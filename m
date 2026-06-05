Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F85CD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53116B0005; Thu,  4 Jun 2026 23:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04756B0088; Thu,  4 Jun 2026 23:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F32A6B008A; Thu,  4 Jun 2026 23:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7916B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:32:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 139B640A17
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:32:40 +0000 (UTC)
X-FDA: 84844436880.07.FE48515
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4FECBC000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:32:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bItySVAE;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iv2aPKIPLb4egTBCESQqff8jQhyqWNFkX14M23BwCsY=;
	b=26n7pOLWXc4gzi/5C3wvX83Kt+fcrbeu1GZj1prM2SU5xv9M4K3W1Lf/0cqL48cMaQdOWL
	02oKtBCTIPukDQj/X+vcbtlRXiEJ6pwxqz6sXw5u0WIeDNOeOCrpkRY9818v2s/rjSqKF0
	zjbEtFdTmJaoUeXjIuC6y0ze6H7ZS4M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bItySVAE;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630358;
	b=TJIA6ZUghJ9ATe2dvceAtkX4OdxIxO86erWYV7h/m30N6ZRQpR3Qqn6+x6s6pbR8I6hfvY
	zldwbrN78CcuxldYUP7QVfSuvZI7sKTbd0plpRo/fhTq5lS8w4A1ZFg0vPLujijf5cOyj/
	g3yK+rxuyA0+qnD3Ry4ld2EzBQnwTLA=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ccdf8d4ac5so16091226d6.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630357; x=1781235157; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=iv2aPKIPLb4egTBCESQqff8jQhyqWNFkX14M23BwCsY=;
        b=bItySVAEUYlC4gsK7okr12EsEioX98AhJH4R2OUMgVQcWaaUvaNEilsqaqOjPmurRx
         ngtodwIFtK30THfFRiOOLj0oNY3rLgBCc9qkVyEkdSGwmbtnpDH4utQ+Hc+KatwYvLFu
         2czf0PQ/pz76fNRloWxnUaowvS9bO00yO1bqWs4ECLAPH/QJMpoTGtL+tqayoV7yIAcS
         78/TRRK0qDr1W33cAZmnRaumqoaRgJbqBDg5kZZwIZsq7EQdcuxPiRWC4RPbZg6Tds/7
         +vZ9vUARqVIYIS0+QXRlRg/cmNccyI/YvWs/dEn0dkF5Ua6TZZPCM8Z0XlcfqW8rhmVz
         Wuhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630357; x=1781235157;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iv2aPKIPLb4egTBCESQqff8jQhyqWNFkX14M23BwCsY=;
        b=keIjPOJzPKsNb5XokBOcreEPczOPK8V310S91FKPcKJpBpSAPrKjC/Ji202W9hM+lL
         0LOSMksmc8Nojm0QsrSCNIgZ1tOTrjwS9nz2cQ/P8/htbQyQY30ii0WcK2wvmssYGyVY
         v2HDPTPB+zJZJQhpEPX9rpWY5c1XyQ/WGPV9XRjYag3O2C0V5X0T6ALBX17a5sYNd1Yb
         uAd0GuduC22oTE4kj8v2WrsFFSeAI2mYgEyrvfaEVuJJOGxEz4hG1iKWDTyUqVxWkLWG
         bjVEZRBiM13sK+vk2wUnH3viZhcV9i4egH66Fa5eJX9xsuwvX6ktnLrYT1eqAZ3oTBOh
         zRCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+EZluUyHl9qgoliHiI3kNoA8+lzymgzYDyUmVRTNzkujGi1XAQvPO9OhgULyc6phhGE2+U/zAJlA==@kvack.org
X-Gm-Message-State: AOJu0YxQX8SY1yjPQku7WNpnVepSYfbyJYsZq998R+lfYvusAUmC7szW
	H9tt6WCPCOsMz/WIge9h2V+5+G+8a+nvAplmJeLDLIZIW/0I3AfSwwbh+GvD91WyfBc=
X-Gm-Gg: Acq92OGkR83wXFkovVAfLm+A57b1gJlBvIAPYggWft/AbaoG8OfJ8+N4cz7oarvZRtr
	wFjbQWny9F9tKuuRBXaWmv4tKxxiJlYMeBtv0R1X3kigEwE2EE2khSzzMJVomo/yxABDvcs0ana
	76oD6KSXGW2EWlz1cd83H6EhgLiTJLFNpOLxJtn1Q6yzRqjphEKqX5nQCIKRss3nwMlfM9cgf9P
	/EFkRxdJDXYYHn0PM28TjA0kqMm7favQRZ9MQAluqHAz0xekZ9dra6+ea1rbRgbjnixHn9RO8NK
	zTtuQwpuTsoobuq1nIxIWGwJ8v36XKsici+A3v3n5O43fhDkFPTG7253u1F0SjfoTnyzXo3QM5n
	TRUGc5VeqWYlVvn3WI25ZqYsvTBRrGNE4hFjbQPZxZcO6RhPXEbixDjWw+XmK7UXngn0hJkFEgh
	GRZKpqu/leP4DmGDpYVFi6nJob6TEL/Jzx7tNTwIMvF0G92X4Y2OR8nIkmpmh8lNSqWcx7RQEa
