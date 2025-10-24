Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCB68CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD2A8E00F4; Fri, 24 Oct 2025 15:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095408E00C9; Fri, 24 Oct 2025 15:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC8E8E00F4; Fri, 24 Oct 2025 15:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE4718E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:28:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F395893E1
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:28:54 +0000 (UTC)
X-FDA: 84033995388.04.3AD97FD
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 00FD6180009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:28:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hmbbVR3j;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761334133; a=rsa-sha256;
	cv=none;
	b=TNUWkO8IrFI3vYntMCEIHHbLudsu2Vp187GZ4+i3Grb24tNN/NWMBdtHG6ZDJMwiPMs6bi
	IfiNfp7X5BKj+m867ZVQFtfr63ToqOotONoHfiwkAQpLcBrLEGaIxmDC11EM7o4umcLJ9y
	H0eGIXVHd7QMjpo4XCemVt1vv7hcak0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hmbbVR3j;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761334133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=G+EzXJSaC9FZesJJ13eYezPswFqRH1YsBPLx3UZSy1o=;
	b=VPI0wp+wSFt45xIvIQfY0OGThx/2njTw89A+wqDl/Km9PKgaK7/lZBUUNQG6BWlXJHqFjl
	VIoT1TESVy47szxExGRTO1/a9Lar7GY0u9GTqHAje6aX41e+ICUinJO0xyCvWWGcxegLij
	ANtRJgf19OvUKirriPkGsI2cszCOTqY=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-88e51cf965dso321695085a.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761334132; x=1761938932; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G+EzXJSaC9FZesJJ13eYezPswFqRH1YsBPLx3UZSy1o=;
        b=hmbbVR3jqSyA6rztAYb9Cy7wwevii/+C4iYiYDoEHeqhxJvLUvT878SqLxZNHh1GFh
         SUNyZskF8jVVWtUr6D7ZunI2y/jDABbS1OXitd1IsL7cilSC4taNByF4/gxlaTSg6+gW
         vn1iE+IuvBFcGDPZDb+r1fQP5oua1ao7uZmXNShefNexbonSsDrlaZtQnlqqrwCMbaZI
         ph9EO7equTM0wLBKw3eEJCu7scj1Ha8Bxd0GJPzpcfJcA2C43/wrxJmcKfhvuFWD7vP7
         PN0p3+DHIPHO3Ohs6yUUtyJe3uO5F7m5VSTw5kNTYcB8yoWO+auvA4CcvwHwnlC4X8Dn
         Wp7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761334132; x=1761938932;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+EzXJSaC9FZesJJ13eYezPswFqRH1YsBPLx3UZSy1o=;
        b=gRv+cH7xhPpVQ3F/JW2J5SS+P3yyGPMfdh/exmimgCDex3N6cyLPvF4ry109XnA5nv
         j3q5py9naK7E+L2jwKci0ncXSUw7TQvDZp3DBG/+Ut75yRVxn3SpUEHrqdrIHB01aaKs
         VVjKjHpXpViOqw9wcPvtqKaNIHfReG8ZZJMiA/pYIRNo9YOAKxnIsCqHThdGa+6KlcpZ
         BL32+q1Lzg+3xTZ8A+3nUH4Cwqazvik0CkLXUgC8JrExdoP20JbaxlR6OT9TJELBNm2Y
         OyqT390pWzgVJVHHxHc5RXnPXTzSfUGw+oP3s/OltESabeepAMm2i/bb500GrvSk6f3W
         ngpQ==
X-Gm-Message-State: AOJu0YyMvmJk8J4GCcbHiB6JU4I07Ka2bFreq5LO4BH7YmVz9PeCYyvk
	zzW86XSzYupr81YGesM2wJLFm9vaq94ERfjJN46kORyOSk105ovqZyU5rXFTrjGG9LiLuOL3uqT
	8Gysc
X-Gm-Gg: ASbGnctU7wqafRFbSBPUY31m32d1lv8577XVnWavp4ubMW8aSZ06lkLy8azlUVNf+34
	YKHjoDNSocSzXojpHjg/I1kpz/pyabXMtKFWaetTLkrS80Mf3JdyL/rlKXs94KZBMy7cdaymtDq
	/CvPAt32hzFQG3iQcxFh4uKsCtti1wJCYu9V/VaKCpKLW1UzhKgHleG6z5+fyzyLmou0MQ6JBXf
	2u63O1iN1iFW3Jlpf9ZKVjoqGtUeI+FHHB4ENmpNu+O5Sh2f8wpDKHQ3b82I/3Af/rxuWR7Z105
	eau2HvXZfiF0anLhUB8f6qT9lnoROkpOUQfMJSaAFa/DGOYaWxUYeS4PoXAv6ezE1fXvB7V7X0s
	ZXWsiLT/+43Z1xbstFL6jxHkX2bamowY2e4j7SiHi2ha+WKMoCA0UpkdShlESiufMb92t2xnewp
	qAJftQwm7oaoURYXN/XK6FA2FNbqTQjaw0ugIYH4iEcxDfW5DXKk7RR2T3Y+E7sXYC
