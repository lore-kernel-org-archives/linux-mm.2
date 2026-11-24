Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65592606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nEQsEOVv
Received: by kanga.kvack.org (Postfix)
	id 8AA136B0715; Tue, 24 Nov 2026 09:05:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8818A6B0717; Tue, 24 Nov 2026 09:05:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797876B0718; Tue, 24 Nov 2026 09:05:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54DB56B0715
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:05:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAE301A0BAC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:05:16 +0000 (UTC)
X-FDA: 85470184632.18.22BDEE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9BB82C0014
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:05:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nEQsEOVv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529114;
	b=BbxeC9yzNOK915WwN+CxT27x5de2kbcJvRpFwjey4sEY5S1qWKyRCqlvQq/CKfw+wRXu76
	F+enFfEnzTDSMgzQrGh2RbVp0Gz3ZppJkBnbt3p70l70hPFCNmdFDi3t+tyvAbfD0psZAa
	UP4WGLtpq2aU7V6k911S3WW01vUpg+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hW7ZGPoql/0vjAt5ga+sKkmm9W80eGku2aKEtGV2c8w=;
	b=327V4IpyL2B1c0hm+/ByTBS+qskLb0/TCbjF0mCWTVBqmlkbVnGs/B9cxivtsXSmAt1cHH
	dondqOXAL8mfD0z3rJAZBvAymm5zdO87f5G3FCzJPDyMW/tbQdC1TaBnADVd2znhmhEozu
	2zTJT1Dn2hDqpgL8VaS4AxoP1nvNIEM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nEQsEOVv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3310435D0;
	Tue, 24 Nov 2026 14:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8BA1F000EE;
	Tue, 24 Nov 2026 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529113;
	bh=hW7ZGPoql/0vjAt5ga+sKkmm9W80eGku2aKEtGV2c8w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nEQsEOVvPg9uZs8lPh3fAj1Qo39UVf8WJg/6I4WGhW8GIIKBie2GuD5DK/hWJLD7N
	 XXFbsjJmFJ4zdg+ZeAGS56aohbKj0o8RcUk9oJKGqRdvPA1dlzGKwJgzce04YTfDoE
	 kQMX4Kt1jvbJUHGy+3IdAW2GpTkIMJJi2M8m1j0s/6gqGZd3guFcFTSNOxrS31I3la
	 KAii9xzYdmifvwQhJIoDqn1DIYWc1NWrZ02MGPgXDMQbsER2kNVx51Lo6ZPJT0J2gp
	 lE7tqkcpAKoxp6VZEtLHwb1xz4xg8XIw89cIiw8bdorFELUoAEwIqVHFvq3itixg0I
	 yBzI/3vuVb+EA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:50 +0000
Subject: [PATCH v2 07/13] xen: convert xenstore interface mmap hooks to
 mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-7-0b0d99d655f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2905; i=ljs@kernel.org;
 h=from:subject:message-id; bh=zpA8p99yoYyAJavHN2hpgi/WaqiNX8jwA5osK7vUTPI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4rvLvioea3/4JPLzEeZbl3oWb0s/9PJC095PjVfV
 dpvcXbWh44SFgYxLgZZMUWW51/E9weJhM3rvODvBjOHlQlkCAMXpwBMZBMrw/fUYytbLzaFN9Wt
 rU8JjT29a39kwz7OkrMbhI/s38wcfoaRYX/mMr77a2f5/t33Q2Wm5f1vJQLpU5PlHZd2C57NSnr
 eyAgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: os4sfuia1pepwqq5s9qgt3b4h7kxtkg4
