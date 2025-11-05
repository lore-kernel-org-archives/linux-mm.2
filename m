Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49162CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 13:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75E28E000E; Wed,  5 Nov 2025 08:34:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D9A8E0003; Wed,  5 Nov 2025 08:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9637C8E000E; Wed,  5 Nov 2025 08:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 850468E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:34:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 467C788436
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:34:22 +0000 (UTC)
X-FDA: 84076647564.28.A59668B
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 928C11C0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:34:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NpEe2J34;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762349660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sv/JzecOhMA8cZ94wcVGV+A+peoLF8ip0q5xsIEB14k=;
	b=0l0Bp4MzokTunnQ/yqrsd/QHYv2QO1w2djieE06ryXT3JjHCyDrWnd6bEYGTQ4uGIFwIyC
	BsgkrCBQJTL5bTikSES0mAhQ+Kan5Pi60cN7HxwAoDwHKu6exMT9r0+TITbpWJikpzLxTz
	SX3BlLKGRZetb8atgy0wTPzPGBya2Gg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762349660; a=rsa-sha256;
	cv=none;
	b=ToN5pw315t2F6Y/Pu3nwB98xHrAulGMeaHohf45IsD+AbSS5ze9jddorwFf4xuPK8OLQVK
	x+Z0oYvOhO7NBznxL8N4lUQurj5Y5gUjR23QSOQr0RZyVzcnL1O31ZiV86Id4CP/WEilim
	j9Y2PoN3Wog1DapLyDoRV4soMVVhgl4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NpEe2J34;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-656a67c0762so844710eaf.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 05:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762349659; x=1762954459; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sv/JzecOhMA8cZ94wcVGV+A+peoLF8ip0q5xsIEB14k=;
        b=NpEe2J34ohh9CdMKJT6ZZcuWJeQghuwv4c5NU+0ns4pvC+Z3/YOj0dIrVzT/vgSynl
         RFFGaRl3N9dFsBPa66cLo/0Le+KSuNVZTO0gdJiGLuF+JOivmvMVkumXYU3WFbssZ7oT
         yHpSW3VeFdLY/8Jztja5TRut+vZfePvOlVv5ooDf7YbUOh5Xfd21mE4Lf4RKuq0tgZku
         OHqpJDiwDAMXyBgCDqyfnL/3zNjiicqsflz9UNGxjmdQW+WY0wWynn3xYwwDdyyxBSX7
         +0ege2KBjpHvksOpxL413rswvoCftaM6jH6H1s4FRsv+q4L9SpiTRdbA8I4x1nHZ8N3H
         CkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762349659; x=1762954459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sv/JzecOhMA8cZ94wcVGV+A+peoLF8ip0q5xsIEB14k=;
        b=jK7fdpoJPunxRl28HK9K3rBTH7wgcogVR6g8C1QKKPvXVQgvqZT6tV88NrYi1+ZDLk
         PWbm+FKKHDXIEpfFDsZMoE/qhkIRUKWmcEGaGmH4gmNWU7mU8lnmCCEnDwhVeImFhTWT
         weEI9iycRBheZ3R+W3woLXuj0AulxSkz8Od2ss4WFF5noKadrYKNQcKsL18uvO1VFl+M
         baCVyFCZl1vXeyeqevGIkpZ4rLCpiHxGwkRmt+ih3ae/OdjKEbRaV4Zcza5RgPvIBGg/
         9jj1jVgLHqKXT6Jxam3Suc0HQz04T/DnQmMvAQp5d4QCcGpaAlrOa++/alWTmJnBaqf3
         C/Qw==
X-Forwarded-Encrypted: i=1; AJvYcCWMNzYhyNHS3V8Yd6zJJ+7EvHWGDRlH3hCUzCB9qno8YUzuI1vRQYznpaAWOzQqvBE7muuYL60xeg==@kvack.org
X-Gm-Message-State: AOJu0Yzz/vC0YT1vcOIrpXkB/LtFc/wj1YKV3iEDV3wCT4XfZkbx8pht
	mP0IqTeprj+7hD+OaL6kqgRpW27uKn3nOJaTpQpTFHIPncU5aN2rQMgd
X-Gm-Gg: ASbGnctmViDXgz3l6HNmWpeqXXTGo7pQLG+JNFtzMFgqJkdlMIb/0K4hWKzlHQdvZya
	J7LFX0NYjzbh++JTlIX4EHKFt1rrDILNtqNJdShfQY88+QpLacwxIARNx6IGCcQ/P8ZPxhj7KU7
	II3YuIUUpeMR6X0qlmyNab2f5suW8uWWI8HEw2+WObjy5G+UZIQj9o1vOjMJMNj9RwOFkxxFm8m
	YO8dT021NTrAkar8tlmjq/LTxWpabMPoEpEDYEZQemQI9VkaSOVML8luI4gGdPjTCMhkk3kukZI
	Sa3eMC/jpAkquLyPVMlZqySUqCxwG4dp3tmrLtuMDM0LOMtHvijT+ULWN/1yRXEZCjZ9VzWF9GH
	tUWoCOVn7jxGGTVem/Oyin1hAK3XS25TQ4KYhXzBGxK5AfOQ2CXJh9U/X7Ge2yrNRgCW2wNn1I/
	7dNY2x/fAbP5x+q3ZXEL1tHrNCpeODzmxN25HF6ymd3kI5sBjzBgB5wg==
