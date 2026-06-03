Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23CBCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D7F6B0088; Tue,  2 Jun 2026 23:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE7D6B008A; Tue,  2 Jun 2026 23:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF326B008C; Tue,  2 Jun 2026 23:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9BA56B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79E3340209
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:09 +0000 (UTC)
X-FDA: 84837170418.29.00A6FE0
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id C48E1100004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Tv2HhggE;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457347;
	b=cc9T3bRK6Pqo49Lpo9uM75hFwoTScweo5NoLYEvVD2yERy92x41pyzPmD2PSfpZO9qKGqj
	BjbaR2EKz2jHyf5AKbYHVKVTjD8l3RQroPj2Y8WKYnT1BwI/AZa6+q98CvRJj6HTvsMGcM
	81AChoMtX+z9mMJXoOO3Ufn+X9m0Wc4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Tv2HhggE;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P4+c0fQ4LYrHNLHZUplyns5z+KGYVI4xj+rLgvLL9F4=;
	b=A4knDnY1J4sJRpY4lqhgZ84gyfw+NFedJUwqFcMelFZJWB4Q1S3jfR9irZQ9zxl5gDXuci
	yYW13UeoDKdefZkDqTY0YpgXIfC9/l1R0jXy4pZDovnIbV8Q8HsWSM0zUc/CnoKQJ14zFU
	QqBHvITc+MtXSBeG+pRUEmAV1AENJ0o=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ce9df49c5fso46353036d6.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457347; x=1781062147; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=P4+c0fQ4LYrHNLHZUplyns5z+KGYVI4xj+rLgvLL9F4=;
        b=Tv2HhggE+OLSC5iA1zw8JYwpIVzmFZiHXj1L2k64H60EGX2xrdGIbt/KEmhCW9/NLb
         f4MeyJl5DxIsF4RpYC5XxP4wW4fQ/LDyfCwI21GVlG88XlrGHcuY2x9jnbtPYHmkc7N7
         x+ZvyIMfcfD069qtLrPuHAXAx7+2x5WcndKjmQRujw97tpZFa37PMfmfOtZr2M+Kg7P1
         bnVsATCL0LZm64ss4sJLldgWEnC/b8WkyK2GVLuKK/WAO7wCxpUh9kNKY3IQ94vqyo9J
         fuiLuuE/OEAbInVMRUh8RyOqufdDyRNxHr5MkP0IAhBne9yICkwSEsx6Nrjtkxq2VU0P
         /ZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457347; x=1781062147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P4+c0fQ4LYrHNLHZUplyns5z+KGYVI4xj+rLgvLL9F4=;
        b=SEiIpmzEzBLgewGDhBWup7DI2KwI3gNVDxsfXAX0P/aF+EfJhnMtNhOBkAGVfph5az
         2TuvFWQQxKGYO49bZU1asEfBKbv1eTqovcOExCVG8G9exPmol2y6dNBGEbMHYsZXqDYT
         9X8pJaMBM3nQrt+0hZ66YVz7zG3z9/PhAGRXdZD8Tv9QgF2yWD/U7hM15nqJcvPPtU/J
         z2+QmYa4ZSAer5o9nD8AfmK22dG2nn7322N0FX4n9qNhUKbwXAWC1aWESXW/cvGJ5jJC
         PzbUCAPVJ53W2zptcRTN/aceePJSlPIXcxqPJLwVIVYeIwXBTenQvrSt4AZExYJVc/nT
         OV0w==
X-Forwarded-Encrypted: i=1; AFNElJ8iJtBCuMf2DEB1Ez1YfRi7fpUHYnEVWo+0YvSi2crrufmIyiXcPBra4G5qN3CVd1vLGg40BRHipA==@kvack.org
X-Gm-Message-State: AOJu0Yz7+Znz0rRpVUKnFraSF9DKzYUh4+A9HLhOAMb9kNDXLZjTB4Mq
	Dzy0AKlTWmtlIjMJQH0iU46InyhyIiGGJ96EdRbLvJvNRAQenGz+XrvSLp+XPlyzhBw=
