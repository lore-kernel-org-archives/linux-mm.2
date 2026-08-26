Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19EFC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B748F6B009E; Wed, 26 Aug 2026 17:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BAD6B009F; Wed, 26 Aug 2026 17:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A986B00A0; Wed, 26 Aug 2026 17:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACA66B009E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:47:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D8B31A0255
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:47:17 +0000 (UTC)
X-FDA: 85144756914.30.9BDBFF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77C7440006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:47:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jrl06373;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787780835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYhBnbgaM5tsdHStoHUAOfPpl70osUN/iMiXrAYwhXo=;
	b=iBdmdvPAF506TkbTiMmbJ30nqe6uscbXtfY81RBc4TJ5PpCTYqgDDdXCvunpQPQPHBC39u
	Zh2Z/28CR/Zc4qp9K78CI0XRxW6a/OPSI8xfiQQnfyw+Z7G/cG03VXa+wS5ddHDQgfki6w
	13RQmaFul1hsabGlxp1w+ZSBr8mtkkQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jrl06373;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787780835;
	b=t1FnzhzbQT0uk+GDGTEPSH0TwgHOlTAYWGhszm/AuHqV5Y0w+ZKpHHD6+RnSGiV+vmJ3MA
	TNsnLx2shOUx0irto3wY7ApQrWtVHE1eaW1BBuyRQ+Z1BT33t0UdbK6lvfo3GyYq1Gp9JO
	lNGSaNqhwde0FjvsS6TzYBekqzEEn08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A737941705;
	Wed, 26 Aug 2026 21:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236451F000E9;
	Wed, 26 Aug 2026 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787780834;
	bh=uYhBnbgaM5tsdHStoHUAOfPpl70osUN/iMiXrAYwhXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jrl063735GQ651Sx5tkw/WYfZg87jCVUGYR086riCa1l56MJB0L9We//V+CrSnrMo
	 dtau/nQDtjn0s5iuzvLOk7wvZ5QjWIHMIFZC5xV26kSa0DESY7141+TMR744OqfrJq
	 011W7EqAScOWHs9Lm7dug5xBjPpqHf5+dJqRFC9TKnM3G1yOlmsK8/mQH9HfKLs1RB
	 GIwJKMpagaBcHmAbNBsjFSrlmxaOG67zccFondq9TsICcc8wspWwUpWAMSUKxNgE0v
	 Dnrr0NUQUIhXciX8+og6m+OIfSKPRYyVxYHmrwxXsXXk11eVTolO0g0c6VAQm20vrn
	 p0HDzXbjcDp6g==
Date: Wed, 26 Aug 2026 22:47:10 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	syzbot+805630f1453e490427fa@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: reject unsupported kmalloc sizes
Message-ID: <ao9dPUpHxP5uOOcw@MacBook-Air.tail10959e.ts.net>
References: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
 <82f138f5-11d4-4839-94a3-c226fd982715@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82f138f5-11d4-4839-94a3-c226fd982715@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 77C7440006
