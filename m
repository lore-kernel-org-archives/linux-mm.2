Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBB8C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7BF66B00C2; Sun, 18 Jan 2026 14:31:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D916B00C3; Sun, 18 Jan 2026 14:31:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D359C6B00C4; Sun, 18 Jan 2026 14:31:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C29606B00C2
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:31:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90055D209E
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:31:20 +0000 (UTC)
X-FDA: 84346078320.23.1248284
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 98C00A0011
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:31:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=DAq2ZTvy;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.42 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768764677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhKndgB+2YCEncz/d989f3/rBWwS27yqGOzKom4Suj0=;
	b=8OqacFvhh61OHLfNL1GQ48YNk2JYca3CN8POoXueNABMlAJqiTsnz4RI5lI8nbqFLYYLKm
	VN6G+8XDMOIIYHGtbu9Rk0XjfwlAZD2OuKs4CieAENxilcJ1JbidZR311SvsSoxDauZYpN
	F8xD5fE5xWuUBqbQTWe1rIBR+9eDrAs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=DAq2ZTvy;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.42 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768764677; a=rsa-sha256;
	cv=pass;
	b=2ihxDDjW8DTd0J1VlsM/Y1w8E+dy9wSOVVddqkTHnDnKunh24zfUG64TrZlwzXBboFuQ5v
	5iINYjHcj5nAs/eyCqlMYtEUal0QBdYLNozhObbwfXduiPkAypKFXeK+ZByCEBPD8pzVWy
	VxYq8q/OrpYQHNb4RHMJ/I+QRBrH3bs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZ/11MQ70d1udlqaUkueGadPNKVapo3RrRu1xm493PNluOi1ia8vNYU9fe6Pe9lGDJb702Id/S7OpjR5DYvi4bOwskfTnrfWTsaG7zGUTXKBbnMrKSbZEu7r01oDQAU9Ch6c+cgIeJyMxpwDuZ0Tq3z9XHfpCdKJI4xI2l4SVWjOcnSpCUBvrRGnGtio6lzAK/pCabjlJbuGos3RHxxsBr++snWv93EDJVWYfiYgG9p4Udar/WXODm6RSZ7snoEfmbHoWTTfSNT2Itk99o7cSURjvgflf/K9XFBx056Xfvl+blTQuis/xgAXrS+kaoE9Y7YECNSFXjpHmGW1v+z9IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhKndgB+2YCEncz/d989f3/rBWwS27yqGOzKom4Suj0=;
 b=CESFSdJA8FSOaQR/TlO2lGFqDC0GgprT8zpwgWaENybzCVcXMO4xFAvnatgryBp0xt8aP9/dCBq7HoSdAOkNdJN+wR0Ob1YivEVQPc3AgIuemrKoiYxnf91KJu0byDTR2NMasyBiQlJfzOChQcs6KRm3giF7w0KYpYBXMcxuulbgvCZtn5hLh5mnqw5ZfJFnfaa/cMTUUaFM/CjsWYNjwHQwvhAQeMJePDnga3uHlnYeRYkV2gyDJYmd2hCSXZSOjOrjRBq5MmfjtmWgaWH2t8rK+v96Akxk70L2ajrBJ7alMP0aAEJpuyIRH6Q5bSPUN/hlR62v/7NY/TCpzLrDSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhKndgB+2YCEncz/d989f3/rBWwS27yqGOzKom4Suj0=;
 b=DAq2ZTvyh4Kln8T1PfAXtrLjFogP910cAvrZykrjxMJ4bB9Y4KwA2/06e0rgZ4J4OY+gRmQpbI52M/c9y0PugnXxL+z09tR/ociAw+AZCCdcYjl8CWQ/5SmZbcIIzolW5b+eJusxl/exBODmGwAIPwmBjpN4OQgo3C3DV+255ik=
