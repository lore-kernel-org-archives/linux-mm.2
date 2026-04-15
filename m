Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C77CF4198E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E540B6B0093; Wed, 15 Apr 2026 06:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C186B0095; Wed, 15 Apr 2026 06:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D421F6B0096; Wed, 15 Apr 2026 06:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2B916B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:35:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BD3F590D7
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:35:17 +0000 (UTC)
X-FDA: 84660433074.19.1BA96E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 806A818000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:35:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c0X1iM/l";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776249315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=am9Vfb1Aq580mnQo1cyYfFVKDwtcUwL0M+34cRZgLu0=;
	b=kOdX7dTxTBQjFcd+G7tfS+0g8wBr0YPNi7I9iyw/eJ0wZQpz1C8wnh3J7vwNa3qLPmqSSB
	A/yGfzFv4++I2HJS2UosM72h3uDv947lABSSwRR9rLf7Wq7Eu7U3/AAdtGyJWf0i818QUh
	PE1EtfCOLfcLsf+OmBnNZFRznYGiYwI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c0X1iM/l";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776249315; a=rsa-sha256;
	cv=none;
	b=b4k1wg0Vxe0wc5ZV3+k4I/I+Dc16nx3eou/KRSLmtnoRluOPKWS/1uueO/EQp7xSpTR5CW
	7Is+YntK9jwLuLixbqqnsrRWOBSwd8h6eafSyIrhbXtBPJIQ2ToFG9Ok27wCuc5frPNX0p
	I9NatbYuqoN0MFfvfYRBfYzqfN6InoM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66C1F44491;
	Wed, 15 Apr 2026 10:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECF4C2BCB3;
	Wed, 15 Apr 2026 10:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776249314;
	bh=bpHgcNl4FYMb3tMxE2yHLnHeP4ny/KqKAE26kXtowaQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c0X1iM/loYQV+lM9Y7nboPQ5AI057tcs4b3NzAj+4Ek9Mgu7fDkzUIT4bbM9KSX2G
	 XVawRbC0AKM05vBRWJMZWLNgk2qDYdhQdB5GpVQBGYgZpWu66sjDgz6f9RrRnbqgWJ
	 m6ays8iGIBJ6yqow4uNHPsK5Lix/zhsvs7/q/qc8015Ki9N9YyYJvj0b7V6NOr0qoY
	 s3r1xNWSe24u7FGHpMdykAN7BkR8hh/cp8OsqbQTRE7zVd9kToPNuXO6Tgo+OurmpY
	 2ZFjTof4Gzk32YdqX13IeddI/nNkWhEVd0oKNBs9/95fiT5m/8uBmxrRoQWk1jpgq9
	 U7ZE/jfalFfIg==
Message-ID: <d61a8e11-5b8c-4cea-a7f4-a890f65d62f4@kernel.org>
Date: Wed, 15 Apr 2026 12:35:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 07/16] arm64/mm: Convert READ_ONCE() as p4dp_get() while
 accessing P4D
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-8-anshuman.khandual@arm.com>
 <238ab437-06b1-43ef-86bb-9341c02040b1@kernel.org>
 <c490455f-084a-4f53-86b0-89c15669efb3@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c490455f-084a-4f53-86b0-89c15669efb3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 68uhbortxaomjawafnk163koarjwki9d
