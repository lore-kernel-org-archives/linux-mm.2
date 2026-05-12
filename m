Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35751CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCBD6B009F; Tue, 12 May 2026 14:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DB26B00A0; Tue, 12 May 2026 14:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9FB6B00A1; Tue, 12 May 2026 14:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1C4E6B009F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:49:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBD4DC1889
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:49:03 +0000 (UTC)
X-FDA: 84759654966.13.BD6FDCD
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 130F5A0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:49:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BRRHbUFu;
	spf=pass (imf25.hostedemail.com: domain of 3HHYDaggKCG0OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HHYDaggKCG0OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uszo/pEOiCKzj7JLqUzd1dVCJweWOYTEHSWoFKhDRKY=;
	b=vgGim/fXVv+U4JO1oX8w+SXe3m/1KprkrFi1a7a2qA2QaVLJHkiX9mlhKh6Ee1PSnAjmp7
	ASqeSMUIvNLluByysbSFraIpRUm1H8V9xRU7EuYYysThqQyTjQ4OVkKhCMXR7Yj+qfbz4d
	1uprqAoY10QcJxsP3FQpWu2MBXqYQjY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BRRHbUFu;
	spf=pass (imf25.hostedemail.com: domain of 3HHYDaggKCG0OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HHYDaggKCG0OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611742; a=rsa-sha256;
	cv=none;
	b=OQLvBrjU/y26UYiJXeOmXth2Q15NfY/lTR56sgPtC7gwAPevIlOahXXYI3M70YvfsK7Vvw
	kNJDEGK3/0ebrzIcxsme/s4d5RVCFoIYh01AE2/Js6AImG8WS7GMI489vM+3weYu/GDij6
	9COWzkDXHeh63mdc3mfUMH7M+BsGkfM=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f7bec24fdso3535673b3a.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611741; x=1779216541; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uszo/pEOiCKzj7JLqUzd1dVCJweWOYTEHSWoFKhDRKY=;
        b=BRRHbUFuhci/RrI9Hk7WtZzuCKiRukVj4mjjGkskkdkuzrJw8bJKF3oL76/TxPxifC
         or8Bj50c6KHpjx7DIsti0evtJh5khD7Etfm6peaxk8V4QRoEL8Ra5TD8/XOMxPiiKlWl
         XzGEqvY8YpgfgfiG31FDAq8Ouf6Wpefxe4WQfYf4VOpVBGG6FHOfGM/yB/75nPkjYhGz
         fbV7RG6JmuN9a6ur0avkMn80zdYDuhOyzFACFre17H/BfWsNLpmqUYQx2w9paK/CsFQ9
         /cm3vrcDgqAIdVq/2sfGCbADs10fMCwOmZ7EMJnq7gdtjXF9mW4spdbA1mPH8xj8RBS+
         2cIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611741; x=1779216541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uszo/pEOiCKzj7JLqUzd1dVCJweWOYTEHSWoFKhDRKY=;
        b=jLdS8Z3oQAYTQ+j3/cZ3ZG8Y8rdr+gvhbyZr/TUerZEzjj0Yw+WqfOHwY7H4I06fgy
         /N3iD1SNHCWDGOkD9qePsmJBBho5UpO+3cBb/m3U6St6FoQawsPIUEiPQd8QN6h3F32C
         a7G0zXdkQk7/1OdDqQqSdaupOS7JBb6v11OWIIpArvBEGBqH7IZ+2/ZVtsHDasrro1j8
         LoQAxxPlPdtdZMNXbqQIJvpKKstkzYR3GGhZK+yRHRfy8nNKrcCZTaVG2To/8d8/N37T
         Z2Q5I5bvJHegWlfWItuFXH0k5XmHCpJWhecCyF9A/K9nOAEMdetD4PwBjQqbIAcMUt08
         nwnA==
X-Forwarded-Encrypted: i=1; AFNElJ/e+Lafk3YJQwGo72RPSFMuGdSZf87sOKbR8WQg2cHmRXtSB4phPA4j1r6KZ1aTpaVkfdfNloNoUQ==@kvack.org
X-Gm-Message-State: AOJu0YxCyOB+hn1xg0LTxFKEQ1hsjOP9tNwIjvtvX/J3PBdScRcGBv1F
	cQ+8LCXUkENwZ5o7Xr0241LATjdjiGqtbO3mpHgZzhVdQofjdnSsPL09h+3SqGoKSXy6xhXALyo
	aiWbxqVp3A0rXBg==
X-Received: from pfll21.prod.google.com ([2002:a05:6a00:1595:b0:82f:93e5:c64c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:88d6:0:b0:835:3f51:730e with SMTP id d2e1a72fcca58-83a5b8d9aa3mr27781326b3a.13.1778611740692;
 Tue, 12 May 2026 11:49:00 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:46 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-12-dmatlack@google.com>
Subject: [PATCH v5 11/11] Documentation: PCI: Add documentation for Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 130F5A0004
X-Stat-Signature: hroknwje53dxkan7mmbfcbr11baacdn3
X-HE-Tag: 1778611741-266100
X-HE-Meta: U2FsdGVkX19FgN+z4usUznr82e97VVPWa1K0eldQcutakqbowMvWkzFVrDra9gOmjXnmSMocZCrazQJ3Lu08MJAUn04CZyQrhVt+8fUIuKfh42vW42lxMJdao6TOJKavRJfTDgK51NoA0fQFsK6hHRubLmokcoUgJt/XYiqWVGZhol9psTmATX9tdx70gwakv8A3RSO0lOGZB34EqJLJMAlf1kFERH/sWfuy2uG2ToAGI6w7AvcrIAI/bDR7Al9iG2xTeWGGHTxgSAd8VAQCyi1p3yw8/003wdipIbTnmG3H+hNCPBFz5xXF8NP83wfdpsT020HUfCW4hor3iaH2QQcMF6MVRxJ4vEd5dL3TL8tjkbSQTdwQjyfPDXjNfySHjfkJRz2KQBe/t+Ama2+7h/soRLhMCdjmzGE08xo/z2XGQyFj9kr334ZEWdKLIjNC4kfyQ7YPMDZGKS0rW5efk9UJ3cDuBuzgc9jXBc1XN7ssMVHe/L7zTY4H08MgFiFGOzOTH5aI+XFnYQ20UPc6PQ7Z8A+2Tgu1Gou6dY4IaSyxYKlyB7CeVK5FSOsrMxqcucEjiQfJPJWvM7D4bCKqInzo4JbRPW1twJsu8aueBGuWzSBQdwOjVSMl2euM4iFs1O9vDaZqw/8ARcaDaMrqvh917sHY1ZFAWQtLISHqrCCNmoauabevZGeJj9uSYf1HJsdojp5N3FZi+06wtlHfl0sEoUj+BXBKaV+2l8njMB0AJhMjYb7Ps/ov83dB+RDSNpTCzvetJuVGtLDPbyn9tRCsiEUAi2slQsCpdQvrd9HJQTTICQlREYXSFRmx5yYCxtQf0H9EOpYV9uZMki9nX8+DoBH14hh7YYycFpqbAKz+t4Moxl/iXOHHXGQv+8Z3oBiVEi/76Bt1XtAdo+sC1PpnngtGrKEtKYKa9qiQH3Z6HKWs0kzzNT2rPc56CpusvsygLta56hl3jQoUCFB
 xHs6X6oB
 rIGibwOnsQ/8DE/DBZDA1dbbx2sqDKmAfcyUvIj3Jf5Eu9ghb9FPfRaix5GZ8WQznI7zauFvbzS3PRwmIP+ERLNgKSCid6S3sgcNMsyiYY4scfi0CWJ2MVdLF5C2fKh8RJdyd0K7Yo0DRRdPfCU/l02LgaqsztZVBNy+QkLBYooh9/gE1mJqh3wvhbm8p7oZmAi96I1t5/7/ifllmwurBeXtBFkQg1QJvhKW39eoMq1ZyDk+omEnTqSLCG8TUTB+e9yDVF+B5F3CjDoHuchQYavrYiI8gRVKDtRTeiP/NB6Jh0xp3030Yxhlrw/AJVHQhL/NbUIsFefraHlhrkNbJ8nsEgfDJHu6dwiesy/eI1+aXFTcZL8NPQIIDSzVaBxT7eFg4Fd1XLhzQ/NSt3wZe4r24fgPnKdreZVbH8hDJZkaM0HKjvzQA1XM7lqfTydyIBaohmCkUNgrUlUF5MsRadh2/4nXp8uKNSaRqCVn2Hm+QUUtHj5N7JRddfa8nhdp/n/htH96FI00YzhmvJUHQx85j90v59ujoL8Xwlg0FWtr0oy9/IBbM6W3AMDeNhssSOy1dMfahKqPsoc6ZRGLnQZCSp2FwojrB9UrWG5BmdRFM0ZyBsXBJh3+QnBcON1LBqYTJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation files for the PCI subsystem's participation in Live
Update.

These documentation files are generated from the kernel-doc comments
in the PCI Live Update source code. They describe the File-Lifecycle
Bound (FLB) API, the device tracking API, and the specific policies
applied to preserved devices (such as bus number inheritance and bus
mastering preservation).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/PCI/index.rst           |  1 +
 Documentation/PCI/liveupdate.rst      | 29 +++++++++++++++++++++++++++
 Documentation/core-api/liveupdate.rst |  1 +
 MAINTAINERS                           |  1 +
 4 files changed, 32 insertions(+)
 create mode 100644 Documentation/PCI/liveupdate.rst

diff --git a/Documentation/PCI/index.rst b/Documentation/PCI/index.rst
index 5d720d2a415e..23fb737ac969 100644
--- a/Documentation/PCI/index.rst
+++ b/Documentation/PCI/index.rst
@@ -20,3 +20,4 @@ PCI Bus Subsystem
    controller/index
    boot-interrupts
    tph
+   liveupdate
diff --git a/Documentation/PCI/liveupdate.rst b/Documentation/PCI/liveupdate.rst
new file mode 100644
index 000000000000..eba55f8a92ae
--- /dev/null
+++ b/Documentation/PCI/liveupdate.rst
@@ -0,0 +1,29 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+===========================
+PCI Support for Live Update
+===========================
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :doc: PCI Live Update
+
+Driver API
+==========
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :export:
+
+Live Update ABI
+===============
+
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :doc: PCI File-Lifecycle Bound (FLB) Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :internal:
+
+See Also
+========
+
+ * :doc:`/core-api/liveupdate`
+ * :doc:`/core-api/kho/index`
diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 5a292d0f3706..d56a7760978a 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -70,3 +70,4 @@ See Also
 
 - :doc:`Live Update uAPI </userspace-api/liveupdate>`
 - :doc:`/core-api/kho/index`
+- :doc:`PCI </PCI/liveupdate>`
diff --git a/MAINTAINERS b/MAINTAINERS
index 0e262c0ceb43..6f0b0ebf67cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20536,6 +20536,7 @@ L:	kexec@lists.infradead.org
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/PCI/liveupdate.rst
 F:	drivers/pci/liveupdate.c
 F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
-- 
2.54.0.563.g4f69b47b94-goog


