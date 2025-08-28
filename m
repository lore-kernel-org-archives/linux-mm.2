Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F90C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E141E8E0006; Thu, 28 Aug 2025 05:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3E08E0001; Thu, 28 Aug 2025 05:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB31F8E0006; Thu, 28 Aug 2025 05:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B42558E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:46:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55A1284614
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:46:54 +0000 (UTC)
X-FDA: 83825687148.13.78DB3B1
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2997040008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:46:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FwH4xY7j;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756374412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5UZMuVtzlTYwPVWKKP1nj4b0AXXLsi60Juw56Bu+zg=;
	b=fsOQYGWX0Nwxi3i/SRAl7vWdTiYVYF6QzxqEvD1bdAgocEtg3pEwZJ4317X/ZYRlUiBeKO
	Lq5L7gbQq9E/EnE1wn/xHvcTq3gMrvQTfHEOwVY/4tO2ggMeVma+/8WAUthEMn2Ez/GfY8
	dVa0ld0FSOXrhTx3Szgdb1Zfa46/LJg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FwH4xY7j;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756374412; a=rsa-sha256;
	cv=none;
	b=4NS32IZIIUWf6UV7ZEQaZTgg4yhhAakwEyyy1XRnC5XZuHkoSZi9ihUzAD/tKG86MUYrkY
	Uh53lZXyGIsye1kgjF60D19phoYH/0oILcrb+Rq3G0K/5VASJqkKSlzX+dxizUl+VNvNY5
	HfcusicSXdwYk1xZqSxZEnPODnKo0k8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756374407; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=A5UZMuVtzlTYwPVWKKP1nj4b0AXXLsi60Juw56Bu+zg=;
	b=FwH4xY7j2uOhWyoslbY3e8r0D+ivRCMcIijff+wct3MTTloSOSSHcAxzTnFEtz9wLr5jIoZXQg9YK/6HF9v3PadaFqw026lmj6FJkaNXCECYP20BjS5APPqBh8ysov9v5dGAuPYXDuDMVtFiLXNlOgKTengnWfHOLxLEzz4lSgs=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmmpNqb_1756374404 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 17:46:45 +0800
Message-ID: <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
Date: Thu, 28 Aug 2025 17:46:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2997040008
X-Stat-Signature: me4hinqn7xm7ikcs39h6siyxenn3n1se
X-Rspam-User: 
X-HE-Tag: 1756374410-126080
X-HE-Meta: U2FsdGVkX1835YMcZaWdHIRapDojJsWdL/51WoXJWbW4E69HhWjXA8fIVZ+zoJ49fYvNg/o9qAXqA2KJ0EacCAb2ZmwKa/PFwcsfLvfx/s2HsbmAvYMNsjO9BqG18G3214lkIkGrwHjcrscgn4WwC8TXaSgnt1vh7Af0ZZervdJCrgc20GW7cuEt+6/Fihdj7x8weO3B/pfPKkZBekgDFpfYrMAXxtCHCLMkOxy5+/ARc6qBajV4azsV0vqn1NGmEV8X8wO9RnjoZ5YRNIknd9uCIMEwlSvyvFrPokpB5vt444GULqTufQQiToq56zwFM5RnhhsxNV3Ar36pJ5GFc0pTIBB4sy05Ad+teO0t3D89L8XAnY/HDKyVTyuTyFCy9HUap6O+8k0yr34+IwKhLitNDZe8FosMRfSYPBorklWpui3qfrwSAcVq/5d5aur8Mnk+DVsCW0qrfdQ2TTqx0AxiOCO7PHNYjb6FNEMV8jczo8hpBZLiYhZqFrAUtm2mLbYD5OmVO179utybUH+/I7O71uqoLuYrRprqYG8AE060Wj9122NXwNlyn5yXePHR6TBQS08gOTi5QEEdMVe0iOFtBMbFAz7yzyix0RQBlPlk8SBjWTipZ8cAOBz/QooheoBNAE6Acq56Yrfo3QqQpe8MwI0sM5cseWkn5oDyWB4hlJiSg0JAI9yWM9HPxGRG6uZmFoFFNhq2qVbmQpwX2Ojqfe/87NwM6Bwi2kD4Tg47xMJCeYxSw07irlLP3XL07tDzM4KrU3fsSemu0e+IuWOWNVfdSLnoYTFylLD8g9tPWBicz5i9ePnyRuKHZqfWD3BMbYPz1IA1A1ABWwjQk+fpNKQRJd0Z0FGn/tQlhwjyKIA+F+XwIteqFUnqIDU4b5AuX4WLsVi3JFhV5CwrKXl8fR5yl7DGv2vTaLZNhvkNu1xDj6n8VZ8oIhf26WTF9JQqjSLK1qCnKQlqp00
 gA2VIvi9
 zgSegGTCDdzH9u/6A/Y34O22/F22RV0S2wGOqi2sOVzr/bS6YoOGhO33k9XCThVP3Y3WntDqanM0Potrp4XcCsk/Pkp9KgEl2bo/oZKtxWkEDqvzoUuK7MVbCkqPo1STRIZITM5/WBZkYstc6x+BzITRDeo86SBR1lQb0VrITv4lviUOtph8NJCotnMBZRwVv070UaHo9CFqwzsFfaPvIeFq40ExzyY+wwZrHq4s+PVF04zS/fEY/krl7pN3223hxzHB4t/uRAAoH2RFefGA8X745l2xIRFeMcp6lT/6WaTEzV7AUHbFNzkCqquYnJT47SkeoB4dI7qyu93c9UJ8xOy8XWGxaskeQqMPd+zSNeI6RwJHlfi8y9GoZtiufQJpG4+MnO9F3ZeznA78PURGaoKetdkJPXpz1rE9L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Sorry for chiming in late)

