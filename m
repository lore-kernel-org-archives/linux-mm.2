Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0972C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 00:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558A16B00D7; Sun, 20 Sep 2026 20:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5099E6B00D9; Sun, 20 Sep 2026 20:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447016B00DB; Sun, 20 Sep 2026 20:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2C76B00D7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:13:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7BA6B1C2BA8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:13:35 +0000 (UTC)
X-FDA: 85235845590.12.840A9B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79F53C0007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:13:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bdVIkqhM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789949613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLIBdJTyhNKEU8IfU998eafr8kKCVMQcTkJyIlWnSvY=;
	b=ViqMVi62dnESIpOAD4B5zd/N5ZHxvf2DswG1aWMLgGQCgJxlxPjnK211CktorLj0TwOC73
	qKNcau0FgZH0R7p80NwXMFAmk1tIxX95MgMKCDcZ07/92Rjzpzr0eFMJZwANX9Klqo8wRH
	HbQO5TXMtDCsl9lZthvYwVRHjqfLYWI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789949613;
	b=W+WEmZGPDsqPHMfAgsc9hWD2dps0vZq62oDvW+7+tkSzotkJGsdjiA4+zfC+0iA4rONR2g
	KJL/IZS4NFkcVBzlN+Ou1Sgc7ZRJJ/rNwha1t3+Bpb/ep3QG2ifzxeOekD0d4pVjVh4xyN
	vwOzJDF9OhKCn5CRt0L9pq1MteXgAXA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bdVIkqhM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D4D9449E0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849181F008A0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789949612;
	bh=HLIBdJTyhNKEU8IfU998eafr8kKCVMQcTkJyIlWnSvY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bdVIkqhMFVkB7TVrZddIKlNhMId7CVLPNFOIYhTBvMfZlq/+ND7W699t8IzRKRpgy
	 Ycn5OZdY4+dgSygoENccSUhU327aIO3bl4msczwgTQNWIz/t2VoI+FRR+ZjqspGr2I
	 aqguGuBXvR0MA8+3C9cFp1UWTpqxWWYVjEdFQ4Z+huLiaX5wFo1njy1A4BQ1IgdOPH
	 bOdU0oA+12EaDez8p+g8+VcuyepChvAoZRLc+uexGe0BYlD+wbIecJ1SzaWgfQYkLJ
	 sM16SDKdXJxCdXHHi0whETmv75bqS3r7Oyz3yUCEXyjs+ZvvGLHeLZ9SKOU6SYTZnD
	 94E/Xy7BxNenA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-670fee39d73so2284673d50.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:13:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxMfp0wv5ecCQDezsBO1+Nk0g6AfR73yWeKkNDf8jCpoTRt2h3DujYufoTAdefpvqhzEx+ovbyf1Q==@kvack.org
X-Gm-Message-State: AFuF++nRbDdVklF0S2zCtEu1iO28nCZqM3TFSaMyHTl6qA66kjJjBzmq
	/Xe94Oow7xO80ZoLO2jWPxfL5XLeNJ0LolqK8iHhxhPxguwEgN4uz2LNGzRw+b50s7NyExrBGQT
	rjOXcEqhfzZN777gGLRn/rpCMBTlj9CygX0Qu8GmWdw==
X-Received: by 2002:a05:690e:4183:b0:671:27a:df14 with SMTP id
 956f58d0204a3-6717fc74349mr2563663d50.20.1789949611648; Sun, 20 Sep 2026
 17:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com> <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
