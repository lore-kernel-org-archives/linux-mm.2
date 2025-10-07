Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 571C3CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 06:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6372B8E000D; Tue,  7 Oct 2025 02:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F178E0005; Tue,  7 Oct 2025 02:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BE28E000D; Tue,  7 Oct 2025 02:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 456998E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:30:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C348911AE1D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:30:15 +0000 (UTC)
X-FDA: 83970343590.22.027CAE1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id A1813C0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:30:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759818614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wKEKLu6qKjlXFufVkEg4BHL77pf3ufxBAYwH1SBcogw=;
	b=CYlbJdc7mrWHlUC4n/DtM3lgj53SRzzZnyyEJ7xrN5LNUlHx4yRbBGhxjK3JJuAxLeWMrZ
	Z/xTpFMX4rDvN/cSBLmEpM/tl/F0JnhR5JhzckwOAAX5EJ8nssXFIElDn+92gU81N/gobb
	tbeMJoWuK7VBSiFV4Q7yAO53omlTDiw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759818614; a=rsa-sha256;
	cv=none;
	b=TxZmDQFHeWfe+1g5A3OfvMgBHANpd9nUNAScTVNdEtrx8PY7aKeBxgUDlh8Ld2JQYYd5Ct
	TvykO49ee/oHFNXkGW0ABDuAZm5f8AqOj1oPZ4CzWrMtWs2pic0nwIU9QM7WPoGT4YCBX9
	1UlK+WKlKXKdK3PUXGxDpiM9KuuPBsI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6060A14BF;
	Mon,  6 Oct 2025 23:30:04 -0700 (PDT)
