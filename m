Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA8BCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5073F8E0001; Thu,  4 Sep 2025 12:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE566B0022; Thu,  4 Sep 2025 12:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4008E0001; Thu,  4 Sep 2025 12:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A35E6B0011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:27:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4A19584C8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:27:02 +0000 (UTC)
X-FDA: 83852097084.26.ED6F216
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id D067814000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:27:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WOBXlLFv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757003220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x52XGF6iKHX3+nNGSEK/taBXgCRgBT1zKgfjO9/y908=;
	b=4Isfv39hsywNtJcleGHilTZMWM6/bMX/Zaafl85AZo0+PZwkNk99dvHt8az4EnefFhvgVC
	IQXnNNF+DmsrVi5y9/EiwgMxV8s9A20duxq8QWDa9i3+8Pk94/Z79l0paKlc3LUJwxCdmI
	9SdZl8rAqqVZCqdyHRvK0jMKWXUtTOs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WOBXlLFv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757003220; a=rsa-sha256;
	cv=none;
	b=vefuR71d/f0Ka3YGsrxZqul489u63R2xw/9Vg1Qn1kX3LukbMOcOuQJjuiDsgi2yAPLk9+
	BhbPBW54k2au0nochPiQkA3i1yuvk9IkLGcHlnV+dJZjE9m/5UlfVcF9Xgud4bqyGhBoEn
	2pO3b4vTD7gQfWEvxnPojgHSoiKdaNM=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb7ace3baso229886466b.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 09:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757003219; x=1757608019; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x52XGF6iKHX3+nNGSEK/taBXgCRgBT1zKgfjO9/y908=;
        b=WOBXlLFvvQfCyxiXFuc8IZl+mN1pg51qqjSNFg4VLz68q8FI/D6ONFOTeQcturmz5F
         gdw4hivC2fhIZREqvYCOasVFpw2beKMD9hba8Ub8Ns4o8xN8MgFwbIkQ4JUE26zfy09F
         Q88Z5Z+PEvxDmoDiWmwUpP5fAAqF/66/cTcheXbNpmOp4+f6Q5gOYqOxYS/3QHIIMmd5
         rgflExbpSdyHPlZFP5RogcUyGizgtHxDamOJ6RgTTaXAFu3lYwmjilWT/9YgQLKqtmVW
         WuLFn6gLRS3DTgwPMmKICDpf2PB0AtRe4/yHCHWhtaa8fwv2nZmztArCbYSziJS4g0ZM
         /f6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757003219; x=1757608019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x52XGF6iKHX3+nNGSEK/taBXgCRgBT1zKgfjO9/y908=;
        b=MwTJqcD1btfi+HAClUBx6n5S7Y0Hws/8gtwt95StCKTLfOTKl8vExHXwaFHdK1BYkg
         JaTYTCC2o68WX5IAGSubNOKLf7d6cNDBK2yqofLgl6KZRqi0h1DMYxLsrf/nYJNT3J0C
         z05S63AaUXIeZV21GTkZIhvjHJr8czIus3vADVyLfvIhUj9UFZJbDf9u9uh0uixf/Q1G
         vByeWllb/M05I0kyCvBc4ISK3Y5TMVyzrfNdMdozYb9SjUx5pl8p52f8tJJyRUBl+F/a
         FX95SkDXILIQo09JifiwIbyPbWlj5cTOPPTiP0kJ8KHZQ4+yQ94N8jng1Dn78ieVx6yn
         Fzxg==
X-Forwarded-Encrypted: i=1; AJvYcCVJ2SFJQ6TklkroXMV5uxzJlYTy5bapIhuqcrHVFfp/IW8qtseJjirum+GhIwJKZ+Yi1TyEIDPhRw==@kvack.org
X-Gm-Message-State: AOJu0YxugDybS5mGPEVgzne+ykWVG7u+K3jen4iwQb88tmWpUhgW3ZIe
	0XMJ82soMjZoC4Zu3kg1lhWGmHg1iM6QSl5itjYLvgWRn5mNv5/887JeslxBpL8wqIjCUcneUjy
	DrIlAaci36M7ilSXDPhWuF+WIhAeh1ko=
X-Gm-Gg: ASbGncsjxAohaJ1+sQgkTUTSxZSW07scikiBJlkrCEqARRBy+VgeOwLknZEIz5zI/bh
	Qe5bxV/XG8b58KSPfvU6a2vENmgfHnWAedhDWBfyEmq6PeOQnYbnjmypLb/87Arf/7cYZ2sdzFs
	4ukea9YLhcslBsKqqo+unAqtCQHAMAnuc9JUwzIIgN20YPsMmp23J1EERdvAjKUpGSa1HSOY0qc
	OI9e0D5ND6SfKJ18zw7F3Y=
X-Google-Smtp-Source: AGHT+IFHSx6hZlZJjgmXEk+skdNc6NPbwOFgHFtM3QRF1Gu2C6CnQMdkH8gTqKiWNIYivCF3n/UdO95dBbR/N21HyZ8=
X-Received: by 2002:a17:907:7f0e:b0:b04:74d1:a57c with SMTP id
 a640c23a62f3a-b0474d1ae30mr464217866b.58.1757003218864; Thu, 04 Sep 2025
 09:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-2-roman.gushchin@linux.dev>
 <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev> <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev> <aLeLzWygjrTsgBo8@slm.duckdns.org>
 <87qzwnxgfr.fsf@linux.dev> <aLk0FuezkcInlM_r@slm.duckdns.org> <87h5xi1e6p.fsf@linux.dev>