On 2025/8/22 22:10, David Hildenbrand wrote:
>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1), 
>>> but not sure
>>> if we have to add that for now.
>>
>> Yeah not so sure about this, this is a 'just have to know' too, and 
>> yes you
>> might add it to the docs, but people are going to be mightily 
>> confused, esp if
>> it's a calculated value.
>>
>> I don't see any other way around having a separate tunable if we don't 
>> just have
>> something VERY simple like on/off.
> 
> Yeah, not advocating that we add support for other values than 0/511, 
> really.
> 
>>
>> Also the mentioned issue sounds like something that needs to be fixed 
>> elsewhere
>> honestly in the algorithm used to figure out mTHP ranges (I may be 
>> wrong - and
>> happy to stand corrected if this is somehow inherent, but reallly 
>> feels that
>> way).
> 
> I think the creep is unavoidable for certain values.
> 
> If you have the first two pages of a PMD area populated, and you allow 
> for at least half of the #PTEs to be non/zero, you'd collapse first a
> order-2 folio, then and order-3 ... until you reached PMD order.
> 
> So for now we really should just support 0 / 511 to say "don't collapse 
> if there are holes" vs. "always collapse if there is at least one pte 
> used".

If we only allow setting 0 or 511, as Nico mentioned before, "At 511, no 
mTHP collapses would ever occur anyway, unless you have 2MB disabled and 
other mTHP sizes enabled. Technically, at 511, only the highest enabled 
order would ever be collapsed."

In other words, for the scenario you described, although there are only 
2 PTEs present in a PMD, it would still get collapsed into a PMD-sized 
THP. In reality, what we probably need is just an order-2 mTHP collapse.

If 'khugepaged_max_ptes_none' is set to 255, I think this would achieve 
the desired result: when there are only 2 PTEs present in a PMD, an 
order-2 mTHP collapse would be successed, but it wouldn’t creep up to an 
order-3 mTHP collapse. That’s because:
When attempting an order-3 mTHP collapse, 'threshold_bits' = 1, while 
'bits_set' = 1 (means only 1 chunk is present), so 'bits_set > 
threshold_bits' is false, then an order-3 mTHP collapse wouldn’t be 
attempted. No?

So I have some concerns that if we only allow setting 0 or 511, it may 
not meet the goal we have for mTHP collapsing.

>>> Because, as raised in the past, I'm afraid nobody on this earth has a 
>>> clue how
>>> to set this parameter to values different to 0 (don't waste memory 
>>> with khugepaged)
>>> and 511 (page fault behavior).
>>
>> Yup
>>
>>>
>>>
>>> If any other value is set, essentially
>>>     pr_warn("Unsupported 'max_ptes_none' value for mTHP collapse");
>>>
>>> for now and just disable it.
>>
>> Hmm but under what circumstances? I would just say unsupported value 
>> not mention
>> mTHP or people who don't use mTHP might find that confusing.
> 
> Well, we can check whether any mTHP size is enabled while the value is 
> set to something unexpected. We can then even print the problematic 
> sizes if we have to.
> 
> We could also just just say that if the value is set to something else 
> than 511 (which is the default), it will be treated as being "0" when 
> collapsing mthp, instead of doing any scaling.
> 


