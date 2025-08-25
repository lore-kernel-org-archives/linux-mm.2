Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB603CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C498E002F; Mon, 25 Aug 2025 10:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124758E0001; Mon, 25 Aug 2025 10:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061188E002F; Mon, 25 Aug 2025 10:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E73F58E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:57:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98FA814041F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:34 +0000 (UTC)
X-FDA: 83815583628.09.92884F3
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5AE48180003
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hvi8BJVL;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VdEVZ5TCp58sTeVk+nfvlA0Ah5Y1WxCmV7eSgrEVDls=;
	b=5UBXMD2ZvZSB3y/zglKB9GDlq/y5Ll1I2eLJEZZOIkaDTosZyGtP8wIHzWvuGTYrA6Q6lp
	4ylRvmfI2zdBe5XpYDtoaY2fioNUQaqiKzAmt0TLdoGGbLeb/GCm8e/7Cpi56gO8JcbEa3
	W+MABwy+9NKdVVRQcm4gQeFV4aYXCG8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hvi8BJVL;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133852; a=rsa-sha256;
	cv=none;
	b=7tjYr6B/SrXZnO45j5JrN18/KaOERvfA94p4mqDcCKXO92Id/z0Qp54q5Qfrv4vVD9WiUc
	Fou8bTqf7r8BbpsAulo3EbLj4ZZmV4r+j6xrx4RrkxYP90i0dT1OrCagAN5Z5ZXhK61+OQ
	zobS+tYMkGIGY+JOC4x9iVAWnT53PKs=
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-771e15ce64eso794118b3a.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133850; x=1756738650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VdEVZ5TCp58sTeVk+nfvlA0Ah5Y1WxCmV7eSgrEVDls=;
        b=hvi8BJVL0bhLOXk2tvZY7DO9xDXyNPuAmqvlfUqVmmIrxW7zWkcct70i2x9oQtToA+
         IRQvz+JBUTkltBbw5CkXtvaaGFfStFfUD1R8wZKzTlymzmd0iHlzT59iX3jbgii+QOOQ
         Yz5swy3gaKCu8tgEppygKdLecBslhzVt8i2dM5dRPhapZQmPQM2GT/MWk+DXKSZ958q1
         l3MnFIl3LAzqAJvTcoluR5pPZjv2ebfS0trZRzisxEAWV6jx4hQcpIxBP+YWxXno8Jo1
         zoLs5aC5EOVwBpIifD72ql48XLeoWnWYjmq/ZCIwHORUGmGCVxNRCa6kNmKwPGOdrAHT
         I0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133850; x=1756738650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VdEVZ5TCp58sTeVk+nfvlA0Ah5Y1WxCmV7eSgrEVDls=;
        b=qQ14tk+sEfP90alV6hvGHptALYHgBPJPLWLzdPRwT3uq2JHT5v8ff6qkIhAf3gUOWq
         VdrHCUc2NyZ007/WA8M0wR3VMPjCUXlXB7DteZORvz1jIHjArVR5/a8P6BX+qgIAMQZB
         TCo+FjchpIuOi61v3TXD+7Z4iWFxt52fXOJqvbWRGgkx4E1/AQGSA7loStpy98eMJ435
         Uj9MJYAMHMg7oSu46HdMbejgvjTC+l7WiL4N3ywqifTdWZckIJqf1PSZivk9SrrgYkxL
         iNCuSSnWFI9QqRaK07vnJYeIOEd6amzro++YvwtEIGYgmeCkCJuukx4AGMV0nghvfGT5
         JhDw==
X-Forwarded-Encrypted: i=1; AJvYcCU/VIHpvDWHS/07pr+QRAxj9Ijchtya9j+zW6qhep6XczZowTPJB4M2DOACs8F9bXp3iDWR0p3VRQ==@kvack.org
X-Gm-Message-State: AOJu0YwI9Rs6Lkfh5TWr6G+LWt8wcwnYDgldwWx30ySb02E4ImdrVVFy
	fdrTuMD/EZv6wc5Ob3GYciEOAEYiDO/BmAx3EJ+bVuVqYM+1hGBHvZsoMulmP882Esw=
X-Gm-Gg: ASbGnctJInlbrl3I7An1D3uIK5LFK7whAZ8jHcv9clF3Naoe4YA1D1ulhidIyLCdwoP
	ggMunIxngHF5teSh/zdnSyaTT6v4pep3PNh9BE8eS42jbiyzRilIfeI/LjBPbqpai5ejx4ecP+m
	PPQwoG2/8tLvrXehylMz1H+s6gKxdyM4Z725WrkaMiR9Kuw6Vn49usgPL4Hn8rwhn5Pv751ygmd
	1RbRcPVL4uWxw0TkoJJ70RsvurDeVtd6FRgedN+FlVFd0w7EusOMIRgnyJ2SXWCLN7vC9Y55l/0
	3dJGF/oZSp+hV2VRhPhjv4lw3JJHmjt6mI4+XbhovKPqqLP3dnWTNZ970MqyESSY/fAGo1ikPgf
	jZ1fUiR2JzGAzVhNXVsfEK1mwmxrdMtNZ8vSNz+ESEu/aPj3TgI3oJsVw2r/Y
X-Google-Smtp-Source: AGHT+IENPQBoFqdndLCJHhCszx3PtbFlasr7HlxuUT0VwFZeQm4kkp41cyvWYH6QXY7aP4DPdWilzw==
X-Received: by 2002:a05:6a00:bd92:b0:76e:7aee:35f1 with SMTP id d2e1a72fcca58-7702fc09f00mr14592628b3a.29.1756133849771;
        Mon, 25 Aug 2025 07:57:29 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:29 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 0/8] Add selftests for mshare
