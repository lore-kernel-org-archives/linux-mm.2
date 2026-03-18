Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B673103E183
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F876B020A; Wed, 18 Mar 2026 10:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D993F6B020C; Wed, 18 Mar 2026 10:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61576B020D; Wed, 18 Mar 2026 10:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADCCD6B020A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:16:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B3441A074D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:16:59 +0000 (UTC)
X-FDA: 84559385358.26.A206D74
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 75DCB4000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:16:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k75txIyN;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4q2Kpmc046uJxX9180CbyEXa13fWGp44Xh17p9r6jpo=;
	b=n9/Tf0352sRFUxuseT2V3G/dVz1GFAb40E2sOH4++yrR1PP5vIXwjC7DEtVIw6l+1pZV50
	6IwUMoJkt+wKmHWTYMpS2rDhmL0DPZoebsFucrRhNOY4c4xv2Cw6Sy5PkBeN5fV7UaFt7M
	Cg1N4w3PJpmzljVcgyeI2TdsSa7+kBU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k75txIyN;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843417; a=rsa-sha256;
	cv=none;
	b=bYW/vn59b05BRNYgBcst90SZl2amlFNtW7ZuTQPOSLAsjjJFai3urAuayTyOO99Ea5Jg/e
	ZPGEmPOkuyB4AvpKFdJCKMaCexmwtysl0MzKQE87SpDoH6LgiViqs/dUqPokrvrTWXKQ6Z
	dpJEMxiV7fdp6cVtvNw2ZeN5gCnG5OQ=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64c9a6d68e5so5958011d50.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843416; x=1774448216; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=4q2Kpmc046uJxX9180CbyEXa13fWGp44Xh17p9r6jpo=;
        b=k75txIyNcxTZ2ZS7zbv6Itfa4/Nl/YKwWqxcWq8cxKGjQQY4ShsfPAIncfBZfohfMK
         jcFTnaQpenyLit1K1DuFqz3k/b2rXlEqzp/s5xv6xkMoPRPjcVgvFUep7+DHurHRZgI1
         DS4WPYndQUng2KEEdUz6ODVYee3BkDf42wGORI1ML+nzMkhJUJ6jkEGYryV11CWw8CKc
         ZD7R5MnYoyAHNUvxdfrKiCAkXCmlwQN4EAMQFp5apIQAgq5eM315Yt2MjBpIOB5UnS/i
         BSb0ubPf3MBsT+yYcgUh21L+GdIupVxFDx1oFwy6Yujsd9F4/UmOaue2STeemkxlyPDL
         s2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843416; x=1774448216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4q2Kpmc046uJxX9180CbyEXa13fWGp44Xh17p9r6jpo=;
        b=fcmBZT5K+YFXBf1HhspSqmoTrFyXRgHOQPdbIPiYcOTUHBhF1cvHz9NyfxOMbc5Qep
         q/TGKO7exENv9JvR7c8VB7zYQZXjmm1zc4KnoZpV+MaqQfdv+94TK88i2iJ1QNqrxU5c
         LFsT7XlZVNT9S8b5FH6Ek8GZR+eil78fxL/y81x0bGNLaFeveATpdJzvN+2fHSdl0TaL
         /1yggV5YjiWLdeIOGBzD74pNWYx0XiDlpq7LSVkMWvWrUG8iLEyXFB5MLQlNvP+pkPpM
         /mRsx+QEh54PmGkNT8Io5veHY3WPJfsHBSUw3xzmm2Jx3QmU0IwlvZj2tzzZ0uCVTCck
         Z4zA==
X-Forwarded-Encrypted: i=1; AJvYcCVp9Dmsrv3fCI2LsXSroDaECnAClRsHNVHzrMxD1pgAYRA7tTE1p6EM1BYk8QPeZF+eq+p1VZ4U+g==@kvack.org
X-Gm-Message-State: AOJu0YxSGw+Kx6M4B1EqSAhhkDK9StK+B23ZmPydgd1Broxuz4sxNqbP
	cyoZV66aXkENg7GJpxM1KtfyJP+/Rf/WgPqq+nNelKXEUO1j7CjbisvmDEFNT4AFf2A=
