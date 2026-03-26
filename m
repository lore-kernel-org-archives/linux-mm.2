Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A2BC106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1026B00C0; Thu, 26 Mar 2026 05:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C86A6B00C3; Thu, 26 Mar 2026 05:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3B26B00C5; Thu, 26 Mar 2026 05:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 37B566B00C0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06A0FC3A33
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:51 +0000 (UTC)
X-FDA: 84587757702.14.EA4FBAE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C2D240013
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0TRfXFFV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrKmUYBT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0TRfXFFV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrKmUYBT;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=1rtyoQ+fvPw8dQMSP7JxmjEEhoD77vHxMmlXFVtaQfbfTNgDW2JMTFyRlRV85m64nBXC6N
	iJxywojj/tAFheTobRmBSHdcLKLTL3IE7ufXKLKU5ohiQyWaZ3uByGg/MilR8oEk83Lz+G
	1s4YXuc3B0Q+/+44/ThBg5rkwBgS5jM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518948; a=rsa-sha256;
	cv=none;
	b=JdS9FdKQcoXINf8L3wz2JjgizDEnps84rAKKgXENzbXIkS9UJEr2Z2jM2x3pRahsYo6xxq
	p/3lXHMXNECRp1TAhgGryecYXYzP30JrQS7lC2N88o7IJwattV0K9hxt0ya47uJsYIAWuf
	/9zgfHAZ1ra7/qgg6ydfYnCl7/EiPVg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0TRfXFFV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrKmUYBT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0TRfXFFV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrKmUYBT;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4BFBD5BDA5;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=0TRfXFFViPXUkITOQz2GM0pGLNQqx2D5zKOiDGVE03I+NNSKkhRlTraClHIJiDR2DBMfz1
	k6dbjaROOamix8Dn8HPhiLAJ0DKb2zpzx0S5++G3Z36JsP3jqXSf6Hs7BlvmzRx7DjdEIR
	Y1eicNGp/yR75COyyspHqz0JGvniWvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=PrKmUYBTCWL2TCFcC2JIpDwkiDan7V+OZK8QM5HGBoPNJ+//GiVfh+qG+OQZm2MHX9b/FK
	ddQNdpiGdVH2QHBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=0TRfXFFViPXUkITOQz2GM0pGLNQqx2D5zKOiDGVE03I+NNSKkhRlTraClHIJiDR2DBMfz1
	k6dbjaROOamix8Dn8HPhiLAJ0DKb2zpzx0S5++G3Z36JsP3jqXSf6Hs7BlvmzRx7DjdEIR
	Y1eicNGp/yR75COyyspHqz0JGvniWvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=PrKmUYBTCWL2TCFcC2JIpDwkiDan7V+OZK8QM5HGBoPNJ+//GiVfh+qG+OQZm2MHX9b/FK
	ddQNdpiGdVH2QHBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 402524A0A6;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4OKhD3ECxWnLYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 046B2A0C59; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 16/42] udf: Sync and invalidate metadata buffers from udf_evict_inode()
