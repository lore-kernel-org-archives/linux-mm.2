Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FC7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4C36B00AC; Wed,  1 Jul 2026 04:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC0F6B00B0; Wed,  1 Jul 2026 04:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC306B00B1; Wed,  1 Jul 2026 04:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13F316B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:56:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 875421C19FC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:56:56 +0000 (UTC)
X-FDA: 84939602832.06.B190DB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C51CC40003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:56:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNMRHBeL;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896214;
	b=4iimX7880i2cqKOs9DhmLENshs0CMKAD0D664d3elcnyTOfR8zhLpx983SE1dj02PlapAp
	yuhH4xSNHLCm393xsQUAu0LW4ZVTaWDqRr1G/dv9O9Zq5VIpbtNN9sTuaEQAWmGY6UmAhA
	wLBW5eRnyZfnRd7Xk+RyJ6DU9F6g1xY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZ50nr0AcHZh8ITCWlGZKEWtSEWm6cGO1t20uNGyx4c=;
	b=sr7xpuzMAS2ac91rE0kORyeKFfea1/u1j6EjvzILPWdF67cElPBcoCvsFzGjrkOJEZ6cr2
	bFBCd3razwnzoPeMSPwCYPIGHDs3q9yu5d7rhgjBXYyULlpQxRLD1y/6q+d62pBMJKlkwn
	zvsYHhBbuvpzxu1nx87G7FB74IN+SZ0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNMRHBeL;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2677C600AB;
	Wed,  1 Jul 2026 08:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E691F000E9;
	Wed,  1 Jul 2026 08:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782896213;
	bh=IZ50nr0AcHZh8ITCWlGZKEWtSEWm6cGO1t20uNGyx4c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oNMRHBeLVJEjyBCVIOyZwbJuJWjy4aclyojSaJbTZm7x6ljvpBHyBpsGnAQPrlm5d
	 9pv3guPknWP21IPaX5BiKCFroDCPZaYod3KyhpuyvMIr4gXeZw+0pohRPo7w5I1m7B
	 M8lH89y6HA4nggcJ5T7ptiCHTGJEDhj70Wxd4MgKqyC1p7zRcjcy26bi+/MiHxb5cC
	 xEuOKP7Y3WE5BWJ3XhumRd0wkm+l3zqs6IYhaqbhVqsOzaLcdcYpKmHQM1NBdgs6cf
	 uI43joE12KhYi5z8onraPLG2JHQfF/UHtTpPhOgahZuzCLK9gSspytjDG2DTdgyurH
	 OCoDp4F5SBg8g==
Message-ID: <98cf3340-1a2f-4d50-8410-6e9d6d3a5308@kernel.org>
Date: Wed, 1 Jul 2026 10:56:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-2-f4ce3930d10f@nvidia.com>
 <9fe5173c-4beb-42fe-8f7e-385c609f899f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9fe5173c-4beb-42fe-8f7e-385c609f899f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4ar314g9fruff5eeq7dgmzgobxk7o8jc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C51CC40003
