Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3372CECD6EE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 21:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742906B0005; Wed, 11 Feb 2026 16:59:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5A96B0089; Wed, 11 Feb 2026 16:59:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1DD6B008A; Wed, 11 Feb 2026 16:59:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EAF16B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:59:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1B87160504
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:59:23 +0000 (UTC)
X-FDA: 84433542606.28.D9AC1F3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 438FBC0004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:59:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hOneO5Cg;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770847162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AojB6NpczDdBWw2M9YMCKzlkDQzN1cz5fhoVcgmRVBw=;
	b=iJZxCBaDSnz9cDz6SwUK2uEh+91OpT/M9bzeApmHSddFBbg/2Hfm7i0X2ZAb8HljljPkzT
	CIgxgFcfwiGKHWvhZ3K2Zfp1fXUNBtk3g8ZIvBGcIwv4ZNVReJ8NHD7FKZEvGe2bKJdyKN
	s992oLG6SJvRYUySR0S6flIEy1Wjwuw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770847162; a=rsa-sha256;
	cv=none;
	b=YXT5lLlQDVyUPG58Kjgw+itJyXfI5IdCIhSgwxuRIICBZTTH6Sj85HYtVPqkRt90wS0hYK
	nSkfZbrpcfCClU+/Sn99Qe6V8mEiN3DY/4rzFcNysNahEFP0qL7EpIfULFb7PVG7D5E0H6
	X8dmWTARf3AGNbmAR/AC1uyZh7gjJC4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hOneO5Cg;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AojB6NpczDdBWw2M9YMCKzlkDQzN1cz5fhoVcgmRVBw=; b=hOneO5CgSAB+iYuHLNcUFBM+56
	0XSkW/HJXC9QQ4LHCud43RZ8Qoyfrd/pfKLBvxOa3bv8Sq+4fJwQtJfthP3pQF4WhdrXSJXhm2X6G
	RmVxlvuMggL1TW2SgchHqqh7cG/doykpZyqFEaqFwTtikdVv/ST4e4O2oRCHBkG9O8X8M6hIRETo0
	RcZP5xVmDFsaGHI22zs4juls23fntMtRXbWDR8xhlR3RzN29JL8lYjuWRwByJK+PwbDVEKpb+qPiF
	eg+hddPmGULyvWvvMgqBYoeY/4LFsjKMCz/sANGfYTzhoeXcxcCW8cLqN8x1/hRANlWjs8Gc2TR5d
	6la2ocbg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqIEx-0000000DFOW-1Wjj;
	Wed, 11 Feb 2026 21:59:19 +0000
Date: Wed, 11 Feb 2026 21:59:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 4/4] x86/mm/pat: Convert split_large_page() to use
 ptdescs
Message-ID: <aYz7t7vG2W8ieEgx@casper.infradead.org>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-5-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211195233.368497-5-vishal.moola@gmail.com>
X-Rspamd-Queue-Id: 438FBC0004
X-Stat-Signature: 5f3rwknyw9cc5t6rim1gouggjzgw8hdj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770847162-850062
X-HE-Meta: U2FsdGVkX1+7BpJq/FPp2riyxqAQpxImUi+dVu9UlrJ9ecUfB1mqDkPvtESe3mP+RHMjcBqNuLjtClU0HFqynQWt/OjOdoy2WxqIp0iTHtZ/uqbdXZSk0cDYfRz8KJM+ZvMVlR2tfVccEMguZMCva626+iVOUUMbTL/91VKcbmVJbhhyVVGGnSxxY/W3TXELM0VQTgij4q7+UJNumEWM5StFbmIvcO2i9tfoBMPoEQa66Zk7ut51q5T/SRZU09kmlOQzhpLG+XLGaQQJ95fAlzk9jpsH0lmuYRO0N25hCfCV7z1vxrNd+kVCMu7RTvsV/HsaL/yz3DwB2PofI1K4sta54bWz2Sr0O0Dnz+4JcrNTY4q/vDnFz1j9Gaemr5IAB7eSxiiP5XUY7w4Iuod5GKyppFsZhTJNFzzUoYKLgtBI4taZ/6jGVGjOBI+arSCxMbN4W7c2Kx3LdILYi7jxxaTdVYdf72R1yLNNDHT8DdvyXLq93yXBoZRj5PL5+gqpGsK4bOYRYONXIGMwtBcTrqFzjwSE9ZxOxbwV0Rvsw9+DJVFkoyG/UwpKruUvraIX3Oo4KBcZsQqwiPd9HLnjJAAhZLZciPOOcMxhSFoLk+VzQ4sfwjioSlU2e7BVfYByeUwHJ+P3RmyIcrM0rbzNhyoRfEXYn1z2J1lhmgm+DSDCWWhqKL8iHxEE9bNBlegu6Av/tjIuyudHEGroU6pTvpVx/woTqevtfVaueUBCgX2VQzGy6SKK3y4t9yLl3HAxUvb/04FviIcUjdUIVgngM/btIFsv7dXQDsGh7q751hCUo/NlBS8sWQcbj9cKXCEZyzIyfDlnGDvmw6nzngxR879cIziGW+iBloQh80JdvwyP6U7OXJ2Nf4yUEUBqlhuy3gx9bb2cuQNhOPCiBVNMmDTHJ4E8NuRW4GFIF0ay9sNq3eb08FjmDeXFGQkp6Eqf6hwWN8y4T4u8UmSHkuu
 bD+X1a8K
 g8fayYk+1gLaCg9jY0NKJ+fkrYX5GT/cuNxN4/jvNMsLZKqWjlF9pdoMc1qqmM0wHaqqw7L2SNySSQ4p0KnybG2XTfek8zjCDoJRyrTxzeAsVte/1yEGHsYmxT5a1BaHFfX/0p64rIgvwfYcwKN3sA3ttu91hPDL2JPBgDbjQZCMT/mKqJXGT651ZQCYey7+cBwlFYC7muFfvrbmtCmlsWzFZJ6bouaqCfvkfA0KkiSZvZUHVkA1Vu0zlF2sCUBZrSGgiTQ3Xcr6R7PUF2y5+UAbREn6FL5p/LMHsNQ1RoDlJ9kNFPTpSrMei+xne+l0V69XNaovxWDg8Qa0k7jBlHA66XfN9YbUHLpguYILT4Ja6N5HwWXEsSaKi7q4uigZJ0WKNofHoS0fQD78=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 11:52:33AM -0800, Vishal Moola (Oracle) wrote:
>  static int
>  __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
> -		   struct page *base)
> +		   struct ptdesc *ptdesc)
>  {
>  	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
> +	struct page *base = ptdesc_page(ptdesc);
>  	pte_t *pbase = (pte_t *)page_address(base);

We have ptdesc_address() already.  Can we avoid the other uses of
'base' in this function?


