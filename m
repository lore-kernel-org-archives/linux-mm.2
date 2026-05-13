Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A030CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304CB6B0005; Wed, 13 May 2026 06:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5AA6B008A; Wed, 13 May 2026 06:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA386B008C; Wed, 13 May 2026 06:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BFE96B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:51:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9C5C1A08A2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:51:32 +0000 (UTC)
X-FDA: 84762080424.19.3823584
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D9D5180002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:51:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a2CFwc5O;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778669491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UL17nduyTBNEQwj1UIKgkwz+Re1SUOkeq0LD1JvjdFA=;
	b=vtAh19LugSejgYAWMuiQneCmjNrdz6+BiU+DkGqMICO6Nhp1IsNuD2lnxwxcsWb8yXKFP9
	9v5R+v8zPkntdi1b1bFVGNANvZ/ejo6HPKHF/pcnUxddiCNAG1HX7O2aOLHLI5cCoV/YMk
	FsmjkP/vKJOJYwsJeMkjlVjIaei4B+w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a2CFwc5O;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778669491; a=rsa-sha256;
	cv=none;
	b=UmSyoziny3Xai3WOgMV4gUjs3+gX9DDhFXMeCHKZaNDMsC2lMl3R+iXmYnrsLPnK6sakZ0
	ydUsG8HXuHoLbBhLUslJqYARQIzi/Bxf95ymsbxFm4mchvfqst7jx5M2goVFWg8Q/y/MHe
	VE4F9EIgmBBEuTaPtWfkp8+XLXgdMy8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8347F60121;
	Wed, 13 May 2026 10:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCB8C2BCB7;
	Wed, 13 May 2026 10:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778669490;
	bh=Hk7K/3RhXntXzFGSnl6ODU3AYCj5OMznpN84yMhYyDU=;
	h=From:To:Cc:Subject:Date:From;
	b=a2CFwc5OUZkzGcyd+bER54avul2DTMxBC1rbYHLhvReTOOHdFY3os6JRfHYa2zP97
	 LnNJiTBhpoLMOiK8w10cl2Q0bJB3c3LYUCgsj2/yp8xn/CmZnBph/vu3JSoxkmCiRF
	 k+bUySFaue039FUmv1QL0hjdNbqkC29wWXgEB5g5UqrlwmDoiq9MBWELdrShPqtHCt
	 qEoy1TcIxMDrVuPycaqEflvgKK/jN81p75rtEykC0rnQe/zC8Uf3JtOc9ITMD6RxhV
	 BLWy129v3FOjGhB9FMgb5TUNjVI1F7fgOY46oxmFxB4UhQOnwXrZMpleyNrBE6tkb0
	 9GxKw0cs+yddQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Breno Leitao <leitao@debian.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"K Prateek Nayak" <kprateek.nayak@amd.com>,
	Mel Gorman <mgorman@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] memblock: don't touch memblock arrays when memblock_free() is called late
