Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A432560A2615
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuHD+6BR
Received: by kanga.kvack.org (Postfix)
	id C2CCC6B071A; Tue, 24 Nov 2026 09:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04B16B071B; Tue, 24 Nov 2026 09:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1AE06B071C; Tue, 24 Nov 2026 09:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8536D6B071A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:05:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAF7E40C12
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:05:47 +0000 (UTC)
X-FDA: 85470185934.07.3E899CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 20DCA40006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:05:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AuHD+6BR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529146;
	b=EkIJHkGXo4b2aXTtrHv3PmsUIiUQOa7KrkWBo9YN3IcLVG/SD8Xt03ZfUIY3h4JiAtTUOq
	3Gj3u2ItJ8qvcFJ2DRateDBENe0M9UouxqNs++Yy+3e5UwAKfC3aDnbh6NQTzFXiNjzl9v
	z1T0PTcX4W0C4sIRiyRYHCuZnb2fE/U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uksaHS0GlZddATsY6wbLfDqHqk97x/nZ+jaBRDCZQ/A=;
	b=fvenOnQUvgUipjpP+8THee9mspNrjjhrcgiWvQZS2a2/IXfcckkZrenvZwazjS/Qym3kCb
	/1F1NQDr8BrwiDUyZnPj14obc9ZATi74Gg145nmKfwyuYKTVjsl0j7PNLJhfm0pkPo4Xhb
	4OLZmcLS0ziM12c5J5plBSX8PVg3Db4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AuHD+6BR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CEC362698;
	Tue, 24 Nov 2026 14:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0A61F000F2;
	Tue, 24 Nov 2026 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529145;
	bh=uksaHS0GlZddATsY6wbLfDqHqk97x/nZ+jaBRDCZQ/A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AuHD+6BR0p+tzbJtwXkbRnF/T5QMNcp4N21BAkRcm3sjw3jGE7tbUCGfDCp9F6q+q
	 DpUIZIWggVslEfQ1cEu3f5K7elBUsfF3scopZOFCPKD/ut84prhokoV/34yZgTHJXN
	 BM4qzuyr9olsnCnpws/QmSwbRaUSvPAvxMmL+uEhMg8B/DgAuwecYKaCR1kBd9a+/8
	 GVKPYclBN2skOxSIty5M8WZPwUJIcu9wl9PWbClnNeyrJlMLjSnTMxNguIhua/B14S
	 aq5WJv10Xdy7Gly+fuV9rRM9oAUHM5y7yMmoalbaYh7GI3SF5CLtkU2KZFzeVUbRJ/
	 jBBlTREL4w7aA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:52 +0000
Subject: [PATCH v2 09/13] soc: qcom: rmtfs_mem: convert mmap hook to
 mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-9-0b0d99d655f9@kernel.org>
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
 linux-mm@kvack.org, Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2093; i=ljs@kernel.org;
 h=from:subject:message-id; bh=zPmexgLBdITMLlr8Oq90Rfb+CcnKJfQXvrGy7I+reFc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4rvi3F99JyTz8dZn33x0kNt90x/m3p3xrq5rFnJq
 OreEsTbUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgImYX2FkuNvVdkr+VrjUgjkv
 4o6HiKdUP87Z+tX02vs1EXw799/lusHwi8lxQYCDaXWi6S4G3i8fejZUN36St96R15S0a4L2DDY
 fPgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 20DCA40006
