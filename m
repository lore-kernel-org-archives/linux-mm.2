Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE48CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908F06B00F7; Tue, 16 Jun 2026 17:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0706B00F8; Tue, 16 Jun 2026 17:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6406B00F9; Tue, 16 Jun 2026 17:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3DF6B00F7
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:43:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C61D41C33E8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:43:23 +0000 (UTC)
X-FDA: 84887102286.26.0DFE6D3
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id D7659140002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:43:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=kQnP0wXD;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.82.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781646202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G18mYJrcuFPmmxraU/yFJy+0YudgzW+4bZ7GypMnwpM=;
	b=KodmP3Sbk5BpkU26I5YhDZG8wVIFpQEXAwilmE5qBHbegm34IlR7vpDlbkRetGNe/00Hdh
	vwo19Z74Wm+C6n27VZvnOUZOi2sEQ5AbgVlnIU9Fq/XwiizB8aMkh8BffQr/Rn0cJZVOND
	6v73G5TQ37CHHMIa3Kz2CmfnNQyb6L0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=kQnP0wXD;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.82.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781646202;
	b=03mNLDjyWbX/P7Vi0vs12fqGlwgUu/OnJOuhc99r6hGDnLOJ4Pp4jBAoZlusCNbcaft1aO
	M9QP475r05FQIgTS26sLMdcAErAq7nk7HHnXENMG1eQ2MHuIHlyCJo82d7Yk+fTr4HB9L/
	H+U8LcYgqhGRzv3fWPuqOLnNqJl5nQo=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30bbe98c3f0so1291111eec.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781646201; x=1782251001; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G18mYJrcuFPmmxraU/yFJy+0YudgzW+4bZ7GypMnwpM=;
        b=kQnP0wXDfLOZXDQK5zKg5A3enKgRMKx+gtiFXzGnDBH0D+OcjecT+GQ2Tbzs8ujBJL
         ucvpp407RtAe3q49eGnLpBUnpiMapx8IWcQdZVDQPbAwcipBHx9BZiAt3RedAhMxeYVW
         LrXhpNQ7o5wfXmzgDt14WY1SB07bf9KC1e8Yr53PARWKtypLAD/tGvcEYelVSIupBcv7
         hn0SbLTSqRWi8xGolrs1k0a5ECvz4hYf2QMqrJEgFpKjJXIAGqc+5FESi6Lc11nXSgc2
         jtg5+eel9CMMvjeVdxxBh4wiaftOPxD1tqofnw2uZ4p4ayvDwltdeUNaIjLIUNdyQT2L
         tQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781646201; x=1782251001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G18mYJrcuFPmmxraU/yFJy+0YudgzW+4bZ7GypMnwpM=;
        b=VjMwa/gsEpkwQw8mfCAub9RkhHDXrhScGe6G84d4Qmq9krpCVcfjYg0PsjaSQDdfYz
         AEBqMtQPehkI1n2CQLeRj1ccRyqYJs7WC/ATUWjpTUTq2Uk4v55RU8Ozk2P9u5CnIlT0
         VSxRk+nQ2rW9O2DNxvs9tELgsXNNqDTRvHdih7c5wAFghzKYNN++P3t3ECxKn+rf+1Bz
         RwvfYvFTTzfz6FIC5tsuG0oq9X/ZbCUGBIou66FQAuyR8KAwVMNEG4MQjs5PfWv8YdOY
         8ef8S8caPzowzrxGnRLm17V+ujZgLLhMrUOatGzDhVGB+vaemhav5a36sxIa7dssNxh5
         5rww==
X-Forwarded-Encrypted: i=1; AFNElJ+xagRFbn5NQG8kKHdGkcUhNwym7BGMi3xfryxpkwm2gfFY8R9o1CUqye3We8z0e+iJsFOIA4JitA==@kvack.org
X-Gm-Message-State: AOJu0YwKiEnzLqAzsLwXGyhq4SVgqummT33VjZ9A1++FzIvbLWEfYE8w
	wa6UG42FKYYYmkBlweQ52LN8r/vFTOfj+D73maheRmBKbnmEZeCmWnj0mmkOLdbIYoczwrBbIUz
	aMBsl
