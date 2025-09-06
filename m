Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFBDCA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A5B6B0006; Sat,  6 Sep 2025 13:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04AEB8E0003; Sat,  6 Sep 2025 13:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BF48E0002; Sat,  6 Sep 2025 13:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2F2F6B0006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:17:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 800E61DE80A
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:17:58 +0000 (UTC)
X-FDA: 83859483036.25.72FB7B0
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E908140008
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:17:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hlCaD5Xz;
	spf=pass (imf26.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8m7gNbOiJ7wFumA8eH5KhxcoFHJTBnL28AX35/mxZ5k=;
	b=cxYKePJO1+shwnayVuXLdmuguVSbA/8bgFKeqwVZJq3ClzYm4O/RLQwg1mlN8MA23oZt7Q
	y/Hc+cu9fmA+kpavmwrMyZHch/4xJzuV/dZ0WZQJE5FqQ071vX0MGKGmYVJ9TP2/UQ2KyS
	NQKSdWleRD9gKPjV2NWcFJCTYTT9p3o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hlCaD5Xz;
	spf=pass (imf26.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179076; a=rsa-sha256;
	cv=none;
	b=EkOnuFmMKHFhMtPkUCagZHMHmI/4K0OXD1O0ltSWOgLjgPsthJz89fEA3olVp0lfWzAPbN
	LpPaP058W1TGHwqXHoq/gEIVeRWAnRANvyV6gVZW7fEQcmzJ67kb91Ap1KzUFhW1RKRvrL
	beBHQQc3NyfluhV4Sy7ZWNYN4MFAFd8=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3e537dc30c7so1144786f8f.3
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179075; x=1757783875; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8m7gNbOiJ7wFumA8eH5KhxcoFHJTBnL28AX35/mxZ5k=;
        b=hlCaD5XzhlwFMK2sN0/JLKUixB+1IllhzUfN7viWRhED3/KEtPMTwm0q8BonRE4RH0
         LWVsIjS20wsSMQbbWricgcWXo+WcaDIe/aGkjd+LCBFWSNkPwBNPgqmCyVzljNKZ8Qym
         xY7FWcaGvD9MwK/HKHNpZ9JQ8ulooSASrw6asskhKjZykERi+AORbidCpmjGXLGRJG+Y
         GvQq4lFyr9DfYa0zHsoBP2/jYmfliAa1USFyo+y31xLviejxD8TZ2DIAySvufdEacj2S
         8pDYSmVWoRoz63pUKXOpGr9g8rNC5JOZ9KuuNkTU+efsUzo36FVeffbiKBK3686mapNd
         OTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179075; x=1757783875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8m7gNbOiJ7wFumA8eH5KhxcoFHJTBnL28AX35/mxZ5k=;
        b=gXyEJxcCqKyM1+RQF/vF5RzulKOo//mOpVqRqMC8hlWl41yQl53yDwS2+4tMp7WUyp
         1ZvPRYJvZ5okoiMoBhtl/BcbSEFcp6TgRO8RCzNtfZmO3wZ2L4/4gdbBCCt+2O/esjwx
         XNqhFvbDFa0aisAaUXAkr+C1Hkd9kffMp4wHl+oCJJamXN9MuiyDy4WMoyFuFkIkRNw6
         C+tcvbI5hrrD9fgdgfOBrj/PKojXCIIl5ziOHc2uPq3QJ+xXYXVGPr73hcWXO5fkhFjJ
         8+VlKSNf0W1DeF2hFDLnmhgI9h/D6PEYBJQfT7AhrAPywKCYbs0K/+Mywcv/PXQARuI6
         Tfjw==
X-Forwarded-Encrypted: i=1; AJvYcCUo1NUzgEnOM4fLbNRL4GxnpHoVvzT0kwTpogDxmPFQV4y4ZpcT/iIUdWIlMDT60gxrGI42Maa7Rg==@kvack.org
X-Gm-Message-State: AOJu0YyApf7FEtxO82J5lGWbhczEc3JMbwJeRiu4PJt4Bv/z+BTT8Kpk
	bFTuM1F4sRNymF4W04DN5c0OTVXrlCvU8owKd+019Ud+gbkchEGjQGp4KW1tlsPmFxFLfKm65rE
	A+1SnLWnAvMgHM1+0tnlMSx/0ts6HTBY=
X-Gm-Gg: ASbGncs5tB3OKDtuFExtjKOysesjzf+bjAEKPV3deiBtW6YWr1y3kp1rsy/50Bt+GhX
	+/Ez6+rHF0M9qEWXI49+K0rIyRPMJvHtU9gaMcRKXVRugGEjF/uQP/Ov0HO93OP0+Hv27ZuScrn
	0bvMUvgHLEdOqSON+9RYk4LN/dMXMlIOKM4Lz8L8twrRRN2xVhznHeEr4YbshKXVeN6iSmxqlas
	JQLg0iw
X-Google-Smtp-Source: AGHT+IEVaxv1flhMNQ21ny8HzxKdUksbjU1IsnfWBaLSu+i+o5RQBFuNsHWY/aKwSfi08c9LffaO8ru3O0fOtcOI6wM=
X-Received: by 2002:a5d:5886:0:b0:3e4:64b0:a760 with SMTP id
 ffacd0b85a97d-3e642026e72mr1764739f8f.18.1757179074706; Sat, 06 Sep 2025
 10:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com> <7cb9edae06aeaf8c69013a89f1fd13a9e1531d54.1756151769.git.maciej.wieczor-retman@intel.com>
In-Reply-To: <7cb9edae06aeaf8c69013a89f1fd13a9e1531d54.1756151769.git.maciej.wieczor-retman@intel.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:17:43 +0200
X-Gm-Features: AS18NWAccC9JiiN3oBmxBjTrrK8-6qYxZFkRTV1lkD1J_h60FmCfpfZ83r4hey8
Message-ID: <CA+fCnZd7tM5i5jOriaYyR1GgjgREv0PhyxpFuEC5506FkndzAg@mail.gmail.com>
Subject: Re: [PATCH v5 04/19] x86: Add arch specific kasan functions
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1w3nrhgyyy1oiwdaw9bpycgshf3doxuy
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E908140008
X-Rspamd-Server: rspam05
X-HE-Tag: 1757179076-922393
X-HE-Meta: U2FsdGVkX19u3L7yCBquomtKT8tI/BTlNfd0ENMCk7vsmpU+bfLtQTphkhwOXkpKOWpsqLsoH/bCwJSb7j81LmJCpdRl9mf7+cCmWAdZqDasmur56w5cdejcpfeHC6bUjGxZqunh6MtTebWZLG0sHLkMW4WUnTO5USHtTQ3LjAX/f3v6nl/M8udWUTgok+nSGUjNteTFTs2kiEzWL3uCJtZk/NtYHpJjHYyGxLOiXzIU0cweMWVUuR/xgdK1vkAGg6OMo96L4W5YIcA5/cHjZKHdKey8S8kiseaUzjRlw6d3+DR9qqy+NdXMM0waEJItCYIt/26I8t4F1naNTqr50k9NcQDxH7xTHZd+/Q7m2MEAQFZaQ75YlJ5GIHmbYleN1hhjqdMlWTYOe2FCv7bbdLRGC7sPJvHduGGg0PLroL4sNktkoeCcm0oKw9YuT0yn2ki9QgS4cl60TswgTTDFTV9d7+S0Tz6UjG5oKD/xUcGYRgbGB9f6d/6qKKz48zpsOsZ3i4c+KQPEGnGPRQnSBgeSG90Rdw9m3uncOpGu4uvVdo75JU6frlZ6odLRBJbgsi1fbDE5WUwmWC2cmqrUJiMNutNh4JqZ/DvwixkS4PITscL9KL4EjbptrUGl7kELrSRtaLWhOls8zvoXIL9t5pOdEk5bjSqY8ditHKjg9Wov+DyC+gxMWMeWVcZ4ht8+TDjr+q/s9/92S1EZMgyFpiWcVaGBPXUq9H/la6PtDc2qCOtpvdyiwQP08kctzb6xV31WQ8LitQkNHu74Eym41OmUqo7Gs2O2R6sVJP8Ntoiy/ZROZuIoy2Pgb75QThRZ4C8zCSP404enJ3gCAGUM6uer5IYyj2SZzSYA1nHxeC0Enn2X6jPDUjhI9fsEcVXHrNhKzMWzDT3HEPSCdwobSd/PJ3w8qChU51nUsxjCTOmvkxOJWsKMH5Kwk+qfhEPIPIB/J4NpbjD4v3cnhxt
 NeF/2yZC
 jjbqzsu+lAo3F+0T0xczW2F8UWTWaQ6szWF0tIuF8mavD0fQeZdmEfdIZtlrkpOr2QfWdU9TSCFo4j183dES+JUyt7O3uqGPdVhQTvUFfxV+xi3ccGATT1L5Q/UOgZKxpV3TKkTaPDxl3Hzu4fADX9jHoTP76BwkSsRDQJZlHGshZ5Rlubst2BFlK/8YNBGSfTZPLNuuRWd5kJ+XC8H7XMa8sxGnnU0vKiXVLqzAeCrOqwYOXlIIhTAM6aGlKxl5lD7LYKfKW52etNIF8pwEZPfccJAfbAXjc6jsZFAI+2vJuivVfGYF+nEZ5UOYxUnsdpnSHtLq66xtRP/m9AsisQHHYfBlwDm986kn+tcDq6tN8yEA3jROuPtyB1SUmmaVbVBgrrL/xqrNsz/5gmQgK3ZJ59rrCDGOyy5pwBeRnOHZf6K9zFbOgVNDzlGnP64fnVFza
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:27=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> KASAN's software tag-based mode needs multiple macros/functions to
> handle tag and pointer interactions - to set, retrieve and reset tags
> from the top bits of a pointer.
>
> Mimic functions currently used by arm64 but change the tag's position to
> bits [60:57] in the pointer.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Rewrite __tag_set() without pointless casts and make it more readable.
>
> Changelog v3:
> - Reorder functions so that __tag_*() etc are above the
>   arch_kasan_*() ones.
> - Remove CONFIG_KASAN condition from __tag_set()
>
>  arch/x86/include/asm/kasan.h | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
> index d7e33c7f096b..1963eb2fcff3 100644
> --- a/arch/x86/include/asm/kasan.h
> +++ b/arch/x86/include/asm/kasan.h
> @@ -3,6 +3,8 @@
>  #define _ASM_X86_KASAN_H
>
>  #include <linux/const.h>
> +#include <linux/kasan-tags.h>
> +#include <linux/types.h>
>  #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
>  #define KASAN_SHADOW_SCALE_SHIFT 3
>
> @@ -24,8 +26,37 @@
>                                                   KASAN_SHADOW_SCALE_SHIF=
T)))
>
>  #ifndef __ASSEMBLER__
> +#include <linux/bitops.h>
> +#include <linux/bitfield.h>
> +#include <linux/bits.h>
> +
> +#ifdef CONFIG_KASAN_SW_TAGS
> +

