Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA943CD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF576B00AB; Sat, 30 May 2026 18:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FD06B00AC; Sat, 30 May 2026 18:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F066B00AD; Sat, 30 May 2026 18:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94B7B6B00AB
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:19:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AAA140402
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:44 +0000 (UTC)
X-FDA: 84825504288.18.F8EC673
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 52EC82000C
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EqP0PSc9;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=l0Pvi4u9YaDjGAHaiBChsK2kBa75JO+Ko/uXGwG0BtI=;
	b=Qc/zuZXwtB9D3WbZgdq4m8RUI9RFIxKxqiZjqzUDchWCDzCVouHjk+dmm0XW8si1Br07P5
	n53JMlk6isjXAagNQ9KH2DeYC7cxXA0q7FszplHd39jIqKVLqq7IbWyFhewlvzE942IPnK
	WxdnFs1E31hN21vUuZekezYvpv2SKuA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179582; a=rsa-sha256;
	cv=none;
	b=Ve40NWt20yBQkI5ZcDHpcjpLf/tH4gv9ypHLgIheuwhyw+Z8jAtBLrxGrT7UpdJn5Sf0Sf
	nkbAgukq0YHVbQO/weBh/gZ8+kWClG7teUpb++dAiMau+q4KWN+hynyFhcWT++SVwVHJaU
	OEJNwSpBHsuHSt5CNMghdpS+aU8m4T4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EqP0PSc9;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-914db83362aso716851785a.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179581; x=1780784381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=l0Pvi4u9YaDjGAHaiBChsK2kBa75JO+Ko/uXGwG0BtI=;
        b=EqP0PSc95af5cl86t0YcVCEuAfQ3C9G7ThDNce7H2sGkqOPoqlmKOD++YSD4hkgM3p
         O4Bey7E1bbYojT8+ZjmcUxeis9eAYIFHhupk/ATC00acPBzBJkerf4PPT0Xs2b2y5anv
         yXd34swjNtDXq4JUbT+0uWASjUmJIvmqFWkQ4muWd+g6etxo0/+stKPpt14fpdjW9Kgb
         Pn6xI2llZoKb2V5pq1Fjr969DMUl3Fcm3nwF2u+Rsdg4/Jw/wQh3TTth60b3ykHV6ghP
         RxIC3b46Tp1P8TrYx621dt1MbEJI1S35sBH5YvgoQ5+Sb1/i4ThsGp0Uij7ZJ3hXIeRp
         NqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179581; x=1780784381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l0Pvi4u9YaDjGAHaiBChsK2kBa75JO+Ko/uXGwG0BtI=;
        b=Apxhtb6+1dDuZSgWU5/h3ylChygxtvQFDpz7QUETq2ueAGJgG1KjwgeRJ+tJgJq/ms
         o8/4RaX7v7+UW8OSnCNHol4OFEPmrZOBfJDVcNZWcMJBfukbNU5J1gibKhvpUNPw9TGV
         uVepL+U6Kl8wnmKcl6QM0nEyEY1pflVhor6Dwq+5wya6sLMsCJ0a6Ky9tLbv9LU5vij1
         qxO580IbJxCeU5+r67gE8BAeiDuqbibMFU0y0UuaXbvV59kOY5CwBLonxDJWDYUzLNwh
         rCazTOO3wYh0vyfRb736BLGd/5UlqvwahDs/cvbQ59L2pHxlQVjJjG3xxi2tntaqpSnM
         YfNg==
X-Forwarded-Encrypted: i=1; AFNElJ+UiLk4JWvrFqXyChlcJ1vDaoBDp40ifQSFpI3Ifxw0OMdTh++hMLb5KwjViwicqV0n/2KBuFT2vA==@kvack.org
X-Gm-Message-State: AOJu0YxkoVQLenjRbg3yIakZMCQiUVXWXEfPAeheA31n4BhAlRdaz5U1
	fxHuqJmFtBZyiqqBGQ4MNpvQzT4YsCXcQxDxMaMLeBWgOHaSwJeQdhOl0HcR7xag0wk=
X-Gm-Gg: Acq92OH909ZwiktSboO/QogMwdganIs4XZ+otALjAxVQbsvYbp+0NC/bfiHbPT8+KyG
	QobIjRWkJyuZ2md3iJIFPuzkvj4K4uSxacayMw/im5l+x/1HZ+WQyJeu+Wjfk5EtI0eg2iEAGvT
	myVgoAIczpjOMNMFqZMY5yrgCPeJvM6XwbSh/Zm9WJLFAGely94Ehd6fZX7VwDbThAyU8XlAOoz
	Di2DwMvMNKbclGUoRONX9nWNLrKHYhV53gwhxwl1f4HWIiALXecfzxuhx2VONBE+QuCWMHp4nHv
	YjGppRmcREhQxNkMthQUr5VdAqJusYiNBbiXwwvbB847pubeUKBJEp3ykRbLjxLjt4HQwYif+G1
	kpIfxzAdcmCcLf2PhwNRTzXl/FB0rcS5xjBT/D550QvMAJb+ZIyVwZzheiP4XeMQoQK4edum+qa
	TQ5kHESo6+VjcpOCQhBRUB/ToCYAHVoLx94lFxHnTbL6ETzAuu2DvnKFGjKnQKew==
