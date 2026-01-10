Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A95BD277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976A26B00A0; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6674C6B009F; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F57A6B0089; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 755246B009D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32297140119
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.14.E507D1D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 535954000E
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=f7gmULfr;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2LUE689TUBjRJhqWoI4FSTJJqCMuaDthYKZkiYtSho=;
	b=KvnOgOQBoI5rpVEG0UWvu6cmu77q5wVkYR0rluXfLHblB1/xMDOh1ISTz/d0N9ppFVwxrh
	WomEvhrqMalUSQ/RuInRE95p+K2BLDOx4F4Y5ybmlNxpc8/v4AEeZE4N+bSI6323u/jmOc
	JLUrdrpLCb4NjlJRA9tcARpgBKBVUSA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=f7gmULfr;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=aAnnCa90fz3k0lVLpi3FEpDxDRbZzRheRg2wsZKJnCbkmiSCBfPfvpfOCcY9hFW9k+EO7u
	WwlX3whrwwTQv2uMyOZVlN2rqspqd8MjU9G1NjNhhetMK3Illw8evGg7eEFOzRXmTXkqby
	qk+9lfhxuCC4KxBH24TyA0+1TudNW6w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=l2LUE689TUBjRJhqWoI4FSTJJqCMuaDthYKZkiYtSho=; b=f7gmULfr1QczamnpQvpHORoB4Y
	cZlsW62CiHl2hZNjtSkrAMYnzAg+3ee4NzKQD0cwRhquSK8F9gIfJ55AnPDVTVn9irnM/Z4tVByIo
	mNFfBFW/wtmlpUsXUkMbOAMkVaYS+Plk/C56B9IAwv6/tGEwb/U8D4KAW4Rmy84/s1u/9SnOxy/Yg
	OW32w/DQT73dGjLsm4GxcsQqJZJEflD08QiKHs0aH4w1/hmnRzseN7XuTSLbTjuX3oWpFMtUSiJhS
	xuXBl4Li9Uu6V4rIOFZ2+yJcSbT9wwml/ntSivby0LL+rtss9AuCL2xRHuodRJy6wp38eRtGM5k4a
	Qj0W5Xpw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085aJ-2fZG;
	Sat, 10 Jan 2026 04:02:19 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 12/15] turn task_struct_cachep static-duration
Date: Sat, 10 Jan 2026 04:02:14 +0000
Message-ID: <20260110040217.1927971-13-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ns3q6stf39akw4baiwz6yb7f953xuqof
X-Rspamd-Queue-Id: 535954000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768017660-703836
X-HE-Meta: U2FsdGVkX1+eLoGpYfz8dUmIj36GQkla5c5HS+EMZZ2eE+xcP96LxJZG0v78XsU9etOmTGT4tnOV7mvUJIqGEV3axFqTiP7UHuWPOWpfSnikfmpvQ4aPCxYdBDwvLehGh4Rp3kocpCJO1XGXboXuxFbEMVV4UqN3Jb2E0ZOMOHDDuBn11u/MeU8EDfR9pRLbjpGyhFxXf1BNup9y0O7PHOzYovxN5XXeqEstZ8roIo6L86cCwL0P+JtTg+HxfNX4q2IPOnL+DqJNxGwVt/jI4MHCdrkDRRGzcdpXAmxojpL5r+TNBdfEqJhjQ15kG3nLZrj53G+gTCP2fdRa9cZR6EtUFWWmhQDPDuAcmM1Bv/iKCV1tWtWG4qtuzrPIGwLiZuZ9mDAQZyWbTqVey2bSYJgGO+60R+yzPYysMcHsyye/CNduVZXi4/oIA9AemrU8evYU9Pk/dkiW2FutBThKLt2D5zqp9qNr8FBd/YNBu8XM8MDNWWLouzxBu07dOkhHiJT1m9346Tw6r5vr9WCbsReGy6T/YbAVfZ2awvso9pAoBVFvjxI0T1HkVZ1qAujZ8Ixu4pu1KO/0ejOQ9cFnC+uISNOjudoJQpiIpCSvpvWGC8mt5nHkFXx1RMosXtrdxqXcGF2jQZEAUZYNuThwu5PEihul7ObkoSU12zsXUR+TDRaP+tQUDlMeUUN+gBoVd7xoPxxmUyAoWQnJKMSc96IcNlg50oym2CvTWFcy8o7BMujs9jPoXxTGzsmENA3vMUQZZxeWGKZrKCUK+KLc+P5RqKsXdxusr5Uszx9NTeWjMvzYgMw6HD8KBuYYVpeaudaQEWK4JtO/BS2s92lP37BqwqtZXd+rjhbVkrnvBr6RItLVizVP9EBgqOTPRXgQi2xv/3Or8fxmYjCz8vS3XPHChGujQTzvZ7PR648lMWkMfuiNT9SRPIYzP849rK7RjIibdUkP3UmaV82Mm1/
 GqY38/Qx
 3DYzds3ahZ/pfsZbeKyUy1egHOQi/d068Ey42HS5okbhhHx1aAHP4+91Ne1BEFP5oh7UO1LCipwojCX2trgUa7BhmREQvWii9jFoxrigKSMrWE/JC7quQWSAmJzK3+jgpyTPBoa0EFWe0OeoH/j8/clF4QeUd4mkz/VRHR/a7yDjDfpSJNPTtdiBTsPYyb2Y6pyav9Loo+dX2fn87GoV0hFoL8dr/D70j7eaGDi/S7xYXIptHECKuMi5Fpsv1l6A8hi6jYlbk1Uwk9jKmliCpnJlpKxtZS0UWqF64Lf6csH0LTaV07gMK40Cw32yjQqdCsNsobcVVNNKpdvwD57SXUC8b9h6QMvN2a9NTZmihlBwm2XiGZJKaW7+JZJByymCd/ajINCY+4abNzdkrXING7CqAm+S1o6pCd0S773T9ZRPY8pWkfZtx74NY5ZS4H6YfBMvE7GFAnJ0QNB2Xd/mW5ksvVVnhUAHcqq2c2KyP2qkc77vsm6OkAIIHuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/fork.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f83ca2f5826f..8f0dfefd82f0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -178,7 +178,8 @@ void __weak arch_release_task_struct(struct task_struct *tsk)
 {
 }
 
-static struct kmem_cache *task_struct_cachep;
+static struct kmem_cache_opaque task_struct_cache;
+#define task_struct_cachep to_kmem_cache(&task_struct_cache)
 
 static inline struct task_struct *alloc_task_struct_node(int node)
 {
@@ -860,7 +861,7 @@ void __init fork_init(void)
 
 	/* create a slab on which task_structs can be allocated */
 	task_struct_whitelist(&useroffset, &usersize);
-	task_struct_cachep = kmem_cache_create_usercopy("task_struct",
+	kmem_cache_setup_usercopy(task_struct_cachep, "task_struct",
 			arch_task_struct_size, align,
 			SLAB_PANIC|SLAB_ACCOUNT,
 			useroffset, usersize, NULL);
-- 
2.47.3


