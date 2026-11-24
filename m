Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821B5606A693
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cDqI3wph
Received: by kanga.kvack.org (Postfix)
	id 6FCBD6B0607; Tue, 24 Nov 2026 09:05:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D42D6B0666; Tue, 24 Nov 2026 09:05:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB0F6B0648; Tue, 24 Nov 2026 09:05:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CBA26B0717
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:05:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 780911C46CC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:05:32 +0000 (UTC)
X-FDA: 85470185304.19.6F199BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 92F5E40011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:05:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cDqI3wph;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529130;
	b=Xnc59IogWnpPUxQGIG+F08bk3Isp5zpnYxsx1mIZNgKPjfFF7c+z1TCZYEeIBzhUAWi0p9
	CGCWE6TCWRNDdjKTVGKxQc5LJTdeOw2V3G8IxbZbMmeKotd3QcJdgDKWuUdsZ5EmodDsX3
	3dY+XoeyQErmQiNz/0S/aPQz1UIO6Mg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrYlGGY0gACro/+moR4ki8LLaruR+DRcq/Omm4chfzc=;
	b=wX4aA19D+3g+0Eux1QK4ypHZ/KFQ67MFtCKFWt9sesUA8zMYakqns8gFwoifqNRrPiUZSk
	Iti62FrleSS4XqKpLM3X9oGLdg7UoDF7YpjRsTHPVS21ZsbPO3YvdOzsbcZAG6mfudXGO/
	Gl7qzcWs2APeu5uuePGBdA0f+weYyQk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cDqI3wph;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9FF741B45;
	Tue, 24 Nov 2026 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83991F000EE;
	Tue, 24 Nov 2026 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529129;
	bh=SrYlGGY0gACro/+moR4ki8LLaruR+DRcq/Omm4chfzc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cDqI3wph5w7mSk7+SA/9MbSHsr7FMUNedC7vWKFhxrOIlpLi/Jg4MsG1xI0bxGAWy
	 qUiRaEAEH9wspwamO2MBPTiaLlH+o8/BVteTJUZpqSzXmShf0FdMFnZW3UEQJcz7qC
	 f0q+icWXYKtjYOrK50ZhDj/QKBpyCbqFkfEyHMExa5AY7OG1tFqiudHtdUMmkTRev9
	 aGc5oo1L+3PAwfFOjRq5w+19u+ENdztRn8Q+pxEcrA7oJco/+Rjiqm6mmh5CB+kEqL
	 sIffKObc49Vrs4vWH7Uf0X1GOMC5zvZdhqnNg0SOOT3TWCwu12uPxmZxl+e1i6P7ig
	 N7AdOF2UuX5WA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:51 +0000
Subject: [PATCH v2 08/13] soc: aspeed: convert LPC and P2A control mmap
 hooks to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-8-0b0d99d655f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4097; i=ljs@kernel.org;
 h=from:subject:message-id; bh=s32LdAaaGb1M+/iwl2Ev3ih3n8WWn5YLe6Ixr8jPsP8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4rzb1g8Sfr0brEfn7ZbKupLCrGYKk8Tb2y48VJl3
 jY9zdPzO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR19MY/hnu+fP5693M5Yyr
 ejU5//XJhc6sqJ6o9PpW5fE7dQeKBLMZGc4t57X/s8jJhD/YdFVqu/caTalFBt/OvYpdl9D1e27
 EOQYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 92F5E40011
