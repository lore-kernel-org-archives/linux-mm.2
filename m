Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8148B606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B02BqRls
Received: by kanga.kvack.org (Postfix)
	id 750B06B00EF; Mon, 16 Nov 2026 11:45:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9F96B05B1; Mon, 16 Nov 2026 11:45:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B446B05B2; Mon, 16 Nov 2026 11:45:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2397E6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:45:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4415F401AA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:45:52 +0000 (UTC)
X-FDA: 85441558944.09.06F418E
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010043.outbound.protection.outlook.com [52.101.56.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 57B3D1C0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:45:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B02BqRls;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794847549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4c03tFqMIrw7oB6ZmYERtCainBi5gWGwxqmc1diN8O4=;
	b=pvw7nf4EBDvmlLQieNB/vjZP3MKhFB1j/DneiocGyY+rmtdPi5J9CsJWErhHuyFGAUGI9B
	Kos/SDHx8NKMxgl+hGQliC944oOz6UoFPwXZgOX732gVA/N93GoHG5yaZgGmDYf9VmPpmY
	DQfzDu9uGHsZ3fnaUyJBhsLd7uQcA+w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794847549;
	b=ZdBE1xMI3v9ATLtJNZUIIpogLhA/pZqmFGg4JwYnD4UJYPAVTYKu0Mmcb4dfl60OP7a39s
	Ifd8rs9HhCgp2xrbYI8jJb2GAUq2Y29TL1h46/o2hlfupUKgFST6HA+0RoTTvHrCb4/mBx
	BdtkveEFB+dg7oHCaDTR/5Lf/g2Srrw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B02BqRls;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5Eot1Eu3GeMVvmEcX2AM1nsuemPTEXeVEwFxqSqsRM19XYbhuksNq4z8jl5VRBRfCWIz2w9x7chIUmY5M+wUVwU45TMUd8G8C8ck6J4AnWYNERQLFB5ltLpDWrmTITrPgXG/Ooho8W/Ttl9Ayx1a1fEGwe81kQiRcZqnpl5SKBVnX+2UdLUFZKc+oJ2py5bOWeuCjIfhupgvAXpjFH82EnS1bddbU+U1g/4O0iHnuxdAefqjL0hQy0+jpmmPoIJy/+sKSMfmd1+fxIIKt85zooDDpc3CDj1T470Xu+w0sau+PgpAEKLnh1ftr9dXDet1kukqa3d8kS+B+wiFSuaHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4c03tFqMIrw7oB6ZmYERtCainBi5gWGwxqmc1diN8O4=;
 b=EQrN2ydSJT0YExSRfoiOFi75iiiMsmKizrTW5hS94eSu5ms7mqwQDikIF1JoFTbnRiS9fV9QaBcXbGEvhEHs8Y1W3TR9Zl1H1dsaDLYDl6gghm7AQawShuMIYuRu2xqg+tVV9jx+XwUbatJAQqRcsIlTPgIYH5SyM11/XtOaBIV4n3Qo6Rot5EWtmBhakBjsn8gq5LSXrQf7z/QiIIoLEsPduJtWe81araaJuxuMvqVYcEznxkZZuuExOwejs/xlsKFypukxxeO+u/EXT8THO4h6UsPEAPKF89rCvYEKErz9PZ2f+63LfSfMgrQoqb0O7qmzCMlN5e0phcwypqnzcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4c03tFqMIrw7oB6ZmYERtCainBi5gWGwxqmc1diN8O4=;
 b=B02BqRlsEsOgZ7j0rVRQmzRkmEszq0jNe/95k7aBn2ibEDTMC6b6J6qmsxRBrCE2qSGBGG75Cq3kX3rKCb02emkRXCNJS2EM9fZtUqNJCbna54jWXPSVpulksGgyTih/5ydIk+W19bGYLSse3H3IUjT/AmkS+440j3Wn9hA02tOT1mjleg3Sc3b+Ehm2v42Sj2XlRj+Hc6tkWQsqJaPZpiu39RFl0G7e1k0SRX7v5oCJJjpcrnBqQ63oMWJq3daDe0P+WUf6dQy/LwznqDGZMAS6SNEdIjBKoh2/Qrms9WthypAq9uj0HzKk3XDqq8vOpNhziN7Nw9SzrsA1+epU4Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB999298.namprd12.prod.outlook.com (2603:10b6:510:40b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 16:45:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 16:45:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
 Ross Zwisler <zwisler@kernel.org>, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Subject: Re: [PATCH v2 2/2] mm/huge_memory: flush dirty file PMDs before
 removing rmap
Date: Mon, 16 Nov 2026 11:45:43 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <5DC99532-F209-4F1D-A70E-F4D62E2B4666@nvidia.com>
In-Reply-To: <20261116-dirty_file_pmd-v2-2-571883053174@kernel.org>
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
 <20261116-dirty_file_pmd-v2-2-571883053174@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB999298:EE_
X-MS-Office365-Filtering-Correlation-Id: 08f359ba-0712-447a-b5f8-08df44010f28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|22082099003|18002099003|261009223027099003|4143699003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261022105027099003|261021123027099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	GykEAsojEjtC7cNVWTfOjB9cjMHgQhu2K0m4AC6ndHrekTLsay/5dy0vSCjkCPMzZC+RF2GmEtORxTCXG1duamAgVwq2XkM0QLWcv06WwenMTS5p5do2pTD8XSm+UAdO6OhF1yfJLBt6vb6I/Iii1ZY6EulC6vk3rb6/l6rH4LB5jplB9OsX4g7PXwGU+9ScUC3di8nPOB5nJAxvesA87yCma4zDD/Om0vMstYlBER9+lmy+xY6SwEqhhnqrob8zp3Dschhf3ue0DwNoEnpAkQMB5yfxtR1YdeHWARjw1SGJlwQ0/43tEl0glsdAUof36Fon3oFVfZ5JFXmTwXLr7Db99Xj8d2ow6APrVfr5h1UWQYyOPho9d4WvqEZZsnhBuGPskvLiUknabw7mhUJjrEXxqhPznyBPH/agvzjzAUq/DWUEdvQyQOcmurX5XbIMkGKA6EpsNQzf5ZFY4wYZD6RbwuOOU55DWZnjPrXmhwsc6RPplyjkZp3mO0QJoZ+ofJQd5hIoMiwYPIgGplcBOyj9JZMVOSI5kdBcdxy1CyQky7/Buc7J7IRLPKYp/zBsEEUKiDHQKWx9+ZXMVBJ0QAjDkZgbfveuBUIyMrCDpPJifDXAuTCmLjJFUmLv9IxXNb1tEp7D8NG6clLPxnWtcE0HweHzDwz2lDiWs2f0cUE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(261009223027099003)(4143699003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261021123027099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VETmHBsmMBpnCPv88huVaUV0krvOTx8WO5/4vS3spSfDA8SNZ8t7g7VZAyqz?=
 =?us-ascii?Q?EPJn4lVAM+1fCubRkaMgRH1B6aF6RG5iWQvByZC4JpfAsWDqNB5oPifo5b8q?=
 =?us-ascii?Q?mVbIub0MTNbSYancKbqas9KhJVz24YHaMIV5R5QA1aa2YwTSLIsQir+MF72W?=
 =?us-ascii?Q?3kAhazJwAmy7/I1DoCvztch8tQL4FTrRQaJFwbMVuzWoxp2XohMza7n6ARtz?=
 =?us-ascii?Q?aygLkJ2Nk3vgpQkrbPcFG7h4jbsByFEDeVNLMpYzJ+V6JRFbsO+MtD3Z/mRF?=
 =?us-ascii?Q?JjLYqQsSQbPQhEa+Sl9ca1g/bdALFg0wrfLCrNSznxwV5nrEnUU8uiNS7wyp?=
 =?us-ascii?Q?IFuspUQMAyay9UMxNRrTVROqRxtAdpVvFe0Uky/kJqj1C/M3IStDu/jN5NR4?=
 =?us-ascii?Q?SoMoKSLgDnboIZb++HDKNUxvDFrH1/YmbYiau2nybj/KGqQEVsHoLEE2sdgj?=
 =?us-ascii?Q?SDhZdyVeidQu6aXofUwYRA1ZgkKTmMFly/I3A12+wbcgHBiprtxp1ovQycyV?=
 =?us-ascii?Q?0wpX2JazblD+FBY+BA4LpXrw4ELCBirqab0rkWRJXjcyjLAenJUCmlEDOfqe?=
 =?us-ascii?Q?2jtmoHWkBgzwit6dnVdpuMjxbuEKLBgUidAIynxggyX6U2mbuLOvA9eUz/4d?=
 =?us-ascii?Q?lRgxXnq/uXjmCV9V8uUCSmd+GZvrAX4RCZW7qL/sIbIzpq2GTEOKW5hYWC4X?=
 =?us-ascii?Q?JAsWfxIx0K+jL0R7n8syNCtkpG1OJ0r0zhbrGz4AwGuWPD5MvH8X/uRUux/o?=
 =?us-ascii?Q?Bv9ghSiFwvu7yIRLRODx78RmPUGQI50G8Lpq4FP7F4hAGHsbsVoz1hgm7XkV?=
 =?us-ascii?Q?YOl2y1bk+5Ux2G9Plk8dXInmLtycnuEic2CEF+HewzpSdfclx0bAox4Ud+v9?=
 =?us-ascii?Q?+LbIVFfXTfdLvQs1TdM/AvQVKz51KsG9RLiXsJtdIrVYWwCaqrZ3TMeztxNt?=
 =?us-ascii?Q?GtXWJCpV4Gc5RmJYy6eg9DAjvDnn1QkHlbF5gkvCM53wLTzvOmrboogHLI1G?=
 =?us-ascii?Q?rInCM59kVwXVmFsaLRM+iePLbtHJsbCGVhPzZZMk4ThYglGhil8GwwZ6JyS8?=
 =?us-ascii?Q?x3MB5T6/KdCT5ro3kntK2sXqDApJGJeHcHMC/s7MpBNIKMcu7VBjoHjrqMhQ?=
 =?us-ascii?Q?uR5lzjsHatEnk3Rpu8eo9bjTbknAGNqnysX0mpeKIAtXYHutkSaWruLtzypA?=
 =?us-ascii?Q?tNbA0dvjFX9LS2rlyThNBUENyH64eRJaUzwhdWaEOvNL8/4NArwqB+B4WTVG?=
 =?us-ascii?Q?DkDuJiYuflS6LRazd+yfkrn2h0DbSEOQJ7LDpp6H+utQJmDEN0ZiYxWSKRki?=
 =?us-ascii?Q?QKIVwQBDo3ZmVX7SCqcFMnbkBUDYoV6KYgoKxG57zddRZXeD9RbwAVG2bkKz?=
 =?us-ascii?Q?diuHovITjvnXIoCtnvaEl1jtNlpmVLXg0A7XF3Ffxni134XpWD5aBlAmkPmW?=
 =?us-ascii?Q?FiXd83s1rfOJMVEar88yPmV8tNnSqLUTUITdmfkIMaTZF834dy87DCNCSIfd?=
 =?us-ascii?Q?OXAcVkNGe2Zq91XfCXU8gEKkxC9FZ27ilt/kwJfXB8etFl/tNCvQIDfpQ36Z?=
 =?us-ascii?Q?nDL6mjPLeYCRxVEaIKJ9E2NCUfhLlEY1UQvcr1GdU/cCNSNCJcT+dGv3yO+T?=
 =?us-ascii?Q?XkRaCyAvI1Y0ZMlo7AbHvgSyphcCNB5uOJwa0GOo2H0HAsTTLz6BR0nMU5CX?=
 =?us-ascii?Q?cDp1K4i/S9KBlirFxKPjnA10AhuqQosWq5sOmne9b54+Lhs6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f359ba-0712-447a-b5f8-08df44010f28
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 16:45:45.1198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QmvDBpiYGQVx/bkfOmDB4Yu7Gu0Ll+ElozoBTfNAfTmK7RCfPtkAQbq8izbFw/R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB999298
X-Rspamd-Queue-Id: 57B3D1C0002
X-Stat-Signature: fhb5fqake3shicz3sxyoefwcyn1k5wxx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794847549-18955
X-HE-Meta: U2FsdGVkX1+ORmRvi1G9rVd8BoRF1JAHAEixMFd8OIoKl3z7ZFY1//YstXn5myuBgNm+yiyUMf1p7MYEhw1G7/PNzpZAVj8MvBPNgbiifIFfVwpnVOF5h0hWtIKDWrRT3C+TyQjXtFjw5LAyoQT3y/EQ87Pr6Ex8vynHoVJYrJMOYzSRxP55fpaVZn40IVajBlMtVScWe84zWpAs4b9W32cfDWzt35xGeCVEsuPQu4l9/4n4Fm0pRQoOvUK85+c62uEqAwhEZqs6fOEPddUv3LbH0SXR3/bcYHvtMdX8O41Pely1nQl/+Vblq1DWHk082z4ixxqgVj52JSV40A3o9gW73YQJbSGMxFRHiv2oM7WthsNYXQsTzB5S2n1bcZdepHE2gQokig1qhH9PhHTTnSbYg8pF9aC7cNisFJxYEWu1uIWripdejWIT7dcXQUpwnqGbPz52xgRb62OKAWmvkn9k18NzM1PHap/scVSZlgbMPAq64enCch5OY/LBYWwI3icGpGagefPj9B2ER/XzqZQhe6Iq/d0GClv7o07xuiX8NeMk2u5s9AE4K6hFV5ulDCUU8DK99Ex2EOYSTiPer/J1aBs77+IPnaRJxIYEUE+//yqTzDUfx6JVGR3DoA1EX10ruhvrhnRxHFHF2zpT/Md/F8ZBESRgNND2biwYLP4nnlDXog+J18EdK9YtXEuKdgg3qZvUxWwZ7Adzc/imgmtE+L1ZdtVAqOVDTczIKgNmAS2lYwmuTqmSSoEIf7ZC+qeqRLfsalLAHruAFmV76soQ+vyEJpvlza3nOuMMPr/mNkd7IMz/g8Aw0m4Ft2yfR9KBZVa4U7jPiXaSkaa+bcBvwy8WscWFN0A9WCjtvWCLJiwmRnBnPsjdwzqzpEaPDryCd2lljKQxAhkDSB88O2vfTEWEq7OIj4vM5f6RYEIaCbt82R1i22QU/2UPJdhDfyfPWHJNJsQ27VrsqD9
 Uz8CsgKq
 wSKmWOonJnUuZvQf/7HENuoFpQByF0lPdqgxURd4VckFCTgVjiE78ldXkjHASXUvv7PF9prC5zWmJw29LEHHeOcr/3+mop/WDrx/DrZ7s4oWir2hZBjgDM+kxXn+3XVWatUY/2jB21dmuEB7vkLCWWBa/HGeDnaHmksepiZCuygPcDpST6NuJHMInlfuX/aZdRiW2Exgu7GUYnV5ZH6bfQpwQTalUW9y1qq4R+5syYbMpxiFpvDyG4H1EVZPBfi6cPlRlUtMLSTgS8/LkDHaaBszxvUiVrPdGQratVbfpYVBUySNz4PR3eSki6mE+AOsKW4mZ/ESHcIN6gJGJtItcfLQgQNvcHXSyr/Vu83DL3kq56S0ksd4l4pJYV2/6Cp8olVZSortxUrtSZH9IbQlnSvm5XAApaB1zLnRQFWraCayL+5XIvLxX9mRZGJ2gxP0lx3UzA1MJA31kx266bNVITyMlHi/2HZeCA6/B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 16 Nov 2026, at 10:06, David Hildenbrand (Arm) wrote:

> Unmapping a file PMD can lose concurrent stores when it races with
> writeback. zap_huge_pmd() removes rmap and drops the PMD lock before the
> gather flushes the TLB. Writeback can then clean the folio while another
> thread can still write through a stale writable TLB entry. Those stores
> do not fault and dirty the folio again. Filesystem DAX has the same
> problem with its dirty tags.
>
> Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
> has been flushed") fixed the same race for PTEs by adding delayed rmap
> removal to the mmu_gather infrastructure. The PMD path still removes
> rmap before flushing.
>
> Flush the TLB under the PMD lock before removing rmap for dirty file
> PMDs. Skip the early flush at address-space teardown, when no users
> remain, and for mappings without writeback, including shmem and device
> DAX.
>
> Use tlb_can_delay_rmap() to share the PTE path's architecture checks.
> On s390, clearing the entry already handles TLB synchronization, and
> __tlb_remove_page_size() immediately drops the mapping reference, so
> rmap must be removed first. Make the predicate side-effect-free and set
> the gather's delayed_rmap flag when an entry is actually queued for
> delayed rmap removal.
>
> Queue the folio before the early flush, while the gather still has a
> valid range. Keep batching references and drain a full batch only after
> dropping the PMD lock. The early flush resets the gather's TLB state,
> so draining the batch does not flush that range again.
>
> Although writing to files through mmap is generally discouraged,
> unmapping such mappings may become slower: each dirty file PMD now
> requires a TLB flush under the PMD lock. Future work should properly
> extend the delayed-rmap machinery to PMDs and hold the PMD spinlock
> across multiple entries, so their TLB invalidations and rmap removals
> can be batched.
>
> Fixes: 4b4bb46d00b3 ("dax: clear dirty entry tags on cache flush")
> Cc: stable@vger.kernel.org
> Reported-by: Kiryl Shutsemau <kas@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/aoWw_iKEDLjKL2jr@thinkstation/
> Reported-by: Chris Mason <mason@kernel.org>
> Link: https://git.kernel.org/linus/5df397dec7c4c08c23bd14f162f1228836faa4ce
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/asm-generic/tlb.h | 10 +++-------
>  mm/huge_memory.c          | 39 +++++++++++++++++++++++++++++++--------
>  mm/memory.c               |  2 +-
>  mm/mmu_gather.c           |  2 ++
>  4 files changed, 37 insertions(+), 16 deletions(-)
>

The fix looks good to me.

Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

