Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C3ACD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98D56B0092; Thu, 28 May 2026 23:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22156B0095; Thu, 28 May 2026 23:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA4B6B0096; Thu, 28 May 2026 23:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86C0E6B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:15:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 533401A1102
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:15:29 +0000 (UTC)
X-FDA: 84818991978.22.E2BCBF6
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9C534140008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:15:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JFsChHIo;
	spf=pass (imf23.hostedemail.com: domain of dbgh9129@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=dbgh9129@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7VQKUmle+s6m6lEZBFzOZjbbNDmhgzc3MV2Qh5axEj8=;
	b=EqZPor/S6iw5hdpM8Nw7U1R64/ZUvOEqOwadGI08OGlZ8QFv3C1kaABVoPQvB69IieQnqN
	JSbzHEAwUqjJjwJjet8yGhXO9JAfe+FnsD4Ud3qrGkYfqkDPn5nyiSHL/gUT7aqwYDHIBu
	xBIFlIuxTbWtuP2UU3qtvKzP6H4leNU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JFsChHIo;
	spf=pass (imf23.hostedemail.com: domain of dbgh9129@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=dbgh9129@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024527; a=rsa-sha256;
	cv=none;
	b=suZV9ffdOds1uVfxwFC/PmpPDo0tFqRe8+fx1xwJMtRi3lggxiEBKAoUe5lx71e40Xl1G5
	zRrsfQLELtiHPu15+buh3j7+mFiEVNYdsSxWF9IOYGLtOonuU9pp0xtvm6/vSyUOZ1Xazm
	DzeUTCqUD/vDkBHFbS/Mu+H9ASyzNmg=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9144163319fso1415923985a.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780024527; x=1780629327; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7VQKUmle+s6m6lEZBFzOZjbbNDmhgzc3MV2Qh5axEj8=;
        b=JFsChHIoSkkeMYHPvapjfSO1YCOFqmMdzI5V4z+rCzS11G1W/G/Cpye8c+QQd6Q57c
         fA3E8nVDxqGGjwiE0J6Te+Wf24xxAMh7at7qiL+ca+iQqMScvoF9nk1PRlPlFSvd1Xnq
         qDe8/7FkuiMyrbuamjzziBD2A2kNe9jhJ4yUaluH5lgkplS+6NVxmpWjdW35zn83u7DH
         YD0jL0KBYEGYnLB/ZfSMsanARTphoJ+Cfkqv6cVtFdA9zxWa78JsPPQh1qOEnpzx57rV
         BL7EFKqEg+S3w0dj7Uu1uQQrpf/fz2Qrnk8sVXzKHOxKKF565GBYNWY0rF/epamB5n27
         2rQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024527; x=1780629327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VQKUmle+s6m6lEZBFzOZjbbNDmhgzc3MV2Qh5axEj8=;
        b=M6fC+HEFTb283m5QMLLqA4jEHsWmQkxSYXCP0yylk820YCgWtehQxLF/gY8JMR3+e+
         eK6SthzCmGfUszKZhwpFKEICxItEqmqy66iXcPJLiOfFaKUtEzyr2nPmN9xNCc62+8iv
         98BaFsxo+jXOkIxiTZPa/1CFoySJLaWowP2LDcwLs+YVqT1QL7pr+m7qBwQhq88TV4qX
         PaA0NWAsAqTPWKPXwLKs51OuhX4S1QGGAMTSesKXjLASGZRKiOCzExjBTyWf4O8bCUVz
         5Z11Cjk8GEj8wHxaPfLHRTapZpjbsx4661mTSKng5rNTyk8IitFbP8jLqTgme86pQ+W1
         VD7w==
X-Forwarded-Encrypted: i=1; AFNElJ9z9nBjKJwZGBxlKFxYdYjZFf4k0tCJIOUfceENCnP1DCnVSZNQ+OyEitCfUk+FvV47zH1OxOXPkg==@kvack.org
X-Gm-Message-State: AOJu0Yy2iWp3hNbsNXk6kmg9+BgBXVuT7oU44LCLXmefDxXJIX0jl8PR
	NWC7T8v5ZoPGSbxvAepeqjqBVksCFPGnw5+V6Ex2zqH5JY4SzMvfgDEG
X-Gm-Gg: Acq92OEJuFCLbBQWkuzLa/h3a/Ca119s5A3bEO+QfElwng8MIs3ZLk5oUv9DIugFHHP
	4c3sohyzSDSAHQk804zoZk6d7gH/ECaP0l8wk1RY05dWKsgr7vu/7FS5AqQ3tD7nCqbtgnz8Vlu
	fO0pICyQokP+9RmCNFrDncrFNe5zBl7jqjX6LBt/JxfPXtzBxchrPvBh+Eah1bptyp2TR4wY/2E
	Onu/830kEt71OQ2otBpyBUtcinhRJmZmA+0SLnPUkxyQG2EgQuGjjULi/PAG8ktH5jpfF5x168o
	OPIOEZDCxobSm5/XZ8m6p03wIx1//qRp8THU1RGjZG6+InvHMcnnjFzvJVQJlhwukS0QJrfcRjw
	2Q6IMiMtqtRItbZZVPMyTkvU9bir+jAZaPUUgEvPob1+GuqNX78k1Lpv690dZrUhbqwRUrhDn+d
	rGkK+CSmnjODdzdhvjl2CyGayX9CUeAhC+wc9+bMLFZ96RlWyWkN4=
X-Received: by 2002:a05:620a:319f:b0:914:c0e8:22e with SMTP id af79cd13be357-9152ff5f1aamr139261485a.58.1780024526592;
        Thu, 28 May 2026 20:15:26 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91532626961sm37414885a.32.2026.05.28.20.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:15:26 -0700 (PDT)
From: Yuho Choi <dbgh9129@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <dbgh9129@gmail.com>
Subject: [PATCH v1] mm/damon/stat: roll back context on damon_call() failure
Date: Thu, 28 May 2026 23:15:19 -0400
Message-ID: <20260529031519.1617000-1-dbgh9129@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C534140008
X-Stat-Signature: sxgzrs1fwdgdp3z81xxtkcshqw9515ku
X-HE-Tag: 1780024527-513035
X-HE-Meta: U2FsdGVkX19HTTquY+UEamJUJQUVa6FUXbe0nnt9GTYBSiYJZP57NItDWMjq0i1ZIL69ywK9XIR/wavwPckQToTGP5zuCsDyng3V188KyMWml2CFYHRaowEKwdFG81MqHSDPwvxqknn26F8h2IusM6z+S65fP7mON00qsjkw53Bn8g2npWjpKRSIKrs2cw0qmQ1j1c0En5CaxcXeiWfs9AlSlc77PuvPL/ciVBKQkx1EtsJcSXGLiL+Z+cFVUDYLnvRYveVXOZ71Ma/PdKYskQaXLxSUvsHQxNEmEAmTQW3YwVGXsnP7CjdzMtAnAUfV+SGMQdZaVZ+nXczsQBkp/OexGH3dBJ4H7xdakyZKTobgSdBreGhhT68zB1YlRZM4hGIU6ui51+5s5L1Lih/kdSuPlCqCAQCoCr/1wPWglfshLX1l3tIcSg3rccVsE89JVeOAmZFqxibcsxcGdAXogUedt0hUXpYbEGeKpx9KCG1GthHDzRv9bmenmDYuzVkBzOueWGOB7iWCCQGUIB2PYRGoOJgbnKKSHG2r+9nHFkTaima0Q5HGgz7ZcvYhzrPLgymko3OfacySH03nv04obTwBchNbG5HLq9e+Imc0SykhTFk8xrkA+Q0O1kOvMkMiCGpTDre3WH3qPj8F8Ob4eSWfQ/mCnPs6arYqqQ5fstqJerxr8P21LO91bVhA5Osh+zA6dYhLGlau/QWDiYQyASg0lshVnlkSE1Mbm2e4gyJa8wIq7tPNOJJCumB6MA/ULpaGqRZdI3gHrhY5HaI5+GVL896BupuqJUEhPSg9GLLNRUdRAOQFDJlSVQLJPBr73ON5bXHS7aJi3dz1GDr7c16C7RTYTUNw73gQWkjJVf7VlmtRb/l36lHHrkWcrD7lKW/NvJmGNjNX6Ml2Vk8ccXsnmf89Bu4doHfQFmKbCnjfErjFB+gXJxt1aKyTECyJqrvezl/WblVfc+AxrOF
 YOPCVisn
 ZcIi9wDarG9qDNx3d1tp73HNAN7iZ7rdqDvaPPIyiFKUCNJIs9vlNy3WZZ737x3Fd/LXWXDmiUF+9plrUC9+jeJwJ4Z6j7V4Xd8uSlFdMa1CPpneSLEwRw4ypJjFTjlcMQqxfmWWLMtxcOsTNbJb34DQf5fOcASgr6fc3zKWNopiLFqJz31NVC/X7ER1+u2jH3RYBoYLYMeepO8bFGtA9CyhJ7hMNj7leLf1wmOlkqu30nzHaIO8c/oqCUe1taYLzGvQsEjvluzJLD/eD5bh5cQbiHq+3gRZiAWuBuIutQDdlQGf+Mkw5vcSHDgGqFwjX7aYtBPJ4oaCIYMDspH39kUtvirRlGqZY3oDkxG7mX8oTtEdsUpCtGOpvVcS/w3TWt441QkcLGzSJ6gwbVcjZhxsaAUYVZfxTBNrqwWHS0uWr5vblAjNisSbnBDcv7VOk4BAB4cqtv0a9ofSUe06mhVhq6rpMfUzAV1Eu6bwIfT9mQL0KhaBTpVp91AXKmN0kt5i+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stat_start() allocates and starts damon_stat_context before
registering the repeated damon_call() callback.  If damon_call() fails,
the function currently returns the error while leaving the context
allocated and stored in the global pointer.

The retry-time cleanup added for this path only runs if users try to
enable DAMON_STAT again.  If no retry happens, the failed start leaves
the context allocated indefinitely.

Roll back the failed start by stopping the kdamond before destroying
the context and clearing the global pointer.  damon_stop() waits for a
live kdamond via kthread_stop_put(); if the worker has already completed
teardown, there is no kdamond left to wait on and the context can be
destroyed.

Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
---
 mm/damon/stat.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 3951b762cbdd..7f222b5b7193 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -266,7 +266,14 @@ static int damon_stat_start(void)
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
-	return damon_call(damon_stat_context, &call_control);
+	err = damon_call(damon_stat_context, &call_control);
+	if (err) {
+		damon_stop(&damon_stat_context, 1);
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
+		return err;
+	}
+	return 0;
 }
 
 static void damon_stat_stop(void)
-- 
2.43.0


