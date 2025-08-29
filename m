Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F3D3C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 03:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C245F8E0008; Thu, 28 Aug 2025 23:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0078E0001; Thu, 28 Aug 2025 23:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2528E0008; Thu, 28 Aug 2025 23:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A02A8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:15:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F2D51A01DA
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:15:57 +0000 (UTC)
X-FDA: 83828330754.26.DBBE49F
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C72F20004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:15:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZOgU3Sb+;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756437355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFS0xCiAMj/Aabl302HWl4K8lW2JEHc6RtxJGL4xl4c=;
	b=fvzlUvWeLgt0yUl3ViL/hwhwaqavNLjaKeJyRIjoafffMlsBU0FOnj8cQoJdxySA1sC+Ub
	4YDSYc2SGlpl2UfMJJU7YCOT0K3Cw+fMleKPhCoiHX0mNlMxCUCzQkejovCk/c11RfBxWu
	unqPuTxtlymUxMNjGLAtlHisR4aHkMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756437355; a=rsa-sha256;
	cv=none;
	b=73H+XJQG/v8tePMH0EIMt4wjbmoY7Hwq0waCbk/rWSPSe7oGV0Ckv/99XeLuIrnY0nrbF2
	0wkIx5oAfnXErLkzZNa1SJN25A6aGvOA63NQbFRfclt93Lhl2xdpi4OarP35tgKaTNSCx/
	aNeSrvZ7a3B+p/lRuZiuWAYVl7KUhCU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZOgU3Sb+;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70dfe0ff970so9422426d6.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756437354; x=1757042154; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFS0xCiAMj/Aabl302HWl4K8lW2JEHc6RtxJGL4xl4c=;
        b=ZOgU3Sb+YR+tMeEAXJqQN9hOVAbyNliNXdddxZUXRc+G1TbA+YFFvxDKNenPdbkyMy
         Rv+ZO2v/D8nulCiCljATgMX9RWgC/tlF6vjIwlNY+4BeEdN9r3lCsYbELNH9ieEVpF+S
         O8VQbxdfINnA94i6BdmZje+nvRqeD8Ww1E3FYo7xplgui5/+BF4LeLuLQ1sMdqZ8qVBc
         Fompe+j8AwgiVFEKajYpUgHoOtr4naJcheTf0leTaWPJ/0EdimmITM95SUN/Yq0XstcN
         MdDyNW/i123d46eYD2BB2aGi7crWeFx4WzusUA8pjYfQD8cg+NbolC6Hf23iax73XdD+
         e+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756437354; x=1757042154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFS0xCiAMj/Aabl302HWl4K8lW2JEHc6RtxJGL4xl4c=;
        b=uCk2ABrzEqIJ8Ky5UalSxQE8Uwu8pjdQDmqTtvMDbNZNAN+hi6DBHpPvft/H8KPMHD
         khcEc7mHsWz/K9jgCKBLoBJW2uI5LtslKvbk/lHzUOwHEhKHGZoG7WaRAqwKPS8IlTcU
         0KxrpWnKA0rvmfNDFYMee8snmUk7jLPI1CV8+iSgN4R+22p2Mtjah5q8Hveh+Ud3qiZ+
         nDySSVHgeclxfvuC489Za2RYMI6kxgtX+L42qsn+uA6AQEWr7PbA3q7Ft2mQFu7Hld1x
         kUbrILN6KzTZEiM15woHKSipV26KrUOmWCk//Yev1AzOmm8SfBRn79u109G3+K2Nm9bz
         oplw==
X-Forwarded-Encrypted: i=1; AJvYcCUtVpLAYDrzf6EHJtr/z1zMhqpeGSk1CRENuJ6G+/vhyAxrbF/6JuSB8EHl0aEhFre94N4kPGki7A==@kvack.org
X-Gm-Message-State: AOJu0Yw2qdijfHkY9U7hrQgwkD6Jnc/PASMN6RD1v/xbztJsgOQAruQW
	s1oI8V2wEmWYTjxwIRXKwSLVBpNimpKvNZYCXWpTWBPfah+6DIl4sD+XcD1Pm4Aq43CmMbAitb0
	kJWqW6s2UrA8sE0ayaiXrrmjfO9IlEvE=
