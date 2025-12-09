Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA8BD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 04:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84BBF6B0005; Mon,  8 Dec 2025 23:48:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC686B0007; Mon,  8 Dec 2025 23:48:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA416B0008; Mon,  8 Dec 2025 23:48:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 581B36B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 23:48:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AC22C044F
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:48:24 +0000 (UTC)
X-FDA: 84198701328.19.AAB8821
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf09.hostedemail.com (Postfix) with ESMTP id C6459140006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:48:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M9iJkDgI;
	spf=pass (imf09.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765255702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vN6Aq/njE6CJjIRH/PbSI6Q15A65PktEQSV8DhVab9g=;
	b=bcnRc+T7ZY2i6fz3y2eLB+6btPFdnTnxljroUXV8YJoavmtCvwK8aclghXdgNWOvmHbr/2
	h4pi9d5XIk3kQbXy6K6yMaqAGd5UiZkzU4E9NzoUJaUb/WYiX+zxrg3KK++cJB570mevk+
	xKrDaqE5EDCxzJgJIuKsWSFk4SE5rPE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765255702; a=rsa-sha256;
	cv=none;
	b=kjcoZTDYmzErPJey2gwWL7S/vT+xdQ52N6V5yoBM04LHL5/Vw7si7qf2rIaKEA3//9tW7p
	xBEgr9yfqqYYQm69GSi+hh3p1UdXGWChhaUfY2E3JIdNcw0I+X8lPojht3ro2/si0+TV0m
	O4AcE8tOKr0QRviHYXdMI0BaoiTwpdg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M9iJkDgI;
	spf=pass (imf09.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765255702; x=1796791702;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tDlKoEC9nLtBsgxGfntiUOgTYLF/8XwN5NDgz58sbUA=;
  b=M9iJkDgInkqNXNC0OVSf5AdVZ0CJvNDOc25+81Sd1rsjL+POEOrdDwKP
   sJJLQOKgLer/Ne7QFci+VfdyTfejfRo9uzyEE1cYvXpPgVrCYN8dl3mrB
   IHF47UsEF8xAfeXEudSEXBPlJNa2A80yWO59ZMST/+QFqsOtot/Oj/Lna
   06dvv2zGwN25oQk1dIR7y6d6a8hJcuj1a5uopSjJtgo2pW00ucfSpJXXf
   RCCj+wt40OvN6bQXvA1pXT83blrPRxK3iZuQfs4bFDpVVVubK1hGSDCBI
   ld4qVeZMJ8pc+kE9nVZ6Kl0jk3xQwyn5yQ/mSGHy6CanrQ+P/6VuoVbXj
   g==;
X-CSE-ConnectionGUID: 5ovbuXJ0RUyoSE4icDPEmg==
X-CSE-MsgGUID: OBDtJ/nUQmCN1j9OlzM8+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="77894305"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="77894305"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:48:21 -0800
X-CSE-ConnectionGUID: O+rESzwJRkamDfhaGtPWbw==
X-CSE-MsgGUID: kzIM6I0KTFSUe2hVEGvCVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="233491915"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by orviesa001.jf.intel.com with ESMTP; 08 Dec 2025 20:48:19 -0800
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH] tools/mm/page_owner_sort: Fix timestamp comparison for stable sorting
Date: Tue,  9 Dec 2025 10:15:52 +0530
Message-Id: <20251209044552.3396468-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C6459140006
X-Stat-Signature: mofe5cjp7y1w8b6ow7m1et7aksm6dk9y
X-Rspam-User: 
X-HE-Tag: 1765255701-498945
X-HE-Meta: U2FsdGVkX19U2crVHmAVLNGa8WEiViqpJsBHmuVgBBr+VbI33WeuGHHKqe82JS4zt3aJ/qmy3Nuq2Y6/JPcN22aqjMNR628geyoeUbcXXXkqWuo9BU9kbMbP9nxpkzfYqMCnb+brccapN4agtrqSuT/VHE9XcAs4Q0UsEZGNB8PJYoHn2ImqFCFp6mdTvtjRTPNTGeiHH9AVPO9YJFgAXeJGFGAKBW0PpiV16YFXsYQcyDm/9mm3MhGNbrwJtlwKTfCPos5eymhZ2dD8N/xnI+b7UPoPlTIax2EChi8vUwEml4WbUYY8TwgKcEw7Fgahg0hednOO/E7Jtnzw3HZaZD7euhtvgh/HGwR0ZFdFk8vng6IBHYIPL4KA+tvv7PTkiDIBoJ9LE7+Udi910YNMtzt8kv5NuXeG267MDX9IUsOv0pRwLNogacZORMx0SbBzkpx9P99IrVPrHofzJE5WUHyI1SN1UXtt2UDocJAGT5AnWtma8Ap6a2+bthexjGDMIAdpkZSIx5TjQIdx5wHly76AMvQpiyUBDI9W19TaD8aIZyBC0MQKcenrwzg4pdfTjaCCHyzfRuS1EN8lJWt8cx4PiicbMOmm6hlk9ptsgjfDBBBB0l7lvMtkD23OXPVho42zaqdsSmvThLXnYi6dZy1fEdTKWTUookdHPYXX8WJAISGREQJFuB37GxQocUzUAH1rYPf+OLBJzTyibhZ/lIffs3iypQ3nSHndQd3+hoMpftCkwgU0CBUsgAyBOj2ncLOSSeX4ngm0MuAZW4ouqJe6GE38QXTeIM8eVblDf9El6137dr1MDEtRzWDB3S47FplnDe8kcht2a1aHqzzE/rLHco3uZZMn/t2eihWyx/z4xnux4A9LBe8X+kWlXQaGP5Mdt4XNBvVOvDeVeda1k/DwMY4Bxa+cdBCyN+IRXW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000159, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ternary operator in compare_ts() returns 1 when timestamps are equal,
causing unstable sorting behavior. Replace with explicit three-way
comparison that returns 0 for equal timestamps, ensuring stable qsort
ordering and consistent output.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
 tools/mm/page_owner_sort.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 880e36df0c11..82d6f6b31348 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -183,7 +183,11 @@ static int compare_ts(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return l1->ts_nsec < l2->ts_nsec ? -1 : 1;
+	if (l1->ts_nsec < l2->ts_nsec)
+		return -1;
+	if (l1->ts_nsec > l2->ts_nsec)
+		return 1;
+	return 0;
 }
 
 static int compare_cull_condition(const void *p1, const void *p2)
-- 
2.34.1


