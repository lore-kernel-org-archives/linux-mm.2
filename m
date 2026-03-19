Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E177E109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A12A6B0567; Thu, 19 Mar 2026 14:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52ABB6B0569; Thu, 19 Mar 2026 14:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2C06B056B; Thu, 19 Mar 2026 14:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9586B0567
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E993D140155
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:10 +0000 (UTC)
X-FDA: 84563637060.28.8491D5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6133414000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xix1hbzJ;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jW3u7I9+lLjN9Ox5/qOhJqXGNGc19CSypJyyiYep6e0=;
	b=mdj4y4ZYWlIvKgmtGUm3nyHTdTR8y8P1QzTkt/UQOaGKOqlUqL8fM9oT/G+P336SbO8H5M
	kOiLRo3SIPRkvudUgaSxLecMIQ6lOaynbXZVTGW8RwzxLsnJ2NIocTWEPEPloFIhA9VOHa
	H43AzRk1WNrzxTKFv1hPTeiQuGEk3zM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xix1hbzJ;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944649; a=rsa-sha256;
	cv=none;
	b=yUF9Rl6Dt+umHAYPU48eE0r0HAZ/wGxEg+3SF+SkePkU4H/EbDvZIwMIPBLkzP+UTRRL3X
	EEFfr5SA/sJfINoTUiw3AMWC6Z2BsVku/YSHGqgYZ8at3ucT3l+YHjdIorcjc9qD/lcVYt
	JbgxxQy+ssYgO1fjIhHQ6Ta5m6GQZtg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D9BDD60054;
	Thu, 19 Mar 2026 18:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFCBC19425;
	Thu, 19 Mar 2026 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944648;
	bh=LhT0XvoqFL5inoAn3uLwrHjF8WgiWC6oU1y5hKpoQX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xix1hbzJ17ib608MrpnaHLSucjdnwjosxSDyq47tfbrRhwyG7s308M1gzj3WuaQBZ
	 mYnz0FxfmNkkvF6/w6M1GodW8m/d88eySpDOdx99xXsOo5tuwx9gaf47WhdUN3dbmm
	 pqIqFVBuoLDjcgsq43adH3LA5d3+IYUWO+6gysnULFkCuAK5/UAHgsIi6gS277LJIm
	 0ksjH5Git6YNho13gk0VVEKAbV+jBcbc3wRjyqxjbp74q6vxX1k15DRnzKNg1BpL7u
	 wOUEtso4ghSPyQ5wjqiqAWPqLFPKK9g2JFcEFKOEKjeFzQA0Q8Eg9pdlakIk71kwqH
	 44c0TBid3Al3Q==
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
Subject: [PATCH v3 08/16] hpet: replace deprecated mmap hook with mmap_prepare
Date: Thu, 19 Mar 2026 18:23:32 +0000
Message-ID: <aad6e8903eb4a8949f658eaf57a55a09a104c6f6.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6133414000B
X-Stat-Signature: rmiwmzt3xm9wbdhfoa8ic1wx69nrktd8
X-Rspam-User: 
X-HE-Tag: 1773944649-902388
X-HE-Meta: U2FsdGVkX1/Pw+D7VIb9Ub87pk26nVZKFi02SNPEk4W5z5nCtiHi1TEGdhOoANLo3/9v1JzmXT7JmLmDiiosS9347O/SjOuEwlQMHL9GJckgXvT56o1QRIS3zu8my2+dXAkfTY8B0enT9G/UWkDbrSXUeK40fadigZOgHnDN+HbGNB4mufdwWOj+j9Tk4wvL17IuJXJ/oM+LB4bAW/LnswTCiKCxd2DakWrcEgkicgGAmwl3sk66loVrc3w76hyP2dlmBpIvRUlj0KvttN4hMEVJb8NN7+yLHGmLMicOsRzhy46sIOQr1JqzoANbhc60FP5xZUiZryzDpsAT8Bqk6ugrM7dFi+8TXgWsLdUfdNrvTia2MAJCLXSy1XaCi5wHtt/EOQhEk3BM9h1PLwnaDJ9veVSOLruUM1ce8rK0rTpNFgJT2scDjzKWdXdoDlqkyL/vFRkMOBSb8AI5ArfeFiPSQg8qdCWb4Afn2KoUVx1DY4bTGmL9llsFc/jxswCoUJQpY6EsCpxOBR5xXgQd8PyqKJe0OPPw+XIe3extu3mPaH9gdErkfMazmtz4tFktJmXN64hTUMdZMB5WP/Gvq4xllHYvKjN7v2pu6TJPccHRUORsq/Se9wXyPTWCl+zwZYuCLWZI3YF2s3u8XCBCoPMaFgbyTbl4347afdmHQNcUBUzt5kHUCUVqLjWx2qBUWa6dsG3vUYzjhSQAtlpfBg1XjdHaIBvt9czk/iMCEZn9KNwOJ+OB6MhvyUfme1x+w63gSW0dlpRT/rfGu2pBeATn1rxj4VNJYR2TYt8Qp4A3tRaCMsL/0BsFZStmu4J0+yqmNTkja41VUDW+aZeW4F5sxYzHKhfZbH1kxFH8lNDn4RqMpl2pwvbioW0N3ENUu7IiPqllgVOlFfSRlfrIOm0/DvO2gr/DnBkX2pqw70mUvsDgqPb9g+GLdcHo2PVahReFz426PaS3U69RfId
 vsOz9H19
 BVrjqbJHXJM7N1peew+zqGcdHBbCo1UPbbaCDRdG9u+rVhKG10vN/3qU1zXglp4Lr8A+HpKuuhVSBccP5SqYUaDrAVB3SNxkSqS+I6f1/c5p6hRqFwNYXJeOdMxaMHlSb1GyTiWntfAyJVZhTz6FKpZz6SPMj84mOOzvRc3nP561yH3cYwimjo6/J2jDgjyVeg6okYbAgs+43xNz3LpjFTYSy5wvX6CqB60rXc4N2UmSyeqk+y0oPCedPhxnZDVPP3Dt+5I6sPWm0O+F3xWr1j8vzYCBgrSWpsneJloKoiA0CNB+uAzsaQIvzldrnlfrDbHYXTyMPe6L1HYnV0VBA6fXlVfOx9F7IWmfTLg+3PNwU374od+rKNHzzGQ==
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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