X-Stat-Signature: zmsyj9hb5ts6wrhfuahxort6zm9kxwsc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795529145-31362
X-HE-Meta: U2FsdGVkX1/uLXDrUNyTTaD9k37BxqDlXF8WK2t/M5xu+RKriJ5BD/+sw2qP/ls08S1NAUnql5JEVxbSgAd1MSVtLU5rCra4wb/u81ry46/+Pqcj7i1ZrNcvo5DT3LlRz3TqNcHO6kdmDQ67/1Pfjv/CmYOF09M2LN7+LrQjpmL8Idynx9LWEBbMhhr83JolpNO3sPwL6YSnU+enu5lPr7cTeO+NPeSZuAj/fzI914oyjO3v6hAZSPGl1gOk7nBqlCx5dg1X0N0NP+C1SdCnJ4ziBqQodccBDOlLP9C9XhkczpAdvp4cZRQEXQb3YfjVqHOw/GRWaWWgYRqfYf7jPpcNW0K/vyli9w2rtiUZQQiL22kfP03NGX1SFfEbWYSCLTAHrb59Gp1HJJkjaoJZJ87Iq5bsPw+kivGZyAEnIBBDegOO7cSy/qajuxFogPA548azCdnSxs+IKjKHZfN3fejXWPmUCks0NNOKr50AfbARhn01HrD4zdRMN3Wbz4SC9oNx2sJa5+qWo7qzjcGS6y6UrmRbtuJfYz/qfNjBjiV6zvrgxlg1eOtj5iMy6JujJN4ejKPwxf+BlaoeewW2szTAuFJddhlXk/qRhgm4m5RXz0R8M0/poa93PtlYAa06kq52OPLin/47cXKE5rqOUONpNMOSDHgSny2kFJ3htsHmdxBh1T5JRlEQBns2Gqp0jW2h8skpkBmBGJHLSqcYhkaCn1Ak+yZIwuJUM2ApE/zyicOpXiPmme2AlqtTVRQo9LRO149GptwDjn6k+ptrePsPM3KgVSnq/QjYAvQ2uNGDMC4uxL7MyEpcmhUVrRK9VD1l+O9J/515i4F2e8K6l3oWvAzbjkWbrK1yI10cNgDVjtCPWzZh0RXC+rSm4o1ASquS1HhUM9aMVjr+lsRXNODz4poTjpKvfitBe54X0g9qqtgeyLYjrn37/0BE3d8TYqVSngLN6qOo4ZgYuV7
 bHtjMCPJ
 eL5jax3EuHf7X5T0z6zzlSUvrfObhc52Xu93uIkvzBjTYKar7LeLFIfXqMGo8WIwPsnP4Pif/pSMQL2MaP/fgGjWavr/aRYyxmWv2HOep1hA1RS72qD/q/4ddGi7LdWEhis09Z1a8e3UkVTNNqxTRkxgc67WnS5wxYkqFcJLPTB7/AzSb+720Gtw8OSpX1wU6eDztiPnKy3Cy2A/NqVKNEOkMB79HgoCeymIeHUMYOAstIN1GZ94MdZ0iojx+rSz/yangU7wKbtf4l9wsyKBUpyijAc5U1qWfuyV8ixrb6reBOIDX59MD2Iu2VLVcFPFZa46eZDVagsrY6HkdEch5Y+neZbAi5UBhA8HQ/8ELYUOIqFdpzQLkrOA77eA6pRUvyysydKFVAkqARjT7Bk8RIE4F0eAEBE0i1dk6UEx4erKlY5vnCabQFfSxXuoac8Ylsn6gMKdbdjCGJfz7JLs+JKWu95e6XfcYh598vC/HT8q9Y14dsqSr1Yd6oH2mtj1uwKETnTBOa857uEx1bw9ZwVQJhS4ARWx7vgWsN47mkYv4F5odaJ78hcVSlyU7tA3cHsDh6JEDDClHe78lOlvbf7qNCAcUUnpfyb7rPRatSLxZlic0lTlI2NsChJ2hWv9DamdamyoiixJ0k00kMbQgmIdQJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
PFN remap mmap action to map the region.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/soc/qcom/rmtfs_mem.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/soc/qcom/rmtfs_mem.c b/drivers/soc/qcom/rmtfs_mem.c
index 342c0845134e..5e2ac75f41d5 100644
--- a/drivers/soc/qcom/rmtfs_mem.c
+++ b/drivers/soc/qcom/rmtfs_mem.c
@@ -129,24 +129,22 @@ static const struct class rmtfs_class = {
 	.name           = "rmtfs",
 };
 
-static int qcom_rmtfs_mem_mmap(struct file *filep, struct vm_area_struct *vma)
+static int qcom_rmtfs_mem_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct qcom_rmtfs_mem *rmtfs_mem = filep->private_data;
+	struct qcom_rmtfs_mem *rmtfs_mem = desc->file->private_data;
 
-	if (vma->vm_end - vma->vm_start > rmtfs_mem->size) {
+	if (vma_desc_size(desc) > rmtfs_mem->size) {
 		dev_dbg(&rmtfs_mem->dev,
 			"vm_end[%lu] - vm_start[%lu] [%lu] > mem->size[%pa]\n",
-			vma->vm_end, vma->vm_start,
-			(vma->vm_end - vma->vm_start), &rmtfs_mem->size);
+			desc->end, desc->start, vma_desc_size(desc),
+			&rmtfs_mem->size);
 		return -EINVAL;
 	}
 
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	return remap_pfn_range(vma,
-			       vma->vm_start,
-			       rmtfs_mem->addr >> PAGE_SHIFT,
-			       vma->vm_end - vma->vm_start,
-			       vma->vm_page_prot);
+	desc->page_prot = pgprot_writecombine(desc->page_prot);
+	mmap_action_remap_full(desc, rmtfs_mem->addr >> PAGE_SHIFT);
+
+	return 0;
 }
 
 static const struct file_operations qcom_rmtfs_mem_fops = {
@@ -156,7 +154,7 @@ static const struct file_operations qcom_rmtfs_mem_fops = {
 	.write = qcom_rmtfs_mem_write,
 	.release = qcom_rmtfs_mem_release,
 	.llseek = default_llseek,
-	.mmap = qcom_rmtfs_mem_mmap,
+	.mmap_prepare = qcom_rmtfs_mem_mmap_prepare,
 };
 
 static void qcom_rmtfs_mem_release_device(struct device *dev)

-- 
2.56.1


