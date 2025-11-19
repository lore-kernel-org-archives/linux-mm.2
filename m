Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CB2CF2567
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280A96B0062; Wed, 19 Nov 2025 02:43:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231026B00B2; Wed, 19 Nov 2025 02:43:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9846B00B3; Wed, 19 Nov 2025 02:43:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC4C66B0062
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:43:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E5E84DE46
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:43:08 +0000 (UTC)
X-FDA: 84126565656.14.CDE2A4C
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id B986E1A0004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:43:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l3SMmJV7;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763538187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1I7cA2fVYEnU5tKmvwQ5dB4/kePKxlMyfJS/i/M6zD8=;
	b=DGpqfj47afNUhMXDbaldXX/UJhvuA7abOrT78tYVZRKqlF4AylbYl+zcbomTI3ns1HqjSa
	HbgQQpG2+qIrZ7S3FjtnQT/urb74/8SqVPTPo0oDUt2KFrSCVjewS/boHu8FpV2PzMqH7C
	w8+lpwUaZjblS/i1LKfZJn3wQjjpmlM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l3SMmJV7;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763538187; a=rsa-sha256;
	cv=none;
	b=4BE35+dNU6GOogs5CYjp1JnUQnu7emsHGtEPzWRn5SYGrYWKz2BIxlLamF19WSha24/7k1
	axeDNKf2eAjJpghEoxuINnYG2DtJYCu0l10BB+8+CgNoJ91fO+8ReSL029nCvnlNbA/z8x
	r8HGDyYujR4lDdp7lrAVaZCbjFABgxk=
Message-ID: <938180ff-7e24-4d73-87d5-fca4bbaa4ced@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763538184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1I7cA2fVYEnU5tKmvwQ5dB4/kePKxlMyfJS/i/M6zD8=;
	b=l3SMmJV7Df/YlzQosv4zjnQtzbyfuENKua4z6s08PbQodhAK/In9ZUM9Y4NRbSBMPVkJWa
	1sExjcueECfivNB8hdidZd1kutWfWzzwrDPl+CgFixJsdFwbKXBqpujVjgPrjI/JsEU0qa
	gDayA0fLuY27pEbzURnI6Awwg70OeaE=
Date: Wed, 19 Nov 2025 15:42:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 06/26] mm: memcontrol: return root object cgroup for
 root memory cgroup
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <5e9743f291e7ca7b8f052775e993090ed66cfa80.1761658310.git.zhengqi.arch@bytedance.com>
 <aRroO9ypxvHsAjug@hyeyoo> <e5edc1b6-4c63-42c7-91ab-f1a28cb0b50d@linux.dev>
 <a64d9d17-1706-4936-8742-8ee5bc4988ab@linux.dev> <aR1wmdn013bblCN_@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aR1wmdn013bblCN_@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B986E1A0004
X-Stat-Signature: aj6joqeoksqgctr8yi6oa97zxuws7xzb
X-Rspam-User: 
X-HE-Tag: 1763538186-155682
X-HE-Meta: U2FsdGVkX1/49D4ckF6b/TABSlaK5MVK/nVSmanUK1WWgXHDKWqSUCZ4JH8Zekx2WSiqpKhJX1KLiTh4h6qQ2B2qgMpdXudxS98YXxvIIR5jssU4SRjynqpbR+vKwGGxUyxwWM5r+NKIfkmsM6wkTDRXODAEXC0NBDe2JmeLrOGZKc//+CW8ztBS9cdy2YeLYVUgpShXM3Thq/RgXTVe7gtFG6fMrPaMk0dDXetboQcX64SRd8h/6yULM30/spjBXQbafcHr/jCI+IfHc285DgAMYvopcxwhfaJceeUIca3vktrGA0HEu+Q6XNsuyqJAmVh6EegXJ1VgS+TPiqwzrIWk2B/krtkpZU1MMqFA2HZUfmjll5z+FefXmZGo2tUHVZfs/9tDRcl7GMn+4LwpbFp4qbv6GpDRRSs9dW9bpKDAX2/+Aeb7woXgZuirt82T0S7GEGgPTcLNK/LlfjVCiFWt53NNRnMpkKgP5KUn9N7eY+zdVUjOkTWxcEpkjxDxIe/qIHvyEu153aTdY6EGDBJr08WHPBBX6RTQ/pgoFg83A6MwqUZK5q+YWJ1Xqb2oDaP2op7Iu7UJ+aAtf7PqJWFpaoqJAqwzn/FpFxoGBMf3sU9gmuooNh0ApF7jGcQEU6G5Yw+nUNJNtkEZ4q/HFmqQ9yhom6guPYJSelPIbEwHWY4MpfESgd1G4d43PlUo8LOtKZO7GE+PcICUowzvNv4JDJ8QaZo0jLgKMrN3I4g3jtF2moNYchVnotINA9me+1wkRCQ/96KKNpuUXyPolzg2risYa1koV2AMmepAchfgvdYN11f2jCKKYYp7gtWb+12CucNr+56/9lwDfAP01d/jzAFae3fzHMus0JF2ME9gb7rxPOjsDmfaUGbRACJ8Tc3y2Zxtq0zu01sRVIHcC79wEhpH4BsbzAR/hNEG9c2RwLG29Mkvm9YjpBfOnLPevJt/jmrOxCS/H7o/xOq
 lZu4GY76
 +eaVcKyLK4kgEEMr/042sgtRhECSkAjPostk7ly9PNRJUWgQReYYNwi8ozz5WdxxLp92PQOCktcqmpTAHsr/XgmD/83rbipy+v6FyfJpMm5fdtU4HlU29ZdQ7Knk7Lk0bCSip3rhAnTL1zHZRA7k8Rsp8BKC8iE5LoxZbwkwV6CNxrhxhHx68qP2aqIUU52SPucmNBiGUvNuNHGxkWa4TbZ4rOC6AkI3jxtxmKGlCiBpdTaWaB4cY8GWOC5NudJADIAUE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 3:24 PM, Harry Yoo wrote:
> On Tue, Nov 18, 2025 at 08:11:04PM +0800, Qi Zheng wrote:
>>
>>
>> On 11/18/25 7:28 PM, Qi Zheng wrote:
>>> Hi Harry,
>>>
>>> On 11/17/25 5:17 PM, Harry Yoo wrote:
>>>> On Tue, Oct 28, 2025 at 09:58:19PM +0800, Qi Zheng wrote:
>>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>>
>>>>> Memory cgroup functions such as get_mem_cgroup_from_folio() and
>>>>> get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
>>>>> even for the root memory cgroup. In contrast, the situation for
>>>>> object cgroups has been different.
>>>>>
>>>>> Previously, the root object cgroup couldn't be returned because
>>>>> it didn't exist. Now that a valid root object cgroup exists, for
>>>>> the sake of consistency, it's necessary to align the behavior of
>>>>> object-cgroup-related operations with that of memory cgroup APIs.
>>>>>
>>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>> ---
>>>>>    include/linux/memcontrol.h | 29 +++++++++++++++++-------
>>>>>    mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
>>>>>    mm/percpu.c                |  2 +-
>>>>>    3 files changed, 46 insertions(+), 30 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>>>> index 6185d8399a54e..9fdbd4970021d 100644
>>>>> --- a/include/linux/memcontrol.h
>>>>> +++ b/include/linux/memcontrol.h
>>>>> @@ -332,6 +332,7 @@ struct mem_cgroup {
>>>>>    #define MEMCG_CHARGE_BATCH 64U
>>>>>    extern struct mem_cgroup *root_mem_cgroup;
>>>>> +extern struct obj_cgroup *root_obj_cgroup;
>>>>>    enum page_memcg_data_flags {
>>>>>        /* page->memcg_data is a pointer to an slabobj_ext vector */
>>>>> @@ -549,6 +550,11 @@ static inline bool
>>>>> mem_cgroup_is_root(struct mem_cgroup *memcg)
>>>>>        return (memcg == root_mem_cgroup);
>>>>>    }
>>>>> +static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>>>>> +{
>>>>> +    return objcg == root_obj_cgroup;
>>>>> +}
>>>>
>>>> After reparenting, an objcg may satisfy objcg->memcg == root_mem_cgroup
>>>> while objcg != root_obj_cgroup. Should they be considered as
>>>> root objcgs?
>>>
>>> Indeed, it's pointless to charge to root_mem_cgroup (objcg->memcg).
>>>
>>> So it should be:
>>>
>>> static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>>> {
>>>       return (objcg == root_obj_cgroup) || (objcg->memcg ==
>>> root_mem_cgroup);
>>> }
>>
>> Oh, we can't do that because we still need to consider this objcg when
>> uncharging. Some pages may be charged before reparenting.
> 
> Ouch, right. We don't know if it's charged before reparenting and so
> it can break statistics in a few places if we skip uncharging it after
> repareting.

Right.

> 
> And I think we don't charge new pages to objcgs that satisfy
> (objcg->memcg == root_mem_cgroup) && (objcg != root_obj_cgroup)
> after they're reparented anyway...

The charge and uncharge operations must be symmetrical, so we cannot
control the charge operation independently.

Otherwise:

charge
======

if ((objcg->memcg == root_mem_cgroup))
	skip charge this page

uncharge
========

we can't decide whether to skip this page.

Thanks,
Qi


> 


