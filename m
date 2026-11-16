Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDDF60A260B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oj+s5Paq
Received: by kanga.kvack.org (Postfix)
	id 184BB6B05BB; Mon, 16 Nov 2026 04:45:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10EA16B05BC; Mon, 16 Nov 2026 04:45:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2996B05BD; Mon, 16 Nov 2026 04:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA5776B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:45:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23463C060A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:09 +0000 (UTC)
X-FDA: 85440498738.14.87C8898
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5629B40002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oj+s5Paq;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tEmxx2uSoc83gcz1fGmTgu7ng9Xmju5bdiTJa5lEnw=;
	b=11wttTnlZ5CFJx1j3EbXGIO+K4D0qVQf0uVQtMiSyArTigWjP4ZfCOSacmYfxX6JysUagC
	z+FbFcU14AvJougsJZWhcLdmBjs1SE1ZkBUXxiPSP9oRbAEgNrff7xJHAi55lC9fHR4xPN
	2CTB1VY/xxn0UC39344l3+YUFVNMCRg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822307;
	b=i2d9XLgpvzoeIyBgB5BT5tGJrfYn6hyQW/Z+EYIaSG0PWDk2lR3e7cGBht+IWNhsdivzE4
	rgdvSlxQgYzSImgDspv/gXQKklX2uyVOaljrFjsscXAJo1TVLIyvlkV/qxBFWpbDtcpdVF
	p0hkcQw1yoa9AcmlJHMRIb54+OWcwoY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oj+s5Paq;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED54B62868;
	Mon, 16 Nov 2026 09:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89141F000C6;
	Mon, 16 Nov 2026 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822306;
	bh=7tEmxx2uSoc83gcz1fGmTgu7ng9Xmju5bdiTJa5lEnw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oj+s5PaqBt9/DbiWrY22jRs4+Mvji90JmsS6W1OCZBrH6HBD7jp0sGKwdPz2SOnFN
	 SVE89Qpp8K+XwVSwHW9MeJPGLER2NpRNrmmBWHHGCOoDWnJyQHxZbJCnaDV8mzdqzH
	 QHWGBe8BBHz/iYDy7cT95p+fnynZ/5LWKioN3whoujaZutdTNezQ5bd5aodsrF5KUX
	 gR2Az2OgzTO2RUOqA5eZzys5G096xAQwpMqj6zQPGvgB4zIma2NjXapKthcekvwH9u
	 gOJ21eUzBZefYAqjgQPl6wAj6Hq7CSepBtTkqhR9knPU31mDc92j+AEYafgpcCZw9H
	 swjYl5SyHWGpA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:06 +0100
