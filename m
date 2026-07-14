Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8680BC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3676B00B2; Tue, 14 Jul 2026 10:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB646B00B3; Tue, 14 Jul 2026 10:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1176B00B4; Tue, 14 Jul 2026 10:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4484C6B00B2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:05:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C05BA1C0293
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:28 +0000 (UTC)
X-FDA: 84987554736.25.274B41E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 860F04000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="L/UyKrDH";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ng20Y1WVsLH0VrG9X7Anb28wNw6mpkVst635uOI6nRo=;
	b=419xbfDMfPExN6E1BzPmv2+vn16kI91jgh3ewTSjisByv/I8GvoMvJoYWf3sMmz1/F1gk3
	jNCmI2m4NtD7lwYxZdft80EnU+KUoU8Wd+yee1R8HSrUzpTQaMixWpE6vswuvPKV4TfeST
	hWP++zLOX4p8D4qHKDqmo5WpU+t6Ju0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="L/UyKrDH";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037927;
	b=Vuke4n7kAv3OJPuEuI2XaOwo0ExctpFiCGKuvYuJuP/617+dHcZkC9FXyGRG+grYCpw0gv
	G0vQhgxcccBlSNzkk6Nj+ihWaE/fZzayimXghwglpLGz6GAi0nMgo/3HxrHgCCgQI978bd
	JJrFgk53ZUjNzyVR5eCTRucK5sJOe+U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63C3B339;
	Tue, 14 Jul 2026 07:05:21 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A07F3F7B4;
	Tue, 14 Jul 2026 07:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037925; bh=xWJCKsvCSbOTf1MrL+nqfsWcuzx4IBI4MMfjRE6PTH4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=L/UyKrDH31P2AxfsB5zaY1mh6o9sykjNj6yB/yMXG8ePSNTlccGqvWENIvdaG1tfJ
	 Wk0YZEQWyX1mVS8XhODJBz5n9MI25kkc+YIk8/N9y9yuoLWoSBYTDhb1fyTBkqd7HI
	 cav7VW0lg3rVkGLnx2wAlICXEbNLvp2RP9uBMl74=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:51 +0100
Subject: [PATCH 02/22] mm: move mm_flags helpers to mm_types.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-2-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=3490;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=xWJCKsvCSbOTf1MrL+nqfsWcuzx4IBI4MMfjRE6PTH4=;
 b=hjHVW6q/l9oVND5egfxNDc6FE64eNht6hv1NYHcLYYfk3GK4zKlatRLYEID3yBr+Cr2y6GvLX
 wE73qcbXnDpDJQn8OyUXgdNbqTA1wZVDqiAytR24UH8BGEWoTGJECyr
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 860F04000A
X-Stat-Signature: ie4fhwobbxr7nw681nh7t9oteifmecbh
X-Rspam-User: 
X-HE-Tag: 1784037926-813316
X-HE-Meta: U2FsdGVkX1+Uoqs43+LPsvudXnZGwzKrBepc8X2V1+02sj5PcHLXEBl6KwC5PKArYSOKgg+Esnx6OfYC3hV2x0cNC6r/mGNJE0bEq+PhFW88zJvjfqkZ8903JiLGKdaeI3mGNdT3YeNcS/iZFLPXwwMPVp9SiPOEvUDjytv24cJWjvn/dED1fosLNoXQ3Z8XunnW4h6yhq7gY7rLOrZ/Y7hGa7QKBuyPp2oLjH7DspwZwr6KcKWyZSIdB3Oxn6pu6XFR7jU6BZGof9qRRbHJduRpvukezEf7rL+jiY5lUSIvNLOa0c30nK8bHhe3WxbgO8QLaZqFlgkFH86LmAp2vKp6cEEwJJ5eqkmtgKFa8QFzeSkCWmekHN+SbxQvgHKFezgMKy7uV+05P1+/0B7aC6DG69dvo8PaMp0y5xSLLR0T4N6siPR6Xg7Dqf8M8+DCYFw+8nXC/SUX67DRMy56VxXYbxmsTKlKTTD4lA6jOtXVg3y9t6+qcw2z1HKHO5Xu28R4RQrT+0VvIhr2QtJFR22sUPaGqQZ2lXKJockvJgr8o9iO2/tEm1+8ShQhWaE+TTtPKLrhjJNViQAU7YMu+rOuuiXQwmeah2ii3rSQP8PpdcReJZRB+Zf6KUP+prEuKc3MlKSPuvJnY/hws+fUmZ4Ruy4+o2p0H2Rv5AgR2NH8K7QkSQARFiWZ9DrcBFjl5qzqfn0ChmkfaNYQLccKkuiNjLxnqRzhCS3QkEOh4I0H6vG3UA/WiE3IAjeXJNOL3cSuhttCNPpPX5fMRcbJ/4rWG37k6pdjKqmBS2BHoG7fL+MJxGONuDeLfE4syJzC9CTR3Cl+65ACprwItsVzAgZcDDyayimp3UzVPM+8oj2eYPw2MKOVO+UvqUSzTJxiCIuGUNJgZiWuYuq0uCUaMIq9MLEUMG9xts+uOMDC7rv/guC0OUVuMhNkyAqcQWstt8+u0VNfYi0wENnEmrA
 XPI4dAvN
 gLqQBE3I0i+IWjhPhVowt5zHk03Uw+DNazZifyxIBQLvLoV196q5kp5xnjEH3VvPzMaLuFEr6zws6NvPkcjvL0yXHnmIA8Y/5Ut/J/c908z6x9JGAoArONVzq7sHa9Nj/09RctqErrBQkZj3Xz41vss2p31O11c3V6YPGR7yFRnoPW8NPjGLkRk2SCAkCQLKA0e4sSqzrjnsExAo4Ubzt0HZ8PmydpACEpX1HW3m/2PkTeeKxOX3A8RfaPxbJy/FTMZcRkaV5t3OLoG6/PZylP98CuKYX+wPxUzRd+uNr7imJPFcvpxdpFh6mSt6S+PmH7wy2W2Tcygynqy+H+w6HShxYAgR2SzHnvHa3T0dxV8aGmelVwWRwRFyybQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some of the mm_flags helpers are defined in <linux/mm_types.h>,
