Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98702606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=iL/G31qz
Received: by kanga.kvack.org (Postfix)
	id EBF5F6B05B8; Fri,  6 Nov 2026 07:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72566B05B9; Fri,  6 Nov 2026 07:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85AE6B05BA; Fri,  6 Nov 2026 07:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F12F6B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:28:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28509120D10
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:28:13 +0000 (UTC)
X-FDA: 85404621666.04.417A483
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56FC7140009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:28:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="iL/G31qz";
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xXFaQslh1ktPeBKSCuZk9/R23tHT1fC6uCumCOv/+0=;
	b=Jf2Axiq6AAVebWeR6Sy58vMZZ3CUxtDmh8OlYlOxuvZtJQvT7Y3AKDDLFyIvGasq4UPUSQ
	g8DiSpWYpSeRImxPvSBTrgHqighv/NUF/m2bqiFnZ0iV2y7S7WtnomIqmyqlci97U8cqPd
	1TpP/s+WlDR09mNX5d7ZrJOJX8lP8WY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968091;
	b=R6zjqnN4s62v0qvgrFuEefaAlNusAVd3xGNmOBtjEfBv7OTvKk5357oIxbsPSv/pFkfRIk
	gZ8lOx9DCSCCEBSA4Ghwy2SO1Nau3XTSWVtaV4SKdtjc/M+RZ14F2LZr55h146wxZJd9z4
	ssojD4Igg1NrpT2PnC5XhTOZHKmTCfg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="iL/G31qz";
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=2xXFaQslh1ktPeBKSCuZk9/R23tHT1fC6uCumCOv/+0=; b=iL/G31qzO/t6eU7RfzxkVzPE/q
	vld4ozQOKZqn3RUYRb4Vu11OwtF2bkOapFX6hJSBlpVAY6FalSigIhJk/PTZBCD25FvsHGhg/zofV
	m0S4QBx5QMjkjJB2mjGT9wj9exjhATNUSQDK7cVRBOI0BM//EtWJyz7ligxWkL+6JWN14QlogyGeA
	ttfgAPVsx9z8bXqy3+Aa2QT4gu4kaEhKw6fKapP5F5Gjd6NU4JUXyM9EOIwWSLVfZ2i2Qubfy7lkd
	aZPwb4Ety+iZmtkqmJkK08+jDrtM72PdYsCylBNnkSR+UQkc85iXnsdawtUcPOME3/AgzklJ4FThz
	mwczTPYA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2y-009HUO-3B;
	Fri, 06 Nov 2026 12:27:57 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 04:26:34 -0800
Subject: [PATCH 4/4] writeback: report a slow writeback wait once per
 timeout
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3599; i=leitao@debian.org;
 h=from:subject:message-id; bh=QXKI9SIu/Eds5pHpL1MLns0a6wtiNFTdigYu7otzjwM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexGOIQ4gST4wB+rTUnGbrNRqBhpjCgYX9BW
 NvtvBMCWx+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 bYUBD/4reK513xbT38cDoDqzrTNVacq1LEms0wFUfY8K8QaNUXeaE2hDmhuKy+fyE76RBQKsJSq
 0gIUayfAQkoJHNAiS4oJihXsEd1JTxUkH8uWa+WRXumBlOK5un61ibF95g/lKKJwx5dtSGpQ+t9
 4G2N5ZiSo4uetBoU7qxqyQdQFeDkFQfJuMlHRm3G2uTLqO5EsT/Ws9/SruNmSctI6iO6yqyN/OC
 hguy5SFNifotoy0+O9zvmrDKkA7Zr8Fg3iDxJZopc4S9L25U6nTPnr+uwRXatatpdb5rYOPzWsy
 0NDTvY3lymKnLbnC4irDcJO5qBmN8EgdS9TFGsUZ6rShkYx52G+o4OAoF7gGXuLEMGVpBqQM35x
 Y0vGnx4kIIrNxoRebnUEjfSjGbsxst8rkQtP8e9xi0Rel+B0fU254/4Anx4bPozgGATgNoDSu0M
 srjJLe0spCvhcA7CHLzq6ksy2j0oactskh+SVdcvqX2UwYQlduqg1cuUfw6Bjx2ieSz0/PThv5b
 n4ncmGb4EoGKToCwbgDvXYDtbXkH0hG4ah5n+yJNhMPOXSgpEMDrn35Tt0uorjJlRlWBPAUIwpX
 wiDCDyROaBwd8F9gKKcK6hc+tKpi8efNgLUh/Bm58CCbDpdUMGmpYBFLChDpcJKViLfyPY5JRiP
 tWEzBTmcxdUer1Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam06
