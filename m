Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF03F46449
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3CEF6B018F; Mon, 16 Mar 2026 06:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB076B0190; Mon, 16 Mar 2026 06:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC996B0191; Mon, 16 Mar 2026 06:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9026B018F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:45:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32007C09F4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:45:51 +0000 (UTC)
X-FDA: 84551595702.25.C5F25FD
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F7DC140010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:45:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DGjdmSK7;
	spf=pass (imf23.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773657949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ubW1SAZoUmH0bsB9ImpSqRcmDeexO/GRoosaLSx4hpI=;
	b=xiFS2EiSXkVtrjL7khRRd6DPficG9mc3WZY6aPChSmeLF61T+XHKCExbWYUnKPzY3dtkoy
	S3oJ8AFOvLjLJI/d6IUnX9+q3YjJy/wIcu2jtegl+iyHzEsEHGmpZcdvm0+9NXvyOrfH47
	CAT04Ud3M7ozae3WpKDl3VvMVG3E2lI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DGjdmSK7;
	spf=pass (imf23.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773657949; a=rsa-sha256;
	cv=none;
	b=J36tdLKZj7WPss583kfX9uTIlabu/9BQi5WpfRNaIFoB70hlfSH/ghkN+6x/5YJVkeEmn0
	kz9meU1lNwqaKW6o/+JB6McoVvItFASBFx/NhCbXUgygsrLFj13TLiFq9tIAThop87b2tx
	iR/KGHN6SMa63AtC/ir2lq42QY2YZSQ=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ad617d5b80so30941315ad.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773657948; x=1774262748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ubW1SAZoUmH0bsB9ImpSqRcmDeexO/GRoosaLSx4hpI=;
        b=DGjdmSK7mv/K2xjM0Yqw3pIOwBYmoybDQj1n4y47WuUwAttxIHPVScDtug5HAcvdxj
         aT7ohpaWugxgRtyx4/q+HdJLo+vf4jRtI74acPvihfUJPuI/sO1evRK1cs3pHZTkYl+t
         N5cgQrgrArd0KfHB/Y3mPcE+mtMKxSc4YK0IlsITGyQlgnUUCXMWwn+3EQEKXqpZI+gU
         MbbyUz8as9aT3spLfvM8/x4G1UhHNsyfrho6ag0TOlymCFqdeypD4bW/OWTOeAPu2IYd
         FhvxQjG9fk7i0YW1WvB3MNLKma+lPSauclvfek6+FJPdGI0CVqFbTzhHukRuCjdE+iHf
         Rw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657948; x=1774262748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubW1SAZoUmH0bsB9ImpSqRcmDeexO/GRoosaLSx4hpI=;
        b=eVz4AZdJfWk+fe5sXazeVuzl84PDN838IXX9I41E+IYM1EEj8Ic6U8A8qL4906NcX9
         GwWCxOZz3R1KGXzbT0wQGo6k/tyqoaEZFEvEtf4v6YaPD0BnlFR6aOqHZqaE4m9s22u0
         xyA+XhmxwONyjuX1/8cfq6fEqpizwB6d2mf6rleYdoH0NRQL36yGQ4AxaoyzwLcOkqVO
         P5Q9+YTjjFYIlU2pO66Yow0WgomL1DCoQqJw5HWxqBQFmOob0UTsnp5rRDZR0XMlS/lQ
         iUzfo9Dt363A7xPhIQ5iNYVkcCPC08N1YkS9lLTh6gfww1q7NxiVzRZGHZVxYCXJ4Fxa
         pELA==
X-Forwarded-Encrypted: i=1; AJvYcCV2AxZb2fylm6oDQQWYky4Sy1tm9+KKSM7qQKeL4FLwMz8bHY8pJbAHLq+uG2tVWPTEFQMMMq8vTQ==@kvack.org
X-Gm-Message-State: AOJu0YydfbAK1HdhE9HGk9bMatK7lrvlH1b9NxHQZW8qPu5YaUEAfbNt
	MjCkTutDRlblEh4PC3/ceoOaGSp0J18d2SyHLI7/W7VHVt7QhdQbCRxH
X-Gm-Gg: ATEYQzze5GHCpBBJLL/oV2QzpN9J8O4XPxkpCufUWAwsfXPClS4B/yZXkvtnAQGPyV8
	B9LyTksXT3U0mICDpj7mkrh422hVANuxAp0phpFbyDbFkFT4+S8n/22ju0yq89C+gx1CWcsJMQx
	TnEtS0OxuZDQYM4vxOS5FPSkeat+mDIx8lUMVxrFoRkOT4lDwOghXpLzsha+QKgJwJAL+ahd54i
	BUj5uyzJ3DDg+CA9E9jmiJGsxx9tqCjr9In007XcDUcH7tXapLkQh+UPmr8pDm94FmMbQqqYEgs
	yqK1p+Pd6CFg4dfopE8CVwHeDY0yFT+O3TeNdmKANBkEb3Yn8Ncxx7mDFDFr9j483UYXv220zZj
	iJZLj58YtYaSbnRdUbgesmnCqMHdVanlamliRRBpYdEA1uhd8oWxCu+mBfzF3OoNfuF9ymrBDQM
	D5nAWVyKs8rxx9mobRLxDEwpF98gfHx4diyjCHqdMDQ0jhb6sz/hNcvPl3Mcx4WPf1GDfYukYD0
	mUGXLE=
X-Received: by 2002:a17:902:e543:b0:2ae:606b:bd98 with SMTP id d9443c01a7336-2aecaad0c39mr127425815ad.26.1773657948057;
        Mon, 16 Mar 2026 03:45:48 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:e19b:34e3:1bbe:df72])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56c23esm133669075ad.1.2026.03.16.03.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 03:45:47 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kees@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brauner@kernel.org,
	oleg@redhat.com,
	dietmar.eggemann@arm.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH v2] kernel/fork: validate exit_signal in kernel_clone()
