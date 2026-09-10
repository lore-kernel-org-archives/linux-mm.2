Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 663E2C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720B86B0098; Thu, 10 Sep 2026 10:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7CF6B0099; Thu, 10 Sep 2026 10:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D6E6B009B; Thu, 10 Sep 2026 10:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EEF86B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:10:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF06DA0584
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:10:47 +0000 (UTC)
X-FDA: 85198038534.05.C0CD334
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4253F140010
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:10:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3YlUNYI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3YlUNYI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049446;
	b=QEFbcGHJobUVymQ4It0zvTZAAr4xKeReo7UUN49VCX/sAhLnzgB3uEWOeoXn90N18mWNZ+
	gMvYmiZwIMZ1oOjU2m07dZQDnAoVJSri8Myl1wHtZ/krTxtpuNzfeTkIa75Xzz7Abp6hP5
	ugoHFnGQ0Z2InT6uhQRlHvUNz3eLcCs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCtMBc/69YQLL/vmB0BOFo8lbp1vfibmleZ+RjFXS78=;
	b=57IW/uI6SpIgVJQGQ7QnvGIfme2ubRw0EPD2P6RCQC9E9+cLrCveOeTEEmiO/GZ118byyf
	RvITvveOYXz6OjLmdROJYzsfESiJjovgwKi/clN+Uu+IPiO10z23qiwpkPbQF5fy/jHmEH
	B+SrRw4QEu232q+UvvTjsrcVABI8K/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBD92601F1;
	Thu, 10 Sep 2026 14:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4CE1F00893;
	Thu, 10 Sep 2026 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049445;
	bh=uCtMBc/69YQLL/vmB0BOFo8lbp1vfibmleZ+RjFXS78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3YlUNYIYpaiM8jp3G4/WuOcLTOnIxdJwv+s+8uTI+kxKX65VwPDppqs+JE0zLvaB
	 NyDL2tInHbN7WThAmEhEtDhajRt1wFhhlIP0DMYqkynGRaURQKkbceSBJoxJ/3ZDTM
	 J6lzpSUHLaap9Dt7WgRzlmjkj+bowVZgXzobSJsWSohOBQjZ/E6lrjUrTQ55tUmUIr
	 hMBJoBiYnzzrCJR8o5kVUjQ/y1OkQCOrwlU38jpAP4x0CyC2YjOdvnevQAo6H4vXqx
	 gV1MqVpoDsbxEuZd+4owbI7fNw3vqsA2KdqHm7qUqimV2gt4p7d6pfDdQSJp9lBwoM
	 vDf49WpFcvzZQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/mm/damon/design: clarify when qt_exceeds increases
Date: Thu, 10 Sep 2026 07:10:37 -0700
Message-ID: <20260910141038.169135-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910112255.157012-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4253F140010
X-Stat-Signature: ucuq6wh93hxkpjw5i9gx7z3gze3abjp3
X-Rspamd-Server: rspam01
X-HE-Tag: 1789049446-861103
X-HE-Meta: U2FsdGVkX19Gd8pP8+bbyQTnyDpa5uzjHyD9e0JAJcxAUVPQhhsR1rpxEzGaOACHgG1Ur2Ta0lZOTtH2ReIwd5rMZYMphCCx4T2TibNgoh8/FGbwEmYDVhdmOnsOOC49Z5hRP9kzNmtC8VgWw688IoGHlQ1RfjV/JAklPxS1GFriH/as6eXXtoFYiSC/ly/u7bw/7M+HoZDuIfjPbTIH9lnXQzaiCsaMn3PLZ4S4zfZge6Hc0NuR4C0xLQ6EW+MzY7L2ymWa3VBUPojOq4ujF0LK5rn1Rk/1vUdAxPb014MWjTT+nyhieFselhFQljYPWFfZZrR0Wglg9RuFo9v8I0i5jue310RgtPrqTo1UmmtJeThbhHZ/1m6GorvSPG+Ia+68bSkwF198z1yKnfadhaIUfGLLmp0TYxTEzsVTt2c+H3I4HhAniWry2KAabZACMjYPewqadRMQsCWuqX8lls2kmZdKVdM5WQJqwthsaxVGYpFM45RAmSa/iezCFPyVsAr6OU45AvGaihKzpWeQ+/d1TyX6OLM1HxJV8TPPz+A47p5gLC+3PJXZS4cZ5T6un9aBD9496aNH+N4CVg+djcgPm/I+tkx7B70JaN9KASf+zSjcnU4kGXiyVwI8PVR1ov8nQMbOTmTUgBRH4VCpik2s2UlG8G/2bA4JyOxf0PZAT8upfoylf/us40TRNCnxIYZ/QdfQy5LX1UQ+RPqyYgEOAxHlcDmDK24SP84yIoTfpbKNYAEJx8pMZYOErLO8LRbOdP47Ggo2jtUNKHHpaqyRh15nzgusfHc958RqWxcv9E5grU0/xlPCqAUu3EHMANeYX4t/GqeHwLqY9uLfpJHbDL5QRWUd/dOJgoIQglkC6oBbo8AnwjCoMN2xnw5yTr368y0ZCPUbHEa1eqq4PncnfCeWOEi2OT8FmMAVfa+j+A5LHiaED07Ys8obnpzxZAwPdKyxM1zjtC0cuwn
 Aw9dI+Bi
 kHke0MuzCjc2/VWYZa9a33NdvlxiPcV6BPvdT4ohOpO+0h4R0dbqqQr1Eh5ZLPyC/NbHrUzCNsey3CT0NxayhW98UVh2MOftfpIsi+GSq0fe/ymIFAHSZtikJNTVV/zulIptn8qsnDdUxvn0GFUMR3DVEbqHM2UsEqle9YGg08FYGEeQp/CReR4wOpbxlXqvmbg84MbI+y9pGxwS+gWdEHSmvevyPnhiqO13Osr+0I21X+bNjJwwnNy2pcUjdoy4WR7i3YA+Pad0Ifv/9uiNS8S+3HBQWAcFHfnFu9oXlA+D8hbjz9CD+0jiSiAK+fZqUs16WztE3/W/yCw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 19:22:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> qt_exceeds counts how many times a scheme's quota has been exceeded.
> 
> When using the temporal auto-tuning algorithm, the effective size quota
> becomes zero once the goal is [over-]achieved.  In this case, the quotas
> are still set, so qt_exceeds keeps increasing once per quota reset
> interval while the goal stays achieved.
> 
> Clarify this behavior in the design document.

Thank you for this patch.

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

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

