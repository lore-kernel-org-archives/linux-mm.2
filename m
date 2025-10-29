Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3613CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 22:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37898E0111; Wed, 29 Oct 2025 18:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7948E0106; Wed, 29 Oct 2025 18:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7D98E0111; Wed, 29 Oct 2025 18:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C66F78E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:43:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 635735B8FA
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:43:54 +0000 (UTC)
X-FDA: 84052630788.06.F91195A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6B6C040004
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:43:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VQcEL8j3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761777832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wik67zmjPJSCJArpOPAfO/nO0IlbnlsMUwHITZGrZG0=;
	b=dzHn5rbqJT0SKwioAdqSn1QJDHB3Dg8yZ8NoM5g2ONq9h2MPiBwORfFmoPLtQ2AapnXGti
	joGdFTyUj2s78FBlJtph+6sY2gTJsnYLbnn7XmF3ciIt2PWurBeMGGCBMe0F+x+qccb0Xg
	12xcOGz9ISjeBS9SROtsaZ+7MG80mKg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VQcEL8j3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761777832; a=rsa-sha256;
	cv=none;
	b=jhMnimZO27KeQO8E0VadD+481906CGPaEsOt49USIAlci/S0786lGbnAnDWAzcybpZ6nFR
	6g7gCXydhg0lMXixQFAONNzAPDVpcfnI21YSK+2YM+wobyWmxUHWbhNe8nW33OVkvTNBZF
	mIDTUlHwnlbKww361u7rAdvVfzKM7s8=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4770c2cd96fso2582865e9.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761777831; x=1762382631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wik67zmjPJSCJArpOPAfO/nO0IlbnlsMUwHITZGrZG0=;
        b=VQcEL8j3nvxtBmOvipSSiMQeivRwTONWeJlo/2SZAvuNhzmPCMETBkH1aR9902ZkNL
         p+EQc3tC7apMRa0wugxJRXF1YmBKRv0vhPfdMHpcwiG6mOkntLcWyqnZ6O6oTSJokKlC
         wpLcp/+ta3RGv+9gpGN8KfrwIO+aOlxc9mCBTwXCDKmnK7Uml0XnePhejhF0lQKHTkBL
         HUxFovsFD/rUzXslru+eeysa26ZFp2VK8uzj9oFWjLc8kdNYh2an+9FfK90v08D7s9Ba
         FVuKee1Sn3BwKhnNEEs8pggbyiJGyf0MIhfs7CEHiXWZ9AlmMMvPSraFgAVq/p7YDKyC
         AOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761777831; x=1762382631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wik67zmjPJSCJArpOPAfO/nO0IlbnlsMUwHITZGrZG0=;
        b=Tal4nw+CrqGogxbVoeEHkOdJvMBQ9wymWAvt/2lTcx0dDc3xAk7aEe9YWTGSrMsK/A
         1rvIEOSUerEAPTaM1eGuCgZxA1+Yw1NASVavwTAXhiPRMvCiQe5AXTJBB/SHg73LOlY9
         4sjkJmft1mlRN0+uOb97SCklFRmobzZgOAeDfZe08gr0WKVxtOfvmpKYyb1s7CxVv2Ns
         cTo3iBwSMNarjdMrUbyCUeVNCsWAhrIqeMxHxfM0QYYZC9U9dC9v+srbqIfS5KBNVmn5
         GYOVPqD2jvvhWVfjHegQekfLUVCk1diLVA6Txp/+nn2qcZWVW5XPMVp9+lWY1CAfmq8v
         BxPA==
X-Forwarded-Encrypted: i=1; AJvYcCWZ5gq34ip8zRksjaDLrgyX8y0bYTfyEqMaj4TiFerS5roWPg3gLsDq8Xmb7uGibJhCYM74eB8TUQ==@kvack.org
X-Gm-Message-State: AOJu0YwKK8ggSgTX/rLqTGAriERP4QUCWTPcGKwLBzZf3ADHullaWveU
	m4c3BRw7FlrGA5oD4y0mqbfqQU5Zw2ffBjNKsQbfujKkuPwDRypyCCaveuWoe8vX2mmV15UmWcw
	aEIjStvdHQi/s1PXye0v3TFhAoAxmaPE=
