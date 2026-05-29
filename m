Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADBB8CD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8ABB6B0005; Thu, 28 May 2026 23:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B886B0088; Thu, 28 May 2026 23:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A346B008A; Thu, 28 May 2026 23:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1B606B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEA6C1C0B2A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:10 +0000 (UTC)
X-FDA: 84819006300.14.80C56F4
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2E6F84000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DEfVB3g5;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VWz/Ba0zwzmUZSFYwq/eHsbiY7hxxlyTIzOmzVE8aUU=;
	b=MPpmuhosjh45LOBELdv1Yq5blYaQeSq2pYXAZqXnnJEtqDJDjE7FcqJBqPXOLJqhs6FAI0
	L/KI/NGUPAMi68aGKMO6XJtmdC4NjG9F+K2joMPzJ0MMqeehYRs+bOfnawzK+V/ulMdxt6
	l53rlHIkiRlgUucrASIioBFDWhyMIP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024869; a=rsa-sha256;
	cv=none;
	b=qGBCVFA0x3yVmUZawuE6nO4mjWGW5AygMgteEcXOyr9QftdJM09ADHpt69I21ACyJFKiKX
	Y7fPHB2xrl3joMV+KGNbgTKy8z5SFcaGkz7sSGN9qWuwOcDQdP898vNlY65UhmkTHit+r7
	tkJFUG1SQoqWJmmx1sCIML59NQDA3Wc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DEfVB3g5;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8b9f2295a9dso147153666d6.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024868; x=1780629668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VWz/Ba0zwzmUZSFYwq/eHsbiY7hxxlyTIzOmzVE8aUU=;
        b=DEfVB3g5Mj1v5+ceeuVG0svVR5KTJ0AW3qJzhWgpCX/8u33XgZ5H1p9fkb8BbDxV5J
         pyCxrj62ef10BGU6wQpHME9/6SO+pgDWQc/UHdjhX2gQQYf6TggNkDeX+2XzU+rXSE67
         AyWFIt2YckdUprXdKHHr8LOKI2+LyArF9B8H9bwMfizE3qG0GiWjlCNAe7hDuoQkbE97
         lcRHVjl5c0Wv/UpuWv7XhCEvOXDK7O3n9clgzsF95gdjj4CaxodWPpi86cAWDTW9bFM6
         JyKQCL06wyuHexm6ubdcOCo7gpnd2pdcXZhFn37wUgY5nO3/cob+nQLjGP3DslAZ8mv8
         2mkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024868; x=1780629668;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWz/Ba0zwzmUZSFYwq/eHsbiY7hxxlyTIzOmzVE8aUU=;
        b=g7Z1IWwVqyjFcLuD3Yv9ANtwe4elWHmEk5x5RHokyi50NKJdpfwohVxslbUtcDPJQk
         fffqeIKMpScIe0KUNtlYNJ3pNe9oTQdoPnwUICuGCR0ScwE2THlsGvSso/11DRkWqfhu
         haHRv8MI0gkCAwUOblQzniFmmNtCP9MTEYQ7C41N5cSsL2j/8o2eOuPOoY7q21i1wpUg
         G4Mgqk6dyYl20JR8urw3etAaMmYUOOjPUerkcuhLXxTKWdEFwhO0lyVNMZOYB/wKmOup
         TZbS639f6sJ4dGDSylIZrjekXjla0jW45h9sKasFJbDg691absRAn9nkDReosICQxv3n
         zdcg==
X-Forwarded-Encrypted: i=1; AFNElJ8TwEsZSlcUPMuGQwS5pW1FXMqQqwffnRuHKexuSPLBIOPHCa+K7u6ptgm/DLLvuwMk8fOmRxRDSA==@kvack.org
X-Gm-Message-State: AOJu0YzcIIhB9gVyyPYYyzA9JYlEu/TfkJQ/YT9R1idU26dhvWsy20qZ
	lnzKc8YSfQH3HJ4c/dyZwPIjCCS4Wq8Lxo1N7RUGP3ujtAi7tY0LVhAsTGaRw5qvM8FnhFyhk7Y
	DBhSo
X-Gm-Gg: Acq92OHowjgBDYrVAq3Dgq0YxF4zDAIUE7yfKc2y8cY4jsWlKnqmgRxNqgwxrXCc0Bp
	IujRMljQLENTh2NQjR35hq6HtRfVhTnzu8nqi0jX8MM9oDVKEHCkJf9UtF1KrIA9S1/GZxOpZpN
	SIdLNXqukJptRmUR8RMxLXzeTjw4TctdIDWuVM3bwuulqWDboCqDo+JvY8bYaJxqGuyYlUjnkX3
	pIYRQPEYY1ZC/l2+q3wPEAjgYUAVTvOlh9eUgcRFT5923StoxdiSi1wfxdSrG/2yj3luaADDoWq
	P8MekDwo4LqxZf985x/5D4aHn4UpqUekDEyIhkZ2w/IaS9oprLZTQJgzII/lJbVewKr7KXwHNF0
	JRJIkejq5snwYehN6xdO/LCozAUep/GLMBvzj9v8DpPCqj/ap/0WNKI18zu8JB7mFaD0jR5NmrL
	MF12eq5yvc57pmV4mBJUCQR4jYMqAQF1kwidSUSw1Pje2du2t/kNs68m6UVZi47Q==
