Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AB7C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 16:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4174A6B0088; Sun, 27 Sep 2026 12:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C87A6B008A; Sun, 27 Sep 2026 12:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF126B008C; Sun, 27 Sep 2026 12:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 042966B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:17:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C281120AA2
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:17:45 +0000 (UTC)
X-FDA: 85260048090.04.91F51FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 76BCE1C0005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:17:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UvPDAZEo;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790525863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USGq2m7h9orgFPTHEzwcgOdn0+wSQ8cWbMPpoviJBlY=;
	b=IfysXNMeQkfHx/FGO6fS5MPGrYK1fSPkTmCNnr/X1yHm6EfMY6+DDpwWO4+nwuhjkj5FKm
	TNUsHSIT59uJ0RQ48Jc9Wl75kiA6ISg/kw9rik6RHGO7xuqwYuz/qK6un3G8Mws6o/ZU95
	K0Im1EE7c747iSJckVG77DPOPsJHahM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UvPDAZEo;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790525863;
	b=advZ2Wa23y5ppJaC/SzQFEFwOki0yJNRWl00Ae06Fjw/KFjGS0p/DiEcr7Vel4MRPK8Uqg
	GQpLDa4MA13uPYZJ5VRwVVOJmy8GMj9ibgwNQq3Hd1PCT1moHM1U1iYy/R+5BPmGmAXrur
	hNJ3LKd3KWWmrbVtIamlEPiDxA0ObuM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA783447C5
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C5A1F000FF
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790525861;
	bh=USGq2m7h9orgFPTHEzwcgOdn0+wSQ8cWbMPpoviJBlY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UvPDAZEo+jJqgN/yM/qEDGlVYXPPjZLIPQnwO1lKRvIbZgRtZ9FCiR2IKAVIqyNsm
	 FwtXSli/KPvZ1d+oKOygmiDM4TmxJWnXdiFTmw9ZeARoL2T+9DUXxAy96urFWe+QKb
	 AXC/au8TplEJXJv4wuwI6MTOEYH+2NYGoY9Grq32H3AJx65N+zXapd35Xa1m8v6mYM
	 KZEhhw2/gx2LLkQLGJ4ADmBWu28tTOy5x5cF1YNT+Fzk0dhggO3qJ09I56Njei8/q0
	 8aXEj1Tl06iZWWf72vl0AMjYJ8Atb4SrbW3wK8jNIpOCDIn8zhMf9KRvpzKY9U59pV
	 gYRxVbOo49bCg==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c996fd607so72330066b.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 09:17:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBztcCw6XyaC+sk8RY/F+IKO5ClXrFfX3DusiAXGFUQY5IOt/iNmf+h2YQ6Z+9Oa5uNtN+NUD26E5Q==@kvack.org
X-Gm-Message-State: AFuF++mGTSXbMYqmUlagQtYF7GdpcNK9JrPwsQXDF6A7DiGXvfiY/QQv
	Tgo0drlSSkURD89T5BkFERViVJr39r0/M5zBESwvzSpiQ5beLFjjQdtjiYxO7NrnKdZ4QZYz+LT
	JhBJi28eg1mL/iq3fNQQSS1QQ3ikBihbH2D0e/xFDSg==
X-Received: by 2002:a17:907:c310:b0:c25:f7db:4bef with SMTP id
 a640c23a62f3a-c2ac2389fa5mr1002872266b.21.1790525860493; Sun, 27 Sep 2026
 09:17:40 -0700 (PDT)
MIME-Version: 1.0
References: <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4> <araWKyJ5MENBwXCL@cmpxchg.org>
 <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com>
 <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
 <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com> <b792823cce613ce756227a3b60cc245b0316a800.camel@surriel.com>
