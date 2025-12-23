Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70C71E6B25F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513B26B0005; Tue, 23 Dec 2025 00:48:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE5D6B0089; Tue, 23 Dec 2025 00:48:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A556B008A; Tue, 23 Dec 2025 00:48:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFD06B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:48:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D04951404EC
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:51 +0000 (UTC)
X-FDA: 84249656862.12.C8ACB51
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0F81BA0009
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ImeHeuCd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766468930; a=rsa-sha256;
	cv=none;
	b=RV/9ikAY+eLsGV6PI49aZC9RqWCKs1zzxlWb+wxvXWh8uacR5UxVJjtxCcVqexDkUHQ9Db
	XdFzyw++q/hWBmWc7o2KGFhRwAzez5Rxn/T42jNwDJ7kx7uNT0w4prO73L+40rW9AgXmHw
	24nRRiBDK2/PZwyIohYrLsw8POnmmGo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ImeHeuCd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766468930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wurmuUfiWrJaqPqHxOTjUkR5eHzUJvLVCpRxkAiKRjc=;
	b=TyIHZB5vLAuzBePl4XoSLb0bhzhFx+PBVpW5Ln/ubrr/fuZXaWzltnGNZpRaHQpz1E0Bl1
	jr9M8vp1ccKMnjUoR/ENFJhQYOfkYuFKoCNqWQsP/D33O2a5loorXMzQA4ixQKfhWch8ti
	bjx78EKUKXgm28Ct7H96StxXsFLsoGM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766468926; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=wurmuUfiWrJaqPqHxOTjUkR5eHzUJvLVCpRxkAiKRjc=;
	b=ImeHeuCd57NwPMtWzd51UaBueoAfFOXjGMQ837zcuThKeQKZOWWUMgIsif/t8o6JfskqIaE5uIJBn2dVBvxm2NucsQmJoZ1slJ7xWmydn/XY5BLM15F87iQrCPPYWb1SYWH8Ht+slH+1eLh6quNDlOQEkXpNKK0bBKUayvRo74g=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvWX.R9_1766468923 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Dec 2025 13:48:44 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] support batch checking of references and unmapping for large folios
Date: Tue, 23 Dec 2025 13:48:34 +0800
Message-ID: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0F81BA0009
X-Stat-Signature: 4zo53ziiqd19sqcy1jqbc8rj6nseb4k9
X-HE-Tag: 1766468928-668661
X-HE-Meta: U2FsdGVkX18MHmOnV5J5k0iudH4v6vhuQFxfBu1treZ1PfFI1MsZaU2NxsO3Ues21yIoYd22NgOQue+Yjvlysy3nO3GUNkpOq3lBmirlGqC0HNtfvSiYN/wwXEJqudvJR6geXbMbWNMexrBVCqKobZC6zbcTh5/dkW7aYxYb7vQsIODm8ocbRlJO0B0zD9BnqqDK45BMBU2SgPquC/RZX6WOCFSfzwZToIrwO3LYIjmcTdaK+FTdrBTqlIy9wACW3l75wtxq7zLYdem6ZlfL4ALDpqUznsZc/vwBh6KJWnpXi/KjwfmAf492Xrt5OiQ6puigJMGWLSxlr8YXwBkiK7Y4l6wuf7VT41nbTC0B03zdvMuU0zhaQQWS60564gYhkqiru9Kz/bmw8hAq3uNrTYHJP7sfCvE15pzV4IVuOAObhpQeW+D55j8ulbTuACVqlMadq9TkXo9lUn2SEoT9w287OUYyxqt8bnHsSdHUg7r3PfOkuqc5VPXXf0S4xmjgale9kkh6IagnD5ME/2IF4jg07VoBIpM4/SZ13uD5amAQu6t/yeM4zDeKo6ZDaucCjSb5KshQQwruwGIjDrcEXVemhO822cFLq4F/bOfoXcxov7M1V2iOgSiRNezGL9y8c2OUNTe2gS2fVD4GW2BtBmrobzAfG+gCnQyFvdooMduSaIWDjj+h8XZJXutUDrT0ZC8q6YwEzgQINbW0Zz6BzLHyKvmxNWqiKYvd4zH8MW9Lv3CgW0ojDEfUWXLmIFGQUh6CfQRczm7aEpdzWOcklg5Q5ISYvJka66apzFggrV6nZuidTdx9sC3YSkG7wrMcWt7qQPPdy/um3S9j72nss27gVUb29ZxpjDZEGC8rpz4Xx64nRqhaE7BjHpwwgkQ/8SENX03c8JA0mWteO3GbB+f6gV4JMdhdlI7tl3uki5Y+JZFxjJ6MTwwFSTM/Qd1VdQaGDmUV6fR+I0g5rOb
 tcOzn+ig
 ckwcscnDG87wuzpcRdfP24qPPI4yXqHFoRTrc8PVOHE3DQbLUfKXKC3oghtr9GT9QL7gimF62fV1i23uQp72P2F5wCnv3eBHek3Ce57qydAYmDVKWTxY42Qief1w73+kG2OuQi3Yi5gwmdxJqZFGQOkG8ptiRQPZOdTnoRFNey5kqIMyDNXps5126UJG4vLa3OUcvE0vAp3tCCwtf9m04NBBlU+CKAAIMc6qnTikeHg5TOYBUsUf+tzeCs4kfvOTM09Mz6acWz//xo1g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_referenced_one() always checks the young flag for each PTE
