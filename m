Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C6BE7E0BB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7316B0005; Mon,  9 Feb 2026 05:25:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951536B0088; Mon,  9 Feb 2026 05:25:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829A16B0089; Mon,  9 Feb 2026 05:25:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72CE66B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:25:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 166E316075C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:25:47 +0000 (UTC)
X-FDA: 84424537134.29.F4D6757
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 158CD4000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:25:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dch4CwOs;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770632745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJ7Ja3pq8GlBQQ3yJIz4WpWIK3mpfgNIH8F/1c40ZSw=;
	b=vnRw50ACL586EhfHV7TBQNpC4XOSCadC7TLhtEQx4zwhTty18G3N63Ux9RQq4o3jVOgMDo
	u/NBiTiOpqAlLFZUPn6esUgmUv2b2N+1AWyP3sbpwCLuGvo1jp4KnwBfGJd7O02KSUTOoq
	jjPgDBV1Rcz7mcjrB4Ono8TakgEWTbI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dch4CwOs;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770632745; a=rsa-sha256;
	cv=pass;
	b=8qaGRD7WfiqCtcI2Ytp68dTVscteq5o0omivm9qihpvhFs/s2LFcmX/7+yC+O3tEsQpdkq
	7tUPs9GQ9vNK8xsVhg0Ia1a1QuOlubV1pIFtl9fmfB873TQuxWod1tkeZ8Gr4TzD4fjV8i
	zvXgbApnG5Q3MWy72nAj82g6caq+Lvk=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c70ce93afaso451187785a.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 02:25:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770632744; cv=none;
        d=google.com; s=arc-20240605;
        b=RuE1dwkZDsHsmi/J3uxXHwlA6wdMtpZQ5wkxzIDRBw0Lmju14y8uW/f2r3rcX6ChhL
         t+1qXy7LcQm2gry424gydjNxliesliNy9vwysUI8yP1+CGF2UpfuYu/1I8sEIC6MkCo6
         7oDtf9skpOUMiV9q+KIzHBfkZgWExpbEKW2I5bHM4UdGiY1pyYSwezKGPL9DnXT7PdZq
         c0NeXPxTTUsk89Wy81ib+j4oAHrDuaJ+Xx9YnyauSmruvOzsIaUp0QwqaWLsOCEIFEEz
         sFsLVCgWestEiNdS9aA8mRJYA4HcBtJ4aES1QiSKPMYeaWHorxGfPtmMauj+DTC/EBPb
         XYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jJ7Ja3pq8GlBQQ3yJIz4WpWIK3mpfgNIH8F/1c40ZSw=;
        fh=mmhyU7RDl/AGHl5F55N5M+YjGiddqf6eKWSwdYEGcCI=;
        b=Ik1kEj0XJ6Jq/4/x+1JYcU1UcOT02ZMaxxeIuY5S3qizH+KzsTgcOsitSJAwK+/Nyk
         kQzLgPHwXXcXXsJ7I6Qt+y/y6gbQ4J/BEDIPjWCNXESDN4Hv9YwsBtyqzoiHOxTM4P1F
         m1zgatPKPz7V6+6Bapdm4beVCSA6fmR7kMp/dQpB6F/kNbJJ6uAijPTUoNG5Tgx3wL8Z
         PagRrTzOrw9O8DLFo7ESalxa8zgyXRXdC/jIHQpzR04FuXWAHlak7DLrCUijs+YV/nsR
         FtFROUWobZstJfxW1Dq/IuJY0K7iNokBoMNLrfpzGrzJxdbdPwdw4oYjtE+Xvk1ytABK
         5sVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770632744; x=1771237544; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJ7Ja3pq8GlBQQ3yJIz4WpWIK3mpfgNIH8F/1c40ZSw=;
        b=dch4CwOs8BSkZ4GyOISMQNxWsYj6zQNdRFFIlvMKabYxQO2ZeJoUMAbay3iwnBVmqa
         5tvjhfh+19wLi0iQgwmbdpgV03IA4HMDKyoNY2KVqOxeBe+LDGf5rJKn/2E0/y539NaG
         SJ6UYZMk461nGhZYTe84em9MRY3zfsvYDSRHdNMGH/5cItW+dAP/1/x3Sl4ENKhcUh2E
         1d+ktzxc2lKJgSpd2wFmALdvG1/Uf7Jchgi1wn/Vq34Gzm7gt4+xSDddOvdTRw/c8qs4
         l/dMwORNAkqNTCwnMQdlr/3QSdEQvmCH0KcSHfbS43jpfTnhb9BihNTcKCROKUaOR+XE
         NP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770632744; x=1771237544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jJ7Ja3pq8GlBQQ3yJIz4WpWIK3mpfgNIH8F/1c40ZSw=;
        b=GUV4zbM1rBR2unQuHQQxzCT9ucaL6G4Yz2OEGsm0TsomtQNJ+RGHg2vvoB3XUf+2iJ
         BBp68FabGaH7sXRVIpFVZ832P7Ktf+QS1yZciEOzXmFukWykQLZwD5yuT0qcjt4XzKLS
         pfzRxT9e3QTPRH7IZKjieGJ1BUEDyLmm/300lBc2Rw1Gl3TorNWVlcedCqr82i8uAmhc
         s62xZm10/xbfL0t+zj9S1/8pAIqfE77kktQGoAZJmGS9UJfb/3aSAgj+1zy6SfGp55PK
         W4gfA/AVv/I0TMaZJKphetWzdomWAE86Y7CI4Jq/q+Mfk7wkf0AJg1wd70jT2NIkK5r7
         /lgg==