Received: from DS7PR03CA0235.namprd03.prod.outlook.com (2603:10b6:5:3ba::30)
 by CH3PR12MB8904.namprd12.prod.outlook.com (2603:10b6:610:167::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Sun, 18 Jan
 2026 19:31:12 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:5:3ba:cafe::ce) by DS7PR03CA0235.outlook.office365.com
 (2603:10b6:5:3ba::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.11 via Frontend Transport; Sun,
 18 Jan 2026 19:30:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Sun, 18 Jan 2026 19:31:11 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 18 Jan
 2026 13:31:07 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>, Wei Yang
	<richard.weiyang@gmail.com>, Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control static
Date: Sun, 18 Jan 2026 19:23:01 +0000
Message-ID: <20260118192253.9263-14-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260118192253.9263-4-shivankg@amd.com>
References: <20260118192253.9263-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|CH3PR12MB8904:EE_
X-MS-Office365-Filtering-Correlation-Id: 63fd5d04-11db-45b3-4b07-08de56c82357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k8T9gjlXjXTQIyCbp7/JonWnq+NiKY0IqBoqE41uq7J/sOho0rANycyJj7zo?=
 =?us-ascii?Q?GG7DjzTILM+BN32qLOxaGb+y+UEfCdZEVz4xzTAZpagyoF0SAChZxDpfru+5?=
 =?us-ascii?Q?2vsvz2wmdVxPEsadFNFKfyfgomaygrMZbeV44z+HZJvcf0Nf7eXbZVQbRoHj?=
 =?us-ascii?Q?0CAzkf+wLwo2oHWGQyxwtK28agL27jQIMHtaaFcchWcEjAH+0Ei5A2qnXRtO?=
 =?us-ascii?Q?BJKiMSZZlQ8iSsZNGQeVmzKMSFbeTuIKae8DYw54RFEerSkkYgWy9xXxyYni?=
 =?us-ascii?Q?3ZcMoF9lqWs2s8Nxu47KlZ4Pr7LSwDIpCpFZoNBh++R7xcZ8RX4UW1w7u1Uc?=
 =?us-ascii?Q?e1jgCaPWVW59ge++DD3GetD+F9kbkvom67myQ+ZqkCxDJtp3BcT/zPAQWYps?=
 =?us-ascii?Q?HdX0zrmmi3vsynVbxpz/L4Ndg3OLDEqSdzcXbfZ3X1huvYSqYDVpwhPz+EIB?=
 =?us-ascii?Q?ZM2HVU1UIbtl6aoHyxjPrrrnzZ6YmyucEO3Ia8+Xx7AODs1IDiB1X/ru7I9/?=
 =?us-ascii?Q?cFHSl3jpgdA2capR3VVEpG40zWv83Ea7GqmObeLKiUePOisdN1j4a2h5LZNo?=
 =?us-ascii?Q?4EOJUfgBGdvNpnNj0fmNGxX9yJn8tzwdfaKGVlOzWGJx2bqbIq3s0iojdAlB?=
 =?us-ascii?Q?U7v4FWSZBs8rVGDSS5g1+3Prl6JmazPR3eCT1YII6iTD5d3OlC6+nHHQ/Feg?=
 =?us-ascii?Q?uo6ENmA5+xg4ZXtnJdBV2FZyUj9RBKEJsKxi4OI6iJgeLPX7y0Tl5TfvDQ1b?=
 =?us-ascii?Q?WgGgCdHdj99ZdScPrTcNScFkwdk9t6YuLmjrYFA2wNPtRkifqhDcHDHvFnYs?=
 =?us-ascii?Q?amJQ2B6bOExbr93Oa7ho2OCSqeGvg4tp5IEWkwY5YkoS0ZuBTtIMC48zY3rh?=
 =?us-ascii?Q?6in5ovM4gNRWx+imJwhFoSme7JiTGBaCMDfEcymbpVV9MMZo1Nmxbb4RB4xo?=
 =?us-ascii?Q?EtwYETgGJH8yNtXh+9+C/tvdPUoYuYn7g1ZVBXCCxyJRnT+tlcFOPJLKkRjz?=
 =?us-ascii?Q?a3yP65L6+GFss+lpNU1fteSdsFTFLZ+QJcI3IkIkipKZBEwEnaLt57fAB0vK?=
 =?us-ascii?Q?el4s6D6TtgrQesWzbQZr/WDS//yuCtybRnT7I+DHKsaDLYF2L46hkzh2hez3?=
 =?us-ascii?Q?27YMEAYzAA9x1cj73V+gZwPu+J5516u0V74EcFscJZHsGE/AB0WWQUMTjr1j?=
 =?us-ascii?Q?RUhKD7ZL2R0zOt0d19mv5jQKWpL+aoYaHATFyQW7A1kK/ZK+OAkc2VsJ9e+8?=
 =?us-ascii?Q?zbdyyPR0tLGGV1Gr3j21xv8ls0lA9L8P5U0q3/n2RvOGzz1LpQgMG2t9b8XV?=
 =?us-ascii?Q?s8Fl140bDZxuLnqRwcYhgKkR5gOyaUULeIJ/nEiFpH8Hly5XptgsmmZSMT46?=
 =?us-ascii?Q?TD4B98534M0srrf94YiU2abBfzC5iJDBP4DPj4JUeggEpaowvcearv+TODTU?=
 =?us-ascii?Q?hGF3kKwvmC7/gO7+b6Fo3bZfJoaHktX27WqZZmvec+uqdZy1WFILffjV9ftk?=
 =?us-ascii?Q?dag2/OgYRfZg29Idq2LrTkyat3yiZm4OHYjX+9TlPHbJfoRuzTQv3HkDTcXA?=
 =?us-ascii?Q?n4a1pVxMskHgZ784AXci29TmSs/ZIVa1ZkfX08CRySoAXcOtBwL00IY7ayFa?=
 =?us-ascii?Q?q1DLkGGyxAX8vaqwffwSVWWg7PrmZbOhMUdOrahiqxNGZ2xhvJk2qmYX2K7b?=
 =?us-ascii?Q?rnNTug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:31:11.8663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63fd5d04-11db-45b3-4b07-08de56c82357
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8904
X-Rspam-User: 
X-Stat-Signature: a6uq3hrhyecs8i6f5suu9fhn4bhziuc1
X-Rspamd-Queue-Id: 98C00A0011
X-Rspamd-Server: rspam04
X-HE-Tag: 1768764677-739223
X-HE-Meta: U2FsdGVkX1/TP0YLuH3aNo+Z3/c4zWf0ijMX5J3hMz/LTEwHqzfBB+imJiB/fHQ+QyMNFqpeuGbkRAinJUysV7N8/iEvLaib7apUOEaElCyzGN3N1owvos+JMWQ72J3ChgDxg5Q9jt8hGYBtSO6g0V9j1S/FlVRJ38BJM6qnXDtBeDNIxDEc/5kd+C5R97gAXVJjPIf3EJ70LOxsxO+yzmCwpVnX64trSWcPWVV3FfTUiYRN+WdSh63JxCQV9xXU2jYaDZklkvDOhyIcC1ZtMlbKr306VYwfhhoGY+1YJtbyeNCQwbuuTgLv8SPeRhPH/e/wbS+iA2vu177/RTfKdcZore/fIZ5PYbVv/wLDSDnm/D15gJ4FBo7auZ9XJcukhMgrvODGF5gz+t+lhMLgiGGUg7T5wpnoOuYBeENypmjz6YbZbDrYUHLRRuUlw99fDx2sw27WnL2H7/Avg3aEGhee8hMqfX313NKPL/unP1QNScE4mRvhGubZ91cGovzJ7HYw0bgu/+Sw0UNnKu2Pc5+DJMbNV8zlahz3M9rm1uQJ5L0bbSgx8eLNwRwmadqjobFCwKLu5mk4ackYMGYhof/GLIQS7sKcIix6SEsuckSla7E5/zvSjppm3wGBTqPjLIFhViI04yWNs8RUZmsym6z+QwUsFb+FxnXWEp4EKx8plDYdY0ZPbf9z/wfrISzAGoR6Wy9I1yajvfNuHUYURPhX6gg7QHzaROfkSl7gaKDr0r2kmoEtYayfPEeHaQtiJxPmvMGGRBPK/kSox9zuUgX9/gEXj5PJNgYCpPruesEyUjud7H5koK0sPYjo/VLO91koU+Fs86ElZ3l3ubl4NDjKl76LQ0ImnAMlRkq4skJfX584B8FpusU6MfWge2+hY7x+PfxcZhwz3N22kElgSKgy1mlZ0JOX/9dkNvFqvMWxBd+dhZw/q7Kyj5DWcBKjJvpXBbltCdVfF7O/bdp
 3n42K/fd
 UQcTlSyreaiOmQa6pVy0wjUChjdVp2+/A4pfIwFTct+9TKyGH799Eo50MO86YA94bgqrNyuWgeaULy/VuNYHZf6Of5xBohfnE4H2m6BaJ1neKT99WlQ6ElauUbhBmiW/oYeI1WTrs0EOZtr9fJfz3elq2n22OAEVbrgzR/G1nFuy2nZV6+sPu19cWu4IYSNWiSxr3NqnUf9/JmpA53kghDJ683lAc79Jq4Q18GcO4wkFlT8MUDFhVDSMS4X5dLsMGac+FxxDnlZkFvokK9B3PJX4upnlR+8JdiVKhqTTjvcVhlvPp2yyN47CTuOhZWZwdRurSsOwX/oFwM6zEWWIM8+LWuGDh/GKg1cVZ7P6GS7iooSYJRobPzFSFKRYo22laxv9p2wYI/7QPoPmkqEIarOtWzoyYSGYbXz3oD5QsV1QlqSQ3x6yNOIjPQCu7hU/tyy6zdIq6KtW+fuiTI42ekRo7HCRdY+4iw+esirK7hERqu/9WCVOlLolb4n8VlSPsXdnYsOvWe+SOyZAPM7M+m1QQ3H+raMVykDlXaQ0EklD/SjB56TT42cZas+1Tx9ZxMEc+wDAr/7TJgnssKNj57Ws5P2RkBLDdecfqzyUSECoz/1iqCciEoCnndq3L29L9puO+kKVztk4VBDy9BpilL/l8H1KtCqEtbCYoD/I6x+wvjzgMNetJ2iTUsOXOwneBCwUf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The global variable 'khugepaged_collapse_control' is not used outside of
mm/khugepaged.c. Make it static to limit its scope.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1667abae6d8d..fba6aea5bea6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
+static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-- 
2.43.0


