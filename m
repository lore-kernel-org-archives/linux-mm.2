Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300B5606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=insta360.com header.i=@insta360.com header.a=rsa-sha256 header.s=feishu2606151854 header.b=RG6ZdmZZ
Received: by kanga.kvack.org (Postfix)
	id 2AB116B05B7; Mon,  2 Nov 2026 02:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282886B05B8; Mon,  2 Nov 2026 02:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BEEE6B05B9; Mon,  2 Nov 2026 02:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8A226B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:44:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4AC57160BD7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:37 +0000 (UTC)
X-FDA: 85389391794.22.7607917
Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	by imf24.hostedemail.com (Postfix) with ESMTP id 38B7E180004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=insta360.com header.s=feishu2606151854 header.b=RG6ZdmZZ;
	spf=pass (imf24.hostedemail.com: domain of yangsongsen@insta360.com designates 209.127.231.58 as permitted sender) smtp.mailfrom=yangsongsen@insta360.com;
	dmarc=pass (policy=none) header.from=insta360.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793605475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Be7kBnZ2pN0tqA9jaxkboOxPRK3z4kRNDuaOawCuGhc=;
	b=3oO5j9Xk7nlYBdJeBvm4VHKgG4kYk5k16/P1I2PELeqUwJHGxHX/2fwvhj+XOePbHDDSgQ
	hx3r/HpIPLiiqKfmmtn3a4OjS7uqQSI+N9bdFuiX3sJwE92FHIgfGylylKAHqxLfj0zRkh
	OiKW2Q69dCafqfCeO4pjip0ai9Fbalg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793605475;
	b=abzBzuxoiIugc7FWgSsUgre7mUcLNMZBFoHq/MfbFCMHv3okFY0nSLNoiod8O7FGbS8AS8
	15yo4QEyQrovMUrvOQmDFqamoX0kH9jPpvUt+tsvP4FKOm5wJlrlqJXdqglWBsKXBB8LQg
	vowT0mckI5ln/LcWFzvbs9p8Ehm9rt0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=insta360.com header.s=feishu2606151854 header.b=RG6ZdmZZ;
	spf=pass (imf24.hostedemail.com: domain of yangsongsen@insta360.com designates 209.127.231.58 as permitted sender) smtp.mailfrom=yangsongsen@insta360.com;
	dmarc=pass (policy=none) header.from=insta360.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2606151854; d=insta360.com; t=1793605469; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Be7kBnZ2pN0tqA9jaxkboOxPRK3z4kRNDuaOawCuGhc=;
 b=RG6ZdmZZlsQ4o3Xl/+kiZRBQWhJF/Cvfl/+96eo3Y4O922B9L927Sz0R31Gbr6XCHYFOgs
 90EUdkrfwEBdfAu+eSrQpG7+3hBFV1gm8PUdyHzBnz86VuRU1uvocssY4CMLXSWHyZmBlc
 ++wvL5SF50DaNDi0E2Ckqiw2FdqrCwir2VlmqRf51C9zVA/rppUOu+/EVUYgXSFtS2MMj1
 TJnFN4RH6bpw8q4qFLVWsOkWb9cWv70exZmW/k2AK+3zfcYvfppUUvlANwdkeuLqqAAGm1
 6xY62q7X0RoDTNuOUsNGgWBVTYmu1xm3LKanLpKxvR0ogxWaGYdg/GGgfh3/Aw==
X-Lms-Return-Path: <lba+26ae83f59+3779c2+kvack.org+yangsongsen@insta360.com>
Content-Type: text/plain; charset=UTF-8
From: "Songsen Yang" <yangsongsen@insta360.com>
Date: Mon,  2 Nov 2026 15:44:13 +0800
X-Mailer: git-send-email 2.53.0.windows.2
Content-Transfer-Encoding: 7bit
To: "Andrew Morton" <akpm@linux-foundation.org>, 
	"Lorenzo Stoakes" <ljs@kernel.org>
