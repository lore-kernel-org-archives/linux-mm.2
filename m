Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14749CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E629B6B009B; Thu, 18 Jun 2026 08:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14306B009F; Thu, 18 Jun 2026 08:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04586B00A1; Thu, 18 Jun 2026 08:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC166B009F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:28:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A22F71206B4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:02:13 +0000 (UTC)
X-FDA: 84892592946.22.BF30E73
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 16CC718000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:02:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sGjmNOWd;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R16Ogh5jvmaUmgJr1ztCh+iI1i0epNMNlmxvIDVA/U4=;
	b=eLEeTQCftDpSl7zyzyGXun9EXJevbuOK29lrvXd4R8YU85OpaCaowFX9awyPQKu7PpwklW
	CmrxnzMY7q8XfwIbAOni+mCunMDYnRvso4FIzMp2wWBoHMW2+oA5dsHxH9YAXGOKp/e7JJ
	0jrHEr0b7Wj4Z9LCmD0HS7s9I9yDv/A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sGjmNOWd;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776932;
	b=ODHk7GZZg8U7f7d8PLOEoOo45EXnfwrGgeIfY9t/v6/+8Ef7yC2IDn1IcUD+Iba5WOFJM6
	Umglr5e30VAX1RZEV9/zS/m8ogAfnmPW/VOlU3lgeZA9YkjSG3FJMnVvIsZNVieeBPm0qN
	lLK1OLuYJXYxbe/c74aRY6psZrqTDYg=
Message-ID: <22613c23-612b-4de0-8731-00ad2da63eae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781776925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R16Ogh5jvmaUmgJr1ztCh+iI1i0epNMNlmxvIDVA/U4=;
	b=sGjmNOWdKUg2mfdWmssriggDsHQ5jiTV02hjScnP+E0ixPGuKgfuqytH/A1b6WV7VQdpEl
	oE9ZVeHD+/Q/+QfW+gQfnDG1XEA23RKulM2xNsxykh6KnOi6lLtcBJnV9Oo0Masi2Fup1r
	VY7UrwgQGpnhQrBEnsshlOKlf7GTIEM=
Date: Thu, 18 Jun 2026 18:01:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, dev.jain@arm.com
Cc: akpm@linux-foundation.org, ljs@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, hughd@google.com, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <20260618074449.24974-1-lance.yang@linux.dev>
 <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
 <0fe2a584-c633-4f82-8c47-d204e3b39a57@linux.dev>
 <e64fc2f2-c4a0-434a-8d60-dcb28b99b8c6@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <e64fc2f2-c4a0-434a-8d60-dcb28b99b8c6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16CC718000B
