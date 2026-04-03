Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35569E85368
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DDB6B0005; Fri,  3 Apr 2026 15:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33EBC6B0088; Fri,  3 Apr 2026 15:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2549C6B008A; Fri,  3 Apr 2026 15:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 177F86B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:40:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A29761B6CE0
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:28 +0000 (UTC)
X-FDA: 84618261336.20.11F500A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16592140012
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HN7jXapC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245227; a=rsa-sha256;
	cv=none;
	b=Z1y+O4kNh7jnp6dpTif06dGHU9Bx3Y/xx3TgpEuXrg5Brq+57Cqs/0SnWhKIWZOBVXiMZT
	alUBnMcoHs9jeMJ2j0r0G5qlj/orFt6q4Tw9TI10P1KMBTXFNSQXQeXsHhQnAVzLHADT1k
	blF96MC0HlJynQv2erQS+LeoEZGUeJ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HN7jXapC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mImRxwwl9HR1JcgO1qH6AH7Gz4TaSedlJCD9OUVooFo=;
	b=Tg/xG13MtKPZZ2w1g0ON2oZyLb2owgHNE7S/iAD7kw0AAZXfhVL+WyqNdhfru64haav3Eu
	z9uN+/YGqg0/JSY0ybDfWRR958s7vu7o71W7JRkt3BLaFFxWlbTk58fJw1ckDSMW0yOGQU
	iy38ML7sTVbr3glClB7v8PG4P1Mersc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8F0843902;
	Fri,  3 Apr 2026 19:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DDCC2BCAF;
	Fri,  3 Apr 2026 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775245225;
	bh=DPjrTtifdEBaKQw6NVui1Rhd5/iW96MpvVNjDyfpF7I=;
	h=From:To:Cc:Subject:Date:From;
	b=HN7jXapCcwFpY8190StoaiGbRmNWC5lrpQPE7K9FY3j74OKrf02qlfkIoV/aXzCA6
	 R+nnTVkUO6QMUcxegDG+Pc6SmfC7Tx6AxLh5CqNKzcTBEDvdSD1qwyg0G4H0+Y43S/
	 VfIcZY91k75ZfgO/u8RBtYkGz7TzWbqGUO2GfnzaqJG2yo2rVbX6wTFgj1B704EtUv
	 g1K6aMRViO5wcJhyRzgkvvvKOH6Wa5U+kEs58byvRX5pdojALzwqzF/mRLfHIh61MC
	 gb6OBmWhOMkWgKd/Qc2Q9GQLXSqm2OJ+vhSmApAeuT27X6wpzzW2TBzfLVJU2YYaPY
	 I75l0R3sRRcWg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/6] selftests/liveupdate: add memfd tests
