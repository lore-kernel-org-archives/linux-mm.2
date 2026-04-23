Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53EF5FDEE4E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D336B00A0; Thu, 23 Apr 2026 17:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7076B00A1; Thu, 23 Apr 2026 17:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24EF6B00A2; Thu, 23 Apr 2026 17:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E18B76B00A0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5EA6160556
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:42 +0000 (UTC)
X-FDA: 84691097484.21.372F720
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id D73131C0009
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P+wROE0q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3243qaQgKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3243qaQgKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979420; a=rsa-sha256;
	cv=none;
	b=i8dbcha+crlPuUMp4Tn/XeSKEAn3Nwn0ObTmXe2U6ktZV0NNVxXsrOUdp24no/t0RAAJXH
	UdiHmqWNADZDr17RofGpjERt9TVJ1Zi3hoxWaMalhlSkU+bIpXWIczqdtX2HFOh8KrtuLZ
	6UJkpnv9Ypdr7Civy/5+Tw4Xt3PrL+o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P+wROE0q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3243qaQgKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3243qaQgKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4E3v8P9Bgd+PvGMRS8uoO/TIv3RrWRtb2HfczKdNV9k=;
	b=Fwb0vnNEfMgwSVqlgFKUnA+v96jMaDCunW7SwXncWwDRbX23ul7kP2O8aMCz66MoxsL2ln
	rIvTbCbUO6HUQbHbblWTgGRTeYfaEYj2KNv07AqSys0H5qeCVamjZw+6Q9f01o5GDJ0sQk
	7S7l13zVxgCSBiIZnGwKQjxhRZX/vKk=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b242062308so131716795ad.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979420; x=1777584220; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4E3v8P9Bgd+PvGMRS8uoO/TIv3RrWRtb2HfczKdNV9k=;
        b=P+wROE0q1VCvTk02K9tfG46oJpCHgyntdpUqpKK/mDZCPfoKL/qJG3FkQ3Tlqg+pm6
         0ykmTjtENb7y2Q7665hhwzt7sxhUg7ZpG5A6AU8eJGaOylKzeGoq2CXUHeSmgwAZT6qD
         C/g+4GCtWst/P4vI61WYDATsA4W5ucIBhghZmg5h8nQn1XlKB3Elkw+lSdwCec7o/ldp
         21vkk9jVqmA4opPK3QKdE/Ncfjr9XYevisBbmF4Ix9w324gSWGVFTtlemfCIF1WoEOdO
         pTlAVBqTij14rRXfIqqXfx1YcQSZ9L9qUqDk/6Zm4Qd98Z8SK2NBP/n8PD4O2Y/gmTEK
         1PRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979420; x=1777584220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4E3v8P9Bgd+PvGMRS8uoO/TIv3RrWRtb2HfczKdNV9k=;
        b=PfidbRbFQr+5+sacLwuRE4ftrNZo0GlqdLvGqYk/S7A435KU0r5VXx4wOQ1wzxgxxV
         pN92wl6b+Vr6tAKaQMmX7z7izRUSAR059MF7r7mCfwJWMrbHph+PD+0su86dw+f3RxTh
         MSn2F3EmekXQrOVxcl+zKje7Qod55KdBCwhac6cV3+bdfkwLMdlWZyKMRfLtNEsXOLF2
         PprWqGae8gYAEdqdF4PO2oDXw5+sGzC8aq7acx6kGnaKbWMIC2iyq8Q7cha/3RcZA2zG
         GrGn+LwYRvLm1wBC6+Ao2vREOYKydQ/rHJHhadKZUxaBnass7Ml7NSWVymlRno3AJ/xK
         SFtA==
X-Forwarded-Encrypted: i=1; AFNElJ/FU9Yi53VQL9Ckd9HeG2VeL1ncvjmEowgf7ZLVFZFPpFqA33629f0HFn3LnAdBaU7m63wPnKfsKg==@kvack.org
X-Gm-Message-State: AOJu0Yy1gB3nQn9H3zAnEUG92yuzBW9UkozF5QHHZOusc1MyQsDx7Yur
	eYNHG1lMaxadESIy3SHeGqEORMRGyuqAarv0q91c9Dg1yo5yzaBqazM6DJ5paHGWWGy7MLdiBqr
	zLJ7KRnvJnH6AJg==
X-Received: from plon6.prod.google.com ([2002:a17:903:1a86:b0:2b2:c9d2:11fd])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2984:b0:2b0:4f9a:b794 with SMTP id d9443c01a7336-2b5f9fd146amr301151585ad.37.1776979419527;
 Thu, 23 Apr 2026 14:23:39 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:15 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-12-dmatlack@google.com>
