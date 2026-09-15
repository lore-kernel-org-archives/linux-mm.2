Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C44C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4211B6B00B3; Tue, 15 Sep 2026 07:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F76C6B00B4; Tue, 15 Sep 2026 07:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E216B00B5; Tue, 15 Sep 2026 07:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 136096B00B3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:34:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A35C51C22B6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:11 +0000 (UTC)
X-FDA: 85215787902.08.D709ABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2C57A0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nQ8C1Ifl;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhGO6+GlrO5bC4tNOgPf4pdo2kq7bPXcK+eEsTvolok=;
	b=0GfE6y941YsxpWNDQBpkNDsXTRDlQ3KYwPQSnp21/fP6eW8/FCdoFBwcLdd5Gwuub7B7U/
	JkVc87gQ2+W18UOtrIq+XRujvw+Q7x/JDuBNIrsPhxHj2EStqpud3FG2v4aUm+iPXyUJyn
	fT5jiF0vZT88jVod5U2cAsYCzsAHL2Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nQ8C1Ifl;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472049;
	b=gj4KfIH86oZe4QTZopBMTEKhSH/eBnhiwLNeepjjvCmmNsw6P1geZnn0FYNZSh5c+Jz4Ri
	1kHkvc1b8MehMB/NHnPOY6ZzPN8VsVpfzmPlP8uOqmDwrUr5/3JSf6GjueD3ckfI4+wqjx
	F/3H79z4ntXyssFmRIe/mqH1vTDNXKk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35725415D0;
	Tue, 15 Sep 2026 11:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF091F000FF;
	Tue, 15 Sep 2026 11:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472049;
	bh=uhGO6+GlrO5bC4tNOgPf4pdo2kq7bPXcK+eEsTvolok=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nQ8C1Ifl5v/VEdveq9mGf3Z+FkWlXntXzUEHkSwQjH9wNm/+moILJ5obBzqitNP3N
	 IBlzTUeAC+qYwcosyjv/uN3SpN6wKH5b+F1BnYLAvwrpAYFxh7xAzh1A6p2Gwl1LgI
	 rWQJAgcOdwQd5Ylu5a8xK1NTioy4jbHj4ziLLIywDBw+W3mJ8po4oGdT92T3R2egH/
	 xuquAaax+7jMrr2xNPG/Odz/y7erbajpwwU+weBYntanMeYoJSnYyxmfhWaIp51P4L
	 YpHw70QLsguWOhvBKn1wooIGtRPB4vcJYrpctMzIq0N/zqf/HB3mTynt9TyjQ+rxp/
	 NpyMNYd5pEyIA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:08 +0200
Subject: [PATCH RFC POC 22/50] net: install SCM_RIGHTS descriptors when
 recvmsg() returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-22-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2042; i=brauner@kernel.org;
 h=from:subject:message-id; bh=583XJCrzovkxIXuJOAwpVg9Fhe+TBNMNFPvPLgzJFv0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kl1Nz+WcexRzpkZ6+trd0+fFefIwcf4SebIg9qKf
 4ll/ixHO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbiMIGRYcr6Twc1Fn/48OzN
 Xc98Cd5J3cfYczNUrC7dCpOb1qzKdIzhf0T4fyfZE4nxKZbFy5ds7U6RenQkNmYPozvL9NMLPpv
 FswIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: wfwuke5gjwmu6kbsca8iuumy1sayc8uf
