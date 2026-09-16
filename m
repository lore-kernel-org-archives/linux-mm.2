Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D61C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51CA6B00AF; Wed, 16 Sep 2026 08:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3C96B00B0; Wed, 16 Sep 2026 08:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75C46B00B1; Wed, 16 Sep 2026 08:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 948A56B00AF
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03487C0719
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:28 +0000 (UTC)
X-FDA: 85219490538.16.8916C58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34060120011
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahSvR4zm;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CjaWpeoftE+Wn2hDoCKbw50T/OskJjYcBztwhRMRzs=;
	b=gPjkN6fbgFdwojX44PJcK3LLJp1MWQkeveWlRVoR/DA6sZFeBxR1/DwY3JS8Fc9Q361TRY
	HIc7X6nsdoW4PN4gAe2tKskkVrPqHYxn2nLcI5TupO9+SjFtmiPSyYwZUeH21F+9WKYXkX
	A8H6j8JNQbfd6zLhBzJ0Ir9CvfFUFGY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahSvR4zm;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560207;
	b=loEoEPbV9qoKnTz7Qi55fqn5rEAQzs/rhM2UA9U1+BOtCbDI/YowFNN/ux/a8rvRkeDVvg
	G4TdYRQ3kKmYMMCvlnIiu9UMaNBu4gaXrcO7Cew4JiNAEL/ayPOqLo8EHW3TFEaCfKiDGm
	mBEhgxcFzPdk70LPgps/bKKfzeQ82Bk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F19A43BCC;
	Wed, 16 Sep 2026 12:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FF41F00899;
	Wed, 16 Sep 2026 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560206;
	bh=/CjaWpeoftE+Wn2hDoCKbw50T/OskJjYcBztwhRMRzs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ahSvR4zmrj7MlMn11+aRMD7jMFHhkqn7OicU0oNfie1ohykF4eMiO/GZbA1eg+IiL
	 gQb1me0lzuUfrSY8Ogl3inoXdAtcNgVH2IHfLrCZ2srfIR/tv7hwD2tPhMXuDFiojD
	 KckhvxKtPszP5sKUZeWMntOw11BxZBhIMWgOt7pyrzupodB6cHiqdgWFKH+VMesBAM
	 k++X0VduwxKPhrEpGl90pK1/vYk3Ea32IOj1sjAp5VdIpYk7Q9ECwKsGDMa/7wYRv4
	 e2uaINP294bJ5aj9C+pCaOHXyVESvZ1ZmEyCWCzHw3Nwd++SdfHu3bQcbnmMrk+bHx
	 tka3wEO888xVg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:10 +0300
