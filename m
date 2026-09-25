Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7FF7C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B828C6B0088; Fri, 25 Sep 2026 16:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D886B008A; Fri, 25 Sep 2026 16:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD236B008C; Fri, 25 Sep 2026 16:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C87A6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:44:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03DC514078E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:44:22 +0000 (UTC)
X-FDA: 85253462406.14.8ADBA91
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19B9220005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:44:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eDW+5lqR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790369061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnZPCNkuYlkSQQSolmN0z74V+niIjfG3d6O9GzevQ5o=;
	b=p3sANQM3E0K7P1M2lOUYQ0C6RIdv2qfFoe6W9UFm9WaQp/a39YBJ9rG9rTIbg+7PJ57KYL
	+hX3ljVXl5m2mERodNc2VLL0z5Q2BY5CUSyeK4tXMVhM6LFbNrBYaE6dLCkuAxOH1kKLi0
	c0s3AHGHqPlNh7Hj2asQL8Ir7rZNsrY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eDW+5lqR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790369061;
	b=atR5qhb719W25QaCZgj5kkAz2fEXgxJThvFAl3Nm1A/LChh6W5DWVjPJOWGWSlV4gW/mkr
	ApAWyUrP/5UvWERH7j7RyUGT1ySolnGptwCwyCiQ+8we9WNiggvCrhunnGUn9exob/0PLA
	RYJgxsQDJ9ZJC5ukdMXHGfwSPW9idd4=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747eb79f7so6261875ad.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790369060; x=1790973860; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lnZPCNkuYlkSQQSolmN0z74V+niIjfG3d6O9GzevQ5o=;
        b=eDW+5lqR2H5EGwSIm2Mrl4n8hVzdOu1ip4Bc5y7UScqZGUa0rF2aqevSZxJ432L8M3
         Yl+tzqFIk46VnbgPBk/xfciKJZGntbH/+9j5iALnGABGsFVP7bn4tGpgYhysZWfdXgX5
         Lc7fPHKeD1q6iA+nv9ZdmN9vR34zWmZTDfq6If6gHyyX6GnMg4W28rYGqOaGjVbmyfEJ
         LV+CPj2b+H7wdUm30Uq8KG44jEB6cnL2A2pYi2+Dwen1U3iIlIXZwgGU26+Gtl3PoZsT
         t3NYzfFZY/nVjg6DI3De6zdkkqv/egI62a3wt96sedtuafsfe/mbcCikdCwiFnDDb6td
         BrBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790369060; x=1790973860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lnZPCNkuYlkSQQSolmN0z74V+niIjfG3d6O9GzevQ5o=;
        b=IAstBX/tT6+DD7mt6wJqadPIwJwJDu1Ted5BdaupEFp8goCwmEWN6QcKgfj86D1dF/
         HJJm6UPjhOdOTiOP1byJQOZ+Fuajl5409FLCu6PYY99kJDey9D72aOSRN8PEAf+2ISob
         jIU6GbDkFc8/NIAQ/LD2EYWp8AvG9DmssmJN/bulEsXY/VoNsUr5WmBLRNbbb5F6qr62
         t8jcI4ctNj8Y6+nFMG76BKJ7b2ZfTNZV23Q9/aKFmD8qnTz6kjOjp3f9J5AqNW1Gy1Zs
         Kl6FNTal0R2ulucgJzKdHlYQUvaEBrcmLHWmpe6h17uNq8qEm0h+mjdbCyt5P4Vt4WRH
         Gwsg==
X-Forwarded-Encrypted: i=1; AKwUvBw1wYoyNrntkWxiPmGqBqR/GTtFn19b1m3c3+WrX8OoGdpzbE+Ef5uXZci6wfkhJgFCN64fLU0k/A==@kvack.org
X-Gm-Message-State: AFuF++kfe6/6BG+M/xCQJ093O8z1o909LGrGRkTyMz8fBf2aRQqOOJQ5
	G3HhBlC/luO7G33mk7eQuHpKpYXu4r0EJnaOLKyoogtFg/s+Jz2J5TUo
