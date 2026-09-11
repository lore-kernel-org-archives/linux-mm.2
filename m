Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89282C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329046B008C; Fri, 11 Sep 2026 14:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9206B0092; Fri, 11 Sep 2026 14:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8396B0093; Fri, 11 Sep 2026 14:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8FFE6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:14:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F6E914025D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:14:55 +0000 (UTC)
X-FDA: 85202282550.22.C18DFD2
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89E4618000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:14:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qao5xUPf;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789150493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgMffH9c4Ut5GzZRUzz1jul/MtsWXNFvANxlyz2Cqvc=;
	b=mjCZ97ZXrWBPVhqOw+d3LT7tYNm/rYDXnx82D4P5Ip5vBiDodBs6BCzp5ViqQgZPOoBQMe
	MMavDcVGYYXJv16VHPLnzdk7eEXODwsvqE8VvCP2S6C2wp0Dp1ySD9aMo+Fc7hQLpAfZ4B
	T/3ALOOabjRoMaaPajFgh7rAvpTq4AA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qao5xUPf;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789150493;
	b=DE025C8AivmLhpEyv9daj3yXFm+VokT6Qdu4kc3/YhK14FkiF7coruQmqESp5J/HPT8vMl
	3q6iE0OchKYJqPi0FVKvq4RVlmbJFukHgkjwgO3L/Q9sHqlYbJJn/3cBl/0gc8e/aF+zbA
	hoUVMqWN6UGVffTeZICzRvCCOrG1MjM=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c253425b253so201472066b.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789150492; cv=none;
        d=google.com; s=arc-20260327;
        b=rQ7FBchUETOBfdGOsPKywFYbMkaNr+P83SiVPE3fWzHGHE9MBEWHiiR+mdusKiLjZQ
         W1WKksFD0UbF8mKrIKZWcCkDTygdQ6Yn16GeGIdPr7wwKaWGLIfLe0SPPuFEs9nE9KXT
         wkNrs+BLSDw4l2JDVnUPRJOyfiHQ9UGKfmSqYGMqplHUm/JkCIC3vf87GJ61BZCYyCJ5
         KjGlhatdV2493r7gqMMXRNizRCiHT+ufl496LajmSsoLDrGNbEds3gXYyMaI21XITsmB
         BtMF+urkc5YkwbLbClTVZvceTydM6hEdeBFqMa1GQ2rsqKiLXquF9407uWaUu2huZVyj
         ydag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sgMffH9c4Ut5GzZRUzz1jul/MtsWXNFvANxlyz2Cqvc=;
        fh=v6zClFgN2PJ6s3PQlLpxAhR4H0YY4j5VWq4vlULvaNw=;
        b=kfzMEcFMee/k7kg4OksCh8r36/cpvZaEFstSYRDzuX/t6+IT0Ti5Kj/YV4jsV3zvtt
         ea8/V62uyk/GUvpOXsbk2ZR+GXUFKqF+reXoZu466Ewb4mdE4erEG/ZQEw0mOhpxKUHC
         Tp+qQalwCpLr937AUokLuY4yKJgPlS5/6Tmh56YiSXKQojOvYbvAJ2Sog6wBiIr7HRIg
         9d14pD5EnVMhK1JgtB1HTSc6liMEKqionHNa7s3JIhnPRTnCsrRr5B9BG86ro6XeNEa6
         3VCUaQMo5dOfQBz/ITFOtyDRyB6zDL7fzVlJIcPmzrxCzRNKGg07R2QEPaBcCBpiWJ26
         fmCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789150492; x=1789755292; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sgMffH9c4Ut5GzZRUzz1jul/MtsWXNFvANxlyz2Cqvc=;
        b=Qao5xUPfwhHGvXq7vcDOJ2Kf9YMQdXBOKDqyeYMQ70yLgyFRM37trW3aSRJm8dSTej
         1b+6ELTGgbYvPImekvxXS4DddkHAaiGCT0E2qGV52fnGOrvqqgxPmCMCUAvt4/PorB+v
         LALSVkOZrvYi9hi8l15dTESH4lE0vNrhEmsPuLSPUwdXzlagJdX+NSycGhS9Jax7xn1j
         pVQQP4+tcqihRW8XrHw43paGl1PQFOoEOQx9eigmf8zC6ZHwSURnXdFk7u1kKC56GkYd
         U6hH1QMM+eexpfjQ8GoTb5A/F0H8Nr4Ec+0wtqI/mvoDpQrc7NS5UgF8jJ5INNZcSO+i
         dNNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789150492; x=1789755292;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sgMffH9c4Ut5GzZRUzz1jul/MtsWXNFvANxlyz2Cqvc=;
        b=ItTuV5EY/AKkE0gG0RoZ7rBNEOgKrQ8nuy3oAegLQGAAhGBMEIQxKth3GjF+NW30WQ
         VGj1Tdl0R/zlheyOkiCq5v4/y/mS3kpdolI+f5gB4xlml7lPBeBZsNu+IfBcN5RtkFG8
         tIIMoL+flMD7tNIp3wnQT2/KA804tEkNlynFXoDez/0T7+FLiK2A/bvIfMq643AacWmw
         U/dU3FhmWttkhrpasEsv4LkCLAN6qaiq0pXUOumvgsNr/OxKaIPYXqToAAzssOs/WlYC
         K8gc/0cjHYYczOldMkMUt5EYKth1voCOBBmQ/f3S7w7GGzN3KBj0bOnkdALDJvppspnP
         L8/g==
