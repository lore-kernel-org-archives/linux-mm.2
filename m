Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9921F3ED67
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 01:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A6B6B008A; Sat, 11 Apr 2026 21:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541F66B0092; Sat, 11 Apr 2026 21:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457B06B0093; Sat, 11 Apr 2026 21:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3439F6B008A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 21:41:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0F1EC2F27
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:40:59 +0000 (UTC)
X-FDA: 84648200238.30.22C8104
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id A0CD1120009
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:40:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lUrONXqF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775958057; a=rsa-sha256;
	cv=pass;
	b=UcrhOkOesyOYr/tyIOXToxVAH92mKskw6ahWPqzjmFSf+TxaEOzBbxMyVwC7YWkWejrYCm
	cnDsjqDSWp+J4tfKrcdMTljOOkCfz2ngkFMsyEVzwme2WFmjPo5Q8PEBizr2KPoef/317p
	ZCpP3mEps9dpDScr/mn9s6m7uLH9DNs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lUrONXqF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775958057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNNOEzC050HR38tQUwt60z/EV+azgbNAgyZ323Y4lY4=;
	b=X09gKtQsOpKtIeR9GfiQ0yjXZm2Vg7qkJxUfvhA73yiy8TeQNPrZCzQjqREElfotocTK7r
	TzaC1/OxMpiPreW8k21FW7qoN+8fTnaWvKv3BPp1dFAIGAvq5CXs+scJ0dKwPISYG3C82p
	s+3x28LRq1XErdPN4RswwGk4Kjawo6A=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d572f7437so2137099f8f.1
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:40:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775958056; cv=none;
        d=google.com; s=arc-20240605;
        b=PVPHCoH30QWelbWQwPog8AXAHLRn4PBePllqvR8QF8at2PCEkm01E620nNah6SwGFW
         0jqNS65DqWler/SFxtnPBXTd25K+zEhxNCPqX+khSpTlKrB20djAAOWeo8pZVMOOTn/e
         i3MHXDbsuk2lAillLwVb3OQmZ/Ymmkzl2TxlzHQ6zbnPZKNSPyY81RwC12Z6m2VbbTk2
         F+bqfncQB+1y8SlWU2ymKYfZC+5gcrECk4vHckM5ksUF3freETGXG4qH6KsMC7i8PRb6
         ocLto3XL0SwaGHt35EkSjJWLcDGmjGqjdOtLjg3Fq83Ph23VTvR2YBYlVM3Dz91ecEAn
         nQFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rNNOEzC050HR38tQUwt60z/EV+azgbNAgyZ323Y4lY4=;
        fh=cgEM/BxkXf/0U0qAQ+319PU1KfvYJWHUDQwXaSg8WCw=;
        b=MRaOAwl4yFiH5mkfmBLyUTVb1Jh5lNffqTBPWSm0uGbzHhrspBupPJNdMeX0/Ytx6f
         Zx/Oq5CAFPhP1haZwPb35GKMG+iRY/aCSnGrZEnNMrHduElm25HgIvJsgur+HqYVD7Ge
         CQrriLVvyOzjWbWXG5EpdkQEKxi+I9Al0wvTNu7Ix3oyeMHCaC8NcUPT3xHiya44/G1I
         0WfYUamr8eHHhm4r4uxAZfeLOMn0zWNjKqZjxB3Unp5w1cG0UOYzh9Zq8Zrr+YD6FqUf
         FWP2m4g5/zoJhZWHcdZPhVfp2H5K0hXxp0/BDRa/BVF2QOrcUSaXphGLUA7YoRxk1DlU
         JHWQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775958056; x=1776562856; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNNOEzC050HR38tQUwt60z/EV+azgbNAgyZ323Y4lY4=;
        b=lUrONXqFwrHch3I+ZPrcg56po+lYkCOTuqLpqUCZHPOpQSapTOO7WiNb1dOiPqmT/7
         Cx/rxhrdJiRgrrZheVy/GqRyvyncD+mcWQ2Knn+Gox+J/7ym21BlKXzGJI6njC054xvD
         Fj/snsSucyZgQKpUmWrOFGOu6ETsr9WasbVqmQjHUO2sO/faJ7njI887kWA0u2kPFlSf
         kRB2eF/CV3resBSCRv0UibTkXYAwlu8cJfaz7hc/7MY16Wl5r42ZsFLLgXJe+Y9yNwoo
         n7m2yHl1gKRB9ta9jExvDYlCVZ61pXXD8L8yn/HiQzebd2LnI8uQhpYGJ14ns7SLexa4
         AdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775958056; x=1776562856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rNNOEzC050HR38tQUwt60z/EV+azgbNAgyZ323Y4lY4=;
        b=QG4k9nLMHuAjJ7xTjcRCXmJscPZn33tgu62hTJH9AHHSrXVXSAD20pTBSJ0bJ4QT86
         Pn3xxhEvUqj+pg4tC0SBPpGCQhMhODYGFO4a2+yOMqWXArgofHkRXmf2ad4f0UKPN1uo
         5V58z4EFjZ1SzW7DlAaIU5N5OdmV2PXV51JXr/yReXG2SNlam+dbJMIGcRqvGEMa7llW
         GouZnMO+NMmdc0HKu35E46/OZaojQ0MVSBY4sWJzZm9i7pC6jdNps4Ly8v2voKDhKWuH
         FoLfAL6GfPgy4tM05U2kOJXj5RMnVRiEIFG0jEo1zNofVcfe1u+2Weki9yITmtN5oZtZ
         1jWA==
