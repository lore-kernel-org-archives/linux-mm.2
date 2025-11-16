Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 572CACD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80128E0034; Sun, 16 Nov 2025 13:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30558E0029; Sun, 16 Nov 2025 13:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8558E0034; Sun, 16 Nov 2025 13:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7703D8E0029
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:14:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5114CC09EB
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:14:00 +0000 (UTC)
X-FDA: 84117269040.13.F53A580
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D611A0012
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AmTlDlu2;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3dUwhm6vJwFmY+aM3r1lF+lFC/h0oyHUqDU3K2sKVY=;
	b=KfVPabibM3fGhU7ymeh/jGApJ0hpMf+YsF0Z1pvjMA0zgSD1xn8uMbRvLvyAJ0wHwuFnN1
	wSrx/dXBoNvgmRI0cP8bPMyjJpCy0JNXc2ALY+3+8fgMUOXhKXgIA3sD0p2jwkmbN3Q8qu
	wonj4NtOLnzlCyhYmUNpuDZKr70PBsI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AmTlDlu2;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316838; a=rsa-sha256;
	cv=none;
	b=WPJCxXH4RuqGCFyIAIIhBMn/Ef/8y1qM/T5VB1M1+tyemxZvVsMl51NkhqrAOjvEJexHZp
	hZqvT1e0Qaq6GhiQdCKK+eE7WfhztSpPWat8EfJEI4ivJ5c6tOmqDJrWA0TeFXbfjevkB5
	p0Ec7tGXb4JUjuESmK5lv7uG8W/nGb0=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b2ea2b9631so38676185a.3
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316838; x=1763921638; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l3dUwhm6vJwFmY+aM3r1lF+lFC/h0oyHUqDU3K2sKVY=;
        b=AmTlDlu2VBCe+w5rIL9KpRzD+oTBU8mUYUJNo3Wjwb8OO/kunR5KmLJ8yU4b3DoybU
         N/rxneMJVC1WgAwu/J/uOJzqTV9Gype1tP3kzVAdBiFhKUzDUyLdsYNcq/AP0BJDBavo
         bNOPAPIOb7vCSqHsKlRUyqzwiWWUgYduI9r+8lybug6G/DvgPGtPn3yiE+Yw+LQ26c5t
         XP1mhy7JkfNXHZQx+JVFKIe1hvF3wS+Hk4TAdnMBE3BYk4u6WFmMlBAQCzDKIPjqDPUO
         /qw0JkYDE4XvDCAPQvN9UpMNKjwzWGsMXPk+VFOItU2OmTNAYvOrHt6isIj6VWrSz4Y8
         mzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316838; x=1763921638;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l3dUwhm6vJwFmY+aM3r1lF+lFC/h0oyHUqDU3K2sKVY=;
        b=cZhOzrUFiw4pQR55XA7hWUqKZr6lSdhq7dGGo9v1QXJLStN7XPI/kI+zFKLqXFtYEC
         h6UARFdIRBOI90mwBt7k+++N4siXaPSRn7U4bJAXnFrhP5CTBvaeNKg36Fd3sVnjuxhN
         X6Y/8V6Vm1Jromh4uEOdjy4qm5HGrXO+vsUe+LpPi/WOAvwImCaiNlLPnOW5GGzt2E6w
         gWJifhYaDjcqe7izp3bIGU32nNEdep4jWuSHZXyRuOkrqVm760hEVqFzS+QgSMWa21qk
         KfMsOe7UQi4ad9HL1jrFnrXiNrghEwMcyqQzrZxM2W1AaAonmF+6O9TB2xfkNfE+PyqC
         IV2Q==
X-Gm-Message-State: AOJu0YwiJjRPpD9VgoiVKYwxFcBMFYj868oolKzfh49lb+bBnSRNat4z
	BMB5dtWcBiKUuGlcQSCvKVJueuW3s8djMZIv/aTGmU0VxY77BvA92aYm
X-Gm-Gg: ASbGncs5OJBO12zvtdH1qmPGHSiMG5rOcVC6uypMjDZq+pivPSudhinM479v7QO5ggc
	35fVJqLPPHI8p8xVlV3OJRWlgX9/7Ry4UYMfehIPPIoWv3dITtJUn7B5FXU6dWSxKJ9HZfLdUIa
	0df8qt1bmqmgypkI2A7AI2904Scp/4qoNgAi2aw++9LfMi5VhJUFznB4kejJuUe2ZSJvEJbJEdo
	Xrb+3jfFCi1488UWuL4Adf+Yk4fIkaFhyIF67mCeX6beEC+DXslCj4c2/Jc3lSvfvCeNuyGally
	iSnD2amseC9/LlDQ75CIUmHgSb6CBqLherlJcqyYwQvy+k3srI8AUQ56eQPtOi40IpdUtnvgvpG
	WoCMEcSJIqoV2UCIWBBEcTKTBghJsA3YR61NqzFytsze/o00BwQ6AhJvgqGpsKkb/ZGTOuSOiiO
	i9uDCDtXdetf4PDfNb+H7+d9KinKxeJpWFV77ju816X04FghufmnVP
X-Google-Smtp-Source: AGHT+IE5n95/jOZaqH4x67JUv8UQnRKg5lwvfYjLFJV9mV5OL1WJP0KweIGTqnY/yCheVO7FE1+xmg==
X-Received: by 2002:a05:620a:c4d:b0:8a6:e160:9b1e with SMTP id af79cd13be357-8b2c3140755mr1286884785a.17.1763316837681;
        Sun, 16 Nov 2025 10:13:57 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:13:57 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:12:00 +0800
