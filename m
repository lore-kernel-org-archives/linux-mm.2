Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5138CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 06:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0676B0005; Tue, 19 May 2026 02:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82B86B0088; Tue, 19 May 2026 02:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96FE6B008C; Tue, 19 May 2026 02:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2E536B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:46:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 583F21201A3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:46:58 +0000 (UTC)
X-FDA: 84783236916.03.A9619A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 969A0180005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:46:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LCB2rZQ/";
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779173216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9dZ2C5eCFM+Hg1t9HE3DIgYlMs7WSP/eQ+FIC29mUc=;
	b=nNE0s209YsfYvQIRxyluujYLWBqQdCOt93+pS/d/eg5Li5Pye32bAx5IdBlAO+Oi2byN6M
	Bj+SNSVqot+we4zdiFhhTn8q4JFdCgngZGYZhpCellX4UUKS6UzcUdQGNTRnYNO+gLwUT9
	+FZb9DpMKFCul8jIgiwg4O+ojdYjnpg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LCB2rZQ/";
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779173216; a=rsa-sha256;
	cv=none;
	b=Ksa44hQroWCH02JTeGNQIeaBjc+gI67GhPHS31cxy587TnqJHvPE4p54Um0Cg/PcUAcZgu
	cEotM2lxxNJJZz11H27TQ1XP0Mvnw7gUq3gPsxLBheVHHgur4rZcQ2/7vDibEqYTU2FiE+
	70UbdZzpJukuKhiomKOZzpn6/Z6zvF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DB0A43752;
	Tue, 19 May 2026 06:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46F3C2BCB3;
	Tue, 19 May 2026 06:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779173215;
	bh=pLDMVyRbN9Y/5H223FaSBbdn9WC9ciIgSS2Ci1HxMh4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LCB2rZQ/Er2i1fpmMhU+kIxYhM3jqrCO3nGa/VKoGrA3JDefuxUKQCwZa/0wAhdBl
	 i4fIx3MEWfJTswY5G93Sv9nZKKcZX1u2VeMwG1EguiPEC4JiXidixGKUmmDiTnVmsK
	 oGOs0fKMJe4lADeLDYL78nsiewSin/I/RvUk5f3ZrknKvvad+nB2AjYGRZrof4Bteh
	 SHqhedoty0fweVHnml4RX7+brZAHlXf1E65JPnO5GYbPyjBS4mA438yPGHeUhWoE0q
	 jdAofOBVlxETjKo7F06L5xlaji3kwdZgFrv63cc0S+c/U3cR+VVUtlamSrcYgxmJ0E
	 rP0uVnwqxtMww==
