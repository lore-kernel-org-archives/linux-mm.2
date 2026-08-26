Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CDDC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6AC56B0088; Wed, 26 Aug 2026 03:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A686B008A; Wed, 26 Aug 2026 03:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930436B0092; Wed, 26 Aug 2026 03:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEBC6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:35:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DC7D802BA
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:35:47 +0000 (UTC)
X-FDA: 85142611134.04.FF6D708
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A92280002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:35:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JddnPsIT;
	spf=none (imf02.hostedemail.com: domain of BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787729745;
	b=Ot9qDLe5887ezBbmZ1qNY3Wgdb1hjPK7VSpTRMt7TUQzhVYHJ5EFWHC0f5BnlBrTNc1Syh
	csKmc9h5ADEDpZoJzRCRoghZ3fvvB2Hp/Iy1ZPXrwrJqLz/tS5J7IqmEk3ORAgx52zNmeV
	arAiC0hepaWaatRsy25lY5Z7LOkQYv0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787729745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPRq7wCujCDeIBCoHVvXJ5nm+1AbLLNDAy2xmgNZTnE=;
	b=my1Z5ukchfWSC9ND4o6cifCurh57MA5MnC8sPcbgi1WHmYQV7ERIXXaNW2ZwpieXqvdVVT
	Tp88SWL5Kd9ymMf8PLNG3XWRqc/VSSFoRXR/9IETj9M/ekTlVRP5kdlyJX85/FUn7IPQ1e
	uJq3adStVgd+5/ic8wXpm6rAmykR6sw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JddnPsIT;
	spf=none (imf02.hostedemail.com: domain of BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IPRq7wCujCDeIBCoHVvXJ5nm+1AbLLNDAy2xmgNZTnE=; b=JddnPsITM03lHqVUsASwTa78sr
	sQPeEVy/iyIcUj1u7ZhEGjndPuTekg40dW/K9n9qyFIr3RolTqKuY3jsT6Lil3oMbp342RR39Lm9D
	RgHNVyc+mpUwtjCfEvMCzuptbea7GBYjEjJkvXevoAG4TQOXoEBMlxKwUv4jI5taXErm7E3yeh2KH
	snVNNaSIKmHvDBfdMbQZzVm3d0oT5Ya2/Kkz/VlXlbctWPQ/4o6Cp/v8TgOEWS8T6YJ/j78vXngZL
	R2tJhN9imjgBHJM9eDH98xAVIT03D0VgWLJlP8J8gaLxjDbn/Bsut9jaEZd/ccckgL+EkgZTGf07r
	c/B3L/PA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wz8Ac-000000021CP-31ag;
	Wed, 26 Aug 2026 07:35:38 +0000
Date: Wed, 26 Aug 2026 00:35:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
Message-ID: <ao6XSh1YRiqPA3rA@infradead.org>
References: <20260811025157.1632867-1-riel@surriel.com>
 <ao1JwEAeNcP9OyKR@infradead.org>
 <a10c74df79e1db6a9a2448220fe4c4fd6a0e5bdb.camel@surriel.com>
 <ao5t8lxaCWQvph-l@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao5t8lxaCWQvph-l@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A92280002
X-Stat-Signature: u38o6uh7gqfn7pg49mf8mpjujrb9khaw
X-HE-Tag: 1787729744-264437
X-HE-Meta: U2FsdGVkX19dvEKLZiOpzq/9Y27ZSM3vjIFF8s3Q1Vq1X78t4hsBrfu3fF2DY03e1qJq/H8/EoT8VoAwTXidl5ClccIJaM+RXGq5HLPsDFIEaj8NWkm6t62hNuNKkZ9nVPi8E1Xq7VSsqQiM7F8A48QJ4Lpyz3Ye+n6oW1Be4dTDfHeS7fkkqshS7s2oZEKJLR8mCJQ0Q83GX8sWILUPwLtuerqSlbvY/S+cr422BM2+fKerWqSsrELiZCK8tSHRxiGMM8RE7zffbaJMuIMpl/lh6DiKeHBBuqbYfWmO0R1+Aw8AEe3Bs0E5s7X1zrgwAYz4WvjB/NUW0cjYkHcGnjF5gns1EHFMp3zLL/riSTmVKFP/tZ6t/yhM5fvPIrUj6Bopdxn6EiwzpP3EasWSOaXKPFa5sNwYtTMh5mRWkCArHzp/lv+lLTxPcxLbR5eSmY8wjtYngF2KIGEgbXZ681QCD+vqVwXCFH2RzOTRz38JAvKtr+ivHn1U5gqYOG1KRT74KM129XX+Z4IKEMgS0FeCsjSxHQCLeQ2kIXYTgvE0psl4fv+PJQAFz5ZblMhgdJH+qVTKp0FMXdylcB0rbH961874xHWwz8JW2kM9Uio0z9TPHOCuauO5ThbErmUUJ+E7ag9wAXXD53OLct0LyLbeSvCfxlBR4WIYPwBJKqtEvVG9dLY8on9hxO1Sw342TOd9CCBjgG+iYq43yY/9P7JF0lMJkO4lW0uiedi42H3807nrf9sOOS5R3ljp2yphzAYGgfrI/KmNcgfEl1m+QTl7e8WaqwOehxiri7IGrtNzE9EIiCvx8wIMVkJaJILTo2Cd6Zg4NIIxZZhzl7+btAm12U66slCmScwDuyfpMYF3tJnk8oVPD4re9nKZCfPE7R4kCXO+6SI84v+V0aJegJZGA548UllrsD3lTJ2PEPFUCiZOz6u2olNk9Ds4kpjkQRhjeRX/HkJjg8jj++I
 hN+CK1pV
 WSbfnQFk+ZwI8OZYesxW8pmQDOOnQ+GlsIli+UYbpq/26bbxp5UbzorKx6FN9+eXNzzAoMhj8hwmeflgCyvZznsyDuagHeknh71i+q6WQoTTe4SiKskGU+saIW3YEPAnNEa7PzoARLwlHzqDjb2ufqZrOzf25bt+wcJ9Vtprw5VVEWxACiUVuGRp+b9xkWOqfs0dAuoDbrYJYM+6gInr36SJNFdEGAt/exzQb6zLuyHOaWZVd8Q1oLGXC8YEPsfqMQlMWvdmm9NYE8RWNvDLXB81rugSEISZGRho7se7nZo0cUmZFvapdt0hOqL7uxrMuYlRx8DTWzW64pDZblXGIRs09kPJXGGzDDXQAHhbs3W46QlqDntQE94C1SQh5UP5ThyJ7B8VxOsHKKYD9f3CWmGYGM7gWc/AbNR6FOueBsvfsHPqVKPtsYKhCWeShbBvKLcc4zzdTn7pEQyHWgzi/UyHCrOBNa/ByK2F7FmIfMIXRhzFiSb6LLsVviPM+0snVGGWV8FMVk/121kjggUq7dDQKA/b8JChJHW2rAzVtjTemJ2chXmB6PBP2bBLZZi8iPJt2EUKXsYlOx64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 09:39:14PM -0700, Christoph Hellwig wrote:
> The other callers of iov_iter_extract_bvecs matter more, but this is
> the main user.
> 
> And iov_iter_extract_bvecs right now is very inefficient when used
> on larger folios, as each call to iov_iter_extract_bvecs and thus
> iov_iter_extract_pages and iov_iter_extract_user_pages can only
> fill in up to 256 pages.  On x86 that is a single PMD mapped
> folio.  Passing down the bio_vec array means that for PMD-mapped
> ranges we reduce the calls into pin_user_pages_fast by a factor
> of 256.

Also in addition to reducing the calls to pin_user_pages_fast, it also
removes a fair amount of work to recalculate the bio_len in the
get_contig_folio_len loop in iov_iter_extract_bvecs, which has shown up
in profiles (although only marginally so).

