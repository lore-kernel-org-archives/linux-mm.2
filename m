Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35089CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 17:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C62C8E0154; Sat, 25 Oct 2025 13:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877468E0150; Sat, 25 Oct 2025 13:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C668E0154; Sat, 25 Oct 2025 13:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6317D8E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:57:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0080D1A010F
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 17:57:14 +0000 (UTC)
X-FDA: 84037393188.05.A0058B2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 577A580004
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 17:57:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ECXAMnnY;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761415033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9vGoY+nbBaOsbKg03YXEdXl7WE0FeSV0k77hTLT5bU=;
	b=M3MHxIi0IVUn1PwNIiQynfK1K6DMNteNOOHsSXUAIAGMF2FqZb2Z8ziyqqlwb1sWghiOaX
	7bm+aeHWbPYBla3W19vtlSUvyc3Xk/ugorOr+VW6kbwuwYVaisVG9bHZiRmAUE/CK2jfCS
	sNIHDKBNnuTZnqQF0tS/3clhmSzWGRw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ECXAMnnY;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761415033; a=rsa-sha256;
	cv=none;
	b=YwxgtHnr6UuLWHHDU4Bye2tbg+o8LUzyCRWcx6OyOXXERVu3cqAsR6YToNjaeeydf4o4N3
	mY04j+BDL5vWmaL/fb4YcKu8eroT5g480xz93YLuuc4qGP4QnwrNqDm5rbVfGH0NNVaEso
	I32UCvqzvhPj9mDKuH5022jYsQLTpbE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z9vGoY+nbBaOsbKg03YXEdXl7WE0FeSV0k77hTLT5bU=; b=ECXAMnnYzkobhQTzmNKTN+D2JT
	LJwyNcLznU3digEnaytP90GukMfPxEKZNmmye4UGQ19jzCPM3wd8PiPgiIC7rzd+6qJXDIQYUGAyA
	2UjXIykYnLNnFjQKG2y5vqoMwm4cV0lUhRAAqEJlVF3M3zZ38cWcedP3YCY3Zo3DJvEsndNjmucqF
	tvLgUBTnHX9radZQYvZRG6yBwaTBX/qMTHGwJRZTD6p+bs9wPQvNqZ60kUFBpHzb8kJU1LZEJSGuJ
	mUz2Mv1HnWqADDRfXGwQitYT2Rk39kHpK7WCBCsp+5eG/+hoxz7/sVJnLd6cN+Qp+3TFITzoZ/ST+
	L/vzx7tQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCiVd-00000001ILI-4AtI;
	Sat, 25 Oct 2025 17:56:58 +0000
Date: Sat, 25 Oct 2025 18:56:57 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Baokun Li <libaokun@huaweicloud.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, yi.zhang@huawei.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, libaokun1@huawei.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
Message-ID: <aP0PachXS8Qxjo9Q@casper.infradead.org>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
 <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
