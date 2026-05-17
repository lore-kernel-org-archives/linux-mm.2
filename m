Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231C0CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB2A6B008C; Sun, 17 May 2026 14:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8820D6B0092; Sun, 17 May 2026 14:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFBA6B0093; Sun, 17 May 2026 14:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF8F6B008C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:37:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0652C16117D
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:09 +0000 (UTC)
X-FDA: 84777768978.11.3B8C1D2
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11BB2160006
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="O/JinnuG";
	spf=pass (imf08.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jA0jwO8NqAbbwvetC+CA7ZxVTwLGbB+JAjjbDxxkNIo=;
	b=LMSG0issjhbQPFb//PeqdIOvTzRuQqu6PHbfnLku3kCyXI/Kqz0TOzf8I2AqBW0y69OfRQ
	QO2oapstQ6XDUd+IuvcmI5i6Ad5En0ab7W9B6AqD8Gyon7RRcCl3lv/8X78xLcb0Q1uJr3
	rRRUd+SH/tSJgIW6uHlFkLmkqlTIKPQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="O/JinnuG";
	spf=pass (imf08.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043027; a=rsa-sha256;
	cv=none;
	b=oi5djN7DUdCorPjnjFGHiesB+2RGzHPTlG1FGrn/V1VqgCHS6cQLmlefa2PSOa41IZfMpO
	4WgKfSwFPcwYXcV1dEqcj/CNzvJ36aW80EwE8xBhCmtSQjW/lSRhOOmLQap+IbiR7RislG
	wy/njm/TMmsP6/LfSFupt/71YX5rU4E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jA0jwO8NqAbbwvetC+CA7ZxVTwLGbB+JAjjbDxxkNIo=; b=O/JinnuGiGhzy01uMYkZrNHAid
	FNpw8ojhEVNvS+5fkDEuqe13fStMmXjCP1zAqPkX1GysQki04I7mUOlpTPAWoPQVzxytJbnDsRDVl
	qoXhNizkQ/9oUU/Fva8KtP8IWVfDgmWd2L1ZjwUTFJYXnXQk04jDGYFs1M1Jq0iBnRrf0pNlIDaT3
	GxOSd8vsxkawJaYOF+ghOJ5bTeBb8MssDeCnDH3Y5xl0tifUZp6OoiXngzHMX1QaiY6MvDiF8oCKo
	nUOFbCIJXM3eD0wcpdtcbkz3Cb4/GJPnwimZLAT3dycZpadsU75Zbki6rX+mj2m83z5daWnCM/Zrx
	wj3gLUAg==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wOgM8-001cLz-Sf; Sun, 17 May 2026 20:36:53 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 17 May 2026 15:36:11 -0300
Subject: [PATCH 1/6] sched: Update get_task_comm() comment
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260517-tonyk-long_name-v1-1-3c282eaa91e2@igalia.com>
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
In-Reply-To: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Stat-Signature: 4oyme48j91xxc8ypqdn4ckf75a3nts73
X-Rspamd-Queue-Id: 11BB2160006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779043026-548397
X-HE-Meta: U2FsdGVkX1+mXQkGgyjApVjjoeEnXqvowBpcdsBQ1O6L2O7hMvUorbKqbUxYdCAbHeTiOJVNaFP+8flbxg0OCuTiCUHHms9LbG3a6BaONnj8ghYISpcLzAMxmy2FPhsIhqaY5wgO5w6WmU5ME9uwYtZDUDsf6KxWyJgdinqJx+3wg6diz9o8k38KrziLl/fERwAwyqDbrxggNqcmqvzvAijC9i2Jqncl9j7p2D51N91u1Xv4FRNy9c1xCKN0qrT9WToZ0A2cimzR+HsGyv2vaBNTME390Zn2xpD471iBeKMF+uB0Btmb1wLXBlO632n3M0Qn9aN8d/SswWnAkSwtl/gdEklkB5XBLOhbcC8ouHHHfaev7bu4LC9xcv5Xu5mJcD/5dgYVqCNG7bh7Paa46lpBOZzkGtnRETWkZB9fYXHwYIf4yA7aYilJaDj1hNvUE6SefT4LKZgcLX1jrawr5sGvojJMYfAU7kgehQUG4VwB3I2VX6HPBc+imbwIQNI5zU/YSPBBhP+mTSfkGKjuPRZgOe26Opn3tvawFkaKRrJlA+gM9ZxH4ZHh1yQ2AQtPLDGuo9FveK1n8tKX5J9K2bDBXRjtyNibsIDjsnRF7EMAGUvacWBp6NtY2MbmxlSL+lWCqTl3NxqkAoKtT/zjFC19DhDiiT2QAz3pc+VqOV5PZgSLx4e00Aeufm8Nfcj5Ap5fQFckvLkCczjlh7ysitXFwQEtJu2MAxqcLKA0GihQp3Xw8g1gpEJ+9ox5c2HzeGF9tHJn1DXk3Jz8W2LbFYYyb/arK70cSSbUoxdifmfmHafLrDdH6wRcMatq118yPL+NxnPObyoRqwUXmvRKui7vpkdlakqWWUk8vs8dWuMclRCpTJXSPzv1d5vdC06J0JLVPcrniBif0iCCmMFnCKvYj7tGn5UBKPgoD5jgmLME5aMX9m1BSIeGGLDQap4FIefpPjVBCYq4oywD2ee
 v9Neiupz
 DtuNdkpKUW0c4E0PA7iMRrv1pLzcFYqXpoKFiF3TFxSOvWytyqsKU7ZcEE3GWES+BgAnYyn8OlkmOy1UA5Xizg0xBQHP+AZDupqdMmPI7B4njF1aiHIz8OuYtjW5COjEfyKP8xl16K1+D/EAHDItZ7LDy9AqxEToZx88FJ17iYKsNqm5AqE/zPyqhuGusZDSn4deslOpHygZoWidhSdUOncE7yqVC5sai+Xi8Gc+SZBtSQrs7wmEH4n4JZ9PvEDi09PjcLvxPtHkfMG0fexodjs2t+aV+6xOP1FFZOy7m+FA0KwXGnTX9bAiQHPZhMUq/OU9ErILiNxzmccoafJeHeXMo/EpfUHDUuc0Lw/JRtxSeuYS0FyH7ncyWqiGY8DUagbGc8oeN4tD0geX3id9s5XPtzrrUN5+Z1z9Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 3a3f61ce5e0b ("exec: Make sure task->comm is always
NUL-terminated"), __set_task_comm() no longer uses strscpy_pad(). Update
the stale comment accordingly.

Co-developed-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 368c7b4d7cb5..60d004a49a27 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2005,7 +2005,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
  *   User space can randomly change their names anyway, so locking for readers
  *   doesn't make sense. For writers, locking is probably necessary, as a race
  *   condition could lead to long-term mixed results.
- *   The strscpy_pad() in __set_task_comm() can ensure that the task comm is
+ *   The logic inside __set_task_comm() ensures that the task comm is
  *   always NUL-terminated and zero-padded. Therefore the race condition between
  *   reader and writer is not an issue.
  *

-- 
2.54.0


