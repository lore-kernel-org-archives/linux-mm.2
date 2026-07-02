Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB7D4C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B63E6B0183; Thu,  2 Jul 2026 21:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E0A6B0185; Thu,  2 Jul 2026 21:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3996B0186; Thu,  2 Jul 2026 21:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E69706B0183
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:10:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F7A11C69F3
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:54:18 +0000 (UTC)
X-FDA: 84944434596.16.A0EC357
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2AA56160005
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:54:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1izVBK4n;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6uTqBlzX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i80g1EaL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=O61y2J9V;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783011256;
	b=1e8VhVDwVDkLXZJc5bRvmFXu9P/u/L13baPU+BZksaTUyzJO5is9S5nc1wF7PTfGi/htL2
	XVuimYSqELHAW/VhATkfayhCs+9lFVr0OsKR+8R8vhAmhtD0sa7T7IaczHFUtwOIColA/E
	bBKPZAm/4yRNy5SiTF82QeO/V4oOi5s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783011256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=heA6NlsuWwAqm6a7CgrmaEXikzhssH3mg744Z6Vx3HM=;
	b=WkNz3b4UG2ie8bkLPQ6Wcp28YXLTE1+vlfWl//Sa4Fy7GA/BcHxbVXoBCsXSCUs28msZ4X
	WkuXOaHa8On+L06dbGoKqIp3WVFEefPkLrMmsgg3GMprSaKNK7Jonl8wr3RtQjXWq7VSWq
	qF9Du54BWRUcjE1afwGGZ8jB5hjiWGk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1izVBK4n;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6uTqBlzX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i80g1EaL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=O61y2J9V;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7658C75FB5;
	Thu,  2 Jul 2026 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783011254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=heA6NlsuWwAqm6a7CgrmaEXikzhssH3mg744Z6Vx3HM=;
	b=1izVBK4nVCJ74vk0GUwiMAv0GlH+Ps2ASXq6SqAYaeWjK8PW5ZlWd6OSAcLlqMtiVIBUEa
	cSd5oQV9mUQl3GWMrCCyaTZEx4FPCpXWM4uBLp7hZkonWn/RY/aHQdxawvRDSs2mPlViDV
	SrKqtCd+GWMLNwmY1EcWQSfqqOJgTUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783011254;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=heA6NlsuWwAqm6a7CgrmaEXikzhssH3mg744Z6Vx3HM=;
	b=6uTqBlzXnUFP3mTmChLkBqe9bSn2aV9bO5GZPaSJwxMPe2hHKRPdjxwC+vZWd4zUAyunz+
	VMNDWuCVoSd9ROBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783011253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=heA6NlsuWwAqm6a7CgrmaEXikzhssH3mg744Z6Vx3HM=;
	b=i80g1EaLCR84t4GJZWPKL6QND00ecxXrtiK9z4q8TQS+NWQohgoAxa1kY0V3lE8MaUmP8v
	W+i9mEj6mJepcuqBJ6gIqD3NXTlMfhAnx1iU+B5UithgtQwzoP6850iPelgEugyd/gM4ZW
	xkQ+27Ttbg/+EogYLdaQToHHKmrNSDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783011253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=heA6NlsuWwAqm6a7CgrmaEXikzhssH3mg744Z6Vx3HM=;
	b=O61y2J9VlyCj+9OmiKJmZFL1QCLCphSXO1xaHSug75JaSqB+QWHtxr4oIESNxRBIWlEZoA
	4DbvtMoAIhZYetDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F384C779AA;
	Thu,  2 Jul 2026 16:54:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HYAEOLOXRmrqQQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Jul 2026 16:54:11 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Pedro Falcato <pfalcato@suse.de>,
	stable@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Song Liu <song@kernel.org>,
	Eric Hagberg <ehagberg@janestreet.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregg Leventhal <gleventhal@janestreet.com>
