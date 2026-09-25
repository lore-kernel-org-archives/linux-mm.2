Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73B7C9832A
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 21:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC626B0088; Fri, 25 Sep 2026 17:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DDB6B008A; Fri, 25 Sep 2026 17:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A766B008C; Fri, 25 Sep 2026 17:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A72EE6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 17:53:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0792F1A0736
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:53:33 +0000 (UTC)
X-FDA: 85253636706.05.61B6EED
Received: from mail-qk2-f40.google.com (mail-qk2-f40.google.com [74.125.230.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id DFDFDA0002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:53:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=AR0Io460;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.232 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790373211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJzCvfxmeFB1cEl2za6t85fQGoyj6ML9WfPxvW5p3nM=;
	b=YGbSYtCXyS+AuunwV/fBTirMVpsfIcjZ8U7vfu1p1JQg7DaIPmb8KFJQkl1j03GjtnkE0k
	olrKq8/DXt3WKyUwOU+djZtoJOwBXJlY6AQlovExuoDWclgs9jqrt6o6DQHJqz6dSlQwFJ
	TwIN1VXncXtV6V2LreDNSM0RjlysFfQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=AR0Io460;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.232 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790373211;
	b=AYOl6PvI9doa7oPS+BHc2a94ctrgx+JN+iso9zmEwl/z5c/Zl3SddYdLqITTbgkjxVHwrx
	jLYrlg6BtY9XAuHDwZJBddnDPJMPRjY7M6ovlFt3UtRvUdeSbupGAKJs0FEopI6M5zLnEk
	Gxbb5MgT0WtEwf4BahO4Ro0rB2Z93Ao=
Received: by mail-qk2-f40.google.com with SMTP id af79cd13be357-93c5a837375so73285a.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790373210; x=1790978010; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TJzCvfxmeFB1cEl2za6t85fQGoyj6ML9WfPxvW5p3nM=;
        b=AR0Io460EfSJyxg3zkAvhGtDD+XkNjnkCzoxIs2TJUZU2EiBzsmlfj3ybC4j8DqLfj
         RXX7P5/tQgmNNkwRPTRsMrK/sN1haP5sGJHoaQuKuIelfPXdmvQy/quV6Cd3n3IIOy+T
         wbpzuwn/m8v2iLw5tde5tGgyMURNBkj7kcTfFlUzRGp31N58d3hpfANAiwb+sFsOASg9
         4PdtR1yL4E2YGP+L39ACWLE+g2rlJrapaf4sagHZIPD+3d11r99v206uDi70qBF0UmPU
         Mgy0Ulzhb2cTqGyMZ3PERGDV9ALMNMcKk9B2rvxv3xT8O0vATVIPwzDk0f2jXZPGsizI
         ZapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790373210; x=1790978010;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TJzCvfxmeFB1cEl2za6t85fQGoyj6ML9WfPxvW5p3nM=;
        b=OnDdO3P4RAY1IXYBcE4N3EahSPMG5YbCRcdxc2phbundJaGGbLLM9DM57B8GFFEc+6
         ZTcb9U7yEV/iDW83LVMiEsi3hMwuKK4FBgLQb2nrBRI/O8kgPr4+gj6avES/ToLkmBCL
         pTjB/9bc94fzE2kJ1oUhDDOk4GENNOx5kNX3g2m4jxi+B3BnYUwDm7UluNNse2lLjMC3
         xX94VzLzMqQ1UFGf15TdupSUET1oVh2PTtZQHtneYAd6eedvkgLIAw5OBZAQlw8vR64n
         fjLqFHCpEX8Wgja4ecvC4hLPb/S1nIuIX0VoJV8Cn/NwohOhlV7hxdogJgLrPpZvXQvw
         H9lw==
X-Forwarded-Encrypted: i=1; AKwUvBzaqMISptTykPkPVu8e3IIWiKGy0p7VoHItx9H4L/xwBVpHHop/QJQD/uQlk7GmesBaVed73PvfqQ==@kvack.org
X-Gm-Message-State: AFuF++mL9A0FJeoe65p+kHvLpND8w3htJWIWCTHVQfv3c/n4P8EgUAyk
	zWYJ+V7zIv6HIV1u+QFPNdpIL8X4kguJS/TLgR484VpcFNjvSeBTCeXMGKD17I6etAo=
X-Gm-Gg: AYBFou2ur82i8sQlbGEmXHtkcXcg+3RwcKA+oNqN21aJtoLd2RRu0CAFzWs+fCgmH+Q
	5ElYX8H6dkmA7RN4nZ3utvEpIGM1HoUxGJF5aml5JvLruzTXJQAEIE0C4uv9DI0f0VAN9JSzLbh
	ph66Rd0Wa3A0lg6w5nRAIHDR8GrXrdj6zRNOciSEpQcxE7XpKnKOYDsYLNNB2q5um1wBt3Q5pFH
	eY0xsfQ9MnhX7bOMAqsS4+OAvBPn3mL+FuafXZC7I/2N75qsaWWRvuL9J6+k7QtrK8CujxcFchL
	4zND0PI2RvSFRy0McjkJho1pQmtJmNSLE8KB52xXwp/6UnjtUH3KeokJ/B52PHeExAD9wyukbPu
	3MXc17wLGHwRDvl7gPR+DPPYrTzzavKxBvbh2fLUwNYlZ6SKAPbe0nm2kB2C/bmPQo0slcSHh/g
	4j1Ic7ge0u/3wLErlRa8bfO8nMlNyxa6hLulS4WuIdhZ98I5KqOoDHlaEGpB6fEEGBZyCp0KDRO
	K0C4hxy
X-Received: by 2002:a05:620a:4398:b0:936:cd75:8f91 with SMTP id af79cd13be357-93c43c44d65mr740709185a.12.1790373209889;
        Fri, 25 Sep 2026 14:53:29 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44653c8bsm277775485a.3.2026.09.25.14.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 14:53:28 -0700 (PDT)
Date: Fri, 25 Sep 2026 17:53:24 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Gregory Price <gourry@gourry.net>
Cc: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbtVBEKm5IJTH2j@cmpxchg.org>
References: <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araKDOz5bce52oyg@gourry-fedora-PF4VCD3F>
 <arbJ1LTzc7H4GL27@KASONG-MC4>
 <arbgZ1OGndQAsXJc@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arbgZ1OGndQAsXJc@gourry-fedora-PF4VCD3F>
X-Stat-Signature: cwbxmf1zji7j45yjx78obw4usb7bbsnu
X-Rspamd-Queue-Id: DFDFDA0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790373210-530465
X-HE-Meta: U2FsdGVkX1/jUV/2sRuzb8lthaKNtVn89sQCZQswQZ6OMlkVdtNyjq5eX66uvqT6zA+Q/qjc735RCym70ay3ZPiBA2xo45aQZaNgq71JOnBnMXXSZYPbHVlDeICGgGvxbfzJ6YKkBBxGj7rkpXmDeCGrTPMIVWVmts3E1OsC855dchnDljYAwkUd9hlJPo3QtSrwV67e7t4S+jWszmfhLuO8+k/42L1Bb3axh6ahsgJ8Ei7p38nem7p3QC0RmyB1oMrzz3yxINVLk6xbi69e8pG6wzAK1FS/CmafcJrI3W5VfcY50iuPCjsWUCoI7kS7JAIsolt8mJanmla3ZqLlBbX77wFTwpiZZCP1Rvx/vVIIGWqHExED1nhusK+LFFIJXo/tVLKl9GyKPkm98690MECpsNYAw9+UjyVKbALRTqLR/Dcs1TmYytWYxjUfkQQT8WMz5tqEajk4AIzcfTIrCpitYIwGf+Lx4jtuLhvFesUsaqauczwbgA5W7Wc7TdFtx5e25pnyXBdoymh50coDIOYmxnx+r1VufdSmNPz6sDbM00+TPt45QOkzVIVl/hplCA2izmDNJfgsYeKVsMJu5vGSA90/ZdcyGyUQ9Bl96/g7djKc2Gz9b04sYhiK7YTutkQVdbmO2UOoOpcuatCNAyFF7FcMVi6SmHfKpuBS8L8VQowATXufLRYpYmmyU1+xNcueFAKxhBm+e03Qrn8ZAjzASwuevAFA56jXU9pBQWgqHMxUDApUjKnUVowrRiSO2mq16RLygxw7M0D2Z3cPW/6+fCx8BxwIhkzO3RQyOMDDUkihh34oRwXWnouBeppXf0kOyezrS94A9t47JBdEQe1JiPQNAnRO/PWrdAbpZOw0nj2Laj1td2ZT0kqxRWiN5FS9oLxTffudnVszbkfZpCxZYwGVOR4dtpT/jR7kGJLhnddnNc7JOcI/xuzMDJzoBHqMMu/GGDEUwdf7CfZ
 jQ5tRSLv
 42txGMPFnVGytRCL3riAmgWdseCvR9bnEIcSD6CshaHz4Oz6JDc+vz/nU/UUDGaB3FZU3iEHH3U48Fooz5aZ39DUTvuHMzymwDzgGBImhscTmwuuX9VSQr9T5l743LO5vmZJ8XxnZFE27X4pQFvaI7+xNdgevthYuoow4Negh0r7PHWjXwJY8Pe7oy1pAMlRXwmVLLi1Kq8193gctuLuoEX5fDrt7pe1np7PlhvahH6ASR3+Bxjrf/GTGaZ1zzK9wSAJMRBVQhg2QXbrjMNJTGhC3sip8+zrC5Yk99ZabB7zz6rK1MTFvU8JPGl7bSkda4VTd9dB1jDowgtZvQ+E+1aTLP7G/1Z7KbfWNKbJdr87bm4YW7t55huIwZg80xUtu3UADAeqCSJRQJD/vR9pqSf1FidnO5TcQla1+S+E+Ies3smegEUrQcS5GyM3tLqFi4BxiM6mHFQUGGtQXS1t7LwZYOfQaaIPGxFwsvj5Id07vmbu7Y+hKhCU37AQ03g+H6Phzht2XMufZWCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 05:30:03PM -0400, Gregory Price wrote:
> On Sat, Sep 26, 2026 at 04:44:07AM +0800, Kairui Song wrote:
> > On Fri, Sep 25, 2026 at 12:11:55PM +0800, Gregory Price wrote:
> > > That shows up as stalls and PSI pretty quickly and can be dealt with
> > > by monitoring - but I can see the desire to just have them OOM.
> > 
> > Right, monitoring is less effective from somehting that is directly
> > in the kernel.
> > 
> 
> Well.... I think this is probably an organizational philosophy.
> 
> We are pretty solidly effective with PSI + proactive reclaim keeping
> our machines chugging along nicely.  I think this is where a lot of
> confusion is coming from - because the PSI data is very effective.

There is also that we usually don't add convenience things to the
kernel for what can (easily) be accomplished in userspace.

The job of cgroup is to contain and isolate workloads from each
other. But you're not hurting anybody else by overshooting into
compression. It's a lateral move within memory.max.

> > > > The second one is a policy change,
> > > 
> > > Disagree.
> > > 
> > > If zswap does not charge a physical slot, then it is correct to stop
> > > charging the counter based on the historic definition - it just was
> > 
> > Hmm, but the historical defination is the logical entry, no?
> >
> 
> I think this is the entire debate, right?
> 
> Historically I think it's clear that it is a physical slot, from the
> time it was proposed it was talked about in terms of consumption, and
> Johannes' original definition even said "physical" (for some reason
> this did not make it into the docs).

Yes, it's physical. Cgroups partition physical resources.

That's the whole reason WHY cgroup2 doesn't have memsw to begin
with. It's not a resource. CPU cycles is a resource. RAM is a
resource. A swap partition is a resource. A NUMA node is a resource.

"Unique page table entries" is not. That's a metric or a constraint
that you might find interesting for your workload. But it doesn't have
anything to do with partitioning a computer into containers.

