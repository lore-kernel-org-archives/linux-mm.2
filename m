Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D75109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505216B0569; Thu, 19 Mar 2026 14:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48ECC6B056B; Thu, 19 Mar 2026 14:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4626B056D; Thu, 19 Mar 2026 14:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5506B0569
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6CD5140706
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:13 +0000 (UTC)
X-FDA: 84563637186.07.8F648F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 521DC100010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LB2MowTg;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WJAlWvMvYkS+6WYdocVnt1a4d1lO198hZRen0i5ofk=;
	b=0I8x2CzybaF05kAiH4iSLolFI9EYk3WoTxFz51a558UxYLFKhw/ss3P+08tP9PxyZmXFqO
	G6p1ZIDZ3BRdRpcTQ74v6vbIKPSDJNLR8T8fKgrD8yFSnJILes6T1kjacVPROjdEfoBRja
	PmJbz0J2kXGyJYn73Fb5aJ+HkYdqZ5c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LB2MowTg;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944652; a=rsa-sha256;
	cv=none;
	b=tplJVudbqAFicksmEPBz3+0XMge5XLzin9um3I0lGlfe9OFDVU59LklTcrLXSYVzl5P+oY
	NRGVKvKuim8P2EUjXmAIrwzCQqXrvdi7XwzPPvN07rZ2bQ03zeho9eCO97wV39zFTtReVU
	iwyxtRL4o6bbFssodcBjbK0eV48YsE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5567600AD;
	Thu, 19 Mar 2026 18:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3758C2BCB1;
	Thu, 19 Mar 2026 18:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944651;
	bh=sJsnVE59stSeWATG7qlVuZYBseXJSjXjZYGmtSdmRzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB2MowTg1QHbA22I0rbpNVF25MKxoRRYtAKlPHLN4dbu9KIcNEYeX7hrui1Yo60sA
	 41POtaNmYUU93Is2iZo9VE8J3c28cODjtUaq643u93jXEsa3c9um3tn7IpGoK45+bi
	 EDglmM3mgleEfyaKfli7dh+jwqRJarhb7LjGbgo8/j4TFO/7rEDjog0+k8I4eQOGLi
	 DuvPNX4rSLYYSYDL8iqd2dW1o5zTfkd/slsn3TuxA1rg7kOfQFIgXhnUCzhSUXu/L0
	 36imA2VexFto5Uac6adE5+bzC8u+yRTcsjpndkaN8rY2ajP+gpEjnqeWljn+O9UEVq
	 4Ts4pfrM9ZIEA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v3 09/16] mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
