Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742F8606A32E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nbQjELS8
Received: by kanga.kvack.org (Postfix)
	id 509336B05BC; Wed,  4 Nov 2026 13:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0D86B05BD; Wed,  4 Nov 2026 13:41:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D306B05BE; Wed,  4 Nov 2026 13:41:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0196B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:41:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B69481C4205
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:41:40 +0000 (UTC)
X-FDA: 85398305160.27.534BF64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8EB0140007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:41:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nbQjELS8;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793817699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofzQXuXOTQViNJOurFeSCLUNFQXJgGfKrYOJL/pV8Us=;
	b=Li1u0vI9T3ycqqbe6pvUuCIEI2m9D1qOygx+H+UkIFjTp0SnEi34LSOsYxXOAIhQ8PcGm3
	OObjTYI2rebove2+jLdUY2zLhRgMOeC7PXA18lloo8mbp3Rfq4e/Bi5OGduPeMYJOVv2uD
	rkgCqn946IQ5R0pebXIhCI87RWMFN8E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793817699;
	b=LluIPXlF3a43rKB53vsvkNnAPcLiEbRUR9saYqrcj+WYhvVDCrkn2vIFSmV6SyEdyyX+H1
	CrgUtv6wrCDlEtUL2DoPd1ylynNFY6f4oUJOETjziD9+r07tSsiaCVs3WuwBFcKsFVAHPo
	8dTXJjbolRzGq/4kFd4hpM+3cV/CD7s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nbQjELS8;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73C06609F0;
	Wed,  4 Nov 2026 18:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35931F000C1;
	Wed,  4 Nov 2026 18:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793817698;
	bh=ofzQXuXOTQViNJOurFeSCLUNFQXJgGfKrYOJL/pV8Us=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nbQjELS83W3qKX43J5wf4hpDwuuzTliSbkKHJoQ+eN6FRXXH36pnKjl+1wP16Z1hy
	 8foClGHpX8xG7k2xr3M4MJyZNkdn/s8EcM7J+ga/NymFpaON/J4cb2dcdJs6UrND9i
	 oORabaNb9ZlID6t7WDzhI4XnHBizI3x5OzMsRFDM=
Date: Wed, 4 Nov 2026 10:41:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: sashiko-reviews@lists.linux.dev
Cc: sashiko-bot@kernel.org, Liam R. Howlett (Google) <liam@infradead.org>,
 linux-mm@kvack.org, "Lorenzo Stoakes" <ljs@kernel.org>, "Chris Mason"
 <mason@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Andrew Ballance"
 <andrewjballance@gmail.com>
Subject: Re: [PATCH v2 1/3] maple_tree: Fix rcu reader NULL dereference
 after the tree is emptied
Message-Id: <20261104104137.2058705ac29734a7ab5666c1@linux-foundation.org>
In-Reply-To: <sashiko-outbox-194509@kernel.org>
References: <20261103020724.2614498-1-liam@infradead.org>
	<20261103020724.2614498-2-liam@infradead.org>
	<sashiko-outbox-194509@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qg77ozgmonp71t4ccjnye4nybyym8xca
X-Rspamd-Queue-Id: E8EB0140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793817698-256516
X-HE-Meta: U2FsdGVkX18goc3OWHOM/1NnDav/8PI5Yku6tHzayBNH45Fn2vQL2MEctboE7cPsIPEVuTAXzk9JfAjqyNY3/TSE3NcNHUqNPCpmUp8w/66wQc5oHcPDuL25dSNDiexQ3M9cFN/aS5oHU02nghLEfKZJwHfDrfxBvXOUZL6R8vHvVzuwmN248LTYo16xH3Ix5UXcZEuLZdgoPpz8uQDpgVWXQHsysTiSxHLm3i2aAWPtLcpWLSvzVr9c66XKB7iY0R/lYq+MHsMdMX2ETs5X5O23EajEmaJdnV1tngvyhto/v0QERZxNwZg9yik+F2a0uXciqwdoqyBHnYx58sCrlPj1NTnqKYOv3Pgg4c5mC/IYFzhaY/q9eLRPaAos4r6PbjgR3ZtyGkrS1AO4x1FO/vszkx7U3YP4mn/4+B8P/rQL/ic+W76pgX8RNTJI6HwIikfsBYsQNNEFp+G6X+UcRuqheOkA39+SJZLNY03U4V5uEMR9NcYhpBr4OSjb9nqYG7IJJW/nd7y0y/6kIzyoQTZRhQ5BfYgSE08AGxWek9RQuTURZ62xwAzBBOoGsN+zVaIJBEWPX0myA48hzt4BS+9QME0wweItCni35T6tzgafAul2W3+OjcFOmbYyEfXc3hof3N0vhYAXH4GFFP2cHpObVFbMlnrMKKCkC1rT14riPiH326ZrfqYbU8g6+6Q85Lv/JGV9rqyJL6vbd2tu/6d3//NUlgvLo/q8r0PTsdbo8dESxnw8ZrnEMvVVsDwZWa8ALYjngVzBrNHxloXg88+6MqEga2Oq/tqh7g+x64MLsOroAWWCDt80ncndfF8T0sAs6+bM+jaFkopMir8EsIthVzx1Bn2a00Orp44bH0p0RtVHtEEXAo5fAckDCCMfHgDBHNSQUE4SHiSIUUaImMzLGG/i9cUdJ80aV1XvYeMTUKqaWDsH/XgBFh1xRB4zCZVMzKoFA7BdJwIhMwA
 1tOU+Mht
 /RZHejI8t6xdtnF0rOdfjdHss3vfG1MWxNNGU3xY3WPBER+9NPcf7kTFfSICzezYsQceoJJ71GkgVw5w4g/YfmX3XncT2RqfDtgArCuFdHMpy5SI1PJLWiwp6kMn8VXuTnUD/2DTmAHheCx2gy11XIK1XwZb5oFP2mNiJrU1CG+2ROkCrpp9hiIeVxj4KwZruMKttgzwzhncGstO/f++VemeH8NbcqawAXCDSvhp4x3uautDIh2g5AS5+h1zNjV0EbCuFh2Mh45T1c/a/Z0EF/9r1fyrxa0ZHRQ+qlVneT+noIcWX7JMo6i2L43xVEvqA1DoH7uUv2MF9hWtHUce//c5aJQgC9Cc+yV0EmTDSaT87scTnt01Tcw69o3G7LnAt07IOV74glBorH428645Gejeo1mCtKbxq6atYxPQxi6xXi5qH5eLVl/hzfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 03 Nov 2026 03:24:58 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] maple_tree: race in mas_prev_slot() when root is emptied after mas_rewalk()
