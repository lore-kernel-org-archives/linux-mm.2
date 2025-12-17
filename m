Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B8BD66BBB
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732926B0005; Wed, 17 Dec 2025 17:58:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E04B6B0089; Wed, 17 Dec 2025 17:58:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B526B008A; Wed, 17 Dec 2025 17:58:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 428CD6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:58:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D27B88B9EC
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:58:14 +0000 (UTC)
X-FDA: 84230478108.05.E648996
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010006.outbound.protection.outlook.com [52.101.85.6])
	by imf03.hostedemail.com (Postfix) with ESMTP id 18EBA2000F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:58:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dADVea3+;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of apopple@nvidia.com designates 52.101.85.6 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766012292; a=rsa-sha256;
	cv=pass;
	b=v/50GoNWfYyn6X7sufpChHzgMUizl+WK2GCt0Z9cneI9UgcClpqWbD9gUqGoOCBr3V5a3/
	pAXeM5lrtsYKnI5ZiomILufKJmHus1No6Fgl9XoCmbzbHtXJbSJK/7I9ELNK8a3jZw1uxH
	P6PK5RfKEhcYuF8bRG9v1Ash1JxkFv4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dADVea3+;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of apopple@nvidia.com designates 52.101.85.6 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766012292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmrssDKL/R+xaRje9k1RYObSvrlsAncqFdq0/E4otS4=;
	b=bgkhQ9sKDdsV/s7dwluesoaDIo5yr3ONo3Alf3OVEY1aANPeI/YD8r/6TNyX5Kr5g6z9/5
	tMRjyE9qaWvvuPqcTdTNOmpq3ZZ1J5OdiM6CqCp1w9sUYYf082AqgXeLFQ8vC3xKIDO6hm
	8Js0mghK+fR2BkF/BRcX0DHWsr272U0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=at6OSkj6ZCROkOspCQQH0zNg15rQI/420uBdINk+ETLu4cKsRcr+eqZtaAGUxdf1OqK6Hn1cg2xlGKkxK+fGNuNbDSA/PXwsAQWYFdNoviaYyCwfXrYRZAwCzIwYlqzaLVr9zEgyG5GIiAkY1FPdTye9QGDl7uPapioqKfIKsWZn9KzSCk7POkKG06sGKPFmrphRmosO0VJ/Vw3Q/w9Wv9IkLN1/Eo73m1QjKY64qjHPM6n1QxnSQF7oW0LJ9Zim7+vWa3SXi7SvCAYdik1/Xoniek1v6htBavAhodEv8CCkDSij/R8PuHEZiKukFwgkqwLgdXe1NAjGZYS0ugLbyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LmrssDKL/R+xaRje9k1RYObSvrlsAncqFdq0/E4otS4=;
 b=wYwapTsbqlXZRVHIRXYYkFqPHn5ZNrya4CMtyaMUsA278VWqQwIPx8G+lLfjg81nK9eOMzQ7m+qcl8Q/eej/iN+wqWKdvYwF2cX/XotYP/LomU9DCzAwy8XZnTa4DAdfRJgmIAgIok+2wQPnH6UL0bHBxRRlwheIMWxLnm/9/qdhmegkHQHo5qfWIlXTjosn52iNqJM5/u/MPwSKBLQ259vQCeiLfF1ex6gBTWpFH9Cf0L4kzXhi2R8ovdy64jUkiEwo9CInj4m4FxR9/6ue8XMYtqDXzfHdbI4YMxsGL1RAmuJU9ROw3rOp4qT8At6NKKGVMe/mPMa/gPN3pwRcbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmrssDKL/R+xaRje9k1RYObSvrlsAncqFdq0/E4otS4=;
 b=dADVea3+2MbYKMfteoD2Ad1derZIJRjlR4zdgTkKnA28jID8rgF1c3Mx/xn//43OG30RRmMLv2mwSiKT8BglMFhm33qrAZ5fT2aTFfpPWya2eEIzUp161er3kB9uDfLohaBPD4xgHlnI8z5VuQ5Hgj7B4AZmD7CkXy3J3635t0Srdm18h7mijU9IcuP/FbuBnZSa3B2uXGXM42duIktfHa4mSr8HVmYSNfKk7pLumCEEx4IgkWUTCg+n3dbGQKUhqhSVXr0nPr3rWKBUdq+6NgcJIAw4B/1+2SY+8jnHI9HXioR42Z45utXY1bIY1B2TeoSUMR3er7A2xCtcvasN5w==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 SN7PR12MB8130.namprd12.prod.outlook.com (2603:10b6:806:32e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 22:58:07 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 22:58:07 +0000
