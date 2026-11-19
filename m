Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A8C606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AnfNxf5L
Received: by kanga.kvack.org (Postfix)
	id 5938B6B065C; Thu, 19 Nov 2026 12:27:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56AF36B06B6; Thu, 19 Nov 2026 12:27:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4585B6B06B8; Thu, 19 Nov 2026 12:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2192D6B065C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:27:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3DADA8736
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:27:54 +0000 (UTC)
X-FDA: 85452551268.09.5C10E9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DB357140015
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:27:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AnfNxf5L;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795109273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRB2iBq3b1trvS3BaRFp13nknOER9bN5W242hzxBiKw=;
	b=D+H09+6wRaCGllF5I4HDglguT7QcNF5fH8e5gL1iTh6sSb4ql1QpGxXLo5cCVyytsii/fz
	G0PjKUr+WCmlr1ZHVn1wN/XzyJ/tIHWuWP/Km/PKEC4uhmWzSkq40IFKJwfmQ8vW6d5NPs
	syCV8JSukjX+3AiYQUhS2wYIfiYy5uc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AnfNxf5L;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795109273;
	b=dNK/XWGbHxLNvS/A9EZT9xleX51JgKt+uOaoEcx0JLzKxyI8Kkdxkmf1jU4TpnAl8PCJwm
	WWbLR4xc46nFZsWIb8eJwPsWJYbi4da0vnpC5Q7b/EgBfMtvlbUUUVKqV8oIjeiP7DCyRT
	FkY2WEQna7xCzeNyBsFwLLzmBr20YQo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 412EF618B1;
	Thu, 19 Nov 2026 17:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739DC1F000C5;
	Thu, 19 Nov 2026 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795109272;
	bh=zRB2iBq3b1trvS3BaRFp13nknOER9bN5W242hzxBiKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AnfNxf5LM22vzZD8nXcrD/0SG2E9fTT8YWOR6JzapSJ7AcyQ2Klpfhu1KKu/qTUjO
	 OfE5NBQDq8R2209ewjOjWZHcgu6heHG9j6IVM73UtkJtf5dzMvym7ZRAYQeqxBwqec
	 v8+GIOGl9amaTNmHImGr9XH5erfGIbN/1yoNi3PJwA9UVXi5mzo4Z/FTuaIch7CvhL
	 27IAVgOtmDPkh7UHu1IaDDW5NnI/2oZCWHQvcdx7dSqcXDcy1purPDlSihoO0bqjax
	 plIaUUvArqjr3jd+rEebKHEFyezYY6J7mOhAENFtSfDZHevO+fwzmxV7xebUbizqFt
	 YlU7nDiUyQDcA==
Message-ID: <80849862-19d6-4497-902d-8acee4e2a3a8@kernel.org>
Date: Thu, 19 Nov 2026 18:27:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
To: "Garg, Shivank" <shivankg@amd.com>,
 "tejavojjala@google.com" <tejavojjala@google.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, "rppt@kernel.org"
 <rppt@kernel.org>,
 "david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
 "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "surenb@google.com"
 <surenb@google.com>,
 "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
 "xiangzao@linux.alibaba.com" <xiangzao@linux.alibaba.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "nhuhuan@google.com" <nhuhuan@google.com>,
 "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "liam@infradead.org"
 <liam@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
 "ljs@kernel.org" <ljs@kernel.org>, "rientjes@google.com"
 <rientjes@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "torvalds@linuxfoundation.org" <torvalds@linuxfoundation.org>,
 "kaitao.cheng@linux.dev" <kaitao.cheng@linux.dev>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "x86@kernel.org"
 <x86@kernel.org>
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
 <sashiko-outbox-214828@kernel.org>
 <2dd5ed03f167563d8b37a4e1ae4b17d2d8aa31a2.camel@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2dd5ed03f167563d8b37a4e1ae4b17d2d8aa31a2.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ntmfgk59ogmizjmbeharctzuydxo6apw
X-Rspamd-Queue-Id: DB357140015
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795109272-532951
X-HE-Meta: U2FsdGVkX19slbvMKt7Vmt9n1mOlPjn8GudUYsUwCoGOchSQ/K0z2N1A2VjClcMLSPOKWgMy7KPeNvo3b7VLQIT02ay8i+j1BDN/ieq38OkI6TmBlrAh1/n8s/fcZnvSrJuYP739b/GcHaB0KccTD1AkE5z+XPd39H/5KeuIk12ZoG5UsqLE1cXIqT/k/9xUmHjLs1aRhNbxVbx7EL6nNtEzEipqA0cT1m6cTkuEX27dGR0QZ/dSnkUiuLRlCf+NqpcHXo6B/75xQ5QUy2wuZ07GNq3o1lXv9/QhueKUxEaXCBZSQrsJdHHWJu++173L+3ZDA/qDrHMmfh8kytCB9kSmWCgqErTPJD3ckPRdoGhZWlejkA+zW44evXMVHXBrwEwiAnty6cz6QNYgZN1Mhip13SDAjASrrNesbwXpjjSAEWHpbrUUR6qKNDLkHGYvR7d6TFIV44ukJ9gi7Be0rCG5B0wK79L8sTb9+FvcUGNHzAQOZ+M4HYyjzvs57wTL/1ymlkz/LGxjUVNZjaBjwA/lY050xes9ukoN1ZD1TrwvrupGlr85JTwiN6nY1XU7o/VPDHFAlAu0itN/IuDg+lmY0qhoBiESUrKDyQAzt91E62FVo5XceJk+RqdlJ5rspy8AYUbJwV9svoxuzFZEBFGHFeGLqb5GVLyv5JWT8c/8Kg+Yqv4s7GRl9+YdicsvzVrcIrWUDx7wzxTD+dlhQ7genuGg1FGyykHOVo3Z5PsAqFq5GacI11TN29TO9Pr76MiMO3Qt081pkSd6gPAFEbJWjcjL3o0dgRr+Sske0ja/AB8I3KIIGFculel0Pq68FzjDW7CRMc/cIuejFF6Bf8zGocdjYX4Os79QoDysLPAPE3fsE7jaUVJuOk37h6I5A1/NdxjuM9l6a2vcwigk4dxpt7EQjaho4YnMuFBlZMF8BOWkzvaEBAMkRXRUVGvuyz1yTWgB09Ipwf13cnd
 /VtVluIy
 oLT1NGi1vJNyHT2xqXVBdpT9Lq0gm2/yoOgdksQOMeA3RvvqEmYOoQJWoVvNFO0Kz9rxs91UOHuCK7S5Zyj42JoWoEPJlRdfFO/FgDQGPBo8BtV3z3Av4V8UViPhtwXuLS2yruMOei+PJYp5JPNVRgjNc+1UpHmXPYR9c7ZabhdMGbEDbXYccfdIlubMaFLn3Sdf4w1JeP0JNRMlaRI0QUiK5ZKYzSfLRNMSnUgfXVOd47ITV9qRAQR67XFePHqIXmM1a+sQLen6/3W87SNvBrRjP+kVVowXz+F4VND1SE29cegaw3YFthe7oUBMHeFWok4frPpSbsja/Hw4wcE22B6bvwrZfUjToRv8Cj6m0/6tUr7Gg1IO5OhGM17YGITxRYFtp4+Y1AIN5GlF7NUYB/J4loEfoYizCNGoODNclVaFss0f0qcDQIxTPOwrCUTYHes8C8jp5rcR77gQSEmfgMBeKQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 06:27, Garg, Shivank wrote:
> On Sat, 2026-11-14 at 17:12 +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found no new issues
>> in this patch, but noticed 1 related pre-existing issue it does not
>> introduce:
>> - [Critical] mm: missing hwpoison check in copy_mc_user_highpage() and
>>   copy_mc_highpage() [1]
>> --
>>
>> commit fae95970ccf2607d670f06862e40d3ba9313200a
>> Author: Shivank Garg <shivankg@amd.com>
>>
>> mm: introduce copy_mc_highpages() and batch copy in folio_mc_copy()
>>
>> This commit introduces copy_mc_highpages() to copy page ranges with a
>> single copy_mc_to_kernel() call when possible and updates folio_mc_copy()
>> to use it.
>>
>>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>>> index d7aac9de1c8a4..a79e9d68359c8 100644
>>> --- a/include/linux/highmem.h
>>> +++ b/include/linux/highmem.h
>>> @@ -484,6 +484,57 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
>>>  }
>>>  #endif
>>>  
>>> +/**
>>> + * copy_mc_highpages() - copy a page range with machine check handling
>>> + * @to: first destination page
>>> + * @from: first source page
>>> + * @nr_pages: number of pages
>>> + *
>>> + * Range variant of copy_mc_highpage(). On a machine check, the poisoned
>>> + * source page is queued for memory_failure().
>>> + *
>>> + * Context: Process context. May sleep.
>>> + * Return: 0 on success, -EHWPOISON if a machine check was handled.
>>> + */
>>> +static inline int copy_mc_highpages(struct page *to, struct page *from,
>>> +		unsigned long nr_pages)
>>> +{
>>> +	unsigned long len = nr_pages << PAGE_SHIFT;
>>> +	unsigned long i, ret;
>>> +
>>> +	might_sleep();
>>> +
>>> +	/*
>>> +	 * When copying we want to operate on the largest extent possible to
>>> +	 * allow for architecture specific extent based optimizations.
>>> +	 *
>>> +	 * copy_mc_to_kernel() does not call cond_resched(). That is fine on
>>> +	 * preemptible kernels, where the scheduler can preempt the copy at
>>> +	 * any point, so copy the whole range at once if copy_mc_to_kernel() is
>>> +	 * available and the pages are in the linear map. Otherwise, copy one
>>> +	 * page at a time and reschedule in between.
>>> +	 */
>>> +	if (IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC) && IS_ENABLED(CONFIG_PREEMPTION) &&
>>> +	    !IS_ENABLED(CONFIG_HIGHMEM)) {
>>> +		ret = copy_mc_to_kernel(page_address(to), page_address(from), len);
>>> +		if (ret) {
>>> +			memory_failure_queue(page_to_pfn(from) +
>>> +					     ((len - ret) >> PAGE_SHIFT), 0);
>>> +			return -EHWPOISON;
>>> +		}
>>> +		for (i = 0; i < nr_pages; i++)
>>> +			kmsan_copy_page_meta(to + i, from + i);
>>> +		return 0;
>>> +	}
>>> +
>>> +	for (i = 0; i < nr_pages; i++) {
>>> +		cond_resched();
>>> +		if (copy_mc_highpage(to + i, from + i))
>>> +			return -EHWPOISON;
>>> +	}
>>
>> [Severity: Critical]
>> This problem wasn't introduced by this patch, but can copy_mc_highpage()
>> and copy_mc_user_highpage() (as well as the new copy_mc_highpages() fast
>> path) return 0 when the source page or its containing folio is already
>> marked PG_hwpoison [1]?
> 
> 
> Yes, the patch keeps the existing behavior. PG_hwpoison marked pages are copied without errors but Real poison issue returns non-zero and folio_mc_copy() fails! Should we consider this as blocker?
> 
> Yuanhe's patch adds the check to copy !copy_mc branch but copy_mc branch can still copy such a page. [1]
> 
> Since it's pre-existing issue, I'd prefer to keep it out of this patch.

Ack.

-- 
Cheers,

David

