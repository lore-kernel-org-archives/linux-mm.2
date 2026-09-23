Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A69AC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3253A6B0092; Wed, 23 Sep 2026 05:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6176B0096; Wed, 23 Sep 2026 05:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC5E6B0098; Wed, 23 Sep 2026 05:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEDAB6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:24:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63E0B14062A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:24:54 +0000 (UTC)
X-FDA: 85244492508.10.541EB23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B8E5EA000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:24:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lf/HJYmS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790155492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLKRb8Y4+nISCnQaxnX4ctxBf/lcPEd8M1PAoqnsICk=;
	b=7meJxyJaNnWgF64rLN9Ra/WX+06YX8ImkV5RftVraZrSzG0oA4vjWrgv/2G3wSnj6B4HvR
	7r9YV8Ys6rXcL6FGL7ywWouHKdfEbt398IkFL3t5fHARon4QLzuYKDzwmayHBKCUsEwKB/
	D3DcNVVFnNTm9VRDuRlQo7iKng8+drU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lf/HJYmS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790155492;
	b=7zsWIT+mOlRGk+O/juFs4MGEQ8OQDqS0rXXs63ISC9l10SJ0yQK8h9dmQCSrm3FBLqCv7m
	sHRzfk7CaVyemA4+1zuCYiDX94puqBpJYUhfZ08Th+CNbMjNNd+4g0cHdo2iheyg9aF0m4
	VO8zuKtEWJBhrJEVIi9Gq8bY6JaaGeg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D327242E13;
	Wed, 23 Sep 2026 09:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F05E1F000FF;
	Wed, 23 Sep 2026 09:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790155491;
	bh=rLKRb8Y4+nISCnQaxnX4ctxBf/lcPEd8M1PAoqnsICk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lf/HJYmS7UTiPzh9amAhYD2S1aZFVo3LNH5rJLGdyYuILAzd5aGZtD7Z+A88a9tmL
	 hHM6MECEikQkwhUsVWW9OiN+brnRisqJ9m4BU9synUw13IBOU89ZTDelvYTT+MbfCr
	 YHCOAWS4p2NquBk89ID0zbIa8fuQleDE9KqU4RAhKfHJPAKRRbVI/pQHilGVcicP07
	 EW/UgyDgmSBMmHsdSA0fJ+c0tZ/MA4+6VdDCVG/bt0KetNYvzUPxCl4XaT+mMKf/Jf
	 B1arbqfvaLL4O7tkudrCw1fmUe8fqQeMQ5Yhy/QP0Sg91jXC39kkSIBIAWf4RbKs6W
	 EnUBG7zakOYgg==
