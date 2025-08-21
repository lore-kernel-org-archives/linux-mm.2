Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D76CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A8E8E0041; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2C38E0013; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1908E0041; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB5578E002F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49F3C588F5
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:27:48 +0000 (UTC)
X-FDA: 83800539816.27.EDB8A50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 61C764000E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:27:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uaHLmxt2;
	spf=pass (imf17.hostedemail.com: domain of devnull+schuster.simon.siemens-energy.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+schuster.simon.siemens-energy.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755775666;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzD7omX0u9H3GC7jMcYIsrU7Gs9oUbqzoWe14sLXB5U=;
	b=T1o8oAE9NxC09DQhEC/mnlAMQoX3l2i8+aw9CKrPSpgCdN7QpnQFrczsse8y+pjgnV8T2x
	hSBtmWWjndBBBWDVhQ5gOSYKx21MBn4PeO6Jh6QIQfaSAhjb+Vpn9YlIx38edEDp8C8sAa
	zy0bUkdKbm86pk7bQHvkGkU4tpiznsE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uaHLmxt2;
	spf=pass (imf17.hostedemail.com: domain of devnull+schuster.simon.siemens-energy.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+schuster.simon.siemens-energy.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755775666; a=rsa-sha256;
	cv=none;
	b=qIvgzq1Rpsa10hZh5ZAJC8czd1I5+e1Skz3Hcnf/4l6oQvRKKqk526iUoIAVWttglmylY+
	R85jItrEhiyhPTMuDdow76yDE6cKUywWE1z9JMvyO/bxdJU6zD4Pc86WK01ul+Usklcx4N
	U9Hv9pkVSUPlr4d6batJHhhQ3VPEI6g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA7D761152;
	Thu, 21 Aug 2025 11:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3263AC4AF0D;
	Thu, 21 Aug 2025 11:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755775665;
	bh=TeLiY9rWYgwluzznmA5sBvokJ7kYB4xX6yAp004tkOU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uaHLmxt2ngLqc4XdyTaJFkv9X9g0lcA5Z9u5bJc2CKTFebgLtws/IxWUVYTB4/he7
	 KwHF8rvP2jP7Cszdmgi0gpDM0++ZDDp2wv3LAZ8X1Bf2O3/8yDbPNg7xpCYsA49fC2
	 yJ+TFi4wXMdPFswab+cKObwNqr/QBh/LBi73aYWIoxAQ29Giyw1b1I/aN2rdCYyjK4
	 mEcrKGwlrqCgGTqQnZkS9GVJ1yF7awn2q6FB2HEFtDboM/pQgj959x8aZRXyPSvOc2
	 V//jTV3J5SdSAiwWV/w4IK5NZ86BduJ2huSiJ3wsVCmjkykQ8pmWKRyeztfGpCP5/Z
	 nlaOOZwUWPtpQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A42CA0EF8;
	Thu, 21 Aug 2025 11:27:45 +0000 (UTC)
From: Simon Schuster via B4 Relay <devnull+schuster.simon.siemens-energy.com@kernel.org>
Date: Thu, 21 Aug 2025 13:27:38 +0200
Subject: [PATCH 2/2] nios2: implement architecture-specific portion of
 sys_clone3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-nios2-implement-clone3-v1-2-1bb24017376a@siemens-energy.com>
References: <20250821-nios2-implement-clone3-v1-0-1bb24017376a@siemens-energy.com>
In-Reply-To: <20250821-nios2-implement-clone3-v1-0-1bb24017376a@siemens-energy.com>
To: Dinh Nguyen <dinguyen@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Simon Schuster <schuster.simon@siemens-energy.com>
X-Mailer: b4 0.14.3-dev-2ce6c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755775663; l=2259;
 i=schuster.simon@siemens-energy.com; s=20250818;
 h=from:subject:message-id;
 bh=ZGFd7PEXdNZQ3XvGm96hBqrgf0z3Sn12r48TmNzThTY=;
 b=F2nKl2igsmfyyDF/eUV0oYb5mlZJyimIpk0NXRJVrpnKfItiOUjRR+lvhtzDMtKjVJKvuPs+u
 3hz69QALEOGCg5dAKDF1klwR3WkvjnC1lV0TyZQ2blO79aj8xnAMWyK
X-Developer-Key: i=schuster.simon@siemens-energy.com; a=ed25519;
 pk=PUhOMiSp43aSeRE1H41KApxYOluamBFFiMfKlBjocvo=
X-Endpoint-Received: by B4 Relay for
 schuster.simon@siemens-energy.com/20250818 with auth_id=495
X-Original-From: Simon Schuster <schuster.simon@siemens-energy.com>
Reply-To: schuster.simon@siemens-energy.com
X-Stat-Signature: 6wewjdyyq1jgk8414kdzr84nsbchox9w
X-Rspam-User: 
X-Rspamd-Queue-Id: 61C764000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1755775666-796855
X-HE-Meta: U2FsdGVkX1/LVBhFFy/ieFTqOTbMyl6oZtpWbFNvVS/x4dCjEtm7gt5StnTcInR9SVRSWjPJ5wFyxa98ss+lLyTcLsikdEozi2VZiY2P4d67xctwkI5rdXRCjqkHPyaiBbJ23FhDNGI1pmg28FIB0CpZaENMeHvddVshQdjzFjde/0R4mWNNHo8QNoAJ8+xNo5RVtFSbWp3aapZWWaYIcIG1XBDwWskRC9kcQKLM8EyIWWjUwEz6Nc0q5h4NBgBxKimDeIlIDCrKThAQKaTI7YirsdjSiNTZBApJivbCdvDouvw46lu3HEN3hiL+3dTcgQWslwtOjwPvzyHzYAGsOVMlP6KeOYXhy92v2uFuzQozPS+yT6tksvyI5mlsmmFwOEdc1nMapNUVyr1VN9hdfH18LOkGGrx6aycOyyiYGtA8NBlnkZGqxPEz9Sw/vaV2PerQRkzVUsYQAcRrAcya6APwPo528cKWmm9KZTHVGp0ooNlkzJKhpgRRz9ma9XKIf1dt14Rp05Ot10OCOrXoWNIoQ0fPQo3YuOJS3tB5z943QFknNWjE/0j3I3UPKic8qB1nzN0MZaDHqxFHbKtaoZa2w4HUH9iaP4wr7QoDE5FYbWMquSp3tOCWR9+AhVZ0N+caLddYucYhtRYafD1yWpAjqqgv3R5enSzKaoyh2lcqlzge7gvG0PD8mKuZ6Huv5EgDcFbjAHhtDHnocdbm0ZoKMc+JViKo7RhjT7VAUktqUB/tnTitCtgMIyupdkTzZKfMn2Ersx6mQ+SV4hLLxajUhNo0DBHQYyeDtCRSoEV5Q6aWbIFBE4j61Ke/yxX8OG62NTpJusqDqAhbgQ/pyzaqlmkiq8No4CFtA85M51kgiYSHaCjlSwVNabM0kuOjszGs5bogdzpwkKDuD8z2S9vG5564HJn+3jVwgLdsqn7uvdvcF4pWiiSijeXGPwmICMm8rbRf5JWSGPs+Fo6
 EYG/skJk
 ZuizAFjkuzXDW/WYPqKsuvYFFvNpgFw3NyDN8ZRb2yr0QGHgLpfjHh2qaxa8mrKiZXpOhTiBMc4OrinToxT97IG360a8HqaNO108s+S2K5OP8dIIUuiZk+7AExdFN8bQ4HV2dVjI7gX+siT5kJ7UidZCDnEvhMRbcyaU66o/bkFPC6JLFMsoeKKMPpj+mR/QvgTxPmfWMlp/AYpw0/Z/9TCMyTrhOYf7/1UX4ehmBrKuh/2yAw23HNTsH1X6YS6DcrTIWpACyPjdCAb8xLisd1PSUHklY2bg6Zz76yFvQSRktUC04uMZBjiaBwKcpz3KMRrAGeUfUA9bBSMPEPb9JevKZXth2+zYhtXGFYaC01Y0tvI6tUOUvV6iBCAtmSNRqT9jgWY00hD2Rcy37ICGSqLLocLHkeKbT01F7gxBuwxnYnEfH2R/WAK64fRcOU/hX2G7JVzdTnzyVnP5pb+HqxOXReIk55HjQ6lAg74rIKs38tm1lKxgJzPP9w12eoCZinWOeheCz5IYsg1YAX4n/YsDfSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Simon Schuster <schuster.simon@siemens-energy.com>

This commit adds the sys_clone3 entrypoint for nios2. An
architecture-specific wrapper (__sys_clone3) is required to save and
restore additional registers to the kernel stack via SAVE_SWITCH_STACK
and RESTORE_SWITCH_STACK.

Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
---
 arch/nios2/include/asm/syscalls.h | 1 +
 arch/nios2/include/asm/unistd.h   | 2 --
 arch/nios2/kernel/entry.S         | 6 ++++++
 arch/nios2/kernel/syscall_table.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/nios2/include/asm/syscalls.h b/arch/nios2/include/asm/syscalls.h
index b4d4ed3bf9c8..0e214b0a0ac8 100644
--- a/arch/nios2/include/asm/syscalls.h
+++ b/arch/nios2/include/asm/syscalls.h
@@ -7,6 +7,7 @@
 
 int sys_cacheflush(unsigned long addr, unsigned long len,
 				unsigned int op);
+asmlinkage long __sys_clone3(struct clone_args __user *uargs, size_t size);
 
 #include <asm-generic/syscalls.h>
 
diff --git a/arch/nios2/include/asm/unistd.h b/arch/nios2/include/asm/unistd.h
index 1146e56473c5..213f6de3cf7b 100644
--- a/arch/nios2/include/asm/unistd.h
+++ b/arch/nios2/include/asm/unistd.h
@@ -7,6 +7,4 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SET_GET_RLIMIT
 
-#define __ARCH_BROKEN_SYS_CLONE3
-
 #endif
diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
index 99f0a65e6234..dd40dfd908e5 100644
--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -403,6 +403,12 @@ ENTRY(sys_clone)
 	addi    sp, sp, 4
 	RESTORE_SWITCH_STACK
 	ret
+/* long syscall(SYS_clone3, struct clone_args *cl_args, size_t size); */
+ENTRY(__sys_clone3)
+	SAVE_SWITCH_STACK
+	call	sys_clone3
+	RESTORE_SWITCH_STACK
+	ret
 
 ENTRY(sys_rt_sigreturn)
 	SAVE_SWITCH_STACK
diff --git a/arch/nios2/kernel/syscall_table.c b/arch/nios2/kernel/syscall_table.c
index 434694067d8f..c99818aac9e1 100644
--- a/arch/nios2/kernel/syscall_table.c
+++ b/arch/nios2/kernel/syscall_table.c
@@ -13,6 +13,7 @@
 #define __SYSCALL_WITH_COMPAT(nr, native, compat)        __SYSCALL(nr, native)
 
 #define sys_mmap2 sys_mmap_pgoff
+#define sys_clone3 __sys_clone3
 
 void *sys_call_table[__NR_syscalls] = {
 	[0 ... __NR_syscalls-1] = sys_ni_syscall,

-- 
2.39.5



