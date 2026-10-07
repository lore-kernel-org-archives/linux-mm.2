Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C55CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 22:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47A4E6B008C; Wed,  7 Oct 2026 18:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A1B6B0092; Wed,  7 Oct 2026 18:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340466B0093; Wed,  7 Oct 2026 18:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 090CB6B008C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:40:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79BB2120361
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:09 +0000 (UTC)
X-FDA: 85297299738.21.2291C16
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id CA65AC0006
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mpr9W+2y;
	spf=pass (imf10.hostedemail.com: domain of 3RcrGag0KCFIuv12C1y4vu9uD08805y.w86527EH-664Fuw4.8B0@flex--abhishekbapat.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=3RcrGag0KCFIuv12C1y4vu9uD08805y.w86527EH-664Fuw4.8B0@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791412807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vIFYPTbMlvK7LEVP07VoMQmv5kgwn2c+6+4FzK8N/QU=;
	b=OFszfAzVMkr/oMyk4i1UxywdXRfu24mA1QVGcPU8st2k9mn5VJoq2wZskY/ezC2z08zTcv
	R38qffRgZviAxo8bzyqLm98pQrdnSEeQ4V9JsiYXwwvFihaduhyiWXJj7cCc5Pezx6UQmg
	9Tu6CBSbzviVl1juzsaE5flFDZ/NT3w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mpr9W+2y;
	spf=pass (imf10.hostedemail.com: domain of 3RcrGag0KCFIuv12C1y4vu9uD08805y.w86527EH-664Fuw4.8B0@flex--abhishekbapat.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=3RcrGag0KCFIuv12C1y4vu9uD08805y.w86527EH-664Fuw4.8B0@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791412807;
	b=OtzujDa4sQfYD/gpIWo7tlCc+xwXhdL24pkawth1PZh423vC6XjClxHCG3yUh4Entl55E0
	zvYiAKfJx2lItckPRv52pUpyh4nTS5exKC65F1qoUUvLU1pmJ6rW50bDr8nQGoTqYKJ9ec
	wTRi/a6xAArOOd55TF/YvNocRcv6vTA=
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-14373747468so5177699c88.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 15:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791412806; x=1792017606; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vIFYPTbMlvK7LEVP07VoMQmv5kgwn2c+6+4FzK8N/QU=;
        b=Mpr9W+2y7eU+pOuJ1X4JEd+txJCIZ5gCXWWzybLwuuXS9woq6+xnDiQvmkSFgOLq0T
         Sy8/uGOzIJocsnbaWybzgQGbTcDccwdZ+Y29uufbIoW84XGJTFrsQvcOOZOH2WswxQuB
         Tv9SZo29uHlOz3AelJpaiDhZi3DAW64na0HVPZr6T73Zl90Eco2uKSyvs5DmBH3pDWiC
         BrKGHNaS7S9UI42MjRA/RS8A010TyfnYDdZT0dDxxFLVTYBsKc/S8gVKoX3wSwvqQhwA
         1D59y9dUZLGbu5r5lwMYiHSBeZ3E7e+n6S3sJSQUQn3828SjUYjplr6htUzyZ/dG478G
         fxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791412806; x=1792017606;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vIFYPTbMlvK7LEVP07VoMQmv5kgwn2c+6+4FzK8N/QU=;
        b=w3uYE35NLj0iqMrWoGbDjKhRzpJQ/yjs6S0XttJAyKuCZS4IdYfKcV58zxJfPkGQBM
         71dtKu9+TbDFvWxQk6xA5LI1cFNsXftrjJfTRBn/a4vq7eYUOpqrpBFjBSVqEdqInCrI
         VmPF4Q422yi/NaleGi0RmTY6pZXnCcgCquMxxokaDP5b2uUEDJ3TsEFV2SpJT5ylBvc3
         FS2jKh7t8RKMmuaPnNCXxw4riqWY39+jgyndyIFvIJfWSi5IkTJDO8h3V0GeDi9OUFEE
         lwiAEkeppAcgmutteDN5b+M9KY/gLsy6pKji3k3e56MnQO5BwXUPPeVNsFbialmwYzEP
         werg==
X-Forwarded-Encrypted: i=1; AKwUvBwuUAyUyIppsLeVyaB22liV+T1GoTK5ERquyhZviz8MladdTd1dMuoPOn63Bz9rvqtANqTe5W/Ncw==@kvack.org
X-Gm-Message-State: AFuF++mvrNE/yBiTcGhZ4jhFDAC6MYyPSbrEbtNGLyJqOrURS5wvVUpX
	uyRuLuDpT6SjLadM3ZChlgWikkwGk1X9zEjp8W9F6IkOvPr8xAYmXaFX/M/I4/O6lhyLJS0+vPb
	g+/Nxf8d8CrUt1vsZTqfUiDaSTzGFRmG5vw==
X-Received: from dlam7-n1.prod.google.com ([2002:a05:701b:2087:10b0:15e:35b8:18c6])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:7e02:b0:143:2967:c0b1 with SMTP id a92af1059eb24-16206b2b3e2mr4893297c88.25.1791412805684;
 Wed, 07 Oct 2026 15:40:05 -0700 (PDT)
Date: Wed,  7 Oct 2026 22:39:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <cover.1791410885.git.abhishekbapat@google.com>
Subject: [PATCH v2 0/4] alloc_tag: Introduce selective tracing for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA65AC0006
X-Stat-Signature: pw6dhr9gy3fnhtzt8crnrhkcriydgoyd
X-HE-Tag: 1791412807-624666
X-HE-Meta: U2FsdGVkX1+W2RbKKSnlYeEQFbG70uV5fb+xn74RmbN4dmFUniuJ9SwBkA1T8Cg25l7kr2Q8dusbl2qUUO3geNtxaArYhuYTfHB8lkYOt1hNRv57Lt86l88yylMT7fcYFpFau4X2DkFDZaOeyZqnhYWdAUlywix62cb4ux10IoTcgMA30sG0KwObFo505ThSA1e2dOZ1y+ZQYdmF9MXN+2/iUig+oqWfUBqwHca1H4nyGgICEPylIY2N9Ub26JtLNFdaZTYjlzAmtSqAEGBFbplRByYri0Xph3xKEtZBCy7Tt3wdMf9coEEty93IkczTUk6bgo1NehJnvGKd1330TDgW5gm7u6R8NWiskqhmhdrpgZK2M1jSLtT61hQb8IZTEbcg0ZWQsGjNkcXcwDnMv7NEhfEH+YfOF/7JPglcgBmvtjarIXLxQR33rlDj7Ihi75OsGqM4IJWVynGHI7dX5i+G0hjk31UAdGz9BPuLeZOaztLLyNNt5SpnujZzBbxfq0+6Dn5Tv6M7rXdEDwKVU3ZrputZzJh+6t3Bduo/ZOBiTltdoJZH0eB4ik0VbuKtKXLZWNvFVBPmgTGekI+1zpQAMj2x5s/VNyPkiYQQZthXgivDfsWFsF+nK7MxmIDUcqP9JifeWOA+bkGd4eKSTRBMCY1zlI3PctdVxC8baZTe2h0V04E9254B/gAOCUJ5ZLvKITvnJJzJBiZ6Jx4nnsi+t/5BML885P1n3NCDvuX11dNvbsWDANW7Hzw7XXTElLb4cCzj5tMFtEr9VpKDI2LyAby14QOforf7RAtsgPwqq2kTt+rBU3jzTbIxVraAKJtlnsVmA4EJ9AiU5uvCZpztImsn3FJ+Y0I1tZVvtRCJckEpnpmmAIzG4Xi4miCnSS6l1N6wggi7XnOdkRxEI7YfFOn3GJxxb5WKvabhJHGEPBRZY8yrSBoDQdHl67ZjWtcbZIAMByiVeqsZdJM
 iER2bDPU
 yNyJgUvUI4rebeZTiQhya3ugGzp4/L61JldI8iZg67MaCdFusW4DnPK8J9M8lhCRCamn7cBtiQJ8r9gBpBdNBgMwnXBd98GUIPQsn/A/DoXjE3thccZvSsN9LFnzdovC7ljPwEhb50duWTt3PSgV3J/zQBDyfj+okN78SQqKtOdxp5lYtz/huREjVIlPwzV7R9jHrTMQQmWuXQvqE7DOfDcMvVtZJYc4HA87XBMrGmqJ3/aG1RX0BpGa2fTDJoQ8zD9Hl69iQYSNu9ejREJ4BcO39B9+XsDIljSe8FjKVoQokpw9aSiLO29xgVxD7vp1nVbx+Iu1k1UGd20/Ep8GW0Ilurdu+WJJQFjQWyYRMqgYCGYrEwUMuQtqMcyKHKk4O+Q2htdZz5/aMqhC8qmOci4zVQjaa9jzHfg6GJm52QbMN81158O/VUFTDNOMoCJsua8impiRKgAlKImPpja7mmbWe1Xb/CoGeT4UhVb02uLCphIWfKwhPoDi7fCBE+UfKQIqVDwj2rQ9ztYjpSMHMZmulPijca+cFchAOnAHRTBHhzM3skLoDIb2cmv+B7I44rceiaYVxi7apTieCDxVc3veJVJohqtJrAxR7oZJDsHEjlbyE3OJmAeHT13oINBvfghjo9jQUU4MR/kYyrC3nX7dUIinS9siqx9TUbf/uLhCspXr7XauSPo13zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing memory allocation profiling (MAP) tool accurately maintains
aggregate counters for overall memory accounting. However, relying
purely on aggregated counters restrics the visibility needed for
targeted debugging.

This patch series integrates three new tracepoints (alloc_tag_hit,
alloc_tag_mem_alloced and alloc_tag_mem_freed) directly into the
alloc_hooks_tag fast path.

Enabling trace events globally for all allocations introduces a severe
baseline overhead. To limit the performance overhead, we let the admin
select specific allocations to be traced.

A new IOCTL is introduced to allow privileged users to determine which
allocation tags need tracing enabled. The IOCTL utilizes the
pre-existing filtering mechanism to specify the allocation tags to
enable tracing on.

v2 changes:
- Patch 1/4: Changed the trace events for the page allocator to track
  pointer to the head page instead of codetag_ref.
  alloc_tag_trace_enabled() no longer takes a tag arg, that arg gets
  added in patch 2 instead where the function makes use of it.
  Introduced new sections in the Documentation expanding on the newly
  introduced trace events. Minor typo fixes.
- Patch 2/4: Toggle traces IOCTL now uses the same filter as other
  related ioctls. IOCTL returns -ENOENT if no tags match and an empty
  filter matches all tags. Added a subsection in the Documentation
  expanding on the new IOCTL.
- Patch 4/4: Updated the test to work with the new UAPI from patch 2.
  Updated commit message to accurately mention that the test flips the
  state of trace_on, verifies it and restores to the original state.

Abhishek Bapat (4):
  alloc_tag: Add trace events for tracing allocations
  alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
  alloc_tag: Extend allocinfo_filter to support tracing queries
  alloc_tag: Add a test for trace state toggle and filtering

 Documentation/mm/allocation-profiling.rst     |  73 ++++++++
 MAINTAINERS                                   |   1 +
 include/linux/alloc_tag.h                     | 104 +++++++++---
 include/linux/codetag.h                       |   5 +-
 include/trace/events/alloc_tag.h              | 122 +++++++++++++
 include/uapi/linux/alloc_tag.h                |  21 ++-
 mm/alloc_tag.c                                | 160 +++++++++++++++++-
 mm/page_alloc.c                               |   4 +-
 mm/percpu.c                                   |  12 +-
 mm/slub.c                                     |   6 +-
 .../alloc_tag/allocinfo_ioctl_test.c          | 113 ++++++++++++-
 11 files changed, 573 insertions(+), 48 deletions(-)
 create mode 100644 include/trace/events/alloc_tag.h


base-commit: a663a4c75b63341fa6cc16e15feb29f36321f5f2
-- 
2.56.0.385.gd3acb90ef8-goog


