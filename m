Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF38DFB5EAA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE756B03BF; Wed, 18 Mar 2026 23:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FA46B03C0; Wed, 18 Mar 2026 23:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED78F6B03C1; Wed, 18 Mar 2026 23:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF56C6B03BF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:24:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 658531A032B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:24 +0000 (UTC)
X-FDA: 84561369648.30.D81C311
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0EFF81C0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EyTILYUb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Z8ArazpuHzwIU8/sGdkPDAUgZ5Tq6d2MPt9c5EGHyCA=;
	b=trpg7mksuePzoZTKCGlFkB+fcjmC4e+8OjrFHVhE1Wbva1cXrb9FF6DKAVLds5F84cRvU0
	TEj8/KdOMPbWtvE3RMgZYYWZ7fiZrMSi/zEVXiW2UHESDGJX8LNB+bdNYco3O1mswNfW/R
	KbEBvM3ePeLGPZPm/kUBfoYIntosdW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890662; a=rsa-sha256;
	cv=none;
	b=mBL0ZLbzqe2Mv2mP5vEx/EvgCachxA2dOW1RnmIe+qpVGzEPw5btylRnDZV+pG2+nAe4Oa
	h/9NndlNe99tjtNkcjnccjyT+XcLBOeyVDA4+jkOI9k0BvVsALnS+NomtSGf+LkuKJUNPz
	ZMyDzjG1A9/mOtNjMjjtGsBbyWBFX0c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EyTILYUb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773890658; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Z8ArazpuHzwIU8/sGdkPDAUgZ5Tq6d2MPt9c5EGHyCA=;
	b=EyTILYUbcZJcnd1smUvge8rFRD1LpYuRaDbj+hDft4CM6i8kVdB2FUWZe87xzXYqYGddH0ZtG27ugWwetFF2wBcra9yPFgVnqkiJjkyqJvfScTyqRIpwgQCZJVl2z3qSej5wz5ES2YZ+MAKltcSA2uNvZkf+oG3vdHQLxya7Du8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.GnNVC_1773890655;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.GnNVC_1773890655 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 11:24:16 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org (open),
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] change young flag check functions to return bool
Date: Thu, 19 Mar 2026 11:23:59 +0800
Message-ID: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0EFF81C0004
X-Stat-Signature: rt3bdt85snupheyyw3ttuy63up5sb9ky
X-Rspam-User: 
X-HE-Tag: 1773890660-771631
X-HE-Meta: U2FsdGVkX18P5vdHcQCKXrwcXhmdv2UosZzwZcwlJN1tqHSMq9LMMWoLDI+KkYHFObvKLJyVNQM7VQm4TjF4m9pKwoFtsEaRSuGEvGuIahZog0ClZ8Qh8hnB+a/Nii4Y1i0sFapnrWViMhRjHJa5MbC4tI0GshQE9DxH40XlsGLVATerNWHmnhL5SvBcHf0CNJ5Xze4LmQEZz1VWSAtungxnXW8O94cB/HzyfjBpqetHpyu5eyB/MkwORPPt+V0hc5jxwEDRAg57tpSNBpByfeBrYe5LdrUDNC+g3yF3QbtVowebNkmfuzr1jR6hPGl+X4AgtSpwbivsvSoc2ZtC6ThPAQtka3wcbu9tP09Hzbo05DOYl0U0V9dRqmeCNXmul8etn0kbuNyoqlq8ixFd3Me7RNt9l8A0S/KgeaHRnUgEFEjxqh+p8pLionfrTgIzBocDxNCGNjoVYyCaaMfZoSVexTK/r70s0BhGxKALuI7F6r/2EzMyBEVKXP9xXgSt6sG9zLKqZqOOkUM5AFGEYkfqERhrbq+xNtQ+oy3OlNHNLU2e7q3V5DsNCGbIunrefE7j6ftqULMScqZklcpkLWpplnaqPs3Cme+34jCsoU1tnGAW1y5XbrC4JrlwLU81IBKvLYqjrUbHNWthtps/36wPI6aR3SUMGz+TDanJAmlzgGB+6mI9cuR3DCNeohUyzH7aXHnY01yknPHy+X4XKH8mv9QMVq57K36fITER7EhECFdWytp6ln9JSVkGeJ3ebVAkWj9MMiWB/lmYG1La61xX32lkdJ8NSyEeOoJGQvQrPcZqkK6I7gO8kMG2UK5ky/Q4YiUutLvJO6guuN9NyiPaU8hTg+BknmDk/NOCPFQjYFr8M1BcbOSEkpr9/QMOFxfQ5h+y0EQ93iB+rTiRiZ/psm7jBkPY3uv3hdm1m6s3hqLxtQmJg+bv0pDTX4if4XC6O6Sa+10V+oH+dxw
 ZSPBjaRz
 jHbW9u1qDL9hETWF9i2LhrabFXR8h0yZ9VEBx96cUd40voucaedhgLGZWtfgRcZrBZCMwfw981xoo+9bJE5SoxE1E7e/RtvZLZOqSWZR4d0x2w89NglbRIrr/oaFo6GwUVL/10e5rtiI9SpWnLh29DeUKCvKek7IbtjgWO5E5CqOYwiqPSptBRWt8Ny1CYqLmEO2HDhbIOyssGy76/dBDkgMOJFXgTxQh8QQly9MS621VGznqIyUgEetTB8S7scEKS0+RmhQK59xEj/138w+n8xVRFGpw05Mz34QUsWpwV72xxCuldmrY7h/Le1yQJyWhCRaF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a cleanup patchset to change all young flag check functions to