X-Received: by 2002:ac8:4809:0:b0:517:905d:dc78 with SMTP id d75a77b69052e-51795bbf697mr17436291cf.37.1780630357252;
        Thu, 04 Jun 2026 20:32:37 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd053210sm69052176d6.26.2026.06.04.20.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:32:36 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 0/9] kho: granular compatibility and header decoupling
Date: Fri,  5 Jun 2026 03:32:26 +0000
Message-ID: <20260605033235.717351-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4FECBC000A
X-Stat-Signature: 3nrg9aeiysj5twngpqn5q5z5ffwjdfrj
X-Rspam-User: 
X-HE-Tag: 1780630358-100069
X-HE-Meta: U2FsdGVkX18uF9QzYEY7kyTbgIGYFCeHUw8n9HXYydz3M57nCvmB4IgsaZS/PexmFKqMrvZpSd2zRfuBWlDmbaAFHHywsV5CDXjgbmFPVhkHuZXbeG3lJvWYvB+6MxLkVg7RHIoYK8ox+Qa0Q9R0MmDH8vsQubNv7YjQp4lBjzlDhucVMA2usf2BMq6os1PZm7eGInkdNBDibNKXnzTBf3VS3nVgYoc8EcCUyMJb9zbYdrKS8upHDY7JpBp6A9UKacf4fKpdemDtB2tsAleiRyliebfUb6KpBCANBlbBjEvEdn8b/TcIWACxvElCKol8F4ZjKcE8n+4QVgGXQDETjWLiO8HH/junQ18S+sg+uXhSPDC0v806w44RroplNWqpCu8aKUXIC6fgDCxkzBWt/wZ1r3L7f+Y7f0NQaVvTIpCH3bxgDmwGH4H8AM/d8w4KHWZ0Zvl0xrwxqfynBdrQQVmdSGdNyhv65Hhh5MBr+A4gaj8IpcMMWJF4FbNuuV+BaghQoT8ZiPylVHQ75s+UO7fm7D0GRLkD1lv9EhOB7M0CYtF0cP9ujzTD0JcJa5umPf3oZF2f9/hL7UnqwHa6VSxF3uGu7akWeGFfDNJJA9ThxWC/Epm0kLKZOZ5OJrWNOw0oQsrGe+LoNTDCtdnXQrK8hn+jeeEib/Qvyp73NreX3ley7X8VuX9QnP9qStfJ8EzfgmTCyLCi72uvFY4FcN1ULNCbEJsrgva2eF8oVDgK7hbGJv+x6j7/SAXtmk2/T/rLrBVCl6dpFUDk9OOKMhF1CTXceZYkAOr0bSQ+Rt9/xnLS1JdsgNeyU/ZcLgepG69qrUQtct/HiZ1PvzZOLkJYVf2fOw9Q0UvllvocM9PA7WAW1iwhB4u3NlK7mEQgct/vZyjxjFn8C98XjFcDSIjlDE9ZAZxf3oARrYtgH2q956Va+w81PJv8tUoD0aht59FGc0R+ZozCMEdMk72
 YEo7Px4B
 gDftuJUmLxZb7NZelrRe5KtIxEz426Z9tYZAB6m69UkTFR3PxXkdLrUxWtfI19H69JeBxQYKn8DZrye4ZiO2bZYBjf09xvu7o4wSUkErzFDyiXUnWAIW/4T4/066quADg5lCGLcaCBqpEuJ5rRNIJKEpEgUWmk3nz7REpTX+ZE8+Rh2M+Ms+geGMuaC7YR9JXHuQtWasN/36IL82aEIhIgTdr5UGZ/69/C2fDyVeSaeRBuC1eopvDAzracBvNBopeKXLLtl6kau9fcB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series decouples the compatibility tracking and code organization
of individual KHO subsystems (radix tree, vmalloc, and block device).

The diff here is a bit larger than I'd like, but most of it is just
refactoring and moving code around to modularize the subsystems rather
than functional changes.

