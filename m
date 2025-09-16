Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA30CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1B48E0023; Tue, 16 Sep 2025 12:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B7C8E0001; Tue, 16 Sep 2025 12:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41AB8E0023; Tue, 16 Sep 2025 12:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A07CC8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CB5014022F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:34 +0000 (UTC)
X-FDA: 83895581028.28.CC4378E
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2791120022
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K4hZuQA4;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038552;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hsOmThW2RAYLAuUPY0h11vKmZVrV6aWWNRHy7EaYEQ=;
	b=yLXiSTqZLW4I47DpKkUcN+NOU3c6rDNxm1KhwQUKonR0OBTJqmv+LbmgZ3Rd+7Oon0vpvX
	8iJpOdFMa2oOS5BfHYcePd4ygizIpVfv0TjHOW9c8CCReFHtlzAMUSzv7xL9UywE+pK9vz
	R5WYk0Wjhe3NFwk5vxa9S5XCEOK9j80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038552; a=rsa-sha256;
	cv=none;
	b=yiuYBiaiyAE2KvdkwdMBWUiCAQQY8b+SmVUQAkTgksbrBufzJ/jV9oO31DskNrnjMGfpeX
	6cL8l7kOG3nJHwj4AsMmmCKQ6lmWotToJN+e/KT2d07xHBUHtDt0y7gP3kHMDXzueji8eJ
	hK/+KsgvEv6Rv7cxq3nhZeditsDgIOg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K4hZuQA4;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-81999b1e9ccso497771085a.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038551; x=1758643351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4hsOmThW2RAYLAuUPY0h11vKmZVrV6aWWNRHy7EaYEQ=;
        b=K4hZuQA473M8u3HWPlfTREr4ao8lYpvK4drUiQZyb+UC0vuuKFTDtaNXBgexg2VIYF
         aVUq9e30VdrvBaIvfARofDBYihT7/qB09jENVYSzHF0u0DUtiWYhgDB6XOIxcrpUb9e4
         7tBDGeypVG0F8PKsBpoEoiT8fmteS3LPjSyolAkyzfgu1k/D7JKCi9SPLDdEVhxTFyXU
         n4vs/mydol3kjtEUrVA+DgkilBmKk4JeBkigCLaHUbUDYFDv4oluU2FEmIJVrANLSHfl
         zUpCjZ95cH9B+tSldNPMrq+h9rLTI+QahG4C1ro8aDhFcwVdmWqsvzRLhADQUsOGqTiX
         L0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038551; x=1758643351;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4hsOmThW2RAYLAuUPY0h11vKmZVrV6aWWNRHy7EaYEQ=;
        b=BJMIXXRJcpxeEmTqSm3yNIJRsjuUuAhGeINTj/T8x6+ExojohZS1zlDzXXfKbYdl73
         eZSpCNHusyu8kZlfZxz3+Zb4RXEpJMCuVdDoSHONHJx/ZeNVFAzcust3vibOgim3eemZ
         4Y7iO9AcfxpBZa3efKAIR50YcZtOVoZiCcBIaaCylI1LmB9NrSK0GDjWBunkMU9C25BF
         wQtltNfMaOkDF4o7PNPdmI3cMMdOVC8CH1lqBFzxGO/J45CMpfZiM1kwoajMCbbidvCr
         XQmBCv1kXGJaYpzOkjL6p2Cp9dFyIgIAXS2SrNi+2lLIWBpvjXwWiSRhKcBArbyzjEiS
         QKzg==
X-Gm-Message-State: AOJu0YxL+M8Sf5RhyE2cSRmeXa+NPUcVeLKHh/4LOp2nD+jC72S5J8tx
	T9OsFA1+mNwTa4v7S6TCBgkMnlMSKYdU+lj89F2SIHFnjlKCWCY95l28k0RQaclgm4U=
