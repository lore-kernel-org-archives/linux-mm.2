Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC24CD0408
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 21:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2ECA6B0095; Mon,  5 Jan 2026 16:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06326B0096; Mon,  5 Jan 2026 16:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26F16B0098; Mon,  5 Jan 2026 16:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2CE76B0095
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:19:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8142056DEA
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:19:03 +0000 (UTC)
X-FDA: 84299175366.17.AF911BD
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9037F4000E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:19:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mv5GI0h8;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767647941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5LAxK+AjnG3YzNOBaLOPsRos3hCuelykUfVzgLenNc=;
	b=7AUIY5wHkPmb8Sfkx3AAG+iHZeJEa4Zovj7LDI96R4GFJ+50LcLdtTCkJTaLXXtCJr9q2T
	ktCGl8Demmgpni8uPudnUwo/6F8uF/L7Dv9EYzQJ5DYUdanJW8lBYXieNosyaXAm4Bkzld
	gzDBqrVUHWdUBeRrQ27kImWn8Rf8u5E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mv5GI0h8;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767647941; a=rsa-sha256;
	cv=none;
	b=20sy4ujSzDStRrbvIIbsq0wXbwc7mB7qIKttmVsFahJxVES73z5zfudXaRub5Aeoj9tYTo
	NJLZnrQACNOa/DlPUyX3dKhCMLwcxxonAYQDdMkC1QFHTg4/Kb/feo7DyyI5vsEwAAh15+
	XWMVkHsYpWBh0ObKNtzyCQ+/2KQ1Neo=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29f102b013fso4368135ad.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 13:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767647940; x=1768252740; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5LAxK+AjnG3YzNOBaLOPsRos3hCuelykUfVzgLenNc=;
        b=Mv5GI0h8MHvQYiXC9MJh3nCFx/fHtCb05kAFLD6BHvx7yZishPX1s1viZqaohdtHe1
         WkTCaNElPR7pJpzQnbJnpyzzc1kCC+zS7jYNUWyvAPD5J2fGpwPEpbSkLIyTi6HwQXey
         RcOrinaiqhAA4uWKZlORlprfcTQBUtevfcl+8LVU62bbRo7LRM6WLn2Pe6BKz0btUiQ2
         dWHMQVKo7iTRAXNVbXX0VBo7UVJzl1fd0JbbCFZwZwAMKgHtM7jXn9xvM7VGkNxAJmtj
         e0L855nHpyOKCxazyvBcwRWyyi10DCZDAReeip6yjMQzmh8DTqrU+182klQWDwVyp4XO
         etzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647940; x=1768252740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x5LAxK+AjnG3YzNOBaLOPsRos3hCuelykUfVzgLenNc=;
        b=W62QlTeV8p6MKL7mEB+QH3jiRJ7AdkcMLMSs0TQxSAQGNiV0dUblWzejiMeCacptN/
         Pl3sM2TFyXYbrujv0P3284Ll+s15J8rIpWERiXWW6E/qwCs2q7TSEy6Yw0GnEnYijs1j
         iFiQmR3h7/3Qndobj1qJUh05icDACiI77su55eDby8RNfmIaDBKESXYP3PV/uZSO6EcV
         MYxyJWsTelz7xyT5CufbSZP/BouTa2OYiJm+aFWdFGskeGH0K8TTEgrUvqnm8dbzMp6+
         xj1W6qSRu5tQJ78sFXtEZqPmDAt6Oy6QF2yRKey+c62GVFOHVSG2m1BJV8orgq/ypA4v
         zBww==
X-Forwarded-Encrypted: i=1; AJvYcCUC+/R+J5V1QwOpYLTHp/tGtnrWYHoI8XHaiUZQ+P0Jr+wFIQlsXLQVigIegRQzBlUmt512uIkcDA==@kvack.org
X-Gm-Message-State: AOJu0YyYgGwffpqGTTzbjIP2dFzuaFJir5aQcbniEBkK/xiYPlM9HNYE
	QcrfAj0j38aK/UdlS7fqvzn+zzrZUA6er8PoW8al9RKO+9oDwIajVU60
