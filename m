Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C82C5DF97
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 00:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A386B0092; Wed, 26 Aug 2026 20:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4336B0095; Wed, 26 Aug 2026 20:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C366B0096; Wed, 26 Aug 2026 20:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F05916B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:48:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86C7EA025D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:48:01 +0000 (UTC)
X-FDA: 85145212362.23.4A0E7C8
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 91317180005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:47:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fbNOx882;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787791679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RZmQlixUCcZAoWs8FseajLNnUbL60FURNfuweUrEtU=;
	b=neGhlg68FRNLkAy5xTNzJkoGaugtx8clkZGmHh+MKewYdZS5kkjYthQPPqGdla7xSMHuEG
	wLnvDCl0ynK3NGBQfsY9QFQAimDMSaS1biy0D6AxDPCWSGBcA2CTv+fdGW1B5GDQsrCB3e
	2Jz3vC1h1KSWDgoG9CpayXp+yN2gS98=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fbNOx882;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787791679;
	b=gurCjfLXiGWEc0SAqjuJuURpKDZnqGoP7ZnMM6OSK6thYd2F6KqCRWcQMT4bwZeJlDMf1T
	6YtKMeh6LsltPgNtksbpiSUtPAYLLq0ZHPOy9VWDlPf/xxQblDlNIaWEfo1+BAs51G1QC3
	k7RQGO4JhyIcAZomx8TmnEq1cER55C0=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52faa58bff5so13781cf.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:47:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787791679; cv=none;
        d=google.com; s=arc-20260327;
        b=OApgiUNyBOIzFy1XcBUTfbYO8ruNPz3CIhb3grIjeK9oMyD4prvt6uDT/culUM0Yfd
         RJcXAuKJXBjFDGdSKaGioA0V08jcGMc+2ZL0ZMpSsocxup2haBh3xMLQRy5oMh5OoXov
         qVdRq9wq8E/dkJVG8qb7L8sq+Sxob4w5Ejp7EIKiF7bKtuI8g+TUgyYq7O/2JnyK/xav
         ZJAYXfZ52He4M5xrI1OAKvunuhMYkaCb3e1vwqP66LLfAAiqFCe5Vr8aqI2WcxP8g+8G
         Y9YCP+TQnvD7LO0naj2Q/RgtQECsH2PZulWNyaJ7cq7ONHDGF+rK6C65jbah6YafFw8x
         bnug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3RZmQlixUCcZAoWs8FseajLNnUbL60FURNfuweUrEtU=;
        fh=D3vVVlDjcyz1NURxeob6rCaKDEMIW9dpYFJyCnfAzVo=;
        b=Iacn/dJWDMVIrSx5CdRp57Yos8NscmuoltOC8TC4ablyRWuurrc/IA2gq3Rol9AXRc
         dVtkL2OWDExR8t5NHZL+fPr103tPTm1xzLVpVDRmSi9mtd7ysCB18pNJ6w1xItAesuiV
         IZMY9Rp7/F+GDdwNwybyaFkHMZOno/pqnYdcoUaPx+6ijV/Js+t3SET1NORINhISsWvR
         +OmaN7HUpBeCcFwfjnE+IXj1RCpbt1aFRsZAMTD1bX7fDgN+VfyWrBN8H9X54f1DI1eq
         EA1LPdvG66ssh5w0Dfxzm2eNoBG73hD+LmRVtio2tsW0AvsHaFwRSN57wJ9HcrK9YC5B
         dqRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787791679; x=1788396479; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3RZmQlixUCcZAoWs8FseajLNnUbL60FURNfuweUrEtU=;
        b=fbNOx882EETc1tZ9OAEvZtaw/dWxQgg5HkqHGPyDU4F4Yz9ftIREu2HoAipwHxnSwO
         D2s+LtUlwA93XBvCCSB10kC6xZHxRu7CRHjb6++4pY+oS3azrza+aRIJbTMYbreORw1l
         ngmoW6AaaiVs0Tb+3fPPj/JNhC2i6hFMcQEPmM1nanWNrWyx3Yz++2MRNcBbgzc1YInS
         lgYEPabuzNYmJj49Hf+0o4Xtj+V2UAMmKugI4sP94b1RtzD/Hqs9Uug34zIm1BUNNGhA
         283O53tnGrhmAXSQYou7rxZHpcJGEE1NRGywxOYCCIasaKPZeP8ONFLALTn/F7Tz1Mlc
         hzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787791679; x=1788396479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3RZmQlixUCcZAoWs8FseajLNnUbL60FURNfuweUrEtU=;
        b=RqUWTuDBWx1ZdkqfMWKPZRO3E2LqGNWFHGm9jMd5ve7F7cTwY3pACAhHHH+cU+mkV0
         jZoOxkZ1+G1zIjs6sNSP+GZ3RBDkGfGu+oTd5272geQ4H5ZEc9w2wP2GdY2wBqmvyaGh
         bmWPbl6rEUCIqvkFzwZCkBokzHoaRAhndEjWHhzBzpjXiKcOHy2DGcze4f/7b4IF+EpM
         glxaEiwKkaBYvE8kEyXhStc9FrqS5atJ0dRWEUTA+ySO797+TCW4nu/r6OztcmQTCl9n
         hkvuZJvPLVIJ6OeoYK7fycT20w+xG27PO1ispFykREvYxdF83cgGt3mU0uaNTVKqm5qk
         aFZQ==
