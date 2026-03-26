Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9C0106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F04D6B0099; Thu, 26 Mar 2026 05:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C5C6B009E; Thu, 26 Mar 2026 05:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394086B0088; Thu, 26 Mar 2026 05:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FDD06B0099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8257E0F6D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:12 +0000 (UTC)
X-FDA: 84587756064.20.DAE9D1A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FE88140003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fg5zz6iJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oJbDjkUK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tgBitcH7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GUNWPU2V;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=ujN0vWocMcJvmDtO2RMyrQlB6WlUeTh0hR5wloZsNCkOQSMN+WiyIDL5bnWyaJZigAqLjo
	dCk8VMlIR9RpJJEP/A+k1VsvxJ+5ybGphmxzkss/tYeQh/0Jj66GCvd1DmHEVDnjBWIeJk
	DWF7qvF1o5ZO4qhPG3JHscxerdelzBo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fg5zz6iJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oJbDjkUK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tgBitcH7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GUNWPU2V;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518910; a=rsa-sha256;
	cv=none;
	b=My1A2QR5gOmUrFHiU02aqZ2eD/Ha5o7/YN5xVQhnnnhSAz9+CF0E1xVAvyw0aDwnbElLFa
	wLJtIRC44K0j+ItFBVZI96ooDfEghzOudOvdi4speAZipbFjo+iS4yKtA44iNsBUtSPOKi
	T3aAYd3EvLqgx40Pvik9pdMWpcGeXbw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CE6985BD0A;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=Fg5zz6iJmRyHEh6qiH7+5WHnTRYylyOrE3kQl1PIQrb56ytIj+OgztDjLZOjnhjq4Q5yvU
	4UY7PfrTk1dhtKlab7u48fTsbNcIMy7P1/1a7I6z0YbAaQ9YkxM1y55sTVoIsmdNcTA3Hd
	VgIp8AG7Dk2jE5gDAVxrJj3WRZA/n3E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=oJbDjkUK0z7SNcPYL20kKpL5l+AAfiXMXUQH5y2dSO6KUN3N4MSxc8G+pdEBzaRGOrVTVt
	A+hsUAYOb776TlCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=tgBitcH7FdYoLfFpSjYftDRezmc3Lz836aO+H9qsVbpCAAAvIcd2GW8hfxZ6tu/JR1ybCb
	hlK/zV51kNZ7mQcRvXLe2gsZ2SeD9WrA+5ULaOVmXqlnHyFJeKZvOMfx7U42ZYZTgjJFvv
	PXBqVtfRAzH/GGFd770ZQEa/SM96CZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=GUNWPU2VmtfcnaXljrOqeEIMf2EsQqP3kks6SkQ82vTLD+rSSSPM/46ZN6Ar0q35ycIx7i
	fo8sg0OsLiiVo2DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BED6B4A0A8;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E/eQLnACxWmiYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 82CFAA0B5E; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	ntfs3@lists.linux.dev
