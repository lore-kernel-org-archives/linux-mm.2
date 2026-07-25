Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CAEFC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9825C6B00BE; Sat, 25 Jul 2026 17:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BE36B00BF; Sat, 25 Jul 2026 17:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3696B00C0; Sat, 25 Jul 2026 17:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8456B00BE
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:06:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D82CAA13D4
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:06:04 +0000 (UTC)
X-FDA: 85028531448.13.07719FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5667B2000B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:06:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qx53A1oD;
	spf=pass (imf13.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPa/LsrTp3hYJdTLzZYHVqwcc+ik3K0gwTpILC+a88c=;
	b=AV9lEbMUwH8BwHMIWxoEgVHZlNjV2p4SaqQ72lj32cd9CRCmp3SGuwTxoke2K/uAP6VR5w
	ePJepH5mppV5Fm5X6CIICaxNIY2daaG+MRPamaZpdP3cKfMaLsB1Uej4jfZlDss3MBJzXh
	F54QjYKr2SjAPfquGEPqoPiWtlQmFpM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013563;
	b=Afrr7meEk16TD0MywQyBkhKwnjU9/gFm43LFFRz8uHL4KsMA5zp6zHgRTLaK0Ec1ScUhIy
	3qz5wczbXKnZG7X1shHPgdhC/t0VPQR1cD2n4EebiCKB2tuOxdIUR51fNFI7Y/Bro9CHf7
	LVeeY2H7l6ICr0ZjYDe+xlnDH9f70K4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qx53A1oD;
	spf=pass (imf13.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA61960A98;
	Sat, 25 Jul 2026 21:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7C41F01558;
	Sat, 25 Jul 2026 21:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013562;
	bh=aPa/LsrTp3hYJdTLzZYHVqwcc+ik3K0gwTpILC+a88c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qx53A1oDvALciaFuFZCSSzhSlAz/InNoUWnSh/Gm5zNnNDFwrP2ubUYudxorFmIZ8
	 7zEIFtByOjtavUSHsMvApD7vD4GBbbBZ01esE+wg5sPWNTKs/+gt2cyZMdOV+UfNyB
	 GhqmCpoYIW4VHpQkIkngfd7iRMJAUjiV4C9aM74c3W8vOj+ntcwdGTREkVPCVA6Avr
	 qHdaGVv0kn9+MfiHmWQe8iz/+hbFJUASZfScyxqob2Rx+S5IFMVrQfSrTNtueszMAu
	 vKdnfxeTOPtQVYJsZOHmXU20gLd2UcFmXX2j+Jf0km+iLaw1Y9SMUcfySmRzl1/sU7
	 qSLDsH6/40CsA==
From: =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	kexec@lists.infradead.org,
	driver-core@lists.linux.dev
Subject: [PATCH v2 2/3] kernfs: Unmap mmaps of removed files via file->f_mapping
Date: Sat, 25 Jul 2026 21:05:48 +0000
Message-ID: <20260725210549.3716546-3-kwilczynski@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260725210549.3716546-1-kwilczynski@kernel.org>
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5667B2000B
X-Stat-Signature: g9i9k7oijpk8x1ecqx6mwines3irtcz9
X-HE-Tag: 1785013563-820523
X-HE-Meta: U2FsdGVkX1/sUCQpx/Hjww6XR2yKycfAlvkcbNQpw4mPxMmtBOjjAynJPwXrfKuOMTwNx86BjkxzrLTijHIsH/oOi1TKwdOFDVqiAyLa9hiJVuhytzPoDEemNv9zanOEnFfp1KWRCYM0vUDmQJjo/PDmum4Ur07MzCXUqGuBIzdm1dL//FLlYNvTQNyzgq3zgEg0+Vnpt1wMQA6ojzVqS9wUxVJGnd9l5d9BznUiYMLmB0a0Q4FCUKIJkHhqFPJ19ai2aRkd1tKijLofMSLNwVIEuUXq3I7VskDmAAjyWZsXD2QxkcTo6v7wkB+toO9eoP6RImldKxTYzU2xZNB/0/fjd8Xyf6yFbe/MBfk/2IECYv/XBT30NTTItAEE2yWhVbj6gmf10L0TNKVmw0WrNFUqA6Pq0vYmU4hwxMwEzdYMFKvf9zxpmLfNVfT1rmlCSCvItFpyyRdogT0evdrCtNzFCqM9zikXfrIz8UUI0j9UVP3OFz9e5slczGR9nxZari5O0Fy4MPqA0aV6Vaaz81V9PIag23JyJcyHmiwlkoL2C2NYyRrT2TBRgodq5M9cUbIo3rzDq3CKBzcDTJUHV2RSAyS9pZM1uRs3QnWteYWj8JioEN2y7VK9w3NF36+i/nKK0ZzOmnzHwXVMAK0MTc6EsvLLPpRn5LCgi+nYt4QYzYoHocg8LEHYAA4EnMYZoN2yuyHDdzvbYnPBzfpqFZ+KcB5oJLOhhEruTmQ337yA+GYdS8FHtoeVZd2on2C3nnEJt0zTHqCxxt5NM5xlCvn/K5r/aQBAxGHmcwQyHFefvJ2jx/HPDVnKGrSjimAbifxbNldpCcWbklZSmUTaPyZXZwNQOQgmiivPse4g+TimpFkp1EBrKlRQLUPyYp/ncC1y7CGnmCkqgJDgMf4wwpEXXuWd+6IrModSQpUDW1MwzKE/btQ/dz1sDw+9lTsDU0UARhXhgwWpItaeKJL
 V1uNrwDF
 NDaT5gPZFh86lQnJqp/hPip07JtWHCAiYUJBfzwZyRIkrH8gdVvPxBFYV4X6oo1NWJM0VZ+rs+wraOjC3KuKBQOwkWcBOipTICOF6+po2f4z061tEp7ePr5rY/J8rBMoMpMZq46KCtOjm7TKy9tKl4mQLjBfP2HVsLfaFcObAMxNIQ3vQJrc4pprsTSXBxkLcMMZ3CBl4qDxi7I0G59yLqi50SFCHWrALkNyTsG7Ysn02TrDheuG9P+dC0KdmiyOLSgfU4VBZ6n0lSObliSaQch0fyv+0tbdctlbqo9Lc9oFEk2dGgj3fD+VInlXvLDziqCKI1SPdMbt2WSay9sIJGvfDXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kernfs_drain_open_files() unmaps the mapping of the sysfs
inode, file_inode(of->file)->i_mapping, when a node with mmapped open
files is removed.  Since commit 636b21b50152 ("PCI: Revoke mappings
like devmem"), PCI resource and legacy sysfs files swap their
f_mapping to iomem_get_mapping() at open time, so their VMAs are
attached to the shared iomem address space, which the drain never
unmaps.

As a result, userspace mappings of PCI BARs survive device removal
and BAR resize, keeping stale PTEs into physical address space that
the kernel may have reassigned since.

Thus, use unmap_mapping_file() for every open file, so that only the
VMAs of the node being removed are zapped, while unrelated mappings
are left intact.  The same helper also covers files without a swapped
f_mapping, and the driver-claim revocation through revoke_iomem() is
unaffected, as those VMAs remain on the shared address space.

This restores the behaviour these files had before the f_mapping swap
was introduced.  A read through a stale mapping after removal now
raises SIGBUS instead of returning stale data.

Fixes: 636b21b50152 ("PCI: Revoke mappings like devmem")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
---
 fs/kernfs/file.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8e0e90c93372..eb04439e9c3e 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -815,10 +815,8 @@ void kernfs_drain_open_files(struct kernfs_node *kn)
 	}
 
 	list_for_each_entry(of, &on->files, list) {
-		struct inode *inode = file_inode(of->file);
-
 		if (of->mmapped) {
-			unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+			unmap_mapping_file(of->file);
 			of->mmapped = false;
 			on->nr_mmapped--;
 		}
-- 
2.55.0


