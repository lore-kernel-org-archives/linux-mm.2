Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29237CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B3D80190; Tue, 28 Oct 2025 13:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB388013F; Tue, 28 Oct 2025 13:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA7180190; Tue, 28 Oct 2025 13:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 594608013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:24:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2AFC8594FE
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:24:25 +0000 (UTC)
X-FDA: 84048196890.21.07AEC25
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3EA964000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:24:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lR83Ydtj;
	spf=pass (imf12.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761672263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tljGKA799ISeHe7sJ8nVq9wgNoDMbrBY6ATHrDEAPsw=;
	b=Sh0v8CGtRai9Hn0Mtg8jrIY0S8WYqH46TaQRrbPK7XYZt6JjmjZRP7tKsi7TftD+DJRv5o
	tZKMTuqHzQ9a7epOYgbRdp4p73e5fDaU+mT2qQX0+BrehzaN0pxZfp3wZKj6n1piFES9Xx
	0+Z+Yv66gWb12uPupQG96M1lmCAFcHQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lR83Ydtj;
	spf=pass (imf12.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761672263; a=rsa-sha256;
	cv=none;
	b=r8yFauv5R3l4e1J/8W/rYN8xZb0D5o0vZfgjumC0mpvyjpmWxjrfN0WnuF0NhxKG6h8lFx
	OND/wkym/1e4epgdfP0x2wK+A1sCP1eyDtSwqPgaD/Y2kCUQirv+g1yIa/gFmKdNCYEKIN
	VkpHsDP4Ia7/3WLOd8zbqb7TU5/Co8c=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-33e27cda4d7so138513a91.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761672262; x=1762277062; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tljGKA799ISeHe7sJ8nVq9wgNoDMbrBY6ATHrDEAPsw=;
        b=lR83YdtjH0f+ig2hz9nOwUaGPsKDY6kEoJy1o5sRWrp0oltruxMugsKvzpgOCGV63B
         cCNOHbQIWg82I5nKJ58knAo+E8gkoVAIMB4DDgx+Dk1g3dEHTx/BFsAQMTJF/+fudW7T
         KsOoFcJufIJWivuC6ddc28TnR4VMt+7iJAD7WaL/kKGZfZy6BstZmfLGXwMGjyf+iD45
         vJK3SSsh3PRETnV3VEKw6b9Zkr5uqud1bEFZcKgH8wxv9JdA5IT6NW6okCZPRZUied2R
         V8y9Aoo4E5AxK+NyThV8ValhntWRWdkOgxhFI2M8aL84alu/At2aqfLrPIxSJefcoqbB
         rECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761672262; x=1762277062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tljGKA799ISeHe7sJ8nVq9wgNoDMbrBY6ATHrDEAPsw=;
        b=YK9j/XtRxP3GDV40dJKuQ8d1M5nTdXnOM08taWYeD/71XO1pdOh9hWsJjjKnU1kKrn
         KVGVWU8rjxBrs4mSOI/5zmTGtKSb/ARf4Ry6JTK0B9aW73sjko3ksijnOhKTynq8gqov
         QqqXKgJLrabnISLiG3lQb/xO5DKFJ5HVSAWQd+iy6nIJa7a/PaDuvY9X9aU0qtnmDVZI
         i1jfxHEuQsI0ExTHbUTYeQTSQ8H11PxWr7B1V9ytS2GGrR9u2Npv+Io/bGbcXE5ZlFJ/
         QjcLDNfB7MHSfwLFqwESgIdjKUgd5aYkD21zT+V9bSKvsldqKJvy9FvoeLOg0u/pD6xt
         XO+w==
X-Forwarded-Encrypted: i=1; AJvYcCVCd28YKyblEN2Ya5Ozd3q/0NC9kdwI0KsRavyVdte/WJbA7wrQI931v04OT/0tJT+W4vZjc7YUXA==@kvack.org
X-Gm-Message-State: AOJu0YzQotfWus6gCG7DPlTtyHlu3j2lnzxadiJ5c657Q4Cov5r2MsWG
	cFsrP1JB7V6AwQMEsvErbHw5K0r5BH+qWVENgLoBOIK2aBt335raZJv0mvFnGoKefb4NndKtaym
	LIq/szqSnEoebbuWvjtIp2ZzsRQt+kLU=
X-Gm-Gg: ASbGncutHX9uc3nM7z/51ipntTqYHKEQQju3Tw+brKa6k8sXiY7HLCyIwQtaKOTT8TJ
	1nUjm2bk4EYR7I3c5/+qqFReeZfSn5/HZUON9CXb5pS8HyWQJX87aUVEQVdR30ROxNKt/iwcw8V
	00IjoTBa43h6C/nzZSIt0YNKx0aXqIAPKp8M6GFlo0sIEOysKpO0OcwOt7HUq/JwtcRvOZvwxPx
	zs9YUdG6psOpiS0BecHLSXV0XupnJqtda1qjkwL1NGY1bX3ol2fQ+0tQkUfR+v2weubJB3OqSUr
X-Google-Smtp-Source: AGHT+IFyyusQp9jVxJoqbcKJt1LGrdYEflLMuoSJ8Py8QQQ6PdrknVOCcNvnUgVhWXQIoX5kkVhJPU1j59NfN4UGYKI=
X-Received: by 2002:a17:90a:e7c9:b0:32d:e309:8d76 with SMTP id
 98e67ed59e1d1-340396c8960mr41024a91.10.1761672262000; Tue, 28 Oct 2025
 10:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <20251027232206.473085-6-roman.gushchin@linux.dev>
 <5e97ecea6574f100385cb21507076c6efb2667eb9def24f322306be038e98165@mail.kernel.org>
 <87o6pruf9j.fsf@linux.dev>
In-Reply-To: <87o6pruf9j.fsf@linux.dev>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 28 Oct 2025 10:24:05 -0700
X-Gm-Features: AWmQ_bk6C1eqilbaEGQX1H9gGHgUPIMiUUod78Q2POZa47mMAp7WiEEcnvZm4YA
Message-ID: <CAEf4BzZu_mmUa6n=kKJBgivKpKh3R3c8TcKwGnKdAV1WenuUAA@mail.gmail.com>
Subject: Re: [PATCH v2 16/23] libbpf: introduce bpf_map__attach_struct_ops_opts()
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bot+bpf-ci@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, ast@kernel.org, surenb@google.com, 
	mhocko@kernel.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	andrii@kernel.org, inwardvessel@gmail.com, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, martin.lau@kernel.org, 
	song@kernel.org, memxor@gmail.com, tj@kernel.org, daniel@iogearbox.net, 
	eddyz87@gmail.com, yonghong.song@linux.dev, clm@meta.com, 
	ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3EA964000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: w5e5qemjxeryip7tpwd9ds3if4fp6mcr
X-HE-Tag: 1761672263-557485
X-HE-Meta: U2FsdGVkX18oeDbWlKCD7k0hZcnm7sVicZpqciFFG+pGna20n25rxhXcEfa4rpZUDUcldQPUNQs+2hA5sus5NI0Y17HW7lmbW0FIAGe1JER7iVSzoq/2cEbwTqfaAq8fAE/4egxFV4hFcWA8xT1beNUVDD/8Kisx6uQww5IRZDRt+1nIq9vR+dxRuwQA5B/OCbkUP5otf0/3VTL3mI8qg/bm8D8uq1D2MwtviGjkSfKT8HaNVLVprZgLnD4ENnpOUf2wAmPPdnfO+Plvf+liUvdExzihM/1lzOj8Z9fGi+anFw2UYbKoFQv9CxmPw+t7aiiYgkFJMt6otJY0szQLc8xvjsAx7a1RwfDaD8XvbQuQ1cGHiEPucfO34TV4LgLOGpbJ81sY5wctyFjO3lXKV8THqjBPsYnAtiyxBgaPVIYtvLP7cA/fThbyGq5JX6wcGbXb7YOqUh5IJdhkEu54cZeGwlQaj2RBLyXBEjtL6MEObrRBBUD1ipIM42PsLDY8H/lK9uVqMzJBD5t0x9hJvcqzrIZvp9hJEIvE16eF0WHOqzyG/zx/xJnk4N9VdYsi6yth8Gg30H1g4332eqr+hNW3alkLdKsCxhyCzoMbVG53e27Kkb+BOiIQmN1Y4YGgEEoIANl4WCxPF65fPy8e8BkrSxBF0RhpQfmkznE6vj8EFwtSkY4xguLKBG8mMp/IJiBWEYAnhKROZA45W29fkOkuMBHen/gJuchz66eM1weIsxV6IRmBXkdeAPH9bOhTUYQGG6boPEDHIv6Th4G7ZqjbsVbeYq5cJ9YYD0w2QdIAGwKTJT3k310AB8NtFRm5uWFrnnutetZ7W7drrYC7+KnPuJK4ioyy/zcYPFksgEkpW8MDac0ALpr+Qpk1QtPiM+rfzxKaO3o2j+KgpvUmVu7EM7qm9zRXQ9DDxKzfiKBBMuJRYPLwd6Vzl8C1syEBaI87/GX7vuEF6CKOKma
 YeoRwyMc
 cGHNWDg3lpXbpIW7LuVcfz/okUwynAxdBuCTXs8Flps2ps4Bxd4huWe/IYrST0GQVQ1l0FIu1GKRC79yuVfTlQgSlWNwilyv2hFQ1D9UNefdtKcK0tlnGDoA2tmO2JzWvbrZEwAc+OIqSLWZTlFuWjRFzVCuWaa1wbbR5Vdrh9ThtIYIXGgwKIV+0HVntNKYcgTWeobztB6RUQSMz/eAlYkjF7tl51H1v6I9KAODTn3J4whbc/deJUJwIdwH6Sj1OFJDXuMyT7txpqdia0AhPJUvWddW/AydM844h+/CzulU0PXHTVs8rAsdqiZEDgBx4Y4T4i2Dcl+aN14/r4e7FHZ9JVO2hTja98WjakXeLVOMjEkLoABml0cbil7mXGNoVH+Y6ibdaEOi/PkMV0TiAQ2AqWBlV7ZTQXbz6tVxXVLqSzdKI6g6bxWUoVn+oX2iPdSHhJdOFslCmUjdp2UeD0wkAHhwIqvP4pNy+Pkf3ZYCYEtH54avyWGKhxYZE7hvn383bY6u1trS/XMQyRoCoSun4JuDmowDCOER79W3UZq/01jX24rXQ0vkNMWNrE1/1DPDB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 10:07=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> bot+bpf-ci@kernel.org writes:
>
> > ```
> > commit b58d54ed56054e3a550e02c324982feb20a2671e
> > Author: Roman Gushchin <roman.gushchin@linux.dev>
> >
> > libbpf: introduce bpf_map__attach_struct_ops_opts()
> >
> > This commit introduces a new API function that extends the existing
> > bpf_map__attach_struct_ops() to accept additional options, specifically
> > allowing attachment of struct_ops maps to cgroups via a relative_fd.
> >
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index b90574f39..be56a5dee 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -13196,12 +13196,19 @@ static int bpf_link__detach_struct_ops(struc=
t bpf_link *link)
> >>      return close(link->fd);
> >>  }
> >>
> >> -struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map=
)
> >> +struct bpf_link *bpf_map__attach_struct_ops_opts(const struct bpf_map=
 *map,
> >> +                                             const struct bpf_struct_=
ops_opts *opts)
> >>  {
> >> +    DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_opts);
> >>      struct bpf_link_struct_ops *link;
> >>      __u32 zero =3D 0;
> >>      int err, fd;
> >>
> >> +    if (!OPTS_VALID(opts, bpf_struct_ops_opts)) {
> >> +            pr_warn("map '%s': invalid opts\n", map->name);
> >> +            return libbpf_err_ptr(-EINVAL);
> >> +    }
> >> +
> >>      if (!bpf_map__is_struct_ops(map)) {
> >>              pr_warn("map '%s': can't attach non-struct_ops map\n", ma=
p->name);
> >>              return libbpf_err_ptr(-EINVAL);
> >
> > [ ... ]
> >
> >>      link =3D calloc(1, sizeof(*link));
> >>      if (!link)
> >>              return libbpf_err_ptr(-EINVAL);
> >
> > Should this return -ENOMEM instead of -EINVAL? All other calloc failure=
s
> > in libbpf.c return -ENOMEM (see lines 11006, 11802, 12288, 12746, 12829=
,
> > 12891, 13089, 13129 in the same file).
>
> This code was introduced by e9fc3ce99b34 ("libbpf: Streamline error
> reporting for high-level APIs"), so it's new. I agree that ENOMEM is
> correct, however it might be too late to fix. I'll let libbpf
> maintainers to decide.

yeah, let's fix this to return -ENOMEM

>
> >
> > [ ... ]
> >
> >> -    fd =3D bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
> >> +    link_opts.cgroup.relative_fd =3D OPTS_GET(opts, relative_fd, 0);
> >> +
> >> +    fd =3D bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, &link_opts);
> >
> > Is the expected_revision field being propagated correctly? The new
> > bpf_struct_ops_opts structure includes an expected_revision field
> > (see libbpf.h), and bpf_link_create() with BPF_STRUCT_OPS reads
> > opts->cgroup.expected_revision (see bpf.c line 889), but this code only
> > sets relative_fd in link_opts. Should it also include:
> >
> >     link_opts.cgroup.expected_revision =3D OPTS_GET(opts,
> >     expected_revision, 0);
>
> Correct, fixed.

I haven't looked at the rest of patches, but this use of relative_fd
seems wrong. relative_fd/relative_id and expected_version are there
for ordering of programs within the same attach target (e.g., same
cgroup). If you just want to specify cgroup to attach to, I think you
should use attr.link_create.target_fd (which is already handled a bit
lower generically)

>
> Thanks!

