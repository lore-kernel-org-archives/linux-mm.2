Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08911C5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 05:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44906B0338; Sat, 15 Aug 2026 01:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B247E6B0339; Sat, 15 Aug 2026 01:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33F76B033A; Sat, 15 Aug 2026 01:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 725436B0338
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:20:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCB78802DD
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:06 +0000 (UTC)
X-FDA: 85102352412.04.C098D00
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 061F01C0002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cQTq7f87;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786771205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yDUp3cp/r1Pc+NMXZTiNUemFBBGGof6Vn7/JKGoQAI=;
	b=B2hPAMWYOTBmGBfxb3s3F6wCtW9oqvJ25tzCGBhB05lYimy/rxpUsGw45jTq3JkAOwhzaB
	3JPxRuO/IpLvvVPT+sauKgM+gOJuUP9A7mZ3qDxHVQ/kM/EB6XOransoRNqel7Y0kUCLDY
	JqWvo8OLKzkcyrEr6WD5MLiiNHdtH0Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786771205;
	b=Lk32yCQgmP5IYlADnhIkq+KoYwuIqLL7f9T+pbyvUZbeB8KEElwW+9IzNDjauNSqv5A89x
	zVSaqrh2+6ewXpN9xaC4neO5WGYWaicHIxde6IKm/mjPojRtHRjg1rEGYa5NZy8aSfsIWo
	QG9X99NgzkQ9iqg1w2VSEmV93tdXRto=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cQTq7f87;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38511175ad3so1669055a91.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786771204; x=1787376004; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/yDUp3cp/r1Pc+NMXZTiNUemFBBGGof6Vn7/JKGoQAI=;
        b=cQTq7f87/XUP4HIoiptpazLZXZf407Ls5e2pb5CT7J2WcntGbXaLj864kwLwkoScyY
         aG4QsTKPA4JCVdWHhQbBe/WX2yR9fevC6TTtNo3rjmwahoq0z2ZUL7ptsu2oFwnWhjC/
         wW2j3SKtAsBbQdUbIY/rJInuLRnl3t9RAR4Ib+lc6Sapw8BRg2iH3CgUB0T7xW28Fzle
         f/Kj+jsiDo0aMj462+5275tMpiyH+DnagY79fQBKSxMQ73GQLHTF5Mw6mnaWv042R5aw
         NiNfWbpnKUp8nxXt5fEAjZZ3vT83TQYk6E3DsMs8nQJvwSGs0FtfHsZfA9Ks8huC6reB
         Bq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786771204; x=1787376004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/yDUp3cp/r1Pc+NMXZTiNUemFBBGGof6Vn7/JKGoQAI=;
        b=RE7HIMYD8WbigThTDjVdhbu4ru5JjpfcYyLbFnZZf/TOfQzES2m6lWnJSLE99Svxwp
         cize1oksgUOCC5/hWmhVdof0hWm8C2p5iL/aqoLbICVGjqyX2tSK3TRozHOFtdsk5aFq
         DZvORqE7/8nj8oLSlxghli2FNiAZhdOJFzl/AxzvlpAkfKahF2vXIRLBQoLuS6LyYL4a
         P287MwNFQ2y5IB3S7ismfW9CgzROxD0qYD20C90EgcgPSmMBgJZZZ9moLYCbOiEg/jSJ
         e75iKCa1Wb+sh6SQtWq1xeVQLQKxarZ2Fx3WHAJwVJHE5nd5iiPdKI1oEs9z/FR5VT9l
         tunQ==
X-Forwarded-Encrypted: i=1; AHgh+RpEyGrWn/pkIMq7fqlJ7bUBDDrWsILpNNFiOFIOsD6S/vLIaRblB40520rFlpPsH5mLXX3EiccG+Q==@kvack.org
X-Gm-Message-State: AOJu0Yxzgyi8ueSi9kGk4qKZlK8dRxhD+WmRLxQW7hOEXVJhE+x7p7Fl
	88NXAy+mbIsSfC+G5iGFL2By+D52z4AYapch3dOU4fpmY2S4UAFUZs4z
X-Gm-Gg: AR+sD10q8ZSvZCv8hrzPior3RCf5b+2hIb2rBWdj9koApUAW9KgNUXUx/k6lKXSKfpr
	JzbIfuOtV/Z7EJwATkXDQShgDpBk0e1aRa00C186xFqr2IFv6MaUlXPpHi1/FZeQJYTQELi7O0m
	4MFCX4p5t9Bg3lzX3+D1yEeXirCFN8ACWi7SLPIl0lDTBHzm1kJSiTqIKSl7GspcS0YWUFGwUJN
	ULfyQeg2fFCw1uIivKjVik13Mb6/TIiiLKqgrNnqT5CjlJ3Cy3L/fcx4/Ob1Mc8wU/BF6chjayT
	z10RV+zq+Ob05vH1BylFGVm0TgH/Gq7qXdJQ+YTAfhvlyfH7+NE3+nGiI7fqfkV5fL7nrU1K3hm
	E9QIlQTNXx+BUqQFlHDK/dN90a13uM1+UCQHxAtJlWavA7k1Dc50w52lfboZM85EZr691/wXx+i
	deManwhU0OFRjXjsxJO166wmDKH6X+ZBPj5oNuiXkurEbK2ozYePqWD96YZsTs7/PpL+e0qpCmF
	EZzeOpgBl4=
