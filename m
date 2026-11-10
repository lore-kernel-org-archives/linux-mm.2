Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A3C606B2D8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n/nPEmY/
Received: by kanga.kvack.org (Postfix)
	id 580CB6B05D7; Tue, 10 Nov 2026 04:18:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A396B05D8; Tue, 10 Nov 2026 04:18:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4207B6B05D9; Tue, 10 Nov 2026 04:18:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21D6E6B05D7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB2031604F4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:23 +0000 (UTC)
X-FDA: 85418658486.16.34A0656
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E7F80C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/nPEmY/";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302302;
	b=M39kcwJ/aO6I0NfeTOd8TKHKEBYDA8r5rG7N9f+7ShUu05eHuofARqeAQjCSuavhB+pTke
	ExvSJ74o41CINa6Jhnpq7b23TGvh4CIE11JSh5q4doDXg+zkhe17XhP6L1jFMHCwO48g9b
	KQ89KdVt+WM9oXrITjb1JqonhZODJas=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/nPEmY/";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xLCAE1ljQwjM/z7WMvrquNwq7v8NRQjtdpUDUMIMgw=;
	b=WZHeQl4wRXnCQEPhbPBzYq8sgwIlw4kuYJOH8A/dm7FwOUXK35IjopeGsy6I3YDDSM8oI0
	VxIUGxtk0MAmSZ3pg8h15s6di5pYxJFxLa1qASYnDsRGx3K0P3PnRuhuWo420jmFqP0YRA
	vRRASrpaxSpjlV68nkbwfiWcgT3GmE4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F65C42BA9;
	Tue, 10 Nov 2026 09:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DB51F008A2;
	Tue, 10 Nov 2026 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302301;
	bh=6xLCAE1ljQwjM/z7WMvrquNwq7v8NRQjtdpUDUMIMgw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n/nPEmY/gv4mqB2kXaUIe0isVNNuSFYe4ifWdFJtsRhYXSoI1dEqHjcK8jXDbyzkv
	 ertikRvZXtvN4JZinzjTGl2V2W3t61CK19ISiQm4xZZKjvx6Ilozk7a062A5tyZVek
	 8ONpx6cO+b1cP6f1iIgOK2yxVMDe8jOAVqYq0can3XlRZqUYI7Gp3FGNtEvO8RVw/T
	 f+noE3Lf2FKsSSXSy3unTl1hqIHTI1UMmGoV2c8K2q9ES1gzqhEiirejgIGUZm9nYu
	 NqYxgSkqeO0i1tDzYYX2q1T4FJPsyVEQu1wNublFH2+PjjrVHGb4S/n5iQ5M/xLuTU
	 IGfiSO/ynwQJA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:37 +0100
Subject: [PATCH RFC 21/41] nfsd: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-21-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=896; i=brauner@kernel.org;
 h=from:subject:message-id; bh=O9QykJ0fSa/ei9QzD3DZ9rjO12HqESJ46S14fhxCm3g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erBm2RVdl2pllcvx587P2/2Nj+HEnjubhYUvT5nG7
 rQvYfmalR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATSZVjZOiTVZZ9M+fcLevt
 JuW1WT9C9YytitQ/n2YJq0v/vW9H2Q5Ghh08Evn7XH9MsUgMSb9yk5f97OVSvTP7v7PqSMtvTvm
 Tyg4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: bni6erxehb6gsmmpjw89uq5hsy9qzkd5
X-Rspamd-Queue-Id: E7F80C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302301-755091
X-HE-Meta: U2FsdGVkX19H0KHW6Qya33kTZhU94wNVtpDiljIffKwQEUE3QONL/7D7yyahKiwmpTSoDgmBmcb5zHHigyTsXMok2iVIBpnPsK4wGNhAmddN+eK4NGDAbiu8p0fueuEdbxH2+u6tXOwLK+O8FT2hQFeyA9gi9ot7gqWfMacu7QI8FHj9Ot7roLnpTFpLoXdzhYeqjtLdMjih8mVIXsYG4CqlPfx4uvtmeAwNvodc2vYGRrEPEyeoI+sM1DFFWF4gG8GWPSinfzH5EJ+FNmz61C1ijRkR/Vup2fhjUzdJst449smgCA6C78qjlSXemRx6xF9i74qyruPrKvnLB+qWB29WdMevKw7MwC1TLp+jih0ZfJjcqcorrU5FVvQQmMeotLDC1IfsidulFyXC0EIw2BDtsJyxwig1tWoGbkY+iQCk96QwlQkyhQXhUedKz6wgOQsZ7+rG4OIw8uDgcEyKYsaYQo30wTF8nBUG8EzW/RPUb/2OCAA28s/gG0bIaCG2BdiD4X8psOUAVOn0/E/xNEGRMeUS38rTsM5qDy8gYswX17//MIz/3zDLDVgBP3llYJi+NGj1SNvMc3M1zcf1zOAJ2aSmWnJvejBt8MKQwT9DwQJyOGwrmT1DkXEfBmJnLBEDrBkSr/tkpk30brgI6oI7JBynwzY3/FrgCaKvDbBs+R6Q+/ul/OIfw+SQTn38BfFqu1NtGEEgCDGVHEqosYcQoPL+y8B2rToxRLPwkpEoHk/djOzr5oZvTWpInpj/GoxXGbwKVSOBNUC+1Sbfbo7TyybbOsBQk36m0CuJar1/SHXTD2pbiylSbuzieBX0HTPUkDWM026TRQclStQ15VRH2ZeoS2IAM+ydP4ASiAsT22VmqvGyJfmcPu6SknpyXrX6KmoyQCglvhI9eFO+1shZSpFNBt709bRMlgeC2J/B0/bEiNTAE7eUN2GwgaV4UCvZvTWxBMBmDfVtBE6
 e4CLSOJc
 KQ8elFzC5gmu5DknyN1CfE7WWV47p60mEJHl5AWkwWEXVv8m+x+2+JsEmWB/7geILAtJeSYqB2gjQ3HHkykqwKBmTb147vWhh6javEAkrlttnprJsF/H6Er0pkBJ2282c1QrkItK6NYrZWP0iCEFR5UMtpJOywT3dHValw70M5HFiO0ZS8iZr3ibPPB+ciQN8hPsp0EgNqLSMq+Y/4B+3uD83Hq/0abSzg17vg8xm343dJmqJeJLH7IbSlXEdxAiNCU0uxMcTh8qNyVUR4x1D9mq02FVH8PKYJAYr9djMlGaWYU/mcvBpwwZBkOttdUprdaveGsseni/31xs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize the nfsd filesystem as a pseudo filesystem. This raises
SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
executables or device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nfsd/nfsctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index f32311f2d7cf..ce2666deddbd 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -9,6 +9,7 @@
 #include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 
 #include <linux/sunrpc/cache.h>
 #include <linux/sunrpc/svcsock.h>
@@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct fs_context *fc)
 {
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
+	fc_init_pseudo(fc);
 	fc->ops = &nfsd_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


