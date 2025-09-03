Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74922CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CBD18E0002; Wed,  3 Sep 2025 04:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C5B8E0001; Wed,  3 Sep 2025 04:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A888E0002; Wed,  3 Sep 2025 04:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB408E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:41:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D92A1140587
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:41:34 +0000 (UTC)
X-FDA: 83847295308.14.0068CF1
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3F80C000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:41:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fn2jjB9s;
	spf=pass (imf28.hostedemail.com: domain of glider@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756888893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/+sjUPKzzeyDNJhhYPMVRz16X6YZ4H6NdmqB+0gdRo=;
	b=zl00loH4PjZJJCiUp0LQ+cTDTypOAbzW+4jkh0PJnXJXreVG4LqrY4l6kpvaEBlisbK7xv
	5+MXBIN40dEoSGv3QApBO47HAF6/AE9I8pI9W8UcjOfSHGspovtY1bz0hL6Yj9ro2olxBj
	d0iiF9vcFfaClSFkENlMXnCFbcYGj0c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fn2jjB9s;
	spf=pass (imf28.hostedemail.com: domain of glider@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756888893; a=rsa-sha256;
	cv=none;
	b=f1aZjbgWllOPCBWVo6fnSfS7WpxrF+Bm0mzFLhge8T9Rc9VPWcW6TXTi2HsjWOezlAXnCJ
	OFa1MfXfZYM93gv3X/YW/KuecaQhH0PQ/KWq0gAcsDePpDw76Wt1FcCbYuszOZJqJ8Rh7H
	Neml/wf1FWb1aZbTfUrgXITPzofItdU=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-70ddd2e61d9so67786746d6.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756888892; x=1757493692; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q/+sjUPKzzeyDNJhhYPMVRz16X6YZ4H6NdmqB+0gdRo=;
        b=fn2jjB9sDQetKgvA4Qbxg3K2gnjqE9eQffYBroOp2G+uK8v8QYffWC+yan4JR7upQJ
         DuUavb/vnQvlNibQZjG4CHUjwUTdkRMfTVy3e7QKyLsJsQEh3VNY7kdLT1EH4OMYmKmO
         54DmuY1NkX9CQU/1t1La5vtcHOgZ3BMMo0R53YhkkTtlS3TyiH2EMbdgH7083WMeuhMK
         afI7ywquYyM8m/lGY2UNj+34JZDbMXzz3N5vyR6UwEnKsDhSP2KaNfW4A0vhQ8c0Cpaa
         F5smsU7xFv8ZlXow4uMlKZRIOpbUixLumQZaJ+9VN4efnr3ymxvkfIBSNdFbZgkndyzK
         dwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756888892; x=1757493692;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q/+sjUPKzzeyDNJhhYPMVRz16X6YZ4H6NdmqB+0gdRo=;
        b=KGhROftMlchbA4e+NlbN06swvJWLYxGi/PW97F1Oaex6cBru3W7gsZtaDfI9RoSRUi
         TqyTgnF4IINScRNyBAfOSgclLlCnWzIBuKV5RtnWkOsx+MGNqJ6oXFrAt8VBII5ULXL6
         reJ+GrD48W5hlAY6dJJoOTncHXNWjfxs10X/a+XctRco20wnukFCbtg8QDdzzUj7acpz
         KfeGUG7MYfYqIU0m5lkEJOSylnxwUYpii+mUYcACmaCdY7KFYmXIQahhnM1XGycqIPvM
         iZJx/96HNWbppWJryQ8cDWxG1/YJdYXh7WqgybRygzK+QzstrDBXtuBCt/NxDv9CYtZJ
         pQmA==
X-Forwarded-Encrypted: i=1; AJvYcCUzyhpr1Uja/sXqA3H2BsoAQ4c7lEJ3HE8uagIDNkmFQNV6AIaz0fccsF/tqz5ycHqaRcwXCGZIHQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8x5GKDZvkQia7xF6Xr61QOcHiMJ3xQxOIJEH3GmxtbE9kAg84
	JDrDXc9s58XVj5zUE8G6WSl9KcQmLJL3Y8fADxbJ8lA7PESwsJcW6YEtSj98LYAr5jXJwKIyVYX
	Qesf0Y940FSytTYFjfZF9lk5OSE6/UCHpWKX//A5r
X-Gm-Gg: ASbGnculFSfpyrNY8zKMICzc++x0hy5QM3uPjCMIUapW310uw3nQPTuTfS2dQDdDWpq
	MgSZSWyOab+EGAMkU0WJ5sq8TPjxf7uJ/50dmSJuwxbDwQ7zLSTfnHqs0BtMbUBp6omppTNEetm
	si/KRms6kyQtHwVpaHcEbg+5TPrFjPR/Q1FVQNslu6mfs35TMMivhMzLudolZ0+W5J4GXSwCgce
	SSqPKnCs9pGlYPl9BiIMmU68g6ODngMrsvrtoOND9g=
X-Google-Smtp-Source: AGHT+IF4vmfJfHqBQxZcNttdrfTYxkvTiSAKs+ul8tcs9Dnds2dX1cmh7ADC/k+xZJ11x/E266a48LBXxeBGRHRjSoc=
X-Received: by 2002:a05:6214:400c:b0:70d:fd01:992d with SMTP id
 6a1803df08f44-70fac73d452mr164331216d6.16.1756888891694; Wed, 03 Sep 2025
 01:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 3 Sep 2025 10:40:55 +0200
X-Gm-Features: Ac12FXwvjV2R_1nfj-fpPxtTM3Ef-lrf13TD6fJR0T0JxJ4IOXBIbC7rd81mwII
Message-ID: <CAG_fn=XWr1_Qvzqq3_dUm-3DjpCFxBz7SbYaW8OMZ1BohjVYDA@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 2/7] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yxdiehet8ngqojpshrdxagp5xfupgdm5
X-Rspam-User: 
X-Rspamd-Queue-Id: F3F80C000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756888892-242756
X-HE-Meta: U2FsdGVkX19+zp8RNBLFP1V4fY1LMq+Sfec68urvgfJt3ErPiHYmnWzAwnHpUfWo+eQBmSquzROemawOhtGSFSezjIsBB7J56OlxoNLL3LdcnwlIhYt33k3V+jnHKCRXSUUkFUhk8o4luJzLZaJ9a/PApgCkuwIyyORcfCEkw5WjtePftFJ4sQOu6sWeUJexISHeP7Dapvvzk4kM+Bdzt0M+q5za6TDZQrvuk49aionwF6LqrlKdUSlxhOARaCk7FKRhNKPyLxKbLugdKHLLFhJIy7ImIohR3yg5EsTFVaxIwFieplGOaLwhaGYeoAyMFa1+25E9ctpYe1fDzBmA2c7Xol6A5Stw/NY47XMJo992MsyymhAmLFChBxOAMzmaS/SVD/9OuDY4yxWlKxOYXHAo25yr4OPwKYi6xVoZou99F1z9CG901XgXKQFZvhHlRx+tO3pIWcU6HUOOZBSgNJLpYJR5ZiDbfetG0tyx72ihvteBRba+8mEBexhjgBjbXBP9OF17G8OZRoAElMpDqy0AjYDGDUyFD+UeHbf55DtL1wq4srXpDWhtLbPSc9UvkreLOAilfre1rXuksxSAcDFNB9CyZB0LowbBdBiR3RHIhzHvfhtVT/xBgLD/ef7Xi0/BAPECUwckSWbeYIVYQl15vGCuwIbGt1g49H8o8gkX3auKf740x2cQ5hM4QFawFBzufjOTAjzETe83uvcToO4PjfG7Fj7v/Etc3T9LzWhOupYX6wKAsMj/pE11qYiAG0l0qRvusv11pj4BJUq65ZV/UnEDUpeoDHRAOJxneZxwymLvIiXZmzVByCttlEUxxSvAWhPCRmG2puAnnSzXmJZBpCP4Z1AfiYm+QcNpyxWUJDhnwRyM9ObirV24Ac4EK31REpq3pnWvALqMxzE/Fxh/jUk+EzSfh8BSBGhSmqKtpst/aizy2ToS2kZe+w5lerZl+HqiO40DDkCgUAq
 RktW2dxf
 yfPre2FC8uIkwI4XPSxQaGxVS8U3OjQh6jAxhH+XhE5XOaSPLQT0uReBNQ9IrudEqjlhzYpJ4xt7S/+FJgjSMxXwP5tfNGqCdCjRkXBBe/8Haqh6/xnQoKZ9kNs0KFkF2m8II2yOVZYWw98bWyBdLrf3Nw1+aeY3X8bVgqbPlQ+jUj7Kq2yWu3EgutV61D7DQFUWphgpF70nnu8mlMnzSNvE3S4xwLQ0QLn/YvhLrU3+x6LtkuM5I6JWEvH0c4yu/AIDEMJ8aL8RrNC4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -112,6 +112,26 @@ ASSERT(__relocate_kernel_end - __relocate_kernel_start <= KEXEC_CONTROL_CODE_MAX
>  #else
>  #define KEXEC_RELOCATE_KERNEL
>  #endif
> +
> +#ifdef CONFIG_KFUZZTEST
> +#define KFUZZTEST_TABLE                                                        \
> +       . = ALIGN(PAGE_SIZE);                                           \
> +       __kfuzztest_targets_start = .;                                  \
> +       KEEP(*(.kfuzztest_target));                                     \
> +       __kfuzztest_targets_end = .;                                    \
> +       . = ALIGN(PAGE_SIZE);                                           \
> +       __kfuzztest_constraints_start = .;                              \
> +       KEEP(*(.kfuzztest_constraint));                                 \
> +       __kfuzztest_constraints_end = .;                                \
> +       . = ALIGN(PAGE_SIZE);                                           \
> +       __kfuzztest_annotations_start = .;                              \
> +       KEEP(*(.kfuzztest_annotation));                                 \
> +       __kfuzztest_annotations_end = .;
> +
> +#else /* CONFIG_KFUZZTEST */
> +#define KFUZZTEST_TABLE
> +#endif /* CONFIG_KFUZZTEST */

I think the definition of KFUZZTEST_TABLE should better be in
include/asm-generic/vmlinux.lds.h, so that it can be used by other
architectures.

> + * KFuzzTest receives its input from userspace as a single binary blob. This
> + * format allows for the serialization of complex, pointer-rich C structures
> + * into a flat buffer that can be safely passed into the kernel. This format
> + * requires only a single copy from userspace into a kenrel buffer, and no

Nit: kernel

> + * further kernel allocations. Pointers are patched internally using a "region"
> + * system where each region corresponds to some pointed-to data.
> + *
> + * Regions should be padded to respect alignment constraints of their underlying
> + * types, and should be followed by at least 8 bytes of padding. These padded
> + * regions are poisoned by KFuzzTest to ensure that KASAN catches OOB accesses.
> + *
> + * The format consists of a prefix and three main components:

Nit: s/prefix/header?

> + * 1. An 8-byte header: Contains KFUZZTEST_MAGIC in the first 4 bytes, and the
> + *     version number in the subsequent 4 bytes. This ensures backwards
> + *     compatibility in the event of future format changes.
> + * 2. A reloc_region_array: Defines the memory layout of the target structure
> + *     by partitioning the payload into logical regions. Each logical region
> + *     should contain the byte representation of the type that it represents,
> + *     including any necessary padding. The region descriptors should be
> + *     ordered by offset ascending.
> + * 3. A reloc_table: Provides "linking" instructions that tell the kernel how
> + *     to patch pointer fields to point to the correct regions. By design,
> + *     the first region (index 0) is passed as input into a FUZZ_TEST.
> + * 4. A Payload: The raw binary data for the structure and its associated
> + *     buffers. This should be aligned to the maximum alignment of all
> + *     regions to satisfy alignment requirements of the input types, but this
> + *     isn't checked by the parser.

Maybe also call it "target structure" here?

> + * For a detailed specification of the binary layout see the full documentation
> + * at: Documentation/dev-tools/kfuzztest.rst
> + */
> +
> +/**
> + * struct reloc_region - single contiguous memory region in the payload
> + *
> + * @offset: The byte offset of this region from the start of the payload, which
> + *     should be aligned to the alignment requirements of the region's
> + *     underlying type.
> + * @size: The size of this region in bytes.
> + */
> +struct reloc_region {
> +       uint32_t offset;
> +       uint32_t size;
> +};
> +
> +/**
> + * struct reloc_region_array - array of regions in an input

Nit: newline here for consistency.


> +#define __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val1, val2, tpe)                                         \
> +       static struct kfuzztest_constraint __constraint_##arg_type##_##field __section(".kfuzztest_constraint") \
> +               __used = {                                                                                      \
> +                       .input_type = "struct " #arg_type,                                                      \
> +                       .field_name = #field,                                                                   \
> +                       .value1 = (uintptr_t)val1,                                                              \
> +                       .value2 = (uintptr_t)val2,                                                              \
> +                       .type = tpe,                                                                            \
> +               }
> +
> +/**
> + * KFUZZTEST_EXPECT_EQ - constrain a field to be equal to a value
> + *
> + * @arg_type: name of the input structure, without the leading "struct ".
> + * @field: some field that is comparable
> + * @val: a value of the same type as @arg_type.@field
> + */
> +#define KFUZZTEST_EXPECT_EQ(arg_type, field, val)                                    \
> +       do {                                                                         \
> +               if (arg->field != val)                                               \
> +                       return;                                                      \
> +               __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_EQ); \

Doesn't the compiler complain about defining __used in the middle of the block?
Maybe move it before the if statement?

> + * KFUZZTEST_EXPECT_NE - constrain a field to be not equal to a value

Nit: you could probably save some space and extract the boilerplate
from KFUZZTEST_EXPECT_XX into a helper macro.

> +config KFUZZTEST
> +       bool "KFuzzTest - enable support for internal fuzz targets"
> +       depends on DEBUG_FS && DEBUG_KERNEL

Given that you only have the sections defined for x86, you should
probably put something like "depends on X86_64" here.
If you go for it, please mention somewhere that the framework is only
available for x86_64, and add "x86:" to the patch title.

An alternative would be to add KFUZZTEST_TABLE to vmlinux.lds.S for
every architecture.

