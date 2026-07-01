Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27CE9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B286B00AF; Wed,  1 Jul 2026 11:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253316B00B0; Wed,  1 Jul 2026 11:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1693A6B00B1; Wed,  1 Jul 2026 11:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E21146B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:36:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 571C6C1D5F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:36:51 +0000 (UTC)
X-FDA: 84940610622.05.724F481
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86B42180007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:36:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haHWV0Ul;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782920209;
	b=oHJ1FEsiU7x8ugsk0g2Hss08f21GKJSaR8E4ZXiRqR6gBAlP3HEKP9dE+Yqj4xcNT1Ootd
	DiI1nwnikTJ2lYYN0rrF+dT186biIGi/BbXkbjOxxe2wFq/3YoeoJnQHb2vv2JVxKliX9e
	KDrSlBn+wU/BpNdxSczWob/DHPd7ddc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782920209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ufqJUnCyvc+hknRtS5Siyc2qfmJS++aIpAUseDEK30=;
	b=sA28klAooD+Lq4nfoZ8EalmDYjB9+bD26KcBGewp3lAB/Ur+zxYcq4+bYZ+v5fdxaQDZ5v
	DHz652PFMSSpQVw201Ly2cqoGT1RAp1ZYEhUQeT5IKNhVVpYsoMn2NjrRt29tciFfeFApQ
	FszLUFizHoJ9ChieiV44RI69rCjAiLY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haHWV0Ul;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFFAA423BF;
	Wed,  1 Jul 2026 15:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CE01F000E9;
	Wed,  1 Jul 2026 15:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782920208;
	bh=2ufqJUnCyvc+hknRtS5Siyc2qfmJS++aIpAUseDEK30=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=haHWV0UlWNsepxaEgoprUycVKUGfqF+k2KN2GFRSdpl7iWO34OFCmMQ+ZfZ5FjqM1
	 7zK7OYNRO/7CL+M7SYNokSmxdSFLdQ1DF+effczbWaWx+0QrOQkssBOIVBp/4m6FrN
	 KUzjkt/gcrjQ8c7XSTlhKl/03Md167sdSVLDbvaGBW2HePO3IlXxTYd2WHwZBN3hcI
	 iemgqXDYHxNDCmGDTzbS1B4uOOK6HHFk4h8CP1HD+2UXkOwAbUwC7SWHpPxjkFoUmm
	 fiH9ucvCNzXD7N8P/xkaTE63ncimR5RCAPlH46Eo+YPIvB7a362fwZrBulhfvMyWby
	 44VKltThKbhUA==
Message-ID: <2fb5ce53-666b-4b0a-a4ad-2b3a28c54768@kernel.org>
Date: Thu, 2 Jul 2026 00:36:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Usama Arif <usama.arif@linux.dev>, Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
 roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
References: <20260701145736.3785016-1-usama.arif@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260701145736.3785016-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 86B42180007
X-Stat-Signature: hs83t1ut4spo1bgfrb93hzabr7x54qpp
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782920209-430656
X-HE-Meta: U2FsdGVkX1+jr4aQTd4QEGv0fLasQ2RfvQR65+YtRMm5S5vIAb1O7ZRTy9lCmrZNQ0jpK4Q9J5hU3vVqG1vGsrjmIFO2u2XyyzghXAf/02TLHTUYOtqnJqQ6ed+ulm7wyUuLrWAUc/nzAwHDrGJo3W9hHr3ZdNFkYJhNkt4QixQ1aWBsqxufJVDARjhPRTOaLh+fVqMm99k3yn/zEOcDTy+8TvgDpZJw/o18JP1WV4nxeGx7p5bLOno/LpDwGIZXL9PpRy9KRRhMPwCcQAsHTOpeXHdt7svkP6U8sY6RuV6E8iLE+uN+WLF8YZM334hi3vhZxYNX+s3hYPJjmmtSCI3nUq5zN5AISOf4xMtoPp7qyCALuqQgAu2vcW6Q2Kump2dAjXxW+x8VqHEis9XUWAKXb59toAJOVioRsB8EXzXhiWU5zuz53cwVMiD5846BOSK1mWcpQ8ASmzENrkq9YWGzlFn3fiE3dNtxW4uQG4orGFk7q/mwxsYATjbQrd7vH+bxyLHZm2h4bEgTXM0D8+CCSycHKJYwu8UB88xc2HZCLtbhz3mwWuy1ZavY982UINJf1xrbDF1WuuMgrHk2pVf/hdliXZSgcBumQHQDIwF7jTc95VQxUuBGOQ65WNzDYod2YTVWrbt0OLASaczjwqQjwKERaYLQRq7/jZ2FLzSGMm4h1ik1UCbCqm67TDfkOWKyufMC1koJtHyjJovqC2CrO5hyrOfsLe3DmlprTa7CpnDtlloSb6RqD6IoOMyThKLsMDOCgxhLSmCdXy4KKbUGAC9MD2FvB2uhPQOM0zPdGQf+L2N2gWCne1RU8d5VpuSDE7cneNQ21UQ6mTbkEYfllRXY9yFtx9xWeSMh4M5qx24vyjc4wih8ZPiHjLfChaCM2UAzCbbkbKsCIk2y9mrDx2cZceVXM4zMozedWtAX6dK/+DNcxkh4Nt1NcP6/qVprc16es0kkPgfKDF9
 UL1f1/Jn
 nrUVQM25i/mgpMQy+VA6LXkFuabMteW5vX62k2l+OgxAA56KY5SfSf1VVqBIiqUIKBQCLkURs8zokSKfrCosR/T5A4+Vphpl8Oni2sxDntk9SLb0RoPko0f8EnD0qIGjiHPw1ID6B4WG6tM3RRXmlJJ1DihtUyhgCuXE9mjYIgQ3w++6ucBke0yroqis0kXw8kMks+L9La++j02hv7wFArSmBl/YQ3zJasmn5mXOzxXfqL8844L9v5iHJ0dfggQwAfqKyKxCd3mP/SFeZPm1s4UYeixtliIuFaq4MEVjBW+6mcBhha6R0zES6BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/1/26 11:57 PM, Usama Arif wrote:
