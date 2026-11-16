Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9F0606DFB2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLA1+ogO
Received: by kanga.kvack.org (Postfix)
	id 83C8C6B05FF; Mon, 16 Nov 2026 06:09:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6306B0600; Mon, 16 Nov 2026 06:09:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4C96B0601; Mon, 16 Nov 2026 06:09:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6146B05FF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E60F51C3DB3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:22 +0000 (UTC)
X-FDA: 85440710964.13.97E04A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 30D361C0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLA1+ogO;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlwMRZPG/WX1QF1ZB5LjirAXKfzgA2iLS0YZM79kPHY=;
	b=vnHRLBecpPy2woj+aih3SXmLVMkwCNCUt3gpY6h1VqJ3WU734lz7Rzg2Q6WvTqSNYSagWg
	fTlCHxJb3d00/SkfnkLOtPP+nKlqanew0x4Lta4YIbBPZBQetNX4YfyBQOOU294tnmDGv3
	61T2Ql0/tpshNXR9vP5LsVySguFaSvo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827361;
	b=oONJR1PofKKLDctf9/SiRKFrUSfphwtR0ERzBOk1AARJXdH+WKOy+CWyk1+27Y9QEE6tXP
	08wZJtf0X+jews4msagn4s+YD4m7Jz6zQDoRaIVR8Z7ZJg1h/7ru7j4dGnV8U5uZGhbuFD
	r+Fa7L7riE8jHp6o5GahCwy/nuync9Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLA1+ogO;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBE326292F;
	Mon, 16 Nov 2026 11:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF361F000C6;
	Mon, 16 Nov 2026 11:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827360;
	bh=KlwMRZPG/WX1QF1ZB5LjirAXKfzgA2iLS0YZM79kPHY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OLA1+ogOJ9Wwkd5TsReAO8ys23e7bh7jaUAOwpd93kXvrDCLtUKOWmFDC+NAofPGk
	 EE18TPYpwpdVL0ZSr3Iet25tX8sM/Ni5/227cFfNUP/xh+/9UimbRNEOt6UgW3hJMd
	 xNDm2VPZOk5BmoOLP/Bjnj450mttQniRwRJI7OfiPwGI5hN5j5yZ938PWE/UmZ5NaE
	 xFrgGbIR8sAD2dDbCYsWVv0cNFetcI+WiADyeSHwxDZOF4DpSZxoHzb4hpbJY/3zjE
	 qratSDqMtqNwDVu6NrMKkRRphEOMxNBGm3MuVnCUDSrt56ZIHBcSIuMZb2nPD8L6Sh
	 vVo7njwM+81nw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:59 +0100
Subject: [PATCH RFC v3 26/44] xenfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1067; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DjsTre7DB95dewo6bwxjriQruqKLMJT1kfwJFiFYE48=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elxr9HXXqUIT2ZbouKuvw3yk/sQp/0tYti/ufgXjI
 6a2rr2FHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO5lMfwP6b1LafHDuGqWV/2
 zJwtG8546JFf2UTJZr/ujICbZUmuWQz/jBWNbTe0ah56ppCyZ6kW494w03I2kYzbnRn/Hmpu/Zz
 GAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30D361C0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7eid8hu8r4fmrhdprn589nkomin3sxcj
X-Rspam-User: 
X-HE-Tag: 1794827361-530148
X-HE-Meta: U2FsdGVkX1/F4FJ65CwwX/uqfwyHiliHNa0qA2kw2oHo9aTKaCCQYtfSUlqj8TH/6jHuM+QohtuWkVUtcdY1Wr7KI4iesVimVPpgYdPyYSSXpdh4l9+vMRdE14DTvYfjJb8Z8YmIR13wtPfy1DplF8ZbTNxOV2j86gaBj+jJzsyqro5P8AkiQDKx0QRhfjCfkluPkiC9Cb7XMb8T2A93Nc+Xa1Xu0tUnQ+KGIFGECkQDcViDwbd/sKoeIF20OsPdp11L+mWwUPr7o44or0KigsmWcAGglV0n6TFiQOh/tVAODUNbb2a0IueJlPfKDWvW0UZ6KYLtUBUF6mHc4kpcF1gm6ySyhryl7whuQBEWEOLaG8f8I344uvpu47ve1BmruKzvpxo2ZxRaJ2XMdVkII8cHO0MkFd8EI34IHL0xYDpR6luj9fekPgnKu9OVJlSthrpmL8bKHvuarUCN4iamneB+nXHIEFBk6AvsY2L/QbxZqnpGg1mLF3U3hlcHHEsomgUFNeZIemhSGAm9Djxsbt3Gsmky9oY437hN+5ceda1WGu5k99unKy19MgFQtm3mA/U2gBazIr5VWyBcaUmdbGA8locl6Ud4RG4UTdCO8s1DFxR6rF+OTeuBwA9hkiGKqa3ktdmroG/maXS7jFaYUUkdpDvoPdotS5OJmChpC1d+NR4hml99U9eb7iuUAOtDz7EMHzuq8YSdSVjUKlTtDag2mOeRhfpBfRtZNnorzRrElm2oDRDUTnaO1KBIQIp6pfunoHixB1RaQe+eqvw5ThesMlN/K5N84csNFIKyeQd/0mC9UgxH+YKWKjs5Y3G7RL2QuWy8JZHHd9QFIwnNb52rQkV2HMivbHcAs9GpRmel9ke4pvKqQHFOIT9nHJIBD9KPZckfPG/P8UShChiR/K9Q0+eJ+r56u6OBvsrFfEsIdDO5pU89t7UE1tPEhBykwIVBTlUou57L2GXUBef
 l3d9DRGz
 8qhr1Ed5q+M//joELG13JyQ0mSN6FtTvktwcbSiQkzqJ+CbikNOhJoXkUOCqC1W/YtdrbY1DS8y0PeOV7JCphg/ZdwIcIXfXt38axYqMazoZILRDk3lCL//PM2lBDnXZ0ScB8UvLqjNeR0nz5WUYxdf149egiJvb1kGpmmKk0ajAsUY5FYNDHZm2w8Eb/pQMcMrX/Rix2Q7Kxs36A9OiKgJfPYqZJpv1vXv2RgDzu1hyBH1i+On1AdMWw69nmNayZsahEtnTnJel4naLd4LYknt7yN2zFHfZGoVqqAUxr2SfkCezvZtxbWkObgfOcPL2WRHJ8KHhOzSRTxPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize xenfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. xenfs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. xenfs maps the xenstore
page and guest memory through privcmd, both data.

Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/xen/xenfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 37ea7c5c03469..aba7d038ed735 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/magic.h>
 
 #include <xen/xen.h>
@@ -80,6 +81,7 @@ static const struct fs_context_operations xenfs_context_ops = {
 
 static int xenfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &xenfs_context_ops;
 	return 0;
 }

-- 
2.53.0


