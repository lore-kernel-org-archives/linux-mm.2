Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B306C44503
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18CB46B0088; Wed,  8 Jul 2026 13:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E706B008A; Wed,  8 Jul 2026 13:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C9F6B008C; Wed,  8 Jul 2026 13:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C270C6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:42:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FFF6140211
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:42:22 +0000 (UTC)
X-FDA: 84966328524.12.CC9F5A5
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F0F612000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:42:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KD4Y3Lll;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of praan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783532540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NY8WDLERqRUUyPPjKLcGWnXs7jTmISXhATSCwU5JbWU=;
	b=yiMwb84iJCsX8Bfzy7K6A3CB61xmM5zkY0oGh7XsJ40CrZCTycsBzMGZmvRYkI9x8TaR0D
	pGJW8yD6e4XZDRXZz8iIymH9T+KEU1duRgx7mvymdNAKZGseGux6Egn4iNeoH6bTId0VXO
	NF6RuQkmWgwtK/fvjA7mjVAbE2AU1qM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KD4Y3Lll;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of praan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783532540;
	b=IyFADvont8wHVaqmYm7zodYOlCjjJZ6vXYCK5N1FwXRmV93RdekJe9UsCarjRYDDsIH1St
	S58l5Ux8sC04miSIRTic+Qd+42fjyAgTmU/GAVcsdgQCxTjS+m2E00mdV7jFht4V02jypF
	y1cGmBbzgJdFbmBQrnrHVOxZbJwm+6s=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cb59f6ba26so9245ad.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783532539; x=1784137339; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NY8WDLERqRUUyPPjKLcGWnXs7jTmISXhATSCwU5JbWU=;
        b=KD4Y3Lll1qnyGxhe/pFJZugGEMACmQRHFMGd+m6LviDbjlApfQIO2SRurTWq9+R3FH
         RPPzVvuvxL2aOPj9o6Yd7lxe03MWYNdjUHYJWDC2oJVR/AjpZt+kRwdd50ybTOMyXSMM
         kUfoSps2NG27htb4YcLh/l4MdCYcUYnC/7haTsoiM5UpHlA1YEohB1mmU27ePNGgE/FO
         OLvhlw9IyQB8VzYxZ4KmDA98AtzVNC2A6rY31TxEYk0nWeUz2enuTX82XmyDBXWJ54MZ
         fWp0GZHvZW3BF7tOGT48LHBlPmVHRUAz7GbQ2+tLWhURTba46uG4EKtrmkPwCDGJ+WJn
         FJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783532539; x=1784137339;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NY8WDLERqRUUyPPjKLcGWnXs7jTmISXhATSCwU5JbWU=;
        b=a1sO/hCpGdbD27pTCpKWXTwIZ+eB7OFHDnFaCkWCCO7f+GdeHu+M6aDFyEtd3U2Xb1
         sl1U6fTPcGA3PBdgyuWpJivNFhmGoOHg8VkSccUuzbYp0S90af39eVrxlK8WXxxCCW/I
         y5m93QiY1gVYebUicBL77V/mZxpfq/EyIUZGZ2xmPs81sM68Nqd0Zu8NbZQ4b579vWdl
         BIn2wF3HgrqUrD2c2GFnyGC1vTCLulQmxLrrjlRmB7a7RUzMqpBrU7L+pB2DkXcMFb9S
         j46zYbsGr258W3jHku4fJA/DMpuE+a9qoeBq2p+i6Ptt3GQ2k0er02vLnpRl21OaM4UA
         3v9w==
X-Forwarded-Encrypted: i=1; AHgh+Rq6H/F3B4S4sKvIDKjbMwiPPjg1oVF1kJNYMpeX5QXdWFVqR2DS9XF/YzHHdHRMX07BrtQKajfcKw==@kvack.org
X-Gm-Message-State: AOJu0YzcF3MdY/kqVM5Yu8q60EjEYNXIhesMVrbbFdb+YY/AVzINR1Ih
	ifXiAum5TX1y8ZQbYxlVXMOXLSj1bjGbr/p+WVLJXHJDMccw1qeUAocG5UfzvzcWYw==
