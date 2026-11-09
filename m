Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B02606A339
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAKPj+SG
Received: by kanga.kvack.org (Postfix)
	id 23F546B05B3; Mon,  9 Nov 2026 04:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF6A6B05B4; Mon,  9 Nov 2026 04:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106036B05B8; Mon,  9 Nov 2026 04:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDB1C6B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:34:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B1ED4063A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:34:49 +0000 (UTC)
X-FDA: 85415071098.15.0070B0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9ECC4C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:34:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PAKPj+SG;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794216887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55l1Yi3/+9u2aa4ZkVBG+syyKZx18Z3AHTa0nn0P3GY=;
	b=RENJmDxm9tzNVdBjFvvA6ZEMSyqWGOVYojXTGRod8HVGotPWbUR6FDeWhYVVMUC0HSSMdD
	Z15htQAQBMuP2xmBDJSbdogcLzqDE+C70uYIlv9AF79N6w5EoWkKji2emOAf+poRZfTBBn
	h2zmJPKMOlEORD8jARIbAtT3lA1IbDc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794216887;
	b=16nIOpMjkRIqJ/i9RAyBVyI5l61jJh949iL+EXOIhIMzefH1k2xb6f30yXn2/yS6Yjnzx8
	w7tnMrqJaMDGNNXxumC4wLDHawH+pQ42YDf1hHVXHsL/HUmMmv3LFmjTkjncSGfBCoq+hs
	/YyacU+xOtTDh9T0EFw8FTWEkFSYGcM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PAKPj+SG;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD64C42E06;
	Mon,  9 Nov 2026 09:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DFC1F0089F;
	Mon,  9 Nov 2026 09:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794216886;
	bh=55l1Yi3/+9u2aa4ZkVBG+syyKZx18Z3AHTa0nn0P3GY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PAKPj+SGQl3aG/CeH9fXlfLUbnAxIPlZc1msI20KN+wlX+JG0RGt69iXH19/tCsAX
	 O3XaCZg4CnSY/fLoVXR3BifCv9lGApl89zUuYDhhvWJaHi2dKWwToksvlJiHXpV2fj
	 jH3NliNw4GZzA2wNg9xPX7CARO1sotYR2SZZTP8kC3mmKABRqNsQ1P0w7bccgQxS/E
	 7Pdls3zIivgKtwteEHDVxXEMehWINLsIxWmKwdFZ3lSJ3NiX1inXZKNCfGJ4h8/wjr
	 7EOJ0qumw+xhBazQoJcIVQs2gd3fSoEFj1EQRVTjJcZXrN36BGncltuuVQ2US0VpFN
	 3IU6u6ddqdWWA==
Message-ID: <4bfb6533-1e77-4150-9626-437678b1785d@kernel.org>
Date: Mon, 9 Nov 2026 10:34:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: Tear down the direct map when memory hot add
 fails
To: Chris Down <chris@chrisdown.name>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Lance Yang
 <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <au_l5MRyDbYfsUVe@chrisdown.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au_l5MRyDbYfsUVe@chrisdown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9ECC4C0004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: tkspo9goziwum9cbw3isrr4j1ewiowm8
