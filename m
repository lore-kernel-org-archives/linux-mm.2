Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25537E88D66
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 10:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452576B0005; Sat,  4 Apr 2026 06:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402976B0089; Sat,  4 Apr 2026 06:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318336B008A; Sat,  4 Apr 2026 06:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD186B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 06:25:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD22F140784
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:05 +0000 (UTC)
X-FDA: 84620490570.10.B481F00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4760D1C0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ARqHXi/t";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775298304; a=rsa-sha256;
	cv=none;
	b=Y0ieI7KqU4xDzKShNjNNCUrOCPiOJmQDM9qHc97V+2cQs1251Dy3WcwnKYYXpDqInfdyzB
	uJwTVeHpngiE3jYKKC3XkiH7/5I+51DqYDkgBEAwEOtJhXasiu0DTgoEuz4YCbN2FIo2h5
	yT9+ylhVr+2iltaxiaHA37As4qZdpjY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ARqHXi/t";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775298304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HRa6VAXSr5p5/uTzpHiQHPWlAGVlH1z7tXnisXSclb0=;
	b=AFKdIKnZ6H8LruR6TbxyxJbRqlfCqXTooGVj2JfpkuXcFkx9Rnszs0XzRAXRtxTDL1RAjw
	spSQICyyYS8ZvIUgXonm/mEhkm+QV2xmwuqB12P021BA35pLFwQPCezmrAVseUfq/p/l1F
	xuHQTGdqzBEMIHYm70XecU6wsUIDXtc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68C6760008;
	Sat,  4 Apr 2026 10:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F80C19421;
	Sat,  4 Apr 2026 10:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775298302;
	bh=ByOnS4HzfTTQZAhJJz0SxZtaNSu6NrKjsBAusN0AUIs=;
	h=From:To:Cc:Subject:Date:From;
	b=ARqHXi/txN5TnqjmiEtATZ5YeyNFtrgSqgAOXqm2MIXFiMtNrcNH4JY8A6iuwObax
	 KBBcbC2KKFqd9QnITYW7rB4TVbeSb7xvC9sFCxKuoBL4gA6N8DivPVHO/peSMLTD/+
	 gQ3zDiN4pjSoZCcqJhBr4+zI8yJWGLd3wt0QKQ4P9AkHz7JLhvHQqTtx5SZe763dWj
	 qxxGiayspP6LgIGcl7D7Amrc3O/+leWsUJ2GWKOCQfG8IOYQxRWkjRQZxGdb1UIWBt
	 VSkizps2OPJYNz48d60nT5uUKCHuNFLwH3gby/k2Ssc8LwNMEbOcey0tpWBaN6Z1X8
	 n6AUEN1OxBn3w==
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
Subject: [PATCH v3 0/6] selftests/liveupdate: add memfd tests
Date: Sat,  4 Apr 2026 10:24:43 +0000
Message-ID: <20260404102452.4091740-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3nrabi5gw7eqpnfzs4nmdmrbkga4czif
X-Rspamd-Queue-Id: 4760D1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775298304-316043
X-HE-Meta: U2FsdGVkX18V3KTuv24FdoSWL5HQ/zhqGPDiB3T9+2uokVAS0Boku5osdHAdP3Zqy6+/V0LIOTYAGXok23JjfmRcVMdui/mNf+961xKWwHofs42jbXH/3kLvQevQa5Z8NA0t82m0l1hZ9WxXJfF3IgOIHbWHDrWqdIHzXIyJIoH+57Qi0zj6qlgC2qimW4eL504AR7DucS8e1BiFD4oMrO1wshwJxmk9bfBoZVrmsnTv77weKLNrQ+6+GpW5xczc1/kI/cAuLnUOytDgxZHfbIl0FUAn4gVoyyFk/6Z1cIe873qGO9zJBf9G+wcTFo5WcdiEV2diB8P33YJhgJMJXteLwKDLC6wapRkKo0Uwz9lJokpsJyQt2iPXbWAOtWxsXcwEFnmKCkQhlj6j9jCWOBlVNCRhSCeyvgrYWoh1afS0mDB35x6v6eSS3dmBCuQi1GIc+Hk8GIU2Hj6B43ZQ0HZIGIX31XOu1jSjH4jcBoMkk1Dhbyzh2+pFwbwwZawGRW7EYBKoT11KZbAag4dCy7S4dY5GZYehw0p2wAOxKiZAzEEC9PxWCB5BGmkdcbgkcPXr2enwapI9MQx1oNI5Xt8+NaF2Q4lE/pKlcyoN1CYK/5nO8Dop09e9sKqpblz1jsy2TjPcvpgrIVwFypfuPeJ+DwFSApijACQX9++Iz+fIkKts0sre55Nsnkor4cIjhtEBkgKMi1X6il7EzIEb12AjAvb0l7a+Dn4Y3UGhKQaFG8iQYXAaeIWgpx/aJ2JcgAuM6EWEY2ISC6An08fFJ3GqnbkjsL10n4uCWgikxQGl3axWx5as/gcLz8bC+G0puPN/gjoWWCbsc+DCFmHeVO5tnO2Cj0Q1ZO6eujOMzRoFa3Pu5NOl3gcOJFkYswxhfRWAulJdqzAOqE2nXeDgUlyPQ5XPmMAJS3Braz1jzvK0OiR3424I/A==
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

Changes in v3:
- Retry on EINTR instead of giving up in read_size() and write_size().
- Use O_TRUNC in save_test_data().
- Return the value of write_size() directly in create_random_memfd(). No
  need to check errno since write_size() already returns -errno.
- Save errno before calling close() in create_random_memfd() to avoid
  overwriting the value.
- Use memcmp() instead of open-coding the comparison loop.
- Return value of test_harness_run() from main().

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
 .../selftests/liveupdate/luo_test_utils.c     | 191 +++++++++-
 .../selftests/liveupdate/luo_test_utils.h     |  10 +
 4 files changed, 557 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/liveupdate/luo_memfd.c


base-commit: 98ddd87f9704ef2fc837ec2ca38877c364d8dada
-- 
2.53.0.1213.gd9a14994de-goog


