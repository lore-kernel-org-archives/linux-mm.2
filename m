Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3B7C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4096B00BE; Wed,  2 Sep 2026 09:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FE16B00E4; Wed,  2 Sep 2026 09:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10C76B00E5; Wed,  2 Sep 2026 09:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC7A46B00E3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:37:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B61F11A021B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:37:25 +0000 (UTC)
X-FDA: 85168924050.19.863CA23
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 912A1A0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:37:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qes4nSDh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PaBkU7UX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AUMI1Rv+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="dHID/5p+";
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788356243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=5uyJ3DvqzPQvEAteCBrVIXfcuY4SSSJK9mgbjFt94RM0+pM7wyQ4KHjbbWsnGzw1E3vY2/
	BAvWomu6nAZpgfI7FQ7VMgjAwpB+h+AtBdrNSByJcv016p/WkGm5Th+eWbvtYL3Zb+sEcA
	3tVwoWZFP27GYp3RlYXepR0qupfN4Po=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788356243;
	b=fSIKc04KDAJ/ZEdi1J7AQO8IH9MiS00GwyY6rydh7UV0MrBqfEM0k6lPNAXQCZXDe/Evgz
	t/vWgYx0+v+3TEdt5v+KmsC5BTtRgIq0Wz0vWnFpT8+9LZ7IEoub/7UN1LbVnDJGa93SWm
	0erZOyJgJr/qL1qvA3QliNlJiIB3WBI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qes4nSDh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PaBkU7UX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AUMI1Rv+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="dHID/5p+";
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A5A111F812;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=Qes4nSDhi4/dx18qt3AzuZ5PGjpqZCEPpSygx9STBmo/n6gzEVMcsBtOuRArBB0dZ0yaWA
	KWzFgVCoP4aml3FELHOlVZW85gIzvsohnBL7ZnqQDiYyzgwoKz6p90Y36XWiwh1IICLyNt
	wc4tRBv0m+f0baP2cnXeOFZpYRr2r2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=PaBkU7UXikcmdgoAM00pkcVWN6VDuODksj8653GHtQVg631jOHu5ZHmaitN8T2HUKuowP/
	qeMNX9PKd9kLFgAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=AUMI1Rv+nMkeEtleUUW7GBFMnM7qoojm8BrRwoNRyTiLkyuyLqXxVosomuY+SfKI0HDzc7
	QJ1oIMFXzme0TDJTf3g94ZloHVs41L5q1nojDBJBidU9E9DpvoQ0TTFRk23Cl8+T5+I/l/
	TVigrSrd3NGLi9MY2BnYDXhlHC4JqiU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=dHID/5p+rTjM6PZzoKEBRakN3cve5wq9jOjijj63XdesT0FeqGHuNONDTQPDXVcmWHwsDL
	ZALOCitqPbtFErAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D82713738;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V07oEokmmGrBYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 13:37:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BEE48A1315; Wed, 02 Sep 2026 15:37:08 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ocfs2: Refuse to enable ocfs2 format for another filesystem