X-Google-Smtp-Source: AGHT+IEPJ7nVMn0D8TuLagAJ4ryAScORRQC55U56zQKFV9s7QmiDF4aAPmvidtBw7n/btM7IHVS4Xg==
X-Received: by 2002:a05:620a:319f:b0:891:c248:a513 with SMTP id af79cd13be357-891c248a792mr2915298485a.66.1761334131761;
        Fri, 24 Oct 2025 12:28:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89c0ec61770sm441930885a.26.2025.10.24.12.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:28:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v3] page_alloc: allow migration of smaller hugepages during contig_alloc.
Date: Fri, 24 Oct 2025 15:28:49 -0400
Message-ID: <20251024192849.2765667-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: afuo1jc3apgdg7ep64c1wmm4dmj9qehb
X-Rspamd-Queue-Id: 00FD6180009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761334132-810455
X-HE-Meta: U2FsdGVkX18qtuX/kcoz9lsWY7+cYEB0fmiiY59LvYLwyfSH3r003xuz7fAlhXJPRexVaLJioBUvMhLFlVPiTz2iSJIrjaBLtXycrU1sNoy7MNfkcy0FR7sl1nau/Nr/oCk410OHAZGvz4spFK+irr4ELJtLCSsa7eFBRNLU1ny/HyJ5xx1o4F88OG0TUSZCm5+U7jo2KNnA0xs7vNOvmSlybXMT2/eOojy8/xuLBoAmUtXAHdyGtxVmOD8l2wG8nivDQtr6o2SgwAV2b+hheUMDAjCclsktW1gP2EGRAUVMD8Sw3aXet5hWKesz2zd2oaDg9Lqh1aqCWMZl6BiNeDBrwGIiIJPgKNbEj3xU6Dcd4YwftEhGj5UWnk+NEHu7eFj73Lftc2E3c+HSyq8lV4iBxWhxpMwDKHrmLUrb9DcnyXjL9QmtetdXbIIF+623NXqOecbZUE/Gzh7AMnnjNb7ES5SovLOOqO6FiBaQSlPR/lNJp659Btxp6cBLtUzoWWb8eyLCK1MNBMDx1sUau3nlZPl1zFMKBrQjq5fLp34wg/GreHsVtIyAhXDduVzet+aeelePUvFSnVLCn/XfCCZPcGh+NI4dLCNMoIlP0BST9VPrEq0CZgWRo0PR9ywZxeyIuPl584+zRdI6dnNUJjY8GbvkzPo89eBrlsDgZdHG3vPDJN6mEB5Ljz8PqmpckHYJK9JAmwRMcCEW6xzOOl3d0o6ECW0IahImKoICafrtTwDjGW7CjsVEcDVShGgUwZiGNa7iUusltkNBnDIe1URzu9ELCP5S6Dj+P++LAuZwtInTTT2DF2E7NQxemAaqJn92QiWWkugvdpWrIYxhEFJZJFttszPI0kQtfCkOXdypsMAYHmGuEChsgH9r54B4CDpM7tSRt0P6WZhvhuLF1a1W2HR0vzTSwcjs+965jfLQQpVVD2VwXFcAHjrfUiYf8Q5b6g8gi1tCKdfUAb9
 hHqp/Q/Z
 eCDoB9zpG/FUZVwkga7I8CoEmQfYX7rJ6H+FeePZnxT28IU7VHwn2bsGIHhjDCPXDSt0JK+SMQVs30Ig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  Instead, if hugepage migration is enabled,
consider regions with hugepages smaller than the target contiguous
allocation request as valid targets for allocation.

isolate_migrate_pages_block() already expects requests with hugepages
to originate from alloc_contig, and hugetlb code also does a migratable
check when isolating in folio_isolate_hugetlb().

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
---
 mm/page_alloc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..23866d4c26ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7048,8 +7048,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		if (PageHuge(page)) {
+			unsigned int order;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return false;
+
+			/* Don't consider moving same size/larger pages */
+			page = compound_head(page);
+			order = compound_order(page);
+			if ((order >= MAX_FOLIO_ORDER) ||
+			    (nr_pages <= (1 << order)))
+				return false;
+		}
 	}
 	return true;
 }
-- 
2.51.0


