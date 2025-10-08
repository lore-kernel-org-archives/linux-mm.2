Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403BACAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 04:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8471D8E0003; Wed,  8 Oct 2025 00:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7A98E0002; Wed,  8 Oct 2025 00:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6498E0003; Wed,  8 Oct 2025 00:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 589A28E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:39:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3708585C2
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:39:23 +0000 (UTC)
X-FDA: 83973693006.15.41C67B0
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 375D4100002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:39:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GBRuGNM1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759898362; a=rsa-sha256;
	cv=none;
	b=MP88QjwqHKezCBbh51ezoI8Ia49bfQCXMWHoedBF5lpCour8KAmfw8R84GLuicOSR+Z9Uw
	SKxuxtuLGNMfLcW4HiVxXFsD2rbcGbdk0K8fTVuWTpoImPNleqtWt61zQ7XA4UIG+NhsaJ
	eeDGgDaLgHB9atq0eKeON/3I5lYlTYM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GBRuGNM1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759898362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rm3GhlyZsgjNHwG8nD1ukkMMPB/ILNmwuDjzy2VbVTE=;
	b=qWFy3SVt417lqM6U+vJ3UomueReb9bNMFQGXXi3OwExHgoynDdsDxYNBnixA6kIc0S91v1
	vfHV/7PaMe+LncBkFpOUe1UscQf+7K/OLO4wNHQAIWzhM87ML6c1TVA6UNX/vBCtI4HIEm
	3l5ImjqN3mLlVX4DLUMbhOGVhIU/3HE=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee130237a8so4988561f8f.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 21:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759898360; x=1760503160; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rm3GhlyZsgjNHwG8nD1ukkMMPB/ILNmwuDjzy2VbVTE=;
        b=GBRuGNM137oRYCvBY67dGN/pGRFGUK+8WomY5kKu7iWgGMHyuug8Z3JDImUV6JqNiO
         IZ1pnTLOsLvkKW2XEQ5GGWi9awEB++yvKp/WXjAXE8eBg5ZkvdsH6/zQyU+XZhuoU3av
         ePdHOBuJbBqYzJw/q9WEqoVB/c/U0xBDiFweYUNsJ18U3qme38L1qontP9vaeumYIhE+
         vWKYsGeO5LpG1u2LRTcBj90sPUIjpHeWQuFR1Frx7/PWK35x53BQ78YTI6SWdfKYEq3k
         CbuwivJpuUH0T9PBeiaLemK8yCHi474A4+rXsnk+EKXDA66P0iC72ahJJTc2gTd6mcr6
         jB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759898360; x=1760503160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rm3GhlyZsgjNHwG8nD1ukkMMPB/ILNmwuDjzy2VbVTE=;
        b=cw6VqUjcu3OIIQ3LdA2191+MPnScYGEfDs0oMJTui3FfMOCZjINXK6zSNdDnEvkKEo
         pUL4nukhNK+JdtC6nHxPOXWLo+ExttZVE9xJg4/HgXe/rqso4M6N9hLJ41QU9cuSSPks
         AZl0dckOJE+rb3ndNKfKJofoer/kZhSoP7VHZsWkdMj53BHaMOd3K/hrXxv5bPIrWYHN
         hPw+BE8EJocKSLzOOO7LWn52obgTKf5C5xcnHa5OwXBsJPUks9YfRnhgO4KmtAEtn/th
         y3rsVH54MqP1Xwoi3CUs3pfpD90xgRiiaUqq77XeEx6D6NEk7yW+JIwUiN/YLvJJEDPU
         BTWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzoXzr6o9YFlq0ClON1RmU3FYRQBC6iqIY9JqCFQTqrYSmSfMQU7p+Raki3NOSZz/44RcYP7/PTg==@kvack.org
X-Gm-Message-State: AOJu0YwjjcAzCmACPrrthYuhCwjeyxh6Q3QBTPUXurOu3FXb2vsGe0Ye
	q9MJ4VZAoKtGGJbyZMM4wYHReEVx15dVIvkF0irIpuOz/zcJEAF/k+92hXimzBgwY9cyO+WwgE7
	l6ZuFwJkE0+iVGkMil6yUMymz2klvs8o=
X-Gm-Gg: ASbGncti2nKYRCDYZz4Jtb/KmQNpVLm8VKvgN5cu0/PgtOL+RmqEvTiLqkJLJBLcDxd
	oIWh9hFhViB/wOR2dwOw2wLjxiv6S+GeOu+/0U9Zsd4DQtR1ZbuHCX0PdhnMAtjfNIyzzYuoPoQ
	Cl3sgpHwLd1RQ5X5T9HyE8v9ZsPbhB1ECLckCQg0KgO+iIzYf4wrOG4R+Uy9AoD/963Hv707AcB
	78Oqs9WQUyTEoZEiJV39q54SdMLXZC0n9/aUk0Vj0R0Zrko2pgFWf0wS9rFbv5Q
X-Google-Smtp-Source: AGHT+IHVEHG1C3LKLnJ8DwT6l1r997HA+wzMKAexilSB8QteathZvj8Spsg01noOe1OnIJsIlqfqCOjIexAD1RZW1Rs=
X-Received: by 2002:a05:6000:26ca:b0:400:1bbb:d279 with SMTP id
 ffacd0b85a97d-4266e7d44f1mr925348f8f.39.1759898360484; Tue, 07 Oct 2025
 21:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <CALOAHbATDURsi265PGQ7022vC9QsKUxxyiDUL9wLKGgVpaxJUw@mail.gmail.com>
 <CAADnVQ+S590wKn0rdaDAHk=txQenXn6KyfhSZ3ks6vJA3nKrNg@mail.gmail.com>
 <CALOAHbBcU1m=2siwZn10MWYyNt15Y=3HwSGi7+t-YPWf0n=VRg@mail.gmail.com>
 <CAADnVQKzW0wuN3NfgCSqQKVqAVRdKVEYMyJg+SpH0ENKH6fnMA@mail.gmail.com> <CALOAHbBzS2RunZzEk8-rkU60M8jKEJ8FwiPgZqNeoXDy++L5hA@mail.gmail.com>
