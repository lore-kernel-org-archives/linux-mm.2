Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C72CCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263138E0007; Tue, 21 Oct 2025 20:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A3E8E0002; Tue, 21 Oct 2025 20:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177358E0007; Tue, 21 Oct 2025 20:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08E678E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95E7211AB38
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:23 +0000 (UTC)
X-FDA: 84023936766.19.3D9B67E
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id D83B740008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QYcRfZIE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V6rRIjCz5N1D5Ed0cxws3QbJ+B4MJ09ZUi0KecBqWPM=;
	b=IPG8dIdfMApFImd8cSFw0lFMqVhmf8w3AKYQbflM1L0ZeLyRmsPrzSyKWJ3WgjDhPiRBKW
	3I7gysjA0RZmy14zUygf32b8AKxDYD7yG6xgtPA1uzMWMwEsQ5zbOTmoqpc8k+SbsnQVTz
	axuC5N7OKontr+fvCdT9DtdIn60Yo4M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QYcRfZIE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094641; a=rsa-sha256;
	cv=none;
	b=aCZxXaFCzRId50xPrFLBCw7BCzfmyUoVj5fpUOlUEnXbMkBZ6eHYYCHzM9pwkDmVEWejkB
	B6ueBUxQxfNkq+rAC0BAi/QOlt2LGhNY12tXsQCoK/W7Wd97G2/R/0ATkmtxULaVJRCv8z
	hf5SMaOPullayAybMKqp5z7/ROPWiAc=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4e8b4e4ce70so6032501cf.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761094641; x=1761699441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=V6rRIjCz5N1D5Ed0cxws3QbJ+B4MJ09ZUi0KecBqWPM=;
        b=QYcRfZIEWXKnhBXHx0sSEKmYgaiK1KQYOIGLT5fbIWo6Jjz6Y1V2Hh5ClrXi4lHGIg
         fiWtYuU3eE1s2x0mHYPSR1lchTnUQntUiABB4mTgQauwibPLQU6yaxvK5WXicjWV4YkF
         18M+oPygpRbuzDJmS5olFnQW2Eiysw0sU+UJ7Oj7lx4J0VD5CsTtrqs5+ydBqqMHZGFU
         RGm/EvgwilBVYJujRyrsGV+a9uCLUce6CW29ZMCFKbI5yvEA761PD54RvF02GMYCdp4C
         5XRj51fOwsmYqKIixbPMe79XLrv6refIftX99pKIqQ7yIy/lpRBEpBZGi3T8T2Y9hktk
         YkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761094641; x=1761699441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V6rRIjCz5N1D5Ed0cxws3QbJ+B4MJ09ZUi0KecBqWPM=;
        b=Fr7eKprWhPSWt2dcQAHJIahdhF0+VPKdjm2de1BfcyzP72sZh4rBynqGP9pAd5mDZZ
         4B/e7vlYRhpeif0V+YGitF4prqnyb9M2/yygEz1yX51Ym49wHkf4LSbLXjkTHpU+JROi
         lmG7FDCM2rCGoSFCOnHzl+9ywi8KZpRbDuMSWzHv4n19bVE3jfumxPg9RjAoUaxuI6dd
         4U5/5oy+HYVD4pX0XWyLZVpB3197rZXfj+86EdwTxTUgbpGhQ6WhU7wH7J4uKlaLpW0i
         xz0BdI2aG3pEIkqfbM2HBG7iHARTTmtrIzR8LPF+yzoMQQm3pVHGhJbSDx+yuJogkVAd
         tbzw==
X-Forwarded-Encrypted: i=1; AJvYcCUCB75+VRLa6XJpdPc5SlcCNl1iKOFfIKnhX7cCRnyccmSqpn/TVvA27hefreu7gXMnbAlV93YTHw==@kvack.org
X-Gm-Message-State: AOJu0YzY0yBposMOOaj+WQSdtqEQQ6QJIf5FC7LsfzamWELCmwdaga2V
	t0ljtejgVzydAkxfW5qhZSfGLGq2grzI6R2C/5cTzmrn74crk7mayU2/a0hSu4Rp67s=
