Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548DC606A8A4
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kITTNKSS
Received: by kanga.kvack.org (Postfix)
	id C161B6B05B2; Sun, 15 Nov 2026 09:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F3E6B05B3; Sun, 15 Nov 2026 09:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F536B05B4; Sun, 15 Nov 2026 09:02:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 742D16B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D985B120743
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:22 +0000 (UTC)
X-FDA: 85437518124.29.20645AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 01A201A000B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kITTNKSS;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751341;
	b=y4oISYjdiuRuCLLbzbhDwGZRcWG6mBFVWtkyiNwgrDkIPcsVsR3x+ZZlPBydR2YhKt82p7
	NVsO6JMqKtqdSeQ3kr8jDyJ7GwjMoBU2u3v3/i0cMusWs7UeGMbdGVFtKkmdOvwQ9oZOU9
	n5H6d5XdLrM/51/b7IgRLMYvx9f1LOM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kITTNKSS;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DcJPqoTIqU3DThjLnJPMhCVprJHt+RxP4LV+bwrcWc=;
	b=yAcaTmJeS7mwuNZ/CHiXpQnRSNEVeXXMC0IDfb6eRe6jLIHi+tLvAWuoPh/GJQhSTH8tkH
	Swl+SbXr5rCFGffAekYf/NZEf+3VQ5EsnJArJr9w+MVNTkRPnt+ArebJHcwlxWSe65QKHT
	n8w3ddJ5FzTbxLUkYXUJ2ldOKrR8YCQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DE9445043;
	Sun, 15 Nov 2026 14:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E034F1F000C5;
	Sun, 15 Nov 2026 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751339;
	bh=8DcJPqoTIqU3DThjLnJPMhCVprJHt+RxP4LV+bwrcWc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kITTNKSS9mm8yBndEG/cxjD+IPNbPBXi5J53OOrpv/ZSyKWGdV8UfaHuw8+tT2t3q
	 Q5uHn8efX7ZIMM8zCgpu71OJqOhqbxm39EPsvAXO499fhnwtqZKkAzQdRKdRsoK6kh
	 pm3o0Xh41WktXxJfHv1Px/dBD3GjnIYxofN7MGKAc76WBxjCDgHx995pgCM2fev6fL
	 ZpsYJyN6zuc6RL6yMqWseAT4Luzp0uoxMCVihyh0Sx0k4YyPjgWGDEUDrVdRnlZWKw
	 0TrNAAbao/NNdtt3tp+4xRr9Is+n5+i4p51bd4Rhua/+4xcbmWu8iow9ARgqwF9O9Z
	 DTjUXXO5WBBsA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:32 +0100
Subject: [PATCH 02/13] fs: add d_real_data_inode() and
 d_real_metadata_inode()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-2-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3553; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r/TK4S9fdHcWiH8C2c6UfK7xalJuGV7ntU2PLLcgpwQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B3o9HiBWLhyQ+/PoPIpPCVP/896/Ozi+6QtqevnH
 lmT5jhbuqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi72cwMqy96J9hur2P34HX
 ertSgf4lxQKnCRN6UjWW/T+//Z+rqTnDP31Rjs7Xat8CmoU+ndGxNJjzfUnNwa0JS2X3/dmu1vA
 pgwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: s8t6fiam6nrgkmfn6z6c14y3nkwifq44
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01A201A000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794751340-689041
X-HE-Meta: U2FsdGVkX19oY89BJLR9FN7wXx3dJtyJBBD9zaJXeXu33kaljdhXxp/R7p0DvRTiN1XjAJChHfg+WQKfctfRDLETG1cCz1hGAeixTznlQYSmqsbCGHR8OcbbOUxv6ftCOA72oP46nD5eOUyNosz4AvuV3Dl72zmDnYdY7JpnBAR4zlQy1HhTngU0iAGwWUg5lgtST+11O3vFjseWaNNm88xBbITUrSqwf1Y7hGKaII/5oxrIbncdUAwo6YjV7JnJxEhQD4yWWDsxRk3iNydZnDvK9subUP1GZLzy2OOfM8mjXMAkM0fjAXjy6ennzruIc+MmKcX7l9uGl4PugvvbWvEJlRBuaObfvazrw777ozeI/sC3r2A5E1SPqZcIoI9nIMLTh4wkLYgAioZhw5UqP5C2R/o+Jw8hUfzdqY2NhW18bxiVpZ26ctQDGXq7t3X/pp68/guvA7CBR6O06JNAtgNQYn2/kIM9zxOeXPz65gkajB2+orFSt7Y3hkF4BnG/lJmM08vKKZRxzCEnFIBeEqMfmk7IJAfF8xSNY7/2URFNjc372zbJlnFwV1dShNJgsbL98wsoMPNOsFkN6kiDOjFeVEdFjLwOuNYvN4xxFqcy7kLU5wtmHJITtNXawVPFiSB+x3UQDtTGkMBKXXJwezmZBVpkYi0Ym9RECX/cYtUjlBZGmRF8Jed2MFEJVqeM9iSLrNY6/tm5JMyNI0E2lHiLdGf44c2eD4728wveXU04ww8F1A8XdkP2VMcHQl6idl6Byp1GCAdd8RZUTpDVp0Ije2rcQ4XEGoW8cxmFgW7HrIAaXydhk4UNd7GcEqNmQ2Bki2H1k1vHPcQL10rrFOv2BeTtB6muJ3t7NrZZPOxXuvEfP06Rx9jJoGdV+u2unirlvXqAWq2ip/YpRCi9lfnkCCTlc6z5nrjGMwaM63mZIW8IGL/Yet3L7ZRN78i8kTwTkLVejVdvzn1UgP+
 XlH+MI0x
 4xz8gB8Z3jZcERq1Smmp8iR5MqTQdCmuaAth/B4jB5eNCZYMAT+YOqd0fXqrnivG+bkbvQndRpXJIxnXUpH3kY1lPt7QzAxsxeWP38WWwo3y1fW/felYWYP4zqTnMoe/oaRKIGw+1Ee4wDGfI6LYdjibCE0JjkYDjhk56vyiDjjJ2aE26St/r/hWCgk+u/JzNtYa2C4tA9+u7rgRLMfOsLAV+U4AAOdR4Hh3MVnPUCuVDFqw2Z6JfiCZNLl4lf32XFkImhe90c0j2dJ/J7iG2gvUhFBWP5yYRh89lNExAWl+EhSqMU7CYr2AD+6AEa9r0ql5m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, d_real() can't fail. When overlayfs fails to look up the data