X-Gm-Gg: Acq92OGCMJEPTmmA18bX4HUBUtJS0O6OBQqOcMgJ0Gou2FokQe0KZJYmc03wOHpX6/x
	ocPIxEK2/YpDkX4shTIzIiBl6unyjpam2EnTxibR/Lb8AA8w4Bitf+8Ctb4+ZNVhUEZfBPFXhQ8
	yKOc9XkOjUFqK4DzXBd2sRxTFwh72olLEGtT5UHOc9C2JImiuNPIjDW5KDRTH8vV+5O+cnRavIC
	gm5KbXiYPL7fd30MQ7lc9VEYmY071xitAdaXFPX1/mLdSDEvl4l9MLHFY3G9j1PsK687v98VYn8
	ITHyB70HzAx0JtVbr84e9CuJFpAGaeeP7bFIYlGCWZ8nmJ5qzepG47A622GV3l30yTj3kQq7KDs
	YjJQ5WeTgobpstu+/CD9WBILDPx2X1EP0qKvi7ikuwuk6fKIvddjysW+vwZCALOv86u/uI7MyxW
	H1qxneyGigBJY0bbVyvpRxrO2FtEFtr/1+gZ9K4bC1cgx3W+8athIYnGXUknW25A==
X-Received: by 2002:a05:6214:493:b0:8a1:8b0a:6678 with SMTP id 6a1803df08f44-8cece03811amr23330036d6.31.1780457346835;
        Tue, 02 Jun 2026 20:29:06 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:06 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v6 00/13] liveupdate: Remove limits on sessions and files
Date: Wed,  3 Jun 2026 03:28:51 +0000
Message-ID: <20260603032905.344462-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C48E1100004
X-Stat-Signature: feeezru8rq7qgmrdc3jhwtx7mtrnnzm5
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780457347-856661
X-HE-Meta: U2FsdGVkX1+EgteQS5ncG7v2mmJ/Reyf0hyIWDLNM3feEohFuwE/uSgxKi4AZ4G7AJSzTDP+k87UaI06hYTqeNSs7LOuFM7eH5OC+yAoaMLRk1kwrqLkTLHIHvoupV6JccqnZld3VEWyugddhhkN7hY0jeCDztIPbSZ7jWsqXhnBlKDN2Y4iycJ1j+1P28Qvf453UOSicec/MhJ44khlmXAiMH0HvSzgR5oASbJP1avZn9xGcpmXc19s0lkD1FGJf8HT7U138GwTOpfjx5JrdxxS7d/2M3kKT7y9SbM4xHNrOeWumyW59VavX5Llizyr0RPcZuHYtxTLu/Dur/+mqQBDRv/RI3NQqmZ9aU4PxW7doLWQJbKz6qB1dA0eGCMwM4wbWuLQoy1y4Sw8BSxc5YD7NUFrmHEAzP8gnFiayv7p2yr1PoMPFT4yCEUclMFCvKkM38jyE7jVLq13ZA2KHKwX/ikEFdXZ4TW5RwRkWE23b+XvGIWtsDCcMX+kDhJfv3QcTwP9dv7Bm2SeLlLOHNIMwROun8zbQK6syTN+TdRDGo/B1JtDURDNbDUhi1u7xEJeq0lZyE+hxVBzKHURXzWvR/+aAz3lzOW2Q+d9H7Eh6L0EmrdPPYhTt09BZwiR3HBUFoYDVihJH+rjefcEUQ003wtCwpKOnc1uZ4IMGPrucKgQ3dT6Ou4G4xduLqkS2ICWvjBKGtp516jUcXJLMPNV7VNF2yJFMKn29ounNiJVsQzhURuGinpt0ECNu0QrWYdqAe9e+pXW7c+pxql/cCHWkbO6YP6qY2FwnJGkDvuhCmKLFbGipBEpEPRLd3bR8nhbNursVsZWqWbXIcYl9OYIW8C3vbO3eJ3lzz+8ECU/B97y07KM4c1OVIQD3WJHw2RTOV8oNv4tnsy/8csj5zay2IMyijjDJPeoD+mKl8kCl15aTHW3hLKL1ho/Kn876v4kJfwxAP3ikbl3Vr7
 cGS2jTi/
 TWsvPvvCplG7rKzcwSZhk+pHGDbMwR80R8vFMsYfTr1jy4pGavHIuXhDrsyVigLrv8NmmGO40Q/SQjqlxZZbUUrZGZA820FpoC/DNQ9vFeLsfOCNyZxTNe8mg/Rzzaq7hRAKAzqmEkwSlfyvyBwFPR/gFQn8wIVRvyLWVdiVpOwPiXxiMWMkLtCdguqxPiBtwhPQWPadpw3arPjDAH+oQ1DXxJXDlcg08TSkBNvTN0zXLHv7SDaqmn3sx8gz630kdAIzjZmbmSGMt+hUyWjTucxjHA3qzvPpk5qOMahUvNIqMXbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series removes the fixed limits on the number of files that can
