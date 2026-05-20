Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 364CACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E846B0005; Wed, 20 May 2026 04:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E196B0088; Wed, 20 May 2026 04:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B016B008A; Wed, 20 May 2026 04:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59D276B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:17:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22C96884B1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:17:05 +0000 (UTC)
X-FDA: 84787092810.05.7B84218
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43BBC140009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:17:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UqzKajWH;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=B/xV4OqGJtER2rnDgnxjP8aamK2J2sLdEwWrq99mTmY=;
	b=QjTlJpC53fvYIY+4+C70oPBqGPYp0uc2IYmvT2yOMDNSFece8D4fhpsQ9AUbcnZhhXkLJq
	WixvN1rmf1DAVyNElBBIYb6puSBO4aY9jP74Z63sc1gSfWXNUpx6bMgSJigX2CDJKNWM37
	Ooxicl1zIr4M67Ei1f7aqNh0NAI1YBY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UqzKajWH;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265023; a=rsa-sha256;
	cv=none;
	b=mdCdD4/5ldX81vbDUVqsYlE24dtuJOf3BfwqxnJmBPX5ppXQDidI3G6u36gM7pXMUehrJB
	ZgYEwKNasyGHjWoQXs2TMpdUUeFwVdA8jSIIgWxfr39GRNeodMpUDR5RD+lCX08jKhl4Sg
	uUUeLZo/1SvpwN2tvg7Cc0Q2RRY78ZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D1C642B8A;
	Wed, 20 May 2026 08:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81EC1F000E9;
	Wed, 20 May 2026 08:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265022;
	bh=B/xV4OqGJtER2rnDgnxjP8aamK2J2sLdEwWrq99mTmY=;
	h=From:Date:Subject:To:Cc;
	b=UqzKajWHqb+6PNHvtRHuQeSe8iOoOZzqLEdnXrPTAqA3hGUeymQaHg0i5K5u0go9p
	 zbIjI/a6QEmNpZgB5cNrIU4YFQSM8+O/npiPsiDCqudjuHZ4XwhB3hLu30SW7dWf90
	 d3XUT1/DvDA0p1BHHZBqLb7BKcQqIcrZ1UpUy9+eR3m5ylvYXJWu//dKzbujmLli84
	 m1rG6gVNRi3KYtbqSLX9FK4TdPCTKdIbAZQq7WQoc9fWoqhxvwXHG5Gyz2Ajqvwuc3
	 24NMAL1wu6N2MmAP5nfg0eMFhP8u+z15BEtGUFxxAhaVggOqgWds2GT9frkLX7ZWcC
	 YffZu/xlBm2uw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:16:51 +0300
Subject: [PATCH] init: do_mounts: use kmalloc() for allocations of
 temporary buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-init-v1-1-aaf2ebac5ad9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPJtDWoC/yWMQQ6CMBBFr0JmTWOZtCR4FcOiU0cZNcV0gJgQ7
 m6ry/fz3t9BOQsrnJsdMm+iMqcCXdtAnEK6s5FrYUCLvfVojSRZTOcxDG5wPaOHor4z3+Tzu7m
 Mf9aVHhyX2laDgrKhHFKc6kTuRK85PuE4vpBa+waDAAAA
