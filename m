Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC38460A6F6B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vw2xmPmJ
Received: by kanga.kvack.org (Postfix)
	id DDAD86B071B; Tue, 24 Nov 2026 09:06:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2BD6B071D; Tue, 24 Nov 2026 09:06:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1BB6B071E; Tue, 24 Nov 2026 09:06:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1AA16B071B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:06:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17DCCC0BDA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:06:04 +0000 (UTC)
X-FDA: 85470186648.24.DABAADD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 47CB540012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:06:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vw2xmPmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529162;
	b=kB9Wcm/7zT1tM5HLKj9AOXHC+WoqlCMKYBL3IZpek/UAIAOv6O/otsrBWze4mcG2ujVT/U
	2xFDSurDDROcyCLiDYc3ftvgoZnc6rRwMLup6pjEj2w++z5JFkoGmm0rpy+Yqgd6XL93+u
	xhdMKZGByiDKO1jbiv8vNCEgYWn9OeE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xz3JZynnSnHv9nbaBuLzugbnS2n4YlzDZoTaQ5Jmb3s=;
	b=B+PEXZ93snGYCXrt5RdVXEPs+tCJXkguoy9VFnMdQDnmxcLQuLzPcgRoNIZNmJ7pcgYde7
	dliZ2CInQvaR1aZsshkSPXjRn3aXy5JF/vLInV9Hg6vBlTuN1A/BuFYGm3ndUalaESsYId
	p9aGTiByzwvpJXZxAvMoBSC5EgWly7U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vw2xmPmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8E3B6269F;
	Tue, 24 Nov 2026 14:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D1A1F000F4;
	Tue, 24 Nov 2026 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529161;
	bh=Xz3JZynnSnHv9nbaBuLzugbnS2n4YlzDZoTaQ5Jmb3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Vw2xmPmJQCeYDCDMmY/gA4vXIgOcUqZ7mdGwQ4g6z3pnvvJhKlcivb9Ce4f0sbnTQ
	 /LndZy836pXWzpMoLqWeZGs9kmkzTgLXcgsncJe3Sgpdznr0vgXQzStws0T7CrNols
	 q1XAlcfii8MGbZg3YqL/5zFgRywif4itMirDlCfnjGE2g4m0/iyeR05TfxYIiqC5a0
	 DDMZDCaGN/By4BuHe6Z1IASCC5aG309wloC7i0Ca5r1ONw5oczFjrDjXSQ494eMMg3
	 FjIOXo8c8eDXjpcMCmzTzhJlUYc04w8gDefCsx1HPg1GPPPk2po0LDn546RnUDJ7Pr
	 ImjOyb0Tb2I+Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:53 +0000
Subject: [PATCH v2 10/13] tee: convert shm mmap hook to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-10-0b0d99d655f9@kernel.org>
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
 linux-mm@kvack.org, Jens Wiklander <jens.wiklander@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1749; i=ljs@kernel.org;
 h=from:subject:message-id; bh=L1Gu/KToKofd3UZS/FEjh2Yr3KNqQvPetiiaaibWgBg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ0r4Zx46snTdPtHW8+tnNGfPK/BmSd/qfVBuc/PZ5
 DC+i1MbO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRh4sZ/hfVtRWlirr57Fnf
 uvle5BG7nX7vJj9r2fnnlqD/A2Ph1jyG/2n68j8PLpb/+vLeF/GV5Zc8dn8rttT49MeoOuz91Xe
 swswA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 34wq6npi3cieifkicgydtn8gpuh7ywmn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47CB540012