X-Gm-Gg: ASbGncsq3TQJGMJ1Mgw5s1bkb1rJch0mU41l3rdLbQvesscNzrKQIC71iBHG5MU/ieY
	pYAGsV/VOkcbDg7ykQtWlXkfS0cMJJxiMuswjrhmzXE9kpUH4udMLTZUcd3LpL/zsn1CvaALNc2
	4yH22MzG028VQKcGb0/LqCXN2Qe00qzUrM/1SfL4bPhPB6xHCva+eBJKNIQtNRwH30EWXJUF8qq
	rrorb1Bp0Epww9r4eM5mFlU0bPlnA5S7u8b6Yt5aWNOFTLo7OtA/w/kLZ3uYrLhE9oJDBhAB9L4
	C479oHEJSYRRVuNwBjmBiWRpUWku58PlaiVf5E9jQkiDw+qMVMysfTFr5IXDYwLGfFhWeRQhkry
	lgJ2YbThn2Lm3YALpP6K5+QAuvicfQQ3NhKFjQjNN5drbOSgB8YFPBF/TryAfYUrPzrwNckhWP/
	cxMEBK50PsZjamJAeHAM3UAjVVzdj/icnJNkQkwDMOFJ1jMnSyKWehwVHl8m91UMALLedyCRkY0
	LocCfeBx3iCoGKZ1xgJkziUCB5Fm+g5
X-Google-Smtp-Source: AGHT+IEIQnd/1fvDkk54xuNCdb61dv8JtlPct/U8dUFU7qNizs881GaUOM4iAn8ujhSbADE1PGNtYg==
X-Received: by 2002:ac8:58ce:0:b0:4e8:96ed:2e63 with SMTP id d75a77b69052e-4e89d2bb2f9mr209505651cf.34.1761094640840;
        Tue, 21 Oct 2025 17:57:20 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf3432dsm84169501cf.2.2025.10.21.17.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 17:57:20 -0700 (PDT)
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
Subject: [PATCHv7 0/7] liveupdate: Rework KHO for in-kernel users
Date: Tue, 21 Oct 2025 20:57:12 -0400
Message-ID: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D83B740008
X-Rspamd-Server: rspam03
X-Stat-Signature: pcpwfmxdfaga93uhawbcaouzpesy9jx8
X-HE-Tag: 1761094641-614088
X-HE-Meta: U2FsdGVkX1/3d/qoEoXiMtCQ2QpslYg/WzFnIQ3pD25vSbV/4n4QSIdK+urdtK6gd+W+ZhUdgB/n1L150DF4Rl0spx3AIp82R0Oto/mTxKO8yWA8aotM+RD86Kk+nkivugRfaV/56X2e8YB8hhLBK8QFx53rnnqwiqtvsrLHAjkZ0qvfRTtTiALTsk8OS3ydrUgAS03MbOmlGyYBXDIR1Itlt5JJmUw00egRoxn2JhDklPko9O97dtNtGeMyGM1dxGVvSIlJJxjovQ/AnQNA14aEGkLfATNWS5VHyTL2jup4cMQ/fJTvoEbwnDSw6iSriX6r0EBZr0HQ2cuCoO1o5VZINzp2uY4Nqjyzfpzra9hrpV9nz/w1X1Cxa/AxfojVnjGiNXkfpt+seDQ2UeV3KekmLYYk8+GWi8eyGwi8fuBgbmcgTYScvUF45b9Fkc8+qr4jYhVXoKLL/2JUKH/yEvCSlJG5FIQr0S160NGbDbCMfy/Sd8UKTMGBBKsqcT3r8D/Tj5iFZ7BfutCHwNNG+YEV9H9Ji8AHK5gWMm3gZHh7qyZtpYqP3y8XuMA/31H8uH+Q6XCua3sUbjFsYT/dPAzKaYfitQbn9BGqZeqaz8iX+eoBuJFeJ0WgIWzwiFUwlbk/+C2FNAbZfwd10CvH1HNCGr7U8dKVmaJVnVqfGc4cOu9JmlCfgA8urLK/ZJOmHDQmOLB+8aYrpO2L6FoSd/TGpx/BMkIGqf25P9TKnVEjTX2nSSwnugn+qKuU59C9hUibP8zDkPqKg5sdJniMgEt3L36EgINAvsira33WTMzK7shDUVaRVh83eBIzGV4EM/zTFTZs3eC3BBCsHF/YPfm9k4meUcw0xezTaJfLqbkCaCnTLOZyH7ADjUADTnKQRDrV5JhQij1AtsoV6U5ezCH+Iks6uE7XeskNhUBVw6AtXNCEs/BB8vS6E1s8LjP8MY2lTEW95GE5bM00y0m
 Q7+RICCm
 K6Yspar1oMyP2xTKAnSa3aVKAlWL3LxWTEGim+ZTAn7PrhpYADj5KNlbXf2PuAh/VOTzx01jdQPqSEXH71/UTO8GqgGDzZl97Hg1Fs6b2K3+a8zYQaR7QqyLFjqhhfWqmTtoV81VpKadQ6lqws5cU/vH1ufwO08bsKbKeDaILZu607u6lLsM/SdbTHCgS7akAuxeuXVt9GOgfrXnAHqSx4E0gicsEMGOfDdbINMiftWTMXGh9XuhqV4Xtl6WYnmwZKHANnXUkruJ/JRel011D08dskLdZu3yE/WBzBjqTfAYFRqcsPge2aU07MPOjrzHOip64Jyz8YTQDGgu/p5vxOqDfxhEHT3NN1PqWB38/gGmLKTbXenDZ0yX+1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These patches are taken from the LUOv4 series [1] and address recent
