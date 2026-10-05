Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7AA6CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 04:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AC96B0088; Mon,  5 Oct 2026 00:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB6E6B008C; Mon,  5 Oct 2026 00:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511A96B0092; Mon,  5 Oct 2026 00:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2793B6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 00:52:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA5A3160124
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:52:40 +0000 (UTC)
X-FDA: 85287352080.13.0911620
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40A2FC0005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:52:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhZ6DkPv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791175959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgeHzxHQ5p6pOK3o0bpbw4gdkXFbQVK+Bxib4DUA518=;
	b=Wn8a8Q523rHqxN9GPMyufdXRsxhf64Noi6jpmKA2uPp0o+hI3WjirOGXigzMQpnKav5X4D
	X4Xw4NgU+FnQ+ljiqEUHQe7JpB9DG6csYrO4aEdAiQQItoY//MEv7DMlXdK/PHKk4bc76y
	heQrUMWnO/d2A+9sHBByGOoiTmZYC5w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhZ6DkPv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791175959;
	b=8odt6/wHaIhyIgOnVeJNTLEAwcFY4bYx/VtMNJVzQr50CyufgjadKyz7+5NLyxygkBNqm7
	2nsHnZYlZTaMg/xemxNQjzmmP/gFBX6GYa1TYGerIBHuzNJC0O0pYugLgccUiLhWSH5Vt0
	OrjuiHyINo7ealqGE/HH+WzD2mzqzUE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 203E16022A;
	Mon,  5 Oct 2026 04:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5D41F000FF;
	Mon,  5 Oct 2026 04:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791175957;
	bh=tgeHzxHQ5p6pOK3o0bpbw4gdkXFbQVK+Bxib4DUA518=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LhZ6DkPvu/CoOBPRzNG1DhOEHHqlaVdsmXRzBnLlEWnqCFfpAYuceGVUNQJZHlMuw
	 gkb/KIz5DgdHFfKYiBPx8QuVQNXYD8LSlJ5OK6ropaAG1n2cCrJgVtuXxTj9UGkDGY
	 d00j8TypicLptK30ZVNnCZ2jX5SXvK3pcVZ51LPYkHFhFP0Ze+emPMgtSYd7G16iJt
	 RnGJh0g0MDV/SMpvPWhceAou17U6VDzcQ0cW8VS/qk0g8elN6DSO5TICcWZ0EHI5OE
	 BE7c+JgxsEYYhR+ukWXBWPn4i3yuYyrKmgx7HBJFbmzU2HQ1BvceG9BrIQ3Gg5akks
	 ac6+o05tU/D+w==
Message-ID: <802564f8-1376-451e-8308-6f98d1efb099@kernel.org>
Date: Mon, 5 Oct 2026 06:52:26 +0200
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
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <25bb02df-a795-4e48-9de6-99f1ca799176@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gpw65oziki8641rmzo3zmksngwnrenf3
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40A2FC0005
X-HE-Tag: 1791175959-429603
X-HE-Meta: U2FsdGVkX185zcOTJKFF9hfPWb2W75DG1RoTfeJaBs9tEwMcpvppLysfNOwUaddq+aAFjB2WnS9ENml3G/tThXHrSQaODMNAlmevVSO+VsEPIqhzoeqy6Jl0ZT8SZkRv2XArj3cS2NZlnKNBDn9WdE8NCHCDAEhIoCmn8k2z3QE/7J2G0CgWidaAxN1GE+RB9cZs6gXmRzmV6bbzGENAwi2dxozrtiyQ3aBJ5nb9gcdiuNIG7B2Qrr5Wqv6wC8V3Svhe4gG9iP7+YiCz7WTbzZRFKXMEd1YF5JkpZBuoJMHjvSlX+Rn+ST2G/xm6nc69RYq4RnhxW+BYaB77sPc0E6bYZdtpgsaMlD7IknJGK0lZqqmlDfdz8wlzetwe8huIVeo2Yln0nq2DPCtAs8ZNDfshlhhkqAIST4YTWf7xBhJtXNfMzCZsir7m5aA32mAerxd7fikEk8h/XuDClXEDL5Fssi2w3z0kByEclUBa0IbnjuZNrmU9wZEKUhKoPW3dEDYd7rwllfe+olpkhv40bjAD59w1tLfiMSlqRleJmzIocTW9ov5/pLnrPPkbJBEvpoJ6PzInmgqyDSiK5AkQRJ4AE5+3atd3Y+r5rtiVQ21Ttde0KSWAzxCMXy1MElZ8uTHgEKj7ZpchnfyiRsSmw0brjaMIH/wNSA6I2tAACHHaCPzyhxKMGUiJO3wGRRymwD/NNushJwUr3kAYQLtYsyOgmC4E9OBwHe190uzmcf7DjdTtKaxgnDKtkiiY3SHA978345nXUgkYqNuBiFqS7WULA37zbvS0ZN9ZuaJuu3jdryg9APOaouPWZ6IYkAEMKyMtqF6gPvV8aEcQGQZbRo0fkQeC7REQ84hKfK1LJ0AR16gd0fk6L/GWi3DHiJvG36lmh3NoAZ8vKTXHMRQXi5Lxxia1N9YErviRcJkrF3u0FyYpaFAdghA4ENE4OMsQNfMNoveW1JKb3HY41iv
 p0XI2kxB
 27TucVKKQJc0A6UGssDLdfm98kJhWfuz02DsFO22gsK2+S/vRptXIPKamk5HHu5SuxuL/hjW57bOxGG2GY9dS1EFgIshV9TVuHC5YadohG/V3QiHonCYX2tw6AlJvs6yuMUF8/xfCOVsmigK9oMYJN4PzMKJZ5vNEoKi/mwBlH5npIA/9zqW8MXGYtcey29QgEvMke7S6kWE+qUfjGnWELZjUi2pDw7mQlIav5lbEYzR15ETsiF9O/LcZBeLBDWAPuCrRLff8bOdWcmajKM+jn0U0/iP0UdBGa4zP1CkLGBEa04erLXPUntSKCA5FOl5q4wnleHKrhXRBrbr9A3B6O4tcyz3M/Jg/XfesyN5EZd2tfa1NWWwzUfN4JjUxyjLq5lHWH9o37v2gwZ/J2uOTgnMcD/A6ch7ecmYhDZgUf9I6RDoV+DAzTMAbB4c9AxQQwoyrw7Z7MKXekvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Don't forget <linuxppc-dev@lists.ozlabs.org> when you address powerpc 
