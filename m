Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE5BCF8859
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4B16B0031; Thu, 20 Nov 2025 08:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94B46B0032; Thu, 20 Nov 2025 08:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1C26B008A; Thu, 20 Nov 2025 08:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0B7F6B0031
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:35:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95ABC855FC
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:35:41 +0000 (UTC)
X-FDA: 84131082882.11.6134B21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C9477140014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:35:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knQ3E4Fj;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763645740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5btAk5N6dNvXNLzmFnp9b/KE4gsd8sDZpcNKThRPsAc=;
	b=ms9nrQILepbqd5NjOxaZQrrfHDhd2yNkLhYTM2ZkWVo4lFRy+tdIL6gQI64Yu1cXArLk7T
	gidA74RPeKIopuqNr1AlNENYX5Avt8D6yb7Q5n/BKujr3K54z0FbmZxMWVZB6XOvfXBuQI
	6qnZ19ER08z4m+Eag1UzaI5R3lwSFhY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763645740; a=rsa-sha256;
	cv=none;
	b=upPApukNV9DfYMpISgBZ8zbvsIrBuM3DmMaYLHOoIhzC0zbhdWVl5qnHXjwpFqbLQQThfo
	5/L+PrxZWE7oj10A2LgIJeiH1ZUFP7FDTSd3AaWHw4w0yP6UdA2rztd91MtlJV+ERGRdgP
	VAy2CLxeKD1+vYOxipBzNnFIwuMJMcE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knQ3E4Fj;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA3E843F98;
	Thu, 20 Nov 2025 13:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A494EC4CEF1;
	Thu, 20 Nov 2025 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763645738;
	bh=7fOQWOlDa/yWJfdxMP4b/quIC4jTVVkZpbyue8xkZUo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=knQ3E4FjFLvlIBk5Vj1nqlfGxz6LM/OkrjtqrPhjawaq7swVpXiOv9gqhzHsVnJtx
	 0r5rujNQ2NvwVHZtqa6cb6ArDqIpyu9xNFcTjiAMSz6JgiXjs8hCzI/NhtGgcgvey0
	 4Ge6vzXaavWScRr7gtsJaU62ZrwGvN92xjuLy1zu/4vkZ9P2fGj0KDl8P879JL0yR7
	 vBBXjPeN0N1hUdp47kYlDr5kul04dWk2cIwmWqC3ujfwrRkdkygdxlDuBO829RYEsN
	 xe85Pf3Qpykdreik1mg2SvxHeGVikch5HSlNNWMSUGPpwQW5hNYDpERSaWsMP5b9Pm
	 SBXqTwTvzRVUw==
