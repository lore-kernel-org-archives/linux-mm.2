Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E117C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0C76B008C; Sun, 13 Sep 2026 03:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63036B0092; Sun, 13 Sep 2026 03:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78516B0093; Sun, 13 Sep 2026 03:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B25DE6B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:37:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE46E1A061B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:37:36 +0000 (UTC)
X-FDA: 85207934112.16.947AC6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A4FF180003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:37:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jD/pKnFc";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kENY6vTLb3k3xzY9wWud1EJa7mum1nmdexc1RLTPIWo=;
	b=3sqQG61aSD6AmnAbvHH+szoBoUa+ggYbGHDnhTnuDD8keCCDxKAots3eMFWIUq1Lm+Dau4
	FWOl27AKMSVUexAKq0d1ylOZlqNfXDBmg38CeS9FhveDTUwMxqxT62nK/iGrYyFZcbO9Pc
	Vz+zGrAZtPf9Vttp7D5vSOG7S/1UqIU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285055;
	b=C6F8bRWR+6xWp04jwQ5LnvRXLACLQPrGeGbDXYIfArnQYqY1eXbWSP8UFcnnTAo+ChQJGX
	rixtVGkjpZyNASB7LR6PjJJiTreHOfNLc6uZGnrTAH6tde5i9EKkzgG62pTUTKP0+UUHMr
	p705pGHqBnWKaUFOOHEEJ3mMf6QKZeE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jD/pKnFc";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C899460D8D;
	Sun, 13 Sep 2026 07:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EFC1F00893;
	Sun, 13 Sep 2026 07:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789285053;
	bh=kENY6vTLb3k3xzY9wWud1EJa7mum1nmdexc1RLTPIWo=;
	h=From:Date:Subject:To:Cc;
	b=jD/pKnFcs/SmCcOj/dmMYFcvawtFKa64uwWJVHDsKIgTwun3UP1+/zBQFRMob0zms
	 A3Nlfoq1Kqxbx2cpVpZbZJppHeOSGQjAO0zqgGNdmC7Fcyysyete9bdNkwhEW3X5fH
	 59/Obh9+sB5fuzloRF9SmowQdw/v+b2J7SbMpdyEx/hApGxiT5teQdHJfCs20EemKK
	 MlouMr7gGaLYJfDEAM3czrcYtB0sIv42x0ZIvrHE0RgLfP0PahSHaLhTumUfzPVz62
	 58AP9U5bA7U25FQdAdWKwYycKTVH2fqyaEh9XePrOiZRO3bxKbg5cEv4Xd0tnAsvOn
	 xTOiG4s0FoujA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 13 Sep 2026 10:37:27 +0300
Subject: [PATCH v3] x86/mm/pat: use pr_warn() for early W^X warnings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-fixes-verify-rwx-v3-1-5e1d6a08bd02@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WOzQ6CMBCEX4X0bKU/pBRPvofxQHGFqvxkixVCe
 Hdb9aDxOLvzzcxCHKAFR3bJQhC8dbbvgpCbhFRN2dVA7SloIphQrOCMnu0EjvpAnWeKj4myLNM
 ZN7kqpSYBGxBenkAdjm/t7uYC1RhzosOUDqjBsquaeBrtkE5apW0bn411Y4/za5DnMeTTzTQrR
 C7ZNmNBC005xWEY91fADm7bHmsS67z4Yjj/3+tFIEFUJ5CFUaqQPwnruj4BRLfqkxQBAAA=
X-Change-ID: 20260910-fixes-verify-rwx-044841b76a38
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
 Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
 "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, x86@kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 19u1x8z73omqog766if17rfck5udik5x
X-Rspamd-Queue-Id: 3A4FF180003
X-HE-Tag: 1789285055-612578
X-HE-Meta: U2FsdGVkX1/RuxSdEBhNZs5Eqjti/6vXtuaSVQu09UE2w8eX73p6mjUWWhTe7PRJpZajGFg0LuBWFS6HXvaZ+mWig9M9VrzotzFaZxmBXn+v+tUqfN/XyPBaJ4reIBAaWLczyNcWy6QLh60vVZfeFbd7j+q0RZLmxmzmrvk+U532JQtcc8iy1IZuL9LWfXxZBEaC5XCIDkDe0DfWEeWhFCN5+un6LrhfCem8XH96lDeO1TxIQH0ZrxdiG9n50MDKNMkqWK3MESgLQb04i13nk0CYHX2hOpMtrbrxDbfM1oRsKBut9MqMukQVt03Tk4EGCJu1HA6i616ZZlxRsXceRMluqyc1kTzHTqVoaK0UCu3zl0u6JTbDl3ZZJh0B0WMwWTVzA9sTZABBtGBgNNHrrUVkXOrVoyJXbZ/6HVjwYYqMjI07J3zzLXgtp3sDjghOw8UtH7IuH2AU+8USfP189+75pyQosU/aaqqb9mMs41ThBSgjIG8vt/mIhWdMq/cnqbXx6lXYJdjIznE2XKC4Iv50k0nvtAlKcj1i3FnZ33SGoTq7wc9iWQVoFFcqsuXlqCWsQz5teC4+GQk7H+CHLJiiEei3cgD5W7pEAP3lAoAKGmKJZlEQ+OsawektTX76a4N3zIUc3tf9rJu3Qs/nCuFZoJ9h4gyMpWL+dr6biikZS2H/NyI+0PRHUaYCGmye5tWjDhHGRVXoa7UVDzNFl+DLIq7ZculyECwZ3L2W2JOF+jyk7LaOTpsLBpxPjcIjJjjq1SxGvUa9SSX/WA8OrdMF2+5oJD2xNfD9RB2M81CyYP8AWC8xcXW8GYFHiiOHg+BMTfde2XHKFsuxKSVxulrgB56GrzmjcEzGgRMTS0hr0jpwTbx8wMCf52ShgVd/tu3Olr6687hzXT3L5Dg7nJa2fcIfzYWX65v2GeQGA8dOMASMTyC5VGE+1vw2RRSoSJJigwwXZEBZCQtDxml
 MOM3vTVv
 Dm9zsMWeG1Vq/CotnhemTUQjYEUnyQc7wcBWDxQkOivIAKdjkEkXWjjXKHzVdsiFu1/4KxSn/raS6WDK96wNt2dieENZUm6gfHn5m/wphilNG/4vH/62kInGytvAjuMaMhv6adxmw220rXi0ppnKZjMTY0s1SZmjofJ4iBqfEybLjVgLjmhPaEdDvLO/cudzl2uHFGGwqyCsy3+jcMpsz49IisZTxoeTSBtPP/D4wwAKVO0J/+veEaD8nhEVozxQTRpZ8pLREfylsgzhsHMwLw1lyGwcWV860pjG4e91dCE3sO0RpufGyHvFYhKLgJDsDUSSN9ZS1K17e36qnfO+xoTilBLgcVJBD2//kZQ4hqzBRg4fpc5LVuekWnQ==
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
v3 changes:
* fix stupid copy-paste error

v2: https://patch.msgid.link/20260911-fixes-verify-rwx-v2-1-e2cde39b6693@kernel.org
* Use pr_warn_once() for early violations instad if skipping them entirely

v1: https://lore.kernel.org/all/20260908092730.4002628-1-rppt@kernel.org/
---
 arch/x86/mm/pat/set_memory.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index b3060000da8d1..a799f539287e2 100644
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
+		pr_warn_once("CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
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


