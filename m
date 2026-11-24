Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB525606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ma/kTwrb
Received: by kanga.kvack.org (Postfix)
	id 7B7416B0896; Tue, 24 Nov 2026 18:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740006B0897; Tue, 24 Nov 2026 18:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB046B0898; Tue, 24 Nov 2026 18:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2811D6B0896
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC17B1C48A9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:29 +0000 (UTC)
X-FDA: 85471533378.07.90B2F9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B5887A0017
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ma/kTwrb";
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561227;
	b=YTPG4POWeXyHpGCTDarz8A2CoPlF6kWuzQECWH+BV/u3Z8DRTnJUOL44sE/ArH4S/LqLV4
	NYendaTFONsNLGtO6ehz4teFguPevRpuFbYFeUYkgBr0gcdGg3Ss210YyXOcqAdtuwtTDR
	n01KzghwIXFdsoJ2q7Lnjrx52aJmJPM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WThBmHMF1JHqTiDTsb9DdVdc8rlMyonCV9j9R+vsC04=;
	b=N1b7uzP4gG8c9WiKDeWOp+8x4jopAAwviiNaEtfVsyI1YnYkXRcwcBsnVFLBwBiP8HK+aC
	YjP+tyb9zZPYnGDcDIJ2rHHDwM0OzbWSK4UTVjJ7E8uA/daInv/PDwfuEgD7jJ+oiz5bhR
	/1tNe8tWzDr3yjT0epqc8QhcyjQMl8I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ma/kTwrb";
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A5164172D;
	Tue, 24 Nov 2026 23:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36191F000EE;
	Tue, 24 Nov 2026 23:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561226;
	bh=WThBmHMF1JHqTiDTsb9DdVdc8rlMyonCV9j9R+vsC04=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ma/kTwrbgGWzl6OUDPxm2b1uvUfXED6heMx8/GAQ+TmwPMgDj7YeoL/vAd9wCP14m
	 YUZbBVmtGEuPOEoshmuDdvOrDNpUVZQhBQB2aMYPssgViwryjxnFVE/Q/zmeaDwIs2
	 wod02cIxg6wwY1IVnd4xkMfiSKIfktKeUdlwtuNVDi8LXMENXJ4d9qrgKf9pbivd2v
	 QUK0rdG9zH+Z8iDtQ7zGZ3WIiBpe67f31nO3orUxPKFV5klrVIWWtYsM7fTwsAtWJ0
	 PZI5K5UuFXnRY7B/k+vfb0knWfUlCHh89/lspfwvzMI2hwae6n/TPZqvq+Dz87Hqb6
	 kK1SWsuobrxAg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:38 +0100
Subject: [PATCH RFC 15/19] exec: don't take the mmap lock of the old mm
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-15-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=2065; i=brauner@kernel.org;
 h=from:subject:message-id; bh=114ewuP1qi1vzBdxjYYmwU6Ys2yZO4jjwhrnzG8rjnM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziR1LinzlUrRMoahenMHOausTpuyoszPeB6+/Kb5T9
 k7UlIrbHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABORjmRkaP3H8G67EPe8xgN7
 b2mlpDUdzKqfLFSR/bojZvIrJ/6Z6xgZZtttOBW4e2XAT3fdoECryuVGT6obVnlFfViRseDT0h3
 3+QE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B5887A0017
