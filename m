Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B148960A260F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N6KBGWfh
Received: by kanga.kvack.org (Postfix)
	id B323C6B05B1; Wed, 11 Nov 2026 04:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09D66B05B2; Wed, 11 Nov 2026 04:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F0A6B05B4; Wed, 11 Nov 2026 04:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDF36B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:04:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 103941A024B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:04:38 +0000 (UTC)
X-FDA: 85422252636.24.BF5A3F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4FBB640007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:04:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N6KBGWfh;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794387876;
	b=h2pgoFN3U260NHHaaOjMn/6GJZL4hZoqUkQFpVOBweJsywdQQP1IOXUGvwQ5kZ5bxBIczs
	xjXKLhA7B3Rr2MdyvPlDAH0bWqIYFtG9mbDfHHbNPj7+uAfJPecMun6ijiiKDtjqxnwF2Z
	3AJINdMLn3JVvCYX6QVxyZUrbOc0tro=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N6KBGWfh;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794387876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBkGXYJ5uxFZJke1jLpVYYWUGbr8za+HvWOrId41WTA=;
	b=IaKT5F7jxFZCCqz1GvSMpRAgRjHsjVvepBjAVtVLT+Y7YeHF366iKl8f+skh/2SxSbHj6i
	vlZzbRFU9jXFMo5lnbvijmYZd83mZAdV6K1MEVP6ieVuxD4PaOUbD5Q3q0XC0nBASrrnjS
	b2zLLNJO+JTGS0hka+mxPgWmoHi8khk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF1EE63574;
	Wed, 11 Nov 2026 09:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1CF1F00A07;
	Wed, 11 Nov 2026 09:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794387875;
	bh=ZBkGXYJ5uxFZJke1jLpVYYWUGbr8za+HvWOrId41WTA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N6KBGWfhAsqq49Ypu3lDBMxqXXdjm4CV7xGFJeWEVztIkjhmav6bMWNwwr3p3lQSa
	 x6Bt7hV48QMhggC0ZAGqMKLOB4OCI/KlMJVqGU278cRUJvwV9kVouMMLrR4ICoJ+DK
	 gV0IbjZLNeHmhQheRwBSLfMNe5MtbXFHMx+/OxMQI7MdTgkZjC/Gu+39ZYGh9czEyg
	 uc02Iac5slV9rct3aidTyvZtTzdpcAW/1QJ3B5vfZiKn96FQdHfZfno2/XO7kUkjZU
	 Hn/tEtbKTCsTxZ/4Tv+Bqn/zV37zfydtdirH3DdVE3uj8TGxgvMZHS63IkiE7+r3pK
	 Seqgk6wBx/0iQ==
Message-ID: <444d9b9e-df1f-4981-b200-969d64d0ca41@kernel.org>
Date: Wed, 11 Nov 2026 10:04:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] ksm: skip rmap_item allocation for non-zero pages
 under only_merge_zero_pages
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: ljs@kernel.org, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 link@vivo.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 tujinjiang@huawei.com, xiao.wang@vivo.com
References: <avMKhCLDv-ybpmIZ@gremlin>
 <20261111083632.57199-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111083632.57199-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4FBB640007