X-Stat-Signature: zdijinuhkc5c6b9fcypzfq37nbdkdwq5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 56FC7140009
X-Rspam-User: 
X-HE-Tag: 1793968091-248649
X-HE-Meta: U2FsdGVkX19ywI5/vpAR5X0j1Ycv7eRjXL+ezhuFvogICFUEO+6qSucp4o8/iDfIS9uchpMVlxERBQ1nemgPTFDxx5cndIss29FUsyYzX05Va6eS8K3wPm/43YrztxdeSyYNFDj0c2z+0cCw3/P5eIEf1FAVuDlzkEzRviSSvEb3fLRevtQEnrEQQVOSvkVKdVhhqL6qCGF1pYABOt5zI9juZDX6jwuRtX1J1D7YZc2MI16VYQ654xqBb9j+JtykFNqAV519n/e0u50O88lLB+KKP/YGrxXdZH0wutfMvffqdRAaMidfQtUEzDEfOx79Or0gGkCn7OBdGvtEt1ZFSxCDCGmOjbbQoHstFmysaisZkkiw5e/eHan108xIvTykCSFdeecKa5masA0yvs2OKhG5Xy1FIc7EFzUzCIBoBm1Qq02M7HUNwcDSI4AdQX9wSKWwM+tp5wJfERh0DJtIX79nibjrYJnTqGw/7ZUeYHWu//pGamF+ax2R/dQdY8JlmBHFVYxDrATnE3r3Hg3dfMnp+R4Zbdvd8aRiL963cGWJ85Bs8ZI/vEeZddAo9D7G4veEqq+cCKbVkW93XIxWFjy7BLY3Kga4p7AREQusYErx5wRc8snl3fOdC2lBh4fvGWvgTx3Y6cDsF7TUQ+7WtheUM9zWXqJEHGK3ZciqxXXXWD5mBK89ZaWRg6SjbQbEPMvHbGb3g6SbO4fP0ty9V2M0gLfUCnOHOU5Sg2rseItuezqLITb86cF3zyyj1utsp9of4KbO0ldCs7RX4HX3DAW9RtdaCXan0zpQBRNpAMGpHTKUtXeIogYaypEtLWy/eBwvNVld2tEUpdm5YAMvUJM2VTqosSRkYP9R9KFrRiBDivQHeI55IcKF2Urw6lGZaK6egPxIigwULIo+XUWPtw9RD+CA44yo2sSanPyrXxOvRU2i+T3Hqv1kIH9IYN1p5s/Z3MipyLicyE9qlDY
 G/wMmztv
 +SD1OL5FxxBgAKLNDBqe63Uet3e/wGYtjukwziwtqtguGi8vgyrcVCe4IVBVfeqcXzmjKslGSoGtI0xPaOgV1JBEzM9GaRAKENQPDaIXsihlh4jQIVBgY04r3rxe/nTMJ5eEyZ9X8Uz1O4C1G6Ubac17hEPHJgG0NUdTaBVkqrYrl3LZbRCQleB66XwQRaR+ezpPVniEEkT5M8wQcZWZGPcGl76X+w6C/6bpwdFG/Q8JTwHUelzVOx5tl7rnPACsy9295GPaBPmvX/EMyWf6su8Ih30qBs8M3HzA76yHKT85FwRmGSPXvHk+pCPrm8ng/wWRywDKwwcFQVHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The slow writeback report is printed on every wakeup of the waiter past
hung_task_timeout_secs, and the waiter is woken more often than that.

Each flusher working for it wakes it once it has not run for half the
timeout. All waiters on a bdi share bdi->wb_waitq, so a wakeup meant for
one of them reaches all of them.

A sync of files dirtied from two cgroups, on a throttled null_blk device
with the timeout set to 5 seconds, gets a report every half timeout,
each printed twice, 18 reports for a 29 second wait:

  [   10.327992] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
  [   10.328000]       bdi 252:0, work items left: 2
  [   10.328003] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
  [   10.328004]       bdi 252:0, work items left: 2
  [   12.888187] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
  [   12.888195]       bdi 252:0, work items left: 2
  [   12.888197] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
  [   12.888198]       bdi 252:0, work items left: 2
  ...

Remember when the waiter last reported, and report again only once
another timeout has passed. The wakeups do not change, so the hung task
detector still sees the waiter making progress. The same test now
prints 5 reports:

  [    7.661129] INFO: The task sync:277 has been waiting for writeback completion for more than 5 seconds.
  [    7.661136]       bdi 252:0, work items left: 2
  [   13.241102] INFO: The task sync:277 has been waiting for writeback completion for more than 11 seconds.
  [   13.241109]       bdi 252:0, work items left: 2
  ...
  [   31.801068] The task sync:277 waited 29 seconds for writeback completion on bdi 252:0

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c                | 5 ++++-
 include/linux/backing-dev-defs.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index cdb2631b8552e1..8d354784326f7a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -204,7 +204,9 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
 	int left = atomic_read(&done->cnt);
 
 	done->progress_stamp = jiffies;
-	if (left && timeout && (waited_secs > timeout)) {
+	if (left && timeout &&
+	    time_after(jiffies, done->report_stamp + timeout * HZ)) {
+		done->report_stamp = jiffies;
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds.\n",
 			current->comm, current->pid, waited_secs);
@@ -232,6 +234,7 @@ void wb_wait_for_completion(struct wb_completion *done,
 	unsigned long timeout, waited;
 
 	done->wait_start = jiffies;
+	done->report_stamp = done->wait_start;
 	atomic_dec(&done->cnt);		/* put down the initial count */
 	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
 
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 4f10849373150d..f9fd3b1bf4c609 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -67,6 +67,7 @@ struct wb_completion {
 	wait_queue_head_t	*waitq;
 	unsigned long progress_stamp;	/* The jiffies when slow progress is detected */
 	unsigned long wait_start;	/* The jiffies when waiting for the writeback work to finish */
+	unsigned long report_stamp;	/* The jiffies of the last report */
 };
 
 #define __WB_COMPLETION_INIT(_waitq)	\

-- 
2.53.0-Meta


