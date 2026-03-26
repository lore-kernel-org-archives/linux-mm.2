Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEC76106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911436B0095; Thu, 26 Mar 2026 05:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D88B6B009D; Thu, 26 Mar 2026 05:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5E26B009F; Thu, 26 Mar 2026 05:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3826B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4C0713C127
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:12 +0000 (UTC)
X-FDA: 84587756064.22.19D98E3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C81014000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rh5Eaj77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YSIeS9QD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rh5Eaj77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YSIeS9QD;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rh5Eaj77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YSIeS9QD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rh5Eaj77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YSIeS9QD;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518910; a=rsa-sha256;
	cv=none;
	b=MbLr2n9mj1kQkmAB0k4AbgxNdyTyAHgb21ztP1IVB+GG6FGeAl5ifGipdX1O5qy1PuFLDF
	p6P0ss4VY/BqEEJm+C5mKYllz8AgZoDQilZtCIYNw98yNO5b5Z9IxYgfC5f8jXDCVusWCL
	akIc95NKzB8m37zoDjt3RZQCUr7M4dQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=cYTYKb+zboCCQirB6WlYpiW05psvL12gDlI82Nw26TdFDMEQeBvcTGmTMGIthddpjRDQGj
	wEu4BJR7aZEuwbUEPa5JXl5OZWEBFkMuFEfGCnLuYp19j6OPzD9NT8+hOHBG5TOoiS//6N
	S26sUaL0E2/zibMLKYpuoNjBqClMMik=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DD2E4D27B;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=rh5Eaj77oQMPRiCLJ27mNVcvqUb37MkyHlC4EAMpSUdiblxNrs/QUGj2c5/bWGDj+HCWi0
	DFLoLc0s3JY0fp76QJ2Mn3p6ua5Hr26i5+ACKpHaODucvmA1fiTnYon1vIvCttZPShywdN
	EvQC6SnRzKgm4fztTgCKCsMcGfs3mlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=YSIeS9QDstfnr9EM6xN2LdfYnda8RgQRKcnWfVqYRxhxdPxMGfULB/G5JR9BBPuIP/JDYm
	7pniZbkkzYhSZyAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=rh5Eaj77oQMPRiCLJ27mNVcvqUb37MkyHlC4EAMpSUdiblxNrs/QUGj2c5/bWGDj+HCWi0
	DFLoLc0s3JY0fp76QJ2Mn3p6ua5Hr26i5+ACKpHaODucvmA1fiTnYon1vIvCttZPShywdN
	EvQC6SnRzKgm4fztTgCKCsMcGfs3mlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=YSIeS9QDstfnr9EM6xN2LdfYnda8RgQRKcnWfVqYRxhxdPxMGfULB/G5JR9BBPuIP/JDYm
	7pniZbkkzYhSZyAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B9334A0AA;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ruXTAnECxWm2YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AF625A0B6A; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH 08/42] fs: Remove inode lock from __generic_file_fsync()