X-Gm-Gg: AYBFou0ENyukXYuduwRYs85WS//kMDXPVVSkH6QSce9WcwGxjMpE+/+Gs8VrmZHKbEx
	LqrgXsYYqF4npX0ZqGsL+Bhw/cDll2jJBh9m+5wW5ZEXuwcR/uzBZN8ss1FUnfKhATmIRX8RRAR
	ETurhDjJ4eGI7WWFnzHjXyBilRNp0xispMJmCGOE47B/IL5TzPx8G2+FQn83RSY0w25ZABBIikZ
	MgbzPsb7v9iiv/YPxUFo5rm2L12wILBQE5Vm7dTlFHBVbrPK5ajVKg2vXhISQtupyOcWpTDoku0
	vUc7C0awyckka+PcmnSay+TTFl8aINRvBp00mLnLtHsXg0r/QPI5JgO/XbiXXcY890BMyvJHjG9
	liLkX3yHbF8W54PQRym7hmBWMrij9whCGG7rkd8Gi2SnYlH7cAuvppQDsNJE9TuHv/ePXHMSZCB
	my80QB9OKb3N00aH5mptRsjnFH947NMAfoJTFlvoj0vpYBhyNkAMdOml/PLLQTDwnh/Ub1K46Vw
	B8qU4niDCN5Ejae/Pin3XP1j60nrRp1LeRv7D134Ov00o7Qjw==
X-Received: by 2002:a17:903:3c4d:b0:2dd:ad73:c989 with SMTP id d9443c01a7336-2df7dc4d86dmr58659805ad.33.1790369059625;
        Fri, 25 Sep 2026 13:44:19 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9144940asm15623855ad.62.2026.09.25.13.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:44:17 -0700 (PDT)
