Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABBECA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 04:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80306B0088; Tue,  6 Oct 2026 00:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30366B008C; Tue,  6 Oct 2026 00:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91EE06B0092; Tue,  6 Oct 2026 00:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6216B6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:48:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C23F1C3572
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 04:48:29 +0000 (UTC)
X-FDA: 85290970338.28.BAE25F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A92D980005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 04:48:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsEA5ZIq;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791262107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUGgZYKffjWTe3V1ODHloSUeuNia8mWQRgDKRJsPR88=;
	b=2GBqcnucGRF3Hm+Khy47ntMCLLkqqyhuAG3aaV/na8y1CXA14E46OzTJSdNyQKEFNI0bkP
	aG9HlwEKOqf1RPElqmU+mMTorSu6pTeiHlejgsFrEBF+kKBTfxcBLWG/aiKQ3NOi0JYLYT
	TRs9Ezscqs326leIEE/DTIGrkVeFiWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791262107;
	b=JXEmR4WwTHUt9kYvqLf/Dz9OL63G82K2VOXcZHHWA9XSrNWRWWsANm85zN5bIXIlnt+u+r
	f4iB2if0DZtgha6nRqgPuEEHQmHC6GnKLkQOmaVPWxTK0hw+GZph0Ehh7bSmU6T3TqQ9WN
	ligajrlqOH9qH0VK2WIq6oZpqfcmVEk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsEA5ZIq;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 960574011D;
	Tue,  6 Oct 2026 04:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED441F000FF;
	Tue,  6 Oct 2026 04:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791262106;
	bh=tUGgZYKffjWTe3V1ODHloSUeuNia8mWQRgDKRJsPR88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OsEA5ZIqc/mPpRuhVowK4aw5jZ8eghvG7y0Pp/YXBR799iq/5qLtwCKODGdbYAjzM
	 mMXUwyZf8+0AyuHCOc9vOWN9viyle94GLCVlRkWzUvi4zF21a9PSK3aJ30kTwgcLoL
	 ZZhZfsMaHYTn+Ck7xOGxLqIF4KxoC54rxa/LhhG/yTxa1XWlKlSf37XVww0D+W5SUA
	 D+VqK62OHKXSYn7pfH1ldc0KsdhaMoM+FG6g1vW1gUX1JDaH/VXzVKDeLpCG6xqUPz
	 TibpvnDRZdCfT7m93htEvTZBXn4mc1H9WcjWwqJozM8WDuSjmZi2c9RZzrGvx8TGAX
	 ggrfME3ZVs2Qw==
Message-ID: <3d358c88-e0a9-47c5-a7a9-74edcf5e4cfb@kernel.org>
Date: Tue, 6 Oct 2026 06:48:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/14] powerpc: move has_transparent_hugepage() out of
 THP guard
To: Luiz Capitulino <luizcap@redhat.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <05a71b6011a6eab7b096f262485fcb8b4987976f.1789695931.git.luizcap@redhat.com>
 <f54d5d75-5cc1-488b-b640-76163419cf4d@kernel.org>
 <25bb02df-a795-4e48-9de6-99f1ca799176@redhat.com>
 <802564f8-1376-451e-8308-6f98d1efb099@kernel.org>
 <9adb6aaf-6e50-4ab0-a021-2529807dff02@redhat.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <9adb6aaf-6e50-4ab0-a021-2529807dff02@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A92D980005
X-Rspam-User: 
X-Stat-Signature: af4cb4fhzmsggwo8nxtgsei9qu1kbpup
X-HE-Tag: 1791262107-84143
X-HE-Meta: U2FsdGVkX181i+rzm8UE2ovXI8bpVUvDuXG9APzpRcYM+VSmiy5aba5kPRf/pH9KeqZE0aYnk2ldAwENm7nL/4hBRpizq5aVX6ftls5ziQoZdrd9PS0M0L3VLdf14yi/06mJNdzQBtJSamwHKiYVt3cJvz644Bv4ZXWzYvhlOA1owexsALLxw+duygfeTmuKZ7nt8LpmGRu0RsYVIeYk9pJ0ooKYVJYSrdGJVxVDfGE8/RwHfyQiQiAfePkTT//cOKHYSvv4wMpL1ocm226GbgwIIP0RucGBJ8wF+LNK6o+Mjb9GNMAmyDj6mCsK+qCeZECLnHf9vg/lIMtF5eI+gb6nbEk3I3RMLckrLv1a9ySqhnu/UQ/kGBvhuU6u+P+ZD00cMkRPKLsfMDLtEKujrB1FcxvmyHJOzm8PGZ3m6vKe14cFCDGPNMNOxT2792d/8InHvx9xjOe0qF8ASxnaSYzaI6A3nWUqXurQp30eqqbasGMtKAjYMYL119MSRcSUsfODlQaz/4xBAG6RNfho7qUoNT5eTyyNngroWDZBLGkJRYGNRQ4QGEe0BrFzsiFghtW1Rl/O0qcEZQXTQne/BvQDPQc8dAK+ErK7QNkwcCAR+Oeqar3NvJCF2CNmqaCiEo0oy382Zx//sjsHJsHzbnYEbasXyPTRtKPU87oLKypv/h6+uXCfkbnLtn8759ryitbYPe3Txxu9db32MjazDTiYhsE7Y3vjBpctN0J7piA2dVWDFG7UwBMQRrtN4J7Xm+EInWQOid+knUC9QhZZqdYX0VUb9Ovaqq5ijqosDWikflz/p2nPqLxmqJ+TxZoIOMqbZpokoU7OTNiqVtf27givKOmNuOJkWKE+U+EI8LOxDsbdlt6Y7yrzujj4GvoGb9yhwNadzxLWGB5Df9ytosgfIxc+FBdz4Ru4AYAd1NA4mfozvzoOPeUhkLCXtOo1o2zQe/JHgVvyNYMYhf4
 skcXy9pF
 PDh8jLWoImRno6lv+fSBHsNJQZJevRoEIySDZ8f2+KLLDY7rRk5I3UbBjFyPFQ2AXGYPfUeJgigd+sXgwa33GU2F+rzAvnD12OPaU7naDALMVWzV5fARGK/haim+0g8iQ3oLyw+ihKjZnhqEs23zAznacaDcIk/Ta0SYY/YGKGhXCxkppZXf8BY9x+Y+B719IIC8uycBRwl9AHShW+z6Bay1dHL9WJbdzWnGhdFKFG8vJsczHpFDWTvHsLMHHt+iciBqh2DO8ncOg4DK0+/Q8H7SaC7oiCgUXoHl6ZzsNdMwKKlVglfGrLnw90RLO7Wt8lSv4BNH3w9IkMFovAdObv9zf5YGpc2uLQdKitFA2IV5h2+190FpoTVVXka3spdbtyxwjhz78abvDAAjAxoxSS44AXg64AWE7cBoZwqijep7VQMK1wKS3sRnT9WGq0PDW7u2tKsCGvDnpfdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 05/10/2026 à 22:40, Luiz Capitulino a écrit :