X-Gm-Gg: ATEYQzysxGrYSpBZ6oa44/rtGZF/Ja7IKoAs4+peZZuwp8tp7pQNHOj/ytPRQqHqEQ8
	tS7+d8p2zZT5MalvA5/NQcDrpmeCaGT3vO+5shn8/A7D5ni+zSJUIYrHvbRdYyG18e3b88Vmm6i
	1/OnkeKhYQ5xQOyAs9HOyjZKlNzL9JTpiGl6iQ/Itnk18mkmomBn5hrbGNBE+RnPaqZXHu4EPO+
	neCmdJw9g6QgMEeG1oc4N0u1joBZw6sK8v+5jP/yZNEFJJZzJEOHjaLl8oVw1zt5MOmZGyv3Oby
	PCGQv+cEB5m+ccAsEV2SDs7QryCUIQUGwD/BIB169u7iLjgmT2HCr4gQngTZKe4otFnaUr6+rzy
	hpQoJo7Lzj3/6w5a03gg7Uxq5O6BY0Reezq8eR7y0EKHR2/36yr/VLzxkVxW7XZoU3VjWF4YX1l
	nAOftxmatZ0MLiy0uydOF6a6jG8057C2NwhhAXhShbjlqB/62oxxqMacfqWP2rJBmbAZ135S9PR
	E5pFNl6MXno6L2gBw0m97pSPphugtFr/8GH4+aozKk7ARuAug==
X-Received: by 2002:a53:ecda:0:b0:64d:600d:854d with SMTP id 956f58d0204a3-64e915f472emr3039552d50.53.1773843416042;
        Wed, 18 Mar 2026 07:16:56 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:16:54 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 0/8] liveupdate: Fix module unloading and unregister API
Date: Wed, 18 Mar 2026 10:16:38 -0400
Message-ID: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3787; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=EuMJArGnI8kRlyq8BztHfFcfmmi/UChIrOm+EM6ffkM=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPF8OwF1EEF/gbudqFWnQHPHX0mnjp0zmH7b
 KvA25XftzKJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqzxQAKCRC7dyhM23N6
 3p8oEADJUOXiGnWAwl0MVovORfep6rpEbo9p8PCu5MV6ngPdHBL7IRKMgr0+K6UcShfkPJRkME8
 j2fnQa0glhWuDPxQvzQ6nsIGtzSb0+C6m8woGgUjmEJeI7gZZ0E6ThRREM1yat8uNbgtTzcyREb
 RTA4V/8+Rb8Ni1W+9PkbvR0dQ+sfVX9AkIPIT24/jx2ZHkZLByGzU2oiTBsvZsSt6DNyn7N6R75
 RAr2kH78kMgfOVcRUptrxrQMH48JxssJjFKrE5pBq5madLiXTkq9oCZSa9UjKycPoU+WLTT/ebt
 HMvr7aJU4CZvjm2EUKUarMKDY7brxGRNdzYYYvGcr3d1M9J+Rd3A+kasxhRVCYhQJkiXYklxiE1
 +QLPEEJ89fa3bteaxxWYMtmbCkxYmZfwdSNjWB1/XHT40HStQhz9sLr7FP4bgYSGid+51XMFyoE
 9uRwnBSDV9Qf+0axYHeWfXx8wHNCo/scY0ZPXCHeQvxXjIEvAPF0FAFA0NeLQH/N5otnUMEVoPA
 NRnWoUfSwB9ZHLhMx96rx44UDKFkJE9s4+XrH/JucFwTNgy+maIxVYWQScWMGF3rn4+iFK6MghV
 /2CvbA48JJmixHviY1sVi3977ATEi0hi+gd0Bzm6Kym0OSRz/kSqmgeRdm3yG8GKUy0VE9ZH5ip PXli39Oan+MBb8w==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 75DCB4000B