Date: Sat, 26 Sep 2026 04:44:07 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbJ1LTzc7H4GL27@KASONG-MC4>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araKDOz5bce52oyg@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <araKDOz5bce52oyg@gourry-fedora-PF4VCD3F>
X-Stat-Signature: 6qc699wmxm5qcporw1nhhe38iwzkxysm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19B9220005
X-HE-Tag: 1790369060-415630
X-HE-Meta: U2FsdGVkX19i5S8heLJhrqHiFcxlVeBo1fuskWraU3yMSTx0cmOyVyLTmK6fLGhcSJQYUKSFNhBdQ1gzPsVmCCQblFL8wfYDBRepnN3RgOK/W4O+xn9lsrfdBkRJDwxdrp5BR7HWUiHMx9jUMMxICaRVMZw/MEfWIfv1wE2UnAhVNjxN0Y3txlMigy3fzHhGakwpHJXc3z4tJ3eljchYteQ5TxCnOFTKRUtgp6rwnvGfrB3DgVpmF2GvIKmYK2mk6Hefj/dRbzaCpDKggxS/+Y1V8lPf9vzYrC46GZJY2UWwgOPQcC+6od4VNmIBn41nVYbkqOnW0QqDBaL0RI3cgKpdCWmBY17K90SBnNtTp4VKUZa3eX2M+dzlDLBBsFkwNNmVeB/t0SxCjQxXEEB47EqMlSTZK9f0Qp8+PDvo7zPq18EOvGXcwp3XV9X68XzE5ZBLJt/8kzTAzS0CzcCiuvwypIayEQHDbqPX41+ro2QBipx5QZi1IDhIxDCgpVpj2W156ZhWySRPW4uAXGL2mImQX4Ckl+38ndDL9zIkFAXr/2cBJ70FtBJHZFGiG/4YH658sLS+bYnU4A38Jt4NP+wX5z9BvToQRcmhalCwtw1ay5uB3DiSSqjC5aCd1Qwi7Kqauztd5N+J/c3KgZAOySSSECl62DI9JSsPO+f8ePGNLTmSKR3BhZy8yDvM3dRqcmQt2jDQUbNlecYqP4AvOK5ng931wcEsYxrxaiF/59oahsgcwQslv5Oq8ac+1Pm7ktZC2ZafVuT+4WMUyX++fKdhl9XBWtj4k9fV2NizQMmZSwhQi2pj8khxS0FJq1NwikKWKwsA/A4qAzYoSeT57P+cDuHEK/jgjx1/SK9x+PnYKb5RFG99iveW9GqBEncY3OF3JFdhI83Va1M97Nr9SD1Vc2S69H14skGk/j6vZIPbREX10+HWpMH8iexVn3krpAYRo6Aa5R/8n9oceqP
 dJdtASs4
 jMV2Dj3JpXOPpDEJ8PBYrEMiNN9+h+jFpxKGAN8mvZS7KdFx1u+sOMF1gi++Xqk1UYDONDMhIvHY168jeJ7OnbQhRh6FFCJXEI7nItYt6z6c11cZt+dw4QerfaB22bktwtWOhAJO78L3H2ZFiV2n6Plz4Xj2nTD0Asu+geQFwY9gnScv29nvrK6k/oRkA5p44EAyzcE0vh0P0QF5+nhLfdMFTpNGqR3mgDK7w0FWD6UO8R25V0wEpgv8SjbqmwAbUD0LAKpj3hUsBGm/TbEODgIrbJjl8oZIakR4R8/dr0bYLGur1obZAJuSN0R6m1Bp2fASU9w7dQ5hHVco8b6FP5YvmSDCJ9Q/wcDrLm4/OnemtRob1jDDa/IOrPte7tlccXnUPID7iXCeTuSTD8cxRQPM1pHYwi4LALRt6kHdgft7N8cWxbNz+peGJhT26iUhmqvqh4/chP4TAyFI9lSx7Rcr9hP2etDs8EQvaKCUC9jaw3JWeG5qqCGjSxT4UkcUI+ZXbpQ417CAoAFiGF0fYGTDQUNDXGM1r2GJ4rm4tmbp1vOsVZ2iIAd+5DAneo7+UgjGL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 12:11:55PM +0800, Gregory Price wrote:
> On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
> > 
> 
> First, thank you for the very nice email, this provides a lot of
> missing context to the discussion and clarifies the issue.
> 
> I really appreciate you taking the time to spell it out.
> 
> I've given it a read thrice over to make sure i haven't missed,
> so please don't take my trimming for skipping something, if you feel
> I missed something important let me know.

Thanks for taking the time reading this :)

> 
> > 
> > First a little bit off topic, I'll be really happy if we can make
> > both compressed memory and swap as separate counters (I even once
> > tried to implement a zpool accounting to account compressed memory
> > in some unified way, but, well, zpool got killed before I post
> > that :P), or at least a way to do that, e.g. something like nokmem.
> > Due to our real usage:
> > 
> 
> I think we all want the same thing, just in mildly different shapes.
> I really see this breaking into two core issues:
> 
> 1) memory.swap is overloaded, and we disagree on its semantics
> 
>    I think there is a strong use case for both detaching zswap/swap
>    and for retaining swap as a logical limit.  You lay it out fairly
>    well here that you are replacing a memsw SLO mechanism with the
>    counters available in memcg, and I think we need to give this
>    consideration as something more than simply luck.

Yeah there are still effort trying to push memsw into V2 upstreamly,
I even got a suggestion to hold a topic on that last year at LSFMM
but didn't find enough time :P

> 2) something has to pay the price of virtualization - period.
> 
>    No matter how we cut this issue, something in the stack is going
>    to implement a method of virtualizing a swap entry.  Whether that's
>    a virtualization layer that virtualizes every backend, or some kind
>    of franken-swap device that lets a non-physical swap backend look
>    like a physical swap back end without charging physical swap.
> 
>    If the history of virtualization has taught us anything it's that
>    the overhead of a virtualization layer is *almost* never so extreme
>    that it isn't worth the utility of the layer
>    ( unless you virtualize the wrong things :] )