X-Stat-Signature: bgci98gc1is7oq9ow839a5s3n4y47ybz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 577A580004
X-HE-Tag: 1761415032-604691
X-HE-Meta: U2FsdGVkX1/llFkyad9iEWKkq2dDuELZBZVIXLpG10yEuErJGO1VG35O7H+csvnGJga8+QwtVp7+RB46O6ltB7ZNbQyIQf/9yzGm8d5KEZiFFDOGFAA+G300F8EDn9qNqq/IkjKE1+3nmSCf6TCz3034iIjdL1UVUYBP7J4eNmpshPQMyz6LcaGXRzbg5j/++du2Zl8Emgi6F+WcH6Pr4yLK0Dmct5BHnANSkDmlai7vk+GwklRjuztPMqdUF9mq7QU7A/kTDuWYgJ/02GlgD3Azee7jp3gHiELti6J7JOiteoexwqkuSJbsHMAD1Zngsaxco4GXeZUZoYiwyeYl5EIvKq1Cz8fHsMLE3/pH0eu+OYudrNUOFL/twdieRTOytwxyA246eDSFbbehHUETqoYWF3S7ijEDdE9syD9Mtt61V/PXqMMYEWpwAdMxU5tGRNwTbN4TuByaM3DAWkF0tFoZklnTmGklpHVed1baJtvenRpdxJdqOJ21s2waayqJg8+94ibhaqEP+c1HhM2sjQMLRQ8dur8lGkUXOqWarBSHSaUCX3UHZmrLgx4EbNT8V/sl95mjEe215p6UHpE7J3t2hol0hgaFZfI2xeRfdAqe6NthOabhpL/JhKZs8nPA53qlG8Mdk6ribz3lCUvgt789vuLlPG6IaEUpWtU2xjWZShdYCF8SXmrOtOXAk7yHnRnBUVkKdM64i3miLVSnX3GGLdCL167GMrcF3ks0qq6Ijyp4L1JMX2IzZ50W5jE7q7fGBNkN8h8NQ/XCa45T3muMgcnBilAKHnKl50XMRZZGDx0TRVE6LzvfqPFd2xzUfI4eVKILl/+vfGFopN8kfgfzupyI94q8dEYiHPulDlEG8SFq+lniHlrAZVvUtPcQvCBAftvFq6qca0wjoYlZhHtlofUlAhs7CNOez3qYqGQWUr5Yzvyt+HT7CDt9/JA9hXSgq6VfZU/wdlue175
 gnYnAhcG
 QzGLGwOLL4BSAhlvye0NzKOkHCMJ2yTKrlZTcNDKurvTxmv398U0fKInwwz5Q5laMPyI+4f9qDlIo94tmCTeBT//AHgBQGqGwFQ0Gp2olPS5GifaCrpyRDt2g4NmWDPWU2P2/nAPm0d1K4itfJcK6iMYtvzi7ClzVCyvV7IcDPEiatqeDbHXWv9xzpJ3O9QthuGdINvd3zIShnI8+gi62x8bKdyf2O5oTvPPYyQvGCc2GeWGv//kT/dMj/NXq1jnnrZIk6jsHevdYXs6IH0A/JjEzolsPO5M/Do4VbVs5jLb38qFWhsAviMaALkxaj23FS2ro
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 25, 2025 at 02:32:45PM +0800, Baokun Li wrote:
> On 2025-10-25 12:45, Matthew Wilcox wrote:
> > On Sat, Oct 25, 2025 at 11:22:18AM +0800, libaokun@huaweicloud.com wrote:
> >> +	while (1) {
> >> +		folio = __filemap_get_folio(mapping, index, fgp_flags,
> >> +					    gfp & ~__GFP_NOFAIL);
> >> +		if (!IS_ERR(folio) || !(gfp & __GFP_NOFAIL))
> >> +			return folio;
> >> +
> >> +		if (PTR_ERR(folio) != -ENOMEM && PTR_ERR(folio) != -EAGAIN)
> >> +			return folio;
> >> +
> >> +		memalloc_retry_wait(gfp);
> >> +	}
> > No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
> > The right way forward is for ext4 to use iomap, not for buffer heads
> > to support large block sizes.
> 
> ext4 only calls getblk_unmovable or __getblk when reading critical
> metadata. Both of these functions set __GFP_NOFAIL to ensure that
> metadata reads do not fail due to memory pressure.

If filesystems actually require __GFP_NOFAIL for high-order allocations,
then this is a new requirement that needs to be communicated to the MM
developers, not hacked around in filesystems (or the VFS).  And that
communication needs to be a separate thread with a clear subject line
to attract the right attention, not buried in patch 26/28.

For what it's worth, I think you have a good case.  This really is
a new requirement (bs>PS) and in this scenario, we should be able to
reclaim page cache memory of the appropriate order to satisfy the NOFAIL
requirement.  There will be concerns that other users will now be able to
use it without warning, but I think eventually this use case will prevail.

> Both functions eventually call grow_dev_folio(), which is why we
> handle the __GFP_NOFAIL logic there. xfs_buf_alloc_backing_mem()
> has similar logic, but XFS manages its own metadata, allowing it
> to use vmalloc for memory allocation.

The other possibility is that we switch ext4 away from the buffer cache
entirely.  This is a big job!  I know Catherine has been working on
a generic replacement for the buffer cache, but I'm not sure if it's
ready yet.

