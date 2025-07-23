Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B9AC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C128E0005; Wed, 23 Jul 2025 09:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53CC8E0002; Wed, 23 Jul 2025 09:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4AB8E0005; Wed, 23 Jul 2025 09:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6408E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 217C2C06D9
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:03 +0000 (UTC)
X-FDA: 83695542126.10.85344B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 59F2380018
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ETK2qZcN;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9liBMYG/DVS1McmQP1qxIOSzcSVz4iJiBcBOfa6Fc6Y=;
	b=7iaAU2MmC+gqVb283Rfslvc2zqpn2t9C5g1iLM++E+56nh70Chu/pomKfY75LN1UyUH7zN
	SjDU7u2weo2pKV0+XJmm+bCx7tvL9aDJK8lm1RUnapsG2K2a9eWP3TIJMsqkwyN7/WSDkS
	G2Jorkf9MC6ou6Sx/cUz2FbpE5doisw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ETK2qZcN;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275721; a=rsa-sha256;
	cv=none;
	b=U2oYDYAmodrmNi+psWmdLrmUO2W1WxIWJbEjANn+CphVbYIJkKJoGYSxHlE1woBjvCEkhc
	oR8x7VdnCjRhYVQIfLasgZzbY38LETaYMGo08wAVYTVIbXsfsfKCfpYPDQGbPwA++5JECo
	Dkjj8VffswYtfaogiisiK9v7TWzWHZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FFAD601F3;
	Wed, 23 Jul 2025 13:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762A9C4CEE7;
	Wed, 23 Jul 2025 13:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275720;
	bh=DdEPBcDoyZyAyQmgxVcA/USPwfaH12G0OefCJEr49ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETK2qZcN6+sQYJHSkoLVV0k/yH8twcRhKOYJgr93JPgv0nrXxZCzfFwSW1/G62IK+
	 dHXoqPt/Wx9t/L3G4sdDyxTDD3f4GLS20xqlO/uiD8S/BJbeMCdXOYPXBGSX5rWv8h
	 uU36XgMIC3kZdDlUYy2xEFpyQkWd7Ao9AI7MS+qm7TPCbsSNBulQ2TAtVt47DFfyvb
	 2rHJLTEmxms3qV80raVb15Ef5YlYHRpwCIAejwL3MXphMFCzgKfNnc/M/MphZcoMgV
	 btntopHEIl6egN2Hxfn87m1H+IhrWppCwky4m3zkIqrXkZG2T894pcTMD+L6pjBS5w
	 +ULHryOUF5DNQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 01/10] PCI/P2PDMA: Remove redundant bus_offset from map state
Date: Wed, 23 Jul 2025 16:00:02 +0300
Message-ID: <c1a4acd69e040fc2cc7e552849f4d922f5f66325.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rxmu1eu37a1jdib4p1czm3jqr4ryn85o
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 59F2380018
X-Rspam-User: 
X-HE-Tag: 1753275721-851654
X-HE-Meta: U2FsdGVkX19LL1MxXbn00t/qOFgAM6mW7knHZYSgKseRBZjiF3d4H1ShZXukoml9duEUkbRdL7dGcRJUXxGX2dGCx2/GQfwDLD62CJSOzX9297VOBxnw1v08zz1uZAdw2/47qj5NpxhlzYp0JWmfF8eIjJA6Q7oFe93X3GSol390fiHMsvkyCJ/3HDD304eMav4Rw95LE1iQYRtb3f8qxAUdeMXwLQuzis+AFUcEWS5g4ddP8G7z/Z/eHVqo1z7CGgUAfRoDKH+s9VNPf9NaUJ5KPoN3g0eUHsagW3yiETwUiwsEYXiNtuXuWnpCE/TYDqze0qfw7Ej+PTWyf3a4YjGAnZWxkc4+xFl2m8uVHt9sAy80SS7YqP8wVDmbrujpGDt/EZrBl4fd/6hZ94PIIVCkp86qt4xByEDD8MBaW/Y4pnCMDPB+m4iY57vHLpl6iome+GIetZcM/tazR2Z3t7TzDY0M+uBsSK+3NhWyuv+PlBJC+eGHmKtSCgLUI6BTsq+YsbtobsK0hmtVALM8C2SdRh6WvMGvSRrUnvbePsj1hy7MynifiDL+ntcWKmxVkkOfK/oO1hwb8yQ8b9jmNkXcAKTdRJcVsHj8oM4IWHzJQwD1CpRUvXdb3e+Dys0cCk5oqITdp4XJIVZFvL75kO4T64c3YhzdilrnTqvjipmkhJ4vBnHXlx6dRnCsh/s1cc5JMy+tpS0LZmhTeWcvXSeYe8ceD15Z94RaEFDZUMzBDXHg/wgtrWAVZroZPUziji+JtFEoDWygHwzH6XvlTJg8qwe2VUU9yFS4qmmpsJIxcnaZ+E/AfFKF+3L2JorQPIriOXhWn4CdA4LrQQgkfOcGpUd7vbhD+6VFsmeZHkvT3mSzCMzwx7VPrZ9GJPTHSZG9GU5uucaOz5O4DPlJBwAw8orUHAgBam4whVyAFeASrK65zTmZeEeQoewlSGlBh2DkwKhO/VqR1/TjlP7
 Mg9T8c6p
 wfn/69ajetTVG0Ijj2iFIeZS8u4+6IJJPg3dhds/tvfcgI/doMIraKY+gqXpySXhApow7mMng5Zj9G4SF4WHGHCx4SZsfQl6tpltgcmUU5YLDN4JgzI+VVZ0pTiWTieisRtbGtvBvEQxmvcHhyxjiTpmAIyDD09QjRk6vRCsCdZgudH3JaTZMFJiTOB+oVowlc6Dw/bSxNj+/NT+f2POBmaPd2IMFq0KMugAG6zh/RZrH7HbI4Nk9nNCfRUuKO/jVLIXtZUcMPBAWnvn64szFlGfQDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Remove the bus_off field from pci_p2pdma_map_state since it duplicates
information already available in the pgmap structure. The bus_offset
is only used in one location (pci_p2pdma_bus_addr_map) and is always
identical to pgmap->bus_offset.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 1 -
 include/linux/pci-p2pdma.h | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 8d955c25aed36..fe347ed7fd8f4 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1009,7 +1009,6 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 {
 	state->pgmap = page_pgmap(page);
 	state->map = pci_p2pdma_map_type(state->pgmap, dev);
-	state->bus_off = to_p2p_pgmap(state->pgmap)->bus_offset;
 }
 
 /**
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 075c20b161d98..b502fc8b49bf9 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -146,7 +146,6 @@ enum pci_p2pdma_map_type {
 struct pci_p2pdma_map_state {
 	struct dev_pagemap *pgmap;
 	enum pci_p2pdma_map_type map;
-	u64 bus_off;
 };
 
 /* helper for pci_p2pdma_state(), do not use directly */
@@ -186,7 +185,7 @@ static inline dma_addr_t
 pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
 {
 	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->bus_off;
+	return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.50.1


