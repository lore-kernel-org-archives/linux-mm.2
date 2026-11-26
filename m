Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B986A606A339
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=r1rvClhj
Received: by kanga.kvack.org (Postfix)
	id 596AF6B05B4; Thu, 26 Nov 2026 04:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546B86B05B5; Thu, 26 Nov 2026 04:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0276B05B9; Thu, 26 Nov 2026 04:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B21716B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:53:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9ADE81A06F1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:53:50 +0000 (UTC)
X-FDA: 85476808620.21.891595D
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011070.outbound.protection.outlook.com [52.101.52.70])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E89140008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:53:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=r1rvClhj;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.70 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795686827;
	b=a497aMFcVgOCdac58XFjITdjngKOAK5CY8KuriM7BHmaA2gRswoj+Js4RpC6rLenRrRMD9
	A7hMcAGHOfWOyVUKdetLms7BwvWeJJH2xd1NZi/+/Zne3K4V62WfyF1+2OzIHQwFJOuR+w
	1ALFULP3lJH8GvgUUexVBglzTz1m8+U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORKKCPJqEqKM1XtErzbQuz66Rl8OL88bYCArj7LSs8A=;
	b=vfitYKz9C9qz90j33yHWhK3aaXJ2T/GjVjiEPdOg7oEZkm4FMfqIeroKltF2NBA78fyCxI
	82xyhDaOhdDYxjLRFPhp/5GHj0Tef9B8x9XkMEfsazEWIKHYx6O/olagA/BlcVf8K9zCNK
	NaVe/BEP3D/jygjAtGpNg4Blrrb6sV0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=r1rvClhj;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.70 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ib+B89i1k4IhnHnikkxUYf+YOPbed682/iU8I9YM+RMt0N+PvinNZO0hkhbnHSOSXHHyOhviG6fP/vX31LpyE/SBvuny5aGh683/2JYYALYW3EKY03PfkB2ccO9En6QcA0KlW1kJdcJar26KIA/mfEsCsUB6IIJu0XQpmTFt9lMv2qtp7H9v4EXSTke51w6IK5kpbtvFf8tt9THDJDxIDhTyZxSJzhh3oWfOND/lqVpuZSEKndb+Ui5xqwINIzZ6f/Vfk9s1kWFkCYPA1Fb+Qc19hRLsY0uuaCE4bhYuLtEWCF/QZTGNNM1DvE34KU1nDr5GxR2GVTsCG22Aln++Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORKKCPJqEqKM1XtErzbQuz66Rl8OL88bYCArj7LSs8A=;
 b=qJQFeMyCuUXftxbLeeeRG6otNQrABsjU/KCxxc0kWOaTpAc8b7vZfWqy1HEkgJcVc3Nf0dIotWKYah/Qi2T/ZgCGxXcOJC2EX2OY9jzGRfLCZhpxOiizOZxBEyNYJkhr5yj5gIZ5kyozWDZXSWiIf/H+dBytt29IirmdmbQnmd+9V+dn9OuhmYTmh+JPSecEEqIffXuCKIMotJxv1X9wwN4z7Lgv2bJRmrryQcdOnpIppnT13o6xnA3SxCNNdYPQjLQpXFpT0lk1V3+ULceDzcKTytsnnHAiQF6kRyp51lZ1JgDT7aEUnrSepAQPctrrOTSsG1epW4gTnsIiDyJ6cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORKKCPJqEqKM1XtErzbQuz66Rl8OL88bYCArj7LSs8A=;
 b=r1rvClhj1IQjvhZpoQJCIKpQaPY5yBlKnxSNd/l4V5NF7/7WlkvfeZuAs9JtskI6rTcaxKyBprY5lSbW/JBYmkacBnGlpyY/tnA3urTjDTfyOW6Cg9pWcF/9A8RT+d+gZqaM5OTUPZOmNPuZO/c4CSvuM3y9ylRCUIL+1G5fzPM=