Subject: [PATCH 03/42] ntfs3: Drop pointless sync_mapping_buffers() and invalidate_inode_buffers() calls
Date: Thu, 26 Mar 2026 10:53:57 +0100
Message-ID: <20260326095354.16340-45-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1214; i=jack@suse.cz; h=from:subject; bh=P6pO8hqSDzDiUMeN+vj6yYZXJszgs6S2wwGl0XVS/3g=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI0HEq4UQTZ1UrVhvgG+EYydxO1nRyNYrdsA +FUT3YdJO+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNAAKCRCcnaoHP2RA 2dHAB/0RMeWEePefP/TbmZY2WRYlfAyvOWDAUTFwJJGUTfii5CnecrOoG2HOl9Y7eZmiLuS7dXW VImegHi6JlrloqSQWBXc5xhjHbDmWgC/lK8hprruEjr5qkPZfaLYJ9IcDMWx7d6ACLjXRfChOw6 3+5A+UsimFNqezMkcpJLjAnpVLz5wkOaBXY/5vfSAGZxqHYg7SfEUio58YuHSudrGxsoEzx5yRR 0/uFG5hGTQmQv1k6khrglQ28AQ8RHvA4WDqAjt+Eha9cBci+Iq3hXA5zAHIHZPCFRgSxKG4kTd/ GDsq4cgIb0wnof8VmkgFan/qKGlhbDK84k0boDDDj+9tkJyV
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: q5wfec6d7fxys6md4x3opkg8swkecba8
X-Rspamd-Queue-Id: 8FE88140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774518910-500298
X-HE-Meta: U2FsdGVkX1/SWxmGQxFS7gB9mpAmDGqDU/oIdO7NuRw4qnlotnLLU4ST/RDQFoB+IyXkfeWbOLmkDXLz6mAfLNj5ECkAzZ28EL5Q38tYFKat/nASJQuowg+bJrXAhJWdw7GjlmMIY5xzKyblLdO5xA9RiNcr3KT+T1kByqAlbCqXyp395WxsC8Rk2gKWOzRh6g0Vz4VSNg1TYEIqI5tccZvKBmCMqEdq4cu/Sk3rmqA5TjubeIZEEL6X0lQ4F+6zDejR83riYb74Lt4OxlLr+8XVj1BlnhA06dJ4f60Crlas/E0lRKpvPhhujww5WPPLlVzzVUkOrduRRDHtDSEOPEAiaKOcElKpvXxCAM9P2OiDRN2zpluTrO+0jKlxe2u5LNT7zxp5o0TNbyUKyFfBzL7roquTibngC2tzKbnRXUgt/6ysDThJuamU38aB5d5whXcg28SRjhcQlZz+q9/15crQC76pYyYETV51iSpvp/BLKsYAqudkFWaWB9yXXkA1MwN4HN5nL9TkQQj2FzwJRHVd0O7xNyrF36pkVk8vPk6gW5YyiPDRZlJRRH9HW6V2Y1a/8lEGdWkOy42jfs5ql+l4Z+ilSCgUVIB/ZKByUH/xrcUJnyNqjeb2uDVNHDWPfB85/awDUfNPkpYof18mQE8oySJYo/4wznBgtsDunjy+AzAjFkKsxYwg7I2KHSLwfogqg6UBmsNh942k+dR529h+Vos8iAIje9gMXosK7Wi/x1rWChl6Tn6rSuGKaGmroDrNG4n424V58wFZWW1wZpPpuj1Ffhc709OWGzR0vz21KgraPkrAKKdpLORvkzgVOWI4X/eZ3QBON5/gkyz4mVXkwiK80zGIk3RicaUwTY81LW7eu7tE5Kl9AMG0ziJQ/8o3+6HEvUdr6TdAwTreTOnXELG1elxKYAzj162Lx3+mIEfOEIlQGIC7PRV8GzFh5BqJ4g7TWQymTLywDNP
 4xd2p8Ex
 8HrN2uXpsmT8oyf+7AFSR9qe3GD/rW/vVaLv+1RmUkOjHjy0Mcc8Ql90ad8GvpOqpN6nMsg8aSJnv17HfNk1+NWj+Ld1KJ4TKKy0g5O6HEykgIXaklD/s1pexzdPbSs3uQxvPZiFYjqlya8lJtY3VeX9IKGGl8ojKZjFF0nsCtgXGwTF+KNvUBYtVOPyDYnZvPz+vdL7+6OUDDzc3zDd61oibBSimDxqLXMsoGCwKP9FF09jRnw72IVM37GQQhEBEgOVUWZ+u1j3/wA313KUzxfMxXl7ikeVWbLpg5VDmsdNECH4rxWCSRMyQrXB5S5eUm84M2ucwpNWApdPV4Va58b67YA0sVsGhMQQGCm1YPKUqBXhP8SGf15ipH6fbMeVQQDNwIEeuDdVKsD+NNU2z+ybisEfE86V6dAtNWZLwBszgJrXnp5jbUlPXyfGtE2cE0st6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ntfs3 never calls mark_buffer_dirty_inode() and thus its metadata
buffers list is always empty. Drop the pointless sync_mapping_buffers()
and invalidate_inode_buffers() calls.

CC: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
CC: ntfs3@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ntfs3/file.c  | 3 ---
 fs/ntfs3/inode.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 7eecf1e01f74..570c92fa7ee7 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -387,9 +387,6 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 		int err2;
 
 		err = filemap_fdatawrite_range(mapping, pos, end - 1);
-		err2 = sync_mapping_buffers(mapping);
-		if (!err)
-			err = err2;
 		err2 = write_inode_now(inode, 1);
 		if (!err)
 			err = err2;
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 6e65066ebcc1..5d8f04dedcc8 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1860,7 +1860,6 @@ void ntfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages_final(&inode->i_data);
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
 	ni_clear(ntfs_i(inode));
-- 
2.51.0


