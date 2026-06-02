Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7408ECD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCAF66B03D5; Tue,  2 Jun 2026 07:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2F06B03D7; Tue,  2 Jun 2026 07:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9026B03D8; Tue,  2 Jun 2026 07:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9572D6B03D5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:06:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54F941A0860
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:06:41 +0000 (UTC)
X-FDA: 84834694602.09.8723B77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE0FD40015
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:06:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YbXPzbLq;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780398399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qu2IPDA2PF27oFfKuoclvpV/15L0SmXzGjwgc+d/YI=;
	b=XnCUJHDZKYYjBDi4+cSN6fyJV473WhA2qcWwgY8dopf4aU4qKqOx3JLcEvo2LuqHQuuLPc
	Sx2/66zQ2hUHP16GFBBhR9oi9Voaik4bSgznDjzw3L6pApBRA7iD5QiC6UvbW+lgMUTmmA
	/30youVpDC+DNoXfiQLeyJGrh8YR3rQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YbXPzbLq;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780398399;
	b=pTaxJdwQalWLSYwKCTFgs3BEsrQpn+wV50W3oOuCsR86gEPb+KVejC8L8syiX1bTJ5RInJ
	E45j54SSIP4TQjmgFkXy8TroNnkzU06N/9H2bsKjY7at8uQN1lW62UKR4Z9F1guev3GFSH
	VzxD/WGjQ/22pch4z+FmaQH3J/ncPjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F20160142;
	Tue,  2 Jun 2026 11:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499261F00893;
	Tue,  2 Jun 2026 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780398398;
	bh=/qu2IPDA2PF27oFfKuoclvpV/15L0SmXzGjwgc+d/YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbXPzbLqpsZzF8BOiz9XEsDfv6n4Bf1OMs6c6X4a27qhvD921Npd1UHFkdlX4eJhF
	 mWQ7wVgbUMakNMG7Eo/RjDdPbwJmJZc4jPmm1hcwZEYVBLmQIjdbtclIs/Qkr+HH+q
	 6e52Ftzv7kdrfrlE/SU+OAccwZjTkLw+/nZG0+BQDAkgCzjK3H6LEvw9H4leqhsDuj
	 mopU11kaN5RAtQRs1WrJPZ6YJ4UzXnlQsvAoem+rThKzzTadQtqJJ2mW3wx/XGPqCZ
	 Bd7rDshuzOWYFCnTS3m9U0e0V5bAiTXLP/UC//8Oj9Do8SKfA7mvaCIo698dlHJcE8
	 uFw23qGiVda/w==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/3] drivers/char/mem: eliminate unnecessary use of success_hook
Date: Tue,  2 Jun 2026 12:06:25 +0100
Message-ID: <010579cca6787cf7bb057ab1f7228978b10601c8.1780397980.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780397980.git.ljs@kernel.org>
References: <cover.1780397980.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE0FD40015
X-Stat-Signature: sk7ezaci64o7hphz1c5yc59apti591hi
X-Rspam-User: 
X-HE-Tag: 1780398399-188157
X-HE-Meta: U2FsdGVkX18C8IxODKkEHbvBF0OuaAdztTpxcl0PZfnc099bfY/Pmyc3YFUEwB8VYPSLY9M4+5HqDxMbeSfuM2HToh1LI1J1542j394ENhriy6JiPohvdv34mOHHiTkpH3YK0t8vcfBzoj4aNDCNDrd8dg8vnjcaH0pm/n2x+JN5zSp06yZPbBdnNoQ09sdH/QuosSMYQxZQ/j2K67PbiM5PfksHfkxGicXjwti6qQPx0nnR6XUgOS5yqEotoeN45XBq/Zf+KxG7IKtYRDmSG6IEHfPy0au/IZZgnj4r8THnzrsfPkeAP8t7W1hm43PjUGgKM4GrVssTv/iYEqQ9+DBySS+Cv9bayoBDS4A+SWy/U8mdKVIhTFa3HEvFgMznrVLpEijcF75PsCSqJLHzs56mKfLXYlozd1iWBTxnjis8D7c4HpFeif1VROXZ0b0Q+4lmITg+HSzt/IvmMDm8xtwCfmxmTeIcHqb56I+/C93lKAZGgs/eSXwUIDQ8d3x8000P30XISLRVosiyeFUmKH4K19woVdH1rlSaKYOWRqdn5yVKS6qVOGbZwS0vYr39P0sUAMKERSMEZMr7mJ3kOJxNl3EkRFFyjbl01Cs4H4Y0G0PL3rzkOZoeEywE26NFYLkUDmF03D9YewL7MN+g7yxJPxNmk1TW/yXgQIHkSfalg86L08TilSdg8PZXhWg8Fre7qUtMwZHZBLmaYfg7BPpiBa+DSiEod2OBiAiyag9DupBCUUHEGhTEGM4DPc0S02fJQumqOnazTozm/bYPVcV4cNpdprHBgGvQ+jwBeLANczCJshUNQ+pkTj6x/+2yuRKuRY+Q3ssBGg9UdBjTTWVn6iddQDricXsQ8WPkoENI5uDCZGWJIsokNjI8eXjY2HCkN0zG8HahxW6xZrc67D5WiETdsYapzA6Z5+aXXTFKlQNXcxA7hVtNvwSdPrVo6mS5pdRPalJqbKC2Pcu
 XJQf/tMn
 sG1Bl+UkCfozMKdJ3L4VJNzWWbXQ2zA77Ydt1CpuRru8FS/4+g6C1OzoHuqRgMYX6CDwSXcbgYV3mV9nvMRlPq/1JpsCRhl3150Lx8StgfxOVELsmAzZqmmiE/0TC/xcMNxeeVbL02Z34krGijMtK9cmCZp7dZ5x3TR3484jUrJlLMDr15DU1bm94Mn3u1nZ9DXpCkoeaERrCK07cl+aMd8S3GicOKywU57VP44vP8hGZOMv2+1Bzl09WIZcBR6yeMEsbUbV2ZCP3imTn+cr+w68s0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

