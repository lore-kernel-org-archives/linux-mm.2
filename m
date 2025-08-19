Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F981CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFED66B012C; Tue, 19 Aug 2025 10:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF456B012E; Tue, 19 Aug 2025 10:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B806B012C; Tue, 19 Aug 2025 10:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93D026B012C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:18:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 530CC58370
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:18:26 +0000 (UTC)
X-FDA: 83793712212.26.D662349
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 61A421C0008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:18:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PgFjKqMd;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755613104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQ5SyoE/MYPNZDWioj0kryq2voWpDfBzmzGzBWhm6as=;
	b=1rOFdUmRlV/SiDdr6xmzMpu9xrwi6dK8kpz1kr/pdQLyyTvPurikun1zVuvd+BMMw1pFk6
	Al3H5QhoN3o+4iODiZRJmrGOzGooENgU4nIpKrX5i8/iRrDg/j27YQTtkNqKc7jWU6Hf51
	9C8/sFkyE/7UGpeqX2ZuE/dIBimHI/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755613104; a=rsa-sha256;
	cv=none;
	b=0WVV/kSAiYvw3BnIHQdrGTJkomxHeCP/yCPmqqfGm3sAe+Z3u4zeQUfNlE2MyU6n/Jum7y
	0sQ1byWH//qMxx4J2/C+y/gUpBPL4QprhyIn1Pa6QKLtxYT1W55WJnTO4EKJG8nANUHBtI
	K1wgFCAeoHPhPhaL6uTfE7M8v5sHuG8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PgFjKqMd;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755613103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KQ5SyoE/MYPNZDWioj0kryq2voWpDfBzmzGzBWhm6as=;
	b=PgFjKqMdmuH82lmSahnqaGalKTh786HJihW+//jf6oo/QaBQCWfFe+Y52HfCseoH2Yp1bz
	lfNmH4mGNl087BKIyhIxqVEIfsFUa6Khx/tMV6LGIqxCeNlajGj6UlmeoxDVboXdLBfvG/
	eE17oGWFOTbym3LIXPLeM61UieufsEI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-175-Tt6NCjBUM0KnyyV-_L6s1A-1; Tue,
 19 Aug 2025 10:18:18 -0400
X-MC-Unique: Tt6NCjBUM0KnyyV-_L6s1A-1
X-Mimecast-MFC-AGG-ID: Tt6NCjBUM0KnyyV-_L6s1A_1755613094
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E835F19775AD;
	Tue, 19 Aug 2025 14:18:12 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D8AD180028A;
	Tue, 19 Aug 2025 14:17:53 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v10 13/13] Documentation: mm: update the admin guide for mTHP collapse
