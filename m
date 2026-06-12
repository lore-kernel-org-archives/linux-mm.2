Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C8ACD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5F36B0088; Fri, 12 Jun 2026 14:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD9E6B008C; Fri, 12 Jun 2026 14:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2E46B0092; Fri, 12 Jun 2026 14:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C24F6B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:18:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 199D51C1078
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:18:12 +0000 (UTC)
X-FDA: 84872070024.05.3863626
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 253AA1C000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:18:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZKYp2s8G;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.217.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781288290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iqIpA7z+5uzNHU9YvroEcwha8urHL7cOeSZxwXaBPs=;
	b=71iih75r8PCOdYJ6E/xRkggkNqGfsV94rCgW2ZY6vWLM0qMbBbKopan9R0h9naCoIYnXWY
	14djoKqsRm7/3Zg/sFbZ6kioX+ttEiTfs5L6BxqXPtdFCjVWRK8iwZqQ8T9c15R1u0wbGm
	i8t9q02C7KEs2itBTtNNcfPT9cH6q7c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZKYp2s8G;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.217.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781288290;
	b=Perm53xZ7qw+WteC0TsBHqpq6LkQB1SveZ+RFOGs4D5Dwk9pdgFTqHJVIbghdaT9gfpOtD
	J6mk3ORbuw+w4I2n0nY0rD91+QSOE9U45L3wPDjNGtMMvoHaUFTuHkGiC+9+9wo6CTI2iD
	bsBDryn5EWuzdyCX4misf93XcftFjgg=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-6c3154fa47fso963225137.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781288289; x=1781893089; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+iqIpA7z+5uzNHU9YvroEcwha8urHL7cOeSZxwXaBPs=;
        b=ZKYp2s8G5XEVzQG9MHuYf67B7iqio9nzD8q/cbzf4CqNbySzpSrIaLWz5zldQem5OE
         8Hz1RHapkj2ZBnYHAu8ZxC4zwJeSSvEYtP5bj/3Zt4EyGKYbMSbkTSYTzVKwzwwrNY+A
         sYM9L9V++rrpy+Cu7j/C6IbCfbaNLL1zD7wMGfUEbRoeGwUNQ9fpSmrNcNvZPGj6eePW
         BPUUd2Fa0693ZzPey2+W9+wUjqsOQ0HiJWFdnsAf9OlRUaB3Lg0dXSwL5bH5WL/ze8DC
         qh8ztG1fTGO/2pgx8Tp1NyJqoF5nuJgaMblLrOADc3nOtCeVBG3Bk3New7ZUBNmTnVxl
         XzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781288289; x=1781893089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+iqIpA7z+5uzNHU9YvroEcwha8urHL7cOeSZxwXaBPs=;
        b=mxbaHevDZRtbct+jKz79kO7UKkqSW9Jn+bBHsO6r0Nc+VLXRl231QS9lEqmWpjc+hO
         pfPxHb54Pg9MUszIY4DENYniJH1wm7in9ppAYGJCSW8XZsPZut4kPxG91foz5iHbSLeF
         qpEwtldYmK3sg8Ttvct7tyXBv5WihNnaoix0Cd8605OmOpVVTnMPWktoKUxXzTDz4jkB
         tnDN1/yYyVsgo4aeSvy6Nb2K2WuvxsxLFyj1pLjsLoiI9ZN/5i9r1/TyqprwWGLb3Ta7
         bVlRf+/zQvvWf4IGjttuHr/W6v6oolQi/0Yju9sCsHcstOPM6v094sEm4GRpMFhtcKiY
         avlA==
X-Forwarded-Encrypted: i=1; AFNElJ/yAYL0vJYfNJVt1LqgZULO4SQ4USnQvSqZEXcPW965M1/NX0D/oWHf+B0zwSj6+iuZlQh2ahO6tA==@kvack.org
X-Gm-Message-State: AOJu0YwZqutno2EWJkeJklTsqt8wkHFTfBgUNMLK0GOxAqhpPCbhJCXJ
	iYLMkP7IUCsbRTUxvjOa6bWlKW9D0j34xhpKdZZfFVzezK5lRNmuj1I2oVyh08my8lM=
