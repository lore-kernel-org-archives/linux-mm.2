Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC494C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 16:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4032E6B008C; Fri, 25 Sep 2026 12:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3796B0092; Fri, 25 Sep 2026 12:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B2A6B0093; Fri, 25 Sep 2026 12:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E60E56B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:54:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A969C06CF
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:54:40 +0000 (UTC)
X-FDA: 85252883520.04.081A855
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7804B4000A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:54:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nx8AV9F3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790355278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zB6y5YhkOLzSNaiUrMoC/Z2pJ3kqHY43Xibqpz7MDRs=;
	b=GoR4UY0wtslFGvoaJ/bxyJ/BAiC1qfDHSwA8ZxeRQcFuF/HPdrZzMvjd0by5zN6/EyjeXL
	Y0XK0QhZ2Oe8oL0D7h02Xi88zqte2aNyZcopdQRAlkma6AY8h8f0DEBkiZ2ZnWAh+IHKQo
	XTdkgcWeroOxQtfsgbi8L4eq+bsCGa4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nx8AV9F3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790355278;
	b=cr3O0dC62PaoI8qjRRMr1E00GirVRQOCLbF5S90cYtSEgQE1iaQErOH/Jm3Sd6ni9fI6hK
	ULzlzH+O8ZBcW2SS+vMW/oe4uR/zStAO4Z0WjyFHqBaKCxT6U021V6R+cCkjuYTy4Umu/3
	noqGE2FGORpa3GO6bqlTowgpA8DyT78=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843f22dcb8so886307f8f.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:54:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790355277; cv=none;
        d=google.com; s=arc-20260327;
        b=Tpd9IQnS8ObVycdZ7saqLoGzRPCZGcwlhV+ixXBYEybyRlNCGbJ7EQ16VpS4IsKZzR
         0X+9Dek4FvttCI04qqaNa3m3GhO1WHHQClOjgIiMbfbM464tJZQWje/JHvoBjIgnNfrA
         4+yIMDGtzfcdPbL2Xrd61KeDhXF3IffePvUETc0rW3KNTrc0t+I8ihYb9OpI0kh54cTH
         cfFkddNhGB9OGgZD0NBDoSY0gQStNJn0AqAtkvLMQd4uApP+eq1mjc9fv7Es+xC8078F
         +WjsOKkmptIv/Fu1AdyTQVVS6o+o4sGTukGToyAe2kdw7CmoFNH74XdmSnuwc9ylyMTS
         AK3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zB6y5YhkOLzSNaiUrMoC/Z2pJ3kqHY43Xibqpz7MDRs=;
        fh=zInnZ/I8MhzNAeTk+R/xa4mZGpakSvCF00dQYBopdqE=;
        b=VqIWLM+6bqgaOobxTGL5hOcb97ccKoDRkHmUgBSsjtZ5fkbS+1Ln7/Ix13xUGMQ/Oi
         Fd7hFUrbuAWrP7RQfsc6XzzQi78dn83Z3ajaH4unjJ9F4hSn0cBGS/J5wAvRCJ/M5g8/
         hqR6UDatuJ9HSi3QyNPZma3FCWzKOyPpjGgROvjb2n8toZvWSzzxpIpA/nEDx6k3Q+x6
         9plBLvnhOWzkUsZSfXGMcRWh+raQXvfeuG+BNX/7cAoa+Umx+UdjWmBb26q3P+LX61V1
         v3V6Q5b2UHtoeTOMYp0eXqw7GLL344WzClocQeLR58eLw1WhyzkZ5x26K6NrzroAI2Ki
         bzJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790355277; x=1790960077; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zB6y5YhkOLzSNaiUrMoC/Z2pJ3kqHY43Xibqpz7MDRs=;
        b=nx8AV9F3bSeZy+g762VRmE9b8zGArH5nPcWzYJ3YQKdEvYLlSyN7DMEhhbIseB4ghQ
         Rw0fKVkT1kuhkiD3LJPpKy1bYh1vjzZmmsse43pUw3BPuknAoHtAO50ZFYF0kevC5zkB
         1NIrYy25m4jeQrfx2P9m7ASsVkbXuTBArz9PDXsUrm+PsG8wlvfTTJKIcE4fglDNukfh
         h5JJi6fFj5K0y0zgYZuhS4uCLcq1gsFoHRzxuKl7t0qWG9aGfXEpHQi/EHmgOT+ziz89
         BG3hOD1wX/HSD12dJyOYEUnzePsZFPXAaaWbSELwOAD0h7iLIsuZVn4+qeWaH2e2mJHt
         NVFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790355277; x=1790960077;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zB6y5YhkOLzSNaiUrMoC/Z2pJ3kqHY43Xibqpz7MDRs=;
        b=RMn7kd7f9MQwTIR26E0SrrVW56Pk9YiXW3nNzCtu5BTtFU+rw3iXwIbwdqjLfqWzpe
         QiHrG3SOdNsFf/j63F5dOHClJG9yG7mZJ6yh9UNJGXZEl1BzHyncWncMTEH2F53oicvQ
         A0uFXTnWsURp3TqnBH5NFfijaWE2W0QrDuI82+W9+CT1kjQYeBLrl/bNNFshNUrUecao
         C+WVKR7Pib3Kp8vEI7DKfGiDJtZwUrEVVBOBZxy/RselcNomiSnT+opbcc3sKs6Y/Bn6
         WB1hFYT9Ay0C9kqVTl7uYzrpRvFK14hz/ddHJMnY/X9XiMw5MMmEnSidqbKsSKjKjNvn
         SNsA==
