Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865F7606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TWinfkdi
Received: by kanga.kvack.org (Postfix)
	id 1568D6B05BA; Tue, 17 Nov 2026 02:17:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12ECA6B05BB; Tue, 17 Nov 2026 02:17:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB2F6B05BD; Tue, 17 Nov 2026 02:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C59776B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:17:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B0F740349
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:20 +0000 (UTC)
X-FDA: 85443755040.13.1748BC2
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013065.outbound.protection.outlook.com [40.93.201.65])
	by imf05.hostedemail.com (Postfix) with ESMTP id 23AC2100005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TWinfkdi;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794899837;
	b=y7OAwqoOSWJpucwO2tf3tyzA++wBzYAkURtOxsUEatgJjfRlLFNIsQv7CnjT5A6FWC91yQ
	K7GT2vcaM4+ImZYEleVIskxDReooQq3LSvlgk8x4uIn/H+L8JK6T4bP9fgQs9tESq+9H0f
	65aDX/ee+KPIEGlNnEQddgvGApr+bmE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TWinfkdi;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCgCFFt5uqQ/lPzcA1arZLOBhqpTkbpUmCYiCY+3BF8=;
	b=Ux8l19NgagerMWhNjdBFtR0ENumiNJl/jv8YOKqRnr111PKMjnCXlCuEK7RrZcAodD1fFr
	JX9iO9o8yodX9JETsGFfGJ/9YHjbNJpmIH2NImY7muhRuu6Ie+RR9YNfdIoM7hf5sOE5bL
	N2KklcJe30omEJjgVIc+Zt3QsIRDCFc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVOEKtKGGkESiEqQ1UhK9avYLXlfHc1edco6B42XlTP0R+Xr786q3BjwlSRrP2V1oqp4VvsvYQO4HqKXlt9BtTLu5/ov8951snVSPhwc4NM6shuRbub83yz1B2lsVgXlMDS4hS4JgLU6d0q2NudI5j1k+KpgevzZdJYtQr1jJBwM37rBETTtjPEf9wgKe3ilUPQditvusW8aVr174qQ+6TwORGFfBBt7I49Dgfpp3QfAfuzAkwHZHKD4FwGD0vvoLJmDPO6/58gFQNAbIgWb4xDpfIY4IAP+Pj2cG6N7u0HLveMu7xz0XFUvlpx5ZFQ4SIMg1OR5HSiuWojwnXKT7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCgCFFt5uqQ/lPzcA1arZLOBhqpTkbpUmCYiCY+3BF8=;
 b=jlAXVFaFQFHUt+93a2A3qHT6nKCCS11KWLb+J6h1AoBJCmTEgSNfscpZPi6ur7HQDJV9VFeDIcFMRd3jsecBk4c2IYLUTZR83RW04EAuEqXofFSD6/A+bdzk1mKOqY8aHYRA4Od6ut1IjngZxTlAdsrm0RCBRpfbJvqCes1Qa2ejFLb8vG2v3c8pvuIfK2zEwiUVD/EzzISq7td5mHB3iz0wtDg9MQjjiqc5HFaU29XTucco3OONUwe2IfOUK0F34E5rI/92NmAMD3rg+jC0h5mtXu3L17akj165BANW+1G4/UGImlntuqudvcSwDajbLWEvFTKOz4GpZSFXo6NZew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCgCFFt5uqQ/lPzcA1arZLOBhqpTkbpUmCYiCY+3BF8=;
 b=TWinfkdiGRjVtFJtrl5CHvVWBXBaIkscJYy6QtzPfcVrfbMVDinyN67U5g0NoKsLDGuO5els1MhrPZGdVFeDzdeyANMuqSQuutwEv89IFNCCSGQ8KbRrLCbL6+ifEz0hohEMRjH0AL41b2os+Q665v/Yebv3iMoFf50spDaR0ig=
