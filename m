Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79771CED247
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FDA98E002C; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47B4D8E0036; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0E38E0025; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 34B5E8E0026
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DABB9C0388
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.21.EA57D2F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id F3600A0004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Vl/3NOTL";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=dLk9ikPpwm0ogbMqE51E3/CzPoyB4HLjGULQtMSXR4cDRGjxYDtc+/BXLIWIYnaZOIeRyH
	Xi+IH5gSNL3Rv3gX+v7kI6HIFQSav+hYJCQ2iNhABovFMpuaCPl7aHHg0Pb5CER61fu+7X
	+ZAow6V2qd9mZB36I8svGbQK9kfcrew=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Vl/3NOTL";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXGw1nJCnekakkZR178NLSh8+iviODtKUClSm5rridQ=;
	b=zfJaYxKDaPZS5mJQISIqPKC8oKFozfv18ml6aPFobGm9nF4U4bRzVfAu0lYflSW0WwzKB0
	oTFNYuVQApXxjx0Hn2efj3o7Smz3EdEpseOMvWJTGF8JVOJIs9Y2tAo44yC9YqtzSjafRA
	IFk1dCZxmriwXnYUOh1TOSmyZ+y5yHo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nXGw1nJCnekakkZR178NLSh8+iviODtKUClSm5rridQ=; b=Vl/3NOTLarYBwB87GqxphHKkQI
	7nr+xrUdOHGzbQvNgPwTh/+ZuDIklH3LjYUAJTNerzga8Stv121nDnS3dDUlEWMDcLUPP0vdvR7CY
	bwy1nf84MahGcCd/mXVTinqlKGe/gh3FEFU4G0XTQY2caZj4q/ktudPogUMWC6fe4UAt6FUnBzwDI
	wlEBeCbvC+oK7xQDjQ7Gp/b5U1/DIQzgr2komhocDqrOpYndVRm6Prd84cwdTe/IF2ZycbvfTJfwh
	/cdvCBu8/rsMTkT9oC8Hh15d+60epPGvbHco9HjSlcLntpJEtmjdXQst25vMXn5ZTu5l4vga99Rih
	xpFUYzEg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GEQg-1EYJ;
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
Subject: [PATCH v4 11/54] convert xenfs
Date: Tue, 18 Nov 2025 05:15:20 +0000
Message-ID: <20251118051604.3868588-12-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F3600A0004
X-Stat-Signature: if9wjwrpnpefqou7w3azg89mjegzh4qq
X-Rspam-User: 
X-HE-Tag: 1763442973-35986
X-HE-Meta: U2FsdGVkX18NcP1Tx1OcEmPnqYhtxFi5mAgP6uAGW6dNdg1Un8OPhpxobQDB14B6wNf49a1shCA6z04dxfEnr2Y2kLDg2Xz0Bcm/FTb0Tp1/6GtkSlaZ3exw79VxOOkJt8ROfDiNE5PBJM+Q9VmkGuDuKK3SxheQKM4TK0bfaOEuVMkZe8YMBgFwW5wRqfArTO6hlXQmkgwimNqgVvS03TW9pbLiMYgqd9/JJezXzhHv/Xf39QfsJ08aumqRwcluFS53pEZzX8LLP+JsIyMpxfq/bLZAR4DZAzyddi5ikEZh/5NKr12wnkk2DdAmyaxDQkXbAlRyLaNuhMAW9gnn2J5kknuSftzlZrnkjOE0XlrET/g14t/8LLFLIS+z1dBgQ+SraN0YlLuGA4MXaShWTnJd24g/KAEwZGqhQDlTdBt4rDrLJCfQr+dlccruP4QyEPWiJp0WpCtdWwgVskK83mjAauF9THkxiNclNQZZ1CVReHmVV1tAfg00jX6jxVDh1p6q4oGGuBQ9LqB//XypAoiDudYFVPpCcjHAZjRjqP0YVQF/afiILtTtz8juTCvbw4zcvyd+FQavidtFh+T+5/K/LvGypn0JFc0eJiEj4F0oGVRF0N8JCy6mhEcgIGqIELgofB4GeTjfPuWlcWK/ct6RQPZJ+/ni7QFQlaVrxiouJG1n+Ezhiu3HZEWAJ+VD0QBM7V6oacunO10Qg0VzuZlvuQ5sKscoYusp4c0JAlzxAABUFRrF5LKbzKZFOmqpE0SQ3eoseYLFp4kTAT+WdQb3/X1A4fCRwqztxqOANNZL1s51ucmC3i8SY7P5VYEo0DZ3Y2keT2i05xqqw8rsUh+c+TdI51N8lzTg7V74NtqN1Gl/89HbL56xWyjFK8CHi+x+f35pSu8hIoDvk6qvzNvSnRcbHgib9jccsZRAMJyGOaQCigpZNP5OOYhzGSON16sOt2ystETmunZrrvc
 1etMF91J
 gegdFGzGP+dWxAncQAWwsO/9uuIIPcifUAisXdbAnoGS4Ta00zdE1lJpuzh3Un0LfeSyF5F6NawsHq51qN/lSDs0PxkDT9PW9+wjxv84INGJjuTPvWGtN+xMA8ZgRliHFj9fgGp5fBZm9YsuQRgMFRPhi7tLHsyVeksvG+lovUliacm1Q3o7QefR3QDcDmqFd1KMqEy2VkbzotRIQXD/3Mbmqbztq/369WFaP5tSjA2gTQBSfaGu4Ss6gAK13YDJmgM10OjlnYVtavxJoS7ZDVxsbcSHPmRLPl9hhpFaUGdLnn1yILPSBPSR/QTtSaRndNTaudLGpCHhaLBD9gbjx4p1PxwLaIGkqNhn4GKMtott0OXBpTd5LdELnUXYLUrB28ibkWLMIxMhFdKGGkcyhRZbP3B30v6xUXunC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

entirely static tree, populated by simple_fill_super().  Can switch
to kill_anon_super() without any other changes.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/xen/xenfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index d7d64235010d..37ea7c5c0346 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -88,7 +88,7 @@ static struct file_system_type xenfs_type = {
 	.owner =	THIS_MODULE,
 	.name =		"xenfs",
 	.init_fs_context = xenfs_init_fs_context,
-	.kill_sb =	kill_litter_super,
+	.kill_sb =	kill_anon_super,
 };
 MODULE_ALIAS_FS("xenfs");
 
-- 
2.47.3


