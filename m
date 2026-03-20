Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 716CB1099B50
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB636B0133; Fri, 20 Mar 2026 18:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1FC6B0135; Fri, 20 Mar 2026 18:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7AF6B0136; Fri, 20 Mar 2026 18:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3BC56B0133
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BCF2C1AE7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:42 +0000 (UTC)
X-FDA: 84567912324.22.24BBDC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EBDB1100010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHaH69Mn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQ5fcRfRZBqewJhpBVyDo43yFkyuLWkspExiz7UwmeI=;
	b=cMIug/QkK9SufmPt5f9SIrIBDa6m3l9iW3dXf97Q/4TA+W+C1qtwrQOa9hO3t9vqqMa2CE
	cel+hrKRUr1thw2V/0m6nRKXsWNGZZ9rD/ZRXgvP50zcoY3jFxAawErbSRcMLJPeSjk0o7
	Yo8BkLYGF1an0nPsrWdMZbyCu0SL9V8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046440; a=rsa-sha256;
	cv=none;
	b=NjIU9WI88dv0X+sKJZlYs9PPZvXqLcKjjUkHQHW72xxtWU3bMyoSM0rMp5sVbTin1LKa5e
	qo5DokjM2LDHr8P5ESmspZJ21YwoGPxdNQsvjx9CCTPi/Lfnl/Faj7zkgy5h3RxNDyaJjb
	TU85oi9SKc4wRNGZjoD06xwle1iKdEk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHaH69Mn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7182C6111A;
	Fri, 20 Mar 2026 22:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A408AC2BC9E;
	Fri, 20 Mar 2026 22:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046440;
	bh=zxWNAJj7O8GtoZ6ysYQIGq3mbn9MaN35AkA3dod/SuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHaH69MnrwnjEExESD+N74FB5sHGoJU4Jzp13qn42CieQKBElreTDK4ABKOTkKI9E
	 YVJEQk7Igps5UHFr1QkcNviCX9tiSeCorYcocEKZGuSjbBmhXF1i/McLQmQzd/BvQU
	 GwI4GRVLdXYDi8yLWVHQ9xx1hoS5xAYim9x1t09OJL4K+HgRfFl+5opDDkIHW80Wcw
	 G6sat1uwi9u+56yN/eGbFeoa/9Cs5QGbj5T35mAAZdIpfscfYs6Vrish6ZooqG2kPg
	 bkWKOcBQL5PZbrvNoj0VU0bO6v6Z2M7tEtp3VkTBumY6frrxHwXL/gBDIR57u/+hys
	 aDSMuS29n0SZw==
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
Subject: [PATCH v4 12/21] misc: open-dice: replace deprecated mmap hook with mmap_prepare
Date: Fri, 20 Mar 2026 22:39:38 +0000
Message-ID: <5a83ab00195dc8d0609fa6cc525493010ac4ead1.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBDB1100010
X-Stat-Signature: ibkq6okecb5azakj75ojapdq7c9ypq43
X-Rspam-User: 
X-HE-Tag: 1774046440-720344
X-HE-Meta: U2FsdGVkX1+ZyJf4wPWJo5YfSDHzcJr7sRmUEBEUZp3irQoCh4hQtsbYK8hrg0Jb2YnkUybfjr6EQlu+ekO7ur1K5SEZK4SlSplCsImYYtHHZJd3Yy7YRwQKn/xRp0I5i7dQn5qD5mgfIbAwyGr8kANpnQ6p9TXJVSJ4UnUQ9QrjtV3XFJgDd8tvZXbNZS+igRPZ9CPdVL70lGpBYdcWY1OIIzSHottVduF8lUfZRaA8sV+XDpC7867lMtaPE8M7SsTGytnUttvApnJW++csFovfXrXhALKbsLX0WG46aSR8afNSGlvewEdzPsPmtMj4Ga3ZUDr6odcP5JQKf6sb5waP8f1pSlWFVdZ0aBAH1m10lHs2CvAxFwgzCpyfoOWE/QATk+Cv5tb0D+Bp3ltc5x0hyX45Sq8SaGeFLCouv/RhZPFwDz6tALSrsotWfC6aGeoobRRRZwrKHYg76smCFp5Vsb7A59kudaA5kX+90o3c79cS00g8Jql4dgt/yHUrTQ58c+7JmFANbQWpvJx5kl6CLYMSi4SdGQ+Oj9AnK/zbPu2bd8qHyC92TnR7QmVFAjP1QWkh+DqIeojtKWdVzQAPVugZnZuGe2fULMbvBVbZVz0jUqAtfiO55vN/UhVkIixLf687gUls8HOMw5J2+RxHhHOH8KJBPQ/AM0xm4uG4Cyr7L4qhmp/wQt0mCuSzH4CNF37BV6ystWmDCwS64FjDMrlW/w7f7JG5zTOol+xkxlqEqfImndUvEahJ2nFA+TWvRpJ2yfuP36bBV1emNIZBieRYwXg0lJk+xEZItf6Msm9DrPcqjY2iFyrPSUrk2QvJ/osBGDr20Eq/KI44A2IkKVWHzxpRZ5iRg430F5td4EjzJUe/d8yBTkvLbrshDrcA/f3g21bGtF82yKBA88RCwd2FwIgH85I2NXKv3K4CkamzD53WoX2Q/hVTOT8e1e9ZRz3kFY06dhEIpkx
 Lg0Alr0Z
 A3YQ4NuPWeZX/MpGZjHss6wjzPsMNIJtdvJb2/cOwdHBhGSN85MyuTjiOGlkmIb3i08MEnXI5v7EuDmZS4+sCE3XWoj2mBBsvfL5/pJ4Uh4nedyGQKSnYfWRALmReO27hkyGcIz4RBWI/hr/w9oLpxBTbO/An/maPazXHJJiezhriXXJkm/iAkIIgS5EuZCw/3T563SKSZqAs46GCH4+VpNOxhKrdGSB+GnMq+/XPpFLkFQ+nWkZthXky/ALnhYGMyFs5AxERf8FFSguu9Tz2SJJuM9JYc0xdS+D5fLqPbGFJqQbw+DXM0j7RyD4y+MRMJeL3y639z9h8yZp9lPfFDzM5jRWMQYBuTj5eD12+mv03Mm+aDK/CZapqUA==
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
 drivers/misc/open-dice.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/open-dice.c b/drivers/misc/open-dice.c
