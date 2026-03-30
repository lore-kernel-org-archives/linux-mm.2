Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A55FF492D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 02:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3696C6B0092; Sun, 29 Mar 2026 22:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341BE6B0095; Sun, 29 Mar 2026 22:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E586B0096; Sun, 29 Mar 2026 22:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12ED16B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 22:22:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B401213B67E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:22:49 +0000 (UTC)
X-FDA: 84601131258.26.5661D5C
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A64714000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:22:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jTeCSJl5;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774837368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwwdgUXzTzQtwufI45UcdtS6s0KoKMxy/JsyfHLNcVQ=;
	b=eiY0p3VemfCOw8WVZhYAVqXYggSA8ak1ZQrycfh+cUvsJ5zLlhRq7v9TsjilmosHg2deSA
	5phWQYBfZikeSRQmN7TDwpLeUcL4Ae/Wc8vQWmamxDsVBt6vZr9LLyLba0iGkJM0JEOa0C
	eeFxBHUmsX2jKcb9ON5s7Yyy8CN0chg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jTeCSJl5;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774837368; a=rsa-sha256;
	cv=none;
	b=i9oR4GqFt14lkCHfglOSzd/SFZocO2L3kNpOXlsM09SKLdGWdsNa7o19ZhPHTSUzXRlrhc
	ksSF9GnkU/izTYa6L0xxpVHz2C8fcRQncia6G/kyPyC9c1Fx5S10hc0KTUZUsczBEJd1Vl
	m2Le3+HVmoj717MszsuIYsLPnFMoi74=
Message-ID: <d54de91d-f8f0-431b-a0be-37b3cb775c4a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774837363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwwdgUXzTzQtwufI45UcdtS6s0KoKMxy/JsyfHLNcVQ=;
	b=jTeCSJl51LLSZGNHjEQ+/4SvIRe6LhNVL8AggyORyEWLvqoCRqa+x4mi8qimwbsqauoEcj
	OxVXD4a9gsqkNDTvBulgVIuJoBL2TpQ+iSlW5XWepAsLjKit+NBRr23tArgXTywzyEV/DR
	RUv4p08/hwRMvV3UZ+9ShCWktxLDwys=
Date: Mon, 30 Mar 2026 10:22:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/3] mm: memcontrol: change val type to long in
 __mod_memcg_{lruvec_}state()
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
 <70a9440e49c464b4dca88bcabc6b491bd335c9f0.1774604356.git.zhengqi.arch@bytedance.com>
 <acnRDhkGy4JXb_74@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acnRDhkGy4JXb_74@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A64714000E
