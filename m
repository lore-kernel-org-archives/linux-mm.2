Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2613D3CC82
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 22:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E929B6B0005; Wed, 14 Jan 2026 17:29:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40796B0089; Wed, 14 Jan 2026 17:29:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21CD6B008A; Wed, 14 Jan 2026 17:29:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1C746B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:29:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AC221A0136
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:29:31 +0000 (UTC)
X-FDA: 84332012142.24.A0CBB35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F4A240008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:29:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EJEzYcZm;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768429769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F436+uVzdG3hzuttrg+5weC4aqoXmW2wQVyUhsH3Pmg=;
	b=g7Gknn2Ga2KMwEE9tUD8R+ToexeGcqY0xf9zO14XhoG/VPA2KHGSaIX6GCQuWK4Dz/PxtD
	R/6wmZ6opXMNib5Bg9bbGohLQX4/FnKdQFA19qrR0BsWWVgKb8ojibMskkuiLBDXeyVp+/
	Kx860S1NnY8pfRgnHu3xz2Yp3uFCf70=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EJEzYcZm;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768429769; a=rsa-sha256;
	cv=none;
	b=eveNLyh5igQKo1WjXdq2Comn8855pX4Bx/sd+po8d4j0UUXQeTif9AlxWl2sjx9Vb6AncK
	sth6AXzfCin4V+APz0WRbTTJLnXVJczzlOoCAm7K3hwR7j4OvfcXOoSt0VhpUxQT9ZygRO
	trEeiPq2j+ISA4bufVvEy70IImnucts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B32B43948;
	Wed, 14 Jan 2026 22:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414DDC4CEF7;
	Wed, 14 Jan 2026 22:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768429768;
	bh=UaZFr4hl10mcWar3ySggf/yWyzFeKQkv3nU3vZ2O4q8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EJEzYcZmclR6eee5WcA+Z0GsBCXTzw/VoU9qux0aE2D1CLbb/tFDjfcBlF1fBDezM
	 MsN3isOQhq5clBGCFHYhbnHT4pAVwePw0QNdNvriXn8YbsG8oHOxhXjE0Ak57lf5t1
	 szPwNdCy42G6FVmKsPyLmShMBWQ6STCuDAwyil8c=
Date: Wed, 14 Jan 2026 14:29:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham
 <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand
 <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park
 <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, "Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
 Chris Mason <clm@meta.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management
 workflow
Message-Id: <20260114142921.1b47d27a3bb22b41ed0c5526@linux-foundation.org>
In-Reply-To: <CAMgjq7AUz10uETVm8ozDWcB3XohkOqf0i33KGrAquvEVvfp5cg@mail.gmail.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
	<20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
	<CAMgjq7AUz10uETVm8ozDWcB3XohkOqf0i33KGrAquvEVvfp5cg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 454wstdo4jtto4o3gyg8dndwekcqgmw6
