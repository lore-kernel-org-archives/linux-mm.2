Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D76C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F796B0098; Tue, 22 Sep 2026 13:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7565B6B009B; Tue, 22 Sep 2026 13:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646A26B00AF; Tue, 22 Sep 2026 13:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA386B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:16:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE60C1605E0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:16:39 +0000 (UTC)
X-FDA: 85242052518.04.34AD18D
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9FEFA140016
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:16:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Lt+E/vsr";
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.204 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJkQfQB3a9RKvj8bM5CBOZYh4CkWNCRPcTCANcgJj3I=;
	b=sXL2K0II6oKjSoRJctP+YIAX2pVoK1sMjBntk4E6yBdxGxeFZCXtsdtpo02paC2yTgEPN1
	4Y/abWVRqLccRW91IkcdOicB8sz2ycFVOFtMpleNAawOAmRWDmcVZo0aKcz456GRUp8OS1
	NipPm2W4bM60tebrfF9mTUtPmPdJtFA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Lt+E/vsr";
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.204 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097397;
	b=FtfRIHT9UKNfi+J712AG8P3oqCGAGYVwkMRMHOal/c2Ghd1llj29zxXw56hIxI1a71XJtW
	jeTo65szt1srIsd2Apxc24tiRI8MtLiphLE12r+6RBxeBRaodhDDLy/PWke5/PXJarRE6Q
	CdgYtODjZDNoYo1zI7DLjy6DGFYxznM=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109f067fso12783485a.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790097397; x=1790702197; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CJkQfQB3a9RKvj8bM5CBOZYh4CkWNCRPcTCANcgJj3I=;
        b=Lt+E/vsrehb+x2TAZgFEKv+tnRURg4CyPh7h2KEHcJPVEggdusj1YT2vNDdMOLRRgR
         7Ca9tu9f7ZwOzuCO9VEfWZrSrhZ8MWmqMnDg370+jTppOB0X79pVltBR10J18miC6679
         cDk0UCCxL//KPHQtgEC0Hmrg/ZEwSjl+PpzNwTknXaltJr6brEJhmSzUR84QOdneQwOw
         DY7+FTb20Q0Kf5ub9DqdVH415e9yqwEMPBnRoSaKazO2K7eVxt4FakY/GUVU1b801H5u
         q8b+FsAo/1zpN/M7dhHwYZhEqZOKEaAFrqPdr94+PwMo1spF2aZ0lkWcrJmA6Ph+JgO+
         YSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790097397; x=1790702197;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CJkQfQB3a9RKvj8bM5CBOZYh4CkWNCRPcTCANcgJj3I=;
        b=zrPFkhMzfu+vfQLHwj02qrmjmAAmg4G2Ufw2BQ57uitvuQZTtHAz4/ElRqwuFRwgPR
         50zrI8ap0XCSs0wIfYrgQEixXFjw1XNssdDpJ5ksyxdVrCAlxQUA7qnL/gONhT72pFwQ
         j7nTARDYwoBXrLFRS4AKuzDPemTOX7UtTBzs/Mz6SZYL71YA1vYUotuLXj1fyiC+Fu1i
         ST0AGR2RbkWgeQ6e7dswPTSB6yoPZp6ewP8jC6VybM3ck2e981lLv0NyFIjfP6kItkVR
         wYQQMufZLXWvsYZTCnZIfce5rNSWFv03UN9wSA82LdfjxYMwJBf3o6wDdsJwxzytsH0C
         YoKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwudqD24tXUCd5JI9Sb08YVU5rLmaQH5xJoISrYfIHAODlGe9t4K1THBf1bSIehtUbvlpheQu13xA==@kvack.org
X-Gm-Message-State: AFuF++lG5KOlUMmG6kxRGx1g9Ba0zUZOOg6gURQ8a4urhSoM0wexCxYa
	gSxO7dvlMaPf9NiLikLZdHUkeOSzEq7iLLOWaFa3g/9CnEBUZkqaFfiTFXHRYeRAWaQ=
