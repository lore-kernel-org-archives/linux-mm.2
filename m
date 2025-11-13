Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C42DACD6E6C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC308E0010; Thu, 13 Nov 2025 09:31:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3E38E000A; Thu, 13 Nov 2025 09:31:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0B18E0010; Thu, 13 Nov 2025 09:31:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE22C8E000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:31:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71167140A4E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:31:02 +0000 (UTC)
X-FDA: 84105820764.05.E36DDBC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 83E6440020
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:31:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=meE89h6v;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763044260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6SZM/+NILO+WtSbRxdj+sPq8hhgspwdcHgRadLz3I4=;
	b=7ySSikJpbX7+sS1Qye3e1bVN5YPKSETEKq2KXOrg446CiHnOlAOjOKOGDmUjLNvDd2x7cN
	Qtay263MvFXyrwkD02Zh4P0qYJa4Ec/tRAd+IjY8qrr6whSVX9DnUmTrTav56b4F61uUsV
	EOKGEffee+IY3Xj08u9LWtlhXjrrPMc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=meE89h6v;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763044260; a=rsa-sha256;
	cv=none;
	b=mvv1jGK7D/GAO1bcs0AYJxsxMZ+2R0yeXHVmtkUZchePJcqfs/CFe8n5/yXnxB4AjLgk0i
	7GDQtAJqQ8DPThNw3MH2q33sQiKg8F7tAPcsbZ/Xiv2pWMTEi6++SlB8cCmRcf4Z3/BOoY
	10agoMshVdukhKMv6TyFvXI6wyFbkjE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A6SZM/+NILO+WtSbRxdj+sPq8hhgspwdcHgRadLz3I4=; b=meE89h6v25nMdBQ65XLNnlslAL
	uJAffzArE0MF9tbZjOLx2ZczUzMQM651RmHNgmdPScenFQJ1mKYxNEb/8jYEA1j5NsqVLYeV2eNM1
	kfkxe3tDFH8wSaLkrQjEvsV9dkTlWTmpwquaBQcHl5w1vzVfkIcFUn3ln49/APfsNuO8rslb4V6bA
	TiLO78UViUlJlBWUOVvFPt1FkAqQPZuwtsUl3N6dXAT6/aaClfnMi7NL5XZhaafkCHFAk8gqZyrBx
	+f8hjxFvOSbM3LwpsX3ValzWKSXlsQ3M0EuXZ6FiZP3wzh8iIurepDzLdYlDIJkLHCZCGjyYx/gaV
	5eObxt2g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJYLh-00000007eCk-3QNY;
	Thu, 13 Nov 2025 14:30:57 +0000
Date: Thu, 13 Nov 2025 14:30:57 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Chris Li <chriscli@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2 2/2] mm: Use vma_start_write_killable() in dup_mmap()
Message-ID: <aRXroZ7MhcZRLY-X@casper.infradead.org>
References: <20251110203204.1454057-1-willy@infradead.org>
 <20251110203204.1454057-3-willy@infradead.org>
 <01ab3958-8a3d-457f-86de-2c7959b01d10@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01ab3958-8a3d-457f-86de-2c7959b01d10@lucifer.local>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83E6440020
X-Stat-Signature: smx8ztke81agokfptm3gnq4wxaxb1kkd
X-Rspam-User: 
X-HE-Tag: 1763044260-132022
X-HE-Meta: U2FsdGVkX1+i+CoI5DD9QneLQMeOvPe+VSzW2xaMkgDrOtf3m/OEmTvoWVgQuH6kXZZh8yAoh/J8dn8hwtZeEAku2vPqbuARzCnKQlW8j4stUaUyYTYH7k8dc1OZxqof5JgoFOrvHnExKadZz31GK4IEwl6BdnL6/FEHxl4xhBPewKpaAMRYHMp2wz3V9UZQrIEHFgNDM/5VwmmMLnmoRpG6HodB+crtFSDtpVeWAy37+Lu/3CRPvhuBWcQnbzQviXtBR3b32UdoTAj5WQBuLvjqtLjq93i/cdE6Dq3KUu4vZooUSR0kyyd37c+tUn4kRe717qROLtQK7Q59DDFGCacLvedvSmiGvBjXJwKUPyE0QFuBjcIfx4n9cCUKTtFkqhaWzIxNLlr+MA0aSLqEyLrmyHkjvPh9OrFB40GTtDERQQmQkB9B7P7Wm3upwwNF19kAJgtDNgJoByPoCHoRUV7tp4mj4YoDenP1eXXpxub1SFCo08wWyDnCcxnDJQi2oSSD96KagdHcLRAVo6sWXYhLYbYOT2BcwGklL2IJzN0NzKDMdVXwA3zp7pBelYXc5s5a0SUu7gccEYlOv0ziuDyGgxg0pKeBBvYL7EjjDX89yKkNffRSY6tJD6PFtQA8uWHYYwx+WwspbNoogtSh/waKf6FRzxuf3uCtt7t0vllFtDIdvpiGz2Kam+mbIW4DT6+JwvrOE6NfUuA7czUmINeuC8afU2QCuAcmXJ2NSDhfICcRTmopJSufYCfqpmmaKt8GvGbWX2Rk2qSXIKorSaj0ufvumYdC3bguC1hhrv/Efb/pSELPJlfAmE0KEjw6XqAwiVxJjcnpgtaC4Ox3iI1SbLF3u4zgaihuSDvHE7unMo8RE9HgqTARDpeN5IShAz89Zx0EDmYsKlet7PvZ03/eFzTShqIOptIY0MF9g8LyPFDraHzWhYLiQhFELyY2vpXjbbmGfPN+EwnDWMi
 n9hWlnuD
 K2AhqPGQUxtVabHdKwARv4V9kpUhBVyri4OFN712WwjwdOU11OrSsd7VlRLE8ZqFZ08Fzd2rd/h7X5M+ENsCLS1QI+wpIazKkwAVRXK+p2m2qtBdgkg2QpfqJvk1l3qZKMB2Kjsz/YAQwLrLjWYhFJBYYtJ/2EDZYHqlgRXeYX704jugvsJoAZr9dBVDcoMbZpfaZKkt9VQ/N7BE55nT8vziXZFqYSNBWFUzAgp3w2VGGX2Wiq6GcNTG+0x4aFWSpEr9egdNRiPK8/wIfxEPMWg3f0MsjlfdV2Is4Xd6Pp/GG+Gxw01QfErDvBH9vkslOjohn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 01:25:40PM +0000, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 08:32:02PM +0000, Matthew Wilcox (Oracle) wrote:
> > Allow waiting for the VMA write lock to be interrupted by fatal signals.
> > The explicit check for fatal_signal_pending() can be removed as it
> > is checked during vma_start_write_killable().  Improves the latency
> > of killing the task as we do not wait for the reader to finish before
> > checking for signals.
> 
> Does this fix Chris's issues or is a forthcoming series required for that?
> I'm guessing not, as his issue was w.r.t. reclaim right rather than at the
> point of forking?
> 
> If it does we should say so I think. If not then obviously not!

No, it won't fix Chris's issue.  I just wanted to have one user in tree
(which was a good idea because syzbot promptly caught the lockdep bug).
This one is an obvious one which already has a good fallback path.
Most of the other places need a fallback path written, which requires
more time and attention than I can devote to the task right now.

> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!

> > -		vma_start_write(mpnt);
> > +		retval = vma_start_write_killable(mpnt);
> 
> Maybe worth explicitly adding a comment to say we handle fatal signals
> here? I guess it is implied but still maybe useful?

I think that would be over-commenting, tbh.


