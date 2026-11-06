Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C47606D808
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=kriSbH89
Received: by kanga.kvack.org (Postfix)
	id BD9296B05B7; Fri,  6 Nov 2026 07:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1566B05B8; Fri,  6 Nov 2026 07:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8B96B05B9; Fri,  6 Nov 2026 07:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70F646B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:28:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBBC6A012B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:28:09 +0000 (UTC)
X-FDA: 85404621498.15.DF0B267
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B68E1C0009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:28:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=kriSbH89;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvU9Ll/eiIhTIGP9YekbSrp0PA62VwZ43mnN9JohyA8=;
	b=A/DKu9+7erGMH3SaDDoNkFc6VDLJkS0GZtv/BmRt2QJqPVyYSXYF8Db80PJsam7j8CFSEI
	LqB04MNIp8T6uTAFshiBsOIjopJNo+Fydwp3T5/ttw7VRAUCkLWitWz3qqs5y4LF0CRNew
	otA8Fyev0lMZuzGO6UjCi9pQiKGp6c8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968088;
	b=urD8bW2prxRdOxoeDB9sGxmrX13Iwe1hYLKL1I2HVQqN41a+SRQ5kQXtLmV/t/srDPl7Hc
	ac9TfjJHu9yJqMdHlAiAXjrOjOSqDQBCuHtU7U6qX3muxWY4a8y/MHJ8WnY3VnKI6cmcYd
	2OKNqKAMsN8YbMFYLYCxVOTHfMxiwGg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=kriSbH89;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=gvU9Ll/eiIhTIGP9YekbSrp0PA62VwZ43mnN9JohyA8=; b=kriSbH89ZxwtRAa6ULhkqiNJJf
	TMaNoX6df9t3k6PGp1kYsjOs/Uk4kZlxd2LT9Ef0SVLrsbktATcTSLmjMZbnnyVnbTWWpurDISd+d
	JmstELL20CDQKrzTqq0bPXA53sRl103ypUpcJhT/R+rAYa+KbS0BxwjatXRBnjdmx+H7p+GL2b5Gz
	/xdfUVsC5BR13YX2wUFQ2uS/O/m8bqGuL2PKCYS3i3enLAd6v/7olOpcw8Evo+zvIWpMgG78xNUN4
	m3WmW0/zWol98h641oDlS5urIAKqVHsgB2c7urVMjSPBfchScJyINF7kaVchSMscNAexmiTMWOoUV
	gtQVcWgA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2t-009HUA-2L;
	Fri, 06 Nov 2026 12:27:51 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 04:26:33 -0800
Subject: [PATCH 3/4] writeback: log the end of a slow writeback wait
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-writeback_stall_report-v1-3-bf0c3b9023a5@debian.org>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
In-Reply-To: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Julian Sun <sunjunchao@bytedance.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2421; i=leitao@debian.org;
 h=from:subject:message-id; bh=iWceDHwwzC7CtVXVGCT6gvnNpBmDPTUwLcY2UEonv3g=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexBfiJ3VegtWonP+xsYLQRVNrpAkov7A9YO
 NvPZ0oPNouJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 be1dD/4nmrxOfJYJw/5P28bGYcp4gHuYsEy9nJmS7KV0gQju7E62cEKfqwun2aIGlpvay7dRID8
 cRLJGizJ4tudbbP4XCo5rOM30dE9DHgmSZTj1fnehuy7ZdYYdE1gWKZTpa/QNgZAZaWY/bgeTA0
 OhbYSoGs+rzin3e9Fo6Ko8rjtcUXoXGbqBrOQ0+9N5vgbJG9tk/+BKtpEB1abqAzWwtqJWxfCWD
 RrkqpjokGI3TNCFMHmHwYt0JdOne/nnqF8WYlnwLyQAG2va1YbIbmqqEPWEmpvij2tP3VefCfMA
 cCo0ytSjAtkAL3seve6NPqHdupdLI6godDCn2iqJ+CjrJnpj35Sk/zQ2sd7nXNeTsRAEnBBharh
 aHNM07S935HTyiLMvulRUH0HsgIuJ/GW/gsK50J4mP6nx/EYgDeJdgQnahVc9eUpkJ0KgWZVoZ0
 5SES4RL8biRgHO4lU9AonTVL+3nFktwndc6nSORxWZsN0edcM9eUOtGJGnZa/lhmgZ3bhj1rRrv
 98yB0/h334klPS7bNk03tvG4v01dm6wVMJcm47vRXvIqlkw7uDj0CzMA99RqDEEsjjzEfHI/Ecu
 ZV70VFYUA1zo9p2jGVqzuaNuPQ55geQxE1r/U+aj5UIaGtHdcfnn1k+w48Jb8JkdwV2aosyQtE3
 /ojLOEHIPKH8wpw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: u78r5fr1syi8s6a97iyrjsk7a7zjd8yp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B68E1C0009
