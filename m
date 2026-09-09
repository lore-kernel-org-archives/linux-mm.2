Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E6B5C79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348726B0092; Tue,  8 Sep 2026 22:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F736B0093; Tue,  8 Sep 2026 22:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20EEF6B0095; Tue,  8 Sep 2026 22:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED1416B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:58:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72BA6C0827
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:36 +0000 (UTC)
X-FDA: 85192715832.23.C9A6201
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9913140006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R0e2KlvO;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788922714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdv4IQZIJENY7PTBs1f5yW/iQydimvcyHFBLXl2Ap5U=;
	b=Jrzvf/iwD+4PWtLjJ2LXdJwlUH13gfmkztz2GzB1pXN0cL7ekY+IJkk/8oASdsibJEdGTv
	/o17xgM6PU93+RLGlClJsXMsJ+qj1wUOUZ8aGvILXHEHL/yYaD7Sa+N25scwpWcGJ/x9qb
	wV8tqTNoNpm6DvWmmUvfJyeSmEuT4iM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788922714;
	b=cRVEg83kTY6nA8iKmsjdvVPdKNc+50rwK3HmcSV65hUCeN8NJqG8yoTEq/HTrN5XWdU4hM
	kpQLu7G258lXwKOxDUoLedmnYrxIq8dZ/hk55iTeC3x0GXE0HQ3p9uRgRZzF5NyWUlaXQW
	y4qdCifYGJ2KNAae4JGvm39uPcJScZQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R0e2KlvO;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so5227503a91.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 19:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788922713; x=1789527513; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sdv4IQZIJENY7PTBs1f5yW/iQydimvcyHFBLXl2Ap5U=;
        b=R0e2KlvOEemzqVw67DiqwgYrcVvgeY03LoNGTolW7aDMia3JwXJLhlZxtQzjnoQ0QB
         mRl8sayTtg0K0CVYc8PUiSK74XlPLljadPeLetauiqt3O4yzmX6dhmLHCQQHGSMbsejA
         vbHp17RUXQ5JBtNStvLzAQ9fYVc0ZCX1tpFcXmcU48lZuNa0rPDHlKV9cEzgkhM2Bzlh
         uDD+EndaijT8nYIlcWeEL9+MGNkou9Efon4+w1XKRvh09cmGzTXKVQOWivKOEBF5oVWf
         jff7Pp/uBQPqj8h4a3mh8akdaIeetrWQ7U26y4dbLWOrx7BQLmk+QdEmH4g+7Quy9yKD
         IFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788922713; x=1789527513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sdv4IQZIJENY7PTBs1f5yW/iQydimvcyHFBLXl2Ap5U=;
        b=VtL2XEvpyXGDAil8zce0hi1WWzI6G5pnlJJB2mJy98VOGK6k7KqbSKgOsvKdxkmz8D
         8fO5+S3xJ02LaZVhg7zMNn62omVfcsGv5LZHCqj+XFyDXJqa0HyGWOSZwK3mgRVn/86u
         7hXlkAnIdRWGO4oqxsw1Y0Nt+3kySgsm6mRCHoKCHIKPF+mJQhwLUPtMNsyqbxuSMaag
         u59uuYsFm9olxJACPMUBuZITMVfnR1Doi2WwWkgaNoJcYBZ8Kfop3pnVFSlMRUxpyiGg
         dNJl8sJvU2qPGhPvdZAuMDOUGNWNfssyS6fJlENoo58hYuX06NWwkGs/fBUG9fIAETJi
         9C1A==
X-Forwarded-Encrypted: i=1; AKwUvBy2OXw8dcjHD6Oz+MaxH2BQEP2Z9G4vxeEgoHxM1fssw4ePSeED2C+ATo0+cdHEOCzojBsoj2Z9lA==@kvack.org
X-Gm-Message-State: AFuF++m4m5mQ1EiaI0Ouo2Ahu2OG/z6g4MwiX/KLwnwqcMR4s6cU07nL
	Tn8IlRB+S9aHNL7LWXEGG5a41ZCf5qcmQQyCYr5B+qo/cEzFNsK9zGxPttaPCY0h
