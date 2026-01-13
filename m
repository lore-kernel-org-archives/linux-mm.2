Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 179B9CF45D4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787446B0005; Mon, 12 Jan 2026 20:21:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DBC6B0088; Mon, 12 Jan 2026 20:21:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649D46B008A; Mon, 12 Jan 2026 20:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 514666B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:21:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBC025F20F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:21:22 +0000 (UTC)
X-FDA: 84325187604.15.E5A088E
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5F5DA0008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:21:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yp0taafs;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768267281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0/waOmhHsYmDL/6HVvoGGIYHZETE02HxsKl6ODkF3o=;
	b=Ro0fQhN5QvW5fW6HkLrd0RAT1vI7Ub+dLug2mY171adAkKz+PnDDpxGy3dknz2liEdPziA
	1lNOwFj3eQyrLexYj0cDZjlgfkBumfKYY13sMHw0oC/ZxIr4zjUitAlqRXiWKu3VzJOMG8
	nblivoBt2bW8PIaJg4GuRhV5tpEAvsU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yp0taafs;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768267281; a=rsa-sha256;
	cv=none;
	b=WBrtJnOxGcuEDgFInE5uuuvU0OjciCdDW16q2r6ZuUl7gJ3Wbffo/XwTZ4D/JJbuzRMwUy
	LMHK4WmVoE/w5y16fU1t6pMV8nXBxf5SIGroZLG3081xDD56TsvUKowgvTnaYA5tLBZhEt
	bvYjMLeBiBJ++uyLlwgVHFngXQtIJhw=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fb4eeb482so4016023f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768267279; x=1768872079; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0/waOmhHsYmDL/6HVvoGGIYHZETE02HxsKl6ODkF3o=;
        b=Yp0taafsLMuYFiSgMZr9mhC5d1+mzHNFi/uWDjzUUS2S0oLbzzWm8hhFDeZJ7lRYeI
         InVk6MNlflA1z+FluMYk2N6wuUstCuT2DeJk+bqKZulUNNkJXMqx/AYmHoyBtBicJpbr
         XcD8wzhvXhsZH8pCpmy6pfwPGQf9sd4RG3K2+gYa2SWspAuOd0ZiGsw5eV5Zs/r530CB
         DQjpJJtBEHHA4S1XOvxNLrHkx7+Sp9Zqn2DfCycYWZRpsof2uAoRrDqvMHeicJMJ5Z36
         /Z8BCDUlBYA71Gw6dfjTOBTEZhZ689rGeEWXj9ZHWmuWIVa9+SRuBgHoNwT3Cqf6T3jd
         VR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768267279; x=1768872079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e0/waOmhHsYmDL/6HVvoGGIYHZETE02HxsKl6ODkF3o=;
        b=hm6gqmcwGRD20iUC3EZgVz2E+38qFhOiFbwDVC+/KV8ZFdHfY3RJs76okU844yJCA8
         1UufLUtfzsh66LDvtyOMi7pfJiUigtX6JKqMlgCrzSSgtAiuF/+6Etv+UEub3gx/XAXv
         VMBgsfOfWqVe+oMZrvKOc2VP6fA7D9Z7iNwqbjT/dnANGI6a1i6Y2Rpi+gm6+ThoLEQj
         6ngoND5WFQ+JOEFFGzfe5tCSmAMnfJv00EXBn11YxQUrf9ngpIatu/7dqjNxno8DwphJ
         L4FCL+dewP8hr4WPK9pQgAOsuqgOrbrT/PywSHoMaDnqqGwSc5lR3qoORGwtDVJ481SF
         Ultw==
X-Forwarded-Encrypted: i=1; AJvYcCVgWuO4uJYoom1z54pOkG/PnAfwLo+u7F4HVEU7S/FXebDZeA4hZqyWEFZBoXkbG9YaEBz6r1J91A==@kvack.org
X-Gm-Message-State: AOJu0YwLb8rY6uNMBCcaKTGY1IF5uswMmwqHIdCFzexXbIp21o/1Y2lp
	V4lq38zD4JpUGvt7s2J5oOZwjfW8bbyAfOt8B8MvPFKtfsIRE+5PjP7H4niepyQeHPe3dsWyybr
	kTMTITaFfzLWdhXugyhc9zVsANQ1XKPA=
