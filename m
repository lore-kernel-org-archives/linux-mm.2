Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509B7606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUrP14Sr
Received: by kanga.kvack.org (Postfix)
	id BB0AB6B05BF; Tue, 17 Nov 2026 00:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88456B05C0; Tue, 17 Nov 2026 00:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A510E6B05C1; Tue, 17 Nov 2026 00:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0A596B05BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17AEE1402F0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:15 +0000 (UTC)
X-FDA: 85443432270.11.F7F6069
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 84F40180003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUrP14Sr;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Kp2fiMZBMHreKa6yBm1C7kAqEfoSCeSULw1o1rg90g=;
	b=5O1YkRi078KHE/pHryLoIsMwWtl9352xNDEWlQ6QolsC5HtSj6KMpz/fkXsg8ZXBRBszug
	gae5d0Pnq603Axe6oBlMJfgzCgaq3YIKkxnFmo0koSlUOHyp9HbbELqOl6j4+qRi4rpC+6
	fsltDuB+d25e6nBLXPJ1WYNU2ty10tg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892153;
	b=wW1PcY8JUKa/iWjDHvRwZ9cX2XrJ9d0nYc9Jhgd8YeEveWlTGfjyWLX1qscbQPGXYM2Uon
	8eL8t8mhl9uiHaV8rO8tXsb3oZWlAcch88Ah9MFhDkGppZkj+rs0A6OWfTNr8wBcW4P1W2
	WofVoj8kFFoOoeGj0DDfrIuwLRHE7IE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUrP14Sr;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 2BE6462095;
	Tue, 17 Nov 2026 05:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 246491F000C8;
	Tue, 17 Nov 2026 05:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892152;
	bh=8Kp2fiMZBMHreKa6yBm1C7kAqEfoSCeSULw1o1rg90g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUrP14SrTNoPVLYZKQ0CMdB5XademuzFki46MqB89BxmypSZtR9xR4zst1ho7zzKq
	 g3Z+xSOYSk5q3+fjMJOmfqvnbE2sdTuAEAbuGxGigYai9tDuMwTBfimmRgWsgOjVzu
	 s/q7SJBmPzfXdGo6aZVjbMD7yMEFzxAK9PbqOu/NxQ++GxzNYgwxCuPaTne5cL/OD/
	 DstCwgqPWyQ/DBWJHWVNbPkR3RW4knP/6GAS6RxlkfgDMJ8YaDhtTWzEdm6aL39oAV
	 sgpg27SV2djHLcKluQH9HlSfcShvKawPb7crhwdJ09wwjpvsq/5PDm1zDei56K2bCr
	 WFTo7qI+SKjbQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 06/13] rootns: Add rootns_kill() system call
Date: Tue, 17 Nov 2026 07:08:34 +0200
Message-ID: <20261117050841.3289652-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84F40180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b7xfrfra8upytwcnsrybtp8c3mdndp6d
X-HE-Tag: 1794892153-484698
X-HE-Meta: U2FsdGVkX1/3XoIRCmLfV8vfBNUMZ/6lUpYmBX5QcmyetfOTAEHQij2TqgXUrHJUf9AXwLJOrs5mC/3mLjxsg5bCFwhIBA6PdFUjAf4Zk5vESRLzcshk4k6fpAY3id4fgK5JWEmF2ySjsrh8iv/DWs7j0w/vlFt+NDlK+b0d3o1wkMwxbLNdXXv7F8a2wEidinVjFDDBDrHZPQTAunaMjdNURNbSNViltSyM180oXrCQoNkW9g2xR4XT1FV7kP7NOM/xWHYDMK8RIxymxhb4OUGCcA04PZxob7WxUvxHJPQ+X1pyPX2NJaCjLcJAxPk85U7RKIwKNLrcbzyqF6GA+f4EkCVBroMQ4quc8v5NkzP/DLwycaM8ar0xk/cHtFsqmGWrAxehM9SrWxNKmRd08jZ5Yuq7kB0RpxQUxznQrahn7s0vcpmfRA3qZRcarSpv5QsAcJMtRHycsL0CmpRxbEND8pRdeIGNIWGR9eDO7fECnS8sge0elXI+gLVJCv9zKgTIqwsnSgJjJC6oq9wmAr+d7XJLgXEszAMZ+NLFQAO96jnvV4AeEhrnSFZE6x8VgoZHEitXAWP5/E/yXFi4N2vvVyVEySAHbeVktTmrSp/G2J3Da3u0OMGsgXG0ObZ9b2YN+RIRYpEeyefDBBuR/0e4DLeqVwG9QGF6E6uAwUsnxJfdlAXBk48wK749qz+Ji0OOA3FOGXcmRr9kiI1RckKxNvTT/hD4lrPwUQaIN6Ex84ahyPxRx9lQ/d5gDyinz4I02hA0CpN1nscXp7fu88L/JjkPurHaBfSxx+5NYf43/Isc9FymtPTdcH0wuK2iR3L1utUrTdeWpapPQ4TfkXfZvmokT7u0NDL/41DRLYDFSndaJ5y5rBEdMwZsiDK6aS4ganuRtQoueJU7GhsWh+uCLhfVMS7Kbkw5177rl9R+yr+k+wIddHhleV5pDmkchY4q3HxqhdkiV8Vha8W
 Tu6D5F3p
 2C9sGNepwSW8V8wrXn7N1VHBkMvwLYa1cKbwPqYBeElZy1d1EzzVi2WYoRZv3cbniKy1gL/OuxrYPAl40ZPjbD0vc00cA9OE4njOtezQ1qqpM86fmvXDBQR1NcL+lqziNAIHPq/S1yW3biV1eh1eSvwD/q6b8z02nRwYjfMPXRiipNtVodGTG/efkTflKHRAmEa5Ml6R5Zr4uYz7o/OInDmZ/7o3ImiG7j1O1AY7O30VVTHMKSNwA6fbkpUgP0zff3j86YTNuMnPT28xDGBaBdeV6xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signaling every process inside a container from userspace via /proc is
