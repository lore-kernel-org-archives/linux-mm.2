Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC07606A326
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LW6u8bF2
Received: by kanga.kvack.org (Postfix)
	id C12BC6B05B7; Fri, 27 Nov 2026 07:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4716B05B8; Fri, 27 Nov 2026 07:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2E76B05B9; Fri, 27 Nov 2026 07:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83F786B05B7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:26:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1DB71602F8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:26:03 +0000 (UTC)
X-FDA: 85480821006.01.F9D6D68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 559CB40004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:26:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LW6u8bF2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795782362;
	b=DIZQA9kSmj+9WG51+4xSuxXsU8mgbI5ArRrglkh9PQJU4KQ4n5KlDaorSfQ/VurzT9YjWQ
	6wvMPX3c0mhkA2zy6STaeeGFbt6JA1cvVFp+RZpbByvvC2DxyURyzDnKvTqj3SAptSFTga
	WroLQvfgsXR0uqRWCa3nMRiZiZ6Xe7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wO/IOEvgfeJp88G3JhgG/noxUD2JKBD20IHHFxKJYuc=;
	b=dSRRQwV6Tg2sypw/0bxoxX/gV0FBPkQq5yVg9t7slwUi6u5y3n7N/xy0BguQskdscuga9Y
	D4SbQWhpQpwtir0TKvirsiZ2CXBh0UJ0CfO7Rim+A7cVqAYdT5+15bwkPrJs37tviNEQBJ
	aRLGYV9gGXIx0d4+cj+3MxqI2/FSZVM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LW6u8bF2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE077417BE;
	Fri, 27 Nov 2026 12:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49071F00A02;
	Fri, 27 Nov 2026 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782361;
	bh=wO/IOEvgfeJp88G3JhgG/noxUD2JKBD20IHHFxKJYuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LW6u8bF2kVNmuWmelsSivsj/jA5wffvdi1FVsMa7rCrDRU+cLnvmXnjGR0S3F8lPO
	 LOrTRj6a/JAKn+Gq3xSuQO7JUVjDJwaouUu7nd4dAS8GKHcBKYF930PNt8ZwwHF0AW
	 nKqXWh71uaU/BVIfWWajGCudQT9HMdSkeb3oFplARqAvV1SonkUm65FWTfaYQWbFjS
	 5jIZ98K93cxNnS4JzZKAv6rChjYiqXdfsDEquIKozcQgejaSHF6uCRo3emRX8gTPdO
	 lVwAZkwlLtUOft+qQqhQ+wchhSggb3UE+b3EVp3rL98D4TXA4i3uupInAHV3TaDw6M
	 bNy8IM7TEipew==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Matlack <dmatlack@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 4/6] kho: use unsigned long for kho_preserve_pages() and co when KHO=n
