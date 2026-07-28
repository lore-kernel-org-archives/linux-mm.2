Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FDEC54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520C86B0096; Tue, 28 Jul 2026 18:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E026B0099; Tue, 28 Jul 2026 18:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36BEB6B0096; Tue, 28 Jul 2026 18:10:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 011B36B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38D3D160525
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:27 +0000 (UTC)
X-FDA: 85039580094.24.EF9A3C5
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8AD4A100010
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kCLzEAOu;
	spf=pass (imf05.hostedemail.com: domain of 30ChpaggKCCEAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=30ChpaggKCCEAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276625;
	b=XJ4M799uRPup34ZUqaSnvlcppCK2o9e1+9ysq5I+VOdvoJLJ3ktFAP970zlUNAcBD8Sq1Z
	cVgYfbNMQdWJ25oT0EMeCFdJffkQlR+Ti/UFgRHyqteEmtfUVtXjngSOffOYiOTVUGSYAh
	rxhe3xqa/UTdiVYZiRRSVDIeSNtCnkw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kCLzEAOu;
	spf=pass (imf05.hostedemail.com: domain of 30ChpaggKCCEAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=30ChpaggKCCEAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5wUi9z17xOtf3gvL/6/TpX7uS9U+gRCHP4vdmTrFsk=;
	b=WGT7bz9fX5McWHbrFPFXGdD4eXwePUYkchozP7wdrGeyIiQKK65iaHbgSQnwdKZplS7Anh
	Blhxp1rP7Krf2cK6XZzgQWNjTzjpGvOB0pZYaJZ1H/UQ5jEDnhwzo6JK91IhSoWKhenC2Q
	R36b1GqCe6ds4V+naAxyprRQ3s8D/Qc=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfca8558d2so4160365ad.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276624; x=1785881424; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a5wUi9z17xOtf3gvL/6/TpX7uS9U+gRCHP4vdmTrFsk=;
        b=kCLzEAOu9n778nSXdfLWO8l7m1Q4ewrfA/FG8RPTb9Az11hfm26Ta+QqWtEXrnrMsx
         xOVcI+W4Pr0zhXyY+9SA1opCZgSHGNfayzYtEuWdcqR0XGNaeHLCQ/btRdc3zfv7Fz7U
         9cXv3o0D1ZMvX+n/N4uXuw34fdM6FvYD+xJm9E7IKRxxGFc5/IPjrtLfYFgBzyl+3yTr
         Jd8+/jHLaSbxNfWew9bMlmyVZXKGYyjFSyXSBNGASRM5DiUFgxd9oW+/MsGz64Mzw1gB
         en5yImT24DSHGbjMQ3B7fQxRzzsPqouOgPK1IDZjcihlA3faIY2kKEZO9VLxvG0LjG4p
         +k7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276624; x=1785881424;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a5wUi9z17xOtf3gvL/6/TpX7uS9U+gRCHP4vdmTrFsk=;
        b=fEiLT0FytF+KBPpjdqkqIlQKItIWXnE89oRFF2YYp7ZGMXwZh+ChFKn3yFZcyauWSy
         m86SNrapdx0TZDs+sVDMeOu/F1RQMwz+QKC9ncgGzUTagH/gEDymQ8TU/UlmoPhK+GFZ
         cwSQjbZ4g7ArsC3G8TBxEhpcp0gPRrE0xULmM+HbvPHrWFAxm28OYxaPSTPCfQWh6wdY
         IftATvdxGerPdY5wDDr3jwX5/+R1ZZK5ggcMC1y12BEeAUZYwEFK4e3m2JlYGiTbHO8W
         gS1GhrW4xIQigGwuVC1tXksxh+gcfWm7Us3Za30lc0hL6V+evCv/cMuU411zcZmZjrRA
         PBug==
X-Forwarded-Encrypted: i=1; AHgh+RqcshzOlb3xWe7DHa+tpzxP/8ehaH9soctGMNd2m0nUDFpsZPa1j++RjaC0jEWynIEOtFEmAEpo3A==@kvack.org
X-Gm-Message-State: AOJu0YwnbcNZDUl3K23dcEcQkcc9R+qv/T6YJ9EmSQE1D9LQ/JbvdsVs
	Polk4Z72EO1Cj/eHds6vu3IkySqQA3Sk+g4AwGO4zAnnlgx8DQZ7f41XscuPcHFmC9mJ4yZ9vLu
	QQ6saMz0NNDYCOQ==
X-Received: from plsc18.prod.google.com ([2002:a17:902:b692:b0:2ca:f412:48ad])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2f0d:b0:2cf:b68a:340 with SMTP id d9443c01a7336-2d015abe547mr50357375ad.10.1785276624113;
 Tue, 28 Jul 2026 15:10:24 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:09:58 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-5-dmatlack@google.com>
Subject: [PATCH v8 04/12] PCI: liveupdate: Document driver binding responsibilities
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8AD4A100010
X-Stat-Signature: 6gjgtjdtit5m6hohhkrc9odoiehqpa9o
X-Rspam-User: 
X-HE-Tag: 1785276625-675223
X-HE-Meta: U2FsdGVkX1+bIod3VycpwB/QUoZP9Ho/OpAZIQ6i8jX45XSCF9kLFDaNbwBFz06J9lbZh1UWaxpf2DrNHf9e0pqPA+qUCmS3CQIwklQAlN2ajWpvKUGQoWMIRmBTSPhR4+75gem83nncG7pvgdDmx090Wyy5pgqeOWHtO3HM7SmVlbQgzKLkUHvFBaz2PX6VbKhaRtSgxz79Mf/DDU+Q2i1TPGSVXEkdu30oag3d6BWWNkrywo1/9u3Nnc2IGooAjuhkKZ2XvNV1amu2rneXvBa/s4Z/xpucqc0hjrNPfPBbpDwWhyz8dl3xpnGkROW+uhtRCnhRhOLLvX9XDHMeffLEXqEWpzD0FFmtDEfqkzb4baASqmnbMOtPRRS/e020L3XNCMz+6QCudQRriCbJfJP81UUE461bKk6AGi2JdAy2QXrZyI8QYhm4to+Z/NJDYxCJRfzFf8bVlr4tCrTAUbA008PlcNZkgOOn2owJzav4+usF6khLwu7LZ+WeEsOafTIL0KZAo/R1h5ZeS4iIG9CSnQ30X7qXUVLQAjA/ZpytBbs1Wh76GiFJOpTU2QCjROW5ASDK25KicsdYwxW7VdB3fEtGDYXHIbo2enMlf+R9iLkh6a4T9h5xXfZxaoL0MUSYqiOW+y3zJNG8NKCUTvMvaDSmJVf4iXb2rVrybkCfMfQfMK96l56Yb6rxxNH/ARJ0VKtx3+vAkoKMTFZ8V6sl0Wh+DVrhRz3jnhKIT6siinsX1IQbvoNBpa8NawA3bbXXqt4h8DkSo3c2r688lQvS+R9HmcUgItAit1dp3SDe1rwejewxF/TZpfXq881wa7SW03W3+ltk8j2h+9VwOq53DTjwHSlUVe6BwgK6fxcEobyfjzNQ0gIiUmd//QUyNWFzJ8qCTLh4ZxU6mHkOIUpcomSA+SYOSgxz7gc9I/3Ti419gK++PDia84ran5vdM19n46OwGK10ZjdrRfB
 3Dd9r41X
 qmuypXBcc9ulPNi1Nwaqe/46bKDdbH01yqY/SsJt0ZXFAxhSlvYyTf+nAZ9kahHnWPZwrKlFlP0sZPn6iIvKyd+p7ZKsZC8/GKOwm+//jyrCbb+nw752cyeZn7RFdG1+fVd1zisbVdrQg63HdWFxUVb/aC8gWSUNDEJpCLzyq9MuvkXKcY6SpnTRISp2WjlaIJPDnIIlQhVEQ17+y3bWZ2G/gf6P7cDUpyxpYFbv5hB0IrOcws3bwsW+Sf9L4fsz1+X82oljvA3h1vZU0g51AUlqVQ0kiwi0U69PXoyTgMhxL2y03Q09M78MEu6tjobTRhk0IKeIUA6WZD7X81zffkzaroGLVH0kXvPHxW1NkbjbYFtAzch3iztQoTXduyNp3/GJpvQm/KG5UT13DaTVMfJfNnwANcRemKJ5oUUnUf260VXSXzOx9cwSti55NidXb0klnfG8GaOF8IZD4c42hx8Ld+sgyC0dIDJ4yHnM8RkJfolUVMEldkV5QUPC9EyJJ1oRwYjzwlafD1bGWZr1ycfos7ZambTTL7n/bqZhFWfBQ+z6rqpd6JEhmbOn072KzEr5xj/FPdGdsu8kjVM6vrbTQ5bOuBJdxjaVuS1b8kFM+BRJhtbIKuAa1TT/eXERjLY5df6X6rGULj0HYxa9d2EpD+JQShviYqmMoaw9bYDzTtnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document how driver binding works during a Live Update and what the PCI
core expects of drivers and users. Note that this is only a description
of the current division of responsibilities. These can change in the
future if we decide.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 5ce5f8b36902..0f7a018ddc66 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -71,6 +71,22 @@
  *
  *  * The device cannot be a Virtual Function (VF).
  *  * The device cannot be behind a PCI-to-PCI bridge.
+ *
+ * Driver Binding
+ * ==============
+ *
+ * In the outgoing kernel, it is the driver's responsibility to ensure that it
+ * does not release a device between pci_liveupdate_preserve() and
+ * pci_liveupdate_unpreserve().
+ *
+ * In the incoming kernel, it is the driver's responsibility to ensure that it
+ * does not release a preserved device between probe() and
+ * pci_liveupdate_finish().
+ *
+ * It is the user's responsibility to ensure that incoming preserved devices are
+ * bound to the correct driver. i.e. The PCI core does not protect against a
+ * device getting preserved by driver A in the outgoing kernel and then getting
+ * bound to driver B in the incoming kernel. This may change in the future.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
-- 
2.55.0.487.gaf234c4eb3-goog


