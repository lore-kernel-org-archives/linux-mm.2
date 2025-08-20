Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A75CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060878E003D; Wed, 20 Aug 2025 05:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010C78E0009; Wed, 20 Aug 2025 05:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41B38E003D; Wed, 20 Aug 2025 05:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0AF28E0009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DCFE1403F9
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:41 +0000 (UTC)
X-FDA: 83796557922.09.7052BA6
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf09.hostedemail.com (Postfix) with ESMTP id B8400140007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sctbnQck;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LaVLdCXndmYsJn6b1HROP2zqjNIw7pnHQe3ZO2d5Rxg=;
	b=I5XIhtVF9ycsUWRXvGA2f6dYjkT2oZwy3cwOLPNGXJpcYMv9N7Rj6mK9Hs01SNNqGL3jZG
	Mjp813M+6nPOXVKt7ff8yODFW0/wFJ21qxNOTttI6PUQLU7iZ+bFP2w80IyBBSAELUYYjZ
	LDEZgz2eGnvbep7Pz3EX8qDAnc0z6jg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sctbnQck;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680859; a=rsa-sha256;
	cv=none;
	b=f0MiD0zZshRPlsv1luwRGhWuD99f10+2u4302dB8e6JRvUPCUTtjdvSPCHsVNu0y6o0faa
	EgwLIEjrPAzpBouViWAYyfouzQT/0KCXiRBk4C6TQLwmMf7AOejfvtKzLfAHpcaiCKd1iM
	+7gg7J5paCsWRlu6Ra1eQaIurj9fel0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680854; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=LaVLdCXndmYsJn6b1HROP2zqjNIw7pnHQe3ZO2d5Rxg=;
	b=sctbnQck7eY2YTsBmp2e4jccanarGUxQa963gK3qMN6uK5b3tHG2sWFpusVwh6nIxqXjDIE2KggufBxGmc6Sk9nIZ8dvXvT/ZMQ77tZQtGekJ+5axpnMQjXx3XpZ/4yX+aRTU18cGOBo1DdGYVLaVdj+Ginp2S+3WnYDX33NOas=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBXj3i_1755680852 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:32 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/11] add shmem mTHP collapse support
Date: Wed, 20 Aug 2025 17:07:11 +0800
Message-ID: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8400140007
X-Stat-Signature: uje7c161fntjab7f49odz6wbt1ioeww5
X-Rspam-User: 
X-HE-Tag: 1755680858-320454
X-HE-Meta: U2FsdGVkX19NpfPoNRm8PjOMzspjKd1A/UgpFsPsVVjBdBupkIGqf/zBfIOMdBe67lS120Ttnn5M0rItVpn754xao+9AskHh4bupBnkq1pl8HJImp1z/GSGn6Aw7jYdIWc9mA2BgEgdtPBFb3lX1yCXdxWrx/ZnWbQtJWdarimLmbvPkXHFVdf6TILgS5FiqwvTX0gzADTDk1V6ckiwEetq9UEKZfVX3iNaOcl1+/70olzExnV7MSgqcDJgFQA6PwwDPFa6yqRbnTe19n28PsqloWs1hBkXPmR8Wj9ye0CmrFjSb7R2g/VOD5zXRntwZBwDXJnezYz4dpOMZ4upKUQlRnZSzHNDRGCh8Z6p+1jzxr68HOpPbOCRAYEx2XQQoa5NSBPIGzqBwbP+9WDpBx12SvQq74vmC5/1Sx4Mrj3NqjPvKB20/LSxcN+USqg55Bo8iWbAcvsnfR0KnYzko+D1T7VjycJrB5FPNe0LO+cqm6lb68AZVFFCZR57S/Zw5FZ5e0TC7C1UiwOraZY6cNtzKqkAGlzBtdRmXjhyedemhbR0a6GndkXNerSLhgGkgaIKeXN05PfMNVZHx/GNAl6SK0prGgGstjv3vKhmytsotCXsg+oTzw6Q8/RGkUGR73zX8z2VoWoPOoaNkyLrGX4l5b23DQgFuqNj2zuFqGdWKVfNzqJ9Yx1hdKjnHkF65Yi7pNa9Fsd1yQZxIcOEOMjzlhU6DoABF4+gHUl2EtWj9yOFRnCjzfr3MBYVQrXa/Jlw/LPs035Xht7gIQ/2pmm56kWLwE9QP3Q2/iCa69B84pXnyuQlMEEXunP9LUoLjz3FRDhoOacFNE27amed4Gtm51w0NSriHJedHFdq7ySOYe9pOx9wL1HQ+xFRpZFpdbWD6O7rlqR95mDnsyjeNWVgYtLM6fXon3Lax4J22IpCbXtnbw5NXjDy/tjLzJMzjlNPXtTYqQT8gEjnhcWq
 ww0bVge5
 DrkSC1co3G+fUV69uDY0qsUR6763f+0s2yk2VCvI5+vQGsk4vMyDNlDWWpAQPBTGG8GlxvylPyEM331LVHhTe5w5jSy/zD4ZIjxCQNMu/XhFGRhOse7OFfMFW/2od9JMW9DKn1IjZV7Kdh5opXviMmdIS+ijESDBf2L9kGnSn/U8UedtQjcTNUSnv1yoFr6WHNj0WLkDaxwRgpG4zRMtj5cTcKq5ZaPAc3o5Evne3nVuxBZC9PxJhJqWzCUYxpJWaNKO8a3XW7XINb4a/cTZHJoY7D1Uf8d7nsscBiJIM+VWN6mg6iDFnvrKv0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Based on mm/mm-new from today.

