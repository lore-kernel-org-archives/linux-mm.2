Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8556DFEA82F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C296B0005; Wed, 25 Mar 2026 03:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE056B0089; Wed, 25 Mar 2026 03:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8032F6B008A; Wed, 25 Mar 2026 03:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 698CF6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:27:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0A6B1607E5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:27:12 +0000 (UTC)
X-FDA: 84583754304.16.FDBFC15
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D7BE41C0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:27:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=guzOAPQq;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774423631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxT8crAtAWHT1Y0DjEeladDi+Mk4USm8O2CuoWFzL3c=;
	b=2ibfVBgRJt2q8Gv6NvPgsEM6BazGsviZbFvzIEZDSKEQJRITwJp+6k3NBv+PtW5PCV1WaE
	FFd3T5x+uWNTS45pwW/kjNjidvcrAu9LyljSVdiTpL3Jqm0PJJDo6vm89E95iNbYMN+JcW
	9fN+OI6oba7kZ+oGIm17VnfLpNBJKUc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=guzOAPQq;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774423631; a=rsa-sha256;
	cv=none;
	b=IB/dzQAUIyOseBWgKoY9D/wxnuBd5fYxldIQccsQDzn5+x4uHbwX2mNT5AWhmqtCPAXH5f
	QSbwP8AfGdIITps7iClwvq+X2i4i8bfaxyDdXw+56+Ex3Yz4qqtfkVl5v2YSwey9rRw9OO
	z/4zisG1Xd4LzeLF99Y+zDdxby35pIU=
Message-ID: <d86749f2-c4fb-4c7f-b630-27fca222066c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774423628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mxT8crAtAWHT1Y0DjEeladDi+Mk4USm8O2CuoWFzL3c=;
	b=guzOAPQqXXAYWBVhbYx6yBWSOGmKidsvRO6IJG2ETMZw6DEvalHDZEuBjyJIPjH3vHvrMn
	MT0V3231oMus0jf5KwCTgxZrgEEyKqdEyBw4P5bBfEFNIRe4mcJy2yPAv+0y7xZavCe01M
	CDV+K8VsUa1OKf3KuYzoMtdhuRPn0qg=
Date: Wed, 25 Mar 2026 15:26:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] mm: memcontrol: correct the parameter type of
 __mod_memcg{_lruvec}_state()
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
 <acM93qmvDFofjWdM@hyeyoo> <5a9d9152-8e23-4438-a322-ec524fd159a6@linux.dev>
 <acNv8w-xNWwZHVo9@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acNv8w-xNWwZHVo9@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7BE41C0005
