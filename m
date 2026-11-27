Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB513606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CifmJGNs
Received: by kanga.kvack.org (Postfix)
	id A6A916B05BB; Fri, 27 Nov 2026 04:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3546B05DA; Fri, 27 Nov 2026 04:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893F46B05DD; Fri, 27 Nov 2026 04:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 571F76B05BB
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:14:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9B89C028E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:13:59 +0000 (UTC)
X-FDA: 85480336998.02.8CBAC70
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 021E618000E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:13:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CifmJGNs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770838;
	b=1u5y3FFViVFr8pE9HJ05FSRHer4j6skfRbpuuwVCPfqhegAQcbm0tDFBQbh1HUiCH9ZGBw
	sD6eG0AUFcps398bqMVgL7BoEiPU2TFu4F5LZzQBjVStcV8H3sBwWai7Jr/p/rVnTdFW0T
	nm57wf39u/YtkZwGTFXHp8b5PCIsZmk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbpBQncRyADmzwyT+DIGCOcxAB+kyUykQ1z1tEvlyxs=;
	b=JFHlqhSTG2TTabq58FOcvPexRTuIAwfti79dtPtsnnwwhhzkc4XeInKnIac9wz1dMHvIoP
	+Xi513gnrPEogc6unJEbaFasS1GIa4OH/r3EEkcOQNGdIwgKgpMlcQyFr78uny8Txcu1n3
	yE+nnjqA2krVu3/IEGMfSN8BwitHTOA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CifmJGNs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b8a1f59d5eso10387068a12.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770837; x=1796375637; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PbpBQncRyADmzwyT+DIGCOcxAB+kyUykQ1z1tEvlyxs=;
        b=CifmJGNsj1/jdLau39hPDmeaXM4u7rvEQbycNXE0l3w8UAoqTHWaHaAWFyHBqEHSkV
         qSdCJAD2q2xIGRybq0LrFWI+YoEzoAGAuheoCH+DPx1CGcMH0aYefKT82oLQJOkpONFd
         S+LXfYoPmGTcfothiqs2LWUlhMsU+CwxY29g7NN4Zn6jyZeiY8TX/OYcpb6ZHLksiyZ5
         TmLxf4iC5zpeEsdmeRmJVaNsdN2O+ERUrtHlNMzZV1x4m0WiwC6Fip2td6GuoqiNOK9n
         NsdCM3t+k1mlIfFyZKQp6VxEz9QELsyTGy6DCjESLQSyresc8azX+6g01gWJ6o654pWA
         HRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770837; x=1796375637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PbpBQncRyADmzwyT+DIGCOcxAB+kyUykQ1z1tEvlyxs=;
        b=M0IMIVRBBJTWJanq99iWFNRqbclG1JCIZZ1+AD2KqecxjiuOMAz/JS7hvnHVZU1c0d
         b25/b11+yD7EvFHE6fd1WwYQygtIjDTIPuOoEehMxQ2sjdH3sOThKgqZNLvgpwtjONVh
         6Vk+I5ffVM/dzFXbGVIQh/bok1sSIzwSGrt8zIuHwasyCXzCvoURV3LygtMBRSBN0pK/
         LC/nluJQx36+552MM++DcIlCn39iVqKHhI9TOLq3n4gT+egykdJGQCyWrIxI+P+RS1sX
         DgzBrWsGH4fLaA4g4MzMiQx0P0JXjmf4snlkEL9kaExJ0sFCy82TtUyErIub+AjprJJZ
         aQhQ==
X-Forwarded-Encrypted: i=1; AL+hErEv2HMZKlGWWH6WOIjiLnDVf2tZTaOZHvTxCdY7sd4mO9fES4VrTZWwSRgSmzzQE8bxGdYEFvEwuQ==@kvack.org
X-Gm-Message-State: APuU4Z/PVEJETOZs5htUsUh4DHGtKoA05VTjNAcZAWNvTi3YgL2pCCM7
	OGc58Kfc/4W6T7mKnUxnOGD13STKcyE7Y21u5NvUn/XjhMCJzod4XbLZ
