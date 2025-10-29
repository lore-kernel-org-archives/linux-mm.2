Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693AFCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233028E00C0; Wed, 29 Oct 2025 14:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A518E00B2; Wed, 29 Oct 2025 14:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1474D8E00C0; Wed, 29 Oct 2025 14:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F34B68E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:01:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACC34C0751
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:01:15 +0000 (UTC)
X-FDA: 84051918510.21.4CD6F35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8740C80004
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:01:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgJGfjhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761760873; a=rsa-sha256;
	cv=none;
	b=Sv9XPdiB0r4x/KYCMoIGuIa/gNXP4ctioaYqp7re6osHj46QMsAs0UTo0Gy7gE2908o9j7
	jYI1/Qeyl+5gIZrWOK8QK/VRw8HTDLMfmVnOfM3cUTHvmMICfwI83KR7jCy5KOUfz6aWb6
	qjXAWox6NpzF+ZEoBXvuNwuzahriK5s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgJGfjhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761760873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fk7oUVcjK2KBRuiCNTpCTkGLdUhoogZBVjBBN9+zhRs=;
	b=usWUhPKhiutzWC28JvzvwvhVttgL/O8WmRlks+7FXZg8asJ7bfyyuJwMWuiGsYaSAisCl5
	a5t7PdbNli2bh3e61kRqgBwatouXsHHtuurEkSaiLHRl/ADH8No1nlCp5eZ+D5/rakELzU
	fobhpC9nBRCfktiiACRFCdxabVwDelQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0F50621D9
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEDFC4CEFF
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761760872;
	bh=JkICoGulKusPgrOc+3fQ7LIX9fdSC22eFlUBUNRokJk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NgJGfjhJaNs4l82+eMSh2r1EAx9uk5HPJAyypHw9PeFAnh2Pd/T9Ut6BEUZDAxvMW
	 C51qBFa5otR/uKQ7dcLeycr0Ay+T0GY6ye9UTaCGCjrJu/lkMmwtbaJOSfdo3XJHd1
	 ObCh5UYVDwzRvT+NLz+PqSgB5CBSK1564+6og8MbDc86VgxBGBy1xAjPIcIDlPsT0u
	 hW5hzztdbZa2bABOBiKSqpn0d4KBxiMJThHlo5sPOMM2g34vAqpZgX63HfzlaZ4nN2
	 H0VO0XKTKApg1SgG+qo2ojtqWg35sQ3GMu5U4W5++yNuGiU1RZ3tsm73dC8fHRQsUt
	 ASSg8KjoiFbFg==
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5db4006eb0fso134364137.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:01:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV9gJsK2OSWul5jJdA6JH+nrWoNZiPPtU5Fv8PhmyPtEI+5sjEYPw4cKHz2TKTCrxkpjyUIdtPEyg==@kvack.org
X-Gm-Message-State: AOJu0Ywfn1HYpVkgGJNzNU4jYdWNndQwPReuhSREbIyIvbN5pykuxBpL
	xYHxRnKcSzBmoBIhg9AaspcHwJ6BOMn5UhUnAzH/K3S3hb+Pyit/IEw3DVfv1291FaR/NaT7wXK
	eryGBUy7mc6iinxPAY9NXNLxhX5pYIGg=
X-Google-Smtp-Source: AGHT+IGGluDTc586NCbCdlpQu935QL/Y8fXJ0sSPv0be/Dt3sEhhVMZJsoK1V7je9HKakunNObg8WJdRv0NwLivAn6M=
X-Received: by 2002:a05:6102:2c06:b0:5d6:6e6:e097 with SMTP id
 ada2fe7eead31-5db906819d1mr1467428137.33.1761760871248; Wed, 29 Oct 2025
 11:01:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev> <20251027231727.472628-3-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-3-roman.gushchin@linux.dev>
