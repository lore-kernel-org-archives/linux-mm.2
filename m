Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090F3C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111A16B0088; Mon, 31 Aug 2026 11:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9576B008A; Mon, 31 Aug 2026 11:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41E06B0092; Mon, 31 Aug 2026 11:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEC4A6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:18:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34101120188
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:18:02 +0000 (UTC)
X-FDA: 85161920004.11.DA4C61C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5819018000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:18:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GENwMsoc;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788189480;
	b=AcwseM4Y1S1L4pXhbWes8dOUQgB7pLCHFoWUr8gy6+lRSMpYW+VYmxri+AIVUDZpSYe8D3
	pxOqaNInqdWbTC8nv6LRDmL2S5kieCnWFNz+D2G7HUNW9PLBPYwA2VfrPFgWtMgt9OxZYC
	qXLgVHIoX+jRnrmXBohUhJ6W7JK5XKE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GENwMsoc;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJbtPwAvz/zM6HluisK0JLIwSett1cEn/TfCd38rpXk=;
	b=UHUYLazjFw3t1aYFk4PHQw5hnCvRRzfKzorarJ7NcsXeZ/rHfRreqU/oJXKbxZyPpMOF8f
	DpCnxACHO3nXaENMbW0TUcBxzViiJtwwmHJ9h/U5fbajK5AsaYSikcHS3df6E281C7uByJ
	n2WmloOi5kX1OxsB7Tr+Gvwrl334gQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3296601FD
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7431F00ACF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788189479;
	bh=WJbtPwAvz/zM6HluisK0JLIwSett1cEn/TfCd38rpXk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GENwMsocGsP8rLt+JAlIF44uiWH4IUpSe/SEKxplHngT2+3FRU1KkFRoj758TaapG
	 bBc0s7iIQztfhvEosMcrDtCbDHAyl2sIfJH/dBXWX95Z8mw2nflPooE6TgyHrdineG
	 ATpEwmBVgC4sH4CPlgnQ83Pp2xabBfkrbmDDW+KrmuZVOAawwvaztX4qCHVyQzPtJr
	 hj5QMw8zxfZajD+jTGKgOs7BP9shI6+d02cdZLRYefRwGoJKyBdfHKUzdPhEfj/QsN
	 nnvGMNK/50GDDFMxHHgBNsOBX4effA1fIpw6bfQ/EoxR6mZSB0jxOiO8HlhaqPK9CR
	 /AJLmztrUGGPA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1c26d7e951so624130466b.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:17:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Robe0q5idAe9PjonIm3hOswJjLo//C/0p6Eby4JfxZj9gSKFDzuhmik7DI0ODiQ1WamsbI7bHbCYg==@kvack.org
X-Gm-Message-State: AFuF++lSmnNlK8DdRf658sd0XB0BRHcnwk9MFeER6s1MJg0vX7gSJsqT
	5YFRymItGPOUzCI+Tth5SvvDNhZujo+jqEugR8St5UU503fZvsgDNrIHNLpFdvJxiY5G/+/f4XR
	Z7z7M7npSbLs55wB0EYeBIuZExaafgjw=
X-Received: by 2002:a17:906:6898:b0:c24:469d:5653 with SMTP id
 a640c23a62f3a-c25b3d2dabdmr70154866b.21.1788189478343; Mon, 31 Aug 2026
 08:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
 <20260815-shrink_zswap_entry_0815_v2-v3-2-0171bd86a667@gmail.com>
 <CAO9r8zNFYM1bry0DwDRNtpnEL9yyXQ3h=1wcLbGsO1sFtGgvjg@mail.gmail.com>
 <CAJxJ_jgihBLy2mbPAN-uqup2mGq+hurKkH=W4RGo4Ad0Eki5sQ@mail.gmail.com>
 <CAO9r8zP6+6jZ7qOxOy1fyd=UgR3yYP20Db9KghW1zJ3bNqoREg@mail.gmail.com> <CAJxJ_jh6J5N0vbFfi2139vnTVZEECJoq-AV4VVNew6a0Bkwk_w@mail.gmail.com>
