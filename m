Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B19C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A601E6B026B; Thu, 13 Aug 2026 05:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FAB6B026C; Thu, 13 Aug 2026 05:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E476B026D; Thu, 13 Aug 2026 05:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7489D6B026B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:50:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0C5040613
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:50:28 +0000 (UTC)
X-FDA: 85095776136.27.C2A4638
Received: from mta1.migadu.com (out-151.mta1.migadu.com [95.215.58.151])
	by imf13.hostedemail.com (Postfix) with ESMTP id A443520009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:50:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bsiX3+Zw;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.151 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786614626;
	b=WiP/RZVKgDeblMA90mGITODcdvz+5sXh/Kvc+6/3IUGWdGq4nukY6B7491wx4IRWvrQgwO
	DbIV6VuncBZUnS/Hd6WrVNndzBHyXFui7cJXf1JbrVSnwLs5Y0b/Vzq6/57DQp/xMZL/8j
	xkZc+mrpMN4iRepNRgF7aTVVf0skaBM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bsiX3+Zw;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.151 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786614626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rij2l4mTiCHehrzAt/8txazgUyAkcpQkwHSq74T5fXU=;
	b=8bVkbLk7VINoY/7Wzcpqqtn2Ykl2vzQuER3EcSGZfuKnhYpCiFTrtEU5uBiPBd+b9gvo12
	JgJk4BwWpIQm9titz5ykYrxmh02wFhnkL10HZSq27mO48nzgQMi4C9KaZE6GmYEGC8Tjaz
	pPyq/9cTW/c3+OJxvZa0Qf4rDSAKc34=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vYCSz1ZEZdbvEGeeo3EZ9moH+qt+41PQR7+RZ+seBJ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786614625; v=1; x=1787219425;
 b=bsiX3+ZwgOlbl6aQxP7jpWAnBYFGJaEtNMpGPkhQPLj2Jh4f96qOK13wIL+OYxD84gnUmHJY
 2BIVJx9bXcknbIU8oJrniCqImVL94tAmh+ju+5iq/71OOVZmnLhfbIhqIhHaLSaNVvWYaH9GY7Y
 k4XULHzyplCggnZqdXe4MHNE=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.111.29] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 15f9e16fe78d2e8f;
	Thu, 13 Aug 2026 09:50:25 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <ea6450e6-8b1a-4c28-a97a-3f81d540446e@linux.dev>
Date: Thu, 13 Aug 2026 17:50:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/oom_kill: fix stale comment in constrained_alloc()
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260813030654.320269-1-ye.liu@linux.dev>
 <an2DyqdnStlK8QC9@tiehlicka>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <an2DyqdnStlK8QC9@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A443520009
X-Rspam-User: 
X-Stat-Signature: fgk37jd4y85arq6pi81pzci4wsxz7fkb
X-Rspamd-Server: rspam06
X-HE-Tag: 1786614626-770681
X-HE-Meta: U2FsdGVkX19tHkF5Qa9gBSQ/x3ajVBpc99jFJt1dgKmaDGhNui/ewSZWjCURgeTieQ/ULwyfkX78VqEJKfKhaOZB8j7sL5F4i9Zi2loVu6AoyFMeiKzRqV2cIAhQsfey12XxvKn/Rg02PphQNO1zopdDnkm6A1ZDCwMHuNugmBzWfVUfBz1BSDPjIqK1yBQUfOkRBzuI1BRPAIdfskDgm9A1FbsKp1MvounKNf6kcfL9s7/n4pyZ1zb4F2J72REJcRBlTVytr7e58jwdPOss8YDLkkJ16P9b4AES22kU2Dhbn33w+AX0cREKgXhOYIU8h3PwaOCF0X30kpjZ1fSJYBhE7+41doGymH85djkW77cMg7bf8hMPfyxHEQZA77hDRUGD469PFptRcDOnWq+a6Df8uHdFpa6RYMNA3Ww2LchJY7BQywFrVZ7tmoWwbCfrN7uKW83CPkEu9h2euvT4kacB2uWOBMc+Fe4SnVT3I/jQiMSGqDDl6lRHn1YBLK3EUJJz38YxqCRLJu3OVWqNlmiEKdgjc+neBKk+2daF9zF4Z1hkWDw7BM7nL2Sy3N8PEA99cq3tEFew1KPPy/llxAQtpkFuWWbzTZLsBWN3Z00W//CAYRDAR/GHd4ge1FmcJa+sfDbCqP2bE8wtgYDWlbzyMUqogRgKmk5Trwt29n8huGzPj5GbbsVJrRgqdiG2mvnD/es9y4uYYzd6BRDTvfG8EAW3WYiMG2HylUvAqgp/vuBT+SCUxntLzQHt1xTc0D26kpaAk3sVSuimrMK6DuDoh70hyFCPx62wLFeUhZZkIh9RKQpKUXz97Uc9KEvwzRrIRjdBmEALNjL2kOFKbh8oMyNTl8xMhzHWAR8OKoqYG9zURvpulc1g78COFI3KoGm8PAXrtdx9awnRm6fKxXj2JFBKLRJMUEVqSJCsv5oUpMJYvdRUUgVhUyD/QwcaDlMZF5EUvXNdeRIDekd
 xm82bNm7
 zSuT0Ttd1KPynYvt6FEkPSKvZJTJ/ZEdzMRThUqbUFkrGYr10ZkjzGC0J3m+BpT/Ns/2af7EBla4oY5lr0fAOZDlgYAE4buOd2bBZDMYtNPzqdcbuii9blgF4TgU9zxhZyrScVqAXOSM8G80uQwM71NQQ7VLWmP6IUjum71/XHHnqbVyTKshlruKWWxMx9hyUvwXhGpfzCTAb9Cfx8B1JuiRN5hhN9QpI1IgKRGcpUuOkUbqCH4FbbkxJrOQbChkZ4q/FjbUmAM6iJNBqkmI9MQEK5w0g5vn2MnQxnt4jALrx+rMmTXY0DjUdG575ADBk3hxIEcvu6bCt8L+MZMQ6gCCuIxDqRhKPF/gc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/13 16:43, Michal Hocko 写道:
> On Thu 13-08-26 11:06:54, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> The comment above the __GFP_THISNODE check in constrained_alloc()
>> is stale and inaccurate: it references __GFP_NOFAIL (which is not
>> checked here), claims the OOM killer does "random task kill" (it
>> uses badness scores), and mentions CONSTRAINT_THISNODE (which was
>> never added to the enum).  Replace it with a description that
>> matches the actual code behavior.
> 
> The comment is indeed confusing and stale. Your update unfortunatelly as
> well. This code is simply unreachable because we never trigger global
> OOM with __GFP_THISNODE (see __alloc_pages_may_oom) and for memcg OOM
> __GFP_THISNODE is immaterial.
> 
I directly deleted the invalid code and sent v2.
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/oom_kill.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 5f372f6e26fa..4b5c70aaece4 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -268,9 +268,9 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
>>  	if (!oc->zonelist)
>>  		return CONSTRAINT_NONE;
>>  	/*
>> -	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
>> -	 * to kill current.We have to random task kill in this case.
>> -	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
>> +	 * __GFP_THISNODE means the allocation is restricted to a single node.
>> +	 * There is no dedicated constraint type for this case, so return
>> +	 * CONSTRAINT_NONE and let the normal OOM handling proceed.
>>  	 */
>>  	if (oc->gfp_mask & __GFP_THISNODE)
>>  		return CONSTRAINT_NONE;
>> -- 
>> 2.25.1
> 

-- 
Thanks,
Ye Liu


