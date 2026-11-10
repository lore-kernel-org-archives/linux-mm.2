Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDE3606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=EqAZ6bR2
Received: by kanga.kvack.org (Postfix)
	id 8B5196B05C6; Tue, 10 Nov 2026 06:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D3A6B05C7; Tue, 10 Nov 2026 06:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691A46B05C8; Tue, 10 Nov 2026 06:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35CE36B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:47:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB533A858F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:47:09 +0000 (UTC)
X-FDA: 85419033378.24.1890424
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0D13618000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:47:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=EqAZ6bR2;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRVW2SlXZrQJCF/A0kq7pS5b8flQ/Sh7jAI5q7A4ms4=;
	b=6QN9QZf+rqnSlEyMb+N+lejnKX3m+GSMV8pFPveo3Yn6DpsfpxRdagyyLaYKrJ6jAcLUTl
	sP6MTTisipvTCjOTyIIAwvJevrfhc1SWfQ/GI64gGUBsQcY1RXY/RLFke4U89HGFy9pBVu
	ZRauOuPedTHn+hKSBp0tY9svxxD21Uc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311228;
	b=m3N+Kw5pnrS5NlISHOn6uafddPCxodWtK96vbYOA1+K06MNts0uwsOCCQ/Jl8+yFpiY9M5
	deCRBlmC/Qhnu+KEvmcKWKt1QH6lpTVdaFGsU55qVOJEaEZXAfeRvmeemUKcygNYQE4xZh
	zxL3lggbBeiS+VWmIjLqiRk6IPpKeS4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=EqAZ6bR2;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=gRVW2SlXZrQJCF/A0kq7pS5b8flQ/Sh7jAI5q7A4ms4=; b=EqAZ6bR2kjWZmkur3br2mPpRhS
	2JP2wKrtXb402ZPLJlwHk3CCE3gzUDouicoZk9sekNwOabrgL1jw4R75fMkmGeLPKB2atHPN9y4Y+
	v4DhAzYggMrnFKCFfStatDp5v2wqf9e7bcaCVQIy9VS3c6S4VUy3CfGqCn7FqWLpYgPrtOfV2WmuJ
	Sv/NfeQzZq5o9oo+ooVIXDs2TyzucOQypasuYjEc51IBubfNI25MF3qluglyLu8yLlA25N/doqRWt
	1b/SyI0r57W9EzzzRzY3lJ72vSvubdpY2P6vAsNbn0KY7eVqgqR+QHxOFsPFaqIWns9NRc6mE87AH
	cZSchDGg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJS-00CNTa-2O;
	Tue, 10 Nov 2026 11:46:55 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Nov 2026 03:39:29 -0800
Subject: [PATCH v2 3/4] writeback: log the end of a slow writeback wait
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-writeback_stall_report-v2-3-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
In-Reply-To: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2451; i=leitao@debian.org;
 h=from:subject:message-id; bh=u2qEqJa97IMYQjXULEzv1cq2WuUThXMDMARYrLe/reE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQYnbNvAsZXal8d97AAOhUXQdWcdYAtPVoqf
 ThjeRURiG+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 bWa8D/0Q8o7HtSBw541Vvwgp2xYsXuYm7Xe9cEoo452XKnUFKjgfFRwYCTsua/Gq/sgxlgGF+Cq
 QOfmimWUKd1DYxOycjuKFQQ6HC61zgJX5+Q9xOEyHk1Q0+ff5suDwfUHQnp70yn3Lq8N2oGImyv
 32IjgGegUnsc/l/rYHnLDltFYVirWl2HMBviA4A76E9ouwWg7xAx5pS0ZFfwAsbxF/MqCy57Erc
 +ZfWJvaNxIMXKWX0pBTUpszVcjqHv/OYiyAbY36nLDRgBLqztr2TLgsxcwlEsakKS9gCKL6mTtb
 EIC9tgR84X6W2/V0RxxDLb3Pu2NOMiQcQ0p/pA3uYu1a2LWQFsPFW+nIh/iAIby8aml0cca8w27
 eHZ3YO1hATrFmzPBFWXj5nKh7X+j2FBgLGLTjcaE8j54Iuc2kMzlP9z6RY6+82tFyeDxG7i2ctg
 B/C06UYRYGBoYOXjAzjl2OIQu3UiaBgI4zZGkxkYVIvkZgD+Yv3zgOAhVMJAPOJIyysHe++yK+4
 L0HPoUprEbXv8i3s9rOdOYeliWgwXJ2ST5ix0KfVxqZTRqX2xqhnVZsf+V17azLTjMxkz60tSmS
 jf4la6GMq+tUhO3lBcQ/vTLkUEDK4zBMvUnC4rbXw3vfLzZJAkk+M9RFdcOvtDxLH7sbT660upR
 H8m2pgEYyG/IJ/w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam06
