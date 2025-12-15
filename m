Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC49ED5B841
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626506B0008; Mon, 15 Dec 2025 10:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCEF6B000A; Mon, 15 Dec 2025 10:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EBB46B000C; Mon, 15 Dec 2025 10:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BAE16B0008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:35:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12FEFB7D80
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:35:52 +0000 (UTC)
X-FDA: 84222105744.03.0F2B87D
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	by imf19.hostedemail.com (Postfix) with ESMTP id 122601A001D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:35:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=i2qMjrwv;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.201.33 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765812949; a=rsa-sha256;
	cv=pass;
	b=pxtHh9Z8ufzGY2LVW2oAFTBctaj6m+FWDnvDu34FcOIVP7O5y5P4No2pkGqFgcG9UonrXD
	cTQCMluG3fcgwJR+O3oOFt1a60ZxzhedixoCCYtvnwBb009c70ieotqHU97/sX0fd4AGWb
	ayNWrVHnNz53K3ciib1hrM8igbXhQYQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=i2qMjrwv;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.201.33 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765812949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVgIy/5ze6wpZVJys2iQsyujhyGNdUjsYuP3eHSISbE=;
	b=ACMKAjlmJvjxm/fw1y28d5MHJVOqwbAaRXVbhMD76O2zpYXNnTWxsS98JVDoFXtHKruwe9
	R01j2/0hfNZDUDNXh1r2xkijLjvUSdj+NVcvJ/2BUiLkHY/UrJDftj7FuF5V84yDep0XHn
	daVNK128j1za4GsqMOehNZpDY9DF+IM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MXOHhpybV2ehEGXTBk9Imru5INes1Nkk3zARz0Gs32AZPKvS31UxtwO99ATn4b7vNmQCb6ED2reg7vDwzRe0r4MJmmGq6P3Uf6/6td+dQz6+A5BloAaMM+47zEPc1iiNUwZHtn5a0pytLrRvzh8jiRY1vh6XLKs0RZei51UxjrAiU9fPpIaIZDYAB3GFNasYK7J5YGqeKI8ECEgYk45Wy5B/f9HRpAlX3iXCCTEDQvQwJCyp39HFZXILLma3L+fKOuIIKFj3oytGHftFJCZ34eN7YcZLF6b/0+o+YcWPyuVKNpJiTFo16HcvdATh9CQxIJCoih0hldKtpxWYXUK0yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVgIy/5ze6wpZVJys2iQsyujhyGNdUjsYuP3eHSISbE=;
 b=p3m0FZT0ych/wDkLkJt5y8ZQ+lFNXVHJpJAWxKexlyLLQib0054aDpiT5tfwgJLRU5YHczYXnJc7T20pps0ksbxdVFeVTaFgPRCgRdPlhVp9ItvFv9OYKpIEvJ4YAcbokle+m0od+XaKSNVFt2QbGj6JXNrUHKX1JIiXxOy1QVj/jYNzKNbn+d4NEcdeDiuS5LgVCgg7fYEiykWeWPcLZ0QMGOcJ6UELhqVZooteNl64iTSQoGd6fZ6ECsR2Ozown+PEONMhf3FCI1JBAy+AHM1/oCpNpaXu/BJAjRvGV4NWfxOWQykME7pICHZSy5cxGfN1EgWXUod5h0kz/BmMlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVgIy/5ze6wpZVJys2iQsyujhyGNdUjsYuP3eHSISbE=;
 b=i2qMjrwvVtKjwuF5/tHz18OoJFEShIDFqp38NUntJ9K2qMWvmQ88iG/3Lsh3rR2v2NSquN8aga0n/TU2vQm2VwKr7xaPGPFIFJBA9t/m9tCdEdleERW5NRQrRUOniRxPhPgriLJaZfxYQr7vM/MEO5R+FllCuLxhpXVZqQkdHtY=
Received: from SA1P222CA0160.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c3::6)
 by MN0PR12MB5836.namprd12.prod.outlook.com (2603:10b6:208:37b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 15:35:41 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:806:3c3:cafe::bd) by SA1P222CA0160.outlook.office365.com
 (2603:10b6:806:3c3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 15:35:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 15:35:40 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 09:35:40 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH v2 3/5] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