Message-ID: <4e296262-fbbf-4ac7-aecc-3ef831583704@kernel.org>
Date: Tue, 19 May 2026 15:46:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <aguiSnY3ie1y4nEl@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mjdmpefte3ajrpycujatmffonqhdxfw3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 969A0180005
X-Rspam-User: 
X-HE-Tag: 1779173216-726614
X-HE-Meta: U2FsdGVkX19RknfeXGmfyJ28dO+rRPF8t4NwCPuRjugoVrpo/kLdJZIAvIJYjFtXErHT5eVuXoXAhCF1KPHXvOMgnZRRTtjX5tixeXMSp2DPay/6JQ6+7xELKxY4sCXKNkjco1Df6tj3ZmhnsqFc9aRKmV+ZDCU3MT9ci2bs0HfbOV3sbAwme99us4lZf8XFbp7TNmkxXBXbdVtCr/xMuwkwKPJ2S2UIH7k5d54/9/vzCc3YXxV5mlQp2XAYtDnYYcml/sXjiavLruIc/E8D1Wa1nfuMYq5Be+zwlnPOupPzgysj99kHCi7ohcAArwUIi1qJMgOrQfB9SV4OUzawWIrMeSQCU51kZagWg83xsi3qphGDzBRL9SxHMtuMqUQRPQvD7A60zH/YKnqzf7sqyNhumALugXWRUndB0FxOKT4HboeaQ0o4XD2ZpQIzmFB7tFLU8Xa7CZUvl29+KsLSQ0uOzmD6zY45njpPvecz5pc7iLp/fc4wv2M3LnjBcfEK+Y3u2R5A9iqpR4C9XpBQs35vNhzRiMCCzA58C3jF7A7q1IMsNY6r43snv8DP6vgX0xVS4RBD7fmv85gPxColqy4O1+l1NtniDNWle7V4g5i9YAyXlw0ptCf/ePrXSDiooWd2TYeP3VPjNkS7CsBxLNgIp18g17sqcCh392z1VVPlOrYM/rUxG441VbYe1ApWJRUOtruYv7U2GVCdUd2tEIsNPBGHKbJZWt+QPyBcV1qFcTDl+R/uHarMJmBceB6qbvZxanEje47jWlygvtEx9ZK8xGuISuRFdxtUl501ZfHiy/p6iPpK8VsD+KdQVgohDwPfsqhiWZJaNwkpCxnNIQYXqqH2DeODDavfFMvhZJaRX9FPp5tMDASFZk0nDFIbYrJl7YqCZf6WelXgEUhvK/mwsSQUCXhvGdL3gkwMxylCD5QzsbQAIAuW7OJE9pvGEdYXrLquJKc0LnuJQUf
 xprgaA7b
 T4HYjqQn0gnosUG4HCxL7jlS28BQZXt/Cs9lm66Adaq5RkTw2kqrZMg5LBqd9cue8Go5+YbZisUauFJuFCv9uMlJ0uSnixdfDQ7PfGYEKSA5nvflYLSpu4J9icteH9CyHlmywgiSsPE26BmagchTuqVQLfsUJda+DllSDq3B2AQM/Fwq+uPuDF6TlB2xxXlpZhP82QSf8u++Qama7uCH0qbudAaxi6yKZutbFo24n7oNVnBweZMg4CkL4rlrBsiqLBexn9aY2PG1ISQRsQQrqkL3d/nmM4hqeolhzTD9vo25SGwV/5iC7q0pThcFC07OJNKGr6V7oxkBqth/buaylwQDU0cixtnjPzvNKAc0c8sbNu/jEIeNDwqxY/uxJEV5LguyR5cSZgRspcUF9quc64zo5hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/19/26 8:41 AM, Shakeel Butt wrote:
> On Mon, May 18, 2026 at 03:28:27PM -0700, Shakeel Butt wrote:
>> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
>> per-node type") split a memcg's single obj_cgroup into one per NUMA
>> node, but the per-CPU obj_stock_pcp still keys cached_objcg by
>> pointer. Cross-NUMA workloads now see a drain on every refill and a
>> miss on every consume that targets a sibling per-node objcg of the
>> same memcg, producing the 67.7% stress-ng switch-mq regression
>> reported by LKP.
>>
>> stock->nr_bytes are fungible across per-node objcgs of one memcg.
>> Treat the cache as keyed by memcg in __consume_obj_stock() and
>> __refill_obj_stock() so siblings share the reserve. Compare via
>> READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so
>> the rcu_read_lock contract on obj_cgroup_memcg() does not apply.
>>
>> Sharing the reserve without re-caching means bytes funded by one
>> per-node objcg's slow path can be consumed/freed under a different
>> sibling, leaving sub-page residue on whichever sibling was cached at
>> drain time. The pre-existing obj_cgroup_release() path would WARN and
>> silently drop that residue, leaking up to nr_node_ids * (PAGE_SIZE - 1)
>> bytes per memcg lifecycle from the page_counter. Forward the residue
>> into a per-node objcg of the same (post-reparent) memcg at release time
>> instead, so it can be reconciled later via a refill atomic_xchg or
>> another release; the chain terminates at root_mem_cgroup, whose
>> page_counter has no enforced limit.
>>
>> Please note that this is temporary fix and will be reverted when
>> per-node kmem accounting is introduced.

... because once per-node kmem accounting is introduced,
"stock->nr_bytes are fungible across per-node objcgs of one memcg"
no longer holds?

And the follow-up plain is to revert this and address it with a 
multi-objcg percpu stock [1], similar to a multi-memcg percpu charge 
cache we have now, right? (regardless of per-node kmem accounting's 
progress)

If this temporary fix imposes other potential correctness issues, would 
it make sense to land [1] in mainline before the next LTS release and 
skip this temporary fix?

[1] https://lore.kernel.org/oe-lkp/agtPMpQK2jXdQAY4@linux.dev

-- 
Cheers,
Harry / Hyeonggon