Subject: [PATCH v3 03/13] s390/chsc_sch: Use kzalloc() for CHSC requests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-3-39e4894637d6@kernel.org>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 34060120011
X-Stat-Signature: zikeygzcm9qzfgmousxcbydn3xit3wmk
X-Rspam-User: 
X-HE-Tag: 1789560207-585678
X-HE-Meta: U2FsdGVkX18gdqUmv7CqiUQBrxNG66Ss6SziYJSz/lVvTFIt0j2Xyoi7tOkDZvxsOgx6gxiO5qh5Tjj+s+cWtNnLM6HjjYqF0i53MKBlcfykRZrQAjOoz3ylFTmmCHHCdTRTqkSOc+qb0s85mK2NtBscDiCx9zQFb/+Oqq/7MgQtyib+wMDav8yoHV9ht3SGaL6p7sHbL4u2Kw9HkdErzLTJYde8cAQV52wafwPbSL5mN/DwQ/IaLOwTxUptZlAOkak+CiVQOIVQ3HGnqJpo0WbVE+Grl7CQNWxHs98xwe2KCIs5/+qtz9/mXD5DCwdDHSjk/N4Ie4K3mSeaw0vmlh4wbC4dS52vOh8feLg7+qwSr+LLosBCybahUaosSHqis5kNV7rlZN3587UqSjwF+D+OxlWAoPwLouVJFO4qQifEQRtyCYynMl440qScbdWsmoPBg/sal+8igK5L06ZdtC+MTCzaMqXsE1aprI5bYc7ZcHhw8w0lk6aW/d/ZFJSGL9I3xZp3vtjeJQzF3XT5Buf3IQXJ/DFosZYK+MgExZjAlj3KyEr1GczHtmx2l1aR4yWHqYUmTUpb+5GlGrlH2X2KQKIItK51yeG2IYzCK0DNBEcmqsvsxoEwVxyWK1dQQZYFC+dLBzb5a+jNJ1pgrP36T/dg28CS/6ZJ+/7yOO6H8swW80InpJeMKWz8rldcRWoWvCRS6ODdpwkoERxhKn8r75jaTISBHvd4n1P/LBJb1fbfOT23p5cC5wPF08mO5u1iBf62n48m+pIHqZduxHm6upDTpRkdsOsYr3gaGDSTxd/N1xocVtKWThd5I2+qTo8z2qSTi6k3iIAw9AxhB82xcA8XjVWk6ZRAQ4vjKj3pjUDhUXpD0lY0menV3YM8BYyjnBXFYFmS7VmSesYsBR9d9i2ESYh/eyIiiJKt1dgI7rY4WkULat07xCE7RJfvoo1qbCuCZwflfVV3JxI
 6EcymfQR
 /WFgEEiDTjpXotUVKbj2ifgMTbrHKAlX2ax3QRKt6Mdcc3MOwvPY5sEIYsb1RaGC8m+zPn0PMuUoHlnc9asZxWBfKNOwIluobO0e7OgRDW3JPpYKLXP9IdkEgybbFH9EBOGmME44uL/ObtWJVireZZ2lPc7T6YuECULg1C4qLIbQPYycnm8t+nVnAHUCwbFyUEQUIhUrKDVJ3EUHZoAdxZ2N2vFJI0zbQMGXsvLkTWejpop6vUUrYxcQKqKJwtl3cxeQIdY3e9hVrQYJwmRlwj3AZ74ZLhppH4yrDaKUYnfwvcEnVuQOai6KZUKwYRt8sZVud
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CHSC ioctl handlers allocate request and response areas for
CHSC commands issued on behalf of userspace.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc_sch.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index b6cb8bb8bcc4b..c8d6871d1841e 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -292,7 +292,7 @@ static int chsc_ioctl_start(void __user *user_area)
 	if (!css_general_characteristics.dynio)
 		/* It makes no sense to try. */
 		return -EOPNOTSUPP;
-	chsc_area = (void *)get_zeroed_page(GFP_DMA | GFP_KERNEL);
+	chsc_area = kzalloc(PAGE_SIZE, GFP_DMA | GFP_KERNEL);
 	if (!chsc_area)
 		return -ENOMEM;
 	request = kzalloc_obj(*request);
@@ -321,7 +321,7 @@ static int chsc_ioctl_start(void __user *user_area)
 	snprintf(dbf, sizeof(dbf), "ret:%d", ret);
 	CHSC_LOG(0, dbf);
 	kfree(request);
-	free_page((unsigned long)chsc_area);
+	kfree(chsc_area);
 	return ret;
 }
 
@@ -340,7 +340,7 @@ static int chsc_ioctl_on_close_set(void __user *user_area)
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
-	on_close_chsc_area = (void *)get_zeroed_page(GFP_DMA | GFP_KERNEL);
+	on_close_chsc_area = kzalloc(PAGE_SIZE, GFP_DMA | GFP_KERNEL);
 	if (!on_close_chsc_area) {
 		ret = -ENOMEM;
 		goto out_free_request;
@@ -353,7 +353,7 @@ static int chsc_ioctl_on_close_set(void __user *user_area)
 	goto out_unlock;
 
 out_free_chsc:
-	free_page((unsigned long)on_close_chsc_area);
+	kfree(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 out_free_request:
 	kfree(on_close_request);
@@ -375,7 +375,7 @@ static int chsc_ioctl_on_close_remove(void)
 		ret = -ENOENT;
 		goto out_unlock;
 	}
-	free_page((unsigned long)on_close_chsc_area);
+	kfree(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 	kfree(on_close_request);
 	on_close_request = NULL;
@@ -392,7 +392,7 @@ static int chsc_ioctl_start_sync(void __user *user_area)
 	struct chsc_sync_area *chsc_area;
 	int ret, ccode;
 
-	chsc_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	chsc_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!chsc_area)
 		return -ENOMEM;
 	if (copy_from_user(chsc_area, user_area, PAGE_SIZE)) {
@@ -414,7 +414,7 @@ static int chsc_ioctl_start_sync(void __user *user_area)
 	else
 		ret = 0;
 out_free:
-	free_page((unsigned long)chsc_area);
+	kfree(chsc_area);
 	return ret;
 }
 
@@ -438,7 +438,7 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scpcd_area;
 
-	scpcd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	scpcd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scpcd_area)
 		return -ENOMEM;
 	cd = kzalloc_obj(*cd);
