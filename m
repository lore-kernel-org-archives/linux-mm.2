Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E925CC56201
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4E56B0096; Wed,  5 Aug 2026 07:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CD06B0098; Wed,  5 Aug 2026 07:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF46A6B0099; Wed,  5 Aug 2026 07:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC86A6B0096
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:05:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5EB27140441
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:05:26 +0000 (UTC)
X-FDA: 85066934652.02.0B59B68
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf04.hostedemail.com (Postfix) with ESMTP id 71C534000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:05:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bD+JxAel;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785927924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4866Y3ff9b3uwVCiml3jDWbGReoFxp6nuoKOcd5mp8=;
	b=SDZ4nSEustuF/ouVgL3aMns5tbOkQkIGRFI9lxlowD5uCGARu8GfGin6+a6ZIFCYdZ9sKW
	aYiL7gbCvoawC8iKF1VKXalI3YOaTdONJWbNLjEsT296IZMy4uslPHQrG243SedkSgc+84
	v8QtJ1akY3BSj1rjb56OtKZgj/+IowU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785927924;
	b=RqtvNVKBzrTXYyFeyqDeSGKCZq5IjWGV2I/OiUeHwvgYUC7w+o4FHuiFw/yEbg9BceXxZ2
	sOuW0rNtX/NPG7aAubjHTNn+IgQljud3iRyovS5zf1o6+dHrJZGMJkIrcg9dnQZdzGV9za
	VXeL7Ysc6Vz2x48muMwmqRgqQL55hfI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bD+JxAel;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785927918; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=o4866Y3ff9b3uwVCiml3jDWbGReoFxp6nuoKOcd5mp8=;
 b=bD+JxAelPaBAqKsaAkHvcjwYA4gQ/Io3NVhLtBV/VZ8382OogBThLvqDU6LWtbiEGj9ZyY
 Q/DXuQgD2TriUtpQ2bSghV7NOIdtqpxIVhpKFsQnUV8Jr83Q2CCnfP08Ywh+8WAVIcZbLT
 rJD1jBz8Re6xhcNw1Urw4HFzNyjoGlowHPKOs/yerEXr6tTt+If38LTiTBW2qNfljRRnwM
 dv1E3fqwRsslV43t3tXMVu0dVEwcA61bdgHSuYVkW/2W7YeaA+2zQs3Zkd0poZ/0AhBGy1
 vA5ZPEKIeM9eBCvwnHuO/UFnr6nPSiE9fG4CXBKilzTOyH/5x9GF98ij0ojsbA==
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260804203508.GEanJM_LGXmItYhFKZ@fat_crate.local>
To: "Borislav Petkov" <bp@alien8.de>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH v9 8/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
Message-Id: <94d6172a-b7a5-4eac-96b3-15cc83d424b3@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a7318ec+350cf7+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Date: Wed, 5 Aug 2026 19:04:55 +0800
Mime-Version: 1.0
References: <20260803070929.86075-1-lizhe.67@bytedance.com> <20260803070929.86075-9-lizhe.67@bytedance.com> <20260804203508.GEanJM_LGXmItYhFKZ@fat_crate.local>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 71C534000A
X-Rspam-User: 
X-Stat-Signature: f18ofh8bfm7o8c4hcfgz3wiyootwyf7f
X-HE-Tag: 1785927923-237670
X-HE-Meta: U2FsdGVkX1+bXQuW/6ASRQiuc0Ur9wqESPIJ2irjtbws7oT1JlM79D1lEijLNtZwn9zTbenIPAVKXWshDYjPUkLdQNaQJwhTm7nGBxpG73BLvnJ0xCDhW4UEjzWvMZ3ayoYAZVcItep+nusaTlua8uP5C07YP7/JSdjCBmCqygk5ss2NnAIynZuFOnz1R4sINRmIVGjAawToz/YwYkrl5KaLjSTkLgr+zGslTiS6lAdaWaRDPb1G6CiwUGQrlx0n2NzYCT5DJKWh8RvZ+zFzT8xTYYpcgkQqLesO3Hb/kQdo1HRZByowDscKMqMSIfgDbolLQ6WI2svMDzT3ACVR3syiS19z0jzT8GLt0D4XRQFePGCjPYsNY7SppE40eaJpEiJG7ScyUsWz2lwjh6C31JNCGFwt1cx1evbkN+CrTdHI/K1vWHs+rbkvjh8Xf6oW/adjNLOs4HVDlaD7OYiCAxJbJWb9e14jJD559pgDljk75CBskCeB+avzqc1zYQZzS4CRHwUFVCwLR/f5gPLtJm9/ajbgO1lxOksXUuoraZZ318ebdjHHaEKLQtrcTMlYQgzBm+VfCabMN6nNp380R4Lyo3ZqTPdyJk9Qivgtcaznl8e44MEa4ylUWoPIMoTmftA1fWTSS+WD4d4Ri2WNsUV62yw/qm/Y0pB3jzyhm2QvmsMo3U0j579SMNtJScwUTDjbpEj2U/1K7pFdziHEzmCmL4rE7LF9XcddWDzwFaI+9mQqIs196XXpr8baeD9x74wRSLQ5R7kxyAM4FCLI9PcToHYjT2+zbXRpJBEokQh673sOzhH2lxCbrQfLDMUscSXzQe7C/KuqxT9Kcib8FdhDJPcTc7YyYUICyvoHDPNAePz02qpEcBJpYFPXdsNQnIT+H290PGftpABjYdRPgE64qzM2LIJlx9bBgh05/MCYiRjuECFl/0wIgR48cO42tWl8Fg5yTp0+oxlenus
 o9hGTNam
 87sBREhPGlIvqPuSKIMsKonq6vQyiVg2gf8oRYMcf8+eN5bydQVC23ESSVAnCcoD1LLAtjVfZyL2sHSMqT8vPxbc0iT6O/anSwP/5FFn/wbfSO5PEnDPsMHRKvyMcpEFNj3aGHhqkYHNTptMS2SReSysYxRWqoO4jwAyvhes9HvJhFC6QzswRGqUKAZE/CY8agnT46vA7EhUPAc6WdGUh2aI0FR1/93B/Mf9fdoIdMHIiPbsC8EbtdSt1pOcZvoKVzNTu0sCQb8U+kkt/NE5uxTxO/ELGj9QVNVF38qozxqpv4mfaVsaA2NlLzd8QhZwDxT/UMONuz56FCimsa3Gu85YP/5Cqg1F+MXtt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 4:35 AM, Borislav Petkov wrote:
> On Mon, Aug 03, 2026 at 03:09:29PM +0800, Li Zhe wrote:
>> Tested in a VM with a 100 GB fsdax namespace device configured with
>> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
>> server.
>>
>> Test procedure:
>> Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
>> initialization time from the pr_debug() output of
>> memmap_init_zone_device().
>>
>> With memcpy_nontemporal() used by the ZONE_DEVICE template-copy path:
>>    Average of rebinds for nd_pmem driver: 150.83 ms
>>    Average of rebinds for dax_pmem driver: 153.55 ms
>>
>> With this x86 fixed-size fastpath patch applied:
>>    Average of rebinds for nd_pmem driver: 96.79 ms
>>    Average of rebinds for dax_pmem driver: 119.04 ms
>>
>> This further reduces the average memmap initialization time measured
>> during rebind by about 35.8% for nd_pmem and 22.5% for dax_pmem.
> Testing methodology doesn't usually belong in the commit message but under the
> "---" lines below but this is important enough to keep it here.
>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   arch/x86/include/asm/string_64.h | 56 +++++++++++++++++++++++++++++++-
>>   1 file changed, 55 insertions(+), 1 deletion(-)
> A quick and untested cleanup ontop with the potential for a bunch more
> unification. But later.
>
> Note that you're inconsistent about the "memory" clobber. The current code
> doesn't have it, you're adding it to movnti_8(). I've added it now everywhere
> to be on the safe side - it would be interesting to know whether you see any
> perf difference with and without it in your use case.
>
> Thx.


