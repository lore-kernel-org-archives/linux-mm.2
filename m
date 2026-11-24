Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30430606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ctl9NT1p;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ag30EA4y;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ctl9NT1p;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ag30EA4y
Received: by kanga.kvack.org (Postfix)
	id 601986B068F; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD536B0695; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D43A6B0691; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA3766B068C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E035EA0BB3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:10 +0000 (UTC)
X-FDA: 85469866860.10.3B27B43
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id BDE9C180006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ctl9NT1p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ag30EA4y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ctl9NT1p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ag30EA4y;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795521548;
	b=7edVajgo0LyVkqnNomissnt4XtIVMiyLn0GnCaZ6vYarunrVRdt1OxhE9D8Jtipu3cjeiL
	jLC3TYQNregr6PrNfcqJ9ODrh4Px1+xG2Wdb+MnNP3s+Wky/5xIKWBgqMgfWscP3+2okch
	VqXkja3QcS62GmPgkUI0rFl+A1jLC4Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795521548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOrzKYoXAZDsQinXLLtvPKctVW1W6s+qcE9bVHQLxXg=;
	b=0Ib8sb0Ss9fcMg91Z3DEzIOisW5cvJmCWjPYdScNuWANXIRhzfmFFdTh8rl/Db/usXnZJC
	IajCDJgZASMfKM1p+W4sPaSM08X3s8omUU5YlSKMdEKVIE5ex12x1/VB31LQ9CV8KI91d2
	gkhc9TEW4zuh+tVYsQfg79hxwQ3Inag=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ctl9NT1p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ag30EA4y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ctl9NT1p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ag30EA4y;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E6122224C;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lOrzKYoXAZDsQinXLLtvPKctVW1W6s+qcE9bVHQLxXg=;
	b=ctl9NT1pjBurcDjdlw+QTY4xCR59C1IIQtqcufQDK3nJxk8G3/H+2litKKUXVWiWTSPNmV
	FieV2XXTyihQExoLfMnGAAJEw4789KQc5IUW3LHex7FotPhIQg4Q4pkTZfm1z8A0UHGWLD
	WBKBUX5Vuw+TajZWMAyLxlRV+vbrDz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lOrzKYoXAZDsQinXLLtvPKctVW1W6s+qcE9bVHQLxXg=;
	b=ag30EA4y20Rkr9s/7LKjtdF8/4QPBxJeLV/3ILvQkwPOwA9140T1+Xer3Es2IUMVAz5XmX
	n/NBxhgj0t6MojBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lOrzKYoXAZDsQinXLLtvPKctVW1W6s+qcE9bVHQLxXg=;
	b=ctl9NT1pjBurcDjdlw+QTY4xCR59C1IIQtqcufQDK3nJxk8G3/H+2litKKUXVWiWTSPNmV
	FieV2XXTyihQExoLfMnGAAJEw4789KQc5IUW3LHex7FotPhIQg4Q4pkTZfm1z8A0UHGWLD
	WBKBUX5Vuw+TajZWMAyLxlRV+vbrDz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lOrzKYoXAZDsQinXLLtvPKctVW1W6s+qcE9bVHQLxXg=;
	b=ag30EA4y20Rkr9s/7LKjtdF8/4QPBxJeLV/3ILvQkwPOwA9140T1+Xer3Es2IUMVAz5XmX
	n/NBxhgj0t6MojBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FE291339F;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l7KAAAt8BWtOZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 11:59:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E5B622784F; Tue, 24 Nov 2026 12:59:01 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	<linux-mm@kvack.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 5/8] fs: Defer reclaim of inodes requiring metadata writeback
