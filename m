Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63804D68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1046B0088; Sun, 21 Dec 2025 22:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D613D6B0089; Sun, 21 Dec 2025 22:34:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46D86B008A; Sun, 21 Dec 2025 22:34:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6D116B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:34:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DD401A09F0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:34:11 +0000 (UTC)
X-FDA: 84245688702.11.73B1B18
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9AFC2180004
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:34:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VMFlsarU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766374449; a=rsa-sha256;
	cv=none;
	b=chlGv9zOPvo7ny6XBk+6OnBpqsHkH9FfDFsTJaI/BamcIUoj+VTTRu4Xk3xxJGF6kQc3UK
	5HyY5+lq7CvC3Ne0Ske5CLQ9fXUYGZQRV0/FyclIsf7tL7XMp//hdRUzrwOxSo2ANF75CG
	Wu1Zc/BNAhHNDvJU2K5DPaz38QK8Ur4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VMFlsarU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766374449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGqa+G9yooe1hEmvBfRcJmjA7QA8SkNJctdApIJNl98=;
	b=lhJ5ijTFfWQeGPqabYdUcQUxiIjMoesbQCZKsROH1oSLR3P0eglKp8nbcXfwtH7bRSK7UR
	iH34QBiYiREj2ob4z+FLfsnm9yy1UnN7fEpf91XN7d5zMgcRtqanU7Lu1LbuidGcgswgsg
	KZJrt4e9Mc28Jzh5ovNFJJKB9s400as=
Message-ID: <75f31ec7-1605-4f50-9adb-6d84e9e81101@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766374443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGqa+G9yooe1hEmvBfRcJmjA7QA8SkNJctdApIJNl98=;
	b=VMFlsarUjmbbIJb0UCStjyxyJrACCyd77zr3JpIq+0OrxRPujQeEJ28zq7ZaQcUjjSRK+m
	45woNINIu2xTjOA9jAQGZrhluNaExT/eu5KnzscPJgAt2nP00wenDmKJuQiyJw2LbGvIUu
	PXSVuQFB4EVTsQET3xVVnLZC6boeT7A=
Date: Mon, 22 Dec 2025 11:33:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 17/28] mm: thp: prevent memory cgroup release in
 folio_split_queue_lock{_irqsave}()
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4cb81ea06298a3b41873b7086bfc68f64b2ba8be.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMuRfPVxkfccdmp@cmpxchg.org>
 <ejywj2fho37z4zdtgvryxzsztgtdrfop4ekenee4fewholyugq@xrbvtg5ui3ty>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <ejywj2fho37z4zdtgvryxzsztgtdrfop4ekenee4fewholyugq@xrbvtg5ui3ty>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9AFC2180004
X-Stat-Signature: r9gg15g4a41ks99uyeywekni8fmsqytz
X-HE-Tag: 1766374449-964316
X-HE-Meta: U2FsdGVkX19UvgMzl2i6RfZ7jv8wq4YknXtnlzn4scf+zOs+6vZdL5LP3WaoJQeulTlWGcbXaSEEQerYFjm8mVLfUBfU4+gxQsUJ0ifvyFqNZy5FpkZh9VoAbaFHqOoUn72TDUq2DNSrrMogHiEJkLr0WEPVI0vxh7yHQ4ZnicP1+ePR3jbap7OXo0241duGb871sohmA/brvye2hinYY5g656FF0igcAmzWakZ77VZPHANtOpPUtzxe/wZKAEk/XBswxDrcmmvGDBN9xJWwy9Q1GAwLsxiaqL2ECxjU5yXfFxLO9Xre3yvm2QLIenB33PRcEd8cXlqV1VVh38xevoJSKYwLFvE5a1bwhBUIQeKOchPyy4K6r35UGeMJrNGg7dCkZ5BRvCAIlOoN6hVHA1fZETRbv4R0Ea3ZBD4Nn7PJ3uYrjai25HLxqlR3C9hThQZiDn/hnbg+T7GGV83VRAmX0m2UGAb3sbSzLPITlwlr2ISyLfrom3IIxQYORH6ozuQcKTeQUP1Q7Ntp2iFX0vu3p2Ynbeh9PidAhm/lUk0MXg7dIqxfvx3WT/mZ7UuhGB4EajYH8NBt/95BVDZ/wIsbKqspPzOYCDbZFiWUI+6zMXQ75UI314a1skV1mIMBl0HdvvAg+gZFzgwjUSIotBIto1oLQXgRCyh9W7IuW2Xu8WBSKQDW8gyeqiUWLIvNQ49f++lMryeIGkBJrGe+wtFdfitH+CE+D9XITCSFb2FCGPG0Fe+F8Gy5dEp3+UI8/a70TDEltVClk7Y8xzmWj+3QkIw7GjrJDe+895998Au8hfmgwqMucGK9b10e+GjCgb008Lo94cAVc0vZMNZyGAdmXLTIJaUdx9OrbrU1d36QE1bXOJDun+wDhrcfsVoDObw7n7dZ9qVGoq+lbJqhukcLo8voP/lxbVUIkx6lRPzVliLFVxSmNrVvP7V7WF2ZM9gfxFpN0UBNZkrPxUR
 mVMGXTRu
 l8Qn0y/ro/jTv2xrQwOKmuj83J6kTLiy+0Eb6k8eZrP1O6JneYbcXYMibfQ0IIHE4qcMDA7j/+0QHWTy33OEW65in1UISR4m/aDjnvcQ1yLumYYsbbpogwVyVpPnLX4ztTn845SM2RvgyUM1NN5SlGN1PnIIrR97nSaAUbLQzMVGUTOZ1hDWwTMTNZnPRd5rkAk303OWvDWoiB4X9jNGIDDUOwLYdwWDpuXZvtKPbN4SHJgN27JmWXBUemHk1Nlkz75/MeYKRWFwzM8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/20/25 9:11 AM, Shakeel Butt wrote:
> On Wed, Dec 17, 2025 at 05:27:17PM -0500, Johannes Weiner wrote:
>> On Wed, Dec 17, 2025 at 03:27:41PM +0800, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> In the near future, a folio will no longer pin its corresponding memory
>>> cgroup. To ensure safety, it will only be appropriate to hold the rcu read
>>> lock or acquire a reference to the memory cgroup returned by
>>> folio_memcg(), thereby preventing it from being released.
>>>
>>> In the current patch, the rcu read lock is employed to safeguard against
>>> the release of the memory cgroup in folio_split_queue_lock{_irqsave}().
>>>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>> ---
>>>   mm/huge_memory.c | 16 ++++++++++++++--
>>>   1 file changed, 14 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 12b46215b30c1..b9e6855ec0b6a 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -1154,13 +1154,25 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
>>>   
>>>   static struct deferred_split *folio_split_queue_lock(struct folio *folio)
>>>   {
>>> -	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
>>> +	struct deferred_split *queue;
>>> +
>>> +	rcu_read_lock();
>>> +	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
>>> +	rcu_read_unlock();
>>
>> Ah, the memcg destruction path is acquiring the split queue lock for
>> reparenting. Once you have it locked, it's safe to drop the rcu lock.
> 
> Qi, please add the above explanation in a comment and with that:

OK, will do.

> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!