X-Gm-Gg: AZFdTZePNjEro2zdtj/RsiqAs+SrZnyhgSxmOqAlG84Tno2xGFBdvWXvG+AgVsKGhB6
	6u3rvc46vUrdYvwi2O1Ujj6FgEHiw0WVpmRhxOxaxYdxWm231lDp4M/a/YYX95ZQT7F+Aj/y1Ta
	VxMSO7NryoPvUJPipAeNyHr9hp3h0XU6Iiyh6hcPHuWZ7ljMOTtDDpJHt1pOE2Jaz93yQPYqBYf
	trPZ0QRN/ut77a5TFo5Sl3eK47vGDebw3ZlKAPSgywfOpPDCsYyq/qq26OtZvSg5bLCRxjYvekM
	HmEbnSi8Jvd1dxUJQ/+caw81OyDB0ieqFihyEMwRu8YiWT99zRZrTq2bAcTnJOz47mRxo9Yi8VV
	wwhnGHXmt2trK/mNCZGJDTxaBYP9ONkYKYOhe1k/djwgwoG3g1am505Pa+IEmdIUHaMFDF0Pf06
	/ybbvnNbGj4ZjRTukwPzpAcdLUAZutwMJnlEXyNniln9XGgT7BM+swXlh62lsoHdDsn0/nTWE4M
	a4/zZodv5EgTfW4Rs6FHjCmScT0mZ34+TtwNOFDYnDrsvZ/pwnJhe+dS0Ii1r3BPMk7VmiNw8/d
	b6hVsNvjpVX1YYyzeL/v73b74nZu2ICmiKc=
X-Received: by 2002:a05:6402:2744:b0:6ba:4ca9:86b7 with SMTP id 4fb4d7f45d1cf-6ba4ca994e3mr17362328a12.21.1795770836265;
        Fri, 27 Nov 2026 01:13:56 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b1ed8b6a05sm26067087f8f.43.2026.11.27.01.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:13:55 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Hugh Dickins <hughd@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] mm/khugepaged: allocate page tables with NOFS in set_huge_pmd()
