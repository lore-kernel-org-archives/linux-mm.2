Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33AE7EC1427
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254736B00FB; Tue,  3 Mar 2026 05:35:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215446B0100; Tue,  3 Mar 2026 05:35:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0CC6B00FD; Tue,  3 Mar 2026 05:35:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCC7D6B0100
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACAF7B9605
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:08 +0000 (UTC)
X-FDA: 84504394296.18.18C337C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6B2D8120004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sQWs6zGP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=662EpqO8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sQWs6zGP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=662EpqO8;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BrEbcwxHzsuw5/1iQnP6jk/azHihcilg6iUu/naUsg=;
	b=LCjbxWuNkJAn7aeUKp3zcNKzPAXklhiu6kB3+YWJKNYU1Cw7OakDm2tcnl/fQan9EsSTJh
	/HVy2Jugtnc1e6tMb0IpTyi722Xwf/CgxSJ4vNzVMufEM/cSsXJ54DWMOM+RFZOEXddILW
	yoyuxbJ0FcDmeiS5w5NMFl8tGEdVS68=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sQWs6zGP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=662EpqO8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sQWs6zGP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=662EpqO8;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534106; a=rsa-sha256;
	cv=none;
	b=Pu9pJX6JplAXe2PyS4ebVW24TNMo80JIiVfRnGgKPgu9+pww8esNWh1vkcMjEpi3cCCPON
	CRW/ASEge+vNoWPtEPQDlhUNwC27BpMmmeytUVC4VjauWEKELlItK+g0NaYNCp9oqfvj1Z
	++xvuaNZlq5cuZOetA/lLRicDJpATxU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E4A9C3F8F1;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BrEbcwxHzsuw5/1iQnP6jk/azHihcilg6iUu/naUsg=;
	b=sQWs6zGPYLXKaYf9cvr1oyKMK4RgMpnvEfedtkA5GV4fopa4whQfkn6EsrbAH7+/wBeGJL
	ZNaI8ZUJRCUiUkY2yq6ydwP8faMROvV3MX9MKXq0GnhmDiEgnAd89FFyivExEF9Xy57cDs
	Th+8QQdzaXioKukJiGLAcCKUtPky0as=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BrEbcwxHzsuw5/1iQnP6jk/azHihcilg6iUu/naUsg=;
	b=662EpqO8HHYWgaVUqeEtdELcTIeiD0t55bGUqR7mw5HjDCgqE0NJLZ78EE953OAgbNcgrx
	KiBo2dHpqmFDuDBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BrEbcwxHzsuw5/1iQnP6jk/azHihcilg6iUu/naUsg=;
	b=sQWs6zGPYLXKaYf9cvr1oyKMK4RgMpnvEfedtkA5GV4fopa4whQfkn6EsrbAH7+/wBeGJL
	ZNaI8ZUJRCUiUkY2yq6ydwP8faMROvV3MX9MKXq0GnhmDiEgnAd89FFyivExEF9Xy57cDs
	Th+8QQdzaXioKukJiGLAcCKUtPky0as=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BrEbcwxHzsuw5/1iQnP6jk/azHihcilg6iUu/naUsg=;
	b=662EpqO8HHYWgaVUqeEtdELcTIeiD0t55bGUqR7mw5HjDCgqE0NJLZ78EE953OAgbNcgrx
	KiBo2dHpqmFDuDBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7E5C3EA69;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DfutNES5pmlkFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6E7B7A0AFD; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 05/32] ext4: Sync and invalidate metadata buffers from ext4_evict_inode()
