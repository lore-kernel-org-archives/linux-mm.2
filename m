Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B0FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98DE8E00E5; Fri, 31 Oct 2025 13:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C704F8E0068; Fri, 31 Oct 2025 13:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85A98E00E5; Fri, 31 Oct 2025 13:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A745B8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:37:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5943D88ACB
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:37:35 +0000 (UTC)
X-FDA: 84059116470.09.7F932C0
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5A216100018
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:37:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PR+ENZTo;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761932253; a=rsa-sha256;
	cv=none;
	b=K4DmmjEuZeXzC2eN1Dz9e5rwvhVUOp5KHdSd1nx8Jbg1rx7+hC+gmNhZWN4Qqv2BK4uI9u
	bx5cSp3NblwxcPCz7Rf3FTOYkrtvNn0P79BpgC1WFqBMBiphXYRVc2SO3pzEnY3PGjKxeE
	z/neXmFO40Ulp9iq+V7dRIUhKXpjUyk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PR+ENZTo;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761932253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5mV2w6my4c1PMfXawO9gB6t8vYeJrvxem9h0oKA3+w=;
	b=hvS1g8cGuEsd0qMHu5k/Qke2odsr+1mtGsGpbB5+uMivgdnKcqxV8H6JS/hxv5wgS6wu4G
	sJC+orPT3kgMRFinaTIGYNv7AS1tOBqe8vydKxXUn4V6D3P6dx+0+szai3Lk6hMQUcnVpG
	pw3DkrFgxp8PwIm+GBQfQAZjlvA/j8s=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47118259fd8so19320215e9.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761932252; x=1762537052; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5mV2w6my4c1PMfXawO9gB6t8vYeJrvxem9h0oKA3+w=;
        b=PR+ENZToFQ6sO8xXMVkZ0slOgOy35pVux2Y2HRG+KsGbyvMFEqFElFYFtKkq1ePqiw
         A6R7YdxrB5tIMRvEqmUZbxm3+XOuXXarNUAjZhp5Kmd9jcoEdVNgKOIRbMNP9HqWrQad
         /xSVOU4SGCdyo8VK2Q9EuqSKccz5BiR3g28s9JM0ImOBU3Q4LD2D8dtdJ/3LP4t8zMWJ
         OxAj/Dz8ouvcMr5WBQJBtJSjMKlP2qTWlejz9pK1Zlk0KS9KzATccukaxb/B7qLLQPca
         3JMZLXMdSj9eDif6LWpsGKxF/SCI8FE7mS9seq8h/+F5sIQ3LlwWph7OZAQO2TkWD5lf
         PCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761932252; x=1762537052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5mV2w6my4c1PMfXawO9gB6t8vYeJrvxem9h0oKA3+w=;
        b=TIXM2CUjbWBg+58exhpYzXjVJjBEXaussnZMLgAybSq70gDqj1AlV+6V49B9Dh2IuL
         2LauiTCrBivJEJcVKY7QipELFOrYnxfmGdgEdpPMHOpaXvTJCKlzNN9UkouF1fjm9EkH
         VAVjEwARJb0gimUJFx2BTlM4CHC2NKHo651TURI1NlytKczq/AHslbHLSIcwHD/Rpaok
         sL46yA8NGpF17ut2/C88mjMfIo+A+3kPgehPKI2hFzyO/mExBxIW5xjTJeT/VjhaqpuY
         K1JE6pNUSMbsrbcUn2zUtSVTnEtD0RdRXq1ruAk0Jx4NJDqefJ64q4JZn1DDxOsVikqj
         Yrpg==
X-Forwarded-Encrypted: i=1; AJvYcCW3yurcZNMw44oa1rzldzf+sOMPoOIkiZPr5vIGjDQ4R4puoVvn25GNmYkL8UbYwVlohPZxSpu1Sw==@kvack.org
X-Gm-Message-State: AOJu0YxwPTJ0TB09symwLU6s2oJounM0a8HkQ1PufqmeAzn1bKws62jl
	jSoGm3u5E6Q8UF5mze8EOqYwJ2WB4C2iF4cXCwtJGtFqLmhStQH8u5Tmomv8UtYX3scJ6dzygFJ
	7Ntpm+LLRqqWB0RGNMZa6cpzHco9IMCY=
