Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D3F1C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 01:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56906B007B; Thu,  6 Aug 2026 21:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08156B0088; Thu,  6 Aug 2026 21:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F67C6B008A; Thu,  6 Aug 2026 21:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD3B6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:09:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A8A0C02FA
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:09:11 +0000 (UTC)
X-FDA: 85072689702.29.8471996
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id B6E5720005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:09:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g3Vtbzty;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786064949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFWYXxn5mX3aRAqaZUoImbgrzlPlEe06IR2UE0VpByE=;
	b=W+Kx2ZjYYFV0oQCnr7tPsGAKb1cD9M3T7KFJGn5qncaKP7efnXgiPwBir68myPKBPejY1b
	TU8Y2KbMJH7Q8Ag9QSLlA5yeIfQDNybyDu1E5qnctgSpc6pcrVii/mrQ6bU/sfjxfpV7wi
	bZcCDAqaRJ4Hq1o5PlLOFR5byGFpOzE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786064949;
	b=VzVjRJMDuBStYcdT6JGlhFH4WNFGvR4/G+Wo0A6ZqxY4rgznykXVs1zyOS2aIUjbCdLgyj
	bsp2iPssPb/gaKYXAhvJWbwLeq5OG2HF+pNnadx1uk5SY386su86IHDvDiesClceVGtc8y
	/3/8srgjpvVha/IqnKw7cdPuqqb89nA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g3Vtbzty;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c10e86e52so70711cf.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 18:09:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786064949; cv=none;
        d=google.com; s=arc-20260327;
        b=m0pAkQ+OJvXuO9svjN5/Y+gWHFUAbk1IPxbFLXJjpBdB5Sav93cW8EF8M+qoc4a+pV
         lNa8igZHP6OiJHvMH4h7sd4ErFhXCeS/H/w7ugRdu30hL5Frar4/xSZ20eJGxuN0SrIi
         VWzrX9LU+/xMIfTtSm2xFJVx0vFVOhlr0aVQuk5HXvQsGSuYHC86cqJupRz0KbZt92x5
         JmyoQEpcCErrGjFy/oTEBccnW3LzspBH8Q84MKyxv6mGLMxO9hoCB0RtZPd0sHSMA9y2
         /V2ATxeH8pNq7AOpSkSICGXxIPRD7AcKfJ1Y3g4U9FFQkk5AWez0vZRHD+FIruCRCTEp
         zKAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SFWYXxn5mX3aRAqaZUoImbgrzlPlEe06IR2UE0VpByE=;
        fh=YU0T/DpnYlYkZHIXOwmMioAl7U/45UWz8kL1/Co8X4Q=;
        b=FTPM5vpsSDQITsOSwXMyJ2YOCR+u4PFzNvLAxne6t/ChRjyBFp5HGDckrp99DRaCdm
         gNxY79aqEjduQk7t7zmbeUiQl2IuYJS+DaMMvE/1x5N7e/aBMPBGawumzVXmz7/lZi3m
         0njZmNRqrM/UFEyHA7204d7TkKGHN/POCDerQarh82OgwQZPLIQBnom1tELe/E/Xrmv8
         aGO4qIiS1ZcKobHq/H9HOoyCXDWopzYXfmpDHJHoITSMC91PoXyPZIFwmG5HztZAA2VV
         iGXFErFzu1Di8jlw8Vt0pb5atsTVyE2eUPOTQZNwio4KIHkhnxKUrhDD8I5pYjRfNNfy
         HJXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786064949; x=1786669749; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SFWYXxn5mX3aRAqaZUoImbgrzlPlEe06IR2UE0VpByE=;
        b=g3VtbztyLTk1GQAYH/8QtpzfeYyWVjxE4CtoKSkrSwOQ40xo9Hlg1lXcR3k1vinOV5
         Tek1ojWbn5aB6t5rxzQ9SOOCwzaWbbw+/I48tw14iQ8DaFwh7W16DQmrlqTJItOozzUl
         FQ2Ym8Ryvhfzf4U6xsF76odMQR305Th9C7UB/q5zQHmoOG9jMTHS0eDJW1sd8Nn08Iiz
         BXnDFLOzWGiXnDM/+vClKZrJ3VeyWH9YIfALSi+bVh/TxOTRzWe45Mt9KNqpyzwSHNnC
         8i+43SjciMAn9yfYxnA0VvQGmJZkiZsW/jqRacba4KopBs8vXXFQ++2GQ6Xwn1NQYJwm
         uEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786064949; x=1786669749;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SFWYXxn5mX3aRAqaZUoImbgrzlPlEe06IR2UE0VpByE=;
        b=qF2LhVQjTK7I1bf8SToEMZT1bXiqiaNwX7PdQ5B6gVPJY/9B7P6fbfLOXuCwAXdwe+
         zENF2GMdTiNPXmYGPDX2LFaNGfSUzEv3lFqOqTgk46gujIop6a7Ev6j59deNwRCZ+BmY
         qoPJ1kTIC/ut2/R3QyHoqU012LFh1Ep8tA4ng3K82c2YYgS3UkIhKW7jFYZQo5O01Yot
         cBBC/U8nwzFk9DwKAUeP2sbgwbPg8xNxI89YAIlBp+ZTOmaX50i1Azx3TStHm04jsR4N
         mQUlxub7MvN1DGNRnqwZJiBIsiRUSpZ6EKubEajaH4KveUKfXH3gukUoNt1x94LowASr
         vUAQ==
