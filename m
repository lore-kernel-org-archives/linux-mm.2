Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A99CD0EE18
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 22:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82ABC6B0011; Tue, 25 Nov 2025 17:50:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAEF6B0012; Tue, 25 Nov 2025 17:50:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA816B0022; Tue, 25 Nov 2025 17:50:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 542D36B0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:50:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0332C04C2
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:50:13 +0000 (UTC)
X-FDA: 84150624306.13.2581CFC
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E4958000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:50:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eC+Lk76y;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764111012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h76CNSw/yjP0++9RG1l5A2zC1eyEfItaauawp05FKQY=;
	b=iKFkt6DGYgLDNZJFQf5b7IVSeZVb5EqKVn2GFMpmypYFhdLq54autYhsT7kVG7zg6lCaor
	64dbiH+D5Yjcym3iPh8hT7xZzLwucdO7T0ECq/tYpH/HKdFg5EBJG3GVA4NE/+tH6JBMT3
	8u11ZpWqgaOjtJk2sSYMIlBzEFAJCtU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eC+Lk76y;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764111012; a=rsa-sha256;
	cv=none;
	b=3KKwnIieMmkPBSwwcW1hj4ICUYdIqdQrLga3QsKMPpXccQLQn2Hr+DSB8cxw5AyqdgAvK7
	WO8u+f0QZtDH2cdctcfxrGgDINmoATOKRnlvhQJjbGbMlRoJ93U/vJ59AN2hg18GlOBYZV
	xVdU1a8mrA0VEy05fElHCNQPv9uT4Mo=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-78665368a5cso58425837b3.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764111011; x=1764715811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=h76CNSw/yjP0++9RG1l5A2zC1eyEfItaauawp05FKQY=;
        b=eC+Lk76yTiAPLfb6BzcQPZDzVfw0awBKO+wpbK+BxDTILHXvNIi9ht2SWHL6D5izIc
         +Xk7VQklVplwYGLupzm2v4nzy6NntvWM2q9r+GymXHmibMaGT+4lttYv1bUjQQL9EPEM
         /BY3aA6wjQraxNY+XMraYszFzDjaDWpYkhLSdugnChmtD7zcuxrJ30ySrjgtO/B0DQX6
         Mqt+L1tSoDZu0ullv3izEe2GbV2CykyqVGIXsEks8IlrtT7pt4woVZOodQYyi4J3q7EL
         Ni1au6M3ywuve8v3rZ0uKQ4H45LC7EkWTqJutDHasommX+Cu2ivi/pQbZOExPaxq6a1u
         8Otw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764111011; x=1764715811;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h76CNSw/yjP0++9RG1l5A2zC1eyEfItaauawp05FKQY=;
        b=rGdsn0do4IA7218vGw26U0XkX2/U1h54HUrzmktE64LHqRqXKk0Ylkkp5PXfkLgL9x
         PDXULz64dmLdnHc+CzrE5EfpJ2RlKi6YBo3IChGQyODjmEALzXXPRg3hYCHmMvpXcxSl
         IomGPUoJj62ooWFramkfaOS/b1rprsesrahuZ/hHDUTGEfr+5v7UoOgpMfqBtU9LyMpL
         UxJmzKyUr6JbzKWB5nAUEzW54jTrXb2qcXz4U1gXT2j7KQd47yWlSXIT0+ZTM84CuDx3
         RAGwbVzgiGq5RpJzpTfir7l7E0ylnlWRKIzWYGVqoXcn7HkL0Q9HBIixZca8l7Pw/4Dm
         7d4g==
X-Forwarded-Encrypted: i=1; AJvYcCWSkk+spNOXOlaQjYqEyycXJTGZ1vIv3mQs/9cIUU6fvawcwb8lznxnCtD0OEkWe4+YifJFb4S3dg==@kvack.org
X-Gm-Message-State: AOJu0YxCcGy7yWH19aVgKwlMRTGExtHauhMzaLiDknUARdbrdFDxuIOz
	Ha3iqnRkeoSSIN3HYS1pfwAXugouiMgS6feocu6Hsb1kCIeY04JzZTa3MWbDmYjlF80=
