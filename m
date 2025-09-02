Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05DEECA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF808E0003; Tue,  2 Sep 2025 09:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5888E0002; Tue,  2 Sep 2025 09:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502168E0003; Tue,  2 Sep 2025 09:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FAB58E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:28:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0924140173
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:28:07 +0000 (UTC)
X-FDA: 83844388614.22.3302007
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8E67180014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:28:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CRUnRk+h;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756819686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2r/mpeKTSsbIAfnQRXWi3fdzeWa6D7xfutpiWD5Rhs=;
	b=tBPRNbvVTxMS9iXRmfXng8LNW4bdVpk06TF+appFDFL5qvAQCoNzfk1Lc/ASkcNRYQcCL3
	B33NlZlbGMoG3UheFFrV/0C4juBeZZyFDGKb/LBJUGi34LdaJLXIjgCur3L5go2NVsG43y
	uVS/Mlj6jiiTPV5f8DtCfhRnStMXtTk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CRUnRk+h;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756819686; a=rsa-sha256;
	cv=none;
	b=YO2hR9tQCaVWr6NqIWjJThQlgGsPC8u5shclJDc5BczjOigOdmQrL1wxjDy/j7pkVHCqsg
	ML4rR8mDtQzhbSVBWdswi/AFBT2E1Dw1rRAANcc07JIjjPx9mWrjvqv0dL/fMSgLVEWP/n
	JZnBhBgrnuOgseDCbCoy/Rix3t4lkZQ=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61e930b27bcso2883731a12.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819684; x=1757424484; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2r/mpeKTSsbIAfnQRXWi3fdzeWa6D7xfutpiWD5Rhs=;
        b=CRUnRk+hrWoeu6PtiIiJHStuASEbQX79ydkHh1zaNX+s7ZrKECYaUrZ3erko85OI0E
         sbQZBqYppIOnDVGtMEhtx5Pf4Z04orX3lcR9MbBdw0ItlB0+kngn3w9IVxpQnfvgMEGf
         Wuuui+re/cdMa7vSQ3cpHCakZRRsnvVn3zYMoL9DNmwqV/bbAma0nm/ybilsTorr3USn
         jSCfUsaLmNEXapFY2aSVMDaV5QFPT7PtfrXH2dgtN+EKLkCd5z55nAx5VF04uHcwEnXf
         VpLIeVowA/8w7Q7IzCtkxuZ7LmB01CnhJ1aRAe2f2rbYcoAO88yBp4Jl589qrrucSWZP
         0f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819684; x=1757424484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2r/mpeKTSsbIAfnQRXWi3fdzeWa6D7xfutpiWD5Rhs=;
        b=MnAnPhX1gMatu9jgkZpEFq3C2NY6nghHkJYZRPxNriGeUNOcl11BjRZ1NEhf9xz6qA
         xkk/4796tKGgTRAGie4qoWbRiQsiYvhvTiIDH6zE564LV3ZGgTVplkPOi8BxN4WMvXgN
         nSe45qSnj6ZW9I2l0TSoRLlB5AvbpXE9pBLUnoJspPTdkCKS+uj/nEkrO9wFCsWo7D2O
         mmyMm6O8h48nh4uRvaFJhlmbh1JoYn+3dmf/V8yP0Qvf8kfufD4H/SqRJSMKxBYQl0yg
         Viwqth8rifYeDb6sK3DBdZPWEBX9xbhB+VUltiIFl4u865AkQ87uTprv35hsWFFfWkpu
         zNlA==
X-Forwarded-Encrypted: i=1; AJvYcCXNHlm6GtHJPQ4XKS4hr+LRCEnU3kDWLsCVABaZ9VLxUjTpVJgOqhTG+BEV2BfgjEIeA3n03nAjmA==@kvack.org
X-Gm-Message-State: AOJu0YwHx9uq1Ch9lX7Pd/VjZ8zfcflPyhAULksX34DOYTXtAbaqRRFw
	LZKU4Mnna/yvdEqcwpevd+jo4NErl7jysRH1T2wNGohQ0QWtYt9hO41u4P1u8YQBCAqHqgPRNf8
	6UpX5UC8rNr1pbqgihIuAHc7OAOKNs/E=