Received: from CH2PR07CA0054.namprd07.prod.outlook.com (2603:10b6:610:5b::28)
 by MN0PR12MB5833.namprd12.prod.outlook.com (2603:10b6:208:378::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 09:53:42 +0000
Received: from CH01EPF000BE94F.namprd02.prod.outlook.com
 (2603:10b6:610:5b:cafe::87) by CH2PR07CA0054.outlook.office365.com
 (2603:10b6:610:5b::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 09:53:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94F.mail.protection.outlook.com (10.167.244.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 09:53:42 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 03:53:33 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 26 Nov 2026 09:53:02 +0000
Subject: [PATCH v3 2/3] mm/rmap: split try_to_migrate_hugetlb_one() out of
 try_to_migrate_one()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261126-migrate-rmap-batch-v3-2-4112998fb472@amd.com>
References: <20261126-migrate-rmap-batch-v3-0-4112998fb472@amd.com>
In-Reply-To: <20261126-migrate-rmap-batch-v3-0-4112998fb472@amd.com>
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
 Popple" <apopple@nvidia.com>, Joanne Koong <joannelkoong@gmail.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, Usama Arif
	<usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795686783; l=12628;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=ffdKyMhcxO5El/sVYUpBhMQwEgvt5dIVgDLTc69rvTs=;
 b=07XycwemAC99aP8bcu8Jjy0da/TzFmwPTrT/jfreOOfGzuwiyaAV8v3DIke+rHGcFUgaBZtFQ
 Em1PszNb6M9B9TUzdvJDdSUQV+5YpvvdV+I2xNbQookNwv78Ue5tTym
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94F:EE_|MN0PR12MB5833:EE_
X-MS-Office365-Filtering-Correlation-Id: c38c2fab-24a9-43f8-6603-08df4ba32758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|7416014|22082099003|18002099003|921020|56012099006|11063799006|261022105027099003|261026121527099003|261028144727099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	GExtlAlP9ybZTZRoB2lvz4skeSVpW2AjE/pEjGF2XEGApG8269eQtiX0yTFXanr1dbuyJHrqV4gqNOjHTvA77RWa1jbuk1jLpEOnQ+01yO0qba2KS+FGBxHk7ccYMzY+xczRKwa0RD2wk5qu6oIg15DGACKAwH3SdnzVqdcmFhkfhuduvbnumNb8JOCN8xHXuzCzmC3BMN27KTN4Lg5ziVCVYxF8QA5KKZ3dkbiC+Ia1/bXbvINiw+l4j0CFAEOHRKZgBrRSV04zy56mcrD2BVK3ByPaH+MHUHmTq7LSAjNFMMRJi6GiNY8A1SGAG2ePc4PtFGgvSeYvVTEZGSX17R8LDHgc+OVikxsr6HjCFfRosDOWFoPiYkiusRzkdQLrRPBU2wKE7fHcX2wqYcyMJxkXnLaRZmBMO6em4G+pzK3cqOFtqFXUZn0UnYLMqgIxcn44yM/LpH9FzkkYYJkYO2YVw1Lvka79mgavVr11WQRoK0W1bt0FXkYAHjRUTRm0OOI7QErHY2zlt0SzhB5FKDMasOEbVka/emDF1W5h+4fJAVhT2QtM2983aDwRaGxpd9kh00qdyFnjsyIg44B0HRBuw28OrGrrGSfNhKIkrNYxxct6Fo1ALmQJwRy79r7thojrlzyvgUiLdnYgzeoF8qEwHVkYUND9mHgphdmBH/L5uhNGnvqExotqgN6GtwDcnE1eDzONY0mYVpvM4Opma4Gov2JlObP5QWVgOe7AVn5Qoq8TbRVRGk6M9zNqdRiE
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(7416014)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(261022105027099003)(261026121527099003)(261028144727099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uG37wcQfOcuv8eiPtvboudvSAwoSUhkJSl84MNxnzdT9fu3tJ1fG8qJPm/99dU2W2bQwH98kbFISLue8a99C7pLifSHGyA9BAK6P+RALR0MfVeiyJfh97eo22LEENkrw9ajNyI+JpZqZNTbgVnf5yt/AFizG88ghYl2dJ0aJzt17ZsfpqZs1JnarsHXKFNunBish73oH7rxUrIbboNnYnBZVDhbkW3HFenmnJgc2U/bTXM1xuMVRPXaqmQAxPuOnSr/nT2lOcYiIlMdEnETWH0xtZB188GoLjTJ/BS2+XTdvV+0K46LdvxjF09WstqkCj2cjdiZbQ0SE2tcfHfqbMcZyixevJHU6VKecdb8Y6QVxQ5R7y1sH4WqSDqfNVn2mAxAckrac6/j8XwUdxjMzB5FubZcZvdnzk1cBYduKfI0iwysrzSBhENsaTJmT+fvF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:53:42.1209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c38c2fab-24a9-43f8-6603-08df4ba32758
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5833
X-Stat-Signature: 7s6apxqzn9ex54m4te3rftshhrnbjnn3
X-Rspamd-Queue-Id: 6E89140008
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795686827-714607
X-HE-Meta: U2FsdGVkX1+kn/eB8okwURLWqBpRsm5eL70WC92TlY+xpAWpwgSE/9bksRV2brNymEYLqOkohoLiWKz9DQBjmRdHwY2uQmX8k9nENNZ7RXOeFY1cyUf95OxiSS/oJwmQIbValWFpjhdGd2ksZvXr3sDYHGja/j0x1/W8NhU/MgfPRz4/v4kZ4Gucut8L40SnApkm9fvMMG1t8o4EdOAsGj2Sp4lsDV8cPXVQzsTS99OnS9SfszRV52zyz7gKUjBXV3Cv1PEexxQCUWmjC+hgQxOn+XltaOkyMbsUFm+KIVBsioRjJhwM3/AF5XnDO7i+fkq27FKgF98L0SQQfAW495a2bfUnMAXCIJR7pJJCTU8jdcbFExEt36/VT4ft6ufB0xiTZS/4oNdhGFBO3BOZx75mdmYl6Xo7Qr+moY2GC3B2UABdYrV0++uwUECwP2wjSwmHrZuCMfIPRbC66aXW10FZrXK1LVpXPtpfmJsQJbwNGCb1oRv7rGJODLzGGzi1JsozFfGkqtUJ/xXGTt15g3gJC4W95sbxF7Qy4OuBTkSZogp0S9J5vp/lb55HlhlGueW0/VrLfQbpCn4V/QqI+8CONlDdZQeREOV/A8j03K8Cus6wD+OT0/SoS8ENh9p+rlhzeyNNloWsm1119DC0b36S362JqOUEs/2gbVuxQ4jr56kTh7DU2VsLC/DyDOu1iBFUX+rf+TR4fSq9LAMueYHFTk+GOFYH93souYGMMCEobk0CK/e2xqwoK075/EzHtdmMwTsUjkm7G18GdZnIPiXxFdU3WUunJm8i7p9RwOxZVqq+lMCn9quu9YDIN6WwBCLP+jJx7WobELfUT11M/LolKgUg5lQJ5PqAxFPVGtw5M3IL3lwBFYR8MAZyFDw9I+43yRsMnyJw9b2CBnoUMRdGolzKwDpkNYVZDrejwyn/Q8Ciu0iHSxKYftIdunm2alSrLpMGQLDtHiLmdM5
 nFwkf1ej
 w875sgUUIY2b1dRSllMCnv+n/x4TpPaI20rUbds26uEpg70GIS26+8YQ8dVflEcjbn+MaIzeEqXCBIYlDhT4BIIa918L3YEh/fFvbFt8+QCzmgNZ1AiHTQ4Um5tSWXG4x5LpJF+sajc6Ne6FNZh7YIOLM6S7cqkY/dQH9Uu/KqjGl3+BaaCXGFUGzfSptp2x2A7lYTKaRaRRfEMM9CCXg2PjGV+lo5u25HrLjDv14m9hx4mjtDYh3U3h8Imt6uQuchlBNvB166OhyNa+2ru6JxW2sAhfPCJiChLSS1YHxgMqD9CUBOemYdgGL3a3NaU++8T3aiXpLjCrkgWrq97ucTjj5miOl08FURdsps+GBHLC6hN/4Dx4L+9yE8ruWKglEO0qwu22RlFEQNVK3zb5fKzBk4ZoOI/yKMpuVovv4E6rr4aTr7JvwLfJ0gI1ZtTj+RvdK873uuLPazN0UyI/C7L1NymcFJWPGg4biFpbTdZq+BLTJ/O1De9cUIAAzcbYYHpUiWfoThNIxXxxBV/k4hRR7biu2f46ICxOnmtMufpt33UPBf8Pwn0BHf9kqXYeR1pSIEyeBbZEZFt+InMWMEiPUvLfQRSAv9gbMPx4avyVdTEtHnAHJSzQEppYB7p4FkonqZqHaPih8oVwaWi2jmzHd3bMZuRqL3HOX0d7TFdFoLDEXpejSpUS+IdZnAeL9uJJESSSlGXZfCk6smHHLTWYCTfy2oK23cr8J33xvasrkm5bg82M1n+cJOLlCcXhLbG2JVBiMaoVEhdeej4Rr1a2bXTOdtl0kjU8S/lAbIOTEbE3dDEbgz/MEkfW95JwJPWE5p8Mz5p069zV2xLJb0VuOSy8I71DHiml5Izg1mUFNHutvVLo/cgx5XiOVsEQ9tmyWUwEDtrehJZdGpw09XtswWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_to_migrate_one() interleaves hugetlb special handling through the
regular PTE/PMD migration path with folio_test_hugetlb() checks
scattered across the walk. Simplify this by moving hugetlb handling
into its own rmap_one callback, try_to_migrate_hugetlb_one().

Few minor changes:
- Since hugetlb uses separate counters, update_hiwater_rss() is not
needed for hugetlb path. Also, use huge_pte_dirty instead of pte_dirty
- No PVMW_SYNC flag is needed for hugetlb
- hugetlb folio has single mapping per VMA, so no loop is needed.
- Convert VM_BUG_ON to VM_WARN_ON_ONCE and not use irrelevant WARN check.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/rmap.c | 251 +++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 144 insertions(+), 107 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 304581856d67..fe87df06fa06 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2553,6 +2553,138 @@ static pte_t make_migration_pte(struct page *page, pte_t pteval,
 	return swp_pte;
 }
 
+/*
+ * Replace the hugetlb page table mapping for folio with migration entries.
+ *
+ * @arg: enum ttu_flags will be passed to this argument.
+ */
+static bool try_to_migrate_hugetlb_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address, void *arg)
+{
+	const unsigned long hsz = huge_page_size(hstate_vma(vma));
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	bool anon_exclusive, writable, ret = true;
+	bool anon = folio_test_anon(folio);
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range;
+	unsigned long pfn;
+	struct page *page;
+	pte_t pteval;
+
+	range.end = vma_address_end(&pvmw);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				address, range.end);
+	/* If sharing is possible, start and end will be adjusted accordingly. */
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
+
+	/* There is only a single mapping in a VMA. */
+	if (!page_vma_mapped_walk(&pvmw))
+		goto range_end;
+
+	address = pvmw.address;
+	pteval = huge_ptep_get(mm, address, pvmw.pte);
+	if (likely(pte_present(pteval)))
+		pfn = pte_pfn(pteval);
+	else
+		pfn = softleaf_to_pfn(softleaf_from_pte(pteval));
+
+	page = folio_page(folio, pfn - folio_pfn(folio));
+	anon_exclusive = anon && PageAnonExclusive(page);
+
+	/*
+	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
+	 * knowing exactly which PMDs may be cached for this mm, so we must flush
+	 * them all. start/end were already adjusted above to cover this range.
+	 */
+	flush_cache_range(vma, range.start, range.end);
+
+	/*
+	 * To call huge_pmd_unshare, i_mmap_rwsem must be held in write mode.
+	 * Caller needs to explicitly do this outside rmap routines. We also must
+	 * hold hugetlb vma_lock in write mode. Lock order dictates acquiring
+	 * vma_lock BEFORE i_mmap_rwsem. We can only try lock here and fail if
+	 * unsuccessful.
+	 */
+	if (!anon) {
+		struct mmu_gather tlb;
+
+		VM_WARN_ON_ONCE(!(flags & TTU_RMAP_LOCKED));
+		if (!hugetlb_vma_trylock_write(vma)) {
+			ret = false;
+			goto walk_done;
+		}
+
+		tlb_gather_mmu_vma(&tlb, vma);
+		if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
+			hugetlb_vma_unlock_write(vma);
+			huge_pmd_unshare_flush(&tlb, vma);
+			tlb_finish_mmu(&tlb);
+			/*
+			 * The PMD table was unmapped,
+			 * consequently unmapping the folio.
+			 */
+			goto walk_done;
+		}
+		hugetlb_vma_unlock_write(vma);
+		tlb_finish_mmu(&tlb);
+	}
+
+	/* Nuke the hugetlb page table entry */
+	pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+	if (huge_pte_dirty(pteval))
+		folio_mark_dirty(folio);
+	writable = pte_write(pteval);
+
+	VM_WARN_ON_FOLIO(writable && anon && !anon_exclusive, folio);
+
+	if (PageHWPoison(page)) {
+		pteval = swp_entry_to_pte(make_hwpoison_entry(page));
+		hugetlb_count_sub(folio_nr_pages(folio), mm);
+		set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+	} else {
+		pte_t swp_pte;
+
+		/*
+		 * arch_unmap_one() is expected to be a NOP on architectures
+		 * where we could have PFN swap PTEs, so we'll not check/care.
+		 */
+		if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+			set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+			ret = false;
+			goto walk_done;
+		}
+
+		/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
+		if (anon_exclusive && hugetlb_try_share_anon_rmap(folio)) {
+			set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+			ret = false;
+			goto walk_done;
+		}
+
+		/*
+		 * Store the pfn of the page in a special migration pte. A
+		 * hugetlb fault waits for migration to complete before retrying.
+		 */
+		swp_pte = make_migration_pte(page, pteval, writable, anon_exclusive);
+		set_huge_pte_at(mm, address, pvmw.pte, swp_pte, hsz);
+		trace_set_migration_pte(address, pte_val(swp_pte),
+					folio_order(folio));
+	}
+
+	hugetlb_remove_rmap(folio);
+	if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
+		mlock_drain_local();
+	folio_put(folio);
+walk_done:
+	page_vma_mapped_walk_done(&pvmw);
+range_end:
+	mmu_notifier_invalidate_range_end(&range);
+
+	return ret;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
@@ -2570,7 +2702,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -2583,26 +2714,13 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
-	 * For hugetlb, it could be much worse if we need to do pud
-	 * invalidation in the case of pmd sharing.
 	 *
 	 * Note that the page can not be free in this function as call of
-	 * try_to_unmap() must hold a reference on the page.
+	 * try_to_migrate() must hold a reference on the page.
 	 */
 	range.end = vma_address_end(&pvmw);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, range.end);