> On Wed,  1 Jul 2026 15:52:51 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The mglru page table walker batches per-generation size deltas in
>> walk->nr_pages while walking page tables without holding the lruvec lock.
>> The reset_batch_size() later folds those deltas into walk->lruvec under
>> the lruvec lock.
>>
>> The page table walker can run concurrently with the memcg reparenting path
>> as follows:
>>
>> CPU0                           CPU1
>> ====                           ====
>>
>> walk_mm
>> --> walk_page_range
>>     --> update_batch_size
>>         --> walk->nr_pages += delta
>>
>>                               mem_cgroup_css_offline
>>                               --> memcg_reparent_objcgs
>>                                   --> lock lruvec
>>                                       lru_gen_reparent_memcg
>>                                       --> reparent child folios to parent
>>                                       unlock lruvec
>>
>>     lock lruvec
>>     reset_batch_size
>>     --> child lrugen->nr_pages += delta
>>
>> This will trigger the following warning in lru_gen_exit_memcg():
>>
>> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>> 				   sizeof(lruvec->lrugen.nr_pages)));
>>
>> And the user-visible impact of underestimated nr_pages in MGLRU was
>> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
>> reaches zero, but there are still more pages.
>>
>> To fix it, make reset_batch_size() check CSS_DYING under RCU before
>> flushing the pending batch. A non-dying memcg keeps the original lruvec
>> stable against RCU-delayed offlining; a dying memcg redirects the deltas
>> to the first non-dying ancestor.
>>
>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
>> ---
>> Changes in v4:
>>  - re-implement lock_batch_lruvec() in a simpler way
>>    (suggested by Johannes and Harry)
>>  - collect Reviewed-by
>>  - rebase onto the next-20260630
>>
>> Changes in v3:
>>  - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
>>    (suggested by Harry)
>>  - update the commit message (suggested by Harry)
>>  - temporarily drop the previous Reviewed-by tags
>>    (since the sync method has changed)
>>  - rebase onto the next-20260624
>>
>> Changes in v2:
>>  - update the commit message (pointed by Barry)
>>  - collect Reviewed-by
>>
>>  mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 34 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 35c3bb15ae96..ca1e2a870d51 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3262,10 +3262,40 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
>>  	walk->nr_pages[new_gen][type][zone] += delta;
>>  }
>>  
>> +#ifdef CONFIG_MEMCG
>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>> +{
>> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>> +
>> +	rcu_read_lock();
>> +
>> +	/*
>> +	 * The memcg can be NULL when the memory controller is disabled.
>> +	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
>> +	 */
>> +	while (unlikely(memcg && css_is_dying(&memcg->css))) {
>> +		memcg = parent_mem_cgroup(memcg);
>> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
>> +	}
>> +
>> +	spin_lock_irq(&lruvec->lru_lock);
> 
> Do we need an rcu_read_unlock() here?

lruvec_unlock_irq() does that.

-- 
Cheers,
Harry / Hyeonggon