Subject: [PATCH] mm/vma: fix NULL anon_vma deref in validate_mm() under mmap read lock
Message-Id: <20261102074414.10902-1-yangsongsen@insta360.com>
X-Original-From: Songsen Yang <yangsongsen@insta360.com>
Cc: "Liam R . Howlett" <liam@infradead.org>, 
	"Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, 
	"Pedro Falcato" <pfalcato@suse.de>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, 
	<syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Received: from DT-9806 ([58.251.139.251]) by smtp.feishu.cn with ESMTPS; Mon, 02 Nov 2026 15:44:23 +0800
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 38B7E180004
X-Stat-Signature: bcsghqpgw69ksh4upxju7s55mdaxgknn
X-Rspam-User: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_PASS,SPF_PASS,TVD_FROM_1,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793605475-774824
X-HE-Meta: U2FsdGVkX19sHK4B2nYZpv+ZI0iNxCVgQoLM5x16a/JbM1d7kX7LvaOLiuT9nGnr6ppTUVP9e3P6N0pho17wX1ECUx6dXo1OKlTZXZJJNEOKkZ3Rtqf2dXm8iMoXR2Wi6lXODS0Afi96k9r6jTeN+9caMuGHOtvYF2rDWwwvwWaSkC0nA3+ss0ksm3Tiz/6qZ+aTN/ZgB+k0r4XAtf9/fmXPW50LmaLmNs1VTpknyPy3IJL3EReZXO8wzIbXETeurGjqYZDRBuNjjLU/fHi5809XGDmBE+RUqpEESAmvwI6C2TGKM0tbfcnSFQXJ4EXotHGPqWGx+l7XdW4ZZXAyU84fQAkgNVHvn/Zldp2Uz3iTU4HvwcsFen0krtMcsqWB9Xfg7TJTy52z40qNuLfe22hOBNP8UX+nr1rqSrD0Zqk8rm3icNO1lPDk6AFQKg9oGrhHRqnrjoN/246dLrcgdR4ep0AY+BJGm3FnDbzBDz8m5xt88b+KF9RA16ph1dHT8QVpH49hztXCWebO1uPmmtgEDTiIcu6DptixxgMETg+iu+KD723HcFsLxOontPJGjY8v+y8pXJuXU+MtfXMxn6C4+62pYAy4B5ncJ4tzmfW+sPcqhwHdL7e/BnCaQptQPLI5v7tfclnPs3td17kO11FZL8/IYbYEYSjadThRQdir6lnMrGoOkURjWh+HCBE9uo6U0s1OeTTPgM5WlbtQx/HQK1S0q6l0Mk31YLEz1DMoYbwA1TUrTOab1o0YF3NhbcGxdyeKhaj1789HnH4RBnK7tAtsAeDb4Ya4AfuiCzeuo7mWRzUsxsS/ti6dRbSMZNxvH1jVbcNWRHN5LYdPNh9ZNfIuA31ZIEqfwMINm9KaITcUO2qwH3+yNaauWm0B8JDG+CsW2SObkZKA4DLFQWP5ud7RZ0LCXKzuGuzW5c0rfoPQVWsokeEecIduP60Ywgg9UGmRVpnTvJI1WhU
 FyzDpMBh
 R1QRdySH6urzmo108O/DA64ojYRxqaOjZq+8EvcKGmLDznxdkKLSeWIftHnGQWiqD9RV7znRbhjTmGDP6wm7vluQMSeLA+nalf5GSpohuXgw6Y9AqNK8pUMG51zYaCiJ/plkAri13VECdw4bpHxMthZkmYaNhC4549nwuA22JdW4d2nWdOxg2viIn09nMGcURr3nk1ayJ7nkBOqYzMjEa5Nbc9oYuBCRQpzRWLkhXxksaFa3/+cD6eHkVoqteOUABJqdvFdtoooawm5/zGks4/u5jV2JC5vGAOiiEC+v4NlWrygqdocWNAnkWpr0cHV6KkeWKbuo2G15Z8x5OY33/DL6t0r/U6Rmy5aU1zsZPtTwY1R6qQXFbozs/3gN1DRupm4S55ERLZ1zVZcmPyc+3aS0b7+Xjm83oSqL1dc5LLIBiYde+x/GesRKElYx2QPi9NQAEYoRSAXv1X2vKzcEy0iz65Zpmea5+i/bf3vvawnIPKASMLBNCcHndXIe8N372AuhyLKySuicUetFHjHVVGK/WrJqJr7ExrN3aLVm4EUrw8AcAHs53a8xmq6B68ypf8fnni1bBeyV7T5jMfzHiTBhlt/u2FPdjgIPzXFdgjbhlHa4dF1JmC9dV/rgexHTt6SBk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 38564710f443 ("mm: implement and use vma_has_anon_rmap(),
silence KCSAN"), validate_mm() decides whether to walk a VMA's anon_vma
chain with vma_has_anon_rmap(), which re-reads vma->anon_vma, but still
locks the anon_vma pointer it cached at the top of the loop iteration.

vms_complete_munmap_vmas() calls validate_mm() after downgrading the
mmap lock to a read lock. A page fault on another thread can then
install vma->anon_vma via __anon_vma_prepare() between the two reads.
The check sees a non-NULL anon_vma while the cached value is still
NULL, and anon_vma_lock_read() dereferences it:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:validate_mm+0x143/0x2a0
  Call Trace:
   vms_complete_munmap_vmas+0x201/0x2d0
   do_vmi_align_munmap+0x285/0x2d0
   do_vmi_munmap+0xcb/0x190
   __vm_munmap+0xab/0x190
   __x64_sys_munmap+0x16/0x20

Read vma->anon_vma once and use that value for both the check and the
lock, as the code did before. Under the mmap read lock vma->anon_vma
can only go from NULL to non-NULL, so a non-NULL value read here stays
valid until validate_mm() is done with it. Keep the data_race()
annotation that vma_has_anon_rmap() provided, since a concurrent
install is expected.

Only CONFIG_DEBUG_VM_RB kernels are affected.

Testing: on top of mm-hotfixes-unstable at commit 989bf98b512c
("iov_iter: validate extracted segment for bvec alignment"), x86_64
under QEMU TCG with -smp 2 and CONFIG_DEBUG_VM_RB=y. The race window
is too narrow to hit with the syzbot reproducer under TCG in the time
available, so a debug-only mdelay(1) was added before the check to
widen it: without this patch the reproducer crashes with the splat
above in its first round; with this patch and the same mdelay(1) it
completes all rounds without any splat. The mdelay(1) is not part of
this patch. mm selftests were not run.

This issue was analysed, and the fix, changelog and tests were
prepared, with the help of an AI coding assistant (Claude); the
submitter has reviewed the change.

Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
Reported-by: syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6ae78418.6552420f.2a0efc.005c.GAE@google.com/
Signed-off-by: Songsen Yang <yangsongsen@insta360.com>
---
 mm/vma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 4672d4205..b674c69f7 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -679,7 +679,7 @@ void validate_mm(struct mm_struct *mm)
 	mt_validate(&mm->mm_mt);
 	for_each_vma(vmi, vma) {
 #ifdef CONFIG_DEBUG_VM_RB
-		struct anon_vma *anon_vma = vma->anon_vma;
+		struct anon_vma *anon_vma;
 		struct anon_vma_chain *avc;
 #endif
 		unsigned long vmi_start, vmi_end;
@@ -703,7 +703,13 @@ void validate_mm(struct mm_struct *mm)
 		}
 
 #ifdef CONFIG_DEBUG_VM_RB
-		if (vma_has_anon_rmap(vma)) {
+		/*
+		 * Callers may hold only the mmap read lock, in which case a
+		 * concurrent fault can install vma->anon_vma at any time. Read
+		 * it once, so that the check and the lock use the same value.
+		 */
+		anon_vma = data_race(vma->anon_vma);
+		if (anon_vma) {
 			anon_vma_lock_read(anon_vma);
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				anon_rmap_tree_verify(avc);
-- 
2.50.1

