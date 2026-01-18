Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C21C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249E06B00BE; Sun, 18 Jan 2026 14:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211306B00BF; Sun, 18 Jan 2026 14:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0160A6B00C0; Sun, 18 Jan 2026 14:28:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E75BD6B00BE
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:28:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CF0E160477
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:28:38 +0000 (UTC)
X-FDA: 84346071516.20.115179E
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E44A40003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:28:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=E8N4P4lr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768764515; a=rsa-sha256;
	cv=pass;
	b=A8SJ/a57Xe0b7eiDbBlEuSSo5a2g4zLVQVl4DvLosQc5dx2AZUVPiujIzPJofuBlvflQU1
	BRV7aPaIuK10cweAU/rvbNRjrMImvheJnRmJgP7sH9zc20xw2x227aQI00tpEzKJf4XUrH
	1owG0kX5Eos/kinBFbqogsaJFv23kHY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=E8N4P4lr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768764515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tnmm/BRTiGWEHKmEQZ87F1BwRfj8ccS66N40A1jkvCk=;
	b=KZo105BsfS1zuk0+o8g8H7gNcnT5oTTQv7UbKissvCrQQNP3Jho5JDaO9zJcshmN0PQzXJ
	aTb0Gn/AYRGDwSY0X48oRJe8BpdiY6I4rB1faGZIsXEdprikpdUAguSmG8+2mQRhQwxwYq
	o6OcxDU4reAqyXdzag+3Q3FPemKRqag=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RKsWt6w2FSUZWufZj7xUtdjeKKpZQ45eDIgaDMHzc0/IIQJir5lChonwg7/zji2nh932YJr/licN36t0C4tMz8WxiUJ20mA/Zvh8EREMPYLo1qahWd1pTpI1gXUZ+GrLcxHZyF2ddFEGTndi/EAmUR6KdkIoH65TAsVIviYKV8Wcgy0UsDqSTISq5OojxTvOwZA3eELz9JjDSIKA/vLv5SHqd8XLj7/4EU88vJgoFMO18reDZoOzZgOq0nlnuN6PZ+sGtQIy4hpiAMyV6ac9f+oAzSKkSSxpkyoatlUkPVAZdwRoK+4KHKyRr2CbshYT8xUXwNPO7ohldJWlEYH0MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tnmm/BRTiGWEHKmEQZ87F1BwRfj8ccS66N40A1jkvCk=;
 b=fuUmvHZztIovZsqP/8f3nL3hn9jiViYjiOtjNZNfXO+CB5wJCc3bp7I/z8wIj9WpgFQNTN8Bkg4N66F77hC++twHSZH5W8fkVe7pEA/2ywyXBC88uNlmUKl++BtxandMvS4a+2pd53+56arY2hZz2no5+KIeh8KpZaLyt13J05LDulp2AX1kJC6RAx/hX5Zid24bljflf+EC8VBr+ly6z3guBq24eXOFFfTJXB9HDwnK1AqYYa42qe/HejricsaS9RHk6fqPpFtTHLKCyQPU5XSlV5oygGjtpRhmAPcIs9mwyjhMvZE5/DbXRxZ+a4zJBGF3FThOXQgSA3mjuE/Q5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tnmm/BRTiGWEHKmEQZ87F1BwRfj8ccS66N40A1jkvCk=;
 b=E8N4P4lrGvIvxYFJD+iqR2QDbCpHRYo9QdmvwcWR+deUmOgsrY17tC42MSWbYu9I6TWyVeANqv1r747CQKubywgzZPK+mCmUBKR9Bt9MKUgsMIw8JWFTMXpAXg+p39CFdMgwq8z+ZJsP9aaAdu4rOVslmVtHSv8/yjKS82mPMPc=
Received: from CY5PR15CA0219.namprd15.prod.outlook.com (2603:10b6:930:88::18)
 by BY5PR12MB4036.namprd12.prod.outlook.com (2603:10b6:a03:210::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 19:28:30 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:930:88:cafe::61) by CY5PR15CA0219.outlook.office365.com
 (2603:10b6:930:88::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.11 via Frontend Transport; Sun,
 18 Jan 2026 19:28:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Sun, 18 Jan 2026 19:28:29 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 18 Jan
 2026 13:28:25 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V3 3/5] mm/khugepaged: change collapse_pte_mapped_thp() to return void
