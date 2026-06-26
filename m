Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D39CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B7E6B00AF; Fri, 26 Jun 2026 05:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4A16B00B1; Fri, 26 Jun 2026 05:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85266B00B2; Fri, 26 Jun 2026 05:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A26D6B00AF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:38:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACDA2A0403
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:26 +0000 (UTC)
X-FDA: 84921563412.19.94D5576
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010039.outbound.protection.outlook.com [52.101.46.39])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6249520004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Wc+sIERw;
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.39 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782466703;
	b=UiPLodI3g9iL+Qg2PVHpLlU1WKWLwcVxUSPj4SlaqfDIid+rRSifmrHNyZQQGOrVc84Nzc
	R3DpQUhoNn25PzNtdBLOpBRNcJ/APfaRp5kFNlG3EO9M2qHnOYARHxRQAPV6fbfXSGNNcV
	+sfo5sPydL+J+FprAL8CBVmg4BvGgKo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jM7ASyLCwmrYD5e5Xf0sdihgZR7KmwptTAnQpBwL27Y=;
	b=HxGFbe2YOrG6QP6v8S5ePwF1uRgB/C5a5VGJLkkGdiGtFhjmF+gB2BwxqREj2MiCrzE7mw
	yd4uMvlLu8zPqqH5CM7zwfvP4y/FNy1/9HN/YOsyegSDp0RzK8ksPFOcFIwT32zGpp79i9
	mbsgxhxWAgWbXQnger7fzUGar1jcpK0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Wc+sIERw;
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.39 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w4R07ZjIMgMkJyKNUC7aV4aw5Y1bXsZBjUNZOi0t/W+DVk46/XWj8RC4XexVKqhP10K6Xy5H9iwf96PvVIw4kS2pW0Y12oM9tqdmT/c2/AMO2cy6TTfleCYgAwQVjZ90huvutftYLOEstGuTcKHMXjYpjqv5lrr43yEAnCSh7j2SsKLEqI1B/xo6uIE2NFnAKvJ2wi4+mHE4EJZZawCkVtbvQkA7GhEUa8a8ZMtNaDQl8HUbRXgLqipSOEoMK242fljLqKb6icta9/pysvpnBoH+DhWzt9cOdzM7AfcAuj9lexBRG7+qRi0FtjMEbbLHM9B3wo1YgCQxBQtoPNprfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jM7ASyLCwmrYD5e5Xf0sdihgZR7KmwptTAnQpBwL27Y=;
 b=YYYD2H2SbGUb4OthTOceZJA4yMKjQPN03hJZqv8YQUOm4ZPTN5FvhM4EwtdI1LwZy4DN+OHNAls5qPqEtPGoW1A55SON5g6veJBFawBMpHIDmlBXUmcQu92XoK3vsrnOD9DbSbYvuBHMNBPLBG544Vprb3obwYn1Kkz+pwKJ6YLYold/Edn+aUOteFe+h4r/qIbexKFiyZ3FKiODwVQ7hb+/fTueWkM8kVD+v7HPvkB0a0R7WbRn3yLlUweC7ANLybWirY0YmSHxNl9ZPW1vhbrLzd9eKbEizmN7z5oJSRk+TFpA97tko4Vs2oqqt+8Xhcgn5ag6oqwkKn9V5fFw3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sk.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jM7ASyLCwmrYD5e5Xf0sdihgZR7KmwptTAnQpBwL27Y=;
 b=Wc+sIERw6YGH/hqgB/tKSb8CK80YRKaa7z2hj6ncomjsHUEGtTdy84koOKtbyi2m1uVd0HX4aiR8BGBw9B5y9rryGVpWpcEprQa2jH/7bFOR8ANdrM8GPMny5IeFA7DWHIJ64EB0r+sxJDoVUUEYBncvdiWpY2Xbc+TCP9Gw5ro=
