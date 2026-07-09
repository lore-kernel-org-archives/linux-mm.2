Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8CADC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C1B6B00AA; Thu,  9 Jul 2026 18:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214DA6B00AB; Thu,  9 Jul 2026 18:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AFD6B00AC; Thu,  9 Jul 2026 18:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D86F26B00AA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71A601692C5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:54 +0000 (UTC)
X-FDA: 84970684428.17.E1C103B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6E08140002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N20eoL1J;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DueEMP2twKq63WtPK0VR5mbp235DC8FOqpNTN5vTvE=;
	b=JPFKZO6k0ZEyzSypmMVksdfnCnLSBmXwn5JrgscBM7wGd9k24PVq2XcLx2Sb5CMPnwesYN
	gh+8YYgwvzkVB4axf8OMDOBKwBnxPiCDq+BPc/f6C8E5BF2zhGEMzfrPrkK+bY3jUbyjEI
	wbc8K3sPPUDSyU9lEWnL+4Bgl5VeNkY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N20eoL1J;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636252;
	b=51WBS2ofRaIpF8dCT3yikYpBidXnHWstFlG/l7tnBpXwHHJ0OxMyBpB33uqjykgQ2AaDWY
	kndbPm3A/VDP4zy7HhJLhe0jmp9L8f8OROOwTGO4WXcCIb1MfYQ+r3SEcnwgRr7Ww9zW3N
	Azr+MHThzFrO+hs4QoGw7a1XTOvGZkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 550FF61387;
	Thu,  9 Jul 2026 22:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9480C1F00A3A;
	Thu,  9 Jul 2026 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636252;
	bh=0DueEMP2twKq63WtPK0VR5mbp235DC8FOqpNTN5vTvE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N20eoL1Jsgw5XjfuLI6ZsoOwg9eChhiIgsCcJTqwwHOYufH6Vm2Iacejx7KD+UhJM
	 hp+jY9uvpH78UD+qN/dq2USZK1tcDkia2izNK7k7iHmCW5loorNNO4SRy5llLN+3Ss
	 k78JqOEnQowNxoXfxaN0E1HyVUysDSKDexIjKrgyPNet3RQ7YL3JJ4qTRcaF4sOPGv
	 xGAzyM2C1kt/uRVL7jx7bHHgt+l/6s/6SzvmN9Klj5ytai1z5Mm0T6OTuTUWLK93xJ
	 juuS4p6fjIXUy2GpTFGrF/r8hzCXGU3TVuvWuAuLyjo3+GfrlxzpomIMxzTfUkpufw
	 xgwag8HbvHC6Q==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:13 +0200
Subject: [PATCH v2 18/23] binfmt_misc: use a flexible array member for the
 register string
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-18-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2427; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gAz94TTaskV/1L0+/Cg5xweBbJSb5hGJ0x6PTB2vSzs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHx7d2lufmHJzjVTOPenMlpP/KIw9aA9U8W3uZ9aC
 yxLZ2590FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR5dcM/6t+rVi3b4vTv/Nf
 d5qnM4fsVwur4vRYspHzdkPf6UVqRnYM/7NcNbMObtyx0inmzNm9brHHrrpvDVjq/vLvtcMq2oq
 qxawA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B6E08140002
