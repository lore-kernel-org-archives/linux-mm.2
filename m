Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1D5606CDFB
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPYvZMcK
Received: by kanga.kvack.org (Postfix)
	id 4AB556B05E4; Sat, 14 Nov 2026 08:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483086B05E5; Sat, 14 Nov 2026 08:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371E86B05E6; Sat, 14 Nov 2026 08:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19F096B05E4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:09:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD2891403CB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:10 +0000 (UTC)
X-FDA: 85433755260.16.AD4B827
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EFAE720007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPYvZMcK;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=id4PRLDY8xxqmv09Cy60S/mO+ESr2mIJ65uM2WRQC7s=;
	b=yvpyrb4vYZWvR7/3yU4kqgqJg52YIqn0Etr8cg19JyFVFTS98PCZPn8/LT3h6uB2qMAWFd
	gdhkNt28a+K5IAqofLakEwCCcjHNS5RCa/SoDnpQDeukfouPnh49JHtuJricxle95ZRtyA
	jKDICenurvTnpbF8WGGRVWjnPZ75XKU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661749;
	b=oG3ohGYy48dtFYERisgR7cZO703Utu36n7S9vRA/2sgJmzdUWjq12H/RZEODYb0KuKtCGH
	GHfOF0Bt3NaCh7gS1ikBXtzM1BBO2jN6s9Ya3CDso8ne/ywKSTew8zuQ9TCGxDpE0MYi+z
	JDXN0hBcm0eSF4r1xXTZBg1jSWGESqM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPYvZMcK;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F3536254F;
	Sat, 14 Nov 2026 13:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84511F000C4;
	Sat, 14 Nov 2026 13:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661748;
	bh=id4PRLDY8xxqmv09Cy60S/mO+ESr2mIJ65uM2WRQC7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OPYvZMcKo2pLKQPLfKiB+xqQT7JtU6u/nMFLT+5hYzH3QWTCFPRoRS6r/Oow1VAkL
	 3HYR/sSwpSruxS71lTMziygx7APu494xsLge+qXN+aS/Fp3Yr+SysKiJDxgm9fV8FL
	 LLLNw7kLSad5h56STuFO2hVPqf8d8oG5y+9btaqGaQCPkoLOjBnZy2HRlufPRIqJR9
	 JAGDmN3jPQZ4ZGCu2z1obHGmPT84ifLV2wmvOlYzT12//tpCLC91vE73DnFUFErjrE
	 jtHCCp7HwPDe37nSYEBsn4aY5ZIWlVvyOmtxOFVyVhXkm5TyApjftkdHnhTF0e2OJb
	 Th1bcZaPa1Qrw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:11 +0100
Subject: [PATCH RFC v2 30/42] powerpc/spufs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-30-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IfUgpka9O6kutLnlSG4nrBix3fgpTd+0l8aZ7VY9Wl0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOmwtup7dlAk4P1lb2Nu/V0Xay46TjCe9C/9OFdZk
 KnsNdfKjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkw7GT4n/qCU/F0TKjhPQ87
 jwlLc8VsP+cYLxcU+LHbRm/KCV2pdEaGPWc5jk092LJ1wpFjdg3lNRW7ODKTlXubs7L6rYTlL85
 gAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EFAE720007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: o8r5y9xbujdssxz5ohxp6gbgn1ipcdez
X-Rspam-User: 
X-HE-Tag: 1794661748-102343
X-HE-Meta: U2FsdGVkX18igUpRzsxQAhXpdQRMycRAbOIvVVaiBOlCvbBWMp2AB8ABlll5rH1piPtEUgCBeBY0RzBPd26heYPr/3N6ZljKoMMQmrcGElLzAVFKlPU+7xRcEML3aWEwb3z0rg+8EqDHvtfmrg/O404iyYXtUf15KwBOh8OUzbIBqEY1VaCf1hcdwoOGaPyn/doX8DR8kI4xOEdK0mqO6GcyoVdiAr+054OQ1QAzwmZj8mxFXGv4RWW2keNHnfMc8JyE+k4mZmkHeKLa//z6EIYrVfyZb4eUKrfEsXgt1s2w23kEkbeJuz2J3oARq+eJvePjzvOqFqj2k9OZfmc00CSvTnKbv7XG6RHHDOXww5G1r4ETOu+VgEPvxINuDKcqqJ0oe62rsX94+/D3C9Ryhm0Rsbt/sCidNgqiCy/TW3tmQkjkpu72kAosfHxiuDq2DLcLranoVVCfAJmfgUa6hYMWux1H3VkxEqDGg+4B56JQrhaSFXYhsxam1z8Zn79dXe1kuyJNObFoWPq82xgHXqBvT45lFUkdTTV49k4/giO1M60yjCy43PR1+4Mp3fCOoUYN+G1LB7E/P75IIni7AXawyluSdWqFTL5c3zcdA+1GzG+wejkiVDV/NO3fP2s3KSh+nug8ZpPavt80cnVkBnE/P4AIGRcH8RpU19+OoYegEC98TVFYt2zdRyhY+M+K7Gw1XU2ohhKipI2T8ue4wN4mZqSqSewvM+V2h29BEa/caWqq7B6j1jcCW+KMoWcRmPGkbhxbWCBtY+WiVa96Msp2iyJTaq+ltpiH0hJ23HH0OzmzceF4Hqw7WCpJR0UiLtPFqZnyJQiIqEl6iqPdfrMx01JDILGsXlAijftM8LKzE9vEWG/pU//2E/KtdIgKbEujoeSwPyTxf4auBJbellzVjPnPF8n5vN8oYDVfM/d24ofCEA4Qz8roRU6Ai4IVafOk4ycit2Dml2EInSr
 bg2+uwdJ
 VciAvqBxvKyxacl5xsJrKCCn9gU2rY6vrfJ1MP/cGnN2TJl/57BXY7hl6WNiImW9PYouhxrC3hIg6pMFdSwIeNHZQeldKYVQvmCE57wbYCae6S9FjBX1rP9pV2JWvmXoq/frepi9IrxvHRnjW0F8EMtKUIjTUTa0Pc2gpGy9dEO2ZZGqCjR6xqjGQQ41TrORlkaONh8CtYHS1rShlINRnjjCtM8KCFFb9rDL8/wOEbkELtJaHpbv/bhjITZDDBqSSN/U3EszD19LT9oICGes0PQSbNz3Wxzc29blxD1GsnzC9a5MbedZh2Sz/ZvMTOCSTN3WpHDiV0SRN+HB4nN2KdD8fbLRwCDrfpRwXydzgfkyXs3lECLV1HP0g87sRb0DyiI/IJFUuq+GXt1AI3yilFKMkBuqA14d2rY4AwpoUGhwDVTmRPRoGU9n80u75vsnPhc9/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize spufs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. spufs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The spufs files that can
be mapped expose local store and problem state areas of the SPU,
nothing the PPU executes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f066d9c7344d3..54b45932aecd2 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/fsnotify.h>
 #include <linux/backing-dev.h>
@@ -741,6 +742,7 @@ static int spufs_init_fs_context(struct fs_context *fc)
 
 	fc->fs_private = ctx;
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &spufs_context_ops;
 	return 0;
 

-- 
2.53.0


