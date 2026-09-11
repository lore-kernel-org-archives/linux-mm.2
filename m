Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875E6C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4956B008A; Fri, 11 Sep 2026 07:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F9F6B0092; Fri, 11 Sep 2026 07:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CD46B0095; Fri, 11 Sep 2026 07:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 207EA6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:28:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D8101C0E6A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:28:54 +0000 (UTC)
X-FDA: 85201259388.21.0963E44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5D0DE1A0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:28:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A2f0gqDW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789126132;
	b=ZEmERWgygpRydtT7I0GYKwc5DJ6pw6KAISenrnl/iPKVtfGXMKSWqG+u1OtDpw7sAIVhoh
	QO8ySAiOE6VEkvmCR4QkKHCC7L+4ZVeeKKnR1BU0XeJYX1RsqADIqwTVfLLJtvvFh0h4GQ
	4X67ehHubrwA8xcO7tFypTlepnVEX4c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A2f0gqDW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789126132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nsSRp8PdyK7jqxwyqAHoe3K2myVb/dPcJ1AFVgoBhm4=;
	b=YEs9K3gPXWwR3OHlo8poK4QGQhofwGY4K3uxUshdoKDxbwqcltYN3gNqiTIll4TiFQIFTi
	5vUPvpqv41F25KUUVRqDNVW4Zt6UgANuM9JdmOh3yJiqn7GptOWtq9nKbBt4f+WCe3ycKT
	DS9v7jn9eGxjVg+EcFUdfsS5nukgfA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55E81415B4;
	Fri, 11 Sep 2026 11:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF971F0089A;
	Fri, 11 Sep 2026 11:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789126131;
	bh=nsSRp8PdyK7jqxwyqAHoe3K2myVb/dPcJ1AFVgoBhm4=;
	h=From:Date:Subject:To:Cc;
	b=A2f0gqDW7IjntqtLnmWTY9FTZt2kpRTwAR81OQ0+X5rLtkU/oM3woCD8mBXpKl22g
	 FxYe3TsxS68ynHwnCCJsl1bwPDgBbcj3b1Txifi+2tin8nkRKoyJzvInE1BZQaJEX1
	 SfEvjpltcAkNn5xhvf+Rc0Gw+3IiqappNVYNQ4vVHGBz9KbXFSFUbvXeKjGQTNnKQe
	 oQ8qUrbxCW07kqROwNWcZveAksa3yuRMFG/yhKpWZZTaXd6Lv/XEL9aASh6XtvTLuq
	 biMrXtbaqD7QwD7g67lAzMIJsCVJbU2WmOQf4Qz7SKN0f6wro+FrvrrGb/qQcA7fJ7
	 xshTLjIDUbIHA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Fri, 11 Sep 2026 14:28:43 +0300
Subject: [PATCH v2] x86/mm/pat: use pr_warn() for early W^X warnings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-fixes-verify-rwx-v2-1-e2cde39b6693@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2O0RKCIBBFf6XhORSRUeyp/2h8AFuVSnQWMh3Hf
 w+sx7N7z93diAM04MjltBGE2Tgz2gD8fCJNr2wH1NwDE854waqM0dYs4OgcrHal+FkoE0KKTJe
 FyiUJ2oRwZIJ1q3/s3voBjY89MaGVA6pR2aaPI2+mdJFFOgxx2RvnR1yPh+YslvxvM8kqXuYsE
 SwwlzSjOE3++gS08EpG7Ei97/sXW54AzNIAAAA=
X-Change-ID: 20260910-fixes-verify-rwx-044841b76a38
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
 Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
 "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, x86@kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5D0DE1A0006
