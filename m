Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 905F9CA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 23:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7BD6B008C; Sat, 10 Oct 2026 19:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F966B0092; Sat, 10 Oct 2026 19:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2952A6B0095; Sat, 10 Oct 2026 19:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06CAC6B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:26:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D0C3A050F
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:26:02 +0000 (UTC)
X-FDA: 85308301764.03.6EA990E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id CDD9C120003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:26:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MGqXdeYH;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791674760;
	b=wZUHvmrGAbikdgSdRpsc7ZOFHS43/nLc5S7MwD3AycOieIzaxVoj4fY2IyA+y97oRr9306
	G/RUWgc2nkkZ58afBaOMflRNDQG2fCudXmLeZy6DYfJyzMUdJmgygReH9qKzdMIi7Zs7ge
	6vRE8hriZ0MVMQ5nV8eQgfeA4PDIpk8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MGqXdeYH;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791674760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lX06ug4ZlwaTEtFe/+FOH0wFcyQJV2GLnOlTR4H9yEg=;
	b=bGnub3UiIR1KW2xRoG2OoU8o8SeyqvFsnll4UpPTkA3EAupI/o/nM4todmbIQosH1tuuM0
	Llrjdva0mg1wK1fPi5FAw/4XCIpZimI70MwUmjhfw5aQ73FX1mUIURIqq0nC6jQ67KGIbg
	V7feLEYBYuvT2shF/0KRJR7vf4t1dAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D823B600E2;
	Sat, 10 Oct 2026 23:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CE01F000FF;
	Sat, 10 Oct 2026 23:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791674759;
	bh=lX06ug4ZlwaTEtFe/+FOH0wFcyQJV2GLnOlTR4H9yEg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MGqXdeYHpyqnP1J5PQ5E2qWuOvv2i1SG2Z0PSZkOeYJbfAi6hmx1DDJ5P2qnbFABt
	 mXfZdxi9/01bwNyJa5xnSHNNQfO4UJxnvWs0mrspJq3s/tFw7oKsukUjrwaX9cABGj
	 67S3u687VB7GBdwVK2B7R3vMktHrxSxO8tyrVk1o=
Date: Sat, 10 Oct 2026 16:25:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, I Hsin Cheng
 <richard120310@gmail.com>, Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, Chris
 Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] lib/plist: fix plist_requeue() shortcut inserting the
 node at the list head
Message-Id: <20261010162558.62abcd2ec967b009d0cb3bbb@linux-foundation.org>
In-Reply-To: <20261009051857.758182-1-nickolai@csail.mit.edu>
References: <20261009051857.758182-1-nickolai@csail.mit.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDD9C120003
X-Rspam-User: 
X-Stat-Signature: u7t9b4dau6ut9c7pt8ca7f5fhqqr5zco
X-HE-Tag: 1791674760-425352
X-HE-Meta: U2FsdGVkX18ITXxQqslUGKrIjFLaXmGeJoYGiwC41WmS7VSeXWl5694ZzfBqz/MJ2Z8Hzvu6OH+9T2uazQWd+w6VfsfqBjqmHgGRUP3LTswFV3mWHTYQ/h8JXpnF6B+RKxUxtayc7XVq48zNrg+LD8HTAi0qoRA+93cXKQ/CZxWpQYMEAaMjr5T1RFSUF0qJSJWX1JFY+tmMD3Fr9HCr5976Q7YdYBqItnH8oE4GuptU2UBujf7Oz6rIFHXrM+iou8l33j+twiVealp9p+pTTKIaMTHlyJpL9XRUxKRnNQCWDPZgykujFaorOAdaxQBKgsDx5DwoRq/oIk6hPDJrUBnl549XQ3FIHV6tgOiobrvlp4pyTMHKWI+8ddgvFinh72Gl4k/mH6cdD67OY8LvYUyLdvgdxnR3f2dnjdTRwJfnmHOZ4eN/VhUrn8jHVSvkRoscBpP7CgJZE7yF9IuPfUmzORfxgCtQeHiYU7844+q8t/S9IxyQPI4+8Gn6dQLZgNkCnJBRFVEzKqcPf5lVZ1NM72rps1AcbMsBzpb37+JxF0C4mEF6g8YD7mFXXOpJllRgi35biDvIE8CDnV9hoCRP23+EPhhMCTnlLv17u95PDHx1iCaokKl3mnbqAGWp/iEIhg8L9rpmW8QRD1yX3UezZQ7/os40+DuEK3xENA9T2wcyesCDu18+IHGVeXn2kQfZcNV2s3Evp4bvTGCJnHtPeep0Y3Wna2GfQWlDSq78Y64AmjFIVMUo0qVgaKeRxriiD1FER83HLDYfltTTjXhtZzRfC7dAuf/C9fZAGZFfahLXv56zS7q3H09lVWOboRElq52If9G4BanWEKL5radVG9EhtG5jMouB9gyHNqbTZxj1vWf/HxgntRGC+PSEGGwIl0NLX1JX3ZMB8w5PcGCntWQ/kgZXSXU6H6T/NYbAI0PCZ37cl+XZ13mo2Vo7qvc42edwRCPhVgQUope
 ABBdOfYg
 xwNISrNCbzwWK8AX27Epz/urfiR+L5YomOfgq0eBCJ91gfQcxbNrO2Qh8zqgWupmWbDwNRw7su/llGNzKymQ7Cj8PRP7/CgHOHH3vq2O2+9eiMotF7nqQlxyfJnTx2BCOHS5yHguTvySwlf9+Cngtt0EBkx9yEEzYNuKwMBVHUahBlPeZOvINjEpkPyGjtzlOAJHWLBRIxsXes8JppeSfKy3Dl3ritzlXYAtt1Pcy6Vw/We0oftRIl2MaGE2ibbyE1fkzWEmB37vzqxMGFE1IISvbwRzhV7ba6g30flhLbdiPNBPxleVy7/KhADh9EhDMITvyw3wV9C91mNmg+QhTjqwQAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Oct 2026 01:18:47 -0400 Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