Received: from [10.163.65.24] (unknown [10.163.65.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 655C73F59E;
	Mon,  6 Oct 2025 23:30:07 -0700 (PDT)
Message-ID: <586f6282-ac7e-42d2-b132-0ba067623ddc@arm.com>
Date: Tue, 7 Oct 2025 11:58:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251006144338.96519-1-lance.yang@linux.dev>
 <20251006144338.96519-4-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251006144338.96519-4-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: or5hu9ac7ebam5e8prn8q4xutt5kscgt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A1813C0002
X-HE-Tag: 1759818613-899484
X-HE-Meta: U2FsdGVkX1/UjbgtOQ1MaPFrOyyEhl3tK3b2SlFJ1l+HjVfs7Kbxc8+WH9u93Nfm/67sKm3b50JaYAPV0TIKuEDd5ViM54jJtT2acxtgBedUvlTZ2+OWY9LW10dzGOFEcV65z3fgItB2Uot8KGr1O31+PIJiUsSPKqibjnsLn19NKXnpCJO3LfVPr+q8IY9KbICrZ3a/oCDMuDhjZpj25vn4+j4wJXWKSQ0+PZHLCDurmVSktK+Or+KyCbwUIlnftV1J5bMiVBLUd0pW9cOuZ6FZ9KEakBZHJVMKJ6PirfEO902RcbIg9dJwEVjrrbYH3RgqBWsIRGBHIVqJwSUEcEkBKEf2F8Ho7w/1Dr+DBjxqwDVDq608p9r3NGav46OwQsFqMVzzDo8LMEaXHHIkEKOdXwGI6RtUlD6pK01EfFinTxanUwYURcIgLw+g5NU8hzeF9fjSJHZDBw9mgcEaF34lLGi23oGRFaO+MENbzJtQ0cAcjZXrzKcK8k8Bzv4jb8XdOdsusiOhDSqtg8k5xiNgKtRjtST9NhANporaiYGHcjYFDjVJgi1MkcG5cQ/FLznaSTH87VdAniWxdexkxSpzONr6uEo0o2K+IfXu38wZevTr5FrEk5ssv7PnHg9natrrCQz43pODgGFwPGwj6PXfZFeBPlIfV+LCyo6UrdJCOYJE7sNJ975bC3Zsv9kDKBfIgFKJs7nDCdc0HDOpzS3yFzzogeQQmBVIrxSqmsZYpLuEL3GyVRhyibDDT4CeglBYIlv3WpXrcNSTPaPuPMIwrem0dz4UACeHj58NS8+mdyB5xFtpT++y1FoiTcrAMjEfG1gdKiSY79Yth50Rt4CXnd4NV4Sx6KmibVNcnITXAxVhPkej26BG22oXJkSD1qHOssVpX5o2pL6sA63nTmhVQDkH+WGpCFkNYMgVvVcGx/FSWIlBp6mAqbRAe7wpfn0lJyZRw2gE1lDuKqk
 iNz8nz6y
 9tH8sk8QyNmgp5kclcPUabWmJPBWUO43yZmuJMFwuVOu2WRfHVYusrjEEQK+ffpNSDXg5Fo2CaWCd8cPaIE5v0Vfb6qvyEctsjd/0yYP+7fXVuK339S5xZ939Jcgb00Knk0zChWfVg99cyq2qw6V6UaGoiUp57OuB5daxgABQa5N8uj3FiB2lOpq05J3MhO7i5KxFzVaOzsm+Z18tGbOBMWFFSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/10/25 8:13 pm, Lance Yang wrote:
> +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
> +		unsigned long addr, struct collapse_control *cc,
> +		struct folio **foliop, int *none_or_zero, int *unmapped,
> +		int *shared, int *scan_result)

Nit: Will prefer the cc parameter to go at the last.

> +{
> +	struct folio *folio = NULL;
> +	struct page *page = NULL;
> +
> +	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
> +		(*none_or_zero)++;
> +		if (!userfaultfd_armed(vma) &&
> +		    (!cc->is_khugepaged ||
> +		     *none_or_zero <= khugepaged_max_ptes_none)) {
> +			return PTE_CHECK_CONTINUE;
> +		} else {
> +			*scan_result = SCAN_EXCEED_NONE_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +			return PTE_CHECK_FAIL;
> +		}
> +	} else if (!pte_present(pte)) {
> +		if (!unmapped) {
> +			*scan_result = SCAN_PTE_NON_PRESENT;
> +			return PTE_CHECK_FAIL;
> +		}
> +
> +		if (non_swap_entry(pte_to_swp_entry(pte))) {
> +			*scan_result = SCAN_PTE_NON_PRESENT;
> +			return PTE_CHECK_FAIL;
> +		}
> +
> +		(*unmapped)++;
> +		if (!cc->is_khugepaged ||
> +		    *unmapped <= khugepaged_max_ptes_swap) {
> +			/*
> +			 * Always be strict with uffd-wp enabled swap
> +			 * entries. Please see comment below for
> +			 * pte_uffd_wp().
> +			 */
> +			if (pte_swp_uffd_wp(pte)) {
> +				*scan_result = SCAN_PTE_UFFD_WP;
> +				return PTE_CHECK_FAIL;
> +			}
> +			return PTE_CHECK_CONTINUE;
> +		} else {
> +			*scan_result = SCAN_EXCEED_SWAP_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> +			return PTE_CHECK_FAIL;
> +		}
> +	} else if (pte_uffd_wp(pte)) {
> +		/*
> +		 * Don't collapse the page if any of the small PTEs are
> +		 * armed with uffd write protection. Here we can also mark
> +		 * the new huge pmd as write protected if any of the small
> +		 * ones is marked but that could bring unknown userfault
> +		 * messages that falls outside of the registered range.
> +		 * So, just be simple.
> +		 */
> +		*scan_result = SCAN_PTE_UFFD_WP;
> +		return PTE_CHECK_FAIL;
> +	}
> +
> +	page = vm_normal_page(vma, addr, pte);

You should use vm_normal_folio here and drop struct page altogether - this was also
noted during the review of the mTHP collapse patchset.