X-Forwarded-Encrypted: i=1; AKwUvBzxNDDcUeClmqp8QitAOd1PzYtafYkYhEyUlwqUHze0+xhI+SwTlI7slcaFRdkkGyvOeKLQe9yZrA==@kvack.org
X-Gm-Message-State: AFuF++llgBdoTHekLhrBQCcUPlwlLA+1mqrTUjYjgSbWJtJth8L5Ifye
	/8Co3bDrlr9FtAUfrlPDX2L8GL+JpH9Bby8w+XeoWDrM0PyhGYDAQ0JkpadYJcuYtwyhLGCNDf7
	CehceSaspNxxtX0SoY6dZQZ2q3IUJJ9Y=
X-Gm-Gg: AYBFou38BYZRmWiM5fvaNkWQCaMfh7Y/wTscfvrwCd18edaLYer4vnqvrVk7hK+bfSk
	2ZfsEHYqAEnBq0Ovq+ch7T065m5ZRxLnfPfdd3E2PzqymU67OfKRBvI4uv8ktoUALznByzIIEZ7
	w0WqgCEk7XVikzCICMwHAczZLONhfA0FKKR9jVszqNdn9cy2DIui59P/8GgfX4p/p1sstpCoX58
	ynY24XJTE+WR3lyIcjxaKak0RH7RvA0JM3PF+k75hXxRTghm/i+XUo8TkoLCCe0V+VjRWoCYlPK
	W68UaVZ7OmP7kJzwTgiF+LUqjUuflvkuHTUN3ycpTKxilhbdB+DEOTBfNTsc8eOWz69djMNP7Vd
	D7TsccwgnV4M=
X-Received: by 2002:a05:6000:2c0e:b0:488:8546:d0b2 with SMTP id
 ffacd0b85a97d-4888546d0e7mr166478f8f.51.1790355276640; Fri, 25 Sep 2026
 09:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora> <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com> <arUcil9kxUPiymXI@KASONG-MC4>
