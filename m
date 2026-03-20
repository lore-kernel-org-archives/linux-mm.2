Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC031099B4B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883066B0135; Fri, 20 Mar 2026 18:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A486B0136; Fri, 20 Mar 2026 18:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797E86B0137; Fri, 20 Mar 2026 18:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFE86B0135
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35D951D7C5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:45 +0000 (UTC)
X-FDA: 84567912450.02.9A5D50B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A473A120002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l4wHJxsh;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jW3u7I9+lLjN9Ox5/qOhJqXGNGc19CSypJyyiYep6e0=;
	b=2mj1N7ArwtuEJEtL5ukyU4VMO7MolaUGO6vlptcjMAAzCfmT6TSMwoJYbqoiQfEY31+kb6
	n/myFkuCtLlQVr2udkbDyia+IrV659MSwPz0ASlTryL7JEcoKR8gWWJbQ8gaWMfpc68jcs
	iTK7t/aJMAglbsqFsun3RRlDN1mtOoE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l4wHJxsh;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046443; a=rsa-sha256;
	cv=none;
	b=2Hx/kKnaHYkpOv8TEn0f2ujVE4scQt6PWKVx84VwgtBH5pp5N3UEsVmyBXDVWOTf6gU9xv
	Zmk0MCtmX5kWk6XaBWdtCk1/vLFVqyCgPlo75UlKFT8wmdxLIfxzcdyrB/YmKk+bL1S0H0
	7XGw+d1Le2cdveYpJBjZadv55n7lzGY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 30E1B61852;
	Fri, 20 Mar 2026 22:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DC0C2BCB2;
	Fri, 20 Mar 2026 22:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046443;
	bh=LhT0XvoqFL5inoAn3uLwrHjF8WgiWC6oU1y5hKpoQX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4wHJxsh7bYrI5l9ypzEJJtRUNeMWoz2qQ6/CYcGcW6jBmZWlRSJKuTUhZQe/WKcc
	 VsRAogHYE/GMTSF9k7KQwCnYeraYqnjeiTQJaiZBwJd5wOH1b5ayrRDW5yDMQKY6dy
	 bW61X0wOKU66c5WTPw0B4hbi18iGnFEHGTz0G67J9Z6ohhrp6ooCSCEj89MEkcqpqQ
	 DBw1rYls5FAig8H/X2et7iKJdCKYxZ3BBE/j4VlCfyTSw9b6kXjs+yVPrNaB4Jc0wx
	 j64mDAAaOvoFQEKZ6nZg2+wIkP8ME7WDB+olROlFem2adm+nNFPwxfPpzTeZ7TkxD6
	 hVTZFsJ0VtaSw==
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
Subject: [PATCH v4 13/21] hpet: replace deprecated mmap hook with mmap_prepare
Date: Fri, 20 Mar 2026 22:39:39 +0000
Message-ID: <094c5fcfb2459a4f6d791b1fb852b01e252a44d4.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A473A120002
X-Stat-Signature: dsbab4w7k9y5j4dca6p8z5ref4jusbut
X-Rspam-User: 
X-HE-Tag: 1774046443-857957
X-HE-Meta: U2FsdGVkX1/mXdEYrh5aTl/2eQRv64Dx0N9NG/o+EspdPxodyVu5z9rhNjvIJ0DNiwkin3CKP+TvcTUQy3fcgKepTWo7e8IY1MnsodOMl4wVpAoYMIQ9EM3aXRpotmwJLmPVCWyepCs90XIvwfSS12H0qA33apxB3yyL/uM4gJV6OiYNrCQXLKwneeXt1VnOfL5qxKigf7e51q+nndI9DFhxJ1rjjaHnnsYOwinKDIjfVlnDK5wTDNiUPrxcOkf5JOunZPYeF28JUxqkhB8VWa2G0TEGWNV/JzDfB+zCTwF7UoXz54VdIzDmWSwnd3o1NSj3LRBmUI2bP4RbcV+hvM7AjLcAw4RV1As8w6qouvGdE1TR0efdbYIDILSzYdCsp6AfT0p2txDMcbPkmJOJ3uRcpzjPvbZ/WchXHtsOX4tU21tEqBlztYs3GNyRVHvOMFGtIXNl0BMmP8hXFY5Mjpm1aw2gQvYnTL56rPxhiGWiINi5KpBgEUrIqjRPMHHW+vZZEMMGh6tQqfUnIpvm6asRLOxQVLQKLSVkpQc6Bo3jk7cEJlLUIw1FZVwGl2Ra7utVl2EFEEjf/RGrAl2/HC0wlQfgLekiNoDoFWOZF/uC7QkMNSs7P2Bq0NN1WDS28DUXim+C2rzVvWERaH14tkGxrHQlbXR8NPEwh3okZJ7NlJSF4NvG415batPaX9tuo3RZ27SzeRG2ZhU1askSQAoedqTThZCahNOCky7S5+60yTMNrsLCbTWrIaJAOvW1FG5awz5Cod1780UG4SFI2vOSHkz+iY1Nw5xJpYzY6l+JP/SakRxfcbAyuNekhcxUXZIPpEpTv4enqiOY4+kMGvUxgjqKPwLe9CdjTgjRW+hLdJSrp9sRIsNsJa/AXSG7Vt1q5kYi9YaOhqHcEIQfNCTnvsQE9Sk4wq2qeu6YvF6CTMqhz0xrpr8H+124PzGvaw/ocXWNyTftiFQ+m17
 Low898Vd
 6K75VBgNy6uOuxP8n0DdQSZy4zLAqfCRmNIqBzXUUeQluBeaf7QVWdoKsepB0nXnTO4dxsAscYUW3Unr/ugtFQv6N+zAhk46F/0FX5q7CC/KiPUEhjjB0PueZFjhFPuHGybcz/mo60j0krN1gT5YH4S7ltq9AAgaJApJS7N8/xjCrq6uyfTqdk7MKSthZeawZhhnMQx45656ZvplrzBD0cnHe/HxuhGZh5S7qa1esGraQdLYl8WnFFmDkUoYevnScOv6RcG9I3SZjjbxUkOiCdf5JdpWUUfiuUFAtDDE2K46aSJbN8rcE6bgGC7u8HqGzChiZV0PfduHIyCiMGAQ4fFNUZCDZNCRjFiQzVGY0EzDNE9vu3Gd8WhbNjQ==
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


