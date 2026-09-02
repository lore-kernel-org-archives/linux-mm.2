Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DA4C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DF66B008C; Wed,  2 Sep 2026 10:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317086B00B7; Wed,  2 Sep 2026 10:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5FD6B00BC; Wed,  2 Sep 2026 10:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E81CC6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:20:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52AFD1A023D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:20:36 +0000 (UTC)
X-FDA: 85169032872.14.9D46F29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95F6F100010
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:20:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lS56OM1A;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788358834;
	b=0rgLtZYExzysF0tSQUEAd3uuohMkoDUYC6Y1tgYABDCzUDboWG9L+MiAUJUv7UZZueegJD
	3G8OCt4+h80Z1QRchiXFFrlfEQyLdzNel/sTMeIPZRY/RzivAFd4BmghfTjinWh7SYJ3r/
	2iF636cot+ngJAf5a79o77k0zY1302U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lS56OM1A;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9agrdnFdQejK6PBezRLA9LFhJ3vTbvnbf3qpO1t0YQ=;
	b=kSm+9ZsrQ2iCXr1GJG3B9NVZGyy2+H9AYbXY54RdMUrhfjdmgU8+lhT4JmafQO2XEy7YvO
	YS0Sqtb1+aGHRDxSPT7hvh1XdJQdOZ+nkr1LsBw2ApEsH4dDMNsgi0W2M9Scr+WUK8YoPu
	n0EXgiVxr8AHWi7GgjSCYdzao/g/hK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2AD7436E9;
	Wed,  2 Sep 2026 14:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F0C1F000E9;
	Wed,  2 Sep 2026 14:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788358833;
	bh=G9agrdnFdQejK6PBezRLA9LFhJ3vTbvnbf3qpO1t0YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lS56OM1ArhNGYcnivIJ8y42C+SAeW77H8php2AuzL42mkwz9TFZniacvAzL758sgx
	 lDlgchQzzPNr3kkx1QTQ+BCRnRhx23dSzcBvQXGriZiw8npVqxHCZOHCbIJVLWIGW/
	 QyO+k/IV6rx1dCwvdbtTdoMVOtJbPa7eDMyinxxxkx2QrFeyyG6ROfOoGcJ5Zlw8P+
	 qumyhIVJ7wM9PZHhx31G3ZlbGXMWAvG0xIsdfMIXzXbzkmuSRFruqYC5ZchHsobk1Q
	 /YhyP4WDLEQIzcKr8OrQiPHB7QpI4Y4nE3dbQXg+c/Fly0MBzu7casTiEuzSnlW9Jq
	 NFNuUuWzCgn7w==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm/damon/design: fix broken :ref: usage and a typo
