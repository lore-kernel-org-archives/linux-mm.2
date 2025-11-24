Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E2CCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 16:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2250B6B000D; Mon, 24 Nov 2025 11:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC0E6B000E; Mon, 24 Nov 2025 11:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1129C6B0010; Mon, 24 Nov 2025 11:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFD7C6B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:56:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2D4C4F4C8
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:56:00 +0000 (UTC)
X-FDA: 84146102880.01.CFA9FB4
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5C8201C001A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:55:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=O8CUk7DG;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=41621b596=ilstam@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=41621b596=ilstam@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764003358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DklLliY6AN74AT2WZnGYkOlsNBTypcLntoZnCtS2gcM=;
	b=YmuNDbdgUy2bDTPKN0qCNTwr4vK7x7P2JEkSKktaFaCw2cUYJdfdr33IaPskR32n4Io1pl
	NcqIJY1t6cyTlvR3stxHCWSdJazxOVvFfrqkpl7yK4C9JYp9EKOP9Kv/oQ2oQj7w+bB8mu
	NKBoSPCdLrylgEyJZ90huzcDm2dHc/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764003358; a=rsa-sha256;
	cv=none;
	b=jzuP5a/gdz0yBPDXb9laodPEE+wH4sG30qSI6GrCYs//Qx+y6paCAhqT+y6Mc/nMS+XnFr
	CpfczonKm5w+Jjf8uWRVIKbPIzwZACDYZ2V1WOexpp9qC9H8ac+h+Mv1owa6ua0g+ZfVzT
	ambNAx3XW0GB41xJpmR79TBg8C0FzYI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=O8CUk7DG;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=41621b596=ilstam@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=41621b596=ilstam@amazon.co.uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764003358; x=1795539358;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DklLliY6AN74AT2WZnGYkOlsNBTypcLntoZnCtS2gcM=;
  b=O8CUk7DGEX9jmPy4J3J5D6clQ91LQMqFrj+IDSeb5VubtUM4Qt795hyt
   YU05gdGo5ENgVYNm9Dej0d2WCnuwZlRKVo//v3y8nY+gXGjKNnri0IQIu
   rEjFSqt3D2YQdoPz3mSs5M4tUV2Q33BudkDdQD19vovV+feDxh/jngOKm
   ZdRBHqbWiWfQ9qZjmFEdAvXfS4waznjHpxIU4gaSxGmavubjg/oinTBkg
   TirTuzbHzMRImjNCkOu3xTgqRm97soa25T9QXhW6LsgsNFF/iNYU0p4oB
   ovvZm454wHXI+Y9N0iGLFENwynNbalv93Aaqh0yGBI9IHCtVAlJoxLHcC
   g==;
X-CSE-ConnectionGUID: fNPqlkkKQJOLXpzGeulCWw==
X-CSE-MsgGUID: DKuq2tyGQxya5blLXf9mXg==
X-IronPort-AV: E=Sophos;i="6.20,223,1758585600"; 
   d="scan'208";a="5619651"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 16:55:40 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:14173]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.46.211:2525] with esmtp (Farcaster)
 id c81b9fde-5d51-4f49-8f6b-6dee1e1c9ec9; Mon, 24 Nov 2025 16:55:40 +0000 (UTC)
X-Farcaster-Flow-ID: c81b9fde-5d51-4f49-8f6b-6dee1e1c9ec9
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 24 Nov 2025 16:55:35 +0000
Received: from u94b036d6357a55.ant.amazon.com.com (10.106.83.8) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 24 Nov 2025 16:55:31 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <david@kernel.org>, <nadav.amit@gmail.com>,
	<huang.ying.caritas@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<bhe@redhat.com>, <nh-open-source@amazon.com>, Ilias Stamatis
	<ilstam@amazon.com>
