Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A121D1951B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 21:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133AA6B0088; Mon, 26 Jan 2026 16:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1626B0089; Mon, 26 Jan 2026 16:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBC56B008A; Mon, 26 Jan 2026 16:56:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC15E6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:56:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7621F1A08DC
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:56:27 +0000 (UTC)
X-FDA: 84375474414.24.21ED87D
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC5961C0010
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:56:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BSiYdvqI;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769464585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lrUOAhghPwzKg1J5j2JXzrncTINsAcnCOvL8lgOY0s=;
	b=YwBiFZyJ7SB+pJAobCWi1rXeqCn+y3dtOAiAN5mpPjaxBeAlhc0rgGLJMhTe5V0geuQnhI
	ZeEJG2WXKXy5O1fae3yXqIpQWzvjBD4wQfAssZu7naHi4IY/Cj8qer1RSu9BoIVPW958Qd
	mxIvFNQXqODijhp2IdMCv2aVyIWmIMY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BSiYdvqI;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769464585; a=rsa-sha256;
	cv=none;
	b=7PMH6UZQSwI2lA2hJn+hYAsQ+3ZsSKQO1eUHTGQKX2MkBY2Us5DrQf2Y7sbI227yWQoyco
	UI+FrzyIyNUg6u0UNlumFF2skPv7IhJR/0WDefOQjAFb0bfEqftXrniGccjP+J2RBJUns9
	+M2Sf/RpGfGZfr9Rrsuc8IeOMtx0/3U=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-12336c0a8b6so812836c88.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1769464584; x=1770069384; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8lrUOAhghPwzKg1J5j2JXzrncTINsAcnCOvL8lgOY0s=;
        b=BSiYdvqIu6Cyb1Sxm6Y8TnErUHiXI6Rkuqyn5oukE0NF7bQtDuNMtrtHNTTPoT5srD
         KcsEFkh2qvkQ+D+YxoMY5RJwUpugw3/Qv2cpvewxcOJJeyh4CTsyexJpp86prEpf4RnT
         oG5IhqH4xRl0KEuf8drsVU3K7sTq2X9E/zOwjclge0vtcAd3e5V1H1FdNR63pluyjyly
         VJmw15/3tCkTqYS8XzM1SJ2InHc4i/snNmSPhH45UUZjj4FOsTFcDo1mbopDdRXwcAdq
         DU4d6w2Bq3bbRmn3RM+ISRN0YXgmIvAgQIYe2xkpk4knelgh/0HyM0/TLBXXbYewuE6G
         ni7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769464584; x=1770069384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8lrUOAhghPwzKg1J5j2JXzrncTINsAcnCOvL8lgOY0s=;
        b=VCXgLcst7p6LYaipKLJGJC5/EZSmp4yBv3oJMvhS+iTSpeBK7mQKDs9C4oPw0+ScJ9
         UsKrbudoQnS0u91/Ia4PN4rBC18SvA3xN+AAo29B1j7KJtQ7SEC5QvqR82MXK15p6qR9
         AyLpynEqHEUtk1ZyoIdgjSjRu9OIf6I8YSg6NhqvxnMSoaku43gAMd9atuZCkRkObDAj
         rA2BCZZyrrKUAFLi959UuXkOH8arK0puyJDeZJQGhY8VH0ZK/gslSMZxlkSGnIT4hUcL
         V1sbytRNqEdYjDxXaOfKvicqFpQsyvvOd5+1MVJ6x1n2XHXkXwvYCzNBrPfU/H7c4xmQ
         npdw==
X-Forwarded-Encrypted: i=1; AJvYcCXP8913qb75VLjcsWHA+cEDEEn/PgvcdQvCPtPum6F74gWZnDUp0Ne/XdWWNb3Plzg8HFicaYg/rA==@kvack.org
X-Gm-Message-State: AOJu0YyXw2iFDD1TVlK4B83myEfSYrg3jW78auAZnzgWOR9l06K7MmgJ
	wqp6X3i9BX4ikjae7924lFOv1m796zbOdJ5S3k/JDOFj192VUDcEtBocrpCix5jziL8=