Thanks, I will fold the cleaned-up version into v10.

I also tested the memcpy_flushcache() fixed-size path with and without
the "memory" clobber. In this build, the generated assembly for this
path is the same in both cases.

I also ran the ZONE_DEVICE rebind test with both variants. The difference
was below 1% for both nd_pmem and dax_pmem, with no stable direction, so
I do not see a measurable performance difference from the "memory"
clobber in this use case.

Given that, I will keep the clobber for consistency and safety.

Thanks,
Zhe

>
> ---
> diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
> index bc6a9f34b346..3a1e1f17431b 100644
> --- a/arch/x86/include/asm/string_64.h
> +++ b/arch/x86/include/asm/string_64.h
> @@ -83,6 +83,14 @@ int strcmp(const char *cs, const char *ct);
>   #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
>   void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
>   
> +static __always_inline void movnti_4(void *dst, const void *src)
> +{
> +	asm volatile("movntil %1, %0"
> +		     : "=m"(*(u32 *)dst)
> +		     : "r"(*(u32 *)src)
> +		     : "memory");
> +}
> +
>   static __always_inline void movnti_8(void *dst, const void *src)
>   {
>   	asm volatile("movntiq %1, %0"
> @@ -112,47 +120,26 @@ static __always_inline void movnti_64(void *dst, const void *src)
>   static __always_inline void memcpy_flushcache(void *dst, const void *src,
>   					      size_t cnt)
>   {
> -	if (__builtin_constant_p(cnt)) {
> -		switch (cnt) {
> -			case 4:
> -				asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
> -				return;
> -			case 8:
> -				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
> -				return;
> -			case 16:
> -				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
> -				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
> -				return;
> -			/*
> -			 * The relevant fixed-size copies here are the
> -			 * x86_64 struct page sizes: 64, 80, and 96 bytes.
> -			 * Keep 32-byte and 48-byte copies inline as well
> -			 * instead of sending those nearby fixed-size
> -			 * cases back to __memcpy_flushcache().
> -			 */
> -			case 32:
> -				movnti_32(dst, src);
> -				return;
> -			case 48:
> -				movnti_32(dst, src);
> -				movnti_16(dst + 32, src + 32);
> -				return;
> -			case 64:
> -				movnti_64(dst, src);
> -				return;
> -			case 80:
> -				movnti_64(dst, src);
> -				movnti_16(dst + 64, src + 64);
> -				return;
> -			case 96:
> -				movnti_64(dst, src);
> -				movnti_32(dst + 64, src + 64);
> -				return;
> -		}
> +	if (!__builtin_constant_p(cnt))
> +		return __memcpy_flushcache(dst, src, cnt);
> +
> +	/*
> +	 * The relevant fixed-size copies here are the x86_64 struct page sizes:
> +	 * 64, 80, and 96 bytes. Keep 32-byte and 48-byte copies inline as well
> +	 * instead of sending those nearby fixed-size cases back to
> +	 * __memcpy_flushcache().
> +	 */
> +	switch (cnt) {
> +	case 4:  movnti_4(dst, src); break;
> +	case 8:	 movnti_8(dst, src); break;
> +	case 16: movnti_16(dst, src); break;
> +	case 32: movnti_32(dst, src); break;
> +	case 48: movnti_32(dst, src); movnti_16(dst + 32, src + 32); break;
> +	case 64: movnti_64(dst, src); break;
> +	case 80: movnti_64(dst, src); movnti_16(dst + 64, src + 64); break;
> +	case 96: movnti_64(dst, src); movnti_32(dst + 64, src + 64); break;
> +	default: __memcpy_flushcache(dst, src, cnt); break;
>   	}
> -
> -	__memcpy_flushcache(dst, src, cnt);
>   }
>   
>   #define memcpy_nontemporal memcpy_nontemporal