> --
> 
> [Severity: Medium]
> Can this leave mas in an inconsistent state if the root is concurrently
> emptied between mas_rewalk() and the mas_root() read in mas_prev_no_node()?
> 
> When an RCU reader in mas_prev_slot() hits a dead node with save_point > 0
> and min == 0, it jumps to dead: and runs:
> 
>     mas_rewalk(mas, save_point)
>       -> mas_state_walk(mas)
>         -> mas_start(mas)
> 
> If the tree holds a single pointer at index 0 at that moment, mas_start()
> sets mas->status = ma_root and returns NULL because mas->index > 0.
> 
> Back in mas_prev_slot(), mas_prev_no_node() sees mas->status == ma_root,
> sets mas->index = 0 and mas->last = 0, and performs a second RCU read via
> mas_root(mas).
> 
> If a concurrent writer finishes emptying the tree (setting ma_root to NULL)
> before that second mas_root(mas) read, mas_prev_no_node() returns NULL.
> Because mas_prev_slot() only checks xa_is_node(entry) to detect a concurrent
> root change, it returns NULL with mas->status == ma_root, mas->index == 0,
> and mas->last == 0 instead of mas->status == ma_none and
> mas->last == ULONG_MAX.
> 
> Could this leave callers like mas_prev_range() or mas_find_range_rev() with
> a bogus [0, 0] range, or cause a subsequent forward walk on the same state
> to skip index 0?

I plan to squash this fix into the base patch ("maple_tree: Fix rcu
reader NULL dereference after the tree is emptied"):


From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree: fix reverse iterator state when the root disappears
Date: Tue, 03 Nov 2026 04:28:56 +0000

A reverse walk restarting from a dead node can observe a direct root entry
in mas_rewalk() and then an empty root in mas_prev_no_node().  The second
root read returns NULL, but leaves the iterator in ma_root with index and
last both zero.

Consequently, mas_prev_range() and mas_find_range_rev() can report an
empty range of [0, 0] instead of [0, ULONG_MAX].  A subsequent forward
range walk starts at index 1, omitting index 0 from the empty range.

Set ma_none and extend last to ULONG_MAX when the second root read returns
NULL.  Keep the existing encoded-node retry in mas_prev_slot() for a root
that has grown into a node again.

A deterministic userspace Maple test reproduces the stale state through
both reverse range APIs before this change and checks the full empty range
afterwards, including a subsequent forward walk.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-194509@kernel.org
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
---

 lib/maple_tree.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-reverse-iterator-state-when-the-root-disappears
+++ a/lib/maple_tree.c
@@ -3930,6 +3930,8 @@ static inline void *mas_next_no_node(str
 static inline void *mas_prev_no_node(struct ma_state *mas, unsigned long index,
 		unsigned long min)
 {
+	void *entry;
+
 	mas->index = 0;
 	if (mas_is_none(mas)) {
 		mas->last = ULONG_MAX;
@@ -3940,7 +3942,13 @@ static inline void *mas_prev_no_node(str
 	if (!index || min)
 		return NULL;
 
-	return mas_root(mas);
+	entry = mas_root(mas);
+	if (!entry) {
+		mas->status = ma_none;
+		mas->last = ULONG_MAX;
+	}
+
+	return entry;
 }
 
 /*
_


