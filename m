Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CAF2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A736B00A7; Tue, 30 Jun 2026 03:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33FB6B00A8; Tue, 30 Jun 2026 03:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4ADC6B00B3; Tue, 30 Jun 2026 03:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B90746B00A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:29:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 384051203D7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:59 +0000 (UTC)
X-FDA: 84935754918.28.089C68D
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	by imf22.hostedemail.com (Postfix) with ESMTP id 195C4C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=I+QmAqWB;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.26 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782804596;
	b=rz2LGU2DZkmq2/unFN3o+Y6kupjmEFT6ZxxE1uASzYHBt0/aux32Y3bJnbSnGr2vcyz7CO
	ohfYwMkFQ09QgVlztYqiuGRb1aqO+xGANe9NcrHozWC0xlPctHCbGWH+LArp7qNmc+X6wR
	lS3nKy1bdQts/jeJZB2ENmZR/wWD6cM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr7EN25FGHy2WNXJ2WFtyz68nDJht+RoVhPaCGfdrMI=;
	b=DT876/ENh+YaCkeYaRBj4ZAyDsUWleHT/iTloWhrS4jDhB0fqkwkAKMsr/wYpEEh6w+9E+
	pW8oK2VLWl2+wQL8xQVySdBq7kUneBl97vr0EJTY9xOPnWPwnHFcJE+KCm4V7mAh6amVrz
	2EXXqDhcJ8eqwFMREy2HPjCDDxrWkhs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=I+QmAqWB;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.26 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cgh+LSIE1aZEfrsmxjQtBIXELsPmmgTuvzmfDuAjtfIz6ZK7KuHhCi2ZrxYQKlgWLRRWajqrItHATTGZwpC0J5CsE3JBjDvzdQTYRKmAJCdSzc+VR5WxN21bGe9vpIPwfXvLp+B25u0XPNhOoZFLz51PWd9lmhCdXLy+tQLCvvJp3u9ePbzqd6OZBdB0uB29f3oc9uvPKpITgTF/jQr6upU3WDtnXIueZ+OdsJMgDqjr/zhRGDAcYOKJSdsUbuTsiYLf1nx7N9kFGI2EVriQXP8d3JE76qc2zex9D/NkDTXtiABdJA1Apq3TuoXpfFijKP6BD3I4o0RNW+52bmsAtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yr7EN25FGHy2WNXJ2WFtyz68nDJht+RoVhPaCGfdrMI=;
 b=n7neJH/SgTK1i2BGiHcx06WcsfwNT+XU0FHXnQ4CLjf9u1tB1iMq0Cse4SDB7JHxkMYC6fNSdXX9/jZngMjjL+z+vWMRhxA3Oa1nMQbGTD9bwI7c4s5njlsg2IZQ4qKv9DQhJx+lw9W0HV8EdEgl6ujsJxQRRMuFmEZAOIWNQLWFARHzXiBdYAMlC/B5x5rHcp9TCdBGSWMGGMYKubUtzc6S8EdSvzADq3WG+LXQmJ2ob2wiASGeQVE8lEAMjDRNDUVGTPqlCzQbOIsft6sXk9nlUn05sSvS2vJxsx188ySmJln+mN+1y1dV6ksZBzhMxM05f2z+Jas1jnX40ocHug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yr7EN25FGHy2WNXJ2WFtyz68nDJht+RoVhPaCGfdrMI=;
 b=I+QmAqWBr2jso1rXMw9zvEXLsPSai5oeLIKOv7BqHIH7mQ1KqVVkvme6xC762pv6lEeDwmtoC1Z4d/dd36JjZGJaqM6iPIKA5aYMyUL6S3QCHqhVk3JRHqV99fFg6G/zY5t8O5FcNzcvZZlDK3JewmnZNnlxl1oEUVnzfFVNg5Y=
