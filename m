Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6E8EC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225AF6B012C; Tue,  3 Mar 2026 05:36:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D396B012D; Tue,  3 Mar 2026 05:36:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B25A6B0130; Tue,  3 Mar 2026 05:36:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE2CF6B012C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B067F1A03DB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:59 +0000 (UTC)
X-FDA: 84504396438.02.CCF4862
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6CA8B2000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=upTTG0+QcB2H5lopEZkGA+l7DeLgrxu5BuF6EA+hvuc=;
	b=6ugMUR2tbJdaaL8AItKICS2x1ADEYoEETRZJCZ3ZSGgGHxZPkelKY39dW8sPQkazHk8QVG
	3pkk6I5gXPuIkhWX9nEximRm/gYs27JzhaModHbmbSskXlbUBX35g4hOzkd6NAEd3LhIeQ
	NGb14m4j2jjpSJk/tF+EjVa4feDOLWA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534157; a=rsa-sha256;
	cv=none;
	b=Nq8oYaeC6BV9lo/Osgrao+POO5BLb3NZkgrlibcBz23CmG7IEbb411TILPehCTZRnacdIA
	hUdCGjfhmvrbpNpjbIR4XBO7BML2gMkJ1lXEITkKryjKubcghJvNUIrGdlIceTv6+M3dMn
	BE6GgpdYJZH9ieamsqbda/X29Kj8RGM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 799795BE32;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F60B3EA6D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id X3QwG0W5pmmkFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4FCEEA0B80; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 31/32] kvm: Use private inode list instead of i_private_list
Date: Tue,  3 Mar 2026 11:34:20 +0100
Message-ID: <20260303103406.4355-63-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; i=jack@suse.cz; h=from:subject; bh=jRmpGnBIbXf3zwY1aurODz7DyXpIxnDKpqd2BEFflmQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprk4KwaWC8zyZ0s7V4lXzGzsQQHzPJJwD80C1 Zy1LnL7DwCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5OAAKCRCcnaoHP2RA 2bSEB/4h+viVsZtNldyok/qfyaKtPMr65DkOGhl1KBx7viW8XI3Jg99sH6b3b3LJxhWsD9vznvj UsjvvKMXRVTrRUop/xmuCm0BR1+F43XCOLruCIBpImghBT+yCdN6hwjrSt8o0FV+rt0vQw8vx/f RHup/w4Zcn4OtRHiDFDeXptIhUSdoXGB8f8kPQdk84DfGagyjnHpMuGomYGOCIBxeBkSz5Lr1ab aBP6abWoi4dzSvs94Obdaa2A/Mh9W55p8/Y0fG3fuiiUL3gISlSfYdTHFWqlUTqCBIGT9vLdJ/A 8rK1AUNHQXNplQIZTpWM1Gjo94jV/z0zzc/zI4qnNuETqgbt
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: r154zd31saam3x6iocpw37qfgqm47aj4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CA8B2000B
X-HE-Tag: 1772534157-287165
X-HE-Meta: U2FsdGVkX1/7zeSLtg+H7fLhQx9uXzNYIgIQ1HmuQds2piV1qNgaEq17SRJL2y1QyTdjT/8Vb7wv8BRWpC2cbc/YtgLHa4iv5C/P/Bv2KFGAZpQQqGAFNin33gFX+Y3h+iolgx7xEVo3MMIDIrQV/Ql67WtOgyvy+ERgcBKIPz2WoqRyczxOzwkytn6yroTidPGadAD2jSr03JIGJLx3h2pyAApeCzd4WcySC7OHEXV1qSBTI8tIY99zw8lM11r3D9q5WyylodvTooNteZ9zRa4p8tXa5A62ypfe3V6Exk0svENoVyEbSwHv8/HnKtxq9R++sN8SCjefgKNM50gwNpeAfTCzT/YnhjIDd5OTJhD0GRYngAdg9RvA0C0eQ2qOpRhsOAjNGHb7FU5ItXb/Otts5s9oXlz5LRKoh3Q4tFJ6wSFOTnLVNzqow44/QF4sFa28cPWqvNR6HRyKNd7R56eeNWINxnx1f8YYi+Aqc/DVNvJKRkWiaI/z1rIJGzNg45TTZtNOV//OlDYI3SCORGOjGmxm14dNVbqwV8gZYn9aGUD2HluHnm2Pbh8j03i+iJ52UDby+tjS0siASR4b/4tPIJCMrLYi2RVAcx6fArRsh8zD+vQ3kZCoQvJbh5ZEfWDQ9iUA1tAqMls8MmTNaVjEwAvHk88Kzbu3t/ixUXu/KSwpsgKMkB9qzgVMNb3OLVNgec7hAA5ObEqKnAo+Smdn26aFDS3WkqAqqCS4HEQ1a4pqraYaliFP08fcFWBCgyFo/ZVl1+a9bwTz0wFtYZHR9uqseCqzQCCJ4gK2GsQYnTgN1ViAeo0usZii5UL1nCCzB66j12rQlLmSIUB6barNh9HXwIBvDHNQs0/dI5W4XlNZODCWW0MNwgYX4hj5gGlLQ+0HQTb83vkv+tnBtsXNN97gsZuWihRlWvD3j6fo2mIK89j/5OAdIDUfRr1ueavGwwBYr2A5z6Ehldo
 0i86Yy7E
 nj1YeJSpuLLrfzCH6PB0P88IeINWTijFXCGpm8pOsO4/LeM9g2nnIRnOf18HR1UPnMEdIiWBAGbJJNpu9cSDRVSsacVmhdABEuTnZ2IPPOBmXFokuWBBnbtZz9AjsYbXjalDE7XIiJ4+uy8DInyNqs++RN9/hED3RqzWq5EHrsdcjgOIAMyHPpH9qWAlB3hl0iWdA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using mapping->i_private_list use a list in private part of
the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 virt/kvm/guest_memfd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 017d84a7adf3..6d36a7827870 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -30,6 +30,7 @@ struct gmem_file {
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
+	struct list_head gem_file_list;
 
 	u64 flags;
 };
@@ -39,8 +40,8 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
-#define kvm_gmem_for_each_file(f, mapping) \
-	list_for_each_entry(f, &(mapping)->i_private_list, entry)
+#define kvm_gmem_for_each_file(f, inode) \
+	list_for_each_entry(f, &GMEM_I(inode)->gem_file_list, entry)
 
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
@@ -202,7 +203,7 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 
 	attr_filter = kvm_gmem_get_invalidate_filter(inode);
 
-	kvm_gmem_for_each_file(f, inode->i_mapping)
+	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
 }
 
@@ -223,7 +224,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 {
 	struct gmem_file *f;
 
-	kvm_gmem_for_each_file(f, inode->i_mapping)
+	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
@@ -609,7 +610,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	kvm_get_kvm(kvm);
 	f->kvm = kvm;
 	xa_init(&f->bindings);
-	list_add(&f->entry, &inode->i_mapping->i_private_list);
+	list_add(&f->entry, &GMEM_I(inode)->gem_file_list);
 
 	fd_install(fd, file);
 	return fd;
@@ -945,6 +946,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	mpol_shared_policy_init(&gi->policy, NULL);
 
 	gi->flags = 0;
+	INIT_LIST_HEAD(&gi->gem_file_list);
 	return &gi->vfs_inode;
 }
 
-- 
2.51.0


