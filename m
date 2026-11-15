Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B83606A338
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AFRuDvhf
Received: by kanga.kvack.org (Postfix)
	id 898D56B00EF; Sun, 15 Nov 2026 15:39:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849596B05B2; Sun, 15 Nov 2026 15:39:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738166B05B6; Sun, 15 Nov 2026 15:39:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45BD06B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:39:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99B4C120812
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:39:13 +0000 (UTC)
X-FDA: 85438518186.30.243301D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F0C7D1C0002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:39:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFRuDvhf;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794775152;
	b=rncEUeMNhLJy68Uay5SAv4x6QJQQUMBr2DD0DJ301LfKUew4tXIDpxA+5UE8mgrt6N5t5T
	gERj8KmdhqhodlloAqE0r9As6LmxMKqMiakOlSLqFfxQLuQ10e2EPMEAIfhCoe705JrJHx
	WYWbiKUYkXp6/hP8NBjavTHLWHf6Mq4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFRuDvhf;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794775152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYnKw1raUAzd3oGbNwevOMeKUBQWz4Y8HJx8/Ua61PM=;
	b=CP30Hax5SV6ChGqWB5ku0N40avA2ooAZzO1E+j9CyRAf0y0P1tYLl4/sHQhzYtnHbtTHR3
	UQdSkSgO53LqfWSGKV0XLkhgJWFgJ3wwdY4pVa8BvF0O1NjsiNp+ecYwagMv/BxVyWOJCk
	wYLjFwbTSxU69NiOu/MnZfA80aChOds=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D7E9413DB;
	Sun, 15 Nov 2026 20:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1A41F000C5;
	Sun, 15 Nov 2026 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775151;
	bh=SYnKw1raUAzd3oGbNwevOMeKUBQWz4Y8HJx8/Ua61PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AFRuDvhfAj0dgAanXIbk2qYSf/iBx5gTWt01dxkdS7Ht9GMgM6t9ds/0xcLpOsA86
	 XpNToIlHpVr3wZAuq+NCnLcv3HzoZW2Ncbzb2BTY4mFOykzZPZUCy7dOSMRk7oO3uC
	 QGkr+sGP/8jnXCYf0x8Cq7z+kbMmAz5NqDOOpbIU8A2QpvIz4ehLg1VWOspSCBqbcc
	 ikHcY2yewpv+tjvuFGTn77EH3h6zZj9QE5GWHkw/r57vserNyUhaWtLX+uhwTa+YCA
	 W4q7EGecCUnX/PmrhqRIaRl/43xXm0He7t1KCUdtpKTCEewe1kUEFSIkzfCk3FtK+h
	 1WOk0xcs5zBaA==
Date: Sun, 15 Nov 2026 21:39:06 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/13] fs: add d_real_data_inode() and
 d_real_metadata_inode()
Message-ID: <20261115-fechten-goldfisch-worum-5c478291ebf5@brauner>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
 <20261115-work-ovl-d_real-v1-2-ca155efbcb2e@kernel.org>
 <CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+3775xA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+3775xA@mail.gmail.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F0C7D1C0002
