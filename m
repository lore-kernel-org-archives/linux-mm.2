Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529E0606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=OB0U8HW2
Received: by kanga.kvack.org (Postfix)
	id 79B636B00EF; Thu, 19 Nov 2026 02:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771636B05B0; Thu, 19 Nov 2026 02:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6874F6B05B6; Thu, 19 Nov 2026 02:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38BC26B00EF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:13:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA9B7809A9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:13:54 +0000 (UTC)
X-FDA: 85451003988.24.AFD2CDE
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	by imf04.hostedemail.com (Postfix) with ESMTP id 867BE40006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:13:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OB0U8HW2;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795072431;
	b=w0Y0gVfMIYz6SbxE4jUPZ4t3JIXoPaLiq2XmwN8TPWAMxOrtWJbVZC82YUZam/5xc1JVIt
	dF2zLtAb/Chbq7FkTXwii90dZcUXcGL7nXT7HzG9olSgL5/a9WzwLTH1Fg+NAnEMo4Y2Vq
	2YQ25rZAPbsvaCBE1KmzE+ihCeVWHts=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OB0U8HW2;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gD3GENhuO1YWX4LRQ7KQ/+e0Pyonw9AoShH21yZSaB8=;
	b=FJqH3TdENtFrTsEqMomjFthFed6bJi3O7O51/R44WNM6TLYNpQ5ICORc6ku2M0CSRHJ0PJ
	dWjgb6LjSq3VQCjyj95CoIYhtmLxQz7Cne+qFVJis5w8W4APY7DKHKI6sWyVDvkBBZFPPh
	Yag+Hq1nBZTq1pu1ojR/OedF8Fq2RXU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bqOikXX1qvFG+/6gKOD55ZACjFVEPOykU5ZuAwJzGM4Bxxy91fll7rkSiftljNzH+r+5rHUc0jWNjKx+m9DLMmD3CTeCiaTEzobCXa/BywhnZVufjxD4UijIH0LGdDXBAf7U6A3zN0gkkfyzDVDfuvn349YkMYCet/MxACivuhzwMO8qtuXidoHxER1enMuSF4/xFMZ38bTZAoSHGpj0diFx1mXvi0IJJhVjJPbXsLshffJhD6hi6ow1HzqIMpzV7o4fZIKm8iTZtQyk0Hq0ZqOY53eTw1NmUmzewBwKrfiu2hERy6fkbh2Ggis87cvEYpCHfMbPTZqqWaRjfYCZBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gD3GENhuO1YWX4LRQ7KQ/+e0Pyonw9AoShH21yZSaB8=;
 b=iTOt//8Mo/Fad8RP1XOhKjAwZJBxif8DB1SkFkwS6loewRylF5hGxdNCIkiDCFF4S2VOz7noFq/yQx1x3jSK5F1knUSjgo2nAL321nsh9b5HOTNeCbB7g7PC9gej2P+G084lGkhqVnQG4hcSdhWe5hSupKrXlLeWD9lfJrHhyvM2OMxL8WbNg4ZMeGl25pQ5qAHjcbmJF+yY0Hnue+peqOFgiep5aKF1hDTs6FNabCt9GjfCPNo0BylEfT94BZAMcr/d72sd4egy25lT9RpFdy64uUnoRrPAlh2S/P4ALgI/cme9gTonb7+EohJYCxqCvDShaoIGMHo38AJ5/lAPrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD3GENhuO1YWX4LRQ7KQ/+e0Pyonw9AoShH21yZSaB8=;
 b=OB0U8HW24bN04bBCo1aZse9hkjalIDYpyZSsdOQ0nxbryUXgBIeUZSQhLY2IDapteK2yfDs4HIvb1XuwlJJQKqn63ZVrRkFjbLKMIDRqQIBQOAiF3e2WabMb+RKtIXlS3pwsDigxUBWf7oN5sa6Wfyt2KdNjzmyFiJdQDQoi0VM=
