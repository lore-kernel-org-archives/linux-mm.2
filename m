Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B26ACA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734496B0095; Tue,  6 Oct 2026 05:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E70C6B00A5; Tue,  6 Oct 2026 05:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA396B00A6; Tue,  6 Oct 2026 05:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 407036B0095
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:25:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D904801D4
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:28 +0000 (UTC)
X-FDA: 85291668336.27.41399BD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 94D2D20006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ZG/jv5FR";
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E2FgdNmn6oEk5Jlq7Hb5C+tZBdjRU+OLXfXMDz1ojzY=;
	b=dZ0LXknQFx6jWPnCjueDS6liiJxpyixZm1HxeeoO9pPqlmyQgzCYtfChrv4cSSHc43mYlK
	w4r7KA33rmrKKJ/XQdIzsITdwhkLxQT37PQeJuaioaV2ieY/Pb2CSxm8Mw+a+E0+FyysSk
	ZLmRTkH22MjRyHl9i4Ty3hqNFFy/bIM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ZG/jv5FR";
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278726;
	b=Yh7BhY+BvE7VULghABUUnn/Vo/10gxHhje5xpvplksRsCcrWcJLXxFBXuNNtbg/dVkss+E
	KkRHDkn1EyxJCpSWj4pIXUN+eJLxqP6DhtjFYnr+trBrv3sRoCzuCDG3bMW3zmoDP7BSJf
	/vVyc4agDsR4zTioZQX5RsHS+hG1J80=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 294051516;
	Tue,  6 Oct 2026 02:25:22 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 46C213F763;
	Tue,  6 Oct 2026 02:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278725; bh=6ISjPM2u/Z+vYWm4XET8cat7X78rAK3YnbcaLUDy+tg=;
	h=From:To:Cc:Subject:Date:From;
	b=ZG/jv5FRf0oHlBbQSrbUzXPCGLvasASjZG8I0HHQGD15RDdVfdoNMjdxdVsnbEJOd
	 IhiLFhi37YnZuNgDPU8Mk/est4HJdQ48EJTJhmRqIRdQRypWCpa9gPxc+OaPcw3fr0
	 fM6cPSib4lHk2Z16J3OEaOheUOfrNp6uxaEcYNvo=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 00/12] selftests/mm: improve mremap_test
