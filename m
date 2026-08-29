Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05860C61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18EEA6B008C; Fri, 28 Aug 2026 21:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FAD6B0092; Fri, 28 Aug 2026 21:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055966B0095; Fri, 28 Aug 2026 21:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBAE86B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:59:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 534138061B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:59:50 +0000 (UTC)
X-FDA: 85152650940.29.E171236
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9FC13180003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:59:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SkXyg9tY;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787968788;
	b=JQipQUI8Gn608ZviQjOLf/kyzpEtustnGgFp9uzvk9tJGn71bPksvGt2983q5/Quw1eFc3
	kR3ISxwbQQ2xwqOV9LFWmtE/MoZEQ13L+C0x1ygAc8CNmiXKa5TjRyDBh5/vPy42zdvYAB
	VGSdKMJ8LE+bXWGMlOLS3+ymx1sVCO8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SkXyg9tY;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787968788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IC0TVf+dsTZWglnCyPO0E/mOtnxcSosUkHWaCKQvN3U=;
	b=ukp0mHvDFM+J/1hngZkDSlIbZqPT0M5mZw1zPMM5pNghz1EmGJKtK6Gn2WtDDdgptQT3Mj
	a+cid0T905QkxR4KeD6tHPUZsRkFmk+haVlnLgCK6Wa3X+KjfFDvVTWnrXJObzjiQRCjO8
	0wJ6sp8OQkDrgPqK56LalVC+kYL5N+o=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e57a753f9so154479985a.2
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787968788; x=1788573588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IC0TVf+dsTZWglnCyPO0E/mOtnxcSosUkHWaCKQvN3U=;
        b=SkXyg9tYfD+8hL4cVHSI0n3AvVOfaElUinpEU6s3orxBgvrWKs0XDtf2EZzwCeQu66
         WG8KhE44ACfoPcn0GFq/QOs11KKHtqICNV7rk11v6jA6sa3RKGrlR/057Z7Ih0yAV8z9
         EN8Gj7dyrvCXjm3LtPnTlX9ySGFDwU5Uged+oZqBD2h1dYoV8gqThYeoAHYkxEU8mEHH
         EmlWOUt4xashioqxfPLejeu0sx6GxdiBepnklEEPNcvqJ5GI18KUYYcEzr8kA5q2SdL+
         pZEvowh/1vfResmpNKcjiRebJCbQzJRtKyr9q73XHIkIkd9kfThhjx2+ysMtAN78FQNY
         eRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787968788; x=1788573588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IC0TVf+dsTZWglnCyPO0E/mOtnxcSosUkHWaCKQvN3U=;
        b=AlcYtYpDmVuTvXvVxTugu4XzysXUv6yqS7ZVizojtg209JbP3WF+gqxtGaBkPPLh0q
         WpyYDXJYhD/TmuKALT7K9LVSoaW+s4if1Qyd6gC/DRnegIPneCtpR8OrrQ+aAwm5305o
         tvHKwLNSXC0tesvBbWloEkdRCmuFfyFwt/gQeSAJOZy3zNctNyiyJts3pQuOGr2JHrfz
         EaMpFK0NyY1BdzmZrTniNMWsSorb1g1w+j+BUyy/7PGmR8nFte6MC+kOgfZfYkfaV7Yb
         47nWTsv5vy0Xm7WoMZLNEiw+MQ9tKCDOJ4akaImf8ZQXFUALdcGQiFeTxjoMEN9LYeWU
         gR6w==
X-Gm-Message-State: AFuF++mwGkUo+tF4pIEI96QdSyym3Cb6aehsxnyNtH1dN9sj+pXuEimf
	rI6EzkEwdNO55HdqmBtsZz9qjdLChUN4OOn9Igi53AlK30ZoXwSIlEEY02EdnHOHjmEPyrTRlhS
	SY2KXW2A=
X-Gm-Gg: AR+sD11b338YU7r0PNw3j5ugAZsMR1ExOItYenuNHUPasAU8XmYjET60yC/q5wMx6oS
	o0DR8RLIKmNXZLK2cdpzda1KfQFK9i9UQS/WHA8RWyzNZzEpycE1va561hsvWF52VrJ+Ig4aln7
	636SXFFzsU2UMWrgTjkccDLCYW1YBNLCc14kDoqR+mflFbMDQQQcZyhgNeoECUXaKOIEfeVjQKc
	MQRsu+hF1zpmpqIjOooWrNAzEVyA3Ee7Cx4/XH7NfXN0zNiBsgPRMqAeIJsnCtXo3pUu0Hxdfl9
	F8jIVBjClBSHjAUEBCUAL5PzORHVetTsxkWKF6YJmQn6zBXtvg7X1MMXwmZRlae+ws8mR4dmtDM
	u65l0rNHMr9rka0jJWdT7ffo4kldf1/6TCzMZm0veO9E2sV5wg5FecgMRqzdubA0dAUnyji787I
	jFiligGlSbZCrNe1gz0WMLkXkN4FZVJdB1VvYK+j32BjJ53AeDHj+TQH7HVR19/4auHCFM1oO7C
	Mf/YNdycRlOgJf3GsjfKnSy+xDwvGMk+Iy7OYjcfU+Ot8ydbw==
