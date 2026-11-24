Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BF5606D0D8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNip109e
Received: by kanga.kvack.org (Postfix)
	id 947FB6B071D; Tue, 24 Nov 2026 09:06:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920CA6B071F; Tue, 24 Nov 2026 09:06:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836206B0720; Tue, 24 Nov 2026 09:06:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0966B071D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:06:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9ADE80B8C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:06:19 +0000 (UTC)
X-FDA: 85470187278.20.30D0B86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3221740018
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:06:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNip109e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529178;
	b=5z//ahXvUFAS/4GN12VOHwa7aOxRybMYEfx+UL8CRaLXvMBl+Mu1EUl7rngE8IeSHMH3iu
	eUo6rXJCTQEqOj9lnw1RnWzhjvt5kB/2wr4qMs9q8nkKeDm5M/0NKf62/kzNWRohvU707O
	eJ1F+yTgabVGWvPf69Ye31/RzAuwCbg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FUmabyr4uQL+774Pvtn0Hclc0nu9L2r9AtaFETc/GA=;
	b=ANLpw6ylFBakhWc5X9EBGE4LVbN3QH8Ma7rSp70WK/8n3+NZt4d+AEOrq/viS6jxWp98eB
	2YSeX4/G8SJI+Yosv3kbJ7/9SPhxMWJJLZqdOXtLR9mZGru39GRqhStm64vhl20hMMTYok
	5PWv49SQNM45EscfIN2orcB8Sw/FPUI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNip109e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6863040755;
	Tue, 24 Nov 2026 14:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C24F1F000F0;
	Tue, 24 Nov 2026 14:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529177;
	bh=7FUmabyr4uQL+774Pvtn0Hclc0nu9L2r9AtaFETc/GA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PNip109e1v8AW41xU7g1LBDLiTkaFRP8f4lZPkWTaQTZjRjFkQGMj8SHSlPBNZ2hH
	 laeFtadOphJlM/Zu0+Ptde0v4sw3DIojGjlR2m3Qeu4CzKMRUAYso+tGP3tNzqdpUU
	 3sU6lzTKuQWYqrxkL5hORf1O/+Hd+Wm4c8OvqIXcRd+ed0pWiVLiUh9729Yx9jx6Fi
	 dgXnxqAfIA8dZQ6o3EwPJ+IUCAlYnXIx9hj5ELXrFUEkSnPqlONUQf1SpQ6qeJt9wO
	 D7Z8L5+AC0tRE+/U+WmavqRwYF54su3iDaH7Xb22dOtX1vDC/N8NGim9zMmqD/7g1W
	 xIohsVS5dOzsw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:54 +0000
Subject: [PATCH v2 11/13] misc: bcm-vk: convert mmap hook to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-11-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
 Ryan Chen <ryan_chen@aspeedtech.com>, 
 Billy Tsai <billy_tsai@aspeedtech.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Scott Branden <scott.branden@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: ljs@kernel.org, xen-devel@lists.xenproject.org, 
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
 selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; i=ljs@kernel.org;
 h=from:subject:message-id; bh=dRLES62L0oNx/h8n7oOxCXbdn7WuTRK+ZkJqntS+Ejg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ0rUZakxBThbH2CZem92EdvkV4oicReY36/xvsBfp
 jlz6+lPHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjI0nBGho3CNY3Z605Z/zPu
 KRDaKl1vlbg8hjs3tHkrV62rTZVdHSPDdePvS9YekA+OrkzRyBNLVHkfcy3a4bNpv8ypohR7gQP
 sAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 3221740018