In-Reply-To: <arUcil9kxUPiymXI@KASONG-MC4>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 25 Sep 2026 09:54:25 -0700
X-Gm-Features: AclHuK-Pj8MGTN6slhH4ZC6bRNscyhuI_rUSwJmyxZ_HRRIbsrEA4QXnbtSmaac
Message-ID: <CAKEwX=PXRB35bUL1=O4Bgx9A7aD4izZZ3dcEcCuMBBhBrMv7fg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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
X-Stat-Signature: egxa6ss4mbgy683jmpqu98psxfwfurm3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7804B4000A
X-HE-Tag: 1790355278-900954
X-HE-Meta: U2FsdGVkX1+PoG4mfOLsJ/+8EIroQMNJlxNniZqehsl10PPUlEnyq1SZcfiHSelI87XFlDdU8rmI1m0IDECDoavoJoYxb3y+HJRSZ528B6WetT9qNrzSKn+29NcGbYDe6V/OijhNXGV1JZdKuK4iv4My8ibQmQ0A19eSevfj8GDiYf4h8SiWUYMwLqOVb3iBiQntbIwzF3gWnPGeniIt3+IX0bLiSC8CnY7zkkhxV0NXkNO4tesVmSb/qC0aIpPuwCRSmJAd8+V5XBmHlAFV862iheHw/DA53YR3yQjybXG9rjIMquPSR43kvi6JCBNFpFxP27Xtyoi4//BJ3BFdsa2E8XNASA1TC/jUjlQTcCJyFHKX1RIPAP+7BLnq3pnTT+3Hipyw2zyd/qgAFlEKLYzrPGSQuZIyOfvCAGcrK3Koa5WpazHZq0pnI/oKAFAHUViI5CqKYEuoG29YUyOKDpg4WVCVJrozk/YeTGT5YUnX5cUI0N0Ec/YMl/3uOowF1HGLPtqEegXWS0xRSAF1fNQJqq9rxbTrH0RGREho5N8RMN8EU0PTqiM+EzrfGsSB8K5Pp0dL/ivdCuzJpI38ikjskQ0YIy2i0hC0odMKbzXDSz/MsB2BL43qw/c7lkl+3iAZpwreQ7DK2gOdHx2nqjrwyct50KSS3zsOMJ3s80TCOCTq/aAQX+r17rhgOU3nI7lR7NgORvJ0b2Alkce/uMghbhtSt/NEVdU6orPzaglRogfo+rywvUEfkzwx24zFg6uJPGDFpGv66jNsxIROJC1Kiy17jzEvdXEQXnmvKGnH1G2hr+qFyLd58jq2C1YH/5Ie3SX7kUuVlGlcbkPGCCQ4y6U1OhK48Flc0u4vXhPK7PNm2oFHtyonozh7txCdY8e8do97hsPgS9o6XJ6Lx9o+0qVyuHi0bnvMMid9INj8smDd9TX5aooJWbYqevVWIUG02BLMg3iOk1PLu3b
 QqNpkjNU
 71kwW3HvOu9CpOQkPyMaDyN5yqrhbtUDPfd12CPNaxexXfq66x4wi/yAUVO/ZOQ3p4Ybod3eOTsmg4L01gIGjgGnCPjNdLKkYTealN9Pqx4V5HYiWbZLNloolyflPY8KBeyUHOG57fRPRwI2eiyVyJWRpzp4y14bTg8Pc/VUhofaiSOhnl3yN+Ar/PrKWF8G+kqwBs049BoEPL+kQHKBUHA4e/QvHQ5T1WzM9ucqpDcfb+r/Itm95YN8aa3dmdeEWrjgx1sLM/ULee1rGgUHUEhA18E7mzwah0bAHVlUDHhmn0iK4o6A/Z35On1GKJGkQkA7lJP98YQ9p9LcEJULs1z+xHI7XF6lLcP2WWEZ24e+mLSwbTXqeYwx3AWYeuaDb+6g7EYVm8re+1gmAWxUPVfQsOLg3TRJIKLt1kEC5mVwu8qbMgtpcbYLANhXk+nZbJePZv/ZmOy+BMGlD+TrYAH0O8agTm7rVeLUsz6sDmjnphfZUM/NaMgnSB+CHa3HqVGqHFLoPfhy3TG3eowrng094DVjhLAtmTXrytWeB3khQ7W0MdN3+ORIXYPMWYtw2I9MGuxDMN1lC9AHMl7KnDBaO9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 6:15=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Sep 22, 2026 at 09:44:37PM +0100, Chris Li wrote:
