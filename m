Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B8B0C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145936B0096; Mon, 24 Aug 2026 05:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0456B009B; Mon, 24 Aug 2026 05:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED97A6B009F; Mon, 24 Aug 2026 05:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C06216B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:30:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F7BC1604A7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:10 +0000 (UTC)
X-FDA: 85135641780.24.0D3B533
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79C9B20003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="A/w/qKCc";
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4Ip1jEqtN/coAyik2SQv7pRhr7t2Z+l9dqjS0wG+sk=;
	b=J1kd2TkJyoQuXfMN2m046H0Gvj76Qm7y3OOg4n1c52qJzSVNfnLmxhK0h+7Gy/K4p2134g
	BReSDOhkRKcKH9pKJfrcLN6Ck/v0ant0B817hSiIC9GrmlyFWEFCJ9dUsdFQEX8h6EessC
	632joKkIvX4QIHlPo2x0Z9oKDy27g7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787563808;
	b=VYdFtYRZaCRnLeeeE/q5g7Ktx75Mrj32qz3l5Nz5Xxo3iRduOxeIIn6dvtLgV7Ww2iMSEY
	KE1i/cDFXz0wOABxxxEK4Aj9mDj4295+Du41pEnrvfc4oc5qAmtAEETdYVdgFvseJ5wNC5
	PmOQDCH9hJ4TOhrJjVmGrNac6WiQDk4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="A/w/qKCc";
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so2327687b3a.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787563807; x=1788168607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S4Ip1jEqtN/coAyik2SQv7pRhr7t2Z+l9dqjS0wG+sk=;
        b=A/w/qKCc9KPTrUUznYlzcDFL5MxrqOq53xvkulrV97FWq7ZZ250PFA6MzoxTTVchLL
         d0vvzMJbVMkdN1svqwNSIL2BohGoazLKsTrSDFjwwditDXrWzg8gb0CM6/p3BTEkkGzF
         f+xesh3OMmn7dvkYHD+T8/No9QFj9TVCZiToKUEgWzsnSEww+oYlVDKB/9u+fpgUhDmL
         irOuS2QgLrDRYN75qxZM6avMfghXSNa78dUnGU2GXwJ2Ef4wKCx1YIuktJLqTWZ0UZNj
         TjwwpwHfgWXsMl++XwJVsFAFA7vSh9RwxHbE7PdxCPIkT7DVa7UmMvIAA+iOMXOB0JZv
         RpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787563807; x=1788168607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S4Ip1jEqtN/coAyik2SQv7pRhr7t2Z+l9dqjS0wG+sk=;
        b=dV196sh+e+CQJAuJOFSyUzA0EZ7gAE9hzwrdr/JdGvsB1RS8YSZjiJWIpv5a3HtH6t
         gAkeXs6f2ULGkzONNYf/IP/qKmHt7vtGCZwq9bcwIJ4QplSMnnEtR16ak4c0okfmGzcW
         tBEuXNv8UX6J9zPvMb6duvL00MjhpoAiEmq3mZvXG6Zb8ZjlE7IQZgK8y4vSgw/1sL/z
         WAL7paOpxJZ2dFy/7Q06zp6ALbk/GqjFvwnpU2bVUn6YYfv+AWxQKiZ3CzGYkxdrfm15
         JF/i+kpPowqBBV+J44bcfh9/ui48Mv55kqy8LLsJnAyWpLC4k98/oV7uyBQb9G/ZnEo7
         mP+g==
X-Forwarded-Encrypted: i=1; AHgh+RqBHinxvFC6pQxe/qSTxSJPfLBzzHzLkXcWjnRymwrYAARIrptivGu2ErphFkIxQYlpxIgi1eNu6w==@kvack.org
X-Gm-Message-State: AFuF++k9VtggSma+xVn0FNWPpvgaHX5MuMKxodctBx6yrDz1bm0MvZMq
	1vnIdHwIIedtwTmwVunnVNJ2krTK5g++EG5BSI/mRGXfJej2yPnfJlLq
X-Gm-Gg: AR+sD12j6l6YwARXM4PkZN7JFrdIDmj2UQOeZb4ptgjUKAEg5BJd7YLrv5Lwu5CqJOJ
	t+nn/HBgSQVZhquWoAZjr/1I/O8mzWJU3AP+/Kv258evXdPLqimwJ2+n8GPm3Ksf6AtXHIWjjCK
	omIqKB3/wnOfmpAG7yi2j2vo4HuwbDwYFlKwp74i1BNR4k8oTCDnWekPDk2a11IVStQd/nC86oA
	klXeP64txHPndqxnT0zyDf8ntoR1zrzEvb8ymYlEKsq+Gjtc1zrMH0EiM9QvmG9F15OBsxUR+RG
	s1AMsE/JS7XXvZ49KUNN4QLBPPrm0Q+9kwOkNsgdDkSlPuJszmxbGafyEtM22UPHpFxvtCXlf8S
	qTXeEAtLLoxs7XTgqWJWfRSEPX/W+OG27FqupKsTCfZccJPjEfocnWpGny2nOzMVnsD9vVrPhnZ
	cAnQEHKgzcPxcvlYit8wgeUEPySqK/JDnL+uOpOPk9JuI4j6HuDLfCzgiCJfY8iTKAKHeAyYcX2
	Ts=
