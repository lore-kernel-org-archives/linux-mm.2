Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC10C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667456B0093; Wed, 23 Sep 2026 12:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6175A6B0095; Wed, 23 Sep 2026 12:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557876B0096; Wed, 23 Sep 2026 12:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8F36B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:30:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7EC8A6C7C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:30:46 +0000 (UTC)
X-FDA: 85245565692.09.0E7B36E
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71D3420013
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:30:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e56fLXSO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790181044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epopaknR4pa8ZzhF6ywCDFlcNYLleytey7bOToQKuj8=;
	b=iAdRroJq29JYMLsX2qETM9/qzolsvVr05rTka88lFT7o1t/LtxlZQrPzxFOpthJdnEcw0u
	VNDFgS8ajvYXDqZnT6bLgQxtlQigu/nNzn9NPuxekj/JnQlrcNjqCK6Kd+udWqCot8lX1g
	t3oVAZK7xhq8dqCl9g1ylwNvpAtl6Gk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e56fLXSO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790181044;
	b=j8su7guXx5Acigu+kF+XrcGpMYYdkISVo/+LbyDzMRO9GjSlc6H/u/+f/ilwj31SNSrQJo
	1m1lUTXB/m4/Qa9/BeTYlt72dHoejeEg9qdT2Ii61uMmJWv7q7sdbWzYdCModxd9KohYiQ
	VVGfFPOFpBa+y8+CZVBK4ae3plsTUEE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=syhg4Xh/gTAUQZORWpezw8Y96tkhKRENMCokWTcj1JM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790181043; v=1; x=1790785843;
 b=e56fLXSO0dNEodGCADCluJC7/pc7/Ch7AsscjvuEp0s8yNT9ctnnFUcVNBfkKs/yvhXeZ4rj
 oz+3SQnRv8I5zVPOixGqdMw7XDGU5t/zS1zlBWxqgk6IIDCS/AD/+IMr0lslwGcVvh6sM812+Cw
 wCAYqfllMyxTL7UQSjRjjpjs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a4693e8db12b2407;
	Wed, 23 Sep 2026 16:30:14 +0000
X-Mizu-Trace-ID: a4693e8db12b2407
X-Migadu-Flow: FLOW_OUT
Date: Wed, 23 Sep 2026 09:30:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arP8vXdJAL6ZJ1Os@linux.dev>
References: <aqQrPLPXHXiuKup0@linux.dev>
 <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
X-Stat-Signature: t9ccptp8rrcytf3femtr68daebgxdhmk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71D3420013
X-HE-Tag: 1790181044-517017
X-HE-Meta: U2FsdGVkX1+CP2ixP2Nk2X1nVDrAb+IeLytuOmQDwhaFbJu3xRlU+fUcRcergSQPPHrcqJVBOK6K+ydxwfSzZdokMOqWEckFqyL0neBOdR+oLBG6/7DjUr2Tjl6stKuQEbbsQwSO17ZXTInaOF1hy5n2FwG1djE8qkPC5PlPgnhSk7xcwE7RV7UJvngTKcxLHV2PrBZwiRFfDcEiCc2BBnoNrSFuz0sibWDmkUo7QmHgAX8eTmL0lxCv5ftQ6aSuC9duODROi+3pHBcTTWU4sLDexjLERIibLzoNxus4V1TM2q1zEzKwz5Wdbpi7iex8Pd4LaIz1ZvVW5yK41lboBukTQm3RdGm5dzclJ9am3gYHpmuMYp6v/y2jaIMrSg4UgTB76M1KO/wIxK4yy72iOuIPW+obAvxsMe9exQHwkTb/4jNNiq+j3L9+FwtCqNAIIdb9WErSlbKpyDmJ4aU5wtraP+NlwmDyJ0gGeXE1MPFsHdK2nHGxyS9ahPRxYL2PTvElVkHLHqvETWIlDfCPzIpj/qYxxHSqOPqzMU6OjPg8QjLOROnqIKLtztgohwlQQWJxomQijBi1oDZgD6ZkMyh/kvcCx0eRh0WEw2O1qPv/KwrNBJWQr3s5kZxNGKmtr7qhowH8My/RQBEpnHpZOjnaMoLjsc9LJZ/ZxQXbPtanEdvmkLkX3QR5rTLQQMdJ1HLSnGCXxK7SJka4dux/CgfEBJZE3FIXpubbGGORGkhqGA2eiRMFzDKj3ob3HVir9Rdo6WS8Gp/8xDznTUPhflovZ2rEAHhmzOEvYQLgjBF7Wp1TwBWQOId2UizmpKiPoHfQ4Afkioroixsd+0aghWUx6wvmxJ6TOhkaZhBn0qiUb+O0uqFGx16Ea6G70uGHYScelav5LHvI2tC/zSiPr7sLqyF4uq+nQk9AJoQAQijD5cfwS8uRytD8Aya7mkXS3P4/gOJiV66DLEOsdte
 8H+vhxxA
 iQZBFyTSPxKADfVVF6wUHfBnGe+JYaMZTcX7TT2Z2/CdMx+1iCw3SyXVq00l0DzIXeYZXdYLGcbu+nV+K4bQlWUlWVMD2B4FYfQC+U67H/qV6zc7yMgUkL5mBHFfsDoG8bCs+jVk/2XZHkXOFnoXIqFJbd9OABQ7WQpuIednbvBkJ2vHDjTzKV37vsORTtXb4W3Dw72d+dli9z22gOgrRXUMMDkHD+PEwtdvUoHeS8Nxu5bNNcjDmZdibTAEvNR4j2DWc0H8S6HVYU1jFj5SEKTXJHPvAdY2hCWVziz2s364bP5IdfY57YC9c6CC+/mhuuFFhwWpug+Z9BhY/lhnIZItKkhVZmhC5O9R9cncM91syI4j/hN+/XneVOk2Nm/xxFjFUP3aighUf5oEiYCw8JbFOUIPolWq1Z7Qn18jkntyvjC+Lnw6JmN2tmsaWAvQIWAhl/vgqUZKXWUaS8ctCt/u4vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 09:44:37PM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 7:54 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Sun, Sep 20, 2026 at 5:13 PM Chris Li <chrisl@kernel.org> wrote:
> > >
> > > That is not what I have in mind. The example I have in mind is that
> > > zswap is charged to swap counters. Changing that behavior will break
> > > our current deployment and that of many other. Kairui give some
> > > example as well. That behavior should not change.
> >
> > We already have a knob to select vswap. Users can turn it off
> > initially, and/or update their software to handle the transition
> > based on this knob.
> >
> > Otherwise, you'd never be able to introduce any behavior into the
> > kernel. Hugetlb accounting/charging is a new behavior, and there were
> > softwares written before that assumed hugetlb usage is not charged. If
> > it's not a good argument to block the implementation of hugetlb
> > accounting then, it's not a good argument now.
> 
> My original intent is that 200% of RAM for zswap is too much.
> 
> It seems you are talking about a different topic: the vswap charging issue.
> There is a golden rule that we should follow: don't break existing
> users. At least with the same persistence, this rule should apply
> universally.
> In the swap tiers discussion, the UAPI was such a big deal that we
> couldn't implement new UAPI. On the other hand here we argue for
> liberally changing user-space visible behavior.

Johannes has already answered this very clearly but let me talk about your other
claim.

> 
> BTW, I already shared that changing swap counter charging will break
> our and others' existing deployments.

What do you mean here by "break our deployment"? We are talking about
memory.swap usage and limits here. Google is still on v1 and using memsw
usage and limit and I don't see how vswap is breaking memsw?

Are you making these false claims just to derail the conversation?

