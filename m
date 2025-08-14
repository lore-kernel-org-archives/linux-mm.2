Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45729CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35D89000F7; Thu, 14 Aug 2025 02:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E55A900088; Thu, 14 Aug 2025 02:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC2D9000F7; Thu, 14 Aug 2025 02:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D67D900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:48:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FAF61DD819
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:48:03 +0000 (UTC)
X-FDA: 83774433246.22.F40067D
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4DC92A0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:48:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X6uriVjb;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755154081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8U9qCHhrJhIaN9YgK8JZU+6qrUbPYoXJVCAPiBgbC8=;
	b=aCxBHmTsQRHcZowpZvFwW2h3VbMckgg4WaEGKpyZ3pRIy+H+NUo6+ExlsHuHa73IRLVRna
	8nRgAtS/NxrtVrvsSnDO46Gk2k45GsHwcf6XwQi15FaDwFmkcN3WaE0hWmh+P+y01Ba/Kf
	YoYdvjxAiKNlcVPJtFQhMqAZ2Gl8DaY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X6uriVjb;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755154081; a=rsa-sha256;
	cv=none;
	b=1HMXoosVsMJaM84KuEsdUQLBavLjpZTu5uaWV/oH1EoyU2XrCKHbmvITJ1NC9co3BgYuks
	rOfs6aA+tFl2qTniWI0V7jEA8A3ReKMBi9r1cyLA9477v0ARfy84JeJarA2c6+yE1rgJIA
	sRNGwN6A4ECDc7Ug7BbOpcclHhV8+ig=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b471740e488so633840a12.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154080; x=1755758880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8U9qCHhrJhIaN9YgK8JZU+6qrUbPYoXJVCAPiBgbC8=;
        b=X6uriVjbNvHnX+S/rqrFRJ455zpprlWKff5y4ykoGrQus+9ySbY8wx7nllbd1HuBwO
         oyb65lgxP8Y8ej67T5YtF2SNBnSK+vQYcAfYWTgz6G+qboEsDloZjHEAzgLTVHhEFjaQ
         azeugQ2L6f9sMWVIkR3z2sc2McsXimVTOqsoQd/R9wgPChyJfQFjyoOKCQAMZme4XeVH
         gSL1nHkCrXtGdIRo9H2Ghd+vdTz1ZMc/GryOLfax0+mELdoXxDEyM/HgFzG61DRGomqd
         zKnogpayVff+nFWi3xO6LQSTaYKKf80H1DUHP+LbvCELfSekMv+8y/ibgm/gXWxtdf1E
         IXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154080; x=1755758880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O8U9qCHhrJhIaN9YgK8JZU+6qrUbPYoXJVCAPiBgbC8=;
        b=NcvtNUttG3Y6ZgJ/GuHCxp/wOHI+q85cfkJ08WJm8ugD1pcXPOITMPH9i0xgzNA2zx
         2hvm9Y1IqdgEBUWC6KAmgxBqv2tBiPMAFAuNXOWY34EcREWtoTtCM12EI8BJRoHIKLYH
         9tHWkM5R/fCsPce1CIcWucYmFpuL61MfXxbPp22vHefpkPUB0YYLDylYw6w2KAaTt/Qr
         OYombzYrFl0kIkIGxwfwpy/b2FgtWN/SIgtcligt66IIGQzGWKCppoxZHzKBzY8GoJfH
         d0IGaquYpQW4z9UwLldOpoKei85MwPjFRD0kMTlLcKMXszj5IJ5rUwOKlruIc/FzzbNu
         xOWA==
X-Forwarded-Encrypted: i=1; AJvYcCWIj+PfqGxQEJ8EGMmgUBzuACgBIGhnXZqA4S52drSMnle+th8ag1OUbFdyVHih86mStpz2fovIRQ==@kvack.org
X-Gm-Message-State: AOJu0YwQ+oYq5UAF2BKEvSEVanmgqlMAhPXdgfxaFd9pERAhRbU/15aQ
	NDqua2aR7lLGTLqPF7nnP15khOfPJ95lKWJJ8nSlHNPSNizwgDQFGfYQ0LU2JSjazSA=
X-Gm-Gg: ASbGncsYNg94ZpX3sLA9uEEmeaoAAStcFzEVo6ifhFWwO7QXX8f9CTfKGf3uBUo+w+U
	mR7umlHJnD3Y2z72/u4Rl4nMd6a37J061fplhKm9PG9/pfyCmhR9Nn4Wq71sLQ8MN+8sruDcR6G
	fv8JsuL/s43eDYO5amofnWBsIQ7iEEJjXpqN1pveV2ZH8OMll9M1NnmpYbWSuu2nle145c/Ffo4
	gaNPs2khECcUSy9dUC/v9Nl+l1jStYwC2I9Nf0FAOhh3hD8Eq00YpmiDBKM/toyZ+VwrT+TYfu7
	RMu8PSWRSa0/7bzK1lJSpdCOiLpmJuYECSHFI2yUzWt30Ex18odHN2Zu6u/1eiciarG3pr3TnYg
	X44hlgClknzK9WgjBQ/qiTXdT4pdwuDO5lUsjeUE9Z2+95oAlSTuW5aCvdcCP