X-Gm-Gg: ASbGnctIA+B2e5aNxtJl0+K8FTz8gs1nIzCNzz4ixeVUkrB/6WUorBBwpF8nAz+CjJm
	uBd9p++gsKyLt5cpomG3CG5/bYrR7jezeEwT+EX8oRpBvNRKDIdPBj4+BjHw4c9NO9XQEzRRgm6
	JJ+tiQht3RBtq8yaxJgJalPUVSEViT6hwoVfj4ZI0Hcno9jgbHGT574UJKOhgV7/wg669zYHeeS
	GhXrUkCjn/hqfOYLvhDgNMTy/uNyIQ5/1teBe34QUEyMLdscWTntA1kHMbM6J6elT05uB/HQ3CD
	4dtF6eZZ/4lNxzBjvA==
X-Google-Smtp-Source: AGHT+IHPMUcDW3YwpEvtBrlqSkWgH3dOQo9Kw9291NP88P35J7TeeNcT/Tu9V9VlCr57x5pMjLGDLOmypXe3JvzCues=
X-Received: by 2002:a05:6000:2585:b0:428:3f7c:bcfe with SMTP id
 ffacd0b85a97d-429bd6c1ef3mr3470559f8f.57.1761932251229; Fri, 31 Oct 2025
 10:37:31 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev> <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
 <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
 <877bwcus3h.fsf@linux.dev> <CAADnVQJGiH_yF=AoFSRy4zh20uneJgBfqGshubLM6aVq069Fhg@mail.gmail.com>
 <87bjloht28.fsf@linux.dev>
In-Reply-To: <87bjloht28.fsf@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 31 Oct 2025 10:37:19 -0700
X-Gm-Features: AWmQ_bk3MBgTJKB4MZUJUE5RMJOP5ctpuIVST3txj8WpDOUYgUkSaXNEbEZ7Ahg
Message-ID: <CAADnVQLHT7DrqwNb_N_==vxCdtX3QvTyZKxZa4STw4cD-WKswQ@mail.gmail.com>
Subject: Re: bpf_st_ops and cgroups. Was: [PATCH v2 02/23] bpf: initial
 support for attaching struct ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Amery Hung <ameryhung@gmail.com>, Song Liu <song@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 89rpxrxxk5xsyf74ru1hewut9wzt7uco
