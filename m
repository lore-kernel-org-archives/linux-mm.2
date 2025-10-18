Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302FACCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AF88E0007; Sat, 18 Oct 2025 13:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB238E0002; Sat, 18 Oct 2025 13:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D93A8E0007; Sat, 18 Oct 2025 13:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 15CA78E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97E43591DB
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:00 +0000 (UTC)
X-FDA: 84011892720.14.E64B2C5
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id D000212000C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:17:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="TRFA8K/g";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807878; a=rsa-sha256;
	cv=none;
	b=D7m5UVGOpzz1fv0ZicvBuAst6CCPl7Vvv/FUJWNDUxSn9kIeXmiqi9qRMsorzQFDmSddse
	vibPS2jvA9eU1EFS6KIRp1fQAamckeKgnW8eOtGbhKbKDzee+j/pJhWbntmg5Ma/lW6N49
	7p756XnUW5zK2LviZ/HqZAfwoXQa9Ng=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="TRFA8K/g";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GZzPoVlS/aHxqNI+MR86s/hCO0+6teAIiedG4wDBRPs=;
	b=5k+b7+ZQQCQ5Ox5QxhBmdVvtwslcmY391iWwX6rBmsa9/IWrfDHKGfxUKyPQsBsDIvGrv2
	GGYPcW81p4arp1B1KLQOnHk7Ma1ypOhdAhbir+YAAbVdjoffz28JBV0WDIGUznKQyZy93q
	+oM1WQzEk7cs5EFm4lu2oHfL98E1DnQ=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-87d8fa51993so13139806d6.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807878; x=1761412678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=GZzPoVlS/aHxqNI+MR86s/hCO0+6teAIiedG4wDBRPs=;
        b=TRFA8K/gyiP8TqPYlhw1jIcL04rAVaRZLt118ljBwQP1JGiytfEUrWC4a+3WAUKodi
         7BrLxLI5jD3/tni/YeFUdafvY8MYL3MuhC6wud+c47FCVQ4cqjvXAF9Q8kegcOyEpePy
         +guvEx5aE7Tw0JfiKghkaZ0yu0R5V7Wvk6YnZGKwOSGMjX5nG7eHVY2oEjxabVWQkx1J
         /1dv8ayAulQykERtX1zWz1u+9mFc/H8O427LcsW9XxSis02GbN+ROXYudInQJOpLvzi5
         VVmP5ZudSw+rcYdl2EgGQdxKqdJwuUkm8FKWBrwK1/bYVhkzQ5t6rmGrNncbFFdxul9f
         lo7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807878; x=1761412678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GZzPoVlS/aHxqNI+MR86s/hCO0+6teAIiedG4wDBRPs=;
        b=NqERd9HnZuDtVTO1MVE6mcgqd/J5MypEjn7krYAH3Nuk21E21GWbQK4+Mm3UFQD4mh
         7K9NHqwC/Ibw0GY7cHaXK2OC1BwMYwuxdFaMkcx4abcbTq86jQTzwtsVGu+iJqPsT8jT
         uHn88WvEobk7QzRQFLsvet2fx+kfgX418QGFFKXU2rtojHX413X3DIBmjc+Z3W8IMJhP
         Kao8zqdujrlriLzwM2BjXMG9RGw2KPzvBxf+xKAWBfSE7eIqzrlbrWYiScy1OB/wRkc5
         BaTkEPI+WcsC52bNk7xDdnvxWaLqJR9tfugJlnyS/g+J7sjcNPZFo7SVQH3j7a7A6VNO
         14Kg==
X-Forwarded-Encrypted: i=1; AJvYcCXPiCozCxC1cF8hHhZ5MgeuSEXKKhxNDTIYZ5iCwUHT9D/uyjsbP0DpZ8o/xvck/XKRRKkfWafLoQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/Qs2hOgRHnONydO6DTmfqldGLJNhGrAo09DcdKZKV+La8vLjV
	zmjDqc5SJaqKxmEsMiKEpfTo/HjzqWVP+KDANSrXwlw2v7aiZXAOILjRk9lkWoYfY7Y=
