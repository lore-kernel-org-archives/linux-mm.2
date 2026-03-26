Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED536106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4812D6B00AF; Thu, 26 Mar 2026 05:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB606B00AE; Thu, 26 Mar 2026 05:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20DC86B00A9; Thu, 26 Mar 2026 05:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 048F66B00AC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1DD4E1177
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:37 +0000 (UTC)
X-FDA: 84587757114.30.38AA02F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 732FF180006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b9zz6GRf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ACJq3f/y";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b9zz6GRf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ACJq3f/y";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518935; a=rsa-sha256;
	cv=none;
	b=nH/g/l0P3TPTbEQvI9WM927M7fyMRk1IBLxP5qQ6hXT8ZFiq2uECXkMckx9qOz7xAJyvdU
	A0aSIhsI3kBc3ooxmjhNIQa+aJFjqoCljtk4XNDDx4CKTI/qiZ+0GYzQJZLOBuJiO7oNfz
	X0OZ15/RVEto+yuTiEH+o3cCsSX+JUg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b9zz6GRf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ACJq3f/y";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b9zz6GRf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ACJq3f/y";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=BshMvJE0YtbNHh/NqJaVc8RXUlq3oKAf4Uw1noJsDXnHgw72wIGWUN8eFi7xQwUUWAalTf
	QkIQUQSoXXc89TF1K6rAuEt1lDzpgQyBenEI6r8HbcWBPONTrNYh3TFoQIQkX449meRlKa
	lvTG0sHzT0gFwCowKvxbSt0l0PoDJxQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2AE8E4D27E;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=b9zz6GRfVCNVqQGAYY7IBdLkHWhziCBTDByTqiIj4068J1wlAxo+xAXa80SVqqnVrxJnl5
	FjO9VzT/DtPukVelpwLsVKqZFu6LSIuBldvbHMiRaa9IRF/0nKEJoafs8bXMpuN2B1TGwz
	1laAbPyuqYGtB00ubyZh75tRSQUX/BA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=ACJq3f/yLxALp47vcAd3MVVEb09Z9xMYOND0AgBiJSGCqS7mXdecs7bWVqz61suo6j/Jhd
	KnXJxKmm1kuKIyDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=b9zz6GRfVCNVqQGAYY7IBdLkHWhziCBTDByTqiIj4068J1wlAxo+xAXa80SVqqnVrxJnl5
	FjO9VzT/DtPukVelpwLsVKqZFu6LSIuBldvbHMiRaa9IRF/0nKEJoafs8bXMpuN2B1TGwz
	1laAbPyuqYGtB00ubyZh75tRSQUX/BA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=ACJq3f/yLxALp47vcAd3MVVEb09Z9xMYOND0AgBiJSGCqS7mXdecs7bWVqz61suo6j/Jhd
	KnXJxKmm1kuKIyDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 208534A0AD;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5EvuB3ECxWnCYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D2D6FA0B93; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 12/42] fat: Switch to generic_buffers_fsync_noflush()
