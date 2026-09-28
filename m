Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD663CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8CA6B0088; Mon, 28 Sep 2026 17:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B895B6B0092; Mon, 28 Sep 2026 17:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAF26B0088; Mon, 28 Sep 2026 17:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3466B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52644A0339
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:15 +0000 (UTC)
X-FDA: 85264469430.15.7DC4B7B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3120120005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rEU0ai8L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dVKd4DNZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rEU0ai8L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dVKd4DNZ;
	spf=pass (imf13.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790631133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=7Uit1JUJvljp2c4WxOuoLB6dGk9GR4jSCthwZkDypMR2A04JINwiPbdPuCeEDgtHy3ewpW
	il4MrEEngnGoCB83+I+FS4v9CB1ibpS77vGYcgqN0nsyLutnRom/qSpToXDhw7kZ72D/d1
	BzLAK7UjxSzr5wK5YjDXbjbReURgplA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790631133;
	b=vuTHaacGnW+MsIu52/b7sGtTLuLp8F9FW57d4KETawq9tezJzcZLUmhpySohkAYO4XunxO
	V3IPLdnlJtSSYsObB2y5zt3pk67YqMUqiKsmXt2tZSnNDnWCwltrsMcA7Mhs2BZ/xPIQzM
	awARnOJTTBpQSATlGUgR5bgESReLD/Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rEU0ai8L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dVKd4DNZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rEU0ai8L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dVKd4DNZ;
	spf=pass (imf13.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D6961F7B8;
	Mon, 28 Sep 2026 21:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790631127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=rEU0ai8LGFM25EG+Y+s1TttWWZGb17L+bIKt5K9DuZXFB26heWLS/VnzsNKyyLMcj6rILD
	jZ6/sj7whA2vf5A5DszizPhpkx5QyNu1V4CrQ6MEVy2VV/dWbXpfIPbqJIfTI2KwbSy/xr
	n4Y4VDspksNKAGczDTgw50bcbpTM/Gc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790631127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=dVKd4DNZkFZJnQtj7/2O/bgaM9Jexu4l9O8/19TecRXs0WVhJZfVUBxyqaNby2K6/04rpF
	JRxg7t7/wdwwtuBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790631127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=rEU0ai8LGFM25EG+Y+s1TttWWZGb17L+bIKt5K9DuZXFB26heWLS/VnzsNKyyLMcj6rILD
	jZ6/sj7whA2vf5A5DszizPhpkx5QyNu1V4CrQ6MEVy2VV/dWbXpfIPbqJIfTI2KwbSy/xr
	n4Y4VDspksNKAGczDTgw50bcbpTM/Gc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790631127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=dVKd4DNZkFZJnQtj7/2O/bgaM9Jexu4l9O8/19TecRXs0WVhJZfVUBxyqaNby2K6/04rpF
	JRxg7t7/wdwwtuBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C98141340F;
	Mon, 28 Sep 2026 21:32:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e7PoHtbcumqWMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:06 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Hugh Dickins <hughd@google.com>,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	linux-ext4@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] shmem: Report casefold setting in mount options
Date: Mon, 28 Sep 2026 17:31:52 -0400
Message-ID: <20260928213155.2612039-2-krisman@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928213155.2612039-1-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jbmu4xaamopzc1dpjiw4h9ugqytaiur5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3120120005
X-HE-Tag: 1790631133-535167
X-HE-Meta: U2FsdGVkX1+JsDcEui6TxLjdSIOHs2KYcJVD/qDDx31AAf1pODPvIoEVVt97603cE1csatPXoQ7wWsmX9Pei8NaQZb36pf20QerWL4ZSnW+FA9S/nB5S3p5+E+AtpEFNLbLM2ykW4AIvqvxVOexTwJcFY53SuMrppkUlyaE2E+hDjsDN+G4FZyAkO6ghNFDF6LoKCorcyvgvPYXPvnAUWZ+9oLmD4l5NqNaX6EvT1towNk6ws2SAY7w3aORyQymBKprfOfiPR6wKYd/W/XgDQX71M3oRSrPYKtgUYh+5iVmDY/cbWSWmrT2sf1KETAKFv3BxUXxhVIsTIj/27m/zKzD4f5ahXGqxRYrWak3lL7ahqgVxD2OATDdxw9FdXO09tkEmnkOqgV7IHazK253uWaqGFMZDmmGzFe547tzw1VKg5+Psf2Ach7bjEL4iGJgPa5+7y9ScbWjwxCjbKQiad0//4z3TwVn6rky3dkLj2JOOltfyYipMrny78QAkJSUuCvRGxus8T8AcVjUXuLJWsz/RwQhpii5k0Q2z0sExBuEN7ue6Q7tLKG3RNyGyeAoPXuuQFjOhjJyFuexpg55YqCrTeqCE5roF5ajUYpKrZ4r18AYsQ7tLiwQp4L86ERt85KEXqSZL0ObX4OzLG7bs7DDewxb4wZ+xMwgist28qsV+OYCO9jB9oM68w54PGyf99dq/mXGWJqfQlshTywgjZ+IaO/xS548wxqXiHtNGj9Y0yR6v4GTRxSRX+H1psZ09HcXw2lt84enCj/pUqoL3j+p29m8T+t9R6xWY+EwHPpjgvqi9hlAGFUAvyVQuZz0f/zy/s9qOETbpSmSkJmkWSzP6M9cWV5N8DJFn9NRz2L3Msn4znpMgXNhsaFMlRj0aslgq5z4frrkJBJsmgV/svif9y4sqxmJ1kpbpP7wCwA9vex49C+kNoVbN1zhZsoY80CIJVxg8kQeRLvIqA0m
 lvTf4kVe
 Hxf/HhMUkLjCc6wT+JpLKDIWrzdb9z45rM14ux5mdsmutT/exwh2hnTJk/cV6JZRiivlH2mvmN81eXIdWB2Frq9c7oRYOvSDoepXGjjr6ltzfueJ+vAI2X5touXDk+gNbkB1R9Iq2yuSdJXXCsptXUn1yUWEsKtPK1Hjmabp8KVBdBrG7Om4UN2FAtbSJjsV6FnuiiswUZpiyCyJ/9yu5uP4wxRLgxMxYyzwFvR6IKqdieeNt4XRlmUR+mEmhznOIf7fH+gBaTPc4sZPKJr8Ky8O0UUauJon6MITeEdTlHiZg0WZ3wDlHUpBH/9+Hy7xeocb+3u0ILolXup9zkFLdLw6+ibdp7TEco6IbpAYF5h6ju+qZhW0RTRM6dHo/tkJ/pC2O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For shmem, casefolding is a mount option.  Report the current encoding
and casefolding flags in /proc/mounts, so userspace can easily check if
casefolding is supported withour relying on parsing dmesg or trying to
set +F.

Reported-by: Daniel Tang <danielzgtg.opensource@gmail.com>
Link: https://lore.kernel.org/linux-fsdevel/5193732.31r3eYUQgx@daniel-desktop3/#R
Assisted-by: LLM
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 mm/shmem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..2b93fcbf5127 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4916,6 +4916,17 @@ static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 	if (sbinfo->qlimits.grpquota_ihardlimit)
 		seq_printf(seq, ",grpquota_inode_hardlimit=%lld",
 			   sbinfo->qlimits.grpquota_ihardlimit);
+#endif
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (root->d_sb->s_encoding) {
+		unsigned int version = root->d_sb->s_encoding->version;
+
+		seq_printf(seq, ",casefold=utf8-%u.%u.%u",
+			   unicode_major(version), unicode_minor(version),
+			   unicode_rev(version));
+		if (sb_has_strict_encoding(root->d_sb))
+			seq_puts(seq, ",strict_encoding");
+	}
 #endif
 	return 0;
 }
-- 
2.55.0


