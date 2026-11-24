Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBE6606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AX8myc6P
Received: by kanga.kvack.org (Postfix)
	id 8C6D36B0883; Tue, 24 Nov 2026 17:59:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F486B0885; Tue, 24 Nov 2026 17:59:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5406B0886; Tue, 24 Nov 2026 17:59:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 422AE6B0883
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:59:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC6D1C0D60
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:55 +0000 (UTC)
X-FDA: 85471531950.08.553AB7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DEF5240016
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AX8myc6P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561194;
	b=h7T4aeRH8xwXuBz7cgfcEnAc3S5owMp2pk9iyMmptq7UJNjS6Uko18yywe/8Fc4JQ01WSO
	s08KZ7Q1bATYpKflZ9pDilXdo5btVvrkck6dfi9dqCKzoTu+RyvuIhepTM/me7Ll0Rf30O
	s7nlStPI2aCKEHp4LSJc6DwUb25LpQM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXmAmGdBNLLBP4R6S0ZfcTIok2405TTTPIbQrdyiZZw=;
	b=TggvuxH1p0nH3aqZmw87KdYAOBhGMamvHsIeBZSGjtxL7MieW8Ms4WdxB4faIN63LKOBYG
	lSk3HxtGzfp2JqF/qT9/ansZWWrzJSJzIRBQC9C55ckVwA43CE/13OxmJSA5Jxe6nHs0qS
	leR0djqs+ZJ5O8nOLP/o4+kQ/3k2qLI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AX8myc6P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D5EF43795;
	Tue, 24 Nov 2026 22:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1744F1F000F2;
	Tue, 24 Nov 2026 22:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561193;
	bh=LXmAmGdBNLLBP4R6S0ZfcTIok2405TTTPIbQrdyiZZw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AX8myc6PK9Et1np5YJLmjrgno2cX9NsDytcEZbZlB9OZmyITi41GUplWWvz5coWZ/
	 oKMVzLU57myhtd/Z6GnvQ37v8ruIRBVvTY8ziFcWwnKzcymwdOcUtdt2wOjAiFPbc8
	 XzF84LtsDOYDEHJuhSCyAB6HKq41AZskoDTl3zSdf6wAMc1MESsyvFnnVoWTrxylqb
	 p4ouxxHAZK7TquvbrphpwIoOspozvJMVfR/F2vH1afymmxwSJ5ydlzlu9vHbtsdQtv
	 CIjVYV9iT/ZDAkkmmFLqU0pKLMX4CCiBHfJdSa8LBkxoildxpoySNtAUArjfOZc5Ql
	 pv4qTDO95TOUg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:29 +0100
Subject: [PATCH RFC 06/19] exec: move unshare_sighand() before exec_mmap()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-6-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=2206; i=brauner@kernel.org;
 h=from:subject:message-id; bh=M1m34MDED+Y6PEKM7nEMrksy4d72guGeEChTZo/u7p8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSzie3ZteW3aI9x60n9Pe/OvhHLVX4e/j414rvz/g/1v
 LyJbYqhHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZWM3wP3Hes+TLvJtzPuu4
 d3+TCL79Y///gOMfF8rcnfA+6rHSi2UM/2M/B31rL375oV3m107F6i2Ky1VZ4/gm7N2z8mTcr6/
 vT7MBAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wzb3e8q636inzrix1qha1tkuusemesrg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DEF5240016
