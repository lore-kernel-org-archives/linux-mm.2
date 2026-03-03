Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CE1EC1428
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A10E6B00F1; Tue,  3 Mar 2026 05:34:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427AF6B00F0; Tue,  3 Mar 2026 05:34:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2096B00EA; Tue,  3 Mar 2026 05:34:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6E186B00EA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:34:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A0AE1403F7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:50 +0000 (UTC)
X-FDA: 84504393540.23.61468A1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46503140007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fw+0oMZq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CiCDkVK6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fw+0oMZq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CiCDkVK6;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=ofkScbgiHBSedLEhb8LDgK0tjpyDNdPg7T7GfFAy99Y3+yiHlXiOz6qxvr3+d3LwLI7lv1
	I/z2S6W2GE+8ecNOjsjdO0bdKQK9CheGPXwV9tCZB9ljjNuwDKHYOf+cwxSBkVPSnYfPDh
	nJiMoW+X+bj+rH3IYiMdFX6jo1rfbec=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fw+0oMZq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CiCDkVK6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fw+0oMZq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CiCDkVK6;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534088; a=rsa-sha256;
	cv=none;
	b=3ys+4S+ouC+OHJs4Gj106tkD9RUgoLlZ0xWym2DxarHkzgeo8gntSi8Dnt4dOJYTEr2+Wa
	xoAwrhvN/Gn6mNs3u8UQzrsdnhqNVRgJsbAqa7bpCTqi7OYle+f3vwtiS1QssLIgPDW25E
	xLLGJGygcpZ/z50YPLQrnzd99M/qtwg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ACC1E3F8F7;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=Fw+0oMZqVkipusMgayet83Kf0iXrioLZGXfcKkWBNkrJnfPHODsyLIb1ALMidfrGbSLnTL
	2jGVkQMJ0EG/3g5zfQoHQYg1ZqC9mZgIOOCLhsSRfFQ2CW1TgJiLeD8cZa+WwADBr/LMys
	JT3t8ctBxmDlASa30q5NwQRM8n3PNxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=CiCDkVK6Tkh0AN+fCa1HsW0mAlBxQcakiCVfxFR2c6dBxTlJxP7VNURvZq7AhNcAO5vYk4
	7mOJ8O08/ppC6xCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=Fw+0oMZqVkipusMgayet83Kf0iXrioLZGXfcKkWBNkrJnfPHODsyLIb1ALMidfrGbSLnTL
	2jGVkQMJ0EG/3g5zfQoHQYg1ZqC9mZgIOOCLhsSRfFQ2CW1TgJiLeD8cZa+WwADBr/LMys
	JT3t8ctBxmDlASa30q5NwQRM8n3PNxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=CiCDkVK6Tkh0AN+fCa1HsW0mAlBxQcakiCVfxFR2c6dBxTlJxP7VNURvZq7AhNcAO5vYk4
	7mOJ8O08/ppC6xCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D0CE3EA6C;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0LerJUC5pmnFFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5EA2DA0ADA; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 03/32] minix: Sync and invalidate metadata buffers from minix_evict_inode()
