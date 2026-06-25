Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918A1CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C1C6B0093; Thu, 25 Jun 2026 04:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6145E6B0095; Thu, 25 Jun 2026 04:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBE66B0099; Thu, 25 Jun 2026 04:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2381F6B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:40:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3AF2A05AC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:40:22 +0000 (UTC)
X-FDA: 84917788284.27.7922E1F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 701F4160003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:40:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GGavGui+;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376820;
	b=igABoMks6Myljto8fUcDwrhBcvVmlMgRttT8YxEoGPzlsXpNhGFD8oFk3JowxlgYlDnSx5
	4dMf9we0KAEwQfwkjWkkBMbKUkFggj3vvAKCj/Tp9fAzVNIJsmqaemG1JCUKNK0/PJ2WFj
	aPfVi63EMd2quVwB7rjUcEfuwkeaqAs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUjgJdVQyEW5u/lgU81ldLj1c+A+HG4Zttd7goITkY0=;
	b=X8dXOytRac6RllIepDyHrzhCHQUMUYaXPZPGKojothBK35PnTQIJ6lI8FxRdVpXaSv2b8D
	+FcsuB3/XPozpeKpF9b5CEF/pFxL4LhRPb6kMWfo5/o5hTRvdhSld0N8dYtWS0icaTXyuC
	yYrijhe/paCl3A16KTG7ud3xpvoae4g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GGavGui+;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2DE52BCE;
	Thu, 25 Jun 2026 01:40:14 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C36F63F836;
	Thu, 25 Jun 2026 01:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782376819; bh=BWj4NQGKd4mjmlkdybirdAqawz1Y04I6GIWh4Gx5jiU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GGavGui+k0FYR7uIV3hPdH3uSry9W7h2Do9UqFdinnEraOlgikBT8u5AQd9lV8P1C
	 xyJzy7nC83ViHAtje4xZv8QlxTwwvzp/xA3ktS9ilzR1667loWyfqwZpBbSxmqk+c1
	 4WK1oEkh8K7hXxod9TzJ0MSZKS0+hycjFGvQpgJ4=
Message-ID: <d2cc9d50-3e17-4217-ac79-00978cd9e3c0@arm.com>
Date: Thu, 25 Jun 2026 14:10:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260625042853.2752898-1-dev.jain@arm.com>
 <ca31c254-504f-4857-bec7-10b8c2de94ed@kernel.org>
 <614e89a8-5108-4ac1-bdf8-fecca48bd91b@arm.com>
 <237cdb97-5abc-4c89-a0cf-1a961425f947@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <237cdb97-5abc-4c89-a0cf-1a961425f947@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h41mw8w7krsi3uzz5uemkx8e9k7utrsf
X-Rspamd-Queue-Id: 701F4160003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782376820-179494
X-HE-Meta: U2FsdGVkX1+O5qrQvayOUGclL1xCnOnDWh8GfhUSZiQix9tYBgNL+8QeQnXNQV4Pr0tkHqxsvYVyPbYrIFCnmmLZ8OfrPHJUohaC0CEFEpydMQVH56pEbwN9nLl9FSRbrw6XDe1XugJrQsp4H17ivvOtKuUSqiX3OJt7aTXp4LBRKbdsjtrR5QQkB+ldZk6kkhA7MQ94FUjgVHFWAsfnDCNpQkrlpIzw1ZJriO7wnprTC4gqjnyFB8ZXZnjxhsCkYaB1c7Yt+6lEr4wz3k41fdckkGqZ7A2PBXcSBEgdZVzWMOUWlyiWn6INn6UwuLXnE/WtfYxGFvb91EKx6WU6NRgV9wrqNhxpOj4+kmekcMkaMsB2z4IQaCSF1z7WhupyAFQlLXIQu3IDILmJkISzPpkot/fVzPH3NDcl9PzHCQdy/9LX0UXMcNPpU8IiogVrD2trYKWmjAPeA57816UAa/HzoNzpjiM9xu/++Rvi4borZrMd4sk2Gj2RJze9G3XwGBKSW3xA9VbvY1cdFntR3FykobynVvvhRHH2icLYB3ZSK74+pFbV1IcWp4Fuf68PND7Shf/fReGqgpyOA53yX+i8+czsNSYDZDU33wJpkZD5pLLnoKTyWcK4FnID3XINp/6IMsXSE5yRCD/osYBU+LA1brd4De1RhBL9jzBMBiLxNRWx6yRqCYBc6EgtTLJZZ2ieSiySaFgK8JQHPD6SaeIWkMzEShQEM0So2pXwAAMjj4S0J3yyPTmuxQMqsyXtAtzjjFn23FbokSkWH8d8VaBkZsF+zLF07wDthej8Z1iKPhCX9xFd7hW+3HwY3n1AM7fbqc5MQRa+OtFd293NEJPyy2X+FOlvsquAxti/7RfUQM9ttkOGVHgGOJUp9D5veox6M3Ja1VrrafxRuEgki92vk228H8Kt11AAfYY9ZDcgDZWhKs/xf4QyT1XBXmXJoDBxy8Qu5x61NFVxVVn
 kZ5tkXCv
 EB6yZ49VzBY/IP1sVSug4yMSObtEMX8IcQaBKuxDGuO0ASJcLRuEEi179YmLyW0KOlI+LKpMgKakoRrtMGqg2O3VQbbKVVtpEDKW2HAjAZmmg49bPE3i9qPMQrvVWINmrPNqtetaPFMwcDzTtH2/hCC5o9JSMS2UvPhFfMeMbn3OLxMi+MCPYWpuZXEgC2JP2jQ5Du3Fwi6y+vPFeND8/zhSBNNvVLL4d1bcIkT7L7LL0OnsAOFmHobjjFGtB2oDAtmBewgRmZOOZdYZG+Co6EXIpAizqdYt6tOr1gfktIqDuj8ncPA9ycNZ5cmxiqeLtBO1hLcu4AzAJgDLCPHBOkqBnqVt14HUihtb8vPbaFaljX3d0u1i8BYS8hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/06/26 1:58 pm, David Hildenbrand (Arm) wrote:
> On 6/25/26 10:03, Dev Jain wrote:
>>
>>
>> On 25/06/26 1:26 pm, David Hildenbrand (Arm) wrote:
>>> On 6/25/26 06:28, Dev Jain wrote:
>>>> try_to_unmap_one() handles hugetlb folios when memory failure needs
>>>> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
>>>> case page_vma_mapped_walk() returns the hugetlb entry in pvmw.pte, but
>>>> the code reads it with ptep_get() before decoding the PFN.
>>>>
>>>> That is wrong on architectures where hugetlb entries are not encoded as
>>>> regular PTEs. On s390, for example, a raw huge RSTE must be converted
>>>> by huge_ptep_get() before helpers such as pte_pfn() can inspect it. A
>>>> raw decode can select the wrong subpage, so try_to_unmap_one() can
>>>> install a hwpoison entry for the wrong PFN.
>>>>
>>>> The userspace-visible result is that a later access to the poisoned
>>>> hugetlb subpage can miss the expected SIGBUS. With DEBUG_VM, the wrong
>>>> subpage can also trip the PageHWPoison check.
>>>>
>>>> Use huge_ptep_get() for hugetlb mappings before decoding the PFN.
>>>>
>>>> Before c7ab0d2fdc84, the bug existed in the form of a plain dereference:
>>>> we would check the head page pfn of the hugetlb with pte_pfn(*pte), and
>>>> bail out on mismatch. This would mean that the hwpoisoned entry will not
>>>> get installed.
>>>>
>>>> I am not sure what is the procedure on such kinds of very old bugs - how
>>>> back should I really go?
>>>>
>>>> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>> ---
>>>> Applies on mm-unstable (d17fe8a046a2).
>>>> There are similar old bugs present, in try_to_migrate_one(), check_pte(),
>>>> remove_migration_pte(), prot_none_hugetlb_entry().
>>>
>>> Yeah, we should handle all these cases properly. Can you send fixes?
>>>
>>> Using ptep_get() on something that's not a PTE entry is shaky on some architectures.
>>
>> I can send the fixes blaming the commit till which backport is relatively simple. The bug will
>> still remain before that, where we don't even do ptep_get(), just a plain dereference, if
>> that is fine. Probably no one is running pre-2017 kernels.
> 
> The issue is that we would have to analyze in which cases exactly it would cause
> problems, like when migrating prot-none hugetlb folios on s390x, where
> pte_present() would not work as expected.
> 
> I don't think any of us has time (or motivation) for that detailed analysis to
> make some odd hugetlb cases happy.
> 
> So I'd say, let's just fix it in a simple way and be done with it. Use
> best-effort Fixes: but rather state in the patch description that this was found
> by code inspection and that the actual effects are unclear (e.g., pte_present()
> misbehaving on s390x), and using huge_ptep_get() is just the right thing to do.

Sure thing, sounds good.