X-Gm-Message-State: AOJu0YwWZ4VOUGPINtOxtsslwpLXlcCVJeIPgojwrI5iC4o4Sz5fvAqq
	34FJ0MPt0sOrjTTkIkgPUh4lRFcpj4wReXUCC9UOi2yV/IavkEuQE0fKwNPxtqgXM692cN3L8TW
	EkvcY6IDSuR4Wu26I4H2F5y4M0n0UMe9yaWL5vCeu
X-Gm-Gg: AR+sD13FARsaQ4UOwkkq9U7g8qYmEr7Y0fldygjd+HA3mNivS2DUxbRDwb39BFa8AmV
	aVsluBmvE4pRHc3xhcsY5b1phRuM2zNmhBNssV1wBatlyWxFmZhTpPOhIwzywwDEGq7EP7lweWv
	wldGK/YFM4eQafKas+CHMtskHA4y8RFqsONzV64ig/97tdflHg5JlYz19MSMTOCaomcbZkLIy13
	dkM2M2xnz9vwvh2hs/sQ85YYAKDv9EGQZ8L+xwVwM3Sl9z3nMen4oxf6YR+6/zWdlEXUXGd3gJC
	UILZ5PRXakhtjihu6q+5qdijRqWmoSpR9uewjXqpr2M=
X-Received: by 2002:a05:622a:2b0a:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-52d1537b77amr4672671cf.5.1786064948220; Thu, 06 Aug 2026
 18:09:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260805090633.141001-1-hao.ge@linux.dev> <20260805095505.1c2cbc150441cb20a74ba9bb@linux-foundation.org>
 <CAJuCfpG_XX-Hwy=TCrJ+g6yiMxGXLB=LvnPN_WLP3WQktNZMbA@mail.gmail.com> <e96d8a13-8f9a-49f4-ae4c-a14c6de5ae66@linux.dev>
