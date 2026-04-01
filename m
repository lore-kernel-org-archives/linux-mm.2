Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0DC6D2ED0A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF536B0088; Wed,  1 Apr 2026 10:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D74A6B008A; Wed,  1 Apr 2026 10:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F2B6B008C; Wed,  1 Apr 2026 10:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1BAD6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:22:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 766EAC8F6C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:22:03 +0000 (UTC)
X-FDA: 84610201326.13.253EBBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B0E9512000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:22:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f801QttQ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775053321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Udu62aiUEQcvvl3iN/QpcXDAHXiWfOoTUovuy6wG5ac=;
	b=YXIU9PcoNfMU9Ik9tQhx9cDZsfWKvNTUtfP1dsUMs9Zf1gpB/oCT8caQOya4vKP5Hk+iKw
	XpI32AQ1io1HyvsmTB7AnXVJz3EGM2OsGTi8yXT/XHv8bpf1SpZpB+2Ryd9PrzV4/TGmmC
	KS1iQjRBmy67TYcd5WaK1hVJUpVyya4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f801QttQ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775053321; a=rsa-sha256;
	cv=none;
	b=aNnZZf54rwFEAZOgFGW6lUEGJI97Ln/tCMi1fJ5j/9TiqdMjpGFEf36n5Rr6iT9ditwYMu
	WGN3Lt57OeRV8uAghySz8aP+CyqrgfNK/rXBasyLMkb4OMeRK4nhYzJRlCA2HatP5iG+ho
	lQT1NDRbyP2V7pt3MjJB+KLR+/qHdB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16A05600C4;
	Wed,  1 Apr 2026 14:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA86C4CEF7;
	Wed,  1 Apr 2026 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775053320;
	bh=Z33pYm24qbSvYLg3avP20eCSmcuudyAdxkucbIxFgJc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f801QttQuTDTdEug++TXlbPQYcGwCgqDN19BY676yqfaczi4em00rtie+1epsL2uV
	 MhCJ7qmAWnh5SFl3tHZQi4yrsSvvaYgZu8/S56CJxizHoD4xCSPPOyNDKQhK1WgNun
	 bQB2dzI1VOjGQ5BL3YOgMbmS/jIUXG6esDRtAp/7fqqCfSxCZcfruuF3rSoha8Wxzl
	 Pjy5mpBddDIHQ9/Bn/R+HLjeQfhHcUxC48da58+1PICwZ7WDOUIMjkr7dC6E/MPo3e
	 OnTv6usFWdMqfkzWa4bA666Z997TUHktcBwCkpMUyQ1u+drN4FEyoa36g71VySGYeK
	 Fg92NM9zrxGpQ==
