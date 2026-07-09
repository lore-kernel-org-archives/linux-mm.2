Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E10C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DD9A6B0005; Thu,  9 Jul 2026 18:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E346B00A2; Thu,  9 Jul 2026 18:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856DF6B00A3; Thu,  9 Jul 2026 18:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA476B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E10B01402D0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:42 +0000 (UTC)
X-FDA: 84970683924.25.211EB31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0FDD116000C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhE3Qxq3;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYhRSL4gTThOEjvt0X6PZN1r/pK2hkBS6685XeAfpIA=;
	b=GcKxoM5mj9ryjS6vjEgEG56ORrc9yq7262LL9nlQbb1eRx7bEprUumoh4CXunUjf8rCnmN
	Wcr/tvj19pkE4wbpsGp95e6hrrJUZ6fW5kqIAraHya9IkRVMmTHKvINjskTFIFr1xYW72s
	yvS2gz+JG2UZqx0sNXGQFcHfplQ58U8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhE3Qxq3;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636241;
	b=rawFScwQk8orAfZYUom1BOv/or0OF02FWAXeTf2D0oWsrrnvaBAelYxWAQsO2xJ40fTRR4
	1lhH2kvtKaTvnX+fAfET1OWDc6GQ09KnHlmIcFqrKCpdBry+e/7cj/B3bQmlJw00CqIo+L
	a/NcaEn/XL8gUlqjPSSebMFmwhkxyV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60BDC42B14;
	Thu,  9 Jul 2026 22:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E195F1F00A3A;
	Thu,  9 Jul 2026 22:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636240;
	bh=FYhRSL4gTThOEjvt0X6PZN1r/pK2hkBS6685XeAfpIA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AhE3Qxq35L6o9awQ642HN5onsUC7XKfku9a31vElmqwPl5ylZlBgYVwkg1/TFqn4w
	 M/xNQgNe257Bc1ODRe6eFtVyI7yGI19XIgoOCfdnO72id63LZ8Y7gYz2aGSKJQwcPg
	 qtz7CyY8FVBjSWFvJWM+nvtKCPf41cwjAvYQXm+0YDB64KeC+T9w0t8G1Y8BxoxWTZ
	 1azM1bei2mDBi9i6Pwk+dXNo6pIrF8YH0uv7yABhPVPfD9aY79K46ndDPSe3wUOSC2
	 m6Ua+aMxk9wATGtodHkplXu15Ik+0CMJCtp4Ur8OuI4WagfepNsdEdSml/vKchN/FO
	 F2r9k4Uw2h6vA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:07 +0200
Subject: [PATCH v2 12/23] binfmt_misc: factor out the entry matching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-12-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2880; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TkHS8svwwTJ1Obe3L+vKAPhau92Mc/d3NI+a2XNdFBw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHz9zSBwZ9tNxdnXPknenJQazpht3vtmJ5ffn0fdZ
 gzb56Uld5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExE0p2R4f5tsY6ae//Osyvt
 6vq24/bNeQfDnPMWzjKrfv/3y01zhRUMfyUyBbM36yyJdp2gsvroX2+Pk1s3HZl4l+mOzG2Vc64
 S/3gA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ngbrksa1uq1j8nqr4qzxwxptud9wsdxh
