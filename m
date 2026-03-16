Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01473F30298
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 03:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB9A6B00FE; Sun, 15 Mar 2026 23:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179C66B00FF; Sun, 15 Mar 2026 23:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E326B0100; Sun, 15 Mar 2026 23:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E58016B00FE
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:11:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72D8DBDEEF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:11:17 +0000 (UTC)
X-FDA: 84550450194.02.B730804
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3835C120002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:11:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=Yu1LUMKn;
	spf=pass (imf29.hostedemail.com: domain of eadavis@qq.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=eadavis@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773630675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsExrWsQ3TdTm+Z66cknxvj6Y+enEEHRqpyOaJkvHxQ=;
	b=jhgfsQiSYskjh28rLb0jISsmLNa4N6cQVulfLuqvK1zu12QhWonctAhiN/ZZIelGOqqqIb
	gs7nF9ptuJC0W2Vv/5RufZkpVkBGNmI35QJKfhpqg2Sk+p1n/+7SfRjLPX1bqH+AD9xQoA
	IvJs8MIK/Z2bDU3osCIgiHbqs1KTb3o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=Yu1LUMKn;
	spf=pass (imf29.hostedemail.com: domain of eadavis@qq.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=eadavis@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773630675; a=rsa-sha256;
	cv=none;
	b=Aq6By7xl4YwfYDdZKjauWqzFIeCt9Z5g9QVpng0ENi5tMgPYkCR649lEO0CPUznGFyR92h
	IqZ2CyMwZDXMz3AVkfX4LuMLgmDQmY9zKE7P9JmVEt3M/GLLxMMTJke3j3sbERG9dzCD4+
	HTMbeTLYomM1RyBIwJmKOX1T+4eY4Zo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1773630666; bh=VsExrWsQ3TdTm+Z66cknxvj6Y+enEEHRqpyOaJkvHxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yu1LUMKnJ8SLXnELcv521mJlQFprPngfkEAW/bJkSXmyy1hj8GC0rsn6G48c1UqUJ
	 QB6ix8kS55+PoHM/KZjKL6O40MQw/AA4bZ2XoMENVyOYqxkD1QBabYonJ0/08AFUlj
	 tW39reMY7+UEHisadImcocI2n8/JH+Z9MXcIGQX4=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 2C38265B; Mon, 16 Mar 2026 11:11:03 +0800
X-QQ-mid: xmsmtpt1773630663t7uxyew6v
Message-ID: <tencent_C43C1BB425D6BA16BB6533FC9E001BC64B08@qq.com>
X-QQ-XMAILINFO: OYPw5v5I6lYzdd5v/VRKtjyLCIvI18eJBRu5n2hBgKUeG6obNoBooEPKfrI0zJ
	 PLYqlPtlCgI6msCfUlsOT90JmaPWTec/99lipqINpmAI7jYHESGYhkdAEIVZ7cBGUXn0DGGeJu4d
	 BAzMAwiuGJl0GSSX/dldSX1pyyx8iFmp/mzrg1QO3apEQzecZ19loj75cChR2MLqH+a/NroEehJU
	 xV3vkfwrtrGAgfNRmpFmk2U4/sVUdJ0Gg4pn8UJW6wXzxZPjbQhHo/f+VMQ+k/YpyByuJSzmVjlp
	 h5C+odIf16X4H2TzIFqH4Q4OqAvUCFcvAv0ojo62KZR8nFCxzJ2T6MN7boYdV7+DfiGa3iyuP/rt
	 pLMlenwZwbGCK6RBGnWrQ/0JDEqzI591N1JEd8zlIfo2z9wDEK0BKHL9iga+RS9o+gnHHqN+BkSj
	 p4uV6VcqffC36eUYNqHFYFmevq5rMcsiLYmFWSD0f3qhnG9lOp93iJ3IbrxAdDbTnbTQEjqzM739
	 ycdi/QQqbEw7uuYI4dDf8uCOyLTNp4MdfyEKGlpjywtvumH1qYtUdwh4McDdfocIHTFoJbJgJdGz
	 9Y3J9r/S31SrbBEkLYRCkV8pektpou16iOULjvuLdKMKr2hkxG5CJWelivIPfq8D6dPYPOPSmjPN
	 XTDUy1jnObL2B6EBUeepRNFJbLmT1dkXAi5xNePWudlF5sa97uMjrs1V/grjZ4/Z5OvMsLPju66f
	 +zPzid1rwjYJ8t+iDo6NO2X8lfAQtRoyWSdIusu2P+PezBE5dz+kyx+vNjYO1kZNV7URqQ0yBMM8
	 cpxWMAEhQCH/wB5YePiQax6qkyp5/1icYyIFpTD09vrUHR0G3JVFdRo8A35M5BM5aHSxsKD4riwK
	 FikfvTqSdixMRqeDhdsUCZvGCGnLajpKRh+X1Dw5f75G0Uuypyk4t1ap7GL+lOZsc6/lFtAdCbmX
	 2BkX4qxjh+OwTeZ7lhWg8Q0AwkCPpkSWLTYlUipg2s3DpXDNhHU1eIo2SYxWkAOOPgfizPhb4=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+c473aa669b5e8a6f48d2@syzkaller.appspotmail.com
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	peterx@redhat.com,
	rppt@kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH next] userfaultfd: unassigned vma leads to a potential unreleased locks
Date: Mon, 16 Mar 2026 11:11:03 +0800
X-OQ-MSGID: <20260316031102.126301-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <69b6fc68.a00a0220.3b25d1.001e.GAE@google.com>
References: <69b6fc68.a00a0220.3b25d1.001e.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3835C120002
X-Rspamd-Server: rspam07
X-Stat-Signature: supqgtj9oofqoc44jgi5tpzbdmhp5jc1
X-Rspam-User: 
X-HE-Tag: 1773630672-48749
X-HE-Meta: U2FsdGVkX1/XmwHJQkp1qwUiNcn1ne6eJI0HL2SL8hSHlhwa/h81f4ml/p/3JLM4OCY0HeRtXpjRuAwWUd3J252ksvr11dILsQNBmzPv3lc+P5mKurmz6Oyut72Qw6bozb5oi1EvCzT4T/Ejgb4EaNnn1CzEAEaQWGq2tcv+XZDbkKGOrYfjONDzUy3G1eEhTfFC7vRnlIZpKZ/KkuhjuZKgWB5gVcegekcLZ3Zd03M1RHXfu/i53V5K12TYRlH8dwGV+xtVzxvN+/GzPGHYsXSLDLBHMWgWXCRmsxFmfOYwh2xlB0NGGIfh/Y60PBXahjRLAESUqNHblipbZSETZscmkFBBfovlY/OuK1+W+xZlwSRr7VcttK5oqC/wcS/rlsP/99+6Pm0E2r+vHYy20b6erU4EnFE7KSzRIMdpmT4L3uEBbwwEM1etw3pVL2vJmEedLeUXaZPC6yeMhtmgTZZDDlqMbViuz/lE80R/lRWFPE5C1i2AoH+zwTyFjoZA5zagZj1dXFItvpO6s86whgrTXARu1PDGdiFR0qlKG/aMPSR5vIXP10WAIDkt8VTHZ2acT9yo0ph2jICAhC2FzWVzDkDhXeayAgKr+uAK9YrtTRSERTAl7rQ8q501fvEEunSpmyxK08h2ByNguL5LAv2kJMuxf0fXN/20pFmfaMVVrrpo41YWgZoUgnf1ydtqDu0F95H1nx1OycRtS5TUL+WnHAyXULLDGLZasC9cODXB6/w6C9ES1yhqczy6SfBozrcOMt96nj8ld2A8t9wXrPMRZcEK0WPffqCTXFrZ+B2Ee5aEC80lLy7R35aBMe8lwsaG3dKwFMEJYKU6NoJLn4ytMIkVDwjsziE/LciLXbh82RlcejgLvad/nS+Y/VLpNRnCVm1wPrk9WR1w0q27hZoVpuRbbH4D+2xLT+RNfEpCE2Tz0aVt6a8rtfYHHK4ejXm2LoVJZ453ipZWcMF
 35nYMARf
 OOq0RZCmkD4ApI8+Hcy6sHvY0C+ZJYz9UuqrFy2QQQwP3Iaes1QsILXMqloqUwvZxn7MJMt1kzmQyN+rpUshWBRm3L1gEghl4XFdkOepWBmLc0T85G0iq1qGfKVLR3iBcLq46twEeotvVjW6/CkoMKjhsE8ICv0VVvJMi/LGE07srg13a8nYz2nX13JJfFGWnYYNUoNn+hjoFBqgj9SYt/GjWppiV1pBkGE4F45OseVeWzPzfNvKWUxGVW2wfYeCydDUPZ5cWcUzeAqlANQSla5EUTTWqLsNlIfeThCN1c8FCJo/EdoaFtgM/3RHKkbre/JGkQo/P/FiyX9HlFHeObkNuBkJSogzxovrG8RfZ9G4hkwp9UlhH1179Q/Y/vkDBzC/hmIejKlVoJq6ucpP7JPb5DYHZakqL4Phh2GXYT/mZCXGIrZRaqQ+Fsos3mV0bkjOqj/oMQ6uNl8A2lOEwafI9RircQBEtRAWG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A deadlock [1] occurs in mfill_get_vma() because the locks mmap_lock
and map_changing_lock are not released; the failure to release them
properly stems from the assignment of the vma variable occurring at
an inappropriate stage.

Moving the vma assignment operation within mfill_get_vma() to after
the vma has been got.

[1]
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5990 is trying to acquire lock:
ffff88802caef3b8 (&mm->mmap_lock){++++}-{4:4}, at: __might_fault+0xaf/0x130 mm/memory.c:7249

but task is already holding lock:
ffff88807cdbccf0 (&ctx->map_changing_lock){.+.+}-{4:4}, at: mfill_get_vma+0x162/0x660 mm/userfaultfd.c:226

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:
-> #2 (&ctx->map_changing_lock){.+.+}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1568
       mfill_get_vma+0x162/0x660 mm/userfaultfd.c:226
       mfill_atomic mm/userfaultfd.c:900 [inline]
       mfill_atomic_continue+0x189/0x12c0 mm/userfaultfd.c:974
       userfaultfd_continue fs/userfaultfd.c:1806 [inline]
       userfaultfd_ioctl+0x232d/0x4c70 fs/userfaultfd.c:2071
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (vm_lock){++++}-{0:0}:
       __vma_start_exclude_readers+0x28a/0x940 mm/mmap_lock.c:125
       __vma_start_write+0xdc/0x290 mm/mmap_lock.c:148
       vma_start_write include/linux/mmap_lock.h:303 [inline]
       mprotect_fixup+0x5eb/0xa80 mm/mprotect.c:768
       setup_arg_pages+0x565/0xac0 fs/exec.c:670
       load_elf_binary+0xc5e/0x2980 fs/binfmt_elf.c:1029
       search_binary_handler fs/exec.c:1664 [inline]
       exec_binprm fs/exec.c:1696 [inline]
       bprm_execve+0x949/0x1470 fs/exec.c:1748
       kernel_execve+0x844/0x930 fs/exec.c:1892
       try_to_run_init_process+0x13/0x60 init/main.c:1514
       kernel_init+0xad/0x1d0 init/main.c:1642
       ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (&mm->mmap_lock){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
       __might_fault+0xcb/0x130 mm/memory.c:7249
       userfaultfd_continue fs/userfaultfd.c:1813 [inline]
       userfaultfd_ioctl+0x2372/0x4c70 fs/userfaultfd.c:2071
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &mm->mmap_lock --> vm_lock --> &ctx->map_changing_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&ctx->map_changing_lock);
                               lock(vm_lock);
                               lock(&ctx->map_changing_lock);
  rlock(&mm->mmap_lock);

 *** DEADLOCK ***

Fixes: 7d4d4de3ac3e ("userfaultfd: introduce mfill_get_vma() and mfill_put_vma()")
Reported-by: syzbot+c473aa669b5e8a6f48d2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c473aa669b5e8a6f48d2
Tested-by: syzbot+c473aa669b5e8a6f48d2@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 mm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 9ffc80d0a51b..a3333d5c6454 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -218,6 +218,7 @@ static int mfill_get_vma(struct mfill_state *state)
 	if (IS_ERR(dst_vma))
 		return PTR_ERR(dst_vma);
 
+	state->vma = dst_vma;
 	/*
 	 * If memory mappings are changing because of non-cooperative
 	 * operation (e.g. mremap) running in parallel, bail out and
@@ -257,7 +258,6 @@ static int mfill_get_vma(struct mfill_state *state)
 		goto out_unlock;
 
 out:
-	state->vma = dst_vma;
 	return 0;
 
 out_unlock:
-- 
2.43.0


