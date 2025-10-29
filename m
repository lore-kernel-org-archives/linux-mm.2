Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D508CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DB98E00EF; Wed, 29 Oct 2025 16:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E438E00B2; Wed, 29 Oct 2025 16:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F888E00EF; Wed, 29 Oct 2025 16:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED5D28E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:09:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BADC012B43E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:09:39 +0000 (UTC)
X-FDA: 84052242078.30.C03F5B5
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf24.hostedemail.com (Postfix) with ESMTP id D3A75180003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:09:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=GiO+NP1C;
	spf=pass (imf24.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kO+NK4R04JM70PmVsjA3ThrFoFrY2dEYZyEQtxD9Gc=;
	b=nGJklTLQMBEK3L722gwadcOcUjODcu+wsZYstmhOg6FgPoDZ7zFzGycWwE2h4OqYmLMO3X
	8k2K8vh28x1Le7huqdEs3AZVZ2XQIpTILYuxK/qToFK+2G4FXviCHwEhXS9YuOqbp8zXB/
	mRpBzNzJO9uUHMuW/B4PmNTX3Iz3orE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=GiO+NP1C;
	spf=pass (imf24.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768578; a=rsa-sha256;
	cv=none;
	b=tU7cG7CShK3BYEfBPsRWOU74neYNyzL//3eWNAbz59A0Gos6NB4euepS3GDQaZvOD9OCZu
	MIpaVo8oPlPLL2eo+eQZSr/v0saDY5DwG0QBX7vFLjCEAwxB3TQ1H12cxi6G1Y3grJqQ/P
	pQVThITrN6uYSbEf4A7t0AvttNCKNCc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761768575; x=1762027775;
	bh=9kO+NK4R04JM70PmVsjA3ThrFoFrY2dEYZyEQtxD9Gc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=GiO+NP1Cl8/oha+EezztD/oioG80KLBwC09Ce0/RmuvQMCBBOpsvpeyrM1SYKP380
	 L55FlMbYoS9vvMYp6u+V/7HJh5NlPM25E3S/mc7Yo6015R0C0GV6qsbAZ0uhT1F7A0
	 mpcNgf97G1MEObQ5l3M7Y1fy71MJY1hXHoqBjAcP6kuvTg7wW06FUUqhHu+0cQ9ob4
	 74pYfXnPEt5uOz28lW7xSav9FPCJaxYHlp/8fDhgCMIbN9UWvw5d+D8fOPV6TBll7J
	 Dzv2hAiwmoltCsMMbtVmhyUxeYuIifVpZya2+ANHr1l0hRf1ny1I1hgtqU13yTLAP8
	 uD8Rn3tilxeaA==
Date: Wed, 29 Oct 2025 20:09:28 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 14/18] x86: Minimal SLAB alignment
Message-ID: <0ca5d46e292e5074c119c7c58e6ec9901fb0ed73.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: bb212e55891aa41be391c49c804782cab1b9ead2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xbjqhuheofp37kujateeujsdcj66twyr
X-Rspamd-Queue-Id: D3A75180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761768577-213185
X-HE-Meta: U2FsdGVkX19Sd5jO/yFw9rpNGXtrFB41qUbvpIHyewtVXTdjCKq6kBPxG+k2fVYI2MngYb19ouhzAyijbwyqc8QSgRNGtjwjTe2H3UrIazv7zHeL8VEFrC7MjCDDloSXTpHeAzx84mzAgDC4SkS0DYTqRd12hmajWAATE2Xl9KYNVu9MgszJXyFdq/fHB+SfqIrSm0McMqO6JHGvdE3Zr0yYOnw3oM7OqyGAiN1FHw5XepqWjlUxtc3mkfDOOr1mSMiklyW7FYbYMJqOz0m3FUpiG+KvbVY52vdRF6ZkGL3APLjPiGcRj6KZCEGpFA+w2X2CT7+MIoHN/jbcsZc5QSvkHr5n2fAPpCvEA1rHNuldbtAWrjQ44DzO2FQwfYaU6UBUKOx0Ku+vS7kFLn9TRrrLgg91dlfHcmTsFu+IJvMISNjPT+z2S7nBZpJACwfscdAsQAE3Bduwa40bZHESbpw6+Z3IjLC8ToZr76ga1m9LtNi5yFdGffohAoZrXxN1piVWqhQNkGtkTB7KgGSz7NGsrSHcZvstm6mnPgHR9cpjeLiyyKLYFScbVLMl+e2NAguWsvdUfks1rQPr02kCkZ1dDi5fmILEEbBRWaEAapDJE0/r4/G3OksruE5YtFLQ70r5c8xkOhMvq4ST2DA/A92de4AxzQ8Yu8WTsHtCvtmpc7d+cQs3H1NfK5dNB121OzY4Uh3jJhQrrgdDYeFxsqnU2B9+QW4zytNpPGRvEQzqlfwcbEN9mduK08GHpQt1z9v4iWHYeWpLI6atUuits5TZOtVOqd1CYo9yhdwNTH8MQA8OEMfl3Dfn2Gn2QcdEJsQfy8qx/uRA8G+L3shLBojtyjwdcRIgMZbtJFlrL/fHvXZsohrnvcZjDowzWncZhOfMXvdKpp/a0cbhKccAoCY8w0GDUL/Kkh2UuOBW1YidfqxE/ASMnWcX7sdq1WJ+BrcPJpOjgXqSkkcZieV
 ZkQBjNaC
 iNRGgi0tG7Ak9PP+h94kVHZ8DW9xUd3N7VyZOfAVP43f55csfjoXAOtjQiMd2iMLrGk2XheQLx513OS3rgnT2BgkYJ20DAmzq8qWyuDnPR05HSQwRJRvf7bpJSybDZLmHd3awzIhZpXcg5CPFwGiR+3nlQMf/yrOrSw3vceN4d1hqAlK6YUQmdLPozFapoQGIGuLRge8w+O5gT2D3Ock2XtYar3H2fQkSKMvbCf4kqwuDJPehywTMQ5oxEwjzgveRg63d1KSFehNx/f6Nljggthqd2U61Ulpr+06w1hsDglb1NlLFmBxD3v3MmIvF3GZL+bW2IjXfsBf6ZcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

8 byte minimal SLAB alignment interferes with KASAN's granularity of 16
bytes. It causes a lot of out-of-bounds errors for unaligned 8 byte
allocations.

Compared to a kernel with KASAN disabled, the memory footprint increases
because all kmalloc-8 allocations now are realized as kmalloc-16, which
has twice the object size. But more meaningfully, when compared to a
kernel with generic KASAN enabled, there is no difference. Because of
redzones in generic KASAN, kmalloc-8' and kmalloc-16' object size is the
same (48 bytes). So changing the minimal SLAB alignment of the tag-based
mode doesn't have any negative impact when compared to the other
software KASAN mode.

Adjust x86 minimal SLAB alignment to match KASAN granularity size.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
---
Changelog v6:
- Add Andrey's Reviewed-by tag.

Changelog v4:
- Extend the patch message with some more context and impact
  information.

Changelog v3:
- Fix typo in patch message 4 -> 16.
- Change define location to arch/x86/include/asm/cache.c.

 arch/x86/include/asm/cache.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 69404eae9983..3232583b5487 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -21,4 +21,8 @@
 #endif
 #endif
=20
+#ifdef CONFIG_KASAN_SW_TAGS
+#define ARCH_SLAB_MINALIGN (1ULL << KASAN_SHADOW_SCALE_SHIFT)
+#endif
+
 #endif /* _ASM_X86_CACHE_H */
--=20
2.51.0



