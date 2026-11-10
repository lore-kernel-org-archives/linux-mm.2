Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6F06077F04
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVZL7Scw
Received: by kanga.kvack.org (Postfix)
	id 75F0B6B05E2; Tue, 10 Nov 2026 04:19:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DCC6B05E3; Tue, 10 Nov 2026 04:19:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E556B05E4; Tue, 10 Nov 2026 04:19:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8896B05E2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC81E1604B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:18 +0000 (UTC)
X-FDA: 85418660796.25.2814E57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 21B271C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVZL7Scw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302357;
	b=uXRgk1uW4bFBpbFr2YfVhTbtlXUraEMNAyTclXlwhQOfkx+u+fTPrR9MYWGR/pfvKkUZiq
	HnUCZWxo1nQpbwAXUWMcA1zufQmHu/NMn66ftNp5491iz95KQtpZYK7U0/LZ9JlDlbUASA
	OdMQIgIgUs/DDvcMAGgBWRtCUorVvF0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z88P87cKE40+y7S8EwzOM4sUxUBx7Kuk+TuaC3S2Cog=;
	b=sEgWfL0wCjA2tMI7xuvN9cO5LV9GbzTFUg5T9AGQdwR3MaYfXjdMEBO8agsCOFTd/r4ABj
	7UC6LELmn+lIw3/jFS4q5vawCWkiulC3eAm5wDgYns/B/ezSUrIMqnLfbu23cYSRIblBjc
	hhR5qordS5DJXkj/IY029X2EOpt2Y9w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVZL7Scw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EFC343BE9;
	Tue, 10 Nov 2026 09:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD051F0089F;
	Tue, 10 Nov 2026 09:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302356;
	bh=Z88P87cKE40+y7S8EwzOM4sUxUBx7Kuk+TuaC3S2Cog=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eVZL7Scw//J74VQnr5wpC1JciKmgC6EEcXntO0XfGddwnot9XuJFBBT6CpLU6G9rb
	 pmxdCGn4mvvkfwVsRZlP7GHScVpTi+QaURvV+yActyYRVPG88Gah/lsV8jbkCAyY+S
	 +Wbub4HnrOoE/jWICNhiEOAummEBvZ6Ytq1+DBO2weH/kWZ6emmeL7oPq7bqrElzyw
	 T34OxX5/F3YJKGJq2hordAvRmx1tt30kr0Tk/X6fKUzZ5ZjsO2KqEqa95dlYVhTH/W
	 u4t7Q5TWviYJ+oRfrOFZbYMq/endQl8GL+Wksf5gE9+8Lg9Q1BSXHCDfuC3VxOHEjX
	 5LUw0U2nwzPTw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:45 +0100
Subject: [PATCH RFC 29/41] s390/hypfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-29-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=898; i=brauner@kernel.org;
 h=from:subject:message-id; bh=1S99ZrioUXIgplFU18XMVOtztLcFYkfXUp54ImS7dA4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erB1aso75cURLWW8m6Qi7yX+5bFJVs2W2Pc9LaHyv
 O3VuG92HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABM56MTwP/Mio/yXk76it2Ws
 +AxuKPBlcunvPh2Rxnh/ibrkrsKXUxn+O3Eax94y/xZ692yIXegBi1cc+4q8ZGTv+bULt9kbHvn
 JDAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 21B271C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: bhys7t8suup61nygeb3o3pkyks46mn99
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302356-350707
X-HE-Meta: U2FsdGVkX1/OO8siSam6XF4FpdPQA1B4DyNIk+whgbszmMNSEC5mapIfA/L1jIb3RG133VJUXQuRG1Alp92rkEc5C+DMXruNlMYAzUOnbJUn/L0ODMii25Ehk35sorcd0mluic2fCluPO8BcEgmquZ+/8T08/3Gs3Zjbdk54BUvtrZKMVfETCDCGiG4eSUk09B+XcSFfMMTlcv8ZgzyQwjAad5SRO86FDKEkmG025wnIYIouEbdjSY7Axx0vyqDn1PnXxh+VyS6mA39vF7uJ7LofiRJaE4H1WIjIq9pqHVBWDO1oJZCvStRT7XFlC+SZ9S0nf8EBdB+GtbgQCle1oSL/Un1r7ya5Ad69uRAnqhYchPWvvZeyarZcbn+UKGKBJSe2gHWKMZmknvjfcAlDWxbiS4OtvWsrTF7WW/aNsFrULqYesUsIXAGgLQZ0twD4T/VefZTsao2L11UzZ4OVkX91XgCiRhz7i0bVzHGXt6SAe3m4EGBH0OoAhXE2xwX8etO+XePUyBJDLV2AwFijuN7Z+FaOB++443NGZDek5iA1cAphtYdo9ev/Tr7bWQ2g+KmL4wmU8OYE+8PX3yctXaoLpC9krvOV+JruAFcejwQpswqVHSHAzX7lPdMCDJOdPk39kJHrVojtmXCdiHPNNqGVkURuHcstHElgOR1G0v270m8MGiyVeC/dE5DgUZ5LSirqdRds4w7WGmQ5U/uXUOX4lM7rL8WjfL2q5gasZXtYXtpsEQsI527xON1Ah3ABy/xjEbdQBuUHy7hRvsDMjy9NVTHCRzcrOZq4xREZ/CvyO3CHILR2VqPqYPVpbQ/Ar5YGU7tDPrF/RpYS1gkJF2ZB7VBOtHjwm1qK9rVoTOI2i1NvdkEa6KVKvU05rkr3GmMqBhvYOjl7H93QFSUy5kkq7zwQ7XE90X0HovyHbnks0/YP1kUaSmUKbMVzRcJF+0LedSSzgv+hYAfhz2z
 Xet86GeX
 FKUmN7Yqq3NGtv7/vSaG9X6N0OVOiVVXqRlt4tukEmhtJRpgwiWqOLZ4uT0u4x/svs3YMpALTKbPCwZc2S1uR1T22HEuKbh8XmLxbdSoLqQjpXn9/8dhRk4r0OZLQCqyPWbyzUlsUJT4H8mdjkkW2A75T1QLc3kVFJK4YdjFvz57WV1lWRe/uYauFPfV8UBKoUwCIQYWHsT/QxNferPZAVBcuKYD0MBS/pHnFvrEoDGhqU9s9RiZaN9lo3zs+AbiFuXzUufDMCJMhrfEmXZxCnFGA5AR3ofB1jMIpOe09Co5SLmudFERTr/EqapaOxBt9nkSSr9E2tDsA9AxzrfEbUQmgoYxmsMHGEWc5i5ypT57q250nuxavxvLw7TcuFS5we3ankGCbAt8EKJ/uySZ/oAgnIYqSQp0ZH0DqIUysld1749XDiL5F2nLZ5h91y+AlBSbx3S1nC1qt+FeRegkNo98oJIpVQRAfwSWy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/s390/hypfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 559b011e6880..8662169de477 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/namei.h>
 #include <linux/vfs.h>
@@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct fs_context *fc)
 	sbi->gid = current_gid();
 
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &hypfs_context_ops;
 	return 0;
 }

-- 
2.53.0


