Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747A7CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 10:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07588E001F; Tue, 21 Oct 2025 06:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF518E0013; Tue, 21 Oct 2025 06:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD6E8E001F; Tue, 21 Oct 2025 06:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8B458E0013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:23:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56CD4140430
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:23:47 +0000 (UTC)
X-FDA: 84021735294.23.B856831
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010044.outbound.protection.outlook.com [52.101.201.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C16616000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:23:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YVP8n3dM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ankita@nvidia.com designates 52.101.201.44 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761042224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LqNk8cHZfU2MdWU2qM+0cEDee65vyjLmE+wLsa1J2LM=;
	b=xB69BkVDSIPCjKXSYfB6qERqHSeS0dr5/9CHTCIKqAbalQknqRn81C+L2sExi1GXzY2GW4
	VvT1VmGRM3l8jpiZpbElS4e8Ps2XgIb2PpW9cVsbzjYVBB/1GY6ec6Kz9Z20QWQGYuuew2
	WCy3cpccUDWWsYSEkvX+8v6h7ocVCOQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761042224; a=rsa-sha256;
	cv=pass;
	b=1zkLzvFaWlwRl1ykmmtTGJ7UZJ5y6GVVUXha57qOoOT+f055mr2SBNiFxsnwzJy722jLgJ
	b0GIMsDR8xBS7kj24NIjj8quCc65HPJrh/q6jRqeLylIyfNSVgUrW3KGl6B4igkN6n5A+0
	oZL2ccewRRzIVgl2UPvkJ9lXeM//XFc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YVP8n3dM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ankita@nvidia.com designates 52.101.201.44 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9YGAjde3Rup+NdV+t3hq1/RucqgaxiNXY7GspoTAb6fd8ZftQETKRlHA+TmTS3bx7dRDSrYM8gtRuDkV1iRG9xg/URn+3tzFQQWX36P86gqTd44uX/qKhid3NP7XVZaLLloaXsvTXGREX1WO7gTvnklMzTcIs2kBLkiOGFvt2MvR2vRYMaPdTgFplD6J7f90nmQe/thmA2vJ75k1nziKRrguz19zTxsi6er8lI1BEin30RMtobp9X+RM0iK0eQYQyCs3D5+3rV/Dcqb846l2eTNXDHhl+r+R0F0chmmPtcZYu8cT9ID43vUociBJK80/hEFXl5XJ2JuBhglHc9YPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LqNk8cHZfU2MdWU2qM+0cEDee65vyjLmE+wLsa1J2LM=;
 b=gREgshDg7lIsHS0VUQnZL6oKZMGEdoFdtNyJoCTNniA9QGm3kDzdkrIWomAJhVBj6luVfiz+/EjHbajrRRfMlKOVDaRLVVZ96jTW9oyk1TwvoHBDfupleSAQhpTD39XuWiL/LAPQR8VNS57EHY/4R1CV2KlX2NJzsvfUdvfdMrNAN5NU5m5pYc+vpaE2ghmB4Z7cTO6FY3XcxnXXs6+24JU1KOmy4+W551sOcq3nizPnbPgDIp+FL5DN8q3tOprKlKh86Ne0rH4M8dkD2FQyulB4cnC9xcqjpvt9bAMb0VYOQLm3SSz28i2hYb56kw63eudc4Ss5xJYWIsMniWRN4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqNk8cHZfU2MdWU2qM+0cEDee65vyjLmE+wLsa1J2LM=;
 b=YVP8n3dM8kUmdocBm/7b1X3eab/DTkLTZmxe+TDoM2Sz6W9QZXCo156TvXdG+iLuPXhS1AbPnbpvnMZUNy2l0gSVWxxMTIwjRH7AluB9by4I3g0xzPW4+NOshdgGjUvUWHy8i7sOT39qQcOdBFKym7bAawwA31eBdp9DJGIW7PuiCvIRnrL3CjSWu5YYExXBkBQ5sPMkFtm8CjCueIKEAFeiWC9P6arbWVxcd1/RhTy0Ryqgtn2CeAiDgAkMXSmKWnNQdELoJtpP9zu3MafvXA9AfDaSn1HszhR+oOH6MXwzUiwjMF2owiqnZmy1NgfgMPVJW9ODjJ00yGX+8H37RQ==
Received: from SJ0PR05CA0185.namprd05.prod.outlook.com (2603:10b6:a03:330::10)
 by BL4PR12MB9535.namprd12.prod.outlook.com (2603:10b6:208:591::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 10:23:38 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:330:cafe::71) by SJ0PR05CA0185.outlook.office365.com
 (2603:10b6:a03:330::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Tue,
 21 Oct 2025 10:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 21 Oct 2025 10:23:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 21 Oct
 2025 03:23:30 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 21 Oct 2025 03:23:29 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 21 Oct 2025 03:23:29 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 0/3] mm: Implement ECC handling for pfn with no struct page
Date: Tue, 21 Oct 2025 10:23:24 +0000
Message-ID: <20251021102327.199099-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|BL4PR12MB9535:EE_
X-MS-Office365-Filtering-Correlation-Id: 366b913f-57aa-4a97-0b17-08de108be652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DMAx5lqfpxBbVqsrKzzCEvt1UEynycCE5mDJoeGgpi/98Kd9cj19oEuMdBlv?=
 =?us-ascii?Q?vwTr/xGy93G3DenLJ1TWPWvbAKoOuukSo4SX+6wLzU//0R2PyOqUJPnxXaZy?=
 =?us-ascii?Q?fzivtO1v5dmkJmtVgkAE8/cheCLnYvY6RfssJ4SqlgmhdWSiuKortW8oszb6?=
 =?us-ascii?Q?K/kHD5pYCMygJ0Db/XgqYta1DsEgHaYKg9CB16QVMqMFxc031ZXy9KY8TFuq?=
 =?us-ascii?Q?AQmfMtG2jo+vAy8QFsWADdEc1WqD2oQc8jq9F4WUr1RXsAd9kC+zL9zmOfva?=
 =?us-ascii?Q?bsm3TQ8+xSCtfrwA0dpyMX67vzVrVVIbN0mtn1eGHWnPlsvw3IqyDElzK/WQ?=
 =?us-ascii?Q?glvWSt+YUd6x3DtGvZ+YnmsoTwDuzeivKqcu6b7WyVgPgEce3XZHX2gQjujH?=
 =?us-ascii?Q?JloF9aFeBRPUmNGcVGu+NRaE+UphMjvLKz0gKt6FgWDvlkBHkCtyEDIYlIFm?=
 =?us-ascii?Q?cC/o077ifiK0LnGgzezHT89m3MVzWt9DjYIswUff1jHOhNcXGdE6xYq9gUcx?=
 =?us-ascii?Q?YJ8fmlclZF+Fh11Dtjez6v+XEz8rqKTkeiwNj0rzk7wXopGzwAoAJUUd+f2P?=
 =?us-ascii?Q?oShGdvg0Tsj9+CjUcNYsKSvd3HoBUOThYLLAxAZZa5o3/DWm9bAdhnQMsxm+?=
 =?us-ascii?Q?AFHPYwPpfMWZl0kbYoegEanQ/zTIwVJqJx9nHDCNDzRn5omco0TGjitVjRfu?=
 =?us-ascii?Q?3iFUWfs8RP4aGaIJYeV12nDpDXK2e65DerzPJvuMbF8m1Z6GVuofWxomXeyu?=
 =?us-ascii?Q?rm9EwkuNGdJs0z0uou2Pb1dxZXrubvFCtmJU82UbfdlxL5BFwVHHvImG9Qq/?=
 =?us-ascii?Q?pJnnm28qLYJcVScycIipg8R4cgD/7d3odqzm0pfpeqe91cfg7pRZsf6urCdc?=
 =?us-ascii?Q?w+8dEBMtQmStYnQ7Tvtu/FAm8+ZWSMcVlGmkXD4oWjR3FLt8RV1njW1bMWS2?=
 =?us-ascii?Q?M7lQ24sp1NyD7V747m7/SgXTPhoX2cnKQcaESoDFor1JDYifKUqkbd/5Gskj?=
 =?us-ascii?Q?ZXB74iahBmInvAh6aPY2ze7XaZEgs2zuT5Q1WHZblKKqdkvCB/UuS86g9iEa?=
 =?us-ascii?Q?uoPggJUh1WTETAHo9BOHQIPx0/8Vhdc3OPMsNvpSjJwDia9rnzLjoyA+ZUax?=
 =?us-ascii?Q?EJptkrvfXz7nscpfk4NSMcpknb6LYutlmQtSEEMwr7/jDGgXRnVL/4ADKEng?=
 =?us-ascii?Q?6fz9IxME2McnlBQDyBgavUaEo9Tsivy5uWcOLTV6PKs01OyNt5EVZL7FVado?=
 =?us-ascii?Q?WTEpC5xP2YNaoB8n+Rh1iTbjl3MYO7u/XWHVnkA0zp5cbtEGUBXrPdnc1jA4?=
 =?us-ascii?Q?GUFdMwj1u55hBLhoDaYE4z82s5HJKdyMSYBzY7Pbk55FxxOB//KSkFeK1kgy?=
 =?us-ascii?Q?IKIvHNzRxJItyUHlGbkvN8lRnqKRSGT0PNLU9MGQj7wwK36NnnNTPvfBmSh4?=
 =?us-ascii?Q?uhNaIBFjuB6K6wBXszwpt2kT2LNXQBouavsdFnpGagk0bj1n1RZzYm9Ie8GA?=
 =?us-ascii?Q?utULiYIbbmaJvvAsYAqX/76o5rci7+u6Aem45u3DyG4llkdyZp+ZCKQkM0KK?=
 =?us-ascii?Q?8ZPdn0wFT0O3pTsi2QipInyHrmVV+qi1EpSF4VsJ/d7o6FElB6/D/NxVVWH7?=
 =?us-ascii?Q?ew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 10:23:38.3664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 366b913f-57aa-4a97-0b17-08de108be652
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9535
X-Rspamd-Server: rspam05
X-Stat-Signature: az1rtx4c5swt91fhhnwmrdn5cwtk6tzh
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C16616000A
X-HE-Tag: 1761042224-769223
X-HE-Meta: U2FsdGVkX1/Z48giiSr6FPY5i7ozhLFUwG4tGGGQMt79LIJgbnvYgg6oK/rDzGTOQvK+/O6jlIOHpiTFWyjVXLViMTUwxs5bu39xtpRkYX11Az+PPCDNMt7RMd+AOoTEQEHztenxJKD2txFoAvYbeGZ0fWFROBLcrfwoPfMEV1b9a5t/eXMnKYDUf9g2yYxXMJl6KT5/BkiRoBo5+JV+wprTlrtxE1S8bg6eQVfUMXBDIV3uWru4qfulAJgSY7u6ht1XJPG5UQ4MIA2BoEdhd+8vFB45faGIZRNvL4SC6fMZsM656bv74Xbd50wm/e55j0sn1SyCDmekFVNN3uRX/ylS21pQRmNBrKvgyL+LF+XYZuuWmAjqS9M+I14KSUi02ZCt6+xBoji+kuwvtB9s35cq/+WsVHrsyMWpf9yoPiK3SJ9i5wiNQSr/GK/FVFm23KnyR4CwvMDtWLp9VEElhkprAMVE58ZcaXLc3exrICCOuQ1TGeHfnPRNQXjyFgr6R7WDVLFKF4Vg8sVEDuIUtTVQ5mYZDqrHJHHUCpSPVfgNFfUVQmHVxB/VE8LhpD+wVSnvDO4DmMpoTUH7puFoZfgssrvdlDudeALr+Mq9pXcKMi2UbAPAkWW2cPN/gA0UexIQW/tICdUMjSWlgCeMtk4krbsg/IWfpKdOV6fd2FzFbQXj3Tn8JHvF+SCtfzdyqxShKvYbUjX1aUG6Dbsz7Mi9LlRhTQfGhGZIqQlxsp7u4fC3ysYAqUwPYfBxVBpUaYyF8nw/nAbadjIfJqxhc2NwvCgcR33YXz6GyiE98LyllkVII9SKpfUAH+Z//OYvUxAdiyqt8jxuxfelNoP238tkeCxysCJZDMgEdwnyPM9QsIQwzZ955r98/paln37Hjr6g/8Sdc6XXQTyjaCyJ00Ty8A0J8h/VRYIWPzGDzMV37X7+Io66ROgNqlaM1CyWPYDZJpW/UVv6udsVm5/
 yHNk8yOB
 7PhnJZ3YAq7Lv/DLqs02tf6Xy3NP6g20SpmCztVrDGsW1XHWjJV/Dwbzj5fZs1+/LuGuY6UUX0tmodiqnuTXYrb8Q0581KAwPJ/qK+0ub0NiZg1fAKP2inhXqguQ/ayBUzshUVpwz1tLi/M4TCM5DwTlk6pvdLy8LPd2fhUmv26ofKpPOKh7CyEDPkKnHtAjuPJMfQsdms+uOczW1Q9p/0QmRB663Plx8QlwLzC2lBmlrPrgY2G0MG8vkruz3BY6FUrNQGBiT25p8j8Op5llhQjOE1tcWCD+/qiwo086lp//a2TSQQSCgxTAd3455M0dFI4qWQXdm51EJbUELRi6fkNSSlzukmFFCDNmPy+S6W+roBOlHpkbUTs3FdrfRmYs38j13jfC30shivybYmV/aKWcyp07eXqa/i4MaANF9F7VI/0pZVhqbuv2czyTpOewbZkvDWypIXMK75JI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

The kernel MM currently handles ECC errors / poison only on memory page
backed by struct page. The handling is currently missing for the PFNMAP
memory that does not have struct pages. The series adds such support.

Implement a new ECC handling for memory without struct pages. Kernel MM
expose registration APIs to allow modules that are managing the device
to register its device memory region. MM then tracks such regions using
interval tree.

The mechanism is largely similar to that of ECC on pfn with struct pages.
If there is an ECC error on a pfn, all the mapping to it are identified
and a SIGBUS is sent to the user space processes owning those mappings.
Note that there is one primary difference versus the handling of the
poison on struct pages, which is to skip unmapping to the poisoned PFN.
This is done to handle the huge PFNMAP support added recently [1] that
enables VM_PFNMAP vmas to map at PMD level. Otherwise, a poison to a PFN
would need breaking the PMD mapping into PTEs to unmap only the poisoned
PFN. This can have a major performance impact.

nvgrace-gpu-vfio-pci module maps the device memory to user VA (Qemu) using
remap_pfn_range without being added to the kernel [2]. These device memory
PFNs are not backed by struct page. So make nvgrace-gpu-vfio-pci module
make use of the mechanism to get poison handling support on the device
memory.

Patch rebased to v6.17-rc7.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---

Link: https://lore.kernel.org/all/20231123003513.24292-1-ankita@nvidia.com/ [v2]

v2 -> v3
- Rebased to v6.17-rc7.
- Skipped the unmapping of PFNMAP during reception of poison. Suggested by
Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
- Updated the check to prevent multiple registration to the same PFN
range using interval_tree_iter_first. Thanks Shameer Kolothum for the
suggestion.
- Removed the callback function in the nvgrace-gpu requiring tracking of
poisoned PFN as it isn't required anymore.
- Introduced seperate collect_procs_pfn function to collect the list of
processes mapping to the poisoned PFN.

v1 -> v2
- Change poisoned page tracking from bitmap to hashtable.
- Addressed miscellaneous comments in v1.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [2]

Ankit Agrawal (3):
  mm: handle poisoning of pfn without struct pages
  mm: Change ghes code to allow poison of non-struct pfn
  vfio/nvgrace-gpu: register device memory for poison handling

 MAINTAINERS                         |   1 +
 drivers/acpi/apei/ghes.c            |   6 --
 drivers/vfio/pci/nvgrace-gpu/main.c |  45 +++++++++-
 include/linux/memory-failure.h      |  17 ++++
 include/linux/mm.h                  |   1 +
 include/ras/ras_event.h             |   1 +
 mm/Kconfig                          |   1 +
 mm/memory-failure.c                 | 128 +++++++++++++++++++++++++++-
 8 files changed, 192 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/memory-failure.h

-- 
2.34.1