X-Stat-Signature: ufnsmeari1wh3q861836bffrmr4nzhcx
X-HE-Tag: 1783636252-511342
X-HE-Meta: U2FsdGVkX1/PRRs0wKIVUuA1U0yu/9qx1YHBsVRCW1SKPEDf/Wy/oathv0vjKbs7ZQd+dWxxvvFfLHxllRLrVZYKJoZyAntU9HCNjLsCmTyLVxugnUC4HFEGo9NP9OuV9M40fiYqFGxbGF6p+8CjiL7OjykuMIlj+5aAX6hqgeoLbyBESb0FzVqToi6YP9nQQ+yKL80pt6it1hCw+8RZFisyG5m2593+gF0wpz638dH+CeiAiwJLtDV4Gt+nmln4ZSThiTW+KQapMR7SysDM+OIQ46KkjsZUrF5iiYFNBOAoBtAt4JXqm0xv57LGwxbhb/3hXHQ3cWNjgzEi/SO5lHtMdhsv7rzdSbCdt3Li92ftXpljB8wvPRK1qYzYryCVT5S/A3LgstRBMb14jw5N/N+XWAd40qQYin/bjYOmyRWHQPDdAUJvlgMi34+fBY7prQ7MYL/NNQ4tM1xrwzkbqSDsUA6b39mMyN+Knk5o9DywXCp9HvXrlTyJoOgrRUj3vhhNd/HU559QxFfer0L90i7Gcs5hfczhG+gMfbOSMbY8twhl393jSCYDK949g0UzchbmEHPZ5UyyI5B8pyAY6DZNIEaDb5mC8pGQb6MglQcJ9StRC6Z/xsXxYH8rvjClEK5WgNNkjAL0/2Frg9CQzzurMWjcsTp79tZCX98S6guDSrZciI06hmi2tmqcvZ6s5QMrzDGOc9YpWXb/lxplPAANlKtaLyRwr/s38W/0Ba+WDXyV+QVN36IqTwYLPJSDkhksBcRckdXe59fFntpOHh+y8dhCKJF23aS5A/ijAcwtJijpCUP1pZW+lGq0OAwWpcO531fpDzGoYxapt3oCcpIiXm0guQuqNm6SkuxDnQRxupABrvw1NyIh8sspKUi/SqEWpiuiSdRF+UN9Jds+DZkYMI/hfg8UkGet3384m7UXbvzkC0eqJX+rApjtvwY5hftSwD7MK/38hbN/KhC
 f/9Dha1l
 IDXiIf5eGlRfw75RqVe0t3KVGhUHCfTeX1U6WT12ig42nye2UMudbH293/LvnKxj6SBeNpGAVy/7EB0Ub00drqGmdT1RC+wfOaTYiEroqBEOtqFGsP5TIoEcEeT6yzZoJHJwxgBHbQfbcNUhRzbegtISYGqMNhLBFL/F2P46ROnoxdTTeu1cTWlGysCIK0aAgL6yASUG5J39RAAf3Z0Bw+QQRJ4IJ09QFap17CgmLTyHj/XmPmJ34rke1dmwGEAOjsaW2NFh6VMZNkPrYR8vUgpTJ3x/0yJk3FTPbVAXtm06c1fI8qQmZBiF5SgG6cG8fWBWR6hVMcw/V4qeVlLr0ezUpEBo9kTmsfibVmEA+1W8WhB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

create_entry() allocates the entry and the register string it parses
into in one chunk and finds the string part again through manual
pointer arithmetic behind a cast. Make the layout explicit with a
flexible array member and struct_size(), and give the magic pad of
trailing delimiters a name while at it.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1536e398aa67..c7435d103629 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -59,6 +59,7 @@ struct binfmt_misc_entry {
 	struct file *interp_file;
 	refcount_t users;		/* sync removal with load_misc_binary() */
 	struct rcu_head rcu;
+	char buf[];			/* register string, fields point in here */
 };
 
 static struct file_system_type bm_fs_type;
@@ -78,6 +79,9 @@ static struct file_system_type bm_fs_type;
  */
 #define MAX_REGISTER_LENGTH 1920
 
+/* Trailing delimiter pad so field parsing always terminates at a delimiter. */
+#define MISC_DELIM_PAD 8
+
 /* Check if @e's magic matches @bprm's buffer, applying the mask if set. */
 static bool entry_matches_magic(const struct binfmt_misc_entry *e,
 				const struct linux_binprm *bprm)
@@ -345,9 +349,9 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 					      size_t count)
 {
 	struct binfmt_misc_entry *e;
-	int memsize, err;
 	char *buf, *p;
 	char del;
+	int err;
 
 	pr_debug("register: received %zu bytes\n", count);
 
@@ -357,12 +361,12 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 		goto out;
 
 	err = -ENOMEM;
-	memsize = sizeof(*e) + count + 8;
-	e = kmalloc(memsize, GFP_KERNEL_ACCOUNT);
+	e = kmalloc(struct_size(e, buf, count + MISC_DELIM_PAD),
+		    GFP_KERNEL_ACCOUNT);
 	if (!e)
 		goto out;
 
-	p = buf = (char *)e + sizeof(*e);
+	p = buf = e->buf;
 
 	memset(e, 0, sizeof(*e));
 	if (copy_from_user(buf, buffer, count))
@@ -373,7 +377,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
 	/* Pad the buffer with the delim to simplify parsing below. */
-	memset(buf + count, del, 8);
+	memset(buf + count, del, MISC_DELIM_PAD);
 
 	/* Parse the 'name' field. */
 	e->name = p;

-- 
2.53.0


