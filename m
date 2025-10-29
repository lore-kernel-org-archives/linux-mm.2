Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 208D1CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D148E00D6; Wed, 29 Oct 2025 15:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4458E00B2; Wed, 29 Oct 2025 15:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758C58E00D6; Wed, 29 Oct 2025 15:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 636B88E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:07:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 304F3C078F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:07:02 +0000 (UTC)
X-FDA: 84052084284.07.91F6D42
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37C22180020
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:06:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=iIyqHUmB;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf24.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UuVBFIvAqVGiw6UOZ0Oq2LH/B7F2B7f/ik0cOvmOtjs=;
	b=yu9ssqFFctVe3BSEClWGoH5OpwGdjflH3T0ZxeF4XjFi1zW/FUS2zp6AqUKVir1Kdid/56
	jdgL/2Tm/UpgfpTFX7So2M88xX30wwZoRaKWmBHZ8ESTm/lZdwANgnm4zyz5+pIBLDGGkB
	7YWnD1s2M7l8erGUnBhwqdy/ccQrlTU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=iIyqHUmB;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf24.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764820; a=rsa-sha256;
	cv=none;
	b=ZU1VreIc4An5OP+ATqPacWBuBPB7gEOZUcU6xFHEwa/wzOwhHpO+Q1v44hRz7r7pIVeONZ
	G9JbANJfymEOmsBsGdctS17M8H3uiujX3i6ddeMBn4laOMDxoEK7OZtaDgHqH9Zm4IPWG/
	x1GNpJ6HMIsOdYStNyq+2HBPyK7Pstg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764817; x=1762024017;
	bh=UuVBFIvAqVGiw6UOZ0Oq2LH/B7F2B7f/ik0cOvmOtjs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=iIyqHUmBQXJaUQMu+N0NZRSCH0kBx2A+c75BMIdYkjFaKskam7OT5Wjd61R/gx1Xx
	 Xz0BfxOeql9L47SHvCAkTWD8CiJ+CjosWQrVJYXj5LffB0359mhzcZDTk3guLEc1CS
	 P0af2k465IeYSTRHH9BfuN5/rtI1csCf0L/rvSxUQ5Cyw8uCyP7Mzz+OLabhBWwsGl
	 FCjPJ3WdW+JAXcyt3iYl4ylBSBFjo6RMPXpCvPqMBk6x7qS2DVGrYDrO89F2AEEiVk
	 28Kvfp7z51eeM83L/GI9KF+c19L/vN8JB6k/tf/liftNpp/hj1PWfhGBSR5c0xS25r
	 LMiCrEx6G6R2g==
