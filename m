Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945DBC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 15:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC018E0096; Thu, 24 Jul 2025 11:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E3F8E007C; Thu, 24 Jul 2025 11:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F2E8E0096; Thu, 24 Jul 2025 11:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D14E58E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:12:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 836D11A034A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:12:32 +0000 (UTC)
X-FDA: 83699499744.23.BF761A0
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F50418000F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:12:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EDFm7qps;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753369950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqXvn/StDWrS77Y+1IlIaBQTJAyFT2n+pM6JuFAK6gU=;
	b=orwgdb3OGVQe5RAPDARY1BHEY8/V5xPs3hLw0ipaUMWH2xkGl3CDPzOsDMvnC8KDkDppau
	eKU96VHujytJnPFaDTGql2DnrXUIG+OL7EhtLxvnwCFNCPQU3W8I57h951th82evuEA/mU
	iU5iC3QgfjP2MKalpFqjF8ik+nYPox8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753369950; a=rsa-sha256;
	cv=none;
	b=fm+LlNJKAVy/a5bVIhZuXpJtL569j44sCFPtAJHZVPXaYH1PiKdzaEswO8m7uFIKEVCBh0
	4djgsruLX3ZDNFN2xyeooAIoCxLR8wUKbY96LRUBmqrysD0sJHD2Xxz5xtF/KQn8rZClb8
	lSjqlcV4yyHOKhbHvCxi2YRWkC2J+vU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EDFm7qps;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-611d32903d5so10798a12.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753369949; x=1753974749; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqXvn/StDWrS77Y+1IlIaBQTJAyFT2n+pM6JuFAK6gU=;
        b=EDFm7qpsi3P80OSP8mFuP0R0E9Jn58gGTUYWR9cykFMweLA9aiSwAZ7pL0a7A+bmvx
         dXHqX2vnCCYJDH6t+qigli9On2larBuiJGxeSjcx4/FosPCUUSlEoqsn4PaD4Gm0Hss8
         7QenRbfWQzCNBDilwRnFEBll1upwRcIN1tnHuze3OmiPViZt9pjZe03IPCfVXD492EFv
         bvrMmQueUBSs1pP/57+B6w++dRAccB/gZwsK+8zqtSV/dy8+jfsw7Tb8i/FU0W0uBZzf
         QRVRPOXdK26P0SbKGCwifLUsi0vQp3SCiSERthqAGdF6ZFC3UpqhvPCTxNtRP60/gGy/
         9cwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753369949; x=1753974749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqXvn/StDWrS77Y+1IlIaBQTJAyFT2n+pM6JuFAK6gU=;
        b=Lyv2RSz7sYqSfUn0HRLHoL1+RHOdAmKkJj4sUVDETMkUtatYt8ErKHg718kGj+oQcs
         /8ZEmCpy49CxXmuLScnWGREQQvvJPkZBVPjZ4EVI2U/0+ETB8Rf9cklZ/0O20GR3UOvS
         ZnitmsCZ6SOGAjS1D387E3VJ7PIb/7jacT5blMOppbTYbDk/Xkq2WMC29YOpdGHvdsGt
         YhXu1Cj2fj5jTB2oVHzuyuakq0XHJEccJDRcg7ZxnKAQjmaztXb3tDz1Ftr8h3Kenl/+
         gyndlk/5vfUt2j5+dmNIXZ94PapGLfyk8xmie7SXsidpp2Ifo3FWDSUxbt37YBqhT428
         PGxg==
X-Forwarded-Encrypted: i=1; AJvYcCUsWtYvRcrRiakXlz+//MSUE/zKOQmGw442f2zLHB9qN/BHL+daAodigZjcR1qSNSBRc/sJdyRzZw==@kvack.org
X-Gm-Message-State: AOJu0Yzwu8tV3orR4z0Aifki/75fKgI3cNPPDP9Yvr9H3szTMwYBMcLH
	QRFgAZ/SzLEJ9nuf7d+hj52n5JRJSPPyyEKwFG/9TUOztfgjc5v490TJLQSP920dDnSLOPaO9bi
	LXbZcyNb3OUIN6qi0SFjwiLs4zB8ZojvY8OCr3/W8
X-Gm-Gg: ASbGncu/nMa8U4sryDkVIX8+ksmYfXQVNbeDcCWxdBt2YPqQecLE41zJLur7I1WSdO4
	xk5syqEi6BrCyXUoIrJuZeM1R6pLDjD75jCNMP1ZkSuV3C1SZ3Iy5pGKzc8asqw5zy8giwF3f1f
	aou5vQjq5TLbGGWBRbVXyXcnAw9Eg7cwZ0LqGv+IfiXb/FEKgmjJh/fzF8i09gIyW6yVYUZQbVR
	NPN6JaYT8+G5CMksESBV8HVQKOnrFEiPw==
X-Google-Smtp-Source: AGHT+IHBGlAlpqkzcDHZbw2sNCslvhmGfaM9b4Nex1wG/5/Ri659NtJD16WWqjDzjVjGRO0jWUwlf3ajnKnPpgKPR/w=
X-Received: by 2002:a50:d7ca:0:b0:612:ef17:7853 with SMTP id
 4fb4d7f45d1cf-614cce4afe5mr78429a12.7.1753369948492; Thu, 24 Jul 2025
 08:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com> <45cd4505-39a0-404d-9840-a0a75fcc707f@suse.cz>