Date: Wed,  2 Sep 2026 07:20:25 -0700
Message-ID: <20260902142026.87554-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902124550.31175-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3o73jtyki4uyj5kfzuyraf34ap8osjko
X-Rspamd-Queue-Id: 95F6F100010
X-Rspamd-Server: rspam06
X-HE-Tag: 1788358834-847562
X-HE-Meta: U2FsdGVkX19abzUPcna354/jEjdUv4OGDXalflOL6OHNupN1AQHkhiGakWbPHFk1BH17cIc2bDCC+YF+dJK3C/oEHhYA6CTscnQt0WaB7sqbdQoaiwPh4IksBqedqn9vTlC0lMR+uMmS/tCadQGmzQb2wCcqn4ca0M3MwyApS0FJZfs+6aLR8bjGdrLQjUlGM9g5LpdzOVvAKKv5zr+kVHajXPu0WS6QjmV259VHahbrGXWtPe8kzuvjbvHqhwfnZjbawe6IeI/b1KLaysP17iFtaJlap5e67Z6P2tyONPeGX3dCZNymUlfFkhO4AAUoZ1QOZLAHk7ZOKq43aZEygC/NCwkiGfB3yt7izVvagx6vyealiM49cnH7uL8nbvxmPaddGFqqI5GccpGjNmGfTcm+pwEiHYwUc7N0mIGQ7jrsGztRnzljkX1f1GrDXnNsICxSmDsqyFjJjZt81VidvilCm5f5zwydu0GXc9rdCKMUcsDVJ4zK5oHN+3T279WpJ/SYUyQej4Grdo92YIP6J3Tr3lnjWhGANSZDBNtSSzMKawNdaJgtDD9PN9uiWUW1BkVlNm5cyUj+cQCfpJMvQlPL4d7e+bIITq9FPAtkxyyd++AVieuoLZAF96IV4c/+DRRXQrSH/GuZtcfvVyR7yFPkLwOM28YihlvXMlakk3J/LCntfqYdBQeu/aAWiwGySExgP+GrhwcxSsNUxcZPh30Z13x5ap+7orAiCBhuiJ7BZknG4gIbaUnI+Mf6VWz4H4NDdx+imX2DRggRhrfO7qWyO7oRIrBM6OYV9thKu3K8sDqKHdOjzWeWc7fk3XLVLjVFcVUZFFsWSCeBaN4PsJDGSWfyXbJQRj04fkiwHPT9Egzs4WJpUktzy6cGpmMEx4Raf+RbtgmoKlt37tUB5KeTzSL88PT96Wmwvi/VXo7xDS7eJ36J6ZbOyML3Ih/gdZG8rwaIkbNFM1i/PYW
 CIso7re4
 T+o1GwgIY3j3eKAYJN4pl4QvIfZkTGvIp9KT2iKJ9G3S6ChfUlO3f6tBvxC6uicsY+F0a9DLSij907jJE/BUr0hStlR4IlIqg9QoCz9SdQQ+l9F3s5RwNuJUmwzkFV9smeb7xM3ROrfJbexvG1axJOLD4kF0NHWpXgHuVPiIy2oxZWNLFcF+wNZ0hls6/9YA4WApvsPbY4mAiOUbz0yHTIWM0kEoP2JuV53vBCJs5OXAuV6AcAJDDjKD2IxR9rjYWKTNVig5ywzp0C5g4r6Oo1z4O0p2q+2IK+muYZNiRJJdGrInrcMx30+kJK4Q5/jQ0lie9AnVqSNQtRVf+ZqH8CEDJAdBKJrFEBEh9DCU8psz3gmUhf28AuhJMktMUDjOfpY95E8yp2QTNphlfIxCvC9Tw2YpaPOX5nnSQ0DIwJLOWA+Zc+tqBOW6rCyZhZsmD7rZaoCzMJUTsGUEuwVir5eVV+xcqUYf6rMX4UA/fdrSvQjWvtx2BiyRP+hKq5KyFLLx8PBfIrctyT3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
I added them.  Please consier using get_maintainer.pl from the next time.

- David Hildenbrand <david@kernel.org>
- Lorenzo Stoakes <ljs@kernel.org>
- "Liam R. Howlett" <liam@infradead.org>
- Vlastimil Babka <vbabka@kernel.org>
- Mike Rapoport <rppt@kernel.org>
- Suren Baghdasaryan <surenb@google.com>
- Michal Hocko <mhocko@suse.com>
- Jonathan Corbet <corbet@lwn.net>
- Shuah Khan <skhan@linuxfoundation.org>
- Randy Dunlap <rdunlap@infradead.org>
- linux-doc@vger.kernel.org


Hello Zenghui,

On Wed,  2 Sep 2026 20:45:50 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> The Statistics section refers readers to the DAMON sysfs interface
> documentation for how to read the statistics, using a ':ref:' role.
> However, the role name has a superfluous 's' appended (':ref:s' instead of
> ':ref:').  Moreover, its target label 'sysfs_stats' does not exist; the
> correct label is 'sysfs_schemes_stats'.  Fix both.
> 
> Also fix a typo, 'frequenceis' -> 'frequencies', in the Adaptive Regions
> Adjustment section.

Good eyes, thank you for finding and fixing these!

> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

