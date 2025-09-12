Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E89ECA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34A28E0007; Fri, 12 Sep 2025 17:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C598E0002; Fri, 12 Sep 2025 17:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E492A8E0007; Fri, 12 Sep 2025 17:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7FEE8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:24:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 859831A09C0
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:24:41 +0000 (UTC)
X-FDA: 83881877562.23.0CFFFF6
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id C3EE1C000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:24:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BTyGw8Vj;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757712279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWm9YsYf2w0GyNuqpvEAceO2ybRB76x2x0lUOA0o3S0=;
	b=jKgMtvaeVb0RLz0ddizw/SUO6gvdTO4yxAgxF6CkZlURP78qs47CX/vKKfgttBsHhEjJg4
	+ntdvN0gVUePMzB89TwiqYAjWJJj8bKoP0eU8ygIFvFxa3oR7sG/haSu061N3hFZVmqmUC
	81hV28M6nh4uPPHfKlt8ePBUv5pmGho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757712279; a=rsa-sha256;
	cv=none;
	b=WyEgmUDCPi/nS65hgII8wK4sTu4xXXboLASMqJB9VVcmdLF7ppA7lVmpVXD6jDtxtuE8vY
	ZPIT4h46gsUomMFDe+RRJJpqdenrL6Qosu9EG72CG/ouG7bCazA7+PQp9iWB35FSPOQZPS
	sEz5VSBxUBT159rEKxo7Ynw23zvLbpo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BTyGw8Vj;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3d19699240dso1954303f8f.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757712278; x=1758317078; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWm9YsYf2w0GyNuqpvEAceO2ybRB76x2x0lUOA0o3S0=;
        b=BTyGw8VjSKXs+/2QGGM1GcpS2KgMkjl9Pe3TgQg0dPBmbDPcD9MCvr91qHDULxubS8
         A8JOKc7vaY79Ax5JbNTmM+FT46WFvRDguzqd1BG7k+QP+ylgwotXnZFMTj16HVV3nLgg
         QmtKMA5ln2dks9ZGnoqVfVMkR155OE4dvPMu5zoLMHXA94W2dE/VaKMdQDK/+taPSgnl
         dKpVEluUHmCDkJ9C5a9SOZ8DqhtjY+RJQYgtLo+ciRcRYGrMj5h0un3E/FAFMQaknl+W
         tyalCQFXdOvJR8Tr0R15GS6jcJy9yOaUAsNgLWj3tS96Alyzw6qgDDqHlQ88hkBk8SQR
         rbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757712278; x=1758317078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWm9YsYf2w0GyNuqpvEAceO2ybRB76x2x0lUOA0o3S0=;
        b=UyFEcBt8szZR14ardQ5GrUPW8WBk957s9FWg1MyBgxKN2raOE4nVYcXo+ljFi97Q7H
         VBWh50QExp7qXIyJU2NUqBkvL7UUU6F/DO5++U44fVpG4uVQ9wnHoBR676KM5PzncSOW
         Yu/p2PYVtmdeK/rHl1FV1t3xK41nGxslF5VtgeM9IjhDL7NNFNqXls5E/yLBb3jM5Wrg
         U5lDZHZ9iVwlnx0E2u5yNssYP54fLkpY7C96pGOqpmicGCIwQonkV9FixZUlTB6wNzif
         f+XSAeisvRkLKYXxYA5h7JjgruHqS1fKSJUyJt+D8lxTzfKu2a2G89RIldafRKTi4QV8
         diuw==
X-Forwarded-Encrypted: i=1; AJvYcCVE+JAQcswvkHUgG+XPMt63SPTcLSJI5Lm57RdTY1nyqLDHleSVQgRT7AxAGjRotkdr2CL8cKWsQA==@kvack.org
X-Gm-Message-State: AOJu0YxuR0k2f1W3GUOFn3CkMZtZwcK6uFIl6Urh2/kfYzJmi6+ZFyha
	cNgqnAtt/E8QcPz/HxNgIeDZILm8sIUWRpc2dZ51NlSWNbfNuYnjbsIWIaeRPKDJzkH7sPdwgT0
	iXD3g2pScOiJUGUx3068Uir+xXXvttzA=
X-Gm-Gg: ASbGnctd4aZTezO3jpOv0qu7MEgpseCRUxkN5furWm/01TcMbNrgFBprOBtjjpSNMOK
	nxdzlNNl8XTmmp4SLhJfYlxKGM27cp7y116Qm2D5hJ0v5aNTVkroCbtctLSInyeMbwO8M/DwUdq
	DPt7S7ca2XKXS0g9HkLzlhdprGEiMKYSsYuGlhNJVmgS2srnmuzXMXI4p3kICmSnqJV4iTs7AFh
	2cIEf1tbALCUp8s1qiQ1vayhVi27FHUGNNTWywdLUfCQZbFHcSS9W1c0A==