Nit: can remove this empty line.

> +#define __tag_shifted(tag)             FIELD_PREP(GENMASK_ULL(60, 57), t=
ag)
> +#define __tag_reset(addr)              (sign_extend64((u64)(addr), 56))
> +#define __tag_get(addr)                        ((u8)FIELD_GET(GENMASK_UL=
L(60, 57), (u64)addr))
> +#else
> +#define __tag_shifted(tag)             0UL
> +#define __tag_reset(addr)              (addr)
> +#define __tag_get(addr)                        0
> +#endif /* CONFIG_KASAN_SW_TAGS */
> +
> +static inline void *__tag_set(const void *__addr, u8 tag)
> +{
> +       u64 addr =3D (u64)__addr;
> +
> +       addr &=3D ~__tag_shifted(KASAN_TAG_MASK);
> +       addr |=3D __tag_shifted(tag);
> +
> +       return (void *)addr;
> +}
> +
> +#define arch_kasan_set_tag(addr, tag)  __tag_set(addr, tag)
> +#define arch_kasan_reset_tag(addr)     __tag_reset(addr)
> +#define arch_kasan_get_tag(addr)       __tag_get(addr)
>
>  #ifdef CONFIG_KASAN
> +
>  void __init kasan_early_init(void);
>  void __init kasan_init(void);
>  void __init kasan_populate_shadow_for_vaddr(void *va, size_t size, int n=
id);
> @@ -34,8 +65,9 @@ static inline void kasan_early_init(void) { }
>  static inline void kasan_init(void) { }
>  static inline void kasan_populate_shadow_for_vaddr(void *va, size_t size=
,
>                                                    int nid) { }
> -#endif
>
> -#endif
> +#endif /* CONFIG_KASAN */
> +
> +#endif /* __ASSEMBLER__ */
>
>  #endif
> --
> 2.50.1
>

Acked-by: Andrey Konovalov <andreyknvl@gmail.com>

