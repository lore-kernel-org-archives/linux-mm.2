Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377C3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 20:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106896B00AD; Wed,  1 Jul 2026 16:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7226B00AE; Wed,  1 Jul 2026 16:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F2E6B00AF; Wed,  1 Jul 2026 16:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B36FF6B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A038A04E6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:09:14 +0000 (UTC)
X-FDA: 84941297028.22.A22D659
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DFB040009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:09:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=POD9t2s6;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782936552;
	b=sAdQJGWByN30M2UuAuepcHEA+NuLIzUnLLJNy2I0wFIM8UiZkeAEvOAHUpplakq9Is6LJx
	NTtUhdi1Z0MTh4v9yuq4gtZv2QjiIstTA3gK4/OdV5F1iEZJ2M5Sfc5Ja7EC0f5ulmhArA
	llHdcgEd0LaIxaRuVMLL7B5OoST2Ddg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782936552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yb6QajBml6PDRqEuDCEin9ZED3RkqNUP8x82FxgMrAI=;
	b=XbJGYjIh1wr+NEnU8/sLtRfJChNA7vsjfFVmSiDsOxyFhFe+sOMjL8mut8zEcHCWT/fsyL
	WMqaqZEBtcMb0MvgVsnPFWSj7o8eGiATI66bMdq7OjU8jGfrWHIqjyDJB7O9dMdns3ulme
	mO+XWWyI9TahmJCOnPqfM8k+iW+YmPs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=POD9t2s6;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B26426001D;
	Wed,  1 Jul 2026 20:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DB71F000E9;
	Wed,  1 Jul 2026 20:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782936551;
	bh=Yb6QajBml6PDRqEuDCEin9ZED3RkqNUP8x82FxgMrAI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=POD9t2s65qU++mvFAjTjg4Q0W8maUZraS3umK+8oRj5Soj+OU+VQ0+AL6FQX8nzfF
	 bOedh/d18VDJWBPVkpqMwCj6GesKeO1wwCxIE80qd6v7cEf7c43Mjw3DnhSD9aAdDa
	 II9TOK4DRVeUNZUPEygCtnXSUa3J+QA1f8lgX05LZL8GzQ1HSWTQoSjCle3JeKgti7
	 7GSPnGZfmdfEAPUdHvLX723YqNd3ZCDeiAgMm5xPbtKUoZ93p9BRLdfyEEiVDvGAAV
	 w0tNsGN0d5AUk+CMCcVPD1ZdZ7yeKzv/uwFQsoQEq46D1cQww8cqcTfgzULWJ6dxuz
	 nNWXPlZN4Vraw==
Message-ID: <22f9bdf3-576e-4146-89c7-64960207c5d2@kernel.org>
Date: Wed, 1 Jul 2026 22:09:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, baoquan.he@linux.dev, chrisl@kernel.org,
 jp.kobryn@linux.dev, kasong@tencent.com, liam@infradead.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev,
 shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org>
 <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
 <ajzm3pHq-wQlLNmm@KASONG-MC4>
 <c16bd777-6dfa-48f9-8dc5-2b56bebe67ad@kernel.org>
 <CAGsJ_4xh1P1yw3JogQxTS=Vu8kLEiMMh8si2YnCc9qnoKWLwjA@mail.gmail.com>
 <1e7a712b-33f4-44c2-85ed-6333ddca421c@kernel.org>
 <CAGsJ_4w8zK=xvWhRpyPiPS6JskmVnEH8E9fdQOYmk_PHb1bZtw@mail.gmail.com>
 <430e75bc-3993-40da-9996-71583e44c2d5@kernel.org>
 <CAGsJ_4yE-U5ox5y+brDBxEoc2uympQ7JBRqgD5OsqqX-u_6t=w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4yE-U5ox5y+brDBxEoc2uympQ7JBRqgD5OsqqX-u_6t=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9u9xjo9d47wdhxu817jw4awwog5r4tu3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DFB040009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782936552-802999
