Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4908F606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JerxBD4p
Received: by kanga.kvack.org (Postfix)
	id D018E6B05BE; Sun, 15 Nov 2026 09:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A186B05C0; Sun, 15 Nov 2026 09:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B572D6B05BE; Sun, 15 Nov 2026 09:02:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 859B86B05BE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FA3B1C4137
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:48 +0000 (UTC)
X-FDA: 85437519216.21.C838A7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B189D80006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JerxBD4p;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i08ApOXti7ASPBt661SD3n+Ftge8M76WHHcwNG2IWGM=;
	b=hzYuj3Ew9FfbE1oM9LMXOP3D9AzkfWEbOOfQ1ipagAqeymeN8Yo2Otmtcyvnob12hGsk43
	Pup3tn7kHAUY3/g7kTJW/ic7Uhv/DHqUsW/g8fVt10SA0VMDXjAadFkl+IzuImCL5bi7wz
	B9EhO6XmHHwqfbporvxfs2Wf9eNFTUA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751366;
	b=xRPlvrPKTe/Pk7QRcRQWcJPn3El2TK9IwmdBgW1cdEDXEh2cufcufOG4DWmlqBXPR+LqWs
	mkhG+VTaHHnO9g5ASuhQXw1HAS8FVrcwyqm2cdx1d/SgGeNSRXudJlSc4rskOzpnxuLjhR
	0v5fHJ8DurJi/YFtj/MYdmq8y7P+ctk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JerxBD4p;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10AB94099D;
	Sun, 15 Nov 2026 14:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830E81F000C4;
	Sun, 15 Nov 2026 14:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751366;
	bh=i08ApOXti7ASPBt661SD3n+Ftge8M76WHHcwNG2IWGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JerxBD4pM157aPDvBZHjgj0/PdbSmnKHj12oQwJ1pDtPlQIndm0OzuljJhGdN/skn
	 AbbE2kVSl2pnNBFFgBybWb91GC4AYp+a1yOhc4duqP44zOM9Z/mnygw1kr9AVHGsrj
	 C1y4ZD5T+B/CkoXS3M3wJ6NaJQ1nvPXULuDo4JvtZHg89keN12gLYINskUv6pg6qR3
	 igR8IsdaD8ILX3LcHsx0wBlQ58ZrcOiGLszGsBlWijVD9DA+hmOYQmDT9IHLHOP205
	 nUgxLMIeACAE05+2G3aO7AtqkLLsAjMVMeAUx9p4IaOKINKW6JuV5S7iRWW33SjlwY
	 NkonebJTyykHQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:41 +0100
Subject: [PATCH 11/13] fs: remove d_real_inode()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-11-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2296; i=brauner@kernel.org;
 h=from:subject:message-id; bh=bY/hKVIBtIsVVaCC+49NkZNtKSbERRV6fGevFpDq4/Y=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B1j5bw+l9O6J0zuaL9GRw2D9jGdZzf2fZEQ2/Ba8
 ZBYxwftjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm8WcTIsHziAZe2NfYaBhWL
 5v3Sk1kQ0LtqsroTp2exV8zFuKhwCYZ/2n2BZUn+uTte7465LP3+SFz//1Kn1OJABf177DY83ze
 zAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: tcdi4zp6x4n5k38mmdmsr9kjy7xk3sxp
