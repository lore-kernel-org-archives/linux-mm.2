Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE52CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5438E0013; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4268E0043; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45EA8E002F; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB0718E0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C9391D8E40
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:27:48 +0000 (UTC)
X-FDA: 83800539816.18.6FF7D36
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85DF8140003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:27:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N2fFVzfk;
	spf=pass (imf23.hostedemail.com: domain of devnull+schuster.simon.siemens-energy.com@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=devnull+schuster.simon.siemens-energy.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755775666;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzPG0pNN8PrqX+g+rIANbw0E+JSl1sgNPdf1iFp1sjk=;
	b=2RWdJ9N3zrcRFPsFVQctJJwWekV78cGQRrgcnVy5jKeAjKqGnGoKJd6VEqq0ALj7Tzmk43
	ayma7Qb8AyDhnR3nInBha01K9r23L5NBCecDM5q208OhbZI5BvNSjbSxGdIlQDnfzg0Cjh
	ohX/N8XgrpZhHfQRfzF/LdxxyBpFJOU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N2fFVzfk;
	spf=pass (imf23.hostedemail.com: domain of devnull+schuster.simon.siemens-energy.com@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=devnull+schuster.simon.siemens-energy.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755775666; a=rsa-sha256;
	cv=none;
	b=uZymu3bUxLcdwUTMo/nh2+rnhvfalL5NVdhm/5JI8n42XC4JxW9A2EGpTnueZe5Fbi232J
	GANRG2rAyDRljAstJs2WYbC4IRzfH1I1w2Xf4s358k90BkBaT2wrGfYXXUUxwRrtSocwRi
	0TXQgikRIOgBzKR5BVHSRlFTPUTOVvY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id C2790A58204;
	Thu, 21 Aug 2025 11:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20A16C4CEED;
	Thu, 21 Aug 2025 11:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755775665;
	bh=1M9j+PL0n2Y6NH2XjNF7fuQwEwS11EOrVMi3fRSifwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N2fFVzfkdDB7GMIspdbWMZpvAcU3dGmdaTj3qgZjchgPgc7MOdWR66qfxpyBUFtIv
	 WeJeOURS2BKBKpwbv/wsi8sDD8adH+9QDYfKgF0gLfk8K0AOLYAofZaCWrAdopQfnH
	 F1SKnzqV4xr//+T+3MDtIHQ73Tj7DW/QaKCtOjqdotBsBfIUGmfeiSg7qeBGloF5bF
	 Qqwac79x3Sw693koPMtmL9i5TME7cQA8fAtkD4GVsCwon1z0Rcezt8ibjUgyilblna
	 tzHbmh9HyLlPBhL7aK5xEn9ofyGWqBoNncOfB2uNwojLVJ333lO/l4N5ucUqVJpU9D
	 7RaCAwyOReXvQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5BCCA0EFF;
	Thu, 21 Aug 2025 11:27:45 +0000 (UTC)
From: Simon Schuster via B4 Relay <devnull+schuster.simon.siemens-energy.com@kernel.org>
Date: Thu, 21 Aug 2025 13:27:37 +0200
Subject: [PATCH 1/2] copy_process: Handle architectures where
 sizeof(unsigned long) < sizeof(u64)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-nios2-implement-clone3-v1-1-1bb24017376a@siemens-energy.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755775663; l=2756;
 i=schuster.simon@siemens-energy.com; s=20250818;
 h=from:subject:message-id;
 bh=fATaBcMTm8PaXx+wvHRntwDrs2IKs0+IzRTpuUxyYa4=;
 b=y7/IgnYV/3SkSNwCoqgDE/+S2MUsRejhrdpl2L+U7VnPzMzgttiqeo7QuevGlQKo7aBzvBcQ5
 485HV4aRh6JBpSGlbRD35ZZAmT8+Yb7t7dbqgXJf0B1MkEE0oKL4n0t
X-Developer-Key: i=schuster.simon@siemens-energy.com; a=ed25519;
 pk=PUhOMiSp43aSeRE1H41KApxYOluamBFFiMfKlBjocvo=
X-Endpoint-Received: by B4 Relay for
 schuster.simon@siemens-energy.com/20250818 with auth_id=495
X-Original-From: Simon Schuster <schuster.simon@siemens-energy.com>
Reply-To: schuster.simon@siemens-energy.com
X-Stat-Signature: spfea1foyqp1i3qy9by6eknno6ogb9yw
X-Rspam-User: 
X-Rspamd-Queue-Id: 85DF8140003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755775666-745918
X-HE-Meta: U2FsdGVkX1/W4rpbuSXg7y+HPn0UZ/+5krv5AIcDTvRshwkSCrmBD5vVzrL+N7LxEq5NOxeGS8RDTMg5X1OT/UiUqvdoX7Osjtoali6E+KELKqXpkHNo+kqksq+F9FgttZgdbUwM7kjTGZ8Hh1/YNjkcUS/nfZatu+syiQHGV5HvtcEbpPk0I4WM0ulTQvAfwZyc4mn+CkRy+NT8Z803OXHwKrojgtcAR+lCA/9wIvZXTOelyEXM0FjWw92JeyzuHY3lj+cDVnK+h8mJjBw5s7Ld75L6EPPr9Zh4/YgeyIXP4lCf4O9dQSzMlaaWDRvMGyvXf64W0ccF6IQybsMV/Wd2xWnQtOQSHTE2BLJPv4Wj3MJRelbW1FmtXSO48ITaNj6KKA0pCppUBhRzx6BdvjDvGpc/h62b10Tv/WI0YPensPorT0ELUtRORUDP6V3aQdjyhxanXzJesaeva8P1IfNDqEVuYnofMN3umoreDXdKY+yyG9akLcimlVGLDnGk1b4IrNiBzj0sZ5cLr2uUkS5Qu/tOXfNDPRrqPmuViLW4tEnI7TUyqnbkrRAt7iiuzmyHpuDW9jB+Dmy/DIqwGvLCZL0prs7v1rPNUABLrvRb/cYl6H96078ZFiAEx1OM6Lv9ueCBoXbUk1Vt9U+/gIq3fZ136ietcjR/t3iirZ97ZjFMD8e7eX8Ve+SL56o85l1eWe6HEbZYhL3z16p4LzZhM6AofS3rgvCLkF5tLg3MHwLIP1f7U26pp8kN5X0VTR0FFsRlRoDxil/h/jPeXFXem24SH3MJO+yTUeAeftWjdVScaKDw6DVev+szeVbBx2VltAOAT42b0LVrWdfGvwMQ4KTt42IrUys7TE6rV7H+GDdTyTflJcxH4NUXMtvS1YpBQjLH+gCPKSiXl5n2IDZo41/tQAatIGbIExyWwlscjrDb0tXUWKOErmaRN57AnWQBBUDbeeOMy451wmq
 I5t9oFM3
 k42OGSuDi7I1/c/o2QdigcJKXnt46NxJTX7dVjaH1EIdHOOc1L1QOvGO6A9y72WRpZymJmyo/EXBONi6OAJsXik9nXOtj1/VK30XtFdjW2H6VGWIcQv0moeqdCuIMK4DrGA+2Tw6YhP8RVGjKaHjvg170YvYoVXAHJDuM5wQUKTOKnRHU0bXQj4RMOYWVZXO32EtHDHIoibKRX+cvSJ13kggp4zvrvDEmWpN018qJYEGhMmhN1G9Y+msWtjRB2FyoQxXOU/kCFTqxg1a4b55+ch8ov7d5hvVdfRV+uLjR6DONwPtqJTp1rocl5e6IJNo7bt599BeJ1nMhcvJhPYxxCVcEnFKQnfbetS8gCH7y67d/o5rxdgplWUU0lAKReD4+fEW7XWxTyEmhZQ4gaK++SlfPiY8TfbhHj292+8rDrRrdjoInDDhrF8wbfTG9qins8LTgYIvvfravunboe3fCK9/QmuO07QR4Be8PO/hC4Rw5azlXXJ/jprYEPzvXDlS4nh2/hr7PzbITRZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Simon Schuster <schuster.simon@siemens-energy.com>

With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
clone3") the effective bit width of clone_flags on all architectures was
increased from 32bit to 64bit. However, the signature of the copy_*
helper functions (e.g., copy_sighand) used by copy_process was not
adapted, as such, they potentially truncate the flags on architectures
such as nios2, where unsigned long is a 32bit unsigned integer type.

This can, for instance, be observed via failures of kernel selftest
clone3_clear_sighand, which attempts to trigger the conditional

	if (clone_flags & CLONE_CLEAR_SIGHAND)

in function copy_sighand within fork.c that will always fail given:

	unsigned long /* == uint32_t */ clone_flags
	#define CLONE_CLEAR_SIGHAND 0x100000000ULL

This commit fixes the bug by always passing clone_flags via their
declared u64 type, invariant of architecture-dependent integer sizes.

Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
---
 kernel/fork.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5115be549234..0e9b2dd6c365 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1510,7 +1510,7 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	return NULL;
 }
 
-static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
+static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 {
 	struct mm_struct *mm, *oldmm;
 
@@ -1548,7 +1548,7 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
-static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
+static int copy_fs(u64 clone_flags, struct task_struct *tsk)
 {
 	struct fs_struct *fs = current->fs;
 	if (clone_flags & CLONE_FS) {
@@ -1569,7 +1569,7 @@ static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
-static int copy_files(unsigned long clone_flags, struct task_struct *tsk,
+static int copy_files(u64 clone_flags, struct task_struct *tsk,
 		      int no_files)
 {
 	struct files_struct *oldf, *newf;
@@ -1599,7 +1599,7 @@ static int copy_files(unsigned long clone_flags, struct task_struct *tsk,
 	return 0;
 }
 
-static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
+static int copy_sighand(u64 clone_flags, struct task_struct *tsk)
 {
 	struct sighand_struct *sig;
 
@@ -1648,7 +1648,7 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	posix_cputimers_group_init(pct, cpu_limit);
 }
 
-static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
+static int copy_signal(u64 clone_flags, struct task_struct *tsk)
 {
 	struct signal_struct *sig;
 

-- 
2.39.5



