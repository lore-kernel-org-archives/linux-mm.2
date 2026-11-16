Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3903606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RByDbBq0
Received: by kanga.kvack.org (Postfix)
	id 8FF4D6B05BE; Mon, 16 Nov 2026 04:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFD86B05BF; Mon, 16 Nov 2026 04:45:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752876B05C0; Mon, 16 Nov 2026 04:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48A776B05BE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:45:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D158514074D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:15 +0000 (UTC)
X-FDA: 85440498990.10.F252B1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0A0C0180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RByDbBq0;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2n7GYm1kafD6KIKhmQCKvKwi/vqwdo3wJ4VdtgD0Qw=;
	b=O+QENhkZiBCfHCsH3QGTETcdB/ohVSH7U4Vr+RoBS30HcuRi46IkCUQtErqoI7nUx5S0S+
	/tIMvFRpR0ATnO5wdzFTko/S93j1CewHEnFdYHJg+v2yLcn8evnCujeR8mTKcl4dTp4SCw
	pFkRKMjzxQQ/iyRSB496C7+cCrhwNe8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822314;
	b=KTGQAQARmj0WrDOcEqqxKrxTHqy26qDZXUH6vgYs+NSLx0CyCfvf78NFcJUbGibJgw2Jhn
	MYWeLbAorcpaTa72nT1M79xqypjFkm6MDLH3WHSU0HoFhPjsckmdx63YlnwAoNlGLTSlT+
	wDQ9PtJAAdVTLj/lx165ZCMl0N+KbwE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RByDbBq0;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90E256062C;
	Mon, 16 Nov 2026 09:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1C21F000C4;
	Mon, 16 Nov 2026 09:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822313;
	bh=l2n7GYm1kafD6KIKhmQCKvKwi/vqwdo3wJ4VdtgD0Qw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RByDbBq0EnH/k7F/+ia4GduEApm//N0OcqKwmFsf4BT0XxfLJRx9Q/3BNS7AE0kgi
	 YNRe2S8oM7A51RS1GgyMvY4SbBnOHniLnhgMYI5u4d88fXZ/cS6HDImxjd1u70pcfI
	 3qzszv+Jp/IPGLXBaWO/1m5y84RQ0ogUVX4W6it4a6dTT2TtyfOt4rURkjxkrSV+PY
	 iUnyV5fvd++UkXz/kMVXLP2dfExUScApmm2dHIhwMrORjU00/tyJyWVDQkhnW2GwSE
	 XAjNi4jGRdY3TdBl2NgIpH59Vn7mV0hPJBxddVXePy4vAac9joOWIvxWgrhhO8GWbn
	 kP4af+FT2lMWQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:08 +0100
Subject: [PATCH v2 11/13] fs: remove d_real_inode()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-11-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2354; i=brauner@kernel.org;
 h=from:subject:message-id; bh=N/tFO/f64vva6VIPqr/EXBSXpu7UN9wS9KMKs7QXnPY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulCtee6L+0rW+dorX9aqKs+8VRlQ9yugY9UnblbjU
 yKfzirFdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE9Qojw+LSVZ5KcmcLwvTb
 6m6knWfp4kl2Ydyhf+gu3ysG4cMLPjMyLJOLzHx8+snmSTvUROdP2G/9IGvanwi9+5EXNjzRmnf
 CkhUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: acgbcmjghzc8rgz6q5r18yasjopn4a4y
X-Rspamd-Queue-Id: 0A0C0180007
X-Rspam-User: 
X-HE-Tag: 1794822313-357656
X-HE-Meta: U2FsdGVkX1/wHXDX0LWBynh11W2k32GC/pNEZ6xCbIwRnRZZCcdOqivNFtfqYWUIWfiB8Joxr2Wv0u/vy8+/jSyH+JjkqroYlv0DMyhjMpxpHbWoig7AwXA3WoIzqHNVQZHbSN1SYW8oHN7bq1tXKVLn5ru7w7KcNnNBER/rGu2tS6wKyXKCloPAP/kQcJSILSSyVzprQLbvAqhegecrOeeKZn4tyAgRWR8C7D3N7z7uJc+aPOdF4RbARoUougFoGIorZddLMVXSRglfI8k1g3d4snVv89/GHaZhE/HKsDylBzd+hE7XUEZVSCESYIlVKf6Bvgr8jR5dxpdbXZCPm76wLivVC+20ASaBgvzixn1CPmhhBQgP/k2Sm5KE3aT+pOES/kIUfqirNhqP0Ij4Qvi3WqSMch09N599iIqrRcopoTG37q+I2EVbxi/zcN6WG8y+AHlMFjK1mlAdkgSFAz610d/fh/b5wdumRkEccN7FPmnYB6nzfctA1fizE9UyrJLIMHsNrDyo4weWYmr2WfT8UqgstoxHJoPsiOatcujfInJLpn2vs+eglGW/r0XPXuEtu9CNT5YaK3I7xCArDMCZAiLNwQJmHMbSBZuNPrk2R2Aa+2jJO2s5VfLlnTqqUB5Ln27fn08Dsgdz+xwFjiZ9T7TcvXPU3nerqpkvjL+0Cqv7zdXnrWcheaI2B00wigu/oEXEHJcfB46IaCx8vOcG8hIvpTJL5jVT2UnWY6TllDD4bYXD8GlCVnWC59jTvXMGxcfY5uaczT97KqjDzJn/G3hjGJvGHK0ba2J9+jowO+KUszh7msremVjiwH5vJ5dZn7c6EUwUAsmqE3a/VP+01xuFsXxCKruCm+K31CoVF+gYNC0lxMlIgMdeHmVoOa7ExEksP3IIjIMPPQ2w1PH0cR4paePqWPbK8lZEtWAfPNHHd8tGBObvSaXttDawZZCTDzsKULlTlbwaEVo
 /Qjl8VrP
 pSojYaAvGP+0CYqa2D8Nqc2nTIe5PKkYSRh0diCm9BpoGp1YAApGO45I8yJhyuNnM3A0CrZV1/6jRUy8M4u1QIwAgmUkpDEXVP2dHUpLomWZRF/e7GDif2RWXHSMbHIykTLy/UpYwdAsrqohr9uAXENLPUC+b+sMYOUTF9U9aPcL3dGtSCA/+Nd/xn6eLY0dT4DvGepZRpQlk3zWBVrpADn7y3Hjs7W6Cu1oBVlaPOCl+Muw96Nl+zwzZekNGoypxZ4XewXdj2LCnjViOY0tWhG3LJr8qZUL+J7nCLni4iz006RLZFYQSh98RfQ==
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

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/porting.rst | 10 ++++++++++
 include/linux/dcache.h                | 13 -------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c38f5df755bb5..aa0fc43907017 100644
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
+the inode hosting the metadata and handle its errors as well.
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index fd8853622f250..fe1aa8fea0c7a 100644
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


