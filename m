Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F77C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 11:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B02A6B0088; Thu, 24 Sep 2026 07:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987936B008A; Thu, 24 Sep 2026 07:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D666B0095; Thu, 24 Sep 2026 07:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 571546B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:03:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDD3B1202F1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:03:10 +0000 (UTC)
X-FDA: 85248368940.08.9E88416
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F279740012
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:03:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaruF16c;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790247789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qb5cHE2dgUrO0e26v2XgbM47NF6xvjd6olYZGEGtg3M=;
	b=ODTAxBgMflvj2ci9vzo/QPadFDRbEbuH2DqPHG9SkjgvGwIX0OS2OzsugeBZ0q4MtpNlrt
	7I5kufxuvjfa/XXDdhmJOIsY8E6A0MEIlMfGfj9NhbtEpPO8da/B2fcv8HYqVQGJUEEGFH
	x7GveEJIrg0CUM5gtJEUzhxlmtsdpeU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790247789;
	b=OpTqiuuIl/0JuGfu64bWClryr4UCclnkHDq5Junt6zdWLxgCq0FQGS3Y+P/4VhWR3z0OCv
	jUZvy9YyR24kngK+5bORY+z1fwvv9VtXkkDz+hoCQCJxVlM0HlBUmZqL45P+ZBUDgmlxSF
	meXHTtsZvPWnZwRmbEjZcwJjXQTL4nM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaruF16c;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E34D60200
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4611C1F0089B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790247788;
	bh=qb5cHE2dgUrO0e26v2XgbM47NF6xvjd6olYZGEGtg3M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iaruF16c2G/cqjPSVprB5bCJNcjbvA/mX1AvmBrCN8B07E6qtOfbqcjiRFAG9sTAQ
	 3V5fGKtIn4/uIpfE0ORNmjAKzsBpDoDXAgqdeHtToWTNEDOrCkpwjfCoBhDY9/LTyS
	 MPDF33u00byP9ILEiJ6ebFfyGIagy5wEbc4Fn7tkYCo1nSGnxA95nHQbEkydNB3hsa
	 ktFNOrWV0+Gdf/dfOeLJJ7f6HTDrTuuro6R/r+xy69a+YMWDEu6QxpCH0ENUiemFrF
	 4DYyr6YdFUJK7WFIuhILlgD5C/vSP1ij7M4hWS3BVBQx+Y129btYPHTr9Uw18yntWV
	 nz6IP5RigS+XQ==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aa8d882so1979899d50.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:03:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByFbXdRXdmc0aVb12fJkBpOcAYRT/LpN84m/NbmGD37V7IUP1opJOURTjOsD4Yi8rNnsw3OPBH89Q==@kvack.org
X-Gm-Message-State: AFuF++lcw0mwdjuSMVxXIhxA+OT4w2Oa3i/Wj8c+DgITRCKll6IOjDOB
	pF3e/9JOkUNlURQzcZSZcLGsK2flNnWRQASTIM/m8E5PtRS+GrAUU+X+24eaPM5jaN0t3w5LZ9d
	gTZBa878SrkqtWx26He8F9gOSkcdxHCHdQuZCnQBYpA==
X-Received: by 2002:a05:690e:43c3:b0:671:1256:56f3 with SMTP id
 956f58d0204a3-672ed2624cdmr748540d50.21.1790247787078; Thu, 24 Sep 2026
 04:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F> <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
 <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F> <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