be preserved within a single session, and the total number of sessions
managed by the Live Update Orchestrator (LUO).

The core of the change is a transition from single contiguous memory
blocks for metadata serialization to a chain of linked blocks. This
allows LUO to scale dynamically.

1.  ABI Evolution:
    - Introduced linked-block headers for both file and session
      serialization.
    - Bumped session ABI version to v4.

2.  Memory Management & Security:
    - Implemented a dynamic block allocation and reuse strategy. Blocks
      are allocated only when existing ones are exhausted and are reused
      during session/file removal cycles.
    - Introduced KHO_MAX_BLOCKS (10000) as a safeguard against stupid
      excessive allocations or corrupted cyclic lists during restore.

3.  Expanded Selftests:
    - Added new kexec-based tests verifying preservation of
      2000 sessions and 500 files per session.
    - Added self-tests for many sessions and many files management.

Tree: git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git
Branch: luo-remove-max-files-sessions-limits/v6

Changes v6:
- Addressed comments from Mike and Pratyush:
- Simplified kho_block_set_destroy() to only free successfully tracked blocks
- Enabled dynamic entry count tracking in kho_block_set_it_reserve_entry()
  to automatically update the count field in block headers on every reserve.
- Removed the error kho_block_set_it_finalize().
- Renamed various kho_block_* APIs to kho_block_set_* (e.g. kho_block_set_grow,
  kho_block_set_shrink, struct kho_block_set_it, etc.).

Changes v5:
- Addressed comments from Pratyush:
  - Renamed kho_block_restore -> kho_block_set_restore, kho_block_destroy -> kho_block_set_destroy.
  - Renamed block iterator next/read functions to reserve_entry/read_entry.
  - Added public helpers kho_block_set_head_pa() and kho_block_set_is_empty().
  - Added validation to treat zero-count blocks as errors during restoration.
  - Simplified block iterator reading loop from a while to an if statement.
  - Changed standard WARN_ON macros to WARN_ON_ONCE on iterator allocation checks, and added warning details.
  - Simplified session serialization by removing a redundant NULL check on sessions_pa.

Please review.

Thanks,
Pasha

Pasha Tatashin (13):
  liveupdate: change file_set->count type to u64 for type safety
  liveupdate: avoid mixing cleanup guards with goto in
    luo_session_retrieve_fd
  liveupdate: centralize state management into struct luo_ser
  liveupdate: register luo_ser as KHO subtree
  liveupdate: Extract luo_file_deserialize_one helper
  liveupdate: Extract luo_session_deserialize_one helper
  kho: add support for linked-block serialization
  liveupdate: defer session block allocation and physical address
    setting
  liveupdate: Remove limit on the number of sessions
  liveupdate: Remove limit on the number of files per session
  selftests/liveupdate: Test session and file limit removal
  selftests/liveupdate: Add stress-sessions kexec test
  selftests/liveupdate: Add stress-files kexec test

 Documentation/core-api/kho/abi.rst            |   5 +
 Documentation/core-api/kho/index.rst          |  11 +
 MAINTAINERS                                   |   1 +
 include/linux/kho/abi/block.h                 |  56 +++
 include/linux/kho/abi/luo.h                   | 149 ++-----
 include/linux/kho_block.h                     | 106 +++++
 kernel/liveupdate/Makefile                    |   1 +
 kernel/liveupdate/kho_block.c                 | 411 ++++++++++++++++++
 kernel/liveupdate/luo_core.c                  |  99 ++---
 kernel/liveupdate/luo_file.c                  | 205 ++++-----
 kernel/liveupdate/luo_flb.c                   |  60 +--
 kernel/liveupdate/luo_internal.h              |  16 +-
 kernel/liveupdate/luo_session.c               | 219 +++++-----
 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/liveupdate.c |  75 ++++
 .../selftests/liveupdate/luo_stress_files.c   |  97 +++++
 .../liveupdate/luo_stress_sessions.c          | 102 +++++
 .../selftests/liveupdate/luo_test_utils.c     |  24 +
 .../selftests/liveupdate/luo_test_utils.h     |   2 +
 19 files changed, 1196 insertions(+), 445 deletions(-)
 create mode 100644 include/linux/kho/abi/block.h
 create mode 100644 include/linux/kho_block.h
 create mode 100644 kernel/liveupdate/kho_block.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c


base-commit: 2935777b418d2bfcbfe96705bb2c0fa6c0d94e18
-- 
2.53.0


