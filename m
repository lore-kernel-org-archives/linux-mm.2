Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C0BFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DDC6B00AB; Mon, 27 Apr 2026 14:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075AC6B00AD; Mon, 27 Apr 2026 14:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF51D6B00AE; Mon, 27 Apr 2026 14:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCD9D6B00AB
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:40:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72A82120256
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:40:29 +0000 (UTC)
X-FDA: 84705201378.05.324920A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6E84680008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:40:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NvSnnN9M;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777315227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbhMhi8ifkGp8/FOlSoCcOAfIyRaJ/euhlZ0Qm1rNXE=;
	b=H1I6XUsKx34rCWfyXfhEKjTh3CpHcCmSTDhhoiT5IApDCAYZJKScW8D9imtrkNpLCIc3Uy
	90+egk6R76Zr/kyRuKoRDUNHBtIq/Z2i/tJfxXunc9RtW8sO0cInCqV4tdRaPjRR5cv7bL
	ykO1dcZ0smZ57ylaDHDgcJCH94HINNU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777315227; a=rsa-sha256;
	cv=none;
	b=WsTdFggKvlNInkNOO9LxauozTGtitCNWreV5W8vKdwz0luzxBiFT3d7UW0LCpDLrTOjuCQ
	vOxxtcVjXBTC9DgzHWgZf5xED5oJoidP30IK56iHWay8Q14QI0I0n4Nu4gY2ECFamkqC/0
	FdXi9lBj9DQojDd3eZX1qSwkN9KXHO8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NvSnnN9M;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NbhMhi8ifkGp8/FOlSoCcOAfIyRaJ/euhlZ0Qm1rNXE=; b=NvSnnN9M8bZk87DNUoaecIYSrE
	EYKgxS7e+S/0NCsnyMZ4lZ9lYs1QUNKyxGP5ae3g+ENk/JYMfPUk67y6zNjiaSTzT20pPFPyCB1P3
	IR779oDSxa/pCKSiXqVc8gL/M+vztZGV0n58nkBhyBPuRi2uFetJWTEZjbPR5oWS6K5nZP2oEAszx
	IuRx6agaDHLDNjCWeIGgy7C9L31h0Jzbv3mA/mwwH6NgcBscevHPM4/sHIU4Tbxa4tozBMYo1pj4j
	nX+ZLTqfqi2VMYUm6E7asgDYJuCSFQCZDa5kyyRlutePQHe0b8e8NsKAXJcOuN1ggxnuVUoQO96Km
	Gjo0EQAg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHQsV-00000002Vp4-3mzc;
	Mon, 27 Apr 2026 18:40:19 +0000
Date: Mon, 27 Apr 2026 19:40:19 +0100
From: Matthew Wilcox <willy@infradead.org>
To: fujunjie <fujunjie1@qq.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: Re: [PATCH v2 1/2] mm/filemap: count only the faulting address as a
 mmap hit
Message-ID: <ae-tkz6qe1zFmXVj@casper.infradead.org>
References: <20260427165751.746502-1-fujunjie1@qq.com>
 <tencent_949F3B157FE71D3C7247AE6FAE2C5AB82809@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_949F3B157FE71D3C7247AE6FAE2C5AB82809@qq.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E84680008
X-Stat-Signature: ec8wrytdzpi9ejstffzugikqcraje5a8
X-Rspam-User: 
X-HE-Tag: 1777315226-984622
X-HE-Meta: U2FsdGVkX1+WjajmtwiHb36yZMSlJMgkH2k43twWs4YdjR6nMdoTpm6blKJh31cFOyZ0agK+8lL6RcHNEs7GG8NSX2fGODbPoW8CrE/+08n0OB7pG5Z4U3HMmCJD4D9SAx90Y9dZT2cdFSiEwbvmskRuxZoTJ4i/+vNDQMLizsum2fanw83IeOScK9cwY25CJp4ThI6NfxUWew8Y2FCJaSxoXyzXKAhfTFcxvDfySlQO7Iy7t3jaEb7gHhnPLtLRQ5MhMX5rl+QVHWy5pomKx1PCO8iPoyXA7rC7YicvgYhx0TmAIyTT2kxgKRGrF1q2Sq7fCPO4yL0DAK2MTGI7ABAptvi2bbzED+UsAkKNZgpJbtQmHwnh7wH2zfU8TCAWIVbYplxvbCNIwqhSIGjlVDtaxGHlJm3na9c9ucBGg7AHOx6G+xJ/Ajh93d+bk+hECbLUz+srCcXGrIgw3fydHTJolSQ20nnvHBXy0mHyWgNWWHHV15Kzrkn69tG5EaumrqBH2hjhya5HE1DoDmczX0dZMVGoJJe59UpVrJZDQFgDJ3o/PAqT+XM9MYoTRXbRkjLABGVXkzWtCYNcWZKkwrbObYAQmF+n6576iBpcFuFJU00vEazWY5U/MTcvHFJTdUia+wOK2i+gB0hsCxxUthrK8/TFS6rSvnCnwLiCvph5wNWRypbFOpZ2jEgnOG0GrcOV129nDn/4HVouUxi1qpcmze9scABgtsRZCXeq75YXFDJQnV6ZaUGvCDxmnn6pmaTdj+92CRG20QYNPqIOCTbeqEyK7Vb6aDxKu5+RctZOwvlEZ9nufnDOINxLiLOXOHFVsmK4XVHD24U2+ldd4nXJsRFF7QNEvQn0TOBphNIV8is9iXIQQCZWmo4W++VLrOnMyo/OOazXuZvVxbesAqROKOZTZdtjfKB9mNVE4cKsC7GSrXLDxY3TxFpghEvOY+4k0kRcMk5nU+pngy8
 znvIrpii
 RG7/6sKBu4+PLAVb3ySry1aoWd5ETUIa5VSnnJNi2/Itf/gnA7MamGSAAeT8AJq04vQLn+qyzGf4A9N3aA3AGWvYxEEGZfUBP0KYMZa6V/ikuyVIus27JIHrS2ZDFsv646cQC8+2WFp/gAs00BO1iaRyvHSfIbM6yhlYiFo7QotYawL/F2PvK2nLsGGSor0IDFpix3RM1sisEpL8DD70oEwVqPGW+cdIvrqI/OUGh9eBZi6W1jruwRuWa0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 04:57:50PM +0000, fujunjie wrote:
> -		/*
> -		 * If there are too many folios that are recently evicted
> -		 * in a file, they will probably continue to be evicted.
> -		 * In such situation, read-ahead is only a waste of IO.
> -		 * Don't decrease mmap_miss in this scenario to make sure
> -		 * we can stop read-ahead.
> -		 */

I'm sad to lose this comment.  Why not move it to ...

> +		ret |= map_ret;

here?

> +		if ((map_ret & VM_FAULT_NOPAGE) &&
> +		    !folio_test_workingset(folio)) {
> +			unsigned short mmap_miss;
> +
> +			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
> +			if (mmap_miss)
> +				WRITE_ONCE(file->f_ra.mmap_miss,
> +					   mmap_miss - 1);
> +		}

