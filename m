Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE7BD3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8E26B0363; Sat,  6 Dec 2025 05:16:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A00C6B0365; Sat,  6 Dec 2025 05:16:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167AB6B0366; Sat,  6 Dec 2025 05:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDEDD6B0363
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:16:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE6FC52552
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:16:28 +0000 (UTC)
X-FDA: 84188641656.13.687E8B2
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by imf09.hostedemail.com (Postfix) with ESMTP id ABA15140005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:16:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Yw40PJSp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of bharata@amd.com designates 40.93.201.38 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIp1wnrbkmPyomzAXvzAmbyaPXBtr9Jb01qxtFcFEWg=;
	b=HYs7yd+xRdMfBXi9mNwU4IALNC/6WbpUHXlbyM1xI2Z+0a2dacxy0J0qTZ0kHh0ii6DUVb
	6CfmBdFd6gJbmkFUy8YP5tf2f0eSfvO3NIReh/DUubtJYeni4zZeZvf/xolgWMahvWde84
	ZuaAL6t/wNNphJcJ6U6U9AURbTp7Wz0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016185; a=rsa-sha256;
	cv=pass;
	b=Aii9odOI1q18WzlG6MPmaLdRM6T3H3ljhIFexqdrzEurd8U7JckepMumJadBgyZZJF1BF+
	MRvjsy+9HNANZ4hBpu9zHactesq5ZkHfWYwO1t38z5o3+pJvXe/4VKBkjzkb652856jW6x
	viNyChUpNbhtbSEQwYU4YNpTUT4ZR+4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Yw40PJSp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of bharata@amd.com designates 40.93.201.38 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iDUzlR3rQEfTfyNdtbMhF7gz9Gig2dNkaG6vxdjXHuxZOUPXdum4nrzpOFZt0dI0kqU6NM049eS5N7UWKeiauvf1HNreskmTSa5cApKnLTeFD+R/NcLc5NC6dNPlFVKltO6owzbrGpgFywEWP0H4nP8N7FuArPBZOwLBGkUXee7KJwkTkiCaD0ep6KJbdgSBDnwxVBgXcx42mX0O8ECk7w64vj3xLfBVzKqTL9DiFrkFPhKOVlS5yto5nIgytRlhRaRQXh4A5lyUjeQX/Dm8qjhjzcTnAvo2YgUfQ10tDZq8pLu2VBk9aSr2lqJVj+oHxva3/5858bbUM7ZAY+5Q2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIp1wnrbkmPyomzAXvzAmbyaPXBtr9Jb01qxtFcFEWg=;
 b=rbMi0MBS9fFfO2GSKltsFNjV7iG+dzskJMsXXMk/9SwNwbvs9aAdRI72t+E3tfrISI1Dlj8L3Q17lokEE7i4vfCFvzysEaXo9kKAxJwB7wnW1IoL2z1SSKyYGTGOVRQ30lAt3YshoR2dqZgaWPRuCWP1zsxZn45f/R9rAuvDSlTrxV6fqAEdCPFbOdQUF3VTT/nkGFg4hNbE9gZXOPLsdBB9IwYZz+uL0k4XqzCIAOEX86YLpUH9UK5Mg1MOsRXaZKzs+Z2WL5TxJL4PYLh+T8hM/InWAzeSdS23VzW38Ul6JencUmiypuXojih4nt9SBXUcmdEStiAa2ZLDUHI4bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIp1wnrbkmPyomzAXvzAmbyaPXBtr9Jb01qxtFcFEWg=;
 b=Yw40PJSph1Py/xIMUjNjGg8EHh/TWGFs5QHYOOlimArgwszr7mwTEPWS4UtlRjnvviPtr9cujiMkjp2LcFovFUEHAkRBggCbvWDyJ12+DaRvbZ/m+hLpF5w5p4hDAXzpwbkNDUpBbXQTpWzpBCg7V5ONACI3o5ksdJ64yOIGZGM=