Subject: [PATCH v4 11/11] Documentation: PCI: Add documentation for Live Update
From: David Matlack <dmatlack@google.com>
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Stat-Signature: kh13kjbzhbufbmsz49gdkimqobmb87i7
X-Rspam-User: 
X-Rspamd-Queue-Id: D73131C0009
X-HE-Tag: 1776979420-832222
X-HE-Meta: U2FsdGVkX19ejdDxWgrspxWOk8IHaZPOxawoPnQcsv55+ObOT7zQYWwg8tyVvlXp4h3iIzAgMspSaB6P/v2YvYAZXqBygY2v/Qe6jKwgTTceDVVUdDsU0mVrz5GXW3asB9wg5A1m8Au6n2c34FWGsXGTSWnA5+H32ke8uUbrGt6lNGcegU5ursB1fA/y2XnN/ANGIufK4fMPMqVHbVflz2AL9/60cxWuGmep+e3g6cErOwLo0Q9w73P+R0HOG39ZJ/sgnkO3Jq9HNvbll1Civ85Cq5UkTPJPgFJMklolQ5xhRjQLCU62SWOzA+l8PEE669s1uc4eIwRZO30FrpyZmGKknI2u52AQXZVG12OZNsiM+0bD1pfhdPxKb4visoZbvnRO9jS5ddcJgCwlwPTm5yQFLSgcFxPt8Oa31H8BaqLzF7ctzKAtQE74trGAAVVDOizsYc9q/TGCEPHHetx1Qrt/ij8cDg8VfRa0xMZyCLQQXVrzlSy43+fKvuwiWdwBWTjYOC4FqwgWNXznI+AGNJN95P0XvBmIwvo2FGCs4yH7lkiWFr7zMRekKJQd9AyGdjMHcUHowHx/YHDkqcfYSi7lMfXjyaOdzSE/O4YJYX9U2tYpRLw3pI7t/ENLTbAH9XGSdO200PbMa0xqC9QiQjo0pVdHexN3VLMQa4Sos1PgNlYVDQnuIYA2Zn5nczWnlIlcCKAMwgQq4AwEdsYITPrv+73EAQBoRsPvBbd/gq6m/lfjFAlkunJn0l/lc5BVhIdzsSEOxy0WSMb98AZwBOehkpGckdhIXJ6T6yvV8WE9YbEWeZf+Qe/hvk9wo9LHnZPbybIiSZ1mYvq4oSWJViidWgW+q62bFggqXk4r5dqTh39B9SgtHziTIlREuuqNoh1XHoSkdp2Fjp81Rl9LVlf65Ou4VAQOpIGfVbZ8s0ixCSM00m/JOJQvOVKEF9fQnC5ijm08pbfl5pj8F4M
 ZrVaROZq
 Xrmp3O9/b78PL2pcaSei/feOaePn05pt+ENOtrTLNCev//etzShJu4TwpvpZmWXW46y7jJnVCsExUtVqiGKLDs2EO0BoAavW+xi/r/uzUXR7vsyQU9RCNa4aekAbyOc2cr9yIYVVdur0tnOwn4xbvZ22NTR6mWE2jRuaDi1kfAbjnTUAnn+lOrggTndBWu+r9oDh50lRCfLSgydwO6UFj1wItGE0pbNKMaU0mi0U5Q1KV6NPl1CB7rboAF9e9g5v6cLUSXR3wQnuYEtqL+JbmNMde76LFDj4x4vj7CjBWk0nQcXirhwGs15azYdPSs6J6JbSzKvOjHF6I+vMZEbK+az6odcr7boRlRxgei3b++4cZeqfJ1v+dP1s7CKfzpA//Cnq0t8xwjGynA8IJzFxg6Br1ALfIHGrdmDjLgMVv66yPk/eYenVLu2s9TEyJfHIvYPIQ6S+WYnjP5uGxmUa84TVlbsi9I89vrrVJyOhS5ijEAiFO/RJu3BnaAsgWsa5nOFjCdxOQObUDyrUEf9mWlAuS90G7Kxr+KyVa0RjimjmN3yZOHH841Bp1ky3ZiIYqMU3HsdEz7fL1H7VUShPzS6L5p3eDcKWGSJd66PtAxP7VQaMwHg3dyE50LP7Pdl1PpoIXh2/twRU3886/SykdiWZ5KD4atDEzLuQ+oTBVfskMHbxnT4NBgqCNlnNXrOT53PKqJM1Rc3JX5wG3kiDlymfSr7UikO/lWBMp
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
 Documentation/PCI/liveupdate.rst      | 23 +++++++++++++++++++++++
 Documentation/core-api/liveupdate.rst |  1 +
 MAINTAINERS                           |  1 +
 4 files changed, 26 insertions(+)
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
index 000000000000..04c9b675e8df
--- /dev/null
+++ b/Documentation/PCI/liveupdate.rst
@@ -0,0 +1,23 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+===========================
+PCI Support for Live Update
+===========================
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :doc: PCI Live Update
+
+PCI Preservation ABI
+====================
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
index 94af31837375..42dbac2c2ed3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20564,6 +20564,7 @@ Q:	https://patchwork.kernel.org/project/linux-pci/list/
 B:	https://bugzilla.kernel.org
 C:	irc://irc.oftc.net/linux-pci
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
+F:	Documentation/PCI/liveupdate.rst
 F:	drivers/pci/liveupdate.c
 F:	include/linux/kho/abi/pci.h
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


