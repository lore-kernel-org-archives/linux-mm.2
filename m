Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68C2CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 14:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2AA08E0084; Sat,  1 Nov 2025 10:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02658E0068; Sat,  1 Nov 2025 10:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1128E0084; Sat,  1 Nov 2025 10:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC4448E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 10:23:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6449A4A9A2
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:34 +0000 (UTC)
X-FDA: 84062256348.27.CBD4588
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9A210140014
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ipQkR+xT;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762007012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mjyYeFyfCt82d7aSwBTlmR33nET5fMThRpkyy8tjGGE=;
	b=k/S9i68rxdaVXMeJskk2i8vVw/gL/RF1q8mmyt4AKQDxxPUUTeau64mr+mBkbKOnf2NAfs
	h7AFdivjd8AzWxN+MV8bgboD23pykhJ92IPqgEQFWwGlP60QrE0gmuZP0X8BOhY4kf0URO
	tcAFuGh0a+XG0By6nW0kYJdsIySzAAw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ipQkR+xT;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762007012; a=rsa-sha256;
	cv=none;
	b=aXM/0r6e6IOkVcKGDEv1A+KNURN/laSJN7GEBh/CK5aePnkrZu9h7IYLNngGuDcqycwhla
	Vd3Nh1hsC+hrxs0JKDFroF1yewkgclfZW0Y5uXBb8MuRDSCu8I4p2RODApkX9okEpVsSL2
	F+uhedgEjEIpZSQFrhC4UzQKFyDpR0c=
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-93518a78d0aso1153787241.3
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 07:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762007011; x=1762611811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mjyYeFyfCt82d7aSwBTlmR33nET5fMThRpkyy8tjGGE=;
        b=ipQkR+xTuGnXUVhg6OH5OpqBlzXruNXy894cavdUOjuswQMMHWbBA2FAZTH/nvMl4k
         4stKovUNV2o8ATG6KIf1tyMqHWcZ8Kg90/jxFtvy4uby/PG6Gva4TrjIVa9mZQ+e21+I
         Q2o7F5jDw2dEiXdeGyzE0+vwgAEGT9CibW3WXSoUX7+jeH1/iDBNCZn1H0Y/P64veokn
         1UY0f9u8a2XMcOLHrbBJ4ZAzHExRSc59sgsBhpl53tQ+r8mBZEgmCXRUbIMAGYoGIecd
         YuwcT1irmNk2Cm5hpzXiIQYxI5QJrXZXnAELoJTfOpoSRaV1OXP+payLutXRDQ7ak5sq
         pSyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762007011; x=1762611811;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mjyYeFyfCt82d7aSwBTlmR33nET5fMThRpkyy8tjGGE=;
        b=hoorXbmVKMt8FJeSw2yjMoRdtWRdIgR1na6pVQiV2Vllk9qZmsnGFxilB+gnKk6j9G
         d5GnMTK9ysqHRlgK2fbZ2AYxF2qoGJENK5IE78EdQ6qBFITPQuamV0X90MhcMNukkJNK
         9K2Xwv0nJ1RpNXsXtns3yGceTDcWVoC5iEWVoxwvOz9UgniLgZzmPnzdwVhapAYaIEtI
         gA4pbOQi2NJR536ep17Ydnu7QUD2ga0WV1ccuIwXH2F5ZdYSQad9MDr4PAAOPa1RLNYJ
         vdLfTyIIsVAmDLokycJsMhwDN3NHQRSGecIcYaiRG2xJUwqFKo1alZGE7jDVS97GGEEo
         f7fg==
X-Forwarded-Encrypted: i=1; AJvYcCUcuvQwtQ2qQ6v76LyA81DNhpLyNzM/2kEoRJC+VWjUMzbuFYdMpp9ARBtrINFkxI/2SFzAl9lCUA==@kvack.org
X-Gm-Message-State: AOJu0YxhQpr1RzqcDxRIXxgsY0G9aGuX/2REciCAUCSZ/JADdOSgJ3gY
	akAq5w6AxbJq8iNAjozjhmv53DBmd9p+RisxoWfzdoVE+9JSShOOP943Tlg2RwVzPLw=
