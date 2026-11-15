Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF3F60A260A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1ckdNyE
Received: by kanga.kvack.org (Postfix)
	id D01846B05BC; Sun, 15 Nov 2026 09:02:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69A46B05BD; Sun, 15 Nov 2026 09:02:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B716B05BE; Sun, 15 Nov 2026 09:02:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9BD6B05BC
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C775680745
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:42 +0000 (UTC)
X-FDA: 85437518964.02.156F28D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E802340003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1ckdNyE;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmUmQueFUIkDd/JCHFltiMkrv2GuUOEp0YdDZHToRTk=;
	b=B/9bdvCiqUOhwz6aMRX9xfCVBG/o9G0o1q7Rb0uq9flnpTZTihZLONrRJxlJwoELHE9mXY
	kmDSYOYXLKh4RydsMxafctOe4HgjOHQrJaiOCj8gyaiydNjXUBFv3bg0dzBJ+z1xd8qK05
	XVNwEeYh+Hr5KmFtKtuHBSnNdr7ZSAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751361;
	b=rNabma4Gv+1SomfKLL8enuqcPG99vi8o6/ZihomoWnBpAu0aHqu1cf7ueJ+pX/qgbiTx3U
	7b3NV0J7UBfKzwGX/w3a1N1GSX0ALk7YE94N6mzdvm1SU+5k1pmSzfF1pghec47hpQb7mi
	/D/8qhbb4FJ6vRRyWCD4wnhCPvbqO5g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1ckdNyE;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4727B45A6F;
	Sun, 15 Nov 2026 14:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30A41F000C7;
	Sun, 15 Nov 2026 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751360;
	bh=RmUmQueFUIkDd/JCHFltiMkrv2GuUOEp0YdDZHToRTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T1ckdNyEfHH/g0T9kKl/6vuBCVZ0Hyl6ls82GnvffEHiRaoYRbZHyVoprfjynxKPI
	 WVI5kZ47lN1ZhnMGADcpO6O21WTP8DSajO1y2R2mbSBOqGqjHxxodT9DITHZDBzgAI
	 ncEVlTXUGTAKGwHxFZqNfKNWyNBFVBMrUM+Vlfr3xnA8i+J1KdyUzE27IpdudkNsmA
	 w6Fu4v08wyDVHNfpJ8M0mVZSBFZGTVy42caJdvtAKDez6YzzapbGQhKTdmZ6ivFAJY
	 jSzUFNzsEixLIL3JyO7hUf6FoYTkjf4XJCj1E3pdVzYV4bRpKzPlGge+KFGMaSToGi
	 RR3SADGdIz8bQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:39 +0100
Subject: [PATCH 09/13] bpf: return NULL from bpf_real_data_inode() on
 errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-9-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1815; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Sife0/X+A5GvD2c7C2xqh/28wXOwqcHzMdpkKeO2AZA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B310pr/0Lf0HRMmn5jweuoV++Uvpz6uKvW6c9l0z
 xNbN4msaR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATOeLKyHC8ZLX6+plr4n/N
 VtoUNaVp1YmlB/WKC2JKbVi4fnbt43jJ8D/7svaGGTXiBV7hh+4ff+NlpiC+btvN2ts8fL96Jf+
 xr+IAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E802340003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: e9849ddpzwio3w5z9g9rkjsrc71t7c7h
X-Rspam-User: 
X-HE-Tag: 1794751360-541459
X-HE-Meta: U2FsdGVkX1/tgi2QifohBOC/kbrXO2xZgsRKXYqBBnnULzuDUje76WjBMAXvkUNEp4QhQg6nNqe5qplSwp3EwA+Tju4/lMS7N+waRZ4rm/r6r62EwNSTnq8xHr076XvLr8yfWYCdjdx7d1GoOlZmEK25y0dgQtppJM5vw8nwph+GNwphZXUPF4wHAXyebLX97nQi7VkILj5/m1tYLWzxT5vPEM/kEB4hcYZuqz7veS3N06CnZ6mSjBAWbM2calwnRzl4lLMF7z7eiu8wd+OtyqcvxXBs6zwYhjC00NFM+X4QgYDC0Zsv+kAQkthNBcdvxVal6oS977mqGfym/CeP0m1qvyvYXWVQAwrAa4ojiOjcbr2VckHZ8tXyd6fmutKdN515oO4rSzB97KdUjnAAjR8lcUDZCMZUFrVqRvv+0QJnsj9VH0MQLxJCVWQDJ1XwmyuPML43pmmyAuq7dCzMDfST4kzhf3exqLhOez89MNrRF1CiuFWtuU+abiereZ6Ak0j8FjjYz0YXukcV4QoafCQLD/VcvysiLl9/Q3UXWfx/knG926u6CIFGHyRKeNtm5PomR3WMxeZ9meB4vHNGSj1M9HZIAfm+YDbZMX4LqbaeyySgydzsvZuGtldPJ8pnGm+EUfZEhUyebQNnC9V6yYndjzXmsg/JniDydEqgJuUtQ2cZ/MOvc2r5LrKMKLvqeoT+ZOZOUC38pGhkGs6xfECoycnz6C2CHmzu6pF5g1An95GmBN7MwQYF2z6lCL1Dn/roGa+U7oEfF59pZnhtFdKKhHFHK+K4Nox++EF+TAOCA/1sVlhFXk6I2KDBmPqFLDLqgkbdnSIJe+EUch5jOu+36pLYew+81qebuW67e7m4nwskU8D+AcP/brCw7p9ATJrqcoCZKNt5viqYimX+wcLQ4qaWBaoqIdI8WYNJm4o+FyruMGAo7JVFgh1ybzLx5MYKm5UnyGsC993xhRn
 RZrGVhOt
 lpIReUOXbAmLn0q7BgC1ntKKe4yST0/EwxtDOOeigFU58ay5vJ4Fq6/+BPA4FS0pil1eewykIncNtN1FZ8YInCkmwDlocBD3cL4KtXFbXm65qnmx2EBpvByUCVxeu2PfuT1UODAyx6ZQk6BpwhETPnVNcX9D0UxF6pozT5kwVgYAH2a21GtZ5EYUl85gDBMzuAEjBQ6f+/V0UGICkrSSSyjhTxhi2lctX8OxZCGuatuDNwR5thLW8ESusvzpkeW+yDPZlhRWui+tdFKiOK4qDsbarV351n3VHrezE
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


