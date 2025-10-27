Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD8FCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2C2800A5; Mon, 27 Oct 2025 19:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA968009B; Mon, 27 Oct 2025 19:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E782800A5; Mon, 27 Oct 2025 19:02:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70E348009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:02:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1033FB7C09
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:02:10 +0000 (UTC)
X-FDA: 84045419220.24.10CF42C
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 166A24000B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:02:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DNslW02W;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761606128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDZ/TlV/FeucZp/wZRQgeCBquQKMH6KaEcJwGGGd3/E=;
	b=M4KK1KL7r7/Nf3bZrA0NcJUf1r6EzduVmE+TWF8fu0IDZfJxJI/sFjEKobIOK5R2wA1ZK9
	vFbe8nsQulA3qoJrK6GZz0h8tnviZYe2Eiipm1OD8ugs/HRor4lYkXaNaDyrr9Twecmrqj
	5bUYST9kLK4TeXyIqXJKgT8CrthrZMU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DNslW02W;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761606128; a=rsa-sha256;
	cv=none;
	b=NTfZ87Ee/sb2VX99lYr1Ab/juLhwo8zCtjO+WKREgxrSrOdm/6iEYKkryg+jXZViXvABEx
	Kxq1a8EL/pVesQLvsou2Ib4MfmfnmTtdbZpWOQ9PZ0HeUEe8NXxxD/RHMBG3Ge3haUt2cc
	KsaOS/EEqN17qHN3uEzzFI6z9mxEz9w=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-592fb80c2faso5796151e87.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761606126; x=1762210926; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDZ/TlV/FeucZp/wZRQgeCBquQKMH6KaEcJwGGGd3/E=;
        b=DNslW02WaAFsBZKbqlnBQiOywL+7eh/cCClK2ctA8sz+hV4scjbHiaBy05A6ydOZ5x
         sFuMyl47dUmhP57T96P/upsiwWeSC8xz6r4GV7SRumRzwXW+NxjGbhuJj3t9Lf1H6Nw2
         RMUEuHJTWumqqH6iwBlo/OkrXYEp1BJVBToNFArv6qE5bN7n9Uow8Jzg+lxf+YGvLqAT
         E30PZ+YIznSVBk6p/ZWmDiCpyuwYOHLZauzzjB1CkcfvOwWL6n92H+O0mh0PcZFwkw/1
         ll8Ph3hViEjBO6a46ONGYFcZ/3lN0ZqsnQI6mNj9XS0nLY2e7VP8UZEpJdWLHJE4BaW6
         11Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761606126; x=1762210926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDZ/TlV/FeucZp/wZRQgeCBquQKMH6KaEcJwGGGd3/E=;
        b=LmWBUYJzJ0FHX/995Fj8WnYw9Jb1vlIBgNr2lPmrsvwDypUn2QtkmALu8IunpfUhNU
         hSq5XkD9Aa0Nfjp4pmpgJswAuQZk67+JwnQ8OhAZKD7P/Biv5LEo9IN3UDlQm7FRd0MB
         eOJdj0i7lbh+jOtBx8XTAoE3x5TMiQYLhkjPm0nm/qX6odMcHVzPnWmThEEpcpSBtIjW
         KHafGigpHLr6xMrwhfVhrfr1sVSygErLL5XikIEl4AWscm09n1VPrPVgL84kgl3BwKLl
         j6dMexOf/4iZ+OJ6kEuyeiYuMkuFJ1IlLe6WHMh877m2Bw9PXB/xxfVsqJ4EP2pwKH9d
         De3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWhCd20BThgMdo3ZcFIP0DpV3VWYl5lZuXwtUXkAwiIRIkPZ7frxtmcRIcy0mACYh9Om1Rp/s92pA==@kvack.org
X-Gm-Message-State: AOJu0YxzWbYUwUKdRyhqB8Zx7v8Be8ceHWBAPmlhslKBKLR80QNQN+lP
	q2b7OMDdTFzIGrCFzzrvJNtZgeswStWKutglUvjkTS4qGL0IU7J4Haax3fc23vxQ5XUoEJ+/Z7+
	mik3FhcvzTAf4EeTwqE/wfVYRl7ruR5SyK+L1qUD7
X-Gm-Gg: ASbGncsvnbJ7waaGZDuRB8m55HOoiuKhzZEwAVQLkLCwwvwrnmuh7g45yevOX4cHhle
	AWczgzKZzqzhADu8+2YRhURTakJn6j09MpHVTGD6yOMLmcjz52z54WNlWyt/Ol1Lqf24jTLJIU+
	v9sriTb010FmH8N4/lkJbfnsqoIwJMEtLsrCjPmV7SXTRfDRF9qutfyS5dJJdnhQUbNkr6gMlUJ
	0eRBIYuachrTPh12b2LeylyI/wtlsDx1cvxfmjOdak9sOsSVpPeXZIRIdLtuyN0f9B1g8TqSiV+
	o07hMw==
X-Google-Smtp-Source: AGHT+IH5GGO/QRS3unyVKP+J5rFOnjCyksUkPYUrD/2ThqVKsfIz142MePftEnso0rQ9MPp9qjMcov5TDkuNjuvVb9A=
X-Received: by 2002:a05:6512:350c:b0:593:f7d:31ae with SMTP id
 2adb3069b0e04-5930f7d328bmr191178e87.13.1761606126061; Mon, 27 Oct 2025
 16:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <20251021000852.2924827-3-pasha.tatashin@soleen.com> <CALzav=fmTVGDxAUcuqmcegAtd8gEW4F3Zp3AGMQBtXrCQgp+aA@mail.gmail.com>
