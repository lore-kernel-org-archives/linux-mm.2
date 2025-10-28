Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F7ACCCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B84800DA; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262B4800E2; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77B4800E4; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5E3800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC31312A632
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.17.B95FFD6
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 031DDC0008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=VsVuTNuT;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7cNvRx/cApjSX66b8FSjJI2fyjXpW5PkYfHFIOF7HU=;
	b=8CErjcVG2xL+svF4LMg84uedwvY38rbdbsVDUr8EDZ2YWutdjRFHEYpa2KwUh0EAjMAONT
	WusIdOJl/CyMz8nuemHO7TB9HZWGy/zpwLorJXXAHQHSR5RIKQ+QuFJ5ikg4HbxVM05j2O
	RS55o9qonIujwWH8tleJ7Yd09cGo4Zs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=Dq4ncnke2F9lFfdsUmLtYGZaZrRMx5dhj7TKYndK4/5ncsK5T02cg7QrSiPQoXjVDKQS8C
	CJbUe8h/3Mg9KnFyn3L6p0e2GwvgiNHG4LrC6mAqstFckkkUYuXV+L/ORX7/pgQidFugVX
	o3BanlKjrABBZdw/jVWWfUD9SqDVEfk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=VsVuTNuT;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E7cNvRx/cApjSX66b8FSjJI2fyjXpW5PkYfHFIOF7HU=; b=VsVuTNuTIHc4/BtKRQmf0nDY73
	mWl3Dwzu6X5U8nei1TpyXq2X5yrpxoWybXmkIBZHiLZeQRHMsrlmBN092u9eokVSxIVHiGGfGqAeO
	7qi0K0TSduNTt31COYmzintXgfZyhK7fAg5CVAmj7864qVd0dLe+XTrV9EyiCZDYDyRMnwRCbrTyL
	+f2gJ0BAiNlXB4R7uaB8Kngk2oOAKX1h/Np8qMsm2LPbZpFwdi5xGpH1Kxg/h4/T9ngbozltJyjKI
	W+ucGiqo0W/h+YgF0F4ZrGgk+et564BA8iBO9ZprjWBaJB9l37W++eesJdNfNGR9ET7XB5Py/n4g0
	dXRdClJg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqo-00000001eVR-3bCF;
	Tue, 28 Oct 2025 00:46:14 +0000
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
Subject: [PATCH v2 02/50] tracefs: fix a leak in eventfs_create_events_dir()
Date: Tue, 28 Oct 2025 00:45:21 +0000
Message-ID: <20251028004614.393374-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: xyiyiigoe6n6d4m8rfeomrqwfp18sf3m
X-Rspam-User: 
X-Rspamd-Queue-Id: 031DDC0008
X-HE-Tag: 1761612383-481801
X-HE-Meta: U2FsdGVkX1+yVHU7mkTy31a/E0A8xy2LSJINT8kgu1+a+rtlUsOMe9iMGfL28B852XBceA/+Dyirq5CYa3TX8gJVkzLasVH75In2wmRyMMpfhctc/WUH84uiFSJ+tBYjMv7kurMmnG1GSaHCFv/PDPT4o50RpEmjwC4UMAzFjPk6ddXsNyPcUezeXb26pKTTW2Mx2o+Jwv13lKeV+U3aJpSg0jf5fo5tAzTZJd0X7HEmOhYcvq9zQMlGB2StHqLaJ3S4v7zAHtVlu48FlKx1WsVEys7D8MY1fF32ZvomPmOB9hw02LnoMaNXSm62WuyNx/jNC9LEAwItGs/raAmd1ORFPMTG8zBRJCfLsGaJpPdqdEYKhPbR4ajljltSTZCb5+kqPruf+vHf4I/ybKZoiA28jjzn3YqcRK1VLXolocbERIYsJz/CLTCtrzmBP+nbCcSYDI07vp6f26fOJ9PvnDrDNjvuXmrAiLGbJmJCBGoLWu0AXBQ0tX/vkk7NKElrkRCdH/83PW/l0ZiUSuWQBRB13HzeIKYpRvrlbWSx03BcJezSx64kIJP58jRKRMkGG0XyZuTLHcY/F1w/1xoKr0qZAZ0ir9IjdErr9c2i52124iEnciAwSn4KWch9JMmbIiXljXHohRtJ0fh8v6ANjt+xMnWDKrKORxtF2h6sWRwDLnHlqfXKMqNoKHa2Pn/J5NCumMZhg12yBAYHLw73du9aqG1pvmzh0VycTLa7XhyKOwU+hjTq7ofo/tCYWOJ5V07511U3DB+JxCndJ/0sWuhWPFegrFqJyCs0ZGQTrp17UDeLsHXKRDM4sP26zyHb7JD37+9m3LSkC5lBkIFkmPXSkFrtVZ0Kqzug2t/xaMq4wgs3dX3QoiSH8lkIm3xiM8khtdYpHzdi2IBgLdFEVUmTE1JjwB1fCv28nRCkWudyiEIIkrfEPokNUMj5puGsHLamtg4bjMUxt2O3phw
 MB2G0XG+
 dTWfLSKMYICvVnHbR9YGxFMnEnLMFULIeZcuglz/jZN3K/LLP0PASDBdjNFyoTGGWvCiM7ycfKa0Yk+034yTPfMlmiPkwjLIIQwR6mo3GMNdzHvET/FmqlmoJem6bqx2CHGkJu7PtimCCdHOkGHNtlpKN1wFzsNkFtpb3oyu4EY0cIvT4lbaSWczhYquj4t4DlElM3X47eJyYB7k7v/mzCACNm9OBGfvK4e2n3/obCkGfBX0BcJj3YlxuL3XSWFYtleVW+KHC5on/bpjQrdB4Wz1VaVjOUMHcV9ZYUXSJvJBmpJEzbsRX4IL14P21NPm9ukLXL3P9nDJBpaWg29qi9JIgr6hOkTMyOn0WBC6Qn1VQhlpXL4A3zXghUER5uLU4LGFcdKXTsO2Ws/2KbKvvi0t+83ByY88vMN4nYEjLfCnc07PmJqkDkJj+Tb5BWNfH9D5oDkxfsv3moa8UXENKqNM5ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we have LOCKDOWN_TRACEFS, the function bails out - *after*
having locked the parent directory and without bothering to
undo that.  Just check it before tracefs_start_creating()...

Fixes: e24709454c45 "tracefs/eventfs: Add missing lockdown checks"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/tracefs/event_inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 8705c77a9e75..93c231601c8e 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -757,7 +757,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 						const struct eventfs_entry *entries,
 						int size, void *data)
 {
-	struct dentry *dentry = tracefs_start_creating(name, parent);
+	struct dentry *dentry;
 	struct eventfs_root_inode *rei;
 	struct eventfs_inode *ei;
 	struct tracefs_inode *ti;
@@ -768,6 +768,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	if (security_locked_down(LOCKDOWN_TRACEFS))
 		return NULL;
 
+	dentry = tracefs_start_creating(name, parent);
 	if (IS_ERR(dentry))
 		return ERR_CAST(dentry);
 
-- 
2.47.3


