Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A187CD711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11C06B0088; Thu, 18 Dec 2025 21:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEF06B0089; Thu, 18 Dec 2025 21:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2476B008A; Thu, 18 Dec 2025 21:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C97A86B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:35:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EC3E131E3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:35:45 +0000 (UTC)
X-FDA: 84234655050.10.17BAEDA
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8D1461C0005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:35:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ddw7gNTz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766111743; a=rsa-sha256;
	cv=none;
	b=B4afI10xzEsCCG6QlT5joEpyYs/6CmgGDI1BaC1lSbbCFcScodjOoOH6AMzmwD5eZ8OIan
	iMyuXl9XbiuYAj8gDmXgT9wF+s9sfdek4txYte0wgy29cz1sC0Pw1XGfg9o4qwBmOg1hh3
	VTAf9Rgvrq776zkwLVVrJu4OW53uH34=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ddw7gNTz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766111743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRH99PRt5G5xzqNNPLwmUFAeEgzLcFZ0F2NTmAJQuXA=;
	b=BZ3sOhTBBVFqtF82iyjHWpV2tTD7tB6cvBGb4/wPWagDpSlMpc2R2sgmLFO1AaxryN3keC
	1qyvxQ/n8QETKq6RDzAPOnEi9sXgVbUZIJ+I/dKnr7K+hC+MBwgSd6RfOUHgSCRve25zzX
	/Skw+6uV37drA4m0STB6P+AwH+sNTO0=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b92abe63aso704574a12.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766111742; x=1766716542; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jRH99PRt5G5xzqNNPLwmUFAeEgzLcFZ0F2NTmAJQuXA=;
        b=Ddw7gNTzdq2J6Cj0vjoC7C6KWHnvVIZsVS3lXropJwzF3pnHaEs7FZqfzNazUP5ez9
         nOdRgmrgpo14KxmfZAA1GzBX1gWuPVm8Zov78eXkGVXim6iykqE4RPvigq1uVc2q8Kjj
         6A0/vIdMnxgpfFSaYpBOyd+iJRC0cjQnTT37AsaTWb9+zRIDWtkB1k7hmj7lT++d9M7y
         EGjVkbiXJtYsGDRm5H6Hof/2SQ35KPmhyPCdPyRaEpzXSWGQ5Y50HJ/THXdxsrYcOXAJ
         L6eN7g90H93pOX5LqEmfdf/MLoDnylyOg1cBpmpKEXH5sJJzMkxz14twWkaZq/QiBwo9
         K0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766111742; x=1766716542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jRH99PRt5G5xzqNNPLwmUFAeEgzLcFZ0F2NTmAJQuXA=;
        b=WixiZw1gUQTdCGDI7TE5Mc5Ygg4K15X3qAt02mDeldeUJYVRoFdCRerEr3JvE0W1E4
         0k8X8RLdfKrFaknOicCd/fiUFmuNFiTiyVrX7cSZLA9xiJ7z8+1Ssbjuz4RO1E09o9ip
         7ynoXdw+cAMcTIgXbXNhgJ8BFOOvQpA+AJrGRc6rQSN083fPuBEAVFbqkvo+iCtt2XfC
         jjWQmGNkecU5R5fcZKq01EKUdn3sODz2NesD9QEZYaTXTmHOEkHKfXZwFhZW10E/Bqzd
         FpdxmAJVyshnMPPquJBc7Uhgrk02XISQ1eVDJiFFIx2B44Pr+nBHVQ6Lm/2SpRG7K+Bs
         uiYw==
X-Forwarded-Encrypted: i=1; AJvYcCXtP7jFLDoYqNo7m/jnaftRfqLXm9h+ICUMTRqJJ3QqULnE430fAQcQPcy5FXI2vl7U5NQYWX2Mag==@kvack.org
X-Gm-Message-State: AOJu0YyjCVx13AYW3rVISchPLhAlQTxRgc73srAKyhQGIyiE8ETf8YYv
	tZLH83qxsWd+2jjqFSsTXQm8s8qntBNg7J/20pxS9dHFXogl1VEnV3fwEyE7bh8h57u5vg8AVt5
	NQ/FIDiQnpZG20MP8hH+TU1kb/5TAWOc=