Hmmm... I mean there are tons and tons of projects trying to get
rid of the overhead of virtualization, if you are referring to
virtialization as a broad topic..

With careful design we can miminize the overhead for sure, and
that's exactly why we need to do the design carefully :D

> 
> I also think these problems are mildly orthogonal.
> 
> We can solve the memory.swap problem without having to solve the
> virtualization problem at the same time.
> 
> The virtualization issue is much more compositionally complex - we
> need to account not only for ordering (tiers, priorities, etc), but
> also writeback mechanics and migrations.
> 
> Quoting roman:
> 
>  > I don't think it's reasonable to add a new interface, but having a
>  > patch/config option or even a mount option which changes the semantics
>  > of memory.swap.max to the v1-like behavior should be ok.
> 
> It seems we're having the same discussion.  We have users who want
> them decoupled, and users who want them tied together. I think boot
> or build option that switches this behavior is the worst of both
> worlds when the counters compose cleanly:
> 
>    memory.max = max physical ram you can use
>    zswap.max  = max physical ram zswap can use
>    pswap.max  = max physical storage swap can use
>    swap.max   = max logical swap storage a container can use
> 
> > But with compression as a fixed part in memory.current, first the
> > compression rate is totally uncontrollable, both the user and us
> > will be fully *unaware* of how much memory they can *actually* use,
> > that makes the planning really awkward. memory.max stops being the
> > bound of what we planned or sold, anything compressed lets the raw
> > footprint go past it by however much the compression ratio happens
> > to give, so what we oversold is bounded by the workload's data and
> > not by anything we configure. We can substract the zswap reading
> > though with adaption, however it's hard to change the performance,
> > OOM behavior or reclaim behavior:
> > 
> 
> I do in fact this is solved by splitting the counters.
> 
> Consider:
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 0
>   swap.max   = 2GB
> 
> This looks silly on its face - but it's not. This says limit total
> swappable capacity to 25% of ram, and you can only offload 25% of
> your total logical memory sapce - i don't care how much it compresses.
> 
> You could offload 2GB of anon at whatever compression ratio you get
> and fill the dead space with page cache.  There's utility.
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 0
>   swap.max   = 4GB
> 
> Limit overall compression ratio to 2:1 and 25% of memory size.  If you
> happen to compress more, you can eat some page cache, but you're never
> getting more than 4GB of anon swapped.
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 0
>   swap.max   = 8GB
> 
> Limit compression ratio to 4:1 and 25% of memory size.  Same as above,
> you can fill the slack space with page cache.
> 
>   memory.max = 8GB
>   zswap.max  = 0
>   pswap.max  = 4GB
>   swap.max   = 4GB
> 
> Limit logical and physical swap to 4GB
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 4GB
>   swap.max   = 8GB
> 
> Limit zswap to 25% of memory - maximum of 4:1 compression ratio
> if you don't hit that ratio use up to 4GB of physical swap.
> if compression hits 2:1 and you can use all of your physical swap.
> but you cannot swap out more than 8GB of logical memory
> 
>   memory.max = 8GB
>   zswap.max  = 4GB
>   pswap.max  = 2GB
>   swap.max   = 8GB
> 
> Limit zswap to 50% of memory, and a 2:1 compression ratio overall, but
> if you don't hit that ratio use up to 2GB of physical swap.
> 
> In all of these scenarios swap.max is exact same counter it has been for
> you, and what we get out of this is:
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 8GB
>   swap.max   = max
> 
> I don't care how much you compress, you're limited to 2GB of ram, have
> at it - and feel free to use another 8GB of storage. If your PSI gets
> too high we'll do you a favor and OOM kill you so you don't spin
> endlessly churning your swap.
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 0
>   swap.max   = max
> 
> Only zswap up to 25% of your memory, i don't care how much to squeeze.
> 
> I struggle to think of a scenario that cannot be described
> compositionally this way - and that is without adding any kind of
> "tier" logic.