X-Stat-Signature: 5ohjo4onzhgxk8uypwoo6c7ziqee7zes
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773843417-952537
X-HE-Meta: U2FsdGVkX1+8LxkqN6/3J9LhIABAG/A4SndrmJP57kq/W4uDp2NTCda8DXPMXvuH/62JolKZoVTmuDVWtdymQrCOklRT5yeqG5w68wwbxzgZAfp8aA+gHzQNBs2iU7NDA6LZj2gzzphmDEj//3a2xniQLy4F4qKYAEanO0xXy7vwWLpwNk1ftJDFeJy6O8OS3wEkNsC4asFvnGd4CHGyyoi/X1HbEdZeJzzcJtJ1/iK8Q/QnzbzjOY4XWB1tf/BhpsTVd3ehHTkIBKc54v4sBOkkEGlGlsxm6FSlrig4cYgNck5Uo2u5W6+gYNMgmEwNyXzS9Tqwg8YRSMjm1cZQIQsk+gLH483yDUE+BHG5G7vtXH/Fz11ISZoeo/5+qcdSsjz9Dqorxdk709Hzf6QC+WpCUMjy20RhiQk6PbGFgo90SiyNO0sbLiOyMppBhUeCTPJsH6NIqIoQmBfNb9/TnXeb+ITq3ax60h/4KeUQ0WkYQOHp4VFEMDZ6ujCO6/GewrwHr4Jfg6ZsrHmxSGOLFJcuLkKhXhoRi5O+R8KOX8sw3Yk2l0/uEOtVWb3NjF6RbSg0/qhZrfxdUdpM1DXmRkBPa2IU1UkxehA923ngqywfcsN1iQZ4f/6JSeFv11BCz2ZlJz8krCvRLL8GyuAgC+p+Y6A8TxmyZ++SkHReQDNYXtyu2uPeZRlb+2qZ7QR7H1jE4vd76V3qV/pcg/BpAg9InB+WO0oXUJxoNnMw+K7Bg5mPCZRRTS/0gzgbbEPyWDyAI9GzgARwJ5xnsXzAK6u8nMzyGbcGchT1bq1TJe+VzHUulKM/xW7KVzPH8lwP+xRplzbcGb6kUDjCLOJhYTkJSwS0h0wacEijpYgcgQXW9IeZTTUKr3YgNtn70hVvRLini0udYO826wW0Ymum5ND8qYH2i8GPyopMCcF28bUD/6QMEMLkt0l1f+mmgI91o/eA7vPjQMhPLSDrEAj
 p/7yOnYL
 qWSp9AIfhBbmLbnQWF9fGPNFCyIIPYIuzP5tt1Bj9aHnVYrwf6ys+HvI5uMjxLMIyfotaQwgW/rmHpbvMCV0n/hREYFQVyw4x1fyi46dNp2+tHyskT/LE9rQLxorm4uII0gjog7LoTVjIBdn3H8+T1j7hez9cbzbw2fg0oAYOCk0pgUsd8DPOzbAWixACnjFmE61GQgpr4/6E29Q3uWUhRjvEnq8wLk4eblHDWgBTRrIbPNc3HjPSkDHC06hfP7CbGiVxmFCIGt2AVRjweOWC/PiN6cSBuKRqWOoMr8rFzBuPi5dLGaUgITBPWA==
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

As pointed out by Jason Gunthorpe and Alex Williamson during the review
of the VFIO PCI live update patches [1]:
> "destroy" functions that fail are evil. :)
> IMHO blow up the kernel or something in the core code, you can't stop
> module unloading once it starts so it is pointless to propagate this

To resolve these issues, this series introduces the following changes:
1. Adds read-write semaphores (luo_file_handler_lock, luo_flb_lock, and
   a per-handler flb_lock) to protect the registration lists. This allows
   concurrent access for file preservation without blocking, while still
   preventing traversal races during module unload.
2. Defers FLB module reference counting (try_module_get / module_put)
   so that modules are only pinned when their FLBs are actively used
   in a live update session.
3. Removes module reference counting for file handlers, relying
   on the VFS 'struct file' pinning (via f_op->owner) and safe
   deserialization without concurrent unloads.
4. Removes the global luo_session_quiesce() mechanism since module
   unload behavior now handles active sessions implicitly.
5. Introduces auto-unregistration of FLBs during file handler
   unregistration to prevent leaving dangling resources.
6. Changes the unregistration functions to return void instead of
   an error code.

[1] https://lore.kernel.org/all/20260303210733.GG972761@nvidia.com

Changelog since v1:
- Restructured the patch series to eliminate intermediate code changes.
- Replaced the "Defer file handler module refcounting" patch with
  "Remove file handler module refcounting" since the VFS 'struct file'
  inherently pins the file handler's module via f_op->owner during
  active sessions, rendering dynamic reference counting unnecessary
  for handlers, as suggested by David Matlack.
- Split the unregister API change into two logical patches: one for
  auto-unregistration of FLBs and another to convert the unregister
  functions to return void.
- Added a patch to clean up the redundant `liveupdate_test_unregister()`
  function in `lib/tests/liveupdate.c`.
- Reordered the patches so that `liveupdate_test_unregister()` is cleanly
  removed before the core API signatures change to return void.

Pasha Tatashin (8):
  liveupdate: Protect file handler list with rwsem
  liveupdate: Protect FLB lists with rwsem
  liveupdate: Remove file handler module refcounting
  liveupdate: Defer FLB module refcounting to active sessions
  liveupdate: Remove luo_session_quiesce()
  liveupdate: Auto unregister FLBs on file handler unregistration
  liveupdate: Remove liveupdate_test_unregister()
  liveupdate: Make unregister functions return void

 include/linux/liveupdate.h       |  17 +--
 kernel/liveupdate/luo_file.c     | 102 ++++++-----------
 kernel/liveupdate/luo_flb.c      | 182 +++++++++++++++++--------------
 kernel/liveupdate/luo_internal.h |   5 +-
 kernel/liveupdate/luo_session.c  |  44 --------
 lib/tests/liveupdate.c           |  18 ---
 6 files changed, 139 insertions(+), 229 deletions(-)


base-commit: 8e5a478b6d6a5bb0a3d52147862b15e4d826af19
-- 
2.53.0.851.ga537e3e6e9-goog

