Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0316DCCD184
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 08:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4EC8E000F; Tue,  7 Oct 2025 04:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E4A8E0005; Tue,  7 Oct 2025 04:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D238E000F; Tue,  7 Oct 2025 04:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5028E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:47:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC07987E64
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:47:47 +0000 (UTC)
X-FDA: 83970690174.22.801C1A2
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0A22040007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:47:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j+cGth1I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759826866; a=rsa-sha256;
	cv=none;
	b=EQpkWICD/666O3dSM5meEZMZa9BK6l+aSyDHupFXCQH+Oj9VJepakohtrLVYjmfDr/IW6I
	UKN4AcHdjZ23mJEaqRj0ufvao+Q8tD5nz+V7W2ZUP4nDeA/Q9Q6TumQlM1yM5aKf/7jH86
	ObCWH1F/eaIWyFGLYV0AJQrOz2OYWn8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j+cGth1I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759826866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crh9HauYP95GJ4zrJ0uVPldJHjW/rsd9tWC0UjT3/hA=;
	b=7px4ZT6DQFrDYVlyMbzOi3E3NfuJPkC9O0CvqPn7rQcfcFXUZst03E3MywGmizPxaeV9u6
	CEZkvC65MbcvMv70T8xg9Y8V8c715lhnwF+qno0fjOoHb2a3JtSw5HUgMguL+sH2XVJZpP
	mWP7MQXhikOlK5Vh3TRFsyEWaB5uSpE=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-86be8a110f5so63323936d6.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 01:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759826865; x=1760431665; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crh9HauYP95GJ4zrJ0uVPldJHjW/rsd9tWC0UjT3/hA=;
        b=j+cGth1Ivqm+q0jqq2D5SDdzouPKJXxg9jed1/h4QVMzr89DfKKDgtqsM0kcXlbzP4
         AhzaSdqqrNk40i2P0g262oWBsM2BNHp63zigYfYzizvWU22QlXHq/M+vMLQR5ue3THwV
         qgvyNcZwpwV1ksnkA0EQoVkgevfg91HlJQQ/xdVKgjm9e2dKCNqkcEfT1exxSHUbwCUZ
         5VvlzqEaCtKJq+80IhD2q1SM7Lyn/r+fruTHmYxn47bQNW46I2KTn8FKGQtDANsQeN7X
         BHNdE42qt6JTvd4kGbtXPsEwJmupYZazHUzBKLlfrFgi+hwZWQFRjbsP70FfD3g2GTwB
         G1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759826865; x=1760431665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crh9HauYP95GJ4zrJ0uVPldJHjW/rsd9tWC0UjT3/hA=;
        b=tEXyKJqxb5QYPThWjVb8JfEn5eE4pD3mlE8J/i7BTJu8ziBkCLFj1Sl1jRrawGdwOu
         W3/A3oBW0TNuNBUZ3/WcpkSvArthH2wCmYGz5hHTDL8gOcS6n47+lI84nbX86vBZs7/G
         tB9nup+dKTxj7e2z2Ozl6M4BtprpauwP3SpcgqydghqEoi6yVhTAI0oGSWH+5enrb+MY
         /g7JCBwo7kfyEB/n9PrKIaHwrj+Uwjiv3IQNxtXNx4cEV+eOuyCC2QfHbwg/DlBUuyR5
         0y5XvwDXjKmxfTwk8j9wZ9RUVMKUPDAIfLpRzA6TI3qY0BaaoJls3PPUEOJ9O3A0GEN0
         6ZWg==
X-Forwarded-Encrypted: i=1; AJvYcCV1qBAM1Z/+P2r+o+Vgz7lUmay/NV02/z2+Y1B1+ckYO2+FQj1nd+czd1nuAGdHv7iYo9i1rr3n4A==@kvack.org
X-Gm-Message-State: AOJu0YzqMriHAjeGVi6/nHHPCDcarxVT6gnAntm7VuFUsUc8bQD97EMp
	V6YTsSXqzHIR0+k7dfJNZ8i+kdmGfVUUdOCXqKNMarMi9H3qYUnu10JRyuCfFIsY0ukkAniR892
	JytRcpR+7l/QjH+u8izo8g7EbpP7vN6k=
