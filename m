Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE34606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CgSTB0r+
Received: by kanga.kvack.org (Postfix)
	id 95F2D6B05BD; Sat, 21 Nov 2026 20:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934496B05BE; Sat, 21 Nov 2026 20:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D54B6B05BF; Sat, 21 Nov 2026 20:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 526556B05BD
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:18:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D024E140626
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:56 +0000 (UTC)
X-FDA: 85460995872.02.F6F1AB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 36B84100008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgSTB0r+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310335;
	b=oiJAHTfj0STE2P1Sjipm2dVRy0ZhDNnklXk8bDNI/ZK0QESV6e4Ci/WyxmGR880tSftXJt
	ttyzOxf8wrCacA6fHASgkvzTTcAdoz14cs+emuapRdxR4ksCcS34WhYplsukeS+tib/YNF
	YajZ8sPcCZxxe4zpsmNqtpmLkd1l1tQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujYt3pxK39YV6xgrJ9ycAzI8XphJxsY1pHf5v0/Q8cY=;
	b=zrpZaHZkN+Lyo/5dZ5NeBLbrrHueCAG6gMhq0LqFGDBRow5oHh1KEC9obwQ8D0mJKDXiZZ
	96U8kYU0yjXS+PbxXcnszmyFjI3V2bc+m6Tojn21fww+paBuIjJ95ddKOrKVMeW1ROXkxk
	x1ik1tYtrt/sLNAB1ONILmsQJ7ofuIA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgSTB0r+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 7C01D4085E;
	Sun, 22 Nov 2026 01:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A62951F000C4;
	Sun, 22 Nov 2026 01:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310334;
	bh=ujYt3pxK39YV6xgrJ9ycAzI8XphJxsY1pHf5v0/Q8cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgSTB0r+qkmpoLhDmBXzXLaFPO6TDxI9hqMTd0QaDETYc5hiIE+oYwIeSHoX1F7C2
	 hd4PtTV9HD0t1euQNFWbrMDTgq3tJFnzNsMmMoSuoKqqkpx7uBZwv3KuTHe0XWlT1+
	 ibaYClAnRYgqz30+oCDgftSDlETTtIjeVlGs4deSajG4UoiIsbes7IlDJCXQCRWcNK
	 +8ry9WPoRCz0m4MKw+ikMxE98B092zAXImn5aAsN1ebTZK54gbFDfVJ7ydT4B2F/ql
	 AwZiXUqVcm46z0BjZkGXB4W5lC+crtcEE4G7ken5udDPyk6vtlnCJ0uS5D984Peiuh
	 v8M/mrv42qB7A==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 09/26] nsproxy: Expose create_new_namespaces()