X-Gm-Gg: ASbGnctcV7QtxI+7mTZXSDs4mWOSIPLmnbOIvyqN+OxKuVR/2XzdyaijdLLbpTgsvPO
	x5vs4CF0HR8VvGMkykxIIR+p2414Z2mDonTrb9z8gVHwRZXyjdLe1/b8GMl52Wal4NQvceulCtU
	iq5GqD7e3ySCrFfMiAwpiEoReNnYpgsKQTftNB81MwbL5Ue4NwQOSw9vCbZEz+sqMUEBn3Nba20
	H7zasyk1PKQdvsbt2KpTk+3bJD5NuL7gksWFKP7hkKRRsT+YS2JLZpGjE5afsFhEP4pBMLvKbX5
	sBtOzf23oAjefcoEBHCrlgWqVfkT
X-Google-Smtp-Source: AGHT+IGgG3j4M2SQf3XFssiae2E5GaU0Oz0HOJLZDxtGjEKIMo/1gRVHcuNdOoC/ksGXyg/SfrIqUSHv9CMrDZOG1Sg=
X-Received: by 2002:a05:600c:3e07:b0:46e:48fd:a1a9 with SMTP id
 5b1f17b1804b1-4771e3fbdcemr39702415e9.33.1761777830545; Wed, 29 Oct 2025
 15:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev> <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com> <871pmle5ng.fsf@linux.dev>
In-Reply-To: <871pmle5ng.fsf@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 29 Oct 2025 15:43:39 -0700
X-Gm-Features: AWmQ_bklQRlCeWMvvDMXXjosBJpVWn26QkhuJgrczs1PBday5NsqxYLilK9uBkc
Message-ID: <CAADnVQJ+4a97bp26BOpD5A9LOzfJ+XxyNt4bdG8n7jaO6+nV3Q@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Song Liu <song@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B6C040004
X-Rspamd-Server: rspam03
X-Stat-Signature: s89xdj1xyiyiix4fand41gccrk1i7rjr
X-HE-Tag: 1761777832-474131
X-HE-Meta: U2FsdGVkX19IPFZTx+Eixh7FKUXk8rTvjOOL8mB02bpEm7ib0OXSraMJAYotOp654DnB+X2C2FINcUz/PHNpoYLnhA7q29SVMQZBSw299HsuoRe3hf8JXPSgpmkQM9vDw6TUG3u5/9QfJExvDdo5po3NfOSIwdTrf38MBP4agXEXoUl0zLWdqeHHi/Za/+mnMq4I5HjEQtZMTyq+94iNAtm43N11IrafUdgF32gPvKNyfsqC+UZkwZ75OSGBxOh7tAy9b5ookUaGVs8r7Ni0psl41S9oE0zpcD4Av/OwR2HAMJo5kVeUH1pxrP+8pynR/eRR+b0Yig4pWiHmx1ubNeiT025F3M9Dg28bvM8Midqb/6JfX9Rd7FcwBXgedZS+bd4bTZqOnkeYrG2D/96oyubBFX/gZqtppyr4HJO42jfY9yWiiCqVvDU/0DZkyL3lKHDm95dJFIIz69LzKnSR5fYKFq2pKCQKHr95JL+CHd602WDQdb8874i5daGfCfW9acOUo4Taugs/9PsCE9ymJ68aXQ5GEmf5t5srdhBmpbvkF7p7VjNqIxMNv93egid8EDba3LY9Zs140P4sm7ghwNHoYSYsrX6RAw3Nbl8jYkoOc024SdUQtf34b/K55IEdA2AarHjzvTg4OMd9G1M0oHu4HcsVXdmC6gqU0EA7bWH2vd8r0UnxMrUbLL2MUHhMx/W2r4IWtxTK31CJzOVpEZivUQ82PpZ57IxXpZkgNQWVOgqPlNfQxsKdT0rKGPmyfx+cgrHIxrPl++eZqlWvlJuSPK964/HWefRbwglcSI3Qkek3hdBRrMeXQ2fUlz7myOq/qDzA7zKCriA967nVn8ohgP62C8DySXpe6TfnZJI/X0073/Vl280YjHQKwBJXmf8NmnRlhIn6fg/0mYQqKFYxi6OlnCXM26O/YqpP9RORgz5qA/+kD+yIBsChE6LRnW3ppdcxqaFLcExYYH6
 vCmARMtO
 wQyRjIlgdDXWsejJf2m0hbBsmVu07VAiPj5YquaJeB6X+R9Bvdg+vYz1CZCGJ5oV0EI7NzFAfEeQLmApND3d3c4isKE0rFDSlb+6sWNS3W+BJH4d+5pAvF13K98tTW5oZgjjj3p4t6BxmbRtJ4QCUrfFh86dKC7he12hUaAamjvkTZIxAPVZctq1HkiUtIlX8lchGry/6z0APrD3f0r617npQ2siiaSV6ikrgw0wGsbaOV+RQErFHlwS2emc/f7JH5K9zkRZinzyI982AKlL87qghU2lU+WgvD4+dG7SYqNmEHoQIwdJiC/RnCVZAUISjoGcsMIxTWycFYPBbRmG+SNj0b9RGUhNDHNN1+6zudH+JVydidwHtMaUEdA/aN6YA964nTcMvn+LwXxTESmLjDCbZLTgCVvQktjyr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 2:53=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Song Liu <song@kernel.org> writes:
