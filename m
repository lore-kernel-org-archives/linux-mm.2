Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD0D1CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 10:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617266B008C; Sat,  3 Oct 2026 06:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8556B0092; Sat,  3 Oct 2026 06:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE486B0093; Sat,  3 Oct 2026 06:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 266566B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:08:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C120EA79B3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:07:56 +0000 (UTC)
X-FDA: 85280888952.07.C035A9C
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id E29DD140002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:07:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MVx95LW7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791022074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGejqWoC9Dv7qKp7UMp4xz2oUGszmqmbLhHDL3WC2dU=;
	b=h+jyf/b/+4uGau9EPUbelZympzbS1rvDcvbxllFo9v1t+opxoBXa4eBIQWFUYAiQ3ZwbE8
	X0fSrT1sMK3lM6aBi39CBFQjZNL+hHh/MZUIPq4+iv+VTwP326GjfVZjHRHnvq9tVLhQaM
	ilYInsIRJlgq37Zpv3AHq2//XeEDMHA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MVx95LW7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791022074;
	b=2b5mpmW2rukJJMLMMzx3nfJhbhENd6F0jriiHQiyV87EAnF1vb+8RjkqzO25S+ioXxN1/Q
	UeAyoW42NqKK/VwAAnhubFCgL0KQqWGP1DG/BrFUDhnb+AIQMJgZclmmAGwNVpYaDuEArR
	GY39SneiMHjAc+Nh6YKbdgibGioJXFw=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b001cd92bso153209f8f.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 03:07:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791022073; cv=none;
        d=google.com; s=arc-20260327;
        b=hw6/BDuv3l8nP4zcozAQQaMZez80qvNZGvADPghubX7C+sAhEnvhMrD3S8rqS86S8b
         oYl4fN7dP+3ueuuylsqTDZyjz6M6MDJT6XJ2eRWEC3gI0ADILnns/348C1BhSJlIcpOy
         dr+3NftY3h4h5nZwLh7HPUqQJN8WShx3s+TIfSt91LxoSwG3EEmxcKTvIOrDWHHyQs27
         6yQqKVauYnFr9GmMO8rmvgb3RoP/cIHHS/aXJwHxwgLSMCg3GRxJDyKLAobXudx9f27g
         GK04tcTDQISpQhPTayFYDx9f1JczClnazwSuF1P7XNeU4qLJNXPHQbWllNSHjFotOB6m
         4RQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SGejqWoC9Dv7qKp7UMp4xz2oUGszmqmbLhHDL3WC2dU=;
        fh=Rj17w7IjIdDJtyyerWfuJTmONAKe8HRfiwUx+1OULh0=;
        b=ZnDZaLNGZHh65c5Pn+MKcJ12rwfEld5nOVG8ExbsfNPE+/HkEXGN+rD4jvqseCy45f
         IJ1XFNqtUiJDJvAOA5wNlKGeTHSsiCrUo1kvwwuRNm8GcagP232xXIPhJshqUgQEl6xn
         Hl6FXEHP8fxADzEpNVLaAn3ZfbJs4lnrZlfvmiNAt7Gnr6750TjzfaAKSL9NYmu/rRFL
         GZ9+fLXmyE2wAtD5o/cAQXyFAJmu84sK0zR3prn/6r6+xrl4w5HuNto98NezteYoAB7q
         YIzJ/IOJ9OHnNKzNJM5tu59IvUV8K+vuL7mqQc+5iZ/iRN7QyO/aVO1gMOvKEfiBsEio
         0y9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791022073; x=1791626873; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SGejqWoC9Dv7qKp7UMp4xz2oUGszmqmbLhHDL3WC2dU=;
        b=MVx95LW7hXKW5o0M2jpOaD/00UpbyceC5WUbDLLZyIMmovvOuSZFlbV832BxDDTYXa
         FuwF8vGGGgSfpjslyUlESslYxovsbX2CgP4Q1teVp14qVhsKYDD+iRAfrJmQQ92EHOqt
         hAd+usddlaKVd9PMp0X25/5Jo+kMm1ta8z1CqjTmRs/wW/2N0Ud5SPQMsgWfH/yphpfo
         /T7x+9F4Tx3RmZzbr5EitPG+4jj5UTRQEC4A6ZmvCC7wcEY20/mgd4K4Dk/fROi+yfMv
         s6AeN613VgE5bG/t9z059CantmN07rN/03SQqm5Vz9TvxIad8nFN5eSkMxSIGIOJ+FKm
         tISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791022073; x=1791626873;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SGejqWoC9Dv7qKp7UMp4xz2oUGszmqmbLhHDL3WC2dU=;
        b=yxjD2tSKNPc8dy+F+j2CTWDMLYsPL5S0hb+v707i06DMFP7lgstng6pXUrw9bHA7w2
         hpfV0ru1mh8mzwCCYsoZtD+8OxbMc5oR803FEZ4x0PP6b+aOz+clZebQH2jaPASGK2Pz
         JuC9/SmhlHohco8eH759/7hNSNOPX2f/YAfF56O/1p549Bdb8jiOMjHXupFDUzaz97sh
         1ZggvvsJLWod+OxXggSm+YA5JoV8/H2t7fmKlkCy+oHu/S9mldGBLKBEzXG1+CcIgRdl
         dZ81PWrWNU9sS6krTJlw9pDpudmjbuewlEMWWcBq8cyXJQKVi7ra0zP5WY4icG+J6UNB
         bLAQ==
