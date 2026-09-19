Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DF8C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2356E6B00AA; Sat, 19 Sep 2026 03:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DA36B00AC; Sat, 19 Sep 2026 03:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125C06B00AD; Sat, 19 Sep 2026 03:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D32C26B00AA
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:24:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BDDA16016D
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:24:09 +0000 (UTC)
X-FDA: 85229673018.06.874547D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 493AC14000C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:24:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UL7fUD1R;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789802647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcwKFo/x3d7KIrwrdSc6FIvo/aUmSvp1opSXGURZ5hk=;
	b=Tj810p+z/hGkl/fLYGUuhjvbvn09T7JAl4I+hN2peuCy34TcWNydGkQfp64sRz+jnVlhnW
	qV3fFA9InjGOo5B0b1dEJ6g+0pdUrixqsnE0FI2DwiIw41yKrWuTWv5Zj/IZFCym9DSSBN
	OrdiCbuW/MiRwsTS98xCU9YjuXTaAqM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UL7fUD1R;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789802647;
	b=tsL2x+MsABTV8qvw66NwrENwuWrCQGksGq7kylGXnc6lAecFvllUhWjp1pYr/FFOCT/VyU
	J6FvRDI1aCzGXhsM/ATx5tpRYzptSStRzeexCQ6D0VlCdsg9XGlirGccUBKF0C+VigPP12
	vDe4qj1+YHMSS93p3jns1qQQYQnkXpw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58766447BA
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2241F00902
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789802646;
	bh=CcwKFo/x3d7KIrwrdSc6FIvo/aUmSvp1opSXGURZ5hk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UL7fUD1R+LFfRdNyW3BYbQT13vuIzvV9VwxPU0lGVypZMMtFBwv8hMGA3f6+g2jXc
	 FSMv7385C4wyeX31P82/p8Vlsqz0rbOTA/FwhmYef7KLB2CqBkic40zrVshI6+7iKb
	 /8PLo5AiSkgoXdsC+XuO5IC92XdJaQVs1ffGGXfl55qM53lVC47M9hlEsTtFwxmj4j
	 /No8o+O4Bb4IJ9QUh3IZsORNIlcw62NrjY0wS1Vz0LPicbigMk1SWE9LG9DB6tfDEH
	 KAd6OZYR2KzufTieJL2FIDnOKJxNuBN+7dIryv3mm8+96VrfroaeZ4II1SPsJ1TkAa
	 6E4CmL3ENNGrg==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab1ef11so1319525d50.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:24:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx5A4exqoci2x+u1cZY7reNlCNI7YuLZS8qZl1frf1qKvdJZstXkHm7S6tKn6eoY+D3LfbEi1w5sA==@kvack.org
X-Gm-Message-State: AFuF++lGicyKu68HNR6oinZpCxyu9QknvKHngy5DhgVGBlPOMtiGAy3V
	kSJJuy+YrC8zQ30x3hGhomZk+kaP4oK0rAM6ZFQPxHTj5rZyRzEPU37ICvp9yUZd4ejq5F88QoS
	PZIr9tRJ1koQEfXfpJSgisOtfCcvflCayFnYoaPZmDQ==
X-Received: by 2002:a05:690e:4504:10b0:66b:14e5:d226 with SMTP id
 956f58d0204a3-6717fcca387mr1086959d50.34.1789802645443; Sat, 19 Sep 2026
 00:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com> <aqU81l1oqGItb-0C@cmpxchg.org>
