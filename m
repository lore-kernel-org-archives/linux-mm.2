Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A415ACAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E7B8E0019; Tue,  9 Sep 2025 05:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2462F940007; Tue,  9 Sep 2025 05:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BCF98E0019; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E72C88E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 959DB160459
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:10 +0000 (UTC)
X-FDA: 83869132620.05.9C64055
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E82710000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KKEvqC97XX/oJlnFZRR+cErmkF/KQpf+ssSD/AQkhDk=;
	b=i27vB5JWiurOC46oomZ0qm9Ov5+LtSkX90cKFay2/A1tM8B+rfyNZsYjuFXGUd/JaToc+d
	nH2Ct49DlbhrSLQwKwyR5Y5iPlKVQRmglXL3g4xi1UN7RqWNrUJP9bpAt5KwouTtI6jtx5
	k/dI4RxXyQ4lM/GgdEAne2e6jbXKYzI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408828; a=rsa-sha256;
	cv=none;
	b=5gDXhRsaxdVL/eXiU9sJBekNkY/Yb9StO7f87Q7nOe8/JGeSRtV29zFibMSEZM/PR1YgR7
	E+OgQxXKWeftaD+BJO8Xk+tUZlDv8cNZkG0VYy8toSG5+QIwtX7XKu+yQInfP3gmmWNJAj
	nYJLD8LIr2uTsUsNuS59MAlPjYLGKiw=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cLdH13hltzYl69p;
	Tue,  9 Sep 2025 17:06:37 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 17:07:03 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 17:07:03 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v8 2/3] mm/oom_kill: Thaw the entire OOM victim process
Date: Tue, 9 Sep 2025 17:06:58 +0800
Message-ID: <20250909090659.26400-3-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250909090659.26400-1-zhongjinji@honor.com>
References: <20250909090659.26400-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6E82710000E
X-Stat-Signature: usbujcy9cs4tfucpq846j3971rsksxsu
X-HE-Tag: 1757408828-739342
X-HE-Meta: U2FsdGVkX1/xGfdlzkwSBMGLIM2SgUZhMNPaVH2AcxNwlcV3YLnOCTDp2w88fjokNPgoSsoXWQngnJRDAfL0ol625DSubYF62IFhjVACgFTNCtE84xnKx2rISHBzeLsYkol85vFbdJ760cPboB85sNdPcCDN6iVTk0SjXkkUiQfWEDKKBobJOqafMKcG0c0X99MSelf1avyMmmqkEWRygArCMMJyLEvQ2a56FrEnMqpmJi2u38F4ePnb54Ky/MGeKCms3XzDMYcuYqWmQhIVB7Kjy2WPZjUBhYbaQRCV/k/gLdCCDjyqkSQqOJji+ik0gLLy7LcuJ7hUZmcxBprs1Udmm9Kbo8ure0J8v29bIAQYzWnr4tc0ZcJu0/tbVjawPlz0RLkKKWmUCF9D2blO5orDWBn4voPPtHh14o0TpfgXCPu8ZSVXJKuA4TPZdYvk0bPP9ne9rlnFZILXbbeU6Hxo6JMJL12f7lhCED9yhjACvf0hcbAo9yZjZFDI5UkwKnaMCtID8sW0WQ6tUsVA2uMjhKUffyuDHGQC5bzRsM9NfOEzB9RM7n1VcR0XQOaHmy3liRhs8V97g9KzTqBA/kHgEr7cfr5TGx8EjPEge4yQKgx4UQY3WyogQZFBq5vT0aovftiTalzicaBkIhc8mYHuIS6peglkoDcRB4w4eEPpyPBzoLoSFQ7woImh9LLd0xflDuGuoSCCPV1hbvxqYOwkDlCn0fwr6SHevjOZtzWKsTNidYx24YCOe5nCEl+Egn1paRTL5XST7bBHueuPv8DnSiVdwe3wbueLPNmyBiOnBShGNwR/AJHNzrFdodUNRMZ3rU/GojQ7CuB1vsVkEPrIufcFz14BZIb+8465UXf0Dx+vrlryZ9YRTOauthdJnOWyordWzcrJXjMU/CyKe2fNPA4z8pzLY851NHTy7S7K41HETLynkfkDWxk/cMaUqWut5I5ueiMtNY+wbXK
 zoNqpNxX
 BRP9wCSAmqgheqP4FBgoPeHLHBPM8XeIQUB3NuvlyowRd1SXeAbuYzhuAal1px6pVslX2blGb6sKquWtf4N+PwCwOrZMWikoqaoFVzJA8blYpVjDK84tyRCPmGuIY3hoiII3yGnVVZybpOMWIzXvq0iaHB6Vf+QITCdCvPS2ZxO3ERcn6FNGLQNFfXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OOM killer is a mechanism that selects and kills processes when the system
runs out of memory to reclaim resources and keep the system stable.
However, the oom victim cannot terminate on its own when it is frozen,
because __thaw_task() only thaws one thread of the victim, while
the other threads remain in the frozen state.

This change will thaw the entire victim process when OOM occurs,
ensuring that the oom victim can terminate on its own.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..ffa50a1f0132 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -772,12 +772,11 @@ static void mark_oom_victim(struct task_struct *tsk)
 		mmgrab(tsk->signal->oom_mm);
 
 	/*
-	 * Make sure that the task is woken up from uninterruptible sleep
+	 * Make sure that the process is woken up from uninterruptible sleep
 	 * if it is frozen because OOM killer wouldn't be able to free
-	 * any memory and livelock. freezing_slow_path will tell the freezer
-	 * that TIF_MEMDIE tasks should be ignored.
+	 * any memory and livelock.
 	 */
-	__thaw_task(tsk);
+	thaw_oom_process(tsk);
 	atomic_inc(&oom_victims);
 	cred = get_task_cred(tsk);
 	trace_mark_victim(tsk, cred->uid.val);
-- 
2.17.1


