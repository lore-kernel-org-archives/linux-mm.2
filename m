Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2006CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0848E0008; Wed, 24 Sep 2025 08:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212BF8E0001; Wed, 24 Sep 2025 08:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064FB8E0008; Wed, 24 Sep 2025 08:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB4BA8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:06:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 677B61407A9
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:06:41 +0000 (UTC)
X-FDA: 83924017002.01.F461CD9
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id D24BC14000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:06:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=CTdD+1XV;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf09.hostedemail.com: domain of eadavis@qq.com designates 43.163.128.54 as permitted sender) smtp.mailfrom=eadavis@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715599; a=rsa-sha256;
	cv=none;
	b=4ndiWSu6WccRh+19sR/eYt4LyS+/ZdgZv6ELfHgUX01Tcw6BI03iZ5FWGs/2ugQc5AjBgq
	7SuEAyxBucvWo5y1xPRzJ8zBY6HZjGsNSe8mLTTdWyru83d2SB70QcWJwCwe9cjzEv0hY+
	InJmeokRJvZ+c27TScSU4jprqRQXyLk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=CTdD+1XV;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf09.hostedemail.com: domain of eadavis@qq.com designates 43.163.128.54 as permitted sender) smtp.mailfrom=eadavis@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=feSX1GmfgWpjZ5g0928zTjhvLUF3waPxTkQ36vSbBh8=;
	b=Qk7ZP6TnKF7b4q3Q0uQfrx3TEZ2qxCc3JjS2Ft3tuwR6vwNJYyfJjYJlfFibJbxUcnOzy6
	UNLpWCx5pSJVwPcOdzLb/tpJLx/FUOBf/aRzc4wCAGNDHNSh6lFxcjDeDIZGo9mTTIDUDD
	igSAbqAws9Agmk6iURZJ7riy/VqSnHg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1758715595; bh=feSX1GmfgWpjZ5g0928zTjhvLUF3waPxTkQ36vSbBh8=;
	h=From:To:Cc:Subject:Date;
	b=CTdD+1XVICrl4oU7LfiCWgTlqCthuMxQjKmyFhP3w9zdVZkNp6Rgwe/dojv+yHmq/
	 4Y44lne7U8UCtwy5MsxMSZRXTrKabmxqHqgfeKJe9xmpoVjxigcRu2IGqITqEEyfDo
	 LqGFf5+C/zNNLVPYhrUVNGJeuhDg6ETOM79gVPr4=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id 19702281; Wed, 24 Sep 2025 20:06:23 +0800
X-QQ-mid: xmsmtpt1758715583tar97unnj
Message-ID: <tencent_5E4F978D9525A58D97925ADDBADDB2193107@qq.com>
X-QQ-XMAILINFO: NUygYfydBsqc9qgiDPH1QBNhznzV02Eh9A0l1mcgOUBEbUc6QOOrzi24Ck/Wx9
	 u8xOGkme/bELRJogUOQWCnaOsfJCybyamjZwxspyoLY/95ZFndBgxIePQHoOk8GaJfg97I98edmW
	 CuYkTGeN/e31AU1C7HGonj5P6nvJzpMkaIPi9is6L0IUcy1NAgvEDISpRlT3UYOqijhqUyG6leH/
	 HZZGMYcmUo+ynT5B6ELJP8+UCZuvoXatEwIFbrXIQTl5pblJ96oYGExYA8RtpOpQaye/Z6+vBi+u
	 bu7YDK8kkkbf4eDLZw2oV0WC7ksWiG2hG3iwBGBOsGrDEwCrBiDBnFMF6U9HBpSEZ6ncNJuWFZBA
	 vmToKSOJVf9p/3mmr61R/pWrb0ZDSETfzH8r3qRm9wYvL7W/B1G+MtEbYUpWp1Buo6SthkU2pB59
	 tIXCWjAsnM0emyv6BI9duffvFWJGlwlYrHM+RCZ6U/efMoJUk8FnreIhhT0NjPvQHEvsyrGSL93a
	 RAjsvNGffGRXh9v15Xvyf8dApbp0qfI5zsk+LoPUeISmbchQVCV6ky5Sj9A2o6AWse2ucxvAbbjP
	 zN3llmV2ilpyOVJsPt80os9Tq4+AhI1iy4ji7llcmmdAzGI9XvpSHHAE766CDJXAUGBAoBSYleyg
	 jJWbt0sKzslBTX6vcKXpu88IoODnyUCQZBLo2zIRrFcNHZRd9nr6fPlDNozY7tvUOHkv2YS5rvPb
	 nTnVLSmo+LumGvN8RUUZ8J64dlHdR0yev3pY225i4lXGLOwJm6VS22TP2qiOHYpNBJ3LNnfHtUoc
	 khUX16oXRN6rLBWHdcXn6L20zXNkaa3+W0pTvEkhKqCOqI5e9Q8GzilnqIvE3aVp1MbOt6Q0JtRl
	 bpZTrTw7yoJK+9fFynedNWIozSHLTgktOM6SBgCsndTKGhBwf88s/7PaQtHQKhN2NLjqoIhCbVee
	 vqHIEAdFjbrhMNtqIvHpP/zGl7YtefHNF550qrk2E=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: Edward Adam Davis <eadavis@qq.com>