Date: Sun, 18 Jan 2026 19:22:57 +0000
Message-ID: <20260118192253.9263-10-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|BY5PR12MB4036:EE_
X-MS-Office365-Filtering-Correlation-Id: 209ec9a7-981c-4959-f59c-08de56c7c2b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dMdc3+lKIw3Ru/SlIHGKkJvgGYGzZNp0JX8BW1fZ5PN/Af6q3Q0MvFjcKzlM?=
 =?us-ascii?Q?5pcD1zgQMZtTw7Iy4K4EkxwFV5AsGFo64K+yOoLRM6RpyMvMZ4eelsQ/CDnB?=
 =?us-ascii?Q?GOBKQvfx8+osoebJYvdjCgNbu8Y/u7yJBKBaF2N92Gmt/n1UDhU4mG+S8v3C?=
 =?us-ascii?Q?1xu7QZ5/uA4KDIB790vSv94bHCnmt3oM4GhczfKr8yxv7JA3ii8FnSB4Yv9n?=
 =?us-ascii?Q?kFZDQwOCzU4TkvbrpNJklhK6YPJ6TYXt0QQ/7SBfvZAy+UBpkrUSp5RDvAf2?=
 =?us-ascii?Q?W+nnRMy02mAXpksnMuYoGWd8AjYKXgrdPoRbBPc8iMEpjFEhhHZUNABM1JlK?=
 =?us-ascii?Q?FWoAUxHj/OepWAypy/BfnLL23ZWPEcs7vq1epBoqrGuBbJHR80s1YoWL6BZO?=
 =?us-ascii?Q?Lew857hhuacUz/dtIFI/95FdE32lez69ZJdgK1pruJVVGvF6EKKvjypLbKuP?=
 =?us-ascii?Q?0m9EuOuZeob9BulQ/y2ocpPnCw0dKVE/fujXKJan0ZbUYULAC8Co5q6PsMik?=
 =?us-ascii?Q?x0NZ3zoHzOaffIFwvPDX7TRiNG+8z6G8M6WCDyGzmBC8twB33Y5Tdg7HL3M3?=
 =?us-ascii?Q?HN24tncHEje8EFSOg8mELhaCGRrACPrP/WfAY7O405v+mnHmzAMdMCfy3pyL?=
 =?us-ascii?Q?eaMZOdgg8gaODunKmq/MjxnrnZAoYyVHg+lsVNcBYmPd4ogQ6PfR6aUt9k5v?=
 =?us-ascii?Q?GZ7Q6MCPecJt/AjsO0M3v6gE/y8YTeSbKay/YmBzdAAcywxTKgO2u93DCyPe?=
 =?us-ascii?Q?eUqxvYhufo47L1cfKHK2TnMR9K8M/13fnBz2wQBzyZg//ce85jNBQYkck1UM?=
 =?us-ascii?Q?tyQ4RoPTcQ5TEJm5d2tX9i8vsQMefpo+DfA6Vp7v5/E+GzkEvdfCqb/LTYSr?=
 =?us-ascii?Q?TJNv2rw3YW66/BE+q+8JL5BcAlBHnnwWUbvDZDKIdrAb5X0cKGJD5EAT73Cm?=
 =?us-ascii?Q?kq3uT/KATDXET20wA1d21fWeyIbh/OTLB0F8cTRZ49E0hBpQNF+PMAQvHPKG?=
 =?us-ascii?Q?PswcGuWMElySCKVk899LJ8WnM5kyHN7Huvea/CUln0EnfWCPCUQmCP01VMX+?=
 =?us-ascii?Q?yTIhbz5LBr7qGUJx7BE8DRwAjzR6UUtcrX7l5zQukrQ/n82vkgXnSi+cbWVT?=
 =?us-ascii?Q?SR7W5ajwJzMRv6/Kq+qEPMTSB3VxUotp+vses7rEFqUpHWvaCqcZgte7PbrD?=
 =?us-ascii?Q?UtYI+nvZ95Tpx/hTEwbj9BYKnGrsaI5cWZqov8A1VWF0WFwgFRSmALEFHFJX?=
 =?us-ascii?Q?HYuQYfUReEeeV4FK8Fj0FUb3j3Bye9+aBOv32ojk5n8EhpYyMIoAmT7d9qLx?=
 =?us-ascii?Q?1ua1c43x1j57GupX5wtsFKfxfNoPR5v8D6H4j/Wof3Zeq2S9+1Z3rN2Yxugg?=
 =?us-ascii?Q?YGWJVoCUtNFYmY+eSFtDkzHbaazOcLVaxBHyqW2B5knKu8xzC9jJQ2FBEWmO?=
 =?us-ascii?Q?+p7HaCQasSoYxKyD18zmP9jFyGMUr4WpPmESAHu9tekoyPz7UHbDwzZ1Kn/I?=
 =?us-ascii?Q?1JdLZr9aF3p8HdxwIXAFjzwrRh8SnPzwDMRM4j13r2a5TYDb7Q6JqUpCqN7L?=
 =?us-ascii?Q?IhA0Dfe1QjKVhccbPyBdapFEcz7WMpU2eGFcLH4kiqVXuZkAX1x/s7wXVrs+?=
 =?us-ascii?Q?OSp5+iDwyop8tsMfqPFqwgUWX2t2DuwOQYlxDJCz+juv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:28:29.7252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 209ec9a7-981c-4959-f59c-08de56c7c2b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4036
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E44A40003
X-Stat-Signature: dc1p7c6988i1qukw4jaxw8fx19s1ju35
X-Rspam-User: 
X-HE-Tag: 1768764515-342056
X-HE-Meta: U2FsdGVkX1/UVufS/+3sS20wublyELrXi3Xg+XzN16EursSqVGrvvxuttEzhycW94M2xZxF8bV8V56pD/BD0h9Vs1dkOW/28A0luzRhoCqKJuMv8yaZVFL6lWl2tfJeUymLUd40ioHLI4qTVw2Zsd8WXbQJ2usLFJrCSaOscXsTuGA7uM0bsHIVW+I+vcciJXeuWisUIXhR8s6O26SgfCwwob/lYtMAUEL/gcncPugqKbhlyazVEw4fwaQkRzmdU6+gvBLji/gSbAIOMSteq2IMmhujuz479V5KXO93V60cLiAM0CJSePkGCcamzzhtVWfPbA8+OglL1Z1Ax3Em9B5OtRowZZW1/E3X+OBNCsU5KS+zkvRLDEb/D94Gv5I55l2FetzqDVAbPGhOoQEuIoRnaYRFxCJyGiSM6JeHcRSBsvL4roYk6Hr67vjwWiKbLNEINE9AZAYCy5AWtHIBUPUca2QpsYZuC4+46+AVzBwfZFLbzgoexexYRDmkpKWvv4zjEJo1oGwsksBw2rirwS1qhE/0m4S8aQS2hv1wnd1oXpTVXcXYFbKD35smyf+L/uryqrn70mheOAyIwChoVXu52BYx3SwOmc5IjMG/WOE62VeKsqjFm2lZIzLIBOjLUPhu8McoTwL1FWNQ56h8WbGUFD6ErjDHG/KQ/iqy7gBKtjCkFmpjAHRgmpjX/rT5trrKlKSecww5HBD+hZ5uG0wG5qZB/kFfPAwRYsQEvHzxt7dw3YN6IuHbBDFXnlBZ1LxA0psbGwUMgvA5jmuCHlDe4Nxg5ffq8udG8EDc/uuktoVkBqqbJyWjbiMPZQmOMJYtQ2yqorUIzrXzdrlpfrqQ5iL/GrvdoQEs9DfS6Vfbh+OCD4WhXJP07n4I+f4CBhNJotKe4KzAz3rKLstvFGW3g3UvRlNV82iDaT8qn4RQOJ2lVIou5oj9aOY/OTmd1e6S2Kv15DJ7wEsxrUIp
 toy8wRiL
 UdDVaWRb9mmWRpfjyBnWZgzQs5KHnxmOrMtg5ddsmIA5XXzdLacZs1VvibE39X1hbKH4Tfsi0O+XOrnZWJlDXARCRreFZ3EMYfvuXAs4pAQ2t+D6cx/68zoJPHfwHsmGDHzkHEVD7JdHG9ZxFLCF0FXFU6VQbnJZz68yOyFleluR0dLA+1bX3OWn6z/ensGs7SyCfql4WBHAmhZSTuIz0syFq0Oue9R2M1XX1Ehz8x9Xl/WWligADbyOMGcfb4JB43C4Vj1Q0QghvnEo6Kka4R0yboy0FW/9aYrpcnVrQ82+txoEf8MnEym5O50MHpXvawS3dOp74THtyEfWswJGYw6IoqLD97Ji73iLUouFBQHy33vh/0cSlpfXPemx2lipxDeUN8msffANpRIy0iVR3nihOfmPKCd6cLANuqwk4gS+XuyI1mylSjQMFf0EeaJFMXtNbaXW0gEOXqvcgKLWRG7atdNYNPCl1EWerrmbUCAx+7vd29oSgjPPkctuC+iZ7EyxLucgxtd2QZSS2PvdVCU4fmQIm0quFHOVg6jCia5JFQvFGUYLhTOuC3m66gj/Qjl363fx+unCN7Jc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only external caller of collapse_pte_mapped_thp() is uprobe, which