Date: Tue,  3 Mar 2026 11:33:54 +0100
Message-ID: <20260303103406.4355-37-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1415; i=jack@suse.cz; h=from:subject; bh=IGpn2U38477v+c6PsdjKXPDX/u4w8/iXEhPzBY2PBAQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkiwvoOz0rMEX/Q3fhsgA4Ot0pM7sp6flswL aWQHP6KuUWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5IgAKCRCcnaoHP2RA 2VnHCACqstiVFtyMN9RhMfncMO1Ev44P2kUvv/aYJoePCuTOIE+9vai6hetbUiwxr+tAZAaRqX4 TDkl2nwgsJ7fp92ylLb1+FFtpQTdkIzI6F7fVWcjJ0V0naqyZX2Mavnp5EOyZJBWP/1Yx0iy9eN KEMnlDQqNf2TmO9ocTFD4rxLgbJS3pIH7vmjGaxgEjCCmnHCl0bPiW5kkkKkF5oTYw8r9dCLx6Z P4Q87rkalL5TI5os2Nl1ncKmAo6HJHNurYSaUIeqgsIiSWNbSDCfEEjInh+EeZw3wsls88BREZn 7sxW20dAcaEUXrolKyv2VNzV5Mf/Nj1k6aiPk8n5PHGNS9a+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B2D8120004
X-Stat-Signature: 8huaijdeittz7hhmr7pn3p8h7qmcbpx7
X-Rspam-User: 
X-HE-Tag: 1772534106-687685
X-HE-Meta: U2FsdGVkX19MGG3uY7hZyWR4aDiRjhwqF6k6gz/ud0a/4Vc258zb/AhS79jSxSekTXQ0i3AQQa+tnU4CTzapCyzvlVvTdg8ASnt5699+z0/iT0xylhBDMtTxTer5ZD1pLdwr7JfbM9pftsqJQiKCYtMlgD/ViNI+e59K6oGu/oE7F+Mmmj/muCa0PZdkR1J9FoP61KPAih6aI+gLD/OdiEQp/KrukRtizG34/elNSiBxSxNtB5W1193fzvgcXxBKsp2EPcMJHHLr5NVKq1Tckhpr3zJdFYWSEJoJ3HOf/bdgAktjBM+meMwVSFUSRHSJMoThP895NCG6isiZNevvBWlDOHlidzw0NZzUglFRIRP/uyFEthbv1RYm+afB+8zvbk1a2AVnpntrffez1ddanl0sVAbu0AvbO52VFi9h/mORH7VMCEEv0eIb0fCRuZuZIH9V9FcVJqX4l3kLQ7LscOO0zAXJlNOMly9gjrCnm+hs2XHhtp9zzLhldA5b9LDS1xrjDjNvc1ITi1gLS7N+Ld6b71B5tW/OyUzNXeSoKTttiMb0rOWpxbewztdRmZd/lN5KJIlp+8aF9eNKiD+8Dql6Zw29SM32TWgYuGc++ZHRyUBUd447/zcVpTAuLsAvR+ybS6UlT2CfxJqvOfcEhJJc3Abj4ZbIynGMSCsFMccN05lR9K2POY9hkW0qRinMC0OSrspX4H6ky3gZnnJNcHEIAOjKhaLOw/RmfYp0/4lt7ZxA6xKNAzL5+xJZrcUOR5tvQj7gIlY9a5XDjRH9rA/i2nuYiK9VQKLT+xcGQAoMdvXO6E3p7csIQ1M4PgpqksNL/Me8mgDtEMB7ySerKxs62e51pIkyYb3gPXsernuu1p+WYpahnf/WL6PNxgUIwBtX0/AXn0ExjQwD/Snhs+WSS0Hqt9tHCm+7X2bB0Jgwdm1hmUWsSrKKpDfaGEh2a/2BWwQfoXibrj/laV5
 VBZnSHHp
 kuQb5GJYWolR+Z7BirBiLXk+044nKbIGfwb8Q++TsLk/9X9jkhhnPc92oF4gTihdiaZD1Ei5SFU6A+zCMY94TFPpoB7aB3DVSJUCNXyG9RYOj28cHG643uCBVlRKBRpFA0/uehY5B9E80fKILVd4MeV+Uk2kD0iLGLE7/lxcR9IdrlG/L9nF9frdIsRqxwC6PMe7hr86kzOqZnIkwm9SIH0tH9EAPjASUA5fBPVOeStYb/nz2R8EeDMOBnORFRq5EX/n1K/qmsnFknaj1713TeKd0nZawzX7qVg/cQ0vASZc/MhZjn+6sGRPK1zun5Ycn8lcJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 4 +++-
 fs/ext4/super.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 396dc3a5d16b..c2692b9c7123 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -185,7 +185,9 @@ void ext4_evict_inode(struct inode *inode)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
 		truncate_inode_pages_final(&inode->i_data);
-
+		/* Avoid mballoc special inode which has no proper iops */
+		if (!EXT4_SB(inode->i_sb)->s_journal)
+			sync_mapping_buffers(&inode->i_data);
 		goto no_delete;
 	}
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..ea827b0ecc8d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1524,7 +1524,8 @@ static void destroy_inodecache(void)
 void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
-	invalidate_inode_buffers(inode);
+	if (!EXT4_SB(inode->i_sb)->s_journal)
+		invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-- 
2.51.0


