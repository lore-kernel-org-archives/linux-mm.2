Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D285CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5668E0003; Sat,  6 Sep 2025 13:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5563C8E0002; Sat,  6 Sep 2025 13:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D8A8E0003; Sat,  6 Sep 2025 13:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 273E48E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:18:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD7F159DAC
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:18:47 +0000 (UTC)
X-FDA: 83859485094.30.B3E8BD8
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC6A940004
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:18:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g8J4ojRV;
	spf=pass (imf27.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRcDWNpUUbZTeol9QRv1WeubB1y1xQlfIP4m0Tbtx6c=;
	b=8mUFYXApntjUNYwiYiRfCwBTHAHi9lDpjjfm45sIvQjdZfTwqDJ2RCy/gFn2mCfSGZ+O6d
	hcxHWN7CR2NoJ6CJQJ41YUK9WGXxIujlrCqfVBJ/a4/raZ7iM1m1A6LSNE7pPfO8iSeDs5
	xJPCqh/0p6Zz9U7pE9xGZ7KTleHgraI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179125; a=rsa-sha256;
	cv=none;
	b=bVLZV5iCo3KFH5Og60/kqzKd98zPF+jKbKWYmXjovIKc5GpicWL6Hywt1vQCE7gj+CwPwi
	3kyDMoQhrvK4VmmaU1rqLk7VdGn2k9A9mTrfHIJGdCUfnSf3XjlTUKtyTAwLL6FieJiB7L
	Oy4rVxIftxaG7m0x7Xr1zjiuhLsm+jE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g8J4ojRV;
	spf=pass (imf27.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3df3be0e098so1642670f8f.1
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179124; x=1757783924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRcDWNpUUbZTeol9QRv1WeubB1y1xQlfIP4m0Tbtx6c=;
        b=g8J4ojRV/VkrNKP1CjbCrLdu1qiIAC5dL7+HvZgaZQv+P1axamwCCnNVgtorCjf41Q
         pl/Pk+Pkq3rWP/5sw5kWmNpogLplU4Zg/QCi+K6zOvuPAibhtEjUae/o/VbcVNUDEVkK
         +XSNyJK6d+guF+ho7ZWN36yrggRVuk5i5DOZ2iXvxH8wgVKn1A9LX8Kf/XQnOmNaM08k
         mxR29E9q1ZaaT/LQK++iEsND0bS3NyFDYCV4BFB/HA2ZUEn4mHu7B0FG7JDqe0u57ASg
         qiCqiFmzSYixYrtdvyYyfLw2sESZHiEtiEr8hVh1gHKflCQ+XAGQga2hqeC/TNytPk0s
         1jBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179124; x=1757783924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRcDWNpUUbZTeol9QRv1WeubB1y1xQlfIP4m0Tbtx6c=;
        b=D4zREWTEryopBWuNuHFF1EgefyptbTa43+b3/U+8S5MinnlSthyWEJpOR+wVlCKvK4
         wd96nD7MXwqf5SkG8okgwUFgUhJMQ4Bamvtzq4mHJqzbDG5p4cdDH/n1tgLYSOeOyz5N
         fxW6wbEHe2E7JIenLWFWTJF07BxHvKeBMJsoZu9tkutFhp+zXnvbbK4ZyHroD6p2egRh
         9Tky1eJgBogO3cFWn/rAwEkZoYKhHMImRKOpNB/uTpVJFKBpEt4jHWTdgGDmAMRJInPb
         w17Ys9kVFxxZXsDeYTn1E2qvjFp0/6ykZd6qXcUJxhZRrybM32Zjo4ZFjcWHh/zFL1aS
         wTrg==
X-Forwarded-Encrypted: i=1; AJvYcCV+20Z2loAmBoFhkXIrKBPTArgr/ycZjQcdKHl4zPRWYND1LtQTZzoCPgCdr6bXThDhivZZY4onbw==@kvack.org
X-Gm-Message-State: AOJu0YwwFWOQhjx9ngNJJFSAwl5j4ajq/U65kDfh5MsdqM+5o2mOQCs1
	Ev6uhzhtCt7BnU+3ob19urxNyzODmMY8vLkbfoCCIX65MQ4yat5iDM8AIjpMC7H1m9iZo7CywDR
	zUZX//Ym9MnwOSFmO2b/oslzuJ+i6wxA=
X-Gm-Gg: ASbGncvAkN+cRN+X57aUE2+YTrebOCLyStFhuU0gojxA+xVestyMKryc7yklNElTjYp
	kByCs0QU9midqFBX6RY/KnwWeIVNUaZUbHStE58qSgjjKEtiAYVSTsiLFe6icdg6zF6/oCumSVa
	rruLKAPEy6+4TyXOBOigGkyx+WwjdMqN3D3oYTpws9rXJyw37E1CSFiGTn9HqBjE6NdZtU0WKw2
	inurYVm
X-Google-Smtp-Source: AGHT+IF1jrxuZ+XP2qXXI9FFTf9IlpGFsK20eHmJUUPJ4TKagTjFlAJHX8ijiGVB9qx7MVwBHEBlfwFBXPiejNWY0r8=
X-Received: by 2002:a05:6000:1a86:b0:3d7:cd09:ae1e with SMTP id
 ffacd0b85a97d-3e6425eb1e9mr1335076f8f.17.1757179123944; Sat, 06 Sep 2025
 10:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com> <7a85ceb0918c6b204078e6d479b85fef6a6c1768.1756151769.git.maciej.wieczor-retman@intel.com>
In-Reply-To: <7a85ceb0918c6b204078e6d479b85fef6a6c1768.1756151769.git.maciej.wieczor-retman@intel.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:18:33 +0200
X-Gm-Features: AS18NWA_eEHpTXTQ0knIVmmRfCpxcK6aFKCLGMxVUA2hte0L9DlCgBnRDAv5G6o
Message-ID: <CA+fCnZecdx5QsYcwn6ZyNoOkQRqmonUmSmfiihYTF8Ws_0O9KA@mail.gmail.com>
Subject: Re: [PATCH v5 05/19] kasan: arm64: x86: Make special tags arch specific
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC6A940004
X-Stat-Signature: mjnh8kay156ncnkkbnk6cfipfs4d6xoc
X-HE-Tag: 1757179125-64134
X-HE-Meta: U2FsdGVkX1/U5lN7CYFhua5nLZmdZCEUBzd8sffrU2V8sbJJ5ORFlDrpmneMzWoVxrcgbahe/Q6i488s3MaccHGWN8SeFCijlXn9FGn2dqw8OUV54dWP0yVC72+r5ZuDXbbfF5Sco0GDbfjusoHsN3X3asI8A0vRmRjaLjstGVof6eitLqQ0vn3BtIxIHcT6hlsH+XR8bF10fYK4MSuQr44cgRmvk3gqJEUXM7Wl2E5eqaBznFonmUDOYba8GYPt6uNLfOP0G7ba/wmacsLEwBqhTHzelv19WbHsk0e5mk7BoSwiKp/5tY3Gza37hG4FartOjZJ/MjvTsOg90W3HzrofL0HPnWlNGp7NjTUurPfascfzLSJaNoCqopSMjya6LTYBF9HF2cJiztI0er40zXFTwRgq8/D/y3O0fkDH2cSL5ZEBEh8NA2Sq7Vz4UhaXRSfDymgAyniTCJU5cm4uI3hNs7sINBRiDzoOG8G4MQX2AIJlirm98uQ0vlaOhmLKLDjqmsBYuCQo9rVWBuF2at6atOcMyJQNUfJ/hnMmYoZTN4sfoH5dEBxjHMltCazlRqLtXo8+SMK82oJrjsFsjffJHg5KWTr6ZBE+EH+XPPokQnGPTdibobof4pPow/LyHdFoaEfKgeBD6SRpcHVelPI3lUlxBno/41mCtjaMCH96WStMzvS/zgx5zdpNQAfvZceK5zPOaTbOLtOyFAFKe9UfsoSIFFuM8IHDIu5HVHbS1UeEHOT6rSqFSMVQ9jKtRFpe0vPH5m0ygIN1/Kwugl1317CeojG7QxWZYFkCI0KDSU+hnGrckCwQnPin8FAwFOhhozfBcrt3XfESTMCagpx5fMsnwGrlDAMpp1pHDQTyhNUyUuvGA2TduNVgjPcv/JXhqiOniIYQMPep8+dLgbDiRpm0uNqO6uskEPoI6Y0GKGTW5C//56oojR2Vi4OrQCIHFcFM0OKyfEXIrQZ
 wQuscd8R
 soXXOFM6OjiNN5g7tDXedfCWP6hF07SzBgYDlf1evcgu8az6R7r2N7Op6Ro2s24eyGvKgbFINnCm5X5S/a+xByXeUzARwyqhXGdbN3Q0MrKUrEXXvBLMyETpgH0NB+ApMu+M/sO9yPZLgAuByACvycYBTi6wyCjEYNU47cUQ1yO8GTpIuvIYWADEclcKyqh2qYQRBEJ8SNRFSNOFB2PwnLBMJPbgmoAfWHbXrnLA+IIUNt2msbzAA56fk6RXqtBLE/sS2P1dN0G6okxMqF+qcw/kv6mZwuq4IAAjjEh7MIa+p5Kn9II3RpIizFYIBzydJCkyX/L4AMxMn4sl1QRbOQYspFUJnXsFrHvLbRVbDgX9k7WuHekinhdpAaDkIctT+rDTAi45JjUcIUB6EkNMRN4lfG30f/He2YBJBjuET+eVxlQCR26CkpslyIwzwBnPjdaNFjef/8VokNUK8ieNuN4o+Rwy3GThQpvwMuugZ37uhYO2Td3RL0NekOozvtK6FVBaGfwkaIG3yZCWG611iq3N+TYLaNryPftjAl4TMBriu/EkTl0Thd8wV9g/PhFFrFjA1
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
> KASAN's tag-based mode defines multiple special tag values. They're
> reserved for:
> - Native kernel value. On arm64 it's 0xFF and it causes an early return
>   in the tag checking function.
> - Invalid value. 0xFE marks an area as freed / unallocated. It's also
>   the value that is used to initialize regions of shadow memory.
> - Max value. 0xFD is the highest value that can be randomly generated
>   for a new tag.
>
> Metadata macro is also defined:
> - Tag width equal to 8.
>
> Tag-based mode on x86 is going to use 4 bit wide tags so all the above
> values need to be changed accordingly.
>
> Make native kernel tag arch specific for x86 and arm64.
>
> Replace hardcoded kernel tag value and tag width with macros in KASAN's
> non-arch specific code.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
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
>  arch/arm64/include/asm/kasan-tags.h | 13 +++++++++++++
>  arch/arm64/include/asm/kasan.h      |  4 ----
>  arch/x86/include/asm/kasan-tags.h   |  9 +++++++++
>  include/linux/kasan-tags.h          | 10 +++++++++-
>  include/linux/kasan.h               |  4 +++-
>  include/linux/mm.h                  |  6 +++---
>  include/linux/mmzone.h              |  1 -
>  include/linux/page-flags-layout.h   |  9 +--------
>  9 files changed, 39 insertions(+), 19 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kasan-tags.h
>  create mode 100644 arch/x86/include/asm/kasan-tags.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fed6cd812d79..788532771832 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13176,7 +13176,7 @@ L:      kasan-dev@googlegroups.com
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
> index 000000000000..152465d03508
> --- /dev/null
> +++ b/arch/arm64/include/asm/kasan-tags.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_KASAN_TAGS_H
> +#define __ASM_KASAN_TAGS_H
> +
> +#define KASAN_TAG_KERNEL       0xFF /* native kernel pointers tag */
> +
> +#define KASAN_TAG_WIDTH                8
> +
> +#ifdef CONFIG_KASAN_HW_TAGS
> +#define KASAN_TAG_MIN                  0xF0 /* minimum value for random =
tags */
> +#endif
> +
> +#endif /* ASM_KASAN_TAGS_H */
> diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasa=
n.h
> index 4ab419df8b93..d2841e0fb908 100644
> --- a/arch/arm64/include/asm/kasan.h
> +++ b/arch/arm64/include/asm/kasan.h
> @@ -7,10 +7,6 @@
>  #include <linux/linkage.h>
>  #include <asm/memory.h>
>
> -#ifdef CONFIG_KASAN_HW_TAGS
> -#define KASAN_TAG_MIN                  0xF0 /* minimum value for random =
tags */
> -#endif
> -
>  #define arch_kasan_set_tag(addr, tag)  __tag_set(addr, tag)
>  #define arch_kasan_reset_tag(addr)     __tag_reset(addr)
>  #define arch_kasan_get_tag(addr)       __tag_get(addr)
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
> +
> +#define KASAN_TAG_WIDTH                4
> +
> +#endif /* ASM_KASAN_TAGS_H */
> diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
> index e07c896f95d3..fe80fa8f3315 100644
> --- a/include/linux/kasan-tags.h
> +++ b/include/linux/kasan-tags.h
> @@ -2,7 +2,15 @@
>  #ifndef _LINUX_KASAN_TAGS_H
>  #define _LINUX_KASAN_TAGS_H
>
> -#include <asm/kasan.h>
> +#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
> +#include <asm/kasan-tags.h>
> +#endif
> +
> +#ifndef KASAN_TAG_WIDTH
> +#define KASAN_TAG_WIDTH                0
> +#endif
> +
> +#define KASAN_TAG_MASK         ((1UL << KASAN_TAG_WIDTH) - 1)
>
>  #ifndef KASAN_TAG_KERNEL
>  #define KASAN_TAG_KERNEL       0xFF /* native kernel pointers tag */
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index b396feca714f..54481f8c30c5 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -40,7 +40,9 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
>
>  #ifdef CONFIG_KASAN_SW_TAGS
>  /* This matches KASAN_TAG_INVALID. */
> -#define KASAN_SHADOW_INIT 0xFE
> +#ifndef KASAN_SHADOW_INIT

Do we need this ifndef?

> +#define KASAN_SHADOW_INIT KASAN_TAG_INVALID
> +#endif
>  #else
>  #define KASAN_SHADOW_INIT 0
>  #endif
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..bb494cb1d5af 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1692,7 +1692,7 @@ static inline u8 page_kasan_tag(const struct page *=
page)
>
>         if (kasan_enabled()) {
>                 tag =3D (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MA=
SK;
> -               tag ^=3D 0xff;
> +               tag ^=3D KASAN_TAG_KERNEL;
>         }
>
>         return tag;
> @@ -1705,7 +1705,7 @@ static inline void page_kasan_tag_set(struct page *=
page, u8 tag)
>         if (!kasan_enabled())
>                 return;
>
> -       tag ^=3D 0xff;
> +       tag ^=3D KASAN_TAG_KERNEL;
>         old_flags =3D READ_ONCE(page->flags);
>         do {
>                 flags =3D old_flags;
> @@ -1724,7 +1724,7 @@ static inline void page_kasan_tag_reset(struct page=
 *page)
>
>  static inline u8 page_kasan_tag(const struct page *page)
>  {
> -       return 0xff;
> +       return KASAN_TAG_KERNEL;
>  }
>
>  static inline void page_kasan_tag_set(struct page *page, u8 tag) { }
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 0c5da9141983..c139fb3d862d 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1166,7 +1166,6 @@ static inline bool zone_is_empty(struct zone *zone)
>  #define NODES_MASK             ((1UL << NODES_WIDTH) - 1)
>  #define SECTIONS_MASK          ((1UL << SECTIONS_WIDTH) - 1)
>  #define LAST_CPUPID_MASK       ((1UL << LAST_CPUPID_SHIFT) - 1)
> -#define KASAN_TAG_MASK         ((1UL << KASAN_TAG_WIDTH) - 1)

So we cannot define this here because of include dependencies? Having
this value defined here would look cleaner.

Otherwise, let's add a comment here with a reference to where this
value is defined.

>  #define ZONEID_MASK            ((1UL << ZONEID_SHIFT) - 1)
>
>  static inline enum zone_type page_zonenum(const struct page *page)
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

This case is removed here but not added to arch/arm64/include/asm/kasan-tag=
s.h.


> -#else
> -#define KASAN_TAG_WIDTH 0
> -#endif
> -
>  #ifdef CONFIG_NUMA_BALANCING
>  #define LAST__PID_SHIFT 8
>  #define LAST__PID_MASK  ((1 << LAST__PID_SHIFT)-1)
> --
> 2.50.1
>

