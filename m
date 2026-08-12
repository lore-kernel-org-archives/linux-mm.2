Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7331DC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 20:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501746B013D; Wed, 12 Aug 2026 16:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8406B031A; Wed, 12 Aug 2026 16:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7C86B031B; Wed, 12 Aug 2026 16:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 190E06B013D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:57:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAE4D1A04CF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:57:07 +0000 (UTC)
X-FDA: 85093827294.17.F13CB57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF78F180007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:57:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xn/nWXs9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786568226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9ZFW+aVhLGxLPkKWmi/fbYeB5bvrDK0sOMD6gIL560=;
	b=vLjm2EYw3JwjUOZxPhNZALT+jg+EjlGSrOrRnXDaj9HD6MTzaYXJ0NnOXajFInG5gtFB/F
	g1+whJfxl+40q5czUS++vaTWEcyEbNSLtzDd/t5Sf6hEfZjqFowqV3jATX7zP/92DRJkY+
	LKyhf/ipLTISuaj6pluAA4f2NsYn/1I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xn/nWXs9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786568226;
	b=Hy3Sk/Lbp7amz9vsvkSDqLlORoBfIRVg4phQc9fbh8PIloA/y5wimjycCztK1Hd6aKjPVB
	hjsIn1n9SizMPeCGYc7xNNBil9q1O4agKJUjEKGs87jISdaLqZdAwI335ExcrZrP6hxlRi
	6kpNOjc+xPX4sra+QAKO+BlwtCRC0no=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ED9C600AD;
	Wed, 12 Aug 2026 20:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9811F000E9;
	Wed, 12 Aug 2026 20:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786568225;
	bh=+9ZFW+aVhLGxLPkKWmi/fbYeB5bvrDK0sOMD6gIL560=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xn/nWXs9fsprt8KNuxsmV8ASDeOoIb3H3jnEU2ohhQbqJ73DTBSViJ0gACuAYdMFf
	 8AYLdX6yGr0XjrF7kyelORCUS+rYx2YsRBihiqVl8NHcWy8N0OxBfiJWM/dKJzp3rj
	 lFx3pM5Klp+xoVyTg4BXchWQX6gAilvkxFX0dxFU6F4uKkEHyxbwAPsdWgPSg27tn/
	 mnUjvY/HbvB7u3HqUtvWlSgeCxfL6+XJpKmrOqq9TmuXIazyq2O/u+AaHEBow3wgTN
	 MaexoowVWFZ1Ki80w/4QblpRus3K81F5jMobOkqylzN/FAHQtoOkgPzRfhFU7IQN3p
	 wX7k1G1joi4Mw==