Date: Mon, 15 Dec 2025 09:34:09 -0600
Message-ID: <20251215153411.3613928-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251215153411.3613928-1-michael.roth@amd.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|MN0PR12MB5836:EE_
X-MS-Office365-Filtering-Correlation-Id: 2447d2f2-fedd-4966-d7e6-08de3bef9a89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NKj5KGt4RWLH1f/rT0S09Km6fy0nGUHv3Fm7o5eyq73A0JyZ+naxgIu0rELb?=
 =?us-ascii?Q?eQtjAqf3Ju690qui/V0LqWqQ7cTtp8twMKa7GnI7I5lL4IdLbQHErZF43Mdq?=
 =?us-ascii?Q?jj5ozRqLBxBKR3r49lIeb2+NIH7fu+lh77Sp5cmJfw6Y5Bp0+EWe8A3RLnMU?=
 =?us-ascii?Q?53VX7zHcXLQmeWNS1vbQ1AjGI/i189YOx7Hwl613EXjbFtNfLzZzpDgtj7Qh?=
 =?us-ascii?Q?arbhcPDzpSQUEkU069eBvqfLnEbnaFc2EZCdBw8fm7WYYQUXgT4h4MydgYS0?=
 =?us-ascii?Q?QfmdGTrpJ4ntZ+8CYUOYqKZ73jv2EbZhefH+Ch0GeIiDVOLTKKkKeD1xitBt?=
 =?us-ascii?Q?T43agul+gWHxqfrKf8PMAXAXnwfCzCHc25TjDycDr1X1Y2/lM9fHCHkHr/OL?=
 =?us-ascii?Q?nrpVY/L9Eo/7bZNo4LmG8f2Oatqjew1FiOO+6YYlkXYDJGYz34Cp19eppBf5?=
 =?us-ascii?Q?N+omFCUIkWAXyvH40xJOIAI71RDVbiOJw+wwDLdb4kGsi2DbAsXN1zK4pZ5R?=
 =?us-ascii?Q?05OJhb4JbFYpwiXJ48zFqmARf2lQ946WB3WP0eqRSv7McKbHNPAls78kCJdE?=
 =?us-ascii?Q?8ThOFkwQGrBfClFuV5Y6krtstEFi0gJ1xG09gDN8J3U+LHDa12th0K7vXopz?=
 =?us-ascii?Q?E8HWJnmV4ovN38sE3vMMVmj2/yoJrHtRn3B6WD2iUIDb2NOEtus3/xyypZ9V?=
 =?us-ascii?Q?cNWOIfmL5h+XVe8XIKmTp0JDcYt5EdfLeMcxV9y2d5MUaHg34QwgHfin1+t6?=
 =?us-ascii?Q?OI0CuuV9xa9PAgtbvZKMrscyp5Y7D+TAfn38yR2816bmZwmNqPxhbwN+RkQu?=
 =?us-ascii?Q?Xh84TCAOGwV1xqGCmPNKTK9DkxcQCup+LYV/v00+QRXnM0UXxNPqW0Raw2wY?=
 =?us-ascii?Q?LUsco0QamKWzLhJ84DFrgxtMpLdyXz6cNfmHetIjhl/7vceqyHpmd8ihqyMu?=
 =?us-ascii?Q?ZxvCiacmAcLHKOdIPmnhJEluObPCa3MGre85lCo1xcJI9vbrFkq50pRILhtN?=
 =?us-ascii?Q?zXc67M9UGkaBIk3QK18Zwe/syiJ59ynZB2GqPl55O6GcSL7SRsCSA5dFUaRn?=
 =?us-ascii?Q?l64ILlcsoOq93564T7o37otm4aHuLWIulotWXJB7hOhiV4pWULLWweptQ4qr?=
 =?us-ascii?Q?aIDwWi11+R1aY6Y9FsAv6gmQ2VlHBJbHYbipMjDHnnQ7ErVknCLWeIkMORwD?=
 =?us-ascii?Q?Rys1UeLTOgM1iyWK3Trn2tKD5zBUUDpq385jxI+xnwkQfmNhNExz6ANxSZ5q?=
 =?us-ascii?Q?65VRkSb/F1ogVKhA2vkBdOrxiNIsoNn+SS/rxIrbN/s3TxQvXcXecVekkwy1?=
 =?us-ascii?Q?v+xsuqrwr4CE3cPFYu1T34n1/VlG2EvbgUUrb1jsfRHv3udVl+LNvn5LuPuP?=
 =?us-ascii?Q?RZSDCZOwqpibMLnIE45ADy0JPbo4IeJaxVp+YWZ+06Lv/SlrlqleVsDCbo65?=
 =?us-ascii?Q?Hn1NPic0F2gJY02Ow8d033CAzZUfitb/kY5O0DcmXwc0ZMy90fbYq1GnM6yw?=
 =?us-ascii?Q?9xEi/yRHG3v7SzrVSPhXBhZVP0YiBosTGbbCDruuvXKAfUGCIho9s+xEoqkf?=
 =?us-ascii?Q?aC/LhWcpX4xIApuCDV0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 15:35:40.8519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2447d2f2-fedd-4966-d7e6-08de3bef9a89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5836
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 122601A001D
X-Stat-Signature: q8hib5paauiu5fjquq1xkp4azzzjindo
X-Rspam-User: 
X-HE-Tag: 1765812948-763037
X-HE-Meta: U2FsdGVkX190y/A4ASkrT3hO9R+H4i9F6osFPUsNUmvdbH5Ye2IhXOmgdf/awO77PF8e3d9QGEAy5UJeIB7N7jrv61vJjc8fEDbGII0YfubbsVYhiQq6wgsejhwpOS2+JqiCb9SyQR7BYFPQBk9gsVznOevxJL92fMAn1Ujd+fiSG/1whpPJbracQff7HrU1KO+DFbNpIcQpH+tfdg1MkW9hOwQ0kTaQgrvuOQyKTebsoBc0w8CnPPclBrYbmRNyt2DNSkGw3LE/knDxQvkqn9jMZfu+2CdT7pPSFyZm3EZYsJjnVejzK+q6u04Ne2XKTJBkgLDDn5daaoQHMVRzKlXteCdbTu8bVqsFJhDCHRiUjEz8LdzhZZ4RGVWM0qxP6bp8JocmtHk2hM6t8AcN+eNaPgEL80l37Omlbe+ul60b1uRyzEssJCIctk+x+Xu1ilZkkbsLL3Vb2O98K3QisWG/gajwAs6UWeMSOIa7GadT/8m/VPHov8oNZLAijXNUJfqZe69cfdAP3nTnfY+yn9PeaWEpTzAwTu6oIUlQ0+IArOUHU8cxb9GRc74fdb5c2tFz8eGD1Lo8oWPisNylS34sG9SN1M1Vjxv0cz/Sb2+3PjL3XXUUiIlicbSHZcpnacTuKLT3Ei7hkc91tkKdKmWldC4LBHXfOnoTJHV6SX+UqyO5UpLoBMDSDvYqmWh5T28Xe846nsPMAR6n6uP7mNZX9cs1JdZ0b0J++TYFzHJzlfNshyLFiIkuRnMfLPNNfUD7+U0SPGexv6kvkZ5Wb3PeeaHZvQyJwTSs8efGHRuLvyqZpDpQndtsFEVHIGJ4ap55HRx7p6OZLjTAdnbpgsmD2uHICPVFhOeyObcJHQ4hdIs1BxZcF3qr0BNrZWebKv7dWUf2iG23zJ+p8VRgDpA/Fewl3BU5TQWNE5znpk+VCd3dAo3dKdGewJ3COXy0WERds5K/HdTkwAqkH+j
 E+9YxILQ
 ZASAUVz/rXMNzK9kCH4NQFDFCpTMAi2t6Gw6afQ7C+/cSxb8/slcjkNAc1J1aiQIigQ8QPnDalcgAwGd6YCUnygQUc3ZkQjdd7g/Wd81rV6FS/IilRK1FiYaoekVytE4MFaOnmn394MUVgaaOGyqib8xOJ5cY/28rqiuGIDlMPh0NY4umf7KaCjxJrf3QjWhRE3kgvr5qXIPdlLJkdT/DFCxsrwMlrf2XBbB9jy1zQ6Dc6sifrYjIYQ4rPTIiwzSG1AxbbLLV09B37FR7IMqFdMubwHDWnW58hnL8NARcHEO8hZpgv7muLeeJ/rrjebgs62BP28LpY+IJyNBPbrLNGFsgpObtzanvh3SDI1MHUEoy+anUf2YhE7QB7vyqnwJNBGQ4GLNauGSmRkJ44yK2AjzBeDXVvAgRQThVu3L/4hcr+OgIz3oLE7/Qag8WGCcOLTU7RwB70dlXGwgTUoxJyJAIlp3D+Xz6VRLd0n15devVABsWd5TtnOJvZn1jgK2j7xAH/vpPIK2NOfqPeZzYFsAHKl404CD/WCBl2yH13D3kbo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, KVM_SEV_SNP_LAUNCH_UPDATE accepted a non-page-aligned