In-Reply-To: <CAJxJ_jh6J5N0vbFfi2139vnTVZEECJoq-AV4VVNew6a0Bkwk_w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 31 Aug 2026 08:17:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMr4bnWHzO97R5ZaxALDf_5688DXv_LS3KZ5rz2Noe_bQ@mail.gmail.com>
X-Gm-Features: AcwNN1V5kf7rBHXxF6P0OwPPKGwOwsL_c1dhEnoPllpp4bh-Yhr3iIv6RTFovz8
Message-ID: <CAO9r8zMr4bnWHzO97R5ZaxALDf_5688DXv_LS3KZ5rz2Noe_bQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5819018000E
X-Stat-Signature: xsnzm14z875zpfn87pxybse9rp5tbpb3
X-HE-Tag: 1788189480-160456
X-HE-Meta: U2FsdGVkX1+XSESVjZrFjlOpYq5bWsixQtW6nW+ysAyKgKTNXvdlSxAmw4g9rJqFCt1LAEHmI/q7lFRMRrObRbqX1fJPiQ71toDZ4aVQDd3L7c5HoR4p4x0vTDeN8bVaGYIbZJnmeWq3mZgwkUksu4bKhDclrygVu5qcJd7TPlaO/mhQDgZ4fu1EfleTR/wPpBJloOmeKVbmHSZPUAQS5p8tKJWUKQYxc4aNUK1FQlDW0nQ2AgrZ6ttRjXgSfI9is6505c4hrlY8khj6H3ni+xeZcCMuyjTLhJ+Zn0lKPIcTyX78DFbTcWKX/rqY8tunSeCGN4a5WZ9D4T6N/5pNyEDubevBn/ZP17wxgjTu/J5qXZSFj6JU6QFKgtmLev2RaszVmrjNbB2va5LGrhIpJt7fW8aLjFr91Vd0C3T/AmLa/jErD3zF3d7yopCvRKW955gygN8yfYDDdheFB8Uuxmk3+yZnRV7TmpFVNHMY/RfU0/Lrn3EKK8NrJewFuhU6rQEIoPJTw79rZsDY149/WcSd/DCepFSOBw7O4xMGvpHd8I8S2oBAIKLXpOb5eQfbYQwRYKoqNqfoG5UpER8V6UTVKKzYePZHiVNjbJHBg9xLt/uWbbhsI7Q4EtWT+LVKp6nDftFI/G1o/mD6Bixsb4UlVz+Cwc8plkK4RuVGI41SDMLf15hc5+2Kd7Q8VVT4mbO51aAJ64QSBC+gU7j1q02wRZipuxtCKCr94gxl+PpMlkg5pydK1TAcQ5C1bN/UUZfDFunQerLtZtDEJTBUCMDx45O4vy7LZERPqq8LleJSVLZLm82WCxj2BKrIhwErXH9mVtdkO4mPuavhGIMOV/+RIv7SChNbB1T5smTrTxxqcLOZ3W6g+wpGaJQv8e+7EeD5MZaYEd2UOXyxUtCzucKbQ5ix6Z2UuHFnXKrLhYWTrrSgZZwlJHuvAkBuLzBL3EyPOae6LnFRA6ItukQ
 d8rQQlGA
 ZgVte2yBn5LzB/R0C/o/VrChpAAkzJGBVfO4GkOKoC8S54Md7snrWxLg8fWUUEbIkyyYiRAdtHCcuKheXVlEs6M/htuzZHg+LsYPvMx/i+S3zVNyvR9DMoA8PhJlB1ZLpaux+RlrHb84PXzpa+mhDd0j6Qd3Sad9VlL64eLWYu93aXp4anhgsTEhQWAK8FQcB3zlxaPuaf0YSqWj2HGOqJTHuxZSDRpXwXyOCj+FDZQmlLOPSOhL4Pw4tnOmCWnLurV8H+KggtkZroHXdN12sGXAm0iurhsGSC/0vW6TAyL4cUM3FxRrqDUFgIz3Y2ogWRXSTKSBpxhyIAcqi8SXE4Kk8A+XNScxdBwcI35klY4z2AyY/al7yQ0C4vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 5:10=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> On Thu, Aug 27, 2026 at 12:56 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > Makes sense.
> >
> > Actually, this led me to rethink the slots reservation mechanism we
> > came up with and the issue that Sashiko brought up initially. I
> > initially thought it still existed, as two racing threads setting the
> > compressor could try to resurrect a newly created pool. However, I
> > realized that's not possible because a module-wide mutex is held while
> > any module param is set. This also covers zswap_enabled_param_set().
> >
> > So IIUC, we cannot really have any concurrency here. Pool creation
> > either happens through params setting (protected by a module-wide
> > mutex) or during initialization. Does this mean that Sashiko's review
> > was a false positive and we can go back to directly assigning array
> > slots at pool creation? If that's the case I am happy we can avoid the
> > complexity (but sorry I led you astray).
>
> Thanks for the patience here. I wanted to check the details before replyi=
ng.
>
> Agreed, and I confirmed it. param_attr_store() takes
> kernel_param_lock(mk->mod) around ->set, and for a built-in module
> (zswap) that resolves to the single global param_lock
> (KPARAM_MUTEX(mod) -> &param_lock, "Protects all built-in parameters"
> in kernel/params.c). So zswap_compressor_param_set() and
> zswap_enabled_param_set() are mutually serialized, and the only other
> pool-creation path is single-threaded init. There is no window for two
> threads to resurrect or create the same pool concurrently. Sashiko's
> concern was a false positive.
>
> I also tried dropping the slot reserve and went back to assigning
> the real pointer directly at creation. The only invariant that matters
> is that the slot store happens after the pool is fully constructed,
> it's the last step of zswap_pool_create(). So array walkers only ever
> see a NULL slot or a ready pool. zswap_pools_lock
> still serializes that store against a retiring pool clearing its slot
> in __zswap_pool_empty().
>
> I tested with LOCKDEP + PROVE_RCU + DEBUG_ATOMIC_SLEEP: an e2e
> store/load workload + compressor switch (lzo -> zstd -> lzo) that
> exercises both the pool-retire and the pool-reuse/resurrect paths. All
> passed, no lockdep splats and no suspicious-RCU or sleeping-in-atomic
> warnings. These are functional tests only, 2 writer races can't be trigge=
red,
> since param_lock already serializes concurrent param writes.
>
> No problem, the discussion made the concurrency model clearer, and we
> can drop the complexity. I'll refactor the code and send out the patch
> in the next version.
>
> > It also makes me wonder if we can just drop zswap_init_lock, but
> > that's a separate project. Most of the zswap init code needs to be
> > reworked imo.
>
> Agreed it's separate. zswap_init_lock guards the zswap_init_state
> machine and coordinates the two zswap_setup() entry points (the
> late_initcall vs. zswap_enabled_param_set()); the param lock doesn't
> cover the initcall path, so it can't just be dropped. I'll leave that
> out of this series.

Agreed on leaving it out anyway, but doesn't zswap_init_lock guard the
same paths we just convinced ourselves are already mutually exclusive
for the purposes of pool reservation?