Received: from DS1P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:454::15) by
 SACPR12MB056849.namprd12.prod.outlook.com (2603:10b6:806:543::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 07:17:13 +0000
Received: from CH7PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:8:454:cafe::30) by DS1P222CA0009.outlook.office365.com
 (2603:10b6:8:454::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Tue,
 17 Nov 2026 07:17:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH7PEPF00000016.mail.protection.outlook.com (10.167.244.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Tue, 17 Nov 2026 07:17:12 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 01:17:07 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 17 Nov 2026 07:16:48 +0000
Subject: [PATCH mm-new v2 1/5] mm: remove unused helpers from pagemap.h
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com>
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
	<baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Minchan Kim
	<minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794899821; l=1463;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=k1Ln4ldzRiGuFfL32qRTgZ8TcTwq+SUYDoUZOX18brQ=;
 b=jC1uZTJrjVyQ4osTLW4JFqw8tKkeY5KD5RLv9unduvnRpxojUmxVE1FSJx9oO8M4NJnYKO4If
 oTWsg2Y4D58C/z821t83NDem7RvlUz+jyhiwCRGVudvf69G56tVnq3L
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH7PEPF00000016:EE_|SACPR12MB056849:EE_
X-MS-Office365-Filtering-Correlation-Id: cfd69d48-0e18-4042-0997-08df447acd3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|82310400026|36860700016|921020|10067099003|56012099006|11063799006|261021123027099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qdColjVR399NEOiPx2Yjeqcum92ZwzhpNUmOHbKpU1BGVFxMw3Jl9SUs47l/53DArIVXlgLck4EVSLnvJ7e5VXnXjKtlKr4ARI6ouT9rLpHdGlEW1+HhMSmHZZdqKhrCtXj2knW8ddBNVHkFvwuv5OwMGSvr8ciBbYA/fa8Yalgu9qTkQy7an6F6gfLLdggI810qf6+HBHrbWDD5YUlPiE9rwhE0LXWul8NiucsRDabF7RCBycoV0uGiHyLc5GazysLG4klkCRCNZFrcJ0CS7KYsMBbqjVTX7pzAWsTr8L2WE9XF4E20lD/Umhnga4yPilVF6JJoBCMDeh9RjKGb5YbBwVw0rZEVZ42fgSMvhVWZ9fHy4hOR77jHYHiJKWDnXsQ3XrMAxL6rMQ28TOHqO3Nut9mUh6BU2H/umh5q6vC1X3jsk7DsOKAjFTL7z+esc9zlQLdg8CN2eqe/bUuoDiBCf4sj3HxF7B9CVIKa1X0ipaNv6vYAKXV1oz0mmOSRwlPWactiayKXGbps9RyQM+L/7V9La3hLnCIEf9Yilwz4ozOPa+ZPJUvwK6HC9To+sxYsMxw6WsnWT5Z/liQrtErfuaeQYIhoSOU8LY+N6D3GKGcV0CL5nOlrtUx4SEA643XOEIrU/S9c2dOZvZXcd+MO++MoBfz/cFWVn7YHA4c1ByOqQzCmJkBqmon1kLEALScPieSx76oW5aaaYvzFnC66cwxngUc3FjWljJDCakGljm25pdv/B6Jr0wvqJGKe
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(82310400026)(36860700016)(921020)(10067099003)(56012099006)(11063799006)(261021123027099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NtrMGgH+qHW4VGabWYJ2l5VuklG19kNZenrHzszPQBscsMT9e8bQNPMlkvpgZ8325felPFeMd9Bke+l2K0e6ojquoA7gp76Yf+1tzwjVG3CuiPp+2zxfyWD/vWt3082M78ZiiP1HmcQ3znqDb+B+kjcUey28GfAwaG5/aiOHIzO4zQu0o5Yw0DJJYUZ12V8ZWTOxXMXe5TW4aUwB37uySZzYMcm0EGbruWjHtjhy8Tn3/tTi6dLVRcJN0IVeAq2rYZg0uqKlAt5S0osR+9x6VTiR5Dc8NFonn+ksOt8U1k9gY4CoZqnJrgeIArisgTDvwCAHmMy0d/fVYa7ctwP2/Kb4u1JWKzRzN6NHjqeLEfZb5WzQ4Sd48C9dqx9vCF42K8KdBB/BWqr9PCqpxIdK1ArMnbIbx23BzEgmEjbXVRDpG6uQULOEQpB/4HZ+crX2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 07:17:12.9235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd69d48-0e18-4042-0997-08df447acd3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH7PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SACPR12MB056849
X-Rspam-User: 
X-Rspamd-Queue-Id: 23AC2100005
X-Stat-Signature: m1aun5xy9f6j45n6u3s9cf6id5xamztu
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794899836-306207
X-HE-Meta: U2FsdGVkX19LroecQZml3DuVBdZpDdxxAYUU0C/RIa1ovFcLK8q4WmV6K97je7/cbhViJUK1k6pd7UA/fVJr7yBjSG3v3bHuwclRCm3m0bfxteXCtqXWYi3AcYRtrxD3GIS7T+z3w+ljioVwaBaxr8W+iugdKaN0LSlHLWRaWEIkoZY+klZhaObn/SOvxA7568DBZWGIwy7dKxvkSvR+omZFTIe2A6ByS6QPRx1rKN+SAimxk3rdkCXH+AjvwJHzYLdijz0plHp8E+3SgfKUv78/33IGa3VH+0nkKjYidjhp0ihZR+xizkDM0oJRjBAbCskw7du46ACAcIHy9BoTyYUahy2xPGbZE/4Z8XcZW+u0TfgIT1nkgs/ES2YPnNNCDXchS1d3LSa+ZvpdqgV9LkbC6BXT+4z1ACtabMAS4WkRTx0MyqVSyI7d8lF8UEiqRaPLhMOICgXdeINSexN5Iv/1SheUkOmFyYwuKorflBy7lNv1vwMInctTUlGetMdXG15Hacfiwz0C7jcSbLm145JVPh43gtml2PeaRw8z/Dib2zO/x9L4itMOraIjFw1XWkUB25zlZY6NSKkx4WzAtkGhS1in2JVcmNwO9y+bjwfZ+EpHClBu0jTOiwSg82SyTDb5hC5Q/zpRxyghhA2U8IxpxKe9phERsJvAvqBlgEUijbdxf682tc5Iimp/BYOZGmCufbuSrC0QCjWV/CpksddHkNRtmAyDoHLhCv5XcymhEampnIh+mQ0LWv2cKXyAj6V6ul6cMb26YtrRfrFMXGfcmSufvGFQWxT1EpC1AnuS4Ef8y5JhZmJ0lMiKfs9TgzLagUchGvMOdTaEUaz8yxZZb4AQmup4DaD2bha0A2GGBFNYfsPAVnArhUlHNjKvvJrAVfJJPcT9mi942aJutj1qJWlIkqV7cDncu1PB/KEcCZUpe8n3/tU6k0LStdki9cZQKh0B+14yIqcG627
 Zmy+SHLq
 m3gKPmt5I6hujQRHri6ixaMrrtnW7Pyl65TLZg5XWOsj0dGiJQ95REfxCIBzBjvpdzh7k/lAb+TUYgV1bruNyPgrWKK79jYtKxjXnV1lubR0wlBNexwtwiHu5YlqzQH0/RiTdIKzsytnL0gzAzb6ZIRC+aZRA8iHjc+kdsNhKT68brgGTL0JSpPj6chOdtA410sQvlSAieeaUiIpfQxJfmx0PkYhAXB2scZ0XgL1ujWDLy+CJF3/bzWr2Z7A1EkHzMzJWQriA8u2Nw3FFX6WQqO+J8VywBKCfY3oZbEXjKvq3N5x+rc1G6VNUXke3Wd8TO+IYxtfVKj48VJ6iaosmqSk8NfLxqfpKg3+Lvt/SWjeaoaugjHQ9UI3CLKIyHECN6gn+ujmiF5laUMN+Vvm7yI2TFsVWjcu90b1hxcha611l1twPzKERhlIGDLG+XVzkryR5pCjemm4temZn9Mh5c9yNDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

invalidate_remote_inode() lost its last user in commit d73065e60dcc
("afs: Use alternative invalidation to using launder_folio").
mapping_clear_release_always() has no callers.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/pagemap.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a37367..e681a7ba6642 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -20,12 +20,6 @@ struct folio_batch;
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
-static inline void invalidate_remote_inode(struct inode *inode)
-{
-	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-	    S_ISLNK(inode->i_mode))
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
-}
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
@@ -298,11 +292,6 @@ static inline void mapping_set_release_always(struct address_space *mapping)
 	set_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
-static inline void mapping_clear_release_always(struct address_space *mapping)
-{
-	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
-}
-
 static inline bool mapping_stable_writes(const struct address_space *mapping)
 {
 	return test_bit(AS_STABLE_WRITES, &mapping->flags);

-- 
2.53.0


