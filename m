Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC1DC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20AA6B00AB; Thu, 10 Sep 2026 02:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9026B00AC; Thu, 10 Sep 2026 02:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC366B00AD; Thu, 10 Sep 2026 02:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63B306B00AB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E38DD140444
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:12 +0000 (UTC)
X-FDA: 85196887944.12.817384E
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1F947180004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gCL1hTR7;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcVbDCPba2ZtcQZxfLWU2CmbcXM9gR7gcXJIOZ63SMc=;
	b=Y48GYtg7G7+zhVd3EWbqhJN3hcVwYQhtaohyjHzMiGL5KLk1vK7QP+hvYwtgsXMHyfoyXR
	vKrsFp1rs42n6bzFgrLweobc33fZLcizP8Kse+XJOv7kwTrsofu/g9oCEJTctCTYcoIL8c
	BPxttdIqwlRW2Qogi+H7g+i6XG5yPas=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022051;
	b=ATwdl9udpxsU0hrwZjaORmdGltT418Maj2hjk4fiIOoUxGPhfXjOLw4FCEfoT2k/GdDYZD
	DYSuoCtzjysPAv16Uq3XAICpuJYFknbMhwKi67tgMcUMoIAzl6JSxACRcI8OmZhgR7JMlt
	rKNidhBul98o/NA44jH95IO8otuMBwY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gCL1hTR7;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccc02279so978954a91.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022050; x=1789626850; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fcVbDCPba2ZtcQZxfLWU2CmbcXM9gR7gcXJIOZ63SMc=;
        b=gCL1hTR7GdoS6TJDQhuehxleTz1eUR4ijCvZG+x8EI3MoH/1YZo3a2O6rEurMb6m/A
         a3EREfhaAFqBC8Tnx1S46sIBdyZ2aELyyQS0iM6Du4sX/u6NwHEE2wwVurzO/5zUe8dJ
         3NaOkcIlJIFlfNx1GrFu79Qxm/zXBMZRnyNKmfEi4loUxHABlmNeVJ9rrUUknuxOKBIj
         vFxBNO3of02SruM4Q2xpZDU5jMqteFfu0LH2S/go8x2ysieqEa0MrukOSRnSLRTXcNHn
         XDTzEBRtkDN7wa82wV99KgHPj8kXEilrVuR6bBECkGMZMcq42bs1emY+WFBosehAlYmm
         SaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022050; x=1789626850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fcVbDCPba2ZtcQZxfLWU2CmbcXM9gR7gcXJIOZ63SMc=;
        b=KnpL53qKoZ+2zMb0WWO1wxUQlTAA/g46ypI3ZFIHmCc3MSV9mNes/AEzrsIVbE3Aew
         9RKZHdqn0wineX0jqFyt1hB9rvdUclomnlXSYcCC30OG1VK+k7wm8Y5/iqzvgAInhisa
         ULdlpMn67NIuF7LFkTZ5R0G24h/XHARyMfab3VCLUCQzL4XHNxDghNXhEf7s4xqhuh2w
         Iepgx9gfuMbIksZ8/uwAYGxhWNdaVy3HejkAXG83obb5nQ7sN5cvQ3Z+jQWxCeSsU9Ab
         EHxVBWBFHCvk9Qthoz6wW0BmScYLFUG4SyEuJHhjurFpCxlj5KJX980PmSYtf/RmPk66
         37YA==
X-Forwarded-Encrypted: i=1; AKwUvBwLMsRKhm1041440eW7HoQ/RzhSlunx1bYZbn+az7ZXA5cEls9q1NeFlyYRegIQpGXldJ95500wtw==@kvack.org
X-Gm-Message-State: AFuF++kCGDLKSPgne2SdbcRIzUUgALn347C8KBcNNCDOmdimkZwrVQG2
	xrlMRP6V2ORsINp+fkXe8SYge+PdaLLKsMLfX4fyqp3I6jrhndJnh0QuKl6pPfjb+OA=
