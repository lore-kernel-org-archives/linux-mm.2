Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A821C5AC80
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126486B00AA; Fri,  7 Aug 2026 16:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8B56B00AB; Fri,  7 Aug 2026 16:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10DA6B00AC; Fri,  7 Aug 2026 16:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B00F36B00AA
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:44:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AEF01C0229
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:44:58 +0000 (UTC)
X-FDA: 85075652676.15.68A4910
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7547DA000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:44:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fbhUoOHV;
	spf=pass (imf25.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786135496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxeALLBKEFzG8grdo2KBziKP2bhd2rDL/QAmIFoybDg=;
	b=wGX7DvnKvXYiQbjHtGr5FG67h+z9ZlysWgqcz6oQ3Ju5ibCWTevhAadXRYK8bVA5tfolUa
	DvWN1wqECP689/EE+zQPky2WUrtHDjhLt/vRtlgdjO3fvPuwSy0B8domSIijNjcL8XGVZG
	bzfVJfqwcJbUrgre9xlb7KGUWj+viaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786135496;
	b=iu1pVTfJyYGLvWVk2qWRn939S4km4lJN6c+REsyPQ8aPZSGFNjPmEq8NLwPCU7TK4GXd9V
	bBarAsisNLbM73pOrVYhgBqS0qCOvhPrYnGWfL2n1GstIpPQKXrioZ0KyZLagbaIlcM3er
	T+NoNBs0Un9NM0JRg7ux1PbyeLYv0S0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fbhUoOHV;
	spf=pass (imf25.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zxeALLBKEFzG8grdo2KBziKP2bhd2rDL/QAmIFoybDg=; b=fbhUoOHVwnsnuOQs3MV9BlWZuy
	UwyGtwxNfET5K2AaSb/jGzgqWdf9sXiu+LJH5ckVWWGObD/MEdI0TPlO7FwZxhqS2XLJTvvA2rO8J
	hrZCl2J7uORp2MH9fjBhD0bY0T33eFJIrY0QUu17QMvejx7b2HPDBfsVlAl0MhGFWX0vSm/BqrldN
	htjyazvLM3/4MEy5FxEWPhvfF3IS7WEcP91vkd2McCuDo/t8SZuAqJVowUC8CJYyK7ALe4pNbgryc
	aXolsdximWUjQ0GpkrzfJ4a547OkAMms1JYrQeo+epoG/YvftXr0ZFNNZ9Nl9rPGLogefjXB4iLOs
	ft9tXDKA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsRR0-00000008jbZ-2rU0;
	Fri, 07 Aug 2026 20:44:54 +0000
Date: Fri, 7 Aug 2026 16:44:53 -0400
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Rik van Riel <riel@surriel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, pfalcato@suse.de
Subject: Re: [PATCH v2 14/19] maple_tree: WARN_ON_ONCE when allocations fail
Message-ID: <tryturkc7cl6wckhogh37wj2z5irldp43t735mqocdfc2mfgzg@jehcfg5eiesh>
References: <20260630190843.3563858-1-liam@infradead.org>
 <20260630190843.3563858-15-liam@infradead.org>
 <20260630160208.b6d1e09d60c50c8fbb80e830@linux-foundation.org>
 <laaqmevk454smc2uotd37rwjz7ijekfhv4hyv3wgbp7bql2bas@tqkyygz4wm6t>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2zydfjwo6sc3k2am"
Content-Disposition: inline
In-Reply-To: <laaqmevk454smc2uotd37rwjz7ijekfhv4hyv3wgbp7bql2bas@tqkyygz4wm6t>
X-Rspamd-Queue-Id: 7547DA000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: itdgd8bhfoicqqfmf5dmdkibwoao5o5t
X-HE-Tag: 1786135496-560000
X-HE-Meta: U2FsdGVkX1/3bQbP2OlYDpxLF/6CBin6hia9wHsV5k3sjGFhYh2eMt/IJf4lr/VKLQgUua3RkZx8Pz672TAhd0vld47VVRHLfkhbV8CxrduhhWbmI+75GmHmvOxLMh5ohxyMMAQF7D9VEdBOd5pb/SQ7nJICzBH/On7SggGh0AGy+BRyEUgGqzQzWWVw5CW9E0jk2aIickiemPtI57Ty/II+mxYenbEDmnkcbT5qnOrJxpku7yuoEe+RPE+wKtvHY9P2++vc6O1E372j82/7uvNoTrYB6X5mBwZnFt+u5iw7hsaiku0AsI4M/vMK9vWkxKCJCjQZvdBPIvu2wM6SEaBjG/yeqlA5B23LGsmXzO1TMjNExT0PvlUYTE+GQj9XyRmhnQOaONp55meIDaLFD7HLSdepl3EA9yBR0xsquePC+TGN0tYIgih2GsvAlUZ2AQFITOGI2f0mo2BFm2gf3j1+2yvN50vUS3hjjBHCeJVGXGDjP0I5rudBmn1hsawTsSoSH+Mznaa3K/mg6mWUv5AmeMbmPfIfL+pVPjejRIWWZsrctmla8l73H9AvPK+JIE8qVO+qPSqD6WzBARzjnLdOGy9oJdaeQHFwVbCYVNW6F8m2+dV4zqlxdhZnzlmvRy9XE/Dy8r0gz8kmzT8VjIqG0Xy4OuDSC0lhMzwUQdUXtfwsqr/V9a0AwBDFo3G0eJt6ZzNFdKrztHnLFWhKWlTR513I1TOlN1++jfGzEus7ZKwysfBU1J46OzS6ThRM8dR+Gu3HDk6dgzpzVrqAbHU5TY0Xl55TAz5YeIb4d33T8n0kz5ilEHmHKAfFydlQG7SA5vGduxqjWwGLjNckDvY5l79OyDhWlAazbfnDmAycPN/9im12AWD21eIHZfoO+XkPOAe92AbpcP+uvw0/uRUFMQ7SzWGg7ygKCXzJabeHE3UuCmGJ187iXyl58WABIebfCaUEDsP4+g+iwid
 hSk16CtK
 bEHuPDfxx0/6u+EXF3Nwss/KrZ6iuIujox8xOAwgAQoqnlzt5zn9je1rn449nBWgQg96F9Iz0/EuYCbya3lgV1mQrT5KGA4etx7+lhZCzBajGQOMBkblSKcQ5yZ35rpx3Wz7VlVGhBNBUHciKv26gpAb7bLTDC+LclCUmuVSpyEL7/MONmx3reeMCBKT+DCZeP6OSvs9UJKP0UbxNASnq8tqf+f12nK3411QmNXF7K//g9H8LXXtYSvtJp9vlazz59LTLwg3uWW+KAThIb0QW68UImELL1tucvD5jFCUwSM/EsiR07pjwA/2ZY3F8S08tBbve0CbCHWFy98XZnKZU9E/TzQE00RNA0gI2fpTY65JS5kzIcXvHEUSVAkDpIBRmF9NTCRfJX2ViyP6lVeIjJECIGnGoluxiHi7FgGkmhVI83qp0ULVVnRa75Lm3gX1kakHDyvVHhtq+lEN1IM6QxbqMZhVnxTPDZ1ThkSlspu67KAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--2zydfjwo6sc3k2am
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 26/07/22 12:38PM, Liam R. Howlett (Oracle) wrote:
> On 26/06/30 04:02PM, Andrew Morton wrote:
> > On Tue, 30 Jun 2026 15:08:38 -0400 "Liam R. Howlett (Oracle)" <liam@infradead.org> wrote:
> > 
> > > Allocations should never fail in the circumstances that are expected to
> > > occur.  Add checks in the code to ensure the circumstances are correctly
> > > set up by the user and warn if they are not.
> > > 
> > > Also add a warning on failure to allocate, which should never happen.
> > > 
> > > ...
> > >
> > > --- a/lib/maple_tree.c
> > > +++ b/lib/maple_tree.c
> > > @@ -5720,6 +5720,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
> > >  	if (likely(mas->node != MA_ERROR(-ENOMEM)))
> > >  		return false;
> > >  
> > > +	/* Allocations can fail, don't do this. */
> > > +	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
> > > +		     mt_external_lock(mas->tree));
> > > +
> > >  	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
> > >  		mtree_unlock(mas->tree);
> > >  		mas_alloc_nodes(mas, gfp);
> > > @@ -5730,9 +5734,12 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
> > >  
> > >  	/*
> > >  	 * Return false on zero forward progress.  Partial allocations are kept
> > > -	 * so the retry path will attempt to get the rest.
> > > +	 * so the retry path will attempt to get the rest.  The failure should
> > > +	 * not happen as we try our best to reclaim.  The user would need an
> > > +	 * external lock with a non-blocking gfp in a low memory situation -
> > > +	 * which would have triggered the first warning in this function.
> > >  	 */
> > > -	if (!mas->sheaf && !mas->alloc)
> > > +	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
> > >  		return false;
> > >  
> > 
> > Can either of these warnings duplicate the effect of !__GFP_NOWARN?
> 
> From what I understand, __GFP_NOWARN is about suppressing warnings on
> failures because you handle them at a higher level, but in this case I
> am trying to detect incorrect use of the interface.
> 
> That is, if you want to handle the failures yourself then you should use
> mas_preallocate() that is designed to give status on the allocations.
> The following call to mas_store_prealloc() will not need to allocate or
> check for nomem.

There is another issue that was discovered by syzbot on this particular
point.

After discussion [1] on the syzbot thread and off-list with Vlastimil
and Pedro, I have opted to avoid failures by using __GFP_NOFAIL for the
retry in the erase and mas_store() functions, which don't report the
failures well enough (or at all).

I'm sending the code out here to apply on top of this commit to add the
extra gfp flag on retry.

Jason has requested a restructuring that I'd like to handle later due to
the late cycle we are in at this point.

Thanks,
Liam

--2zydfjwo6sc3k2am
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-maple_tree-Remove-warning-from-mas_nomem.patch"

From 7943966dfd4eb8470d79da1fef2d81cf4cf59983 Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Date: Thu, 6 Aug 2026 10:23:00 -0400
Subject: [PATCH] maple_tree: Remove warning from mas_nomem()

It is possible to trigger the warning in mas_nomem in certain call paths
using valid gfp flags.  Drop the warning and handle the failures
differently.

Instead, have mtree_erase() and mas_erase() use __GFP_NOFAIL.

During the discussion, mas_store() was also flagged as a potential path
that may fail due to implied gfp flags.  Changing those flags to retry
with __GFP_NOFAIL is a viable solution there.  At the same time, adding
a might_sleep() check to catch incorrect uses is prudent.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0954d431bf981..4fb7a209dcb2d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5577,6 +5577,9 @@ void *mas_store(struct ma_state *mas, void *entry)
 	MA_WR_STATE(wr_mas, mas, entry);
 
 	mas_may_init_lock_check(mas);
+	if (mt_external_lock(mas->tree))
+		might_alloc(GFP_KERNEL);
+
 	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
@@ -5609,8 +5612,7 @@ void *mas_store(struct ma_state *mas, void *entry)
 		goto store;
 
 	mas_alloc_nodes(mas, GFP_NOWAIT);
-	if (mas_is_err(mas))
-		return NULL;
+	mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL);
 
 store:
 	mas_wr_store_entry(&wr_mas);
@@ -6351,7 +6353,7 @@ void *mas_erase(struct ma_state *mas)
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
 	mas_wr_preallocate(&wr_mas, NULL);
-	if (mas_nomem(mas, GFP_KERNEL)) {
+	if (mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL)) {
 		/* in case the range of entry changed when unlocked */
 		mas->index = mas->last = index;
 		goto write_retry;
@@ -6402,7 +6404,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	 * external lock with a non-blocking gfp in a low memory situation -
 	 * which would have triggered the first warning in this function.
 	 */
-	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
+	if (!mas->sheaf && !mas->alloc)
 		return false;
 
 	mas_reset(mas);
-- 
2.47.3


--2zydfjwo6sc3k2am--