X-Gm-Gg: ASbGncs8lrmWwD4wH9jfeovezaljKedf5IQH3bBQJzgU3IsS3wZQZB7H/9DpkOzUuar
	qo9r4Y+Hc23hfX4aBm8ClXPpoOzlsZvbFLz6mIRBrrwAmajyFf/N/41q0zjHM6zKPvfKFCr5qdj
	g6iwvdGcgHp2VnUi6kBY6LcRdty60jfA3k3xP65T+b0HkdzxbysKP/HK4AsMn7SYAdaOgpuCX4K
	4TbcyfXC63euz9K3TCSiyLSEt7qOuOE04+iNpHoIqvFuHxDzTY0x2vJVHnsr+yRjixWHJFMUWsi
	qHfNhS/L0Z+FMGCUhD3TDACbyyDOmq5XVcgerdd6ryW67YSJ0K/jzcqm6HEopub4GRTCXPD+YxQ
	ROtCrSte/R0kzHGz6iTs7HVqmxPmLMcJddJTDaWO1Re9UznxwWVSqCzw+WVKkSpSh+GaLfUvuE2
	cl9YVyef/QmnWhPPo2Iv4zUEoNWKslyB2axn2TfMH61RhGTXL5HeEJvn3WbjeU2nwpKip730fxf
	rG1EXQptiWreuXmeUOOPw==
X-Google-Smtp-Source: AGHT+IGv1aqeoBs230VoYjhUaedrhhH0BEcn6yibSCLCY4GSXU2MuZWJpHXeteVR05/zPVhCmOmGhw==
X-Received: by 2002:ac8:57c5:0:b0:4e8:a4de:4703 with SMTP id d75a77b69052e-4e8a4de4883mr75059621cf.57.1760807877849;
        Sat, 18 Oct 2025 10:17:57 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:17:57 -0700 (PDT)
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
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 00/10] liveupdate: Rework KHO for in-kernel users & Fix memory corruption
Date: Sat, 18 Oct 2025 13:17:46 -0400
Message-ID: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D000212000C
X-Stat-Signature: z8npuq15ujwezytg5ppqe5fydutnpajy
X-HE-Tag: 1760807878-369516
X-HE-Meta: U2FsdGVkX18ytjQFrTj5v93x3lPwJ4/1wvLSYdXK6ABgYKaDE/QXa6Dw1HB5iI7iNiEs64GNUWoORCI8OFKAs/BUB5FfhxAvnVxv/ixD7VLyrzzSHrDtRP9ylqiIO/CrPnsDhMAQb2GWJvn6hz85tlgpSZWneKZXlRDyG77kzhnidJU2acDm4nGFVu7JG1dXpewqVyPUAPtn+Q3qQ0VssC8/dQV5ehqGmFLbgSYrG+vulNLN8K+60IFdTGrnuVqOkXa92oSRGOcnFKVE4RL/d8L1wb2glreQbP8JLfgPU/l/fyEHtfxZ3h0iMppEiv61UrWDVSMTw0JkHvKePVfVjDZVDjBoRR/tUyspHHaEIpM2fHTPZ9kiW0w31CzD8eVmqejY+Ut1jxaUceIuAS8KefhxmOR3lIcbbwcJDKtHLDzzkUAO6vpX4zI7xUs9+fPR11+6aQqQl0LytMoejOE23ncLMMrXagyivBtRak2ylOW6NgmjgypoAkXcM8J1o1wdQW4CaCDqzgzv+qMLh8UYFcIZchkcdAqyfkZmtSJbCmWiLtmEVO5G50Wg2XndEHwM3b0XJFxeKyylsX5/ElVcOBaW4ZnUxzmZFy/gKp5fB+lMI9LaDxIrrLHPoI5n/NIOVNK1lXGFcUPvWJtQRcJiULxaVY5J9leuadK8DgFfk2mzgPnQnvb64BmILN5+bWe2unYVuPQhxM8JsCxwSzcb5Bek6/dEisK1+QX5N/H0cHNFmk0cGYR+KGV2E4AKP6KcBVfKY2ye0YHb7bfyPHG/hr3kvuFIONECZwIvZQy7JowQyfvpDu4qCaWrP1MAO7UmlUrZKk3yWX4NFdAF70NJkFSZXUjiSU60pzdmxRVZroz8A8fsrzfoXYiILPsBRt0j3Mh9DEVCy1KXcUU903aI7TK1PbjJ3Ykmr+47imJckfPTEYDjPTmOQ3k62m4V0jStSqbT+llfVHALr45oAt9
 JOuMH60E
 FKeHl9oOmJee0b/6V5cveAxqVLMKjpdesqJIdtW3recda0i9YePfHBao2/oC0UoUS6l2lMjEMTUB18J+K627+0kTttH7hqWVuOvBUlt9nK4ZE4wKI+3ZL6nhv+58cPIzLs1GtmYb0xzJF/0CpVoD7MSWZgzlocRj81zz08mi7VW/9Ti4xVxiZQojeJKYpASFTzb2nS8SOwPwlMNidMusPe34R1JxJQB47MboaBLm89Eb81I3fKkDmzOFg1e0phjLrL7/uiQlhWbPItwkeS5YBIm5SBxe7OFyMT5Al4139aFX0zpfy+oJx/T27kn7VX2S/inAE+pHvOt3YXEXoWpPeJXGXYdlUVYqtiZpm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series addresses comments and combines into one the two
