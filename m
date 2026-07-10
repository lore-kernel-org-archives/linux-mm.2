Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB338C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C6C6B00B0; Fri, 10 Jul 2026 05:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA5F6B00B2; Fri, 10 Jul 2026 05:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996F56B00B0; Fri, 10 Jul 2026 05:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7419A6B00B0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:34:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 121D01C3A85
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:00 +0000 (UTC)
X-FDA: 84972355440.28.4C85784
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 350A5C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOGjXkUu;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4L+ewyd/DXbi01Z/LJ2w2Zg6TXNholpeEmz+tC5Twp8=;
	b=Wyvvoi78cS7ruCItDBvt6J8lmdGjPUmeIAHEtGyUs+ygfXbH0W4Xo0bx6Xja2Lmf5Gm5oc
	CTQJ1JxfbyXu0n78HGnqri15LYVfAyuVV5hRPF5iY4FKL3XHK+VOEimxpTjV6DbQGjQkFE
	bu0LAzh3AKZMvaUsPZrPkxsSeIaBv7Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOGjXkUu;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676038;
	b=QgHPUJ6krqVttRdxZ/pljYyDw79jJjz+CWkOR4zZeeTtFP7vC7SIljlZ75sSmSoQV3266r
	QbFjRUI0AkQ3aOjrP5x2NKnfI4xPGGAkwG/tRLzXKDqUMDhPLSyGIBlIkZIsjCwG8d8HCG
	Fz+LTwVc8TK0/ihHWnyrwOtA4/CU6Kc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AFD443D7E;
	Fri, 10 Jul 2026 09:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155061F00A3A;
	Fri, 10 Jul 2026 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676037;
	bh=4L+ewyd/DXbi01Z/LJ2w2Zg6TXNholpeEmz+tC5Twp8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WOGjXkUusrAH8RHIytLylACCQ+MXGAryQVnLcSJb4+/FZJYFgeNr/USQwWtKYQyYn
	 79DggVuuLRA8yKoCgz/2NAg6vam7ryTZNbkL9i1hQ3rPuca4yabkGmYgqRh6fTCTBM
	 mIKLcHsK1BnIAX8yBT8ZTVqBG03J2je9+rBH97yZ+eSnc/7nLyEr+PoTc9+ayKeuVs
	 kkzVJLIrNR5lTz3sVPBg/v4fxuppbrOVRueAXf2r2PGx8LxVXg+37q6STwe4oq5aFZ
	 LWWgkKUqsort5kGxtSZIjjEYrRk+B/i0JZj1sTaMpvM5QAu5jIw/cP9JTNjrMSrm2p
	 DA7mvCPejCpHQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:20 +0200
Subject: [PATCH v3 19/24] binfmt_misc: use a flexible array member for the
 register string
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-19-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2390; i=brauner@kernel.org;
 h=from:subject:message-id; bh=op5FT6KTOFj4auKeOC4UkTSWzUEhg5f38f9n59dfWiA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7In/kVv9cIbmhvspmu4xXYc9zfx3sU/Pdq+7fXBVU
 o31Jl+jjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImc+cXwz6Cl48HU+/tOJv1f
 5qq0V0yg9fUbO/n5j/d9W7ylUyN0wi+G/ymntv/8dtvr8RL785+V7pbkWjycYb/6jZljbsDReWe
 t5zEAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: dimhpope9xdu7fhg8kprhaq7w37n97ri
X-Rspamd-Queue-Id: 350A5C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783676038-87994
X-HE-Meta: U2FsdGVkX18wCBASkACMHSZVMlJIUiiH8uQotg1LtpkVLmgpBCcpXveC5pecvDvr8jIYde5r+0mJnmBarjlX9yh7X32VJwekcxeVZ0Td5hR9sppI3KDTfDW4M2UQg+HIn1K3cSeZTm061HQYH91UJPZY9g1nkA0Ix8aA8HZwynjbOvac3BhhtakBX9sUpdURT0aywg4hm8aFaJAMOMcRv2KhbQNJLvk6PWB34MnQmqbIg+9NjoZWtvFwWuRjuREvsPo0hQnYIForrZAdNXGT3y7s8kaJEEn1etdRXhmnguuaMjBZbhTKTJbxDZD8xedSfAvhLI/yoSYGkIW+zhu7R0RE5K+erhYjFgeoGGM/GuiAeQjV52TmYNbeEELTwtWIdR58MPejMvHScnndWY4ZUzYy4B/4ZOmzqlSmVV2oPaPXEKCgtJuQZRybNV9YsjKjEFzsEjfaMI3qEsswlo4CXGszI3DN/4sqruFWhmlgJv0yxnkhhNV6F0kzw6RCJXTN93t2HpuDnPluddRUjdSLWDqWrBZ76YNRi01/UDGuIKTguUHBFTftJRJ1tzoVrjJPlFmS32X+YcIbUCBNX0xuDLyOI6VOOGB3RoJVJ3cvgYl27PJDetc/hoKcpeOlktCSB2eicD+co9fepyNbDldXxhvBC7E7Orv1Cr53fMOCZMEpCrZUoAFTL0HCk2OG3pVv/Eoo52ZnFxVseF1O9HVmoZ/epl8FqAVvcGE6BJqVqLCW2h9juPcXoYETm8YgnIpAPE85lmzKFwlxKbueo3isXnJ9rtP1qZ2xMbyQEKWqatFyd+5odX43K5VmqjC/mjtllTs3Qc8Wid33mFKHsJdVaF+sh6qcShGb8JHWce14XKr4qDDm2WUfI40gvTKpRfEoSC8NE6DP6YrtaqF4zb8bekc1l7JNJNMyxOwd/xDFgqa4UGqUNUpm4761CMZKS4ZS5lk6jVpLA3zN6sp67dd
 KKTjTn/r
 Y8WeeD3L6zmX7S/Dd2FFa0PO5H3jV5YMIZXTpQ95Z0CNx9MzZyuu/Cycoz32pt39+dnKyNTz3yGsWdO1j5UIMGHMhULNUE+1m2Omyi/Ip01oHNpmoMcYdPEkncA/VJ+cbYChBocHC0ZbJLmpog/2ayIHYuesnxJaVw9gyyrsPqrDhiW0SX53iX/l4T6tOe8AteDwIF1m1/887CH6YVqSp2sapfSaRTQ8NRsamOkei/xXOZKF8ZrzgiQUQWoC0sclZR6od+992HNEJFaDBuBvyKvT09YkdpapZa+4QYZXNuyMYBzZT52Sl9ucl+wgdzgO3D3UBxwsvt8rUruvhzM6/lw6TyZUA7Rm6fWMxrdESZ46iCEM=
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
index d9dc9546d199..4cfd3ce5e47e 100644
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
@@ -377,7 +381,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 		goto einval;
 
 	/* Pad the buffer with the delim to simplify parsing below. */
-	memset(buf + count, del, 8);
+	memset(buf + count, del, MISC_DELIM_PAD);
 
 	/* Parse the 'name' field. */
 	e->name = p;

-- 
2.53.0


