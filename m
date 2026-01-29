Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F6FD61020
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01C96B0095; Thu, 29 Jan 2026 09:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8956B0096; Thu, 29 Jan 2026 09:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5A446B0098; Thu, 29 Jan 2026 09:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 947376B0095
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:44:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FFDB1AF76F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:44:32 +0000 (UTC)
X-FDA: 84385272384.28.ACD4E5E
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9B014140017
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:43:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FYBGgP99;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geW2Hchw2hipgNtUXmkYBzbL3lmxlreN3f1iPu8nAVM=;
	b=ebkyiptOQojFd2goGGxkNQLsq7LJq+rxuaTVEyGuPO43A94WV8gb49c1qE9a5o5iov8oGC
	Px2zrAfGuunmvPQXMzQuJC0QKYl97TDWMoHaZB9n07XX+9rQvkl2HRof/+MrlBLAvjefER
	D+v0wttEsEirNAnuCeHmI82B+qPsIWk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697836; a=rsa-sha256;
	cv=pass;
	b=RYu2hv01MyPqEVMtCj90BZEAwLDgwHy826AMwdyuNpFtEOHPKPcVfANWbqk4wt5L4qZMgX
	uVkRUQvakyuAHnfySj8nOy5J+y1w5RZ1UPoAzBbNqS5bWl3WqFLBu1NE0YUjkkDkoEAxXO
	WAOGr+4tmQIAlRiIfvG7ZOHL6DctJFU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FYBGgP99;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ov6GxMRxGcsCY8SZ4we00eW6IvMPXsR4+0u47M6fTzT2UZU/06xJHy7mtXISin3byoNv5dsWwYAg1pmsuXua0VyXaXtP9BbTfUDVXzVOqm62pIAXMN5E/2UFQ6cdYvJNDiCUqAG66lZlTVTSJg8FmiOxPFJGI+R9JXuQqW5P3eF1+kdKdD7d96AXgzcdgfVlxhD+okj9h2LNHTnawmNmISvI1NkcETjc4LqzZ5LRGQcL/A1HaJ61AxNqY2FV3OG7WWdtqrusbeCzAbzkEa2M1Yx8CeeLPvhjeRGz7o/92NDAm3os5+982fuxfJdKHfbl3TwSk51Ze6Xk6Zj+ssrENA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=geW2Hchw2hipgNtUXmkYBzbL3lmxlreN3f1iPu8nAVM=;
 b=lQG/nHplw+Ky2aOdNxTkO2/4n6jISLU/1uQ8DFJmuI7lt7qy8NsHBvB+NQ5XpR/KIFJCtfsT20uqxob9/em9xKQLuywPiOFTCsx/e02yAUrvRibvJttzIguUoJ6e8f48oW3c8/M4qmkUhpObHMfgjQFTSOCC11Lj5w4u8UxFwOtyYiFe0WUX57qR+RbdHGavHK6jga+yNsIfF9UempQZNX4h3OxAamxhYq0+NLY72mQ2oPwD7KPCbtLcjNr8ztlbtkVP3qxv8yFnhpOX1Liwfws8seBInzepWSuJSQPNUK3IDFObLXAkEKkhQ1D8+wiVF1El2BL8/PCr3d3pYfl+/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geW2Hchw2hipgNtUXmkYBzbL3lmxlreN3f1iPu8nAVM=;
 b=FYBGgP99z14DgkUKkXE1tjotMXUmt0p/v2pImm2tk7t5dfn2Isj0yIen0oviQoOyYPXLh992OPbFA7mXYStUDgx1Tm1IajtDa5SzZQQnQwiJt7etVhUCCPXBe45vY36LU24FIsMdYpDcB4smbg+7+QX83+yzyDahmkxQkd0hio4=