X-Gm-Gg: AY/fxX7yQd2AHU+qTzH/0OmSyxntYARkyLaRsJA2aW0d6qB9cV5P14brv7aBDF2m2PY
	xQ8Lffzi5oI22MLemvxUFEnpZPKH0vO+iaTlzBOWzXhoAc1gOPDto88WyQFwc2ta+PtBJojo7Gv
	bOkK05DQm66GTnnsQaYBzTtYaczMrkDaNwkDYoaEOMJe2+k5rsdhnw3LlLeJEa4sOGhpsVVMWrw
	MUVZhtdD+vHWLsVp27VU2vFsyStfi8fmN893bQYx8cdu4TNMpFLTFhZY/NPFnWLyaMmYnrNfQ+e
	wyK22f0lr+LzS3J/l1zuMOYmA9ge7A==
X-Google-Smtp-Source: AGHT+IHsdWkVlnLMRuujPEk8fgbaYFpMbhMzj3K/n8eLf4/IDQ0QT15xIzF9mO5xWMxwZF/FWLtnbiYQFvFN5vQd7J4=
X-Received: by 2002:a05:6000:26ca:b0:431:808:2d60 with SMTP id
 ffacd0b85a97d-432c3629aebmr24541037f8f.12.1768267278856; Mon, 12 Jan 2026
 17:21:18 -0800 (PST)
