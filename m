Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC87DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834D16B00BE; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C176B00C0; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7486F6B00C2; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5E26B00BE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53201C1E79
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:06 +0000 (UTC)
X-FDA: 84935760252.30.8A15E56
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E58680008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=OgizoVBl;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=IH5CHeN9;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804724;
	b=3KVvqoApakfOuPSuE0z+W9nc/BLS+41umXBxkpYzAn3PEF341jYuuDcKdZ7wz03nwwdSQz
	ez17l2gHQoPVtEfcmfWjx5qzWT8J0UUQyElbBVxcZybBToVCOC8LQ0Ph2NMHGVMIMCRwgo
	Dc11A+JLu9mxA+3h+uhD5OZjfstPqsA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g6q8J52JRPYsbeqFtRfjFwg1P4OIXdiBDnM8s0jQSrI=;
	b=ui9rAjU7pnJRTvuP8Mi+7ob88PUXfsrm1UCWXm1lhkmdWFmw/hiwA13Q/On+H/0ULdcw2l
	eG653Wyur2g71AvmDCW5ptIWisRMuZ8egtxpp/pGKYH1wzEarWK40B4Rcz1ZFwq5YqIXAC
	lzLfZAR8o+rrN9GAxfPqQhh2w9qa4yw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=OgizoVBl;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=IH5CHeN9;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782804722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g6q8J52JRPYsbeqFtRfjFwg1P4OIXdiBDnM8s0jQSrI=;
	b=OgizoVBlGSdoNhfAW113ezv2iMgX31cW4yKE53fp8st3R/A35ngxUS0PM0Ficp6lUIQYJ4
	HSegIGGs4ALanutJoFoOlDAtTLQwnUTzsrac5WgsfYqoA9/VgITDwl1Eeo8aIGPTv1gepk
	3MjXFeZCVRmSDA47C9CiGkZ2JNpK2y4WWAcK8LO1ynk29JUf1i3L+vF5WWagLzbym94AEN
	OHIoZYGNW4+umcyAHWkfzxbj5Ln3biwIZ4d3a/ysRYVuW9pJ156jwjIOLPgCIwM5qyqhPI
	l7JeC32za1GBDLugTMrA6DqvbOpPRm8HgbWj3g46lRIfzHNB7lcMtwqpd2SXXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782804722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g6q8J52JRPYsbeqFtRfjFwg1P4OIXdiBDnM8s0jQSrI=;
	b=IH5CHeN906UJci+1jnRW1pUdrxTPmHnkypTarUPPQoxmNBwuOG2wKrlNIBUzWDzOGNbdkp
	sWF7Q3trV4/MdKBQ==
Subject: [PATCH v4 0/6] vdso/datastore: Allow prefaulting by mlockall()
Date: Tue, 30 Jun 2026 09:31:54 +0200
Message-Id: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23OQQrCMBCF4atI1kYyk6S2rryHuEjajAZrI0kNi
 vTuRkWE4vJ/MB/zYMlF7xLbLB4suuyTD0MJtVyw9miGg+O+K81QoBZrBJ67FPi5D+3J9D1XFVg
 rJQptgZWbS3Tkb29vty999GkM8f7mM7zWj1QDzqQMXHAk1VizbqmGZtv74TrGMPjbqnPspWX8C
 Y2Y/5KxCFVN2lQkpFT6nyC/QiU01HNBFsGSIjSEVgHNhWmanrNfWSIyAQAA
