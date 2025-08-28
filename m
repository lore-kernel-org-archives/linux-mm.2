Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 676D5CA0FF7
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8298E0023; Thu, 28 Aug 2025 13:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 495E18E0032; Thu, 28 Aug 2025 13:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311D68E0033; Thu, 28 Aug 2025 13:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E28A8E0032
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2EDA83FF0
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:57 +0000 (UTC)
X-FDA: 83826811194.27.EF98859
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 32F2F2000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0sDW0mt;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTrXzkcV2m2dA13EOmMFNFGpMePUSApKZuPMiCNsvag=;
	b=i0RHT7ZALs/0OtTeVv5PK3ErSlPfcLL+gl214Zj6zm73wsrJp40XE+wUykQhYoqcrk5WYH
	KZNj52cudGaVXSYIBvWNxNGqR3/zhKnMTS47Z8w7z1Zd2wT+Lcv/9FyQnUjkdVavIWR3I7
	8tHakAKvRpBH+NA2c7LBX3PN4ibLWPQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0sDW0mt;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401176; a=rsa-sha256;
	cv=none;
	b=xgtbtm6IZbiQ5p44KMqIpvWDagnEdVMQ79VE9VENoayaZJulYsmcGZ3i3LHao6cQkSapZs
	mPjIDhrfEHNKgRSSbHe9sMQdDuo8QmBh0OwPKt37qdTD58akGD5pti7B23VqO8VwCs3e7w
	GPuttHvZIvMGz9JftQ8HYv8YK/BAZKs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E453041AFD;
	Thu, 28 Aug 2025 17:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EACC4CEEB;
	Thu, 28 Aug 2025 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401175;
	bh=XEEup2P+YfS2nWpANDMTFLVSwSxLXRRHKWWJnlZZn9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0sDW0mtUEfC7+wyIitulsjr21PnQg6oUa4z9o7wFesIFqL9G9II6sjiS4dNfLInx
	 9RPqGCPrVFzGnAwGliAwcCi3WCC+uNvvSSvtHZoF3fd19n1FFO3pDXeBSrLLKRrsEK
	 ZGjQJQp9LqPIgrXjGUKQh2CnMuzOwr3vxz2Xu0Xtm8e2VcAaozGeoaMvsf+or86ZL+
	 WKs2PKSPPJl9hYSm/YvATa9LiTKDekB9dA5yuYhVOSRKTb3q9LkB8troiKxwNvdczN
	 eqJxV+0gMcPsXoKkrJIRqBpqPEzbFU0ZjRKJLREFfCBEjNeijfmZB2w4FpGmDQwmrV
	 9pqxHdEQ/bxeA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 08/11] Docs/mm/damon/design: document 'address unit' parameter
Date: Thu, 28 Aug 2025 10:12:39 -0700
Message-Id: <20250828171242.59810-9-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32F2F2000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d16brbawnr3hmfjoowfbkf5hus7n7btd
X-HE-Tag: 1756401176-100718
X-HE-Meta: U2FsdGVkX19Uw/825jwWGfYbG24147aoFvZvbUWr0vApE3N/Z8kkphg4Y3UUHoahXX/7zgLwaA2LiP35MPbWFDUBm5+hQlxGHS+1Q09FOguqxeudLnUgOmzi72qrbsP2h/Xo0rZLXjNDnmiMWFdKXytSfWVyO+das6qUU0KeefZMQTTFzWjjBLLE/svMX9DtvvPwmF8ZEWC2nyb+WNcuih4iN6oirIDUviCCAC01/GACm154ABqrRlIB6qMcJiGWAZZcLPGlEL2gRIWPS3z9gYMzpKnSEAkGsgNXBLfdCpay9TVScFTVXMek6nuRtIucWbyOB2rRJ8eS1Jeu7o84E6k5ek3cv36qIR0Pu0/UL08HUeHV/58rG6PEQs88BN0trPNkoqp6YmjFbqf/cKPZXy0wsVoyEH0KW59xoSCGrevZEiNxxXWX/HinKp1PjGC2+gRuv4D8IUg8lqgAzgRzjaNuVGUG0fV6OJmqSuj6LD1z27GF5JV+hY24x4d4mMfvmkzEogYLOuRB62YcBQ8KkaVtfxzBIJgjbdRhFmoLCowaxloGPIzvd4c/dRxFn0fVLNsH2QvotdPauTy0U3z1kK/y/xICVGEXwvPvdKLn36AahmYp+pxh7c1pFOxgKxq1wiO3xGyqLBoQ+nngkuMPG+N8R2/1LIsrrQRpiNglBkGwi0/wu4bD4E2H5UCzT+ImEtCvzY/cC0tnh+fhHJINNnzJ62pFTfIbe/P4BZ3ZqCY6euFibMFYy+KlG2dR5HCyxnS18IqHZredoyD6+ggeezIlZ/P3YK19NRdctpwr80us4Rmz27w2Y1jEpsj8813cTbcbkJjIiwxKR+KnloNN0LOxOhWaIEJByMdseld6KIkFMDyrB1XBaAINEHZTgiHgTjteQBk97dAPH535XYLaPvdK4msLnjuU8A8nuhMfS8NRbstvv2S+TA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add 'addr_unit' parameter description on DAMON design document.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2f6ba5c7f4c7..d9d5baa1ec87 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -67,7 +67,7 @@ processes, NUMA nodes, files, and backing memory devices would be supportable.
 Also, if some architectures or devices support special optimized access check
 features, those will be easily configurable.
 
-DAMON currently provides below three operation sets.  Below two subsections
+DAMON currently provides below three operation sets.  Below three subsections
 describe how those work.
 
  - vaddr: Monitor virtual address spaces of specific processes
@@ -135,6 +135,18 @@ the interference is the responsibility of sysadmins.  However, it solves the
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+Address Unit
+------------
+
+DAMON core layer uses ``unsinged long`` type for monitoring target address
+ranges.  In some cases, the address space for a given operations set could be
+too large to be handled with the type.  ARM (32-bit) with large physical
+address extension is an example.  For such cases, a per-operations set
+parameter called ``address unit`` is provided.  It represents the scale factor
+that need to be multiplied to the core layer's address for calculating real
+address on the given address space.  Support of ``address unit`` parameter is
+up to each operations set implementation.  ``paddr`` is the only operations set
+implementation that supports the parameter.
 
 .. _damon_core_logic:
 
-- 
2.39.5

