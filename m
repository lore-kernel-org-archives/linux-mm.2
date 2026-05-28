Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B088CCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E636B009E; Thu, 28 May 2026 17:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156B06B00A0; Thu, 28 May 2026 17:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045906B00A1; Thu, 28 May 2026 17:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5BAB6B009E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:30:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE18A12047E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:30:33 +0000 (UTC)
X-FDA: 84818122746.07.4F79913
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id B9D7540019
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:30:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IL4c+iai;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780003831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpHrgIeXXcvDfmuKsXXjHhEfFrUsBGF9Cp2mPrCFg1E=;
	b=7DJmkJRWQpcdfiQ3a6p7k9YstFJ6XwqwBRBMud0r8bRV/ZUT7GA3v0/lRUwhnUac1Fbl00
	gMKwZO48xJShJ5syGJfd8MpTq/lVAZVtL/xzckHDsMFIkvw7V5K8z6t7dtsNQbJmnzxJMi
	BFQmRE4X3Ah+xWXlt1WQ0wuTaQERN2s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IL4c+iai;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780003831; a=rsa-sha256;
	cv=none;
	b=PbnIfpm1fmIiOwrm0etgVoIuwbQQP6ufh5kCJcyKzkum8dhdBisR47W0xfQeidbeirWrJg
	cg+vPaB5t8SUDIwKRUzTMToH5Hg7fKGsFWF3rZk9oz7YqGY5NfVhB8dhz2FyMkoqABg0a2
	CvmYcJY/K5xegz8iHBPHqq0V/6LSr4U=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e6128bd9b3so3486315a34.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 14:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780003831; x=1780608631; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wpHrgIeXXcvDfmuKsXXjHhEfFrUsBGF9Cp2mPrCFg1E=;
        b=IL4c+iai+xyIPELRMEER9OsdvHckIvu4TucL8U8Zz/8uSehI/Lgn3fHOeo4X2wNynv
         l6aGDoqcITBG4ria0FqZ/WzGKDxI2sUKdQj/86+MqXHhMV3njAgZ/pcp4gXhYgh1pFv7
         ciRhpohHVF8begn3WREI18nMlX2MeMgPPMRlrveROwmng3MQpWDxPTx+hr/OjX44i5Iy
         KsZZeAja3CvbfQn65Oaic4kTjYIofnvcF9Lc5OTOHUwfzVOsd3mHqe49IvVlfTqY/Bf/
         K6pD2vAkMm1F5JN58YMJ8EnBS6+2cG40RtBPMCCbJdJalW7OyRsnzbprwueut6lVqdBG
         E3Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780003831; x=1780608631;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wpHrgIeXXcvDfmuKsXXjHhEfFrUsBGF9Cp2mPrCFg1E=;
        b=RePhyVC11XxWGve7/2Vy6wpC2ZeOkb0DDQh/3Zh46rVy2kY2tiENPUIGLMWF45WXMG
         rryW3nYUa6XPcjhaaOsGAGT9VvcfB7z/9cnPfyI4LOJgvEyhaoZtYGiJ2hjEZCQKMpkb
         1odYRJxaaDBLWOVZvDr8w0NY0Weng5aju7vHoBeQhWxcHnV8QLEuRCc12sgRyQLJjHhr
         CGrkgis//seyv+aRTltVog3wxmPhGjOBVJNrnQ11L3+XMv4trQ9rUbFdf4R9kRdXb6/L
         eY9v5glRURzTDEr125ydEp8RKUX6ISqtuXBPaiA0rsIyuqa8DpDoVK75DQrHxu15AGI0
         tBIw==
X-Forwarded-Encrypted: i=1; AFNElJ933EPLORrmUzzBlZdXDLZJnUl8dBkkG70ig+xwvW5Nw/hehlHOw2mjgmUL3A9MQdEWS8e7V5B6eA==@kvack.org
X-Gm-Message-State: AOJu0Yxkew1Vil9rVsXXza9qTFcCstWSUol7fTiM63EXsV8wIhmQGUqh
	uiPJw0PLgHyZ92Z1QFXcRTV9nqt5DIghOktcYLM05spukbk3Go6iGClg