index 24c29e0f00ef..45060fb4ea27 100644
--- a/drivers/misc/open-dice.c
+++ b/drivers/misc/open-dice.c
@@ -86,29 +86,32 @@ static ssize_t open_dice_write(struct file *filp, const char __user *ptr,
 /*
  * Creates a mapping of the reserved memory region in user address space.
  */
-static int open_dice_mmap(struct file *filp, struct vm_area_struct *vma)
+static int open_dice_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *filp = desc->file;
 	struct open_dice_drvdata *drvdata = to_open_dice_drvdata(filp);
 
-	if (vma->vm_flags & VM_MAYSHARE) {
+	if (vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
 		/* Do not allow userspace to modify the underlying data. */
-		if (vma->vm_flags & VM_WRITE)
+		if (vma_desc_test(desc, VMA_WRITE_BIT))
 			return -EPERM;
 		/* Ensure userspace cannot acquire VM_WRITE later. */
-		vm_flags_clear(vma, VM_MAYWRITE);
+		vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
 	}
 
 	/* Create write-combine mapping so all clients observe a wipe. */
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	vm_flags_set(vma, VM_DONTCOPY | VM_DONTDUMP);
-	return vm_iomap_memory(vma, drvdata->rmem->base, drvdata->rmem->size);
+	desc->page_prot = pgprot_writecombine(desc->page_prot);
+	vma_desc_set_flags(desc, VMA_DONTCOPY_BIT, VMA_DONTDUMP_BIT);
+	mmap_action_simple_ioremap(desc, drvdata->rmem->base,
+				   drvdata->rmem->size);
+	return 0;
 }
 
 static const struct file_operations open_dice_fops = {
 	.owner = THIS_MODULE,
 	.read = open_dice_read,
 	.write = open_dice_write,
-	.mmap = open_dice_mmap,
+	.mmap_prepare = open_dice_mmap_prepare,
 };
 
 static int __init open_dice_probe(struct platform_device *pdev)
-- 
2.53.0


