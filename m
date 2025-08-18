Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3FACA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9736A8E0026; Mon, 18 Aug 2025 12:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B078E000F; Mon, 18 Aug 2025 12:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860798E0026; Mon, 18 Aug 2025 12:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9A38E000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:07:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 300E1117B3D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:07:32 +0000 (UTC)
X-FDA: 83790358344.09.7D3CB2D
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5D9581C0002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:07:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=HhrNmbyG;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.167.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755533250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6ek7I0iyYbZpN/v0UC5zzd0o0Ftoqgt1vFlNzowpm0=;
	b=oCARIcuhNkh69VfAM83s+cYTiV51mnLaWvMhQQlmSBAb6skbGZyUYREQqntk4B4fJ0PIeH
	uZ4Fm9k9F8CHPwo76maYJgi4TVK5JxVRLIzb49VxJoAgp3z52WGhZyGZrASqp8UI5sntrr
	cku9+RjnppUDQ55jrNTAc6aM2Umc/MI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=HhrNmbyG;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.167.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755533250; a=rsa-sha256;
	cv=none;
	b=hJ/vGQpAMo4W6plKI5ouoRiK7WcBMRA8/0SuPQjJsl2Ptv6qE08uiKRn2EHmzxV/rys5K7
	5wQbbG+9pF52zzp0r1LVydoryLDSGucP4v6VcvAHXwPcedBKx2/VRdOEvaQGox9V711HoA
	F6tLRX4g5E20zsVQf9YpQMJMljtn+84=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-435de818a74so2377540b6e.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1755533249; x=1756138049; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D6ek7I0iyYbZpN/v0UC5zzd0o0Ftoqgt1vFlNzowpm0=;
        b=HhrNmbyGv+kra8zSQCzOyo5UfTkJLV9qTe3PYZwF8J9UI9y4SSgoNw3N4U3EYnQYv5
         wIP0EYxtaRaIMGwg/WzkLJgW7CkONuyrzoVVSxNStLiriKSP7mhm5i5+6JgmCB7QHv3L
         TFJF1abULcGdG0qgDTAFqgacuihWQF7nQTs1b9EddEWP/KOcLafrblc6ukqW2LtfrAgd
         f1LIFisDW9Ux6MPeGg4i3g2eYK8whgVHSHi1mjusOF6sddhNKgzup+kAOG8a5n37yUo1
         1yqf/thZtgUC7RTMmMsdwG4KWQQh0mQ927Td7MKYxDEwaf79br3uf/UsE4P+zqoJNTC8
         R0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755533249; x=1756138049;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D6ek7I0iyYbZpN/v0UC5zzd0o0Ftoqgt1vFlNzowpm0=;
        b=bnsO0jB55/bukL8md/NcO+Nfs/Xcb/HDfY0qgDPK8IEMPRp5ETCLq93iWuTzhFnwSW
         kydjjkmyHLneJNT9wm33lzV0xuO4QQx9hOensuzWc9QaSh5S/WAuZ3SgI07Mo/f8AQba
         /y+lbC8Kp7dQZfC/xOyGR5BWnAVoBeJ2ucWUn0ZaUPKaoRs8rCWjUoJi9jRcGUN/VT0t
         Jk+9sF5UNdjrNPgeSFPW2vLLUIRpXPMIqESr2n0/CXV60QnHn2JEmE1tTCbyCm07mtjU
         FZ13FZzhGOR1NeDOhY/Xf4nSrD+mDhqwed3V+wgTf9yt/zgvf9lXW/k3IQBo+czP81HG
         i79Q==
X-Forwarded-Encrypted: i=1; AJvYcCVqsNUHl0QOZch2jZuispNh1mvBRVEgmi0ApP1/Hlvh44n5kpUY92/AYheSnI5svdaHzzjd/jY8xA==@kvack.org
X-Gm-Message-State: AOJu0YyTtuqdYh5+Mf4L5tjmmor6KmMVBRprMkzTQ1ZWce13AzzxKFDl
	Hrl1lMTe0CX7gHhUPhXobMJyp0KM9VAHmW34K+g/EhBNKZ8zm4+Poz6Rx7q/oiPsaa0=
