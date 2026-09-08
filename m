Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24CA1C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376FE6B0092; Tue,  8 Sep 2026 07:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3007F6B0093; Tue,  8 Sep 2026 07:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9EE6B0095; Tue,  8 Sep 2026 07:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8E716B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:19:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DCECA48EA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:19:09 +0000 (UTC)
X-FDA: 85190348418.13.EC5080D
Received: from mail-m82102.xmail.ntesmail.com (mail-m82102.xmail.ntesmail.com [156.224.82.102])
	by imf02.hostedemail.com (Postfix) with ESMTP id A134B80006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:19:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.102 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866347;
	b=pa3ERgLy6Kk3MfCfBqK2Rr0g+ESQ8dyArexhW+qDWQbgw/+vBKJIucNn0vi3FAAc6+vb/F
	hHVQ6HIt7qaa5tby8kg5WCPONXUEbpsu/lG+6GxyN7/W6G/OYHJog04dFXh49z1zjZQ1Pf
	vwUjNM7TzKvSzDpNH7n/ZI+xD+N3C4Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.102 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d5qmPtV+Si645wm/t/d+hQYYFbSbVKqcD6QNIiB514U=;
	b=NX37pWfKltPX79jStObNpQo99b89TsdritE93xzglqrGXWDU6zL170R6dizwpYXyMmm4vQ
	TlPcsxl3y0/MvID8RNH+Q8NV9sb2A3fAQ/5iFU8zce4ilNd4Y0fzcSLp0ZKafVBRVF6Q0q
	eL/XgbdlQvBAmBfbMeE3njc5yII4ceA=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ed4ad140;
	Tue, 8 Sep 2026 19:18:59 +0800 (GMT+08:00)
Message-ID: <be27d762-af18-4efb-8f24-3e39373f53ff@easystack.cn>
Date: Tue, 8 Sep 2026 19:18:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Weijie Yuan <wy@wyuan.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
 <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
 <a98bde94-d1fb-4246-b7c6-e64303d8388a@easystack.cn>
 <5d4c247c-b8ea-4d3f-b2b9-d442d372fd03@kernel.org>
 <6744bcdb-3456-4ba2-95a0-a58c354bfbfa@easystack.cn>
 <ap-qDThi-NQgVXVD@wyuan.org>
 <048d7470-a813-4252-a4f0-0ec29694f639@easystack.cn>
 <ap-zYt-1qCBGKZed@wyuan.org> <ap_P_Pvlpn2rEjBV@gremlin>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <ap_P_Pvlpn2rEjBV@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa080be24450229kunm2817d6f71c285e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHkofVh9KSRhDSh8YHRkfH1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A134B80006
X-Stat-Signature: oeuknbfjpeq9ha7knhj8934c9brgn9o4
X-Rspam-User: 
X-HE-Tag: 1788866346-772438
X-HE-Meta: U2FsdGVkX1+eHuYjzBQ8MYydIZXDADCQhO8XXpV0TRkuJm/+5j1eLvk7KR/EDy5gL2qow5Q1om5rdNhcieh9IKrC3VYSuzgEscv8ej5rIirePQOKuRKBUF5RHMPddeGqYRE9fTQ9f4OGpI+d7bEDG/g3YenzQv8riLqUhpCXd3QpPIh0VpaXfmSawgGnmG0lJVYlsCRWZZbI73BowLLEI9BxgbIAeALIc5qMNJNpT19w82r7PBOdgUbuptChHc2M0OiioCeDN9Ch1lsLzSLtn4nSc8zCUQXa8L5y87GhDmF5JXlC777+b4H85PWOCuZae5rv69Ujq5VQfdfhPeIr2tMsL+cztbwPu6AEZQ8wELIntK6l2Mi03Kdw7fTz09GFMfcHh8Gx62638HLjGPQXnRlogwy4DMNPY5W7FSq/fRbN+AH3FA15D8OhG58r0IUngoefBhHiGk6jcSpuz7iwfRZK5boMEUIzPDLn6ewtqADtnEStEc8uNTl1sPGn33N+cVecTtVHpQw6errFbVycaDIREUF7nBczcwa34AM0YJvfuXjomHxseRuDr6q0fIVTwaZ0TgsBlEGwuyihyCotYSgAz+CY1tVq23o2sIR5/K5zv+AY7rVDHl3R8uYW0iYQ5VXfde9mSTYIUk56rMKzccSLK4VqREVg105phmnK7JExBJT2tjeHT67O596bjZPAeAbnZ35kybpoVUtEhD6yNiUKPDzO8oMZqCVcqcai/Fpn7v0HCsy96Wl6FJjLb5S1hmo08Bu+8IFtieqDXwPMN0renk/g8J1s7Ua/0Knx+wgArrkUxVcr3bATL0yRp5Fktpr9aZAAOKnz3sktdqTV9GrvMFZTWjTuLQdKLCGw2zqQjh3m6vfJBgT+fEZAMtTTf93YFdLC38yY/sQv9YEktRpqM1rzqMmXKqE2esTcvCw4ISCAtjMMIvBdyPGjl0oCk/e3DbT0LBOkvvJRxvp
 E1wqHeje
 HgSdGZVG4PfhFseHl5gFGq0yHviLqzAsDAsX5c5U4I4XrlJzvSQWUC/QL0YOJhnxWF1tRnFgF5Kr7SFRPn7of4Adr8DHYRj35TlenuPedAEFuEPfKEEFoj3aoOL5Z0WE1CGIYsLIQVz+Upxy14tpirobDIf07fUBzyWmzcfiXTIPeBqv9Pwl/yIAHjYWrPqoK5qgeXYruZJV4ghCZYGem2S3K7TOlrCyImmWqyCnTlbwcecRGFLlBC8BCxTMvGmG1cM2gtIf9cOtGv3L+Yot/tqffAiTX9J/KVITVb+AgYwaSWmWSHhlxQfHsXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/8 17:13, Lorenzo Stoakes (ARM) 写道:
> On Tue, Sep 08, 2026 at 03:04:02PM +0800, Weijie Yuan wrote:
>> On Tue, Sep 08, 2026 at 02:40:10PM +0800, zhen.ni wrote:
>>>
>>>
>>> 在 2026/9/8 14:24, Weijie Yuan 写道:
>>>>   From an outsider..
>>>>
>>>> On Tue, Sep 08, 2026 at 10:41:23AM +0800, zhen.ni wrote:
>>>>>>
>>>>>> Sorry but your whole reply reads like a LLM slop. It took a lot of
>>>>>> mental effor to actually try and engage with it.
>>>>>>
>>>>>
>>>>> This reply was written by me, and its viewpoints are not simply copied
>>>>> directly from an LLM. The LLM only assists with the wording.
>>>>
>>>> So that's probably the reason. Your previous replies was indeed very
>>>> much like the output of an LLM. Even if the idea is your own, after
>>>> being "polished" by LLM, it's hard to read. I know English is not our
>>>> first language, and it's not that easy to speak like a native speaker.
>>>> But may I ask you did you read it before sending them out? I really
>>>> found this bunch of overly formal content a little painful to read.
>>>>
>>>> So I suspect the LLM may have taken too much liberty in polishing your
>>>> text, to the point that your replies no longer read like something a
>>>> person would naturally write.
>>>>
>>>> The "Summary and Plan" in your reply in v1, both in its formatting and
>>>> wording, looks quite similar to LLM-generated text to me. So I can
>>>> understand why Lorenzo asked whether you had used an LLM. Come on, we
>>>> all know what LLM writing looks like.
>>>>
>>>> That said, I do not know exactly how you used the LLM on your original
>>>> text, so please forgive me if I have this wrong.
>>>>
>>>> Thanks.
>>>>
>>> I really can't distinguish the LLM flavor that clearly in English.
>>
>> Yes, sometimes I can not as well. But I guess the native ones can.
>> So.. ;-)
>>
>>> I'm sorry for causing some trouble.
>>
>> That's fine. No need to say sorry.
>>
>> I know and understand that we non-native speakers would rather not make
>> mistakes over these little language detail issues. But over-polishing
>> can end up having the opposite effect. Keeping some of your natural
>> writing style may actually be what the community prefers, especially
>> these AI days.
>>
>>> My normal reply process is to first describe my ideas, then have the
>>> LLM check for logic and grammar issues, and do a round of polishing. I
>>> check the final draft once more to see if it has deviated from my
>>> ideas, and make corresponding revisions.
>>
>> Sigh, so it is hard to know where to draw the line. Write more and learn
>> more about "human-like" writing, perhaps. :)
>>
>> Thanks!
> 
> Thanks Weijie appreciate your input :) and it's good to get a perspective from a
> non-native speaker on this!
> 
> Generally I empathise with LLM usage for helping non-native speakers with
> English, that's a great use of it, so I don't object to it _in general_ BUT as
> Weijie points out there's better ways of using and worse ways of using it.
> 
> You have to ensure that your meaning is transmitted properly without it
> ultimately becoming essentially a conversation between a reviewer and an LLM.
> 
> So the technial discussion you are engaging in MUST be your own.
> 
> As for the 'summary' emails - please don't send them at all.
> 
> I feel like often they're used to generate a new prompt for the LLM and it
> really ends up being 'workslopping', that is, making reviewers do more work
> while the LLM takes care of things for you.
> 
> And that crosses the line really from 'aid to English' into it being a problem.
> 
> Instead, ENGAGE IN CONVERSATION with the reviewer, in line.
> 
> So if a review says:
> 
> "Please make this function do X, Y, Z".
> 
> Don't put something in a summary email or anything like that. REPLY to them,
> quoting the request and respond. Like:
> 
> 	> Please make this function do X, Y, Z.
> 
> 	OK makes sense about X, Y is a bit tricker because of ... and Z is
> 	impossible because ....
> 
> For instance.
> 
> That way it is human-to-human interaction at all times, with maybe the LLM
> helping with translation along the way.
> 

Noted with thanks.

> As for the review - Vlastimil has raised legitimate technical points so I would
> engage with those directly.
> 
> It's very reasonable for him to conclude an LLM was used for more than
> translation, certainly the rather ludicrious 'document the world in the commit
> message' approach looks inhuman.

I'm not sure which patch you are referring to, as its commit message
appears to be unusually long (seemingly stuffed with massive LLM-
generated information).

For my 8 patches, the commit messages are not generated by an LLM, and
they are written very concisely.

If you are referring to the cover letter being long, I would like to
briefly explain. The cover letter itself isn't that long; the extra
length comes from the test programs and test results I attached. I felt
it was necessary to let the reviewers know exactly what tests I
performed and how effective they were, so as to ease the review burden.

However, since this information cannot be placed within the individual
patches, I had to put it in the cover letter for now. Please note that
this content will not be included in the final commit messages later on.

> 
> So engage on the technical points without summary emails, and please put
> documentation in a documentation file :)
> 
> Also I think it's reasonable now for you to use an:
> 
> 	Assisted-by: LLM
> 
> Tag on this series.
> 

I resorted to an LLM only to structure the language in my reply email —
purely for efficiency, to help expedite the review process. For the
patch series itself, however, I had ample time to prepare, and both the
code and the documentation were written without any LLM involvement.

Therefore, I believe the Tag in question is not really suitable here.

Thanks,
Zhen

