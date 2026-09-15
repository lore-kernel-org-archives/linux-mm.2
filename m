Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA84C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A661A6B00C8; Tue, 15 Sep 2026 07:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3EED6B00C9; Tue, 15 Sep 2026 07:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CA66B00CA; Tue, 15 Sep 2026 07:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC906B00C8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:36:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F0C0A53D2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:09 +0000 (UTC)
X-FDA: 85215792858.16.4605540
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 41B5FC0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMJ+b7mB;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2lQ5Ka+5N2KnUU5FmxbFpjzBp5OWSe8vXNiFGVP9wo=;
	b=OW6JLiip02e2BTh6z0aexDODyo+WXrk4HUuANUaEjZfRYumLLn/yVIYVkNJ/cH1ZGvRJn4
	jbKszxlQeQ7uZIZvxZ9mbuPHqBM8AAK7avINv5kc47wBR4GmaxtFDYixcnWWQtPFBdZ49a
	sn2C9SySN+pF44SaY+b7mtOa8yNRmQY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMJ+b7mB;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472167;
	b=0zMAngXzs51JwpZkUc27FbVbYXllX38BM7sDifNNoM7eenQ27IqsQekj6d1Cdb6XlEZdR4
	0WkFDc6YIep8KdReoblkVK7weitNjXAAQMBsQUeAe0nhTh3h/CAghbbxDH6i2GtHK737Bx
	2oYNuHklcQdE50Y9cc6IEjHNFDYmob8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 807664078B;
	Tue, 15 Sep 2026 11:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA1E1F00898;
	Tue, 15 Sep 2026 11:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472166;
	bh=o2lQ5Ka+5N2KnUU5FmxbFpjzBp5OWSe8vXNiFGVP9wo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OMJ+b7mBI0Q8O65xdljhCPY3wAhJtYK6vRviUYwoOTOfvpAhVhrNZ1kCsXQAqmv7v
	 3GuPhfOQ15Waw0FL/v7cPGU1CKFB0vIzNSBGpVjd2qBgP1hQ3swVBB0qsd708/I1v5
	 vg/o9z55oXEAHcBz+9R03GejIoqfhheuysEBDKH6SjqNuu/M7QucGgMkPeQdb5GX9n
	 uQNmyO/vVkhVONQwgr/tUv50HwF7x4nXtsyG+xs9H48A8Y+g/iDSD50VrmcEX/KGAo
	 6x7qUbImLs8LGWOMAtx7W/94RYq1+vZrklFF1JGznEjJF5X02jojdwcWqWCWnxH6Bc
	 DQcVPuaGmWDvQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:23 +0200
Subject: [PATCH RFC POC 37/50] tpm: vtpm_proxy: install the server
 descriptor when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-37-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2398; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WL6iBvGKSQMcLT8fyxBve2m38vKajd88XKUitLJDfoo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KkLDfGbfS6nzTDW3+CR3ZeWem2mM3pd9c9eC2/x8
 KvW8xPoKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMhPNYb/Ude3PmqXNzFcrfTk
 c5TA/YXTT8zPT3uZ3v9yqU5S93XBRYwM/34c1tN5sX7LjoD5b9gnnuLVilnzKtv7cqb0mf/eLA+
 5+AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41B5FC0006
