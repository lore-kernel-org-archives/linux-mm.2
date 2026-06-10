Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590BACD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366A06B0088; Wed, 10 Jun 2026 06:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C52C6B0093; Wed, 10 Jun 2026 06:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D736B008A; Wed, 10 Jun 2026 06:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F21EB6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BD231408C4
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:38 +0000 (UTC)
X-FDA: 84863631636.21.558345B
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf24.hostedemail.com (Postfix) with ESMTP id 66F1B18000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HdHLOaBR;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087376;
	b=Xq95xGmBhLF1wKyTX0f1vGvtT0Z8Ztj8BqSDV58f3c1zPzAXRps5RLxXpyh56uCubmNI5w
	vi43kpr1TX3HSZPj9vNZLlFg4UyrJug0bCS+RmlV/2sZY7H6eDv1weRPwhDvBHrVnF3HIi
	BBobz7XrQnYki/IwHZUKbZCp/n3TeHs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HdHLOaBR;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BbCWmlCmn/Tj2Not5xAOtZkBxC6r0MbruxPRpmXFBTY=;
	b=EMG8FkIk5MkssdjpviRs2HtvGvivaWyiIRohGMau0PWHl2RZ2cXR1umRivarDvD5pUxbyR
	dKotQ30waWlGewmznu1NMC2U2DpRj48ORNbi+QhSHjUiIL/FXNS55gGLi83Sls8UyXG3Pd
	fF++mwzUZSQXluRwN3pYy6xDL2cfehc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087371; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=BbCWmlCmn/Tj2Not5xAOtZkBxC6r0MbruxPRpmXFBTY=;
	b=HdHLOaBRprZt9/6kfkkVvY9YYLGME4p5Q8nqm/kZi6AgHHeV/gs6uMbsGBN9d2eIEq8aoLa+sc9fKP8fb8ZDrNECdVDkvwZ08CFyT7spixkX+ipV/glg6CoQ+uv5Touocrbb90T2S2ACpOQQYkSgjsKBaSoS35M21IaorhUMz3c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aHmfe_1781087369;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aHmfe_1781087369 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:30 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 00/11] add shmem mTHP collapse support
Date: Wed, 10 Jun 2026 18:29:08 +0800
Message-ID: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 66F1B18000C
X-Rspam-User: 
X-Stat-Signature: neb1nsggif6fpb339iypnreq9tgahwed
X-HE-Tag: 1781087374-166993
X-HE-Meta: U2FsdGVkX18ObAjL+/cO49GNcn5UcGTVc+qA9deKQ78rPVZq/er70X+N9ddEDB6VvjmbaCdZLCTgukZaSTmylSA8tA8r+PR8MnWID1UYUun5VJPsTwJQzv198OvHne3tSxlkxnhPcsJ/PcmLKvQEQzhFvOXn9Z9rfc7Pj401OAFUFC26wnyvxfowxd1nxu/PJ3YjvAxbqtMY7bKWTma8zHkm0yrVhDYn50LA/k3/SWwi6J6q3kDLdQudmG3lPBwYEITZHVEK4pSU0XOOqwg4V74HVj+mbRT3yHX3SVLV9nsI168qznBPyLcey0ze1IHD0cG4f+rqTX/9xNmCq+d7+qia+HjvYe8tVa+nlK59vQocewH0SD6fCAsU+jfbhBqsMIxVzWlpESWhIAEUmbVBWnKsk7zWv9TO5xrWIfqcdTdC1EmZwzGc7tViquQiHV/cnaYNvMsiBOxNESPL3/S9hb6uAD3CDojux0p0/B+QZIZkC+TOzrrENgQMjJT4meDAy6X7FsqRhQ0u9LL1OHax3+Guc7Uwi88KEqyW6uRxitlF+maPyMLZxQNezQSZXFimB8faZokQa5lscbHbZZ5f480Yhf9DbENqdlNOvy74/YnE8kSNDGLFE8/jS/RXttPf0DMH1zffs3R6O0hxH6bus2r3Zxfamqydz7SyOQSXotdi9Mjk/VdemmW6giufKJJAmHKx1gmFMVvd4kXScgQTHb8+jZXAlKrBz38MmZQ4W8nVFvzG6Z21PZu7djAEPAOH+gXo8DNT6nR7VgQR9FONOgek8P0M+nuVvZphPcwf3ykuraLlAVIC25ZJ9YON+AvYnnBofIntI5FMsKHzzRBUiMApprq3lJJAElzBMLF2wU1zrb13AEEzIy6amCx2U40YZ/BLi1/EBfXSAJUGiLBJz9akElIfN5ov6me6tiGFoZjpDK6oWrdT/AYa/h1KyrvAi7fA9wwnenJjHljxqe3
 CotJyzkK
 fOnvx2VdpY7ZzZGo8o8R3qagNr+jDNwyU/hRmwwz8ZLEE/Onf8m01tNHlB3csVevOr/fJSClj3Zeb9sGlPYg4h1QnVj1SdVcxyrB0fP05r4h0EKHAcIo0RmS1HLaYAlGTFIy1d1GXgOCUR9DhZ3uFMNOWw0LDuuFqVLqcSR/BXwh9t3mWhlBYbq3norPV4Zllb0dQAwJWXjCA3SKFg6pOAiGPBsaadhBpv9fhWXbfDrucvjjujsgcowBPWX9wFA0+yoi6xqKhnSOqUMPI1Up/A5QAVw7i3zwckO/q+GsSgJ2BpvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Note: this patchset is not targeting v7.2, but posted for early feedback.)

