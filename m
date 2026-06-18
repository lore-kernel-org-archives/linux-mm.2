Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85166CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5FC6B0093; Thu, 18 Jun 2026 04:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADF66B00A5; Thu, 18 Jun 2026 04:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3A06B00A6; Thu, 18 Jun 2026 04:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33BAC6B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:23:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2513DC2C0A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:15:52 +0000 (UTC)
X-FDA: 84892324944.19.01D6703
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6E56220009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:15:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jokNGls3;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Knj7y01GHDRS45IwUSNAID4Zu7sh5HJzfhv5fC427g=;
	b=EwlIpLKN51G0KM2mdkbTfwnd3BV/wCtdq+3Q7mLxyrqYRYAWZKHnHkKZhPUYifH94V1q03
	1rpYpN5ZSjAdMZfIYHKCQozpIUAYw5ZYwMy3C+vMLZUZ3OpcawSNyQo+0XGqT2TnoAgsSE
	/D9vBWsk8zds8HXNFlKBU/OhCXKibsI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770550;
	b=4g2URQSHSlRc6Jx63Ukrh3d7hn2KAY0+6hGbDbAnmWXMVjFEdP+b4m+jihSIaoHf4f7DJq
	aYgqzKRIEltl7BhD4dzphY8O/UjrDnNyT+7Dl1p3fa1Ipm5Fto7FfnTm4a3IDVfPIoHzlv
	wxGm38gUTaNYYZ7wVKUwO5XYPJ8dx9o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jokNGls3;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05EE46012A;
	Thu, 18 Jun 2026 08:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2D91F000E9;
	Thu, 18 Jun 2026 08:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781770549;
	bh=3Knj7y01GHDRS45IwUSNAID4Zu7sh5HJzfhv5fC427g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jokNGls3ixoGRdhDZ6QqH38obrdOQHN+DZeEo2hwsKYe/o8KfxbKq0R0282CfheXB
	 lAcuREQMv0cfoJS6zGuFQ4OLTuD2rRok6hMOlUfpZH4oICtRTsCFswWlryM4C+mH+0
	 50tdVv01yNvC5pKi9GWOjY5XV3ABmUB82gdYgc+XaJ7BJ6zjEPZaTDq0GktYHza0FM
	 fOd4kCqwRW3fCxxHmSV37pnfAnXbBSiRieWKRR5qvP71JT9pFCbNH6N01ntreosI6C
	 UklARm49eg/279HoVeKl9Ln/Cim8iHNyXzl501OJDV6w8J1uBHMmbovoLIw29OApQF
	 Y1YwiH5U387GQ==
Message-ID: <6f4a4ef5-0a23-4d89-9b34-a610299525d0@kernel.org>
Date: Thu, 18 Jun 2026 10:15:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: mincore: try per-VMA lock firstly and use
 walk_page_range_vma()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
 <6f323e68-94be-45e8-aff2-b64f5ef7bb36@kernel.org>
 <900d0057-9b21-4bb7-a53a-397079d301e3@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <900d0057-9b21-4bb7-a53a-397079d301e3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E56220009