X-Rspamd-Queue-Id: 806A818000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1776249315-292704
X-HE-Meta: U2FsdGVkX1/NKo3udW/bhyimEHXFkst/FMSX6VdS6u3XZfZ5X9kP1qlrnAkVviBBZBllTer6KxhnL0Bft9OAqXoubjDpNbaWlAStoaOGO1pLSQM5qXpcanFAfhPcEdGV3xHJsE8/0rZSlxdPkl0VwwRomyohD4Y4q7XnO1acETtj9AKkObcXh2yIc0ZP1dm0PMhk9PzukEGn1r1wLAfcGxDwO7dZpvyfgTH99IUOW/t/zyZBYv6R3dOpy4p+ZAqMMD6zHOzHA3ghxnPOcE7oqF+2WlBY0yD8YJB3JxCRKTefqTg8QeTOYhKQmSbCnhnKHwHdbeDfmBRYXrLmMy5H7HY0aSixxgCZCg/qKRLwkqQsQT4fxMJTBGrabj9o57S8fxWheisuP5sE5vLpOYtGP8761jBJ11l/gf3vqx3zFYgYD1ljZLe5OLaFJdNqeIRkAz1dGIzdM4NKmod5WrvbWmd8ozWPtIXwBqF0FEhi1vlZ8zJxBDgjFuU/bR/oMVNzseAg8gdoYa7y2jfKo5dJ7blud0mUbL5hfMMmqrWZ6NvlKFo4gY9GP6N07WhtdnSrcE9Hac7MgpWKsQPirA7QMPLnp/jUD4hlA7U7cVch8My1AVPVaNsZJ219V32J/uZGxQ6tpsvrw/3j1Lhw+rB2AjhfArpvbBGlar9CbJWxEB8zpoce3cZYkd8SukN0Mm6jKAxOMfuWEcxvZazGPP7+r/ApKsYDtEQu4AzeASlfk/4zi4D/HmeD1lR6LsG3Udq6AeJrnKolmYJ5pMnOVzwWcJ8zHGZIDJX2OM0dsGO9CAjJ7Z43ZJa2XaP21FtpHvFCJMwZK3aCOnDhwnqSThTeBthasDRF8pNcbyY+Mv7YtdTR4LgdWiFYe+KqaVOJn69j1id6k6MYrbDTTgsI2XHiQ9ir3l4F+Gja0l3+Gvn0lS8xt4GuS81jPDML4xTw4WCD2yhAfaj6knJUcKZC3r4
 XOZetZBb
 j31OCKAiMO2HeODRbb1asGrdpcHuXVUsOOLVpLu+uwxUKUZwyoUoOWNkuRg3yLTa5AbTJ+13sztZbJBD3KpoQ//pteA01rAJt9/ipOLn8mdROQ8PZ4Zolbd/A+x9eFAkU/S1GKTDkTAVbt5lWQyesKJa7UJgnGdlqxIZC85HXXW5oN56S9oOYAZWl/TmAd8xX7VSJMU7w6aMyauFIc2yWlLm9q3tunuza9jnJNjANdR14d2BdpCwV6HpWIKLzJNL+7OLF1UBcqNMVIDj7yefRepp6XPdujqRR05eSdaPpdl/mnycwVqOHutZ0uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>  
>>> @@ -2258,4 +2258,21 @@ int pmdp_test_and_clear_young(struct vm_area_struct *vma,
>>>  }
>>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
>>>  
>>> +#if CONFIG_PGTABLE_LEVELS > 3
>>> +phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
>>> +{
>>> +	p4d_t p4d = p4dp_get(p4dp);
>>> +
>>> +	BUG_ON(!pgtable_l4_enabled());
>>
>> Heh, while at it, convert that to a VM_WARN_ON_ONCE() or anything else
>> that is not a BUG.
>>
>> I strongly assume CONFIG_DEBUG_VM checks are sufficient.
> 
> There are multiple similar BUG_ON() instances
> 
> arch/arm64/include/asm/pgtable.h:       BUG_ON(!pgtable_l4_enabled());
> arch/arm64/include/asm/pgtable.h:       BUG_ON(!pgtable_l5_enabled());
> 
> arch/arm64/mm/mmu.c:                    BUG_ON(pmd_val(old_pmd) != 0 &&
> arch/arm64/mm/mmu.c:                    BUG_ON(pud_val(old_pud) != 0 &&
> arch/arm64/mm/mmu.c:            BUG_ON(p4d_val(old_p4d) != 0 &&
> 
> Shall we convert all of them as VM_WARN_ON_ONCE() in a separate patch
> as a pre-requisite ?

In MM at least, we fix them up when touching the code, and only
sometimes convert entire files.

As documented in Documentation/process/coding-style.rst, there might be
some exceptions where BUG_ON makes sense (severe data corruption
possible), and some cases would want to use WARN_ON_ONCE() + recovery code.

All of these cases here sound like VM_WARN_ON_ONCE() is more than
sufficient though, so feel free to convert them all in one shot.

-- 
Cheers,

David

