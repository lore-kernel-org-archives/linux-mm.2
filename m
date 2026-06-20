Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F4D1CDB46B
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 14:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC7D6B0005; Sat, 20 Jun 2026 10:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D266B008A; Sat, 20 Jun 2026 10:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5279F6B008C; Sat, 20 Jun 2026 10:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 279696B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 10:08:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4D8312011D
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 08:10:25 +0000 (UTC)
X-FDA: 84899568810.22.AF84C69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1118320003
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 08:10:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9WITInZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781943024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gGw4YYhbCFNwv1pDJFddAqeyJBVIitz2x+M8cbi70A=;
	b=jHIl7J6YDoV4dXu8axgg7/PO1mLflk2f85QLpnozyB2TPpFu2jaC/qgxu07koSorstVciC
	f6UinqLsFw43BX/MUUm8o95JsukviieLUmcPsJmt5o7WNXMHM7iUhuNYiWaQaU9EhSQmEL
	f1enJeCdbTK9GI3Pf7KxD8RCEwKvHtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781943024;
	b=csh8ae/0cBnaqo2TP28IPCjz+Td+WwUbieRWnEkOTNdGYEDRyb4557IyWAdrSbxHhjuEHK
	c2Wa0r6oUt60vQr8Rj2wKSRC7XHqY6uqSJ5E7HUAA5SIZIxGqK/FY4uyNYUQajZsby50+B
	FSSRnescWnXMQYnrlHyDKgzonH31LvY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9WITInZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F403B436C6;
	Sat, 20 Jun 2026 08:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4853C1F000E9;
	Sat, 20 Jun 2026 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781943022;
	bh=4gGw4YYhbCFNwv1pDJFddAqeyJBVIitz2x+M8cbi70A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9WITInZ/lRLRcWN6643y3whNa/8lGpOMxgK0dxXNkfWZXjO/hOX/aYnn25UdZkG4
	 nWATsjgG32adk5ffvTaOGZmGFibhEHC7Q4Bccxd0UcQEGvZDjdFg/VTlPrrm9SZ+mK
	 yOb5ztgqZA41yRR6dJmrKgXJbF6/p0EmKQj8xmw5wpRLQ+1qMjnu93V2NTdC/bNmMr
	 J0LMB5xtwq8SzcbfbB8cgbVy8tN0+7a+V0Bep1YQZo81OMtxvFtWzTtv23itK9XGo1
	 cc7AM0HTN2EKBXfZh67dOY1n0iCMj4wgPBBtVQFlxliWoyqoaIieRJ07+oivjjJfsB
	 MA4pBh0/KJpEw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	kasong@tencent.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	npache@redhat.com,
	qi.zheng@linux.dev,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhaonanzhe@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
