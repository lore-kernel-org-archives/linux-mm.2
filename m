Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3C4CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 00:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6846B8E000A; Mon, 22 Sep 2025 20:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BFA8E0001; Mon, 22 Sep 2025 20:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571688E000A; Mon, 22 Sep 2025 20:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4578E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 20:32:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0978C0793
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:32:00 +0000 (UTC)
X-FDA: 83918637600.18.0795D51
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id EF8161C0007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:31:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hrhSKBAv;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758587519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=nuv5RSx/si7XE0ypaIJ9uiu0NBPNF2TPUH2vaRnBsJY=;
	b=niL8yiKHBZRSYy9mpfH+sqAkQCL/o9KwHQz3SWbRB5VtBHAfyYJ4d0naarsN9mLCIS97SI
	LTZZ9ZVR3+0QZQR4AbiJTJq8KWSJdNFxEpb7bA02uwhEP5PQ841XbXzU9eQ+8J7ti2to2U
	SGe+2hzwI9BPUAnOw8OExcuY3LiOl3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758587519; a=rsa-sha256;
	cv=none;
	b=rZElEgd2iG6+gIMaLIVW4jb/EDdl7PCA0rgORjzXhni5B8a+pNPqmadZdPDmusRxE4Aiej
	i2Xm1Yuqfmb0Tb5DrhDf+kRjczSA7r9P6od02noR6h9RPbTjEQIqnDaLQm66nhSFUOn2iW
	aiYCBZ7OekyEZ0Hk+za4C2lk595K7iU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hrhSKBAv;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso7873154a12.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758587517; x=1759192317; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuv5RSx/si7XE0ypaIJ9uiu0NBPNF2TPUH2vaRnBsJY=;
        b=hrhSKBAv3xcpyar8GPFpputM0XgIMcX1U2iOfk8ARtgsL5IEugbd9kx5YZmbp1SVID
         wjTQi7q7X69E3W7VyRxQtUaEq1E1U3i4WR0ylROTCZq9ONFK7pfS49Rh5E22hlZkbs45
         8Oo4E3hjZSomeIJqkzNUNKt0cb6J05UUEY2sTo/Zggrq/WW//g+MQl8CpbOzV8b5x6VD
         gSK0gFP3VW8JFcz3OayXAN2wSw22SUQTwxW1hF8tkqbnHr5uLKQtgyLyufnO4jXgXJo4
         QUGJCSGRvjLKJlbshTut3GrhJsH2jJlX2qTS3NIy8HbZBnGT/qUodUT16E5yVGyDWkoI
         xxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758587517; x=1759192317;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nuv5RSx/si7XE0ypaIJ9uiu0NBPNF2TPUH2vaRnBsJY=;
        b=Rncl+3wE6Lc6uT3O0feDu/tokF00DFhBmtXQjW4iALYsNXal65l7HppInNFRucQrZS
         hkPdIRTYfWXeLDzITY/KcisbESkPA96A6yx+kAWujZ84runeMKdkT2Tf/CyIWnmfLVBn
         iaxAc1iXbVrmRlqaHZmsLY6kTZuKQ+4Q4XXsP/alvk8sYmftbDnex28UEsv4JIteG5Nt
         /RgRVVT5ZzzBwug7wDI5kgpW0ko/CTUCROtKTu4Es2pD6yMV5zJBU4M7HHrf+iexZ7Fs
         +8rfM7JQv09GPNR8BNJgyPccupF0UAFcNB/itCZIDM6L2ijIXrDc6sLcFlzKYUnmp/OC
         aFHA==
X-Gm-Message-State: AOJu0YzsJ5eUpOmhr2zoUopvWNP7fI1wbx5zKypaOu/HVqTxDUqiph1I
	3TsodZIAZZcPkYJX2LUUdSyGcby3pxapAYGWUePV02LhEOGJjnFGVbIN
X-Gm-Gg: ASbGnctpSWpQOhSFC3xCLE/oV6kzLxWg4TLxyvCVBlPsz2lGB8g0bKzII6BOcnwGwZ3
	VrOMO4faye264FFt2cCnAFIcR306JoOQFcVr33/xmcOMa/gB+vlsV2NcqS9iSX37vH/X9FygzmA
	XOzv5BsEWyy9gE4MMMCaJAo8UWNoLQtnT04LxNP5jo8BZvRvh3mHFmGKjdj3U1qRRo+NVrqveUK
	vJh+D/FvMIBnk6Lpqq44v0lULDRxa2ZRSITD16+UDWJ73pPuKxt9eATULDfYDdzji4KP9YtHFf5
	HH6XrzgesH7eJFnSpNpBTiHQg2wz//M6RQhIa2Clmi5/MoEz7kfOGTM+eEurVahxU5JdmzaG0fc
	vNAIbmJ+R7eIh93WM4oXEfyfDl07tMdou
X-Google-Smtp-Source: AGHT+IE3rFKqzJp3+T+GICLer3YUDBJycYzY2DLt7TaNzUu1fgubAU0bzYg+JbltO3Q3k+3WIJE3ZQ==
X-Received: by 2002:a05:6402:50d0:b0:634:2538:e569 with SMTP id 4fb4d7f45d1cf-63467799f7fmr461678a12.1.1758587517168;
        Mon, 22 Sep 2025 17:31:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63469f30772sm142787a12.22.2025.09.22.17.31.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Sep 2025 17:31:56 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	david@redhat.com,
	anshuman.khandual@arm.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH] mm/page_alloc: fix alignment for alloc_contig_pages_noprof()
