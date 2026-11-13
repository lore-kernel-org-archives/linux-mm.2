Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A595F606B58E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRpZnT4t
Received: by kanga.kvack.org (Postfix)
	id 1DD386B06FE; Fri, 13 Nov 2026 07:02:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B52D6B06FF; Fri, 13 Nov 2026 07:02:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3506B0700; Fri, 13 Nov 2026 07:02:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D57EA6B06FE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:02:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F7981C3B0E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:10 +0000 (UTC)
X-FDA: 85429957620.09.085A40D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 91A9440014
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRpZnT4t;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUJ/RH16CUAQaM0PxhxLjbl6pOsDoCFNUfhjJDzXYAI=;
	b=W5ij1VTMsWFulJIPU88Vl0QJVYn8S05s8fEvoMBwcHd+NKCsOysQ+EM7r/84nzcV6xJvT8
	KQ9gCJAcvcU0pVHH4nmGPm8ph4xrrJTb4xefmif3FpgtEKkyFENKfJQX06syQ7Rl4sQUxY
	bVVXWbA25pDeNmMUnsx7ak0CMEewqQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571328;
	b=U0HbxqcGz6MrplPnbF2AHI2/3VZNx7P4R8cuaxVXc8nRzfzR6gqrI8q99Nl8qd9K5ztRv+
	xpMy25nLguoUe+tKdp7FSPlxjmLgyiyrVA1gXNNV6eGeu/8fg7k90MczRLxU1yyaip34yb
	tDP32QyiZeEY0bZohX6E/Z220cfcCzU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRpZnT4t;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ECE362236;
	Fri, 13 Nov 2026 12:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECC31F000C8;
	Fri, 13 Nov 2026 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571327;
	bh=YUJ/RH16CUAQaM0PxhxLjbl6pOsDoCFNUfhjJDzXYAI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JRpZnT4t/jYbHpTQBZoAPxuC43KKqhQeXRStGzW9hFFjLHr69igGE2UBo+5YKnWrI
	 6yXrPHlE7MVQKWFxBfBxlYZFy9S/vpLmUeGY3XqZjw//xJk7S0I5D1emk0NJFzB0U2
	 I3er5eljWMspmrvP0zgjWx8CbO5RuNDw/Wmn821zjZ+wkK2GUGAVl+HvAPjaVuAlIc
	 V/u3bYzEQCIURcDJ0eTE7xnepibFXGJ7BpvW3cQ2TTowUrEKBRovXGNL5psqJ/gAnu
	 vt0GVMPoozgBRhxRRGXMpZFjJYlQ2RL1gwHgAFYHmYciD5STu+MbLlHB3XtPlMAbPq
	 rHJ0XuzI4u4jQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:23 +0100
Subject: [PATCH v3 27/33] gfs2: wait for a pending withdraw before
 remounting read-only
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-27-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2800; i=brauner@kernel.org;
 h=from:subject:message-id; bh=c4mPQccEi9gz8unBosiI8qBxJmixdc+IlKuwVCk3jlI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73LfPfKBzIWqW9OvkvPjHxZM8nQtbrctT3gRuaXb
 rV/CWcnd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk6W+Gf5olC2Qc59ZVZAX3
 b9B4uFE95lx3xlX1KVFTD/fuKuKQTmBkuK4jWLf9WX8Nd90m/zPsRT+evmA7t3Hd0qArEs5hkU4
 GzAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: 9x6zgggguhec11osuckafd3abmmh5tf8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 91A9440014
