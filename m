Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B4E4FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 09:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B3F6B0088; Thu, 30 Apr 2026 05:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBDA6B008A; Thu, 30 Apr 2026 05:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CAF96B008C; Thu, 30 Apr 2026 05:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDA76B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:11:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31920A0409
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:11:08 +0000 (UTC)
X-FDA: 84714653016.08.5291FF4
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A90C40008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:11:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mOLFoDZN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777540266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8605kaejS4v23sY+MZu3mhg7KjkLUA+GPjpm+rHX5Y=;
	b=bH2ryp2N+dyo+vKbYegtI6Yi2fAxZaIoBC0Tc81/9TG4wyqptJpNP6bSYKvVRHhtRMI7x8
	tRR7yOWhZlfRLSzpKm1Yhc0yWnbeSe5Q2+yfPME3bpBNXcmYz2+jysO8H9FvC8e2SUnVRG
	bsQ8/WPva7FOYMpo2ylY8Bv54o12eBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777540266; a=rsa-sha256;
	cv=none;
	b=APM2pL78S+ZyXbtNZ/EDVsk9fO8FaP+hROwbNd+A4Ep18/OIRRwtS1i5df3HaA4Qo70AHh
	964ZZcxF2JlQ8BH/B2xEKOpW2LuEn9MGs/2ynDjgs8GKEHgpbH+kwTtKzGyLLfmu8zrZUQ
	z/V1VF4Htorv/SslSqiZbendb+GkMtg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mOLFoDZN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <7a4c824c-faee-4991-b8c8-703f7f0e19a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777540263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V8605kaejS4v23sY+MZu3mhg7KjkLUA+GPjpm+rHX5Y=;
	b=mOLFoDZN6QhfEuusU3J6R02KBqSVIu9DTxLSznLqat/V+GUovPd7FOrHswgdUrzyU6xgti
	/dWlIbUnUyJCq2YOgFnVVPeZ/zn58rlHW58hYltxJWmDlmM4Zf+7NYZu/k3a3PENXfIzah
	Fce+MsCAN0/6UxwkkD45qF+Lx1wOfa0=
Date: Thu, 30 Apr 2026 17:10:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe
 huge_zero
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, liam.howlett@oracle.com,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, npache@redhat.com,
 zhengqi.arch@bytedance.com, ryan.roberts@arm.com, surenb@google.com,
 ziy@nvidia.com, linux-mm@kvack.org
References: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org>
 <20260429065743.67054-1-lance.yang@linux.dev>
 <ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org>
 <aa3937bb-7f06-4136-ba36-ce4a06acf80a@linux.dev>
 <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
 <e92e45df-0821-1d67-e026-88c57960814f@google.com>
 <9845ff31-acaf-4a04-86a2-b4104446e966@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <9845ff31-acaf-4a04-86a2-b4104446e966@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A90C40008
X-Stat-Signature: 7a4i4eyq4znzqmuyzo1ytojhu386grfr
X-Rspam-User: 
X-HE-Tag: 1777540265-300690
X-HE-Meta: U2FsdGVkX19xth7F2nWlki8pDY6Km9fKZwM/AewVJIa72aIEJjd+qwGtg9AXDlfHTnTuv1N9zkS0DXlpNjGfkZiy0fKmXE9Ekb5KZ1WLo1Pq3R5ZEM6Cze1+nxqU0yfHjiZxtFpIct9tN77ANteAUvgdxrjztHh7nGRUboev+p/8oaZQG0tCrS6deoEz3T8RLzSR3gr+pN/cytdlXu1noXVRkYB9WDCfOI6REzm9NF++XKjDNfjkrcSFWj+Yo1u0l+v0LOhfVvEH40hxxXfwTeTLtCtSaEoP75Xt06oCbKj3Z2OkUQj20biiAvrCTPMSsxacfh0aozvN8ljtwD7STo0IQSI4/Jsf4ZVTvN8BarFa9zI3C59jCoowCz5FFof1EssZyOJWHZd0Dg9JlC25t1hqg+vzlECmheO4LLHIH4fMYg6LNaT0SOtudPn6/IkiA3Ce/w/+gb9k/bnWONSODDYmK6yvt5SGg2sSgoyML+cUKJupxn20i1EklOXhxFgY9KgdPnawhhPA2VGmG2BZzoNqfbZgPRBazO/EmUk/hRlNBo8zrxmYsq9tJ3OG5wme+yZnF89jDygzxV4OJSHc/zHJ/tD0JqN3b/4bbGIzCbcnlGQFXW2p5Cz7YvGc2Oao0aClU6Fto98ejNl17EMqU85o6iCS06oU0EIimn5ugR9K+E8tH9kcagpupRoYS/5C5CuM7Sxwteg+pSBPI5mElCfwyH9+FWQbscHScSo5zw4vs7G1w/vGSoo/4AAQyQmiB7sHJkwjQgpaQ9aEbfAj4h46Kozisu+W2zFZR33Qp3X3groA22+9O0pzyAQyZGi4SZ7momNj5EjoneIWn4dwFmxqooDLsb1WbsWAI9mpS6be2vO7FbUbGgGJ5kXiefKw8IialvWNlkwhHB4hiN4ePguawjAypelk8jjGVcAO3d7thjL0Y4Usf3C41reh3UETFcXkiHHs9+581Nbm18M
 q31TmPQ0
 go/BoWreqsrOmD+sA6XKSWoFDxCNvhKGA+w1vYNEwchHLJlKwQGshwH6Zx9iVxzKagB0rq2/5uO9VSAXXBkxpiE0lNbU42Pfr8AZfKoQEG8ZOv0En/i2OfzG/Hn5TzfVHamcHFqmdOjNyDnV7FJYTLFUEoBqHKbn9hvGX7AvXPC7LrwYmjKo2fKnEaafi2BW8z+I6XbC1y3TdO5i0H+m1zsdj9HZc1viS8dJc/eullNW/X5fFWUONZu7RhQuXy3++O6EgtxrmbDRlvvQwdwWmLGQkE4M7PGb7GUFIQ/BpgqpBlo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 16:54, David Hildenbrand (Arm) wrote:
>>> ... and triggering the VM_WARN_ON_ONE(), although never reported so far.
>>>
>>> To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() whether
>>> pmd_special/pud_special is actually implemented.
>>>
>>> Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
>>
>> Agreed.  My Fixes tag (where my bisection arrived) was correct for the
>> common zap_huge_pmd() symptom I was seeing (Lorenzo's commit removed
>> an independent is_huge_zero_pmd() check from it, so it now relies on
>> vm_normal_folio_pmd() to give the right answer).  But you've chased
>> up other usages, and realized it goes back further.  You could just as
>> well blame the other commit mentioned in this thread, the d82d09e48219
>> ("mm/huge_memory: mark PMD mappings of the huge zero folio special"),
>> because in come configs it is not doing what it expects to be doing.
>> But af38538801c6 is where effects start appearing, so fine to blame
>> it (and both come from the same 6.18 series, do it doesn't matter).
>>
>>> Signed-off-by: Hugh Dickins <hughd@google.com>>
>>> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> That's generous, but the patch is not mine at all, and I'll
>> happily let you grab my two paragraphs above.  Please, just
> 
> Okay, I didn't want to undermine your involvement.
> 
>> Reported-by: Hugh Dickins <hughd@google.com>
> 
> Then, I'd also add a
> 
> Debugged-by: Hugh Dickins <hughd@google.com>

Yeah. Thanks to Hugh for the bisection, debugging and detailed
analysis!

Cheers, Lance