X-Gm-Gg: AY/fxX4hZByC8SozgDV57A6HZaMsmDYsq8OdgBriNHzzOpwRXXb2oYvEKdJaTi9wH1m
	KBpCudS8fGofXy2Bnu1rHE2FRpXUZy592UDRsClvPUmLlnUwDCWR2mIh0euzEYUSb0h9m00ga27
	kQ5bb4zqB/tp/gdBcvbF8I7zCVZ5OwBNOmF86ScvOEGK47pX8TR0lu0mdulpBByITzp9AXb8dn+
	B/ObXYNK67vbEIhdUi6rJ9k5q3rcAB6uVqKrQcv82EOOBOnB4LJJr+mGYKPTPylLiB4ZXbhRhY0
	YliVu77plS4IcIrLgdmDl+bM9Q1fU6rjUGKIEHPOdKdCFoZWXS7r5m7THyxjHl7Wf2npwT8Vcfg
	GHPEj3lJZ2kpLOha/8Dj3W6wXZWINrN4wZREFQ5Md+GHG6GV1ZbuTQ5ObyvpcE//HDHvPbcSlMT
	j9kDPIip1x+T/08ZeW
X-Google-Smtp-Source: AGHT+IHHnbvfuO02O2T8eWP+vcVOcuSJ7Y6r/Zmdy3IOsvMBodteHhpEqVwKxEJiZnOh/YXs6iICfw==
X-Received: by 2002:a17:903:2f92:b0:2a0:d629:9035 with SMTP id d9443c01a7336-2a3e2d758c7mr8216695ad.3.1767647940296;
        Mon, 05 Jan 2026 13:19:00 -0800 (PST)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc8dd2sm1526925ad.82.2026.01.05.13.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:18:59 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	miklos@szeredi.hu,
	linux-mm@kvack.org,
	athul.krishna.kr@protonmail.com,
	j.neuschaefer@gmx.net,
	carnil@debian.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org,
	Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH v3 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()
Date: Mon,  5 Jan 2026 13:17:27 -0800
Message-ID: <20260105211737.4105620-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105211737.4105620-1-joannelkoong@gmail.com>
References: <20260105211737.4105620-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5qzmtju9btspg7rjtrw7p4ncq95gyu81
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9037F4000E
X-HE-Tag: 1767647941-669414
X-HE-Meta: U2FsdGVkX1+ugjpUfERVo9FVN6e6o3/yZWtfkAOhcVWw0fFFoGD+N+JIzdSEGQAeTYsR39gdh10Upxm1IBn2E2yWIZK+uTnQ0RbENgbuzrrp7Fzm6otoqYR5BUfBFelB1u/CShk6AzraPdzjKBA7/WbaKxV/lbJlEQErNwUh/po/J+1L7DvHaXhUVqTxmbzm80z9P29ZDQhjZvW3Ll1hSx9sZo27FF7IKPyc3OKbmaVyTrm47sOVlOb/QKedCmq2viXxQ04VtSk2NLQv8JCZG8tPxwKtFV2dY/2VT0Snp6iERkcGNDgwStLnooZhkqhs2Ji7o+cPhbqsKbUxklBzTnAWFnyE6QxScdGKnxAnLhJrJOYU7wDX1MxpISRTcPSL9CU2/5Xlb6MPwMAvTtu0Wlb4eE0eH4tIuIqwqHtrsnZkuDo6lEx6kwGeCDVbqmliWr5j0QVB2qoNdlTg34DAblpJyWFW/Hv5Rv6wKrA42Ir01CAdssYCmO+FCwQY2c6jlvhQs0YUwYTYvzVSo7c/1Qpx54myJ4TwrstoWv0oV7fFqUEp1Wh4TyzcPcpKyypyzthpux9PU4wrFGInrBbBDb/Qkm2iZyp3whpLBvDPG2oQpI9UWuBVFVAJNQUGVBIW+ar+CULglKU4tK1nLVD0UfuPe2h0nb4TSam+eL7avaWd5BwBoNxUw9yNTLz0BcFp0TuhWFZGcMHUlPl+su5baVx0aJoCQ52CopXiHjuMp0eQzFwlY49OO1PxSkZ/vtjNqMzXH+Y/zi8aUspjxVbJ+/x3n/b/79HG1YzqCKt9A904fNwY84SINE55O6u5rO7wejP64Lrrrui5U87RRkVfWrKXAO9yEYtcISLFwYhv3bNZ2dCD0JZfTvwfrOlOEm10ebj1DB6K8vb6yoVLr7Sme2tSk9oG8wDj+SnJLE3hMfPvOv4qQ34IM5Y5v0+Dv/CfXCcgifywr8mQRA0A1E1
 kivFut1p
 VUQsSz5D1qe2XtluBqBckM/mN8LFl9vNIKqNwleZ2bKsAgtBArDtg4R3NdC0rHNU402VBGPA7ptPaVEOMZL8ALyWZoLPjZ2dsoll3oHp6MnuDFb4q2Z6sN/ti9+zaqWb6KcEmp+uOE/wiV3NRvqwaherfS4CSVYWRsu8WHe9i51dNbhtESKa+hrHfkCJWa2VtWP5QYJRK+NvQq8/XanKB34x7ENe/ipNcGLMYHq/bdxBWRr+yR8izubkvWU053V7TVfcu6oe00QcQzAIeeO3ixORaXSyju+og6DW1HOhTdLp9Hsf5wzeb3CVm8ZKs0eLAvcbArPLgsufaYcZ+roRSgiDDPGyehhzK2vO+JXdHTUm3yvmwMn+7IW5O/6FPOzxE7pFXp7IceZKJUbzvi0faGGk8kE1wjB/SJA4Olrfips8oPd0a4PcogcJqR5M4YMkwyd75NlNbXuz9Io2oLHvhEVGuqObKRRJIX84IyUbd29ryU5PMcUwuihK+RqOT6FkdqHzt/QeBJJt8oVtdx61eYnqBJKvXXLereb2qSwnhcIg88vkUQYA0Q1S8GGO0j/5xZL5JYaw9eJUFTFJhTQEFh2/JPj8YaDLxIQXKGwebKZMQzdXXfS4gi4m0Kz29GwtGFcSeEzRC8bOL/9K/0Td4AqIqLDcIMBukIizgW+Mkw9xc8IdaNRCUwstldDb0bKRiDNLCxIIe45VTRovG7QRUVzfxyCKKZXiYDnBcZsS5BsTWw29N5gZn2hQr2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Above the while() loop in wait_sb_inodes(), we document that we must
