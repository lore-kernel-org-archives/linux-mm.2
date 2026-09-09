Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B9BC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 06:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124D06B0095; Wed,  9 Sep 2026 02:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AEB66B0096; Wed,  9 Sep 2026 02:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8706B0098; Wed,  9 Sep 2026 02:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C457C6B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:43:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD650A00AE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:43:02 +0000 (UTC)
X-FDA: 85193281404.12.C498DC9
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A5FB1C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:43:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yj8IIijY;
	spf=pass (imf18.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788936181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=34EbQ0kkkdVKw0vcmyhvRZJ8gkzUUK1Hj8AwcwAqHQY=;
	b=v8fDRnTgisNssOpTcBszZn5ZWf3QIogCeHaLOg9QmzOOYgZF2S46o57jJniLa9fvlSG9WK
	L7vW2RCP1Rce3yagCTFHHmWLTUZRO//8BL7NAVzujiIZDrJS9MwGYM/5ZoMDqV4XcEnOY4
	Idx2LB/IJHbn+18GhUe96JtqXoqc+iI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yj8IIijY;
	spf=pass (imf18.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788936181;
	b=xO8xMwlvc9LvIs9F1AbYqmOSKRrfoicg8AAU6rUS0n3vwOZiPEHisPLBTEBgPjP2Wpxqtr
	yaNr9itPeezKa73q5IcSU476h54RB8CR0Nt28BysUvmsH8prAceOMB/4tI4nRHjgveKOcp
	ZEFJPb2x8U5VAuT4scn5lHLESK/S0p0=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47f96c5b722so3856461f8f.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 23:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788936179; x=1789540979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=34EbQ0kkkdVKw0vcmyhvRZJ8gkzUUK1Hj8AwcwAqHQY=;
        b=Yj8IIijYqD0oA23XWQCleBlbuZeg1W3BrrpWc9eA/PJQLtZMXRaOWpRFAk/+LyeWXq
         i3B4tNlbC4l7PCuW+03ImUO3/BBiNL/3uqEUj6Omi9yV1AjfgGg2FV+4cts51HM0u4Zk
         BYy5uE+8+7c0noGaZIkf+BtkhzGE8Jl71HGJfWVO0HB3ez/KhHdMxrPf7bD7JdvPlAo7
         09TCZTT6wXwsWGxcq9dqR25WoarZ2QQ32SM60/2WCWqOD1Qj90T7BTa11qHk3lus58Ky
         l1CUhS3EBShH8ooTInKGkVB+wAZ+0DYyWlaR7Qw4CLXyknl2QyCK2X2bin6RifXmhrrd
         eNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788936179; x=1789540979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=34EbQ0kkkdVKw0vcmyhvRZJ8gkzUUK1Hj8AwcwAqHQY=;
        b=VnX7OmbDdvcZfGHCL17ZWz+WHCHVRyZNZy8xQnH3vZX+ZtE8PJypDhHJQXyxzECYtv
         lhvfk6c/3RucXhFYZIdmNsmhR6x2uTbJetmzw+ybRT08Yi/rbLMA5A6Vbd3ob1bcsFUy
         H4WnfJ1ihENrgFxfsAMmccom0SKZqIQh81VHjW/lJbL5Okj6iwj8oTlxoeAmKaGhloRR
         5pNXm35qaXpbRH32lFWfCYTNmgr/+fa1M+BLgOSFQcPuq8zSRAWp8ylcbcTicZdtb8Rn
         kCe+TghRvTpb3QxUCagRoIMtWNAZSrkTvw9mig210ykaM86j2HrN82PYSkt/aH2+Xg8R
         5dMA==
X-Gm-Message-State: AFuF++nNx5hSOvcoagpAVHUFWNYT8aHdoI5JiNn+dnGb1y7ZPbfvz7vH
	YGg4q9r3ywaeP0RZmfeGgXnfK1r1wSOe4SXjm+erSBNanDWrlF1CUCIIOnVKKYFBuME=
X-Gm-Gg: AYBFou3aZ500yzgEOBoAhpFIFTY8TCjMHyo2CuzaPYH0DY7d8fTNRlUlqO0r2WJ6imY
	UxECklcXkbyqQCcjIE9CVDJExcL1gJZAypQxMswnQoTFKXNcVRKJoLlKqH7c6n7MsvbqLWCBU1n
	7fTm5iF0HWFeeksEB4E3uUHCioDyG4Gl3QbAtyzQy6SYz3SE2L8UQkQnseCnsMJUzcLsyDYBh2q
	MqkZNZc+Tjl0Ggo23LIVKrh8ooRNP9PJbYqrIXhIOx7inG79BXMWdQxWqR0cqoZTeCOwdMsCR8g
	si5HyD4TXXB2HAgEtgFf+jDZ+sAy4//jadXvHfTpb4lXR8aM4wpnFgFqtMv+mp3hgL9cnGFK4Gv
	oTwGgfsNshlojgSVH+P/+FkBD8zZzqpwt1Nfh4Ary609OVyH2IGqmAcW/rCMaQkpBLnyKqIrEG7
	wqsyNWLL4gpPiQSeX4O9G62suiC5ohjpI1uWGDltYP7RQzWuZ3xnAasdnjvctttEbk78CfFd7Yr
	y5foAnRbUhj
X-Received: by 2002:a05:600c:8b8c:b0:49c:e3ad:41d3 with SMTP id 5b1f17b1804b1-49cf7f4aea6mr327332105e9.0.1788936179364;
        Tue, 08 Sep 2026 23:42:59 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20dae82csm25030745e9.3.2026.09.08.23.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 23:42:58 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org
Cc: bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tasos.papagiannnis@gmail.com
Subject: [PATCH] mm/nommu: Reject wrapping ranges in access_remote_vm()
Date: Wed,  9 Sep 2026 09:42:31 +0300
Message-ID: <20260909064231.18693-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6oiqsmcphyg137ek4hwpmeqyqj6ucapf
X-Rspamd-Queue-Id: 3A5FB1C0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1788936181-490728
X-HE-Meta: U2FsdGVkX1+xZLMgjMhZLpEjCJE1R8zFFW4ESs5W9LOO76RxNuOWcjdDL2HlVshoXZW6LakF5wA+EU6IBW9Doqc0XmexhOYGWn+WYerpDxAExoTu89fn6OQOzkpghRVwEA/wkc0ofbUDBcM+yHbW6lw7BweTDhuKkZ4G98SnALz4RkfpMV2z3cPHZ97TNymfZse/aM3eOal8jgRrsmMnITyef8dd2vI/cxjyckwfYEw2FvbHMYL8Nzdm11Vt431mVB23X7Z8lP0UsbPoY6sSzlL4LaLWBaAjc5CaEVMQO30OfOsXG6ifAAMXcFzu0ZMQypd4laeCqjHJo4CMvkf6qgBWGNrUwmGcy6cDQ4fw+6GF3vRC/NglHwg1xe8rfI/eaIzPzETybUlxBsv120sS5MjIoy0bN/QwN1gOI1ShgeQ7z7dDNB61FrruGSLiCwZCgbCZKyLOEDiUth7G+9IR9CjVJYL3j50CMdvXN/V/khj/d4O/b16VcvRcsOdht9Du52jVDIeYyvpp1FOVotTou/puBvZs1eVNuTVnCUi0PHEKY49lmKZabDwIsBvbwkYjsZan9hlEjZiGWIUb4M3hzuTJT16F3qn5EE5BwgzU4D1KYrl45tEv6QIEq+K9gYfIB9ab5yHB5TwjKdSFntqNI2kYF4B3XIgbL7mOgPVS7GxL6yxl5tHIgggWDUUMdabmQ2v6GFr6a1iVSUuaVYVeZ/osuwRv7LVGD/MRAI51IB0MyFL1WDWnsL2REILdl6PurI31GIXV26eYOD0InN0XCkORVJUxenEDmD2ketb7SpMzzrQL7JLCUb34zycxzbLlIUVtEuPrS7M7BKkx0gYOIvyU9kZ8igbMtRZpdkxDP4/977Cx81OaJKmgtnyeLorU5jGL4e7eeXGrrlX5EvVLGPKx9se01+eemR6GWz0+DN9kETX7mr3X1p6Hkcela9ZEat3zTbpGjMCyfrxbQ7l
 rVrz4npE
 elxzWmPhxtpotL0Yk9SKw+x/X9AM4IY+fP5XlTKHQZUa17gGqeCQVSO0O2UJV8rshHTL/zpKy+2Fg89fzFuMXJjJnA4k5N7quMbevR66Au2ffwBUubALKHgc9/wSxQ7D4pO3qJKnBhdRwW9YbY6JIy1D2+gQamVaCvsoTAw3qAHY+5npxj+4Sl6LGTgo7H52K/pN4rYIHtg6x99lQ2jSefuxOjZgBfr4FFbCxNrZeubp0Ma5xsM+oFG8IFPtwSF1BI8u9Qn+K2YTDXFCg0nMaM6BkV+N+ft7SGE/jRZ8XJQX3dJOgA4VMpnyWQS/TFoPt2Pv4yRm8mi57mzA9NyiONeyNfdvVeQBL52TEo/5PYgokroC29YAO8Uf3JiBg9QvctKDfGbg+zvotLqnLqV6OqIjOakE+G6WHqyeKf0ebTZfJ9CMpcFW/wCaVECl9QKfYFcqSoHGU5riotkHRoBUBy3kbtTYA7/VaXA6F2xDjnP4TobMX9JwGq3qC+Gi5PbW9tNCOeS9BSdPFC9ZExldNt9WBuNfdkzvkQ1BKIYoXDnvCnHkMbbvirxegPx2tpOcdpBJU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The NOMMU implementation of access_process_vm() rejects address ranges
whose end wraps around, but access_remote_vm() bypasses this check even
though both functions delegate to __access_remote_vm().

Move the wraparound check into __access_remote_vm() so it applies to
both entry points.

This is originally reported in [1].

[1] https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/

Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")
Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 mm/nommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 498e01ee40b0..ed44510e3770 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1674,6 +1674,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1727,9 +1730,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 {
 	struct mm_struct *mm;
 
-	if (addr + len < addr)
-		return 0;
-
 	mm = get_task_mm(tsk);
 	if (!mm)
 		return 0;

base-commit: 0d9ff90a5422cc7509258aaaba1e7481df4d332a
-- 
2.55.0


