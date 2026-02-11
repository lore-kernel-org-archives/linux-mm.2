Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260E8EB5949
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 00:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312B16B0005; Tue, 10 Feb 2026 19:45:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296446B0089; Tue, 10 Feb 2026 19:45:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1A26B008A; Tue, 10 Feb 2026 19:45:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCF76B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:45:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 969C41B28C1
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:45:00 +0000 (UTC)
X-FDA: 84430331160.13.667EC27
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id E669920005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:44:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ogz/RM0G";
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770770699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3aJnr/OplGPAFmy1GI/fCChhGWEtuYa5I8f+gitr6E=;
	b=LtVw0yt4xGVJHW49zzLSDJbzxNSGfhE8rNjegcM9hBdGvl29+eHqTXlF7vl9yZzZ6v3jQV
	7lJyfCWqGuumdvZpQo516NY76VDoVUGxp/MyzAIjcbTEDLPhdRwxwjXUbivtTDiNZPDuLi
	d4YCymz9sknKERlWUm7uA5UZibpvc7E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ogz/RM0G";
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770770699; a=rsa-sha256;
	cv=none;
	b=DR7SvenwnnHlGkd6XTmIMAgLeNg9Igh/a7Laemk9tK3PKbVepa8b5D94IGmw/rI+/1CRPj
	cntGAJbXCTl9gbnub5HSWJKkk3qrHXkSjXSYcx1boSOjMwrZp/e9geCClPRPslwog5ACIH
	bbc+sTtU2KexkQYEJYRfv4JJ1uX6q00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770770696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q3aJnr/OplGPAFmy1GI/fCChhGWEtuYa5I8f+gitr6E=;
	b=ogz/RM0Gal0DKCePsJrRFYXBUFaCmlyOfJSgqV5bM5gS/PpkBBMe5t9pa8uNMEdmwTjj6S
	ClJRpQ2A8D1XL/Rsioh9iFckh6maXSSEWcYoeV0oKgDFFelSResKvN41xh9IF6rawrwXsi
	fVKzTqjA03Olw1uOiaVy+WE6WvHe8mc=
From: Usama Arif <usama.arif@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Wupeng Ma <mawupeng1@huawei.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/hugetlb: Restore failed global reservations to subpool
Date: Tue, 10 Feb 2026 16:44:44 -0800
Message-ID: <20260211004449.3731199-1-usama.arif@linux.dev>
In-Reply-To: <20260116204037.2270096-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E669920005
X-Stat-Signature: ktim1qtbj7pq1xapgi6cc9urzoa81pqm
X-Rspam-User: 
X-HE-Tag: 1770770698-463398
X-HE-Meta: U2FsdGVkX19ypDm6kXXk3LX/0sMmsWNGS4PVEN6CGkzQot0Ii8ymejq1unCpvWtOVz2Z2Jc+62vRDPBg+1TMA3uW3RBKGsYYtgaVYQCA5G70lVCte8erRB8ytd8mNdVQBrvJ/Oun6D7cTm5FmI5wXCGTlcMQG9QYuh9qi/PqtTXr4zB8crRQuYWJKNuTFthGihvkh2ySJdFPoOVQ7WlXFeTAp7S0j4vxk9Tgt1so89tqzQqiYLZSH6YYbW4bO6ADxVk+chNzkUPvOvuslGIXV1PnpdS1YlVEyWYPOeVrfZW0wo/vY1l55oKAjxe3qGTtzqRBeX4k6cRva2vb0LtuRrxR74r+LKRFv3vlEqjYF1l03bU1sGBze0DRv2n0NxEEbN1SVazhgDOisybP9K56ddb9AwCSKHIT2aK5mXoXrQVJHm+eaJsuml4Q+V0yKW1p4WDzci5Ua6Hs7vn28XHo/JU1H53rawsSuP1sdhICyrXKJtEQ7VZ7bKfEJ+0GxHXci/MC2XUR18Awnhi1/8Bn/vYomCGmYCQLuh3ndKrbL42vPrIGOj3k7htC8yszYYLU9DHwo3h2VUAwowy5JuSxozypmx+ZkFZbRzRIcmFu3UvMGGDuLtTzXU8/B6YNW1VRA0kMc5gDsji4Ev48vO1JEsu8efncfgVN3NBPc8nPIouofcaKyWrTndHwPWtW38fEZf3lgAE+S7JuuCf9wGtR4fHWzGeAbDm0OUMUSZuGE37KQmHYdJC7dEhj3PeULIe2ruzJkh4fJIBsoHqXo8pvs46TTNEf0a8125U9Hu4SOYfoyq8Ipt2EbXZm3UW29rp5JjN9focgXfcctaZGKf/PLOYjx53mg3OvvzqYhUhhTcV5XMbeVb/aGvPItkUPIKW6sJyMgRHfkBMl2e7Xrmk/vr/4hGpnZfQ9yo4OTxQ4xUKfxkWzdx5tg7Du6HwZTPj0+lDrRz+XsPCjgKtyjKL
 AzcpvIXn
 MNIWi06NYvR2WS+4xmXIrQFa7yQLup0/AeDgjk/orxj0Tzp2RyVGcbjvGBv/sWnzg7avlOsAnV7GHvHtHyz9fU+FwkF5GHBH0tAfjkMMpUesMTaQTZlQrMPzj4xhQcJMj2VVBk7mw3HZnxTIGF2Ne8dXKzNd+zgttqzVMul8p0E5lRlrF7t+HcHKfQtczxSL4Q7aNnhVylFoVJnmueoAFdjvY6NlvLzfk5hwifQ8z7i/tYzInoCCbCIrsyE1439UejTw/bXf0fIe+k4NWpua41gQtp7/D6MTfv0xdZDMb6sIaiSsR2OMqRTOKl2TFClsx8uiU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 15:40:36 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> fixed an underflow error for hstate->resv_huge_pages caused by