Received: from BL1PR13CA0426.namprd13.prod.outlook.com (2603:10b6:208:2c3::11)
 by MW4PR12MB7215.namprd12.prod.outlook.com (2603:10b6:303:228::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:43:45 +0000
Received: from BN2PEPF000055DA.namprd21.prod.outlook.com
 (2603:10b6:208:2c3:cafe::43) by BL1PR13CA0426.outlook.office365.com
 (2603:10b6:208:2c3::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Thu,
 29 Jan 2026 14:43:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000055DA.mail.protection.outlook.com (10.167.245.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.0 via Frontend Transport; Thu, 29 Jan 2026 14:43:39 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:43:29 -0600
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
Subject: [RFC PATCH v5 05/10] mm: sched: move NUMA balancing tiering promotion to pghot
Date: Thu, 29 Jan 2026 20:10:38 +0530
Message-ID: <20260129144043.231636-6-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DA:EE_|MW4PR12MB7215:EE_
X-MS-Office365-Filtering-Correlation-Id: 16c747cb-30e5-4748-1927-08de5f44caa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ihCqLzDMbu97E9XSPwxAArG1KN5ZEtbqekEfDwvHAKmxxENB0flaC0KN9cAM?=
 =?us-ascii?Q?a2TpPa56wu/rVwbo8IV6HN8ZiremCDq7YWIb0StYURq8hQ7xIjytyEEKDOiP?=
 =?us-ascii?Q?aLeRvjHDSmH/CcyZ8fH7n3GA7xjEfmLol50CLtS9fqAdhe/xMp+gLFqQsBs/?=
 =?us-ascii?Q?RpqbJK1B+R1EXxcPJO/t2z57XQzK9Pl6u2+hutzopAXf/b8X8ag1Jhe1jKtQ?=
 =?us-ascii?Q?c+AfxAKaWSlhQxTXEv9ais+0TcwPJ1kK1LMqWAhGEQnd/Xgu5msKkegfXIU7?=
 =?us-ascii?Q?DTrz0sQJUw8RcInfBX6XJnGCRRlOYcQ/6U8lYDf3ErB8V9zdV/QyAazAOUfz?=
 =?us-ascii?Q?miEq4ogev4FIcZot33I0XW/rfU8YShHTldSdoQaBITsO+LMRTZMiL1O+loSw?=
 =?us-ascii?Q?WtorntWtDXq8qElYbUcBz4dMYPO0eL+vRVHs4OmlWeHsKVM/FGvqQBSC+O/e?=
 =?us-ascii?Q?S7pvz9M+gYV8AsNHuVHwf1lUpemtRyw002oBf3Fp2zCGIybFHYMpWdT8KRyl?=
 =?us-ascii?Q?+z9GDLL7dka37tOwH0K8gXi1g6ppIPmAaf/I3VNEIFckGLiArkjg7V8JVFHu?=
 =?us-ascii?Q?vH8HhX+BwOFSQMFdRjJoLovYNU33mpRwURHuN/Dg6lzddMrDywNfrY+ltjXM?=
 =?us-ascii?Q?HiUyMZBUGCso0qzrQp9MWC1ynfnul28p9UmqlmrIm+kk2PgN6xzmxmtm5iT7?=
 =?us-ascii?Q?+YCAF3ZhCshNcjH6r+gOFE5giXbevKBNtMfDk0zBzk7wAb3MAv9CylNsHJPY?=
 =?us-ascii?Q?4Mu7u+BNHcxOkHybT4pqMHA9ZBRUVnpRahzllRgnkmvz1p7T3ysD7kk9YcCA?=
 =?us-ascii?Q?6y/FlIYYrQMDpqNouG+mawLI8keMRNjZX134SzfStoYIEQii19P/bVMOKUan?=
 =?us-ascii?Q?32lyVfJBM83lBGPrk18i3ji5iQ/uh/oQ1sxN9fq9a7yeZTFOMF8ckNjg42lq?=
 =?us-ascii?Q?tPsZIPGEgRGLcAnacnUVHNz9B40FRhgVhlldNWLTyCTbVUKQbJWVR2dmIeTP?=
 =?us-ascii?Q?RJ922FZD17KhixC/mJmvoCBH3ddQSX5cso6E46bTIENbM+xZY/P8BTPb3FB1?=
 =?us-ascii?Q?PtlWZhfzAKYjJlgIIH//BbK1eq1FQ6qbsJDOaU5PyKK7PaLGsJJAG49CWHEU?=
 =?us-ascii?Q?2iQh/EfxnqcR824aIsYe7PiOwzmJVTe5qfljWw18BkQBoRjAJWdLKwsnkQbH?=
 =?us-ascii?Q?4KxGHJRlEVqjUKQC2jJtbVlfz8sZqECXuDMEi2YTQGuPPIubwKOiVXnckhtt?=
 =?us-ascii?Q?cBs/pPT6RvnAttvw3CzO+escJJQPqrzYNMhfcOIZ2JU3YdREeeoe8VxmP6AM?=
 =?us-ascii?Q?h8gyqhbfMVQJ8tpU1a7JXL/ByRsro/u+Wffvo/EZsHRwz/dvZpb04WYYpucR?=
 =?us-ascii?Q?6W0W7V6uao5PdZ765fzL9ffkwwiS5lzjN4nTnFqnxpoMBLI37OrcKHk/yVcu?=
 =?us-ascii?Q?0NmW9cg6lgc5SQ50gSl9B6qfZX2y6TH9jEmvttlr2Ak/WKCBjfDggEWMgBIo?=
 =?us-ascii?Q?+Fg+5JYFvOm9hHI5YY2qEDHBHl9H/wbxxoL4gaxx1qgQ7hQJVbQbH28+0k1C?=
 =?us-ascii?Q?ghoidCV7pTRd8RqvkWM1kRlCaW2oldplVSRBJLEweYPxiS8gHa53AfcSGKVe?=
 =?us-ascii?Q?2KZ/+m6oekfQjfqF8CJGrr8H0JrNmyMzOcj5FrQdYtPOhPzrU6Uv6jbTzAuw?=
 =?us-ascii?Q?tJL41g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:43:39.5047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c747cb-30e5-4748-1927-08de5f44caa6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7215
X-Rspamd-Queue-Id: 9B014140017
X-Stat-Signature: yeh9j6rgyk3gatsg54kbdbmcxat5muej
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769697836-269925
X-HE-Meta: U2FsdGVkX19/gRqqzivdFaHLILYW4RZUoeCbSLtYv2SJZnIaV8XfPosn5fX3h4+1ndoTldzjRsQApBRTj293YZsQ3eAZECihbJIVb+QBCx+CK0iG1jOj0vj8pX9wdC1OkWfk1tCwaEtp5RKAVlxlHs4Lu7gCFTzrxVIZ7W3S7FSMxW74fsivh3l3a8ifaRtsGG9vJL/cv7Ll69oy49NkAZO3udxzjDK7GUA44jaLGTRwU5qtCSSuAxeh5IiXrPc0dG9UiXcrdyHrSkNK1kcOiCLEPOBR1F83lgjEHsAZjVN/snrDxvs8fLSZhpc3l7hB+UyLflSYJTFJafxZTkTjwnjaTo9cuUt6W5La3NO6kqXcozBZhRRQTjH4ST+ljsfYtmbxNUbVlYB4ASXtX9fPY+GA49Nn0AI2LJvT+3fu2lVwTZgqjs3gM+jfp9N7oOtWh3b/xsn4EsLDiIDmfBtJIJ9SRH09JlhS8soz3ZqYeInEIuT/IxQYJ4o1eLSpE1bq1AWL9M0BU6+SVGVhG+S8Kq41R/sdTRSnYiqnbuTBfyJfYAU3+QIwToR1mc3goKEUClcdlwMRovca29Clk7hctaU/WmghIUsK6fRihvvv+E8Tm4PEUTMGGkC5zPS5ce4WvV7siMggGshhOcBUBBDCbtf26oxwLYGzxTK/NZDbde/oAQ4ZnV5kNDO5NUP6LPOsCpYLlMOYjEurrp+7557KczqplT4/qFmgun5HLyjfxLR0kuiJNxCYi2eGPnXB9L6U5g8iuYW6mugP8WhXeMa2BVpJe6ylqrHY6scPSTSwjHLh0EUOTA5xX6UHTl+QYxKubV4/2JIDWQ+iRRLA/KdDfKAm3ib4FuTDUlNC+uJSO2jY2BZ2KYcHryWWqG2YsT9laW4fBr75rVWbR0hbLdvUMs2g2VM52hTHQSDJ7TRqb5KrvWFhyygi1ds0wDStTDhB9cEF0rJ4LuTJt43ey7W
 eeCW6ri7
 TNZS2BBXa/cdecq5d3ANFkymQ8gUswaqz0iV3pqwvdiNeCRerNZGIPklRfCclOgYXrWYdHeqdfnf5drkoSdhdXiLVxeYiD5kMzr2tK26U5PIGCaojMUk9J+ziCW+qRa7FD59VUJCS6+g/vd9lObfpiywQcWLYAtFy6BwXRgdTb5EwwCvGU/egJ7UGsmbFl3AcWTW8LFeutdv73wBrOpaUJPJiMtWi7HjmKdmFLUlw3AWwohU+742P9pIqZdDuFZnrBcpPNDPttwXHOdhZQjxhwU1CW0XQg4Ph1OFW+y7a/Qf9DghILBmHkWvrLphhHYBo9TGc/PIFPDvJ0hn5OmFbMl79RAdf9BDqmFKvaQLRsfeISSmnxISj0Epg6870kZ1eyEUrf5wOb57YJAeNrzuTLyM/rcjEi+wqoPMce+YVWGbZLuLics+r8R1Sin4McPzhwtNHRF5Rp60URR/AKc78bkevJuHzpwRuPDyWQFgnFwTr6XUKkKhnRTX8I1ZeM/FDMAV0DF7n5z0B0E8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently hot page promotion (NUMA_BALANCING_MEMORY_TIERING
mode of NUMA Balancing) does hot page detection (via hint faults),
hot page classification and eventual promotion, all by itself and
sits within the scheduler.

With pghot, the new hot page tracking and promotion mechanism
being available, NUMA Balancing can limit itself to detection
of hot pages (via hint faults) and off-load rest of the
functionality to the common hot page tracking system.

pghot_record_access(PGHOT_HINT_FAULT) API is used to feed the
hot page info to pghot. In addition, the migration rate limiting
and dynamic threshold logic are moved to kmigrated so that the
same can be used for hot pages reported by other sources too.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 kernel/sched/debug.c |   1 -
 kernel/sched/fair.c  | 152 ++-----------------------------------------
 mm/huge_memory.c     |  26 ++------
 mm/memory.c          |  31 ++-------
 mm/pghot.c           | 124 +++++++++++++++++++++++++++++++++++
 5 files changed, 141 insertions(+), 193 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 41caa22e0680..02931902a9c6 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -520,7 +520,6 @@ static __init int sched_init_debug(void)
 	debugfs_create_u32("scan_period_min_ms", 0644, numa, &sysctl_numa_balancing_scan_period_min);
 	debugfs_create_u32("scan_period_max_ms", 0644, numa, &sysctl_numa_balancing_scan_period_max);
 	debugfs_create_u32("scan_size_mb", 0644, numa, &sysctl_numa_balancing_scan_size);
-	debugfs_create_u32("hot_threshold_ms", 0644, numa, &sysctl_numa_balancing_hot_threshold);
 #endif /* CONFIG_NUMA_BALANCING */
 
 	debugfs_create_file("debug", 0444, debugfs_sched, NULL, &sched_debug_fops);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index da46c3164537..4e70f58fbbfa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -125,11 +125,6 @@ int __weak arch_asym_cpu_priority(int cpu)
 static unsigned int sysctl_sched_cfs_bandwidth_slice		= 5000UL;
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
-/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
-static unsigned int sysctl_numa_balancing_promote_rate_limit = 65536;
-#endif
-
 #ifdef CONFIG_SYSCTL
 static const struct ctl_table sched_fair_sysctls[] = {
 #ifdef CONFIG_CFS_BANDWIDTH
@@ -142,16 +137,6 @@ static const struct ctl_table sched_fair_sysctls[] = {
 		.extra1         = SYSCTL_ONE,
 	},
 #endif
-#ifdef CONFIG_NUMA_BALANCING
-	{
-		.procname	= "numa_balancing_promote_rate_limit_MBps",
-		.data		= &sysctl_numa_balancing_promote_rate_limit,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-#endif /* CONFIG_NUMA_BALANCING */
 };
 
 static int __init sched_fair_sysctl_init(void)
@@ -1427,9 +1412,6 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
-/* The page with hint page fault latency < threshold in ms is considered hot */
-unsigned int sysctl_numa_balancing_hot_threshold = MSEC_PER_SEC;
-
 struct numa_group {
 	refcount_t refcount;
 
@@ -1784,108 +1766,6 @@ static inline bool cpupid_valid(int cpupid)
 	return cpupid_to_cpu(cpupid) < nr_cpu_ids;
 }
 
-/*
- * For memory tiering mode, if there are enough free pages (more than
- * enough watermark defined here) in fast memory node, to take full
- * advantage of fast memory capacity, all recently accessed slow
- * memory pages will be migrated to fast memory node without
- * considering hot threshold.
- */
-static bool pgdat_free_space_enough(struct pglist_data *pgdat)
-{
-	int z;
-	unsigned long enough_wmark;
-
-	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
-			   pgdat->node_present_pages >> 4);
-	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
-		struct zone *zone = pgdat->node_zones + z;
-
-		if (!populated_zone(zone))
-			continue;
-
-		if (zone_watermark_ok(zone, 0,
-				      promo_wmark_pages(zone) + enough_wmark,
-				      ZONE_MOVABLE, 0))
-			return true;
-	}
-	return false;
-}
-
-/*
- * For memory tiering mode, when page tables are scanned, the scan
- * time will be recorded in struct page in addition to make page
- * PROT_NONE for slow memory page.  So when the page is accessed, in
- * hint page fault handler, the hint page fault latency is calculated
- * via,
- *
- *	hint page fault latency = hint page fault time - scan time
- *
- * The smaller the hint page fault latency, the higher the possibility
- * for the page to be hot.
- */
-static int numa_hint_fault_latency(struct folio *folio)
-{
-	int last_time, time;
-
-	time = jiffies_to_msecs(jiffies);
-	last_time = folio_xchg_access_time(folio, time);
-
-	return (time - last_time) & PAGE_ACCESS_TIME_MASK;
-}
-
-/*
- * For memory tiering mode, too high promotion/demotion throughput may
- * hurt application latency.  So we provide a mechanism to rate limit
- * the number of pages that are tried to be promoted.
- */
-static bool numa_promotion_rate_limit(struct pglist_data *pgdat,
-				      unsigned long rate_limit, int nr)
-{
-	unsigned long nr_cand;
-	unsigned int now, start;
-
-	now = jiffies_to_msecs(jiffies);
-	mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE, nr);
-	nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
-	start = pgdat->nbp_rl_start;
-	if (now - start > MSEC_PER_SEC &&
-	    cmpxchg(&pgdat->nbp_rl_start, start, now) == start)
-		pgdat->nbp_rl_nr_cand = nr_cand;
-	if (nr_cand - pgdat->nbp_rl_nr_cand >= rate_limit)
-		return true;
-	return false;
-}
-
-#define NUMA_MIGRATION_ADJUST_STEPS	16
-
-static void numa_promotion_adjust_threshold(struct pglist_data *pgdat,
-					    unsigned long rate_limit,
-					    unsigned int ref_th)
-{
-	unsigned int now, start, th_period, unit_th, th;
-	unsigned long nr_cand, ref_cand, diff_cand;
-
-	now = jiffies_to_msecs(jiffies);
-	th_period = sysctl_numa_balancing_scan_period_max;
-	start = pgdat->nbp_th_start;
-	if (now - start > th_period &&
-	    cmpxchg(&pgdat->nbp_th_start, start, now) == start) {
-		ref_cand = rate_limit *
-			sysctl_numa_balancing_scan_period_max / MSEC_PER_SEC;
-		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
-		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
-		unit_th = ref_th * 2 / NUMA_MIGRATION_ADJUST_STEPS;
-		th = pgdat->nbp_threshold ? : ref_th;
-		if (diff_cand > ref_cand * 11 / 10)
-			th = max(th - unit_th, unit_th);
-		else if (diff_cand < ref_cand * 9 / 10)
-			th = min(th + unit_th, ref_th * 2);
-		pgdat->nbp_th_nr_cand = nr_cand;
-		pgdat->nbp_threshold = th;
-	}
-}
-
 bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu)
 {
@@ -1901,33 +1781,11 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
 	/*
 	 * The pages in slow memory node should be migrated according
-	 * to hot/cold instead of private/shared.
-	 */
-	if (folio_use_access_time(folio)) {
-		struct pglist_data *pgdat;
-		unsigned long rate_limit;
-		unsigned int latency, th, def_th;
-		long nr = folio_nr_pages(folio);
-
-		pgdat = NODE_DATA(dst_nid);
-		if (pgdat_free_space_enough(pgdat)) {
-			/* workload changed, reset hot threshold */
-			pgdat->nbp_threshold = 0;
-			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
-			return true;
-		}
-
-		def_th = sysctl_numa_balancing_hot_threshold;
-		rate_limit = MB_TO_PAGES(sysctl_numa_balancing_promote_rate_limit);
-		numa_promotion_adjust_threshold(pgdat, rate_limit, def_th);
-
-		th = pgdat->nbp_threshold ? : def_th;
-		latency = numa_hint_fault_latency(folio);
-		if (latency >= th)
-			return false;
-
-		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
-	}
+	 * to hot/cold instead of private/shared. Also the migration
+	 * of such pages are handled by kmigrated.
+	 */
+	if (folio_use_access_time(folio))
+		return true;
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..f52587e70b3c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -40,6 +40,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/pghot.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2217,29 +2218,12 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 
 	target_nid = numa_migrate_check(folio, vmf, haddr, &flags, writable,
 					&last_cpupid);
+	nid = target_nid;
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
-	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
-		flags |= TNF_MIGRATE_FAIL;
-		goto out_map;
-	}
-	/* The folio is isolated and isolation code holds a folio reference. */
-	spin_unlock(vmf->ptl);
-	writable = false;
 
