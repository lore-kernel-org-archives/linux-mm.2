Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA71109448B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0086B00F2; Sat, 21 Mar 2026 13:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80CD6B00F6; Sat, 21 Mar 2026 13:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE326B00F7; Sat, 21 Mar 2026 13:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2D86B00F2
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:58:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59BC7C2034
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:58:14 +0000 (UTC)
X-FDA: 84570829308.15.8D0ADA5
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71BA7A0012
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:58:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XTfB50po;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBOfKv8+dSxaoWkBve3vKf+AERqgheSr1LH0+CQ4vtE=;
	b=sk3AsxXfox+vPXFjPB5QL+FcOWVc357AuHV2+Kp8E/g8DEOlddAnNkZfb63w07xBxrJaKc
	9Dw87mNsAxZnL9HiuPa0kwnDxNNqheUN5V+gSI2Amg/HtoQhFpG+/b6mHYK+hQyxO8xGDx
	QzyfhRrSEUHohGFsrm/pgTDmLTE/ZLM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XTfB50po;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115892; a=rsa-sha256;
	cv=none;
	b=vb4sx0cuQ1ReuucTek1y+DxywcBJf6uD9j/DvXthQWD/DV4mnvDrKYMCQ5Rhtz44o8dl1h
	Vpq1W4Dhba0AW+t0m9DJ03jHnd4J5qlZEnzbVedP3AtbiqHRUzZo1ppdsVUsU79ZbqJVXx
	Nsl2BQsKpjevCo1bnp9F6G0BCiAZx/c=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cfcb045909so210632385a.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774115891; x=1774720691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GBOfKv8+dSxaoWkBve3vKf+AERqgheSr1LH0+CQ4vtE=;
        b=XTfB50po6j+2GsCtxaV5/bYPTLGTTXNaqgA5xy9MgxUNiUn3XKP2YizqcfXvOvin4a
         7WNUXQYJdQvU5X4N6UKzN2cpiDilmrGJzkl0fvUGr2XwZkplKhfeaiQ5bbGAclR5FnjZ
         5/AUcYt14Ik39K0okVf4nGmNEZoYKAn1qDt4s5IuDnNtDUfyM8htNTezet7mJxhHc//7
         249cTgzwC7khoULaTTTU2ExUNi182hnN2xhLheFfsd2rGSi/chVdg5mKp9ZrT5kAwkTx
         9ai5rzp540CgxHP4mHOVwTqMivyMqbpC5dcl3Id9XJJh6XKHPSdeJ5dragxtrjCquF4u
         UNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774115891; x=1774720691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GBOfKv8+dSxaoWkBve3vKf+AERqgheSr1LH0+CQ4vtE=;
        b=PnEyVrFbt1LazgEl1bSkEiHJXBiOmWqWOp7JdDc1fEbVdgSte+qdtrhfMkljbRVmdm
         8MjMOcORfNDFL0lhh+Uni8OlerElzMkhAepUOw2+2CjufupIUv+S0Zu6OyyMUfbNrdpl
         CudH8tiL8fCu8IU17+mQqPnKKr7tGxF1CSHT8SL0T/MMEPUVBJ2IEt4kbPfi0nUdnuGb
         4VCfgiWcHWk/6wTlHaG+fjgD4VSjxsLEIS6QCbCFAnJHVZSNs3iHIZt5R8jsDgJmtU4c
         Z8BYmHb6+wHPN+KRjwOImrR3YKvlWTTEHVq0GBV7jnOWFLD09EZ3R9s4Iod2vjUh0f50
         BIEA==
X-Forwarded-Encrypted: i=1; AJvYcCWWXFGIAXsQDroFZd7QJgO+MJPBnHGWDA0d4uv3dBSm/YYu1CpWQDsWmql40uHydc3c/pBPv/H2Ig==@kvack.org
X-Gm-Message-State: AOJu0Ywb4/MgDGjn6WqlGF1tcac2xLsFIRbwmSFxxPHdfjmpofptrCeB
	5tmlO32BU+dotGF1jYDwMSKLVePOtGOwcUzmobTSnnPnbU9o80qRuV19gWwLgAPO4bY=
