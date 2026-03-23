Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B0DF532C0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D414E6B00AD; Mon, 23 Mar 2026 19:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8FE6B00AF; Mon, 23 Mar 2026 19:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72026B00B0; Mon, 23 Mar 2026 19:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2036B00AD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C6A0C3CEA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:03 +0000 (UTC)
X-FDA: 84578996166.10.0BA4DF4
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 992DFC0002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eaUmUB0P;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3xNPBaQgKCMcqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3xNPBaQgKCMcqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aeeFxLRNeEzMbfk8m3pX/GNMnylfMV1s3l1hGn54HBA=;
	b=dcCWoyzbHSmgTRQmbZthzD0Yg30kxtPBv7OsTyzfiouvXbw3/kSq2CFfU+8BnL8vwDmbsQ
	LwBbfP3svrpjJ62xdEzYzJXsECd0pFP79hnLrUUs+7zSnUUc1jdHhoqLqz66zVb/QGOIiS
	F0eQSLi7AvUaoP5UKSco74g/RYjGsns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310341; a=rsa-sha256;
	cv=none;
	b=wMXRgKSJzW9KQ7Y6TwJRCtl8e23X8OYIJv852BWiIBY7SEEyX4NpkGVOO53NUZoLzvyhjX
	cVk0wDcZ8RSLJzNmeJZelx2KHlT/nZrsVXBH2l+bMryYr5UOfr71MEjmRtvOqLcgdLuUPn
	Wl4el65onJZXd0BmztdRdM6zgGtq3wg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eaUmUB0P;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3xNPBaQgKCMcqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3xNPBaQgKCMcqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35678f99c6eso3207399a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310340; x=1774915140; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aeeFxLRNeEzMbfk8m3pX/GNMnylfMV1s3l1hGn54HBA=;
        b=eaUmUB0PJWG4m+Q7azYuWiAePtNL4Bo43sk7mCBcZNvPyjAWJVpOqmVE6G6+PodXJ7
         h0zTR7pgHWcusyMJjB9DYSHb9/haQUNwvMP+ih5jdFH+oi3HvBLgxw4jFpFLjm5wEknM
         TKIuzhLO8y6q3x7eIQubyKvitQYkPRABBE65BkTVMpRAMj/wD/M9p2G/iSp6rAFwButO
         gJ+JoOSs68LTbUhpcX40sDqcpW/Ut5b5UHT9lKmLCsAQEaZJQtrb+nFY780+bqF56d2i
         R2xmgTg+C/sI0zN0XjpYJk0Y6fLryjt93Tgw7KKF824ZHFd22NgqPW3AH2AGVBm/RBHt
         14+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310340; x=1774915140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aeeFxLRNeEzMbfk8m3pX/GNMnylfMV1s3l1hGn54HBA=;
        b=eY6acM11iNZLtxUxxWtkgHYf/cunHafjq/s5m0gNCJILhGrxk1UsX7rmEL08BIhTM7
         K5LVSzFTgNGFa13T7iC38LgjKC2ZpAqNTD1mFagC4dPB6xchgXvt/JvEiuHpfMWi61Ba
         DNrUzRJJUmkymhVmYdyVIFTityfbPRD+ObnZNsFs/IlxaHSuoci5CED2yG7nRQdEcADc
         avx6vieatUjlQn7pXy/YEui7KrjoVQPWVwjvA1lsNJlm+vSh4Qg4gbJlBomp/2IVgyIk
         jOCwvTMsgMFYdJqEXhMKjElWrjPyVrmh0udSDmoYSwD6ZZIWcUYoPNLlDRQCKNsH4Qer
         oQ0w==
X-Forwarded-Encrypted: i=1; AJvYcCXp/it0d+wUIOzsTUmaIQzbk5BPzWo2XoofWxaRYNZQjRrgGmXs7/8c4MS4fiQrK3DP9JjcCRMkUg==@kvack.org
X-Gm-Message-State: AOJu0YzZKSu/RR1fTg8PfIaxh/my22mQD22PLaa5fDZOk2n3J1jo1h3L
	JTUJs1YD3G7YtwQckXKzeoTGpLQIOR10428+6mBG8xE0rODXSlqELzaOGWwm9F09c+71tp8bJtU
	96GqWXPmSO8c2Tg==
X-Received: from pgbcl21.prod.google.com ([2002:a05:6a02:995:b0:c73:90cf:9638])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3286:b0:398:7ca0:43a9 with SMTP id adf61e73a8af0-39bceb46904mr12137508637.36.1774310340303;
 Mon, 23 Mar 2026 16:59:00 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:05 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-14-dmatlack@google.com>
