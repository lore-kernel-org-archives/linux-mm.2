Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFB2D3B7D2
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2DFE6B0365; Sat,  6 Dec 2025 05:16:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05616B0367; Sat,  6 Dec 2025 05:16:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD386B0368; Sat,  6 Dec 2025 05:16:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E47D6B0365
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:16:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24AEAC0477
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:16:54 +0000 (UTC)
X-FDA: 84188642748.10.3A55F85
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013020.outbound.protection.outlook.com [40.107.201.20])
	by imf23.hostedemail.com (Postfix) with ESMTP id 234CA140007
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:16:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jx7bNNEO;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of bharata@amd.com designates 40.107.201.20 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016211; a=rsa-sha256;
	cv=pass;
	b=Szqvda5BFqhw4utj8li4kDUXFie54Jjp2tv4aX2Fy69bqtVUI87g0pPLBZK6nwWOTgMKDI
	baypOwXCIv9qPnYSWdJBU6H1/w2OWIvkGL7b/9Ic+b9yt1eKM1sG3C4jOGRjOtPY4gprqR
	XvvScI6RHX8ZeLNkEkZV5jY1/Cbd1q8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jx7bNNEO;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of bharata@amd.com designates 40.107.201.20 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qY+gFyCTa7xV02wDDVU81eT4okWhzX0AfGXG2QQOKs=;
	b=dIUSkcgoLBSC1rQ6V5Tr8thGLT4JzmP4MFsl/Gnt1OlWRHXUDz1NHn8Z7c0l4dKITPPoz1
	bjq+CYV6UDkUk3rhI5iT/lwnaP/yc7SR7BABuL7CXgfdbqpEwq/CMYcwVJVugXgrWgP3HF
	JjSfW/zovjzoZHmzp0orI9SpJEkcD5E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lzpbwUExlhbbAqknUgeBt7/bcVexWpMa8fBb4juiyyp81Bkk64M92gGL6elXD1sqWijSGiJ1W1T9cubtMwxLIVSFa9kvzu8XPTUujJQ90lj7D7AXS1ipgfRO32IJYadi1+DiEp/JbBXpS7TysHMAn5byicBfgWG4rn1rk1LZ7J57wJ/icNdlY0f7lYYcVoJkqB1OJMn93en9Tjub8n7k35rZ8urUk+jqgXVAxa5HwvugAlnpgTZSK8ugyngVt8DD1s9CNgW/EEqnkta7uqW61xzvz2M09iUoLnYcXgLzSR9OtjjieaP++LyjzVK4YfTLu3i/npmtC7LLGZd5U6N6qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qY+gFyCTa7xV02wDDVU81eT4okWhzX0AfGXG2QQOKs=;
 b=jQ9mJBfEev0tBtKUSxocTpaHTdcFkTyzilH+Nu/BYGHv2HX7wS8cA63ZO6v35/pkAlacbuTNgNBiKjrVpVOz8nSZgYvyzaV/d6NlunibjeoLeuMuq5faEbzOiAS2+LyYQS9xzZp1DbDd1x3+CXlifRMaXDcPH9ar4rR4HK61RAAJgh1H2b6dUkyywVzN3I1kiyMCN3XkSGSCpYS0saRlxmwhtbYWcIfjs+OYfALy6fBkF4x7RZBp0/U1U2XLAuNwZdIT6qqevjBr+PIgO7/icASQhxwiANwpBpT9kS21iLgGQq1Cqxs2zjuuiX1d2kfhIBn3DILv7aJF4nxc9A6/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qY+gFyCTa7xV02wDDVU81eT4okWhzX0AfGXG2QQOKs=;
 b=jx7bNNEOM/4GRkCm9cWEm3F1XcXOgEu6OuC1UZ0zEScRG+DLyuKPyoHgkcE3o98tTVfIWoWeGTkQgX73CzJUK4qLjRSwdlV8XhRBceC/ftuM0JJplhDsGiROb/BrT2eMeE0037Bg9WhLp1mmmM0uIL6OVZ/24CoGVrQup0IItnY=
