Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F9DCD98D6
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1AF86B0088; Fri, 12 Jun 2026 12:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC136B008C; Fri, 12 Jun 2026 12:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1B16B0093; Fri, 12 Jun 2026 12:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8064D6B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:21:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E209A01B0
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:01 +0000 (UTC)
X-FDA: 84871774722.21.3E48CC8
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3111EA000E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:20:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Kks4Atna;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781281259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIYT/HNuvNJd7wtW3If1BoiCZk6EJ/pRukABWxJMOZ0=;
	b=gMFIVxH4dht+j0WAOHLYIn6PoanEWHFLeNA3+BWFm20bPKXR5ZOPgnPtEe0sS+HN7fYu5h
	//ohcnyoYautmXWZX5k+NfhZv57L3KRiZGT07eSqKWB0KUBGiTgurcjmE51e2X8gdNu0bM
	U3tQkQpVvac9S7nG1sk4Nr288dKZhY8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Kks4Atna;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781281259;
	b=Ti77DA8laqY/5G0LoMKv2W4snOLpy3gBjdtXt3dJ4i+/lhJZR9NQT4qfGW7NknxMn5bL7S
	yqqMAw053s8NC2BRO1QHvlqZls5VVnbiEHzCFidsONtf74r81zuTKVMvNRnLQ0xwnWvOj4
	xhj/2CO78VbJkur+lEdH3B6isSa0AX0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zIYT/HNuvNJd7wtW3If1BoiCZk6EJ/pRukABWxJMOZ0=; b=Kks4AtnaYNx5nZiKCxP06Gd/Da
	Qf+VvfXREYGa3t5XvOfINjONUHMCCj9e2AE2gV5le9ZHaUyg1b9WY6XdCxGMO2iGdknHEo5SoPYZC
	jhPJKC4XE0xxTwrGKstcKNvDNeJzVS4TsL4dlY7Al09sb6k1aIXwnjFbLFZdp8KFQwzcW2RAv2Yvy
	QZovYPDtSm/XbnzJlaKTtWxUk5LyvBFubqs+99yIVAuj+WB6hT/QVkr+PHKMnXRtJnkpcsf0I7W9C
	8TL8E3nW4CStXph3Ly9jbvtIep6a5eSaYr+B522k8ocAYNUEc5Z7QLDNF9zXK0hd6xpbHUfJzVLQB
	ok+wvfrw==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4ca-00GgP4-2B; Fri, 12 Jun 2026 18:20:40 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 12 Jun 2026 13:20:14 -0300
Subject: [PATCH v3 1/7] sched: Update get_task_comm() comment
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260612-tonyk-long_name-v3-1-7989b66e8a99@igalia.com>
References: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
In-Reply-To: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
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
 linux-api@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3111EA000E
X-Stat-Signature: i5b5pdf5n6nncggkecrzbfc3qw8zonao
X-HE-Tag: 1781281259-563579
X-HE-Meta: U2FsdGVkX181ZlC37hJZ02S/f7ixokTtoZExQsBvve+FAIT+52mcSKcXiPpXsEN74oUbIan4jnYWBmNJzVhdvYlGANTC0C+pLKYIbvpdAUFIeFIg9OHNCcyyCA06FEMRoJqbc64NPqYIE7wNTtzplaUkJqGzUmOYwceveq1RJlkX6O47pwuhIZiYMBQVKFfAaDyNT+aUUvRU+p8rL7nosthZ+/qdQ/gamuDf4ZHzIckngzikF0RsQfelYbW6pVSBikwlvpFXtmZK2+iGnQXZk2pDFraeJRjCjtoaMI/TUxlfofT7IavjY6swXTKye8X5lWfFRqNhLTOGvp2Xhvkf+mX0RpXSeUIojwcT0x1+u86Ft84/20X4365kImGMvcuEONMJWzqxraIywwuxDzkM9dXStt84HSadj7QDYXdB1PozbfEqPfwyqYpd1W6e5LWwwEW5fM7fxDj9xQWnQJg9y5l5u+h9BXlmXGa0DSHGHVJHHdwNdlOGlCArGTOIf4tsNeE5o88PlIGyP+pAMQxiex41W2s5BA4Kz7KZOTnG/Su2D1bxBbxBAp3gbGJelSp+nm5onn3X10QoNmeUDADiKwnGS+LuxXWROZTMYM5fT1ambfJysg1l4JYBDeEbcOswB5+Za+Fkyv3Iq6zniCxoIQ+XDugWyrenESL2kdopXWFQuUWk5EHDdkpZQcyM7QWUqogYhle6TO9wvX40pFWUU900XVnZSWKw1BeMBApMAqzqh2KG3QzqTSa9yO3M6Z+FhJljQxPWwA/zv4X8ceqhNMgyeCGwnCVPr+nhhswBN+ZPY6T7V/t8fBb5C048UFMAAMzMFNrq8b7VnAN3u90K75tx9oDW8DRN3fEXBddc/df1g1h5sQVBO7sK9dDL65cfNe3frdwYDevejwsS+CzMNRypJyzrw9YE2kuzD0LHcL0vPVnIXqQds6YVss7KtD70JF6v5Vg+dHYlIT7pq/z
 O9cPorjv
 3DsP5UCiCAy5D9qo8S6ITo87pvVYSHNKwo20r2rM1ItWY6uAM55ogvIF0IdxZCyX8500RC4lIIxyt/exDvGd4DZJRVF/JCynr3FoHlRgODoQ+ZGorea8eEylWKEjZtsKz/iYrRiAJbEMwnOrzA231nCWKHLPUMPuxB59IfVWeLQnrakEoQRqWwQV7xejgji4FubC/TPUL3EVYet6SAfcBc4lGkyPBDru1meg0sS66BUei9qW/H6821aHMGJLnMaNlcmYWTR/+G/7JmVPPRAPNYNhxEf8AZLLVhNHPYmdFNCBi7Kgh7AFTAUT1JNO7odoHnbktuA6ZpY9MBPT3fRBEf/HPRHoPXUYzWxkc1epxkhuH9OgZmgxf4+LzYOFxmaU19fBashKhHQ2q/p1zjmMyv45nEDlpyad0AUrnYaAXvq/xd8u3Ie82SjXQR42Ka1m1XA7UWcG76oLCyjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 3a3f61ce5e0b ("exec: Make sure task->comm is always
NUL-terminated"), __set_task_comm() no longer uses strscpy_pad(). Update
the stale comment accordingly.

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