Date: Sat, 20 Jun 2026 16:10:17 +0800
Message-Id: <20260620081017.89085-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1118320003
X-Stat-Signature: 45oe3s3byidwctob75c5ctk3y87gas6j
X-HE-Tag: 1781943023-920979
X-HE-Meta: U2FsdGVkX19r/JMY3eI7Y9/4eknayUZ/gRR6mpJW0ufcXzDprpCeElEo16dgTTDNyiTixsOwOVt0gcNzhwZsCq4bjy+cC5l1ZVVG2529dDzoz573H2KLQoHqxPwa7e1p8yPu4CN+yb4eDfyYzBsCKlZJL5bW491oxyDV/wSpR/jmY4HaSbc6vs1q45GmGN8t6X8mOvRgEiMnMNV7ejQLTcMB0OAIVm91W/cCBS6sI4C6hxdCjaUWZ8LxFmdKT42Cb+/i1FnpHuP9DEKpE7LCVyOPiZ7QO2jZbqvcpE3bkAL5NM7USsa8d2tiZCCJuXRgutCnJkYA5bK0RibyZv+Pb3oa2votGrYXGB8Q4+HD+xPS+e1P5Zzyz66DzBqIDVUOIoFaTI1qVgYqd2ujKDbP82jUYfd/KmTxjxesQKOwq9Z8sSq2MCjMfMna4VolGLCNGef6orgZfjn9lR3xbW3x8gWewmGhJRROCHKT0U5Kb8mHB9rOxaeK+iboQA0i8BrVxUQ+LN60fYfNa9/j1W68TIJl9ZlmcJ6pv4PoXB6QR7+/dNQI4FdB7F3oDGSNekuOTC2LtNEDMe2QgfVXg2m1V9aQcOsiCbztPIC+7MtQC34ILuwnlZwumj6NmGJpMdVhB08hJU5ZF2Fbm/eaAQF0ydKmLXupmdfqEKo8PAGqO+pwS+//pBz3hGh9VR1Z5K6/GRKQN63dj3n1a1Jq+2AU/2ontAqcBK1ee7Gct0FDkd6jg1rr5o4w2ZyWzFT0zSX3iT++sgvIvFgNHYVy0i6HVobdO0Fkfif5xbpXuzZ34fsdtPF5slk8aIPX+qaqOtkAcHGdl8NA1uwFJM7wFoDtZL8wILkWD/b5ebhPMtISJxnmsS6WLb2ezojyvOACFihN9hwBJxPpRxm9BR3QrvP+6TrXJ7Jzgnvu76tgcggAkfVQ612hHAHbl6b0MiQ2exu1zya1uwoDRyekcjs/u+h
 w7w/JRH/
 5NuxscnGWbKf7eik1NWGuqLSIqk4+B9pXcwu5AgsaOITwxqX/NcRrPPD6giJ69CVw52L1u0nzWsYX9xVK7DGHUQWFQHyWzQFxMD0ICezJpGKmPzBv/t0C3kv7OYWWa3Cv8RsCCBO6JaIKvMzu3vkHYeatrEAwRkYIAUA17DLCEUr1yzOreXhzzPx66SShcYRA5KdphbJ6n52K/CE3pOB+LdA4fJG1R0/DVc/ZMutDjSz8BXy2Xr0Sly1opyyM5Q8lfl5aj2DKJ6cD5aLOAzRmglsLCgFh9Og1tPRv0pEuwZtDk+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 10:04 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
[...]
> >       /*
> >        * The page can not be swapped.
> >        *
> > @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
> >
> >                               if (!folio_test_large(folio))
> >                                       goto activate_locked_split;
> > +                             if (!__can_reclaim_anon_pages(memcg, sc))
> > +                                     goto activate_locked_split;
>
> Why are we even trying to allocate swap space if we cannot reclaim such pages?
> Makes we wonder whether we would want to have that check earlier, before the
> folio_alloc_swap().
>
> Any downsides?

I don't think there are any obvious downsides there. One issue is that
the memcg may not be passed from reclaim_pages(), so memcg would
always be NULL. However, the folio could still belong to a memcg
whose swap quota has been exhausted. In that case, my
__can_reclaim_anon_pages() will fail when checking whether we can
swap out. But switching to folio_memcg() also seems awkward.

So I feel Kairui’s suggestion [1] might be the best approach. In
folio_alloc_swap(), we return -EAGAIN to tell vmscan.c that
we can split the folio and retry the swap-out.
only when there are sufficient swap slots and sufficient memcg swap
quota do we return -EAGAIN, allowing vmscan to perform a split.

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..62e2c506ccae 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1755,6 +1755,9 @@ int folio_alloc_swap(struct folio *folio)
 			VM_WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
+
+		if (get_nr_swap_pages() < (1 << order))
+			return -ENOMEM;
 	}
 
 again:
@@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
 		swap_cache_del_folio(folio);
+		return -ENOMEM;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		return -EAGAIN;
 
 	return 0;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 299b5d9e8836..63e8578454ea 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1257,6 +1257,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1275,10 +1277,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			if ((ret = folio_alloc_swap(folio))) {
 				int __maybe_unused order = folio_order(folio);
 
-				if (!folio_test_large(folio))
+				if (!folio_test_large(folio) || ret != -EAGAIN)
 					goto activate_locked_split;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))

What’s your view on this, David?

[1] https://lore.kernel.org/linux-mm/CAMgjq7Bmi2XYxPc4tVO8KTWSuj8jpt-c-JueqYRK1kLC_nmBqA@mail.gmail.com/

Best Regards
Barry