Date: Thu, 26 Mar 2026 10:54:10 +0100
Message-ID: <20260326095354.16340-58-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=790; i=jack@suse.cz; h=from:subject; bh=MUD4hvw0kKK4/k9ZuBglb9Pnr5A53izwByukHuzgvfg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI/iH1edR4ShwUvYoFKD7qhhaBFBhSp0KWEX 3MdhTPWkEKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPwAKCRCcnaoHP2RA 2a4GB/sEoTazVYsOod3P+7Q7cHcOJ8li09u2SmfS9NMDOgvd7GUUyee0Amz/FogU2ivaPxMvJlz 8KjCnG+Vrw6P0Q5iWMfl9uT4DUjnYsiAZ9qT0otWDuNXi44425x4VvBWBqu25LLh1edJ1eOHAxZ EN8YuyEgOnmgDxNuFXCkfxaOwrFCsP5PgFykiZGe3ijNXDZ9YfJrUBs0oRpmvQ6EBvFEKPJPujv T8ZpmxS0YMIdFy+LdBFE7EF0JNNv6Ao1wT1qbk/WgAyQwT6RYcstoYle3mN8hjLFpvJ128g1Zdh B4irlh9r5tyPwpuDGEmY636MNurozBK/gF2amwNyKZa/BOQ/
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9C2D240013
X-Stat-Signature: kfpif6a7wyk1yzkurq1kabo61jrfajqa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774518948-217554
X-HE-Meta: U2FsdGVkX19vSdNmDJ1zmnqOQLQw237YSLsWmcI2IhYIFF9WKF4DWq1CLwZMJUjRyp7QFgrmJ5bzm/HHrCMrKFAZ/QBnMvuBW+gjZx+ETH+ZV9EPTpNcmbobm/GNgkojRFQ9OabvLBZ/oessZAs66Tmney5++Xp1GWszTewV2tXrBGQ5LMah/7Iz61iAFcgpk8Z3v9WvqT40xQ/ZwGMRWDSQd3zCMFJh16WXohKZGcAHgf6jq1VWa21BjkGEI50AlFp0YpEiRnaq5d2LCBmxqzDGsOU7Z4b/i98t1qHdZRJ/qGa6tFtPIkhxQ90dftnKfj7HhAnFgHkjlQ8OV98GfyTv13NzRbV4TsFTVSTldyZwY+aecOCLHhif7P2wvVBGeQVrs6+tmeGFJRluR5mY6VB3rwnW95xCkFHo+Brhia2yM2Zd4hUKbeqGkLV6n34Gpa1RwdS8OnVL86CtKWraGssmmkIXjGgVaD2q6c6ho8HUsI5sqye09d9f8uixHCaYXciRXM1i98cMM/1RRgoXTEv1maKLtqVeSJO9RYZrSjd2ThxXQOx0soGdLatsGmmCo5bSRxaugIBB9ScvuA8SInF1HvgzGG1HDU0FotPjaUq4YEzVVXjBXXWGsFEr8iGUB7HJOB9oVPSX1XABVxeAEnKkyjox/FxguY/0CSxpEBXVcqtjTVzP7M/fa8o9F3Dv1DDP1BDx8UeYiIbWPdVSPGv14bDbF9wBoLpVifVWSkkN4O8KUCJTaR0fz1EDyXFcPvIDa4LZ5E12MYK5MCxtS8XeRBPNfULJLAF0sBOKHya9pBSqgEU1Gqefa/g0Hzl21qOPiWRbW5Zr2HFFj2Ri2CLzzq6Z5qAkqOPiUTNVi5nxfu9EEzGL5sGmPpo6t5tqGBvgyDMCc3NRYfK2xolmozmUYJsrUc7cUMw1OB6jdNsaCVXWE4WvuhIrA7CoQ6DFMDEZIdJZNEPy7l5tnKI
 Np397Tgk
 jj91f/x2SG0XSfF6RrVK2YK4ZDtwFcYGY6SuxO3fKaoOXDnS5SozqEVRO9OqHe2AAhkzId4SpKQUErpnR9yAKTDoJgZcy606CI83PlU9kJuRa5Kp5i3MV2Hm3I/Ty/IriulAZpnXaRBOwu13WCfIKjJ1r6Qjegg/YvLVZunCZh0V8GdkItOErZ5OF7YXY6rrr3oqQ0xzyxooqQ5PGGIuuP8k3rMJTH3MngK2qJo8uU+N+WZDv9wXK+TEZz4vRRqTgxzFsd/WYEYwa0jjQ0K/MZEkhmT5USDnD6blDygPHOqQn9R5fELCYlXLjnn+bXbzc8Eiy1J75GokWNEtjDuCRa4Uw6SM34R4rAqhTnRrSCIDUyGw=
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
 fs/udf/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7fae8002344a..739b190ca4e9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -154,6 +154,8 @@ void udf_evict_inode(struct inode *inode)
 		}
 	}
 	truncate_inode_pages_final(&inode->i_data);
+	if (!want_delete)
+		sync_mapping_buffers(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	kfree(iinfo->i_data);
-- 
2.51.0


