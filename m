Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5769DC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D62C6B00B3; Tue, 14 Jul 2026 10:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ADE56B00B5; Tue, 14 Jul 2026 10:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C42F6B00B6; Tue, 14 Jul 2026 10:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0476B00B3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:05:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EBDA1A0161
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:36 +0000 (UTC)
X-FDA: 84987555072.27.0B18593
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 577FD14000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Bm1/z7nw";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037934;
	b=gMBuI42Uo7pJma1Nv4SuWukUVjkAZO3NMxltVypLEUk6fMJdEVLgQyCKhv6ziRE5zVPy8x
	N5GrubyXVRvKuPEv9/7jWnWthBBTv0PXorV+jiRTIbbtWfD2+EWEZKPXE0l3ghGQAqshZQ
	Nb8uLjPWXY9indjn8pZFUQrLoCDhdpE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Bm1/z7nw";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sn+zU8yNJHIyNq+aM/0w0FGWDdrVU1gUm/tv5PTPfjM=;
	b=t2AH0XaZG6QJHc1mpFE3ItzhdaV4iB5Sa3aE/NJdo/VXrHsAPKIAF8thTFELIvTr1TxkjI
	lF7MIfH8uJKnahwvVMrn6bZQRwWzbxIdcsXbpDkTEBMv4k9GOpGlFf9DdoplRTPzFS0mju
	aTLhUV5IOmedBzWnQ0BGafklpJ1gMfM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 224CC152B;
	Tue, 14 Jul 2026 07:05:29 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECA813F7B4;
	Tue, 14 Jul 2026 07:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037933; bh=FInc2gTxhVQc4LYtwtKoJPw43dSvFTnMs+LPVQ5s9u0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Bm1/z7nw3ZrVQHSoXKrtxTQs91wc4RUrXfic6nvC1VPB3At2KepfWXr7Aw3HYFpkn
	 ioHo5OCLJkJiU6MHz48diP4nr6YFWtjQg3UL72aeFoQQSfWxPSBxVE10gNTyxwI//k
	 BrtCJZVqyK4Ji57oD58xPcYajyNM3z8AN78Fhrlw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:52 +0100
