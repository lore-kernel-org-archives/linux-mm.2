Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F31C44516
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053E66B0092; Thu, 16 Jul 2026 10:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59846B0098; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C365B6B009B; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 835A56B0098
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 395E6401BF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:38:43 +0000 (UTC)
X-FDA: 84994896126.06.D0C224F
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C18B4000F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:38:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=lGJLlnnk;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf17.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ya4G86ANygOaWUOVa7w62N+5O+59ZsUYvR63syVDoH0=;
	b=mVqPChfpPsh7cL7C58BGel5ZyPj4Aq3rbiyDzSJ1bVeZKfahU16ckwB6wwWHul1PKzUDSC
	I8JrTt5FsFZORC8numWkt+HeSpGxrogJYhEzVM3p9dJMOtNKED9jd7frtufwpIm6t4wymi
	ucz3tEM6VqqpFnHAYXFPuj2oiqp3CnA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=lGJLlnnk;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf17.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212721;
	b=b42uT1dZCqFLhDUVeXPXtaN0Bd4xdsxQos635+wk0i7AXKLwkz28XC7PXrVY0esLhyRqXE
	uzSpQxjCUp7iCInRjbgflPUI3CdMjnbNCaPPXIty9k7VO2ThrDklJJg1M5W19Io0PFIJ8v
	QwC5zFrjp2Y69pQFZre/by1ueOhBGBg=
ARC-Seal: i=1; a=rsa-sha256; t=1784212442; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PcmXxNM116ujYktl2B8PgN5Fb2vWu5zbR65PNCo1Gh6e8D8pnRZrZp537ovK4kpVsSf0//E6UrJFBKhLNpewOAFmpRm1RIyMeXxCGpN1PTKlEhHwWQRfSL8McbjWzLbctXfmL6UMtn17Sqmd4roAONLPAxI3hw6hEm4FLg7LWW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212442; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Ya4G86ANygOaWUOVa7w62N+5O+59ZsUYvR63syVDoH0=; 
	b=CXEujvq1A7pk+uPqgahtMdBLptpfgKaCrfdsnkslZr7dwacljmH+h14u/3urOldxAaMa+T4GweHy1IJM933Tx1ynElD0vsbCElctMURPoPeZB9fCApmtNFhdfYYr7z49XYgPUCFziO4qH0M7H7Lh7OFv6GdpkBzTx4SzqatPIjs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212442;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Ya4G86ANygOaWUOVa7w62N+5O+59ZsUYvR63syVDoH0=;
	b=lGJLlnnk1l68wegebseYTGhaS7a/4IJ25ceMPX+dWJlVkOqso7Y1M+m3r2v6nFt8
	7ozdGp3BAhINZmmHSuU/JjDrUEmoaNaSmqIWSKLBEUmFnmuyCeZXv4ULG03WxubL4uT
	wLphikbx40W26kFF/RoLofgQutFQUD45REflaRCA=
Received: by mx.zohomail.com with SMTPS id 1784212439389523.0177283934667;
	Thu, 16 Jul 2026 07:33:59 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 11/24] pidfd: add spawn builder state tracking
Date: Thu, 16 Jul 2026 22:31:37 +0800
Message-ID: <9f04647b62927055673942e0d4e1ef93fd4c41f3.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C18B4000F
X-Stat-Signature: ztfnckhf359b7bw3bmiaiku6mbu8dr3g
X-HE-Tag: 1784212721-320517
X-HE-Meta: U2FsdGVkX1+cWFg0pLzjmmqhoZm+LpcAe7zzQTmSsiMRyfy9iiWe+awItTzb3RPAYD9aFnKaEY4b9iOJM3VuXPUPQ9gPR9N/KDMzMemcrTb+u+Qx4DgCZyoCPPs6yIFdy1uMoCkLGO3WmB0RreJx+GmQwqeFFOjFtgUEqbGyFRfE8FE0rJIUwEmylZdDpUNibX6mf3pVxJhL3RstgV/LKxrwi4Ub5ZCX7KkVMoIscX/h/5Ue5CfU58+xrDonw3/d9vlbQ5f+NM1/vhIAeEqPIdKuyCoActe2hRAIOpX5BdtahCOnWpLtp4orG2BqsI9SuKrV+pH1NExOW6XMKPd1HUi/Db2l82L05EfpSRsR6S8ba3V81B32uaQhZszFv7ZW7RnB1nv64JWmra56jUrK6H0wyvSyISNP5jKLnolls1ywfq3dXOG6ggszzorgiWo09Z6BghD6hDYc2P7jbR8AaPMMZhjIvPHM/eFgKyRDH6hs5KOhL4nx1c59IcyN58hfQ79InlwLXFBOJxF764JuTC2Vb8bkhG7IdP2waUrC/9X3OnvliJK+c7BZPInafrL/6dUL3K4aShQdt2fZ63ISVK8yzTrF1TkO3lMbv+jxL+u6NLKycNXkuTSUkCjl0V1y4AnuI3QIaR3+Kc6t5mr+POyGW99xC7dD3mptsKtC7yf2wBIhV7GVD7zRYWKNgVRZrJldZ0PHZHS50ivJ+LLom9576o1kazH9E9XcMMNDhqJ5Q/kg690PLLx18ygxt8QYCAiq8qDgMqkjm5Z2dQA8GNZFw87qTBqzEDdzIxTpD4YQBZHhreBIYjykIOCvsHdazu4cVx7A0610UeHLMJ9cSY5jzsaZHA6ih/7teMvDYkuAI+P7L3H3ToDaI9KzNzHDYylM5tMksK2C8lsNNpmszRx7y3F7p5YEQl1eX2uralj6Kd1bfp6014Vj0F0M3w4/Ufzx8bk840Bxd2FjCZ1
 lr5g7PfY
 LhZYMlSSw+j4XwMpXU30Bos4UK8IRfrAvD9B9fUGoPuCg0NXaCUYTwz5i6LJmBGXCf35OLigkegWIDpuk7eMYgakDIj5nnsNzvjJKOGvKE4vFeUoBsg6kORNHNIpZqdz5L5XWcf8yiTKYRGalPFNhhllG9PYC3jV1qvu2ttF1u+ewclie2CZniSDtgtRrTU0IySfhzCoY/ahFIdle4MS+yEJyjOfOV+7V28YdNwsQt7rzTsVy09nHxswjGzAXVN6VFKDjkuch6Oeem4R88rLFGLxUe1gom1XJGsgSnVUfyo7LSsrsMCu4X+o6KNAKEMS31SrZEm+9AI96PHOcbbJ4jbJ8jS2vtOUkWOH8P2G2Tpe+tJnSfyVwLN87WQGxe1mVpOqGBZiEdNfmmrDpxGPLwjByNHNOaTjq4jZOG5nvb3Jw2ioCZn2EGJVTVGcRaXx/ENR4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add explicit configuring, starting, setup, started, and cancelled
