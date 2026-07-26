Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1618FC531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 10:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77166B007B; Sun, 26 Jul 2026 06:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28006B0088; Sun, 26 Jul 2026 06:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E8C6B008A; Sun, 26 Jul 2026 06:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6026B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 06:46:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F16AB1A04A2
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 10:46:18 +0000 (UTC)
X-FDA: 85030598436.10.9995813
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0387140008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 10:46:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AFOQUzRh;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785062777;
	b=6ptV+XiY6LIUPfzL8muCkfxFgCbViFIE2x32wL+1xhRHqE/z4VLOhsdNuSh112n412Lly0
	avG1tCOPWUanSOpOfZ6RFufFWxKdmEBxsdcEuekkQz11tYE+JgA5uYql4dXyXe+ZNOgUe0
	lvxIY0wzBLKAKK+QNX8kBR+nXhk76Co=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AFOQUzRh;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785062777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MBcq9ozZMfxwB5Gw8TbZEQZIWR4z+wrqGI1WzSpxn8=;
	b=JSQPbueB0nWcTBLOtDIH9KZwjYDoq31jAR156C/+WgEJlATGKhNfuxoEDO0jJPmu+QyhbC
	j782Wx+q+lyYxfHIKTOQMT57nF0N7MXvvezQLMEaUb0kbtWkfjriOUgrgYaq29wYksq/5Y
	Me10GgztuAO5OFuvX/ybDrAUXARYmjE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1MBcq9ozZMfxwB5Gw8TbZEQZIWR4z+wrqGI1WzSpxn8=; b=AFOQUzRhcjohlfgLhTeZT2WVV3
	SJxd0ruDFJPzlBdy8GgT02rwMLNoQHe4hmvkOV7Q5mrF9q0Z4Qeck9vYwVnoTxRcxjH0Ysd6Nf9nI
	fMq73cpA9auY10NymR4wwuHe6c47pGC5Lg7FcX54YgHKtRUQS5P7z9jnygDcPRCor6vR7zYkmNcpt
	iVjoohE7qqYzEUhOJJ01MydhweSK8F+dRbp5qp/pGLkH0OJoGiIeqRXQbh9Q7a9w7BdD89TZgWsLT
	2WEVMBFnOiTCVvN3cLU/qKn6ASPMHDrA2qeXmdvyFVrMV0jEfb+FC5KVnk+tBovXcaW58lcVMAdn8
	uRG1J7EQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnwN3-000000085wf-2tJs;
	Sun, 26 Jul 2026 10:46:13 +0000
Date: Sun, 26 Jul 2026 11:46:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: kees@kernel.org, akpm@linux-foundation.org, gustavoars@kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, david@kernel.org, urezki@gmail.com
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc
 allocations
Message-ID: <amXldUo3LfIGs-zs@casper.infradead.org>
References: <20260722142936.3287702-1-dev.jain@arm.com>
 <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A0387140008