@@ -476,7 +476,7 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 		ret = 0;
 out_free:
 	kfree(cd);
-	free_page((unsigned long)scpcd_area);
+	kfree(scpcd_area);
 	return ret;
 }
 
@@ -500,7 +500,7 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scucd_area;
 
-	scucd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	scucd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scucd_area)
 		return -ENOMEM;
 	cd = kzalloc_obj(*cd);
@@ -538,7 +538,7 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 		ret = 0;
 out_free:
 	kfree(cd);
-	free_page((unsigned long)scucd_area);
+	kfree(scucd_area);
 	return ret;
 }
 
@@ -563,7 +563,7 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sscud_area;
 
-	sscud_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sscud_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sscud_area)
 		return -ENOMEM;
 	cud = kzalloc_obj(*cud);
@@ -602,7 +602,7 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 		ret = 0;
 out_free:
 	kfree(cud);
-	free_page((unsigned long)sscud_area);
+	kfree(sscud_area);
 	return ret;
 }
 
@@ -625,7 +625,7 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sci_area;
 
-	sci_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sci_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sci_area)
 		return -ENOMEM;
 	ci = kzalloc_obj(*ci);
@@ -662,7 +662,7 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 		ret = 0;
 out_free:
 	kfree(ci);
-	free_page((unsigned long)sci_area);
+	kfree(sci_area);
 	return ret;
 }
 
@@ -696,7 +696,7 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		u32 res;
 	} __attribute__ ((packed)) *cssids_parm;
 
-	sccl_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccl_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccl_area)
 		return -ENOMEM;
 	ccl = kzalloc_obj(*ccl);
@@ -745,7 +745,7 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		ret = 0;
 out_free:
 	kfree(ccl);
-	free_page((unsigned long)sccl_area);
+	kfree(sccl_area);
 	return ret;
 }
 
@@ -756,7 +756,7 @@ static int chsc_ioctl_chpd(void __user *user_chpd)
 	int ret;
 
 	chpd = kzalloc_obj(*chpd);
-	scpd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	scpd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scpd_area || !chpd) {
 		ret = -ENOMEM;
 		goto out_free;
@@ -775,7 +775,7 @@ static int chsc_ioctl_chpd(void __user *user_chpd)
 		ret = -EFAULT;
 out_free:
 	kfree(chpd);
-	free_page((unsigned long)scpd_area);
+	kfree(scpd_area);
 	return ret;
 }
 
@@ -796,7 +796,7 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 		u8 data[PAGE_SIZE - 36];
 	} __attribute__ ((packed)) *sdcal_area;
 
-	sdcal_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sdcal_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sdcal_area)
 		return -ENOMEM;
 	dcal = kzalloc_obj(*dcal);
@@ -834,7 +834,7 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 		ret = 0;
 out_free:
 	kfree(dcal);
-	free_page((unsigned long)sdcal_area);
+	kfree(sdcal_area);
 	return ret;
 }
 
@@ -904,7 +904,7 @@ static int chsc_release(struct inode *inode, struct file *filp)
 	}
 	snprintf(dbf, sizeof(dbf), "relret:%d", ret);
 	CHSC_LOG(0, dbf);
-	free_page((unsigned long)on_close_chsc_area);
+	kfree(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 	kfree(on_close_request);
 	on_close_request = NULL;

-- 
2.53.0


