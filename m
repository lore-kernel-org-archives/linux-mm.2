Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A293606A938
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z/rhUIdt
Received: by kanga.kvack.org (Postfix)
	id 5A89B6B05D8; Tue, 10 Nov 2026 04:18:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F976B05D9; Tue, 10 Nov 2026 04:18:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4966B6B05DA; Tue, 10 Nov 2026 04:18:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6616B05D8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C71D840147
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:30 +0000 (UTC)
X-FDA: 85418658780.02.A0BDCCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C8E9140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z/rhUIdt";
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302309;
	b=yHFDyhr4l3QzXZWvGwIR5xLckX/EYlnSikOsxq7V+nf8vRqO9hXv4tgyEM51yxzYT56Avt
	4iwyTU5kQ9D8xidJmNcNNKmfM9aGnCXZGgeCy3f11pJNTQGFzFdA8ffh8BG0JuA37EhCwI
	r13snR1Xt+ktMHUrqDlqvdoj9fwPBJE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z/rhUIdt";
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUOTmrjfTp1V3edmG7gNtNzcyR5ppQHZl9FL8hylfFM=;
	b=SxqiSNjorUvelKuXyfPIG98qemRFgwPkWADw8kLUe3DL9eS9MgEUc6OJeY1WKLXR9qaymk
	Bf4oW+PiQuinWtXPyW7FjsEjZZMLkyLBu5IXRxNLH454umOghrSp9ShMuSeptA4+JTDX9+
	u95bG1XdcmusOIzBH91mgI8Bt0Gi0sI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C6CC4248A;
	Tue, 10 Nov 2026 09:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC561F008BD;
	Tue, 10 Nov 2026 09:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302308;
	bh=BUOTmrjfTp1V3edmG7gNtNzcyR5ppQHZl9FL8hylfFM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z/rhUIdtQk+seOQ77LPhWLi0h1HQ2z43OEYnSCV//qvDOQQY0eHazzaAy54GUx8Mx
	 8OK9mCUr3KpEXeTzY4DiLfSk8l4evm0rcg5MG+ZHO1q3f2+gjSfOngnblIK2dDloDP
	 +WK6+GSTNoZaklQDEZGcF/9QgdWYzJPUOnmM9b0SlwKN7qlVlPKvfelGldE5Fl2bZq
	 JX98mYm4OGqMZKkfdmwuQV/pEXKpVF4ZPuDqWxolPUJwv7mAgjzXljkKCK82NenbeL
	 eIEFZnStffm2ZpLfOJ/AEIbn+CZ9LM0bc0AUxEiBMv53oXud1Vog9u11hUGToZKfGe
	 0TNk0TnU30pYw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:38 +0100
Subject: [PATCH RFC 22/41] sunrpc: use fc_init_pseudo() for rpc_pipefs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=934; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HtfAKXnCso4ldD33NV35qBTF+UjT1cN7QubZI9DMCIE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erBWvWPi53s6BltWb/lTc4Zf/LbV2zVLS/PuNTwys
 NpTVK11t6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAic/QYGSYY+3T8qY1dKXP/
 avJlZZapb1UX7tkXkrYvfWun7ZXF048yMlyV0He+V+u+/2+YguYEho8MZedCVq0SsT9y8ZnhI4f
 FWnwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0C8E9140005
X-Stat-Signature: hn3jxedzpd141pz5zdkc5smdfxparknc
X-Rspam-User: 
X-HE-Tag: 1794302308-97494
X-HE-Meta: U2FsdGVkX19RkZNNlkD40FDvX0yWkBrXzaKfynhMvRIAk1SLlF/UvxNnRs9CGlpBuKo8dnBs8JH3mm/fyVoSAe+WMI0wSXGwhaS+VM+4vlR5rWDJTiLxaGsQChv3uk8mRsTVZrzltUlyXUffOslzM8ick1VFbe14cJWJkKNZW6LKOeqsXU+VYEItpNomJAhzycMTnnUkorSMSOZYkCt6EHZLGQhtKHi1+/H+HuclphHin6RlEyKkTuzMfGEOyoXU9owX749g0A/WNbAdM5wcLgMTcvCUk1CtC3sG/shWEvomigY4TfXBpA3wFaykxAde7BKDx5kvXYF6Tp62YvXFf8Anbk5QiAQxNEV7aH2nWkHSRyiNAvI04BFZZeo1Jybc69hpSrEzI6eWqX37xk2ENOaj7ff8KQ9xw9tEhUPPBViYI7uo7EDPBSS4Lqq29QbjdoZqbZktUSPsGMreBYTCWGeiF2pOShbvmqq8dt90MDmPKWJtT+FKpyypXaHVQL5GQzkz45SVgYWS1o/JpVjScYuxHXvQrQ94QJfcpj/et1sdMMkK8lBwLIyqXDIbPXesX8nA3v3dnuyp51UcQ4M5B09cqNO3e8L0JozK/ECEGC5Z+SkXnlJokhy5czipCnPQwRvMxWtXKwg+8Yl95wzERZO177IfLSR/lWBe6Z9cdEKJ5arkkRtrmtvbR+Jh1oKbOt6V3Z5piykpmQ2eMFOgLFGhkkZbR2+9yDaKfbCR/gXTWpjrUQC6njDoUjRS9XgnQ3zI9yWOSVtj6o5xxtrRUvJ6BwInXhYJWiCziktUNsBj1okclf3PHsG4vZGSY8xJAR8F/KCgByqAfhG0wOQpklyLduFJw90buZQyCKfVrInXilVafjTFYtQfstkZ4FQ3ZgLuK5BQoZeae7B8Hcpm5Wzkyf3+fKvHw++Bpvpm/kJdK5Oj59AbzpKMSD1SXv2/EjRucKAJEzEobd47ttc
 7/7vUrLh
 e1D6l9zacwnbYHYZpsFRU2xDriO4XDLwv8yOnijZV9ZQOfEfhBuq9UGj9WjoSUIcVQH9d4DM1nleva8hD9gmUUZmLXJ96Jjr1vob5grWXlrSMlp6bXdCo+02N7CJSnDGW+DXwE6rA70/7Oi0OQsv/Xijlp5O0YBi1hUvo13IHHregnrGME23Qqwfnx2yVnj275cpyZZzNqXqrTGkBiAkxOgYzvZH17vz0zphs7UCXH48f4xsmGFNQvJpPM4+NyIdVI8GZZN87Ops9MsGE9PAPtfH9BSz3CIQ6CdjF/l5LRph8UoCcoplmBLOZb4guMjgcwvrsUvJf1vG1xCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/rpc_pipe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 9d349cfbc483..37277a6d2415 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
 #include <linux/kernel.h>
@@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct fs_context *fc)
 {
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
+	fc_init_pseudo(fc);
 	fc->ops = &rpc_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