X-Stat-Signature: osttnbonpkf5i7uipid7s3dsmoo438nf
X-HE-Tag: 1789126132-846061
X-HE-Meta: U2FsdGVkX19mcIX3mSPWL2GlANf7CuIiZM89ADRhkKVpN9MrkxypYdBgmY0+goXT7gxzXbthIHwopGhRqr7CGu1shhYg4u7RJ0WdsQ+sArpH+iIKP4NDJCCeM9b30YIhYASeeWfu9PHtPRTydpqTdH6p5n2cOMeZVfAP+WcJjjKAQd0y2/OOs1CeHliiPnGFPLv/MywePMggqZz5hGUVxfbgl1W+fVOhhlxxDl+wljHuparIH/AlW0PUZU+VB4si/Myps5r7h167SBrJMbNyDtPD1AXcJQPeSOV7U8d9y26derBXF8WB3q4J4TsNeWCBdLIKMkZHC8GivrPHM15FbMsdSz3iKGTISbfXzg0Us0pM8BusXMA43NKpKIJNluiCIhJIwqbuYHO6R4Ho99swCPjxB/sc3vbcfjFE3qbNWHxx8K6ZrK2zfsQ4PQgVwOFdt5VsZ0ERiVIfko7chChtA6aXhF3GXaML9COtuFkxZNNBCslel6rU85czPe1mgAMZz8CEKprJmMQcHls1lbdgxI1hz0JBobYUbJnv7yZuLu4sMfbYX38Cx3AESdLXbmy8MrYrz03HG9aNPm93v1IaDIIyh9kUEEQ/IqVO9sA6lwSsN1V2dxWS8slSNe9dpzs504LKj1SJ1n7arOfTd2ThtWZH3IZEaPvXiakliyxkGQ6QT/USIzc3ar4Ji1pLEmFmgjh/lQmnGuuKcyQgnZKRdOPbFvAEZKxaU41YuJnioC/47vP2wYDHx2UARru/JVT1RzBsO7c79pZ4+J96EUpxknDsqVQElDQUi12OdcY0A2Mx7BFdBcHu1USTkUaKtCs83U9OtAo3po4bNjMGM3GJCFUyVZVyItScxZtdu58cuIrNHQKEdxm7hjpQpr6Mzc1k4iMo34MwQeNGckjfVnzcG5c1AcLEVp1nfmIFajcJ5Skkf2BXwtAujM0ZyhYTBV9meTJ34hQuLGyE/mNpB+A
 QCcjMyNY
 vELpCMNHcrc4egVLGB8jJlzk5pfSt1Ar981ZzYVCApAm279gX6MWFDBwIW6DuERLvfCH6Nn7AU0Pm4/ND3DRGsFdcWAbpERcmu+sJkMn8qE7n6f72Y1HPMejZvyqPXEzrwAAKNSfjZLcyS5zljfFfCyhohQvH62Uax+cUi8cFbCxU4BI2i1zjQTX/Cki54mA3LB3hfMzEhiBVvpOox47Wh38uDKzc6CpgQzoBxaP1PtksY3a0v0HMl/yiyuR1LhBJJWeSUiS7hOeu06/+xetdVBcajJMOKaupgBL/cifqT/C207+KTw0r6d3x8hFT6pjKl4vXQQkhhZuw3iw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nathan Chancellor reports the following warning:

  CPA detected W^X violation: 8000000000000123 -> 0000000000000123 range: 0xffffffffc0400000 - 0xffffffffc0400fff PFN 100e00
  WARNING: arch/x86/mm/pat/set_memory.c:722 at __change_page_attr_set_clr+0xde7/0x1290, CPU#0: swapper/0/0
  Modules linked in:
  CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.3.0-rc1-debug-00006-g453e78594434 #1 PREEMPT(full)  2950d432dd3910251071a66f3134fe0875432786
  Hardware name: ASUS System Product Name/PRIME Z590M-PLUS, BIOS 1801 12/26/2022
  RIP: 0010:__change_page_attr_set_clr+0xdff/0x1290
  Code: 80 7c 24 42 00 0f 85 3a 04 00 00 48 8d 3d 19 8d 79 02 49 89 d9 4c 89 e1 4c 89 d2 4c 89 f6 4d 8d 84 24 ff 0f 00 00 4c 89 14 24 <67> 48 0f b9 3a 4c 8b 14 24 48 8b 0d 81 44 bf 01 41 f6 c2 01
  RSP: 0000:ffffffff87003c60 EFLAGS: 00010246
  RAX: 0000000000000002 RBX: 0000000000100e00 RCX: ffffffffc0400000
  RDX: 0000000000000123 RSI: 8000000000000123 RDI: ffffffff872e50c0
  RBP: 8000000100e00123 R08: ffffffffc0400fff R09: 0000000000100e00
  R10: 0000000000000123 R11: 0000000000000001 R12: ffffffffc0400000
  R13: 0000000100e00123 R14: 8000000000000123 R15: ffffffff87003d58
  FS:  0000000000000000(0000) GS:ffff8ad1777a7000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff8ad0a4201000 CR3: 00000007e3022001 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? _vm_unmap_aliases+0x219/0x280
   change_page_attr_set_clr+0x161/0x250
   ? events_sysfs_show+0x5d/0x80
   set_memory_x+0x39/0x50
   apply_retpolines+0x656/0x6d0
   ? events_sysfs_show+0x5d/0x80
   ? events_sysfs_show+0x6c/0x80
   ? events_sysfs_show+0x62/0x80
   alternative_instructions+0x3c/0xd0
   arch_cpu_finalize_init+0x130/0x190
   start_kernel+0x97d/0xa10
   x86_64_start_reservations+0x24/0x30
   x86_64_start_kernel+0xda/0xe0
   common_startup_64+0x13e/0x151
   </TASK>
  ---[ end trace 0000000000000000 ]---