X-Rspam-User: 
X-HE-Tag: 1794571328-102900
X-HE-Meta: U2FsdGVkX1/mI57LKYdlCfYIpaMfMzQeCO5d/PGKiuNhTDiV/KZ66zzNN9pz/phRRokLckmFkCFxSQzTAPrJs05BeI7mLoqj9HqJKTRCoy0UxooNVK1z4v4xguBa1dmmL+9fCMb7KRdTMTG9msN6yWzmemEVwkwRSTP1xdEZ6ckXVMWHiaTqEQBZCe0NpgquVIOupHf9wsdmvGi4jjCV1gSp0PzNR57Uyj1tIBqZ+aKRy43OlCcLTjAEx0t7x2vsFwIpcipCN09uHbmhGMb+4Z6NOgPQ54658JTdKKvK9SYdSyLX1lStDpSFiD0l120Tqef52w38QVnO1IyQ6zpiKDqcOCvsYfuBV24aowHTvnjvkO6tPyYbIyLnc639TG02lITbfRDxGvh/d31LB/jcr20aTmyeS/c6Sed3AqWhcAkaRYZf4u3P68+0kRSVVA3JGRhCpGB7+YKGnQF0VDnS/spOs42724d4L6ODCV2dM4NzsXxCR8F2JwwpieRbzp+M3sXteCXxGu4PA2Dv8o1uSJQ2Axa+ZFFuFxChRkDn6JC8QsuR3sWuWdZj9gTPV1e7OZSQjTI7TjKw4/Me1/x3Me3xAdJiiymGPqKcZugmd0WzEdBTB6X9SnnAuYS5v2pUnBMScjET847fXMW7GkuTWr1F0oMVtMroCElTaThMwxbFspjPwYit/m8K93PaFVK/nYK2E3cDmUKbFnmsl2joAcKilyGVHqiBuBhz5O07/zTt4zw2JsL33+/6VGESbgIWneTyZFfNnide6RX7jCfZ2wBsWxEzUOAGC9b6NqmSxidNkyuHzhzOXuOhfLkEbmZdeA/nYnnNXFLEkMHgr78hIfEABr3V17uCC2JZqsJIGl/PSGloWGYyUTlTqT7DsLvxVvrdbfnLTa2FtfrYNkja8+ehfH/2aok3VKwj1s/ygA+hKE6vC8h3gGYrcIUOOX6CM2MmwIH+Vg2npIMkPLy
 Hu8l+5ua
 c30C/MN+1Jo2d296Hifl6afgbVJ1jfQrOCEBEMNBlDq9QiJGPOrAZOfpstelZH63sI/N/zTo6P05VYNIsVZRlrDs/xPqyO7YDdB93u9YJgEXGnXjFfdGt5kwVDwUFxbXrT5mEWxdzr6fHou6NIR6NzkxL7sDmuYaNaJ/WDEmEghcmfTCvkC7Wr5QHywuaEFK+Tzn+lXwX3Ci87uJybFt4FEtWjFE0b2jSAvurVy6pH2fiwpXmKVOXvHAFJfROGLf8SPvJK96s7l853BD7T0VF1XQaq+CgkoL669t6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 9c4a3de6cd5b ("gfs2: Asynchronous withdraw") most of a
withdraw happens in do_withdraw() from a work item and SDF_JOURNAL_LIVE
stays set until then. A remount to read-only in that window bails out of
its log flushes on the withdrawn filesystem and gfs2_quota_cleanup()
hits its BUG_ON(). Flushing the work isn't enough because
gfs2_withdraw() only queues it after setting SDF_WITHDRAWN and a
withdraw can also start in the middle of gfs2_make_fs_ro().

So let do_withdraw() wake up waiters when it clears SDF_JOURNAL_LIVE and
let gfs2_make_fs_ro() wait for that right before gfs2_quota_cleanup().
umount doesn't need to wait because it sets SDF_NORECOVERY first.

gfs2_make_fs_rw() could leave the bit set on a withdrawn filesystem too
if do_withdraw() ran between its withdraw check and setting the bit. So
do both under sd_log_flush_lock which do_withdraw() holds while it tests
the bit.

Fixes: 9c4a3de6cd5b ("gfs2: Asynchronous withdraw")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/gfs2/super.c | 20 ++++++++++++++++----
 fs/gfs2/util.c  |  2 +-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 04bb4cf787d4d..f61c309368ef1 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -146,12 +146,21 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	}
 
 	error = gfs2_quota_init(sdp);
-	if (!error && gfs2_withdrawn(sdp)) {
-		gfs2_quota_cleanup(sdp);
+	if (error)
+		return error;
+
+	/*
+	 * Check for a withdraw under the lock do_withdraw() holds while it
+	 * takes a live journal down, so one of them sees the other.
+	 */
+	down_write(&sdp->sd_log_flush_lock);
+	if (gfs2_withdrawn(sdp))
 		error = -EIO;
-	}
-	if (!error)
+	else
 		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
+	up_write(&sdp->sd_log_flush_lock);
+	if (error)
+		gfs2_quota_cleanup(sdp);
 	return error;
 }
 
@@ -567,6 +576,9 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 				   HZ * 5);
 		gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
 	}
+	/* A withdraw that do_withdraw() didn't finish yet leaves it live. */
+	if (!test_bit(SDF_NORECOVERY, &sdp->sd_flags))
+		wait_on_bit(&sdp->sd_flags, SDF_JOURNAL_LIVE, TASK_UNINTERRUPTIBLE);
 	gfs2_quota_cleanup(sdp);
 }
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 529c3ec37a18a..888e0d6bf5122 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -121,7 +121,7 @@ static void do_withdraw(struct gfs2_sbd *sdp)
 		up_write(&sdp->sd_log_flush_lock);
 		return;
 	}
-	clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
+	clear_and_wake_up_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	gfs2_ail_drain(sdp); /* frees all transactions */
 	up_write(&sdp->sd_log_flush_lock);
 

-- 
2.53.0