Date: Tue, 24 Nov 2026 12:58:49 +0100
Message-ID: <20261124115850.3512-13-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124113450.3451-1-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1029; i=jack@suse.cz; h=from:subject; bh=NcANvdLSL9uTS5c3IhPYy4gJEYBnvTX5TIsYlIvC2eQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBXv9NiH28xvLtQaw6a4N1+JoA2cI8CjwCjIjr FKjea+2GaKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawV7/QAKCRCcnaoHP2RA 2W/SB/9W9eMDjKT3yZZH1RdHbjoa5Ownf/H8POAlcfH0v9fD4RPNdlFLC0p8Zto6Btk3jWn+iz2 lw3byuu1P1GCdFX4v9hXtFYbQ+dUcXqv9YiY8DF5qEY7XGqatokNBon6HG78Au9/x3sf9n2c1Tn hSm9oU2lP+TAUYdO2teBr2jiLv2ad+zG2hHkhFW2L0O6U6+1uYJig0qeIwva20xYpvwzj+jS24s pbLm6OMSJQMjHf5BgVMhcRSfj50YwHVStGBPtQLL3ue2boVJ7vIfvXo/16KdJ5dbG+saDFiF1h3 smMGuV67yFnLe1yO7r7OD6J9ea2LSlt6EV2SlVCcDlikSevI
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BDE9C180006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: i7ya4ubzckiy6jybqizqdzjqqkdxxhdb
X-HE-Tag: 1795521548-75309
X-HE-Meta: U2FsdGVkX19tzATF17lTKEYSw4TtixKNc+U/DGQ0I1Br7VRZZ77y+owJ5AV+OAW5ks/sCiCaNZSNTL5GEfHAjkH5Ege6B8JRrRHDtFyQLgYAONGU0t9rb5aTgVWFUcLjDXLB2J22LM+SO6l1bfw9waG1mcBXPPOy7wq2ZIP+/eCRNMoh91jB1YZwDUdYHOTKnlSrxke/E+weW1UNI1unVGe5+dATPKwqvzn5qMTGO/KWXz61FQg0lU9doommEFo4+mT+ktFBfRTYnveFNpzwj0HHjhXSPbH9vcvwLiqxiYD2Eq8vggc8P7NiKdmj0aK2ipKVcgIhDmeWugYuIlp+PxCTuhKdoDeJHFAlR50bnLHcpTAqpxFpdL0aTHIPGvFAbmMI2H8gd8omyeWXi2HQvjzxibnt/rYhBzW0CQVOqUaXix70oYoJLLTYJiuiwGrHvNjeFGjlPUfMaCqmr4QbN1lcsb2fIO5WNrc8Mh1mfE0OkCi9xGrXxrhT3xJNLrpjLwIW2+4MAshKUU8e4+A7iYDfRwO5vV5s5TI8wB4FWi9151LOZn01n3NL5Hb3d9/bNxL8dqTYmZwFvpwaFaNdm4IbRZtOFb/V9qMsYB+a/KBfhvsTAwwXxTFoggK3Al+auvW8gtxjJlDG6z/dNW8RxJuY2g7CVsEmOwHsSzQZi76G78Eg4Yu0mW8q67xavOVmkXCqWHBML+7PQEwH3y60ASSJMTh+YDx9fcxeV+0qxEk0Sr7OpBi9zVscBrNjmC68S22vJOXguU7IIxwZPjHRkIfEyAANOXEH0ExxvOTjGEoYq9ryCuKo7FwvjfGTTeAEepxyJygEjuWuWb6RdMeAkZ7/snedWWABMBVw3POJvP2N7UcR15WvyuC20xJCzi0f1fcLgzHpprCspAS+9+GLvk1PWaZlfNyVUbhw7Fn7Zuxoly6Am0vzF8+YMR4EfF83ZlVXuvPKzSHaSLQlLTm
 Y7OSmSVI
 hvfpxIKjfZG3kHE7ynK1rW0wVNnSCdUY7IYaOAA7OPUSFbq9lwD3UQnxT9lKK9JiDDdjaaVJLmdV+OWCsOHDEfzB+9pBDj0nuP38T9/cZJEl3akZI0hkEeubA2MA5sCZYIVZFDAuYPHPJ9IfsOgATxTzUxvoauTBbCn5BNJQARgb3MDBNZr1rtNSnvKQKF3ZSspponXwna/pwBuKECVHSBIuxgYd070WX+CjJPtWmpBYcAz1vyCTnGL6idIG8uu2ePsXm4B1HQd44GKCnKuxQrY8PHdshDigv1enor8xmsuQyXLwP5blMmZxTkzXB3Mnxo9X1f2Rbh2lkyPPwpSXM9D5mh0wXCi/2bUyKJJDW3Sz43cpdx92HDdCl/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When we are reclaiming inodes which have I_METADATA_WRITEBACK set, we
have to callback into the filesystem to write out any dirty metadata
associated with the inode since we are going to loose track of it. This
will require IO and is problematic from memory reclaim paths. Defer
reclaim of inodes with I_METADATA_WRITEBACK set.

Reported-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4ffafb101718..760c730f4a9f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1083,7 +1083,8 @@ long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 				     inode_lru_isolate, &freeable);
 
 	list_for_each_entry_safe(inode, tmp, &freeable, i_lru) {
-		if (inode_state_read_once(inode) & I_DEFER_RECLAIM) {
+		if (inode_state_read_once(inode) &
+				(I_DEFER_RECLAIM | I_METADATA_WRITEBACK)) {
 			deferred++;
 			continue;
 		}
-- 
2.53.0