Received: from DM6PR02CA0109.namprd02.prod.outlook.com (2603:10b6:5:1b4::11)
 by CY1PR12MB9649.namprd12.prod.outlook.com (2603:10b6:930:106::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 10:16:19 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:5:1b4:cafe::5c) by DM6PR02CA0109.outlook.office365.com
 (2603:10b6:5:1b4::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.13 via Frontend Transport; Sat,
 6 Dec 2025 10:16:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:16:19 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:16:11 -0600
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
Subject: [RFC PATCH v4 3/9] mm: Hot page tracking and promotion
Date: Sat, 6 Dec 2025 15:44:17 +0530
Message-ID: <20251206101423.5004-4-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|CY1PR12MB9649:EE_
X-MS-Office365-Filtering-Correlation-Id: aab42f27-acfd-4a24-a0d4-08de34b07f88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rGubQ9xeyKNKL1YJLydsN1GZehlhtKAXQtPhttHbhtOZR0liUBPUBIwftLdo?=
 =?us-ascii?Q?RuSoQRVbEdPxOGxMhzsZqRwCtmkCApmf47xnGcCMqLPMbPdkd+GA3OYm2UlM?=
 =?us-ascii?Q?9IQ11pyrSNhUkeVlRSB35kNTYTOSYavkndhqWwu9kCQnCpvZ5FCkW1vjs/5b?=
 =?us-ascii?Q?4P6atpxy5swn35InEISib1s6H0x74rrjRapAFWL5mMmf+Z05efnohTkz/Ive?=
 =?us-ascii?Q?v+WNhzZuHMbdMch0E1Uyw2hxQLO8NWmRuAx14dV8gSmF79e+R6ac8s6JNZD0?=
 =?us-ascii?Q?Pt3vJkShtFxLRLFCqHm/ffs9F6zmGmXrw0x6XzvcK3kig8cVgcW4XxN1C7hT?=
 =?us-ascii?Q?3TQwxu0Wo9ucTBM3OX9ys5UEKVRGLIP358/DAHYlXBORH9ZYyrpT05qhAO0G?=
 =?us-ascii?Q?PU9EBdSpQoYxYW3B4DlZ42kP5zQIT/eeA3GRiK04V/jy4eewN1elzaqrSUxm?=
 =?us-ascii?Q?F8OCwudIQuf3uOHpfPv9tUKevKOXZNRamb+YG9hXmR8qOCHeNvwWklN4t7S8?=
 =?us-ascii?Q?6COXVfFFCskCsQEFEfPdTT16ljJVykrZtcos8KcfSXYts+fUSfghWsGwDlLj?=
 =?us-ascii?Q?PdjPidcwCuS9bvTIZlgw+bu+wLIutIzGLzrhFW1So0eYxftTL3uBZgLzzmKm?=
 =?us-ascii?Q?+Sv3ANsNxrHTNcG8qvh3vyBmjGoq72LYyTRqpUNQ14zUp/d7AlJWOonw60NV?=
 =?us-ascii?Q?K3Gotpx9JTfCc6iY5JD8dDxQ7dBOhcqCLuYfJgshZkaGV6XuJyrr+Hn3SL40?=
 =?us-ascii?Q?zFHJcjFMR0nG7RB2XPfelkZ6+/hW6qDvqMMSbFighJDXxdLyg98Cg6bOAnJM?=
 =?us-ascii?Q?m+lXRTQn/f99JCKPX/eXzzJC4APM3fiRZXFD4p6sVbPX4DmzaszhfsqQA5g8?=
 =?us-ascii?Q?Q4AmfuNigdM8mBgmuTRUw4tIzGubLPH+b4amR5kZmEBvbNT7vHvw2BULqIG1?=
 =?us-ascii?Q?itRoHzselrpseSaV2SrtEFSky5UiHlv6RD2edpEBhRFGfKCCSp3ldJkPCFvw?=
 =?us-ascii?Q?fpwWiFDHYseA2kaTdvPXoNoSMr0t3Sn7M1DkQinIXOB0sDwqWdBNwY+6gQmp?=
 =?us-ascii?Q?zDO5EP426ueYKWtfij6A+5wbNqEfaSO9BXv0Y3NeeKEwxnjuBx7oscTz6ZQv?=
 =?us-ascii?Q?6ynOEo53dd5Arnns73aUEL5xX/oteFcHGNVduEm4ekQdIhYwkSUlY3F0FvlD?=
 =?us-ascii?Q?TxcqNEBTFD0X55Fb3GrfPYlv7sheYDmn9Cicu4ssgd8cfQVE1qEORRQ3WYdy?=
 =?us-ascii?Q?cUkjhel62a1dvmtcHv0yVIWdDMBHeqgoUcV9LzZYtXXC3+poHghfgAanH5QB?=
 =?us-ascii?Q?rPCjsS/Uwr4AsFxh35nocZczEQ8zpQUu1nnMF63GSz2gAM6VRnB8I6BXXwnE?=
 =?us-ascii?Q?zfmZEaf9E2U1i9VA35eI81LcOKrVsLWKyKVk2RjR0J0Bazje2vO1wLbh+xVk?=
 =?us-ascii?Q?1z31MYUlrEfLI99VxkGlIutf6LKdcKamBHNxKQFK2LRUJeoDy+3Ay4L11XYi?=
 =?us-ascii?Q?PnoqUe9r4iDyMwxfgkp1C6Us9itWNBdRpuJAkged35iivXDdIksYNGQzFPTN?=
 =?us-ascii?Q?K8TjHb/hwrGXLXIKpFU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:16:19.0856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aab42f27-acfd-4a24-a0d4-08de34b07f88
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9649
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABA15140005
X-Stat-Signature: ns3m8oo5jkqw3r9osffwmt3w7aex7pud
X-Rspam-User: 
X-HE-Tag: 1765016185-126330
X-HE-Meta: U2FsdGVkX1+9anXKMuCsSXwL/gBADSyZSkFJBDclC3u8gp9qpmne4Lyn/SBvtfFB0rBzFfuWFdo6sL8JnwHbUq+a2YuFxSpGo943itnfJDNSpqqu+JfC+MPD3De6gGI91YFj4VOwP4SrR+xinljOiUULc0vTBlFVHaEX0xogOsKJ36PwLNilSagMXdBv1+rq54IBj3Wj/iFLarKZBgjCYJ7A9rO4SsQcaodwf30ly97WSu1YZRjM4os7wArqCWJuitnSUk0yXT2xIVhfVbz+kDl08Fbdqp8ptx5l4L0LARhPesdKuA0cE8OTUzADMZ9AieD3EL82iGHFXXW8pzHDpf3MaUgifKSBiJGG1Lm6RAie1irwq97aTaY3kqYNcNYcZgjlABGiFOHUGY5jn7RI8yJoeKHCKPLqF2UjWs8FZHykEex1BsNO0cujElSJNyu4VthpuGDGJYRHAe7ZGTOfN+8q3s2WINC1Z/ofj/BZKSIvbbFV+BO+WUbben4KY6YQWPgIjaBFFyb8fonwhKwpu1QTlUdVA3kc/AO+H/CJf7LdWMOYLZH6arrGD3qiXIYQlTYd9djfsaZjwM9/Kgrm2PeS/k/f1/VLgZQlHawmQxvsJlk9jrfPwvg1/jst94vM9kaClqe97kj0SOyQ5/OD6FNbxUbkxPIaAqpSpkrS68uBxVstemUmpLjOFfaPwjwTMJjIzyBhxcbG+V7DStnC/OcFAc7m/CN/l0wOQ4QXrqn4cch2Kgt2fVZ/0qNh/K0bJHU1eHE38kb52pvLayK2v15Tk42bksh0TOwr0Qo5MMizSQ4Mux8yNKXgaBjj+pJtMKgl0ttIMuSU4QkDorEXlp1SGXt57axxVExIb+PNDd2ZW3jtvfbpw5GCskl6WIM/EA6n1JmKNrZVOIKmiofnTPZVKWnvU12NjpmhhRADube7TikD/n+XzqPUiQuvpTLAV9s4958tBLF55hG1jB4
 QcA2SCgG
 P7bnIX2hJ8sAye/8bMIf0mOgIgcZaIZEmN81qBcqLPkgdMoE6JTuKZAZqtNPE8GWDPsSNDSqj0bMy5gwVNNqjbpLzd+t02G/EkG4ZgrZkJ2ZNWP7je/QId4K9/mAmk1ik3CAfcRz3Gv2vVHhRDQgGqSFPwC8pYd8GcGj+9X7Ptg0x468suNptLE5kIJN6zyTZG6JSQIAf80QWQOUF68MCV1msGaj820HmqSCy9Uvp6TN4NCnGKl6t9xvpRy7UGWWK1SkFwBmahoKGZMOPniQOKXdxarGgyLJnUmAMdrTXmyC5zLV5ZXLNGNG06m+KJRv5LHhPhwjTeJMqTmXgQLS54VXEC+DbtlVwcc6A+ZGntoV7yL54MpFfZ7sPmvLaNYakSCpakSEFKTQgTw7EQjIDaOWwrCLWgxed6U+KX/6zVNcZ4QzCxU+1MGMcsfDyyu9p4CqPRRer43QpVdp1dL+jT18D5tfKzgfeD/VolxJbJS4OWqd7iuP9MrrYLOOfVDRKj1xjlrJt9C7PIJg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This introduces a sub-system for collecting memory access
information from different sources. It maintains the hotness
information based on the access history and time of access.

Additionally, it provides per-lowertier-node kernel threads
(named kmigrated) that periodically promote the pages that
are eligible for promotion.

Sub-systems that generate hot page access info can report that
using this API:

int pghot_record_access(unsigned long pfn, int nid, int src,
                        unsigned long time)

@pfn: The PFN of the memory accessed
@nid: The accessing NUMA node ID
@src: The temperature source (sub-system) that generated the
      access info
@time: The access time in jiffies

Some temperature sources may not provide the nid from which
the page was accessed. This is true for sources that use
page table scanning for PTE Accessed bit. For such sources,
the default toptier node to which such pages should be promoted
is hard coded.

The hotness information is stored for every page of lower
tier memory in an unsigned long variable that is part of
mem_section data structure.

kmigrated is a per-lowertier-node kernel thread that migrates
the folios marked for migration in batches. Each kmigrated
thread walks the PFN range spanning its node and checks
for potential migration candidates.

A bunch of tunables for enabling different hotness sources,
setting target_nid, frequency threshold are provided in debugfs.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.txt |  63 ++++
 include/linux/mmzone.h                 |  14 +
 include/linux/pghot.h                  |  71 +++++
 include/linux/vm_event_item.h          |   6 +
 mm/Kconfig                             |  11 +
 mm/Makefile                            |   1 +
 mm/mm_init.c                           |  10 +
 mm/pghot-debug.c                       | 180 +++++++++++
 mm/pghot.c                             | 402 +++++++++++++++++++++++++
 mm/vmstat.c                            |   6 +
 10 files changed, 764 insertions(+)
 create mode 100644 Documentation/admin-guide/mm/pghot.txt
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot-debug.c
 create mode 100644 mm/pghot.c

diff --git a/Documentation/admin-guide/mm/pghot.txt b/Documentation/admin-guide/mm/pghot.txt
new file mode 100644
index 000000000000..13b87bcfa6a4
--- /dev/null
+++ b/Documentation/admin-guide/mm/pghot.txt
@@ -0,0 +1,63 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+PGHOT: Hot Page Tracking Tunables
+=================================
+
+Overview
+========
+The PGHOT subsystem tracks frequently accessed pages in lower-tier memory and
+promotes them to faster tiers. It uses per-PFN hotness metadata and asynchronous
+migration via per-node kernel threads (kmigrated).
+
+This document describes tunables available via **debugfs** and **sysctl** for
+PGHOT.
+
+Debugfs Interface
+=================
+Path: /sys/kernel/debug/pghot/
+
+1. **enabled_sources**
+   - Bitmask to enable/disable hotness sources.
+   - Bits:
+     - 0: Hardware hints (value 0x1)
+     - 1: Page table scan (value 0x2)
+     - 2: Hint faults (value 0x4)
+   - Default: 0 (disabled)
+   - Example:
+     # echo 0x7 > /sys/kernel/debug/pghot/enabled_sources
+     Enables all sources.
+
+2. **target_nid**
+   - NUMA node ID to which hot pages should be promoted when source does not provide nid.
+   - Default: 0
+   - Example:
+     # echo 1 > /sys/kernel/debug/pghot/target_nid
+
+3. **freq_threshold**
+   - Minimum access frequency before a page is marked ready for promotion.
+   - Range: 1 to 8
+   - Default: 2
+   - Example:
+     # echo 3 > /sys/kernel/debug/pghot/freq_threshold
+
+4. **kmigrated_sleep_ms**
+   - Sleep interval (ms) for kmigrated thread between scans.
+   - Default: 100
+
+5. **kmigrated_batch_nr**
+   - Maximum number of folios migrated in one batch.
+   - Default: 512
+
+Sysctl Interface
+================
+1. pghot_promote_freq_window_ms
+
+Path: /proc/sys/vm/pghot_promote_freq_window_ms
+
+- Controls the time window (in ms) for counting access frequency. A page is
+  considered hot only when **freq_threshold** number of accesses occur with
+  this time period.
+- Default: 5000 (5 seconds)
+- Example:
+  # sysctl vm.pghot_promote_freq_window_ms=3000
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..fde851990394 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1068,6 +1068,7 @@ enum pgdat_flags {
 					 * many pages under writeback
 					 */
 	PGDAT_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
+	PGDAT_KMIGRATED_ACTIVATE,	/* activates kmigrated */
 };
 
 enum zone_flags {
@@ -1522,6 +1523,10 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_PGHOT
+	struct task_struct *kmigrated;
+	wait_queue_head_t kmigrated_wait;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
@@ -1920,12 +1925,21 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
+#ifdef CONFIG_PGHOT
+	/*
+	 * Per-PFN hotness data for this section.
+	 */
+	unsigned long *hot_map;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
+#endif
+#if (defined(CONFIG_PGHOT) && !defined(CONFIG_PAGE_EXTENSION)) || \
+		(!defined(CONFIG_PGHOT) && defined(CONFIG_PAGE_EXTENSION))
 	unsigned long pad;
 #endif
 	/*
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
new file mode 100644
index 000000000000..802240d574a6
--- /dev/null
+++ b/include/linux/pghot.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGHOT_H
+#define _LINUX_PGHOT_H
+
+/* Page hotness temperature sources */
+enum pghot_src {
+	PGHOT_HW_HINTS,
+	PGHOT_PGTABLE_SCAN,
+	PGHOT_HINT_FAULT,
+};
+
+#ifdef CONFIG_PGHOT
+/*
+ * Bit positions to enable individual sources in pghot/records_enabled
+ * of debugfs.
+ */
+enum pghot_src_enabed {
+	PGHOT_HWHINTS_BIT	= 0,
+	PGHOT_PGTSCAN_BIT,
+	PGHOT_HINTFAULT_BIT,
+	PGHOT_MAX_BIT
+};
+
+#define PGHOT_HWHINTS_ENABLED	BIT(PGHOT_HWHINTS_BIT)
+#define PGHOT_PGTSCAN_ENABLED	BIT(PGHOT_PGTSCAN_BIT)
+#define PGHOT_HINTFAULT_ENABLED	BIT(PGHOT_HINTFAULT_BIT)
+#define PGHOT_SRC_ENABLED_MASK	GENMASK(PGHOT_MAX_BIT - 1, 0)
+
+#define PGHOT_DEFAULT_FREQ_WINDOW	(5 * MSEC_PER_SEC)
+#define PGHOT_DEFAULT_FREQ_THRESHOLD	2
+
+#define KMIGRATED_DEFAULT_SLEEP_MS	100
+#define KMIGRATED_DEFAULT_BATCH_NR	512
+
+#define PGHOT_DEFAULT_NODE	0
+
+/*
+ * Bits 0-31 are used to store nid, frequency and time.
+ * Bits 32-62 are unused now.
+ * Bit 63 is used to indicate the page is ready for migration.
+ */
+#define PGHOT_MIGRATE_READY	63
+
+#define PGHOT_NID_WIDTH		10
+#define PGHOT_FREQ_WIDTH	3
+/* time is stored in 19 bits which can represent up to 8.73s with HZ=1000 */
+#define PGHOT_TIME_WIDTH	19
+
+#define PGHOT_NID_SHIFT		0
+#define PGHOT_FREQ_SHIFT	(PGHOT_NID_SHIFT + PGHOT_NID_WIDTH)
+#define PGHOT_TIME_SHIFT	(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
+
+#define PGHOT_NID_MASK		((1UL << PGHOT_NID_SHIFT) - 1)
+#define PGHOT_FREQ_MASK		((1UL << PGHOT_FREQ_SHIFT) - 1)
+#define PGHOT_TIME_MASK		((1UL << PGHOT_TIME_SHIFT) - 1)
+
+#define PGHOT_NID_MAX		(1 << PGHOT_NID_WIDTH)
+#define PGHOT_FREQ_MAX		(1 << PGHOT_FREQ_WIDTH)
+#define PGHOT_TIME_MAX		(1 << PGHOT_TIME_WIDTH)
+
+#define PGHOT_SECTION_HOT_BIT	BIT(0)
+#define PGHOT_SECTION_HOT_MASK	GENMASK(PGHOT_SECTION_HOT_BIT - 1, 0)
+
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now);
+#else
+static inline int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	return 0;
+}
+#endif /* CONFIG_PGHOT */
+#endif /* _LINUX_PGHOT_H */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 92f80b4d69a6..5b8fd93b55fd 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -188,6 +188,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_PGHOT
+		PGHOT_RECORDED_ACCESSES,
+		PGHOT_RECORD_HWHINTS,
+		PGHOT_RECORD_PGTSCANS,
+		PGHOT_RECORD_HINTFAULTS,
+#endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index ca3f146bc705..472975da69e1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1379,6 +1379,17 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+config PGHOT
+	bool "Hot page tracking and promotion"
+	def_bool n
+	depends on NUMA && MIGRATION && SPARSEMEM && MMU
+	help
+	  A sub-system to track page accesses in lower tier memory and
+	  maintain hot page information. Promotes hot pages from lower
+	  tiers to top tier by using the memory access information provided
+	  by various sources. Asynchronous promotion is done by per-node
+	  kernel threads.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..a6fac171c36e 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -146,3 +146,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
+obj-$(CONFIG_PGHOT) += pghot.o
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7712d887b696..c2a8e5309417 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1401,6 +1401,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
 static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
 #endif
 
