Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A847CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 05:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1BE8E0008; Sun, 21 Sep 2025 01:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971538E0001; Sun, 21 Sep 2025 01:50:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8866C8E0008; Sun, 21 Sep 2025 01:50:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77E4D8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:50:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 279C61DD892
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:50:31 +0000 (UTC)
X-FDA: 83912182662.22.257DE0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6CF44C0002
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:50:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QhwVuUvB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758433829; a=rsa-sha256;
	cv=none;
	b=sCtMVX5H4xv271hxRCVErhVTP6pM54Xc0s6dGpTcRonXFDC6xqd30cZSHt6PjGfD5EgTi3
	fq4Zd/c0QAC2R6J2Zkw4mvzl7ES+TKWMb6PH42hZevnQpF/TrKtGwp0nvR8C5RwQW6aeHZ
	KdLMN3k19nWOIqS2gSyAYFVHHtvmNiA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QhwVuUvB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758433829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUMjK3HVGR4GsSpNfMsB9xV66bqvN4nMDDvBEBOlv2E=;
	b=KBCouehx6+vUbujnYmCJl98tJGraGQhwtBJs8wsc/AjAyC7hJyRrabrvz6OSeJ+9HgrFS0
	ZE2gsmiNzeTwomUKCqAx8F3oVkSTK/Y3BAHiGeq33FVQqF2Yvtor56dmOZmDrKoODDeI4g
	pE36j1nuzFo8+lbhVfq976Ot0A9D0mk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C1D94050A;
	Sun, 21 Sep 2025 05:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5598C4CEE7;
	Sun, 21 Sep 2025 05:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758433828;
	bh=TSVC8N2GodlaKAQaAY5OOOC/Kc/9NpEegQNC+DqLKYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QhwVuUvBiheXc/46XR2qLZt3+NU4gqqsYQzJ0kPwoNmLt2MUhemSYYpJi5H7W5jhI
	 T1Y1QFv7sinCoGcvt4N85QZJ/hCJDJ4Yg+MkBXCsmXmlNk3LucB6ToAWwhD/UoGfOJ
	 F+EjsZLdEC39g5u+oQnl4DjexZmKCIMu0CPKGgMv1ysKh7bBZyXLxE0xxsQSLabkjT
	 NPJ8DcbKFskOLinPCkUYRbJRWnUVkiRBvgtLduEgKzham5yyeXvORONG5g2WgPqPYn
	 /u5znp1HQR2saKtV/UCAuOznvTOYXHxG4913A/OySHOKWGdCeL7EXXpPhWbKW55Jet
	 kX925caNnEtjQ==
Date: Sun, 21 Sep 2025 08:50:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: Re: [akpm-mm:mm-everything 254/254] kernel/kexec_handover.c:970:50:
 error: passing argument 1 of 'kho_restore_page' makes integer from pointer
 without a cast
Message-ID: <aM-SHRBIwCI5LnXJ@kernel.org>
References: <202509191034.SM82Oaij-lkp@intel.com>
 <20250919140419.211ec45cae8a479d1e347453@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919140419.211ec45cae8a479d1e347453@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6CF44C0002
