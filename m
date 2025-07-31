Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18DEC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 06:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396876B007B; Thu, 31 Jul 2025 02:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347956B0088; Thu, 31 Jul 2025 02:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D286B008A; Thu, 31 Jul 2025 02:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC2E6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:51:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B1401A05E4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:50:59 +0000 (UTC)
X-FDA: 83723637438.13.9888C90
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id AAA5EC0003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:50:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yMDn7r1Z;
	spf=pass (imf22.hostedemail.com: domain of 3UBKLaAoKCOseVPUNeQlPPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--richardycc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3UBKLaAoKCOseVPUNeQlPPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753944657; a=rsa-sha256;
	cv=none;
	b=y2XNR2SFSUmlTHCENJglmnR+8/oD0DNkC6Wo4OVL1HSUKzLHBdbz9hLhQH50rBGPQgE/g2
	O6npiRiRA7NbUsYggoGqZVQpYEw7eVOgsnnSME8HX415HqNI6JpxdIAiPHlOyb/hwK778k
	3S5aQ+jptj+Uyri42CunRsAp3ktkRJc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yMDn7r1Z;
	spf=pass (imf22.hostedemail.com: domain of 3UBKLaAoKCOseVPUNeQlPPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--richardycc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3UBKLaAoKCOseVPUNeQlPPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753944657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eDJaxtMqe7fiyPuNTQg1qGmKmUg0reM6fAkK/O+G1w4=;
	b=U406eqfazk/vXBbasR5LJEKbvf/ivHyuAtmqboFocFcrQFcbq6IrRIedpkuKcdInOUP5uF
	k42Hy8UWw1+dXgXMVrRzW2vXUMwuG6vNrwlDjtGayruUfWe51S7dLINlPjG9Zzn4SzuCrc
	ZisZQN1+r9uqQzLQGVLoe+qXD6IzGNs=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f030b1cb9so1015940a91.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 23:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753944656; x=1754549456; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eDJaxtMqe7fiyPuNTQg1qGmKmUg0reM6fAkK/O+G1w4=;
        b=yMDn7r1ZGYId3Uv4iZUZBVAAq3buNDftfVFMZiI6lYL/SuSY/WJlsg/8i0hTSoP3dx
         b1qysXzHg2/yNyWCQzXmbOXs6AWqxdTM9yZQaMJuyhz56A/pApmEOootBBdiVwvUq0a+
         zkEUdF8J8GrWmkxKJgYNcs9R1l41EmLswJGCeT0xVCTBZBnZmj/i4sA+Pjh/rvkmku9K
         eKHS/vIpbNIqr51vl55YUpifIjQtC6FtkWeejhQAh2XDhbqihYoNttHOW6UpS6SdxOi/
         u0MubKAE0+2RlowFIDNU4vudi5nBEqcZp+yIl+VWrgUy/waDrcNuWfItpDKTDd2TrF8r
         CM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753944656; x=1754549456;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eDJaxtMqe7fiyPuNTQg1qGmKmUg0reM6fAkK/O+G1w4=;
        b=bAQ5slWNVEbbAAl8XiYfF10W0zbPeO7VAhWTgcfmlRx6CNbeHZrzHkWwPYkc2dYp+r
         YhnKhPV/oIlL7UVxxk8I0oe01RJaHsQiFIo8ED4EFicW/GmRI7yetckiyE+m9k7sLNq2
         AXXz25g4Ud8VdhdE5bN2IujK42fOdAwwyLzu/CPwxf0CNYVAtNxnCL+pJwx/fNB1SUj7
         xC/mIW+02VvzQnBtyNwNWjn5KkFWRMia9ReEHs8t9aFoLmcRwYem73Ld65G0rQ5iFkh6
         C7MpemLxLDp7oqSM7aor8voFKmckwRGvsUwTVywZcdT7WFX3St3Rj8NZtmUBW5STE0Wo
         kASQ==
X-Forwarded-Encrypted: i=1; AJvYcCXE3jgoqqli64/4mw6ISAN6uIsqyodk8VLnp8G0dVz8CdsTVom8ErFEips1cspcXtzoh6alGouZpw==@kvack.org
X-Gm-Message-State: AOJu0YynTGH0eRclB14k3P+7rTI6CcKWgZovw1xjvva9FDoAQRkwOcZi
	vJWVy/iyVVLQmYuKLa42I1ctuukwU6cLz7EtpUZ2hixaaX/3Zma0uit+on2P4ebbvPjLKawrHWg
	yi2txoybXyQbocNuI3QmQ
X-Google-Smtp-Source: AGHT+IFpIPWixJhTbrmE7dv0Cm0HofhpwRmbpRh4awsTGTBSBMeWjmf38aB3IMobKpTlhlDwGPSTmVR7kD9SQmQO
X-Received: from pjbtb15.prod.google.com ([2002:a17:90b:53cf:b0:31f:26b:cc66])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a81:b0:31f:210d:2e56 with SMTP id 98e67ed59e1d1-31f5de557femr8853490a91.28.1753944656412;
 Wed, 30 Jul 2025 23:50:56 -0700 (PDT)
Date: Thu, 31 Jul 2025 06:49:46 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731064949.1690732-1-richardycc@google.com>
Subject: [PATCH v2 0/3] zram: support asynchronous writeback
From: Richard Chang <richardycc@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Richard Chang <richardycc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAA5EC0003
X-Stat-Signature: o64cd5qn1c661361xois18tzc7te6y38
X-HE-Tag: 1753944657-782753
X-HE-Meta: U2FsdGVkX18ZbJHWxcDImGZjsD1TSe3jjsQfxoBTGLEBjFvYZXQaenjuIsNdydn5SRLmK11IaVagaeq0WzWWv9KXZvnVto8TamHOuJXChyEvnd6poXna8LKNTV+zk+0CkGiMR4mHMJ6xCFjFg2eFd+DIvPXYi9K2iMOYyK4UZ5fStRy2UXZgZqY5vFfD7nFa9P7hiwERd9QogIiuAtH7N8n/egMOGNrMt6c5PespeJG7nL1STWHMQk6fyJATUOG35folwf5GntYVnAfF/OG9ZuVdD1qD7t29sukNs/QUX+dZGe7LFrO9rjgAHgHUNi2MPJ9I222tvOyjLL0Zp9fx1H+1yGHsXamL8MrA7UzqqjwWa8qXatCpR4BwlQ60c/QYOfmveANRVUG+PQx95jkOMq12HzT9alB/9KDVbH2X0i9DQOYTLmAwiqyn0YgYPWIuZ95i+GP+bCXSEyfzErZOCeE3WscRobTCnWSXQyhqGv+HLEhMruXra6u9VPv55Al2608pRBb0na8B5L04Ooe1pSsooCPie2Ppl2qoLvgIgZ8DQqFCa6Gt3qKLpnzVhZKjQkuyMYlOMYMEVrZjvCrKtI2wBE34ONq0e2JU6plK5GPhkYihRb/zZrhu/i4YxWnFUYwv4v7Xp8EYQJuGbqKHvYyGV24933QD0Xep2GIXjgIjGKlRGLwT4YjcCEvMyVMEuINB1l7/c8NMEoi/UqYLcySyc/wgYFT3qra0UOkhEqotROR6Ri6TOc6fsep2eC5gQFrL2VM0crlGzJ3YUNuQLeHzO7zBP/bR7eGPVAcVHghMieRRN/jlL3rcXvehFgr7QGdEmWrNiiN3t0yPNmpPnw4giuCAFqTVX/UwR5JnbkY/5WCk+3maufUApSNQHY1A+MqP83vSPCsxBZDuKg5XnY1HimMc6jw9iqFXnOENKUswrA3wXP9oAKbWxhnjWbE9xUU2BIlJ809zt9rIhol
 33PY4hZI
 mjxRWQ+VngdItpospFEXIectI63z5eckKNl9+vrwzvKjA4jj4EBRtElhwMNcLdUzCUcKBQMdHHkvZRKSzHqVWkOTtCJ9ZYu98hkFE/XP7RQEjdIn8ZIKHm2EfVetdUgYH0atZFbMsbAgaGou+Bdw1l6Ie3JNo1K4dCyQ/2glnaxgCHzJsa/7AyGXOyv0Z1Ni282Za+tEhDRUQ9ftUNmpHueDak+AuWc2NhMm78Z83sFLdLH7HA2s6Rv4RndkS/X9bamYKY7ygGl3AxLMwf5dFZVs7fhWBNgrThnVQmY2GUnPK+iKivnI7p35AvfJeSMPcdA9G9vafrI+gvPVWp0hWQxMGdqP02NLX3yTFc3js4FWCCrE+OyogoEzsc3Xf0AnC9Kmy1xAZj3MGV4qfH7602qRnfWUrOxEorWoHWideekVEwSHuzRPgBXGtbDDufxMup7n4aRz9MlYQ/AN7IwrMgSpzVy2huzBp6DtFiJ+XvTo+ZcsMKhglRyxzCMNOAmaQ1h0w8UrTT68sy3tLjq9GFSTlpJzBi4Dtm1na8EfALQ2AhsZSCLtiSPsYosxHVg54wcQ+bVW5NBuP2GzXB8l6LAOlPE8c5YitUFcl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces asynchronous writeback to the zram module.
By moving to an asynchronous model, we can perform writeback operations
more efficiently.

The series is structured as follows:

The first patch is a preparatory refactoring that moves all
writeback-related code into its own files (zram_wb.[ch]) without any
functional changes.

The second patch introduces the core infrastructure for asynchronicity,
including a dedicated kthread, a request queue, and helper functions to
manage writeback requests.

The final patch enables asynchronous writeback by switching from
submit_bio_wait() to the non-blocking submit_bio(). This patch also
includes performance benchmarks demonstrating a 27% improvement in
idle writeback speed on an Android platform.

Changes in v2:
- Rebase and spilt to a series of patchset
- Add test results
- Link to v1: https://lore.kernel.org/all/20250618132622.3730219-1-richardycc@google.com/

Richard Chang (3):
  zram: refactor writeback helpers
  zram: add async writeback infrastructure
  zram: enable asynchronous writeback

 drivers/block/zram/Makefile   |   1 +
 drivers/block/zram/zram_drv.c | 157 +++++++--------------
 drivers/block/zram/zram_drv.h |  30 ++++
 drivers/block/zram/zram_wb.c  | 248 ++++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_wb.h  |  42 ++++++
 5 files changed, 371 insertions(+), 107 deletions(-)
 create mode 100644 drivers/block/zram/zram_wb.c
 create mode 100644 drivers/block/zram/zram_wb.h

-- 
2.50.1.565.gc32cd1483b-goog