That sounds interesting, but I think this is already a mini
version of swap tiering :D

And not sure if the implementation will looks odd, e.g. like if you
adjust that midway, you get different slot of different compression
rates.?

> > And if the memory compression is really fully transparent (not
> > doable by software), yeah, that's great as there is nothing to do
> > with reclaim.  But, for now, we have to go through page fault / folio
> > allocation / map it again.
> 
> Transparent compression creates a completely different accounting
> problem.  You lose ALL ability to see the per-page and per-memcg
> compression ratio, and as a result you can have 1 container jam
> 300 billion zero pages into 1 page, and another container spew
> /dev/random to its memory - the result is the 300-billion zero-page
> consumer is the one that will get killed for over-consumption.
> 
> Unless hardware provides a way to attach a token to a particular page
> (either by out of band reporting or some architecture extension that
> reports this as it is written), this problem won't get solved.
> 
> Until then, don't count on having anything more than a logical-view
> of offloaded compressed ram consumption.

Right, thanks for the info, I don't have any transparent compression
hardware so not aware of how that part works, the software based
one is being very commonly used though.

> 
> (this one of a few reasons it should not be serviced by the swap
>  subsystem, but I digress).
> 
> > So For example, if we already have
> > memory.max == memory.current or under high pressure, then now
> > doing any read from the compressed part would need to some
> > require further eviction first to make place for the decompressed
> > new data, this is not like any kind of "real" memory, something
> > feels not right here.
> >
> 
> This is in fact how numa balancing works on tiered systems.  You eat a
> fault to migrate a page to the socket, and with tiered counters you are
> required to drive reclaim to get that promotion. (Presently this isn't
> true of global pressure, migrations will happily fail).
> 
> In practice, we find this is acceptable but could be better if we
> allowed the promotions to occur asynchronously outside the fault path,
> but this has other trade offs (loss of locality information).
> 
> Anyway, this is exactly like real memory, just a bit more stringent
> (a "Swap migration" cannot be allowed to fail, while a promotion can).
> 
> I have also experimented with this particular issue in compressed-ram
> forcing promote-on-write instead of letting the hardware-compressed
> memory be written to uncontended (which is a RAS nightmare).
> 
> In practice, if you are decent about proactively reclaiming your
> workloads, or if fairness is enforced across workloads, this kind of
> issue is not as big an issue as it looks. Fault time can be minimized.
> 
> Some partially simulated data:
> 
>                       Cost of a page fault
> backend                   p50       p90       p99	max
> disk swap-in (NVMe)       59 탎     70 탎    145 탎     1.63 ms
> swap-cache hit          1.13 탎   1.15 탎   1.25 탎     79.9 탎
> zswap-in (zstd)           26 탎     31 탎     44 탎     0.27 ms
> cram write-fault        2.10 탎   2.24 탎   2.43 탎       70 탎
>   (promotion)
> cram read               0.13 탎   0.14 탎   0.14 탎     14.7 탎
>   (read-in-place)

...

> 
> Generally I disagree but the data above shows you are technically
> correct for extreme outliars (zswap-in max vs disk swap-in p50).
> 

That data is very helpful info! But it could be very hardware dependent,
especially with certain mitigations and hardwares, the faulting
process may slowdown by a lot. This is the right picture for most
cases, and for another example on one of our certain instance of VM, I
observed this (high pressure, batch fault):

                    component                      탎/page
page fault handling (directly calibrated)          ~1.92
swap machinery (slot, swap cache, rmap, zram, etc) ~1.04
lzo decompression                                  ~0.32

Kind of crazy that decompression only take a very minor part
of it.  While storage based SWAP goes through SPDK so it changes
dramatically according to the host, setup or spec.

BTW CRAM looks really nice from the data of yours :) !

