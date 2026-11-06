Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71E4606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Lz18xgjT
Received: by kanga.kvack.org (Postfix)
	id 76FBE6B05B4; Fri,  6 Nov 2026 07:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC6C6B05B6; Fri,  6 Nov 2026 07:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548526B05B7; Fri,  6 Nov 2026 07:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8546B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:28:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42D6280D23
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:28:02 +0000 (UTC)
X-FDA: 85404621204.06.C40B38C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 67B061C000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:28:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Lz18xgjT;
	spf=pass (imf20.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968080;
	b=RBFIsntkE5fD+Y6Riq3zZtsBuZcjaFwEXcbmKO2BZBOeoyj/B4cRYtYOHghpVFaeN8uMHV
	jeDgwZsHFu8D1ullIHT4v+4AR8f3oZs7+VoR3qNqphF8WFEZ/lP3CIFcp0BCRv9xzG6fgo
	E/EgmwhAAv654f8BFHwWeCPNHc5p/Us=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Lz18xgjT;
	spf=pass (imf20.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0K0z0yTceTksPqIamPM3k9tvhF76ci83nLwd5+1KHsQ=;
	b=fgI7dGj6x4qyyLwa7Gq5+ytNZrRGR08wyUaPrf3Ys25vkxbBbyjBuuNP7RHpF5JNC3u+G6
	KOMKrnvuqG1ermh5ckhEo1X6eiSIrUShp/VmQvACo+LQbX4eGK3IhM9FygFzZ4o30f7yW1
	yLhVFSRTFTcXVak+XGOCSGKzm1s3dWo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=0K0z0yTceTksPqIamPM3k9tvhF76ci83nLwd5+1KHsQ=; b=Lz18xgjTW3Eh2aHokixjfUhLYn
	sHr5VrLzB26C2/gOGJRnkURgsccY/mjIAN2CRGMpBPifNXnD7Da24Z6fpRFePA+KA02Ns9/yLDcVF
	2MqcwCN3mgS6+JHkHJk7egJDedXHFVmyWe+sGGcyM7CArpvW8L23m5GNKuaT9J0hyO7RQU317YkE8
	1udLIzUOkygs6zXojidQRGE+46sK6b2s38FreI6PAxLSqx0RI0sxxnc3y1NjECNR6NUbGf3mx40cK
	ferojonEagaetim6BeonRxtuXJSTjPy3GwC35zYj7HXuun8orkM0iI6VGmo76edkVzilm5KjjtFpj
	xvYv6Rww==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2o-009HTw-0F;
	Fri, 06 Nov 2026 12:27:46 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 04:26:32 -0800
Subject: [PATCH 2/4] writeback: name the bdi in the slow writeback report
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-writeback_stall_report-v1-2-bf0c3b9023a5@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5387; i=leitao@debian.org;
 h=from:subject:message-id; bh=vGPPzg1eXn3iHlKOFVYXRKo9IwFuhJPYRhoA+zYRKhY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexJKO2ZNZa6uneAZzk/9PkGTt4+gcQMjO9d
 sjqxOz84Q2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 ba0mEACb2ydFMss9vayqjlC4o0sYYVPjf/oQTk01jLCDvdcx/IcMETO5xiJO8Uc6U3qXefvYCyT
 PoqH0YU+biQqdkC+avIMnMEE3Mav3MTIsbNvv/xgn/4dF316MQRfoEbY2rmMVr2/fPCQihc6gFt
 Ak7231toocCUeA0RaydMw90EaqDqOhSYtUb2GmFwtKRGTounUAkQ46DZzjCaPCOM5uhO8aUgCVR
 GXo9SQpomJqb91/20gJXd00YH73uYfk/DlRD7CW0xUb8QW6CpyXOE8wZToWnzHSuCOf07AULN11
 9SrT5RXEBJ/mi9O7LqSgiTj2gx3ZLViw1r6yoQcZI26VjrtqJZI/kKRGlr+1yzv8UuiHRrxVoHN
 F2g+kX8HNGRP+Y28e8sN1ktjICQ1Ww+x4bIE//mYdSsVOg9A8qB+Bb4EnkZIrwyruP3gUXVp/qF
 F7hlcqSnzNfLJgVlfWhVRMdiLhlvx9b3cwRa2KLq0wXZnk1nazMkgnquobNVVgDpKWifmnnMKIZ
 wgHTd/OoQZt9g+YoD1W1I9pFWt3iuCzS2MAg8/DW8W7yCkt6vHO77wPZcWT3tZNWH+4k9XkpoKV
 jzR2dwJQMudeDpBjMXz9ZNoUMZnOB75a0QG/8oIPVFAzOvTSBVY9UwQkbdw5HhdNQRRmADcyuRT
 qlhip55y+TPZnXg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: or5x1j7z5ybzqcq97ec5idcqsew8ggxs
X-Rspamd-Queue-Id: 67B061C000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793968080-197337
X-HE-Meta: U2FsdGVkX1+qXZrWTWc2aqOWmOe+0gbQd8RVhpBb8ki1xkGVBnD6j+SOH9Ng5biifxYOnFFDBsn2JRZUc3pWDUATEu0FyGteZgkuSwLJbVj2TqBJboCubz/s0lTEe41gmKMj8ylLUmXwrlKrjX54NbDhmkSibVZ+DN2mLtF4sn3gzaKrgoCU6meU5WnYLlu6ifynctmrFcCRpq3TjJDrHd90ggSM6MGFHv1Xj/hX2+rMbgTqKVKUgm8JcUFsm/ncu6ek06vss7ZizzCoWez+LBsu9u+LpFga1jJ51F44VxNuVS4yHAZkYvglMBJHFsW8SNi2Hj9GehFf7Hwx7xUi35c8o02rLXfEF6Pqkqif4OAKGlbP7KdqNYi39EyKgxpVtMASIzYMrIOy2xhLVw7QBQKgls4FRT7P1JGTGwnvIW0BrfyuTFDJ8c6s55A3T/VZopljy7g7U+DSiWoP6ogcpNnkgih+doAmtfeAddRxJt5ZLdHBI1Rv7u1ims+l/9KfMxp55sXWT60cffH6uhN2TkycnQw+bW9XB4cnRJYWEnq8Gs9Q7uXxI6SNsKlEY0MA1KUlgST12dHBkLgyljdDaOr0JwChjytikFUItTwUC1rH2Q5RlWgKk3jePD+xs+qmJoOW0HMsi717DMvR9JS3PCivTSUM7OfR14AaMeJ5ZOEiplL66WIBKfwYpQKw2bw2TYeRb/ecCVqMsXvAzoueYTn2bNHS2RGTgcH8ESBl8vDB4yDPMfuucAGMN/ke7LvhvFaTutS8BXidQcgu5tYdfPAgOvyW458e6zJba7hxKyTz8Ic1B6FIIjelWY8rX4sswt3Z+544M4LfjBAbKLQd6cfT83Y/kRiCVEXKo8dVjeBSfOzWcpB/V9iku9FILkgjnK7tVEMGhQMKR+Z8yZjV4dJ3il0BBdONf6MlPCTD834GkDoROJ++ZPotUZo5pizsEeD+x2drG9lauhpuqsg
 pixqrID0
 9MLGoO6Fv5oKnNyVSMTFSkynzwmQQhYmwS293GJPFVhj19SN+kP3WDB7WQKJs5KgzwBQlV8GbRp2qjEcvy9xno6PHDL4OtujcaRrFbrHivgX4KP5aOS+9dOdx1oS3gfe54sok9gyOOlbs6SmaHtT0vqqHWQ6kTgM5BtwGQ1dtiuVFwBD7BgVA8isGbQetNGdVHJV1khkHGz+6mPdUtCNXqEtUCy+MTIXTi3VXIuvzuqErUumeafTu+I7X8IS8G6b6I2BwItcFqQ6cZItTOO4JYguynOG8/LFjJ6ye
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The slow writeback report names the waiting task and how long it has
waited, but not what it is waiting on. On a machine with several
filesystems there is no way to tell which device is slow.

Pass the bdi to wb_wait_for_completion() and print its name on a second
line, together with the number of work items still outstanding. A sync
issues one work item per cgroup wb with dirty inodes, so the count also
shows whether a single cgroup is holding up the others.

wb_wait_for_completion() took the bdi until commit 5b9cce4c7eb0
("writeback: Generalize and expose wb_completion") made it usable for
the memcg foreign flushes. memcg tracks those by bdi id only and passes
NULL, which bdi_dev_name() prints as "(unknown)".

The first line does not change, so anything matching on it keeps
working. A sync on a throttled null_blk device now reports:

  INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.
        bdi 252:0, work items left: 1

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c           | 20 +++++++++++++-------
 include/linux/backing-dev.h |  3 ++-
 mm/memcontrol.c             |  2 +-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 01a00d7542b371..3dee9d65eaf721 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -196,16 +196,20 @@ static void wb_queue_work(struct bdi_writeback *wb,
 	spin_unlock_irq(&wb->work_lock);
 }
 
-static bool wb_wait_for_completion_cb(struct wb_completion *done)
+static bool wb_wait_for_completion_cb(struct wb_completion *done,
+				      struct backing_dev_info *bdi)
 {
 	unsigned long timeout = sysctl_hung_task_timeout_secs;
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
 
 	done->progress_stamp = jiffies;
-	if (timeout && (waited_secs > timeout))
+	if (timeout && (waited_secs > timeout)) {
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds.\n",
 			current->comm, current->pid, waited_secs);
+		pr_info("      bdi %s, work items left: %d\n",
+			bdi_dev_name(bdi), atomic_read(&done->cnt));
+	}
 
 	return !atomic_read(&done->cnt);
 }
@@ -213,6 +217,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
 /**
  * wb_wait_for_completion - wait for completion of bdi_writeback_works
  * @done: target wb_completion
+ * @bdi: bdi work items were issued to, NULL for the memcg foreign flushes
  *
  * Wait for one or more work items issued to @bdi with their ->done field
  * set to @done, which should have been initialized with
@@ -220,11 +225,12 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
  * are completed.  Work items which are waited upon aren't freed
  * automatically on completion.
  */
-void wb_wait_for_completion(struct wb_completion *done)
+void wb_wait_for_completion(struct wb_completion *done,
+			    struct backing_dev_info *bdi)
 {
 	done->wait_start = jiffies;
 	atomic_dec(&done->cnt);		/* put down the initial count */
-	wait_event(*done->waitq, wb_wait_for_completion_cb(done));
+	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -1164,7 +1170,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		last_wb = wb;
 
 		rcu_read_unlock();
-		wb_wait_for_completion(&fallback_work_done);
+		wb_wait_for_completion(&fallback_work_done, bdi);
 		goto restart;
 	}
 	rcu_read_unlock();
@@ -2972,7 +2978,7 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
-	wb_wait_for_completion(&done);
+	wb_wait_for_completion(&done, bdi);
 }
 
 /**
@@ -3069,7 +3075,7 @@ void sync_inodes_sb(struct super_block *sb)
 	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
 	bdi_down_write_wb_switch_rwsem(bdi);
 	bdi_split_work_to_wbs(bdi, &work, false);
-	wb_wait_for_completion(&done);
+	wb_wait_for_completion(&done, bdi);
 	bdi_up_write_wb_switch_rwsem(bdi);
 
 	wait_sb_inodes(sb);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c2284466e7aa66..808d939d2ca7f9 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -39,7 +39,8 @@ struct backing_dev_info *bdi_alloc(int node_id);
 void wb_start_background_writeback(struct bdi_writeback *wb);
 void wb_workfn(struct work_struct *work);
 
-void wb_wait_for_completion(struct wb_completion *done);
+void wb_wait_for_completion(struct wb_completion *done,
+			    struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac6c43ea8c5a6d..df462d279a655e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4525,7 +4525,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+		wb_wait_for_completion(&memcg->cgwb_frn[i].done, NULL);
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);

-- 
2.53.0-Meta