X-Received: by 2002:a05:620a:2acd:b0:936:dbd7:fcb3 with SMTP id af79cd13be357-939138ffddemr1080911685a.21.1787968787726;
        Fri, 28 Aug 2026 18:59:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9391701305dsm272582285a.4.2026.08.28.18.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 18:59:47 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	urezki@gmail.com,
	chenwandun@huawei.com
Subject: [PATCH 0/2] mm/mempolicy: stop copying state in the interleave paths
Date: Fri, 28 Aug 2026 21:59:41 -0400
Message-ID: <20260829015943.1258774-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FC13180003
X-Stat-Signature: ccoxsu5bbthqoseng9sx8ibxuprr7ck9
X-HE-Tag: 1787968788-541534
X-HE-Meta: U2FsdGVkX18Z/gsOWbZPqBrD4+7XHlILH3a9yE0k0Rk5rA6jFsyQ29xG6LYtyry1sZK2PqRgyp3Kf2C3e47s+ViFYEms2AbZRz8F1TW/U5H6GyvHLVhTeGrGClqtBgBaUJTKTzRdGypuA0xev9av8ncEQMgqg2ygoWujBzJ7dOGOCPicHZ3awTGjfqt60+IbrLg3hSHl4pp1JaIIGHWcdbR1DPdIg8tZjiU+Mub+1InMed7GFzIyO84B2lmrQQjUiAdqNqI27E4ffrkmMLz8DkmNQpja5FSJlipk+FupvgVWUlP6/lU+uvQpd/KlrMse5oLO3CVu+dOc84koiVcgXvYG1jHn6t5PRjIDh630skkQvy6FllgnMLtlDwjpeN0cS/QIvDDvOvFBjj1XymnWgsV+Lo2fYUsyZHKMaeK0qVmHBq7XQZjgKOuqrYt+qYBeZ5BjxS+9xyO0yI8YR4dQ3KQWTW2jWhu10Y3yqU09wtdgzIUdk4LQV4Cpsah0cS2MmnQT5FoP6oT/5Cl9AcKbFyzFqdTba7A3sgFp6CN0jxedcEzh1VEVYetbn6OmKIpVLMpNqWXFuFnTUPMjHnKOV3m4EYutzX8a/1tqvjc8CmxCpyRvRuWKuIAJMggYjFOvaZW/oSugQl+KpIaI/icbMZ/HStseqcDW8mQvBhyyi5WOLh98+fNIP7eRznNRFm+pto6KdyVRtZpb7vN3/Y3QXJZTzxY+BkmhsF2lqtcD1J6UlXkpMZMeUUNtlYGCKzeJ3fbyGdt/GszAtfAmUCxJ6ZR9uoD/C3MpiVemV6CmrXfip7EeD/6ysA1b74guiKBbS04bGt9SNuv70RCzDT1UsJcfG47YGxTdLzwXB5trrxxnGqh5WI+qSVX8+qPaWSpzL9Pvfr/WZDDPoPFOh90LoSx0UlFAtnBnn7n9oCbJFYiuQzAIwau5t1HSIWRaylFNC6NHhC74UV1JVQuYpJX
 8+6uu1a+
 G5Npb39tbyfcsCy5lyGZ/2LZYIYVKIRWLeDDGbwgVhag9Xv3G+52KBD+ML7T/y8YdjbxYMPNUtj0wQHXnUpzm/99/Que0hxWrK/Q64ht2jtcdcnY6UaW+ZatfhLraRe5nT1DnAnbw/NfGr0aJMmvRn6F74xBjb3Y4G899UyhYA0O2KlMctAW9A8RrOAgN+ETWzGR0EAIW5C4lGZAoUznZZvrL4uWJ1eCcMCDVprRWnL66HU/WH7CLwfrBrZhZDUC5ff9yTJ0ejP27DwPFb7b3wMJdrSOn9Rg+yiuEBjIclwdRdzo1LOX7BioKCKzfiP6sNQwk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The interleave node selectors and bulk allocators take copies of
nodemasks and node weights (for weighted interleave) in the fault path.
Both of these copies can be entirely eliminated.

For node weights, use SRCU to pin the weights in place.  This eliminates
a copy and a kmalloc from the bulk allocator path.

For nodemasks, we can operate directly on pol->nodes as long as we bounds
check the walk.  A concurrent rebind can shrink the mask, or tear the read
of it so the mask appears empty.

 - The interleave node selectors fall back to numa_node_id() when that
   happens, which is what they already did when a copy came back empty.

 - The bulk allocator simply returns what it managed to allocate.

The node count and weight totals are read separately from the nodemask
walk that consumes them - creating a time-of-check / time-of-use race.
Just clamp the walk to a single pass (number of nodes), and clamp each
bulk allocation chunk to the space left in the request.

The cost is distribution accuracy during a rebind.  The copies never
corrected for that either - they only kept the code from dividing by
zero and overrunning the allocation request.

Gregory Price (2):
  mm/mempolicy: use SRCU for the weighted interleave state
  mm/mempolicy: stop copying the nodemask in the interleave paths

 mm/mempolicy.c | 156 ++++++++++++++++++++++++++-----------------------
 1 file changed, 83 insertions(+), 73 deletions(-)

-- 
2.55.0


