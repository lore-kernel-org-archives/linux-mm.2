Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B97AC5516E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604E46B007B; Thu, 30 Jul 2026 14:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58EA06B008A; Thu, 30 Jul 2026 14:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457306B008C; Thu, 30 Jul 2026 14:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F35C6B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:55:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6D8DA0A66
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:55:17 +0000 (UTC)
X-FDA: 85046345874.20.377C12B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 306A74000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:55:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmTfwEIc;
	spf=pass (imf01.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785437716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Hfg/Gngqd8SEsjmvDZsSbSWbGJu/DBm8x/q7YUwOtSU=;
	b=Q4HZpcIuMSPCi+xoyaGQubC5GfC8J1PsJxG45yIJcN4AMwBhwftFjvwLvWdowUjschULHq
	VyVtcsOzW4Lom3nicG3S+AkIdgEoqE+7sH5KPU8iP13pPk40RN1UqjFfypKvn/ZxCoWSx1
	rOwUw7Mefdiv3kpYDy0Myx6fvVMXsz8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmTfwEIc;
	spf=pass (imf01.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785437716;
	b=vUnI6SdS4jbIwx8Vk6JQzzGr6QEbx095FZs3eOo7Tj2xooOtcJEduSeC/0VbJTI9zPYvSQ
	AaVGJkahm78UZlDO08D+wp9gy2Z4ve5NXWKYtKcznYyhXbzTuNUTOCFbLaJpNosHXYXDZi
	uSNygvwxG8eYg6px9O23FO/+KlqktwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44186407DD;
	Thu, 30 Jul 2026 18:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5231F000E9;
	Thu, 30 Jul 2026 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785437715;
	bh=Hfg/Gngqd8SEsjmvDZsSbSWbGJu/DBm8x/q7YUwOtSU=;
	h=From:To:Cc:Subject:Date;
	b=UmTfwEIcQAZ86kDM34UYJMbq473z2fsOFlb728dkck+ISBouYAxxdTTa17upWeCAd
	 Fa952fHS1lUK5GYeiu4zWH3buJ4uR9EZ7TWSXC2lc9Un/KGctN/G4jrnRsJWN0Z3O4
	 icXTXhrMyGzLgaCR3MW4oWiKwMahsSDodIrIUqVBEd2c77lrw/RFUYTdgTB14yJb7J
	 AmQmDSvbuqXeefuq7nB6tIdLkstbSL/n0Y6OXGiQH8nG9JbgC7N9vYtzeMuWCwX/Px
	 YQzQKRIk/AQZMRzMIxKwr9/DY5gDArP6OBunaEBI0dow0OGiJN54LSNJvA3RVVacLl
	 FhFznXM7WnipQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] mm/swap: reject swapon() on filesystem-level encrypted files
Date: Thu, 30 Jul 2026 11:48:53 -0700
Message-ID: <20260730184853.48347-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 306A74000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 33c5ekw6kwbq391fdxhheiiyrcjchrt4
X-HE-Tag: 1785437716-73147
X-HE-Meta: U2FsdGVkX18WH7rZQ9CEnwqfOSTdDk26QGfmPZu79gPrTU/eOKNSzEvWaXDZ269UqB14pBuXHYQZ/7ALa9Jv6iFqpRhXGQEXdX0w9AkKpVWuAPBA39djVmg6T5DsL0E0hU6H9n0DJVRytcyLMPFLTr4WffEDkDftm6XHWwR8AOSZ4qYobglzmlkbAWI+aVKeZ3P7g5PmpyH0+N32fXar8WUiUYjgwNKUsOAjVzyzbGUhkfyc8oqgvHNcwoa3GkF5NmuZM1pC3kRmu4SkxvplZfVbeo/6BMJjD6IouTDRLVOPOzGY6jDRXpNQcNuuM5JRpe5YyYeG2xxsTgwDnpimiWEN6kZT7AHprR4HSLPotl+n03Sft2rOXgfF2SXTWmRmP1X0vAP1L3I0ku2Dw/jrMJibkxRPwiZWEWPEXsYrfk6aivglB3tO8i7x7DO3WcfGBVXdgXNRV+9JHKbbKaXCk6RmY4XVPGYn9Mh7Gu3CHq57SRcSRlYqap9ga33b8r+KK5fT99VssApJIUHrquVAfd4zWCpDosn6H2Mf9NdaClul2vu4LMrblH2vdVjwB3X3vgQaLIt/g+dM7AmVU9HuDCtDSSFdxRax5iqLwjaFnmCQNsG4I3gkO4FA2UYQ9anCVErusIn7p/O/fCcTJq2BzynUpyfUKH4O8+CmJJ0wjzO1WJ7ba0WnLiUvb2WMyGh1hdttpHTNsavWq4p/WDL8RMudxh5GhJiwjB1WgjK/WN0qtvp1MgkBEGLuqjV0xZxugtzL1mqhxYuzuQpk+OpbZCgh8qeFMaJeYfwsUIcDP8rw3NNoCfZR4Ha4HCjMQhb5qxo9BGLJQXjFKVd933RYrewHA9GKegRhFQE0TiksATOyPmfqSHlUjRP7fMMeyANQV+e7ALV/W9M7hOsc3tKOI1v08YZxiUck6Du58XrpgOyGaur5F1KUnytBYzp+wFX0/pQ/nKQJW3ZJO+07IZD
 r/oBq3fH
 9TO8SQt2+Zl11OK19oZ/SOBBM9UJ4z4xjGLNoDTt6quNh5LVRQ09yObxxa/xNcgqo0Cqz6y5Domx6bzDH1HLJUGevhCKjy3CrzmMqIWzp2BIONs7MjLC+K4kPN3UDzBKTEoVInPwFseIXiHnF2Uwk2x20slpcJO/b9LcJXb7a7xC0xhCSfek9BdXAIwJuZ3V7B1htLhaXqNh4Hg8iX/+42jd6t2x3LcNDYOX5BoOVFUV3UD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ext4 and f2fs don't prevent filesystem-level encrypted files from being
set up directly as swap files.  In this case, encryption is bypassed.

No one should be doing this, vs. the methods of encrypted swap that
actually do work (such as swapping to a dm-crypt device, or swapping to
a loopback device on top of a filesystem-level encrypted file).

Nevertheless, to prevent user error, make swapon() explicitly reject
this case.  Document this behavior in fscrypt.rst as well.

Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 4 ++++
 mm/swapfile.c                         | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index c0dd35f1af12..cba1989777da 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1238,6 +1238,10 @@ astute users may notice some differences in behavior:
 
 - DAX (Direct Access) is not supported on encrypted files.
 
+- Encrypted files cannot be used directly as swap files.  To swap to
+  an encrypted file, set up a loopback device on top of it.
+  Alternatively, encrypted swap can use a dm-crypt device instead.
+
 - The maximum length of an encrypted symlink is 2 bytes shorter than
   the maximum length of an unencrypted symlink.  For example, on an
   EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..e4991da81b5f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3650,6 +3650,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		error = -EBUSY;
 		goto bad_swap_unlock_inode;
 	}
+	if (IS_ENCRYPTED(inode)) {
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
 
 	/*
 	 * The swap subsystem needs a major overhaul to support this.

base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.55.0


