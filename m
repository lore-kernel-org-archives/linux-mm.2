Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B7F10BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07766B009F; Thu, 26 Mar 2026 23:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D916F6B00A0; Thu, 26 Mar 2026 23:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59F06B00A1; Thu, 26 Mar 2026 23:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B05466B009F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C3A513C07E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:39 +0000 (UTC)
X-FDA: 84590423358.05.EB728CF
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 98C7910000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XbUgJsfl;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2mVzEWL0L2HhjVvEK8GmAScGtZLW+i1YPHrNZRQ3Nso=;
	b=5IistK1VVj+/yYNrfA8vTD+e1U7jQ0UnJicSzLTzwcQxfsLUOb+WgvDLJkZikz88GneI4f
	vCyMyMP/5I+RoDIq+mFWRrbsYZo0BtbZi2oC4u6DPte2JdBYHU2h65WbTMfE7vezUwQv8y
	DFpAq3t8YkrToIFJD9znKMD5+pSD8Q0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582417; a=rsa-sha256;
	cv=none;
	b=bBu/biUZMup5Ia2yQVUNaJAqeb3LgzSfALmBzOc05XGsBiEMLIL+JmHFJdYQP95yHTQPxp
	2sucnN81cg7/zpKm0QlUDGZv0BPtMgDHbNXbBQJ7lcVwCTtCMCK+OrrarFtNEBpTM3A0ga
	OIAi1yTXAmoOI7/5fPrOoFdCOrAH0+o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XbUgJsfl;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-89a1d7cc7f0so14216196d6.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582416; x=1775187216; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2mVzEWL0L2HhjVvEK8GmAScGtZLW+i1YPHrNZRQ3Nso=;
        b=XbUgJsflS5cLCDFY0XLGIPRMbBsZpgjH6U4gQwJ6xmMzKrBMQSeQJlTB3dof56my/J
         nztRZP12sycFHO5S9C1T7/62xygYgXpuNV0FLr9wn1mJ5iEZTDnK4nkvRf7S3ZnlCjSl
         s/1uOiJ47OINHUT4+y85vwTcoFnRtwf6VzmRLciyYNYYI2ufMF2UMy3LqplSOAprqE9q
         qP7dpDw2brgmWoSaPHAiTrtobfe4iMFyB2ziQN/7ej/s+dMPV2Tg3Pn+/eYWzBfc/fYl
         eCCM+O6cTQz9v7lE4uFM3iAdi9BZqczHNSNQ6XIy50BgcbwSQJkXRCbKJpJJhOirbBA2
         9jaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582416; x=1775187216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2mVzEWL0L2HhjVvEK8GmAScGtZLW+i1YPHrNZRQ3Nso=;
        b=QVex7lNaPE/oRW4/2BNH5AqAYPIWUCYsB+1xPgvhXZXouXh+tY7WzWx2CU66l0Dl81
         dt3uA3V56lOpGAmCmuv80smBcaxTNub4FbNjrDug6QGYCvSvqMOKSl5MvxAKEr+fpKuB
         4RS4BBzbO901NU3dVoijh80NAMF8nydgHCToVP3g0WRcgvLl+GyaXyzPnyKXDXaYxiYB
         vo8kUGRGUMatuXbHeKYlDQxRJjiE6qHUIrvfzl8DacQZPQ2mmRFofdIN2JOKEMTrRCh2
         XDNk5YogVQQcBgKzeltGycTf7K7If5GCelqVKDzf/4gJJUWYinKyh2xPleenVNyDvHJp
         tf3A==
X-Forwarded-Encrypted: i=1; AJvYcCW+ZzmVT4CEEnTjDJO7A0NHf+6YZkbVBOZbDKFNv/WALiwDxxq8a/+VVZwh6LuMVg9yydEbMcZtEg==@kvack.org
X-Gm-Message-State: AOJu0YyMJQM6Loi0ELSPkvTBM8sV352ELsgCYefCLRaSOhkNn2ZGFoeD
	pnpqXkD/jpfUOLlpniN33/B07xC7p4kO6DT70wHbefM85Ai+NMWDn95inABOIS89DvM=
X-Gm-Gg: ATEYQzyMpW52n/noNAaTlV4NIM1ocQ0vlF6QqpzeIdyRJITLMl/5dKG+FUws3BqSUFp
	1akoU+hzmgyvn0J6+ilBDOzUL2JAJOE8Wwic5E1HOb0wgwbpzIgfaqH8dk4SgQZRMEuA+Fqlv63
	9Y2VFDy1+272GKCrkWWJHf76AGm0BuprnF53zH4CdPs6se/PxB86gOiz6TlGQWs8RmnC+hqkpey
	4YuPHSLvPXgJZuXOQG1FT+ch/6wq7js/XBVihH5v4B+a0CAR3u/Xm499GaZS0NokuH0ItnlBx6D
	M6r5MfcnTLf2YbTJehj97uVNBAUc/jGyFaaZj1tkvaO7k4w2ib5e4YUwWHN92lYWfldKPB3fsgG
	Mjd0a+ulws9DWyUZYrFCIWGnROhKLDcClBh6fUq3CSpM1G4wfY1a/Hn8sxC+KzvQIIMnoNo1gko
	pP5D8jLThetIiKuWT00zTH+bl//NKfrYvG3TUPRfBoBCngjqA56ZFQbOryHZVJT4IxJg==