X-Stat-Signature: 4mzz735kkqczi3fty6s34qr16prmm6ey
X-Rspam-User: 
X-HE-Tag: 1787780835-348774
X-HE-Meta: U2FsdGVkX1+VgffNSGkb/3zXgyFwC16XoSXoO3yFZ40C1rZq99S6vMabFINAgmm0PUvQoj8id7rkIZNEHSjLbPhumuzL0zHZz2buZXnRP+983slv6NLCwGq9TNbkFbnY2fPEW5d9A/RJ99sg5w58/aVcX/CpHK7r2eBdx6NqM3yIIceu9GZXiLXa3t6A0OXGZp/v8OBFCwzzf+SCbWDFtZZcHKbjkWQWz4e1VmP7eV5VdCNzwPDh+9UW7RkJnMTDf8+ZSAmqgkGYKFKWtRgZhOdlNTkiFJoysEvmGJsy8h5A4cISQ6DjUn8s0vNHUaseFuPKehMXuZ/EZVtwjOUMGczM1VJNnPIGyYXsR6Kf5PkVUKX+yygGOT4dS+WXh9OFXz9q3MdHYeav+QdUeMwEE8XGqE67L0I8J7Aq5rLMKrPnEQ1LiSMlFDB0A0H2gCX9dTwxZuxiNqg5fSDcPnHqQuo/qVaKkN9HjHwXf83/f5dRf6NNR6qDk2ILX4iq21VrPsKcW9PJImGUmsD+lyX/vBO+AtWRLR8QyO2qyyD4Ke7zPToKat7wGJOfFJpu5nFxuRlfWD3NAyxQ5l52Z7fQ5BQXCxUhTsK2RG8XMqi2oaFH/IF1h8WfyhsbRRVZTE32rDL8v2sy61je9yPWPnoU+JXMK67h1XOLdY5YtWdpmdR9KOJND9Ogci07ZL+ek3xvmVv6s6+tauDhUuiNJ1ldR5ZRsfLyghXpx2QT5KYwoj//tO4YsMJj5YrSZIal5bVNO/db3z7pPfG84KXKp1TJ2AXH2mU62dxtayR1BZa212Gcp0m+b6lFfcbalVjymFDkyg+yt3w247uWKlsjmu4tSoas5dRR2D/8CBEDcVaGpclh8bUDjowXBGyWo2pR0TJeIeem4HL2Qde5eFUMdniIiH5CyogM6qKcPm1El32UYVxfQ826J1szvpy2SpNuFJylLkgDvBcRdqzn4AdEocj
 q8L/niwo
 tM1vqpLamshK+cEuyqSZRjOyOyTAXMgiTBPRarNCymxOHpbC/Xf0iaeWjohUeQKN0tCY8yM0owTcYfvazmZkVVdVmlWpkn8s7W0ZGgNMYcKYCY0dh3vJg4G30Wx0pspbQIqkazHl8PGKA71b5uqT1xFPOTQkopr3H+viQ5DGDhcHqANB2m4PzPYGJMhUFwgpgUQBNtz90v1biQ0nwufBN1Ht5y0sn93jR/qU3KFZGNW4znTcn+nWXvTeUZONYGRtoCqn6/EtwTzAvE0+g39oIlZnj4wywTxKv+3CqhLbQzB2L3uYv6SMexxysVhssbxoYSZTACH9YyKeP3aHYTVumjKU4QMAGlcJSW3MnZG3VSr6Nn/XXrcNBw6yXBe+iwxDenGOh4GYl6royMhsrFVTaJ+RaRs9cxFJXm9KqExAghp/eiPRF59mrgrP8mfC4RSOJ9RSaWdpcRodykEwZ19dPIxRfT1vYoe/dsrb+mhBEUUGOH/bGCQp3IFoQXZh2oL7mo0Q7D7AlUlQyI8qQybZeb9VCFXBfh/T74Af8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 11:28:12AM +0000, Vlastimil Babka (SUSE) wrote:
> On 8/17/26 22:40, Zi Yan wrote:
> > kmalloc is used to allocate physically contiguous memory for kernel
> > allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
> > the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
> > sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
> > because kmalloc allocates an order greater than MAX_PAGE_ORDER. Systems
> > with panic_on_warn=1 crash because of this WARN. Fix it by rejecting any
> > kmalloc size bigger than KMALLOC_MAX_SIZE.
> > 
> > Fixes: aadb4bc4a1f9 ("SLUB: direct pass through of page size or higher kmalloc requests")
> > Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
> > Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > Cc: stable@vger.kernel.org
> > ---
> > It fixes a page allocator warning (order > MAX_PAGE_ORDER) when gadgetfs
> > requests excessively large memory from kmalloc. Instead of adding
> > __GFP_NOWARN to suppress the warning, as was done for usbfs[1], change
> > kmalloc to return NULL without a warning for this specific issue.
> > 
> > [1] commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively large memory allocations")
> 
> So I checked and for kvmalloc() we have in __kvmalloc_node_noprof()
> 
>         /* Don't even allow crazy sizes */
>         if (unlikely(size > INT_MAX)) {
>                 WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>                 return NULL;
>         }
> 
> This comes from Linus in commit 7661809d493b4. I'd do the same thing here
> then.

But the purpose of this patch is to avoid the warning in the page
allocator. Should we fix this in the caller (gadgetfs) then? 

> Thus there would be a useful warning for e.g. development mistakes
> resulting in the size to be unexpectedly high.
> 
> Callers passing size that comes from userspace or similar untrusted source
> can either pass __GFP_NOWARN or sanitize the size to what they expect to be
> sane (which is context dependent and I assume actually way lower than
> kmalloc limits in practice). Note that passing even sizes within but close
> to/at the limit, trusting blindly some external source, can succeed the
> allocations but effectively DoS the system with heavy reclaim/compaction. So
> caller sanitization should still be preferred IMHO. Some of the recent
> arguments from Linus [1] would apply to this too, I think.
> 
> [1]
> https://lore.kernel.org/all/CAHk-=wiSmgwwLKCqJwGS-dVHnSLU8W+7q1UQq-G9=TBGGZbuhQ@mail.gmail.com/

-- 
Cheers,
Harry / Hyeonggon

