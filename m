Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8627CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD6D8E002E; Thu, 16 Oct 2025 16:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DE08E0002; Thu, 16 Oct 2025 16:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60C98E002E; Thu, 16 Oct 2025 16:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D31E48E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:22:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D25213AF6B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:22:40 +0000 (UTC)
X-FDA: 84005100480.16.5AA1160
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id B0F89C0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:22:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=btwrNHDD;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760646157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9xQP9XyCZLqUTYq1Y8XH5nflS2dR5bys8ZFEddppgM=;
	b=LTlULAOPaKEDI7ui043Z18KtmRkzXI7iTUuC0j+jxjuqe46hhBgM2Y6i/yV5u1q01zKjHQ
	IVMI4JJK0eKBi5OcKQo8yT6peim0kOF3SYIcEFshiChtJmiq9auiRTRl7BvF/Q+8N7mYJh
	xprxQ0v6D6frVZerNJd6SOro4B/WPnQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=btwrNHDD;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760646157; a=rsa-sha256;
	cv=pass;
	b=dLPTm4QDPTgHrz38UCHTZ61exLT9t2S6A0siGrP6JEhzYiCnhdOGPyAZJsCRryX6JkhuXF
	ubnSdwyqHmgRU4xe0ovv8+RsZEFDur7Vz/3j5Rj/Xom/YuI7f2+kYyHQQEpbRPdpvisUoj
	sSQzKbfS8iimd5l0JRGSpnLF8wKGfHE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a7mK3JbfnCWBIoP430a5wCiGPlMvHeruCD9vKwn5G9WMqTUbTy2/hIIjdXD+3ifwpSgu6Z0RdlG14uSi7Hb2FrCkDLgBNpcOVlcBsr+xjLaRsOhkCVOoMOXQxOd972uolWbKb+w4i50CdCLkmb+2osE3kdZ6wOuLBhL9hYmrWbWZdFYzZ6BIBTRQtUcL5rdsBqKJuEml95arNoJtJRpKK6vzV1dHGvS9rNetYWg0m9csyWr5Xu8PLJ7R9Moc51PHtPLCVn8qHFKT3G9DpWAdbJX9glb/649+fEP9uHGRkWytuN9AcZkEBqKZaBlGMSuOHuZVZzLeYx+DQpfjIfTMwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9xQP9XyCZLqUTYq1Y8XH5nflS2dR5bys8ZFEddppgM=;
 b=vU/9CERYxTsqHg6MX2nzoagrbnegklL0hesg9QvRi83KC0YPAu5nI2XXMt6LmFcuKfUB++46gIv/Wj1Ry/FXRZlUGkP7p4GCIf2AOfuuZbBBJu5JzFag6YEofaQdkzY9xdiZVNXd62wMRSaRsf3IDWFyLH+vxjq/P9bWmWSNnF5BqyVHhat5mwNdh2sTYXM7AUH3fHBBersBd0OCiyFi1f8hQRfGdzztroHSbNSAWyP1TMYIzDNS+9sgPdko4pNjP6tNq1d3+bIWpyPGSUav3DTLQwOw0GmrXXaZjASD9eYhfx/hYWvIjRg3VipwUqvFMRpIODlEbLLGFxeIcg2TTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9xQP9XyCZLqUTYq1Y8XH5nflS2dR5bys8ZFEddppgM=;
 b=btwrNHDDBxEH7pug7RhFX+mmUWESSUJblaLSLQhFXIeSJnJY4OWkrKKPCIEIXEEEqYAEiCyYof9FoeVNjza8FAf9VGoh3Lv5VXefAbnK825khcTo3F/la73uaAY4wVjKcr1BsHS8RtC9L+vrofc7B7YcdQCTaqIAEiWMmNzP0fEIddH5Eo3Zq07vcNwp3kOzecIJKrft3PWaVHiDIxS+jiDGsu32zkIHfbLIvnkIhrtAMgksImYl0Kljb3fHdOTDzhAfB2+lrPRvJPTZFWmc5bbTH5+WUuD32qXyiOPav7BXHJ1sof/NfwnzlguBSu5wBm0j7mKBEllvl6rF/CG1bA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6230.namprd12.prod.outlook.com (2603:10b6:8:a7::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.12; Thu, 16 Oct 2025 20:22:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Thu, 16 Oct 2025
 20:22:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Date: Thu, 16 Oct 2025 16:22:27 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <BE1A9E45-A304-4A54-AA4A-C8ACF889262F@nvidia.com>
In-Reply-To: <99d5c245-3b0f-4b33-8d44-bc2b203a5a51@redhat.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <99d5c245-3b0f-4b33-8d44-bc2b203a5a51@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0569.namprd03.prod.outlook.com
 (2603:10b6:408:138::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c7823e4-63d2-4d0f-aefb-08de0cf1bbab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjZOM0dVbkRGNkc2THk3WXFucWExanpiclBhY0tsNk1KR0lvWDdUZFB5d3Jv?=
 =?utf-8?B?bFVYRGJOUzhUUHZZeFJ6Q1A0VFNjcCtDT1RSdzFGalp4cjd6QmVZUyt3ekxT?=
 =?utf-8?B?Q1BWMlpPTytZOG9WMWcwR0Y2WFd6bE05MUlXTnBrRFRtdzBxOXc3YVF3TG5y?=
 =?utf-8?B?NDZCRy9PMUJCVzROREg0VSs1VXhMcmZMa1lpa2NMeHBaKzEwTEcyS0YzeGNC?=
 =?utf-8?B?SFlFTUljaS9la2o1RXVuQnR3VStlN3dQNDE4bGV2eTI2WWJFaWdnZU13SXFh?=
 =?utf-8?B?Z0pjTWxFaDFWM295dnM5ZFY2SXgyY0xhVDJXcGFjNGYzRTNlU0hNWmRwR1VM?=
 =?utf-8?B?aDRJRFlXVFR1Z2h3em9jNWRWNFJlMks5SVpvZEZxYjArazZhTVo2cXFiQ095?=
 =?utf-8?B?aFgvYkNZVmk2QXV2SEdFby9lUkkycS82TUJHT3ZZNnZuc1dWYzc3M0dBTGl0?=
 =?utf-8?B?TkZoVE1PVFBmUFpyV1o1R21vTTc1NDdCUksxclhRUTZhSldqS0wzMVdZa3ds?=
 =?utf-8?B?STE5dDNTUGRaWHhYSnpCVlJhRnAvN2x4RS9QOXBMNUtLREpIb3Z4cXZyc0tt?=
 =?utf-8?B?bTFTVS85SXZEWXgyVHR2QktjZmVSaHRBRUVLMlJwaE9jUkYvSDE3bzZlUU1q?=
 =?utf-8?B?MGQ2eUpCNEVjUWJkelFFQ3JjRlBwN3FHa01wSTVTWGRwcURXL1RwZXNsclRJ?=
 =?utf-8?B?S3QyUGdvbXU5cjFoMmw1bHNjN1pBaEVOZXhNZlBrVEZMZDIvZm1vZlMrYlpW?=
 =?utf-8?B?OTVuMXY2VVpVVjZEeWx2TjJ5YWsxSEt3NjZpSHByVmhxbVlhWkFhakpoY3pr?=
 =?utf-8?B?aEJlS1JYb01iUmFOSGNtS1VjNTlPTFZrNCt3QWVleWQ3bk9YSXk0eStEbUhJ?=
 =?utf-8?B?MnEvbHVqUXBqaGFtVzgySnNMZEFMazc0K0hPVmFyaXZIY1JWWjVPN2tmNnFW?=
 =?utf-8?B?VW55SGUzWlB2bGVmT0MxdXQ0Z0tYS1BXcGswc2pCVlZGbUdYTXJtM2JGZ2F4?=
 =?utf-8?B?NHNnbUxyU3QremlxdUM5dGtRVDdUZmo1L0ZmQ1RJQ0lJTHdwRThoNlIvM1R1?=
 =?utf-8?B?bEtWdDR0Nm5wWkl0U0dhN2ZGY3UvTms2ckhxZ3cvZW1yQ1hUOG1kMUlzRzZO?=
 =?utf-8?B?M0NLM0hDT3E5KzcwQmIvajUzN0RBQUhrbnFGVlNEQU90Yk4wcTR2ZmdmWTFi?=
 =?utf-8?B?YzhGeUpYYmdIdnpzc0xLa2wzc0d4K08zYWhYVEhvbVZ2ZnpjWFprcDhjMDJI?=
 =?utf-8?B?ZURGblBtQlFFM0xYb1pVbTJEZU8zcXhBUUhHaHl5eDYzZ2twR2ZyUm1DdE1a?=
 =?utf-8?B?Yyttc2hBcktmM01zQUVmWFhRQ25URjVTVklpUjl3RG9abXZjbUN0YVh5UHc2?=
 =?utf-8?B?T3hrR3RCaGZadWFkZDFHWVEyUXVPZmVnZ2ppOFFLei9hMG9hRDZIMDdOclI1?=
 =?utf-8?B?UlZOR0Q0bktCTWxxbE5kblZ4YUV4d2tuV1BoSnh6bUNlVURMSnpJLzJPOHh0?=
 =?utf-8?B?TmxVU05yempLcWZHN1gyVHJYSmhBQUF3YnRCdXJXM3lJYXplVUF5TDlYdWUx?=
 =?utf-8?B?bEFYK2hiSUE0ZjVwbHI1d0hiWFloTVZWZ1d1NklBNCsweUtvTWtXOXNjNUhO?=
 =?utf-8?B?YUY3NVp4UEg3R281c1lDNHhZdUhxUXhEbko5YVlmNitaTTRPQ3pFT3BaRHdU?=
 =?utf-8?B?OEVsMHEvNmdRSElhNkdkNUZVdkJ6cHpqS2dxVW8zR0ZRdTY5clQ1UFRaMDRm?=
 =?utf-8?B?ZkoxRU0vUkdXbmozaEVxOFdQQ2NFbVhkNkZWV0QreVpvRFJ0SjJjSWkxT2NW?=
 =?utf-8?B?SlNJbStkUGw3UUJtdld6c1NYUmFaeUlFTFZtcS9QTkQxWWxoZmhEYit6UFFk?=
 =?utf-8?B?M0psdml2MzJjeVI4V1hKeFExVCs4UDFPNlVwSElrMjQyN0I1ZEt4UHJMQXN2?=
 =?utf-8?Q?g7BpEtdDpmXJQjAEq2nNSgLK1T974wIt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGpMRnVUbnl2YkJhUWUreVVRcVFqNTRvUUVlNjRxZmllbm8wRG02dTNDTnVR?=
 =?utf-8?B?MXNXb21OV2RkYUdPRU9NQUkyZEdndkFDOXdqQVBuaDEzSGwwRTllQ2tOSkpF?=
 =?utf-8?B?R2lIVTg4K0tpNm5NdDlxT1VKWnVSa3hNUUErQWttRWVCWEFPWGtYY3B6Rnht?=
 =?utf-8?B?YVM0WFhGS0VjQ0tEWjFxTlNxWDhacEdxMlFyQTBuQzJIRDRTbG1IbFVkVFZR?=
 =?utf-8?B?cjZKS1ZqWWpDTDEwRW0xeHJqakV0aXZxcHYvbmVGd3h2NzdBZGhSbWd5N2hr?=
 =?utf-8?B?ZHJtQlo2akpQUk5HS251UXdQWWJmcllIYTI5VWtWVFRFZjYvT3JhRVg5ZU9T?=
 =?utf-8?B?WmViWXBaV3NqSjZEQXNpWjUyb1FZV0h1Q2g4VXdWK0NNb2hUdlBabW10N0Jk?=
 =?utf-8?B?VDlaL2tlQUUvckZIanRDU05MNm1LL0pXWFRURGlRN1FQdFk1ZEFEbW12MzBJ?=
 =?utf-8?B?d3JPRTdnN0l0TkdtOEtZU3c4eXFmbWlMM2Q0UDF2eWVTUVNNNVI0RlRMS0Nn?=
 =?utf-8?B?cVNROTM2SmVwRzlrcmpwdnR5QTNERTRCQVBwNTErazNldGE2L3ZaZStyZ0Ny?=
 =?utf-8?B?cFFZSm9xdi9yUmU3dE9nVGNnQjBUMm9KQ254OElhM3hmOWluNVUyanhIRDJu?=
 =?utf-8?B?WnBFY0tBdFIxNmFSNHluY3kwbVIrVnllSFFWeWNsN0tjZkRQODNtLzhXeExv?=
 =?utf-8?B?Q2IxbnhPdHVRd3Uxc0VNeWJxUTF2OERTMVF6UGtkU1M5NDB5TjdnRkE0clNC?=
 =?utf-8?B?SG1xU21jYmhkMHFQdTBYV0hieUZIRkVJTFhTUFBZK0NSbFl1MnpEMHAxWk1N?=
 =?utf-8?B?ZnU3U01xMGd0WFFhbFlNU1JFWS9xQytraDZYWVlhNlI3SVg0WVRqemlLL1JQ?=
 =?utf-8?B?MUc5YytNekhzWnhRS0F6L1RiNXc4cFFHSGVmWTNWN0psV2RCMGdLQlhDYVhq?=
 =?utf-8?B?SUFRcUdMQWNaZm85L1JrdmFkN1ZaOURlT0dRc3NwTWdUZGVjNVROQXpGZlo2?=
 =?utf-8?B?NjdoZEppZWRvUjVSNSt6REtGVUxSQzR0ajhkZFlMWHJhREJWREl0OU1iOFBy?=
 =?utf-8?B?RGlReGlkdmFaUllLMFVZejkvYzZ3TVlKemVxc3cySmJ5aXZ6ZjdrVFpEOThB?=
 =?utf-8?B?QldaVVEzQU5SUUxqcXkyTWxLc29sa3hBeXcveTg4bnZibTUyQmdDRW1uU3hG?=
 =?utf-8?B?L0s1VGhibTY0aWN3eDYzbTRXenRjYVRDREN0K2UrbE1pUXA1alQ2VUk5OGZz?=
 =?utf-8?B?VTRqQlpYRndLZUorL0dVTXJVeDdCNUVzRkFXZlJnb0J6NGZabm10Y0RaKzBB?=
 =?utf-8?B?MlRNK1U0eHpYTnZPWGZTcmVsUkRvRnZQTXJhb3ZpcWxJeGdCMEJCWFFjaXly?=
 =?utf-8?B?bHluaTVYSkVTS2M5MjZMdXNLaFVLamZXSng3QXJjMXJtQnlPRWRpMXRPNUkr?=
 =?utf-8?B?dDByRkRHR1htT1MzZFFqRjJpSmdrR3NrRlFCamFQeGxITzhxTUhSRytGbFNR?=
 =?utf-8?B?TzFQZWFhRlE3TzlWL0N0K1hCTnh1MmdZWkRja3NLMHM3dTQyaGdySFhSRkVx?=
 =?utf-8?B?VEdCZGF3RENNbnFlRzR6SkhMR2FUbGpDbWxQTk1WZFdNRm5JWjVHQ0J0ZVVO?=
 =?utf-8?B?MEw0dWNZVmpxSGUyWmhFZFVmMUlXY0JHZ2poR0lLMEY1dmpjdGsyZEIvR3l6?=
 =?utf-8?B?dUpmVkMzVCtpTjJJY3dVcmZYODVSbmN3N0F0S3NkNUJCRDdWOTFZaEZzTGx4?=
 =?utf-8?B?dUtkb2ptWHpGYWhaT0FLQnpaaTdGSm5rY0FqR0xQVEowUnBpSElPWDk2RURB?=
 =?utf-8?B?NVR3bVNrQ3I4TnpBbDZ1RWJETGoyd0JHbGoxR2RLSjJGNmtzN0R1TGRyOE5W?=
 =?utf-8?B?WlZJMXk2dnMwbHFYVWdyWUJJdzNCR2EyckxZb3lTQnVwVlZIVlZMTDU1Z0dG?=
 =?utf-8?B?NWVEM1kyU3ZadHZDWDdqTVZJTVNyYWxNaDVXdnZWZEdKL295VzdxNndxWFpO?=
 =?utf-8?B?RnU3YUNDWS9BRlQ3SS9FckpGQjZTQngyMmhiUDJPT1UzRmlFQ1dOWHA3cDZa?=
 =?utf-8?B?cTNscnF2ZThkT1NZZWcrazFmNlg1V3BwUzJqKzRYS1FSbHlBN2xBenhYN3pO?=
 =?utf-8?Q?iG88X2REvgRIWx2xdRV4Rsjoy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c7823e4-63d2-4d0f-aefb-08de0cf1bbab
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 20:22:31.0049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMluzIW2MfCPVr3z2pbVfzz24Mpmdal3oSDI1HbKxtCUIj6QHdYdbMImkLR28bdt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6230
X-Rspam-User: 
X-Rspamd-Queue-Id: B0F89C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: 81etrd4gx9sn3umsbuae7g8gy4bt7fnp
X-HE-Tag: 1760646157-117854
X-HE-Meta: U2FsdGVkX1/9XAhy8rdDSP09nVtS9Wra3SnEEOhT2HjVx2rzdo26W2Wf/g5X612hQBKKyVjlC1MRg3h2Qo+tZzRn4S4dejK8Kw8JL7J+H+Ny1XrlbSmfmc3xIF2ou6JdFt6l2WYftJy/uGUAJ2cubJOWRvXyPjINRhWECrBe2ONfPfY+EdX20+FNlThHsf3lXcABhQNjl2q4pU0HeNb15Te0G+A8TpiO8969od8++Q/2NtanZzOROGgiPA2O6jEX4xkt/x1EIia/rrkO3lnW2ihNGpCFen8oFb+l4mCAq17LtweTdW5G/Q75seC2vC7umtYOaOuuYjOROVkm63xWh5FZcHvn+HTEtIdr8h+2A5XL1d7flEGvU6rc9IZIUMfhAjcS7ZP0FROkdW9lA8n3C0DVIpyFdDndmJXUnhrJcfFDUBWLYHJ+ArF4whfVg4q5vputiM80Yd+Fvl1uZ/EaOlZHadvf/QdEv5CPjSrMVElJVp+e0CVP06OZBLEo42gM73gHd+Wiovn53dy+NSfPtdK4XdFClMpVCQAmL3tFKN+K0HucJvu3LQn5IjSE3cr30btmABsl1K34X+Q/LKNRqJKrmJKmsbAAd3m0rq8gLmdGpLlIGjMZVPxcsI5QWkzKsdogC3jwn8uGz8vfh0FzYD6dm45D9j+Nm73h+NWoKdVensIp3l7fEaSnxw0HO2LPOepW/aQcNHSr6TwXdKVDwwQ4/CD1I2j9fw9ey7gXtL3EYZW0pe1WKPcQNaISNQxe+ZSvxGt9znFeZ6w+wZShvwBuYwUfJN9vIRM+4oBYmKBt4NkIwsZ9mbywwxPmBmke3dIbKIu4eCJyaXFIUrggaluPDhjJ673Zaywx28v40dnbi2oShFDull5oohI6lN1kEYNUGpSZ+5UlyOIhsMbheN18oFMQ0GMvhzosNX3J+agLas6Ajke34m+cB+BaIvptJ3evd5lZuyeQn9gJS5Y
 VcgapoJz
 0baj8+yUThgoYgtt4QrYJyru+xYVd8pQKXFpZzvJChEsRtN0MH9FEI6TqRTQVQmPj0GK+pEqE3Mb3Khj9SXD4rzmRaLBfjhjOL882jZev4znTVeCFxwhNTOkrV8M2xaEzPbJy0U3xhtayspFLKeCt1sAp9sawLQpDJvcOpQ2JzfNxrBF1PK5LfRc8fNNI1k/1E+FPHDcU40IoR8ihyShQA0YfxJMaheW4ZFsAZ35PQ9gHMZ7nEK6bO47PCiZYPUNPcAqW7xdxf/I2amXIcGNFu7CQe+6ze1Dq2KtSHlgiiFPJiFiXY3NEBv0T0Id98iVEl9TeHgIC41DKTGq//V/WEbTgSzgbvZKGO/NCW/D6F4xZMsT6JM9Vqu7AoUVt8Tvi4NWAC/qphndpzFhQrMMclGjcDH0PmCXOhRYNS1J0hgklY9Co5liI44+f8DKOILKxq9ZO6Pwp/Q6tDkjkXp5hYHyjSgSl8e4rmTxlAtHaX7Okug4JSfXWGM+h+rDCfwufbzR6V39Mx8+0q1EPLkylnJtECMyWaLeob5mwKKdSTEg8Doych/YQ5FQaSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Oct 2025, at 16:10, David Hildenbrand wrote:

> On 16.10.25 02:46, Wei Yang wrote:
>> Existing __split_unmapped_folio() code splits the given folio and update
>> stats, but it is complicated to understand.
>>
>> After simplification, __split_unmapped_folio() directly calculate and
>
> s/calculate/calculates/
>
>> update the folio statistics upon a successful split:
>
> s/update/updates/
>
>>
>> * All resulting folios are @split_order.
>>
>> * The number of new folios are calculated directly from @old_order
>>    and @split_order.
>
> That makes sense.
>
>>
>> * The folio for the next split is identified as the one containing
>>    @split_at.
>>
>
> That as well.
>
>> * An xas_try_split() error is returned directly without worrying
>>    about stats updates.
>
> Why is that change ok?

Before this, the code decreases 1 for the to-be-split folio before
the split actually happens, so for a failed xas_try_split() the stats
needs to be fixed up. Wei’s code updates stats after the split,
removing the stats fixup for a xas_try_split() failure.

How about?

* Stats fixup is no longer needed for an xas_try_split() error,
since originally stats was updated before an split happens.

>
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>
>> ---
>> v2:
>>    * merge patch 2-5
>>    * retain start_order
>>    * new_folios -> nr_new_folios
>>    * add a comment at the end of the loop
>> ---
>>   mm/huge_memory.c | 66 ++++++++++++++----------------------------------
>>   1 file changed, 19 insertions(+), 47 deletions(-)
>
> Skimmed over the rest and LGTM, but it's all a bit complicated to understand.
>
> Trusting on Zu Yan here :)

;)

Best Regards,
Yan, Zi

