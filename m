Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F69CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5696B04A2; Mon,  1 Jun 2026 23:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85F86B04A3; Mon,  1 Jun 2026 23:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D769D6B04A6; Mon,  1 Jun 2026 23:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA8996B04A2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 163314060F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:22 +0000 (UTC)
X-FDA: 84833511924.13.A62E4A4
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 50A2340008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aUMRFVfv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M1YZ6pkpMukmY0PpCar7lQ0cU7Gg/pAjVgGHiG98i3c=;
	b=5nsh8aDgMDPjczTuiLJu2mgtcp1YAhq0K7utM4IOEqvhI/fbO4fvFiuH+JZ0fh6w/+W9ZY
	9xUkcpPVZCpGZN7yQqqxaoSm+BjzkavhuJKHvCADtSbayfR5y1uxyYYiHB1VMXVGTmM7pq
	rdzeiRNh7wsopckwYC/imkNrggIT65k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aUMRFVfv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370240;
	b=hBNfYcYGWqrdKzCTgc8tGec9fMk7xPImNVWmm5atOhnoL/7fDF9XkZONTd9z8kpptTDaku
	LZMXtGshCPBffovv06m7RSIch5Z2/4BHgA5XgdKZKwg2FYpOyOLewabNeIDUyJmYIAJWXc
	7kvWjwRudGdNtwtS/3itu9mX4UjrG+M=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51758478240so8151511cf.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370239; x=1780975039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=M1YZ6pkpMukmY0PpCar7lQ0cU7Gg/pAjVgGHiG98i3c=;
        b=aUMRFVfv8wAzyOcI/5OtSzOJAiWusx8pNWITuuBcTbam8YGnD45ImA+7tasCT/xcRj
         oQ/ap2aWx6Lxjh9pl/emlaCEQu9Cki0xipaHRqt1EhdI6NlBoKWMTTuyveOjc4ChFUr6
         H1EY91jy3IvAVgd7n/nsHlLclUVmEsD6UaC6H6dMVbBPViyw9aBLAS2nOD/ruUNhYj9d
         3vuXWb0TR3sD3u+dglF//3D4GmgguOQe64sZsfwp4o9JTDCpyz7c1tjsRgAGZ+lFQBN9
         yrjQQxFYypefnYdMH00DZBSwBaMP+xnJiHdFQt93LBBhWAkeqyg31FrpRKo7UaGlJDKu
         Ac4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370239; x=1780975039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1YZ6pkpMukmY0PpCar7lQ0cU7Gg/pAjVgGHiG98i3c=;
        b=qZHNWVrY26xx6o+4TUaQaCsdGSI1MWodvyi2dslQ3L86gnvcE8eVIwQdX7wqbnyIYu
         6GTwOLpk0BUb9N9LrPZ4zCjmcza4t2EgE9dy+I839F4rNXdSG8OpXtV9tVRuuaFwnXWu
         tA7p6/i1aEGsmIozezEvGWxAysEvlSPunrsH14LxtKL2XYBWrza6yhFShrxL8OZ0YafH
         ePhVxns49aJjpXzLoQSjMQEVcCU1ffGLLD9bsHn+rX0PvYUc33DilQDo8ek9mnzMiwns
         S6uYV5IVud23aV5LvD40SyM8fTJ9zgDhrndzZeSC6BPyw9g9tGFvP0G6Wkh6MWt36QKv
         8ALA==
X-Forwarded-Encrypted: i=1; AFNElJ/SkEbgjNsXyWZteqGIXctMyv/fe4Gs3mp9zZ+avV2U+cR3MaLJT/hrFcPZmsduyuri4P85zSqd9Q==@kvack.org
X-Gm-Message-State: AOJu0YwgvoL80HIG8XcckrSfpdPhBspsfRXmqME+w3V/J3qAJDpegnQx
	RY2NZ8GOq0euLAz+6ICGuAO/FIU5S2/bz1JR8lFOAqhZmXTyHifjA1nSyrc+8IBmfVw=
X-Gm-Gg: Acq92OFiV+fvP3bxrBnNVRc46LCZMkaLtoAnhrKTvGYzh4SDDHC3c8fkt9CBsJf7+zV
	zTtapEEYEFoPr4BhydYLR1+l1zfhAgcZzjWXMJTT0YRXiu1FXAcPr6GtPNVmKujJOdsxr635V1d
	vlDv8fR95VhSat9QnhTsu9WcOxq6vBtK3MrPO2mqnMASMHOH3l32uBbaVThNIoHe2XhByzEMDNB
	p4SmTpUe8FShsrjzJo0Vitv0ZRse85XgDF7ybH4flwLkkVNl0TuExRiqEiy1lud3ivPpZDxsPFD
	kZMCHL/2BHc09RXzKHjsd+fcrUU64mY8J1D55dDyDWeatSXSxhRus5aLHhTQ00m8MaDQWyr1Oa7
	547+DBlM7BJn8SEkaiImsgG/bxFtFGVwoplahc4x5qrl8ICNjkOJoGtrltaJGooQ0nG3inzMArW
	8kX7gsGJlM3FQ0MX2UP8scsjxkyobPp3nj100Pj2N5rrBL84V58CR/AT07L+R5rawzt9R9Ynh0