X-Gm-Gg: ASbGncvV12vWp73/BJNnfNMb2n2AMsVEFTGil9yc4Yw/iwZ2ANCSYY6+SCjfvLCiKKq
	oeMOUvgfaltPzwW7YMB/FligPp66q5s/Z0G6ViwEE4zHsspkDykY+V+RGujR+GWSKNiN0lo0Vdp
	Yw0AgvFON96G+SbcoQBMnGmE+j8DaAbES/FIvUu8DE37iTlQcvpp3W89r4RoPSmhdDvAMkzoM34
	burlxqm+y/MTnzeG/R7R4qQhzHNBuzmdU4cgEfSWnFJqtOZZXQxrCpzzZ6esphlJuK2Oz7f
X-Google-Smtp-Source: AGHT+IE0kCx/uqxAfqV2bOwZSICMDBVUoFj0t71GiPD3ZOtz/k069SnnR01KVwEtbQaFoOkSu9qAE8VcxY6KD+XN6HQ=
X-Received: by 2002:ad4:5ca5:0:b0:815:2c80:5538 with SMTP id
 6a1803df08f44-879dc82c417mr175681336d6.35.1759826864937; Tue, 07 Oct 2025
 01:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
In-Reply-To: <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 7 Oct 2025 16:47:07 +0800
X-Gm-Features: AS18NWAAW7GO0Nbda-yTtjdo7G3EzwEKMHmRebu2XNJhJXwwvRx2obOSyUBetgo
Message-ID: <CALOAHbATDURsi265PGQ7022vC9QsKUxxyiDUL9wLKGgVpaxJUw@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6n71ohpcgjcryq1sc3em8u94n6gwgg19
X-Rspamd-Queue-Id: 0A22040007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759826865-618900
X-HE-Meta: U2FsdGVkX1/A4PfeB1e3ZsVFZxOrI5yHFugjYl223fLQIIz+H2QLX+cu9ipnCo2P4fkc6wPGyKipijzOb8QPLo7AHPRSlESW4uz3l1DAO2gHwISnwxAp1I0gRjWLTWZdL6nk0B1nS/5sie4ZNJUvur2QsENCzi3qrn6YZljxbQ0c7nHQ3Ai1Pte6GYZF7+I0HEaNiXuGMVAv/iv4BxigCeZzezuox7T3d/Yb53s87QE6HyLWEELV3w1K7zFOsdtBnIpexwxFo0zuUNPGw00G0jXNORVHk27PHZ6oCPS9YSZ3umniNQvcbp6+GUNe1H1f5vdae2ark69P61P0agZJDuilxFHzrDG+UzzHoaz5plTUeaBn9VmXQ4Aok3dBgEebPh16mqmMSwSx9TPpJFyMh0cSYpG9tEbbv0yk0eodlx+Ea5jowhNpNyTuto79ziUQcSau5ZVela0Y3Crw02lZCJJcwVTfv6MJr+H34c8jhcDzwBg0O9x5A4jFX5Zti6lPGIaBavbT0TVu91y6U4/VSN7zZH9vz0EXBngp/bVEmeqMYgzbXLow6WVD5PcEMSSe/edyz7HSBEJTmgV+Mr2rONiv8xF/vxt5hAukPe+wMShye/BuiMpJQXHYcw7X4ytU22NF+CO8jkCE4MlrrXf5D/Zz1pFIekKueJc44LkoQVdg7s8HBguVgWj6A6ip8fEuweNPeMadKQ/9KlU6ouaXiW1qus1ydPlvoXaPejV0chbRdFimmA6/QR1VLtVUiHc23K9rGgES1GztT5OP16P7rXwZdppph87HXX4iBfIj0t2IrfiKQEMkpdRTjqIECgh9nUWhyhodq4Kn4pmtENpKQ84/Il8h5lFTBJURzlkCMK3wK+Mfe0TdjY97UkJ3Oct8pWlPkuXDxKj1WRnf89YfelxRPVjnYkJzCZjXpJkt2CpU3Eg3PURUf87FTwW7+YBujBN7BmEeR8ivZLQpgHS
 S4xPulMX
 /E6QJEFNXswq41Bh2qUh3B6TlswPcOi9obAMI0/Pb70VYPvAXlljORcM3u3KjorkeD9IFMbpKIOAPNPDiJIDqySUaTto/Hz2zQSquIux/slYuWdNWiTwytMc74g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 10:18=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Sep 29, 2025 at 10:59=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> >
