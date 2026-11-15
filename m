Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6337E606A33F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=okWrLewm
Received: by kanga.kvack.org (Postfix)
	id 7F82C6B05BD; Sun, 15 Nov 2026 09:02:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781776B05BE; Sun, 15 Nov 2026 09:02:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACC96B05BF; Sun, 15 Nov 2026 09:02:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1046B05BD
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1110A841D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:45 +0000 (UTC)
X-FDA: 85437519090.30.AFA8EE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CF2CF40015
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okWrLewm;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nk9KOAvwXnmUxfWBIIVXeG4Hr+jJ2sLSpduyD0Qh4lo=;
	b=HenPLoKFUPYwcVSJM9AGp0wOIhJft5gkK01ctXT/qjnJpunwW4G35Cm4zMs7EYDCcOC7/b
	V2osQbwtDDN6OqxGdDcMhlXUfraJ+YP7jgU0+j6TsHpMyZTutIk4pxwAMZhTvA0IS49+2I
	RvhSFUXnrOdNrvBSieJmBl0r+PyZSRc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751364;
	b=W3aRfp6QsNb75P3mskhKIwCsCWCjlrGxU32cLsnCfEgrPYgg4rEin3n7s6LZv0UzJLU/P0
	NrtRYbGP6RNowxmQXEx44UrQ2DLuYq9lO7ZTYhf417/rWlcA7lw/7hKkP9yDvkUvOmmSXG
	DQsI4/q+fU8LPdMV16SLK1A9MI8Ywu4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okWrLewm;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2952B45B3D;
	Sun, 15 Nov 2026 14:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8D51F000C8;
	Sun, 15 Nov 2026 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751363;
	bh=nk9KOAvwXnmUxfWBIIVXeG4Hr+jJ2sLSpduyD0Qh4lo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=okWrLewm0tjpkTulDAIAQQtjyW3tTDs1ZX9uqvV6m/BiotBM76BKIenGj1sCYzElw
	 CprhIONz1nVfNaoZFbC/WdEGeIb3oSzPUyI+99cZlTyRTOa4U0tN7gDc+HCOiLq7Qp
	 KGZ6ged4PJ2zgSxi8GzNBM6M2dps41Y4wPaebp4RrUTijYPl4Mkr6Sc3Edyhmf/XtJ
	 rLjzVOVhsZhuug57jVu5g5EPlx8i3gTF0uwUHtpfo18GjGq3r+/95TSmwrj09iIAgB
	 Z3RKbW/2dtWGUki0KxtO1pUW9HRFP+hXargeMtrZhe9AggvQTjAgciMRsFt7wp7I10
	 poMeBkro+HyYQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:40 +0100
