Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA51C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0D3C6B008A; Wed, 26 Aug 2026 08:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDC56B008C; Wed, 26 Aug 2026 08:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC816B0092; Wed, 26 Aug 2026 08:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6F5A6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:19:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7587D14034F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:19:37 +0000 (UTC)
X-FDA: 85143326394.04.BA33F0F
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8371440003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:19:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HGCFlLd5;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787746775;
	b=bvki0j00YloQv7y4FxIqiwFoB14uEy/AqkgRCoTPVF/BcSm6wEQ6r2H2ug48qkKzPx7Etc
	s+3zHbIqb23ZHcOaCJDhd6oCTleXSoxUSPitGf8bmilxGdBkZNVCkvq0SUrAGjnmfMPEKQ
	WuYmc53pxgUL0lh13pd4B00g7wQd414=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HGCFlLd5;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787746775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWTItkLdaNcYG8wfYq3YekuPNOywaSYtZm4aiNMSYwU=;
	b=mGnpzooVb3YpebUz8Eb5T0JVPzvLEbwk9qWEvjr7kLMydM82iYU8comkz9VHsBVBoyCCtd
	5N/So1ZfRIP4bds4+7M82lXTiZfsncS7yrno8BEhDCgYu2VGjRCi3q4racoKp6t3sPuPRH
	pQVOQQsWjHtQDrnsQOyapZtPcs/0A2E=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4765eec32e1so94204f8f.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787746774; cv=none;
        d=google.com; s=arc-20260327;
        b=Nzv8VYXPAcHSYiGj1fT+PNv0teJIbh1qRuzGsQBeBklo5LB1GbLN3pQnW8llc5AzFe
         wgUjha3EJs0/VEguiOmC63hT6fzcEcIjyM2eZGKSWucquB46kFN2gVJBRCYwTkFXQkzi
         00aLJUekAC8bVP5YQNbDi22tH6+CQK4ZcJzJVfUN0r2wLW/NxjrtVbkLyO9RYtpMnCG3
         S2Q3ny95P0AdjTrJStiMlYt1ITPpKYtrjSNO89kx2Ypu8z4TnfmXZ7EudIMfdrOOfzjI
         dZ7v/6M1sWdVjeUuRvquGDPHH/Ym7pcScFxG5kGFN9HmHewB6CdcIkSuqAhYCa9imfdG
         CCzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HWTItkLdaNcYG8wfYq3YekuPNOywaSYtZm4aiNMSYwU=;
        fh=iXB3siLVVP3680P0boJRLZ0o7LAU7TU/i1YZGI3R9dk=;
        b=LLwEFEBRLneS/NFRNXn2RqY1dgOtmuFFWhIjztgnwjj9KD6Ap7q2/3/a/vfl/VgqA9
         IOtjVN225UP6c9HDPjIUNNvpC6dx7MbPR/hwTLxiGA9vi8na3ROSvSKh7Qiqr6IsceP8
         rkeTUFf43fMhWTqJlm3gvO89YX5cdRtkdmn4Ucv/+YK9ruI4HJ9slqL7QKRmqzrISiCd
         +26vmI6UIKgivqB3v65wpAFvuw2WQUZDfAx24RZcVlhklRHl3G1Z4P/dR063PyVZiwJP
         RTR/IWhbY3iKD8W9BgWtaQkzBfvXAfMMRwZnKA1zGWTR8it8HVldhdRHsyFBSGerstj/
         GVbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787746774; x=1788351574; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HWTItkLdaNcYG8wfYq3YekuPNOywaSYtZm4aiNMSYwU=;
        b=HGCFlLd5ewMo5lGU/s+MiSgA1+KA9BnV3u27D6Qqi4Riu5H7t1afr3XYmewVuUuFMC
         5cOyPTiNers3sfJ022BXqMt0fHa/uDjDn7ll9Dl6BlGy02T6olmG/fr8XiZbQaXDiFS5
         kTRfDhftT10Ls9yCuG/tTc+6zSwu7jnrcELH9GixlJg1RLehgYEXOqyhoQyklgxsbC0+
         FrfWufISR7SyuDMMCLagyWwduVJfqJEmsuBYoPtqDR1fO3mWk0Rl/GUs+BuB1fmDP7z9
         jnDBA2LbWuI68oL9BJX9fJNn8T94RQTe5HHgbEd33ID/c26gTa+pnIJigCLFDYRrpoOl
         orxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787746774; x=1788351574;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HWTItkLdaNcYG8wfYq3YekuPNOywaSYtZm4aiNMSYwU=;
        b=kEF7bOvEwX6bIi+LUZHMZle/iYZeZtpm9xjJg6zJM/fBE2foJeWHrbPCgLuRcFF+FC
         t3TSymb4YnMK3h2RLnIbc+CGr7iJr8zzdUtqsVqdf/y8bJsc9LmpVVjUqydxGPjMdmUO
         g9BYvbEunQUA8daq6jplNMBG6ZyRXVAKemGkRXLVuNLNLzmaca6JJRiYRpCzGYjXSiX9
         OPBMuSD2VVfc+HFoETUc9lDJL0BjpFblP1yp/Y6XJtU7Igf6j+fHXOQiB6YUbR5YGkas
         cAxiisdovHkDceGdSmJJD2TlRxCIav08fUbyX0yuPCxr19g2HNcEUk1QUCXbJcwludOh
         Ff+w==