Specifically, this series separates KHO data structures from KHO
core functionality:
- KHO data structures are those that have ABI checks between kernel
  versions (e.g., vmalloc, radix trees, and block devices).
- KHO core is the functionality that involves passing the memory
  from one kernel to another.

KHO core depends on some of these data structures, but other users
of KHO also depend on them. The number of data structures keeps
growing: first we introduced vmalloc, then radix trees, then
linked blocks, and next we are planning to add an xarray-like
data structure. Keeping all of this within the same `kexec_handover.c`
file, and also under the same global version, is no longer sustainable.

To address this, this series:
1. Refactors and reorganizes the code by splitting out radix tree
   and vmalloc into separate files.
2. Moves and organizes internal and ABI headers into structured
   directories under include/linux/kho/ and include/linux/kho/abi/.
   Instead of cluttering include/linux/ with prefix-styled headers like
   kho_block.h or kho_radix_tree.h, we use the already existing
   include/linux/kho/ directory (e.g., kho/block.h and
   kho/radix_tree.h).
3. Introduces a standard set of compatibility helpers in
   kho/abi/compat.h.
4. Decouples the compatibility strings of individual KHO subsystems
   (radix tree, vmalloc, and block) from the global KHO version.
   This enables independent, granular compatibility versioning.
5. Adds a KUnit test suite to verify that the composite compatibility
   strings of different subsystems remain unique and sorted in
   alphabetical order, guaranteeing a consistent and predictable
   representation across configurations.

This series is to gather feedback on the overall design and layout
of the granular compatibility mechanism.

Pasha Tatashin (9):
  kho: split out radix tree tracker into kho_radix.c
  kho: split radix tree headers out of kexec_handover.h
  kho: split out vmalloc preservation into kho_vmalloc.c
  kho: split vmalloc headers out of kexec_handover.h
  kho: move kho_block.h to kho/block.h
  kho: introduce compatibility helpers and decouple block version
  kho: decouple radix tree compatibility from global KHO version
  kho: decouple vmalloc compatibility from global KHO version and update
    memfd
  liveupdate: add KUnit test to verify alphabetical order of
    compatibility strings

 Documentation/core-api/kho/abi.rst            |  11 +-
 Documentation/core-api/kho/index.rst          |  10 +-
 MAINTAINERS                                   |   1 -
 include/linux/kexec_handover.h                |  18 -
 include/linux/kho/abi/block.h                 |   4 +-
 include/linux/kho/abi/compat.h                |  33 ++
 include/linux/kho/abi/kexec_handover.h        | 203 +------
 include/linux/kho/abi/luo.h                   |   8 +-
 include/linux/kho/abi/memfd.h                 |  12 +-
 include/linux/kho/abi/radix_tree.h            | 133 +++++
 include/linux/kho/abi/vmalloc.h               | 101 ++++
 include/linux/{kho_block.h => kho/block.h}    |   2 +-
 .../{kho_radix_tree.h => kho/radix_tree.h}    |   5 +-
 include/linux/kho/vmalloc.h                   |  34 ++
 kernel/liveupdate/Kconfig                     |  15 +
 kernel/liveupdate/Makefile                    |   9 +-
 kernel/liveupdate/kexec_handover.c            | 531 +-----------------
 kernel/liveupdate/kho_block.c                 |   2 +-
 kernel/liveupdate/kho_radix.c                 | 290 ++++++++++
 kernel/liveupdate/kho_vmalloc.c               | 274 +++++++++
 kernel/liveupdate/liveupdate_test.c           |  56 ++
 kernel/liveupdate/luo_internal.h              |   2 +-
 kernel/liveupdate/luo_session.c               |   2 +-
 lib/test_kho.c                                |   1 +
 mm/memfd_luo.c                                |   1 +
 tools/testing/selftests/liveupdate/config     |   1 +
 26 files changed, 997 insertions(+), 762 deletions(-)
 create mode 100644 include/linux/kho/abi/compat.h
 create mode 100644 include/linux/kho/abi/radix_tree.h
 create mode 100644 include/linux/kho/abi/vmalloc.h
 rename include/linux/{kho_block.h => kho/block.h} (100%)
 rename include/linux/{kho_radix_tree.h => kho/radix_tree.h} (96%)
 create mode 100644 include/linux/kho/vmalloc.h
 create mode 100644 kernel/liveupdate/kho_radix.c
 create mode 100644 kernel/liveupdate/kho_vmalloc.c
 create mode 100644 kernel/liveupdate/liveupdate_test.c


base-commit: 5fb813ae0009d97fc414f08ad73286f562e9a123
-- 
2.53.0


