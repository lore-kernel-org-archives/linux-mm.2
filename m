Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F1DCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE11E8E0025; Tue, 18 Nov 2025 01:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B228E0005; Tue, 18 Nov 2025 01:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B858E0025; Tue, 18 Nov 2025 01:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAECF8E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:21:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C2D613AA8C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:21:41 +0000 (UTC)
X-FDA: 84122731602.30.EE470FD
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id B957D1C0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:21:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="drr6P6/I";
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763446899;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKINhvrphJyrNwMIsOfgnLwqrkhKPlvlu+weyrXrIrI=;
	b=jq50BxAkJbQtxuQ4ovOOl6AyRYs9HFrfUF/xmVuLDNkvX9IZNjfwoaH4Cw/tRLVCvSSl1M
	WKik8/IcCyHMNLOVmbYSTX9jAtkPS+9iFBYtMOlMYDvCnlsTFgv1a1RmVPZCbdzYHDNNeF
	UrdvsOeX5Lv9DTsOpqyTzCe2iHKL2XA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="drr6P6/I";
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763446899; a=rsa-sha256;
	cv=none;
	b=4jaldZBAzqHL9eAY2ESf2wxKuTrbPRXXCHvkUC7GNNDJvhgPg0SB5HMfytTJ+Sxu9/aEXA
	QLVd1VJVTx5lwiJD9D1vPxqhRGF7+ZGx9JZQnDDnV3cpV+Q0wZkDxsVSLOIfAz/NvnOQup
	z1beeuNqsytD6L+r27hc2oFyJB6wmm4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WKINhvrphJyrNwMIsOfgnLwqrkhKPlvlu+weyrXrIrI=; b=drr6P6/ImDwO/t9/k7B747NbnQ
	2NNpVUCzrwlO4WPEqnMN1C5vUIu1JwP9bNUnldZd1a71TrolnehTHK9+jrp+oJNDVuCG4no5+7mwx
	+2osw5kE94CsjuVBAWO/KVsNQMqX+0RkuAh9I+5WH/8RdScDn9eVGgjDbWi0KV0NFh+QSOtbjg1ot
	olAWidgyu9oIdnGKdczwLgH5GpCcSpeNk4qBmUz/FxLORprEREsuLf/Tzp0Zp6U7NQ/cZ3CCtsRSm
	tbogeVwJBiD5TavPaIvgYzIJTas34LzcQNI4b3uIuie0hDfXaD5198X10oVYWQqVgMoWZb3/MMyN9
	nHpHfRjg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GEQb-0vTT;
	Tue, 18 Nov 2025 05:16:06 +0000
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
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 10/54] configfs, securityfs: kill_litter_super() not needed
Date: Tue, 18 Nov 2025 05:15:19 +0000
Message-ID: <20251118051604.3868588-11-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B957D1C0005
X-Stat-Signature: 7sy4t37ehubyyncgyzh6sj7pw18uo8gf
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763446899-720135
X-HE-Meta: U2FsdGVkX1+CI0dAUhNJS3V7FhB2nHPbJE2dgUtclPiPhxCXuEeINRKkq78ijSqm27uDnBIzZzrUKTfwWQydXPBteNPKN6gvI31jqGr7OvRR5UplhjvrKgCBCnprNkQTo7w+A6JTOu1xYsqLoFYUl/ZGNpfgeOeS5BMW2mqcX/US3LEQfyBEGyOony9P7E65jSbNDI+XiJBBpdvVMi4PjQnW2SatLhzRQcZPmHqsC5jup3uXbjzFbpKnNFWMuB/e4BwdVLx8VVnVSUJX9umnmD2qxfeHTaupxozTyxQQckQ8Gf48etUf2Ex4jGMpcXWBGD6NceyMj7IsugDuL/1mmTvD/au0iYO9rbpRi9O2IYIzdhYCdC9NMt8xDv7tAUMenHsPbI/TylVdl92q9Z/GnkJr8MQlNNL0hrGLnWT2ePkez+4U8EU8ACL4Eckolieq/KIL+xK3ibHvBBmLYwLEQezQ5HUzoLAKhbSJI/mwBpbUABs2ox2vqUVvwtoL2UOqYxAqemkBLfKEXYPJDmYedeKBmeSUtae4ERlcZR1JAUMsy0CqwV6XzbmU4OX1HmpY3mq5u5Ardjn7xG5gDuETJl8wl9M3HVMCzXlV3Tt7UA8RL72bPZfucJnBD15TxoKNEKwzjtpHAX1rUHeIlNEXh1vAIqy4n+PmAuWgckkxtwHjJmtwhLIec4SokBDpNFlMJgw4lXjn/RF69rtGC77qnuijKmqzVJDPQ7G2wzpFmifNvisPavS+StnFzDMEyZ106vZFBYCa8giiKqwU06Eyg3wTDBfEoeo5+1iqo8oVZXFMyygjrJoVW7zltPnQhZMEO60KLH/sT7ZlWXubMSkZDHmdwQksczEGqYFZm5GEozOs8VVXagl8Vp8MFzmd2yQsfGse3UxZLm0E5Yey94neGS/mkDO2TCzBFqER7Q4KXIKCllF3G/VqfKVM5XywH9/f3c/xTLU0BLRQEVZRCO5
 E+CsZegO
 9FITuaShJ65TvN5+LgXnSBTkaefnAZ8LWefc0B1n/tBUXsf0XDBUI2/kVVHyoAtNRO76RO4UW2Mpryh7CSmV9Kijg4d3HswYGVLA8G8tguYBImo9rcI8lf6oHLlP/XX0vZdueRouO2ejqZl1ZrbNaxpSySKQz0iMJMRASneSfZX9lyg0S2fb2pxK+8N6JY+8VK6vDshyBFCcYWlBiuKDzAidmOKFd/PoMk5x+B7o0QGItEtX0Gn1rDof9vDAgcOgcrUVvqfvTlfJVDfGmfVQXI67RXY3LCm+BhXfrpaDGU7Tlxa1jBg6VKcncG8yl5R4rdBFa5aUYd1fl6WFufPXpn1xHX8w8S5hQSOtfUiUvQ8TfZ6p4/9boD4+omB2zld9Y6Brpw9cvUMdkr006slwBtO/QZTzHM4xO05qxt5+rXhjUVvWHELNCe0aaOvLXe3WcdbdBqJBRCNtkeZHdsm6Af4+0O191oaRsSwQUmmWkrUjWn9ymhK5dA5NqcBMm8ezATu4O
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
Acked-by: Paul Moore <paul@paul-moore> (LSM)
Acked-by: Andreas Hindborg <a.hindborg@kernel.org> (configfs)
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


