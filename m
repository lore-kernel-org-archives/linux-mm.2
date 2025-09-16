Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9287BCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D918E0024; Tue, 16 Sep 2025 12:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F0E8E0001; Tue, 16 Sep 2025 12:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFF08E0024; Tue, 16 Sep 2025 12:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDECD8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71B3E1DD45C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:38 +0000 (UTC)
X-FDA: 83895581196.12.FE166A7
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81098A000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JLNc6WTl;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOGfEho2lxDBDt+dfHnFZdb9utqA2RtE2i1pJMhS6N8=;
	b=helUob2wJ9TQ1y0pyKdyrX/tqpaSRnaT+hSMo3w6HDmXx/zCTtbgdDhhDu/r/pql4X3k6c
	zLMFGdr5PbfiEcfUKwSoLDrmyivWoC08k81wXmIfK/8P9w+y7F6RLcs2gUVENACyAjtvlz
	HAMNGEEHKWHy7r3IQ6TAXyOxiM9N65E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038556; a=rsa-sha256;
	cv=none;
	b=R19AM6x+f9/z77rEahi/E6Hbjcm/XD6s/uehkiEM43JxQEg+dNdfNu1r5LFp62cPibgA+t
	BZXIF2IljZdlNnbuhPY+JPkj3nLbSTBtmNDOu2iq6WdAG4IwBfggJoSCEv6D3oJvpDeBL1
	tmE5dbIG41iTT2gQUpJUjb7RpbISKqU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JLNc6WTl;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b4bcb9638aso542181cf.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758038555; x=1758643355; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOGfEho2lxDBDt+dfHnFZdb9utqA2RtE2i1pJMhS6N8=;
        b=JLNc6WTl+wK4JKDeEa7i1fEOD+Zt75V63lhr3bfQUBqjewP2SpUu35My6icg7vC3T/
         p1EfOKn2bTTdCo5SOg9ctztS+s+xgKkR02Wg7USrc729XxaFYte1s6T/e/ZYQmOmQv6H
         0D7QaI7aQx7ueB64VBfuCz9Vfsijz5X29HALe2wqGWrFHCO2pF7qxXurA+IPo4PtvDKg
         Y4b+8EjeS9OcpQaPtnZk8lDa8P/mK0uRXkUyPXGNdxYzybLPTPzHcy2Y1qErg1feA9ps
         mW2yo34i7Bz+JGcoa0tX6Z1sFbjM8fhQLsnIHoxXeaGbpxIcvWMw9KgLQ3Gu4WBbevgc
         mXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038555; x=1758643355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOGfEho2lxDBDt+dfHnFZdb9utqA2RtE2i1pJMhS6N8=;
        b=VenzfgoMwXDLbrmi9/LuVMPRxDfFvO5hyC/1UACZgsAGYNoH3/L4psu5VyDx5u5/Tb
         NifkFlv+XG5X95odAqM+8vYEgP8dmtbYN85W6RFXigY6mDEvKV5bRyfVdsDL62QTUU+2
         kFGMJcgI5zQAsp9OgEUNlDsRIn1dLxc/H1rjSc/w+gjVwGjmDkJxERx42xnyJG8ThNn4
         yV7L1RlfA0B+OW0X21p5vWwc0k56Zzm4HdQ/eBznyb7aynk1lBDxTc0G+4AR8xy3gwVn
         +agsx4m0C/2R35V0odhkj2Tuowx7JH2ixvmO9noSYztLK2k8ZqHfS3f+ZRub+kLeHpff
         w/hQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtzNvgOWHb0i95AKkDrPSsJBlFo98lHGVDpIho3AdFmZqbiUG3ko5Ok1vLDrw+T1SxPC7xGLE4eQ==@kvack.org
X-Gm-Message-State: AOJu0YxjzvVLaXlkH/QAQUFQGLy2nB4z/GSr0GJLFAgHa0ao1wfieAUO
	wOSUp0BIk8habMU4VnM5a//xtWe/sBq8MFdr29mOZ3gRBIEswCF/z6JNuPZqNG1bavNDlJvwmTe
	qqGC6EFd1iL5EUOIdCGICnZ9n0KEsOLNlFal6BnyK
X-Gm-Gg: ASbGncshVPL6eQ2amY78oQfPzf+SeVw0YvqEkWGmQdfmM+rAV9y5lGRQ7bMvQH7slzg
	a1NHp5BQWqM206mnPkCwjxhRyUh0O3U42mR+x5zKMPsGlwxOrrq5WNmkrdtHC0Cc2uA5RJknnAC
	q7YnhS8Wu7yEYg+ZiSkW0V5dnvaL5z3LSw7XYs2Nk3ST0fGFSrw0AZmOR0XyPc30XEa9aE9lF7h
	76kzBqH1zz616iqxHPV5Hf7iAUQoz7YrxbLoKM8HtZG