while others are defined in <linux/mm.h>. We will soon need to call
one of the latter helpers from mm_types.h.

Regroup all the helpers in mm_types.h to keep things simple.

Also remove #include's that were added specifically for these
helpers in mm.h.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm.h       | 32 --------------------------------
 include/linux/mm_types.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 32bb723ffbb9..7a4b8e7ac8f4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -34,8 +34,6 @@
 #include <linux/slab.h>
 #include <linux/cacheinfo.h>
 #include <linux/rcuwait.h>
-#include <linux/bitmap.h>
-#include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
 
@@ -948,36 +946,6 @@ static inline void assert_fault_locked(const struct vm_fault *vmf)
 }
 #endif /* CONFIG_PER_VMA_LOCK */
 
-static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
-{
-	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
-}
-
-static inline bool mm_flags_test_and_set(int flag, struct mm_struct *mm)
-{
-	return test_and_set_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
-}
-
-static inline bool mm_flags_test_and_clear(int flag, struct mm_struct *mm)
-{
-	return test_and_clear_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
-}
-
-static inline void mm_flags_set(int flag, struct mm_struct *mm)
-{
-	set_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
-}
-
-static inline void mm_flags_clear(int flag, struct mm_struct *mm)
-{
-	clear_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
-}
-
-static inline void mm_flags_clear_all(struct mm_struct *mm)
-{
-	bitmap_zero(ACCESS_PRIVATE(&mm->flags, __mm_flags), NUM_MM_FLAG_BITS);
-}
-
 extern const struct vm_operations_struct vma_dummy_vm_ops;
 
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b4129beb9c4a..a2e0dc5892ff 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1414,6 +1414,36 @@ struct mm_struct {
 	char flexible_array[] __aligned(__alignof__(unsigned long));
 };
 
+static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
+{
+	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
+}
+
+static inline bool mm_flags_test_and_set(int flag, struct mm_struct *mm)
+{
+	return test_and_set_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
+}
+
+static inline bool mm_flags_test_and_clear(int flag, struct mm_struct *mm)
+{
+	return test_and_clear_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
+}
+
+static inline void mm_flags_set(int flag, struct mm_struct *mm)
+{
+	set_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
+}
+
+static inline void mm_flags_clear(int flag, struct mm_struct *mm)
+{
+	clear_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
+}
+
+static inline void mm_flags_clear_all(struct mm_struct *mm)
+{
+	bitmap_zero(ACCESS_PRIVATE(&mm->flags, __mm_flags), NUM_MM_FLAG_BITS);
+}
+
 /* Copy value to the first system word of mm flags, non-atomically. */
 static inline void __mm_flags_overwrite_word(struct mm_struct *mm, unsigned long value)
 {

-- 
2.51.2


