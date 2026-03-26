Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 489DC106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62DB76B00AC; Thu, 26 Mar 2026 05:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F726B0098; Thu, 26 Mar 2026 05:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EDD6B00AC; Thu, 26 Mar 2026 05:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA886B0098
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB02C140C39
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:37 +0000 (UTC)
X-FDA: 84587757114.06.8216482
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DA291C000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KhtlkWiO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RPa8Up3P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KhtlkWiO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RPa8Up3P;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518935; a=rsa-sha256;
	cv=none;
	b=SqN+oeXvc/ybiJ5XkDtoWiF5wG+xvBEvPYRpqMadnwR1EZs1RD/j+f6u68pU8mIGuyw0XI
	FQR5O1076v605erX3FMMJQ2ojlKgx4Io181zLZzX+ANWYbgdBha3oIKACrtfC99/NBcBpT
	cCVEwb8rghNGxnLvfe/bIFMV7uN0prI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KhtlkWiO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RPa8Up3P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KhtlkWiO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RPa8Up3P;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=ef4z+6WWhVnZNWDC7fywmK+8wXqNabKXF8XnL0G2F4pu0xfL4uKMKywmpD57wYU9sjwh/v
	GYRHXFy4vv5np12FbhQv7QxqjkQEodNk8wEUlIHcPdBEJ8Qrmlh7K3mJsF3bfxJdLyriR+
	IvDIZqjGjhwl++iLs/3FxVL5WZI6wDM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 162F05BD90;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=KhtlkWiO78CCJ9mGJrt+U4aNIhhgZPPRQfPgmPwTj4qgyhwY5RT8DHONXFX8D6w/9XkBMK
	32PeTho+BOFRWhKnDofaCEPmEre8/NsuZw8oRVwL9jyu75CEJYOeApY7uRa9pc37TeiB7g
	qelr59wcfrX8hNnF5fIqkgrnSWKcxlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=RPa8Up3PdBsZgjkYN9RG5sVgNh0qSYmtretiLMFBxaF+DT+KG0OQMf3FaP+qlGtdEHT/uR
	QwquuxjWs/2ufQDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=KhtlkWiO78CCJ9mGJrt+U4aNIhhgZPPRQfPgmPwTj4qgyhwY5RT8DHONXFX8D6w/9XkBMK
	32PeTho+BOFRWhKnDofaCEPmEre8/NsuZw8oRVwL9jyu75CEJYOeApY7uRa9pc37TeiB7g
	qelr59wcfrX8hNnF5fIqkgrnSWKcxlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=RPa8Up3PdBsZgjkYN9RG5sVgNh0qSYmtretiLMFBxaF+DT+KG0OQMf3FaP+qlGtdEHT/uR
	QwquuxjWs/2ufQDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 061F04A0A7;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /WV9AXECxWmzYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A5B9BA0B68; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 07/42] exfat: Drop pointless invalidate_inode_buffers() call
