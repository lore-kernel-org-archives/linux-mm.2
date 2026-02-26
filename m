Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925C8FCE064
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EAE6B0088; Thu, 26 Feb 2026 07:26:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC746B0089; Thu, 26 Feb 2026 07:26:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FEE56B008A; Thu, 26 Feb 2026 07:26:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6E06B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:26:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3157C8CB02
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:26:54 +0000 (UTC)
X-FDA: 84486531948.29.37E4E29
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6E3114000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:26:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JDYI8Pap;
	spf=pass (imf27.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772108812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=keG28VRg7hb2nWNj2uJ8lKl/FGoScXVGvErAk96Ikwo=;
	b=of10mdmP28AQgsXUTuUS17iuvUuW8cZTrL7mJbPHxbGM2T6hMhfEBofRoLgmxk4scnpeoL
	txXcSmi+OLeDMDws8mjjW6LbP7SAZ1XQhGchCEXCWmQdk2oPzrR0YXrdO1tf/cdlMgDkCW
	pW6p+B5kglt6NUL5V2AnjF4Td5Mmgxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772108812; a=rsa-sha256;
	cv=none;
	b=ze/nxe6nEsNdtLdtkI+g2V5NM98FugS6OJylwweVXCu093lHEUMkrR/OhxGM1YQKeZCWM5
	ocIyIIAXZqj6ewnzh+nnuVg8D0hiuTBLPFPIbMP8/2HPb9Uf4cyMFMJQIcSEzY0aY0yif0
	dqmTyxoTxpKvoQsBxZMJl8Lwp75M6Dg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JDYI8Pap;
	spf=pass (imf27.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-827307b12dfso411041b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772108811; x=1772713611; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=keG28VRg7hb2nWNj2uJ8lKl/FGoScXVGvErAk96Ikwo=;
        b=JDYI8PapnCUaKru3hBPzK8HGNGKTAsp6uNcN35JsCqHOe9d9hYivzGCezBDGGqyOGZ
         23VkDfPZtb1v3FFXGIFGke6NzBQZfi/YgGlfwhHjTEdclbzSJDcjQdy66KlvpPg9WYGP
         1nXnAc5RBBOEDoB1kpx6hIcsH+3MG2OvLISxwDvc65Y2C5pitFD+L3/b0ecAlHmOcegt
         p2OCkoQ6KFXouVn3EFYWXJbzqrNjVIeiTzE7lkApzhLHtmM6oM42ue/9oWFmtABOxery
         hrrF69pFCTi84e5ks6NZT5gNHAwqa+Oq83hsWDPcXz6XAgWiYx3D9ZVPynQAKuNdPBgJ
         aO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772108811; x=1772713611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=keG28VRg7hb2nWNj2uJ8lKl/FGoScXVGvErAk96Ikwo=;
        b=Uk1P6B1cQgaH/QGx3w/ejRuoWQCv1z53Ra9Oo0NX5wwu7LdT2tqLQ4YhiYshLQX+Ms
         XQFWyC9TiWv98X42P09LAM5952YGbjtaQ1JX6VHFGvLDKxv1QMMjVhhBKBSXJuLiZVPk
         Vmzn9M/YwV57Zj0nqmHPqqeae6q4f7IMaQKJyZMdmLmPWxaQ7Jovl0JMjKz/EkNmnDB2
         ISU90y5PCgJSeXTwltRnxXEUHA2dTtcbMu3umcpqtfPTpLzy9295Q+9cGsz6z+RPJ4hX
         LN7VFDYUce8GkvO+Im65zuS1L3WHrAZobB3eNcvja6wlYnD3pG4t855VTFIckdfZ3qiN
         XYKw==
X-Gm-Message-State: AOJu0YxoNflNJkRwyJoHsqHuzrheZoXQ5Nu3t0z3J6OChbeW6xN1jTi3
	FrP34gsiaZq2EoQn7B4kXbKjw+w5Q0RSuJknb3go5wcF1DJkq8seg3aFG97+tg==
X-Gm-Gg: ATEYQzwzw/vqYfZsMaYMBHZqO8vA/7+37Yf/XoaBjaZ2Ka4G8AlcRc7F5O1urdlQfPs
	F/EGA0AfTxZ7ZGw0YaFjAKsSGPQWtH/gaU5JzjS6ofHswNxLnxJQiiAwTDMChQAC6TfQ3ruq0cm
	nbYCoLGy2snnTIN2zutOLGwXUDJpf3/mgRgvs7TFmVbc7evAuD0KfFjgKEB5lb8eyw2taZ5y3Je
	bJkU0mft16QdfGfWf/v6oRFsrF/uU3jc33Y7ld1L4wlGwsRRFBLYbAibyBdQGl7zygDcS4Uxdxv
	CUyjtveawlwli3O8mgMW8Gp/MdL98v/0VyvEvIOkuB2VyhR4CsgN0gP+HlbBXyQQ+sU9JCbbNmn
	zr6ov8vMkh2jl3XX/ZnZWQtLw9fylHuLJkAZo4Md0M14SVHTLz5o+8P8XsiXHHx6zqJ3T/Ya9Ae
	U9XHDZUt08x8NnXsVOGA==
X-Received: by 2002:a05:6a00:1d14:b0:7e8:3fcb:9b00 with SMTP id d2e1a72fcca58-827398063bemr1923995b3a.22.1772108810592;
        Thu, 26 Feb 2026 04:26:50 -0800 (PST)
Received: from dw-tp ([203.81.243.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a01aa09sm2958494b3a.48.2026.02.26.04.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 04:26:48 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linuxppc-dev@lists.ozlabs.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH] mm/hugetlb.c: Use __pa() instead of virt_to_phys() in early bootmem alloc code
Date: Thu, 26 Feb 2026 17:56:30 +0530
Message-ID: <b4a7d2c6c4c1dd81dddc904fc21f01303290a4b8.1772107852.git.riteshh@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 6mcmz6rpt77exaw7k57fw1pgrc1fteek
X-Rspamd-Queue-Id: 6E3114000B
X-Rspam-User: 
X-HE-Tag: 1772108812-611140
X-HE-Meta: U2FsdGVkX1+kJkW3Nz9iD+m6pe0uaI8xqTSzYgOBTkcPlepBm9TV6L2R2zrWvaVUGNdgXUiwKtV8Im+4RRj0lbB0n8hXNCD++peGIOuuLm9x1mMYbu0iPn4cZAOpIZX2JP5ljeXZ/Dj7rkXRKp5R09H1T6KwCwTuuR5kZjqd8QORRKrJ1eVcjG2bl8pA0xcs4jpvr7qSFxOoH6mOXy0IRrXaiUHFJ5ZK6mJmnrHSpNPxyq9V8dHVqcOASjYuhbKj23G5OybjscWEAk5zKqI7aWhaWs8AAHAIVeRC/I+Xw4Gr+L9fPhYJiveKtS2dLGnpGwqQRYJAvAKK9ygtiLIVquxWYMuzxIU8NCZt8dLSQ8rYIYHsJEdIKrScKV69bBg2ogZpjgi5QBpN/FrmhIH3bHL8UjTKIWX2VdYfpEca9pTu3d/c2eziqZUu0BtuAkp2tnLZXtNAhelwiI1jL/g0JRG+aUb++oQusgLOIIYv3CmE1pCyM6NYgzplFAsouhYL45BsCApM/lfQWeCUeWBb24nY/3yiztG564rh6QNyTSm/IYJd8UaLS6Ld6A2tZaNHkEycCejHfpKmCL7eH6raIBccK34w7Cj8s0SBxacdbfNNnCU5i0PItQ8b4BqDlFyt7PCQv5Co+BLJAVewzdEjnUTkHhBQS9W+yv7wSJhvvn8ZjNAjXdCNkPiNaddrNO/O2XTEsNcvxKCKNe1ArldKA5LVldq3ICjuV4WenC9/vbQYOYJ/CFHTtqpVY6DH2+JCsA8sWCZUkCnTvqVbvrHhA773oDBaUWxZcFI3mLxKNmxnmWjJyvdF457zumJDDJMkDy3KV+0Ql4rdr6vUPLBN5gLfAm+WTK5Dtn+FUSYeLQXuncJxRDBs0c4F9CezCBNPnxQshsda1PT2JIamwytchLbYeff+n3L3L6iADYHYbE3QI+5C6LXG7UdCc8wbtvvAoPgE2RCx9NZ3ELgq63j
 /gTUUQYD
 a1/lgXhRza6ktkWImPaWRKXWCBdWtUoNTzw1XjpC/Pdgjg6Qym2zJ6hE7O3XRV4UlVaaDZmYFrbpJ+woq2mcXSyD7wGIBTasjNZyMHSpmErTByYiwEqZnTuVzHii86K2swD70cLm8leVyVNoeNWWbQBVN71l2eHq7K+W9hq3NwmdalhGr1lZ/ftWbrjo6vi8mm1+BLCoQ/byFwaP31/JXpQrFXB3/AhgDhNiMpjXxwI61NN6dvoTpMr+fsOvQUfFhbQ0Ddmwp0BJW/GieRa2JChXmlMvNbZKpoTcH24KomMq8WaeN1YQvnB/UYEMYi3uFKYcKTcCHeeo42o6JXwq+dVUl+kPqhTldM/mcruDYb08fNaI9NSwC4EISLkCgr2X5aPQl6ctk+xQYmBW3qhnySXT9vw5WiNqWbsrUdjUhMN5B3dr5PsRkzcqmefab7bz06HpRljAMEsn8j5svXvV+uF28zWWehoEQMJ/vHdpDP7Arn+OsRiHu64UTEuoDRbF3Xli5n7GgRv3HEbKaRIMAgQSyQJSE1e6zm6y9hcVZvVI+K5CySw7LPhAwCu2IW6F5dHS2aWUazaHXl+tJOhijAxnqBUYXfuRJZVqvrQggWVk1Q4t+0tVQzh6SWgLzylrEIynM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architecture like powerpc, checks for pfn_valid() in their
virt_to_phys() implementation (when CONFIG_DEBUG_VIRTUAL is enabled) [1].
Commit d49004c5f0c1 "arch, mm: consolidate initialization of nodes, zones and memory map"
changed the order of initialization between hugetlb_bootmem_alloc() and
free_area_init(). This means, pfn_valid() can now return false in
alloc_bootmem() path, since sparse_init() is not yet done.

Since, alloc_bootmem() uses memblock_alloc(.., MEMBLOCK_ALLOC_ACCESSIBLE), this
means these allocations are always going to happen below high_memory, where
__pa() should return valid physical addresses. Hence this patch converts
the two callers of virt_to_phys() in alloc_bootmem() path to __pa() to avoid
this bootup warning:

 ------------[ cut here ]------------
 WARNING: arch/powerpc/include/asm/io.h:879 at virt_to_phys+0x44/0x1b8, CPU#0: swapper/0
 Modules linked in:
 <...>
 NIP [c000000000601584] virt_to_phys+0x44/0x1b8
 LR [c000000004075de4] alloc_bootmem+0x144/0x1a8
 Call Trace:
 [c000000004d1fb50] [c000000004075dd4] alloc_bootmem+0x134/0x1a8
 [c000000004d1fba0] [c000000004075fac] __alloc_bootmem_huge_page+0x164/0x230
 [c000000004d1fbe0] [c000000004030bc4] alloc_bootmem_huge_page+0x44/0x138
 [c000000004d1fc10] [c000000004076e48] hugetlb_hstate_alloc_pages+0x350/0x5ac
 [c000000004d1fd30] [c0000000040782f0] hugetlb_bootmem_alloc+0x15c/0x19c
 [c000000004d1fd70] [c00000000406d7b4] mm_core_init_early+0x7c/0xdf4
 [c000000004d1ff30] [c000000004011d84] start_kernel+0xac/0xc58
 [c000000004d1ffe0] [c00000000000e99c] start_here_common+0x1c/0x20

[1]: https://lore.kernel.org/linuxppc-dev/87tsv5h544.ritesh.list@gmail.com/

Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6e855a32de3d..43e0c95738a6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3101,7 +3101,7 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 			 * extract the actual node first.
 			 */
 			if (m)
-				listnode = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));
+				listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));
 		}

 		if (m) {
@@ -3160,7 +3160,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 * The head struct page is used to get folio information by the HugeTLB
 	 * subsystem like zone id and node id.
 	 */
-	memblock_reserved_mark_noinit(virt_to_phys((void *)m + PAGE_SIZE),
+	memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
 		huge_page_size(h) - PAGE_SIZE);

 	return 1;
--
2.53.0


