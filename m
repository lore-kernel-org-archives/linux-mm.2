Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 760E0CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2188E003D; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D79C8E0038; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C638E0036; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 764BD8E003D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3157212E876
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.22.1AC9A55
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 50B3540007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uebdJF5p;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AteBZg1Rl8HXmlwF9pQEJDfnqUw3H67agXJaoVo2v7U=;
	b=af8Znx87eXcwSNL79VL1vt3V+xmGd6ay6NEyCapna6zlXn1HQVRWG5kPa0uKcmLPHc4osU
	xpJ78sRZUTMnPthud4TAxC8lQ7DXK3N448aU27Mo5PTv/Tux0MMrnHFThC+AybWVeXD/H/
	bN1DjJhaNtmXT3+zgkgfY1nH1eZmqEQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=ywkb+JL3Fqt+J146bjuNDEuLH11lil3AxdQAjdSqmzloltGzr807taABchICsd9362o7z1
	8WM3nKlXk+R/s0N2Aa//1ywtv+8o9IBuVw44/XVYaweQOJMAt4CNNl+R7p7UMtv8jdbQd9
	FkZEJIMtbnlPga17+O4ni8IoMfTCelw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uebdJF5p;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AteBZg1Rl8HXmlwF9pQEJDfnqUw3H67agXJaoVo2v7U=; b=uebdJF5pf07uYuFSwWcvMcjJA4
	aMBIgBZ07P6Z7Z5i2y6WJB9aj7c4VP5/O9k2aF7DzcSYPG1dwqEOTubJtzYsWoiPZo0kA2/jDUEF2
	b7r0UsEwbChuPZROhUWdb3uUGI7EdA5kZNpkgsHvboUEniW8t2gp12fPx3iHxPaq0vSuAJbv2p1HI
	kHCzgWGRfgOsZmsmtrjipM9tulW2sRBO40L3kgNJMHpw6+JqgEQ+1w2YyYwLjGPaQ73xX5QhOeyew
	yKSk130DpWM8QXtbXxc9lfE7z25d/IUY835TAk/kl1TCuVJN7Mr7fefmvVmRISgxVpvMmFWtqSBgp
	DZssowdQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4T-0000000GEPl-14AR;
	Tue, 18 Nov 2025 05:16:05 +0000
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
Subject: [PATCH v4 02/54] tracefs: fix a leak in eventfs_create_events_dir()
Date: Tue, 18 Nov 2025 05:15:11 +0000
Message-ID: <20251118051604.3868588-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 50B3540007
X-Stat-Signature: 839bf4jphxnpersx6eezxsk477h44ok7
X-HE-Tag: 1763442974-441841
X-HE-Meta: U2FsdGVkX1+NkSChGfiswSZ7a03SLJqgXTHJ+4vMC+Xfn7oWT/2aXsdG5iMokC4U2jD6kAzG5R9n/QU5H5XsZjUpQi0DdhSLcytQ2I1M3LslLdjvU8SM2uUzhM32U/1nBExNKhOPmvQGmIwiOWuXSFtQ2zd+fZeXPvAgrWBG5ASDg1z2ofOD9QrlJcoVHAZzG4b5TPunIw2g9hfnvfmRglnNvxcOmT7eK62J17I1j1doKTyzsc08MCgfSVEsp3aknGutiNkU04FCVDYQ3yYcWcnNiCwNJlXskjIfqRUZfl56NywBlj0pepr7ZxTKIug7NVk+aHyPHOq20kvPfFI3mVmjga+loB5TEnaG0GcE9BI6JzDcZVGGVXMSyRRZusM24da8aW3k9tdw4hNwkSpNPXRCz3uwxY792krhkBXxGtA7oOtW80qa5GxAF9/1iXewcGLZQVxMk2ECs1OkKh506r52twtH0p9VxFLLl6KTKnKsmRYpF5gevDhDG1l7xeljYNaD5NY/227PMGoRfxRwkeMXdkZ8Ezqu0ljqg/2RbcFxTerqksqabxTpMkGYJ78V0ntD/eFeM0lRkYZhpR3uSd99sT0KhpqFjkCNf1keV2Zu9VrwDnT8qtlYaJpOwZIPvMSDoZluQRcpRMSaMNRyU51cAxTkkdPHrcKx5CmGAyiF5OluVMc1z6XhYOq353Fr3/ajppE+xm2WMLZ5GVQlrrlifcDnih/ZGFnz6eqwkfazKwXV5BuyaL4UI4/ALocx66NtuBKmhUBdLtede4ODteQQ8B52N9HQq1upkev7WEBpCfge56YQqNS/LQEt4PY02fp8LmCqRY/g8AW050uFuqa5y2zhmvCtDaf2uppPmWgyeh63UsZsakTNLKc6htpBviMj4rdEFap+6mw0TD/r88KVl2ZwFGrB78MJHX+oBO+a9sUD1Qu6NO3WCmIOawqm227LWwtBDrnrWSKcxoJ
 dcEpO/Dc
 2PazhoO4eie/CXsWx768Jas04vPGeiM3HxRw29F3AUvnPN0W8D731QvEILa/jWPesw8LSl4MwZkEECL93vtYdX9RfrokNxyv9nhRF5/vyWHsY/DVrkGxu4nyFyJp0M7VNGfaCKMia1QdWKU8yo2QFNmvO4SqzIwps88YO1EEwcmZ9Du0fXYKKT/weulTAL9/zTP8+4syeQIg07RCs0V3mp0fLedX/yF5OajQ6a61x7QsPcsdqmkt6bgAaCvq1jHlPUDZjylcfdQJyB7fdUPvbtV2VmicsrCf0V2xYczcfBHrUhQq3qJA8jKYSVG25QbNxiibSmWUJDk/ONwfztDmC8W46bvuBnwWaIFMEp4X3/rrz69LzsDzFl+mTvmFp0F8qoJL6bie/fareJcNuwVAEvTgrmh60WoI36ngV8edlLY/356Agf9zSIj9Eq0Vc8so/lD8W/KwIhi/2exgF/WnX6AWQU2IGJKjj+fTg7BU17FVCTaKxv0fQ3Wdg07vFIpvuJuaOY9lDwbiZZGIk2winIdAzpw==
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


