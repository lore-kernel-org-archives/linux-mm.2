Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BF8D148A4
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432426B0096; Thu,  8 Jan 2026 16:49:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CA86B0098; Thu,  8 Jan 2026 16:49:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4F76B0099; Thu,  8 Jan 2026 16:49:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5886B0096
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:49:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D12391B085
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:48:59 +0000 (UTC)
X-FDA: 84310137198.20.D32D25C
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011046.outbound.protection.outlook.com [40.107.208.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B30820014
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:48:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vSP8M0Y2;
	spf=pass (imf13.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.208.46 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767908937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6S2bnfs9WvvEfWZmJfQLL0w0M0Psm/uI4p6BSOG8/E=;
	b=cHHrrzbS6fk1N83qsYv4YDgheu2U4R4B3rKZiCljCfA4zca0GDnszfbCtZR7+tVuXseil/
	uhgwqzbYdaBDMuXivAGMEx9nxbS03nj9GWJA6E9VkasJSddvWaeL8FsDytvm018RWRcQkp
	eEgiFpdxktJpjAeO82UIsEd60aaXPI4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vSP8M0Y2;
	spf=pass (imf13.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.208.46 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767908937; a=rsa-sha256;
	cv=pass;
	b=pHUmzfYUGO9x1jBFaIv+24mu9wEMsxNH5duzN2XlVVVI513JmVeotcFX5koOupRU2qoFeQ
	qg9uRqpw8ICnb907TOeferGt4sTEtp88/sNUHP+XeOePou2yOUP3nc8UJ38Hb2EWp4ltUy
	chGz+0IJZzzhb06usJmjgZapTO+JQv0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFC8bC/+69UpGfFt7TH+JqbeAyh0KnEJzSV7eUC/L+vpGb6bt6fYWJFcEXxmudnr9/PxBGksaNhlPym9zRxUh16I7Bd7kbeIIMrYAafV47/bOtNDKvZG6HhuAgcbicbciEQma94lr+XRE2xpsIhXrFad5n9pkZ31C0p9tbvleaLZCccbnwPHudo/w41yxocdy0trZJsduxQ88uolXuPAslqfV9ykihCeHFtaLo7k3pTY1GdnMxiB/HazD2AfDD2wmIghiT9F7RV/GAKmxEOz9E1oXaxHU01bnCogaqql29l04vwgW1rOYTYD5YCx82mMDCA4aDP9AXgF3bEniQlrjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6S2bnfs9WvvEfWZmJfQLL0w0M0Psm/uI4p6BSOG8/E=;
 b=HNWg/2qVmVWGX2A2l6Cn+Y+ZR00imYIuBeGobzr17RtyNNp+Lvqjjk7MLrvmX/L5YZHJB69fVqnSw6WSSTCJoRtAhlvahsP2lByRlNkOgwwE9hel7n6jVWngRhBv5HN1Emr0Cpy47DDWrxMW5DE/yPx83mMKdeaQtg/Gqh62TiAhxlbbf6La/DE7jv/Blg1IQ1kqSJzbLT7QTQV+mFa5WHxrdmx3mWhD5lJ9ETO8rA41QtYVmWMbsKZBfiyoEBhiorp7JUZetnaBKvBXm10ccvpCyHaHqqHuPsvobt22YtVaaKdGN/ltNgBinc4mLPHDBXFOFf1v00OMFwpNQOTBOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6S2bnfs9WvvEfWZmJfQLL0w0M0Psm/uI4p6BSOG8/E=;
 b=vSP8M0Y2FIIZyaNLQ5YaXhXlnUPDVLUIJF1wflBu6liq/XOAgPjU3jPw4rnZwwONo7tUVJxH1yK0iTukvB8+gtolUFd4xo/uKDT19Q8EMA/UiXZIf/EawvyNYK+EwlJ+0X9ASvRbMBwFtSIAMvmh465PgL4pP8QzxjNASdaWu0E=
Received: from MW4PR04CA0379.namprd04.prod.outlook.com (2603:10b6:303:81::24)
 by SN7PR12MB7911.namprd12.prod.outlook.com (2603:10b6:806:32a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 21:48:53 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:303:81:cafe::f) by MW4PR04CA0379.outlook.office365.com
 (2603:10b6:303:81::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:48:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:48:53 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:48:52 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, "Kai
 Huang" <kai.huang@intel.com>
Subject: [PATCH v3 4/6] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
Date: Thu, 8 Jan 2026 15:46:20 -0600
Message-ID: <20260108214622.1084057-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260108214622.1084057-1-michael.roth@amd.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|SN7PR12MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 2747046a-d6e2-4d32-e667-08de4effb743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B/tIsMYIRe7MhKrwpHwkwuXbyp4MbYzmFbXKc78nSb9dEgPo8lrKCJ8dOzl2?=
 =?us-ascii?Q?V/TV4+vGyRmRzRdLnuzxJZhWzRLxS0Hl00nGizWhjyekJXJYjRTnHplY2tMf?=
 =?us-ascii?Q?vAZfu1JZ50CPBXxDfi7V2KqMnt402bfnTw0H5Is5jErunKL9sPgQXJBB5KrY?=
 =?us-ascii?Q?O3+vcjhNABFi4aR0bGcHFI2+qxapnYPFuJFMn78FBHEC0tAGw0rGp4Cxq8qM?=
 =?us-ascii?Q?+/zDOY1G9HkbBOqm116QmVyVp5dl+mwqDnhHJlfmHWeT5Z+sKu/8WcY+yA1Q?=
 =?us-ascii?Q?ICExICD0pe3YEjiR3FpKczMl2f+fQ/bD1XIqdn+ioXl6F6nAdjBunr00PyRe?=
 =?us-ascii?Q?pRijoisINIA0/u6v07SZFw9LuShNxFCdrslWltO7gXODBhaYhbYqBGN2O3b5?=
 =?us-ascii?Q?/BTvuijuAJZ1jqkB6UtIy9AMxkbqpC3ilSL85kQNnJ6xYWVkyncELSMMJrZ2?=
 =?us-ascii?Q?lA5BqorMHjJYH/rP+GsHvkPq+432BWZqmC1Nrif0AmgpNRGi0V59B7G8AVtH?=
 =?us-ascii?Q?HXuDTM9Rr2X3luiO62O2VOZAQVr9seZdi44iYbzK3qU8x8PnG0Zcc9MsrTEv?=
 =?us-ascii?Q?6Dkgx+z8sbR296fPLq1EtLz8G0PKEIZl4dMeGM/NeJDf4EzcfkS9ZtCR57iq?=
 =?us-ascii?Q?ImRP+cAYENISw31vAOudAr4IyAiVmY4vnLdHP343z6F+qiTCl44drnG41MyH?=
 =?us-ascii?Q?D4/PSsApozyO4NyAbsIkegsiqzf1zoS4liyI3C/TIj/dsYKsxgd93ptf3wZB?=
 =?us-ascii?Q?kmmOTtdMFOQex3ee83nNSRk+3PablpyEtkU8GYQwGRi9vdaVNKH55n27JtPO?=
 =?us-ascii?Q?VXJwy96mIwkpua0Ja3BdO16FikkxGMOlsf8GZkUu4LtylbxrXyCY5jM2ffSI?=
 =?us-ascii?Q?7UEJagaauy1DMOBockooU1X2YM5/4KE2gFTGi1UAHfpupKM2V3LllxY5gK5w?=
 =?us-ascii?Q?7L3CsGG9FS3eF4QiI482rhHQxChYne67tfEh6o/s1DwlanlAAlETaU95lJys?=
 =?us-ascii?Q?yRQmqPY8dQIrq8H+LvFq4ySadWcEsz9Pfu8x9WIrfVt3YlvsTSZi6PfIynCL?=
 =?us-ascii?Q?MSpC/FDK97XRrMhqrldJ03UAOz2nP4sA6k8eU3cBdyhMSJmdngfgJ57llj6U?=
 =?us-ascii?Q?tQmcfud4iTLuHtmiyIqWJ7wRcARqRiACcmVne/38h01cj9KDo6JuxvCPHCvj?=
 =?us-ascii?Q?qJUXYf8i9lXhl+XCJH1Zvmq+fRN9xc03JyqyLpHfvZ0zHWOsdHhPRRfYXm78?=
 =?us-ascii?Q?NCyxl/QiNY8P1mWCyUfJ631TEePAKFWC+devuAvWTaBSuoXWhebaY9XGeDfL?=
 =?us-ascii?Q?SB04KfaGhwOUJ126iZTU7CxQoUMyeWi6efKS5lrkXo21Jcv4vscn37ih0tkP?=
 =?us-ascii?Q?49Ps0VGHifliaSkf8rqAk0VuPVGaB4g40+3rKvAFDBxaGn9hagjivLHp8E+s?=
 =?us-ascii?Q?JZurim8VPcXlw+2YP5Pp7tIw8kZJ1xN5J1nnjafOIq/2tEDHaL+mNtZdEmvx?=
 =?us-ascii?Q?GcIGsL6sNOPUABQm36Ane9yFCJDjGQAHkb6W+9L9trkWdEhBAftvhtorbR9j?=
 =?us-ascii?Q?r3dMZRdhQoE/z92wlso=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:48:53.0157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2747046a-d6e2-4d32-e667-08de4effb743
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7911
X-Rspamd-Queue-Id: 1B30820014
X-Stat-Signature: jzi9b48awrs6hy4xu56mty4epw47fjkc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767908936-761100
X-HE-Meta: U2FsdGVkX19JfTZGlfEI8+v6pnCndYt8/aS7CBoYA54TYU0vxINnGOw8GC72CUTO/rW2gXMYvGDEA1lydfn1WHHLAE5V6MDKOwrTP0GLljpn/LVzzbfhpPMvqEgLyAID5VL1kWzLQWHK05fz+nGYZeyUtK2MmeEyMMlljvAeer6Q2SwFaWJMzdiH5R1dzXpmnZ8CADMqS7ioHbqMO9LkV0kZp4ndzhSQIKU3ImjGQV1Ii4A3WlMNB5+fGI9MTZv+iKYdAUJJhcAT2pfr9lHGZ2an3fKdbK33CBOUShqqNPoFDEOSq1lpWNA31TwvifuBnhz6Asox98FZmcdlirXdTqI6s6FqsxxDa6LIfy5New4KhrLxxl+67cFTd2iiIVJx09kvjoPgGOFAH3RaMyBnpuOMeGzsqIQSyQf3hRn3DvByfSz0SMMY3MNtu1PF2eHkGE9Q25EgP8yu743mwgy7VeiUyY3bIH8pmHjiQHOOfvF1gP8H1+DcqQbX6wU6sQ4MIA8K2faIepJzPrcJQ+rSxGJAu6hgMzPcQ57dtYzDCPqXbynTjwzI2i9R7obg28kCMF4/uhy40ihpy7mItgnDIQuIpdRJLHZ2Vc2AqSqiJpLj44v5yQpRWHFMyIEEYIyeoF1zck70giZfTW8b2AJPCe5vboWAG5k4+zSOe7ELozf1P5+6JHqFvQBoAiCjXbbt14/L6jq0khe+m7lvmSqiWwpkAVt9y99z8eUHOQCYBYoDPvwZL/9tLLbRsos1oSIm1skQFpQT5EcxD8xrP/Cnl4hfSYIboYfKG4FdJmZNd/QFijP6WlyULArfJrSajJC4uGJB4fDnSg86ogn++VwXe0/kju9nhR15L/v2ouyfznJ0I+Pc5WH2h1EErfZTQJy3SZ0FY3UsPBb6RTCE1rTlBVCEgxogrvNdIipTA4ltNMASelc1UCWpIMkMS3+7byPTDDV0u7VNt4rq0S5wUfe
 GyE8OBSE
 +nZknooCqaPClyKRk+HFi3LO7XMB2gsFKp3f7PLSK0dworhNq98eZ7tmDPEMpptodth+8vWxMNZYcw6JVvAwoYOOJsrx/o2E2bdupkyWAxdCFW6oCQDE5QHM3yR+dH8opAOsn
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

Reviewed-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Kai Huang <kai.huang@intel.com>
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
index a70bd3f19e29..b4409bc652d1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2367,6 +2367,11 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
 		return -EINVAL;
 
+	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
+
+	if (!PAGE_ALIGNED(src))
+		return -EINVAL;
+
 	npages = params.len / PAGE_SIZE;
 
 	/*
@@ -2398,7 +2403,6 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev_populate_args.sev_fd = argp->sev_fd;
 	sev_populate_args.type = params.type;
-	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
 
 	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
 				  sev_gmem_post_populate, &sev_populate_args);
-- 
2.25.1


