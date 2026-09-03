Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE915C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4F4D6B0099; Thu,  3 Sep 2026 09:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00606B009B; Thu,  3 Sep 2026 09:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15536B009D; Thu,  3 Sep 2026 09:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87F646B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:48:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A3BF120534
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:48:58 +0000 (UTC)
X-FDA: 85172581956.23.552550B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81FFB180008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:48:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9MeGmA2;
	spf=pass (imf06.hostedemail.com: domain of syzbot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=syzbot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788443336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6To+8fe2xKabaq6LuBCZ/jPSqRixKgPLH1mPUnM4bHo=;
	b=ywn6xfctBIGz8AOZJgtW1m0du6my1POvgfMyMGwcXzDUDlG/TrguSvrr2HyNtu+OG7i/Q2
	UM0pYL4d2P6rbQi5kJGGEuJ0gsbIkjNoWeXLcV32wd2plKv0aCv0lmbRw7Bp9No+R4F5qf
	1+Jc6WrzYncxM+pZ45qbnnQgeFs+wzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788443336;
	b=z3CUYyLsjVTRRqdAdF+tq0a6Yyuxz8IZaFgmYVOW2Zn5Wm1Mg+QXoRykxNTj8NYCyDTsdg
	O5VjCsuU9gcQ8PyAzRX9VJajM7AJjev8wBLjXEs7BblbfBF2HZ46MgSS45jgP0xqxhiQx2
	o3GRufCVk1NToROdB01MC9xNi1cb2nQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9MeGmA2;
	spf=pass (imf06.hostedemail.com: domain of syzbot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=syzbot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 9B30341A20;
	Thu,  3 Sep 2026 13:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 26F671F00A3F;
	Thu,  3 Sep 2026 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788443335;
	bh=6To+8fe2xKabaq6LuBCZ/jPSqRixKgPLH1mPUnM4bHo=;
	h=From:To:Cc:Subject:Date;
	b=Z9MeGmA21BkOeddjLE5LR+XMcG1y6ECfJya73DU/Sz4bHhlqCXj9ITrKmN35Q9USh
	 9qcDv7PZgOTejj2ZGZ3GMj7N82R6dxusbEjROgDFwnjcGW7Dsc7h8dK8K8J1RZaQuG
	 tzLfqGgTZqj1uHoEqyedjDD4zynzhcK8sDLVyERsZQuldPVq1iTS4+ae11s3Uba+QV
	 wjizbqXtIE0xB4UAr3wRcV2gr/SDYnfcourzrSV2lJyTbclsxpztfBmiuZgU371VeJ
	 jwiPw1HfSLolZiiF1UgH9xGXB40nQiASCwYCyKhlJMhYwNy7xK+w0FYhXTyA7qZ4ND
	 nraERTUl1ykyA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, "Matthew Wilcox" <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] xarray: fix index jumping backwards in xas_find()
Message-ID: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  3 Sep 2026 13:48:55 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81FFB180008
X-Stat-Signature: m1fgc5mabzrnr1sxm5do8swyqet71s66
X-HE-Tag: 1788443336-767819
X-HE-Meta: U2FsdGVkX18p3H/GmcSTixfCEallyMrGLF3KFuzlkmQP6nSHN44ZO4vrPbPZ9SOe/F2dZ8OBGwvbo2WpIYTDO/W/s4562ULWtG2Cu1Lbd+AmnjDWhzTOlQVZO5BkD19JfX/MASxw2a/TpmdROfBph7mH77j8cbEaY8V5HVLmMeVN1Vtaps6+sgSkxsOJjTHIq1KAJkIsP3mv0VBVorJAyI4ZIrqpTMJpmT9E1EzNoUsSsSwXfderWwLcEBSeaOXqOUDIlKMpm7JOY/gWezeFwYAT4cfAK61zY46HvI+ncWrG9sadrMgYniK4bgP6IN0ieFz95f8UPHf3STtUHErPHN+MEoAjoWd0QGnGI1AKHlJYm2ORp1QItNp7aY7wl6W9AC3m9yH0flfF9R3lBO6BmfpqE23HGYieFi30I6C5eVJrRIQXv97J1nLvk/MDmVUhboaArEtFu+yiREuFV6fY86e4/MHWnV0Sd1gYKBGFJIj569sjAujEBRnmRgIP4e3hEwyKMKnthhHZBDJrhssvDbaCcwdquGm1yKlJEAbiGeE5SIpzlciRMdbXCK1iIG4nX+9SUgQBZ9dyBQLYezScdf9N3nh/P/Up/JWKimrEwwj2DgHieD64t2FcTxZeKKuHR+c9qaqXdJMfeH4/A39PF2uJZMRIMtvFT7WMs/IEiO8h7wsXIx2qqbL5equfV1F49qeimBedoyyyjA9Fm4VCRJd04bV7HKn67HcvrpDiLGc/Yq1TJvc+e1lELMvXrnq+FrvshH3dVJan7hPzXCnICx38n/5LAenNYbQ4SkNqaTtjvVQp4NeDrRKrQiIIUeZCMsbh9douwTv+0RjcuD6aqE4hX0ViAA4alDIoGEZbg/7Nt9lKWOo5cREQJg8CcqHY21ZQsqUuBJauY3SrCkgukknQjUL9PzzFNxlr+sIE/T9TuazOjkI8+cyAhx2uczcUQqMYvUxKtBE5lhAChfm
 eCisfphZ
 JdNX7YQfWIMjDOEkGdU7bT/X2kCCz6B2cAGli0GiYkIFd9s0NIQv7jl8X6fKNOKeQnJJLddyAg6kaiBuYRDValIa3sHGZprCmHdP3kH5piu4dcAWeyUmVxIJJoqeHTO3NvKKZZhMRpVRdSjZS2mY4nvv4PVg83isuBcNkhgHuw2APIUrdxdNiojBXALGkU5+Yo4OUD5u/wEe+fb+n08dV7H1PeOT2zUVM0mhm7JOrDSY626KTeKIcFbE+PMqyeadaLrh/HgVk9nHqHyf6U3VwVaJqaDfc+fb4MUwUH8DVF0FaankODTGlbVSdjG6KO0EJw+Yui0VRIpPlk0qUgdRZovk1fYHmNlRe6GkUimRZKBgFD8jvo7GN1dQPyLgBWFV9w2bg+u95QlZv0V+AR8d4FKZIJ3ZoFdJyE+RktX2F1b5YN48HxYu6X429nNLc+1iIciEekVEaCFytXVS0OMFDolnmHVxFg4VRaqK0w3BzFTGE9JzLL29cm/slLmcgowsLQ7wXX8t5P2nZ6BZWXAyrQ4eqSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

A bug in the XArray iterator xas_find() causes the iterator's index
(xas->xa_index) to jump backwards when iterating over a multi-index entry
(like a THP) that resides in a non-leaf node and is concurrently split.

When iterating over a multi-index entry in a non-leaf node, xas_load() sets
xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
the requested index. When the caller subsequently wants to advance to the
next entry, xas_find() is called. xas_find() attempts to synchronize
xas->xa_offset with xas->xa_index before advancing. However, the fixup
logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
Because the THP resides in a non-leaf node, the fixup is skipped.

As a result, xas_find() simply increments xas->xa_offset and recalculates
xas->xa_index based on this new offset. This causes xas->xa_index to jump
backwards. If the THP was concurrently split, the entry at the new offset
is a node pointer, so xas_find() descends into it and returns the folio at
the backwards index. The caller (filemap_map_pages()) then calculates the
PTE pointer based on this backwards index, resulting in an invalid memory
access such as an out-of-bounds read or use-after-free on a page-table page
freed via tlb_remove_table_rcu().

To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
xas->xa_node). If it does not and the node is a non-leaf node, set
xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
Also add test cases in test_xarray to verify xas_find() behavior when
iterating over and splitting multi-index entries.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
Link: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