X-Forwarded-Encrypted: i=1; AHgh+RryJ/w/9IP0erpC+a9tWs6R1pEYKpo8D6mQ9mXGWDgH+stYHjMhbYSA8e7nBW6fDj0JX+e7Tm6HNg==@kvack.org
X-Gm-Message-State: AFuF++kzoPG2MQdK/bnh9JIRQPBKoiW3/WxidhmuX9zcY+P16XGrIV+V
	1N4N+amnhcFpmC4bDSfwEwVLBGdN/Nb7TamcNDp9A4bHpknFirUzyusM88biXX4tHYzCDBY7st+
	GGXnKQc+yUtn9l12pe5DRPyMVzOFO4sH9Y3jOUJAx
X-Gm-Gg: AR+sD138t2goVieTWC6omDMCSNegfJnsiyjWx1HO3BIY/4deixSkwcGWUnyT3OoDkLH
	9vIFVTrhVJROSTLeDpjefHHVH4ySJsPNSRqvi71Tddd7BmUzxM1AuFmNff7EyKZyCyaZyCNBLFq
	214aSULCOxsjsE/xrUfOcaZHidxyRF/P4UkWI6WkqfInu9slp95guwZWJH0M2u4hew1qyF5qhdh
	crvES8s46DXOD2G/4fV6fkCqLkmsYJY3CnccVfDCdtN66DjfyMkf2wEJ8x9cQMsLScnfK1ukPws
	eHA4BCeXLxHj0SyFYOKN5crwkkz8xamwNAeK6KafTgG1xmh60a70hg==
X-Received: by 2002:ac8:5a8e:0:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-52fa6597314mr3597551cf.7.1787791677524; Wed, 26 Aug 2026
 17:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260812054105.102637-1-hao.ge@linux.dev> <20260812054105.102637-3-hao.ge@linux.dev>
 <CAJuCfpFvdNFdsKdK2CdF2fNp8gbNgFpoeAiaqp70mpbNGCvk3g@mail.gmail.com>
 <143a37b5-93a2-4038-8be9-29e13263e743@suse.com> <CAJuCfpF1pWqhc+P9zPg8FT_CcdQxRuEpJ2DtYja1BeMXhW7-8Q@mail.gmail.com>
 <499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com>