X-HE-Tag: 1793968088-240963
X-HE-Meta: U2FsdGVkX19wA47FRzLSyEBHoFTKpbefxRSBPfuHa/DRuAHdTnIwzTAC0+Gsh2x6sU36GBdXRR+jaIgK9Wgf9sJCohUr+9Ba5mBk8oggdLDqGzp58vbLpj7L0EsLC3Xea01ZqtHn87mZUQZUThGtNRWKLPzFbVLqoeCH/SEW7FjHPYbRPqnKerqI6fU9q1+X5RfcHg7XpotqTSkimL+3c4bu0agI87UP+GoW3WespCw9dmJpynRpO9AQ7h6HQy6exmPmgEULRP6lWhrt6knZ2qXF8BB+R+V78gh6znesIFXqECuKMHfVDBz5EuwXTYqFYWk1cb/DgqgWlB17Dy69lYmHrp+01nxYfHsLsRRP6rNfNllT29KayZkRysCQ4/9jQqHmBoAsNp25/fTiC8gNHb65havrSxqrGLtGUGS2ffsqy5cX/ARjZ7gvn/Fmu7xq7SIbFd6zy562PNiisZFEIQr3wZAiAe9++vvJGFjBDam+8EW+zS95j7UuaBuFL/0zfFTCNGE3+UrRyyxTt5cKsLL28m3IBP62FS058rDb/VIvY3dN28olNq6NLzpz3N0SG0/xiwJ0iZC9CKXFer76Hb83i2Z03G2hq70ATHc8l90TAzlRopeGCCXuaJnU37qYS6Gk0CNgkQl3gfvWbd54Y9lQx3i6MO2K60VbPGRQfuH6uHYQwMBK7NYiA8KJG7I/HOpBYASidHCvZRlJLA2nW1OOXozea0WEYawhSY1YG98+1jblrgvbV8dsWDPtIpJ852wi/CUWAGaaxo0V4hQuu54PjcrcWJBvQOAJA1W/zwnnyT0Cx/6XnNOcB7lQmd5WZsSVpm6RmlKYQ7D15MLPEvQNIDu3l92vceOV9pCw4Nf3kJ/5WqISDoe8WuKUm+nVerzLtV2ZtlAL+YyQRJIbRQjN24O03dKVZLIgZg+P0/dIDn8Lcv7O5NwYB5KgRW4BRb/a2xWXWlUdnflnAjd
 f8zbFjFB
 +sENOi/L9HQwh96QSYgnQTf9JBOmfDRJP+i/E21bBerVLm2/Dpt1ovYPdfGim5OKp6FttB63HHgoqSlGjXcHq0w+LH5NUHCyksQEF3V7YxAmmptm5Z3wgfo+wDkuxDTw5HLBQwwkinUbGVWYOZZcYYkTFlvQxWSX9brCUejAaDwD884aiHTMnUXxgOd3stm/2eZ7er+Uw0k3RpOd6GlqaL/qy3I7mA7Kp+EHSkRVtwWtl0O9TB75GUJfzbiqd3OrIG0JNdiPnA5wDQiK8e1A7G5jhJYI854+jeKrKwwcQ2d6scM1Jby0X0hc7BJe7aWmgK0luOXkmMNr1bQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A slow writeback wait ends with one more "has been waiting" report,
printed by the wakeup that sees the last work item complete:

  INFO: The task sync:180 has been waiting for writeback completion for more than 29 seconds.
        bdi 252:0, work items left: 0

That line reads as if the task were still waiting. To tell a slow
writeback from a stuck one, the reader has to notice that the reports
stopped, which is easy to miss in a busy log.

Report only while work items are outstanding, and log how long the wait
took once it is over:

  The task sync:181 waited 29 seconds for writeback completion on bdi 252:0

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3dee9d65eaf721..cdb2631b8552e1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -201,17 +201,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 {
 	unsigned long timeout = sysctl_hung_task_timeout_secs;
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
+	int left = atomic_read(&done->cnt);
 
 	done->progress_stamp = jiffies;
-	if (timeout && (waited_secs > timeout)) {
+	if (left && timeout && (waited_secs > timeout)) {
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds.\n",
 			current->comm, current->pid, waited_secs);
 		pr_info("      bdi %s, work items left: %d\n",
-			bdi_dev_name(bdi), atomic_read(&done->cnt));
+			bdi_dev_name(bdi), left);
 	}
 
-	return !atomic_read(&done->cnt);
+	return !left;
 }
 
 /**
@@ -228,9 +229,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 void wb_wait_for_completion(struct wb_completion *done,
 			    struct backing_dev_info *bdi)
 {
+	unsigned long timeout, waited;
+
 	done->wait_start = jiffies;
 	atomic_dec(&done->cnt);		/* put down the initial count */
 	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
+
+	timeout = sysctl_hung_task_timeout_secs;
+	waited = jiffies - done->wait_start;
+	if (timeout && waited > timeout * HZ)
+		pr_info("The task %s:%d waited %lu seconds for writeback completion on bdi %s\n",
+			current->comm, current->pid, waited / HZ,
+			bdi_dev_name(bdi));
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK

-- 
2.53.0-Meta