In-Reply-To: <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 14:13:19 -1000
X-Gmail-Original-Message-ID: <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
X-Gm-Features: AcwNN1V4--hMjboOC0TrbzcbPbb8njndB64L4hTOvsdZJ08v_ItIqBCQ_Dg6snk
Message-ID: <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
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
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 79F53C0007
X-Stat-Signature: imn8trxoobm8zehckwmit84adgfnesw6
X-HE-Tag: 1789949613-281040
X-HE-Meta: U2FsdGVkX1+fS41c9Q2gtV7Wv+/dJ6NmVCxRCSNbkotfGFSnXb+pzfrf53Z209v4oUSpoQhQkbETaD/2zVqxn5hXsN6+tlx61tEseyDf+BJ1Fvz3b3ZKaf040v0h3kZ2v39fMhpBA0lk4/P8WMuLdHlDxCZHMCGTbkYBDiCJ3nokb8QE4argCF1PgCPLC6RH6UEq+CmxzRMRQQZwT+9nVmQYYfFUjrGoGLcyO7Z6gYVqe8bcTNuzlQV8OaLt5pb7oDZz0BYMMi30KyCK1r9ortpPMisVLI7B5ad8rmqaleV6rimY/kOtKDntycqNmPiCmNRIm/G+URHzYOxp08qv/LczweK2V6BWA/JGaUnvCmh70jZpHJtqAd2KuEYZce20Ns2HY4hVgL/4XASH84SHGfsqjPQYQvBv2i6dAuBoC+OZKJ6ZQzVLL626ysmzk/W5hzzbJepy10s+XBHm5WtrLUtXfYTjoKjpBRJuqd90o3UXd5Qj7p41jnXWQlu6cvWvjSIa5GXGLU0PtfvkX1HyOcUyRowuSxJku85QJEmfukLLEDUHsPvl6nIGS1Epo4J3VnvNrK+Z+/ase2bP3AHPy2YKyzhdHBGiI7JA65ND4WFpHZoTYeMD4iIcWXYnvxz5qGt5d9qcKo3ZfsMFT1doS6X310lZkHUP8Hj/JTe84CCpnGCStavI1RhxUTYzYyhj22HvTES4mEmSMxVhbuAf5McRz/SQHQ6LiiiWUTN3wcfmKLFGfB53RwaG/2Bka/n8bTQd4KPA5wNfor0Vz4hU9jZKf3IoJ3mq76pX0fvamuzdQsbBI8vykNKiaROUJWJLZv/L/WuUurVrD6T9u5Y2aBVf6PaiQRx0BNsO5R2Ms2MaQKEx3qmQmNH3HmGPhID/NGC/srWtu4ieKdlfK40/zBsmSds58iePPnqP1gAln2rnihKRQuyOT9gBquASS3UT33KkUgYopXycIpFfRJ2
 HzR8IcY5
 XwGXnk14BZ7DzzFpqJKOMBBsonG21psB76thqJAaKtG4J9EZOUnqZrv6HByTupuHEz/RNo2Vxt7qO9O61u8GodiGlYRejMzHIl60I2fUkTb56M8nj6JfkeuAlwgjWJBwPkGS2soKcYBmam6+RA0AEFFjL2j80GbgL2y7bEiFr5OeFruVBf4ITqx7IXZerKRUghexvYxGm/CaJ1SM920ME+2MmTRrVB25SDC/F+6fbk9OXS7n7wT97q0yXGOXMc7PBV9P3xScIlTPBhutQ0NRFL4erFE2auOFC+uZWL5O/DiqusW4qbQqwXtE37O7aSl7p8zMjcpnrQWtMLHZG44jC7BSOX0L5uKlgoWof2MNxHp9Tl/zmKrsESXn2MfOzBdNAPAc3cdC/TgHm+trKirmLyiCQJq/2pMAYpoQUgy3+nqbqhsI3bRHgWTPFoQnTzU+fIl+lRyg+ApHT0Pb90K07lueswg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 12:50=E2=80=AFPM Rik van Riel <riel@surriel.com> wr=
ote:
>
> On Sat, 2026-09-19 at 11:21 -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 6:16=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> >
> > > However, I believe we do need to take care that
> > > whatever design we go with is actually able to
> > > support the end user functionality we want.
> >
> > Agree. I want to add that we should support new functionality without
> > sacrificing existing user functionality.
> >
> That means things need to work both for users
> who want to configure a zswap size, and for
> those who do not.

Sure, I don't think it needs a syscall like UAPI. But I do want a
kernel config for the power user who knows exactly what swap VMA limit
e.g., the % ratio to RAM or the ceiling=E2=80=94they need to use. The rest =
can
use MAX. VMA is a resource, I don't want unnecessary waste large
amount of VMA address. Other use cases legitimately require a large
VMA. So, power users should be able to set the limit if they know
exactly what they want.

> The cgroup memory.swap.max is an existing
> interface that does that on a per cgroup
> basis for swap, though in practice the
> limit mostly seems to be set to 0 (no swap),
> or to max (no limit).

Ack.

>
> memory.zswap.max does the same on the zswap
> side, again mostly 0 or max are used.

Ack

> Are you saying you rely on having something
> like that at the system level, too?

That is not what I have in mind. The example I have in mind is that
zswap is charged to swap counters. Changing that behavior will break
our current deployment and that of many other. Kairui give some
example as well. That behavior should not change.

Chris

