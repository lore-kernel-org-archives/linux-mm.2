Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DDDCCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A55F6B0414; Mon,  1 Jun 2026 11:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6566E6B0416; Mon,  1 Jun 2026 11:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BF46B0417; Mon,  1 Jun 2026 11:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 413126B0414
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:14:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8FB5120728
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:14:05 +0000 (UTC)
X-FDA: 84831689250.24.6A45654
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD3AD20007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:14:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gt9J7KBN;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PFuOZ0nHYsOGtAGAucIBVF6IBxl0A7E4f4zZcHnKtM=;
	b=kmXOT4c4Foz/rXxRAu4cQy/PAVUmyYfFZMt3U/inHBDUZMTmH/U2z0DHI6itRCR9dgNwvB
	4a4eb3095Wkx5Y3f6AExHvveBSyPGsa7fbSWLLYot4ff1Oj4+GJ9Ul5VF/SSkuecy/lhs1
	OckneJAIepiNDzVLJmXk6EKjQGsAGUM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gt9J7KBN;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326844;
	b=mJtegLwHoJ5lLiSzvWxINGqpyqN+1AP8E/GB44hxGa+Ej3LYBmYXfJqwIu5jsNJKb+Kxti
	IW9TurwbOfqVO0ohvktnkPBgrXyuuU7elNmbZqQ0sMhohWSDgyB5btDFy2761KYvtc6MO7
	IIBiV4Nm2kLwMefrlAe9Bnw2eWNiVpM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5PFuOZ0nHYsOGtAGAucIBVF6IBxl0A7E4f4zZcHnKtM=; b=gt9J7KBN8uCLra7cPlyaaNn7dO
	5KjLBx6RNNUabFS4dvt0VbO3rRq8EtoV6V46oEZMC+JnhGjPs/nwl4nRDAEwQN1y0ky9gsl5B6zWv
	WShYUMekK8/Wdh1KhR1P+Chgg5xe62c/u+Ic1Mz/mPk9IoZ7aYJzHfGKWDEiffgG+cKs8H7eC6P6P
	p0NE2DzNRHPkWwguwF3EHM4ov3lSUGqtty3e84zyqagyxgP1AiL+dJCUx9MydcCMFdZERVFKRFL+R
	Ow4dFouqOUPiv7WqdGIuoNrWIVsdUelwUGR5tAVY82QRHVZupxRmbbQnzeWFyKQ3Bg4bESuLi48ri
	6s8Ejb3w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU4Ky-00000000IdF-0Q3h;
	Mon, 01 Jun 2026 15:13:56 +0000
Date: Mon, 1 Jun 2026 16:13:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2 3/5] mm/shmem: introduce copy_zero_to_iter() for large
 zeroing
Message-ID: <ah2hszECv05z_Dt7@casper.infradead.org>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-4-chizhiling@163.com>
 <ah2HfH3jJZDiNAQc@casper.infradead.org>
 <rvvwfa4dp2wovn4vlglajxwpumiudvcgbnrj6fwh4dxtxemawh@rbav4cliyraj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rvvwfa4dp2wovn4vlglajxwpumiudvcgbnrj6fwh4dxtxemawh@rbav4cliyraj>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD3AD20007
