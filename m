Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27E5606A881
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HWC8lhcR
Received: by kanga.kvack.org (Postfix)
	id C94CE6B05B9; Sat, 14 Nov 2026 08:06:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45196B05BA; Sat, 14 Nov 2026 08:06:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B345E6B05BB; Sat, 14 Nov 2026 08:06:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93F5E6B05B9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26D091203CC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:14 +0000 (UTC)
X-FDA: 85433747868.08.5AFBF51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6717FA0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWC8lhcR;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKEebM2B/rTWfHQRxsgcjHqOhGI+gUjJB4wKvnue758=;
	b=c1gDgpgR/mo5wfs33PPVcCsnR6NVmQR9cM0u5HY7ETfgIiYoGoYP8oL32X5f3mbL22Wser
	AFBbWIrro5CN2xCTwTt0AQZdoeZPuI9s5VwPEdn5q4jOQKPm6Xx7g3t1cKFREXp/ZJgLTj
	DjCoYxJvK8c2ooa8+MSq4LdBwPDlmbI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661572;
	b=D93fyPvZEvcD1zvj5sP0niswhFAOYnkYsA5MRrKRqrZDSg2b/MzSh3vQjvwtZ3VToQS62T
	5DBrNFlmfIDJ7gBeY8hA5xEcrFR4sTns7CRKGu70jjBa2uS0NGXyOSl5WWEImh7ETFU3LR
	cCPRkeYhdiVZsMw32w8qeNNVsVm2Bic=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWC8lhcR;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C94B625F7;
	Sat, 14 Nov 2026 13:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9DB1F000C4;
	Sat, 14 Nov 2026 13:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661571;
	bh=JKEebM2B/rTWfHQRxsgcjHqOhGI+gUjJB4wKvnue758=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HWC8lhcRxYRCVLn3TpoIzDZ0r6knLI/+VKra9y0LMZUdf9y2SW8kRjug2+6ll4TFw
	 sFMjM36I+HTVQCiYKOXtD3DCl934UGrWmg6qnVTWAkdS8Qs4hfZxLEQ5cd0s8oJ9C9
	 fUhCdYxXyKWUMiBhpguIoYbC0o3ATeajksXbxx0xoSufrfGJhGbAI/UAksPOhTc/HT
	 K2qcgoXt7i4qs6W+rhzztnxXhcqqn/HrLZCQg2St4BiABC53+ogrC53+NpAn2uKl/P
	 uu8arH/6EFYPXQYJcwPTBER+wepJOnNDlC6o2SSf6lebRTXyPpqWofrAf4PX4YP6mn
	 uEvTMIXHZBFPw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:46 +0100
