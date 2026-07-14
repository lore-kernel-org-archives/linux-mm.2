Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835BDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F4E6B0005; Tue, 14 Jul 2026 05:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3291E6B0088; Tue, 14 Jul 2026 05:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3BE6B008A; Tue, 14 Jul 2026 05:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E08506B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:24:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66C3FA02F1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:24:37 +0000 (UTC)
X-FDA: 84986846994.20.EDC7160
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id D635E20009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:24:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c1vqSLt7;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5hVbWmSdqOj3dZyKgFalHXz2yWT1XoIB2Yzua6Nbdg=;
	b=MLxRjugMKVlWNaHCCNTsb/lpqHxP6nYy4uHVlbmhzEbT+n4cRI6lMSkyxgxUqIgkaHDi+y
	BsmDeFM7EcHGYjmNRnRCPu1yRsSwXEEkreuye77x1s9bFemZEQePZkIhXE6Y4pAecBq4Mu
	Ah9SsspBPyrb4LWZcDBZUZxUAt2pFdo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c1vqSLt7;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784021075;
	b=uAn1LquTxt3NneO83fE6XkNMhifjZDenwX3blx+zqZDLVsbEPJrPodWdYGJtJRP83ZdbZ7
	ah5zAuLuaANSK8nioRTSYqXl+SWh9b0yTUpuA35pz7l6yoOwbTPM/J4HrMfzdfoVOFgaMU
	foxRY2q63N7LL20VPtWkg+f78UekAt0=
Message-ID: <7bfb13a0-8f4a-4f4b-9df4-da842169f8f1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784021072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e5hVbWmSdqOj3dZyKgFalHXz2yWT1XoIB2Yzua6Nbdg=;
	b=c1vqSLt7YpRFDe2umMN3RExEnZnsJ+Y62WB5Cqnqs4LFBiYnVCK1S7k4r+DG46NqwyT+jo
	rXth3VEv29BtauCCiBfDvRWZ4gxMd1r2Irwis0JtMD2c3IhnXOrtyT6uofDsp8Wy5HUCHI
	T7FTDTnEjCFXCWSd1OgEjrANW97a/2s=
Date: Tue, 14 Jul 2026 17:24:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 6/8] string: introduce memcpy_nt() helpers
To: Li Zhe <lizhe.67@bytedance.com>
Cc: linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com,
 david@kernel.org, kees@kernel.org, mingo@redhat.com, rppt@kernel.org,
 tglx@kernel.org
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
 <20260709112520.24857-7-lizhe.67@bytedance.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260709112520.24857-7-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D635E20009
X-Stat-Signature: podjhei8ktm8dxwhfe4hwnxu7bqhs3bd
X-HE-Tag: 1784021074-566175
X-HE-Meta: U2FsdGVkX1/U+f7Gf4xh6NHdxoje8p7+g5gcH4NvQpcs4a4PhyuYwHNwvaX3mop5XW+ywsZ8NtvPaAayY/q/sJlhiMNTLq8G806YfMGh3ia5LuzWb9Y6wH0oONIypKJPkrhnFxtxItOH1CSR30NCjERRe8Kv6tVWAQpBB/3Ut/rmPrH8od9klf4LMaUfj331JTPiWw0//bxd3uSxkdmd4CVKqU3/xLRF+YV+R/otuq8FmUH+CiomH09cU+g8GEB8FwqXxdercggMHLXrLmaFvruZkWpCutik5Cz13iBRvcRmJCnZA5HJve5l+XI5IjyCKais+b34E3fGIDpPHMcBZ3FxfgZdiMv75H+mFuo4Bc8UErXi9aC0sa91Qs//Cd0TpIYY3vohYKwhYqowQRNv/qO0jXjk3FjVdTiMXaoj0TEOlztCa7vuGF0osrOfM3Lcjf2KoAXIAboUYV7QZdp7JTPZwVb28qi538OAFCS/cXHSNn/AFI6Zn9eGOJnhwUOcMVQE2HiDaIdWtHwfJdYDLtP1fuSbWSQUS3wcv5xuYPqKwysxEwFePMh58weoTMp2Ik9ZQD49P6i0j4YLswU6c7GhZeuU7gOoEvFOfEgKZCoPjQ0NRYf3XDfAQidNVO8Jqs93bgKpcn7gbqFEw/mgAeHXobBDsCPnyOwXIIIQwiJKfdTSf8ReBcT0q7oLL1W33cfR7EXQ3Qk3nhS6xee8sBKnfD8v0y51R91w0Ii9DPC98uA2Ku8tdbvhI0xNv638b5d6ffC16gs4zb0+wAqegBYxLnH6lvrDFdSCrtO5jb10yNQ+OyTmMFxgqmNjaMHIWEAZFq3gtwitW+QiWY92lASfHBvetSKEEPztQ96+enW79Qyzkhdg56C9ENy2+abZ+45iZUnpmzIo7a6fHnF/XvTLJF/6YMnca7G4O0Xa0LfdjsqyG7buy1TC1wCSJ548NWRRo10SZduFplOoCZN
 NAEZasyz
 m1iHeGo0AU5jNFoUT7xo7TWzdiK6j5weKGD2tc7sdo41T8xWMht2wS4nzReN0qi4/mx02TW+EaoLZ4RCT/GkJ7QrSzAzwnCUY3D9AybhfiytXQ9BTRBz23fvZjUZd5m2kOoifCxC1GV18xIoEvgQv+rTre7pkzpkiwq9OwBomkun+6kFkrbmoykt84nXyurEbI3TeRzcc2UssheoMf+7HSet7lEDl79AmuWMjQw6JwSKUxiI2XQB/4zflTzEtz+An3ChMXq0D+2agPkg0KZUHRzmQ9jv/jrqu5QNA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/9 19:25, Li Zhe wrote:
