Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752F5606A920
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmhfQG5W
Received: by kanga.kvack.org (Postfix)
	id 97F006B05D1; Tue, 10 Nov 2026 04:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F306B05D2; Tue, 10 Nov 2026 04:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865A86B05D3; Tue, 10 Nov 2026 04:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 636F36B05D1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01A1FC03A5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:03 +0000 (UTC)
X-FDA: 85418657646.03.804A51B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4607D40003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmhfQG5W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302281;
	b=CZrOsd7rqGh3D6hFGZLfafipv3XMjN9DK9o8g0OPgc2o4SqnLw7tscsfF1NozpKanwwFWr
	8ZDLODdXK/9+qPtgdHdUM9qOUBad/aTZ6OT7PJR7l17saFeEkrJHSAjGnKoSoYG7dWxE1G
	/vdboM4mxfDFi1+saKxGXAFG15iFIbI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8foKI6JmuMCwlgA1vbndmP56m7vz0lsh+SJERlRxyTw=;
	b=M3SR98XItshR+kfEULWQHKRFVuUUT6GK6MahODgeNeXn20j28okytIKElV2eAW/7dWLPeT
	ymeuwUCMvawlKBZ4pbubE/r9LmLMpqohIgnnKYYIjE/d+QjgYv/agLq9Yhg4Kzg+DpEwQ8
	qDyetkZAWiVzPlaZHej4NZYXKWphJkI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmhfQG5W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4C0F636E5;
	Tue, 10 Nov 2026 09:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7F41F008A1;
	Tue, 10 Nov 2026 09:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302280;
	bh=8foKI6JmuMCwlgA1vbndmP56m7vz0lsh+SJERlRxyTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dmhfQG5Wa9F1vl+Ncla7LH9qR2Pb19MWVA960fv/qPgnC3PfvrweEc5lpNq7tg5cv
	 X5jebb+YDcv3+oNILPlH9pzpQZuHd5gXnfWtjGHFm2sCmt+GLljdrB8ed3e2EDVoxW
	 6qwLDDuejmnmabFf6S4yipLYILlMtcgi/B3PaMm2jtiYlDVjoc2AfZI3TB5b25URyB
	 9JqF6aBLQhF8lrePFMLHHrz/X2m11imH2EHUNar9GCgoanthwCkg9zDKmfEF8OQXN7
	 FbpquhbOcx9HJMB4de2od2c6Rsbmt4mVOK3tjcZbRaBQ7AHeFHK8pVFWivdn0ZmDS9
	 s18yL7iJzQ1pg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:34 +0100
Subject: [PATCH RFC 18/41] selinux: use fc_init_pseudo() for selinuxfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1631; i=brauner@kernel.org;
 h=from:subject:message-id; bh=G6GyKhtPUuEHs5LrXzW88WAPZ6YLQCvHyquwK5OU8Mc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erCSv4OpQlCv+sKCEKYLJnl7XiQuW3g/KvNGSuDNm
 Z9Edkzu6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIwRJGho3heV555heiU9OC
 joYteqa/h+mn21yLC5/8Vn9e8++ltjrDfz95yYxJLSHu6Y6WLBnlx5eIrDRyi2Wcy6Ybt7PmXsR
 WHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 4607D40003