wait for all pages under writeback for data integrity. Consequently, if
a mapping, like fuse, traditionally does not have data integrity
semantics, there is no need to wait at all; we can simply skip these
inodes.

This restores fuse back to prior behavior where syncs are no-ops. This
fixes a user regression where if a system is running a faulty fuse
server that does not reply to issued write requests, this causes
wait_sb_inodes() to wait forever.

Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Tested-by: J. Neuschäfer <j.neuschaefer@gmx.net>
---
 fs/fs-writeback.c       |  7 ++++++-
 fs/fuse/file.c          |  4 +++-
 include/linux/pagemap.h | 11 +++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6800886c4d10..baa2f2141146 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2750,8 +2750,13 @@ static void wait_sb_inodes(struct super_block *sb)
 		 * The mapping can appear untagged while still on-list since we
 		 * do not have the mapping lock. Skip it here, wb completion
 		 * will remove it.
+		 *
+		 * If the mapping does not have data integrity semantics,
+		 * there's no need to wait for the writeout to complete, as the
+		 * mapping cannot guarantee that data is persistently stored.
 		 */
-		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+		    mapping_no_data_integrity(mapping))
 			continue;
 
 		spin_unlock_irq(&sb->s_inode_wblist_lock);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 01bc894e9c2b..3b2a171e652f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3200,8 +3200,10 @@ void fuse_init_file_inode(struct inode *inode, unsigned int flags)
 
 	inode->i_fop = &fuse_file_operations;
 	inode->i_data.a_ops = &fuse_file_aops;
-	if (fc->writeback_cache)
+	if (fc->writeback_cache) {
 		mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_data);
+		mapping_set_no_data_integrity(&inode->i_data);
+	}
 
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..ec442af3f886 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_NO_DATA_INTEGRITY = 11, /* no data integrity guarantees */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_no_data_integrity(struct address_space *mapping)
+{
+	set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
+}
+
+static inline bool mapping_no_data_integrity(const struct address_space *mapping)
+{
+	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
-- 
2.47.3