X-Stat-Signature: 99a9znxrsfhib174i1yanwrjpgw4a5sj
X-HE-Tag: 1781770550-938279
X-HE-Meta: U2FsdGVkX1+Qbkrp6xeTW6tnRbrkinaEPTe2HPGJjnP5eBCIR/EPf2DCBga65dPOiMSheSe7bbFhEGiEFn9avs58fagN6eIDT4RMX3hHpiSgvoRqvbafdGUFIJv1fCBl5DmZqKel+XdrYHL6PZirpnUp70IJ+jZhWo6hKc3tnzqRNDzU+2wB48YjcVo/BHQLObCCoq0B7SeFv7xxsEG6VRrxVWKPd14uYbWKDtJ0bIAwuwS0EtXgsa1KVNpdDgmFH9ypfwKkaUqDJy8A0bBX0mthK7BXKWG1IifZLi3Ke/oBf6lXSfETaQq8Sq+5smS6keyo9n4bGiVim33b2hNtDueGIkbR4JGUe7BpsElxrmHxFqsj1bipqlV4OfDaKxxBPQTY28eO2b/FIDRJgJTcaC7NPexSvwbVccwbCM1XQcH1XN9rb4lffCvH3yCD3mJwyf4V1K9elPcHmADeyz9ZB8ebrb49Uo810xFUERFdztd4GA4X95kP8KHt0MNLcRgBfd+ILkxqrVN2zazpn8GnpbB9mLslJG6abIGhGyenAYnINLUtwv4aGmbYrvsfdBaNn6JG0QzR4VW9/8LsE3VOookquaGEHaqPt+64tGcY1nbooxH8m+WOc4R145jBbhd5dcG+72wH8Vu+j5G7vqmlVrHrWy012iv6MLTgjAdC/284AlwdSKxfI465MMq4R3v/wwc0bcLpxOJnS1nSZIDX41L2O3pzop+vunBH7xmW/zajmRXP2Uue64lSS48elqIZaf4eOt+SWuq0Ie4F5pZ9dv4H0+sT4QCDcACzBHLisN2WmAzYCWxN87mAJ93Nr9X5bBS1qdh6cGxPpTr6PIfsjVarogvyofUVsDYdw3QhEgYAb17vMfZDFyDWC5WsH8XBq/RRGRzVsUrUKq72Bth3lxsryR3bQIiPEZr7dBUpDqdd4LmjSFGfUTHxDKtLy8AAJTd7+V9c3p2rduIhxgW
 s1iVqEJM
 gLdVdS5REgwp6fMLvKzv9RuTjr9qqGqsskv9USGZXXdxv1haBoiS+plcZXDA3ZBhJaGATkdv4Cb4++Efpd9qjYJ11K14D4u1hk68rLnGmCyx4yKuTMJOxGn9x//fZK2WcA6kn/v43ErQL8ktFIE6a2q6zzP1s7allCwh6KqIlZfYQ9rtKPIy8mSJqhms6myxKsvqWAvFwM3bwaoKWFuetIYBa7F22IrkbZgMawgcq5+GM7w13z5ajhx7hkbwR0IB/ok3omMcLcBzPBCqqKU6rw+oRBYdoraCw+L1wX0O69f68mkxU1rDWhCrU2TeOx0v3C27IUQJJHMGZwvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 03:41, Kefeng Wang wrote:
> 
> 
> On 6/17/2026 11:01 PM, David Hildenbrand (Arm) wrote:
>> On 6/17/26 10:26, Kefeng Wang wrote:
>>> The mincore syscall currently takes mmap lock for the entire
>>> duration of the VMA lookup and page table walk. This creates
>>> a global contention point with page faults and other mmap_lock
>>> holders in multi-threaded applications.
>>>
>>> The mincore is a read-only operation that only queries page
>>> residency from a single VMA, making it an ideal candidate for
>>> per-VMA locking, so try per-vma lock firstly and use the
>>> walk_page_range_vma() in do_mincore() to eliminates an unnecessary
>>> find_vma() lookup.
>>>
>>> Unlike walk_page_range(), walk_page_range_vma() does not call
>>> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
>>> to skip the page table walk. Without this check, PFNMAP PTEs
>>> would be treated as present by mincore_pte_range(), changing
>>> the returned residency status. Handle VM_PFNMAP explicitly in
>>> do_mincore() to preserve the original behavior.
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>
>> I think you should first add a patch that converts do_mincore() to just use
>> walk_page_range_vma() -- which is what your patch series "mm: convert to
>> walk_page_range_vma() to eliminate find_vma()" wants to achieve.
>>
>> Which would already be an improvement :)
>>
> 
> Are you suggesting that the per-vma optimization should be separated
> out? This change is not too big, and I am fine with either, which
> method do you prefer?

Yes, I would split the "use "walk_page_range_vma" from "use per-VMA lock", even
though the first patch would be rather small.

-- 
Cheers,

David