Received: from MW4PR03CA0122.namprd03.prod.outlook.com (2603:10b6:303:8c::7)
 by PH7PR12MB8793.namprd12.prod.outlook.com (2603:10b6:510:27a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 07:12:09 +0000
Received: from SJ5PEPF000001E8.namprd05.prod.outlook.com
 (2603:10b6:303:8c:cafe::74) by MW4PR03CA0122.outlook.office365.com
 (2603:10b6:303:8c::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Thu,
 19 Nov 2026 07:12:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001E8.mail.protection.outlook.com (10.167.242.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 07:12:09 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 01:12:03 -0600
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH v2 0/8] mm/migrate: separate hugetlb, movable_ops and LRU
 migration paths
Date: Thu, 19 Nov 2026 07:11:55 +0000
Message-ID: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNwQ6CMBBEf4Xs2TWlNkg9+R+GQ90usDGAaUmjI
 f13K549vsnMmw0iB+EIl2qDwEmiLHMBfaiARjcPjOILg1a6Ua02OMkQ3MoYuHe0LgHjKMnNDzT
 MJ2tsT57uUObP0pDXrr51hUeJpf7en1L9TX9Sq/R/aapRofVErj03jSVzdZM/0jJBl3P+APfHh
 P++AAAA
X-Change-ID: 20260824-migrate-refactor-shivank-4ee3949fcdcb
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, "Byungchul
 Park" <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	"Lorenzo Stoakes" <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Yiannis Nikolakopoulos
	<yiannis@zptcorp.com>, "Bharata B Rao" <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Huan Nguyen <nhuhuan@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Matthew Wilcox" <willy@infradead.org>, Hugh
 Dickins <hughd@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795072323; l=5320;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=Uu8uYtQ2yORy/fuidxaInGVCYLnKgmpZ6ZFcwiV/NUo=;
 b=sDvn26z/TNN/f9NOTD8quyM9JeVxL6EYf3vvv9eohk4mEBKkiSdBDbZxYSFhj8XqQhddX75oa
 yxyRCvwpoBAAZsKYeSUJ4a1gnuQKb21ZP3pvCTNbNHzF/Yt3SdtK9nx
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E8:EE_|PH7PR12MB8793:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e4b8a4a-10ef-4b43-5101-08df460c6d11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|376014|7416014|18002099003|6133799003|13003099007|921020|5023799004|261026121527099003|11063799006|56012099006|261026140227099003|261022113327099003|261022075727099003|261028144727099003|261009223027099003|10067099003|261102123227099003|261021123027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	AGxyHClTLsd1zWS+AXdE5T+vv8T2nr8aNsueUU3vj8bom7RyAwnI6OXdFNgiPEo2HqCQ8bmKNeSevMfU9LZFyuoYkxTFGo1x+ppeZqYzmeWnaP32SlnCCoSpxNYfXqJ59Lh3MaoSjs4e8GSfLypDWv3yXcTqDcX4aSZKPuYO5x7psbYLr1aSyZSu0asfQ7ryA8ccAFQNeIvN8q0K3YPpUSeXBamz1L7u4pb5mMRm6jK1Y4SIYwgIS0mnnYDjY6v87xT5mbAHdDMHr++243j2qwo9K6m0nsNu/GUualXPJaift92taGfnJHZlAxE90dFwe8II+Bd0AainLvvzbDbl1fmlTpsK2BXyguAd+MpS1NNgSIKMzJyFduqI+D13a047GfZI+61xqmGrTOjoe36QhAE4oMWZRC5GEJdNfzATFVQZHWYVw93GQDIra8KI62QdT2TqmKHLmAe61kK/Bk2NNhR5plTVGecg95pNBHqFrhLpRuOjolCdR+dRFu6GJY0mUVO2p+X0L8O1YbRgxLWxy4MPI5d6F3X3neToof7R+fLUKe1r/SqTDqZewIw0qZq4oOoTGnuoxXXfcXSFoYaclWeottZIB/z4tDL/qF1uLu4zZae4yPUMen93ZtSi+2WOyHnrR557RVOy5pCMnWk9IHe1gCYeHSwAwxpsq9J5I2G2grH4aYIUWYxqNF0be4IUKFjuentCLADW14iAmDSHrQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(376014)(7416014)(18002099003)(6133799003)(13003099007)(921020)(5023799004)(261026121527099003)(11063799006)(56012099006)(261026140227099003)(261022113327099003)(261022075727099003)(261028144727099003)(261009223027099003)(10067099003)(261102123227099003)(261021123027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ET1SBaZe58ay8INzhS2VgTSLqQoqNmcoMu734jZjdWVLr+3OkfzboJXmlr4I4t+6pzYHovHOosC+J0Eu0hGFstgMeZ+F8FPB6mRKerdeGSVsmABZw8BzZL1VpjGhlZiJ9Nks2z4SGFYF9zMd61/Xt50MwBMkW4Aft443Y/pbH/zLltPFjz8YBpvXwOi6KS0q4puM5zoG0LXq6wQX7dyLRXkdPG8GnrvK3QMsGwGKfhLScht/Ph28OmS5+SSN2NTnreyiXz+Mf8zSgRC5/94OiwEo5Qf8YH/PCzpT2SEosKmlN93baytR8p1dbhPqKbmdZaRju6TIBQ+4jbTg7k5Qa3iicomk9RSzwpAQzWBcJQV0hwsZQe3mPJKnglGzrxO5MLDgDy+QcJRxwI9nzLToMKAvBYHaUK3RxHmwwKYNUwJUfQKPYesIY4UGn63BRS6c
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:12:09.1942
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4b8a4a-10ef-4b43-5101-08df460c6d11
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8793
X-Rspam-User: 
X-Rspamd-Queue-Id: 867BE40006
X-Stat-Signature: rfgoxxi3r1i4xwa9o4ou1nmjyhrsukgq
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795072431-243402
X-HE-Meta: U2FsdGVkX1+AtKXXiQC1U/9Dezu8FwD3DOiyNr83gvECeJzMNm8OfAmCWackGCyjPz6FUj76jS1iU86t8Le7LZABCNYAG8e4GJIF4sAMgTVUp4CpAYUmiJ5zGDBTWkUtZfkmUu67uvtUYdSF7DzbZpc+pLU0jLJBxWFKDfdim03gwkDp0mDpTqiKo+XBRX8YSNukqKwANOfSTq82U946vNCWkbYw7ZkauFioEyrlAwjxb0KmLoqr/S6lc/ey9cExv9lsJk077WVsriPW8upz+7PRbAW7s/4d4I5CJs+Y01SbOFvqFPJ00nIhKVRLVTnz9dYLfAo3s9abcpIsTd7j5+21kflrhG8WawT8POTH4daKWJWVBvss9ZW869Xg7g37RHAbengR2GPi2yW9HoQnXfJdM9z94kPP4jbho3gziZkIeVXbClt6wDyYBCq2nyWLiiaxpl30u0/UzOBssWXhmdDrZZsj38ErCSSVlwBXRYDOj42K4/KASNCiIYqkLST7iAuV58W1f9c7YY4xkVBj7jiODj99nX4coI4fqu0u4zssOFHJwUSxhETtcHPEqub8uIcZa+Unss9jAfwJVrTHA3JjeX4RcMlgIXKypRE6zAAqFR6SDL5l/MY3DAMFT5SASF14lpVG9b6BSkqOpYwnJbepo3D/Gmhl558z4kAqjTtPldP1Wvtax4OS43z9MHdbcFbqshcmZdm3zOsfFvEiC8F6z37Q2smufUr4eq1h4sn12JNtuwpf/CNVHaiKNcyg45GbI5CvXMZIVoyD1ASP93PuxZQVB7uy4kSUB15YBRnU9z2PbD6aXuB37dbd3lESNsQmSZbzHjRFn41iqtl7+tcgK1tBn15Pr10RU373sTcSJkotl12Jyqn70NM5IJgis7lUSt2v1HgM9rJ0WCY5k0qM3Dj/Tf1M1pv6NuE0d6KYUEZhgowbzF+uq00Hg5XzyKWhlisZR0OGieBEG7O
 aNztr4NQ
 /apVmx/WwFLT8T2xxy7c+OQYZI6YWH2/cCY0wBhes63qCdEmAtNQWVdGe9q6jACxcOAhzQoZr3Hq2+rVye/p8JENSqrzx02iIa4kFNW829TQhQNc6y/NzhBFmFCjYeVBQuStREKZDLUAJiIuwht7I1ruz3ykbA2amiX5G6PBktX7skJFSxZfyRPHJ45TvD3nRW4YZltlKPYFoUg0M9aLi1b5HWnxUSNetemjrqDm8udGzUXQQ2ZsHkKrMIdzi9qBS4JFqJXibCShqfUAcRYYp2YMP+zxfkRkEh8/73GWtzgzB50Mhg0SxJ5fZR+f+/B2qjXmIlQNbDpL+P0j7RR+LzsM+5yFZIassvdPaeyqRND7hQR8dhsJPjo7lGr3BC82Vtp2IF61tOasKoPdOEEnej+/4T6WFqG2RD53+zHP26pWkpKa/ABmLbeyz/nBcYJpG9MtHdOv1NeMHfH1IkHOUTx3Xfr9gx4S8gayu9qkhFu1ffoMVEgjYNBJ7xEE+D6WzmysWa1XihZJ6q4qMz+QRnMYEr6XiJXSMw7WpVUzpVaowifu/b95m/iJ6L5YUrI9QO0rkC/M6ghfvlwnIyV+RHWKiJX+G/0V2g86sA+xTm8oH2XI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_pages() handles hugetlb folios, movable_ops pages and LRU folios,
although their locking, mapping and retry requirements differ. It already
dispatches hugetlb folios to a dedicated engine, but that engine rescans
the whole source list on every retry pass, movable_ops pages still pass
through the regular folio unmap and move machinery, and the LRU batching,
synchronous fallback and split folio retry are open-coded in
migrate_pages() itself.

This series sorts the source list by migration class once, gives each
class its own entry point, and splits the LRU batch engine into explicit
unmap, TLB flush, move and undo phases.

Thanks to Zi Yan and David Hildenbrand for the discussions and suggestions
that helped shape this series. I also used LLM tools to refine my ideas,
identify the edge-cases/bugs.

Old flow
========

migrate_pages(mode, reason)
  |
  +-- migrate_hugetlbs()
  |     `-- scan the mixed source list (from) on each retry
  |
  `-- split the remaining list into batches
        |
        +-- MIGRATE_ASYNC
        |     `-- migrate_pages_batch()
        |           inline unmap/retry -> flush -> move/retry
        |
        `-- MIGRATE_SYNC[_LIGHT]
              `-- migrate_pages_sync()
                   +-- try async batch pre-pass
                   `-- retry failures one at a time through
                       migrate_pages_batch()

movable_ops pages are identified by branches inside the batch unmap and
move paths.

New flow
========

migrate_pages(mode, reason)
  |
  +-- sort the source list into hugetlb, movable_ops and LRU lists
  |
  +-- migrate_hugetlbs()
  |     `-- retry each hugetlb folio
  |
  +-- migrate_movable_ops_pages()
  |     `-- allocate, lock, invoke the movable_ops callback and retry
  |
  `-- migrate_lru_folios()
        `-- form bounded LRU batches
              `-- __migrate_lru_folios()
                    +-- async: migrate_folios_batch()
                    +-- sync:
                    |   +-- async batch pre-pass
                    |   `-- retry failures one at a time
                    `-- one async attempt for folios split on the way

migrate_folios_batch()
  |
  +-- migrate_folios_unmap()
  +-- try_to_unmap_flush()
  +-- migrate_folios_move()
  `-- migrate_folios_undo()

migrate_pages() now only sorts and dispatches classes. Each entry point
owns its retries; the LRU entry point also owns batching, the synchronous
fallback and the split folio retry. Folios that are not migrated are still
returned through the original source list.

Motivation
==========

This refactor makes the migration control flow easier to follow and gives
new optimizations clear boundaries and insertion points.

Separating movable_ops also prepares for memdescs, where these pages are
expected to lose their folio representation and folio->lru handoff. The
current list interface remains, but its folio dependencies are now isolated.

As a side benefit, a folio's class is tested once when the source
list is sorted, instead of in every unmap, move and retry pass, and
retrying a hugetlb folio no longer rescans the whole source list.

Behavior Changes
================

No functional change is intended for the LRU and hugetlb migration paths.

The movable_ops pass has three intentional differences:

  - movable_ops pages are attempted before LRU folios;
  - movable_ops pages no longer use the LRU asynchronous pre-pass;
    synchronous callers use their requested mode from the first attempt;
  - a movable_ops callback returning -EAGAIN drops both page locks and
    releases the destination, so a retry allocates a new one.

---
Changes in v2:
- Rebase onto mm-core/for-next.
- Drop the migrate_control patches, will post as a separate
  series; and this series is limited to mm/migrate.c.
- migrate_pages() now sorts hugetlb folios and movable_ops pages onto
  their own lists in a single pass, instead of migrate_hugetlbs() and
  migrate_movable_ops_pages() each scanning the source list.
- movable_ops: count permanent failures in nr_failed_pages as they happen,
  mirroring migrate_hugetlbs(); the totals are unchanged.
- Avoid the migrate_lru_folios() -> __migrate_lru_folios() rename
  by introducing the per-batch function under its final name.
- Some rewording of comments and commit text.
- Link to v1: https://lore.kernel.org/r/20260902-migrate-refactor-shivank-v1-0-9dcca87669c4@amd.com

---
Shivank Garg (8):
      mm/migrate: extract folio unmap phase
      mm/migrate: handle retries in migrate_folios_move()
      mm/migrate: factor out folio splitting on allocation failure
      mm/migrate: use a dedicated list for hugetlb folios
      mm/migrate: add a dedicated movable_ops migration pass
      mm/migrate: rename migrate_pages_batch() to migrate_folios_batch()
      mm/migrate: fold the LRU batch paths into __migrate_lru_folios()
      mm/migrate: add migrate_lru_folios() entry point

 mm/migrate.c | 561 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 378 insertions(+), 183 deletions(-)
---
base-commit: f7d95bf74091373fad7273db4557df9b5a902335
change-id: 20260824-migrate-refactor-shivank-4ee3949fcdcb

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


