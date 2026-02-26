Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E92FFD8FCF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3063F6B0159; Thu, 26 Feb 2026 11:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3066B015A; Thu, 26 Feb 2026 11:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B466B015B; Thu, 26 Feb 2026 11:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02F156B0159
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:27:07 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AB348AAB7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:27:07 +0000 (UTC)
X-FDA: 84487137294.19.82E811C
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id B45B1C0018
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:27:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oYncBP7R;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772123226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhpPpUmawavr8/7XO4FkbjGyfWyIYMOEPuIKrXPIOZ8=;
	b=HpNXfdVgWmmFUi1M+atI5ZKDetbTjsyfIhvOWcDEOxQxIPezKDcElPZ1R0miQ4x5YUhxci
	EJQFAsJ/UyX31L1rs1lZsJsbNkyqxKgCuNJ0I/zwjZq56gT4HTVIcq7KABF16ROS3f0snl
	3VSdyC+rVAzrHBNSYoYfexRiHPHX0PI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oYncBP7R;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772123226; a=rsa-sha256;
	cv=none;
	b=tJDPAMbkigkmBHoHdy9tw2LkD18opZh54dXVbeIRnEPGnVndwLYOvQgCp1w5Zj8qyqpANa
	+E2c857bNtRnmpuB1PUbop7LVDonTIaJBfVM/W5WooCzbAZM1g9b3WgjsDJS0B0A+a3r12
	7q0Q+5UEcGqnB9f3y4tf71KYUSuYju4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772123222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhpPpUmawavr8/7XO4FkbjGyfWyIYMOEPuIKrXPIOZ8=;
	b=oYncBP7RaHS8J3MMylYArslXoH71eizg7mSGfgLGYgnJQMZRPlGt3Og7eMjJ3PDXcu0Cjf
	Iiuihwux6vl14q6/NYTTenfiDG7eC8xz67swamRfYHsVdoFeTWT3Bp41LT1gfO69H4ips3
	QprD6BI2Yb6LF4d3T1CZMn9JbixT3Hc=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 11/13] mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Thu, 26 Feb 2026 08:26:52 -0800
Message-ID: <20260226162653.3802758-1-usama.arif@linux.dev>
In-Reply-To: <20260226032631.234234-1-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rcttq3ybtcko7mewh5gocytufydmmiox
X-Rspam-User: 
X-Rspamd-Queue-Id: B45B1C0018
X-Rspamd-Server: rspam02
X-HE-Tag: 1772123225-608464
X-HE-Meta: U2FsdGVkX1/emI2K3hgPb4kMOu49Ee/9WNXIJqH4ADzCyWgZq8xp3FQZStR2HeowRoDWhwcSyKXm9OzWrBXDTGLp7CiAthCUcHgnetyLB0V9jfrJg12KUVeWFveMB7g8x/NwDnlj/txLo3oiYi5kRIkpMscOwGxAGDLzyRHkEyTW9dvTXC9RssmgMk2CUU5JtOYUCl+eBIBi6kpgPmVrX9NgrSuQEWZ1o+E/5glAvNH1M7p+NgGcACPPk6R8ib6v670JFSMQq8MFh/GNI2widrpH7NSlKPffVtfphDMlgU6hfmPeT8TCglYL6CR2FoLIzUG9NROVFz3cCXuvlBjW4by7pn17+BeAfpWI/QW9pCJRraVQk6SBTFthiyVpix+wMlje7g80grn1JAuTOOQ+0Auu0bovOF/pzOD+xjdwcq3dx0/IgeIWb7OQD4il4SEI1y+E82KjdWn/lFI7mgI45FgwOGArEajSG8GtLezEzuTkaTvC2UgtNI1hYPHb98xpvX/kiBEJUfSBgK7kVaJXAwkq2z6jp6R5PlgdRR7UGvNyMi24pzu1WmMZjUdLEwhDOahUYF1+TjUKxlLeajlZmKf1bNc2kzubprgQU7IK0CGwCw80o2G+19lnQyfweU5+z8+UNhA1BQ6kTcTygBSUStPXeOTHZ8DihHd/UDRfVvFg6I6GAE/mOSqoOmKRHQvhtxkG26M9YqPxxD+7pTi1DYl2yeMNT8FpmHvESUGjjnSkSSYf5oQmBNuLIp1G0Ts95rRA3rRmzbbT3Abx/GTOuZxSO2UrjDHH5bZ6MzrHtiBTfxxW4YY99ZeDD87aCgcriHlv57Qw87KCo0gPWa/2zyAzs6+dvq9WZgtNKR1mO/c64tZJbfLFBW/q7o+68VdiRczF5cjlfP8azVFeTAdYDMjv6cNV+rcLDljqn9qToWWRFlEfHGsJrT66o/zigPc61vWrqK+diL9/r4kKIDK
 IzptlGar
 8DOUbzkChHL1BCd/hqcl/7W/z1ybpqW4Hnu07kT+ku/yYxcoQLMaoAb4lTIlfKNPHeS8HaxWLKtP3qt2SaBWTLHa7D6av27cgJo1ZWe2ppWQrZR8yYyn3uXSrOjoEKf8ZDHCoUzwneDUezFCx0F2kP1CZJmcTPsQyKMVghEer5uIliWFjjfseb/AyFZ/kFv5WCXMmx6Icejkfx7CSFNol2YPMPjmb6R8cBGGOoDEjWrD561s9vmWqq5x8gK22wtPjiRXLLJJLDUdWbzudkhpVcoqgCCOX4d8XcCAF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 20:26:31 -0700 Nico Pache <npache@redhat.com> wrote:

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

The only one that stands out to me is SCAN_CGROUP_CHARGE_FAIL. memcg charging
of higher order folio might fail, but a lower order folio might pass?
That said, if the cgroup is that tight, continuing collapse work may not
be productive.

Acked-by: Usama Arif <usama.arif@linux.dev>

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
> -- 
> 2.53.0
> 
> 