In-Reply-To: <499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 26 Aug 2026 17:47:46 -0700
X-Gm-Features: AcwNN1XT-rcdo_XETSjod6HErreezxHNaJvrkrMwvUtAwfNAjQo_hdUi2H_bXu0
Message-ID: <CAJuCfpE7tSXOOfDVUpOp-jKyyw0vXUk6Q7MFxOVoYULXmh8GjA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: draq8okqsfpi4piupwfrma4bxim6373y
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 91317180005
X-Rspam-User: 
X-HE-Tag: 1787791679-885478
X-HE-Meta: U2FsdGVkX1/JuVZ0kRZHnUwzyzsZ4Q7mb8tn8dBV7y8UHD6DRTXN3sIIENdUEFbvhW7pcFDOACkwnWKV3Wxo9nr8etYXWq6gBe1OJwi2YFIPiKlc9ZwgrSvhmsAWi2BcjlnYQhEhevponsgUmd8afaJ7IAQq2Ab3pSGqQwpewCf+nHux8f4AzCLg2m9DscWXvBGg8XTGD9LkGvYcZ+e8HpkLIRAUSJrRzj4YAfxd3wG0+YutxvVNO7n++AEA0pTpYYeW066a6OvQAfwjMkGyWZPwEzBNASRX7JL7/+dy1aw+v0vXt3Qwy4hmtABPevQIxbxw3lX2Fpi1Rty1A413MLIEtwl1b5t3BPnyEOF14vWf3FaQNrVBAUEeJaFTyESAXbKUJLl352qY4DJ7yjWl4Tv8ZJ5AvmziZfSZkKBPt+qJVBgDMAJ1vnkDo3YIvanG+5eCxuTXhVERISJJBvz72V4u06WuQFdBpnDIksfWUkcawdnNiiZLGfuhwrORO0ukP8rho5IAes4ahBZebCgFNsm73ksHD8Yewcb550nNQDnlpkPXC6K75w0i2fuF2ClKLtYzhHdkQbQUrftwxWe5ffv5+bCnVZqCbx2oevD17OveV1h6ckA0Rg+KDJIpTwMSl06DxaDyg734KZDZqEl7U3Ipk7wE1azVdgGhYkiQ5bFg0nMqd1P18STMzd8rgZWgtn9aKeKWps0mV8V+D40VxmbvZ/PLRaDRD+1Vl1tD6kAPQ3ugPtRy1COnUzZejGic1vI3Q1bAOKLAETCTwljOzk2vopZZukunRckBT0sjjCBCKAV9D8yDqNsadHYxXYnkC1fTYHHiKX7xARsK6Q3oRMCrrwUf8yk7sT8p5mE1jW0v6UMcuA10Ex/XQ2IhfJm39gT2mZD9rmL8r59FaZlpekqwTjdHa3Vkkt1SxzL0CucqQhkDuY1lRQGy797rauxCq98PCpfoxrzq/3C7Hee
 jZeTPggB
 TlF/RkW3hz/QXENnZ6UD5dz0RzzkdHBxoUCi/OnVqoK3rA9r/I6SKwtAIY+1ugiROuyTd+kiBABWAnge+o0MAYVWxTbrMn2X1Co7ctZZOylFfRpBMep/IrL6/sB50rAv+m0NT7wJjUGcwKqKW/JLj25eCsqaH1is5Xk27a2muKsnE7LbN4sJpWGokRaPMdqoeMN6mvatbvD7OaCv6A2wpLu6ClsNH7dO5dxXFN6oJOMCpj4nbCTMoqwn7TNQGVu4vA14izwMq4OlJre1whelTSrFyD8ZOIAys9qVKnaB4vsFgHZh788rR2qlmbpT5hFCESziS/OMh/btkixU4CEa6zqM9Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 1:32=E2=80=AFAM Petr Pavlu <petr.pavlu@suse.com> wr=
