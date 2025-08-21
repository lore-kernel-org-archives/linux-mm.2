Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E50FCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 02:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9256B00E6; Wed, 20 Aug 2025 22:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399AE6B00EA; Wed, 20 Aug 2025 22:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D67C6B00EB; Wed, 20 Aug 2025 22:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4EB6B00E6
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:30:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B10F3C0229
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:30:46 +0000 (UTC)
X-FDA: 83799186492.23.ED8D5E4
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id B490780008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:30:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=M4M0osL4;
	spf=pass (imf02.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755743444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMION88G6TPbiFF7T9DSor/YV4Dhrggsi8E1Q94kAvM=;
	b=N5B14s8//q6HmRxeU6PVYaK2gVycKY3Q21bes9Z1kViLAPsdtTaN4hE0ABEs0chkXwu8h3
	rHij309kMRRfio+oPYy6iw0Tnwp+cdsLvLpy2nAgLOIR9VzsuTZsRU2bQAkySprubtqLZc
	ey6vbp2vWTkpg1hNNPf/N6IzVL0Zfe4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=M4M0osL4;
	spf=pass (imf02.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755743444; a=rsa-sha256;
	cv=none;
	b=IbDr9GM5T3y4QIYUpFow4LTmiCI6dm6USkvfY6Vze4F0fF40I8YCWlHT77CHh3KFn7za1y
	BcK84igW3FoYwoJ2EF59mdJAPv3Nv0m7HCAB+gf0I/1Dhrzvbg+3h2VCE6NCUM4o7Fffhs
	C4sgw9lzQyRcFbcdeO9Ce/Q5IhGwyR4=
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e94dfbf7ba1so511162276.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755743442; x=1756348242; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMION88G6TPbiFF7T9DSor/YV4Dhrggsi8E1Q94kAvM=;
        b=M4M0osL4N2lHIJJBKxLhRA/4SBlfbVMyQQ1NJBZRN1xiZwgrjL7PaPZgT4Xx5wqvqs
         54mCqDaj5QWDrdqfgO0ly1YLc1vTFZURyOb0J55dHKGhGuHUSGubJD6d0DAON/Wd+UMh
         EmVke7plYQ691JZLJIqmbKNsFT8atdhlGZHyRkU9n5i3asMkniG8aMCz+dFbPCf+utco
         fv0qjXbHxcd+JK5hdchcZ1e+HE9WafGG021EVNovQNeNdEnoGwJWhVhSfrLuocJg606x
         4RT0XQDa2VeDKzBRx1Dm2yW91BzNUBgPYO9kj7XzfPk4pC2hWQ7sH1ArJAl1r7r70zfz
         P57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755743442; x=1756348242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMION88G6TPbiFF7T9DSor/YV4Dhrggsi8E1Q94kAvM=;
        b=WaF6vw3kcVncqAhSBLGQU4X1cdQmm+01heBEJSAphanPnn9ikBndbMHWEv1dZAHYB8
         oJIjjpxhqIzPvcM9Oovgv4qsniLUTnyYLuhh+DzbTsv0thOURMc6xnFTEn+doFA2N/JG
         xjMb6UVk0R5lc081slS8H+PARusODWeQYDArbeTw0nfTgsgEHxHHBTMZEELCie/sDv3Z
         U2jOWT2QH5mZnJers6SZGgMozO3DcRJZvEC0H6A2JKdCyexEdnbiz8HWBEkfu2A4DQio
         t7omUrE9vtLBUhccMj35jScEti1kL8Th4dENb2Rvep6VgM4tJo+sAlmUGGk6obPdc9XH
         av3A==
X-Forwarded-Encrypted: i=1; AJvYcCVBXD+yazQbF4HlILXjgU0jnywURS3DmvALiQpafXyEwjvbdpmQsDqlx24SxO1jmG/FmXnP1moVnA==@kvack.org
X-Gm-Message-State: AOJu0YzbX/9glyoh7WnRoaNTyb+vNQS0YY0kDpNqRvKRY29BqrLvhbS3
	LkPivo86nF3VJvr8CNZUaohpBKPhHSfzLUg5pHRiC4iWZb5a5AcBDkK1jLRzGJje2repg0M+wuf
	BM9TxSo2zK3QxcgF/Mm1ngow0uoPG+SCh372gk+wCwA==
X-Gm-Gg: ASbGnctOz5HJg5RFpeAi30NYSbNL9kQ5DZBJvEu6RS7rlZQ9fLmnwZRtCZswiYFRGqB
	MfHQBZulQBn0xRx0at3q6iyqN5I+YXbcR1uTNnUsdbD/ElSzahNt0svsQ+SGFQTA58/I/teSjpF
	QKfkpqsg/pnOsC8BAjJWvJXpiOfknY7kwiaSOho5egf5X+uCq9t7MdWwHy1ccknTjzKxL7lEiuy
	YJEB4sdY5IDkToAvZ7Ti5Bm
X-Google-Smtp-Source: AGHT+IGHwdE1yoE0p0wXWL0FR3kNcqWuprB5S21pgTsnfmdOOr1XNkU1L5aco2yBQOW+mjqEWdEcfSMHAi8UfBwEZOE=
X-Received: by 2002:a05:6902:1208:b0:e94:ee5b:f698 with SMTP id
 3f1490d57ef6-e95088dc93emr1024460276.5.1755743442340; Wed, 20 Aug 2025
 19:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com> <aKY2-sTc5qQmdea4@slm.duckdns.org>
In-Reply-To: <aKY2-sTc5qQmdea4@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Thu, 21 Aug 2025 10:30:30 +0800
X-Gm-Features: Ac12FXwn16lFOJCh2AxH5JioHJPOSpdJ0y3PAE3Dn4f0kUvtBjLfueMmyBwUcXs
Message-ID: <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B490780008
X-Stat-Signature: z9g1z1ffcwpo1aikhka1ed3ccbkki4ba
X-Rspam-User: 
X-HE-Tag: 1755743443-953804
X-HE-Meta: U2FsdGVkX19YAE+D9IOYywa2EpLXiMqoqNFEav83JoGZEA4c2h4j2yWUK0nVWJX4O03g+Uf8EvP9AVjWkkhRStrOb/7cly9NcERxsoPHH1swIMJp5JJP57F+ALgcrrIqJpfpXW8kdKdnRMXRPWtHu4nEwMMEeK1FKtzSq5wwxQWeihDWxrC35m6EQ2Xnw/vPFoNNodDl6sOINECwIFPLWEeXxit5gCk3Rrn97+L6cx236jLOBtPghIgxFx/iGd5ERmM55tuvU+Y5IEFg5s7U68+2LSBXLgZXnFmzwiJdxuQCOzdIWdGibieL555QY23HS+darP5znQwtaJzyc4wArvcAhW29W1iRFMBCrTXSQ1TtIV+rVATj1m8MLi9M7kQYWOqrcFCezHmRo9g6SPWuurpFMSwdWHHkYm0ClhZlbEUlBQhp6J0ZwFjWthkZs2uF+J1iTr75EDj0roWV4Pu3ycnG6ayoWZCviBhkSRwF5Wt97yz0Ae+fo3xu/s9b2L/XiUbfMnwUwwDbP6MooOwrTOzS/15rYjYro/uRKsqvCNqbYfsOu6RTozmzgeFh7SvHX5OR2ZaVOpyoEHrx2G67dqXfnFsAqNyIdOhqQNW7rjDq55ZwTWdSyEigdBWIrAPMymXwVFu7gBpTRSVJ/Ciu+YrilLcJzGxsnWj40cbwv+rM6Am0oys8oHk20c6jD6MfXpuQLrOZ59uuV1jIIMR8/Z6UshjcrvLHY0TMfPIw0xFuwEEjTLZlWQXs4pAzCzkjA4iKZaNdnSBV36nAc7pQTaszEzM+OSJFq6AfZhrIZ/NvvkVeaDilEexIY2e/pEdpl9AciGW4JruVK090NX3yjVB11Mnjcz/t45VewC4xViem4tzfcIb9KHnY3dL7wkvmw9Vax0IdUtG6iLBw5ZDa6Jg9WRxzSJFFfUYTtq6B9KAsEt8kAc8/JD2PxSz4ZKFtkUiSkWkHbzoTF250ko2
 7jIyugEW
 /PKU3sDjySmBBoDI6z2AOqYdjEiy3qXigKdMzlp04zcVGkv2hbo3ZN/XGxiSJyp0iEX6NWUhN2Z/uk+58yql3YMIL/H9rXd8ENc7ni9GcZuzuTQuV8n0Gr40jcfCoRod76f6EuuQq75kSXB3znptIJpyqqPiAzeDEhDlBHEvS+RB/5QEMOsW/024CY+5lIrS6XnUEfdg6K7/m/NWUV5BWUXfJLFE2oo08NPWcoA0fv+1GZZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 4:58=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Aug 20, 2025 at 07:19:40PM +0800, Julian Sun wrote:
> > @@ -3912,8 +3921,12 @@ static void mem_cgroup_css_free(struct cgroup_su=
bsys_state *css)
> >       int __maybe_unused i;
> >
> >  #ifdef CONFIG_CGROUP_WRITEBACK
> > -     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++)
> > -             wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> > +     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> > +             struct wb_completion *done =3D memcg->cgwb_frn[i].done;
> > +
> > +             if (atomic_dec_and_test(&done->cnt))
> > +                     kfree(done);
> > +     }
> >  #endif
>
> Can't you just remove done? I don't think it's doing anything after your
> changes anyway.

Thanks for your review.

AFAICT done is also used to track free slots in
mem_cgroup_track_foreign_dirty_slowpath() and
mem_cgroup_flush_foreign(), otherwise we have no method to know which
one is free and might flush more than what MEMCG_CGWB_FRN_CNT allow.

Am I missing something?

Thanks,
>
> Thanks.
>
> --
> tejun

