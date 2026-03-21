Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A931099B54
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 06:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F0D6B0005; Sat, 21 Mar 2026 02:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321306B0088; Sat, 21 Mar 2026 02:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2360A6B0089; Sat, 21 Mar 2026 02:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1167C6B0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:43:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D11058EB9
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:12 +0000 (UTC)
X-FDA: 84569128224.29.0B71AB8
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3CE7E1A0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sXuPqm6g;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774075390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CFe5F2qNF94aRecR5rQidH10sMhxbLDMuB5Obisunh4=;
	b=glEJDtBaqX+hI6GfWZxWHWAZWEhYa82nmCkb2SMdWNWfh+fUWHRNNwjr4p1fESLMNbS8pX
	X/QAFqZA+8vZdEsU+HFdyUcGpNqt1vLqOswNluLKDAfzHB1Gb2iBSpalfc6izdrUxZpXNp
	zQjq80W7/TX9x3UdWpQ0etOMRBEeRKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774075390; a=rsa-sha256;
	cv=none;
	b=JHDpOtDXBqpyfAzM6qWDtbvPnLWuPajPY2k/H6tL7o4uOZ/zKJOSUmsytAJ4dFDfH2/M4d
	y2mIjYk89Z6BzszGXWqbEl/CYd66DYmmwQNMngkKyHyX/b4rvWeixYNot8nojYBq4bzUzZ
	LWt8FZgHXhMe7WAWW0mCOwbRsZChDEo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sXuPqm6g;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774075386; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=CFe5F2qNF94aRecR5rQidH10sMhxbLDMuB5Obisunh4=;
	b=sXuPqm6gOoB4cfECJY0E34WGzrLrEk+Z8NldJtYM5iN5Zl61cVYO6OgDc9ibARWknHk4ym7jjl2diC5iwT1ou83XjSauV1i9m73HOAiKPx1wk8cW2fMaly0omRp/ZZXHXLDXbo9ZRWa9ZO9pxLdq7asKnywGplo0qYXoIJp9XpU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.O7gUx_1774075385;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O7gUx_1774075385 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 14:43:06 +0800
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
Subject: [PATCH v2 0/6] change young flag check functions to return bool
Date: Sat, 21 Mar 2026 14:42:48 +0800
Message-ID: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3CE7E1A0005
X-Stat-Signature: 1jbefa59i7ty76wjxzjdwwzo1u8iwsbc
X-Rspam-User: 
X-HE-Tag: 1774075389-284369
X-HE-Meta: U2FsdGVkX1/mnOPTaig+piL2nqC9Ppz7H2tzKUEJHT5q7ri1vIMYviutexxsMxyxjlu7Mzx3hqyGpbKK/Ob/IiERh2vvXWLPMeel0SHc/wbszXcyr5xbE+l6vzolzsLv3jALRSHslvj5AG2JKhA6JqSA65k3YkhCYEvTJBGfjHTcFpCZyeqX8eTfWxD6zGtNwR0jmmMTgZqTGJQZbygI2JXW1flhUueCGQXWZ1xPgUD4/XPE8ch0Wb8JesE3psJDkeAK6dpH1ROB1Z7xMInHZeKfBRwOrUFBUQ86lcz2JPeBC+i5BMoJ27wC34MKO8JRd5a9zOxWtB9WbMYpASWGU0g34d1PZr1plVC2ba5j5Js/jy0oHh+WAiC+CETzyg7L4sS+nKnJoRVflOCoO66oWqxfi/aluOHII9IoV5vC6r09BakBpzpQfdL9YMprbGs9dGsfVai8PqV1NvzZV1BjkjwbQUS1goDIw/hcMfuxV3QD5cWWBmT2+JgXVvaR9H6Izz1r94DEL//mpY9oGdPX7XrqDDx4/pJwdcNzBtflTaanHT/IxxBhKpB7q6CpLDvSlOkrIkxOiQzZLIx9zM3jH1VMjKaezVft7TvUcyM4I1FoEeRZ21TW1Ld1LPCsGRqMDkrC2PfKquJ2Bn0nfC3jWwwM081op7NrMV1jP9OP4qMaUlogUn1eb5bRCOPZ3hFkSrpEoGzbjRHEm4vfaHsxIfhXOTGtNp63Seh9OqiAXzDXkIHtDwCSRzArMkIxwjS8aZbJHfdk67IFH0aqwuXmULL3yK41DFh5sO8vMklxcbJM80hmVVLfv+vLcRfzVHlXg4x0ztBMaBOg8oWx9BOsWYOgFCTAZKT5HNxKvbp6Zphgq6muPVb1wutW7HPl4e+eHBqWhgLAmtn/E2KDxfhkgAQvYb02Jy3NK8n4MMKs3Hr+4aX1OPxXY+hLiPCwuNFKAUeqTqAE8UD+onlpVjH
 kIEyVIo4
 B1obusL5fCGnVEarUieZu44ytsuE0SWuWqJTwKaBPPJv5O5vi/oMMdiSktliJNJztf5W/L4HIvu2LFY2IR+jTxolYiFFsPbZqUKUK3Pmk20sxZ1a8nDf2y/kSVm9LB9IFNkBDbWIJWFyzhOKvrFZR08iq64erMZNnDcNI+ZcSJQFaHWLFMECDdbEJfLEGKRg0sRH+D+a0i3HaVW3N2vgu3px0pd4BTlxa1MOdZD6KF1cxtIZxngcZoEj6l0SZzru2ii1MMYbFoUUcoY7cwloystnHaWv+8ti5SlZnit6VhRDAa/7JT5fFZ7CZ6WzTe+PVQDKN
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

