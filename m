Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC28106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C156B00BD; Thu, 26 Mar 2026 05:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCAF6B00BE; Thu, 26 Mar 2026 05:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1B16B00B9; Thu, 26 Mar 2026 05:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7021D6B00BC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DBE05C432
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:44 +0000 (UTC)
X-FDA: 84587757408.23.94891EB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id D4E3E80010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ekgi8iaX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kIjMpLlh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ekgi8iaX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kIjMpLlh;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=rXAeM2hfMMxo7X9a147yJRCvAEnSanG/vWcPpuuiXZrPqyVBYLcW1cnye1byI4oHjlg2yv
	3eVUexdAVKx+t6wQuToyt59EO9778OpS7uu+w23gF3AnHuYMpvKLFYItXAHj3+nrwN6RfN
	KgvUwuFdZUiXT0wmPrt6AV/M1fGiwYk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ekgi8iaX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kIjMpLlh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ekgi8iaX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kIjMpLlh;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518942; a=rsa-sha256;
	cv=none;
	b=jfB/fGDp5f+X8RtRuhWVD32+f6c+l9Sb7dH+bU9Rtlv78Cy8G2M162qjcLWtVVeXjNKpIU
	nOO/p3AnW3EN8l98I+KKdqKcIPvVsZSpiwok7BXY9fiQF0ulorncKrkUIVGA0RuiWhHTz6
	JiIqhT54Ro4LQ9vyV8sRPbLhXHDVOpE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2318A5BD99;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=Ekgi8iaXS4N/Pxa5Iq0DQeS3r/N2w8ecGZ6fCfpb9zsrV68BHeIMKgrtUgrT20Q3wMDqz4
	Iq9iGTKjXpwUw8mkGzDfwTX9C+VP0iOn24LXgXpq5csShPDEZSesXjTdJALtemq5P/ehol
	U6r9KUwJNfBTu3IxsCMudXn+ZvjKwK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=kIjMpLlh2UeW21LnFRQ9ygX2+XWEb36ITfeEd0QPNo0eX09jAg2yfOl1s9Uw4grM9jUo1R
	+u2oHKtCtgVu9iCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=Ekgi8iaXS4N/Pxa5Iq0DQeS3r/N2w8ecGZ6fCfpb9zsrV68BHeIMKgrtUgrT20Q3wMDqz4
	Iq9iGTKjXpwUw8mkGzDfwTX9C+VP0iOn24LXgXpq5csShPDEZSesXjTdJALtemq5P/ehol
	U6r9KUwJNfBTu3IxsCMudXn+ZvjKwK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=kIjMpLlh2UeW21LnFRQ9ygX2+XWEb36ITfeEd0QPNo0eX09jAg2yfOl1s9Uw4grM9jUo1R
	+u2oHKtCtgVu9iCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 189E64A0A8;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NS8CBnECxWm/YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C3282A0B7B; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 10/42] minix: Switch to generic_buffers_fsync()
