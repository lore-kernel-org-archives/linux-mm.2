Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72FDD3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66C76B0007; Mon,  8 Dec 2025 09:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C183C6B0008; Mon,  8 Dec 2025 09:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934FF6B000A; Mon,  8 Dec 2025 09:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9696B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C9A51DF1C4
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:37 +0000 (UTC)
X-FDA: 84196554834.05.AE04F85
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66840C0002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gWaD8wGw;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=e9SP0T1+8QBCjJBHKElgO2TUG+1klrfqK3ioADSYafM=;
	b=vuy7WncezwFLBqSjLz3cgIzg70eDLItjieVmNDZrT8h3XEmv/4J1YRM3pXSHs0IW8QtbSn
	BxUWcDwCkvPSk0KSIBHcS3yXtsSb0ffCFvC76xpHu/vHd98/JCzYQddmuskzHo0u72kYjq
	5KlIGyUp5iPsuhZco6fpRnhxLRSBcRE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204595; a=rsa-sha256;
	cv=none;
	b=j6V5N4yyNN7Fyn3cyVHnZGSTc6OAkw9QSMfi+UQqTZRLj8ms0981EMH2TCUBUZzWEiLlVu
	mEGSm23AtzIWKutxrBbiQoHrk8xTL8WJQtic3mpAWdk2cKFPOGPLZowSZAKalk53qhJtOV
	rQtIi0nnUJre8Ad3icpm5dm+U0QLUyk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gWaD8wGw;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7355f6ef12so551561166b.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204594; x=1765809394; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e9SP0T1+8QBCjJBHKElgO2TUG+1klrfqK3ioADSYafM=;
        b=gWaD8wGwytuqhNSmQ9hjsnB6w5/kXQFmuhU5wwUxiqO2scxXeh8JAPIykT8vIns0Zr
         GjSlzjyx2jKKnmDZ3lzXSnugTmXOE+xq6JWc6VrVvFzm/YtVdSPlt4mrH81FXfLPptFK
         eicmV1vf4/uOrb0OavQ4c0LXsgJ8NPhjjBcKfWzWxnyL8LpMIeE4+XyujEedXeWC3Ea2
         LHpcohKkyZTdfvoTg85MPyW3fesJ5JsKqX+GXWJaprRz9Uag1tYcKbSShvirYFwjaBQr
         RPGf2AnhjIzztfMWZcVGi5O3eV5CCCxg/JXuyNkikzl1sK8+HBIymt2lszUtCLb9WonP
         Qcqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204594; x=1765809394;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e9SP0T1+8QBCjJBHKElgO2TUG+1klrfqK3ioADSYafM=;
        b=Fd7S/te51uF66btm8DArZW+tDDSyyui2J7jCz5kiN7VuwGqWUQDhrTWQ4/p1HmytHb
         g5zlJ3P7RPBVm6wF3A5bXbEiJbmb0cpGWO4MEQKOFltqiKzzNqxYaPEcHV2wyVlxcJV1
         Lm0UOA7+2nhf20ie00DM4444GECKbudRuUbbQ1eQ0ff8jguMCstJHRct/033Fvn89i10
         F5QaC7ZTqbhiTZB2Vrm2kHCInKUYOS/XoJAGWV5niJaY4sl1gZtixf7Q8i203bqS67Lx
         ee4LF9lRJSaTD2PnWZs+T64Nnb1uSi4yD+irwDmvQnD0PFUFnBEs1uTzV9uuswYG99gk
         99Ww==
X-Gm-Message-State: AOJu0YwXdEpji2v6poaynnsszAstjyiMDgbrZO6W6sv35RLhdHbw9qpR
	J6/uCNvi9P8hLm3/xtbUnQHB0gEpeqmZWWTD7/aGhdAA9xo8p1yGPKWz
X-Gm-Gg: ASbGncspmBghFVdjeiSfzyVAiT+R0PpHcmv1I9aONqQR+x9bCuZH2q+9lNI3PM93pye
	eqNMW2OzXJRfbfabuetk8Eufm75jxgmUmFhYnOskeO7jlZhZPsngLjP0iuQkhyz/RE8yXtnwrZl
	frP1ji/6iCZP9IH6n4seja/1cEVaTpQq/EcMixlTbAFScMZg96unNs0K8gID7bg5igrtufcK8cq
	ng+Upd7Odr5Iya/vTFFzD1wH4Vb7ODteKujDVS3woIxl9W9Ko4plZHGGsvHtPAX+SKpgEe5SfVF
	QRwC7zImjwW4z/pIsY34I5wxW04N/vk9l8Qgn6PSYBDlOW9zfUhMkbGEf5lKd3bS3B2G0v8VeJr
	hkUXQ8AUlly/f+HZ3FmdctglpMCtAom747f4gsRJZY6QqYJP7NHWrrC/DbdOfbYIkSPKMePsiKI
	WvLcyuww+xNg==