Date: Mon, 25 Aug 2025 22:57:03 +0800
Message-Id: <20250825145719.29455-1-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5AE48180003
X-Stat-Signature: 5zd3noqajsmikmopp5jf7t7pe77331u1
X-Rspam-User: 
X-HE-Tag: 1756133851-109448
X-HE-Meta: U2FsdGVkX1803z8F704MqYm+/9AeLHUbt/HSwY8C2t+hfHvG8O44PNxdarJagliuxrmZ8ktewm4hSl9ue2HK4e5tMmxWR/KRZVlTHVJyfvafyFtjWtUN1ixlY5sf6JH8S5Hqf8maT3A3V+B3tF3sB1I1zB/qEijgsfGKvfC9/JL5FJSOtLTQUjT5FwlAz4SuZW6r7aidPjpM2Xnd4BqpFusox8LAkSMYhPteRHLY3WlKtKhKe/H1bbK7+ZCW7JxkSqsSqWfjv86ztbvkKyHSzAqX4zOZQEBL+m4l5JlMazW9tf5yNqxn9QjTPdmFOQESCgdyqciSPulci147f1L3Fr//0TXbRKHMOTsViTFZoSjPvuqeTN5md8tPI6KscvpNB/qiO7SgBBSds0BUWizB/FMDMWBV+M0dsVjK08cq61us/xZIlhKp1hkJFizmV2MdUVHykibhtKFHyOXCEhDK15YPYdGxC2sP5DvlUy1SG0UD8XfcW4lEWjR34l6b4Lg+KdcK0YFVFIPNizVerkiQ3evnYXMJeg4bi/9YElBp+xm2nO/bG0wHyaO+0XRkr0JasO83xiTOaSw54kU6hZyvEYxYBtw8VjCr/17Z/v2/p7Q6zo3D+rFQoDkgT561QWVKlIwJVG5A9PwxeBySWxNTkIMknEGHiKqaxEpTDIjnq6b2IleSPYMqUI3O7dYi+2pVQZf34XI950qFpq32QfMSf5RLYNn7JI/O+AtFrUy8pBqZeoxs0XYftGst2rigNi3xvwlEsEsKWX6kcj4mKDKF+/3GBtQZ3vp1o+MEMvXv+1amdpyohF0Ejc576hjNImvGY1yHLp3kG/smYjjysgaMap4DsLvbPMtFm1DRjxsAzyFhA5pz63e6pqT+OHkIgF7tq4rcj6H7O+IM8lpszyKne3giqBUfjREtnAR/PV5SnkW2kSL5lBH8XkkRJNS+ASxeZK1ssz8jPJjD9JORdOk
 HbRzYRZd
 c7QjxZAq83A73U8d3QIBkWYNOp6PXyV6GWQBgGMXbU7o0jxxlMWmbmfptAhmDob4i/K9K3IyLkvm/+1vh68xiALrKVMSSUmh9JCc08V7avK49hyE6euwQb8R0Qp+Mho0essWbi4sxJhmcRxoWv26sWr6KeZ/62FQgBdFUr0k7CC0xtFxGSfTFXqwRLVXHBWXCvHH7jyA9y3OiiynZs/ohsVBLIg94G6Apv5kVUXqDrysoliIkiekWRs7wJvvF0Yb3qiC+HifkkqnLdlQEllHgUsvA3JzrZtl5bhYb5RtSu7Si1uFRYSaFflkeVvuvQz5rinRnqxF0Gc2krLl9yfTaICUE0IHYhV7ES4xjMi5lWtHK/Z0BXohPNA739XAOKKooKbFPEmLdb7NTCLEsZUy/mvzC+EYrOcsgBClJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mshare is a developing feature proposed by Anthony Yznaga and Khalid Aziz
that enables sharing of PTEs across processes. The V3 patch set has been
posted for review:

https://lore.kernel.org/linux-mm/20250820010415.699353-1-anthony.yznaga@oracle.com/

This patch set adds selftests to exercise and demonstrate basic
functionality of mshare.

The initial tests use open, ioctl, and mmap syscalls to establish a shared
memory mapping between two processes and verify the expected behavior.

Additional tests are included to check interoperability with swap and
Transparent Huge Pages.

Future work will extend coverage to other use cases such as integration
with KVM and more advanced scenarios.

This series is intended to be applied on top of mshare V3, which is
based on mm-new (2025-08-15).

Yongting Lin (8):
  mshare: Add selftests
  mshare: selftests: Adding config fragment
  mshare: selftests: Add some helper function for mshare filesystem
  mshare: selftests: Add test case shared memory
  mshare: selftests: Add test case ioctl unmap
  mshare: selftests: Add some helper functions for reading and
    controlling cgroup
  mshare: selftests: Add test case to demostrate the swaping of mshare
    memory
  mshare: selftests: Add test case to demostrate that mshare doesn't
    support THP

 tools/testing/selftests/mshare/.gitignore |   3 +
 tools/testing/selftests/mshare/Makefile   |   7 +
 tools/testing/selftests/mshare/basic.c    | 108 ++++++++++
 tools/testing/selftests/mshare/config     |   1 +
 tools/testing/selftests/mshare/memory.c   |  82 +++++++
 tools/testing/selftests/mshare/util.c     | 251 ++++++++++++++++++++++
 6 files changed, 452 insertions(+)
 create mode 100644 tools/testing/selftests/mshare/.gitignore
 create mode 100644 tools/testing/selftests/mshare/Makefile
 create mode 100644 tools/testing/selftests/mshare/basic.c
 create mode 100644 tools/testing/selftests/mshare/config
 create mode 100644 tools/testing/selftests/mshare/memory.c
 create mode 100644 tools/testing/selftests/mshare/util.c

-- 
2.20.1