X-Google-Smtp-Source: AGHT+IGCZsREvR1VZ+XsR7ha+tSOnACMJcqyHTG9GdyppjH3mGDryHaDWAaGL7FjSTusjsI3mMut2nsh+qgHgEwvsTk=
X-Received: by 2002:a05:6000:2209:b0:3e7:428f:d33 with SMTP id
 ffacd0b85a97d-3e7659f371bmr4280887f8f.16.1757712277929; Fri, 12 Sep 2025
 14:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com> <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
In-Reply-To: <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 12 Sep 2025 14:24:26 -0700
X-Gm-Features: AS18NWBQoKfEqcXxDiBi2y0eZcdZwwfvRq5T3SFVD5TOSJQlB_ujy9rk-5-4j_w
Message-ID: <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C3EE1C000C
X-Stat-Signature: m8j76qydsgnjkeqoefehm5pqxtcryw6m
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757712279-507249
X-HE-Meta: U2FsdGVkX19eScnERaCSADK12RB6tSEWKGz6aLtgJ7JVyaUlgYnsoVj8tcqHMP8Jku5WGElsJ/4lw7SRHOJqznFm+IW4dugxWzG1MJWwwS7IFcW3QddcaZLCxGvMe7a//iklCaqeFW2y1XGE3A/Hqj9bBTTbfA0s6w/aw5AnLxrGSUa7QjGQg1eQGVk3SL9vHZJmZsPxocUHuWZT37cljGV9IKseqlVHVQGoOYeyyJ6qJXahdWPvGaDoww8WsueF5E3o3Ka4/cUTZw/nS82Z8jLwaDaCAiUJE5GYSkhPZOFA4OzT135ZzX28m6s4hLNRYTSEFVoKXIJZYBhRLoZFO7zfqaTiBY6xeAaJ8n8ylngIndxyYUoim7ZXDDjBmtE3e8rIOz5XbMuaZhcw4ZEiC9U5tZ/vLtgckNqgPkwZa85j1eGXib1k3DjSfp4Rhb+inKnWSmeMwbXj7l0Re4OpC7aoV6iE0+ohXGnLLtEhGZ2GyskwTwTsgn+O3YYay7LQQCWELgBMciHmMY0W83H+fBmi11Wcg+rph5P0wq5wRCmFVjRHiT1wn2bJLfr/aNjKEtrpU4et+gr9AgVaE28qHyXBYOgiUzwxiemEkbyhWsNqYeY0E3KjeO3AOoInvyGBsDeRxlSrn+2BTR81+/hiUN6i7ykCZWA0RwckvofX38AQdEYvFUMTgRbBlHfqJ1kmR5Xy4j9WD6/tPAHJdu7Eif9WqUuwG6PlrvYr2FUHESQXM7aHBllycDek/oztL9Fu5D1zU/th9QqMo4fJJdby/IKpHAi7P4KlThH7g4VN9GtX9aTbyNhfrP08W1IIaxeb30LYgCuJ8tmZNhRxL4aEbJ0Wf6a8lVBOl6O5EKLHideXMYmtJi86QFfvSRb4t4mahGb7Mp1fLY1heDmBrGX4od/30Whd1xR4UvN2792gYbYP7Cgq8J644ueTs+nmmziUtwD75AeOWWFCJJ8RKKv
 ajGIjuDk
 6yTZVbnmP2DtUc+YZTkb+EcqxJL66bamWWXG2ii65/cRseQ8nnLZKcpKFpZT6i4z8hHgFXovMJNy3ZJ1eBdf950Hd+85zzNkuls8j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 2:03=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Fri, Sep 12, 2025 at 12:27=E2=80=AFPM Shakeel Butt <shakeel.butt@linux=
.dev> wrote:
> >
> > +Suren, Roman
> >
> > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Since the combination of valid upper bits in slab->obj_exts with
> > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > use OBJEXTS_ALLOC_FAIL =3D=3D (1ull << 0) as a magic sentinel
> > > instead of (1ull << 2) to free up bit 2.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >
> > Are we low on bits that we need to do this or is this good to have
> > optimization but not required?
>
> That's a good question. After this change MEMCG_DATA_OBJEXTS and
> OBJEXTS_ALLOC_FAIL will have the same value and they are used with the
> same field (page->memcg_data and slab->obj_exts are aliases). Even if
> page_memcg_data_flags can never be used for slab pages I think
> overlapping these bits is not a good idea and creates additional
> risks. Unless there is a good reason to do this I would advise against
> it.

Completely disagree. You both missed the long discussion
during v4. The other alternative was to increase alignment
and waste memory. Saving the bit is obviously cleaner.
The next patch is using the saved bit.

