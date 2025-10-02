Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86772CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 06:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE8B8E0003; Thu,  2 Oct 2025 02:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685A78E0002; Thu,  2 Oct 2025 02:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BB78E0003; Thu,  2 Oct 2025 02:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48BAB8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:47:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF8551A0239
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 06:47:12 +0000 (UTC)
X-FDA: 83952242304.06.7354100
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id C86EB40004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 06:47:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Cz75y1h5;
	spf=pass (imf11.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759387630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+78RkU0h+ACDThG/YKtx3AblMf6FNLCDnnTDpoCoHWw=;
	b=2bjPJIzu+JnXW293Cw9qwIjSNXblHFe2i9VVMRTK/GMsz6zrfhxZ0Gj1H5EfBt1Xreqz2O
	uUVado4SSgQTZLy/9cTL9CpFrQVafC+XZ6v9Bo6v9hSTeUjITTMD/4tpgJRVzo0nSpYk22
	JTP3t24/hDX4gnQzenR3pCsXwqesd4E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Cz75y1h5;
	spf=pass (imf11.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759387630; a=rsa-sha256;
	cv=none;
	b=73TR15nzAoMqqzhaFqgUD24H5KstK+g8xWJf5TH0FdFIHVLQpZnoksTG4REiaDvhpRcIqD
	ZC6bxPvtDEL70v3N2HQAJHcAWzIOsmH9Bw33XJVwX1m47qRbQTxVPqQLoSYcnQLW4AJ3tL
	wWxtw3133Es8hbTt0Ijpcg69cDCGHNk=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso4106a12.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 23:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759387629; x=1759992429; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+78RkU0h+ACDThG/YKtx3AblMf6FNLCDnnTDpoCoHWw=;
        b=Cz75y1h58KB6CJPG9x3OvRUOYHwR3+sF6xo1q9iDn/Ken1df7gOZ0595FptCphs9tC
         SVSVAuvvB+0DM9i2uvcsMNCqxWGAe2/3PtEsq//ot51GbMcQw75yniD/dkJwtsbLQhs1
         FB8A16SCKh6SjSScl4cbSTbawh9Yf9iIE8umV7pTf+5OHm+NoON9vnrohz/iyO7HyQOo
         BUZqFE1FbuCHwcfSpm3jDAwlv1ZkwLoJQqmn5DQaI0NvtHYc6efsG2/FGtiVXtedF+uC
         Zun+vI6ysI75EVDAChH4tRqTfuaXMq3sJ6zhahcdEge2lKthmRcxX3QI0Er3OrjAfZGv
         dWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759387629; x=1759992429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+78RkU0h+ACDThG/YKtx3AblMf6FNLCDnnTDpoCoHWw=;
        b=uAynANGzFtWdbCBPFtf5TlQHLLqeQUAQWv5F43IEK5Hmcj4l2Eojv7jJcOY5FUm/mX
         rjt1tBakO8V1ge+nqHMyFAZOWrWcRdCuMQwx/3fPkQbwxYprUWKCCeD+sdDGMlzFzxf/
         6QL834W/74wE29RRAL5HFvNRO7aK23b5ysTVXfmmzKbu0hWg7C2mnI8nFSDF/GHBIGwu
         wMrLTFtSnzu/C4TaZ9kwXdB5RxSOMmYYRtCmFh+PkGuBhrYBI+GcnWBEDJKSNHVU1Aw1
         DxioEXlVhj6+tqK7las3jBd2WXFJoRvu3rhUDbYy8pBATCOIogqfZ9Ro2ovZSWM6DtZ6
         igqA==
X-Forwarded-Encrypted: i=1; AJvYcCXAdZB+T8Oz9rUMA3wYHI+4Y0jDYLW49NtDMxVRcQ24Szh76nuq3Sd9lK32dNyuHdrBzgnZld+pjw==@kvack.org
X-Gm-Message-State: AOJu0Yy40pxhwK6RtJyYpzREdLaVKaOMcvL2sWAIKpDXm8dJPSZHtQEL
	Eam9I0PBNigM4SNkOehyzl169Q+qJpC5TweO0ezfvzN6pbGKXDQES8pEU4Vs2QNf+889DW3ncwO
	IanUKnGrjIlft/BN8fhZ0XyNNNqxDWTmKzW3p6RDT
X-Gm-Gg: ASbGncvGKs8bs23GIMsyjs2iBG1WfRtnCJnz5E+WF+u7QgfvZ5EAIgKoLQFH5WMFAWf
	0m6n7S2sl4Ud3WwykGhhqv2sKLpjz13mxxo8I2ah7vTh6cJ46XMQsk0BRl48vkNdzXLj+uUtD/D
	eMaXEhd3RJu7uj+8iTTTYBy2qP2SqSOSGoWcOjCa29z9BVouiaot8ajO2xI91r+rN8GC/lFAjMy
	k8avRUNjGhX44t93lEY0vqnXKYZTq4GeiKhFSAEUqn6uSEfBw21EOVQCX1fBQr5L8QqK0E=
X-Google-Smtp-Source: AGHT+IH4892W8xvfmGJipnQCHyFedM4DnEkP3aXlAVs1mMZnTZFFiK87J/d9YnL4CH+1QGGVKyIgheyklB7L0wO4Uhw=
X-Received: by 2002:a50:d654:0:b0:634:90bb:185e with SMTP id
 4fb4d7f45d1cf-637e1666400mr47600a12.5.1759387628791; Wed, 01 Oct 2025
 23:47:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com> <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com> <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
 <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
In-Reply-To: <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 1 Oct 2025 23:46:57 -0700
X-Gm-Features: AS18NWDrXLXmA7wRK1aZKqj0CPUtlqHSZJhywtP9L9vC3uKTWRDdlTnwdfpyANs
Message-ID: <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Alistair Popple <apopple@nvidia.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, jannh@google.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xybhs4kz45uwk5ge68drahjo57x7ayri
X-Rspam-User: 
X-Rspamd-Queue-Id: C86EB40004
X-Rspamd-Server: rspam04
X-HE-Tag: 1759387630-258088
X-HE-Meta: U2FsdGVkX19jwEX2GmsQ8rFUjsq6fxH06729+8SJnNt0RLazy8xIkHqkSf+iWY+Wc+4Qk7CkbgkcrH+GyRpIDEk49nv+KmmAWG2D1AoJYXuSunWpXDNnS5zZgUA3klwd2Kfje8dNyOZ4+SZm8P5M4ZosVJszPduJxCNHVToNIuX6kVEtUm27pRb93REeDSOb6tvE4w2fVmF95t4rj663LLKwBBu2Hs9pEkFp+HcAkozH6UxZCY3ty+TXFSkeIk51q54Vd/l8Ca1RtJXexLm/v3Yzc6DtUxZWbIFEminMBHeouYUIzDunYoGmCzg7jhKhaZBolEtTrFX2MBhpaJQBRM6zLjjoFuES1c8rHH85AIWXTA3doCrMau7I4mdFCAABKcXxOHQb9GZgQJhCOq1Xfa3C7ZoQ38c/tg0AqUL2aBXKQPXIMOUdTK/Mr42hnpNTJgaWa0D9pE69uN5r79fyVSGZYkOcN6pt/+fnRWqp9rxXi38PadylRVNVbjAHQ9rLYcP2F41B8/tn+sUcYBoQdVk2Emv86x1PMBbAKTNEIczzg/Wq0CzeLQPjpNhNTuRMpe+qFPMVIAi2vJagKZQFa7G4EiWL2tJ0BtwJzj1SkDWb9kQNjwOq5H4+5mjZEghm/wS/+wPu6QWO0cdLXH/QcgTakgJ22tXyqxJWBEbrQGV5KStYOs0IMvnq72Yl8vsLh7y8FhIdEAOvx2aLFz98SAYl/JhBhpeoYGnD3e7tkHZN1x2fSL8tcQYAkWERirsbMhpipOkHVXg0MDTKyIXtiYJfSwIqxyuCEcb+GUD/2+7/vxhSlxlx82WVm9K95LSr3Fiz1ZE2P2zSrb14nStIy4mXKvHX6ncXMNLpGAiJKS56+WbHYp4MhuYw7rolxey77ceQBsGpCHLR7PO5jPXCL7vhvz4P3nnxgtUcxUZejYuMpSUFsV3+m88uX2LX/V3h486Csq6iLU0ukaYhBd0
 43UnqhX7
 csTStsC/gDcaFKzQXf0/v5bKhEVcn9lNkxMazqlJRAxxlrXhVdLnJDia6zLjdzcjr/4na9X1eKf1rmwcjprpXDnvUgMTdjXGFSt8r8RUxXV5etJodEOAYalr69KSbWmUegOUmDAFG+i1pyvSlshbdvYnMyuNKKNHjbqeqKGZdL1efebIkZzPT/nv8gDTxLHmCRn4ZIhJPlspuO8YZmic2zx3dZcYwnXI6bbhFtOd0VAg5ux6jDBvm380TYplbOe1cXuCYEQ0pccfoD5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 4:07=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 24.09.25 21:17, Lokesh Gidra wrote:
> > On Wed, Sep 24, 2025 at 3:00=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >>>>
> >>>> Is mf_generic_kill_procs()->collect_procs() problematic?
> >>>>
> >>>> The dax_lock_folio/dax_unlock_folio part confuses me: I think it onl=
y
> >>>> locks an entry in the page cache but not the actual folio ("Lock the=
 DAX
> >>>> entry corresponding to a folio")?
> >>> Yeah. The name dax_lock_folio() gives an impression as if the folio i=
s
> >>> locked but it isn't :)
> >>
> >> Sorry for the late reply, I saw you posted v2 in the meantime.
> >>
> >>>
> >>> IIUC, a dax folio can't have an anon_vma (folio->mapping is actually
> >>> an address_space instead of anon_vma), right?
> >>
> >> We have these weird device-private dax folios that are anonymous and
> >> should have the anon_vma set up.
> >>
> >>> So, I thought it wasn't
> >>> required to actually lock the folio in this case. Please let me know
> >>> if you want me to still lock the folio around collect_procs(), or add
> >>> a comment?
> >>
> >> I think we can end up reaching memory_failure_dev_pagemap() with an
> >> anonymous dax folio.
> >>
> >> Not sure if anything would prevent us into calling
> >>
> >> mf_generic_kill_procs()->collect_procs()->collect_procs_anon()->folio_=
lock_anon_vma_read()
> >>
> > I must be missing something but dax_lock_folio() dereferences
>
> Maybe the code is missing something :)
>
> > folio->mapping (to get to host) without checking for
> > FOLIO_MAPPING_FLAGS presence. If it were an anon folio, wouldn't that
> > be a problem? And then in collect_procs() we obviously check for
> > folio_test_anon() on the same folio before calling
> > collect_procs_anon().
>
> Right, if we reach dax_lock_folio() with an anon folio we are probably
> already messing things up? Not sure if the "!dax_mapping(mapping)" would
> save us, likely not, because it would be an anon_vma.
>
> Hopefully Dan+Alistair have a clue how this works and if it already
> works as expected with device-private anon folios.
>
Hi David,

Any suggestion how to make progress? Should I upload v3 with
mf_generic_kill_procs()->collect_procs() in folio-lock critical
section?
> --
> Cheers
>
> David / dhildenb
>

