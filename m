Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B87BCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2488E0042; Fri, 24 Oct 2025 12:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86CF88E00C9; Fri, 24 Oct 2025 12:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734C48E0042; Fri, 24 Oct 2025 12:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 613E88E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2341613C408
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:08 +0000 (UTC)
X-FDA: 84033494496.09.8B22C58
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A1004000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=keOToSFT;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322206; a=rsa-sha256;
	cv=none;
	b=bpAdczaHolW2+UNqzgh0KNmmJfz3LCoR6V86nU4GmEBXGCoo5ikUqH7Su3xXJJHzNht36w
	GwxWf9zJuuQyB08W/iWULLVaG6gnIMEqEOCOQpOqVcCUIqNRamubmJsKvEUiKmSzriooJz
	GlJuwWypD4PkubnqBpBvWLI1gxevcms=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=keOToSFT;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5lJRZHIBr4l8hQ14h2r8Jc1C5VceV8EYA0FrZUk2otA=;
	b=RlJW0YdfW+prYMQhtis5PvAneNmnqVA7BWMrfRBroIkgwSX4017hJ0zGoYYBcLTJyfy8Jf
	qLN3JFkW/2pTcKgOGdnsr5gpXXFtpKXaD+t+SX5/NpR7MRn7O9YJ5N7jST/+WVoGIUKr4d
	zJiIGl4piOY5HcF9TmGyZat+u2HcWMs=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-78485c4146bso25274357b3.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322205; x=1761927005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5lJRZHIBr4l8hQ14h2r8Jc1C5VceV8EYA0FrZUk2otA=;
        b=keOToSFTVM5+qhFu3EbMl40hZ3YMX5+kfcLI3leDmLpkzoD49vRJCLm57L1r5S6gtG
         ap5U+kQiA8A11ntlbWWzWhHK0u4oslCOEGwlwtGCOOJYQotEuW8v5e8gxD3lrNYPkRiW
         UYOWphCDWpi9Tj16n7tvoYSqZWh5MpTp590w78OcIQkUZIm4HwtSf4pLEhvClQDujSn1
         oTwkNlmD8FmeNvYh/VzA19SwHLYwfzTH1r2bG9wc0gHUx9x/kdvDyT+Lg4i6yjMK3JGN
         MNCxnaxyKeqZ7rBlpnLqDTlLsWuppEVW30vVbksYiyH5kfwZpeYa7VbPF6qm++MmEDUz
         49XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322205; x=1761927005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lJRZHIBr4l8hQ14h2r8Jc1C5VceV8EYA0FrZUk2otA=;
        b=A9H9sTQ399dmsvudOfrOZQYuoIFwVHMAXDBtwdMOSE79RySvHHn3/NkOJt3A3tDUA5
         KJOH9UDR1FQk9kRe5MzcOg9zGnTLTT19Q8H38szAtCaGAwHOc2rHDUGZaIWhIkWTg5n5
         nNWXGrICLJclUDIrdZtAYasRwiz83gBN077E4OnKjlyqpcbpjUiUXOUz9V7vhJBzQYrg
         e239hIXEC4ybu0xjWViXDPpXmjqNwmdRcSk+v3QOPupVzuyQYNcuPjNzPX7sYqS7Afa4
         s5SmXO44oeSvJW3fOoDI0BJZfiQlblb2tfPLrHapy0RC5YOd+AXg08sSVOf/pnUDMvM5
         OmZw==
X-Forwarded-Encrypted: i=1; AJvYcCWnJIeyasuym4yslqAKqkA9Ev+x5HlDbEd84hxMD2PV4BiH+4ltpZxf/ofQK/tWWVp/8Or0BatmAw==@kvack.org
X-Gm-Message-State: AOJu0YwCyUHDX/zHjmluQtuohLrvDINKUoWcmXwIMwvSfxmmHdOaY+Ga
	uFTOOK//NdVciyj4ddsdZdKWNvl/QqwpnDmt/a37Shv1BLFdIlJBM4RaA6gSwnX78Zc=
