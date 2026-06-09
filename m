Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF61DCD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF946B0095; Tue,  9 Jun 2026 09:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5747A6B0096; Tue,  9 Jun 2026 09:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4369B6B0098; Tue,  9 Jun 2026 09:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6916B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:19:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFEE9140553
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:19:58 +0000 (UTC)
X-FDA: 84860432076.26.42B2929
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 15F9618000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:19:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iFkKtYvd;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011197;
	b=qr8Ic4/ktcTDU0EEJkeZeDbRK+QD48MjgK0PDb6GdpIf8i2RUeirSmfgkqKLtt8JutByXW
	gmyV0K07sLgYgrPk+RtZl0k/8hqBnEsW1Av/icXmW3/O3vi3/t0g0SCrAkwBpYA17Q30/F
	TGVXUEJ1vwVPUHzPIq+yIMSTY371ChA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iFkKtYvd;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fckmtw5a6qdMAglllBfAH38thXkAD945UPCXBAhQnGU=;
	b=fn9nZE7u3dQA7Li96xi6KOmEBM+b6WI8WNWIhtxlOLT1bWvtPtQfa6id2KUO8qd65heNty
	X9PS7PXHrP/Hvk84OtIxsfWH9T9dCVhEmMwn+HTZEAfXNggjcGF1Kk8Q057bnlXVwYjN92
	2rx8Id8unJoyInGJU5kvZ/h4PW7fems=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-304ddfcf72cso5707789eec.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 06:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781011196; x=1781615996; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fckmtw5a6qdMAglllBfAH38thXkAD945UPCXBAhQnGU=;
        b=iFkKtYvdBFHleiitdqzFwFR0hPf37w4ijcw4cgsV1tO1IvarUELLlUfgWEdN4n5pom
         TeTpGqIKM+akEzAqGcyPamizA8pHHI5lYgCWhohFptEdVWl7wGhGrwyTglC5vLVSzYwR
         n4UKTnBlWj9ThfauHipCFxucTYWmnkRFeipnx68eDW8ihmQLFeomg5voFDASqrBtCEfh
         N52Q2PD25n6xac9CEc2+G6aR6Waf8uZuQF7BBjFDBdETVXxKeKmC2lGkJBifoO/uLhhp
         sMMJHtHS8qDFhFBSYoCAJFQI6tdKHKe6yGmW56Nb5HtC/w60+YF0mNHMGHZ3F+bbUNpF
         8Z5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781011196; x=1781615996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fckmtw5a6qdMAglllBfAH38thXkAD945UPCXBAhQnGU=;
        b=eIbVnrjN9+3+7HKBN92mD7JbQumINETxuN4mFpEkFUrb+lnr7t/5CAxlgx/mjisOrs
         GgOLzfKYsTC6QyCD0Rigz7qYVggg4kDcsmbK4tbW1wc3Ib8byq1aAHyqKmnRuO44fSJ9
         yexFIDy3VkSqq/M2jNoAnt6HUmnfKOh7c9CwMEucU0SpJOzJeTAWhIbEfOvUTRJiPKEV
         wrfR3h3D6ioStNQgoHRzA8jgaS7HVLQaWZKEy1Te6jhtimEYqHjRP70UEMeOcubF1bMT
         kGZnfMopJrKJZpgULpqO7jLbitRT5/hEs+AqKVVRQ6fh0nhn9PTnA/Bgq7OHI06hHlw6
         6aYQ==
X-Gm-Message-State: AOJu0YwMY8UHEiYepw7H8e2Ki7Zd/IuNL4QHMtrohnlviYZsZS/xz5G+
	JdjqHcJnbOJGkbzw8MYryHPyVolPzBBkQeOFTO0zNLacT/iW+5FPydgv7zHmlw==
X-Gm-Gg: Acq92OGtQWDYv6e6zuWIjrdSmKvxgqU8ifJBmoei4Sgi/jTWKTPgjGpNc8g5Kt7vxqK
	sMlLgdR34hzsZ60Mnk1zoStG4dplJArPEPltzBS+PsPIotAkewYU1SY1Fvob25vnDygThwj9P3E
	YC6wMP33+LMNcu3dDtpUl0mwmzyxz11RjADx6jR4fR81qr5teoR4TWB2V7Y7wCgYGrlUoobBTZz
	8JCLJvqcAQhKrhAS8S8ZQnNaQBn0O3BzfTiB7nTxrLOkpTlFWujqf3w42J51pxJ8Hu7u4JaJrKy
	NTMF0bcnPyqSC8wjk+xn1vDbbtE4ye8s2wWZ6mfq7QOy4lYsZrUrnWnypezUppUQgr9NJFuR7rm
	WHD2VGtO+ZzKZ4TKGrOzZwOKkYIoLxLmFTz1kWtMSxHKzmvEjy24MkfwfCo4o1TNqickKWsthR3
	SRokxh+V7EGGbZhdTRPBQcQ/XKkAAAwJFCOsOM1VJCWrEnzPeesWXcxusefole
X-Received: by 2002:a05:7300:7fa3:b0:2ed:e12:376d with SMTP id 5a478bee46e88-3077b358a45mr13893772eec.35.1781011195706;
        Tue, 09 Jun 2026 06:19:55 -0700 (PDT)