X-Gm-Gg: AY/fxX4rHqGG6eVL9qdIRiMk3mOrbJfKckGGFJCbR0egMPF32ybrDj/E+pQmKt/w5qc
	JKy6QVlr6ezseY/TJM4roMRhwCZRHaryAN1E6T/NFbxK6Ul4HHRDc5j3DT4yhNShNRyHsZYACDQ
	XOdCwzHbyRaXb7Y8rV+sIwxLJKxpy5hFvLBQMi4YrjUfPVxrCHAcnnVtzcGfruq7ta1bw+83PYp
	1KA17exLypbMwyHkBqev0djpYO57HsXRWN3Vs7HcZaXTNrOXzszgf83UvUNFn7a6XaZu9YjXtcy
	PFBWLZBmHTDPSUICcdk/XrBjAvyekag=
X-Google-Smtp-Source: AGHT+IFxi+kRe2dMmUsfmW3+z6bYkdcoprxrBmd5v8jzkk2f0+sY2037jR7F8caL1Fe7AT1zC4pzZp14vFRdmAoeQm8=
X-Received: by 2002:a17:907:868c:b0:b43:b7ec:b8a1 with SMTP id
 a640c23a62f3a-b8036f28da0mr142797266b.24.1766111741658; Thu, 18 Dec 2025
 18:35:41 -0800 (PST)
MIME-Version: 1.0
References: <20251216200727.2360228-1-bijan311@gmail.com> <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
 <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com> <a47adffe-b2c6-4d86-a970-b31c2e620146@kernel.org>
 <20251219002134.uqgtnr43zz7vvvtd@master>
