Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29683D5B841
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5C76B0024; Mon, 15 Dec 2025 10:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD836B0026; Mon, 15 Dec 2025 10:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC346B0027; Mon, 15 Dec 2025 10:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6998B6B0024
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:36:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F93788B09
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:36:22 +0000 (UTC)
X-FDA: 84222107004.01.2744FC9
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1D61E20005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:36:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="KoEpEPc/";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.201.23 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765812979; a=rsa-sha256;
	cv=pass;
	b=VzFa5LZTZBsdqoNeWmIYzGxJ5XuHRi93ae30xxW+97/8VqZ8xQKkESvFHbYBytfhTDAMPI
	Eo6Jz/mzokYduCdkzUKLf/0t5aoWDX76xy5HDVGH/rQKHUvsZSb/Y420FtnU9G4hOBMRmD
	ai8U/3+ah2KANzcJA/Wp6xgxxZWImuc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="KoEpEPc/";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.201.23 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765812979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXzS7537FlmFrd5HkmEyPgxcrq255cIDwZK1pbEPrEA=;
	b=q50hHf1Sq6/3L3M5T9Y+SpHEjrtOMRdQYw6tCEc31L56UPvy3+yU0P9nA6cx3/3yewNZD9
	Cbhssy4lGpF+ZqnLLtbHt91K9hv7p8IcglKbyTEZ7EuhLZNR3tKGSA/sYdA4s0xLo3Em/7
	cVpwF5JeL3cS0QiFtzbVJXsNIHzpems=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFa93i8fdPIXVuwCO0LOzptcGWRDmvQXpwoStwlf7ifn4OHvyURuxamYmmdxx6d1tHVuFEb4iCUNqJBKt/cjbKHsev269f3A1EF+rImnQY6FhnWZgBaDz7SVLlKLvSR+EDvmHMzxVREwMBExmSxYPkDlrrUfuZaRsLmAiQQvMmmIs2SzseqM+fN5WuHa9y6e/VqRnAbGBbkRNSxrQ50HQL+pASeSf9VaiCOokj9sqR4Z1ghnm++YxKc+6UBWrGSxoFrlzRQYdoO7VcZfG0wmUu+QIEXwzTzHFlzm1ZPqBVrdkaArDT+xNXRiSKH64uzw42GwJWqPPvJHHJjEk1RQTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXzS7537FlmFrd5HkmEyPgxcrq255cIDwZK1pbEPrEA=;
 b=TCw0HiahXUymAzfo67eDgrkBppM4mMB0nsO0dt91lnUGqOKmkjl+CqYauXWSQPTUSeC9Jn/9SpfJdkstpYERDE4Z9X74z8i2ePkrUS4OG/4dOepokUVYj3+9JOwU0Y+V6+jL/1gnOFaiWl18C28/p5va9YUhLFgxV1agn6TdY7uMTiV1dFLTL4YHI+jOHbs9C8A5oHpWMetyZqgtJqVOpFTnN4b6DLl0PNwaapghSsC/Ba9VjtTUWGGno51FhpT0GZidGB+Oh87ZlQQuDejdl2YFR1uGSIdOqW8rbkgImTD8lCWnPnGqSam2r6S8KeAL+fVZsIUNiV1Ht1cjDSR1zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXzS7537FlmFrd5HkmEyPgxcrq255cIDwZK1pbEPrEA=;
 b=KoEpEPc/BwEsaJhZEHE6+LoNRPpONCP4wDhlzc7yHekamFC/QzS6C1QuUYFQQcmBK8+zdfB1nYHaKfD0Qh87DiU9i5uvcxkaha0QZKLk7lGYtqD/TPF4NRWpucr5ifl6Ovha9Xf1fLVt3qP9QH+Ka3uSTqfL5WUwDnkiMvsisOY=
Received: from SN1PR12CA0090.namprd12.prod.outlook.com (2603:10b6:802:21::25)
 by LV8PR12MB9692.namprd12.prod.outlook.com (2603:10b6:408:295::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 15:36:08 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:802:21:cafe::f5) by SN1PR12CA0090.outlook.office365.com
 (2603:10b6:802:21::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 15:36:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 15:36:08 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 09:36:00 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH v2 4/5] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