To: kees@kernel.org
Cc: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH Next] copy_process(): Fixed jump logic error
Date: Wed, 24 Sep 2025 20:06:21 +0800
X-OQ-MSGID: <20250924120620.1577525-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D24BC14000F
X-Stat-Signature: xpzxpp5m9uxkg4dkhpjw9ryb5kspmd4w
X-Rspam-User: 
X-HE-Tag: 1758715598-109691
X-HE-Meta: U2FsdGVkX1/1uiOMN2V33jeS7jebUUWfVLh5bo10ks9jnM9FesHjF1IJDyZOKqm9mHjjZQddUsshOAtAX+g6WOlI1JuVE7Ylz4lBYWba3ek06CsB6Vl1aepuKVFMjIFXWqODFAQYsbHEQnmWtYXbZbum5brML9EDP91N5btbymrwPADgMXdpAUDeH+WMlfYWittClyXHQ+1vICdXBvC3FmHwH5tlGbryVca7WHsQOywgcxVh5Jzln5BCyeabTbWAL0XnWqcFjiUSJ4q8TSP0e036xgVn8fWWNvib+3XafVNuot8arCtBZAzK4NfVoWAWbUqcGAnf/QAPgAuJ2iwRUSf+3FBuZSPXzQtbM29TY6Je0QCskW0cKZTvnIXvbIalwpyRkOn1XsPftCrbL58Pq+iohLfWNODSk+wIHHIrKr25Y++p5gGOhjp5BxgW5yeh+bPm//lSBGAih0MHMeIfhZNbISE7Esc2JIAF5iuvNZ/wxCRLueup1MrngsBUmfT4qmO38CSoklp/MwQHrPG7hpQnPwy6i207FT2aATOGzYKRA4YTEMQ0pxyLFY0NvUZDnfTYZ7ydiVt4j8PqIIATPUAVu5r3MW7Cm1RrEwpgZQfn81QG7N0RnOhNPqSdXrAMkm/D2xtUTkj5aYZTYDdk0WpwRpNsrW/oF8asBy69fXuvDxQBc6E1JO9LokZix4lUI7VPS849OM0JA3PoBatzvK/KHZxfwFQuCl5E7ZG+chx9E20YxAsIllgax77mCJ274Mt6sCiI+Ivt+Tq4yW5gCo2nVA0c8nAlmYdmeJX2Xqpw2LnFJeew8zwCeLsOqxbGFzaKy/2ltb5iIk9LVqBTESLSOhZvtJ8ZqcpK9cjoNpKw8HWWJAQcLISe/GdjMipetAvz2RJ86tcY01n6N01KMmnIihQF+JAPdJeO18CQRyHk2EYOAxaWltZdzuN1XxHeLneEGj84NL0BJ6LjNS9
 ngEOywny
 Ue2upB8h6aam7FOvBKYknxhg3/gSOj5kNeOmKYwscjds01lkt1Y4fQKTMbGHcgSW2FjIO9G5quERk2KxFgGU+/DCqiPMB/G4xPJ1VFZgol4H7av2kp71bG4gEc0WaWpVcM2ecxaY1/Lob2ggeZfJOPktKyAXbuqiW05jx7YQk8Q6IpsBcO8Qu0ZDLPKZlXjOAOcHSdkftACT/wErc11PRckMamTiGtxWRCZEaaEtJUPCJm/SQWdu3klBzc9sLGEk1H9eGUGOebQCdS3GqGAC6lbJQI+ErhGMonZFfiflgJhY21wsbz7FXScGhLpRg/m9zCrHjvSnmZ36xs4g/ccTWn0O+1BqWbPODzLBdoT7sjFQRF5V9/3advOF6bTKpMSMYk2JNoJmso9+P81w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After futex_hash_allocate_default() fails, the logic should jump to
bad_fork_cancel_cgroup, not bad_fork_core_free.

Jumping to bad_fork_core_free would cause a siglock imbalance.

Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e9a7fb5c3e49..a0b8eeeb1d27 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2349,7 +2349,7 @@ __latent_entropy struct task_struct *copy_process(
 	if (need_futex_hash_allocate_default(clone_flags)) {
 		retval = futex_hash_allocate_default();
 		if (retval)
-			goto bad_fork_core_free;
+			goto bad_fork_cancel_cgroup;
 		/*
 		 * If we fail beyond this point we don't free the allocated
 		 * futex hash map. We assume that another thread will be created
-- 
2.43.0