Date: Fri,  3 Apr 2026 19:40:06 +0000
Message-ID: <20260403194014.3704180-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 16592140012
X-Stat-Signature: ydxpso5wiyqm5o1iod4w8y6pamqztkk3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775245226-954930
X-HE-Meta: U2FsdGVkX1+8y0cK7tHOBUwy7+/6N2SmisSN01L5gC/tBY0gg30IaU7/PgeIzkMzttejknH/IKnPws6luXEUHPPVv6Jph3QuXX3dr/0Hym9D7qqti3pdq4H7xhBApIVnAfLL5/mUOK4jhfKxRipS4lt4qI4Hj6SISF91t1knbco0Z1QfmSnOe9rYERPxjl5t/p8QgA08Kttv8OXxkblM7C/5yS/DjQ2mMIQS3KJitNBU+zQ010JAlg6Sp/ebEtxpNsqQVVF2g7MxwMpsc3v5IkcmsnqRiRL0v3T0etccfI3bmF/LZ5vUmcLLSnLL2ssCeGAeXsXvdu+t20oig3sQFkVaWPxAOO7t64PVHP2AqEr186au/BqHsW43HLOHGI01i8vPbW3FV+whvM4KOGX/u8n4sQTQMwjq55MoWsDG8wBbAjW43Hz8XjkilUi4Wxhes1gzIpkjZwejEGvFc2mBPh695KLhjd9SZ8Q7u7mdIaaxyIOIq6JqT7jUV7b5GyFcK4rRlIc1IlXCVEznS22cYnTwcGIYmtGlocg4WCHqZLogweOWaDy0NpTfjAKNzYecjXQDUqOa+9Wx9hLtmwqx3naxJ4GU7RJuGx5WZTuRc7AOQCKyKgPv3NRyelwOQ/hT8HOzI8P7LT+xAqYd6OAsSawWSbwiqeuVeaYhB+v7tt+TcMN3gtAEMzXwRqJB4BwWghvoga6ISObbX3FF/4cGVvjNlsXdUQbZmbpJMeKMXBZhPa3bJ8yQN80haShnd9EHtrZcCklij7qyFohgHuI5DNk3+Ytyx8PeUIijlcYHkcN5bMd78fqkrBcKHRCizLvMn8l7ZgkQL9UByNhDtrrbACV8qaP+4BF9p9sTIhdOQB3x8tQipj11QNEYTLj+o30w1NTgqDwKLaYeJgHV5NKa6myd5XL5e78ZCxzdFBcNzX2aB+VWpPDTTV0ZO5FKxOb2XYcmR1/ad9QaXWM7Y3H
 Y9+BUSlo
 muTaQlKloGF1yvPmesNsgst+1/HagsHE3mHkg5bMj+TYeGT5GyuKZW0y+mzE7mBHWfngUQUjifJ0POX3mKFE/tFy8yFICuJ2yHjlYmE37eTqbtYGuMeWII7BSxfiNQawqxikKHqQcgUJUKVGT2e5Sl1t6MRNEAfeFn4XdMwetk+a2isnERlp1tZEa3Fm5iyq9KeHqSFDzdluNrK874qPsuLCmpVlRl2owLSlgBUZwcnW8mu99HY2D8vIpj1G5p+M0HE2nvinW8SUZevevKTszF3Pj9vv3BW1ZNWH6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series adds some tests for memfd preservation across a live update.
Currently memfd is only tested indirectly via luo_kexec_simple or
luo_multi_session. Add a dedicated test suite for it.

Patches 1 and 2 are preparatory, adding base framework and helpers, and
the other patches each add a test. Some of the code is taken from the
libluo patches [0] I sent a while ago.

[0] https://lore.kernel.org/linux-mm/20250723144649.1696299-33-pasha.tatashin@soleen.com/

Changes in v2:
- Drop LIVEUPDATE_DEV since it isn't used.
- Split luo_fd and stage declaration on separate lines.
- Split all 2-stage tests into helper function for each test.
- Fix wording and argument order when LUO_DEVICE fails to open.
- Rename verify_fd_content() to verify_fd_content_read().
- Advance buffer pointer in {read,write}_size().
- Add a check to make sure current working directory is not on a tmpfs
  mount. If so, skip the tests since saved data files will be lost.
- Rename RANDOM_DATA_FILE and RANDOM_DATA_FILE_FALLOCATE to
  MEMFD_DATA_FS_COPY and FALLOCATE_DATA_FS_COPY respectively. Also
  update the file names to reflect this naming convention.
- Collect R-bys.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (6):
  selftests/liveupdate: add framework for memfd tests
  selftests/liveupdate: add helper functions for memfd tests
  selftests/liveupdate: add test for memfd content preservation
  selftests/liveupdate: add test for zero-size memfd preservation
  selftests/liveupdate: add test for operations on a preserved memfd
  selftests/liveupdate: add fallocate test for memfd

 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/luo_memfd.c  | 355 ++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 189 +++++++++-
 .../selftests/liveupdate/luo_test_utils.h     |  10 +
 4 files changed, 555 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/liveupdate/luo_memfd.c


base-commit: 98ddd87f9704ef2fc837ec2ca38877c364d8dada
-- 
2.53.0.1213.gd9a14994de-goog


