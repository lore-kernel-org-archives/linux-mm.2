Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2512EC5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 02:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CF66B0182; Wed, 12 Aug 2026 22:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDF06B0362; Wed, 12 Aug 2026 22:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2F86B0363; Wed, 12 Aug 2026 22:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AFA96B0182
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:13:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAB281A051E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:13:06 +0000 (UTC)
X-FDA: 85094623572.03.B456759
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5AFF4160004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:13:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OiwxTKNE;
	spf=pass (imf08.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786587185;
	b=PpOzCYVLWfYvqkaLs2hmr4CZDUZR0Ak3/QIqopDwPMb/FGMRNoiEzKvHc9Kv8xrjKb4qVo
	FAdwzkGWNCc2dUJW5Calz6gP6Q2eKlP8vka0RkwSJOhWLKYDM9PO2LUNzMiGHt4aZKmQXJ
	A/K33MaWhnmhXA8SszDXq80ZejqCOFo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OiwxTKNE;
	spf=pass (imf08.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786587185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqRBVMLV1FU1sc6hfjyaY3vPQ8av1rqBHpWJ3OeVjRY=;
	b=H/qJVyh4z0omVu+q2aXnI1XYXMb9VMi8S/hhlt/52tb3PPrqx4BdnTfwpS77qclaPuJxem
	pOzt9KCMk9SQ3wXG+OYG4yANve42ev7XYAUuQOzZfzKs8N2mcvfpx82f2B2/nwqgQikAM+
	SDLDqgZ+aI1+V1tVEcDHbMVNQ1kRJY8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z1gML0qDSqQEE0jNWTJ/2DlMFeJZvkeeMONLtVEaFls=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786587181; v=1; x=1787191981;
 b=OiwxTKNE9ROpwVJvukL+XDc9n2KWqtxGpAxJwdKUyV6ZJkjPKrMBcGqaZNPkvkxYKd+5SG5g
 ujuqN/9JuDHugKQWFcEi2EsrBWNd+MxFZd6xqVlMh4Qx3C600uLn0ew3iSJJCyvaSEkOr3jgdgn
 VPuJ4OJJVRWr/2dd4ywlsyWs=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2601:282:1e00:c920::47f] (2601:282:1e00:c920::47f)
	by smtp.migadu.com with ESMTPS id 6dcdd29a1782bdd8;
	Thu, 13 Aug 2026 02:13:01 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <2666af48-1e95-4f68-8978-90dc3f4832db@linux.dev>
Date: Wed, 12 Aug 2026 20:12:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into
 a helper
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
 <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
 <20260812123959.d4e31d68e8db85b9fd3981eb@linux-foundation.org>
 <3dd59ad8-2f00-4332-91f8-7871e8d60b02@kernel.org>
Content-Language: en-US, en-ZM
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
In-Reply-To: <3dd59ad8-2f00-4332-91f8-7871e8d60b02@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5AFF4160004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: nqohmn4gg9z8zne59ur85rfzrk9hwr16
X-HE-Tag: 1786587184-93918
X-HE-Meta: U2FsdGVkX1/Nfos4U6BgCwqZI8FDg2KQ6hOMfUlFi/+o6Vk3UXxIWPFrYHxPU1Twap6ChWi+FI+K5D391nFQJTN+Rc9UK1h9CIjqul5A8aKNs9yp5paGKHWYv7N1ohkgKRy+NepzdNZ/vuv3baTbEKo5gSEMGrhyWM5UCyZdqCTaYVHicxNSKPgNTTBHtnQuseV4x+fHJnYklqeAO0QXcjfwUxV7748Hl+q3gcxwGqRvwlyCDIxW4/NFWfZi+Rgg4VrrToh2PUHn7AEK705H+xlY0dCpgnAO/JkXruW8p88D0LMQKI681Nsb6DO/AAR5ToVyXSIBtCfktbrQO6D5clyUpoxpOtfhjNmNRuVF6HXOfY/0C5JgMyfODRQ+HyBrzBu/EqJnVguqmBgcRpNtUMbACV4f7u/m3OBafPXELspEvTAIPiPCbIG0qJTHrnc+M1y235fXE5jUHDB9K1ADjSX6SEo2UgoYCo8OMDCiQpZ1RctvuHx3XTtw2U8UPKCVVv0FPLKmuTq4sC9wJcUK8gH5aX20TPfTnZ5s4voGz0oc5JOhC7SJDIHZ7ftxIYHvqEPRQSFa8pIMRJGKzHD5foj33yMDJF3SYtYVjeh0PiNGEkWWIHL6B1NflA7+TKhY5JkFj5LtA6rddJ0c04d2rPGlIfJxGJpUuyiGJPR3ome5q3FZCCr2kW+0H+su7z2B5jB8l3s7MNpdZB5z1G6u8vFWFK+bPgyXSxqpqu/KV5QXuaKZQYv91YCY5aGtXL1/iQkEh1gdqhAHkyw7bHGRQ3m3O7NAXwzbCXyDwwid6c2M/4lDP+q80TP3ftG4oww0svLS7dHESehLZxxEkPlw1lkkQpe3sl5W2Azi8GDV31nikVr9muCvEF+gYaWqbGHt1esNNxvjpB1zluybHZmJEdN0ruGhYX0dl3Ct8X3BTrUvIcdhpFwD6jBVlIjxg2YsG2CPpLlpIKY+e7DISnj
 +mWx1o0g
 WkaN0JYLmL/S50wGSinU9IsPUkTWEzuHAVUa2vbiPzddopusRHHeqkR09JMUSy9V+mASpiIWTgAJwgXknWIboAhNEz2qbzzJ0HiobQTFj9I1Th+pVuennJTH4YaLpCIoWDNoz8v00qwWY2hiYoaqm48AyQt8lnYVktUiguk1zqnoqihDXgEiuc0t76K6FAAPJ/sBdDP/A19hFJFMp/8o9P/R6Ux9pyBEoZ6eyLE0FudzY7zceD9BHglAzobFlXz10B4m6hX4DfDVOrrJm9N4DCVbFtsTqHIMSoxK6QV5Phb8JcjrNWUKuHu/bA1+WzHrLnIdt1S+mRl6OfL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 2:56 PM, David Hildenbrand (Arm) wrote:
> On 8/12/26 21:39, Andrew Morton wrote:
>> On Wed, 12 Aug 2026 10:40:08 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>>
>>> On 8/11/26 14:48, Nico Pache (Red Hat) wrote:
>>>> For anonymous collapse, the collapse_scan_pmd() and
>>>> __collapse_huge_page_isolate() functions share a large portion of their
>>>> logic. These functions both check the state of the PTEs and verify the
>>>> following:
>>>> 	- max_pte_* values are not exceeded
>>>> 	- uffd is not active
>>>> 	- lazyfree properties
>>>> 	- non-anonymous
>>>>
>>>> Merge these checks into a helper collapse_check_pte() to reduce code
>>>> duplication. We also add a helper struct for this function called
>>>> pte_check_context which allows us to pass the required parameters in a
>>>> clean and elegant manner.
>>>>
>>>> A helper function is also introduced pte_check_fail() to provide a clean
>>>> interface to set the pte_check_context failure results and return
>>>> PTE_CHECK_FAIL state. This helps reduce code duplications across the new
>>>> collapse_check_pte function.
>>>>
>>>> Two slight modifications are done to the original functionality. We now
>>>> warn (instead of crash) if the anon test fails, and we leverage the
>>>> vm_normal_folio function instead of page->folio, this should be
>>>> functionally equivalent.
>>>>
>>>> No other functional changes intended.
>>>>
>>>> This patch is heavily based off work done by Lance Yang, but modified to
>>>> deal with conflicts and feedback received during the review cycle [1].
>>>>
>>>
>>> TL;DR, I think this patch here needs some more work, and we should not fast
>>> track it at this point.
>>
>> This has been floating around since July 6, so it's never been
>> fast-tracked!
> 
> That's not what I mean. Stuff must be reviewed. Review capacity is limited. Some
> stuff gets de-prioritized and reviewed later.
> 
> I managed to review it now, but concluded that it needs more work.
> 
> Instead of reworking the patch now to squeeze it in just before the merge
> window, better to resend this single patch for the next cycle.

I would be ok with pushing the 6 patches that are ready and leave this one for
the next cycle!

@Andrew,

Can you please just drop this patch from the series. I will resubmit once i
handle the feedback provided here.

David,

Thank you for your review, I'll look over the changes you suggested and start
cleaning this up.

Cheers,
-- Nico

> 


