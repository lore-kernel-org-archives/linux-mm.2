Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F20106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1776B00BB; Thu, 12 Mar 2026 17:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9682E6B00BE; Thu, 12 Mar 2026 17:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A7E6B00C0; Thu, 12 Mar 2026 17:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7404A6B00BB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:19:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A71BB955C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:19:49 +0000 (UTC)
X-FDA: 84538678098.03.6A79BF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 81A884000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:19:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oAmgV2ar;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773350387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJW95MAAwk02Yo5Bqs/qbwpbpbptX/VVoXNWJEuoRrQ=;
	b=IMrTmx1dTyJNHbJ2VcIQVEkLyhvGWKEK6zPVXm5Oy2X3uHxGkVWvw9AvrvcA57YV3K81r9
	BWgL6TYaon8tS86l8sRCCChvrwBhwihL6/pDXlDZ/a8GPpcXPEJhxxs24MDAlDKzWH2V4Q
	S+T0Ro1a+wl4+m0bopSW1NXF1BAxBxE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oAmgV2ar;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773350387; a=rsa-sha256;
	cv=none;
	b=aty9ZMxHJDYDPdCjgtzcUIiLIxsVPRyKHhW4CzYgow9MpHBlbbls3l8oLBDaUh/6tKokBH
	HfOVNaRyvSHpD2f0xNtuvKcFwiS64JULOwq9D72eEpKsmJJ97rm12Pw8wrenh0v8OkYqyJ
	xw/OMdYzqqTTtdMgcOWLahZAvpscCos=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8CA860142;
	Thu, 12 Mar 2026 21:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE64C4CEF7;
	Thu, 12 Mar 2026 21:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773350386;
	bh=b/n1AB5/3Poo0rQsSnXTnJrEIrDJtXE5V+mRQh+spI4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oAmgV2arw8JwtUgPzmUkQXEI7qwOzfCbG1n6XzBr808nXkT+OTjcRoZGUbQVs225r
	 9oL/+sG4BcrmV3hycYoRG47G00JbqB8hTMHM0ptNJU7mjsuefL4tvMRzuId6W14LfC
	 IhC3XdsJFW4ICAXdSYDHW57MGspUq0ZIKv9UDCO2lWLUNOBuhtz5raqUE/EXj07yKw
	 lSTutMzLLYbUh0c0Tgi5w3ADbIccOK0ATm2IM7ZQRhFJKmmxtB8JJh2aueu/1QEbET
	 doHY7gQJmOOlG2DNwXemCr96moZ7CqMMX0kfhuAXOVJR/pnLfkaz6t22RHEZ5xmisP
	 wmCkSME14rwIQ==
