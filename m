Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8BE606A8A7
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DXjGpRQV
Received: by kanga.kvack.org (Postfix)
	id EBA0F6B05BF; Tue, 17 Nov 2026 18:14:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E901B6B05C0; Tue, 17 Nov 2026 18:14:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5F16B05C1; Tue, 17 Nov 2026 18:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B98376B05BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 373EC120608
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:36 +0000 (UTC)
X-FDA: 85446167352.02.C4CF394
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9801C140009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXjGpRQV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SlzPffRgB/6gUqSBvb7zP1wBLoY8VjWDsPvdBt0XzKw=;
	b=XKtLj5qHnybtoYT3hCwG7eY3V2rUEj4nxCbZStVgY3AT9Fw8AXBId2s7GoLU/om/7aStBh
	Hs6LlX89eAZlFObPR0XGSNRpy4qnLntIP+nDFJrYqupAXpZ+O7Qs32ClczWCGo8hwbZvVG
	3cK9Zv9AwM8NnPqYWj6rzpSyhiP0wfU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXjGpRQV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957274;
	b=bs2MHZzuOX4LACQjr8myDUm9PP/IHiV5OqoPURYD3FG8vH1pOUsA9Jt3NIkqwErzYP7lXY
	DsPilBLeyLJFU6AtqlI4c7zAHEhyPIUa0N31a55nz/J9DCRF4xjgvTawTZh/FVyDnId9xb
	G+NcS6hNTuIT/x3K5afjJKXFAj91hsE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 2FF2460DF7;
	Tue, 17 Nov 2026 23:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 42ABB1F000D4;
	Tue, 17 Nov 2026 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957274;
	bh=SlzPffRgB/6gUqSBvb7zP1wBLoY8VjWDsPvdBt0XzKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXjGpRQVnPgTfnjkyH/o1PjExJVbyZcqgliLVv8F9kk2R8UpR38v6/Qvsvt0RbrVr
	 sokfQ6Rl8CHQDA4838jsxJAxDc3e4nNzXnTWIk8pDGgcg78uWt2aljjL4K3+mcxqGr
	 gg5ymkfe5zPapllISsvjERekdfgml83D9eant9Cr/sdXtsD9HFoQWxqE+O/nJWMLKf
	 AvIMMjC8byZXL6C4SEp9x3yvMjYVzuoJWzNNUbo7qSnkKKZhbor/M3kFY+1hh8OqlN
	 PCP5T4m2BQBJxW2OTwXWvhGxqf8j1MMQtZJcGO8KYhvxeI7n0w0/0PWN/TPDLsiq5E
	 nkZ0Gmz9JI3dw==
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
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 06/13] rootns: Add rootns_kill() system call
Date: Wed, 18 Nov 2026 01:13:45 +0200
Message-ID: <20261117231352.3816603-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9801C140009
X-Rspam-User: 
X-Stat-Signature: traideym8hsf1qenzte76jtd33tb6k5g
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794957274-517314
X-HE-Meta: U2FsdGVkX183B0cOSmGlWfXKhAW5RJQaRi4ngcy9z8g8qhlr98+8hFFHgV/+FQkuNHUXOQjs6d94AypSeFkcYC51wWLvZd8SiuVnXhq5ZI4dKZ0TgC/qg9aAWovLzvaGfOVuRr/PqdjERcfinvsDW7XC8qskO3koV0qIcaiavGPKR3qMpuCKQP0lkjn2I5v+ttq7dLQatdK6ouh/l2/utmXPeHaCBpj9B3D79nwOmuqdKtYZwIEyuqHb1dCXxunltIUb/A33kUtV0nfydWjnpLFovP0GGYTmBq12c8HmUPTFhVxQvPOrmdwjsGTre8pUJ0SnR3VsMAbEUprNo5Ftu5UyCGU3izrYxgsDb8+XeVwwjJYLU0oewnqO94IW5Kwf1h5PA8QC044EfRtHnQ9dTtb0xmv+NkzgT0G7n0PQtciRYBzaUgD+dD8nYletWjpXjR2v7dTZWAlZ8b5AbbA0g7CiMTqCtDJADghCyUQnQLoHOZOZDVB752ifG5gq1A+6KZxf+sDVcygwao5q+aGrFzZx1O2NbmD3Bhy1tiXa+8VGSQazo07UqrKfWVM/cRljLUnKINLq+6OJxeKxbJuTBlXzfI6kgsktfGfROnR2hdSVZLQBhFvKwS8AorhPHYpO67Sq8tDhOcj4aGv+ByCebFnBo2jdsODvRgJpC6oZ5aC21L6N85c9il+3Cty3TrccpR+RIVbAko2hXegrmeSE+YCmcCepzcIw3/c2nfDC5iLbQQUhnu8pdrLt5/vmVgctKiiMkMRdOggA7YU6JzjpQ1Q+UPY4KjkuN3IddnDO9JqA+GLwLrB36kMNkalWr8Oqcsx+pR2C7mb1lDnp0vc3ac6pKV5zfxYlggrEQTuFDAZRYhytVl0apaKefGJol04W6Zgom2eyghGb7ogaRHcy6m2E4Ii66vJuF5E00GtAwQm9FZ+SqZB5RTHEMyvnTKBTslRnEFM4jMwiBtcJUZu
 29XBnVxt
 APiZNUeiTWWZOVG8f56f2surdulWaiQJwF7Tj9NXLY1Czhs7ZO4/0b450j22bmyDVmnq6arR3S8GMF+rnPrGwMfLMWhm/kLjdEqnheQ+UUrhAHOArVWgAvd1xZwsbYdTycjxamTHnU/AlYmELS99syXYwsKTo7fRUWIwKfJEkFEjSdkhSFJ+O+SwGrb/xIdITATf705+8ppBmrxyxdsVh6+hLKSbT0NlKfS620aDGwIQhHdLF/d4WEdMVM3FJNnVaqp/z1reiYM9nxSAqhwb0ZrOnRA==
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
index 83ab759a31ec..90a070dbf4a8 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -21,6 +21,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
+#include <linux/idr.h>
 #include <uapi/linux/rootns.h>
 
 /*
@@ -389,3 +390,67 @@ COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
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