X-Received: by 2002:ad4:5de7:0:b0:89a:13fa:c1cf with SMTP id 6a1803df08f44-89ce8f8a73fmr11222326d6.55.1774582416603;
        Thu, 26 Mar 2026 20:33:36 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:36 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 00/10] liveupdate: Fix module unloading and unregister API
Date: Fri, 27 Mar 2026 03:33:24 +0000
Message-ID: <20260327033335.696621-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98C7910000A
X-Stat-Signature: qf1f7x5ab6q1mbrhaje4b8r1h6biz8j8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774582417-70883
X-HE-Meta: U2FsdGVkX1/+RwtdC9g7tB+zIEPjBm8sf5wgklOB9sdWbS4XUvQ2rE+xYT+ZTp7tk7IMZH7AezQJPHgooXEgA/plgOYiVSTBI4jgLDudNA+A4um1Vf4vRGkm79hGE+j+BD6ceYbatKCKS9QQDL43JsUXoDzNkAaCh2azWquH59k7/SHDXm+kAvPdwEGg3NKhi9t5Ez7ZHGx3dyEF625qLDVMUTmRWGAvUcd+nZnbi8aCBTLdZTQSwMuVqGnESy69jUcgSAJfHYbquSniJ2ZsJN7o+bf027pr3/sVUCF+t6kaOYZkuO481bPImDzpuKWPzDQsDti9VmJhXDQrj4bFIZd9z64isjG0/p2poOGzurVhozbOQVgLcWqxVIjgtnNJN/c6xA9HY25AUf8A5Apt5pmGzHmH5H3Mv8q6XmbKL0aPY5JdUd/XHFpZiggGwTXCmfka/GYX0CAk+BisSky7JtVl0Po5EFE39st1ZE7q7UOJ/fyMk0UVTZVuIEFhmWfFO3D8UnXuMTwmwXOkcpw+SEUzSfuQcaPQ8aOd601Wi60h7nn0gRFWnS/ZO9+TcV8r2dSicncZ9uosKTJ9VD60McTyzRkENXJiE5vNAvRH8mZWuWf9dBbXtwJU6uDT33kj5ApctaNOcEoeepQlbgZD0wkcQ2ei2Ztd5pX/0aQA7bIyDUIYKTtSIIWirJd1TTXbPih1fi6GcWkxq0Ixk+cliGI2GpS0Z34jzxprKT5uYwJo7F4Dp6TH/meqsrG6IeA28lpBf0eWFpiKkrQb0TPUmk16gLlVw2f8UxowzIUTJPJVEesAdKF/DuZ5nlLyvWOLEOa5M0zrwCejEDsBAgW9UWAsw0vzbpaaC0DKz5GpuxCllHL92NB/iLP7ShvjIgEK7ZvH6nf5vNx8UQoOzy5xF2jK/ta1jVWlDlJBVtIN4tpcHJOcMfMdynFWU1fyqJoppthIkJGqRk03pSTslX+
 G9zzIbQH
 v/WX36ezDxOuPJe+zYGh+JpabTit3aytmU0NBbxPFkBxNmx0/sfpNcM0zEFSWpSnItd1ZfsSjrxvrLLM4NFvd6JyHPASr3NpntGsyY/IkRYK6uUvL8waEi3N8Ae79PPKRi2aPwiHtQEV/Jseahkeg6+xkKvjD7C3d2jr21jZVZjdmlmhoFbx97QMraTkU8ChRP6DowgBFrjZeGpFn/VIh3V8xGc9BVOsZXnu2u3Z69ltt7PgoLLUWOLTFaqnKz7Fskyz1G6F8OyarqLQHauSqdXNcAaBSyJSHZRm1VjONlwRxQkIj6YzJS0aoeSgFMDKKXI8bAfwDKJIYku8kO0r95vCSWCUKrNRgKzGy2wbn/BPQxgpw2Hy2GVcTz599kx++5xM/FVDZuuoJvkAlqyOCAKUjolH+E/mLRwIX59QJhKgP9h7rSRcEn7zt5qGTSDTmljCvrNeqL+inbqI=
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

Changelog since v2:
- Reintroduced explicit module refcounting for file handlers from v1 to
  avoid problems during deserialization time and for overall simplicity.
- Simplified the locking model by consolidating luo_file_handler_lock,
  luo_flb_lock, and per-handler flb_lock into a single luo_register_rwlock,
  based on a suggestion from Samiullah Khawaja.
- Replaced scoped_guard() with explicit down/up lock calls in cases where
  goto is used for error handling, as suggested by Mike Rapoport.
- Also add to small hardening fixes: Synchronize lazy initialization of
  FLB private state and Safely print untrusted strings.

[1] https://lore.kernel.org/all/20260303210733.GG972761@nvidia.com
[2] https://lore.kernel.org/all/20260318141637.1870220-10-pasha.tatashin@soleen.com

Pasha Tatashin (10):
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

 include/linux/liveupdate.h       |  15 ++-
 kernel/liveupdate/luo_core.c     |   6 +
 kernel/liveupdate/luo_file.c     |  82 +++++---------
 kernel/liveupdate/luo_flb.c      | 182 ++++++++++++++++---------------
 kernel/liveupdate/luo_internal.h |   7 +-
 kernel/liveupdate/luo_session.c  |  46 +-------
 lib/tests/liveupdate.c           |  18 ---
 7 files changed, 142 insertions(+), 214 deletions(-)


base-commit: 4f1d805a97d6353e4ae468b08ca212641cd26f92
-- 
2.43.0