X-Gm-Gg: AYBFou273mxfInbFEOrDgQmAD/hvzxxCTxv9/SH6slSmV5fqjVfDWztCvReopGfEZxz
	Yis5i9IwXbkN/2wTC6R5QhZm511Oxtw+ALMunbZX+SU4aQ2hG7FBhzIMlfMVaxAMfkB4SaR6RUR
	Tr4Awu6xwQX/ppoG4igyM/jEuCz12vGbMyKqAuF0TxFi4HgFlNWekiAZt4FTMOmvGqws2OV14qK
	y7WVPrbUc+QC5VCARNsxwd5mliF94yWSIrUbRuRoG4zTnDuzzwB0AoSr8AoD3hs0/K3F5Lz/8qG
	IxQWm3NODEAtOJAdxowbVg8rCLPiBk/aqdefueeo8WDyPrsEckoIYGx3nwb9VuEk+ZtUSkDSvWu
	6GfzYlmcFn1QkSKbAsuAq67HouF2V509CTRrjhN2IFvMZh6e8o51J5m55Jk6ftotUhtsSKB0c6+
	4/b9FmnV/9DFV7Er04yUKHDAO1psC/hRJh4rJO+cNQSQuJ7ZJdaYdyOpkPfHiAXHagjg==
X-Received: by 2002:a05:620a:2993:b0:93b:c22a:e98a with SMTP id af79cd13be357-93c2509e62cmr13040785a.2.1790097393108;
        Tue, 22 Sep 2026 10:16:33 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24756838sm24592485a.1.2026.09.22.10.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:16:32 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:16:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, Baoquan He <baoquan.he@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arK350ZCTJpVtctk@cmpxchg.org>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
X-Stat-Signature: fkonpytqckk9461idkprkqut99j6ii5b
X-Rspamd-Queue-Id: 9FEFA140016
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790097397-399024
X-HE-Meta: U2FsdGVkX19pGwiBDVxhkPdWem2vIGY6rWxrBMNaUdRAJ8J9ouPC5l2AQnABENVBOwZqQOkSa0MikIYZfZPsFCVJA/yo0tvb/85S3/7sg4fghhtkUZ4OL8la2/QrdLrAnjFM7Y3V3Ox6Z7SfmSVCaGs+SH77UOawdpToRxqDScsx3zUzjKc6oWMdbRySR3bjUCCzrbMp61aZJoQg/rdOTbjKxr3x8vHX4oknL6EIKNOvVQFvQloNue+EhQ4uQ1IecvlZRA3PJu/zJB1q0PFxuQmxEHWQ/783dXZGeFiGmbsClWrVmiz4IfWzwZ9/JiExL106Qna1DadEzpIlmEXUXAYEkJY03NHiZ9IWyzTsfnNjDI84pTfOcBJrQ8eqfAy7TZEGoLObiUGzlRQyE9aeweFPwfXiVYHe3LqqsTTewvBT1bgzymr+cog3mGJABBX0YifyZzxMCB9LS61mOPDIMsgZgL6PBQCSiF9RNpNJKUNKvRNLRF0lX9hjtbbhepPf6UWW5EnO3NKJ/7JWkPh4Bn25aOjNpRMY94ZtK7mdmhL6pds35M9V8IXeUoTQzM8xvweISti11HOYZEQHwcVOZ8+5pKCyXy40/4wLa4lZPTtDr8p5vMe94J3/rHKF9e24SFb3wtC2+19Ada1GwDsUP53+xLMXq/ZqDOtGrIWO1g1EmAmdafZ9yUDOh7d/0woolJ19YQkj7Yb/dgvxKaqOC1cN0OTT5zMkZr5Wzfw17YtyNWs1lO1Qk4oovnoZcBsn7vIJC3NrIhg7R+ExHyPRAckM8M7EgfsqRVChMAWBPdGpoKZA9vEKDoHmd7ibHM53B6mC4Uxv4wIo11WGC1urGZSyAik69a7TfS8BTTWcqrXEcBqUTzkYf+5OKbFc4Gpgc6MXb9VcdeGSQAw+hOFLrdAT9Ad0aAmGpxMat6jxIpcLxxOSycflHRHkSk6LG/23i3x7pj/ALWJn5FIiOxE
 bMN/Owtj
 1oNcc4TbcE7cQO2GFt6dwdWj5xZdW+4xShVb7sxulWvDevGDCKLw7qENCtWex1IaCzO8sZ1EikC96jx0i9PTlTiJIqKD6zooSH4S42WJ2Vk1ipXcm3q+1Qrq09VyCO3YP1ggx2n886EAAtbblpDl3M4llo3qrruDPN+xBoNSzZsufj8fxFsK7/vHeJEV803iJYWscx53gdVqLT+vgwqlV79j/hDzN9/zWksUSgKG2LHFVCU4RjaNKqWVYuVylVPkcdO2hj2K3P2Sj0WOTavwWci8mO7oUruQ0JbI6+UeY08HJouWR1BrSyN1fynY7m3RFuOXw6HIouBEDF3tRB+vvRfreHBAujNvX+1TKSqBpX+kMuhjkwd9IeepSsQSfC9IVqTq7SszGpI+c7Oxcm+6HEp9hKB8ZYULiOg/m7s3VCilQ5OO3FxMnin9ijSIO7vHd7X39mWSh1Wspm/kWuAyvg5dGhcrhtmDoMCo5SoTdpRUKY5BelkYRf157WR0Xcu0gUzAaUOCbL8v2UTWpPrW62tfp92tXUsXF5STDGA7rfaLA25btFjRnej+sRnV0pCk/bxqawmzEIq3BOs613a8g0EN63Qsq7xzwvgc7fTiHk84nC6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 09:02:28AM -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 6:08 AM Gregory Price <gourry@gourry.net> wrote:
