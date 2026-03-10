Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1B1EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7176B00C6; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0796B00BE; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D906B00BB; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5926B00C3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B63A140141
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.06.112207A
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf12.hostedemail.com (Postfix) with ESMTP id DEF7340014
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=NQWcwkCO;
	spf=pass (imf12.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8TjN/2NPFGBCTqh5wE+Sg730eIFQE4v4MynIZorfX4=;
	b=ijN10rVZt6J40c/F7STBjuAtVTumy7KhG3vS/rGfSJ7/WfzOZgtCHaBFwHwrZ79C1rHbHj
	Ua7OBo+KwFGaUO2fBsb7TiZ17Uzg99yCPQBQVmrbQ6eiUqP+ufbTM2JM+rZkhHYmAC3FvE
	6C4a/NVDbf8f4Ey2wGRUJ2kxzX+sHlo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=NQWcwkCO;
	spf=pass (imf12.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=CksUg8580kIWnG4CxLYt97l3sbQR5BuIvwGAIzJB9RE6ZD8Foq44Gmi0skPzsl8xBs3FVj
	IJCI8TIuFd0Y2mFpPmhKXuHgHFIW1MSeBhGPYj/iAIZ4Jf/iuz6XCuWlvfpOVorGGYuHWM
	H87RSDG9R8ucQIjx/eNEIZbksawfEig=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=+XsCLvfG0yRq7Clc+S6vXeLkWzACx5pWWBTw1PU8u30=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NQWcwkCO5Yf5aFU0Fr+hSnIE5j/fbQz1ZZ6kLAVpTNGfPh7umHqxt9pFFOy6bAroX
	 RBLvd0qLA99dtqQiGKYjsTOTfTZlUhx6yNiXQHG8dQ5sdIeNL7CirLYAhT5AwBd36o
	 YiESNxlbhaOWr4PVxOJfomk8wbeHNmFvrkSTOpuc=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-b734-7f0000032729-7f0000019c1c-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:16 +0100
Subject: [PATCH 50/61] iommu: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-50-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=934; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=+XsCLvfG0yRq7Clc+S6vXeLkWzACx5pWWBTw1PU8u30=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaAP0a4MkqsRJ5x7o2AECAXDJXUcNnvcP2jL
 Fnncqolc+mJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGgAAKCRA0LQZT0ays
 26BWCACZ2FsBOvK5vymJ4jNeheyMBLZmlutrR9jfimv19CKbp3wX0yqY0IgbC3+xiW+xz2CmiEu
 elpLzpFROPj+lHciOMtwniWl836Y8y3OBxdIzgp1Tcy3Ffv4iiDYZg6fn4s21C30sfDewBkZzM/
 oTShSXVQk2aaQji24A4tVvesTB1YCSJ0cdodFVu8ytRsCFbRhzUGEybOG9Bk1gp1pizhlUrevZe
 ky3pa8774nGDXRNTenO3QPi5eYmjmp3+jl22odQgRq4UYaTFuckuTj8ZjbSd3Db6Vvti4yjTzbj
 dPn6v3i40vUhGSdowNFCOZB8euyQhRspr8tJsS+hGDqM4vf7
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-E15CBA3D-56C34FAB/0/0
X-purgate-type: clean
X-purgate-size: 936
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: DEF7340014
X-Stat-Signature: 4hdquzhzxknnxk1sfoj9irsqmcatcm6c
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773143732-406079
X-HE-Meta: U2FsdGVkX183dcoNyYnBV0abZZFFHeVC27uw25rQVuPOkVmP0hpD5WOIs1l/VNTwGveYSEZsv67xPRTKPvEMWXhhXy4UI+44uLe/l3ngTS2uoHkiFlhL6ffhoBB+Zjh88q0BVFyR3b2Tq8R6t3yOigMLG3XwPFbWIian2k0XE3/6ij4UMd5sgmrtqGeb6H6ar0Wwc+8A/KMi0yB2woT7G+ZcO9QH9xP3wedxLSojJrNxGwhpVK6DPT64viddqHd092CzTPaPKoNt6125NCzD1apN5CVpIgJlxVfPj23WaxpAtKbKKJoeEAJf/k+YuJGlKW0z+KnchiSnWySSVAVQhaNagRT92w/8D5hFbDH6/WGrFfqbLxRANRtS4Ox7Sfj5IPFGgY0fZMLXTv0mKpyya91mD9Flk07qGk1MhOi5QPfOaJRzlUP/E7KTGdMxWfS5FBstkPtAhyj4lmuz7FNodOi2IOZDl+7hhEjwNol6My/PewuZvpCEgbKSdX3RojAhGdtaceQTEPVkZtSYyasB8HVVUs8SHC6L8MeKOfug20avmiAwGwFlHzTaDV/1onwIUxQfbjEyAMI2sIq5G/lkS1jBJ8JIRz55zpAw5N/JDnwVJaOb//7Kudhf7Hzfnc3+rvtVFfrJBYqgQ/rUmHuS9S3ODNKRx2dNKBSaZ3eTgkbiqPbPbu+6+Y/12L/MTuC8Z8d+8mYJYONooZ2I7zWt/CnB8Wifa5liW/6PFcQD8gUjK7KrrRLoli/boNArmOsVeGHEwciXg8g1scjq0Nt2+TdB/iqeK1IS7+RWKamDoR6AJmKvYXggQqeN7KvepD/AiZln3IYS+0j0aqrJnmSv9UMqLECWBVi31PWe8clSSae/IVt4JjiOpu/jIiOVhruGqykGOEqhiFgv+q8eCyg6+wmzV0EAqn8hsWigNx1GYNY5pxAuElVethUDAyeASFAKS9AoQ6946z5+eRLU1xk
 eRvhP9b2
 yiOEtJoHKC0mdCgJC6EkDBrLxPWX49o6Y2/NWMw6udN4ipSnOo7yNeGfRJ8hlPrPyHJ1rG7OILO+rrZpQvwdzl57RUqm7Rh4jucjnLVIlGUvOVImbdMRRb9ZBus/ihwvG/98zb6Zl3i5wrToK1NbSv2xoNFyUMGOEJi8L1GSFSE9MiCtwNeTuT7WCRehYk4dDJvjHV0TCmA8XQy13cYHRjmu9jzlbsa79ZvWVcdHGjjc/l+L8ZcFs9LKQzCNRYlK6b1fnXX5Ojh0myNH3Q20DHVFW86V10PCzgsohRn0B6rrbVZ6A0zuP3yyHn0T9p3oax3DlznlSl7IQkhzJIPvRp00UeWzfMlkG21Hs4c+GDIx1h7gPaFacKYpewHh3w1JoLhH541Kee82Q+bg7D19//k0qny06FvB9vcomMKU1wzvrtY0rbHDEJlMxMbx2Kmfe/fssTViPUv6w9iiZazyxLWi3++ww/5KSAqAZGU4JAGxbW1PkRIW3+ZyZKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Joerg Roedel <joro@8bytes.org>
To: Will Deacon <will@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/iommu/omap-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 8231d7d6bb6a9202025643639a6b28e6faa84659..500a42b57a997696ff37c76f028a717ab71d01f9 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -881,7 +881,7 @@ static int omap_iommu_attach(struct omap_iommu *obj, u32 *iopgd)
  **/
 static void omap_iommu_detach(struct omap_iommu *obj)
 {
-	if (!obj || IS_ERR(obj))
+	if (IS_ERR_OR_NULL(obj))
 		return;
 
 	spin_lock(&obj->iommu_lock);

-- 
2.43.0