From: Song Liu <song@kernel.org>
Date: Wed, 29 Oct 2025 11:01:00 -0700
X-Gmail-Original-Message-ID: <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
X-Gm-Features: AWmQ_bmAg580HVj5YBdyFsS189BaIn-vGa9b15QV_82EsPqPQmTP0zb5M7q-qAQ
Message-ID: <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8740C80004
X-Stat-Signature: mfotr53de9nsjd9ca8jzobkxyqnrzjsg
X-HE-Tag: 1761760873-182025
X-HE-Meta: U2FsdGVkX1/EawuU6OP7OMECkY1Gi+77zctEDZHxzd38dcmc9Q7QfOL7MGG632AHReDI6OtBU6L0HLCAvq3mB5eEUfVmbDdcogwZLbvjdMP0gndGrMXh/inVljhGjGjSM5QJOTgq0uT+fznQlyUiDDuwQborwAFjrrpyy/huF6PIf4M/E1CFJAkDBO/KQ14mTat0P4ELVmIB3nFHdBQDJu2dCMLaY7x/n6NU2gyaAaBvtJ4irxb/3FAZEZsKYA0KzeNxixeJ2uHzof39Z0GwutvXo1HdL6/rMr1bh5VxZmehFqaeRt5qUrdePAdCoAryzk7enJbr57WcduN2iymQ9Ze+lzqLolEyror79KlshUYMtAThGumyJqR7D8Wr2PrvaNl0d1N2Qu220sCH+aIyqzAYmHk4oUY18osHPSU3steuMFo679BZy/bGcSlBe+p5Z2BBKx1p6zn6FpBzwo9NJX4j0PIZ2LE54xMOtDuEJyozPNmsy2W8UhweNPHARvsUhQQ2TSKdPQjRi8e1BPaoN+J5q9NwsyUcSPWVQqX4zKA3xMXWckraPOvFUbb090sjD9JMK7jFEt/KGanp5+KUcQDztHX+PZ/6bvjTBod99MBmuYyAFKvRWIoXmEu9ID6b/iaqTjS+PT13P/BycweUfyBu2CXPmM6WMcWh9Xt9OKnFawSKvqAlSm72f88Rvov2z+M+GQkIn8EoRxmffY/BiP2r1WFtGD01iOcUROXqNPreKmHK8Ojp5G8p7/ACpamMiMLyOdOrs5dlp1cRVgvi6ALlc8m3MPKKze0/1j1e2vYqOIG8jNYjBihDJXQPd/O8hEfA77hqCDjK+orKajIm8IcYEpXo/hcNkeuMjafbpNUubF2KMrvdbGwy6wYGCPBFlnvx+8IAW6malAVgMfv11SDlRuXR3PbtOsT7xu4YPWduDORQ/bQvOaaE7F54Nz0yN5j/iwt82I9JR46Y7bE
 6GEaGRLL
 inTUK9CxLse2RQSl9/J8dsj9cG4rrMEjtsbXR5cuiDL6nldEsVmkFxFE+TE+ygVWdB9JhmcdsqbXReGk/QW0y3H4y03Vbf0v88k/m56LuEao/CLr5Q9Z8cyW+o5jOe7WdeOZ7HDoI4ESfznE1hD4pfjiOwusA4teQg81ArUbzFR+Z4bV4LX0yFmtydXWMtvIt6kcfIsZtjp53gQb7JEhvj+ArjOWsiU5kbPVsCE8Hrd9Du0gw/eq4L89boA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 4:17=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
[...]
>  struct bpf_struct_ops_value {
>         struct bpf_struct_ops_common_value common;
> @@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_attr *att=
r)
>         }
>         bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_=
ops_map_lops, NULL,
>                       attr->link_create.attach_type);
> +#ifdef CONFIG_CGROUPS
> +       if (attr->link_create.cgroup.relative_fd) {
> +               struct cgroup *cgrp;
> +
> +               cgrp =3D cgroup_get_from_fd(attr->link_create.cgroup.rela=
tive_fd);

We should use "target_fd" here, not relative_fd.

Also, 0 is a valid fd, so we cannot use target_fd =3D=3D 0 to attach to
global memcg.

Thanks,
Song

> +               if (IS_ERR(cgrp))
> +                       return PTR_ERR(cgrp);
> +
> +               link->cgroup_id =3D cgroup_id(cgrp);
> +               cgroup_put(cgrp);
> +       }
> +#endif /* CONFIG_CGROUPS */
>
>         err =3D bpf_link_prime(&link->link, &link_primer);
>         if (err)
> --
> 2.51.0
>