X-Stat-Signature: hjnejihyzh8y3htnzjrzbjou1af4sj4c
X-Rspam-User: 
X-HE-Tag: 1774423630-397320
X-HE-Meta: U2FsdGVkX18W/vFqMRFxRi66KUC9Sdds+OwNQ9QpkJydW4nEJeV8NLDk2vUn4EmbPNH/dtwtu6EfQZW2mGbGeMN+yLo9UFSnvF6YGIQUq2jutSp5XHBpZD6evvFL9IWRw96gverDKwbtUkLenJB93fBlBbeVrweJ6ofFMXbAW4FDDnx9monoGUFTFNOoVvdEYdaUx13Ja9B6sza8oHmV2x89lF2IbW+rt/M93DyKV6rwlew6gjSLYRqHDtnuXJKgi59epRBJBFaS54VuiD06KU5FP6iF6WPJwkWbZfkZnJTQSmLSsLTtiyne3WRYrsAUpf2Is8HMcvQfVe6UI46AY3C9Dq85gsXELXpNM1IQRDt4KYLKBjib75HcQjnk1LXZUxPtO+9XhNz1Dh85PonjxdR28pk3LGv/ti/yPwY8QLF/8636HY6aKFZdf6T3DPytXNx1Np5WfjLPxWWPJ13aXKKS/aydWXAaMIWz3PIsTVDY1P4jhFr4mZw447lgh2h4vjut5eTFiiJCDvBZgEyVm6xswXI5uHK49+g4EoFitPyEej1nYmBCZiYGc50vi8HVwiNjJ8ICWCieJIwu848b0YqZpto7fAJXYYo9mImjbJK82X6GxDq9zcPEGO8IRhh0h/KM2zCQ4Atl5cnku51bVySmW2JmG/qL2UTD0teOybmQPXNj/ysG4dUlRPibqv1ybDY8C+t76XNGXcwazkhkRFsioj+YEPpQ5TWhyVkcPhtyPJalwiLnUG/4IwqgW9d5Fz+qqfMQuThTEAvrluakwvKr1EFUmyNn4ZhTlZCFDb3Om0lir4QGwx3qlnacK1Malt0Q0zBCKF41/oU7fNCQF5bHKq1RntrLPsj4F+pHqIPx++QiD01tc0Hg19s+vhagUXPO2ZRAbghxAsQHdFeRlg8MzPN1gTlI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 1:17 PM, Harry Yoo (Oracle) wrote:
> On Wed, Mar 25, 2026 at 11:25:06AM +0800, Qi Zheng wrote:
>> On 3/25/26 9:43 AM, Harry Yoo (Oracle) wrote:
>>> On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
>>>> reparent non-hierarchical stats, the values passed to them might exceed
>>>> the upper limit of the type int, so correct the val parameter type of them
>>>> to long.
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>>    include/trace/events/memcg.h | 10 +++++-----
>>>>    mm/memcontrol.c              |  8 ++++----
>>>>    2 files changed, 9 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index 7fb9cbc10dfbb..4a78550f6174e 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>>>    #ifdef CONFIG_MEMCG_V1
>>>>    static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>>>> -				     enum node_stat_item idx, int val);
>>>> +				     enum node_stat_item idx, long val);
>>>>    void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>>>    				       struct mem_cgroup *parent, int idx)
>>>> @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
>>>>     * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
>>>>     * up non-zero sub-page updates to 1 page as zero page updates are ignored.
>>>>     */
>>>> -static int memcg_state_val_in_pages(int idx, int val)
>>>> +static long memcg_state_val_in_pages(int idx, long val)
>>>>    {
>>>>    	int unit = memcg_page_state_unit(idx);
>>>
>>> Sashiko AI made an interesting argument [1] that this could lead to
>>> incorrectly returning a very large positive number. Let me verify that.
>>>
>>> [1] https://sashiko.dev/#/patchset/cover.1774342371.git.zhengqi.arch%40bytedance.com
>>>
>>> Sashiko wrote:
>>>> Does this change inadvertently break the handling of negative byte-sized
>>>> updates?
>>>> Looking at the rest of the function:
>>>> 	if (!val || unit == PAGE_SIZE)
>>>> 		return val;
>>>> 	else
>>>> 		return max(val * unit / PAGE_SIZE, 1UL);
>>>
>>>> PAGE_SIZE is defined as an unsigned long.
>>>
>>> Right, it's defined as 1UL << PAGE_SHIFT.
>>>
>>>> When val is negative, such as during uncharging of byte-sized stats like
>>>> MEMCG_ZSWAP_B, the expression val * unit is a negative long.
>>>
>>> Right.
>>>
>>>> Dividing a signed long by an unsigned long causes the signed long to be
>>>> promoted to unsigned before division,
>>>
>>> Right.
>>>
>>>> resulting in a massive positive
>>>> number instead of a small negative one.
>>>
>>> Let's look at an example (assuming unit is 1).
>>>
>>> val = val * unit = -16384 (-16 KiB)
>>> val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
>>> max(0x3FFFFFFFFFFFFF, 1UL) = 0x3FFFFFFFFFF
>>>
>>> Yeah, that's a massive positive number.
>>>
>>> Hmm but how did it work when it was int?
>>>
>>> val = val * unit = -16384 (-16KiB)
>>> val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
>>> max(val * unit / PAGE_SIZE, 1UL) = 0x3FFFFFFFFFFFFF
>>> (int)0x3FFFFFFFFFFFFF = 0xFFFFFFFF = (-1)
>>>
>>> That's incorrect. It should have been -4?
>>>
>>>> Before this change, the function returned an int, which implicitly truncated
>>>> the massive unsigned 64-bit result to a 32-bit int, accidentally yielding the
>>>> correct negative arithmetic value.
>>>
>>> So... "accidentally yielding the correct negative arithemetic value"
>>> is wrong.
>>>
>>> Sounds like it's been subtly broken even before this patch and nobody
>>> noticed.
>>
>> Thank you for such a detailed analysis! And I think you are right.
> 
> No problem ;)
> 
>> The memcg_state_val_in_pages() is only to make @val to be in pages, so
>> perhaps we can avoid the above problem by taking the absolute value
>> first?

For more clearly, here is the diff:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6491ca74b3398..2b34805b01476 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -787,11 +787,17 @@ static int memcg_page_state_unit(int item);
  static long memcg_state_val_in_pages(int idx, long val)
  {
         int unit = memcg_page_state_unit(idx);
+       unsigned long uval;
+       long res;

         if (!val || unit == PAGE_SIZE)
                 return val;
-       else
-               return max(val * unit / PAGE_SIZE, 1UL);
+
+       uval = val < 0 ? -(unsigned long)val : (unsigned long)val;
+
+       res = max(mult_frac(uval, unit, PAGE_SIZE), 1UL);
+
+       return val < 0 ? -res : res;
  }

  #ifdef CONFIG_MEMCG_V1

> 
> That would work for memcg_rstat_updated(),
> but not for trace_mod_memcg_state()?

Why? The trace_mod_memcg_state() seems to accept 'long' type,
am I missing something?

Thanks,
Qi


> 