X-Forwarded-Encrypted: i=1; AJvYcCVhWhaXWlwLxWE/jFNR9+zD/ZaFHk4q3ZzlQfINhANCTwKthCat095xuhptv2zj3C/pVdrB3Wl7SQ==@kvack.org
X-Gm-Message-State: AOJu0Ywwri0ObaaVDTLwEae/CMQF/2BBRS1NI/UBCyrPP+OnG8rO4LZZ
	2jLg32+QGmkpsyP9Uco/dtV2wdvcxTQHPEZxXGzc5QdC8zbHhVNnljvH25KBWvME9GITx8Tpz8O
	/QNRbLx0PbTo0PP1mL5Qqys/zFATdusY=
X-Gm-Gg: AZuq6aI3Sgc3XWbBrl8kIlMvIhUttIKiCcIKFlpCgUAHlIUIgMIOAxxwMVFKrZ3Ijb5
	NW/awyn+qOrlwigcOUbsa9IfFKzVOG7bD4mE0rqje6VaKvNftCzKahtDOCyEmABHy95NbQLaV0r
	nUz9vGAe2qm1Kwa0pOnWhGsuONwP1LFxPe00digIxnoddBhDqyJqoiGILN8uqhg/Se7DR+JhxZM
	9cxo91mAYi+k4psKAnxwcdwe3leDoI3k9JSMQAM7HoE6eLWRzyGwU42Brv8+790dyDAJg==
X-Received: by 2002:a05:620a:2a14:b0:8ca:7b14:16d2 with SMTP id
 af79cd13be357-8caf1acb32fmr1351403485a.50.1770632743882; Mon, 09 Feb 2026
 02:25:43 -0800 (PST)
