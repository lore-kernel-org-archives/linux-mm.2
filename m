Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDFC60A5BDD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R1t75HIV
Received: by kanga.kvack.org (Postfix)
	id 837F36B0721; Tue, 24 Nov 2026 09:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812506B0723; Tue, 24 Nov 2026 09:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725F36B0724; Tue, 24 Nov 2026 09:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0446B0721
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:06:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C62A21C46B6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:06:51 +0000 (UTC)
X-FDA: 85470188622.03.3D7F3D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC1DA10000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:06:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R1t75HIV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529210;
	b=6S3RCQjec5VFKucFu0HKJlnL7/TIqN8iwkghGl9XkPgAqaE8ZyNWUs+1UG/EFV9wJPWWM/
	Cb+TVteB0ADAKTSk4uVdvOd/cVbdOTGR65elvEAj8dQ78ZTREp5LQtqcXQMIb5BlUMqcpU
	wEs0AGLBzxNJw97Ukal6eMrThJzict4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ome7MtfDmJxUwg0IIJcuaL9s3WvpoOw/F+488/56/Hk=;
	b=z7ZZpTZWGsyWCFF8nfN1UZXBkzH4NK0/RzviHFegqwAajVWozzl4zH2PHI8rBUjyIUiwOZ
	srsH1Lk2WEq7GZ3974kkBgHn5mHwxK215jkyBa/fcE/u7W6VHdxu/yzQIPmKGEto/zdme8
	gvfQbwjzsdYvW+TFPiEeVPzmKzWFUh0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R1t75HIV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A6BE4485A;
	Tue, 24 Nov 2026 14:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4731F00AD3;
	Tue, 24 Nov 2026 14:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529208;
	bh=ome7MtfDmJxUwg0IIJcuaL9s3WvpoOw/F+488/56/Hk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R1t75HIVUgGwed4MxVH03XMPsKv2JqX+GHESlBjGLx+mFrupW37TcwLtpW/IA6nyy
	 /GFmTHsaPp9jqeignnTYbg8XAcb71Zl5d/p+/LAhAPYbtvE2tXJtRSJM+KmOhA23xo
	 b+0f+BFZK7TG8t5hljheItWqdjAzmcymj4aeA0igJZQkzHalY4cmxSLLwwaJ+kOvbF
	 nAwp7tHpgVZ6SjGdt2vXASSIAfiPlHOInPOc+nSrJhCgTdzUl6o2H9Fj4JbZnGQWfo
	 SbOpJ4PyEg3keLzdMV05PlznAg+UhjGJw7KHRudCO04Qr3OYwNZ7lVIq8rdOofismK
	 Vd3gRU0Moj2oA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:56 +0000
Subject: [PATCH v2 13/13] vhost-vdpa: convert mmap hook to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-13-0b0d99d655f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2537; i=ljs@kernel.org;
 h=from:subject:message-id; bh=N+qzvarBReEV4cRJsAvEDjekSINy/joij8VQmMMnGpQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ0o8vLegK9dikmDZFhbDbGFDrSavY3cUZiWJFNvpx
 5wXv8/SUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgInEJzMy/PW8eWna9yvXPQW+
 +SxatMug7PudZW2LD+n8j3n/ocB19StGhukFquFZRov1Eu9xR6lFvWh5yOKQHaIvv8GK//TBGYm
 lPAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 69ncfxnfcrid491u6fkse75kkh4eyxcz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC1DA10000C