Date: Thu, 19 Mar 2026 18:23:33 +0000
Message-ID: <d439d6941f4b1a3f598e6a6a95630d215152961f.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 521DC100010
X-Stat-Signature: 3u9sjjgcrn9gijkdxz3fw9acpcfbiajo
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773944652-886258
X-HE-Meta: U2FsdGVkX1/zHfNKjz9VOKgIrLRg5gXpCSrF5dJZGIld8rtxu0Xu5Yk1OuhpFl/oJ9ciKCO2/eDtuCja5KMS8HoaUXG+1h1HO6zvbn/4Dt3mt+N7NbnoK85E2K2wBGIWIjqil6bUEDlBWjO1sV6/2M6HF9f6Ewozm/cj+TIWgb5AkKg139InZibHon0ujxUuGuRadrOpnzMLvdBAu58L9SFhT1g7pAkQYQN0hC30/Sj0rj5ZXHSGKFolmngQPQFovAD/dHbF6QfMsMBJ9gxxD2kNAkeJkDP8E7KgU/UY739B1C/DK0mBreW1lAe3g6ECWugfaws2gtQfpZN0p0fEK9iV8+gavoUHqWzgsxteGHlRtwP0/xZR98wygoCTaRgM/oVUvF5U7MeZRxXNXPbcy3V+RaLZgUeRqdn0WabnOAejHrBiqRK6q7ZoYCkM7Au1QpZMQ8op1dwuHyWlv/HMuYXlyfXSgmelQQmk39y822iysc+aOUyMy5AaESuqnZOYWDtxHAECCZvhJIK5ZKhfFGht3kEDh5xm1V8q0EZu0MN4ipXWqYfHVcjXZPIl9D5YWlgMQtUJA9Y60+lnhU85JkJywcmL2DDLYMqn8JqdxeoorHD84RaCZpziUg6/hYow6oacTSQAX05EsipNLKV9j9HRj5Td/qFX9uy0M4RaPJ74fxzvWtIPPT1WPy6kc8p4b83V1vY41EpGTQDJ8Yr5wnu6veOG7Icr2lResDn9y1xATK3Zcq/hFlxjdn87cvOvtxgnVU/qiEVfeQ6osqywQytLzzdfoLXFBehwHnPMD0Q4JnFYmwZykYdCN0BQeheJQIUZSFcRfS4T7yYiQkNc+efqw+6Q11PYXRzhC/L95YIKLqoOXl5PHFQrxOyJPJQJEZsN5+lwpWZkGznY6DVGT/ji/bzQasca+o+wGqYQkSIFd25bEsSS6NC+7ND4QIsrVXx6rLLIrWvuS4Bj3rQ
 bXMwfn1B
 0njSnrbQG6B1DseJvjStpuridsQ2qjosRdkUugYj18BL85lbSX1Ethe/Eno8laR5OGY3K+FZOxg1zPd8Sh9/Da1h++rKnDrXqyG2chnHr+mJM3TqfXmN0nebQUb30xwOWT9Fe5OM0mNpHK3SjXXj1aIajx9hDrSgqohN2CUubsXDzUSyohwbJuRbQOWJRuwVhPJ3r4WhHNOlRH9MdJuwcA4nVwewY4QbGp8iB9bWRqe9aI+QZVrTvLX8CzanukkI0e2pL/XM0ht/MCgJ4vOwIiuHMr7MdujZHBEkwQsXtuXGP/3ITvVAQDmbpEpSGS2l1URZ6PIk82KBLuoL4tYr3TqQdEY5gdaV7umitMUzkzWhYceqp8M6Pab7eM+z5XBWr29jf5uvrECUQRbEOSy7oEf9rkTAzrymQpPMUOcM2dw4HRKp88G0wOP7d7Mg3X7xkUyAcs8ugrqyX4Yfu5pVWQIbr1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the deprecated mmap callback with mmap_prepare.

Commit f5cf8f07423b ("mtd: Disable mtdchar mmap on MMU systems") commented
out the CONFIG_MMU part of this function back in 2012, so after ~14 years
it's probably reasonable to remove this altogether rather than updating
dead code.

Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/mtd/mtdchar.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 55a43682c567..bf01e6ac7293 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1376,27 +1376,12 @@ static unsigned mtdchar_mmap_capabilities(struct file *file)
 /*
  * set up a mapping for shared memory segments
  */
-static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
+static int mtdchar_mmap_prepare(struct vm_area_desc *desc)
 {
 #ifdef CONFIG_MMU
-	struct mtd_file_info *mfi = file->private_data;
-	struct mtd_info *mtd = mfi->mtd;
-	struct map_info *map = mtd->priv;
-
-        /* This is broken because it assumes the MTD device is map-based
-	   and that mtd->priv is a valid struct map_info.  It should be
-	   replaced with something that uses the mtd_get_unmapped_area()
-	   operation properly. */
-	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
-#ifdef pgprot_noncached
-		if (file->f_flags & O_DSYNC || map->phys >= __pa(high_memory))
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#endif
-		return vm_iomap_memory(vma, map->phys, map->size);
-	}
 	return -ENODEV;
 #else
-	return vma->vm_flags & VM_SHARED ? 0 : -EACCES;
+	return vma_desc_test(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
 #endif
 }
 
@@ -1411,7 +1396,7 @@ static const struct file_operations mtd_fops = {
 #endif
 	.open		= mtdchar_open,
 	.release	= mtdchar_close,
-	.mmap		= mtdchar_mmap,
+	.mmap_prepare	= mtdchar_mmap_prepare,
 #ifndef CONFIG_MMU
 	.get_unmapped_area = mtdchar_get_unmapped_area,
 	.mmap_capabilities = mtdchar_mmap_capabilities,
-- 
2.53.0