Received: from BL1PR13CA0300.namprd13.prod.outlook.com (2603:10b6:208:2bc::35)
 by SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 10:16:45 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:2bc:cafe::38) by BL1PR13CA0300.outlook.office365.com
 (2603:10b6:208:2bc::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4 via Frontend Transport; Sat, 6
 Dec 2025 10:16:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:16:44 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:16:36 -0600
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v4 4/9] x86: ibs: In-kernel IBS driver for memory access profiling
Date: Sat, 6 Dec 2025 15:44:18 +0530
Message-ID: <20251206101423.5004-5-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251206101423.5004-1-bharata@amd.com>
References: <20251206101423.5004-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|SJ2PR12MB8784:EE_
X-MS-Office365-Filtering-Correlation-Id: 90858848-a510-4842-b1fd-08de34b08eed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bQ+/zPBz+juyfXpsH7bTGYm4nLRdPu5q5QerPcJac7k/e4eoUM7wej/RUENB?=
 =?us-ascii?Q?cGX2f7ZFmm0f2z6tWoLwhTfMDqqE86B1ZRYhMn9dURxgZlO4gWfm/T2dxW+w?=
 =?us-ascii?Q?4Qyvockr4A/NuaZ05h/q8fRVmq88ZLq3hiJXwTZje2P2ATz1ZnDi5VdHqF+P?=
 =?us-ascii?Q?Nb8R94cADMhpTTTY4uGox+6THamMck4xTtBOxGAap3x19W8r9q6Tq9ZrGU7v?=
 =?us-ascii?Q?iHBo68LQJpily9jtFH/G92Wn7JXXNpA8oCyyk7AreQ1z3o/xLfr7bVk6UjXU?=
 =?us-ascii?Q?X7nDnpwA9kxj+6gw+G0ASsdarEKamoOP3CbSJCBEv5K23ALmetZlbzctzo+T?=
 =?us-ascii?Q?ZM0GkkvSAidGA2f22U3vYpJIFSRafiXez5Y5zUyjjx4JCl4lzJftnOZy9RVP?=
 =?us-ascii?Q?3J8aBayxl4JEJpK/3DO/bCysYsY7VVIkdpdUX9zluF9T9uD/c8u45fbUD96W?=
 =?us-ascii?Q?3i9C43YEZlbPcM3ZMNr4vQur8PuJOospxm/PlSiEA+lbbd8Da1UJqr+/pHDo?=
 =?us-ascii?Q?Fp5m4dqNpoHDzgtanECcXsJsNlyCQObWT2LtgRqLNpiqDJ9jH1RFDUHJjYLs?=
 =?us-ascii?Q?ReLiug2g6q5/xUu6TPso4eTioVawOwjqJLaFPrvf/+pDQ+rLOTTrrFPlLbh9?=
 =?us-ascii?Q?F1kM/aHVgLMHXdqqKNoI2HAx5uObru5Xg3E2bQJzLsy58EkXTQzGJqKRQZNV?=
 =?us-ascii?Q?FIo1LqirBkZLQXVU5ACcgmzm6vu6xTeB6VOvtRz072+wCIjEVtwESEqRwf1K?=
 =?us-ascii?Q?qdATa3TkpMEsbIhJXe4CPhmDadXLYfK72xUvP31CNkgbHFV8U11OSRWxaWf8?=
 =?us-ascii?Q?GSfFnZ4Kj979WMyce1vPBtOx3cFgGcHv75nTaBvrQo6E+STQl/VTGJOjS4oX?=
 =?us-ascii?Q?uKUFsV2sTZMtKfGV5JGIXLkS65TF2bm8rZljieyXc9NGrP2q4J0vN+TdyTs4?=
 =?us-ascii?Q?Yo7GTZL9fHiGZUwIUGpMyZs/l1DiXpgm4WSeCU+1CDPgEbQ/lt02N5veW+Ei?=
 =?us-ascii?Q?vitzTtl9kPnhNhoGj1fhYuQ+EN5S3Avsy8d7q6bdnob0YJPLp5b/Gg6H/c0O?=
 =?us-ascii?Q?BV6tlXgy/i0qC3bWdeYYn/htsJsmmydaO0Kq/1zocCIZjbR06tGVY6QOhTw5?=
 =?us-ascii?Q?KA5Coe+CIK91yqCePWkHA503hDUHWFkmQX0eEu1HfnzjR7p5Q/Ja14B0pHD/?=
 =?us-ascii?Q?Pttk4ozyjfUDWccJVeCtgLwjyeYEvmnJ0rDg+l6/8yXWvvuKwepoKScduqVV?=
 =?us-ascii?Q?0QGfWppDfFa5EBx4fUzTfuP3nKc9aHt7lKKdXiu3YWsI51yvclWWJhohkBJU?=
 =?us-ascii?Q?t6xPpNFmF/sbeTEZcKsDJyzrdI6ZOpw2ssIsQsgwHpqkGz7LsOZE8iTEu95d?=
 =?us-ascii?Q?CRQKutgvb3ap1ECha+f4GhgbwhbpZ1piKUsYlTY372vlgDKqvtnWhYLQpEYJ?=
 =?us-ascii?Q?ivd8U6nC705WuBImMpln7u5/8RckUro4wbwabhkSxXztFP+YoefzhzptzwwC?=
 =?us-ascii?Q?7Qi+yeRjOFRiJYhD0HJZd8bY6kpA9hDiY7a/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:16:44.9586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90858848-a510-4842-b1fd-08de34b08eed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8784
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 234CA140007
X-Stat-Signature: ffa163xqjwjn4em1p9prp9xb3jwb7ari
X-Rspam-User: 
X-HE-Tag: 1765016210-843047
X-HE-Meta: U2FsdGVkX1/wP9cOrikHHl5M05RaBcee2pwRaF81CdMeiI3z7AjNAugOnwMy+lhkiJPG7SvNscvCX5G/in4TjflYYS7Nn1pB4ZYp5Kjumm/zlS9P5MUhkPHXc6gsU9ybhuY88P45A+pAIgGmY9FGAlSAPwcnYzslXtxMCWstK7M/pmu1BgiGsyPpiZYmnjta/z3MR+9c6TXnoH6qmRpSNV8wf2+OPonS3O+iZI6HsxBnksaV1O3Z6HHOo7Gyp4cg7edQdNZIJhWvuYtVTNswJGgYoxtxeRAYbj+ZUfnDf8uPA7D7TxFB14PnBs68XedoYoFEVJjZmndKHEu6LEdpEQCDH77i5MPLzyU2BHSIMHAloi2y6B2+919exR8i+eAiwZEEfCDE2PVPnOXGs/BIxhYWGpihpvwBLsvViOHq6D9Y2FP4eiIwp4T5VETNUdQO3MobWd+FtrBM9yn5FwwwNGe+TPMXUG5IEeorszy+J0yutSpLiUqn6LGFn6qBLML+xl5XtOF5cEFhVxd0GNHjBLCSu72pZo1jWT+P1YN+cuot4FzIuFmKi24jE6ufDS8rW1CphOJz84ruXBggFidcBaJVWgb0+9tkOi13dY4erppTSX8JZ3kKxFOtbgBVD31MNqJMQdw6qQijJTk4JFzw2DOA1vVyy8RuXcHplZe2vu7sRPcUl77Ywt6J9qmA2mI24CR2OYHEQl7HVdoKXgCGw3veAXZeylZVje8A7OTtRPoRBcqrwHUSEw79qPnKpZFyfVrdfXW87bUV75FuRsbQb/u4Lc76ZpHDzocmwkcYpv6jPMUsDY3dkOSxZUeVjx/J4Q/ehdIVOuAR5mhsFCDJEx1uogoS9vWWpkv9MknIYMBaxMatRiE51gyCOQIiXNaZIASRYb1TGdafLrLpvf1Vm/hVnHG5FMqkqCIZkkUEP8Zn5AbpdpKlbK5hzRiyWLRIppog5gBwmc4PpNGUjqI
 F4n/dyrM
 CSQfH/o8vwZlaOYdWzsAV45aLZggqo6XMddd1UAKzBLF3UaD45C5Ajw9MxAQQM42xocefsn8Znz0WWjz+fw+aX01kvlbGzcAS1mN+4JwHLRGr8Xw083Tnm5V0WHa+B8sCE2EWiveNqu9nI7exr0Oin/nhf4urPbUI5njJiIcEeXYjSpEws3JFQRXB70TL5bxwmpuHRgs4GKUQyEQm4fO1Q1cQ5c7QcbcGReFjbquHW6zG8eXuAoxlPthzuT0Ep5RsOEEtVuJ8U0k+gskMLT4vCmC9KMGnsmt8CUA8Y2g3uIbKDEDN4DPLCEwETm92E3x7pR7Yq+bEk6knMuCGEY/Jd6FBnhGsEhzZrHX+4hsC5bzTtzWOFJGPQCU+tdztpDtawFiJT8MiTDky64fIGfuDzc8cnxPTbn6O4ynXOk62RPln5ti+bZYPRpjbwRBZT2Bb8TKIDt6gBKPqUaPLYMNGALSaGUcgheQ34+yeZE38M5Jjpy9UW704e9jzi1le50G3s67pmHyf5+XdofbSFa+eYtblmxhEtE1RTSuCHVHldwTCYLE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IBS (Instruction Based Sampling) feature present