X-Gm-Gg: ASbGncuReRf+ZSLgW0FCZ0DL0hghCaySAXK8+VkyZhRnL+cKjcf7CJWwkWCwlwOqyAP
	cwLi89WZI5tQa+ylgOl9cU9bofqfuU0al6JjT4i3fkegDVkvXcFsU3ceyxMa3XL/wVp04kGd5eC
	xl5eggDr2r2x3D3ElA8t+4mD+6xlh4kAryvU1ysmwYN38lrhljIPftCCy1EuVevgCdRm6caqu6h
	XIYW+Ce3J4UTy3MmRZLieaA+X6XuFpsZqDf2DaxeW7l5XviHCbY7s5Q6dfR/4aBRiKn2Wv5UIKN
	a+MAd//XR64OBKx1RDt/EA2dDf/po1B0lECkbUNAVyfG8DFN2TrSp2IG26WcXvg+FWf3AHMN9Ca
	vNt1xFhAk8SPoHJuNB9R3rjQTy32yOmTjrXRQWekrzXri7WfOWrVfzOyEVRsgbNPPJ9fvCSjQvo
	SB6KyL7mq01dMI16qL3Ceil0Jv4DsoSaAG32G9MRXlAyKA02rBIhz6toqkvXaSS8pkG0XaV3ThJ
	S3S2k0=
X-Google-Smtp-Source: AGHT+IGc1FGEZjeaYLJ+wKm7FdiEJRHIZ4kNlSevXX0Cogam92uLAPcastSEYdMn53ltCq707R7VTw==
X-Received: by 2002:a05:690c:6f08:b0:788:504:fdcb with SMTP id 00721157ae682-78a8b177285mr144036767b3.0.1764111011167;
        Tue, 25 Nov 2025 14:50:11 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79925ba4sm60138167b3.26.2025.11.25.14.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 14:50:10 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	skhawaja@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	akpm@linux-foundation.org,
	kees@kernel.org,
	davidgow@google.com,
	pmladek@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v8 0/2] Live Update: File-Lifecycle-Bound (FLB) State
Date: Tue, 25 Nov 2025 17:50:04 -0500
Message-ID: <20251125225006.3722394-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E4958000F
X-Rspamd-Server: rspam02
X-Stat-Signature: fgdtmp31gwgtyogdqq6ke46eitt4tgno
X-Rspam-User: 
X-HE-Tag: 1764111011-156948
X-HE-Meta: U2FsdGVkX19RxvvK5dLD7vK7Kdmvxw/BeQby8fu5FYtNYyEAJg+oIGbE+vBveLzzdTOJ43MJ4WlkxB17VB93pc72adA6k0lW3AkvzMtanRsH2OL1sxEJGIrKiqXoYSft0qhd8vrXfXnHREewQlC07OLCu5Jv08n2k6NqtjTDukUJKVnCNxv8e1g4zTst98Scs0TlZMrl34LRl3BHRTXEb92WZUQ7C1kDrtxnUVJS/H2MpcBFSpmPpbDZnp1AmyNItBC3a741E1mn5xu25hHWxqFkWZmVhcjkg+Y4EYF/dY+xtqbfNxCB+HAJN3eFLaSLoGjvmM+wRrNHHVuDOfAiO/JXtQd4MOgxrmHpGDAVaVwRqHz7DPstoOUkYbk8jHdQFbvqhvU6CKOsFf83BUIaRtoqH97DFHnAVr38VEqTIZQjPlFy2VVbgveWLeYCdekbccQzAck2PpHDCrsxmh02BgwOvsHZbUjafmoONpY42TFyctPJc/bmUiJ7Gelb55WSFG6jLzCABgDxIfFb/ffyRjX7sFGA2uPzN38aXJCRYnhxfX6JEJhZgjwCUxuk9M9R0J5+IZUTxRCgxIyBq3pkU3x4gfCbwznXFkCGwEwKFLIhikVtJTbCoFeObaTuJJO+9lPGedM3ME2pgd3ZJek6bLpO++hB3dqqibNY395w8NVQyWW/xN8O2OXXNMfuE0bUiBxxCrhAo5cY0fMKjKbx0+TK49gNNwJjnasmHt1kCrpArBKouzESlkndp0tqsJQoa3Uu3s3kUlTW8LTZqle+pUarZGpvdC1wXDZOrX3HvKLpgIOsROHJAiAhGcolyrO1wFXeWgIBTMhFGwo2Zt05aU7henlzzrJk+q7yb4anVeJYSz2wixK+YsrLPUP/XKG/mumeRWWoAOr0ZJB3uDRY4pKH+hnAuskfKvtABbtI5Gx3Brq4AEqSOqnUCx3E+PLwrANZvOozWZYmN/Xl9jm
 eEZv4p82
 lie3IQMHN2o4LJyS6z/8tVmV9fd1fMmtj6siJ+wR+enRB+ulAZNJ8I3JC/1y83Ab6wcnzI1LgFZDY+kndIzJyV9psCKhQgdlsdFGAISYGDp+PSy2wstiZk6wYVystRKTt2ZfdvT/VEyHG2jlxxbj/3b6Xfb2WXB1jnfpForJXb0yBAOkFDwaIe1ZT9A0rVQsmjZZfkT7SIC3+kA2t5RKHY3MfbKizTw3C9zSrbaDVqWh1B8nov54Xp6A6BYdlDEAc4UGrF6JDJLT9wIGg9r1e6t5/+qcYKymRIVQxF3mqPZF7FPpuq1gr33UVXZ7qEILCah2IfdmVQGSof3VJrM5nkOc99q3sgVSZp4+2dOPhANRo7m3Xdq61sclNGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds support for FLB state to the Live Update Orchestrator.

