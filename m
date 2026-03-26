Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0ED106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A466B00E1; Thu, 26 Mar 2026 05:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802416B00E2; Thu, 26 Mar 2026 05:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0C76B00E3; Thu, 26 Mar 2026 05:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60AD66B00E1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 204FB5CA6F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:27 +0000 (UTC)
X-FDA: 84587759214.01.B94D956
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 015DF40010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fScM982w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B6RG94pn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fScM982w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B6RG94pn;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=RbEpw83HePKdePE17RENym1idRn5Db5PxA1S2cf5ZC0sQbkEpCR4u9oQy75Yj7V3+LCOwj
	KXuX9un6FeteHZuWC83W3nU+5gxexza+jVZS2gqz661ZLITzDqXJcBqT0DJUM5As1R4hV9
	tLRsEs8W+XdIIWEiy53Lvmi2NZGagmU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fScM982w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B6RG94pn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fScM982w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B6RG94pn;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518985; a=rsa-sha256;
	cv=none;
	b=NRyOhRAp/rzjmT6C3VV3ah82g872jsHgjudA76jAW5okxeMMonZovnOzDnZjp3dOSd3BkI
	Z+3sJuxbDtf87UBJd0IsLfVtNqmjVQoszMMoXUWV5gZ+cBgyceCXT6GMjJprG1dTHlyvVo
	S6y6L1qlCmA3LCa23RKF2iTQfYdru8k=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 728AB5BDAF;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=fScM982wQUhdU44H8+ReTLKRpECzZSS4xPf3Tp88zk5uQjq/lapx7GTCfM5Flj65fwqzWX
	Y1JbqAh2s1kAiieEObSRHgvVb8EsTeMoVkWdYf+MjezkamAYRUyFnnTwOFtFyVToSJCqqh
	YbwDX23uBx4Ge59RJG7URZMn1SNT+MY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=B6RG94pn8Rnaav8lvSUMP2AqtmYja5d0B/dK9n6+rRqkIRmBOSsWnPvsuczaS4kYKH8Hl0
	7mL8LKKeURmv7FCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=fScM982wQUhdU44H8+ReTLKRpECzZSS4xPf3Tp88zk5uQjq/lapx7GTCfM5Flj65fwqzWX
	Y1JbqAh2s1kAiieEObSRHgvVb8EsTeMoVkWdYf+MjezkamAYRUyFnnTwOFtFyVToSJCqqh
	YbwDX23uBx4Ge59RJG7URZMn1SNT+MY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=B6RG94pn8Rnaav8lvSUMP2AqtmYja5d0B/dK9n6+rRqkIRmBOSsWnPvsuczaS4kYKH8Hl0
	7mL8LKKeURmv7FCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 666274A0A3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 62cKGXUCxWnkYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 68366A0C71; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 27/42] kvm: Use private inode list instead of i_private_list
Date: Thu, 26 Mar 2026 10:54:21 +0100
Message-ID: <20260326095354.16340-69-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2244; i=jack@suse.cz; h=from:subject; bh=8BltPTgRrYXS74k/jRdBXdCWWkCHR1h2kZanq93z8Js=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJJMyHuU/3ELVIudu1rF0GGX7ypYh6CAVU2g NgW+LKl4xiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCSQAKCRCcnaoHP2RA 2aduB/9Jwc/U1s4qbiVmV4BfMyZLi02tfp5luwGvNuxAPtN0u0xT+6Z3YsHsIiwR7NUdsVwGd6e rcry5sQjYJJO8IB8+L3A28rPif3tndKm4DrWEjaLYNzJbfk2nY12VLSzIgApxw9pf3Es2vubl0d T0fnoy12qDN7D75ASstI0WO8lXP3ogab4Q3VAFi/TLyDMmP6lozAMlF74ecvAnl/DjBDzFAVS0I nyLkdUVPaUsVlhufM3J/I3S2kLKimCRVEfho7FP1MtAy81+LIx06rLrH27swvyRa98FfkdCFHBr L10qT7jYDA/adaIUnTHkIqPKqN4msKrQuHiFY4p5QLE6B0/R
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: rfkubjtrh5q47nietybxd3zqat7erbup
X-Rspamd-Queue-Id: 015DF40010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774518984-962357
X-HE-Meta: U2FsdGVkX1/8rytorcEdZLeDQwyfH0kuX2ILxjgMxNu59/8ayF9h0Y9JkuN3bgqJAuWpDM/4tKBcBvrnOLZNfcsk8l7WojPIhG9EqgdA2XsiRLt1KjZkqdYjVGpXdagDhakxBeD3tfpQ3XJ/RgD21B6a2oJbGyqDuPpTBhcLK2/xjBe6DzBMjlxdLvfnW4vAi0uSTVgSUo1lGOUzSC5fs2aYVux10s2a6gvsYVhYTphPybG3XlKNU2I1oVz4aRwwScwSkWud8Qoa+ByZ71B88cKoI3MLXv3d4SHDSv+kINZM8zLX+nwG6+XfzQDS+oadSM87xOlq7ndsfMuayA5jvXP+nE5eiutnNL2htXRfxHuJr7oYdjBhbmhW+/wDg80KUzVscYSI1TuQr9ijvoO8+fw0M8txyYgZSMk98qAuBLvADYuHfGGzePQ/rbZgRW6hp2Tttt+JOBM+mwTAcjozgGkM4wa8YoEQJ4Dh/flrPH1jFHkS1IrWZnt6y14H/8GyUrZ9pSGvb+oov3f1QyN4eqr2pAPMA7tsMUCW0m9dhCG0ERospOW+6jjC3G8Tt2mI3OLEsZ/s1ubbHMt4ylhI3DpTMM5ihR4IYXeoUJZasXbipJxa06PourzbMDpXR0O4ctdbQnH+fYrf46WTV9urQ2vCxqEJbtuSDeygYYawFmgD2ub99u0NjqwuDJSh3c7iFX9x9Yt1BSW6vcp6VvdBw0i//AxrW6PYS8CiaC7h/5X/GfX1X+3hXjVE8bM1dRahkibwG0t+zQUd+RHuBljiZ8bp5m8CTbQb51F7UmIaxaL+GwAl2SgZj6jTDQWq4s4FcnDHq/qyD9yukGkivN4kbF1GMx9S1FNUxtkc71mXtxZUFNfxDZKIIWizelI5gP7MlvQi6Xe9eEBZWUd7wSzN5amNEkNrv9xCjqKKpwwm8Hgmn2CkEc5lhtIZc+U3ANL8tMRfUULUWLQZ/Ci/2Yc
 w++Xc36u
 PKIgDt9p5jC+zZH0KkziAn5ShMEf9SfWNcSbkelb0ZljnWeSLU2Aa+jhwcV5lsoinyCNn1PGVReMR2Q8uTol7aMc7WQ==
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


