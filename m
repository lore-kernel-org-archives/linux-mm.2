Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D4DC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1798E6B0098; Sat, 19 Sep 2026 03:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B106B0099; Sat, 19 Sep 2026 03:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040456B009B; Sat, 19 Sep 2026 03:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDA026B0098
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:08:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43900140198
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:08:10 +0000 (UTC)
X-FDA: 85229632740.06.17A84C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 68BC2A0007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:08:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZS6+QU2;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789801688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gE+paBGkzkQFjuoRRz7bb7MKq5Y27OcpesK3wuYSa7w=;
	b=LIgYPQEdwstgveFVWtqbawPf09A2zf33xtJ4t0ka9gN1cEBpZxWuD+OYd1Amxvk8ram0sV
	XO0+u6zksh40wmczrwtKC6ONO34QLsoaLY7RjTwpU7527jxW28Udogj8ODbwibbwber5tZ
	vV3puBzFe3O5AS8lrvBxNoPF7ZtInkg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZS6+QU2;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789801688;
	b=6OUm1F3LaBovtstnOp19Ryv5MtvaMd9eObi5+ofxnD33son/ibinNjXHFFHspeLYMkA9xr
	TSXuyr0r4QSZRurQ25LOUVNHjk9niKqkrv7Sw6Q3t+Ydi/wiCOQomyl8DKPaCJW1NEFFSU
	81uTGxNb4C25fw+eGOLrQEhLM1oUDFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83AD860232
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4431F0089B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789801687;
	bh=gE+paBGkzkQFjuoRRz7bb7MKq5Y27OcpesK3wuYSa7w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nZS6+QU2FaK7JEHO2/S2dt3qa+Hi3bOONBdvlpRuSaE2yM1DodwkSJ8OS5OT8dmOb
	 Qq2TI7DCEgw52pfjYZQLhHoypYwaiMiP/Lw4E+cTiL5ZZm6MG1KGVuiUDCjht2ODYd
	 u3ucCeh8M0UlhTjpXymQkwhHx1FZRus31fuJNfzCSfhfAG9ma9R8/siVyuqyTgPd+d
	 Jr6w8ym0RPu+yPowWicpZTRbtTxzRgtou4+Z8sZfEQi/Bode4gqK04V6ez8uqUcV6u
	 PrjA8fOb9FiU61dampiMRE+TcZnoTEfV8M9OY1MrmbVst7bqhTBdDV60/e6H0aBdC+
	 rMF33t/t/NSJQ==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66f7a9afe43so1259553d50.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:08:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByJ8fWnqGV1VapX9Xe0+NAYqCDu24EEBTXbiH4XKm2THjRZw7eXG+Zq5523qQhwUOB5ftMx3XxEZg==@kvack.org
X-Gm-Message-State: AFuF++mkNktHxcrlT8e4oUz6br4CKsX1iYRP0qshnObys4VKjJnWekDm
	kR6nfu3r4D+TgMEThVf6mPedAbsBFPE0IBhYkleclOY4dKm+ErpCgNNohqnHWTO7MhpMGevqUWq
	ADwf1Z4XeWFhgIc+ipAoKPo/WMsDcirC/3Bd+sCOboA==
X-Received: by 2002:a53:d5c8:0:b0:671:33ba:b4dd with SMTP id
 956f58d0204a3-6717fe4c8a9mr1153659d50.93.1789801686606; Sat, 19 Sep 2026
 00:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora>