X-Stat-Signature: b6qu51thpo5bwcyzdqcx4e9ox7q4mbg4
X-Rspam-User: 
X-HE-Tag: 1794387876-763868
X-HE-Meta: U2FsdGVkX19qYwgAVKFbGyyqRK5ygOSC9yMqxt+mBgzSJixDwkFLquaA6Ft9zA5rbyW6Kaqxgec5z77wtH6StO2BKldzJ3bPYHAJMPOZgVN4RsMFt7qlTpMZ/BGFZa4H/GQheO3+OaukA/fRGQ0PtNFC9FykD5kdoDwRTKCGJRgCckbfGvoKG61a9cFQ/0FJC4w7mTAnOPLJLMIp5IsbYkUSUZZpCrtFOlPq/o4+WUSHq/OlRFERG6MTowKZSrFy/QCI1zhDMBguhkrNsnsYXm9PwLDQlWbRbFRqDIy3mi179sRVwaFe2cBAByg+be1u1T56P47Z9tDzEKWVehQDStmcNW/iSs+5jcSZRHXpNudpNOopjUueWhVAs+KXszqCPUMVrZm0FVoxseh7OddDdaWmhbnBsQZM8oSXXa3zYRU4R2Q6fmRvA8oWRZERY4aaIPiSDDH7jniceKbFyQzyARAqf1UBIbJZpF3I9aIN65l8vetgSIYg8c6XWgEXftOmaDR/EgKZ7tugAklltQpj4/Amr+gbQ0vzvTDK1Ax343aKnAnrKgcF1JcLLLrDqyhFns0gBRwt4KlZsnbee6f9EaCaXMXvawRrIFxNd32CRiKzgxpTauP4Zrp04PqWAmHVFWa0CXsmL0TxDzwr4lIJyL0haJcFnvEUn9+8wlst9qWbGHRcu0uJX7U6UQ8H9gXjkFAiyFOBoNllWaaQkyAyFGvYIzKpInrmWXILS4b1uzbb+JSUBzhT8WFwKd+oS/WTeYaasSTgRweukX8oZK8RNdlCS4VPZWQ/4xkHh/0yxXF+1auyyloixxQaPTCWX6pdkd42LnfbXoq3zaS2j5ZnA1xhAeyWeIUZGiAIiQ+70kxVkAM8SJvoTxzXS8FB1O2nKEHqbcEA57FwUODgWiIdJGggl7sGgFArCksVI6RKwM7kI6FcyNFnVK7Cj6WExkrPOJJVPx1OLSa7a3rRrCG
 xXsj2S8/
 ghOWLEvsTgFjlz9H2ywfbxbtargg541SwgJMqQKNa32u/4ykLuNUGmVUONOR8WEVNMDoxO/GO/RhuH9X2MqPPfv1QQOl0S6CDlP4REHBGcO1a5HwWqdmqtz7//w6vaxQTboFNIUjletKPHcXWDrPg3OqRjP3SnTMMbBDT43JERTXrKxQ5k8vj9XjPlFpRWcm/natVKuzEzdYufIt5yKmJ45aFQz82nV0aZHt5HFB3FiyY1tJezg3G1bJpxPPSjGWk8iUkhYX4l0atE1UDM43DSZNZoK1jbyVGlCNAvwPFQWy9XeqLtdzQwUh8vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 09:36, Xu Xin (vivo) wrote:
>> On Tue, Nov 10, 2026 at 07:22:06PM +0800, Xu Xin (vivo) wrote:
>>>
>>> Indeed, the description was generated by LLM, but I thought that was clear enough
>>> to present what this patch do and why. Aparrently, you don't like that style, I'll
>>> rewrite that by handd.
>>
>> In general we never want LLM-generated commit messages/comments.
>>
>> I do however obviously appreciate and empathise with using it to assist
>> non-native speakers. So that's fine, but ideally you would write it up yourself
>> and then have the LLM do simply a polishing layer, keeping the length as small
>> as possible, which should give us the best of both worlds. Thanks :)
>>
>>>
>>> The goal is only to avoid rmap_item allocation for pages that can never merge
>>> under only_merge_zero_pages. The implementation is simple.
>>>
>>> I'll send a v3 with those changes.
>>
>> Well let's wait on David's POV on this series for this cycle before a respin
>> first thanks!
> 
> Thanks Lorenzo, makes sense.
> 
> Hi David,

Hi all,

> 
> What are your thoughts on targeting this series for this cycle? I understand
> you have a lot on your plate having just taken over mm/core.git and are
> focusing on bugfixes right now, so I'm fine with deferring this to the next
> cycle even though the implementation itself is fairly straightforward.

Patch #1 is rather trivial to review () although I will have comments.

Patch #2 needs more thought.

I don't mind something that is easy+quick to review, but if it takes way more
time, it will have to wait, unfortunately.

So the cleaner you make your code, and the easier it will be for us to review,
the easier it is to make it go upstream.

Schloppy LLM text achieves the opposite :)

-- 
Cheers,

David