comments from Pratyush.

They apply onto mm/mm-nonmm-unstable.

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
   part of the stateless KHO work [2].
 - Moves all KHO code into a new kernel/liveupdate/ directory to
   consolidate live update components.

[1] https://lore.kernel.org/all/20250929010321.3462457-1-pasha.tatashin@soleen.com
[2] https://lore.kernel.org/all/20251001011941.1513050-1-jasonmiu@google.com

Mike Rapoport (Microsoft) (1):
  kho: drop notifiers

Pasha Tatashin (6):
  kho: allow to drive kho from within kernel
  kho: make debugfs interface optional
  kho: add interfaces to unpreserve folios and page ranges
  kho: don't unpreserve memory during abort
  liveupdate: kho: move to kernel/liveupdate
  liveupdate: kho: move kho debugfs directory to liveupdate

 Documentation/core-api/kho/concepts.rst       |   2 +-
 MAINTAINERS                                   |   3 +-
 include/linux/kexec_handover.h                |  53 +-
 init/Kconfig                                  |   2 +
 kernel/Kconfig.kexec                          |  24 -
 kernel/Makefile                               |   3 +-
 kernel/kexec_handover_internal.h              |  16 -
 kernel/liveupdate/Kconfig                     |  39 ++
 kernel/liveupdate/Makefile                    |   5 +
 kernel/{ => liveupdate}/kexec_handover.c      | 513 +++++++-----------
 .../{ => liveupdate}/kexec_handover_debug.c   |   0
 kernel/liveupdate/kexec_handover_debugfs.c    | 219 ++++++++
 kernel/liveupdate/kexec_handover_internal.h   |  56 ++
 lib/test_kho.c                                |  30 +-
 mm/memblock.c                                 |  62 +--
 tools/testing/selftests/kho/init.c            |   2 +-
 tools/testing/selftests/kho/vmtest.sh         |   1 +
 17 files changed, 576 insertions(+), 454 deletions(-)
 delete mode 100644 kernel/kexec_handover_internal.h
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (80%)
 rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
 create mode 100644 kernel/liveupdate/kexec_handover_debugfs.c
 create mode 100644 kernel/liveupdate/kexec_handover_internal.h


base-commit: 4d90027271cfa0d89473d1e288af52fda9a74935
-- 
2.51.0.915.g61a8936c21-goog