MIME-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me> <be136bf8d1a6ae9ef98686c3ba0b6a4e2ea2e780.1768233085.git.m.wieczorretman@pm.me>
In-Reply-To: <be136bf8d1a6ae9ef98686c3ba0b6a4e2ea2e780.1768233085.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 13 Jan 2026 02:21:07 +0100
X-Gm-Features: AZwV_QjCoIAxOzPZYukp_TYwCHn5QSJvAWN-Df89pT1TOcJPzRbvNO1VkRAILAE
Message-ID: <CA+fCnZfQmhSyF9vh3RzreY7zrQ4GbQOp5NbA0bXLHUMG6p28QQ@mail.gmail.com>
Subject: Re: [PATCH v8 02/14] kasan: arm64: x86: Make special tags arch specific
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Samuel Holland <samuel.holland@sifive.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kumjijyr35b14speffcwzstaqhw5jkzp
X-Rspam-User: 
X-Rspamd-Queue-Id: D5F5DA0008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768267280-12424
X-HE-Meta: U2FsdGVkX1+z4ijODmL1Q13oG1qa0ABbfZkyDTkauI6q+sZfx8iupxGQuYlLY2+ZX0J9WZ5AZv77aYa+GXLlBqMBg/dm5dqhllVBfe0eIoWXjOzBey35dbW2aDqSKqlcJprS0bMKuLgJtgvgLWg1KkopqSl0lV4MWGcQAPDHUmfmoDyRIP5GRs+Q9P7uFC/pzxeDtIlxb53CYPT91wpzW6WhPkA0CTAPEsdhWUEaEZHqJwIZMHvOikjJwuULvxI5ozU9W1tWjBqY0HY0C35BBY4Y3279hluUCOR3tlmAFwU9tsRJTdTWgLxwFu8Z3+GefioPbt4dXi2VCjlIMUCW9CE+VJca4cTA7bKi6et8ROLGYAwyfYW5GOIZJ/i/m0myPbvGOwS8DZdhMudBzpOLZiF//r3pCvVmKoqDteJvWrjLzdQ0ZZ7PMBDUp6hLNNQ/QjcNNxIptSIDe25UGYxP2F/vaUIb0oPSUs2g61SmyBVXn3IBacNLqntjDvbge6Y0gXID0BNwkBtQqeerdzgCP8ylIbYhqB/hkN26042ZC8f2cJH0wUeXKVxWhS/8+JlnO2FgSgIOi+MfbgC/ckkpeObmcD1vXRzUUIEuGqffRIg+NqFKj8wu54fS50m0mg+PBkyIJOJRUZL6mSGFtHx91Ncoe23TEAd2HM43GCFYzwiTeUumXnqkTMylzF82bZYZ79Y9+GJdWokX+7CSTz9oixwjL04/AVDAil2eBMuAga1fdL+qaA2lIYptXEoSBuiuY2A2joKRj+1QcB5BqeEKyg1SPgaerFFBLmhZnQyKqKVsIPMSKXuW7J1gdxDDhZ4uu5qmy7cyF6oxYRUG4zgFsT9AI5UxyRE/rmaMwyE0DKFdncKh/+GLAfQBMNDmTKD99Znj4xYN9tCuR1WnhL8i82w14e4aq6aU0X0DnLxNy71l+qX1OspqW1p7XsOp/Ys5MEdoQt755qyST/BNdYy
 8zEUuZpv
 Gyc1Lbn8YD6Scq/vAeT/AYX3raIQphvXZEz89sciMqSrfybXhmZIWNk5XKzVqjV6lso5JRE19WZbQ2bopNcHAuCRtxxx4N0omjzmR2sAvJ3yfFF9aSRptsSiAgPRlHMfZBigbBghNfgaG7dTCbu2TUXfB+UR7clk0Q356kcpjkKEM2vhpCsmuJCypRaVQwsSIQs5+/6xDcdAyEIqMKt/gbdUvdqzvqf27NBRRkzn11QpZrSUsQqCzrXVIPduezmIREiCo2I+xSb20n7fFzRCVIrwz/dQF9/QBf+5Vw7+5kpSVGHGA9bpNLzzvBysQJ64McKLTVAFE1d/6hfDPJ2AOghxehFCS2ynWRGZUmnZIB7PS833cdizI/QZ0UcSTUiHNzA7HhJNavrhwv2VfOvuufNRCunNbiaX350BqICJm1eAxhL06npr48YQvv7fzF9N/apoR10TMMcO9oda+LMyPwrvp2jGK3mPhevDNchSlPLNnPcxygr/IbThIz4zBj9ZfbbDwEnVVNvPuHLzzQLqAaoig65QK1Uks8B9D+X/ETH8fhEQVia68AsYsWut1K8REPo/aSb78yidvPW1CavafxSSBW3EEdy3pfXrp86uthpPLQf0=
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
> From: Samuel Holland <samuel.holland@sifive.com>
>
> KASAN's tag-based mode defines multiple special tag values. They're
> reserved for:
> - Native kernel value. On arm64 it's 0xFF and it causes an early return
>   in the tag checking function.
> - Invalid value. 0xFE marks an area as freed / unallocated. It's also
>   the value that is used to initialize regions of shadow memory.
> - Min and max values. 0xFD is the highest value that can be randomly
>   generated for a new tag. 0 is the minimal value with the exception of
>   arm64's hardware mode where it is equal to 0xF0.
>
> Metadata macro is also defined:
> - Tag width equal to 8.
>
> Tag-based mode on x86 is going to use 4 bit wide tags so all the above
> values need to be changed accordingly.
>
> Make tag width and native kernel tag arch specific for x86 and arm64.
>
> Base the invalid tag value and the max value on the native kernel tag
> since they follow the same pattern on both mentioned architectures.
>
> Also generalize KASAN_SHADOW_INIT and 0xff used in various
> page_kasan_tag* helpers.
>
> Give KASAN_TAG_MIN the default value of zero, and move the special value
> for hw_tags arm64 to its arch specific kasan-tags.h.
>
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Acked-by: Will Deacon <will@kernel.org> (for the arm part)
> ---
> Changelog v7:
> - Reorder defines of arm64 tag width to prevent redefinition warnings.
> - Remove KASAN_TAG_MASK so it's only defined in mmzone.h (Andrey
>   Konovalov)
> - Merge the 'support tag widths less than 8 bits' with this patch since
>   they do similar things and overwrite each other. (Alexander)
>
> Changelog v6:
> - Add hardware tags KASAN_TAG_WIDTH value to the arm64 arch file.
> - Keep KASAN_TAG_MASK in the mmzone.h.
> - Remove ifndef from KASAN_SHADOW_INIT.
>
> Changelog v5:
> - Move KASAN_TAG_MIN to the arm64 kasan-tags.h for the hardware KASAN
>   mode case.
>
> Changelog v4:
> - Move KASAN_TAG_MASK to kasan-tags.h.
>
> Changelog v2:
> - Remove risc-v from the patch.
>
>  MAINTAINERS                         |  2 +-
>  arch/arm64/include/asm/kasan-tags.h | 14 ++++++++++++++
>  arch/arm64/include/asm/kasan.h      |  2 --
>  arch/arm64/include/asm/uaccess.h    |  1 +
>  arch/x86/include/asm/kasan-tags.h   |  9 +++++++++
>  include/linux/kasan-tags.h          | 19 ++++++++++++++-----
>  include/linux/kasan.h               |  3 +--
>  include/linux/mm.h                  |  6 +++---
>  include/linux/page-flags-layout.h   |  9 +--------
>  9 files changed, 44 insertions(+), 21 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kasan-tags.h
>  create mode 100644 arch/x86/include/asm/kasan-tags.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0d044a58cbfe..84fdf497a97c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13581,7 +13581,7 @@ L:      kasan-dev@googlegroups.com
>  S:     Maintained
>  B:     https://bugzilla.kernel.org/buglist.cgi?component=3DSanitizers&pr=
oduct=3DMemory%20Management
>  F:     Documentation/dev-tools/kasan.rst
> -F:     arch/*/include/asm/*kasan.h
> +F:     arch/*/include/asm/*kasan*.h
>  F:     arch/*/mm/kasan_init*
>  F:     include/linux/kasan*.h
>  F:     lib/Kconfig.kasan
> diff --git a/arch/arm64/include/asm/kasan-tags.h b/arch/arm64/include/asm=
/kasan-tags.h
> new file mode 100644
> index 000000000000..259952677443
> --- /dev/null
> +++ b/arch/arm64/include/asm/kasan-tags.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_KASAN_TAGS_H
> +#define __ASM_KASAN_TAGS_H
> +
> +#define KASAN_TAG_KERNEL       0xFF /* native kernel pointers tag */
> +
> +#ifdef CONFIG_KASAN_HW_TAGS
> +#define KASAN_TAG_MIN          0xF0 /* minimum value for random tags */
> +#define KASAN_TAG_WIDTH                4
> +#else
> +#define KASAN_TAG_WIDTH                8
> +#endif
> +
> +#endif /* ASM_KASAN_TAGS_H */
> diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasa=
n.h
> index b167e9d3da91..fd4a8557d736 100644
> --- a/arch/arm64/include/asm/kasan.h
> +++ b/arch/arm64/include/asm/kasan.h
> @@ -6,8 +6,6 @@
>
>  #include <linux/linkage.h>
>  #include <asm/memory.h>
> -#include <asm/mte-kasan.h>
> -#include <asm/pgtable-types.h>
>
>  #define arch_kasan_set_tag(addr, tag)  __tag_set(addr, tag)
>  #define arch_kasan_reset_tag(addr)     __tag_reset(addr)
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/ua=
ccess.h
> index 6490930deef8..ccd41a39e3a1 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -22,6 +22,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/mmu.h>
>  #include <asm/mte.h>
> +#include <asm/mte-kasan.h>
>  #include <asm/ptrace.h>
>  #include <asm/memory.h>
>  #include <asm/extable.h>
> diff --git a/arch/x86/include/asm/kasan-tags.h b/arch/x86/include/asm/kas=
an-tags.h
> new file mode 100644
> index 000000000000..68ba385bc75c
> --- /dev/null
> +++ b/arch/x86/include/asm/kasan-tags.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_KASAN_TAGS_H
> +#define __ASM_KASAN_TAGS_H
> +
> +#define KASAN_TAG_KERNEL       0xF /* native kernel pointers tag */