X-Gm-Gg: Acq92OHaazAgwCncKRbz5wIfV4N5UsI5mveW0OqUNblTIjlZkU5IjQBCyhhRZrY5hbu
	x+lVpXv2ycJmjUyz6powVu2bIAFwgJTYBsNoHvj3DogFfdOfPHkw35ZoDq5chfDSbHrFL+PmaBg
	8jI3m7ylUy8GhruAEN5EM2X4Gewg/N08zXe2C6ycO8Nlcv3rvkC/fCpv+doS6YiC+nG3H9kH4JA
	ccYNPKhCLoQ2QtDsh2O80YmAHun8BY5gt9e7DLgfP2oxEZYv8YRGhAD+65saWQKdNDvJPUEZT7O
	6qqaDOrx9vC84nIxivmA6jwnzmWGYJ5WTkAp5bcUIGVHxrBhZQ2dBsSD/SGwN3h3K89NPP9o5uQ
	9X6j8Z71nIWmd6z4OHSJUbOfTDjMauSfK1E1P2TYvtvwLDNmIhC/S9neMDWhR9gbKakfXHc0r/u
	s94Kn41n8h+4gsVwJYPoc7PPuWAZ273suHobx9kW6gVMg9LIZpB2JjMc1uT6fk2Ki0NjJNvTImf
	n8A/A==
X-Received: by 2002:a05:620a:2908:b0:915:d32a:1cba with SMTP id af79cd13be357-91dbc52c4damr20136485a.27.1781635502015;
        Tue, 16 Jun 2026 11:45:02 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9161a00af50sm1669672285a.30.2026.06.16.11.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 11:45:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wZYmS-0000000GgQZ-3dnI;
	Tue, 16 Jun 2026 15:45:00 -0300
Date: Tue, 16 Jun 2026 15:45:00 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Kameron Carr <kameroncarr@linux.microsoft.com>,
	akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org, mhklinux@outlook.com,
	linux-coco@lists.linux.dev,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Message-ID: <20260616184500.GD3577091@ziepe.ca>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
 <aibhnnDFQTHWMEFe@arm.com>
 <20260611114954.GC1066031@ziepe.ca>
 <aixGqCqKkQeDfUST@arm.com>
 <20260612181807.GP1066031@ziepe.ca>
 <ajGTPelKLhgFqh7F@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajGTPelKLhgFqh7F@arm.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: shiazitm6r19s35xzw14dredoc5bj74c
