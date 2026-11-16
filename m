Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89FDE60794D6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9B5RaEQ
Received: by kanga.kvack.org (Postfix)
	id AF4B36B05FC; Mon, 16 Nov 2026 06:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4ED6B05FD; Mon, 16 Nov 2026 06:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D436B05FE; Mon, 16 Nov 2026 06:09:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 796196B05FC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AAFAC0928
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:08 +0000 (UTC)
X-FDA: 85440710376.28.C965DF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4742614000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9B5RaEQ;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZa8raruWf4jzyZcy4zjAHZiv8qEDUIon9hD96nRur0=;
	b=KHwfbJ3oW+qrp2YqShDx+0wBpYj0d/UTsJDItUqqCdfjpU3auo577DfUDQ1kWS4e8NxOy5
	6YC2PMdSHeYRhfgCh/eXzMRrLkAjB2P5wxtAndmw1EyGcI6VZRNQLqPtGPXw7ayutyXEAN
	r12fGRlZ3HLJyFBH+7umW570rVfHL4M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9B5RaEQ;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827346;
	b=Oe4VDocUEPcTrXh/gEymS5XSjf2Be+ZIe1qR9J5trxfe5yB/+8HbO7H1IqcjLviDioChYw
	IK5twzSEbu5WS0NHVYmGt+lTgEiv/DGKc5LVMJZBocOw+8g0ESIFRLpw6ybcat8WwyLpGB
	rxpkIcMb9R4Kbg0+Pi+CiFQFX8QSgjs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92ADC41233;
	Mon, 16 Nov 2026 11:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643CC1F000C7;
	Mon, 16 Nov 2026 11:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827345;
	bh=WZa8raruWf4jzyZcy4zjAHZiv8qEDUIon9hD96nRur0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R9B5RaEQmiwsAP1jIczB2zWH7HySjdmMzkng/+3APaCz2aIiR/5pA6QHlhTGPsx8z
	 CRzgX8ndXpYp0sjoyAbMIp1+MxGD+2DAlrY7udq0z+KNdGy7F3kxcIwyC6zbTjxhWm
	 yirFYavZHEFP6gIEwpXBYIN6SxBglphEPLbBaCq7FRAcuqs7D0l1JDGItjul5ABdHB
	 d9KuKk4ck+bWHEQ7LhylcskCqFiUIBf3v15nKwFrhNFGCCv2wRxQdpOvT+/bHvNnrt
	 DnN5kVqm7vTrOkR80gnd3fRgFIsX/hlTkS2T+BoxTB5bUiUfAjvwd6zlckKAgcRgHy
	 1qyB+N2C8a43g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:57 +0100
Subject: [PATCH RFC v3 24/44] efivarfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-24-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=972; i=brauner@kernel.org;
 h=from:subject:message-id; bh=U3c0nafflYvUbB7XCWz+41zdupMknG85VhFAzpOuQl4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elxl0evIXDdr63nf8LI7X+5e612rf6tTU7lporhxj
 mdZts/6jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl0/WL4K3elzLjM+M6M+brf
 9/5bG75Vlvfsk9/+7EWxqyIett05Vc/wP8X9yuP865WvUu2fte80N+1KFXWeciZ+5nF3c9snSkG
 ZTAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: xmt3xhycdiurpenzs54xz6mhggkdmwuu
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4742614000F
X-HE-Tag: 1794827346-480449
X-HE-Meta: U2FsdGVkX18tqYo35a+eOT5gOM06vSfP+FxFs2cH8Ls8011pYZD1zeGhvOOZiWRafJtMdgMVLWioIqrGkwkAvS93QOwRk57KoUxlcVHa4MpjXmaPKPB/V9w3SS6tcMVpeyHTBLJN5Y1k5TxtxpZ+CvG5kZEqGv1b+/hqDjPs6bIcz5Ywd1q57ABJAm1ri+TavnKFCVdot0M2hkEYffwUXAOZkotWHeOsk7J1PoZ2jnc5sXsa3qxh8WMWGInHuQMrYvFYaFUPRoSqsvz1wbA1OUh8teW5hKiG9HRy0Mb93kV0tLOzCvBtRqGqUhgkGbPOXnDF1cSgJOtuYw+wY6dqiLnFWksKUGFLcMxOjzqh5HfDmK/2ZFN6jk7XzF8kc6P7NCQ1Nhvsewf8pkmDsIyUGYXRYIW5urPmKbjdh/TmDGKUsSkedEzcD0xjGmOrF0+B4yPMYl9M1BUJQ9JMTsAbUE9wAFdZIx5uxkk2RocFruUOhNJ4vUt2m7GDMEmGJWmGRKS6iBsaIScxyZlAMcoPQg+JA1poWz2jgYERNwGgG1os/869oVPMieC2B6T9hmsxPLrIxl1X5CE8FzBzuWG6sWqTMPkFiBzvKIjjTcRMRGNCaJibTzh+H76TlXmrstfmA1eXV6AxpIOjn1Kfv6CjzUvqF8xuXAD9T5aLqHkCYt5nbFYBjfNqV959h9AnH1713zjpyhJMrYevDJM/dNtj3RIEi4/tRm39eCRKA6o2tnLTT8xvDZMRBDL9qsVZLQhTEb+b5jhdUWMUVQN+n0EjRaTw68zVT+x0E0UhHaEwMXIRFVZMg/KrM8LsYswEO0OQur7UcUb3bZWO8QTxyakid2uofazaWdIMVyrzGzIxL0ENs0bdkS9j+GcH7u5BO9YerdSOFNPCT4kS7NxSvrgxWcYHW5tGlpRfEdWqXmBniwlATOcQ5AaKrqB1m06+Lg3HwUi9Z5oEG9NKnT4uM+9
 O2IHDfps
 1H4jKHrk8tS5BUEZ1rApitIZIJkp1ntEvsI3tlMYP8ctFfYicpUxtB5bdEMRpFuH3L8HYumlGs2lYZXpRcopCOoqdut14BLsB3lboTaGcWFT1ljyPZnrA7sVe4Nm7YCAf1mvHNev9lF2Ao+bAHlcNuuamua0UgG3NqCBnrbq1pDAy8NCY4J1RMtorj8MBbMd2TBFxdNTSUxrRT61koXwndn3aR+T63Y/Nd05eUSb2lr1FF2lV2KuLoT8dRjjc8X4iJ81bhBGXyoFQaVq7HZSU6R4HbL583sLubuiWd0cQS+bDvXZIzQtXttR1fOtjEVg9gWsceFqAxbSaSWKVpmDbsIZurQ5EIQPQvHnZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12746ced6dc63..e598d42c5f42c 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -8,6 +8,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
@@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	}
 
 	fc->s_fs_info = sfi;
+	fc_init_pseudo(fc);
 	fc->ops = &efivarfs_context_ops;
 
 	return 0;

-- 
2.53.0


