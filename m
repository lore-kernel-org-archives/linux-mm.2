Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9172AF532D0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 04:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00366B0005; Tue, 24 Mar 2026 00:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB12A6B0089; Tue, 24 Mar 2026 00:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC71E6B008A; Tue, 24 Mar 2026 00:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADAE26B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:25:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 501BCC9FC8
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:25:43 +0000 (UTC)
X-FDA: 84579668166.22.52E5E11
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C242100003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:25:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VCisPo8C;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774326341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFm4rq63hk/RC8ec4idA1Wj6bRsPq9bmm+kOdtLr6mE=;
	b=gcljao3eG4K/34MN5Mcqk9XuSU+SQxTFeSQVoAzZJBhubpAX23ih2LUejw4NPyGyqrS4cW
	L8FXFfgPfXFsJ7Hr6iTOem5o7ekHLMHfxnm0RlQ/NSfWzqJaikI5/yZsY+2FrXzFL9xEv+
	jdyvfmHT0w/FnnMArTZADaDZPeBbDQI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VCisPo8C;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774326341; a=rsa-sha256;
	cv=none;
	b=FF6m4gTb8OrojjBS7QZwl2tdxrBU/uE2fzJyjClnEfqVNzUGtDeTkGRY02cVm9vx54qAUT
	P+IcNBWbNv+cYApMuOXs+4N840iIIxo9q5Lwf4CkuZJVAA51ejMrzHwIhGwDrH+Nr54Aku
	t+QwzECECw6+inVd/zNstQ0fpzmNpEE=
Message-ID: <138d9363-ab0c-4f5c-bedc-b326f5aaee91@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774326339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xFm4rq63hk/RC8ec4idA1Wj6bRsPq9bmm+kOdtLr6mE=;
	b=VCisPo8Co7n3knIGM0A0ZVk9KeDhkyF3dYJNyIngSsxp5cgCjpBS2vBIAqIineGlMW265t
	Uq314LeejaqmyZiE6GvJye2uYRmVqRhgEWRLaTivnDDhugIdiI4luxhrqq66i5SUKZiMwj
	nIUZDYgdo3d05U+icbURkSf2M1LGkwo=
Date: Tue, 24 Mar 2026 12:25:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
 <acDxaEgnqPI-Z4be@hyeyoo> <2d39ea5e-fd69-4acf-8518-a504f5f7a838@linux.dev>
 <acExNWaaKdhrBH-J@hyeyoo> <c913ce46-bc83-4d36-b1b0-a51b12e515e9@linux.dev>
 <acINdWKdH_b5LdhH@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acINdWKdH_b5LdhH@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C242100003
X-Stat-Signature: r3sqfebpn7c8buhep57oqa559465t9da
X-Rspam-User: 
X-HE-Tag: 1774326341-741004
X-HE-Meta: U2FsdGVkX183Rmf0GMgf02oTBUmnFnnHMu4V7ZIEYQW5IB1oYxmj7GN4O01ivKdbXrYINYONs11Jf/vQtm3mWArM+ONr1EBkU2RYnipdXDtUexSsvnDOunY8OugN4Y1/RfL1dNAIQ9QXVvFJPueqOgL/mPuA99oEKOYOg+Mv+IDPO4LIHiIZadoGJg/rVdVyhOMe7aRbOFOqGerE9XR2FKqoVOLkYVxUiNI45PxaeV6OAvdOsRzEdCcoRqMa8Wf9UqkvNnr9AmviLo9NKMneM+PnjBBn2y1KEXYlU8JJThb84xvOYYIYJuy+z1rCF8D83xpZZydmNid0P3FaXYrElXU2DF3Jxy5dpMtZjgKBulXKCPTDVHDQTBKZsqQ8qBIgXcjLBKhbAmZwxPERhTyaBsRCEP/27O1jQ/wNVU/cybs3mFI6ZvARoax1Me16fqls43DDp3n/rgWvSIgCHhejupbs8xbvcF/h1bBQm7QurqVCaE3b/n2Qo1jAWvqVWUt5x0cxhscwCor52E41mhAcQtKQOh76d594HfOYmiWHcRd35j6Ga3ogY3qELSTFVJoIOO5NmA8mB9UNhhzgs54HDW5xkGvHuR/7IkqM4Ts2weAr/3ztpcPBbrbZQS3/RIEU38CEEy40GgucsztUbj5x+/SIkFrJiMKtJrUmZZndXhIGO+4f50oS+eR5n+Wh/uGYMeew7JABPFGe2BwTh76DVkCwtmJByDIXUFJuFJHcldujf7Pbow0OakKJav8bT/Sf26Q7fL82Cq7Bde8veBsuP06DOKorltagO4UQeotb/JBxKPd7SB3K+fqeAWpct/0Sr6FdMx8WSNE7ABW7xp/3xqWVjhq6VG0jQyGveo+Q5hSSpuBBeRD+0vN7diS6H13hjmPLEEZV8inITcMRTJpCUrPKgj8Rq3XNdklBW5Unkxh/qlcp/Xtdogw+Q0JGXy5GRsP8o/6FbUp5QS/8JaE
 KlKvEfXd
 mb6pTdhWe3P68SWf3antDSibCUtmLY1uRaTAuhbq5C6QxI7F1WUBdMyUVFGA+RQPVWk1huqkttP7eVUYpWDVxEMZG3/Qj7SAL/irDxFlXWK1ZP5j9Vg+E7FxkD5HLczDkl6IFl+9JitMnReOYvAxbDDQJv9xbseGsYr5Wj0rrNhG5zf0UyZzKSq6tP/+iQzwkHKhu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/26 12:05 PM, Harry Yoo (Oracle) wrote:
