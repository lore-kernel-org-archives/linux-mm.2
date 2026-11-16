Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C040860A2618
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ft01kBTQ
Received: by kanga.kvack.org (Postfix)
	id 79F956B05BD; Mon, 16 Nov 2026 04:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBA86B05BE; Mon, 16 Nov 2026 04:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556776B05BF; Mon, 16 Nov 2026 04:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 277BB6B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:45:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 935DEC0916
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:12 +0000 (UTC)
X-FDA: 85440498864.01.73C6521
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D2DAF80009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ft01kBTQ;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7T9ynTkV4YsO/iVdJcFIbPQ2DiH/ucpb0T4B/QE4bOs=;
	b=OO/swOREy2S+MY/+23tcBN17g9MbYVSTBAsognEV7E8W4DA35yPqioPbMHrjyshsmowt51
	eVVVP581UmiQLpC4qWE7T7SfvDerb6ZxPyMOKb1vw4bGs07AqH6YmNKl2KRHcuuVkZFm2T
	WfNZ/1at8/E6LXJDDlxgixrlinMODb0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822311;
	b=hsX2LgkyGoWotCaIyjDrXqjXpg1FDEmFJUzReVvp4fy0U+1zNmx3zFEvA/BrHgU68U9d0R
	Qy6lbVgCloUdS2Bo27ygR/13q749N/F8Vb4uTfgE19qd+fIz3EqcC3c+i5y1rfb3/cFQhR
	AMe2Iu7M12DH5J8VRukAfYJlvfmsWSA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ft01kBTQ;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 188AE46133;
	Mon, 16 Nov 2026 09:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF9C1F00925;
	Mon, 16 Nov 2026 09:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822310;
	bh=7T9ynTkV4YsO/iVdJcFIbPQ2DiH/ucpb0T4B/QE4bOs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ft01kBTQjtb3tTFugCBjTwuW6pw6jQihhhRFYxyr6NHo1/5TUNuslgS38WZ/Y2bvf
	 M6iYKB+yooVBjT4N1uQ4GKP23TCNj8qA9TMSA2L78LtCv/p+hH2jOeML9EJErrvMnt
	 4XDb8ED13Oem2tDu1VBeMZb1fddJ4/zYSGTov12PR2CxcRRKBGTcBJTI6FzKdoAoIQ
	 mHnSiZOcCY4i9HoncVw25osu68F7pWDzyOkVy2sO6WHZXF7anfSm1nmsMbax1qh6df
	 H8fqLOSgeSolbGyAJWHSXEmJT3aUtLGUkMeylTpYWfwCZjnMEEP709pYIjpJ/zg44P
	 i11CeNNXJ8ILw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:07 +0100
Subject: [PATCH v2 10/13] ovl: return the error from the lazy lowerdata
 lookup in ovl_d_real()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-10-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4078; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mh3e0v2O9oO1OzXvLpc53qgpoN0+L7fgpfypazM4mWQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulDlca9adXZ7csyqIIaGjPx7re7H5j698fyI0A/DO
 /6FzN9OdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyk+BHDH45FpfsXbGw/O8Xm
 e/jXvkxGfuawjMhwtusfUl26GCKen2Zk2PCsdAazz5Zni+2jH+XxvddgvSMcq/9PsDVYXPjgSXN
 1JgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D2DAF80009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qkm61fhf1cdoyf6tdowo8g81agegureg
X-Rspam-User: 
X-HE-Tag: 1794822310-644409
X-HE-Meta: U2FsdGVkX18pZzTt8d4Nm/DhZCGWOkudDrfPtOiGnsZngLnO8rkKPpB4WNctc+NrTAjkJ/ZrRUdahyIznhVg2hnOgNj10qcG/M5A87yp8h3ndJwqjgaumZQ1mTP0tk7j7RwZJPf+rAGUZQuEOfBYEINJSAL2b6UPf3M2ntceMo8M8HLqda027ppT13n88LbTB+wiHS7eM6qY+wYjaShKD86kGA77czGFHDVcHrS4IvL2z6EVdGXuSBeZxLoAOCA9GEhxi267nJCTQROKmnVCOh2ZoTzdHBBgItt2/MzgFuVRNrCT/5XmTvS0GHeuLNkSe7JpW/MpE/h2bLyI9F6I+SXcYsMB+wYotE89nWEO5aPdWSagbAaViKY1+9j8WShxzGbE8Ui4vihM7q7x9UGdhD8TL02gsecRq1HTGoeg7GbX+Dlhj2sU8XBKcKKmg+DSokH7Vk03seQZKA6zVBuBsUdQb2BChZmn6112JaWrTl1iU4Ghh3q5pliaJN69Fczqc3ohJ3BlZ0mwX8NMuONaz2IWq+UcxMwREkVvcqO43SFFbCCG1VEi4e4gcDe0YdWzIwd5vZyVuNPvXotIee786jT+nVPbxafZAq3iERXcRi6rNiRDeKyAwbXK116NBwx7uEymB/WWyj8rN0Yf9Ik/HelR2bQ3M9TUrkfFp/YQOiTnep7pIgk2qSgPOUZ5SgEX/n0V/YZ/uZtPm2zos6XlfgAQBy7iGZdLl4KecGhqoYvCesWDd3VK1ImwOsVZ5JXdVUOJNC1ckkZ4V0PkYmQgEIaIwHirZPUI+Cl+y7fZFAX1ZbmjLm61z5BvOZkhkNyAareLyYO+LYqT3G3m8YET3lc0Vv8ZYXAqRo93rpY8iHEFG7yDEpiH5VAMxiJDp0F6nnlyFFXsW7i73i/UxtGUtsOvk2xCxOvqAzE7Xqg6v91s0/QAqZk+GtU5XqW1WqFuMq63+GVwNHhdDer++3k
 1RScFvdW
 7xs+nHRgA0nRyerlNuNWp0kCn9ihhCOwHAKv2g04w4Mx/OmZ/gSogxoOh5i1dMaeK6+784lIlDyIucjnNBM3+aCzE7Ei/AKb698+sovsBAuKBJMDzmZcAMbwXK6cdDvMZTLimp1tfJt3QxT6UisC++qNuc/vj71qVQkuO+xoD1Xkd+bGDC8UR/rFIPxk6Kn/ksP1LQ90pW5lEAq7S64rrGPqtkMsQYySCtAwjEi+vuqPpB+sH5uEsHNaBOw9oZJnjg6qC6lUiLPiT0lh4ArcfX90SS7zYgyPlvGLQtsfuT7l4AbkUqrBYS/2SLxu3y6IhqdV2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

