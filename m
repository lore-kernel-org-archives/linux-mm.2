Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D05CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 15:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2796B008A; Thu, 25 Jun 2026 11:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254386B0095; Thu, 25 Jun 2026 11:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1412D6B0096; Thu, 25 Jun 2026 11:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDDD16B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:39:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C0B51C0E37
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:39:09 +0000 (UTC)
X-FDA: 84918843618.01.72C12BC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2137E40005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:39:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NwRAVRXu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hqJZSBG+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SaBVehSy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="0rYclu/v";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782401947;
	b=EZ3tFBbBo+GPqyMhQd+hJ81YPtWZHL36fUpUzmKbNz3vaeYmCo6VQcV3aAsd0QmmzjBWeP
	GqZDsV5/xfBUU1dyarcrlJUlBGHXK3VpAqz6e9sJoCVoyb+6sujyh5c8K+zUuU2y8DrYpl
	wAqxWmwbhPwX6+Pj/GV0Qr4X5fNnk3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782401947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3DH1IpOREXh9R036qQ3fgOrNp9Y/tCMMtgQvXveSOHQ=;
	b=pPOYBd222Sp6aaxhmt39KGjONEZIcMVyFF53JAemADThr4S6VoWhpvFy6JzHJo3yfcbT7a
	sNffgXbFenJyv0tAow4nbHcYCGnRdWthxwCDFvlCBhpNFoaCV2AIuumG4qdf28JmsDeJaT
	VM2oNDb+UtyzV1OBeOlgU0CXG0VZFqU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NwRAVRXu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hqJZSBG+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SaBVehSy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="0rYclu/v";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8EE0D71C28;
	Thu, 25 Jun 2026 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782401945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3DH1IpOREXh9R036qQ3fgOrNp9Y/tCMMtgQvXveSOHQ=;
	b=NwRAVRXutpXL/pdBgzbmyaYn4uUz1RhaPMZl2P2XObe0JzP7opZP48clrsGBdO/sQLMmwm
	9dOmMalIjTzOa8I/ci3wKXhKZmiqN9tljD0OfuEOAEzPm1th8LZlHkWU+PIB7yVoT4HKRv
	Pvkq3Oc8qU2sLrynhJ2AKMbM99eq028=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782401945;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3DH1IpOREXh9R036qQ3fgOrNp9Y/tCMMtgQvXveSOHQ=;
	b=hqJZSBG+e8rDq7//e/0MGt3NNk9o0QiRh0VCPaH5bOMkmTSIKAZHMSseJkjU472br+6XLr
	ghNqhbvDKt02GpAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782401944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3DH1IpOREXh9R036qQ3fgOrNp9Y/tCMMtgQvXveSOHQ=;
	b=SaBVehSysMnqbJJQlnJuef9R/gjK3tLrl64AB6Tb25BC9SWcTMFTVCXaDuI1vqObtLswb+
	s79GV8xJLTDKMvhvMhD+J544aMGzE6JQF35qpbvutr8GiWjyDAF2tdVAB0TRqHZAthqQOI
	ucjmzUFsI6w9CZxa+W/6o7gWzT+giXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782401944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3DH1IpOREXh9R036qQ3fgOrNp9Y/tCMMtgQvXveSOHQ=;
	b=0rYclu/vu2zoQTYtbYtT/46cwy08fQTH5uJ0FqbiMoyPwr7w1ZwPIvdpKRF9Y9L9hLbk49
	CBKS986j/lCshnDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 984D6779A8;
	Thu, 25 Jun 2026 15:39:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dJWvIZdLPWqvWAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 25 Jun 2026 15:39:03 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Falcato <pfalcato@suse.de>,
	stable@vger.kernel.org