X-Gm-Gg: ASbGncujaavnf9vdBsnGg36H7vtTuqZF5dfzgKUawZFuknZ5vpIPhqn1yhgkGmKdZMI
	iqYYBPbShELF/5MVBvUnvjrMgZA5q7Tth3udIYDDaZ+ZcKRDPtIh1lPqoYtNqN/e0P6mZGsQ0vR
	Kp9b+3o7lMuu7/EvLLLFUM4uh/f5//UDUmP3U+fHjVZ5gm+FNoaPJT55rrd87tLIL4WxUAgXRDJ
	puZzrplC4V/u//cG5ATVfZPyTh063sXEjPqC0/CxpvSdW/09gU=
X-Google-Smtp-Source: AGHT+IFFAjUELcmzEUUIYc8SHA/xvC9uJFbqt/nPTvZ1yb5BBrEZja9lEGaS63h6U3LHxjGEGcjgnnXdq8S/DdNl+yo=
X-Received: by 2002:ad4:4e13:0:b0:70d:fd26:f22e with SMTP id
 6a1803df08f44-70dfd26fbd6mr27305636d6.15.1756437354406; Thu, 28 Aug 2025
 20:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-4-laoar.shao@gmail.com>
 <5fb8bd8d-cdd9-42e0-b62d-eb5a517a35c2@lucifer.local> <CAEf4BzaOA-3NtwTmrPgveqbW16m3KZAAA1E_xn_qjtiJBGsE4g@mail.gmail.com>
 <4ee47412-2a33-431e-b667-2daf25bf0b38@lucifer.local>
In-Reply-To: <4ee47412-2a33-431e-b667-2daf25bf0b38@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 29 Aug 2025 11:15:17 +0800
X-Gm-Features: Ac12FXw78zOh0YCbOC1DZdJk9pXKNjEimCM6h54y2oGXNzxpBZAFFy6hpw6Sz_U
Message-ID: <CALOAHbBUCKTO+LX=5r_hW3+uBHO-J_gcQXyJEkasM7Em+37b+Q@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 03/10] mm: thp: add a new kfunc bpf_mm_get_task()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, akpm@linux-foundation.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C72F20004
X-Stat-Signature: o1xmmet3tgbq7m48cdnwjqg7qrktneu1
X-HE-Tag: 1756437355-32800
X-HE-Meta: U2FsdGVkX18PNPqxFo4OxC+uS6iF7mz3lgPbD+pZYUN1LUYvNfHUjpXCG3c4X1OkSffphI5v8lD4zS9lSDcAZhEtPS3RAjWDfE4urccwo7OJp4OudDFD6/peVd8Oc66jlPkRkw+w8qmuMU0MiLg/vIoN7jB/Il1fEkEaBiWroMZdfDHzcz+f5xIbttBWJ7MNzv1CZ8LNk2vdpV3FueqUrhYpmDqSsoEiEnDC4MQupr6bG61Rk1fJa+T6rinr4ZZr6D2+LIGdJdP8mpUe+T6zjh7fQ2wAIZJPa0GwSaiQzkU2lMIgQcrKB+LfqGSzLwZa5oJ8VtciOJU/I0gUjYyBqWrOyuth96W3LbPmLMRG+jaC6cG8rc0vqGMbS7fVHSiWDmaryjrvoK5vJFjNhJzo2f78lZy4lip/Xx1giz+i3mT3i5TxMNJufq8cCNWumNy5LG9kLTbr4iE4DqiFEMyS07cj0vBTWy5cy3CbwYpb/kJMylsZe1xltuq9INNiBUoR2ffJs0Git5tvl1MMg18UTDIWdbUX23pU/rjXJ0jxw2G/0MIpiusxrzrr9xnBPhp010RHaTco1jCgYmR6ECQp1ZfQnbseocCoNwPgGQYUXFne39rKj0L4KDCpJUJiN83vPio8N/U4LkhltqL4l57bJtLqhN25HE2ReuZ/dwhWi7YIgCq0PfAJ6ovIlvjtzIrbR64ZEbES5hDd1arfYhtvSW9IyimdvMjrqDfMCrKleUSNhk3b/sdOMd2uw+6N0nWnxCtrAeH68k3znwcnV1tzVXXAS8KuHnAy0IazSn9hHGAcw+KnMk99pZ5CdSN2KX4lB25QoevALVxNLDTfH7IRmLxK4O7dDY3qJ2VuTKkg6uV+HU/3JK3BAJf+tW2gxPHgBMY64GbzPLcwxue+AI7gwYDfkT/ewOjFp4mUck0cEVW21i0xPIhWfb9PCh8721sooY/e58NcU1zdI79UEVc
 StKOKmE6
 qihFTdber2Rbmi/KP/4kNZrjXb79bWTHvJn8NjO417DBVOxhYCVN2JR4HRLzTfD73sKiu8CMG8FiGo0g/fGjj6KfkvpWC2aPqMG2bZrH0DlT08ItAQZJzxYZq6ZAJKAxoo5k/uzCYLCaBRagrXjKeao5jfWEOV1G5IQp/MhWcjQ5G885JY4dtaAwmUjyMIK50ISuf9nOCL3AF2MP6OVbq1Odh9xPyl+LaCAqNdOAaFG21oIm16khRY3ZdPtGTJ39uA61DhyNGQO4zKgJIpZ+e411h36nEzK31oJ8ng6zKpJaEb7/2hD3awVr/JukMHFsVywqt+UaVUQgFoZ4YAOuJVxZqpkMsWHzfXwByNTtxRWjRjeyRN5nTeegx+VT6os7CwshaEQ4j8ywMSLb/kYSMko9KaJqaAT+Al42Re+jDVheh3Io43UJhlreViBkKXIKkfbtIxr0SNRRIodnDTthiZR2XjJmtOUFCQxhvp4y+Q+ITlQJyopUkdUeaiIDqFPv/DUE8m8GYlBJa+Om2q2xfM1ciRKvtvW9saoeEia+H9SSv+MMyBGMQ5EvWtyzHCM/msj2TObwvOif/Czg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 6:51=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Aug 27, 2025 at 02:50:36PM -0700, Andrii Nakryiko wrote:
> > On Wed, Aug 27, 2025 at 8:48=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Tue, Aug 26, 2025 at 03:19:41PM +0800, Yafang Shao wrote:
> > > > We will utilize this new kfunc bpf_mm_get_task() to retrieve the
> > > > associated task_struct from the given @mm. The obtained task_struct=
 must
> > > > be released by calling bpf_task_release() as a paired operation.
> > >
> > > You're basically describing the patch you're not saying why - yeah yo=
u're
> > > getting a task struct from an mm (only if CONFIG_MEMCG which you don'=
t
> > > mention here), but not for what purpose you intend to use this?
> > >
> > > >
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > ---
> > > >  mm/bpf_thp.c | 34 ++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 34 insertions(+)
> > > >
> > > > diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> > > > index b757e8f425fd..46b3bc96359e 100644
> > > > --- a/mm/bpf_thp.c
> > > > +++ b/mm/bpf_thp.c
> > > > @@ -205,11 +205,45 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct me=
m_cgroup *memcg)
> > > >  #endif
> > > >  }
> > > >
> > > > +/**
> > > > + * bpf_mm_get_task - Get the task struct associated with a mm_stru=
ct.
> > > > + * @mm: The mm_struct to query
> > > > + *
> > > > + * The obtained task_struct must be released by calling bpf_task_r=
elease().
> > >
> > > Hmmm so now bpf programs can cause kernel bugs by keeping a reference=
 around?
> >
> > BPF verifier will reject any program that cannot guarantee that
> > bpf_task_release() will always be called. So there shouldn't be any
> > problem here.
>
> Ah that's nice!
>
> What specifically here is enforcing that? Apologies again - BPF is new to=
 me.

The KF_ACQUIRE and KF_RELEASE flags enforce resource management. If a
BPF helper function (e.g., bpf_mm_get_task()) is marked with
KF_ACQUIRE, the pointer it returns must be released by a corresponding
helper marked with KF_RELEASE (e.g., bpf_task_release()). The BPF
verifier will reject any program that fails to pair these calls
correctly.

--=20
Regards
Yafang

