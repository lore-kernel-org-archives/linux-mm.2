Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFEDDE6B26E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291EB6B0088; Mon, 22 Dec 2025 21:55:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F8D6B0089; Mon, 22 Dec 2025 21:55:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120DC6B008A; Mon, 22 Dec 2025 21:55:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 021796B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:55:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A7388AAD8
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:55:08 +0000 (UTC)
X-FDA: 84249219096.05.2B11DFD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8CECA40002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:55:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c4QO2mHI;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766458506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tO3PGXcrbO3yWzecK3b3DT9nkv9paSQm/vGhx+nO1p0=;
	b=JbTo9Ys5J5RBwlUoKF6Q2WV4xi5UUumMTcnf9wvWCXhl49g7PInc999K5H7nof6JujxRpO
	SkD8wmKd5OuppvrhnT8wrcYE9fK2n5hPFl56xndUnAdgUHyi86mq/90QT0UFEwP01jEA7s
	ofhMM+in2s9G2MQpSz4K+kH7D1mZgsc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c4QO2mHI;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766458506; a=rsa-sha256;
	cv=none;
	b=IcooPPYPKtMtZgRu0yNOSBRpED8pfSKXW1ToPtPGeXdFWWmQ6sDscV5t5jIysQBkYOMiSz
	R2aMdUHdi0lMZh+KJWaWHrGSrEjwqqc6ZxsVR0+0WVnbDm8vOGmVquvOw4zzn3sw0xtAs9
	cv5KC7ORFFoCVhOBK3CT1zvDBJf8cqM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766458505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tO3PGXcrbO3yWzecK3b3DT9nkv9paSQm/vGhx+nO1p0=;
	b=c4QO2mHIb3z8/WCuw5R2nS5w/Yr4kk3TEyFLl6g6Y75AacQw/6tH39c209xG+hMwnvCEVB
	A8lbfYz2ZuHNqruaZK+YiEHCwNjYJY123IhJdSO5S1lvjnsOfEr3p9H7uIgbj+CP9DdnnS
	fD6S+XbhjyAq9oL0VUwOQHQ6PZ6dywg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-uGCB806uN22TqaBQK8HCgA-1; Mon,
 22 Dec 2025 21:55:00 -0500
X-MC-Unique: uGCB806uN22TqaBQK8HCgA-1
X-Mimecast-MFC-AGG-ID: uGCB806uN22TqaBQK8HCgA_1766458498
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 223C41956054;
	Tue, 23 Dec 2025 02:54:58 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.13])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FA4719560A7;
	Tue, 23 Dec 2025 02:54:49 +0000 (UTC)
Date: Tue, 23 Dec 2025 10:54:45 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v2 1/5] selftests/mm: fix va_high_addr_switch.sh return
 value
Message-ID: <aUoEdbP5oE4q47qR@gmail.com>
References: <aUjJ0OKZajNNoQok@gmail.com>
 <20251223011532.4337-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223011532.4337-1-sj@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: j6tdxys4m5qnjtkxb5sy1k8roy7wsis4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8CECA40002
