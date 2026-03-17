Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D427FB5EA6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D1C6B0005; Mon, 16 Mar 2026 22:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6F56B0088; Mon, 16 Mar 2026 22:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5A96B0089; Mon, 16 Mar 2026 22:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 504796B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:38:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83F0EC1CFF
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:38:41 +0000 (UTC)
X-FDA: 84553996842.13.B6A093A
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id C270540008
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:38:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HPmogNYh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773715119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pjI5Sf85AGG/BWekd0QHD1ezj9wn3KJ74ppogqf/Zgk=;
	b=D4UJ0+7f1jxfG4X7/BjzWK7TgIvk/0Y8HfDJPevmjJHq+AQwhDwwJEhurTNxXqYUrI+G69
	DYvrTPamodLUsWfAYUQPyBuDcuZMh5NftS3ajbkfwGqKF/ozg+QcHeomon6hYdF2jo9tm9
	Lx1qf9bCtUcXyjoAXBcJgm7YlYmNb7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773715119; a=rsa-sha256;
	cv=none;
	b=T/yTARgK5MgPlqOjjOuwyQvMwT1C0wYKfzfCxyC0hyPf9hQ273AfQ5eX0bYNpxihBbfoEb
	C0iJDUDqOfcuxxvaay/MW/JG8Gcq9Yppg+J8u4ChweZrj5ciBMgRxkQM98GJGhAAWQAtTC
	0FqQU71J1jxTCe7oml8Y4ZIRi8yIy5Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HPmogNYh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64ad9fabd08so5755239d50.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773715119; x=1774319919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=pjI5Sf85AGG/BWekd0QHD1ezj9wn3KJ74ppogqf/Zgk=;
        b=HPmogNYhDwZXuubi7QajUKnxllXRNS4JH5VQttYxjaps9XgmRFTOt4IaNKkzxI2Z92
         QvSfRZICKOcZa+l3u9rM25PH6HIm0HQg96Dt8V9IeVrMBZlU9hUnzLpeC9DX7bqJ0bd9
         PGZIyC5IH4AfAZCs3ff49oFdYi/C9IUaOULUrsw/9n7zVoMQwK3mTs5FyAlFXB1jeV+/
         me6Kvymb8//hkpiS14PYn+zz9BPgvhIDynvCzf2tYMoKgjyXdUtcZ+M19SgcnNsCm7qi
         aSUpkIesliIv1iFy6haZpaw16vvu9jwW+/k2pKu1xiimIuYRXgWP3+7vkIdfFhZq2MiC
         Mmhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773715119; x=1774319919;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pjI5Sf85AGG/BWekd0QHD1ezj9wn3KJ74ppogqf/Zgk=;
        b=oDfbJNLLpGBKpZqCc1wq0iGas0dAY/h1kgWcVv9/59A1GIWsqmxEzlh7MndYkppnle
         n2Qp9eZvu9ART5Z9oB0sa9A15GiTnFWXRNCv4pUK2F8F3MxC0BNshBe7bQdc/o60sZTM
         GWO7gNdkfg/yJT0MbjJrIxoD+K/Tfc7V9Eo+Kc7MwHS9hMdgp7+OYt4o3/jgm9blMeZ5
         uFf6ElrDoMQ37Je1Z4GzNKn5mbL4z6tytyR/VezYRXTkcQldjFFDXN3lekmEPEdZHVEW
         3N9Z0tCoS2hYfiMlFwrmWy6NqHMc8O8KvvTzjpu6fSq+1dhVGRdb1sj+fHWgJXw9JuRy
         c8Mg==
X-Forwarded-Encrypted: i=1; AJvYcCX254AHm16fFSxZ20BVUL3jTJ/izydaOSpGb9LlnWw1sM9hooFJQdO6lKcJKnLZJzkePp9KjnunzA==@kvack.org
X-Gm-Message-State: AOJu0YzS5D1bX19Urt4EvSArN+H9hRb9dlyAm4vSYHZMaGpUbclmQdOK
	uMCXXRTgFV+LsYCyGusf31vy/Cpp1nk3aWH0i6/2WYaY2snw0C3AuXtFEbSb+W7yS6c=
X-Gm-Gg: ATEYQzzrtiOItBBuM6VX++IohyGmqTiBe7UYVxIMx1WnosdpQ2EUR21UHi+s8A/MZia
	ugity1mNp0sRO+Ga1Fc3tFqOpNCLqeCGXvxKv5DNC1f72Vjq1gWSqswP++fGjca49fokGsscxUD
	xR7NNMcQTYswfZ5fhDMoxWSQDsjyz5CzBmiR0O79ElvZv/oNpIiDkC6q3zXrZngGAXjdDWBSe+v
	SIWMUraH5+agDlU9b/myMgn2+awOWKlrTPItYES/U+tMrJL06eWwiB9MGd/Z3C+/2arwyWbUzW7
	b49QqwPf4c5jU+0CFQoAQ+oAZM09JuoyhaeOVZ3ElLOWwLItXj3jxDmQ3G7YFlso1O1qskYn9/j
	Sfh1R/3Don6ZWa3vSF5eiZrKovvrGic9L/JjppLj7Om17y6BU5NItO7AF399F12cXWb8njQPGPN
	W0MpxUEZtrTufLZrtTsjO7LPDFOQacti9PQZzbOCpulwbvc7GqbV8Sf5bZ6DPVDKO54BTkIOotp
	eil1wQ4mpB3mmhtsFvy5sd2v0GgusMYfsZjEblYoIJ+dCYnmTM/pEl04olU
