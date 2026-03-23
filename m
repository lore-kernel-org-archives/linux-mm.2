Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD11F532C1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7F86B00BD; Mon, 23 Mar 2026 19:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0036B00BF; Mon, 23 Mar 2026 19:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18BB6B00C0; Mon, 23 Mar 2026 19:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B06D96B00BD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 854A95C2B4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:17 +0000 (UTC)
X-FDA: 84578996754.26.EE390B0
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id F0893100004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ez9iIpM9;
	spf=pass (imf05.hostedemail.com: domain of 30tPBaQgKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=30tPBaQgKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CreqaGlwQEQK+YRyK6iGxzdx6WSNNVSy3f0PqjRZciY=;
	b=sk9vJhBLzXzhU7O4a0+rYhggsC1zi5zQwdWItnYYJ411dFNBcDruPW/BDun2bZhhfkjo5q
	OLiAeT2InnJQWZGhcKx32w187YSN37nBkFyXAcNL/XaH97Xh6xB/7gIFziAhkhVsUSwWmh
	DAZvKbs9TpYHsGdmyO2+naqba9ITdh4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ez9iIpM9;
	spf=pass (imf05.hostedemail.com: domain of 30tPBaQgKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=30tPBaQgKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310356; a=rsa-sha256;
	cv=none;
	b=ApO/Yj/sJ+XC+HhymOafIRmrxLrt6CLi9OZMErU+kAF0iwxYs3/2wxz9Rx/D+B0Z7AaHZA
	0AeYn5FfIkDZL+NYk4oxixl/FHCiGg252KpW4qxVwKNCFx+JyoSPJJHkfpXvIZV202BXnF
	7VDjRlGGr/AFSsaJbrnfN7JETqXGrvY=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35449510446so773115a91.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310355; x=1774915155; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CreqaGlwQEQK+YRyK6iGxzdx6WSNNVSy3f0PqjRZciY=;
        b=ez9iIpM9msijQjIYZt3Gb+UQvxzsmUpyKSBvRjo4u+vTibkgMh67CXCMxDcj1JNVrv
         mI9a7BJCgfL4wD9uX2jWnj7RAy6AxCsEz7hiYIgcVumf2ahm7mInbGfQgHHF1Z/9tqO0
         nHd4T19fRd8HR6YWJsEc2UCZ0Jix6VgmAvGz5coyBKo1DXP+tDh6lLZ3hiI5UpPj2iW7
         TXoExyi3feXWuke4iykIOx8l4xTn+hcHcWiXvSSrgu+me1B9RGhLJ7E9K3Nx+kGuLz7/
         h7xSrPytOU3vYt33BQRtuHULUOsjjaWG0YWhJGpVIid/Fz5xuLZqgCisZWLiUv9OAhH0
         p8xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310355; x=1774915155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CreqaGlwQEQK+YRyK6iGxzdx6WSNNVSy3f0PqjRZciY=;
        b=Hdko416LFH0kYuhm/OA4HtnPzKdE0co64TIPZMnj1Jio5dhuxC7kuEyAFs+5Svpj+p
         HtOj0CjQbvfbHRhbca5urlJzuek6ymXk4/WKFBbWZyB5V1qWe7DFKmM5nMpJ8oVZI8ca
         jjB3n06BwfpBsSIHUqIMzHpsSJ9KfZsXUkHqQArDSushoh/TIdg4dNDzBqUqxNQ0K08F
         y/Tx6eyGh0lFpo5DQ5HpST9n/dDhkYoOzlNC7xGoWirJ9VyARCgt0+DFujxdxrKtouot
         Ghw9svlav9pF7j3Jq3Ab8HRaKFYcL2cqXtAprbA6dfKTxC+kkQ9KaligoExGqi4ZkS/C
         KoNg==
X-Forwarded-Encrypted: i=1; AJvYcCUiXQdeSvIS5spHHJHwjzcbGeL6wsxRr/1EcXVE+upcraBBqAQcrc4rNkOlN6jei3kfb6dF9An7XQ==@kvack.org
X-Gm-Message-State: AOJu0Yyr/UXxacyxTZQO6L+//eOy+GlqAd78SSQ4PKBmOR+i2Ah5Mb6i
	AyPuPr4FPz9meq0AmRi5VjChCsmLN5/T1Sj3FfX/Drplrc4iuVhtdpLHkaR9eXO2k7LDFEgFv5R
	99m2MQ3zNBq+l8g==
X-Received: from pjat16.prod.google.com ([2002:a17:90a:d10:b0:35b:a2ad:add2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d85:b0:359:1063:6aed with SMTP id 98e67ed59e1d1-35bd2cb3e52mr11055132a91.22.1774310354638;
 Mon, 23 Mar 2026 16:59:14 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:13 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-22-dmatlack@google.com>
Subject: [PATCH v3 21/24] vfio: selftests: Expose iommu_modes to tests
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0893100004
X-Stat-Signature: nciopfeszbrdpked94tspmjy98ztgd5c
X-Rspam-User: 
X-HE-Tag: 1774310355-273599
X-HE-Meta: U2FsdGVkX19CRPfbsrMD7K7yJd83gIsbfUifCbq0fpzhN0FtP3Zq2bMWKBMDwBpgktMdRPoLWySiPYCgbi6viCZXJu8qHH5XKHiP2F0bO8KxYTTNWja3VxNA6ry0tSapJB+qwn6TWTr3iFjtKvYW/jmYf5m+SLu/xgRNsCXiEkxWhaMDg6J7xZC8Yj0QP8oGJ+sylbdHRChws+v+8RKdmvDcPdyG+S4emteC9XoFcWaplUFD5hDgE/2b7PRXs1LOWIqTengetpDFb2rdUqkb1B++t+efZE02ospRXHrTv//XA9kCgdw6hFoDiM2+k/g/7cr/vyqj1tf0b1gLlSrxhlPozPpf6EVFLJQhTJAlnKA9VC0ulqJ7V8fWAo2nsCAnVFNH+9Izr+ajmD3VB57aK3hrBH8UcPXYnBQAXkROPS1GbBuh/WbEM1e3iBMvUf1omuhRtpQQjmhw1IUQeQlQaEdPjSCn4ldw5ez5IcolHp/STGoGie55/jngc2akv1dBZOJ4fh6xK/JLknCq/CffM6waXdFNk0rGlVXGUVaaODzqUFzaFJokxozP983OFdPmiuESDqPV6P3ktgpZaG+NTcW6FSK90esLdMHAvDiQb1BQ2wSeeM//FnLfD0GleMRRTHXrbrTo7z8irB1Qt0JIjzzj++9DlsIprVlyfLGtc/COxNi3dP2zn0URdR4fH/Zmup1ucZ2OkWa4W85dOumfoAfqko6kAnTgFpM6SMGRa/M1TyKI4in7ex6FE7wZPn/67okPLw/khmfzw3ztWnknQpk9BMGp+zPS9V67WfBZ9KNLtgXXSFVpwum/vny4lhLL5wW9QMns6o1sfnwk64uceUB1oQ7xKAbgs+9YKYJudXsWO1L6mJJ8AZj9khUSbxuQIWGRc4HpFytpU+FrTe9a9WlxZ5h2Y0gKtwMeKq3gkZmz8PAwqiSN6XT2aaIBg6P9rvjotiDT8mWwftqDzMt
 rrHoPIAs
 BbTc1QY1fSF+DAOK3RDueLyflrb8mVgblaWdFIHsbigPaAIcUCumLf91Yx6CShGKYo2Cwc6qJdD/v2YlBCIqYfBEURVAnwsvKb9UCKzgiRBzdVq+fcfceNQQNwouvg81BqW3qZY5Nhpq3t483bxEK8/TC4MSrAOXne3NuJf6cDTmxc9nEcM60+Gr8emaY04HpF8DvgCK9yThBIm3ZsrWkJt0hb3YYBCNT2HBuTmCBEvCKDYgdbwQMBq7bRnyI7m4CUbT0/CMM+f3dO3NhWRauaILh4yhaqi/bC+EMGSRjtH0y/3ZmSHQMq7498Q2IFRvUzaDl
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
index e9a3386a4719..4b9cbe262159 100644
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
index 035dac069d60..95a494f829d2 100644
--- a/tools/testing/selftests/vfio/lib/iommu.c
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -23,7 +23,7 @@
 const char *default_iommu_mode = MODE_IOMMUFD;
 
 /* Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(). */
-static const struct iommu_mode iommu_modes[] = {
+const struct iommu_mode iommu_modes[] = {
 	{
 		.name = MODE_VFIO_TYPE1_IOMMU,
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
2.53.0.983.g0bb29b3bc5-goog