X-Stat-Signature: huyft4sbk4btgijzyp7qmondm7jud4hz
X-Rspam-User: 
X-HE-Tag: 1781776929-761999
X-HE-Meta: U2FsdGVkX1/yec/NxkuysBj8sDAM4A4/c4r+FLMyDbKrI9EcA2Vt12tLJwttdBeaSDXwe+oDu/U2RFRugEqJpFDqhK/4WsMFGr2qxoyZtvsjgtnrchBoH+G92zhzIx02q7pn5at98xeAONfdwhtBg5t+UQRK0KzI5SUK0RbsMxxOUjvV9WTiIPGKY0KYx+Lc4nel6GLlISAb7XpkbT3EQxdLyMUk1J4q5ZDMrffdvZ1OkyWyB2jJImSbgaS7ODDDyT2zrvQuWuPzGqEiOMsBFszd6K0uMQ0QkiObRE2qxakVE3VqmHTQwox7xkbP4ElnSfFKZ7EJ9kO6fcvsht8leV5g++aj7V2zGlydABMaA70nTRPN/No1lGRFxqPI+MUNYcng85gBvAcSed9EyZ3a6OZQjX6Z7JmGED4Yih/MB8N2XBRVsGjE5IbHTwSw79K85HSpFYV+E78ChbBf7ozX8mguQzLIvl1dQF1GeR0KFSy9Xow9vusIXZmQyAgmLklDd0gqRWbcd8JnUvodb+p5hFGuwEG0vTng/62jPSTlwyDd3WJ+Nb1PeJZd5tLQfxS+g1oK7lLko1XQJ0Vsy1Iao9vUd9BzOcrEsCufJFeFYZnjKfFofrldFHxaarFclme7/gsQ8J4kEZx/hyHfWDBOY2vX6Y8qLeIjDQazI3bLu9oNlVk1W3mKtPl7G4y8zmGaNLRTX74q/ntqtsUiA2o06Qv/C1gxlI+wuJ59kCN2RW0uZzj87YTLoqOzK8IHVwx+4f92OQmvyJe01z45vU/w5Q7/YqfsfGh5NXT03tqF/aMySUbxcKrxPFi/IFqd8/dvepmzKnsa26adP5OcSPQD3x8ianLZuSZPw8V2IekbMCbb2gs0H8xliVQoxwqiagM+pEuoRZHIzut4XUcgYm0kt67XD36IKSrs/XmC1+W4c0+r1m6VDhJS4jII/EuikbOGkC/tstbNU3e2PBETEot
 KMbZfQ21
 Hf2HR9AEyKlFLIP1J8iloXpZmZZjGQT9G3giNImUCYg7q3cR7P22HrfxCi8hrB2VPoOJdlhLtP8HstFPXccYKD+vp+1PbVfJ/10FXXznUfby+1KGLnbP7JFTEKJA7ff62lVKNS9jvuQNUDhpz2EKbQTstwdGGlqx3NsFDRC0ig52oIhQpu5G4/jW61J1mYOtO/FTknawK8RuEftZ2P9RR6rQNlkWQPPwLCLHsUAi+yeHTSs0ALClz5ADLMZxu42Qar4PJ/D059+EiRXbEHjKJsbPGLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/18 17:43, David Hildenbrand (Arm) wrote:
> On 6/18/26 11:09, Lance Yang wrote:
>>
>>
>> On 2026/6/18 15:55, David Hildenbrand (Arm) wrote:
>>>>      return __rste_to_pte(pte_val(*ptep));
>>>> }
>>>>
>>>>
>>>> So plain ptep_get() can feed raw huge-entry bits into pte_pfn(), and the
>>>> derived subpage can be wrong.
>>>
>>> Good question which impact that might have in practice?
>>
>> The subpage check can warn, but we still pass that subpage to
>> make_hwpoison_entry(). So the hwpoison marker can end up with the
>> wrong PFN?
>>
>> +    subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
>> +    VM_WARN_ON(folio_page(folio, 0) != subpage);
>> [...]
>> +    pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
> 
> My s390x page table knowledge is a bit rusty.
> 
> IIUC, it would be a problem if some PTE bits in segment/region entries (pmd/pud/
> ...) would pass the
> 
> 	 pte_pfn(x) -> (pte_val(x) >> PAGE_SHIFT)
> 
> check. I don't think this applies, because
> 
> While
> 	#define _SEGMENT_ENTRY_ORIGIN_LARGE ~0xfffffUL
> 
> We also have
> 
> 	#define _SEGMENT_ENTRY_ORIGIN ~0x7ffUL
> 
> So these bits are not actually used.
> 
> What __rste_to_pte() primarily does is reshuffling present bits etc.
> 
> So using any other bits besides the PFN would be problematic I guess.
> 
> Am I wrong or isn't the present bit already at a different location? For
> prot-none hugetlb folios there might be a real issue, as the PTE present bit
> corresponds to the PMD/PUD read-permission bit.
> 
> 
> Oh my :)
> 
> So yeah, we should probably fix that ahead of time unless I am missing
> something? Good that we separate that hugetlb crap out.

Yeah, looks like this was already there before the split. Should this
be fixed separately?

