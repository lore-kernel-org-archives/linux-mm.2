Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE864FD9E34
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7316B0005; Fri, 27 Feb 2026 01:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64F86B0088; Fri, 27 Feb 2026 01:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63C36B0089; Fri, 27 Feb 2026 01:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBFF36B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:16:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EA1A8BD0C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:16:59 +0000 (UTC)
X-FDA: 84489228558.12.D443488
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 85EC18000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:16:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DVwIZNx3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772173017; a=rsa-sha256;
	cv=none;
	b=B5zMxSJQ96bMhdx35J5Y0wsj5YFtO0wrI96I7zpnpzm7KAneT3HnvLrQQzQApAmkmaExzz
	iN08C3Ggb21hd/swwa5mngSYPAlNde+lHvJTIL81Tuch8S4bMNhcweGh2HQRIL4U4UIGJ1
	a2Qefhg/a++gTGS0VtafTx5Q4VVnVyc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DVwIZNx3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772173017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TBQTSZoZ8QpZw8gStM3hrWmhO0sM5dIUkdb0CVPsHZ4=;
	b=2uheUTFbHhhlGlR/uoMZ5VIgERTxa/kB06WQxF6FlKxsJLkFVNyeaDbAcpSzgHp69ekjyG
	2MB7AYJYWkQmXPIGIUzkJCRjPd3V/C6RoHx80hlOThS0qwDeJXC1gnzsqeyMRmLngJ7BIR
	Flf/Wu2APR1V2WvVXuZGIe7L3MevYTQ=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2aad1bb5058so16151735ad.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772173016; x=1772777816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TBQTSZoZ8QpZw8gStM3hrWmhO0sM5dIUkdb0CVPsHZ4=;
        b=DVwIZNx3pe1qDh8/cPl0p3jbmRvmOLXYHq/TkKkViTPcTgst91X9Zg+nXOtjFuYTpk
         jKUwYTVhaOIZzryaEy+vuWvSBlxzrMYFM+nGQh+MG1DqBMYdoMPf24gDYO5dNb1ajTx2
         3o3ajiH0hZKIH0tJWiTpSfHHX6HQ2je7i05ArH9zGMToGlKrkJENwGRjEOg9FdXbfkVr
         XmlQW2HVZy1FfRxedkiS8rGlIPrqCRbvwyoi5/nN0KahnNjfXIgRN8UwZjZcI3bJQXLQ
         fbJnQZpbEAvYZuPvIfKKHJiX9cCzOadQBCMTInhxo/hc9vyaPCMdkhj2ttYRTpn9FQjT
         owJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772173016; x=1772777816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBQTSZoZ8QpZw8gStM3hrWmhO0sM5dIUkdb0CVPsHZ4=;
        b=MfBsD91AtOrhH/s8rME362ymbKjnYKmxf5iYRqvAD6TOOTkckr6uFJeJV1d9vk7zkw
         4UFf09zqxnmIWDxeTrW51mvtgO8BupmXQBX4YB+BXtMik7j3s89qoGTfY0+SodATxMCs
         UXcNw2Ji3xgwLw191nU6O+ouwfVUVLz4bxAPtnJgJbPnhyxOHv8XlQunXDD0qCXTzpla
         ZXnwljN/fEftFbn5jEmyf+PiquYmsaIUCh+aSdGakeQzMzu+d8A6way/ByUr0pJLA/AU
         UIkBDb6p2JF2spGY2TiNV0hdzAIkoekoj/zRF5XtSWR4sM4jf6M4UwKadYz+vRlpFX7i
         KK8g==
X-Gm-Message-State: AOJu0Yx8YqXZvQwsVQJBP4zMAlXFQr145IwkBja9D4zkvopNbxNCh3lq
	z+5y4eTSk7y8VXXqzowVuRjjTje5eDfPhU8rfY1RKTYHwEHj+dWDSYUkc7uNmGWF
X-Gm-Gg: ATEYQzyM5CHTDy7kwJ8gsMfXxP4mK9nfbj/wi5gpA9jCitNjg4HnZHv62MtmawBcoSM
	1QSr+2uDbEnuBlWm/V8qfsH6tf1vZ0DZPhGa7Qbr2CSlvCbMGD7PbSP9LhAYWyDILjALoBwFhsy
	yXr3koCN+iLIeU5307hXHBgjDQFPvVYALk/50kbT+vYjRuV03zoi88x3ANGG5H8UOYzDchLz+zr
	kg0CZz+QesSiH8NGf0Gj5TBumSBYqxcdmLYFSVPBhh3wmH+Hf42Rm72eqvf/idlf/9OsexTMpqR
	HkU82QKeqyGXbbFF7tPDHbMlMZxDp08NuB8DVnk97rEp1cdbFoIeH6sddhGKs3mYo7xd5TBBzBZ
	1p6pPEo3gnpwO6MQ1Y9IjsY5N1ov+guPnNOBmvRoAc5jYVAk+ENVpvopu2olw4XzevRCFSsAlSv
	nAtAVFPbm81rA4PSFOEA==
X-Received: by 2002:a17:902:d2c1:b0:2ad:9edf:7fe5 with SMTP id d9443c01a7336-2ae2e4bce9dmr19427245ad.42.1772173016250;
        Thu, 26 Feb 2026 22:16:56 -0800 (PST)
