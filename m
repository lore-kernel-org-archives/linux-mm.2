Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38BAC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 12:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA3C6B0095; Wed, 19 Aug 2026 08:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B0C6B0098; Wed, 19 Aug 2026 08:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B12B6B009B; Wed, 19 Aug 2026 08:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D21C6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:34:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E61D514054B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:34:07 +0000 (UTC)
X-FDA: 85117961334.03.4EF6DD3
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf03.hostedemail.com (Postfix) with ESMTP id B02A22000F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:34:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A46HJ2pj;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787142846;
	b=fPc1siY21IViUWy0z8cIvSXao0KKxXgOl0xr4WKUDgDL7qdZhqkiCE/MqvBUI+o1o4KXkA
	/wfpak5py3zhz+RMpMb8/Nv0dI9RUILMvD9bCzGX7VlgjBjIVVZ02hU3e7dH6eaePbM0pz
	amL0raIsGbKX7hueEB25P+HNSJyWYTE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A46HJ2pj;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787142846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BZYK8AHt9k4bE0RHXY1aSuWkhvRVrO3B5R/AbwY+lM=;
	b=8EPwUstl3WPbHc2F6LMiH4UJyDZdNUX6PoZBKbq59obR47Nscn+ZeUlaOv/UNW00P2YEcX
	vPJe/cXVF3EGyKtE+5ywEwSVK/0zeySvDIdHF2pLhTT1PqWQ7PY382S2N4f/OJh7QVSiWs
	gwbCz5CMhhgOvsLIhBBTHj9EvyneJQ4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1Mi6ywisfNPGRA43uZhTcAwin6zOWap1I65ss7T8AI0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787142844; v=1; x=1787747644;
 b=A46HJ2pj64npg82sCkXrs/oN3zXYhC0M8eZXuqJqnXnkua3btMTRXvoK+O/KkPdhjy/nEvkZ
 W7tFAKC5abb1tF3MRbJLIJu4/JApnnarxo9EOKr0M5vOFDTnjehkhX3ubZbYaqDTAh/5Fb/tsRq
 Nf/xS5sVMofmGtE+Ky637kpo=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:a428)
	by smtp.migadu.com with ESMTPS id 8e3edf76e993b089;
	Wed, 19 Aug 2026 12:34:04 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <fbbb6dab-71c2-4f8b-b7f0-6c7f73ddaddb@linux.dev>
Date: Wed, 19 Aug 2026 13:33:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/12] mm: add PMD swap entry detection support
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-3-usama.arif@linux.dev>
 <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org> <aoSmlTH8e26xAYLp@gremlin>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aoSmlTH8e26xAYLp@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B02A22000F
X-Rspam-User: 
X-Stat-Signature: 7m8nahm1nmyurgmn1w4xudeyu5dg91hu
X-Rspamd-Server: rspam06
X-HE-Tag: 1787142845-835740
X-HE-Meta: U2FsdGVkX1/CHyHgffIN89pC12zwqrPVTlwQQM8gdre61K+nIXjnnMOedsf1pWCOtlLJBBNBALymesUhvtEwwC+pIdmambpDhPQIRmHXGW/jeDw7vDM6K4yRBVCb35EFwVvCfSWrtU7xpF563k3ZzhF/Q0MO+1TVW84cDr6m8xMMBb7HvWBJSFCj4pDRKuJNwsQTvPLP9PFl4J0PIJg0hTT1g8WhftwPvphR9L/nAfc/P9gkRfnwPtrtH5U4V4qN8AXP5StDSzuSlMYXGUA1VtvXQ9XahKoOZv6OVeLV6i8qaD7hyYZM49SzKQOksphs/3cCWWcpRWakHgzqvitmNSRCvEeU8Q20rGQRTVdign2BhQldPMhZrOpPNiqO7xiXbwRmdiktPOWaGIMMF4uH5oEfIrmkgKtC/rVgTbwEygY6VKh+Rwzuh0ZvESuOI8RuW6zZiiKdXS9ahH6N6f/ZL90KYPUCOhl+KIO307ha6JzjK2A9G2uVY/+lFb6MKk4U/nQx224a2gOtgc/Kkb7L1X0ioxA8vAffRq/gFQ++E35GL71phoAMwSaeLzfYlPU3y3esxewDvYTZc7myvzoGRQZgFXWZa/yZgCdTIoaccue3LiArZqhx+qeHJzKzwsFCbf7cE7P1PyrWMzfgo94kscpBBjmVOGM1ZEA7ePiuR6848uWysA+aDxGjEdajZfwPj+NUr5dd0qlpKXfhYFbNYDkrpbpuZc+mIy8ZluHYnEynpRNRt97jhfUJC+Ngz2pcO6G7/GADuL490DcJt4e2zU+YOc8Lj+QyS3EvgBi9vdPMFsus9oeeHqENMeEmTj1kEFbNSdzFS7/SQO5RDi/g28WIjwc2Mr5C0emGLo1fw6Hj/NckSNcVal9+kpD0Ye6iEZykzR4oo0O7HWTT1kB1g3VXpeUlXjzmpWTZQ+RcdDaB4vXFacqajvg1/v04pEKgnI9OrdlN5KTMGkuVrZj
 pyRHuNp0
 QYpKVYLU8YqFTKkhL2PfGdv3G6Yogr+0blAB5LWjoEz7UvssPauYj0Fz6syEukXrMeyKZsfb/B63I5i+rE2wh+PWW0DVwMIIsCtwjdbk3O8Ubj4/b8vexGDuOz+HIFd7+nTW67tZKmQIxppGCfaK0XLm9lrNPaZ2J2LtLxNTlgWjleusAiYbgcoeRegypnUazxk/0R2iIjArb513LC0/taYPQ2QjGjGGfgjX1Sim5o0Edh32FZyZqymlO2wpH3uX4nKlMLbr3yCagrRXnaRFldWt1HUBhRxsS4kHwiXQuNxbE5SLLGrGlNQuO8WLdmhBm8zjfPsZwq06heqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/08/2026 19:42, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 18, 2026 at 04:40:25PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/18/26 15:09, Usama Arif wrote:
>>> Currently when a PMD-mapped THP is swapped out, the PMD is always
>>> split into HPAGE_PMD_NR PTE-level swap entries. To preserve huge
>>> page information across swap cycles, later patches will install a
>>> single PMD-level swap entry instead. Add the infrastructure to detect
>>> those entries.
>>>
>>> Teach the softleaf layer to recognise PMD swap entries:
>>> pmd_is_swap_entry() detects them and softleaf_is_valid_pmd_entry()
>>> accepts them as a valid non-present type. Because swap entries do not
>>> encode a PFN, make pmd_softleaf_to_folio() warn and return NULL for them
>>> instead of passing the swap offset to softleaf_to_folio(). Clear the
>>> exclusive overlay bit in softleaf_from_pmd() before decoding, matching
>>> how soft_dirty and uffd bits are already stripped.
>>>
>>> Add pmd_swp_mkexclusive(), pmd_swp_exclusive(), and
>>> pmd_swp_clear_exclusive() helpers to each architecture that supports
>>> PMD softleaf entries (x86, arm64, s390, riscv, loongarch, powerpc),
>>> mirroring the existing PTE swap exclusive helpers in each arch's
>>> pgtable.h.
>>
>> Ah, for migration entries we still use a dedicated migratetype. I actually have
>> on my todo list to move to PTE bits as well.
> 
> We do seem to have rather hacked in PMD level stuff across the board
> previously :)
> 
>>
>> (likely the _swp_ part should then be renamed to indicate that this is for
>> softdirty entries, not just swap entries)
> 
> You mean softleaf?
> 

Yes, I read that as softleaf as well.>>
>>> Provide generic no-op PMD swap exclusive fallbacks for
>>> architectures without PMD softleaf support, matching the generic PMD
>>> swap soft-dirty fallbacks.
>>
>> No softleaf implies to migration and no swap, so this would work.
>>
>> You should extend mm/debug_vm_pgtable.c in a separate commit to test what
>> pte_swap_exclusive_tests() tests for PMDs.
> 
> BTW one thing I should maybe mention here is that I never quite _finished_
> the softleaf thing, so there's some awkward overlap between swap stuff and
> softleaf stuff (swap entries _are_ softleaf entries, just a specific kind).
> 
> Infinite TODO list etc. (maybe this is a hint/nudge to somebody else to do
> it ;)
> 

I kind of tried to tackle some this along the way, with the prep series in
[1]

[1] https://lore.kernel.org/all/20260706114320.1643046-1-usama.arif@linux.dev/#t


>>
>>>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  arch/arm64/include/asm/pgtable.h             |  6 +++++
>>>  arch/loongarch/include/asm/pgtable.h         | 19 ++++++++++++++
>>>  arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++
>>>  arch/riscv/include/asm/pgtable.h             | 15 +++++++++++
>>>  arch/s390/include/asm/pgtable.h              | 17 +++++++++++++
>>>  arch/x86/include/asm/pgtable.h               | 17 +++++++++++++
>>
>> I'm sorry for asking you to compete with Kiryll's series by creating one patch
>> for each architecture that directly jumps at arch maintainers :)
>>
>> [...]
>>
>>>  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
>>>  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
>>>  {
>>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>>> index 7c13c58a5e218..4a6c52974b305 100644
>>> --- a/include/linux/leafops.h
>>> +++ b/include/linux/leafops.h
>>> @@ -102,6 +102,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
>>>  		pmd = pmd_swp_clear_soft_dirty(pmd);
>>>  	if (pmd_swp_uffd(pmd))
>>>  		pmd = pmd_swp_clear_uffd(pmd);
>>> +	if (pmd_swp_exclusive(pmd))
>>> +		pmd = pmd_swp_clear_exclusive(pmd);
>>
>> Can't we just unconditionally clear these flags?
>>
>> pmd = pmd_swp_clear_uffd(pmd);
>> pmd = pmd_swp_clear_exclusive(pmd);
>>
>> Avoids these rather unnecessary conditionals unless I am missing something.
>>
>>
>>>  	arch_entry = __pmd_to_swp_entry(pmd);
>>>
>>>  	/* Temporary until swp_entry_t eliminated. */
>>> @@ -634,18 +636,30 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
>>>   */
>>>  static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
>>>  {
>>> -	/* Only device private, migration entries valid for PMD. */
>>> +	/* Device private, migration, and swap entries valid for PMD. */
>>
>> Can we just drop that comment? I mean, it's as clear as it gets in the code
>> immediately below :)
>>
>>>  	return softleaf_is_device_private(entry) ||
>>> -		softleaf_is_migration(entry);
>>> +		softleaf_is_migration(entry) ||
>>> +		softleaf_is_swap(entry);
>>> +}
>>> +
>>
>> --
>> Cheers,
>>
>> David
> 
> --
> Cheers, Lorenzo


