Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE2BE9A767
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F396B008C; Tue, 24 Mar 2026 06:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11CA6B0092; Tue, 24 Mar 2026 06:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B263C6B0095; Tue, 24 Mar 2026 06:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A152C6B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:53:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 493D1140A09
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:53:40 +0000 (UTC)
X-FDA: 84580645800.26.4FD845A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC8451C0007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:53:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HCyB0+Km;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9iFzn9ho;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ot6oNntE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JxJYfz7L;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774349618; a=rsa-sha256;
	cv=none;
	b=rXBCvvLJ9vqYBLOtrnn7Iid5Z76ymjLgtzgajhDO79rwXPqFtbBAe5JhHaXhJGYEBB1pHG
	w22l+ll9GxcYu/a3c3AJDU7Vao4zLMXXtmn0MPwpDb95U0JodKJ4I+NlmgPXmVJaWgtt9q
	QAeYKi23TWOZyKL8RccRsXKk0SQt5vM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HCyB0+Km;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9iFzn9ho;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ot6oNntE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JxJYfz7L;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774349618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAVSeq8dc1iph9UfoaG2fu/c5Pxc7sA0ywOlkLaoOUQ=;
	b=OH6FMIZQiwSvIDavF6JnAzTsHa7NjiUjegOtojtu/0dAGuXEFHtCbLMfEP0+lnuLB9wUL5
	Y+zJHLqwdV5g67FOAgG9nOMJLWG6JkQfNMAJo0dQE8Is+HX88aw4oaNzHCalvP2U6CGUc0
	qlGyytVWp5Cetsy1wbdSfNrquxohAWA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C68E95BCF5;
	Tue, 24 Mar 2026 10:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774349610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lAVSeq8dc1iph9UfoaG2fu/c5Pxc7sA0ywOlkLaoOUQ=;
	b=HCyB0+Kmn1cS7QwldEmeC22pEHLOieuUpa38YG3Gbpw9LH2PKqucVFyhLEST7Qcj24yQtW
	YVcD+JgEddMrGVcQW9ak+MA/IVkXqiWkl10NVOAoG8XZb6BaURTreWH+Fs8A+dLBrWx/N6
	CHK55UkWl7wf3fNnxYc8RJKZadkCjrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774349610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lAVSeq8dc1iph9UfoaG2fu/c5Pxc7sA0ywOlkLaoOUQ=;
	b=9iFzn9homkY3dK6aUS18DOWn6w+dcxM8Qeo7sDSOgU4y8EwWE9ZC7eHEWIGd6q+rjyDfQI
	wj9Ua3DbzZ3bAMCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774349608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lAVSeq8dc1iph9UfoaG2fu/c5Pxc7sA0ywOlkLaoOUQ=;
	b=Ot6oNntEoLlkRqTOhGZen79XcGAffkz6a8L95ex5du1oCI7wA59nIdlyqxVSZCPIkHwdyR
	UUhiU0tTd+EK0GLXlGFvbOB1FMhJJ1G/reakLfgsOeXkSXHZ9G6fzrMhA69qy7ah+gmuCE
	WK3iQ6zfQQJVMomDPv2LmFGbxSU7QiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774349608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lAVSeq8dc1iph9UfoaG2fu/c5Pxc7sA0ywOlkLaoOUQ=;
	b=JxJYfz7Lu5nUKEvB23F7x8nDbVQfwlNnvQBKEQr+U+bwjj4JXZ09cdFPY+2WwrshRZsP9q
	dvOKxuhTlGPSSdCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B510E43DD5;
	Tue, 24 Mar 2026 10:53:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /tUlLChtwmnRBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 10:53:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6E00EA0B51; Tue, 24 Mar 2026 11:53:20 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>,
	Jianzhou Zhao <luckd0g@163.com>
