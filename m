Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B3A1098785
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE0D6B008C; Fri, 20 Mar 2026 09:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786206B0088; Fri, 20 Mar 2026 09:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C73F6B0088; Fri, 20 Mar 2026 09:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 204FF6B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:41:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D32A789944
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:48 +0000 (UTC)
X-FDA: 84566554296.14.E70115B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 87375C0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="KM7Pfj0/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/OeKw6R";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=bZa/sXmqPTMb7rHptT8GHWq0bDyu9KTC+7vivxzkqj9MyigkjVUXlBYYLrCFqD5upEFWk9
	IUblUkHkeDJrjAffCksCf7RBcDwTpQUD5uUS1kd8Y3F686b2/xJrgk165S2nMd3aRk/I1S
	/OEYQtSBVibCtP0VeGYSDZ1b/xnpLAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014106; a=rsa-sha256;
	cv=none;
	b=ysK5Ww6xnLpSpeQPyk4adrqF0nBhd+GTZN6BNUJIy3vTdirq9ZW7ALj8l025WzuyNpQS67
	6kHaC4DqPR3jOkMrv178vo7N4gnOYkUbIbZNu5Sfpwm89cd6fC8t4dHGjHUgx2/7tye2Vh
	rAp2cEp3BSes+Wu/aHDxSixpIMDJITU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="KM7Pfj0/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/OeKw6R";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C10664D1FD;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=KM7Pfj0/x/z0cqPdYoaC0FfqdagK0BcoinjF4KQYPLcEYBCnukDjIVlCEBO9JJOGGnYihW
	D26ukT1LO8QsQbhN5LITcNzS4EnMBnWP8NO2V1ePm6j/eRhpaSSTrauBd3oWkisR9K17an
	7TeUD247LjHyi7Ck7VGZOz9mE+QBDvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=k/OeKw6RRCiMkf07Td2inHX9Rhej3W+yrmVKMJP8AijrW9jbrYad8Wnb3gn0gepOkYsIkO
	tezPrhUBv7c4CGBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AED464281B;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RBdUKphOvWlECQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 60A80A0AFD; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	gfs2@lists.linux.dev
Subject: [PATCH 02/41] gfs2: Don't zero i_private_data
Date: Fri, 20 Mar 2026 14:40:57 +0100
Message-ID: <20260320134100.20731-43-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=757; i=jack@suse.cz; h=from:subject; bh=zt6HPqIyrGTBlI6V+0Dr/XGCbljb9VrDeuE5lHdQnrA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5t9QDNvNUEpIhcooLLBbuSbDnT3nLUxpPES BJ6DFZlrM2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1ObQAKCRCcnaoHP2RA 2YO6CAC1QjGsiVbGWR49r9Gc5PDE77TBzLQ1nn76UyxV7YDC0GXdhh/dRP7krJYNUltHXz6QS42 1SGtvIZ2eSmgIvFa6nD2Fl/96OVrwA6bGhTIwuzT5ut6YQneZZxMSaewidPP3Y3k4Skx0cToUuk cTYGfVjK7PFw/J4ecyxoUq4mtYn3Rx6d88V1dNEMdEeMq/PQ0ST/NvwhJNSXUXWJ5io9UugmtMl EViwvNz8HhVdsEUyywn6pu8/9DW9UFSQEafgqh4x9WDEyb4U5ArXHI/r1QJP+b4zG9Aq+7LhZAD 9ghuoUtRkfw5GZzSyEMygzQPxvD+P6dBh/7lgoQl1rQiTPvP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87375C0002
X-Stat-Signature: dpo89q9ndwahpe3nyueymsd5y1xw3pou
X-Rspam-User: 
X-HE-Tag: 1774014106-396256
X-HE-Meta: U2FsdGVkX1/V2tTphT4s0upmQMKg9HG4/1CV35fKdG0QO86TUabzwlp00SyHTUpBtifi6YSJq3ytR/TVwuDHR4d+Q2vEoMiqdUzNBkPVCSx/ME9bQlAXWidS43FAS4tVtdDWsCUHIc8qlZEPjyrY0q8iz5gP2wmR+pUzjXHDVqme60FtzXEkBwkLIkVzqNIxmXllevEPNVEWsdA14O6brhDm3Z3q4E8Vx2Hw/CV2nzum1T6hmwGo4xGmNWUBCar0JLO1M+EzwJ5p6kvrG4+HWoaS56BbV0y18etnsx7LI1c7VK9AHhmHWbvH3jvr6jquKMev3nD5BtGq64BWtL8UhEVQAzJvuZy2rWxI1F88IWnILr86GoeeH4WDZa/ZK3JLjFq0zFZNnxKhHxuXO8ORV11gJAkp0eC/MHPJKWAp4+Hw5koFtMZO+YYvDnfyqbr0AOPhRh4+0lCN9aUFnKixoED8K9zL9JWx89qddTAW/Vo2uoXnMn+fs4eCG03ozjyf6AI31usZYK4PJXYhj5xdtsXhbwZgPp8VYJJ1pCO1ahK5jlLPwJ/Yps42uxcD1JZ3f2vHBnjWpQc9iULjwE2K5SOdbJ7BnpUsZCM3U0lbYsGU9ZmyZPVXwGNQBsNCDNW6AoPe7g+oh8p+c+4Kc2aB+0vdTqxmC0nubIjArCmxq5alFDKGFT3j1VgDOZ/hoHnVGikFieIVi094WokPqGdYdif68k3Y5MoSLAFaWexSDZQ9s242ZkQscLAbYdLZcKdttYVdkPGH50wZGcq13JJL7u8XA9ga4bKsdFvkk5oQjjSTsPyzYWTmmLIPw2raRjD4AgEdzoZqrnPgHORNsbmoK3rUZjCU/VtEqZ24Ny3Vw5U6bbPjIE6TkF2sgQ8B+gSdcZwWNaHSou/Zor4CtGdFPYw5Ya6K/txeQRHNJavDX25azH7Eif5J8uD/pGi966wf+wGaAqHVSsy9xKrprr5
 qyC2o5cR
 v3vHnjDsh7lA2H7Il0+UV1tU3FjgMqdMHNLrwO512wr7/okJdWonw/ntpGNQwFAL/mZf6k1mfzTMTyJkpIdMLNcwFE3hbmrMkg81kctxmYIvI9lVkZKRHo66Hk558STljzYK6n3SrI1IjDjlilm1rZ+zMFaZ5KqnnEANGmpjrbdEhwNnskAlxUE9HatsYi2MnalM1A9CMtu+EIUFjvC0UuVofgfb2sRaQanHaSSzXMGyTK+9Jwo0LHaat26s0VRDbu0uFnWW/OsJeoUQHBmPXmrwPx1iOE0N/cwJknE7ue9EQsgqPyVR/u6thBjNdRv57zDTKoWkVVlsm85zEIsvK0G8z4mPHAnTw1PKoiX0HTplJnS4SSkSr6kAvAM3niszf1wrJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the explicit zeroing of mapping->i_private_data since this
field is no longer used.

CC: Andreas Gruenbacher <agruenba@redhat.com>
CC: gfs2@lists.linux.dev
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/glock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2acbabccc8ad..b8a144d3a73b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1149,7 +1149,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		mapping->flags = 0;
 		gfp_mask = mapping_gfp_mask(sdp->sd_inode->i_mapping);
 		mapping_set_gfp_mask(mapping, gfp_mask);
-		mapping->i_private_data = NULL;
 		mapping->writeback_index = 0;
 	}
 
-- 
2.51.0