Date: Mon, 15 Dec 2025 09:34:10 -0600
Message-ID: <20251215153411.3613928-5-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|LV8PR12MB9692:EE_
X-MS-Office365-Filtering-Correlation-Id: acc023cb-672d-4819-5cbb-08de3befab0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NC0AAmp2u+CVzGZBDBWgnLXNTu9w2tB2khjitGx9rC2JE3TCIxZtQD4/vf6O?=
 =?us-ascii?Q?WUFUzd8zBCjJLUB0nr7VMUZ/qey2uaafvOvvKcGy2QyvGqxVaGnlRd2Hycyi?=
 =?us-ascii?Q?hHARr0qb/sbPBvUbT/97cB1gpEO9oP6FBxAfbPI7T3nmdTnpIP6hSKR0+SDm?=
 =?us-ascii?Q?dkVwOAzrD8tAysCQRG8VBfYX9NPkB/cvuO1WCkoY/eEerSDu4euVZNqMKoQ6?=
 =?us-ascii?Q?4n36j8Cym4tUvsdTsf8mTIyL5oVk+Qz4hffGMLPgtP0Lx3ilUlODhu8hrd5P?=
 =?us-ascii?Q?FjKXdFs9Q9PWszZ4W6KG75/fcg1VlN03aUitw6uDAL/95XuvAis4bQ5lOfEE?=
 =?us-ascii?Q?cEugQdTXBJZ9cD+vBY27FUJZMYbR1oh56h1lHD0MI7dMNAAaxfhwadQg8OYI?=
 =?us-ascii?Q?Mmqkuclu0bSqKyaf9hmKMrYOwXciXWKiKsKPC1iModOqnzyTKprK1nDPV+rb?=
 =?us-ascii?Q?wLG5NNoJ9ftunfXFaNzOiJSetoxIAjojvk58Py5KsW6DQVIhGtI2b7MK4FgN?=
 =?us-ascii?Q?ep2nwiVDKTqdWxaBCZTphmEuK3PlAO5rX0oDx/fNOBFaR1IW+U/aaPxOJmje?=
 =?us-ascii?Q?WhwUnlkuetiUf2cjomJcgpxooh2Xe70UFJ7kfmMgTb94hpqvjVZXuFwE5aQZ?=
 =?us-ascii?Q?9LlpGxJVuyvTg3AM1epF8m+OgDUITPV0T10Tx1WHQVYLMbVm43Ul0B6BjfZi?=
 =?us-ascii?Q?Cu5mOy/5u7fcp4VRlIUU6jq7NrUlJCBbA/kEfUI6AtRKQYUVYuVLU3aW6OsY?=
 =?us-ascii?Q?qdaYGtXQvD52OgucHkH/V6qROHV8oHOkgfISwSFbUr6Iht+J1yBk/VZI1y7y?=
 =?us-ascii?Q?7eqh5jnJ9m3310LvR/UZ2mFCUwmYIR15VC2ehKPJH2BMETLEXp59hQaaAdX9?=
 =?us-ascii?Q?Ml5M1mkI/oY1rPHX7brUzwOdJ8MQL8kU29YbGNnqKSw8zy8ywz8+/Xvbp/ZD?=
 =?us-ascii?Q?j8O3ZrDp5CV/bJut6apYstbXybQ1K33ZUT2Uku61X4NZ/YS7a0si9sAZKGa1?=
 =?us-ascii?Q?odB8oSq0m9AN62EAXgdLisBTQCyih7dWQGd80FUmgxuaqoG0/Tfnjc4dGV4P?=
 =?us-ascii?Q?MT+VtanM5F3ANUUV+5oWwXRt2XyvVOHMJDiDkfIZtfkvkDe67WAXpAC6sKok?=
 =?us-ascii?Q?lpUdF0R/W4VVieC7IgAQRasVJDympioTuGrq7W30rCdIzaMPf7qhJHwCzU1B?=
 =?us-ascii?Q?Z8JxV4CU3BTYiYaZQfg9iJAUGZzzogbnWqniWwvwrEN47qEFfHwfZiMYZ9E/?=
 =?us-ascii?Q?CAANMOJWs7o6t1ARy+90yqc56yhh4o0tOxQZ2zdwao4VdV8GAzPDRuHEstnU?=
 =?us-ascii?Q?u6Yp4ih+N9U5ccanyYePPyi/7cLmiqV2NwHfiUDWjCzlmyIG5J55pc/HV2a9?=
 =?us-ascii?Q?HetKHt+rioKO9+DfKYvtoXNgDU+euU4Lb30SY93WRY9ymXq32dVYk6dwtq4J?=
 =?us-ascii?Q?9YG6rouqMA7jmoUzSqWQLfayhSTye4NYaqYy30w5dbuIRifDCkcmeFCLZ/1W?=
 =?us-ascii?Q?MFtaxUvNibcKl53TbRBlS1gX83cx7BIV8sQq2BIgftwMfkwMtxDcY09l7AGC?=
 =?us-ascii?Q?JFwjqI2aPjM74F0h6MI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 15:36:08.5477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acc023cb-672d-4819-5cbb-08de3befab0c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9692
