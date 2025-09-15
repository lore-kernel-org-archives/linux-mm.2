Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18379CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727E28E0026; Mon, 15 Sep 2025 10:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE5E8E0005; Mon, 15 Sep 2025 10:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AA08E0026; Mon, 15 Sep 2025 10:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52C418E0005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:01:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1174AC06A1
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:01:14 +0000 (UTC)
X-FDA: 83891646468.08.FD70A1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CB42A002A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:01:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P+u9tdzp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944872; a=rsa-sha256;
	cv=none;
	b=fv+kdT0dSz/3L16+7QL4NwNa/uk75hIyDMrFdSA35J7zFqhP9DKSLn0KzybA5fnLOpKOfT
	9NKruSPhl+X3liM2jXHGoB2xgdcPTLlbQHZXIgiOfqBCcFJ/UfunfwEmlp8/Y86CWWszEQ
	yNBXqUz1sZ93zvTxkJxuqjhC6MzXfhQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P+u9tdzp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atSd9tw1aLbC1YFHebDFztayclxsChQLwGxI3nriSmw=;
	b=xlVBda5qoG8Cj918U7psQqdObgigoVagEuJrAnZAnW6gzBAunJNQdsC23omgskAc4b4FHC
	0XhDncdcfke/AU1RG1lRSdlfbQ9iJwUb3NCiSIyltI6+ZI5d+GEaMyKemBXVjA6uTwqrST
	kKQZh/+OSanqlhLyZ8oqNa3WF+o0PKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33A4960231;
	Mon, 15 Sep 2025 14:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AE7C4CEF1;
	Mon, 15 Sep 2025 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757944870;
	bh=8olvie8tLQ2mhtW55gwpyxifDR7KCERuklBIHTYWwxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P+u9tdzpymz6xsyciaB6n3rt32DVJ8+TkdA7u70VzV72+k5dfIPdjeJj4BiAV+zKq
	 JwdqgqXiaXa9ZOFhYxBmdHIQQ1J+YbxXvkezAfMpAbWdM/v3gmNMLZr4DryGCc0xuJ
	 4aGtt9LYRSI+K270uEvon56jV/zEAzOjadorNAY2R31CCG0DUgHOcjSy7qVwIID+VC
	 FOYjTJhwajK4xIOdABSmdLMyKmZWIKZweFortDGA/PR7vnLLl2lleaO2D2wJAckTYY
	 KoaZWXsO7U5wdxe+NIb4cIKw8/UmhlyUFgs2mOlYNKMzs9veniITYpVrrQbm2szDQ1
	 Y4K+eoPfacPAg==
Date: Mon, 15 Sep 2025 17:01:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <aMgcHWxsEWnKzzcN@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
 <20250908103528.2179934-2-rppt@kernel.org>
 <20250908141423.GJ616306@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908141423.GJ616306@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CB42A002A
X-Stat-Signature: 335wywwocsid53f4er6roj65kymq3rac
X-Rspam-User: 
X-HE-Tag: 1757944872-788404
X-HE-Meta: U2FsdGVkX1+vRD3JI20DGcPnaQARmOjJLWHR5thlT5jVkYyfTLM46+8S/wivzjhG5FHRdAiE3K1dAFO/kg18VCZQ/+8SXoNrn8zpBmwXIWqoVC1XyfnBfmbwIriHAk3ane2J2J34sIvQRRRUVlkkYO/IA+XZwhUp9U71tsq6Rg/aeNrnz0kitz6dxQ6IoqbzXA8sgU7Q7riryuaq1RpUl9yHn0nTw8HpXjEunSbkT0iqaN7/mrXXTPw7CWKHloKhsKkmWCcXNgp79+weAHWDlndFegQZJ6PvWeuUgeqN4LyUvFfR5GJAAIO4qmV2gH72svsF22Aoa9479D0Evg8Q+d+ZRacCLDSuP7JxovhMFR02MI0OTZxXLVYFYhIWjRyHSbihy90dRWvTjpX66YioAxzbc/kZCR1b4gDMtFJZ3Us3UY1zonlsWSXx14n0jLlPbrfZvEhyZrI69yHV7KWhwbUj7ODwU5yExCFUUfxK2o70N8ZLKZuSfej29VQM+u5O92LLUV9+jxZ7aGMAHBBjxKVPsI8bAqvcz0ub3qBp4//UUO09Y2rGB8sO+qPOoTZ5ftLQrEKWPKXBs0+FfisNDjLKC8TnZtLl805/aNnIizEMuH/vh62LrR+5v2selZuz06j+RPjHhxXuR4kJkmYcQwDOl8Jb+ilPB2TAdj2yTfWDmK5bM3QbkUWaY6cgeypHhDfEEYM1HXEm01htSv63i6Qt7zk4jrkrcxoXuGnOZhuWmXiIZDpBJV3n3aeL/5d60lZlC7Ab0upZE8Wos/dolh/8ChYxDJztt8jbu2APJMtC/aScAjKd3bCvzZbUZuFFhrjn9rX93T6rvRIocqD21Z1hCcfhzulga5BIdyZWGVpVhwIQuF4mYPGgH0tdZf4mNQzqKXr+RNMaLBvcIyJbyL4uTgtIQwlFUt+5Ictv3SiAjyJSKWyibfm+ndaTVth+5gmwqQBx4ayXHlA2oYv
 GIsuLACu
 6qfoX/NZsn6wjVlqWq6j0Qq6+ayS0pcdfZovC+7in5xIcRWdBl/rUbx+sDKf7f9kmQ6Bu2gwPIRJBz2Oys6MPUoeCZofIbgrQJaoYhJ6SNkm8asssZGJaq4B53peqza8ExXMA0hq34nGL8S4H6t1ZrFf0eTFHz+Vc1mEDYUIo7DW/BWUanH5v0tvtN6+kwjiMi+81It1l7rZJW1zkKltywshxW/+x+qfnPqZM4uQ974dJ3V2HquEYJWa1xB2kpZTncKvk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 11:14:23AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 08, 2025 at 01:35:27PM +0300, Mike Rapoport wrote:
> > +static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
> > +{
> > +	struct kho_vmalloc_chunk *chunk;
> > +	int err;
> > +
> > +	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +	if (!chunk)
> > +		return NULL;
> > +
> > +	err = kho_preserve_phys(virt_to_phys(chunk), PAGE_SIZE);
> > +	if (err)
> > +		goto err_free;
> 
> kzalloc() cannot be preserved, the only thing we support today is
> alloc_page(), so this code pattern shouldn't exist.
 
kzalloc(PAGE_SIZE) can be preserved, it's page aligned and we don't have to
restore it into a slab cache. But this maybe indeed confusing for those who
copy paste the code, so I'll change it.

> Call alloc_page() and use a kho_preserve_page/folio() like the luo
> patches were doing. The pattern seems common it probably needs a small
> alloc/free helper.
> 
> > +	for (int i = 0; i < vm->nr_pages; i += (1 << order)) {
> > +		phys_addr_t phys = page_to_phys(vm->pages[i]);
> > +
> > +		err = __kho_preserve_order(track, PHYS_PFN(phys), order);
> > +		if (err)
> > +			goto err_free;
> 
> I think you should make a helper inline to document what is happening here:
> 
> /*
>  * Preserve a contiguous aligned list of order 0 pages that aggregate
>  * to a higher order allocation. Must be restored using
>  * kho_restore_page() on each order 0 page.
>  */
> kho_preserve_pages(page, order);

Maybe.
 
> Jason

-- 
Sincerely yours,
Mike.

