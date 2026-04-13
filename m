Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 492CDF531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21886B008A; Mon, 13 Apr 2026 14:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2546B0096; Mon, 13 Apr 2026 14:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9107A6B009B; Mon, 13 Apr 2026 14:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 819C46B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C453013A0CD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:31 +0000 (UTC)
X-FDA: 84654425982.05.59BC5EF
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1B9D4000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ETXlFbWX;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nXdhHmCt9HCHwn5uF0tfmMIFoBDe6KztPifx02CLmJI=;
	b=xWlpwTpsyYr/l2NIptDKsc+zxyvQrzt1+Cjqq+5YWJa5A1xlBZgENT7aYi0oCr7HYR3p9s
	n1M8ZGldMEar7w3OCvLarHz2MI+aC4eZAoCdlisJ9RO949EmU6zY46ihPwvbi4NK7Y1Xu1
	yRbQWbOnWOeDQMhDid+X8z7ShUxtmjE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ETXlFbWX;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106290; a=rsa-sha256;
	cv=none;
	b=AC6HPAjuFG+jpqSh0xcB7lNlNOJYgDI+TVo/ZKjJcRlVaYV1Q4CcC/LFu/d5ergFd2FkQ3
	bC4JelCHlwMJg+1d8JLkeFkfGgfm0PNbFE9t+iR8iXGe3Gr8FASvNZawp4HCRFgCztkGMV
	k/cv42BJHjIPeiMNyc5NRFImZJnsU5g=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8cb5c9ba82bso730556485a.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106289; x=1776711089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nXdhHmCt9HCHwn5uF0tfmMIFoBDe6KztPifx02CLmJI=;
        b=ETXlFbWX1clBsfTBzushNUk/x8z+THWUwvTc0gdB5cYWOkeztFO4cERvDZrvU/WsoM
         PLP7ZHTdGDiN2eIXFTQyPpolZPIXumHUHs01o6Yjp3dVQJLVHMuv/nwwKjqQfSyIYsad
         gJ33sIAYwPmPRrdxkuiNMOmfU9rLqeAiK7JUeY1ZKN2AqQ4txoZ41ekP5tu5bMn0t6Xc
         I3+eb9gLNtWHqwm2RJuO3A3gFdCW8keyCiDm6ogC6mPsTrV9ICAjm83FHUS1VO0GX0TQ
         sZnueDnLSt5nLVEUlUMK0PhBOfmXOGgD1lUc/jFTYsMcF0OLREk9yBQIgO9IfiDeU/oT
         Y56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106289; x=1776711089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nXdhHmCt9HCHwn5uF0tfmMIFoBDe6KztPifx02CLmJI=;
        b=RCr8Hcg9hGSKt8kEXrrvyVgCb1c7SsGLk5ltpchCorwd2oLYxvT2m0uYhjyH5BAK2n
         vsaLr8nsvdxHPPb4EZDbLhbdC3h+LgBe+nlKxMFIxkgVM2QI+z0k+jrsJdrUK5pgdO1p
         gqZE6IAewVTweaoVYMzN5iqa1VF0gtOx3UC5r47+FWWkjrkjN38ykPglRdoOLL3vWNGm
         T3PY1++CXGsUYOOFBMS4daPErO90MxmL2Xtml8k3nGXqhMblm0/09zV9UOi3EqDdnLVN
         w+W5rtQ/Q8UlcDds6Lne83DJwvROzjC6oekIn55LZ8Xc2IPKZ28EgODkCRplJ46nEL/U
         cF6Q==
X-Forwarded-Encrypted: i=1; AFNElJ+QD90xjE59GxUCmoal55dOnxzdTEJUzPi1o0scvwH4w421XwiXVx4nfUcqCOtXwz/v09LXXDhKCQ==@kvack.org
X-Gm-Message-State: AOJu0YyQz/voFYsPZJVin40iv2UxcEqCfC7j5j2vi0DYS4PtAxV5zIb3
	5+maabBKFLA5Imt7aCEsUZ1azhenbpREDxJkEu84ZY+KuEy5QD4zmQj+UCeCpl3qCPY=