X-Gm-Gg: ATEYQzxXcoJK5m8KrBb/i10FAMTUxkRsjWLTkx7kEo40S24042Q6UUcQfBz8efrmZDd
	5p6f4K4cg0QDeyqt9BRiISvUQ066cnYu2hm+vc+CydMx3emlh7oBhgX5Gy5U8EWsE3iahp3f3zr
	cH/kr0PyfNhBbtadx8UXV56n5tAgdLzOP3DvE8c4inL43/ubzS52fX+kBpxgkr7QzsDadasXZtf
	Oy3vY/b9CCQWVrLK4Fl9p4GVhZZl5k9rYm/EHSWQoYQdHknTgzCXoQiRtaSYDJ2hBJtqEz4inSE
	SFT5kvtoaDElhSUj1Dld0TZGOUcceTH+ot45aNYm34WWDSxeoHdhc+wnJz+TIiv3wwfL3E9ZwXk
	zjWIQvxlyKW+1dW2+k0TyZVh75mmRZZkGK+lxDyPNNAYbdqGvg+XuQ/Clvl4kBKLClZLNmbwdWZ
	Y9IBUmuuKCFeSQK+wgn6HRtKESlVUD32kH2ta77UeSvJb/AN5y+7RIXSGfLpFalgqmUVkwuLOPQ
	/Pj
X-Received: by 2002:a05:620a:170f:b0:8cd:d921:7075 with SMTP id af79cd13be357-8cfc7f8adabmr1070366885a.71.1774115891450;
        Sat, 21 Mar 2026 10:58:11 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9089ca9sm426515985a.24.2026.03.21.10.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 10:58:11 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: brauner@kernel.org,
	linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	jack@suse.cz,
	shuah@kernel.org,
	linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH 1/2] liveupdate: prevent double management of files
Date: Sat, 21 Mar 2026 17:58:07 +0000
Message-ID: <20260321175808.57942-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260321175808.57942-1-pasha.tatashin@soleen.com>
References: <20260321175808.57942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71BA7A0012
X-Stat-Signature: miagyhmhom3t93etana6fi38wd5mjywe
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774115892-920225
X-HE-Meta: U2FsdGVkX18BT0N4TdIEaL73GqPXsmDq2To06NeWPFzuCRoVQUjxNLgvBUim+F8o+LSaMMshLvGeiHdX7SfDDo+s4mRzdQ6Flmx0Vrfe+DJ/k+63HGn19k3PnJaCHvjjvefJ+nQ6FHcM+8lmOho/HzG0EmkDE/v5eAvhczOYD3RvqaW877F3900eaR2FWBDRc5zFeMo4GefRck9CD7X2nBUnLG8+G5FHserPLTATQ1JE5gsJDMsbmVsB2HKza83oXCzgq1sxpLyqLLGNWDrmyVHGpPhEaQixLy+nx1grCQ3WZ9J3vsuSko0kgjk5HCL3IYz1fhdzwGUOz2YQ796OeevEoh6Mzb6P9NBZ4dZRjg1SPuI+x2M8RpWL/tTkpSCx277C+QjgkXKNJXNCkhOoLoNkI1e+whV6SKpl7N/nFYp37XI4hbJLNORa4bLXXIjO+869+RcEWu3zt2CXlSgrdNU0DW5zvBrHEw6Gg5AQfMqpMcL1sjGGVoVjA7vZO2s2rQ6R3U+5mHgA+fKp6a8AROe1+XlW+g+E42/SuEvRbZdVbpMW/nB4U0f2sWQhX5a/iYq9RH7vAUaDwwmvkU+S1TFbe+1v070YRc6HLpWAOaZ0VR4LpLTe0tThoTt+OGlauXDIp0KJqMQOc/UosA4Dn5GLdv6T9F9rUTDGQY8PiJB1LPk1o4o3RKg8N47QB484BNLaMOt0iL/LeVW5k1vZroQdbQ4Wdt15dViWqeImZI1Hexqtcby8usAeRmIoJop1g/iNsgoW8jkBDLx/K8Z7hJ61c8nbnSZxZKlnfaeQ9xKsBlXR2uJpjpAic7GRkAzRAJGkWZtZGsjOlyMO2cLr5louWDgTeX9EruiT6yv57AWTusDwz0HB3ovoKrAEzZDxrWYh7zE7uBkKQpKXjKmUv1Tgv58P74b15COM0b0yb/iHGPoZ1nFAat1Ij8EejmbtDjglHTHB3/KbrXsXJcx
 48WBb4C2
 knNE9pEVxq5+r9RHDAkFcb8NnwbWCHFr1vysnBBaf8Xlfo2O/soyqRYSeNV2OGLxkKHtumB4JoEWAPw1R1hPubtdhEBNJodnsXkfJtZwcw+v+yKLGTcDrSjM4AlVEzQUqrmWaK004tcihQkvOxaEKlomK3eJ9qzsiveM2OfK/zlrnrwgt7Lz8yueAXC2tNNCvphZlw+yUY9icQqQrCOCawbJ42aGFc8t+N+6a6LqOYaP4Mw2FqaefEpnT2b9txjWLcIVfrRRllVcsZL/wlhN1jHq29MDjucCeQvDzCOGsLHGEkTuK/jgeOoxLBP6mtbI49Zm8rj6RckoD7x4MBhMLgHmFfYSJDvqCV+A3iGsv99vC8oIV9Nw4Ua1TfdXZeVbMmF/S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, LUO does not prevent the same file from being managed twice
