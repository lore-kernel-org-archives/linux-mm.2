Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526A8C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F606B008A; Thu, 10 Sep 2026 12:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220906B0093; Thu, 10 Sep 2026 12:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137686B0095; Thu, 10 Sep 2026 12:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7F396B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:39:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88EDEA4FB5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:39:48 +0000 (UTC)
X-FDA: 85198414056.02.1407FEC
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 984D0140009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:39:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WyPsKyit;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789058386;
	b=OEPM+4tJYN23HtsYoU9tPmNVsrjuCCnI6HVf1YC00xxJxtGcDDju4zqHjut7vai5OPbniv
	eja2VGmD6oWSqD2s7DK+yeeHUcDJQ/5vTAgmyvwPo1a3ayBNXPGPptXIz7guMlBymjspMt
	+k+bP1G5no73gdZuYGB6Kj5AKnH7u48=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WyPsKyit;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789058386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dt3gtmPkdPhfN8wK3IzamDnv04krly1xcDydirm8Dg=;
	b=nMG1FDXdO1XdJpg3D13IrAvv3AZ7bCSA6HTiOx9pJWG+7F/gU6Bgk0F4gYKc8f3ful9N3e
	9X1QdUe54ZcUycEIvyMunPdgEpmFaYIBLDgibJBiAM8Cv1FfptDvyJrVbrwATTix7ywPa+
	tMhqmQjtKQy5dp/UbJAYSUtHXzSvkf8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yz1ck6uqcqcd9T+oUOlPk0GNk4jIwW+HM3Fvm0oIvuw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789058379; v=1; x=1789663179;
 b=WyPsKyitMDXYuExL/dowTmU+dY0ZsHlqfB4c28hdxZNRHS+QQeq4xBgUi/97wXtgcjVrRmQe
 ndOlr64PQ437/4KGSF14E6J0/UT9qEmM3XCOUQb+mQdU2RfPGCpyuXamf3O1uAA+fCdr+tK7AhT
 8HBU/P7lnJUkTuvVXqCV1LQw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f698ba6bac255394;
	Thu, 10 Sep 2026 16:39:39 +0000
X-Mizu-Trace-ID: f698ba6bac255394
X-Migadu-Flow: FLOW_OUT
Date: Thu, 10 Sep 2026 09:39:37 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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
Message-ID: <aqLZ5TVDAqEbIeMN@linux.dev>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqJXx2vtbKaRLt3x@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 984D0140009
X-Stat-Signature: ddmmzywqm5pyi94ur38pxsf3zj38sn1g
X-HE-Tag: 1789058384-251417
X-HE-Meta: U2FsdGVkX19u1ecFOgb6ar5+YPSrFLtR2YA3UzuAiPdCkyV1Mvra+xj0WbDErt+Db1Dxx0zblFzxqlPeB/iL1tk6FhjYvx2DNXOk44a7CD+d2k3TvM7ihVLs0aW8W/M7fOOXi/PuQKAM1YNM6XXGaqP9xFIv8jkXShon+/h/isF9j9tpDW3SDwPg4+G6ds4sTffeDjqVi0A4IKaTkq4FdL2CdwRMk9Xt3ek1HWL0uwPwX+u2j9Fuk2yZJ0Sd3z60B12+uMvfIzegYMW5+fZVed8ADSvBaZWN7OgMKjqO01WlIEz86Wwc5FW1Zqx2PmZ3v1TiOtVx0DdZN69EzzhIRc6mZtRU01z71kjw3g25FsfvhiseFLX2gzkeZhlmXy6UUPT8tQHRM+RddGzLk7WtE3Wh3t3Mqji6hs1ULG60B9BBxYIUjEQAG+W0/EdW4W6yQEB858gIp372IbOoj6ik2P1yZycilUGq5vjddJeVoy7syr8/JHscpUtuZI8rBHnn7gjsxq4QcacKPcDN49R0WdbqWTIi92wv5rclW2yCisbr4owYjTTR7oxDbpTjH0jB8YQg0AcHeOlaeXBFosOaFzAJ1+4SAJBJkiD6Imz0cnZ8LShpmikaMQeAl+MSS2zPDzMvx/6/R2jAQZvY/rxtt87jQQ+8x0AMxwUyGHNDSfTbxUO1ra5Nf5IDv4WzOQLWFrY7RGQB8zuyt3aVEaclxkOU+IcXeaVM+iRaT6V3W/vnWCVaWWOs7Np8/I6WsgRngHgWcY5Vl2TXfsym5NNfZr7fmHtrKCxK69mJHoY0GyOg3EacRTn2MA3z9lSnR/GM0v8aBo/WYmaQTr+kW4KjFFL0nZhOoEbhG1N1Hq2N8N0TzvUcev3sgIi/VcEjAfQAXC0JJPTPgs5yE5MPCJTD+R37Vph+Z/t/ZvsuLm/jVvphfgVuGHm8Yi34P8jckNVKM1W0PGcF0iuhMEAjY9S
 BtgDiQdo
 S8T86RHye/ssg6jKNkcnfKujNYnnuxZyBwNJ1jlM5xrieLy9t+Z0OI0PdzfDPiRVMKCLPiJLdLpS7GjFpIOdsv897Imrj/uH5jknvb6Gd8+L5EnVYrl2EppnFSAdyJtktfBP72U9NhwWHVCfeT6WAtcCtLrdOrcZ4zPVzR9U3Z8egrwywoKQ9BijSnIG0V7JTncXVlUJcX0OU3YfKOx4DX8f3Ve3waUxZ3rPXP8g2CvX3dby99TwJ77qPnOPo8yTgPWAZ7VqMwRCk1myg5sFWrybgOdnpLDzjEF2luXI2qJSlq6rpCNwVEVjhzIMXOyUvtIQPQ3aReHfN1cd+8DJOrDVgLQ8j/hs4kLTfl/m6/bfsSsYnzNN5tnuovXb3/r/Oj5ttDITs7J8sx3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> Hi Nhat,
> 
> On 09/04/26 at 02:14pm, Nhat Pham wrote:
> .....snip...

[...]

> With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> rest of swap already uses:
> 
>     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> 
> no branch, no RCU discipline, no tear-down state machine, and no NULL
> return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> cluster layer stay as simple as it already is, which is precisely the
> part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> on.
> 
> I'm not going to claim xswap wins on throughput. I measured it:
> on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> within ~2-3% of each other, effectively identical. 

So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
we are discussing implementation details before deciding the design and
architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
need for dynamic growth. Why we want dynamic growth upfront or can it be added
later? Once we decide that then it will be very easy to pick an implementation
that would take us there.