This is a follow-up patchset for mTHP collapse to support shmem mTHP collapse,
which is based on Nico's patchset[1].

The shmem mTHP collapse strategy follows the anonymous mTHP collapse approach:
track present pages via a bitmap while scanning PMD ranges for collapse candidates,
then use the bitmap after the scan completes to determine the most efficient
mTHP order to collapse to. Built on the basic framework added for anonymous
mTHP collapse, the shmem mTHP collapse implementation is straightforward
(Thanks for Nico's work).

In addition, I have added some anon/shmem mTHP collapse selftests, and now all
khugepaged test cases can pass.

Note: I have not yet enabled large order collapse for file folios (file folios
currently only support PMD-sized large folio collapse). Although file large order
collapse would be more straightforward to implement after shmem mTHP collapse
support is added (requiring some changes to file_thp_enabled()), I think this
still need some discussion on whether it is necessary to support other large
orders collapse for file folios.

Comments are welcome. Thanks.

Changes from RFC v1:
https://lore.kernel.org/all/cover.1755677674.git.baolin.wang@linux.alibaba.com/
 - Rebase on the new code, and update to use the new functions.
 - Add more test cases.

[1] https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com/

Baolin Wang (11):
  mm: khugepaged: add max_ptes_none check in collapse_file()
  mm: khugepaged: generalize collapse_file() for shmem mTHP support
  mm: khugepaged: add an order check for PMD-sized THP statistics
  mm: khugepaged: add shmem mTHP collapse support
  mm: shmem: run khugepaged for all shmem mTHP orders
  mm: khugepaged: allow khugepaged to check all shmem mTHP-sized orders
  mm: khugepaged: skip large folios that don't need to be collapsed
  selftests: mm: extend the check_huge() to support mTHP check
  selftests: mm: move gather_after_split_folio_orders() into vm_util.c
    file
  selftests: mm: implement the mTHP-sized hugepage check helpers
  selftests: mm: add mTHP collapse test cases

 include/linux/shmem_fs.h                      |   4 +-
 mm/khugepaged.c                               | 174 ++++++++++++----
 mm/shmem.c                                    |  10 +-
 .../selftests/mm/folio_split_race_test.c      |   2 +-
 tools/testing/selftests/mm/khugepaged.c       | 195 +++++++++++++-----
 .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 tools/testing/selftests/mm/soft-dirty.c       |   2 +-
 .../selftests/mm/split_huge_page_test.c       | 139 +------------
 tools/testing/selftests/mm/uffd-common.c      |   4 +-
 tools/testing/selftests/mm/vm_util.c          | 184 ++++++++++++++++-
 tools/testing/selftests/mm/vm_util.h          |   8 +-
 12 files changed, 492 insertions(+), 236 deletions(-)

-- 
2.47.3


