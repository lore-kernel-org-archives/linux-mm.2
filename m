Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52762106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089A36B00C9; Thu, 26 Mar 2026 05:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43216B00CA; Thu, 26 Mar 2026 05:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58EE6B00CB; Thu, 26 Mar 2026 05:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C44756B00C9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BD4C13BF24
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:02 +0000 (UTC)
X-FDA: 84587758164.16.576B785
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3BE10100005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1ohE+/+i";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yWbswddA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1ohE+/+i";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yWbswddA;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518960; a=rsa-sha256;
	cv=none;
	b=a8ouaIZbWg0NhFhpXgQGUYIldM00eHXoXVJnaWB/+gAXOXAzdDNF0F9oMaAvL3uVHSSyuH
	jsVG7bezMXoMKh0H3nmymJeIuzavJurVRmsC5HYJhsTMedHMBa9BrO6wXLbA5YlaVzrUUu
	mVqSdybnOmhqQOAF1yEDBaoZoVnpIZU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1ohE+/+i";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yWbswddA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1ohE+/+i";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yWbswddA;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=IyWMc4x4gzKWAWmKF7dyxwT6ZFPF8ynpsMMvGg7c3AXbTCbQGohciVwE77n+gb+QjEzGui
	BQRFLo/zk0SM2Qdtuz38lMQfo90IN+T9FZXMx/a1K+DJknbQlAazBKUjTPEj75nR6TaiC9
	e2syv9UdNXjuJxLVuX4klciY12NOuEs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4E2B15BDA7;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=1ohE+/+i/xI+ZskyUv4EraTVvaP+8Cjj0qm477ZOZiHRc0dCwpKq13EBod8DcAiY7oqPJ2
	f7AQIoAy7s+GdxLzZDn+qvl8/8QmG0BTP+3zxTCOktV/BlQqzvJ+pmwbUhFySKgckZJ5L1
	QIUEKg5cRbt8M4kmIRL4QUAcklNuDlY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=yWbswddAYIxQUSFHwvF4fQlh5m0e2ajdTafaEUrMfuigAL6k24RHUCB8HqdCAeqjtb9elE
	mzpG1fDtmU9M3PBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=1ohE+/+i/xI+ZskyUv4EraTVvaP+8Cjj0qm477ZOZiHRc0dCwpKq13EBod8DcAiY7oqPJ2
	f7AQIoAy7s+GdxLzZDn+qvl8/8QmG0BTP+3zxTCOktV/BlQqzvJ+pmwbUhFySKgckZJ5L1
	QIUEKg5cRbt8M4kmIRL4QUAcklNuDlY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=yWbswddAYIxQUSFHwvF4fQlh5m0e2ajdTafaEUrMfuigAL6k24RHUCB8HqdCAeqjtb9elE
	mzpG1fDtmU9M3PBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43A564A0A7;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QEOGEHECxWnMYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0D883A0C5D; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 17/42] minix: Sync and invalidate metadata buffers from minix_evict_inode()
Date: Thu, 26 Mar 2026 10:54:11 +0100
Message-ID: <20260326095354.16340-59-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=796; i=jack@suse.cz; h=from:subject; bh=S1BAqXV/Jqi4FmJijCh+slBc7/Xi7wKphfEUon5Scy0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJA8bYqxZ3+JTUWtvnp18qagzJO877Mdw6cB sfHYzZzTaWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCQAAKCRCcnaoHP2RA 2TLYB/9xXXjlaa9QiiyDHdW4cz1emasnfHuX/cDFhXlHKgGMqEsSXRN3dc4h3zlXv2nAjeYWlns Gfgv7SzMVNqgS1HRUCFEDV05oZu4CEZSKE+YnzGHQyM2AuXJimH/kUOWqmbI7W/CieZnC7lR8DL nWKa47GOpOxpJPJzCXN1ukTqP5DCQ5vB2qhclQtQ7rcTLdyg8HtYUayX7J5K735fCjpegQ2x8FS 6PdXVrbXwDpf9wq2rUu/qe9SR5pOhEQpmuhBmlQxsE9kNUgklbt/OqcbdDjoVm//8bOLeUbZJmZ uXgBv5BKQC0h9wvCDUt1Q0zZLI0X1oUY1NU4V461WW2drIIl
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: imie89sxutstaj314f1cqr3pcurfe7q3
X-Rspamd-Queue-Id: 3BE10100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774518960-723195
X-HE-Meta: U2FsdGVkX1+9CDR+sj/P2NfFAyuuHVmrUnJbEVygtyEMD2/2qEcda9B+L3dJ5M/5tl2xTtUEvNm8B1VYvUOM0KClmJ4dcQl4emiQzhFZVJCmrIFsU6g3TflWXuxf+czD++ZI0jUcd6i2mLfdNaFpbxrgpVC15IUKskfg81TWIT+ZZzBkLDImho+2LlrCBRVreVPpGXt4aqu19l8dibwDtjbAdjoP9EJDVL4cahdBcmrhEJIQNwemCs5OLvtmPEkC0qdh/c8Kaw9Rf/j9+2B9bUoPuhSUAq4FwPfGvoXBAaQSkSq1XxrFFIkvX6tQz/Cv3y3FNyZoxnTq1qpfVr8nrth//t1KXSuY07iQKplX0d484paN55nobIVxSKwHfihYVccapF8VG0ooN/L9C7xdIi+956udaNd/PfBhjkCRyhw3fWcXXSSEA4SfEdHi5rjKnPvTEPjBcT1+p9b+OGaxIkVt+j1N1iW4KdgCRbI44P8E13CIGlkFv4WZaTmYbZiy417N+zFmhBny+0h2q1FU8eXLBvc3Sv63wJIWZDHt6txeHpcJ5AHiZYHrO2NPG7R93C+QJ04y5NaecCa95cJfGxrWY3IXUg8JTWr5sgJgBoTm2QWk+4QmWC5ElKjkEg/EGdycKz+LNwG0GVB0UO+MJpkEs2jC8MH45Gi22beH87OSDfLFCOB5AGChBE9jCVwygTYLckmeXSIvk+/PvWn89K07RJmuY/ZjGYFGKGZuslYgmMOPAd9Oy/Ra97f7SpLzXSrhDkFGa7EUxICEr32IjhVt97s98zirxX0iuxljMp/FexCI3UnxqryEowDZxPY5KlXdFheC7oQLwTmU50zQ1xhhkhU7lHJH5AGnWmIpt5/+LPSBlmoQVcHyKX0LKT0xrsHNFPBv8FgpxO9LAtdnZCzS/Yekz3rbXBQ2pYSFwv6PYcUicp4/9FuKmr7idgcf6Z3SDToe9ruDKOm9aaz
 vb1nyiGd
 Q1mgwArTEGkzEMZhapITAIWUlHyt8JB0N5G3HQXZkmGmokKk/2l0cAOfKuFzL1nzlVmHmaQvisrsCNKfCH9+ZzoGhwDkHnTPytNBP2LYoAIaMtBY7c2LBYIXmLGFzYwgEYPtr1lVglcpWbuKLrj+H+3epR7bkcmLZHDkWtti1Zf4hEWuQ4LTk0aibaAXYDQ2KUp3LYzW3W1UdnIz6VzHSZMYpqUkK71Gyl/F6MW+8NJny33l+IPA+LITDY7h3GS8DcJBU643rJwp8AVpvO/AkwcclWj83BuSKr7HOooKiDfOQihhSD3w/uFOkaujBJ7Ci1XQKlsJ+yXD9JA1k7y3MoOFYLbvJl1Tcm0nC/4cziRk5Fs8=
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