architecture.

Le 03/10/2026 à 17:44, Luiz Capitulino a écrit :
> 
> 
> On 10/2/26 3:28 PM, David Hildenbrand (Arm) wrote:
>> On 9/18/26 03:45, Luiz Capitulino wrote:
>>> A future commit will introduce a kernel API to allow for checking if the
>>> CPU supports PMD-sized pages. This API will be based on the
>>> has_transparent_hugepage() implementation but will be orthogonal to THP
>>> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
>>>
>>> Move its definition out of the THP guard.
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 +++++++++---------
>>>   arch/powerpc/include/asm/book3s/64/radix.h    | 14 +++++++-------
>>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>>>   5 files changed, 20 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/ 
>>> powerpc/include/asm/book3s/64/hash-4k.h
>>> index 8e5bd9902bed..79511e6abfca 100644
>>> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>> @@ -165,9 +165,9 @@ extern void 
>>> hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct 
>>> *mm, pmd_t *pmdp);
>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>                          unsigned long addr, pmd_t *pmdp);
>>> -extern int hash__has_transparent_hugepage(void);
>>>   #endif
>>> +extern int hash__has_transparent_hugepage(void);
>>>   #endif /* !__ASSEMBLER__ */
>>>   #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/ 
>>> powerpc/include/asm/book3s/64/hash-64k.h
>>> index 7deb3a66890b..a4a44a112ff9 100644
>>> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>> @@ -278,9 +278,9 @@ extern void 
>>> hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct 
>>> *mm, pmd_t *pmdp);
>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>                          unsigned long addr, pmd_t *pmdp);
>>> -extern int hash__has_transparent_hugepage(void);
>>
>> Without some of these helpers in place, I assume actually using PMD leafs
>> without THP would require some more work. (which is not the goal of 
>> this series,
>> just asking).
> 
> Yes, you're right.
> 
>> I do wonder whether the architecture should instead simply say "not 
>> supported"
>> if !CONFIG_TRANSPARENT_HUGEPAGE?
>>
>> That should still enable your series: using mTHP without PMD support.
> 
> Yes, it would. However, I think this introduces an inconsistency.

powerpc has two types of MMU (HASH and RADIX) with different page 
layout. MMU type is selected at boottime based on the capabilities of 
the CPU. For transparent page you have:

static inline int has_transparent_hugepage(void)
{
	if (radix_enabled())
		return radix__has_transparent_hugepage();
	return hash__has_transparent_hugepage();
}

> 
> In in its current form, arch_has_pmd_leaves() should always report a 
> hardware
> capability. This is true even for the default case where
> arch_has_pmd_leaves() defaults to
> IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) in the assumption that
> archs supporting PMD-sized pages by default will have this config
> enabled.
> 
> Your suggestion will change this and for some archs
> arch_has_pmd_leaves() may have different behavior depending on the user
> configuration. Additionally, I intended to decouple the base API
> implementation from THP.
> 
> If you feel strongly about this I can implement your suggestion, but I'd
> still vote for keeping the API about consistently reporting the hardware
> capability. Even if the only user is THP code today, new use cases can
> be added incrementally.
> 
>>
>> [...]
>>
>>> -static inline int radix__has_transparent_hugepage(void)
>>> +static inline int radix__has_transparent_pud_hugepage(void)
>>>   {
>>> -    /* For radix 2M at PMD level means thp */
>>> -    if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>>> +    /* For radix 1G at PUD level means pud hugepage support */
>>> +    if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
>>>           return 1;
>>>       return 0;
>>>   }
>>> +#endif
>>> -static inline int radix__has_transparent_pud_hugepage(void)
>>> +static inline int radix__has_transparent_hugepage(void)
>>>   {
>>> -    /* For radix 1G at PUD level means pud hugepage support */
>>> -    if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
>>> +    /* For radix 2M at PMD level means thp */
>>> +    if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>>>           return 1;
>>>       return 0;
>>>   }
>>
>> You are swapping both implementations, which might create some 
>> unnecessary churn
>> I think.
> 
> I suspect this was done by git diff as I just moved the functions, but
> I'll take a better look.
> 