Date: Wed, 29 Oct 2025 19:06:49 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 05/18] kasan: Fix inline mode for x86 tag-based mode
Message-ID: <8681ee6683b1c65a1d5d65f21c66e63378806ba0.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 57ed454739a234eef863007c4125f42148d9fdbb
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 37C22180020
X-Rspamd-Server: rspam03
X-Stat-Signature: uktjhzs6qmodkjiubr6tuaw51gg749tf
X-HE-Tag: 1761764819-633122
X-HE-Meta: U2FsdGVkX1/J2lvL3BBtyTvlnNe9byzpAjr8EbskfegHSn5jQMUZEaf4RdGvAABD+FLELYF5htvTIj8C6ZUQ4F5mgH1gNRs6OOQvaGBjnsv50ifMsgQ+OxPfRgGbG2shsE7YFakKgldFVlh6MXmDkHh4U/WJN3gVkYmYNKqPZm0IF60apFxnL0k3OTWt/QizDxvbR0b1mJ5E9+J573bOeVr6Ag74OAr9XCP9pR/GXm+aOwLWxrb4y3KLIxPsKyK81JLeh8Zmyt/FZXrj/znxL0pPf1FtkgbtF29B73D12BY6kU0WY4sV+1ZX2A0Ru9n5qtRk9S6lA1EEpa4bM3k8i03aFd3h2/2FV8Su1+6E9BUn6ZbqmafjuOxGBeBPbfqo4BEaOX0PAmZyINr01nes6h+15tFezfaGeq4h13SmaJJg0GZeazmhbCmfy2mrPk79WM/O0HQeVGDK5wi5PrjzyS86ZNg9KsD4HwlCXsI5VuIxuXDzOu6ViTC7vXEhHIfOcMChvNzMeMtsjKwW+i0J+M3QhA5ziWYaN6aZmH7KtI4UM8L775Jh8e8ixu4GDKSX4ndHCGL92SSm0pdxwyMoWzWU/jyd2xnD/yiNrfywzgF9b2XMvqxLKPVVnz+8MquaAi64zAhTmf1OA/RnecUHG3c892ZAx2+GSnP1TnsW0b8cAZvlu7n/proqKShYeAEsUHtDoYAf0E5hlCY6Z3/41OyhKgpTE8vhq4H5OS3lm3GC6VmFXYfXfyDMrh7dIV2JRopzWw5aWyao21s2O289ZYwXKI6HeUddWvkAbBgnWYPI/6/C0xRNP4QHmr4g+eaVoEkR+5rUP1zdZYFVaV8EC4yrZBIS3yB3Yu5GpE2CjvtEG6WFjVhw6flmWmIxhozvBz0dap0a/r960vTl7jSkgMumm9gc7IABpW3f0sItiGvSEcv0nRhIKWbe4z7lKE8q9IL3IBEVQ43wVeFPZwD
 p6I9ofEM
 ixL0KaNQS0i+qWeM3yPg20R95DBZ553EQeU2VOWIRhyAI8B6pzNYQPkQWuVSrrVRmaeog9snCTRpLeEvokbIK76eQQTg3ZNkDKIyF0LeRtK6aoJF8zNPhftdEP0md2t1VbIDTFAXLYiJNkVGKgMvq01Tfqcsz5uxwNQ64IMHVQYrVzhb7VvHlBgA7UPR4pKMr5WuChBu3TEDUAfn5Vgnhw7+vMiaYmCQudfb/x95amBcYyAqI/Br/snvC4P3Z37VvAxpSERHMVsYa8tMfr062fvMIs7CvcXesvdMl5kouTYzEG9HRvTFv4+Oe2kVkZM4To3L6gw6U/KJ71bc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

The LLVM compiler uses hwasan-instrument-with-calls parameter to setup
inline or outline mode in tag-based KASAN. If zeroed, it means the
instrumentation implementation will be pasted into each relevant
location along with KASAN related constants during compilation. If set
to one all function instrumentation will be done with function calls
instead.

The default hwasan-instrument-with-calls value for the x86 architecture
in the compiler is "1", which is not true for other architectures.
Because of this, enabling inline mode in software tag-based KASAN
doesn't work on x86 as the kernel script doesn't zero out the parameter
and always sets up the outline mode.

Explicitly zero out hwasan-instrument-with-calls when enabling inline
mode in tag-based KASAN.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
---
Changelog v6:
- Add Andrey's Reviewed-by tag.

Changelog v3:
- Add this patch to the series.

 scripts/Makefile.kasan | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 0ba2aac3b8dc..e485814df3e9 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -76,8 +76,11 @@ CFLAGS_KASAN :=3D -fsanitize=3Dkernel-hwaddress
 RUSTFLAGS_KASAN :=3D -Zsanitizer=3Dkernel-hwaddress \
 =09=09   -Zsanitizer-recover=3Dkernel-hwaddress
=20
+# LLVM sets hwasan-instrument-with-calls to 1 on x86 by default. Set it to=
 0
+# when inline mode is enabled.
 ifdef CONFIG_KASAN_INLINE
 =09kasan_params +=3D hwasan-mapping-offset=3D$(KASAN_SHADOW_OFFSET)
+=09kasan_params +=3D hwasan-instrument-with-calls=3D0
 else
 =09kasan_params +=3D hwasan-instrument-with-calls=3D1
 endif
--=20
2.51.0