> plist_requeue() moves a node to the end of its priority run.  Since commit
> 95d4b3450ebe ("lib/plist.c: add shortcut for plist_requeue()"), when the
> node was the head of its run it skips the scan of the remaining nodes of
> that run and takes node_next from the prio_list of the node's successor,
> which replaced it as the run head in plist_del():
> 
> 	iter = list_entry(iter->prio_list.next, struct plist_node, prio_list);
> 	node_next = &iter->node_list;
> 
> prio_list is a ring of the first nodes of each priority run, without a
> sentinel.  For every run but the last one, iter->prio_list.next is the
> head of the next run and the shortcut is correct.  For the last run it
> wraps around to the head of the FIRST run, and list_add_tail() then
> inserts the node in front of the whole list, ahead of nodes with a lower
> prio value.  The list is no longer sorted:
> 
> 	before requeue(B):  A(1) B(2) C(2)
> 	after  requeue(B):  B(2) A(1) C(2)
> 
> The condition is: at least two priority runs, the node is the first node
> of the last run, and it has a successor with the same priority.  A single
> run is unaffected, because a one-element prio_list ring is list_empty()
> and the slow path runs.
> 
> The only caller is swap_alloc_slow() in mm/swapfile.c, which requeues a
> swap device within its priority group.  With several swap devices on more
> than one priority level, where the lowest priority level has two or more
> devices, rotating the first device of that level moves it ahead of all
> higher-priority devices, so subsequent swap allocations go to a
> low-priority device first.
> 
> Only take the shortcut's node_next when the next ring entry really is a
> higher-priority run; otherwise append the node at the end of the list.
> 
> The CONFIG_DEBUG_PLIST self-test did not catch this because it only
> requeues nodes it has just added, which are always the last of their run,
> so plist_requeue() returns early every time.  Add a deterministic test
> case for the failing shape; plist_test_check() verifies the ordering and
> the prio_list ring after it.
> 
> The bug was found while attempting to prove plist_requeue() against a
> specification stating that the list stays sorted, in the MachCSL
> verification of the Linux kernel on RISC-V; the proof failed at this
> arm and the prover produced the counterexample above.  The fix and the
> test case were drafted with Claude Code (Claude Fable 5.1) and reviewed
> and tested by hand: the three functions were transcribed to a userspace
> harness that reproduces the misordering before the fix and the expected
> order after it, and lib/plist.o builds with CONFIG_DEBUG_PLIST=y.

Thanks.

I recently queued a fix for this problem from Alex:
	https://lore.kernel.org/20260903222456.1881786-1-handyhandyman.adam@gmail.com

The two patches are rather different.  Please review Alex's change and
and let us know of any alterations/improvements which you see.

> --- a/lib/plist.c
> +++ b/lib/plist.c
> @@ -174,11 +174,17 @@ void plist_requeue(struct plist_node *node, struct plist_head *head)
>  	/*
>  	 * After plist_del(), iter is the replacement of the node.  If the node
>  	 * was on prio_list, take shortcut to find node_next instead of looping.
> +	 *
> +	 * prio_list is a ring of the first nodes of each priority run, without
> +	 * a sentinel: if node's run is the last one, iter->prio_list.next wraps
> +	 * around to the first run, and node must be appended at the end of the
> +	 * list instead of being inserted in front of it.
>  	 */
>  	if (!list_empty(&iter->prio_list)) {
>  		iter = list_entry(iter->prio_list.next, struct plist_node,
>  				  prio_list);
> -		node_next = &iter->node_list;
> +		if (iter->prio > node->prio)
> +			node_next = &iter->node_list;
>  		goto queue;
>  	}
>  
> @@ -276,6 +282,25 @@ static int  __init plist_test(void)
>  		plist_test_check(nr_expect);
>  	}
>  
> +	/*
> +	 * Requeue a node which is the first of the last priority run and has
> +	 * a successor of the same priority, with an earlier run present: the
> +	 * shortcut in plist_requeue() must append it at the end of the list,
> +	 * not in front of the first run.  The random test above never
> +	 * exercises this, since it only requeues nodes it has just added,
> +	 * which are always the last of their run.
> +	 */
> +	plist_head_init(&test_head);
> +	for (i = 0; i < 3; i++) {
> +		plist_node_init(test_node + i, i ? 2 : 1);
> +		plist_add(test_node + i, &test_head);
> +	}
> +	plist_test_requeue(test_node + 1);
> +	plist_test_check(3);
> +	BUG_ON(plist_last(&test_head) != test_node + 1);
> +	for (i = 0; i < 3; i++)
> +		plist_del(test_node + i, &test_head);
> +
>  	printk(KERN_DEBUG "end plist test\n");
>  
>  	/* Worst case test for plist_add() */
> -- 
> 2.56.0