X-Gm-Gg: AZuq6aJ7uErK70SsZMJjbRt4etKoBqWTD8+qz7gaH6vSi+ycmwfUJeLx4PXmQMrzfQE
	3hpN6yKM8lUjPHIibIB9YK5gS+Qk7E0uUef1heTm8OQoOH3S6rCre+xqmPvmNI9+NcYHiQ4pKm4
	JYmp7rpwxuaWqdNXk/3b/tL+by1Po2f3YS0XuONoXjfbPw6RkmVvdBmdhBgfPDZ+m+ONB7arSWS
	xWI3vaok7hllLDOwsbTQyaSgGNRqnDJy4Z47JC9hfb16xgcTAXpJiugOV8suPXC2SjTHhIYZPWY
	wvzvdP4zkxpVS6JJZQV6eI7cdGJ1ilpWSy3CDT7OW034G5Wb3tNaA2+7S9ad2ibwt+tdl7DbV/K
	NYrxB32DOElhfJ5dCS8Nqwi3KKNsa8HUJ6Mz0TsMTZa1jNgnZdTE/WFx5uP1s374jFYUMx1zgQv
	+lX3AvPC5q1HrvL+VERy++
X-Received: by 2002:a05:7022:2510:b0:11d:fd26:234e with SMTP id a92af1059eb24-1248ec01e46mr2897894c88.16.1769464584287;
        Mon, 26 Jan 2026 13:56:24 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1247d90cd61sm22036468c88.3.2026.01.26.13.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 13:56:23 -0800 (PST)
Date: Mon, 26 Jan 2026 13:56:21 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: Paul Walmsley <pjw@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
	alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>,
	Valentin Haudiquet <valentin.haudiquet@canonical.com>
Subject: Re: [PATCH v26 01/28] mm: VM_SHADOW_STACK definition for riscv
Message-ID: <aXfjBd7eCE3ypUnf@debug.ba.rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
 <20251211-v5_user_cfi_series-v26-1-f0f419e81ac0@rivosinc.com>
 <68e1702e-f803-2db2-0e16-53ecef4d9eb6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <68e1702e-f803-2db2-0e16-53ecef4d9eb6@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC5961C0010
X-Stat-Signature: k73sejjnixj3kdacrde1nyj8qzw87uka
X-Rspam-User: 
X-HE-Tag: 1769464585-830273
X-HE-Meta: U2FsdGVkX18abwVjdmZRq9wZe+dcwrnW8KFwgAYEI/NwxCTu5akn++B7oDJKFzNN4OaWaMZQs1SgGj1/sTrd7WwZdT/luUvqYKO2ntTbhqgIph4t/hqcNSG2azZ/eQyBCVR7dOOk4O5s+ITRqdbE3OfsvWFzs93gv63xOn0o3bM/qOmVKprI8TWuhDlWUHJQmjgIKWmVPfu1LCVpm2W5p9XEaSIXslsXZMxMY7QpWxsvAXMBj62HSyzLS6eK9258CNNnCHksqiz3u5TVZPnETPZ6AcFPH6WKYmHCt0BkcOEGSFs5F6mRqvaltIELOH/oRDuVxQJpRp8r3T9FjL6BFrZqaEyjOOu1SzqRgn8ypjx24rcVJg5VL7qIHEoSTILsVF53Q0qNQfJQC9sPIWibYD8xahxe1n5PhZwe2GBMg3mlI8HspiiJ21G8zpW7sPvjUYpBuboaMSB8H+IMKJBisyNzbAN4SZIOBt68IbF4+XqapGqvdKKRF2Zr3Iu9/v3LbOE09S9atthhceSdYMxaQ3ns0Qwv3CYEwl+cfiR9KhXJv9LhjeTO6x65wnc7A2Zy2ldjnK6c7ms0xxtvyJ4xcfqwxbBFFDEMUIdkviHjpPPVwgKS6aPL+uyU0zfGQWVtm4QyNgCkKjegRGu6A1rib6OBEPQu5p9jME6dEFU1H0XmDd7KM4/sxJ6uqOKHUSAm6bF6JFQkRf9j2Ck+q7l3n1zPfW2j0l6UmaRVecZSYmPaMVZpwjW+qP1k/5u84hG8GoMp0xR7PRZIbbXBBX1a5eXDnGycfBUHurj7YnKp3KMO+X6B5mmRVGm8aNB0osmxKxHm7Zap4HbZn8CEEgpaxHYMOfaWlGxT/Q25O6alKRjmFdD+vuQ/HWzKZG+qc++auti1kBXJeIi3oO8z4TejTKt7IgXvz7RWAIdylL/tC2CKO+WzJFGRdz2V5JS7/GgTOhPXD3kJ88VF+AEQ76M
 Cruy2je9
 lk7iUKRMX0bRX5PghSgf3YZyh3woArclzaLxgoLHQrMkk7kTEm8hBXfk7Ggu95kUsXEYugGbccT0yZ8u1/plAi6l8iafKk3LcZxH++YRrErqdQ3M719tZ6dej5t/h5dGMcVMQraRfxgN+MHh+fIiAVBHwUJeIY10X3tTf9P18YLk2kpkHw4fhCqdB8i+JqQuJnAQp4iiPJD0hDFoathGFrz7up8Q+lawNngb1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Paul,

