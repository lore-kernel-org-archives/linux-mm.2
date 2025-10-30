Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0701CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 18:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC708E0152; Thu, 30 Oct 2025 14:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E628E0089; Thu, 30 Oct 2025 14:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDC68E0152; Thu, 30 Oct 2025 14:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB2C68E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:03:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9669212A7FE
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:03:51 +0000 (UTC)
X-FDA: 84055553862.14.7600D52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BA0BC40013
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:03:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IHGz/OkY";
	spf=pass (imf11.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761847429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ib+eozWED9/iyFCXIsA4NhVQLzpW7wtd9ZuzLW6xTTY=;
	b=n6XJhlnKvzacoApZKE8VsMAtQkZoKUer4HCNrfAx2gOfFjQhAi2LjMER8wRax/kLDR+hCD
	F/dCmNpGY96oi31ck0ssMOjxa3qWTZO8Yb+zyfWH5TmxQSPPUIWd4WGH7zkBIAmwTgUqa5
	n/WmvY8+xb6hj99ygfRkzTqvNRulezI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IHGz/OkY";
	spf=pass (imf11.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761847429; a=rsa-sha256;
	cv=none;
	b=5+Ma0bsqX49DcfcvpJApfyNcNRZw2NA6XcIRsLW/ws5tE2Uo2igTuZa6gOqwdxkj7mE+Bb
	xvNIYiVjOyLAXwIECeh13i937Us/1EKDsJpvUaFQFydEcU0yq+8c3aXkNVbZo0oClVZF0K
	Tx5EOSYUhWvfuK8+UQ5WaHl9Y1TNcXs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CB0260320
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEA9C4AF0B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761847428;
	bh=d5pYIM+DlvI/eeXCbPFua+nftpLWGhp6JWVLglPWRyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IHGz/OkYI+QItig99Q9PGNA+cMatvujXM/apZeeTMF0iX7kTQifeSPHY1QLmrhO7o
	 tAt55mrv91Obwlxr6fAsubSGK0TSLM2i9twln8XyjLSpMPgjpmMS4vGXX2OnYYkH7H
	 AaktQisIQOnrEsDJ0sDDutbevtTsF0G/bZSP1lxWZVPyTfbcHGAkt2GNvkg8YNQR6d
	 tZ+hFuKhsFEi11PaRCUeJ8ILOqbq+SaUpeziVRMxGzaDaQBFG2/EwWeP3cPPQ/yRD+
	 ZNtt4nptVYiETD3+jemBJd7mzeDh3DHpnesDiuiHzfRZudaZ09Hvy9CgoP5eqGm32G
	 Plt/idPH+L+sQ==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-7f7835f4478so11305076d6.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:03:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWL0UsAff63puXVrVfMG/jAnrRrK3CTSElBAJq4AZ6iGoKYzGhSI41V950+lAv3tcFVlg3HFFoBqQ==@kvack.org
X-Gm-Message-State: AOJu0YyW5IS2HKFnITyUYBU2vlbtNv9jRZmiqEMBkecQ4OJucPUQKISc
	88WKFoDzpyJYCyqFPJFlh6v4UAbqIf2r92VBHHoRwoVVAbVPFbnDVGBTa2b3y7isFSH1xaa0RfL
	pIdIxDPD+FS8vm+dRqanZnHZ3caCQ0to=
X-Google-Smtp-Source: AGHT+IHhsYhWatkhUtR9Thi3jups/Zf6twLHgbotCak5ADv4q6trdZ9jUiXcieO2Ocfd/pZQOSvORcXRaoUyXxEzlH0=
X-Received: by 2002:ad4:5cad:0:b0:880:2582:b7b5 with SMTP id
 6a1803df08f44-8802f2f3cc5mr7911166d6.23.1761847427883; Thu, 30 Oct 2025
 11:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev>
In-Reply-To: <87zf98xq20.fsf@linux.dev>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Oct 2025 11:03:36 -0700
X-Gmail-Original-Message-ID: <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
X-Gm-Features: AWmQ_bmwqDpuhyP64DRlFdaSqpW8LEt5_ngM2TCJT1ee3IRNDHD_d8LbTVxeNBg
Message-ID: <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Song Liu <song@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kmpzyi8o6ynjfisubsqjku6n6bpkpy6b
X-Rspamd-Queue-Id: BA0BC40013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761847429-25079
X-HE-Meta: U2FsdGVkX19KhwMi/Uxc4/zN2hx3xVSn3I3nUBcuRF4eauyX2RgjAsOBD9T3CPb6oq/IO+7Zm0EFbNk9ffkXkBeyj/q6ykj8F2NVOml45cN3lABtq3ZKjjxcJwEG0vfhNVrm+WXvD1avTOMZ21JsRKWp8cRaAGgk3t+AkQHNMGAHbAqofhQqUn3y5VUdNN2lsnuqkPwBO3s8jz1aOE9aQJNFohWrTVoLDOFFD1B5C0Adp+ITAcXspI20aw1P8t/S6NwmcbTV4Y1F5BDB7y+PvaHNNvAxDATkGyOsIXzYgX4vj+sJ4l76G5I40CupFqyI+xo2Phzw73rwOAb5Lpg3z2dGmONOapU1P8rtyzzs5+NWbZWhz6kHYvVyGR/OtIEV6TMDSoe5AwoYER8ziSMJksaiHKR2+xnGP5Kaajj7KFEvJlvVSTt4vsIkXchA/+g9M1LkuMyYgH7BqYY+RAz3bQxbN6+SxpFAUi6UyMOGXXs7DuxJb9+jZuTtfOdJZPOC2iLsdVKtAnhRBfRXoha6rn6MC2hpp423YxXojXYpl+uHi+2XbwCbkIW4LEuIvMWBt1JPzNRLiikF53pML8diFAaJMXwglDi8uFiq0ejgjSgyAox5NnpAWvmsjtg3uEL/GFyjykX19tSEXugJ6oStCwLJCsiXXs0IGCXBAEzn/XVYqbAF+Tr4TdzqnAl/SoZvkTwRob3gM81B3qYGTVanbul0e/LLvAgrHjVGljCsuvazIIThtKQYElaGG/KTKpqJOZw5mc17EqugnJFekCz3NAaVTy0tixuzEZECuRj+je70Jcx7zb+KXuXDWJNkPsHWv3iDFGim8zDc0WisI1sVLLkhYt3YrecIK9sRgtJkL6T3pYprVZF3BdO6BOB6WE6mz/T45Bah7yd6/Na+Tdl8WpnhMdxM/4CKoI9NAfjqpYz2hBh4KuloWCRr8ATpcVMZQ1NYLKEuHdU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 10:22=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Song Liu <song@kernel.org> writes:
>
> > On Mon, Oct 27, 2025 at 4:17=E2=80=AFPM Roman Gushchin <roman.gushchin@=
linux.dev> wrote:
> > [...]
> >>  struct bpf_struct_ops_value {
> >>         struct bpf_struct_ops_common_value common;
> >> @@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_attr *=
attr)
> >>         }
> >>         bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_stru=
ct_ops_map_lops, NULL,
> >>                       attr->link_create.attach_type);
> >> +#ifdef CONFIG_CGROUPS
> >> +       if (attr->link_create.cgroup.relative_fd) {
> >> +               struct cgroup *cgrp;
> >> +
> >> +               cgrp =3D cgroup_get_from_fd(attr->link_create.cgroup.r=
elative_fd);
> >
> > We should use "target_fd" here, not relative_fd.
> >
> > Also, 0 is a valid fd, so we cannot use target_fd =3D=3D 0 to attach to
> > global memcg.
>
> Yep, but then we need somehow signal there is a cgroup fd passed,
> so that struct ops'es which are not attached to cgroups keep working
> as previously. And we can't use link_create.attach_type.
>
> Should I use link_create.flags? E.g. something like add new flag
>
> @@ -1224,6 +1224,7 @@ enum bpf_perf_event_type {
>  #define BPF_F_AFTER            (1U << 4)
>  #define BPF_F_ID               (1U << 5)
>  #define BPF_F_PREORDER         (1U << 6)
> +#define BPF_F_CGROUP           (1U << 7)
>  #define BPF_F_LINK             BPF_F_LINK /* 1 << 13 */
>
>  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
>
> and then do something like this:
>
> int bpf_struct_ops_link_create(union bpf_attr *attr)
> {
>         <...>
>         if (attr->link_create.flags & BPF_F_CGROUP) {
>                 struct cgroup *cgrp;
>
>                 cgrp =3D cgroup_get_from_fd(attr->link_create.target_fd);
>                 if (IS_ERR(cgrp)) {
>                         err =3D PTR_ERR(cgrp);
>                         goto err_out;
>                 }
>
>                 link->cgroup_id =3D cgroup_id(cgrp);
>                 cgroup_put(cgrp);
>         }
>
> Does it sound right?

I believe adding a flag (BPF_F_CGROUP or some other name), is the
right solution for this.

OTOH, I am not sure whether we want to add cgroup fd/id to the
bpf link. I personally prefer the model used by TCP congestion
control: the link attaches the struct_ops to a global list, then each
user picks a struct_ops from the list. But I do agree this might be
an overkill for cgroup use cases.

Thanks,
Song