X-Gm-Gg: ASbGnctA5Mqdrj2D0npz0tfU7HzOyZDbKY+rsyWbayhbfts8XaQ75yrtW4NFWvyIpNZ
	KXEl6zMGYx6/59W6ju4vBCnCyfyWSf9SLL9sKG0GSgmE5kWeRJCnCGkWGw/HGyMfJdUzmXpR//A
	3VjpYZVePqPEWzGxuFAbXFDzpUd292nOW5c7sDXud902qTI5TV5pqd/qeTD6yPEyBV8MKUtEhtJ
	Qj3GnW8QD6PC1C9rXBkDfbJ45ecppJE0UXWQkhhYcXCCD7IwLdEGpyOBo8OYQFkKESgKfJVA00B
	Gergki6G5cN3OBsIJxRepkm1/lMQGPWS2rbJxi6rLaRY87cdHUy1mXAe2/L1Ze4O+cQlu7TOiEB
	0vx8Jj0/vsDwPDAD9s8mD5QADfdcbabVBGJSw1gaSmfSCwiY=
X-Google-Smtp-Source: AGHT+IEcUJm6HBE67qNWNXwnh1bmV+sbQgFEI8gjzHotd6hHFYJuVK3vbAW+rqvSuL61i7u/HC8DNg==
X-Received: by 2002:a05:620a:370a:b0:7f1:9a91:1dda with SMTP id af79cd13be357-823fb826224mr2074340985a.13.1758038550496;
        Tue, 16 Sep 2025 09:02:30 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.02.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:02:29 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v4 12/15] mm, swap: mark swap address space ro and add context debug check
Date: Wed, 17 Sep 2025 00:00:57 +0800
Message-ID: <20250916160100.31545-13-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2791120022
X-Stat-Signature: q4ax5814uk44q86t55ym5exybxsowz6c
X-Rspam-User: 
X-HE-Tag: 1758038551-863099
X-HE-Meta: U2FsdGVkX1+dwLXNuFSRjcfbee2yZy/JrHVFjOzKk1ojmE5lABuztLnfPr4pmrSOqG9HmiJ1ltela3mp3Hr7Rp7V/taAQZ5PFCJULd13gXjhMCvJiNA1lpXlaMWxNsXzGSGWtGASvSmStOzRB9zADsQQLEFkN+1AXRgK/i1uT5CLkGclXngHKKT6f53pf0yIdQcMftYWnPDdITl9JlolV3hsi/vLbEMLYToWUyUz9xF1dnDcrbn2plq18qUuOZ3JLprsmS/HmJIKmUO3Iwgv5QIuwnZUP0l7IuRgytTAJzZPbYmgvUqbYlSscq45O/QSpaiiB4nQWTkT6WKsmm4mM9qLtGqmHpa43DvtolFWveY43gAmq7euHvh0EU2+zjPgvVqRJwGXk/HELO+dhIqugy550rq91gdZQRAuvRIwddaPVlE074Lhsh5Aic9bGJ3/+axbZsNvm53a4lMd17CIv8xqSRcxUDDTaxx+aRbbEYbdi0beij2mv7GqiFHUBvt3EsCMZnUrStR1W+E3N+tQP3gwSsJBvRUuD4i7PPs90iHrrHYjFdMpisBXVRe6zq4888Yvh/LtxuIw3ToSlAQ6KP3WLtaK/a9eLgLWVKpXU4q9L8aMW76yLaFwl5OMUSBa45OquwEHmO4avE06NOGvX3WZYDXWj09WMGi46IZ4iCqAi6BFiVznY1zxla4a6jF45OR86KfgsIppoZprFdKNRA4Xbj7NQd7FWSsHWqTchbMjxvIjtt7vI+Cb8VQ3cfrE97kv/8L/Ztgy5qpZQ+K1d3x1LDuqVwaJ0kPYiR2n7wGihG4m6qlbs0nHHITBo1Ne4w6GdaIJqWdMB9gJgBwJulHYq2RCCi6EODJWD4++nw31nq5dl+Ll7sHWgN8yI9sGDw/ysj6KvnKyviZVzBlgDlCn3JxFUUgMkHt1GYJDLX+qDEilTKRDblZVPHyytews2g9QXuXDsbHEg6Q+/L0
 p0FgDUvL
 8zpauGgavAN4sS0b5cVcnBhL1YI8gk84e7U51ZMME9EDo5XuWrXAgw/VOrBJMC0JyYZZyu/AyisFng1mM7a9dyoLv3amRGHHLN2U7OHgRhd8tosruPPRuXe6Xq/H1Lqbm+eXFpnriwuNTgMbm6nKtIJBch9vXlHyqKnWGS4wnsFg+qPhRvTPpy8VWIEVbp4/zvqwM3RNkJ7NdcuJT8NvysZNYLBql4vibykj5meJO3Kc+kSl0iteIGfpgptYkCEITeFHXaxTv/Xdo2WBda9+x7E6hSS51q7iPkO7AObGMRwAuBGlTrRNtyHk6EX4tnH40eyJ3krXMJqu6oRwebXYzJUDxIzSJ74nLZg51qHypIk7JHY/Hgoi5nNcLbcOjgTDyj9AypOY+/boCy+pZ9Z/t+Iu3Bqu5n3gfSrQa4/6eewjARZF1AH2OAn4hgo7kIzzVc1h27lwJzCO3n0gxPC6R/0BG6v4Xuk1v2esVqbib92OwhXZ0jP0aRIKOG6ek9cP8deftjbl3a/Msg2gbbjgr1+QefOBGwQ0N0jsCje0J1X0ZHSZD+kImF+Z73yFgtcwTwqQT3AKXexLn9pa7J/W+BRm47iSux1nYYg4RS72yCdqdRj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cache is now backed by swap table, and the address space is not