In-Reply-To: <b792823cce613ce756227a3b60cc245b0316a800.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 06:17:29 -1000
X-Gmail-Original-Message-ID: <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com>
X-Gm-Features: AclHuK8lyU5HNKfMH-oiZ7t5RDtX6FakbfaPtRr5UYjAiWQbHf-Cp-W6HCn32gg
Message-ID: <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 76BCE1C0005
X-Stat-Signature: tbrqzf55wxj8qp91muf8y9w9s535kjow
X-HE-Tag: 1790525863-740945
X-HE-Meta: U2FsdGVkX19nWZs4oXMPHXcEshtUCYDNc/7Lfp8anfCgCoeZVSPSvABxXa4d/IwzwAz8GUAeDNvwjTRsLc5YGvlIRW84/mY0+r+U0dJA3CEa/EOi0unco5XRIoNJ8VmUIDuLezao6B91IpRbaliFBAcsUdgUwR/lXlQ4zqUu0BUahM35ArvQIxoH0NuDfQ/onRcJCkC6zzktyvEKztFqFJWteHkWeLZH9fMXAGXFQq8t2WylcHUMHQE8YtqZbh+/em1cp2PFvDGJuTETjhMTWoEj83aszSa24TLNibokukWvttKzZJhIsdc44mXHNBcS4zxN/64qVhg0Xhhys2Rm5ZEhbh8QQUp6+LTaMZJaKoZYRomsc6BAzn5ujZa6oh0ZVCwk/XkM3g7YG/Rz3ic/Iuhd9e9A8X5PHaazAtc7fagZc6j/eDmCNuPPU3JiDohlVcA8Hm0CdeAdJnXeeLONI8y/9UG/IRZ43bF00+V6mGSaTKOrvg9O8tu5MZwu/j3rfNH05b9fmuS5IYMNnvd4LumKJKrwcPjISey3hAP68PzxH8tCXL8EFwK8MMcL3qvzXPR9nts6jtOuAeJpgd7H9tslUG2WqRnUVvD8P1I+JH02CckcyoF/NtMZcC4YQzlRxIYyjpKLOCGKlw2aFtRqbBgsPPytRv6OMTJXacDURgf39PNH/Zh452GJqzxH0LF82NG5udfCJYR8MEv1R8XrXtFTt7JPDvVOEsjR121HRgtf0z0HIZ6zt5mEbPmYkltGtMFp5aXtgYVd6ReIWw8ndMbYh3UXSIWd1YBXQSfURCDx8YXF2t2wsqjIjPyTuRsEp1h409V9zb8vj7yz75QTXEN6VRg5DaaoIYLVG6Gxm9cgaMV1Dt50fWLSzgbOmzfKWdF3rEepQzEqv7V57xZl57RQfSi9dRNAg/UcbQw8xwVUYE7osTO1+2ca51mTivN8EjxYXjDw/EhU4/m42Cs
 IwkHu1zd
 bITi1gUTwYHw0GI4K+G1emoa1dFWUGUrjx2ffwrcVLVO9Mf5I1af1zj7yGxSdfYocjkxrYe8WD79V8eqXarqykIMeeNE+oopfQvzjgQHFONX+GfhDhKZc24qP5sD89/6cLBBjVcVkD0MndQRjnLNDbgwxEUbJq67NWcYVYR0TJiboTX9mV5jKiENx78EcFsox5X232bTPWAVroFvZUDk6+hd/Ct3fqpNWslqOvD67Ya1QCSK+xBkT++gwcXTIu+Rpu70Sk8xYcy50zJVoGUaZUwcZDaghvAktaPh4DHc0g4lQTYxwowbdSxuYx8ntCau/+OoVLuQIaOEromo6uhxXib6EbXesmnk0vvpENc7U0dJAEJ8aibw9XiEFdN/q0wImVkfQEj5SSt9sYbE900K3jZMJPorZKaaQ/ptXPSo1neesZzdTysU7DurK0+pEIruLHRGyQxXuUMdp7TDXiL0PE/w8jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 2:29=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sat, 2026-09-26 at 20:23 -1000, Chris Li wrote:
> > On Sat, Sep 26, 2026 at 2:59=E2=80=AFPM Rik van Riel <riel@surriel.com>
> > wrote:
> >
> >
> > > The fair resource use from memory.swap.max
> > > is to control how much of the fixed swap file
> > > (or swap partition) space each cgroup gets.
> >
> > That is the part I am not sure I understand correctly. Fair in what
> > sense? Using the swap file proportional to the memory limit of the
> > cgroup? Do you have an example of perfectly fair swap file usage for
> > a
> > cgroup with an 8G memory limit versus one with a 1G limit?
> >
> > Sorry I am a bit slow grasping what exactly the fair behavior is.
>
> Say we have a 64GB swap file, and several
> cgroups on the system, applications A & B,
> and system.slice.
>
> We might give system.slice a 10GB memory.swap.max,
> and each application a 25GB memory.swap.max.
>
> This way a memory leak in application B
> does not result in application A being
> unable to run.

Thanks for the explanation. To me, this is just standard
memory.swap.max limit behavior. I was thinking there was some new
concept of the fairness I haven't grasp..Thanks for the  clarification
anyway.

>
> The thing that leaks (if anything) ends up
> getting killed, not the innocent bystander.

I fully agree that is the behavior some of users want, it is what I
would want as well.

Chris