X-Rspamd-Queue-Id: 9BB82C0014
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795529114-822181
X-HE-Meta: U2FsdGVkX1/EvmiWsWlWC+4/ASsx7cWZycByVIWL6SrvyNEy1jmolIm5CvdqwfxiDtuejgQnrGvrB0OI5m+srGBaY3G4bB/Ujj4ZUzL8nurmeMadT52DCbhw8Tprfjy3zy5yjIH4+1XsYFokeAX8iCWNMf8EGA9xnHw1l+vsL2IRIUh67EAmrmCE88s9eOICXHNrv006yLeeH+G5Gh1wGKJCxgvtAy57x9g3nxv97Mln266Iw7mZkbib/bvdGfHxG/aBBbp7sLUiHRwWiHfTFo0OuxIWij8ZOrJqfrK9yYwit6PozDwwdAUXph4GL/50LKzYd/fmIJzdcMJUpj1vMVQ+lPlGCMn7g03l/CsIkN4k2YUk8aenBkv4x2i0T/6WN2zpV4r/f2GnrFgX584WD+FnFPFtlPf1Rz94HTKarUhNUoRREXk+oUfl8t1L9naMAyJyaTaZoHjw0eZC0X93PJO03b/r3203D6XXp+YcV0xvZImGUyCgvg+39QhKDZuuUeCEM88IM6PIGk7F/ePa0EgLOGNfEPzDuuUHR7dM/71skSIpmLOsd5v9IFxaw3OJ5EsTxhso68Fu4Noo5XCFEYeFJ6R+d6bGOSI4kwxaIAHOYJXKO2Zhp2WemBT/047Jlr57l31lBGSbOlztMXSanKDjgE3TXKv/lS5k0ur7RWr73OlNaZ3UcNLbSuGmjy6DHGEy0XSQdgA8/l9+v0hOhRYqkqU97oq7IeutgJL3wuIkqYWMDX2MAOCBBAbJQDlGul9rEftIzdcvHplbSxi6Mcxtdi+bBDPpNsjgeo6n7gn7GbNHLsu9TSt4t1kxd+fFq3NRW4SOgQdwus15FvBWwuNxH/ktgh+IXcR+85udLN+CFHOjhtl/N0UJGLl80sUM/T6cFLBCzqXKM1ixKTfCtp9hpv+WnpqEntFrPbMZp2dFm+Jfdc5u4v6/QEQ30X0XZug8NoxlKGaBNej1+oe
 Pm6lrOgS
 +PjBnrs22zH0oyiRLUYetFBQ6S6jRJiwW5zxpm3e9NbPgV1aXIhi07StvZgv5uWRS75SLaTzUxHAGeM34gmzQBGL4FQuUUYhvtdG4+EYcIUxV5A2PY3aiD3nHmcQAyXtpZ1eK5t7YtMBeSdE8hvtkrTBYqChZ2bi/9ChzPtJABR+z1kx5J9pFQrjnFRMLIvq04mgHPRAI7iw05GG2Z5dcKnunAnhphq9Ra3U9b2DzmM886jw04kw6BFkejahABWi+FYfH9ARRsSGpaGVmyyMabmCs+ctDlEXpbToMvZpwTRhwrnFTSJOyO9E9vthRdgcmcVa7v+vcfZGbXcwlJ+y7qA0BZzdRACM/NBLSma+TL7K5DdoZbxVN/p2nQZSQGCuAGhaBkIdnPr9mgTj6wk/zCzwxZaok+xbFpQ73d+TZH5Cz9cUKWpiPXmT634JOspAZvyNhJmWK7mWmQIY9jPnFWE3uxaWKwmxzGS2Kh7JuHPLIZ3IezamYwZTAYNqzdB1u29OhymIV65KtxozdB5L9phwpsrk9HDJ+02M+X3TpvmZV02KbTkoY+tZ+LSyetzf/AhA7pZsbQrVb/Mvh8M2SAuUfzPqiY42gshSIgi3Oc28L2mGOSp0BWVQC909Gs45XZU0o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook for the
xenfs xsd_kva file and the xenbus_backend device, both of which remap the
xenstore interface page.

Use the PFN remap mmap action to do so, retaining the -EAGAIN error on
failure via the action error override.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/xen/xenbus/xenbus_dev_backend.c | 14 ++++++--------
 drivers/xen/xenfs/xenstored.c           | 14 ++++++--------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_dev_backend.c b/drivers/xen/xenbus/xenbus_dev_backend.c
index edba5fecde4d..3e4cb267f411 100644
--- a/drivers/xen/xenbus/xenbus_dev_backend.c
+++ b/drivers/xen/xenbus/xenbus_dev_backend.c
@@ -89,27 +89,25 @@ static long xenbus_backend_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int xenbus_backend_mmap(struct file *file, struct vm_area_struct *vma)
+static int xenbus_backend_mmap_prepare(struct vm_area_desc *desc)
 {
-	size_t size = vma->vm_end - vma->vm_start;
+	size_t size = vma_desc_size(desc);
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if ((size > PAGE_SIZE) || (vma->vm_pgoff != 0))
+	if ((size > PAGE_SIZE) || (desc->pgoff != 0))
 		return -EINVAL;
 
-	if (remap_pfn_range(vma, vma->vm_start,
-			    virt_to_pfn(xen_store_interface),
-			    size, vma->vm_page_prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc, virt_to_pfn(xen_store_interface));
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
 
 static const struct file_operations xenbus_backend_fops = {
 	.open = xenbus_backend_open,
-	.mmap = xenbus_backend_mmap,
+	.mmap_prepare = xenbus_backend_mmap_prepare,
 	.unlocked_ioctl = xenbus_backend_ioctl,
 };
 
diff --git a/drivers/xen/xenfs/xenstored.c b/drivers/xen/xenfs/xenstored.c
index f59235f9f8a2..0cf57c286adb 100644
--- a/drivers/xen/xenfs/xenstored.c
+++ b/drivers/xen/xenfs/xenstored.c
@@ -31,24 +31,22 @@ static int xsd_kva_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int xsd_kva_mmap(struct file *file, struct vm_area_struct *vma)
+static int xsd_kva_mmap_prepare(struct vm_area_desc *desc)
 {
-	size_t size = vma->vm_end - vma->vm_start;
+	size_t size = vma_desc_size(desc);
 
-	if ((size > PAGE_SIZE) || (vma->vm_pgoff != 0))
+	if ((size > PAGE_SIZE) || (desc->pgoff != 0))
 		return -EINVAL;
 
-	if (remap_pfn_range(vma, vma->vm_start,
-			    virt_to_pfn(xen_store_interface),
-			    size, vma->vm_page_prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc, virt_to_pfn(xen_store_interface));
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
 
 const struct file_operations xsd_kva_file_ops = {
 	.open = xsd_kva_open,
-	.mmap = xsd_kva_mmap,
+	.mmap_prepare = xsd_kva_mmap_prepare,
 	.read = xsd_read,
 	.release = xsd_release,
 };

-- 
2.56.1