racy against concurrent fork() calls.

Add the rootns_kill() system call to walk the root namespace's PID
namespace IDR under RCU and deliver a validated signal once to each
thread group, aggregating per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h |  1 +
 kernel/rootns.c          | 65 ++++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |  1 +
 3 files changed, 67 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 60e9c4ff71e7..a854d248c8a3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1009,6 +1009,7 @@ asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flag
 asmlinkage long sys_rootns_create(unsigned int flags);
 asmlinkage long sys_rootns_wait(int rootnsfd, int __user *status,
 				unsigned int options, struct rusage __user *ru);
+asmlinkage long sys_rootns_kill(int rootnsfd, int sig);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 8a1254db69df..f59b2fe9910d 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -21,6 +21,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
+#include <linux/idr.h>
 #include <uapi/linux/rootns.h>
 
 /*
@@ -390,3 +391,67 @@ COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
 	return ret;
 }
 #endif
+
+static int rootns_kill_members(struct rootns *rootns, int sig)
+{
+	struct pid_namespace *pid_ns = rootns->ns->pid_ns_for_children;
+	bool any_success = false;
+	bool any_other = false;
+	bool any_perm = false;
+	int other_err = 0;
+	struct pid *pid;
+	int nr;
+
+	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+		return -ESRCH;
+
+	scoped_guard(rcu) {
+		idr_for_each_entry(&pid_ns->idr, pid, nr) {
+			int err;
+
+			if (!pid_task(pid, PIDTYPE_TGID))
+				continue;
+
+			err = kill_pid(pid, sig, 0);
+			if (!err) {
+				any_success = true;
+			} else if (err == -EPERM) {
+				any_perm = true;
+			} else if (err != -ESRCH && !any_other) {
+				any_other = true;
+				other_err = err;
+			}
+		}
+	}
+
+	if (any_success)
+		return 0;
+	if (any_other)
+		return other_err;
+	if (any_perm)
+		return -EPERM;
+	return -ESRCH;
+}
+
+/**
+ * sys_rootns_kill - Send a signal to all thread groups in a root namespace
+ * @rootnsfd: Root namespace control file descriptor
+ * @sig: Signal number to deliver (or 0 for permission check)
+ *
+ * Walk the target root namespace's PID namespace IDR under RCU and deliver
+ * @sig once to each member thread group.
+ *
+ * Return: 0 if at least one thread group was signaled, %-ESRCH if the rootns
+ * is not running or has no members, or negative error code on failure.
+ */
+SYSCALL_DEFINE2(rootns_kill, int, rootnsfd, int, sig)
+{
+	CLASS(fd, f)(rootnsfd);
+
+	if (fd_empty(f))
+		return -EBADF;
+	if (!is_rootns_file(fd_file(f)) || !valid_signal(sig))
+		return -EINVAL;
+
+	return rootns_kill_members(fd_file(f)->private_data, sig);
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index f9918d38107b..fba44c49ddbb 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -403,3 +403,4 @@ COND_SYSCALL(uprobe);
 COND_SYSCALL(rootns_create);
 COND_SYSCALL(rootns_wait);
 COND_SYSCALL_COMPAT(rootns_wait);
+COND_SYSCALL(rootns_kill);
-- 
2.47.3