Message-ID: <3dd59ad8-2f00-4332-91f8-7871e8d60b02@kernel.org>
Date: Wed, 12 Aug 2026 22:56:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into
 a helper
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260812123959.d4e31d68e8db85b9fd3981eb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EF78F180007
X-Rspamd-Server: rspam07
X-Stat-Signature: 8mzn1t46ajqxju8q91y3a4phimuwa1e8
X-HE-Tag: 1786568225-617273
X-HE-Meta: U2FsdGVkX19R9qgBPf9XUTh9V0sEAno+kXoQC7pNwNRtLbdpDQJkwSJPj401KP7b/cs8mFF/0qIXoDzg8PrNG56yA1MY23zqsD55OVfhPXqS1orFRRmQaQ8FSsQfBLbiAFykmNR6FV3XH2M54eSY0YblQIMRRgbTfUKH5KLVLXn1mOcib9ae3zPcl73IEr+7eRaev/Xa/ARZIBCXjg7/9meZjUH8oDH7Ua5FHxVRBKlaEELUdrjBrbqVPuSPu21Jv5pC+dsEIIG5QN1MwSLubiPhSznVbGhvdUEafrRo89O2RtyzV2EZ/tKYT1dIWZ/SzmPfELHIZtYmj6bDlVtgnvHkkWubQ9SC7UvnPqdvpq+V0x/Fk/Ves+RHH0UK/7p/wwSH1A+oHDbNSPcXSTFzYIFHJAO3RObb7LuwFO3vCNSUIfEVQ9kI0t+v33AyrVeSF7KAV/IkZTdqQc9aAXlAjc9AcmvUTwRdA8UmiKxOcgPRpCSoZytYjZVOgKkyNLJPfxrPJBBhcF2Qs0UjKT5sN+ivkfAAyGg4OhSkFISYRNqvXVu4QDGMd4K/SmfY1gOJ+00ZOdZiReOpf4i1QCiKMnSHsCivhdw5GNEy93/XzuYsvW71cYvwm/op4GIeF1f8mZTTw9zPlLSiYzLo9LHUYvJBxgXFZKH3I8deJAvDUESHjenmfr48b406wSJNeMsnJrsbpAGk98tiqgZ2OuKp9jUXHasH+3/nTu7yhgY1VdSJa+10JWHpM/kE1Zw20tZQqn+3U7v/1zCsNiu7CEv6TnsmGDy9AgfylYWYvuxOYrZSpG6N5U09orzRVIWbt3B7cwmDEIKpZv033G8qE/jPULjf3GDU2YOalc7+gVlPBynJvFfKRnSKShkDerbtEjqt2tuSHg5BEHLZ10xRPD8QSdDsFqotKcVoYBclqoGiSUmDlvGdr+U1b1m0QYtpLADEs17f/x2mR9EhN+wjr5f
 I+m5qww4
 3m3YdVTdUiC8rsXkV45kR0i9qirfXpxd8PPYovg3/vRoRtpAsHW88z2OzJrUNDwVw1po5oOsyFvTp1aSDnrl97Vfwbr5gS2F4xydy9zgKHm6gW4kaLms55KVLePDH3y2Y+3DurJ1NBDJTnzZRX/NiFixwLP86I2UXQ46p4paCTbGWEt3l7sURL4OxEKH8cMplpakw7KO1RJQk8dFp/PFAZdhIhtoTQDn4LIxCRQqKlNuHCA4OvduHDD3FQsGz4AnXqhyOtvnNpzhHEA2o1+psHQ/F7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 21:39, Andrew Morton wrote:
> On Wed, 12 Aug 2026 10:40:08 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 8/11/26 14:48, Nico Pache (Red Hat) wrote:
>>> For anonymous collapse, the collapse_scan_pmd() and
>>> __collapse_huge_page_isolate() functions share a large portion of their
>>> logic. These functions both check the state of the PTEs and verify the
>>> following:
>>> 	- max_pte_* values are not exceeded
>>> 	- uffd is not active
>>> 	- lazyfree properties
>>> 	- non-anonymous
>>>
>>> Merge these checks into a helper collapse_check_pte() to reduce code
>>> duplication. We also add a helper struct for this function called
>>> pte_check_context which allows us to pass the required parameters in a
>>> clean and elegant manner.
>>>
>>> A helper function is also introduced pte_check_fail() to provide a clean
>>> interface to set the pte_check_context failure results and return
>>> PTE_CHECK_FAIL state. This helps reduce code duplications across the new
>>> collapse_check_pte function.
>>>
>>> Two slight modifications are done to the original functionality. We now
>>> warn (instead of crash) if the anon test fails, and we leverage the
>>> vm_normal_folio function instead of page->folio, this should be
>>> functionally equivalent.
>>>
>>> No other functional changes intended.
>>>
>>> This patch is heavily based off work done by Lance Yang, but modified to
>>> deal with conflicts and feedback received during the review cycle [1].
>>>
>>
>> TL;DR, I think this patch here needs some more work, and we should not fast
>> track it at this point.
> 
> This has been floating around since July 6, so it's never been
> fast-tracked!

That's not what I mean. Stuff must be reviewed. Review capacity is limited. Some
stuff gets de-prioritized and reviewed later.

I managed to review it now, but concluded that it needs more work.

Instead of reworking the patch now to squeeze it in just before the merge
window, better to resend this single patch for the next cycle.

-- 
Cheers,

David