X-Received: by 2002:a05:620a:172a:b0:8cf:d80c:5ab0 with SMTP id af79cd13be357-9153e0a76dbmr564555385a.17.1780179581378;
        Sat, 30 May 2026 15:19:41 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:19:40 -0700 (PDT)
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
Subject: [PATCH v4 00/13] liveupdate: Remove limits on sessions and files
Date: Sat, 30 May 2026 22:19:25 +0000
Message-ID: <20260530221938.115978-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 52EC82000C
X-Stat-Signature: 5ixbzugj7ntkyu8fiwjsnwtn8k836pz4
X-Rspamd-Server: rspam06
X-HE-Tag: 1780179582-829512
X-HE-Meta: U2FsdGVkX198VcQKOumMDWqjPVFXZHjan8/20ACNpur/N00tYmbqMtxGdxpBikCVckn2qBSFtXgigtB4OGaglh6aXfKyaDDB8X3403Wrpy8IHT9okJssmwu9TiKBSX9qxnbPShz94ozqC3E5tcPZfC8lhLe/aIKSzFMxU8+ddrPggkfFZ3PkVCkwPV8x/EGq73q/r+KHjVGVXdpaN1cAAh3PGDD0c9a+YFOtFgOZ+Q+5yedfMG/BAb7YixIhGx8QkGjEArzCtUPOutcHwHacEVzqhmpVSd1gQNvz8Kk4TeF2Vn2SyeXQBp6T4W2pf+XPL8t81GNe1lIZsaynS1h8QNlD9Q9khOxWN7uoEvjDd9dstFxo0c/cM+OnPlxjq+2ajkRKOUx8sQsM6+N/dqpmxQK3wVRxmSsVjfUEGOrnSHkLurnshX0sEWDstI/9xS68A3Trwe8r0LVCSbh9SKRccdDKhsqvtzDmH63gDE9HTSZ72bTMMe7w3C0aWFgcFGH0KmxMOJOyhQGxmXKNCP3sOJTBaeAk5bR+gJOUpbOhmIjjl2Fgbm6PuHz5XnZk4tZj/GXnIlo6idh0w16P8FCCkZquGyMrna4qL0m5Ka7rUfQb57IPyyFQZsjxLijDzrY7+SCU7av6ud5wnq3LBBRUwJJzXzy2bFwWTkRwhmaZbVeMgVWGkG1SObzlykAXqdTEl2eoT/8JvvGZX/IuWIlVTzXrPNCUaSUC9nrESLRqcwMhNkJBjC8yewDokpg/pyp+ixsQnRIqpg9VGUN9gGcFBVbWIN8wfL/luzXHCyQwl1uTvnqxpufH8bqZ2M6B5KobFA07WYQeg2xV+mgfgnLTg/qrp8iNdhIKLfpjKOzCX6SRFFwG2ac6L+oKkTIdLvOCKUOc6jJo9N29x6iYZdUotYzGora6lOlbGzmZHChplQv47f5K5/flo0D7FOVyU2LDu6H3gKpZuHe5E1q6w40
 1sOHKnIH
 tt9FHN6E2v21eXeTkJ5lnEjKfDJrdZWRs3+S7aXi9iE4ESRUSURqIbYBZDm6+QaRaBVKZMvnM5gYOzd0IkJTAuAxFKoCJpqqG0ai/BoSdhVfaZOcFivflHz+Vt6zFkyoOXHqJVTsAR01cmVd4SnQnnw/tkCadIr69yJsJNzBSXBJLjGBpd86+nYCWtVtczxfmrPJLUYGPB7Yvq8QlSpHBlCH3ePF0pZlszOUvyTmfH8eWmcf9jLLPyHFyks2k0kDnuVAC9uJXu1/Ak/9LvOJrMGsPA2SphEJkv/YupW+YHI33Q1M=
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
Branch: luo-remove-max-files-sessions-limits/v4

Changes v4:
- Addressed comments from Sashiko:
  - Enforced file count mismatches during deserialization as a hard
    failure.
  - Reset bs->head_pa to 0 in kho_block_restore() on cyclic block
    detection.
  - Added two small fixes to pre-existing problems at the beginning of
    the series:
    - "liveupdate: change file_set->count type to u64 for type safety"
    - "liveupdate: avoid mixing cleanup guards with goto in
      luo_session_retrieve_fd"

Changes v3:
- Moved the linked-block serialization infrastructure from
  LUO-specific (luo_block.c) to generic KHO helper infrastructure
  (kho_block.c, include/linux/kho_block.h,
  include/linux/kho/abi/block.h).
- Registered luo_ser directly as a raw KHO subtree instead of
  wrapping it inside FDT.
- Collected Acked-by tags from Mike Rapoport.

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
  liveupdate: defer session block allocation and PA setting
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
 include/linux/kho_block.h                     |  79 ++++
 kernel/liveupdate/Makefile                    |   1 +
 kernel/liveupdate/kho_block.c                 | 384 ++++++++++++++++++
 kernel/liveupdate/luo_core.c                  |  99 ++---
 kernel/liveupdate/luo_file.c                  | 211 +++++-----
 kernel/liveupdate/luo_flb.c                   |  65 +--
 kernel/liveupdate/luo_internal.h              |  16 +-
 kernel/liveupdate/luo_session.c               | 242 +++++------
 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/liveupdate.c |  75 ++++
 .../selftests/liveupdate/luo_stress_files.c   |  97 +++++
 .../liveupdate/luo_stress_sessions.c          | 102 +++++
 .../selftests/liveupdate/luo_test_utils.c     |  24 ++
 .../selftests/liveupdate/luo_test_utils.h     |   2 +
 19 files changed, 1161 insertions(+), 460 deletions(-)
 create mode 100644 include/linux/kho/abi/block.h
 create mode 100644 include/linux/kho_block.h
 create mode 100644 kernel/liveupdate/kho_block.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c


base-commit: 5428435567cbe06c19914592fc22ca23c9ca1de5
-- 
2.53.0