>
> > Hi Tejun,
> >
> > On Wed, Oct 29, 2025 at 1:36=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote=
:
> >>
> >> On Wed, Oct 29, 2025 at 01:25:52PM -0700, Roman Gushchin wrote:
> >> > > BTW, for sched_ext sub-sched support, I'm just adding cgroup_id to
> >> > > struct_ops, which seems to work fine. It'd be nice to align on the=
 same
> >> > > approach. What are the benefits of doing this through fd?
> >> >
> >> > Then you can attach a single struct ops to multiple cgroups (or Idk
> >> > sockets or processes or some other objects in the future).
> >> > And IMO it's just a more generic solution.
> >>
> >> I'm not very convinced that sharing a single struct_ops instance acros=
s
> >> multiple cgroups would be all that useful. If you map this to normal
> >> userspace programs, a given struct_ops instance is package of code and=
 all
> >> the global data (maps). ie. it's not like running the same program mul=
tiple
> >> times against different targets. It's more akin to running a single pr=
ogram
> >> instance which can handle multiple targets.
> >>
> >> Maybe that's useful in some cases, but that program would have to expl=
icitly
> >> distinguish the cgroups that it's attached to. I have a hard time imag=
ining
> >> use cases where a single struct_ops has to service multiple disjoint c=
groups
> >> in the hierarchy and it ends up stepping outside of the usual operatio=
n
> >> model of cgroups - commonality being expressed through the hierarchica=
l
> >> structure.
> >
> > How about we pass a pointer to mem_cgroup (and/or related pointers)
> > to all the callbacks in the struct_ops? AFAICT, in-kernel _ops structur=
es like
> > struct file_operations and struct tcp_congestion_ops use this method. A=
nd
> > we can actually implement struct tcp_congestion_ops in BPF. With the
> > struct tcp_congestion_ops model, the struct_ops map and the struct_ops
> > link are both shared among multiple instances (sockets).
>
> +1 to this.
> I agree it might be debatable when it comes to cgroups, but when it comes=
 to
> sockets or similar objects, having a separate struct ops per object
> isn't really an option.

I think the general bpf philosophy that load and attach are two
separate steps. For struct-ops it's almost there, but not quite.
struct-ops shouldn't be an exception.
The bpf infra should be able to load a set of progs (aka struct-ops)
and attach it with a link to different entities. Like cgroups.
I think sched-ext should do that too. Even if there is no use case
today for the same sched-ext in two different cgroups.
For bpf-oom I can imagine a use case where container management sw
would pre-load struct-ops and then attach it later to different
containers depending on container configs. These container might
be peers in hierarchy, but attaching to their parent won't be
equivalent, since other peers might not need that bpf-oom management.
The "workaround" could be to create another cgroup layer
between parent and container, but that becomes messy, since now
there is a cgroup only for the purpose of attaching bpf-oom to it.

Whether struct-ops link attach is using cgroup_fd or cgroup_id
is debatable. I think FD is cleaner.