X-Gm-Gg: ASbGnctWztmBCnie1R1vhuSMM8iATAHyLKAyH3OhGWypQWwVk1qe93V/ESM6qHcRFMb
	D3VqbRdT3KyjqpjwLL/wSAyEEvmvywLbBbm4LcIDHbrdTeEuP7ZAwhG1e56LgfbrgoKWyFzxZwn
	aLDDizctOo/wMLk5C3ewDMdJuW9pHXLtI4uIoFI3a9eBFndlYy2DYs9lM4RFPpdz7hLUB59eT8F
	CiUXqa6IWMJp1XKYWaYHg==
X-Google-Smtp-Source: AGHT+IG8WM3LN3n+vs8UfaZfhyKrh9NOM79dhQApSdhBW99EaIXb2eKvjvaDXdwBWeu8xJOM+PNHoMyKJvxujvcsD7k=
X-Received: by 2002:a05:6402:3589:b0:61e:9307:702b with SMTP id
 4fb4d7f45d1cf-61e93077153mr7144821a12.9.1756819683920; Tue, 02 Sep 2025
 06:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <911dc3b4-c511-4ef2-a159-091780987965@redhat.com> <CACePvbXs3J6qYWFycVW8rGjiaOw9iTFLdWq1Lq4HyaDkSY45uA@mail.gmail.com>
In-Reply-To: <CACePvbXs3J6qYWFycVW8rGjiaOw9iTFLdWq1Lq4HyaDkSY45uA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Sep 2025 21:27:27 +0800
X-Gm-Features: Ac12FXyXH_eAyWYE5C0gX0GODJQwF_Wg6FYFg7CcBoXlApyBiT4JHidtNY6X7ho
Message-ID: <CAMgjq7BPUE_+AhF_Nm98k6hbVPpLkQcwPGGMqA3yZuKmMR6xZw@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D8E67180014
X-Rspam-User: 
X-Stat-Signature: uux6sxef5afdu1r9agzf1sdxi19ddrym
X-Rspamd-Server: rspam09
X-HE-Tag: 1756819685-107943
X-HE-Meta: U2FsdGVkX1/DEKNe93QZIg+M9gDM/C4GUmYQGrqMo4yrJf4/3c4T7rEFf45I6QaBaaEpcm/ATN42SCe4u8mbw+GgWExYXb7aHIrbvjl+nKT6r5TKRFiowhrfDVV1wdaRY8Upp0izYEJiQ/UbRp+w5k2V08QXDZPz9fMBcVXaglCuluZrb6DMzKFm3sGimqiK62uhW9YvCurv99bFicvteYw3VF76NNxRJ2MxWhGnlXD+vouxs2+O209NwhzR8yC7hP7sXLnILfcDzZsKxdbSRcUmaUVjqqwvJOLc0viUNLu+XQWkWBWOtH+2T9+B/d7Xdt8DUQHzkZPvynlkaSceCtYVySqQ55CAaXDqb9ReYFLooctMD+d/GcPTZmD0sk1Uh5i1ISoo6E/SyGLhI5N7o9cdC2BdoafUvm4C6JsaCHEfDQkLRvVIv3YIsJb0xG9Fd3gYvu/BxC6TftNkSh2WhZ8JsR07kKdHdHFYwSBEwlQyaK7mI3OGNzKvNRkOQ7Xqbrxtv32l5r/Ww88p8eWmsQ2bjoi2x4PUYH0O6gm8BP3GFetQAz2ewb64ll46oCpKnS6MGm4PE4BfWbP7+PkSrwPHewQHMpwXptbz4hdrd4BR96aEwbqSogApHrWdy4hqnx4SupGLF/Z5Fki+Ml2zsmCjU4ZkC11Mf7slSGorE1v2CmPdOO93ddPmbgR7z49GZ4ZBKAPrXCv7P42NYNS0/vm/COOZXE2by3rWPEBjPfvCfn+pYG0iIcpcdhz1THfhkurP/Tjx29ndRB+WroLcJ536hyLmIwd4vQTMlAzlI+Hi5rnUUUVUmFOamiVlfbMNxgnWUDaPRAfizUR3WScAnBbe1pq0vQWGIIgDcwn+GlWRUFovNuwCCX1QyMJ/3mdP0BdXfyKAtyR7h/E4oBzZOJ39vCfzZM6qSfmU4oCJzIHy6eKwnQrYJKNYpY1tNgStkErw46mQPo1yMHui/of
 tOVUT1Xv
 ALRTNTUGm7adu5DjlhCFwxRyE17hAKcjDbTjjlx2H91S9DmrJX1tR+ns6TpYItlMCQuPstqtSSOgTCMlCBprVBKgp9ytT2wtmXeM4mjDBPrqDllTLwWVCOyYhFPoVRJK4jrFFCvzFxPcPXvgZxxRARBGprAOvCF2SFp37AwA7ZsfmPR2c/IfeV49IKDOAm7RKSs8QbLkjpTzCw33BWkq4V00PX+7gK6aYmcwDuuhVnlPOFmk0/TRuxsHSI3qRP3hMtc7T+fZT/wvn8YDY/rQQM5Oaxht2TuA3Md2rpUA5FBvMn+wfxl64f+r0qlIcmZ1+4WqtMEo8xmYklGD5TWwvdsbPeyoq9ERRVrywhP/OZz1nQvXD038OP2+PpB1b1uaj4pvl2hLa7TYSRgBm51TdathraWJID0aXUB+cL761tMusr6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 9:03=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 2, 2025 at 3:18=E2=80=AFAM David Hildenbrand <david@redhat.co=
