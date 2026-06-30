Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D615C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659E76B00B1; Tue, 30 Jun 2026 11:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6325C6B00B2; Tue, 30 Jun 2026 11:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548D46B00B4; Tue, 30 Jun 2026 11:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318C56B00B1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:00:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7B948EF60
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:00:26 +0000 (UTC)
X-FDA: 84936890052.28.1AA55F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D760EA000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:00:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5QS6KFh;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831624;
	b=vnhn1F13i9jvVAIAvBiNpGpGiYeLQgMvgzWZnas24h996iHF/nl78VgV879XTAVd2S1USg
	DdmrfN9CDlfLAAhCymtauuqhHX9BgoiHoaFES3Ye4gVKFNQ+mmTGoVo3jqccyJQO/lC/Pt
	0UvM0Fwgdu4zGO15DpOWt3zIAnrP+Dw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEjljAT8oCBe6H0+DZxoSp7D0aXaqVksk3/Y1JCjZd0=;
	b=cqQ+X3W8j91I7de1SWNjDf+aAeZ1KWyUgOgW4fElvCvJClCdrJTXrDj1VibLyar6oVZRTN
	ePzCIGnAb1Bc3npB/WzVE8FHZEFzsGvEWqPS5z5lj8S2A35ryCdK6RlOmtLkxMxcBobQs0
	W1WpjwPgf1+/ngKYs75Hr9629LSgBEE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5QS6KFh;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A59760018;
	Tue, 30 Jun 2026 15:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB01F1F000E9;
	Tue, 30 Jun 2026 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782831624;
	bh=lEjljAT8oCBe6H0+DZxoSp7D0aXaqVksk3/Y1JCjZd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D5QS6KFhU/5DOxHs4TOWy0bffEu1vpyOjarro1YAFzBSMYJ0jmUqd8LXAXR5OSaYX
	 lT+ZeDgjVMLyeTBPni32H7bS6yD3N1YatU8vQZ3m4XXPIvFBZ3bClUETpdYbq6NLN0
	 D525b55NxYXe3NhT9lr1DvZDoZmx3XKZXU9PtqtAN+uGBEEWkUx4jDIMjFq5ywIOYB
	 0k2hic87Cigrr0lRB35EPiUya7c9cB7pohffQfgPmFBS9sx4Q0i+DDDGdU7K9/pwAh
	 gSQmlmDsiNreWpKLyF9SfSGdt/GUWU4i07X6MW5tXoGFu0D9jvOBINDUNGr6sQp+rf
	 9Ql8aWYKvA5/g==
Date: Tue, 30 Jun 2026 18:00:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <akPaAp-0Zul8uVga@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
 <20260630123150.GB7525@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630123150.GB7525@ziepe.ca>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D760EA000E
X-Rspam-User: 
X-Stat-Signature: p31qcjre3i1ze3rjiijiii8mex81mw15
X-HE-Tag: 1782831624-322395
X-HE-Meta: U2FsdGVkX1/Qao58vKOfV/53zzLKH6kPr5OC8/dV/6TPZryudd4YgDdsUNaLV+FXON/7dCiXmF6A+AI1Jd/Q41eFvtvQGIfddZFwunkeKG6MRVFwrXwhnCdKY7oC6bKtAG/TB7wrZ/0KeOw7ttEcSgi7iLgHf+C5iSISnGsQ11+qYUx65cUAnD0YMWt6DKtoziRICdBK9c4qMS3lei4cCVI5xvlsd6peuMG58DzENXMrCcvURjdbH4IHNHj5BRXnNDpzFk+XEJmqgDKasiXz6ZOH7j0ZbaQnDGE/L220kqhDakVQwWvbU/GPBBdExWTykDit6zeldA/apuwA25et3YKI66GBIKaobvpK9osj/31yCeU6v+frXwUyl2P9fSu2W6/zxYAms4zDJST9gNTr8cIFhZnFKAIjw/UgQSBmautWWS/M+myLDbkFjbfSgNmrfVMvwHxj0gG2YSPBA4oFQ6T3fbm//W9M/9sknjelx5wq30DUQTSB41SDorYVZ17pE1D126wa71Dw3QENF5ln9bWvxNhwZJpiv8TwmPxRE0CsJtS7mKO4S1D9QhOXtEKT3+mgWxSNoWzM65JfY0SSRdfT2LnBwke6bcaotSapU9lXF9oXXU1xZwq+LR6sXS/GPGMz6HeYxgYJbukE+4C4PUbelGVmLg4AT2zPVioW0GR8fbnFqk3TZiPYANM3onJgkfc+aCdnglSZhsPNBGgflNwkjGFe4VR0upF2/9qkG98cW0Azvk2Qnbw8qRhN7XQsC1vb5niwlItDsJaWmhRYGzZ3nFl1xJafqYkCK1PWCSQ8OvIMuvcS+XEYmvb2bLcuV3e6hzj1fX4Q95ZsyCjGSZ6b+WLmB9OXNPo8fmhLFcoc08fJNwInG1QFK5+G4GY691h7h9FsE3qzpNPthvjGoKMK7APCzZCj+tkNuTSD2pZ9FcCQSKwOHomfYruaLZwSfKKKxxzCIU++7xy26uq
 oJIskc0T
 BDputxHHJFYPYZzPRWgLPDAAthd3lyK40YXp7J9z4RKU5rVX/PDCuAsdfXK1ENcHHZnBuCrrmeTZF/hKAcb5FUC/ds/1bEt2orngsNuMi5nCpBoIec+6LPXLmrd3r79ZHx6JGlyymUxtcMKYq1rUAJLWJgSdWahf2ofNYFKHgzVkO1TojCo5LW+IruryCH9pfjMIebHomYxseKTf8YEf6vEGdm4arVY6rzrwhUHMBVaycQh5TafQhVOAY4SaR03rcOhyPCPa9Dv7bNsVRH9FrME+A7ybUX3j683wpPJyDC2BVj5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(adding Vlastimil)

On Tue, Jun 30, 2026 at 09:31:50AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 30, 2026 at 01:52:29PM +0300, Mike Rapoport (Microsoft) wrote:
> > ib_umem_get() allocates an array of pointers to struct page for
> > pin_user_pages_fast() calls during memory registration.
> 
> A whole bunch of these use cases in rdma are really "give me some
> temporary memory, I want it fast and as large as possible. In a
> syscall context I will free it before returning back to userspace"

Not sure I follow where "as large as possible" comes from. Here it's
explicitly a page.

And does "fast" mean that vmalloc() is not an option?
 
> eg we'd be really happy to get any kind of high order page here.
> 
> So, how would you feel about a new API?
> 
>  void *kmalloc_temporary(size_t min_size, size_t max_size, size_t *actual_size, gfp);
> 
> I know of a few other cases like this in the kernel at least.
> 
> The implementation could try to find an available high order page and
> immediately return it, otherwise do a small reclaim allocation?

How do you suggest to decide how much of reclaim should happen? With the
usual semantics of gfp?

> Jason

-- 
Sincerely yours,
Mike.