X-Gm-Gg: AYBFou1PdYdmzHOw0crulyaCpdENVUb4R4bEXCuQnhuOeqfkIbxklxUmOabG2VZbdxb
	/JJCGzNq1p6xWvVim0ITShiKxsxZzoJE/IRLS+uPHCjg15j7J89FIcpZE8yAJkPeeVvMCjfshHd
	IxTdv4JDjNSy0OjwlWrbd5M5Q9ksj6sj0zSfPe6bHKDzPnGEY3BFgnG/Av0LFuPm5yLNYha/wl6
	fScZFf2X6SgcNJIq9OYg2AvdO8+FphG2AO6CAGShYRXqFY0YuhP3m9QMeApkD0E4ocx0IC3aMuo
	8MDE/Ufu/gCNDx+zHQkryZKoqBQZnibyXbTxG523hAV+5HHlUd6et09KncEswXzNxLTytsxqJZL
	0HKbRfE2eNhBMfxky6mBFbPqSQp4B8tOqFwVmM9Tvu1PJrT5Pg4lIyfrlhW87CewuVoPHiny3w8
	yYOMop0Fo3ANCvAJv+b3pXRQmBdbgFfnV30kU42ILb9FVcBBfdG+uggIb86AVwCUHlVUetg4HPj
	0qiGKHhdc3tE1KhbdYm4F28+gXoGX+XW0k=
X-Received: by 2002:a17:90b:4d82:b0:398:bacb:1137 with SMTP id 98e67ed59e1d1-39d70b1c7demr7779886a91.19.1789022049796;
        Wed, 09 Sep 2026 23:34:09 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.34.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:34:09 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 12/17] mm/sparse: inline usemap allocation into sparse_init_nid()
Date: Thu, 10 Sep 2026 14:32:51 +0800
Message-ID: <20260910063256.64386-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F947180004
X-Stat-Signature: 1yjp179s8uhqcx4dymbcgrzjwwr1y8ox
X-Rspam-User: 
X-HE-Tag: 1789022050-385904
X-HE-Meta: U2FsdGVkX19LT2rd8TkhyZaGSxV7t0DPdf4uqkjxswOeUmH7vCat9+LdYO69OIPhTRzMtO7/V6jQ8fnTDq9Fo7BOA+YuyvEfuirsd797gfj2j0emPJ/95ukKyHt4X9JCuN3E31/Ad6XzhGbTHxCO4HzCYoHlaQjTJ/KbujlY7Drx5jCnvCDMQagJ6et1KjU8qfwPRv+rC1fyN/COdrc0UvNNA0//g0OgyTF/CDOlzeFniYm3eyk5R0/Itxx793dqvHbHZRwQAJ51TEj9IOkpWHWwpz6vXhCwm3v3LMN5+Ree+FgI8GwQdk3R0BuhaJKwKH34OhKTPQyV3bpaX8F9s/HsB47k8DwKaIr9hGMp7ohvpcAHAyD53c1ZNSMSC4nhSNTs832G7e/Br7YAUjzIadXLPL3pRjyYtpRvcnfs6ZIQT/W2bnoUgvvlZEo79FnCckWQ9AOVW/tuYhxFZ7qFum+wej5IXpTHiMD3Bzl+z9oKQNFOuokCxmTNV6HvSp8Bev59ZD2xiYeHNsn37RmvdABRHzPhUOU6DgFz6xQ28qhYaukmIW7l6JPyzjwmJBfDSP7m1shpWv0KiPBXG3WLmm60FI4n878/Mvmqs7lr3g+qzm6iRn7C1fh1rF4LnB4XfONw3ZShA8zx0WsfuRzeHjkmsAm6zwPV20Q1qSK3i7HJ1spCSvAawXwnTzR0rXvSLr52OEy4YbFyTD0p0d3AV5ChVCtyLu0QVUcPBlpHejnwB+lIUzmOC2awg9TJTr2eI/gcT6DQGoB9Mhsbi59NvEGLc6H+XcmMofwHMtUxmRsdQjSMkOg4rCHWpZVRNmTX3UpxNvl/n0SxWctKKegbn1RJMq5JZX0CT2D87OyqgdvBU2jmbiLylbtvrnf8ibJKFu0WxmZNJqic4v0qqOnVCmCG9s+QE3u91M4ur4vFFfthODzUbwKWXBhX0qq4LvtgYj5zwnBliUN+KQm6dT4
 +IdMuIha
 vewwEB2cU1UAr1kgsJp4OHq/LRb+b/OmxteuQiEVtmWalC4/e2AycbLkQoAm+JvMJazXsaJIdqeDu6VadjwaoufNrJ6V6T5/o9JHlb5KdcHjDFHKVhV2o0UtNe86q1WvX8ZXro0KgU1t58SZaKzrd3/8pT5hSyjasmEIqsA8D1abxUyyCGpYR9LbDuWY5fzr4ZRpxihSLPKMEEQPlgXwtXuwBcDAG6SPnAC/cq+ZLhpFluylQmcROaF/AwC7WEauc/qZCpudSEnIiajeKQUl/rKW1/6X9NPNdWDeD8KvGE1rrZ0eSzBX3u/KS8gyS1JankMEIhFDArG4EBW28i/plb+Ef6/Q6xrEMUTOJuayQ2Kyqihm6jBvNMc+RqBwTrMgT+/YEdqCTvUEGWNAEBxDUM3iDjTJdxZ7PkLo7LhaiEW5tlts1/EicLrbQwlPVoOKF/UNPep6NE+sd1LBI2noywAWtOsSTfqdvyqw76LfWPQunEmiYPNyT4OX5eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing SPARSEMEM_VMEMMAP_PREINIT, sparse_init_nid() no longer