Subject: [PATCH v2 2/2] udf: Fix race between file type conversion and writeback
Date: Tue, 24 Mar 2026 11:53:13 +0100
Message-ID: <20260324105316.28684-4-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324105132.30490-1-jack@suse.cz>
References: <20260324105132.30490-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2896; i=jack@suse.cz; h=from:subject; bh=FEnadp6JO+MPzPP68/+c/BaboXtOcLDZRx6+8ZGnQJ0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpwm0dWUXMWHI7dLfXxTt3zkIlX3w9BF/wstDZ3 xLYtNfNl8eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacJtHQAKCRCcnaoHP2RA 2XvBCADdApQa0zeY6tEuXjNT35ZHplRx55Kg9iQdNAUP1vp0pRcEbibFdEbxoEV7Q9PSSTIVzQ0 HGZv10bJZwYwXxkT1RY/9Z3HXEAh5j9X7xYQPHYBnIV0PfVLMrb97veYC7vuCTd4MqTwhysLG8E ZUz/C9CuYBoWcFM3Q9qYClND989dYkdpEbDo2eGB6VAN9bgWK6U+YmoQT4pk3guC0TYKnUr2ASP bnISrs3WeXzOrnOjrzO8wlDFfKeTDCVpt+/c0jJNfOMRxGo9qWiGHyzCXoLdcKIXvrDsJCWrb2V 2aIF582ej66azaWJLxHmK3JRJQes8D2JFS68o5wKl3y/1cfy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC8451C0007
X-Stat-Signature: x9wibc8nien3mjm4kuooefrt1r4y4icb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774349617-763462
X-HE-Meta: U2FsdGVkX1/AYWg17KLe6SqaVenYVKq+D+LV3vbf1yCiv65vZzWxHn219TFZKv6XDgz9EuaJyR9DkcyvEQz/X4cUBTzlayHHL6sc7Ua5dVQn1wlv+2WY76p27pWSxrm+YnjzWvojjrG7YCkKWfakI7vrl52zvIOkBS4wzItsrtMeg4OO5UJjDb8l54F+Gdydvm22CmgCu3bbr+N8968FCyno2kHy9bKS+yo9JycqtVHDtC6AUQA86b0icsuC3e1ZccRDF15PQeIwGLkDCjK0W+sqZppa99ewkWUPV6KVHZcptztrNBB6FbvsOkwVSZKbuHe5oPP4mOxvOEhymCht4ZR23gnISQFYbuiy/r7+ynxY5yVWZZYirsVjnMK8qfOW6W/eFA1c48soTX1uebtZ+yzk9RHzU3fezOqQoCo2n7bx7YVhmCjszZpy1uqqEkpjgPU3d/PJ1WXSDeDI4HliXTHzF36dkNTOsZWP/Wy9CXiboWa3NNNigtpraAKYaEz6yU4OqpGMFcQIh/PTsgKogHoOAUVIabhTw6GZgMI7+22QZqRKvgN00u8dAB3EifR0fth4CZEWt1vr/Ri4hJbnMBgXQf0dyZaBOfmPu/2oNBPVMDuopIIQT4IhPmqWTp1QDqnwfMluj25GoG0nd146RR0kL+dchl7gy0B2vwwxSDM+oA8k6GxIRgQAG8DNtIrXITPNRJHKtXQtSE/AltnXOyWjvbebwNRiolvsdZ8rXeoT0roatPEII77hhNTKA4IiJN4AGEdJRGQmMhfoENeSg1it0iOoNjnHZhtqfElIpcuKAZyr5prtNuYXLLAI1TVZ5V+DtzgMqQ/cSwRyO+a26vw8gD9OCvgVWfgUnXenOQ3CndaD573KmoT9mYInw84Cef62eZnKYHJJna0jc5Qr06gD6QwNSSJk6+ioKnxxOLzzufd/Sa0a2dBhgFFJKtnJ5BooxW7Qn4wfkmrn5x0
 vWnMME1B
 JWIlodWKf1GGgdV88m8gz3BWT3v7xutxGEvcybsrGF8MDCzDTJAgzM/IMx1sOJWwxwv08tehcGUAjaiCg29qySQD/q6l63L0UjpdDfZlPpyeNMoAauo9UY24mn39fHuSzbllfDpwQiwBeLJPcy66466NQfsBh6OOI1NuzW85KAYBiDWFZ1snvcNWWM+HcmnA9m8gYaWWoV6NctZjkyLfY+JZbPZaTRhpnDaCSY4AGR9/xaP4iv7FGS5CkqK0NopNNGbBEOfzTXly9/fmHFrJTesHtxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

udf_setsize() can race with udf_writepages() as follows:

udf_setsize()			udf_writepages()
				  if (iinfo->i_alloc_type ==
						ICBTAG_FLAG_AD_IN_ICB)
  err = udf_expand_file_adinicb(inode);
  err = udf_extend_file(inode, newsize);
				    udf_adinicb_writepages()
				      memcpy_from_file_folio() - crash
					because inode size is too big.

Fix the problem by rechecking file type under folio lock in
udf_writepages() which properly serializes with
udf_expand_file_adinicb(). Since it is quite difficult to implement this
locking with current writeback_iter() logic, let's just opencode the
logic necessary to prepare (the only) folio the inode can have for
writeback.

Reported-by: Jianzhou Zhao <luckd0g@163.com>
Link: https://lore.kernel.org/all/f622c01.67ac.19cdbdd777d.Coremail.luckd0g@163.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7fae8002344a..a659cd7d7ec0 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -181,34 +181,38 @@ static void udf_write_failed(struct address_space *mapping, loff_t to)
 	}
 }
 
-static int udf_adinicb_writepages(struct address_space *mapping,
-		      struct writeback_control *wbc)
+static int udf_writepages(struct address_space *mapping,
+			  struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
 	struct udf_inode_info *iinfo = UDF_I(inode);
-	struct folio *folio = NULL;
-	int error = 0;
 
-	while ((folio = writeback_iter(mapping, wbc, folio, &error))) {
-		BUG_ON(!folio_test_locked(folio));
-		BUG_ON(folio->index != 0);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		struct folio *folio;
+
+		folio = filemap_lock_folio(mapping, 0);
+		if (IS_ERR(folio))
+			return 0;
+		/*
+		 * Recheck inode type under folio lock when we are protected
+		 * against udf_expand_file_adinicb(). Bail to standard writeback
+		 * path if file got expanded.
+		 */
+		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
+			folio_unlock(folio);
+			goto mpage_writeback;
+		}
+		if (folio_prepare_writeback(mapping, wbc, folio)) {
+			folio_unlock(folio);
+			return 0;
+		}
 		memcpy_from_file_folio(iinfo->i_data + iinfo->i_lenEAttr, folio,
 				0, i_size_read(inode));
 		folio_unlock(folio);
+		mark_inode_dirty(inode);
+		return 0;
 	}
-
-	mark_inode_dirty(inode);
-	return 0;
-}
-
-static int udf_writepages(struct address_space *mapping,
-			  struct writeback_control *wbc)
-{
-	struct inode *inode = mapping->host;
-	struct udf_inode_info *iinfo = UDF_I(inode);
-
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-		return udf_adinicb_writepages(mapping, wbc);
+mpage_writeback:
 	return mpage_writepages(mapping, wbc, udf_get_block_wb);
 }
 
-- 
2.51.0


