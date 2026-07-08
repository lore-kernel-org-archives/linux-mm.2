Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68578C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608B96B0005; Wed,  8 Jul 2026 13:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0F66B008A; Wed,  8 Jul 2026 13:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9CF6B008C; Wed,  8 Jul 2026 13:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 194A76B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:48:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D6971C7E43
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:48:38 +0000 (UTC)
X-FDA: 84966344316.09.5E811B0
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id D9E2C80003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:48:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="f/Ipllcy";
	spf=pass (imf30.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783532916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3n+7WeSImaE/4g038c1rdz4vAq6B0NjqEh02G408iWI=;
	b=gBc/S6wquXJ9KI8Nnzt92lJMmFvTPj4rzV5waJvm6DistCEpgLc9rNbUVpuSE7xiKEzg4/
	v1Ujh7s5zvi+35H1bFAJjjjTIOBOnpBVQXwX/3cnefbSpWF57ILXDscPjUKJCIhQ8Q5BZS
	R+Sng7tO5w1bWJ7p+BYLv2JUhPc1E1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783532916;
	b=Jf1sCfG9woqoHB6s0VnnxJ+6wfUqhWEmtaeO29dXRhXX4hcxYitTOzTeuZNUQ8E9q+f1Kh
	JKIPK1VPduedFVM2Ru6EUHKuPz7WMbQF2s5buM9fgKXr0Buy4h3NdUp848i2nxwY3DDG0T
	SVDWilbUwVbdJ1RaJwb/vghZ/q9w1nI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="f/Ipllcy";
	spf=pass (imf30.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ccdf36f63dso10465ad.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783532916; x=1784137716; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3n+7WeSImaE/4g038c1rdz4vAq6B0NjqEh02G408iWI=;
        b=f/IpllcyMXwIzrUSNLUwTl+e0LzwBvld7b/03O6g3bJkBV0Qa+VXoMPMH5FCQtQJpa
         H1U+zhFu0zz06EpkxCmxucMPWeVMTvjLR9iBQHctKTM9mU943sNvfcn4f23T0IodPOah
         UmSoMZm+t89NfTqgyTaWu3MbyZTytedqttUpn/e5sVZCtRl31JcBd/MSFCeO3qpCjMcH
         uxnoAEX8s4pqa15comSsUzI9TnE3ltwTnOixvevDdp95xSmAkR5khBLpn3O+DA5PMZ+q
         gf4YuqninYMfDY3K4YPmsgjtkqsToEz03615TZvFH83+CATUzQiyFqgQ3gZcK2Rjwtj/
         gAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783532916; x=1784137716;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3n+7WeSImaE/4g038c1rdz4vAq6B0NjqEh02G408iWI=;
        b=a1SJUSYeSd01Yuyk6Yr98ovc8Za4b1IB6/aD+9WaQgz5+ySUdTN4qGSlLv7c4LHiSq
         G/eFvp+Wimqk4mJejsH080FADNOqYDvg9Esip63mreKg+KGh19+zCo2oTotk18guIVhy
         P5gXX1H/Qp1aAoxkXNR2rBS9UzIpI8NHKeGZQN/eb2wuZcZQn4ukgNV7H1TqpJF8CdTv
         gSFn1K0BDGGGnJGvM2XqgfbT1KvMol/PAvEeNcY3Zwzi72Jwc5Vx+e5gTt3ZipHcuqDQ
         zP+KB1lQYSV2HRIfGqRDAcLJZYsbxzZXTSMyf950M2Z3eo1PfPgj1ZLs6hiLVgAGANkb
         URrg==
X-Forwarded-Encrypted: i=1; AHgh+RqMkxQo6ofoe8lK/WT8+k4YIFipckaPgjaj5araFkpLeLAIHkpY9+1BVpLrkEC80kzG2oXAGKFVtg==@kvack.org
X-Gm-Message-State: AOJu0YyQ8blh1yOu72lNxBFtS1gWyR16+cKEQ6O1339/v8eV7ny2MyNh
	JMBk/t3g43WGe6ajsk41IfH2TP1tI7LTPR4bVmrR/EBW/AUDFrKUh9pQvG8Xp6qlaw==
X-Gm-Gg: AfdE7ckGqTaFM2lZawpQLb1V5S67T4mAW13qu8we8NuX+uz01I9IMeBuozPRLBQjTva
	FNwPZP3ElnnINmyBqcjeL7zT43xEoQw2E4jiXXa/awQcFB+1kovlz0yiY1QFOhl+FkVOnTyX04Z
	9VmF2BBLxGqfw8INTqrP2Ybpj1QT4TqBI3ZrkYIzPBkoSU8RZDLQFNFK7UWA6/0Gc0jTXRZ2keI
	TnrzSxt/14e8oHKNXcYOBRLRSjtMtgLMEor5u7NkcUI5vpThf7uQnFhZtE2Q3Q50KJaw64PsHjj
	AwWjl3kiRgtKoOOl+0YY3vlqs1L2Fpky/USKT+fKj2LquYp6EJvHoIDTZ1nxmPyoYsUtydoWucl
	7km9DPZkwGi00MrY0dWQXO2O9yl0cJw/mQNGIzwX8X7XhYQe3uYkgyDz/qIbtWRxtMAfT0ef1YV
	XJqJPmOO920v4wzBmSgHAwXx1kL+GhoUi/NaooEn7r0zObvrk=
X-Received: by 2002:a17:903:120f:b0:2ca:cbe5:c3af with SMTP id d9443c01a7336-2ccff8db91fmr332755ad.7.1783532915006;
        Wed, 08 Jul 2026 10:48:35 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d3bcc0sm31299635ad.67.2026.07.08.10.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:48:34 -0700 (PDT)
Date: Wed, 8 Jul 2026 17:48:28 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak6NbMKnGRoj4YkA@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <2vxz7bn5mv0n.fsf@kernel.org>
 <ak6CxVty3O5Ib7q4@google.com>
 <2vxztsq9l6x7.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxztsq9l6x7.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D9E2C80003
X-Stat-Signature: n3bjer6cxf36fdkd9dpcybgyng8frbfg
X-HE-Tag: 1783532916-57349
X-HE-Meta: U2FsdGVkX197++mYSZSHtdowcp1rwGDUoaHeDz4mbGtdPWGRAyBLvs/wi9BmoFQY0rBamNrV7LKAKK0GC8TFTKJFbLrZ6zP2mcP1e/KFgCKnVlLLwKTiqs0qnRZgMwupakv/awFq4Uyx99C6KR9QvZJMWktmSQozhOx2vv6LyuCKFO2QhurzYdFaMb5meddAVYcnDjVSDzhPL+Xr04mHaCZOkbfLDWEDIsNssosLmbIMOciD29DQuEoIslbIPAJi6QmkezxwQcaZvileX/Av5PkN3NChoJlyu4ixE6MiRM9nQleFd5INCWbvYcJ9ycD1pwxwNId3+BLdMgEvts7cMQ02JyEpbADyxPiomr5nIOHurD5b8smqguUHHDlXUEoW8Ksy5SzZUZtj8siUSkfzqWYPeXMogxPx/m1YnCQuO/uLnqtvv98o2m6SS6rhC9iTZdpVRjlwBtb9qSgy5xRGJsZKiRiuFgfRKZQfRIvXjL86hK+JKJdrSvVpEztI1VxpsT44nO1rc7aTFzCBZLQkfFAfptiN8A2pIuV4IFd0/PowDN6qtTSAPgbnhopojNgAHTVv1Azh/occqv4XT/Qrc/rO6JzbUcny5MdC9MfLXaigXNyAvxpkx0xVeTFMgU0HFOn5IxeHRAQSJxeET6UGaGvdVljhzhI88kuX2T5O1qZNcAmgpLFe8ykHtp+6RVqSMeiBT7Ont9gjvOHVy7ivDYgiqORwI+HAaKUqekCyeuG7KjJFvdE1uNBpM0vGqeKyg4wDyYOqpwZfh8isOTAxyRsaF1GZIpUz2tktCpbu8+JtqN5xqpJRsjGn92GAxxc9cVoeTRQU6p6ZwHgH+WpEhPStIH+K9Fvczwapi/tcFflOkyjGH95SiXVSGuMZ9mFPAlnMwVQSDRFkKZ1GMkUI0EJhPjVHXWQlIrFH2qJ8eTX/IM7vQXD7pldhH1uGTc+B7V/jUfGWoqDpnx64wIn
 SktphwMh
 NpXYu8d8C5vCjMrda/efkc7Jp1i2dxwexC3XGK2nH1+T31OsmUMOuT1Ton43ZfhX/4DVAwIu8RfObXAY08SLg21ag9gj0P4LvDXF7jIMbkPyY0hglkfEAtUhT/2qHGCx0L7Hgz52zVJALBPQ/wKlRL3EMrT7BQuf+zX+8nzqupH2rGpN8o29BtKYpTeWhrFrgoQY4m4Le92V0/n4Uvdn6C4DpPLJSw0PvTOuqJ8zXEV5TgHseAWEVgdX3uveoGZDA5HfGf3UZYANfAnxdxXDS5eMDxCesk+lJpR8/7n2vpg3XIhVJRZ8CPFHMFDbL/x66hmOdCvieUfqWvJp9MPe3MqpPuyiMpqXX2ieq/7KDpPiPHwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 07:36:52PM +0200, Pratyush Yadav wrote:
> On Wed, Jul 08 2026, Pranjal Shrivastava wrote:
> 
> > On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
> >> On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
> >> 
> >> > This series is required for the ongoing effort to preserve DMA allocations
> >> > across KHO [1]. It addresses a fundamental mismatch between the current KHO
> >> > restoration logic and adds support for high-order buddy allocations.
> >> >
> >> > The Problem
> >> > ===========
> >> > The current KHO restore implementation treats all multi-page blocks as 
> >> > split pages during restoration, i.e. kho_restore_pages() initializes 
> >> > every 4KB page with a refcount of 1.
> >> >
> >> > However, many kernel subsystems, most notably the DMA allocator (via
> >> > dma_alloc_coherent), frequently return high-order non-compound pages. 
> >> > In this unsplit state, only the head page carries a refcount of 1, 
> >> > while all tail pages have a reference count of 0.
> >> >
> >> > Consequently, when these contiguous but unsplit blocks are restored by 
> >> > KHO in the new kernel, the forced refcount of 1 on tail pages causes some 
> >> > trouble with the buddy allocator. Downstream of the eventual free path
> >> > the __free_pages_prepare() [2] ends up calling page_expected_state() [3] 
> >> > when is_check_pages_enabled() returns true (only when CONFIG_DEBUG_VM or
> >> > debug_pagealloc=on).
> >> >
> >> > This detects the non-zero refcounts on tail pages [4] and incorrectly
> >> > taints the kernel while leaking the pages in question.
> [...]
> >> >
> >> > 4. A new helper, kho_split_preserved_pages(), is provided for subsystems
> >> >    that may need to split memory after it has already been preserved.
> >> 
> >> Umm, that sounds scary... Why do you need to do that? What's the use
> >> case? Why is the driver reconfiguring its memory after preservation? I
> >> assume these are DMA buffers, so why do they suddenly look different?
> >> 
> >> And in either case, why does KHO need to do the split? Why can't the
> >> driver unpreserve old preservation, then split the pages, and then
> >> preserve the new ones?
> >
> > Ack. I was trying to cover up an edge-case I guess but if we're simply
> > moving to an explicit restore API none on this would be needed.
> 
> Even with an explicit restore API, I'd say it would be a bad idea to
> preserve using one API and restore using another. The driver really
> should be unpreserving and represerving. And even that if it really has
> to.

Ack, I'll add a new pair of preserve/unpreserve APIs for this and
mention it in the kdoc that the driver is responsible for handling
splitting preserved pages by unpreserving & represerving.

> 
> -- 
> Regards,
> Pratyush Yadav

Thanks
Praan