X-Stat-Signature: ft3a9p3oz71ud3ekjr753iobm8t665ce
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795529178-226943
X-HE-Meta: U2FsdGVkX1/gTONdqpRzwCu87wXNQ6uK2y7LauaLyHn9wfjLzEds/w9VHmHlP4Rs1L8g3KK8t/3+kIEXgwItoIvZ9J5FZKs8lNspHvqVgQF0M1gzsBsMFSdUpvBVq58K3hajdyzUDEyKXrDCbF7FINjKXmlk6FvIsgIPinrS735ht7eLDEJcMOetAbJ2+qOHZy9+tRJpM25Qyf8oYW+RxBlUcAHHOuuHj8B4BqMbcoSDEkxaqapPuyUJdJ3HWUvmUu/1xxDLp4rg7JBvMbfAVNim17qTmfCj6oiQ2/M3noCohgZlR0uBv3ONqGpLVWI6euE+cBP4bKBhs27lOrFnktVoQyiTm4r5uqT2D+62cHiXOA7uldO6/MII0knXSTjyre02PHt3CcdBxDe1Eg+wyJnmWLEUuHrqnbELEcQLxUvfDJvyls70Jt27SQwN1RmgEp7x+ePpCFdox4ZaTcP9DVnis5sEo6pZfWiy6b8EGWgLXzY5szW6kdsC/onHakpVDEWrJ3aQTLUqp8g6kAefFcynrdFU0WwI2/KMIPH8poN1Mz7x97Oc+3ZC/7ddd3MmzeC9cvqfCuPlSnbxHRUdQetOaLc2gUnfUni8T2dr2pBHrB/40RSqRXtSkot7WxLwUn0jSvvq9+o0LmfYkJUaHX2MT6kwNJAhFRN4AFu0vVfjOxchqhPvVx7pTVlb+xZvmrQU9WpWNijcdepcH5MPyRKMYGm47/jxvpIRKkybObc/YmXRMxDrFq2+eUM2pxsCBz7Exd8O/0q9ASPgVOx6eip0BsR1Zfl3eIsSpWTcO/8f+RJFfjkQ6jrSmY4cqwsbADiTvaTj6n9r/az/x5kOhHJJC0qG5Pyo/j9pJyYn6vkoIK16KA5HHVk7roVecFdOy8YeFYVSZb5FJn7r5sONcL+V81+sBPJMG2S8YFuu0yaC0Dld949o9KpXTkVMSo7APuccg/K1i+d6sKknT11
 76p5M/Cl
 IIxUEYA6CgYaTAA0SQ465WNfH0ly6V2WY5KbbFSb3aeP53xk3MvEXZA/3g6rkwWWZ2Xf+Dx2rywYY85kUSkXR8A2N697fUtvkaoN82LeQ9fMpiiWlr4U9jAVFf/pD3IMMSPbeRYMs5j/hana9L4hIsNeKG7Rs2rsG+IPnqZtr4FMvJKYb0juLSnXkbxB8N8s+l9eOlmEVP/29JCpWiTXuULSIM641HZYx+c7TjkuufXiIlkH2Ny3ChBb6SgYPLySfr46L1fCaLE72xSXdb1KF0MD/qlNIQQS3bUFaaCT9j1xDLp6TsbH94aqJEYJwkQchzBr99x4uB8o4moM5m4l8cbYAFJ/mPLsajqXk9C4mXJmzB63KFL2QmRbC8X1BBnt2t/yuqLxazUPreBggUqjMX/sxqJWTVzmokiG8xIoSu1muY3LdmR5k8dAO+iwMTBBzyaDv0VgM40v933Lk7HHJPWJR0Vpsd5pbeO5bEk1gPHOak61NYy7NgcLtzOWJvvmys4iwM+223cVD5XcRAqMXh+Hrr58+svg8SHzovaAS35no5/QrTj+QMPtNgodtjeGLmRNdLyneJ6iUOQhGIzTiO8g4oOxvcCi7ZCr68UEFTH5rbjSz0lPg2mTh2mrXT1cYZ+VF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
I/O PFN remap mmap action to map the BAR.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/misc/bcm-vk/bcm_vk_dev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_dev.c b/drivers/misc/bcm-vk/bcm_vk_dev.c
index 88ee3a417616..25a2b46ebad9 100644
--- a/drivers/misc/bcm-vk/bcm_vk_dev.c
+++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
@@ -1201,9 +1201,9 @@ static long bcm_vk_reset(struct bcm_vk *vk, struct vk_reset __user *arg)
 	return ret;
 }
 
-static int bcm_vk_mmap(struct file *file, struct vm_area_struct *vma)
+static int bcm_vk_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct bcm_vk_ctx *ctx = file->private_data;
+	struct bcm_vk_ctx *ctx = desc->file->private_data;
 	struct bcm_vk *vk = container_of(ctx->miscdev, struct bcm_vk, miscdev);
 	unsigned long pg_size;
 
@@ -1212,16 +1212,16 @@ static int bcm_vk_mmap(struct file *file, struct vm_area_struct *vma)
 
 	pg_size = ((pci_resource_len(vk->pdev, VK_MMAPABLE_BAR) - 1)
 		    >> PAGE_SHIFT) + 1;
-	if (vma->vm_pgoff + vma_pages(vma) > pg_size)
+	if (desc->pgoff + vma_desc_pages(desc) > pg_size)
 		return -EINVAL;
 
-	vma->vm_pgoff += (pci_resource_start(vk->pdev, VK_MMAPABLE_BAR)
-			  >> PAGE_SHIFT);
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	desc->pgoff += (pci_resource_start(vk->pdev, VK_MMAPABLE_BAR)
+			>> PAGE_SHIFT);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+
+	mmap_action_ioremap_full(desc, desc->pgoff);
 
-	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-				  vma->vm_end - vma->vm_start,
-				  vma->vm_page_prot);
+	return 0;
 }
 
 static long bcm_vk_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -1262,7 +1262,7 @@ static const struct file_operations bcm_vk_fops = {
 	.write = bcm_vk_write,
 	.poll = bcm_vk_poll,
 	.release = bcm_vk_release,
-	.mmap = bcm_vk_mmap,
+	.mmap_prepare = bcm_vk_mmap_prepare,
 	.unlocked_ioctl = bcm_vk_ioctl,
 };
 

-- 
2.56.1