Date: Wed, 23 Sep 2026 12:24:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH] vmcore: convert mmap_vmcore_fault() to use folios
Message-ID: <arOa28u0tRZ-jGYi@kernel.org>
References: <20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu>
X-Rspamd-Queue-Id: B8E5EA000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5kiyisygx7xs8z4q79ah8h1fxj3yu8iq
X-HE-Tag: 1790155492-449475
X-HE-Meta: U2FsdGVkX1+N7IILhvis2z2zcn4ra/+KRePxrupnH/CeAVDENOxLEuA5+AGZKermKgU/ytt3Z+yMYajgESg0zz7L9o8UaY7h2FkQft8+WmblY6n7y/RQ3gFKvt8DsH9WFeoUjrgZRVpGlavzySSAry3c+MNCyp25X4YSxgTJNm5ndFUkKWz6nssaia1Rf2TDouv7VZ+kBM8uS7uU0bbKtFsC0hfrGizL+p7pZVsi+q4jCZ8ysM90JZ0ffSJAGYYOHo3eoCVzDnvlECjdtM4xNXdLYVnTUrJk/ndpZhRdpSZRr7K7n7Ebox2mH7K7AxOQMoK7iEv9sTzuZAPsa0Jp54Qaj5skzbX3js1liVpvMTPjvr/9tXNOCxboT/wBs/kCQwgISOKxcwUBDnZl4p6YWg6JzKXdvHD60ypabVH+imf9uvO4u/A0k9qmGh+9OCG9n3AV86hFwfy1E1jVm1J5wOua2YDRvTdGXni8hjUpjW/Yi3BSmGTuLyzKz20yuk1FqWCZQsz0oltJup9okI38Y2sP49US9ANqmjFdGDjAMqWCdCzUOk2Dgq6r7co7lduxCAEQ58e7E4zPXOs+T9f5I5OFuqzZoKq1IhvGsCprqnMXiqfNItFij2Aqc1jLOUujTAsigy5PsNjyWJ5NEQzjtD9jxph5Z8kuOgxKRAmLlsVygOUGwx/BVj52almaEGSi3/6EhaAEkNv0Oo9reQCzXiVzwmMHbFnq/+GZBWK4ALI9NuulDl+PVVX9Tpitlx/h+iGuBdXiMNXROYnmBwiDRhGVs1gOmcUsS1u+z6DrDQhMb0TvWH08jXjCP3Usp/nuYRhCo/29i7uoT2y76cVMCKMT0B3Ve26NgRNeRcXvErkyeWo9TZNA5nrC1oBmmqBGlJiz4KMnmQcvdkNCA7FEog4UNWzQf/w6N+B1k7ugDHnfISG7DAvlAyWg8Vp3ZNw0WYnoHKN022y3i/BhMka
 tIYZ1ovT
 +4l9C/sKyIqhbOjQDlwTdr5y36SwhLL1gzADjos3XOzbP3yWxzghknndx32MxpF6By0HVlILkqLXpybSJse6e4wBasOtYlXAjvYJQCNqVVq57xJ5BjBtcM8IWOnA4Jr9rSKynFJfAZNDgqdoEgEEO9pswcD5J4qs1oPnZBiSUZgLP6QYJmwJ+1k8DBAoQB7J3KKQtfoMCgGGAvZQD00LWFtEXzYKqrl0Ofcc4YrZINjAcFU7VbFHADss/+fDz2jwWV5ezODEpkz66UuYweODqnim3q5ovakxAA7ewJL7qaA9LsJUSqOXgBOgarw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(cc s390 folks)

On Tue, Sep 15, 2026 at 07:42:15PM -0400, Tal Zussman wrote:
> Use a folio for the page cache page the s390 fault handler reads the

I tiny bit of context why is this only relevant for s390 would have been
nice :)

> old kernel's memory into. This removes four compound_head() calls and
> one of the last callers of find_or_create_page().
> 
> The vmcore mapping only has order-0 folios, so the logic is unchanged.
> 
> Compile tested for s390.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
> This is based on the kexec-next branch of the liveupdate tree.
> ---
>  fs/proc/vmcore.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 44d15436439f..2dc3803aa11d 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -474,29 +474,30 @@ static vm_fault_t mmap_vmcore_fault(struct vm_fault *vmf)
>  	pgoff_t index = vmf->pgoff;
>  	struct iov_iter iter;
>  	struct kvec kvec;
> -	struct page *page;
> +	struct folio *folio;
>  	loff_t offset;
>  	int rc;
>  
> -	page = find_or_create_page(mapping, index, GFP_KERNEL);
> -	if (!page)
> +	folio = __filemap_get_folio(mapping, index,
> +			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
> +	if (IS_ERR(folio))
>  		return VM_FAULT_OOM;
> -	if (!PageUptodate(page)) {
> -		offset = (loff_t) index << PAGE_SHIFT;
> -		kvec.iov_base = page_address(page);
> -		kvec.iov_len = PAGE_SIZE;
> -		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, PAGE_SIZE);
> +	if (!folio_test_uptodate(folio)) {
> +		offset = folio_pos(folio);
> +		kvec.iov_base = folio_address(folio);
> +		kvec.iov_len = folio_size(folio);
> +		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, folio_size(folio));
>  
>  		rc = __read_vmcore(&iter, &offset);
>  		if (rc < 0) {
> -			unlock_page(page);
> -			put_page(page);
> +			folio_unlock(folio);
> +			folio_put(folio);
>  			return vmf_error(rc);
>  		}
> -		SetPageUptodate(page);
> +		folio_mark_uptodate(folio);
>  	}
> -	unlock_page(page);
> -	vmf->page = page;
> +	folio_unlock(folio);
> +	vmf->page = folio_file_page(folio, index);
>  	return 0;
>  #else
>  	return VM_FAULT_SIGBUS;
> 
> ---
> base-commit: 4d17a004cfd5489f88ad0a7a151dea11a533338b
> change-id: 20260907-vmcore-fault-folio-4b382eeff262
> 
> Best regards,
> --  
> Tal Zussman <tz2294@columbia.edu>
> 

-- 
Sincerely yours,
Mike.