In-Reply-To: <45cd4505-39a0-404d-9840-a0a75fcc707f@suse.cz>
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Jul 2025 17:11:51 +0200
X-Gm-Features: Ac12FXyEpQmBUWM62BqVW--MRdpwMGBL7kBF9xwxQYUchJD8HK0S4n7Iw79CZgM
Message-ID: <CAG48ez0KjPqqDdzejsjhaHSuJG_0Q8zhyi-7rYq9gSZJergVVw@mail.gmail.com>
Subject: Re: [PATCH] kasan: skip quarantine if object is still accessible
 under RCU
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7F50418000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4jc8mzkjhzygx9t5rgfexyyzoqx94j11
X-HE-Tag: 1753369950-754063
X-HE-Meta: U2FsdGVkX1/Kw91jxkcw/2juA1aN4QJl/dod2UkO8KD1ZCtlA56IQ1uXf9mpQvYBPGCnegMHn3gITTjflhFT93erKmK+6dLza7W803LRcS5YwZbC2VAuDPArGFmBxFLoVA4R803UHyfbd9jfIg4clMoFRkzGuteMzA4aYSoD1yz7vnwLuDLHMTj+VeBW2uVA4tKI5W0XlmN5GqqrNCUpRTwxZTkQ1mLdRxws3KGmFfHCo48gxKDBzc3fArt8C+jVYFAdjfTp/gHbd927HKGGw1AIcTgQ0R3zKcF4pC/XHrZ/ROQQ0l+PqyFKY2oipNfDq5r52cL3OGwl0HO//4b+3l2Ocuz/jp77DnukiwqDDkCv7N1FDzDF+PT908eYPRlnUz8uvvuXnThxofGkZtIsfDx/xNe6Oe9c2RMjTidARX0BAwc5xWI9BKrl3hH5EE+rdrO1Abxr5Y+Kqfad3PW79JrWcpUK/Uv0GQ/hqsqWbCkJFR2bbrbSnEojVweZ1CjlBfMTBvV6iMIN7qtn4dPSEelPYuHREhQaOqEcJsSgmIyDosfLKtnlnW0gVJlgbAM/PR+xSri8Bq38tlJ5JY5AV5cldzkX3S97p7zUUbwwitnCLdLj4t17sHE24inzNUV9mgNlyqZkXzaVO0D0tHKhsvajUTrID83Kf6KoQsSF7PIgskLFhH/GXlnIG/DRweSJqepcakBMhCMQg2mi8fhlMaB+eDHICXVwPHusm+EBa25xUj2L/5IDsstxD5bTfNR2paOE1UisT7x2EuhP9xzhJy52G2Yu6P/zWrEKeQ1EoAl/qn20/TOWcZogrhmUppS8aBk02bPIMn84UowlZFstoAU/Ol4oVpOYnpsbylHx7lJApRPHbPUhV5yS6zsTMl1+0tE48IMRDwVQxNhWZGY5LN9npv6Of3YM5EUHhK2DwbGRliiF251Za4oGcd9b6NTD8rY6vU/YEjMzh2GNKqv
 fOimZqtz
 7r/YiWbj2JMnSXTx4hI0WmwrILIYp8/6kvAZp7389XjPiGfcrSIUjeI3GkzZ4w8v+c0/dOykFTwfbmWh47Oyd8GKI5OqfcfPgjaFtAv5inG9rCV+vNiagE/K+jney6QN5pd23idrQriKhsu1LRrcw0Eg95smikJd+Q2vgbsBPkk1UmYxbuiOGdLUME21owg6E4ECeEPpO//Iq39F0XcVozQ2ijaNA5xFPsDyPfm680YL4VENmUucfPZzo/nLZ0GIf0N+BogdgMZ3p8OxxxPuN/QSvQB/F8pka6kzv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 12:14=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
> On 7/23/25 16:59, Jann Horn wrote:
> > Currently, enabling KASAN masks bugs where a lockless lookup path gets =
a
> > pointer to a SLAB_TYPESAFE_BY_RCU object that might concurrently be
> > recycled and is insufficiently careful about handling recycled objects:
> > KASAN puts freed objects in SLAB_TYPESAFE_BY_RCU slabs onto its quarant=
ine
> > queues, even when it can't actually detect UAF in these objects, and th=
e
> > quarantine prevents fast recycling.
> >
> > When I introduced CONFIG_SLUB_RCU_DEBUG, my intention was that enabling
> > CONFIG_SLUB_RCU_DEBUG should cause KASAN to mark such objects as freed
> > after an RCU grace period and put them on the quarantine, while disabli=
ng
> > CONFIG_SLUB_RCU_DEBUG should allow such objects to be reused immediatel=
y;
> > but that hasn't actually been working.
>
> Was the "allow reuse immediately" not working also before you introduced
> CONFIG_SLUB_RCU_DEBUG, or is it a side-effect of that? IOW should we add =
a
> Fixes: here?

This was already an issue before. I think it got broken by refactoring
in commit b556a462eb8df6b6836c318d23f43409c40a7c7e ("kasan: save free
stack traces for slab mempools"), but I don't think it was necessarily
an intentionally supported feature.

> > I discovered such a UAF bug involving SLAB_TYPESAFE_BY_RCU yesterday; I
> > could only trigger this bug in a KASAN build by disabling
> > CONFIG_SLUB_RCU_DEBUG and applying this patch.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