In-Reply-To: <aqjcFb6MFNiA6n4V@fedora>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 02:07:55 -0500
X-Gmail-Original-Message-ID: <CACePvbWxnr27ZczLdBco4X53aKcgq16VqZouO2qXQPrSv9Koww@mail.gmail.com>
X-Gm-Features: AcwNN1WBLwbT5ruT7e5y0cS0b9GaV16VkekND9NewldgAksHMI-xQQPGAeCaO3Q
Message-ID: <CACePvbWxnr27ZczLdBco4X53aKcgq16VqZouO2qXQPrSv9Koww@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68BC2A0007
X-Stat-Signature: gt7bjf1be5kt36iiij9z8p4dhctmu5ub
X-Rspam-User: 
X-HE-Tag: 1789801688-64352
X-HE-Meta: U2FsdGVkX1+gbgpcMtpu0H8QrVt5WOSn9eEDMhhBKoyCmS6sVaiHC+sFb3LaTHEEogsbMiePO/yndImwdcqHUeuzwbJqwR03VfAC8smBWjPyG3WRuWiYpJOJqMgqBwRdSiW3ok6kZ2M4U6HutAOPXEYQfMF9k1tCTKp4wb2ADZuzXjc66f8VVKmjmDWyFNrw7xLTdv0Y3MdioYW5rsGAHmZK2jt8waR2Wjpc7LfKRUFAIJaDRnikbi9DTfpMTekoccpOdXhkn3BizyjKZ21uyJb5OhzwHborRp3em9u2U7V9Pmi28WdmRiHcgnzfMmEehEj2vG4SqYY/f+iK4qwvO4OcsIZinUz/WlWrWY0x8uWymc3WKjZfKOChoOKPwOS2/wS8kfY38e/LolJK4ac6q1LOhdEpxZ3IY1wG0Cui6ngzAeB4j5eIuTlSJJx/8ngRY8+FjyBfYgAzsUEILEQB7PSkDoW/BrDdKRvvXHNd9bTYpLKLlX8anmRoVsmqHrRDIeQb5HiUaSuWjCLfSkp/qqpZhp+GuDfDKy9gNTPmcZLpmCa70+lGfhwvprEmC80BfJM2/OZfkTg8647fjfYWLVch9HxBW6BAjr+SMatEo3binzsw0WHicKiOMuitZzqiXb5uxqSbvSdSSB+llx+krMOTTyovBCX2wFGy2DL2RaG7kZ44KD6RakBIbOSy5knZn1P2fGgK10tmCySWknHQYYS69Gn6tC40GBASYOkPL4YLqDDfDROmJcwRcQT8h0DWJdGQfb7KGNKMEC/TwXvPoOTvZhwwr7KBoEfONmaXkj211LF+j0SGKBkq9cL/Cvxe+jdcs5r0zcYYGdALF4L1hfH5KUp6r1UEplZgmtER1g23kJmmsOznbAwcI6kHxpOF9Oux+beUvEtKsh8UZ2jJUaJoQ+goA8NvHkw6Qgpd8rkJSbLEaeJsgOv9EhVV37StfV12hZTSU7o9xmDS7kN
 YcNmq8WL
 G0FsCCHkCYt5gJnknic+16NdJUw4hmSH/J8uYyo2kPkRzlyeCXEgi6QAsZiXi7RUDr+Oy0Rtb6NHihViSIZTC3AvD+i4M8rQGZNB0sUJj8fsefiI75Wz3Y1XIEQ/O8dvdHkLZ7tokUFfmSLbBkKiNS8tsQ9/wDjBgpOmILH4gBEC2gKp9qKtyh9XUbYXDEonzt7XZ046fMQ3YbOeDQK3xRmUaxsG9uhRnUr22KAVFAXBmiBr702VmxXyQnhDS8FbRBWxtIJm2G3lMipYO+l4+vieE+6lnQVukXHtUyyFJu5OMtgPJy27BvNEPT9f2GNKN1xFKzDhgXYnFQk+oBmOnP8qAjZr8pALlMAg8VbJHQkdmCXkbGem8MY16GWCqcvoG0lp2i0RtKYD+1QHEtKNvxL1sNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 12:48=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 09/11/26 at 09:45am, Shakeel Butt wrote:
> > On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> > > On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > > > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > > > Hi Nhat,
> > > > >
> > > > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > > > .....snip...
> > > >
> > > > [...]
> > > >
> > > > > With VM_SPARSE, xswap's cluster access is exactly the plain-array=
 line the
> > > > > rest of swap already uses:
> > > > >
> > > > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > > >
> > > > > no branch, no RCU discipline, no tear-down state machine, and no =
NULL
> > > > > return. So VM_SPARSE doesn't add complexity to close a gap; it le=
ts the
> > > > > cluster layer stay as simple as it already is, which is precisely=
 the
