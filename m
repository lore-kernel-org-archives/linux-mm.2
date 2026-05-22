Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BD1CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B736B00A7; Fri, 22 May 2026 16:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4A66B00A8; Fri, 22 May 2026 16:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58AEE6B00A9; Fri, 22 May 2026 16:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44F456B00A7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07A87120442
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:26 +0000 (UTC)
X-FDA: 84796183332.27.3CB8B0A
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 46555A0002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hMk07G96;
	spf=pass (imf15.hostedemail.com: domain of 3drsQaggKCIcoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3drsQaggKCIcoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jD8Dp8WjVDfBtyvW+7yZYOtj2UMzN2TZIRigqz140zs=;
	b=GVbivwprgDvtKnouNM+K8iLEwLL4MEyqYEax3BZQ2ixoXdLhwuVfBklpmWjoj9Ir1ctmuo
	dFQ7SBc42XuaYPXllZ6GW1Ll5xD7k3KfxyQhbcyKMdZVYMzi0nQSiZ+IG8kGmymGqGWgCU
	BOoz0jTMnqPfGARvnY3H2y8uN8C702U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481464; a=rsa-sha256;
	cv=none;
	b=gYPf5dJP5JR9zqAyAmWhgf/txe8fdDYfb2VrwVosUkaHCJJMJ0ujpFTzNrj7+xLUqjGJLO
	cW5c6gEJ2SNaPbsScLm4a4QdHbLkas0YHbcN60y+PQdzL9WAkQ+6rp2LT75VyHXOKaaF52
	5jYq4iFgMFrmYD3AgSX75Gsqaw9GWVA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hMk07G96;
	spf=pass (imf15.hostedemail.com: domain of 3drsQaggKCIcoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3drsQaggKCIcoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c8276c91addso4304420a12.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481463; x=1780086263; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jD8Dp8WjVDfBtyvW+7yZYOtj2UMzN2TZIRigqz140zs=;
        b=hMk07G96ohXNJN5MBUqZTq/OFIuzsR2bxuTZCNowXkBAd3J+2d0tHlZOyFACmZLKr/
         Ssmd1kjQFlE0nA31OAKIopqHpjpqUScg1VfJIFNuRZ2v7wt2F7JroNJQNREAhzIX4thF
         eHpgeT3EJQedln2NBWQJXd7+OQM3E23A3CcHGgjxQz8PT1FT0tYAddTp/jWJZBzK7Ss8
         mpuqJkoom3probGHQ4aDJd5NygKTVmvqHbzPnphUU+0XuCKgcTiF7IvRNIKbMwPo8O7c
         n0liyth4sumlKq4nxxID7KM8urQxCfqF8SasyW5dGjlHEkf3tTgo14tH3MWtQA8NZmXh
         vIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481463; x=1780086263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jD8Dp8WjVDfBtyvW+7yZYOtj2UMzN2TZIRigqz140zs=;
        b=diXtvErryqAYoRyllUoFxFv6DBbQNip/H7qj6LDKxVxvN8GtqXdgXPU+tKNsF+zcAQ
         KmHjtdzWohH7hCzQvBZU/k/8Y4VIE6y4hCCSajCTSNdOvlHm+SV1RmQpVo6alq47oggp
         uKxV/5AqEDjnf4q8JVXmruM7uSCrBYyIRVFuxRfEclLzmy4KorTKRkSXOYel/OK2O39p
         OMqcukDRM5fL6Y7u8t0sN9GDpphre5t9aG8TQ+x39DFgYiXvF8Uedj1LK+NZIr88F2u8
         ngNSWI/+qyai0H7ybs725CEC2MFVnnwQEsmL9izKx8FXyxhTaiRbRtGFBKhtn5i/n0iQ
         jkJg==
X-Forwarded-Encrypted: i=1; AFNElJ/lr66sDX02hZmEg1wxFKXGfzGGl1yaxYKvQ+HSdKL1AqjYoYAw1cktyv4BT0Sa2MgfR8DBBSjmug==@kvack.org
X-Gm-Message-State: AOJu0YyFvycJPtHqDw1bqZ3BHN9XrqITU2iKOBLOvQbqR8xdnj8Ajity
	h0gp3wfgBQbiG+wIVo8gnq2IstCgYd9LLyzOX0AZExu2YrEhhmd3Dqhnn/lHu1bLOHi6xDhOmHW
	uneD0WalB9OWR1g==
X-Received: from pfcs23.prod.google.com ([2002:a05:6a00:6fd7:b0:82f:6a57:a9aa])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1c8b:b0:82c:7f08:8826 with SMTP id d2e1a72fcca58-8415f15b50emr4877330b3a.17.1779481462682;
 Fri, 22 May 2026 13:24:22 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:10 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-13-dmatlack@google.com>
Subject: [PATCH v6 12/12] Documentation: PCI: Add documentation for Live Update
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
X-Rspamd-Server: rspam11
X-Stat-Signature: h7fsisqp6tit4mnqdqimxsj8x3qwaat7
X-Rspamd-Queue-Id: 46555A0002
X-Rspam-User: 
X-HE-Tag: 1779481464-56775
X-HE-Meta: U2FsdGVkX19HMrHvmG2Sy3Q3hYR4ALT+rsGPPfiXQ43w9S7sbzKXMsQcCusOAoMNMj0dk67YT3uPiCO9b9qXCbx5AU62ZAsyotCIsMBQohJvzrWZySoHWs6++tELlv2hgZuxxx7qn2V5gll1txQoUhx3jH5T0OHzH080RsUAQCf+uIeqIkKpZCnvuVYU914tEe/BkTV5fWS5TCkLp73yJOBDXfiHxdrlx95JkUdMotWPcyJqBKrOVIzR27npkdgdR/huwaAjI5AK9iWitR1/D70Q5/L2Std6AEXGeazmjTSaPscMfScPXekf1hbuX0hAC9+6CvbXlB/Z8npXO6wqp1SLpR4PO/L9lPZtqJbSSO1SvyUjsTSoFu+1I/AmvBuBTiBRcCdMd6BjrvMZm/1Uq5m5Jfs123X5ZBe4We7t0g0JD6fqYDnuwSFN+BI1vk96s59+ZG4c5R+TZOTaORoaG9Q7UERQWfryX9VFT5tWvbMDJl7ig/fba0KwFkSUdP6yU/zSxHDAz1+o67aAqPI4SQiFev+ALpBN6zHvP60swqcUFmb6CYHTKPjU30Ak/n10QPWi8AMhCIetxNedxdxZEn9EtmlO9kkPKAZ6KlHRloZGL52xANploB+imzQzcZGVOfm3yahm/spFk72vI3JssIMPyoZwTlTJBJtgdZjJY5HkMHez7z2EI+N2c5GoAMN498QAxbiHv6zCH58pZlmrzKkq+7qV+kD461WWWCCoQjSoDbep9Mfpjb/7gIvhlNmyWK7JuBIk6SHfp99LrjWj4ckcJvpIA47SE/AACSPPaiq39E9nAaZJE20peLtJW9cWy9W4TuOP7sBspbVUeE1cSMwc9tU3h/ogN2zD1B6dIbDd6lQkT2eZJhKJy699KUUoo7lgYQVB+AE+f7SYcsUZqoK/8Nr5bwGzLpPkcHeDdZKXIBTWq4b4Cmqr+XaraS8+gpSdSDLaaDUbiwXRG7k
 /8YSxXHZ
 hxMba/Qvlk0Gc791EdVMW2sj+a4HWnT5pIWnMRQsgTdCUdbRimcb1W+KuuhBoaRc6Zs8Stoh8IR4nCpEAPyjGXrP/SesgNRVzycvti9T0IBjUXWPv43exV1BaMVqwvpRL3eSahpy+uiQe0BB2r6MinJq0AQu1sZ2IC66CAQXPLTOls1JQ45MpZx+yOEmtsVHNjluDNEIDDTNzTLbPKWiI/ei5hIybcJuNtlhenfXn1lU9o2XwM+NrrBhnS4J8ZNnwGjgakBAK1NJ2PPZsQlwhfWGzJYZ3Jmw6JIDykpbMdhWeAoEH4XSX1KmQzGAFkq+e/POT8EODxCd9Jk8JWNiPjAekHuD8QCq581iLmCyuJ7n3caIGlM2IUGXVAwzUSLJsV5h+rt89jgO0R/F0spjwnJCervRIboDF7J+6nZuz1jWrh9iWNFHPwPLW2wnpd+5n9vMnyRu3eb4bIIgcnxpaDb8IoMyNj51+0sYY6d1qJ0bTbOOD0Gt56XV8omlrQxjnxVZYA+iblSG29ui0XccoEIfXZx3tkrCC947SNgfeqhOvhHe7s6k8YaENbIDtwKq01CDJYI0HSYySdSZLwZaWq7TiYn6kxLvSA2khl1fUtqJsK5fa/SUevAorK/IjwKLL+5LzmQ7R274FpGnu+T3xiip8hbS3F56exUOOlmX52NvCOICTLTj01LPM/Lxy+M+6U46aM2mWpA+THqqV16tvsAywcf8jKz75jFrM
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
2.54.0.746.g67dd491aae-goog


