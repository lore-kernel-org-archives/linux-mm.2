Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21E59C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE7F6B00A2; Tue, 28 Jul 2026 18:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DFB6B00A3; Tue, 28 Jul 2026 18:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0847F6B00A4; Tue, 28 Jul 2026 18:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3C066B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BF1A12051E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:34 +0000 (UTC)
X-FDA: 85039580388.27.A0D95A5
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf20.hostedemail.com (Postfix) with ESMTP id 550891C0010
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h8YAfIaB;
	spf=pass (imf20.hostedemail.com: domain of 31ihpaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=31ihpaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcNE6apqn+AHojLUlXt2w6cBeAI0PrY+z/kXQXeICZk=;
	b=FzPYxLCHkM+tDl1ibbP/vpDFdENaIXUc0JxjKeYXa+Ct1pWh3ayNCFy92uJgCXn+j5Zyhg
	KqG/LA33EyunjJiTOserYwONDyAn5yY9sxOEb0jlNclkDokJ9XS4M/2KjKptAmd34I45KG
	q7SnxGKW0daNaAaRLf8kQTBfg1gTzg4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h8YAfIaB;
	spf=pass (imf20.hostedemail.com: domain of 31ihpaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=31ihpaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276632;
	b=rrJmwDDtNT/PS7IThRihgLTDYASrCP5P9//ncN0m4mC/MhT5MsM7PwxjuQwgl07ChxxppQ
	v7Jxw0oOg66tP8HYhCAfbUwIQiBO6lMxzskCCaxp/5gqLgZXK0aMiEf5Qb/czoBIFo+nne
	ApTNQ9WFJSC8RGP5X6/fF8ebT3KeXNo=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cacd6d37edso4493685ad.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276631; x=1785881431; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jcNE6apqn+AHojLUlXt2w6cBeAI0PrY+z/kXQXeICZk=;
        b=h8YAfIaBEIR/WTBdkr+j/RSKRmQnEgygDulLVWm9hIACqHeK4CXm1WjE7pvuWUEwZB
         crLrScuqeL3eEqpQhVv0Hyl5zy1w9JNUQd2hfP5TNowrHQiboQ6ac20yJqkFOp+IdhMI
         JpbdmDGVMAsMGpTFs2X/neFILpiVKC1m2EP3SITnKIZDqZ+jN9LGSShk4BuRt+u6h0td
         U3/0WEB40AkxbBxNXzbYpDBVNuSfbS/1zYiDt3aFHpbvzmdEyFgX0OfGGTUaeQbLWnit
         atgBGJXo30WRQuD/4rgdYEgh1bJAQLn7dEo2AkWkI8jVFHshAmeBkNp0+ION/dCot5Jb
         LL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276631; x=1785881431;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jcNE6apqn+AHojLUlXt2w6cBeAI0PrY+z/kXQXeICZk=;
        b=Y81CNsugmWbdmndmlH3miLIzFYkDlLGuudmLnAqf4JmmxnJki/QmyJI2uxSEE51ThP
         vhhLA9psPQ9gCHJA3l6Ewv9tNtHfNBlperp/91f41ZKcIoqigVrCIlamGe81fyZmkbx0
         kiJzYGnvvSOWys3eHkt4KoF6Y2cze61NH7nh1SU6G3XzEbGUUKoAvjqLEEwdEoswpwK1
         67R7Md/xouFZBrpybMRqESZtgF2YRBI4NOzdvp5ZkgeeKGxXXtfrw4s4/FqCGnpT6eVk
         dFDNY2JBJIxUdcLgzAFPq5ZK2Hee8Jz+ZETBBFQDyuNjzymtOtU4Zm2qp5BJk1K73TqG
         ukrQ==
X-Forwarded-Encrypted: i=1; AHgh+RrT0GYVl/DDGuiiJLxcs2Limi3yof3ygSbSB2Km6hFKKoC67y2v/oQD08vuegucqA8lvNGkEMAAhg==@kvack.org
X-Gm-Message-State: AOJu0YyKHv1OZ3I/uwU0v0nOKoRC6DoEDmDNxeCsBbUvNX3uAllTFwmy
	lonDjsZAScG+PAfJdctSZjJnLfAusNnjYjggIyKl5rToewOMzHxZ4miWCQeYhgL1znVRHTVajh1
	MAed6gn6ryW3Anw==
X-Received: from plrp16.prod.google.com ([2002:a17:902:b090:b0:2cc:9345:c60a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:b90:b0:2c9:df1b:e948 with SMTP id d9443c01a7336-2d015b145a4mr51662475ad.4.1785276630984;
 Tue, 28 Jul 2026 15:10:30 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:10:06 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-13-dmatlack@google.com>
Subject: [PATCH v8 12/12] Documentation: PCI: Add documentation for Live Update
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
X-Rspamd-Queue-Id: 550891C0010
X-Rspamd-Server: rspam01
X-Stat-Signature: uyeit9p6x6murkt9bisqwqrjezq71y6o
X-HE-Tag: 1785276632-394236
X-HE-Meta: U2FsdGVkX1//6U2rO7MYMiXQNt3ejpSKLdcTdocvgLZOCUKoZqoMS8mlYsS9L+8rdqORQXmPKIr+BXMegmit7h0M0aIUaVV8j2+eEnRvNAKOLXuNuBGlTyYH96THUfgyiPS4cvOZRDgWOMBA/6DG8emwytJePDGviRSpsA+D1H2EcQfEQo65J+1U7f1eA4v5MYneq/rfeg0Y7kuIehNa8DuWfsVBugYbJa+EN+W5MEQ3logygr7Up+9QeqsM2CxcJZs1UbIaUgHfWU3qYXrFbRKFTTnD0/6CChao0uLq0e3nZtBRdPVTQXEwD5VNuSTqUb31AMm+xocZ+cJVG9p+iZhjHsjaPbbhpx5tXQgtnbzJZF+zoTrAA0AZ1H/rR1x3H+3Hcn+PcFF59GdhprAtnGNFq16yKSRfNjFDBxelcY5ICs5f6qeCbNCe6yyCwOKbjsG07c0dWLMag96ZjBbJR9kN2emGC80ujNRbttBYOLdQS3I0Vk8+tknrW39kmk3pWLsfU7uGOturTj3wwzq7RRrRH6NUpbVz1mV4HUY2lqbD1CUbn3xIWJH2U3IclIZafWpzVvlzG9VBkA1A3DWOQttln83pNCLQQjzDlOkhiJTqtRClE/7l0SjVt/T/8KnqOgBKeryk/B0bR9jnXfx7dqNnZoFbiNewqSeD4VCu27PRFEqDbdZEZ+qlMYnjLKb79D1z2vbVZRGOej9B3KwYW+X/Fm1be1LWOH4eGC2JLoQUKO6u2hOtlfTMs80731myoM5DCv0q0fISDr1f8PZFwGTd3soDzEP4sW18aKbAH3tqehqe5Cz5pylXd3EXr6VEXJXQSYB3XEwqQL3Qc9f7VezyTaMWpsSqomx9vAfCqZR2MwxDuYoXtoZpUUuBttV5d0fkLRL1SCxhCsWVQjzMcLdYbuDUKulZ6MFQoIkZND76sJP2CuhQ0vuiT66eL2aCjLGsvHZbdmajI2FVLRD
 RXKYVQ6R
 smnM8dB4kzunS+kXmz6e9i8L+AGmmMey5Z3ZdqIful9qUFQhlljKkBwJmvN64W1Wsalpb0w3dVdHtJ/UOBwEXz+MQM7cAZ1vPbyilFm8MAIO4O0kdb4+BBYF4XAuO4ULEHIWWEkaIJvfO8LUORattKIvMP2FftI1RGP2qrDgEXRlJNl2IVWIcF5Biedi96yFCs8ttJVZseEjoYSAMG0nHjO4godoWctpIRTjRLte5V3hYlBbhAY4xJW9Yb74HtuCkuZ3yWn9O8zCIRCVGU9LPrh91+7twvCvM7j50FFO5e9641F1oSjBH7XmRebFyai9ZxTT/bhgdMeEZ5lmw6CaRV0rRdEXfzqzbgULYwMVeV/sd732qw2o3YBMxoX4Rfebzlh2OQJ7pcQ1IUczp8rKkzL0pwMGpzwBLvzuEOOgYtt4b3WtDqENlTDIgFidDGVciCqyai3nYbsMzW76FA+7CpsBR4fPobQcyn/fed5+C8gb81RRgpW6jH9TsgyUiB91ky7gxk8inunVptUDRu4dSFqJ7lkmluAISaBDbkXsYtkl7DDso7Z5bKNMeZ0Zkj48tH/rodpsFXGie8MV6KXoa0xZMJ55ncvpjrO0SaazL9mOO7BiW8ULKPKG3o4CqyNQdnf2x/cPpjGt1+MlJWw8s6gbuhdFVoz6JRpibBX4kyMzaGvk=
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

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/PCI/index.rst           |  1 +
 Documentation/PCI/liveupdate.rst      | 35 +++++++++++++++++++++++++++
 Documentation/core-api/liveupdate.rst |  1 +
 MAINTAINERS                           |  1 +
 4 files changed, 38 insertions(+)
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
index 000000000000..96b1d7f5df3a
--- /dev/null
+++ b/Documentation/PCI/liveupdate.rst
@@ -0,0 +1,35 @@
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
+Internal API
+============
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :internal:
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
index b3c689e633c1..2bce2644eba2 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -74,3 +74,4 @@ See Also
 
 - :doc:`Live Update uAPI </userspace-api/liveupdate>`
 - :doc:`/core-api/kho/index`
+- :doc:`PCI </PCI/liveupdate>`
diff --git a/MAINTAINERS b/MAINTAINERS
index 08a724b860dc..347c435ca404 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20833,6 +20833,7 @@ L:	kexec@lists.infradead.org
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/PCI/liveupdate.rst
 F:	drivers/pci/liveupdate.c
 F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
-- 
2.55.0.487.gaf234c4eb3-goog