X-Gm-Gg: ASbGncuHzNQr5Iikw7I+qbrT4yAstgmsSYxSfcYPUIz86ElB8TA+2/HuzvOIlUHrYe1
	G99JPjU3r7IdMiq/h6sUzkUWRJmCbYnIEJP6KX3Z9TdFHRsytySqBi+enRejPap3urNb9ZpEsrK
	KjYZcZ8GMRJPd1vE8TWCtMVBhlqDiOdsmG5a7bp8I1/YzlAxTAKH9UpR5Bp3Tg2e3f7gpFucQu9
	xn5UsM5uLHu4yuCfOqtQsQXmynIba5Q0lWF8ypy6+8ZgECpqlhWkr8SJOEhkIKxvz/ISw2xkEzA
	rpf9zl2wVbg6N+YPpf5ZUAvv78nvI/upvpERx18cnwIcZDPSOIOdxZvHnkTvSeVQgWd3x6oHPFl
	jemKvY3f0k6rPBITQhp+kVWnOhIoFzhAMnmhrg9/w0ubPfxp3nW1GKRolTaABUBkiSD9qonXlE3
	MO30jSqIWos4tYEGj0rQnzdDinVHv3V6vbEQlviDTNc7cFvAqoxEGfKzJ/i+0aPjShFGyPfsvB4
	JADmb3LUdsAd6xwX0IpAINgDJFoWiigbQ==
X-Google-Smtp-Source: AGHT+IFbczexsGZdw5sv2+pG+AP8WrRH85zQQI+6zaXO2pY5DBaHCIdJeZqqgPLE5H36FmMsaKUogg==
X-Received: by 2002:a05:690c:4c09:b0:780:be5b:3435 with SMTP id 00721157ae682-785e01f9ce3mr23044217b3.44.1761322203852;
        Fri, 24 Oct 2025 09:10:03 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785cd6edd87sm14099197b3.51.2025.10.24.09.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:10:03 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCH v8 0/8] liveupdate: Rework KHO for in-kernel users
Date: Fri, 24 Oct 2025 12:09:54 -0400
Message-ID: <20251024161002.747372-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A1004000C
X-Stat-Signature: dzyqhpzt8raoetrsdbnsaddir55nfean
X-HE-Tag: 1761322206-390721
X-HE-Meta: U2FsdGVkX1+x+HHe5Y0P/tVG3062zbtcs1wZLUGu3UcjA3JQivY6S+t74Smu/tOsk1U4Ac0jdfQdeBmcstEhcutVou3KcpvH4NuQGMxh8h0iEL9fDW0BPZ44p1ydog4+c7BH3a02kKZaJdvKYWJkFFxLUvrc8K9+DiblT5Czo81jjzR9/uqZvMxXTau/EAeUUFfub1s0vWo2v9P3+aBOQsw31aN/R8kxOsyQlIuEyZW+44x93FBM3uda2EDgwIVsqkv91kh4mVt4nZOLIq74s0aEgSJQI/8k3SMOi2gYY/rkX6rMEfAVOtBAfJAUBu+1YIAOkGUUYEgSnkiJmN7WIEpzy6zGcKvyW1DD92dplAyGznpwwAkaAMgK6/Nzva0iMtl3ZIZyti+iNntoKpTGfTreE9HILM85DH8L+Qfg4hbWzk0XlMBBubdmmrRo049gXNAuopi3JJXqZMWIo+9vIAFksTWo2/8xapu+S/jlfZonHhGLfz0R1WhLcminMTqap8SbH3QF6ELaLbV5DPc0igWlYZ3J3+YrAi2O7CZ7+e0dGrr0w9U/lsbOMXyGdAvQi53VKqAgELXqUeLr8oUADiwJOM+aPnc4g8p2BQH+nXhLw0c+ssmz95/caVK1zp/Q/Mjj1m3iyaVP7KonoFniceXyBcgpEvxdQ5AGPCNq17q2wZHgljGPiSbJHkV6FwOfH1visKIOtzRqLooCKfEMl2LeP4Nk5BZgBXgaKiC3WBTyjDqamzMK2XBizJOvwiYkUql1rrH2jhOXwBA0IAO5+jT3b6TjZKE7p+yY/x9c9jdf6G27kOq70tGHtdHPUi+JNDA2Chj1KsR8txcHnsiJ/6dYnpt0ceHharpU36zmCq4rQ/zPcVxVZvoWpnBpYe5ZI3s5b5Tpe0PWrF+o0CeZgpXTkazX3fcU8MCgmPM8At5WqthHuK2XjqldqT3W1etEW7vmmsrWo0U+KB4VgOh
 CPS/REx5
 I3TmOvGGPNsil9YBiAR68oKaiLkPVw9CIJWedFCX7+eXoZxcQ2NyzBtnebpSJy4Z6+RCPhAv16pjnflS83TvEFXuaGVhUgNhrLLkRc9ZZMlwE6b0Of/ibW098HSc9n0TRMx3ojBMsoVodfErBlV+wojUbt3JpwHX0nMZFfc3ZwqPIGvzLLdo2BGqA0qOvWa0Zu+df7FvyZBHOWLrfNeBcRHpXCxdlZQp1Jle9UjrERveKsqHhVSOVF4u7reRVMPGj0LNpOmci6uqdnJ8fxUxbk7rH2w4M/HyFy+B82qtt3ZhjcEfMsD2GiWVY+Wx4ZIOP8dk3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v8:
Added review-bys and addressed comments from Mike Rapoport and
Pratyush Yadav.
Added "memblock: Unpreserve memory in case of error" to handle
rollback if preserve fails half way through.

This series refactors the KHO framework to better support in-kernel
users like the upcoming LUO. The current design, which relies on a
notifier chain and debugfs for control, is too restrictive for direct
programmatic use.

The core of this rework is the removal of the notifier chain in favor of
a direct registration API. This decouples clients from the shutdown-time
finalization sequence, allowing them to manage their preserved state
more flexibly and at any time.

In support of this new model, this series also:
 - Exports kho_finalize() and kho_abort() for programmatic control.
 - Makes the debugfs interface optional.
 - Introduces APIs to unpreserve memory and fixes a bug in the abort
   path where client state was being incorrectly discarded. Note that
   this is an interim step, as a more comprehensive fix is planned as
   part of the stateless KHO work [1].
 - Moves all KHO code into a new kernel/liveupdate/ directory to
   consolidate live update components.

[1] https://lore.kernel.org/all/20251020100306.2709352-1-jasonmiu@google.com

Mike Rapoport (Microsoft) (1):
  kho: drop notifiers

Pasha Tatashin (7):
  kho: allow to drive kho from within kernel
  kho: make debugfs interface optional
  kho: add interfaces to unpreserve folios and page ranges
  kho: don't unpreserve memory during abort
  liveupdate: kho: move to kernel/liveupdate
  liveupdate: kho: move kho debugfs directory to liveupdate
  memblock: Unpreserve memory in case of error

 Documentation/core-api/kho/concepts.rst       |   2 +-
 MAINTAINERS                                   |   3 +-
 include/linux/kexec_handover.h                |  53 +-
 init/Kconfig                                  |   2 +
 kernel/Kconfig.kexec                          |  24 -
 kernel/Makefile                               |   3 +-
 kernel/kexec_handover_internal.h              |  16 -
 kernel/liveupdate/Kconfig                     |  39 ++
 kernel/liveupdate/Makefile                    |   5 +
 kernel/{ => liveupdate}/kexec_handover.c      | 508 +++++++-----------
 .../{ => liveupdate}/kexec_handover_debug.c   |   0
 kernel/liveupdate/kexec_handover_debugfs.c    | 219 ++++++++
 kernel/liveupdate/kexec_handover_internal.h   |  56 ++
 lib/test_kho.c                                |  33 +-
 mm/memblock.c                                 |  82 ++-
 tools/testing/selftests/kho/init.c            |   2 +-
 tools/testing/selftests/kho/vmtest.sh         |   1 +
 17 files changed, 590 insertions(+), 458 deletions(-)
 delete mode 100644 kernel/kexec_handover_internal.h
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (80%)
 rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
 create mode 100644 kernel/liveupdate/kexec_handover_debugfs.c
 create mode 100644 kernel/liveupdate/kexec_handover_internal.h


base-commit: 72fb0170ef1f45addf726319c52a0562b6913707
-- 
2.51.1.821.gb6fe4d2222-goog