Date: Tue,  6 Oct 2026 14:54:59 +0530
Message-ID: <20261006092511.145776-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 94D2D20006
X-Rspam-User: 
X-Stat-Signature: ywi11czzhnoc48ayme7j494a8d9jgxcs
X-HE-Tag: 1791278726-845169
X-HE-Meta: U2FsdGVkX19aWy4bRY9RNgfrqrYyg4HIGZZm+roUnQ9XuDm744vJ1U607eAfy77+SNWVfcqSN02oCEPCFjC39M9ygpS3KZHq0SrKbBlCkwcHUN6vNzcwQMwbDsIyNAG8oOpI812RlkD9yJpsSTGAZLIVmtWAkjGJXmo5OUq6mLsbJwzYgwJJoYUPSqAr1GUHVzToHtN6f85123tEFpqNyVlb457bZR0ZYT5cqcwHqLpvLu2knGAZ0FiY8JK3d1BLyIG7lqg4eaZlDvWREdhujRBA8qwuDSSDIQBA8lOQABk3pdsCVn+9E9S/Ums8c68erkoZW9JqMtK7tv6tmbZumMSZ2ud0w7F7mmgYK4ZOdjHAWh4+pJBcv1qVxBA+gpgGsCDIY+HIx4/KHCk3ttXU23oLoGLM350x+Tn3eXvqP19Sh9FIVApY0zlhDZMr4mF+SKdQuWu5Xdz+XKkKtggEhdTsFw+tToSYwW9H6bOkvG+C0Zv2ELgYiCfLDw2Qai/K1Ti9HQFffgN35Zvz9JK0FeGpqP86YdEKjP5xXwIH5Xbw2WVkHh2b9sgOr9j5t0lV6iLC/pt8MeYhxXsjH+FTueMIOgTLXf5r+m2/tQebSIDnaGQZgfEMzBRsqecmKeiodICjw962W+6PzGWguBEFi6tfsPwpebHVimAY7Lr4A+14rzEffpW2cusa3ZHHUVTH+0fMmfCNyBfR5uzJ/LEfVCa832n4L8kJXsNNRM5lM37CVq9AK2PbbtJeZSgqz23stRmw4Y9SphspT6TU5PqLeICdpsEVCuUQeoWfPdl4aydqySa9nPrbiP5VSvFNE0Wj/JLjp9RRXvcBnd8zKvzJcSXpE+gmP+GLgC7GvFzR592fUt9kLuXIEtnOjVf2j6ocI8mfAcKv7pdaQ9i5cQwnQ3wFmdM4xz9E58hZy0qaW63fQ2lhxOuu0M2B8eqfKdprPjmNFRdKlSDLPi6zaID
 HyEYmVnN
 6JwbYhZMdQj3wcCwzQehUeIBAaALsVseqhALcPvEGZv3zuB9rXLyVVkQV+Sj9anr1zgTdCAKVHgokyUA6fww83P7VZLpzVsKkp7924PdRFrIMBY7VbvICD4+0b7UMD0D58bza5MREj1xj9r0O1ujsLieoJ3HFSExNzqHDoW2o9KEmztHqmRSQNRH2g1e9YImqaKPbzTiigeR8uxPYXLwqMaY38/+gQDuXPonGuYkyhpD5lezT/gym9Ch17QWRccr6X5P7ETU8uBv8T09eauUp24scicyXniyMt4UtORyA5NK2GsNU6bqIHaUOeUhjW1hf9bso
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes correctness issues in mremap_test, simplifies its
test infrastructure and strengthens validation of remapped mappings.

Patches 1-3 remove unused command line handling, unnecessary cleanup
checks and redundant errno handling. Patch 4 converts the test to use
kselftest helpers and removes manual failure tracking.

Patches 5-8 fix handling of unavailable userfaultfd support, unexpected
mremap() successes, data-corruption failures and cleanup after mmap()
failures. Patch 9 removes perf tests and timing infrastructure.

Patches 10 and 11 replace threshold-based random-data validation with
sampled validation and a deterministic data pattern. Patch 12
strengthens multi VMA validation by also checking the mapping state
of holes after remapping.

Changes in v2:
- Add a first patch to remove command-line options
- Add a second patch to remove munmap() checks from cleanup paths
- Add a third patch to simplify errno handling
- Drop the "correct multiple VMA range size" patch
- Add an eighth patch to fix cleanup after target mmap() failures
- Replace fully populating and validating large mappings with
  populating and validating 10 pages each from the start, middle
  and end
- Extend multi VMA strengthening to userfaultfd multi VMA test
- Fix minor formatting issues

Previous versions:
v1: https://lore.kernel.org/all/20260924050009.19974-1-sarthak.sharma@arm.com/

---
Sarthak Sharma (12):
  selftests/mm: mremap_test: remove command line options
  selftests/mm: mremap_test: drop munmap() checks from cleanup paths
  selftests/mm: mremap_test: simplify errno handling
  selftests/mm: mremap_test: use kselftest helpers
  selftests/mm: mremap_test: skip test when userfaultfd is unavailable
  selftests/mm: mremap_test: fail unexpected mremap successes
  selftests/mm: mremap_test: fail on data corruption
  selftests/mm: mremap_test: handle cleanup after mmap failures
  selftests/mm: mremap_test: remove perf tests and timing
  selftests/mm: mremap_test: replace validation threshold with sampled
    checks
  selftests/mm: mremap_test: replace random data with deterministic
    pattern
  selftests/mm: mremap_test: strengthen multi VMA validation

 tools/testing/selftests/mm/mremap_test.c | 701 ++++++++++-------------
 1 file changed, 291 insertions(+), 410 deletions(-)

-- 
2.53.0


