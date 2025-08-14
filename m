Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E587DCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72050900121; Thu, 14 Aug 2025 07:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDC6900023; Thu, 14 Aug 2025 07:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60EF6900121; Thu, 14 Aug 2025 07:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42F6A900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:39:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9CFB137D4D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:45 +0000 (UTC)
X-FDA: 83775168330.12.BAC759F
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id E7A4E10000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XK6wJfPY;
	spf=pass (imf14.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Siw9DsX8IWhSgi7MTre4CZ6lTKJuNoAzdRBlrvonfQk=;
	b=03a9eUAdYKggUBvL3oiuTVtqP4u1dS7iA2K4F3NJ+nGEWgmxFrpuMz85RUbkH0EXCFxlfn
	xImq85PrtfLYrFsTxjFBEUo+VQuphxXkDL7KDLZTRUDF9Yj192sxVeb5ZDie0cf4vmBTUO
	ZE8rLnXJs5u3/KKbOs008VW8oWXx94U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XK6wJfPY;
	spf=pass (imf14.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171584; a=rsa-sha256;
	cv=none;
	b=lmfZ0r3ATVe73pPxEoEQijBt3GBsXeTqfGgjOd36VS/WmrGNE2CP71ZzglCGtMU9KuYXEO
	tafThEIuDVB4PvxgTpj25TohjUb6sXXDsJvypMzFUxYZ/rAg6NDkeVYwXoR9nwl3LDWgYp
	SFuspWSlph+lvVAy1tgNXi4x9rB5Af8=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e2ea79219so1032547b3a.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755171583; x=1755776383; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Siw9DsX8IWhSgi7MTre4CZ6lTKJuNoAzdRBlrvonfQk=;
        b=XK6wJfPYMXOB030HGllZLyGLz1LnVdqyVs+jWdmzynHTHc+cY8rZMNp57i0VyHErGv
         YSO7TeswVi98RgRhy4NDKBCbthF4tqxkfnI+6gqyaYJP9g9SFnCwcnmPz6M9kgFCsoHY
         zD67TUeEIH6EBfiz+7Da8JVu80cUVBlDwdP/i5Xy51CboA9YN5EH/4DvXwhMgTW1EiIl
         MFty3KU9WopJ8XftrmUkcp+U9y169Vgp3MBYV/tJ2izK3POomtWJPa94cW3WpHi4fU3x
         hfKGfnC604m1eNT1uEXn2HNKSTgCxLKRarSeQQb4JWa46xe9+CfHTJB2Sy03CZIGOkOh
         SWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755171583; x=1755776383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Siw9DsX8IWhSgi7MTre4CZ6lTKJuNoAzdRBlrvonfQk=;
        b=AqnsvNDTRt/qJlDQUhJcINwbJjkHTGzpQSgKzcM0D8/zaBKYGlLAFHO4QgL4O33+b3
         YK+ecRnqM+IKCmryfAZuFNLchYlzsuXVKlLc0gEnQYldm4yauOPt2OQnAYrSPZb0R+bx
         LtTSRuIRcl/aT2V0K5QKWWzC9WgloCEgT0cxU3j9uudGfIJfAI6kHiRDyyGevpHfrNyy
         Efpith/naJsW8Dc3aLKe/q84I2RNzfh06Sr7RfhYCCRbRfCurgr/3BYIhn/BatYRUpjl
         8ThXiiRMpKCI/VLzi4zqfv5oAz1BKgup5ZpHBxgKtHNKObNasNrsGbXORaW11W9/3SCQ
         s7xQ==
X-Gm-Message-State: AOJu0Yze5CJ12KAyIcO78K8pVEpennnxpWE4hmaW16+CYijbsAf8D7js
	bQD469qUoKPxw9u3GaK244B0r2nsww4nGrSWcTMG2WRFDuAUunxyMfAx
X-Gm-Gg: ASbGncuUvAkgt7qtE27/khiFSuakKU+TFcFgCNq8ZsMVKaximBFYp9xv7DTYlk6iSmO
	vdECP18kvoTmDIK7I7JY596gXGwSa902c9Nhn9GCxdgy3y8n3x9GmsJnGPVN+BLCoE+hBtRTcmQ
	8vnuiqNUDKGZOQwnuZSf6yP+qknWPqxwzh9Fiv6N6vsQL1WfThDRXWMGgdTDgKDodST++8efHOk
	ZXxSa7s0MHDeIsJdenqZuB889Gw73Iwoqv82tLZuRcYYVJYiPdmw0lpXH7WYmYUR94G8vyUOoIW
	0f2I/xxOBxFTzTSTU9RYsez3QyX7e48Q924q5aWFW/DChat5qDQenyb0Rxx4xQrveIxLskD1nMf
	RjWWTXlX+N04/U4wWWNjmLWpr7zI=
X-Google-Smtp-Source: AGHT+IGMd16t2RXLIzdNEugJRNwYRWos5SYiV9iJVUcDWcvOePo09FZSkA7mgkzSpPOI3o4pkkhaQg==
X-Received: by 2002:a17:903:1b64:b0:234:ed31:fca7 with SMTP id d9443c01a7336-244586daca3mr40410685ad.48.1755171582702;
        Thu, 14 Aug 2025 04:39:42 -0700 (PDT)
Received: from vernon-laptop ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2430b53d504sm49046215ad.87.2025.08.14.04.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:39:42 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	shuah@kernel.org,
	richardcochran@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.or,
	Vernon Yang <vernon2gm@gmail.com>
Subject: [RFC PATCH 4/7] mm: memory: add offset to start copy for copy_user_gigantic_page
Date: Thu, 14 Aug 2025 19:38:10 +0800
Message-ID: <20250814113813.4533-5-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814113813.4533-1-vernon2gm@gmail.com>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7A4E10000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wabsdicy97ft3njf6hp55mq1ts6zc6rw
X-HE-Tag: 1755171583-721041
X-HE-Meta: U2FsdGVkX182qEsGrupfVSJbBfmz9KlCED3l/hA5c8tvUb7DqfDOCVkjFTG4aFTmpbqGxBRHMjitKkFGsYfXsOejt/x4JyXd7xFCW93utXfDfi3DURGNQ304FzidXZPt2v3pRxjMzDC8htWpdxETaaH5WNCa+RLGuEBZzNcQ8D3d1gl76M/XMF/NntiJWpLbMdk5MNc+CxGvG2drHSg6k1ag9k/ki3LDxHXoRC3LHYGST4rIbuoV3qMa4g0kO8bzIphHw36z3NW8hXCjZSe9Y2x30Knpa9X8SlOe9Oo8U9r3gHo1cArWNGKBm9nYslMrA0gNdYE5j1ngfOZgRt6qOLWFKuCovCkyHicKtYa/5dhrUPOoAcMXZiw9hMpgmrFSY9yoxzL3ZcgC0ZpQOqDk1CWtlQBklntvEQ4k/RngJnyZhQGBqcsv7l9ARbgo55Shp4BwEv9rV6+TM0uT9hX8Dmiksnu2AoyRT8UuwpgOblc8de4gpoAWoqTCLD/QGinyTbE1Sdrx3qu259//EtOz26zB5dBTpMaX0uA3kuQKbzwpK3isfpcdteyGHHoCxCrHL9l3xFNgMY93bn6R0bW9BmuVGkXP/gj/Sn4Qf4cIUr0t9UoIN9p0iCQUaMpbChK7FcaTAI8vF0HtKakJbfcSeOklAbCgb1ldY02Hp22Xgs36AhYv3ZTzmHEA/b3YnxngNcDFZe9PCtOqZVqIH1SBlP1W12eg1qDc/pkesN3Q0jrueYBriVjyzAhdZkTEmMG43dPtzOrFLF25jCvfQHDBhybOoVYt938Wn2PGVfEvlRqdJ1gGUjbnbtwlruIcu2tStmIgctnXVs6OuxJFJ6hz9oxbK/GrIZW52AgwGwXiziaYbREUWKdKXNWrWORNB9mbJnPMtlhSfmlsSKFzSudHP63ORiQ9H3hkKCKENecYAWPN7IE0kWd+VGt5WUF4oHjzOpgXPhApqVF1qpyE85c
 JhQi7ti9
 cqoArY/qidl6QahokNrnoh82jm1cYvhzH0xcZRwn59mAtLvL8UwY1iSoFhd/RwiZ14BkcV13/rtNXHnpHRzlcHtGiyrEk4QtOyhfBWGOJ8rgFIKzdP3D0j0flz5gQLvaV3h4uogO+OVJmKkYqOlf0K2sM4fE/XhWRNJfdVwiRjKK5bCF3MfmYtPtCuKVw989jtJfb1qcWl48fLXMQQnULmarm30I0Qc9UK8ZXE/B23P6wG/tp8tq1tDwodxgyBWYU6Aysc/BLr9Bgp1GwhtZLw9omQ3XO3aPCznroWhw2DmLY7fRDbUu2JfngiuZPXRqfQYf59k5BCwRgf0ZuZuAnGQDeQv7QI6TQCn9aWplWdT6iZPvKrocnUaP7Uu+WtwuKqlEtwJvRgopjOpx7lZ9fY8L+jfnc/Nx9eWfPbGu37nUVwDakrzewjGgoodCsTcm96iI0NbwlcVXdO1Ygs7aXWWVcIj5RHaEPyyGg3TpO7i4MDTyIGLgtZWYros4bh7v09xdKv/yswTRWvM6jtLBV1vp78zNJVYDTe6IFZt2G1BlG8XAccn5BCcG3SwtBPqU24UuNOQU0KaQ3oas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for wp support mthp, add offset to start copy for
copy_user_large_folio() function.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 include/linux/mm.h |  1 +
 mm/hugetlb.c       |  6 +++---
 mm/memory.c        | 11 ++++++++---
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80c6673f419e..e178fb1049f7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4006,6 +4006,7 @@ enum mf_action_page_type {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 void folio_zero_user(struct folio *folio, unsigned long addr_hint);
 int copy_user_large_folio(struct folio *dst, struct folio *src,
+			  unsigned int offset,
 			  unsigned long addr_hint,
 			  struct vm_area_struct *vma);
 long copy_folio_from_user(struct folio *dst_folio,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a0d285d20992..91e1ec73f092 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5682,7 +5682,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 					break;
 				}
 				ret = copy_user_large_folio(new_folio, pte_folio,
-							    addr, dst_vma);
+							    0, addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
 					folio_put(new_folio);
@@ -6277,7 +6277,7 @@ static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
 	if (unlikely(ret))
 		goto out_release_all;
 
-	if (copy_user_large_folio(new_folio, old_folio, vmf->real_address, vma)) {
+	if (copy_user_large_folio(new_folio, old_folio, 0, vmf->real_address, vma)) {
 		ret = VM_FAULT_HWPOISON_LARGE | VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_release_all;
 	}
@@ -6992,7 +6992,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			*foliop = NULL;
 			goto out;
 		}
-		ret = copy_user_large_folio(folio, *foliop, dst_addr, dst_vma);
+		ret = copy_user_large_folio(folio, *foliop, 0, dst_addr, dst_vma);
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
diff --git a/mm/memory.c b/mm/memory.c
index 7b8c7d0f9ff4..3451e6e5aabd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7071,6 +7071,7 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
+				   unsigned int offset,
 				   unsigned long addr_hint,
 				   struct vm_area_struct *vma,
 				   unsigned int nr_pages)
@@ -7082,7 +7083,7 @@ static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
 
 	for (i = 0; i < nr_pages; i++) {
 		dst_page = folio_page(dst, i);
-		src_page = folio_page(src, i);
+		src_page = folio_page(src, offset + i);
 
 		cond_resched();
 		if (copy_mc_user_highpage(dst_page, src_page,
@@ -7095,6 +7096,7 @@ static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
 struct copy_subpage_arg {
 	struct folio *dst;
 	struct folio *src;
+	unsigned int offset;
 	struct vm_area_struct *vma;
 };
 
@@ -7102,7 +7104,7 @@ static int copy_subpage(unsigned long addr, int idx, void *arg)
 {
 	struct copy_subpage_arg *copy_arg = arg;
 	struct page *dst = folio_page(copy_arg->dst, idx);
-	struct page *src = folio_page(copy_arg->src, idx);
+	struct page *src = folio_page(copy_arg->src, copy_arg->offset + idx);
 
 	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma))
 		return -EHWPOISON;
@@ -7110,17 +7112,20 @@ static int copy_subpage(unsigned long addr, int idx, void *arg)
 }
 
 int copy_user_large_folio(struct folio *dst, struct folio *src,
+			  unsigned int offset,
 			  unsigned long addr_hint, struct vm_area_struct *vma)
 {
 	unsigned int nr_pages = folio_nr_pages(dst);
 	struct copy_subpage_arg arg = {
 		.dst = dst,
 		.src = src,
+		.offset = offset,
 		.vma = vma,
 	};
 
 	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
-		return copy_user_gigantic_page(dst, src, addr_hint, vma, nr_pages);
+		return copy_user_gigantic_page(dst, src, offset, addr_hint,
+					       vma, nr_pages);
 
 	return process_huge_page(addr_hint, nr_pages, copy_subpage, &arg);
 }
-- 
2.50.1