series [1] and [2], and adds review-bys.

This series refactors the KHO framework to better support in-kernel
users like the upcoming LUO. The current design, which relies on a
notifier chain and debugfs for control, is too restrictive for direct
programmatic use.

The core of this rework is the removal of the notifier chain in favor of
a direct registration API. This decouples clients from the shutdown-time
finalization sequence, allowing them to manage their preserved state
more flexibly and at any time.

Also, this series fixes a memory corruption bug in KHO that occurs when
KFENCE is enabled.

The root cause is that KHO metadata, allocated via kzalloc(), can be
randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
early memblock allocator is restricted to a "scratch area". This forces
the KFENCE pool to be allocated within this scratch area, creating a
conflict. If KHO metadata is subsequently placed in this pool, it gets
corrupted during the next kexec operation.

[1] https://lore.kernel.org/all/20251007033100.836886-1-pasha.tatashin@soleen.com
[2] https://lore.kernel.org/all/20251015053121.3978358-1-pasha.tatashin@soleen.com

Mike Rapoport (Microsoft) (1):
  kho: drop notifiers

Pasha Tatashin (9):
  kho: allow to drive kho from within kernel
  kho: make debugfs interface optional
  kho: add interfaces to unpreserve folios and page ranes
  kho: don't unpreserve memory during abort
  liveupdate: kho: move to kernel/liveupdate
  kho: move kho debugfs directory to liveupdate
  liveupdate: kho: warn and fail on metadata or preserved memory in
    scratch area
  liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
  liveupdate: kho: allocate metadata directly from the buddy allocator

 Documentation/core-api/kho/concepts.rst     |   2 +-
 MAINTAINERS                                 |   3 +-
 include/linux/kexec_handover.h              |  53 +-
 init/Kconfig                                |   2 +
 kernel/Kconfig.kexec                        |  15 -
 kernel/Makefile                             |   2 +-
 kernel/liveupdate/Kconfig                   |  38 ++
 kernel/liveupdate/Makefile                  |   5 +
 kernel/{ => liveupdate}/kexec_handover.c    | 588 +++++++++-----------
 kernel/liveupdate/kexec_handover_debug.c    |  25 +
 kernel/liveupdate/kexec_handover_debugfs.c  | 216 +++++++
 kernel/liveupdate/kexec_handover_internal.h |  56 ++
 lib/test_kho.c                              |  30 +-
 mm/memblock.c                               |  62 +--
 tools/testing/selftests/kho/init.c          |   2 +-
 tools/testing/selftests/kho/vmtest.sh       |   1 +
 16 files changed, 645 insertions(+), 455 deletions(-)
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (78%)
 create mode 100644 kernel/liveupdate/kexec_handover_debug.c
 create mode 100644 kernel/liveupdate/kexec_handover_debugfs.c
 create mode 100644 kernel/liveupdate/kexec_handover_internal.h


base-commit: f406055cb18c6e299c4a783fc1effeb16be41803
-- 
2.51.0.915.g61a8936c21-goog


