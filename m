Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 256F6D73E8D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3059B6B00A5; Thu, 29 Jan 2026 16:26:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214FF6B00A7; Thu, 29 Jan 2026 16:26:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0016B00A8; Thu, 29 Jan 2026 16:26:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F34D26B00A5
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD0851602B3
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:11 +0000 (UTC)
X-FDA: 84386284542.04.48BCB71
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 312C1140006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=irJqziBI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3cdB7aQgKCFQz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3cdB7aQgKCFQz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721970; a=rsa-sha256;
	cv=none;
	b=TONENSGYRXFOjcNThhbLONnWHDUPPFF/FgBqlr3D3GXWS1cdY+Yj5z7F6qxorRZ/XtALMg
	p7TFzUs8Q2PnIoap/MJHZY2Ro0C/6CgBWwn++voyKz6jx64UoSyZyShpl7TrPitMGclzsL
	9W2takomruD1IKGkKErTdZALHWqG918=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=irJqziBI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3cdB7aQgKCFQz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3cdB7aQgKCFQz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZYm6U95PKyVs4z00Hg/ZV7BBbgjTCKK+U9M7txSstE=;
	b=gWdH+ZCJCPiIHOVd6aBdFsHd/fbNo9XtkUW/CbsOrxYgF86Z7RlJPUJrh0UkJty+Ye1o13
	OJing5BuNv3Z/ugO9hD2LM+6BkVqMcmlfh5FXqM5EErHGgxZdJLXWE5xtZmULtJnw4H1qA
	RvaLBi3eHB1D7b3RDZ5t1nCRh7t8pT4=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c5d203988so2580359a91.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721969; x=1770326769; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xZYm6U95PKyVs4z00Hg/ZV7BBbgjTCKK+U9M7txSstE=;
        b=irJqziBIBixkpoEij1vwPKU8on4hoH9s39yzRto7GcHr9oyBGjYjIKWTwcCkeZbMNW
         UNaiRRKtznTDvbifCN+LTtdCDeW+UBlXf3ev/hCfRn3V6U/UQl7ss0i1mt3+rS6nh8Um
         dkDvzOTYLc980qj7QTe40kP5JDmExckdD2grdrw7oo8F2ZauoIkCDiP8eV+/z99kbjQQ
         uBiYij9/z5I7vHtrvdaxmXq0luGzBZFRz64wAv5mim2n5zBxo2sXvrH4Rw95GJ228i8H
         N1/0GR3hRxiT+PU4QkUeK8jCULnwFL5HZ8KBJS2e2XatUcUqLGrpOEPYbNPFAdIQBF7o
         eCnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721969; x=1770326769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZYm6U95PKyVs4z00Hg/ZV7BBbgjTCKK+U9M7txSstE=;
        b=pUXqUoa07qedXegKqAvyNgt94Un/GB/OyHAQeYzCCU3vJpVYo7HJ4mXHl+W7uV1U0L
         YFDGtbRES5OksJ/bkW8Tkf4Hc3extZTyMLMax60wILcWMDGRM1w1p9qtNpcsKa2G+7Qp
         DNDRmjnPBtG1PD29lxCmwLNupA+AFphza9GsvLdCasWQRDqjvoKGaEi2TjyzPJMSlO5D
         EIP8fwoJ0NfXl2f/AqxB62bx3OcFhCsEgtCj7nTZtMbZzdElAvVirUD9SZirw7DOSG2Y
         iPcBayQJRdjN9Dl+aTEib4MKnSIctMfAzGXP4Qn/z/OzgDrfeEtPqn75/mAQt/7ZW4lg
         rZJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVy/Lo/cIjuBmXs/bg3u/EWx5nYGmsx7gy1ES3KzMDCwoEjfhBVMa7zk9zviDzDJf89njZRV+sehA==@kvack.org
X-Gm-Message-State: AOJu0YzqFtA12MoIrdF7CEsAe11cIZ1nC3Zz6OvABsEm6mlciYeZ31eF
	rVLCq57l3M5moD1KUDPxMpGHM1jW63sT+NRZw4XdHs+7sp2LU20MySQtLRCIQps3lL5Zi5Innn+
	w4JFR9un1mi5BNg==
X-Received: from pjpy19.prod.google.com ([2002:a17:90a:a413:b0:34c:9f0b:fd7])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ccd:b0:352:bd7c:ddbd with SMTP id 98e67ed59e1d1-3543b38af32mr803010a91.23.1769721969001;
 Thu, 29 Jan 2026 13:26:09 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:06 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-20-dmatlack@google.com>