One thing that stood out to me here was that for x86, KASAN_TAG_KERNEL
is defined as a 4-bit value (0xF). Which makes sense, as
KASAN_TAG_WIDTH =3D=3D 4.

But for arm64, KASAN_TAG_KERNEL and others are defined as 8-bit values
(0xFF, etc.), even though for HW_TAGS, KASAN_TAG_WIDTH is also =3D=3D 4
and only the lower 4 bits of these values define the tags.

This happens to work out: for HW_TAGS, __tag_set resets the top byte
but then uses the given value as is, so the higher 4 bits gets set to
0xF and the lower set to the tag. And for saving/restoring the tag in
page->flags, everything also works, as we only store the meaningful
lower 4 bits in flags, and restore the higher 0xF when doing ^ 0xFF.

But this is not related to this series: I think the way x86 defines
KASAN_TAG_KERNEL to be 0xF makes sense; we might just need to clean up
the arm64 implementation at some point.

> +
> +#define KASAN_TAG_WIDTH                4
> +
> +#endif /* ASM_KASAN_TAGS_H */
> diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
> index 4f85f562512c..ad5c11950233 100644
> --- a/include/linux/kasan-tags.h
> +++ b/include/linux/kasan-tags.h
> @@ -2,13 +2,22 @@
>  #ifndef _LINUX_KASAN_TAGS_H
>  #define _LINUX_KASAN_TAGS_H
>
> +#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
> +#include <asm/kasan-tags.h>
> +#endif
> +
> +#ifndef KASAN_TAG_WIDTH
> +#define KASAN_TAG_WIDTH                0
> +#endif
> +
> +#ifndef KASAN_TAG_KERNEL
>  #define KASAN_TAG_KERNEL       0xFF /* native kernel pointers tag */
> -#define KASAN_TAG_INVALID      0xFE /* inaccessible memory tag */
> -#define KASAN_TAG_MAX          0xFD /* maximum value for random tags */
> +#endif
> +
> +#define KASAN_TAG_INVALID      (KASAN_TAG_KERNEL - 1) /* inaccessible me=
mory tag */
> +#define KASAN_TAG_MAX          (KASAN_TAG_KERNEL - 2) /* maximum value f=
or random tags */
>
> -#ifdef CONFIG_KASAN_HW_TAGS
> -#define KASAN_TAG_MIN          0xF0 /* minimum value for random tags */
> -#else
> +#ifndef KASAN_TAG_MIN
>  #define KASAN_TAG_MIN          0x00 /* minimum value for random tags */
>  #endif
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 0f65e88cc3f6..1c7acdb5f297 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -40,8 +40,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
>  /* Software KASAN implementations use shadow memory. */
>
>  #ifdef CONFIG_KASAN_SW_TAGS
> -/* This matches KASAN_TAG_INVALID. */
> -#define KASAN_SHADOW_INIT 0xFE
> +#define KASAN_SHADOW_INIT KASAN_TAG_INVALID
>  #else
>  #define KASAN_SHADOW_INIT 0
>  #endif
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6f959d8ca4b4..8ba91f38a794 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1949,7 +1949,7 @@ static inline u8 page_kasan_tag(const struct page *=
page)
>
>         if (kasan_enabled()) {
>                 tag =3D (page->flags.f >> KASAN_TAG_PGSHIFT) & KASAN_TAG_=
MASK;
> -               tag ^=3D 0xff;
> +               tag ^=3D KASAN_TAG_KERNEL;
>         }
>
>         return tag;
> @@ -1962,7 +1962,7 @@ static inline void page_kasan_tag_set(struct page *=
page, u8 tag)
>         if (!kasan_enabled())
>                 return;
>
> -       tag ^=3D 0xff;
> +       tag ^=3D KASAN_TAG_KERNEL;
>         old_flags =3D READ_ONCE(page->flags.f);
>         do {
>                 flags =3D old_flags;
> @@ -1981,7 +1981,7 @@ static inline void page_kasan_tag_reset(struct page=
 *page)
>
>  static inline u8 page_kasan_tag(const struct page *page)
>  {
> -       return 0xff;
> +       return KASAN_TAG_KERNEL;
>  }
>
>  static inline void page_kasan_tag_set(struct page *page, u8 tag) { }
> diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags=
-layout.h
> index 760006b1c480..b2cc4cb870e0 100644
> --- a/include/linux/page-flags-layout.h
> +++ b/include/linux/page-flags-layout.h
> @@ -3,6 +3,7 @@
>  #define PAGE_FLAGS_LAYOUT_H
>
>  #include <linux/numa.h>
> +#include <linux/kasan-tags.h>
>  #include <generated/bounds.h>
>
>  /*
> @@ -72,14 +73,6 @@
>  #define NODE_NOT_IN_PAGE_FLAGS 1
>  #endif
>
> -#if defined(CONFIG_KASAN_SW_TAGS)
> -#define KASAN_TAG_WIDTH 8
> -#elif defined(CONFIG_KASAN_HW_TAGS)
> -#define KASAN_TAG_WIDTH 4
> -#else
> -#define KASAN_TAG_WIDTH 0
> -#endif
> -
>  #ifdef CONFIG_NUMA_BALANCING
>  #define LAST__PID_SHIFT 8
>  #define LAST__PID_MASK  ((1 << LAST__PID_SHIFT)-1)
> --
> 2.52.0
>
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