X-HE-Tag: 1782896214-168155
X-HE-Meta: U2FsdGVkX18O9M6/szZd+P7AT0uThwJeyzseeQSANZMF6aEp9yAiIlVM4HrvxFxoshoOw/VSieWNHm69Cxo4jU3twFI8bnbBWgxvosgEZwmlneGoew1AgZDdAFEYU/WdRpuNFKKUEgaTIHMIfNkFeqFgbfxYfj4m5VCbmq1a/GU6Di6wB3IAXw8PSOcEpddEXXZSjzTXW9536co6cxlWDR54u4IzRVLySSk9xTz3jfePC7F9wAgCDIBx7zU+3bZWll3/KYfI/2FpEvKPU6Wn972LzN4KYzH0yTr4o0ADxUi8zPfrvmgCNm4j72/BqERc5DaEy7tncliqNR+LdXLZvwoT+SkylFSdhAYNCBN4Mt3TFeAjF7kq73dG7fQf2wVQEw/yuP8zVX1Qh1mAfaP/p3tpxJFII4BSr6lXxoxFIPgDkrDyCi1vs3mbTFB02Mzwa+u8uOlOSD6tT4+/nUxw9NlZY8+3heHI29gznD5wDAw+0ingcQWjyyQ2QjqfZR2F/4Fnj5hMvm0wVCE3LUcg5JoyAkR9em2evzUgP7db1SDW8J+brm/tW41a+DiNSZN/+cv2tVdRuXgBAZLn+eYdaG689KWI0hHb+5wDMgMzvYjCtBXOiM2yOxaQU/h0Sxlf61aiOBn8NR44aNsEKZx1mykYqK/7DFQFKCJtV27gXpFpxVWAYoGb2zz5Bd1Ka93JPLa+sFlw+GICv/KXggweney1PyliHEA8JpsNCPWT3SPcP+bVqzUDyDUTTBXHqhJEdQ1CZ034v9O2k6PWKhXqUByn/ed+ECGOZk7C/Rnl8zMJsKQ+kBEnkdqtsxMWMUqmyHWtXDe6CQ5NmMI0v7/7sFyRg0RFuDMIM6XZR8EU8z3ZjGs2Gr0HCW2KJChf36ZLPQLlT3eVTHtjB5ZCUsz20yZs5NKgcEREcATaA/TTSPXCv1bK7MMsxpIURCnv6oTheiIGHWfROrKTRKN11hk
 2NDyo4Pz
 ImZ5BYA1FXPmssllA5q0ExsAW/XuKGhXlSTRJUF7YfYpt2UxUBrzEw+3FSW2a25ABBr9mnlGWjhoAZOsQZJcQA8x/RTIX5i9leOSCi/pmp+I57s0gBgNLLlQWrraTY1qe725qaaaMPXxC/wHCR8SpfvixqmJhx63qbGZru5i3Vnyd5nH6HQXRfcdhjBGoU3lKXFzVl39cK+y+LqSQcMewF7IjwZz1otie0g0IJGkayGAnnvwgHQgJI5wj7gGjdGuI9tGHwXJBrOxoSj5rp+SDcdbUduZe3mleskdP1T6wgzEnWciFvIQEcv0dqhyYwbYl+WmN10d/1mguj0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 16:39, Vlastimil Babka (SUSE) wrote:
> On 6/29/26 04:56, Zi Yan wrote:

s/add/readd/

>> page->private should not be set in tail pages. Commit 4265d67e405a
>> ("mm/migrate_device: add THP splitting during migration") removed it
>> without a proper reason. Add it back.

You can link to the discussion where we clarified that this was not intentional.

>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/huge_memory.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2bccb0a53a0a..037d67fbec6e 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3594,6 +3594,16 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>  		new_folio->mapping = folio->mapping;
>>  		new_folio->index = folio->index + i;
>>  
>> +		/*
>> +		 * page->private should not be set in tail pages. Fix up and warn once
>> +		 * if private is unexpectedly set. Do it before swap.val assignment
>> +		 * since private overlaps with swap.val.
>> +		 */
>> +		if (unlikely(new_folio->private)) {
>> +			VM_WARN_ON_ONCE_PAGE(true, new_head);
>> +			new_folio->private = NULL;
>> +		}
> 
> The unconditional warning means this is not expected to happen. In that case
> it's odd to check and fixup always, but only warn with CONFIG_DEBUG_VM.
> 
> If we are reasonably sure the current code is OK, and only want to catch new
> mistakes in development, we could just VM_WARN_ON_ONCE_PAGE() without fixup.
> 
> If we are paranoid, leave it as it is, but drop the "VM_" ?

Agreed, either "if (WARN_ON_ONCE(new_folio->private))" + fixup, or no fixup.

I'd prefer VM_WARN_ON_ONCE_PAGE().

(I was only able to trigger this once while testing my own patches)

-- 
Cheers,

David

