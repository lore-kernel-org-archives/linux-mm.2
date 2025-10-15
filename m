Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A043CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2178E0051; Wed, 15 Oct 2025 11:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849688E0005; Wed, 15 Oct 2025 11:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E0F8E0051; Wed, 15 Oct 2025 11:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5420A8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2308C1399D1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:55 +0000 (UTC)
X-FDA: 84000736470.02.BA184E6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4015016000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=oWauNRo5;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6Sk5hqN3o7EU7ky7uH/S38B6QQ5U8486HycD+qBSzo=;
	b=I8BqcaGzHknFUBHCiimUQfBTkDM2aHxa2ZnlZjthbdFBMlP/Sv5w2E/WAKUXfumblCzsqL
	KdGL2DHdMjcn+pUTz8ULXytw2w+yVRSpp7Ly3NbpsVTgHHvcm8c7vZv7hfq30YPrbxtqqf
	BJdgT1PI6TFiqo7I06lsEyJzqi83dlQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542253; a=rsa-sha256;
	cv=none;
	b=qn3/o0BN8hKp1QFaxT0wH0L+iVsaB56Yc80mA7FNZgO9GcBng/6FZ9oRtaHoh02CweO/Of
	jekJt1x5KaTWoQ8oJS4FcnnmvzLE9/mxra4OL5ZwHolonzdxnWIh1OUTIeIMNvuSbfQD1y
	J7tfqGsMcofOlt7KN4J9qqFUb2AJIcY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=oWauNRo5;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542251;
	bh=ROKoonOOaPmiRlBVqml71l+74uvjDMGSuEeXXfy4kSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWauNRo5O8AxCrbqN3wpQuZhqtYBS/whks9Dwc5EtVArhQT5qpEhVrSlH6wBw4uEU
	 iKaDieQ7m7kvx0TbZ7pJDXX5+Ms8gyoCJ+mrOS6zO98Xy0LPr3eY6ZoVwRRpj/qt51
	 Q1Ck9KR4XbG7CyXHbj+L4+vIgms72znNIyV2+qxI9nH+F11CvHJMqvLGbCsnusFBO/
	 V8TY6t5nVgAuKW1sos2k9HuBavmxb6aGEV/t83si+7Q3ZeUzuGjLEeMh/R8QU44LrH
	 cr2BxHFzhREQhUiJEFzo2Uq+ORjUrKy/qJMkAdxNVlFpILq3pSpcjE57bYZ8Ik0lO4
	 TejE+TXE6gekg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id CBCEC17E1340;
	Wed, 15 Oct 2025 17:30:50 +0200 (CEST)
From: =?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Miko=C5=82aj=20Wasiak?= <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kernel@collabora.com
Subject: [PATCH v4 11/13] drm/panthor: Improve IOMMU map/unmap debugging logs
Date: Wed, 15 Oct 2025 17:30:15 +0200
Message-ID: <20251015153018.43735-12-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4015016000A
X-Rspamd-Server: rspam02
X-Stat-Signature: q7syxn7tqzpt6yzdwdeygquxshkphkz7
X-HE-Tag: 1760542253-264574
X-HE-Meta: U2FsdGVkX1+ImA+9OIRpv5BsYFA0lZe/5LwaS8MJTlCvggQpa4alnLyKrDZZ0WAbNQa8i0+OLwtmFSat48uq9Mnvr4ITtmmY2qXJeefcuQKAx4cgjMnX4aDN7If2dWwYbcIDeieHWAtRMEeMtIEr2kMQEqT+imwqZX+avKnYwN7G9vDD1Q4YrKJDWWjv9L4YGoNFD/5sj0KQn9fwvQ4rtD/Fj+3kP6bVRYmLGKm8B43d/9a6bu+7oV8YLZGJK8BDCYJhUGuYBTZesjqPlx4oPTqmaOgx6xmpTYD1kf4VMdQziaxNvkwPZTXUt1VuOqmp1ZSyrHuogpsrVxH3taLd3j7LUs6XuNqvA3Pc7BksFWhG14OVofHN1u/23patH4kjqMhegaEb2gLDZ2aTwMnWo3448tymDXJoVVldPJ8y0UKHBns0oCaubC9tiqwgf9fQlOllUtk3/W4tpAgg4Nz1r6j0qThsy2npzZHBTtkwFAnTAj/60ycBrlq0R0HLffF8S2G//ymJdTRxJttQh5rEo1hgQOt6ZMWaBInbFvX8Y7Z6qWhdXVZ0M7KF43r59niDpTnyx+YtybcI/EmCBS2Zh+2BZzLkyJIYGoZsJ2sY71uEzZdDMc6Y9b5Fsn6M1LXnpgJA7Ez0asVhLH9bSq+xBZUaen3g75Inr3gDv+Jiq+vDzQd1Uh2zcYzpdVhyVcSiD6AHdVGpVLNNlg5voDBVvua2g+q4WH9eAcanJg9XYk7DJB95eGzo4SQsU2WZzq85blYf7LdH8HPiUG6ypVEgjJa6oU7avAkoLUwrjI+ZVUTEk/Rnamvm1r5L9b1NXThpZqEthPGBz5HKPTgVB//ub51TbMlhinDAfIP60PqPPf3JLlAneHgifSxBgdzJVypn9aUAWsDQg2EacH0vJ2YsYqs0O7myJOFyTUBJPlngdoC8qVW9TQ3wlfGWlpixIcyaSJpOnxHth0MOaOUHsAs
 Iqir1ll0
 Bs0bcQmYiAuRuVYhaQWPdTVUU7Bn44WA/TTDHMBib2vZYb6Gt0L067gVaTtgwzBkLEmLaK6qTJJ56IG2P8gEpW5q4ALZDgj0SEz3fH7nIHimb+hHdH1+o9E0HVcekRpflTXDBNy2K8pbwdDvJDqlXEhzpBuA1j6BeHdOe9364P0vUO0puPYt+Zc36otnV3qVI0tUfpok+j220vsvhuddmGNfvVOAZ5rVdxEI05q9XAvWPRlH5j/BiNeOgrNOXXExdVv7VAM/tHkyhpoKYXi/TLnMRFEMQ9OVLsYPrqpK/h5A5jMrnKQ4KuSMcA5hk16pBWcg95mYt0Zkvo65j6npdSLOSyFbmW3zDQ5ahN2WOLST9732Fjt8zHljgggGyyyPDgxrP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Log the number of pages and their sizes actually mapped/unmapped by
