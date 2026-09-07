Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85BDAC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18DA6B009F; Mon,  7 Sep 2026 05:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C98C6B00A0; Mon,  7 Sep 2026 05:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0546B00A1; Mon,  7 Sep 2026 05:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 688626B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:52:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 079951A06D5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:52:51 +0000 (UTC)
X-FDA: 85186502142.27.F2DD957
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4CAD4160002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:52:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PRHc5Tzk;
	spf=pass (imf08.hostedemail.com: domain of vdonnefort@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788774769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqgfejYSVwSnwDj4+nn08kyPi4IgtneNSDWgXEMZ2iw=;
	b=h5O8asnu7y0KeMyV5wR6VzvvOh7oDjzlzAhSmS/vecg7gFEa63USnECTG2/7lZR/UQ2aLC
	EmiqYxcNpCDbHUmIK1gscFI86DGy7NyJuybMf21F6gbfntZc8UqXV7DpT1PPEQ1B5NmhQL
	qLfkicwrC96PARaqh1Y2A6e+NBtoSJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788774769;
	b=FwW0lVfn3cKfjTxazhiYr6qP3m8ix07wnz8MeJSw52G9Qbx3VtRPkn1hdeKtyBPKz6SEui
	70MKAfMNh5zzVQtesutNsOg2SCIGHkSBgPr7bLeBhLD4pp2E1Mb9CEUJt1vAGN+1Y1Gzqr
	LK4uC4ZFy4uIAwTcbNtJ9oKNGeO29II=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PRHc5Tzk;
	spf=pass (imf08.hostedemail.com: domain of vdonnefort@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-482dd6ee390so3813103f8f.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 02:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788774768; x=1789379568; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kqgfejYSVwSnwDj4+nn08kyPi4IgtneNSDWgXEMZ2iw=;
        b=PRHc5Tzk2I84Q2nH9EWUVvcd3lqJz8BI9mYcVT7TZW+ed+42h9ADy4IT4rfG/NpZ8u
         GJZ6F/PiG79sV4MG2ZVAn6P6IA/01mNLbfksL0qmI36FGEwpaMTz+ZfrdaKqCx1+8GsP
         0jnsVsFxOpP/5fOWRi2EfjitR9oqN0zKZ/2U/Tl9sGPCSvdoreynMu+6UCdyGv3A/mwd
         rxQmPaR4Xord3UvX0GdU1fIyADywVhT6gUNo5VQzOHLUwjHXk1d5eLDB8fzuMZkzL1DH
         7z6oX0ZjGNEI4Fa76lrQqScmw2lbgGGfrG2Tnary5JN6c8ZAlgbkHK8P5/5k8j0NiZ5d
         lMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774768; x=1789379568;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kqgfejYSVwSnwDj4+nn08kyPi4IgtneNSDWgXEMZ2iw=;
        b=ZbRrlYzEg7pD8rwSIondXbgAlkSHdmytjaL89MU3yS7hOsmmGkna+taAAASRXYdaGS
         xYXXF7MpNhCOZlMWcZ6ZktiBla/ByWVEMvHUcnSMXVbS1G6H0D/uczLy8H8kclhqZmJs
         YIIz2q0sMNA4xQI+H2S0aeUsVY8oD9IYDXw8Up13zf0wcMFvwpt/Z0BfvAmGzgyXJzU/
         G+f2IUOtuXbmXZbpb4ID3tuHXtxWEvq3ol3Y/+ZwCzRgeJcj6XpDotpexehe9Uy5hWUh
         8kTFd4VhKe0eX1YU1DMUKTwTegX8OLVCISjkpI1+kxoawTO3tU35V6VjcgXcFl92DR5f
         kZNA==
X-Forwarded-Encrypted: i=1; AKwUvBwW/rAUe84yu0lCoD4WvktJGSRHS7m6+Bixfudmbhem+stpu1tnBiIzG4PjiOknUzuK2jUmHqzz1A==@kvack.org
X-Gm-Message-State: AFuF++nD5CRk7h9c42U4wJdoJmWVdOCorHVU25i6jEWpoc+chgRLHket
	IVu+wTkZGI+D5/CsUpcvxbstXZ8alecKkNSGHIM7+CFyJRvUurBYy3FBIg2TYUgumg==
X-Gm-Gg: AYBFou1fEP3e8sn44Mk4+NBMg1zzN1/HQnxPOtjR7qkS7tBiPuCbHfMych1tcHcc1yO
	GZJuYooqWijaemJzaUVpMBE/wI4hofs8+JcWmDMX0vR21cN6AxcJtTDCsgKL7JqMWbeCEKsIcRK
	jj+DMCoZhxyYLLYZbyBhoV9hVhXvd4zcMBt0KBYNZjDNv4KTL7j2rgoODuHbReUnAmQTYu30/T8
	bmItef+IgGbZs5xKFsHtTxQU0trUPNBknPKilXBv8pDnhI0rwzK8atPFS9Ddyppwpy9qjy1SdkE
	4JvaiNRPUMb8KzrRu/3FVAhoF60m9s6Pq1I7mtPzCUOjAtpQ0zsMhPQUWJxN1zhLxlGTGHurp7i
	XN3JqtbJ78eJ38op8vM03ntA6G9G4bloMmoNqNhGYClLdO/PORzgTUeslFg8P/EtQFp/+xNOODt
	/RPDd26FyrSO07Dcn/KY0pfKl4qeGSbvUITY/gTkdYnMGDzqZyrN7kpEpfHrDqeKVoikM1S9B/D
	Vxn/jQpCSpQgmAheJsTWtflY37ub3oy
X-Received: by 2002:a05:6000:4b1d:b0:485:8c16:a32a with SMTP id ffacd0b85a97d-4858c16a5a7mr19950748f8f.31.1788774767486;
        Mon, 07 Sep 2026 02:52:47 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885bf3f0sm30012615f8f.33.2026.09.07.02.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:52:46 -0700 (PDT)
Date: Mon, 7 Sep 2026 10:52:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 03/10] set_memory.h: Introduce
 can_set_direct_map_range()
Message-ID: <ap6Ja02S5IDqWRHC@google.com>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-4-vdonnefort@google.com>
 <ap3BVr5hHwA499gu@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap3BVr5hHwA499gu@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4CAD4160002
X-Stat-Signature: szbt7shbdz8p917urtxpha9x5zs9mcdf
X-HE-Tag: 1788774769-47009
X-HE-Meta: U2FsdGVkX19BgFyivK9wytwViC3UJ2nKG2oS7pXbWrhSGmMNNFtEwIVl8hX8+4+ECnpHBiAs/YZQR45G1zS4aXr6vIxCBUoTOjjnLVHMDe7v3sTDKZwV7X5vrALHw8xkOmqOkT0spcTpPQeBLFXnkqvml23LQ6oAb7IFV2REBPpzknIjAHJd59gs1l/4Fg+BZOiRHmrbgR7UyvknaWLK1MWLGSaVWD8zE/5BmIwRWcRNFMpuwUfwHV7vsK4IDMdTvqcJuKhrLg6UPs6QTJiZY0VbfDclKySf/YyADDKZ8YL/gLNsRoE/kwLNU4NMo0N7Z04qPVO9Iqoj9N5/TEk+p+B9hfIXp5JbJGc1Hph5oxJ/zdXSqfCNsTFjarvjKlbv1gR+MYyrK0IWd9iZ4w/+rFh8WQHpm9U21ZOwEk2O2A1rhLnc+AfmTCq18YjQ9wu9GtDQ+bZYFMtLiaNejX9BNr7zlugSYnyJnbRDdqClRpn68vto9dgSh1LXiYCqYVVHDTHBWybxM+aDDl8NRmTtgmY2yPIaP+VgsKXkn9OcG0il9mvyZ/AXwwY+iKXfyfAw3NTNA5VHwApcfxyJvO3piJFSe0RSZYaKDmoPtZVUJ2kVIPXMwHUGeXQCHeRXsAXIp9OZvD3XKvIOqBFAwmU0RyPAdPCXOjTGa68joZXtVCTG2DhymF3m0NL0gnuNpdA8twP6UnD93NiWQ2Ychi8lB6VaYVbvaqa3bTXivUuPkTmpjfECfBxtpaB3i3jFAhHgOpLSq9HSG8Xwpx5r/yM7oxCJi5XbBZP4i4oe32Mn79mqMTpDJeNyKMQCsKnw11GleeVy9osDgg7dRLUPE/bo8ZCCBI4sR3sLYgGg1BRdAtGq0zC3trbhreGcUfSDRIihKDEoJAcFHR7BvinHilINXuao5dsN7+tC4ycQr3A1owgls2+rzm47BQptS1FBOHEzBmJDctZfcA9Spq5AS2E
 5CEmuACN
 KQB+Yifwdz3uWECh+vLSrikusu/kKfcmjs1VpeSwaL2dKuDvZqcLV8XlCNzh5FzCXXNKLF6DgwkbpjiZmXEJkQw+4cgVCwFwVY0CLz16HNRYzzDoEqlVkmsPZEEkYfvGX9nO4KHUyQxAEEmLXyiumUARz8pPeZ1QA9Mcg7bj0oFri72mz0WCRRmYIxyECZmT6Q5eU30D825KOSeiANqAOGtKH7BhsQSP6L6Er7ajvr4V6NRDlI2lMbakkLOWrgQmeSaSaWWFaU8Kn7csEFCs4ySG2BMPSwhVHrawhjSHhyAYR6d6JJhYo8au5pgDEar+NB8Qm9jrp7k8ysqvaG8EwJt3y02AAtiBwcJ1tzbKOigwpkmBfF6zkuSJXN56o7EN69M+NAWjtbfr6+Q3TAvJXbqiqOlUovMvgGmrsMhTRGgSADBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 10:39:02PM +0300, Mike Rapoport wrote:
> On Wed, Sep 02, 2026 at 11:47:05AM +0100, Vincent Donnefort wrote:
> > While can_set_direct_map() tells whether the direct map can be modified
> > globally, can_set_direct_map_range() checks if a specific range can be
> > modified. e.g. if mapped at PTE-level.
> 
> set_direct_map are going to have number of pages parameter soon:
> 
> https://lore.kernel.org/all/20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org
> 
> so this check can be a part of arm64::set_direct_map

ack.

> 
> I wouldn't expose can_set_direct_map_range() as a public API and rely on
> the callers to "Do The Right Thing".

ack.

Thanks for having a look at the series.

-- 
Vincent


>   
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> > index 3030d9245f5a..88175c3fa751 100644
> > --- a/include/linux/set_memory.h
> > +++ b/include/linux/set_memory.h
> > @@ -44,6 +44,12 @@ static inline bool kernel_page_present(struct page *page)
> >  {
> >  	return true;
> >  }
> > +
> > +static inline bool can_set_direct_map_range(struct page *page,
> > +					    unsigned long nr_pages)
> > +{
> > +	return false;
> > +}
> >  #else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> >  /*
> >   * Some architectures, e.g. ARM64 can disable direct map modifications at
> > @@ -56,6 +62,14 @@ static inline bool can_set_direct_map(void)
> >  }
> >  #define can_set_direct_map can_set_direct_map
> >  #endif
> > +
> > +#ifndef can_set_direct_map_range
> > +static inline bool can_set_direct_map_range(struct page *page, unsigned long nr_pages)
> > +{
> > +	return can_set_direct_map();
> > +}
> > +#define can_set_direct_map_range can_set_direct_map_range
> > +#endif
> >  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> >  
> >  #ifdef CONFIG_X86_64
> > -- 
> > 2.55.0.970.g62bdec98f9-goog
> > 
> 
> -- 
> Sincerely yours,
> Mike.

