Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43FE7CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5DD6B00EB; Thu, 18 Jun 2026 20:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297396B00EC; Thu, 18 Jun 2026 20:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF576B00ED; Thu, 18 Jun 2026 20:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D75CD6B00EB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:40:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54248402E3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:40:24 +0000 (UTC)
X-FDA: 84894805968.27.1FB7C79
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C0691C0008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:40:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="MLPkf/RP";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of stevensd@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=stevensd@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XzeBq/piCL+a8zs1wRjqsckZIBcIJTPXTpFURgzSDQ=;
	b=SKcw9yDcWavqCdhPn2tsI1HudvTV/u97uGkLO9BUZ+Vsw+Cle/4+3+Lby2fMRUnOUVdIkB
	nY3AkRRZInwWJhASCE/viWzMJJcgP4hOSdNFBe534l8+i1apIiH5zQATCnU5p7MWMMjjOA
	yK8raTlEr/iM9Gtl1+DPZ/o4LsU+bvs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781829622;
	b=O2AhIHKy01BEbeqe+HqEQMl2K27vE0BFGzcFTxNkquBNo8U/DwKBr1KwtHwg0H8k5XuBzm
	4Xj3e8c//FzVtq/CT2ygkddDEgH649DYjPTntEDTz7wVvQNFLzSPjcfk7o+vu1nHjgECoB
	H2E/t7A1/uDcH97M+Q5ncUZTH4I7d3w=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="MLPkf/RP";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of stevensd@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=stevensd@google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-695a3842230so5965a12.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:40:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781829621; cv=none;
        d=google.com; s=arc-20260327;
        b=B6J2S/EFgrtMiZunXDQRehkfQxrm2cLtnvtXTp4hJPnEikPKjvxKd2wc1iu4DtuMsC
         G8qPkZ7kMJNXHB4+mRIgWcFhd33qanGFDtAH84s/orLGy7zGBMHDMqvPXg/rG3igKWxv
         8zJ8jrn6/8Fvh0s12z9IBofQa4GIVz/9kcP4jwdT6nVyqo/+aAtAB6I9E8LVSBxby3lw
         W4vz8sj6Eeb9PVjT56V1vF6XMC9PvKgl6IzMChTmme3N8g8aksT8JzQ6o8fsVY8lSoUA
         3yTHLSGEfqUtFDS13KcmzNUuwlHDFDu5pro4SmkTvJ+uOPelg/p9i2jOTWtup7ZMUZX9
         mvYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4XzeBq/piCL+a8zs1wRjqsckZIBcIJTPXTpFURgzSDQ=;
        fh=vxtlF7ymhBqLjmS3BTmLdiJJYJoWQpSDBic+VNdD7Pc=;
        b=WG7dg2wFjTQWNQj0Xdc8N4fnKJIfe/fBCJupktC6uhHkkgo/zYy3U/jZssb9kfvyfb
         DZax6uUdzFL8WFUm/SlkHqMglU4EhIoWqlWomkkcQBzHNjmph6G90Vur46shZObEq+El
         kEZwa8jGul27res8DDi+yPvBVENcVU99sIzTAf5hdg3gcz+yvKtl12SlKG5/AMDwFonB
         L7JLLKKO0m+aw7CBWg2heddi4cFfy2L/05fCNKR6n8AJMOy2AcSkacOvtMZIMrWEVIp7
         Jedgs2mDInYSfoL9qEs7Ud9tFYfy1MaAigEzl5Oj3Ms7tB0rfgm7YmvwYXqvzkxQH8kr
         03cg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781829621; x=1782434421; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4XzeBq/piCL+a8zs1wRjqsckZIBcIJTPXTpFURgzSDQ=;
        b=MLPkf/RPYIcBhqh3OOwMB5TJYwxtZF+Rib70Dsb/hZRaLkE4zEgncAtB5/kJ7rbuyj
         LpOPZH8x7poQkYMB1/ZU4F0wPk0UiRohpBee1dckmAimuo0e/mqx4r6wcsgaKZnBNhTp
         mOxfUcjr5h6tyODKXpuqOtdVPI5lo2jUUagWlBISYapjWUSkK3uIM/Jvnyo3T37epnay
         fgvl/WvM35jyWmv3iFsotgAuWLLiChpRWNumpcM4j2gJzsg77teF8JlijDHtPDf22Twi
         m9DS4Uien42prZxuudD5ZddoCp6RBRAqSNCFMPEbNVusdjDj8fjgdvPpz5djZA7I7Nvc
         VqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781829621; x=1782434421;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4XzeBq/piCL+a8zs1wRjqsckZIBcIJTPXTpFURgzSDQ=;
        b=bFB0jtc/LUVlf7nV0H7AQasmMAvykh11qTfFnRM3o0icTvpZwiyrT85ovnCbhJMQKL
         uIGAqIK6gVTD9MjpQKaSu1SoRMxB1gFmvBcCiRzTq3VTyGE3sKXTHX0ej53uwMxQY4Kr
         1DECZOzh8t1PYXlbKU32u1P8HAJnyGYSOebjGu12cO9OMFEn7eqgGgAjZu8lVfnn0Hx2
         sewfSdtPXUNfpYVZ7VVvZFYq36e+dbe7QAK8Jc5Vzhm4EMP8RUO+rwTfGBGcE+6FeFI5
         ZhmMKYSnPBmJfvl27iuVBhtI4jlVLAYvMvB54aE2QBfx38noVx79qfp5jFtyyLrnb74h
         4kQA==