X-Stat-Signature: aj4kwmhr1owhsx57qhoposrehycy6myc
X-Rspam-User: 
X-HE-Tag: 1794775151-145588
X-HE-Meta: U2FsdGVkX18uDFCBH/criGXsqpsRC9+e+pnWQqgs6pP4ui0mSYgJgnBAM2HZOYZ6/WcLvPaIB7dG8Op6Cs9uriMYE5IXs3rwEmBGZCSd7eL+JYAcNNML9rqF4kNXMyV/7ALdeMeSvYKnZPEdPMdNFycfSFT2c4gXAfqizL5s6l+UDjtkS617KRY7DSe710fg5684kF7D1OaPlayuBNHQWtpVQPHfF/wC4u3newa3KXOPKjHvTYOJdDcrB0gstLgp+R63fs3uX8ArPirimVEXozbYQeDgUb5SjPcm/AkQbJc/I6aS+pE1c34DpWskjaDT2L/+vBEDC1rAu294i96/0BJLHn8tzkuOyT0aJACyDY2lsfay4uIONGF7GeTIcZ70ykWWg9pjUDh69xY0ZXLVSsquf+ZLYT/7ufbicS6ddYwWsp4VB2suMqZX9c0Rpk2lt3/wyVOt9lFhVlgQ7vCqa3n4hqdolbbhaU9OYjb4GfZri009n1kxuVPIcvg+gvSyMYD3B6esrxRFb1IYI8cpNrCfAxdeiuS0y8Zd05Pb3lneVKimoRzwSakqTz9qU13cQ0YzSIZnuhCuZ89vliwtb70p5IoLFPvTlyyRbczW7sXuku+OJYK97vFVW8ZPZ0rNUMwF8+9Wiomy2lNtB/UpN21FJaL7SzROlvzeiyplbFldeo2a3PL92RjE7ZMHK9VuTK0wyIqptHLdGqQnvWT4Jkqy+GMIrho88GcdjTq+Ck1qoFnxsKLU/VemduuRsmhsCOKhZmCQm8MPndpShF4mKEKrm+c9KuxI9k7kOL5YzZd5aGuzloQCNvyluW6cXWo+qGCpRg1wLpE7ASLokoU12TD9+4m4ty1XfTAYpcDNon6y1S5swUUAI8QKxw6F037oCEk5GnkmPgohIyFro6WFfsTBse0BoYPe63/yH3mtaUg6xn2n10R7xbD259z9iYu/qIXtfgqNSPoi86eEsWm
 gVUYtRQK
 Y46RbCNr2uO+TcjGp0G8lYhz4oI3IBh4z3/cRo7t7VJrI2cRWE48dUIN6H0zUnCHAfkocQ2Nvy8Hhy0Vww7UQT9z4yzKAe10gDVVhNCHg9KeAs8MKn4r7tPDeQPlGmWMXdrO0eokZv4DtSHd9gMn8PPBOPAXtQm9QZAFYecwPiNuE9NVBygP03Q0SGrZeEx5uBbZUwhCLjcDbUmSoN2z+TvYlQTAsYrmTrKkZVSnrqhGTTxFYjKNedrGgbvum67qeI2CjIwqdbHE/mLymd8EuQTSuHXvyONLDuwzttI0QDS1VCHll/OdENw1/tkTS8JQ1DQ6xlsJzu07m1sCAv+UhlOAU1EJEN1AFfCgv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 04:00:36PM +0100, Amir Goldstein wrote:
> Wondering out loud - since you needed to change IMA anyway and need
> IMA patches reviews, do you think it is hard to also gracefully deal with errors
> from d_real_metadata_inode() and not have to promise that it never fails?

No, that's easy enough:

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 2b15179e9baf9..477f0d29f3cbe 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -639,12 +639,12 @@ static inline struct inode *d_backing_inode(const struct dentry *upper)
  * Otherwise return the dentry itself.
  *
  * For D_REAL_DATA the union/overlay may have to look up the data first. This
- * can sleep and it can fail. D_REAL_METADATA never fails.
+ * can sleep and it can fail. Callers must handle errors for D_REAL_METADATA
+ * as well.
  *
  * See also: Documentation/filesystems/vfs.rst
  *
