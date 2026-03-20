Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 069011098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C684F6B00D8; Fri, 20 Mar 2026 09:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C236B00D9; Fri, 20 Mar 2026 09:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95DC6B00DA; Fri, 20 Mar 2026 09:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 897556B00D8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4112B160220
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:06 +0000 (UTC)
X-FDA: 84566557572.03.60803D2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id E9B55100010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cnn6+hiY9kUDWPBtsjk/eiu5J/5uryfyAB683eU0XCo=;
	b=isgFeNm7zER5Vlp67MDGSlM+tvH0CuPM2K8GGzlzKjgFj5YvfFbG1r1KHFXF0LuYyvfeJS
	S3zqqdErYqrm3Bc1Mfe5SChiXxz+i8/PxtQEmvtnTsPTwtL0i+9szDGU13wAynnrbPhi+u
	0DZOSrOcSZcOUFnsw3keN2DtZXVRIOA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014184; a=rsa-sha256;
	cv=none;
	b=PjJqFyiSzsS1H7bQOHoTNeJ7L+6blBlsbvRt/VSAyp/HRD/wyFUg8ENq8wClCWvLhh3GOa
	HuBZIomC9jOrbzghbfmXBlxeZS27wSlSIz5CxOY/fSDKFccf116rETiQ83saHZSLwdj+db
	jEAoyKsIVOvjrKx0F9t1rjDEHMYIyRo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 789E65BEDE;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D6834281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vYW3GplOvWl/CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2B0B8A0AFD; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 25/41] kvm: Use private inode list instead of i_private_list
Date: Fri, 20 Mar 2026 14:41:20 +0100
Message-ID: <20260320134100.20731-66-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2199; i=jack@suse.cz; h=from:subject; bh=m+lB2/q+0DhErETXlDI5b3T5IuwHOZTjAraJKIevk3A=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6B1oHQPMttwmV/waq6w7qvrxv+B+yoqCBpA hYB2TfsJi2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OgQAKCRCcnaoHP2RA 2amfCACs7+3kVQC24piOZZccFxPZcILv1VIPFArFvhdXNyKl6w9yChdq68siLuKEB4JhSwLp5zt eVGgd+P8hCwr1SVPiSSDsjfU65WQTtGVVZf6l5JEf84GNdgFIqz06u6kJfbCnEwjlDePL/gc1PJ 5hf0ovTAEPpf1CBa/qLL+1G1SRc4hs3+iHnDxvvwkModMG/nelg+nX45zPkh6UgbQUiMNpHoDyl I7FLcV0QmeKkk1OHLOG9Zlqg8eB98owx/xAADMWxP7HwFd67CEckzkLvqnR/JcNPvKMEjDmlDB5 HnMxTctLYKNGTiFAkJ1+Dgb+RC0KOAxO9T6fEiFXTlvn84v+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: 7ubmenx3shm8zhikdget6bk3te6rhyox
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E9B55100010
X-HE-Tag: 1774014183-877016
X-HE-Meta: U2FsdGVkX1+UK6b3rr2NBdmllCH7V9H2HzWQ929EwbEtMLs8FIA1nAZaiQrwxpSMBXUOwqhiGtJPWYjD5bmzTF26gKeI+0z4AE1mBY2AJmXcAfG8q9q7wxBaUFBGtOdU/G0ap77jI/EzCjRIikuaTizLxL5IsIRlVYIkFGrB4ranQU0X7V7xTNjAvHyfbvEnk+pH7W/31/hO/TLejGWGNlukfmruIXzJxfX6hedFas7BwtAFZ/ElV3ZFm4EjPFc1Ah4Zy8IdnPUqusNbDAo/ucnSjCHxKbhgnbRnxh5AyMoD1W/RSA1SimfwVybb08vBavgfjp7i9wV5wtcQCDIlztXhnOsZ6upFzA9j3n954KmdG7a3Kv1kgjr82iZWH2/OKIcQEoHjTXfzTy4Q6QSe833wqIFWRQ4nNuuY2lE8XUerrn9T6TJZn3CAbexN9wsyyJo+RdpwH1biR+rxkHoj9odIWlHJEeuvEIhYRTnLHn0GPIDnA6CsKDt2fTc0kVqk+4AahNilyX05DLY6KcmvOTkLg38Em68NquYN2+gnH3ya54TjruIXJQLoj+8+udAFF9PEtyD7Kbs48LNdfmiKg9CEHSPsCiwYnBAQZ8rh1/RSy86W3L3XzNB9VjpL08HeuDDiiI7j9Hpmy9b7nyhUj2c7svEPm4TbyEeiD4ksMB5RndtLDfBWAn/iluWEaNStQ0C/6V8TdNFKTAnN2Pg+3rKRTddiDF8cFmjMxwIuS98uCtjbGWexo7AdFjO6Xy4DSpD+wb2a9u4snjVFfMccgOee7kiOfrSXxH8ogMblneUpFEPRx/cHkZJjB8cJjLrbEHa7PXUAiQLunQNJaKPYVbHkFN6YJcf2QHPUVOL7u6yyZnL5BdX7jcqpTTv15jWCJjCWop9VD7raTJjouq7ZB1Dt3Bg4rK24a18l8QOUUidkS+nQZdXkkV5+8uSRx1mKWsj4DoixYJzyOIbcCkg
 wcR41nCO
 6k4OMpGpVP5cC+YuKE48HFxAzcEuXVdGt6Wvx/0/vm3Vs/j9ojTwuU1h81kXmHQHm/iSn9vzx9CvhJ9O5x+z2nMMCKMZzgfKt4UfhrhwOnv4LL2wf5qHBiIKwNjqfw5GYp+1bmyr/aoxQZNBK7bReGC/hJiaAQdXl8X+o5efg4s9sBZDWrVD40PIiada5UJlUVI5pIL5DnlaHSHZpMBA3nviefdvVtl5PfQzi79eSActMcr3fqTPHnE5BOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using mapping->i_private_list use a list in private part of
the inode.

CC: kvm@vger.kernel.org
CC: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 virt/kvm/guest_memfd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 017d84a7adf3..42b237491c4e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -30,6 +30,7 @@ struct gmem_file {
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
+	struct list_head gmem_file_list;
 
 	u64 flags;
 };
@@ -39,8 +40,8 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
-#define kvm_gmem_for_each_file(f, mapping) \
-	list_for_each_entry(f, &(mapping)->i_private_list, entry)
+#define kvm_gmem_for_each_file(f, inode) \
+	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
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
+	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
 
 	fd_install(fd, file);
 	return fd;
@@ -945,6 +946,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	mpol_shared_policy_init(&gi->policy, NULL);
 
 	gi->flags = 0;
+	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
 
-- 
2.51.0


