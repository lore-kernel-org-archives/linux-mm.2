Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39756606A332
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=fKAVD8PL
Received: by kanga.kvack.org (Postfix)
	id 52C9A6B05C5; Thu, 19 Nov 2026 02:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6B36B05C6; Thu, 19 Nov 2026 02:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C62E6B05C7; Thu, 19 Nov 2026 02:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1846A6B05C5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:12:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CF20A0978
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:52 +0000 (UTC)
X-FDA: 85451001384.17.D4CD94A
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013034.outbound.protection.outlook.com [40.93.201.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7974540003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fKAVD8PL;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.34 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlolxniwPmyd2DChp6X9U+YSoYUVmlMtHnpv88nHQYw=;
	b=I7M2z7ekybIIttwRsru5HbDLtKQp2WiT7WovN9AWGFVUGnx6elmP1Z8PZOUSjBK7ev57Qp
	Yl4PNQPibst7UZ2Cp6uQgBs29doLpKFVkAi+HSa4/BsowAnRXsT5JWU74UVc41u9huaLuZ
	/bJV2rOc1Xn3uv3jtLJ/LtSqHCqMmc4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fKAVD8PL;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.34 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795072369;
	b=TEkkN4t/UjLly8OG94s2OaSeLgzB5g7zD709560rQ5/CjJqMj7xrdyMZIWb9UXJfKy+h5S
	Ug0JVGIlsX4M96YyQMs8aWphPw/P8P+REQ72t4Ifc1btCUBHDgU9Qtf1hdjwui2wpZlv5Q
	hMXE6wilXl7v8qyE8DAgJWxt8jkDDhw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+HPpXOJR4kcObMyUmRATDiZcPwfm6KKFXosnNyIgu8PMXFV6pbIrT8Cd3G1fGUG/KUYUyafazu9lrBxamoWqthgxNUifcHeGWn8svlPp68CK11PmoGfJPa1b12jBFsdGZ12Z+LwOZy2UhD5SSxDEZazCmmUkVzTJwV16nFw/61hBlq7A9VEVrQ+yG8U+00MTqREK5FA9SPC235bzBlyvrvnT564wEf2whXdhPRDjBjTACFximA5SkI/0I9RZ+1M57oBlaEZITmiW8Xx4OQCA8VWsjqzALu3rXv4NUPw4ZufSkJ4iZUlFvWvy8rnMH6bz9FAQ3neovUN6G9OA4wSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlolxniwPmyd2DChp6X9U+YSoYUVmlMtHnpv88nHQYw=;
 b=upzTwsTj3ZjyEdnSIogGfrThQbS4O4yFukUopiHw7unfOKeSlGbyQ13VObIT8b/8Z3xZ74O5i87EV1sFt/LCL1hxQoiER0+7yUi1mS8aju5Imji4eoUPZWRZ4wKbuJpO6URdYLMOeNY0L6AcAajtW6NUnHQgh6nW77MDQ7tH3fIbXXZrXp/BYQ5VHDV+t33fZ+A4sUSsw7AZd/uDK+CBYmdRQYI9emTdXzSXjsCvCyrJL8tRjOmGAQqRnPhTghBaIROvh/aTfOlpbeJHxMBSCe9sxlcyBAMxOdC40iQRSHwI2ZhAdYkc53BG3wsh2ks1UNW2v97fWAF+9HTZ/uIvDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlolxniwPmyd2DChp6X9U+YSoYUVmlMtHnpv88nHQYw=;
 b=fKAVD8PLSqHwonFqElrY/olkV2DNiIkbDpfdiic1NCzHgXEx4VX85SSfH3M0nFjQgMK0CAV9g6MWv+/9s5sRw8PLEzMOjAwVhsrYRe1jWkdnqYw4R61NDNVyhsdu0LkKea94soApfjwA9X2fwUu4gd07J5uIzByYiffRHjQeySM=
Received: from SJ2P220CA0005.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::17)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 07:12:45 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:a03:5da:cafe::9) by SJ2P220CA0005.outlook.office365.com
 (2603:10b6:a03:5da::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 07:12:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 07:12:45 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 01:12:38 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 19 Nov 2026 07:12:01 +0000
Subject: [PATCH v2 6/8] mm/migrate: rename migrate_pages_batch() to
 migrate_folios_batch()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261119-migrate-refactor-shivank-v2-6-f4535bd0bc52@amd.com>
References: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
In-Reply-To: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795072323; l=4160;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=m7JToL1zAswr7HE4Qx1QCa6gmcawM0kq/U+0hplkzdE=;
 b=MvVsN0pAOUAQjS/jtY3EjcJ4HjpCRg+eZSE565LtSDNXm53dCZe4q0w77KxEAuWh41bs80UQw
 zoK0Ci11cumAUOfn6WE8jDrhBPtxbXS9t+G/mvR9uLSWLBS7m0dnlII
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: edbe608e-8583-48a8-0bce-08df460c82b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|82310400026|376014|23010399003|36860700016|22082099003|18002099003|921020|11063799006|261026140227099003|10067099003|56012099006|261026121527099003|261028144727099003|261022105027099003|261021121427099003|261021123027099003|261102123227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	DEKhthPrqBA9Xj1gsqM31FIYAqIggtg6RrCzkRtdTkoHIEGzdIcqeWph5qz7Hr75+CzwLOeQtE/e0bYiSycz1pFVlfwXYZIGjq8cfuq4lzIuCF+T6AmwtABVzjQGs444bUzS22vYEMvMDyR4DHTNcieUF9lzLceyBWVYHE9jEctyw+l/KI3mu/Pw6pwC3Qy85cxo0M+s3eMzorWnAc2SEOki8zjYeCaVrcuYBxi4RJuZVABzT87vDVfznwZAXUbeCsGW2g4qcKaB/H9+Ervq8Zl4qyPQs6Ux60l85L8eR/N9Z2RnNyay29mvkEFNC6WSlWnOuxngI/VtSMHKJTMxn4IesRBwPviKKbuQMj+1Uenm0I+hZQYizDRXEhlghlUpmgJaheLRVfMvek7BmhbKf/izzfOspA8A8jJwrEiLMrWXn9ox4jpUmG/9sKLdKj7gLiwsMVKYoiaM5tFe5kPUAp42sM5b9uFVdYhaQ9NypZlIBskAb9T1ZYs4Kz4aTS/9AbIqoFU3RG8CXz6wF5PNK0enmZ2Goa5vSU2h3uq56o4TDVbvF4TTvuBb7QdF4aZZdDwduCx5kdj/G5p8xFQi1PWkFenC9/2Lo81qfCnQu/iIbNwDRgvNmRBMtRSdoAbbtaDNU1apZRi7egEMQM13Y0RSXv5PzlyZfnvGfneh1t7It6HkC+PHwfXW07sk179ojsVlYTH0kpeBCy93WuAkuNaVNLi9CeCnaD4+JatYR6jrLmXJzVcl+rSRFDQ1EtLD
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(82310400026)(376014)(23010399003)(36860700016)(22082099003)(18002099003)(921020)(11063799006)(261026140227099003)(10067099003)(56012099006)(261026121527099003)(261028144727099003)(261022105027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xPmGvp5mzQKho6d6Tb8kuYyIbY3piLvVz7RMgRJzNl6yFP7i1HIfxXKy4JcUe4kEX96zoIcnThnEKj21OLZXLbEuBLyORN/cX6g8hgk5XBDbozfebviVSmATLlDMe3xj9P8+4ETP9be4iKSnu7DL0TQX06VupgssXLd8W/xovvVoYw930Ywb2SsxapoSBDeiNp2TjMWrASmf0TT0A9Ymvccf8LQkfOtXwVghKe7WEK6zel6C5XuRbpyBoDlrOFAfItpcCMTqu/CraB0zw2/truDfJR/iMGRcoaMDFWoAT5vkDXLkza+1FyQz2N7QFgxj7nZBD+yPzzq/rUliz/HIeH6NMnLBAJJGRo1OOv/tX14hOBiqZBS+v6mr+invlSS24bWl5md77dfjRhjhUoIomubBGGfMkcsOBojOrJdwUM6AmIhntBzj7F6T6QsvXsDw
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:12:45.4963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edbe608e-8583-48a8-0bce-08df460c82b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514
X-Rspamd-Queue-Id: 7974540003
X-Stat-Signature: 5iykyxkapcy4fgfboefwz18oqpktnbba
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795072369-837775
X-HE-Meta: U2FsdGVkX1+8ibr6ZY0Y4VC2dQE1wEDtHliX2LbrBLvOBTxPq7anmxqulQxK6ZeDU6ygM5I6sKeIyNfVJhFWMiAeMfQI4ODVqsUjQf/DQU8DqWrJr3zCsDcLv6SwK++Jy9lUN0OymX9LYuX0Vq6dg75KcZGIiOGbyIgq41yyXPgSOXO6BX9lK8un8S5dhfPAdtdSxm7NRujlnhaagCymG/anTzTHY+/zwWnlqxRgx12khJ7eBTr+OrS3fBM8AGm4X+2rGwSB33jeXr/J87WTuwdYnqdQXtMGJGRZk+co5u6KPK88xRg48bPfbfYBMXJJK1KJU1s7xY9zl1LhVLYlx5myHObdPsGtZLSslcPsXoqk/i5fPkLwT2VPevj03fM+5qiXOmbBM+5Nfjs8p3UzZkszEWsQAWK0TwsFmnKAdru9pQa4Nrn6kie/Og1kq5CJvtnF1C60gm8ULDc4QeU/zOK1pAPtlH1+16oXBBydjn2zKY96A81xuO1zeALUWZqOZYIvm0Bx/hOWVhWWTK+9TZbrNDoZaYGzAM2KjNdeHb+1mdPVh2dAwuq3IhT0mQe63ZeNt9xnzFaJOvTGrk7UksB0cJwFBB2u/2/BpJR25/6Azb5lxenOuVA14BWHBfsQPXRZa3GvSmjxaQGFjX3yW8ZSLmF0OjfoQgKXVs37dPHQkGrxCS3NwO7zG5JRbVYk/sUbcOgTIFzyJnR0s5cSGHDALNRTILnyLzVik+Jhz36yt4UdzlFNGWtLuF8R/PAPaNK14743sYA0CG5lw2AHzNMD7iwC+tGFunIcq0KByzDGBzo7NxRbjhfHAe5H4TyEEd+AUfbF1EgbP6uqLstf74bshm37PO5kVpXU9nSFodiwIk53u9wsXZDcEhk56OiU7EFWANlbkR0l4N4J2sz8tbZ0BSWGdcYHBAiVx0iA9CMe8bbj/XdGLOwfv98O1b4iOWrWpfYl5OQIXPaTvEP
 tYA6DgCn
 S2XMjcMPBNhz+pBAylZKCh0/2M0jHfnAn9n3KnbXoKOgs8gO/nveq6dBS0o+aD/Au0z6tTzUcUYjEednnpdj4N8E9hWFCEHs0wKJbP8DlO/EDBuERAlymK6rlRlX/83iRRPzMuEKGaIl5uSst3quEQgktCCgHkl6hCxzQR7H3um59wllQx8iMAIOYY2EU6kXEXyf/bjXwDV0GKVPjqUwUQUUiRFnoZQfCqjWx0NtHk6YNtHrcwvBF1J27Gkw4Lp0IddJiSDMYX/18M2CBIccCQxxoGVBA6MY0+wvbl1Jz6gfWfoz3MM3/0QGyPxR1OU7IaiK4bj77DBDFpet5dLPKythmm5hyhb2sEzUdTBze8tkhW2RGXN4wMNJUgvz9CNVzUoLIbsB4B4GVFbOdhQhP2h2VQFzxqP05Kl/gDuJ4lowvkYIN9YE6h7tEgzboWkOXU0tiUlA6aq3J4xOTQ+UvIsDaN0jbsUG+GGICvRP1C12JUPl03fHaZxtXgOkn93AsbhOSV380UkAwjyrhNqXKtae0lKYxOgEAN8IiIAksvQWWINT+Bmj0PZogoMIy9nejMxpvDkATI7jY9EaE0b5+x0cpZ701kRH1ct6VyM0xJwITpSlh3S7+XcXBavipy1/WvjF85gLc36bwZswrAuuathXo7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_pages_batch() operates on folios and calls the folio-based unmap,
move and undo helpers. Now that movable_ops-based page migration has been
separated out, rename it to migrate_folios_batch().

No functional changes intended.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index bfd38e6339cf..1d44c6ce48cd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2021,7 +2021,7 @@ static int migrate_folios_unmap(struct list_head *from,
 			 * always reports success when its fromlist is empty.
 			 * stats->nr_thp_failed should be increased too,
 			 * otherwise stats inconsistency will happen when
-			 * migrate_pages_batch is called via migrate_pages()
+			 * migrate_folios_batch is called via migrate_pages()
 			 * with MIGRATE_SYNC and MIGRATE_ASYNC.
 			 *
 			 * Only check it without removing it from the list.
@@ -2153,7 +2153,7 @@ static int migrate_folios_unmap(struct list_head *from,
 }
 
 /*
- * migrate_pages_batch() first unmaps as many folios in the source list as
+ * migrate_folios_batch() first unmaps as many folios in the source list as
  * possible, flushes the TLBs, then moves the unmapped folios.
  *
  * Only MIGRATE_ASYNC may batch multiple folios.  Waiting for a lock or bit
@@ -2161,7 +2161,7 @@ static int migrate_folios_unmap(struct list_head *from,
  * Therefore, if mode != MIGRATE_ASYNC, the source list must contain at most
  * one folio.
  */
-static int migrate_pages_batch(struct list_head *from,
+static int migrate_folios_batch(struct list_head *from,
 		new_folio_t get_new_folio, free_folio_t put_new_folio,
 		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios, struct list_head *split_folios,
@@ -2212,9 +2212,9 @@ static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
 
 	memset(&astats, 0, sizeof(astats));
 	/* Try to migrate in batch with MIGRATE_ASYNC mode firstly */
-	rc = migrate_pages_batch(from, get_new_folio, put_new_folio, private, MIGRATE_ASYNC,
-				 reason, &folios, split_folios, &astats,
-				 NR_MAX_MIGRATE_ASYNC_RETRY);
+	rc = migrate_folios_batch(from, get_new_folio, put_new_folio, private,
+			MIGRATE_ASYNC, reason, &folios, split_folios, &astats,
+			NR_MAX_MIGRATE_ASYNC_RETRY);
 	stats->nr_succeeded += astats.nr_succeeded;
 	stats->nr_thp_succeeded += astats.nr_thp_succeeded;
 	stats->nr_thp_split += astats.nr_thp_split;
@@ -2239,9 +2239,9 @@ static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
 	list_splice_tail_init(&folios, from);
 	while (!list_empty(from)) {
 		list_move(from->next, &folios);
-		rc = migrate_pages_batch(&folios, get_new_folio, put_new_folio,
-					 private, mode, reason, ret_folios,
-					 split_folios, stats, NR_MAX_MIGRATE_SYNC_RETRY);
+		rc = migrate_folios_batch(&folios, get_new_folio, put_new_folio,
+				private, mode, reason, ret_folios, split_folios,
+				stats, NR_MAX_MIGRATE_SYNC_RETRY);
 		list_splice_tail_init(&folios, ret_folios);
 		if (rc < 0)
 			return rc;
@@ -2329,7 +2329,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	else
 		list_splice_init(from, &folios);
 	if (mode == MIGRATE_ASYNC)
-		rc = migrate_pages_batch(&folios, get_new_folio, put_new_folio,
+		rc = migrate_folios_batch(&folios, get_new_folio, put_new_folio,
 				private, mode, reason, &ret_folios,
 				&split_folios, &stats,
 				NR_MAX_MIGRATE_PAGES_RETRY);
@@ -2349,7 +2349,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		 * is counted as 1 failure already.  And, we only try to migrate
 		 * with minimal effort, force MIGRATE_ASYNC mode and retry once.
 		 */
-		migrate_pages_batch(&split_folios, get_new_folio,
+		migrate_folios_batch(&split_folios, get_new_folio,
 				put_new_folio, private, MIGRATE_ASYNC, reason,
 				&ret_folios, NULL, &stats, 1);
 		list_splice_tail_init(&split_folios, &ret_folios);

-- 
2.53.0