across different active sessions.

Add a new i_state flag I_LUO_MANAGED and update luo_preserve_file()
to check and set this flag when a file is preserved, and clear it in
luo_file_unpreserve_files() when it is released.

Additionally, set this flag in luo_retrieve_file() after a file is
successfully restored in the new kernel, and clear it in
luo_file_finish() when the LUO session is finalized.

This ensures that the same file (inode) cannot be managed by multiple
sessions. If another session attempts to preserve an already managed
file, it will now fail with -EBUSY.

Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/fs.h           |  5 ++++-
 kernel/liveupdate/luo_file.c | 27 ++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 23f36a2613a3..692a8be56f3c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -712,6 +712,8 @@ is_uncached_acl(struct posix_acl *acl)
  * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
  *			i_count.
  *
+ * I_LUO_MANAGED	Inode is being managed by a live update session.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  *
  * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
@@ -744,7 +746,8 @@ enum inode_state_flags_enum {
 	I_CREATING		= (1U << 15),
 	I_DONTCACHE		= (1U << 16),
 	I_SYNC_QUEUED		= (1U << 17),
-	I_PINNING_NETFS_WB	= (1U << 18)
+	I_PINNING_NETFS_WB	= (1U << 18),
+	I_LUO_MANAGED		= (1U << 19),
 };
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5acee4174bf0..86911beeff71 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -248,6 +248,7 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  * Context: Can be called from an ioctl handler during normal system operation.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -EEXIST if the token is already used.
+ *         -EBUSY if the file descriptor is already preserved by another session.
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
@@ -276,6 +277,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto  err_fput;
 
+	scoped_guard(spinlock, &file_inode(file)->i_lock) {
+		if (inode_state_read(file_inode(file)) & I_LUO_MANAGED) {
+			err = -EBUSY;
+			goto err_free_files_mem;
+		}
+		inode_state_set(file_inode(file), I_LUO_MANAGED);
+	}
+
 	err = -ENOENT;
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
@@ -286,11 +295,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 
 	/* err is still -ENOENT if no handler was found */
 	if (err)
-		goto err_free_files_mem;
+		goto err_unpreserve_inode;
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
-		goto err_free_files_mem;
+		goto err_unpreserve_inode;
 
 	luo_file = kzalloc_obj(*luo_file);
 	if (!luo_file) {
@@ -320,6 +329,9 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
+err_unpreserve_inode:
+	scoped_guard(spinlock, &file_inode(file)->i_lock)
+		inode_state_clear(file_inode(file), I_LUO_MANAGED);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -363,6 +375,9 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
+		scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
+			inode_state_clear(file_inode(luo_file->file), I_LUO_MANAGED);
+
 		list_del(&luo_file->list);
 		file_set->count--;
 
@@ -609,6 +624,9 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
 
+	scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
+		inode_state_set(file_inode(luo_file->file), I_LUO_MANAGED);
+
 	return 0;
 }
 
@@ -701,8 +719,11 @@ int luo_file_finish(struct luo_file_set *file_set)
 
 		luo_file_finish_one(file_set, luo_file);
 
-		if (luo_file->file)
+		if (luo_file->file) {
+			scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
+				inode_state_clear(file_inode(luo_file->file), I_LUO_MANAGED);
 			fput(luo_file->file);
+		}
 		list_del(&luo_file->list);
 		file_set->count--;
 		mutex_destroy(&luo_file->mutex);
-- 
2.43.0


