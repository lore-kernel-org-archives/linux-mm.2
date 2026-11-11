Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84B2606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ma+qyGKW
Received: by kanga.kvack.org (Postfix)
	id C3FC56B05B6; Wed, 11 Nov 2026 04:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16F06B05B8; Wed, 11 Nov 2026 04:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56136B05B9; Wed, 11 Nov 2026 04:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88B186B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:22:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17AFF8023B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:22:56 +0000 (UTC)
X-FDA: 85422298752.22.20624FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A8C21C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:22:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ma+qyGKW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794388974;
	b=snRox/K+Fg9GG2JbA1wN6ap5pfxC6yg8mj0ojfLIRp49rRSG2uqXFcJcEuGO5tNzwmBZcm
	Na9DRJ6warLb0GTk9scvJEcidsn6/OD3agbYc1WZ4TkUKuC1rKj1oAVal/0kcFwvf3FTrW
	uc1SyDewhv5vNCdrv7pOnVR5kKSaFmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794388974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7b5X+4SjztcHydS5WfCa1q0BYAFZqwdMD8BIV9hhKRI=;
	b=mMOY8wb5MVhkB5qZep0D1Kt3gUfJl3Pkf32SqD0+lu2L8heGRpXOkBrWDFpvKBZJumQJ4V
	s9dxwuX/TQ/D9LtC1dF7LeJvqJwOhuXHtOC1iEpdEmBTPvEWFcJDf3weO9j7+wdQCj2xIn
	PHUVt9LZPqX9YPoIUGERzxrwtqZHBrI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ma+qyGKW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1670E60DC9;
	Wed, 11 Nov 2026 09:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A8C1F00A05;
	Wed, 11 Nov 2026 09:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794388973;
	bh=7b5X+4SjztcHydS5WfCa1q0BYAFZqwdMD8BIV9hhKRI=;
	h=From:To:Cc:Subject:Date;
	b=ma+qyGKWLh4TZNAaUdEeYWoinDKtueXJVN2fP2E5y1OM6V0uxGGOBrH2nMcQAPyZe
	 9dqZEuscw1CZd30lO75Blugh5oW9HMarIoqzDud+2nTcFWdEzjJwnx1MlHMNX7aOdo
	 JrgOMmpflyEpdwKj+JphfrPE1fHZNMowW1T+5LwCDy1Lz6nHtFceRQncP5FYdH1lOl
	 mTgxOPztzQ410CyG1Rmij08KzZz9JozM4hiazqHpaK6BL+r3ZUuRiHplhYPTDJcdDL
	 QztnNG4oMk9zErC0Lw8sjtaPaiiKfWy1onpGQsc/2akwcnrb7LZwzQ3Z4sakO49TdW
	 9Y7Msma2BP9hQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
	Andreas Grapentin <gra@linux.ibm.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH] [RFC] instrumented.h: mark instrument_write non-const
Date: Wed, 11 Nov 2026 10:21:31 +0100
Message-ID: <20261111092231.2027735-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A8C21C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: uech386qxgap8j5hhpt1k93xsnmrh9h8
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794388974-461742
X-HE-Meta: U2FsdGVkX18dxBeoiQI08RvokN2E53DDie+LBsrKZ7czrkU62QfKv3f4qNqKmWErPvi/AJ4szhPsTMwsF2EPzasgyRvcTbOwgL20fJq/FFyZecWwlm4cPVmz4yFno8gfKx455XZjaN/iGnipAGQlVRYCrun8tlTc2T4V/f8GWMoxgUUGK+LPHzGj5fQMg6H8AqAtaFkPAwojrNb066KXKFl9E4RqKZfRrrMgEVtybfFzyGzcl8yZF0MId5ItD6cIrpV5Y59Oc3rUflCcxcH2gtj2wPGm6fvz0pUHpShm3zH4K1Ble434gerC2bOM04BTqpjltLEU17qbUGbyN8RkR9hdnCk9A4j4z2oaRitVw6JoeEkNl1/jFVOeJbzrHY1bvS3MN60aUZNxPDxfFWTRUOLPPd0keEE93j1o92Mq+m4vGI735a6TonJ0bL1dr8hjIPcWcPT9gEV40i3t6agAy+Vz5OMl1iGFyMa9IjNfxBl54MVdCVxgSG7n4VJirpWz68K5WQ/FjrcxBb2wOGxJgrxFrZJAWFR7bxwgCAD8PJaFIKaekIJXvZIIQJUUfjDwsRWAWkChSGjy3SRwaB/nqATZniVzu4M7h+pNCatjUL90feWFZHyoL9XCH2R3NubXot/YWGPh25gsIAvS9ETiOEWxBKSfP3o6Z5vhpjjSkniroVm4oRM8uUb/JqoiCdu03TvTXYC8EBvpHtju/OuYt6vcNtOZEmdN6ebM5WalN9nY6SBI7JPEoPUL+lwKdb/5lnRgtIQRDRY3p10wsHDSGN13CovokZ9umsxcd4gvPHVDlrc0yarjmOQuUpgz8kyaWAh1vJltNt5nYUvFp4H8naOn+2YC3QhxseQqu3ahKw0DlXGP/ERxlt/rhdolq2yqlsI+qo/pfjw/wA+l74gTRokwUnGUs9dgpIvCx64NOiephEMe1/WAxpZyC5U8Qet6C+MSxO2nCMCU+UPafRZ
 MjKjT/89
 tbXsRa32ngWC+jl9ReZBPcoRwirT6s7dtOFi5OIPJfBtgBj6ThTU97pW+uIdusSfiCfsgXhcSElJINGXpaVw075tXhcrRfVWeCGNa9yb9al6UXdptPTRofS/MFjlGF1k73vRVWSSTM4XVwA7Wz92N5k4MDF5slazG1LYfD7SIWXJPjCduRgiSQ/KTEhVl6FZEf+NwF6rGFvqeQwWILY9vdAZS7euoG7z4dpwL0Adjo/ixxwxyD1LEvy4LkT13KbpNJPbeE16ZxvF7jgjM+eoITwE0YYkO+AKmcd7QvWqpxv5ToerSROYMB4fbK+CttcnF1fUroH0O9Io3ri2/0i/xE6NuNkGsW8d7wkDfDqyTxq6TS0FLzIq26m4ECLmIiO/OesVUK5evGXSHXGDnWJV6ILnc+dHi/f9WoJms3GI46Mgjj3zriGPWsP7m0TW/5aVnTDt8ltzSDwzZ/OyG299l+ZXry+75wCVCCw2pT99d4b7hvO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