X-Rspamd-Queue-Id: B189D80006
X-Rspam-User: 
X-HE-Tag: 1794751366-651365
X-HE-Meta: U2FsdGVkX1/YTYrewY8EvqbAOus48HiGveb9MXnkIv654QhyTcOCa2OGCl83dNOMqom5ptMaSYBH+5A+LdP4N2Q3ZxZN8oYrqbKseZyKSUACurRK8dh0oXdtk4SutnDDUw45U1alWVbw3PopVCXsd8H01sUDryjsuTbJJOKimJIIPPjiqf8l7gEybxi/GqzPFB6gXKL8mFzKquwND2LJzv6G1mBPNrJqUWV6gv11HHq116mw56rn49jOuruVYk8hPHvE5Ku57HUqQMQQee3hOHPbKebMqXdSq4wYicLvhOCNFZ/4cjBfs2G6lv69perwPUNGjPpU1NcTDQj3lT+DOp9Zr4Paa+ZR0s/j8ASsgOOzWasPkOVT36uxrMBZh1Zrw/HBzTP9wdL3n2eXPxMKoMOqB+kzhMfPPyDsG5ETMdWVGGjjVCDgPytXII1r8gosrnS94ryYnvl5lXD4gDFbYWZhhE4CRJLXGLCa5kKN/f26sKAnWABuqzqXWjJ/a/wHa7XqYudprXXhcCTuxmYDCKpaz4FW1X6pAcH32d+OvVUBbvhEkwzNuQi3AY0UrK+k4Yj/9F9dAGcHw5QBuALeabIsiZaJaz7Z7j78b94l3sdiEC03QPpgFryrPuuodu4W0meWG4GE/4C6kD5UOhnQy75TV5APZCMZBCwb7SY3zGxCJR5ISrEZTo8Xdi88U/5whiucKDMUVwWMJxXlHwPTXqQZEMPj6YTw/Lrz3YyWWkAah8fYhNWnDYtZbdaF80XPgxlEy8RnaEFG03CcxfnvI1jw+NZ/Od29AQx8gp4pnfovxoF7Ku9SQiJqwe3N0y0Ah0btyO5cqNG+asr0vikhQBJyt/WkZAPK0ojO5Pg/w5J08QM2gMeF6iWNe/VDn4hdfjnSUKJHGzn0GAQXwIP2QiEsXoHL2HPOL8Tzx4t5G1OgNUvLAcIZ/jCPB0SaUFlMFcJ2wrKq/57L5RPLhAL
 UsjzU+LZ
 KnGV+3Xktv2vODDDSDxQB7go8uT37tKjfztQU+suHK+Ym33PxWYvbnesBF2n0lnhRMIP4wz7Kgm/kY1Ti36foKjsPzbu7qvK2bX9X9EWaMnjFBWouchGtjtYUleWNtFRvS0pGtLXRSyEl/E2DazJRh1LW8LZI4sOOCzPrqnhJ+PPk/dCjIArCLeVHTX8BzGYSzHlXP0IPM8s00VR8iN9oOcmJeBXWSoq6AEK9cCLscCPbyTwViU/JHufad4fq8Yb3IrDTdao0/u8YxN4rk9JXBl5zvbben9/awif4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

All callers have been converted to d_real_data_inode() or
d_real_metadata_inode(). Remove d_real_inode() so that any user we
missed, or one that gets added in another tree, fails to build instead
of passing an ERR_PTR() from d_real() to d_inode().

Add a porting.rst entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/porting.rst | 10 ++++++++++
 include/linux/dcache.h                | 13 -------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c38f5df755bb5..28a24b702f2a6 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1422,3 +1422,13 @@ helpers take a const struct mnt_idmap *. mnt_idmap() and file_mnt_idmap()
 return one. The idmapping is immutable so nothing should have modified it
 anyway. References are taken and dropped via mnt_idmap_get() and
 mnt_idmap_put() as before, both accept a const pointer.
+
+---
+
+**mandatory**
+
+d_real_inode() is gone. d_real() can fail for D_REAL_DATA now and returns an
+ERR_PTR() then, e.g., when overlayfs can't look up the data of a metacopy file
+in a data-only layer. Use d_real_data_inode(), which returns the inode hosting
+the data or an ERR_PTR(), and handle the error. Use d_real_metadata_inode() for
+the inode hosting the metadata. That one never fails.
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 5b3b34d271bd0..2b15179e9baf9 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -654,19 +654,6 @@ static inline struct dentry *d_real(struct dentry *dentry, enum d_real_type type
 		return dentry;
 }
 
-/**
- * d_real_inode - Return the real inode hosting the data
- * @dentry: The dentry to query
- *
- * If dentry is on a union/overlay, then return the underlying, real inode.
- * Otherwise return d_inode().
- */
-static inline struct inode *d_real_inode(const struct dentry *dentry)
-{
-	/* This usage of d_real() results in const dentry */
-	return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
-}
-
 /**
  * d_real_data_inode - Return the real inode hosting the data
  * @dentry: The dentry to query

-- 
2.53.0