Date: Thu, 26 Mar 2026 10:54:06 +0100
Message-ID: <20260326095354.16340-54-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=791; i=jack@suse.cz; h=from:subject; bh=U+QxL7wMLUiVGEqv4r+69y8nwApPUSkF7ragwmMCpxc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI83OE2n0S6FtaeH8MKk0RkmPh3Lrjg5K+f/ cKvhEmuGmuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPAAKCRCcnaoHP2RA 2ZsbCADarW7XvadGiIAZYSWa8IZjt98iS79mXZEfh0M6NqRgcuEznw5jt20L/ith6GTrN/h8ols 7inIXn/VOOXKWA1f4Tkj0GPTzua8OfsA2042BV3urwdTILeaq6NkXzblC85p7MXp7HYhDG0h8Ya GMH2rrIrnTlnieRt9ycfTfD5qpeNO/gxw1LHMEHIPABmiZQAsRRdnDWF2BO7yNJ9ZyJjTQ7vegt DjgqUoZq89prIUTnTCFiXMap5T1DHvn5Si1OpgyQOxf2Pu662rU9URkm2xGu4US3/3Y2w8pm/13 AvkJzXFpLT2fftbY+g1gEpmz1xKsGB3Iqcn1drupcIdK8VUL
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: 3fauphrpwyeyycwodj6d87ecmc3rboru
X-Rspamd-Queue-Id: 732FF180006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774518935-16946
X-HE-Meta: U2FsdGVkX18C+KofwRrsFXh3UU3Nm+wEVOmEEiiOCZIot8DhQjtit1M00J6MsKFhbEDWSCFcK4fQzn7AR/JRXa2nqlPEvHy39HqRL2mpe40PqWnISExY7T7XZXo0JnbV3VxzeoqeIe8F+LLLAYoTeeud0bz7V9HzK1a5xSlptLVe8zQrei4jeUcS/e4ICfvP7DrCuDmfTjV9hrGEVswAUb3WtxDq5gW5bX822xN15VSF2RHRm8c7myznlZOf85crsMnLqCA0NPnA8zeUb8zNO2zWGHfYfctjwMclPycXZAQEQc81GRunsmERwaCpQc5B2MKDzjjHEeY2QqOorUHVRy4JMLZQ8OIzhFR2Ew6/b2INeUlPYtZ4BhkMMrgra0VEvzIo5u8OgJHac7bPxAn9Ub8C/cNjXJl8M8tXC40dZQ6EbHSOS5B/pvpiz155OrN9iYtxcYP02ZUb8pXQu52mdhyQ4sYWgnk/OqpvIWYzUSP71SQaGKPDvkvb78Sg9xNkT3DP6+uKqM08q5LOuAFp5vQdrOAFhQ7J1FD8vBJhRpmlroZgxU0SSNIp3wNE99rdysI+NnnbHyUwiP9G7TwkaVKgNMA4rDP0twJUrmE/+9U+HX1YRDSE5jD2ZTUL7lzUQUfc1OSL/9/0gqVsUGc0XBq8e8lI7rSdSR5YGo3fE0QfBevfoGLQIMPd9wsl8pF8frMMn6A0fE6qbt3Xagu86hB4JfgzHDRBqZsY3omSrwdnCimUt3SkbLm8SziFqTEkudpfv0iz+IolDTIhZmoRMvMau/zUuyU2tpH6uhh6yJtRa0vymDp+4IdRDHGHmY3pQJf20QJDlXzgqlA6rJQi0hztkDK+VAiMfvkavLs5IiWuycxzisKfhrK0SvLEP3zKJE9YDXNGcOSjWmshPeOCkqbtyvn3kEIPSU4KNHEHyq6S08aaiKEi5O10E0MSwptt23/EDR1njqcJctvphbM
 eBotjx0J
 F3m/Rd+YNUFcffSFRAqDkL7uk3gwj2YQajgRwaVebEjcE5uuH3D5bPoB8nAPW47LfhRdalHsDPTbgToBKuQ56JWpdfk2SITd8+E+IAmGI8x1MgSGn9yoZUTQYUgN9XzG7qURsf+LiHDonv25+a6ptTnJLXRKVX5/55a6kPcHRXmi227jyGZocOplVj5CDkFPRV1UPnmUID+L0sqdvthUpC6LBPQ4MdrSINy0RFX6l73lT4vu90EsXWQbhQjVZ+aVwg0/FGYsT4ZeHzy6vCXomukiWnV/Rv78aRKqov+t9qYqhqL6r6pHdiNP4Hwpjdsc6B2/mmVAYvvh7yLMDCGOLg9QKbfUCW8Gr7+lzHzMgH0CBxfj7xFpj9+r5HZdpTk/7CnWCxSvWq9jIfvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FAT uses a list of metadata bhs attached to an inode. Switch it to use
generic_buffers_fsync_noflush() instead of __generic_file_fsync() as
we'll be removing metadata bh handling from __generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 124d9c5431c8..1551065a7964 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -188,7 +188,7 @@ int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	struct inode *inode = filp->f_mapping->host;
 	int err;
 
-	err = __generic_file_fsync(filp, start, end, datasync);
+	err = generic_buffers_fsync_noflush(filp, start, end, datasync);
 	if (err)
 		return err;
 
-- 
2.51.0