X-Gm-Message-State: AFq9FYKR/vQVKrYpZwVD+rJl0ev67h7EZDarhNdKLrYm1DzMhtVOHGx4
	pQukIdR3cvYz90YylJgXgf2MfdHpcdSzcIjeQxBvyhNJtvvMH74ceiRjF7tQ+XMnm6oz6w6/alU
	CpAqykGGcg50yyCa1L56U5+YLs4kkWNw=
X-Gm-Gg: AYBFou2RcmTzgdQ1dw/rwsSRQpuvI966TTCNy+S8zVpuml2C7ddJNnUUc2MPxz4DSTb
	TT4asWer8VtzKahnu377L/OwvajRsPVHaHHpDHTaiQ3Aqfo7r+qmOphh8zASZN4DB0/WGLB6J4q
	Re0TsLaLtaaGfwWvBY3+T+4Ez8v34NNZJV1EJbusJe4VDg7moynIw7x/KOBAFBNAKSRDtFllb3y
	G+/Dyw4gZFqBM14jkVWmO7Bu3lTbOUa3qOhZgDFpmkqKWfF5nswZ9F0iVWrc4nbK9ZcpEVgNDKj
	RryYChy/NUcWa9SFeR+HpaHGj2BBekXXDzdINW12wrTvGAvkK6l+mgnB+FvWSIZmQTujt/0kw8F
	t55eNvFcVslXX3SasHjXkWw==
X-Received: by 2002:a05:6000:2306:b0:488:8384:c382 with SMTP id
 ffacd0b85a97d-48c48020123mr3398217f8f.49.1791022073404; Sat, 03 Oct 2026
 03:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <20261003005900.909710-1-hebaoquan@kylinos.cn> <CAKEwX=ObA6NQg-24jE+BT4QksamwM+hYWWxfYBYa=4mXvC3oUA@mail.gmail.com>
In-Reply-To: <CAKEwX=ObA6NQg-24jE+BT4QksamwM+hYWWxfYBYa=4mXvC3oUA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 3 Oct 2026 11:07:41 +0100
X-Gm-Features: AclHuK97ga3djXI0BaUU8HyVFHqyUdFC5pg9CtvOlAcqOSdxgWxjAQD5ANmeZSE
Message-ID: <CAKEwX=OG3-z_WdUjA9XMVJELSgrDZStyGNJ5fkj4BsH+w6HBEw@mail.gmail.com>
Subject: Re: [PATCH 00/12] mm, swap: give xswap a physical backend (xswap
 phase II)
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, baohua@kernel.org, 
	youngjun.park@lge.com, david@kernel.org, kunwu.chan@gmail.com, 
	baoquan.he@linux.dev, gourry@gourry.net, riel@surriel.com, 
	klarasmodin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E29DD140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wafyi6m98b34bnh73pddb3q37rtxsh3e