X-Forwarded-Encrypted: i=1; AKwUvByTySM1xD32/jcdPI80T8evDIY0Xchkp/9119Iiz3JgTYSTHXOu4YZe9VrfqnLlFoUx1LnWCGj0sA==@kvack.org
X-Gm-Message-State: AFuF++kdoNCOkBRCE3ryfb18rvjNJj0MSKBz2HYLHcKQIKgaDbG3b3F+
	0x5ToKph8I+uPto/vPfmf3D4VAb1EYBFSzUN7ybxoASKhgw7GXkg+ybsrvShXi9bDnQXyHXiRJw
	vx85WQuigZsKWura00JDEZSymiXYYaoA=
X-Gm-Gg: AYBFou0aR5auwLD5Zpa5X+bTifHNGhpGS2QjIF5XB3QrA/OaUbExAUvZebcRbJ9HR0U
	gz5lEFGVJpH6auagzvzkIrRwSrP6IEOzGViAVE4x66+Jw+DQcXFFM6PWNrcv324XLME8PvyEHpg
	ZUjk2I/ij+AJVm2fibT/WYLr/4VMWbVD7aZ0Ot6VGAoL1JREofqqUxm6rYArxX+lqRUv2JWUBfI
	XUm5FMTGPD4j8595FHlreIHwsU6jz1ahraEd9xSGNJK5wu8g53zhPHuRtibBQcphaq6PiZEfNU1
	isbkcsYTHv/j0UfXfXeZbfoE1cWC9nEZlm22RnvC/XfNUgXuPzsTR5ZOaIEaPxjE8++s0v46aJk
	536akDg+Hm6T7
X-Received: by 2002:a17:907:1c10:b0:c29:286e:2e3e with SMTP id
 a640c23a62f3a-c29666d5f9dmr241723566b.38.1789150491872; Fri, 11 Sep 2026
 11:14:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com>
 <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com> <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
In-Reply-To: <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 02:14:13 +0800
X-Gm-Features: AcwNN1X_Mr5nGygMYASuHxKAbKSbuoEdUvrKDUVcI7Vk1_FQ39e_c44cG1FLDGc
Message-ID: <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>, YoungJun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: otm1ugb7a4ubmbtio851y18goheq3wrx
X-Rspamd-Queue-Id: 89E4618000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789150493-24109
X-HE-Meta: U2FsdGVkX19zvwTCzrGN5UEm8cnVMGwziGMV0wnkM0JOgKayvpV9gmE2Y8nNHXQA7CQ+5OJeiQ9QeEHaCzQAQwCKAc9K0h0LjaR9a8O3Pmn5cWB+2CDVcEBxouB8blzmurxXvKG6WQBEQJw1u7j1mymCqcBaZx+mvAK0F0CcV1jy5Dr1lsWHuAJLWND8BZlLo8xF9cigSLlDKHoqVXNcX6xuxe6MuQPI7UY9p8XBqzYBE+viAYlJFMhLDNhtPdU+oKYvAlYE/DiHVAwDsr8079LVAG5KZvUHNbsVVWce2HPqmzcZrxtfpWOgmELkw5vx9H13qnqSmwoClMN0Irp1d1TrRQOHNq8JZA3d9SfQkBShzBXUt6qsJzN5EhlaDSpfrnzGQ/dSKQoJjzkxzn3jOo/PkogTE3z/TZcpF6sP6d4lY2sgVMM5dPEYONz7MUIG7PRp95kWsEg63d+R034z40KfxNouBCdVmook005nI+nwtC8che4MR90lWjlPeNo019D4wt8tzG7xoJHTKi7OSb0+uD7wY4GyuMVOzt9uREDLU5IXH1Y2wplZCefJCKkL0kjlEiViebM8jw7fgT9RKoghiSx6Xn4czzts+81HcdxYruszv3iJOcSKeoVHuZZZI8mCjwFNx8qGRZm/LZYhcJaiS7Ai1zrjhji5kR5fki4mXAUrB+ZI8dMrbZar8wQb52bzkhlr2U7wD+Cn5iqhvGsQNxxrcwNXlW2TFA8tusrOfWB6j8INx/y23ERXbFjcJpttpvveUIvI38jzu0X+g5DHLO8P3dDzClISNpwmVAdVgBOCjqirPcKYLrQlQ0mmX1VobywHHIm+vTmceD7anDtZvLUvNWrEKo9E8lzN3XHYGJP9pzmfdVj1QKJpiDhro1a/EzcDTxDDG7iKqIh0IqXEwxln/Ugq+mVIU2J8S66NNZXx1t+tbNNKBvw9umFQF36p2INr1SWdOU6zgX8
 EjlfUtly
 omK0xe0zkhy3jiZ55PlfHNrgpiMWV36vkAFIXb3Y2eNX/qk+Kmvxa+m16YDosWmB3XGDWwgdPwxTVuhrDZAM2K7t/i3jSZfiiXcBKDAlm5xeQn5B7bfYbyc1etNxSm8QZ1i2OLVA5e+FCjBdWzcrhSsdqPA/G+NqlniqWlxH/kKuSlWQpKwdgyTmOWP3kZPQi+TRAlEySiTBjSjENtfyDClkvsie33Dw4+KLiedkwl/K6A3v8hMS3BTAZ5NBYPzlNiyxNZS5WsHqnrXbqSqx1/gqRArUbQyNnB5rTFJzuM+DfQz9Rb8qvu9Ih0qrh+dDM2ypfFI7hmLWaT+WRiDfGISzRHaxc9xiTw21GrfKFrgxKEkMb6Tj3oNyRKI/rC3AqvwrCOfCp4PTvjN2hsvB2LyJYeFWIIJbopZcy9BIen4FTJMqlf8tpK9DuyXcVpnkiWukPu+JcFx5jZh2NnBrC+/wfnQGy7dISQrA8ZHoBO+tRpA32PosvIymT3qT8AQ7TW5z4jY7Ue7UiL1W27qIZXDDWxPWKzfjEkZCN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 12:57=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Fri, Sep 11, 2026 at 9:10=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > A boot time bool will cause real trouble for us, at least. We have
