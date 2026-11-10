Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D22060A2637
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=v7Tk81Sm
Received: by kanga.kvack.org (Postfix)
	id E0DAA6B05C8; Tue, 10 Nov 2026 06:47:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2286B05C9; Tue, 10 Nov 2026 06:47:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E826B05CA; Tue, 10 Nov 2026 06:47:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 933556B05C8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:47:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31635140662
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:47:12 +0000 (UTC)
X-FDA: 85419033504.13.A5F5025
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6749D20002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:47:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=v7Tk81Sm;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311230;
	b=ojSlXHORXBIzlTavj9tnWGkfZL6Xp1E6aSRneYj2wtC4wSiq0GwH5cKACtWuzU3HgNFNlf
	ZeeQorISZqu0aFX/NRHXcFdmvtrzXjcfbM6dh3kWU+V3I7MXVaLblRZqq5mMaWtMFZ6HXS
	pKTTiMb1rHNZTSP8P208LSsQYKV1GDA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=v7Tk81Sm;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyWJug/hBVWQQCOKqOZgk5LGIUN0CoIe/ztsrf1oXBc=;
	b=lJm4hHDSHooLL6ojkUSO23HddKhiwYgZGI6/yfkygYwb5/WneZENs0BErD79zOIbo61/ZS
	O78zQ7U2jmRGEkZrwEE1Q96WMriLnJPzfjbc9OBcVckW4S6IUaauHs4gDNOeO5eQMYvWIf
	qiEkAwysWC1ulZdpBIMsXvsJZrgR5js=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=oyWJug/hBVWQQCOKqOZgk5LGIUN0CoIe/ztsrf1oXBc=; b=v7Tk81Sm/v2CyqZbx+psXu5q2r
	ssSHq92OtmFNYq9p5nSX5H6ETCLNZaDmzyiYoLMcwEIYjnGonD3nH2rqOptn+9yDfOvhaZDLlrjah
	n+01f7wy1t38GU3DWbQHZoTVx0Cj393GzwFlgDDd7h3pwBtdflSreIvOkoR16mj+DCe9xMGwW6F6k
	VJ2VlS3g8ztZllnojNM2khGcjBYbaI4Y1HN5MQlcah1N3diBH2wKAbXCvlZraUq62E7Xg9B+CKIVN
	A6PNs+bVApeqaIbUaiyzbcNCggKSaOXgQW/5jYuVoAdDR0vpBnFrnd8Oc3qP/ANS4cC2YL4h4jDYJ
	Xtng5O4A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJY-00CNU5-1A;
	Tue, 10 Nov 2026 11:47:00 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Nov 2026 03:39:30 -0800
Subject: [PATCH v2 4/4] writeback: report a slow writeback wait once per
 timeout
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3643; i=leitao@debian.org;
 h=from:subject:message-id; bh=ajm8Ubwuv+zRBQCdQ86iU9Tq8be5/mg0MciPD2KAfKM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQYEQeCZFOUQMESKbD8oigrM0FIkR0zqQxCW
 emSIIM8CryJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 beoXD/9lTXvWJYV+JVoPskFLodmlanyOBCnxB/KXdCaVc8sIlueOcnJ4XOL+C9wptJHQNxraHCm
 vSzn90Ve/YsPVW9Gr1o+/x3sliFDJH3vkw1SRkgNJeNsdCcPVwb+Py1+oJ1erUqWi+AVHPMzqV7
 1s55ySvBsDGrxFJCgktf3NGEja6hmny3CsNnFsCfnzCle0PLW08Ux6mghUNElv0+MCpab4zmPWO
 KylJh/zH7yJHvscZqbnIRNEcuGXiXsQZFTCJbUeMcaXaKm1rvxAuJV9kCGR2OwnK9grQ9ZsgaWs
 askY4XKVu4JCNwDWL4n/nBejkFMdgW3NOHoZbLTBwj/rseWdj/Zfh9gTjI1VLka4/VjTZZ/ZVoY
 5iGyZkjnwYYfRMzQcSeCxBOgQ2voM5zQmkzjRRNE4YMffLjWjzZG7YoPPHIMeOrj6mHhi6Pj7pP
 gOWX0/MbEu0RMV0Wxn415d3patjIBJGLbm+RMaQRibIY9kReYln6JvaC7Vshg8i4PLB5T95gIo+
 uxqChWUDybckZkNoX8lteGAhdnr4MR7jywgV/A2kSDcf4wNu6RKSZ9cP8TNNdhry47WsP/PmTKb
 1Oi1qS0HeANf5nn890ZJB6ViIM8FRFUkvPva9ZA7xjgVRfIILeKT7KMoWUOMNSx679mMHaV5Wcg
 SpgtKJuVjHoJ6gQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: a617419ncpwrhmuq3odtzp79jfiuxtdk