X-Rspamd-Queue-Id: 0FDD116000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783636240-360682
X-HE-Meta: U2FsdGVkX199zbyBzfIa86avPI8+qB1fEWlqnv5Yxo/iyw1sEYZ6SPFIC92C6UAFfshzZtODvUdbv0CC7DEYahMLJ+K+ugrjpQvJoQqY/0tBRb2lzbOHzRTlXiWD/ZYLmu6h/0xYUsUtzHB/D2zFUb8QIHQWfa+Ozv4Bja6mYliQ5fmNBDHp+sklgfww5crvsMSXyOdG9V2t1oUWfRioZiPXAtu70LXreG4yTt2LTcvlMFRSNVyvM8TxxLaAVyG0ahtf9+lvH2FlfBfIZHdcqdmUo5PBEh6h0CztZFNqdYzMhxjHhQQDg7O00fD+71drM2ZB1pu8fKn/KMrVBNRdBqh6dZUqs6Jrnx3967tOX8Z6E+X/Hd+CCa7zOFf/DNji5ZJt58hN/aXl0xr6P3xIpk/14wZpMeMEv7V+yqsLbNyC7y0mrA48j7jUYcQx1FdF60TfwVYVk4HEAoNrX4NXW73Jr1AOkiclzIGcYoZ7QvjO2FhYYlfY8Zbi5s906kOqwfnqkX55RPKx0ikDLMB/yiu6utaGA9MmpMgI6iUk99ozPSguXYoZFFokHyDP3BHz/hlaGb8KA9leKxwpPIuVfuDOv9QSr2rWFGGN4QsC1yGtd9crFDFH57U0exMhutyzgIJdmArMEAU4Zg1oKV87mQqlVB8ED+UMHT1FQ+rxMcQXoU8a4iPSC8lN05pLcafrfpoapBqVrqqFIXN/0wKbVLzh36PzAGbXksqiazU5RCJSmVhUk2bC3rIvF9rx2JlvFEoAUlQ3t2lGpUFnXvGrZYGddvWxIYAUnRNRBsnns5/E/1/5GzQc6FzwJWjidcf+AH0+QYrnZ7YZ7w/+KtMfId3ziZJ/BdkS1FfuEkF7D2YbETQhU76tgW2JKfqHzu2mCG4VxXAFJ/yq2UhLPLMmR1G7QbSKr8FeELHN3M0YdxNe6kBhmGd4g/P2EGhYgiz7knhAG85t17IMUuClvGd
 akaSH/u8
 vyOcfDKPcUZeZtpwRuarMKU/jp+o8xysoVrgd0RcuCOwB14MpS1JLPu8+b58NxWIoFBU8GpzymYUm0jFEsZdrQDTUmnJOyz6+NZzjYt96wY+cSmEAbSq3Ef8uOryqCvKio9dzuwwqC2aG4Ed5vN+bsSFBYUzWQl8AfpDZNffpAMB7xp6yanNHwoVQz37w2LPVodmOcgEbICDNjUgDDNVKKpWjjXazT82X/NI8jG+/MvclUXCzxDgtQ3GM43aAGPjpQCLWzmdx51ZQZic6PyS2l1t0ZGOQ2qFsJtR5+9wgUj1dRRyMWN8HkN17p7srSibsDrKfOfmMgFqNi4hcqT7fh7w6lNzNgX15HHIb1Jz5fMKlkXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

search_binfmt_handler() open-codes both match types in one loop body
with the maskless magic comparison spelled as a manual xor loop that
is just memcmp() in disguise. Move the extension and magic checks
into helpers so the walk reads as policy - skip disabled entries,
match by entry type - and the maskless case actually uses memcmp().

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 50 +++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index dac2b423280c..688554caef3a 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -78,6 +78,29 @@ static struct file_system_type bm_fs_type;
  */
 #define MAX_REGISTER_LENGTH 1920
 
+/* Check if @e's magic matches @bprm's buffer, applying the mask if set. */
+static bool entry_matches_magic(const struct binfmt_misc_entry *e,
+				const struct linux_binprm *bprm)
+{
+	const char *s = bprm->buf + e->offset;
+	int i;
+
+	if (!e->mask)
+		return !memcmp(s, e->magic, e->size);
+
+	for (i = 0; i < e->size; i++)
+		if ((s[i] ^ e->magic[i]) & e->mask[i])
+			return false;
+	return true;
+}
+
+/* Check if @e's registered extension matches @ext, NULL if there is none. */
+static bool entry_matches_extension(const struct binfmt_misc_entry *e,
+				    const char *ext)
+{
+	return ext && !strcmp(e->magic, ext);
+}
+
 /**
  * search_binfmt_handler - search for a binary handler for @bprm
  * @misc: handle to binfmt_misc instance
@@ -93,38 +116,23 @@ static struct file_system_type bm_fs_type;
 static struct binfmt_misc_entry *
 search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
 {
-	char *p = strrchr(bprm->interp, '.');
+	char *dot = strrchr(bprm->interp, '.');
+	const char *ext = dot ? dot + 1 : NULL;
 	struct binfmt_misc_entry *e;
 
 	/* Walk all the registered handlers. */
 	hlist_for_each_entry_rcu(e, &misc->entries, node) {
-		char *s;
-		int j;
-
 		/* Make sure this one is currently enabled. */
 		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 			continue;
 
-		/* Do matching based on extension if applicable. */
-		if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
-			if (p && !strcmp(e->magic, p + 1))
+		if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
+			if (entry_matches_magic(e, bprm))
 				return e;
-			continue;
-		}
-
-		/* Do matching based on magic & mask. */
-		s = bprm->buf + e->offset;
-		if (e->mask) {
-			for (j = 0; j < e->size; j++)
-				if ((*s++ ^ e->magic[j]) & e->mask[j])
-					break;
 		} else {
-			for (j = 0; j < e->size; j++)
-				if ((*s++ ^ e->magic[j]))
-					break;
+			if (entry_matches_extension(e, ext))
+				return e;
 		}
-		if (j == e->size)
-			return e;
 	}
 
 	return NULL;

-- 
2.53.0