This functionality was originally part of the main LUO series [1] but
has been split out to serve as a stable dependency for upcoming device
preservation series.

What is FLB?
============
FLB allows global kernel state (like IOMMU domains or HugeTLB state) to
be preserved once, shared across multiple file descriptors, and restored
when needed. It uses reference counting tied to the lifecycle of
preserved files (e.g., VFIO fds) to ensure the global state is valid
as long as any file depends on it.

Why separate?
=============
This patch does not have current user user, but multiple streams depend
on it:

1. VFIO LU preservation (ETA: Tomorrow)
2. IOMMU LU preservation (ETA: One week)
3. HugeTLB LUO preservation (ETA: A couple weeks)

Merging this into linux-next allows these dependent series to be
developed against the same API.

Github repo for this series: [2].

Dependencies
============
This series applies on top of [PATCH v8] Live Update Orchestrator [1].

[1] https://lore.kernel.org/all/20251125165850.3389713-1-pasha.tatashin@soleen.com
[2] https://github.com/soleen/linux/tree/luo/flb_v8

Pasha Tatashin (2):
  liveupdate: luo_flb: Introduce File-Lifecycle-Bound global state
  tests/liveupdate: Add in-kernel liveupdate test

 Documentation/core-api/liveupdate.rst |  11 +
 MAINTAINERS                           |   1 +
 include/linux/kho/abi/luo.h           |  81 ++++
 include/linux/liveupdate.h            | 143 ++++++
 kernel/liveupdate/Makefile            |   1 +
 kernel/liveupdate/luo_core.c          |   7 +-
 kernel/liveupdate/luo_file.c          |  32 +-
 kernel/liveupdate/luo_flb.c           | 656 ++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h      |  15 +
 lib/Kconfig.debug                     |  23 +
 lib/tests/Makefile                    |   1 +
 lib/tests/liveupdate.c                | 158 +++++++
 12 files changed, 1125 insertions(+), 4 deletions(-)
 create mode 100644 kernel/liveupdate/luo_flb.c
 create mode 100644 lib/tests/liveupdate.c


base-commit: c26edadff67601d5bbd748ea404ca354d9d47997
-- 
2.52.0.487.g5c8c507ade-goog