m> wrote:
> >
> > On 22.08.25 21:20, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Swap cache lookup is lockless, it only increases the reference count
> > > of the returned folio. That's not enough to ensure a folio is stable =
in
> > > the swap cache, so the folio could be removed from the swap cache at =
any
> > > time. The caller always has to lock and check the folio before use.
> > >
> > > Document this as a comment, and introduce a helper for swap cache fol=
io
> > > verification with proper sanity checks.
> > >
> > > Also, sanitize all current users to use this convention, and use the =
new
> > > helper when possible for easier debugging. Some existing callers won'=
t
> > > cause any major problem right now, only trivial issues like incorrect
> > > readahead statistic (swapin) or wasted loop (swapoff). It's better to
> > > always follow this convention to make things robust.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> >
> > [...]
> >
> > > +/**
> > > + * folio_contains_swap - Does this folio contain this swap entry?
> > > + * @folio: The folio.
> > > + * @entry: The swap entry to check against.
> > > + *
> > > + * Swap version of folio_contains()
> > > + *
> > > + * Context: The caller should have the folio locked to ensure
> > > + * nothing will move it out of the swap cache.
> > > + * Return: true or false.
> > > + */
> >
> > I appreciate the kerneldoc.
> >
> > Intuitively, this should be called "..._swap_entry".
> >
> > But I wonder if "contains" is really the right term to use here. It's
> > more like that a swap entry "belongs to" (was assigned to) a folio, rig=
ht?
>
> Right, in the other design doc I use the word "binding" for the
> relationship between folio and swap entry. As if it is a binding
> contract, your folio data goes and only goes here. There is no owning
> relationship. Other folios might want to compete and win over the
> binding contract as well (the race in swap in).
>
> > Sure, we store the information in the folio, but the "contains" is a bi=
t
> > weird.
> >
> > folio_matches_swp_entry() maybe?
>
> Yes, I like the name folio_match_swap_entry() you suggested in the
> other email as well.

I like this name too. The `folio_contains_swap` name comes from
`folio_contains` as it's just like a swap version of it. But I also
found the name a bit strange as they are different things, but had no
better idea. Thanks for the suggestion.

>
> Chris
>