Subject: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for init_mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2504;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=FInc2gTxhVQc4LYtwtKoJPw43dSvFTnMs+LPVQ5s9u0=;
 b=LLyApQy3cCX+sEK7+yEv+wdSQwFfqhZ/PtGYmJI+JJbZMoulhtvHZSYrG2onhzlRcBnCeJhTe
 oQ14mia3FhGBEfCDsSpVX5EPWBdyUPXpBCd8WmZOxEP54NLEVWz9CaD
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: 577FD14000C
X-Rspam-User: 
X-Stat-Signature: 6j8sstbw8t9z1ct5pdwj5m3ersqcpuip
X-Rspamd-Server: rspam03
X-HE-Tag: 1784037934-421760
X-HE-Meta: U2FsdGVkX1+TbH2bct7n637+k42nyleX3M++m7sxtOfdrZGiYvSyWDPpZUuGIVqhDDMCifqo6X2uHqMEVzz39JS5vk5xrEVWfLq0EK73TNLQayDVIZIX4HZAmmzrziSqEEd+UMI7IYeex+aDUbLfcfQ30y4V6PrNNUyjESHwqMeRIhsY88eMlyppgUw3LkKhpdKaUjsiU61qsa5dsUjV7SY0rztxA+vwhzT6D3dR+ciIa/54i5vGkBz7F2oJvDIG4+jVOPwmqiWdzbc9LxpCMlbk7tL8139CPd3/MOeWnGsELQvJRbNxMGQFgxILo2s7EXKgocKVDr9IRvF8cjBOr5L0DXNKCksRl+QR1Ku6ux3JL9p3LsdxV2o4/DbkoeQEfwzpTt3GNFa0Rl45OnVrDk/HB6B8AmPxv4p0sb8LpfodsHqQ+D0Pdvvsn8XYVQ2/QNB+BnoDHlcvwypAVgistmOQSz/SlXPBoU/izMU86LFOCSCzhs5T+J1KIsTFzVk4kRVjlCORZoZxdpyTN8RMj7IAXLwwsvo5LtA6yZcpppQWFo8we/JfTMPGwj425KJcpNsZlnv7klWt/JjImKWZnGHeND5TIjDzO3iNzzokVwg8QnK7oa4n2R0EhuBDfsUpAZRygjFujfkCZY+vi380UBsz7o588/ZJNbHyLcVdfSdnGZryYlpMjqX+zuP7VRpR9mKhDUes8looQ35cee88Abn5wTe13y2Z8JM4Rrb/SpCiDYFn1IYpVLF4KfGdunohhHHm2B0vgG+axqDLmpArkRddsB7SA4lgdtr3Ov/GnEWe0IBVlCrFjls7DlLWmAW9VpXINjyUZboi1ZV6kgGvtouYGMlrDbXk86cK3YGkDsV94JluO4yCE8qGkk2eGosK3Wxp+tZaRYKdhylxbhl0k2JuL/nOHvHcYv9Hn1+bXmYYkYa205doI+Xpup9YB54FgxoQuVo+QQCfrTYr4c0
 49XCTMON
 snGVTuCC5jD/MFBAndAsYk3nrfoWzxJa2nGQPedgj7oF6Rkjs8ZpD22GZ2p4liERgRONh2KlklFFKwYi+bv6ZFRQLiuyQySg1nnDvBTxcnuXN13ZTOSiFBvf/QbLeoqVCROgrOR/cFYYIL7MwAymehh4eWxCjmWXEA2mHk6WYtT+eMm69YLS4BldOnsXrBGSonclcHjxgJCa0R2+PQI76augvlHh8Ckvji+Vy2Ab4Nk5prosy3+NeXwRakH/j3Hwqda3W/Bj+FwBp3kTMHZpHR2SFnmE9bBYh5hP5KDugytMgX3Acuq9q6yz6PcyFy0h0jV9XE+oMbvz1nLOps+2J8ljJwqiWKaK8QjlcoWyw4YaZzch8BDv4q++96g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm code often needs to know whether some mm represents a kernel or
user address space. This is currently done by comparing the mm
pointer with &init_mm; besides not being particularly elegant, this
ignores the fact that other mm's (e.g. efi_mm) may also represent
parts of the kernel address space.

Introduce a new mm flag MMF_KERNEL and set it for init_mm.
Subsequent patches will use this flag to replace comparisons with
&init_mm. No functional change is introduced for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm_types.h | 10 ++++++++++
 mm/init-mm.c             |  1 +
 2 files changed, 11 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a2e0dc5892ff..7838ea3aac00 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1414,6 +1414,8 @@ struct mm_struct {
 	char flexible_array[] __aligned(__alignof__(unsigned long));
 };
 
+#define MM_FLAGS_INIT(flags)	{ .__mm_flags = { BITMAP_FROM_U64(flags) } }
+
 static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
 {
 	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
@@ -2001,6 +2003,9 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_KERNEL		32	/* mm belongs to the kernel */
+#define MMF_KERNEL_MASK		BIT_ULL(MMF_KERNEL)
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
@@ -2008,6 +2013,11 @@ enum {
 /* Legacy flags must fit within 32 bits. */
 static_assert((u64)MMF_INIT_LEGACY_MASK <= (u64)UINT_MAX);
 
+static inline bool mm_is_kernel(const struct mm_struct *mm)
+{
+	return mm && mm_flags_test(MMF_KERNEL, mm);
+}
+
 /*
  * Initialise legacy flags according to masks, propagating selected flags on
  * fork. Further flag manipulation can be performed by the caller.
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 3e792aad7626..93773269bf87 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -34,6 +34,7 @@ struct mm_struct init_mm = {
 	.pgd		= swapper_pg_dir,
 	.mm_users	= ATOMIC_INIT(2),
 	.mm_count	= ATOMIC_INIT(1),
+	.flags		= MM_FLAGS_INIT(MMF_KERNEL_MASK),
 	.write_protect_seq = SEQCNT_ZERO(init_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(init_mm)
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),

-- 
2.51.2


