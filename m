Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE04C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71BD6B0092; Fri, 28 Aug 2026 01:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21946B0095; Fri, 28 Aug 2026 01:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA536B0096; Fri, 28 Aug 2026 01:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7CAE6B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:59:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBEE7120277
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:59:55 +0000 (UTC)
X-FDA: 85149627150.27.09C5DC4
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E87740005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:59:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Oarq/594";
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787896794;
	b=AiV0PXmund07HUNqnacSzfr5BN1XgU4N6sV2yDD4Y/OW0laWJVrb0ga0McByH17Al9ahNQ
	yLGKAx3WHgu3LBTGh+jIr0oX1ZvHYDXEkWQrfaJ9xY9YuHyCVNOh8E1mgD65GcFd8BJbvK
	WT48GXZBtjGeajxZp25qD1v3n4LhKHA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Oarq/594";
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787896794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W67g2+Dtuws6uyQi/Oz6Kv22fM7UlvitqiW6NCwEKwg=;
	b=dXYagTWjSlQV3eek8npvcosGpX5qFaqBfB682T3wOl7dxC2yCwrGOHRw0e7yp+1qrJkeRj
	PUcLmV5dBL7G+055rMfIFuzDeW2k9w5JDqQ67NcjwycxOaapi2P6ThydLjhE7KNzPNJuDd
	ZJa1SeDu4j1KL0CEqLfk8Uz9l06PGJg=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3969e82ff8fso619163a91.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787896793; x=1788501593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W67g2+Dtuws6uyQi/Oz6Kv22fM7UlvitqiW6NCwEKwg=;
        b=Oarq/594wm8Imv2qUdXvnTuLBz3j2edY2Y8rbKQUPueMCvylLRSpfM46XCTFkKDcsT
         HzsaPVBcX6kfhmu1V4pQmA/L9p+UsBe6HemRqBCv+nen+XUkXEk66+8t6m62aXC8aeqP
         IWOUPUu0qCOmPqjdPD8DmVzz7JzLTfuSqFK5mtHuU5o5qt7VqoMFiGjkefA9jnvDCYck
         YVRLZS/0haIWK4PXI7w1GrjHfN0ehLS0OcDoBXTDTNpqH58X7fWX7+I/bIFxILcR6t3H
         yOHCcoEW3Bxmr7FiXRMZTmffm64zyzEpLtt5xDNSlXXnMz0WEf/ey36VjgETjDPPGdoL
         uO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787896793; x=1788501593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W67g2+Dtuws6uyQi/Oz6Kv22fM7UlvitqiW6NCwEKwg=;
        b=HLlwCksaFnyN6ERItUIC8lNs7wBWg9n1JJULKJyD0BEk3FvP1YOX+HOU5F5D/anopr
         Na2+evUHI53ShUXNts6OU3OQYOA2GWfOwp1i2mxV4h+qvuq6iNU/jM7LW4y1/eqUgpe4
         p/XTrl/VlnAc7qc4Ft4FTXmUfmRPWXsnXvfvP9e4nR7YYzMVaFjbiD2jfsepa9S8aUKO
         0b4xRb1koG/VdrWom9dtHbsKCo8nVKfYMsaJoXuSqUxbD3S4JO1DHLsg0lrgPvprZppT
         UKJsaZQORsfUBvRva/M3qiXLpmyq1MMxfoND6iCFtkC18wFSX2m7vqaPa7yfEjLdSqtY
         9OhQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBCppPdHATdXVdUsffyKXB/uW476IVWc8n8jq8ele9iwghPsgZJnKHQBtJIqiJYOSR5ZHtsbo77Q==@kvack.org
X-Gm-Message-State: AFuF++nORpfZj6qzfl3LE5noMkV/cMwMHCsJkJc3pU3E+4bOYWjNUUsU
	e2zvBXqyTm/PLVWBwCW/stdFFMlJbDcG4PI2fD2sOSUFrMldiLb/aa70
X-Gm-Gg: AR+sD11Cjq4+jinRQkELT2Dmr94nL7VyhZ/H5X/u9IS+noVGIbsnvosBN3yZ9nfYcED
	oVHlu2kq2Na/2TaHN1p5MPlnJhXACHYRNqrrDNsK2EX4ro1QoU9eLysgQTVtyvShK0cHgAlHAYG
	h/miy9Tb7/H+LkxX64uGH4JbM2U4LgnpVb94CQbBqfSm8YnR6FqklwHNeYS7MOV68p/7m28HYmu
	YnKGcp11BuSmqsRbJOiJQ11p3iTlWW3Ci//uIA+figCc7ZLTmo4fEoh9nlAbvtyLgntaNn0gIAe
	pK9GbWcMQpaBvTqxQUi8gEOK5oksFAzQ58dJ+3KlsjldHP5wiOHIODJbCkHTd7MqrOzGgRJ3wsa
	ZRhBx47ClxqaIVhK5EgD8OCJpt0SbJQ1nQpb4YylmIAs9rhPJJ5Ykccs+tZeejc/7iNu6b48lRc
	mjljblTlaMcZG6/KalD3SoaXdAZ8ba90rKFfwZXmFNsldm0/5k8VDyxwf2O0UmtKVWQ+tWeYPnN
	5DVjAScFt3ZCA==