Subject: [PATCH 10/13] ovl: return the error from the lazy lowerdata lookup
 in ovl_d_real()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-10-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JLedksX0Um5gAap23O86BJDyzWsAqlXP7yJwjFzO2Sw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B2d3Ne4ZNLeCckTdnictDIIXVBb4zdjrzrLHYuCh
 Sm2+porO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbyZiYjwy6X9weZipiPlacK
 hC2QD6sLWzR72uKM1/UZqxbGX9w56Sgjw/fps7v/LG9Vt6pTfGFwQHi3o2y58e83c0sPN/LsmbJ
 cnwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF2CF40015
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ig6dczw7fxnyzfb1iuagqot6ngoxcpmg
X-Rspam-User: 
X-HE-Tag: 1794751363-807029
X-HE-Meta: U2FsdGVkX1+5NP6PsWvazKSw6J21Eb8nb2E3WrtsCBfWd1sphfR5hyIjYzmWt1v2IgiEyMnH9Y4GawFrfdrs+cpNYedGO1lY/w8CDaEsrnZdbd0AqscQSipphHhWz771DsfXXggPDY1s5r5HI8mTN5OvC2+shOkoaO1xZQChPRDyhWw5siSL/3A7y/jJlGt+CwKZ13noXWVDlPqPJy4564S/Lk44EzCofLNNKl4IN343+zdi+0JglrBjc8Pm7McXBIlfzSrGINrgrMX6dlDE61WlcicqsE2KIkNo2KYkbLbBn8KvZ9LtE6esxMYr3Ft5LKRPg3865zWHblogw72dV5cyoSugbpkvTV6hNZ0DAHEuS1mGXo7WXQIsmevDGK0wN7QTsPDyMJ3qo8qZ7493JNDib06X9iEGGAQl1YM+8/F1cdC5fO34pICdqZ4c1tWKwgymehQXcFoos8XkdWpXc64GhuRy6jR6hZnGoZtNBY4JLwxMh2sRXH014xVbUcZ6IZqnpJ67kwyRQ90Gi+O0yJ+tuooCCSmri+3whjyckJS0MK7MLtVj0qB+/+OrxftPoV0yQfOcqcRvSgngE2gSLEd2C0pPZSfIiHTc/apvEfTHD5jAeKNnrVWCH2ihLzUsKIB5738uMOAMMTV5nKih5lYK0TnIpZ2ZYNokZb9OHrVjoactWsWbPoFTRMLGOEi7QEUDI6tFNN+74jgJXOF6e/X29S2JvWmATiIJV5NbrQIgbk7TU1pukGVTb+NpZuJo4daMRjFyc7u4OWPA7sgFuGibMCK3T41/LJAPcY3DorAaTCT0UBCtUuKGPWaU0BrIjaDsAkALNnN5odE0LPItbtHu01bwMz85bL2LuCIHInrbAF2P4LqEpL9HXCx7TBh8WBUqCRCZS3IxzTcSuu8m4RKbDgyIk4IlWRYbnKifCu2s1jaE8xgjYfiuVRnfAzJXb/rWvBfwe44ut1TkrZZ
 sz/gTfa5
 k05iCijNl3YiVFOtNge+mzWX/aKUFyg4Tia0B4IX2aWT8G0capbBh/U5OAMyzyXa+FVTc++oQNk3sC3cJqkYW6YVZx/6dnRUWcquu/mR7X2d7RX+ltjaA+EwPWowS2KgVdHcDNMpHUK+YR4tndyUZMt4QUNqqtqaexYeVy5Nf9f1fY4ZbKqGj4fKXKuDvlRPJx8syYR32sgt07VDI4N27NM80lQ1OtaFH74qs+/sN32x3Ri35o99beuOE/70zrv21YgVPgG64eoakxk4jXFx75au2Q5tIe2OvGNasuYJn2vxRYNePSWLlsHxrULcJw/qsNQ17
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
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/vfs.rst |  6 ++++++
 fs/overlayfs/super.c              | 17 +++++++++--------
 include/linux/dcache.h            |  6 ++++++
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1824462a43711..6953f399672f3 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1374,6 +1374,12 @@ defined:
 	for returning the real underlying dentry that refers to the inode
 	hosting the file's data or metadata respectively.
 
+	For D_REAL_DATA the filesystem may have to look up the data first,
+	e.g., for a file that was never opened.  If that fails an ERR_PTR()
+	is returned and callers must handle it.  D_REAL_METADATA must not
+	fail.  Most callers should use d_real_data_inode() or
+	d_real_metadata_inode() instead of calling d_real() directly.
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
index 674bc50b81827..5b3b34d271bd0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -638,7 +638,13 @@ static inline struct inode *d_backing_inode(const struct dentry *upper)
  * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
  *
+ * For D_REAL_DATA the union/overlay may have to look up the data first. This
+ * can sleep and it can fail. D_REAL_METADATA never fails.
+ *
  * See also: Documentation/filesystems/vfs.rst
+ *
+ * Return: The real dentry, or an ERR_PTR() for D_REAL_DATA if the data can't
+ * be resolved.
  */
 static inline struct dentry *d_real(struct dentry *dentry, enum d_real_type type)
 {

-- 
2.53.0