in AMD processors for memory access tracking. The access
information obtained from IBS via NMI is fed to pghot
sub-system for futher action.

In addition to many other information related to the memory
access, IBS provides physical (and virtual) address of the access
and indicates if the access came from slower tier. Only memory
accesses originating from slower tiers are further acted upon
by this driver.

The samples are initially accumulated in percpu buffers which
are flushed to pghot hot page tracking mechanism using irq_work.

TODO: Many counters are added to vmstat just as debugging aid
for now.

About IBS
---------
IBS can be programmed to provide data about instruction
execution periodically. This is done by programming a desired
sample count (number of ops) in a control register. When the
programmed number of ops are dispatched, a micro-op gets tagged,
various information about the tagged micro-op's execution is
populated in IBS execution MSRs and an interrupt is raised.
While IBS provides a lot of data for each sample, for the
purpose of  memory access profiling, we are interested in
linear and physical address of the memory access that reached
DRAM. Recent AMD processors provide further filtering where
it is possible to limit the sampling to those ops that had
an L3 miss which greately reduces the non-useful samples.

While IBS provides capability to sample instruction fetch
and execution, only IBS execution sampling is used here
to collect data about memory accesses that occur during
the instruction execution.

More information about IBS is available in Sec 13.3 of
AMD64 Architecture Programmer's Manual, Volume 2:System
Programming which is present at:
https://bugzilla.kernel.org/attachment.cgi?id=288923