- * Return: The real dentry, or an ERR_PTR() for D_REAL_DATA if the data can't
- * be resolved.
+ * Return: The real dentry, or an ERR_PTR() if it can't be resolved.
  */
 static inline struct dentry *d_real(struct dentry *dentry, enum d_real_type type)
 {
@@ -686,15 +686,18 @@ static inline struct inode *d_real_data_inode(const struct dentry *dentry)
  * If @dentry is a regular file on a union/overlay, then return the
  * underlying, real inode that hosts its metadata. Otherwise return d_inode().
  *
- * Unlike d_real_data_inode() this never has to look anything up and so it
- * never fails.
- *
- * Return: The real inode hosting the metadata of @dentry.
+ * Return: The real inode hosting the metadata of @dentry, or an ERR_PTR() if
+ * it can't be resolved.
  */
 static inline struct inode *d_real_metadata_inode(const struct dentry *dentry)
 {
+	struct dentry *real;
+
 	/* This usage of d_real() results in const dentry */
-	return d_inode(d_real((struct dentry *)dentry, D_REAL_METADATA));
+	real = d_real((struct dentry *)dentry, D_REAL_METADATA);
+	if (IS_ERR(real))
+		return ERR_CAST(real);
+	return d_inode(real);
 }
 
 struct name_snapshot {
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 1b50cb4913d0b..17d528771d8fe 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -241,6 +241,9 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 	bool ima_present = false;
 	u64 i_version = 0;
 
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
 	if (!(inode->i_opflags & IOP_XATTR) ||
 	    inode->i_sb->s_user_ns != &init_user_ns)
 		return -EOPNOTSUPP;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index ac8328812e6ef..71faf156f9d6b 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -763,11 +763,11 @@ static void evm_reset_status(struct inode *inode)
 /**
  * evm_metadata_changed: Detect changes to the metadata
  * @inode: a file's inode
- * @metadata_inode: metadata inode
+ * @metadata_inode: metadata inode, or an ERR_PTR() if it can't be resolved
  *
  * On a stacked filesystem detect whether the metadata has changed. If this is
- * the case reset the evm_status associated with the inode that represents the
- * file.
+ * the case, or if the metadata inode can't be resolved, reset the evm_status
+ * associated with the inode that represents the file.
  */
 bool evm_metadata_changed(struct inode *inode, struct inode *metadata_inode)
 {
@@ -775,7 +775,8 @@ bool evm_metadata_changed(struct inode *inode, struct inode *metadata_inode)
 	bool ret = false;
 
 	if (iint) {
-		ret = (!IS_I_VERSION(metadata_inode) ||
+		ret = (IS_ERR(metadata_inode) ||
+		       !IS_I_VERSION(metadata_inode) ||
 		       integrity_inode_attrs_changed(&iint->metadata_inode,
 						     metadata_inode));
 		if (ret)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 9df7fbe3523e8..016de5a66eced 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -357,7 +357,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
 		}
 
 		/*
-		 * Reset the EVM status when metadata changed.
+		 * Reset the EVM status when metadata changed or the inode
+		 * hosting it can't be resolved.
 		 */
 		metadata_inode = d_real_metadata_inode(file_dentry(file));
 		if (evm_metadata_changed(inode, metadata_inode))
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 6953f399672f3..ff7ea00a42ad7 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1376,9 +1376,10 @@ defined:
 
 	For D_REAL_DATA the filesystem may have to look up the data first,
 	e.g., for a file that was never opened.  If that fails an ERR_PTR()
-	is returned and callers must handle it.  D_REAL_METADATA must not
-	fail.  Most callers should use d_real_data_inode() or
-	d_real_metadata_inode() instead of calling d_real() directly.
+	is returned and callers must handle it.  Callers must handle an
+	ERR_PTR() for D_REAL_METADATA as well.  Most callers should use
+	d_real_data_inode() or d_real_metadata_inode() instead of calling
+	d_real() directly.
 
 	For non-regular files, the 'dentry' argument is returned.
 
diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 28a24b702f2a6..aa0fc43907017 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1431,4 +1431,4 @@ d_real_inode() is gone. d_real() can fail for D_REAL_DATA now and returns an
 ERR_PTR() then, e.g., when overlayfs can't look up the data of a metacopy file
 in a data-only layer. Use d_real_data_inode(), which returns the inode hosting
 the data or an ERR_PTR(), and handle the error. Use d_real_metadata_inode() for
-the inode hosting the metadata. That one never fails.
+the inode hosting the metadata and handle its errors as well.