Received: from localhost.localdomain ([129.41.58.2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db55f60sm27162467eec.6.2026.06.09.06.19.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Jun 2026 06:19:55 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC 0/4] mm, swap: Enable THP SWAP for PowerPC Book3S64
Date: Tue,  9 Jun 2026 18:49:30 +0530
Message-ID: <cover.1781000840.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 15F9618000C
X-Stat-Signature: 83o6nr1sehfbkp5xjw81x4pjtea913mr
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781011196-420291
X-HE-Meta: U2FsdGVkX1/g6C5b7Zb0VX3vkZmdHZcLzkLSW5rYhu8iNHV+tXy0S0ECjHrCanHQZx2wBMWAFKLzZpZtOmZS3HbVFivggK/5IHCVGAmObJ+2OwTr0mHwCpfVxrT4rbdsTFArXWlPWbUGGaTc2DkBUkI1roTW++8T+qE6GpLigdp0ivaNKj6TpoPW671Ruhv6l83/0WmvE1WDBHo3H0GI2wjOwYnpNyLwqtkPUdLhe3xFhvoKRFekrkvF8DAhOpT7yotWh9pAoZRp/YyF3RNSgmm5ThqKKsQjXeJ8ldfLUOJxWgbHZ+GpwQC7cWlrqYaDJnjMo1fhWFxq/XmIijKdpYll99GnSTkQ1kYoOz5Y1YZXPmckzFAVjcaS1lqljaoBEbtkQDiJWviUL6jRS3UiDdsTqkg380bEdtrBgwH5c+yPsDqoRmScO2LPbv8UtwRFT+E/jo3u7Y4Bv4jCkz4XV8qy2NUgRtsLynd6ZALg+bwhrKIqfkmgUGFi7PTjsv26C7GKeVtcD3IiVKsVjiAAL6JzyDixuDuJvCy2HfQLOv2ezvNJZAqLK2U6hS7qxghWCRYm3+3BCMtGK0aLOGwPc+5AhBUgIRkhIKwrbOYXGOcw8LA45QJntmJHUDEjA9Yc9pO1xCO+tXEf8FcQNrAXf2ZKRdVQMpp7RYcgiiAcouFfy86pVTQJuqKVQvJGITKayacVj3cwETPOTlwM2vfOsgmEa9kkM5qzo+LXjClExo6nmmydV65s8mHiBuz1oTjjPVeoY0Zh7HotJrYkHph/WwDs+FWFu8F93li8XMT23NLx6BvOoJzDP4RyXxlsQ7oDlohLL9ttlOH3dixY6MQOCMM916+uEhAMyMqZqaEKhSzYfjzG+d2NLlQeBUk0UD0NUYSjjBLErBp8+k+Cn76pzfMKLg4+ApMfE4RTWYR29KOZAyIimKYbXCPB5m1rAmAL5RiG30zMGFTf9jsDt9W
 Omccnuti
 ZR4GuAIOj+L0g/Isb52OI5lfYSN2MfAC49thXsPwXuON5hA9fgfXj40SLL8SIdWK/npUjSGCLcNiqJXpjayI8dUnF9m0tqII4OUwrveoJjHz5dC1CS5MO81ppiooRJ6FCBLFx9e3elIHoHnh3zykXkxxvp9z9s77twOLmiFg2zFAwwpMyfMyT0lNsM3tys7HusFQKbM/5FuBmrazAYfiz29bc5kp3LaCLuotvoCU6X5s3MQ94tvWzBZjx7MbQUoJfc5BFfmHQw26+6DovVJcriuaXkntNz9iOGyv/1TCnB21oU33u4MgujppzeQoEvPQq63GE7u5wIaQ6eFEPGZ5l+CW4sfIS8Mx+P0B5GbPCSrtieKsiNLsPXKbq4G5ZisgRCHVWvIe8Z0PQK9ceoW3PyZpu0KOZgDgTPNoM1G39YIH0QKyPGiv/6biaFeEn+xmcSm8x4DIbadfGNwuz4odnUGsjQL0UbDM1AjRgxMQvxzhz4f2nUvUrSc9PiJTzZrp0kfBhCyFp7bVFKIsprB6zGUXnwtf1fUW7wELWQt9jkFADUiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On PowerPC Book3S64, MMU is selected at runtime, so macros like PMD_SHIFT are
effectively runtime variables in the Book3S64 code. THP swap code uses these
macros for e.g. to size some of its array data structures based on PMD_ORDER.
This patch series makes that usage dependent on the runtime variable.

Sayali did some performance runs of this on Book3S64 with Radix and it gives
40-50% performance improvement. We also plan to run it with Hash, will soon
update the results.

Note that this patch series is based out of linux-next (next-20260608).

Ritesh Harjani (IBM) (4):
  include/linux/swap.h: Remove unused leftovers
  mm, swap: make SWAPFILE_CLUSTER runtime
  mm, swap: make SWAP_NR_ORDERS runtime
  powerpc: Kconfig: Enable THP_SWAP on Book3S64

 arch/powerpc/platforms/Kconfig.cputype |   1 +
 include/linux/swap.h                   |  17 +---
 mm/swap.h                              |   5 +-
 mm/swap_table.h                        |   6 +-
 mm/swapfile.c                          | 132 ++++++++++++++++++-------
 5 files changed, 106 insertions(+), 55 deletions(-)

--
2.39.5


