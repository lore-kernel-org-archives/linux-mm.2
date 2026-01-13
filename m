Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC4DCF45C6
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A916B0088; Mon, 12 Jan 2026 20:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BCC6B008A; Mon, 12 Jan 2026 20:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9852E6B008C; Mon, 12 Jan 2026 20:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 879C16B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:21:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 222DC1AFBC3
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:21:30 +0000 (UTC)
X-FDA: 84325187940.21.3A97823
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 213E7140007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:21:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YxpLQ1nP;
	spf=pass (imf23.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768267288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B49RRc+uw/7CnjkDBtwFzIn6uJK+tMPJfHRkdXOkfA0=;
	b=2cMX6e5JFRi0zIJr+gvsSfTi2ZijS3uLNEwYjOvDLd5HFw6zzYUpTR2qMFu2xlrUhtSKFN
	nu5dqhJ+hxfFoIH5v+UIKFSGVhgRgvGe1rIzbgRBLdQ2N9uS2VnL2dh3uR7YToT3IDo+VY
	n+gssDYx1aNfNvnc6OTgUyOTk4g47nA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768267288; a=rsa-sha256;
	cv=none;
	b=c5vR/uUCh7daUvbRf8r2O94FMgjeQApNPHt0dK+JzumSKw2qOlOjeYFMlkbDrsZc8PGmtp
	aDBEv0G4/LBgZLPAwZq8oXm5ToGSO6tKi4wzZjiulK3r5dno8zzRwV6UAJpHv+NGaq0KqW
	LEDs8i7/q97UrFJnPzILFZYx1uVAABQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YxpLQ1nP;
	spf=pass (imf23.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-432d2c7a8b9so3485687f8f.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768267287; x=1768872087; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B49RRc+uw/7CnjkDBtwFzIn6uJK+tMPJfHRkdXOkfA0=;
        b=YxpLQ1nPqnN0HToP3muyoywCD/wnHlvooXUetKjqI2HzYziKyDnHDzUM1pzotVyryZ
         xT6T3BRcaaTcEr/sJpti71NjNDhfK0PpYUFK6bbw4RmVVWJaPngHycNGGBxnB3rEfEN4
         eR7hoeISOLdKQrwnMLVvny2sUVo+i50hbWBkxQWOXAU2jwS99BrFtnXVgaOs/KkmrbYg
         GGKTY7gFz8Rj36MYi+R0v+WfSd4P225EEG5XgN+FWsFE7AYwAhmbHwTSfZkjzrT5xlJ2
         kc5qbV7mzlcMyPQmxEYTbG8GIGZZvyp74AA3YI/bVpMOFpeaDK8ucVnSnZJYRvnRTf0x
         BPdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768267287; x=1768872087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B49RRc+uw/7CnjkDBtwFzIn6uJK+tMPJfHRkdXOkfA0=;
        b=o0pm41eNWHMQHNYgeY7BuqVnd73a8XdIn2Kv+Zo9KJS+Qd9oIZrBanAdnMby46sdfu
         MVHfu6V3uxVqfFMcF3WJT8ZYIOakPTeTQLABaQ0EDwpdz0vTpohjPPUJxirbeFtKRMaN
         BNPYI5GkUDCrZVSk2GL3jG+WNNLnZzIPIJn7/QIUME8PY7lj033ZsyVDgUgkoBDTAsEu
         Be2yKi4AUmW8JTk16PW199V05piGGB+w5z/wEBNB/19zywysOHOz5Q/1QhQhmAloAQat
         WdZKsKGpLcmWSfxGJv7K4P2GEiOnftPsYTctL3vD++rzcVNuAfuGos7QKB0v3I5/BzZF
         nvQw==
X-Forwarded-Encrypted: i=1; AJvYcCXc7fT8nHC4KY+vh3Ttejj0/gHjxORX7ZZVJzcMtPhI0iSgh29g21Sa9tqZXQ44/cPIshrlgMWQhw==@kvack.org
X-Gm-Message-State: AOJu0Yx3cmG2fV6kDUUeqz7PRXkrwXBcLWaViKAIiJYbk50Unvi3h4RT
	g9L+AVd59kP+IDVIL++BgfFxCv7OUWjJaKOIaWRH2/oaGA+kdOpevfZcQFshlHXY7fRSI31YtoM
	8ZcUVgrqI1Hot1HZyoHEXz26cT8tp/5I=
X-Gm-Gg: AY/fxX5w6l0OXkXTsPZMKUGm19fStKQpl9uyAlRgLvi2LpPHgkkCCICWv9BxSy2x39Y
	q8ZKtluVvQVCCb87J5F27M6+diy/CA889aSyi/eqRdPFENRNUAiutV7XIAE/ffxkkbgNncoJa8L
	yBSmNpQBkjEwS/qpUBvJFfFY2sx+se+f39paI6GyqdXWuWHy8S8DS5nOObYRiNWaPPDVhsHQWDO
	tG1I+2FHK7mzFmMKeVKHcF/q9uVwPrGW0F9pxTWsUKYdngTSP13RM3SPkTXO83hQbfWbYIHVTZe
	Ducb/kjPN6TktFceemPz+1rzi8wZag==
X-Google-Smtp-Source: AGHT+IG/YkOc5YnWvAPGfda+l1w/aTKCehhDoJkCZM8lMkYuU79k28dPTosGFxBDqdZ6IxqVyqazi7euAg7b/g7/Kgo=
X-Received: by 2002:a05:6000:2882:b0:431:907:f308 with SMTP id
 ffacd0b85a97d-432c37a375cmr23160903f8f.61.1768267286471; Mon, 12 Jan 2026
 17:21:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me> <785eb728e2cc897e05ee709d42214172be481ab9.1768233085.git.m.wieczorretman@pm.me>
In-Reply-To: <785eb728e2cc897e05ee709d42214172be481ab9.1768233085.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 13 Jan 2026 02:21:15 +0100
X-Gm-Features: AZwV_QgNCKYV65kMyu0l_dWwfZe-OUyCZiqTrFscvNfb1KMt_cAloyWYmxxC2zI
Message-ID: <CA+fCnZdTDzruwLA2MdE=+5KQC5VKMEjm49Z5ez-dDO27y4GORw@mail.gmail.com>
Subject: Re: [PATCH v8 04/14] x86/kasan: Add arch specific kasan functions
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 213E7140007
X-Rspam-User: 
X-Stat-Signature: 5bipphfpi3gn8dfefjcor7p97sw5rue4
X-HE-Tag: 1768267287-922139
X-HE-Meta: U2FsdGVkX190W9kom5pCHKN1b0dCD2aNjFv261ZmURLhfR/42pe2OJCmYxJir/7qG6TvY/R5VwLZtVjVjfmwxs/WTCpwuUhB4fymV1eXh+pz2VuE3ToXO9vNggkoGyazqwbsdhHbgf3C95A6PvN8RF5tWoGUsEE7VWdApykixIRxT/XF9xOpBSFjzQVPx6qXoj/s+7LvyhEnu/r1E3caHbZrrPz6cWQ0hyWr6ecK2ASLugSbupeiCSpkX6M7S3KSAn7LDggogJ4gBBLdAR1ai3NxQjF6ca1Zz7oRQQqY1iO6OQ5f1N84fqqVJCsxt0b6nLah7Big83izy6Tlmd3A4tqrUrC/L3VliK1yPQJ2YiynGok+oegTIHicbD7NiWe1Lqks1Iu55yY/7vy7cpO81n/9y1TgVev8CJ+/vDkILyovXsfTznBom5zw+NfOMVGmNSIW7ZI9YouyF/QYT0hjXGoglxXRQbh8T/jYkMMEYhUC88VYss4nRyM9VwffB0MVGYUFDQVSKZ0lS3qlx7m/N+7vfNeJ05huEe61LxNAFQ4gmPvqxYuBP3zhs7rC8a8CprqPaZ/g4tVsuvSWYwSVg0H8HfWhkYFNkMTIbq7ODYHskB1KWTug1awoyPdi5fFmHXTAlWIXaj6I6BbczYrRjzNgHOMIj0JxzqaynB+hdLvd1GUQ8UodP+17C+lDwSLq5BvRzIdqaDi9QwqYgOQx02ghKmZfEeDzCWaZ6etQrJQsRIfAI0RkjIrZsZ6XJPGbTF4FNsKRCTMOq3I6GsXmWOEcuVpQSjZ3bV/hpDAJLkXqFzN999Y4QsQq35upHDn4aRWUvvUIbeJbk5vqC/kj+ZxLxo0dGupxw38w4/Ru/0uWq6DTH4DCN/ZnLt4d7LS4hI2u9VLlRKQGX8kGrz/co7Yk/Q7HKtAV6UvH0WGogPLE55to+emh3AMD/37wO9vUqWkTezGGPX64AVGY5mC
 uxaC2lQk
 QRnHAkAWHUELgP/FRhn3sUk+y9pMtph8uZvl4lZVFxE9aFZq0Ryia6aspa2BK0dZAkC6BZjl8r7vx0l1xmMxcabFOklbMohlKo8q5JR65ABaeqNXEFnyS+RKvHLEKanbvTD6dDq8ljG9qiXG/ek/RhUr0ju1J96IaB+Lz65daLQ1xw8AxAAmqMSN6hZsvT4na9HMjwjvICG5RVtkcSbJLwUkxUMhzMNftX3VhiIaqjF7EVMBU3kYv211dpC70UW6oPJopbvZVJBlRhmijyOZ5rcd6MjI8KKgamnf7zTmfiwkLtdz/rrsxvw9XwFiY3JbI+3ha5G9FuDR82z35dGpCtGdcP6Dr+5b999TIhG0qaZw8F2xxYIQs2T0kxyvdO4uoS5tdVh51VyU73bJKlcQvJ6MBHfdTbQQFhO4S8LkUeU4Qc4PdcpwWRRbbQdtxR3Yw0Rv0U41E0epx8roupWlJiwP26F5Zm/SyRBV8UfqrX6Dk2Pw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 6:27=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
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
> Changelog v7:
> - Add KASAN_TAG_BYTE_MASK to avoid circular includes and avoid removing
>   KASAN_TAG_MASK from mmzone.h.
> - Remove Andrey's Acked-by tag.
>
> Changelog v6:
> - Remove empty line after ifdef CONFIG_KASAN_SW_TAGS
> - Add ifdef 64 bit to avoid problems in vdso32.
> - Add Andrey's Acked-by tag.
>
> Changelog v4:
> - Rewrite __tag_set() without pointless casts and make it more readable.
>
> Changelog v3:
> - Reorder functions so that __tag_*() etc are above the
>   arch_kasan_*() ones.
> - Remove CONFIG_KASAN condition from __tag_set()
>
>  arch/x86/include/asm/kasan.h | 42 ++++++++++++++++++++++++++++++++++--
>  include/linux/kasan-tags.h   |  2 ++
>  include/linux/mmzone.h       |  2 +-
>  3 files changed, 43 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
> index d7e33c7f096b..eab12527ed7f 100644
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
> @@ -24,8 +26,43 @@
>                                                   KASAN_SHADOW_SCALE_SHIF=
T)))
>
>  #ifndef __ASSEMBLER__
> +#include <linux/bitops.h>
> +#include <linux/bitfield.h>
> +#include <linux/bits.h>
> +
> +#ifdef CONFIG_KASAN_SW_TAGS
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
> +#ifdef CONFIG_64BIT
> +static inline void *__tag_set(const void *__addr, u8 tag)
> +{
> +       u64 addr =3D (u64)__addr;
> +
> +       addr &=3D ~__tag_shifted(KASAN_TAG_BYTE_MASK);
> +       addr |=3D __tag_shifted(tag & KASAN_TAG_BYTE_MASK);
> +
> +       return (void *)addr;
> +}
> +#else
> +static inline void *__tag_set(void *__addr, u8 tag)
> +{
> +       return __addr;
> +}
> +#endif
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
> @@ -34,8 +71,9 @@ static inline void kasan_early_init(void) { }
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
> diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
> index ad5c11950233..e4f26bec3673 100644
> --- a/include/linux/kasan-tags.h
> +++ b/include/linux/kasan-tags.h
> @@ -10,6 +10,8 @@
>  #define KASAN_TAG_WIDTH                0
>  #endif
>
> +#define KASAN_TAG_BYTE_MASK    ((1UL << KASAN_TAG_WIDTH) - 1)

How about KASAN_TAG_BITS_MASK?

When KASAN_TAG_WIDTH =3D=3D 4, the mask does not cover a whole byte.


> +
>  #ifndef KASAN_TAG_KERNEL
>  #define KASAN_TAG_KERNEL       0xFF /* native kernel pointers tag */
>  #endif
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 75ef7c9f9307..3839052121d4 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1177,7 +1177,7 @@ static inline bool zone_is_empty(const struct zone =
*zone)
>  #define NODES_MASK             ((1UL << NODES_WIDTH) - 1)
>  #define SECTIONS_MASK          ((1UL << SECTIONS_WIDTH) - 1)
>  #define LAST_CPUPID_MASK       ((1UL << LAST_CPUPID_SHIFT) - 1)
> -#define KASAN_TAG_MASK         ((1UL << KASAN_TAG_WIDTH) - 1)
> +#define KASAN_TAG_MASK         KASAN_TAG_BYTE_MASK
>  #define ZONEID_MASK            ((1UL << ZONEID_SHIFT) - 1)
>
>  static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
> --
> 2.52.0
>
>