X-Stat-Signature: 6q6irxean14nyn87soawcx6wm1krtu99
X-Rspam-User: 
X-HE-Tag: 1785062776-396189
X-HE-Meta: U2FsdGVkX18quXXl/Wh8mT+3vkVtiMBiXzkkaMogj1FtmbDfKzF7nKHgl/uh24i0lCcMvwEI/aE8ZFMCaS1Ecvpb4UH673xu6eKJ7vwO89p9vyIaqpM3q8gNNhRN62k7GKv1hCLnXTsGYWHcWCMcQ1ErsuK+Qp5oYqhskrRrLi4pu5Au/jVYWRChjoDda/EToTq65n5ODgWoMJNX9da+jkWRUlbOl43Tn78IEdj0C59KUbM0lgm8xNp71qHMSA+VXhkp/qN4Nit6GjEfHwidbZKEpmwvB9z0+sixcRep7J8TeK4MopnJyHLT676RlHacvVEz3rEtPy9ZDp2aXXTDEZ4IH7mdMonka9sslxfdWL+SxfIIsJMfQL7gcaWv5TJR8EY5UvBbELlGyUBxGWbRQZRI/sZqXJSZebUsJ1Z7DOVgOBVp2oReagNblkcXqVR1hty+jrmC/Xn9Yy7MWejRy6yNTE6JuLz08FVoL25w5dgQ9+HiU0qGWd8sKBXFbgV09C5sb7wZqHim5HAGDgza7e1g/8g0YcljN9Mr36kjKu/ILPQo/4tehmSvKD/opwX2L9+YXXz07/HAsJ96b1rPDxVhUBnc+/oCrENydZhk/giXJPjwZ8yzB1GCY2uaPwRBFvN1/8QIw0qb/2yL20d+zvB+yTuk6nv2i/s1KQiRJYMeLbDcQH+rh8MpzTsZ76HJ6Q+r3z/P3n5ZWgsBYxpMVros1W8BVJU4Aw0U2zWzSR30lDpBRHua2PEl4WPkLpf75+aQocNWIFEPDtVFrvflZ5yIZT5q3aDuHhrCBPRQEHllSAajxAeOFGE4LibnnO4v8yx7NIWF1N/cNT98X7qNWWIrUF0McB5ROa4BPz2GNgIt9uSQ1eTfns5J/B61oWjXtCMkrWWNZTz/W03uu9DhUqCQs/f2UJrM68AKjmlqeflhAG1muerCaz1F+nFwIHZ3SUGwWHvnC1/5JpTA9TC
 CZYwByKT
 jR1W7maCiZFzde1FcxjOhH8BG0mawpHmcZIGoCFcgquvcRuvanakLnkhBmp8M7Bqvv4Zzz9Oc5HLdhuB7EQJpoCTFY3pYTbz1VynqzVZWyPzykzaJb+VueNZi37bqrWVjKiGLjlbA79w6wO8mOk29hBq5eBsJXRGOBwrz5iOrSyp+C07q9/AfpemQokdL4sA98kyXdB0JJM+5Oy882mYUASUrCKzj3QCs6bkWUHeTgtJrLul6BomQVcDCwfwz0gmoGrRdLCuolroFlSprM4/dLJn8Wc5Ugmh6VpaT1wkgQFTy3+CAJNbvgYUyXuJE0+7V8dpFBKKbOvWd8cM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 02:23:20PM +0530, Dev Jain wrote:
> On 22/07/26 7:59 pm, Dev Jain wrote:
> > The vmalloc allocator stores the actual allocation size inside the
> > vm_struct structure. We can use this bound in usercopy instead of the
> > page-aligned va_end to catch usercopy beyond the actual allocation size.
> > 
> > For vmap, the requested_size field is always page-aligned since it maps a
> > certain number of pages. Same for vm_map_ram (alongwith, not even having
> > a vm_struct). So the check is only relevant for vmalloc mappings.
> > 
> > Because there are early vm areas registered even before vmalloc_init,
> > requested_size may be zero. So also check whether the requested_size
> > is set.
> > 
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > ---
> 
> Sashiko:
> 
> 1. "Does this locklessly access area->vm after find_vmap_area() has dropped
> the busy tree lock?
> 
> If an out-of-bounds pointer falls into an adjacent vmap_area, and that
> adjacent area is concurrently freed by another thread, its vm_struct
> is freed. Additionally, when the vmap_area is moved to the free tree,
> area->vm (which shares a union with subtree_max_size) is overwritten
> with an integer size.
> 
> Would dereferencing vm->flags later in this function cause a use-after-free
> or a wild pointer dereference?"
> 
> 
> I don't get it. So usercopy is checking OOB for an object but shouldn't
> assume the existence of that object while using it?
> 
> It is a bug in the caller if someone does vfree() while usercopy is operating
> on the vmalloc object. I don't think usercopy should handle it. For example
> we don't handle it for slabs currently.

I think the question Sashiko is getting to is how we handle:

	char *p = vmalloc();
	copy_to_user(p - 4);

My quibble with this patch is that you've made this more precise at the
cost of making it more expensive.  Is the extra precision worth the
cost?  You're not running into anybody else's allocation (ie these pages
are allocated to you exclusively), so I would tend to think not.  It's
like calling kmalloc(93) and then accessing bytes 93-95.  It's out of
bounds, but they're not anybody else's memory.