-	if (folio_test_hugetlb(folio)) {
-		/*
-		 * If sharing is possible, start and end will be adjusted
-		 * accordingly.
-		 */
-		adjust_range_if_pmd_sharing_possible(vma, &range.start,
-						     &range.end);
-
-		/* We need the huge page size for set_huge_pte_at() */
-		hsz = huge_page_size(hstate_vma(vma));
-	}
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -2649,10 +2767,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
 		address = pvmw.address;
-		if (folio_test_hugetlb(folio))
-			pteval = huge_ptep_get(mm, address, pvmw.pte);
-		else
-			pteval = ptep_get(pvmw.pte);
+		pteval = ptep_get(pvmw.pte);
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
@@ -2663,66 +2778,13 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			const softleaf_t entry = softleaf_from_pte(pteval);
 
 			pfn = softleaf_to_pfn(entry);
-			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-		if (folio_test_hugetlb(folio)) {
-			bool anon = folio_test_anon(folio);
-
-			/*
-			 * huge_pmd_unshare may unmap an entire PMD page.
-			 * There is no way of knowing exactly which PMDs may
-			 * be cached for this mm, so we must flush them all.
-			 * start/end were already adjusted above to cover this
-			 * range.
-			 */
-			flush_cache_range(vma, range.start, range.end);
-
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 *
-			 * We also must hold hugetlb vma_lock in write mode.
-			 * Lock order dictates acquiring vma_lock BEFORE
-			 * i_mmap_rwsem.  We can only try lock here and
-			 * fail if unsuccessful.
-			 */
-			if (!anon) {
-				struct mmu_gather tlb;
-
-				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-				if (!hugetlb_vma_trylock_write(vma)) {
-					page_vma_mapped_walk_done(&pvmw);
-					ret = false;
-					break;
-				}
-
-				tlb_gather_mmu_vma(&tlb, vma);
-				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
-					hugetlb_vma_unlock_write(vma);
-					huge_pmd_unshare_flush(&tlb, vma);
-					tlb_finish_mmu(&tlb);
-					/*
-					 * The PMD table was unmapped,
-					 * consequently unmapping the folio.
-					 */
-					page_vma_mapped_walk_done(&pvmw);
-					break;
-				}
-				hugetlb_vma_unlock_write(vma);
-				tlb_finish_mmu(&tlb);
-			}
-			/* Nuke the hugetlb page table entry */
-			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-			if (pte_dirty(pteval))
-				folio_mark_dirty(folio);
-			writable = pte_write(pteval);
-		} else if (likely(pte_present(pteval))) {
+		if (likely(pte_present(pteval))) {
 			flush_cache_page(vma, address, pfn);
 			/* Nuke the page table entry. */
 			if (should_defer_flush(mm, flags)) {
@@ -2761,14 +2823,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
 
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
-			if (folio_test_hugetlb(folio)) {
-				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_pte_at(mm, address, pvmw.pte, pteval,
-						hsz);
-			} else {
-				dec_mm_counter(mm, mm_counter(folio));
-				set_pte_at(mm, address, pvmw.pte, pteval);
-			}
+			dec_mm_counter(mm, mm_counter(folio));
+			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
 			   !userfaultfd_armed(vma)) {
 			/*
@@ -2791,28 +2847,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * so we'll not check/care.
 			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				if (folio_test_hugetlb(folio))
-					set_huge_pte_at(mm, address, pvmw.pte,
-							pteval, hsz);
-				else
-					set_pte_at(mm, address, pvmw.pte, pteval);
+				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
 
 			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
-			if (folio_test_hugetlb(folio)) {
-				if (anon_exclusive &&
-				    hugetlb_try_share_anon_rmap(folio)) {
-					set_huge_pte_at(mm, address, pvmw.pte,
-							pteval, hsz);
-					ret = false;
-					page_vma_mapped_walk_done(&pvmw);
-					break;
-				}
-			} else if (anon_exclusive &&
-				   folio_try_share_anon_rmap_pte(folio, subpage)) {
+			if (anon_exclusive &&
+			    folio_try_share_anon_rmap_pte(folio, subpage)) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
@@ -2826,11 +2869,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			swp_pte = make_migration_pte(subpage, pteval,
 						     writable, anon_exclusive);
-			if (folio_test_hugetlb(folio))
-				set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
-						hsz);
-			else
-				set_pte_at(mm, address, pvmw.pte, swp_pte);
+			set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
 						folio_order(folio));
 			/*
@@ -2839,10 +2878,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 		}
 
-		if (unlikely(folio_test_hugetlb(folio)))
-			hugetlb_remove_rmap(folio);
-		else
-			folio_remove_rmap_pte(folio, subpage, vma);
+		folio_remove_rmap_pte(folio, subpage, vma);
 		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put(folio);
@@ -2864,7 +2900,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
-		.rmap_one = try_to_migrate_one,
+		.rmap_one = folio_test_hugetlb(folio) ?
+				try_to_migrate_hugetlb_one : try_to_migrate_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,

-- 
2.53.0