> incorrectly attributing globally requested pages to the subpool's
> reservation.
> 
> Unfortunately, this fix also introduced the opposite problem, which would
> leave spool->used_hpages elevated if the globally requested pages could
> not be acquired. This is because while a subpool's reserve pages only
> accounts for what is requested and allocated from the subpool, its
> "used" counter keeps track of what is consumed in total, both from the
> subpool and globally. Thus, we need to adjust spool->used_hpages in the
> other direction, and make sure that globally requested pages are
> uncharged from the subpool's used counter.
> 
> Each failed allocation attempt increments the used_hpages counter by
> how many pages were requested from the global pool. Ultimately, this
> renders the subpool unusable, as used_hpages approaches the max limit.
> 
> The issue can be reproduced as follows:
> 1. Allocate 4 hugetlb pages
> 2. Create a hugetlb mount with max=4, min=2
> 3. Consume 2 pages globally
> 4. Request 3 pages from the subpool (2 from subpool + 1 from global)
> 	4.1 hugepage_subpool_get_pages(spool, 3) succeeds.
> 		used_hpages += 3
> 	4.2 hugetlb_acct_memory(h, 1) fails: no global pages left
> 		used_hpages -= 2
> 5. Subpool now has used_hpages = 1, despite not being able to
>    successfully allocate any hugepages. It believes it can now only
>    allocate 3 more hugepages, not 4.
> 
> Repeating this process will ultimately render the subpool unable to
> allocate any hugepages, since it believes that it is using the maximum
> number of hugepages that the subpool has been allotted.
> 
> The underflow issue that the original commit fixes still remains fixed
> as well.
> 
> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> v1 --> v2
> - Moved "unsigned long flags" definition into the if statement it is used in
> - Separated fix patch from cleanup patches for easier backporting for stable.
> 
>  mm/hugetlb.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

Makes sense. Without this, used_hpages would keep on leaking if
hugetlb_acct_memory fails.

Acked-by: Usama Arif <usama.arif@linux.dev>

> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 5a147026633f..e48ff0c771f8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6713,6 +6713,15 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		 */
>  		hugetlb_acct_memory(h, -gbl_resv);
>  	}
> +	/* Restore used_hpages for pages that failed global reservation */
> +	if (gbl_reserve && spool) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&spool->lock, flags);
> +		if (spool->max_hpages != -1)
> +			spool->used_hpages -= gbl_reserve;
> +		unlock_or_release_subpool(spool, flags);
> +	}
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>  					    chg * pages_per_huge_page(h), h_cg);
> 
> base-commit: c1a60bf0f6df5c8a6cb6840a0d2fb0e9caf9f7cc
> -- 
> 2.47.3
> 

