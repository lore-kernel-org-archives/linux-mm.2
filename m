Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE04C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A376B0088; Wed, 22 Jul 2026 05:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571816B008A; Wed, 22 Jul 2026 05:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487646B008C; Wed, 22 Jul 2026 05:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21ADE6B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:12:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E69E1603B6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:29 +0000 (UTC)
X-FDA: 85015846818.04.54D271D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 096DB180004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ui42q0eq;
	spf=pass (imf06.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784711548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FPDqfr2rLPR3uRJbaSYiub4wVAZzuM39RjFvMBAAGos=;
	b=DKQn8a1VQ7V8/nuHIyLnHxD3zWDWRzYVpFccUwW+YtkJvVsJbQxSDc+zwmnSRsH8OFTOZb
	V+vcKDZtKdZ6QsVovN5nnAbXiHqfwhvJNUiDDhoOeEuCs0u2VMEtGfM+f772YN9qEWSHL+
	97TRbSCwJiHAwvLGxjYwl9nWGnvbMNo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ui42q0eq;
	spf=pass (imf06.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784711548;
	b=w9p9rKEYSEYgMdml1zSZd2gFDP335fehAU4tF1YoQ/dcBcrcQZ5cQL5UNua7dqfMfZPrpy
	HHMc6kzOjX9coMkgZrQGrXShbhzQ0xpe95O9C/yZHJjq2zsLXYVkHlxy9ndIZAb0IHEiul
	MprPtM5FBEQZDTjDcTsi8VJuHCuHCds=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EAE01595;
	Wed, 22 Jul 2026 02:12:22 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9D2F83F86F;
	Wed, 22 Jul 2026 02:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784711546; bh=aRnuFbYmxuzHtIDm1YR9dnNIB8HJZpB9ssKA4sZZP+s=;
	h=From:To:Cc:Subject:Date:From;
	b=ui42q0eqh0FmzLexEzHBPekesvUyxl58Grtq0nXlWfTIRfNyBdi0nULaQUlQfvrWX
	 i2IJUqM2GEOazslVCNUNcWi+ADydnJDwYd6z7iFO4LPz8SZSMdZEFEVytW6XpMpL7K
	 ET0JO12tvo9+/+khCDkAugm9Nm7OD5D4JT1JA+5c=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH RESEND v1 0/5] selftests/mm: Handle unsupported and transient test conditions
Date: Wed, 22 Jul 2026 10:11:34 +0100
Message-ID: <20260722091219.61504-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 096DB180004
X-Rspamd-Server: rspam01
X-Stat-Signature: wok4w7b9975skxkftcczakrbm9urmkka
X-HE-Tag: 1784711547-736402
X-HE-Meta: U2FsdGVkX1+RfnkdemclStC9BmOLEIblqxerSLDL/JU+nzopU4zrNiTOMA8TWokOAnm+9ADqR1zO28bcCHND66F5yFWlzhCwuvr5bBqwDaI45AjGinQRCFHECVD9EfC1za0dMBMgwC0igPGgSAiB08cvmYsf9mD/hpdcG+YdHZNzuAG07zd432H/LFJDSCo7mI1zLz+PnRMlFFQMj+LUvPNz0yapkHQ7iLGl3m3zev7SUBAz9CWwH7uXJNRPXs/s4Q1pPVRUrBe7tSGFY3n6LgW4y9ITQWbL+73T61P4cHyTEJzkZbJ1LLggrrvLLcs8q1QqwaxTqwYc/3M15/19cOz2xgAmr8a+QwpR6t7pl7PXx6ywe/GI4W6Kl0WwKGeKoXAAd2spz8dujMzfa5dBR8YOyHTxgllpzqTV1XeYhqD5uKzXiwmsSfiT5bGzTqmwFlkD/mvWiz9HiycUNuIquXcs0fwNBKrmipirAmgj2uwWTdtmJgVjFE3/fHKSR0u8x1INPxrbdojP+Xi5/tSW+JpP6KioqBqMAkUodFK7noQuExY57GLOCakOezX6LQcaCWDwhXfFP2MMhIXFxIUCCiiud7mpOU7EQi6OOJtKCccL7PErctpeKTfE7D1jouLXtlINpBZNubOajmjmjhwTk08YQv35SHvOfnvIUyr8+xbyO+d/4QhHbkAWzZXJcHLadDpF+AtXuIdBZOLi8OX0CkDtNheTJLS1sbHTeaj6iaaU+HM5FV/u1ewR5ePgGjV85kvNjZQ+7Eb89wMfd8pkE35d6+iVEIP3mN3LX0OK/lZcIABTxI4V/FPhz7VS8em3/l86UtKbt5w49jwbB+PbJqaAqTYawrDbjiu/USebqi6GdTMGrdEq+O2T6FeCuWkPUjaQpj9SnEOVdi3K5CHojDTgGkyD7XwG/FTqM4XgPtDBIAQ/AhUJWsqtNd775MIrWBt79jlnmO7GKJ+TT+i
 px0jF7e4
 jtm6HOm0z5O29evCvk252WC0jrQL/qi1MEYIMipQv4qaXk48LltjyhVNEHCQK/ZWUfFRzWVqhITgowYDIyPbZ5b355LTAtvrMbZ4+fEB9I2vPwoY4E+m5uzbDp4BqoejRNvWkkV8qisgljweRRgo/iltuuNy8SUim5WpwK5IK+B5hdxv6ik3nhMZINsqVbWBbnvgrYJ89r+JStCNGUaVT554TQiHMuUDqXuqU3w8jpW+rBD97Ox8yfpqumGQ1KgK/tst8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several MM selftests report failures when the test environment lacks
an underlying prerequisite, such as fallocate() support, MADV_REMOVE,
local page-cache semantics, or swap.

This series converts those unsupported cases to SKIP while preserving
failures for unexpected errors. It also allows migration tests to retry
transient move_pages() failures.

Tested on an arm64 Ampere system using an NFS root filesystem. The MM
selftest run completed with no failures or errors anymore. Also verified
on x86_64 to make sure they don't cause any unexpected errors.

Muhammad Usama Anjum (5):
  selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
  selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
  selftests/mm: skip khugepaged swap tests without swap
  selftests/mm: skip page-cache hwpoison tests on NFS
  selftests/mm: retry migration failures for the full runtime

 tools/testing/selftests/mm/cow.c            |  9 ++++--
 tools/testing/selftests/mm/guard-regions.c  | 10 ++++--
 tools/testing/selftests/mm/khugepaged.c     | 34 +++++++++++++++++++++
 tools/testing/selftests/mm/memory-failure.c | 13 ++++++--
 tools/testing/selftests/mm/migration.c      | 34 +++++++++++++--------
 5 files changed, 81 insertions(+), 19 deletions(-)

-- 
2.47.3