> >
> > On Sat, Sep 19, 2026 at 03:45:03AM -0500, Chris Li wrote:
> > >
> > > I found this new concept of "compression space" very confusing to me.
> > > Can you explain the swap behavior and problem using only normal memory
> > > usage reduction and latency without introducing a new term or new
> > > metrics?
> > >
> > > The normal user doesn't even know what compression space is, let alone
> > > what makes it transparent.
> > >
> >
> > Sure they do - it's the amount of memory consumed by compressed data,
> > including the metadata associated with it.
> >
> > converting Johannes statement to diagram:
> >
> > >> Compression space is not a separate resource. It's page tables,
> > >> backing pages, and swap descriptors. It's just MEMORY.
> >
> >                           Page Data (PD)
> >   [page tables][                uncompressed page                  ]
> >
> >
> >                         Compressed Data (CD)
> >   [      recovered space     ][pte][swap meta data][compressed page]
> >                               |                                    |
> >                               |---------compression space----------|
> >
> >
> >                         Memory Pre-Compression
> >  |[  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ]|
> >
> >
> >                         Memory Post-Compression
> >  |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
> >    ^----------------------------^
> >          Compression Space
> 
> Thanks for the explanation. So the compression space is just the
> actual data store backing the zswap/xswap/zram.

It's actually the pre-compression side I was referring to. The address
space that vswap/xswap map.

If you artificially hard limit this *address space*, you are making
assumptions about (1) compression ratio and (2) how much non-residency
the workload can tolerate. You might well get real workloads hitting
that limit while you'd still have the ability to store more.

Add pressure-driven writeback in the mix, and now even compression
ratio assumptions are not useful: The stuff in zswap compresses a
certain way and the stuff that was written back is out of memory
completely.

Yet it's all mapped by that same address space.

How could anyone pick an informed size limit for this space?

How many setups hard-limit the process virtual address space to 2xRAM?
Nobody. They limit the physical memory required to back it. That's the
only thing that actually matters.

> > It's actually really confusing to represent this space as a traditional
> > swap device - built on the assumption of a pre-defined size limit - when
> > that size limit has already been defined (the memory itself).
> 
> First of all, the traditional swap counter has a very well-defined
> meaning. It is the size of the memory that, when accessed, requires a
> page fault.

That's 100% wrong.

First of all, it wouldn't work because you can still take page faults
on the filesystem.

Second, this is absolutely not their intended purpose. They are to
control access to a physically limited swapfile on disk. Because it is
a discrete, separate resource from memory. That's the whole reason why
memory and swap controls were split in cgroup2. I designed this.

What you're talking about is residency guarantees. This is what
memory.min and memory.low are for.

