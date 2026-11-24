Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE43560A3816
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iHtmG7Cj
Received: by kanga.kvack.org (Postfix)
	id AC9FD6B070B; Tue, 24 Nov 2026 09:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0C16B070D; Tue, 24 Nov 2026 09:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7806B070E; Tue, 24 Nov 2026 09:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72E696B070B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:03:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE224160B6C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:03:55 +0000 (UTC)
X-FDA: 85470181230.25.4565403
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3079C40010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:03:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHtmG7Cj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529034;
	b=ARWGHh3t1nUhdSiSUU6SrcuzLZKnZpx2CFjlpDaLMJ8YMzFppojA4v6NF5SUSA79SfJFEU
	7L+0CNaeNsMlnVrOY7Qbfwdzx0liIOLSim4gIYnhUV1LxGXf+nAgxEmbKoUNNmSXG2KF6v
	6mWAisjZdm7soYdmq4Ozn0Evoz9NmRg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJUBuFI/X4ybR5TQJo0mpuZGpnhQ+Y28O/2YwIAeUl0=;
	b=bIN/OnzuPJQWjpBKMqjPAt9Bm2Cm994vcXGsJd84mv0Agt1ONXdM10Ej3+77GDn/XbalmT
	jViVOo+UhrSe/ZiznV/geh4jpFrARA1INtEs64gIQ8ppt8NEnAFKZxWNLZ87BdYIOJ3CT/
	o9sOkIXMkgQI8hK64mV9iMQeXA3mB6U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHtmG7Cj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6127601D9;
	Tue, 24 Nov 2026 14:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388EC1F00AE3;
	Tue, 24 Nov 2026 14:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529033;
	bh=vJUBuFI/X4ybR5TQJo0mpuZGpnhQ+Y28O/2YwIAeUl0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iHtmG7CjTvXPz3lA7PVVVfcohJ6emKtmjQ2NVdO2YLbIRwOCJfD95zg5jaPopSYaS
	 gj5YZqmFSdMCB9FUDQv5kkAhrEJtfG0JXoItpXFghN79meSem8VIAhQgIUFZSzsgAY
	 r4LSrjk7SnXCqTh4BUkrSrsjPXB067ziolwbz+SPR2Ltp0YGJdQcNB/fTa+3srse0H
	 /GlPyBuULOvYPhH5W1j1efHQ11GpECImbgYnAOTpdtXBpeseeeo4Fqv9cOfTrOTpvy
	 kwrbQFsHkQGnl4n4jy0umpUo8SNKV+PrXpeTfoo5qbg7WgAkB1/06qMvPYru+IuxNi
	 f+p2tfqpbV87w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:45 +0000