X-Change-ID: 20260520-init-152a94946e25
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3243; i=rppt@kernel.org;
 h=from:subject:message-id; bh=hEOV+xLBzps7dK3nmv8ZLA62uaADwLGePclh0jyux6c=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW35bx0+sRUhpBsEehlgNGBwsmYfYqIoq3ABv
 O4XWrYEypeJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1t+QAKCRA5A4Ymyw79
 kbGbB/4olTVytxkGtnPOlA/z35C0vEnA3naWGyc2qN34UaPtYTSoLiSwyrtQtQTMq/MK8A/rQ1N
 nX0NIRc/DnbSHUPwcvZLQQ2LGDCljYAYCwi4eag5gZ8W3Mhhvlei3BkUfTZLEzR/wVvbiE4Llyj
 gSA15MND7ShHWLKMgHjpGaocJlKQhnP93ZThTCI8mWZXIijk1Nd0hDIdWHo0praoy/oku5dnTnu
 gFzZAqi4oGBKOC+//pCQBFP9/hAzX1Q+T5edvKZOelDcHejrU6a9SnzWrLbsdtaM1zqoHO/SQxY
 2IONtVb9Xex0o2D94jZsrG7q0wOA46yjFppAogstvdNEN0vr
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspam-User: 
X-Rspamd-Queue-Id: 43BBC140009
X-Rspamd-Server: rspam06
X-Stat-Signature: c9gkr85wew3o7c4y4ih5bax795j1fu8f
X-HE-Tag: 1779265023-630125
X-HE-Meta: U2FsdGVkX1/NW3WwvVNsP62HXhifsc7sZ6IQEkt+Nvy/NFNQ+G31fc/6deQRdWKdHJbQmJSOwp80JF2N4BWsITg/p76YcjcYDW8t7uh29w0OlxgEEyFEkd3oRqCu++eZ0dZNC14RBRV+COuE3rUZwHoHLmTWEmP9jA06j7ZiYEyenizuaWqpfaJLhZsS4mSNxirp7TAe+8jv0YxNx77eO4WAuBascS3vEc6oAhRLdoDFPcTtverc00ndNgZICADa4Y1Z1uxvksbXludYyqilIe39giITWj4wTKLEIgBw+86gjEx0WcsZA/M2uZAVkFVNo5qyhWTHxmGBObNCtUQzygBsnBBq+4/v2gPDK0RKIEXlca/L/qaB24qazbvfzrjAZS+bjVs0r3GXGIZ/aGVv7c2Hgxed00znqfXEhPAEz8E5b3xrwyIBQBuZKU1e3pnOdj3KiwuCXx3RF0JQbF39EJDC++PBGEae07AyvllNaCw0H/kyrd4ACmXer35be5lrA7gtY6FLMGjdd9e7mOVzlNWVBreqftxc45ULIoStuKDUfCLcZzPzxcGEDRqbgvAPJwMzqyPb93l3suWgkOWh8aUBD2MrwgBYUk8gLXp0dtRgXwAib/gJZfrUuLYsP/H/Ed8DxaLAYKU453K5s+Us74RsjE/JOIhxyDwtkHJj9eR04P06ZYLONFbRHz2cBDzxRIginzgf7VDP1lS2T0UilLFy8kmCbXVKhgLsj6GKd58yjkz64BAl3xVGt44GONu2+hVyuht27DgBc/QfOl6vkqjOcaOMZjzHoUbfFQNh20eT8E+cLaLxTGkXwLteASVEkDcJesJfrv60HnQY8PA4pmbXGJ5q11JbK5CAYHdfe4MtENB4wy8zy/DJqZ4Cgvlc6BoIyah0/Z1JQHPZ88X/xaJZXhUzIdzISN5lqkq/kVpeMjFWhLG9BA7DP/LoQ7n1LHmLN+a/Pt4Hnhcuqju
 Hpwa8WW4
 1P020fUc0pECqciKW9BllkwbBBeDYE0MyWIoiWtGGMh6MxOFYzxqNy5BUU+aaboZvM4AZWtKuMCRwb5FyJvLd6Vlgy0iQCyy+92rKsyNwmDlKlPa4wLA6+0x1+t8KNldw92RfccHqilwniDXtJEU9gX3FjkSp9n2YvIzvuxfI71N+DRfRKB9v8a0lCHEOWDmdR9DvgYJxOEGrLoD22KcJPN4bxMvLPuvuS/8SaNnqpQyMWUJ9T0JC8l6qMVCY2yPZMFl9ZHt0cDxmUrsYRdaLD4ZSbjmNrlomcF7zbHJ5WFuHEe/Lsm/fENXyMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several places in init/do_mounts.c allocate temporary buffers for
filesystem names or options using __get_free_page() or alloc_page().

Usage of alloc_page() APIs is not required there and only creates
unnecessary noise with castings or conversion from struct page to void *.

kmalloc() is a better API for these uses and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() and alloc_page() with kmalloc().

While on it, add a check for -ENOMEM condition in mount_root_generic().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/init
---
 init/do_mounts.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 55ed3ac0b70f..95e0b3a0f711 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -143,16 +143,14 @@ static int __init do_mount_root(const char *name, const char *fs,
 				 const int flags, const void *data)
 {
 	struct super_block *s;
-	struct page *p = NULL;
 	char *data_page = NULL;
 	int ret;
 
 	if (data) {
 		/* init_mount() requires a full page as fifth argument */
-		p = alloc_page(GFP_KERNEL);
-		if (!p)
+		data_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!data_page)
 			return -ENOMEM;
-		data_page = page_address(p);
 		strscpy_pad(data_page, data, PAGE_SIZE);
 	}
 
@@ -170,19 +168,20 @@ static int __init do_mount_root(const char *name, const char *fs,
 	       MAJOR(ROOT_DEV), MINOR(ROOT_DEV));
 
 out:
-	if (p)
-		put_page(p);
+	kfree(data_page);
 	return ret;
 }
 
 void __init mount_root_generic(char *name, char *pretty_name, int flags)
 {
-	struct page *page = alloc_page(GFP_KERNEL);
-	char *fs_names = page_address(page);
+	char *fs_names = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	char *p;
 	char b[BDEVNAME_SIZE];
 	int num_fs, i;
 
+	if (!fs_names)
+		panic("VFS: Unable to mount root fs: not enough memory");
+
 	scnprintf(b, BDEVNAME_SIZE, "unknown-block(%u,%u)",
 		  MAJOR(ROOT_DEV), MINOR(ROOT_DEV));
 	if (root_fs_names)
@@ -242,7 +241,7 @@ void __init mount_root_generic(char *name, char *pretty_name, int flags)
 	printk("\n");
 	panic("VFS: Unable to mount root fs on \"%s\" or %s", pretty_name, b);
 out:
-	put_page(page);
+	kfree(fs_names);
 }
  
 #ifdef CONFIG_ROOT_NFS
@@ -343,7 +342,7 @@ static int __init mount_nodev_root(char *root_device_name)
 	int err = -EINVAL;
 	int num_fs, i;
 
-	fs_names = (void *)__get_free_page(GFP_KERNEL);
+	fs_names = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!fs_names)
 		return -EINVAL;
 	num_fs = split_fs_names(fs_names, PAGE_SIZE);
@@ -360,7 +359,7 @@ static int __init mount_nodev_root(char *root_device_name)
 			break;
 	}
 
-	free_page((unsigned long)fs_names);
+	kfree(fs_names);
 	return err;
 }
 

---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-init-152a94946e25

Best regards,
--  
Sincerely yours,
Mike.