X-Google-Smtp-Source: AGHT+IE8z6TNiU3ePk48BI+doqg/bH4NTxWdTXISMyBVQ21lhT2P1M3hdipDnXRTCcDABOBcmXjW8w==
X-Received: by 2002:a05:6871:878a:b0:3c9:7e9b:632b with SMTP id 586e51a60fabf-3e19af07bc3mr1381694fac.30.1762349659507;
        Wed, 05 Nov 2025 05:34:19 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2 ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3dff46fa5afsm2245210fac.5.2025.11.05.05.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 05:34:19 -0800 (PST)
Date: Wed, 5 Nov 2025 10:32:23 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ksm: perform a range-walk in break_ksm
Message-ID: <ff4jfxphz32fackvh2236an7575zhqnwntrx5ledudb4afu2ag@sk4vigyq5jif>
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
 <20251031174625.127417-3-pedrodemargomes@gmail.com>
 <cd632ad0-c73e-4e6d-872b-2f4dad285e9d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd632ad0-c73e-4e6d-872b-2f4dad285e9d@kernel.org>
X-Stat-Signature: 98msjzeqztr4mywsjmo5m51m78wrtfbs
X-Rspam-User: 
X-Rspamd-Queue-Id: 928C11C0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762349660-549814
X-HE-Meta: U2FsdGVkX1/pVgs3GULPksIeuaj6kbUPnDHrQfUPMOLLewELU3uDoTk8jy82CeMDLC5e91fwM0pPQlzC09XGBklImJ661fHjXiRM/thBpCgi19NxIT7ua18jHBCCoASBbprCt+6g26fjU1tYzfkEoNYSE3P2rnX+zhED8nFA7pltsdevstuEs/KbSwF+deP7wqoVo367t+nizUM0fRxWfQ9y2n3zSNsryT79gW3Tv4yiq3UYVORqut9YW8GEeaFEF5Pbkw9D7JwlWLmOHLLxEmW4bw0s7X7wzfi3mF+AvLMT8Wt8U3MXws2KSuQqFs8hJDqS0G82WJ/z4QIn7zA7CgCtunRhFNmn2fapsv/WqBYYwPcT6aHw6SCISlFG/CJOqMMaR9tzYp0r5IhEmJlIa9mLwGYOOYi1SS9ObH3QSSkWWvFakjVy4w1gIiw+iI4YavbgBVB3iv57j3K4ThMiKHzYSkzn1RUmhKp0V08unj5s6SatxIY/xq/rW1tZQzq4STQDYjH40eh2cTXTzZQrb9yLILndDgugUkIbk7ui16Q3Ne5hPS9lEpLL8RnGJGdRdqVmP6e9J8koaACGo9irWdxO9aECJL2OSgYuFcYV0rHtgTtw8UCbcQsTYxVPMXc/N64vM0IkNhFodRIRSdeYuVEu5w8uli/38402s/Fpa0ld4ydJal9MA44UYrIVkSBVDBMtX7Ot3agZ4BVYfswygcLvdHjvwCO+LjV7RFYU9HzjApKtPAf+9sTN0dK4+Jh4dl6HGRdIqEyT3+bhV5dPzcE4nxFe4Nr6CbQqecyTOMsyM4bISzEixqOf5qR+sY0FYZbVPQ0a5dTX0xEHyG2K9DsXDgMAxKVAt8NVwAeUSrNuF8CjYmWKILYaRvFTif8kiZcSNeArq3CTZ4BjZtlZy+xCD2KwVNb5tzpkMGW1jRriacqzEWkJmnrolM+sRcp4cb5bbdk/VQ1xyX4AF3X
 6+HZxAYp
 sWnAwmULRPLAxjIrVpzucgHi23fDN2+OW1v6oPlYFQkH50fPAltVVRD37MQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 06:06:26PM +0100, David Hildenbrand (Red Hat) wrote:
> On 31.10.25 18:46, Pedro Demarchi Gomes wrote:
> > Make break_ksm() receive an address range and change
> > break_ksm_pmd_entry() to perform a range-walk and return the address of
> > the first ksm page found.
> > 
> > This change allows break_ksm() to skip unmapped regions instead of
> > iterating every page address. When unmerging large sparse VMAs, this
> > significantly reduces runtime.
> > 
> > In a benchmark unmerging a 32 TiB sparse virtual address space where
> > only one page was populated, the runtime dropped from 9 minutes to less
> > then 5 seconds.
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> > ---
> >   mm/ksm.c | 88 ++++++++++++++++++++++++++++++--------------------------
> >   1 file changed, 48 insertions(+), 40 deletions(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 922d2936e206..64d66699133d 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -607,35 +607,55 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
> >   	return atomic_read(&mm->mm_users) == 0;
> >   }
> > -static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> > +struct break_ksm_arg {
> > +	unsigned long addr;
> > +};
> 
> Leftover? :)
> 

Yes, I am sorry.
I will remove it in the v3.

> > +
> > +static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >   			struct mm_walk *walk)
> >   {
> > -	struct folio *folio = NULL;
> > +	unsigned long *found_addr = (unsigned long *) walk->private;
> > +	struct mm_struct *mm = walk->mm;
> > +	pte_t *start_ptep, *ptep;
> >   	spinlock_t *ptl;
> > -	pte_t *pte;
> > -	pte_t ptent;
> > -	int ret;
> > +	int found = 0;
> 
> Best to perform the ret -> found rename already in patch #1.
>

Ok

> With both things
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks!

> -- 
> Cheers
> 
> David
> 