The warning appears because commit 038176c21617f ("x86/mm/pat: fix
effective RW computation in lookup_address_in_pgd_attr()") fixed the
effective RW checked by verify_rwx() and it exposed that pages used for ITS
trampolines temporarily have RWX permissions.

The permissions are updated in its_fini_core() after all the ITS
trampolines are generated, but since verify_rwx() detects invalid
transitions, it warns when its_alloc() makes RW memory executable.

At the time of alternatives patching the entire kernel text is mapped
RWX, so the warning is bogus anyway.

Since the verification of the entire page table with debug_checkwx() has to
be enabled explicitly in the kernel configuration, retain the warning even
if it's bogus, but make it scream less loudly: use pr_warn_once() rather
than WARN_ONCE().

The warning can be removed once debug_checkwx() becomes unconditional for
configurations with CONFIG_STRICT_KERNEL_RWX set.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20260905044253.GA3816371@ax162
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
Changes in v2:
- Use pr_warn_once() for early violations instad if skipping them
  entirely

Link to v1: https://lore.kernel.org/all/20260908092730.4002628-1-rppt@kernel.org/
---
 arch/x86/mm/pat/set_memory.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index b3060000da8d1..a4f7fe69e6922 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -697,6 +697,21 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 		return new;
 
 	end = start + npg * PAGE_SIZE - 1;
+
+	/*
+	 * If the kernel text is still RWX, gently complain, this could be a
+	 * false positive.
+	 * Once debug_checkwx() becomes mandatory for CONFIG_STRICT_KERNEL_RWX,
+	 * the warning can be removed completely.
+	 */
+	if (!kernel_set_to_readonly) {
+		pr_warn_once(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
+		  (unsigned long long)pgprot_val(old),
+		  (unsigned long long)pgprot_val(new),
+		  start, end, pfn);
+		return new;
+	}
+
 	WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
 		  (unsigned long long)pgprot_val(old),
 		  (unsigned long long)pgprot_val(new),

---
base-commit: ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482
change-id: 20260910-fixes-verify-rwx-044841b76a38

--
Sincerely yours,
Mike.