X-Stat-Signature: ypu94p5gdpqnq9hej913k8yatt3qxw3h
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795529130-551523
X-HE-Meta: U2FsdGVkX1/wDrJ28jmJ++/Yi0phT+1AvV1iWZ5HNwUIyhVjQI9EhjUavmFh9Bl2sNZP+4mAvRYnSNC1EDT0Na3S13qJXR65bWgnTcpT0x19K0gYD6CVrADf5lpvNGwUGVfSWBaCXoiYex9rWr2FrFOMBSUmf3Hz/Srm09goC4zivsxTTniIhU57aKbIqbMHp0fmfib71qPYCchG6UjLW72c3ejCVQcuLSkJb2HfbbCP8lrGBgyVLAix0oL02jfD29+Vfg8q7cr6m4/fei3nKHL4P67eDaMg1fMR8ROSXY6ZwluWnMGPb8IAMVyMGtvJbmbNUnsPRPxGcBP2qVUuxjKZTYJU4Yg3eNqtBG+8baA894CsFxb6HDB+OVgyAWYwVvufqJK9ewjiKyN87rE+Upw1JTZKnZIFioYTmFNwd8P/Bu/40DJxrSBRdSiUAW6hXGg1iYENXUONkbxHTqFzxTiPHfo0izK2HPGU/emvAz+Di+ELimOHkESEP8f6YoMPMabHVDM6MG283MSsK6E/jLY2tgsQA3cT8LwtRUnXR2xDhfOoYLGlPyOxqzugiANwQAr6fwYTMaPRm9t6AQ4sPdatJOsXQKCdOURsb6rsyn/xqvxjtdyTHIjmU7lwVbjWvAxY3FW1qbOtlyHlac5k3j69w1KJ9sqB/1alkNJkXocvXZuDND4vd+BIfylBr5wujGrT04y94n1erdB6HSRwdqVOHcdi9FeHQfMoh8KVwQdcLUyNOP2++4YE3Gd/jh8GJ6gVVMtxVqlV+XIjS8BKIKDimKM0chi3ogXrSP311SwmEHCL1YtuYdbFy11oFvwVXxEnFRacJ/Ez3/7M6uzg3lYSESNZ4ug4bNcqlqrLPVqnowqnPp6w1OYPA6QXEGpPZR8qHQflvBZW3z+pENSMu8W/VM/cwedRo7VEKQ24sw6XlV4CUIX5zJbA+7J3Ihj19wXczhXBkiOmZKyv+V3
 PsYgtpbQ
 NTBOqKtr0cENCWPGA9M5JubtCvp3cpSX8p301aYytXlW0Jy+S/0LhuzjpnyGtAkarKKn3piGEEY3JZIGj0qOzl1jfbrd7RAh0Kx9wxSN5FISox/fP86fsq+Lk538d9beZxJWY5QaDR1Z22TKhGJlTI+iuwBzgXxLTFS/Wys35+pX8/8mAxT8oaPRSVgkNU6xD6x1ne2+BnZAMdP0phLQJLCaP0kdpE8MUCCGDro5wApvKAXftpL01N4KxAU60WriY014FVLWvXqieKVowK/Au+Dk1vsjvsAq+5Y45Fueb1BBCc7GggjWrzfGPaqMN2qoRwXJgFlpyZwJaVKQsXO+B0wxpl424v8Sm2kh09qKXE5+JjH9UHSLMJjGiI7co748LL8PtG6sjIuhUhRbKRrS1yMjajL+htFHuBwOSJYEc1yG9AboJ45d8hMHRx1k+lPFng0JVdE8UFTa3l5Qveh1RT+RGVvxoefxA/Vg9JBLYGE3uTK8/c6UA4Y6xtJbS1Q6WRNTrNsSE7M3GYcJPRzqFGWIfxI3r8tfFVvMkvICNnKbElPliZp82xSi4Bm3sYDyTajur8KueUPDLzgmFV8hg8tKWFyruOUsuCOnxRrHqXvnP0g0y0LVpk1CC+kBOsZrv6BHcwaKpbpwUa/QXhjF2Q+73++L8RELp+R6QH2O30cZLnbUFGNcauo8DV/jqwu0OOguM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook for both
the LPC control and P2A control drivers.

Both remap a range of their reserved memory region, so use the PFN remap
mmap action to do so, retaining the -EAGAIN error on failure via the action
error override.

Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-ctrl.c | 20 +++++++++-----------
 drivers/soc/aspeed/aspeed-p2a-ctrl.c | 22 ++++++++--------------
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-ctrl.c b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
index 5d91ba2038d5..702fb3e85472 100644
--- a/drivers/soc/aspeed/aspeed-lpc-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
@@ -47,22 +47,20 @@ static struct aspeed_lpc_ctrl *file_aspeed_lpc_ctrl(struct file *file)
 			miscdev);
 }
 