> > It seems you are talking about a different topic: the vswap charging is=
sue.
> > There is a golden rule that we should follow: don't break existing
> > users. At least with the same persistence, this rule should apply
> > universally.
> > In the swap tiers discussion, the UAPI was such a big deal that we
> > couldn't implement new UAPI. On the other hand here we argue for
> > liberally changing user-space visible behavior.
> >
> > BTW, I already shared that changing swap counter charging will break
> > our and others' existing deployments.
>
> Hi all

Hi Kairui,

Thank you for your thoughtful response! Lots of food for thought for me :)


>
> As I read the threads and try to clean up the requirement, just
> realized that I forgot and ignored something previously. I think I can
> share a few things here.
>
> I also see that Rik mentioning that:
>
> > It adds up anonymous, file, accounted slab, and
> > (after compression) zswap memory use for a cgroup,
> > and can be limited with all the usual cgroup
> > limits.
>
> That's very true, and that's also the one reason we can't
> migrate some workload to zswap easily (at least yet) :D
> See below.
>
> The discussion on this can be saw two years before (I know
> things are different for V2, so see below):
> https://lore.kernel.org/linux-mm/CAMgjq7AYA91f4g-bknUZOMg6hApTD-X5LqjcTBN=
2u-Lu8pjs+w@mail.gmail.com/
>
> An minor update for that, memsw in V1 serves pretty well (we also
> modded that part and would try push to upstream if doable), and as
> memsw is missing in V2, we can still workaround that using
> memory.current and memory.swap.current. BUt missing the offloaded
> part in memory.swap seems a problem.
>
> First a little bit off topic, I'll be really happy if we can make
> both compressed memory and swap as separate counters (I even once
> tried to implement a zpool accounting to account compressed memory
> in some unified way, but, well, zpool got killed before I post
> that :P), or at least a way to do that, e.g. something like nokmem.
> Due to our real usage:
>
> With compressed memory staying in a separate counter (which
> we manged to do that with ZRAM) the memory.current + memory.swap
> (or, memsw for cgv1) could be the exactly planned or sold size of a
> container, the scheduler (e.g. from k8s level) is fully aware of
> the packing rate of a host based on this reading. and can make
> scheduling decisions based on that. And can control it by
> adjusting the limit two combined.
>
> But with compression as a fixed part in memory.current, first the
> compression rate is totally uncontrollable, both the user and us
> will be fully *unaware* of how much memory they can *actually* use,
> that makes the planning really awkward. memory.max stops being the
> bound of what we planned or sold, anything compressed lets the raw
> footprint go past it by however much the compression ratio happens
> to give, so what we oversold is bounded by the workload's data and
> not by anything we configure. We can substract the zswap reading
> though with adaption, however it's hard to change the performance,
> OOM behavior or reclaim behavior:
>
> As you may considering compression is trading CPU time with memory,
> then two things here: the user could use more memory than we expected
> by burning the CPU. And, some users has a leaking application, the
> application could goes super slow or experiencing high CPU usage due
> to memory being compressed. They really just want to get OOM killed
> in time when ever the application leaks beyound a threshold (and
> yes that is a real and actually practical model for many applications).
> And, we can't simply disable memory compression for them.
>
> In many cases we just want a best effort compression to make space
> for low priority tasks, and do not want ordinary containers to use
> compression at the cost of lose of performance. While still has
> a fixed limit as usual. So simply disable memory compression is also
> not the plan, we do need compression to make place for other
> applications, we just don't want their real raw usage to exceed
> memory.max, and we can dynamically adjust memory.swap.max to
> control the oversold part, compression or physical.
>
> And this is not about residency, so memory.min/low don't help here:
> it's about overselling, and about not leaving a container thrashing in
> compress/decompress loops instead of being killed.
>
> And if the memory compression is really fully transparent (not
> doable by software), yeah, that's great as there is nothing to do
> with reclaim.  But, for now, we have to go through page fault / folio
> allocation / map it again. So For example, if we already have
> memory.max =3D=3D memory.current or under high pressure, then now
> doing any read from the compressed part would need to some
> require further eviction first to make place for the decompressed
> new data, this is not like any kind of "real" memory, something
> feels not right here.
>
> Another thing is that I think we has been assuming that physical
> swap is slower than compressed memory, which is not always true either.
> They all need to be read through page fault, the page fault could
> be the real blocker here rather than IO or de-compression.
>
> I also want to separate two things that I think got bundled together
> here: not requiring a physical slot behind a compressed entry, and not
> charging the raw size to the swap counter. The first one is great, yeah,
> and it's exactly the part we want, it's what makes compression usable
> without provisioning disk. The second one is a policy change, maybe it's
> not needed for the first stage, charging a cgroup for the
> memories it has offloaded doesn't require any slot to exist behind them.
> If someone wants to run memory compression with no disk at all,
> memory.swap.max defaults to max, so that still works fine, right?
>
> And I'm not saying "keep everything as it is forever": it is that the
> raw offloaded size (the entries, whatever the backing ends up being)
> should stays accounted and enforceable, and that anything which wants
> to describe physical storage gets its own counter.
>
> And I'm not asking the compression layer to have an opinion on how
> much compression or ratio is too much, just think we need a sane limit
> for container schedulers to sets on top of it.
>
> And "it's opt-in so nobody breaks" doesn't really hold for us: we do
> want generic compression solution, that's the whole point, so we would
> be turning the knob on and losing the counter at the same time. If we
> want one generic solution for memory compression, this is not opt-in.
>
> And if we check again, currently, with upstream kernel,
> using ZRAM, we have:
>
> memory.max: control the raw usage of application.
> memory.swap.current/max: controls the offloaded size/limit of a applicati=
on.
> With (memory.max + memory.swap.max) <=3D planned usage (and this is memsw=
).
>
> We can keep the compressed part in memory.current of course, as already
> did in upstream with ZSWAP, and things can be further adapted, we
> still have:
>
> memory.max: control the real usage of application.
> memory.swap.current/max: controls the offloaded size/limit of a applicati=
on.
> With (memory.max - <compress memory> + memory.swap.max) <=3D planned usag=
e.
>
> Things are not too crazy, but if we lose the compressed raw size in
> memory.swap, things seem to be out of control: the raw footprint can go
> past memory.max by whatever the compression ratio happens to give, and
> nothing bounds it in raw terms, memory.zswap.max is in compressed bytes
> and zero-filled entries are not covered by anything. I can't see a very
> clean offloading model for us here.  And we note, use use both kind
> of deployments, pure compression and hybrid writeback.


