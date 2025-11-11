Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D8CCD13D2
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C21E8E0014; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0738E0013; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC558E001F; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCC3A8E0022
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EDC358E2A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.10.C58302B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id C71A580009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="wefX/RwZ";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=At4vL/qALJ6a6JhYUKSdptTA0pRAJt3RPycnmOCvToUJ0ixLkl9ahtFdTBRUAu/kSTOzDm
	4UkLNZ/j3mHEzawrVqEHDN4s0QqmkN6eYyO50LnGsWqFJW5X/b8TqwDSCRSoSjH3UHyiHG
	fPqv9w6JWB7HL4EI/DDe3FFsYED0ghg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="wefX/RwZ";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSvwG6RsfCAVSbS4+/4CBqqk98DhL2WOLYlzO7apNsA=;
	b=3Fag+7eQqFq73fpUanUn7pqObdHOwLgEMqh85GRhuy0onByhNsB4HqeUB+y6YVPko8ob87
	oflUsOWmdsOZ2TyXW5qakLtN+ynGh0+lqgShK+L1UCYgvGbeu09RyjRTTRd7DvGHx1u1Cs
	cZQuLwWy+LEfGomYKCcdbsoAjnHVozw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nSvwG6RsfCAVSbS4+/4CBqqk98DhL2WOLYlzO7apNsA=; b=wefX/RwZfv4dtD69RnkIvTZIqG
	PTG9ZHWW0bW4yX7BJNMx9wJ7AcDjxOPZ6mjVbD4CD7BuvVWvQMZWwS9FOaVlQbm4I+8IkYhfOsXlM
	LgAZbd4hEKtquq0INN1Hk/j7AThuKTggf/CXmrE8+aLBpMOzJ+dusy+dlWnpKk/WOKN+JT0pQ754g
	vwcnMguWJwt8rzuweaSc75VPeWvEKDrpB3XyL32RFnJstyZqvdfTe5Gw+9cBZ54VZCTp+8o5rC9hI
	YtwPtgJegXuyGqE0TaBkvEIYqX6np1Vq3VZldMhc7DFvG2ZPaj3ELNQUELCXJPOcMQ6DUTDp0hZz0
	oBUOoPcA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000Bwyb-3vRs;
	Tue, 11 Nov 2025 06:55:24 +0000
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
Subject: [PATCH v3 18/50] convert pstore
Date: Tue, 11 Nov 2025 06:54:47 +0000
Message-ID: <20251111065520.2847791-19-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C71A580009
X-Stat-Signature: u57m1rhaufrgeri1qqk8yasbgtguurca
X-HE-Tag: 1762844130-99944
X-HE-Meta: U2FsdGVkX1+8G5xfBC5vZNFOZPKc87IkHYlfrXsf212sfREeLqnsLHNwiB3WfSUqRQryTlJE+7AZYIl8tyAKQywK1JetiNlGhf7I6b2B0ycGovqbvmu6zPCgTllDHpw6Mwch5UcQZ4JBFjU2A2OwCUhh4lF7BCrBllhcT3pfok+jXnXPsNTBNrulx40XIxYhG7jPtvJQdibHWFvhsezg8XKCfF9UPJxUdlMpnxkMOGrIVEpyzULnV9V3OwoWgty+py+gTZU7f/75BtZq8WKk8kWUEZLxMUpCPYcXcal8DMRp/YnvY+3Q+8I4iBDqAwJwSotB/XyW/zYav08HF8ACwb+43ZSdqh5reDnJN83YMVSHD4lzogdz0R7doVk8KYNFVK+mO/LZRfvs60uG6/oo0CZDymxgO8TKQiBM5tzU+93Ba/Ez8Est0rxmMGQ1LrJVd1OT7AgRPyZsVYmTCLx2UDv9CJwAxnBzkfgzGmjxPp6+5Ua8mjMeVVohDge0q2T0WMeREZD/i1Q8yziqVVxbHLP2y17LliQYwC8yhTRYb8TSTlteTj61/zkC9a+IVqj20JXggkRwsikbmEEk8Pz5uBBVzhfLo7pP8o5v/0NJf4xz7dm6l86RLcnU56733sbxIRW02b+v+QqL5FPNMbUVUu9EVNMZo8Yp4BSPxPNmDymeO+xZlwSFrmVsZSpW0I7hwAvLGicRCfAoG+H2RBCCAx0T69bMEAu1PdRXQbFExOSSeKxihz3XUTHRApWTJVumQdtlgE0BmmKX3QzDskjYw1V0rbmdECazA4xF1W1jOw9Fvv+QmD6GHXwogHWCBMzRyrXRzKK0L4g+sx1CMflnF4QESytmlhTeLr1Op7y0gKNcNqHHqUCYiCFQzvYWa2BiRmpB23Sw+LKJv8cbs5hrpJXjMnNp/BLvZ2dg6ZHPEm8OOMaHlz9IIQYMWPtfiKxuzWf9HAHLZzlpNvADZ/8
 PxWzAJ8B
 ezS+bLZRHw2WCqOWcVJnkpWOe9gIBb7zSycAyBV3LcpmngAwOjvMyg4GAf5diX+JYPz86vtw3fEBbIJERjho603heg30+WLySzzqxfPHXuDQYkLuAWbc1X4PKZSwYo1ruAz0MfTfKP/P5txepfCgeLJR1ExMIy1v6ms2rifRUAIbAL/BcFFFuSa4QmSOy+bdXvKOUNYwMmN+99O+C1I4y0Z8zL4SV5JXEQU4Z8TMI8R+N4ywigj3RbaZa3+kIkgBYkNQxXfFx7NarMLb0bprpEu7U9e/UPCKu7QNA50ytyZ0tlrTJQBuWwmTpSt2A+QpQhnnP1MCsFcQLTwV+xUSfM6nFgzJAHFoTittFto3C+884Hh2xdWGu3IWrmWmGkHJS4DWS4XeGL9Vj9zb8QbRSgRQM3FaDgi1a/KvbcQTt71r5Ek1F/YjKSY+oRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object creation by d_alloc_name()+d_add() in pstore_mkfile(), removal -
via normal VFS codepaths (with ->unlink() using simple_unlink()) or
in pstore_put_backend_records() via locked_recursive_removal()

Replace d_add() with d_make_persistent()+dput() - that's what really
happens there.  The reference that goes into record->dentry is valid
only until the unlink (and explicitly cleared by pstore_unlink()).

Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/pstore/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index b4e55c90f8dc..71deffcc3356 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -373,7 +373,7 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 	if (!dentry)
 		return -ENOMEM;
 
-	private->dentry = dentry;
+	private->dentry = dentry; // borrowed
 	private->record = record;
 	inode->i_size = private->total_size = size;
 	inode->i_private = private;
@@ -382,7 +382,8 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 		inode_set_mtime_to_ts(inode,
 				      inode_set_ctime_to_ts(inode, record->time));
 
-	d_add(dentry, no_free_ptr(inode));
+	d_make_persistent(dentry, no_free_ptr(inode));
+	dput(dentry);
 
 	list_add(&(no_free_ptr(private))->list, &records_list);
 
@@ -465,7 +466,7 @@ static void pstore_kill_sb(struct super_block *sb)
 	guard(mutex)(&pstore_sb_lock);
 	WARN_ON(pstore_sb && pstore_sb != sb);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	pstore_sb = NULL;
 
 	guard(mutex)(&records_list_lock);
-- 
2.47.3