MIME-Version: 1.0
References: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
In-Reply-To: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 9 Feb 2026 18:25:31 +0800
X-Gm-Features: AZwV_Qhl0qsSwOQgOMCI7xSnmG-ncwg_fyRrIRycUWmzs6NMP7bdVr-wUKZ6eRc
Message-ID: <CAGsJ_4wgG6-FvDbLw4De0r_vPO1fTH_69A2VyntabmS6H5ZM8Q@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Machine Learning (ML) library in Linux kernel
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	Viacheslav Dubeyko <vdubeyko@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 158CD4000A
X-Rspamd-Server: rspam07
X-Stat-Signature: wtowmipg3syqre53f3ktro67eyy3hqw9
X-HE-Tag: 1770632744-471760
X-HE-Meta: U2FsdGVkX1/Pvi1SW4HNAwT5qslHjhpHAlm6z4Bzakw9aW4NUXTQ4OFu0dxwD/3gRx73OVmVP9sU5liD4YtbiCqIH4xdmRaqtExx8KnzGe1HsPjBgqU5siIzHRQnhR9rMevLETWTHple/tpL464GgSTeUPB7cWS2Oe43UY1Wv2hYdxDMGVmm4FcJzEvkqnCintARKLqB9ClQSyRNtmNmiUoGY7J7iGsboQshV0WInDRCTcyPD2YU8Y+rfbojJVemjv0x18HMqxM2FYkQsPNrgLM62tV6tlR2buG8Xsvyb4RV91U/I6SEaeMEQ1CLxGiya/Tqpyy8i4Mr1auIqsEfB1ieWsP1BMQBBU6xpYYEUAdEJjrY6sclqVwn3d2Xbhu/tdkgao+PZwi2PE7zaYOT6hGBi8J//1usweF1hQyrkTNDbC5Q5ypizN7vX14NZHayuVPHLSuk1aqdOT+wKywyb9jc7+h9+nngJZPLQO2YwWzCkS2Ihj6trp5sUEFAebHkqgIf4bqJP32L4ljAR3nElsi4YW1sby0sOQEuBol7hzeLuV0z/FhKMkgrlGHoZ7P3zr53RmFdkxI08exU8Jh66QM6iy7IqpsSSkDEM2zFpE/ZlMcUkc8RYaM+444tA4uB4IoY9FrAO+QtubfLPJGzTFsk6efwfeBvsM+cdpIR4BV80jm/w/75S6yhB9Ry+MpOdasWGOCZVI4ZLhgKMw8bg70mwwZK2hXtThhAgsE1+olqwV2x6zMHh/tCfMk9Z585xCTD3XfBC9IuQkpxQA7zo58XYljpBU+nMTwlZGiriduv2wQtKoJ13Y+Uilwhh1YoXmbauJiszahCtJlJXKkhjiW8agPuZLEcELfG7iBQFzs27MmI8Ds1zQ+zI0DjZ7eZydBytwtx06xJ2KkBSxR/qf3dBVGj5gfezSMJrBoDbQt0XP7/nJe7SyhGIDkwXOZpOLbDXi3O/R4KUgiabe3
 +KBylJW3
 w1ax9Q8LyjN+DSNkV6OtfJNzXj/9f2o30QZFjFrKeIdJ02d7V8F0E/aWUDME8uHdTeNk6laJAVSTDz0JWEp8mYVf5lF4f/VESMOoZRLWbwOWDgEqBoJKXLKKU1FLoTfJ39emNviqeVpFN2fxhGElUJZMJVP3gVcyjyjb1SKQqfUr/afFCQNuG9AurqDqSlWNJlk16Am6YBW6b25B1QTO0Y5HYpqfKv/MTHcrl7QUG9PA00xSTH28sy4LZPHdUxRwecysWPJMOtYQyoo5e1pyI1iTRVtEVqaFs1dqOiTPSfBMMFHnpRgg+7p4puWvUPFosvraVm5JbD1tKLtswkZ0ib2P0rtSux2LQ3bsWc9Gt5MnX6QlP8u7VLV0ZFlhOjLB423gtA/+FV3Gj5zsCmjaaIJsn6Xqm/SKyld+6uf5tkcUDVEKfUn7pwny8myP1lFv2uBHqVaN8b7oGrkTwtvFF7LpkCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000003, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 7, 2026 at 3:40=E2=80=AFAM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> Hello,
>
[...]
>
> The continuous learning model can be adopted during training phase.
> It implies that kernel subsystem can receive ML model recommendations
> even during training phase. ML model proxy on kernel side can estimate
> the current kernel subsystem state, tries to apply the ML model
> recommendations, and estimate the efficiency of applied recommendations.
> Generally speaking, ML model proxy on kernel side can consider several
> modes of interaction with ML model recommendations: (1) emergency mode,
> (2) learning mode, (3) collaboration mode, (4) recommendation mode.
> The emergency mode is the mode when kernel subsystem is in critical state
> and it is required to work as efficient as possible without capability of
> involving the ML model recommendations (for example, ML model
> recommendations are completely inadequate or load is very high).
> The learning mode implies that kernel subsystem can try to apply
> the ML model recommendations for some operations with the goal of
> estimation the maturity of ML model. Also, ML model proxy can degrade
> the mode to learning state if ML model recommendations becomes inefficien=
t.
> The collaboration mode has the goal of using ML recommendations in
> 50% of operations with the goal of achieving mature state of ML model.
> And, finally, ML model proxy can convert kernel subsystem in recommendati=
on
> mode if ML model is mature enough and efficiency of applying
> the ML recommendations is higher than using human-made algorithms.

Hi Slava,

Do we have any concrete examples where an ML-based proxy,
together with its userspace ML agent, has demonstrated
measurable performance improvements over well-designed,
human-crafted kernel algorithms?

Such examples could be in scheduling, filesystem I/O, or memory
reclamation and readahead. I think having a real, data-backed
example would be much more helpful for this discussion than
reasoning about an abstract framework without a concrete use
case.

Thanks,
Barry