return bool, as discussed with David in the previous thread[1]. Since
callers only care about whether the young flag was set, returning bool
makes the intention clearer. No functional changes intended.

Ran mm selftests on Arm64 and x86 machines, and no issues were found.

Note that I only CC'd the arch mailing lists to avoid disturbing too
many people.

[1] https://lore.kernel.org/all/d172d6bf-c60c-4cf5-9da9-f30de38cdfed@kernel.org/

Baolin Wang (6):
  mm: change to return bool for ptep_test_and_clear_young()
  mm: change to return bool for
    ptep_clear_flush_young()/clear_flush_young_ptes()
  mm: change to return bool for pmdp_test_and_clear_young()
  mm: change to return bool for pmdp_clear_flush_young()
  mm: change to return bool for pudp_test_and_clear_young()
  mm: change to return bool for the MMU notifier's young flag check

 arch/arm64/include/asm/pgtable.h             | 29 ++++----
 arch/arm64/mm/contpte.c                      |  8 +--
 arch/microblaze/include/asm/pgtable.h        |  2 +-
 arch/parisc/include/asm/pgtable.h            |  8 +--
 arch/parisc/kernel/cache.c                   |  8 +--
 arch/powerpc/include/asm/book3s/32/pgtable.h |  4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h | 26 +++----
 arch/powerpc/include/asm/nohash/64/pgtable.h |  2 +-
 arch/powerpc/include/asm/nohash/pgtable.h    |  4 +-
 arch/powerpc/mm/book3s64/pgtable.c           |  8 +--
 arch/riscv/include/asm/pgtable.h             | 14 ++--
 arch/riscv/mm/pgtable.c                      |  8 +--
 arch/s390/include/asm/pgtable.h              | 16 ++---
 arch/x86/include/asm/pgtable.h               | 20 +++---
 arch/x86/mm/pgtable.c                        | 28 ++++----
 arch/xtensa/include/asm/pgtable.h            |  6 +-
 include/linux/mmu_notifier.h                 | 76 +++++++++-----------
 include/linux/pgtable.h                      | 53 +++++++-------
 mm/internal.h                                | 16 ++---
 mm/mmu_notifier.c                            | 20 +++---
 mm/pgtable-generic.c                         | 14 ++--
 virt/kvm/kvm_main.c                          | 40 +++++------
 22 files changed, 201 insertions(+), 209 deletions(-)

-- 
2.47.3