X-Forwarded-Encrypted: i=1; AHgh+RrxxseGmNtTCMtRzvHmiGDoAntMexhQwH4x2nI5iAF/JWYDa2aFOxJlFbBBi0qYyM4h/vpP8yOhTg==@kvack.org
X-Gm-Message-State: AFuF++l+v7SM3P+69I2CCf1bydYQu7fzyWF8fK2IXYkUObQqft7F6J+R
	x9a9yU+Mk5JosLXrTfZjZbgoG4Z9ej2BCbHUWzYs4YxP+87NGGAUFmHoZr6mQ0NGPA2uhY7mbIY
	t7Yvj1flP6m55GlcxvJS4OsT0kx3oBhw=
X-Gm-Gg: AR+sD10mVcqmohhsbFJvUfYRR60S0aK8dSj/piNr3qfezzwrmwdmy3vfMWLxkJ7fLEs
	FPPZWMW1XG3PfothNjXbLG1tlPIo1/X2D0DrgZPEXlPWcAX5b6l3tnNl42yl5hNoI75nyP2Gxl9
	k65b+D70XQpWPMb2W0oLluZk5Zd/eZhmGlYYsylU59C61v8lAgQwGOEQOWnz8X9+gY0g8qKWpuz
	f+6DpEMmryCu2j/R1qLpCsh/D9ylH8ECvm9iVuq1uI/6QpIbrc6bJBEZ/uhsqD/z9S7xCVpAEuw
	iW9Vy4TbNoqK1zATrCHRR/MuLvjaSNS7aD4O+PTrAGedqe+9EF71WrQGnD5Per6sLpfQlnWBuG+
	7czgP7ZwCGfidlhZcJdPWdvsLLfJWBqyAkyDlIKsM
X-Received: by 2002:a05:6000:4711:b0:47f:8e4c:8a4c with SMTP id
 ffacd0b85a97d-482e27403cfmr3428181f8f.4.1787746773692; Wed, 26 Aug 2026
 05:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-4-xueyuan.chen21@gmail.com> <2931f8a6-3780-4d6a-b19d-61cbbdad1a3a@intel.com>
 <1e04196a-7079-4a8d-a1b7-844e60d08728@kernel.org> <687afc72-5b6a-4138-8d33-fe5b6b7aef00@intel.com>
 <26e6340e-9551-4d18-b6d7-86cd400a5b88@kernel.org>