Subject: [PATCH] Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"
Date: Mon, 24 Nov 2025 16:53:49 +0000
Message-ID: <20251124165349.3377826-1-ilstam@amazon.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.8]
X-ClientProxiedBy: EX19D039UWA002.ant.amazon.com (10.13.139.32) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)
X-Stat-Signature: dw6wsfuhz9mhysjspeqq88m9cdrqk4f5
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C8201C001A
X-Rspamd-Server: rspam10
X-HE-Tag: 1764003358-988956
X-HE-Meta: U2FsdGVkX1/YZo5FuB04uVbk0FamOKsYVO1cJRwEekWkfvgBBM442G0wZqhFifTlKE8jhndqD3uwHs8bkNWg9wI8ei0BKd7kaJVE0VbgwGYuHa6N8R87uk4lsLaqM3Iu5YOH+ioArDeVpq/Pud4zJUhetGA6VDxLDBbn+uDhayPxSiTJr9XQ1AC5lJ7s+bCX2sQQA4MbaC7KtLTLG0+82+sHOtcNt0ei/J2/FZbpNviJ1Ro0LQk6/WlWvbV3j8b28Rv4dJJRIf+/fEhkxf9SlYUKffTESo/syew0CGVeTzADvkx8R2NZmzsBhNqgkYMDaWyT0DfFr1Z1E2AVfsL4/y5EuEaSGM6OReFe0hztOgSA5up0L2Wvj3t++Xn6KWL0dxo4F3yNYBxRz6lIF02iG+3vaHaz7P1vgkC7fAQzd8L0sAMiEiwqWM9RMltnJsjgSJk0AX+ibQYGneGDUEnt8xkO9xdrk55rmKnUVp70e9OO5brE0ilAbjlORvw9wSRWOXXM90z6PyzQICgzP+Mv+Qive+qJtM0xmb6NE+LwQyWhJ39VqKqflihPR7C6/sRwIbwlxgkCqHfD5Ve7PFHtKsKPd/Cn0EtG3dh2d0BMfnJuUkW0Qh3cLPMEgfhRlJFu3pK423Yh+AaVluaFqKAV/Q7R85UVzqO6IIVupNDLGIAefgTeEFu15MZk1pJgQOaDgfx25cQa5jJ0G8sGliQWKWPqr3dyTFPcKcbp6fFUmW4F8CMUnUBlWI0du2APMpetejyCii3LWyLZLcn3Kvm8XnVw///27P4UwBkYR2Q+F1OakbsxdOFUz1xmgmLi5dTASHgyLVfo1HOpSIbhPRv4qqpgZs0zWGj/fvgZnW1SdcaoeaB3Oes+HhPY11cGnqvfebrt5qv0Dh7J4Tfz3HoDlEGlUUVDZ4GyEBZQy8TLKISx1SUOGvYHvIggAWmVjiSNMzFUlMoxVSIWacSp49B
 SXWLZZ6j
 kuBLqlMqOO2LIIikkp+PaUsD2RRdHOsRHiKi3kFB6Pg4wPbMYY+h8KS1IIWeMssNyXSKZcRtsok3TZ/KJvOoByAg4AUf8fVBGi4k49GYpgwhaKJmTKGtWPyXCwqJp7M0XpQGtYCYoUp7iVRYsJBkvDProVHui1hBkm33gYoqu0ROxRNxwk+XS3lkQYc6hkZ5C6IHBrK+Dz4AVT1MJTKpx4BrUGUmI1cPUZ9g3PTszI6k2JS0JVPZG5V2MwA/K1MfJuMVvsVLDFDkbRAIeABcdGDQ7Gp+TeYO18G3eTzbHPfwdliV0HRTIS3BvSVhmheTlcHKpjEYTngUFskkJQfVmHrN/l9GR502FNGM8+mZ5A8q5udcNvdOFiaJoJLPIXUbOgVljvp3q4JWgXc4jsccm2BbFGGeabfvgR3W7JVsDMBKdQZmXUGVasbpfZmlBklzaC0RzezBO4sEtHGNfG6fup1teDvHzYuQyrhATbzIboiT5frwLQg+kcosiYmjtecO8RI9TIbeLAIhQZkr23iB6tntu3JkLAox3RspT2E0TRV9ZFO0X8pAsaq3sKmTrZ8rh5a8A5tyqc627QM4eK5oPkJKup52eHVW0d6gNQVe9Ei9YJ0hIGQaM3U8BwIK1UDK9tRsOVFgrE8hjxydwKaE0ztxXeFpnP7q+7FRnpRNttdKE+0bQwq5BmwDs65Q+gFuHTYUTcLWrPyKokAiZ4fXU7a59WLrsN+cUdyl1PL74O0oaYSeXM0fv2TNTFYKULTmrjQCTttZXpiQlLzcc5nLwg5ThvN3xXGU5CQe63A7EMP0neyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
logic") removed an optimization introduced by commit 756398750e11
("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
was not called out in the message of the first commit explicitly so it's
not entirely clear whether removing the optimization happened
inadvertently or not.

As the original commit message of the optimization explains there is no
point considering the children of a subtree in find_next_iomem_res() if
the top level range does not match. Reinstating the optimization results
in significant performance improvements in systems with very large iomem
maps when mmaping /dev/mem.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 kernel/resource.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index b9fa2a4ce089..e4e9bac12e6e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -341,6 +341,8 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			       unsigned long flags, unsigned long desc,
 			       struct resource *res)
 {
+	/* Skip children until we find a top level range that matches */
+	bool skip_children = true;
 	struct resource *p;
 
 	if (!res)
@@ -351,7 +353,7 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 
 	read_lock(&resource_lock);
 
-	for_each_resource(&iomem_resource, p, false) {
+	for_each_resource(&iomem_resource, p, skip_children) {
 		/* If we passed the resource we are looking for, stop */
 		if (p->start > end) {
 			p = NULL;
@@ -362,6 +364,12 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 		if (p->end < start)
 			continue;
 
+		/*
+		 * We found a top level range that matches what we are looking
+		 * for. Time to start checking children too.
+		 */
+		skip_children = false;
+
 		/* Found a match, break */
 		if (is_type_match(p, flags, desc))
 			break;
-- 
2.43.0