In-Reply-To: <e96d8a13-8f9a-49f4-ae4c-a14c6de5ae66@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 6 Aug 2026 18:08:56 -0700
X-Gm-Features: AUfX_mxBaPBw0NNhQsaxZ_CDj1g6HM-fQ6St7Kg8vy0drI_vqZEKxUNI36LMIc0
Message-ID: <CAJuCfpFyTaqLnyi11PtAj-ouJiLcfxZoYDRUUKSZbW3RfDFOUw@mail.gmail.com>
Subject: Re: [PATCH v3] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Abhishek Bapat <abhishekbapat@google.com>, stable@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B6E5720005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9dcz11ezc54ksayasa3qrp7z3d8doduh
X-HE-Tag: 1786064949-839993
X-HE-Meta: U2FsdGVkX1849i2bb9UTdtK2ZO1yZ2sVRsUoC2qcmzCA0ikdwrUrVe/bKqRxdDA6Iz8obnP0TtovXYCyD9fZDehm8S2agGnDh/liyuHLRB29/tMGyfM8jjMdJENhQlzlWS0Zf6SvXhh1OJh3nfk1L2uZbHSDiIyr8eSKtEWUverQO8fCIGKpSo1X2YlwoKfvGA6r1U7ayRiVuWS+s30QwXIIiKnmsRsxa8lbi2AlhhU328ITVaQRdjVGr+4iJQB218pUrlcxAZX9RxzyXP3DyFo/JBlUegjqYiARtiDIsIpRhC9UqfM7ROhEUbA3bEcUDksahRrJ51s0IY+ks28aXr19jLaR/DtEgDrvVCwAoBIB3U6YgVqQ9j+wPCWCv21q/D4rQkuYD4fAwWcgteX2x/bN7NpkyeU11vvEln4tXTpGY3H6ulciJiyTVJxt3i3DnCNRMr0dTUdgd67NJ1HrG249eVg7Fl8l3xm4WVgWqaog9QJ8npl/CFtogcPr6Mv2liQDYC7Ks/wum8RicKDwn8mzCfCb8ubD24YxZkIeRQbncQZFQYAEztcOp913xuBZlTqs+tNLLNMTBGdeNcOwOWSn/DYjvWjZpjm7J9ztSJyw5KCUoDNsk/AYfSC6U46ag2ayZS19M4oLe7CY8wI0x+yptJfqmqfB/2JxxEcPaoMFay/rGurYyJ1AQST9PlqfAdOGz6VIfUtbLSb3NV4zXtuByKRrEJFDMpG0kYAc7BtqUp/oRFe3tpoW8r5jFULGAAr++jnjdqI3qHlAA5MOWoN5PnxFjB9LSaCpZ3M/LYofSiY6tZYYLWn8lTN+D8SRszosFy0SsdmYu5Gv4gEsyQyORU6cjLzDSr96eW+GTVLJbGyAB0Hpd+Vz4eBzivy1vp0zY1vDe3SI3BfiEs/Re6QHUI0QF6sOzHCcvB66CAo3vGs77/WgVtYHfyJldNlJJ9qJblQ7GlUp1rFpbhX
 mnMzuPX9
 65EYID/U+MYgxe9iVgvPZGagnj+0mscwLbruONBYT1wrYm/j12TLGOHgSIlGBvNHi7I7aKMAuxoiP3df3lNR/odVj2aaqiXOeSMXVcfjpS4mPGQfor2SfRoUE+Rdx2YdopBM9lJgwBiuBfpC0oElWNKlfC4oDh2huhMHShM+bLNC/qeouzbHdld53hnYEQ2Pbw27RRZAQR9bQ8RVrqET90Rg2ua5a1hLKvRoQo7k3pX6wYqtfFfUdpIVV4RZ236QW+NargKLDw4dAbMEHyD2T294q9rf3aHyliUF1NJRPkNqEEkGXbwP4k1Q7OoAKBxAjd9g1uEhjQgA3VYn6qAyqX8D8nMRC6O/8pqLlmBIc31uIq4LUqgg1cMvHTbKLl4X+0tc1XIh4U2idiSDael28uq0YxhLOj658xnrHX4TNuJPrFUNqHcOUzeSzigmYHBwcCo/CRMfjJjRPbT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 1:36=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> On 2026/8/6 01:47, Suren Baghdasaryan wrote:
> > On Wed, Aug 5, 2026 at 9:55=E2=80=AFAM Andrew Morton <akpm@linux-founda=
tion.org> wrote:
> >>
> >> On Wed,  5 Aug 2026 17:06:33 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>
> >>> In reserve_module_tags(), the tag overflow check is gated on
> >>> mem_alloc_profiling_enabled():
> >>>
> >>>      if (mem_alloc_profiling_enabled() && !tags_addressable())
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
> >>> Remove the mem_alloc_profiling_enabled() guard. Also return an error
> >>> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
> >>> the mapped pages would never be reused - shutdown_mem_profiling() set=
s
> >>> mem_profiling_support to false, so no future module load enters the
> >>> codetag path.
> >>
> >> Thanks.
> >>
> >> AI review points at a cpuple of possible things, one pre-existing:
> >>          https://sashiko.dev/#/patchset/20260805090633.141001-1-hao.ge=
@linux.dev
> >
> > Yes, pre-existing issue can be handled separately, it's not directly
> > related to this change.
> >
> >>
> >> "Does this unintentionally result in a denial of service for module
> >> loading, preventing critical drivers from loading when they otherwise
> >> could have just disabled profiling and gracefully continued?" sounds
> >> pretty obscure and I doubt if we care?
> >
> > Hmm, I think Hao considered that in his previous version
>
> Yes, I did look into this.
>
> but now I'm
> > thinking we might be able to handle this more gracefully and not fail
> > the module loading. When profiling is disabled
> > codetag_needs_module_section() returns false here:
> > https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L28=
22,
> > so if we had to disable profiling, we could return NULL instead of
> > ENOMEM and change the condition here:
> > https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L28=
25
> > to act as if codetag_needs_module_section() was false from the
> > beginning. IOW code at
> > https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L28=
22
> > becomes:
> >
> > if (codetag_needs_module_section(mod, sname, shdr->sh_size) &&
> >      (dest =3D codetag_alloc_module_section(mod, sname, shdr->sh_size,
> >        arch_mod_section_prepend(mod, i), shdr->sh_addralign)) !=3D NULL=
) {
> > ...
>
> The primary blocker is __layout_sections.
>
> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L1730
>
> This is because __layout_sections controls whether we reserve space for
> the codetag section inside EXECMEM_MODULE_DATA, the same way we handle
> regular sections.
>
> When codetag_needs_module_section() returns true during layout,
> module_get_offset_and_type() is skipped, so sh_entsize only gets the
> type bits with offset =3D 0 - no space is reserved.
>
> If we bail out with NULL when compressed tags overflow and add a dest !=
=3D
> NULL check here, we'll end up hitting the later else block.
>
> if (codetag_needs_module_section(mod, sname, shdr->sh_size) &&
>      (dest =3D codetag_alloc_module_section(mod, sname, shdr->sh_size,
> arch_mod_section_prepend(mod, i), shdr->sh_addralign)) !=3D NULL) {
>         ......
> } else {
>         enum mod_mem_type type =3D shdr->sh_entsize  >> SH_ENTSIZE_TYPE_S=
HIFT;
>         unsigned long offset =3D shdr->sh_entsize  & SH_ENTSIZE_OFFSET_MA=
SK;
>         dest =3D mod->mem[type].base + offset;
> }
>
> That'll cause the following memcpy to clobber the leading data.

Ah, ok, now I remember how the areas are reserved there. Yes, my
suggestion would not work.

>
> If we really need to fix this, we can use dest's return value, with a
> check like:
> if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
>         dest =3D codetag_alloc_module_section(mod, sname, shdr->sh_size,
>                 arch_mod_section_prepend(mod, i), shdr->sh_addralign);
>         if ( dest =3D=3D sentinel_val )
>                 continue;

You can't simply continue here because during the next iteration
codetag_needs_module_section() will return false (since we called
shutdown_mem_profiling() and set mem_profiling_support to false) and
will take the "else" branch you pointed out earlier, which will
clobber the leading data.

>
> But that would also mean extra work on our end - for instance, we=E2=80=
=99d need
> to stop the per-cpu allocations inside codetag_load_module.
>
> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L3571
>
> Could there be a simpler solution for this?

Hmm. What if we return something like -EAGAIN and propagate it up to
load_module(). load_module() will check for that error and retry
calling layout_and_allocate() but since now
mem_profiling_support=3Dfalse, both layout_sections() and move_module()
will work as if profiling is disabled. We need to make sure
codetag_module_replaced() and codetag_load_module() do nothing when
mem_profiling_support=3Dfalse but that should be easy. WDYT?

>
> Thanks
> Best Regards
>
> Hao
>
> >
> > I think this would result in a better handling of this situation: if
> > we can't fit the tags anymore, we issue a warning, disable profiling
> > but continue loading the module. Hao, WDYT?
>
>
>
>
>
>

