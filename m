Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1E4C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C9D6B0092; Wed,  9 Sep 2026 19:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A866B0095; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A286B0095; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5F006B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7D3A140388
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:55:48 +0000 (UTC)
X-FDA: 85195883976.22.30906E6
Received: from out-93wp-a34.jellyfish.systems (out-93wp-a34.jellyfish.systems [104.207.68.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 04D4FA0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:55:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=a9jIM5nT;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf15.hostedemail.com: domain of hi@tychen.cc designates 104.207.68.34 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788998147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T7jd44gstMNeWdAHdpYwxJzLjuFnV0LDcX+sE500ubQ=;
	b=XFtTtBFz52GJT5qrMgtToGVkhMLy7TOYP+mZjLweo4aZsJJ9sozjv+jbjJk3lognYm+KSN
	muN8OWgSc8+mOPd7V6v4JdfxxGVZp4b9Vn7zTs2ccgGViK/1zmggewUe1X+2W3L39URplH
	lTFIijH6Iban7uwC61r9R/sULSxLqAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788998147;
	b=CZsUx2TKh9LxFIa1n6RIwR3ImE6sUaDZ1ZxFtCWOMaOl/pcabcAOrJqkBcLvKZ2ILaOTzd
	yetjXJvvOWVFZFdJU06cOxBgevVOAkW5a7y1fglYFnOF/gzdiyP2RWUHgj0IuOCwqh6P+n
	ohZP7jrnN8VQkvUeQiKzPtR0EjfA5Y8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=a9jIM5nT;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf15.hostedemail.com: domain of hi@tychen.cc designates 104.207.68.34 as permitted sender) smtp.mailfrom=hi@tychen.cc
Received: from 192.168.5.7 (unknown [23.142.132.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hgHk55JQSz6tmK;
	Wed, 09 Sep 2026 23:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788998128;
	bh=T7jd44gstMNeWdAHdpYwxJzLjuFnV0LDcX+sE500ubQ=;
	h=From:To:Cc:Subject:Date:From;
	b=a9jIM5nTa3UtzmDc+kqmLj5+pq3c9Y2ff4yr75Bs00QT0Ro97NRjPG/oJs49cshDz
	 SjGlj7dIiKJWhZ40CYre31lJuKzgXF60iHXLhQNyazzn365iekR2txbjTkY1NwR+sE
	 CgyKZE4jvDNt7COpdXb3UrP5nshXvi/dTWgEKeLjVv/5/PITuetL4TVTDUl/1j/buh
	 73+cLDhnQkBDDhGVOsvmwk6+bIWV5f3FKqp3e2CirpwLzK3Otsq39DfpsjH39GpyfR
	 OUjWiwqPMDtVtYfYNHyN7cN6k4iHF3eLbbMyP0NECtcYlHz7NPRy2tK1U4kWcAKRuH
	 2121/wgboGZCQ==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hi@tychen.cc
Subject: [PATCH v3 0/2] memblock tests: cover low-address allocations
Date: Thu, 10 Sep 2026 07:55:22 +0800
Message-ID: <cover.1788997523.git.hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 04D4FA0003
X-Stat-Signature: 79s11qf4uqqx49weofkchc7dozs46hx8
X-HE-Tag: 1788998146-611452
X-HE-Meta: U2FsdGVkX1/IWVkFbU/noATx188wN55A1vBPg+rFpTfMZkcFfzNilZmkwfWHE2sgsfFLHTU+fT3RThCe+6n/4bpMg5Qs3oaPG6aL8TT5B/WW/hAtp/AF2f2EtqLgCJv6YLAYOn6d7DQpZyPYm9jEITnKDD7JxvJ0u3gEB5zrPOvE62Uvr1qkkLuwmJANpwptCm2ISgqic8lmIhAK6LBWNZFfDRdSl6wMD1iLx7xR7C4rx6bFz/QiLM7MxfJsnXBmA2lf6YxWujESoz6PkfS80lkC2mRn/MxGwd+cvPG68Kz2fvNIutwgW7viarvpsju6zi8ZbVQ2pn9xhGbr05oxNvfAfiZhV7wt+9T7mHw0PwXnY0OOzk2hUOygkwh9wnqYX4Ms/jBXWuNA/ufvYfrROGKu94aV1G6hAEJ14+Nclhvzdst5efnScsAMEGjMO5PLa3RdFhZfAlL/+SYzBr3MCWgWj80TOu7xj444VOrJcwZ/dGI6kYQeCF2idLhMwylhyyTUuERScEnOSLrmFFGA08CvPeRT543fiIlZhvi3dJDFO4PHyxVcaT1V8Koty+h+rwvdABJ9AU1Lp8zJDTu1jiGqfsW/9ox2pVqnOLkak2JTLVSqbnL7jLTn4PDPbS5R4UtGsssdWtb2L/r6rnX09210/6WP9pZ2k6WUeSVEwv7MEUJ6H4a03gBJNDWZGIadcmdEa4M4G30GvXP9WHEeCBdSzpLZVUrcrhOqCLFAdWvwz33hH8bMBdtv+Sy/9ZJiy0E++CHTfcS1AdN+5Iwzw4JNCtfMDyfUDLkFlcCgJ2QpBPLZyr6EDBUHR2RT4gJxlPmRX9rNvQddw4a+9w/wfTxGpfZxcK2TVXCMhKDF3Z9wKTqyvl8T8bPsVgs61jKTBWw2v4767ngvz2WJGkijRs9mQfrKwxioJpIxi4wcH/DADsXyMpsrc4ZMk8dzurj+5NGs4ODkX4T5fpeHhxA
 eBhyL6/3
 BPER31jox+n+cAOxt+q364VRbqmR7+OAshRSuncU3zWxsqkbBELi98QXIa32BZj2nJtHKj7DXhbQfscwYAF/GQ/kwjq4m41CzlNG26BEtWt2vMfXJ7l0FV/u0uCQmuv7EpH6epijuLXdedYGfLGDLJVYQ2TaSYdZcrV2pI7ZHbcyRDOKZd/gGaV/tCPfHBrE4mTwWcc0gFkQIO2+vMM0KUlLxT/hrsuuruTTU3YoLCVsGJX9njVd9sncPMQ7Aeq88cDs5Mi1fu5X7K5ZuuPTtcU+82Z7a6CYai7vHASXayoAUWqDC7XpiOS5y34TdTctc+oicrni+ZZD0nfvH//8zeNtPySl+zwzMNh8btzLJeDFFFNc0iitTlGQpQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Model a low allocation limit within the memory registered by the simulator,
then exercise memblock_alloc_low() in both allocation directions.

Changes in v3:
- Describe the low limit and simulated RAM alignment directly in comments
  and README.
- Use Assisted-by: LLM in both patches.
- Start a separate thread for this revision.

The pointer casts remain unchanged. With BUILD=32, pointers are 32-bit and
phys_addr_t is 64-bit: the tested compiler sign-extends a direct cast, while
the conversion through uintptr_t zero-extends it. The direct casts also
introduce compiler warnings, so this revision preserves the existing
conversion behavior. There are no executable code changes from v2.

Validation with ASan and UBSan enabled:
- Default and 32BIT_PHYS_ADDR_T=1: 189 tests pass in each runtime mode.
- NUMA=1, 32BIT_PHYS_ADDR_T=1 with NUMA=1, and MEMBLOCK_DEBUG=1 with NUMA=1:
  272 tests pass in each runtime mode.
- Both ./main -v and ./main -v -m were run for those configurations.
- BUILD=32 builds without warnings from alloc_low_api.c. Its runtime still
  hits the pre-existing basic_api.c memblock_free_near_max_check assertion
  before reaching the low-allocation tests.

v2: https://lore.kernel.org/r/178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc

Tianyi Chen (2):
  memblock tests: model the low allocation limit within dummy memory
  memblock tests: cover allocations below the low address limit

 tools/testing/memblock/Makefile              |   3 +-
 tools/testing/memblock/README                |  12 +-
 tools/testing/memblock/TODO                  |   5 -
 tools/testing/memblock/asm/dma.h             |   6 +
 tools/testing/memblock/main.c                |   2 +
 tools/testing/memblock/tests/alloc_low_api.c | 148 +++++++++++++++++++
 tools/testing/memblock/tests/alloc_low_api.h |   9 ++
 tools/testing/memblock/tests/common.c        |   6 +
 8 files changed, 178 insertions(+), 13 deletions(-)
 delete mode 100644 tools/testing/memblock/TODO
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.c
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.h

-- 
2.55.0

