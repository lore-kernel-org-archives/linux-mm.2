Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41EA5CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DCA28E0012; Tue, 23 Sep 2025 13:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D358E0001; Tue, 23 Sep 2025 13:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E6D8E0012; Tue, 23 Sep 2025 13:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67EA18E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:49:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00041C026E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:49 +0000 (UTC)
X-FDA: 83921252898.11.B79BED2
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012000.outbound.protection.outlook.com [40.107.200.0])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0298240002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hvIC9Hib;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.0 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758649787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySxMyb6AxP1VEu8p9pR2Cxm8wJ0Dj/H34gqdILOtxH0=;
	b=uMSqODvueB7UQq5gK06w89C6zyUBxUesAzoWdOsOZq9JoRQ4KE+uXBvpjc4vImk2Rx7cwK
	Dk5QaI/H7/PuUHuCeGU8lTIJ2bwII96YcYUzAJBx3x9cLB0pwmVem8GmxsDbr4bhVcDV4T
	npvLz25hXv8h1n4H2T7D/vU1B35ie+E=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hvIC9Hib;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.0 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758649787; a=rsa-sha256;
	cv=pass;
	b=S5LCPunStKdOpHrh75qeNpgKYacmvL7AmMlFELpWYSCCcigTbH/Yk0ZShP5GZBIeVIWOh5
	UTnLAnXxajfJwoSRXqbGjO1XSI4VFsOJ/g/S4EW28Phi97wR3ufk9ycvFjCsPaisviE1Ow
	GMe+cQO4wH5lYjl2sb6JCwgKqhdvtl4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QwJp/YkKdxFeI2hFtz9up6W98SLrDquAyqPH39cRwxLmSSjxcU3TSI1TB4IugvpYKkfzVGjKetnBlSDj15tZ1aOPsicJ9WsNkkhqDy//WHXHijDFisGoU6Chmq6z5c1PvfdK6rcf2ULEBEaMjRf+GlOxmD6oltNGu7JYIFSC2aXoarFtlT4ITMJ0GLajUSSd2h2mUd/xopCmJwuyKPXOnH5ra9x79g14w8lkK3hpR6lm17tp84CVTa+VFzmd/gcFFwB+iAAwd4O6T9KTh8u5IybKtyueg/UQnsKY+c98dyYM0GDt7kcUR4pa1pJnDmj4jG+guhIrX0SEoz8bBAjXCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySxMyb6AxP1VEu8p9pR2Cxm8wJ0Dj/H34gqdILOtxH0=;
 b=mURaNmf6otSl9hyskm0voSibCoMGsK4iRu8bIRQm4uTa6m3k8dWxso8+hQl+i1GEotNp8zJn4U3qo4LQoJlz1uS1pz9c9jd8+LTfDhjn4kO0kbAEawSv7Dv7PHkBK9ICyrkN87paOKpMOpZrZ+dfQDAUdTdue8pptaULcUGsm9SGyykEzYxGipq1DaXbY+ATVeB7P1lHUUXH1zSGHykGV3JwPYkPqYIP5gwM/SUy34xdleO5nyMd9IUelc/trHx3zmI6mK11pfZuavXBPE+y0vNJai04k2U+p9DvQE5OQ1TO0PwVz+n8ssZcMsT7c9ZakbFwPbu3lAfwyR/6oJUmOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySxMyb6AxP1VEu8p9pR2Cxm8wJ0Dj/H34gqdILOtxH0=;
 b=hvIC9HibVtJf0adTAY6x9yIsS2jD73MDc5Ej7TKbCMOHDPphYNGE9vBCXTWEc1qR6xl8MFWRrcobB6kO9hsmcHduQZvss0YN/U1fBV5hq4a1Qvq+m7uv9mSC19D4eiFoUdfDawYYdArE7zSArjf84NgC4tBZGl9BbjuEb2m5ZU0=