X-Forwarded-Encrypted: i=1; AFNElJ//A0PO5PkiFDGMmSgnJWes9+5kjQ9V8kM8cz0U5V6mWL8pQ66Al7IXdrd/zswOKXQQrdO5q0vXXA==@kvack.org
X-Gm-Message-State: AOJu0YwZ7R0DbZ4WFqT8aZLE0sbHfA6tbaqbTmL8velTZBtxB6CLjJuQ
	uhCRJswC0XcC0dQX78NwuMheQKrquQIWXICNGfTghRQedvhvCHkvnj5Lfl2jmljLPK/RHb5K7ZX
	a3M/AJ22CginQ3y6RZuv9WkgnvPulk/I=
X-Gm-Gg: AeBDiev0Xxtq8bkjo9QkRDMiNnTfltgPRPia7gCzkCsJ7D1gW3EIN+hOKG8iRpe3D7Q
	fM0RKxL1ZRkDUVy3bpY/oqoF5Fp7x9Rro4dkXhqcF55uAdO5Rc8cObVnsFBZq24rRV5b3kqsoMd
	1AjrpvMzJpUuYV+B2GnIVLUT9r1WuZyeera/5oyvsPypWO2rQ3hdhKCxbf+O0z93vsIXbqvl2Uv
	MwiHadwGpofhtNEXA0UHAuOPXujhibwBN9PgEYw+L7b2nJSGxnEMEGCPtaB+8HM4dAjNNgkNaJv
	tHOSAHvo3omylUFuZfwm3BTMW7ZqNMAQZdmnIQ==
X-Received: by 2002:a05:6000:1847:b0:43d:3004:5fef with SMTP id
 ffacd0b85a97d-43d64274a7fmr12585642f8f.7.1775958055842; Sat, 11 Apr 2026
 18:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <acQrQYHJgqof0yx4@yjaykim-PowerEdge-T330>