> But I can understand why the point here is that you might want to limit
> the total amount of swappable memory, regardless of where it ends up.
> 
> The real issue is when your hot (or warm) memory exceeds your real
> memory limit - at which point you start entering a churn cycle where
> every swap-in swaps out a hot page.
> 
> That shows up as stalls and PSI pretty quickly and can be dealt with
> by monitoring - but I can see the desire to just have them OOM.

Right, monitoring is less effective from somehting that is directly
in the kernel.

> 
> > I also want to separate two things that I think got bundled together
> > here: not requiring a physical slot behind a compressed entry, and not
> > charging the raw size to the swap counter. The first one is great, yeah,
> > and it's exactly the part we want, it's what makes compression usable
> > without provisioning disk.
> 
> agree
> 
> > The second one is a policy change,
> 
> Disagree.
> 
> If zswap does not charge a physical slot, then it is correct to stop
> charging the counter based on the historic definition - it just was

Hmm, but the historical defination is the logical entry, no?

> lucky happenstance that the swap counter and logical accounting matched
> up until now.
> 
> That said, I think there's a strong argument that breaking that coupling
> may in fact break users - but the answer may not be to do nothing, but
> to simply give physical swap its own counter and begrudingly change the
> contract.
> 
> I can hear Johannes rolling his eyes at me from 3 states away :]
> 
> > maybe it's not needed for the first stage, charging a cgroup for the
> > memories it has offloaded doesn't require any slot to exist behind them.
> > If someone wants to run memory compression with no disk at all,
> > memory.swap.max defaults to max, so that still works fine, right?
> >
> 
> It becomes confusing, because we also want to use the swap counter to
> control physical consumption.  To run with only zswap w/ swap.max you
> must have no physical disk limit.
> 
> It is the exact opposite issue of yours.
> 
> > And I'm not asking the compression layer to have an opinion on how
> > much compression or ratio is too much, just think we need a sane limit
> > for container schedulers to sets on top of it.
> >
> 
> I don't think it's unreasonable.  This just seems like a distraction if
> we can come to a conclusion where both scenarios can be composed.
> 
> > memory.max: control the raw usage of application.
> > memory.swap.current/max: controls the offloaded size/limit of a application.
> > With (memory.max + memory.swap.max) <= planned usage (and this is memsw).
> > 
> > We can keep the compressed part in memory.current of course, as already
> > did in upstream with ZSWAP, and things can be further adapted, we
> > still have:
> > 
> > memory.max: control the real usage of application.
> > memory.swap.current/max: controls the offloaded size/limit of a application.
> > With (memory.max - <compress memory> + memory.swap.max) <= planned usage.
> > 
> 
> This makes me wonder whether a pswap counter functionally deprecates
> zram, since the hard memory consumption limit becomes composable
> (putting aside the implementation details).
> 
> i.e. is there a zram scenario which cannot be composed with something
> like zswap/pswap/swap
> 
> > Just for reference. Maybe a seperate counter, tiering, is a better idea
> > than changing the swap counter?
> 
> I would push back on tiering - this seems like more complexity than the
> requirement warrants.  We may find memory-backed and storage-backed swap
> want different solutions in the "tiering" worlds.

Hmm, I mean in general swap are page fault (swap entry) based, that makes
them similiar and that's the common point?

> 
> e.g. it may never make sense to give zswap/zram/xswap a lower priority
> than a physical swap layer, and you may never really want to compose
> them with one another, so why does it need to be considered?

Making ZRAM have a lower priority could make sense... Well I haven't
actually see it being used that way, but first there are users of
multiple ZRAMs indeed, and e.g. if you put offline batch tasks on the
same machine with high priority tasks, and the offline batch task only
want to finish their work, however slow is fine, and the user want to
have lower impact on CPU usage from them, with a limited storage space.
Well I have to say this looks odd and just a theory, but we have see
too many bizzard usage of the Linux kernel, there are even people
using deprecated GPU's VRAM as SWAP for CPU's RAM, and hey they
still make sense, you can easily found popular community projects
based on that.