> Introduce memcpy_nt() and memcpy_nt_drain() for write-once copy sites
> that want a named non-temporal copy primitive plus an explicit drain
> step.
>
> On x86_64, override both helpers in arch/x86/include/asm/string_64.h
> using the usual self-macro pattern, next to the existing
> memcpy_flushcache() backend that memcpy_nt() wraps. The x86_64
> implementation maps memcpy_nt() to memcpy_flushcache() and uses wmb()
> for memcpy_nt_drain(), because that backend issues MOVNTI stores and
> callers need an ordering point before later normal stores that depend
> on those writes becoming visible.
>
> include/linux/string.h provides the generic fallback under
> memcpy_nt() as plain memcpy() and leaves memcpy_nt_drain() empty, so
> architectures that do not override memcpy_nt() do not pay an
> unconditional barrier. Architectures that later grow a specialized
> memcpy_nt() backend can override memcpy_nt_drain() with whatever
> drain primitive their memory-ordering rules require.
>
> The immediate user is the ZONE_DEVICE template-copy path. It populates
> struct page descriptors in a write-once pattern, so a regular cached
> memcpy() can incur avoidable write-allocate traffic and cache
> pollution for data with little near-term reuse.
>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>   arch/x86/include/asm/string_64.h | 22 ++++++++++++++++++++++
>   include/linux/string.h           | 23 +++++++++++++++++++++++
>   2 files changed, 45 insertions(+)
>
> diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
> index 4635616863f5..6cb9e0ac7fa0 100644
> --- a/arch/x86/include/asm/string_64.h
> +++ b/arch/x86/include/asm/string_64.h
> @@ -4,6 +4,7 @@
>
>   #ifdef __KERNEL__
>   #include <linux/jump_label.h>
> +#include <asm/barrier.h>
>
>   /* Written 2002 by Andi Kleen */
>
> @@ -100,6 +101,27 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
>   	}
>   	__memcpy_flushcache(dst, src, cnt);
>   }
> +
> +#define memcpy_nt memcpy_nt
> +/*
> + * Reuse the existing x86 flushcache backend as the nt copy primitive.
> + * Callers pair it with memcpy_nt_drain() when later stores must be
> + * ordered after the copy.
> + */
> +static __always_inline void memcpy_nt(void *dst, const void *src, size_t cnt)
> +{
> +	memcpy_flushcache(dst, src, cnt);

Why not use memcpy_flushcache() directly in device dax path? I don't
understand the necessity of introducing memcpy_nt here.

> +}
> +
> +#define memcpy_nt_drain memcpy_nt_drain
> +static __always_inline void memcpy_nt_drain(void)
> +{
> +	/*
> +	 * Order the prior MOVNTI stores issued by memcpy_flushcache()
> +	 * before later normal stores.
> +	 */

I also have a question here: why are we using wmb to guarantee visibility
at this stage?

Since we are still in the very early phases of memory initialization 
(specifically,
struct page initialization), since we are still in an intermediate 
initialization
state, this shouldn't be visible to other CPUs anyway.

Thanks.

> +	wmb();
> +}
>   #endif
>
>   #endif /* __KERNEL__ */
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 5702daca4326..a109b2f86ca6 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -278,6 +278,29 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
>   }
>   #endif
>
> +#ifndef memcpy_nt
> +/*
> + * memcpy_nt() requests a non-temporal copy when the architecture has a
> + * suitable backend. Architectures that do not override it fall back to
> + * memcpy().
> + */
> +static inline void memcpy_nt(void *dst, const void *src, size_t cnt)
> +{
> +	memcpy(dst, src, cnt);
> +}
> +#endif
> +
> +#ifndef memcpy_nt_drain
> +/*
> + * Callers use memcpy_nt_drain() before later normal stores that need to
> + * be ordered after memcpy_nt(). Architectures without a specialized
> + * backend can leave it empty.
> + */
> +static inline void memcpy_nt_drain(void)
> +{
> +}
> +#endif
> +
>   void *memchr_inv(const void *s, int c, size_t n);
>   char *strreplace(char *str, char old, char new);
>
> --
> 2.20.1
>