X-Google-Smtp-Source: AGHT+IFrvIE5klPLjtgAcRRwXahOqbKuS12v1SX41CUBYbkgKcxIRfBt0vMkeQV4TW2WSxuZyLvtourtBQzZChO5rcI=
X-Received: by 2002:ac8:59d5:0:b0:4b7:8de4:52d6 with SMTP id
 d75a77b69052e-4b7b1bdf823mr7027581cf.2.1758038554773; Tue, 16 Sep 2025
 09:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <20250915171112.f71a7606a7f9fd3054662bed@linux-foundation.org>
 <CAJuCfpFQCgQLSrzfVjV+J4tkYbOx_W9v-kWmoo-rmh5hs9gEXA@mail.gmail.com>
 <20250915195633.96236cecebd8777243a770bc@linux-foundation.org>
 <CAJuCfpH1JW8vwOFF2H2SOxZqoJHadXsTc6C=LUS_=twcf=k9qQ@mail.gmail.com>
 <20250915212133.de5b8522137a5ed30efe956e@linux-foundation.org> <CAJuCfpFonUPE0FL5XGm0paYp9ZXeAKK6mjHO_8hUkyxfyduL=Q@mail.gmail.com>
In-Reply-To: <CAJuCfpFonUPE0FL5XGm0paYp9ZXeAKK6mjHO_8hUkyxfyduL=Q@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 09:02:22 -0700
X-Gm-Features: AS18NWBBsyvMb_SnYAjyDoVzFBtIKASw_yt6BbU_ooXkYgjsNjIX79eMvqtS-Dw
Message-ID: <CAJuCfpEGpLJMTDS30Z0xpurbxtRS2LKx1G2=u=kPknpBrHK6jA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pxhp8y18e49ewajq1re7zjmc4f8ui6xi
X-Rspam-User: 
X-Rspamd-Queue-Id: 81098A000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758038556-809986
X-HE-Meta: U2FsdGVkX19NPY6fgAtAv6X1OSUB25D68r91Flsrxxndr5JZNPF5EbyWFQ/gALLt+1bnzO32vf7MJ79qGsh9rdD9nu6B8yIqQFlqK+IrrJVRJGnZ/K/zK7I5G63hABSsKcdaERnGAiGepgjxgQlS+KUkFMQp7FQcgFlz1otWrhy8lPoGJhpqAOZFl8hqJX+/P9MSUIZJO8hy7rkORWQB7WhwUldC1dS+8Z8EG7JJ8m3Ojad80jGDWtJ4czRfPmhGYk30q4abkAdVPJYyCiyCiq05CcbpH9PbKCRek+Ng4Z3uf9g23cazQzMYSyx0KBZZqlaUGEbkUmloaI91zSURmUTeGYPanZi7q5fTKQIyNdoa4BJplc3MIPCUagLuc4jkxLeA1UdScwuquWyhgXW1bgD3PRVwtDPu2hIWKiXUIzIf/gEhTZma5hpxEYxNglFGsK2UNhBCaOugTCAmOzytRHuRIEEEqSrnbzYTFq6E1iMwkUns07sLMM3UK09mZIpiMXvmoC9D9Gzxg8MXxgEPbdcisr6pln7XR6TGbQGugkKACTgFJpcUA0I5Pw2ZF/+Gko4YH36ZzXSUToi6PZlMf9ywGckVu2oLHeSWZlm3bCXLk8bWAOWugea8oW3xhfv3Oj8hc4SOJf7qPZH7rloMKecSnzKTPLN0ZIKRHCPou+9MO6CuNOciFwZdpAM8kcaBVgPQDY5VW3zy2w9wZ5bPqNJ/Xz3nDBZLVdBa42YkD+OmoPMGUIQEuI5APwPHfoWiPEwa5+rD7gMs0CYz6rAlWbA3OEyuM/qjYy3uMd6tUe+MmsFT2BXXWBVY6WwqCnP3mxGAIFTar88VJAIihrKWHFxgjEraOmv9fWcV2iPkp8F0KuF485aSgLo34rZgHq3lOt0teTBhPEZbPW9ZX/Ug/Fzu6ZG0Zq/9JzArL0DrRpI3TBfNblly0SgqyJh8ZC5mlxOX2bhOJBb2DdOUOGD
 /xMMitrU
 xkE8r9LLXiHvgrVKnB60x052zPGgPkxEWo7c2aqk1mmXH1rZ5t18wxZpjS44Bu7yufxVOYybi2x125xIDQtvvawe4k5p+/UMBB5ifiHqItB/1QxkJDw9hNTsCQdXvCcuslSifzuQYOrSc2wcEDJgaQM6FJO8gKFUnecqFnu1RMc9KEsHPQrrxKs6Q3cuuyYCAzV5fGUTCxOG3sOVBExPZSyLZrtIOLS8tbfp48L54GxPiHxz87j89SgCevl2CTp0/3alYe5csML8/xwz6eoFxc0/nvS+6pEXWB3SgSs5/2TKYs5mCkUz+u4Y5j7wy9K54jAFTW1XnjFOLGxPdf7qA72RLuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 9:39=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Sep 15, 2025 at 9:21=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Mon, 15 Sep 2025 20:34:33 -0700 Suren Baghdasaryan <surenb@google.co=
m> wrote:
> >
> > > >
> > > > > could you fold it into the existing patch or
> > > > > should I respin?
> > > >
> > > > A little fixlet would be preferred (by me, at least).
> > >
> > > Ok, should I post a fixup patch or you will do that in-place?
> >
> > I think the former, please.  Your intent is preferable to my
> > interpretation of your intent and we get all the nice patch metadata to
> > track everything.
>
> Will do first thing in the morning. Thanks!

Posted at: https://lore.kernel.org/all/20250916160110.266190-1-surenb@googl=
e.com/

>
> >

