Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6EBCC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB926B00A2; Tue, 13 Oct 2026 12:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293326B00A3; Tue, 13 Oct 2026 12:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181836B00A4; Tue, 13 Oct 2026 12:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D85196B00A2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D788A0CE9
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:53 +0000 (UTC)
X-FDA: 85318129386.03.22B7AF9
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8F93CC0006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HKaWngh1;
	spf=pass (imf10.hostedemail.com: domain of 3jlvOaggKCNsAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3jlvOaggKCNsAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908751;
	b=Q55IjhpoBTiS/PHVzCYl2SXNWhquZ/9M6aYWdVhvvaRvVGWPH0WFDWAeFoaoHKj93lt9Lz
	fGmLrU2jurJE4H1mx9h5eS3f2byHaGfVrlrSFh7DBKXVWVqntsv7rL/QY7nyEgs30LJuRe
	PV22W0kkbkY0tJp/Hh9pCGI+gILJG+o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HKaWngh1;
	spf=pass (imf10.hostedemail.com: domain of 3jlvOaggKCNsAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3jlvOaggKCNsAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWpNLUzvXXnBTpZNjknwwhw/as8BAKF/fqR9wquhzLQ=;
	b=R5ik8nfNltNjbd76We5jijjSHz1udubVe56qZwNTKPfGla5GlBHkeXFA5ATIq++eo06EGv
	tI74ssw8MeA6qO10eRkCzLtfNV2c7rY/7cG/O3V7o2VUGu9w38AHdJM39xBsv50gzJmGVe
	Fbjfi6FEXEPwPNzZOhU+VMSc228WWKk=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e83df1d54dso839885ad.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908750; x=1792513550; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bWpNLUzvXXnBTpZNjknwwhw/as8BAKF/fqR9wquhzLQ=;
        b=HKaWngh1YQlTUiVR3yPALHu7ANP3mbZodFMQxlB+aB9/lznG8JxI0PxoyF0iQ+13FO
         SKXS49I//Hn0P7O7zbEk2dQ9E3S+CiU/8g65so2Y7poHDXeE79ln2F1guF7sIytQKMnF
         7uSluafixkYkZkg06rZPkzDqjQlS9n0BpquTNiPqRNj8DJ2wnkKEcgXpr1RKrAx+oxXS
         E92KaCvx1MEWD1TtfWN9p3ttWuAbpYMIMFkliDTWp6kc96AaZlXUOGSpRtqW1YjpQm8a
         fZnkEailA9kQGfVHDduIn/pqLioJRYh4buxZlZOcbBLDuKk7FNgMMHF1Ql2bLo0C1irB
         j5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908750; x=1792513550;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bWpNLUzvXXnBTpZNjknwwhw/as8BAKF/fqR9wquhzLQ=;
        b=xmwitQUDMgZdI+UKMhFmCSsKPy8VM9ws2gwqbM3p4rWytkZAENXxz9kbLQt5Unwyiu
         6XL1K8G6hnaeRX9D4OmdVRCeTnL63jM8MZAghUms/m3e9/mZEL7YmDOMY4VA1NMM/JDw
         qnKHfVHpfjxCVkI/0aqQ03uBruc8k6FJMP/44I0ga50zvyo6NC5BDluHWeQUTWY+QWFE
         zYkgXrlPa4swxOaMzfRXq5JJTs/8UQuqqQg+F/7VhRJxOOz2V+ad1wluyl29v6tDwsUr
         sxg4Nret/Ygh21MEn/iTlBudeA+sTKtlo0Qq/Yl+ZVvvBSVU//BmVRGmJfTXZRbnoaBM
         qq1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwpRz1U/0AyZFWDklA9rTg8xFOTRNKNwNuVL80PyhQGGd2EfpSuyHv3lSziTG+ngMboS5wnV2ZswQ==@kvack.org
X-Gm-Message-State: AFq9FYICe8LqogJtVJ5ttoEu0xwnWuG2IvNZZxyExcBLeQkZ68cYVXKA
	Y3rDuLnzqrZ1pNKHSugVC5oInCRoohT1mrj9xvizlG6c9Furn/d5UeUAWKbOGVH3eNzQlFGr1/I
	9aH7gVzhJ+64jSg==
X-Received: from plnq15.prod.google.com ([2002:a17:902:f78f:b0:2e2:d223:8126])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2309:b0:2e5:38bf:cb43 with SMTP id d9443c01a7336-2e8427f0c01mr119406635ad.2.1791908750143;
 Tue, 13 Oct 2026 09:25:50 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:29 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-14-dmatlack@google.com>
Subject: [PATCH v10 13/13] Documentation: PCI: Add documentation for Live Update
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
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5cjxrz1coa43rxgnywuiqmmj1p7a7ca9
X-Rspamd-Queue-Id: 8F93CC0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791908751-887747
X-HE-Meta: U2FsdGVkX1+ddcofQUmBCqPmXdoYSurGVVntHlFzIcM/SthcVAZz57V5W4n5DWGg9iKAly1u6HyBSQqkOgd2l1hu0ATdQRlVhyNExFDz3Sn2O+f9V5TED3+qPfgDrfvyVPtR0HTZgNCgbI+IGurH1dh1c/17HK98w/2w1cFaVDOpNIjR3eRH7Wz8L1rqWkTIlqD8HMO+Zzo65W36WfCZNv6ivujWCTlR9/NVPCQ/mCVs5w/7mO60s7P+tAedUBRd7vvIAO/5v/snJPK6QehNbZHkzC3YCI+0pYDBRV6UTECSEqlwoSyUNvLA80eHTMTtW+wDf57ufRV8JbohyE0ZrB/El3bdqv5PTClL8YkbghcegQ8DCEC6TWdrbLxhtqC8l9GR0Aa8deeqo7Am8Xr4/egqKuJniLfr/TT3HEKy3oVmnUWGYgRLwGf/99Xo5pC80cxQIXeKgLewU8tRvzfQHCg+aCBneKs417atzFlkvSPchp9V2IlBDpl6ZySYgMLqBhAk4kfHDh4IVOmlj82KVqbfwyeccazBIgrB8d41wE6I7UgcWf115EAs6w8B+RfhJibW5tPAUWN9ksmmw4FdKkQjGWMR4ZWwAfzKG8MMJWggkRHCaJD6inLK4NyuhVRNGxDpLGViRHbuXfRnbDObCO5dSpQi/1ee9J2sl+jw4RmpnUgrdbO3pnPb3obYqZjTSXQLMiVCpjWk2xV5rtor/PqLGmalFTkyFLnImT9f1gA+korblvU2cOCM7sOjDkoZ/K4yXOxwk+kDFhK6sZyhDd3antMA3C3WxKgT78RSBFLYGWV3HEjItfO5FrrYuhOktCikzf0sHVsvGh1alTXLuXQo4qHvXhKJZo86B9PQdspXmNogR9nT532ZN6Q4jNH2K0RqDZbPVE5WJYi8L8CRXnVDIhiq+MTXVS0yM5tDvI/+x2FWsRle/q40tDpjiQUK/gOQyJuZnpZ+R6dpBTw
 ahDDbwkl
 eo3l1JhQOQ0nks/vYn5sa9Z/sqWbPCEtPb/dsBp8wduJ0fHKZYsPB4y96qL66wQmGOLVgpROYuQmxvrE6XLPqJNsUxeusS4BCln8L0KunVpGv5OhQA55OLU9k25ph+LS234816+5L7rVrt7SdR0LTpBQzmLmfk7+14Ie4SAp7LUg73RtWGH+HQpkjU8KCedy1ztcicVX+gZZWdkXq+b1tPStwxGpGj4qUdDei9srbn49fXQp6UTpun5tvMDsMJ9vWKraYmJw19Vdf6e/YS7Z/sytH41kxjnvxZSw4VmtYA2i1p44IxS1UO71eEfoUp5TvzzZEiqgr7d2Enf509hVmUjb/kSkJiZp/1K/P5fSS2adjbOuHAd1GMBuWpnEiy1lu1FIxN1JRGmFFaD302V6u7M+Jy7hM6DWKR7xAeaRYFMAuieQ3iRd1G5NGRQn8Wz/1wvlJbVKgw1YZgmhLvbkmq5bS3R2mp/ETWBj6YD9AZGyGD6afosGDRm66KXkVXFeFebaVxWk3X/EjDnfar8xi9kmCJL1FX/uRIZnzn65i3zNJPYsDhb6T3rKO2aVWnlZnW3xBq2a8xr6/zvU5ktoQJS87GUasbR3R37mBS3kmM/253xRfrMyxn53/LlpJQFHQN7hcdWwXqrKisNR8Ks1Mo3bLL9KPOi2EFAppaREE9jP73Vw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation files for the PCI subsystem's participation in Live
Update.

These documentation files are generated from the kernel-doc comments in
the PCI Live Update source code. They describe the File-Lifecycle-Bound
(FLB) API, the device tracking API, and the specific policies applied to
preserved devices (such as bus number inheritance and bus mastering
preservation).

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
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
index 3eacaa98775c..5d1b58271989 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21055,6 +21055,7 @@ L:	kexec@lists.infradead.org
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/PCI/liveupdate.rst
 F:	drivers/pci/liveupdate.c
 F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
-- 
2.56.0.385.gd3acb90ef8-goog


