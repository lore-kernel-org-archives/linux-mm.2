Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5206ACCA466
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E1F6B009B; Thu, 15 Oct 2026 14:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0D66B009D; Thu, 15 Oct 2026 14:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5686B6B009E; Thu, 15 Oct 2026 14:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9B86B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:13:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A88EC80524
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:43 +0000 (UTC)
X-FDA: 85325658726.16.75B0970
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf28.hostedemail.com (Postfix) with ESMTP id B95F9C0002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=robDDbxn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDB1f0sKguTk1eQsF/NF4vlSac3s0gHTk2MkMD0FZK4=;
	b=qKx8ifZSuqU/vlO1++Po9INwbtOybwUcgP3zywyEMzU8YkENuETCP1XRoFC4umv11OiM5Q
	22dostifJBCMjp7Q/buQhWpFvEo6oYNx+WQjpZo1LHvKYTcZO5eqL5xHiCIGrFOIBjeiBn
	u8fTnr9wT/07cjsNVCkoIzwhn2w0UZ4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=robDDbxn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792088020;
	b=JlZ3TmQhvaayrLlsBKaeoELPMXlIt0cPPj7KeRUKhOHKupWxjxS/JltvQxtgDuMLSFGLJM
	PsoXZklCCIIg1meRtnP9XFCBgY0/5RTq+HQ1RMkjGQNBmgCc27i3Rc46nvKXzf8iF6MlzG
	cQeGJmAVUP+y38NA8fQlIgf+zmKu2SI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M5k9iDyxIK9/WiVvy6MbxeCN0W4Qafr6NmT7fBUQs4WIFOqj/8SMa6XyE1yqjERGTKl4u7jvRySoNHaRdnfm9MQ1QCZxs4MLDupIW2RqApDs6ObjSIUoSiXqq8r/r/FRzY6Q5zEC8PoNe3l6Yn0G050AsH9a2M3mulfZ21spNJcXeZUtry2Znu+VSbyMAija2SxyOX2XvZPUHNzxsbj1lhZ7TGx/T9t2l94FmRwU/H6ySlcOPzjJYD6kTO1SaoiXUz6izWxOrOkgA/TAX+93NhB27kXK8cTj4KGPifLv61qmF78Uozh5bTxtdQRfnwTjeAwg7cEbErJv7XEQteVvmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDB1f0sKguTk1eQsF/NF4vlSac3s0gHTk2MkMD0FZK4=;
 b=C07iYw7MbjMgKG5NozJHzKpuZTQUIKgIIACqyaIVLQAJELVLfmQ+5Na+nxPvdwUlXr+KWTg8kab0BAIAjgJSGpE1K6avRTCbdEuByE4D1iv5ekkDm8zOFH5Oe5BaeGfU+wfFWReYclg4YwTenvAm3kwJXq84s9NF3tExCfjaq15JNCcy8uGSFsLn7RM8de+MMZCPjkf9LlJuikCtiKju+ulOvAj+1n3Qfi1/1WJtUydmhj3XhMlT0abWIDT9jgAUrL5Xmtj81r03G/Fhn0iMC2EbMMcR+uj9muS9fkrzfon8WR+XJwN1wfzJetIQYJ6oIzyR45QaI6ZAqx74wzEjKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDB1f0sKguTk1eQsF/NF4vlSac3s0gHTk2MkMD0FZK4=;
 b=robDDbxnD28fd2HFmzk+q3UrBA9XFOlLOKlOZAxOYUBhL317sP05i0MtBt5mnOkUSIapWhFs49BzQRb9CqtMKQD9dZ2AwG4j54uyGpJl+cVFubEJON7sCzKtKbI6clHmXq0rBDl3Kudv2VacHnofQrSe0tCb1u4hxD8W+Q3SW+0x45AghWFNxPnB0RKNOqWtpwadQLGih/PBG8E/hDOe3KK8IBqJZAwCxhSG3wIYzCd3i2c1BgCaxS5MXCgUdLxRj4fOA29YNn/FKai9jtOC3/HkL+npHTLDPF+kMrB051+8QitAzbuJKjY/KuldNnWizu1SxM/6gIClR3ot+7erCA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9058.namprd12.prod.outlook.com (2603:10b6:8:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 18:13:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 15 Oct 2026
 18:13:22 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 15 Oct 2026 14:13:06 -0400
Subject: [PATCH for 7.4-rc2+ 6/7] mm/huge_memory: avoid transient none PMDs
 during lazyfree reclaim
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-anon_vma_uaf_fix-v1-6-7b977303b42b@nvidia.com>
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Kyle Zeng <kylebot@openai.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQZPR01CA0064.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9058:EE_
X-MS-Office365-Filtering-Correlation-Id: fdc981f6-6bdc-4ac2-39de-08df2ae7ff7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iTjAqxk6I7XGTN7FXCB/Ek6u0LuSVhwTdHMfjwdnysjnIlOEQnUsWGKsifkkgQHGVIF4oBDWmq6+DNSDItvS6RPMn8deLvLA8H9fHKMbO5fqEu41UhlZO2vrMMMkAWa7QbhwZ/RW5UuYXs8hoSpmekIO6+ieS9HeA4kI9dMdYqlS5m9XmDo3dNovoFMqhXaCUZu9P0aGXfYQpFRpmfxq97XYyXkfX46PsWmJps/4m8WgnCAI48fSHNVSWVmd6jItBP6PrPvT1RJiVCAXSNGUFjyYhGj5YIUJo0dTcnRAmH4B+dpQDJias4Gs9ayzpKgJyijwUkqxUMzb1tTqSr3EkIU3PnDX11klAbKeaeHxI1tY8Xyov2aBx0F+PfdoLgoe2WirUBLHy2gsHNkBfFZIOmZepBaOhI1p7fsY/NnHf0e6WcyP3LAlPCjfdsbZvvdY1lIz8hsVs4HNQ4KYQgiql0HoM3IDqOMoGfXGlOmLJWQUs7Xb9OomhlhyEFGGDmZ1YRQfw2dJteE7ESvepMM1W95kxJkv/RBg9Kf9KHveL4+KWqG3ocRqYfI2CMKmGEh44EVHUP3ouk9JCgtN2SjAQksrt2HkehEfg1I2mWZgeYkpsIK5siXui2yCQWEgg2MNwsfw7vZ7hNXoWaMHap+bcXhQCPXvpUauy8R7+NCddpug7CQeh6xQWjFnFGggXoBDg8oAMMfGrKS9Z3GD/ZDC8g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTR2VWFvdXBhd1dUelE1ZVRONklzVk95SkkyQ1pReCtQRXJML1VWWVJ3RkdW?=
 =?utf-8?B?NUdHakdpOGdUOEkzV3ZCNmQ4WGhtR2FGTUkzNFB5cjJXclE5Z1dlSi9xeGNp?=
 =?utf-8?B?UjVwM1Jwc0w5dWxaMkJXYjZZeXMxNUExWWdueWxCR0g1amR4SW5iSkY0UStk?=
 =?utf-8?B?d05uNGtJbDg0c1lZeitSYzlPOEM4M3V0TkNxT0NsWGNUblNkZ1lqbTR2bjg5?=
 =?utf-8?B?WDlpNEZiS3dmaDlqVGM4SXIrVnNzTGFsR1dsQ3FrSG5rV1hUOXdROGVGeUFM?=
 =?utf-8?B?VDJIWlRaV0Fzb3VMbEdDdmp1L3V0REpabzBsWDdYdHltZ2oxWVVrQko5Qkls?=
 =?utf-8?B?RkpwdDVPWEJMYW5waFBqaHROZ1FqY3NkUExGc0VWN3BWcHNqS1hYdWlMQ1d6?=
 =?utf-8?B?WForVmc4MitkZnhFU3lwNUUvRFVaL1F0NWZHT0lrQlZUMDZTbFE2ZmhITEZW?=
 =?utf-8?B?MmNZcEpkLzVvV0U0VVpnd1VZbGgrYWVnVUZlOVFORXcvV0tmUzUwR1B0a0lm?=
 =?utf-8?B?cUxDMHBob1FKdW1wbFBxcjlVdTB1QVVINmVZelpzWTJEM2U1cjE0ajRCVzdY?=
 =?utf-8?B?c3hJTkR6YVVPWHJmbVF5ZTZNN3NXUVlDVTFBZHJyVkRuTlVyQWVnczV6cHhC?=
 =?utf-8?B?L3lYd2xRWmtqMk9oZTBRR0d2akNFTVFoN1BOU0hwRnpnam81SFBuZmk2TWZx?=
 =?utf-8?B?S0ZWQThPT2M0azhqSHlBeFRva1RIeVVQN0J0MXN5YU9iRENlZ0V4MXZvT2Fu?=
 =?utf-8?B?dEdhWXZmeGI0OUVEVm1TSGNTanFuRUZlNUFVYm1seWpxNVk5eTNOdStjaEZL?=
 =?utf-8?B?VHhGMmFtVnZZd3l1QXJkTVA3aG12dDdkZi81RUYzdnhwa0k5YlF1aHRobUVS?=
 =?utf-8?B?bVBoTlg3YUZPRWxaZVVqcEZmUEhVQ2JhalpFa0crNGQvVGRxUUtuYTZlYTFO?=
 =?utf-8?B?LzhKMSsvcktQVE1BdGZZeHhQdSsxdnlPK0xkRG1FeFkrZU4zTUpudXBNZjBM?=
 =?utf-8?B?eXhHb01tT3pFRWE0Qjk3Z0crMi9LdWtEVWlsYVByYXlpM1U2cUZaUnJUWVVR?=
 =?utf-8?B?UmNEUTE3WDlEZnpBcnJiSFJqaE5Bc3d1bk1QMUdKYVljaTE3bWV3UE9rNFQ2?=
 =?utf-8?B?OTl0RzVIUnpjUEwyYlRFcGFaTFhaclFCeVRheUpSRUQ0U0FwSG9obFkwRmpz?=
 =?utf-8?B?UGMyNS9SMU0wQituS1MyalZFc2VlM0RzdWpBbFZPam91VVJVODdoSFBraTd0?=
 =?utf-8?B?bUs0b2x2dThqZ2VWZlB5R3Job2tZNTE1b1JTWXh1SFI2SVNEc2VaSTJGTmps?=
 =?utf-8?B?T1BGdkFBaitMZ09nakZQazNxS0g4ek9DbU9DWEdla1pnSU5DSHN0Wm9nZ29P?=
 =?utf-8?B?bnRrbCtMVkd1WTcxbEZqRUtXb09RRHpYQWwxR0Q4Zi95ZGw2UGlBSG9rWlpC?=
 =?utf-8?B?ZWhpeDU5R0F1T3EyTkMwWDZTWUxKd3lCTXovVWxNdDUva1BZUzZrMktSbjFQ?=
 =?utf-8?B?RU44T3NqYW5kY0dZUjUwU3l3cXJwNUNCbVIycC9taFFUakZQRGdWSm5YbU1J?=
 =?utf-8?B?MDhxYkF5ZFo4dnkzZHJsbDZsZVFvVTdGS0V5dXd5VTBHeWVORzhSaHpRVWFv?=
 =?utf-8?B?N2dDcEJ6WkliK0ZNbUNiKzhVWFpEZTViRmFhTkI3bXdCL1FxR2NPZlZRRTdw?=
 =?utf-8?B?ZnIrdWFHVE5pcDU2cTJBUG5tVWV1bmgzZ0dma2dwNXVmblJYVXBYK1FhbjlP?=
 =?utf-8?B?YVdzQkZZQ1Zpb0R0ZTlCMXFrQURpSjlLK0pMZy9wQmt6eng2c016OTZHbUxI?=
 =?utf-8?B?QXRNRDJLS0hkMGRVTkxUZFB4elR0OG8yMVRKeko3UTR4dkFvYXh5RGJ4V2ZX?=
 =?utf-8?B?elc0UWdIRUhWWGdPV3hKTHNsN2RQRnh6eS81c1FGSmtPK3FJVmVqemNMbFFW?=
 =?utf-8?B?V3I0cXBYdTdKbGFlUFdKc2V6a2pIc0hBVTZkNjYwU0hMdUVNZS91Z3YzUkQ5?=
 =?utf-8?B?U1kvcmNJcjhuak05MHdCbHRSbnBwcVhBRTB0OG5RRHBiMEorWFo2QXFQTXJ0?=
 =?utf-8?B?Um5IUkcxdEd3ZkZmQ1BMZ2dXTDRBTHB3RXc0aFo1dkNmNEFIK3Z2ZDRIcER0?=
 =?utf-8?B?eVVYTDJGei9wWlc1Ykx5QURLY1FYRGhEV1d1UDJZOFFpY1MxR0NaaUJrRi9W?=
 =?utf-8?B?b1R6TTZsbGhnN3NrM1I0dXRSc1h2Q3B3TEhjNkp6K1Mxd3d0bzZkWWhjOGZ4?=
 =?utf-8?B?RW1yVGVUYXp1Y1ZBWjQzOWFkWlVKQlZlU0NWUjFxaW1zTkdUTWVDbzFNckhW?=
 =?utf-8?Q?JLPW5SGP7T6Z9dGh5e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc981f6-6bdc-4ac2-39de-08df2ae7ff7d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:13:22.3047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51Ek/mKtXJlbA4zkEm15rbLKyw3DkwXqHuxLIhhXbwpQLelEp9/VhHknUrhHMUU7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B95F9C0002
X-Rspam-User: 
X-Stat-Signature: cs4teq35wqoigw5kww3y9pjnhockrtk5
X-HE-Tag: 1792088020-236392
X-HE-Meta: U2FsdGVkX18mZW8nEk5eKovF9oNdKjOEpyzTPh/bU39HWKN42vnOlflbqnMYihMeyP7Cnt5DEHKQPdjLyNPPCPEgJe7DiZy2CzKpFRg/hTqhOPkVpJp6kew/dMLp2MoIfqLi5pgCWHdG+Y6QKZy5ELMX0oXcuhy+/6tqcev/kjB9bhgmBb9+1w9skbO7auuzJ3kTrBeq7sBEbF5YD5FdexDdZ/tnxD4yZWaW78EdbZ+XFkKE+0X54d1JRMgYKumEpStUEEI8U4BiNpdTbeJREkW6E8jZvLRwN7L3oQWCMn03qlq2IFZkEA9cgik2fqLQfj4Qss23DS0o9xMff0+BoqQl240qlYnZ0WsEv2LxvAjtXURjnvc1PeObORlcWlt90O8AV7/cZuZGl/4JgkioJHcHk7R4oLH0fCng2QbEHeDCQaFSONsPEi4pslG3HKR4kPlVApk7gFwWrEmbJbiwMmU2m7+lSByRVqqUOwOvWGResvYhJiQfht5eWtCtVmAuypQvVsEuneT/r8XjU3qihyvh4WlST09D5FhRbNr7szQYUXNI/LnGbqikXupF6IpYwffJH/ZEYelN7osmCT+GGYujdd/IEPlxCWWaOzDKmgPoHzjqSl5nHLM1XRkjAMmdy4+CLG3hFcGlCXYcn0x/WC+38+vmaYwGtS2Bd0jG//PmERmMBWST5qsmIWiGrNebYbaQkbEoxIot1tfccBZDuWQEaW5Ra1DA1aAhxLcALYDmoCTKkg2gOJPJyd71qqcytYCd9Jfh5pIFjWvAqm0bzY+UuyB9lengh1x6jiYfi3AIqwFGQR4CCmj+pveLe95/sXzJcC8GZ8atbbfnFojSeu0Iwe5tJXIg3GlR7XixNR5SOnHlZsNM/sqmPfFj0z8+NT0dd1sBnid2VLy1GVjA/Is4rBD7QypRr0b3C81BS6Cz97EMhn3KHGnepaRm+0xvUw5l1z2f7eKNwOGXj7f
 TsTtRF3N
 CvKbE0ddl27Jo2qTGcX0MYVq9ZvZLhHAXj20qp2tdy54/CpQn9tjl0xCvHhOLe8lu98ZrNOykiurhK64OvatyAz463q5JcfNy2/wtnTFrGW/J1vRRZ876PVfE5H3aIpzRubeFm/6JZ+VxCmwBME1tkdVB/HV5hVgpbKt9YcUrihq2bWkSNNgW2Q4oOxN8I3gN8iXcOkMc/QiqaYQK0a8Ugt+Td0dwI1fM9E3WFs2uHGgHILO7uPppFAMrCm61UTCprWadK7s78lbElUNNDlRf6hCOOou8h2txkmdzpjBOn1y/qaKssSLiUnQqLT7Qv/WB68OXANCTm49Hemqq/CIUw6Pr5QaS7MAWBKJa63jRQiXgq4bE2xVc379B5GCaxXZO8VsPB6xQ0wLlVYLI2aIWdjb0hemwAUffp+jHKv53ti6jxABSBeA4xmVg55xlsd4zwZVoZnOodIng8FfVHDX6srHLS+U1c4oea+VN0j7V1KCDhm+S1N1Fn53drZfKjGOWgasK0RgMH46HB9bzzFpfRbF/Knk145clcHkwTPzhRicpX/rN86KHuV5TTbOipCoC4P8eSY/khk7dztw60EeSUuJgaqJ1R/9hXSXeUVTRj+gM0CRPx0lPi9AP41Q82bmNFm5xQhcfOlfQzzSHbN+H1ZEz8EJY/oVTBxBrgdbwpzKzf3np62sywOtsTwyfMeymT7htlPGXXuFMinjkFJR++UlvW4CFcuB9aXsfWaonD1yhXn7KY2pDwZnjMnLNpI6n7FtxPoKwkgCb1E8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kyle Zeng <kylebot@openai.com>

__discard_anon_folio_pmd_locked() clears and flushes a huge PMD before
checking whether the folio can be discarded. If the folio was redirtied
or has unexpected references, it restores the original PMD. Reclaim holds
the PMD lock and the anon_vma read lock, but not the owning mmap_lock.

Both zap_pmd_range() and mremap's get_old_pmd() can skip a none PMD
without taking its lock. A concurrent munmap() or whole-VMA
MREMAP_DONTUNMAP can therefore miss the PMD and later unlink the source
VMA from its anon_vma, leaving a restored mapping behind. The anon_vma
write lock taken by unlink_anon_vmas() waits for reclaim to finish, but
does not repeat the skipped page-table walk. Once the remaining VMA
links are removed, the folio's positive mapcount no longer guarantees a
live anon_vma. Racing lazyfree reclaim against MREMAP_DONTUNMAP as an
unprivileged user reproduces a KASAN use-after-free in
folio_lock_anon_vma_read().

Use pmdp_invalidate() to keep a recognizable, non-none huge PMD while
the discard can still fail. Concurrent unmap and move operations then
have to synchronize on the PMD lock instead of skipping the mapping.
Clear the invalidated PMD only after the dirty and reference checks have
succeeded, before removing the rmap and withdrawing the deposited page
table. The full invalidation retains the TLB flush required for the
dirty and GUP-fast checks.

Note: this patch relies on the following patches to work correctly:
1. powerpc/book3s64/mm: don't count invalidated PMDs in page table check
2. riscv: mm: don't let GUP-fast follow invalidated THP PMDs
3. LoongArch: mm: don't let GUP-fast follow invalidated THP PMDs
4. s390/mm: always clear _SEGMENT_ENTRY_READ in pmdp_invalidate()
5. sparc64: mm: fix thp_pte_count accounting around pmdp_invalidate()

Assisted-by: LLM
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/huge_memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e86845..39d56b5032d59 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3571,11 +3571,11 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 		return false;
 	}
 
-	orig_pmd = pmdp_huge_clear_flush(vma, addr, pmdp);
+	orig_pmd = pmdp_invalidate(vma, addr, pmdp);
 
 	/*
 	 * Syncing against concurrent GUP-fast:
-	 * - clear PMD; barrier; read refcount
+	 * - invalidate PMD; barrier; read refcount
 	 * - inc refcount; barrier; read PMD
 	 */
 	smp_mb();
@@ -3609,6 +3609,7 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 		return false;
 	}
 
+	pmdp_huge_get_and_clear(mm, addr, pmdp);
 	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
 	zap_deposited_table(mm, pmdp);
 	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);

-- 
2.53.0


