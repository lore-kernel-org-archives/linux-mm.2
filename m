Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAC8C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7358A6B0088; Sun, 12 Jul 2026 03:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70CA36B008A; Sun, 12 Jul 2026 03:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB546B008C; Sun, 12 Jul 2026 03:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3486F6B0088
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:41:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E51EC4167
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:13 +0000 (UTC)
X-FDA: 84979328826.25.9DEB298
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62E82100003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yXilX6+s;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pnx6PsVHcrvSxWAaNCSG/M3DsulMI24w6J6EwBrV9o=;
	b=FUa/CdYEDSpMcTsKb0rkgIFFY7DcVty6hbKDzfYOKIe6i3qYQDV/CvytWC4zG/MnpzA/kN
	8A49fIPZOiFu2z2Gjj49iDhOH1XNRmVQ3dJ4TfeyrMmh7MLj1eXxvY3ILizB0mC1KmH44Y
	NF58ttWKB+TJwlvRHqA5i8ba7qlnjD4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yXilX6+s;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783842070;
	b=rZHFSRyTBQahmjq7CSH0c8jDS/hD2zydfRglq3vOUpI2CKPSkCOyyr3FriwX8bHRb+ul86
	iZ1c/S5+V9CEYsZO9Rdwtn0rkR8GOlbuD9669rGzsSzEP4gadQnnHFjVL0vautgnKBtae5
	UOLB6RLts4k2NjXdnlGzADj5vzDISH4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RKhNOd20jRrZjwqUQcabPs4Jp0c4YV7QJkesXM7tf6FKEo4GTutdrQMh21D5vPYYGjDo6YzitTcmx2azB3tQJt8E7j4WoYi7tEHiy7pdZ0sMCq/KjUuuwufnHvO1zAZzkfDpxpQ3RGwb+ZHttyWvJy+ntMUkE3SIY337yHKWghQ904FP2hIMj0Z3BTnLbkyGDI/WXcAqYVU1ZDhnpBQzMNca2fvMhrcOOVzt1jn9OvlREiIlapcpBwgr/U+K6xP/ux72sJJcIjaJpydsXKkL4dd6ZeumarsTxaRONTwig0CvcPjBlJMBnGrr63Jr+rpzBNSAGwZfyZWxcxhj/9oFTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pnx6PsVHcrvSxWAaNCSG/M3DsulMI24w6J6EwBrV9o=;
 b=MgeFI/DR8l0v245pUQFiHDxf2SHnWDwblR9om8qQGi7U5IBrUAXvmlkYMZk3kEnHC6UopB3lG7OPrV2/QjiVVXitPQVmFkutF1IQUuhRISDH2VZ8xMjdPR489oH6hOnt38DBgcnrcVKugYKH1xNFUXMbheck9+UnTyeJwDNeHISONQm00REpC17XGzThhRPF/CNkpTT19eoo/cX5ak5oQwySiCZFJxYFVI3AZS/m4IfH4+olti8oXrONm+WdiK5lZPWhz/c81c9s49Uv32NfY97OR3nmVZ9wTh2241niQFkaCkaW2P9b90z+YJiWsVAj2/zmt/5FG2iwiIqzN5pgsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pnx6PsVHcrvSxWAaNCSG/M3DsulMI24w6J6EwBrV9o=;
 b=yXilX6+sCKtSqFgF5iwqJIiozRhLtV2nLwFHNolNY3L7IPia5Ua6Unng90Og40Bihwp1f4rFLfbfvGIsXSO05uRV3SGA4OXRsjP0mvrfYyS4P4yjbkg+wUDxlPBaNVBsmL9ep7VUKrBoFGiPKWE2AKsibNoJ45kQIBHT+Yvt96g=
