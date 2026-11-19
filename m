Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6A760A2606
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HC8W9Wjx
Received: by kanga.kvack.org (Postfix)
	id BCAC36B06E9; Thu, 19 Nov 2026 17:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56B36B06ED; Thu, 19 Nov 2026 17:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EBC6B070A; Thu, 19 Nov 2026 17:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 750A66B06E9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:43:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8CDD140C1D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:43:57 +0000 (UTC)
X-FDA: 85453347714.04.47C8E18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 577B04000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:43:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HC8W9Wjx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795128236;
	b=BwTf9DHuG80VMELyiMnCFUqaT7EfW163xSjhH89ua/EueBdOVgPynjnMqqpeSXsV5mEVHl
	IoibOrxF3c6oQ58sYRmIKO5AvzYucMA5EReg7mQwQ8hyzggdqd15KMNm1DZRoNgQZ9+/ZX
	BQSROt0PPQ3Z5ot1n3nm2gpF6l6q7Xk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795128236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgOViuFvQ1WLBdTgeo0xBwSjxxf619C+mTR7GkYLz0I=;
	b=Mqzg4eMVjGOXjZciktUfsmBGxM89ZV/VNpuQcYprvYQnmAecOTDb0uxBwSH7Qn7oCdfYRk
	NoxjbswvKXKN6M49scT17nZWogE0cN6Nz8roiZii0arGpvc/uV8vpewQaAzVGe2VbMdw+l
	SRlIRlRhvGXFnk/Wz25cfEDoKJ43cM4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HC8W9Wjx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id EBC0D6298D;
	Thu, 19 Nov 2026 22:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0F42C1F000EF;
	Thu, 19 Nov 2026 22:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128235;
	bh=VgOViuFvQ1WLBdTgeo0xBwSjxxf619C+mTR7GkYLz0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HC8W9WjxhO4iHCFx5ER3+ZmW2t7L+2P4zUurqe98F/Lvvhw8xIi1zCmlHrOVbm/81
	 kQQauMVeRfBsEspfcxnerySlinGDiwTyxXGoXNt4eTwin6LReM70QBdaeB0k31MTQS
	 wghGogcrqFKCmL7Q+6qsLbjGoYeZeMgB36JY1UkqUAup23NwLQWNvUI74t++Np2flf
	 /NSSESeDRIzNzPSLfh3bZwiG+xilQwJz8T9qfYEJZGRml/MvWnKCqWrxYkYCpwCTkH
	 Sy33ZPrHxWaECiltE4d3JNTsN9FL2SpMblL/W84E9WqTX0lmWT6hCeOpPqstxJz3HH
	 IsmM7K7tfV3zA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>,
	Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v4 06/14] rootns: Add ROOTNS_KILL ioctl
Date: Fri, 20 Nov 2026 00:43:04 +0200
Message-ID: <20261119224312.1037966-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 577B04000A
X-Stat-Signature: ktih5ug7i3s38eo3efkeodwsj4zshtmn
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795128236-750120
X-HE-Meta: U2FsdGVkX18HtZFhLd+7qapkM6EhMMgtnaU1ZOJ5nLeSHpngGkwDiJv0hDtAf5fd62/KtAK8nsdyYpfnSUOHfLD/pFfFIt8XaZpOvo/cauv8bbMHAF5edr1VmUpuzlrZ3FLXp0jrs+4VTkFSylm21OnMgarasptZr9qERb2SGgJmdtWWKwOerl60RZfn9Sn6LPQFv63P3fMZuS/PZQk8Sq+f6cS1ZDuLvaVUZ55AtTb2v8kYAy+OKcp2p+8udgyAtebG+by35g7mFXZKT5CFOC6tvhSTOQ5+yGMy9w8gXXEHO0FCN7AKCCJ2xj4ltS4iVwt2SUWeHFwoAeihB7VoccaV2jr+1/kOc6mYHJOP8R3lPPmSVsCYqJCWC78xbGPvVegrr2UphtVDDfnfYZbDkhYCNxvIH56Yqj1ul2S2QyzW0EiYvXk9BO+y22GQl5nUQTtN7kdDwWp0q1dpZeXHDO7ViuXMLmFL3RFvtMq4oa45aLDz8GVwrGKpluipPIYoAEi1wuky0nhHNmDjWGqsLiCKkQDrjPMllv0kESlPh3CQ2DLB0lHIHAZZVNws20CyS7rQVyOG0v5T70MvYCpeNdzewU12qQdDGB2aeBeBAJd5xyB7LrKC0tj+R6VNu6hMEwbnqP4+ZAtlpZUyn7EHzKP5aSfE7QaaatSZFLVGm9+Pq+jr2EkSn8o5hdP3r8RlAOrw1ODvUjiNIFU74wYDI+CLeIAxcOtOtVIOmhUU6aFywgXnvnn9jEcN+MTVUdZ3H5WBA7GKw3jXAl/a89Yt1jTzDkXjEdcFEq75VUEzEiy1QR3UndJ6ANxQYV7FG7ZqhuKX1XewK5Mfg+xPW2PGOcmrRy8ivqPAOmQfVCmt2IGGQQmu6eBfpvj+MRUvXNOXe4Qj3VORi9qqFD9rfbxta5CG8sxWS5u4aqv9417Cw75wFHRpChsL3COLng9Urg5im7rPYnNPSKjpwmJ3ecf
 AItuXNFF
 icLR3UyBY7Ivg//tjUJE3GlToOM6VHMTCtag1+fWvGXSS8br63SkPMAZISc5lVv8Hera1bw1F/XHfhtimIXAcHAN/40iFQJ0xDHv6fbpu/9vK0uJ0bvzOoPN0XOdRH1EbCz2SGq7qIMB9Ytt9CwRqUYcZPk3R21hWf1rI8Jv/cVr9ShSW6g8zYXXKP0VQ9yxe/YwgduEHzThoKXnLD8YqOeKaffSvDyfPUGqSsC2k9mxwEULH0YyPa2IslYtFb5g8ECrVtOQ3fUAr5VLFhkD4IqE2GSoA2PBiSnOZx+LF1zZpDJXEB26NrbHoDiE3MMHkRjXBOoRhp+UICcVDHaKFXHwCV8xEgAGqle1gCofMKDbkhKDcaPJYBDNzr1hz9iiAII6OrJjjnKvdZeKBOHJX58kyN42nTtteR1l2747aiE2kCfYdeJ7by94gAaK8INSdxKjG8HzSPaXnxQStVDeb0mDFEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signaling every process inside a container from userspace via /proc is
