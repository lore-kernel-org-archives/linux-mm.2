Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D47D106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67DF16B0005; Thu, 26 Mar 2026 05:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629F06B008C; Thu, 26 Mar 2026 05:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F45A6B0005; Thu, 26 Mar 2026 05:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 354726B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7A99C39C6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:00 +0000 (UTC)
X-FDA: 84587755560.23.23C3DAF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6C83C20005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:54:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ikIZO/va";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/A1kzg6";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ikIZO/va";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/A1kzg6";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=uUIdPkDkQwCs77VXBGUcsQZ+NtDxKux8J6hRTHyCFxd2gj/tPTqUA8XCK8AI+90+jJME+6
	2W1jNimtykfokQk4hNxlJwxVYfwu8qRl/qZun+ts9vAHxuME700r7vY1fXmCO78Gv57D63
	HeLVZMCqx0F5P0G2UUPtEQ9P9itU8V8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518898; a=rsa-sha256;
	cv=none;
	b=qoUMPO5kZ/5Py8mU0z6waIShUpQvgMTu5J7vxT2fvVW7slzfOoubojoTWV781JK+VkqyDz
	hmQWpfV1qeRd+wlcGCtulk11gF7OQkdZiCjgzjKWQd5XMY5WFE3bYpEB7POwZEggMVh9CU
	N8fhqF9xzYB6trZMnPTrNMV8BgcdSwc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ikIZO/va";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/A1kzg6";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ikIZO/va";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/A1kzg6";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C11645BCD5;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=ikIZO/vaU57PVncq9onK+AWlFRxS2Wllql55sHJuoKgxScAbjAiFTsw1D6cyAI0NOImVGB
	Ak98wk8ZPMqSiRuSeDu8eqxVL1qNcqID5gF3m2kvaZOWi5d80vtxboDRiFZP5WuopVVfE7
	iGcOMrm5JZszWQuYIzDGC9JqUj4Eu6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=H/A1kzg6niMWw63cLdurH1mVR8nYMYDANZnrwBKcPVcZEXFBF3TLrrkVFC/PZEwWp+fpZA
	qC8b8sx1+rk7FAAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=ikIZO/vaU57PVncq9onK+AWlFRxS2Wllql55sHJuoKgxScAbjAiFTsw1D6cyAI0NOImVGB
	Ak98wk8ZPMqSiRuSeDu8eqxVL1qNcqID5gF3m2kvaZOWi5d80vtxboDRiFZP5WuopVVfE7
	iGcOMrm5JZszWQuYIzDGC9JqUj4Eu6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=H/A1kzg6niMWw63cLdurH1mVR8nYMYDANZnrwBKcPVcZEXFBF3TLrrkVFC/PZEwWp+fpZA
	qC8b8sx1+rk7FAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B86B34A0A7;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YPkBLXACxWmhYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7B594A0B58; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 02/42] gfs2: Don't zero i_private_data
Date: Thu, 26 Mar 2026 10:53:56 +0100
Message-ID: <20260326095354.16340-44-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=757; i=jack@suse.cz; h=from:subject; bh=zt6HPqIyrGTBlI6V+0Dr/XGCbljb9VrDeuE5lHdQnrA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQIz9QDNvNUEpIhcooLLBbuSbDnT3nLUxpPES BJ6DFZlrM2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCMwAKCRCcnaoHP2RA 2Y1TCACgJjs/Rj5FUUtM8EfC8lTypcZwH8QH0u36IVm3yNSUP4LRuXWlbat6aqsYI7G7Xs7Mi0y XwlcOAbtxAWgP0xhT8MhWCSlbm1TBxma1C7+oXNtNN0Qyz94GBDelwZqbh8gokEAXH/T6q3ooP6 6Qbuug3VzwIn8W0bppX1q9Af7oQDl+OHDiycH1uNmgJTIAeicGumUA6OG5RpwVK/vxzSHQU8zEX Kd6LC4g2HAUlishCR2r/8aNGq/v3t7sb3WlrMNhiP0ZHdzSB5akmdDh9+guOCppxX+6noHqOAUa rvqhzBHansYERqqkK1Q4VBKoaYBhRdD0KDRjD/c+b5mi/aRy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C83C20005
X-Stat-Signature: 43drr1opsf4dso3ew3dhafku4c7r7rnt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774518898-13386
X-HE-Meta: U2FsdGVkX19q8T6TiMErBsH8/vDi+4LO7McpYwB4NXyquz9nUQO9j2IA9dReF1pjxjYPYdccNECF1mUWyr+x0cBhssMBrN+mRKDGITA9RulGRvTFTiLoRO0vWENcHSbSjVVe+CcNPhu6hf1x4XO600tTYycEqIvw35kMvWdJj05PdlyrdwqgawrifnQQo/2DmQgoEiRy12MgWnfq8pv8lXWw2Q0Rp1cOHW1pwC+UNkWJrx8N1yQgFolYbBc/g9CLvF475fPX5YijYlWT/UBKTo/cGpVv8Isxl2xlVIlU4zj3enBcHbCMCShm0UJ1Ip+PDCtZFgHb+y760IbNOx9y8JdyWzkclcNo9/xBbTBYFLqoSK42LC8qa3tuCjGrQT6YdylorTQlzlUbokBotjr8yYsU3XBYU497t/SM0qQ/SQFHU4+2Q2kyp/AfZIgP7mWOVo121SPq8dPBObo0Pb5uEi7n1vwqBCpdosCJSmPqsv7IQ78dBww3LHtXHanXmCc8cEUFEoGyVljbeAn5OqEmVJVOW5nOqM9KIIZNjtTJ7wqSuq6urf7S6zIJZ44NyvTPVT+vjKWhdlpjURL/o4ud+ksd8wmQtooaFk0z2tdSz3D8pQ4Sd9hivRQecjJvdeKw7Zg0Sqr8GpmfVkAcRZNeFRNNFqqs10G6FFOziFg1i8a4d4QjemeOmEuOyVhs8JJw6ZNS9nPD3s4K6x+bhKO7IiGJsoxSl52vo5YPFVL1hTZah6izttKhDlFe80JSHK/LIedDzpMwzU54neOF5oukt6h3AfJLV2Y0x85U1XXG0WvS+ixLaVrzBlRVgC76ahNcYH7rgdFaevG4dPX8gIw0dXRHC0wEjX1OmXqzhwl+4gDTbvwRAk87scgi6mnxa153BnIofMuSmDJIz0vtaef6iQCVuFOjWy32rV09XEPi70JylxdUlM5Kai2PqckdfT7CvRmSiGUkWiIbPPQZ3ac
 FhO7Hdm1
 U+sPgMndml8DWi5cI9Hh3D8rdG7eqj8hD431V3Juo39RApTA7lQhH5kddw+dtgR3BaL/3HV+8Yaksy/1uFNYvg8F/KNiv0wyW2FgGo+166GMAzSATfRDI24TyKcq0LX3gPY0vtngB9jR1r2s5/1KTa0d51EME45Z75REblLwdPVjilM9cFQj5Y0PQNFdvSTkIMZzs9WwXl+sDL8P10AJTmJ+eOOHIg9RWmGM7nvSboiXaw/epxz22lElTGMPSZhlq5RnR6K15MXTHRl7io2txGCu7/ePbTkXmWtpTt4MwRGGnedBYX1awiTlBSDGPj82bbuyMH/x7X/UsZHrx4wW6IDpyva5n5wHtQo4areLzGnShrXTY72mz3eT/RFNDgNH83pbf
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