X-Received: by 2002:a05:622a:a9c9:20b0:50f:f0be:dc7b with SMTP id d75a77b69052e-5173a7fe8aemr158846631cf.39.1780370239332;
        Mon, 01 Jun 2026 20:17:19 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:18 -0700 (PDT)
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
Subject: [PATCH v5 00/13] liveupdate: Remove limits on sessions and files
Date: Tue,  2 Jun 2026 03:17:04 +0000
Message-ID: <20260602031717.197696-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 50A2340008
X-Stat-Signature: zuhfxqfguhegfyeg5pczkc89rqro77dj
X-HE-Tag: 1780370240-111784
X-HE-Meta: U2FsdGVkX1/O8ZhcN9X4QwerOnSRVXmhHk1FnF5YWKWMnVsop53BpY+aos6ZWjTRaQIWOzLZnmGlXPrpg4zbEgJGA7rJaKPGcFFPaV101ZRqvRVjhEEPlmv52/5Re/rH5Rf9/73Iyb92ORBW32OmSEB7mFybTl7cUYFrDgMVXV89TOVOhrWKKqKkLuhy4NFm2jUPuczRPOO5XoHr3vesSxe0wSFJhIWDbYRhs9b1QQ3wlGosjsiGJUsTBkQzhlkMaOrVtXdKmVNzMW/EAtFJQ5W3TK5w37g7PRKcPXGOOYpdXsbiHknXoCyeLFpJA8ZBHwAA5jtNTdiMG0b7O4zl2LU6jAf0soAgCbw09LiFpBj3EEEE0sJJlUqOhqQkEyGJId8Uegt3W53mVHmCQ2TMs7eWLTXjE3GgF/R77LU12zHGexYsEIShsSapy1+EQwz56g2s5PBQtB6Amsq0f6RPQCu+BYb6jDW8x+7xAWkzFXYqRNOHMWbf7uDYs0PGjFsaijRphBb1gaLdAW5j+iFd9peF6+zYmmGcHmH5uHDuldBtq9WVHD5p+45mN7TbcgNBwSucMU1UkM0srqa+1+FkWBGu4zvFvjPkYG3Z/E8/ZQ8nhE/x8A39ZxxcmaYaOvQgc28DN+IHpqrv172EPad3FBl9EJYVro5DS20XvQn3uPnutgFu3Hezn5oW1BQXY2epIga81+NFMbjQ6RgzOw3dokaNO+l6OblOU+Hh85v7VEb4ay6Tth+XHSxpabOalx0GkL+KmmPwA200axMorlK7GoDmfAc1ICk9tqeOJ2uihp0ILmQlMOwnaPTILuRrGPEvZff/6kpTTrIekuDFD+8pXYfdBRgytvpoj6hhdbZd5wuDUCqan3faZFOEyDOaT8gvDPFjdjD3d3Xmhcoph9Pg2k474sCuDT53s6sVSXWqdZaNjNtxUGoMO7CX0CrP4fZCTJoaCcWBVnHRPZjM17x
 TBGcSuBC
 3MZZOjcnAHeI0gAhZ8b+V+BAIbAlDYZb7WIchswMO8OILxR2Brm51ZTU4gx4cLBWnwmqj/XMlsJN/nr1r1Fpra/kghtYxzRZQgxiRsnO7m4uoXzSCJhwP++FpZbAUF7kOFRYS1EJo3Jt9UTK66Pqzh2pTw5e++v86mPw337lGNINJgtdkdANYDD1zImVnbLoS7gq6z66NGGVaFhuzIFNs576PhcAWnNMKM141IcOFH2pcnbFaGmQYukI6iPn7KADexFcMtuocTsANKrwj4FiLvJiEaTIaQyv6mu/isgziCfTmxvc=
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
Branch: luo-remove-max-files-sessions-limits/v5

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
 include/linux/kho_block.h                     | 101 +++++
 kernel/liveupdate/Makefile                    |   1 +
 kernel/liveupdate/kho_block.c                 | 390 ++++++++++++++++++
 kernel/liveupdate/luo_core.c                  |  99 ++---
 kernel/liveupdate/luo_file.c                  | 206 ++++-----
 kernel/liveupdate/luo_flb.c                   |  65 +--
 kernel/liveupdate/luo_internal.h              |  16 +-
 kernel/liveupdate/luo_session.c               | 241 +++++------
 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/liveupdate.c |  75 ++++
 .../selftests/liveupdate/luo_stress_files.c   |  97 +++++
 .../liveupdate/luo_stress_sessions.c          | 102 +++++
 .../selftests/liveupdate/luo_test_utils.c     |  24 ++
 .../selftests/liveupdate/luo_test_utils.h     |   2 +
 19 files changed, 1184 insertions(+), 459 deletions(-)
 create mode 100644 include/linux/kho/abi/block.h
 create mode 100644 include/linux/kho_block.h
 create mode 100644 kernel/liveupdate/kho_block.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c


base-commit: 2935777b418d2bfcbfe96705bb2c0fa6c0d94e18
-- 
2.53.0