ote:
>
> On 8/16/26 5:16 PM, Suren Baghdasaryan wrote:
> > On Sat, Aug 15, 2026 at 3:45=E2=80=AFAM Petr Pavlu <petr.pavlu@suse.com=
> wrote:
> >> On 8/12/26 7:41 AM, Hao Ge wrote:
> >>> In reserve_module_tags(), the tag overflow check is gated on
> >>> mem_alloc_profiling_enabled():
> >>>
> >>>     if (mem_alloc_profiling_enabled() && !tags_addressable())
> >>>
> >>> If profiling is toggled off at runtime and a module is loaded whose
> >>> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> >>> skipped. vm_module_tags_populate() still maps memory for the tags and
> >>> the module loads successfully, but the total tag count now exceeds wh=
at
> >>> NR_UNUSED_PAGEFLAG_BITS can address.
> >>>
> >>> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> >>> as its position in the alloc_tag array. update_page_tag_ref() masks
> >>> it to alloc_tag_ref_mask before storing in page->flags. Indices
> >>> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> >>> tags.
> >>>
> >>> This silently corrupts /proc/allocinfo: allocated pages get attribute=
d
> >>> to the wrong call sites, so the statistics it reports are wrong.
> >>>
> >>> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> >>> independent. Once compressed mode is established at boot, it stays
> >>> active regardless of runtime toggles of mem_profiling.
> >>>
> >>> Remove the mem_alloc_profiling_enabled() guard. On overflow, shut dow=
n
> >>> profiling, release the reservation, and return -EAGAIN so that
> >>> layout_and_allocate() retries with profiling disabled: codetag sectio=
ns
> >>> are then placed as regular module data and the module loads without
> >>> profiling rather than being rejected entirely.
> >>
> >> When the described overflow occurs, why should codetag sections be
> >> placed as regular module data? Will the codetag support use them in an=
y
> >> way, or do they simply waste space? Is the issue that alloc_hooks()
> >> creates relocations pointing into .codetag.alloc_tags?
> >
> > Correct, alloc_hooks() will have references into .codetag.alloc_tags.
> > With mem_profiling_support=3Dfalse they should technically never be use=
d
> > but I don't think it's a good idea to skip .codetag.alloc_tags section
> > allocation and to leave dangling pointers. Also the case described
> > here is an outlier, so optimizing it would not yield much benefit.
> >
> [...]
> >> I'm not sure this is the best approach. It's complex logic for what
> >> appears to be an edge case related to a debugging facility. It will ha=
ve
> >> the usual problem of error paths not getting enough testing and breaki=
ng
> >> subtly over time.
> >>
> >> An alternative could be to reset SHF_ALLOC on the codetag section to
> >> remove it from further processing and have relocations that point to
> >> this section resolve to something else. It seems that alloc_hooks_tag(=
)
> >> could tolerate this, since it only needs to reference the associated
> >> alloc_tag when mem_alloc_profiling_enabled() is true and that gets
> >> disabled by reserve_module_tags() on the overflow.
> >
> > Hmm, yeah if we redirect the references into .codetag.alloc_tags, that
> > would be much better.
> >
> >>
> >> It is also not an ideal approach, but I feel it could be less intrusiv=
e
> >> to the module loader. I can put together a prototype if needed.
> >
> > If your approach does not cause module loading to fail when we disable
> > profiling, then that sounds like a good idea. If it's not too much
> > trouble, could you please send an RFC?
>
> The alternative approach I mentioned unfortunately doesn't work well,
> since redirecting all relocations against .codetag.alloc_tag to
> a different destination is nontrivial. It would require introducing
> something like frob_relocation() that is called from each
> architecture-specific apply_relocate()/apply_relocate_add() after the
> addend has been decoded.
>
> Another option I realized is to change the order in which module
> sections are allocated. Rather than interleaving the allocation of
> codetag and regular sections, the module loader could first try to
> allocate codetag sections and then allocate regular sections. If
> allocation of a codetag section fails, it can naturally fall back to
> being treated as a regular section. This avoids retrying the allocation
> process, which I would prefer to avoid.
>
> A prototype is below.

Thanks for following up on this, Petr!
At first glance, this seems like a much cleaner approach. But it's
also a sizable change, so it will need some testing. I'll try to run
some test scenarios over the weekend.