X-Rspamd-Queue-Id: 1D61E20005
X-Rspamd-Server: rspam03
X-Stat-Signature: sttxmn8pft8zx6wt95j7quy9wgce4rt5
X-Rspam-User: 
X-HE-Tag: 1765812978-210675
X-HE-Meta: U2FsdGVkX1/KNQQwopVbnan9Pkkru7TP3c2chhtb2Ic4PAQDiWsY5OsqT2tBoyXoNAMGf9KxoawuwxJ/pQbdNntUdakTGYEQyGOVchJ+EnAxt16b0GeFLUDw3pQ8P0WaS+sYn3g4oGqdt1/rJErB19DRoyab7BT+KqrJzZKr9JK2B7YCWIrkJIY67Uggsb7qC8Z+zrKmtgNbqeAP5xh5HIPvWCSo85uT7yHkv+jVSgo+ZBdCfI6INuXf7Vb69gmN+j3gRlORVQT43R73VFU+H5zIO8V+qRDJIVTxZ9NSAzW6GxBoaVjTvmIJSqlXo4unMy76YyRSDDRHOB01i3O/Z0xb80LFfBPYnz/Fx8FHH0+QGJy8ejhN7OeS3e+7P0QGpUx/WC6EtEwcXgdADu8OrhVis1OzMuVtuTAcdIhTP1JYJEJKswwfb0O2aXUKku9T5K7JomwVCB38dooPV/JMNsebw0U9XwcsGIj9wQ1KLv32CeRd60FL2wweUNvB4CUwy8h92LiWtrgxCeqS8WGtSORmPMAGqOCK6ac8UrYpgFgGFdi/i5zUuXaN3b6GGtXtIb9kf/5h6HFA9VmxZpKpVa3kf9jTA22l3e97bgfq/0ew06dmK3EYuxLfh5yRqQlTOHUe8hinBBoZS5TqekI/QhRcUy11pAw3+qBfcVa/U/lyMqGPxNvMNzHB2Ut1Dw2Du7HgxWXZVdkjuQE3Dst6d1VFz2v8rtQ9zyckPsnFjBwZbx+L3kNhU4mmqXlaeFqWzeW0g/wrj2vX4Q3LZbTqPfIjnRpRQ8tpBkduabofImrxGP4xk3HRhotkdNaG2kgWzpwcbnjCBrIXqgNOOHAzKu3WM68kuLjcqz+/n59rtmNT23pQdAZ4VGbzO324V0WX/Xrd9vvtsdeW+Dfeqww8FIb9qQkJzez+rTDHQU0ufzsCUXJpoaeLQwSLNxOM9+maBlvACjFQPGIZypKHxDL
 PXymNTpq
 vngAShtvZ57+XEr20TQGvLyFFa1ZVg2a/0GpS5WAweO/mzEpwGOu8RXxmz+ybJ7Z02c102wP5thvLzJWcLlMIBcI5AZPSqumbkw1SqynCDmQWKVb8vZE6nS+x1h624zwfxoBQggCZj6K42QilfPR0v/dKA4nlK9B0DQWkwwPOpA3LRBgySZbz9xyoYDEAJj2o6TwN9jka159nV8rvGGxxjTx520Q9Ii3I/Ex/V08Lnjbzn70phBrgEsWkr2evguRxazLWlmLBaOkk5PhZFIrmSuHd1ngUorso0aAkhCl/3QRMTjoAG/z/QLmaPhLKz3g8mBhJS6lfEcNLjKY2w73Fryzlz+4bAkPXrDS6n6MukO5JBpaaoJQkhhgF/ZOg9DZ4UcOREDpeImckZlxoh/Cd3OJMNij4tkoWMA8Z4JptILW+VJSHbVb/RoW56NmjSDKIsXlKhnG5Vl8D1tM6WH/XJw0NGEkLsfZ70U3umAHF0BcWrqvwClOg/S0LPWNM8MV4kXgMDKiI9plMYnNUN69I86tBwkb43j73nXM4e45wXFKXmThdaAQfcYxnxy6a0I+XaUSSVr53BdX96+s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since it was never possible to use a non-PAGE_SIZE-aligned @source_addr,
go ahead and document this as a requirement. This is in preparation for
enforcing page-aligned @source_addr for all architectures in
guest_memfd.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 5efac62c92c7..6a222e9d0954 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -156,7 +156,7 @@ KVM_TDX_INIT_MEM_REGION
 :Returns: 0 on success, <0 on error
 
 Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
-provided data from @source_addr.
+provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
 
 Note, before calling this sub command, memory attribute of the range
 [gpa, gpa + nr_pages] needs to be private.  Userspace can use
-- 
2.25.1