Subject: [PATCH stable] mm/khugepaged: write all dirty file folios when collapsing
Date: Thu,  2 Jul 2026 17:54:09 +0100
Message-ID: <20260702165409.164568-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2AA56160005
X-Stat-Signature: ux75c5j3w33ggp861cmpn5g534f4gzzy
X-Rspam-User: 
X-HE-Tag: 1783011256-713488
X-HE-Meta: U2FsdGVkX1+mEiKLYV/mPmUUJlu/qgHVbk5zQmr/i9DJw5wEWOiXGKTWpKVRluC3rPFCBC16Ol4L3RF+GraUI1UCG6iQLqfP0UnyaNH8KUdDY3xnYMLDgM7Zm2Y03P+0qyo5MGDpWYUU1CHd7eLjKaPRmw1aRr3EmdVKjDZZt9C1OGb2aFmWmeesMskZeHAt3zhxREZdM8xw0DxanE74gcbWP8czVg6B27OJgJaJsP7VJKj+3sGFLf2IVVDDzxF2S2NlfBlHHx7tsfP6+dM6PnqYusX9LO/8Z5csX8nb12Qpn49D0LesA/jAuH7pzPq5MdBoCkXQ4HyFSIYkjl5B33EPOX80UN2HRYQLTeJBfFXSSX7sl7zHh2CfBeGTiYLaw0kH8j2vtp0bC+xWxDg+GGOHKQXs7uM551sBvBC259ASbvwFljXEXn9RJWaLPyr0Qjh3oM7SSU6el4QkCvzmX8t80PlrFWe14f6sVasW+6z9nyt1bjhsyRd6Ph9pSpnKrqb9UCuaz1o09P1Uj0mU0wEMCPViMZjaJ+ImMkG4yZQszwVzcX+fqL9QitMebh5cJWSFIAdXLJs1vm6VRsfWPN04xRpTPVKqOW2hAtLc30a59UkgsOzv8AR5SAFCcKCiX3CGVM5Q7EpbUVicyv/QCYmQcxb27C8t0V59kP1mh+TrvkaSeWXF6fIppd6igyh0dtiUY9XmL2ngJg1gPRKifRQCPy5M+wWmIrjPdolbJKeRmPCfT91+MnwoT9W2rEJ10DPbAIijbM84Cfqc2Tjix4LkK47DZgURLnUkBfMYuJBYKg45SY5jT68TdX4n2QqQvlV6T1RCwY8uy/36wYI9dq4ppwSqAmMZwfW7yBks9PvmJSHDl+S/naPuaqqW2mJYUbzrpYleNL2mmV9QaFbEY3tnghBxCI3Cdxa6g1+KF4dxxTOjUPGBHVFRwsoD0L2R4Xz0otmgy7u5Y88wQRc
 UGgfAcmB
 Ep46jyTtArmODWaG3E2+ulgiILB0H+MBQzCYvqlZY4RqDQ8NWdZLL8TQZegCsZDuEtMVtyPc2iAVbSY8O+ek8qOYrm7drxkLhtbF0eLfHsC+LMDmZ4ov1Spv+ARQBMY6r0Q1/WdXOM1EiszG9evdFEvcMBbJlLXMIvn0QzOS81QfhtLW+j1yaaF0hUR915g6YrckFYFMePhSXkcI79wGNINn8x8xSIe8LC3tUNSemju2zfa7GVBoguj4mRcGsDRGuISak4/Yas+7V27inVp86igYoRP7MYEJUZhg5wH+VEZZ/ik4n1jdPTvNEr3lcN27jW25VZaxVASPceheOPOjZRsowYsk1oOJJjFic0Err9Nw31VzcBFhHeXYN5TzlDlpXoSL3uIqEWc4msTzRXDcOs6ygLyjkjq9W/bQ3t1z1/FT1Qboqcb7peHJJehesRzyEe2IOHbuuvl9x4bbE7ahp3MAS5SDedoUWofY7mM+sPeVqX3eG0M2y+QQhNPJ2ICbOZiUv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As-is, khugepaged and writable-file opening exclude each other. A file
cannot be open writeable and have THPs (because the filesystem is not aware
of them). khugepaged will never collapse file pages for files that are
opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
particular file is dropped. This is fine because nothing could've been
dirtied.

However, there is an edge-case: collapse_file() might not be able to
coexist with concurrent writers, but it can coexist with dirty folios
(from previous writers). Therefore, the following can happen:

open(file, O_RDWR)
write(file)
close(file)
madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
open(file, O_RDWR)
 nr_thps > 0
  truncate_inode_pages()
    /* THPs are cleared out, but so are the dirty folios */

When this edge-case happens, there is data loss, as the dirty folios are
fully discarded.

Fix it by fully writing back the page cache (and waiting) when collapsing
file THPs. Doing so provides the guarantee that no dirty folio will be
observed while there are active THPs. To fully ensure this is safe, the
invalidate_lock needs to be held while doing the writeout, so that
do_dentry_open()'s page cache truncation excludes this write-and-wait.

Cc: stable@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: Eric Hagberg <ehagberg@janestreet.com>
Cc: Zi Yan <ziy@nvidia.com>
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
Tested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
This patch is written against 7.1.0 (because the code no longer exists in mainline).

Zi, I kept your Tested-by, but I had to move some things around and
use the invalidate lock. Please re-test if you can.

 mm/khugepaged.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..0707d719a270 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2094,32 +2094,43 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		goto xa_unlocked;
 	}
 
-	if (!is_shmem) {
+xa_locked:
+	xas_unlock_irq(&xas);
+xa_unlocked:
+
+	/*
+	 * If collapse is successful, flush must be done now before copying.
+	 * If collapse is unsuccessful, does flush actually need to be done?
+	 * Do it anyway, to clear the state.
+	 */
+	try_to_unmap_flush();
+
+	if (result == SCAN_SUCCEED && !is_shmem) {
+		/*
+		 * invalidate_lock as shared excludes against concurrent opens
+		 * in do_dentry_open() truncating the page cache. This is
+		 * particularly important if there are dirty folios in transit.
+		 */
+		filemap_invalidate_lock_shared(mapping);
 		filemap_nr_thps_inc(mapping);
 		/*
 		 * Paired with the fence in do_dentry_open() -> get_write_access()
 		 * to ensure i_writecount is up to date and the update to nr_thps
 		 * is visible. Ensures the page cache will be truncated if the
-		 * file is opened writable.
+		 * file is opened writable. If collapse looks to be successful,
+		 * flush any dirty pages out the page cache. With the nr_thps
+		 * incremented, there won't be any new writers (nor new dirties).
 		 */
 		smp_mb();
-		if (inode_is_open_for_write(mapping->host)) {
+		if (inode_is_open_for_write(mapping->host) || filemap_write_and_wait(mapping)) {
 			result = SCAN_FAIL;
 			filemap_nr_thps_dec(mapping);
+			filemap_invalidate_unlock_shared(mapping);
+			goto rollback;
 		}
+		filemap_invalidate_unlock_shared(mapping);
 	}
 
-xa_locked:
-	xas_unlock_irq(&xas);
-xa_unlocked:
-
-	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
-	 */
-	try_to_unmap_flush();
-
 	if (result == SCAN_SUCCEED && nr_none &&
 	    !shmem_charge(mapping->host, nr_none))
 		result = SCAN_FAIL;
-- 
2.54.0


