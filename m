Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55186CAC5AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2758E000E; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CAB8E0006; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6BF8E0006; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 112778E0007
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C344B5BCBD
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.18.FA88925
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id F0FE780008
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UbGImuk0;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUEimjhDUEQYPy4l3MdZr7NUKB2dX1VaNYCU+wgrlmM=;
	b=iy/mTZO/LvO71RBfJZ9lyc1x2rgbHCu381MVKSjOWcC1wrFA3Jz7kxm7WekU9hYKUmGBl9
	AF6yivNx6ssKssBO3bxrK5WkpjTomu5DAkW7DDtKmE7xaLB/cQXjuEq8p/z/mO+VqT1WsH
	Jv5rO8NkpKGwW++n19kVlI59N6KeIs0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UbGImuk0;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=rDwYQayLdwM0XMTLtxmwdX01Q3TtcHEXJ+QUM2Ce3UA/QzEYFjNledPLymEam2dsMDm/kt
	BDhimsHYCkkKrbAmx8COXke3AW3NHWbehl+GPPZOxIEsG/2iaUFYZKsB404TwskGH044q0
	oiNzIY9GGzZveyg9FbzJVm1yjKT86oQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gUEimjhDUEQYPy4l3MdZr7NUKB2dX1VaNYCU+wgrlmM=; b=UbGImuk0Hl6O05dAIo++tXbfXg
	bvlF4ugn/z7/w2EQ+WJfE3qSwayHfSD7FZ2WBMNz6K9ZLxBAo3Xnp6YwxFn5v3MYwW9exoDqfBQPF
	fkdf5Xo577FTLg28ACzp2DbLTl14n8fe8XdzONACrcH3J3yyw/FRyw5d5qhgIHPN6lPd6qL/thgiF
	pLFF9csM6voffxVRfWz4kaHMGAm8pWVCRuKvIK0kEco36Q6TaQ+1aDbR3reF1QABJt4euhpb6Uaev
	NB8FQ3WEx33mWi4DdRTG0CAbF4XVByyQvcQW8WGsh4BaP5ZX5i6ODqkzW1xWrQypVDIO7EFhiAEv0
	/aAZWThw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK9-0000000ExCU-0Idj;
	Sat, 20 Sep 2025 07:48:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 08/39] configfs, securityfs: kill_litter_super() not needed
Date: Sat, 20 Sep 2025 08:47:27 +0100
Message-ID: <20250920074759.3564072-8-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0FE780008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gx6ww95osez4bruyyyum9xut3ddbrqk6
X-HE-Tag: 1758354485-311160
X-HE-Meta: U2FsdGVkX1/sZrfS+4B5VYehg3UJ/xf87Xyi/xNbUNCFkWCyHysNpDNsPeirjNIvFZq4yF8X2MeC1+a43nyZpCk/Z1hfWbU32CTk8l4o+OAAbsAn3+CIRUOxCw59zR8pIodrhkKU/b6iwHCtBiRhDqy0QsnnauwPd2OcygFltGegAeIhzoPwoUxAREiscr5AkXZO25XT2ArlbFQrfxtdcpfrt8YGNEPtjyi6TI0udsxnlowZyyZpOKMYg+u9jLPj4gMUNoL6i4MkoOV78st72xCLkuB8KXtn3puVEjDDc8C+gePWTGxW42k9xfh7ZMFs6GjnPVZ3pXwos547Epxlnh0qmtIRE03nE0clfHEyUHaTmAAOi+3JwWcuhj+9SyWFPBq7cGEZ9itYotKTskfMOqZv+59L99Rsr6e5RVPc7IERAWvv8ac5RnnJ/hBROIRUlbKqeU7YouDRnadMZYG91i/t820OvuuSvJAAkF0ZTJXm6MJe2llpLLkD3mCR5oZ6Ufl8t2Rs1qJurLCiVj5FWIkzZJ+C6JxtrrrKnOlnqUac+SXfz19n8NRY34270ZUQNyeixkztV1dFcbHlFG84+AkWfmnx7evXNbHHYMwfDzTz79xBnZJ3q6m5sDuXFNzaoZqCWsZuWB0F2Jc+uXfpoMqXZHvgiBWldmEoCdHTsEDEZXc8TUJgT1+LGCp6w8TRAeKwITvqGfzsviV9b7DuRC3jhsVTDqPjNQNo6+hBw9HEYywrGgiX4GGsH4Ukco6nA8cXKNRRfeRNW6okinv6aWeZIExXWFKoTdwkaMe3U4Px6vzcMVpTdViU1WkL1bOtlJpQWO8BTjDvOOdPwE2IHSKPp3nYkyMqsYqHA7qhjNDttMrsVvIDjvMJPI1zStGcQytUW7d+pEk5DGk4sTR//UOELr5+3SsTiRIr+mCiRc0EPHitIwPl2crMJuT/gTxvjuvkhjDCdEHJmJ5FlUl
 OKIwwfbU
 tST1N1sTphJkUOrw2ZWcxMZ18m9gCH+CwQBFiq+Zf9LtWY8HHW/i1KivKf3h4zKL1SqtPZcjK0cxbTQ4wAkFnFC87JS/vtTzO1XIU40LHQvffNXhzyaHzwoaBxzEf/37oy/YX6IhOG7PVjKwBWWPzPbvWoTWswSOcjk8mceLufCfRT+SEw9nzql+Vsbx5thJCxiZCz5GKg27NlGt6390JCg49i8HeCVwgxEnmbvQVFMvieFC6lsDQuVtKYSuwASptekuFYw0pgipmSD72pAOjzzZelk4Ajc0fOv3wrESTr9QVe7TdwT0XGOfQKfeQwUUOY+pXQVe6OyxNlpdJH3eDwFOHnGRzEEOhzi8Vv4p4y+QODN29R0gcONLQ3TsedH5v5Hg3CAswTm0w+BjX5WVPBhlRLG9DRV8Od/PpTn9P7F3oJp8iLRm9Qvyl0JX57kQpxIJOt3RQvoOGHt8Ozk30S+9KWEcPc4pHoSukHaN75OL4jNMmawhyIaawQQ==
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/configfs/mount.c | 2 +-
 security/inode.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 740f18b60c9d..fa66e25f0d75 100644
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