X-Forwarded-Encrypted: i=1; AFNElJ/UJXezPUHb54s4pVoh5mKCKYuBquYYfajsqYKZ2IuzhonVYU3hR317S1RpJkSJ24Hg6hpHMGZ+/w==@kvack.org
X-Gm-Message-State: AOJu0YwvPO6WT16q7pDT/k4v8ea3Zfbm9w6pxztDn3CaPYX95PI2Pl/1
	O2JmVT0XHyfExnwhHK862ZLQBgSk6NAEWArPSmWMnxaLBRrn6XwPnbcDslZhka9Ghn+6Y/GHinW
	nRM/axwrlDLBuEgK++E4GLPrZIE6d61Qn+BQJ2O2R
X-Gm-Gg: AfdE7cnoptxhgDXm1HS25l7iuiGUP4Z9/u33limb4r6tVMfakt2BNOAYLsMoFhJ1q1A
	2QAVU9iu4ha3uyunCqw9daj+KhK83FczdMxExluNoXgwcL0QqldHLUQ0N6yQpAwWTprwlTdSjeg
	a5MRueYt+gaSDrdREjJl8/IedxgGyrUExIllBBCripKCVDaAfylm54Oz2g6burMIab0fyvAHW+6
	fYxTtfQmstAV0d6WKTPcrs0+BcqvlOqZPi2swyOuGj96YRH+mAAWx8GDErOIKXs/Rkg3FzkU5UG
	qRkIdIbRyeAt181QWfyPIiqaXvQ=
X-Received: by 2002:a05:6402:5342:10b0:68f:d45f:e495 with SMTP id
 4fb4d7f45d1cf-69721814916mr19675a12.12.1781829620070; Thu, 18 Jun 2026
 17:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <c96b9621-16f8-41c2-869e-7310adfe75b6@zytor.com>
In-Reply-To: <c96b9621-16f8-41c2-869e-7310adfe75b6@zytor.com>
From: David Stevens <stevensd@google.com>
Date: Thu, 18 Jun 2026 17:40:07 -0700
X-Gm-Features: AVVi8CeQcX0dkCfTrnawvyEYgQyE3sWjDBpkVIMnyGzkz7zQ2F6P05ZFVgt4FTU
Message-ID: <CAOiLmNF+e1Vuw8HJc6kwcNgee8Qi8h+Dv695O4TWmHKYsKez9w@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "Zach O'Keefe" <zokeefe@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4C0691C0008
X-Stat-Signature: 6qf15834mntio1injw3oyytgz98qjww6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781829622-745369
X-HE-Meta: U2FsdGVkX19+GofyerUs6H/qgGz1ynYSCjZg8Cdk3AWqKs4SWADSeYkuio5oJrH+OseInfuZkpZ6vabFRzEaLA7+psZQPQYU62ZYQnpf8xOiSj7r1uIWEvPgmCczj0/aqGEQ/mL+yAMYs7fCrtiCc2u6J9iG6FO5C/eQ1imRWlwlfcCeYX0aVnuqjdPNVWlzbhW+v6cv0tS2uijkUIaA4K0+dFv2MnINIiJM/KUFXVdgl2W+cZYDTbHeSUE/EelAVKrkNo1uh1p9To8YW6TZxwzoWyUrEjaghU/qF+rcs4CqB9Vx0bQhiHyOdAdaut6noubysfUQzXz6B/p5fQv0fpaHeibQdF7FF37B8ZacrRcPkQ7qCrUFPNGXxK9Y6w+sArQxMlM/baNAR4HiIHfgY1S/3ufP6LuXSmg9urk+xOhHnPahxA7a5C3vyfpo4GcQd/G7027c7hLoG8RtvNpJHew+Wtp9kKKs4uqo2bodMtaHnB/BrifOnDiKb2urdr2JxUhsjJU49raOIz6MziYrpwt3wd0ueR6E86aFrJddu65mIsbTNh8acaNx9heGE9vT/eDm3A7fh1OZCu18ch2c8pbbFr/DwVMiioZBschnQDbXFOky1QkQBvJYheOiQ0gj3TwIV88UIq9a1rLyjsJEXfeFWskG+71ESoyeRejmpqr+yIL+69esG6DbCTbQC1lSG6LoQyJsYWprGiEJ54zRZ3IBvzsNG0oAtmSo3zUUQrPHwnK2SnDNagbooWWhPMVa3L1rVgILV/7l7o+rOF7XNQZEMmC0+dJAR/wdrzR3FXUTHoPwH+r/XRz86gJAJVfeVtVh5GDLAY0Z/DanFt4zfPGTJJiNCDuhq6ziYeh0znVGbSXFgoZ/0ir+eThPIjFHxO/cHX3mVmtBT/zT2sGTdytjH/uAwz2vyPP+7jLKTCwQrsZEBr7PAZnlebXMrKBuW+QYrQKNa+rSpmTWmo/
 ciDymkgt
 jRyoxIMC2Oe5CI2hKHnkd5Er782PAr97N7FpbIjrLEnhZvMxCjllO0HEEv3HhbN8WK29cPTjrP31jkThOdpBggX/j6OAMfP89t4t31AEIkueHvpGXEPmCPsmfNvduEoT6qLB55W0pTBlw41BsNvjEBGsvho3FIev8+E7ZzyACgBBeNUdMgewRn2GOwgED8Ao7Qsp6aH+73zxJSexp6u0dqPpJPtsSNkLp7JpOet5b/Pm6u5L8JovmOKWNqePY7/ZQOvejTZQ6zfviuYbU0IQF/r0gA7rO5rG2YOPllcWkAl+EmCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 3:28=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> On 2026-06-18 11:53, Dave Hansen wrote:
> > On 6/18/26 07:50, Zach O'Keefe wrote:
> >> Overall, are there any particular painpoints you'd like to see flushed
> >> out, first?
> >
> > Handing exceptions in the kernel is hard. Period. That's the pain point=
.
> > Just look at NMIs, #VC, #MC and the rest of that mess. Just look at how
> > we've moved away from ever taking random page faults in the kernel. Or,
> > heck, randomly taking faults at *all*. We've concentrated them in very
> > specific places, not in general code.
> >
> > Now you're arguing that the kernel can pretty much take a fault *AND*
> > allocate memory reliably at any point*.
> >
> > I just don't see the collateral in this series to justify that claim.
> >
>
> That is most definitely the zeroth-order thing. Extraordinary claims requ=
ire
> extraordinary evidence, and this is certainly an extraordinary claim.

I do acknowledge that there is currently a lack of evidence - this is
an RFC after all. The question is whether it is possible in principle
to produce sufficient evidence. From the Android side of Google, we
are willing to carry the RFC patches downstream for a while to build a
case for merging them upstream. However, there needs to be at least a
possibility of success before we undertake that work. If upstream's
position is that dynamic stacks are no good, full stop, and will
absolutely never happen, then there's no point in us trying to pursue
this avenue further. And I assume those from the datacenter side of
the company are in a similar position.

-David


> In addition to the *massive* maintainability issue, you also have to cons=
ider the
> additional overheads you will now have to deal with in order to avoid dea=
dlocks.
>
> Almost every OS that have attempted to swap out kernel stacks have been k=
nown
> to suffer from deadlocks under very high memory load.
>
>
> > The NMI entry code is a disaster because NMIs can happen anywhere. The
> > #VC code is a disaster because #VCs can happen anywhere. Once #PF can
> > happen anywhere*, why won't #PF become a disaster?
> > [...]
> > * #PF on stack accesses isn't *quite* as bad as NMI or #VC, I'll give
> >   you that. But it's still pretty darn bad.
>
> In some ways, they are actually *worse*.
>
> #PFs need to be able to sleep, because the common case for a #PF in the k=
ernel
> is that it touched user space. This means #PF needs to be using IST/SL 0.
> However, this is obviously incompatible with handling #PFs on the kernel =
stack
> itself, so now it needs a stack switch. In the common case, it will then =
need
> to demote the #PF back onto the normal execution stack, which is complex =
in
> its own right.
>
> Now, if you are on a pre-FRED system, the IST entries don't nest, so you
> absolutely have to make sure you can't get there again through any means
> whatsoever. With FRED, it isn't quite so dire, but it will still give you=
 lots
> of fun if that interrupt is one which would like to be demoted off the IR=
Q stack.
>
> > It would be a completely different story if there was a track record of
> > finding and fixing bugs in the x86 entry code from the authors of this
> > series. But I don't think I've ever seen a single email from your folks
> > before this, much less a review tag or a patch. I'd be much happier if
> > you got Andy L's blessing on this, for example.
> >
> >> How would you like to proceed? Would explicitly marking this as an
> >> experimental config, in the interim, be more attractive?
> > No.
> >
> > The enemy here is complexity. *Maintenance* complexity. Being able to
> > compile out some of the complexity helps with debugging. But it doesn't
> > help maintaining the code.
> Indeed. Paravirtualization is a great example of how this works. The PV h=
ooks
> in the kernel are still a maintenance nightmare 20 years after they were
> introduced, and mostly that cost is not borne by the people who introduce=
d and
> benefited from them.
>
>         -hpa
>

