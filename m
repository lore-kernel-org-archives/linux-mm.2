Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7049606A688
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lgnIva9K
Received: by kanga.kvack.org (Postfix)
	id D12736B06E8; Tue, 24 Nov 2026 09:03:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9DC6B070B; Tue, 24 Nov 2026 09:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C008A6B070C; Tue, 24 Nov 2026 09:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82DA76B06E8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:03:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D34921C33DE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:03:39 +0000 (UTC)
X-FDA: 85470180558.09.0B257B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 08F63C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:03:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lgnIva9K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529018;
	b=racCvDwXWM9LQFV77mfPlRnRUrgBWipKEXli+SYyk0LiL0q5NMBPVAyeS/GXnwLkj/tB96
	LE9c9mthy9pOzedzmnSWyUPZE4YnRix4uLs6lMSVtAbZ/K1gGX3AhdYTGJ+oL8HYwAi52b
	/Rrtj1q6DOtWAL5zugrsR48ih9dzZfw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEgT8LA0rRCf6QNXkIxcU8G4AwB3CCCB3Sy/g9Ov95E=;
	b=I97hzAS89L3Sk5lIrnJZffjibDqWunCKOs/RyEDJsKDXCMo3Q7vrj6jZioI4CJvZsW7daT
	viP1ypnKTKJYDpH3U8mAjUMzq3tJVIilJDQ7exCLyUVwnG33QeCt6QUCCD+Yg0Rona8/1V
	9LW7+g7yKpOPT7x6q6V8XFOLvYdWnWw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lgnIva9K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C35645ADA;
	Tue, 24 Nov 2026 14:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC9E1F000D2;
	Tue, 24 Nov 2026 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529017;
	bh=QEgT8LA0rRCf6QNXkIxcU8G4AwB3CCCB3Sy/g9Ov95E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lgnIva9KLMkUPJObpQOKYtz3otyVdfSMFpdn1jQwIpMlk520FFqMXVbw/h5rCk5aM
	 ZcATjbGD+6/HreWcTYCyu4RHpZTCUrX6vOFINRYB7hegedAzZv3N3ozJ5fa11z9eaM
	 gXXQWOhj64Q7pR47HsOyK6FGHG0uHoSfwTM6XiHuVS7myaCNjsnAuuXHUj/wq9U3p2
	 lQW5/BHNg2s211IbQIjkhHQHG7z2O6su3Yfa2ykLBzNZFs2cu9h189uUCdMinPY7Ev
	 uwAcxEkv+7zGOnE/QurKfUrnjuQWC6+1VYW3BugMR6VXffjfIIPgcP/WlsULN+XnOo
	 BLi/c3ZTzPxGw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:44 +0000
Subject: [PATCH v2 01/13] xen/privcmd: convert mmap hook to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1514; i=ljs@kernel.org;
 h=from:subject:message-id; bh=vbEx7oZObK1/uvpt+gmlwGGN8AqsAvHpQ+6B/bIbWLc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4p9KnSRk7EO3//5aBbT8vkXtm3ydLgmlDTdz4Xh/
 51DR51rO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR/xmMDDNFecLfebbckfi4
 vE7/m/LcK2sOZZ1nm8rxbKGpph2foA/Df18VkyVbq9Zv5zmv/2rbIZaiJdcOXiqa8Xh3xbur6dX
 d2awA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 08F63C0009
