Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C0E606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M6eYgI6Z
Received: by kanga.kvack.org (Postfix)
	id 834586B05F6; Mon, 16 Nov 2026 06:08:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4BE6B05F7; Mon, 16 Nov 2026 06:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACD56B05F8; Mon, 16 Nov 2026 06:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 440EA6B05F6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:08:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5A971A0910
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:37 +0000 (UTC)
X-FDA: 85440709074.14.3B8716C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25F06C000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M6eYgI6Z;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827316;
	b=esHj35NBWpw0NuRZlhqaea2pPaWuW35NTwl+noxG870rD1pPLzIwyPksMuGJoa9hSCk55y
	hrJhOk+i+qeRIMMAQQIxDKMO8gl/VfBZ4QQTkXi2riHybPv2s9jMmG1n99T1t6+sTlelxQ
	A4URzU+hQU83aCzHnOQiAx3PgunRg/s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M6eYgI6Z;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWvZBvrR1DOnVrw2+TUZXk3eg5enGUE+5GG/CSvPX1Q=;
	b=P2oNjvuEaptCEQfXdqTHefDBmv2cWqMKtWvqCxiSo4CPqm9EXWRsZnOnubt1coI3s4kJLt
	0VJsh2yBaRHN38ddwEPB6vsrOX/u9w3FdtBxMmq+wXbzhATbhUObBTIy3tnldZoKdDF979
	iy0AEppqXCi8d9ru+IOq9BsMlBz4UiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 755FF41650;
	Mon, 16 Nov 2026 11:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F771F000CA;
	Mon, 16 Nov 2026 11:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827315;
	bh=jWvZBvrR1DOnVrw2+TUZXk3eg5enGUE+5GG/CSvPX1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M6eYgI6ZSCWFmdAv+fAKXRWQeKnBvNmi3ZGo637XqBmytIJecsOCK8L3K76JPXXYP
	 ZDPxK+Ub17iANZxNSKyVdQBi8dIcKzwcfFwcTCWZPHberYy7Dgy2T/eRZfYiblTD/U
	 c6GlWKRoWjOZBL0xxEWztgdZ+LarTM7lnyr+L5QUayqTvcDKYMI2riwgHl2jprvZgH
	 USZr2oeMdzb8nM+mcT8jPB0bEtaNdZsis1cazQz7ZkYniO5Pq48EYVmjMP3dWQBom9
	 daQQ9/8p1AQEcogykoG50jophGkGugVTSDHtKXkiD8LEQcS8k5lbk6G80EZfEpoPlN
	 0Q/R/MMLzKqVg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:53 +0100
Subject: [PATCH RFC v3 20/44] apparmor: use fc_init_pseudo() for apparmorfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-20-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1081; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NfojWSg09WkliXy6sDezT//cu9zqICvIe5+KQz3E+8A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elwq/vSPWt7KO3sOFNTGK89qCpZfP0G03cB2BnODS
 O1VoQXbO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbCsIHhn4LYxbUVE/0Uvyou
 mbw9Vp/12f3yXZEdk7pN8p6JL681O83IMMWguV3BybXeKuJN4+fvR5NTypbM05p2R9owKS/KuHA
 ZLwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 25F06C000F
X-Stat-Signature: gsse1f8ik3uxi3sde19w4hb6sodu7wxe
X-Rspam-User: 
X-HE-Tag: 1794827316-66237
X-HE-Meta: U2FsdGVkX18ruP8JXymRONu2aRWyb3WKoXw0T97ytikF2tDla0+Ncr+E/hoQWPReqbdPZYJKL6PFcIDeKau7jinLuaBtdBcIeZObaQUTYg8x8U/fms9MiGCKNtbi7hQyV7j0JDywHOaDQ1QPnePU/p4qsPqlZV2BEYoXI3GH1+05sQH7okSHRhIuBpBHzPJ0QPzGctvM5ENzOj3p3PRTgiZRGE2kklhY9byNqmphBFFKo3Hb1qyDO4V1y3V0Fu3HJZvd0ccq2O4DeteUpMGq4GyjwHkS1r5ny0iScV37mfc5jpl2g26EP8MV8xxg0aijrwfyPZ0kPCgeiQgmT+QQ62Pe35YNnYD94aSCE19GRejrazhxv7crMDxhRD6hDjDH5suWX+ah6IWXduEVLazyGWb6NMKCw4DXN2OHgVb+2xR6bXCuEftZtnF9XhNfHqCnMF7mpyq/KXIGzFRDo+MJH84l9uXxQMPcEccxZU5yi5mbPa7WoyDZ/DugK8Y2bFedK1xQwCQ/nRajwh2j2rJEx9AgZvHKhHOKJEG0FTVeGtBhfwwm4tFzsZY9PNqv/0cUTBBdwWSO69ll63JxjtrPaxSmoaAcy+hwdUuBM3ef87VqRQIvejNfR1K16GMi68FX/LvpU9VO/1n4VFEvO2RRFk/Vq5hLpUblG0tY5jCemZ8/v9hvMv11hp99T/nTFbfplp26KmdhQhEs82VekxPF5n9KZcu5/nVntMenZp29nCAAAxWlezfODBb0WBV/lgioo0FGwdkFuL1S1sxGsWlXx8dhedFhhOdxSm/oU5rQlxYuoO/ciXneCE4NWsnbK+FjZ+94fPPin2k/RpHhCK1TK5a7+0D09ZjoM8pCgk7zO7TM2f8L3DIc5ZUgN/kyGUmAtH3f0A9osscQrb+Can/3TQ0+/r3MGOhcPH+KbyP4adZVHAuCFPL303fvRMiFzPzj2JVMXYJbAaOd2RIjWxh
 TbO6PkPS
 BPzaluC16eI75fzVYEOgHNMp5HkSiIjCGwD0G2k1FyJJd0uxlVitRB20p025zloDZFaxyNcwRmFoA9AanfBfwQLdPcYV6EaaxzhzXHb32ed156CyyRA0nViD88a/E+5EnU4+ra3whZQ4Lmp9z1DtP4B2x4+Qg97hqHfEC7d45pTaiS5sGM1gbi+1F3HSKvwiwpm+eEmLzdqbaNDSUrO821Sml6A/5xtE7jsqd+uPP/X8XxvUod2BhgsiYYfa2znHllEGZpJE4lXbQ6AklUeLfSul1B4KMM/BoeS/v1IqtX1dEhTGXa6GWBZrQBIMpGqE3l93oWQQIif2h9Z2e5nVTJedBxCb2usV9Cx9Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index a993664672173..351ea3a7120e3 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/poll.h>
 #include <linux/zstd.h>
 #include <linux/string.h>
@@ -263,6 +264,7 @@ static const struct fs_context_operations apparmorfs_context_ops = {
 
 static int apparmorfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &apparmorfs_context_ops;
 	return 0;
 }

-- 
2.53.0


