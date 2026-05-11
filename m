Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F020FCD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442896B0095; Mon, 11 May 2026 04:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419836B0096; Mon, 11 May 2026 04:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F766B0098; Mon, 11 May 2026 04:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 219CE6B0095
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:32:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA6FE1A05B5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:32:44 +0000 (UTC)
X-FDA: 84754473048.10.053B3A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E2CDE40009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:32:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KWNi09zk;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778488363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7thnP23IxNjvXPG29QaGb5A8u/LfmwYVVuto708drc=;
	b=HnhxcqKrnQ18SF/0VscqV4701unYCasyIRQaO95n69sCEsCxPZ8t9oX2Rti8nT05RP8twY
	gH8KyzatvMeQdjZmwC1Bc2/mCdrLuLIecSs453ORQWkT2mIGCnbpuuXfBGx+H58pwimJ0H
	mdhPPgOWQ5VGya8igesxFOfhKtIlim8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KWNi09zk;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778488363; a=rsa-sha256;
	cv=none;
	b=f1lCySqqdMhrF8TPH8O9Alvtb/Jw9/mXeezwmTPEkFh31GWFU5e1I7soBHR6cK/p0jJzqw
	kni5XUSZCaBWbsIwvu67/3mdnaGH1boMpQr1bvUZOs33bFfsXZeuVl2d080p0fT3L0qKP9
	3q29eBv6dXcpEgbnH1WgfdTxDjZujSg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEA9642AA5;
	Mon, 11 May 2026 08:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9B8C2BCB0;
	Mon, 11 May 2026 08:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778488361;
	bh=2TxP/yheNSdnrIC4zW6oOFELCk4Q4qukZBA/NDC6JVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KWNi09zkBGAfZ+wg3snaX0JS2508dfUwSqkiYgzJWvjOxolSx7ELPlhs4nPytNWvF
	 pTL/aXwwOfFq6QnyyOJYwi/z8HQQm53s/Fp113ci6KYc/15yGi33cBH03bt0CkHuZK
	 2rTY32n/vv03LcTzq8MfEuuUiorlNMB1M+etnGaEg6unh0hqaWtbC5XE3TvdalnXFI
	 0wRqnSivi6T/2nY4tWqcjhT2ryIJEyn4Kdktlkzop3x4hIGqoHraPBou2akHlKaBgD
	 bQzO6PJIt/zZiNQdBWVOZab8i6ANiGmk5DqrPY+FfFruw9ogCaGQXww04cU1dxAaA8
	 fUxALblsiJ2Eg==
Message-ID: <771a8ee7-0a7c-4d70-9e7a-cc08abebd4aa@kernel.org>
Date: Mon, 11 May 2026 10:32:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-2-dev.jain@arm.com>
 <de2f992c-dc93-4b79-b841-11f47511dcfe@kernel.org>
 <06029485-9e85-4d2d-a324-abba918eecf3@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <06029485-9e85-4d2d-a324-abba918eecf3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2CDE40009