X-Gm-Gg: Acq92OFdLLt7hphXtF7ISCKxX4oFEIhSveOZfOpmiHht4p7mSAyGzpD1DX/3HfzPa5h
	kDLA3aNA9/jPs5UkfWMl1aQDBJEQV2BzmC1MPKoX6f4ErsJ00N8rCvjWmqiZkpxv6U6ZkvFdxPk
	vBCr0YIbxoroMYVTV8gv46GssfuVj3UM1j+pv3oA6KOTZvgBCI5+ECdLf8BD0Z6C+p+FcBylufi
	/XFgb7dHWk/cvogSGpS1J4yVa4qg0N3BPGWVVO6rAHTfmUGQJBRQerR6qAWJcwOix2dvoMd0OhX
	aT1LQKC/KeFKX5HzFAgOrAcYnfQ1sxG0mRA55cuYdzwN7AvKxiATd2BoRnke+lFykPQ1aAt/Bem
	udO8cRo4V5UNnt2mmdynk2cqtwqABYO7XJdMYO/LvBM3YEhyK0yVyvZiyfdX3KfdKuX7A1QFuKV
	3LSKByyoJatv37b1udPK93DHGad4dKbHRogvR1ryADPJydO+iYo69MYvY8u6Z7afgU35IpFwH62
	4kzpNK1JX1qgEzlbsc0PcVRkzKS
X-Received: by 2002:a05:6830:81e9:b0:7d7:570b:6800 with SMTP id 46e09a7af769-7e694e30aa5mr218271a34.23.1780003830565;
        Thu, 28 May 2026 14:30:30 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:47::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695212f9asm129362a34.13.2026.05.28.14.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 14:30:30 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 May 2026 14:30:28 -0700
Message-Id: <DIUMP21RASZI.2VNQV45RIL209@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Tejun Heo"
 <tj@kernel.org>, "David Vernet" <void@manifault.com>, "Andrea Righi"
 <arighi@nvidia.com>, "Changwoo Min" <changwoo@igalia.com>, "Alexei
 Starovoitov" <ast@kernel.org>, "Andrii Nakryiko" <andrii@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>,
 <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>, <x86@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
X-Mailer: aerc
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-3-tj@kernel.org>
 <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org>
