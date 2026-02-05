Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 205D5ECD9B0
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 22:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7A86B008A; Thu,  5 Feb 2026 17:23:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42AF46B0092; Thu,  5 Feb 2026 17:23:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329B76B0093; Thu,  5 Feb 2026 17:23:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2202E6B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:23:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7604C0C80
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:23:34 +0000 (UTC)
X-FDA: 84411830748.25.6ACF6D8
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12B0CA0008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:23:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SmL8Figq;
	spf=pass (imf15.hostedemail.com: domain of 3YhiFaQ4KCPkkpsebosjdibsethpphmf.dpnmjovy-nnlwbdl.psh@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3YhiFaQ4KCPkkpsebosjdibsethpphmf.dpnmjovy-nnlwbdl.psh@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770330212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=haoofomy9mUcwiPEYSd4UfbSMuTLktRLPbLWvg6IzYI=;
	b=Z/oDtP/+FfTRtYWmkyEAEwrAJXR8xGHNVtr4bz2WxI3wS/0bw/x2CAU+Q0AmiWRUKX7SK+
	jLhCfD0P72/oyyQ5H37sUkY61Dmzi7dxf7+S0l+IDrqx/DvNL7NtISpGSsQBFPYHXoHMmi
	ZFPUNDqmHvBfV8f49EMUYVrww2q3wsM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SmL8Figq;
	spf=pass (imf15.hostedemail.com: domain of 3YhiFaQ4KCPkkpsebosjdibsethpphmf.dpnmjovy-nnlwbdl.psh@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3YhiFaQ4KCPkkpsebosjdibsethpphmf.dpnmjovy-nnlwbdl.psh@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770330212; a=rsa-sha256;
	cv=none;
	b=TNrYEgJRF5pnPmnw9bDqoPoisUGsmtRGwHcxEkNfhJvu19EtHrefXen1JVkmV868RD29Ii
	qDV99VSdjlXSpk/xWaaNQ2jdmIBghMSZwmmGPVfiM4fUCWFrt9REqN0fkmxxAU0gux684c
	tgDfrGGBeHMEW4sF1O35gFOvIJ3NQgM=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b8343aa8a9so1293487eec.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 14:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770330211; x=1770935011; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=haoofomy9mUcwiPEYSd4UfbSMuTLktRLPbLWvg6IzYI=;
        b=SmL8Figqc+kpIMxUdnxiwkg5g35U3bki6Y49uu0PKj6gHoFqSG8WXZqna/45KrFSVi
         1JungI7zZacS0Ql9Z1n7dDUAcDsmR8s3WIP9u+oqRE/jwmSa74Cb194ihxlz9tGzomk6
         uHMatKx2EBJ0gJfungR2MHlqOBq2C+afqIGq8TH1NX/5KAFR9Lhxn/odFiC9rRmYVbfo
         7MoH6ZJdJhCEOQ5Kfa3uZOxh9E9oRDMYxBrBx0SN7pF3Ertza/GTDLsCFB+MMMQIVcem
         bnwovGEhCNThHMTx25YnwmOCRRkhJjEAIdP5Zro5VKzsB4neG+Hv+ySXnQgtbcJZA09x
         Tf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770330211; x=1770935011;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=haoofomy9mUcwiPEYSd4UfbSMuTLktRLPbLWvg6IzYI=;
        b=Cul0g6Z7Oj3TAfowKL+g6bseIA9BsHu1oGx9ybcMmcMggvBmRfzwVk6DBllfzXoBWS
         qB0DH/azgxjfGlnBYt3oFPuyR/yk8/Kt83pIqRhXVdS1xHFU24V+98aEgLA6Mf/t3z88
         cTXzxsQgy4/ilD++5uamMN5o9L0f0yI0yvFQo2H8Xq3w3W0NqoahryqTHruYN7yIS4g9
         haoH/H6H7AdADtTQ7Z8zLMUzMHKxla67hWOTaVOvoOivWfjqBfZduujwJ32ccqI0DnNa
         MelLeF0hCUk9o6SaeOXoKGVgDXuHnBmvRInV+V1M+aGv8zMLNkxTuhTqBc4eiQ+dLdM9
         cqMA==
X-Forwarded-Encrypted: i=1; AJvYcCU0Bqho+/G9DKnCi2WXCUU22AXSkz2FAcWGyE9NuDmX9+YZckLBHmyteC+9t62qgvMIJIkhDsU1PA==@kvack.org
X-Gm-Message-State: AOJu0YywgCsQd5NthTSi4fDaZVeP+GtKtzwFYtj8IOc23LMBellSBQjX
	9bruzVzKpH7rZqWtIkXf5MfIo6t1IJJccbjaGhoN9TzQWgUOkuJNmcXUhV58eeVVLZ22Jqa51ie
	3cvsELV9Ifm22BKirJ5XlH74coFb1HisSertOXA==
X-Received: from dybud9.prod.google.com ([2002:a05:7300:f609:b0:2b8:28ea:cd5f])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:3e18:b0:2b0:6a03:e620 with SMTP id 5a478bee46e88-2b856721f10mr311665eec.24.1770330210752;
 Thu, 05 Feb 2026 14:23:30 -0800 (PST)
Date: Thu,  5 Feb 2026 22:23:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205222329.2419035-1-jordanrichards@google.com>
Subject: [PATCH v2 0/2] selftests/liveupdate: add end to end test
 infrastructure and scripts
From: Jordan Richards <jordanrichards@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Jason Miu <jasonmiu@google.com>, David Matlack <dmatlack@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jordan Richards <jordanrichards@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9pdrb8gyayuhj5oa5gy377xmyym5wikx
X-Rspamd-Queue-Id: 12B0CA0008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770330211-92564
X-HE-Meta: U2FsdGVkX1+rHEYs62opeWyKc4aU813JR7xithKfiToLF/0dfihxVXGwQsGQoDNq9srGcWKTDJVlKUvXgQiemS/rht26iKdIDr5d3FNlxP4O32zFB3yLkhJIXshPyc2C8BEI/LqmuPPc3KXvICOvaOseUCQLcGmfp9RmtvtfvnkFU1qG5tXyMVLv6DaWjtDX0JOiIP/gX/R7QSwquVKoOS4wqR2fHrXlSIQXucmsQaQOfIZ3GY5/vgBnnVUXil4c73aYTaTGonDiEyFXqPMPabHVCrvVjfxeQ+p5CaAiZyOhp67tD3jmIH7mnCy6sqTEX0tcu40LUQpTklRSnUVwisC8kR6xMvUSYzxGw47E8GcIY5MGT0/mZ3C0/RqcjFW/QfEhT03QIXLf6NvqHbYXQPuThGJ3VTJ3s6BW9QL2TbUNkP2tU+H6cYIIqUqL5fGrJSlY8hq+7maSwKpDT6u8MkGk7djUq0Q/+KkYSQdhNhadonPPgXXOVu3lDNsXf710zpKZB4hhhLmShkyh/VE6eUCI73iHMGPgBc5GE46SylIJuzazc8oo4dIrUFxcDc9uGx5WP2yl1lwIzogBcmLQhEdhODETXxWRb0MzTtUDJG2m6/5GcNZc4wa3FVytemN41XrtPDV3PbAuuzMY7slVkckHQJBPZEVyTjuYJfw+NH60crXvpJFHBHWQd8R594Krzny/i5Z6QTtJECd0xNz7eqa80QkoxVDCB6z986dsu1tO2mkvCAYX1jF18aixeqf/hE9Pr3cQRkKl88i1DD4fwH0ItSi9ZQ4DODGY3NsJeUu9mV4oeudBj0IZr6p7ZFBoTDh7iuXzM+9w5zjZQg8ef1Cff1gmTXsjlUKOs4ACMj+YCGaDTt7x5joxLGddm7r7E3V1sdmJa8hJ24cd2QQq+saB6lZTC9Uj1JOL+F+1WfiJQdWwQm16UZGVFstcIe7bwIUBBuk4gaycRMxSuf6
 s0PNxP+m
 qh7ivDWIXHwU+l1y6DuQt31ZpN28WQKIcBbLMwqBIi4sgAk0UQdUMLPdb9GKP57JaaTs3jJ/EXVNChQtPNpCMtmZ/wcrJWIUAq90kJ21fCGaKIcAuPfcShsSZLGdhn5haiLsVcbSbQgM7IrM+6bUxKm5tffjOPxlFQduRXo6ml+2eNP/Yxi1/3cnVj9slhvee4EfV0KDqDrR8zHNrarqebNBBFZE94Vq5oae93AtggGyQR83zKTK7MJ6gHfMxLtOttJBDomkPPay+qwLakLkLuq+FJBt8B4a5iBYPc+dz0eORf4LkeNeKH/VRjy61lcaiZv4WWU9zgpt5Vnno+yTia9km5Dxn+Up1tmff2GVxETQMH2Nx+2Pc4LnVlf//A1P6acHaaWRsxHPcJIpQE8iS7258wT5tIZDkuAbFwaLOBprTX2YBzhYYiweXkCCb8Pxm44JtR+vuWOGh83VnUhpJt/3GGx1mjHnVVMcYn+3V459DoHyOjOrn67mvgLIiiMuxJ4Cr34Lo0kAuJlIycbS27oFR/vJwAAu7GJYdp9bvXIW0w+rjGnuG9fsgU1+Lgl1Wqx/KMRv6+cyh4v+wx8NWsAaNb5aP27eQDds/dj88sLWjnndCWtPi1abnHKIlTpQyyIzC9/ua5pN6qZiDYlYlRaxptMzyKQvA/ZIrwA52uCiLzGUphc9EBBNAot6MgWx7jFGFJ4byOvD8eT8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series adds end to end testing infrastructure required to
verify the liveupdate feature, building and running the existing
selftests on supported architectures.

To support executing the selftests as part of an init process, this
patch series also adds ftruncate() to nolibc.

Changelog from v1 [1]:
- Moved ftruncate() wrapper to nolibc and fixed issue building selftests without nolibc
- Fixed handling of CROSS_COMPILE env variable
- Remove unecessary complexity in luo_test.sh
- Move results_* directory to selftests/liveupdate/

[1] https://lore.kernel.org/linux-mm/20260122214427.3568647-1-jordanrichards@google.com/

Jordan Richards (1):
  tools/nolibc: add ftruncate()

Pasha Tatashin (1):
  selftests/liveupdate: add end to end test infrastructure and scripts

 tools/include/nolibc/unistd.h                 |  11 +
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/config     |   1 +
 .../selftests/liveupdate/config.aarch64       |   2 +
 .../selftests/liveupdate/config.x86_64        |   2 +
 tools/testing/selftests/liveupdate/init.c     | 179 ++++++++++++
 .../testing/selftests/liveupdate/luo_test.sh  | 276 ++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     |  27 +-
 tools/testing/selftests/liveupdate/run.sh     |  63 ++++
 9 files changed, 549 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/config.aarch64
 create mode 100644 tools/testing/selftests/liveupdate/config.x86_64
 create mode 100644 tools/testing/selftests/liveupdate/init.c
 create mode 100755 tools/testing/selftests/liveupdate/luo_test.sh
 create mode 100755 tools/testing/selftests/liveupdate/run.sh


base-commit: 145197c9801f90fed517447e24a9d20f3927cf27
--
2.53.0.rc2.204.g2597b5adb4-goog