X-Rspamd-Queue-Id: D7659140002
X-HE-Tag: 1781646201-108847
X-HE-Meta: U2FsdGVkX19c9Cow+0Xy9SEHYIwFO6KHd4xjryj23E4FOOUvIAwe97CajFSDXf/Nx+h7W16+VzZfy0qOttR4h3Qyl0nPPdbruzGyMzfYcEXL01VYrJqK2mVVwDaV/QzNBBuT8rKmKm6d9Rrc2mPs11HmCfeFqlCwY9wreMklQannlGpDVf5g0PUgpkViEYSFjiOkc2tqyVCJfa9dz4YXffcLWsxGvXdqiIIlI6bkp3XNz+Rn4cCF7OBXqtam3Ha6I3hHKXEzmivVkxnETdHKohl51GHKmT+vSM4e3og9NazEtYbUF5P7Rgneh6TVBRepPk03ZuN+f9fSqa810kVOIm4XnJVxoynqzWUVcT2yb/rTKgUgmBjFWC1DWcqP4VBj8UzqPiPIcEa3yFP4F5icdsj7JeDz8HngxUQi8mFHTyCYIlQJM936qEro/GYbcRFp1H1c9kORB+SsM4PmIA3Q8GY2DJ72sYPYLlWMsgxbo+y9TabGydjvDdbdAPWFlYOmv3NmV1L79SjSvBl+kvfk+UcytoHyM0J+PCuJtw3N6+arIL5c5h5hz/uP9Iv41ckpDzhqUwYovwTh0RcE2nt3tJBY9f7cwT71K6MukTQXVhd4QwHFN9iv5XiMbX2s860PdF4fuQ96UbPBgxDisQYnk3pACq/1NoFXAFzb8QpdUyOBkq9vgaQeIxaOnMweETZKCszdG1AJyucZzUXeWZq9u8vghGEO48w5RFtLiG+HWMte1crQKnaSiE52PFmTmJhhxTcWFQP6uo5bB5iUtFlOFw6j39n/pRxsquLbFZQYIsCtqAsTwjFSbK0YiOOyN14Yj/chwbmgHKVYlkm0OnBGmO6GzsOnmFIFsV5UgpYGP56lNqERs4wNKMB9qmyNzjSdyMbnmHxpVfcQBE8H8gek5OS7drMMMkPc317RwV+E+ZWcrRy3qRRX5m7agQQ2wQYcqTUjVCTybd5J2mVg0Yv
 KtUM+mBN
 dS3I4P/cKmwoWZ7OVhncylRpop7ZTCcekvMNQLhlp+AGaw5oG0Surbk66dd0s9prrmuqiegKNi0AifoSWNB/2734YSTjZtOToX/t4fKapDZvPYyr1v1ACqO9FYHajeRaTBjnKPOkH48QtdYOSPYkiOVc/fTRaCLTkSOaP+Mpq3XsynrfHnN6Wexy+pPcubAgLPEpHIW4WSpSSeqCNR1vtpY2PeMdvBNFHT7gLUZXhQtUJCfJ7I2vAazXp9d3grJl67tafdz8x4aDRU9QtbgBsCKn1a43VhrgjD0rPlKENc10ygbAw3z0y1UFSbR2JCTd7ZTvvYsCV2YutlhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 07:17:33PM +0100, Catalin Marinas wrote:

> > The entry point is dma_alloc_noncontiguous() and you get a scatterlist
> > back.
> 
> Yes but not scattered pages unless there's an iommu behind. Anyway,
> that's an implementation detail, something like
> dma_alloc_noncontiguous_vmap() could allocate scattered pages as a
> fallback.

Oh I never noticed it deliberately returns only a single dma entry. I
think that could be optionally weakened without alot of trouble

There is also dma_vmap_noncontiguous() already, so I think the main
framework is there, though it seems like it needs a a bit mmore features.

> Currently, something like netvsc_init_buf() just does a vzalloc() and
> passes it down to vmbus_establish_gpadl() which knows how to interpret
> the channel encryption status. I assume with the vzalloc_decrypted()
> API, that info needs to be interpreted at the netvsc_init_buf() level to
> know which allocation to call.

But it doesn't end at alloc does it? hyperv will still have to reach
into the vmap and convert it into an appropriate IPA to pass to the
hypervisor. That really needs to use the arch helpers the DMA API has
and those should not be called by any sort of driver environment like
hyperv.

> If we move towards a dma_alloc_noncontiguous_vmap() API we need vmbus to
> encode the encryption requirement in the hv_device::device somehow so
> that force_dma_unencrypted() knows what do return. 

Yes, they would have to act like PCI and mark in-TEE and out of-TEE
struct devices properly so the DMA API knows what to do instead of
open coding a copy of all this logic in hyperv.

> We have the DMA_ATTR_CC_SHARED but that's not interpreted on the DMA
> alloc path, 

It is to describe memory that was deliberately allocated as decrypted,
not to control allocation choices.

> so there's a bit more work needed on the DMA API I think (not sure
> whether Aneesh's series covers any of this).

I don't think it does directly. It largely sets the stage to properly
allow a struct device to opt out of force_dma_unencrypted() so we get
support a T=1 PCI device.

Jason


