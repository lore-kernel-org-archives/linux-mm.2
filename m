Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD14CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931478E0016; Thu,  4 Sep 2025 11:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1988E0001; Thu,  4 Sep 2025 11:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0D68E0016; Thu,  4 Sep 2025 11:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66EDC8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:57:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEF0A140294
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:57:31 +0000 (UTC)
X-FDA: 83852022702.26.D170936
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB60F140003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:57:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcVfe5s5;
	spf=pass (imf23.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757001450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UGGZII7wzR1KmBBZk5RJXulMqebBStNDcVGZJavUGGI=;
	b=sEOZIwHZvyiYK9fztDglUqXTpVHVWw434EuaqEqZ/K+CqwwslogS9NS6zplSIXSwYVj37u
	AnA2NzohZCwE1JOxhJiMkyWbc6E8Nw8a6+6Dju1RTpQ3HUY6pXGG0g2f31zScsaMOHxM5k
	uVcfx926TN0CVi2+2IinkwkjowMrXjk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcVfe5s5;
	spf=pass (imf23.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757001450; a=rsa-sha256;
	cv=none;
	b=VicMx2bGr/qB/agUOLbSGScX49Kxr69s2LJQ8bt9/6X64aq+AZYlF2Jlu48ez1Dvrgqwg1
	6eB3L3eFJHpBujJicokO+tej0W740pcG5TBGOElMgWqjsKcMt2E7wG673T3xuz5F0pDfGu
	ex/OmcdfVIinCf5FU3xJ55NX6kZtv0o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757001450; x=1788537450;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=U/9erhoYhlZcSpBP7NuPGJz8BINSYeuVYu8DDPGpOvA=;
  b=PcVfe5s5T18rMWKLFA0uuTvLawcVNrw9JNWD4iRbd2xF6NiuGKn11a9O
   AfFmwctBj2isx714iu6UPvtNUfVNYio475lU0j9UJBuRWIODXkzjJXndD
   gAimkUloSwFNAT5cYsu570+baVSF/oARMeC+V1pFAxgQ1xB5HTYhJka5u
   og/qoUUHhRNEneQU7e84j2DCAW3h47gqae2jDmnwxkBLDeZvUdTHC6wAQ
   TVxUEY+hs3BECTrllydSfC3LVFCC2tmoOFmg9QwIaX6w5YJtmag+XY2XQ
   bF4ol/PDJw3YA3q185CW9QdhdYVBpPvQ8cvXV4y1K8OHIhiSKqll7gAJZ
   A==;
X-CSE-ConnectionGUID: ViY8KvfASvK3uQKYjO4JqQ==
X-CSE-MsgGUID: +p8TxOioTb2NdnRedrHKEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11543"; a="70051446"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="70051446"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 08:57:28 -0700
X-CSE-ConnectionGUID: +QT80w01RuKeaW/5MpWErg==
X-CSE-MsgGUID: D1btvDC7T4aF9bwmLrnVfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="171824229"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.122])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 08:57:27 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: surenb@google.com,
	"Anderson, Russ" <russ.anderson@hpe.com>,
	rppt@kernel.org,
	osalvador@suse.de,
	nao.horiguchi@gmail.com,
	mhocko@suse.com,
	lorenzo.stoakes@oracle.com,
	linmiaohe@huawei.com,
	liam.howlett@oracle.com,
	jiaqiyan@google.com,
	jane.chu@oracle.com,
	david@redhat.com,
	bp@alien8.de,
	"Meyer, Kyle" <kyle.meyer@hpe.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vbabka@suse.cz,
	linux-acpi@vger.kernel.org,
	Tony Luck <tony.luck@intel.com>,
	Shawn Fan <shawn.fan@intel.com>