the IOMMU page table driver. Since a map/unmap op is often split in
several ops depending on the underlying scatter/gather table, add the
start address and the total size to the debugging logs in order to
help understand which batch an op is part of.

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 6dec4354e378..aefbd83d1a75 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -917,10 +917,9 @@ static int panthor_vm_unmap_pages(struct panthor_vm *vm, u64 iova, u64 size)
 {
 	struct panthor_device *ptdev = vm->ptdev;
 	struct io_pgtable_ops *ops = vm->pgtbl_ops;
+	u64 start_iova = iova;
 	u64 offset = 0;
 
-	drm_dbg(&ptdev->base, "unmap: as=%d, iova=%llx, len=%llx", vm->as.id, iova, size);
-
 	while (offset < size) {
 		size_t unmapped_sz = 0, pgcount;
 		size_t pgsize = get_pgsize(iova + offset, size - offset, &pgcount);
@@ -935,6 +934,12 @@ static int panthor_vm_unmap_pages(struct panthor_vm *vm, u64 iova, u64 size)
 			panthor_vm_flush_range(vm, iova, offset + unmapped_sz);
 			return  -EINVAL;
 		}
+
+		drm_dbg(&ptdev->base,
+			"unmap: as=%d, iova=0x%llx, sz=%llu, va=0x%llx, pgcnt=%zu, pgsz=%zu",
+			vm->as.id, start_iova, size, iova + offset,
+			unmapped_sz / pgsize, pgsize);
+
 		offset += unmapped_sz;
 	}
 
@@ -950,6 +955,7 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova, int prot,
 	struct scatterlist *sgl;
 	struct io_pgtable_ops *ops = vm->pgtbl_ops;
 	u64 start_iova = iova;
+	u64 start_size = size;
 	int ret;
 
 	if (!size)
@@ -969,15 +975,18 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova, int prot,
 		len = min_t(size_t, len, size);
 		size -= len;
 
-		drm_dbg(&ptdev->base, "map: as=%d, iova=%llx, paddr=%pad, len=%zx",
-			vm->as.id, iova, &paddr, len);
-
 		while (len) {
 			size_t pgcount, mapped = 0;
 			size_t pgsize = get_pgsize(iova | paddr, len, &pgcount);
 
 			ret = ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot,
 					     GFP_KERNEL, &mapped);
+
+			drm_dbg(&ptdev->base,
+				"map: as=%d, iova=0x%llx, sz=%llu, va=0x%llx, pa=%pad, pgcnt=%zu, pgsz=%zu",
+				vm->as.id, start_iova, start_size, iova, &paddr,
+				mapped / pgsize, pgsize);
+
 			iova += mapped;
 			paddr += mapped;
 			len -= mapped;
-- 
2.47.3


