Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CB5F531EC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 03:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11BA6B0088; Mon, 13 Apr 2026 23:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC24D6B008A; Mon, 13 Apr 2026 23:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1286B0092; Mon, 13 Apr 2026 23:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B577E6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:29:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1674C140398
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:29:26 +0000 (UTC)
X-FDA: 84655731132.22.CAC8816
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1079012000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:29:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hOletua8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776137364; a=rsa-sha256;
	cv=pass;
	b=H4FFzi1q2b9b0XRrxhvoxA+HeAYTNnFga6K9h4je7xY7mcqk18os8DbOGZuYZirBV1aVa/
	xtiJy+Zo7xMC6IY3Jq3137NlOtN858GCrLM71wtI5R5q63uAdaeB1p9OfstMlqXDPY+rYL
	2CLXA5keY6VZ3miEWpD76ZovhwSPDes=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hOletua8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776137364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IgEcKdFGPBfiWmGanmcMdBmry9woiQGfJg0pQl8nak=;
	b=JRhmFRI2kYIxLPmktY5yF9933y4xKNbrJq5hya/AzWz+Bx7S+Sh10W2hf5Ygo08H2QNzXa
	KJXZdu/MUii9CjfQ5mxCb3SyPlEAjdY4qyUyoQst7NgwCd63vS6tRhMs6JB0pVhZupHbfP
	B8fs3Guv+bAYDxzPudBqzyPuqLbFMmU=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6715006f4f7so2851733a12.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:29:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776137363; cv=none;
        d=google.com; s=arc-20240605;
        b=LTzkXQkv265XCzJYbjqFpw2edrUgqOLapXHG7b1jHtvwOvcjNTJ1xrXlsne0KlIy0y
         tL5cf5H1O+2+jEuWDwgoIwumFpRDXL8m/5UG2kIvNTh/1nySInKu8iQGIf2SvyzVXZc1
         Hotz+ZuxWlKb/eANsITdZuz0qo79XwIFQDpM4nKUujeDmL/4sSK1Cojroqgt+kbT3jIm
         ljy8zGy2VOuegP3brThzFXIhP6PcqGe2Sxuaquzh3AmAOxLHvRHGuTIUa5W1UbaAdaDU
         GUFfuhN1sTNyV991RK2Szmv4iaVJs/24CSXq2UJi9ftIuVH9o3pu8jNF7AixNPyNfC1+
         VWoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9IgEcKdFGPBfiWmGanmcMdBmry9woiQGfJg0pQl8nak=;
        fh=EIiFV88w3puYIn4OsSCPkn1W6Xs4wwJtd7vC58sUEHo=;
        b=DIAITwjWpK0IKDR9qdbHUllS/Cu9oOvYHN/sC5nDLO8zLV2hSTNw6o82biKBDAttFM
         Teo2L1mujbe56soUdXUsPelUwjo3Br0cNTGdlDRDQcDmKFQiqoJev7ng9EeoNdkkfLOu
         6OGNxZfLWqdGU/RflRlBMsMC74mB8hUxXAPnzIvFrfAvAY9boMqhJxxxRwKV+XFowL7L
         oyxknbt6aMdt2U3kf6Nr7scYmZFMdp5rV/C6YcvZu9q0Pf9VM8y4B+tGE0CNbw6kOsYO
         X2rw9AU0ULj79PX6CtV7sUdXNcTEkYClg64iVwUAPFa53HdrmMyEVYk/96+Jb95gf8fi
         pQDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776137363; x=1776742163; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IgEcKdFGPBfiWmGanmcMdBmry9woiQGfJg0pQl8nak=;
        b=hOletua8ZROjG3a6zDE5wBWOVEQQ3iGPm2ZfzJUskgJiISzgUQSijOC7pJBUntjd0U
         aiYSRdob5F73hm36hzzY/cbvOMX1jK+169wYfqp8dsz36GDqHU4BPo3CPeNDxWX2cKdb
         JmgnI4hfGlzm2xovPnjv6qupYRbINoCLZMu8MNeG7TIr3X0BY0i7NhH6P4J86dDxbPAw
         qxEZ1zGKmACOUB3jAXJyUqt3UFypTTcJZkntalmp8UZEdijOU5Z8lu2lbFQZNCwjquyl
         Texgmj+T3lC2ED4MJvp4Y/B2oCqbqrm1u8RccmBMtGc8x/gJBDhScHj6TknVqmWnzJCS
         1ufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776137363; x=1776742163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9IgEcKdFGPBfiWmGanmcMdBmry9woiQGfJg0pQl8nak=;
        b=MqBkLxbr/K7vxeC70wSK31Wbtm2cPU8GytFqs4Inz4FZ3C7Rj8zOdgffeyneb/LPB5
         whTrTXPL/Mo78NiXLfziy2SxGCj9ZzbRz9sxsmrcckIKO2/9zsbuj7db3NfankXYPZr/
         KrOTTXFTjPLmQTnX1AVEc3tYMJZhXfObbvziIn0xcRe/lPYwd5PJ3RkXYImnWGxv38wP
         ZCTPfWiXRs2wjOB/jRQG3aWU/5s2eVtA6bcFrL0/ekMPKSp/Bgfs+z6K2Ac3Bz5U4F41
         i0W96fs/enL5H1mjmfdVmAEHEh+A9WKKcArDjxi5YQE9nfyTAW3xXJeg5MBadecK1MXt
         ekXw==