X-Rspamd-Server: rspam12
X-Stat-Signature: 8ru9771r6tdj7xwa7tehrhxw3ywjnsqt
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302281-265045
X-HE-Meta: U2FsdGVkX1/Xq54O+5kleD02V+/c0YdTlsUmdCfDbbkGt+vL7VTg0L4OpBJSrW2HeMwYhCzbO7QGTSSlkCbB43r9yrq0MhNQnPVS7FXRtzoSxNhCxUMBz3HrzLdbjMsTCh48K90fKR9aUMFtXGi02NGEByvBoViUirYlzmXfgv2SwEChGae4vfzRoGzO4jIpLtoevvG0vb/hh/KFtLSVP5UJUN0xQ8BAjtl2cnBO8bvpn9Tjd8krxJqE+42nVVLznzic4FB/JuwjJjuDD7IHYosf6LtIWj1J3Vx91kLeR5LLkbQ8Dx1Iw1ScWTND74wLAK6dh4qLFAl2M6VACj/fB08KThqHSupnxL0hSUzC/Fkx+wfTcFojRDjqv2dPr1wIjmNp9+6aemFw8JaKH0FxecBAj3R7Og+kr65q8myXZ/YMCGdiv9pL3McYVsAv/M4BoBJBJZ+M6fMFyVSEn4RkYPK9/rw0S2D6T7akScWmRrUUfnaLIf5jJv6pFYC/xZUjzeq44SG9W7WI7pC3U4KKXFipqPaVEpjcTVHlefQvJq4tW9kuDnILK57ROd6kwGG+UXCkoZ7sC7wMxdO3/HqkmbTZ36sWy/1WsJEfbC8rIVG6vQ4kHEX34uH7jUuAWQsn8SO/QdL9aTu+4v/5xAh9H0cv6nuT1rZuScRJOl6sWJ+kaSaynASrBMuHRLSvj3wHUNqbN6lSt3LTql7q2nklJgTRL1Pri6Zcn6D2n+rvxH4ZYtlhPj8KFHzDM12poUoXTeqlxaccZ8+y+BVOVBW3lL5t3lyxassidsJ7Kct67FYTBirxYhtXIybVpMEtWy13V8+wHXTbZnUMQH45Ukwe4D0xwmxYH38FhJWVHgGN4EJpVYIJVR9Kt+AEjZYrvyu80/u69m1eOFbrQb0PbBF8jDkDX0saf9R/hzN1xnhXvUjcD4Ys/Z0vhonqCc9dAMN/diurx9nanzvWKNRSNuF
 xFZtTOeu
 sTI/Z3TfWHwmArZiOuuPbO3NUMSjZmnbilxPGJ3oU6f8t0/szQVkt9q5woWYLNOz1iOvftTwDuDwix2reZucXrsYW39eEGSA6C9dXkBuM3igeswFBAAuj4F+zilpi09x2l6fRsIvuenypVBY7GSrfhndmBgw15pVEWqLzmT1NUxQPrb3oZNnvXxigHYmVuxIQpigXw0Lna2fPJnTbHzb8fDs03YxBFbkVdOQepQddnG8idDPLgfrNLljnmEVql5Tgxr56QpwYxDO5Bc06XP+VU+eN9cautAVK3w6Dki8caJHFcsDm199hr1PzNOzdmyzoiMNKJwwy9SEkMIjRg9fqegjumKiwZWaRh9hGifgaK7DtgXb+JUSTewR6yaNtcYUi42xiGBG1C3VfZnfCTJaOK2DMPCbcWKROHdtbUXMiK2BVWAslbPx136Cb7VZWZeQ2YXm75L4NKpgyEMjEFVgrq02H1TmlfsazRGmz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize selinuxfs as a pseudo filesystem. This raises SB_I_PSEUDO and
SB_I_NOEXEC. selinuxfs never holds executables. SB_I_NOEXEC also
refuses PROT_EXEC mappings but the status and policy files are only
ever mapped for reading.

But selinuxfs needs device nodes. The kernel replaces file descriptors
with /sys/fs/selinux/null on exec via dentry_open() which doesn't care
about SB_I_NODEV. Android init however opens /sys/fs/selinux/null by
path as /dev/null doesn't exist yet at that point. So clear SB_I_NODEV
again in sel_fill_super().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/selinux/selinuxfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 310e19efff1d..d7ae853b6d68 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -18,6 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/hex.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
@@ -1852,6 +1853,9 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 		/* last one */ {"", NULL, 0}
 	};
 
+	/* Android init opens the null device below by path. */
+	sb->s_iflags &= ~SB_I_NODEV;
+
 	ret = selinux_fs_info_create(sb);
 	if (ret)
 		goto err;
@@ -1955,6 +1959,7 @@ static const struct fs_context_operations sel_context_ops = {
 
 static int sel_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &sel_context_ops;
 	return 0;
 }

-- 
2.53.0