X-Gm-Gg: AeBDievD3UEj1yQSkzSMNfcPUe7/qvjgCwBdfq9QNI0+tp5KuwIyOuPneU5BsY6G5bx
	IdRUYeezwr8irU/XQmvCZ1P0cooH27u7nWIahy9SFiqFYeCBgmZ/K7TJy1rsKmiGK8E+NC5HAD1
	NPYV0Mr9N2ueC/fesoxd1qYXYlTtZWYz0pe1SzIzPZXL+VqrDUrz9TwfDvmui/CrSo3O/cA3L+J
	7TQ0C5gXNDdSHUyewla1IfmfqAOiD8XFTBLKEPD+OsPQInLtlGbBgX5XgY8586SyMqSbxONPSYR
	gDC6EQsJtweWdw+fsxmFdvgk6fyCuWTQm6BEmgs3ZJextx5oXhOyMvMhUoStahjpSPQjRMpx0pP
	qvE5SjByJDBs9p3IQrrdQdpuyKAQgGijEntzZdFUVnwkxeZYlIS5va9p0ghbz6M5fcVp+6/LqfL
	L1rHBG5zTLtU0QgVAyaieV1UbmVxIRgbiXBtIslLM1i5onvIjcF8VoqfWW4RpIVcj4Zg==
X-Received: by 2002:a05:620a:410c:b0:8cf:e946:bba6 with SMTP id af79cd13be357-8ddcecbd79dmr2141356585a.36.1776106288806;
        Mon, 13 Apr 2026 11:51:28 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:28 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 00/11] liveupdate: Fix module unloading and unregister API
Date: Mon, 13 Apr 2026 18:51:16 +0000
Message-ID: <20260413185127.128180-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1B9D4000A
X-Stat-Signature: 4rc9qiywaenrma543he9cq4edafrpdpb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776106289-126131
X-HE-Meta: U2FsdGVkX18eGUND5NaDayyG9L7c74rwfCXhCKAcVYr6mtB2aclagt7s3SVRqysRUABJdN16jks+M1E0WnxWoDiOLxohHIygKxDyDKpwnrPzbZi9Nq89sap/U+Ze8qt/jom0YdSGEfh99pmYkAHkOQ8FFkF7DOlTZPUPs03Z/Txbxu/DxZJspNdcWVEkMgsvX/MQEhPl7lBZIceZ4JkFPJZILuZ/p85upErq4JKWHKE5tXlX1sx7i7Dr/FuKMlB2WuKBfQdsqszcTq3sbcGAyBLRN1hA+M769jR1U0byV0iQtlS8SKpYPh++k1bQZjvihbUfn1fX2mx+Z5/MC0DDGTwepFhQbTh4qQYGNO5fk+4FIZggslD+lQJUl4vlp001fgKrutIbj6BUAfiPMuUUILcwg1pOT6WBHwmNg3w2+EC0P2WPnTK0+nTPIpN8ODgNtumJ6Y5KptVO1OwEpa9cQC5j3/cWzuBFYqsAgB7R6yWSltUGJwNirnGJZ1u7xZ2F+aXo5juX14tN6vzRLgxfSaGMCSr87xDkP6gTY3WgvK3J48ckvc6w+fsofl00NfFWYrsBnW+W3LXe8CRy2V2ryr7NoQ2hOOMh3jx01/4fzNGD4xgNlkGQqZQKn3inYFtLJLgct1gLAJqTO9gq/JOtrN39DEH1/kXyzF3f3hUbfVFiwLVXKS7nUwJLbTBMeZdM3v2MGZ8Gbvm26z0B+uC1x+mTrUM3M6BoVPTPjJLUMU3wn6OIZ0Qu/y+1up+Fh5ByNqHrxM/R+Ks82p7mpC3rHz7mXdIYh6VOLmqCsv8Ixx3oPamdBMWGsKnq49fVLLRl1A3Vko+7v/ysnBncxHYZaj/DSmPVq7uwmjm1cdrL0rIYFic2PSwFBE582fcbV0ZpK7bfwGYL+z7MIY8z45iZGaThyYn2qakIcPPmQmOUA/OXj2NHCuNj8LEJ7HFpCxTiJLTj6M/YbSQVydk5gBM
 n20lKwCT
 mXfqb+sJY+guGArYnxz2CoNXqAz4RBQZMI4iJy7u8F1/xxJupDl6tZwkWus0qMx07E4kldQmNFdfdoPi8Er0yrWOAhax7NOM8CCngIHVBSIRz7uDBo/iEEm3RCePQdMRxCPQ7F9GHdux0ONa26WeCS+iZqRxJVGaJBjqIvq6770iN4aOMX3NhBWT4BX7BP5wOramvqPYcHaEv7hpLpRO4b/T6/ZaqJuyo65oL6ejaTpE9/BJg8PkakSWAr2J0AlvrHs353o1gPTyFxQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series addresses an issue with how LUO handles module
