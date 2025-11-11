Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2BD6CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD9F8E0005; Tue, 11 Nov 2025 03:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D50B8E0002; Tue, 11 Nov 2025 03:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111CA8E0005; Tue, 11 Nov 2025 03:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F35808E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:36:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88791C048B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:36:27 +0000 (UTC)
X-FDA: 84097669614.14.4014200
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id AB18818000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:36:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lyd9yXcK;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762850186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYW7uwo5YmrbKTsOhY6HR/nNpnR25sBnCicgt/mIAYI=;
	b=XiWsXwDBf0ekj/1XpDDPhko+xdTmAklCp6SnhFKUw9TY2zBjMMgenKBuY/OtnCLsB7onKX
	i5ls2sjphc83qyy7K0jcO4gXbFMdvQ7gJBSFKOF4jvtoNthWJ+aj3AEl1PEEEWRZgTIYya
	ugFneCMzY2G1J9Lli8cLnrgjkP2boDU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lyd9yXcK;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762850186; a=rsa-sha256;
	cv=none;
	b=pufoUU6A5yIjbJeLWSMkDdgrLpZGaXaD1pzuOKTDlRQ0N1rIEv3b/qq8R4LCPKjwfjtZlt
	5316JdgkhbfBd9euU0Ichytn+Xx0OGng7fLMvwTGj8Dtd4Gv4f1diJhbqpfus0hyPfJ2tU
	ogDktcJKmEqu4GsKiYWqpLpaydfxwhQ=
Message-ID: <0618ea79-fed3-4d4d-9573-2be49de728cf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762850183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oYW7uwo5YmrbKTsOhY6HR/nNpnR25sBnCicgt/mIAYI=;
	b=lyd9yXcKgVyy5ObtM77OrHWo0Dxr+4i4HTrXVudYHhVkwnMGRUPM/IbZOc1d9CnGGgLNJ0
	ioIhGiUkn5YLIwJs1ZXguIXPhWyXOZte/exkLOwZ35rlxE9hDZ4mkej6SQDbTXei3S78nV
	BRjknCA95GHxC8ux0HjhPJGdOqZ2vqM=
Date: Tue, 11 Nov 2025 16:36:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AB18818000C
X-Stat-Signature: xua5nst4dm6fb88ge4dm15oonc3dfru4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762850185-628303
X-HE-Meta: U2FsdGVkX1/dnM45h6nbdFNW4BQ/CP6Gl5Yc14PxITgIG1BInBIAuj0ZRrNN7PKindCusJdIeUBPWwoH/nfGJjPUKaF8G8s3n7RSz0IfDudbpjl9gh2xrlO2tGbpE9NshEOEgBn4n3WAQvDumpHhJNtPrPRt5/Tu/yKZlEdR1y6/wZSourFTztPlnSyCCxG3Z+UBjtR9y5NkWIMnhDXMnhnk/3koicxAH381MwMYguwz9fKx9CYKs3eLVzuNPR/IMlI2Nl4ZMnsGMz3CClRHnscBQ7vwR5X/26KWJqd+Lwv4n6RACoiG14Li8QOsDrKBIFrKENIezj5PjX3F4lSWGSMjsAwoUi1qRoVHVDvpPdF//SPWUz2h5HrmqIKpPHdlntqRVmmUeu3S7iJl4R3ktW7AM7NUJ2DcRXXU78xp1SRBlOANmmTT9NckBeWQRivkEtGtPF3+bAwsEVkdxm9GWN8pgJ4uov01IKxJHLkFfuNf+0DaoFfmzWfVSS2OA/5hPDuu9JgmFsZl8vPdbaWdzTtq6vsnuCM3T1Eo/A0UDT1ypLiiyP+TpZk4uJys427Q8RsmcENO31ap2mxEtBFsfK/nibYsVBTGFKW1rxFlsiqBgkqBK0M5NlMPusf5NF8i083y25o0RulS04OTTzVHcNSvf0m4+4j/Xj5pteAmMWSYKuCLdyovaCNpQtjZZcEuj+sX8P+zQERLU81nfnpYFBuEwQRiyNLR84jDRpYwGEHHBMvOpVAfioCys2rUzQVF0DPErC5a6O+B8M8/+wtdmJfg/oBTs37fLzyimnQT8lnJGLnRni6dA5BT/nQ6BH+QMChuATyM72HS3DIs8SdseO2ksnu9eEk76dJWh9rJaCYkZL45KDgypa30Z0N0XW6A3gbdF5mTSc/ZMWzPr7uwSKVB84CPOsCly7zbBxnUsqHDqKr/I+S/HbSmRhDEHANcK43JdYYJ1bESTXT+Lxe
 D6HBY50T
 tZ8oh6tAYLqAmUBMphj4ZrtoXiBZN1MDgDAIPh52fJvxg49e2Pajz3ts9rr1FrOhcVXh1500nx/s5nJLXezdjAugG31diZOSrjNqVWLJLy3dhCzwI0YCw47AivTzCXdACIzWT0hAUJY81ip6aKJWOJYkduq59tGeWaswvoOmyzBA/5duYJLCyOe/6hzTYwUIpDMHScf5jrmiLnrTJQju1nsm8wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 11/11/25 7:20 AM, Shakeel Butt wrote:
> The memcg stats are safe against irq (and nmi) context and thus does not
> require disabling irqs. However for some stats which are also maintained
> at node level, it is using irq unsafe interface and thus requiring the
> users to still disables irqs or use interfaces which explicitly disables
> irqs. Let's move memcg code to use irq safe node level stats function
> which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
> (all major ones), so there will not be any performance penalty for its
> usage.

Generally, places that call __mod_lruvec_state() also call
__mod_zone_page_state(), and it also has the corresponding optimized
version (mod_zone_page_state()). It seems necessary to clean that up
as well, so that those disabling-IRQs that are only used for updating
vmstat can be removed.

Thanks,
Qi

> 
> Shakeel Butt (4):
>    memcg: use mod_node_page_state to update stats
>    memcg: remove __mod_lruvec_kmem_state
>    memcg: remove __mod_lruvec_state
>    memcg: remove __lruvec_stat_mod_folio
> 
>   include/linux/memcontrol.h | 28 ++++------------------
>   include/linux/mm_inline.h  |  2 +-
>   include/linux/vmstat.h     | 48 ++------------------------------------
>   mm/filemap.c               | 20 ++++++++--------
>   mm/huge_memory.c           |  4 ++--
>   mm/khugepaged.c            |  8 +++----
>   mm/memcontrol.c            | 20 ++++++++--------
>   mm/migrate.c               | 20 ++++++++--------
>   mm/page-writeback.c        |  2 +-
>   mm/rmap.c                  |  4 ++--
>   mm/shmem.c                 |  6 ++---
>   mm/vmscan.c                |  4 ++--
>   mm/workingset.c            |  2 +-
>   13 files changed, 53 insertions(+), 115 deletions(-)
> 


