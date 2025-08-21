Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BB7CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72868E000B; Thu, 21 Aug 2025 06:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A2B8E0003; Thu, 21 Aug 2025 06:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D602B8E000B; Thu, 21 Aug 2025 06:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C49D08E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:22:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 803ED587E5
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:37 +0000 (UTC)
X-FDA: 83800375554.19.D207CAF
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id D8CDF40007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=dcitShqS;
	spf=pass (imf01.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755771756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqJEmr/n09REC8+UBB9VEKt7Poxqe/QefzeRVIsvj6A=;
	b=Z/Jwol3TRdRkXGxTLMo2jJO4IlgzlcjUDAjHZpJtGgBNYz9XGeBVeN0Z1HP7czZEKZPIyD
	DAbSCOdnPI7hU0W4djPBhzQdpcANthro6Ia0lEtPQ5b9RjE6B028GXPyT/DqkHLOCQDSLw
	9Vfz+oOm++z5yjCrq4gGIqpMVuQN5ZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755771756; a=rsa-sha256;
	cv=none;
	b=28ttUkBZ7dzR7gHhuQlofGSDmodnf/qEM42Kb/6IiRkA0i+ZqT3Hi62eV4HFC3/h6PDlkW
	vCK8iauBqD22+IZZvn/6jDEN/RigA6HaQlaxLGy+ThXLTQB18qy7cvY0NCYXhHsuVVIcN0
	+d/8BPVm8hBJPhX/MMh0MtWPfUIJ/dA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=dcitShqS;
	spf=pass (imf01.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VqJEmr/n09REC8+UBB9VEKt7Poxqe/QefzeRVIsvj6A=; b=dcitShqSPUuBBKA4+9P37TcOhG
	u7PqftO+reDMPuDKrTaP4COiidnrQNYhqrUuz9RukvpTJp2gJpPv4W/YtsqtSG8g8AquTq3IprFER
	VxAVoVW8/k2sFNeNg2R2p8YJ8JKugf02aO5keT0AxLXt3mr54ivsCOMEcnqJK3qUhTk/zjAW6CArQ
	MwBPbyfWOrwyFPUlTSmn6W9xU4xiVNNafCN6t7gVsnlmxzmgx7THcsJOtBGW9CqoZFda7OcOYQ33K
	g1cHk59nVGk+2UdcdyIUxwskYIMot9FQ3Yy4WLFfhaArAJQK0uzyMDmz/GUy0GnrA1Q/FJW5aEmo4
	7JXrWb/A==;
Received: from [223.233.68.152] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1up2RD-00HBmV-Hy; Thu, 21 Aug 2025 12:22:31 +0200
From: Bhupesh <bhupesh@igalia.com>
To: akpm@linux-foundation.org
Cc: bhupesh@igalia.com,
	kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	oliver.sang@intel.com,
	lkp@intel.com,
	laoar.shao@gmail.com,
	pmladek@suse.com,
	rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl,
	peterz@infradead.org,
	willy@infradead.org,
	david@redhat.com,
	viro@zeniv.linux.org.uk,
	keescook@chromium.org,
	ebiederm@xmission.com,
	brauner@kernel.org,
	jack@suse.cz,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	linux-trace-kernel@vger.kernel.org,
	kees@kernel.org,
	torvalds@linux-foundation.org
Subject: [PATCH v8 5/5] include: Replace BUILD_BUG_ON with static_assert in 'set_task_comm()'
Date: Thu, 21 Aug 2025 15:51:52 +0530
Message-Id: <20250821102152.323367-6-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250821102152.323367-1-bhupesh@igalia.com>
References: <20250821102152.323367-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8CDF40007
X-Stat-Signature: sk38ewph1kfqu46uqhz368taaffuzeyt
X-HE-Tag: 1755771755-22764
X-HE-Meta: U2FsdGVkX1/bQBdIKYw29hBMNwepwoVEYmdoN7tOgY0CtxSf2VtWRyMo8jo162IMTpO0TIPEWx3167nnXBYJkvi3CFz4gzNHzaAqyUrS9ENDXp3TWhP76uoDUmPCyIuS3AnCzsVCvttu9go0+uHw8yhXB76+XpTKJoiE1FAcd6AW6NLBJb7OgsqjOduC2Ncq6vYG+lRCrsoh6zHZAAGhHSVx2BZfSK6nBhJ/7Jekgn9Z8CyKewa1FRz6pbC8HHgkSxwyN4mkjiotI2X3Xsu33AB7nBAk1IOOVXWkD5ELkqvCIu1ZQXaHv9N4DPQAp2cLD5TNgrivPPxFxh0DTnoOY3HjTqtpufoiPbkAKJE0cgbE7wMK8KfJx74y+A5oBWWkQ86ZIxpfN5bYS7Z7vxr8hlklu869QZ8YC9wMkIQALgxj6xqT0LDAHBEjk7M7Ac4CeCzfNAsVhzOiHYCOL3MlEE8VMObgUMgimtkeKSrmNC4yNSpOQgRkZOwAYMhIHoWOV7+diOYpmNfmdSinoZgwAetqvF0rDY8ABkPQOn0+DrD8oLhKwqQkEUFq2vJxRPTKYhmMaqG/UWpO5SdVvn1OfqO9daguOKg2MrIEOabfxVh6d/6YNjHJEmybBYkpNtxh0LHYt+n4zPZq/C57FkosFE2+rv+cjtb/swQ0uLRlmmcZBMtA3M7y3SRkp21YJZ3u6Q+jAAx9YBtfDSrIJq+eQRW5teV3lbHZEpnMO68lO26+TF1ysGKtqj0NfF6So8DQXDrsblaar7WXZVIv9wAFjn2Rnwl1cadkBPaWKyicMOBcjiyNZsmfNVDluAKPFjZnZ8zPvNQdsvhcEr6Hweyv9FwvmywCyKUV7UjNdU1HNahkygdQ0h8a8qPHESQQaLeSdsAByOdIYHOOHEgAFQl5XEMX2AUGkwdiI8rn7s6xVZOM1ewjtMCTyhzlh0jXsWsuDrZobaaJO3nMDg94z3m
 i7URR1AY
 Do5zaiME9ljEpWbWHZIsHbr4vvMqiho9gGPfZU7YKwdO2yHV2ZXzLTvCmY7Zxub3veBb0ea4dx0/MvwTxK8+mOIspH2FRs53ThiJ6Yuw2fWC3EplmKk13Rt4O4ocobxQwlRQenKXX+Ha2fCFb/OcCVSsSrwofWMVrt5wTTrpYbKFwO5sb5MvU36ftfS11+hkzGBDj1lctUHM6cZWZWWLygBefElnHcny3U+VsDYRjmM4CF+gC0XuDR642y8FCncYPX5SAf53M2DN4B0BI3hB90ZaoDfWAQZDUyLQ5awfVjvyZeixpYCw6wR3ED4MQmBDiCAYy0K9v2+Ha4TIciA4x2x1JVAvQsh9Zj92/W5l7Qs3CLO/PRAmEcdzh2vSilS+M9HL16tveQ3xtKbfbXjnCYkvSOaQOQmxr8kv16JLwU7nvM+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace BUILD_BUG_ON() with static_assert() inside
'set_task_comm()', to benefit from the error message available
with static_assert().

Signed-off-by: Bhupesh <bhupesh@igalia.com>
---
 include/linux/sched.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d26d1dfb9904..2603a674ee22 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1972,7 +1972,8 @@ extern void kick_process(struct task_struct *tsk);
 
 extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
 #define set_task_comm(tsk, from) ({			\
-	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
+	static_assert(sizeof(from) >= TASK_COMM_LEN,	\
+		"tsk->comm size being set should be >= TASK_COMM_LEN");	\
 	__set_task_comm(tsk, from, false);		\
 })
 
-- 
2.38.1