Date: Thu, 18 Dec 2025 09:58:02 +1100
From: Alistair Popple <apopple@nvidia.com>
To: John Groves <John@groves.net>
Cc: David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	John Groves <jgroves@micron.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Gregory Price <gourry@gourry.net>, 
	Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [PATCH] mm/memremap: fix spurious large folio warning for FS-DAX
Message-ID: <74npmrpzagba2bbye7kmwwoguafbpvnkxarprp3txy4wmu6gxp@japia7ysaisi>
References: <20251217211310.98772-1-john@groves.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217211310.98772-1-john@groves.net>
X-ClientProxiedBy: SYYP282CA0009.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::19) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|SN7PR12MB8130:EE_
X-MS-Office365-Filtering-Correlation-Id: 640c6d32-bf37-4d39-2a78-08de3dbfbe3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hOV+DBeoYdZjimdbgLqxkh0SQrtiZMWxItK13ybIFBpYkQQPIulLVOioXOeH?=
 =?us-ascii?Q?5TZYsPmxVV8vd+xR+spkGnJ/+Yo3N07oPfaOWtTVgDBNguXrlXlftAI3MPU3?=
 =?us-ascii?Q?EU/ZdNljEXFHCVPfewKYB8twiSCLDL8gq/M6tDxkGuqHlD/52T8MGm7w01cU?=
 =?us-ascii?Q?GFHsU7dcABQ6HgnLLX4m17vAXeJeskUn/woXkjbsOyAKAnE9X3evvX8IZQmC?=
 =?us-ascii?Q?1UHawyqzNzY9FF6Ela2DJRPbl1xaWLR3Hni4kkixM3VI4CqhClCsb8j/YCxt?=
 =?us-ascii?Q?gnkK5g+8TabeproH5+UCuunf/bawPoHA7LPb0+UP3NYd9oU3ELQQWdzabHPb?=
 =?us-ascii?Q?JgrctFXizft/fzYQW/ZMdDj71pTyknhfIsT+RowGrEBKBOFvO9M7IxbEY8nc?=
 =?us-ascii?Q?RgFN3ZfN9Sb9e03rEqqwRgjX8FtU60ovqqDgKckkOytqP9NXweZeha2CdM04?=
 =?us-ascii?Q?3+8+MqRxSF5ekR8/y856UwIPe4QeaTD18s7/rOOZpfRG9BHNxV7/NVjMm/Tc?=
 =?us-ascii?Q?SsMiywThEi7hnH2YdCT0VvqeM5v2EVOgqIzp2L7GneYfVrJ+am0QpGNL38Tu?=
 =?us-ascii?Q?nqeTONsSZzfLk9NTdyZtySlIvqj60quwzaQz/ZjKD2QTSID5IDgaFGvsZNmP?=
 =?us-ascii?Q?zE4zo6C7CIsxcJh4cA+dG0/jVzTDdw5sk594kfz8+sxhO0sepRhaCb8flC/c?=
 =?us-ascii?Q?Uyd/HwsQZ+YgegdFJvmcZTIlLnOQ3xPGakpTQzTeCEjYkkkr0t5kRDEkLyO/?=
 =?us-ascii?Q?FH8vYQxKGF+zwlaPmOhiQzD2PpX18aKPVAtI/I8ZhWnduDIjoLGDoXj/FhZR?=
 =?us-ascii?Q?wFDerc2j7+xCcPaG6U+LIKPKNxe2DsVhITfbo7OCKvwbNEKk80Ifz4fT0PHZ?=
 =?us-ascii?Q?q5+uIT8d1Me3ZybHpCSJLD6hbgm4r3e33jLJZjsG+20GRrk70bR8x9RkjIHN?=
 =?us-ascii?Q?xLVJDvpbcjQIdpFXtiv3Q+DPwCffHiq0OLJbuRdKmffn9Xd+/G0wgEe/NTTv?=
 =?us-ascii?Q?N3I10xXBWk3lJEw/9c63afEpWfvPK07YQMIT3e+VMVR50TTNu7mqKP/tgeTy?=
 =?us-ascii?Q?T8F3666vxpDwYH7f49zWh3CwacyZ893LbbrB180jNEsaCPytKRP7VIXrP5nx?=
 =?us-ascii?Q?bisCZ/cxpAsVLeLxl4Mz7a+/JQ2TvDpBzFX7HR56F4BXyY4Frc13M7m0al2R?=
 =?us-ascii?Q?b6Y0g6p5fcmbPuZTDcGykHEIko3WKlvQplqLCjrE/tEmQeYd8BMUYJ5at0vS?=
 =?us-ascii?Q?C559k0BW6k/eRPDQPs5nzt5u+AdFvWzVawy+HvdfcuW9RoR63qR4Fa4pTeUW?=
 =?us-ascii?Q?Wgdk1KKmYtA1LOqyD1Z2Jh090WzsYDJgyOxUpX/WLMWpDudtBPb+R4xL15iR?=
 =?us-ascii?Q?idt0ziHtoSR3SWWKIlamVgEsXvkq9juWgjDGDB21xILElHyFx3lqVormWmpU?=
 =?us-ascii?Q?jZlQ7IWBQHiZudfgnBaekezzSAYbr1+B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lq3XOqdhhIxOWn+Ds3kEpqTuBmqocUYXnq2GLr9vsQNLr0EfZa/jhrQt2uCa?=
 =?us-ascii?Q?JQq+uWSXsmNQJzqY3MdVZ1deGgad8WKuEby4uj0l7JfZg9dVk6F01mIDDf8/?=
 =?us-ascii?Q?aG949DmMExRInYZqEvgJfDkMZ1VAZCRWYfP3WDbjgJG25MVw2Mn3ynsbeIfc?=
 =?us-ascii?Q?kNhdKCgRrMZsWh0PJE+0yPFn3QwI5jU7kBY3qIvTax5vZxgGxoARb4MMUNaX?=
 =?us-ascii?Q?6Sflr2VIaHcl1BbCIIXbvd4KMXNTli2UOZoRN8YFpKAn4cCHisElfhwE/F/I?=
 =?us-ascii?Q?zUiWV+F1iQxiEIl8e9pHZKCzvUrJPcIWtqQ6aX05wu+LjPdFKk0i8t0VfJHk?=
 =?us-ascii?Q?fZa44v/3aR5dSjFNgHfS3QfSDf4AjRDdwPbig3rgLonrwgdDmF6dPn9roeZP?=
 =?us-ascii?Q?5JOoQm3sB5d36q/gkAAJPXEnR1+pfw+R8nto2mAzUmQZUYIsNX8ZHtD87tUp?=
 =?us-ascii?Q?jBg466L+7WKhbfrQIDYvx5P/QFiyH8HDCNpWRqn2u2a/U7Vl13IlJqdvCilr?=
 =?us-ascii?Q?dugtJhbzF+H0K9ia7gcH0jSLffbRluztq6ImcWxncRab5sqOG/cQ65Hc4+LH?=
 =?us-ascii?Q?rwxuceqX+b5TYKnlgCX8vheXbPMiutGnEW7BSdGWi8me2AE7Y6Xs3FnGUpKx?=
 =?us-ascii?Q?ET5UoXNXQU/Lxcb2b4aPQCkDXcbEWxKzBrZ9++X3spiff0FUIjzd63ybrA6h?=
 =?us-ascii?Q?ffNrmRACPL1yV3f1Qq/6jkU7CICTULK8QfUVDj8GQTMy22ywD/e2nrVTj6bq?=
 =?us-ascii?Q?1aS4plfBKAP0u0GejA9gqU4avnAk2FZC6jFi2TDtjJDXm5vUfUiNnPhLCInw?=
 =?us-ascii?Q?LGj0AMMkvMZ7el0hUm7zJgjP26I5/m+qHLFP+Ess1T1ABT4M+DKDO/dtQ3Gr?=
 =?us-ascii?Q?6xllRVPkElV9ydfTB2cQ7XBH3wMZ9s83T/XtATOc98ti6ou8DqLA1zPpsFVr?=
 =?us-ascii?Q?4RJ709CXwc9uhRvj7WSpKgDssIYvqjo4UcKfNfklQ4H+fSKMU5y7MfxEkbVQ?=
 =?us-ascii?Q?/gcYbzT8O+83YNKo4Y0Gt87Tw6pyYY4u3Gq9z939z3g7ypYcxvonWOP27GPN?=
 =?us-ascii?Q?W8D9UqlUReRQBeOA7+wvkV+91VrgbBxuInBtrOeZQ2gjpy1qIqLfjTmZh0+p?=
 =?us-ascii?Q?kmA97KjwlJdAE5YYuAuKavrz20AZ4l3kLqnPxksIT/Wgw4m0fFcXp674Vtkv?=
 =?us-ascii?Q?FZEEqGldyJeWSFQnXw03aQw1wfhf9JYo1MV5OhLsJiBFUbt6Z8/CUeHThGkX?=
 =?us-ascii?Q?NOizvVYUaUU5ee/bJ0GF4Q3zaKWLZV3WCGNSYeyhhkNJUEUg+x7KwWGO/vvC?=
 =?us-ascii?Q?ojZkCI5d/3rLMchX/qVIH4weGbGPAciltf9sTi2CnU1u9Uosbg4fQ7+51jjb?=
 =?us-ascii?Q?7aDo/34iZrpDK8cXiYCVUDJpEn2jEJ304lL/NEKUuLkxBNi236WrB+b1q3Wi?=
 =?us-ascii?Q?+VuMeUhSnI6zcEga8x75aYqe5OtJ/Se97WjuBBrLhCLWnw935UcwUq4kchkZ?=
 =?us-ascii?Q?WJwd1Q37Lea9YAXBgATuETsJGrGJeJV2NoAjKjSczHFrATOQC4tbLEaWHsIQ?=
 =?us-ascii?Q?x6an7o9HS/8yYbtZonQ1j4CeZCoCpa1tbLHGeHet?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640c6d32-bf37-4d39-2a78-08de3dbfbe3c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 22:58:07.5778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PeZmXMNShQWRUuq4r3CsmH2XsgFtBm86MYcEewbxuqKdkSnT8b6OqlidNzF2Zf+SX8HSIGyj8rEPth03RbOH0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8130
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 18EBA2000F
X-Stat-Signature: q9eqihre7rye5mb4jj5uan9sku5e5piu
X-Rspam-User: 
X-HE-Tag: 1766012291-751596
X-HE-Meta: U2FsdGVkX1+MPOYvggna1kTKhfQYPyNP3g8RfaO91bHHt5FOxWri66LpqFp8gWhLxuvIk73zQ7vv706lbxaSd+zya8i/kRA9cQRGhmrbowWtXLVjKeonTLQfjXt0jicg5EnCuGsBXrayeaxfB+2spp6nsax5e4QKmaq8eWJAqekFUzI4z3Iktv17q8sZKaJZPkCq/I8NneP+mWx+kaUyXfu9OKA20zadZqzVstPPdKO6YdU0oNf66lEopYM4kRG5BjVYj38B2LB9C2077LiNaoXX6R/xjx50ev72Upi5cpNbRzh38H+7KwRWkKIT7ix+x7GuOfy8PuSCDMtAHe6kYwa6VGmR6XEcC/E9VJeUUPc71CklFfken2c+ezoi59QUnvF3FEFYgNM5Fcj7117ciuEKwwEws0wdRuiCf/TVcm6qAxexZ8SoWiqMUaSZf2n0b+lYbRHUM2g3QxiVdiDcVkm9UF+vwjUFRH80sMLiZnZs2kuHo1duSoZyAxss3m2ltTw6yMELGqquByU7H9ynX+08D0TX+r5vDgIQ6WQAMk4a3E+HX/y2MxG+k9VIdgBaFJpGA3F2ZOLxRNM+12Ji6+XHpVjHHnRoMbIo+GeYXCVCYRaRT0brp43ciVNcoUc2MZCZto/PeJuaj4mS3wuQSASTV46BGoWgzaEkKoJHXxclyvyvFUCS9xNmetKIt6yStCA+EFi762OiICypauit3CLSTEU2DySmrKhTuTjrLYetWsjlxJVBvi1K5ZInEfYnmDBN4h8I5hasLaQlVU4tNDznZdJLOLDDtBogs36aWT1cHv408OMWNzbZEHmaTG/6K6E612yM2E135KDwok0gwr0uefcRG7ZQAbcBLQ+nBTS8mwH6k/5viixqHFaQyNFMQVAFjeS68hAYHnlz1o0VYurZ5B+5+KRoJl3A6PptS0G0o+s/E7nrUSwDL8WXerdfPvE6zBFDFkYvP6QMEzI
 fSyPSzdn
 R2gcM2N08D95Wnp0FakQ4jWobXzWosFYuxm6zmyJWERRVUYtaSn/SouyXqHzXnWAHmnYRgBrYKx8uMMJ+5A91wZhgr02FxNRcCXmXKW44+97qDAkBVnaw9Yunfj2W/y/XtIoQgqwn9ib/CKPabbKswIukAf54ZFj4pYOhcpu2nQUUwfrxExdqkCAiekgLJLmuMRXvH/bXwcOIvUw10OiP3vV6A0VMbkw7kRXzKTocqWzXcad+bRGZavRn20We4nRk+xXI3+aia0hIsfcNdrrP70J9ITPJMArogNBIKf3cXDzmiKd//sb5zaStpmvZc88scowfck1bLl/5NV8UzXBkRBeLUHTg2MhHkzt3xYSF8+dxJ21BIRDi0LzD6NHnUgyqD2ENmlXRYK+jc/CnB4CTaoCZ4WR3s5LbjEyL+eWknAxOUgKpFTuG6sCvH1yFo3zFE/tKb1hK5eJpKJjHU1SKHzTcA/xGV9zrh4fBqbakdsJ3qyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-18 at 08:13 +1100, John Groves <John@Groves.net> wrote...