X-Stat-Signature: im161q3fez8fre9qtkfz991o4qeadbo6
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795529017-76570
X-HE-Meta: U2FsdGVkX192acw24Ji/hGPFHnQf1T+I2B01osE2/qTg1S0/rYnUjM3XlzbFVnPlm0zBsOP17xjgDR/OsX3DP1iea+F+K90Q9yROfE7BVEKivJWbvG9Ay98qexCc4M+AD2bq1ncKglBWDbx370nkE2XXO0JaejzXnM0GttSe8WjsKd4U/if3dqJP2q0vgjHtOwiF+9UTWk5zwEF/Ae0x0rwPEPfhXrXpN/kyOhKMDAl/wgdtVkEALP9Mg0jqLSeH8rP5wIUBUiQo3b4de+X9AGZ1QOhNfObBGGZh1cBzBSBH/m2kys75nOZ7Gpdut97qs1cGxTx+qPa5MSH+Z3sijBDtRja8R/7JiAUT4Olz2MDbp5/DRI7mauqa1Yui8e6yM2BmasbAIB9znSxg8esqIlc7ZfABfQIsN6FZ9WBcSYExX99RzGv/ZH4kSA2JXpdHxcWMAFQ7shf3fWANBZvpiU6PwaZ/v/6rH6SK2U0dmHoACxSKMwGtOSHMc9JS23vt+zd2VnStqm9fEGvt0nZ4CTjyiSC6y2nIiWS9Xuxcq5+UL39zMu2k32JhPz3uIk4netq3YfVfj3CLrAO6KSfLb3+FnEqkAHogImRrijfHoxuHBF4QRv9zQtjKjEltCGrXi08+37ZA/eI6jTGaBqMrSDBnNF9+m9c4VuI+JM+Xx3fvQ1yi13t5QjZKJWTcMyuagQ0LljTP8/Z7DHjZOi8N1DBbM8E23Lu3V3mDcBlMYoa3da76WLdkQzm7UnFsmp/Uyx3yKaZIYC7Ck/zP5Ijn3GliLS9+Wncy9B0Sj9W7ZcgM/Odwei3zSVQbyf7AP7Ag2mf13HBvIWsL7C/3bda2SfdYWjXYB+/ftSls6MZEZ1eCOpAHRM5AVGgH98TbtCmvXYkydGNwwUvl1/vGmXZn5RuszTQMwlteNK7y1IAajsqejPH9l65/aZ5SevP4iLcK9UVhNheE7sFUiSnjFh4
 rOi0nmSA
 yYtUWOgoIN4pqMIglpw1saT5/t7mDeEs7OOu3qvD8dFlX5ItLVGo9pQrlcgpbyZgy0lcUwRBqEXVdAAezpwKIc2J9rvEORdkNtTVeXxv6g2W/9IQ4eJmu+fkC8XaFCBxpmpC3mYvyFoeWYZNUPp9gmXPPabx4nwvM0f1HNyF1DMvVGK7/PAxhsCJujohSbnNR38I1DOH19l6VA4iQIOBCoJ0eE4g1o+gmhTK4S0/rMB5JMSfDIvy60QrU2xyVaicQb9lD2/DzBnW439Kt14CgEyUZ92TFOIEG1D55w0C1jSbsEU2sLmRWGkK/KWOl2Vw0LlIZh0oXtzCRfYjMh50vbIcnNLd41m6jlN8Pyzbig1WgHeXHmRG4IFrltFoGuM7Q0Zj72fZ7Y5O0TNraGkqwexSnqzi+KLLLpTCH1QY0FY2R9tyhwKypyV/qAaetj5Jwtx7ovy0Gzcp1fVArFj3ybYBhfLTYZn2Om3JoZ2Xe/EtxW+/K8sv5GDCOA5T/TzrWiIyJK2ih8LqQt1fU0U5uAWzrabxUKjdaz1+WXfAZE3gbZppJvL3stNddm/aOEJ8wj0rgkh0/taqGw9HC3sI4n/almHddCg6G+QkgZPndx8iCprKFXGs7RJfbUEwUwlsaXpgF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook.

The hook only sets VMA flags and operations. The VMA private data is
already NULL at this point, so we no longer explicitly clear it.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/xen/privcmd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 221b31611343..6d9e1fe03337 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1645,14 +1645,13 @@ static const struct vm_operations_struct privcmd_vm_ops = {
 	.fault = privcmd_fault
 };
 
-static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
+static int privcmd_mmap_prepare(struct vm_area_desc *desc)
 {
 	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
 	 * how to recreate these mappings */
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTCOPY |
-			 VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &privcmd_vm_ops;
-	vma->vm_private_data = NULL;
+	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTCOPY_BIT,
+			   VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->vm_ops = &privcmd_vm_ops;
 
 	return 0;
 }
@@ -1681,7 +1680,7 @@ const struct file_operations xen_privcmd_fops = {
 	.unlocked_ioctl = privcmd_ioctl,
 	.open = privcmd_open,
 	.release = privcmd_release,
-	.mmap = privcmd_mmap,
+	.mmap_prepare = privcmd_mmap_prepare,
 };
 EXPORT_SYMBOL_GPL(xen_privcmd_fops);
 

-- 
2.56.1