Subject: [PATCH] mm: do file ownership checks with the proper mount idmap
Date: Thu, 25 Jun 2026 16:38:53 +0100
Message-ID: <20260625153853.913949-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2137E40005
X-Rspam-User: 
X-Stat-Signature: 5i3hq55s1yn5ha6qzn8bj79gysqwbz73
X-HE-Tag: 1782401947-718960
X-HE-Meta: U2FsdGVkX1/qnvrsxid9Pi3aK2EX7mjFPWY4RURqkhGbxWVFr3b42ZsnN8smyldUgmHK4xiZ1KYHcVNluUS2denEtpl9ZDXt11ds4lG87xjx25BIMxDkZvEib/cJxm+BQhNZFghy5pOyJXYkarUzdTPdnrLVajypwqrbg03k1CYUwjmdtHyIG4HMU5PyNcCbrC7u1Fu6ok3u2f3CzzuzoJMUtcwhM39K9mB0R7CgULuzF0qs2CmWNCgU5texNHqEZ0ZeuVVdUfap3dFNqrH+/BRoe8IR84VWYCCY904khg0tkht16yiFqNWh7wUi3cWPCexWwiE6XqTxxPEPjU2NMsBfjSDBOxL0bt1EtRhLdc5orxDtYwXtnI3YMGzWQziwLvPH4LnGBhPvhbO5DoHC1KFeylQsbl2fTeqZnIeZfBcbtqb4gdyO7WWo1rqIxmDxSI4VUc7rxrV4Zna+iOe8Zs1pg68AgFJ64Ia2nThsZkjb+cr7HYNR26do5NuGHYBQMyL/UK3ltw8CosmZODstGCYtq6pFw/sunQq3NCfoVp51wlbPFf9U0zbWx6MnL+lF27Xic2QVFZfry8KjiSUruzF37e8gOAw8RvQGuVXzLyG7nox97InG9m2iwdjy3P0QYgGD92/EAQm/czE9Qns6q2K8eya3pNkALYpmEpj4UDvD8qZJXn1vsX2PDW++Yssdb5ahvflCtgR2aNXHWcXp6023OnJsuDXZ5IXoX5mpgXxWgPikhsxwepgz6iyHUM3PsO/rkChuYuTFG9xp2DYz+peikswqahZFKLr3a8puqzJeYiZRGPUof/+fhte7emIcGlOjXugVej8Q1gr49OGNmau6nvPPkOEb6QAnrGvJy1Gkd9lCkVcdf7sGwuYktmLWQz0I/Jy54+W3KEJMtGqh2QbWemqLzQa4Xl8L91qZC42/DVeA6r7NPDCbOcC0S4Lq1+i5zgYmWb7ZMWZEDAq
 O3XWRkp4
 eUkBKLwZsnyLqJYw6qbUeKWiYTiugnYWNfGTa+OIkNoxCvmjO/uiK678sS7j+3pf9kjpgKMWBrZJL1CEvIOOUQvroE7jNRAX9F0O6eBRSlYf9k0b5Fm/r75peJcSR6pmOpxntlSOG6FkcaYpsyc/8lH13wWhpPXSJfhZ+Zk3sxYtvHRQBNkB56ySAjIAScQMGScASarQVMy4Z5iPR85CUUB4Wxejpqquj7rAzOoWhJJsFGGm2vaoh6ytdIFQ2oNeXfKb+EmKO9+s6HGyQFhuL6ZKqdRT6V1FUC26r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since idmapped mounts were introduced, inode ownership checks
(for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
done against the nop_mnt_idmap, which completely ignores the file's mount's
idmap. This results in odd edgecases like:

1) mount/bind-mount with an idmap userA:userB:1
2) userB runs an owner_or_capable() check on file that is owned by userA
on-disk/in-memory, but owned by userB after idmap translation
3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied

In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
idmap internally, but it does not need to be the case on e.g a 0444 file
where even the owner itself doesn't have permissions to write to it.

Since this is clearly not trivial to get right, introduce a
file_owner_or_capable() that can carry the correct semantics, and switch
the various users in mm to it.

The issue was found by manual code inspection & an off-list discussion with
Jan Kara.

Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Cc: stable@vger.kernel.org
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---

I noticed there are a couple of call sites in fs/ that could perhaps be
cleaned up with the added helper, but I'm skipping that for now for brevity's
sake.

 include/linux/fs.h | 5 +++++
 mm/filemap.c       | 2 +-
 mm/madvise.c       | 3 +--
 mm/mincore.c       | 3 +--
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d10897b3a1e3..50ce731a2b78 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2444,6 +2444,11 @@ static inline struct mnt_idmap *file_mnt_idmap(const struct file *file)
 	return mnt_idmap(file->f_path.mnt);
 }
 
+static inline bool file_owner_or_capable(const struct file *file)
+{
+	return inode_owner_or_capable(file_mnt_idmap(file), file_inode(file));
+}
+
 /**
  * is_idmapped_mnt - check whether a mount is mapped
  * @mnt: the mount to check
diff --git a/mm/filemap.c b/mm/filemap.c
index 5af62e6abca5..58eb9d240643 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4704,7 +4704,7 @@ static inline bool can_do_cachestat(struct file *f)
 {
 	if (f->f_mode & FMODE_WRITE)
 		return true;
-	if (inode_owner_or_capable(file_mnt_idmap(f), file_inode(f)))
+	if (file_owner_or_capable(f))
 		return true;
 	return file_permission(f, MAY_WRITE) == 0;
 }
diff --git a/mm/madvise.c b/mm/madvise.c
index cd9bb077072c..77552b03d318 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -336,8 +336,7 @@ static inline bool can_do_file_pageout(struct vm_area_struct *vma)
 	 * otherwise we'd be including shared non-exclusive mappings, which
 	 * opens a side channel.
 	 */
-	return inode_owner_or_capable(&nop_mnt_idmap,
-				      file_inode(vma->vm_file)) ||
+	return file_owner_or_capable(vma->vm_file) ||
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 
diff --git a/mm/mincore.c b/mm/mincore.c
index 296f2e3922b5..c8757c5085bf 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -227,8 +227,7 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
 	 * for writing; otherwise we'd be including shared non-exclusive
 	 * mappings, which opens a side channel.
 	 */
-	return inode_owner_or_capable(&nop_mnt_idmap,
-				      file_inode(vma->vm_file)) ||
+	return file_owner_or_capable(vma->vm_file) ||
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 
-- 
2.54.0