Date: Wed,  2 Sep 2026 15:36:59 +0200
Message-ID: <20260902133702.1313635-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260902132458.23590-1-jack@suse.cz>
References: <20260902132458.23590-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1149; i=jack@suse.cz; h=from:subject; bh=eXTdW3jlEgvo3+fRkqFJjMu0ZDxZwxAjzXoYPvG1T7M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmCZ+FzI04LF+pOrfTGNavGesx/qjDrqPtxMsB RhMY5Cka/CJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapgmfgAKCRCcnaoHP2RA 2TeIB/4uXjrpYBo3JbyvmS+RnmkgSX8EW5LfRWVxuJDr87VFxl40ALxmgrt1V60e/hJ4o8Tg/E4 XanwRM9nZEjC2e4f9KY4a1gqUFO63L3t0euRzfTgana469tJX7a+RWlZ4pK0tjLSpmCaD7O3frm Virpy8R2LQ9IXjc3W7e2zZxYd2KA5lP57AXMCjJaXVu6V0ahP2kXahkxZAqegOjfyse6TQ8hSzc j8Rra2XDzz6rGJaOxSIB8hYy+OO5zFSuwQtc4pyL4VqzGZ/Pqmy37AoPPMZd/vvThorCOpnSrG0 7a2gceKaf7MdUP3Jz0Fu1L9cBVNGfbSMWRmtvfDTA7yXd66T
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y3ta8mxaiafeutm7dunobfjs7nnhu7h9
X-Rspamd-Queue-Id: 912A1A0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788356243-554029
X-HE-Meta: U2FsdGVkX184kn6Gas+pjGXcnQrqu6NFlT5JbcTA0IP8yjNoAEHAbhgTDOYfu84C50rFAXnwL3bM22xN0x4YQTKlI4Ut9/20sA9EZUa122eo7WQZuOJwSx6Fli1t/5lcxs4Fan9w0QKzXx93IdEK5Zqwsf2NJ+MJdiY9DEbiUY0GjJS3y4TREW9A37Xxz95VBA6ma/nZOmvhOeG7UT/Z8Ig/afLabfFiuBZO6McWLK8ktvroPeRXg4P1L+Gyv4La1KadXbRaWXA2r3m+8wEsFoGo1ni5vtlaOP98WcF034WSFbdNDEkL6mh9WAj4U6CThJl8g8SnS5wlXcsOqHTb5HyQ/F/KvlgCdAyRDjD3GTht0QKDyiu5jgY9waETKwHaw1ldBAYk/25t6Ri6hmHPQU+DaJ46LFRhK7sIx9b7HFcbSlzn4tgXF9Vh/Z/EZDJkAXvYOH0hDU2pxs3jP5q4hIQAcvp/D+EePq3jvasatASoZ5qp2BlQjKkh03Xz/VyljWVLzKOvh+cWIOkT8OmgqX4gYZPIEFKuBqzzrhnlsEgEVpKBlKhjVl802je2bNC/nRBKEImJjPG9TPHTPKUvD+dVeWmBFBpl0fj3kFkz3JECvXrEL/Y30Uy7AMKqhrpBl0rN4raptq3Tzs7VlI2qw9juwQxqiAbSpj6ubDHLe9Kwr/rezbyvmzTQCr7HyBfd9pThOwuq6ZBaRAh2ZfmxUT86WFHfWG+U0ouCNFkk6ZiuOcBScYzepOckhqwSM/sPtU4mUVKvIkzthoUTaD4FiMReHqpGQRi0T++d/Aw3Z1UjJrKc/98eKEiV2Wb5DSZYxNqNqsnTU3DwF/s+CHKIGOs8xmKhKOUrkaf1I3jzuCjFmqiwkOUUm/t8R8HBjEEdPckf0e38TVdhEaz8yVjQbon//otnkMTv8s8RLsqhZ+zrBM8G81iyov8r646kyzN6d/BR4ssIsrWU3OBuLWM
 Iunq5li/
 seODPVNtMxq+iOg2h+YWdk5/xLmw0ybAdO+PEghA773Ch+dx2XqacXmIpZ6psn8dztMnE8V81nt7lqMEcEC3eMBN3ICJl1mjbcx33JcM1zh33IyyY+UYnE2MCUcTnqXGT7Xlp4JMxaXhUyJSl04U/FFlBe5HClnHTGNXhqHvGcztYFHZ5Mzis1mSq2Khy9JNeZ0/z+y+84z1KukZogftMLIwB0Oy1ZXi6wVl5AO3hgflS/iY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
requesting to enable quota using ocfs2 quota format. With suitable
passed arguments this can get upto ocfs2_local_check_quota_file() where
the passed superblock is from the ext4 filesystem and that can cause all
sorts of interesting things, most likely crashes. As ocfs2 quotas are
specific to ocfs2 filesystem, verify we are indeed enabling quotas
there.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..97dee8ee6096 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -171,6 +171,10 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
 	struct ocfs2_disk_dqheader *dqhead;
 	int status, ret = 0;
 
+	/* OCFS2 quota format is supported only for OCFS2 filesystems */
+	if (strcmp(sb->s_type->name, "ocfs2"))
+		goto out_err;
+
 	/* First check whether we understand local quota file */
 	status = ocfs2_read_quota_block(linode, 0, &bh);
 	if (status) {
-- 
2.51.0