X-Received: by 2002:a05:6300:14d:b0:3c4:3767:adb2 with SMTP id adf61e73a8af0-3cd2fd4d873mr48989218637.1.1787563807262;
        Mon, 24 Aug 2026 02:30:07 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc199e60035sm845226a12.22.2026.08.24.02.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 02:30:06 -0700 (PDT)
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
Subject: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to folio_pfn()
Date: Mon, 24 Aug 2026 17:29:33 +0800
Message-ID: <20260824092935.73892-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824092935.73892-1-vernon2gm@gmail.com>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ua17wuukkkpm3pjgxsoar1ej5dt8znh5
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 79C9B20003
X-HE-Tag: 1787563808-502905
X-HE-Meta: U2FsdGVkX19XK4oO47/ZNd3digfJJ5T5r5qCcCaCp+SIAbS95igXamrqDnMNqZdqhkBWQCucdb9JQrEMfTS/Emi7qMzrW86Bl5uHWRkcZbkkhWKGpSz3TF7bgsxOOBoFyrKgXteXVKDo7tZvz/Ure8/TXaxhiU4yTrvXGy3FR83bbiHHs/iqcQa7r++su+jXe5LW547GFaHQoLSACG3a6D04uDgmgbD/UiHASbfnDpOqC0Afj51mkR1D1ANqlkjsJk6K8HAxjoi22DrEniCsNgepbgk6hayBX9Uq5pGJe1UbEjp95a7/zMALiVUZkEm5WR03hRp8Jx57KWj3PiZj738NSh2DPa2sau36T2zkRgDsVn+0Gh1p4/q8JB6awQA8TTOyKrsnGQiV4dHWmDEv4Y4GA5KH4eI5UVvDtxRCNxsgXliMREuM3tWjr9oxxr5psEKQnSHcyzdBX3piI5p4NUeyQbYOY6aixPBsGj9HUpEVfWjRxc2wFg08GXS+43p+jgol35wcxEiHvZ917YLr/U4gGrhgpENf9RBuPtVP7QwC6Q2v78WndYYH9kealIExJ/QfGrgnNfc13TzusOsp8iEr5czk7SBJmkVb7+rZ4zhrNAqPKm1rz9wn2VKucrEARGqKf5s+vZVh/JZtQyGZ+e6z1evz/2WQQzzoToiiTx72W9sYlZZG68p7dNU0oWjxUU/58oQdXkKHN/sDipd3zq2mWWP+yGI9Je1O7328hPiDvXQHuPHXZ8NbMdVnBjtzojZsBIHTZqEIA9vXEv5Y0phx0gZn4xAUDRIYpsekdmnEAEXjRR+3vFsvYlnb21U7/qOiaySHykPqC7PNF6JkcDhke3nS6XMb2lETKtbgiZpOaBJhz7ES5krEDDBuClRYSerl1muk1N4UsZcNyAxn8cOAB3zGnqEww0bs/OLXMA+JlKkccMwzBJOOGJ51MEMgMh1rcI17Ju9cosBfkSc
 Jbwh98e6
 knBN4KqPDqpMYL52McYYamXA5XtFUZ3I7+jrM/94TSRx9AQuFg3AEE2y2J7xEXSpFGXWjePEExY6z3kN5GggZvmarmNDNZQe5J0vXRONIW/3392Zd6JMoCd3iL5kKmH6FY7PruiX52w3bJ8Pk08rZ0Lz4D+A0/S/OZm41y3vwLY67H8+aSoGILV4NxkA/24uXs0a2ELxTyXwL4NtWhLAZTvenzyGSajs12hkUe/SZYppHiLZMuWAlDmexH/+DClxr1TYf6incFJ29UQDyDeMsZnm0E/T1c88JvfkfAASriFT9cSuDkjCFvvVob2rSx3ufhy3lZ7LC9o5fvKXgWazwo2aRqyxfDsqeqVgLUv3MwecDKpVK8YCWAtXf709RF8+RJ3Wpp4+yyJbOLYej7/46e+fjR/hSrWR1J7mOlmyeTPtfFg6eRAw0MGGVd7RuuKqvilATtklTmfonQpGKrgokE8x0XPBojjd6lnTI4BrybQwB9iI9DEMWzP4u9Yt3+YFicYbW
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

Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

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
index 79effd3f3da4..00337405c0e0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2689,6 +2689,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned long pfn;
 
 	present = 0;
 	swap = 0;
@@ -2719,6 +2720,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			continue;
 		}
 
+		pfn = folio_pfn(folio);
 		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
@@ -2779,7 +2781,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, (!folio || xa_is_value(folio)) ? -1 : pfn,
+				      file, present, swap, result);
 	return result;
 }
 
-- 
2.53.0


