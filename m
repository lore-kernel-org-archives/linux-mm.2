Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A18607B29E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UY61m139
Received: by kanga.kvack.org (Postfix)
	id E2A006B0601; Mon, 16 Nov 2026 06:09:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA2A6B0602; Mon, 16 Nov 2026 06:09:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8E56B0603; Mon, 16 Nov 2026 06:09:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A65A46B0601
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D1DC1408B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:37 +0000 (UTC)
X-FDA: 85440711594.03.6FDAD94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8FCD240009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UY61m139;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GA9SDweTRi4TPXcTEQAFscMtUQB58wBJUJ+Dpl1Ho9Y=;
	b=n01D2M9Nh5oxjQnmkdD4fNVpRfyEa2/LS/rE1hqMb6m5Pfp6YEPlsgAFkWmti7k4qaSysP
	NPHgOyQ/r8cOuo4PSBsS+ACna1bBGVa7CL0R5qDBMMQKaqCW5RU87QC8iew2+ukvAscTw5
	alBixSKa8ph0sC+SaQ/zt60EJP9gg1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827375;
	b=0rcsNqLkHMoeevVcjxmpiqu16i/wrUJLQeJdzgV1YZv7AB+IDidBMCS0+VIFIPfhkQfUTk
	U6Lo3Icn2QxzhV6hW3/0GoNxd8K/nabDrD5EK3tVA4jKJbKdAoT0RybMQyh2x2KomdVImI
	O/d98vFdTg6FjwuTmhIcE3PeYmNpc5Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UY61m139;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6440401D6;
	Mon, 16 Nov 2026 11:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2951F000C4;
	Mon, 16 Nov 2026 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827374;
	bh=GA9SDweTRi4TPXcTEQAFscMtUQB58wBJUJ+Dpl1Ho9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UY61m139fqno9VQPvlV0NuBKhsaZrGDjrVzYlgm7LD6rQ5l5RLgAEz/YOurVtzhaU
	 qWs1Q3SpXOFEmSDFy4inEO29N0SZfbZ5fIb1NekL9cn3PvqJ6DyP4XAUxn3ozl2ZJI
	 p23wAbdf2yyN/romcxRDKr39Pbs2B/eeDzuc0T+uKi9yP3S8xjvIKh/Rs/IdXfbP5R
	 Mx/ud7lVz45gCjw7vwqFLBkjvSKk9SMvO7BidByfWJxJFW9iY0IoIxHKSuZIU92ddZ
	 aJPF5uOwKvaCzHfS0eMFmp2nXScO9LNfO2AwBc+xn3LaqIAOhZIwFema+aqToY32q9
	 RwJnBI1OJ0XQg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:01 +0100
Subject: [PATCH RFC v3 28/44] ocfs2: use fc_init_pseudo() for dlmfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
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
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=997; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IB1X/Ir1PaWyRnPeEjajubDonNXHmf0+IfXVC+GqKVg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elwvfOHxw+ltDXUTZ+ofeOXJ0hER3a2ieLJd7uhR8
 /iS/m19HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZXcfw3+kCa24qp2Bz09eG
 L8+mdnSztOooc+yd3XlZ1ff8S1e2nQy/WdNCAuRMJW+dt9Cc+Y1r4eIJJ4r+Gs1+8uby7aLo2c+
 y+AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8FCD240009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xa4og78niyetg9ch5t5t5sphndedkp75
X-Rspam-User: 
X-HE-Tag: 1794827375-576599
X-HE-Meta: U2FsdGVkX18vQ6QtuQ4JVgqIoKMz9KGnsdDWP+f23WBe/dweJlTT0MPT8F7lKEKEyH48Wd7ro4apvTCGP5BMkKyoAWCHwDRUc71LsgqPey8W+eAQZm6WEDwV9ZobDPluulKpAqgXWBRdoxWubFdVuWMmcdR9CW3X51XW36mVET086yLDjrmQ+Rmpq57Oebdo3cJh/QJ9Ol/+adEW0qJc7WGaNiQX2oSRZXmg2/bdrIroHMD62TTig5/Hu9UlAN7RPYdGBIA7Z+p24IXfMww2NQM6gDOI6vhLSETqTBhtVHpO5ZzzQm5zZUjJMdDJjQKE3qlZRW/Cx8QbuRCRJ57w+gNPWiq54gSNthB2qDu3BZpZEPfrqJxCoWKvHn2p0jhhQZPK1I4inp8IpBhwlytmwpeYau8cWivn0sMb+K7ClIQX8HeprFvhgM2sHaxJTlmqFEwycddf3SvP12frf9jyY36PLwQMluiLMk4a0hY9z1U67I5pAOie1T4bauHmBgiqKx6/mBCJWdZ3skT4cBFYn4pdUsMQexmmjTY8Pv+Fb8YWhu6WY3vh7txDCkYAA5TCcoeM8XHSBar4bOxL/gRJNprCD2ybeJqabFN/hZCSkzPgZ47+RYiPzvHHW153NGtwcyvYCGw+XAzUR3x1yRhYezl2s+7SgJWpwBRu3BDcESh0koxfAhzJIiJ9g41Sx7urbTSVpdQhwGYKHh3UmIOpOTT4yEnISoJzyp2G4ZncXV+C6ONEk1suNU9wkf33T1lH+wC6XRcqLOZd6qX79kwgpyaHVUYjpsKELobl7yuv1mPrZrts8X4xhoSd9gE4CsW/qZ/LdQuv2+oCAGH+midEmSwaK/AwTIW0/GIuHTb2bYrBxhlGA8RBdeEgJ28bDmwHL7O2JIfXmYjeLjbI1cVF/wZ2Uii7ObpnZEm2l6K2DhApNeyLizBpgqX/Vnd4inNXEL1KMk8GLk0qA0+3WcO
 Fh0Wk+UT
 utAwkBjO38XtmuP3YuQbjN3L2LPvlikqXVHK1X1QGFe0OhViZvd9Gzr3nITMpHAn83S7hiJHMSHUV3RSt+VpaC59FpSLZhGBHydmowSv8NYen8DivJ4mhD2O6/aBIq1dUfXhHcIUYBcPS8SvvAu94x9Mq3mtKc146gyAHkM4hNsT8xK35gQPBbSYbi9i9/lL8nOv6NcKOGoWL8tbWNVOgO9ZFylOYRNe0K51ePkvpqNjTvOygLc5zWFTzw0a+DmU9fFjiUrkuwX5j4Ij0ffakGruw5vV0vMGkwXQucjfoMClRjMIulp0U8abf7wL2iw1zy0aeaV+a6tz2WBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
device nodes.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/dlmfs/dlmfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index d3bfcada3e3bf..1789ec96dc130 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -563,6 +564,7 @@ static const struct fs_context_operations dlmfs_context_ops = {
 
 static int dlmfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &dlmfs_context_ops;
 
 	return 0;

-- 
2.53.0