X-HE-Tag: 1791022074-141667
X-HE-Meta: U2FsdGVkX1+ChdCKu13MADrlYjVMdPkU8LBSQavy0KN/zfY7rz8ubMsZd7svbZMYTm+BWmV7FKebWcc3zxZvBpKuNorg5fEFNV5+NyVxkLxLrSkVspHCGhv/uhiR+pHP5wXOlrIaU7iiKlrwQtgCR8xerg/X9f2rZW5ueI+bC6X2E8d6msV8JKjKmK+htZm8/xZ3hV0IeY/6xcqF8Aaa3OINFSg+Rl5aUPHftBTJMQ0c7aAlVTiRcPiVJm/7PCdKTeg1fMcX7q2QvXNwXEJbESB3VHfD/QvAioqB47b+edU0UvfpnoZoAbyhzAQnZmdCDCtBDqTlMPrWM/cLO7sJ3D04m14NIf94piXGSbFefM/VRtkeHAg4Rg+uCWtb0uHaPTJ32xxfZYRRSrwBQGzFecQE/wHjiGty1PXnhHccI5ae6y/vCLrvFowXrePkVcQoUFMcJ02AZ3/bznZIyj3w0OvySQCIafai8ujkPt678M/NKEr9/GsIF1Czb1e+YJGL9p2bPhsLWrQsC/v41Jp5NCxf4q767tbHcaFbgwoOf+ASNOGZEWAEeqFJ5+XrHKT8K5y7cRfM5bKpOIRsyrQb6F4lhgYOxDrMCTi7qAMJHDZku7sNKA5zt2CImAE+zbTWtCEJtxNBxrPtTePlDvH9bHjdYKpHVoZsnzkgAIcSlBCcEKFfM4MClKEhw2nqwOQAN2jN5cY1FexdalJfmwfwkQLdJWPxqA7pfcYUxoQ1f1JMLMIm9i1/a+KT3R5lKOYjqdaj2415MCYOCIRIQeI8jdTunjtSNr35/OgWE+QxVygXiObAHeFmbWkpWfnzjnGArow2p2Mn5AjMTyHZqi36I8/L/ujiOjVYtBdNno8QUDN+qMsWyI2JU6ZQLk0vCJrNCpGooHSdzygi+Er8H1AiAhlbkDFemxAnSJiGqYyuvNsU9XrXcWWH4zwuI5y+NUDeyWwGOfWRnSkZfUAzWs+
 HNohfzgP
 WJA08/miliZAoOMwm1ibElF4492COQbd4aYR4TtXZ/JeDF6LdilAR6dR0o+hRy0kUyAr4XBnl12ZvPlS8rD3lsyVbi7BVV25MOCxHecsyoL+iHY5sLPxHWiatATOhbhYuy9lWFpNNRyHF9P9jmSzHlkTEtPqxVGwwhqvlbMAxWGoZzPVbHfJBqFhm4rvqXnIIFmCf8bZAwGVzFKNqzlLUiYlkDTEumL8Ko5tJT+L86Cp1J5Ald/Uacp2EWx8hCp6lVkqaurobiheKqJVhzz5HM2PdCeSnOSEPCA3Ri43oSg5ilLEFNOWy9tvQnz9/BE9hY2B72Drb3+0LdIDFKQKOQxCIofvw7BNwyNkKa8rQq36juiNHuIdLMoRAPNE6zF4Luyq3+J36nr2VLrZ8etDrkE4AVVICKFTP3CRopmYPFbrBlEYyYNVx6F+M82OZklFcxWmawAMBIf+YAHdvyCkikVspdGFRnvEADAZkTsLK+Dj6K7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 10:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Sat, Oct 3, 2026 at 1:59=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
> >
> > An xswap entry holds a page in zswap. That works until zswap will not
> > take the page. Then the page has nowhere to go.
> >
> > This series gives an xswap entry a second home. When zswap refuses a pa=
ge,
> > the entry takes a slot on a real swap device and the data is written
> > there. The xswap entry does not change when the data moves. It is what =
the
> > process's PTE names, and the physical slot is recorded behind it.
> >
> > Phase II of three. Phase I is the device itself, 14 patches.
>
> It's not cool to take my idea and code, modify a bit to fit your
> design, then send it out without any proper attribution.
>
> Adding a per-cluster array to store backend (in place of the existing
> zswap tree) was my idea. The only difference is you put it in the

Just for the record, here's me doing it since February of this year:

https://lore.kernel.org/all/20260208215839.87595-10-nphamcs@gmail.com/
https://lore.kernel.org/all/20260208215839.87595-15-nphamcs@gmail.com/

Look at struct vswap_cluster's and swp_desc's definitions. This design
predated the current swap table edition :)