Date: Wed, 13 May 2026 13:51:22 +0300
Message-ID: <20260513105122.502506-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D9D5180002
X-Stat-Signature: sbtmq4m934r4t6mhne36pqftgd8nyt5c
X-HE-Tag: 1778669490-436566
X-HE-Meta: U2FsdGVkX183/mEkKLG9DDIiqbTPK18NrAhmWZ7JEIKXDnxw/oswYp56Bl5XQvE/APKQd4/U19LlRQO5993H9beOedd0Lav0XwB+iSyEO8pTNZGkYfpkp6Y22TzV8EWmbKL6grmi/hsGByCwwTk/HYW+fICUi9Rk5O5uKbDCQtFfWieLDYlET34LT691JvROauSOpErb4Bc+B9mPwYNFqdDXI4XNqNey9pBfD23fPAZsD+nu8GrcxM5k7FSGhjzmKPZ/qI7wbs/o6biQ/Z2i4he+fKTRPYaMVMfB7c8zpIuPOK7KlMZ+9dAMp1ofDFUqLYq1kwyrpu8y63oME4rjE0DWI9t2+a7ro7xwKbAkM/nmiMTBSs0xWS8BUmh73o0zdDb2yKqWx4afo3ZuQoQoQfBMOHgZos8BkG41bBgHp6T23H0PW7oXRArBUlZBOFidW+gxyygZI3UQxfkwWm/VPzBPiMhmMcG+ZpM/4LK+uIj0WGQLayGGKOIW6SqjbpAlFNAUwgsKYZz4YcaOda4metUwaWWg16TI8NAR1XkBJbl98UXHELc1BWPXNcjvzw3jVZwciQAArabtmU5QPZZr6TBVvl7cgkVLKRw9a6MDQgZmmeq5KlBFcH964hdlV0yHOLAVWhVM8uM7/9F6vZbHgEtdE82bnOjvHkoL4C/RtHMXwbb4L7CABrJDRqdD3pyEhX6e28aTxzluNHiaoJtlqSIDLeZLwWC9+I+iecOQ5rhukJUlcEL2FVq2JJ4a2+fDft4FvoHpLIYXwEm0MH+gu9um8uV0Ggzec4kC0Jn3N3rkuFDNgM6nvu6PM0Wu0CUp6Ofq1jj9l3BocyvVez2li6iMPfvBUBfKcza630f08C3RylDIokMyiKN+9T/mEDTm9KYGNWJmiRHH8dngJEd/oiLPJy5MEO+zeBD8c4F4iDuJBlnCs/dW23rnpMafKUBrzpSnviw3+LEq21OAjmT
 jZRGZWly
 fE49pYqWPMRXo09Vk9vA3Cm3oJVOAebIjebQQgndZ6cqFwwvp71s+YfD5qZlXgfmy7a8Tfw8/loJTuCEUX8IKMip6XJLylhgz0LYQsFz98D6WHcBGDk1nKUxcO34sGpFNnbi50VIpke/y+gI6+bHnEWZWU4kL0of7whvCuxhGDUB+PbLUnnId1Qz21aYhET1nFtFGEUJ4KqDvaV9laHK4Oc2WhmzBcn7O/rnj1VDidbfcAzs35/3fmiFBYGpyKFhzhOEQVoKoVn5AA33ppiLz8MDQ2vSGuDeku15wavBUG+HHN/OCZR8VaC/KGkCxzQt0mpXpaviK9H9XRyY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When memblock_free() is called after memblock_discard() on architectures
that don't select ARCH_KEEP_MEMBLOCK, it tries to update memblock.reserved
that was already discarded and it causes use-after-free, for example

[    8.514775] BUG: KASAN: use-after-free in memblock_isolate_range+0x4ac/0x650
[    8.514775] Read of size 8 at addr ffff88a07fe6a000 by task swapper/0/1
[    8.514775] Call Trace:
[    8.514775]  <TASK>
[    8.514775]  kasan_report+0xb2/0x1b0
[    8.514775]  memblock_isolate_range+0x4ac/0x650
[    8.514775]  memblock_phys_free+0xc4/0x190
[    8.514775]  housekeeping_late_init+0x257/0x280
[    8.514775]  do_one_initcall+0xaa/0x470
[    8.514775]  do_initcalls+0x1b4/0x1f0
[    8.514775]  kernel_init_freeable+0x4b5/0x550
[    8.514775]  kernel_init+0x1c/0x150
[    8.514775]  ret_from_fork+0x5dc/0x8e0
[    8.514775]  ret_from_fork_asm+0x1a/0x30
[    8.514775]  </TASK>

Make sure memblock_free() updates memblock.reserved only when called early
enough or when ARCH_KEEP_MEMBLOCK is enabled.

Reported-by: Waiman Long <longman@redhat.com>
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/all/20260505051821.1107133-1-longman@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Waiman Long <longman@redhat.com>
---
 mm/memblock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a6a1c91e276d..ccd43f3abb82 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -989,13 +989,15 @@ void __init_memblock memblock_free(void *ptr, size_t size)
 int __init_memblock memblock_phys_free(phys_addr_t base, phys_addr_t size)
 {
 	phys_addr_t end = base + size - 1;
-	int ret;
+	int ret = 0;
 
 	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
 		     &base, &end, (void *)_RET_IP_);
 
 	kmemleak_free_part_phys(base, size);
-	ret = memblock_remove_range(&memblock.reserved, base, size);
+
+	if (!slab_is_available() || IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
+		ret = memblock_remove_range(&memblock.reserved, base, size);
 
 	if (slab_is_available())
 		__free_reserved_area(base, base + size, -1);

base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
2.53.0


