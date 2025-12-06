Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D502D3B7E1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31CB6B0012; Sat,  6 Dec 2025 18:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09A56B0022; Sat,  6 Dec 2025 18:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C202C6B0023; Sat,  6 Dec 2025 18:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B31C76B0012
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:04:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F41F52689
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:04:00 +0000 (UTC)
X-FDA: 84190575840.10.98F484A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C6F7414000F
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uJ2JZwXM;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062238; a=rsa-sha256;
	cv=none;
	b=5VbxG94o71Tl8f8RfqdpAWPS8l6l3veXaZA839z95NcA2L4LO5nqY3h9C68XtT1emqt5BC
	jhKCjL2F73S3mT74FiRRhLsH2YdCg9osOUz7NB+Z3b0Avn0L03o2fstRKNsKiDQsEesUpL
	yjuKDefy7KmLIWNS1Xg4+CeRCrEkstg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7YoGpMyUPp3jH132CIdD3VVC6kyvyTZv2wvu2Rm4MU=;
	b=jENMq4JIYZesbx6TYo3IYmXTmhE3nnixd+ZNxVNXxPbq1+RPRWhRPYc/fRSqA/Q26kYmje
	g//+igbBri+AaQbU1qNfPWTUSDbJWP2aUMrgM8Rqp2H78/aVLUU3evpF9KPM7KHHysGD9O
	+Ex01fl23iDYQVMUfhitAYpXoFhLLM8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uJ2JZwXM;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C791B43CEA;
	Sat,  6 Dec 2025 23:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BDEC4CEF5;
	Sat,  6 Dec 2025 23:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062237;
	bh=fGPbJKByL7S+VIwHfLLrxZLls7YbYHHkduUbnM1vhgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJ2JZwXMPZBVSnMwc5z8fugeGrViXv1sYM2jgFTCIoMG++wHeJDsoqlg2QWMyz1fG
	 /D34iNvXn6M1p4hEMRSR80EXzWx5TeD/YRn4gwPgpNUCQIsRcEdDJn4HH8cUc530+Z
	 X9dHrgt33cuDK7Q9iVwzJvfxywhfHrIuKYqc8x/HPgLuQzzPHrJPpoZCilQbQV9dOD
	 MPBWe8RhC+HfjVA/0WNKEKtWzH3M9hSus+AN8uv7wPg+eA1RA6A5l67e4n9a6VdDag
	 vDH2yDJC1sTAhvwujm6FimvTkDOlCN4Am9/l9c5dKYMRMxpQWn++1R0J682zSIP+3Y
	 3eHXsYi/SqXYA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 08/10] mm: hugetlb: disable CMA if liveupdate is enabled
Date: Sun,  7 Dec 2025 00:02:18 +0100
Message-ID: <20251206230222.853493-9-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
References: <20251206230222.853493-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6F7414000F
X-Stat-Signature: w1dzkjethi8bru7t4yb5stio1orck7en
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765062238-12787
X-HE-Meta: U2FsdGVkX1/nzNGUW3lYoy7kKNifr6N8glpYqypDKiUPya4CO/yJ5czy6cqvFv5s+/TUmLpKo92e24SZ2Hq26xMSb2DVLSb+lB/FxuOPXqeYS8kJogv3q+ByOwLeQ95gR3G7DOrBiW2t1vJnHZhWWyOxa9m08JA7xRHGeMzuFRW5BvFl9GXHliRqIe73hLPCtouAkj32Q7MLy+RR67AnY6D8pb/TufPAhy22hAkZrYvy4IQ30/6cSMpo8bbUT+wPkaTI/EDonTaifsnw2CVQLeJ/n6L8XKlLdT1j477Z1F79vggRJbdx8tsIMh8QTOQE3zPE3KyBqBmG0pvRmanv4OW5orlxBhtuBzgzoKRR9PHt225cNhxdsycY5kFOgdQ/TOUFqq3TyJOtR4AKwqsDuoFM7QcZSqzEMElV9RksueW2+HR6XcyPcpaTe+SktEN6vitkZvp+DV+rrHaLZ3mx/Y8AMXrH49Hnzii6GbWpledxEqM7YV0Z4UhO27f++DC8Ow2IFfjBJR0VSy5Y5SwkajxQf01IIvlPA1M9Lit/E8Es4lLpdd7moxyZ/rpRfJOSaSe14UPRPF7CEdZkEE/HjtQHr44wqUieZfVkTSK9KaakY5RFgtcqwEdU6umhAJV+d0Wa/M/7mhbTCAEPBIJugM7PwcdWksL9JvX8k1sOculV2x/QI7m2Myu43XYd8wlNyPLyp8dENSZLhJGB3HyLXRlrIEeVAu3H0uCzNDwj3U/8os3KnIGFqRAKRwvvDTcC06Z7iWjiwDr3I0P6lNnOgbeCSrdhBaiJY4Ey0RDd2tbUDMve0Xjiqkg+1ysXNuTTcVj3s9eXXrZ+KiyWK0xnESi/N4VZH624wWwD6tG/BBK2bqTihmBWXpXKdUk+zt1YxSvX6Jg92IAR9b06K687tVKv2xkkV/Feo0L1D+1s7hF9ne2aoyaWubyA8uIAg8Gr+hLFptv9TfzKupUFpqK
 v1dELTQn
 C6cOouO2hBiWoEOZdwSSwiTcqSdQN17Fd02YwK3OPWDhgghKQK/WnaUu29h4JG/YLZzRrSlfDBIEcCcrJVDkPJGJc+J5G16EjpQxmKmPDjwgOPk7XCQ7GIKLonCcy/uqur2NdSAjlLnn8gcMxA7ix+A0akFE+XzAIMZnOec7Glur/70wRia7PPjp+zDwyMNOCMJFm79qY/GxrjdqVTw63b5UEuNqX7BfXAkMFU4CkV8reWHPf2l/DUen95O1w5HYckcv9OGv7kcyezuI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugetlb live update support does not yet work with CMA. Print a warning
and disable CMA if the config for live updating hugetlb is enabled, and
liveupdate is enabled at runtime.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/Kconfig | 3 +++
 mm/hugetlb_cma.c          | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 86e76aed8a93..4676fea6d8a6 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -82,6 +82,9 @@ config LIVEUPDATE_HUGETLB
 	  use hugetlb memfd to back VM memory, or for other user workloads needing
 	  to live update huge pages.
 
+	  Enabling this config disables CMA for hugetlb pages. It is not yet
+	  supported with live update.
+
 	  If unsure, say N.
 
 endmenu
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e8e4dc7182d5..fa3bb776c0d2 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -4,6 +4,7 @@
 #include <linux/cma.h>
 #include <linux/compiler.h>
 #include <linux/mm_inline.h>
+#include <linux/liveupdate.h>
 
 #include <asm/page.h>
 #include <asm/setup.h>
@@ -152,6 +153,12 @@ void __init hugetlb_cma_reserve(int order)
 	if (!hugetlb_cma_size)
 		return;
 
+	if (IS_ENABLED(CONFIG_LIVEUPDATE_HUGETLB) && liveupdate_enabled()) {
+		pr_warn("HugeTLB: CMA not supported with live update. Falling back to pre-allocating pages.\n");
+		hugetlb_cma_size = 0;
+		return;
+	}
+
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
-- 
2.43.0