X-Gm-Gg: ASbGncs3SFnYgkNI2x48kFyJvT4E4st9mY80ETNsnbQeXEfklJ68UdDNhTI8MtuCn2E
	i18uf1OfV5rCqkKGBs4UKwtVkq35ZCFIHrOAXWrpWcNIrc3vTpBTc9Bb05eir7F5JKKurgKf2EX
	wukzC3t3TMC9IP+euVlaPMRTN58HL8+mOeR0ubzjBkptriKRJ/2UAYmnI/3hgv7nihvsdClnNmw
	G342sAK1Sms81C4ghytJpObrE3SxjWOPc7ASA0lWMiHODZrx/62CDG/WthxbyahUMGa9mWmdzjc
	c1Ra896RK+IuGWISaE14Owdr/9XlhGOBCBs8s/OsrWkya3NMNZ49J4bazMWR/zkZvJ4JXlJ+
X-Google-Smtp-Source: AGHT+IHkRfCegHArKlwGfaPyx0kzz53A2FyhdpjpMnPcsXRnYC7i/30cf6RRe0zz3Qa6ICjSFo5brQ==
X-Received: by 2002:a05:6808:3a07:b0:435:8506:2263 with SMTP id 5614622812f47-435ec487ee3mr6478173b6e.24.1755533249123;
        Mon, 18 Aug 2025 09:07:29 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-435ed1b10bfsm1783361b6e.18.2025.08.18.09.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 09:07:27 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uo2OM-00000004Orw-2igd;
	Mon, 18 Aug 2025 13:07:26 -0300
Date: Mon, 18 Aug 2025 13:07:26 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
Message-ID: <20250818160726.GH599331@ziepe.ca>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
X-Stat-Signature: 9csjfmt73haqd5fg4schtq56ncx83et1
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D9581C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755533250-283292
X-HE-Meta: U2FsdGVkX18Ai6Vj3Odh2terOidgwhCdOshHRMLg448LfSRdyaoZkejTQ5X6u1UzEj8wdlp1J/By5gFXjMfpm0t3UqBeXCrvXgluER1kNrAHGcFCGNf38wt9QRBbQzQhfl+iHwp7eoaUA//3NMKhdFBPRUcMPRZWNqXlmiBahqEjQJFOGnnA+GtGk+izErhsI97PkkKxa3Le+qeJE3V1tP129KeavHvq861+jDtL+GvNqLXlF/mioiFf/bRQoHlSe7QTsq5czD/5U2tSFrYZ7dNs2RMjBCT3tSMaofCIn9muYaTzPX+AXGyjPez33wubrXIdcHgke49EQyY7B2c9Ybb1fRaNY+ypHfJHo50v2MG/QVD+LC2d844Tv4IcZ0KeFGAbrf4THpJ6nqNXqOu8uS39wx8VNkTYdUyNPDl5IjzzZA6xO3tAmuigD10FXrOasn2RKyqNmCEKS97/pilar4gsXc8RoArgpF3rGMbtocJxr0VI74N/nnI+9RJ5iiNnesR0YyzLHCIQdQFas+WJN6V0YOO4G7olzLiJmOqsvmwVzC6dnORpxEfAGWLdur9hdorpuHGaVG6Xn/ZboOskz2iGsxVO3SiKpgn79x/7jjvQ3ojjX+Jjg2pOO8T1lUY4VNF/j4updckVNL6/I0gmX02u3jkW/VWvVx5UFgjyBjtUaXHQXWrQVZrUPmDNSJgSIoUZiXFYvwcRrfGGUw8ZLn8F/uQOgMY53Bo6ugmVcx2MwVOEDaTe5eKQD+6PaMnbQ8Lg1li2oG3pRCsR04sOmZuLwzqGMz19Cw+lwXSOrCyLzUkAjfO0dm1ZtRr2iVmlMTdV9snfjfRBYjmYZEXdS7DUZJvSYL5LvqG+sd09hh51fGxLyXEZdCzafSLSWvKt0j502Xr8vAbrdlfZ0h92iOtV86WbszMJnYfMDw4zUuehaAEfV+uUOEITAK1/CWSO5dydnuOSFm47dLOR4Ax
 Irn5Ko0e
 /hZiNI6b+Q/KXt2IinKjxBrCw7x3hBfXjn45o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 09, 2025 at 03:51:32PM +0200, Thomas Hellström wrote:
> GPU use-cases for mmu_interval_notifiers with hmm often involve
> starting a gpu operation and then waiting for it to complete.
> These operations are typically context preemption or TLB flushing.
> 
> With single-pass notifiers per GPU this doesn't scale in
> multi-gpu scenarios. In those scenarios we'd want to first start
> preemption- or TLB flushing on all GPUs and as a second pass wait
> for them to complete on all gpus.

The idea seems reasonable but I'm not sure I like the naming of
'multipass' or necessarily the complexity.

This is sort of a co-operative multithreading thing.

Do you really need a linked list here? At least justify the design
choices in the commit message..

> +struct mmu_interval_notifier_pass {
> +	struct list_head link;
> +	/**
> +	 * @pass: Driver callback for additionall pass.
> +	 * @additional_pass: Pointer to the mmu_interval_notifier_pass structure.
> +	 * @range: The mmu_notifier_range.
> +	 * @cur_seq: The current sequence set by the first pass.
> +	 *
> +	 * Return: Either a pointer to a valid mmu_interval_notifier_pass for
> +	 * another pass to be called, or %NULL if processing is complete for this
> +	 * notifier. There is no error reporting mechanism for additional passes.
> +	 */
> +	struct mmu_interval_notifier_pass *
> +	(*pass) (struct mmu_interval_notifier_pass *additional_pass,
> +		 const struct mmu_notifier_range *range,
> +		 unsigned long cur_seq);
> +};
> +
>  /**
>   * struct mmu_interval_notifier_ops
>   * @invalidate: Upon return the caller must stop using any SPTEs within this
> @@ -243,6 +269,10 @@ struct mmu_interval_notifier_ops {
>  	bool (*invalidate)(struct mmu_interval_notifier *interval_sub,
>  			   const struct mmu_notifier_range *range,
>  			   unsigned long cur_seq);
> +	bool (*invalidate_multipass)(struct mmu_interval_notifier *interval_sub,
> +				     const struct mmu_notifier_range *range,
> +				     unsigned long cur_seq,
> +				     struct mmu_interval_notifier_pass **pass);

Couldn't this just have a pass number counter and some return code to
indicate this notifier is done?

Or do you really need more than 2 passes? Start/finish make sense
too. Otherwise you may have issues overlapping the backgroundable
operations between different driver types?

> +static void mn_itree_additional_passes(struct list_head *additional_passes,
> +				       const struct mmu_notifier_range *range,
> +				       unsigned long cur_seq)
> +{
> +	struct mmu_interval_notifier_pass *p, *next;
> +
> +	while (!list_empty(additional_passes)) {
> +		list_for_each_entry_safe(p, next, additional_passes, link) {
> +			list_del_init(&p->link);
> +			p = p->pass(p, range, cur_seq);
> +			if (p)
> +				list_add_tail(&p->link, additional_passes);
> +		}
> +	}

Like this is very naive, if one driver has only 'prepare' and 'wait
for device ack' passes, then it will immediately stop being concurrent
while another device may be still working on its 3rd pass.

So either this should be more complicated to properly support
different numbers of passes per registration or we should just support
two passes and be done with it?

Jason

