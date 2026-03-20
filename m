Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3069710987AF
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8826B00A0; Fri, 20 Mar 2026 12:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980BF6B00B8; Fri, 20 Mar 2026 12:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDF26B00C5; Fri, 20 Mar 2026 12:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AAA76B00A0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:43:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 211A413A507
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:31 +0000 (UTC)
X-FDA: 84567012222.14.4700C13
Received: from toronto-edge.smtp.mymangomail.com (toronto-edge.smtp.mymangomail.com [209.38.81.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5D586140002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=s4JMMpLI;
	spf=pass (imf26.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774025009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1z4EZkU3hfJQofS/LDV30v6HLPNLGEIDJUPrfGbrKw=;
	b=cFMg8S922b5mbNP/sqPR3M5E8z5ZcichFSMrYjlKB7z/mxn+d2QGQSIcWAjAeJhaIYSmfJ
	H86rfl42hyRbFC+WSipITc9phJaDu80vIeNp2+M4ADldhvA4D1OkRURycgIsr/mEnJerSY
	sexm2uqF2K1CoYZMFL6wEZb29XFTyos=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774025009; a=rsa-sha256;
	cv=none;
	b=Hekdmdk6iPJEO08XxF90ncoEz13BptJk3SKH0a5IE51khxIo1W85/odTdMlRxKm/kcZMQW
	7DLrxHSyG0vSJ/f6o5vM0qPacc7pF9KA3m/INn241rpJSJA2kxDBhmXuKXsy6fERcS0e7S
	IGZbUDlyY7KBQnsmpRQRUg5bWsYy9j4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=s4JMMpLI;
	spf=pass (imf26.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTP id 0DEFF5F42D;
	Fri, 20 Mar 2026 12:43:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774024994;
	bh=u/53CXeIQwpaCO0/ObR0JkGhc5pmW6NGabn8LdjoAx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4JMMpLIgq5X05nmJTKspuN7lxap4g9KpDg+VGCPrv3DVE/BYK3iSNYrXZjTisFBS
	 5f0ofj9asGTjIuc8IBEhp0n02kvoFh1ydRdyJjzrA2Ekj0JjV3blkBHrvjcKc6PoNG
	 wXHWxfBJNopmD6bCmBwacuVx4URqQ3+vxp54CEdo=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
 server-digest SHA256)
	(No client certificate requested)
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTPSA id 6812E5D9B1;
	Fri, 20 Mar 2026 12:42:00 -0400 (EDT)
From: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Subject: [PATCH 4/5] liveupdate: validate handover metadata before using it
Date: Fri, 20 Mar 2026 17:37:19 +0100
Message-ID: <20260320163720.100456-4-oskar@gerlicz.space>
In-Reply-To: <20260320163720.100456-1-oskar@gerlicz.space>
References: <20260320163720.100456-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5D586140002
X-Stat-Signature: nk4w3zjsc988uz685supeoocc6hpun4d
X-Rspam-User: 
X-HE-Tag: 1774025007-544681
X-HE-Meta: U2FsdGVkX1+wTlqqlqofCwr8cXiDXXpuskfrYS00vM01/I6THR4Bv3cLC3lDIZhmrQy9llCM1rmjSkVKjIvqGotQnsqckxPlXEjHl1QrDPBDeB/uMJxM2KOXMqjlYv7D26wTWdPMdb0ghi6jdLnn6dEz9mcCBZaS47zz4bNZkr/fgpZU/y05N8PfKJhUqDBa1pt6KHIkD5CbdTY6r92HZD63FfrS6UC0WgeO5q3/b0h/45dhi5+rl3ygccFgSxV6Y7jGfoWXw4e0ngg0ZNdKKcESlF8oMY4Q1z5oirVT0sjQcdXhRHBgLM/HMjZBzHQxAwwwcqcTpRN3y2uvPpdHOxdSqPK5KF/0DKaQyD3biXUV/9sG4Fq/4JerkvmvfBdMlF8e0JnmcE6l7vs5Ch1KCtwIhCcHqCwJA28XCl8d7Jev6FZ+kJYGCJYu/STCKQn7iywsCt3rmWQXoQLKSjgXZ8sLsj066TlStI2Du6/iO5WDTKufkhxVX8H7OR3zX0yQBzQfoNpms+zqQi1zFMRrqUXevY85/NRtRQ4tH5AVNu+suygxeDTchu5hvNQR/MqZsbr/KzQ7RMPhiHm4kAZ+ZoPSw/CkDZWS3p8g/78AbZX1FvJTWA8qyDi5DHw1n2aRM53zplw7srxs/mj7stgKfcJ1L768pk3D+5wXIgUKyZUCZQPVFBpU8FRJVHqk78gD5TqImR2htO5ylolUF1jnURKX2hKQJNo/CIHzT4nyA+O43vH4b9v0gIMrdb9iNm4zgbyERRXfyJzJunrx6+awcX/xMZWxdXXohvGpjbdUT+LoamNipZ3OeIW6DpYQqQMsJvQjy4xoRrpvRzGsnBtewFWCoGs/XR/Rm2LeV69YccA8rXHV6u9DcTuLjSTMsVq+aSPtoI7iNhsVwYO9cRVZNKwg5UGehdEjmtCkw2irAVSSIRluBbBfZ1gcJdXB8KS1RN7OKNNDpj5sr6605c7
 GCsm0F7X
 TnMokHzGnM9pIyJwVHxfRnDQZl23DVZ8F82ZnpSirXNVIkKai8qvzlmK4dFqYz9AuCDNa4cx6jREPz/C6RFpsgrX7Nnjy0bxVr2Y/No8O6e4oe2XkHEekn5S+5ZcTvfgnBNETWPqfQGp/VxylYG2vEyN/N1DKuvkbChJZJUHpNhuUbE+kGj6yu3b+a9BonKJHPWvJBmm3NAskkRWPzWRGgLVc1jwt5/YmNI3gLZACuHj5dtXfwpNh2DAlHhZbxFWHbHI8Qzmxk5JTEz0FwpOuCME5kS9uc9cdPBJXjyeaExtb0kkGmG1ci3VdNh+7q9hAFgW+oagcS1nFbkczzU99v3EB5vOEO71jNtotAbcegLI4MWlJJJMK2FQViQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The handover restore path currently trusts counts, strings and
addresses copied from the previous kernel. A truncated or corrupted
handover can feed invalid header addresses, oversized counts,
unterminated names or impossible memfd folio layouts straight into
restore code.

That is dangerous because it can turn a bad handover into
out-of-bounds iteration, bogus phys_to_virt() translations or
inconsistent shmem state in the new kernel.

Add cheap sanity checks before consuming the metadata. Validate
session and file counts, require non-zero serialized pointers when
data is present, reject unterminated names, sanity-check FLB headers,
and make memfd_luo reject impossible folio indices and unsupported
flags.

Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 kernel/liveupdate/luo_file.c    | 19 +++++++++++++++----
 kernel/liveupdate/luo_flb.c     | 14 ++++++++++++++
 kernel/liveupdate/luo_session.c | 16 ++++++++++++++++
 mm/memfd_luo.c                  | 26 ++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index cc0fd7e9c332..94d49255115d 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -765,10 +765,14 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	u64 i;
 	int err;
 
-	if (!file_set_ser->files) {
-		WARN_ON(file_set_ser->count);
-		return 0;
-	}
+	if (!file_set_ser->count)
+		return file_set_ser->files ? -EINVAL : 0;
+
+	if (!file_set_ser->files)
+		return -EINVAL;
+
+	if (file_set_ser->count > LUO_FILE_MAX)
+		return -EINVAL;
 
 	file_set->count = file_set_ser->count;
 	file_set->files = phys_to_virt(file_set_ser->files);
@@ -779,6 +783,13 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
+		if (strnlen(file_ser[i].compatible,
+			    sizeof(file_ser[i].compatible)) ==
+		    sizeof(file_ser[i].compatible)) {
+			err = -EINVAL;
+			goto err_discard;
+		}
+
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
 				handler_found = true;
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index f52e8114837e..3672cbf8e075 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -165,7 +165,14 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 		return -ENODATA;
 
 	for (int i = 0; i < fh->header_ser->count; i++) {
+		if (strnlen(fh->ser[i].name, sizeof(fh->ser[i].name)) ==
+		    sizeof(fh->ser[i].name))
+			return -EINVAL;
+
 		if (!strcmp(fh->ser[i].name, flb->compatible)) {
+			if (!fh->ser[i].count)
+				return -EINVAL;
+
 			private->incoming.data = fh->ser[i].data;
 			private->incoming.count = fh->ser[i].count;
 			found = true;
@@ -609,7 +616,14 @@ int __init luo_flb_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
+	if (!header_ser_pa) {
+		pr_err("FLB header address is missing\n");
+		return -EINVAL;
+	}
+
 	header_ser = phys_to_virt(header_ser_pa);
+	if (header_ser->pgcnt != LUO_FLB_PGCNT || header_ser->count > LUO_FLB_MAX)
+		return -EINVAL;
 
 	luo_flb_global.incoming.header_ser = header_ser;
 	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 77afa913d6c7..9a08e9794062 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -542,6 +542,11 @@ int __init luo_session_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
+	if (!header_ser_pa) {
+		pr_err("Session header address is missing\n");
+		return -EINVAL;
+	}
+
 	header_ser = phys_to_virt(header_ser_pa);
 
 	luo_session_global.incoming.header_ser = header_ser;
@@ -565,9 +570,20 @@ int luo_session_deserialize(void)
 	if (!sh->active)
 		return 0;
 
+	if (sh->header_ser->count > LUO_SESSION_MAX) {
+		pr_warn("Invalid session count %llu\n", sh->header_ser->count);
+		return -EINVAL;
+	}
+
 	for (int i = 0; i < sh->header_ser->count; i++) {
 		struct luo_session *session;
 
+		if (strnlen(sh->ser[i].name, sizeof(sh->ser[i].name)) ==
+		    sizeof(sh->ser[i].name)) {
+			pr_warn("Session name is not NUL-terminated\n");
+			return -EINVAL;
+		}
+
 		session = luo_session_alloc(sh->ser[i].name);
 		if (IS_ERR(session)) {
 			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b8edb9f981d7..75f3f7226e6e 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -394,10 +394,15 @@ static int memfd_luo_retrieve_folios(struct file *file,
 {
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
+	u64 max_index = i_size_read(inode);
+	u64 prev_index = 0;
 	struct folio *folio;
 	int err = -EIO;
 	long i;
 
+	if (max_index)
+		max_index = (max_index - 1) >> PAGE_SHIFT;
+
 	for (i = 0; i < nr_folios; i++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
 		phys_addr_t phys;
@@ -407,6 +412,18 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		if (!pfolio->pfn)
 			continue;
 
+		if (pfolio->flags &
+		    ~(MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE)) {
+			err = -EINVAL;
+			goto put_folios;
+		}
+
+		if (pfolio->index > max_index ||
+		    (i && pfolio->index <= prev_index)) {
+			err = -EINVAL;
+			goto put_folios;
+		}
+
 		phys = PFN_PHYS(pfolio->pfn);
 		folio = kho_restore_folio(phys);
 		if (!folio) {
@@ -415,6 +432,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 			goto put_folios;
 		}
 		index = pfolio->index;
+		prev_index = index;
 		flags = pfolio->flags;
 
 		/* Set up the folio for insertion. */
@@ -486,6 +504,14 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
+	if (!!ser->nr_folios != !!ser->folios.first.phys)
+		return -EINVAL;
+
+	if (ser->nr_folios &&
+	    (!ser->size ||
+	     ser->nr_folios > ((ser->size - 1) >> PAGE_SHIFT) + 1))
+		return -EINVAL;
+
 	file = memfd_alloc_file("", 0);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-- 
2.53.0


