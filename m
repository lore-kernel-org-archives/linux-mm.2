Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138E0FF512E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 17:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390D46B0005; Tue,  7 Apr 2026 13:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341866B0088; Tue,  7 Apr 2026 13:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231026B0089; Tue,  7 Apr 2026 13:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3D86B0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:02:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C68F6160867
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:02:07 +0000 (UTC)
X-FDA: 84632377494.10.F6564EE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id C4FA08002A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:02:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="TDW7x8/C"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775581326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RU9CUTBlQTV9unvZiW1Jd4pICbElcO0miIF1kiEWLp4=;
	b=ZCJ42TakSCVvdLglEoKR9nnARZccdSqgcnSRzMLj1VPZo3NAJaXM/E8H14z7JZ+rPkdeer
	wNiMRsOODkfOwN9Lfx/kdZit2bSbqc9lKgglD7EFWmbQ/tnLsKXtGqgLHKwTp0vbQVFk+2
	NZ5mI6igZg3mtzixo8skWPUbBuLaYQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775581326; a=rsa-sha256;
	cv=none;
	b=QmdDcCfQ91cdH01MCgKAzflvcuLauu/DJnw3knnd5vaFyOuNzbVuOSC1/03/A5BexVd2Ik
	Ev8FpmcGexO1tkf5E4AlNR4fD8dyJRAjZTKSrTh8stqE4CYF3kqBhjPSaAgAbmqYmLjODs
	XqWcxWZLB/m6Id3fZCu+RtlsXQWhjJk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="TDW7x8/C";
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=RU9CUTBlQTV9unvZiW1Jd4pICbElcO0miIF1kiEWLp4=; b=TDW7x8/Cs5bog2cDLG7VRZw7mI
	uXdr5mFUG0MHd/TjOmBDl3ivMIiF2q2rgA8LWXVvR0d3+AVnpWpRf4n4rjTlR/DSZEd02PSBfWqO9
	A0jZAJj3dFxox5lZ1fvv5iVwGTd5XhZNRXAuHKNn/DFmzdqGv4nvM9TGt7vSg5aFsVnH3hsfdoXza
	gif5GP1xJXNZOVc8ZjjZ9+lhp7iTfBQub4UeKgf8M+EQFEggWPgwcTMq7do11Bj0XsEEKL+7upZmc
	NyIp54SgnZzTgTe1ee+PcccgWdWh/a/NszTSpOWqQfOwUdtAglQZP7tUZL0tO7NHrBXN+03HQc8V+
	LTzBs2jw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wA9oO-007mvG-1S;
	Tue, 07 Apr 2026 17:01:59 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 07 Apr 2026 10:01:47 -0700
Subject: [PATCH] kho: fix error handling in kho_add_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-kho_fix_send-v1-1-b21977feb960@debian.org>
X-B4-Tracking: v=1; b=H4sIAHo41WkC/yXMTQqDMBAG0KsM39pAjH+Qq5QiaiY6LcSSaUUQ7
 y5tl2/zDihnYYWnA5k3UVkTPJUFYVqGNLORAE9w1rW2tp15LmsfZe+VUzADV1Us29A11qEgvDJ
 H2X/d7f63fsYHT+/vgfO8AOSrA1twAAAA
X-Change-ID: 20260407-kho_fix_send-ae33f16d7502
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2270; i=leitao@debian.org;
 h=from:subject:message-id; bh=mGwEireWqSGdcxepiszY5FgqrgUhgGJ91Fpy3eOBcDM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1TiD8BaOCojAoyo4gqxHXTLFN+vR9pNm/DeW3
 TfrpuAhq7yJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadU4gwAKCRA1o5Of/Hh3
 bQYFD/0VGdPVpIsIE+BuFlsCe113eYUK+EoINu70uXmeeQkBov6zRr52bpi+VEaWBJd47lWSy7H
 XKY/7ME30RAOXDTT5aPAFNKnlaIbXh3voGs7YsJTmD+dWikCYu00M7rq/E7y92Di5/QnXmfiCNC
 lPhxivU8c4pl7f2LK5wV4D4R2TWPupeLDZta+7EkNm6HRuu9QxpqOKumCKyJzjNfI/vKXqHksBi
 HE3sLwzVVn+F1bwfMDMNbmkmE5gQceOTvCQU2BLr92qPRO3TJp+zE2zoSBHfMV7yyukt8aXy+C7
 +0yJMkcKFxXveJ8L6k8B/9Sa9VhiM3O7P5zcJbEEvK4f2MKd5HE8GwyKC6y8jXViK+L4G0/NDmf
 Y5NPV2JmP6dk1v734w+kDqOzxrCogiLSM8pYhMp6cgk1KSgyyr4Ts+Cl9W440s45dsH4aISs3EQ
 G/pL919eTfRLrVd5HZZrdgeZRbxQzf/5mO0+e+4mvY0SXm/+EbHXLu6zCqFZu2QFbccBpECsHti
 1Ayk9dMMgIuUoU53ik9kQ4cy8IfFyJtbu0/eDmo6AP2N6TTftctPOPi88p7fG3VrpX/Zwt35/M5
 RUaivx4dN/ow8yCQO/e7wOeV6cEqmM+C8vRndLhsC3l5Gb0f56tup1VgOF3N0uNI9FovLd4hjSS
 xrKD/hwBiQgiPYA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: C4FA08002A