All callers have been converted to d_real_data_inode() and handle an
error now. So return the error from ovl_verify_lowerdata() just like
ovl_open() does. The lowerdata dentry missing after a successful
ovl_verify_lowerdata() would be an overlayfs bug, so keep warning about
that but return -EIO like ovl_open() does when it has no real path.
D_REAL_METADATA never looks anything up and still can't fail.

Update the comment in ovl_d_real() and the documentation of d_real() in
dcache.h and vfs.rst accordingly.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/vfs.rst |  7 +++++++
 fs/overlayfs/super.c              | 17 +++++++++--------
 include/linux/dcache.h            |  6 ++++++
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1824462a43711..ff7ea00a42ad7 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1374,6 +1374,13 @@ defined:
 	for returning the real underlying dentry that refers to the inode
 	hosting the file's data or metadata respectively.
 
+	For D_REAL_DATA the filesystem may have to look up the data first,
+	e.g., for a file that was never opened.  If that fails an ERR_PTR()
+	is returned and callers must handle it.  Callers must handle an
+	ERR_PTR() for D_REAL_METADATA as well.  Most callers should use
+	d_real_data_inode() or d_real_metadata_inode() instead of calling
+	d_real() directly.
+
 	For non-regular files, the 'dentry' argument is returned.
 
 ``d_unalias_trylock``
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1985b553a47b7..39d4d57dec230 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -42,7 +42,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry, enum d_real_type type)
 	}
 
 	if (!d_is_reg(dentry)) {
-		/* d_real_inode() is only relevant for regular files */
+		/* d_real() is only relevant for regular files */
 		return dentry;
 	}
 
@@ -57,17 +57,18 @@ static struct dentry *ovl_d_real(struct dentry *dentry, enum d_real_type type)
 	}
 
 	/*
-	 * Best effort lazy lookup of lowerdata for D_REAL_DATA case to return
-	 * the real lowerdata dentry. Callers may ask for files that were never
-	 * opened, e.g. for uprobes or O_PATH files, so the lookup can fail
-	 * here. Return the overlayfs dentry then.
+	 * Lazy lookup of lowerdata for the D_REAL_DATA case to return the real
+	 * lowerdata dentry. Callers may ask for files that were never opened,
+	 * e.g., for uprobes or O_PATH files, and the lookup or the verity
+	 * validation can fail. Return the error then, just like ovl_open()
+	 * would. Callers of d_real() have to deal with that.
 	 */
 	err = ovl_verify_lowerdata(dentry);
 	if (err)
-		return dentry;
+		return ERR_PTR(err);
 	lower = ovl_dentry_lowerdata(dentry);
-	if (!lower)
-		goto bug;
+	if (WARN_ON_ONCE(!lower))
+		return ERR_PTR(-EIO);
 
 real_lower:
 	/* Handle recursion into stacked lower fs */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index a75016a713d4a..fd8853622f250 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -638,7 +638,13 @@ static inline struct inode *d_backing_inode(const struct dentry *upper)
  * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
  *
+ * For D_REAL_DATA the union/overlay may have to look up the data first. This
+ * can sleep and it can fail. Callers must handle errors for D_REAL_METADATA
+ * as well.
+ *
  * See also: Documentation/filesystems/vfs.rst
+ *
+ * Return: The real dentry, or an ERR_PTR() if it can't be resolved.
  */
 static inline struct dentry *d_real(struct dentry *dentry, enum d_real_type type)
 {

-- 
2.53.0