X-Rspam-User:
X-HE-Tag: 1795561193-627671
X-HE-Meta: U2FsdGVkX19gH6K7Zh3e5QEL+dep0ONNwK8PWIQrhN5mdABNoZZ29yF+cEkE1fGj5xL0mQHkaU15ou/w258OW6h6w9tdHjjczI97tcmydE37xIWtT0XGEEOVpktO525CsXlRRV/SeT1WYR4eYrVRIr/BzxQ3vWtfmTZGwYLU6xj51G3URooZWSFVDUzgYJOM5+XiaJBq/N67OBiNYPv8VV74Y+DU7oz00C4ChaFPevl+S8lQ5I4yG6LFSaejlwlAb8f+Hk3OzWdTR8/tknekMCWomgLU4NH6vjOQHpugHmpn9cUoHh8CF7vcsvWnjHb9okYbVPEMyRYhd/4Uv8THgFQ7Mo3+/NF6Nr95pQq9QLSF+bANJrvB5qwhykDTEIvP7byDIl5ML6UwJUKVBwnNSqKtXdk0p+em+wOp7CfOvjuJzdoZVgH+SEw0Fv2ueElRQmUYukTKhRcS0endEfs3kyHON5U192+DSBlvYxXcez0ifYwdmwiqnqLEV04AEBW8DWeGneJBDnq9bfXJChIhxePt6Z9GUv9vF6ONjQZ+9vWyNAZu1D1+FjM/Ph/OwVaIpmtUvpGAgZbtDGJ1nEUKe/0EO3mGdK2n8iBxPvXLaa+YCGZBTHcncVnz7s+hIKoMIDt6kHv7m4aD5LGBOiVdFGnaRUyRQ5I+LWZ3onpBvrx/7PdQu5pwvliuL/6bA2LLoOfAjM76tOPgvupGe/u+2bjdzv67n/yywK2g6sKGZkWKrjpzEckU86iNYURkS1ElnrU9UzhuN4G6jeDN581VkVJzk7Nh5YlP0OMvzWZTl8FYCxmoQ1+H6/wxCqBSbbiykv+MyYmjC91kIVjMAtHZfV815cqmk12z2ZxZkiAX2bKiSAWJVYZ06ZT3rPoNTdzjuYdFVMe9RNJSb6Fh8ht97CiMthp5pfF3qSsVGH4nuOLkgrLw8FopfxLEP57s0+e0Lkurh+KrT5jPf7MxlyW
 ASfqr8m2
 3S85FS4/iETIZ/uhpE8yZZiy6YKDcCMmPbmlrrQQH0GSzdz90q79ClVirKGBYgvoOnr+mWD3TFOXdBZsSgiYJiBzKJ62HMn+mJ98QoJei11AaUkM6Wa8yp8uWs99DJ8fpqn3iGkACHug1e938cZRDGNcDOZHMIYpBUAZTRqRVixlFgqyMD3OGe8S9hAGzTO6ecFd/FGQGkP70jb56JBcJMLGUTOgUTmV6wfZTsQxvNTT4dFh70QMXSVoHGE1HoD5z9tAtHCN6V7GlQ4yZjdOWNOEjDcF+z4Hx5/c98+XTqD+9Q/lvUd04wcDpjjTaP0qXQXGy+2+XRbBxl0gUURb8cbLAaQg0IIpIpqr4R9mmjeruHFx/wb8uCuD34ygmkzIvUpqbyWzokUrYdydbLqZwRCiTSPm4y/FcV9MNnhSNGmnV50M48tCoDCrNSdSblkbVoe0UwghYIz/2uwKM8TzsbsTvN+tvUQE2SSZU7oiymC7wyLAfhM5+3FOAMcqRtwpAOLYfE+YOfvWZpoAZpZekTdQUC4qIFMyzgsiT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A task that called vfork() sleeps until the child has released the mm.
During exec that happens in exec_mmap(). A child that was created with
CLONE_SIGHAND shares its signal table with the parent and
unshare_sighand() only gives it a private one after exec_mmap(). So the
parent runs again while the child is still on the table they share. If
the parent ignores a signal right after vfork() returned the new image
can end up ignoring it as well.

It used to be the other way around. Commit ccf0fa6be026 ("exec: Move
exec_mmap right after de_thread in flush_old_exec") moved exec_mmap() in
front of it for two reasons. bprm->mm was to tell whether exec is past
the point of no return and everything that can wait for userspace
indefinitely was to sit in front of the lock that became
exec_update_lock.

Move it back to where it used to be, right after de_thread() and the
posix timer cleanup. Nothing in between relies on the signal table still
being shared. With that the table is private before the parent is woken
up. And the new table isn't allocated with exec_update_lock held
anymore.

Fixes: ccf0fa6be026 ("exec: Move exec_mmap right after de_thread in flush_old_exec")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8d2b14e1d455c..87b78fce609de 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1171,6 +1171,14 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 */
 	posixtimer_exec();
 
+	/*
+	 * Make the signal table private before a vfork() parent that shares
+	 * it is woken up.
+	 */
+	retval = unshare_sighand(me);
+	if (retval)
+		goto out;
+
 	/* see the comment in check_unsafe_exec() */
 	current->fs->in_exec = 0;
 
@@ -1223,13 +1231,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out_unlock;
 
-	/*
-	 * Make the signal table private.
-	 */
-	retval = unshare_sighand(me);
-	if (retval)
-		goto out_unlock;
-
 	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC |
 					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();

-- 
2.53.0