-static int aspeed_lpc_ctrl_mmap(struct file *file, struct vm_area_struct *vma)
+static int aspeed_lpc_ctrl_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct aspeed_lpc_ctrl *lpc_ctrl = file_aspeed_lpc_ctrl(file);
-	unsigned long vsize = vma->vm_end - vma->vm_start;
-	pgprot_t prot = vma->vm_page_prot;
+	struct aspeed_lpc_ctrl *lpc_ctrl = file_aspeed_lpc_ctrl(desc->file);
 
-	if (vma->vm_pgoff + vma_pages(vma) > lpc_ctrl->mem_size >> PAGE_SHIFT)
+	if (desc->pgoff + vma_desc_pages(desc) >
+	    lpc_ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
-	prot = pgprot_noncached(prot);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
 
-	if (remap_pfn_range(vma, vma->vm_start,
-		(lpc_ctrl->mem_base >> PAGE_SHIFT) + vma->vm_pgoff,
-		vsize, prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc,
+		(lpc_ctrl->mem_base >> PAGE_SHIFT) + desc->pgoff);
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
@@ -216,7 +214,7 @@ static long aspeed_lpc_ctrl_ioctl(struct file *file, unsigned int cmd,
 
 static const struct file_operations aspeed_lpc_ctrl_fops = {
 	.owner		= THIS_MODULE,
-	.mmap		= aspeed_lpc_ctrl_mmap,
+	.mmap_prepare	= aspeed_lpc_ctrl_mmap_prepare,
 	.unlocked_ioctl	= aspeed_lpc_ctrl_ioctl,
 };
 
diff --git a/drivers/soc/aspeed/aspeed-p2a-ctrl.c b/drivers/soc/aspeed/aspeed-p2a-ctrl.c
index efa106d37bd7..7387b0cd8666 100644
--- a/drivers/soc/aspeed/aspeed-p2a-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-p2a-ctrl.c
@@ -97,29 +97,23 @@ static void aspeed_p2a_disable_bridge(struct aspeed_p2a_ctrl *p2a_ctrl)
 	regmap_update_bits(p2a_ctrl->regmap, SCU180, SCU180_ENP2A, 0);
 }
 
-static int aspeed_p2a_mmap(struct file *file, struct vm_area_struct *vma)
+static int aspeed_p2a_mmap_prepare(struct vm_area_desc *desc)
 {
-	unsigned long vsize;
-	pgprot_t prot;
-	struct aspeed_p2a_user *priv = file->private_data;
+	struct aspeed_p2a_user *priv = desc->file->private_data;
 	struct aspeed_p2a_ctrl *ctrl = priv->parent;
 
 	if (ctrl->mem_base == 0 && ctrl->mem_size == 0)
 		return -EINVAL;
 
-	vsize = vma->vm_end - vma->vm_start;
-	prot = vma->vm_page_prot;
-
-	if (vma->vm_pgoff + vma_pages(vma) > ctrl->mem_size >> PAGE_SHIFT)
+	if (desc->pgoff + vma_desc_pages(desc) > ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
-	prot = pgprot_noncached(prot);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
 
-	if (remap_pfn_range(vma, vma->vm_start,
-		(ctrl->mem_base >> PAGE_SHIFT) + vma->vm_pgoff,
-		vsize, prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc,
+		(ctrl->mem_base >> PAGE_SHIFT) + desc->pgoff);
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
@@ -308,7 +302,7 @@ static int aspeed_p2a_release(struct inode *inode, struct file *file)
 
 static const struct file_operations aspeed_p2a_ctrl_fops = {
 	.owner = THIS_MODULE,
-	.mmap = aspeed_p2a_mmap,
+	.mmap_prepare = aspeed_p2a_mmap_prepare,
 	.unlocked_ioctl = aspeed_p2a_ioctl,
 	.open = aspeed_p2a_open,
 	.release = aspeed_p2a_release,

-- 
2.56.1