X-Rspamd-Queue-Id: 6749D20002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794311230-905649
X-HE-Meta: U2FsdGVkX19VF23VDkp1YQdxJyVMWrZJh7o5u+qeJ7WDVM+BqQxVdova3pmLzN8LhYUgetDEy9CnCPTBt8RiSGaKHFuT6dYu4TpCFrjZus7/jGmx5bzxwNYJCBO17kCVH/JWcUmgE8hSx+sklPrIfh0tC3WHKxsDyg488aBWSRii2HsAkrM0f/qlmImIxwiHRPbBILPF6zTPwqEy2UXkJjSc5YzldsYa41TDdGHWjhT+sjGRy50s4uNrfpXEcLKTMoopMNXQlTzG6XQpME37DfylCQcCPvKt1sqpLQ9PiBS4AriXc4awoZ1/+II5UJv2RVodbOF9q7FBggSBWwo5/29LD4Ajaz5rKX48N4dZ0+JKTagnSREssVyPqPeDPGYb8+ouW2+jR2NPAJ6PaLoQdDyBWx6uTY5xKiYW7RloXNvdfv1bTWslmlpy/FHtLOZyfHGc0KC8gktSWPnFdE5VY+EICeHkYXefXU6Q3uFyUVczTHFErmHgEXmNX5CvBkln7TjNs/vH0ikir1UFg1ifFQ1a0Xec3Zd0bPmsPnwHH+ykHAovNrmmbVTUMAuH3EqhJ9Y8KujV8HFqiJNgyK7X++J1bDETCZTPO0OjJov0zA5tjhx+FIpqcN7mUMIa1rb41x9s3OfY2l8suvYcYURsXWQ+zGOcLHI6DwGzTdF1uA0giJYv2UjTobPW2LBqa6zeiWEOrbVTDj952FM3OEgPO3pWGFzQvrqIZwaoNKm8AYZ1NOy8Ir52kebKup4pDWi7Hpl8mZAncPqpaBkydSWGXpfUr9rb3mGeaFQ+MieYj++c6LTPZgfcw+05fta6Z8hieWQteAo4GaeB6zZq0ziIkZbxEggbHuKBCDyIgyGqBgG86VZkoSrMxsUjxmnTlKVeDK71vQkqME3DXEUGHLU4bu8+CmWX7T0KahuXdsloZ0cFd+BwVDUFNo+gb/osnRjNhzRXNRYZ1gMfcOFYLDf
 eeKqCjYX
 gyUF7ymaet19IJAkRMz6hOtVj6T4cO9WZUFUbmN/bWBBoj8FAGVjMHBF7p9ewhuPv4/8qNey9CFuyIWnYFIjd/a2KxsFODkFHYRjpAhh/1Egi0RhYBW7mB3MTwSU9C9dSVXidnbiBpXnLbVf4T7EOQf1UdeTbud3LtQwNEc6ihbvIfjdXtrWPDPs9xuXCb1WdlYf6HR4/q2GLUigYORRwfaQ5NNB8p1FTRi4JbOKbd3HMrALBTAl24oxOrfm12whFN4JxiCOPiint4b7AmqSeapO0wKkb3JnA/mm8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The slow writeback report is printed on every wakeup of the waiter past
hung_task_timeout_secs, and twice each time.

Each flusher working for the waiter wakes it once it has not run for
half the timeout, so the hung task detector sees it make progress.

Since commit 84654c7f4730 ("wait: avoid spurious calls to
prepare_to_wait_event() in ___wait_event()"), wait_event() checks the
condition right after schedule() and again after
prepare_to_wait_event(), so each of those wakeups reports twice.

A sync of files dirtied from two cgroups, on a throttled null_blk device
with the timeout set to 5 seconds, gets 18 reports for a 29 second wait:

 INFO: The task sync:275 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
 INFO: The task sync:275 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
 INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
 INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
 ...

Set ->progress_stamp when the wait starts, so the first check does not
take a zero stamp for a timeout. The same test now prints 5 reports:

 INFO: The task sync:276 has been waiting for writeback completion for more than 5 seconds (bdi 252:0, work items left: 2).
 INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
 ...
 The task sync:276 waited 29 seconds for writeback completion on bdi 252:0

The flusher only checks for progress between inodes, so the wakeups now
land on the first inode boundary past the timeout, a bit more than a
timeout apart. The hung task detector scans once per timeout, so it can
catch the waiter between two wakeups.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e2da4781b5e00b..fcb7fb0196208b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -203,12 +203,13 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
 	int left = atomic_read(&done->cnt);
 
-	done->progress_stamp = jiffies;
-	if (left && timeout && (waited_secs > timeout))
+	if (left && timeout &&
+	    time_after(jiffies, done->progress_stamp + timeout * HZ))
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
 			current->comm, current->pid, waited_secs,
 			bdi_dev_name(bdi), left);
+	done->progress_stamp = jiffies;
 
 	return !left;
 }
@@ -230,6 +231,7 @@ void wb_wait_for_completion(struct wb_completion *done,
 	unsigned long timeout, waited;
 
 	done->wait_start = jiffies;
+	done->progress_stamp = done->wait_start;
 	atomic_dec(&done->cnt);		/* put down the initial count */
 	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
 
@@ -2135,7 +2137,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 
 		/* Report progress to inform the hung task detector of the progress. */
 		if (work->done && work->done->progress_stamp && timeout &&
-		   (jiffies - work->done->progress_stamp) > HZ * timeout / 2)
+		   (jiffies - work->done->progress_stamp) > HZ * timeout)
 			wake_up_all(work->done->waitq);
 
 		wbc_detach_inode(&wbc);

-- 
2.53.0-Meta