X-Stat-Signature: kdz3iwn97mdxu7x3r5kog6869znru8cf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0D13618000A
X-Rspam-User: 
X-HE-Tag: 1794311227-921683
X-HE-Meta: U2FsdGVkX1/pbeL4NaOCV3KDiNPNDQqELciNTz3p87xuvtOnt6nCoYDjSLDAI2Rq/7pXj9wKHdrfhoDsZSbWk4zDunakTwK5iSMjiAMsadWveNFvbMnIZbOY6m2LWfQAWm45e91kCKKxUqNYVmcdd8VQqvByAlpsV8a4Xny52Qc7o1RQXchSrx8C2Xe6HFzRpxk3SJCpqR345VSLrOSAVj2/d2g2oSDeWeFbYfpDd/aCEegRlBAIFWRGD8aRB4gHYiQcK9WHZuUF3usxOzvCnua1boFAk7f5I9TNZAfiep2sRqb7kQd3QRYo1ORLIgGej7CJzWz6byIMAqPCwhYDmH9+yaFKeLODdvwHhe4/lwDTEs30267g66beyHXQyyg+fKXE0fNs8Qgv5rXt/E0dsfX1SpsRsDSaY1vRvxT7xvPJKcaUMTIHeGqtWqEefGN0TmXkGiOUA5uGAiaan/KnL7kPHUkBQTORL3usIxJr8nd8zDNj36oLnrjj360fbwHcoELyxdoY4MqcjWP44ftwCFb29xg32QQ5apZAqjWNv/dJz/Q89eKIg26iSN79hxpZcCAMct3JcksVWV9G7LQE1jFXPaRGJIAjP6PGuRusvL0wSTA4OfrEXsos1NV7Yekrl/gPs+9dYXRzvV1XBqRQbILIfaYFgkOcTZ8f+RcR+yoEUTTTDou2Uq9Ifog5/tZyz5pnJ1l3Q5xhsdgtKTbk+ccIIW22QtRGfIS/ods9GWtpHrW8yYTibiRIzTRNCKyZnYS7u9jIzgrz22XPZNKikHvYyfaRZkvypk61Y7VsLw9yK4ttmN4t/fnEjzASDc0TB9suxFCtOKoAK0El4KphXlPdWYoGdgksaBuUv6qv3W26CVZXDYXUvu4V0OL7bRmE9D+XEnGyWev7OBKRo/z+uAoCtLm36DFIxA9hoPjLOpb+dWM4LgSIAn2QcUKbDxGUt6jmwaOOxikPxxFDvoP
 0FDoi2E5
 Os4wtMMo51LBiYZIAjsaqVRhY85gp2q1COo9DPL3um4Oh+bVJWLMwzD30xMEqAIhj9ha2vJokFngCUIc2rB+4kssM93Y0pHdK8WzhzGvytmsgiiMHIJTq56oKmwRWJoEOjqL679PrXaCMlcQlK8paLeMjbxraTl0D18peSPotvTf7PpudvRHxSYayg2GFe83EVvDFoVeE3kTcEo2AeznxKHAXFGgR/RtlQplFx6n2SrEhtXQQhDwdLD4Nz654UVmaEnPPhpcqWQbY8+kTPbptB8N6n12Fts3datOD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A slow writeback wait ends with one more "has been waiting" report,
printed by the wakeup that sees the last work item complete:

  [   31.763963] INFO: The task sync:276 has been waiting for writeback completion for more than 29 seconds (bdi 252:0, work items left: 0).

That line reads as if the task were still waiting. To tell a slow
writeback from a stuck one, the reader has to notice that the reports
stopped, which is easy to miss in a busy log.

Report only while work items are outstanding, and log how long the wait
took once it is over:

  [   31.807879] The task sync:275 waited 29 seconds for writeback completion on bdi 252:0

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c5e9e5c0d506a9..e2da4781b5e00b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -201,15 +201,16 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 {
 	unsigned long timeout = sysctl_hung_task_timeout_secs;
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
+	int left = atomic_read(&done->cnt);
 
 	done->progress_stamp = jiffies;
-	if (timeout && (waited_secs > timeout))
+	if (left && timeout && (waited_secs > timeout))
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
 			current->comm, current->pid, waited_secs,
-			bdi_dev_name(bdi), atomic_read(&done->cnt));
+			bdi_dev_name(bdi), left);
 
-	return !atomic_read(&done->cnt);
+	return !left;
 }
 
 /**
@@ -226,9 +227,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
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