X-Rspam-User:
X-HE-Tag: 1795529162-587392
X-HE-Meta: U2FsdGVkX1/Nz+BBODxfPwiX96A7UUgOv12yyQimEUTj+IsjDRqjyWM0zUGnywwol3dMvhlXk4oDd5vqxObIliIqg5w3RWsI+KVcgfb5xfVKZfMdoZwfgXLRS9FFuHVrhXVXPvkKi7VKecHvmBM9nfSx3KyjVh3RUx50rzvHdFeKzxSZSGPXRGI2RE/6MgtfBo6uNImcOhcwkOHY8hpNBcMXJDTrjSnrJJ+ref6c/03KbtRDWWCUmUm2dlZSOEcvuehpvRIwiLfx6S21aExrLKNa7vUZm26dotrVSG4yUjfrcEb+kdS2w7oj5HAmfHKXz7b7m7roGJn/+15wFe/2wRLy6Bsn6UAb8O4Y3+BIolneVgeFlcHKoquVx1vRFE21zeRgC4L3KPZeaCcZuT5Ge3yA2fI4/avTTDUGUMzh00k+nzaVP0W48e8DPWxGIZLUOg9KHtJv8fUCJgZ9yuY4unnk1eEKZM1+/oCaZ7C7KsTSxPpoKWAVjxj9prWCkLfBTBGfIXeSvjYngCTOfP4PjRlj3bULhxL6jfJlWgVrUgn/1LQaRjLtf+s5EsJm12U3bCjBSfuBVeP3e5vnyAbnJVx0YsbnsCy0jFIxAiK8ddpNs9BOrA7AQeJHyHZKbXa+M3aPz4sJ7QNNJLmkV3TcxlPjw4sZOkvBNs8ica7uii31slQ67ntBfqpdo5Je/ERITj6yqVev0VqGo1/eDQbYKR9PU7T2EQIcxIU4wekU/5HgqoPsNfm517ic4mjpyPDWfiKqL5Gyg0yPKnvZgY5x7QjDH07YdYahQHRr4iKblGeVKa3C3DQ0MrTFsthmqxVKasSD2npUuXcyI8O1Gwu94qhRnUrK+gbjw5pprpU9aAE/7XJVDb9itL646hDtGpI7GpRrgd3iUlvfrN91l+kKMmFkrrbqOvEfF8n1Trc/mSn5xh9AUkN1SanGRGjYcSBL6jHB+lG4jhucZRQ86Qg
 DCvSuxKb
 VchKGxBtRohkvm1wI8LFXb8hPx/5Pc6FQGbThpzURrt5rsqgRbwMI74y8EN+EBQiwwtfWzUIDJIeKqU1PJ6R/8e7J0XtvfIRHbJ+0cRZfEFPB95XoOlo2B7Ce8pc4ccslu4ddiWfaAiiKHBoXWOdbHI8nJG8zWOx9RtUbn966/bTwh93x8NoBtzVlOjZa8XpRiTrudE4dJU66tRucivEpB1ubItrSCBXpc9VpQSdt0bJpuYVO0SY9mxyL5qVfw9cx/1C9zJDJQHXxStwv0emUUb2cSiSPGF2a0Fnfyt8y80UKALMDLuNy9FO+WJN4GmDm37WlqQhHGjr4EkKXv+5xLyanxlbvzFm/9HaGFT2HSMMKT9lLFTPDc2iQa4Qa5TQ7e8R+lzHB6GufmmVort8S8/JKUtujCElWVrkvDn9ncVYzobd4/zSjAoal7XfAXtC6EUDvhZf6gLNUQHofdmLRyfsyZTBXQGzXoC4e3InSB8Xsc9ZFR/cBk/Dj8k+viHWYGXX8AIRNdG7JABkoBe7BLNSyXSe7hBlqfHbBGxGmjOl4eOCzN8GYBaTRhFYidWR2dwBU+4mm3iU1fXJpPfaBQFJODSjEa78peazVefwcI4efOHJQd6O7ecLfhaxzyjy8+PYqBtzc57RpsJ9FxV/ekhi3mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
PFN remap mmap action to map the shared memory.

Reviewed-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/tee/tee_shm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index daa4af1e089e..8fcbf0232aeb 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -567,10 +567,9 @@ static int tee_shm_fop_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
+static int tee_shm_fop_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct tee_shm *shm = filp->private_data;
-	size_t size = vma->vm_end - vma->vm_start;
+	struct tee_shm *shm = desc->file->private_data;
 
 	/* Refuse sharing shared memory provided by application */
 	if (shm->flags & TEE_SHM_USER_MAPPED)
@@ -580,17 +579,18 @@ static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	/* check for overflowing the buffer's size */
-	if (vma->vm_pgoff + vma_pages(vma) > shm->size >> PAGE_SHIFT)
+	if (desc->pgoff + vma_desc_pages(desc) > shm->size >> PAGE_SHIFT)
 		return -EINVAL;
 
-	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
-			       size, vma->vm_page_prot);
+	mmap_action_remap_full(desc, shm->paddr >> PAGE_SHIFT);
+
+	return 0;
 }
 
 static const struct file_operations tee_shm_fops = {
 	.owner = THIS_MODULE,
 	.release = tee_shm_fop_release,
-	.mmap = tee_shm_fop_mmap,
+	.mmap_prepare = tee_shm_fop_mmap_prepare,
 };
 
 /**

-- 
2.56.1