Changes from v1:
 - Add reviewed tag from Lorenzo and Ritesh. Thanks.
 - Drop extern and use 2 tabs indentation, per Lorenzo.
 - Fix the incorrect conversion of the 'id' variable.

Baolin Wang (6):
  mm: change to return bool for ptep_test_and_clear_young()
  mm: change to return bool for
    ptep_clear_flush_young()/clear_flush_young_ptes()
  mm: change to return bool for pmdp_test_and_clear_young()
  mm: change to return bool for pmdp_clear_flush_young()
  mm: change to return bool for pudp_test_and_clear_young()
  mm: change to return bool for the MMU notifier's young flag check

 arch/arm64/include/asm/pgtable.h             | 38 +++++-----
 arch/arm64/mm/contpte.c                      | 14 ++--
 arch/microblaze/include/asm/pgtable.h        |  2 +-
 arch/parisc/include/asm/pgtable.h            |  9 +--
 arch/parisc/kernel/cache.c                   |  8 +--
 arch/powerpc/include/asm/book3s/32/pgtable.h |  4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h | 26 +++----
 arch/powerpc/include/asm/nohash/64/pgtable.h |  2 +-
 arch/powerpc/include/asm/nohash/pgtable.h    |  4 +-
 arch/powerpc/mm/book3s64/pgtable.c           |  8 +--
 arch/riscv/include/asm/pgtable.h             | 16 ++---
 arch/riscv/mm/pgtable.c                      |  7 +-
 arch/s390/include/asm/pgtable.h              | 16 ++---
 arch/x86/include/asm/pgtable.h               | 20 +++---
 arch/x86/mm/pgtable.c                        | 28 ++++----
 arch/xtensa/include/asm/pgtable.h            |  9 ++-
 include/linux/mmu_notifier.h                 | 76 +++++++++-----------
 include/linux/pgtable.h                      | 53 +++++++-------
 mm/internal.h                                | 16 ++---
 mm/mmu_notifier.c                            | 23 +++---
 mm/pgtable-generic.c                         | 14 ++--
 virt/kvm/kvm_main.c                          | 31 +++-----
 22 files changed, 202 insertions(+), 222 deletions(-)

-- 
2.47.3


