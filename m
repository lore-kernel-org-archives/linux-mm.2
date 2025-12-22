Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B11AD711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADF06B0089; Sun, 21 Dec 2025 22:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983CB6B008A; Sun, 21 Dec 2025 22:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB1E6B008C; Sun, 21 Dec 2025 22:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2396B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:55:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FD3260A16
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:55:24 +0000 (UTC)
X-FDA: 84245742168.15.7543579
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 48D3B1C000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:55:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y5bED2PI;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766375722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xqiag8fioZOe9NX9oHRHaDgP//h6CBY1O8QvNdZ/XU=;
	b=WoSDhVi638doaNyj3V9Ne94gbDq6Wzh3/i2bjCf4wUZCRY57EM0Cte38Ud+pwMS4ymf5N5
	JqlYHtm63epU+JQ2d7xtGjbnDXuoEhyQ4jJkBwaoVTYyXL9zL+8yWlsb7Kz4OOF1h9kxQy
	FLFWwbRwzJADgJmenPhlbsjjOckTADg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y5bED2PI;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766375722; a=rsa-sha256;
	cv=none;
	b=pWWs7uOBbsu14/eqbDJCfrfcJiii1wmj8enOhWalSJ1XLhRXdHOkRxWlw4fkMqScfgoYDE
	Tfr0yQrVdrTAzWBHMxPAGsUjufPc6I/9m/x+3RNbp/MR8s03WwIDaH6pV2uB/PffFNzRoY
	da58MceHaZslVKSQknVYhtZAsMKi3RM=
Message-ID: <00f47523-e458-4e9e-8354-1c33bf0591b8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766375715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2xqiag8fioZOe9NX9oHRHaDgP//h6CBY1O8QvNdZ/XU=;
	b=Y5bED2PIdjRswHhz5ri86a3xuzcsAPrgnCBsf4HQ2FgRrsukkrTd76VX+FYh4x8wwvB3mB
	Fp0g52FAQ4i9IXYKS3Wfsv3Z/gRuJqfBuAroC+gLllj/yblELd8z0vYQDuJxl3RR9vHMIb
	vIkXAJSjU0i86jfI3sXnHuPHndBX8mM=
Date: Mon, 22 Dec 2025 11:55:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 24/28] mm: vmscan: prepare for reparenting traditional
 LRU folios
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <800faf905149ee1e1699d9fd319842550d343f43.1765956026.git.zhengqi.arch@bytedance.com>
 <aUQCfdnoLQDLoVyg@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUQCfdnoLQDLoVyg@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ib5roktsikrxenfqir1owztcc9e67y5u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48D3B1C000A