X-HE-Tag: 1766458506-825759
X-HE-Meta: U2FsdGVkX1/6eO20lxdHfYyqNT0NhBbNd2g6P6xPfX7/i4yQfZt/T/SYAju/Ih6eYoG4evQSIZ4Lin6WsaY+kPmdP0UKepUfQGjOpycifTS/qHE6n2HtypiF0lQ9JmZQpwk8txQCpHXZkIcg3SU8cIV5JFvC0vO9xeA9QfsIgqTsiMiMn0fvEHndWa9y8Sh8ox05uZB9b+OQtaXqSfL3T/sCeujlLG8rdvf0mZR3tqvxYX1f5Ave3YBHk5QRps+1d4nrowbGfEqvVz7+AX4Nd0w5CppXAtsDh+YfuR2fGG8cdIc0T0RkmV5nTLUZd0YMpgoZK1/8FuxFpPUNKzWVLlz/ZG/+voSVrM+r9NP5v4TEtPGzd1wVrT5736gR6Yvvdi5hLNwyga5q3HGzpkoRIT0yFGEyJ4F20jl0xJ/+woMQIiKl5cVGOVUTvbnDhN1LzonO8CTQtgNDeOAgvC59DnIxsjHt8ui2e3Fjh/dq96Q9z427l31DAAXD5P9A0y0inFhADPJt5xzc4gXY2nt55QumKM8erirfnEfmX5FJjDElXL6Gyd4kLi0RaGrETBW8jOBFNkh6mTrmYCkREpwSykZ4EKM8fdJnSXe1Z4QPQfYhiZweFj6uqU71vXRxba75GR9C4MMtl5IYeG0SL1SKxi/2QOQhgrwGuGolFhMlR2Br0LWc9D8ZyJEkt4TS1/N/8Kr69GC0TQjGt7//T3ziIuH/+8Om176DGJvsy+M3wDz1ChScZiidlvtjQflWG+t4wBAv/WBxoTl4CFmJwsnbkfrBbuqhWCHEp8dk//Y7zU0ijsIaDWBN4PvFfFpk7zQLD5fQV/VEGrjcN3mTwNCTNvJNkbnZKmbF1Y5pzM/rXVVeMaV6Lk5Tq+v9sYzov8Yk8pgUgLkKNMGlkHunRrEqqUvmuL4ovQY587wkIMheyafpGd5ner4gSsPOkQqOas2FM37Rf1VdhxAI8ylmUNN
 dPM5hGzn
 HHRJjnonM+xpJmRX58r3d+ULs6Vtm7KrmN2DQMJAFJq8ax3kQZsC5IC4BXpJrLyAX4PGPoiISWh4BANViknch97YPXAMdUKGvTktcVg7W/oXSfvcCRZjkQysxDtooJJlcrM4J7Ws0spNNW3wpakU4CalK/Aa433v9kLYbfL+ouO507UjH6/QNXYXguvMKmayeuWc6rcKI5XR0fC+t6TfkPXA4LHBgPuIrEAj6dvwZzGgYwm7AoXhWXCjIrb2IAPK62KVeeB4SJFKSwVf2gcLxYOCEXZ4yTyA+gaDMZtNSWP2xZpXfb5Dr9gLsqEbKL6echGJaSE2FZfzqSarfAnHJZsTkb5WZGynHwWlR3rorfnBakJBweA/wz/x2CtDJWU5ZxUdrlmhRJpfh9xp0I3qONjnTlygbGSEYU0pSqcRMba7xB5fctu+6HhP0E7Ku6RkKq0/NywpiDXVXMPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 05:15:31PM -0800, SeongJae Park wrote:
> On Mon, 22 Dec 2025 12:32:16 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > On Sun, Dec 21, 2025 at 10:57:09AM -0800, Andrew Morton wrote:
> > > On Sun, 21 Dec 2025 12:00:21 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> [...]
> > > > According to the doc below, I don't add the cover letter, not sure if cover
> > > > letter is preferred, and if that's the case, the doc need an update.
> > > 
> > > Funnily enough, your series was in the exact format which I use when
> > > committing patch series.  Usually people put the cover letter in a
> > > separate [0/N] email and I move that into the [1/N] patch's changelog,
> > > as you've done here.
> > 
> > yes, I see cover-letter is the actualy way people is using and looks
> > like I did some of your work putting that cover letter into the first
> > patch. I think I'll add cover-letter in the future.
> > 
> > 
> > > 
> > > > https://www.ozlabs.org/~akpm/stuff/tpp.txt
> > > 
> > > God does that still exist?  Pretty soon it will be able to legally
> > > drink in bars.
> > > 
> > > I think its content got absorbed into a Documentation/ file a long time
> > > ago!
> > 
> > I happened to open it before I submitting my patch, and wanted to know 
> > what would happen if I follow that. And it looks like cover letter has
> > become the actual convention.
> 
> I think you could use
> Documentation/process/submitting-patches.rst instead.  The html version is also
> available at
> https://origin.kernel.org/doc/html/latest/process/submitting-patches.html

Thanks! Sure. I'll use that. I know this doc, it's where I find the tpp.txt
in the 'References' section.

> 
> 
> Thanks,
> SJ
> 
> [...]
> 