Received: from MN0PR03CA0015.namprd03.prod.outlook.com (2603:10b6:208:52f::17)
 by SJ2PR12MB8717.namprd12.prod.outlook.com (2603:10b6:a03:53d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.19; Sun, 12 Jul
 2026 07:41:00 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:52f:cafe::65) by MN0PR03CA0015.outlook.office365.com
 (2603:10b6:208:52f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.19 via Frontend Transport; Sun,
 12 Jul 2026 07:40:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18 via Frontend Transport; Sun, 12 Jul 2026 07:40:59 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sun, 12 Jul
 2026 02:40:51 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Sun, 12 Jul 2026 07:38:47 +0000
Subject: [PATCH 1/6] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260712-migrate-rmap-batch-v1-1-872a734431d1@amd.com>
References: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
In-Reply-To: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
	<riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783842044; l=4856;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=g1KssW8+1v2HJaJEhqcOFZIerfOk9z+DUKil2dMLEUk=;
 b=PdS3GgyyjGtODvWWy5S3bZHiQpJzmSt5Z3pvDHLGpkbfJO6fF0ARPuaiguu4Zb7pKB5EqhIwt
 f3UF5gyB2T8CUazjdOfaVglvSEKjSmLV2XpYPA7F05LpojSFUyR56V0
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|SJ2PR12MB8717:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb754a3-09c2-4d2c-914c-08dedfe8eabf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|376014|36860700016|7416014|22082099003|18002099003|11063799006|13003099007|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	MYBliWtnoQEevF9RUtEK+QXzWrlA5bUhC6zjO3xbX0GFR+qqhY9BMs6AglSy/0F0BvpGSAW8GoEGrTwFT+zskJvrlp2iL/MQwVoL6fj8A5d4MG4GIGNTuIeH6yhjCwTxKwwDlGfHwxIOlz+lh2FkoYOSHvHcSxG9mwJsDPYvw6IMieDzIWz1wkbTeosh7C9wGJYsrINtpoek5JAyLMS1Hny5VMiW4XMWsrNtsotGQTWfQQBW9FsaY/N/4iIpL4xXzRfla7WttmJhHod9KcrStypjxdnsRbWs80NSCsj4VZWfIwrHMFXE4KYFE6RobwceAYvZ4N2q3UnCx2zZr0M3vhlV6VlMPDrDrwqOPxDbaJLGnGXl4KB8jFWHOmsSJeJxRljybzO+zU01yGQtTmDapybe91pjLJEP1KgwCdJJ9SDH4px9pmxjfOJX00+Kn1GXmkKmqHvllDW17a7TwxaBWPcTq1P/D2pBiq+AAg5+I3jwEszlgoI252QAFW1kzzyOjYHdNPHhB4KYUZA/1jy6wzIOjTn4sXIP6punfVbXwH7f/LDtfIwwCrbT/VFxRVoyUG07zk9rhVbMhXFInYTb3/sqA+A6aQjOwxo3qoFi+horAFNM6/ELkIB64ckyNN1gOC5W141cSEGyTekuzVXHeNeRScRFz1IX3C2zXnXm32oeZIdyAr5pPXH7UpfRoU5CRrikYtej/8yKIqErIVti49fw41oty1YPkYLSl6v2irflNoyWoSyR3xSOGGfO0YDe
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(376014)(36860700016)(7416014)(22082099003)(18002099003)(11063799006)(13003099007)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hjVD6tketPAgS+PzPhktg9HulDDypzqqvuZr1cPIhgYBiM9lDDf1C9n906WiDmI3JJatgtVJ+/OchlpdbXmFtscKTTrR3h4A4t4yM/mQ/zOCa1/X1GZ2+M4ZbJc+9+H4wuuSuqCouZPaDEg2T+FpZcDsfRGAmSPtNmyb59txnmfQFbDwmoYbgP8G9oZlfpA1JnxxBhgKvJq1DrdnnNbwpo6R8lGypdqEpX/yj/n6rIPm0kIoUsky6P+E5Mba9XdZf+TnyX9WoBkb/c4ND+BoBGOOXOX7tG8se449xZT9bRz56H2r8iHL+SOQqUzWvI8l6gygJA6TDFqo9eCyXhACx+UqJR8p1FZfmf1UlAQukZPnuQYdtIcnXD3jHlLBy4DnqW0e7FBVWW4gVSX4PCiaih2tR+9ha7fBl/4UGCi6Q7QLFmQ5levJKKggfXJsGfsY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 07:40:59.6571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb754a3-09c2-4d2c-914c-08dedfe8eabf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8717
X-Stat-Signature: kfsftap63xk3qwq3amw7tc568ukf94ij
X-Rspamd-Queue-Id: 62E82100003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783842070-867640
X-HE-Meta: U2FsdGVkX18z9wcDWk3kdG6pr3WmlsLibkz726RFkrHL2NhiiyynfzmvSqXZbpuSTi9AvXsvrXdqa0l2RwFBdf8/4yJmHZD54g95JpyL47U/xQoRDRYtuyy00ZDjlPMgaFeJneLQzIfdOeAlYakz35sBRseDTm5FW81nJ4MycLV7YcOramVbLwR3B0pIXnRy0TC8LqNAhyOALoXfLA3cdTYqkH1X3NdPvZWeDcvkWRYCU8iEoGo1wl3qix62xkuVwoXuyu+pmOa8B6CZfTAJnamWjiL76RZq+QTIge0Eb8nU/ysvYK5wwg2XoEsfVbVSkvnNJnqOzM7RO5naZHCtOuURbkFWs5xPn36Z+iZ+if7dgPPYhlXW63jZWw3uhNTfk1xqJ70qu6202fthobJdoSPJmhP+LujmGJ6BkX/8GnZTwkwgI1Dz/ylsHj+HRTmmMi4CFJ6jafaaFoSygSgaWIIYM4xiVurIcZDz9g9Vdz5s0k9pYRZkQWfdc/OjIcfuIoMO2ORc7R6/XAZieuY9zdMXr3mPt+b1B554Bo74rCk7PO66h1Cvol5tfXBwXx5tH8u77QDR0MfpFB4eJMtW+/cXXnYPsicFKgb/ZxuI6s8xXUjGXeqIb8ViX42T1RymzQR46zRfv6j+j0D4sb8EteIoo8pjQU9husAYuUKYmkey5lbesBqwygjeGmnCHVtS2VCOXFH4KxSgJpoiZHnj7+8nJqLw7iMrotRWBJJ01lxBb3BM2G+KFkXqF5xeWlNt46OmvLGqMrh3IetaVQn+fx26EfaMPB9wiSATaEIkEKf80t1ddT1LdS4r6MbM9p9COZlA6owHV0byRUtdvYozM4uLbk5eSOxGeJr9baiNoaQ30RGOsrD1Q1OtZfdFD3XglgLyfhLzft8KQW16wUCJpOGjGt0Sc2cRyhufF3RP0wsx8VcZuyhOe0mt/JIBjO7+05lHbYb5g7pvQhqRL09
 c+sAT9dj
 SlrgEWdJM2/gvSyFLYcxDLOZa7qFv+WCuOp4K1ZhjKaqxsEZs+qEjpR2dUyeledY3JMcx5h3j66miq5pl3qf4acirQD16sxB6OISvrh30legiPzQgIEQtljDIP+J1tnRDq/CeBQ48wIp2YNGXsn9fRr7ixgGR5QSET4ewdPx9qDguhvNSqBvH+ONwdgCScChgo/CzFXG1+Pw5/yTYmsDWTJdEm88YPEMTirulrlGuXvMSoEFsU+/Rj3LNpeHR9+39CURrVynwbgPiIiR2i4pnCb9ZTDqZOp6QZvoW4ImthvxmhkIwWgk1VRwHSttQM5R5g40EhPNa+eURe50O1t0kVvFGFnjH1eZqqhHstYITV6msFPJlbh5eg0+qzqEq7mqJa+DXOjKfJev1Nz3g6eCThqSSXSMNqG+OnMhWImbT099m7EIxZG1LRh6UGnVJ2p46m+2+1dIAdCarQgO8LKPefqsbgxAOBL8gMwzk400e9dwXW3hxoEgXYoTEbvzctbJKx/3/P59Ez8/wLodTyuvUagwybepCA4YRAZ9T0f9WgRitfZfX6ggcUA5585XfqQPxOiQ22Zt0ESm6z+9hfV1XxXI4uQ0hxYM2uGrPSWkrOrWUHxWYL4JXPQLP65kkr8/K03HAWTmHW+J/4LoTfcBfnFFAUOI+ZlPZcf5V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dev Jain <dev.jain@arm.com>

To enable batched unmapping of anonymous folios, we need to handle the
sharing of exclusive pages. Hence, a batched version of
folio_try_share_anon_rmap_pte is required.

Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
batch of nr_pages. Refactor the function such that the clearing of the bit
can be done at one place without duplication.

Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
from the PMD path, but currently we only clear the bit on the head page.
Retain this behaviour by setting nr_pages = 1 in case the caller is
folio_try_share_anon_rmap_pmd.

While at it, convert nr_pages to unsigned long to future-proof from
overflow in case P4D-huge mappings etc get supported down the road.
I haven't made such a change in each function receiving nr_pages in
try_to_unmap_one - perhaps this can be done incrementally.

Borrrowed from [PATCH v4 00/12] Optimize anonymous large folio unmapping [1],
will drop and rebase once [1] is merged.

[1] https://lore.kernel.org/linux-mm/20260526063635.61721-10-dev.jain@arm.com/

Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/rmap.h | 52 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..64929490a7cf 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -706,17 +706,18 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum pgtable_level level)
+		struct page *page, unsigned long nr_pages, enum pgtable_level level)
 {
+	/* device private folios cannot get pinned via GUP. */
+	const bool pinnable = likely(!folio_is_device_private(folio));
+
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-	/* device private folios cannot get pinned via GUP. */
-	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
-		return 0;
-	}
+	/* We only clear anon-exclusive from head page of PMD folio */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
 
 	/*
 	 * We have to make sure that when we clear PageAnonExclusive, that
@@ -760,29 +761,38 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 	 * so we use explicit ones here.
 	 */
 