X-Gm-Gg: Acq92OEMHh2wVxiW9EfoRQHMGD5fjORVxnUdvsDfEQPfbG3buhrTcpt6ElMyakjYuPK
	aDpg4i/naHuG8g+vHK8Q9cUx01lm9Cl7QRNxghnbnqT8vxeHK07S06mBC7gNF+2QBuaoLiaQHKG
	STLWd9N6beQgsTFoBuVFesSGcZExqP9lCdH2qHBnoFFe/IDS9EpQYBYLO2LQzGsCudFnD7Nvtsj
	kpcb0LoSRS0UFkKSEhPLfNoGa9sHwl1XqzWHagek8/8Uk1FOd7tcA5YQf8Ct1X9fU9/vl5dZu+j
	y6L3HFkUdG3Qk25djmlGqMnot3ziQoG5XAbbWWg3tsqXf0H98cY2we2D6Zhd2xa4aMN9nMIb1fL
	gVtADEZDK+CoBBqQs1hLz7+bbBGBpDQgrf1H7mhdC/TWGLzouVX5da/CR7vYCQXcEtQCH+v2dDz
	rvJFy2Cxt8WJG1niEJVLz7vfqj3Nj3lGJwEa4eIoJis4w8f10DAQ6bcLsCN4iBll2O+LjMIrl9L
	7lEsQ==
X-Received: by 2002:a05:6102:5a99:b0:6d5:91f0:21b4 with SMTP id ada2fe7eead31-71e88e0e755mr3085010137.29.1781288289001;
        Fri, 12 Jun 2026 11:18:09 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619f3c324sm282729185a.21.2026.06.12.11.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:18:08 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wY6SF-00000008EqU-36LA;
	Fri, 12 Jun 2026 15:18:07 -0300
Date: Fri, 12 Jun 2026 15:18:07 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: Kameron Carr <kameroncarr@linux.microsoft.com>,
	akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org, mhklinux@outlook.com,
	linux-coco@lists.linux.dev,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Message-ID: <20260612181807.GP1066031@ziepe.ca>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
 <aibhnnDFQTHWMEFe@arm.com>
 <20260611114954.GC1066031@ziepe.ca>
 <aixGqCqKkQeDfUST@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aixGqCqKkQeDfUST@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 253AA1C000D
X-Stat-Signature: 93ejcf8kewhogfgymek6hkudgkhh46aq
X-Rspam-User: 
X-HE-Tag: 1781288289-93107
X-HE-Meta: U2FsdGVkX1/fME4GibeHuHFCnqAA+eV+myTp0+e3EHdaFKq4mY7etEyDw707xmfBodw2lasl5dDzrlGUJ1JAakGaG7kNE2LTeV/epLCOs5eP5looA4hW2XlqdlpoFgkoFmBPw9m+RIY2XSJx3LL2WfTlZFNqeolFTaJvyQ0D2j9u2quBwRUbWEHqlZnqY/C9hMTlAQJSZjVvao0P1oCNdgUp2tZuiPyeNnTHOzWa5wVjOUwvDa1/kd/66YHGAscfMVNkZXHGxYC4whJ0jjm31+knopZIwmjBIVYc3ZWO0EmBJGcviBaoszl7lKcmxy63U1nTLlXNb/gjmN+kTi8T6JCB9VAkWbpb9JGgTRetjJf3abl+MVQc8VCN9szYTjhA+huhXdYg+NDPSd1/RD8h6nmGL/6Z+rEI5zXczZsGQKMWaejvY92c+cW4HTOrmL08ZFfVfnV7JZXcMoDSezy70UsogUnuL+gzM2456hp+mrx1hpJ5/YpxzjQWssACjsc8sNhxkDCmq6j5LAxeC6ZYl1omJu+kv+u6DKtqyvZHlagfCZ1Okc7jGGzz8UWFz6G2ebl5lbn/bk8UtuVvoPsp0sen9fbzhHXTtnOtFScGyTaEN0JGi+GAoSV7T2TuujR7grqBGRSk/o9tyyhYDJOFkPb48Gq1Owltn6nmovie8kllkZlseS189caeqvmhKCPgUtr9y4R28flF1/XWapDxLf+4+lF8H+BkpCb10qWNSYfH4/6nmmxBYur9634X8Ax+/V++kk1WNPfMVqb5F6C0pir2FY5UEirg427Pnd3qw4gsFa8G8yPQr/3Tx2AJPrsmbTQeauDMmhm/ZBKZ7sfz3mAAOh6KIFTBXLH5DuNpKBd4e/xdGhM9f7T0nl2SRYfmJk8TOcHesUIxRZpovCky92mO+pQrH7oOrVhi/ifhfAp/LZqDuZpZaCmccDnEMh0c7pcNAcCUWhN3gdCcQ+4
 1/mkmU1k
 DwuyMEyNspcSJ25XTCEWEGXwPaguYinVrWCWpCoRVEjIt0srAYUFgD9JgnB86Fl+7YE3mCV/yzE/yFFPZXptSr1AZqRFqH3tZOWOfFz4Pbt/yOhArr9x+bHv5vVOBzYNXH6APHxJfxElkJgmy+LKd1eIHXQYe2+mSrTr32BwS/yqmDMLwIduz+YaPZU6c6gVhoK49dy+0ThrS0aI5dNFgpl4j0W1tGAAxpvno5tb0UiHyqwOrxnxhqTHjVMZZyH4GD1ZxPm18C2XOeaiiboVryCV1TAhdEUyL1XcptfrD4kRudb9GFnLUULWK0/d9/dP9o5a/tWq4LAWS6wk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 06:49:28PM +0100, Catalin Marinas wrote:
> On Thu, Jun 11, 2026 at 08:49:54AM -0300, Jason Gunthorpe wrote:
> > On Mon, Jun 08, 2026 at 04:37:02PM +0100, Catalin Marinas wrote:
> > > > +/**
> > > > + * vzalloc_decrypted - allocate zeroed virtually contiguous decrypted memory
> > > > + * @size:    allocation size
> > > > + *
> > > > + * Like vmalloc_decrypted(), but the memory is set to zero.
> > > > + *
> > > > + * Return: pointer to the allocated memory or %NULL on error
> > > > + */
> > > > +void *vzalloc_decrypted_noprof(unsigned long size)
> > > > +{
> > > > +	void *addr;
> > > > +
> > > > +	addr = __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
> > > > +					   GFP_KERNEL,
> > > > +					   pgprot_decrypted(PAGE_KERNEL),
> > > > +					   VM_DECRYPTED, NUMA_NO_NODE,
> > > > +					   __builtin_return_address(0));
> > > > +	if (addr)
> > > > +		memset(addr, 0, size);
> > > 
> > > Talking to Suzuki, the small window between set_memory_decrypted() and
> > > memset() potentially exposing stale data is safe, at least for Arm CCA
> > > as the memory would be scrubbed (there are other places in the kernel
> > > where we do something similar). I assume that's also the case for other
> > > architectures, although not sure what pKVM does.
> > 
> > It seems like a poor practice though, this should probably be
> > re-organized to use __GFP_ZERO so things are ordered sensibly.
> 
> __GFP_ZERO doesn't work if the intermediate set_memory_decrypted()
> mangles the data (e.g. changes encryption keys) and it no longer reads
> as zeros.

I thought arches are either preserving the memory content or zeroing
it, you are saying some arch leaves it as garbage? I'd argue that's an
arch bug and they should clear it in their path.

Otherwise this sharp edge is not documented and we have many other
places getting it wrong, eg system_heap_allocate() doesn't re-zero the
memory after decrypting it.

> > But what is the purpose of this? I guess some hyperv thing - but
> > shouldn't we have a more structured way to "DMA map" things for the
> > hypervisor instead of stuff like this? Why can't you use
> > dma_alloc_coherent() which actually gives you an address that is
> > sensible to pass to the hypervisor?
> 
> IIRC netvsc_init_buf() uses vzalloc() to allocate some memory and that
> buffer ends up in set_memory_decrypted() via vmbus_establish_gpadl().
> arm64 does not support changing the decrypted/shared attributed of
> vmalloc mappings and I don't think we should add it. Better to just
> allocate it properly upfront.

Sure
 
> We might be able to use the DMA API but we won't get something like
> vmalloc() - physically non-contiguous. 

The entry point is dma_alloc_noncontiguous() and you get a scatterlist
back.

> I think dma_alloc_noncontiguous() just falls back to
> dma_direct_alloc_pages() in the absence of an iommu.

In all cases you get a scatterlist with a CPU list and a DMA
list. iommu gives a smaller DMA list.

If you want a vmap then you can feed that CPU page list from the sgl
into vmap().

A dma_alloc_noncontiguous_vmap() helper would not be hard to make, and
IMHO, would make alot more sense for hyperv to treat the memory access
from the hypervisor as "DMA" instead of trying to re-invent the DMA
API.. :\

HCH was already saying we should not be allowing drivers to use
set_memory_decrypted() at all, and hyperv is the biggest non-core user
right now...

Jason