X-Google-Smtp-Source: AGHT+IH8fEM06ZvKhW2tHNMx4HCm1V4KHJ9G5sskVwcxUnvZdDTuwB+WAVO8lbZmBThC3Oe5fZtcYQ==
X-Received: by 2002:a17:902:d505:b0:242:cf0b:66cd with SMTP id d9443c01a7336-244586bf675mr28557835ad.34.1755154080047;
        Wed, 13 Aug 2025 23:48:00 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.47.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:47:59 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com
Subject: [PATCH v5 3/5] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Thu, 14 Aug 2025 14:47:12 +0800
Message-ID: <20250814064714.56485-4-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4DC92A0002
X-Rspam-User: 
X-Stat-Signature: 644hkd1ee11knop1hoy9q1y8pe5ys731
X-Rspamd-Server: rspam09
X-HE-Tag: 1755154081-333557
X-HE-Meta: U2FsdGVkX19EH8gi9VJb+7bckZcv79VOkkiPghCg0oj8Pmlxrn7rrUyuvTm7U3idOT5v4Ow2zpIIHxT/hx2/LsyL3iEIoWsgPi4QfiSpXgKs0zNZpqtb6XIBQF7EtVDxeapVGGT40K9WyIqhmhKsjutxSSJ7WVU4JHfdNUPAqcMmJ4GGPmAumJ3IrA5EC10voFiIRsTsMkLxhmPkReqMZCdAmVquIDWlD0Uw9wPC/tDR7qTgufap7DfUCNcU59R8H5RW10piXMVT9qG3TQql10KFSXwWHWcHk4aWVSUeJYipnQoJ9T4IYDKmb0OR+hBZHDQHiPknLzxhnEskQOJdETHjCA8H2cP5WMC+QcZsLT7SAcCeyq6ZeV564sO1RjsPGCTHfyMWTOmY8Kg1oJGMqW8DUiZRL7H6nFR97AWDfFxPUdkpS0+/eUWI8qxlmjCLN7/54cJq+pxohr0FcnVge9y3UL3bBkRR/2N4ZiM8zHsh+ETXw7FeV9F21jHiD9ejnAEWlbQzuT5ci/luEWRrTClMQ3ZvBmMrUWDc/dcXiD+c3KmWClOosk191hviMIB8EAovbnZqx+2TEamoJg1irjg3JYrwqZhB5QsFwbiI/ykjYY6irbCyJaAjdubKBaS7XUFYa0MJZh9G7kMUMh329/cTN5Y7NMVhVRZeyA/KTg543Fmd5n3Bay9NM9LeD5qtYIy4fjJd1I3TbAsJEoxx/3DVmDWKSif62upXSEQMmLjiUD62Fz1VHtvb67oRSTJpCjlvp/aJ1jPmhejhPVJQ8CD9p+gajc1fOPrJEBBEUcgenJI4vuHp8K0n61rJD/3zWE85JItRGYHXirLrRB77CksfZOuC5lofoLmnvZ2i05Z8t0JMiZ//zPAr5Cmlazi1qrkjoY5fhH2KyX8O9l7v68R38+uWI7oyr4Jhq2FX9Hm2334LksRUS9JuIqjqQygkNg2ZQIV8LZMxukUJRSj
 axPKpSU/
 Tv06vw+A6LH99pLBG04c/txETWcwScsov/adHdZR/3QOlyrgAG8T0nAMuJDWedqOUNRUY5NntYp6EoeQp9xtf2AYSVOswRjB9M3WsvQn5OGM5ffRi2eCB8iw1pHTXqK3J6tBXhzLN0+PhnR/qM1RPX4M06cjdU6BYeP6S09Au7um4R27kM0BdYKYIEdcBUk/b4VcRYOzk1L8FkTkbnNgnEBoKO8gJ9gbar9mL8F+dBUzL6lixzKa5vEs5zZ1rH7wudnAvdTfoBVG1sZq82u3zSOg/CTC7PhMRGRPOcBCp3NQqygMToDT8ovMxEvGlxpWKc7ruflsI33KUsAWrMHNyGfEAICi8zVjyAGYW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

The function vpfn_pages() can help us determine the number of vpfn
nodes on the vpfn rb tree within a specified range. This allows us
to avoid searching for each vpfn individually in the function
vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
calls in function vfio_unpin_pages_remote().

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 7829b5e268c2..dbacd852efae 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -802,16 +802,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
-	long unlocked = 0, locked = 0;
+	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
 	long i;
 
-	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		if (put_pfn(pfn++, dma->prot)) {
+	for (i = 0; i < npage; i++)
+		if (put_pfn(pfn++, dma->prot))
 			unlocked++;
-			if (vfio_find_vpfn(dma, iova))
-				locked++;
-		}
-	}
 
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
-- 
2.20.1