X-HE-Meta: U2FsdGVkX18KgVm+VZCNBURFcxIk0IoBVBqM0OECvt5Mqk4gyBBWIZ5Yt6VB7W9NNZQ/lPHhAD56yQG6CMCXVDO6T5GCM5eOYagmOMXDGPyhm4Xdt4k81NjRmuInj9X6J6JkNpy0lcJrCaleF5x3QmMF2C8AnZPvTx3V2Wwm1b+hKBD37qG78SIOJst3zzk0DkQG6K1N+qMoSWYHYAjSkm6rtcqU06y7ei0j4q1UtsdoR+1lxfsBrliQ3CatSW+oCL+Rsfd+4lUjuzJb2O5wLjxl3mTFqguZM9Bs+rW5N13W43Yqo48eU8Kw1Xvh0nvmF9CE1QMCVv5Pxpr9VJ1pW0Z/TDYjHkjEpsOHqV7XdErTbV/nd8dVdMq3QS6IiR/8MqK+y/B6zooNgbv/7ELv8Lj2TcPScZXDu9ZdE0j4uTla/aJoY9qrXx+fkbZ2iu+aaavLg8i5K0G60NtP0A7cnkZeOcAgoeoiUAT47B+qBDJlHrXdaRR78VJniYpJw1bfvnHhaViZc5Ha8yupUXCXfrFBcMIWNtFCPjPOBg200rZmALe1JMdjic64bXoH4KRBPRhii0cnqdKmjaWbxyYBah078R9Cjmv0MIM4dBur/9l8+hjfFXVwktZ3KDNW/BDFsWleJKiW7Vh4DMY+DNTZs+fdZGmjW4YODaYZAHaBtCi96F30hEYTEaKcxNJbvyhgU8DR9gN8koFTSA1TookAwILtRhyhb/0dMRPfnI+HvJwVjJOwSmuD8gUPvCAjEMP7IDqFw0pLmNWo3Jb5HAv/2DL+TFZTWh5b7D9pDDQDGJvMXc0KCyN8ohSMEGiNsM4M7VlS+gtiAhy7vWIvuWrfjhx2Try5vokPEM5MDVpp+AlemMc7HA7ZqEKEjfPLQvgWjfy2UThF78l2irqoofNOetsOfVKPfla8Xn2EMMiPk29u957rT9sdBynzY7LnJk68ISMmH4U2L/BoTPMURZp
 /xhRlCkD
 4VOduCbL/++Jc4KgbEejiywGkqrpkI+Sn88o77OLdHpopPJKNCMyHp8eKjYLZ0sqAFPnaQRhd/KbP9hqvkuI6uFrRiKUSUNdwfeNLNmdZq5hqvJ5rJn7Vu4IEZXotSx2lzj7V++PCrc/8iD/Wlqqv8muZWPfxAT4AWfmIMJP8ovtVevkHOftIMDeaZ1OwCsqxxaWix/kT5CLSb1/+UdZL8fuptI2Oc2k2NgBhHF0WjeHVs0KIOHCg4uqse3I0eUTQjf5TkZCjUC1aGye8MjTXmf0SyDNUgwGLttrVjxIsgpgCEwq0ANQd7aNWHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 11:50, Barry Song wrote:
> On Wed, Jul 1, 2026 at 4:18 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
> [...]
>>>
>>> The newly allocated folio will likely still be sitting in this
>>> CPU's local LRU cache. If we drop the drain in patch 1, it seems
>>> there is little point in calling do_wp_page() from
>>> do_swap_page(), since we won't be able to reuse the folio while
>>> it remains in the local LRU cache.
>>
>> Well, we call do_wp_page() here to avoid another page fault where we would end
>> up in do_wp_page() and actually break COW.
> 
> Yep. We still need do_wp_page() to handle CoW, but we could
> actually reuse the folio if we don't drop the LRU drain.
> 
>>
>>>
>>> So I'm wondering whether we should keep the drain in
>>> patch 1 by checking for a refcount of 3, or instead do
>>> something like the following in patch 4:
>>>
>>>
>>>         if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
>>>                  lru_add_drain();
>>>                  ret |= do_wp_page(vmf);
>>>                  if (ret & VM_FAULT_ERROR)
>>>                          ret &= VM_FAULT_ERROR;
>>>        }
>>>
>>> Otherwise, the combination of patches 1 and 4 seems somewhat
>>> inconsistent. It feels like a strange mix of sweet, spicy,
>>> hot, and cold—kind of contradictory :-)
>>
>> Yes, this needs a proper thought.
>>
>> What you describe is relevant for
>>
>> e.g.,
>>
>> swapout
>> fork -> exclusive bit cleared
>> child exit -> parent is single user
>> swapin -> added to swapcache and LRU cache
>>
>>
>> This is not very odd, so we should keep that working (I think I have
>> micro-benchmarks for that).
> 
> Maybe the simplest approach is to keep the drain in patch 1 and
> just make the code improvements you suggested in [1]?

Yeah, probably best for that scenario.

-- 
Cheers,

David