> On Tue, Mar 24, 2026 at 10:54:48AM +0800, Qi Zheng wrote:
>> On 3/23/26 8:25 PM, Harry Yoo (Oracle) wrote:
>>> On Mon, Mar 23, 2026 at 05:47:27PM +0800, Qi Zheng wrote:
>>>> On 3/23/26 3:53 PM, Harry Yoo (Oracle) wrote:
>>>>> On Thu, Mar 05, 2026 at 07:52:48PM +0800, Qi Zheng wrote:
>>>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>>>> index 23b70bd80ddc9..b0519a16f5684 100644
>>>>>> --- a/mm/memcontrol.c
>>>>>> +++ b/mm/memcontrol.c
>>>>>> @@ -473,6 +501,30 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>>>>>     	return x;
>>>>>>     }
>>>>>> +#ifdef CONFIG_MEMCG_V1
>>>>>> +static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>>>>>> +				     enum node_stat_item idx, int val);
>>>>>> +
>>>>>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>>>>> +				       struct mem_cgroup *parent, int idx)
>>>>>> +{
>>>>>> +	int nid;
>>>>>> +
>>>>>> +	for_each_node(nid) {
>>>>>> +		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>>>>>> +		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>>>>>> +		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>>>>>> +		struct mem_cgroup_per_node *child_pn, *parent_pn;
>>>>>> +
>>>>>> +		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
>>>>>> +		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
>>>>>> +
>>>>>> +		__mod_memcg_lruvec_state(child_pn, idx, -value);
>>>>>> +		__mod_memcg_lruvec_state(parent_pn, idx, value);
>>>>>
>>>>> We should probably change the type of `@val` from int to val to avoid
>>>>> losing non hierarchical stats during reparenting?
>>>>
>>>> The parameter and return value of memcg_state_val_in_pages() are both
>>>> of type int, so perhaps we need a cleanup patch to do this?
>>>
>>> Yes!
>>>
>>> and @val in memcg_rstat_updated() too, I think.
>>
>> Right.
>>
>>>
>>>> I will send a cleanup patchset to do this, which includes the following:
>>>>
>>>> https://lore.kernel.org/all/5e178b4e-a9e0-44dc-a18d-8c014365ee2f@linux.dev/
>>>
>>> Thanks!
>>>
>>> Should that ideally be applied before this patchset?
>>
>> This would conflict with the current patchset.
> 
> Right.
> 
>> The v6 has been in mm-unstable for some time
> 
> Right.
> 
>> so I prefer to add a cleanup patchset to
>> avoid interfering with the merge of this patchset.
> 
> but it's a little bit more than a cleanup, no?
> 
> I'd say without the followup, this patchset introduces a very subtle
> (likely nobody would notice) functional regression visible on memcgs
> with billions of pages.

Right.

> 
>> Otherwise, sending v7 might be more appropriate.
>   
> I think it should be sent either as v7 or as part of v7.1-rcX.
> (Whichever way Andrew prefers)

OK, In any case I will first send out the cleanup/fix patchset for
everyone to review.

Thanks,
Qi

> 