In-Reply-To: <26e6340e-9551-4d18-b6d7-86cd400a5b88@kernel.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Wed, 26 Aug 2026 20:19:22 +0800
X-Gm-Features: AcwNN1VU5Mbc85A7hVGohdOOFmdIUTao66TRdBDCw720fDhJHgSyn-6YsLEVidU
Message-ID: <CA+qSx6wyvivrp5P-vLSmXeEK8GCs00ThKLSq4C8q7bLLLXUPwA@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] x86/mm: add set_direct_map_ro_noflush()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, akpm@linux-foundation.org, ljs@kernel.org, 
	usama.arif@linux.dev, catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com, baohua@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8371440003
X-Stat-Signature: rgrtyjtauza17zz7gk57fubzb1bmf5sy
X-HE-Tag: 1787746775-520733
X-HE-Meta: U2FsdGVkX189AK9z3lFaXfEfeK0XqR+j9S31eKusElhv1dAPWT496bBdUMUhgoOSjxgtlnnHR90J8rqnn1aAgbYSGtD4ZMsK8gyiMePTqXYW6gOr3H0/qwIIa5GAq05w6E7kzBbFFJv1ENE5IMob/4po5UEs20VVxwOvM8TGwZf/MCq5aGBsFWt0WKD71GsdlY1dMzUJualGsfLMwhB6bm5KAkk4Sc5lZcmED3RHlhxro6pySpkXHKngbMwurmui6IMsxjXX1tt5p1JzbkBlJOTchoGucyrQOFb5OxBGbElzKiVwcbXuijcOw11u90PSlUHn2HS9/zTO/dGjLivuxWLtALeE7hhlAT2n1blK1LLH77T4JoQv/l7LPmZCJF9WBP93mNYxTBFgKK+wBOpVisLrkupQUGyN02+wYIhCeHnvfoA4SyHcmwcLA5OJA/65+9+E7uiULNic3OQocPRNrUgHR9r/shWRSltrahj0QjzWiTAJFqHe0wNerciyJ1L7gLCl3kN0F4DPIcyyxSkADNSKsFEWxjZaypP2BWoLOSf8wBm9/wAzm68kXdtqzOlUFlqkHrztxrT6GWRzyzA4uGHquo49AYxtL+ashX0iF7iRm5Leq8HKMq+DNuFBDc8pEIR+tUpdd3YOV3Z7I6yP5wTL+3N3Xyc9Kjvij+8JtweZrSMQudDOiKn195ENRibQlurGRQ+4Nj/Hhyhajp2UhPS6akIoCTkmXtKvCg/4YGIY/jRUVcSFvLp1u2m1hZjXuxkNlOskdEJqARWRHcr/eG+/w7mEMz6FUJm6f2UTV2iV1LomEe7TxPO08NfEQMtmfxySPnknxQmRBTSuk2c+pdeT9VJNYKifdepedqLDlyq7FbDeuqgNuqlCVmXKnzwBtWEy9K3CGJTyFCViYW0nFdGNIgM+ici8BChQmrWs/e1Pzh4h5pj0DaI+lwJp2OHSAoB7N/cmOH70SA/iY+o
 dnIoO7be
 Djmq+Z2K8HWzFBfYSARpnongHiYhTuz64rWyyhkx9MCYe5O+O7XE2zuDzzhRDXkiD6Yi/PSBlvH3IhyGGznZgLxSUvgBEl3SDJdtYabO/fd2M9aVckhZ5mG5nVxHvD/N1+XEEOtPXme0jfEGVSweoKIIlUdAleXfUQS7cwZBzdOMi+GZfYPHzzMEttHNuezqLxcnst+b+Jm/OZegnd2xuUUsl/XLgqSXR3akIT5BWrsV0DDFbW5qd8Gqeh9zNC51IQOLbanE22V7R03tHdw6Cavr7OUDpm13Q7cSWxxIplhvhOShS96sMulJtOtQXvW74VF3LEv07dFSBMN+ixIKHRI8CLJJtOwB/wTFTaJRrWrnWeGmbA73v+X2FYfUjyFL9FpYjB+C4a+efGrblKp0G33scdhAcFuQp9lFUMLjmlcQ3npqoyZPdqm+CODbRYu4Y4OQQUmhWVr6B28iwamlh9/C/5Jar9VCFiams3Ll8DNfws3PRA5mrb841UuIqkCjcqsVj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Dave,