X-Google-Smtp-Source: AGHT+IEqNjKeBNlIS/Wm3s2NydVJmCTbTDvkFBE6U1wxZ+eNNdSlgL/llqPb8/t7I+r5AsLAbnONOg==
X-Received: by 2002:a17:907:724f:b0:b73:278a:a499 with SMTP id a640c23a62f3a-b7a24306ab7mr967759566b.15.1765204593481;
        Mon, 08 Dec 2025 06:36:33 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f49765f3sm1084790366b.37.2025.12.08.06.36.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:33 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  01/11] mm/huge_memory: relocate fundamental folio split comment to __folio_split()
Date: Mon,  8 Dec 2025 14:36:06 +0000
Message-Id: <20251208143616.20797-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 66840C0002
X-Stat-Signature: zb848gw7nxgx4az3azzx3qxnof3uk3pw
X-Rspam-User: 
X-HE-Tag: 1765204595-72605
X-HE-Meta: U2FsdGVkX1/kllKu2mo2OPz8Ft/JW+DWOLxpEjDMISThagjjx5N12svGpo2IXhR/cIHBV3+t57fMqV92+XDFpQLsrG1C6L5qh/yAizokwrVz4LIx9StzVZ5RmxTRbT7MiCbEpJeo2iAltPjGr622r18GVqWVnDrNpYSl1sbzhKiegd/mPaNWcz7aZQL0yIss2M5vkDYS0WjEOCS70tyTHjIfWJq/5fxhG8U/EYzgFaakgmxHo8LTk223WL8uUjny62/w6+cXucNP5KdCuuBh+OUVNMGFzWPmW6uMVqqqtH2iL1qZyZJhdBECtFYE9B0AsjYZUjIkwJWUfqWOY3O3RJyCasDFgcqOuyDtOPjz9r7M9xmxw4VsyLhLbUBGvcIxdUcvSYnGcX++DXuTKKLxbS6RbK5fbfYQPI0TEbkKN/aEXSp18N3tvjJbWoKob4Ptl/g19/RRfbz2zZ8bPJjYZsIuVrK09q+cnnyyjc1qL3Sn3GLmUa1VJYf2ZfsO2hNrNthy6MtCPL/tgGhZ0bzGenQBKsq47buFLtw/ae12W8cNrCKJo76RqRV+icpwzgIQCe5g1rJx0EiMsZY4AWnk47h+JJOj3EuMZTmkhv2sF5TshPJAuFWUVyc4EgYKTCshnrI+zOsRW4bj12mV999oRxtrI1RiJRN/hgnGw0t5x/suvqWiLiJ4XVnQRYnAhO09sn4Z0M7LkktPLlXv0RnLCyBC/keVZnzdnARLCc2jol13Z44NaU4gF6ovUN5Cyun/39frFuQNf6IevzxWH+M14ptOYJl/8g7P9bywc9CtNzh+wf9VRKOZeQktXRYYUUCUt+05KzvlyBx0pMqvK0mO7CT613iZ+X+5bqv89ejdxoedNMLCiMEXoRPYPZAHRxaKoIQNlzk+k6vI0BpJCgslVfr/qhGy3kdWAqRcgyDNQi3la4SZ/nbmhDfvuN8vGDKKAplcmXrwJN3nMmrfcMv
 fE2tqzgW
 ZdBPZsASgoDTTU+YYjMEgPw/fwfYrzKOEXwj4sbsyxq30gpfnsSdLzAaFN7cmWHgdfg9V+c8fyEGszFVKSz0eSJsJxNixG14F4MgMb6/ztm8NfLGUd0NBbZxnFakHreJc3N4dAm21VwiPO5YEw1zOFQDxUgl46F2tunFWY2eBeVgLyoXQ9gh8dj4GfuMNH9t0LetFqMU6Rlse25W9mIaYG55kG1+sOxjqdpVuA+/LCIoxFN2ijYfsUut7nGRSvJCnrAzaFcIrDpR65w01/t7NDa3DPapO9W/WKNnYvIau69M4rfYSiyzN950vmFt4jMVYe+mQOK/6sNVM0qn59p8COVpKuORW9kkZF33Io0g5FFPFsXwXBvAkoolk0fimbDP4r6d/MF8apsLTXscoBGSWJiZuVF+Aj1kFhZLnIwLQT6O+p7S07GdfdbWiQ0+lgzPqCRgnNb2AOYQUpjMJ0Xm9LFpbgPFE2JLxpZ1YC2b/HgYaSf+UL1dV8FckiyRNfiJ6OhMQRRL1IfXugCi+ZdOm4Sn+GI4N/WEw1E26FTEgwZDker9d5c9PBMCN5OWZuzUxbrz1OIuM5oMJeW5w4nGptyvzng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The core function responsible for folio splitting has shifted over time.
Historically, the mechanism was documented primarily within
__split_huge_page_to_list_to_order().

However, the current central function for folio splitting is now
__folio_split().

