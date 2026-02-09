Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 179FDE81BD9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547AD6B0093; Mon,  9 Feb 2026 10:30:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518FD6B0098; Mon,  9 Feb 2026 10:30:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424EA6B009D; Mon,  9 Feb 2026 10:30:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3276B6B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:30:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEBBA1B2880
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:30:27 +0000 (UTC)
X-FDA: 84425304894.13.250BEF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EA17D100008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:30:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqdHMa6Z;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770651026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKAxm9xBTz/eb5vio0bs+wXtV5RFUrrt3e+Gwjv2pKM=;
	b=LykjIbFmZ7H49OFNOdRCgSYacDX0i3ygiyjU35gvDGjg3k25eKkYsU3ViY76z7WDQCvMVj
	UaynEYQoIJg0AQP5HMfNAXrJHy1xTEW4vLUfjTGSjuIqDAhSDRGZZHN5Px1n4la3YEuBlA
	7r43xPD5j/HyK6BpKdxUGPTW9mvj+wc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqdHMa6Z;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770651026; a=rsa-sha256;
	cv=none;
	b=HiXhRNQjuJszVvU+FvFxwcDGLXaIhdv70ZllPq0SmAERMMevn8zmgf39uzuSKVNrr8fVib
	tZ+tbkEekUK7MToei1YBudkeA2l6kZIrBfurS0QtIJfVCp4vWKEXT5ZOL9LPaS5jUXpTgj
	8YRktRjr82tj3XhMlL2rYBUIyBf0srQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03AAA43DAC;
	Mon,  9 Feb 2026 15:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D09EC116C6;
	Mon,  9 Feb 2026 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770651024;
	bh=Syo2nfb/vozha/nQ+Z68XrYJGV/g5qSp+feAbh52S5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SqdHMa6ZFYZMW0NCI/VHNQ+3jxq5oc3uR44Yls619P07hTcg6a1dhw/KkixDq0Sr5
	 e8mHUOXynARMvuuKER6zcpH3G3iynnCyThJJqbhqpDXgLOIJczmXHKEMaTxwAflX3p
	 hAwUsI92FpOd1FRHqOMpClOAjBgRsk239HIn1ryBntwXfQ68Ergt5NamWFz3W3ScFC
	 UO+ku5KRR1u2jzVe2UTSX6c+cGs60PZqJAn2Y/tsd6n3KFR8ISRA7snvtMz7xpSDJl
	 oNYWjoGFvVC2NKBr76yhLHc+gvEHDI5+OYwY9lGL36ZA0RZrjNrEcU6YATFpByrTnG
	 2Vz7rH2ogi/Nw==
Message-ID: <10f061c9-5c9a-4e8a-8790-a2a68b38ff33@kernel.org>
Date: Mon, 9 Feb 2026 16:30:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA17D100008
X-Stat-Signature: htiszhjpjateztcjj79ye87ikbbucpf5
X-Rspam-User: 
X-HE-Tag: 1770651025-843056
X-HE-Meta: U2FsdGVkX19jgj67VreZn9OzLdTH443ZuWcQfgbkAMuOnb4fhIllzxvZJWw+Pvqsi+m30r4E2XsxXKgXzrJNaSPafLkVco3r6w8wHzu5G8jYHBK3pccFOz/nV8TPOq610fAFEfVsSVSFi7R6hVpk109o9M3JsOVipKVFMkOGiQHJit641N3UOvbLz5bONABvQvu+xIvODaq6zGiaOe9lA2BUU7v0S+eKs6oSzsaHOOX7FiPmS6i/ws+cl4vowtrelJ68dsc2j4WR0K/DIoQsTso95lY+9zfDhCtnNKgqhc/xHeHap3HqH/xflEuVieRet7Q9FGXL4ZMPkuU6cnbdciabiyef57jDeEI3cfsOZuDJgOrq5R3pgxWlUlnRs3mb7w1XC52cjVM3VzbBUeEkjJi2vxNe9xpMZCdda06T9QYK0cJGMLFFMAPEXczXLKMzOEydn+YjmdskrZMoPnk61GUxLaXeV/bxEFTyQ+DWSt0+lmxbmozeve4vy0ksQ3FSeGL2rxE/Tf8YpETwWsLQNUgWD9WbudUXb38U+NtVLhGI3eBuU+q3dcTOHsjeca7O0XAMZ2C1G0+l/LgQxqtEN3AVBZ+/1LcAJtKVqLzi9+5/kaGmcIW2xz01NLdlxcohMf7pA1HTw9YzFbWj04KYJDy9GotcM248i69EojrXANlFdxuzPJMm8cr3/FrE/KR4fYc9M0m5LVadUeiU/KfCU1y6L65gezVY0aYtUYPwB+Vk3BWD4wUJtCOIrhZVdSTqpF9n18rsYHxsa6vJf2AdWj8cOOFrCdbrktWi8JGkFHjusxY5cmZ3iE+vUqpNLCDf7WOAvl9HBuyPlzgaQGSjueODE5b4FlaxSuxaHo1bkLcU7jOAL3aGzoR8JhkyVWT7FPyovCGkFTWmGyIUUYXYsvxlObTwkk/cn9Jx+clnqfLCRZnUX23nEMSwMRd2EQCccnE6o6YTBrbGx8xHNuE
 l/Gn/jKh
 sO/cNkBkoVjypMDxyE4c9ObkK5H6Ch7HedvgzA+/r+TOuoZ1l8iWE6wBT6b1LLcOdc3iM/tR6/ypBcWsLKmfQjbMELhZ8pijZ6K3EjPGBBuVwi6epzAJJWIHA7Uq2ca9LZgJVTfHyAgEpOs8KXwLpa2jeLNIS0gjCa5HO8w5PLs5B51CYCHu2wsDwzsGll+vpdK+T9LDJGXbK+p3eTdboeslXW6vbnsNuOAcAcsXPaB4MBfIPTDskN1s6CEdgxYGSdozjaexkUmwFk49OiKPOORnH9d3mjGybBKsZ4bKjtEGohCe+9Vern/iNmXG9RGi/O371N/spGaO97fd97NpKiL4KOIDZXnOP8vIMzDFhxFRGPO0x6joKXhUpY0+UdGTGtRxR6Jii74PhhGk2mPDeEkFXdwuagusdiAm3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 15:07, Baolin Wang wrote:
> Implement the Arm64 architecture-specific clear_flush_young_ptes() to enable
> batched checking of young flags and TLB flushing, improving performance during
> large folio reclamation.
> 
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
> from approximately 35% to around 5%.
> 
> W/o patchset:
> real	0m1.518s
> user	0m0.000s
> sys	0m1.518s
> 
> W/ patchset:
> real	0m1.018s
> user	0m0.000s
> sys	0m1.018s
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 3dabf5ea17fa..a17eb8a76788 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>   	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>   }
>   
> +#define clear_flush_young_ptes clear_flush_young_ptes
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					 unsigned long addr, pte_t *ptep,
> +					 unsigned int nr)
> +{
> +	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
I guess similar cases where we should never end up with non-present ptes 
should be updated accordingly.

ptep_test_and_clear_young(), for example, should never be called on 
non-present ptes.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

