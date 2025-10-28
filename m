Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E973CCF9EF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4409F800E7; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA071800D6; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B13800E4; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08DEC800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFB0B12A631
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.18.B1D105B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0B87C40009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RshzQwww;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=1PRzAaEoOy8CF9mas54JbDaTBsCYuKREb2YfTbDAnvkAxJYYcRN+yl5Q4EjVit86x93rJ6
	+chXR+SOZm/Li/tTxFnQiWNrAxSY2/FK2EVjSSSPq4A8VDTJn9QMzVYkSYNAFagbf7SVmv
	IlqJSUGrV0niWoB1QgixFAsFZ/sLZts=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RshzQwww;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Quy3Z9YUR2p7/o0BhLPqipVcn+3o5MzKrJ0FbjbabQ=;
	b=FTRDJADr0VsHfbGk5OjtjSKURkvSzoVRyTOMyx+Xbsin4e1S97rg+UUqZ7uv4er6pbcQ4T
	sOJPPYNFmr44voTAxuN6VrxPTqQ18n68DhUfYv6X20jr60LUQXKYoypQZX88bQzW/9MZd9
	urFivg+6qOf4u8HGVZLVnA4/GYwlyuM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4Quy3Z9YUR2p7/o0BhLPqipVcn+3o5MzKrJ0FbjbabQ=; b=RshzQwwwhIM4JqS6JZxrRB6SRi
	sXnRpYSIo5COA7j41rIr+FZs7mPLff7B9ySvdiZZ5lxVK1g06AvmaXhv70p6toFwyWll9CLH8n+FE
	Bq5eaBQZ5p6VPRqN6KqAKsQstjhS1pRI2XyGASAUKmqRbjLp5H6jxFr8YgIzLixZkt4ZM99eScusG
	ZvniTtZpZZ5rRgkDy7NGh6LoHz5GnEDif1NgRBV7e2R6k1CpekKobidov/xXX9HqS+xxsxzqpESLf
	1sTR9kt2IXyvCjxM42Ti0MKZ44e35LMsuOuX1BoVt3Um7IFuEeybntNtMTJWIiADZ/bjaKcxTyo3J
	de8RuQdw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eWn-2xv8;
	Tue, 28 Oct 2025 00:46:15 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v2 10/50] configfs, securityfs: kill_litter_super() not needed
Date: Tue, 28 Oct 2025 00:45:29 +0000
Message-ID: <20251028004614.393374-11-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B87C40009
X-Stat-Signature: 6q4pkyh93n71wnc4gs8h95astxrbk6di
X-HE-Tag: 1761612383-864146
X-HE-Meta: U2FsdGVkX18ST2ItyHG3Q2L2UMlMmGiFvn10ST4lUYuDxQgaUW/eM7QIyP65N3b40YTuD4x+mZseAGAw9cVztwsXfgp8OTRAS212uisW+Gs0fuI9dIdDReA791Z27sQILlO1pR7y+wEIjInB0zku60vi3fr1b/OvkdeuzruIBAMamQ1Wm6ml8TRZZHkww+x2Uekw6TKN/ZczD0fBn5U/mWph5UH/Sq6IA6UWZ188yapff1LEbO8PokdBVhszKsdIwyLyj+gQrgOpAArtpaGxsVVKDSIYx1yR6UOam7oTVfAQpneJ3OAQeMuGCWfT+xlzSpVREQGRrSGNSJ3AdWbfqCtk6h8rBI1ywXCE9Ma1/WVLnoZ5FSlXiXzdwhFLU/IqA7iSfvS/Ko8424jMNKJ8T0pggvSJiT30cdQBZQl1fDC9oXNZnn+RiIkTHyzyzaf/q7sG/84KxB0zzqwVHULuMVTE6xu0EirpfUpQRJr0INTaXOU00I8pHDMmqnJ0PEFPkoborrijCycmHvFS/Wcdhu2Hqz2eMYbyobJDFzwbBzXmqGCzV4E9MysuE4+bU9sx0zSDVEwRDqO4pRjk2j3KqXs/4xoJQPgGowCBaaV8jNhzEux3AxNtHQ9Oz7LgLepdYNc1/HPqyEJyYqGpY/vujupKm5dSP78nCbSWcQpuCdKcRWkPx2rP0YPmIVlNTSKalokx7LjopAuLamLSHPm1KiGd/VnzOlkGXhBYJY5eQmkHZ/CPJE8s0KOZXYNabRILyKCl+aAWOAzvJXpbTyrJ9UfodiCTz8l7rv24CdqKEzoxn70X2i055ADAMh1xEEdrO04pSk1iAT2yx1a247k+ImhSrAYohKEjDK7MkpFDHGsKHAmm4mgRu/+LH1Dkdk6Zvvm+Q9pTyKGsDRr6o5PhlVro7Xxp8dYBXonJnMM62g3yGFdZXmqg5nTIliH2Be4/A2UDToPCuA1kqN5l3hN
 cgcIujFB
 IlyzOhR7+AeZbLN2gV0u/MAgXbgZg9wQRI+kG6cUosO1EClihtv08rfEVNexWNN9BbEtQVthgiqiMhZ+xyDJ6k8CdAQP5kG0/wKo8lLQHynv3VXYckgtsWf7QA8DO9TML+a8WAnJbuRyKahO6xfB0moTxnP5gOnNGuC8eXZ7ZyYGFgWkUIayjWWSwvqhMjXirKx4x+sIunJl6qAKv8irlWECC6R9E9hdgwFsoSI+T2p2vfN/k+JZMgKVQxvqeWLGoIXlOvfrFActWtYrf9p6OzEvnEst8ZAI7zC9qel9C+y7wKsChhXrKgroTkoJpe9ENn9C14jtD6uask8312xjPJg5yB/Hm2F1HjJ+OYcNbp8FrzTt03VVQ2w1Zmq/01WoMBCql+51j+JkW84oUi5rTvnR+g9/IUbFT3TVqsKJSC9MTYjpO865ekVQI6LJfARb/tXIjdEf8daGIVamR5NeKe7B85JKVm0gAI/5D7gojS0kSh8ACdODNI5xVEutBsZH68MQdE52UPQN11dUzhxflePRlF1fMn35q3YG6MM09clscEOytYgIdY8KU7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are guaranteed to be empty by the time they are shut down;
both are single-instance and there is an internal mount maintained
for as long as there is any contents.

Both have that internal mount pinned by every object in root.

In other words, kill_litter_super() boils down to kill_anon_super()
for those.

Reviewed-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/configfs/mount.c | 2 +-
 security/inode.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 456c4a2efb53..4929f3431189 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -116,7 +116,7 @@ static struct file_system_type configfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "configfs",
 	.init_fs_context = configfs_init_fs_context,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 };
 MODULE_ALIAS_FS("configfs");
 
diff --git a/security/inode.c b/security/inode.c
index 43382ef8896e..bf7b5e2e6955 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -70,7 +70,7 @@ static struct file_system_type fs_type = {
 	.owner =	THIS_MODULE,
 	.name =		"securityfs",
 	.init_fs_context = securityfs_init_fs_context,
-	.kill_sb =	kill_litter_super,
+	.kill_sb =	kill_anon_super,
 };
 
 /**
-- 
2.47.3