racy against concurrent fork() calls.

Add the ROOTNS_KILL ioctl to require an ancestor active PID namespace,
walk the root namespace's PID namespace IDR under tasklist_lock, and
deliver a validated signal once to each thread group including in-flight
forks, aggregating per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/uapi/linux/rootns.h | 13 ++++++++++
 kernel/rootns.c             | 52 +++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
index 3fd215185398..acd91d895c63 100644
--- a/include/uapi/linux/rootns.h
+++ b/include/uapi/linux/rootns.h
@@ -67,4 +67,17 @@ struct rootns_wait_args {
  */
 #define ROOTNS_WAIT		_IOWR(ROOTNS_IOCTL_MAGIC, 0x02, struct rootns_wait_args)
 
+/**
+ * DOC: ROOTNS_KILL
+ *
+ * ``ioctl(rootnsfd, ROOTNS_KILL, sig)`` walks the target root namespace's PID
+ * namespace IDR under ``tasklist_lock`` and delivers ``sig`` (or ``0`` for a
+ * permission check) once to each member thread group.
+ *
+ * Returns ``0`` if at least one thread group was signaled, or ``-1`` with
+ * ``errno`` set to ``EXDEV`` if the caller's active PID namespace is not an
+ * ancestor or ``ESRCH`` if the ``rootns`` is not running or has no members.
+ */
+#define ROOTNS_KILL		_IO(ROOTNS_IOCTL_MAGIC, 0x03)
+
 #endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 5f03b6ba4a54..ce012a07e982 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -154,6 +154,53 @@ static long rootns_wait(struct rootns *rootns, void __user *uarg)
 	return ret;
 }
 
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
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+		return -ESRCH;
+
+	scoped_guard(rcu) {
+		read_lock(&tasklist_lock);
+		idr_for_each_entry(&pid_ns->idr, pid, nr) {
+			struct task_struct *task = pid_task(pid, PIDTYPE_TGID);
+			int err;
+
+			if (!task)
+				continue;
+
+			err = group_send_sig_info(sig, SEND_SIG_NOINFO, task,
+						  PIDTYPE_MAX);
+			if (!err) {
+				any_success = true;
+			} else if (err == -EPERM) {
+				any_perm = true;
+			} else if (err != -ESRCH && !any_other) {
+				any_other = true;
+				other_err = err;
+			}
+		}
+		read_unlock(&tasklist_lock);
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
 static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct rootns *rootns = file->private_data;
@@ -163,6 +210,10 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return rootns_get_nsfd(rootns, arg);
 	case ROOTNS_WAIT:
 		return rootns_wait(rootns, (void __user *)arg);
+	case ROOTNS_KILL:
+		if (arg > INT_MAX || !valid_signal(arg))
+			return -EINVAL;
+		return rootns_kill_members(rootns, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -176,6 +227,7 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
 	case ROOTNS_WAIT:
 		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 	case ROOTNS_GET_NSFD:
+	case ROOTNS_KILL:
 		return rootns_ioctl(file, cmd, arg);
 	default:
 		return -ENOIOCTLCMD;
-- 
2.47.3