> From: John Groves <John@Groves.net>
> 
> This patch addresses a warning that I discovered while working on famfs,
> which is an fs-dax file system that virtually always does PMD faults
> (next famfs patch series coming after the holidays).
> 
> However, XFS also does PMD faults in fs-dax mode, and it also triggers
> the warning. It takes some effort to get XFS to do a PMD fault, but
> instructions to reproduce it are below.
> 
> The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
> free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
> when PMD (2MB) mappings are used.
> 
> FS-DAX legitimately creates large file-backed folios when handling PMD
> faults. This is a core feature of FS-DAX that provides significant
> performance benefits by mapping 2MB regions directly to persistent
> memory. When these mappings are unmapped, the large folios are freed
> through free_zone_device_folio(), which triggers the spurious warning.

Yep, and I'm pretty sure devdax can also create large folios so we might need
a similar fix there. In fact looking at old vs. new code it seems we only ever
used to have this warning for anon folios, which I think could only ever be true
for DEVICE_PRIVATE or DEVICE_COHERENT folios.

So I suspect the proper fix is to just remove the warning entirely now that they
also support compound sizes.

> The warning was introduced by commit that added support for large zone
> device private folios. However, that commit did not account for FS-DAX
> file-backed folios, which have always supported large (PMD-sized)
> mappings.