> > many VMs with fixed boot images and fixed cmdlines. However, the VM
> > itself is used by different customers, some are ZRAM only users, and
> > quite a lot don't want any kind of compression (e.g. their data is
> > dense compression is just waste of CPU) and prefer plain swap. So I do
> > hope we can have a runtime tunable instead of modifying the cmdline
> > and rebooting or rebuilding the base image for different cases, and we
> > have already seen that a runtime toggle isn't hard at all.
>
> Ah yeah I see. But before moving back to runtime parameter, do you
> think we can come up with a heuristics for this that have does not
> require userspace input? In v4, I'm doing this at folio_alloc_swap()
> time:
>
> a. If the cgroup enables zswap, then always go vswap.
>
> b. If zswap is not available for the cgroup, then bypass vswap, and go
> straight for physical swap entries. My intuition is that we are not
> buying anything for these zram users, as we need a physical swap slot
> anyway. Thanks to your design, both can co-exist in the system now -
> that's something I actually did not envision possible in the original
> version of vswap. Pretty cool eh :)

Thanks for the test and idea! Yeah, I always hoped we could do this
because there are some very promising use cases for raw and plain
swap, not just ZRAM.

> Would something like this fix it for you? ZRAM users will not get
> vswap indirection overhead at all, because it would bypass vswap :)
> Down the line we can revisit this decision - for e.g, if there is a
> use case for vswap-on-top-of-swapfile. There might be other interface
> that makes more sense.

Hmm, this interface looks confusing though. you mean tangles vswap
with zswap through the cgroup's zswap limit? I originally expected
this to be a problem solved by tiering, skipping certain tiers seems
much more intuitive. Maybe Youngjun have some idea here?

> > > > doesn't conflict with what vswap is trying to do. Some other of the=
se
> > > > differences involve design decisions rather than just surface knobs=
,
> > > > and those are the parts we're stuck with once they ship.
> > > >
> > > > So a few current interface difference of vswap and xswap I've notic=
ed are:
> > > >
> > > >  - default size: somehow also tangled with VM_SPARSE, which
> > > > needs an initial virtual value. It's super cheap if not zero cost
> > > > (the only cost is occupying some vmalloc area, which is fine
> > > > I guess?). But we still have to pick a number, could be large
> > > > enough to satisfy everyone?
> > >
> > > 8PB? ;)
> >
> > Right I saw that at V1 :).
> >
> > I'm not sure if this is the reason that is in conflict with VM_SPARSE
> > in your mind? Techically, at least for 64 bit, we can just apply the
> > same limit to VM_SPARSE, for 64 bit machines we have a lot of virtual
> > space to consume and that should be fine (VM_SPARSE is just the
> > cluster map, which is much smaller compared to swap space).
> >
> > And another thing is do we really need that much in any case? Will
> > things like, e.g. 64 times the physical memory (max pfn) be enough? I
> > know Baoquan suggest just use the physical memory size. So that could
> > be tunable, it's really easy to tune, just a number.
>
> Potentially, but we have many users at Meta. There's a huge diversity
> of machine types, workingset size, access patterns (both frequency and
> file:anon split), compressibility, etc.

You can just set the number as 8PB? :)

