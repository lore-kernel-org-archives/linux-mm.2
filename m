Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 731D0CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4816B0007; Mon,  8 Dec 2025 01:35:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D548B6B0030; Mon,  8 Dec 2025 01:35:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69986B0032; Mon,  8 Dec 2025 01:35:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4C126B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:35:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64CF9160995
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:25 +0000 (UTC)
X-FDA: 84195342210.06.6155F57
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id D95511C0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oF+NBXwW;
	spf=pass (imf20.hostedemail.com: domain of 3qnE2aQgKCLcgXplkjfrdlldib.Zljifkru-jjhsXZh.lod@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3qnE2aQgKCLcgXplkjfrdlldib.Zljifkru-jjhsXZh.lod@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZqyNPlmDIsr9igOdfXIDir5SMEz9QXEH46sRqM37UGQ=;
	b=CpDeo/7C0/zqnQbe7fDMDzYYh003eZlKic1dSp+54chnYxTNaxrXPrDXj+USduwvRgnna6
	OusPyoxxMY4yRgFMdPxYj4mmg0QVFq9lMCySrFuLVEsJia0MTANYwFKrpnp+hwaCLOnS0i
	TveWnUMxTAxPOwqJCMJ25O2Liw80yYY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oF+NBXwW;
	spf=pass (imf20.hostedemail.com: domain of 3qnE2aQgKCLcgXplkjfrdlldib.Zljifkru-jjhsXZh.lod@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3qnE2aQgKCLcgXplkjfrdlldib.Zljifkru-jjhsXZh.lod@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175724; a=rsa-sha256;
	cv=none;
	b=dAEc0vLzESE/cik5J9D67tENhpMDpnr8pnEmpDOlETKDTM/wYDyU9dnmaSkvHi8Z1bFKEx
	a0q2aOKqXHlGTgaDLflFXMWKXRJVU8AiVI3NuhNZZKddH8n/NruhJPVRwtI8cRXH1+WR2a
	rptckRH4tFSGyOcdWzxq1pZgsdMto1I=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so4295754a12.2
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 22:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765175722; x=1765780522; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZqyNPlmDIsr9igOdfXIDir5SMEz9QXEH46sRqM37UGQ=;
        b=oF+NBXwWlC6kz5sXtyhn9PlXECmcFFe7SZAlL+OOIGrdiovI6C+sBbnqPbqRoGFj81
         xtyyRkMvWlRHq85vp1P9MvOq6kzA9/QZZaEbk40Wsp+hQ74Mi5MH9kYdM8E15UGv3FDh
         joLrbXqQ3qFJQp4ph3ovEsZa6lN8JpXRov+oPpz6OXjuvNhdVzXLr/i+PJCvMWRQRNtn
         GCo2cvufT7Zb3/+44dYkYxtSGjkhtoaoaSVNbqCTZhx5CFOXGUcFAWOuz8RTtFNdgIW0
         Yhm/rW9JNePqVinagbYERKzh1QosvY/30S9zikyTc2D2Cj0baXZxmKB47XS6vNuhxbLx
         lL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765175722; x=1765780522;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZqyNPlmDIsr9igOdfXIDir5SMEz9QXEH46sRqM37UGQ=;
        b=SddWjXWiucnqVPfwRQwC/J3ljTuo5QL2CMvoHJTpTChOmkrv/PPM2p1GmH5C05Oucs
         C2AJM2Dr8fHK1vKOv5ZKKYyHncliQXdZ2n40GhjBFGQ2VirGY/VXQ8sYNmDdQAnDMgkB
         6C2rbfMgIS2k9I+niAtIwH1b9JX8+O1GJeHLjrUJhr0qgLB54uRHPN5KKR2uAmXCNhj0
         loe6Od0TcGVCg6O1IM4oPwtTT1dL0giYB2aGq7DeR42KfGupWYGKD8jEF9x5mKTvRQAC
         tFpxsYkiLKF7ANzamekbcXrjtLH5m2q7PKPem24VbDXz6s//SDdUtmyspFUBns1LZl6w
         XRYA==
X-Forwarded-Encrypted: i=1; AJvYcCUrHNEHk2e7JmPhQ6ajNzyFbgRwfTvfr3MFDc0hePsZSZT/scue8mgqef4XziGBlqt7Z8HXQNLPFA==@kvack.org
X-Gm-Message-State: AOJu0Yxg0HezhGEJ/gWiJ8qb2w+u5jKTnMLGYbouDhxB7cATozUYYp2n
	k7RX618l4rOxnI8mQAi8IIBMryjfYK+iODuxrL+mrfQuIxuFp9he7EXUA38U+dOeyGnHm0b5Lvo
	gWlObl4WheqcfIg==
X-Google-Smtp-Source: AGHT+IHAI3z1pMXzyBPNpREzJHkOBRWhaGBqjtnbPcPl9gXNFuPCdYXbJdbTdfH/iA28L93uYP4ZI3E2jt+oqw==
X-Received: from dygg16.prod.google.com ([2002:a05:693c:80d0:b0:2ab:9753:da7])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:7187:b0:2a4:3593:ddd4 with SMTP id 5a478bee46e88-2abc70f78e9mr2666178eec.1.1765175722204;
 Sun, 07 Dec 2025 22:35:22 -0800 (PST)
Date: Sun,  7 Dec 2025 22:35:09 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251208063513.3633942-1-jasonmiu@google.com>
Subject: [PATCH 0/4] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fxjypfpoa598yrkrbdca89akwaxuk4h4
X-Rspamd-Queue-Id: D95511C0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765175723-655950
X-HE-Meta: U2FsdGVkX19+8Ij7uRuMETch8hLtIjddsymIvOIE76GiJsJB7M4FMqzAZKdrl+OJkGAZ1s7LhXFKmvwtN2dauMgxSb2oNxFsGY7Ih5BTk7RCl6BrsxxxAQgoddPRcujRnLDOMRi0quhPTDS8YH3m1njctvrWMuiJ1szAawQIAe0eETk3GOw7AGafCkrsodOnPiU7z40kheWTAYzhmRCN0WtL6+1Pjak8f1FLTBDOKG1DN3W3ck4r9YJC2FuorA5qHHPO4tb3V6TBfuPOAuQuXqq3ZqMTKjE9DAgVs4wUrk2KkZ/ElywhxNSNHQxCJfklnnQv4PWos9woEQ18lhG06nkMR67NqkMKMUAty0wFMlNwkKCP5BHNY14VA1vXKAmeUUnbsDlRNJD+G62VsW1u7nwfwIueFaSAtCFW7U50uC8TXmNGtw/G3Cz7x02seLBWZJJuNBl4HmupgsIDYeJRj4Uz6qisYz0gxfcfsaVFCmxwN1VXDfEJjQ3f8k+Nl90PbsIp0FDndRb3t9d1IvlUgMEjGmmEKRCDHkjOudU3ZJuQDSebWuQFvDvIL5ZyXWyZT2cXkaxJXvpXluI35p4qTloGwT39Rc+18PdwC66Om4JZOj4oaniOB5tKzUQcnEs3RLVz9s9mHFxi7fkw2QKsJR/B5tkH6TjfKSYu2C5/7x/4nPBnkPK2ERfhfVz977ZMcfOm/8o+wcGuE/wvfx40uzUkXOXT8iyASSSq8l/hSsUFqf7hS6WjfkLv4+JHi6fDu8E205Aj9nXMv/7y/ZwezuhDSVz5GF83W022Jz7Ou4ElYQBOgvqSCF7YN5HTCY1o5TJyos6iq0Teavndzy8jufTz51df0vN3Mdnfx3KGm58D3GEPeHXgpnokJ4GyRe7Hu2bOWmqjFso7nbxVbNw9WadujxmkMvvvu8TiPqizCs/69bsnBPiHpda04KvD2Gl0fyFopS6VPwgOoVE14I8
 D8ZWHYzX
 YqXNrrWjeCt2JRQD2Bsd9qrPHMg0JTB9eEBhcDySiafaInN8B2IEm4WxyQ2zqumctssy4KUTo59Nwg2T2BKpVByV1x7EsfpbruBPkkH+AfWyTDYNnWA4eiEWtorddtB+QLI7cqLgXcbNyee03bM/ByN5+18WS5YwKnrHngUHh2SwGpW1DwkMARtP57Y0d7Ia/iE/NDkgEov2Zh/Bcfj65dRPqEnqO8xQmsIrR71lPI3JiQWFgvhZVUwNSKP5j84v5gwP6mHIwJY4+Svo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to using a radix tree data structure that can be
passed directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the KHO finalize state.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A
page's physical address and its order are encoded into a single
value. The tree is composed of multiple levels of page-sized tables,
with leaf nodes being bitmap tables where each set bit represents a
preserved page. The physical address of the radix trees root is passed
in the FDT, allowing the next kernel to reconstruct the preserved
memory map.

This series is broken down into the following patches:

1.  kho: Introduce KHO FDT ABI header:
    Adds a dedicated ABI header to define the FDT interface.

2.  kho: Relocate vmalloc preservation structure to KHO ABI header
    Adds `struct kho_vmalloc` and related structs to the ABI header.

3.  kho: Adopt radix tree for preserved memory tracking:    
    Replaces the xarray-based tracker with the new radix tree
    implementation and increments the ABI version.

4.  kho: Remove finalize state and clients:
    Removes the now-obsolete kho_finalize() function and its usage
    from client code and debugfs.

---

Changes in v3:
- The preserved memory tracking data structures is defined in the ABI header.
- Relocate the `kho_vmalloc` struct and its helper macro to the KHO ABI
  header to formalize its status as a stable ABI.
- Export the core radix tree manipulation functions as a public API to
  support broader use by other kernel subsystems.
- Update the documents.
- Inline comments have been cleaned up.

---

Jason Miu (4):
  kho: Introduce KHO FDT ABI header
  kho: Relocate vmalloc preservation structure to KHO ABI header
  kho: Adopt radix tree for preserved memory tracking
  kho: Remove finalize state and clients

 Documentation/admin-guide/mm/kho.rst          |  46 +-
 Documentation/core-api/kho/bindings/kho.yaml  |  43 --
 .../core-api/kho/bindings/sub-fdt.yaml        |  27 -
 Documentation/core-api/kho/concepts.rst       |  28 +-
 Documentation/core-api/kho/fdt.rst            |  84 +--
 Documentation/core-api/kho/index.rst          |   1 +
 Documentation/core-api/kho/radix_tree.rst     |  17 +
 include/linux/kexec_handover.h                |  27 +-
 include/linux/kho/abi/kexec_handover.h        | 268 +++++++
 include/linux/kho/abi/memfd.h                 |   2 +-
 include/linux/kho_radix_tree.h                |  81 ++
 kernel/liveupdate/kexec_handover.c            | 694 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c    |  20 -
 kernel/liveupdate/kexec_handover_internal.h   |   3 -
 kernel/liveupdate/luo_core.c                  |  12 +-
 kernel/liveupdate/luo_flb.c                   |   2 +-
 lib/test_kho.c                                |   1 +
 tools/testing/selftests/kho/init.c            |  20 -
 18 files changed, 765 insertions(+), 611 deletions(-)
 delete mode 100644 Documentation/core-api/kho/bindings/kho.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/sub-fdt.yaml
 create mode 100644 Documentation/core-api/kho/radix_tree.rst
 create mode 100644 include/linux/kho/abi/kexec_handover.h
 create mode 100644 include/linux/kho_radix_tree.h


base-commit: 7d31f578f3230f3b7b33b0930b08f9afd8429817
-- 
2.52.0.223.gf5cc29aaa4-goog


