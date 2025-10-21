Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B534CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C682F8E001C; Tue, 21 Oct 2025 07:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17CD8E0002; Tue, 21 Oct 2025 07:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6338E001C; Tue, 21 Oct 2025 07:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8546E8E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5035611A195
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:01 +0000 (UTC)
X-FDA: 84021904722.19.FB8BD9E
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf22.hostedemail.com (Postfix) with ESMTP id 76433C000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:30:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=b93OUNWS;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovYggh8BE0fpVvDPOK5TnkkygYn9qlYyuaX7+8QzWGs=;
	b=jdUB0w32gXHNe+oqe5t0S2G6juwbBTgycx26+Qm0W2q6dczV8CwpFG1njDFTsTAAKXJnp4
	ljFxDj6Iuu66qYEB6IFIItV9zYT8Au5PNvtSEINsnFKVOdYcAIlyELPB/wYlElVIfdG6jb
	TUW+jxttaBgsRO1DwOyfUTVTI47zSQM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=b93OUNWS;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046259; a=rsa-sha256;
	cv=none;
	b=tsgdFGh3GbSSQ4bs5DBlKcNtAxzJG/exk9aIZ5Xo68j0kHZuGiSQeLtl3pZWphKzEQDOlh
	sgdWgzVN5U3nwdNef5BvMBLwxBtL4d1EuodCnj/QKmfXGYjG5pJbG+yEjSGwwTXYzwnHaN
	UPT2FWnVaftdmuu0FhLfn80ydCTNQ3Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046256;
	bh=sQcBV/ZWlVLGeAwivyndjv3Kv+k/mZS823qVLbIeFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b93OUNWSW7r7qTgAwBXcn8UspA2dw9uIT0hqSTrBG2A+DnUDLdWdkbPUkVdiDR7Kg
	 nowa/y8zFLm7q8uFqeeTfwEEuGnBnldVpADTAVcIjjd0cfUuhzBLlw5aqaxX0c9uHv
	 lQ9QFxrqwWDEwKZ//o7CQ7dcEhVijkFKsww9SI7bRmv3zoAwtre61MW/LstAyX2YP2
	 tjckVi7CldePzXZ9oesQKlRhNa62BKoaHzpqVExc4Jyt8/Jp73lELE7T3cFbgBq+7O
	 CpM+ZCmR7jaBx8pJ3GURSSU6P2lnpE8KVqz3gkys2UQotyM7NyrpT3HxQb5lkI1Hk2
	 cKLKKB5gXCHAA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id BA82017E131B;
	Tue, 21 Oct 2025 13:30:55 +0200 (CEST)
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
Subject: [PATCH v5 01/12] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Tue, 21 Oct 2025 13:30:38 +0200
Message-ID: <20251021113049.17242-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 76433C000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sr3htyk1dwpbd94qb466fqyym8tgk1c5
X-HE-Tag: 1761046259-626942
X-HE-Meta: U2FsdGVkX1+BZ3Drvjo7gv7rfjmcftYM4tqtIK+XCkfKyoVp19UJjKbhPU3RWAo9X1av+/P12s1kQbW7MVinz3QLQFhWmzzpi42LByZIfqtYPVFKQZsknUaF+/RhHSB3VIehAYmd9aCgcHvHv9T0jSHnKbJGTRXP2ExGLQra6gxi3DCn0Wtpk5sQGItvMDXieXKe5FzUUNp1yMoO20PhMNw/kykt8TUUMJMFB9sB7/JkjJeruqIUKQO5zQcEm+oagAAPzrrkPsMQOHSAJHv/DXPaeMQtanZEG068TpIx3hnSrrbffDth4zDq4kL/RaMkEva1PTf8m6uZgbeqF4d7ILrcZOPbWpsQhgGFhyUHHye72koWC00LE9BDl963BfpP5i6GdXwIeiKHOi0QiJKd0KkhZof+e9PkjsOLsLDpLBWMkDFZ3CMUQSNmT5Te7n0iWxL/pLJ7vhXjy9mMM+IKX9Il5ztMwHvSd6UhoZ4j/2R/k071/RJitfSEKhO9zyNLNKVRtcxCLaOf1dd5sEqmUn+LtwoIl0VL+Uxp7kyson54NYnfFmHPGy6zKYBJ/hNYGvmIqopv6aMpVksGfvzESLnTIvGZl3qeGN+IqMVKu84YPuU3HDOXB1vSL292FlGJLGw8YjfTel5aG1s1r3Al1FIijuc+nPg+8J+/yqTzQopf+RewbJbfkW8Uyc0/saRB8CzED0n9tNfqtHiS0a1zVrSQZy9cc7fFSvLhS0tiBVrASXGGgZ+gSVZ6c8rJwfDoaQX/uR/Dm6OW5UL45/Bm+S64GBkeSiZVP/KV84B/QtFES9y5YwV2HwZcIRBQgV3FjLs2rafsL5HfMzUlLag7NECq7es5QuTx+aVDLijG8ihYXKelmif6wIpUHeyWt3vVan/Sdu9UmGDkeqJRhlPYwYFM+L33QPfD306a5Wgps7XAoqEm1xbn4aWkfKsx2cvLMoBthVw/xJffg28b+7p
 OKnCflqy
 N9JXdXzTSkkVZvmm/NH3QN5Zjt4PkIeYzQetfcCVIYRtLNm4/Csos2UC71CNTSn9DSjAbiW1BwmDCI9VH2cR2Ju8CtjJAw/cP7/mLNtH4KvUOxnQYoGrS5Ch0CML4Agp6ZoGTTkNymQArmeJcZKUr6yLXyPwb9fD1FL97YBdku1eSSpldJ9xKnlxl09qa2htKrh5EaX61Zdxz+t0DjK4WlbMrtUsnPOnyTc7iwQFQYKhrwiqtTGFsEPBUTLSN97aTgdvLD3hw96WjuHCm1c20yHGwVvMKINCMJmr6tiZaRaqCzXDLVkHS9TGp1Ksnvn9hZG/5n42bCjLUHrRfxgG0vuS6dlg0Yeyckbcrbz1Rlzl08guKJEOv7LA2eRE+m6kxvESnWjdFpseN3jkX6hn5Tek/hwvwAHAbgfK/Ty3dxLQH3E/Z5lxWcYFuHvfxbQOjmT/Qyj8QoCtPa0DLDc6uqO+a7+WkAj4tHdcxsn4RI5oMCOia6MWRkWEitw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For a fault at address addr, the page offset is
  page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT
              = ((addr & PAGE_MASK) - vma->vm_start) >> PAGE_SHIFT
	      = (addr - vma->vm_start) >> PAGE_SHIFT

Since the faulty logical page offset based on VMA is
  vmf->pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT)

We can slightly simplify the calculation using
  page_offset = vmf->pgoff - vma->vm_pgoff

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index dc94a27710e5..be89be1c804c 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -577,8 +577,8 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct page *page;
 	pgoff_t page_offset;
 
-	/* We don't use vmf->pgoff since that has the fake offset */
-	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	/* Offset to faulty address in the VMA (without the fake offset). */
+	page_offset = vmf->pgoff - vma->vm_pgoff;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
-- 
2.47.3