Date: Fri, 27 Nov 2026 12:25:30 +0000
Message-ID: <20261127122536.3708770-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <20261127122536.3708770-1-pratyush@kernel.org>
References: <20261127122536.3708770-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3udegryek8h7xk3jk3cqysap616jwdik
X-Rspamd-Queue-Id: 559CB40004
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795782362-892391
X-HE-Meta: U2FsdGVkX18dr6u0O8zkKiLch5TGuxtOeErL5P/InvWK2HLYmb5rszs8TScgrVMzbyD4WYErZ2gEvMKxTWVS85zxsYmtz5SSx63ps35RS2FlQm2o8kmkkG6KF94R2EebQw17tTthWLyN0aLxe9XFyuEA8TacRNIW0FRgmOciwZr86ha5ZRUigE8qAfTySlzwdJPYYeF7JOrDu6yCMeiqZF70rbMB7aUvq5PU+MzRH6W7OumheWdyKfd0gle3sR/a9wV6aMhqqn+WHKKSOl6BhDKXo9pPriVUCrOsDJs+z+jnGl/voVlmNTp7wKtjyLtXfHXG7mVRuDTG0/UyUFHxCBS4sFOI30RQRv3Q+Dqnmoolpi7E64gh5gJqN0hGpIJ18jz16VdMFRTaD26rWepNj2wBoQanI/Jyfv7MCElsrMyanXI3LPhnU166zcZ01UeZwsxP5wevzFzINzwrA3y/orD6/R2LACJ2px0Jj2wxSGqvL4marWwSHtB483H9I4KQqSSS+la7eEC/WyqIJJ2sJxhQXo6FjQw0nVomsou5tXSZ4D1ynWG+y2z+oMPhpikrT5F5PtqzyEmk4cNA7phUnoZuaXIvbS/i0zGw1djUU/0/PXfn8Jj+AkKIzVSAM+0qNamvxNgx4eJEu06i3AU85ofZg8Dba0bN4CuTW5gP2rq2E9401/4DaHS2qR6yqF71V64csH6Dur5y2QdhaBz21G4qRuQ60KVfLi91Z4nJ2cBwwSrnI92wOWN6Ik/r9K6d+blfRsdmbdIp/Y949sWPMckwf7mVJOa9Oo2CQAJG4Yxb2rL1pUJSrrMTXWHEMnm2bf0X5tUqZLtX4fpLniv00mwldkhMDkFwtjphXClS5L4WDXNz5/upn8/5qtOIaDc2VVk07OQtND4M6IJLhxC5JoEsvhesUdyjAMyjPeqMd9RaABmnQ758n3NuHSNMqsq9Lc+zHKpdC/N5pgrK6VF
 rNltdlam
 i9TOavMSyGBZ2wtYA9GnvpnJzFbMAVDmxiNLo7qZhdcPMl+6UKtYxOp0w0g4yg/zN5JYZZsokJeGgrM8AcxCEacMV+b+KnZZEXWcKKTmSd/2iMez3jmuT4ucVsg7+W75Aeut6EHeovj8ZbnD5gpPfgJUNORDXzJGeDa8bN2EhbVdXphRxbjxAv8TGLJIs06xaDEnVQ85O5NOOW1/0/GNr1Je2iOUE7V8z8f5ft4JOEPOslBIzgmKmI8xjHiQ5ssVvkkbmSAdmNDdLMlA4y18/bDlfiB/+UANUGXoVBm6l46dkWGHlU8xmZbE0wgmQn45VDKSdtJrEUfz4qrs7s2Lj6vKL6naYiyEOXvhMBZbGHGTlowDUjg/FcQKpzPSVHiGckMi9rTmOJZM07C7zeiWdaaGPs4jljVACPAa5Wh6zY+YqWrjheGgME02qgVQGBoZQgpUn02TtOGe/CsebfdQw5yXHMjQVeFuQ9RWcPnMsMqWdInPn5+mRsxvrKAaUe7VQEMRy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Commit 840fe43d371f ("kho: use unsigned long for nr_pages") changed
nr_pages to unsigned long, but it forgot to update the KEXEC_HANDOVER=n
stubs.

Fixes: 840fe43d371f ("kho: use unsigned long for nr_pages")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

---

I don't think this is stable material since there is no problem in
practice.
---
 include/linux/kexec_handover.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ef2b188c8ed0..a20456b8da20 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -66,12 +66,12 @@ static inline int kho_preserve_folio(struct folio *folio)
 
 static inline void kho_unpreserve_folio(struct folio *folio) { }
 
-static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
+static inline int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
+static inline void kho_unpreserve_pages(struct page *page, unsigned long nr_pages) { }
 
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
@@ -95,7 +95,7 @@ static inline struct folio *kho_restore_folio(phys_addr_t phys)
 }
 
 static inline struct page *kho_restore_pages(phys_addr_t phys,
-					     unsigned int nr_pages)
+					     unsigned long nr_pages)
 {
 	return NULL;
 }
-- 
2.56.1.839.g22a8290db9-goog


