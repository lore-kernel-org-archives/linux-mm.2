Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC84C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5CF6B008A; Fri, 18 Sep 2026 05:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865AA6B0093; Fri, 18 Sep 2026 05:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7555D6B0095; Fri, 18 Sep 2026 05:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4637B6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:47:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBCA912061B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:47:07 +0000 (UTC)
X-FDA: 85226404494.21.FBF52C0
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf02.hostedemail.com (Postfix) with ESMTP id 159EC80005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:47:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=idhETmnS;
	spf=pass (imf02.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789724826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JVl7uqBilEpabcfZZkc7pg1MsdjTOvZRzrklboh2FZc=;
	b=ei8I+8bw0KbIrwCEU3D9spmhLjXS+07Abe3xIpLw/HUGkbTTic13XwFU5KcHjD4oJ+eMg0
	PJ/aX4fNO+U4mZWkrsJPWNQ9QhQVL+H5fXNxwRIdvSXU0dqr5cAx6061nCNFaFPgf2ipEE
	jwGYrp/njcr27megK9Knch9hUbfk43Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=idhETmnS;
	spf=pass (imf02.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789724826;
	b=eyzfko+Gc9QHhrjCnZAUdVK2B5bmFSaL7ghNdWoUApvMYNra4izguoj77iFVOCcsyghIKR
	kiAgPHU9QmqsvS2qEuHMiSvEJed9XtRBD1HXsRFTuaj00pV2rRJe0xs3FKcNP8DHI9FIzQ
	sa5i1+422g7yQJyQ8rq5//6sMS1TCLw=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e64ccso4394625e9.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789724825; x=1790329625; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JVl7uqBilEpabcfZZkc7pg1MsdjTOvZRzrklboh2FZc=;
        b=idhETmnS58mJMloZEOVcbJp6RDh/wxmeUMfU2H1p53ICMOXTkJ8dByAie21Ez4u5uJ
         ErPznxCDCxs/6BUKigre2LDz9bszHB+Ko+ss5BvqAKDMGZxMzpOwfVp300IPpXT6bRIy
         cNSiKPkm/YgNHLJF5NliX4bUcoaf+BqSGjx1xlrTiudFnkXUOmYPrUskNtD6cqC2rJVp
         ZHaGpO3synGKqZu0xtJh3fqaBR5F/4zuHMp+7GuWPPZQkFz4LYsC1tD53lISoSyypprm
         vspPz7PZZ2aN+pN9xLROudRV3xX/IWQ3qb2iWD/j/ltSOBWw44dP4ql8PfyXEIrJc2zf
         x2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789724825; x=1790329625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JVl7uqBilEpabcfZZkc7pg1MsdjTOvZRzrklboh2FZc=;
        b=Ikn6IzCpy/HXIaIKHLGUCAesLrs45ZHq+VPMLdTXXxNmM+bIQhvFGVagZj/YpYQ+f6
         DI6vD5jiubiTxBgw/Zc+pNkeopyz8L5nzEjaBKSW+yYkWFv53IvY1NoUsmNSdIyTIt8E
         H7zYCN/RiTGiim3yIVeJQ4mf31uOuP0tCPvY60YHzx0nm+2OI4Jpx5V/zs5gzDUJ02RK
         Yu1PKw/RFz2QZApPhM2h6+fYgRGsR5mtskTgHXc4LMhPGc8m/w03izZL6at3FppK+UDB
         N1C6hpo/LRDJBuk302wlxkDL1ugCsvWpNSTB74GWEJDoMyNBrQRhKrVYLm7zs6P65Ygu
         mvPA==
X-Forwarded-Encrypted: i=1; AKwUvByo4+CIFRgOI2/mjxFf6sxDbOhdJXsLJ+XpiG0exMKY3KjNR/0uuLQj/9HOoVWO2RjIfc0z9tY2Wg==@kvack.org
X-Gm-Message-State: AFuF++lLm8oMEtrYb8+WR2pTIO1+wmIGzqCURo9QF2h5iMQ9PIy0/ShX
	SH2IV2NuZtH1xQxrII3SY8HSmmM/fgs7fBZAaUDYIp3zsW9doNhlEek=
X-Gm-Gg: AYBFou2aMQNG8ozN9SvpHZ6p8zIdhxU7iSwQT8irkiIuLwh95kvuVQj5PZOc+NR8yXI
	6SBtaVnfoS8G117iEADopx+yuRspJdorfVcjo+EML0Fy40vAucWbXT5RxPYH5+9I8oxA63Ac5go
	s9X+UKwqErkx9t07vY/TFE2p3wD8sqnVp8/Q+3RfEfWtMt/Aj+8NuqaofaWrW1Bk26SG6Lx1ZHB
	n7Mm/Lb4YIfhXRrOQh0v3XrE5DuWXXXV+rtG2iWwNqKdZCzmbMv5IC+4q7dkl9DW6dm5Bv8wmaC
	LLSXfup6BjdIb0ED1dRJG76iVQizcD6AhPRzb7U9Hular5l1LO9KCzeuotieXW0FXmTIbJLBm0S
	kVildLBvGZxCuWeew/MeTQw1m2gOcXLsjqbUyvVZq9xapO45wJlzRbXBwN7iB0eoGuYzyl4KyH7
	4xuHT45IqF0GWJLngxU1u3S4/3924zhokAYlMbJ/ZMaSugKQgRwc6YRnDRUhMyM15dsnytAwxlx
	uwg6Jlzs6Lb0G0Obzz8ZJv8AGwWkUgAsPqYq7TQtPP55OeDTxO8zYiQ1uoX+RfpComha5TiwOVo
	U5hqVTg=
X-Received: by 2002:a05:600c:4e14:b0:49f:bd3c:bc19 with SMTP id 5b1f17b1804b1-49fc572eff5mr23057365e9.20.1789724824379;
        Fri, 18 Sep 2026 02:47:04 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-487200829e1sm3054971f8f.34.2026.09.18.02.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:47:03 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com
Subject: [PATCH 1/1] mm/page_alloc: enforce upper bound on min_free_kbytes sysctl write
Date: Fri, 18 Sep 2026 11:45:51 +0200
Message-ID: <3c1598eaff225a155cdec5e92d5c97fbfc6c00fd.1789724312.git.med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: e38dxukjtw3u9sawh8514p68tfi69991
X-Rspamd-Queue-Id: 159EC80005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789724825-237053
X-HE-Meta: U2FsdGVkX19IVQ/23pOsxOK9Q5Bp/6cM1J1aK15+eUv5IOAtvtCrpZXizGlRY3WF/43jFcvGy0n6wnsBIQqzcKnfzXtiqIESWkbzEhUCYwBlzD1dfL2HRxWaD9hvlxvNTeduQcKMq3KghV3aJbLiFuRkIx8sv4Dx6JEL264nJ9LqwE7i3b1EFU82h7z35UpsNnqGXOGic3Yjh6T5svQsI4TK1OLUYH+/OmyPQc8EaElYzXPsm0UiAR8EZv8lIAa7SQNMiJIzEQsLYyAfh9aFbneNtfPtdKLH/IOn8Wevx3mSml8yadhx7dGjt5QhD9kIUWJRj4bi453ZanPmkdV/f0C3Ry75O3W0eOBLKGPrVI61BQ79n6iCK0Bssq1mbsmxtPJlpGCbN1vApto8XeEDD1xb6PR4CmR0W6Fc8iTGUqMURuYquGs1cPMtzyGTBRPlnfc8O54l8CPj3vuPBSl2rxMUpcLEVswKD5vUd9pbuOaLNquAa0424l97fxerVmq6Q88dJxsIxXLEMjdGEgMAqLRlU0Qca1unDn2XaHQ074kqFtPaO38TXNqEdz239hYiKgdR/wY5r9uIu5ftvLsWV77KDKRYLLlgf2XjcvT2bWJVBeHMjCkl3SpF3qcJJBQ46/9nvo9Z2rNWmxmqLvwOKQZaI/11Vf92qJ3O9QFtPL7COB6EXfzm9+7Fgd5c50Kmr3FCwbovpuyndcMkx0ghkXOr7klF7PwvmNE8UvRnuDk1VpfILSMVR3UQQ6YDHpqRDjxhfOiGSamtvPuQx7Gr//ezhn2VtHjenCbHQCpthm5r8Xm7gk3cUqkC/+bQIdd+hZsmnQvVnYFtoIotwaYLSgEoslSlcVRxyBkD36OLJ3krMOoWL6yjYs98Cmm77k1lcFe8RgFpJcmcvj6tjeRuIg6Rlza5cKLOaqRngbJepyu3ottsiETqYgF9d04y4IlA4Aq8Ye4d8qFPvOE4lKB
 k1yYAxi1
 UmZEGnI/m+FkeGpwq1ppwbOGSPidOixmQqtXolpkaQaNMospBkKZ7sHbtdsGydXxAWzGxukgkrdh12ho8Xj0aHsJtyox53DJl1UD5X1cmYRhHby2wkd2dkMvX+OJ4LWYm/p7KYsgGt734BqixA6/IcyYHXET6xkanp+k7rC3gRD+tQId/UNvQRCHZgfM5Mn1c7hCSZQbIJYA63qxEGZP/nQtWQxvKtKiOzAvCrU/KB/CKLJMezOrTk0/5orWvzkuUsNe6ClAYd1fboqcqu7hIKhse2qfekeIQ9SbepPBM1ayamN0FoX2suYCU8oBXwEi7eUPryYUnMeeok11wb6G0kOY/t2jMs3F84whUO6WT32tnG1hDAENZQJFMnSjdSJDZ+zmr8BJoDEICfSgWafMRFSHq0uE+m7rtFYszhmBtwSoQJyuOXSnaj+a6vzGY8WEsQ2I+dnroGJWIODLOZc+e5W8efkUjd1L43Pk0yPNfLec/o5lSnfjc89Wbf544v51XoP9JVaNkFY//uqbeU4l6IEJ4gTyWM5jh2jaXCxXB9zQUJmfYwMD9Ib6bxefeIVx5QNWIOl72s/N3/neEVpO+Uhkey+J8kLiKG6xsAxKO4AKJUfV0Kyh/rkufD6Qo6NlbU+FQ9J8ghClC4VLCZTF6932r0UiadG+oCvTRxActmfUU0GmiDQx852jzRFwS5Yv+CUxUB8gQY0cntpFx4Gl6Or/B3v/LQVOKwnDYDR8VqRJjFhVBViat9FPRUUX9JpgRjqQi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reports a kernel panic ("System is deadlocked on memory")
after writing a large value (e.g. 3145728, 3GB) to
/proc/sys/vm/min_free_kbytes.

calculate_min_free_kbytes() already caps the auto-tuned default at
256MB, with a comment noting larger values don't make sense even on
big machines. But that cap only applies to the computed default --
min_free_kbytes_sysctl_handler() lets a user write any value, since
it only sets extra1 = SYSCTL_ZERO, with no extra2.

An unbounded min_free_kbytes drives watermarks past what the system
can provide, so every allocation triggers reclaim/OOM with no way to
make progress, and out_of_memory() eventually panics.

Fix this by applying the same 256MB cap to the sysctl write path.

Tested on top of upstream master (5dd1818b15d9):
  - Before: syzbot's reproducer reliably panics the kernel.
  - After: writing 3145728 fails with -EINVAL, normal values
    (e.g. 200000) still work, and the reproducer no longer panics
    the kernel across repeated runs.

Note: this covers the reported case (a value far above any real
machine's RAM). It doesn't prevent a smaller value that's still a
large fraction of a very small system's memory from causing the
same problem via lowmem_pages in __setup_per_zone_wmarks(). Open to
a follow-up there if maintainers think it's worth it.

Reported-by: syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c61d6962d0b7e698439e
Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
---
 mm/page_alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..8cb62879bf41 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6933,6 +6933,9 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
 	return ret;
 }
 
+/* Cap sysctl writes to the same bound calculate_min_free_kbytes() uses. */
+static const int max_user_min_free_kbytes = 262144;
+
 static const struct ctl_table page_alloc_sysctl_table[] = {
 	{
 		.procname	= "min_free_kbytes",
@@ -6941,6 +6944,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= min_free_kbytes_sysctl_handler,
 		.extra1		= SYSCTL_ZERO,
+		.extra2		= (void *)&max_user_min_free_kbytes,
 	},
 	{
 		.procname	= "watermark_boost_factor",
-- 
2.53.0


