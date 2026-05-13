Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE851CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1273D6B0005; Wed, 13 May 2026 01:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7C56B008A; Wed, 13 May 2026 01:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FBC6B008C; Wed, 13 May 2026 01:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0EE26B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:32:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 592318E04E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:32:41 +0000 (UTC)
X-FDA: 84761276922.05.F3373AC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id A9D5C180007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:32:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=sWeMuAWg;
	spf=none (imf06.hostedemail.com: domain of BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778650359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjTCGdXoMQwGvFmF6y1p0Vhm/EMhbe8GlJkwhKpocYE=;
	b=MdqeYEQXIJ0xDK2KMN325MbSEgJxrrAEIwb4I3EAweHOfbMIwVhWpnFVZgn01zdLuz6OsF
	ws+1PpjOwSRz2Pf8j+e5PFf0YpQfXLpynw3PFALztNjWVwTHtDZS/HW+NbXhfRBoQVMxc+
	0c5RC+M+4pV3PiZmOkcVtfxEyiYNNVI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=sWeMuAWg;
	spf=none (imf06.hostedemail.com: domain of BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778650359; a=rsa-sha256;
	cv=none;
	b=ZwnbpIUhLqsBvgC9fz6eWXJthQ8TFR8rgrEZujiniySVscG2mlhiwyYSiWUPwuQrZohUzm
	9r1UMnXJ+acxMLzBrjIFQPDB+6Dn1TOCIlN2hgJbq8hTQt08rJiSo1vuZ3/ACmoYcvnjyy
	Zleumzo5xGjR1BSAh57E7kyd3/OAVhQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RjTCGdXoMQwGvFmF6y1p0Vhm/EMhbe8GlJkwhKpocYE=; b=sWeMuAWgwij/oy3B9/HVTuarTW
	cmVgvWTO0xcRdZr7szwnJGRpci/T7coAr6hDu9BnOojG4eBvQtwekjsJQpQE5nMlPaHU52xHBrfiI
	rRpyzTHxEHOw1IrAhdUCQQ8xjPPMWN71e8ir2HKx8SQ4bIdxEiG43dhaxFJ6n7hNM8lzbW0cpUebi
	fAnJKhBeqdZZTxLYVNIUrte00HZ3ks5Hdzq02nuSxMJaPPHPkvWUmIqJISIWOlYdx+Uy1e4nGeeTx
	TwdZgkZzHrpLODYCXSTSaCqOua9CHFU6jYfC+RH5NSbMJw+gbziQZz+DJ4B4q7XoQ2xeUqIHxTdHt
	QMZ2yNkQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN2Cv-00000001KKS-0dsU;
	Wed, 13 May 2026 05:32:33 +0000
Date: Tue, 12 May 2026 22:32:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <agQM8YJgiMxGlI34@infradead.org>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-3-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512104201.716213-3-baoquan.he@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: p7d1bm567taoxoj918eqrkpaxpqhp1xs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9D5C180007
X-Rspam-User: 
X-HE-Tag: 1778650359-876969
X-HE-Meta: U2FsdGVkX1/mWeSLwiQBl7VjEautCvCUhrWJjxEcoaXMzAni9nMJ+Ecniq5q5xu+4mpnmZDt62Zf3h31HXnAWQkMGXSSzR22yLnMSI+SBhPKBcuuJ4K0+PLWPlsp6ymVm7QpS6eFuxgH1sWnhvWhCRv8tEv46JapRI3j1X2BEt3BC8ZaS0KQEfv2WH2P3kmkSx4ny+r24dOtFqSdnQ1tveNRu6UmvbXRiiF87+1l97aFAy3EpJh+afbHxdr2WQ3GXwSLg4yFlbFTHZl6qEloXGMHJl+gpFxCk26noUhXK3AN33wnuQDF3AkxSUjIhS7fioZkDMenDDj0Sa0EU8EONqJpx1E2CrvKwwAmb+vyOLakrOXc1RPw6ds0Cx+vHP0kXZeBZdUU/TyOMi7h6p+FOsgUmY1XYjCsjAuS89+gBff5FheSOSQhOiqQJZs83RuqJ+Nu7d8z2B4HZgCFdf6IaWpQVSQaHKtaJBb0OoIhsB6rhYlt6okewfxxNOz2i5HAMuQVHcTM1rOAR64gt7yPwZCR0Z/W1rdPfsGzklckwAZWe1rr3BsEvwh7jbTEb8CWxXyHyNsye6gs/B3o+UInvCWwT4PAkG9M0AXQSGt+uSNr8p8FD6GjriZfp4VwnvVOs6MalI/2+iBhwqrlKihva2QU0qCqXkB3NC12Ab9dB5B7NJnm8grxUh+jUXVqWN8Z7kV2v276PSBlDUEFdQdtlks8FUZOFstGcjZHZcNXtlYGStmXoUBU6HFMCyaRMTALqXDvI1eHpGIVaa2crre6zuOXVtefOW/mpg23QvnKwf3L1X0x7g+0RC4tWdvIsDLjNhDE8iNo6mn69NzQmQv63jjjp7M6+glMViO0QKDiIWyM02ENxCyotbsLBSBFrGEU/Hj5sovJoix7clz052gSkbGrmw/sa5c9/u8amGUlq9tqqfNiEMRGVCQ6UpMHfHCtU+ULXviei0dhytMI+qO
 AllAKPwW
 WchJ6eAxGZ164vwJvSBhc0QJp979g/0FfoFaGr1gy7DYW6Z8xMl6BkvJ3uoNrNhXqqIRom9oBVWdkPpPsQ3jnqk3tJXNnm/2ksw18uGM8wLNSHC8BmLss4/aJM+dDm/lGGIIaQlsH46LaZi43wXc4CO0Vh/NA3OrY/JF2hDozWsVv+rsmmg6HzMF+rMMgIrRreNBamcOBXxC0vPTd0EQVWT7rWor9l/5kWtGxxxijDxN38yKzdxc+Syb40C1TrXGxUwqVnWrBsvj6FBkBUxWA13gZVRANHQhwICThHfNl/4THgXpW7iek88xoF+W2ttGvsALgE32rp7L9iirUjOL+ggnbHT0IoXdyFV4cN6bEvzYpzU1LAxi3u3qPKYjGQwwIF2I6nXxS+qI9lP4lDR4KZktyxKnyF51IaIoyBtZiNJf/gITB0mxu9/Lh9JsPFMrz826AUTov6XRxpHZJOv4yfqK2Nc5j/WqBMgYSFkWCUNoi5/Pz8CnwyTVv8jBE86YTDgUFUEwJsEidGUzfsvSA6Gh71ujTjSjguYmMomr7J8JLZo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  };
>  
> +struct swap_ops;
>  /*

Please keep empty spaces before comments.  And keeping forward
declarations at the beginning of the file makes them much easier to
organize (although the current swap.h is a complete mess not only in this
regard).

> +int init_swap_ops(struct swap_info_struct *sis)
> +{
> +	/*
> +	 * ->flags can be updated non-atomically, but that will
> +	 * never affect SWP_FS_OPS, so the data_race is safe.
> +	 */
> +	if (data_race(sis->flags & SWP_FS_OPS))
> +		sis->ops = &bdev_fs_swap_ops;
> +	/*
> +	 * ->flags can be updated non-atomically, but that will
> +	 * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
> +	 */
> +	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> +		sis->ops = &bdev_sync_swap_ops;
> +	else
> +		sis->ops = &bdev_async_swap_ops;
> +
> +	if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
> +		return -EINVAL;

In the long run setting these from the helpers for ->swap_activate would
make more sense.  Also as ls long as the ops are a small statically
defined set these checks here are a bit odd.

I guess we just need to land this ASAP, then my swap_activate series and
then do a big round of cleanups for a coherent swap interface.

> -	} else if (synchronous) {
> -		swap_read_folio_bdev_sync(folio, sis);
> -	} else {
> -		swap_read_folio_bdev_async(folio, sis);
> -	}
> +	sis->ops->read_folio(sis, folio, plug);

This is a really annoying double-indirection for the SWP_FS_OPS
case.  I think we should have one level of indirection here.  One
way to do this would be to remove the swap_rw operation and
implement the swap_ops directly in nfs and cifs.