states. Serialize configuration and launch transitions with the builder
mutex so configuration cannot change after task creation starts.

Publish the eventual pid with release and acquire ordering. This state
machine also provides the boundary for later one-shot claim and
cancellation semantics.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 46207c8e8139f..99e3ef56ecfa3 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -22,6 +22,14 @@
 
 #define PIDFD_SPAWN_MAX_CONFIG_KEY_SIZE	256
 
+enum pidfd_spawn_status {
+	PIDFD_SPAWN_CONFIGURING,
+	PIDFD_SPAWN_STARTING,
+	PIDFD_SPAWN_SETUP_DONE,
+	PIDFD_SPAWN_STARTED,
+	PIDFD_SPAWN_CANCELLED,
+};
+
 struct pidfd_spawn_state {
 	/* Serializes configuration and payload teardown. */
 	struct mutex lock;
@@ -31,10 +39,45 @@ struct pidfd_spawn_state {
 	const struct cred *creator_cred;
 	struct pid_namespace *creator_pid_ns;
 	char *staged_path;
+	enum pidfd_spawn_status status;
 };
 
+static struct pid *
+pidfd_spawn_load_pid(const struct pidfd_spawn_state *state)
+{
+	/* Pair with the release publication in pidfd_spawn_publish_pid(). */
+	return smp_load_acquire(&state->pid);
+}
+
+static enum pidfd_spawn_status
+pidfd_spawn_get_status(const struct pidfd_spawn_state *state)
+{
+	return READ_ONCE(state->status);
+}
+
+static void pidfd_spawn_set_status(struct pidfd_spawn_state *state,
+				   enum pidfd_spawn_status status)
+{
+	WRITE_ONCE(state->status, status);
+}
+
 static void pidfd_spawn_state_put(struct pidfd_spawn_state *state);
 
+static int
+pidfd_spawn_configuring_error(const struct pidfd_spawn_state *state)
+{
+	switch (pidfd_spawn_get_status(state)) {
+	case PIDFD_SPAWN_CONFIGURING:
+		return 0;
+	case PIDFD_SPAWN_CANCELLED:
+		if (!pidfd_spawn_load_pid(state))
+			return -ECANCELED;
+		fallthrough;
+	default:
+		return -EBUSY;
+	}
+}
+
 static void pidfd_spawn_free_state(struct pidfd_spawn_state *state)
 {
 	kfree(state->staged_path);
@@ -73,7 +116,7 @@ static struct pid *pidfd_spawn_file_pid(void *data)
 	struct pidfd_spawn_state *state = data;
 	struct pid *pid;
 
-	pid = READ_ONCE(state->pid);
+	pid = pidfd_spawn_load_pid(state);
 	return pid ? pid : ERR_PTR(-ESRCH);
 }
 
@@ -136,6 +179,10 @@ static int pidfd_spawn_state_set_path(struct pidfd_spawn_state *state,
 		return PTR_ERR(path);
 
 	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+		int ret = pidfd_spawn_configuring_error(state);
+
+		if (ret)
+			return ret;
 		if (!pidfd_spawn_same_creator(state))
 			return -EPERM;
 
@@ -216,6 +263,7 @@ int pidfd_empty_open(unsigned int flags)
 	state->creator_cred = get_current_cred();
 	state->creator_pid_ns =
 		get_pid_ns(current->nsproxy->pid_ns_for_children);
+	pidfd_spawn_set_status(state, PIDFD_SPAWN_CONFIGURING);
 
 	pidfile = pidfs_alloc_future_file("[pidfd_spawn]", state,
 					  &pidfd_spawn_future_ops,
-- 
2.52.0