Information about MSRs used for programming IBS can be
found in Sec 2.1.14.4 of PPR Vol 1 for AMD Family 19h
Model 11h B1 which is currently present at:
https://www.amd.com/system/files/TechDocs/55901_0.25.zip

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/events/amd/ibs.c        |  10 +
 arch/x86/include/asm/msr-index.h |  16 ++
 arch/x86/mm/Makefile             |   1 +
 arch/x86/mm/ibs.c                | 316 +++++++++++++++++++++++++++++++
 include/linux/pghot.h            |   6 +
 include/linux/vm_event_item.h    |  19 ++
 mm/Kconfig                       |  13 ++
 mm/vmstat.c                      |  19 ++
 8 files changed, 400 insertions(+)
 create mode 100644 arch/x86/mm/ibs.c

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 112f43b23ebf..e387c18c91f8 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -13,6 +13,7 @@
 #include <linux/ptrace.h>
 #include <linux/syscore_ops.h>
 #include <linux/sched/clock.h>
+#include <linux/pghot.h>
 
 #include <asm/apic.h>
 #include <asm/msr.h>
@@ -1756,6 +1757,15 @@ static __init int amd_ibs_init(void)
 {
 	u32 caps;
 
+	/*
+	 * TODO: Find a clean way to disable perf IBS so that IBS
+	 * can be used for memory access profiling.
+	 */
+	if (hwmem_access_profiler_inuse()) {
+		pr_info("IBS isn't available for perf use\n");
+		return 0;
+	}
+
 	caps = __get_ibs_caps();
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9e1720d73244..59657bd768c9 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -760,6 +760,22 @@
 /* AMD Last Branch Record MSRs */
 #define MSR_AMD64_LBR_SELECT			0xc000010e
 
+/* AMD IBS MSR bits */
+#define MSR_AMD64_IBSOPDATA2_DATASRC			0x7
+#define MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE		0x1
+#define MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR	0x2
+#define MSR_AMD64_IBSOPDATA2_DATASRC_DRAM		0x3
+#define MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE	0x5
+#define MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM		0x8
+#define	MSR_AMD64_IBSOPDATA2_RMTNODE			0x10
+
+#define MSR_AMD64_IBSOPDATA3_LDOP		BIT_ULL(0)
+#define MSR_AMD64_IBSOPDATA3_STOP		BIT_ULL(1)
+#define MSR_AMD64_IBSOPDATA3_DCMISS		BIT_ULL(7)
+#define MSR_AMD64_IBSOPDATA3_LADDR_VALID	BIT_ULL(17)
+#define MSR_AMD64_IBSOPDATA3_PADDR_VALID	BIT_ULL(18)
+#define MSR_AMD64_IBSOPDATA3_L2MISS		BIT_ULL(20)
+
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
 #define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcf..361a456582e9 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+obj-$(CONFIG_HWMEM_PROFILER)	+= ibs.o
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
new file mode 100644
index 000000000000..946f3a82ca11
--- /dev/null
+++ b/arch/x86/mm/ibs.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/init.h>
+#include <linux/pghot.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/irq_work.h>
+
+#include <asm/nmi.h>
+#include <asm/perf_event.h> /* TODO: Move defns like IBS_OP_ENABLE into non-perf header */
+#include <asm/apic.h>
+
+bool hwmem_access_profiling;
+
+static u64 ibs_config __read_mostly;
+static u32 ibs_caps;
+
+#define IBS_NR_SAMPLES	150
+
+/*
+ * Basic access info captured for each memory access.
+ */
+struct ibs_sample {
+	unsigned long pfn;
+	unsigned long time;	/* jiffies when accessed */
+	int nid;		/* Accessing node ID, if known */
+};
+
+/*
+ * Percpu buffer of access samples. Samples are accumulated here
+ * before pushing them to pghot sub-system for further action.
+ */
+struct ibs_sample_pcpu {
+	struct ibs_sample samples[IBS_NR_SAMPLES];
+	int head, tail;
+};
+
+struct ibs_sample_pcpu __percpu *ibs_s;
+
+/*
+ * The workqueue for pushing the percpu access samples to pghot sub-system.
+ */
+static struct work_struct ibs_work;
+static struct irq_work ibs_irq_work;
+
+bool hwmem_access_profiler_inuse(void)
+{
+	return hwmem_access_profiling;
+}
+
+/*
+ * Record the IBS-reported access sample in percpu buffer.
+ * Called from IBS NMI handler.
+ */
+static int ibs_push_sample(unsigned long pfn, int nid, unsigned long time)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+	int next = ibs_pcpu->head + 1;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	if (next == ibs_pcpu->tail)
+		return 0;
+
+	ibs_pcpu->samples[ibs_pcpu->head].pfn = pfn;
+	ibs_pcpu->samples[ibs_pcpu->head].time = time;
+	ibs_pcpu->head = next;
+	return 1;
+}
+
+static int ibs_pop_sample(struct ibs_sample *s)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+
+	int next = ibs_pcpu->tail + 1;
+
+	if (ibs_pcpu->head == ibs_pcpu->tail)
+		return 0;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	*s = ibs_pcpu->samples[ibs_pcpu->tail];
+	ibs_pcpu->tail = next;
+	return 1;
+}
+
+/*
+ * Remove access samples from percpu buffer and send them
+ * to pghot sub-system for further action.
+ */
+static void ibs_work_handler(struct work_struct *work)
+{
+	struct ibs_sample s;
+
+	while (ibs_pop_sample(&s))
+		pghot_record_access(s.pfn, s.nid, PGHOT_HW_HINTS, s.time);
+}
+
+static void ibs_irq_handler(struct irq_work *i)
+{
+	schedule_work_on(smp_processor_id(), &ibs_work);
+}
+
+/*
+ * IBS NMI handler: Process the memory access info reported by IBS.
+ *
+ * Reads the MSRs to collect all the information about the reported
+ * memory access, validates the access, stores the valid sample and
+ * schedules the work on this CPU to further process the sample.
+ */
+static int ibs_overflow_handler(unsigned int cmd, struct pt_regs *regs)
+{
+	struct mm_struct *mm = current->mm;
+	u64 ops_ctl, ops_data3, ops_data2;
+	u64 laddr = -1, paddr = -1;
+	u64 data_src, rmt_node;
+	struct page *page;
+	unsigned long pfn;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+
+	/*
+	 * When IBS sampling period is reprogrammed via read-modify-update
+	 * of MSR_AMD64_IBSOPCTL, overflow NMIs could be generated with
+	 * IBS_OP_ENABLE not set. For such cases, return as HANDLED.
+	 *
+	 * With this, the handler will say "handled" for all NMIs that
+	 * aren't related to this NMI.  This stems from the limitation of
+	 * having both status and control bits in one MSR.
+	 */
+	if (!(ops_ctl & IBS_OP_VAL))
+		goto handled;
+
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_VAL);
+
+	count_vm_event(HWHINT_NR_EVENTS);
+
+	if (!user_mode(regs)) {
+		count_vm_event(HWHINT_KERNEL);
+		goto handled;
+	}
+
+	if (!mm) {
+		count_vm_event(HWHINT_KTHREAD);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA3, ops_data3);
+
+	/* Load/Store ops only */
+	/* TODO: DataSrc isn't valid for stores, so filter out stores? */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_LDOP |
+			   MSR_AMD64_IBSOPDATA3_STOP))) {
+		count_vm_event(HWHINT_NON_LOAD_STORES);
+		goto handled;
+	}
+
+	/* Discard the sample if it was L1 or L2 hit */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_DCMISS |
+			   MSR_AMD64_IBSOPDATA3_L2MISS))) {
+		count_vm_event(HWHINT_DC_L2_HITS);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA2, ops_data2);
+	data_src = ops_data2 & MSR_AMD64_IBSOPDATA2_DATASRC;
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		data_src |= ((ops_data2 & 0xC0) >> 3);
+
+	switch (data_src) {
+	case MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE:
+		count_vm_event(HWHINT_LOCAL_L3L1L2);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR:
+		count_vm_event(HWHINT_LOCAL_PEER_CACHE_NEAR);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_DRAM:
+		count_vm_event(HWHINT_DRAM_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM:
+		count_vm_event(HWHINT_CXL_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE:
+		count_vm_event(HWHINT_FAR_CACHE_HITS);
+		break;
+	}
+
+	rmt_node = ops_data2 & MSR_AMD64_IBSOPDATA2_RMTNODE;
+	if (rmt_node)
+		count_vm_event(HWHINT_REMOTE_NODE);
+
+	/* Is linear addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_LADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCLINAD, laddr);
+	else {
+		count_vm_event(HWHINT_LADDR_INVALID);
+		goto handled;
+	}
+
+	/* Discard kernel address accesses */
+	if (laddr & (1UL << 63)) {
+		count_vm_event(HWHINT_KERNEL_ADDR);
+		goto handled;
+	}
+
+	/* Is phys addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_PADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCPHYSAD, paddr);
+	else {
+		count_vm_event(HWHINT_PADDR_INVALID);
+		goto handled;
+	}
+
+	pfn = PHYS_PFN(paddr);
+	page = pfn_to_online_page(pfn);
+	if (!page)
+		goto handled;
+
+	if (!PageLRU(page)) {
+		count_vm_event(HWHINT_NON_LRU);
+		goto handled;
+	}
+
+	if (!ibs_push_sample(pfn, numa_node_id(), jiffies)) {
+		count_vm_event(HWHINT_BUFFER_FULL);
+		goto handled;
+	}
+
+	irq_work_queue(&ibs_irq_work);
+	count_vm_event(HWHINT_USEFUL_SAMPLES);
+
+handled:
+	return NMI_HANDLED;
+}
+
+static inline int get_ibs_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return val & IBSCTL_LVT_OFFSET_MASK;
+}
+
+static void setup_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset < 0)
+		goto failed;
+
+	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
+		return;
+failed:
+	pr_warn("IBS APIC setup failed on cpu #%d\n",
+		smp_processor_id());
+}
+
+static void clear_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int x86_amd_ibs_access_profile_startup(unsigned int cpu)
+{
+	setup_APIC_ibs();
+	return 0;
+}
+
+static int x86_amd_ibs_access_profile_teardown(unsigned int cpu)
+{
+	clear_APIC_ibs();
+	return 0;
+}
+
+static int __init ibs_access_profiling_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_IBS)) {
+		pr_info("IBS capability is unavailable for access profiling\n");
+		return 0;
+	}
+
+	ibs_s = alloc_percpu_gfp(struct ibs_sample_pcpu, GFP_KERNEL | __GFP_ZERO);
+	if (!ibs_s)
+		return 0;
+
+	INIT_WORK(&ibs_work, ibs_work_handler);
+	init_irq_work(&ibs_irq_work, ibs_irq_handler);
+
+	/* Uses IBS Op sampling */
+	ibs_config = IBS_OP_CNT_CTL | IBS_OP_ENABLE;
+	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		ibs_config |= IBS_OP_L3MISSONLY;
+
+	register_nmi_handler(NMI_LOCAL, ibs_overflow_handler, 0, "ibs");
+
+	cpuhp_setup_state(CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
+			  "x86/amd/ibs_access_profile:starting",
+			  x86_amd_ibs_access_profile_startup,
+			  x86_amd_ibs_access_profile_teardown);
+
+	pr_info("IBS setup for memory access profiling\n");
+	return 0;
+}
+
+arch_initcall(ibs_access_profiling_init);
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 802240d574a6..6410cb131d3d 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -2,6 +2,12 @@
 #ifndef _LINUX_PGHOT_H
 #define _LINUX_PGHOT_H
 
+#ifdef CONFIG_HWMEM_PROFILER
+bool hwmem_access_profiler_inuse(void);
+#else
+static inline bool hwmem_access_profiler_inuse(void) { return false; }
+#endif
+
 /* Page hotness temperature sources */
 enum pghot_src {
 	PGHOT_HW_HINTS,
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 5b8fd93b55fd..67efbca9051c 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -193,6 +193,25 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGHOT_RECORD_HWHINTS,
 		PGHOT_RECORD_PGTSCANS,
 		PGHOT_RECORD_HINTFAULTS,
+#ifdef CONFIG_HWMEM_PROFILER
+		HWHINT_NR_EVENTS,
+		HWHINT_KERNEL,
+		HWHINT_KTHREAD,
+		HWHINT_NON_LOAD_STORES,
+		HWHINT_DC_L2_HITS,
+		HWHINT_LOCAL_L3L1L2,
+		HWHINT_LOCAL_PEER_CACHE_NEAR,
+		HWHINT_FAR_CACHE_HITS,
+		HWHINT_DRAM_ACCESSES,
+		HWHINT_CXL_ACCESSES,
+		HWHINT_REMOTE_NODE,
+		HWHINT_LADDR_INVALID,
+		HWHINT_KERNEL_ADDR,
+		HWHINT_PADDR_INVALID,
+		HWHINT_NON_LRU,
+		HWHINT_BUFFER_FULL,
+		HWHINT_USEFUL_SAMPLES,
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index 472975da69e1..6057c96b9cd3 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1390,6 +1390,19 @@ config PGHOT
 	  by various sources. Asynchronous promotion is done by per-node
 	  kernel threads.
 
+config HWMEM_PROFILER
+	bool "HW based memory access profiling"
+	def_bool n
+	depends on PGHOT
+	depends on X86_64
+	help
+	  Some hardware platforms are capable of providing memory access
+	  information in direct and actionable manner. Instruction Based
+	  Sampling (IBS) present on AMD Zen CPUs in one such example.
+	  Memory accesses obtained via such HW based mechanisms are
+	  rolled up to PGHOT sub-system for further action like hot page
+	  promotion or NUMA Balancing
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 10745e498e3a..4160476c4ee5 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1501,6 +1501,25 @@ const char * const vmstat_text[] = {
 	[I(PGHOT_RECORD_HWHINTS)]		= "pghot_recorded_hwhints",
 	[I(PGHOT_RECORD_PGTSCANS)]		= "pghot_recorded_pgtscans",
 	[I(PGHOT_RECORD_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+#ifdef CONFIG_HWMEM_PROFILER
+	[I(HWHINT_NR_EVENTS)]			= "hwhint_nr_events",
+	[I(HWHINT_KERNEL)]			= "hwhint_kernel",
+	[I(HWHINT_KTHREAD)]			= "hwhint_kthread",
+	[I(HWHINT_NON_LOAD_STORES)]		= "hwhint_non_load_stores",
+	[I(HWHINT_DC_L2_HITS)]			= "hwhint_dc_l2_hits",
+	[I(HWHINT_LOCAL_L3L1L2)]		= "hwhint_local_l3l1l2",
+	[I(HWHINT_LOCAL_PEER_CACHE_NEAR)]	= "hwhint_local_peer_cache_near",
+	[I(HWHINT_FAR_CACHE_HITS)]		= "hwhint_far_cache_hits",
+	[I(HWHINT_DRAM_ACCESSES)]		= "hwhint_dram_accesses",
+	[I(HWHINT_CXL_ACCESSES)]		= "hwhint_cxl_accesses",
+	[I(HWHINT_REMOTE_NODE)]			= "hwhint_remote_node",
+	[I(HWHINT_LADDR_INVALID)]		= "hwhint_invalid_laddr",
+	[I(HWHINT_KERNEL_ADDR)]			= "hwhint_kernel_addr",
+	[I(HWHINT_PADDR_INVALID)]		= "hwhint_invalid_paddr",
+	[I(HWHINT_NON_LRU)]			= "hwhint_non_lru",
+	[I(HWHINT_BUFFER_FULL)]			= "hwhint_buffer_full",
+	[I(HWHINT_USEFUL_SAMPLES)]		= "hwhint_useful_samples",
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
-- 
2.34.1