X-Received: by 2002:a05:6214:2f13:b0:8a0:d08c:a720 with SMTP id 6a1803df08f44-8cce8009ba3mr14944206d6.17.1780024868221;
        Thu, 28 May 2026 20:21:08 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:07 -0700 (PDT)
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
Subject: [PATCH v3 00/11] liveupdate: Remove limits on the number of files and sessions
Date: Fri, 29 May 2026 03:20:55 +0000
Message-ID: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 4m5bp6ksx9t144o94a5r6ijobe56d16u
X-Rspamd-Queue-Id: 2E6F84000B
X-Rspam-User: 
X-HE-Tag: 1780024868-553117
X-HE-Meta: U2FsdGVkX1+gqDKIEdbbH5Vce3VdsF70r41U+po2OTTdFat/6iqqChN7cRcVj9lnWCvJwLcA3oOx67xQEzSPvEvitzC8iCXjluPKoOw8HK0BSqRl1YSF3XyxjL+rTxmAjQns1CQHLIjrX0YhlfuMBesABhsfWs1kX7n4BVu0/REWl8daO6PiKwTRtBSfncIdAo0ARSioTmsl+WBLdh0tPBBBubK83FWy3FsHdfCIdvWz0e4jzl74N7G20Hndtj4wOPo2X7iEePmVtKqvlp/AD2+ATqZyKd54+3QQLka4jHMk8V3YHpQ2KG9vsT0bP2AyP7MPdr4WEwYN26v7LeVQNp9ZPfbjhzKIUcwioaKSKwB9IX6I1YR+HONfygghlt9pruR6Uc2rNEEOcxCXkvKwDiWTDrRM0YJNY5tp7jGcLafVOQF9y6MClb4NNGKRNgPCuVzpD4p+YLmlocwkMSOZlxAG6bhZQXYt/1ujl0HVGqi+JPasXDX3J3GzpHVLMj17ohbjJNdOyUPSd7QlUta7PSmtntmWSN7PEQRSDvHS4fNLuaWs3rYVH8xE+JyCQ2k/mBfG1oyUEqFefq0sosXYfA4d6EMmv7dqFiVqWRZnteFjA73N5nbZakkjUdNVX0RwauJ6jbmZ+38+xcuNip8rTZi2Txyus7MvXqInOgf1Ky1jlkVwXvNk44viVhe48d00xagTbnJkrkvkxMm9KA0V0j+X6wHlCAldmuMqKw+wPcnK3OGqma+LEGCgr29GtSJniVAFC91KZxBDYskuV/2K+29+GXxJp0ULiHxaufjmDPdfkpaqd0QaFK3TEAjbk9vgB2sGH2x3555Kk44wtT2y8wGT54QV6kv/NtxLIiOkbHSmgYV/v6AK/2e2Yc+ekj59pxroWQcXR8EUMGcx50gus/9nP3dGpWvHQcaoWFqq+i1XozZ/AJKIptk0Q5l/QYeuTe0Z1RM5e9XofJtn2OQ
 zgsy5T3/
 bo7vTsttRwHnQrG+9AP/DzjyMditavxea/Xu560+6qGNr/9yYDyD6dqS7mcr9LBKUD2nE9Wc8V1djCdDjpOqecDiJfFLdBEVZDMla0Bc2olKlNkrPl9tMCzrEyPPVfVT2ciTvh/iIJpJkLdZxWcNf2BwwN4h9S2mZl0eG+tOHjtvZbPZZarLyQ0xg7il8mw2ZRzcI3hW1qgM/MyaQHx0bRL9dGbGdpYnL08ETGCByE+87BKw6nzp4m9lpGWcHquxgsQSBhHCPQf94oV7hF6vMYlMf5nERSWzdwecCyFYQ4uMt2ok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Branch: luo-remove-max-files-sessions-limits/v3

Changes v3:
    - Moved the linked-block serialization infrastructure from LUO-specific
      (luo_block.c) to generic KHO helper infrastructure (kho_block.c,
      include/linux/kho_block.h, include/linux/kho/abi/block.h).
    - Registered luo_ser directly as a raw KHO subtree instead of wrapping
      it inside FDT.
    - Collected Acked-by tags from Mike Rapoport.

Pasha Tatashin (11):
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
 kernel/liveupdate/kho_block.c                 | 382 ++++++++++++++++++
 kernel/liveupdate/luo_core.c                  |  95 ++---
 kernel/liveupdate/luo_file.c                  | 209 +++++-----
 kernel/liveupdate/luo_flb.c                   |  65 +--
 kernel/liveupdate/luo_internal.h              |  14 +-
 kernel/liveupdate/luo_session.c               | 214 +++++-----
 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/liveupdate.c |  75 ++++
 .../selftests/liveupdate/luo_stress_files.c   | 101 +++++
 .../liveupdate/luo_stress_sessions.c          | 102 +++++
 .../selftests/liveupdate/luo_test_utils.c     |  24 ++
 .../selftests/liveupdate/luo_test_utils.h     |   2 +
 19 files changed, 1142 insertions(+), 445 deletions(-)
 create mode 100644 include/linux/kho/abi/block.h
 create mode 100644 include/linux/kho_block.h
 create mode 100644 kernel/liveupdate/kho_block.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c


base-commit: 5428435567cbe06c19914592fc22ca23c9ca1de5
-- 
2.53.0