Subject: [PATCH v2 02/13] KVM: PPC: Book3S: convert spapr TCE mmap hook to
 mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-2-0b0d99d655f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1158; i=ljs@kernel.org;
 h=from:subject:message-id; bh=gtiaF6eQ5l4kQG69nvAkqE3NZUUEizPFbGQry23tGvI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4oFbmu5VXls3dYr8f7eMuEO344nPNsfMWXNVf7Dq
 qZ7i657dpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiU0IYGTbVO6rNXJEyv+mV
 +9vcNeFPj7t/YJz3RnHNZ8l9hdoHV+1h+O8ze3Ji1SVFpXAe612GQm+U5O/yPeIyeLxitpextfz
 t+xwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: gbkuwyfxy45ynxeyhfengyquye1t7bss
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3079C40010
X-Rspamd-Server: rspam03
X-HE-Tag: 1795529034-38089
X-HE-Meta: U2FsdGVkX18A5jIFfUKC07Tll29IVm8iyVVO28OHw30zbzRDRtzOnLF39xkjPU1Qr1F8JpxVKD2gjcyOVNnVCOBnO3eTBX3aEemfmJjZwZj6w3za8njt5HxD8R5c6P1D2qqZymrLUbJ0ZuY0Ftcl+IcOX7Gm7YWyVilh724CHqPqCRhgrDfN3y/FF0R+IiDY99YB5Amej18SC1ZxNiBMvfy+YZxAEYjZTOVtTDYzY6lM/nXkvQeqct2f6L44nWZI06f7ujSEMELtUd0eTu0wasw2fyjX93x2Z2bkRsTrCbCzYF6Q+bNc0rj+qh0Sc3y8/BZTyouaWamFwmvWuRV+/CCEOiKYODczKvP2nKdEZSKckaBcrfohL15uXVPszpi7q2H/P3KSiYDwMBSOXxURLiDgh+44VB2ohkca4pKAiZhEflnm0+xAAbi6N6Y0Q93YdOabiC/1VzXGcWHZBCtdM3s4zNPvhuQQpycGGIEXmu9wgrsAUdTFn+qir5+RhnwVNKFdcN13uVx88DJ4HF2Zn1oT6J4enb2n6oIu5TPUyxMdZZnUbJpbjRrYNq8ntFmeeOnaKoQJ/2etKmsZQorkPcBB6WsNNSbcOCus4k48IjxOXHKDvC7CeSLDMrCyNZsQ8gtiYPimFPqpAWngg9StqhfDGwM7IucAVI7cGiVlbsjR1WJz43GomAWXVyxXUUhPFW0BqhIzM/UensNL8PFzd1dlyN0cqpJra3rC0d/SqwGc8ZOLDgLk82NsA+qFNKg0pxa9+789vHOS2FRGNAL05bsI/KfdGm9HIPvgs7o/vCQvtSgUNSafQhuUPCoEK13uiEXE+7QKQm921K/n5oXPGI6KGNVb6YSGc57qZGHdH74Uhrti5vMnnN1o11MjnIo7IU9xK+GSzZOwJv0t79co25tWEmAJQDcJ1BxlIjXIbQAv1Q+Sv0KJXFG0CD/UJ5qFw94o/DAgSIXYyPZEFyT
 DXoMheOE
 fyE/5oGZIWhoVqT/HER7vzKB/gYTvBuTEzvCxCzte6jVUi/t1NKwNM0nmIvq4ePzw0cRfcQL+qqpMO2bxbzrCp9KTvy0mIUurm0RhL+8zWlXL3v0QoW9zs4z6dbSYGRCu3sC7LzqT1FMcCB9mXjtQfm3ks4nCfuHfg1boe2pF3rwe9XMuInpMe/pOIEimuXmlLFGhGaNh/YmlOq0yZ0w5X9DylbruqZW5O0q97aHjA7ysrb/5S2MSHytwL0tBUC6tdPq/S23dGYz0uwjUUuct0EVK+TGqrwj5aBHxTbXCLd1sH0ZajUAD3E3Kb7EINtjViDPCI1q8YHyYMpboPxWerGcbEH6RaHCJBmB1AeTF3zq1c1/VLCWRfY+IkFzqTioQ5TZjdMvcQw+5GLG5mWGTMkrbjs/AQ8q8wCXCusHCmAB7VWnaWxZOmNZq9NHhz664ENsmAsmfjvKcEgNiWZsxRCG0oQV//y0R/rgKKfNfE14cf/lEfFJ2wMyoLdRRM6ax3ViRwthyyF/gNdQow+6CaPHcoxJxhSeANA7iOZw6yH4zIVrjQp3wBwdomjCAE97v0AVuRgSglDk/vwI6rvcYg4BDTRs83fzaIY3+f+Xj2W/k4vET7ZeRC85Etx657Krb3opu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only sets the VMA operations.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index c5f3f5b29d89..05f6f2c9a432 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -247,9 +247,9 @@ static const struct vm_operations_struct kvm_spapr_tce_vm_ops = {
 	.fault = kvm_spapr_tce_fault,
 };
 
-static int kvm_spapr_tce_mmap(struct file *file, struct vm_area_struct *vma)
+static int kvm_spapr_tce_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma->vm_ops = &kvm_spapr_tce_vm_ops;
+	desc->vm_ops = &kvm_spapr_tce_vm_ops;
 	return 0;
 }
 
@@ -282,7 +282,7 @@ static int kvm_spapr_tce_release(struct inode *inode, struct file *filp)
 }
 
 static const struct file_operations kvm_spapr_tce_fops = {
-	.mmap           = kvm_spapr_tce_mmap,
+	.mmap_prepare	= kvm_spapr_tce_mmap_prepare,
 	.release	= kvm_spapr_tce_release,
 };
 

-- 
2.56.1


