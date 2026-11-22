Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40184606A6AA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OoGSfxYg
Received: by kanga.kvack.org (Postfix)
	id 035416B05BB; Sun, 22 Nov 2026 14:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28126B05BD; Sun, 22 Nov 2026 14:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA13E6B05BE; Sun, 22 Nov 2026 14:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A02476B05BB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED4B01C40EA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:36 +0000 (UTC)
X-FDA: 85463761992.19.CFF66E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F38340003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoGSfxYg;
	spf=pass (imf04.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376195;
	b=CZEOv+asVivK8jo1fQ4Z4q411vofxCO4Mze3anI1t94HR2+unxYSu/B4WjfPLb5ZCtcUFI
	XQhrBy7h/2Ufy+bnStcuCw0kCirRewYN4gnupMkLPQoum1KueK2GHERRrcCxtKS4HKT1Bc
	YUSU1zRI/RpNIxgjGirRCCsiNem7+08=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujYt3pxK39YV6xgrJ9ycAzI8XphJxsY1pHf5v0/Q8cY=;
	b=y1iHG1AmrhMLi6l+97UutrjTNP6znh+86XbSQugxEbqJAHDg2119DbmoTwUz1uY022ZtM4
	z01xWM4kTDaB8S7Z1MPvsV1bQbzF8fkWxCS44E03pHchoUUH+gQYlQF7vkBazPm7DjrfcL
	ttD8CadfTDJC/Y2Pa/t9bfsnUrHzhkI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoGSfxYg;
	spf=pass (imf04.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 0529C61E04;
	Sun, 22 Nov 2026 19:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 275C91F000E1;
	Sun, 22 Nov 2026 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376194;
	bh=ujYt3pxK39YV6xgrJ9ycAzI8XphJxsY1pHf5v0/Q8cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoGSfxYgsZcZJElXw84v9gsSeSMwok9hzGq6rqX9ynWRDXqq3zx71CzuuYvvw2g/R
	 1UpEgjqxgsRgThvgJblfJjMiuNX4mqqhqHoyFnm0J7hEkd5/8FlUQcVS3mkMU4mMYX
	 iF91SZzxOwMNMH2crVXxL7rch4XakMfXwpVbdpSN68at4yxvJhdrFGtdqimiqw52tC
	 d1j+4sNCZtrz2PP53RcNgvvbAnU4dUe5TRSV/ZC+XXhMOQA24qIq01hpvWa3QXVrBH
	 aYxsxae0fedmvv9+V6SNnLaGfcB9iN+D8NEneNdjl2luzlR75sAG8Cl8K/pyTCNbLe
	 u82rSzLk5TrlQ==
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
	Eric Biggers <ebiggers@kernel.org>,
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
Subject: [RFC PATCH v7 09/26] nsproxy: Expose create_new_namespaces()
Date: Sun, 22 Nov 2026 21:35:22 +0200
Message-ID: <20261122193539.3334213-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F38340003
X-Stat-Signature: k6e3zzbmdykz5cxnhx6j9f4o6wnf5u1g
X-Rspam-User:
X-HE-Tag: 1795376195-834586
X-HE-Meta: U2FsdGVkX18bxqx0CKK2XpnB8/KbEyJE09xOStNX2zqVdDuRZPiBLKRNPiMIaOBQa+OFQhJ7aHM8spVUMDT4IkHyhrAuNPTz+YSwjA0OM9wtU2yB+ZxpGrop3bf1AI3V8784aOINg1YhE/qpH9kco90cfBColtJv2uYmLalnIWAW4AAiOiZrqWwonaKJrEz3fmukK/LcCxKDp09iJ9LsJIGjersga5p0mX+M1UnT9gpxbRzc5okXyB3vI9IIvLuP68WhdSz2/GFHS5esafHr3betpaVhmSBXqIJFjW/8ThzKkFSCuyqIwF2t9xXIvbepGPTOUMGr0s2DJ0MIXU+gVJI618QjvQQoVRTDe40ho1Bw9MnTfyVV/+QjlRO28oIaukRgZvIpVy1Kye5anugaTEwxwtxv4m/6U/8S1BLCd9vGDb93JJ+/J+445hy20INAeeanFYtyuOmOWWBGrxgtE5s4zpu6BtNauYDXyYZj0R4I0TqzlJ2bF1fffbzHQf/xTiIAX9n0WNvaLebBnAvEvgms5FCsq9uANkOLSDUlp7Xs6LKiOzi4voBHyKSekpAJk+KtJ+cS85D8LKvykCjBAx1n2VOkf06LS/1xnVe37hhA4T1+ioF3fWjxPVJCzJ/abcK8TwB6FOlPHsauXAg6fgQdp+9oJArWMtByk1UWuDYnKUvsLS1elyeaJQXaGZqOVSwy5r3NS2HRncLDFG/b+DdLPmryNcwJH78qfg3dH0AvACWNzfUX0JZENqLnIPKQC9IBMHUpFBYNjqkv8XkaOlYXP2cNSk3tlHMuNz26FYEbBWXc30CpCqD0s+23XffOysSKNkl6RbirigL7c5qarXyO+2Wli765p3bX+CPo52gCVkmAK6XLkJRF4G8/b+PcKN+kkyiwAxi9PwU4hnZM/M0dqrmBoFMa0uAzJlwcEnbMAQ4vphz0VIafqiqav07EwQC2RJqEOrGHbYibeA6
 wLMNvmvg
 MaRm7nQFWyRNy1HcCM70Mb+cmrKZ/pmAec5P/rJMFQAyCrPVCsTdhYgACJgdkoWpyghSWD3QPvyFBGhMXMjz4YoLHIRJ679uCZ3rp+m345kKPB7prcUUx4ZUzVTbbuP9mD9T+as3iDv/0u8slVuF/j4by9R6170sJSm2uWQID6HUF4Ik199HjFwSQFGj1G1EkQ1gOkMPUufUtBoetbf9io9/kwJA84Y7XHgTzTc0uUDnpDKCyypGKkvrejPL1k8KCd9/5vIASfBSyxtpBCC6Bc5QWiIYuf9+QI9DRwXTunXdYpdH/yx2qECH5KlofZ4RsbjDXruJN7z5fxyaTDM20KCN/e4kWZvLaZ93hMKaqpdBEo6qCT/ls7zsjMjqCqVBCG5DIZTMxgzATonpB3nxeKiJ9xrMN5d3PBC9bPwDQDtopB15LEOdC4O/VboKNxPe3je+ESEYgOrxbKb7pIj86p2kwPD3jdBwYkuZDWzCUa0ItLxA=
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