X-Stat-Signature: mairjxp4fmr48rkjxads7js4e3d76fis
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795561227-120294
X-HE-Meta: U2FsdGVkX1+VfMzwstI0JoNilaPvZKXgrvwXdbEj1OquUAXvB3N5Tf9OTH5uBKtF06oZacXtiN95YV8KvJsOFv/5MzIjUpK/a84oa7OZ0HQtfBdK65JA1H16lixHlBFKeuckpzu09TyRiiEn9uQVjdG+AsTIb73pW7X/CvmCNvxjoSeNDm98fBSIBEnHMY/RNMbj2tyMtDyU+WGj+iRV0JM6kKL+kVvMkAJ0Cv8sLGGJ8m8L9mHaQAG5Nm/nREQ5yI1CgEDPuxbdtdhtrnacdGrQkNu902bLoQ9rsYINdS4U14FV89KwpokQkVcrcokjzgGCh7KHwpGn/e/rT8KCELpIFD5u5JHeMn9Xw6gZNJitRodR9zJGFVuYVGOJbMk0l73ZWT7NvLqIwXBn2dL51bR9CmX9i1OBDuO1mQTMNSWu9hZOQVkmmJRHH/wCnAlGrKTg0iUHEPgv/+sZuyGcHBlCFfXtvt9f/dLCO9hm6FyfMomsBlicasuZJ71oO9IyNifzA+JNVaUN2BRYNbZZ2HvFWyxG9cn245IEpeGImPb/x0Rq4yOF+NJE9roUoI1tqN2XbeyFi9stvTGuQSt+/SLQ5+YXcekJy79QJO7X6Blr2VLyW68FxdD/Z1oo2ddzkx06icTdEPwtTohIaGLluVtRJNm9yDBFCCGPIMfraEimv+lgELZ2P1plztZWvDHk/q9/DMbN9kHFsfZUCTP6gfrmLFJcuEbZMTBZo0Uz3Wv8ka2Fx/ZzxxCtdZo4XGxYuPeMo2XA9+2Z0xOLZBYZ7QD/gMINQHZ5t8j8XplbXsHC4ATpZeugjD/beKxKBXlLBzpQVAEZVzDYmw5X+1XdxDoLZhXlYRnZXOJNcSUtJNCUNLSJCI+mpaT+rYuU2ETXoiGJGYlVtBgwMqHfPdbLvMk4iQeCyuZwxhEsopRS4UY5DemLbpvougaD14ErncBw2k+ChMu3aX8Ivt5Df96
 HN1dXtpG
 JlLlGNctc+boyWWAQciNBHkRi1gvAKV/PkUac3GRq3spOJfT6+f+287mqAR2solBRvgyinQL6w8C09wRz6++sikuECbot8MiPctnr2TUQeyRiT/0ZFYhaG755Tr7gACk29yR0YSIQdueRdMRBU7l6E3RzNwbNWUkmkaQ0eOUCmBJ9odfErJLZrlmLoOLsXN0vlieTmE6L5HB/q6L5BjNbGcZT4Zxr8m1CXnjkPziBgwAKty85OR6vtfj5vPPstJ2vr1hK7Ha9iQeO+BojvOOU8nED8nXtV+f3fXId0kPGn042UbIXWvZkY+78HIinbHsK8qQ6415u1lmZ/HkENklywsvpSz8sDdOv+OwPgi73eBTAzm+C/ZCdwietSEe67fLJrs9ffOrmmZNdp+nQiQ/OX4p/njNmJIPb5uTyP031C4fPpo0csEosIYV8mOZeKjNgd7vZBGw+lHPDP+X8EtS8wr3UIi8ZyLhCELlHCtpz8b0ZXIc0RQok584NXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

exec_mmap() takes the mmap lock of the old mm for reading while it
switches the task over to the new mm. And it does that with
exec_update_lock held for writing.

That lock was only ever needed for coredumps. The coredump code used to
take the mmap lock for writing and then killed every task using the mm.
So exec had to check for a coredump in progress under the mmap lock
before it left the mm. Commit 7e3c4fb7fc19 ("exec: Check for a pending
fatal signal instead of core_state") replaced that check with
mmap_read_lock_killable(). And since commit 0258b5fd7c71 ("coredump:
Limit coredumps to a single thread group") a coredump doesn't kill
anything outside of its own thread-group and doesn't take the mmap lock
to find tasks anymore. An exec in the same thread-group is serialized
against the coredump in de_thread().

Nothing else relies on the mmap lock to keep a task from leaving its mm.

exit_mm() takes the mmap lock for the same historical reason. The next
patch removes that one.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6120310f3fbab..78046ed839646 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -864,19 +864,6 @@ static int exec_mmap(struct linux_binprm *bprm)
 	if (ret)
 		return ret;
 
-	if (old_mm) {
-		/*
-		 * If there is a pending fatal signal perhaps a signal
-		 * whose default action is to create a coredump get
-		 * out and die instead of going through with the exec.
-		 */
-		ret = mmap_read_lock_killable(old_mm);
-		if (ret) {
-			up_write(&tsk->signal->exec_update_lock);
-			return ret;
-		}
-	}
-
 	task_lock(tsk);
 	membarrier_exec_mmap(mm);
 
@@ -903,7 +890,6 @@ static int exec_mmap(struct linux_binprm *bprm)
 	task_unlock(tsk);
 	lru_gen_use_mm(mm);
 	if (old_mm) {
-		mmap_read_unlock(old_mm);
 		BUG_ON(active_mm != old_mm);
 		/* Defer teardown to setup_new_exec(), outside the exec locks. */
 		bprm->old_mm = old_mm;

-- 
2.53.0