ignores the return value. Change the external API to return void to
simplify the interface.

Introduce try_collapse_pte_mapped_thp() for internal use that preserves
the return value. This prepares for future patch that will convert
the return type to use enum scan_result.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---

 include/linux/khugepaged.h |  9 ++++-----
 mm/khugepaged.c            | 40 ++++++++++++++++++++++----------------
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..d7a9053ff4fe 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -17,8 +17,8 @@ extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
-extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-				   bool install_pmd);
+void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd);
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -42,10 +42,9 @@ static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
 					vm_flags_t vm_flags)
 {
 }
-static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
-					  unsigned long addr, bool install_pmd)
+static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
+		unsigned long addr, bool install_pmd)
 {
-	return 0;
 }
 
 static inline void khugepaged_min_free_kbytes_update(void)
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 93ce39915f4a..17f3f0043368 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1477,20 +1477,8 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return SCAN_SUCCEED;
 }
 
-/**
- * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
- * address haddr.
- *
- * @mm: process address space where collapse happens
- * @addr: THP collapse address
- * @install_pmd: If a huge PMD should be installed
- *
- * This function checks whether all the PTEs in the PMD are pointing to the
- * right THP. If so, retract the page table so the THP can refault in with
- * as pmd-mapped. Possibly install a huge PMD mapping the THP.
- */
-int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-			    bool install_pmd)
+static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd)
 {
 	int nr_mapped_ptes = 0, result = SCAN_FAIL;
 	unsigned int nr_batch_ptes;
@@ -1711,6 +1699,24 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
+/**
+ * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
+ * address haddr.
+ *
+ * @mm: process address space where collapse happens
+ * @addr: THP collapse address
+ * @install_pmd: If a huge PMD should be installed
+ *
+ * This function checks whether all the PTEs in the PMD are pointing to the
+ * right THP. If so, retract the page table so the THP can refault in with
+ * as pmd-mapped. Possibly install a huge PMD mapping the THP.
+ */
+void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd)
+{
+	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
+}
+
 /* Can we retract page tables for this file-backed VMA? */
 static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 {
@@ -2227,7 +2233,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 
 	/*
 	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp().
+	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
 	 */
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
@@ -2480,7 +2486,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 					mmap_read_lock(mm);
 					if (hpage_collapse_test_exit_or_disable(mm))
 						goto breakouterloop;
-					*result = collapse_pte_mapped_thp(mm,
+					*result = try_collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
 					if (*result == SCAN_PMD_MAPPED)
 						*result = SCAN_SUCCEED;
@@ -2845,7 +2851,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		case SCAN_PTE_MAPPED_HUGEPAGE:
 			BUG_ON(mmap_locked);
 			mmap_read_lock(mm);
-			result = collapse_pte_mapped_thp(mm, addr, true);
+			result = try_collapse_pte_mapped_thp(mm, addr, true);
 			mmap_read_unlock(mm);
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
-- 
2.43.0