Message-ID: <be698a14-c292-42d1-9a85-109a9072a0b2@kernel.org>
Date: Thu, 20 Nov 2025 14:35:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-8-shivankg@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120065043.41738-8-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C9477140014
X-Stat-Signature: ij38kmn7zcj4fnkmdtxmry5ksneijsxw
X-HE-Tag: 1763645739-754114
X-HE-Meta: U2FsdGVkX1/J4m4B9EgXvPXKFMUJZ18T9JtT00AuqQwkibS6woIqbHjodxABdudQqgKuxpVzaJiWv/AkSi1XXhy5smM9TZJUSS+of/Fi6OG2+zZtOzlSTgo4zlIrxZkZcKpzC858ANkosHgd1MOLkmXepRuLgIUYlB4jbIFf0K11aVqtwtYVj8qdS7BXBuzo4xznXdv52HUuf3gI4qDiLwzATpZxw2AlRIPKhvHmWC8PXY0HfrJGeadQtOKehprEcta/Jl1JAuodDLdgPpxLOFzg2C7PpRBiCrxt65ak+idnv0dWOsiSWe9pt4nSqDxYJnWqjcy6mhDX+ICiesaIbCW7iAc1S/1j/kJnZu+7Z3rtFS/GDkuXh66YXEu00FNRRbUx8LNdvWCuC2G8PU9GbD+Qd3lLbXoiOMtdGSHtCdBrBB9Z38VIgrfa4fFu/ou5ZDETiE5TO24D9AX9FpgX7lEl3Nkzw1+OEh2Y95Ji6l8N06Lp9Tg5dSZTv4G3YeLGgu0EQ9KMhfHvtqYKuGm7M7ZQVZ+vUilyBqFs6BR0/o7LwBe9cyHjZ4WS1SN2bxvGOI+ofOBE34NKMzoW9sd/9fKMgp/EjIxXo+LzunBVLom5qe3u2mNdUfCjbPK6gnl4o00KFRi8JCPtxXlIS7EKgHLTJVH2fTd0TcYtoibyIvKiLbCZAzuqyEML6kg45eb98XAQJ1FWnEvcUaW20kWSv/20ucCIFK+dIMmtPmuAftiOJ7UduNvg6GAf9sDDY/fhCh4mSSoNWlfKGBurPSgbjDM5Sot4xeXFpnT4tw8snAG+SbTSB0S7SUzytHg5YtnX9LCtZx/oqBjbiUqAkm/D8V7BqYq1MG3/w1kOG0euC31ulN0jkKSl92JEKdcHmW/C07m27nnRs7S0X0j8vYJUIXtlpqXf1AsYBKtAvLCaHxGEG76HULNVrBFV5jTbd6JCKVCpP9ht61CB+lXEiu9
 EjT8imQI
 fUNOFHYYmpL3U6BjH1JRQpwWlYopKyaSmN1gSbdw2WwWsVGtGXrCNJUjbSsj/DrPsaajpxIBcW+w5gCMRZVcrLxGUDNWrp086mxPao7fRAYq4CLHiJeIMWWfuO95o0A0a5kB/wp8EZKIEPtkVN5zAlfB21rX60P3xwDiATK/Lj15rf7OgqYbduvR32VV74vLQ7xbsJ0F3v3i1tovyo3sRjnx6bax5e+YgKGHxJsZMcvvMJJ78sBuWr34AacanY1+mHORgb41qS+j05v9KDfh7mQlkmkP+SlMdvLmqvR92MsiCOWo2NN+L05W8iqF6coY4S9++7s0due6bYUSWJo7Gr7NI020buY8fFizXaXQb/eUOAbN+dG/vjPFE106BG9XmSPaQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 07:50, Shivank Garg wrote:
> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> text sections), the pages may still be dirty from recent writes and
> cause collapse to fail with -EINVAL. This is particularly problematic
> for freshly copied executables on filesystems, where page cache folios
> remain dirty until background writeback completes.
> 
> The current code in collapse_file() triggers async writeback via
> filemap_flush() and expects khugepaged to revisit the page later.
> However, MADV_COLLAPSE is a synchronous operation where userspace
> expects immediate results.
> 
> Perform synchronous writeback in madvise_collapse() before attempting
> collapse to avoid failing on first attempt.
> 
> Reported-by: Branden Moore <Branden.Moore@amd.com>
> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   mm/khugepaged.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 97d1b2824386..066a332c76ad 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -22,6 +22,7 @@
>   #include <linux/dax.h>
>   #include <linux/ksm.h>
>   #include <linux/pgalloc.h>
> +#include <linux/backing-dev.h>
>   
>   #include <asm/tlb.h>
>   #include "internal.h"
> @@ -2784,6 +2785,31 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>   	hend = end & HPAGE_PMD_MASK;
>   
> +	/*
> +	 * For file-backed VMAs, perform synchronous writeback to ensure
> +	 * dirty folios are flushed before attempting collapse. This avoids
> +	 * failing on the first attempt when freshly-written executable text
> +	 * is still dirty in the page cache.
> +	 */
> +	if (!vma_is_anonymous(vma) && vma->vm_file) {
> +		struct address_space *mapping = vma->vm_file->f_mapping;
> +
> +		if (mapping_can_writeback(mapping)) {
> +			pgoff_t pgoff_start = linear_page_index(vma, hstart);
> +			pgoff_t pgoff_end = linear_page_index(vma, hend);
> +			loff_t lstart = (loff_t)pgoff_start << PAGE_SHIFT;
> +			loff_t lend = ((loff_t)pgoff_end << PAGE_SHIFT) - 1;
> +

Hm, so we always do that, without any indication that there actually is 
something dirty there.

Internally filemap_write_and_wait_range() uses something called 
mapping_needs_writeback(), but it also applies to the complete file, not 
a range.

Wouldn't it be better do do that only if we detect that there is 
actually a dirty folio in the range?

That is, if we find any dirty folio in hpage_collapse_scan_file() and we 
are in madvise, do that dance here and retry?

-- 
Cheers

David

