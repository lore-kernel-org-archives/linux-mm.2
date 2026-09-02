Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB77C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6556B00A4; Wed,  2 Sep 2026 03:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096BC6B00A5; Wed,  2 Sep 2026 03:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FD46B00A6; Wed,  2 Sep 2026 03:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C82E06B00A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:33:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5172C12072D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:33:46 +0000 (UTC)
X-FDA: 85168007652.13.DCCF714
Received: from mail-pz2-f9.google.com (mail-pz2-f9.google.com [74.125.228.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83A7F40003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:33:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UCuD7gxV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nb5Q2Se78rLq0fXFEmBN2MgTVK3UgvxyIXmhlVfKh+w=;
	b=vFjROzJjrI7DSTumJR103KFGsFS4vZ2RDcURj65HJ5Nl1/TpmvqzgNNNhsGQDXc/K51yAQ
	FquM0ZZfLNksiW4ObmGFlxy5m1K8BNVJWNY3YT/ivZrgU+N0kB+YC/0bF117/ClT0Ar52x
	QoZmXQdTnIHkTF46+rs3cZRsAN/TSaE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UCuD7gxV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334424;
	b=4W5npEk1ORS243P+W/6P8mGU8RnfSIORZVgRKNMlZYaOJRo4FpXQSMdrWgK3M7KisNjwbo
	fHFpDQBFIhDgM3O10j8+9aaHPRhbNPVIdd2XI9yJcnVJZpjAPcmQkn0R6yGGG/BH7QmL7D
	tqfc9HAZbdH2pFAWUDlCX01qB2xS7P0=
Received: by mail-pz2-f9.google.com with SMTP id 41be03b00d2f7-cc1cb94b583so255264a12.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334423; x=1788939223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nb5Q2Se78rLq0fXFEmBN2MgTVK3UgvxyIXmhlVfKh+w=;
        b=UCuD7gxVM2Dv5eNtksR7W4RWG8SxqiqoN/qKET7fbRDRz+skWKIjdVtFmz8DOdKRt/
         vO51Y4jltoaAH5gca/tV3SdnjKkkNlgSYxlYaCROEo2Q/efm0y/tYsKF73XmGl1p3qmN
         dI/0kVlO4uZxleaPtwu4u+0pC7R51Ngh9GWKqg+7DlD8By3ztwx6YEcsfvl7rWv/zQaZ
         XWRXik45VaHvalhtZibsRpOMnAPq1UaMKcBedSlUfv31aw4WYz2ophmz6AEu299eA/pY
         uZx2kUhipvKPWxPnpgjb/Ja1L5OjY1BcJPeLwpilh0rVIzohfy6ECAtMR/Frg06qFjlA
         /yGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334423; x=1788939223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nb5Q2Se78rLq0fXFEmBN2MgTVK3UgvxyIXmhlVfKh+w=;
        b=fjz5Na657BLUkPXA1HcWJXK6OAPByP6j2wqS36DDIuRYtPcf/WeFcHjH4dEhB18C2u
         vK/gjA9r9mAVLOXDqsSSvCMUxCAo2nFsLzALTCtOdvldewqypCUDElz9dBlAJOPKXW7V
         XBUg3bK04bL7joEEyPrhGed984v4bXAemlITZZp4J6a+YjEAsSHhrgGv8tGp5PoTZXEF
         7PYzfOYWgZcXUa7t8YX09ExzG/XrPoNV8qSmDurvtJe8O5rFjBZmVIuzEfrNrWiXnVTm
         H7uprayMakIdPxXHLs4bVRVstdaXd12iak5aT5NPMx9Y28x3AskgJBYcmqIEHSEsnLOP
         NF2w==
X-Forwarded-Encrypted: i=1; AKwUvBx0wEmhVPpg8hCEgmaAswzFhvL2YwuqYbrKlw3O7NHiQe0s2uPoZMWrTMDl3ks41zUSi45s6hFM2Q==@kvack.org
X-Gm-Message-State: AFuF++l7DaZ8of/RKP7dPR2fJLMEDvplEZ/BO9S3KIyIvJYG7mHRxQdS
	OBrhRxqpd673smv1qyQ/W2TE1Ynp2zOcYbCYyssJE4kVyNZ9xnQLFFXC
X-Gm-Gg: AYBFou3/ZUGJ9KQRqH8DZMU55GCVPv9Ht6tG7pLezJJgMxfC6QUPC37/pB2s8CQtcQf
	wjFFP1BdPXoXb12EG6zRNidRz6SUFQWAqoDbcwV8I1ehtfOLtMsA+MEux7VmM+/xj7sBo6+3VOK
	wHh+j+P9kshjzvUPom9QxAaTC1YlMiKIlgLt2hZschr+5DISLGZMzleS6zHB0mKDdI5C8EouxCh
	PtXV04fk1cTm6U/wLXQbtcIJehMITBTQc9N2QzNMMrEVy8QZM1z+pjqZCr0cBbr4dX9wfnPKDlE
	8GKqwiLvu2MQR+n8I7XZLtkehgUOYfqHcD6ExoHNHYg4STGSuXnMGWE66r/5L/8heD8rpDPwxBz
	dSOOW/3ujjJPH+md+WQGgALf4K99FD1v1OlsDuQuO2HHJYBn64wrkB9CUCnUo7ZqK9jUGKIBJLi
	SpaBeXPwavjruOdUrrP1wKvfvhOYjYgo3686ULwKeZPmjneVqcaX8rrFuwuqPV2fIBF5gNB/Qz
X-Received: by 2002:a05:6a00:6ca9:b0:84f:77cc:63cd with SMTP id d2e1a72fcca58-85ed4449927mr5116039b3a.17.1788334423379;
        Wed, 02 Sep 2026 00:33:43 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:33:41 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v6 10/10] crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF header
Date: Wed,  2 Sep 2026 15:31:16 +0800
Message-ID: <20260902073116.802752-11-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83A7F40003
X-Stat-Signature: nn1oe7wn1nq7qoiswx7m56d8gpyi9oqe
X-Rspam-User: 
X-HE-Tag: 1788334424-278555
X-HE-Meta: U2FsdGVkX1+7JWrHWQJXONnsjT7kt0C+DrjzLrW9+63lA0Cohq+KAZKAEatCrmsyvUgA5bN1YUtQENPBFKf4Sw/NUMLkjgH8brpXNlLxztMD7vg53VBT15zCUqzVz9PmnUem9u7u9ngLD44O4UpqxMgXCxOhkE9iapgNDQMay1NfLJVyVje/q1mDzxl86OTJbsFB5pjeaCqZ9w619k/S9M3/QcT5mmV9NGeAd6PaUQVxufHPquFMHggnxIB1JLR6Ab4+kKpbaeNua14QU7lXBFsHFdn4fOstMCrd+v91K7l6lbonVyZIlhaS2b9IimSzZTlOB7W5J5nX30L1fnohdirS4jZV033yqEMsvKSkrti94lf+IQ801iGEiL5zABG0zLACd1esEm+8AkEJpCIUaSwbTiKSo8mp1KS1qp+PZw+XO7L7XEniHiACGJDqgFR0k9kMBvIQNgn6C9QjiqRZqztD13WhCpR1B1UxpIbXdU75MoV1CZUyvnxBytsKDgv8ODk2zPzAVR26+TG8mOBrsfv51Oo/+RPnVwu59JHsGnMaP3tqfRv59rOrUpfOrPDRQGFndT+cQI+wHN2t4Vk/WGlWZ+ZkQtgkAP8e8VPAwQQ4DCA6fEyuWHHM946kD91vgTuSy0iR0Ja1fRKTj5BWqQoFhJA1ljaeRN6p49GXkI40dwjb0cmyyJN7VbPrSIprDEDRwLthTB5X9MT/hGeJ4UStqW+5Kn+OW2MyKdLjnRL29qVI5Wf0EPhhTR4nABDVeifTt214Xj+J/DMSVq15LLwFSTTqBl5ZAf1tI8XL1gK97rPhgpBURVXzZK2dZGoWtUogXWCj2hGiyeb81GYMAX2t6uzDUYQ8A/YmqnAE8kOmdDChp70Q6BD/dvvs42Sj8NBDitWgDEFHkKzcPNVlsnRmXe2UFJzSLgPLYO3b4E5Hq4Ae8Tpll1TkLuzLO3mYP9sSnV7cgNHiohK07IP
 BW9elX5n
 0sS8jwwyseGXK1BK1OnVNfns6sxuD1ZIxwyJhuHkpnQaqcviDtT/5Tp1aCYbCKJEqPLUwY6wUS9FSZEgeEe8on95DHeVlzlloKeVoPOq9tEs6t2plnDGsx2UQrXaVm0o1cknRv2SKlXfv6J8ymGk5IHzDjJYADPvfrZYPsbmZYAgN1sJbA4PNjLl7RGfDwxfWdEtVTDrUVEiRIHO+aTkgVtSJPy7MTcSP8YnIjtLUgD37AIWduDZm5EwNhA8gbrnfLwiRIxr6V2SY+hdVle4T8VTji7+T9bGJ2FyoR03gxAsHmHghH2Kh4PjcB/SS7o57qkOJq4w5X0EpsgLyxffBAXGpZFXqJ6um9ocNU4loGPZTZ5MkPbWmnN4rHNzqarpQlpwVd6KZtxj18tt1KqkmuLd2rh85lXh+2EYERYKLl9jMSqeR4YfRNBtEkFrK3iRF6cvRV8rcNH3nhVhhZCUP2ZYwFBEosgJr2HmyQRTxLQsvLRWZmEV4v4tSpQNjUjPa5X8MnAJlW8HQeGX7DOc5YCEHyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Reserve regions (for GPU, DSP, ...) carry no data useful for crash
analysis. Exclude MEMBLOCK_NODUMP regions from the vmcore ELF header to
reduce vmcore size and capture time. crash_should_skip_region() now also
returns true for MEMBLOCK_NODUMP.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 kernel/crash_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index bd64cf585795..b0e618e13588 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -270,10 +270,10 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	return 0;
 }
 
-/* Exclude NOMAP regions from the vmcore. */
+/* Exclude NOMAP and NODUMP regions from the vmcore. */
 static bool crash_should_skip_region(struct memblock_region *reg)
 {
-	return memblock_is_nomap(reg);
+	return memblock_is_nomap(reg) || memblock_is_nodump(reg);
 }
 
 static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
-- 
2.43.0