X-Rspamd-Queue-Id: 4F4A240008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768429769-7159
X-HE-Meta: U2FsdGVkX1+4oW83siIPBWSNRuFV4aBOoH0jIEfKTeOaVPggDIL+hPVrTv33AAACT5TYIeWoRiQyGsVOvVBSuH6Z58Vmgi8EC1b99Q2auakuY1e9VfXvhnHHlHLo84mr/Ug2cvUmXfbhT+cHgHel6xCBbXHkH5kvE8SIQ38qDsjO0BJLFc5FVPwIn1e5zgeGOnShbw4llOwUWx7DnzwLVjKdISsIgaDX1UBcYSoh2vLmgGzmKgHcKZfJmQZ3X8OOrPior8GtPUd0jdAJhWhoDVTdo/OC39TWWF32T6B0sBEZIVyEDEYtCKaZLRSXHQkKBQ1DVIRHJnw3OpK5LRgmRGMAN99IncWZlH80p2y/GKoNw0EuJXVyHziGVHMVX9ej0JDISWFTmD0QUVaz5UZjDXnWHzgBCykUn4Xw/S7zlQxThnMa2pMbBa5Xgn0UonRxVmktD3mIe39osFZOTi1fWCzqyP63QA+YyFRZxi8jlbLF4gkJG+AguveCWWyvLT95wgbFBijSfg3KgXBubEBlq7RAtBlpr0LPX/bgqo6XbvFWQrOcQQtRnGoSvreVI16Ux75T/qDdz+FXoAymQM1jmfh8h0NAHk5ssBjMgwCoiwmHHLdRmDbOWbYhpdn+ZYDXkkZhpcYEpgkGU82wSeJy1yVjMHLN/Cy0rOvny2KJsd7CuNnwesdCB5VjkleXVfjdi4iRcR8JpVGqvbMNesEO12a9ch/4A1BOSvs3byFPbutltC8hhar9QuJE7RadBmCdbo88yHaYPOFjiJy9gWodF9r1DBAvYutUjIfc7P5K3W60JQRRNsk8JXGF1X2fxnIlyCsusAKY+0ZzpVEklXCKdJHtO8OJz774j+tUNzdb5REmg4EJbFWv8tZJeX+BChzKW67n65qHFn5LXW4tnJfiUOBkTxX5+RmfQ8+Jj+G+HR/xw8RXr8frLeMZudQoSgH9pUy3g9pJGt4az7CtwmT
 ow423dak
 IA02kcD8ktxzfcr8FHzTgurNmE7quDIUrHNC1/JrnTAhCB8Hn7aws04Ha7N3JAaMCmNgu6xaia5vJMzCl1rXX1eePmbuC/sVLoa+5LZtHFqjZK3TXtuArTG/Wm8WC3nDjUCvXXQNFJ/oy5Dbl+oQphoB0Mr+iZioe8cM9+TbMdOBZPXKp6HLhaBOw1uDMZm1Y/eJEmfsn0sQg+/Q7SjXxUX24Egf3LxXfOkzx9Zo9HB3Y0PYA0kRQJLzoXA04pziiwJRr+e00Lsm0ht9Ny3r3ljwljK8pC2RhC6YALOxzvj5Kbw4yGFOWBBGEDADwr5ztlg+hPNSnp4fvDFF9vtbVHqyhBQ0LRuyqeSTWIk47odRrpU9yviAPQ8JzjVS79HFftgSeylx9VZPEAeVceRAETrNXG7+IdTezLokV7sKqTtM1+/Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 00:53:41 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> Is it convenient for you to squash this attached fix into this patch?

Done, below

> That's the two issues from Chris Mason and Lai Yi combined in a clean
> to apply format, only 3 lines change.

Let's cc them!

> There might be minor conflict by removing the WARN_ON in two following
> patches, but should be easy to resolve. I can send a v6 if that's
> troublesome.

All fixed up, thanks.


From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix locking and leaking with hibernation snapshot releasing
Date: Thu, 15 Jan 2026 00:15:27 +0800

fix leak, per Chris Mason.  Remove WARN_ON, per Lai Yi

Link: https://lkml.kernel.org/r/CAMgjq7AUz10uETVm8ozDWcB3XohkOqf0i33KGrAquvEVvfp5cg@mail.gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Lai Yi <yi1.lai@linux.intel.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/swap.c |    2 +-
 mm/swapfile.c       |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/power/swap.c~mm-swap-cleanup-swap-entry-management-workflow-fix
+++ a/kernel/power/swap.c
@@ -199,7 +199,7 @@ void free_all_swap_pages(int swap)
 		ext = rb_entry(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
 
-		for (offset = ext->start; offset < ext->end; offset++)
+		for (offset = ext->start; offset <= ext->end; offset++)
 			swap_free_hibernation_slot(swp_entry(swap, offset));
 
 		kfree(ext);
--- a/mm/swapfile.c~mm-swap-cleanup-swap-entry-management-workflow-fix
+++ a/mm/swapfile.c
@@ -2096,7 +2096,6 @@ void swap_free_hibernation_slot(swp_entr
 
 	ci = swap_cluster_lock(si, offset);
 	swap_entry_put_locked(si, ci, entry, 1);
-	WARN_ON(swap_entry_swapped(si, entry));
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
_