Received: from dw-tp ([203.81.243.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6d1913sm57837485ad.77.2026.02.26.22.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 22:16:55 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Peter Xu <peterx@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
Date: Fri, 27 Feb 2026 11:46:36 +0530
Message-ID: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85EC18000B
X-Stat-Signature: abdemnezxeif651sx9myaqzgpwbiyu3q
X-Rspam-User: 
X-HE-Tag: 1772173017-989339
X-HE-Meta: U2FsdGVkX18zjg0xIqTkGzAcPpDyk5NPZfLEYsgUhpb+Mc2mlXvgEl164uUVSy72zV3390b6WNVqwh8N9Cbv3SmqSI4N78Z1XZ0v1tcH/SZ3tDzBaJj6w35sfKyi4F0KDF6xmkVbQCOh/3XKH18kmOch4l8HYm3GBZndAiLX97ymNYVqNZZpwtGfiKstXiGXJj+v6uZcqb3jEi9M+ijCO7B/VG+yK/TDMrmx2gux7knPG+ZqKsCz1vYLpD+FDnYWIe5IPWzbmFuoANK4PUIaOzf/9IwWCKx06PGmILo6ZQUVVZ4rPXIH+xupEvYTHzdqKvplhyGZolwHhXcaSbh6IbrRe0CdPiWdszy8g/I1nGhGdnhqiK//Go1eM43wRKYyivAG2LLzmlh9Ql8aElFJHOgV64xF11qS+k7vWkmc8BHMjTCwWxn+w46++M/r2Jds0rRsim0qPY6QHmKh0mxcNjKVw7AdosNdfSNXnov+F903HFghpKTRiUEqi5YbuPrPcmTQwgziKvE8h7zY+SlHmdTX9rHxObYvMpFlDg94t5gE2kW6fw2FAmNUG74HG5//8sEpNtDwST1qQbvKkh86K59iHXhv4/qp0VPqC2r0ysWT+G3J9XVp1FDv0d+vPG+yy4m+kIBIHD40kdGibCTaJ3EqnBUFOdDPw4dFtNcmHJuuEkP0A0sn/qWDLpLd6tEcbQv7PHDzLFScaZ/MmGswSlKUHLRCOcFZo+sdLVT/qmycy0G2g0fydxIyz27K1iMIRrykIcUI0R1MMaXqb3DBDQzkJrhfgdzhNz1QIPKThzbCZKIWFjOTokZaq5umzF349Fm7zxIBQ4exQLijbTi1BtAQWw/HDEMJTOLytYQ9wEjXiFXXKuBR8Ci4CDDLEp+fdVNCw9LePBNYinwrlqYyCKhL57p1DDg5zMUyv4hOYHix8rHUFP07gCCXC3WNrvx2tl37r5ppin9nLmCvmCR
 Lg7tWADu
 Q46tBjFkFERyazGWj+eq9Om5c0MHaz9ij7hYWibG8CBB/B8osVPigynb6ngkeFnGUDOJT6A4bp9ll6kn4twvHxBv09bUMzQm1jXI1nsfro+20QFIQTraP4oKRcxFO3rlMtZY1BIDL5seszDYNe80fQB+ZClhBT8Zjg19jvCpon1Zr/f4iYLUKhJP08Ny0McEtS4g0TxdjOthPBl0o/oU+V4NCrXexE01jbqbxAEGvmOaimRK/ATTT7dU0hqrmKGJYpGdQg2Fkev78T6ct8Us1bHXOnV9Dd75NDVUblkjg3aTjUsjxWdee1zmUJmiERdB8DrWq2lOHrPhZxPjylqcrnAmEGfrYSsLRJOyovVmN0tACygjzWRNAIutihCwh6E91+7hXrIMbOPELocbGyiOWTpGEVvAg8z0gETmviWB/B2SIo0PGAcOgHt02dhu2zwazZatK1S6+2KGpXYawE3nPcBxnieVpDN5cX+030vgupNBHMTsnkwypl1tpBH8K6EeMSN7eUwMi0OMTpTgwLIO91RAYgAS/a6bleqKMyu3UfLGM+tHe2W9BqkL5k8UpKZLGmEao2C6P2gJxKj+vOsVmFKyd0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures like PowerPC uses runtime defined values for
PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
at runtime using kernel cmdline. So the pXd_index_size is not known at
compile time. Without this fix, when we add huge pfn support on powerpc
in the next patch, vfio_pci_core driver compilation can fail with the
following errors.

  CC [M]  drivers/vfio/vfio_main.o
  CC [M]  drivers/vfio/group.o
  CC [M]  drivers/vfio/container.o
  CC [M]  drivers/vfio/virqfd.o
  CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
  CC [M]  drivers/vfio/pci/vfio_pci_core.o
  CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
  CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
  CC [M]  drivers/vfio/pci/vfio_pci_config.o
  CC [M]  drivers/vfio/pci/vfio_pci.o
  AR      kernel/built-in.a
../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
 1678 |         case PMD_ORDER:
      |         ^~~~
../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
 1682 |         case PUD_ORDER:
      |         ^~~~
make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
make[6]: *** Waiting for unfinished jobs....
make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2

Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d43745fe4c84..5395a6f30904 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1670,21 +1670,20 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		return VM_FAULT_SIGBUS;

-	switch (order) {
-	case 0:
+	if (order == 0) {
 		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+	}
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	case PMD_ORDER:
+	 else if (order == PMD_ORDER) {
 		return vmf_insert_pfn_pmd(vmf, pfn, false);
+	 }
 #endif
 #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-	case PUD_ORDER:
+	 else if (order == PUD_ORDER) {
 		return vmf_insert_pfn_pud(vmf, pfn, false);
-		break;
+	 }
 #endif
-	default:
-		return VM_FAULT_FALLBACK;
-	}
+	return VM_FAULT_FALLBACK;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);

--
2.53.0


