Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96798CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 11:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F4D8E01ED; Fri, 15 Aug 2025 07:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0D78E01EC; Fri, 15 Aug 2025 07:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F648E01ED; Fri, 15 Aug 2025 07:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9B528E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:13:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D795160113
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:13:29 +0000 (UTC)
X-FDA: 83778730938.17.1C47F38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A87F740002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:13:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755256408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gbUJHuak2u5MhS/qm2dIicmSf5kMrLrrJoF5h7UvVAU=;
	b=yagFubkSZ7NCJIGM6F+M1ycoKZR+3+06vO0e3Ml0A85WxBQbGO/4KJWJGEC4tXN67IoicF
	GV0xZfDNOLGtcWfLJehGrswaJQLRRCP70yWJMV765GM+hql22iC3aU3tG0g/ZxzjuutCsn
	uwL7egV6mo0tDquN1AsBkVnZZElWzVg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755256408; a=rsa-sha256;
	cv=none;
	b=hNGCll4XRB1MPGURQoof4u4xfk+DMlYI481Jbk0fdzQ+o3/NbtqiJFhOSHlPOxZLCXqFCj
	tdUZtzNCHhZ0zsJjORuw386kqNcYoUtBtHNi65sHlYqO59iKChXQVwIi3TM+W88AqriJQ+
	i2JKEwmyPyv0xIJGnZhFCpAayuf2q7E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2547F43A44;
	Fri, 15 Aug 2025 11:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B8BC4CEEB;
	Fri, 15 Aug 2025 11:13:21 +0000 (UTC)
Date: Fri, 15 Aug 2025 12:13:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] kasan/hw-tags: introduce kasan.store_only option
Message-ID: <aJ8WTyRJVznC9v4K@arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
 <20250813175335.3980268-2-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813175335.3980268-2-yeoreum.yun@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A87F740002
X-Stat-Signature: pdapus8nphucpb1fm4c1wb9twawneo5d
X-Rspam-User: 
X-HE-Tag: 1755256407-720934
X-HE-Meta: U2FsdGVkX19CwU8wrD9nNa3/QqR9GWl4CISiQ4R7lAS4Om8uD6djfI52g5XnATLW69GsXo9o4muPXnwiHgH579rsfVc2Psg4hLj2/5yRbiwiliSSCsfQMU96o4N41/pNBg/07+sctsvyFvxxzX550lpMlG5aJxVDPVnteAPtwj+gIwQicvUI9ex3WHigYpAGaZCOwfHMxklLDkLqiguBJkNyx8UTMd3hjtopzKVkLeKTdAEac0+Fn9X3OlFLXxCGRi38GCa6NmdAVj620o6OGQj6wQTH/6eAmheA9bAMuGRLgqF5zqGYNwfnNW79MRzZFg7Dt1ZDdp44U3W0wi494Cv5NCkq3BS3FCo7U7oNhz8Kzwc71DAjuHab50cMGBhabylWEOf7XAshPnkzihpzhPGbz2yRMkjCxXyp3nl1pGG+wIJulSs7pfQ8j9JAcHJcbJDJxc56kU8sE/oqCrGHrVSGG3kK4ih+IqEd6R7pkfqOpDsl73cfzY19BcXqVhoD4c1MxMoeKZSk0BhPdNUPryuC6tTy75Er/vF5GIxDbwHZ+pCOxXUVSWdGMVPQ9pUxYc9qOaJm03HCUul1OzWidCXbAbdJFgzgseeFT5I3SjCJwYnXItSpEkrMWFT4bhEbPA1A+Ks/f2QuRicvXrO/y3+ABJEstyqWPxJHmWnmiTMXw7gKghjR72r8G7XIKHa0OH2csV4B5aphCui/WKO4QC9Czf7u0Kc8uuz5dxjlvfA9Efbf+gZlgloBEqrPu8yLSiBlcCqVV/VDrMsvRsT70JwjE0zlyrx7Nn2g9C7IoKfFm3s2n8x2DSIc4DIkB301/j50Go1udoKmB4YaXJUatq14pQPqGVvQUWJ8HO2/N9fundC949JJzegcSpdNnHKMBVwXoB0OWdB8czX8tPQnP0OMHqd1w4rGYXzeyZbURh+yyOnUsbSwefAmCsVhRq5xOtGpiJ0dz5JiG6b5Imu
 ATt32Gt4
 NXtUGnEw0PMTsWDRbqr8j5xqPQZg9BEbbislNR0w4JSBOAZcySkaIzpm2YPYqGSEIE9GPaKGeqGwpku5cmI5CfMcg4Tep1/7JsqTXfoFzv6xmW9agMIvOpO7v/pP0XY8+HtVb//MLaSbeRXMarladJs8y1dTDKVCePyF1WXTDIsDa0aCxGAJwtQSgN8AWJen4HRYwyaZtTwiqcSzPAM4boqM6GVglWLABZVLp0YJHnnx6lj1pyLUgNxhvPd1k/fHG+TCCVHnUgKS6lgkqlJPp6hP1Fr+AH7RZz7cCYbuxnh7TJ0rI13AGrLwPpTIEqMd9pK3YhVCiuJ/YGLzroIzwNxWdprbHdr3ds4vMWEI2HzA8Xj7bN5qqKvdj4xQRdBN84BmK+eXH0uXQR56jUYhpLngdMsfwb00I7wEV87FKEkenzDmlZa3MNsOyYM5H8cZSPggtMVBfkN7pMqao7cCplBCKXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 06:53:34PM +0100, Yeoreum Yun wrote:
> diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
> index 2e98028c1965..3e1cc341d47a 100644
> --- a/arch/arm64/include/asm/mte-kasan.h
> +++ b/arch/arm64/include/asm/mte-kasan.h
> @@ -200,6 +200,7 @@ static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag,
>  void mte_enable_kernel_sync(void);
>  void mte_enable_kernel_async(void);
>  void mte_enable_kernel_asymm(void);
> +int mte_enable_kernel_store_only(void);
>  
>  #else /* CONFIG_ARM64_MTE */
>  
> @@ -251,6 +252,11 @@ static inline void mte_enable_kernel_asymm(void)
>  {
>  }
>  
> +static inline int mte_enable_kenrel_store_only(void)
				^^^^^^
This won't build with MTE disabled (check spelling).

> +{
> +	return -EINVAL;
> +}
> +
>  #endif /* CONFIG_ARM64_MTE */
>  
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9ad065f15f1d..7b724fcf20a7 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2404,6 +2404,11 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
>  
>  	kasan_init_hw_tags_cpu();
>  }
> +
> +static void cpu_enable_mte_store_only(struct arm64_cpu_capabilities const *cap)
> +{
> +	kasan_late_init_hw_tags_cpu();
> +}
>  #endif /* CONFIG_ARM64_MTE */
>  
>  static void user_feature_fixup(void)
> @@ -2922,6 +2927,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.capability = ARM64_MTE_STORE_ONLY,
>  		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>  		.matches = has_cpuid_feature,
> +		.cpu_enable = cpu_enable_mte_store_only,

I don't think we should add this, see below.

>  		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
>  	},
>  #endif /* CONFIG_ARM64_MTE */
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index e5e773844889..8eb1f66f2ccd 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -157,6 +157,20 @@ void mte_enable_kernel_asymm(void)
>  		mte_enable_kernel_sync();
>  	}
>  }
> +
> +int mte_enable_kernel_store_only(void)
> +{
> +	if (!cpus_have_cap(ARM64_MTE_STORE_ONLY))
> +		return -EINVAL;
> +
> +	sysreg_clear_set(sctlr_el1, SCTLR_EL1_TCSO_MASK,
> +			 SYS_FIELD_PREP(SCTLR_EL1, TCSO, 1));
> +	isb();
> +
> +	pr_info_once("MTE: enabled stonly mode at EL1\n");
> +
> +	return 0;
> +}
>  #endif

If we do something like mte_enable_kernel_asymm(), that one doesn't
return any error, just fall back to the default mode.

> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9a6927394b54..c2f90c06076e 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -219,6 +246,20 @@ void kasan_init_hw_tags_cpu(void)
>  	kasan_enable_hw_tags();
>  }
>  
> +/*
> + * kasan_late_init_hw_tags_cpu_post() is called for each CPU after
> + * all cpus are bring-up at boot.

Nit: s/bring-up/brought up/

> + * Not marked as __init as a CPU can be hot-plugged after boot.
> + */
> +void kasan_late_init_hw_tags_cpu(void)
> +{
> +	/*
> +	 * Enable stonly mode only when explicitly requested through the command line.
> +	 * If system doesn't support, kasan checks all operation.
> +	 */
> +	kasan_enable_store_only();
> +}

There's nothing late about this. We have kasan_init_hw_tags_cpu()
already and I'd rather have it all handled via this function. It's not
that different from how we added asymmetric support, though store-only
is complementary to the sync vs async checking.

Like we do in mte_enable_kernel_asymm(), if the feature is not available
just fall back to checking both reads and writes in the chosen
async/sync/asymm way. You can add some pr_info() to inform the user of
the chosen kasan mode. It's really mostly an performance choice.

-- 
Catalin