Date: Thu, 26 Mar 2026 10:54:04 +0100
Message-ID: <20260326095354.16340-52-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=jack@suse.cz; h=from:subject; bh=qxEFhoc5TAxgK8o7QW5olFNXyUnNyDJBoNqezgZzJxE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI6wtYz/MQZTdQ2oMuDSu4hXpUpF+I5J9WT7 LwV26ndyxKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCOgAKCRCcnaoHP2RA 2UtcB/0bYO5+Iss3mhVKnA+bmXVSBsYshUvvaqq2vOOYDAEZpYwIuLzzjIbN3Z5+uXIrOhOLHir xEtn+3TJNK6jvs+1Bv3rHM8MKMZiIXmSwTuzzolgPqmcuFBSDO2fkG5PnOm47dkukb1lHHGyo/G hzMYF4bgpgZcXWCs7BFwyVUZsS2O2NXAZwYV3uEjKKBDfK9bgMnbnj6RfGP5pblj9q+JNM8VTQT yc02SjMa1lC+ot6Bqal+o6nvDM3soi1QEgCi27iN54RC8p3tJ3Tc3MA28xCIBDkXS9gmrZvWMGH 3p+QoMwzHe5798zOvzlGrUk0iwufdipBniRdcWxVTk28WeCG
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: D4E3E80010
X-Stat-Signature: o15o17m3ad6qx4x7ouddchn7sobu9osu
X-Rspamd-Server: rspam06
X-HE-Tag: 1774518941-49515
X-HE-Meta: U2FsdGVkX18GGqDb8daRVQQ7NtdQ9hsdtO+gGNSjjr/0h15AVtEFogw89sYGJPQELZWtSwgmh5MFl2AIzm2NutmCa7Xt1FjXAhvo/JeuR0s4elubKz1jNrwxX1IwgRh+gP8NH76DN4RGF1BurrZijYYCc+1VkufGsiruFONTi+wMd8fGvK8bnoVkmeBzvwkjJn4SC0sbngXx4FQlJKKAF0tsUYd1FvqHS6p9K2zBAJ5K7pmh4kO5PWAc5n3+yC/x8r0PY8M8+pmcAwIjIZlW35PC3g3pCExCqcsb3+wCpkhfmuJQ8UK2q8SNTOSeftulKDY+J8QQHcPCL4iKZ8Ne7XzIgq6rCaG97bJrMphG4AJdddN4/c6TwzEMoAqe9QCeLRn57o9pAOCSBi5XlCX0jerBebsfV2Zaa8XbzvTGtFwuE4DB1GvhReChrG3SqA5ILrzmmWVVOvJSvbWugorV9V1fs03qHQrOak2Cu8NwuknpDEsIjWf+cyTqt7EhDcVGOyGRPADOdULWGlaWue1JW7qXgmbDu3cWSfQMnjgR7Yp4vmjy2QWBQ8vEvvfi6lF7QAwVIAACtZGtHZJ4X1F6C1Wlc97QeKy8vZBeEDZYmpcGNQ86sllLqYrNmuHe5keG6BCN2PbTonnfIaf+gi0L+EtBdxlXTSClq2rm+PdsHxfZcX2pqdfStxOMv5PL3z7Yo6HGg2lJqKps+cEopsy+0F/9Wl72wEIjapbTIMzAN3tsQXozr5HA7ZhN2ajOgbc8UrHL5gEfBaTwx7vEEogfjS2V8yQkrCDJZFjHs8sx4I44rdRh1DLmnjg/u+aS125OIlUvtQCF/1QD8TKwwmkNed0J4guPL8WfImsbXx81ZWAWEqABbDOsr0MP11A02A9ZaZt+UvjFoIyDyjYau9JT3ecK3S4yPtA/WgywVL5XXV4hk4vsz8Jpapg1SD5dhC1mq6RTnMsH37mb0TzvL3Q
 zzMZRinu
 Y3Ttb/hbv6bPjnotY+rM03dYyDKqWJE5PnlNjS83Tq0i5F7im6cU5r1cyngy45YijbfNGsKkCubuMdA5XOUEFsmaer3HEywyVprkJPjTErqxavo2Nu3ReSIko5CBmZPhAlqK3u68FIpQptn+jtycM5dCxszVmcm8AYCxmFaoSDbER/Y9ONtLxcW8GeXHMh+Ap4UH2SLlS6EwgM9wXDP3kxoFEHKqyHFdjtC/NOs8eSJTp31whs8tkaqscSXc7kvuLdvJkncQuOx6PTXpO2sXNeWZk+Gz4sXbBz76a7bC5RVpQlkomjx77H7E4EQUrDfDpKrP0ptoycMVrhfDINQDvNhiGSYm+dKMJiOU9BZTAAFVTe3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Minix uses list of metadata bhs attached to an inode. Switch it to
generic_buffers_fsync() instead of generic_file_fsync() as we'll be
removing metadata bh handling from generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/dir.c  | 2 +-
 fs/minix/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 19052fc47e9e..a74d000327fa 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -23,7 +23,7 @@ const struct file_operations minix_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= minix_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 };
 
 /*
diff --git a/fs/minix/file.c b/fs/minix/file.c
index dca7ac71f049..282b3cd1fea3 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -18,7 +18,7 @@ const struct file_operations minix_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 	.splice_read	= filemap_splice_read,
 };
 
-- 
2.51.0


