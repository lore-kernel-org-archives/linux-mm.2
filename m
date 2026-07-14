Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94422C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1335A6B00F5; Tue, 14 Jul 2026 11:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4616B00F7; Tue, 14 Jul 2026 11:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED7C6B00F8; Tue, 14 Jul 2026 11:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C01896B00F7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FCEA1403DC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:25 +0000 (UTC)
X-FDA: 84987731010.02.4620BF4
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6864F80006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h7BI9Dt1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3ilJWagcKCOEYLSLQVKJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3ilJWagcKCOEYLSLQVKJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14GlidItFhGsteVDeFZQr0b0Q8bnxkhoEthNZJCEcqI=;
	b=aa+qeHwBMcvJ9Tuoy+ABURNrsiFRgC8moPd30WRfKtasBwXhCERdoyUQTZQTGKDTy/Zi4p
	JIE8IYQ2Q8sFyMRR4Y/saxXi9PUVcfd7bMKxqJiPq/J61u/VXM0Gy5S2gFxlrSY5DOselg
	s+4ye3cn/dMrkZxoQkeaqReWS4+BSkc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h7BI9Dt1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3ilJWagcKCOEYLSLQVKJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3ilJWagcKCOEYLSLQVKJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042123;
	b=bWGJ/039UDCjPkGtGC6BcJG62zwKNJPT3VhDz73IMYzflUYlwk9B+3E8ojWWNoXuQR37bg
	PxiPHPz2niNtDn08zz4MfqsLry4i04Cg7fkQwnlPJxKnEQCbNdaLfu0IB2qv/oZjwRJOdg
	3qtHY26mj1JydJYZ3S8JCNYMf85SD8I=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-84870e7f498so5237379b3a.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042122; x=1784646922; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=14GlidItFhGsteVDeFZQr0b0Q8bnxkhoEthNZJCEcqI=;
        b=h7BI9Dt1NOVHyTJf6e74ZLXyOePhBctC52jyTOdkno7tMBz162bESwnbppx+s8VubU
         trMqRPFAejicnMN/iEAFCItV/IfBt/JZySKa1Lmwo5MFCnJ6nqhdsXbAY5+qMig7jewY
         WtqVT7i0FB+0oF6DTL6QWbQ2DjK4Rv78WseMj7xVS0DISeCqTXtihwTWm0kKqiVUBsy+
         UACjkQMm+pfWlfS8SOP05QBCjnxP2dDIjB3ot77e6xTCT59avFWUJIxvsgzUmyRaRWhE
         lVOzglYPtB/YcCwBq+E8NCKUyv89k9clsast3sGrMi7FJ8xi63Dbqpom/uSMIAldPave
         TREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042122; x=1784646922;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=14GlidItFhGsteVDeFZQr0b0Q8bnxkhoEthNZJCEcqI=;
        b=fSb34iQPpvXAuLJo6dfe5397MZ18PdVoDzGFJewe8aCAU2mq6qZIz2dhgBjJrqkIjx
         83XNHH6zLWCZo/xX6ViwWqEcqTyaFIjYW/yaqvA9SKjplNUmcjFwuOkNs61uCE4vqts9
         TcBgjL1Oc9EvbiMwqOHmmaSt13jKOLmKhnpcwYJEYrrOkWMekg3fjSc1Din7gi1BxaL+
         5xz21oldqqLbtGLMz1uYZwNZLlg6b7Ivim6j72k9x9w6Tbiuj3tVukrWoCXYeHE4y+t5
         o4y5lb9PyFIRSTh75mtvvRbHya5kJQdwlQg8UhO8ondd1nJ5jNml9/fn8JdMNmOOywXD
         Bg/Q==
X-Forwarded-Encrypted: i=1; AHgh+RrTMz1U/pXvTIv/Mi70xp/HRWzynpdibieRl/0bq2SXtZrAq5LPGtzwnZpDk1zgTITWXIfpKkPPkA==@kvack.org
X-Gm-Message-State: AOJu0YzmsN65xi9D1DaH1iE343CkjgVzqG9auRn57L+NL1yaMIyoibZu
	3KulWxST0a2i3fZAB0IAdWls+fvB4uZcL9koiWbcCdNHBXxQmS9Dgqy71Mmz2vw4jwOAqE2YPJf
	U02lXw6H1Iw==
X-Received: from pfoa23.prod.google.com ([2002:aa7:8657:0:b0:847:99d5:ef10])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1ca3:b0:845:d286:1fbe
 with SMTP id d2e1a72fcca58-848897aa414mr11307298b3a.60.1784042122068; Tue, 14
 Jul 2026 08:15:22 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:57 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-13-vipinsh@google.com>