needs the transient sparse_usagebuf state and its helper wrappers.

Allocate the usemap buffer directly in sparse_init_nid(), pass it to
sparse_init_one_section(), and drop sparse_usage_init(),
sparse_usage_fini(), and sparse_init_early_section().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mmzone.h |  3 ---
 mm/sparse.c            | 46 +++++++-----------------------------------
 2 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f2d39a888eac..6acc14b169bb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2223,9 +2223,6 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 }
 #endif
 
-void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-			       unsigned long flags);
-
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 /**
  * pfn_valid - check if there is a valid memory map entry for a PFN
diff --git a/mm/sparse.c b/mm/sparse.c
index f4f393a033a4..d19c173b40fe 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -234,42 +234,6 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-static void *sparse_usagebuf __initdata;
-static void *sparse_usagebuf_end __initdata;
-
-/*
- * Helper function that is used for generic section initialization, and
- * can also be used by any hooks added above.
- */
-void __init sparse_init_early_section(int nid, struct page *map,
-				      unsigned long pnum, unsigned long flags)
-{
-	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
-			sparse_usagebuf, SECTION_IS_EARLY | flags);
-	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
-}
-
-static int __init sparse_usage_init(int nid, unsigned long map_count)
-{
-	unsigned long size;
-
-	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
-	if (!sparse_usagebuf) {
-		sparse_usagebuf_end = NULL;
-		return -ENOMEM;
-	}
-
-	sparse_usagebuf_end = sparse_usagebuf + size;
-	return 0;
-}
-
-static void __init sparse_usage_fini(void)
-{
-	sparse_usagebuf = sparse_usagebuf_end = NULL;
-}
-
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
@@ -279,8 +243,11 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
+	struct mem_section_usage *usage;
 
-	if (sparse_usage_init(nid, map_count))
+	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+				    SMP_CACHE_BYTES, nid);
+	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -296,9 +263,10 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			panic("Failed to allocate memmap for section %lu\n", pnum);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
-		sparse_init_early_section(nid, map, pnum, 0);
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
+					SECTION_IS_EARLY);
+		usage = (void *)usage + mem_section_usage_size();
 	}
-	sparse_usage_fini();
 }
 
 /*
-- 
2.54.0