Date: Fri, 27 Nov 2026 10:12:15 +0100
Message-ID: <20261127091344.113688-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127091344.113688-1-azpijr@gmail.com>
References: <20261127091344.113688-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 021E618000E
X-Stat-Signature: eoj7mha6gji33m4qzwmuattb58sjeyip
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795770837-132664
X-HE-Meta: U2FsdGVkX1+evftC62mFTExMmrNgo5XQ3WDMEi8R3jQtKe94zsSGtStSE3grWTyIIJk4COQZnGA9WkVu8VAo27Uu5BdvBr860Z0jE2Nha3ySg/1SZ3aov9e+77bu/EpvDtVb9n7GhZR1WwUyuNtReD7vT1vLO7Y+m3aZv/tWEE1PL8VxmPQN9i/wwDkTJK+479IfttS9jSolnLEf3tzTyQ9CXyKVrEo1gpLaYLhetuMBO8TjzowRxnkLBh94WHQFqHqpZBnvu3SnndGWVSYRej2jJ3lb1QrRbyVRRYVyv0fuziz0gdBn0kRQf4UOL3n8IG/WYHcPRd9LrpGC3RWn0Z2CNs26Q2VhvQVOLVBtiwlj7rKkovRi1pjqgFNMhzTQhs1Iy9JGklAyoJ/pVfBocjtrbxzhHjGk2a/JGiPjhMhsRl3OD+6rZGVvXPa6GywyVW1fewNMBNT1+/JJiAsiTwDsfl+AfOCh79FFGpOG0KuOP04shIHtAE205ZF37jjk5TpNGiTpz5v9VqSx5R7lw3WpgP3HMTJaosHnHAwncQXidm0wj7+B7YRBFysxv4Xh2nvy4KsvdqCig+2KqaKekTOJ2oqPn2GO9P1de8UD8wFqCklcSZ5G9K/2X2RffAmQV/E0JsXN2ByRRxkvtaHyzsTN5GDYEc5A9S3l5KdyQfm6N7Eso8lJjzkmTs7IMGXVar6nz58HWXN9ekP2CWY7EUU/KnDgHYViUw59aXgPUNhcG4gxEliulQbo+5+LSRH1YqlvrXjI/d1tF1WktePlSU3Fw2xE5hWxzNFK5cYTq7Ead4D+kFZOKDpPx6RnnDNoidfH8RGPpcMwwWBCWEibpkHxjP2BV47UqcLyZNA4Hl/gIFEI3dl1CxSxhMAXC7R7iY++DhPeHd+yIrQviAu+sKijO2r34ycl6TxlAOUXfforHFEMoBLLizehVm5qUO0DAp0yukUJ15jw+we/rTX
 VSseHn2g
 DoQBKWOoY6KAGJgGF7SpVtLuLH16FYapHcpOpRyjPyMp/JjMO1EXE/+owu8XVTEKnHbmeclm7ySy11SdGXJYyPhi68wD6zqGozz6uJ/HKIpQcAci6WB3eM5seRyLLv7aX/8uhK2oFbmfkEICpRckxBQXkNxk+gerXcjfq/Pk+fhkhdqerl3F/7JldCsz2/YMEtP1uG6s8JaBuvpgEeCClHUVq+FtL6XchU/3ZJyf+j5KEZFmq/AdoQFQiz+N3eTstT9/lTKmrqIe7hl3jW1kbdmJvtvOCQOxsyI2GAWOzYZouhJAaFqPFKBD4bneEHO0dRnFXtomx0lKR3fju+lkEXitCSmcpA+EA06LsPA1QmPZ+pIhqQFZi6LBdQ//pVK63m7JuRtPc8vndGMXpNDjXDu9TphaoXPEZt+1DcBVsLWX7eKcEG8NhvNUf5CyV4JZz9j1HLXNpPRqhD4RiELYEYZMZki+F64VQbjnawjo4jmmOAE7OBbYVOVzGFlLShD6lN2hKHxgR/H7lEb0yr+LrFMBbBnzBrzj4Er5ZNdI+Vtqf1q5guW3muzw/YFe7xrJ6Jfa2tWt3TkNheWdTDTVleKyeubF6X+nn+pEm0vxxOMHZihke8z5CSLK1f5qK2UnMkEXCezTCH4HCqvRQ0KmYdMr5J6mjUKkXUS8RocMlQicXgFJCOkv5Mm9vCJcH2ZQ6sGezYhWYofXgN1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_collapse_pte_mapped_thp() calls set_huge_pmd() with the folio
locked. When there is no PMD table, set_huge_pmd() allocates the
missing p4d/pud/pmd tables there.

Allocating with __GFP_FS while holding a folio lock can deadlock in
reclaim. For example, memcg reclaim on cgroup v1 waits for writeback
that may be waiting for the folio lock we hold.

Allocate these page tables in a NOFS scope.

Fixes: f8a01513f574 ("mm/khugepaged: do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL")
Cc: stable@vger.kernel.org
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v2:
- allocate in a NOFS scope instead of before locking the folio (David)
- the deposit table is handled in do_set_pmd() now
- new subject, was "mm/khugepaged: allocate page tables before locking
  the folio"

v1: https://lore.kernel.org/20261125100058.15200-2-azpijr@gmail.com

 mm/khugepaged.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 93d4a6f159e8..2ac8b5621db0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1839,14 +1839,18 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
 	mmap_assert_locked(vma->vm_mm);
 
 	if (!pmdp) {
+		unsigned int nofs_flags;
+
+		/*
+		 * The folio is locked, and reclaim or compaction with __GFP_FS
+		 * could deadlock on it.
+		 */
+		nofs_flags = memalloc_nofs_save();
 		pgdp = pgd_offset(mm, addr);
 		p4dp = p4d_alloc(mm, pgdp, addr);
-		if (!p4dp)
-			return SCAN_FAIL;
-		pudp = pud_alloc(mm, p4dp, addr);
-		if (!pudp)
-			return SCAN_FAIL;
-		pmdp = pmd_alloc(mm, pudp, addr);
+		pudp = p4dp ? pud_alloc(mm, p4dp, addr) : NULL;
+		pmdp = pudp ? pmd_alloc(mm, pudp, addr) : NULL;
+		memalloc_nofs_restore(nofs_flags);
 		if (!pmdp)
 			return SCAN_FAIL;
 	}
-- 
2.56.1