I got another instance of a -Wmaybe-uninitialized in ntfs, as this is
the only place that enables the warning:

In file included from include/asm-generic/rwonce.h:26,
                 from fs/ntfs3/file.c:10:
In function 'instrument_copy_from_user_before',
    inlined from '_inline_copy_from_user' at include/linux/uaccess.h:184:2,
    inlined from 'copy_from_user' at include/linux/uaccess.h:222:9,
    inlined from 'ntfs_ioctl_fitrim' at fs/ntfs3/file.c:78:6,
    inlined from 'ntfs_ioctl' at fs/ntfs3/file.c:246:10:
include/linux/kasan-checks.h:38:27: error: 'range' may be used uninitialized [-Werror=maybe-uninitialized]
   38 | #define kasan_check_write __kasan_check_write
include/linux/instrumented.h:146:9: note: in expansion of macro 'kasan_check_write'
  146 |         kasan_check_write(to, n);
      |         ^~~~~~~~~~~~~~~~~
include/linux/kasan-checks.h: In function 'ntfs_ioctl':
include/linux/kasan-checks.h:20:6: note: by argument 1 of type 'const volatile void *' to '__kasan_check_write' declared here
   20 | bool __kasan_check_write(const volatile void *p, unsigned int size);
      |      ^~~~~~~~~~~~~~~~~~~
fs/ntfs3/file.c:66:29: note: 'range' declared here
   66 |         struct fstrim_range range;
      |                             ^~~~~

The problem here is that copy_from_user() is called on an uninitialized
object, but the instrumentation passes the pointer into a function that
takes a const object. gcc deduces that any access to that object is
undefined behavior and warns about it.

The only workaround I could come up with is to remove the 'const' keyword
from these annotations, which of course is not great either, as the
functions do not actually access the data at all.

This also found incorrect 'const' annotations in
arch/s390/include/asm/fpu-insn.h, which writes to those pointers.

Any ideas?