In-Reply-To: <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 01:02:54 -1000
X-Gmail-Original-Message-ID: <CACePvbXHan6Sfmdq6JFrcaMMy6SGvzPs-pautLtg-9D6=W09qg@mail.gmail.com>
X-Gm-Features: AclHuK8VFQcjyBqPb4h6LbJpz-yiYCZ7Fqjey1egs43oMEG0gsapG1F4wdinNfg
Message-ID: <CACePvbXHan6Sfmdq6JFrcaMMy6SGvzPs-pautLtg-9D6=W09qg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Gregory Price <gourry@gourry.net>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F279740012
X-Stat-Signature: 3mwym87c74ww6nh3cquh3q9py8kbxnmw
X-HE-Tag: 1790247788-152617
X-HE-Meta: U2FsdGVkX18ONN2/KtgSrWJ+BYeUARyykhUEsHxP6C0q9UESYfLHovfN0CCzCGV23RDvttmNO8vQJZ4CiANm/+bH/WoCJITc/sWiY4k6OuCAO1N9/+44MedQdNo7eHMhGvNNhK+0tvNVIJKVTlVJ/yHtWxW5CBAFh+yMUgjHANbgJubiebt7it0qsYEJFmrD3bJlg4x0L+nTxm2QckljBV+Ja6dzJ0CTQ19lfJVZqtSkJjmw9GGPW7iu071v0WQf4Ox/yTqHuvTcQQJ/DIZJeWfzbAETY6FhPPUqEOBKxQqAqEHod1keMgi8Ycv3pEqiiUZ+15ump0YaIvru6kSBCumutvzvt4zvjj3P5LFxlkdQEBPgAW/pIZ/MDtE6SZ8btAcLrjLblWFzcHOKApCy1OcJo7KBPQbNlSeqW05bljgS08Tsi4/8Q8wq7tjqFcZQNAfzNYZaSPrmYBtouUk2rgNOqGO66WfqReFCsd1UpxSkhqrC6IssQZkM1rMppJjpdp74/PlZZHrEeBk5TunGaM5QsQROaMYTYDEvyhb/YvpTRFSLsUZAQVlstFtroQIU/y+Amt0vSYoseT6TrLHB0uP8Jvj7zwJtvBd08HBmoBdnWPcZvtgoG5yS+LZ3x6FrPOP1qQiwbzmJ83ViVXD3gPFFSqhWKIxzkzihMh6pNE/7/ytfmE/W7eiyUuonpC/RmiVSqR9phSqIreoCiLTb14OEFqaJNn8L9FEFz8xDSnVUnc0ZbrtRIsRpPivj44gjPOjR9vRl8RaC5iH7/faJtRAhNSQE0+PYI4Enla8Ng+hh4FLzC88A1AxVkdjhL0VJRYCdCQIxeneFb5UV9o9gKLKGGKPURzROAw4LTONjHL6atmIMrenkz4FIjBK/I+CmML+q/VYH6dVQsKFh1MNr1z7PflNiF9z86xzInVPjWNoVZLqUXXnM1AeCsJmPjbi+jxSMKcH10UH9nib7GcG
 YI0TLOD9
 FuWy37som8f8fzrVbbYnNxccJLIi2lK7W2+I/v0ux+fO7g4AoOYbaiFlI1TxCAJFZ+mf4JC0qWoUJoSu8V+1V2diZzM+N08tWgSERLat4HV9iAXcjkYVXOKNMhXCjS6GIoiXwFLpqWx46buYOLvmEj9QMnb5LfdR4dmH0q0aT6Y0nA5H/XjvUTFtNJm9Ol9IP/vwvgryAKVrmWO8cN+YBWEMfVvm0DfHJOIns00wTNP0bOjbSiaYkTdQR/SnfYHCWx1ToiP/I8ecUMsI/vDc0wq0I+Lno2mkgX4GeRfXV13mgBVboISIeruA93KGg/cCCwFGL2qeq9XuPiKCxRkSR1Ibc2xR2/sYN1j0xkHtYwgemCzZEaoc8vImNVc8kI5fktbC8YBqynWb5DNOzobkopb4aC28ZUVtjwPntvfRhywJTVu9K4fKyAfEK7QE7MBiEhyiDc7HQ6mGZEanQ/Ee8MsqO7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:39=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 09/21/26 at 01:02pm, Gregory Price wrote:
> > On Mon, Sep 21, 2026 at 06:32:56AM -1000, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 3:27=E2=80=AFAM Gregory Price <gourry@gourry.=
net> wrote:
> > > >
> > > > This would preserve the existing memory.swap semantics while allowi=
ng
> > > > both backing resources to be constrained independently.
> > >
> > > It sounds like you want memory.tiers have limit enforced.
> > >
> > > I suppose it is possible. Again I want to see how people would
> > > actually use this feature.
> > >
> >
> > Possible, but arguably not needed. the swap and zswap counters already
> > work for this existing interaction.
> >
> > As I pointed to in my response to Rik, in every reasonable use of
> > pswap+zswap the global swap counter is pointless.
> >
> > So then pswap=3Dswap and we're left with zswap and swap.
> >
> > And I'm not convinced your reading of the swap counter as a limit on th=
e
> > *logical* memory allowed to be swapped out is actually accurate.
> >
> >   memory.swap.current
> >         The total amount of swap currently being used by the cgroup
> >         and its descendants.
> >
> >   memory.swap.max
> >         Swap usage hard limit.  If a cgroup's swap usage reaches this
> >         limit, anonymous memory of the cgroup will not be swapped out.
> >
> > There is no documentation I can find that has ever documented these
> > counters as "the amount of memory requiring a fault".  If you put a
> > compression system in front of physical swap - the counters as-describe=
d
> > would still be accurate, while your reading would be broken.
> >
> > "swap" here is highly implied to mean "storage" as opposed to memory,
> > which is why "zswap" defines its limits in terms of memory.
> >
> >   memory.zswap.current
> >         The total amount of memory consumed by the zswap compression
> >         backend.
> >
> >   memory.zswap.max
> >         Zswap usage hard limit. If a cgroup's zswap pool reaches this
> >         limit, it will refuse to take any more stores before existing
> >         entries fault back in or are written out to disk.
> >
> > If you're presently using swap.max to mean the "logical amount of memor=
y
> > allowed to be swapped" - then your usage does not meet the definition o=
f
> > the knob.  You need to justify that your use case cannot be expressed
> > via memory.min/low controls:
> >
> >   memory.min
> >         Hard memory protection.  If the memory usage of a cgroup
> >         is within its effective min boundary, the cgroup's memory
> >         won't be reclaimed under any conditions. If there is no
> >         unprotected reclaimable memory available, OOM killer
> >         is invoked. Above the effective min boundary (or
> >         effective low boundary if it is higher), pages are reclaimed
> >         proportionally to the overage, reducing reclaim pressure for
> >         smaller overages.
> >
> > That's an SLO interface.  memory.swap is a provisioning interface.
> >
> > As it stands, I'm left viewing zswap's counter inclusion in swap as mor=
e
> > of a bug than a feature - they account for different things (memory vs
> > storage usage).
>
> It's hard to say. When 37e84351198b ("mm: memcontrol: charge swap to
> cgroup2") introduced memory.swap.*, it was clearly defined as charging
> "the actual number of swap entries used by a cgroup". Please see the
> commit log. With that, zswap still reserved a swap slot even when the
> data never reached disk. And not to mention zram, it's backend is RAM,
> but not physical disk.

Right, that definition matches what I have in mind. The actual number
of swap entries regardless of the backing type.

Changing the meaning of that breaks existing users.

> Now some deployments do use memory.swap.* as an SLO signal, and that is
> real use cases as Chris and Kairui told. So I don't think this is about
> who is right and who is wrong.
>
> To keep the existing deployment working and at the same time give the
> physical slot its own knob, I think the solution is to add a memory.pswap=
.*
> counter as you suggested. And that is not something we think of from a
> brain storm, it comes from real deployments which already depend on the
> current memory.swap.* behavior.

I think it is important not to break the existing usage of
memory.swap.* behavior. I am fine with adding another counter.

Chris