X-Stat-Signature: p6hdym8bu379891f48t4nkr798o6ocmy
X-Rspam-User: 
X-HE-Tag: 1774837365-647956
X-HE-Meta: U2FsdGVkX1+fxMsiZsf2yOOda29JINQqWY5sBsBsgEsVgSrybq8kNeYSIPgmub2w5exJAiUKlW8JNlYDVsmMcuto8p7GGEufOQdFXOEzu7zDKa4ZyGd/QKe+yMobEU2t73hR9nZfKRAGwfP55qDrSFkVv2wGwkzOFk4KFYt6cpV7c3rmVklw/m3uMm5OybfBp7dFIgwek9aKqhl8TfUl2rzGBdceOKgeAUl+0IgckGnqqr0QMaiVCCMLyK8p0YVV1aQs5xvPIHy+kDKoHzpG7Lxui4BJCpvIlDmKSqLAiIvLe7EaGszIvC1fibeJLwgvuTqg33f5n110M/jXb6FsxFiCj7TUEBhQXRq220ByL1maoUdoRRDsdnsaJEv6scoqGGqoEsw9AeEEWHypWZJcGc2pykuZy7CbVIHT530gdteKpdDGs1amGTzUM+fKnsSyks2E9vkpVMezH5zst1DOezdgAP4e5UIJbIvwwWx2/rPoMgcJoxB29R9eWdVXYsxC/fqM0FcK5PdLg/9pfELUv+TCjlRSMS8ciE58bsgDPO7O7SuGdt5BmlBLlKFOl4943orBJGa3Dm0x6yhQjKoBRySl9BJwmmBh49IgO/hqDIKb1q6ZPbgOFYF0k6vGxK9Tpi50MBKHqgtokABu5AzCzaOmH8AsVJWeaNccDFSPKAaIw9BRypikkoCyESc3I75e/skdfIop29hwCSq36cGB+FIxR8yPLO4tTfYNbIxTGudEGCsSvTkZW5DIaL5FKVdNuvBmoHWxGSDgW1EWbWpexdNLUmebw5jN633B29oj8b7O+55axQ1zu6KRdYCHAMqOzVQIcG7TZvi79P92JzzK/1aEHZf+uxyuip9BJxDlgYnHAWHJKNYsi65+NQPDZ1V9ljC9gGzNq/4HW8dM/xxzsz5wheHX5J9kAHJwUUXxAZ5HiOVqP2vdHbgFmk85f3ytewP066AYxFlPiMlF3jC
 eivOg4D+
 Zm6DZHvdcxXcGPtUHQXyH3SdLBEX51HSsY+JUJ+bjjV0ROOb9CXeHSizKracWWbdNUSRLnH7xJTlfa1pl4nZTh/B8HHAppAtPt4pHVF1eodollx5V/rIff9Q5yV6Z8BGA+/nK1SyIxHxnw/chvQTR32ndYlVX6tFCmyFeN3Ma0A3fTSFeiP9z93BuO13BY05ilnopcf+vaQ8+FxGq02OjLN3xMhMx1c7qtdZ6LA1bXZ08usPhFRG7RvivvJUJCtW6hsAvSKuKZ7nMCP2sf7gsCNtzAYpeALZ9d1pNzbQOSyAf1Ss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/30/26 9:25 AM, Harry Yoo (Oracle) wrote:
> On Fri, Mar 27, 2026 at 06:16:29PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The __mod_memcg_state() and __mod_memcg_lruvec_state() functions are also
>> used to reparent non-hierarchical stats. In this scenario, the values
>> passed to them are accumulated statistics that might be extremely large
>> and exceed the upper limit of a 32-bit integer.
>>
>> Change the val parameter type from int to long in these functions and
>> their corresponding tracepoints (memcg_rstat_stats) to prevent potential
>> overflow issues.
>>
>> After that, in memcg_state_val_in_pages(), if the passed val is negative,
>> the expression val * unit / PAGE_SIZE could be implicitly converted to a
>> massive positive number when compared with 1UL in the max() macro.
>> This leads to returning an incorrect massive positive value.
>>
>> Fix this by using abs(val) to calculate the magnitude first, and then
>> restoring the sign of the value before returning the result. Additionally,
>> use mult_frac() to prevent potential overflow during the multiplication of
>> val and unit.
>>
>> Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

> 
>> @@ -831,7 +837,7 @@ static inline void get_non_dying_memcg_end(void)
>>   #endif
>>   
>>   static void __mod_memcg_state(struct mem_cgroup *memcg,
>> -			      enum memcg_stat_item idx, int val)
>> +			      enum memcg_stat_item idx, long val)
>>   {
>>   	int i = memcg_stats_index(idx);
>>   	int cpu;
>> @@ -896,7 +902,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>>   #endif
>>   
>>   static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>> -				     enum node_stat_item idx, int val)
>> +				     enum node_stat_item idx, long val)
>>   {
>>   	struct mem_cgroup *memcg = pn->memcg;
>>   	int i = memcg_stats_index(idx);
> 
> Some of code paths that calls mod_memcg{,_lruvec}_state still passes
> int values (which is quite subtle to notice), but it should be fine

Right, it happens in too many places, for example, the callers of
mod_lruvec_state().

> as reparenting is not involved in the path and could be cleaned up later.

Agree.

> 