Thanks for the review and the discussion.

I'll switch the helper to a page-based signature and do the flush
internally:

    int set_direct_map_ro(struct page *page, unsigned long nr_pages)

I originally chose the address-based signature to prepare for the
interface conversion, but since that work stalled, I'll keep the
helper consistent with the other set_direct_map*() helpers.

The remaining comments will be addressed in v7, which
will be based on the latest mm-unstable.

Thanks,
Xueyuan

On Wed, Aug 26, 2026 at 1:31=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/25/26 18:57, Dave Hansen wrote:
> > On 8/25/26 09:43, David Hildenbrand (Arm) wrote:
> >>> int set_direct_map_invalid_noflush(struct page *page)
> >>> int set_direct_map_default_noflush(struct page *page)
> >>> int set_direct_map_valid_noflush(struct page *page, unsigned nr, ...
> >>> int set_direct_map_ro_noflush(const void *addr, unsigned long nr_page=
s)
> >>>
> >>> Which one of these things is not like the other, despite being named
> >>> just like them?
> >>>
> >> That's called out in the cover letter:
> >>
> >> "
> >> This series adds set_direct_map_ro_noflush() so mm code can make a
> >> direct-map range read-only, then uses it for the persistent huge zero
> >> folio. The helper is direct-map specific, takes an address-based range=
 as
> >> discussed for set_direct_map* helpers[2], and leaves TLB invalidation =
to
> >> the caller.
> >> "
> >
> > My concern is not so much what the function is doing or whether or how
> > the specific function is documented. It's more about whether the new
> > function is consistent across all functions with a similar purpose and
> > name. Also, if it is _not_ consistent there needs to be reasoning behin=
d
> > the inconsistency. I think that is missing here.
>
> Yes, the intend from the submitter was to prepare for the interface chang=
e to
> keep them consistent.
>
> I agree that for now it should just consume pages instead of an address a=
nd keep
> the interface consistent in this series.
>
> >
> > In this case, look at the call site:
> >
> >       addr =3D (unsigned long)folio_address(huge_zero_folio);
> >       set_direct_map_ro_noflush((void *)addr, HPAGE_PMD_NR);
> >
> > It *has* a folio. But it does a folio_address() and two casts to massag=
e
> > it into the type for set_direct_map_ro_noflush().
> >
> > If set_direct_map_ro_noflush() just took a 'struct page *', there would
> > be one folio=3D>page conversion, no casting, and complete consistency w=
ith
> > the other set_direct_map*() functions.
>
> Again, I agree with that, and the idea was to keep the interface consiste=
nt as
> it gets converted; it's just that the series that does the conversion sta=
lled.
>
> >
> > I'd also be OK with set_direct_map_ro_noflush() taking a folio, with th=
e
> > implication being that it might eventually make sense to convert the
> > other set_direct_map*() functions to folios. But page vs. folio
> > confusion is much less likely to cause bugs than a void* versus another
> > pointer.
> >
> > IOW, what I think I want is:
> >
> > int set_direct_map_ro_noflush(struct page *page, unsigned long nr_pages=
)
>
> Yes, or as will said
>
>         int set_direct_map_ro(struct page *page, unsigned long nr_pages)
>
> performing the flush internally.
>
> >
> > Or _maybe_:
> >
> > int set_direct_map_ro_noflush(struct folio *folio)
>
> I think I raised it before, but using folios on this interface is not a g=
ood
> idea. Primarily because
>
> a) Once we decouple struct folio from struct page this interface would on=
ly be
> available for folios and ...
>
> b) ... the huge zero page (currently huge zero folio) is on of the exampl=
es that
> *currently* is a folio but very likely won't be a folio in the future. On=
ly
> anon+pagecache that really need mapcounts and all that will be folios.
>
> c) I don't expect any further real folio users (IOW, anonymous folios or
> pagecache folios), but could imagine non-folio users.
>
> --
> Cheers,
>
> David