X-Stat-Signature: tkxqyij5uyp3a43spnyz1xywogb86aek
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775581325-837831
X-HE-Meta: U2FsdGVkX1/0wneHHjildL9nP8kz6gCRtiPZlnDUHV41dVi6GUBlEYgs1Xxv588c6Xe4G5zTSlM2SLdUMzoo9NhVmtx2A2D+6fxSrGgfY1uDezmQmatGYIN8lldxCHFE+8j0SG9/U1aqq1PafHjSCVg8WhuQH0ACVmcrR8uW/JCuD/W5ik6o+voj/sz+O284FZ4izyIhAUlSC64KLq0wQbmZX25bQA7Wh0riULFYdW4enTJf8feyOsxoAQZloZNIkoTNgEZW9F9zC+7QF5UeDNrMMp5WM3oOHkgMnq5NNNU+SIpKQghjloqnPJzWUxbSmmMjulJqOY7HgfKd1MtdwMpD+/tH3pnxokvsxqrhbvTkgjZX/eYr5rlSCMGESCS56+8WwmGJlOb5KaSBMX/zesOv0UkT4TNCxpmHjS7B6qzCntXn89OzTsTg4y2GzEisj+rIAt2tv3QqqwYfdV7bkQXaomMDrx7oNk3qyjBsZeI8rxd5o1mcH0mzhfTcyb23UG/upnq9YQVLT/vtQm8/497NDtrO6+nlxSHCOhRo7hyygdE3LL8rVOGEKSXw8Pb7wQJEHUpfKXjXdVjG54LAybpH/eTc7BL15Clz1ioCiYYikfCZBfywoqIvnWWBlUwk8kwaJfl3R7gnZ8bSd3olv0MovdwSK68lsWSNJoIQugr3L5mnhE9lh48LJfkWGbZ6hOhPY82PxkbhzmhY0z4SC0SHuHNxf8nW0+IsCCw0wH5XGuAd/MQHor0DHnnn20eYnHPim0X5OOkTAxs8oab59not5IouhNN0gV8EOs2dGnCe5wav+YouaWwSJlcLA/F8J+0BwhaTFv/l1TNGsi2UCQ/pA75ojF2z9cMEYE0wWuuyAvep+7K5QfuhMybyIgNrSXGRXY3/PuXo2V2Aio6RRwoFrf8UF+ZTSZqZu/VDhgXebtlzAunC5FsolcWhGOL8Oq2dobWI1Ukgy8zKdX+
 fXG+Hlw8
 mqC4m2n0OED1TBHfeF0fNDzmMvNODnmWTex6wfMayeayUTyf+FN1bJ/RpTgVIoILJpClIgVCL9/b0+bz0fUkYPclDiMpxVbqNPAOPItUyKk2GUhiuDnCDtPLA+TyL4u+dey1CtdyRm3jzpACnWzyrD1QnZ7s2j87keYeHt/d9Dphuo52SKIPPGZxwbmv67zI2+Ccl2Pj1Er8U+fMpdVvvCwtdAtlSkrjmY/Sm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two error handling issues in kho_add_subtree(), where it doesn't
handle the error path correctly.

1. If fdt_setprop() fails after the subnode has been created, the
   subnode is not removed. This leaves an incomplete node in the FDT
   (missing "preserved-data" or "blob-size" properties).

2. The fdt_setprop() return value (an FDT error code) is stored
   directly in err and returned to the caller, which expects -errno.

Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
out_del_node label that removes the subnode on failure, and only setting
err = 0 on the success path, otherwise returning -ENOMEM (instead of
FDT_ERR_ errors that would come from fdt_setprop).

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/liveupdate/kexec_handover.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 94762de1fe5f0..18509d8082ea7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -762,19 +762,24 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
-			  &phys, sizeof(phys));
-	if (err < 0)
-		goto out_pack;
+	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
+			      &phys, sizeof(phys));
+	if (fdt_err < 0)
+		goto out_del_node;
 
-	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
-			  &size_u64, sizeof(size_u64));
-	if (err < 0)
-		goto out_pack;
+	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
+			      &size_u64, sizeof(size_u64));
+	if (fdt_err < 0)
+		goto out_del_node;
 
 	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
 					  size, false));
 
+	err = 0;
+	goto out_pack;
+
+out_del_node:
+	fdt_del_node(root_fdt, off);
 out_pack:
 	fdt_pack(root_fdt);
 

---
base-commit: 9763aa6c6df784d7159925c0b3bef4dfb791e84f
change-id: 20260407-kho_fix_send-ae33f16d7502

Best regards,
--  
Breno Leitao <leitao@debian.org>