Subject: [PATCH v2 19/22] vfio: selftests: Expose iommu_modes to tests
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 312C1140006
X-Stat-Signature: sig3n95ozktznri6joc7bzjrhd8eenmn
X-HE-Tag: 1769721969-430958
X-HE-Meta: U2FsdGVkX197hZdL8cJo0HmAigl0dFpP4BtEVqFsmND+rbjgOjd2u0BcOB/4IjyL1THHJQ/pUskTfjDRZTpGCRbd7f2vWxymT9E4pK/Ver55qNK+sZW9tStezrvDYiPYUS0hTpq3aAGOk1UNImZaVhLhTQIn9XxHigTuWeaakeeDsJRgfEzr5tQiEfznri+alPisOrnZlNh3/JskmEB+Hruiy71XHAm+POjnKJitXyKHDWF6dkIRitGbGy9Bvy5N6c0auQMgtkXGjmCZirSnY1R1PliV0vkXEEIBeNCMhZndyeBMllUb2iTxBKTWnSa2Q930aDtgEBBEujohfV12cgWYuSKokqDDJI/EV7PgdFymsYQJrPqzF1PMeK9vuk1sLtSKKKd+Iaqf0mBaebBB9y7C7M+MTJdqtucpT/f30FEEmT/7wJW+KoaUWDzHYeZhNg5cMBWULYWDoAhsE27gmdwTBoPj7pIrXKcRMoxtkJTqKrDQDNxijaKOWbeS/fSzNEzFtdl5HdOreIdirrYe7n9OT/5D6NMLFBS4dyTJyI0PjJhX4f/3ihqOrJs8cLVG/5PwxPbleCzZL04TE+FjeIXVEpm8JxinDXzF7zDRfajudDsHeA88AaAyUDP1J8nny/9xr2gds4ir09TMJeiYHoEMJkZ7BBgsbPMudHBDJ5b+ATfEKbRfH4pwxiHL88qqjJab+7ZuI9rnITo0skun+4xCgoQUevy4bCMG+jDFySaptFwNsfbF92UTb2zixZSDKMsc9LcVRKanOXn96zbozfv/+Zbtl08P3UdrDyB0j0bgk5nI3/1ThtHs3cHhq7QAYZUpxd5phwZLSRTSKhsBiu2+OH24XtC5+7RS6uxNYkgmPoMX/7Ur7GWfgBIWAlSDuTAVLIKe9r5g+mXrJdgP2ccN/Vek3z2yJgcJIvzo1ugvn+FmBbcghqCKqz5DiiOZmXZU+/jSU6nBoI+3mZv
 fhv8ClDP
 ZSXAa2dDdGhpW58LFYvQsHF/CX6anT3kdvKTay9bDI17ME9H5aUKVF0XM6hkH1nXVDjbj2U/l79dOnbz5pPUTjOLFoCPQfZRdyrgbFPunR5SIfcYT3NrB/LD8ydTyUXHyqUPxsZMKsGJsbo7ymb0TSqG1bR4+fn99Uak4NE+elsJ5jVgL4fJwMlZ0U3/Q0etjZhf6IRo33J8kBJUw3UZHRUVxuHkwOfvgSSCNcM6uBGFJD2xDpfWZMrT/sSYuTDRg75dlszUCI9CjVQI6UskaOriXChSbbZODEbgCfOe6VvbUx1HUmmlOR48reg1IIxDnZo+h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose the list of iommu_modes to enable tests that want to iterate
through all possible iommu modes.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/libvfio/iommu.h | 2 ++
 tools/testing/selftests/vfio/lib/iommu.c                 | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
index 5c9b9dc6d993..a03ff2281f11 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
@@ -15,6 +15,8 @@ struct iommu_mode {
 	unsigned long iommu_type;
 };
 
+extern const struct iommu_mode iommu_modes[];
+extern const int nr_iommu_modes;
 extern const char *default_iommu_mode;
 
 struct dma_region {
diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/selftests/vfio/lib/iommu.c
index 58b7fb7430d4..add35dbc83f8 100644
--- a/tools/testing/selftests/vfio/lib/iommu.c
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -23,7 +23,7 @@
 const char *default_iommu_mode = "iommufd";
 
 /* Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(). */
-static const struct iommu_mode iommu_modes[] = {
+const struct iommu_mode iommu_modes[] = {
 	{
 		.name = "vfio_type1_iommu",
 		.container_path = "/dev/vfio/vfio",
@@ -49,6 +49,8 @@ static const struct iommu_mode iommu_modes[] = {
 	},
 };
 
+const int nr_iommu_modes = ARRAY_SIZE(iommu_modes);
+
 static const struct iommu_mode *lookup_iommu_mode(const char *iommu_mode)
 {
 	int i;
-- 
2.53.0.rc1.225.gd81095ad13-goog