Received: from CY5PR17CA0034.namprd17.prod.outlook.com (2603:10b6:930:12::19)
 by CH3PR12MB8282.namprd12.prod.outlook.com (2603:10b6:610:124::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 09:38:17 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:930:12:cafe::4a) by CY5PR17CA0034.outlook.office365.com
 (2603:10b6:930:12::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.17 via Frontend Transport; Fri,
 26 Jun 2026 09:38:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Fri, 26 Jun 2026 09:38:16 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 26 Jun
 2026 04:38:11 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Fri, 26 Jun 2026 09:37:48 +0000
Subject: [PATCH 1/3] mm/migrate: rename page to folio leftovers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260626-migrate-cleanups-prep-v1-1-a95933af7619@amd.com>
References: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
In-Reply-To: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>, Dev Jain <dev.jain@arm.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782466686; l=1587;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=A2mRI/IeN+cHHhf/3XYDnweZTQ9AXnaifvILPdKnxAQ=;
 b=/N9hGR4Vd0k03R0181xuT5dYQXaaay4wOZ2t9pfBuTpsi1faMgm4zMoYjQkOpqXYQOxSIss6t
 cFqdE32Uti/D5rKTgHAaCGVNKTCxN3VfASxbMi78uCkvV/jq1x+rGcV
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|CH3PR12MB8282:EE_
X-MS-Office365-Filtering-Correlation-Id: 74c66179-7b17-4050-4d7f-08ded366a668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|7416014|1800799024|36860700016|921020|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	UdxbJaMN+JVzij71Sd3C/jUPEcmWvi7JMVpCSgkZW1CKidnj7Tfhh1Qv5aGigftGCkFoRdPcm6E5ilNPzrZfW5MYLlok/dmq3tGzhBIss5xPgc8FZK9s11TlOq8zMtXUWPfg0fEN0G3UgI4kFw8BV0XQAvsiPOQt9IGuvSoadNstddjYM6qVXGfPMuerNm5eNGpQ/pyQ1Bvf0aW5TFOYEfcjc83vzbX80aoX1IZvX185/iZv1wY6RL7X8bMBVAOn/qcEyZ22yWPD9eBeV0OOCP3Z2LbdRk8265aq24JcvsAT0OdLEcNW8d9W9JaL0DLZCYUcCwVbeDgHkti0FJk9Gk0nEc/JNDLbb0k5wEPw5syfQ93HnowskdDWpBlJDQonZg/oDB4+yND3q6F7qiXi6AVFEVnhVtYHhkH1GpCBfgGey+Q3HUayuL7u8/MmREnLE8/zVNEah4ga1X1EMhDwqVB2Cy0732XlE5Ar2PmwfBzv8Am3zKjeKMZJDgdXmbtKFKmrnFj36JN+4TorSdbaMmD0+EX720M6pc5ac16fotBtJZsmsPMG29RAN0xHgsnZLFv1dWMJBAS6JzLHgGXjFrKr9tz2g8JB+yASsK5uyIyzP1jp3y5VAFjkViTAN06dm8OGeDr/nR3S+qW1LfKlOGmf6/eJ19MQpTCUbMRG7TPxpNGMbyHTeq7HjxnQPLFWgsc0JcWINrt8+qlmEmmi+k64TZuGukRK/Q7+5JOlprREvZdO4PfVSabDRHZKBU7+
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(7416014)(1800799024)(36860700016)(921020)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	R7pQFD1Nwli0jjR2vGQNvYBbjvFamlBEW7kWZN8K3OT5BVHc3lTHsiRE4EODmxh0non7F9KV4c7Phnf6WKDs3VDeVMWHSfR/1Im3sUPdVhySX/Dt8TFSboNYIx7q1+Ai9fPrwpEwCSZXBhiK4hOu4VOFPhlH1uSt0QWvtcQ3Vi7zkPNP4V2ztlkv0aMzXMSugZzYlMmOreYEvltZNbf1hGEduqqsoOGLX8GH0XXaCHZ77xL/9m80bsFI11m37U+VoUfDxp7NgCT+PBs2o0t8r9YWDKe3JM8oDk3QuEmjNyHhJ6r/kWcuCNdriYQ3s8tCN9nRnXWLd37f54P4M0igNuijPxmviEoHFiDT0e/Wrm7kGrY1U8/teemEjzXN6Q2f4LkUcefSQsMSd+YGocJHMmSlSIN9JScJ96E8IqkeIElZImNHDvB4+abV+vhYn1Uh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 09:38:16.4857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c66179-7b17-4050-4d7f-08ded366a668
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8282
X-Rspam-User: 
X-Stat-Signature: 1qxsh63kmxnxr14eocmufx69mgs9byzi
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6249520004
X-HE-Tag: 1782466703-796919
X-HE-Meta: U2FsdGVkX1/ctspLrkcxR7Zi3DaaDE1jPzUX7DMYKbQCt8REZttWTTG1+oHPSWbPs/xECFcbRCV4tGVkEMG5t/0LiriOo8U+eFjQY653IagQefwtylvym0r5G5gaLPW7gnDdUTt0L6Bhyw2xjE4awwrt4WPA4sCcCuNftlgD9QaAxFTl81K9BzfblyWiUbH8wHmiTszkDeqQrATIKAc6BbPzgMx6Pg5ZBsXlMp6diSIjFuKxcKQFegoDEJXMfMSJUlSSdSBsE62gPg5rZKPOg/C70EnbIe0mL1EK/1h9IB2NTOjifoQgfCmyi3qQEjRS+nNmy17dfjpikO7QtRED/t7wXcui+v25i+mSj93YnMn3ZkopYW1slP1UJSn9ixyg7GIf0z2JsDrfkHjgGlzq1+SXRPLe97aRJl4y0I4KWihsqzHdIICnvNI3EaWo5jzTUyLJQI5Afa4VLW1yTITg269cuAUq6qGgkvS3f3K9DAUuPLziQsTdqs2uUk+gExbs2X57JE3t9u4JsOWzggdd9jw65aKuYBCvmvEP5RkImpOA2ozE5dGlCxXwdtPzH1JdkpACJp+RroMNqkFwGE6I8CiifAjYmZBPoNU5jI0msqgKCh8y/n8L2gRegN2mRpLZJ1EDhzzNNpMp25G4VLxqCyQafR838x7nrZRFbLGMrBmIzBhkyNm4SECRfIz3Qka5frTq+Hwp24sP9s6EktGgGn4zS9sy6LT366RcZKbPxlsHZyWk9+j40Pdzrxym6SDseOsXdgwALr4xyVy+uB2XkyEP6Yf2EsDzH9l30psMn4cFC+bZhEWZ7xmsrb95dmN37rVE5Jo7otzyXFSwHPWVxACPBHDvFePCoAFQyLQNdPK14KGSUTvAEAslZ6cCa//iRnssC57CAHVF2LH6a0MTA6lowvMrxLmo3/CE1M4ts+duVGFoHp39HYq7G2Bf0VwHksdMMMmfhEMqvVfdyhi
 Pl72j3ac
 jC8lGzwhb+aSw5Ay4IrVIaPYRcrjScdpCYXMU3G7mrWYlZPnIT6CfE585TUerqiIlluUvLrJvxBRXW5N3Xb/HqSONGZ91Kh9SaP8+/wWexTj5WbYASUz3P93Q9woyoOr2IyN4OICJhnw4lFNQzeOfBaeJbAxUGc4pxDB7WNlmOOtD0wAd15WWM1QNHISOVEjUXQw/u9bRE2488Uyx+/5q0Mt/rXGqBeZcUYRIRsg+GAquHgT3+LcJ83nhEawxmEeoKogloQkoLbcX3ivCLFJTkE8fBXYJTs69N4UOOOyKsLWdgAzcIkbKBAcnatO41TFWc9SVG2k3Zw9fQYpc9F4OY6Cby6IIaGp1aM9AKDUOF+O6NNsZ/4ixEZUhMwF+3IzpGPkX7RcyZ2R5gm6hN7EGHpRAsxR6Xorwhezsbn7P5poyBeMdjBmxbBYdRdr8aNs6xvqr1H7L9WBclG/N/DBOzfy1QkUHVJfH8l66USbpGMgPG5bes1XN2eSprd5qCYGbQEgRMDUO2wz0Qua4CFrzN8Wdenw3+OhE4FveN1ykaM01JNGVRYUMfJt3kU8w9XxmbmjMVwhelA3NNNPQqWVJhe/UpIosUZUKkHs9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename migrate_folio_undo_src()'s page_was_mapped parameter to
folio_was_mapped, matching FOLIO_WAS_MAPPED naming.

Also fix migrate_folio() kerneldoc to say "folio" instead of "page".

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..dd7dbd8d84a0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -884,7 +884,7 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
  * @mapping: The address_space containing the folio.
  * @dst: The folio to migrate the data to.
  * @src: The folio containing the current data.
- * @mode: How to migrate the page.
+ * @mode: How to migrate the folio.
  *
  * Common logic to directly migrate a single LRU folio suitable for
  * folios that do not have private data.
@@ -1157,13 +1157,10 @@ static void __migrate_folio_extract(struct folio *dst,
 }
 
 /* Restore the source folio to the original state upon failure */
-static void migrate_folio_undo_src(struct folio *src,
-				   int page_was_mapped,
-				   struct anon_vma *anon_vma,
-				   bool locked,
-				   struct list_head *ret)
+static void migrate_folio_undo_src(struct folio *src, int folio_was_mapped,
+		struct anon_vma *anon_vma, bool locked, struct list_head *ret)
 {
-	if (page_was_mapped)
+	if (folio_was_mapped)
 		remove_migration_ptes(src, src, 0);
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)

-- 
2.43.0