/dev/zero, uniquely, marks memory mapped there as anonymous.  This is
currently achieved using the mmap_action->success_hook.

However this hook circumvents the abstraction of VMA initialisation so
it's preferable to do things a different way.

To achieve this, this patch firstly defaults the VMA descriptor's vm_ops
field to the dummy VMA operations, which is what file-backed VMAs default
this field to.

That way, we can detect whether a driver sets this field to NULL in order
to mark it anonymous.

We then introduce vma_desc_set_anonymous() to do this explicitly, and
invoke it in mmap_zero_prepare().

This way, any driver which does not explicitly set desc->vm_ops, retains
the dummy vm_ops as they would previously.

We also update set_vma_user_defined_fields() to make clear that we are
either setting vma->vm_ops to what is provided by the driver (or
defaulting to dummy_vm_ops if not set), or setting the VMA anonymous.

This lays the groundwork for removing the success hook.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/char/mem.c              | 17 +++++------------
 include/linux/mm.h              |  5 +++++
 mm/util.c                       |  1 +
 mm/vma.c                        |  3 +++
 tools/testing/vma/include/dup.h |  1 +
 5 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 5fd421e48c04..a4297eb39887 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -504,17 +504,6 @@ static ssize_t read_zero(struct file *file, char __user *buf,
 	return cleared;
 }
 
-static int mmap_zero_private_success(const struct vm_area_struct *vma)
-{
-	/*
-	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
-	 * of /dev/zero anonymous, despite it not being.
-	 */
-	vma_set_anonymous((struct vm_area_struct *)vma);
-
-	return 0;
-}
-
 static int mmap_zero_prepare(struct vm_area_desc *desc)
 {
 #ifndef CONFIG_MMU
@@ -523,7 +512,11 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
 	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
-	desc->action.success_hook = mmap_zero_private_success;
+	/*
+	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
+	 * of /dev/zero anonymous, despite it not being.
+	 */
+	vma_desc_set_anonymous(desc);
 	return 0;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 11f440e9d7cd..0f2612a70fb1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1489,6 +1489,11 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
 	vma->vm_ops = NULL;
 }
 
+static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
+{
+	desc->vm_ops = NULL;
+}
+
 static inline bool vma_is_anonymous(struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
diff --git a/mm/util.c b/mm/util.c
index 3cc949a0b7ed..2b2a9df689d7 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1192,6 +1192,7 @@ void compat_set_desc_from_vma(struct vm_area_desc *desc,
 	desc->vm_file = vma->vm_file;
 	desc->vma_flags = vma->flags;
 	desc->page_prot = vma->vm_page_prot;
+	desc->vm_ops = vma->vm_ops;
 
 	/* Default. */
 	desc->action.type = MMAP_NOTHING;
diff --git a/mm/vma.c b/mm/vma.c
index d90791b00a7b..9eea2850818a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2697,6 +2697,8 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
 {
 	if (map->vm_ops)
 		vma->vm_ops = map->vm_ops;
+	else	/* Only /dev/zero should do this. */
+		vma_set_anonymous(vma);
 	vma->vm_private_data = map->vm_private_data;
 }
 
@@ -2744,6 +2746,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		.action = {
 			.type = MMAP_NOTHING, /* Default to no further action. */
 		},
+		.vm_ops = &vma_dummy_vm_ops,
 	};
 	bool allocated_new = false;
 	int error;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 9e0dfd3a85b0..306171d061e7 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1303,6 +1303,7 @@ static inline void compat_set_desc_from_vma(struct vm_area_desc *desc,
 	desc->vm_file = vma->vm_file;
 	desc->vma_flags = vma->flags;
 	desc->page_prot = vma->vm_page_prot;
+	desc->vm_ops = vma->vm_ops;
 
 	/* Default. */
 	desc->action.type = MMAP_NOTHING;
-- 
2.54.0


