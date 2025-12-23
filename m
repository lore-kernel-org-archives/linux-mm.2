Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C40E6B277
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 06:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A006B0005; Tue, 23 Dec 2025 01:11:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7636B0089; Tue, 23 Dec 2025 01:11:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3876B008A; Tue, 23 Dec 2025 01:11:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9946B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:11:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA6055934F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:11:15 +0000 (UTC)
X-FDA: 84249713310.14.C509BC2
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id AF69180008
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:11:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ko+T3x5d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766470274; a=rsa-sha256;
	cv=none;
	b=cOEXsxavUMWqtfw/5TUCNRV0WeH9VFQzgnxvhJt0ljLkkx7b+332b4TiQ6IOcvczcejMDH
	7hPAKW/Y9WOQxW+XG/uxOIVHd4czQh9cUYdXbMLB/vYdKAxYrWLk6BJ2Mpu8uajaHpUOSm
	BOgmvGhGMz6PgrnHxtCb1zOe+qvR2pw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ko+T3x5d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766470274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23aWOZVb4BJFZwZWp+U6nNqi+ffrD9hfhTZYhMPV8NA=;
	b=RYdkmng8ci5Pz746cIVclYgm/DRa3ZaC7GPZ51YwhgCcnKlMiT+wNuLq2E6HzhNQYydsab
	qRofkPvKi+ZEH8dZs5dci//xKxC7zf7ni/ACW3C2hwNnsKO43kKCguXDy6X6L/0tS+nuV8
	eIPfvTprNjPKj8ArCWGiakl6+hxSVv4=
Date: Mon, 22 Dec 2025 22:11:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766470271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=23aWOZVb4BJFZwZWp+U6nNqi+ffrD9hfhTZYhMPV8NA=;
	b=ko+T3x5dZUvaGGt3MUjw5uDq17uCH5QaQlH4UlV2s3orLqSCIvl93evk9/p9qfgHX/Z8nj
	3ATnhhZPrVKz2ahwSml08lGAMOE26pMLObjy7IfjmaAarMiuzZGl19f4FD8kNMwavb5+rZ
	4jnGSNjdwGz9dviGFEoaRd3gIkOirdg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF69180008
X-Stat-Signature: 7zk71moss1d4zy685snzx8j64byaah4q
X-Rspam-User: 
X-HE-Tag: 1766470273-914244
X-HE-Meta: U2FsdGVkX1+PkGcehGDEXSwYlecUUZCTpeaSJMuG0p49Be4UFOGKri3J1lcbLRQEXDmbdUI+hxjgMl9Hb0/yZcu9KBL2Nm56cwdDiKHxApkfMN0rRoRvim9qUsdUXW3zIzEOoIY5acHelRknIT/etu9+seofjmCAyPdvUDWlL0R9ABPz0P2n/Z9YqfWvPKHs4JPszSuauAlqV4a9xWppDFwj7FbFOrINN04PsdP5+qvhNKacMDVd2DyUDAGOquXhsDoI+K1LXCDFMZDL4AFzSHZuh5bUTE8s7NHsmd5h8Ex7FOuuLc3g3pWD9fx7ibiGYs5HbdM1VcA/YSwRxIOow27MZPYgIV5o8qJZTpIE2MPYL5sjX/6JDw0ADWsraAgbrjTUHr2Gqf7/UwQvHGgIN3XQpN9JZOZscnQ73sCUtohfmcmgoJkZTG2OB3WakcqerMkG2yMiP8Jaq66QXMoirUCG2AoQrv6uCRhYF5Hjp7AsIelwXVm0fiEjVIw4q3/n0Wx9t1OOuw6PbLMCCqUeZ95E8Gbzf9JxRFStRVaLpYuUyuVOXiU31MSMNH3Ta7TZZeqzRGUJQcnC70PftL/LJCMczdSk2VKWJcAqVXs8QaudTut6rcGZPEQUzWEbtnXrWiiQjfmVuLFW1CgkT5x14U1bFtiGp2PzBu+IoWPV1Ugy9n1C5d6XTC+subpeKGvM6cHsvVd25lLhOglmiXe7OtLUK8XoKRZU0dT2B+qxgNTt8fDO9qmOxQueriiJX22/M3wcavuqnUPT+/k0Rb8sbeqFJrvMdORKbgmr7DpzumNlnaHA3CbQY/SXqSrVz6FTowbGdn4dJmK2BFN26Dnq7ufPdr0oWYnXAlFFhtVEOQggGERSIjofhtaiu5p66oqyOMFRnh3UyPqpaMfwrk1KRarbPoKhjr23wDGFp8gq47uKAnL2pY5eLMZ1dIBF4aQjitofasdRSJCZL4hvqCL
 tsxk3TNx
 /GQvSfavkVE4FTlmNHX2b/TomjRl+kB9SqJwVhIJwxzjT5retjcLdlsvqBLLfptqYI+nXOi7ULChnoWp7DwMsqxAucdLArLQKZu8tH0nccXAdP+cwTK/MdP5LX9baRyBo4xh74BJaCgFHBfjmUaPAMbTvx/spmKT9/PxyJLSQu4OoCd6b9uq0dlpNuXwL+ifobfdUL4bmuX2vZ4d/DgfwsmRuqBcmQ2ugCKgM9zD+tjNfKGy6iKBUdM8wSV0kwvZS7hfU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 01:42:37AM +0000, Jiayuan Chen wrote:
> December 23, 2025 at 05:15, "Shakeel Butt" <shakeel.butt@linux.dev mailto:shakeel.butt@linux.dev?to=%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux.dev%3E > wrote:
> 
[...]
> 
> > > 
> > I don't think kswapd is an issue here. The system is out of memory and
> > most of the memory is unreclaimable. Either change the workload to use
> > less memory or enable swap (or zswap) to have more reclaimable memory.
> 
> 
> Hi,
> Thanks for looking into this.
> 
> Sorry, I didn't describe the scenario clearly enough in the original patch. Let me clarify:
> 
> This is a multi-NUMA system where the memory pressure is not global but node-local. The key observation is:
> 
> Node 0: Under memory pressure, most memory is anonymous (unreclaimable without swap)
> Node 1: Has plenty of reclaimable memory (~60GB file cache out of 125GB total)

Thanks and now the situation is much more clear. IIUC you are running
multiple workloads (pods) on the system. How is the memcg limits
configured for these workloads. You mentioned memory.high, what about
memory.max? Also are you using cpusets to limit the pods to individual
nodes (cpu & memory) or they can run on any node?

Overall I still think it is unbalanced numa nodes in terms of memory and
may for cpu as well. Anyways let's talk about kswapd.

> 
> Node 0's kswapd runs continuously but cannot reclaim anything
> Direct reclaim succeeds by reclaiming from Node 1
> Direct reclaim resets kswapd_failures,

So successful reclaim on one node does not reset kswapd_failures on
other node. The kernel reclaims each node one by one, so if Node 0
direct reclaim was successfull only then kernel allows to reset the
kswapd_failures of Node 0 to be reset.

> preventing Node 0's kswapd from stopping
> The few file pages on Node 0 are hot and keep refaulting, causing heavy I/O
> 

Have you tried numa balancing? Though I think it would be better to
schedule upfront in a way that one node is not overcommitted but numa
balancing provides a dynamic way to adjust the load on each node.

Can you dig deeper on who and why Node 0's kswapd_failures is getting
reset?

