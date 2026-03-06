Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE72F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37D96B0092; Fri,  6 Mar 2026 08:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4FF6B0093; Fri,  6 Mar 2026 08:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4346B0095; Fri,  6 Mar 2026 08:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC14B6B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:19:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 757791402E5
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:19:42 +0000 (UTC)
X-FDA: 84515695404.16.7B176E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A8BC840003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:19:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Iht/zUKj";
	spf=pass (imf07.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772803180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GF8UB6fO6VcAecz8C7S4CeZl3ZIGZw5K73DM9bE1pg=;
	b=d1J0gAVVeBMXHnKT7zHw85hHQqMifOV0Oed/0T/VwssOBPoMBFurdO91MAdUaKM4DNk+Qm
	N2oRklk0t7DQnnea6Fmx/y7yK1vSQlk+JhhNK2RN1WmwV+kPKk64OvVD1K1yv4klVejKkS
	Fj15UUdztnGEc1LM9GAd+GKGr3nYN6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772803180; a=rsa-sha256;
	cv=none;
	b=W2ZXcyIQry6Xf331IvHwOfIFufCTM/vCVUP+c79aOOth+/oRu2ehDTUX0CMt13tqrgPaD+
	gWcvTh1ozwld6RTJqa3O9w3Tx4zRdBtrREtPYUu/chNal9WS366iIA6i/VFwoqB8jW0+35
	lqKv3HKZistC3Vi0s3Ka2S9sF+7dZX8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Iht/zUKj";
	spf=pass (imf07.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74A6F40BA3;
	Fri,  6 Mar 2026 13:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596CAC4CEF7;
	Fri,  6 Mar 2026 13:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772803179;
	bh=ZEiOwb7RzH6HdyRRFc0nT4eB60mBor0RTsQzUvVIdDA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Iht/zUKjU/nJFZFdW35AIWkCUJckXXrmVWT1Pwk1MnDM1jpkCobd+CMUADoKCCbuZ
	 vlfUaur+mTZMJquYsBHy7Qk4aNLX5bcLBb4MbpAHgKW9ZlpR+fO1iZtA4pvHEyh+zb
	 M12TiLGNyvFX8ROfh/sIiAOBu5fFCYjV1XDWY1z+xdM9huhjchNNyt6ySFxYV4uJYm
	 M3OGir+hw9wgqGvHJCmcb2uLQum35U4QvK+Um0bJryTRlD76NOxOVX2TH3sEpKH5Pr
	 VivlHKY+tgdK9qHHmUNi3Rku6+BqDZGC0xoSJK75NJk7fpyqUPlj7kuNbP6ojgVpz+
	 mLNo09CpwT9Sg==
Message-ID: <fb9bd5ef-09b1-4c84-8435-d595f2154331@kernel.org>
Date: Fri, 6 Mar 2026 14:19:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: zero vmap stack using clear_pages() instead of
 memset()
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Linus Walleij <linusw@kernel.org>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Mateusz Guzik <mjguzik@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
References: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
 <f861cc00-2b41-4112-bba4-810388a5747b@kernel.org>
Content-Language: fr-FR
In-Reply-To: <f861cc00-2b41-4112-bba4-810388a5747b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wsg3tuoophe4ph38yg3j7mw4eaj8pq4n
X-Rspam-User: 
X-Rspamd-Queue-Id: A8BC840003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772803180-97991
X-HE-Meta: U2FsdGVkX1+RlYr5Al6zsYkD2MOX/gdHOicrZc9c3Q7pU0IzTipu++LM22BkVSfijBabyWiAe2LNu5VVJWJsesmqATiBnR8W+ScxjxBErTu6d7aHiGgxzEIIEEHGjpRNeet8AK5jHmVhED962RpiNLLXlM7DsBb722v/4iLbSqXacYJOxQmPoxidPIMYAibDnf3MVkFfldl9JonWDd4WVuebPWRZpAzG6Ab8qP0nq7aQ5W+/iGDgVuMsqTGYRYSUmvgKljMIIiywoshpDYP2AFNBZMTdDnFPKd1ZoIsuPvQuRgZeoJKyF+NUcnzzjQihSqGLSR6w3x+sbQFlzK4HNYvy3gHJDFqSh9S9LzQ0M9BS+8VBv2EVBuMRwP/oeqZCojXf1Ub1ph7OqBZ25CRWm7zeJ85MKoehIUlGKub9nvdalBXpYEl9gwqar9+QAwjSmhucC7QcOOfKP1nPdswTjF+WKwV2mhAGVkmgJWEZFs14bEUrK/Dvr/CXfZyjbVrRe1Z6xZj/64UNj+B3AdNhna5y4rZ9E8LW/9BpZ4VlsMTJBfMqGSkH0NM+EDoy0NvY+NrU32h0zEHHC8mW2LTd8nm/EBYb1ACjEXf1ZXrI9DiuD58/3IwXn7irfC9AxZjCOFl8GNFXagOjwiAmDsp5VOZ0dzQPK7RcSq8KficK8UPTBfwEVdtpMnI9pln8ZFibrR4W1EqWP5Flz87IyHEviMRpbrumYy8ZyEu7dfeoJ+WOtIKZH5Scd0kcbT/+ClSJnIZXEfEmAl8nRoqrOTUStFrSjhy5UHvr7YvOlDFRJAg850CRNYg6NakHsgby9VdGQ/qNOA4+KSisbL+p8E16hv0PqB9mcY7+MD9sWaUo+j5fMrQsXOZP3VkfK88AgMEj5I/TV9OIAR9lmRCVQWIL/cGi3RtwoIUisSKVxGoI1EICVwqL1w6cZEqv8gxAfJTNBhxZlTCdlnEcm25E9Qv
 gac9fJay
 6KZ9RtIJhTvFXUGZHG1HRLLFjrP/LDFJHO0Y2P2ra8h8yJTGuiKV0W0QswbWss/M3Ya5KL/SYEDJJgcWcLShRZidLNA0yExlXUPjCMZdcHkwXO7IrATxHhxIVGc3zHJiTAmFn7tNWoa2J0TRj8++vx/45t8B8jPYL8uH68iF+/ELJBDjTRMR5+7scGXYg61BuxkaF5yztbJhyuQjv51m/A6qoHYxb/Yn3N5vkkxQIVLDArY3YoPTggJAaIGNTF97F9IOPD11Bha/ehdQJxfBFpjOVanYA2e+MjNmMLbwC5JtTpLzK/iWyE9f8vqYk+v6LMWJm2U/ZXlWcdRlSQz0+m+VIaVKFsFuH6+lIW/8BjgquO3/3VwPEYncl60Qq3PTvj3ewpHwopLL8ExsBUwcyu7xuwXUS5kx3eD+XUZ1COWD4AyC/Uo25UpZZg804uM/XIB7u+OEUdOglqaXKq+0eTMtyCaNj4t65GdoBl5bspduXJS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 06/03/2026 à 14:16, Christophe Leroy (CS GROUP) a écrit :
> 
> 
> Le 24/02/2026 à 11:26, Linus Walleij a écrit :
>> After the introduction of clear_pages() we exploit the
>> fact that the process vm_area is allocated in contiguous
>> pages to just clear them all in one swift operation.
>>
>> Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
>> Link: https://eur01.safelinks.protection.outlook.com/? 
>> url=https%3A%2F%2Flore.kernel.org%2Flinux- 
>> mm%2Fdpnwsp7dl4535rd7qmszanw6u5an2p74uxfex4dh53frpb7pu3%402bnjjavjrepe%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C5eca287345d5408b59ce08de738f41a2%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639075256284265137%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=PrUINapvx0%2BJH9Dl9%2F2bRfUJmrvPCxwk%2FxGll6rgle8%3D&reserved=0
>> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Link: https://eur01.safelinks.protection.outlook.com/? 
>> url=https%3A%2F%2Flore.kernel.org%2F20240311164638.2015063-7- 
>> pasha.tatashin%40soleen.com&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C5eca287345d5408b59ce08de738f41a2%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639075256284308057%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=J2HT3AP4aZTX0Va0XE0taOtnA9GsETKFY1mWhrHBQbg%3D&reserved=0
>> Signed-off-by: Linus Walleij <linusw@kernel.org>
>> ---
>>   kernel/fork.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index e832da9d15a4..88d78ccef245 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -345,7 +345,7 @@ static int alloc_thread_stack_node(struct 
>> task_struct *tsk, int node)
>>           stack = kasan_reset_tag(vm_area->addr);
>>           /* Clear stale pointers from reused stack. */
>> -        memset(stack, 0, THREAD_SIZE);
>> +        clear_pages(vm_area->addr, vm_area->nr_pages);
> 
> THREAD_SIZE can be smaller that PAGE_SIZE, how do you deal with that ?
> 
> For instance on powerpc/64 when PAGE_SIZE is 64k, while the default 
> THREAD_SHIFT is 14, leading to THREAD_SIZE being 16k
> 
> Or on powerpc/32 when PAGE_SIZE is 16k, while the default THREAD_SHIFT 
> is 13, leading to THREAD_SIZE being 8k.
> 

Oops sorry, I missed it was only for VMAP_STACK, in that case stack size 
is at least one page.

Christophe

> Christophe
> 
> 
> 
>>           tsk->stack_vm_area = vm_area;
>>           tsk->stack = stack;
>>
>> ---
>> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
>> change-id: 20260224-mm-fork-clear-pages-ae7c52d12a93
>>
>> Best regards,
> 