X-Received: by 2002:a53:e1f9:0:b0:64c:f90c:743b with SMTP id 956f58d0204a3-64e630479a8mr11940326d50.41.1773715118626;
        Mon, 16 Mar 2026 19:38:38 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e65b636d3sm6651543d50.17.2026.03.16.19.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:38:38 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [RFC] liveupdate: prevent double preservation
Date: Mon, 16 Mar 2026 22:38:34 -0400
Message-ID: <20260317023834.487682-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C270540008
X-Stat-Signature: 78ekw7go1k7fuq8sk5qhnrm1qktobyny
X-Rspam-User: 
X-HE-Tag: 1773715119-479204
X-HE-Meta: U2FsdGVkX1+BIomdppnls6l1EVS+xsLk2zK+CfP2qOXZsKjgd5ZaMQ/0zdvNwQxvtgWz3lijyAoSYbzHzu034RYUrjw/0qTVAj3R/Oo1gywt4j2XF4GGFfqFMU+eZrZsPOkJnmYXu32SNTS9lurvECTVHRDYbCuy4mxLvFqwVTvg97JhBWJXW/3ngWYHfuzBjsvb5YtH6919s3CjPUiKisu8enPRRm/hwG3oFvLOyMI4EJ282Mfbp1Xj0xy8dy7UpIT3ULRWa0+ZxATSVrB8wfTj91O+ldtZeTFSXh28r5fcIiVvwDKFGhyh/AjXQsv1z2b2gr7vlPzLX0QSpN6IiFeRjkUdq8T0j/1k/F+Ws++wwr8BzpP/FbyITYJExmWHUxwOO6eLw9lloJVkLePdimg3i9I23F/QZWp+ZGswOgo3zWbqsvkbZ6ajzchcRAvMxYV2ZaI12Nl8iKvX0tXo3VuYwcmLx/OH4gC0stuv5upKu+PrZduc4QzK2wVYKEu7ZFT8uVL9u/2pdZhAxMSJaaB7sEZk+nkFOjJ3Ts3BSZZA+jm+3H6NhQczQoXfX9m3DpKlji1rijezpLYHPhlv43DOfaoABWOSYYXdT6X8H8rAR3ndQJZA5JRy+qAFXRoUMqb9Peeg02GCKnd1ZZ1vidncBSwLBG2SD39gJ0F/WpZlxT2QTNg/gVucplsOCdEFZmDE9vHCeqGBr5O4UmyBK47TSUUYimSmKfo5P/oNjbIhZUPSiZm/ItaIR4ghaYCL3UeVgeO3OaQhEq5PcmV+YrtE1Pv82ih2Ykh6KoG/jIE03qd49ucVB8ROyrrd2a4yZagtvjye7TLwZkTmxt9iZphQ7yeB0pMofY7Zgv+WpWz0XTQBNzvv3ANQZraCzFz/SclLofQq2CLSXuEjxO5UBFd0wMHXPSivduC0Nzo87ar9IE/4qf/EmS0RuKU4ubOazABteGQqjszrF6PWipE
 1LreJOJe
 xLfJKW/dFr/FEP8QW+dmA8jmce0G6x6cH4B+CdffM980JOBqqmNzP5AMf9UoISgx4YPC167u82lxdr3gkWm0elEI0Z4cMkV9JjbcJdPNp/tohVEoXLgEkwbPHNTiYbhq7vbrUdHO7tAyIq9Taio0GpOxkIbceGS/zYVBA7KM1wvkAZ1h83rMae+z90ierzB88lFMQBiTJKuFrUtP8+MKa4rNUYzdOkNoLFAIJdZbEElEao2cj61hmmBZnLBbtoj5C468fdZT65iksKvIiU4GjOX46H1xQaFI+w8Y0PGWU6mlMs5Wktpn8HTCtnEZL0bhlUZp/BRYNSM8rPk+/sGQsk2KlSV862ysS+lbU8KfJljqYIBJ/yelRqy5Xr6lB4xycbyjTIXrQKQjcUy5Je7OJ9LemtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, LUO does not prevent the same file from being preserved twice
across different active sessions.

Add a new i_state flag I_LUO_PRESERVED and update luo_preserve_file()
to check and set this flag when a file is preserved, and clear it in
luo_file_unpreserve_files() when it is released. This ensures that the
same file (inode) cannot be preserved by multiple sessions. If another
session attempts to preserve an already preserved file, it will now
fail with -EBUSY.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---

Background:
Because LUO preserves files of absolutely different types: memfd, and
upcoming  vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd).
There is no common private data or guarantee on how to prevent that the
same file is not preserved twice beside using inode or some slower and
expensive method like hashtables.

[1] https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com
[2] https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@google.com

 include/linux/fs.h           |  5 ++++-
 kernel/liveupdate/luo_file.c | 19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 23f36a2613a3..029257ee7e0a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -712,6 +712,8 @@ is_uncached_acl(struct posix_acl *acl)
  * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
  *			i_count.
  *
+ * I_LUO_PRESERVED	Inode is being preserved by a live update session.
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
+	I_LUO_PRESERVED		= (1U << 19)
 };
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5acee4174bf0..38df09d89433 100644
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
+		if (inode_state_read(file_inode(file)) & I_LUO_PRESERVED) {
+			err = -EBUSY;
+			goto err_free_files_mem;
+		}
+		inode_state_set(file_inode(file), I_LUO_PRESERVED);
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
+		inode_state_clear(file_inode(file), I_LUO_PRESERVED);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -363,6 +375,9 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
+		scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
+			inode_state_clear(file_inode(luo_file->file), I_LUO_PRESERVED);
+
 		list_del(&luo_file->list);
 		file_set->count--;
 
-- 
2.53.0.851.ga537e3e6e9-goog