X-Forwarded-Encrypted: i=1; AFNElJ98tEqsT2n2Jy/dBOngq01P+LPluXfvgZM8geVXpv12elMkriF0KXPGX4V4vFe69TXFgIgma4nZPg==@kvack.org
X-Gm-Message-State: AOJu0Yx2er1xkEz505axfReNA97M/uSezGIONXIK/Z/DvF/Nr5cqqrJZ
	ys+7QoiYqLz4nBo2BPliW5WIRhxtIxJCx4ZZUZbw6L3GphD992kQhdNcEIwtgiKULsQCN3xH8FL
	84f4TWIOiWfiSXe1XqNbUFo27Bf85gms=
X-Gm-Gg: AeBDietL8cjMISa0ShbkZjCwu4sZAUqElkN3++uD1vGlLIDwTdf6ZPnWuIV+QunyGpK
	Z7/sb04udvd2c+VevimT+cnLRc1SGKn/6uQ0zFppcElQWBYeEoL8C1Y0zSVoLgjs4wetc9UANTG
	gY+ggH/pqROErRAn+P3DXnY7JmcJoqi4MFIAZvv6Cs2xCKRUXfRi2/HgkRDpMC6e6g+Cda8ICuM
	rdCAA5qgqunvApMwR3qzeHCb4ZFWJ/176u2dwGZD5agZ6evplqcIJ8V7ESMxyviZN/KTuU8LlSm
	JoK/x7YT3Z3H5FtJ77uRDAtuYgWsRW0XVxUM6H2k
X-Received: by 2002:a05:6402:a54d:20b0:670:8d90:e861 with SMTP id
 4fb4d7f45d1cf-6708d90f131mr5258361a12.6.1776137362474; Mon, 13 Apr 2026
 20:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <acQrQYHJgqof0yx4@yjaykim-PowerEdge-T330>
 <CAKEwX=NnHxpQKp9qBg2=r_euyjgxw2nHXjbgof3MymHTgJmRAQ@mail.gmail.com> <ad2rYH9tUPthHFoj@yjaykim-PowerEdge-T330>
In-Reply-To: <ad2rYH9tUPthHFoj@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 14 Apr 2026 11:28:46 +0800
X-Gm-Features: AQROBzBcwys1sJE14-sqswOYWhGVy-YykuPt2kRn0gHSFefB_BbHyO5y_ejkPqk
Message-ID: <CAMgjq7BO6SLZPfNXDh1F-7RAOqDAfqMQ4PM=qjAq1mCsWyD0LQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: YoungJun Park <youngjun.park@lge.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1079012000B
X-Stat-Signature: 3z6hsnenpaauo8ohtibwfrfda7moypeb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776137363-323930
X-HE-Meta: U2FsdGVkX19ttQzD+nVFI3RSPgPV8+u6j7UUjAldCDWagtVDbWw2/88Q/OxoFvc7SXSTPijRqOKOunrm/gP5pAMxkdfxxoCYCi8tvmuz9WSdc4Ok0pq154qQN0AhSY6c1dYNCtN+QqvU46qD8ExMfS7dYEtNnNNHQh+iC9M1uFyeg6PUDwDCxVkbT19E4SCK76VjHs3zMeuvp5SYJrz2xACdhnaf0ZpLklnSmDPilcH0muxP8+xKQXrpkbOfH1dI1rxcvUJSTtTHB70R0UcmYKJcAhUaFyaplzADUlrW8wn192uuOvX4ioA4NmmJxiXtLRvVVpGuELxP7nxlIPWjR4w6C07jcUIaQSxr5jOnOaSNgZoFADw0XELM87kNXki0DNOYI4qD6gCb55dSAT6RRoAmGPjhzkq9EFEfW79GgXtR+MC3y5PNqVY/HCUD2ljGIkveELkCkh7yrWC/6e1eGvGc+6yJVQ48UHUPsTp1Cc+QpYPhAnoFvQgJAczPJQtF+8ArRxv9Lqbm6HukJDy02FfBC3YnBkQ9J7wA8sGxRi2KbCxt6P7Emz9vNYmsW1k3vJ1ZAoefgw49o6iamrPoJSNqGLlWGN4esyYTX9C2Czq7XQq2xQHFFldpigNvIb1aJKitpK/FxFRDPVTjqouut8xVCzBwj8ufvSpqKKfoSR6/qPaA88aT9YPuCC+n9CpnPuINgSqNASUMLQuTLMriJqiJYW8/ePguq4Jro30oYUftZgO19RA0Ege94ZP1TZMJmPDq2CD6lw/sz7LkuAeNFNlcVcIVoAT1X3uz7Nv1d/snbAMXadU0amWGQRekBaULNOj2akyozSbyXWkOT149/Eyjbnq5scqVzgcfclKPUkFd060Kwvmz6M52FPLuQvTM7esrJbLBtkc5KMeslHN4r0QRJ2P7xfwCkEF76AG5UzEHnwqq+I1/AX+M+ATocDEUwmrkvK7KAqFee9MxyK4
 x3rnxOz+
 JLjdii5Y/7+KzwsqShH6Nxhr7ul534lLEuFTeWkVY1UdmYLEJ370u4vZmd8EAxbEo7rUQk2zbgcRDA2K5UNJ4BqK6x/wMR4alXd34YHeJMJGxdoDVrNTaXqnSIFgPtnfa0AjknjeyuA5foof2OrQtOcrUQdLUkVQTqWraiWbDcAeEIQRzeonkNSS9X3u74Lj99dilz7EuAmrXmuzoaQ0OzD6LAJnkYSELo8hSPC5B62uJi07JPlnfnwWf+VBBMZTFPP5n8v8ItbQdZO8eVWYwVJS6eo4ChUwM7MvaH1ns40URP4y1TVX3NhVxZB9izgIQ+U2s56owBhGvJ9U2iz0Qjh5hkJEOfAaPpbAGpasKFp4/NC+FvGgCDPoZIh3lcVG3/Yzqko0qB9qhal0prZ57YJeYMC+V/jEbI//ql65NFM/MGzGqfYA1VCg6f09Q71+K4ROg3LdrzQsvNz0JagqyKFRYl7L6x5XsbLszSqkSqhImwjkdbCSEOnWbtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:05=E2=80=AFAM YoungJun Park <youngjun.park@lge.c=
