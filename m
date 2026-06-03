Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04DC7CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7A16B0098; Wed,  3 Jun 2026 11:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560F96B00A0; Wed,  3 Jun 2026 11:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4504F6B00A1; Wed,  3 Jun 2026 11:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33CBA6B0098
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:44:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9F0CA03FC
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:06 +0000 (UTC)
X-FDA: 84839022492.14.8DFE4B1
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 141D91A0010
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=I6Z515zU;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MIUnOidiefXcspEuuyeBWqUN2o/RTn4ccvxerf6qmvg=;
	b=BC79J5clRnFNAYarUrpBQBufioTXMwBiss+d9CVl5dfPQ23877R9jPTHTN0smKSgoyXRcL
	AUiBWF1/GSyXY5DMah0oN1Vqa/Mvq3P/gW9lYyNtcjUvZLORyWDC6DpskzNzJPpv5x0b7x
	7HLrN+zwu4ntrHL+RUghncG3omjpqFQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=I6Z515zU;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501445;
	b=AtBOBbG7rNmabENwYNweYb5e6py6+kHdfP2nTXM81rU5H6dfGJUxvdLG/cpszgYc7+j1ml
	cvqzGt3cLcaEbhbQpHOBhs9fCdioG+FWGnJeglMMvU9HqCXkX1/0zVtx66ye8JTdKkPC4f
	9w530dvdWAtXalg0uqmDv3dEiaSJ2eQ=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5176bbb9384so21339661cf.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501444; x=1781106244; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=MIUnOidiefXcspEuuyeBWqUN2o/RTn4ccvxerf6qmvg=;
        b=I6Z515zURJz5sPd8frhMOkhuEiIo4X6DrAvuoJ9uYLurDB+ZpESRf0Ye+ZU9IMv43N
         8DtC6ojWqgmC8SB1Zx9pxQpbh917OxcyorLnWWQCuO+PckRGFSbyuuPddUX7H/Uj8PtY
         EreA6tbaY4I6CjMrY+Z62qXj9WiNGZFO0mHo79wVvF5SEhxWc0g3vyzumzAawwGTgE1C
         h+Pbg1RrmDAOVJykE0FabKr9yvEfwAjgNO+5k6UJVKpmZlzevINWmU9RP74EIXAIKofJ
         7cJ1/v0YlKucgR3YEjuH+WZ5vUr81oBknk4wSp9zYMGQgzoBdRNBp5/nq2n1z2ysT5Hi
         NlzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501444; x=1781106244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MIUnOidiefXcspEuuyeBWqUN2o/RTn4ccvxerf6qmvg=;
        b=aAk+uCVj+aehBaoRnlU46U+N6j1UH8CFBjbTCRENTrSKKEexsMDVrXcljK17r6YuB5
         nDKEwpb1ZvUI7Ex/Ser/t45dmbnHeXP6LhBo0ENLy7mmUUp4uz43V68POtf/HGQuvuUz
         j6buvnCj9XlqiNrVJA8XPwt5v80GS1YmY0oexnDzg0zRqBohYxZzS40tWOZ4m2V30O4A
         OyZ56kRFIWWqlsLov8hAp4xdhYP8PQQ9BknnZUVFWs74S77HxWuXMugxIxHYYEK+Pq46
         zqnDULBpzpQVcDR+3mQeFL524d3JEPE9aE3na5zapdCPKgEN8ImenO6Fkqjr19A0+O1k
         76ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ/JX/MypTVZCPbs9mreVf6wLirp+1ja73HUJuzilEDeDR6ecxZhvDSaE9WjGIyxR0r8aMBQupt7/g==@kvack.org
X-Gm-Message-State: AOJu0YxCALMF1PRZjdO3UI7o9P5SZorTNah0gZ3XTqnjmrN8XoShYi6k
	tg4AKkdrUyRzuVlJ87RV8HUYbKDh4BxBZPYK6m5HAxvAFA/JDE4ZeJRrse8cCR/1KUM=
X-Gm-Gg: Acq92OGPoHxJhxM8otGhwsX/8DMFSS8qIuTVxPQtY4ceL2mgqh9AnM0ncbT3cr5nCW0
	w6ZtjXil0JHjvbBps4lpTTDsIUBtnaRtdOf/PYFciG7Uso+aqUAzkAwG4HtE/GfUwG1wyv4Is0K
	qS1THLnXHUFcJn1de4E1BYN/xYOQkxk4AI20sOAkAMz2hxuBjLusV0L7TTw94mRsqsXw2/fdHSe
	ruRy5dn7rMlA/GIQ/YkqmPX2SRE0RT4QC7YGGDQKX1dA/XVRdwlz4zU0oCPUhJkPtUeIG6QlTE1
	smJgi91dWzPTn630zPZ9pfEIKR/0yDQK4BHWqi0lKSrqKN7pt8G1UlOylrPjIwZ0/P2X3DK9cm2
	lAsO6sWBB0QZ9OekUDnMw15AZ6OQMRCJrYlXSyf+rcB1AjIP+PoAVWh3TRkPybUmXf7mVIeWm5L
	WjrYnF6iQzJqm1E7Lf7okIhFirJB2S6moUhnH29LtuLTy+7lntpqoONLjOloE/kg==