Received: from BL1PR13CA0269.namprd13.prod.outlook.com (2603:10b6:208:2ba::34)
 by CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:51::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Tue, 23 Sep
 2025 17:49:40 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:2ba:cafe::7e) by BL1PR13CA0269.outlook.office365.com
 (2603:10b6:208:2ba::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.9 via Frontend Transport; Tue,
 23 Sep 2025 17:49:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 17:49:39 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 23 Sep
 2025 10:49:22 -0700
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>
CC: <ziy@nvidia.com>, <willy@infradead.org>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<vkoul@kernel.org>, <lucas.demarchi@intel.com>, <rdunlap@infradead.org>,
	<jgg@ziepe.ca>, <kuba@kernel.org>, <justonli@chromium.org>,
	<ivecera@redhat.com>, <dave.jiang@intel.com>, <Jonathan.Cameron@huawei.com>,
	<dan.j.williams@intel.com>, <rientjes@google.com>,
	<Raghavendra.KodsaraThimmappa@amd.com>, <bharata@amd.com>,
	<shivankg@amd.com>, <alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>,
	<weixugc@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [RFC V3 7/9] dcbm: add dma core batch migrator for batch page offloading
Date: Tue, 23 Sep 2025 17:47:42 +0000
Message-ID: <20250923174752.35701-8-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923174752.35701-1-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 085cbdc6-0f45-4926-7eeb-08ddfac991d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3pbclC735Jkd5U9DCIAKodNSGrv9SfbjycCeOnmd4nJQUrZY7FmaLS9XZwzP?=
 =?us-ascii?Q?gRX+Ol7oxRSRXWE85jtxUJdJuMKNkgZpLpJUarjpER5MGK0zFyJhIjznpTiQ?=
 =?us-ascii?Q?0btR4PkBhVw6kGHBOZF5LEhb5NiLy8QgR0hhQhKDyRj6KJZOGGrD9fxvq7c3?=
 =?us-ascii?Q?hj+GG7r36Z81lz4pc+OUc3+BKmLP9e1dGN3jSS1zfcKYczTF/ZjMApjGwDHr?=
 =?us-ascii?Q?XWNHbhYfq8Aj7u6+o/TbBRWhN648CY/emGECN8MkOooGrZrMsSWcw05eX1U2?=
 =?us-ascii?Q?XqMoP7Dqi0BFURqna8XDCUaxSajrssym+a5D0+8FiEDdNVpKdfNsFE6i33h1?=
 =?us-ascii?Q?WQcJOVtDHEbtJ105gSFKuainpB1ZIRPq2GxqFMLwqouxkFraKR+VaCreJ2pX?=
 =?us-ascii?Q?316SgBSq3J6JRsA5WTOboH2ARELBD0anVL0hl59ALk5rNoGL2FHTubynvks3?=
 =?us-ascii?Q?zDabZbexqKmep1XoScEINPLhsO8df2NH4tQX2zBFSAEFOlXK2kkCSGKddX3B?=
 =?us-ascii?Q?qYvnxt7yPLs9MPUwlrZ+7aNsBD+xkHK6HxKFpL3d16vhOOizriWOg+KaQaNH?=
 =?us-ascii?Q?bV7S6OW4JmfpYtrn9wJUEeJTMhxEQCSa5apDTu8txpZBIaRVhAgBCGUSGzby?=
 =?us-ascii?Q?LZvw0ek5J1Q1MrXvyTEFCnOPCGbT3C4lFQeFARrgZYOk41RH+kQnffS/yfLZ?=
 =?us-ascii?Q?0zr5Qmgyma0zaJQM+jHJ5b+wc6FtpahtjCrSUaxOkg7FK/dbt6CTyd/KErSV?=
 =?us-ascii?Q?ivNOEdm9xQ2n2X0RX+3+KlEaYEBJAUNcb8Os4GtM+n5UlOnGlOaKiGKpCaQb?=
 =?us-ascii?Q?z9JsYExeNvVgFrU5sVQ/+R0AUrQBtdDIVBgvdS8OFKMnkJtbSqET5QftFaY1?=
 =?us-ascii?Q?KjaF1yzR5kE/xCNcuksRYc+AjCdkgQlk8EwSjE8wgZP97FY4TNnVp+s/Rm7Q?=
 =?us-ascii?Q?hUtIeHhZe9B9TZv378Tsf1ecM8g7lGk1k9gafSrzKwuYKSA5n5LT0xxfs15L?=
 =?us-ascii?Q?xBHydxfz29dfd+M4E7q4OQT5r5hu83t2FlpZSBYdTcyxnwz96CoM/PaEsO6F?=
 =?us-ascii?Q?XtNQawRuVBWF1Vu6utwLicmO4V4qpG2fQDBPVNjGd2DxpS79VXKb9mYhwpIe?=
 =?us-ascii?Q?po6+nf0dOnOy1N+HV5dmW2I1d6rOaq80gqhbDlXMx+K6MCcSgTyGNLUixxAJ?=
 =?us-ascii?Q?X9+KSdFxuD1mlBM6+pw1mHPkqWlOenNBc3mw4q//SuEqIdvMttrzE5nvmzyO?=
 =?us-ascii?Q?J7/1T47s+CBufWaQLtsdupmNYf3etiiKKl2TKnhZp7eILi70T8TgbqCVFUeT?=
 =?us-ascii?Q?bws1cUQAfXWgVpMP4DfIisNTltvXONud9XxHx9M3iHxyBQ62kQ9+SRYkdFa0?=
 =?us-ascii?Q?B62XrDKQgV7BI2qGzgLM2mhebVJniURXHgdpO6xwntAONHGv4X3SIs7uVDkM?=
 =?us-ascii?Q?FytYJ6G0GHqtm2RikZ9ScObLscqURbQf/VSjpaTUux++yYclLndLn3eze5wo?=
 =?us-ascii?Q?oVBlR7ydYbqQ4rYiv2f5ID8i6MSD85o6AxOa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 17:49:39.8360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 085cbdc6-0f45-4926-7eeb-08ddfac991d9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097
X-Stat-Signature: zf1u4kxyrd8fr8i9p7mt8aaz7p6rsb7b
X-Rspam-User: 
X-Rspamd-Queue-Id: 0298240002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758649786-476617
X-HE-Meta: U2FsdGVkX1/P6f0RW/6gQ4gkXoLOpdkrkjDqjewNF4ijGVeSMbJ34r2doIK7ZY5obrLwpgnUqmX7iufMGSL/JQmBA7mFMIYqAYW0XT44542LHfAmL+44IQLg4lxYjuytwXNKgE0c+MSoNY+BnOJPqIbXe59yYq/rxe6fnj3PGi3tPWsORGM+IrhBx7pdCOM7mZrRBdJ8Yly7FRlK2Tmmt4ZUdV4cUU7QIAYKAthZETOQcwTHVAxiAvqBpxhLFbn1jeTYw54q1XY5opONMwLWRiOjw3pVeF+tJQiylFQvPDNoSnSPblETvC25wWKiSgeu9N+LA7l+gxG7gC77zBeed1D9Ww0T7+2VwVgRkGFZT8kqKQuORMRSjfI71HAHG0OovVaPpD1SHHxduhAH4tiY8Lp5mp9PAz7woySiax7ZSZbz01HjYnt9gvyH6tjEMquc2iW9ww1tk6dVKj004GTv51UYbJRCZvKxMetJy5rutWd8+h5z8owqWunfTDLcjdgYXxGz9uHitKSdknBLu1XzalxloKSFKLpWZBOL6X6dFcUZcy4Q9KuffINWdxbLKKRGmNZlO1revPgldbshASY30YonySZyt/RnJYVVGuGiUo/LvrmLig/0L3FOIrPIhPSsnM5XNF+w7lqTYUnxqm4zeTFkjMMTqYaJKuXNQUa07/VRbyYK/dIfidYFJuVdQKXAQUatlQmiYMs6G8ezxzPxIbjiX9+ris58581T4x8w8pHUCcmhKFyDMQaPD3QlIN+DDJ7xrXhy+s/3gV2ZvDoKdGGGjkiUqGGfeBIDv5hxEDHL8oARLO4hn9yyYm22zN4GAE9NGYVWHZXDczew+62irfR2YF0+1tikt6CkiZ32Jf+1y/rIy2aUb6FiP2zfiDQwnCj64Z6zVpaBIGnMyNdDIp6q12+YibJvSXgzZTbRPkpy2UblkpgZQaFUtjEkOy4pz3zpIj+n5MhRoAPb/cr
 dh+DIt+H
 rvYjcGHoKsnI7fCeC1WWSKaIWrjLqntmUL/S5EtSrcUJTdQV1gDtaMRzR5C/4n1hfWujc0/VqQ4vbOcZVacuBaBRrQWmraeZFOQGF/dmmF36qYmW5gBc20+aJS4+/uqae8HU/vfowRRcCPUkZzAhUYJ1K4jEHw9AOOIOGkj//Ab7rINuRicsa2oPfA4MFd1CTRh7wNUDgcc1aOMGlZKTJJL3QT6cL0gm3EPf92BD/T5t/P17CMu7T2prLjVi+zIzF4V7x3foreicxiiEwVYB2FUXAKhj7hENP6erISJ0Eyp9m9vmvmCKBDX70DTPyJBRgYEIDCi0xbYo8B+vKv7UC+PfZNjm8vKsJulTZo82Bd1FIpTq+GzKdB02cUShglMmdFLKtQQ5m+Tg/bem4L4j0a1P6+N0GhzWkrrjO5LDAn8UovHtaUOfhrkjQYWOU8zOFZ21hehsqGKBM43u6TMxx2Wb6IpLkdXcNUcgf9iZ5QCY9yBpOwJawtELDuu5oDT3oO7xt3fcLVmw0mQlMnvWEBoJtDgNhxvWVaz/zSKxEi4VBqvXeeOvyYpYHnsWTJiNlOEzKAXbIiezp684oW/WkfMQhyIbH+w2BsuUK+iM8J3POgJMdWCOL8/OkETa43N/LvRdcCY9Ng4uAVXDISzBFOiZL9Ylj5ELZn/yh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dcbm (DMA core batch migrator) provides a generic interface using
DMAEngine for end-to-end testing of the batch page migration offload
feature.

Enable DCBM offload:
echo 1 > /sys/kernel/dcbm/offloading
echo NR_DMA_CHAN_TO_USE > /sys/kernel/dcbm/nr_dma_chan

Disable DCBM offload:
echo 0 > /sys/kernel/dcbm/offloading

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 drivers/migoffcopy/Kconfig       |   8 +
 drivers/migoffcopy/Makefile      |   1 +
 drivers/migoffcopy/dcbm/Makefile |   1 +
 drivers/migoffcopy/dcbm/dcbm.c   | 415 +++++++++++++++++++++++++++++++
 4 files changed, 425 insertions(+)
 create mode 100644 drivers/migoffcopy/dcbm/Makefile
 create mode 100644 drivers/migoffcopy/dcbm/dcbm.c

diff --git a/drivers/migoffcopy/Kconfig b/drivers/migoffcopy/Kconfig
index e73698af3e72..c1b2eff7650d 100644
--- a/drivers/migoffcopy/Kconfig
+++ b/drivers/migoffcopy/Kconfig
@@ -6,4 +6,12 @@ config MTCOPY_CPU
          Interface MT COPY CPU driver for batch page migration
          offloading. Say Y if you want to try offloading with
          MultiThreaded CPU copy APIs.
+config DCBM_DMA
+       bool "DMA Core Batch Migrator"
+       depends on OFFC_MIGRATION && DMA_ENGINE
+       default n
+       help
+         Interface DMA driver for batch page migration offloading.
+         Say Y if you want to try offloading with DMAEngine APIs
+         based driver.
 
diff --git a/drivers/migoffcopy/Makefile b/drivers/migoffcopy/Makefile
index 0a3c356d67e6..dedc86ff54c1 100644
--- a/drivers/migoffcopy/Makefile
+++ b/drivers/migoffcopy/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_MTCOPY_CPU) += mtcopy/
+obj-$(CONFIG_DCBM_DMA)		+= dcbm/
diff --git a/drivers/migoffcopy/dcbm/Makefile b/drivers/migoffcopy/dcbm/Makefile
new file mode 100644
index 000000000000..56ba47cce0f1
--- /dev/null
+++ b/drivers/migoffcopy/dcbm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DCBM_DMA) += dcbm.o
diff --git a/drivers/migoffcopy/dcbm/dcbm.c b/drivers/migoffcopy/dcbm/dcbm.c
new file mode 100644
index 000000000000..87a58c0c3b9b
--- /dev/null
+++ b/drivers/migoffcopy/dcbm/dcbm.c
@@ -0,0 +1,415 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *
+ * DMA batch-offloading interface driver
+ *
+ * Copyright (C) 2024-25 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/migrate.h>
+#include <linux/migrate_offc.h>
+
+#define MAX_DMA_CHANNELS	16
+
+static bool offloading_enabled;
+static unsigned int nr_dma_channels = 1;
+static DEFINE_MUTEX(dcbm_mutex);
+
+struct dma_work {
+	struct dma_chan *chan;
+	struct completion done;
+	atomic_t pending;
+	struct sg_table *src_sgt;
+	struct sg_table *dst_sgt;
+	bool mapped;
+};
+
+static void dma_completion_callback(void *data)
+{
+	struct dma_work *work = data;
+
+	if (atomic_dec_and_test(&work->pending))
+		complete(&work->done);
+}
+
+static int setup_sg_tables(struct dma_work *work, struct list_head **src_pos,
+		struct list_head **dst_pos, int nr)
+{
+	struct scatterlist *sg_src, *sg_dst;
+	struct device *dev;
+	int i, ret;
+
+	work->src_sgt = kmalloc(sizeof(*work->src_sgt), GFP_KERNEL);
+	if (!work->src_sgt)
+		return -ENOMEM;
+	work->dst_sgt = kmalloc(sizeof(*work->dst_sgt), GFP_KERNEL);
+	if (!work->dst_sgt)
+		goto err_free_src;
+
+	ret = sg_alloc_table(work->src_sgt, nr, GFP_KERNEL);
+	if (ret)
+		goto err_free_dst;
+	ret = sg_alloc_table(work->dst_sgt, nr, GFP_KERNEL);
+	if (ret)
+		goto err_free_src_table;
+
+	sg_src = work->src_sgt->sgl;
+	sg_dst = work->dst_sgt->sgl;
+	for (i = 0; i < nr; i++) {
+		struct folio *src = list_entry(*src_pos, struct folio, lru);
+		struct folio *dst = list_entry(*dst_pos, struct folio, lru);
+
+		sg_set_folio(sg_src, src, folio_size(src), 0);
+		sg_set_folio(sg_dst, dst, folio_size(dst), 0);
+
+		*src_pos = (*src_pos)->next;
+		*dst_pos = (*dst_pos)->next;
+
+		if (i < nr - 1) {
+			sg_src = sg_next(sg_src);
+			sg_dst = sg_next(sg_dst);
+		}
+	}
+
+	dev = dmaengine_get_dma_device(work->chan);
+	if (!dev) {
+		ret = -ENODEV;
+		goto err_free_dst_table;
+	}
+	ret = dma_map_sgtable(dev, work->src_sgt, DMA_TO_DEVICE,
+			      DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+	if (ret)
+		goto err_free_dst_table;
+	ret = dma_map_sgtable(dev, work->dst_sgt, DMA_FROM_DEVICE,
+			      DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+	if (ret)
+		goto err_unmap_src;
+	/* Verify mapping produced same number of entries */
+	if (work->src_sgt->nents != work->dst_sgt->nents) {
+		pr_err("Mismatched SG entries after mapping: src=%d dst=%d\n",
+			work->src_sgt->nents, work->dst_sgt->nents);
+		ret = -EINVAL;
+		goto err_unmap_dst;
+	}
+	work->mapped = true;
+	return 0;
+
+err_unmap_dst:
+	dma_unmap_sgtable(dev, work->dst_sgt, DMA_FROM_DEVICE,
+			  DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+err_unmap_src:
+	dma_unmap_sgtable(dev, work->src_sgt, DMA_TO_DEVICE,
+			  DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+err_free_dst_table:
+	sg_free_table(work->dst_sgt);
+err_free_src_table:
+	sg_free_table(work->src_sgt);
+err_free_dst:
+	kfree(work->dst_sgt);
+	work->dst_sgt = NULL;
+err_free_src:
+	kfree(work->src_sgt);
+	work->src_sgt = NULL;
+	pr_err("DCBM: Failed to setup SG tables\n");
+	return ret;
+}
+
+static void cleanup_dma_work(struct dma_work *works, int actual_channels)
+{
+	struct device *dev;
+	int i;
+
+	if (!works)
+		return;
+
+	for (i = 0; i < actual_channels; i++) {
+		if (!works[i].chan)
+			continue;
+
+		dev = dmaengine_get_dma_device(works[i].chan);
+
+		/* Terminate any pending transfers */
+		if (atomic_read(&works[i].pending) > 0)
+			dmaengine_terminate_sync(works[i].chan);
+
+		if (dev && works[i].mapped) {
+			if (works[i].src_sgt) {
+				dma_unmap_sgtable(dev, works[i].src_sgt, DMA_TO_DEVICE,
+					DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+				sg_free_table(works[i].src_sgt);
+				kfree(works[i].src_sgt);
+			}
+			if (works[i].dst_sgt) {
+				dma_unmap_sgtable(dev, works[i].dst_sgt, DMA_FROM_DEVICE,
+					DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+				sg_free_table(works[i].dst_sgt);
+				kfree(works[i].dst_sgt);
+			}
+		}
+		dma_release_channel(works[i].chan);
+	}
+	kfree(works);
+}
+
+static int submit_dma_transfers(struct dma_work *work)
+{
+	struct scatterlist *sg_src, *sg_dst;
+	struct dma_async_tx_descriptor *tx;
+	unsigned long flags = DMA_CTRL_ACK;
+	dma_cookie_t cookie;
+	int i;
+
+	/* Logic: send single callback for the entire batch */
+	atomic_set(&work->pending, 1);
+
+	sg_src = work->src_sgt->sgl;
+	sg_dst = work->dst_sgt->sgl;
+	/* Iterate over DMA-mapped entries */
+	for_each_sgtable_dma_sg(work->src_sgt, sg_src, i) {
+		/* Only interrupt on the last transfer */
+		if (i == work->src_sgt->nents - 1)
+			flags |= DMA_PREP_INTERRUPT;
+
+		tx = dmaengine_prep_dma_memcpy(work->chan,
+					       sg_dma_address(sg_dst),
+					       sg_dma_address(sg_src),
+					       sg_dma_len(sg_src),
+					       flags);
+		if (!tx) {
+			atomic_set(&work->pending, 0);
+			return -EIO;
+		}
+
+		/* Only set callback on last transfer */
+		if (i == work->src_sgt->nents - 1) {
+			tx->callback = dma_completion_callback;
+			tx->callback_param = work;
+		}
+
+		cookie = dmaengine_submit(tx);
+		if (dma_submit_error(cookie)) {
+			atomic_set(&work->pending, 0);
+			return -EIO;
+		}
+		sg_dst = sg_next(sg_dst);
+	}
+	return 0;
+}
+
+/**
+ * folios_copy_dma - Copy folios using DMA engine
+ * @dst_list: Destination folio list
+ * @src_list: Source folio list
+ * @nr_folios: Number of folios to copy
+ *
+ * Return: 0. Fallback to CPU copy on any error.
+ */
+static int folios_copy_dma(struct list_head *dst_list,
+			   struct list_head *src_list,
+			   unsigned int nr_folios)
+{
+	struct dma_work *works;
+	struct list_head *src_pos = src_list->next;
+	struct list_head *dst_pos = dst_list->next;
+	int i, folios_per_chan, ret = 0;
+	dma_cap_mask_t mask;
+	int actual_channels = 0;
+	int max_channels;
+
+	max_channels = min3(nr_dma_channels, nr_folios, MAX_DMA_CHANNELS);
+
+	works = kcalloc(max_channels, sizeof(*works), GFP_KERNEL);
+	if (!works)
+		goto fallback;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+
+	for (i = 0; i < max_channels; i++) {
+		works[actual_channels].chan = dma_request_chan_by_mask(&mask);
+		if (IS_ERR(works[actual_channels].chan))
+			break;
+		init_completion(&works[actual_channels].done);
+		actual_channels++;
+	}
+
+	if (actual_channels == 0) {
+		kfree(works);
+		goto fallback;
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		folios_per_chan = nr_folios * (i + 1) / actual_channels -
+					(nr_folios * i) / actual_channels;
+		if (folios_per_chan == 0)
+			continue;
+
+		ret = setup_sg_tables(&works[i], &src_pos, &dst_pos, folios_per_chan);
+	if (ret)
+		goto cleanup;
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		ret = submit_dma_transfers(&works[i]);
+		if (ret) {
+			dev_err(dmaengine_get_dma_device(works[i].chan),
+				"Failed to submit transfers for channel %d\n", i);
+			goto cleanup;
+		}
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		if (atomic_read(&works[i].pending) > 0)
+			dma_async_issue_pending(works[i].chan);
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		if (atomic_read(&works[i].pending) > 0) {
+			if (!wait_for_completion_timeout(&works[i].done, msecs_to_jiffies(10000))) {
+				dev_err(dmaengine_get_dma_device(works[i].chan),
+					"DMA timeout on channel %d\n", i);
+				ret = -ETIMEDOUT;
+				goto cleanup;
+			}
+		}
+	}
+
+cleanup:
+	cleanup_dma_work(works, actual_channels);
+	if (ret)
+		goto fallback;
+	return 0;
+fallback:
+	/* Fall back to CPU copy */
+	pr_err("DCBM: Falling back to CPU copy\n");
+	folios_mc_copy(dst_list, src_list, nr_folios);
+	return 0;
+}
+
+static struct migrator dma_migrator = {
+	.name = "DCBM",
+	.migrate_offc = folios_copy_dma,
+	.owner = THIS_MODULE,
+};
+
+static ssize_t offloading_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", offloading_enabled);
+}
+
+static ssize_t offloading_store(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				const char *buf, size_t count)
+{
+	bool enable;
+	int ret;
+
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	mutex_lock(&dcbm_mutex);
+
+	if (enable == offloading_enabled) {
+		pr_err("migration offloading is already %s\n",
+			 enable ? "ON" : "OFF");
+		goto out;
+	}
+
+	if (enable) {
+		start_offloading(&dma_migrator);
+		offloading_enabled = true;
+		pr_info("migration offloading is now ON\n");
+	} else {
+		stop_offloading();
+		offloading_enabled = false;
+		pr_info("migration offloading is now OFF\n");
+	}
+out:
+	mutex_unlock(&dcbm_mutex);
+	return count;
+}
+
+static ssize_t nr_dma_chan_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", nr_dma_channels);
+}
+
+static ssize_t nr_dma_chan_store(struct kobject *kobj,
+				 struct kobj_attribute *attr,
+				 const char *buf, size_t count)
+{
+	unsigned int val;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val < 1 || val > MAX_DMA_CHANNELS)
+		return -EINVAL;
+
+	mutex_lock(&dcbm_mutex);
+	nr_dma_channels = val;
+	mutex_unlock(&dcbm_mutex);
+
+	return count;
+}
+
+static struct kobj_attribute offloading_attr = __ATTR_RW(offloading);
+static struct kobj_attribute nr_dma_chan_attr = __ATTR_RW(nr_dma_chan);
+
+static struct attribute *dcbm_attrs[] = {
+	&offloading_attr.attr,
+	&nr_dma_chan_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(dcbm);
+
+static struct kobject *dcbm_kobj;
+
+static int __init dcbm_init(void)
+{
+	int ret;
+
+	dcbm_kobj = kobject_create_and_add("dcbm", kernel_kobj);
+	if (!dcbm_kobj)
+		return -ENOMEM;
+
+	ret = sysfs_create_groups(dcbm_kobj, dcbm_groups);
+	if (ret) {
+		kobject_put(dcbm_kobj);
+		return ret;
+	}
+
+	pr_info("DMA Core Batch Migrator initialized\n");
+	return 0;
+}
+
+static void __exit dcbm_exit(void)
+{
+	/* Ensure offloading is stopped before module unload */
+	mutex_lock(&dcbm_mutex);
+	if (offloading_enabled) {
+		stop_offloading();
+		offloading_enabled = false;
+	}
+	mutex_unlock(&dcbm_mutex);
+
+	sysfs_remove_groups(dcbm_kobj, dcbm_groups);
+	kobject_put(dcbm_kobj);
+
+	pr_info("DMA Core Batch Migrator unloaded\n");
+}
+
+module_init(dcbm_init);
+module_exit(dcbm_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Shivank Garg");
+MODULE_DESCRIPTION("DMA Core Batch Migrator");
-- 
2.43.0