> 
> 
> On 10/5/26 12:52 AM, Christophe Leroy (CS GROUP) wrote:
>> Hi,
>>
>> Don't forget <linuxppc-dev@lists.ozlabs.org> when you address powerpc 
>> architecture.
> 
> Will do.
> 
>>
>> Le 03/10/2026 à 17:44, Luiz Capitulino a écrit :
>>>
>>>
>>> On 10/2/26 3:28 PM, David Hildenbrand (Arm) wrote:
>>>> On 9/18/26 03:45, Luiz Capitulino wrote:
>>>>> A future commit will introduce a kernel API to allow for checking 
>>>>> if the
>>>>> CPU supports PMD-sized pages. This API will be based on the
>>>>> has_transparent_hugepage() implementation but will be orthogonal to 
>>>>> THP
>>>>> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
>>>>>
>>>>> Move its definition out of the THP guard.
>>>>>
>>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>>> ---
>>>>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>>>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>>>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 ++++++++ 
>>>>> +---------
>>>>>   arch/powerpc/include/asm/book3s/64/radix.h    | 14 +++++++-------
>>>>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>>>>>   5 files changed, 20 insertions(+), 20 deletions(-)
>>>>>
>>>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/ 
>>>>> powerpc/include/asm/book3s/64/hash-4k.h
>>>>> index 8e5bd9902bed..79511e6abfca 100644
>>>>> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>>>> @@ -165,9 +165,9 @@ extern void 
>>>>> hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct 
>>>>> mm_struct *mm, pmd_t *pmdp);
>>>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>>>                          unsigned long addr, pmd_t *pmdp);
>>>>> -extern int hash__has_transparent_hugepage(void);
>>>>>   #endif
>>>>> +extern int hash__has_transparent_hugepage(void);
>>>>>   #endif /* !__ASSEMBLER__ */
>>>>>   #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
>>>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/ 
>>>>> powerpc/include/asm/book3s/64/hash-64k.h
>>>>> index 7deb3a66890b..a4a44a112ff9 100644
>>>>> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>>>> @@ -278,9 +278,9 @@ extern void 
>>>>> hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct 
>>>>> mm_struct *mm, pmd_t *pmdp);
>>>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>>>                          unsigned long addr, pmd_t *pmdp);
>>>>> -extern int hash__has_transparent_hugepage(void);
>>>>
>>>> Without some of these helpers in place, I assume actually using PMD 
>>>> leafs
>>>> without THP would require some more work. (which is not the goal of 
>>>> this series,
>>>> just asking).
>>>
>>> Yes, you're right.
>>>
>>>> I do wonder whether the architecture should instead simply say "not 
>>>> supported"
>>>> if !CONFIG_TRANSPARENT_HUGEPAGE?
>>>>
>>>> That should still enable your series: using mTHP without PMD support.
>>>
>>> Yes, it would. However, I think this introduces an inconsistency.
>>
>> powerpc has two types of MMU (HASH and RADIX) with different page 
>> layout. MMU type is selected at boottime based on the capabilities of 
>> the CPU. For transparent page you have:
>>
>> static inline int has_transparent_hugepage(void)
>> {
>>      if (radix_enabled())
>>          return radix__has_transparent_hugepage();
>>      return hash__has_transparent_hugepage();
>> }
> 
> Right and, unless I'm misunderstanding your comment, this supports my
> position that the new arch_has_pmd_leaves() API is all about reporting a
> hardware capability and not tied to THP support.

Yes my comment was in reaction of comment below, I wanted to say that 
CONFIG_TRANSPARENT_HUGEPAGE is not always enough to tell if a powerpc 
actually has transparent hugepages or not.

 >>>> I do wonder whether the architecture should instead simply say "not
 >>>> supported"
 >>>> if !CONFIG_TRANSPARENT_HUGEPAGE?
 >>>>
 >>>> That should still enable your series: using mTHP without PMD support.


