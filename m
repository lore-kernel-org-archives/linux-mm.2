Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 969F4C5321C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F33A6B00E9; Mon, 27 Jul 2026 09:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C576B00EB; Mon, 27 Jul 2026 09:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D6D6B00EC; Mon, 27 Jul 2026 09:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBED76B00E9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:44:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBCC980723
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:44:39 +0000 (UTC)
X-FDA: 85034676678.04.B0DD098
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C9D9740007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:44:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f2z7b51q;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785159877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HBSjs0YXmx8rxbE5f0/XZpbxIe03X0ZCU3v967/exQ=;
	b=rlndq3nsqPGrDoUT0u3sz786f409jSU7nMgVulRZ96HT8p4Q/vROHGXSPM2npUx41dN6Su
	sRwmuwhvcqMFKa9VVuwq5ewoOtsHPTZCf768NcKl39IZifYt/0f+wRq7yx1Qzdnz4LeEe/
	v63JnVtAjA02+JWCVTepSvDeljaxkcM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f2z7b51q;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785159877;
	b=hzPHO1y4vzLYUreYqIzWTnFBpi1efMMo7pSJ+959aiOSsZ1cOY13XWuob+Oj2r7TfUPLLY
	HD9W9w0fW2aWcfsDTYFbV+hUubgD4ggTk6GnPBbovSsmUnK7aovpKa39SmucCGvSj4XTOf
	a+oG0js50nlurggaiLvFVv33nVRVEIo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEAE142A4A;
	Mon, 27 Jul 2026 13:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FB11F000E9;
	Mon, 27 Jul 2026 13:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785159876;
	bh=5HBSjs0YXmx8rxbE5f0/XZpbxIe03X0ZCU3v967/exQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f2z7b51qoUf6Sutj4dP/UQlgqzQVH/sIoduN90fsornu7wBavjeVzTibtWRxCn4rh
	 af1p74G9L+W0ulIOv/E0zlviPmRGlrTCpAeBe6UOziqgNaO8mLutQyd2Rt9bXOavbP
	 oxuEUCa930MO+rNmegPrETeDvk6+4qw+l7dF/K4dVeZaesqkECQ+rjiWPLI9947/nS
	 6EgoWWmXHu+CiPztjXHtWmQasSMcMjjtDAhFB8AzK2J3qIXNAGrNm2xMBXCBIfcKKP
	 pLmlnIiOtm1gHo56xq5M2Su4ZHAX9fPZP66WIxr77+wQ5XvR2KOVaLgM6gp5DcYv+w
	 DI8hFDl/qc7uQ==
Message-ID: <ac1e42b2-eee5-42cc-bf1e-dfdc5225adeb@kernel.org>
Date: Mon, 27 Jul 2026 15:44:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: constify generic pte_get*()
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-2-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260724102017.141532-2-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C9D9740007
X-Rspamd-Server: rspam01
X-Stat-Signature: yzhe9iy91xps4ip1s4qbic8ysg6c1657
X-HE-Tag: 1785159877-360508
X-HE-Meta: U2FsdGVkX18NBdOC7pI01XdFSI/EBGeb7fTw8Ck0EXzA5ASu6l00D21T9EzsD/pPTJRLReLN6VrYFYraO4CbF4kRI3tqZRTWuGCQ0PCIKpc2VZ+xydv7a1hj4ZltVvSCLAYBm4LDLI2HQLYLZH1j9fZXZk+oGn116l+bShUIHnIRKpNVTcc8Pe83ULhcZkRulwFqTBpb69sEnkNCgu5ZOGxcPACQV4EAhvJ1DsRUCtqAFerCYj6b9SAhvNmJ4PfsJYyWE0lODTO3jCAqWHnAOIrWp35t7wkzDqH4puxqtj7vW63aM2WDd9TkPhjl8VWAOwSdsAFJ+ZQO6n8SrUYinEWTJu9qjDNKMmGuvlu+t1LVHw96yuXtvzW5711hXBQgqu10rrQJNe/CDA4GmS9YdOBb/vzVc1T/Dn3huhi4YB3WpkZtR/Qqn1Y8ZQ3mfERtIqIWHdnR/s9xJ6G3ZwDoK70nXuWPvBtWbJO7IVLvjboj8eiLE+rtTo6C8goYQvyzVuude6DcznqB6frcGdJ5MhxQpu9eD72Kc2APD3WJ4OKRyHdvyBCO+lklIrdYDuGNa5XyeRS3uKuZKBUBSys95vzTJlG35ANf4HlkCXTcyt/0PTP0HJpJ0eT6zuTzk0n4Zh1fpPdt8FasJdLbcxMuoxl5IZjYZWjYl+XsCpSONXcdOL+ww0RYONjt+pnIdU/HVggvvd+f+DkG588tko99XkImfhkopsuqVQXX1yvi3tUS/8ABq+au5rWjKCpceacHoR3Dsz7NoFV0AwBo3NSYTmg9McYAhJ75eFtOlVoLLFvApUlXAbfAEa/xiybsHjdoRhzw7hKFyR3NVe5SyIIdV/Gvuuetydep0c8csSF0DsNSRPuxyN5GQ376mSawjnKoqROL28mO/klLHO2VDcEVK9MQ3VOYh7uiAYPGloMyUo8ODftzBzs8fpn6PclsJO7ki28Qv0r1TOLPnghqtuD
 uRZKebOx
 iNaSw2TfQ1P9osslZjaLPmeuOUQoX3LWQpEU5nBDYXIxrS7FnGHPqCiUwbIPibFglsrlMrj0zupXHWejU0oOfKd1lMtUzkWitZlCBnZjUwj4NMFCqKMtG1QPjfuy1rVPTHAfODn8w6b2Gbz+AFTXqGH4Y4/s9rZXJV2hvNV6uRJK8QP3J19dbAy3NZKV9zsC6WQ8MDG17iw1xg7zdxma1kkBruAB5Mi4xNt+WpRuprHtqkqaz0Ex67S7rwaj6DwQ5SO2HS4GKtTSAhV58nTkC0wiFHM2H/r+4+qqAX1kBYLoGpVFmJc6eAqgL3qJJLkSvwBNYJ7RugrxPb390XhK/5/9PPdzEtLCgLVIVI+jPBol8w229JFCbY/TbP8IGwExpds5l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 12:20, Pedro Falcato wrote:
> None of the helpers need write access to the PTE. Constifying the param
> allows for const typesafety.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  include/linux/pgtable.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8c093c119e5a..dc418553e57a 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -490,7 +490,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>  #endif
>  
>  #ifndef ptep_get
> -static inline pte_t ptep_get(pte_t *ptep)
> +static inline pte_t ptep_get(const pte_t *ptep)
>  {
>  	return READ_ONCE(*ptep);
>  }
> @@ -739,7 +739,7 @@ static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
>   * present bit set *unless* it is 'l'. Because get_user_pages_fast() only
>   * operates on present ptes we're safe.
>   */
> -static inline pte_t ptep_get_lockless(pte_t *ptep)
> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>  {
>  	pte_t pte;
>  
> @@ -777,7 +777,7 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>   * We require that the PTE can be read atomically.
>   */
>  #ifndef ptep_get_lockless
> -static inline pte_t ptep_get_lockless(pte_t *ptep)
> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>  {
>  	return ptep_get(ptep);
>  }

Yes, that's a step into the right direction.

-- 
Cheers,

David