Subject: [PATCH] ACPI: APEI: GHES: Don't offline huge pages just because BIOS asked
Date: Thu,  4 Sep 2025 08:57:20 -0700
Message-ID: <20250904155720.22149-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rn9hat7i6kmc5madkt86cncjtgtfmxrf
X-Rspam-User: 
X-Rspamd-Queue-Id: AB60F140003
X-Rspamd-Server: rspam01
X-HE-Tag: 1757001449-982783
X-HE-Meta: U2FsdGVkX1+KHDRy6h8BkwSHluxLYExij4YCf5fT+M4eDRH1kqrHR/N/CCQ5yuYDwRogJDiba/9DNwbMojSQKJ/4M/cP3XXEFv2JiLb0DG19JcbwkwXAleFpg3c5KQItPorITbmOtyrYawol6u8dG0EXwg18u6+sT4hOIcRrZQ7hJdlugCQEsTiqfE/BW7EhwYVZgPNGDwWowQALPgXYKiVYbN0ilISwMuSgChvFY6WD0rLfGnc119GnMCpBwpaq782at2E5CY1n20rzONU/zD2ZuE/1dbOX4t2JSv+UxpOcyICv8NCSU/G/qDpB3iTh8bpkP5gsQHvr/nu+dFJnQtZyvLYLSFnyn0RHF4NxFPzVhc4cWe3SlkbybFt2oI89MIIdnhkpEzmcHBkeQThQzgtTuJ4uqjRSD8/ynlYDrIAgOaRiapNYvSnoH/4VhYXD5lW371wiTQJ2X1M8oO5xyFvSNNKNbUkIuyVwLgJmqSLp4vHcgxhLT4KIWVGA3D2ae80sEmC1yyEjL7sLL+wKYBp2EM5zzS+R9JHllCDtbQckeRmfBYJJ6jhDQedyWezaxmymS8lnUdnLo2wChEmFYFcRl6B2JBo4Dcup+ghmVshgHP7Ks8tEO7lxmcfxRIj9AmedkOWCsu4T6T9r6r3/zAeislF3e1gGYG7cSUbm+GFKpY91D6pgumCZRySpIgAykhC8apZZMptQFrStM28xsUveXOs9z2GtRf6T9HA9p8I8a684qkeiFGNQYCxXyOw2oalw9z5Eu4aUNSdMIjocKLxlkuaeby2dWWUOgs8aEgH6O73yWOt3P+3iVClcGgJVWoHxCUGLR4Xjp1m5bkT+XSvtRKDU92btMcIIM4SgmEPiNHpM6tKIdeqzKp7hma4t34pbjgFt9P8JvHdIxwX/Iq4XFUFyXx/xA/+viDtaNQ29FwsnY3D2tYtHXWWf+UPvizGD0BMHppdwJ68PZEH
 FVTF1N7Y
 PEcABje4uTrk9Cy4r3elKgqvvdfhUivw5pBsqR3Qwia7oo0ag8FYx/59038xS3IeqcIcP8s66V4rSsohg/CmGXcKfp51d4c3EXhS2Ev1e6YAXIRMAVsxcp4aPiWzmumR6AuSRkDrh8g+Xa7gSgIFD0oJJin61LqNcBWiqrTLZ8BNDc64IaYcUTV++5u5RTSVmUHA1b3t8zn4a6OkvKtuDvu8o6Gq3nknSXEubWpjPanEggxdYP7TZy15wRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BIOS can supply a GHES error record that reports that the corrected
error threshold has been exceeded. Linux will attempt to soft offline
the page in response.

But "exceeded threshold" has many interpretations. Some BIOS versions
accumulate error counts per-rank, and then report threshold exceeded
when the number of errors crosses a threshold for the rank. Taking
a page offline in this case is unlikely to solve any problems. But
losing a 4KB page will have little impact on the overall system.

On the other hand, taking a huge page offline will have significant
impact (and still not solve any problems).

Check if the GHES record refers to a huge page. Skip the offline
process if the page is huge.

Reported-by: Shawn Fan <shawn.fan@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/apei/ghes.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a0d54993edb3..bacfebdd4969 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -540,8 +540,16 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 
 	/* iff following two events can be handled properly by now */
 	if (sec_sev == GHES_SEV_CORRECTED &&
-	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
+	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
+		unsigned long pfn = PHYS_PFN(mem_err->physical_addr);
+		struct page *page = pfn_to_page(pfn);
+		struct folio *folio = page_folio(page);
+
+		if (folio_test_hugetlb(folio))
+			return false;
+
 		flags = MF_SOFT_OFFLINE;
+	}
 	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
 		flags = sync ? MF_ACTION_REQUIRED : 0;
 
-- 
2.51.0