sequentially, which is inefficient for large folios. This inefficiency is
especially noticeable when reclaiming clean file-backed large folios, where
folio_referenced() is observed as a significant performance hotspot.

Moreover, on Arm architecture, which supports contiguous PTEs, there is already
an optimization to clear the young flags for PTEs within a contiguous range.
However, this is not sufficient. We can extend this to perform batched operations
for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).

Similar to folio_referenced_one(), we can also apply batched unmapping for large
file folios to optimize the performance of file folio reclamation. By supporting
batched checking of the young flags, flushing TLB entries, and unmapping, I can
observed a significant performance improvements in my performance tests for file
folios reclamation. Please check the performance data in the commit message of
each patch.

Run stress-ng and mm selftests, no issues were found.

Patch 1: Add a new generic batched PTE helper that supports batched checks of
the references for large folios.
Patch 2 - 3: Preparation patches.
patch 4: Implement the Arm64 arch-specific clear_flush_young_ptes().
Patch 5: Support batched unmapping for file large folios.

Changes from v3:
 - Fix using an incorrect parameter in ptep_clear_flush_young_notify()
   (per Liam).

Changes from v2:
 - Rearrange the patch set (per Ryan).
 - Add pte_cont() check in clear_flush_young_ptes() (per Ryan).
 - Add a helper to do contpte block alignment (per Ryan).
 - Fix some coding style issues (per Lorenzo and Ryan).
 - Add more comments and update the commit message (per Lorenzo and Ryan).
 - Add acked tag from Barry. Thanks. 

Changes from v1:
 - Add a new patch to support batched unmapping for file large folios.
 - Update the cover letter

Baolin Wang (5):
  mm: rmap: support batched checks of the references for large folios
  arm64: mm: factor out the address and ptep alignment into a new helper
  arm64: mm: support batch clearing of the young flag for large folios
  arm64: mm: implement the architecture-specific
    clear_flush_young_ptes()
  mm: rmap: support batched unmapping for file large folios

 arch/arm64/include/asm/pgtable.h | 23 ++++++++----
 arch/arm64/mm/contpte.c          | 62 ++++++++++++++++++++------------
 include/linux/mmu_notifier.h     |  9 ++---
 include/linux/pgtable.h          | 35 ++++++++++++++++++
 mm/rmap.c                        | 36 ++++++++++++++++---
 5 files changed, 128 insertions(+), 37 deletions(-)

-- 
2.47.3