Date: Tue, 23 Sep 2025 00:19:43 +0000
Message-Id: <20250923001943.2479-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF8161C0007
X-Stat-Signature: om7ai7oj1xxzuc7qq71psczx6spcsbfz
X-Rspam-User: 
X-HE-Tag: 1758587518-875644
X-HE-Meta: U2FsdGVkX18QK8Uwtx5VtcBS6q9vPe/uFHNUdbHoOTWvU3wwttAgcB/TpV1BYEN64bp6Gsb3Y8xbwQCBoYGP+32DmQMgQjwSJNhhPNDZWvm8jdSYCYo7Sx19v8I7fuIey2JUznL+G8jM3RU7vp/X40PzLGg6S9yA9KQOth0f7yJbTFgs+IvWjCPtSMSJ9YfH4NmFs03Mmt+nLnzHb9xlu7cTM5Wh7LyIq76UT9qXVIMszGhfDlRMumNlkX/C1QCpzEtXDOVe4NRNIYvhwJMkxFdWWdAEwarQw50hdyp6AubtQR3TVHmYbdA2RfNdnk76ahbhJhF07TrhoWEm3IQgt3tJdr/+4T8wdBupLROyTv4Nhe2Z3DJo/SQ6tstkzCgqyUVMVKI3pz90kpWEPbiAtE1Tv4TE5DjNqJpvNi7SDCWiwTXDM/PqFzzwApQ37e53VGeuAl03hXLrUQsmDzbCM6yrnm5XeFRCEhqkxy7RAgZPr/ackTKFwVWTzci1+LOm/gcvfBWy5izEANhl3SJ+6nDAgnfTort5/aDvoTcAPcs+5WpJ5nQtK3L6P408S9kKPq/kQHm++zjArdlB8zCFSSZPI6a9z84WYzG7dhQhgr/HYI3fEznqg17jUlANFDgYB9ehItzBYDf5G33WDy33ANzkTfLGrZ9XL+80Xkdd2/eu+IUB9Q9pj4Aj029PZkcpkcmnm7Ot8IHi4E+WOBwUVg7l3NZ5eYdq6XFDkHHcvH0rFJ9cwXRZY6VXkm2/bKlEYWKskygouqWZg5oxxfYyBck2v/4YUY/idWl++ZtS7Gx0RZlwnxDM6Cdwa6kd5iRo8v3JsLftr22gUyJE/f4BQPn3a3mPlT1cnRnboUp4cupundKzObzvS3NGAkny9usTI2nFxdgnZqe0khjvnrqdnrE+v5TFiD+5+Gt18UYnJ86jnbe1HeAZYbXYpGl5S/L9WamL7nyRuoHy+fedRTI
 d21hXMB/
 7b/A6FHw/0Q8FLwNccR2gqvCvoJAtOyFfv2uJirPPOxmgnglRq+i/6F87mhxcsXEw3Wz7M3tVeIJKskWLUHpUUOyEAre3N7cCO+MRfbTyIBTlpRTY3tTXmdir+83tvRPmAztIou5QBMAVPQkx8o6quTFOWzIg78FFQH9gTP3E66hvYHGRcKyKz4M+/+LXV/BRYWY37waSJrEmQ9DcZu1o9rds67383GnqgFSdwvANJVG9qorF/YjPf/6d4LT/DcZLm74t5O9BEuhdi43yToZnJUxjYJjqSep+hRFY2lYoyy9PGF59KlO/IeugLxO0whS/UnJqQaHc6T+L+gvFoOtNu1Tfbuc1s6TIfByUwsIzY+olxPYJOXLOafhqlCDighI++KbFsxTfihmRTiS+cAao02KigxioWmKUdKBClgHHtJeVq1SDyYMipysMV2UpDlppWr+drm4VQirnglrf3wBCqewPxeT41C+f7Ro9/aoyKlPXOKotL1y4UgQFmQxI1BK0dzg1Tg6H9TR/8HpNHZ4n9rNF/dfQXdZIpa02LLdsqJof8/IEh7ZXMnCcSWSjRju4mnu3bKEAoIqUc8BQ6lYhSjKlqPP7Ey4//QFqglAL0XycGYIOXkmo5mdZJrh8Zp6EC7ibd0x+GzBYaJkiShb2UgKZT4Vb2eIpmIeU9MtuCZBwvkbBRRMWUya8K7gmxxvTQ+vXlDKECAOTW9DHu+b2sldCCSY8sRb6kJvqolKUX7gedu/tDyvlFZSplYR7izbKkjxT08Ickk2JLQEW39mRXCDlWmnG4OLYQ8oM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
introduced generic method for alloc_contig_pages(). But the alignment
calculation seems wrong.

Since ALIGN() only accept power of two value, while nr_pages could be
any positive one, the result is not defined.

Use roundup() to calculate the correct alignment.

Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a1bcc1e003c7..a17a6014e3db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7095,7 +7095,7 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 					gfp_zone(gfp_mask), nodemask) {
 		spin_lock_irqsave(&zone->lock, flags);
 
-		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
+		pfn = roundup(zone->zone_start_pfn, nr_pages);
 		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
 			if (pfn_range_valid_contig(pfn, nr_pages)) {
 				/*
-- 
2.34.1


