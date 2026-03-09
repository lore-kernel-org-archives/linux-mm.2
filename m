Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6225AF3C241
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FADB6B008C; Mon,  9 Mar 2026 08:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9656B0092; Mon,  9 Mar 2026 08:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580AD6B0093; Mon,  9 Mar 2026 08:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46FE26B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:38:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0763F1A0132
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:38:52 +0000 (UTC)
X-FDA: 84526478904.05.7CEFA81
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3CA8F1C0011
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:38:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PyRBEVnC;
	spf=pass (imf21.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773059930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vew/51ISuWV8SVa/aQVcC7dheArZhsg+HjWKeDYSuPQ=;
	b=hy7LxM5Qvl3etWGxMwb2IMqIp8sBAnGi/ns6KVJZcldEwx+np9yzn6UDSA5E+eHvEsjKqT
	rZYy4Asz0QJkK85nexPe/1hzoGm6ZFH7f6xDHPW+sYXijUabYgt0QSOfj8PZQPIewrs01o
	ZObEo4aEXUhnCVI21OeNYnSfpKIC45I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PyRBEVnC;
	spf=pass (imf21.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773059930; a=rsa-sha256;
	cv=none;
	b=MdhFA0kX2QpUVUSmNu+DEkSz+fay5DQNP978qM8YQkrbmodguTMjUjfFXV/+Z6+gpUh1M3
	uhvbGO/wdvrUe07LtYC/tU1gAC610zziBrTsIIPJU3lqPDb/wrewYLoyyfmG7UUCnUd7AJ
	tna4J6r9Y7ajjyUCUV3ur/3NcJiVyJ8=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so128241285ad.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 05:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773059929; x=1773664729; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vew/51ISuWV8SVa/aQVcC7dheArZhsg+HjWKeDYSuPQ=;
        b=PyRBEVnC48riIyE4ltp4VunUDBaE5ziXgeSU9VPJpahTSh/mvjQPiY5h2Q+6CMMpRQ
         L1UqAIiNYBeQqGS2EwdGCAJNlIBrSDV75YDgWrnso7H76FxSngGiUaoeAUSNABSOi4Ri
         /3FZdU9fXw/uLVoGDoYk36axY0cy0YF04/DkJylNqKP5FFf3GqBBI5XHtK7ahKHsKWm7
         v0CgzUWfcGkKQMh62BBujdMl8C7fymJMNVBBHwdjweNdirClGXkpWJgCaEXLA8gcO9Bf
         jNpfuNb5ZhSQlYhfFDB0kVUxWoeeCfscyD0o+cqp3c03ZmwyfJrmpJE7cygh+BHpWY2b
         RVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773059929; x=1773664729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vew/51ISuWV8SVa/aQVcC7dheArZhsg+HjWKeDYSuPQ=;
        b=wCrxL6lOLGOZ3BCP1vRsiYCpoFHSKhzzoN29ZQicVrZ+auH6uVdZA1P869Gy3XIyTF
         95037rKHZHU1xZtR4Y97wGeGXGlVkesDmky4YEE1Si+eE5wy/YVvSFloGETXri0GYS51
         J9XfyriFJnTzYllZNfiykqh/0ZVAtyIksk5G1GSoZ7wDrvimHTcEDqx7HaYQHqOgsdHw
         hPJzSQdEjee+Dy0fpo2xqrF70nP+VX6/DIFSWeD/TFl8mYsD63PW0eRTiflab9RlAAXh
         kcOTcO3IzjeMFPEw/njaTDRw8N8aa2BPwYkA0Tk8q9EPJtCgjLrLgzKRh3Gsis2z9/hN
         jnig==
X-Forwarded-Encrypted: i=1; AJvYcCX0pWbjxhpwcWsOMF2dUbxXEBSCRU5IenvSn2L4kYmj98pRNMHl9oP/LFCMph+9QWQtH02bzCtxQA==@kvack.org
X-Gm-Message-State: AOJu0YwV+g7qYgsJibQJtJAyOm7oCJC+yI/AakSN8MLoiUHXFVE6YnBa
	rt7MX6WAyrVzEW59dO4tCRXDne/SMCpiul1pJ6irMzpLIv/cDI7GFB1o
X-Gm-Gg: ATEYQzwki9U3+qU0103LOyXVd1PoVasbhc5ZDcIqZdNCYxiZMXM7ZMHZAXcLrMIrKcZ
	PiHYTzbxh+EglNpUsm3GD9Cphgrw4yhzJvnCUJC32bhrc4R1RzeIbNb5jPHMeWQVw7Q/Nmwxyul
	5KKiMa0zJLK5DzjeEa+SoA8ipz9dc3WeVkEa53Or89bB514VKswC0+WiQEqhAUJjEBuan8jwC7M
	bRBiDbfGdD2/iNJ7YFBF1BNb7V3EWYOmj/b9X8p2ocoY5GZ6w998pRirjtzLOfLW9Su4jmy+tCg
	/LxrAvfQdM/hKYcFgjIW/sWhO3bQ1yEsNqnAYlwlg6ZychkRdl3UwnsJPSGKMQ/JEzvB0siWs29
	zg+4BpQlB5wb2p/MAvI8BO9NGfNanCigkZU3D5YisJQ3x7dwEBNTMP69RJxg4cKNRMRsgvK5Qha
	dLD/U2q6coLIUVhabcAfpPV8JRD6JNA9xXQNYntbo=
X-Received: by 2002:a17:903:388f:b0:2ae:50a3:3aa5 with SMTP id d9443c01a7336-2ae824879a7mr107552435ad.52.1773059928817;
        Mon, 09 Mar 2026 05:38:48 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83eafc64sm154867375ad.40.2026.03.09.05.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 05:38:48 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Peter Xu <peterx@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v2 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
Date: Mon,  9 Mar 2026 18:08:37 +0530
Message-Id: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3CA8F1C0011
X-Stat-Signature: bkte3kkzwxt5xds1ax977d8pcc65cm4d
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773059929-383921
X-HE-Meta: U2FsdGVkX18uNgAitGhBhw7YI62yqfQcJ448r0DoQUs54KsQqhXaZ9sHSbsLCAvuN/cMqGNMd+7jMkGJ0SPWtRi4TPXas6wFID1DU3tsUqCvOS8chZq+m0hVDuaCq7fg77O7FNDveIC5NzkjyXiJAmAbdROIFsJ9QxZMJLH1SzmzHGtlVrxYLwST1UUPj4GVMonyR/Ldd2wfnNL69Otpdh45cTd7CRc488gLhWhAVtVu9uyUjUAhigGQ9oDfqG3E0ien5Am9Ayv4LR/ubQfaMTRe/BiF/yIGdb5O0GTGefePLs92VQGQTUtWvLU8KT1ps1HBbH1HfU1yyt9SmqfIDeb+8VIqEw6f7VqqL0ihJACIWfEa2SThC2F9hL1v3xMGKyfCcd10upOHzNqO3n4RHsgBeTYRIofTbhRTLx+VXYMXhev7oHIf+WNdpnRSesM1xcoimcXPirWfpmWkD807/4FwtOgM5PAwGmHeFzX0UGolZQuzEOmDS2dfkmE2nnY6QfynNQMs3gUtREPOM3m9IC6aX3itG3XnYlEw4o8wX8KXxOWVK31gcpfc3OyLVH/z+e/DbQ154FV0aB3rFFuN4eLU5Tdh0IjAcWei9kQd24Ldovznahz2KK/AMSP1F7KYct40+7dddkmUGL0D7O5qDZPtzCCvEPwRPGSAcZUZpAOzlwR9rv6LDBWrzlslIO5wJXAY7FM7zyieDozZaOj7472gCXgHLBcdM8LgFvYfSnxz8SbVrGTbjCfre+DlH3UBKhShGXKQvZRC3/ml3NlfaovfwGO8idlKvKdEjCGjDAxX8cp9H/e6HX+zwssFWZCL8/FCvih6FtReRqAJkrP27QUvBFf3zqm3DtrFcRcETdzvzSUGGw1yeyTbhG/xsDIiOGNnlrTD05yXPLHXjzZ238MrW7PQB4C31hoIRLve7mMCA50KxATDXN1+q+bk51WUK/n+QSSMQy5zFiofVCW
 N1ByF6vI
 HkRuwiMtDo+dapUAIjjQynosPBi949Oxshg262ue5QuUYAWYTDFwgngWId0e1ibMZZryPqe/AW1cnwzILmenld2W3Gt0j+nEEI1FHnhSakDrN1Nykxb5Lzr/BTC0Lz6VzLATvzlzla3ADS42R/M9W78qv/Q8eTMWZ1OPIfH6k1kvSuLh2O0xaCRy+f3lc3wJoTjwSp8RQeGHfUk6z2ObrBQ8doLQEwNqA82WA4rp3ti3I48y91n+KG2qvYsuXFA2S0T7dBMV+/BhbEAYQMIBMW1OGFg3FTDzCG4iqppvyrOpELTfhzBks4fUereu4tFSHOK3nVI/dZOR8Ww1gk/oQvSrwJw/Jw7ivZBqqJK5GMcNc6Zy299vWvQxEisOyfe9gNcqQP+49xUr+murPoIsar0PAJgAJPOvI1MsdsEEZng1UWnbkLJKnjsMKdTunhXkb09gjllKnus7hZDVTNMduh6yNq4JpTLJXBhcFhWbHp0y/J22SCstJx3J5qjauiRTAt2uqKLtNxy21VxufgNbZU7+3yBiQcn3eQXbY9a4nfgHeHOetNsdGuriwlxB+EZ5XwWfetifiXhEyzelQxFWVgiVJIfKn/KURd2a/bcS2UuDAWCKxHcdAEba4eg==
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
v1 -> v2:
1. addressed review comments from Christophe [1]
[1]: https://lore.kernel.org/linuxppc-dev/0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com/

 drivers/vfio/pci/vfio_pci_core.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d43745fe4c84..0967307235b8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1670,21 +1670,16 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		return VM_FAULT_SIGBUS;

-	switch (order) {
-	case 0:
+	if (!order)
 		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	case PMD_ORDER:
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
 		return vmf_insert_pfn_pmd(vmf, pfn, false);
-#endif
-#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-	case PUD_ORDER:
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
 		return vmf_insert_pfn_pud(vmf, pfn, false);
-		break;
-#endif
-	default:
-		return VM_FAULT_FALLBACK;
-	}
+
+	return VM_FAULT_FALLBACK;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);

--
2.39.5