X-Received: by 2002:a17:90b:5405:b0:38e:67e1:15b with SMTP id 98e67ed59e1d1-396d0de4c19mr9263684a91.6.1787896792757;
        Thu, 27 Aug 2026 22:59:52 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0ea808csm5826241a91.2.2026.08.27.22.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:59:52 -0700 (PDT)
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
Subject: [PATCH v4 1/3] mm: khugepaged: fix swap entry value to folio_pfn()
Date: Fri, 28 Aug 2026 13:59:24 +0800
Message-ID: <20260828055926.346744-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260828055926.346744-1-vernon2gm@gmail.com>
References: <20260828055926.346744-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E87740005
X-Stat-Signature: tzzyquamac31gcnrnbj3zpt76bjdberm
X-HE-Tag: 1787896793-967921
X-HE-Meta: U2FsdGVkX1+dggawbPFcaJn8svrdZgmwDkktbeBbgxdj3Jx1Z7CCY2ee3sd6yVDlEE1XYiUZrm13eWq5Ncl1VZwq7SeQ76oqSLvsRb9MYxT5fMme+IZeI3q0ElKLmkRj3jP0j4RFj/XC9ku81pbwhOwbtYqkvfSXwhEwbGtW/dz49GX9VgIMS+UBEYCUY3AhDokHNzCoPdRV9Kkl6kk6eW8twvi4vtq2oBVRQf4gTLeh0v3mJu8NOJ6SNzNu0xnKoPYwbHRBPIMzBpWPSPU1kdAR4gJBRA1TVj5hCY7+XJFQ5GQLCF9pf07e2R/BIAYX2hkLrq1e16qqznVdD39jabiOyEeo1H4OBtnvfZdttk4stsrSgJ2/ROVigNpDUc1qm0tjUh5mns1NONi/W9ZExLh3uRA86rxKiDwwIrKHCYONRjUitHcgE0x0ktkh02M3LMjhcEm8Sj4D2qHynn4Oa5IR4Eo18Yg1sF5iGkI79K53L2vwTtI75rAVub664Xjpm5Af18gxQCYK1hR1ZoOfiJt8vOg7b6LX7KcyndVf5MaTe+QOtQ/aRDEq8+ADwjRywvUvakhDTris6KdtmewEV2ON4y78rfzXpDLPAVXT66qhkeA9jydSl/N7ZTIYEkqGAYYtADkGSx6MFgcIcpbpFytvISB+WA/5JeCAYz0WAUhaJH8Sh7is85sJINg7UjBaHUikXnjv0LxawOWKdNy76phho+/vnL1f7aUWGfJ3yjtdT4JKOhlaQzOfSh5oQiQvza1SFcelgyMeNPuZ0QVHssTJLx4p1hf4S8OKSEGhZDkMkXVet8G29jeQ6t7Kc8YX2oxpnNT+uwyA0iO6z8hyf/v2H0xchrtPSlbl+2Kx7KUp510YmT/e7n5rD7bbfCCdbWyxqXlNV6NKbFXrLXRmGyBE7sj1WmsS8h48i7BlBRY9JScusridkz6SPzh/AtRd2PxHkL+DswWLWd76peZ
 UKiI3xXr
 57/zc6+JKc6P0Yer7SNYGIXAdIEHYHvYjCZYDuwXx6ADEikrE6FwNL+of1uwDsfgHVWPE2kJjUBAbDPy77zC2EdlSGiX8qg2YjQ6g2+5tMTyaUvvT88032woSh2uL1b/NBJlcLXUCVv23s5KVQs/S6QSycWSXFxejAz/xjJFe6Hx2Z7oxmOXSg1hNLdLSCWOPGOHxlhX6HFrK7kuKhUkuzD6KdhWPcCwTLSumDM26p4t5KBIyzEM/CzPTRGJqbK1Fy1cgpFeJP4Uc0QWTaRB4rO0xwLEUfXpcBnscpJaJXlHBtCBPJ0ubFVDjY/GZ5P+7RMTKFvfgumg74OhoSIZE8onWSWTOTjIi5AVgMRTXLUtQbyeJs8+miFWEE1AOmpnIWXexiw8C8mBjC9cTHZoQvTXb1Q9ISU7iuC/29jmuYs0yosAXgKtK6rdrW3TU+Rk85GUrFv385G1MlWRKzcuhD9/08FcwhYXS+AthVSoIx7kHJ5qiBeAkCvHndqvp9ER7koye
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

About calling the respective trace_xxx() functions separately on success
and failure, refer to [1].

[1] https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/

Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h |  6 +++---
 mm/khugepaged.c                    | 11 ++++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

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
index 75639298efc2..b597a3e68606 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned long failed_pfn = -1;
 
 	present = 0;
 	swap = 0;
@@ -2715,6 +2716,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			failed_pfn = folio_pfn(folio);
 			/*
 			 * PMD-sized THP implies that we can only try
 			 * retracting the PTE table.
@@ -2726,6 +2728,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			failed_pfn = folio_pfn(folio);
 			folio_put(folio);
 			break;
 		}
@@ -2733,12 +2736,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
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
@@ -2771,9 +2776,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		} else {
 			result = collapse_file(mm, addr, file, start, cc);
 		}
+		trace_mm_khugepaged_scan_file(mm, -1, file, present, swap,
+					      SCAN_SUCCEED);
+	} else {
+		trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
+					      swap, result);
 	}
 
-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
 
-- 
2.53.0