-	if (!migrate_misplaced_folio(folio, target_nid)) {
-		flags |= TNF_MIGRATED;
-		nid = target_nid;
-		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
-		return 0;
-	}
+	writable = false;
 
-	flags |= TNF_MIGRATE_FAIL;
-	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
-		spin_unlock(vmf->ptl);
-		return 0;
-	}
 out_map:
 	/* Restore the PMD */
 	pmd = pmd_modify(pmdp_get(vmf->pmd), vma->vm_page_prot);
@@ -2250,8 +2234,10 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	spin_unlock(vmf->ptl);
 
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE) {
+		pghot_record_access(folio_pfn(folio), nid, PGHOT_HINT_FAULT, jiffies);
 		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
+	}
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..98a9a3b675a0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -75,6 +75,7 @@
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
+#include <linux/pghot.h>
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
@@ -6046,34 +6047,12 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 
 	target_nid = numa_migrate_check(folio, vmf, vmf->address, &flags,
 					writable, &last_cpupid);
+	nid = target_nid;
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
-	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
-		flags |= TNF_MIGRATE_FAIL;
-		goto out_map;
-	}
-	/* The folio is isolated and isolation code holds a folio reference. */
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
+
 	writable = false;
 	ignore_writable = true;
-
-	/* Migrate to the requested node */
-	if (!migrate_misplaced_folio(folio, target_nid)) {
-		nid = target_nid;
-		flags |= TNF_MIGRATED;
-		task_numa_fault(last_cpupid, nid, nr_pages, flags);
-		return 0;
-	}
-
-	flags |= TNF_MIGRATE_FAIL;
-	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-				       vmf->address, &vmf->ptl);
-	if (unlikely(!vmf->pte))
-		return 0;
-	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return 0;
-	}
 out_map:
 	/*
 	 * Make it present again, depending on how arch implements
@@ -6087,8 +6066,10 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE) {
+		pghot_record_access(folio_pfn(folio), nid, PGHOT_HINT_FAULT, jiffies);
 		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+	}
 	return 0;
 }
 
diff --git a/mm/pghot.c b/mm/pghot.c
index bf1d9029cbaa..6fc76c1eaff8 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -17,6 +17,9 @@
  * the hot pages. kmigrated runs for each lower tier node. It iterates
  * over the node's PFNs and  migrates pages marked for migration into
  * their targeted nodes.
+ *
+ * Migration rate-limiting and dynamic threshold logic implementations
+ * were moved from NUMA Balancing mode 2.
  */
 #include <linux/mm.h>
 #include <linux/migrate.h>