This is a follow-up patchset for mTHP collapse to support shmem (or file pages)
mTHP collapse, which is based on Nico's patchset [1].

The strategy for shmem/file mTHP collapse follows the anonymous mTHP collapse,
which is, quoting from Nico:

"while scanning PMD ranges for potential collapse candidates, keep
track of pages in KHUGEPAGED_MIN_MTHP_ORDER chunks via a bitmap. Each bit
represents a utilized region of order KHUGEPAGED_MIN_MTHP_ORDER PTEs.

After the scan is complete, we will perform binary recursion on the bitmap
to determine which mTHP size would be most efficient to collapse to. The
'max_ptes_none' will be scaled by the attempted collapse order to determine
how full a THP must be to be eligible.
"

Moreover, to facilitate the scanning of shmem/file folios, extend the
'cc->mthp_bitmap_temp' bitmap to record whether each index within the
PMD range corresponds to a present page, and then this temp bitmap is used
to determine whether each chunk should be marked as present for mTHP
collapse.

Currently, the collapse_pte_mapped_thp() does not build the mapping for mTHP.
Cause we still expect to establish the mTHP mapping via refault under the
control of fault_around. So collapse_pte_mapped_thp() remains responsible
only for building the mapping for PMD-sized THP, which is reasonable and
makes life easier.

In addition, I have added mTHP collapse selftests, and now all khugepaged
test cases can pass.

[1] https://lore.kernel.org/all/20250819134205.622806-1-npache@redhat.com/

Baolin Wang (11):
  mm: khugepaged: add khugepaged_max_ptes_none check in collapse_file()
  mm: khugepaged: generalize collapse_file for mTHP support
  mm: khugepaged: add an order check for THP statistics
  mm: khugepaged: add shmem/file mTHP collapse support
  mm: shmem: kick khugepaged for enabling none-PMD-sized shmem mTHPs
  mm: khugepaged: allow khugepaged to check all shmem/file large orders
  mm: khugepaged: skip large folios that don't need to be collapsed
  selftests:mm: extend the check_huge() to support mTHP check
  selftests: mm: move gather_after_split_folio_orders() into vm_util.c
    file
  selftests: mm: implement the mTHP hugepage check helper
  selftests: mm: add mTHP collapse test cases

 include/linux/shmem_fs.h                      |   4 +-
 mm/khugepaged.c                               | 177 +++++++++++++----
 mm/shmem.c                                    |  10 +-
 tools/testing/selftests/mm/khugepaged.c       | 162 ++++++++++++----
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 .../selftests/mm/split_huge_page_test.c       | 135 +------------
 tools/testing/selftests/mm/uffd-common.c      |   4 +-
 tools/testing/selftests/mm/vm_util.c          | 179 +++++++++++++++++-
 tools/testing/selftests/mm/vm_util.h          |   6 +-
 9 files changed, 455 insertions(+), 226 deletions(-)

-- 
2.43.5