>
> --
> Thanks,
> Petr
>
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 96cc98568eea..0c6f32ddcbf2 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -325,6 +325,8 @@ enum mod_mem_type {
>         MOD_INIT_RODATA,
>
>         MOD_MEM_NUM_TYPES,
> +
> +       MOD_STANDALONE =3D -2,
>         MOD_INVALID =3D -1,
>  };
>
> diff --git a/kernel/module/internal.h b/kernel/module/internal.h
> index 061161cc79d9..217bb540e361 100644
> --- a/kernel/module/internal.h
> +++ b/kernel/module/internal.h
> @@ -29,6 +29,10 @@
>  #define SH_ENTSIZE_TYPE_MASK   ((1UL << SH_ENTSIZE_TYPE_BITS) - 1)
>  #define SH_ENTSIZE_OFFSET_MASK ((1UL << (BITS_PER_LONG - SH_ENTSIZE_TYPE=
_BITS)) - 1)
>
> +#define SH_ENTSIZE_STANDALONE                                  \
> +       (((unsigned long)MOD_STANDALONE & SH_ENTSIZE_TYPE_MASK) \
> +        << SH_ENTSIZE_TYPE_SHIFT)
> +
>  /* Maximum number of characters written by module_flags() */
>  #define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
>
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index d0e1e0bd2ad0..a86ae8774cd0 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -1624,7 +1624,7 @@ static int apply_relocations(struct module *mod, co=
nst struct load_info *info)
>                  * ELF template and subsequently copy it to the per-CPU d=
estinations.
>                  */
>                 if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC) &&
> -                   (!infosec || infosec !=3D info->index.pcpu))
> +                   info->sechdrs[infosec].sh_entsize !=3D SH_ENTSIZE_STA=
NDALONE)
>                         continue;
>
>                 if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> @@ -1722,20 +1722,6 @@ static void __layout_sections(struct module *mod, =
struct load_info *info, bool i
>                         if (WARN_ON_ONCE(type =3D=3D MOD_INVALID))
>                                 continue;
>
> -                       /*
> -                        * Do not allocate codetag memory as we load it i=
nto
> -                        * preallocated contiguous memory.
> -                        */
> -                       if (codetag_needs_module_section(mod, sname, s->s=
h_size)) {
> -                               /*
> -                                * s->sh_entsize won't be used but popula=
te the
> -                                * type field to avoid confusion.
> -                                */
> -                               s->sh_entsize =3D ((unsigned long)(type) =
& SH_ENTSIZE_TYPE_MASK)
> -                                               << SH_ENTSIZE_TYPE_SHIFT;
> -                               continue;
> -                       }
> -
>                         s->sh_entsize =3D module_get_offset_and_type(mod,=
 type, s, i);
>                         pr_debug("\t%s\n", sname);
>                 }
> @@ -1745,16 +1731,10 @@ static void __layout_sections(struct module *mod,=
 struct load_info *info, bool i
>  /*
>   * Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
>   * might -- code, read-only data, read-write data, small data.  Tally
> - * sizes, and place the offsets into sh_entsize fields: high bit means i=
t
> - * belongs in init.
> + * sizes, and place the offsets into sh_entsize fields.
>   */
>  static void layout_sections(struct module *mod, struct load_info *info)
>  {
> -       unsigned int i;
> -
> -       for (i =3D 0; i < info->hdr->e_shnum; i++)
> -               info->sechdrs[i].sh_entsize =3D ~0UL;
> -
>         pr_debug("Core section allocation order for %s:\n", mod->name);
>         __layout_sections(mod, info, false);
>
> @@ -2800,7 +2780,6 @@ static int move_module(struct module *mod, struct l=
oad_info *info)
>  {
>         int i, ret;
>         enum mod_mem_type t =3D MOD_MEM_NUM_TYPES;
> -       bool codetag_section_found =3D false;
>
>         for_each_mod_mem_type(type) {
>                 if (!mod->mem[type].size) {
> @@ -2818,36 +2797,14 @@ static int move_module(struct module *mod, struct=
 load_info *info)
>         /* Transfer each section which specifies SHF_ALLOC */
>         pr_debug("Final section addresses for %s:\n", mod->name);
>         for (i =3D 0; i < info->hdr->e_shnum; i++) {
> -               void *dest;
>                 Elf_Shdr *shdr =3D &info->sechdrs[i];
> -               const char *sname;
> +               void *dest;
>
>                 if (!(shdr->sh_flags & SHF_ALLOC))
>                         continue;
>
> -               sname =3D info->secstrings + shdr->sh_name;
> -               /*
> -                * Load codetag sections separately as they might still b=
e used
> -                * after module unload.
> -                */
> -               if (codetag_needs_module_section(mod, sname, shdr->sh_siz=
e)) {
> -                       dest =3D codetag_alloc_module_section(mod, sname,=
 shdr->sh_size,
> -                                       arch_mod_section_prepend(mod, i),=
 shdr->sh_addralign);
> -                       if (WARN_ON(!dest)) {
> -                               ret =3D -EINVAL;
> -                               goto out_err;
> -                       }
> -                       if (IS_ERR(dest)) {
> -                               ret =3D PTR_ERR(dest);
> -                               goto out_err;
> -                       }
> -                       codetag_section_found =3D true;
> -               } else {
> -                       enum mod_mem_type type =3D shdr->sh_entsize >> SH=
_ENTSIZE_TYPE_SHIFT;
> -                       unsigned long offset =3D shdr->sh_entsize & SH_EN=
TSIZE_OFFSET_MASK;
> -
> -                       dest =3D mod->mem[type].base + offset;
> -               }
> +               dest =3D mod->mem[shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHI=
FT].base +
> +                      (shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK);
>
>                 if (shdr->sh_type !=3D SHT_NOBITS) {
>                         /*
> @@ -2879,8 +2836,6 @@ static int move_module(struct module *mod, struct l=
oad_info *info)
>         module_memory_restore_rox(mod);
>         while (t--)
>                 module_memory_free(mod, t);
> -       if (codetag_section_found)
> -               codetag_free_module_sections(mod);
>
>         return ret;
>  }
> @@ -2951,9 +2906,47 @@ static bool blacklisted(const char *module_name)
>  }
>  core_param(module_blacklist, module_blacklist, charp, 0400);
>
> +/*
> + * Allocate codetag sections separately. They are loaded into preallocat=
ed
> + * contiguous memory because they may still be used after the module is
> + * unloaded.
> + *
> + * If the separate allocation overflows and fails, allocate the section =
normally
> + * so that the module can still be loaded.
> + */
> +static void allocate_codetag_sections(struct load_info *info)
> +{
> +       for (unsigned int i =3D 1; i < info->hdr->e_shnum; i++) {
> +               Elf_Shdr *shdr =3D &info->sechdrs[i];
> +               const char *sname =3D info->secstrings + shdr->sh_name;
> +               void *dest;
> +
> +               if (!(shdr->sh_flags & SHF_ALLOC) ||
> +                   !codetag_needs_module_section(info->mod, sname,
> +                                                 shdr->sh_size))
> +                       continue;
> +
> +               dest =3D codetag_alloc_module_section(
> +                       info->mod, sname, shdr->sh_size,
> +                       arch_mod_section_prepend(info->mod, i),
> +                       shdr->sh_addralign);
> +               if (WARN_ON(!dest) || IS_ERR(dest)) {
> +                       /* Allocate the section as a regular section. */
> +                       continue;
> +               }
> +
> +               if (shdr->sh_type !=3D SHT_NOBITS)
> +                       memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size=
);
> +               shdr->sh_addr =3D (unsigned long)dest;
> +               shdr->sh_flags &=3D ~(unsigned long)SHF_ALLOC;
> +               shdr->sh_entsize =3D SH_ENTSIZE_STANDALONE;
> +       }
> +}
> +
>  static struct module *layout_and_allocate(struct load_info *info, int fl=
ags)
>  {
>         struct module *mod;
> +       unsigned int i;
>         int err;
>
>         /* Allow arches to frob section contents and sizes.  */
> @@ -2967,9 +2960,6 @@ static struct module *layout_and_allocate(struct lo=
ad_info *info, int flags)
>         if (err < 0)
>                 return ERR_PTR(err);
>
> -       /* We will do a special allocation for per-cpu sections later. */
> -       info->sechdrs[info->index.pcpu].sh_flags &=3D ~(unsigned long)SHF=
_ALLOC;
> -
>         /*
>          * Mark relevant sections as SHF_RO_AFTER_INIT so layout_sections=
() can
>          * put them in the right place.
> @@ -2977,18 +2967,27 @@ static struct module *layout_and_allocate(struct =
load_info *info, int flags)
>          */
>         module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstri=
ngs);
>
> -       /*
> -        * Determine total sizes, and put offsets in sh_entsize.  For now
> -        * this is done generically; there doesn't appear to be any
> -        * special cases for the architectures.
> -        */
> +       /* Repurpose sh_entsize to track where each section is allocated.=
 */
> +       for (i =3D 0; i < info->hdr->e_shnum; i++)
> +               info->sechdrs[i].sh_entsize =3D ~0UL;
> +
> +       /* We will do a special allocation for per-cpu sections later. */
> +       info->sechdrs[info->index.pcpu].sh_flags &=3D ~(unsigned long)SHF=
_ALLOC;
> +       info->sechdrs[info->index.pcpu].sh_entsize =3D SH_ENTSIZE_STANDAL=
ONE;
> +
> +       /* Allow codetag sections to be allocated separately first. */
> +       allocate_codetag_sections(info);
> +
> +       /* Determine total sizes and put offsets in sh_entsize. */
>         layout_sections(info->mod, info);
>         layout_symtab(info->mod, info);
>
>         /* Allocate and move to the final place */
>         err =3D move_module(info->mod, info);
> -       if (err)
> +       if (err) {
> +               codetag_free_module_sections(mod);
>                 return ERR_PTR(err);
> +       }
>
>         /* Module has been copied to its final place now: return it. */
>         mod =3D (void *)info->sechdrs[info->index.mod].sh_addr;
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 2070e682fe10..112a014d4b89 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -950,10 +950,12 @@ static void *reserve_module_tags(struct module *mod=
, unsigned long size,
>                 int grow_res;
>
>                 module_tags.size =3D offset + size;
> -               if (mem_alloc_profiling_enabled() && !tags_addressable())=
 {
> +               if (!tags_addressable()) {
>                         shutdown_mem_profiling(true);
> -                       pr_warn("With module %s there are too many tags t=
o fit in %d page flag bits. Memory allocation profiling is disabled!\n",
> -                               mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +                       pr_warn_once("With module %s there are too many t=
ags to fit in %d page flag bits. Memory allocation profiling is disabled!\n=
",
> +                                    mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +                       release_module_tags(mod, false);
> +                       return ERR_PTR(-EAGAIN);
>                 }
>
>                 grow_res =3D vm_module_tags_populate();