Date: Mon, 16 Mar 2026 16:15:36 +0530
Message-ID: <20260316104536.558108-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6F7DC140010
X-Stat-Signature: ca3gwpq68d81th8mdutj4gxj5nfmqdmb
X-Rspam-User: 
X-HE-Tag: 1773657949-886196
X-HE-Meta: U2FsdGVkX18QsQODmB29KSyJyKXO30JrknqjSkEChppwuZMHJE2eFzCMMjxThxblB/FvNSmC+dojFhRnbNXmETcUfPAxHU/uB6PeoQ0un+bgUgyuq+ee7iXMetIv5vY50GCrhC+ohwI8Qau5+dO6MvQpTKImwz3m6BTnOpPA2T12FP9TRPVfRBIs2VS8LzyTtwhuB7jrB3C1E26zaha0hP91C/84nwG5JOcR2ZXbAeTY0CCWVUMueqSrpXsyV5GpAa1F49q7UJHNeYF0ga89pBCE+pujnurOT4qqhwXm9QrM2LMABwGAARlduNW5VCRhvt0njmCugH4epf9QhDoD1iHWShsreUD3vEi4u/uOSMpHLgROP7Ew561JxiX37XlNlTULO6MP6K62iz8dcqGE4wgo/X84Uv3nBaz1LjBVg5gG9saGBfN6hbUr8HTloMaJtf+FejMJyAWBHmM3/qpf8UXF37fcOXTEoJSuj9YiGRnBDgmGWzlQoE0vDfhINNFilwbJHKr5iWytidPmsZdGa7AzTXfMyHVfgw8WLcG4ADIq8wCB1tMlUWkG2kY1A6meevfuCOG+ljuQxC5fBW7IKrlDy5QXIJfuIXjmsFslohvUxFZWzy37YHy49Fz6+S3Z+jTxwDFkUa8VA5Ld+PY7yx0CPYtXyXd8kpCuVMdhv8huDAckSU7ilVDxJftKB0YbOLvgkt/qO4mcnXWtQgxgOvPbC6FiMW6LH2RYWvlwnLONtndyYcPBPR/tP/yAc3+WeeupnSNH2AAoiuqBtFfK6O3n7EoN00e7R3y7+GSwiR3ebuta6sHN3iZsp1T5khugMX7vIbQZmwFO+bgQJWUfWClaMBtaw1MKtd8xTaaj0wIBD5VWxPAVSxSScRB+QXs8i9r0r1WD0sP2nKmgGCX6UwoRVYNCGBB9PU3RcO4fX5brT1jaoHMXqpCAkBBSyjJHc4rlqTJvnfkPoHx+NqT
 /hOh7b/b
 Ohwu910NnQLmS+0J3HCYZo/AtjhqaO9mbyqd1zxV71aREWbFdz4Vv++KtB+nA1O8JfLs7QmcVA/1BMiWFdV/tpUkdY6jEM9sugWXDFS3I2NfL8Qwg1RNHUR/UqZUzzo90PfPf6gcCLmPrUBo5yrwdBoTS1jr6SuYDgfiKX0mN4f48pF51rgDKxXuLgncZIjDg8k0E4lViUBkKLzGstXSEZQSpjb4JgaDfXEVFKDd2eS/u9kKyVrVDZlX0p/hVU2R9/Dc2Kzq9in2H3+5oTQA+mV+HiFBF+Q2bXZdIzpHpKgRkAhBx9hZoOUkqWlsI+Ysl42blXML+P/u9vMgjVZcB/eZW00cMKPwRZa+D/cWu/kPMONg0s2HI5119asJjrnisEStTqVzc3jG12X/gJmCTKnSBzbQEeRFXZKI7QWw2f/wS8THfxwpM/271VMFflOauNTtm6fGWjGnzH20k+WkobD6Otzo2Cn9qibk2Qigls/1F7ImGRUhn5PpvT8FlqsTmC2sbee3F/ViFUTUD2Pew3kNNbcZUGp3a+gLzq9mFiOCuBPziSMpBFojTmBjx8BOFlf8Ec+3bHZfZvkW5BYhg/QJfx2m/wnHiOi4aIiGRK2kGtk5OXeeJxYM+/dxOVSnnWBuhtebUZPnVbYNk5z5LkMukAQtX1V8wPRHcQ1MgFau+RbJyVtbgHjZR/Sn9m0783E/MxJF7Loc1zSQ1Hh8IDvypcGcDGBJtWxtV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a child process exits, it sends exit_signal to its parent via
