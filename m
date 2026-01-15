Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF483D47CA5
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8426B0096; Thu, 15 Jan 2026 18:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA62C6B0098; Thu, 15 Jan 2026 18:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87956B0099; Thu, 15 Jan 2026 18:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5ECC6B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:48:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41161C1F12
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:48:58 +0000 (UTC)
X-FDA: 84335841156.12.95A03F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 617138000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:48:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZbCPxLlG;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768520936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWbVYkGLs0GPca8Lb9eOzddCko9Dp1+T7GgoFpUQ4oM=;
	b=Yb3qBuW2/Enzyg9U0NKiyEMECF8fJzkfT65UZ8WN2O5pWhoQv0avCTpdnEOXWtNl6LK4AO
	sgqLGbY/+B3c3WHUV2i/SMeE09IuUXGndfRSNlnyu8BhZ3Wdz+5+qGi8xkYMVUMK+lk0IT
	CwdvCb54B5e/+/PPL3CVCQfQh3ChoSk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZbCPxLlG;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768520936; a=rsa-sha256;
	cv=none;
	b=68/Y8Aq7cMHQuNqedYIIIYxQ4xRpIWXLUsbas1b9l6xiS6LBTseALlflnerEMVr5nc8yx4
	tWkJ1kieZ7xxxtgWEW1PcEQrwdRuUNId07E7UgTmwj5rztCtBxLYowD1AS9cbG/lKXPow0
	rbUN1m7mFUw2Ldj/R2w6hzB0wBt9nd8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5388742E20;
	Thu, 15 Jan 2026 23:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4F8C116D0;
	Thu, 15 Jan 2026 23:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768520935;
	bh=oefMjdZp2nJz+Tj6t5nbIdKYyCTyxQCLpbveopuW1V0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZbCPxLlGHoMFQzvGaL0M4b8GbuIoUlw34aS6YQLA8O5/g5ke3cbKf73kW3L7pOu+3
	 CFhF8AoDGosJI3YPdXzg3OH8OZJ12FHN9l6dE/lGrB2+VzwSetCMHlhuc9D2A0NFs6
	 9wo80t8vDKSuRyPimsBnVsvgZS/4V/6LmSFqKvx82RbiFJ2WsHuSpRNALKkQ4IWsbP
	 uqsef/OreqOhElre28p8xFG1+JxodqKT9mIZpLazLGQDU5MxTdxUtXy9nkQtzEAJ+G
	 SvAfisWQiEwCphYpnT7d7qvboqJOmggD16rGnFzIs3teTpRfmxoWYViLu40Snp1BI3
	 JhqrEyFPUtx3Q==
Message-ID: <719f9bcd-0990-48e7-bf3b-929417a13db5@kernel.org>
Date: Fri, 16 Jan 2026 00:48:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 3/5] mm/khugepaged: change collapse_pte_mapped_thp() to
 return void
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-10-shivankg@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251224111351.41042-10-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: h7p3wk3ejaitstmaf1y8sujgkrj95o6s
X-Rspamd-Queue-Id: 617138000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1768520936-785495
X-HE-Meta: U2FsdGVkX1+QKHhPDI1tRCtEUmEIhMuTyj9pzB/cblNqQyKhU3aK1YBi1v682YRG81Ag1qz4vcH/nPeNeFO5p/e9fYMORyXACzUIWAzOROmoI5Xe7wvaJ64ZRnRUB1tCpSktJ+8WDF3QZPD5lgtHZVk8NIAzeVWHkMLfLdC6m7IA9qiqMDg1uavoRKGeTnlzgseqcBkwiITRnGc2/wWxNu3Hqs1A95gi2XbeWQ+JzahwTQT+tn67uuhTt+pi0g6iCtUDG+yl2alAe6gABeDz1dbTvwwAraUEZlfYLKZooZAZkkwMAlIu82k7HgkDQwkUCHWsdJQuN1nqwEmvtCzjiMbT3prCuGfXffhc6J3Bu+7R0AuQ505ni1P4vWfJZtgwXxbFzQZ8RcQie5+LM2u0+xyld3Or3g+aP5SbKTlErSrWkeYxz12AkAHQOuNBro7Sg+LN9irN5cqFT/ncsqwsChz3ReGJSM6HwilBwM57JvkKN5ZmkQJIh3Gvq2NgP8yrtxUylywej44spk+BPek41gUCeh6XCZLoKQIU4bWtPYyH+77lyH2q8xmlVdRATyM9L2sUnDuRj/yKMT+2nYTvCccOder5PYXZYppKiJvTiDdoxkQ2oXgjF0lPFzTYGReBh5xLakeevAEsbU1WgYJ+noOJkdodOkuLrRurW4TTSQSHHsRBMXD4pOduFpKD7UirwqECAUr5PCJtb3Vwe6rTGGlkr4K+Rm6vyGsBDiVJ59wtjgBFADqxKHbZZeVNThlWYZuAt2fcntNIuKEy5D0cUEMaiGieQD7l2InPFEZTlIofO1B76+TrUxBbS22b8+YE2++55kCE4GjuFY1W6uvZclIjaZVRhfSgYCrWYRuaEI7m+PW7VDfTo/1dfr3Vb5d4vYEreWrf8JjAnALOHqlI6KVnAEvYC3OrYtUYV2YR1VYeu+I76LNt/1tNXa4tg8lOguAKGdAFCJy4PeQZgPP
 SuvuQnWE
 ZzQqcQpjR+5gq7JfWln/a7U3NlvgTwvlYZP4C8VcqIRJMG7gTMD5XKXjG/vqU1rOpl0cYUFhyQNQ6+XnFAWN26W8XsAp1DjhZySTMBKjvrFFDtmU8+rOUrp6tS2wszkfJdb6e4yqG+kI1RbYsFycfqWl/QVQfnmAWhlmvnHAd9YWtVQKGPhhxE5W+tjUMcS8RMhebo/HxFqNy7uvqFe/OX5tR5WJIImQlmzGQQL6VQQ16QuX6KZm9XUvs3riYp9DzAbQmTmoHC23VhJ+EbxQ4KTgvEK4W3RhY6xozesaOTxbWtGu21J7C81pgWDK3VMkIaF6NsJnuOlf7QLxytNyZK4V/Gs6paPodKD5x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 12:13, Shivank Garg wrote:
> The only external caller of collapse_pte_mapped_thp() is uprobe, which
> ignores the return value. Change the external API to return void to
> simplify the interface.
> 
> Introduce try_collapse_pte_mapped_thp() for internal use that preserves
> the return value. This prepares for future patch that will convert
> the return type to use enum scan_result.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   include/linux/khugepaged.h |  9 ++++-----
>   mm/khugepaged.c            | 40 ++++++++++++++++++++++----------------
>   2 files changed, 27 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index eb1946a70cff..37b992b22bba 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -17,8 +17,8 @@ extern void khugepaged_enter_vma(struct vm_area_struct *vma,
>   				 vm_flags_t vm_flags);
>   extern void khugepaged_min_free_kbytes_update(void);
>   extern bool current_is_khugepaged(void);
> -extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> -				   bool install_pmd);
> +extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> +				    bool install_pmd);


Sorry for late review.

We remove the "extern" whenever we touch functions.

Nit: two tab indent on second parameter line. Same applies for the other 
code you touch below (if you already adjust that line, just indent with 
two tabs).


Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