of a metacopy file in a data-only layer it hands back the overlayfs
dentry and callers silently work with the overlayfs inode. That's more
problematic than current callers realize.

For trace_uprobe and bpf's uprobe_multi it means uprobe_register() fails
with an -EIO that has nothing to do with the actual problem. For IMA it
means the stacked change detection is skipped and for IPE the file is
evaluated against an inode that has none of the properties of the real
file.

Teach d_real() to fail and teach all callers to handle errors. This adds
two helpers for the callers to switch over to:

- d_real_data_inode() returns the inode hosting the data or an ERR_PTR()
  if that can't be resolved.

- d_real_metadata_inode() returns the inode hosting the metadata. It
  never has to look anything up and so never fails (but no promises for
  the future).

d_real() can't fail yet so this is a pure preparation. d_real_inode()
stays around until all callers are converted.

No functional changes.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/dcache.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 84b0cfe4ed0e7..674bc50b81827 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -3,6 +3,7 @@
 #define __LINUX_DCACHE_H
 
 #include <linux/atomic.h>
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/math.h>
 #include <linux/rculist.h>
@@ -660,6 +661,49 @@ static inline struct inode *d_real_inode(const struct dentry *dentry)
 	return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
 }
 
+/**
+ * d_real_data_inode - Return the real inode hosting the data
+ * @dentry: The dentry to query
+ *
+ * If @dentry is a regular file on a union/overlay, then return the
+ * underlying, real inode that hosts its data. Otherwise return d_inode().
+ *
+ * The union/overlay may have to look up the data first. This can sleep and it
+ * can fail, e.g., because the data is missing or because its verity digest
+ * doesn't match.
+ *
+ * Return: The real inode hosting the data of @dentry, or an ERR_PTR() if it
+ * can't be resolved.
+ */
+static inline struct inode *d_real_data_inode(const struct dentry *dentry)
+{
+	struct dentry *real;
+
+	/* This usage of d_real() results in const dentry */
+	real = d_real((struct dentry *)dentry, D_REAL_DATA);
+	if (IS_ERR(real))
+		return ERR_CAST(real);
+	return d_inode(real);
+}
+
+/**
+ * d_real_metadata_inode - Return the real inode hosting the metadata
+ * @dentry: The dentry to query
+ *
+ * If @dentry is a regular file on a union/overlay, then return the
+ * underlying, real inode that hosts its metadata. Otherwise return d_inode().
+ *
+ * Unlike d_real_data_inode() this never has to look anything up and so it
+ * never fails.
+ *
+ * Return: The real inode hosting the metadata of @dentry.
+ */
+static inline struct inode *d_real_metadata_inode(const struct dentry *dentry)
+{
+	/* This usage of d_real() results in const dentry */
+	return d_inode(d_real((struct dentry *)dentry, D_REAL_METADATA));
+}
+
 struct name_snapshot {
 	struct qstr name;
 	union shortname_store inline_name;

-- 
2.53.0