In-Reply-To: <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org>
X-Stat-Signature: fous1a3o5e3ysfxruneak3yw6wqg61gq
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B9D7540019
X-Rspam-User: 
X-HE-Tag: 1780003831-472361
X-HE-Meta: U2FsdGVkX1/f8w1u0bjmJGWqsqFZdwa9gnPOQAeVmXNY0p5NDA4TPbpvDlP8Ph0PM9+5xJ50QVavLLJUiWGAhk9I/yxJ/S3hLkkdgYZp89fYw7HCh06g8KZWgI5CtUHZ/0My2Ao6RuoXZfv/3NwrVwSK6UCICCaurPFF03N1RTOq9M557PrDMLaiEK1u7j53ZRZu8kGdAFG8j23YJE/9cbsjfuJ49ybGe22UigrEj2Ga/3N8CyiQqryLue9T8JKWUVlYouEqEla0HVBL7a77CxDZxQSOebSW8erp2crR1BvrYFcar13lDKxGIG5Z3cwZcPTQiPigg/MvmPqV6ztCU3asOYVAX+1CVxVD3f9Uf13dAw9NTnRIEFtj94uGAEXSgo9jfRCK0uUBlII/vBUgZk7Gl/Gq/xReK31rFeYlUWm4eh31Fu4my36MEGBJgafVaeQFbjV/4kmRiKHw+XFCt0AkH1/qnysBalCHCBdObctGP9FYYTxHtUh4Unb/l1V7M31bP/Gct5+WASOWF3NcGa7+kSlA8ANXlWssRhMLhG/3jHZyRtl7oYGFlDm+ryYuacD/XtoDsAamLPqgVnfhMT8ZdWf9yk5fI2krn8AatVCwoeVN6HexiXUX+Y/uT/BB7SE/UsAHLvExNDLPrZa0JHoP+KsHCKKzoHz3i+tzhwJga7oN5eJC2eS50opjIqzKnBnBcEyPVugFgUUIIu7qe+S5cgq8HxpL1x2qeYW3CZvEH3G+SonPUZr01mdoMlyTrtrin+aPD4TrfE85kUFHwTdDrHGnJXYcLznj/dLECeirNf1BHasifV2eRWnzluSUfU2/314z0ffl2JC3DhA2+N8KRZmEE/ype/hINR6TSD4zWeDK3yedDmV8xhD8rToRIn78xTAAYgiuhQg9M4wRkAapK6uXOtTMo4ppcL9v2Ea3VMROYCUT+fNzhyFST0pnmRY6WmT/TYF0VV6DNi5
 MokV9yeo
 KwUVPYcKzMGHHd2eNUSXEV3bxckYIOKqlIADx5UdxLR0TCE7ADfNlKybABQI8G6taRzLgvSE4EzQFuSz/NRQ0iSqs4y+N48yXMU7Lrks78z3XF4/MWjEsGi2m7VQ3AXjfpUYP1opLo2eRnUmX9ib0uzqOrt2SfCnmmFko4YERsNpfmLtF4EgX0WHilPYDr23TWoIwx9V5vnqRZqJcBPCwQLtnZuVsBTfL24F9soXibTr1hB3ugY1T5KdtdAnN8TNsCPoYTqKYVm2jAOrRh0stgx9EQwS1wtl4676dMSGvPonB9cTUSO3Xnq68U6lDheSflnHLS+/zLTfIeRQy/90i+/QKN+HuPz28KrIurjcspDPhv94Aq+Kh623XSmEu/BcDt7tu44LL9fcdisT6BwyBWTscNGIZBLT6jb+eCBDBtRNFfzwiLvpk+kVW9zinTc3HegPU3k2EH8dapRSRwZ70ai+xUzV//1ru5fAqBtqCEgTH2Q8u031KB+WmdLgmAfKy8ZPybRD/lKwWBLnXQMpdEKQtyP5ddTeKy/H28hOLLx5w6n22e1QVs+gNCJ7cT0Km7/ofmVJq/Jn6g0L4JChAsM3Gbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue May 26, 2026 at 5:45 AM PDT, David Hildenbrand (Arm) wrote:
>
> There is still the chance that apply_range_set_cb() could race with scrat=
ch
> insertion, right?

yes, it can race, but the fix is to remove only:

-       /* sanity check */
-       if (unlikely(!pte_none(ptep_get(pte))))
-               return -EBUSY;

It was sanity check, now it's simply in the way.
It should do set_pte_at() unconditionally.
It's totally fine to set it to proper page instead of scratch or empty.

Tejun,
do you mind sending a patch to remove these 3 lines or should I do it?

Changing topic. re: zap_vma_range() issue.
It's not forgotten, just complicated, since we can't just take
mmap_read_lock under arena->lock, since arena_vm_close()=20
is called with mmap_write_lock held and it takes arena->lock.
Will figure something out.

> Shouldn't we also be using ptep_try_set() there?
>
> The nasty thing is handling whether ptep_try_set() actually works.
>
> Something like the following on top, maybe?
>
>
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 49a8f7b1beef5..086bea3f3698e 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -122,19 +122,27 @@ static int apply_range_set_cb(pte_t *pte, unsigned =
long
> addr, void *data)
>  {
>         struct apply_range_data *d =3D data;
>         struct page *page;
> +       pte_t pteval;
>
>         if (!data)
>                 return 0;
> -       /* sanity check */
> -       if (unlikely(!pte_none(ptep_get(pte))))
> -               return -EBUSY;
>
>         page =3D d->pages[d->i];
>         /* paranoia, similar to vmap_pages_pte_range() */
>         if (WARN_ON_ONCE(!pfn_valid(page_to_pfn(page))))
>                 return -EINVAL;
>
> -       set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
> +       pteval =3D mk_pte(page, PAGE_KERNEL);
> +#ifdef ptep_try_set
> +       if (unlikely(!ptep_try_set(pte, pteval)))
> +               return -EBUSY;
> +#else
> +       if (unlikely(!pte_none(ptep_get(pte))))
> +               return -EBUSY;
> +
> +       set_pte_at(&init_mm, addr, pte, pteval);
> +#endif
>         d->i++;
>         return 0;
>  }