In-Reply-To: <CALzav=fmTVGDxAUcuqmcegAtd8gEW4F3Zp3AGMQBtXrCQgp+aA@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 16:01:37 -0700
X-Gm-Features: AWmQ_bksoC09_xtubL3fsrVqg9KgYMffT0YmnVbt95BNOWTR3CmBaoOZ230HE-I
Message-ID: <CALzav=fD47OCZRMNqDmHs798qpZzeU6eHHuNA+wyhmZ19aJ9vA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 166A24000B
X-Rspamd-Server: rspam03
X-Stat-Signature: mxr5crr1c88ti9keentg6dmhzasbpomy
X-HE-Tag: 1761606127-172254
X-HE-Meta: U2FsdGVkX19+jUnyfZpP1LIZeeboTh5flbVpUx97UHST8NPPMVu/txD8TlfwBKiNCWDVJGSpxLQcrVf8kmtB8U0LkvKOD3rCgVgzVMsJ2+6UPptDAefMb1Ux2PqV4csfzYZ2zuT+ej8KcCLJVM/bUQTPf3BwiFpvFtTrxZX3SgCVr/Ga4J1z+vPJzZk3P/yd7PyPAIamDEvVtU6DqPtbrFIRlqFmPjcqa2EQhXJFQGpecsESl5ffowZJlfTM0PsBKCkcvu1B/NX11J4EkuNLIItdDkcHWlR4zjbcYgZIM5HtRYpDJubk0b6pa7ErCm74rQnRs2jRt4lPBAvCdZzMPOnVugo20YzBS8/k3J/+6yPB/vSmDj4SfV6l9vA07JedWtHRMLtAJEfA5SzNL5XMhCci1ipc3e4Y0wTe0/G6K4pL+DAK5Koxl5S6yInTHmp5ZIPM7hJk4AOX4M3xNrUVKtnjHQMr5sEP2qpC/W8Nwtc5EF7TlUPmkUXNskJYpwBOn4fdFH37QAJwLAfflV5MFTMhs846si651qQEy1tD9ifaezee2Ul/LsOkc1ZIoXplLU9vyUzb9q1hTScfNBWJg1ODwau+CgDnaJqZh5IpXv9fIRphyXamavG4KcbfKyPhAdNJJ79u43aanW+0kC9tKeTpOtECNOKFm6SCfeEnfC4SyLnXbfRgkvlMSritBimh7GsrbZ6qq2fduchu/951a0UyL4zA5vhDxeZl8rPsC2Eu38GWAXONpU5LvigEHAjlkFMYUNjMBwgOhDpM+X1yzllSjtHGvvuCIWhFOwsM2yPBqqqhjl153soJNwt43bdDr6FPtHTJMP29EQQVivBJLM8QOTSp9PHukqM5V3xbAzjkLueVck7DQIg8WHUWLkIeXY9HKVvVMOcZtoUg9OfKS0JHsIsV5HiMhZm0A1ALWJI/jotuPDbc8vCL5vjfoznGVlBjiLL/A52PkPFgoV8
 Yq8qICeb
 tRE7mmCMwp6MEo6Otht+Uop+sQuGr3LnicCpH2hCai+2glXxg9GptqdMJcwXafSx20X9oSwZ7Z0QqmwLTvTNVg7gsAxYauH0jNWOl9G165OJvYcUMvuZtycu5zXwwg1AdCvL+d56VkiqMjgfkcjaYTv3uiINkspmZWm5c3tOVeypbELVNppDvLhp9yDX938duNvjCfEDiP5iaA/7nytJgdxobhGSYnw6NcQ+AAtffOUWkwRFwLW81mdhzsw75SOhTHdz28wvrBVgTipfTkfsUpsyVhLP1tlC0WVNhERq2NwgVaUr0yVbrqG+mA3xH5UdMeLZ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 3:56=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Oct 20, 2025 at 5:09=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>
> > -static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, =
size_t sz)
> > +static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
> >  {
> >         void *res =3D xa_load(xa, index);
> >
> >         if (res)
> >                 return res;
> >
> > -       void *elm __free(kfree) =3D kzalloc(sz, GFP_KERNEL);
> > +       void *elm __free(kfree) =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
> >
> >         if (!elm)
> >                 return ERR_PTR(-ENOMEM);
> >
> > -       if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
> > +       if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)))
> >                 return ERR_PTR(-EINVAL);
>
> Reading xa_load_or_alloc() is a bit confusing now.
>
> It seems very generic (returns a void *) but now hard-codes a size
> (PAGE_SIZE). You have to look at the caller to see it is allocating
> for a struct kho_mem_phys_bits, and then at the definition of struct
> kho_mem_phys_bits to see the static_assert() that this struct is
> always PAGE_SIZE.
>
> I would either keep letting the caller passing in size (if you think
> this code is going to be re-used) or just commit to making
> xa_load_or_alloc() specific to kho_mem_phys_bits. e.g. Change the
> return type to struct kho_mem_phys_bits * and use sizeof() instead of
> PAGE_SIZE.

I see that you replace kzalloc() with get_zeroed_page() in the next
patch. So the latter option is probably better, and maybe move static
assert down here and use BUILD_BUG_ON()? That way readers can easily
see that we are allocating for struct kho_mem_phys_bits *and* that
that struct is guaranteed to be PAGE_SIZE'd.