+#ifdef CONFIG_PGHOT
+static void pgdat_init_kmigrated(struct pglist_data *pgdat)
+{
+	init_waitqueue_head(&pgdat->kmigrated_wait);
+}
+#else
+static inline void pgdat_init_kmigrated(struct pglist_data *pgdat) {}
+#endif
+
 static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 {
 	int i;
@@ -1410,6 +1419,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
+	pgdat_init_kmigrated(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
diff --git a/mm/pghot-debug.c b/mm/pghot-debug.c
new file mode 100644
index 000000000000..b6bee0f32389
--- /dev/null
+++ b/mm/pghot-debug.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot tunables in debugfs
+ */
+#include <linux/debugfs.h>
+
+static struct dentry *debugfs_pghot;
+
+static ssize_t pghot_freq_th_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int freq;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 10, &freq))
+		return -EINVAL;
+
+	if (!freq || freq > PGHOT_FREQ_MAX)
+		return -EINVAL;
+
+	pghot_freq_threshold = freq;
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_freq_th_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", pghot_freq_threshold);
+	return 0;
+}
+
+static int pghot_freq_th_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_freq_th_show, NULL);
+}
+
+static const struct file_operations pghot_freq_th_fops = {
+	.open		= pghot_freq_th_open,
+	.write		= pghot_freq_th_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static ssize_t pghot_target_nid_write(struct file *filp, const char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int nid;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 10, &nid))
+		return -EINVAL;
+
+	if (nid > PGHOT_NID_MAX || !node_online(nid) || !node_is_toptier(nid))
+		return -EINVAL;
+	pghot_target_nid = nid;
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_target_nid_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", pghot_target_nid);
+	return 0;
+}
+
+static int pghot_target_nid_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_target_nid_show, NULL);
+}
+
+static const struct file_operations pghot_target_nid_fops = {
+	.open		= pghot_target_nid_open,
+	.write		= pghot_target_nid_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static void pghot_src_enabled_update(unsigned int enabled)
+{
+	unsigned int changed = pghot_src_enabled ^ enabled;
+
+	if (changed & PGHOT_HWHINTS_ENABLED) {
+		if (enabled & PGHOT_HWHINTS_ENABLED)
+			static_branch_enable(&pghot_src_hwhints);
+		else
+			static_branch_disable(&pghot_src_hwhints);
+	}
+
+	if (changed & PGHOT_PGTSCAN_ENABLED) {
+		if (enabled & PGHOT_PGTSCAN_ENABLED)
+			static_branch_enable(&pghot_src_pghtscans);
+		else
+			static_branch_disable(&pghot_src_pghtscans);
+	}
+
+	if (changed & PGHOT_HINTFAULT_ENABLED) {
+		if (enabled & PGHOT_HINTFAULT_ENABLED)
+			static_branch_enable(&pghot_src_hintfaults);
+		else
+			static_branch_disable(&pghot_src_hintfaults);
+	}
+}
+
+static ssize_t pghot_src_enabled_write(struct file *filp, const char __user *ubuf,
+					   size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int enabled;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 0, &enabled))
+		return -EINVAL;
+
+	if (enabled & ~PGHOT_SRC_ENABLED_MASK)
+		return -EINVAL;
+
+	pghot_src_enabled_update(enabled);
+	pghot_src_enabled = enabled;
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_src_enabled_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", pghot_src_enabled);
+	return 0;
+}
+
+static int pghot_src_enabled_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_src_enabled_show, NULL);
+}
+
+static const struct file_operations pghot_src_enabled_fops = {
+	.open		= pghot_src_enabled_open,
+	.write		= pghot_src_enabled_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static void pghot_debug_init(void)
+{
+	debugfs_pghot = debugfs_create_dir("pghot", NULL);
+	debugfs_create_file("enabled_sources", 0644, debugfs_pghot, NULL,
+			    &pghot_src_enabled_fops);
+	debugfs_create_file("target_nid", 0644, debugfs_pghot, NULL,
+			    &pghot_target_nid_fops);
+	debugfs_create_file("freq_threshold", 0644, debugfs_pghot, NULL,
+			    &pghot_freq_th_fops);
+	debugfs_create_u32("kmigrated_sleep_ms", 0644, debugfs_pghot,
+			    &kmigrated_sleep_ms);
+	debugfs_create_u32("kmigrated_batch_nr", 0644, debugfs_pghot,
+			    &kmigrated_batch_nr);
+}
diff --git a/mm/pghot.c b/mm/pghot.c
new file mode 100644
index 000000000000..a3f52d4e8750
--- /dev/null
+++ b/mm/pghot.c
@@ -0,0 +1,402 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Maintains information about hot pages from slower tier nodes and
+ * promotes them.
+ *
+ * Per-PFN hotness information is stored for lower tier nodes in
+ * mem_section. An unsigned long variable is used to store the
+ * frequency of access, last access time and the nid to which the
+ * page needs to be migrated.
+ *
+ * A kernel thread named kmigrated is provided to migrate or promote
+ * the hot pages. kmigrated runs for each lower tier node. It iterates
+ * over the node's PFNs and  migrates pages marked for migration into
+ * their targeted nodes.
+ */
+#include <linux/mm.h>
+#include <linux/migrate.h>
+#include <linux/memory-tiers.h>
+#include <linux/cpuhotplug.h>
+#include <linux/pghot.h>
+
+static unsigned int pghot_target_nid = PGHOT_DEFAULT_NODE;
+static unsigned int pghot_src_enabled;
+static unsigned int pghot_freq_threshold = PGHOT_DEFAULT_FREQ_THRESHOLD;
+static unsigned int kmigrated_sleep_ms = KMIGRATED_DEFAULT_SLEEP_MS;
+static unsigned int kmigrated_batch_nr = KMIGRATED_DEFAULT_BATCH_NR;
+
+static unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
+
+static DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
+static DEFINE_STATIC_KEY_FALSE(pghot_src_pghtscans);
+static DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+
+#include "pghot-debug.c"
+
+#ifdef CONFIG_SYSCTL
+static const struct ctl_table pghot_sysctls[] = {
+	{
+		.procname       = "pghot_promote_freq_window_ms",
+		.data           = &sysctl_pghot_freq_window,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+	},
+};
+#endif
+
+static bool kmigrated_started __ro_after_init;
+
+/**
+ *
+ * pghot_record_access - Record page accesses from lower tier memory
+ * for the purpose of tracking page hotness and subsequent promotion.
+ *
+ * @pfn - PFN of the page
+ * @nid - Target NID to were the page needs to be migrated
+ * @src - The identifier of the sub-system that reports the access
+ * @now - Access time in jiffies
+ *
+ * Updates the NID, frequency and time of access and marks the page as
+ * ready for migration if the frequency crosses a threshold. The pages
+ * marked for migration are migrated by kmigrated kernel thread.
+ *
+ * Return: 0 on success and -EAGAIN on failure to record the access.
+ */
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	unsigned long *phi, *hot_map, old_hotness, hotness;
+	unsigned long time = now & PGHOT_TIME_MASK;
+	unsigned long old_nid, old_freq, old_time;
+	bool new_window = false;
+	struct mem_section *ms;
+	struct folio *folio;
+	struct page *page;
+	unsigned long freq;
+
+	if (!kmigrated_started)
+		return -EINVAL;
+
+	if (nid >= PGHOT_NID_MAX)
+		return -EINVAL;
+
+	switch (src) {
+	case PGHOT_HW_HINTS:
+		if (!static_branch_likely(&pghot_src_hwhints))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_HWHINTS);
+		break;
+	case PGHOT_PGTABLE_SCAN:
+		if (!static_branch_likely(&pghot_src_pghtscans))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_PGTSCANS);
+		break;
+	case PGHOT_HINT_FAULT:
+		if (!static_branch_likely(&pghot_src_hintfaults))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_HINTFAULTS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Record only accesses from lower tiers.
+	 */
+	if (node_is_toptier(pfn_to_nid(pfn)))
+		return 0;
+
+	/*
+	 * Reject the non-migratable pages right away.
+	 */
+	page = pfn_to_online_page(pfn);
+	if (!page || is_zone_device_page(page))
+		return 0;
+
+	folio = page_folio(page);
+	if (!folio_test_lru(folio))
+		return 0;
+
+	/* Get the hotness slot corresponding to the 1st PFN of the folio */
+	pfn = folio_pfn(folio);
+	ms = __pfn_to_section(pfn);
+	if (!ms)
+		return -EINVAL;
+	hot_map = (unsigned long *)(((unsigned long)(ms->hot_map)) & ~PGHOT_SECTION_HOT_MASK);
+	phi = &hot_map[pfn % PAGES_PER_SECTION];
+
+	count_vm_event(PGHOT_RECORDED_ACCESSES);
+	/*
+	 * Update the hotness parameters.
+	 */
+	old_hotness = READ_ONCE(*phi);
+	do {
+		hotness = old_hotness;
+		old_nid = (hotness >> PGHOT_NID_SHIFT) & PGHOT_NID_MASK;
+		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+
+		if (((time - old_time) > msecs_to_jiffies(sysctl_pghot_freq_window))
+		    || (nid != NUMA_NO_NODE && old_nid != nid))
+			new_window = true;
+
+		if (new_window)
+			freq = 1;
+		else if (old_freq < PGHOT_FREQ_MAX)
+			freq = old_freq + 1;
+		nid = (nid == NUMA_NO_NODE) ? pghot_target_nid : nid;
+
+		hotness &= ~(PGHOT_NID_MASK << PGHOT_NID_SHIFT);
+		hotness &= ~(PGHOT_FREQ_MASK << PGHOT_FREQ_SHIFT);
+		hotness &= ~(PGHOT_TIME_MASK << PGHOT_TIME_SHIFT);
+
+		hotness |= (nid & PGHOT_NID_MASK) << PGHOT_NID_SHIFT;
+		hotness |= (freq & PGHOT_FREQ_MASK) << PGHOT_FREQ_SHIFT;
+		hotness |= (time & PGHOT_TIME_MASK) << PGHOT_TIME_SHIFT;
+
+		if (freq >= pghot_freq_threshold)
+			set_bit(PGHOT_MIGRATE_READY, &hotness);
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+
+	if (test_bit(PGHOT_MIGRATE_READY, &hotness)) {
+		set_bit(PGHOT_SECTION_HOT_BIT, ms->hot_map);
+		set_bit(PGDAT_KMIGRATED_ACTIVATE, &page_pgdat(page)->flags);
+	}
+	return 0;
+}
+
+static int pghot_get_hotness(unsigned long pfn, unsigned long *nid, unsigned long *freq,
+				    unsigned long *time)
+{
+	unsigned long *phi, old_hotness, hotness;
+	struct mem_section *ms;
+
+	ms = __pfn_to_section(pfn);
+	if (!ms)
+		return -EINVAL;
+
+	phi = &ms->hot_map[pfn % PAGES_PER_SECTION];
+	if (!test_and_clear_bit(PGHOT_MIGRATE_READY, phi))
+		return -EINVAL;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		hotness = old_hotness;
+		*nid = (hotness >> PGHOT_NID_SHIFT) & PGHOT_NID_MASK;
+		*freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		*time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+		hotness = 0;
+
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+	return 0;
+}
+
+/*
+ * Walks the PFNs of the zone, isolates and migrates them in batches.
+ */
+static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
+				int src_nid)
+{
+	int cur_nid = NUMA_NO_NODE;
+	LIST_HEAD(migrate_list);
+	int batch_count = 0;
+	struct folio *folio;
+	struct page *page;
+	unsigned long pfn;
+
+	pfn = start_pfn;
+	do {
+		unsigned long nid = NUMA_NO_NODE, freq = 0, time = 0, nr = 1;
+
+		if (!pfn_valid(pfn))
+			goto out_next;
+
+		page = pfn_to_online_page(pfn);
+		if (!page)
+			goto out_next;
+
+		folio = page_folio(page);
+		nr = folio_nr_pages(folio);
+		if (folio_nid(folio) != src_nid)
+			goto out_next;
+
+		if (!folio_test_lru(folio))
+			goto out_next;
+
+		if (pghot_get_hotness(pfn, &nid, &freq, &time))
+			goto out_next;
+
+		if (nid == NUMA_NO_NODE)
+			goto out_next;
+
+		if (folio_nid(folio) == nid)
+			goto out_next;
+
+		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
+			goto out_next;
+
+		if (cur_nid != NUMA_NO_NODE)
+			cur_nid = nid;
+
+		if (++batch_count >= kmigrated_batch_nr || cur_nid != nid) {
+			migrate_misplaced_folios_batch(&migrate_list, cur_nid);
+			cur_nid = nid;
+			batch_count = 0;
+			cond_resched();
+		}
+		list_add(&folio->lru, &migrate_list);
+out_next:
+		pfn += nr;
+	} while (pfn < end_pfn);
+	if (!list_empty(&migrate_list))
+		migrate_misplaced_folios_batch(&migrate_list, cur_nid);
+}
+
+static void kmigrated_do_work(pg_data_t *pgdat)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid;
+
+	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+	/* s_begin = first_present_section_nr(); */
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		start_pfn = section_nr_to_pfn(section_nr);
+		ms = __nr_to_section(section_nr);
+
+		if (!pfn_valid(start_pfn))
+			continue;
+
+		nid = pfn_to_nid(start_pfn);
+		if (node_is_toptier(nid) || nid != pgdat->node_id)
+			continue;
+
+		if (!test_and_clear_bit(PGHOT_SECTION_HOT_BIT, ms->hot_map))
+			continue;
+
+		kmigrated_walk_zone(start_pfn, start_pfn + PAGES_PER_SECTION,
+				    pgdat->node_id);
+	}
+}
+
+static inline bool kmigrated_work_requested(pg_data_t *pgdat)
+{
+	return test_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+}
+
+/*
+ * Per-node kthread that iterates over its PFNs and migrates the
+ * pages that have been marked for migration.
+ */
+static int kmigrated(void *p)
+{
+	long timeout = msecs_to_jiffies(kmigrated_sleep_ms);
+	pg_data_t *pgdat = p;
+
+	while (!kthread_should_stop()) {
+		if (wait_event_timeout(pgdat->kmigrated_wait, kmigrated_work_requested(pgdat),
+				       timeout))
+			kmigrated_do_work(pgdat);
+	}
+	return 0;
+}
+
+static int kmigrated_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret;
+
+	if (node_is_toptier(nid))
+		return 0;
+
+	if (!pgdat->kmigrated) {
+		pgdat->kmigrated = kthread_create_on_node(kmigrated, pgdat, nid,
+							  "kmigrated%d", nid);
+		if (IS_ERR(pgdat->kmigrated)) {
+			ret = PTR_ERR(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+			pr_err("Failed to start kmigrated%d, ret %d\n", nid, ret);
+			return ret;
+		}
+		pr_info("pghot: Started kmigrated thread for node %d\n", nid);
+	}
+	wake_up_process(pgdat->kmigrated);
+	return 0;
+}
+
+static void pghot_free_hot_map(void)
+{
+	unsigned long section_nr, s_begin;
+	struct mem_section *ms;
+
+	/* s_begin = first_present_section_nr(); */
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		kfree(ms->hot_map);
+	}
+}
+
+static int pghot_alloc_hot_map(void)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid;
+
+	/* s_begin = first_present_section_nr(); */
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		start_pfn = section_nr_to_pfn(section_nr);
+		nid = pfn_to_nid(start_pfn);
+
+		if (node_is_toptier(nid) || !pfn_valid(start_pfn))
+			continue;
+
+		ms->hot_map = kcalloc_node(PAGES_PER_SECTION, sizeof(*ms->hot_map), GFP_KERNEL,
+					   nid);
+		if (!ms->hot_map)
+			goto out_free_hot_map;
+	}
+	return 0;
+
+out_free_hot_map:
+	pghot_free_hot_map();
+	return -ENOMEM;
+}
+
+static int __init pghot_init(void)
+{
+	pg_data_t *pgdat;
+	int nid, ret;
+
+	ret = pghot_alloc_hot_map();
+	if (ret)
+		return ret;
+
+	for_each_node_state(nid, N_MEMORY) {
+		ret = kmigrated_run(nid);
+		if (ret)
+			goto out_stop_kthread;
+	}
+	register_sysctl_init("vm", pghot_sysctls);
+	pghot_debug_init();
+
+	kmigrated_started = true;
+	return 0;
+
+out_stop_kthread:
+	for_each_node_state(nid, N_MEMORY) {
+		pgdat = NODE_DATA(nid);
+		if (pgdat->kmigrated) {
+			kthread_stop(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+		}
+	}
+	pghot_free_hot_map();
+	return ret;
+}
+
+late_initcall_sync(pghot_init)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb09c032eecf..10745e498e3a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1496,6 +1496,12 @@ const char * const vmstat_text[] = {
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
 #endif
+#ifdef CONFIG_PGHOT
+	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
+	[I(PGHOT_RECORD_HWHINTS)]		= "pghot_recorded_hwhints",
+	[I(PGHOT_RECORD_PGTSCANS)]		= "pghot_recorded_pgtscans",
+	[I(PGHOT_RECORD_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+#endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