X-HE-Tag: 1766375722-141973
X-HE-Meta: U2FsdGVkX18072fonCT15T2120LY5crOOeQCCaeOuibP9pHf6ow+oReREvzaud17Kr6NvwGjJPG6YdTXS3VfTYnYv3DjFziiYe7xWLfkkzlv4/tB1WE2PRxFiYfOWPqvg+de9nqR16JZ7kxWArgDJbGsnXzmDtEGUG7lhcQQFtJSpR62vUJEgiUbafXM23uqRagx6gbgUIoKqA1f070Ks6od1paj0rkO887PoLPqfMVrYM+cKSsQoKM8IFwjoZvITm/rfC0ixpm9gxilq1qwps8n+WfXgl4uXni+OAzaKlX2oNJ8r8qDBgzeQe0CM7eUxeXC6e3h6o+rMyrUp/HnmBymaGii+sE91ajbVSR73bi3uqu4HDhTOWsraO9xB+GUI/jd5cHvmWsnaQh3jKgcgBFESoBvEb4LjsbMve32c2l1UbPOrntztVwpQ1VjpgxFfN/JxDdo1ujUPUvqI6hBec2gnMu2X72Tfp4SHgGnnwSymkV/oolzVLzKxU6VUDQyiIRdJ29AIYaA5P75/X0pFaPcCtXkyoUegHAQ+hzuLbEiZWdnOcRzoECptSV0yEpkF+htGXMsU0IcDbCj1KxBh4mL4FAxW8qN9j5cBwbNbCAtoht+00+1avXigIRepPqnINlRJVOnWOpo2TLNXdp1+HdlPWJaa01y/esYmQ1whRCdSSUlBQ/az+zZgbMtldYxqon7XZ19BRYnisam2vq1OFkrE/79tbpGmCdIe2E/1ltFPinQHxBJemT7Zg/EIv+iKF0n2FYukaO0CkJsFwMeZpL/rxPfz2dH4fVromi0/O2xDE3q7f60d+4y4gUPfxjLQeNuMx/7k9vkFfaB9q0aUPARjRwHPuvdx12weQ9x2J8lT2fHr8uqIxxbb0cPaGMdKmhH2AXakWFIUOG8VGkSdAWiKTNHJcV6kLiMf2kv3bEWeLIU575/3PujH4y/6AV+XyBRETdGqmzcmHun9+t
 qMtYWEiZ
 67FhJrcsdioXj6aQIsz0l7sf0H4vEAu/1jAy3jTZ/65gF7uh2Xs1M/Avcoluy3ZG6zyf1gF9niGZPJXyBA9fdlY/NIN1mmyciq6yBmVdLegEUFiIWdcENHPGsskwyIEwgll5fLDHDZcTdY1P7978BBG8cmwvH0PUXwvPcQu3SVrbmwF+mJp+Wak1qXpUS0nmTYBAwU1jbk9h/C7lmztjTzxUN3ChEFPSrlHZJ1Imo1pDK4M2EaCLzd1TzNKnWBPSY+A59jSbZvjuudXu9SXH4F57zlnlm1JGBn7UrYtLLiW7OIO93JjUyMyEEGCgIVtbXPooa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 9:32 PM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:48PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> To reslove the dying memcg issue, we need to reparent LRU folios of child
> 
>       resolve

Got it.

> 
>> memcg to its parent memcg. For traditional LRU list, each lruvec of every
>> memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
>> is feasible to transfer the LRU lists from a memcg to its parent memcg
>> during the reparenting process.
>>
>> This commit implements the specific function, which will be used during
>> the reparenting process.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Overall looks sane to me. I have a few nits below, not nothing
> major. With those resolved, please feel free to add
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks!

> 
>> @@ -2648,6 +2648,44 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
>>   			  lruvec_memcg(lruvec));
>>   }
>>   
>> +#ifdef CONFIG_MEMCG
>> +static void lruvec_reparent_lru(struct lruvec *src, struct lruvec *dst,
>> +				enum lru_list lru)
>> +{
>> +	int zid;
>> +	struct mem_cgroup_per_node *mz_src, *mz_dst;
>> +
>> +	mz_src = container_of(src, struct mem_cgroup_per_node, lruvec);
>> +	mz_dst = container_of(dst, struct mem_cgroup_per_node, lruvec);
>> +
>> +	if (lru != LRU_UNEVICTABLE)
>> +		list_splice_tail_init(&src->lists[lru], &dst->lists[lru]);
>> +
>> +	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
>> +		mz_dst->lru_zone_size[zid][lru] += mz_src->lru_zone_size[zid][lru];
>> +		mz_src->lru_zone_size[zid][lru] = 0;
>> +	}
>> +}
>> +
>> +void lru_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst)
> 
> I can see why you want to pass both src and dst for convenience, but
> it makes the API look a lot more generic than it is. It can only
> safely move LRUs from a cgroup to its parent.
> 
> As such, I'd slightly prefer only passing one pointer and doing the
> parent lookup internally. It's dealer's choice.

Make sense, will do.

> 
> However, if you'd like to keep both pointers for a centralized lookup,
> can you please rename the parameters @child and @parent, and add
> 
> 	VM_WARN_ON(parent != parent_mem_cgroup(child));
> 
> Also please add a comment explaining the expected caller locking.

OK.

> 
> Lastly, vmscan.c is the reclaim policy. Mechanical LRU shuffling like
> this is better placed in mm/swap.c.

OK, will move it to mm/swap.c.