X-Gm-Gg: ASbGncsVbYNd85dMGn16qebiOxVFYW79ZEts+GzR3IKommjzK7KuIa28GQB3UbkxJ3W
	SHgQdqlj/0IhWcfXw6JFc95e5JxfNWXKsGpRiCHW3khZ+7hGElNLZdtvUHso2pVU4AgnT/9Ndso
	7OHTx5N8hsA4tsePwlKbsB/IWqPt4xnveRWKSRDi0R+xMUAHgyvJTZ2b9zWtsm18b/LiYwGsc7r
	7xRA9/jVeByt2J/TrbUaid8B8x0pPkAl3Dk5GIOIbgzJagKfk5LNEUIS3lFE5cmV/QBPZSTjGy+
	CwY1KL91KiVSQddTtFBcS0Uv1zOC67sjyHBBZb9BzjcXWDQNF/oMrLtxTFcmi2gTKb7646eIlt4
	IWNYT786bulT9Atknnr8u/aSz4iGCaB5o0MfjxWfLqVN55y38HjvBfIOxoZWoHknr/vdyzw+Rvj
	WREbH0Ha6fmpbJC1kiQiki4p+PFCY+DxNWIGhZey7DctMzoNBxu7O7Fm5CDVmOBt4Qc84oThSuV
	F3Z+Zx7hg==
X-Google-Smtp-Source: AGHT+IGBXiDtpLvwnOU1rUIvjzlWuqMrUwK4wBcxPPZuC+/U/6yYNYHC5t6couOoofEI67TRcbfb2w==
X-Received: by 2002:a05:6122:2a51:b0:556:9cb9:65c8 with SMTP id 71dfb90a1353d-5593e122cb4mr2859544e0c.0.1762007011445;
        Sat, 01 Nov 2025 07:23:31 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559449647e0sm1776242e0c.3.2025.11.01.07.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:23:30 -0700 (PDT)
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
	tj@kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v9 0/9] liveupdate: Rework KHO for in-kernel users
Date: Sat,  1 Nov 2025 10:23:16 -0400
Message-ID: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A210140014
X-Stat-Signature: 89cdkrhcdb9u3bc94k45ypy7q1be4c7g
X-Rspam-User: 
X-HE-Tag: 1762007012-614974
X-HE-Meta: U2FsdGVkX1+GJp0/jvmtGHpIRIaIzPzt+WRcQ3WF79DMY7PW0bseV9z0JhEJ9LwUk8+0Jp/zwdhgdI5zeA+k2pjkGEwXdqvyxIyW13WOBbZWT1dIU0yMomPBNi0UhvG9jO0rQHjfSiE6YEOxuWI5s/qvH2db4GSxLszVPtk9qsSCXP8SRjvl480fFQDc1AeE0nn2FcQZ7R7e6zOJ7uSnZRa1LXfWhgb6V0udDX78ZF000F5Xqo9eZdg/qbGAeQoHTLiU+P2/E6SMiageb5M0M20Y2flDVPaC+INxwbY5VGBNOBJBm84zPhWj7S5bEqtLVPZXDmRB6SjLDbbex2WrdE+Iar8ohyqh8OmK7NHXzN+4x/SeqeR1yPMnTxF7Em8A1B8VuM5zfU8vP9grSXJNB/y/+xLljfYL01wULlbhePwkytyYZeq5u/j5LsCF2EKJu9qbfGHnF3yaYf2sDLYqmg/hWCibLGxTgvRvc9qJSGzcrx+5L/HkryV2n0AzP0rvMUTK/Te/z/8/CzW/kTaG0MTsNmWxstu+kdZD0yEJOK2o0ga1tqRHgVz0IihDQaLD6Yr+ZxgdgEY/dW/EnIpDrLvyojq3XXPwu/Z21vQkY3NfCP0Ujm8zcuEDhgKc/rvFs3n5HZQfGQY3TAUK50SK0hDrx/HzdXIGuQAYW8jXT1vaPKDtAtAeheRHVuBOX2EXWnT5pcT3fXegSd1sQyfOWIxaVJJFNOCx7Guow7OdW7FZs+dLuG6luLlB2YPR/q4Nez/4C/QwxOwtCydjRQ8YopPvx3A3RajDiFL6nXvwSc4fsDGwO0KqFVcX6dVnJSy1XyT/UOSRM1N3d77SDatY4sd5+ytk026lJrkTCbH551LJzHhe525rWsUhMhsYFc45FykPBmgs4/oBJVeDJ97SO9y6I8C99n8WClZNrNbmsmgyrAQYMFKTRuvH+GswfbnhvKMY841h3WXdX7pZyDt
 lEPxVpDy
 oW6JKXiadFAi9LcBKnqr/avg8gqgzDvAo5BRkih9WmLLdrD3l/b1nfW6gME2j+zSXNdXAajJKUa8s3tUvCvzxrPXmYf9He2IR5OOrLiChD5pELipdubLI4Rwp6vS1UpSkx3Z6sZH+3Vi/nDRd3s8DpYTvIUYMZcZd75xEpB8SDEeZI7wj2NfiqEBITlQL8M6oMng6M04dqu1gwyjxeNwC0lWi9yqZbpxhqXDBrsJ0UGKljP65j3oZIAQErBjYTQ4odGyfFWWeVg10re7Bl+/2XqcARDFoj7Z1Gz4gbm+FjG3me0QuPg6QtnaxwjUdpBjumFKR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v9:
Added review-bys and addressed comments from Mike Rapoport and
Pratyush Yadav.
Dropped patch that moves abort/finalize to public header per Mike's
request.
Added patch from Zhu Yanjun to output errors by name.

This series appliyes against akpm's mm-unstable branch.

This series refactors the KHO framework to better support in-kernel
users like the upcoming LUO. The current design, which relies on a
notifier chain and debugfs for control, is too restrictive for direct
programmatic use.

The core of this rework is the removal of the notifier chain in favor of
a direct registration API. This decouples clients from the shutdown-time
finalization sequence, allowing them to manage their preserved state
more flexibly and at any time.

In support of this new model, this series also:
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
  kho: make debugfs interface optional
  kho: add interfaces to unpreserve folios, page ranges, and vmalloc
  memblock: Unpreserve memory in case of error
  test_kho: Unpreserve memory in case of error
  kho: don't unpreserve memory during abort
  liveupdate: kho: move to kernel/liveupdate
  MAINTAINERS: update KHO maintainers

Zhu Yanjun (1):
  liveupdate: kho: Use %pe format specifier for error pointer printing

 Documentation/core-api/kho/concepts.rst       |   2 +-
 MAINTAINERS                                   |   4 +-
 include/linux/kexec_handover.h                |  46 +-
 init/Kconfig                                  |   2 +
 kernel/Kconfig.kexec                          |  24 -
 kernel/Makefile                               |   3 +-
 kernel/kexec_handover_internal.h              |  16 -
 kernel/liveupdate/Kconfig                     |  39 ++
 kernel/liveupdate/Makefile                    |   5 +
 kernel/{ => liveupdate}/kexec_handover.c      | 532 +++++++-----------
 .../{ => liveupdate}/kexec_handover_debug.c   |   0
 kernel/liveupdate/kexec_handover_debugfs.c    | 221 ++++++++
 kernel/liveupdate/kexec_handover_internal.h   |  56 ++
 lib/test_kho.c                                | 128 +++--
 mm/memblock.c                                 |  93 +--
 tools/testing/selftests/kho/vmtest.sh         |   1 +
 16 files changed, 690 insertions(+), 482 deletions(-)
 delete mode 100644 kernel/kexec_handover_internal.h
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (80%)
 rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
 create mode 100644 kernel/liveupdate/kexec_handover_debugfs.c
 create mode 100644 kernel/liveupdate/kexec_handover_internal.h


base-commit: 9ef7b034116354ee75502d1849280a4d2ff98a7c
-- 
2.51.1.930.gacf6e81ea2-goog