In-Reply-To: <CALOAHbBzS2RunZzEk8-rkU60M8jKEJ8FwiPgZqNeoXDy++L5hA@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 7 Oct 2025 21:39:08 -0700
X-Gm-Features: AS18NWC8ZPttD2mQYRSD8-3WnTYDsNM_I1o2QCoCf1odJXXOlkBQmZekv5Q9hPQ
Message-ID: <CAADnVQKLbc4iZDGWbbhqwr8hKhAZhyLjiZuuz_RBd2f9LH45rQ@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 375D4100002
X-Stat-Signature: mwonucauorwsxhysxeeeb1hy1ujd4jdw
X-HE-Tag: 1759898362-512326
X-HE-Meta: U2FsdGVkX1+SsDm3Hycmc/1H0jUjJJXxdt+e4VTPFVUxb3Ei/B2TIHQcam6aDe5L6uWBoo7hd0n+H0F6J4s6TYNqDYx8b6WTf/HOU+tCOnEaflI6c6vcKNfN5PAfQkO8nJBDMijwy+ENhmlyZS22m5hzbrwY4PaBjvXaQKcMn/1//sYEtLySiKZeamlXGvL3xIC9nd5pM/VLFN+nPCcU4lmwHhHfEnBFm6IJF5+HLsHYjhf5cyDn8hr13RP/v6tsJOTyfrCiYcQvOj/Qwo3gK8SLtVHxpqcPsgSJRPSSeVYX678JABEHDVArbJf7mkPLXvQhzjdIiZOWsI3Z1D7hZHutab1npWieH+JyLNQwWzoaNs3KrjqNmmc2HOEA8I8lQ5/RaJ6cm2VdOvhYpvoCpA5kLYKQAMuN7n3JuyOTdoOck5f/B30ENjjEQMyNb2Fjdvduglf9Ewhi8/TKsdojokBPy7inr08U+Tp8+EeRlYO4J2jH9fMwEy4nkqC4YI6W2vBNa1m1F+WpJ6sUrIaqPbDRVfCFZNvK7ofcMLotqj2wuel2wXkueQzpftipiFLEdMAH8fIG/dGBhxLd9CJPrNUqstMHOYdYn+fYAnrPbYiaGBhEcdM7qsMGBrmD7S+DUvn6a4BCZc+OcTd/o1SUwUoKn8UYPBAclP2GKAJInTGOggrVPWucwp2dIU/BXBwrz0/4YVlFjkgJ1Gbc9xsCCyR2H58OIqntm1iMsDJHHGvQHIv/tMtE0ECbnLeo4ZEJJq211zrUvhYwnqXUgmP/wJkHgbrqG1h//6egOnlsymnhZglCHRWGUwmLcmmaNqesHhhmeaIQt0YYG+21ao6yMTmG6Xm9vvZreYQv043Ud4Td3HWL/O3W6bcH7+2dvpf1PCeA++GTRIXGD557OggyZ71hCHtFPtZayby46xKdUo5V91tIvhhOUgWoxOTL1tkl0Z+NGIET/lu463MFAOp
 uEZ+kgyA
 4Z6qni/qBm/aKc1Fu5mXoJuBqqgFI+oJkwICCKFQvrO2Zv9l5gLEvt0wTm8rn605rFuCKy28iq6pRC14551rM7kbqtGtAG8Q08B8ed5BkJkXxePb7Fg+IBlRtHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 9:25=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Wed, Oct 8, 2025 at 12:10=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Oct 7, 2025 at 8:51=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > >
> > > On Wed, Oct 8, 2025 at 11:25=E2=80=AFAM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Oct 7, 2025 at 1:47=E2=80=AFAM Yafang Shao <laoar.shao@gmai=
l.com> wrote:
> > > > > has shown that multiple attachments often introduce conflicts. Th=
is is
> > > > > precisely why system administrators prefer to manage BPF programs=
 with
> > > > > a single manager=E2=80=94to avoid undefined behaviors from compet=
ing programs.
> > > >
> > > > I don't believe this a single bit.
> > >
> > > You should spend some time seeing how users are actually applying BPF
> > > in practice. Some information for you :
> > >
> > > https://github.com/bpfman/bpfman
> > > https://github.com/DataDog/ebpf-manager
> > > https://github.com/ccfos/huatuo
> >
> > By seeing the above you learned the wrong lesson.
> > These orchestrators and many others were created because
> > we made mistakes in the kernel by not scoping the progs enough.
> > XDP is a prime example. It allows one program per netdev.
> > This was a massive mistake which we're still trying to fix.
>
> Since we don't use XDP in production, I can't comment on it. However,
> for our multi-attachable cgroup BPF programs, a key issue arises: if a
> program has permission to attach to one cgroup, it can attach to any
> cgroup. While scoping enables attachment to individual cgroups, it
> does not enforce isolation. This means we must still check for
> conflicts between programs, which begs the question: what is the
> functional purpose of this scoping mechanism?

cgroup mprog was added to remove the need for an orchestrator.

> My position is that the only valid scope for bpf-thp is at the level
> of specific THP modes like madvise and always. This patch correctly
> implements that precise design.

I'm done with this thread.

Nacked-by: Alexei Starovoitov <ast@kernel.org>