Subject: [PATCH v2 09/13] bpf: return NULL from bpf_real_data_inode() on
 errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-9-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1862; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mYuPWfGXzyPhmBavnKn8qYRaH0QvgFc+AD0P8F1FbFg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulBRcordIOBXhFTJay2ho2f2H1u/yaOawSLezHbex
 LN9hjMndJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkejcjQ2vpA7OVL63fhMl6
 yUR2RO03/VTiv9Bnh71We1rT9XyTZYwMa7fePri5u+DW+vUH9by5VwSe0mo2nm/1VpZjf7vb99V
 aPAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: h9dtga6u873ekiior1bzfpgfuz6du9pa
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5629B40002
X-Rspam-User: 
X-HE-Tag: 1794822307-52632
X-HE-Meta: U2FsdGVkX1+2zempwvqHcpuqGD63wQBts2Hv4YJpvTHV7v1ywhuN+vk9xgUN9CvzY0z7IEmHzK/0gmrTRa/qEtXm1cCX0nHFBa1B182YUFe9k/xfRaQ8dHMu1p2k3Ko0kAxC+NlL0/5NhrMzCmgpV9mkM3abQNHkV8geG66mHG8vNhUKUnjSv7IfP9biSiLdKSnMDe4PT+JtTKfxUr++qrON44tpszu1zKki90m43IuIeJzyU6oIOPiwfBgMVqUFfFA9LPsu6BORaUnTTHtoz9wmRMs9cN0vDq/cAWPGzoKvh51+74mkuYHZZSfJeG/xMqTjwnHFbpfLLx0R4YyE7k21K0hRZHiCgwPW+AZDBiyoRatexzcem1oW4mOme57FbbTARf+a/PPRwgNKnEwvEbKaljY+BQPYo6fuF4VgfsK27k+kWiC15pEIM79COLMKnLH+QgKXMba9RSILAP7zsRjWkqHodRIRDNL0nkdNsGgmOufl8gxzAHUC2NFJ3qFJ7NJgTuvmW/P9BMYccQQh3hIMLlqVJntT7qDD99oUhIfNJD5KhvWidlip+JQ9C2V+/lvEPdtt/sDv9Hskl18rivgRZh6apGSipGQChT0NAqZJG2RYs4egBKUAc/ygyQ2FA5gzf/etw6jez4k89XRWwOJN+PYMByd+K3pTBZ5pG1lGFkA3Zd/7iOI1gJyfMaITkqsDvZZRLqaub/qRCVh8d4aLF+yK71khsdwEA6E0fFY3ytaHRfUy/R6W0FoUnPwlKk+x9KwYX02MfeB4MA3ANEAi5bR6ze3/sfnF8G01qF5mlvd1/B2Z04QKn2JvLsFYNNZaGmAvOvYj7ptjwJ8BQDPB6UguCa86/U0oVka57oQ2BFwcQIDpYTshWYan1AqhLuyikf3qZZiDiQ+gdyQO+Odh+Ihlu2JaqWvWn766ondXLigIiUqO3y5AUbp/Kd/OqyGf7DfNmgoU2aMaO0g
 aqTlx915
 AptFqGr47kq+x2TO3ZCi5791A+16CqVIaqRX8OfZjqCCgfe/iSGvsEMWZvCpLXaporolQoyv3aPJtUryS7JVGPiLjVOFVVqDQQOhOEfxrHVmzy313JoQct7aN5ghVtITU6kA93c5OefRd9XyeOGNIPyF2kx8u9R4eDRX0B/V+zjAEI4Dp/1LuscPcFYuC9oR6saVc13QCNzkJBeLVD9bl7SNr+iANd1Md1+rgKEzQveJM3pgmnuSxQBeKmquKF5Rgwr5+HA2XgLC61m04uboN79GIEhjVjE7S4WOp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail for D_REAL_DATA. So switch
bpf_real_data_inode() from d_real_inode() to d_real_data_inode() and
return NULL if the data can't be resolved.

The kfunc is already KF_SLEEPABLE | KF_RET_NULL and its documentation
says it may return NULL. So programs already have to deal with NULL and
the verifier enforces that. Note that this is the caller that most
easily ends up with a file whose data was never looked up.
lsm.s/file_open runs before ovl_open() and lsm.s/file_receive sees
O_PATH files passed via SCM_RIGHTS.

Spell that out in the documentation.

This is a no-op until d_real() can actually fail.

Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/bpf_fs_kfuncs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
index 35ccd98a4de64..ab24e6bcd64c4 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -491,11 +491,20 @@ __bpf_kfunc int bpf_sock_read_xattr(struct socket *sock, const char *name__str,
  * inode itself is returned; for any file on a non-union filesystem the inode
  * attached to @file is returned.
  *
- * Return: The inode hosting @file's data, or NULL.
+ * The union/overlay may have to look up the data first, e.g., when @file was
+ * opened with O_PATH or the program runs before the file is opened. If that
+ * fails NULL is returned.
+ *
+ * Return: The inode hosting @file's data, or NULL if it can't be resolved.
  */
 __bpf_kfunc struct inode *bpf_real_data_inode(struct file *file)
 {
-	return d_real_inode(file_dentry(file));
+	struct inode *inode;
+
+	inode = d_real_data_inode(file_dentry(file));
+	if (IS_ERR(inode))
+		return NULL;
+	return inode;
 }
 
 __bpf_kfunc_end_defs();

-- 
2.53.0