Subject: [PATCH v2 19/19] mm, swap: remove no longer needed _swap_info_get
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-19-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=2873;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=6T04beX0GGSCB6YCwUEk5OpfcEwSjNbZ+ToNclWdUX0=;
 b=W7OVts4nsc79qmFvrVhRBOzy1wzll6Cu6AwgKE4FYlSsHvfwyr19xOLzvrv8SW2ZApDX3ulPj
 /7Xl7gJPxlKAFEOScR31zfxy/G8ZEp3OBR22N7sSKJg6Po0A9p1H19S
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D611A0012
X-Stat-Signature: uqyq96wcx93k7fznf6wafqn6ey7mj7ai
X-Rspam-User: 
X-HE-Tag: 1763316838-191727
X-HE-Meta: U2FsdGVkX19j1ugURewIoBdt56azQ8zVS1rIXw755dvKvZEiEgsWemevXI0wlfBEXYd2Qm329t94JQ6yDFqSScwy8+pfVVg3joa5o02HMiaF05LU47vs3tFTSDv7VMmXl9hMhsMG0Xnxx+JzqdvIqq4kpfnlCKhx+MkF/5kRXX97wzfh+e6ga7koU5tbt4Fvwh0zz1Ii6U9Lcz+mREq2IsP8dAABlfgniFoIIQdHiL6XedNPmT0y5EbfMdB185P1pli/djiV62DZ0cFyLfBk61Ew2adof53ZhhHDxczj3nw1pDbFgLxAP2STmXUzgxxHtQ1OHu4gFE+yj8qlH6d65xRp+jqXLYHnUcIhgXF6f0WcV/dExw6e449TiIHBdHr2pzYc9iTJnAbB6DUoOcW4pfZTISWETGgi0OzysLzsZfgRT1KvcmoXHwtpP2E+O0xM6hqqKu4c7YuGiWaQVET4g7Gn77mMn1et4k7VRexetU+5I+FUrjS0DI0j0uriWVbMoq+NAsi0VyrOhlxKaRkXCww5hBrMp1zizZIBtPSUY1xPEs3bpKTf+kTwq7hnBVZrYkNOQFgSa2vTgmxnsX+JNw9sZVQximXkzQdKHx0bQlhvYsMywzQP3Y38cfHXb+zsNAnlJpX5vnW0pD4+viI0GmB84eBZjR8mv41BWz3CeB1aRNn1TETxvbaQbfVu2KK7QPPdORPrjYLYVaqLkG6X/aFfG6XxJhj8rpb1wPPzMNIld/bKDBYekhoH8QXZvimfNgU0A5ENAhFnyehhmItZaDHtsWGgO3BCyUQs27eGddytC0RR5xhz1JV4w7kcOJumDmMTAT40SWZhlUsEvmFfPQIU5tJhh58dvg/aa+zSBh99OD43jyROBzhGmf9i8yGTu+rlfBlHPs73MGMbxf2vDhkwLWvn6UKeKdQVimWF4q+ZNS/8nF9o+WmYgLuzq/n/RRTeHqMN8QMVW+CgDTl
 UbYnbuG1
 aQkelqQMb7YQ1sw5LJR6wSqgA2ACl5vrSgAijo/8ITOQHiJcbzj0Bguyy+bcZ+FP8IqsaIXJHe3ya3ec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are now only two users of _swap_info_get after consolidating
these callers, folio_try_reclaim_swap and swp_swapcount.

folio_free_swap already holds the folio lock, and the folio
is in swap cache, _swap_info_get is redundant.

For swp_swapcount, it can just use get_swap_device instead. It only
wants to check the swap count, both are fine except get_swap_device
increases the device ref count, which is actually a bit safer. The
only current use is smap walking, and the performance change here
is tiny.

And after these changes, _swap_info_get is no longer used, so we can
safely remove it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1bb568728b85..057b927603c0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1578,35 +1578,6 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
-static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	unsigned long offset;
-
-	if (!entry.val)
-		goto out;
-	si = swap_entry_to_info(entry);
-	if (!si)
-		goto bad_nofile;
-	if (data_race(!(si->flags & SWP_USED)))
-		goto bad_device;
-	offset = swp_offset(entry);
-	if (offset >= si->max)
-		goto bad_offset;
-	return si;
-
-bad_offset:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
-	goto out;
-bad_device:
-	pr_err("%s: %s%08lx\n", __func__, Unused_file, entry.val);
-	goto out;
-bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
-out:
-	return NULL;
-}
-
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
 				  unsigned long offset)
@@ -1765,7 +1736,7 @@ int swp_swapcount(swp_entry_t entry)
 	pgoff_t offset;
 	unsigned char *map;
 
-	si = _swap_info_get(entry);
+	si = get_swap_device(entry);
 	if (!si)
 		return 0;
 
@@ -1795,6 +1766,7 @@ int swp_swapcount(swp_entry_t entry)
 	} while (tmp_count & COUNT_CONTINUED);
 out:
 	swap_cluster_unlock(ci);
+	put_swap_device(si);
 	return count;
 }
 
@@ -1829,11 +1801,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 static bool folio_swapped(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
-	struct swap_info_struct *si = _swap_info_get(entry);
+	struct swap_info_struct *si;
 
-	if (!si)
-		return false;
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
+	si = __swap_entry_to_info(entry);
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
 		return swap_entry_swapped(si, swp_offset(entry));
 

-- 
2.51.2