X-Received: by 2002:a05:622a:313:b0:516:508b:bf4d with SMTP id d75a77b69052e-51778789b11mr58906021cf.56.1780501444077;
        Wed, 03 Jun 2026 08:44:04 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775c07e91sm26996561cf.4.2026.06.03.08.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:44:03 -0700 (PDT)
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
Subject: [PATCH v7 00/13] liveupdate: Remove limits on sessions and files
Date: Wed,  3 Jun 2026 15:43:49 +0000
Message-ID: <20260603154402.468928-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5k6ogckurjinj3rr8951ry8eoebm9eb5
X-Rspamd-Queue-Id: 141D91A0010
X-HE-Tag: 1780501444-663905
X-HE-Meta: U2FsdGVkX184V5bAkweF2oKZWR9ifgcbOKGXkciUTHHL4ptkIuxz5QKBtY8j/qWmC5qNzu5rGnLSuRYbWfZY4mMKpAWnMpo/hnFAdlAZVvPj52ZhrWq17sa8rrWH9sebhowWgJDrIwFOBOyv9W0uptFLlWB7JUNDo/hezk3N/i7GrwVvhw/CRHFf85OzfHQbvH///KbYSKL7EJYzUSD1cEb0plA28zApInU3ggsvEJmWPS5ARehEgceYPMrObTigCCOSUucKdsnGbwVgWNFY5JHd4u9pLJeiDzRaFgKABWEIgybN/DMJxacs9qtaBboWFEs9fVxgM79ynwb3+OwQtbG7IFn4vV7va7MQJeX64FVzzHT1TQyON8smnLrJL5Q9oGH4tslb33YkBebgQ258tEQ5jwfj8xCjJaXZF+fK3sguB5PXXkSSRALIFWV58XdSa+0aJYWrZmpVTEZjoT1fNX/WCKEenNfwT1dxuBl50ndVKoNVBz8Y34DSdW4V8gYKt4a2LbNR8Pxhxy3xdJZRR89c/tnSEBkfLbL5l8VWpo8lrQ5Gb3idGDQObN5nmAkGyEPQoSgkguMKgcSPhPldi5mp8QTpL8WfyXWV5BlCfBhNBqcugfVsraCVV/YfiI+/cf62yS7cnwQJo53z6+mCKmPuWlA26ftwOYlCzy95BTWbhmHU+31zyDsQ79IfWjDoyiE5f7YHE4izhTJeYw9N5lXfK5wAzuLBUc+F1l5HGwTuWuwYbkEFyKkmetWAb+/OvSmrFcDUBrluZQ27PL5jkYE/ykiyhjGgH12YbFyoAnvErlQGH8AG6/xeBFmXhSpSwrV2at5Rfrjr91o0D01d+PiQaeNM0VHLaACtLS7Yy7wZhclWngJyuTBctGK1zt1Iep2G/1Ch46xnn/AWeogZhOkAEYVZfe/fLs5O0vEt6Grm0EirMORMXbKUjak9rsCYl5wZAMeJmPh9F8z5M/e
 34nx+XeA
 1GBxOVA3QNCy7ew6AgwQpgT7Ul9nbmbYS5Kc9q7WmweAiVBxNAx07SZQLTCZCzV+ac1K7rfzw+nLM5bEOYDZ50r58H04WkTkbLGHye5A41y3l7cFxBG3ehejAg+f/bnYvMk1W3OBu+fCZhHRZdLvWkkXX11gQY8KLSuJO7wUa6ucTrS5leBhxf91yxR0uF6vnkAN4Ixce2/I221Rk5ShYKYihgNvsgVulAxRmayVUlvuLg0vNzM/VrFr5G9m+3IlD3zm0bQsqqrO7txi2xBz541AtaHV7eqVs84CrE2YlqKO2QeM=
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

Changes v7:
- Addressed comments from Mike.
- For changes in kho_block.c, and updated to use gloval KHO compatability.
- Collected review-by's and acks.

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
 include/linux/kho/abi/block.h                 |  54 +++
 include/linux/kho/abi/kexec_handover.h        |   2 +-
 include/linux/kho/abi/luo.h                   | 148 ++-----
 include/linux/kho_block.h                     | 106 +++++
 kernel/liveupdate/Makefile                    |   1 +
 kernel/liveupdate/kho_block.c                 | 416 ++++++++++++++++++
 kernel/liveupdate/luo_core.c                  |  99 ++---
 kernel/liveupdate/luo_file.c                  | 205 ++++-----
 kernel/liveupdate/luo_flb.c                   |  60 +--
 kernel/liveupdate/luo_internal.h              |  16 +-
 kernel/liveupdate/luo_session.c               | 219 +++++----
 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/liveupdate.c |  75 ++++
 .../selftests/liveupdate/luo_stress_files.c   |  97 ++++
 .../liveupdate/luo_stress_sessions.c          | 102 +++++
 .../selftests/liveupdate/luo_test_utils.c     |  24 +
 .../selftests/liveupdate/luo_test_utils.h     |   2 +
 20 files changed, 1199 insertions(+), 446 deletions(-)
 create mode 100644 include/linux/kho/abi/block.h
 create mode 100644 include/linux/kho_block.h
 create mode 100644 kernel/liveupdate/kho_block.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c


base-commit: 2935777b418d2bfcbfe96705bb2c0fa6c0d94e18
-- 
2.53.0


