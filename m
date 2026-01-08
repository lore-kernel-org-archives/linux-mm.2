Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D1AD1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CF36B0092; Thu,  8 Jan 2026 16:47:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DCE16B0093; Thu,  8 Jan 2026 16:47:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6005C6B0095; Thu,  8 Jan 2026 16:47:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50C636B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:47:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1ADAC13A7C2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:47:59 +0000 (UTC)
X-FDA: 84310134678.29.32611E9
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013025.outbound.protection.outlook.com [40.93.196.25])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F4D2180004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:47:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VQJK0UAd;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.196.25 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767908876; a=rsa-sha256;
	cv=pass;
	b=MBtChSsX7wzYMPcy+znzyRhOf1dty0LE2gMknTxJXcFhr4AqcKCTUNtQLUp9wpM+XmYEPN
	Zt0jcv2vS92hwlVYvsbeJgIOlsdwtey2n8PgtGQFYLw5YjAopZ9CTRiGQMftSODgIULb+M
	63oEXl/wgL+ffzOSZ3h77Ik0lNbtJ5M=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VQJK0UAd;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.196.25 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767908876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/DGeAmIneQdqsWfNqmsml3ObwhmC2xDuP86SwZg5aQ=;
	b=qJE7U+d7jJom7Plkp9Dbh5WbE5hAOvE0j5Wbm4QPVS5cayDdBn9fTuEb3ctcw9rqSxA84+
	cxTphM9Gay1OWJfgm8yOXAl5bkhDTJBaKr8bPUHjRbaE5Bp15pGq9FJKZr16VHMK9/pjLT
	EPCCKmPBW0wvsdxHUAQQ7bLN1GMlMr4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L6js/uGTbEjL+UCwiwnkomNB2kHC5aJq3S62WQBOWVXWmyMzsqAmhMXEH1I0N4DM8HXJ7d+FNohexEKwiDJI22vL8wXXt96vfoQR9J9hrUHsuzQ0AI67qq9AL9ZXNSaOcV6ZrPH6kHD4wR84Xd8oEJ8+bhHgGKP6RC7Sz5OylU1Xra+h1cf/NGfaO/I3kXnRW+lrl3ael0rR8n5k2dNaMMJluObocVnI6ZkXHwUps/xVA3NQ3Fvjk4H1I3VXUMtLMeRLRbi0hatJM0MwAlkz90EY3MZCsCnr9DCvN27ueTQcgxVfTayjPlUozmDu5M3rlPMtydl/IRZvPBaCtgMc1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/DGeAmIneQdqsWfNqmsml3ObwhmC2xDuP86SwZg5aQ=;
 b=YIJic4vFAGtHdxlGZV67u1tEEQ9nNYCmPquYclvqUcJm0s3TcCds101OhWxlG8GLXHUmf4SQFFmRoXnWQzGaML7H3EVh6rv8zuYtWzZi68MicueeQgcRo15w9QT4IW8RiHno1Ba7QSY9bpVlzTiuIfCdgk5fLytog4tQzztXFT0QLx4e+EtVfcUiciQD7c8PEQkKVqOVrxFXOegJbyRCCQs0jucwRm2AtRtpImjc0dVsblWxbSRQD5ernw5CCNlhyvzGqiJywch0Pizk+HS9h1vIFfjBVFOinUJFe+ibc79eHk2WIQn+x0iXgOQqZFmEXpYomg0C/eT0itHwYdK46w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/DGeAmIneQdqsWfNqmsml3ObwhmC2xDuP86SwZg5aQ=;
 b=VQJK0UAd9beXq7Fe3gSk4i0r+3FQcrou9TWETrCHZrko/tNUx09cn0ffGVanJjbI/dJSGmMU3h8n+yFuebha4VUWi3X64jHGg77YBEehyXF7cMOp6AS5KLKcpC50ShQ8vlHIGl1Acp2J2HsPQziAuHxl6/JRafjGHK7kTv3Ac1Q=
Received: from BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 21:47:51 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a03:54:cafe::55) by BYAPR02CA0071.outlook.office365.com
 (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:47:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:47:51 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:47:50 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v3 1/6] KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()