Subject: [PATCH RFC v2 05/42] kernfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-5-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1449; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ir2ppogbuqLEOPNYev9c+66l6T/T0A3wuXIOqOu3yTk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMl+Jvtl/aO5Ua4ZJd1uQa9EV+geipFK+mptcsVm/
 q0Yo1fBHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNp72BkWP7iOsveCMP+z1P2
 GCRNU/Nzrztw1ed3WOnr6aEc868WTGVkuF6+JnT7X6/USnPOeU/ZmFOmTf/1ZgfTrUK/ZbdrryW
 2MAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: wseip7ym5dfqre7z6bg9mufbquszdx5p
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6717FA0005
X-Rspam-User: 
X-HE-Tag: 1794661572-810148
X-HE-Meta: U2FsdGVkX1+uCzNHV+q6E3K/QNH/19QsNyBGEJ2/1Nl8uXn9qwVPLqL8qSaFbWVWsagzEdweI1Xc4by4A0fvieIUVUQLIlohVaTeIWA5i+to0oU0+UkjTaOZyceQnI8hicS1sKbSAjjNK1kdkF95ck27wAU8T4jldZ8WUKb73BgU4gWheepnmdrmfmHQaa07pkaDXnyggXOoNKMjfjaRyTpmB0HEA3sXMVABqq5mwqEjdM4qUAKnrhLf9FwPaIUPJhs5/YZSoblO7jBvi1wlSNcUyfTtv1TS/sR6ItB9Z+3wkUaX1Qb1PbK3dR7IZxrJReHtHN6yg0msXkGf+ygz7nf1Q2ES2PmY9JBNl9u/il2rvc5xgiK7QzLYsSm12AFJ1y33Zas3TJYtmk8FgTTSc5FnwzEcbmtHeovsy7Bghg8LvT89deK+DrF5HSysqbec7ok4ULjYPenZQzNLyo4HQI6qAzJ5IYqMAc4CxXI9N+KBLTF2xgj1mm4S6mn/RaZUpS+1cDfxNA4A0PvMWaO2ZaFVbW+9C4sBxLEckqWBw+ihdSHfUr5u7fbYFy9iKZf9bqUkTF69Bg+UCpUXsAbOMhnJapYCQLHA9qMOYxIibb9HYYOtaI7CDmSjJdU1T616/6WxwGWq1cZP/bSeDzmZVLrLfQSFEOrnSyqYC8hBxq0w4LSgE68Ul5vnytEQDxFKjIYwtYnDoz0ZD/L2kRYdB61xK4x/jC1SSRZL5xq54/jG0d3GAucXRXbDne6PKiNWmo3W1bLryicKBx+3pwEvW2SmAGLGWW4B95edN42AcX9qKrkWOCiH6o6DDAyuEhiESmIBcjKORZh1uyHTU5Du38sa6DHGzGASZMIUin7Bes06Q9UOVY0Jr6+UZBHIl5aEq5mixHGvgEW5wqArw3WB8ZhWs106I88TRrH/M2yG80j5JWQMxXX7Np1gfUWe6s8LhLUvRZkGNItmltxX5jt
 e0CI5uew
 2D11+/6G/apR6PDW088pe6KywIE2E0KgnQTHIDcNDltaqtWmVgR0BTwGqhbQTIh3OtYGK8Wbj3iNpDGSRDdV3rnGKcoDo4pp2vZxMOyGSn5AS/z1jzIfnjvI9+ZLW9XSE+AyBj9UdCfoybFBcjaqVLT544bXRqKFmSQuerx2muBK3fgp1c1+cnPYQUSPDB3acz02R5+UxXDfAL+OT0LKm9RJJyxJWkLC+d7nFrKsxxyaJ18ey7yzIqaO0oMy+gNHsrVSvVd4WkttJJxiU0KpM2DCSHUsQPc318Exergo5eiek8mR1Lt3RWADgNGcnAwYQ8Lu4bk6Yhm9vGAz84bPp+6dLO+ZuOg8dlWQ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize all kernfs based filesystems as pseudo filesystems in
kernfs_get_tree() instead of raising SB_I_NOEXEC and SB_I_NODEV by hand
in kernfs_fill_super(). This adds SB_I_PSEUDO for sysfs, cgroupfs and
resctrl.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/kernfs/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index a0be784bfb064..6b60d212b003d 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/magic.h>
@@ -298,8 +299,6 @@ static int kernfs_fill_super(struct super_block *sb, struct kernfs_fs_context *k
 	struct dentry *root;
 
 	info->sb = sb;
-	/* Userspace would break if executables or devices appear on sysfs */
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	sb->s_blocksize = PAGE_SIZE;
 	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = kfc->magic;
@@ -388,6 +387,7 @@ int kernfs_get_tree(struct fs_context *fc)
 	info->ns = kfc->ns_tag;
 	INIT_LIST_HEAD(&info->node);
 
+	fc_init_pseudo(fc);
 	fc->s_fs_info = info;
 	sb = sget_fc(fc, kernfs_test_super, kernfs_set_super);
 	if (IS_ERR(sb))

-- 
2.53.0