Fixes: 33b75c1d884e ("instrumented.h: allow instrumenting both sides of copy_from_user()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/s390/include/asm/fpu-insn.h |  8 ++++----
 include/linux/instrumented.h     | 10 +++++-----
 include/linux/kasan-checks.h     |  6 +++---
 mm/kasan/shadow.c                |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/fpu-insn.h b/arch/s390/include/asm/fpu-insn.h
index aaf1faeb3dc5..7cd6e9f30485 100644
--- a/arch/s390/include/asm/fpu-insn.h
+++ b/arch/s390/include/asm/fpu-insn.h
@@ -359,7 +359,7 @@ static __always_inline void fpu_vsrlb(u8 v1, u8 v2, u8 v3)
 
 #ifdef CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS
 
-static __always_inline void fpu_vst(u8 v1, const void *vxr)
+static __always_inline void fpu_vst(u8 v1, void *vxr)
 {
 	instrument_write(vxr, sizeof(__vector128));
 	asm volatile("VST	%[v1],%O[vxr],,%R[vxr]"
@@ -370,7 +370,7 @@ static __always_inline void fpu_vst(u8 v1, const void *vxr)
 
 #else /* CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS */
 
-static __always_inline void fpu_vst(u8 v1, const void *vxr)
+static __always_inline void fpu_vst(u8 v1, void *vxr)
 {
 	instrument_write(vxr, sizeof(__vector128));
 	asm volatile(
@@ -385,7 +385,7 @@ static __always_inline void fpu_vst(u8 v1, const void *vxr)
 
 #ifdef CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS
 
-static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
+static __always_inline void fpu_vstl(u8 v1, u32 index, void *vxr)
 {
 	unsigned int size;
 
@@ -400,7 +400,7 @@ static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
 
 #else /* CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS */
 
-static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
+static __always_inline void fpu_vstl(u8 v1, u32 index, void *vxr)
 {
 	unsigned int size;
 
diff --git a/include/linux/instrumented.h b/include/linux/instrumented.h
index a1b4cf81adc2..d28aa6b0aeb8 100644
--- a/include/linux/instrumented.h
+++ b/include/linux/instrumented.h
@@ -36,7 +36,7 @@ static __always_inline void instrument_read(const volatile void *v, size_t size)
  * Instrument a regular write access. The instrumentation should be inserted
  * before the actual write happens.
  */
-static __always_inline void instrument_write(const volatile void *v, size_t size)
+static __always_inline void instrument_write(volatile void *v, size_t size)
 {
 	kasan_check_write(v, size);
 	kcsan_check_write(v, size);
@@ -50,7 +50,7 @@ static __always_inline void instrument_write(const volatile void *v, size_t size
  * Instrument a regular write access. The instrumentation should be inserted
  * before the actual write happens.
  */
-static __always_inline void instrument_read_write(const volatile void *v, size_t size)
+static __always_inline void instrument_read_write(volatile void *v, size_t size)
 {
 	kasan_check_write(v, size);
 	kcsan_check_read_write(v, size);
@@ -92,7 +92,7 @@ static __always_inline void instrument_atomic_read(const volatile void *v, size_
  * Instrument an atomic write access. The instrumentation should be inserted
  * before the actual write happens.
  */
-static __always_inline void instrument_atomic_write(const volatile void *v, size_t size)
+static __always_inline void instrument_atomic_write(volatile void *v, size_t size)
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_write(v, size);
@@ -107,7 +107,7 @@ static __always_inline void instrument_atomic_write(const volatile void *v, size
  * Instrument an atomic read-write access. The instrumentation should be
  * inserted before the actual write happens.
  */
-static __always_inline void instrument_atomic_read_write(const volatile void *v, size_t size)
+static __always_inline void instrument_atomic_read_write(volatile void *v, size_t size)
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_read_write(v, size);
@@ -141,7 +141,7 @@ instrument_copy_to_user(void __user *to, const void *from, unsigned long n)
  * variants). The instrumentation should be inserted before the accesses.
  */
 static __always_inline void
-instrument_copy_from_user_before(const void *to, const void __user *from, unsigned long n)
+instrument_copy_from_user_before(void *to, const void __user *from, unsigned long n)
 {
 	kasan_check_write(to, n);
 	kcsan_check_write(to, n);
diff --git a/include/linux/kasan-checks.h b/include/linux/kasan-checks.h
index 3d6d22a25bdc..90b878b876f5 100644
--- a/include/linux/kasan-checks.h
+++ b/include/linux/kasan-checks.h
@@ -17,13 +17,13 @@
  */
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 bool __kasan_check_read(const volatile void *p, unsigned int size);
-bool __kasan_check_write(const volatile void *p, unsigned int size);
+bool __kasan_check_write(volatile void *p, unsigned int size);
 #else
 static inline bool __kasan_check_read(const volatile void *p, unsigned int size)
 {
 	return true;
 }
-static inline bool __kasan_check_write(const volatile void *p, unsigned int size)
+static inline bool __kasan_check_write(volatile void *p, unsigned int size)
 {
 	return true;
 }
@@ -41,7 +41,7 @@ static inline bool kasan_check_read(const volatile void *p, unsigned int size)
 {
 	return true;
 }
-static inline bool kasan_check_write(const volatile void *p, unsigned int size)
+static inline bool kasan_check_write(volatile void *p, unsigned int size)
 {
 	return true;
 }
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d286e0a04543..591c179164af 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -32,7 +32,7 @@ bool __kasan_check_read(const volatile void *p, unsigned int size)
 }
 EXPORT_SYMBOL(__kasan_check_read);
 
-bool __kasan_check_write(const volatile void *p, unsigned int size)
+bool __kasan_check_write(volatile void *p, unsigned int size)
 {
 	return kasan_check_range((void *)p, size, true, _RET_IP_);
 }
-- 
2.53.0