X-Gm-Gg: AYBFou1lY7Txyk4aLuBs+nQ2IXOPPh3uFO4IIhVOCCGG1fiQtv2ad4dyhDa+T3bgMjD
	ii+yjJpWnSZx+RijR4Iu4M6RQDDCSWX52rrJb7Rm71F96AI/aM6B94iViEwi2akrETN00HTY0zY
	EqAG9xCoe8ufch0AWXtd59lrQ/7VjX1UJratVL+l2phAt8dxQXpjExEd8Dt69SDkP6FwJyNXFUe
	Z/pw+DsCn0v8VPJ+TdCsaTaLhIPYV+nC6XAp3T/njV/IdtNMt1XKlKbkFHHFZ7x6PiYBHaMVCoP
	KdKSgdzlPQCuW/6uNuakY87qL9CKDQtv4UeEuXjNmKpydGUEvOjpa/BNn9JshcBxNNXa8/g0YmM
	KXNhllzWjxeMttiTRRDT8d6SU5ZSPv535WyKn1dlaxkmrvkgPCEkbzzthjkpEt2Wwwr4Wu/VJax
	MdURph7JjVO0rqraAfi52AI+cErzbErkaSDBrIG0ORrXP9QGkFoQB4APxcKPajENmPMvKQFiDQO
	0nMkMCoNlm8lA==
X-Received: by 2002:a17:90b:3a81:b0:398:c292:ac80 with SMTP id 98e67ed59e1d1-39b2612eaa4mr45424270a91.10.1788922713364;
        Tue, 08 Sep 2026 19:58:33 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c39451sm35077172a91.7.2026.09.08.19.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 19:58:32 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v5 1/3] mm: khugepaged: fix swap entry value to folio_pfn()