do_notify_parent(). The clone() syscall constructs exit_signal as:

  (lower_32_bits(clone_flags) & CSIGNAL)

CSIGNAL is 0xff, so values in the range 65-255 are possible. However,
valid_signal() only accepts signals up to _NSIG (64 on x86_64), causing
a WARN_ON in do_notify_parent() when the process exits:

  WARNING: kernel/signal.c:2174 do_notify_parent+0xc7e/0xd70

The syzkaller reproducer triggers this by calling clone() with
flags=0x80, resulting in exit_signal = (0x80 & CSIGNAL) = 128, which
exceeds _NSIG and is not a valid signal.

The v1 of this patch added the check only in the clone() syscall
handler, which is incomplete. kernel_clone() has other callers such
as sys_ia32_clone() which would remain unprotected. Move the check
to kernel_clone() to cover all callers.

clone3() already validates exit_signal in copy_clone_args_from_user().
The comment above kernel_clone() states that callers are expected to
validate exit_signal, but several callers never did. Adding the check
to kernel_clone() enforces this for all callers centrally.

Note that this is a user-visible change: previously, passing an invalid
exit_signal to clone() was silently accepted. The man page for clone()
does not document any defined behavior for invalid exit_signal values,
so rejecting them with -EINVAL is the correct behavior. It is unlikely
that any sane application relies on passing an invalid exit_signal.

Reported-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe6b99feefc3a0842de
Tested-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260307064202.353405-1-kartikey406@gmail.com/T/ [v1]
Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 kernel/fork.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 947a8dbce06a..89d7eb67baf5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2687,6 +2687,8 @@ pid_t kernel_clone(struct kernel_clone_args *args)
 	    (args->pidfd == args->parent_tid))
 		return -EINVAL;
 
+	if (!valid_signal(args->exit_signal))
+		return -EINVAL;
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
-- 
2.43.0


