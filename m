Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0ADEC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1328D6B015A; Tue,  3 Mar 2026 05:36:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5F06B015C; Tue,  3 Mar 2026 05:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED146B015E; Tue,  3 Mar 2026 05:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC4E96B015A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:36:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A848EB92FD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:38 +0000 (UTC)
X-FDA: 84504398076.21.93E003E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6664240004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PDz6JRWj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gz7qITFv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PDz6JRWj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gz7qITFv;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJwm4fvAg3a1hOEhycwe2FUYXuHnKvYj9968NDPJOws=;
	b=eH5OXlPF6jzVjKKxTkbB34uohNhXlwwe2zIw1LHO5LgkKY5m+8ZfeqPZ2UU9/hVF0E4I0L
	Q0XQvHAZ8hM0K1ScrIlMVFt/agOwdr1Nh5DQ7AhFt8lSV7XrFySgo2EAVcOPStvDcIj5VE
	MJdEr99fQZMO5BvRYgpb86rrBuc3+Zo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PDz6JRWj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gz7qITFv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PDz6JRWj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gz7qITFv;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534196; a=rsa-sha256;
	cv=none;
	b=JQnDGeyZzR/hx3fVZMccFZvDRrQ59q5Y7fluPoIYw2d24FZ545jwUmgnsYUnj3+nzE0DsX
	Oo+s+320SNxuHMAzkMkFGzr0iBsfLvsa4EyeAaB9ch5rpbFqXsrK4i8rTl2Xm2eN/2eT6D
	QsTa5MBxyrkSrlyrnz6SrJCakvWVPy0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7DDEA3F90D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJwm4fvAg3a1hOEhycwe2FUYXuHnKvYj9968NDPJOws=;
	b=PDz6JRWjSeQ890kGuvn9Ph3Oi9gtVV75wuen0eIC/mXNKQGoQxwSBjYdpl7p80YHjXOdCR
	QvAXuk3IkmlmHuPhyD4zb2nHhmjfM+eR+GE9hifa3adtlblT9qFmnPhqvjXVVG4l58jNyz
	VxHPfyz0cN5Wn2xVAqi+jo/jPSzHpGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJwm4fvAg3a1hOEhycwe2FUYXuHnKvYj9968NDPJOws=;
	b=Gz7qITFvIJY6misgdjIAVQ1WndNK0+d38+baDQ3JpzKnvkyCNN/CXIM+W3BWuPlCNupEuB
	lLHuW+/doPxx85CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJwm4fvAg3a1hOEhycwe2FUYXuHnKvYj9968NDPJOws=;
	b=PDz6JRWjSeQ890kGuvn9Ph3Oi9gtVV75wuen0eIC/mXNKQGoQxwSBjYdpl7p80YHjXOdCR
	QvAXuk3IkmlmHuPhyD4zb2nHhmjfM+eR+GE9hifa3adtlblT9qFmnPhqvjXVVG4l58jNyz
	VxHPfyz0cN5Wn2xVAqi+jo/jPSzHpGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJwm4fvAg3a1hOEhycwe2FUYXuHnKvYj9968NDPJOws=;
	b=Gz7qITFvIJY6misgdjIAVQ1WndNK0+d38+baDQ3JpzKnvkyCNN/CXIM+W3BWuPlCNupEuB
	lLHuW+/doPxx85CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74BE23EA6E;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DFGAHEW5pmmlFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 59132A0B82; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 32/32] fs: Drop i_private_list from address_space