X-Gm-Gg: AfdE7ckXTYdeh8+ineCP9KOtUh8eIK98RgkI416gsvY21Wa4CDoFqc/f7ciZlZYZiee
	RXFEz8Ha7u3ML9fOXGqq1w/wvsCCh7d698y88BhW+nKW6QlvVb5ocGFW503wp5mR/AhQVA3tNq/
	cGmnTCr42USYhevnp7AO/50YrgXauQabmkq9AmQKj0gk0cLSqu2IzDbolbKZvIDic2rZAA1r887
	nbdKMvN8KBJgXHEuVkEPUSZIdaDjki6kRnIIGh2ZCDG2t99ycVgv7YbAKajSkA1scKGGpFGS5vP
	M9T5YA0OQe3BJQFW14gSy0LclUc/+GvakWBJv1HSXhqmTZQlEtMdtjB2JtUdZ5ClHWzAJGHo4GJ
	I8uOWUe8oxxppV7QGsikYrND4P45DGWMC4P0nYcHywUYGPSf7RN9Uw0ee59wz2xX6AvGBAsvqVs
	ZSC4SpLYZCjhk0voJn7d9VBjHM1bWMl8uo88PJpIC8FGsUslc=
X-Received: by 2002:a17:902:e806:b0:2c6:a078:bfb7 with SMTP id d9443c01a7336-2ccff8dc9a5mr327665ad.7.1783532538783;
        Wed, 08 Jul 2026 10:42:18 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b609acsm7268238b3a.1.2026.07.08.10.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:42:18 -0700 (PDT)
Date: Wed, 8 Jul 2026 17:42:12 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak6L9G-x72n2kY7B@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <178341290876.3292146.16538284698967245356.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178341290876.3292146.16538284698967245356.b4-review@b4>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F0F612000D
X-Stat-Signature: 3j4w8yeba9dasxq3iwdj69mxno531zob
X-Rspam-User: 
X-HE-Tag: 1783532540-537614
X-HE-Meta: U2FsdGVkX1+dL7JwVMsqNv7rh1ZuK/FZLN4LY3p6y7BFSZb63DjmYCEMr8ywgEtCl8uk15zuvltRIwGPB83Jl1fn+gNR9/TDNhHAWkT82+j/vh6tfz2/MKX8sQnnu4D3m/5qQ8zUhuzTmHwTHQi5ql7U8ybaiEAFfgMAjevP7VNoagqmNly/8CcLtblV8JQkmvwSSAaWs+wAvIghCwdufHLniM3oeQkzw9iPBarIjrp/RytebAw5MU9VxwYlbbANv8zGzcR6rS3089VU2Oi2PUtq5RypIkqKRF6+L5GyVEAsryB6pKaWVnYrwys7iLxhwlkqLaj9X9rV9lX6tx1Z9ud28QPlmSt8TesApfyWtim+xicAngg25FnuFhStjuvSRERzWgt/jLmre1VO+qyeeWyowH9SzUWMhKv541jvEdzN+LYYFiL1gFrVDLuJRB4Rm8DA/zwriDN6jyCdtHeo1cnTzpP23WF/ty63D03Kc5+2HOdSwP8v21c39M/caR2T53DxlEUSnFOl9uJ9XYC82S7L8mRtOv0YhWNuBYw4Xs65e3D/pxbBgRaSbIjdRbdrbfj2cG4t3VXc9B6zso/OQ+1m3xngAvM6DpwqFPreXWYvFP1hWjHuPqIfN1vRHLMfcnWGU1hsO/exRWbn2DJHnKjjIZIqx2gZUoy87lwqis2gTHmKVx471SAbYF7VC1zkCo1xUFxYDhrC0TxsyU+KcNhSnGSHl5BLe3MSYeuRDwJZm4eJA5tSrngKLt39JEK1YLqKfcTPMeeKM/vWC/2fXl08a/F3NRvlghGvJxyUSPjcK+xdavJu3HPPH1iXkBUlxaN9jb+/Yr3EHc2eufTWXrClVS11NmOHtS10SX8ErzjCQZqgqaGfHfS7vaV/4lW6AeqprEvrCWLdpVylBTzQAVEPZY2/G2gK4uljaNWZohpZ8hoHEBTQaysrwtaoKa7MMuM9Q0G1UZn7QTJW+5q
 LJ1MIrt0
 fP78a2rOJsNzXDRzLQA7d6/JQ/Wk6YRPrh8c138ehHHsLlM3tZtoUrY/Ez8Gb0qviGSaQ1KRE06KyKDAF6K7V/pgj8+NlUe6Npn0CRyJ1JWXy6/8uEMlwuTuwWXOTUXsi6YZwkNpFb7SwGsSBxfiWuukaRAYf22R/2gbgXwODi2YjK5w3d75n5FoKp2106FknuEH3R4BWonsYave0VY8kANeZ6TypdxHr66kGagTwDytUwmwx0JejYK7OiwNDkEwh1YMYA+QkpshVYm0UoW5JTa5GuTDUREK2xVBw7+rlxY2HoypFPLrWMU97hKipb2mGDcrfmSfgO/Y+h2yemEWMe7CuMY/HB1QSLQotbIFDPNwmi0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 11:28:28AM +0300, Mike Rapoport wrote:
> > This series is required for the ongoing effort to preserve DMA allocations
> > across KHO [1]. It addresses a fundamental mismatch between the current KHO
> > restoration logic and adds support for high-order buddy allocations.
> > 
> > The Problem
> > ===========
> > The current KHO restore implementation treats all multi-page blocks as
> > split pages during restoration, i.e. kho_restore_pages() initializes
> > every 4KB page with a refcount of 1.
> > 
> > However, many kernel subsystems, most notably the DMA allocator (via
> > dma_alloc_coherent), frequently return high-order non-compound pages.
> > In this unsplit state, only the head page carries a refcount of 1,
> > while all tail pages have a reference count of 0.
> > 
> > Consequently, when these contiguous but unsplit blocks are restored by
> > KHO in the new kernel, the forced refcount of 1 on tail pages causes some
> > trouble with the buddy allocator. Downstream of the eventual free path
> > the __free_pages_prepare() [2] ends up calling page_expected_state() [3]
> > when is_check_pages_enabled() returns true (only when CONFIG_DEBUG_VM or
> > debug_pagealloc=on).
> > 
> > This detects the non-zero refcounts on tail pages [4] and incorrectly
> > taints the kernel while leaking the pages in question.
> > 
> > Proposed Solution
> > =================
> > This series introduces a "Page Type" field to the KHO ABI to track the
> > refcount pattern of the preserved pages.
> > 
> > 1. KHO detects the physical state (CONTIG vs SPLIT) during preservation
> >    by peeking at the refcount of the second page in each buddy block.
> > 
> > 2. The type bit is preserved in the high bits of the KHO radix tree key
> >    (Bit 63) and stashed in page->private metadata during boot.
> 
> This brings a broader question - what is the best way to deal with page
> metadata. This particular case requires only a single bit and luckily we
> have a few spare high bits in the radix tree key. But what if going
> forward we'll need more than a few bits? Do we need a parallel data
> structure for the page metadata? Or something in kho_radix_leaf in
> addition to the bitmap?
> 
> I'm not saying that a generic solution for page metadata must be a part
> of this series, but we definitely need to consider and better sooner
> than later.

Ack. I agree that regarding page metadata, we are limited by the 
available bits in the Radix key (and as discussed with Pratysh on the 
other thread it increases the memory usage too). I guess we need more
complex metadata in the future, a parallel data structure or expanding
struct kho_radix_leaf to include a metadata array alongside the bitmap
should be better in the long-ter I guess?

> 
> > 3. kho_restore_page() applies the correct refcount pattern based on the
> >    preserved metadata.
> > 
> > 4. A new helper, kho_split_preserved_pages(), is provided for subsystems
> >    that may need to split memory after it has already been preserved.
> > 
> > Considerations
> > ==============
> > 
> > 1. A primary goal of this approach is to prevent driver/subsystem code
> >    from peeking into MM internals. Drivers should not need to understand
> >    the distinction between head/tail pages or compound metadata. The KHO
> >    core handles this internally.
> > 
> > 2. To handle rare cases where a caller might wish to split a high-order
> >    block after preservation, we provide kho_split_preserved_pages().
> 
> Do you have anything particular in mind?

Not really, I guess I was thinking of an edge case and attempted to
handle it this way. We could very well write this in the kdoc that the
caller who wants to do this must unpreserve first.

> 
> -- 
> Sincerely yours,
> Mike.
> 

Thanks,
Praan