In-Reply-To: <acQrQYHJgqof0yx4@yjaykim-PowerEdge-T330>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 11 Apr 2026 18:40:44 -0700
X-Gm-Features: AQROBzDroNuERyKabe8GygVxq5Z0i9E7OcIym5VR0h4i9PyTzTJ9gMs3fd__1QA
Message-ID: <CAKEwX=NnHxpQKp9qBg2=r_euyjgxw2nHXjbgof3MymHTgJmRAQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: YoungJun Park <youngjun.park@lge.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
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
X-Stat-Signature: m1h8ts8n1rrbimu45i5k1ztjqpgnk9pm
X-Rspamd-Queue-Id: A0CD1120009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775958057-395453
X-HE-Meta: U2FsdGVkX18ZnEEDc8c0kZ9UsUMIWaphb87Nz8rlNnDc2SQN9DKqkLUn9MCgj25oURygtyeq5Woaz8481z6kl2OF7me9XuLvjQN9r02+FRKMcRQ7itETm9WHiz6rLCaHuuxYHuVlx79uBWoLUHDhsEl0pJy/WzO3aouat7KrVZSNNNIMzGK0DCLXAvjdKd23cMzJ45pqyBMl5hkoKDvho6FUHkO7sTIRjuhviWzzCKuTvj42iJASNwPhBfyuI9ThJNl5GJwkD3nQSNGeilAdVmw5v/LB47ftKjLyyjPP7MPnw1k9qPXZnskvU8Je0MZMFGko+qPK6YJaTtybpdmraKDjs/C+aJ4Q8B4toPpxguxP1QZNtbKeiieGaWJWG9E9K/odMrcBKKFhu8N3TRXArWC5lOYf3lScfLjl67its+Qti9KYKt/PDr/hQSANqUrgUuGETcFQxBNpDZsvTSmqdGTHTcovWRyHEDNrWdmT0ptyNGBe77cXrdmd0qqdpdkLLIIrHPPvUOnA0MiT23tN6e8Mk85dFJ8nNDW2sMLVIlJK38Zl8Y4vhV5pinLMW+JoKLcY3ci5As0VRWPX7w2Nv3X1G6cEEk02NUNvAVxeZFJvyHp6HpOqO+uRJ30BZO3AQi8H3V4VC/U/HlEvtbvn8tY89A6E0x8zwKXc+Yos1owd9hL8BLFWZxA5KrNXNxzkeYPlO1YMINSOzEqeNrvGh/Ra6rDlUoYbgvTPO4yWvyNBcO3T+wbNjS0D1dbKazZ1BcWTT0jc4ZODPjO3aOw5Gsqo5Y2jLo307grIeLld4rBBTGyUKUsICkPr9jT1vgRbVE8L0PCCKw5f0OHhzszwTD+rIGZuT9tOGjIEoxaAgomG0bKD/Fovm4QmLkQfPwH325ar+rVnkITQj4SrlYaq0icoZqGJ8enx3rS5bRMHzjaasUw3fI/B6RD/tnQDBilRBCzUtmY1aPhXFAPsy7u
 VjzNlVKS
 4mogvt/uYogx8KuGJC4oZzQEbrZLiZpmYrcIczl8NOSbEuKfsaXDbvdIl0qRnlhY3CNgA6w55PjECFfDMjr6c722EUVBRfgDx8VCRBk4/mXVaR+KvBdg9N0qcfniOQ1lAVO/IXFyt7P+H9zhAiv4mnC5cQU8UgYlUTESqC2H33CJNWpc3GYCFQ+TdhCif2PCk2vtcoHQaS6hsoYtT15jHT41HOFIkCqcTXOdrjW/9Wf6YiM2BfYqYHEUY+1TEwfK+z4K2I7NsZDBKhkGANk54+oX0qAnJbvRG/LsbERlugUsoLn5hMsp8hBpYr39gs5Q0VfBzvBPbQOlDZXdd4ht3udxKcj7afqMdqtt9/haTT59cTRLuZqDVtfNr9A8x4ohIoQ9DlI+yTqIm01o1Hn9rPA0cZr9t+Z3chp0Me2rMhoNXks/hgYM1DTFv6pZlpVzJUrJU/BGVW8nrtB9s9nTOtyIzkjw8fjJiM5LnG3uBSmx2PcpQ0GGH3rUC9HRbW0wopFu0bC7yxsPoCdMZpLyP5JV6th/2J7ZCfr/4ZmcUbGjVU3lTeLF2tGsYYrEuG1MZEgiXGd2KNW8F7gzscLQUQXtfrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

n Wed, Mar 25, 2026 at 11:36=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Fri, Mar 20, 2026 at 12:27:14PM -0700, Nhat Pham wrote:
> >
> > This patch series is based on 6.19. There are a couple more
> > swap-related changes in mainline that I would need to coordinate
> > with, but I still want to send this out as an update for the
> > regressions reported by Kairui Song in [15]. It's probably easier
> > to just build this thing rather than dig through that series of
> > emails to get the fix patch :)
>
> Hi Nhat,
>
> I wanted to fully understand the patches before asking questions,
> but reviewing everything takes time, and I didn't want to miss the
> timing. So let me share some thoughts and ask about your direction.
>
> These are the perspectives I'm coming from:
>
> Pros:
> - The architecture is very clean.
> - Zero entries currently consume swap space, which can prevent
>   actual swap usage in some cases.

Yeah not just zero entries. Compressed entries consuming a static
space also makes no sense to me.

> - It resolves zswap's dependency on swap device size.
> - And so on.
>
> Cons:
> - An additional virtual allocation step is introduced per every swap.
> - not easy to merge (change swap infrastructure totally?)
>
> To address the cons, I think if we can demonstrate that the
> benefits always outweigh the costs, it could fully replace the
> existing mechanism. However, if this can be applied selectively,
> we get only the pros without the cons.
>
> 1. Modularization
>
> You removed CONFIG_* and went with a unified approach. I recall
> you were also considering a module-based structure at some point.
> What are your thoughts on that direction?
>