Message-ID: <ee15d52f-45df-415b-b0d9-3d267d147e5c@kernel.org>
Date: Wed, 1 Apr 2026 16:21:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/13] selftests/mm: ensure destination is
 hugetlb-backed in hugepage-mremap
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <3b6ffba238a4b59de891acf896fa25d7d3193228.1774591179.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3b6ffba238a4b59de891acf896fa25d7d3193228.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ym1gu4dhkdzxkjpcstkrfuyst4wiq6az
X-Rspamd-Queue-Id: B0E9512000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775053321-958835
X-HE-Meta: U2FsdGVkX1/DNiWD8cAUiM+1h2ZjgHyAhl6pCurKhWi/Zt++SEdtvbnTd2JNm27lcjA+1SgYnJiGp4XFqWw438NxGxg6n6uG4ZaLzhh/U37DpKb8jPsiJDvZ1KaBkMflh8SzkeW0FzUimdVeOwYZjzsofEtHEbqKc0QwSKdO54prsWiAIJ+rftKTvxpG4oqRPr7DLagxfg8XxxQO2DWbZsg0E6XUVEF95U0wH5n6ALNxX6E35BfqOcoCVK3GkUeVEdDQtm6cn1GvfdD1c5y3OhZktTQL3Uyppi4mdqA7D3ex+Dk9RjztPULnoZ+x8YM5ou9tcVNdv+j3KcRrMR5hVcw08Q9DywHD464I6D498j9FaduodB+6bhXeSEak/8JvTm5oSqxqf9jId6Fdk4CDuDNa3intPy2QaNCErRQrgnf4HQAI2hpN8s6nPBql/876JJCkntkYFcPJajugmeNTVtdKjpHjJlHGI+qC6KCOM84yK564nDc6BO3kW0Q1cnIOhUfHVhCQaDepfuNJkR0/sxKFk1dRjchcENOyxoHmmFnr2fPLrVTXtIlGmf2iBaW+8O64yiIk0ZF9gkUMqBuFzEKZSTQXNzEe/Q7nloHOCdt7YGrXmP3LCwZlpZMcST/C7ocW3G0Kxc6lCp2S4z2qJNSORJBSJ28m5DZyQyWgdItpWdPjsBJFCJ8ltPVJvQ8PL2ulA0ygXvT7w94p0kHCBZM2ZjFF1sojlziMwlJmu4Av/noOZ31YjUy4XJhIKzHNKjTO3958ssVjjXLO/2cOKObj8XcVE8Vg29xSNMMA+Ltm9cN4zaJPGahlN+M5sBmbC9HNslGH1llUVx239Kqal8XyBTI2Yir+lng0xlPw+okuX5irLtqn5RsclpgQD77960SBNpQtDHfDeJXFpeWzoAgn0lmz3x88y1OeopfSPnrkw12rMz+s6HF5vHAj5AsIhphksMSxQl4M38IHa10
 sLHMNt9B
 hLRmSXxEbQBmWtIAv1xOd/Qt3lKtpB1Ctu4B7Z8GR+j5PapKNRKiCsjqsxebIuhhx+wOoL1cwI3xPkAYOauB4F9yLE+QCyxyqV6s3rO3/PSVnoCDwLdXZHbfGkOVAakbWJy9LZAmGmUWaHdB24up5r/DqltiZn0BnDV6MQg+Mz6SOsUOM2aswtOpja0KNwqbej/HZGyPzUhyKkt+4o9LjI/n5bDSka0XqcHhkZUlz7VyIzU7Erd1lSs1TVoxZKZ/rPBnX34tpv/C9h/hWFXzx07OhErQd2VCtsHZqPid6CddU+M87ZT2pF4hG5BrMQBhovh8vgcYVOIYp18LcP+2fa8BGUfjpowLKTuzeycjNvgsz7kmA6Yf+00HqiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 08:16, Sayali Patil wrote:
> The hugepage-mremap selftest reserves the destination address using a
> anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
> while the source region is hugetlb-backed.
> 
> When remapping a hugetlb mapping into a base-page VMA may fail with:
> 
>     mremap: Device or resource busy
> 
> This is observed on powerpc hash MMU systems where slice constraints
> and page size incompatibilities prevent the remap.
> 

That is weird. An mremap(MREMAP_FIXED) is really just an munmap() + move.

Are we sure this is not some actual problem in the hugetlb implementation?

> Ensure the destination region is created using MAP_HUGETLB so that both
> source and destination VMAs are hugetlb-backed and compatible. Also add
> MAP_POPULATE to the destination mapping to prefault hugepages,
> matching the behaviour used for other hugetlb mapping in the test and
> ensuring deterministic behaviour.

But then the test suddenly requires more hugetlb pages, no? I don't see
a good reason for the MAP_POPULATE, really. It will be discarded either way.

> 
> Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED |
> MAP_POPULATE so that both mappings are hugetlb-backed and compatible.
> Also use the macro for the mmap() calls to avoid repeating
> the flag combination.
> 
> This ensures the test reliably exercises hugetlb mremap instead of
> failing due to VMA type mismatch.
> 
> Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/hugepage-mremap.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
> index e611249080d6..48c24a4ba9a7 100644
> --- a/tools/testing/selftests/mm/hugepage-mremap.c
> +++ b/tools/testing/selftests/mm/hugepage-mremap.c
> @@ -31,7 +31,7 @@
>  #define MB_TO_BYTES(x) (x * 1024 * 1024)
>  
>  #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
> -#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
> +#define FLAGS (MAP_HUGETLB | MAP_SHARED | MAP_POPULATE)
>  
>  static void check_bytes(char *addr)
>  {
> @@ -121,23 +121,20 @@ int main(int argc, char *argv[])
>  
>  	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
>  	unsigned long suggested_addr = 0x7eaa40000000;
> -	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
> -			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
> +	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>  	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
>  	if (haddr == MAP_FAILED)
>  		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
>  
>  	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
>  	suggested_addr = 0x7daa40000000;
> -	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
> -			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
> +	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>  	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
>  	if (daddr == MAP_FAILED)
>  		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
>  
>  	suggested_addr = 0x7faa40000000;
> -	void *vaddr =
> -		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
> +	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>  	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
>  	if (vaddr == MAP_FAILED)
>  		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));


-- 
Cheers,

David