To ensure documentation matches the current code structure, this commit
moves the fundamental mechanism comment to __folio_split().

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 96 +++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 50 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8db0d81fca40..37a73bfb96ff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3911,15 +3911,61 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
  *
+ * This function splits a large folio into smaller folios of order @new_order.
+ * @page can point to any page of the large folio to split. The split operation
+ * does not change the position of @page.
+ *
+ * Prerequisites:
+ *
+ * 1) The caller must hold a reference on the @page's owning folio, also known
+ *    as the large folio.
+ *
+ * 2) The large folio must be locked.
+ *
+ * 3) The folio must not be pinned. Any unexpected folio references, including
+ *    GUP pins, will result in the folio not getting split; instead, the caller
+ *    will receive an -EAGAIN.
+ *
+ * 4) @new_order > 1, usually. Splitting to order-1 anonymous folios is not
+ *    supported for non-file-backed folios, because folio->_deferred_list, which
+ *    is used by partially mapped folios, is stored in subpage 2, but an order-1
+ *    folio only has subpages 0 and 1. File-backed order-1 folios are supported,
+ *    since they do not use _deferred_list.
+ *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
  * preparing @folio for __split_unmapped_folio().
  *
+ * After splitting, the caller's folio reference will be transferred to @page,
+ * resulting in a raised refcount of @page after this call. The other pages may
+ * be freed if they are not mapped.
+ *
  * After splitting, the after-split folio containing @lock_at remains locked
  * and others are unlocked:
  * 1. for uniform split, @lock_at points to one of @folio's subpages;
  * 2. for buddy allocator like (non-uniform) split, @lock_at points to @folio.
  *
+ * If @list is null, tail pages will be added to LRU list, otherwise, to @list.
+ *
+ * Pages in @new_order will inherit the mapping, flags, and so on from the
+ * huge page.
+ *
+ * Returns 0 if the huge page was split successfully.
+ *
+ * Returns -EAGAIN if the folio has unexpected reference (e.g., GUP) or if
+ * the folio was concurrently removed from the page cache.
+ *
+ * Returns -EBUSY when trying to split the huge zeropage, if the folio is
+ * under writeback, if fs-specific folio metadata cannot currently be
+ * released, or if some unexpected race happened (e.g., anon VMA disappeared,
+ * truncation).
+ *
+ * Callers should ensure that the order respects the address space mapping
+ * min-order if one is set for non-anonymous folios.
+ *
+ * Returns -EINVAL when trying to split to an order that is incompatible
+ * with the folio. Splitting to order 0 is compatible with all folios.
+ *
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
@@ -4136,53 +4182,6 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	return ret;
 }
 
-/*
- * This function splits a large folio into smaller folios of order @new_order.
- * @page can point to any page of the large folio to split. The split operation
- * does not change the position of @page.
- *
- * Prerequisites:
- *
- * 1) The caller must hold a reference on the @page's owning folio, also known
- *    as the large folio.
- *
- * 2) The large folio must be locked.
- *
- * 3) The folio must not be pinned. Any unexpected folio references, including
- *    GUP pins, will result in the folio not getting split; instead, the caller
- *    will receive an -EAGAIN.
- *
- * 4) @new_order > 1, usually. Splitting to order-1 anonymous folios is not
- *    supported for non-file-backed folios, because folio->_deferred_list, which
- *    is used by partially mapped folios, is stored in subpage 2, but an order-1
- *    folio only has subpages 0 and 1. File-backed order-1 folios are supported,
- *    since they do not use _deferred_list.
- *
- * After splitting, the caller's folio reference will be transferred to @page,
- * resulting in a raised refcount of @page after this call. The other pages may
- * be freed if they are not mapped.
- *
- * If @list is null, tail pages will be added to LRU list, otherwise, to @list.
- *
- * Pages in @new_order will inherit the mapping, flags, and so on from the
- * huge page.
- *
- * Returns 0 if the huge page was split successfully.
- *
- * Returns -EAGAIN if the folio has unexpected reference (e.g., GUP) or if
- * the folio was concurrently removed from the page cache.
- *
- * Returns -EBUSY when trying to split the huge zeropage, if the folio is
- * under writeback, if fs-specific folio metadata cannot currently be
- * released, or if some unexpected race happened (e.g., anon VMA disappeared,
- * truncation).
- *
- * Callers should ensure that the order respects the address space mapping
- * min-order if one is set for non-anonymous folios.
- *
- * Returns -EINVAL when trying to split to an order that is incompatible
- * with the folio. Splitting to order 0 is compatible with all folios.
- */
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 				     unsigned int new_order)
 {
@@ -4200,9 +4199,6 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
  * @list: after-split folios are added to @list if not null, otherwise to LRU
  *        list
  *
- * It has the same prerequisites and returns as
- * split_huge_page_to_list_to_order().
- *
  * Split a folio at @split_at to a new_order folio, leave the
  * remaining subpages of the original folio as large as possible. For example,
  * in the case of splitting an order-9 folio at its third order-3 subpages to
-- 
2.34.1


