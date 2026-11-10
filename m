Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAFD606BF25
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XaFZlFw/
Received: by kanga.kvack.org (Postfix)
	id 5F6EF6B05DE; Tue, 10 Nov 2026 04:18:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE346B05DF; Tue, 10 Nov 2026 04:18:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496F26B05E0; Tue, 10 Nov 2026 04:18:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23D5F6B05DE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAEB51A042D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:57 +0000 (UTC)
X-FDA: 85418659914.10.636587A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1116340003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XaFZlFw/";
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vbBpJ70QQUgTHc+9S4BdJlbLsLxsrAejDAnX1SbNic=;
	b=z9ruohKCqgAvqQWa4Ah8NF3u7MABH3HHo+bZ8efpnDkZd6n6iXyUOSs2H16Q/HGSe5mF18
	I7UoMkhMJr/34ZKSZwLPanYkoGS9JAbWsZmLL5lSzEyDVb+Ru/0RRiDWJ/Gw468e1Pje+4
	QhaWl0GhnWYzBl4WvLTICLEVIaK0Yy4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XaFZlFw/";
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302336;
	b=AKIbgsbOKakYcDnrpP2j4TFl5bMldhJeRYKAvaUI1omtPcMu/MGdkyhsM2hZy8Ky4XsZnV
	xPFEeQwssEp64Hf5MFySZZsclOg4aI3LgjjsKzeC3VwIYvGcJGlHI6wmk2En4jUuoN+K28
	qDdpmYjI41zQFt7cfYiEnClkuvcs06A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABE826380F;
	Tue, 10 Nov 2026 09:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4BE1F0089F;
	Tue, 10 Nov 2026 09:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302335;
	bh=3vbBpJ70QQUgTHc+9S4BdJlbLsLxsrAejDAnX1SbNic=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XaFZlFw/DdnrRtOVsZEGp6QUGtmIPGuUZ+N4Hdx0OM0hwO0dbNjERxcTuZMYTcqjH
	 niXGeBr0dTqT4XuSBUJ4fHJ8LPa5mQ0gDOgO3p3iTEzXRwE29SgFUYzxoeoORUG48o
	 4DJ6Rk3Cvuwko+rTIDQL/lX2vrxaez+zErrVL/jJfRbWQLh2oJpIux07YdOMODEWT1
	 AOcuJ+CDnO6LeM9EEmN9aS0LHpgFim9TfKS15MTiXRxDbWwt1Q2uZLl1zL9z5geSoA
	 YWA/+bXNEPPKIhhzJ78YCVVL+ahtQQQJ2oXlHwFAREVtyR2al+Mwd8OYF0Lie832Vc
	 YrFaKf6APBZQQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:42 +0100
Subject: [PATCH RFC 26/41] xenfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-26-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1017; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xO/6EKTyizodOr3jpQQP+lr/++u9/c+Tcs9J04rmnys=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erBpDZsiO/PvrRUOZYzHr09ZKmN5JzQjsOPDecc1T
 gv0mD6s6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIvSqG/3GRPk4+yw9m6Lz9
 kr3Yn+deca/qnJO3fHSPGiyKaKxs38HwV3xiCl/tWo1fM/4fmOj0yLklovHKITOdd0+MZx7UWyL
 0lg8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: pk3f6jhq1hzkajfoa1e3jhqoxmt9bkp8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1116340003
X-HE-Tag: 1794302335-594863
X-HE-Meta: U2FsdGVkX1+vkSEA5c1/peKMmGN6c69r1if/WZ0bCDT2qR/18/watSfSrVJazCzJtcHY2DbwauV8nlNOhfcCBD8ksKzpRkSXXL/X1cqmcbJUN+bgUXsD2FV26y8FLel0DmlVRfP/hIaphwwf0chjB05NRaEYKtXRelK8W109F9KR2S2P9DePtDhD45+nROIJXpSTiNOZpkJm9sTltH5iqWJrbtKLt5JhYwiGKrf+L/WoLLOlDVG+7xFMJCtnpUloJyWRcnLpSmK7tPtwd4cfDX6/A5yqkp+Jlzo4a9tqtTjrzyKVYnLSb3DUVy3UCE3AERxZK2NWqEb6twRG1RN42uGP2jH/2TU6K5qxzvzuDeEPzSacJLSk+YvWb1PY41iKNjdg2TMG0mDMDSzGHMNmXLRm4WYMuyNA3j0gu7iuSo7P4oWHm6zHafTjoRp+jCyMW3rxNy7cTGoLOj2V+ZPWjLwvtu/IM48865pBxuT8vuS73CBU0EyzbQlqOidgJfn7mjKN5cFtC/aSVvc41jV1Rbw7RXlv4Kt5RsAv1U9QyJWLfOC/sC4O1NUdOl1qHRswE0cOVMm4ZEcGEgUiKiGuIbUztQ6UUzOggXBvUAElZYMiLn6EEWd/OBTD4i+bqEaqFUFz1G5mTldFfAr7/gCk2ir9uVrkjsWnZkS1ybCWYJAIUhIqDBbM8kgbkhpEYLxN4ryD7u33h/yBcACTU+DUx0w2q0yRtmqBnii9hUgRSccPJC8ZMJaZC3j2jno172hQDFxJlDAeU/cNjpiteDAeRaLM3xfOWTttmwNmHxpay+tv6dDl+XDtARyoijDyHjbz50vl/UfsNeJkzYCg+bdHseodbjC/oko/+p9wWs8WZxFBlLc2grpq0XzJDmPWJIfLOjhNeJ01FUYFi2MNveAocgq3Iruvlp74QW0Si8ZE2GfB35atpfUPt8Zd19gIgWyX1E6GE4LakIbBrCh9HDg
 vSqe1mQI
 9Z8ZiOBepFthtaDp5w7oyHlOo41qCj7gVdheEFFCMBbHY5LDGFpKPGjxtcrS7WNX3GpEWeSOFhfHl9r3d0HmEbzmgbv+HwxV14IQoyeDNuk2d/dX1X5LqwDmslK6bE0jte/A4NZT7ivX0iPAonaeSl0kB6u4lRbwstPrJQT6d/zZpZkUtYtjp6qKcoAJclpiqGR5GJ25C8M0BceXMqsYjt863Ata0Lf9/krNrg2eRYYcG384xP/iWBvOTMNq6dshud6Lml1X1gYvVFhvxtA1dzncTQ/5zc5bn8P9AhE+I1XMoNK1ODR4aBAuukBRtg+M1fvj/sF+XS2g61qs=
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/xen/xenfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 37ea7c5c0346..aba7d038ed73 100644
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