X-Stat-Signature: 9q7qt8hd3ktj1r6qyk7wjqxys1ujmpku
X-Rspam-User: 
X-HE-Tag: 1780326843-741087
X-HE-Meta: U2FsdGVkX19S2bWmRvs2GkJoOgBV/zcT729uppZ4h+SCH2DsKcHTW3MAvhiJTCyDK4j9yq4hTrCAFvnxOctzKBWHYi3BioWvMI+0i67BzgpSNg6jTSp4CHX32fda+9qp7hH7HDcK4uN4rAVtqUYnFYWvc9GssdXiRlYsrmJMFLVJ3QuId8esKGok4pyajf2LshOhk6tg1sdTKbxnXfHau/gV09u13Z2lXx2izQDPeW2gBdgRqav5P1MeCQWrORSqWNojvoazvxiIb81iduKqpaTIn1LoyPEmVPbfk5D0kCwboeXAtn64wA586E9ZCdA9n5hLhlEUka/vpYQb9bgSpGLqi6jbxaQta6WAJkuZHx9bVT8tT8y2fyv/D6WIPGqs4UjPSYPmG27ePNMgU4jOahYbtdG8OazmvEuFiSiOPEEO7HEJ7ejn1IawtuZ2D/zwhfYqQ/N6vmCOu52lBYeN08E52rwEppug6uJmdiSsXC7u+OD03X6oMPwVtIFRMhNaeoKsHPHfl86tUS/7zuQm1dTFPemNHwZGU6eBCWJ13uCGOHDdUlBJAiMaWwMfFU1r+3lB/SnM2ACJ4Ln61TekDWed9mNd8SbBYbldsJOinWiiuXrL/GKy+AI3N/FT/JAirnrtCuCChG5Y/KVBvSj1VAC50JHStLXYjKaPH7rHmUNTxSFhEesXOKLJVa9j8MXmQ0hONE7AhJKtG8V4YPq3iGNEVieTX+eTrsCj4JPrFJGnXkOclkYIYozSdnRdUWzn3LNSxL+aOEBOI2ZV+7FI8iM9s562cPhVR8IH77yeAD55UpSWFMoDNNj/TiIZYpVs73aPA4PTAF6/ejDpXCiBoT45OkNQ+q/O0J6X3Prv/tLsneCMLiKJbdNhIlGL7/5BEmZRfFE2QIsR9WJg56S3izQVkUUaa0eMcdFGiPnlps9WTSzXTpLPMPF/lPAfB+HX8AbXuJ8t6EsF+1sFZt0
 mj3LhgO6
 xjv1sdgQs1lWM0C5DV0C003KxoVx6q4Cdz/2ZJnkxSO/RRFTW2Xyp0xicrbYteE7F7PTi7CGx+mv6pcCPxHUpCBRiTK70NHoKOlt2z7QuKTu74vVbXx2aeYoI8MxguxPB0YFPVM19X6E0nqAXD3vU0aO4NBPW7HWjt7WEMvofuydT9q8eQYZM6xE7tJRTJeYIxoDxOSNr4W+DfAk5CIdVLXXm3RIcVe8f5gfxlu6KJqeKCmQtggS1/ZMfse5moJbpFRfygYnjnEp4BEr6VA+YxE3DylAEte9pn4Mg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:02:01PM +0200, Mateusz Guzik wrote:
> On Mon, Jun 01, 2026 at 02:22:04PM +0100, Matthew Wilcox wrote:
> > On Mon, Jun 01, 2026 at 01:57:02PM +0800, Chi Zhiling wrote:
> > > Currently, holes larger than PAGE_SIZE cannot be handled because
> > > ZERO_PAGE is limited to a single page. Add copy_zero_to_iter() as a
> > > wrapper to support copying larger zero ranges to the iterator.
> > 
> > I think Hugh put this optimisation in the wrong place, and you're
> > perpetuating that ;-)
> > 
> > So perhaps we can start by moving this optimisation to lib/iov_iter.c?
> > And then you can redo your optimisation on top of that.
> 
> This is a rather suspicious claim. If clear_user is indeed so terrible
> that it is faster to copy, the routine needs to get unfucked instead of
> the problem being worked around.

Oh, I agree.  Putting it in lib/iov_iter.c means more people will see it
than if it's hidden in shmem.c.

> I can't speak for arm64 or other non-amd64 archs, maybe these are
> horrendeously broken.
> 
> On amd64 some archeology shows the following:
> 1. 0db7058e8e23e6bb ("x86/clear_user: Make it faster")
> 
> 2022 vintage, replaces thoroughly terrible 8-byte per-iteration write
> with rep stos usage

That's a good candidate for fixing this problem.  56a8c8eb1eaf is from
March 2022 and mentions the slowness of clear_user() on x86.  So a
commit from May 2022 might have fixed the problem without anyone going
back to measure and remove the workaround.

> 2. 8c9b6a88b7e2f33c ("x86: improve on the non-rep 'clear_user' function")
> 
> inlines rep stosb at the callsite if the CPU has FSRS, otherwise
> fallsback to a new routine which does 64-byte writes per loop iteration.
> 
> FSRS is reasonably popular by now and chances are decent the test jig
> used by Chi has it.
> 
> For a size like 4096 bytes, the 64-byte loop will be slower than rep
> movsb and even rep stosq. This needs to be patched and maybe I'll get
> around to doing the needful(tm) in few days (it's not hard to write, but
> some care with testing is needed).
> 
> I could not be bothered to check how the workaround showed up, but it
> definitely needs to be removed as opposed to being perpetuated.

I'd be delighted if somebody tested just this patch.  I'm not really set
up for performance testing here.

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..112cae9f9e4f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3427,19 +3427,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			else
 				ret = copy_page_to_iter(page, offset, nr, to);
 			folio_put(folio);
-		} else if (user_backed_iter(to)) {
-			/*
-			 * Copy to user tends to be so well optimized, but
-			 * clear_user() not so much, that it is noticeably
-			 * faster to copy the zero page instead of clearing.
-			 */
-			ret = copy_page_to_iter(ZERO_PAGE(0), offset, nr, to);
 		} else {
-			/*
-			 * But submitting the same page twice in a row to
-			 * splice() - or others? - can result in confusion:
-			 * so don't attempt that optimization on pipes etc.
-			 */
 			ret = iov_iter_zero(nr, to);
 		}
 