'uaddr' parameter to copy data from, but continuing to support this with
new functionality like in-place conversion and hugepages in the pipeline
has proven to be more trouble than it is worth, since there are no known
users that have been identified who use a non-page-aligned 'uaddr'
parameter.

Rather than locking guest_memfd into continuing to support this, go
ahead and document page-alignment as a requirement and begin enforcing
this in the handling function.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 +-
 arch/x86/kvm/svm/sev.c                               | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..5a88d0197cb3 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -523,7 +523,7 @@ Returns: 0 on success, < 0 on error, -EAGAIN if caller should retry
 
         struct kvm_sev_snp_launch_update {
                 __u64 gfn_start;        /* Guest page number to load/encrypt data into. */
-                __u64 uaddr;            /* Userspace address of data to be loaded/encrypted. */
+                __u64 uaddr;            /* 4k-aligned address of data to be loaded/encrypted. */
                 __u64 len;              /* 4k-aligned length in bytes to copy into guest memory.*/
                 __u8 type;              /* The type of the guest pages being initialized. */
                 __u8 pad0;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 362c6135401a..90c512ca24a9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2366,6 +2366,11 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
 		return -EINVAL;
 
+	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
+
+	if (!PAGE_ALIGNED(src))
+		return -EINVAL;
+
 	npages = params.len / PAGE_SIZE;
 
 	/*
@@ -2397,7 +2402,6 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev_populate_args.sev_fd = argp->sev_fd;
 	sev_populate_args.type = params.type;
-	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
 
 	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
 				  sev_gmem_post_populate, &sev_populate_args);
-- 
2.25.1