Received: from BLAPR03CA0017.namprd03.prod.outlook.com (2603:10b6:208:32b::22)
 by DSVPR12MB999124.namprd12.prod.outlook.com (2603:10b6:8:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 07:29:49 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:32b:cafe::20) by BLAPR03CA0017.outlook.office365.com
 (2603:10b6:208:32b::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Tue, 30
 Jun 2026 07:29:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 07:29:49 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 02:29:38 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 30 Jun 2026 07:28:41 +0000
Subject: [PATCH RFC v6 5/5] mm/migrate: adjust NR_MAX_BATCHED_MIGRATION for
 testing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260630-shivank-batch-migrate-offload-v6-5-da95d7e8b8a2@amd.com>
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
In-Reply-To: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Teja Vojjala <tejavojjala@google.com>, Pravin Tamkhane
	<pravintamkhane@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Matthew Wilcox <willy@infradead.org>, Davidlohr Bueso
	<dave@stgolabs.net>, Vinod Koul <vkoul@kernel.org>, Bharata B Rao
	<bharata@amd.com>, SeongJae Park <sj@kernel.org>, David Rientjes
	<rientjes@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>, Dave Hansen <dave.hansen@intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>, Shakeel Butt
	<shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Fan Ni
	<nifan.cxl@gmail.com>, Jonathan Cameron <jic23@kernel.org>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, Nathan Lynch <nathan.lynch@amd.com>, Frank Li
	<Frank.li@nxp.com>, Dan Williams <djbw@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804526; l=724;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=louhjrGsTxx8XuTEJjLwJVyFsv1SqYtF0BLxW9jEzW8=;
 b=YGTxxInII2RV9KKaO26F2QO52DCGpBWZN4bLeFOZ8PyXLoBL+UwekFJl79DxF0sqLvSqSbtvF
 Rpl6b92AaS5CXfmlAe2rhhPppaIwUI3DcVMHAw9akd7roy/ZZdGAl8x
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|DSVPR12MB999124:EE_
X-MS-Office365-Filtering-Correlation-Id: 22278ff8-e138-4179-d38c-08ded6795e26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|7416014|376014|921020|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+Xr19c5ulriDUeE5a1kvU5PIrPUFmsD5l6BCfZ0gmxUTyPGguKNxxR1vOIzD9MNyagIc5jkWLaCFIeuiJLUJkvaKpBRhme+CjfNrQUjQVlbNLuqO1u5psqRobT3050z2+oTAdUQTTDxIvCDe8if6SurZEVDOwLiezqX78Wij13b+DisRJDUCq6BkPPf7Z2mQOMjbRY/bI2nZO3MaLT+EiHZmbSn6UF4tzR4BKmxRb73PpafgKoPcB+/P7jEAVgy20QJ4LZA/PQNq6CSDW70fyCeMj0zDQVps21xX6lAICS8WeM9tcFT9woY0APKqp7tvliW43gc6m5qFswHdjTziUfZrfW5ET8d4mNtzJQr3vqmr5lW9PZ+/jbB40khPHZhDbUthdwcTjlsfT3C0EELl+TJfKW04zmV3dFzmV+uiPuVuX09c07XOUJjKrR5+c8+t4p5inNNZBCqsbWykn6TSi9NVWIqlGhlSKMln5aFQEaUmd/TgMS+ZJ9k0HXlH5Q61muHBCpF+n/wzu/Ys8OCt7gTXQTBOTS9zaLIWhXXRhN93RGA9qda1J41PyMOHoPNPexhuC7yeIwBZhj5+/ZdU0Igo/IfA6yKL33q0oxPgVJ3BCiEKm32H34cXGlby8l0UKTmCWbut+lcHB7H9s6aK8VCGJ3aEMxUNWTa0TmL3SuZTZCbRO0lEapqw7mV9hubUU4eifgJZCOQXngbRbAlYyZLjd2MPHrKJuYguKDylaCNc3nte7aNMoFBxR7X7Fnmc
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(7416014)(376014)(921020)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Zv0Ys+2pwUCwIVS6OBz4ufaKblVvO5YIFSiJ7428SOXML6X3pNRBxkz357P5Z5loHfP7oka+3+H+Ei78++uHlQzlGRORI9iIM9rurU9VDOV35cit5Otw0FX4h7wEgXZWMQSLtCH8jR5XCfahyRX4+oV2MT9svCJvVyPSnDFPt7PMzHEFRJODLwCeIf60xN4xMfJEaIFhS2FHEfiQW0v4Y2cEGYlOje5MojUSUsgnpZacDVumWmow2t92kEnS4rtrT70p+nYYvKRn+LqAWkdt77ZmQ/Kpv+AhZdgWGzO88lL4q/lUZcg4q/RVSIin/+kIqvnusdoi/xPNlUPMV8L6fwX4lLQaody8ABKTarN6p5zc9sb0EVYlHI5sFwTWNuIhXojMcFdEEdmm5fVzTiT4TBvCjvDjUc6kb1rGAwPfhWTQ+xj1HY3mtNiy6OGoVW2O
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 07:29:49.1738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22278ff8-e138-4179-d38c-08ded6795e26
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999124
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 195C4C0003
X-Rspam-User: 
X-Stat-Signature: f7w6pdfmc3gj6mf7fq93jqtowun7e1mo
X-HE-Tag: 1782804595-849932
X-HE-Meta: U2FsdGVkX18JTrZcABRzI7zbeikZztxa6IkRuXTGm3ELqVNiCTgd4uBnR9+Ie7iPBJ4s1P1KATDzSEF1TwgE2uCMx5pJNsPFJaFYJ5iBz+yIXVZy6RAG2j5FQW8yQSp0WP11Tb0EIRVymdq4+ad7qiO/N9CRwLSRLllc7mN0U+sOkdNo4kM50NdkEmnUMu3vS2707/JXUPn+VAOXyi01hxqzAh8RYttRFO6mkNMCJa2kmROzm/2wxEEZkpwc2LcBybck0yCgvM6jmbAZl8CUX+ubu0hprd2JR+0C8Be8OVuUucdQE5hQzHncWvCmGByRA7askmNcRqGMVf1vxjPm/PGDReERVvatmgy7kFx7XN9TZOl1tdrWu0ybBEWQvO8aI/wZn4qCXeSgzPGTBf++wK6sN36s0Hg6K23EJAVgqOE6pUwCz+xPpOB1g2fX24fZVWzBZTr5p7uO837LOtEbEd8SLD8+UAdjKkY1jaxIyKXVHnBeU0xSo2dCpL/JVNYZXeGQHzcft4+G3VODQk9N+/9nh4iGLiAM0+7U6qUtAklllpOuJFxTlybb7k2vtGsCpb1gOZlasxbwk36v93wKM85UwS720/ELZV19P/f6FwSj8Ii5UzHiuea8vN/i1sDs0BhGfhfTLWXgrEPkix12zKJ7FEfEYKr6njHu7oqfEUxlWYe96rrvCObRXEBxvxfd/FxvbTbg9NKMMgv2Cb9pwydoS9GtxfgxYlRoISQQOsVpwhg5PXxR0R3I6GVVjFZrI/H76rk3S+HoE/xhctBkI1LAgAYb1Ddm2TFZmfH+VcCKuXLO60dgpd2206XeUAYoeu89SHLp+WTkbp/1te8OFS85NHrtbWsYiABj7OsxZdtQZEO8lRV0hLzSon2t6tApp/C2Z1Arcwke3PeAYCsAuxBmW1r7Cc8w0XKpGULx9otKD6yoZieZNqUv1bsjnUYYgQL0O3Cbw1LKL+YgWc0
 i+Mqvnjr
 +1zOp8Qo6NMIDGlvacuOCSbdOhozLWE+UDIthATVqbaKDrmcltRoQ6hd+yk7ouNWIgSi/Zq01snlLjlZrHe23pUoxR8rb2S+xAIg5zEv9AltZp6pH5vHaPUqOLkTUA2HYKHdnYJ2QuYcfknvxr3uGOVg0AELs805diTo8GwXiDGugT4EgsNVcWGDpwBqMKFL2yOKMGCTYL8qcegM7q1Z5SvYCTwJxypqcvaKfu02MRtpWKmzvALoyXOzk9Uwb8mS+nwTuNvOJ/1g59/3OPoa2ScCHegD3Mm7vUmS2z6Lbl2JikUxJEuaFldROAMdBRTmJYmuq6xKmMxj1znMSk8L99ACB9RmWwJ01+JRQPVRadnUhNjCrWS4m/VdGwoG+X9+vPhbHl1uRRDlkyjrKA00Ckf8doFdREloBiuUuK1cZvDFksT0kLDSxc+oqEaAE+iwmZM8FR8/s59LiSdS8Q0GkjYAzqpqCPItvaydMcKRx7M3XU8NAzwka2ey94ceHPSHzWH+oe6M7JHaBUKBdPv8b4iujQahD3W1v+KIGgZ9mKrtnW0N+lxKHBpo7Sh4Mw+/nphwbYMAeakzcuOAVUMCXvp8OjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zi Yan <ziy@nvidia.com>

Change NR_MAX_BATCHED_MIGRATION to HPAGE_PUD_NR to allow batching THP
copies.

These are for testing purpose only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 4fed3110ca0a..4be1f3dc1603 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1592,7 +1592,7 @@ static inline int try_split_folio(struct folio *folio, struct list_head *split_f
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define NR_MAX_BATCHED_MIGRATION	HPAGE_PMD_NR
+#define NR_MAX_BATCHED_MIGRATION	HPAGE_PUD_NR
 #else
 #define NR_MAX_BATCHED_MIGRATION	512
 #endif

-- 
2.43.0