In-Reply-To: <20251219002134.uqgtnr43zz7vvvtd@master>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 19 Dec 2025 10:35:05 +0800
X-Gm-Features: AQt7F2pkz3EYSsFGi9H09hMpKNH71EFGtYJbTTOyn_amDCe-dJHTO1Ui_Ub3mKg
Message-ID: <CAMgjq7DU0U3RVw4cuFeNSSmTWnOmvRF9bQn5oaeZUOvXTVTdYQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in folio_expected_ref_count()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Bijan Tabatabai <bijan311@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shivankg@amd.com, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D1461C0005
X-Stat-Signature: kr7t4t6648z74m8c76e81xm3uq3fp5gd
X-Rspam-User: 
X-HE-Tag: 1766111743-670769
X-HE-Meta: U2FsdGVkX1+yOXWpfbddi/Zp2cD1AvTzuOhfR8Y8zP6Z+usRRzV2krJ5aFD5Uoopc8yVrm8UCMNzehCIIjbwedh595HH93LTzv/zwMAylKXVukFYDLkqhZHVQih7ce4oSwQJd7R1342z99dHYern+0s5ScPwyTE+/BmJKoVI2Qn0jBE7z30jD6Ekm2NuDjBX+XYXzsS0jaQ4Gv7ApbyUaGNQDEUEITHzfDo1/ekHzFnHlEQ35hIj6fnOQJfMX2EjlOCaxXX7CCkMc2Ka8y9O9B1Cno9aj3N+IZ02ZB1sSRLw32nsDLDGnNYavBioLIo+rUP2vtM1T9KOLrR86smmEAgOUD7sWOD+/itIrF04n6i3kQ88kLc4vi6BS19NfH1YZWlevsNboEfBD2MEddHHGkE7DhYymtlE6/It9skPTXld7JH4DcCmpqtTeXI5MY8NQ5lx+OvUY72+r8pNz2+HJY9EyyRi1VVIsgas/w3MO84BNG+skK25pum9YTq20kBxUsv2D9mTvjQEP8iLfEdfxNfgHFDVKWxfxqqEwezUS/fQL3cdQSMgM6l1Hk0KaAr+Q5iQLiZ2uHta6j3cshwco2Zng3zxBnmr90FihPx+UR0+0sL3i79LhB9iDE1A6QKAXgHKMqXfc6UMyEAx3gym9ugR/AjCRt2T2mv+KrL/KvQTmtvZGhhjjzPKIxF6rSJp+UL8Q9Ph2+OhiXgMmLdhqTLKT9t65+hdEN8NKsJRMSMjbWEFnawYGijUYtcqXhkzQGAWsAvsouJFmyh6769y/LORpjAXbuGqNN01Lic1MUi1VQKbMPIxky3/AIAFPdzBaIKiGBRDeJBITdnCkD/4z5IY4PIvfX3ycGcdYHPFFtJ1hKIORQaJtE/UB8/YfsBtMYnInXlFCsXxSMi8U3Tz9uA2p1wlQ7A0HKI6LH9Qek5tIkj56PcnR7d3k1Bto5HpatTty64K70zzUsu/r/P
 Zp2hNgto
 4hVqkJmm+Qo3CUIo2ZzY1m3EwI5WLl3q91F4Ui43Jvng3mocxsQP+yclmFsll9BH6QIIdzlJar2KEh9NBS8DA/DZqFGk4AgY5EzL6KgtcEWkfyF8PJkCGknQbHsTFX2nUZjep1jX3BzE7FbJux3tKfrm4TZoYbo27RoxPNOdMYzwRy6xvtUcIbZ50bW4XssmQBDAoHtR8/pdag6MN2MH9F7PO88QrS9n5Usrq6bxEBjrYBVhlOUxh0Ww113Ic5U+L2nJqC+6YdIi4kaUI269EZylmnGA7BWU1OfOS5W5FV8Q2fQRnYLIZnbfJiSKG8t1PKgQV9AEhGVfuqcYZBKK37WnDzJ5aC6SBDCu/cqlD+nofEPMp1ylO+3snDFawJQTAc0seRy1iJL8oJt/Euxd+mgNo7MgHq1vrhTUOnXgbTV0lQ1M5Wnyl0+d9lsplDVFqHsAHaHd/ifHYuUTxEdcnWGjmdJj94JT1pKnWupY/43Gn1rudVWZ561XlEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 8:21=E2=80=AFAM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> On Wed, Dec 17, 2025 at 02:04:16AM +0100, David Hildenbrand (Red Hat) wro=
te:
> >> > >
> >> > > I am not very familiar with the memory hot-(un)plug or swapping co=
de, so
> >> > > I am not 100% certain if this patch actually solves the root of th=
e
> >> > > problem. I believe the issue is from shmem folios, in which case I=
 believe
> >> > > this patch is correct. However, I couldn't think of an easy way to=
 confirm
> >> > > that the affected folios were from shmem. I guess it could be poss=
ible that
> >> > > the root cause could be from some bug where some anonymous pages d=
o not
> >> > > return true to folio_test_anon(). I don't think that's the case, b=
ut
> >> > > figured the MM maintainers would have a better idea of what's goin=
g on.
> >>
> >> I am not sure about if shmem in swapcache causes the issue, since
> >> the above setup does not involve shmem. +Baolin and Hugh for some insi=
ght.
> >
> >We might just push out another unrelated shmem page to swap as we create
> >memory pressure in the system I think.
> >
>
> One trivial question: currently we only put anon/shmem folio in swapcache=
,
> right?

For swapout, yes, the entry point to move a folio to swap space is
folio_alloc_swap, only anon and shmem can do that (vmscan.c ->
folio_test_anon && folio_test_swapbacked, and shmem.c).

Swapin is a bit different because of readahead, readahead folios are
not marked as anon / shmem (folio->mapping) until used, they do belong
to anon / shmem though, but we don't add them to the mapping until
that mapping does a swap cache lookup and use the cached folio.

Also maybe worth mentioning, swap cache lookup convention requires the
caller to lock the folio and double check folio still matches the swap
entry before use (folio_matches_swap_entry), folios there are unstable
and could no longer be a valid swap cache folio unless locked.