Date: Thu, 8 Jan 2026 15:46:17 -0600
Message-ID: <20260108214622.1084057-2-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: b794bbcf-d688-4ba2-d85c-08de4eff9263
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bNgu/SXOkEzHd57MTzRe6z2EUdQ7TQWG5nl5+0yK2DsKZN7Evxcn8pZ4qzjx?=
 =?us-ascii?Q?Cgqw8P6IDDJlUa0PZn6Nro2+f5vJnML4tgv0Y6e+3+RvUJlhScXVjQBVKKFO?=
 =?us-ascii?Q?2d7i4DZkDA7CXmuzj8Cb3eYWj7DGdhKxXwfxedTQx3HQ3bbnfkYNYytGU6nh?=
 =?us-ascii?Q?obZylpHH0m+CarY5zlaU3rEyQwhGKaxE6epnIIxHyT6NKRr7En9KqCVbqtgz?=
 =?us-ascii?Q?RinjkFEDHTSW3zuVaisA2FV7ID8KrzziFsOiQDl9qIvZ5IdC6mZJek13uAxZ?=
 =?us-ascii?Q?y9AJnj9mAuwtWgy8xwYwn0L0AAkZ45o/uFmapbwGLQEPh9RH1/5UkT61Rdfu?=
 =?us-ascii?Q?PX8ox7b92RDV/o9Mw252VfDQFEYlyG8dHp93vJlGUecYp1POgJ9yvEO/LdB9?=
 =?us-ascii?Q?7n/DzXITg1/IsbS6t4C9B+n5GwEVf8GXj/tC33KvLOjc/qJMlMAH2sm7V1zP?=
 =?us-ascii?Q?ceU6ueS8yGlEjYBMtweT0BcYutJQ+epqxWy5o3RYKwKV/qP6RE3ptos9+wSy?=
 =?us-ascii?Q?fWsEkwVG1UL0ksB0om6qo5tm3zGjvA8XHT395PQYBYLFdzEWJ+tCKOKkfX9T?=
 =?us-ascii?Q?rWDCqzR9AoSE/h9jQw00/aWpL9EHqhib9mzDyo4Ian5RXR5Ow5A1Resy03sk?=
 =?us-ascii?Q?ZLs9vC0U3zGl4s7+fC4ylRbFFaAIWzClI6JvAXN7S9BxOo211oarUhhnJ4wb?=
 =?us-ascii?Q?WwBBSrGLgiBAltu81qAS9jZpgfmd9kZB+BuZAHXCbpY4TVnHNEvWFl4mz8os?=
 =?us-ascii?Q?N/KzFX/zts4GZ4wsa7pAgSVbN+xxrQpe6pmGCi2HL1F5qjHKUkzqCAGzJUDR?=
 =?us-ascii?Q?LhZM+QxnvoZkBtGm8Q0n/SYr70ylkGjWZqA8zC/YgrV/xXPjPHcGpCc6jxbR?=
 =?us-ascii?Q?V8nqrYQx3goMv59vHzKYKGF48xG7Ln11V5wjcNVhBTkQD9wHIZ6YF+2GBMiY?=
 =?us-ascii?Q?RdHRlClj/cfdxv9b5o+zbw0pyRR+wHTBZjxieLvliCUV8H+rta17HJ+Y0smy?=
 =?us-ascii?Q?LZaVklYKmiwxfDhQjAAGNtyZ0aWVE95s0GugaDloen00vg+9Y/VBTAZNRWpL?=
 =?us-ascii?Q?9wl8EbiK13IdqkiCw5aR5DNgjZ2L0GKwjvltmARwEr0NgNscWlp+kql7L8A1?=
 =?us-ascii?Q?I5tPYrS3IWdoPPPVT28u28wCUTVTINhpWfq7vHq5Hr2Utcl2hZCyXAIURzSZ?=
 =?us-ascii?Q?bxrL/VXV4v3uUuK4fNNo/QFhq94OZHWfP0Ge5B4AOH00uhoKMe4edvdgBudk?=
 =?us-ascii?Q?Jy2Ewxo12wVZ9cLF3aJ3p9z9XS192Rnkj/P/9lO5D4O3tWV3X+KuktFJtZxP?=
 =?us-ascii?Q?rP3VURL/51OJzvG6MxDxAumGZQ1/wHd6dTTEfRnHVreIxNCNiJYCYiPMMtQn?=
 =?us-ascii?Q?NtvjXysGS0yEq5AFHQS7pjFL6i9tuNW/cN2QKuBgcqtiT631MreOxstratk2?=
 =?us-ascii?Q?+ddH1qDnjR6mAYrxoMg5g+GRxg8LESG3ZE4x87sA7mqOokPicSiLLAaKRNDk?=
 =?us-ascii?Q?XhWMciLxH7PXOJs1AC6n5WOfK0pYE0tmPU8Q/Gj8TZoRZOUDW+6+XoVxyPZu?=
 =?us-ascii?Q?ilCGnVfE6dbHY161MIU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:47:51.1506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b794bbcf-d688-4ba2-d85c-08de4eff9263
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222
X-Rspam-User: 
X-Stat-Signature: wk9c3zjrj3r6ifame61bnct1cqimadqf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F4D2180004
X-HE-Tag: 1767908876-773588
X-HE-Meta: U2FsdGVkX1/DvswL0SSTxmlDqWTGo8admXZlAUYcLo93pjIKJLRbzvtX88Q9UIdMT0JZlnVIeEOCA562jtwUcBnLhSnDbUFl76VAej1xlOH9kguHLwB+7nphA7RSM47SpkytEwhc9oai+xN8Kl1J46vfsqtSUe31bPC4zjKjBVIaWMnMYwMDp2yLw7bJYH47X2zLOEPHzyDotts/nMDWOXL2ejnPFw4VaXga3quaTjpO8jXRUZw/vxutVR8Romq6uqHKb9c3aqeGDZC4GI3DzkCvvc1TXd6mNnqz+cn2vceT541nB8BtSZNdGSC3PTkLt37HifYBxZAMjnXuDM6TAs0jaBk6QquukfggApFU7NSeWWe6Q/uBHi9bHvRQZRQbhUsqYqvNE5W78ReAnSwVQMGXOl7+XXLcZYYdtjwFdj8VmrzvDZyzP8y0bV5fSD7ueizVz3adsMun2QiqITUHMk10Tyiavk4wassPtoGw+SMXKf/wuwwjbSta70s1Pr6bNu0n1kPiJKBQVhqQCOTvVTPrBfBYBTmrOq8+XrK/z+NrFEIcLlOBxEOrv/y/0gQqbLd5iCUSa96kOVQVtmcZHl8BKghhYF8j1m5EkvlgOz87rNnFcN1VRV2sS/3TT39hF4vNzVQ+MzJuo//c+PaoQwhtmMKPI9mNfsADLG+eO1A3IlANQ0St8tDTf2OOC+CQ55t/q+QDNYbBVYJxZ2CjXl4KrMaPjf4N0HZUaJtWeQBJrNG3G6s/2Kk5g1ZQPOvUt4/3iU6E1pv6VCHaKmbCezYdGbjEdNppck/lPDzOc7TfNijTG8iHKdGPCzPMTXAzoUQpOOs9D/TbKkDqSnbDlayZzeozabPNbErhvYDpUNgOh86R56ONCbt+lV5E7j5wmd8zTSmx5nwmWYJL1ah5Mf1CY4FNcmG0jSm7bH4tY0y00Y/cWPDWjx6aS7NKbrmZDwWCs94gVduhlHJEZQk
 O3xEM0hF
 QhGvT0kN5dodHn4nFAZyrmM6PO68S6ydls3GBLHDt/1rKfvz790ff8LNQebRVAHmRIQgDlHrjmNVi3/ojbiAd3kBPWcM7kPGsaHGk38ucsYPusZkE1PcUN/c1dlYeXxRTjDG8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yan Zhao <yan.y.zhao@intel.com>

sev_gmem_post_populate() needs to unmap the target vaddr after
copy_from_user() to the vaddr fails.

Fixes: dee5a47cc7a4 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..261d9ef8631b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2296,6 +2296,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 			void *vaddr = kmap_local_pfn(pfn + i);
 
 			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
+				kunmap_local(vaddr);
 				ret = -EFAULT;
 				goto err;
 			}
-- 
2.25.1


