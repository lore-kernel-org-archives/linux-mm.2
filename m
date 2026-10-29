Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58736606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r4Dl88Vx
Received: by kanga.kvack.org (Postfix)
	id 646ED6B05B4; Wed, 28 Oct 2026 22:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61EBE6B05B8; Wed, 28 Oct 2026 22:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C526B05B9; Wed, 28 Oct 2026 22:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC7C6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:58:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A06131602BF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:58:07 +0000 (UTC)
X-FDA: 85374154614.03.37A9B8A
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54BF5A0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:58:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r4Dl88Vx;
	spf=pass (imf25.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242686;
	b=CWLrN/ssXJiuv/LRQPjCn19Vk7JiJmMtHqeCksjzRHuY+V9mZrtkR5LZLU4nT9tYW6wRIO
	1FeotPnc84VDhejtnMMj+ayOUcMlCWSJNwcyYobhhhUQAsTIbC+fUaVZfmEK6edUOvqI+S
	nKC8zumQ5gA1XCLbAV7mXOCYC+a+4b0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r4Dl88Vx;
	spf=pass (imf25.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z/VnQt5DC7ZDkdABthZSi7jwABJbhFlA4p/KW5opRjk=;
	b=TZgJIpOSSu6MHpTOMyuocsBnX7wEOYvY9uGzlLxxDlXciG5IK8p3XIPRLhONEGKVKpyctj
	eyqePqv2iNhkfL81Fi2kSopAzrxbpz1hBL8ci0WhXE2NxScPcwcu3DYm+RPc/2uCZH6Ixz
	Z4uAp9eX0XPb0SzlI8Lv0pzyyvuLu4g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2yJPhEA+osB6DVRCw5dTasiq5meR1ZntSgNLQBMw2zo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793242683; v=1; x=1793847483;
 b=r4Dl88VxHTQ5u7jfJcN3OerbImh7YLUfp03Qzf2/uF9HvKKphBxtKAyThluKZm3Vvrcxm2ej
 kNsqTTdScf/Qw0NAxC33y05z3+Zis9c4snvQ3p9vLc/ewE1MzMuxchj8WGBBRa4anebpdjtVi4M
 J5cOlHNz3mlr3EeeoMlZXSrk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 14de6ad10eb9457f;
	Thu, 29 Oct 2026 02:58:03 +0000
X-Mizu-Trace-ID: 14de6ad10eb9457f
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: glider@google.com
Cc: dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	muchun.song@linux.dev,
	liu.yun@linux.dev
Subject: [PATCH v2 0/3] kfence: fix pool allocation failure handling
Date: Thu, 29 Oct 2026 10:57:40 +0800
Message-ID: <cover.1793242457.git.liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mbwd893wmz85cswz1ibadxdg35t9d9r6
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 54BF5A0006
X-Rspam-User: 
X-HE-Tag: 1793242685-131712
X-HE-Meta: U2FsdGVkX18U5+A74QBnepvhimxEwiGIc6Yyf6khIcpECX3gz4auPPMOEb/CETKKLv2dF6MEx1wKywN2aH9FSc46bM8+Tw+m8/WzruM7yZmsANNqm8oA28Set9yBqUXi31mC5Pahu60LH6hkumlYRv/Dd3ExS2KvvqBgsh6lP17enf4zzWksKYNQ7Zx/l9HaaBj4ug/+XenKid6u0DyBDLD7wKafYJ+m0wG+mmjgFmzTzmUhAhCbMPUoUi+AiTd7d9h3KySGLyq9DmpdyiAU1wU5g8kuimRc8WI9Lslzb+xUSCnIbG3R0TJ/2bqlaxWknDNAS0/Bi7hbv1fCKxhN3gcBYuBjY2v1PetxiJ4twxIAYP5LHwERL+q1p/NrjBD7jOhUPiBwuABD6cJqZ/PdtvbQuU01TlC+q8ij/c9l2/VWZgBYklS4E0y7+Wmcz60CP/2UD4R0aKX4plZcvjCl5oFhVckss7lCDo53ZBb4v883ZNXqlo+TopIoahmPIWVtiK9vKeFw0yh4k/brcI627Oqva3OQ3UZ31Ep7GTFgytBidqr52wmuDttnDvDWfRVcQkP6klcP5UMW5TZq0izBWy5B9fK/qRLdJKZ/0V9wQXlUPmDJjM58nvrnyfVN18AZWg77m0CSKEbD9TQvkI23x88Xm6EA2Rl9jHovEVUJvjuZCZFuHKRc9hWAgBoGo27BJlVV2rweR0E7VFJf5EE3yXaEAWAGkdJRLUZVF1HS+BM5tQTXvVWbYIc+eXBim+CyJUEkH3tUqjqTaWvNjRJnkvwmqMtT/BfknKjHWVKJgF1t20xPoj+e5bUsB5e7FM4yshWOSzRCIw6KlPMS+QTmfE8xkOAOCH27AmIkM84c0pvSuult1E96F96Gj1GqhFQwDd93wX2+9YtKyz+3gQPU5nuFZWzG4sSwNu8M3/ijDW8/nJB/4x3GX8q3SYufWSo7X3kHcYTVxf+E5WwAdDJ
 wwOU3okN
 CXpwL+Ov7TFzRJr0DmjuKTGhTH1Ip/Mmjw80Fd7ohK0SRJGlpfcMNRoZupRS1uCUZB47zXqqdDHx6VdUrNAiIVDD0zgkUJ1do7hPNEgl5rhdg5Q/p9cD+8XMb0Gh84CA7rhvXk1rJU2vg/0t1odgl0FCmHOHiCfoZSfNSfJNwAlDnfHSQ+SpOsPRSdUzRehCsI6Q4SAFYzev/JLwlM1EI/9GlTY5krOBJYIYWxwPWR38TxfgQVWzNTBxwCYNzEneFziflIhWJL2Ie8doUPSza2HEd3D2Y8IG6LH5Fqm9JLlpx3rA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

Fix the cleanup address and page reuse window in failed late KFENCE
initialization. Also let RISC-V boot if the early pool reservation fails.

Patch 2 depends on patch 1. Patch 3 can be applied independently.

Changes in v2:
- Add Marco Elver's Reviewed-by to patches 1 and 2; their code is unchanged.
- Drop the unused asm/kfence.h include from patch 3. Sashiko reported that
  its unconditional inclusion breaks RV32 and NOMMU builds.
- Credit Sashiko and kernel test robot with Reported-by and Closes tags
  in patch 3.

v1: https://lore.kernel.org/all/cover.1793017073.git.liuyun01@kylinos.cn/
Reports:
https://sashiko.dev/#/patchset/cover.1793017073.git.liuyun01@kylinos.cn?part=3
https://lore.kernel.org/all/sashiko-outbox-186543@kernel.org/
https://lore.kernel.org/oe-kbuild-all/202610290904.wbrEL97y-lkp@intel.com/

Validation on AArch64 Linux with Clang 17.0.6 and GNU ld 2.40:
- RV32 and NOMMU: reproduced v1 failures; v2 init.o builds successfully.
- RV64 defconfig with CONFIG_KFENCE=y: init.o, mm/kfence/core.o, and the
  full Image build pass without warnings.
The existing NOMMU warning in include/asm-generic/io.h is identical to
that from the unpatched base. No boot or failure-injection tests were run.
All three patches pass checkpatch.pl --strict and git diff --check.

OpenAI Codex assisted with review, adaptation, wording, and validation.

Jackie Liu (3):
  kfence: fix pool cleanup on metadata allocation failure
  kfence: clear the pool pointer before freeing pages
  riscv: keep booting if KFENCE pool reservation fails

 arch/riscv/include/asm/kfence.h |  4 +++-
 arch/riscv/mm/init.c            | 18 ++++++++++++++----
 mm/kfence/core.c                |  6 ++++--
 3 files changed, 21 insertions(+), 7 deletions(-)


base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
-- 
2.56.0