Comment inlne.

On Wed, Jan 14, 2026 at 07:57:19PM -0700, Paul Walmsley wrote:
>On Thu, 11 Dec 2025, Deepak Gupta via B4 Relay wrote:
>
>> From: Deepak Gupta <debug@rivosinc.com>
>>
>> VM_HIGH_ARCH_5 is used for riscv
>>
>> Reviewed-by: Zong Li <zong.li@sifive.com>
>> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
>> Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>
>Here's what I'm planning to queue, after updating it after Lorenzo's mm
>changes.  Please let me know if you want to change anything.

Yes looks good to me. Thanks a lot.

>
>
>- Paul
>
>From: Deepak Gupta <debug@rivosinc.com>
>Date: Wed, 19 Nov 2025 09:55:05 -0700
>
>mm: add VM_SHADOW_STACK definition for riscv
>
>VM_HIGH_ARCH_5 is used for riscv.
>
>Reviewed-by: Zong Li <zong.li@sifive.com>
>Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de> # QEMU, custom CVA6
>Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
>Link: https://patch.msgid.link/20251112-v5_user_cfi_series-v23-1-b55691eacf4f@rivosinc.com
>[pjw@kernel.org: clarify subject; update to apply]
>Signed-off-by: Paul Walmsley <pjw@kernel.org>
>---
> include/linux/mm.h | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/mm.h b/include/linux/mm.h
>index 15076261d0c2..de912272c5f9 100644
>--- a/include/linux/mm.h
>+++ b/include/linux/mm.h
>@@ -359,7 +359,7 @@ enum {
> 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT2, HIGH_ARCH_2),
> 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT3, HIGH_ARCH_3),
> 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT4, HIGH_ARCH_4),
>-#if defined(CONFIG_X86_USER_SHADOW_STACK)
>+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_RISCV_USER_CFI)
> 	/*
> 	 * VM_SHADOW_STACK should not be set with VM_SHARED because of lack of
> 	 * support core mm.
>@@ -460,7 +460,8 @@ enum {
> #define VM_PKEY_BIT4  VM_NONE
> #endif /* CONFIG_ARCH_PKEY_BITS > 4 */
> #endif /* CONFIG_ARCH_HAS_PKEYS */
>-#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_ARM64_GCS)
>+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_ARM64_GCS) || \
>+	defined(CONFIG_RISCV_USER_CFI)
> #define VM_SHADOW_STACK	INIT_VM_FLAG(SHADOW_STACK)
> #else
> #define VM_SHADOW_STACK	VM_NONE
>-- 
>2.51.0
>
>
>
>