Date: Thu, 26 Mar 2026 10:54:01 +0100
Message-ID: <20260326095354.16340-49-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=642; i=jack@suse.cz; h=from:subject; bh=nIoejJMaV49gDfeiiXcXv5LH7VzUz9A7WUS7gjGHtc8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI3asYuc/oVgtRi89eW1ehL7CYhut2nO3al3 BpSIY98L/yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNwAKCRCcnaoHP2RA 2QgJB/4vYwxu9hVC2NpAKjgJUN90wx+oO48gHyS3U27s/oLQBDHOcFkcXUy8vwEZDpU0Kk9P5dN YaiK28Fi/i6gurrd8aqe+1HKn91CVevrNkUE0Tj5ceLYwOvNXM0WA+kr5N2eQxVZ9xv7RTtQyX3 bZkFBdxitJb+CLqMtg1H0afc/BoCVEE20tRT1ZLpRK4V29Ur5Q/7ABFM5sWeQdiHK8l/duTb0kg oyHjrT4uD4k6GfDhR0Ye3dTMYHn4ucIonq1Tjob2BBKYEhKPhHc3Qtkiyx7H+rxeJgHvJdpNQzV HPbeW4POGDqiPg/KkYxrAj5YFMK8Wr5a4iSQQtST1594SpnW
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9DA291C000E
X-Stat-Signature: yecrcx9ffj78wmq47g8gukum3hd5ognk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774518935-821564
X-HE-Meta: U2FsdGVkX1+JcDgGAuDOo1ElpGKuy9uWPq0LgihyyKRjVmTUY9Jcx6kUf7jKM9ihArwOL11Ne+1c88KhqapsmjJW2pmHh19OrL1cUHdrw01nffNffN6On+S7dgGxBTja14Psk6aMwzGWrrmwpKTshFi8ZxEkl3RUQ3xlWJKS+uLUTFtb/bm2UEnN7ywIYX0QlobN5OVLz7EKo7opS2s6mV2e+GL9tn/2kO04Glc40BRczPz9y/O9/XPgqIrSiMqWEbWBR+RWP1qIa/75ggksY5vR1lfTXp6b8wV/FqYz8HmdadjiU0d1fHqeU2QIvvqRdUHDRvNqf+tb6ibXhCtjG8F07inn/uhiBsMFjjv1j+W880z7U/ubyXbZvlNIS2MSzHZQ+Rjj0TCRzY3mqAY4QasJg0kxdTJLihnJGuALqXK/6ciT/Lj5GVKFaAxcMCwpBrTxPZmZ/VJRhbqQRT0r2rWcgPUZadvTx5VzT/Ce0AOcjamrWBPF+Aju4qh6Nz/TFTo4a40cy/yAdMJ4+pY9VTEKSnxl9EbFZbFkSkmOAmWUTNuQJEzgWTm572bzYj2bhsMcsMewkMtuqv2974eiBNNYbTImdRnSbH0e+Q89BrIUpuPafqXGRhL8VBSNxssuydy7rBuHpmVvjRVIcXyIdgFYzc8mzzK/QJnfkdcy6vFFr2kq873wOshldRiSpheTfdTBoA5y0j7CppliUiOlzvHuMgHjbvyEpBlypkUsmPTg6ySmvhtsooRN9dBs7gCC77S4OXE4FMuQ7eL+QfUEpgswb0UhbC5rEERyovOGozdAhbxgnWIwMUiGoMFcigInNxJSMfRugl2/qLYow12TVvKA1oIkP74cX2XJlWs2nZ+Sb1aseaYRl0MLcwCZ8pewx8niDVbs3tB5cEC0ExgXlPKnjBGB23vjAw+DIfy5MdX+Wrw0nOm055wAsXCBuBX/gE+rJlopj7IsqAY0ylz
 mE85+JUb
 JaEuB4RvT9egpgNufPf55XcUA/K48rtjbVG6uI+hnNacqcbPdw8s01llwn1nOyQV/TxgR4J+117f3ZfBjkv86bGOKyq8MRJrM+VFzgSjT6XIDE+1I0JN9NMtkud+mO6an2ALFgs0PdBWAAyX38YC+gVBib7g1WkuNq6MbmHMK8X9B6g5eXV/DpaYVnB/u9bzIRkEVuroyC571I8n8pUlTEWIcwB1LftIqznG+PyPJS/EKoTARCckatPxWd3pZLYUU/Q6twXPgHWeDAnhwrWECxJs3m1JEX0yB6UifHDaYoiYMD4tU7889uhMlg0lVsnAs45jHMvRmnr8UgaOzUrooUujcJihuK5+bwvyTj/Z1UEH+AS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

EXFAT never calls mark_buffer_dirty_inode() and thus
invalidate_inode_buffers() never has anything to evict. Drop the
pointless call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/exfat/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 2fb2d2d5d503..04559b88482d 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -695,7 +695,6 @@ void exfat_evict_inode(struct inode *inode)
 		mutex_unlock(&EXFAT_SB(inode->i_sb)->s_lock);
 	}
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	exfat_cache_inval_inode(inode);
 	exfat_unhash_inode(inode);
-- 
2.51.0