X-Change-ID: 20250721-vdso-mlockall-461bb33205b1
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804721; l=2808;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Qk7DYFUKXyi0OoTm/6+Kd6bYGXZgByC3fku7LHCQZy0=;
 b=5v71y0CinDj6GyMIadfNCwlSnCnHlgj52Vc1+zmEKEY2yUfkVo5sXM5N3Aaw+eXrjWiFirFEl
 zKY5Rc5wemACnthbAReZiKzFFeu6SzfyZRNDUMN3NZO+uehT1l0Cu0d
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: s8jfdc3ghbyp844hfrzky9unmp38xpp1
X-Rspamd-Queue-Id: 7E58680008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782804724-601056
X-HE-Meta: U2FsdGVkX18U5+4dKFrW3CGa5q8aQgPV75nmzo9ILWn7AChkYoxHzMDNh2VFRQPDl2808uPNEWMLy+RPihfpV8ZR/0i5KUJ1NqNBBy3eFQL5nspCUov0M24SsO2wIQEVRsHerZvk/91RUwNxOTX2XbcB+bFFKGQz5pKRHeyR6BCFzb8sy4UC5sOt0m0UNEYsPjeoK2tJekTwd6nkNW+KTAYLp3Ro46BPYWWpxogSdgtNAf+qonBIElFTt50ULX+goP1vSq2pQgbL0UvTIoz2mFGYAtT/X2lqzveDalSPIehhAgDv7Y131+UD8QyVsfsGf6sXoU3LYZ9tAqKBGzPxaNos3jrP1eGwPOgmlOyoM+2L5il6ncxgk1d1zTuiJZGe/rg3dowuqKJrjAeXx9tE6ecTQXQWE78zhZJi93tWJHQ8ngYgW9qdcfeQCvhzI+lfBxxvBrgZzUmxQcsbF4biKFKLt8tyHc1BM1QDJhGDR3xDdXB+/yS2K5/4XUOLeRLMVS7b/HKNDTlwdTlhiYOg+47FXOkTFn8FbEHssux2/cP+VD79YMwhPUH4O5jVj3kn1LCJ8nVNMKXkWelVh8oIr4xP4VZp4fdIBORTIye/vjIhnkZlgRuD7t6MIS4raIte/iRIw6jN6Xtzac8AwZOhFpbo1lHLSLBAg9zht/rEXWZkU+EWMmWrhuv2lUlXOB2JcJZDD1AkITLIZpRUWWBSZp3LSYpEd+Ns4x2sW8boa7IhwIYSPRrazRjH8vs2if4ASDTlizcaq5uKpPs2D/Aby1v5QelMAVwOiyAs1m6EwJauG4PZ9H9AAAsKH9MsyjfgStjfuAvGKj+ITl3amCSnE/ZWBsbfUYGqsYYhNjIUtlQEexS4KKuwL8GefWI+CI9LlGPUvhV6Zp6BMsc5LwY2+E+SC7oCnaseXi+lSJ3Nj542F6YKVz/aE3lFT+ePQ96f8ROwLl2VAyDLcJAfvjV
 PVtbMG5a
 azaerFE/R7+Fr6kDWWynvzAydSrHmoYH7EzkjBkgnQp+jkIOIUSJdPon+tKhfkKnVITBV/Z0rcAYLfvAMJRfY+nOGxuSCX/ylbJpiDz0dOOO7FeKQKZ+iDPNFXe1zdAwzZnP+Ih4w5VPqlUGJ5xBXIxTUiFuFFALW5ANJV49bZ6Z5aJH3wOYRbpME1z0bN/uX6HVp4zgAz92FXJL7C9Mp4MhCmBtvr/LSChS59R3f63aRqlfENHNaQHO6zxePTNhSeVDwZA0u8H1kp1YQQe2YEH7bNV2gUOn3vIQCTnjepSVOdkEZ1awIM5bc7tWJb8HowdvBxhGNHthzbFs/GgwmV5qWIoY+tcvPqKXWyNa16ER0iMjeAy948/iaJjHTeKBWaJtzhMQfve18DZ42amnTY8AagvaOUAiKCEcf2+5NZQYE4ilPjV81lXvAqVS8bnxNGcxi3zF0CaFhvPmc9g9Fzho0ntrxon+/yWP8guqMqWkccEDS2JQWQaM9LU9bY15eOA5p4VtMp9Uz+wNjggE+17O1igKMoqCM+lX3eh95vSfHlO4jy7CuSGxJoztS4AHg54lVMYvTJj6h15YMvzOVr4VeZmCr5oifja/yabCTVHEtV4TvEsuo19NMo9jc/+7JbcbCDv5LTvCydo6JH5TWLpY+JWjFVKOjTVSzOJXh4BOvJSD43lb32omR2X8wnkNAtnLfoAfcIbDx1fbaiVDCRy1zESS2RPC5WVbw9y8RBrjwkdeynyaZOYtpXNb6DZ9k2N7mpEF6mmP8dOudzsSt9RKl44JfwIEJ/VFgHmxzOnoLAUwoIZcUSWPuVnUQG/U4OTdCnPxNIV2dXP6h1Qk9kBq3HtNDZWmvGbmv9TnmZDRMa1Vel0g3EIRnHdzCQZP8GHEYNZi6ADa8oT2EV5nMGL1UbMNIZqwsnq/n5xMRUHXlNyZFT8F1A/ulGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While mlockall() is meant to lock page *memory*, effectively it will
also create and lock the corresponding page table entries.
Latency-sensitive applications expect not to experience any pagefaults
after calling mlockall(). However mlockall() ignores VM_IO mappings,
which is used by the generic vDSO datastore.
While the fault handler itself is very fast, going through the full
pagefault exception handling is much slower, on the order of 20us in a
test machine.

Since the memory behind the datastore mappings is always present and
accessible it is not necessary to use VM_IO for them.

---
Changes in v4:
- Rebase on v7.2-rc1
- Extend commit messages
- Link to v3: https://patch.msgid.link/20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de

Changes in v3:
- Rebase on v7.1-rc1
- Stop using zero page, which can not be mapped in this way
- Link to v2: https://lore.kernel.org/r/20250901-vdso-mlockall-v2-0-68f5a6f03345@linutronix.de

Changes in v2:
- Stop using nth_page() which is being removed
- Link to v1: https://lore.kernel.org/r/20250812-vdso-mlockall-v1-0-2f49ba7cf819@linutronix.de

To: Anna-Maria Behnsen <anna-maria@linutronix.de>
To: Frederic Weisbecker <frederic@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
To: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

---
Thomas Weißschuh (6):
      vdso/datastore: Rename data pages variable
      vdso/datastore: Map pages in terms of the faults pgoff
      vdso/datastore: Map zeroed pages for unavailable data
      vdso/datastore: Explicitly prevent remote access to timens vvar page
      vdso/datastore: Allow prefaulting by mlockall()
      vdso/datastore: Simplify the mapping logic for VDSO_TIME_PAGE_OFFSET

 kernel/time/namespace_vdso.c |  7 ++---
 lib/vdso/datastore.c         | 65 ++++++++++++++++++++------------------------
 2 files changed, 32 insertions(+), 40 deletions(-)
---
base-commit: 0f4c4aeffbe38fb638f9a978bfb64caa582c2681
change-id: 20250721-vdso-mlockall-461bb33205b1

Best regards,
--  
Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>