X-Rspamd-Queue-Id: D2C57A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789472049-438903
X-HE-Meta: U2FsdGVkX1/VFY5XaXiM6pCz8VjmaMCvHu7fSNPhuqB0FLQuoWkV9DHYffByAA6IQPtnyxTiMtOE/9obSCow23IuRZTxS1Hsu8blCB+etv9pxnfug3o/QWBDjyQKEccjbis0kLuF5JNemM2IOvPLWz4RHKpCY2bSxeTFz3OB7gOZN9/WmeOppPYRJxD2vxZ/uu+LjzMd62NlcRGPtZQ8IMcswXZzOBCzWcqwtrrA1qY/gQyJM0hMdXGPXQJTo17RIyqhgh84eenc1dlPauPyJdPOZUjWRq2imP5IcMW6XHdfDPeevybzBmXOJrn3pctHOE3wcji9P3RKxcWv2cEdO0urv9GKzHcrhah3oorrdHjj8ZqXjD5QYYx8qBzl/su2cmcr33aj3MmZx7RtDMX8VPePF1x+6Yh9Rq5KnZ6pAeZu8ApN2aZYfaHIKv3Ep/MRAVtP1nCm7Hh+bVkRu+ootCdcZSjSE6MmiixFzEi4g4MR4BHTVkB+8TfF3hK9KUcud7CgWpnnuQcOBMdoLJA+OKI9L29sk64selwr2fhJwFWkWHk+yZ4jylSD7vCwm+HZ860cBWUQEaPqFVowkHA1wraIGcpp74aCSbplVkUV37+S19AW8Bi6TZZaXsPuTHPmWjXWL2mZ2GcdsSvrrSRWiUWsXRwpd7/ZqiVmvHm/veKeUUI2tQMf2oQ8fuWh1Nkj9VbyKvhtoqCG+He8FOCXBwPuJdarUJm3gr+UKuESpSuInGo5RlY0yr/2jMp6h/7l/7o/bKm7E1relAOxlr0qhCisRcjcj8GouVU2VitVIZgGb5O2ar6X7TgmG3NzczTtW2ef0E91mEX7gG+BwIxVK6RUzmoMEY9zp0NYAOY5oGKLXxW4agN5zJuV5B47vyPcImf63Odi2OTxiyLKfaKvY16I4fJINagcNchFz2V48ztNdLVFt6xKw+iXxBPxB0elgo7t1JswZWYXNf7EaVf
 ZVBFdSxO
 NzrZvKGVyBz+9jFHjHVvtyZUE+vHqzgRBZDNXzS5jKGXifY6CjuTm21HfyvbZ6I1jtfUkRED7gpemzOqQ2QDpFxr+GnrUz/aPe4f52EtHnCEkfY2JSSo+h/8cemWCn3X2gHMaKWRXEnmjPIgRfkbj/4WUlEBHUigWG4M0ISbsyys8jlen8ZkbiwMBNSByBZnPNi2PsEO+ATF8SUXyuQZTiYq6PI9O6hq0NkxoRkSqeUZCA0EaDMrigbc0aqPKtbTwE2rByNckXC5qvdJxkiTUPWrlR6iBdNfB0ljxD7jJjDlGgyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

scm_recv_one_fd() allocates a descriptor, writes the number into the
control message and installs the file right there, one descriptor at a
time. Everything that recvmsg() does after scm_detach_fds() can still
fail though. When it does the syscall returns -EFAULT while the received
descriptors are already in the table and the caller has no way to tell.

Reserve the descriptor with fd_prepare() and stage the file with
fd_stage(). The number is written to userspace as before, but the file
is only installed when recvmsg() returns success and dropped together
with the descriptor when it returns an error.

A control message that doesn't fit still gets only the descriptors it
can report and MSG_CTRUNC.

IORING_OP_RECVMSG reaches the same code from io-wq workers and the
SQPOLL thread. io_uring requests commit their reservations before the
completion is posted.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/core/scm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index f0d44ecdb11f..f05931eef54d 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -355,6 +355,7 @@ int scm_recv_one_fd(struct file *f, int __user *ufd, unsigned int flags,
 		    bool notrunc)
 {
 	int error;
+	const struct fd_slot *fd;
 
 	if (!ufd)
 		return -EFAULT;
@@ -363,16 +364,16 @@ int scm_recv_one_fd(struct file *f, int __user *ufd, unsigned int flags,
 	if (error)
 		return notrunc ? put_user(error, ufd) : error;
 
-	FD_PREPARE(fdf, flags, get_file(f));
-	if (fdf.err)
-		return fdf.err;
+	fd = fd_prepare(flags);
+	if (IS_ERR(fd))
+		return PTR_ERR(fd);
 
-	error = put_user(fd_prepare_fd(fdf), ufd);
+	error = put_user(fd_prepare_fd(fd), ufd);
 	if (error)
 		return error;
 
-	__receive_sock(fd_prepare_file(fdf));
-	return fd_publish(fdf);
+	__receive_sock(f);
+	return fd_stage(fd, get_file(f));
 }
 
 void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm, bool notrunc)

-- 
2.53.0