X-Rspam-User:
X-HE-Tag: 1795529209-779090
X-HE-Meta: U2FsdGVkX197N1g9g7qiDSPbUnyas28aCJO0nBS5yN2HkUvQe1Il6XF6uX7ML5y7KN07W9XydOOuIhrYpzY/oPzwCf3HxbwX2C8HzasFW31UZz6X7lrP3gYuLQVe+JV+Xx1hjyyr/4NZLMpKi5NHQdggejiPODbcVHdjt45shb8MmsgUq6hTVFIp+n/GMOBFmAtUE79JGd/2WK2VOyhBFemMrpfIFAQ4D0JjLqZJ4VcvOrF9XcHygyVpEzanQI7/Xqwv54WtZIOGxh+ED+e6lT2U1DCbmQVPUteSj/E83JwE7e9vB/9si/uBlYRQenHlNVW5NAyTRGcUvCfaAXIk5Hul03DgljNsPenldEwzwe3fHG0ThlZaQF60KbDOriuw5pJ61/3O0hJFT2WlfWoHG3X+fmoJ1K2mRN2m6m+rWd3qmlV0ps1QyM5lOyDw0VONP1tnumdRf8FA1k6YL6ue6QZkcIwzhQplDwUrBgQhuSwDd+pR1vhAIURhrZhY0CuWr/vBarq9Kiykl1A9cJCMx2wSRMBmfTsEVjIagE9/bMn0s9yI3yoLhypGFj+yau7q+DwQvfwavr3mWTrX4TfxfHV/y9xcf9/CdHYUjkBKQCHSK2TWNQPMqhCw9utPMPf1hxZ6rfdh6hjk/nMhKzxhZ8JZW1S/fNc2PrrAYGmzf4G3HsOW//YoXW5LDbm1+KW1cYBAhPIwNH5zz0L+TOhjIDt61Tn/Gshuse8aAE2+M51e9SX9qpI7Dr4X0RFvxxSz7IJ82qtqzSkCAiTceAy1rNdzhu+kvsIBv81rbmYOoDLg9o2GFED1wj2mqergryngrOg2KsxNsAyEPT2L3A0hOZT69q0ywi1/P2rVThajbjA3IuPYVJy2wWFM40mpJcmKvVC1wdEtPUB4tMQqEG9IGwJxCFl36YnaZrIveIOa6Kxms+93rEcmsCuktcnYUe+uQP0KxHu/AOf9ELQ+lng
 8lvgMwwj
 VezI4QwsFKOIRyFAEsYjruf5A3/b2Zd5BRS2VE4dY5KzCavBKbdmebu5h0BUKYIVhqCqArhORrReio+9XMKDPaVTT9IKzlPaNb5bv3FA1cpQJ5X7xLzd+OU7WQashKj8iJ4rrnI4jf47ip7VW4ZQTcRlO1IHgKeVJXjeqENg801G8T4xCY6DUBYHBVyLW81l7zYy5aMxM3jfdBCQDJOAts/oseVU9SnDVXHOPSKKftg0TV9eqAl7ql/wae6oHSkKA/I+o0ahyod05c/K2CW1w06JyKCw5eqIFuQGw0mronALjnZBSjNrDL6hOQLo1+1Byy5LrQjw80xgd275FAclmv2ZyYtZu1HzrEjwh7jupBa1baaWeh/J0kX3CEh8NtGdEFFihqKJozb0ZR82/lEpesY4cLvJTvl3NU0YeZ7f3gkQHJ5yRc74t0wPiefsRH3b/mR5nOn/Yml5xHiKv2rZybYNvtegbnEGRjStpXsdLOzpbd4K2GmAkR/ixQj+mf09zjMJ7rImIhjjXSPEkoKRhJgTb/Ft8kcdnLxRnYYZ0ougMbvG7dt5ffPOEOOfTnXnD7bHFH3ZlugDgocvTBrRlXCW8KKpJN6wLDAQNmukUMrZI/cbyQCXBRXJOXbQ/VrEhMMiX8a6CL7rQWTF2DrzhM3sh7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only validates the request and sets the VMA flags, operations and page
protection.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/vhost/vdpa.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index c912ac40ca37..c729efd108d0 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1617,19 +1617,19 @@ static const struct vm_operations_struct vhost_vdpa_vm_ops = {
 	.fault = vhost_vdpa_fault,
 };
 
-static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
+static int vhost_vdpa_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct vhost_vdpa *v = vma->vm_file->private_data;
+	struct vhost_vdpa *v = desc->file->private_data;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vdpa_notification_area notify;
-	unsigned long index = vma->vm_pgoff;
+	unsigned long index = desc->pgoff;
 
-	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+	if (vma_desc_size(desc) != PAGE_SIZE)
 		return -EINVAL;
-	if ((vma->vm_flags & VM_SHARED) == 0)
+	if (!vma_desc_test(desc, VMA_SHARED_BIT))
 		return -EINVAL;
-	if (vma->vm_flags & VM_READ)
+	if (vma_desc_test(desc, VMA_READ_BIT))
 		return -EINVAL;
 	if (!ops->get_vq_notification)
 		return -ENOTSUPP;
@@ -1642,12 +1642,13 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	if (notify.addr & (PAGE_SIZE - 1))
 		return -EINVAL;
-	if (vma->vm_end - vma->vm_start != notify.size)
+	if (vma_desc_size(desc) != notify.size)
 		return -ENOTSUPP;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &vhost_vdpa_vm_ops;
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
+			   VMA_DONTDUMP_BIT);
+	desc->vm_ops = &vhost_vdpa_vm_ops;
 	return 0;
 }
 #endif /* CONFIG_MMU */
@@ -1659,7 +1660,7 @@ static const struct file_operations vhost_vdpa_fops = {
 	.write_iter	= vhost_vdpa_chr_write_iter,
 	.unlocked_ioctl	= vhost_vdpa_unlocked_ioctl,
 #ifdef CONFIG_MMU
-	.mmap		= vhost_vdpa_mmap,
+	.mmap_prepare	= vhost_vdpa_mmap_prepare,
 #endif /* CONFIG_MMU */
 	.compat_ioctl	= compat_ptr_ioctl,
 };

-- 
2.56.1


