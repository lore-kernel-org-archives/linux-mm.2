Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E49C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B7E6B00AE; Mon, 21 Sep 2026 16:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC596B00AF; Mon, 21 Sep 2026 16:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB856B00B0; Mon, 21 Sep 2026 16:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD6C6B00AE
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:01:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D7911401DB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:01:06 +0000 (UTC)
X-FDA: 85238838132.26.FA54A16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F89C40014
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:01:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFShNioD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aiW8jMRF7trBH5bkli+MjzrubVcAAqfTiLF5O9WVvhs=;
	b=rvTUltQbrtbkoEldJ0YfKar1aLItfEGvlfuIMUgmGs2jJ3Z/ZgIrSY9aqynFR9u/vim8YE
	RZeFfO9BV+GiVShOy7VMgnUcjC8UYENGa/9zfc3xOPTtVamcAAHIjZIjn+eZcXFlAPvsaB
	oEsmKo2z/CsY94UZkckJDuD9lRr+t1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020864;
	b=n1D9bEqthVahtdQyW03BR2SdyN4yvocYH2XMviNKoQvrbd4erE3oeqcCJXSwHoICbTW3m0
	aZJoh+XxuJawj6XMcQju/PPL9cb34ZXzutdmojZUI0XRNx4GPYYsZ4pf75wu+omgAapPRY
	xyXXhH12YwIL1pfPm+CaJ3Qms/fosD4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFShNioD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 872504242C;
	Mon, 21 Sep 2026 20:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B47B1F00893;
	Mon, 21 Sep 2026 20:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020863;
	bh=aiW8jMRF7trBH5bkli+MjzrubVcAAqfTiLF5O9WVvhs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hFShNioD8FIHUBPTTlNed6+nGMGaxBGmHT701pV1AkxSTAInddj9jcXHuknAJ0deb
	 6JuE2m9tfJWf5ihrXLNXTWSEHvC2cszDBZTxb2nIFwrYxYkvlK7m9UqPnzYL4ayK/t
	 Fh0m6UZRYqyG+3dX+gPfFwAHAyuRwgX1rEO6YBGdhm+mI2v3UkJ17xFc9fW+TaHA0k
	 RB9EYsX0YuIorA6ooaYUbo6VOTusScsUhryPOHvdGP/JhHONA0X0ffZnaJVSVD9cbR
	 vnWRVzyaZIykdCwmzyk4JITq446R74sw2TBVaH3rqtV76s2D45yyraFtH75Z6CQT9i
	 +JwyHF+JB69ww==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:59:03 +0200
Subject: [PATCH v2 11/13] mm/sparse: remove flags parameter from
 sparse_init_one_section()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-11-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2374; i=david@kernel.org;
 h=from:subject:message-id; bh=N/9OGvGMP2oKAsMrqGIIPnQ4ai1EtHZkGHyygVZ1Lq0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rRVJuerKQhvSQ5K9nXfHddWu1pWMzTxl6nqfN8+l
 5vi82d2lLIwiHEwyIopsgQF3zd4+XJdbbUbHzPMHFYmkCEMXJwCMBHZpQz//ZMUuHVl2K782c6X
 87fzp5JdmMLqktLzX6et//ih8IkZF8M/Xd/5f47OXtuteNeld9+f6otJXc6qkpr+umKa+mZcW17
 yAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3F89C40014