Thanks for explaining your perspective!

>
> Just for reference. Maybe a seperate counter, tiering, is a better idea
> than changing the swap counter?

I think memory.swap.* is never meant to be used as the "offloaded
footprint". It is incidentally correct, because of architectural
limitations: zswap/swap cache/zero page usage leads to real
consumption of real resources (physical swapfile).

But I understand your concerns regarding the missing observability of
the "logical" footprint (i.e the "offloaded size"), and how that would
hamper legitimate use cases.

How about a vswap counter that tracks the vswap usage? That would
provide the "logical" view. Userspace can then monitor and act based
on it.

I think that should cover both of the situations that you (and
Johannes in [1]) pointed out:

(1): With memory.current and this vswap counter, you can kill any
workloads that violate the level of overcommitting that you set out.

(2): For us, we can use memory.swap.* counter to provide isolation to
the physical swap space, which is a real, static resource that can be
hogged.

There will unfortunately be changes in userspace programs/scripts that
is required. It's unavoidable. We're adding a new behavior. It's the
whole point of this line of work. But I think as long as we provide a)
a way for userspace to index on (the param which tells you if vswap is
enabled or not) and b) enough userspace machinery to achieve most
common use cases, it should be good.

Let me know what you think. I look forward to hearing from you :)

[1]: https://lore.kernel.org/all/araWKyJ5MENBwXCL@cmpxchg.org/