@@ -31,6 +34,12 @@ unsigned int kmigrated_batch_nr = KMIGRATED_DEFAULT_BATCH_NR;
 
 unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
 
+/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
+static unsigned int sysctl_pghot_promote_rate_limit = 65536;
+
+#define KMIGRATED_MIGRATION_ADJUST_STEPS	16
+#define KMIGRATED_PROMOTION_THRESHOLD_WINDOW	60000
+
 DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
 DEFINE_STATIC_KEY_FALSE(pghot_src_pgtscans);
 DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
@@ -45,6 +54,14 @@ static const struct ctl_table pghot_sysctls[] = {
 		.proc_handler   = proc_dointvec_minmax,
 		.extra1         = SYSCTL_ZERO,
 	},
+	{
+		.procname	= "pghot_promote_rate_limit_MBps",
+		.data		= &sysctl_pghot_promote_rate_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
 };
 #endif
 
@@ -138,6 +155,110 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
 	return 0;
 }
 
+/*
+ * For memory tiering mode, if there are enough free pages (more than
+ * enough watermark defined here) in fast memory node, to take full
+ * advantage of fast memory capacity, all recently accessed slow
+ * memory pages will be migrated to fast memory node without
+ * considering hot threshold.
+ */
+static bool pgdat_free_space_enough(struct pglist_data *pgdat)
+{
+	int z;
+	unsigned long enough_wmark;
+
+	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
+			   pgdat->node_present_pages >> 4);
+	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
+		struct zone *zone = pgdat->node_zones + z;
+
+		if (!populated_zone(zone))
+			continue;
+
+		if (zone_watermark_ok(zone, 0,
+				      promo_wmark_pages(zone) + enough_wmark,
+				      ZONE_MOVABLE, 0))
+			return true;
+	}
+	return false;
+}
+
+/*
+ * For memory tiering mode, too high promotion/demotion throughput may
+ * hurt application latency.  So we provide a mechanism to rate limit
+ * the number of pages that are tried to be promoted.
+ */
+static bool kmigrated_promotion_rate_limit(struct pglist_data *pgdat, unsigned long rate_limit,
+					   int nr, unsigned long now_ms)
+{
+	unsigned long nr_cand;
+	unsigned int start;
+
+	mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE, nr);
+	nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+	start = pgdat->nbp_rl_start;
+	if (now_ms - start > MSEC_PER_SEC &&
+	    cmpxchg(&pgdat->nbp_rl_start, start, now_ms) == start)
+		pgdat->nbp_rl_nr_cand = nr_cand;
+	if (nr_cand - pgdat->nbp_rl_nr_cand >= rate_limit)
+		return true;
+	return false;
+}
+
+static void kmigrated_promotion_adjust_threshold(struct pglist_data *pgdat,
+						 unsigned long rate_limit, unsigned int ref_th,
+						 unsigned long now_ms)
+{
+	unsigned int start, th_period, unit_th, th;
+	unsigned long nr_cand, ref_cand, diff_cand;
+
+	th_period = KMIGRATED_PROMOTION_THRESHOLD_WINDOW;
+	start = pgdat->nbp_th_start;
+	if (now_ms - start > th_period &&
+	    cmpxchg(&pgdat->nbp_th_start, start, now_ms) == start) {
+		ref_cand = rate_limit *
+			KMIGRATED_PROMOTION_THRESHOLD_WINDOW / MSEC_PER_SEC;
+		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
+		unit_th = ref_th * 2 / KMIGRATED_MIGRATION_ADJUST_STEPS;
+		th = pgdat->nbp_threshold ? : ref_th;
+		if (diff_cand > ref_cand * 11 / 10)
+			th = max(th - unit_th, unit_th);
+		else if (diff_cand < ref_cand * 9 / 10)
+			th = min(th + unit_th, ref_th * 2);
+		pgdat->nbp_th_nr_cand = nr_cand;
+		pgdat->nbp_threshold = th;
+	}
+}
+
+static bool kmigrated_should_migrate_memory(unsigned long nr_pages, int nid,
+					    unsigned long time)
+{
+	struct pglist_data *pgdat;
+	unsigned long rate_limit;
+	unsigned int th, def_th;
+	unsigned long now_ms = jiffies_to_msecs(jiffies); /* Based on full-width jiffies */
+	unsigned long now = jiffies;
+
+	pgdat = NODE_DATA(nid);
+	if (pgdat_free_space_enough(pgdat)) {
+		/* workload changed, reset hot threshold */
+		pgdat->nbp_threshold = 0;
+		mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr_pages);
+		return true;
+	}
+
+	def_th = sysctl_pghot_freq_window;
+	rate_limit = MB_TO_PAGES(sysctl_pghot_promote_rate_limit);
+	kmigrated_promotion_adjust_threshold(pgdat, rate_limit, def_th, now_ms);
+
+	th = pgdat->nbp_threshold ? : def_th;
+	if (pghot_access_latency(time, now) >= th)
+		return false;
+
+	return !kmigrated_promotion_rate_limit(pgdat, rate_limit, nr_pages, now_ms);
+}
+
 static int pghot_get_hotness(unsigned long pfn, int *nid, int *freq,
 			     unsigned long *time)
 {
@@ -197,6 +318,9 @@ static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
 		if (folio_nid(folio) == nid)
 			goto out_next;
 
+		if (!kmigrated_should_migrate_memory(nr, nid, time))
+			goto out_next;
+
 		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
 			goto out_next;
 
-- 
2.34.1