Date: Wed,  9 Sep 2026 10:58:01 +0800
Message-ID: <20260909025804.3233645-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909025804.3233645-1-vernon2gm@gmail.com>
References: <20260909025804.3233645-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: y5ad54zcf41fj8a7yxu5rrca1e3wgx9b
X-Rspamd-Queue-Id: 9913140006
X-HE-Tag: 1788922714-939907
X-HE-Meta: U2FsdGVkX1+yepbUdIUw3cGEnSNAwvSSu+pArwwAp3mH37D1W9/baF/RxBP1fuWijjAXwn9U/bsdZ33VO5FIi9Nn4Mb1cMzV0jyh/tawByji1mqYFwY5suEKU9JhES7HnO9Gzi5VAqZTdMqCiGnpgodWcMpdLvE8u432/+mLbki1ERPwW1mFgl06b14LA0TQ8Q35PTx2M+04D1yOKrfakF7j2wdknniawLH1VfqeShUurTJ2p4GIJMmV0boAufJQ6vPsIEsuJ16lNXs5TmzMSNZErHkHHKyBj0xnxPumy52nn1sZ6lrs5PyYVbTyKXjkCE5o4Pvk6ijIlQx28vmhuoJair+jRp0xeamWs0LcXYfLmvgK0DzwRZO7kj4LGdUPp7b2JC7+1YLG8YqLlj8gYnqipwVl0CkCAqaAygA0ZqYwbDVDjHHyF88QbSybzP0nCz5hVRTLWgXCgo4M0lxkWu//WPkLIk9rf1LrFUqM8ltjKyyMpKPRfi7gd1NZY35vAH/Oli7oUJSQEQH4rTr3mjPVhdl/1H2owWYiO5iYeGvToDL813H+sIdJ9K8rVAy8464Xcrrp8fe/of0QhfxCpRAAryA/iG2Exj8i7NS0cOiX8hmn2AC6dIvA4VHbWUnMFnuEUDL6PXJ9pCIlSkbiVSfuRbKe5V64yyemr0NTmoUaNu3hQ1ZJXXAkI8MNfYmUU1u3rnP8lTORcRhBzYNkV+rNtRy7R8yBtfUlk8rNfXuqzwGiNpO/94S6PZBPtBFuVzjoX+9lFZSNLG3aBWi0FXZco/fsSmiJzKQnZVW3j1umP+kxBGktdPjWArKMSH3ZL5t/U1uyPXH/LyciZ+w245LcpqELJuXFP7s2p8dyhEgVZfWpmgG8mYtB2CdNUkNXhq83+3MbZ/kRhTJBDNYEeHHYzzICv5u4n9+tV0QnA4J+CtBbibBYR2X5+8a+kmCYPNeolmWIXiy9CUPcq5s
 CjtW3abQ
 Yv0AfJPDOeBsc0vWrt26gmuOci4ab9RvjM/VhnBQkrsj7U096zHyW9xwzWbDogG0h6mJ9bhjouq3tGKD4k82a11swJOhT7cYOXTdewVBAQbV1DlDHfVRkimG8+Wb6Ukdo9eFfQQWvnv8wjbaIMk9M3y45EPyBK+f9nVyhXYiiwG6nH5y9IgQ96ZDh00LFpc4KL96lCV//14QvgWqc0PPGIbCFsr6pWdMWMLLRYqxZaW2S/UeQXuAN9XdU9E9nQ5aRnAaro+XEP1PNSai7NV+U7SIuB7bEn6xLFmtwD954ZJqRoDiLCcA7DUgXHdEADz7QCzcKH2aXhRHaHIH0d1KI5GGsDw+W2Vc21TMtW4BEn4EWRgU61b+2w+zPmuJePY+mvN6IuV7gmaL6l0iyT4zPp6wTsXsKF95RtkKwyCG5mq6mDqRIMTKQZ/eXzZ5sTH7nd7QM+ZNfWW2ElpSbFenHQTfSzqApFGd9OFcjEOIlvh91gyP6XOmiA4kKmPxbka1+HQFp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

When the swap entries found exceed max_ptes_swap, the loop is left via
break with folio still holding the xarray value that encodes the swap
entry, not valid folio pointer.

That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
plain pointer arithmetic, so the trace event merely prints bogus
scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
dereferencing the tiny encoded integer and oopsing khugepaged whenever
the trace event is enabled.

So when folio is the swap entry value, simply set pfn to -1, just like
exhausted scan naturally.

And the folio_put() has maybe dropped the last reference of folio. The
trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.
so using the folio_pfn() before dropping the reference, closing
use-after-free window.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 5a48c5406cce..7b526528f85b 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
 
 TRACE_EVENT(mm_khugepaged_scan_file,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
 		 int present, int swap, int result),
 
-	TP_ARGS(mm, folio, file, present, swap, result),
+	TP_ARGS(mm, pfn, file, present, swap, result),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
+		__entry->pfn = pfn;
 		__assign_str(filename);
 		__entry->present = present;
 		__entry->swap = swap;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e6947fe142ee..6ee0ad13a31f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2690,6 +2690,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned long failed_pfn = -1;
 
 	present = 0;
 	swap = 0;
@@ -2722,6 +2723,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			failed_pfn = folio_pfn(folio);
 			/*
 			 * PMD-sized THP implies that we can only try
 			 * retracting the PTE table.
@@ -2733,6 +2735,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			failed_pfn = folio_pfn(folio);
 			folio_put(folio);
 			break;
 		}
@@ -2740,12 +2743,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
+			failed_pfn = folio_pfn(folio);
 			folio_put(folio);
 			break;
 		}
 
 		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
+			failed_pfn = folio_pfn(folio);
 			folio_put(folio);
 			break;
 		}
@@ -2780,7 +2785,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
 	return result;
 }
 
-- 
2.53.0