The CONFIG-based approach was a huge mess. It makes me not want to
look at the code, and I'm the author :)

> If we take that approach, we could extend the recent swap ops
> patchset (https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@re=
dhat.com/)
> as follows:
> - Make vswap a swap module
> - Have cluster allocation functions reside in swapops
> - Enable vswap through swapon

Hmmmmm.


>
> I think this could result in a similar structure. An additional
> benefit would be that it enables various configurations:
>
> - vswap + regular swap together
> - vswap only
> - And other combinations
>
> And merge is not that hard. it is not the total change of swap infra stru=
cture.
>
> But, swapoff fastness might disappear? it is not that critical as I think=
.

Yeah that's not critical. It's a cool beans optimization but nobody
does swapoff and expect fast ;)

(It is a lot cleaner tho but again not my first priority).

>
> 2. Flash-friendly swap integration (for my use case)
>
> I've been thinking about the flash-friendly swap concept that
> I mentioned before and recently proposed:
> (https://lore.kernel.org/linux-mm/aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330=
/)
>
> One of its core functions requires buffering RAM-swapped pages
> and writing them sequentially at an appropriate time -- not
> immediately, but in proper block-sized units, sequentially.
>
> This means allocated offsets must essentially be virtual, and
> physical offsets need to be managed separately at the actual
> write time.
>
> If we integrate this into the current vswap, we would either
> need vswap itself to handle the sequential writes (bypassing
> the physical device and receiving pages directly), or swapon
> a swap device and have vswap obtain physical offsets from it.
> But since those offsets cannot be used directly (due to
> buffering and sequential write requirements), they become
> virtual too, resulting in:
>
>   virtual -> virtual -> physical
>
> This triple indirection is not ideal.
>
> However, if the modularization from point 1 is achieved and
> vswap acts as a swap device itself, then we can cleanly
> establish a:
>
>   virtual -> physical

I read that thread sometimes ago. Some remarks:

1. I think Christoph has a point. Seems like some of your ideas ( are
broadly applicable to swap in general. Maybe fixing swap infra
generally would make a lot of sense?

2. Why do we need to do two virtual layers here? For example, If you
want to buffer multiple swap outs and turn them into a sequential
request, you can:

a. Allocate virtual swap space for them as you wish. They don't even
need to be sequential.

b. At swap_writeout() time, don't allocate physical swap space for
them right away. Instead, accumulate them into a buffer. You can add a
new virtual swap entry type to flag it if necessary.

c. Once that buffer reaches a certain size, you can now allocate
contiguous physical swap space for them. Then flush etc. You can flush
at swap_writeout() time, or use a dedicated threads etc.

Deduplication sounds like something that should live at a lower layer
- I was thinking about it for zswap/zsmalloc back then. I mean, I
assume you don't want content sharing across different swap media? :)
Something along the line of:

1. Maintain an content index for swapped out pages.

2. For the swap media that support deduplication, you'll need to add
some sort of reference count (more overhead ew).

3. Each time we swapped out, we can content-check to see if the same
piece of conent has been swapped out before. If so, set the vswap
backend to the physical location of the data, increment some sort of
reference count (perhaps we can use swap count) of the older entry,
and have the swap type point to it.

But have you considered the implications of sharing swap data like
this? I need to read the paper you cite - seems like a potential fun
read. But what happen when these two pages that share the content
belong to two different cgroups? How does the
charging/uncharging/charge transferring story work? That's one of the
things that made me pause when I wanted to implement deduplication for
zswap/zsmalloc. Zram does not charge memory towards cgroup, but zswap
does, so we'll need to handle this somehow, and at that point all the
complexity might no longer be worth it.

>
> relationship within it.
>
> I noticed you seem to be exploring collaboration with Kairui
> as well. I'm curious whether you have a compromise direction
> in mind, or if you plan to stick with the current approach.

I do have some ideas while discussing with Kairui. I'm still figuring
that part out though.

What I'm working on right now is tracing all the inherent overhead of
swap virtualization, regardless of the method we use.

>
> P.S. I definitely want to review the vswap code in detail
> when I get the time. great work and code.
>
> Thanks,
> Youngjun Park
>