X-Rspam-User: 
X-Stat-Signature: boznh6aqxi7146hczjxqp8nxaxec951t
X-HE-Tag: 1778488362-115364
X-HE-Meta: U2FsdGVkX1+f6waVyDb5Rq0zs79gMu/40iXl8rO7hjCCdyND/of01aa0YsjY4hmTCk2r9X7OSaJOq8kHJKl5daNOkmmH5inm/tVXpaqcE/Ioq1rJyeQ+WXcssZtBv7/oqOWUZiq86viegR1QWy319w2zeLdki29i8W+CrVAybwA/wxx5iMnLSgTlt1iBbzxGNeb4ijNmH5ZKGaBB9OydFdfebnkdqRWnGANi2cvOxORrnFJcLFZZ/ZGVJYTJeMgfO+/vMf24TTUlu87wmi2WECw0FKiybwRWitqFDhj6q/e2GSdmwZY1MdPWas6BHh+iA5Cw9B2ZNz8y1GtWiFU89IIDaLPkdUam1IqDdUAFCYd4Y3Pn8hw23spT4UTtupN4PdmErufMQL19QqlBLA0Z/CNqCWvnLQ9shu9QZRTiOiDDVa3ZCsu2Tt0KYasrGzkcfWsT/uGcrIWlhftvnKeyZJMXoKQW5i+rBJQPTu8ufi2qiRsoiyTEgNCnBIBEGnWokcleCM3tGOjrz25lF50SWyyYgilgF9Z0ys+q/lfy4qZ/bSsKzlH02dukn4DOX4yKkfFLoi38Z7YIRbE7whgh9YCCZpsz0GJ/rkDSOjPFI1rWYZzOUlSjf006BcaNQrgEdsqXVkxGbx8TH5RfNRVtJC/v96Km7Mtu6hJ6AxhQyq+5uF0CmeX5uaGttIbJOPUS+2Qjq1ob+Yi8mYTYF4IGNLUYZ1noEopQcsxTxmZSCpZmB45qeD3/RU9AbAzALb/l9dasUooxTnbEdwZE1JM1GVPN39d9OaZIwIP4mg9vlCJYLUjPt3hrcT7QaUwirEfEFli/mnmKrKDceXR5eg50m/eg9c8JXRYVSQ/YuhG6LyGOfCs8q4kBtkWf6pq8ROSUmscdViTsALeIHgi3mHf0TbNX0cazQrxgrmyDsRtDp13FKbBNWn8E4e4uybzoVwfHABI/T/ld/WI3we3ttNO
 Uh1JmJNr
 U9Ms4C1uJBsqo5U3M4P+EgN+s5KIvgMQSUSl2fwd/8xs47WeGxYPFETVpQRHL6naqXXNEqJBlHpQBfySaG4oR0wrwXijxA6mcLUmYRBtT+TOUYuacRVxrHOVbuRANgJ40rTZ1DtFIPSlQ4MEH/Tocc2quCHvtao3OcI3/kDIwSrPItpFEa14kncPL6ZYD2ukk9mwCfEQ8Iu1ylmqQdP7zEfYQcThm89TJcQFoQ/hRri2MVNFAqTJ1p6695vK5zv96MEinpqi8OgEJtpdjcSk6mGb66YTyS63mYvLcwv/0t+OAU/DNYxlracxSx8sb+Wj8XUsJhLdXT61nkEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 10:18, Dev Jain wrote:
> 
> 
> On 11/05/26 12:18 pm, David Hildenbrand (Arm) wrote:
>> On 5/6/26 11:44, Dev Jain wrote:
>>> Initialize nr_pages to 1 at the start of each loop iteration, like
>>> folio_referenced_one() does.
>>>
>>> Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
>>> can be reused on a later iteration that does not run
>>> folio_unmap_pte_batch() again.
>>>
>>> I don’t think this is causing a bug today, but it is fragile.
>>>
>>> A real bug would require this sequence within the same try_to_unmap_one()
>>> call:
>>>
>>> 1. Hit the pte_present(pteval) branch and set nr_pages > 1.
>>> 2. Later hit the else branch and do pte_clear() for device-exclusive PTE,
>>>    and execute rest of the code with nr_pages > 1.
>>
>> Right, for hugetlb folios it should always stay at 1.
>>
>>>
>>> Executing the above would imply a lazyfree folio is mapped by a mix of
>>> present PTEs and device-exclusive PTEs.
>>
>> Why lazyfree? We use nr_pages also for
>>
>> 	folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
>>
>> and
>>
>> 	folio_put_refs(folio, nr_pages);
>>
>> Given that make_device_exclusive() operates on individual PTEs, wouldn't it be
>> possible to trigger that?
> 
> At the point of this patch, batching is supported for lazyfree and file folios.
> make_device_exclusive does not operate on file folios.

That makes sense.

You write "In practice, device-exclusive PTEs imply a GUP pin on the folio, and
lazyfree unmapping aborts try_to_unmap_one() when it detects that
condition. ".

But I don't think the get_user_page_vma_remote() will set the pte/folio dirty?

And the pin is only temporary. The caller of make_device_exclusive() will
essentially immediately drop that reference.

So can't we just hit that?

1) Mark PTE-mapped folio lazyfree. Folio+ptes are clean. Can still be writable.

2) Convert last PTE to device-exclusive. get_user_page_vma_remote() only need
writable ptes, not dirty ptes. Caller drops the reference.

3) try_to_unmap_one()


Note that make_device_exclusive() documents: "device-exclusive entries are
considered "clean" and "old" by core-mm. Device drivers must update the folio
state when informed by MMU notifiers."

But if it wasn't dirtied, there should be nothing guaranteeing that MMU
notifiers will set the folio dirty when MMU notifiers are triggered.

-- 
Cheers,

David