Date: Tue, 19 Aug 2025 08:17:42 -0600
Message-ID: <20250819141742.626517-1-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61A421C0008
X-Stat-Signature: 953t8nhq3jfnrt333bt1z8e7hapu75fo
X-HE-Tag: 1755613104-456635
X-HE-Meta: U2FsdGVkX18zelJumu3fWKl0tQ8SVpkbhlrITy7dQgnAkTHDXmQiQk9Fk7iN5QkbbDUkKoRaumUU+/J2MM5HfNWby+H312kgZ4CYWRCOa4Tt3F7EVRMHeLfZREtHdFVQXYosaz6J8sX8P0YYcqenKXIiOeSi3rYUf8Ka5FTvzMB1K86zZ3jilBj9SUlqSuRaZT7dVcKIDDaqss765CHoXp3w8k5ypHhdedQK9duFAD3bcEoYzAmcJx6o/emA/p1WN+x16bAkpzPfNAKdxdux/M+wrLHDPtoAyrb2JjyOUAQDoyDT6Gx4COO7Dk68K5Eyv//eOZVLKAMNLnGTDbAEL84hMFcc38cgY+3j3NB2pxmTx82uDS4a7hRCg0cSdMIDcxQ0uhZywRwZaOnIPPVuB4O1N2tBtG2O7I5O/5lUyhX7U+erGhZkWd9GpHnyo/tlPIUylkU1rM/CHBAtWE6yyTMRtPrQwJ4NIV8ZiwTJ/sF+jVinl+0UpET3bIxKMFXGBrkCPcYN4nbbvMlc3gAq3lNIWv9x03uWhb0ScrJ9YLgupJMY0Ox0vN6eHO3Tzx1VU05DLHHkADNpOR3XOXpX5sUXy0N6P3YeysTaqff9dY6EvDbRZ79ZWJ8pkn372J+z5BKO0S3eO+Hl9ZxkLzp2GBG/DihApQA1DE6i0YSmXFPA7ZlnP56k8NbmHtv/qXgEzTIUBNqqAd++5ojmA+zFYQQerMijA264GzG+2eZDJ6eV5PmMpp9lFbrJn2xcTTOb1kxKujRdY/JpPRSstYBFZEelYNv2L3KYfkp5Fh33Hw2FDEgOAyPvZdScxC0ZmFRVuvF5mYcuOWk2ieZM4KCwx8NIMCB/fW/48U5uPH5ta7kn4St+oNx8iMWs/174x+52lUZDXtzQqeugXCOgFxEqfo8EJEmqdYDltKzYFotnEwOVTI8r5KH2xrCVhZKKpbNyV4+LHJsepUcW1WfJBmi
 2rXj2hxk
 MGVd2eqPjEyP6Di2yw13AJhJaAtJmWxA+Tny7RExHoaeS+tNBeOG8Ijme/ocdGiyZdHjTaQuZH7tQXZVT3txB+uAgxWWJdE3HdR836uOYMgEd8iHJqrSYRPZObnMTALDwt2KHaaodLcxPUolV4rgz9LNuyjtgb4dvkW++l7pKSfqwBTk7Y5cwZdyuJxwD6xgPbd3tHQhaKv4sYq/W2Na6bVahHHr7pMSJaFfU77kYB1lOV+Vg/ZQ/qgRNM0nZdPC6S6nqTQR58DpW4NGHLVBlTgcXXBIgYAtpiId5tESkYaGA7SB9BCH4JGUZN2IY9+bO/LY0H/P1Ilv5Bu6tkJquvgNc1ZPc2HE53yuj09lfcO/H8gsvSLQnb0gAs0vZroUyB4ZEbiP+Itqe0bybwvS+kZQM0SWp6BCe/10VzJWbFoQypc4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we can collapse to mTHPs lets update the admin guide to
reflect these changes and provide proper guidence on how to utilize it.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index b85547ac4fe9..1f9e6a32052c 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -63,7 +63,7 @@ often.
 THP can be enabled system wide or restricted to certain tasks or even
 memory ranges inside task's address space. Unless THP is completely
 disabled, there is ``khugepaged`` daemon that scans memory and
-collapses sequences of basic pages into PMD-sized huge pages.
+collapses sequences of basic pages into huge pages.
 
 The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
 interface and using madvise(2) and prctl(2) system calls.
@@ -149,6 +149,18 @@ hugepage sizes have enabled="never". If enabling multiple hugepage
 sizes, the kernel will select the most appropriate enabled size for a
 given allocation.
 
+khugepaged uses max_ptes_none scaled to the order of the enabled mTHP size
+to determine collapses. When using mTHPs it's recommended to set
+max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (255 on 4k page
+size). This will prevent undesired "creep" behavior that leads to
+continuously collapsing to the largest mTHP size; when we collapse, we are
+bringing in new non-zero pages that will, on a subsequent scan, cause the
+max_ptes_none check of the +1 order to always be satisfied. By limiting
+this to less than half the current order, we make sure we don't cause this
+feedback loop. max_ptes_shared and max_ptes_swap have no effect when
+collapsing to a mTHP, and mTHP collapse will fail on shared or swapped out
+pages.
+
 It's also possible to limit defrag efforts in the VM to generate
 anonymous hugepages in case they're not immediately free to madvise
 regions or to never try to defrag memory and simply fallback to regular
@@ -264,11 +276,6 @@ support the following arguments::
 Khugepaged controls
 -------------------
 
-.. note::
-   khugepaged currently only searches for opportunities to collapse to
-   PMD-sized THP and no attempt is made to collapse to other THP
-   sizes.
-
 khugepaged runs usually at low frequency so while one may not want to
 invoke defrag algorithms synchronously during the page faults, it
 should be worth invoking defrag at least in khugepaged. However it's
-- 
2.50.1