In-Reply-To: <87h5xi1e6p.fsf@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 4 Sep 2025 09:26:45 -0700
X-Gm-Features: Ac12FXwS8NBvLhK0GXWhEwLEcG0BPLfgFRE5uUtzqIDYNw67JkiC3-IZJcrgDd4
Message-ID: <CAADnVQLBrOgeH5T2iXa7nNpHTtQvpzuzfOgEgPQv8T_AKEg6mQ@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D067814000E
X-Stat-Signature: qw99g4573369ebmjxe3awdecw7neec19
X-Rspam-User: 
X-HE-Tag: 1757003220-614786
X-HE-Meta: U2FsdGVkX1+PIdyAULlUNxWCjCrkumhEHiv0XFaANY4u098D8GAR9aLdNJR4hBkJVsaADkxPOmX7Kmt864fUTxX6vRTm2qU2abwztFyC68ZfaQZ2rCXFqwWOwgeHtcg5Bm8VDf1KI0lfV7aKfNWYH/9Q/r+PzKRKvXFVmzy60w/sT4iuykZd2wxjxLYq/LCSmT23JYIMH5ThqPKHu8p9sT6XfKg3mfaHarTgBvWT1DOm4KRP4dda0aOA9vczTR2+aHWl4uVacmDDe+mtxztX2S/uxe7eO2f4UcQ/2lk5LMnHAEbpFx2CLGJu6lguEv5iubrbTXje4i9Japw+Vf7d6bI328DbSHl2w70XglqwapEz3SwA1/lLoEdoUWf00F60qoqQbCDIj/TJuKNx6tkU7M8qVHO18FVIYfgJCWxgV0S4f6adhpCpBJZ7c+sqk5vPW3O/LG/WU/nvwyFSGAlMT6ssPU4kJ633et6eyZrlafqjAn1hGGScsE30jwN2kVq9ckdVveUt0r4H0gOl2QWZpNKKIzBDmK5RqX+SUlqTpy6qkjLjrR473o0049XHgv/f+sR3tgrC0rP6z+m5mldZLMSkJI5XthLB7v5wnw3xrrGzBlJ3/BI2bpEhlscVQkPjAlIQ2UdRP/SfBAOnFrxIwROfwDLFEV9grWD1pQI0c7obusXI3y9fPda5XTwTmfjMQ992/oCru185ku1qx5gl2qa3nj6MW/fCtOEc1ST6IfBi0FSU3Nnj1aCUWmCc7ajRtrhjo45xj/87DFusfUGfHgQ0uQ4EmiTW4i8T86vrQZmKe61Kc8iRT11lHua0kkOq3l55HUFE+FS8f141bEUzf9W5AdGta7z2PihIvEHDKrpQEZEwEIKWqvV6bOklSN3ZhUJbH7L3ogE+2lzdjNHHelYXZZ8Up7kcyw4v+ev8S3vLKM74/ld72BEyGZJp4f/fJBD6R4ajltDsrVSfY2Z
 juztVYVg
 +k9Jb2BGiSWHHfeExSfgBBgDDJNCIZ0dHuCgVeeFVUQrocD7/NZng/VQInoIEJuTIzVj76Zv0z/oa4LEw43jeADxZ04zFSX1Md/L4lU4hGBvsw0Sc6oYPxxjVG2pMDDy+VIXmchcZizuHZ813NH9hcDymd7ehST3qlezwJVGxbMkSUmi5LbJCnzT2Rh8rmOb+NJvrSgINaqXPWWqmxMmX7i7DaXezAOJzKEZaua9nMvAzZDfYxWnaD57rHp0s4GjVY5+XTF274GGlZKflSxpc00Y8Zumd8Zy2LNZrP/Qu3z+6mwUmGHQQHl1DitthYzSEZEDzkf3SNSjihIW+TkalLR/09+QlGjMRjjTuIQQRuQizQbBN6SqlbnKtLXpJ4V5ImOhwqsc/oIaB15utW4A3VnFUyw4HbvhWdM08
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 7:32=E2=80=AFAM Roman Gushchin <roman.gushchin@linux=
.dev> wrote:
>
> Tejun Heo <tj@kernel.org> writes:
>
> > Hello,
> >
> > On Wed, Sep 03, 2025 at 04:30:16PM -0700, Roman Gushchin wrote:
> > ...
> >> > - I'm passing in cgroup_id as an optional field in struct_ops and th=
en in
> >> >   enable path, look up the matching cgroup, verify it can attach the=
re and
> >> >   insert and update data structures accordingly:
> >> >
> >> >   https://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git/t=
ree/kernel/sched/ext.c?h=3Dscx-hier-prototype#n5280
> >>
> >> Yeah, we discussed this option with Martin up in this thread. It doesn=
't
> >> look as the best possible solution, but maybe the best we have at the =
moment.
> >>
> >> Ideally, I want something like this:
> >>
> >> void test_oom(void)
> >> {
> >>      struct test_oom *skel;
> >>      int err, cgroup_fd;
> >>
> >>         cgroup_fd =3D open(...);
> >>         if (cgroup_fd < 0)
> >>              goto cleanup;
> >>
> >>      skel =3D test_oom__open_and_load();
> >>         if (!skel)
> >>              goto cleanup;
> >>
> >>      err =3D test_oom__attach_cgroup(skel, cgroup_fd);
> >>      if (CHECK_FAIL(err))
> >>              goto cleanup;
> >
> > Yeah, that'd look better but are there practical differences? The only =
one I
> > can think of is fs based permission check but that can be done separate=
ly
> > too.
>
> The practical difference is that a single struct ops can be attached
> to multiple cgroups.

+1
Attaching the same scheduler to multiple cgroups also sounds useful.
I feel sched-ext should use cgroup_fd too and do scx_sub_enable() at
attach time instead of load time.
Then scx_sub_disable() can happen at link detach.
Looks more flexible from user pov.