X-Received: by 2002:a17:90b:1dcc:b0:38e:6d4c:14e6 with SMTP id 98e67ed59e1d1-3933b77c874mr13623090a91.3.1786771203820;
        Fri, 14 Aug 2026 22:20:03 -0700 (PDT)
Received: from localhost.localdomain ([49.79.111.198])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea96c7fcsm5269702a91.3.2026.08.14.22.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:20:03 -0700 (PDT)
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
	Vernon Yang <yanglincheng@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm: khugepaged: fix swap entry value to folio_pfn()
Date: Sat, 15 Aug 2026 13:19:22 +0800
Message-ID: <20260815051924.194810-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260815051924.194810-1-vernon2gm@gmail.com>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 58bxqwqgjocwpkmumwcdmcnrw6tm79ci
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 061F01C0002
X-HE-Tag: 1786771204-693777
X-HE-Meta: U2FsdGVkX1/ztKx3pcpPA+V0dDaJqyEgYiJZ3PfrT6iOOtLXYhrDFp87sRMBN6emXuHPkcYUq1gMaxX7J5fCQ4hLyfLLtrJAGh4FJEm9/X0GTgd71uRbcUGL4YnCmaoOxu/QRnNgisj4SH+AIXHaQ3yhHIpK37RdeNxVcm+Q0OUm22vx8roFrhvF9/HgcKjMSKCTZHVPutUOvYLuFg9G9/0iuVjMCbGaXz4DyxsGE9Cmuysd6bjPbXefa9BpwTUMHa1v1dW1ooVOxULOv9E+LkNs4q5Kl7cxPxh3Mdp6wEqg9WtJwksgkFZaC4ZVzfwZHaLeAewxe04kX+bJbg3p9zsWev9tQPQuLFO1v4qUUjqNMcSNP7FQHw9q1CZ7cJOxTdeJ5xpCzBidpZR+hZcy66VUaTqS8LM3mIy/BvBx50XfE9gwA1hgbFL+tUkMxT30DRUIN0IGlp9uXm+mj+yrw4LGm2EL0bgmO+PeibGN8kBENp6uAZw0miOP73VNHenBmXx6G54FgEk5N9km982Lu8xXHh4hbxeHbAdAZsOs99rQiVvSkABLPn9ygsaNHVunyZiEUvkxDn3TI5qPkE1HhfYwzq6mqquiYjOpHPOv56gEc9pIeX2kCiQGqWkaCCznDv3xR9xaYkg53dEdzophoYwc8XKeNQvgOFTbgqlsw1ZCoRl4HxUVkW2JZSJ0/UYihmSKOVaYCynUKGBumfJ7gllvDOe3IcvhuUN2kxzpOXLdL/QSjj7OWfn7wCiWPvVtkDH4WzDa6jS0QAj8Jy+18LdTAdkV+JSLPjRswsYamR4DRDbn3f0gXCUD10ajHjqcf38Uw7xxBEnT5YWGVhYsJEF9dPG2GsSCNZ0ty9AtzUEwuYFOByiLLQ7WGO2yHXCoTe9aYNy8k4X8rJ2T2cUgkpRZMwCTKUREvq74DuE4JVByOocrL/7pmVBSD8wClCGuQJ+ht+VQ0t+dXHJgvsy
 C/TRVFlI
 d8PF1zsw+L/1jZlRB7iLQU5nVD9WFti0Vg0fZKLbtxLJ0gF4ZZbh5FSBuogR02b6bWv5wgAq7IMT0mTxr981CWFL5Y+R1d4zNcHTFnBk+GFw6Vb5RNv5+5UAjxb2iGPtcrPZbZ1ujipoHU4t+8JHoPnJ3QXbAyjuAY01/BoXX3uMLrMA0GFTccH0yr0zuBJiPVn7GXv13NyGbDqDpCrjOjfYOAUX6UuKeFGhYIAKcZuNmnxKrzV4ZC7eYI60czyisF+kOlRRl0C8TtfQXHk2jQV6wbLcTn0XP3jl+jo9PLlWHqasf5aGcKcTzfFWdc268qDqCAHEKgiiTe6p77/xPDeRJfO3vCrh5FqeRFQfG3v929VxQJfb4f6Jc1DV5teySShe9HqNX9DwxwWkjPZP1/WE0O3+JDKRqmXUl0NcwPV3nHLqi1tfTcwt8xcyhadnuiG3GGGDmVAzeXr8=
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
 include/trace/events/huge_memory.h |  6 +++---
 mm/khugepaged.c                    | 14 +++++++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 291fae364c62..d3572d4ef453 100644
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
index 617bca76db49..e7830761d3a2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned long pfn;
 
 	present = 0;
 	swap = 0;
@@ -2720,27 +2721,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			 * PMD-sized THP implies that we can only try
 			 * retracting the PTE table.
 			 */
-			folio_put(folio);
 			break;
 		}
 
 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
-			folio_put(folio);
 			break;
 		}
 		cc->node_load[node]++;
 
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
-			folio_put(folio);
 			break;
 		}
 
 		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
-			folio_put(folio);
 			break;
 		}
 
@@ -2759,7 +2756,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			cond_resched_rcu();
 		}
 	}
+	if (!folio || xa_is_value(folio)) {
+		pfn = -1;
+	} else {
+		pfn = folio_pfn(folio);
+		folio_put(folio);
+	}
 	rcu_read_unlock();
+
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
 		cc->progress++;
 	else
@@ -2774,7 +2778,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);
 	return result;
 }
 
-- 
2.53.0