Subject: [PATCH v5 12/20] docs: liveupdate: Add documentation for VFIO PCI
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bo838hdc3opthhneo8choeoa6o4pwj4s
X-Rspamd-Queue-Id: 6864F80006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784042123-791669
X-HE-Meta: U2FsdGVkX1/E12mKwryo44yghOxN4aIaxGW26jJsGTv+w2uXaPkkWejBGhNumCC6tGitC2Kx7LyR7FbI95f4OufqOABBTFeHwKG+C6bDWYXxpfZNL377/tktD4JX9yfUNESNa+Q1NWKGBDcK2MI7Ks2/551Bjk4R9hLGrPYprjOrOm6WUMwGxc7FbPnETwmYHCTP/owaj3nSFc68SnHPRCFHRV+GGwzWtsrrgii7W/SSf/3vm+bqKem2Dr/MYeARuSjWDIEqLa5EyHSdH3I02c4GouhThphkpPvE97L7xKCevHHSoFkG4wZPzjmTIGFjz/oSxLAViXfbbzZW/tWJregpq49HdAfPWxBy4qYmIU60o2lQobBPeLnQRxQLqWR8QSRnQFvHpVtylnUfakLc1Uf24rZ2UXlSxuub3Itfb1sIhsW7doAzpNLtyiQHvxwm/GL6au/64oJdN9Z2yFV0e4iR11lVWu4ALAZIe1LrCoVhvRUM9IFuf3saG43XVGTRKjAzxzDTNgLd3JZVhmD08Oq6Y+7IYnksPaKUYAYphPCuetlh1Sea6J7k6VWr+1YT/hr0EFPMgbM4hUMrlf+yRE+DE1iC4De2KvlOLS7xgiZyCgGMm5oHZomTUTJ3tm7tdISezXtm5K3dRcdL8H2lMPN2TKkMxfT1d1BHdTDkYz00S0ogYLUD7iBTw42vV4+5Cn3XlIqykko3HQr7j/TKFKoPh+FtZIPSISZRZFxv9Pdfy30P3as1Bt9U3kIGWL9tTqfWM8jLcyC0dzEDfgVhPl+IpkafdxsyjZhwqlvC5Fk1aEs6/Q1CD2EfNHzgRtqJJVvm9rW7wbONMxeX/QwULbULCXz2V9CHoJ8rrY++YG4G8hISiEee8cGqH9iQt8nHZtZGvxENn4FxEz2gp6Fi8cdecMXE1Ya7UtXdkA1Wjz9c3x5PNH3QFP+AoouIhHfz9IBrtda7WuFFGtubSXR
 G5k500Rd
 AwT1fq5QwqaKpiCUGJeNOgnwqscY9sRCPtmJIX5nv1tNdHoS5Mrs/OqVPMX4iLNF6TNVqyltq3brIuLenNm0IpKHqQ/5gD1Xnv5JJDTJMWQYkZoA1ZMtgCY9v1SCey2DIj+QFK1vI8iAyC8+7MzKDenGymI0qjT9A0YMH4LClu7RXr/kBVtUvU9eWol84Z5ITpRPkiSObLtI31u3o7qe9DIPCovBoQ7mG250U49V9oD2vyR5zJkxY5pFtvEyvS6GgLJrCVYECTOQgh9Z6cFbIcjebrMBNRGAu066Ml65vHkBMcpiWsdTPXvOCGh/gKe3F6U13Bv0rKqH3bDaivaZJsAqUsDCkYJ8nYFiZXTXecv8TBRcN3pXxGHZ8jXoKsgZQdw/pCWiokUoOXY4AaZozddZanZ7VHqEMKqVQRCNjZceDKBqxs8K4rM0OzpLqEz/tWDLkWohFALB/i3Pn9iDd3SBI/6cWGQXGDX45HRF03vUrwKdINvo0VsZlkuF1dH1P3gcgqUw2QSxdI+iC9tb+KXGQoRYkWRyiqOfRohB8WOvODWdyX1FhWEMhNPRf4uT9UAbs3xYjEuFXsrdN/44rOBfBNqjIP1fhemmgihPlBz3zXeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Add documentation for preserving VFIO device files across a Live Update,
generated from the kernel-doc comments in the code.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 Documentation/core-api/liveupdate.rst         |  1 +
 .../driver-api/vfio_pci_liveupdate.rst        | 23 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 25 insertions(+)
 create mode 100644 Documentation/driver-api/vfio_pci_liveupdate.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 2bce2644eba2..20f1d2e20508 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -38,6 +38,7 @@ The following types of file descriptors can be preserved
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
index 77a35742de0a..43b3165d1c68 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28328,6 +28328,7 @@ T:	git https://github.com/awilliam/linux-vfio.git
 F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
 F:	Documentation/driver-api/vfio.rst
+F:	Documentation/driver-api/vfio_pci_liveupdate.rst
 F:	drivers/vfio/
 F:	include/linux/kho/abi/vfio_pci.h
 F:	include/linux/vfio.h
-- 
2.55.0.795.g602f6c329a-goog


