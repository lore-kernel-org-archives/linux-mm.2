Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A27FC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42596B0098; Fri, 25 Jul 2025 12:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19E16B0099; Fri, 25 Jul 2025 12:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956476B009A; Fri, 25 Jul 2025 12:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 835F66B0098
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:22:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0929DC0843
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:22:39 +0000 (UTC)
X-FDA: 83703305238.27.B254EF1
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5350840005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:22:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LlQF+OM6;
	spf=pass (imf17.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.53 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dG8LORNMv4hLV38o9+LQvLvmF4TyNuHF6RVwSF8uMp8=;
	b=z68wtjAEfsfqE+qDm3X536wDDxNf6RZ6HhjdhdPwyyz398XyJwgqZYycLcvThKcAr767iL
	RbVNleMwrP86lQh6A0zpicnRPAGXYIqkn6jeXi9MyF72QuSbM4INzhTG5XQWmp1zeshW8V
	W9xNyiTygdRxlsqdJ9TVgV+xXyAu1Yo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460557; a=rsa-sha256;
	cv=none;
	b=5dwKl1J/TPTXYV+t3cfqh7GZxPKocMyd2HckWgkxtcPCBy+E4m4m5tiUbsWfJb6ftZp/TK
	aOwTt/Y7dh4aqE3p+ZPibfDtJ2ZUcV7n/xgLUEyATka5m9Rmf0YKcjEvPZt+KjNfsLjGRu
	W1UV7ZY6D2wrj10ygQgIbd8MuoAewho=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LlQF+OM6;
	spf=pass (imf17.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.53 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-30687111693so354373fac.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753460556; x=1754065356; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dG8LORNMv4hLV38o9+LQvLvmF4TyNuHF6RVwSF8uMp8=;
        b=LlQF+OM619KEdUrw+Otr+BOhGiSHv7RIgjzqKTswb+H6LnaCwa9nH7Sa1J8PcD1fTw
         jPEZKFgspfrR8YbMYhEXV4e/1EK7C638LkIrMp9/XKpvqHI4FLoS8BisRemlEINwndyM
         SjLts/EB77/OHI2cqfBTvvdULLk+2LJyt9vI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460556; x=1754065356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dG8LORNMv4hLV38o9+LQvLvmF4TyNuHF6RVwSF8uMp8=;
        b=l6YhEySsHH/fmahKaTsUawhJHStN0OwgAe/grYWtl+JI0F0CeBKXzcq6kspq26IEbA
         rIheZt5+C9qZy02MRoHWrcmWTgo96cp1wYeZlROyBZefHOjEGCcYk17jAvINLsyFFP3X
         UUXOHtZeFN0pMYM8IpCQLbQMuibXgK/2kq0OjoK6tVwzmcjzuakSooKCfmhUa13xWhqf
         MXvZa7HT+3O/gbm6oak2TgPo7eJQUEqVoKju3k5fH+WrYoZ2NhwUEZxbZXgJ2zBDYo08
         oiw8CIrEaANGCLIF5JARo3NfNbX84viX+9jfXxMJ1hg++bEkyipGH5g2uu1SRYuMtb4/
         b+BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq3c+DQEMCEoswO46tPMc7zhD1iFbpyCWvajVGh27w/I6zqit80k/4in1cjP9cHpxegnjLJpiZbA==@kvack.org
X-Gm-Message-State: AOJu0YxEqHmjQ6vKtQkQwlm6oNKSNe+hW38XuVN1u+18BaxbVjHUmmqd
	ttmTyKCLEYmo+XZmOclo+1kne85Wwh5MV6xEDAWqWKrFHKCYCR5HGsAUVzntcwllWFMuRfVr4CK
	i7s+aA8gPApmTFc35X5YTigbQU9PCxJ/abdy2CUqL
X-Gm-Gg: ASbGncsLBqLYqAiLzDCYFRaD+kFpL5zHI3jDVRFRpYsPaXD8RAQGJL1ivXuQw4NoWak
	Gp5t3EWQ+SogIq/z8X8JThT5/JrTZVL9Dqo06AD6y4v3OFgol9+QyS7NWBoRSpSW8uGwgR6sWn9
	OPKnblOrOExtbIs8A3mHT0yO7a2mse3B8dfMUOVwmDXPhs01s5NREy2CKdPjpMq8zejn3bZmYZr
	RNdMyx/aBbp30O3R9vQU48Rz3P4qFYqtgvVGg==
X-Google-Smtp-Source: AGHT+IE+9r3hfO5zBRvfZvNR3MWRAD5H7Tw6vqB+Cze1RNE/NgXdJj+e5F7QgK/8TZwJ6pHwkdNSQnKE9BFj7S821Go=
X-Received: by 2002:a05:6870:a906:b0:2e3:8acd:d48e with SMTP id
 586e51a60fabf-307020bb42cmr539535fac.9.1753460556314; Fri, 25 Jul 2025
 09:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <CABi2SkU75e7tXcpgnLbDhqSJBWVPOvmfMh2uPsU3mUjMUhhYqw@mail.gmail.com>
 <38ed372a-4b27-498e-bb3b-f95792bbbe27@lucifer.local> <9c861191-ac9e-4d26-b2a2-1facfa45de44@redhat.com>
In-Reply-To: <9c861191-ac9e-4d26-b2a2-1facfa45de44@redhat.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 25 Jul 2025 09:22:23 -0700
X-Gm-Features: Ac12FXzA-vO48FLSIgwm34Yvy9xCrveF7N2ZBWVVo5aGocgvC73fwOsfOIwjfIY
Message-ID: <CABi2SkXLnsXzE3HUQndyAY__hZdO2QPDRrgG9+cUvTNSTMH-nw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5350840005
X-Stat-Signature: 7ibwdcqwnpgbqgrszi3wqcwk111ioyxm
X-Rspam-User: 
X-HE-Tag: 1753460557-993102
X-HE-Meta: U2FsdGVkX19S1Gse5DRIytbbQxkxCX8Q/yS+orCHCy4Xx6w5TatX1qElX5RMltha/AgJfDr9XC/s07bZZmr3ILcESs9uDe81wRPbBplVpTn4z0yrwhtlbpyYSd1wwEZZMEevR6IlW8Yg9PN23z0ryn3GSnRhu+VvMUHmSgU2py3QzygOO8Br/6xIgBkukIo5FQ4nBeQ7oPl6sOBWcxo59c4ihJ9lUj/vDJ4mHm9zlmNgNdZMWRpimDWsX0jPdobd4xcyhCkJJNH77+9PEDpFDYlTgQhG2ImE9hDhbBQis0ZsCuohMB0Pgpz1deF7j2WR7sOjJFFpEPUcF07iBMxLNO4UR3Ja3zC2kVu3hdpoG0sEc+ntO0ZvdVqKIrHCALdPF7ToNTdhKjUNHfOjDL5FGf8ii/5fAYlM6EXSnaKb6XhIuSM6A9UKrgoH0Uy+Rdoqs+UdxjJBz/EtXqutHp2+eVtJEyfypwJT4NAlH2TttiFsDbxsHbvgy0eND3olJTuiZqoPQ7Gh8EQ5zDcN3zbVW8OFhXdlL5SmP6SkIhL1quND5mQFc4JRdA7wRiZsWQRAyDpLsqprAph7hNv6adGpGee87+45avDbUTXTflAMke1DNH/XbwAqzSimZT11FH0q5QNfnahWlE5KF8lewadEollw6tcATOP+QC9JvifFLAaI4v5qVNqpi/TIrvwEZvFMk7S3QCjwHaspEewZPYvOydTd0Ea4iEC0yiMInf834Gu12+dhceaqRB04SNkuy8eAXRThL6pfe8vR5+pCQ4dwH0QKDa35F7TStK/1diGUoUiodbGrmHwpDTOP9NRqKyO4ioDwmsnyVBOuvoe45olwQDrMOfAfdqqJDa7jd4zhOeIX3o6RoKGTsTTrfpqYqLAAQsiQoVgVi47o+g2TbfHBlCb6IVCkb9Ou
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 2:53=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> >
> >> 4. We could ask applications to switch to non-destructive madvise,
> >> like MADV_COLD or MADV_PAGEOUT. Or, another option is that we could
> >> switch the kernel to use non-destructive madvise implicitly for
> >> destructive madvise in suitable situations.
> >
> > Umm what? I don't understand your point.
> >
> >> 5. We could investigate more based on vma->anon_vma
> >
> > I have no idea what you mean by this. I am an rmap maintainer and have
> > worked extensively with anon_vma, what's the point exactly?
>
> I think, the idea would be to add an additional anon_vma check: so if
> you have a MAP_PRIVATE file mapping, you could still allow for
> MADV_DONTNEED if you are sure that there are no anon folios in there.
>
Yes. That is the theory, thanks for clarifying it for me.
This is exactly what I was trying to say in my previous response:

"We could try having destructive madvise check
vma->anon_vma and reject the call if it's true. I haven't had a chance
to test this theory yet, though."


> If there is an anon_vma, the only way to find out is actually looking at
> the page tables.
>
> To be completely precise, one would have to enlighten the zap logic to
> refuse to zap if there is any anon folio there, and bail out.
>
> --
> Cheers,
>
> David / dhildenb
>