In-Reply-To: <aqU81l1oqGItb-0C@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 02:23:53 -0500
X-Gmail-Original-Message-ID: <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
X-Gm-Features: AcwNN1Ugv2uKjDvI3UlN6yWV2c11EGmbN_5p9iXtBCp6zavSXduB5hlfoQJWQ5A
Message-ID: <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 493AC14000C
X-Stat-Signature: fe8gijhhotamghjxqfmm69omggjiqo5f
X-Rspam-User: 
X-HE-Tag: 1789802647-464250
X-HE-Meta: U2FsdGVkX1+X1tuWUjchBsUdDzpTqMKtCxuw49/QrL3+cZM7ylHyzOjweXN5UPGl5G+RbargrAxZvn2VXdAiFHBnFZZMs6d4Gew/VlPXp9ff2Hh0UqzLvj8WENHxI0y+rA4EbiAskkJ4ef5L31ikOvEdrnyh7q10adPOdLKUjzxCEmTQIX3KwahDWIHrUq+HzJj/tH00F7NtfLE7N0rbjkbT7oy/rM9n5n0nRI4rEy/SnannmV7xyM+dcjclhU5gW//AV92YXt2fF8kvLBjzGwZmlNMezvuRMO9TaIUfZHsAaqzOzwL+TK0v7bQjT046NxcKjWJ+ZX9qYrgLmB+cQROvYSbRQOFEY+QMbjmyVbrllA1rKyx1NefdYuFkAl4uE5Y6HM6YDv4k+WEdFB+FsjyTkv7usxGKLG6XDJfq/ezNBM2WEABZst+fkgOJAz6hKF4JvO+A7h9jF/pz4+MiGpotUKgF4XTcllvqS/EIubzRh6CbpfOnHejFHFJn0Kc82jJu7ka6Bi6jNSRczz5YNPuUYJuOXUi0nncjxkHUWAOphA49mFFN4tzcF4868b1Z/X4yr61/VNKsoxTcohyPgRz+14KfnP26WFuhs+g7/xCCxTHPol1bXIlUyM+7EZexl8R91lk6WzXqe5ZPyTr9820R9f7tMavaQDMpno6IT2BuM2xJsL5pFR3sRQvD5oz+uQqsrqcGfsjnrvhluels+5CUzzOlknEQTVDlffry799mPAQinqNC4JfgUnWDLYHd0+nnI9JRhv95UZ6OjmsUtgIJGw8NjQWORp2lAa3cn6eJYkxZHA804MRRwq8PQd7BGJYA8FEBgXvrAgP+m3/JnT4KFgT4O/3GE0iI8RWJf8PpN5ZGlCFDdnG2ri2eiLae9BuWeUmWF3HhO1pYProyLJZkKUEDlpVL2J2JT84aXpyrwbFeiRDc82ziSp6hRMZ6AAaCduC45h/qekkC2mb
 hnFNiNQ2
 0gn0TyHE40i+W5eaINEEk/+oS7zVDTGgHn1IBx0oSbE8fCYPvcQVFfIOHN467qxJ+QoyyNPDVgSU76Vb9gQ6BHWLSBKVGpUccRI/9spjNBbF8aICNx13xYIMR7wvYEgVgf+rMchm5xG+Dl1KJuS6xg1V0+G6dOMGVR7RoEpr9JAYlLwrJCjPkU6e1l12qQZlvuAhM73P+RcRW2Rq7orksq1aXR3mPzbXnvLBkgb6oPEDe6AcHSGKQ1xCa6wWpHzsPzxvYW0Cx9nE3LhXp2K7ufPikCAF0qV08SDhjeiRHoD/32LkhPrlm5Jo2kyGgpBuDy7mMkDLT7VeYCSxPqsCkeGmrQbTK6V+uKZufUDSv9biMHxlY4HXsG9UH/oHfSoIbWmDYik5VkZxftZbnG2/+0wRFZzOMNOVs3FnqVJoS/1NRg2jk0caE6TAzGLU+XETpfEW2HxVCK9yyOiYiIADhSDcPeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 6:52=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> >
> > Is the limit, the heuristic exists only to make "a seriously wild
> > allocation fail" (as documented). But on a vswap-only machine,
> > reasonable allocations fail. Common swap devices, zram, or xswap don't
> > have this problem. One could argue that the size there is just an
> > optimistic guess, the compression ratio is not controllable. But that
> > heuristic is a guess by design, and a plausible number serves it fine.
> > "Unlimited" seems break that.
>
> That cuts both ways, though. If the configured compression space is
> large and compression ratio is poor, it lets through allocations that
> can be considered "seriously wild" for this machine.
>
> It's a filter. I wouldn't say that letting things through is evidence
> that it's working.
>
> Since compression space is backed by memory, it still makes sense to
> me to reference this heuristic to RAM. Cut it off at 2xRAM or 3xRAM
> tops if compression space is available.

What is this "compression space"? Isn't it just a swap entry allocated
by vswap or xswap?

For our deployment, we only compress about 7-10% of the system memory
before performance starts to suffer. The feedback loop will scale it
back. I am very curious do you have actual work load to swap out 100%
of the RAM. I find that very hard to imagine on servers with huge
amounts of memory. I would love to learn more about your swap fault
latency history in those cases.

8PB discussed in other threads seems way too excessive.

> That all being said, I've laid out implications and concerns around
> limiting compression space in this thread, too. Collecting pros and
> cons is fine, but if you bring up cons for the unlimited case, it's
> fair to ask that you engage with cons brought up on the limited case,
> too, so that we can weigh the tradeoffs.

I think having a kernel config with a default that works for most
cases is good enough; maybe add a commandline to override it.. e.g.
200% RAM. If you worry about overflow, you can set yours to MAX which
is ridiculously big. I don't understand why you force others aren't
allowed to set a reasonable default. I do want to have a reasonable
default config. It should be configurable.

Chris