Date: Sun, 22 Nov 2026 03:17:52 +0200
Message-ID: <20261122011809.2667684-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 36B84100008
X-Stat-Signature: pi9h9dyb83o8dsc9umeebrp1i9xr7at8
X-HE-Tag: 1795310335-671021
X-HE-Meta: U2FsdGVkX19kr3S9LSCT7opQRUScUgRWswlyfbV8aMAy5ygF5epBG/F9qO9GVP0WX8aZgyD0wlAxmpPsRnf3YaFG/0eltk2xOtyExUbwY/hFbPoYrRDDrO7rS7ouaMTkU2EkMkYLzYmmJYH9axpDMSWeG7fLtD+CVpd46I0jIbzN1lDpaQXwXAzoez577mcjt24PcfEAnrOsaMRS1cVJdKed0r2gFPsrvX9y+QD4zKS5QYtSyr9i4S8L+/aeRCePCOFZ+eAYs3QpmW+OqVRZEl9kbGYvXlvuJQ9u2+7XCcXOTSlCE5hE9QxHr9eNAZSfJweVabqOzm8WL7sT6NZs4En2luAaihqnv1ro7FrurH1DMHukCSnwu/C22ZgvedPDrPN3BNtrKMQrRpOf7ed3bDAaSBbaSpBLP4EdDglm7zKzAzvp5uPXk+t6ARevyYSEpfJ9CMyCuOZv3d4nd17kq+8NVqkXBFIYcqAUrdqIf68WR1SKmDV2G0aXosuOghwvS/H851P0yeR94LSFSpPeHKO+ymlVI1ZKMSeWxjBLNJAgSJCvcmr8XoT1IVyAuTDOVEiDHdj26UonmpfGI2VNNABYTbkpmcmecV7Flj2x44yXDZRbnk7meze1Tl2YTBNoczxn06Z9gHjo/l0jEhJfBjZS+Pq8041vMv/O5/7gN2OT1KvJcLh4WqnBRiYVRr5pijII3UC1HtAs4ssM89/gXsm4St6asxlBGw7IR8txTdsAOu2r6uNUeSRIsIpU1+U4ZTGkwMU6njI6KvdBc6FKMBqVbLGiqKM078tBh3YslsZQZFrzSyPTAIdFa7Ak39uprdF9q83ZljZ8vLNXMFbpLh5Z87/QXp6bw63gF6Jq3rGN0HdmjVj6jr8mUJZE4u+HrD8crKugPWSbexx5QljcOxtgLHk3xp1/1jP79WFxjM+srVC4KPveCH0SGHOho1TR71qmuIKBPcrpzS4oOit
 2aPMxwMn
 MKB80XRtEMNQIrd+IbLVIs1lfcQZ+Llb8/noRX0ZDiocpAl0frWlziFDOym+tP7Mr8gHb/AFjfmacRloB1wSltazP5DWFsRBidU5vsmAMNkkUS+vSp66vNHJPaD5nf8t9X9bKeCSTV3oNxUYq++KwOs4yvLFQRrMdBP22aDR5y2d9SpGivxlntfnSSdp9GXxRwWxq5KcBDhTTzSk6y63OabyBEq7nPWPXBwrqt1e4mbTM5hyfUqmZVuHy2YS5+kImeMGwpd0MDJjSwVGliRrZt7tK/VdFUc9688ZOUlbLhRVAEb8xWarf97oTB7/tBPBMZSJDbTwrGpmG9Ak9Ms6gDXC7s4vKWGMMAUTLCJd4UeQqgCFEXdxyzDu1ijmIeMa24YUWMpC58+pRbLaxZuXBuyEzwTSyXqSgzPy0jPYrK1WJNSRn8zPdr9ebwy1YQJWF+4nK3/fFmLPDHSws6Zw/5D7dTaCBN0ObxBShIfVDX77uLCA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

create_new_namespaces() is currently static to kernel/nsproxy.c,
preventing callers outside kernel/nsproxy.c from constructing a child
nsproxy without mutating a task.

Expose create_new_namespaces() in <linux/nsproxy.h> so userland_open()
can allocate a detached namespace set from current.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/nsproxy.h | 4 ++++
 kernel/nsproxy.c        | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index dc2447f5f092..d611c40cb4ce 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -12,6 +12,7 @@ struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
 struct fs_struct;
+struct user_namespace;
 
 /*
  * A structure to contain pointers to all per-process
@@ -92,6 +93,9 @@ static inline struct cred *nsset_cred(struct nsset *set)
  *
  */
 
+struct nsproxy *create_new_namespaces(u64 flags, struct task_struct *tsk,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs);
 int copy_namespaces(u64 flags, struct task_struct *tsk);
 void switch_cred_namespaces(const struct cred *old, const struct cred *new);
 void exit_nsproxy_namespaces(struct task_struct *tsk);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 2dcf105e8ee2..3c4161515c3c 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -85,9 +85,9 @@ void deactivate_nsproxy(struct nsproxy *ns)
  * Return the newly created nsproxy.  Do not attach this to the task,
  * leave it to the caller to do proper locking and attach it to task.
  */
-static struct nsproxy *create_new_namespaces(u64 flags,
-	struct task_struct *tsk, struct user_namespace *user_ns,
-	struct fs_struct *new_fs)
+struct nsproxy *create_new_namespaces(u64 flags, struct task_struct *tsk,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs)
 {
 	struct nsproxy *new_nsp;
 	int err;
-- 
2.47.3