holding any mutable data anymore. And swap cache is now protected by
the swap cluster lock, instead of the XArray lock. All access to swap
cache are wrapped by swap cache helpers. Locking is mostly handled
internally by swap cache helpers, only a few __swap_cache_* helpers
require the caller to lock the cluster by themselves.

Worth noting that, unlike XArray, the cluster lock is not IRQ safe.
The swap cache was very different compared to filemap, and now it's
completely separated from filemap. Nothing wants to mark or change
anything or do a writeback callback in IRQ.

So explicitly document this and add a debug check to avoid further
potential misuse. And mark the swap cache space as read-only to avoid
any user wrongly mixing unexpected filemap helpers with swap cache.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/swap.h       | 12 +++++++++++-
 mm/swap_state.c |  3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 742db4d46d23..adcd85fa8538 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -99,6 +99,16 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 {
 	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
 
+	/*
+	 * Nothing modifies swap cache in an IRQ context. All access to
+	 * swap cache is wrapped by swap_cache_* helpers, and swap cache
+	 * writeback is handled outside of IRQs. Swapin or swapout never
+	 * occurs in IRQ, and neither does in-place split or replace.
+	 *
+	 * Besides, modifying swap cache requires synchronization with
+	 * swap_map, which was never IRQ safe.
+	 */
+	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	if (irq)
 		spin_lock_irq(&ci->lock);
@@ -192,7 +202,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 #define SWAP_ADDRESS_SPACE_SHIFT	14
 #define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
 #define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
-extern struct address_space swap_space;
+extern struct address_space swap_space __ro_after_init;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 2558a648d671..a1478cbff384 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -37,7 +37,8 @@ static const struct address_space_operations swap_aops = {
 #endif
 };
 
-struct address_space swap_space __read_mostly = {
+/* Set swap_space as read only as swap cache is handled by swap table */
+struct address_space swap_space __ro_after_init = {
 	.a_ops = &swap_aops,
 };
 
-- 
2.51.0