---
diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee..cda7245e4 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1247,6 +1247,67 @@ static noinline void check_multi_find_3(struct xarray *xa)
 	}
 }
 
+static noinline void check_multi_find_4(struct xarray *xa)
+{
+#ifdef CONFIG_XARRAY_MULTI
+	XA_STATE(xas, xa, 100);
+	XA_STATE_ORDER(split, xa, 0, 0);
+	void *entry;
+	unsigned long i;
+
+	/* (1) Order-7 entry (0-127) with adjacent entry at 128, starting at 100 */
+	xa_store_order(xa, 0, 7, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, 128, GFP_KERNEL) != NULL);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != 100);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(128));
+	XA_BUG_ON(xa, xas.xa_index != 128);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_erase_index(xa, 128);
+	xa_erase_index(xa, 0);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* (2) Splitting a multi-index entry after a lookup begins inside it */
+	xa_store_order(xa, 0, 7, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, 128, GFP_KERNEL) != NULL);
+
+	xas_set(&xas, 100);
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != 100);
+	rcu_read_unlock();
+
+	xas_split_alloc(&split, xa_mk_index(0), 7, GFP_KERNEL);
+	xas_lock(&split);
+	xas_split(&split, xa_mk_index(0), 7);
+	for (i = 0; i < 128; i++)
+		__xa_store(xa, i, xa_mk_index(i), 0);
+	xas_unlock(&split);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(128));
+	XA_BUG_ON(xa, xas.xa_index != 128);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+#endif
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1370,6 +1431,7 @@ static noinline void check_find(struct xarray *xa)
 		check_multi_find_1(xa, i);
 	check_multi_find_2(xa);
 	check_multi_find_3(xa);
+	check_multi_find_4(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b49165..980324d68 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1406,9 +1406,11 @@ void *xas_find(struct xa_state *xas, unsigned long max)
 		entry = xas_load(xas);
 		if (entry || xas_not_node(xas->xa_node))
 			return entry;
-	} else if (!xas->xa_node->shift &&
-		    xas->xa_offset != (xas->xa_index & XA_CHUNK_MASK)) {
-		xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+	} else if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
+		if (!xas->xa_node->shift)
+			xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+		else
+			xas->xa_offset = get_offset(xas->xa_index, xas->xa_node);
 	}
 
 	xas_next_offset(xas);


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.