Right, one of the nice side-effects (other than delaying fam-fs, sorry! :-/) of
fixing the refcounting was that these started looking like normal large folios.

> The check distinguishes between anonymous folios (which clear
> AnonExclusive flags for each sub-page) and file-backed folios. For
> file-backed folios, it assumes large folios are unexpected - but this
> assumption is incorrect for FS-DAX.
> 
> The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
> allowing FS-DAX to continue using PMD mappings without triggering false
> warnings.

As this is a fix you will want a "Fixes:" tag.

> Signed-off-by: John Groves <john@groves.net>
> ---
> === How to reproduce ===
> 
> A reproducer is available at:
> 
>     git clone https://github.com/jagalactic/dax-pmd-test.git
>     cd xfs-dax-test
>     make
>     sudo make test
> 
> This will set up XFS on pmem with 2MB stripe alignment and run a test
> that triggers the warning.
> 
> Alternatively, follow the manual steps below.
> 
> Prerequisites:
>   - Linux kernel with FS-DAX support and CONFIG_DEBUG_VM=y
>   - A pmem device (real or emulated)
>   - An fsdax namespace configured via ndctl as /dev/pmem0
> 
> Manual steps:
> 
> 1. Create an fsdax namespace (if not already present):
>    # ndctl create-namespace -m fsdax -e namespace0.0
> 
> 2. Create XFS with 2MB stripe alignment:
>    # mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
>    # mount -o dax /dev/pmem0 /mnt/pmem
> 
> 3. Compile and run the reproducer:
>    # gcc -Wall -O2 -o dax_pmd_test dax_pmd_test.c
>    # ./dax_pmd_test /mnt/pmem/testfile
> 
> 4. Check dmesg for the warning:
>    WARNING: mm/memremap.c:431 at free_zone_device_folio+0x.../0x...
> 
> Note: The 2MB stripe alignment (-d su=2m,sw=1) is critical. XFS normally
> allocates blocks at arbitrary offsets, causing PMD faults to fall back
> to PTE faults. The stripe alignment forces 2MB-aligned allocations,
> allowing PMD faults to succeed and exposing this bug.

Thanks for the detailed repro instructions. Not always neccessary but definitely
nice to have.

> === Proposed fix ===
> 
> mm/memremap.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 4c2e0d68eb27..af37c3b4e39b 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -428,7 +428,12 @@ void free_zone_device_folio(struct folio *folio)
>  		for (i = 0; i < nr; i++)
>  			__ClearPageAnonExclusive(folio_page(folio, i));
>  	} else {
> -		VM_WARN_ON_ONCE(folio_test_large(folio));
> +		/*
> +		 * FS_DAX legitimately uses large file-mapped folios for
> +		 * PMD mappings, so only warn for other device types.
> +		 */
> +		VM_WARN_ON_ONCE(pgmap->type != MEMORY_DEVICE_FS_DAX &&
> +				folio_test_large(folio));
>  	}
>  
>  	/*
> 
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> -- 
> 2.49.0
> 