reference counting and unregistration during a module unload (e.g.,
via rmmod).

Currently, modules that register live update file handlers are pinned
for the entire duration they are registered. This prevents the modules
from being unloaded gracefully, even when no live update session is in
progress.

Furthermore, if a module is forcefully unloaded, the unregistration
functions return an error (e.g. -EBUSY) if a session is active, which
is ignored by the kernel's module unload path, leaving dangling
pointers in the LUO global lists.

To resolve these issues, this series introduces the following changes:
1. Adds a global read-write semaphore (luo_register_rwlock) to protect
   the registration lists for both file handlers and FLBs.
2. Reduces the scope of module reference counting for file handlers and
   FLBs. Instead of pinning modules indefinitely upon registration,
   references are now taken only when they are actively used in a live
   update session (e.g., during preservation, retrieval, or
   deserialization).
3. Removes the global luo_session_quiesce() mechanism since module
   unload behavior now handles active sessions implicitly.
4. Introduces auto-unregistration of FLBs during file handler
   unregistration to prevent leaving dangling resources.
5. Changes the unregistration functions to return void instead of
   an error code.
6. Fixes a data race in luo_flb_get_private() by introducing a spinlock
   for thread-safe lazy initialization.
7. Strengthens security by using %.*s when printing untrusted deserialized
   compatible strings and session names to prevent out-of-bounds reads.
8. Fixes a return value issue in session deserialization.

Changelog since v3:
- Collected Reviewed-by tags from Pratyush Yadav and Samiullah Khawaja.
- Documented the assumption that a handler's lifecycle is bound to its
  implementing module's lifecycle in the LUO File Descriptors DOC comment,
  as requested by Sami.
- Added a lockdep_assert_held_write() in luo_flb_unregister_all() as
  reqeuested by Pratyush.
- Added "fix return value on session allocation failure" patch per
  discussion in v3.

Pasha Tatashin (11):
  liveupdate: Safely print untrusted strings
  liveupdate: Synchronize lazy initialization of FLB private state
  liveupdate: Protect file handler list with rwsem
  liveupdate: Protect FLB lists with luo_register_rwlock
  liveupdate: Defer FLB module refcounting to active sessions
  liveupdate: Remove luo_session_quiesce()
  liveupdate: Auto unregister FLBs on file handler unregistration
  liveupdate: Remove liveupdate_test_unregister()
  liveupdate: Make unregister functions return void
  liveupdate: Defer file handler module refcounting to active sessions
  liveupdate: fix return value on session allocation failure

 include/linux/liveupdate.h       |  15 ++-
 kernel/liveupdate/luo_core.c     |   6 +
 kernel/liveupdate/luo_file.c     |  91 ++++++---------
 kernel/liveupdate/luo_flb.c      | 183 +++++++++++++++++--------------
 kernel/liveupdate/luo_internal.h |   7 +-
 kernel/liveupdate/luo_session.c  |  49 +--------
 lib/tests/liveupdate.c           |  18 ---
 7 files changed, 151 insertions(+), 218 deletions(-)

-- 
2.43.0