Message-ID: <ef97dc96-2525-4694-aaea-34ef67a05caa@kernel.org>
Date: Thu, 12 Mar 2026 22:19:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 11/13] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032631.234234-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226032631.234234-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81A884000F
X-Stat-Signature: 4ubcbtwgo8e5p7q881ekkka4yi9cao3n
X-Rspam-User: 
X-HE-Tag: 1773350387-905631
X-HE-Meta: U2FsdGVkX1/zqxg0Fp3k2DFcpClSEo3qWlzq7uxh/7GqY2PuUH7tGkaPGA1GNeO5AKj+y2/9JkbyrBiYd338uQ8gmEn38C5y15TvoEO0WgfbsWSAoSl7TWdYpuI3q3XjY+r+QNvCtWRlKU/+lxxTAPTPiM+wcAj1OOt+b9gBV/8giGPf6pmtcRtFVvV7euebREglSfQ0xfqm/7c4Gq6gCTHuC3+MK1k5PC78/XQIvNnWKhJFP3ruPUgW40LPcl1F8yIoPLFyiwe3izA2cGMAjX/sgUed3gzbeVe+y7T2ObIFeefD7nxqTJfO/GocMf+eW+Lb8C+zk55xz1FoQ4HEAtdYXWOCCYAWLlm8llzQz/G2bzEO4d2gXCaPDMwyHGOkbVL35Ermx0Ss47cfYBuiMzVOFBPfaxMX34y+oqqAzc2WObLnWmYwp6/g/37dynOkyRKNKaQN50W7Ub3JU4EcuPsWKfYwJxoN+s59kET/vo3wtQ3H7Ul555fHNEL4eoy6+GQkvCIJJwVbFG3KJY2qKjPhfstedCUbTMokBHmcPK036dhFuxRXja3YsHMBn92NSyAYTQ/nNtEME7BeIfPrjjNTNvKcYjne2CNuTcOQHDkpM61b3V+r+kU2WFOBGH42V66Fraw8pZTji37VCDQ8QV1wO0yo4rKdHMQAlp5LHq64Q2FWNQZ906d7CayBGLcwZCcmPgkGdNIbHiw99wWmr43Wl19qN9BkRHV1dAhmfbtJFJW+WkTINTV1qoIr1NBP1MWloP++ueG7Z+j5z+HOtZBtEbvcRg1FNa5KcUCOu4tahcpf/GbL1rcxoP4fUrt2nSgPbweA9PAqyTLVq7zpsn4vAgDeBfRXktu+hnY//hgbnl5XYtHZQz5M6dpLcg6PVnSGm+ijG8nOqAdiufcSIYanSnBKCIsx/iLKwXgt/6j5Q8NBjJB7uPUGecdHFoSW005Rivl77cwSgDdGP2d
 ruJcqxUo
 WtF/T5pqTKGjO3rAes2LUYN9Kg5HOI5B+ve7y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 04:26, Nico Pache wrote:
> There are cases where, if an attempted collapse fails, all subsequent
> orders are guaranteed to also fail. Avoid these collapse attempts by
> bailing out early.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1c3711ed4513..388d3f2537e2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1492,9 +1492,42 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>  			ret = collapse_huge_page(mm, collapse_address, referenced,
>  						 unmapped, cc, mmap_locked,
>  						 order);
> -			if (ret == SCAN_SUCCEED) {
> +
> +			switch (ret) {
> +			/* Cases were we continue to next collapse candidate */
> +			case SCAN_SUCCEED:
>  				collapsed += nr_pte_entries;
> +				fallthrough;
> +			case SCAN_PTE_MAPPED_HUGEPAGE:
>  				continue;
> +			/* Cases were lower orders might still succeed */
> +			case SCAN_LACK_REFERENCED_PAGE:
> +			case SCAN_EXCEED_NONE_PTE:
> +			case SCAN_EXCEED_SWAP_PTE:
> +			case SCAN_EXCEED_SHARED_PTE:
> +			case SCAN_PAGE_LOCK:
> +			case SCAN_PAGE_COUNT:
> +			case SCAN_PAGE_LRU:
> +			case SCAN_PAGE_NULL:
> +			case SCAN_DEL_PAGE_LRU:
> +			case SCAN_PTE_NON_PRESENT:
> +			case SCAN_PTE_UFFD_WP:
> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
> +				goto next_order;
> +			/* Cases were no further collapse is possible */
> +			case SCAN_CGROUP_CHARGE_FAIL:
> +			case SCAN_COPY_MC:
> +			case SCAN_ADDRESS_RANGE:
> +			case SCAN_NO_PTE_TABLE:
> +			case SCAN_ANY_PROCESS:
> +			case SCAN_VMA_NULL:
> +			case SCAN_VMA_CHECK:
> +			case SCAN_SCAN_ABORT:
> +			case SCAN_PAGE_ANON:
> +			case SCAN_PMD_MAPPED:
> +			case SCAN_FAIL:
> +			default:
> +				return collapsed;
>  			}
>  		}
>  

LGTM, but I do wonder, given that you have the "default" case, why spell
out the ones that fall into the "default" category? I'd strip those

/* For all other cases no futher collapse is possible */
default:
	return collapsed;


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

