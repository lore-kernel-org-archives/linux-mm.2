Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78FDD106ACE4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94636B00A5; Thu, 12 Mar 2026 16:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2BD76B00A7; Thu, 12 Mar 2026 16:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41036B00A8; Thu, 12 Mar 2026 16:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9226C6B00A5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45B751C498
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:10 +0000 (UTC)
X-FDA: 84538547940.02.3894994
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98C7D18000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=erAoF0sk;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLQ5/+dAFTyleEjPQjbNA1FoFbhiHvxjMg5pI0fqPpk=;
	b=3HrEQ2LS260vSLSqtsoG373siPooVtbQXAWziYV7iMnDH0xVfsI17/yV+juspKvTadDM3i
	H08kwqeucb+oKbsdTXjSRZmmc52QGyuUkg/lNUXIU1b/agUT7lIFZGWAS2gbuy9NbSaFDK
	+ygZG+djNPtDKHl+XmeLyTHAwUoYP2o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=erAoF0sk;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347288; a=rsa-sha256;
	cv=none;
	b=hNDHoULxuNr4u7VDpivoD7qlN13elZ2eIrDCVEv7zaOrxx+37Zbi+nlTjluLtcRDukyJuz
	KUaUDkaQTvz84DrH/bdGcCUy2fkUJ4vEdpwnPX5S8ZKFR3AXT8y8u51hpX8bKdfxYd8Fj3
	bHaaiLfK6VpuGcjMrS5yaMapveQbE1I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F2526133B;
	Thu, 12 Mar 2026 20:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED4CC2BCB0;
	Thu, 12 Mar 2026 20:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347287;
	bh=N35PsY/nqCRIMm5eMpyBBuhak2KyJHh8Z/VDZF7nLys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erAoF0skWhig2sy2XGQocOISTOPTHwY4byPzMCoxIUmvRIWtVFSlgvfuHzcn4wLJ1
	 O9AHxaTCKMABBZwnuuxfeI6PX0jVhab441MFdtVS0RIijBkqEqWFFsBTcBz+gH2hs5
	 GrmB2CPU0Ji2lyaV7Gr2QRueT8DLBehn7LcMbJKynkYWepvqbcHXwbsLd/AYItxfAc
	 EJ11iPF+R4matvTGKIYfOtftwYlSPKGg5g67cdXwOsS0jI5DGts3Hxb5D3hzDIqZm7
	 K/bmvlykPz44dERrspFs5AiNY5JbCnQlueXfiBEF6A1aHQL7oIcOia7Iqh5RA0cMNm
	 FQ0UA4BiN93tA==
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
Subject: [PATCH 08/15] hpet: replace deprecated mmap hook with mmap_prepare
Date: Thu, 12 Mar 2026 20:27:23 +0000
Message-ID: <6f9fdf902dede78143c26099b9a2b82ecef35a83.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98C7D18000F
X-Stat-Signature: 5em8e1yqrzxijx3zb3bo7cfwix6d88t5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773347288-887616
X-HE-Meta: U2FsdGVkX19GeEHEh9qRnn4ecFoL6Vy44+gJeHKUcSnSkDk3mrlFapfOaKQmRarcSzB9h/QxMpCMtNUQmc+0QJsljRkhNZfXsZl3qlPjbXmXyRrQrQolKcxrAncta8ocIiR9eMNQBJ3azekqVfiBP8nL4CmXJFIBXSeXbH3NLawWZk4/I8IXDsyRXAyw3OZSdB0gbnH8du2WduJukDkyR+XRdH7UNvl97FIk43rJ9RkHk6UeGtgEJCQTWC7/YX2vU7lhgmfYkyp9k59o5MnmF94GfbT9ypCv7o1y77+kK9scwnukLovfVR6KcMUcBkHiW4HBSKGFVxZ412XJKhJggcJzz5ntPPNPaBeOyVMTpgULjMBhMo2Jy2ZCfM5rzia0MXjYYR86C64AujUUda2/HqnkyeS17o532jSLSiKv7RcCQ2RH7eE+vesdZXgcBmnJVFehn6a0pcVkqbO0np5HDIV+AVeUqjed9yYvygHkuhMLfOcbZbq4hkykJDzL5+LSTujXuapvUHEl+NHzYofA3EW9mMiekbE0/5QOzga0Xy7ZpBpl04cWL2iKeaifFVI0qhwyA4Ve8IwuvgZCa3v3OR/lxOB8LEiAhwO1t43mjqOcY1QRirMzdpI0eocddLRXpB3M2DOmzYZ2P0I4n2nsc4uzRFoSzlzzVowU2oH0IpfadLhZ5qymXsCCWPK676H5WEYhy27U5MLQ9KlwlRO0T6Aq7U7OcvtCBfjo3tBZP0nfX2oT6qdOqe7IGT8yt43xRSsNXdc49AQHVTtanhgVrOYvbe9p324X1P32IwL/YuDvug/ocIYTteY4um98/ScEl64nmxrHXyQ8y2mC/V8hXvDwkXInj/YeMQlIGUyfpgcNN6Ef9WBfYqBH01KdwXGjtowTc+/dfM9HRIDtfr0vG0Pk4jYMJBDmTF6qP4y9VpN1lG8IWGVUbJsOiQn/qiiQ5z59P6xKufVVu9UQKOT
 ZAOVQk96
 nRB2rh3hiOC+dFnEtuXKSecLadwDBQj0KCLc5n6PyVnqZE7x+Tq+NZsTm9OMuYLi5Sx6e5lyPiDfh8x98F+2W4lnzrb4bYFugqVGa4w35U1UXQ9E9bfSlUZ79gsm8JqMC+26ynGjeAbhssXz8FKO/y7Pkvwz2W9nwanRth3+mceqNwc/oG5a6xGOPszY+Cbbo0plvIKZXQd1StHHju5NHTYb/1x3R5vjamsaKr0dNo3Ewg+SLQk9hNHIiZvG4iFIcXlqrAtBSF1JBAQ2YMAY4EKflRvnkRataUXRO+NVrLMIKZOysCKCd/0FlmZU2g7vmjk9+M1Orj3WA2cVq9/D9A8NDhdflmP9aR0P0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The f_op->mmap interface is deprecated, so update driver to use its
successor, mmap_prepare.

The driver previously used vm_iomap_memory(), so this change replaces it
with its mmap_prepare equivalent, mmap_action_simple_ioremap().

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/char/hpet.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 60dd09a56f50..8f128cc40147 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -354,8 +354,9 @@ static __init int hpet_mmap_enable(char *str)
 }
 __setup("hpet_mmap=", hpet_mmap_enable);
 
-static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+static int hpet_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	struct hpet_dev *devp;
 	unsigned long addr;
 
@@ -368,11 +369,12 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 	if (addr & (PAGE_SIZE - 1))
 		return -ENOSYS;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	return vm_iomap_memory(vma, addr, PAGE_SIZE);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	mmap_action_simple_ioremap(desc, addr, PAGE_SIZE);
+	return 0;
 }
 #else
-static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+static int hpet_mmap_prepare(struct vm_area_desc *desc)
 {
 	return -ENOSYS;
 }
@@ -710,7 +712,7 @@ static const struct file_operations hpet_fops = {
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
-	.mmap = hpet_mmap,
+	.mmap_prepare = hpet_mmap_prepare,
 };
 
 static int hpet_is_known(struct hpet_data *hdp)
-- 
2.53.0