Subject: [PATCH v3 13/24] docs: liveupdate: Add documentation for VFIO PCI
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
X-Rspamd-Queue-Id: 992DFC0002
X-Stat-Signature: xhxg3rs3a767xqs16p6nm8ox7ce1jf1q
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774310341-77703
X-HE-Meta: U2FsdGVkX1+4nuKr6s5qPPc+bPQFFcIpl4qoS0S+xdl7B1Npo2Kw4H7zVufGK4CBs4r8C66/Uhq1E8FQRoMXUp3zixQKqBbVKZCw642bsDA2Pugeo4LxdBHA8Cb1LGIKTU3hWbAraWMpylOnCUARNY9pYl0da17PHQmC3IcB2YCCmzme3TtjWiFeM+WdaLKkNYCV9vupbqBbbI5sqTM91tPEq9fFV1De42xIE2Lr+l+OFaIx5xSMDK0JNibh9eSxw5ncR9TjwDCv/rsfiC44DhGzLna4bxr8hiU2AnkXNunr1DAOXK4KRahIuXCcmwcXiE1cJ8IFh0nUic2cM6qqQBvYxb3mPuV4CfaJ/JXp0sUznPb5ip/DgJz33/QRU6cN/fcozKFbKtbfQsgKniC9VRBEQGDfk7Xt3BEECCuoT2m0dRJvkGdgzkueVzjYDPablsbAyqNerCLdpFSq66skYH+TECLQRaAilZP0NNSsTBxbY9LLO8K7OyIt2x108Dvhtwm6Hjjolg9tsb7XHBubafboyUIz09SDJi5ya+YgV1cB0FlqC6Ll60xDt1JA+E9hcb1xRKXvIs2PG2HDICryAQXj6++vswm2W4NSnzHYmNKfxtfsiV5nhRvxH77GujHmXy38xL0rvc9pqcKvFKwY0UhSvpi2t9cuLWJiIB461gMYjDJowuLFoh1wV2JvC8LsZG3nzg42GxkIRSNC3h4eHMWw4JL/ZKZ3a0TaqJ1hvUMrkHRJFFp2Z5rSHwk24UcBrDaSSzhU0vbjt6rOABLsSNymaW1yDtKlT9FfkLXCTEId+xPREHCVurXtXCx2fccFl7tkUgqne9qrm2J3qJ+akZdS21AOgUoZoT8WQRMwy30mQyzf1snsGrekvskN3pUFDCDF3+pBHkKYBH1Zu0V6gB+zevgjUWk+tLXERmIZ/ETZ76pfPnIRckmiIUb7rP8KmBPuTEccCq+c4n8tFtY
 pmVj/TBZ
 oeTMrhAUJzgWQnb0froaglYFha1zjDolrjdIDclSgKj8AmA9G4OpGy5KRC2O0xOlZzwvDVuaKCnqz5P5eZu1sKiDYaHbNv2zM7Jo93VGvwj7X/tW3ab0RPTx7XncCSeCk7Ti3Jeb3GowpWCTl/QkIPkElg99qzAd3Wzu2tKdL+9To4+1ie6tXMII2I5TbFPS6/sFYDTNjQJ6Dm1wSdJJ0ciSqa/pSMF+D/Y+H3VlVOfuV7NUpjXTdpqkDfAMqiqYd3amY4e+Sp3U3leNpCYxQOVjJ0JZo1dVQszf6SX4hxwWTKEm2vtcTB1kPEue5c49x7aGonGjBfTZF/iGDwRCLnF74NZNAmy5h9yw2i0uuSBXufb8Ug7XZCi+ZZVoPXGlnqWJbnS57gTVHWRfr3dfpwjSiXo8wM4DNDHHqbPIOTpJqNDZ5hjLERnOxhBMbhvTW9bzGwYz2hAAadENtaUukEkgIYwi/tqu3GxnFbhr98DnBPASCxirbOUePZ4EtMQUKkm/UsOhtAtcj6tUTyrxOz1kS87D4oGSEOBD8beXPC4gJghMn8G6tEM5YeHuptNbkRHf6YcBQJcxbNc4DNgbAL2zfAeKdhQzEPliiDFPmSL92sYFniEsvi8oWGZfckBXGar8e5eMnXEcBuwsHDdB72NecqHWG2JytN3oV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for preserving VFIO device files across a Live Update,
generated from the kernel-doc comments in the code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/core-api/liveupdate.rst         |  1 +
 .../driver-api/vfio_pci_liveupdate.rst        | 23 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 25 insertions(+)
 create mode 100644 Documentation/driver-api/vfio_pci_liveupdate.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index d56a7760978a..c55d0d9d1d3b 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -34,6 +34,7 @@ The following types of file descriptors can be preserved
    :maxdepth: 1
 
    ../mm/memfd_preservation
+   ../driver-api/vfio_pci_liveupdate
 
 Public API
 ==========
diff --git a/Documentation/driver-api/vfio_pci_liveupdate.rst b/Documentation/driver-api/vfio_pci_liveupdate.rst
new file mode 100644
index 000000000000..1098b84e5ecd
--- /dev/null
+++ b/Documentation/driver-api/vfio_pci_liveupdate.rst
@@ -0,0 +1,23 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+====================================
+VFIO PCI Device Preservation via LUO
+====================================
+
+.. kernel-doc:: drivers/vfio/pci/vfio_pci_liveupdate.c
+   :doc: VFIO PCI Preservation via LUO
+
+VFIO PCI Preservation ABI
+=========================
+
+.. kernel-doc:: include/linux/kho/abi/vfio_pci.h
+   :doc: VFIO PCI Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/vfio_pci.h
+   :internal:
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/core-api/kho/index`
diff --git a/MAINTAINERS b/MAINTAINERS
index a16a7ecc67a4..a6a31b94a4e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27684,6 +27684,7 @@ T:	git https://github.com/awilliam/linux-vfio.git
 F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
 F:	Documentation/driver-api/vfio.rst
+F:	Documentation/driver-api/vfio_pci_liveupdate.rst
 F:	drivers/vfio/
 F:	include/linux/kho/abi/vfio_pci.h
 F:	include/linux/vfio.h
-- 
2.53.0.983.g0bb29b3bc5-goog


