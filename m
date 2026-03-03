Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D594EC1427
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1086B6B010D; Tue,  3 Mar 2026 05:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E3C6B0111; Tue,  3 Mar 2026 05:35:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70FD6B0112; Tue,  3 Mar 2026 05:35:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B18EB6B010D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EAA71603C8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:28 +0000 (UTC)
X-FDA: 84504395136.25.5724117
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B21AA000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IyxM68nNvs6W1tkLhsP9rSNWRbix4An/a7eSO0fcpzQ=;
	b=F8qJUBmuEJIJfnXtSYs8v1ExI1r0dRpJPvIzzPncIROGr6tCKm3KWXGQIk3Wzyj5kfFZWS
	fQxiqvO4aLPElKcDrd4Jd7BlYynXNDGK2OiPTjQXVe/NN1EID56pD7vdSA7cdQhciA278I
	TjdbeSsiqO/HsxkonEODJN629b6cAeI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534126; a=rsa-sha256;
	cv=none;
	b=JZFGKnZfN4CNcgPTIv++9/oKHtJSGiwRmbQDU9XCSpJmXmC5TtJHBn+MCM6SPkjtBt9wF5
	WtF9mpRUCkXWA2PJ1QCijMYQ4yG9cAwW4r8XCaxOljJ0PJcz6fv5JdSp+5xzoSPtmMXaK4
	tBr4gsDhhMa81d7UEMnyCaCsrUKVV0Y=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 418C45BE1F;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36CFE3EA72;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yetfDUW5pmmJFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F1C39A0B6F; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Subject: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers() call
Date: Tue,  3 Mar 2026 11:34:10 +0100
Message-ID: <20260303103406.4355-53-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=770; i=jack@suse.cz; h=from:subject; bh=3fS727Sb8yeAInT3qAHa47xqfXMgVJWE1jEhMxa+cYI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkwJU3tlp7qhclMR8b60WNVwl6KQfH0b4J9W fbr3SYqlOSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5MAAKCRCcnaoHP2RA 2YGNB/9OtFONbI9Bdr4PTwp7ci11Ixyrcxo+4xa9vhga1M2zpXPU3KkCu8UO/upLo+dFr9HUlB0 +kKObJC/FbgyeLsW6UWXlC1Fx5tecqMuui+e/tFgBlyJOo7+YR154CW2HAEf9VHdnl0fl4Qfq65 F4452cYAKGDuYhVEXjWGXBo6qZkDfoYrZqnHDzh10/V2JW9Ne5UESOZBB/x2fvraPE2nT7IvDof O45WqMxEA5x//n/dQH4WmLnAcAPPDMhara8Qzn2LfBXQG/SkPUX+dUsTZNPaE1A491y/fjic2a+ Z7GN9AvHjJ7mlTJ2WXHbI33uNIIykKvqRM7BWUbzU6r8l0Da
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B21AA000D
X-Rspamd-Server: rspam08
X-Stat-Signature: qo5jtajdyia1tnwrcy6jdxxnpksspno4
X-HE-Tag: 1772534126-188802
X-HE-Meta: U2FsdGVkX182fM8idDq6T/egq15kvKV2m1jWe5OZg7/tcoCQJe19ROnRZ356xkNTeXfufMp9atx5yEGwlyymw+iV/UDzGL75FjEyaGpZz8J2mSYMRekMOZC3L+MNEcTeCZZIS3979WGUkYJhq5u5iEkbB8JQ9MpnMHAgc9BZrx7zKQU0d/d7EWub0TdT4cjdvZTB6c9t8ijk+mdZRdrfCAfuTuuzejAjCqjMGNmWZFgZiJhtmFdFWijAI4aDo9Rwzhn1fnKyKfwpLn8R3QkXpfbx030CaPCYbK4BbirF4sIp/Br65tm+bDBD+mhCsLliGhwOJyF0SYnrDSzxnBalwt12fSQRWDSQxJ9pMxhDrh66V23dRKVNoOAAscUW2a/gbfWS6C2Vdg9z3jP0UX8Kn9w/RdY2l8+pBRAfPWG0Pzqlk2LRVg1ALF81vwmCUQToD2xXa8Qri/9S+hE7lwkEkJoOZV3anJ7b3sIz7VZiuSrUexA1ecX+7uT8LyteUOEcgS/NjgUhE2KPSGR8tUwKFX4hcNwhn8NHBmoZJHUFtO3vUYqspL10+Rmg1TXX+zjGyW98bgm6HF+mWsNl75vDB6ob7X/5Tm4ZHcgSfislP463L1ltFJ4DiTAl9A2qG7DpOvrMmWscP/ArTYn4i7/ZbljR0MsL9kgfivl9cL9IsGNGa84AJFk9yRAorCRNgbUH6loQe2FL95vPxtRzuVBFuIcozC5waN+a1Di+JXc3XjBmjejjBEQOsjAPYN4LgfkSfvXYaAXxVMtxwEIeoz8BBe3TEL5E6hUNWYna8iA2zVeWSAmEjtE1n40l6MuFhYHmV14ZGsnZWJTVC3EgRcBNTEiowwcGyknFoBOsRliZ8SpvSAwmyqj1IvFNEEV2kCF468ObsElND6+I0ubYeUJ4mOoaBIMq0AQw0N1flC3dz7AI5kH9Xj7JsUhKwxYOw9fJpePHKBulRFoLayIvvnN
 yMJwCzeE
 0ypE+PO7PiGbxXzZYeXHPpU+YfSsI/FLbQSpwntgo8aTh79NGb9rGPlCnNWp5czZAOzffu7G0yAXtxnT+QFsC0YxcAz93RcDAxsAFYQaS9hwR+P6Dr+RLAVQZSK55zmSKofL5iJ6I0Bs9ien6zRz9IOZE1SFC5lVRQI8txSdgv/77sygUP3ocE3PUmvTKXU2tAs5OCcV51WqIIVUTFsnyIwa9x6LIyynoimtt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody is calling mark_buffer_dirty_inode() with internal bdev inode and
it doesn't make sense for internal bdev inode to have any metadata
buffer heads. Just drop the pointless invalidate_mapping_buffers() call.

CC: Jens Axboe <axboe@kernel.dk>
CC: linux-block@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index ed022f8c48c7..ad1660b6b324 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -420,7 +420,6 @@ static void init_once(void *data)
 static void bdev_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages_final(&inode->i_data);
-	invalidate_inode_buffers(inode); /* is it needed here? */
 	clear_inode(inode);
 }
 
-- 
2.51.0