Date: Thu, 26 Mar 2026 10:54:02 +0100
Message-ID: <20260326095354.16340-50-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1587; i=jack@suse.cz; h=from:subject; bh=6btBYXD3CG8Zu0REp7+lJBoMAR4l7z61k8aJXBh/SdI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI4aXoWg6sS4/RklZ4gga8GPc3ktWNdpYKXn klIuUDC3cqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCOAAKCRCcnaoHP2RA 2fJiB/9Qd50NWkp9GGrCACr+k41/RaoDpO8qA8DdAMYeUWbk85BUas6rlqOAJOtSjVoc4DKmuD8 E0d7wAHaX+xEnMhfXMFYCgpKvNTWMSNPAyKmw1DwiBZ8119AR0Z2qzXmA6/qUHFYuqZ1pr9wB/C 9zmvOyT0O7ChITVb7sRzBEl19tOLbrQJL2JWjucy2DEQ0bFahd8nXH4nhn4BVyiRhegMIyaaBsI /xkreng6fLOrvK0uGR6O58gPYfe/ly9cWfuDXW8WVwoqnI5O4/ldEzkRlXYRLiAWEkQmk/oeqen l1c6vinH7j/3ohOVzxVrcyErD8PO/TxCEeW/p+2a3636aqEG
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C81014000A
X-Stat-Signature: 1pzkjaqgouus36wtywfe5fk3aggf6czc
X-Rspam-User: 
X-HE-Tag: 1774518910-158251
X-HE-Meta: U2FsdGVkX18SF8H3wtur/7pWAmZRpVOY/RMrx9GBsb9SJ/iOoWYCQh78fZX5JwQF+xdDM4ZJu2v+0o1O7V5M/OoUvQfI/XkHsPXfzTNxghKWo+HO64FJp9e4UAXZCYzArWS25Cww6S4p7vrcYdBvWvQJ+xCMYjSaBBYSdlTr+tbNG+9Z/eCHu+TJeu1sRWv36lgv960wFzW1L1JwJClG9SGlWWEpM3kyHchbE1yExMwLU16xT9uoUxzUY86zB/lxQdv4hJjuj4UQUwwRetQ8spnAzLT23wSyXsLbm7x8M3MkWNcABLcMjjZ8Ew9JniqYASK9d+IhFK7SjjaS8kpnQqHuf/FmGfgJuM5GkaxY2lDYeEOPJjgk5My3065V0wop3ZT4nHGPVWdz0VRf+qr7gX/nuw5qLlG2EjbveVHbbt2Rr29RndMJFCkL8dfJJTvydACIJj2wXPVx3IXhuOqoDUzyk3EYvkYuLDVLCyJgcKKgbEhYvdrvvFfCJRlGfs15z2EVpRnpEO4JTQfFa7GBKVPYrxCZE08X35vjB+7AUj0NhTz4rXwVeyxyAk1tGor21XlOYng+H79BryEU7hjKYsSUx+TVepXWexfy8jVyX66wPrJGGLuZ0qKXqDwuflhy3rWiWgQi1Nl+4uj4PI+zqI9KBthjT7Pd48nbYXx0cljKAe5OwD/f0OvMuMWnDD9MUwTcS9O+aWzRk10wHSblN4ZMzxpqG8504SReCJn5Xurz5JWQEgqGhAjnNXzAEwvPSYwIdQ3j/EyJq4t/to5zVLGB+xVqcbwpvBWvVYg9HR7hm6pDDsFiSME1ZgfSiLL0JJ5RAZaHkMOGGtm+vdG7Sze3qZWSXakvAGF4b30EsXrlXPOffJxuXPRXgbDLgdbIPNnajaDbdO/u2Ex2xSYGKD1s6RQtTiDF/md1p/ANgqy/LCYWd06C4cVuQySFkEmOJc9RKBZRXVVI6FEbh+W
 gdYpv3Ja
 8kEVldDrrV1/xS0hvSHciGMFS4RGyg4+LwBdUmogxSt85azU65NO8RuyjavHbeciifHAzKLbKKEU0l4JXeGUmn7pvrM2SOQoX/MWtFSC9jd1lzidzv7sXmcSDWscRSoZDI7Edv1Rq/wqpTgtLE+6joa8yTklqVCgup7Hcxg8rYhTCPaD25pzKmNb72fFtgCA+RtBKkevyQh8NAR9kHsMFPohTYZPunK5PLZR1MqBT+zCc1FSjDS8WnGll6aG2/9cVfr9xQbTrL7+Y/5vEP5USN7DWBwetsLECA38RgTBfZffP8Bmkuv+PUIV11fq+tKCKqpQv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inode lock in __generic_file_fsync() protects sync_mapping_buffers() and
sync_inode_metadata() calls. Neither sync_mapping_buffers() nor
sync_inode_metadata() themselves need the protection by inode_lock and
both metadata buffer head writeback and inode writeback can happen
without inode lock (either in case of background writeback or sync(2)
calls). The only protection inode_lock can possibly provide is that
write(2) or other inode modifying calls cannot happen in the middle of
bh+inode writeout and thus result in writeout of inconsistent metadata.
However if writes and fsyncs race, background writeback can submit
inconsistent metadata just after fsync completed even with inode_lock
protecting fsync so this seems moot as well. So let's remove the
apparently pointless inode_lock protection.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/libfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 74134ba2e8d1..ed7242d614fe 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1561,7 +1561,6 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 	if (err)
 		return err;
 
-	inode_lock(inode);
 	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
@@ -1573,7 +1572,6 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 		ret = err;
 
 out:
-	inode_unlock(inode);
 	/* check and advance again to catch errors after syncing out buffers */
 	err = file_check_and_advance_wb_err(file);
 	if (ret == 0)
-- 
2.51.0


