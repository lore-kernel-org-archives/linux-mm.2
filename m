Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F26D3CCA5
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 02:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2C36B0088; Wed, 14 Jan 2026 21:57:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B253E6B0089; Wed, 14 Jan 2026 21:57:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24BD6B008A; Wed, 14 Jan 2026 21:57:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1096B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:57:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 237B41ADA5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:57:26 +0000 (UTC)
X-FDA: 84332687292.22.3D526A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A40F840002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:57:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pM66J1BT;
	spf=pass (imf11.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768445844; a=rsa-sha256;
	cv=none;
	b=4PiKfsQJoD8uKAjyNVHGN13MRyhLqKx+FDvDMsN8AAuheffWMu9Y8rQO45LeYHojBeh8I2
	hXd56+4DVkklAsr8hmT2D7I4n3LjmQm03L0lC5VzcpIf9LwtiUUMFTOny8k18o+cX4OIMK
	P+xCsteHJsyXCFmK2oCHNTKquK1Mcu8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pM66J1BT;
	spf=pass (imf11.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768445844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0wG2Al6MwZJbr8Bc1wy447ZQLYYRXcO+Gdg+WzaG10=;
	b=w15r57kPeCPl1wpbfSzg9YCeFNurHzGglAh3k2q2W4+tRVgDfxrGNjvUCuOLvYvsF/+PAi
	w6DzrGEZkcnTOHbi7M1K+YG3QbK/YwA6BAxRrQUZN/YDJzc8pZfEtswU7t15DMUKH2lBSw
	ktXzdISRJx9TbklM2zm2XW8cphZkmcU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D66D86013D;
	Thu, 15 Jan 2026 02:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B73CC4CEF7;
	Thu, 15 Jan 2026 02:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768445843;
	bh=vZY5zsWBaO65aRDg0tkCt053druTmj76dpqw1tJ3uPM=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=pM66J1BT0I09Nyr/Aavbh2/YXOpVUtzg4+16ZMMkcG/CGlwUiklJ+lVzqZBscIBdU
	 8ONmNeBh29X6tFzTRjYZ67byWpAtquhTNeJf40Gj1cF/3mO+w7aNCDUqUof73dejXu
	 Z0vTCdrQNinKd7int+v6pgxUlZe2ABvJQ2ug74fxQEaBUaVo8+rJV+VuDbIzv9QmH0
	 jqn5ZDnghY8isJPSQrfcHJrleudDgapDvp0PqE5rEKfcPyjARADnPcZ3eAierGTh55
	 wiDpqcriAzAtQ4Ibc9OHIb6pgPIoIKJt9Zg3inBL7ArklI0ilNQB+tIPdwGpWRKbde
	 pny0nDjTkCWUw==
Date: Wed, 14 Jan 2026 19:57:19 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
    Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    Christian Brauner <brauner@kernel.org>, 
    Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
    Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
    Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
    Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
    Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
    Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
    =?ISO-8859-15?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
    Andreas Hindborg <a.hindborg@kernel.org>, 
    Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
    Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
    richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
    kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
    evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
    samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
    rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>, 
    David Hildenbrand <david@redhat.com>, 
    Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
    Valentin Haudiquet <valentin.haudiquet@canonical.com>
Subject: Re: [PATCH v26 01/28] mm: VM_SHADOW_STACK definition for riscv
In-Reply-To: <20251211-v5_user_cfi_series-v26-1-f0f419e81ac0@rivosinc.com>
Message-ID: <68e1702e-f803-2db2-0e16-53ecef4d9eb6@kernel.org>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com> <20251211-v5_user_cfi_series-v26-1-f0f419e81ac0@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: j184gm9srnkzopr4ybbjcrizxjzd4rrx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A40F840002
X-Rspam-User: 
X-HE-Tag: 1768445844-289079
X-HE-Meta: U2FsdGVkX18LFB3P7Fy35pnwJomP6ddzlo2YVBGO3W808hIvPtCu0lhox80E5mVnvTb/jLgEZ0XrNb5j6yObaSDaKBwUegmZnQBSN80D8b2LBMoCBSLsfdwVOGU90eF/7CPHltUXhGtGR57pUC/ZgncQ13tbgWvSrHdNdOlcdGutwK85Wu68R3qZXLi+m/TsNUEcQVCX8fcETFaB7ubpbJKfsPzcNmyhJhSw1pJ6mhtYk4B+12i+b9OQrX20W9/iig/H872fKLbibPnl5LzNRmjW1F0kX1UhsEUHsdIVYD5u/rWupgujoBnAKWbfokCMwQLaY2Ti6TAFIFE1eJxVDPaGf2saqTmqAB7xIl4ZlwSf8cL7LcFmGSZajsFv67VpNL0G87+jZM5CMU0PFhnzotF9p8v/yMRZ/qd8aXku/u03DlV37ONMY1ZbfY/kMULAeO4FeJ58hqZmaTe8v3J4rjMVqGWEYHkN7lrBxA/DDy1oQFXpDgXIJXn87cGaGS1tcVy6Jyx09pnak+9cuQXsRVVlzgRn1/N1uh/axuLu2yG3FsmZSWsQuGb6eJp36qFJvsmTUwWukoLbh01bEF0MCLG8Z72N4oZqIvoWravketzaprZ8rfXseVQN6KizKmOCoTTCtbnhXoPEMXzjrulCpMSqzrVDWqoZo/cp3Q8EbTpgKktxrBjyEA2qFQp8fi8IAJAOhiogcpOG7O8YM4AVSWr5EfsgZEAnj9X47+0bK95SOHfwUVTNV9076X/+us4R3LE9qbMIV92X75t5OmNCpayYQ4EPRJaP6iNLzHXj9bLJaq1BCIIBf9URc3m9bNcC0stecyawnaxXUA+LTY+EGx0HK/TKr737v7gVQozsSZbBMm3oQhX9Mlzrs9OIJq4jlT7CffkCusm9tZtkaKvIXEMvvShGmGc4LmRAKCGZOrgTRlLYvbRnAPLGahijrLnyXjISmXzNTPwqyITBeH8
 UqsOyREW
 4vzpjl4WDYBcPdYFBrevagBfEQC32JvW7jv1x2oW+lZ9yW5N4Tflm4+gDN0+YgQSiIAY/0ykbHLqbKThK+Svc6Gm12biZFAz8XuRzHZQ1YzO7cM3CKhd7v1O9oLX1/UB+/GGKnL6Ndjg7ESRoMODo1vvH77atuiwap2ASo15bl1MLOLoFKWNLFKbkYjBoGBt8vvp7Ls3Ir5ext02BupLSBYHJs70hoCkq4vItjL47pFUqDo+gHPMyGnpreU5CbW2F8TfNkZveZ217CvxBWrRfRHXxL+5I6HQzfssAhTcpd5zqg0FiEF2DhNS75zd/U1cUgJIE+cWm1yxz89cUgPkF3ptgsFLsbRDmKZSKjMF5/EoGnYCG8FpK6PcsVty7gr45y8PiB5r1z66+SA1DtsOspycZZj8SxX9vCTiTZYjZDYwmV6TZ2PcKRe3dDQADjo7/T7JJhHkCuFy2UzXbVL8I7OnjDYyGCErdbnbx97xfnx5yh0QwprBAelrLu4FJbKzD20k7ymTUeHGuvsdu0LK70UQ5pvJ6LeDu8MJrcf/SgQ3+pxLeNeEaiN7q3Kox+uL6UzVnX78HQ3aGIvo6R1oZH85ztKX+vgxsVDMJ0ZFrzRGzBPg0uJ2YrwAJfg7SCdOGs80/VrIIom1GXIQeqd6j+lAsdiVQ37MrHM4EKY8FCETvQiPSm4HoXSGEjkT4jBpTeU+A1LJ6SRnF+Y6ShzkTuM7FDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025, Deepak Gupta via B4 Relay wrote:

> From: Deepak Gupta <debug@rivosinc.com>
> 
> VM_HIGH_ARCH_5 is used for riscv
> 
> Reviewed-by: Zong Li <zong.li@sifive.com>
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
> Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>

Here's what I'm planning to queue, after updating it after Lorenzo's mm 
changes.  Please let me know if you want to change anything.


- Paul

From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 19 Nov 2025 09:55:05 -0700

mm: add VM_SHADOW_STACK definition for riscv

VM_HIGH_ARCH_5 is used for riscv.

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de> # QEMU, custom CVA6
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Link: https://patch.msgid.link/20251112-v5_user_cfi_series-v23-1-b55691eacf4f@rivosinc.com
[pjw@kernel.org: clarify subject; update to apply]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
---
 include/linux/mm.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..de912272c5f9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -359,7 +359,7 @@ enum {
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT2, HIGH_ARCH_2),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT3, HIGH_ARCH_3),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT4, HIGH_ARCH_4),
-#if defined(CONFIG_X86_USER_SHADOW_STACK)
+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_RISCV_USER_CFI)
 	/*
 	 * VM_SHADOW_STACK should not be set with VM_SHARED because of lack of
 	 * support core mm.
@@ -460,7 +460,8 @@ enum {
 #define VM_PKEY_BIT4  VM_NONE
 #endif /* CONFIG_ARCH_PKEY_BITS > 4 */
 #endif /* CONFIG_ARCH_HAS_PKEYS */
-#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_ARM64_GCS)
+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_ARM64_GCS) || \
+	defined(CONFIG_RISCV_USER_CFI)
 #define VM_SHADOW_STACK	INIT_VM_FLAG(SHADOW_STACK)
 #else
 #define VM_SHADOW_STACK	VM_NONE
-- 
2.51.0