X-Stat-Signature: 5mkob13istyd1as1hcobcgo6sihjmwp3
X-Rspam-User: 
X-HE-Tag: 1758433829-144495
X-HE-Meta: U2FsdGVkX1813yOLWSyaVHPQdyZelYKqYzUbTlI/uPoUTAqV92K03CjU3m81Oqw1eSMVxb/w/aQ7i+3so6WxAhz6AAqIVl80AXxgYPf80pYo+n/upccWUDL6NE1U3hSLQlD3OoLpvvDkBW9deLGjn9I/6LVLNz2FrbXhFoL8YzBGYG2bgNmMzu9ZGazxk9jhKk2VZZYCY3qES3cEa6Viu5e+ccB6f+VbUuiu1SIFA8rfQ5sRk8wbTNYiOMzr++xn+6r5VKUR3KxYDe49WLPOqKNczK5/esmpzr4OVPsCVZJba8IPoS8jMZws6sWhMPvj9FL0mz/qTYz7rT0NGp1Yb97b69ZYnUgjV++83qmuwDagooppCmgwd+bujhQ3QXkvkerPcxU0itgJg3I0T/mxo8tkWZMhwJU/iTaSN6NHy9Bt3ozviDjJi5slGuLaX4fuXlEQLKdNXNETC000iB87j2iVniHylhs9IGD4pEns/RYtSgGs7+jXdz4DLF54ad0knKdzNP1WhRm7xDAa6yA4yIllJCVWGSDWJRkFBsOAg4Fpl6hBazZ94w+HdrjegwbU8TwYAiRKtrvP9pPqfVhLwNhv9kgndqIEOT1hhLHQwarENkjzbPE0uP9ul+qHCaWJYooD2OQ0ixHqk3AcC1phNiDQQ6BfIgtBB1gh8cnfzlh0Nl2ZbZcZQ11+Te8g4zKeFNLBEBmrsi1H6abohEvfG6oR9XiRtff4GiRHh5rp+z5wx4vGxZrBW1AVqkBJtvdksU7Wp84QPzaGVgv+aEuDphfEc0pzGWNcH1IFUEFhDT+jBq+HtXgLtLLFMPbg4OJoTdKtK6QVPt9/c05Tz0Xn8lIMqhZALmivZnno1Uyxn5Bq+FmG3wqxRbJPSVG6mORvI/jTU1vdE8DN+H9eOwN6usvVsEGKlSFaaB+mRvivCpdbFhwfcWkbvtoYJRKmrJpz5iJuTKCC4TTyfT65BT1
 NymkcfOB
 OPfQqjr8gErzjxsxCWYADYiHzot1oI7g9uaZbNlp601aX03+w49N40YdcF59JHktZyZCEgDsoyAxq9BgNoUfK18G/iESE0arfUfLDPHsP8dqMjEYkUaGG8xC4mWVVJPmEdF6Ygs2ZIBoLNN4EvvKhjOo8In5OTtsBm+pLxf21iiIx2FLA8R8sYWlnNZL4QmHYfD7791MdNALjUGM2/KSjWxtSvyQPOfQy++yH5t/B6WqvRMW9UknV+ObFy8b7cXJc+qjDe45Ll9qbgzi2JFYHPZi2+1N4GY9vg0TZ7MheFSRLbac6q6Qv8/l34AyzePQcBAzk4FtZVNzPLOOw2T86f4k29u5ziQZLY5yJ99YQtDq7Q4WwimA5/GT71UHvB1frcBfprg7rJyrbaVp62Z5BBsINew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 02:04:19PM -0700, Andrew Morton wrote:
> On Fri, 19 Sep 2025 10:37:27 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > head:   46735c0743fed990d0ed8722a131ef54006c45a3
> > commit: 5369505b204b3fc65f839f7558640b6ecd675461 [254/254] foo
> > config: x86_64-randconfig-071-20250919 (https://download.01.org/0day-ci/archive/20250919/202509191034.SM82Oaij-lkp@intel.com/config)
> > compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250919/202509191034.SM82Oaij-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202509191034.SM82Oaij-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    kernel/kexec_handover.c: In function 'kho_restore_vmalloc':
> > >> kernel/kexec_handover.c:970:50: error: passing argument 1 of 'kho_restore_page' makes integer from pointer without a cast [-Wint-conversion]
> >      970 |                                 kho_restore_page(page, 0);
> >          |                                                  ^~~~
> >          |                                                  |
> >          |                                                  struct page *
> >    kernel/kexec_handover.c:229:50: note: expected 'phys_addr_t' {aka 'long long unsigned int'} but argument is of type 'struct page *'
> 
> Added by "kho: add support for preserving vmalloc allocations".
> 
> I wonder how this happened - was the correct version sent out?

There is a conflict between "kho: make sure page being restored is actually
from KHO" and KHO vmalloc series. 

I've sent v5 of KHO vmalloc on top of last week's mm-new, it takes care of
the conflict:

https://lore.kernel.org/linux-mm/20250921054458.4043761-1-rppt@kernel.org
 
> How about this?

This fixes the build but won't work :)
 
> --- a/kernel/kexec_handover.c~kho-add-support-for-preserving-vmalloc-allocations-fix
> +++ a/kernel/kexec_handover.c
> @@ -967,7 +967,7 @@ void *kho_restore_vmalloc(const struct k
>  
>  			for (int j = 0; j < (1 << order); j++) {
>  				page = phys_to_page(phys);
> -				kho_restore_page(page, 0);
> +				kho_restore_page(phys);
>  				pages[idx++] = page;
>  				phys += PAGE_SIZE;
>  			}
> @@ -975,7 +975,7 @@ void *kho_restore_vmalloc(const struct k
>  
>  		page = virt_to_page(chunk);
>  		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
> -		kho_restore_page(page, 0);
> +		kho_restore_page(page_to_phys(page));
>  		__free_page(page);
>  	}
>  
> _
> 

-- 
Sincerely yours,
Mike.

