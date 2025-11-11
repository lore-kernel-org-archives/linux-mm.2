Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1270CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35128E0010; Tue, 11 Nov 2025 03:01:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6288E0002; Tue, 11 Nov 2025 03:01:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5E48E0010; Tue, 11 Nov 2025 03:01:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC2D68E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:01:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72D0C88CBE
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:01:38 +0000 (UTC)
X-FDA: 84097581876.25.929B1E3
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id C08F540017
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:01:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hUv5N0YJ;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762848096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AteBZg1Rl8HXmlwF9pQEJDfnqUw3H67agXJaoVo2v7U=;
	b=wLLntPU0WLoqDG+Ic61/Jcm/84Qj2JM92kW7MXO33w3S1Bdxwt1NZkaUg8Yq9fJAKi8HKR
	6CWM4rwHzwDf3ubayItPjb4g/ZJ7bHhjdtQ2m19r6UyKyMOCupl6xOgo7FmSwTwYvkO/gG
	8eJxTkpqpLVG/dKtU+i0wBqJRNxnBBk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hUv5N0YJ;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762848096; a=rsa-sha256;
	cv=none;
	b=my8XDjE6PhGGuWTZLXxMDdpXrlAnDY/YvbMqZU8iKL5TFxcil9RKypoVLe89uh855Hdq93
	qaO7UgFb4R/S6jtNhtnmQgpVCEbZblXtnx6PTitc56oJrqw4/B9QIvoRu2UnvTfipbTK0E
	h9mxpe3/iRMD8lOaPpkiP97uqYPdnFA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AteBZg1Rl8HXmlwF9pQEJDfnqUw3H67agXJaoVo2v7U=; b=hUv5N0YJTnik1pbrNSxtqUBlQw
	9cOvz0bTB4Y27X5wtakM2e5mLlL+A1vWqkpKBScibz62/7hNSxH8Qhl/fXtcMmytQT7KieaNS93ca
	hSKrCcXInNpOmxOg9eQWON/uKQvv6Y+fuhHuN2yUosFBERdlRKC96DkJ1Mf2tvSoj85JiuuFtleeN
	YlqExq3xf5s14ARGwCA+sxhLM52ngQal5Zw4sXygbVTV9c58CEwdgjIEIq3AGep0pSKwDneTJaDmC
	CHzBiKcobHsZWXnkvKcGNSyWFwPNG1YHAhBgL/Jbp8AOUXxVE9E06HJMW//0RGDcGPaDreuMcr9cb
	CfuCNGUA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHh-0000000Bwu0-1wva;
	Tue, 11 Nov 2025 06:55:21 +0000
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
Subject: [PATCH v3 02/50] tracefs: fix a leak in eventfs_create_events_dir()
Date: Tue, 11 Nov 2025 06:54:31 +0000
Message-ID: <20251111065520.2847791-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C08F540017
X-Stat-Signature: oc6eyh41grpgyeu7t8nyoecycymkygfy
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762848096-473100
X-HE-Meta: U2FsdGVkX1990ZHQNFwjjMCI94L5NFYh5SI0fpPoagV8IdclYt9iydwOBKqON/dml/Fetk8HDT8DmIYLOTWMBanV7W8wpsBfM1tbvhxs8GDBDEMVDydh8JdVeCbdWixl9gMYNKMp/xWlHWOL++SEwqNaVqq5QMXWohruK0IMkkzW/Zq0Qh6rVvrfeWDtY1zzMewoavurk9eVYZO/pnG6IYYWIhH2ZbfYSUvBD9Cnx+ZOqzZhc1Sfk8WErvH6h6GqIrNk9Q1dww9clOdXD3aAe/ocOM8m+rY6W7/EQ4Sb9xJtHOfUsEsNrp8g8xmgMSXUXVIQrSmHOD2QbGk6FwrreZ1tjKz9MuN9A2Nx9W0a02P2z/RWdXD5FMTHwIWLI6qQxVu8NcJXvwDBq5p/JeF/dxHve4TfRY8/rmWWOgLioewjoe7bWeOzKcYSiV08Ijw7pm7iRbhIsaBXR+imA5ej9ufyFM7R28E61TYn/6iKS3/jsxmf1GrRsz0+UPu/85kYe9iLOGocwdvr4ZY/NaWhuaJnfFuvnlluJ0d1sllPp5mXtmU68ECFflSblPspiL3n5WU3mGkbdzPpngF8KWqVCQhFzlIkfLtOoqJb+aTaQTGuYA2ty1jwXCRBp5iQrYExKoVq7OoZSZc1g+ubf4LbEEJSCHfB5xkMPMRaSVVrbXrVwZnqrZi7x+hQwM/xAJV2s7bwUrrvQiB5a5k23/RoQ/tNI9wilPPxLk1gxImT4Bvg/cLUOtgPRt3QOeBxJnpv6FBlcIduI0k2eFrXfGt1NbIlhFZjsA4eDWftcYhmwnlskpJoh/5gAt0eiP6qLSJrf55lZTcDTVAFgD35aO9iioU8Lo4QGxPrYBtuuSDyxdpZqQVEyK5x9TxtLnnRRTtnAoYBO/7G0F3L/ygBz3CSE47vGmBPoNcmZcJaSNQHD8cxIfsTKaAuE9qsmYsHyRoDFufFyEb1+pW6JYeFPAi
 5DCP77by
 Z5MVzM/6nMeYVqvIrcUBMX9r5CrjLN420l+oJsaRzLku1v0SNqLhR30pQsF1HC9YJccBKkvonrHLpFKyP+lHVbxzjpU6X96Dde8HcYCtDqdLN4Jj6NHIfAjEkbrCgR6AMbljAKuEE2QenmDW1qUxhPu5RoomiC1rCJNSNSrOvOsXmtHM6ARLVK3TeoqhDF3x3vJrjrcJq5jLRJcXJRo8ohemkTf74oEU7rrv+I6xdTYH6u08VT6Ymp9yU1+QyXvxwXM7NEPwg7UicAbWIT1uTG79fop/M1seX9QBeTI6b2Ee1G2d5XECS2Pt5vzZpoLKf/yBl0/Q46kUw9Dm01ptHRpIn+WrMDonpNQc6my+ZCbmVfG4bPOpIUKBbvXE1DYT6JgAWt2VhYV3cQpl/2K77lDHEew1th70B6jQrxwgB8ceYov9qorRictxCbHdBFPvWHFmFV4GSpmGWLaD0R4pO9pVPV3nWmgJ4A38AGgHrL0+7TZ/x7wfxh5pjEhpHa6uL4GLdmhB6KJKjvaQFD0Ut7WS1uQ==
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
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
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