X-Stat-Signature: 6c6dw7y8fkqgucpmgwzejp9p8j9fzdw8
X-Rspam-User: 
X-HE-Tag: 1789472167-381885
X-HE-Meta: U2FsdGVkX1/WkipUzUMIsQIjyjYC/LgRd3UpUGxYLZTps3KQUQNSje6FKIZbqzdDzdP3cKTJZ76vR77lBGc9GBXoF9yX0yfIl2jLZwMIWEQEMhXKe04cnPuwwnsyfYa6nPaVeXg/NOrxex2NbwQrxWJtLwmtrYgcRybogO6DYcKAw0azydCVx4P28oS+urt974qwPR/kA+jbxobM0E7MzGL05yECfEkA3nwYm+yndYzbgHvbCBdEcFFcQC7G49+RdAUz3uaYDMtoXOny5/s02LfMDx9EW0houtusEJJPHDHX3JMNdtufB0OiU1YNKsWOakdvRzvo+ICKwny0Mobhu7CwpZx8VooNpPgYMCuBrgvPUjgUIe/sw3xo9+JaSD4KZqKXmPr3AcJssKdEn/w/BeWmvcksdPY6+RulFnWnOSuYlEaJ/ZmT8nveoFoIjmbxMh06OjHtzoimkj0re6pmJGcg3Nu/oBru/qAN25q1L7K86kEEQJ9zNHpaNssxmGWo0x/9uBwatmA9m1P/2JOxfTi9PEdnkqEWU51BaKI+/i4Wq2DmuX0FqOn70CwouL1Ta69bIDwmF8CiAcoCnejWhsnbhRkHZ7EDMDwiWWQM2eJ+J18PvVKY9gVLTxPFBCrVl5Bto3K1H1kxiU6ZVq/yjEh+L8xvsE8TU1pbpPB+6rNIvNjanCScxLX6ncDxb1qelbgDyt2NbcWliLE1JAVsWWX3wn3vw01jrzTakc6gmOGmM18shyHqeemGTbVwsXw9Qbri0uZVTASDPmBRJ4B/BiTjTscx+i8FaB4jRqNju4zExMCwlvto+tsv394QKpPBJ7O94mQFb6gB+GD+xfao04oWeCAlhKciw8VahpEXOkcJ2Md8zPDRZ9+21x/jVBCGPvF+his7seJg6+ggFlahHIkmlVgWN59uZCnBA2Onk4u+hjGo3/4AZMZBXw6sn5SdcqeNNJwWvTpJuQYmciu
 PiVdbAeE
 bbLU8a4SZf6C3t3ZhYQu5UWsiDtKJPrmwIpaudsva2mV3kCqTI8kvbQjcucB2XFS74x9Tk4PyqzjOJc93QHSwqFyGzxBqQ+3KmFMXmRLmiLEkGlwkVFfYpGshwXCCUunPaMXNcQ+Zs91xlGzvwGQsVvQ1TEf7oleajCB23bmAUQnNYT4Du4VLJ8BVnzVWh+7+S4nWF/yBPcr0OhhoIVVWkFdFKA4nqw98W9g0erbUVvC2bvyDgNLTxta+D450/4ehUckRlmsZPVtQsR5utAOAErdmnJMEAiUnJkYp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index b81fd2a537df..8eb87044596a 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -531,8 +531,8 @@ static struct file *vtpm_proxy_create_device(
 				 struct vtpm_proxy_new_dev *vtpm_new_dev)
 {
 	struct proxy_dev *proxy_dev;
-	int rc, fd;
 	struct file *file;
+	int rc;
 
 	if (vtpm_new_dev->flags & ~VTPM_PROXY_FLAGS_ALL)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -544,20 +544,15 @@ static struct file *vtpm_proxy_create_device(
 	proxy_dev->flags = vtpm_new_dev->flags;
 
 	/* setup an anonymous file for the server-side */
-	fd = get_unused_fd_flags(O_RDWR);
-	if (fd < 0) {
-		rc = fd;
+	FD_PREPARE(fdf, O_RDWR,
+		   anon_inode_getfile("[vtpms]", &vtpm_proxy_fops, proxy_dev,
+				      O_RDWR));
+	if (IS_ERR(fdf)) {
+		rc = PTR_ERR(fdf);
 		goto err_delete_proxy_dev;
 	}
+	file = fd_prepare_file(fdf);
 
-	file = anon_inode_getfile("[vtpms]", &vtpm_proxy_fops, proxy_dev,
-				  O_RDWR);
-	if (IS_ERR(file)) {
-		rc = PTR_ERR(file);
-		goto err_put_unused_fd;
-	}
-
-	/* from now on we can unwind with put_unused_fd() + fput() */
 	/* simulate an open() on the server side */
 	vtpm_proxy_fops_open(file);
 
@@ -566,16 +561,13 @@ static struct file *vtpm_proxy_create_device(
 
 	vtpm_proxy_work_start(proxy_dev);
 
-	vtpm_new_dev->fd = fd;
+	vtpm_new_dev->fd = fd_prepare_fd(fdf);
 	vtpm_new_dev->major = MAJOR(proxy_dev->chip->dev.devt);
 	vtpm_new_dev->minor = MINOR(proxy_dev->chip->dev.devt);
 	vtpm_new_dev->tpm_num = proxy_dev->chip->dev_num;
 
 	return file;
 
-err_put_unused_fd:
-	put_unused_fd(fd);
-
 err_delete_proxy_dev:
 	vtpm_proxy_delete_proxy_dev(proxy_dev);
 
@@ -640,13 +632,9 @@ static long vtpmx_ioc_new_dev(struct file *file, unsigned int ioctl,
 		return PTR_ERR(vtpm_file);
 
 	if (copy_to_user(vtpm_new_dev_p, &vtpm_new_dev,
-			 sizeof(vtpm_new_dev))) {
-		put_unused_fd(vtpm_new_dev.fd);
-		fput(vtpm_file);
+			 sizeof(vtpm_new_dev)))
 		return -EFAULT;
-	}
 
-	fd_install(vtpm_new_dev.fd, vtpm_file);
 	return 0;
 }
 

-- 
2.53.0