-	/* Paired with the memory barrier in try_grab_folio(). */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
-		smp_mb();
+	if (pinnable) {
+		/* Paired with the memory barrier in try_grab_folio(). */
+		if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+			smp_mb();
 
-	if (unlikely(folio_maybe_dma_pinned(folio)))
-		return -EBUSY;
-	ClearPageAnonExclusive(page);
+		if (unlikely(folio_maybe_dma_pinned(folio)))
+			return -EBUSY;
+	}
+
+	for (;;) {
+		ClearPageAnonExclusive(page);
+		if (--nr_pages == 0)
+			break;
+		page++;
+	}
 
 	/*
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
 	 * gup_must_unshare().
 	 */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+	if (pinnable && IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb__after_atomic();
 	return 0;
 }
 
 /**
- * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
- *				   mapped by a PTE possibly shared to prepare
+ * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
+ *				   mapped by PTEs possibly shared to prepare
  *				   for KSM or temporary unmapping
  * @folio:	The folio to share a mapping of
- * @page:	The mapped exclusive page
+ * @page:	The first mapped exclusive page of the batch in the folio
+ * @nr_pages:	The number of pages to share in the folio (batch size)
  *
  * The caller needs to hold the page table lock and has to have the page table
  * entries cleared/invalidated.
@@ -797,11 +807,19 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
  *
  * Returns 0 if marking the mapped page possibly shared succeeded. Returns
  * -EBUSY otherwise.
+ *
+ * The caller needs to hold the page table lock.
  */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned long nr_pages)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr_pages, PGTABLE_LEVEL_PTE);
+}
+
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
+	return folio_try_share_anon_rmap_ptes(folio, page, 1);
 }
 
 /**

-- 
2.43.0