> > +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> > +                                     enum tva_type type,
> > +                                     unsigned long orders)
> > +{
> > +       thp_order_fn_t *bpf_hook_thp_get_order;
> > +       int bpf_order;
> > +
> > +       /* No BPF program is attached */
> > +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> > +                     &transparent_hugepage_flags))
> > +               return orders;
> > +
> > +       rcu_read_lock();
> > +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get_orde=
r);
> > +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
> > +               goto out;
> > +
> > +       bpf_order =3D bpf_hook_thp_get_order(vma, type, orders);
> > +       orders &=3D BIT(bpf_order);
> > +
> > +out:
> > +       rcu_read_unlock();
> > +       return orders;
> > +}
>

Hello Alexei,

My apologies for the slow reply. I'm on a family vacation and am
checking email intermittently.

> I thought I explained it earlier.

I recall your earlier suggestion for a cgroup-based approach for
BPF-THP. However, as I mentioned, I believe cgroups might not be the
best fit[0]. My understanding was that we had agreed to move away from
that model. Could we realign on this?

[0].  https://lwn.net/ml/all/CALOAHbBvwT+6f_4gBHzPc9n_SukhAs_sa5yX=3DAjHYsW=
ic1MRuw@mail.gmail.com/

> Nack to a single global prog approach.

The design of BPF-THP as a global program is a direct consequence of
its purpose: to extend the existing global
/sys/kernel/mm/transparent_hugepage/ interface. This architectural
consistency simplifies both understanding and maintenance.

Crucially, this global nature does not limit policy control. The
program is designed with the flexibility to enforce policies at
multiple levels=E2=80=94globally, per-cgroup, or per-task=E2=80=94enabling =
all of our
target use cases through a unified mechanism.

>
> The logic must accommodate multiple programs per-container
> or any other way from the beginning.
> If cgroup based scoping doesn't fit use per process tree scoping.

During the initial design of BPF-THP, I evaluated whether a global
program or a per-process program would be more suitable. While a
per-process design would require embedding a struct_ops into
task_struct, this seemed like over-engineering to me. We can
efficiently implement both cgroup-tree-scoped and process-tree-scoped
THP policies using existing BPF helpers, such as:

  SCOPING                        BPF kfuncs
  cgroup tree   ->  bpf_task_under_cgroup()
  process tree -> bpf_task_is_ ancestors()

With these kfuncs, there is no need to attach individual BPF-THP
programs to every process or cgroup tree. I have not identified a
valid use case that necessitates embedding a struct_ops in task_struct
which can't be achieved more simply with these kfuncs. If such use
cases exist, please detail them. Consequently, I proceeded with a
global struct_ops implementation.

The desire to attach multiple BPF-THP programs simultaneously does not
appear to be a valid use case. Furthermore, our production experience
has shown that multiple attachments often introduce conflicts. This is
precisely why system administrators prefer to manage BPF programs with
a single manager=E2=80=94to avoid undefined behaviors from competing progra=
ms.

Focusing specifically on BPF-THP, the semantics of the program make
multiple attachments unsuitable. A BPF-THP program's outcome is its
return value (a suggested THP order), not the side effects of its
execution. In other words, it is functionally a variant of fmod_ret.

If we allow multiple attachments and they return different values, how
do we resolve the conflict?

If one program returns order-9 and another returns order-1, which
value should be chosen? Neither 1, 9, nor a combination (1 & 9) is
appropriate. The only logical solution is to reject subsequent
attachments and explicitly notify the user of the conflict. Our goal
should be to prevent conflicts from the outset, rather than forcing
developers to create another userspace manager to handle them.

A single global program is a natural and logical extension of the
existing global /sys/kernel/mm/transparent_hugepage/ interface. It is
a good fit for BPF-THP and avoids unnecessary complexity.

Please provide a detailed clarification if I have misunderstood your positi=
on.

--=20
Regards
Yafang