Date: Tue,  3 Mar 2026 11:33:52 +0100
Message-ID: <20260303103406.4355-35-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=796; i=jack@suse.cz; h=from:subject; bh=S1BAqXV/Jqi4FmJijCh+slBc7/Xi7wKphfEUon5Scy0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkg8bYqxZ3+JTUWtvnp18qagzJO877Mdw6cB sfHYzZzTaWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5IAAKCRCcnaoHP2RA 2epKB/9mFaykJrZpS5Y8yDL/oFlGtxGZcgQ3TVgzivnk+90jI8mxaj+5s9lXw/cLXqpKuBtmNPw bF7sdI7n0RLewMVkc66adiQiPXrDaggmlqMMcy+vOP8MeWev18gnP5p3pz4JF/LfnVu12OEqLVs Wrt4LGSfsvUnxPT5ffv9DPF84RgfrUlimuqyywZhjMH37pqwIiRifXyqT1g9gbltdo9aTCeWeJO xU2PxRyQSRMsVPeMPUSI+BcKcT5FhKU3hQGSq3pvtTSJ6Lji0lipOZ4jrKjxCKyncv5FhPQgExr mQwiH4DthC1SR+JbO+BNFFdnsYltdSdMSyhTcQnetKcsaxKF
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 46503140007
X-Rspamd-Server: rspam08
X-Stat-Signature: xuyxhpi9a356zwq6a57pmfuxpmmcpd51
X-HE-Tag: 1772534088-888119
X-HE-Meta: U2FsdGVkX1/8we41A6Qwt70c9vHas9XApXyNgyawPlAqyV8hikyKHG6Eg6aI5PuTpjqwD9ITXKsRj0W7xxuETpbv/Q3v9QfNvE+YCu/oJszhJodag2t0YAFeKawy0rOVIwlwPDnkBtjf+WoYtPvyv/mxs0fOMYEwjNjoNm5Zsqn7GGfyQ4q6xlIIxpYwxhqGhNyn7sHeMzPHrpNyNj4reFxwk43ZrKfYb8qWnhBGmqvD+0517ZBkyxviBkCXKyWzbuIyFpopgdxXWcLjR3Xjw8EarSdPxr+Ivv2XcVppZJqoHxDT0k9Pt5KizLFwFnswSm2Ttvq5VV/4UzqP9PSAAbpautO7vZuHLoyDyg0KMBwJUaBKWvK+qVd3udnWJibGuooID+acepIfT1bwGIgRfqIqPE6wln+csr+vtU7h0ohzOXbEQN0uctBxTQR68K0OHvHmGjdOVBemHymmlgotmSA2KpulcpOLRQM+0O/Gtz9uqQZxRPviTU9Zo6EhgPvxZTKVODB9C5D64wbNkagWhs4ziqpJhOo6+SpzrSwigbY2qHZeGVZpkYPk01GEI3gN3XggqvFDvDRvzC8OPAQBHOiayCZaSZ6HweTT3zf6yig6O9/ehZfVaWDDJmSuO1fSHwSYGmkGdgVmR4sjrZW6kzs8k0KkoVApUYBA41uVASvprabByhm5NhL5x4GEwps0ks3qwXQ+0z0byR5l5OHsLe3dDSIN2ldId1Q1WYOJlF0F3nrE/MFLolejV8zVzoTA5Hkf62F+moREFu6DD291qtR4mwRL6XW6UgP+aWFyAKav+wXcSrF2M6rTFM5nyYclF+OTZw5kc929VsWzU5gtg9BLwsX48OKFp82wdY4bM/k122hcvBcTkeX7o9Szp2hyJPfNwyRmzJ3lso3VSjSagy1yLamFtShV12peCXuhQU2Ue2pFmcy0eFi/GLGhDs9RV5xrYZrf/YD1rVNgGXO
 I22Hd4RJ
 l2JcEib8Klp7uFp1DPeCXicxkdmGZAT5nbiNhObB/M46tJ8kuC1Sw4faYohkoi3viTpjhl1SMWyXYhD8qO7rDw29nJFiPwc53pJo6A42t0mP6CFBBeujPDHHsWO+p25HH/7xaly28SojB/mcl/qD/27HckH++rUEvFDQvCH0ZNypgx4Of05tpHC/rD1htPsN+o7wfHhJbWpSobM0WYC5Df/UtzPJ2eDJ5/fJPkktGXqCyRneIGmsoZ00yEI/R7x2K2hzLeMGA1KxhQNU85QAdk3FJhXYRI1EhIZpd+ePAL14BOgyAPL/vadLV0QwCXB9e656Q5+fxzAxrMGZNHaTKkLKivA14rMXPVLBq+IZwNUDkxI8=
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
 fs/minix/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 99541c6a5bbf..ab7c06efb139 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -48,6 +48,8 @@ static void minix_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		minix_truncate(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
2.51.0


