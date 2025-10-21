Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07328CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE368E0003; Tue, 21 Oct 2025 12:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587E08E0002; Tue, 21 Oct 2025 12:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476668E0003; Tue, 21 Oct 2025 12:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 339E98E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:44:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B774E13B5E7
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:44:08 +0000 (UTC)
X-FDA: 84022693776.07.AE9BFDA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 01D1BC0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:44:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPrCn0W7;
	spf=pass (imf28.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761065046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnZSOAVMKEkF8DgY+Fx3pHUy6vCFxXk/5AE4e+Z/Gr4=;
	b=tyqahqU2eErdVbuCnyekbxZwHiIHguGtMnxst0rq2iMXdyWH2VfxBk/U/bAlRdi9Xx8VGP
	QlguHRIAghjdrTI1vRaOGEW6gjBgOXretXt1jrKt18bOAHC91IySW0Bcqgui1Z4jthCrPJ
	X9DWXEq8HlUf3EWh9vd7zUsEBsioQyc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPrCn0W7;
	spf=pass (imf28.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761065046; a=rsa-sha256;
	cv=none;
	b=2/uqj932kZhrjn+RxYkuEGWzRxTuHhKBypeet8fLi7muqecOh+sVv9reMVuGhXwz0GtItM
	Mgjv6YUxaKQnDhbWEt26fTUqSp8Jm0hiRjQFxpPACCbx9XlRctKNTk9nSRHYI8Nhs26gtI
	OZdjvXbzjM2ONjKeChJWg89TEIynen4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761065045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnZSOAVMKEkF8DgY+Fx3pHUy6vCFxXk/5AE4e+Z/Gr4=;
	b=hPrCn0W7f1kPfJBL/gHXFkLJp65djRV/R+4F9saqs5UCDCbuUSiAcIhNh5k3wFNOifDYls
	GixyQq61gdIYSMe2DzUne9F2EbVkNP9zlWNR1EpNfSM+Lbwrzfek/OaCee6rjmz5KeaeyX
	dYAXbQOeRfhvLZFBpjv0R5pTr17tKwQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-pnnR6a2TPAiDjuenvIyeeA-1; Tue, 21 Oct 2025 12:44:02 -0400
X-MC-Unique: pnnR6a2TPAiDjuenvIyeeA-1
X-Mimecast-MFC-AGG-ID: pnnR6a2TPAiDjuenvIyeeA_1761065041
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4e8a3d0fb09so1542781cf.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761065041; x=1761669841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnZSOAVMKEkF8DgY+Fx3pHUy6vCFxXk/5AE4e+Z/Gr4=;
        b=hxu8s+mWrUXcSndvadN/jpFc+9ZIj/j6CMG/Kx6hQMokenDthSYlDQepn5f7woE174
         alTu9ondfRsVpY5YS+jPOzGpb7V8p1dq9UHgSE/Lgj1o8w6K38HpQ/N5g80OhTM1K4cv
         cpGgAoRq81oDkwZMP+utelWOVrSanter6NCBjzDoDhXyF7+4Bj9JyViZ685rzxXu6qyk
         ix+a9eA0Lr7iDCIVTRiGwgACbssoerFw8f5cCadER0qNe8YDyoSemuvO4i4xVmqcgyT9
         ELb8FXLtITJZIderdDdhTEHG+vfDOU8cpc3Ry6+0gZ/a57g/qC5KZd64JSlVvGUhsT/+
         Bgpg==
X-Forwarded-Encrypted: i=1; AJvYcCVuybcraI2IW6H6Yv3jFY3LCDohzV98Z9dL93kQZRg6CydpmAwkkPEv5VCMrnuyebQN1JnoT4ntwQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7Xmge8KQSyCgUqz0ak0/S55WaBb+LlwljAjJgDJIaERwgmeLP
	D7H/UaXkCyxue1Tv8H1BvNCB1lVf31CS8OEnrJQHhTZdqBwyQmOCcRq4qiVBE3Tdovznp9Y4dpR
	PcsHXxfmzgiNEQZLAcdpeVZpuRetNOm5D83UyPDonN4rVgRi4+tBobqicaaopkt2AQOmusnxs4q
	EKd2IJC7YQDzhLuEmN75L7xaTQElQ=
X-Gm-Gg: ASbGncu+w5xpXWY2/mFJGHxFPWXzn1XO2Z5FQsLED+MDY4igfGSXdf3l1jY2ijCCC9r
	9OYQNtAHjeb6BKskpameti5ES3ts1vdTpOWUWUzFm1xd1N6wgLSJooyFYq58ej6kbfcWxs7LHwe
	AfhvKcfeHLQI9+4HmjzSmqCgIvT0V/0qTe3tEF3wKkdAI8Iu4dX1h2LTqob1OuDbInVSIAspvgy
	0WiJqVmL9Zc7lw=
X-Received: by 2002:a05:622a:8d:b0:4e8:a8dd:9ece with SMTP id d75a77b69052e-4e8a8dda588mr204964351cf.73.1761065041350;
        Tue, 21 Oct 2025 09:44:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAfDFlGk7bvGv6JgbTw1zj++uENryqhdqzCaeJw6qYcicQPAK2zyOIVO/t/8no07sO0cLtemg82e5bbZzJhxI=
X-Received: by 2002:a05:622a:8d:b0:4e8:a8dd:9ece with SMTP id
 d75a77b69052e-4e8a8dda588mr204963971cf.73.1761065040848; Tue, 21 Oct 2025
 09:44:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <20250910170000.6475-2-gpaoloni@redhat.com>
 <878qifgxbj.fsf@trenco.lwn.net> <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
 <CAB=6tBQP3aCDWch4ZcEYMqFsJ4OKXSyC_hb9V9hA7ZZty7vFeQ@mail.gmail.com>
 <042629f9-f295-494e-8fbd-e8751fcbe7c0@redhat.com> <CA+wEVJYLF9T21-V2k0Y0zxcF0zcRG64QUVrM=qHDWHz7+4+ptw@mail.gmail.com>
 <dafcdb6e-be12-4b86-959e-8510a9622358@redhat.com>
In-Reply-To: <dafcdb6e-be12-4b86-959e-8510a9622358@redhat.com>
From: Gabriele Paoloni <gpaoloni@redhat.com>
Date: Tue, 21 Oct 2025 18:43:49 +0200
X-Gm-Features: AS18NWCBpqAbisvSgvvqFRL4j0rCUfXKUoQLmxvhLRhTM9VY1KibLNsIgwn639M
Message-ID: <CA+wEVJZS5GErRThB7wvQ5pDoVo_j=pKD4neN-U2qJEnTgHRYXg@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
To: David Hildenbrand <david@redhat.com>
Cc: Chuck Wolber <chuckwolber@gmail.com>, Jonathan Corbet <corbet@lwn.net>, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, gregkh@linuxfoundation.org, linux-mm@kvack.org, 
	safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org, chuck@wolber.net
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: W5cmg35P9_MgewpHikWIQybkYcVLtdXuhdjiEaQ0UBY_1761065041
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 01D1BC0006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1jrmuan68upstpdodhx19nn166fafjnd
X-HE-Tag: 1761065045-204551
X-HE-Meta: U2FsdGVkX1+MjI8dvmsUQ+CftIYl/AX43MXeEuXIItcZTGbUrj7bgqL5xMdhKhSPRBB2247l2TquWYNj8sxXTMBC1uoJ/YOMo/lmyG7oB3K0LlHFxMDWUDA0LZ/sSUT9WPSArk7slJ2LLC3vkd5GYpS29NVMk3Qh15x74kvd03Wkx8jdgFhNlpPj5rO/lZq7MEX22TJ6L5ibqavvNc+zB1/jShPwwKj6RwEbrOac9GZlHlcDPcWLOeGRTEwEy7QZHmzaSkFSjxpSUmt/air8M/BIVZ1jM/S7iJcISUJ2pOiMEMaRGMcUsBuC4mVtTMkJF4MZfyGb9NM77lKSCKGk4iG6IQ75cr/y2RQC+gBD/nXXG9mw9CR19zAL9MkDyObj+JyUm///xQe7YRji8MGzh6/cRoH4tahowUVN956pLzk4d6vHccSWt8xcCeRXFIaLWE797e7byoaM4MvdE+R1xwzejWPzLB84gVXo/sfJfOY94A7/h7J6r4y4zHWwQROIY+Qfvj6LGUPW0LD81wVKikYx4lhn5qCZtGvuA7OJuFTsOLfE3Ah4tHU0CWyqitVxEjTSDQJPkmRWrpD6mWaMtF6Z3ijUi/0cX9M+i6EsovBqgM0M0jEczPmBOJThCXDoy1WwNb9ik7eL9idr2799w50GaXH9dCGtj3/jshjPHw+Z4d/3hUV3Gl3LrXqC+w8aUjD6ElY7JNLwo1sfSFuIk7L8qTdfEjYmnIPgT/G2DcBq9AIiEqk0eF0YP6dTGnx3YtweKJS7g6batdbm7kUev059wj2TGMgyCC/V0lDbeI828/9naQ4J4vGJ9qI5zxsAgeM5DOKSo0+eQs3ynvSHgRVd6cEXYfmOHegFBuHM+zVkLDKmPSTbEIjBCRqaOm8i8C6dq8+Tw2E0RXMNcxr0JSEbQtajWBqKuJZRlD5tOjPJJTfAfsAN1+VLMiFcyR7mqN+xUtM6js4kmcfUQV/
 cNf6TXQH
 EqzidteD5gHE9Q8TLYOKE/zKdB9mVRJCESVrW5K07//pbMXGr3XcOLgmcpM3Hy/e6BlGW2gdRjtvNdi/IF0rpbZ3OFJJCwGVix2/lNSdj+brNY+xF/cwcpNwifFwgrP2FrHxGiNaMT009HIm40/9weeBG9MD6BnRY8IlK+LWAr05zjl7iDyPX2+rmvTLUcUBjra1eT57/dXn2GPKV8MeVkdjmGR9IEoxmU2xe6rWrBVwKH6rMQssePP4DbsbccgLZNO4ZcqvwL/2bctYYRwZ0taaC/i/jHbvPZFNGj4SERywodapoqMajg2nUmcwX5YR76bKIfysslKdEJRzHlyqROt9o9XbrvOHYlKeuwyVC99t4KxE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 6:34=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 21.10.25 18:27, Gabriele Paoloni wrote:
> > Hi David
> >
> > On Tue, Oct 21, 2025 at 5:37=E2=80=AFPM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 20.10.25 23:02, Chuck Wolber wrote:
> >>> [Reposting with apologies for the dup and those inflicted by the brok=
en Gmail
> >>> defaults. I have migrated away from Gmail, but some threads are still=
 stuck
> >>> there.]
> >>>
> >>> On Mon, Oct 20, 2025 at 7:35=E2=80=AFPM David Hildenbrand <david@redh=
at.com> wrote:
> >>>>
> >>>>>> +------------
> >>>>>> +The Documentation/doc-guide/kernel-doc.rst chapter describes how =
to document the code using the kernel-doc format, however it does not speci=
fy the criteria to be followed for writing testable specifications; i.e. sp=
ecifications that can be used to for the semantic description of low level =
requirements.
> >>>>>
> >>>>> Please, for any future versions, stick to the 80-column limit; this=
 is
> >>>>> especially important for text files that you want humans to read.
> >>>>>
> >>>>> As a nit, you don't need to start by saying what other documents do=
n't
> >>>>> do, just describe the purpose of *this* document.
> >>>>>
> >>>>> More substantially ... I got a way into this document before realiz=
ing
> >>>>> that you were describing an addition to the format of kerneldoc
> >>>>> comments.  That would be good to make clear from the outset.
> >>>>>
> >>>>> What I still don't really understand is what is the *purpose* of th=
is
> >>>>> formalized text?  What will be consuming it?  You're asking for a f=
air
> >>>>> amount of effort to write and maintain these descriptions; what's i=
n it
> >>>>> for the people who do that work?
> >>>>
> >>>> I might be wrong, but sounds to me like someone intends to feed this=
 to
> >>>> AI to generate tests or code.
> >>>
> >>> Absolutely not the intent. This is about the lossy process of convert=
ing human
> >>> ideas to code. Reliably going from code to test requires an understan=
ding of
> >>> what was lost in translation. This project is about filling that gap.
> >>
> >> Thanks for clarifying. I rang my alarm bells too early :)
> >>
> >> I saw the LPC talk on this topic:
> >>
> >> https://lpc.events/event/19/contributions/2085/
> >>
> >> With things like "a test case can be derived from the testable
> >> expectation" one wonders how we get from the the doc to an actual test=
 case.
> >
> > Probably it is the term derived that can be a bit misleading. The point=
 is that
> > we need documented expectations that can be used to review and verify t=
he
> > test cases against; so maybe better to say "a test case can be verified=
 against
> > the testable expectation"
>
> On a high level (where we usually test with things like LTP) I would
> usually expect that the man pages properly describe the semantics of
> syscalls etc.

On a high level yes however there are two issues:
1) even the Posix standard define the behaviour of certain syscalls as
implementation specific
2) if all the details required to write testable specifications were mainta=
ined
as part of the manpage, these would become unmaintainable

For this reason specification must be broken down over the code in a
maintainable way

>
> That also feels like a better place to maintain such kind of information.
>
> Having that said, man-pages are frequently a bit outdated or imprecise
> .. or missing.
>
> Anyhow, I guess that will all be discussed in your LPC session I assume,
> I'll try to attend that one, thanks!

Sure Looking FWD to see you there

Gab

>
> --
> Cheers
>
> David / dhildenb
>