> > > > > part later work (writeback, rmap lookup, memcg charging, THP) has=
 to sit
> > > > > on.
> > > > >
> > > > > I'm not going to claim xswap wins on throughput. I measured it:
> > > > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are=
 all
> > > > > within ~2-3% of each other, effectively identical.
> > > >
> > > > So the claim is VM_SPARSE is simpler than xarray based approach. I =
feel like
> > > > we are discussing implementation details before deciding the design=
 and
> > > > architecture. So, instead of VM_SPARSE vs xarray, let's discuss and=
 decide the
> > > > need for dynamic growth. Why we want dynamic growth upfront or can =
it be added
> > > > later? Once we decide that then it will be very easy to pick an imp=
lementation
> > > > that would take us there.
> > >
> > > Hi Shakeel,
> > >
> > > Thank you for joining the discussion and for taking the time to comme=
nt.
> >
> > Hi Baoquan,
> >
> > I am mainly trying to facilitate the discussion but your use of LLM is =
causing
> > more confusion. LLM use is fine but please at least re-read before send=
ing that
> > the sentences flow and makes sense.
>
> Sorry, my bad. I used LLM to find Nhat's words. But I did check it by
> myself. I wrote most of them by myself. While at it ath the moment, my
> logic could be unclear.
>
> As said, how swap_cluster_info[] is built is the foundation. Whatever
> you do, you have to make swap_cluster_info[] ready, then you can do
> writeback, rmap lookup, thp support, etc, on top of it.
> swap_cluster_info[] is the basement, then you continue building 2nd
> floor, 3rd floor, till a high building is done with things added. Nobody
> wants to claim he just need the high building, while no basement.
>
> Now, the foundation has been built with the lazy vmalloc, it can grow on
> demand. It keeps swap_cluster_info accessing as swap_cluster_info[],
> a basic array semantics. And since we our target is to support a very
> large swap device with an extendable logical space, grow on demand and
> shrink becomes important. Now it is there.
>
> That's my understanding, not sure if there's anything I can't get so
> that writeback need be made first.
>
> [I type each of above by hand.]

LLMs are just tools, like spell checkers are tools. They all make
mistakes. Even people make mistakes. Don't beat yourself up for it.

Our community should be more inclusive of non-English native speaking
developers.

Chris


> >
> > >
> > > Agreed on requirement first - but this one was already decided, and n=
ot by me. In
> > > the July ghost swapfile thread Nhat rejected exactly the shape of "gr=
ow only, can
> > > be added later":
> > >
> > >     "Except for my virtual swap design, which does support dynamic gr=
owth AND
> > >      shrinking of capacity on demand ;) If it cannot grow (and furthe=
rmore, if it
> > >      requires userspace operation to trigger swapfile growth), why do=
 we need this
> > >      at all? Might as well create a new swapfile with swapon?"
> > >
> > > To me what it converged on was "dynamic growth and shrink, no writeba=
ck yet".
> >
> > I am not getting how out of context above paragraph shows the conclusio=
n about
> > dynamic growth/shrink and *no writeback*.
> >
> > > So automatic growth *and* shrink is the requirement, and the simpler =
alternative
> > > was already on the table.
> > >
> > > And I keep mentioning it in the cover-letter of each version of my po=
sting. I
> > > only did the foundtation via lazy vmalloc. And Nhat will do the core
> > > part including writabck, rmap lookup, memcg accounting, zero page fil=
l,
> > > etc.
> >
> > I don't see any evidense of this decision. Actually this whole email th=
read
> > shows that there is no such decision.
> >
> > >
> > > What is still genuinely open, and I would like us to settle, is how l=
arge the
> > > device's address space should be, because the metadata scales with it=
:
> >
> > With dynamic growth/shrink, is this really a blocker?
> >
> > Anyways, I will let Nhat and others discuss the technical details (unle=
ss I am
> > asked for it). My main reason to join the conversation is to converge t=
he
> > discussion to a decision and resolution.