X-Rspam-User: 
X-HE-Tag: 1794216887-637089
X-HE-Meta: U2FsdGVkX1/mxIstvvtor94pAJG9JlV/mxYOn+wbZbMV4BQX0mBA0zJtSwmz8a8kCS4Epq4NDG0RxfyS4Bg3Uf1CavnlD2ihYXEtgjSqc9beC39l/IoNwklWuiO2zY+6hGgJeo7qw0V0VAUprCn1Wmc/Aw4p2ZBGiDO5ftYmZ/HVFOGO0z1Gudh8iFX6gu3Beg1Egc+S2ztxD+xwfB3DMc35YPamQuWJUheVXvbbVipau4hkqmcgxDJS2FL029pVEIuFxR0q7vq0RIgKjh3up48ClYZw0J10K1EjVLfCK0wLr5JojyOuxhSDlf1j2HrGwfH46ltiFlvI/V4+ZIMyPioFzbNViiQ6Ft5BZPcutBhOWTsmosy95V4ot+MnKih9mCKarzYQo9uL3jSDae01Bbo/ovsJ+G6eWRStvFtU59wWAPbcD+ZdtCFLXR6paHFO5f080yFAhYRPN34MvFdDTgNhTCi1/jW81Y68ANNlgi6gu5dwrIUPk8erh9KtzZxPQjvhWCoodKqPxi5uNFaX1rMQixDR7SRFDQtepMuCuoC2Kd8qiO/yt9WlsEmgm3fqAjQL75UMIRwDjEo/dvJIUDWA8hUHHalf2ekpk0z+tmmgHFFsLSU82VydFu3GUVQ3+4bxM5NtSVYAZAFGWCXs1Xt3ou5UvS4TAtCdjJI0MOfX3SNwJWfLoUBoskF/AO1rcM4VNInNOB0hbCes/Ih/yr1jHmnfXEBiXjKA0pVmCCHxEHRz5zBxlKwr2Nsp3r6MNZ2XLwAy/DOf2iae4v/1jzAdXW1m3mefn0jPerby0xPs91c0kvtso6R0OBZZTgyyYMJPYNPbGQRd1D1fh3XS/DF+MFEqinfP4lmWJYg47b0ZRqVY3CCYcv/XLsl7tu70cMHUQyy8XkvCo82TlyjUYw2AGCcPlgzzfIF1JaG0ZPZ50Ec8UPaJ/G8O+HbtYISibu87LNdNd/0SZzUQ7rw
 pXO/iPxh
 RvxPqDkDq7ohZJ7DyzCru90WcqD822E1hpAR2dKcTDYUmuyWMtTXs1b2ode/qPyq1tI/adcdLTTkXcjGLgsow9YtQSTdDDkb4uxXqd0Hevg3Ery3V02u81sHTPYDcDUYVUJw2m1mz9sVTQJUx4FykNbxzQnkwiqMW+zmZlRY+crqDLr7EhJBkPWoDhgPizSa+gQ5Kb6nV3lzna0lOHF8S6QI75C/c1dUEjY4nfl9V16+Tq5SexDZABkcVAfUtB+GAwNkPFEzCqhOR+jWTzQas0Tw7BHPfYFEAbSFm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/8/26 04:00, Chris Down wrote:
> arch_add_memory() sets up the direct map before calling add_pages().
> If add_pages() fails, the range stays mapped and any page tables
> allocated for it are leaked. A later hot add can reuse the stale
> mapping.
> 
> Remove the direct mapping on failure.
> 
> Fixes: 45e0b78b0532 ("[PATCH] hot-add-mem x86_64: use CONFIG_MEMORY_HOTPLUG_RESERVE")
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  arch/x86/mm/init_64.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 8b6d86fb5a42..846cb34b38dd 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -989,15 +989,23 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
>  	return ret;
>  }
>  
> +static void __meminit kernel_physical_mapping_remove(unsigned long start,
> +						     unsigned long end);
> +
>  int arch_add_memory(int nid, u64 start, u64 size,
>  		    struct mhp_params *params)
>  {
>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
> +	int ret;
>  
>  	init_memory_mapping(start, start + size, params->pgprot);
>  
> -	return add_pages(nid, start_pfn, nr_pages, params);
> +	ret = add_pages(nid, start_pfn, nr_pages, params);
> +	if (ret)
> +		kernel_physical_mapping_remove(start, start + size);
> +
> +	return ret;
>  }
>  
>  static void __meminit free_pagetable(struct page *page)
> 
> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

I thought we fixed that already, but I remembered

https://lore.kernel.org/all/20260930160432.5564-1-lance.yang@linux.dev/

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