X-Rspamd-Queue-Id: 5A216100018
X-Rspamd-Server: rspam09
X-HE-Tag: 1761932253-897535
X-HE-Meta: U2FsdGVkX1/IjjC4ajBjSGo3lRImarfwQ0WaHx7Z4yGhwdjdytZ6v6TFHkeuJwIS1opHAxWl8dOKicYI9Jyf42Qgw5FV1bjSZYc0Ga8390ZdQwrpu+bgUtM9ZGs0CtmzvJqzqDI37cB27zu5GMDEFf2KaG6SKYEepQKNnpzVdaJyyQYeFSEVhnMGJgAUBpjAhYQCDkh9vBV0pnoXtfnaKHuFvdZpv2w58D5o6DODIVEtxb6lb3NHx4T4fNw+3xsU/EiBtQEgmMudlyo5ygwGjPCFWC4pvJWewyoXMpnf2PDdtzWamIjxJvPu221VN2f7tD36OKVB9CoJoFpJtut33wMI2nIkxYAIoTWkuUl9PfE5W9oy24p+vTfOeWm/Gf9cDZ8oi/azd90QkttT/yPS7X56ugeoYSjANFuBJi/+g/Ifn3URz0OBbyR0pTnAzVn53dQUE4usGUZenNJ7rUvxHeYB3nYQkeie25bms00GikGSduY5fI+joT4kuUoRQ4EC0QL0siSecIPzhVn6Faies5EeYviuy7EJ7q3Ws0R2AhPaQeeI9K/wQRQ/eNWDy2e3KVTz/yWPmfTvArU0C0U8BG9rMcVrCpuPoIQ+CdXSNPol03bj024N2svdmjXeWMQVlNZDEFC1/KYMUk2b5h2vo4pISD9751sjHfqFtLNjYaVdh6CnvbVFLiX0MvtPRUQsHQ3Ywke86N6CWVsELlXksNgSp/mv603J3Bz7cRDy2BGKWqYO25WRoO3QQ5DFUvW4HUnJSZ+D3ZRZyj8NkPW3L8ganXRJ8+/yPE5Hw8zLaZQpi4Q6IN48/hGWBfUAcPQhTeOUMoUREOFxrJLog2eBKEPCOaYz2KCzSFSW9shrXM6EL0hTtkai7ilP6BU0+/j7UWZXjDq4zyXfQxcNdZ1e2y1+t9c7boVeuVcuEn2lR9c1WyqErws4GyMCzrWOKacIw/Cs78pJ+ppXt91fVTL
 Y5ZbkHtU
 aa2SmUaT6nrtEm87S0GGEHU4s2nra8e/Nieyn9tFQmNxoysdWogCA2DW3KXa3TPR8O3zg/yywtzAkXpSU+lgZl+9AbeOpp9OterKP4sYJ43WvJ9Bp1N81w4yS3liWFR+67dx/5RFgYzjsVvqkrJfl+BBR7M7KdSsC4KMjeJmL0M0vqWS3vXBiLbVfd0vbD6ar1DCQ9wlzb98D5h424ow9ciiwe6V/PGJJpkdWBd0XvC18oqkWiEFE+0AcXYvczz3zTtrhdI4XkGwdfJ/OVAFQgpJDMZYswNavP0WYDtteYCa1YkH2b/kKDNVXHCsJccGr4CKeicwNbSjIRgc5G23v5QqecrevaD8ycFRQvQhxRsqTExHjDcmQha8bg2oaPcMivAVGuF+aanYOoftKjDAmKjKPeZs8SnC6lE8rtTIERS/SOPs0+mDGLog6rDIH/YnKzpzGEH81Yb4hZGAOR2nzjL5WUE2tDrWRWxowrbh9NJ0FsJ5VwWGZFOBK8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 4:24=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Oct 30, 2025 at 12:06=E2=80=AFPM Roman Gushchin
> > <roman.gushchin@linux.dev> wrote:
> >>
> >> Ok, let me summarize the options we discussed here:
> >>
> >> 1) Make the attachment details (e.g. cgroup_id) the part of struct ops
> >> itself. The attachment is happening at the reg() time.
> >>
> >>   +: It's convenient for complex stateful struct ops'es, because a
> >>       single entity represents a combination of code and data.
> >>   -: No way to attach a single struct ops to multiple entities.
> >>
> >> This approach is used by Tejun for per-cgroup sched_ext prototype.
> >
> > It's wrong. It should adopt bpf_struct_ops_link_create() approach
> > and use attr->link_create.cgroup.relative_fd to attach.
>
> This is basically what I have in v2, but Andrii and Song suggested that
> I should use attr->link_create.target_fd instead.

Yes. Of course.
link_create.cgroup.relative_fd actually points to a program.
We will need it if/when we add support for mprog style attach.

> I have a slight preference towards attr->link_create.cgroup.relative_fd
> because it makes it clear that fd is a cgroup fd and potentially opens
> a possibility to e.g. attach struct_ops to individual tasks and
> cgroups, but I'm fine with both options.

yeah. The name is confusing. It's not a cgroup fd.

> Also, as Song pointed out, fd=3D=3D0 is in theory a valid target, so inst=
ead of
> using the "if (fd) {...}" check we might need a new flag. Idk if it
> really makes sense to complicate the code for it.

One option is to cgroup_get_from_fd(attr->link_create.target_fd)
and if it's not a cgroup, just ignore it in bpf_struct_ops_link_create()
But a new flag like BPF_F_CGROUP_FD maybe cleaner ?
If we ever attach st_ops to tasks there will be another BPF_F_PID_FD flag ?
Or we may try different supported kinds like bpf_fd_probe_obj() does
and don't bother with flags.

New attach_type-s are not necessary. The type of st_ops itself
reflects the purpose and hook location.