X-Stat-Signature: caagkic156i38zh5nmw78c5dpnnu7jt1
X-HE-Tag: 1790020864-10338
X-HE-Meta: U2FsdGVkX19i2H+e8a4MG9aPt/Ff25gThhHMs2SKcpXtiTqIe7REZl1d4mqHZPqqPakUggHEuAhGtskq5xQvSii8lBsTZW52unH1kMHnLgZRTQtc33urJG4/klthRBrZ3k3DH/eIXpgLr6zaf6DasI1MEi2L6aVr8ZNkvUzVyxNzCSaEkHqp9E2gpYaiCqSnEsWLz2JaYUPjRNsoFPX6BsFHVkvfeF0Kzq/i/qxPLQJbWJZpgsEg2ViFbKWJwy63PaZD3Jqyd5OYnNqVu/76T6SsMlvjcYQexdlaiHH3P8R2jNAFuIzhPF0JdV5HVhzP5NpJkNaD0W9GmRVHdkNgyO15BPacw+VbnzhjRxaw4VFrITkOS/YB+++CcujwIwATBUjOik+IUUNv1kBcU/jNJDa1ampWAROvnvUkF1EhzmYmMbFeaGHqm6P2DSQXMv47WcbOrScNIEqMlqTJ2anyWWEYTlCNOgCA/M3LJ7hijjVFpeBOgbajlWYPy0t1daKaFbT/94vOtvmQbEk/YhbAyu5+t5pxnt+cFgSI1yvDjXU2zOQsralVQVMlfsKvmiE5Zamy+rJ2Btxl+OWn9r6wncytAKOrZ+pjUHy1xHm+Xaw8zsu2KCFuC+QirXMCwhTgDtgBsqBD+ck9UnNFopSoC7LXSzcE40pBWzH9ZsQyhspDikgHW8HMHzxHBdOxj+e94HobHO2ca3tzWVS7wQeIfcDuaQZGJimAgKPrLsM7CgZMbkCqxjMCJ/dT38hyUFp4ypBpAoX8jngA7Ts1+EtlLdUniofWB3yjP3fH9dHhSvv4oqAiUI4rnNQ4u0YiYqlA45IyyRuSh5KK9Ke59e84oFISFT9zliFX50I4a3Rb+bs22sMj5Mal3n/TJ7Z2JmHQALsEl3y5W4nRhRGFU0xt0RHC5l6C963U4TrPEieIB9AN9TeOcWS0az84y40CwUVyNLrkTFRtIxX2ngQWQB5
 miQJZfs3
 NL+oewm4SkVc1KvWVYDYl1o7cNHlKPsW6EUk3YMF9g1W1Vkehj2/aukhvr56mgD2XEobCtTTzov6QgU6GvD2vth50xAoz7COSqPEWSZBf6v5OLjdkc0KBK8AmS7ww+4HF+nwLT18D/s6q7Vs2ls3LZ8r0H1LyVC3QgVlzMM6DAkr8vWYam/0+Qbt2PrMqTkmllAUbx1xtgXix8j1WIWMeYLfVP3y7gi27Qe2bTPxxi/t5EOIYQIF+xPpEQXwXUdPAr5BHoC725CiJgX6MAB3JU9+cjpnWrI31QKYL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last user of the flags parameter that used to pass SECTION_IS_EARLY
was removed, so let's remove the parameter.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse-vmemmap.c | 2 +-
 mm/sparse.c         | 2 +-
 mm/sparse.h         | 5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f0db433e0f10b..3267f9362c68b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -869,7 +869,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
 		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
-	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
+	sparse_init_one_section(ms, section_nr, memmap, ms->usage);
 
 	return 0;
 }
diff --git a/mm/sparse.c b/mm/sparse.c
index 5d2d9f95d4024..702904b417006 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -243,7 +243,7 @@ static void __init sparse_metadata_init_nid(int nid,
 			      section_nr);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
-					mem_map, usage, 0);
+					mem_map, usage);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
diff --git a/mm/sparse.h b/mm/sparse.h
index 19664d702af84..fdbc4cacf91d1 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -21,7 +21,7 @@ int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
 		unsigned long section_nr, struct page *mem_map,
-		struct mem_section_usage *usage, unsigned long flags)
+		struct mem_section_usage *usage)
 {
 	unsigned long coded_mem_map;
 
@@ -37,8 +37,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= coded_mem_map;
-	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
+	ms->section_mem_map |= coded_mem_map | SECTION_HAS_MEM_MAP;
 	ms->usage = usage;
 }
 

-- 
2.43.0