om> wrote:
>

Hi All,

> On Sat, Apr 11, 2026 at 06:40:44PM -0700, Nhat Pham wrote:
> > > 1. Modularization
> > >
> > > You removed CONFIG_* and went with a unified approach. I recall
> > > you were also considering a module-based structure at some point.
> > > What are your thoughts on that direction?
> > >
> >
> > The CONFIG-based approach was a huge mess. It makes me not want to
> > look at the code, and I'm the author :)
> >
> > > If we take that approach, we could extend the recent swap ops
> > > patchset (https://lore.kernel.org/linux-mm/20260302104016.163542-1-bh=
e@redhat.com/)
> > > as follows:
> > > - Make vswap a swap module
> > > - Have cluster allocation functions reside in swapops
> > > - Enable vswap through swapon
> >
> > Hmmmmm.
>
> I think this would be a happy world, but I wonder what others think.
> Anyway, I'm looking forward to the future direction.
>

Yeah, I agree with this.

And I do think swapoff of the virtual space itself is also necessary,
we really need a failsafe, e.g. a clean way to drop the swap
cache and data, kind of like drop_caches or shrinker fs are
commonly used.

> > > 2. Flash-friendly swap integration (for my use case)
> > >
> > > I've been thinking about the flash-friendly swap concept that
> > > I mentioned before and recently proposed:
> > > (https://lore.kernel.org/linux-mm/aZW0voL4MmnMQlaR@yjaykim-PowerEdge-=
T330/)
> > >
> > > One of its core functions requires buffering RAM-swapped pages
> > > and writing them sequentially at an appropriate time -- not
> > > immediately, but in proper block-sized units, sequentially.
> > >
> > > This means allocated offsets must essentially be virtual, and
> > > physical offsets need to be managed separately at the actual
> > > write time.
> > >
> > > If we integrate this into the current vswap, we would either
> > > need vswap itself to handle the sequential writes (bypassing
> > > the physical device and receiving pages directly), or swapon
> > > a swap device and have vswap obtain physical offsets from it.
> > > But since those offsets cannot be used directly (due to
> > > buffering and sequential write requirements), they become
> > > virtual too, resulting in:
> > >
> > >   virtual -> virtual -> physical
> > >
> > > This triple indirection is not ideal.
> > >
> > > However, if the modularization from point 1 is achieved and
> > > vswap acts as a swap device itself, then we can cleanly
> > > establish a:
> > >
> > >   virtual -> physical
> >
> > I read that thread sometimes ago. Some remarks:
> >
> > 1. I think Christoph has a point. Seems like some of your ideas ( are
> > broadly applicable to swap in general. Maybe fixing swap infra
> > generally would make a lot of sense?
>
> Broadly speaking, there are two main ideas:
> 1. Swap I/O buffering (which is also tied to cluster management issues)
> 2. Deduplication
>
> Are you leaning towards the view that these two should be placed in a
> higher layer?

IMHO the swap infra should be doing less, not more, so we can have
more flexible design, and different backends can implement their own
way to manage the data and layer. e.g. Having one backend being
flash friendly and it can do this without caring or affecting other devices
or backends.

> If it goes into ZSWAP, there would definitely be a clear advantage of
> seeing dedup benefits across all swap devices. It's a technically
> interesting area, and I'd like to discuss it in a separate thread if
> I have more ideas or thoughts.

Just branstorm... Why don't we just merge these identical pages like
KSM? Maybe at least zero folios might benefit a lot if we keep them
mapped as RO instead of recording them in swap, seems better in the
long term?

