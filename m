Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF292C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 08:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8F06B007B; Tue, 28 Jul 2026 04:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379676B0088; Tue, 28 Jul 2026 04:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B0F6B008A; Tue, 28 Jul 2026 04:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E27336B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:13:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2881F1202BB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:13:50 +0000 (UTC)
X-FDA: 85037471820.19.29E1266
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53F4C14000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:13:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rY0eOVuU;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785226428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nf3/RXzWWNLxCoGIWrbrb3KbqO5WYkBEOlmrkz1TaDk=;
	b=QVn3oab3OYDZZGHXte+m8HZuEPMafP+gnvrW5XDb3FG1Z7Xs6bLiTdGd+foHp5fFHzSyY3
	+pLp56D/14oNgPySf5G4d2HpVluD9X14wItIR6CgEX1i5W0vtbBPO05QMbXbMv15HMSIVj
	LQTDa6AEdYPQbB3MBVKacOw6fkFm0/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785226428;
	b=gr+lzLPgZxPGFS/LjfYNVrpvDF13CyxIdDlTpAxyqfNEMG13W1bBibo/g92B4FmjL21Jal
	hGVo9vIjKXfYXmjdA8A+6R6p6vLu2sLYZZwPasL4D9ZYVeZNbS1/cfiKAsk+ytqOIEnedW
	LCiF/2Sz2tJjANIhHcjmMMUXoGUxjaI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rY0eOVuU;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785226424; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Nf3/RXzWWNLxCoGIWrbrb3KbqO5WYkBEOlmrkz1TaDk=;
	b=rY0eOVuU0NcTxCGtU6ckbq86vskEATcxljwMlSVFW17RXNgfXHs/2kD2jCSPF57ki6hcDwFShF3xM47m6ANWLAG+aLDJhkyHsPe9GMH1kckHJS5yFVGvxgIXUnJc9+m+TfYZaRr8WhOLMo36PL6O82aFNVz6FrFi7wsofFN5T3c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8-0EhG_1785226421;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8-0EhG_1785226421 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 16:13:42 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] add anon mTHP collapse test cases
Date: Tue, 28 Jul 2026 16:13:32 +0800
Message-ID: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 53F4C14000A
X-Stat-Signature: 19m84suu6zspbgmmhe8w9e3iuapo3xok
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785226426-492969
X-HE-Meta: U2FsdGVkX1+8xs4y+BFWkLe+rLBhJ+NJwI2NHllEB6qXWISmymLpoZIlydUNFu3uKwiaJLO71gEJq2hgIccGaKYnZl8Es5w6y7Osah1Ygv2/42TB8/fFxoqg5WDGBgAyfY5rVgDXL+V1tISLzNTBeQSyUZI1GAraPEZvyuRb2gybAQd2Rrh3r65J98ZMubyTyd3e9GvJ0Ak1vLa9PNHS8I61JOTZfK6WVdRyH6M45+uZYkzfBc1wvmOXyqJMeruDIIBXOUbzolfygP24kKfwcutaZ9Cxk9QCFmHVUPD6qJ3ntHb/B9Hakm2RtoCfFZw6c4/2zGvjsF3OTunf6wyBFCuPSnGuEoKvbKy+oWftWmsSdI4P3GSVnAcb+bzXfM5XC6d8AFSvQxT5DYwuq5iIYvqsJq1917P+KM+N0az1LhRW1ZOcLbItFOLbUlHwU/AdiRK6c1i84Mnz+1vIMj03uOdbD41RimsFbYUsOFahx3F+Mt9PtOkSXsJIUKaewvC3+SdaNkhCjXbNArbAoh51Q0p1s4/+KSpbq/GD71gs7PcrWVt2GhfFTvvKFnxDclwMRkuHygXOGXUzrALRNf/3V6PHfgP/nalc/4T3JgTgvWl1e8FiMf+d3lEdYSvzAILw2fZpTIRX84RlJKaDwzzWSDfwToWyl4BEKNKY7nFnFyBfSreZaOQ3m5BWp9KJAlTx3AldoCDq73luxArNDHRJ719IwgxLwzzgS0Wv+PO+ccgXqPRQpp9J2jTZ1nHSXCGIAuwQqIwDPWkKTIkN/l/O/Wlz7ciLmDUMVar3K/rjJERcW/EOjEQQeH6uyZgK4SVHJQ1kbaPb+GbqbwCHjy0JSoUPFz7n2eIWc47GXR+blk3phIkmlpPhLqV8op9P9Ww1+oomvl1aNTVEGu1LvFuYrGbvgtbEcq32wSmC1/oDDGJ0T6fjgwfxo2HgiQZzQMsk3RbN6uOtEEbOmJZvp7y
 8oc6orNW
 9iOJLyr5phigyeTVzoHC8gl5HGNvkqdJX5STYSee9XlnI0QAJnr7ZNQfzZrUFLWEbr4WyZ3s0ilZ3ASzwCghr95pOTiMW5wolIrX6MhDq2hTbzyBHQ1VcTkX+VVSjTni9QISua6wub1EXO1mrP7anreDiDnIokI/j+J+ESvz6JOJa35eER8fB2QuSZyoPD7gT1BBJBs7WjG4arBFTLI29y+u+0mwXpTDAOFui6DSQrqUyKPxuWygBdoFV9iAx/cFjK0mepSvJ+hptX3xl7VU5XPwn3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is split from the previous shmem mTHP collapse patchset[1],
which only adds anon mTHP collapse selftests. All khugepaged test cases
can pass.

[1] https://lore.kernel.org/all/cover.1781083630.git.baolin.wang@linux.alibaba.com/

Baolin Wang (4):
  selftests: mm: extend the check_huge() to support mTHP check
  selftests: mm: move gather_after_split_folio_orders() into vm_util.c
    file
  selftests: mm: implement the mTHP-sized hugepage check helpers
  selftests: mm: add mTHP collapse test cases

 .../selftests/mm/folio_split_race_test.c      |   2 +-
 tools/testing/selftests/mm/khugepaged.c       | 190 +++++++++++++-----
 tools/testing/selftests/mm/pagemap_ioctl.c    |   2 +-
 .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/soft-dirty.c       |   2 +-
 .../selftests/mm/split_huge_page_test.c       | 139 +------------
 tools/testing/selftests/mm/uffd-common.c      |   4 +-
 tools/testing/selftests/mm/vm_util.c          | 180 ++++++++++++++++-
 tools/testing/selftests/mm/vm_util.h          |   8 +-
 10 files changed, 339 insertions(+), 192 deletions(-)

-- 
2.47.3