Date: Tue,  3 Mar 2026 11:34:21 +0100
Message-ID: <20260303103406.4355-64-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; i=jack@suse.cz; h=from:subject; bh=KGtDrC9rNzTK65SQ8Oe7H9Ud9xEAArRJg33A6iQt0U0=; b=kA0DAAgBnJ2qBz9kQNkByyZiAGmmuTmiwKupnqCllCbgGVKgOMHk8s5SOF8d/mNwYbZRpubyN okBMwQAAQgAHRYhBKtZ0SvWnjKKtVUoHJydqgc/ZEDZBQJpprk5AAoJEJydqgc/ZEDZAigIAPAg aLhOjvAkhogRp0PsPfiAlvNv8YRXMwIUjSIqMVAVwFc9REL4+R/6NFJ4gCRMGYFlHOC4aiMszpE UhueKj0QF0yqOeimbTOxxJ4HM3FWc2ur/GMmzFeJWrzhICzX09nA7/6Hprn8HNFifoXIakkxFc9 9twj3/r1SUkgyxIJp/2OBbYiE3rtCR+eEdZdPQ9H+4W2G6nh48oBHafwjhTisOiNQU7nNMUxk81 j4ACfRGlNgQs4+nSQK9oqCnaxhuwyww22NWbsYcINd7RbAgUaUDydVNDDXw6s0L4ZqXj57PIlyo XL4jg8Q4WkKImKMYn4iUBtJnDjfg0FkWiPEaVKw=
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6664240004
X-Rspamd-Server: rspam08
X-Stat-Signature: 318bo57pf9dtn8ux55o9z96gjd8a9hg9
X-HE-Tag: 1772534196-90396
X-HE-Meta: U2FsdGVkX19u/KBUhhgXu/ae0Pbeb8unHfogoPEKMIBetcNhhJbFOUPVh94s6+rSRajqwGVR70aPbwVNNIOSUoGPUTHGnYtgrQtTXwwDk7x9MsbSTOuINpIJbXfVYDw996XHMGy4p49qqHpsO/cgvYgzn7XMYtof6O0K/mcfaWJsB6Jv5tpzstfFaxksK+DYuxuNkRtx9zsoXdKfFd84hvFCfMdX3U+9fl+BmAdBQSjc3f0LpYqD7ioVc082wUeP6uKm2ofyCEPEzcU0qX2327ple+bJLGy995YiTUlW+1SIwuXVtxyvPFZOdrfKJ47ld2Kk1QTAauAXHlIp2JfaVOO5ndoAK7Do14BJ7V9JFEnvakgDHBWBSZOwikNf/ZZ50kZ9sr4WdCDivivHFMuF1pFXlDVowGOx9qQiqZw0KcZfZ08GxRHr31elms87MurXrONuxaQIJnXDbvqtwUVc6S4jaIlz8YxyMbr4c/TBjBU45VQOPkrxKrHkmyL+wYRnRFBGZb9nWv+Oc6WyqfZe2/+hhFPHguSRrLCr2ztRw6xVjUVpCIULtbjrj+1NPzY3gKMqGdCVhn0SUY0ZjvADPQMQitZFP0VXq0pelH1QxLPviSygJ2ZX7QTSIlvI/D4PK124Wzv/yWtvgRKimMiUWTdsdAd/OcJyhsRe1oY5lQ3kiVlYdZr7y/yWcMJADtwwoAW8pWoPZduW3piw1PMuU4g+pXSavFShFVSzfi/dyPxETGHF60qt/1GRc+YQTVLUtjjcZe8OzhkAjtNAYAuZVmLedisYuQij44NQkL/NtvlNOKeFHOsDNVmMko/JyFEICuuodf34FSCN/2gjHJcFTIjiqcZWThzVxelBtVO0ae3dw/NuSSIQ4e6jhD+GztKjXpmHfQrqBMohmZyOsLtuMYLchc/L8hXFCVDi0v/+kNAC4OdZibSCmUn55bRFu39x75HzvBTnZFTli3g+jU3
 M4gddIve
 XrgtipA8YwDEtgLvXcUNMpU6hDWSTo1uXjrh0oRO8/uj9n8Qn+3bw7KkWnvFqucor8U/XtR6v1bLwjVtWCxg4pqKuElY+W6txAhznZlaSpR/KCbxIATY9nqxjXvYTokoZR7Y3srYn6i64cOKiePPX8RP5IkvN46YPHIcce3FN0aSSWT3lfHFlEUKfY9Ao0kGIxPzrcaFURV6b2rLFrbGJtbGRa7rH3kW+SLH3nOlxWUIzUiBODHlxdBy7uLYYKVowA1LwbrAYLlE/pKx5XXq1MgxuIANcq533Hjw/y+ljq7hume3Umq7wMAKPq5fbltaN+GForxtFof0dLJTNCGHhZwDqhxEorhCUrW7k/5Byg8n0Hz3SHr7rZ6XF1V3I1fi72AThI6KOKn79iC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody is using i_private_list anymore. Remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 2 --
 include/linux/fs.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d5774e627a9c..a8f019078fab 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -481,7 +481,6 @@ static void __address_space_init_once(struct address_space *mapping)
 {
 	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
 	init_rwsem(&mapping->i_mmap_rwsem);
-	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
@@ -795,7 +794,6 @@ void clear_inode(struct inode *inode)
 	 * nor even WARN_ON(!mapping_empty).
 	 */
 	xa_unlock_irq(&inode->i_data.i_pages);
-	BUG_ON(!list_empty(&inode->i_data.i_private_list));
 	BUG_ON(!(inode_state_read_once(inode) & I_FREEING));
 	BUG_ON(inode_state_read_once(inode) & I_CLEAR);
 	BUG_ON(!list_empty(&inode->i_wb_list));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1611d8ce4b66..adad21e31cfc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -470,7 +470,6 @@ struct mapping_metadata_bhs {
  * @flags: Error bits and flags (AS_*).
  * @wb_err: The most recent error which has occurred.
  * @i_private_lock: For use by the owner of the address_space.
- * @i_private_list: For use by the owner of the address_space.
  */
 struct address_space {
 	struct inode		*host;
@@ -489,7 +488,6 @@ struct address_space {
 	unsigned long		flags;
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
-	struct list_head	i_private_list;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0


