Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39C5CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F159C6B002D; Mon, 24 Nov 2025 12:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED676B002E; Mon, 24 Nov 2025 12:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC0F6B002F; Mon, 24 Nov 2025 12:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCE886B002D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:30:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36C5F16051E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:30:02 +0000 (UTC)
X-FDA: 84146188644.15.9C3B53A
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010006.outbound.protection.outlook.com [52.101.193.6])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B7C840014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:29:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h0LvZbYt;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764005399; a=rsa-sha256;
	cv=pass;
	b=dv3/giSmyU1wOcoKEKZe/Q7sWS7ixwDInlLtf9xNhIdCe8zETtdSKStrD++Litjh7IO6Nq
	53ER4kk+4IqRfdj6tY3zJgYWtKhMTmHHF+5v03j/zPgytkzBT49h2FsiGnYPldjSJa9vKA
	cyjMkClKdd3RZ1SXCFU0JjB7VAvVcuE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h0LvZbYt;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764005399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHammP+sgZzwx1Fl4pvdeAtoi2GGG3ojJVovRK4zg/c=;
	b=Y7rMrPpVzPqIknFXDnZXVbK1CsNGGSDYIDiXxDF3K1Lj+MiThPU/Po53JRwo1+vtTO51iM
	kmd6xgJXS63PnIR/1N8bl8Q4RccRapL2O5M1p4ywFwYq17+Uk2gCKNWa3kFipC24NHKtsW
	cdcsdiZHuH/fizX/M1EbADVOTgOHwmY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KEyFqP4x3j3+stGLxGg6l6bKNdNZ1a3R6AC1tGKPSd4wD7FcoloDHXVFwLL9a3RR0XgCWPS3rfG7CAjwkt0SMYsj8+P3NjD+6N7CW3mBzJslBAJ9Cax5pzAYB8qmq4prlKVVw2ZxPz5s7u1KlhPZSQQL/3FWpxbjfMvgjYLjuQyK3sohilVr3/W9ZzqR5M4s+d9k+TKsxo8ExfXP0UnQiiMGjSSYwLTQFN6rFHm7Tn8ak2eUa2Y5h61rEgc4koRlUlwYR5ZqOtbbWWNI2BMlCyH6YNo7BEBRl+Cf7HP9CyyGJT2v5c3gqV9DeTwoxhgGNQseOiVVO7AUGJ5PcNfxWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHammP+sgZzwx1Fl4pvdeAtoi2GGG3ojJVovRK4zg/c=;
 b=IEE+hpgS2D9MRC+3vx/SiM/mcHBNZ2OLawlGCVrKY0dcc6re33df1ibd3BkETmvyLbaIcmzbu0EbruAOEfr/tyn2p0cGZqMK+GgPc84morlcy9eg/8Cebi2PsGQkYKtKbQgbhhJecQxQbOTf9O8eW6d6Y5CBWMJUbjssjgeEGT/SvmN8oPEREe0dh//C2c+AtJWUKvTx15Aij9nhT3H8rlgz6foBdqsvgJMm7AZcWRvWwvPJXhYuiz0uhfBw4GMGZm1kDQAUJRepNwQ/8z0iNqw9DRcHoKntTHB18sw+HRsK5HqtXRhF3+CeWi9JHZymi47cIMq3uCE+mJ0Cvy28kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHammP+sgZzwx1Fl4pvdeAtoi2GGG3ojJVovRK4zg/c=;
 b=h0LvZbYtUB6mKZMYmGysu6SxlVwMV7hNMvsbKvUkQzXtlh7t5LKQsnGdbD73o5IqvjasOrk9VluBISns3Z7tbz2XPPHdzw02+ZeFZI4TDLRZqT+axHk9ev5bNUrPdQA5RE0Esn+1bPUfVb8wE3+rGfLRxDck1VXNaDdxRRjbi/1P2DYCGSahoYlj7HE32Hw2ezZobyixZdFk509EorpF5goLMzSqOnhqH0NKqd5jKTle8URkC+lA8wm8xI5yxjPYROcbzbNry1IH3nGNWLuVQxC4CnDKrP1bZ2yRGxSf9D5eQaVrk9zgQMYnqOxhqljug9FTZ1E18Kb/l6Z3Buw4aw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB8965.namprd12.prod.outlook.com (2603:10b6:806:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 17:29:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:29:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm/huge_memory: fix folio split stats counting
Date: Mon, 24 Nov 2025 12:29:50 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <C2036549-30B7-4F4D-AA82-51E75138F1A9@nvidia.com>
In-Reply-To: <721894de-1b36-419b-a3d4-0ab43d607d3f@lucifer.local>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-5-ziy@nvidia.com>
 <721894de-1b36-419b-a3d4-0ab43d607d3f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0937.namprd03.prod.outlook.com
 (2603:10b6:408:108::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB8965:EE_
X-MS-Office365-Filtering-Correlation-Id: ec0904f5-1a35-4c4e-be3a-08de2b7f1505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a3BXQ0NrV3JMOExNbTQxNVdYZ2ZpbnJqY0srdUJENlQxSkUza2llZFdwbUJt?=
 =?utf-8?B?bkczbnF1d3NZZ0EwRGs1b2dRT3R0WGxLN3p0MTRRdTQxT1ZwcUxwVm9EK05n?=
 =?utf-8?B?WnlQTjBZM2RoWEx1MUpVYUhnRk81UFQvYk10MUhIWmRnTTk0Ty93MjdhaTNT?=
 =?utf-8?B?bzh6REk0ZXNmZUZXb3FGdE9VZDV3bzdVWWdKdU9RNjhJZXIrYUdOL3czdjg0?=
 =?utf-8?B?RzE2MUpyaWVnaHovQXFTRkR6cldhdVJJOWtLN3FXTysxMVZuZHB6VVl4M1dT?=
 =?utf-8?B?dll3czR0dHgvMWppV3hlSlNxTVRub24vQUo3ZHRvaWNJcENUU2hlSnVZS0c1?=
 =?utf-8?B?ZnAyK0ZlVGJoTUVFUVFIZE5ibTdlL2x1K0hBbFg3TEtEcWk0VWpjSWdWVUNv?=
 =?utf-8?B?Z0tJK0NrVUsxcVN5NitXQzVLT0dVMjdFVjdxaVdEVFdQU1BseVo0RGErdlJE?=
 =?utf-8?B?aTBGdGNzNXRRTG9TR05ucFpEZVpYdk1wZitia2c0Y0doTElabCtGQUdhYmZC?=
 =?utf-8?B?WUEzSkpnQzg0WEdjSnJCZUwzaUdtSUpKcEUvaHFwSzRUNXNqSGI1L2ZLQThJ?=
 =?utf-8?B?S1FjQlpkSnE3MzlLcVp2Ni9RYTRSbGNMYkJQbnhtUzRzbWlZWis1aUkyZ1g5?=
 =?utf-8?B?SDlaVXN5YjBJSmNRUEQ3SEo5MGVyemhnSGZDL2ZhWVYvaU9ldC9teFJHTk91?=
 =?utf-8?B?c2ExMzRHblB6OURrSWRlM1lBOVZ6OHJpRUppaWlkbE85STN4Z1YxRjdwejFN?=
 =?utf-8?B?dUJTc3hLVnEvYW1JOXVSYlBVS09tV01wdVhWSlE2ZXFoc251a1pObHdwRzk0?=
 =?utf-8?B?UXlpRENrT04vMVlicjYrNWNJTGpxdmxvSDlQNERSN0VwWEpzMThxZzEyS2RB?=
 =?utf-8?B?NjdCTE05SXBaRU0rVmE2dVdXSU1SeXF4NXBCbURXUTJlRGE2NG9qbDRDUG5s?=
 =?utf-8?B?S2Zxd0lBMmkxYXVmS3ArcHdPTHd4RXlMMnZQb0d6ZHNIYmpVcWtYNDNNVUR0?=
 =?utf-8?B?Q25WMlNqd3BqZEZUaTFIOGd5M2NCeVlFSmNVT2x3TFE5ZVZJaWwvbmNWclFh?=
 =?utf-8?B?S005TDlzZVFib1dSbHhlODRJdkw1STlaMzB5ZUxkYVlIeXg3VDNEeDVXYU9x?=
 =?utf-8?B?alYwT1QyQWV3akRWNll6N2xvWGlIdjFWMy9ZT0duaUkxSTFXNXZvZGwzbS9Z?=
 =?utf-8?B?VEFNcFlCV2pJL3cxanN6eUxMRFJldDNSVUxOTlRsaFJ4bXJUNVo3OExKNGFZ?=
 =?utf-8?B?MW0ySlFqaFZkeGl1bzRINy9qTnNiRVYxRWJiTGpJdnBERG1USFM1ZkNlK1lK?=
 =?utf-8?B?NkpFajhwdy83bFptd1JJZFlTYWVwdW1tMGxnaWVmRHNycWhPNFdnS1FBNHBD?=
 =?utf-8?B?YWZjM2ZxQlpUOG5OaVJiYkZVUUZMbFFldWZKZHBNdHAvNWNPZ2tlSis0T2lh?=
 =?utf-8?B?N0hZcy9Nb1hxZWRSM3l4aUM5SnhYZU9MamdienJ3MXBFWUZxdHUza2hhNWow?=
 =?utf-8?B?ZmpDV0Yzb2RNdHg3aWtqUXFOLzQwQk9DK0lrZ20xd3dPcXZHOWhnMjNPVGhm?=
 =?utf-8?B?a0wrU1pGQ2FpR2xjUVNuNXd5cys5OGw0NUJYeW1aK2QxNVdvNjRvQVoybkU0?=
 =?utf-8?B?dVRPYVVrVXB0L0RCSk1MQXUxWnZ6WlZsVFRnVWZKN0pOZlJFdFpTWGoxWFo3?=
 =?utf-8?B?WkRmc1loUTVlNDNlejRUVnFHajlCWllZTVdMbzZBWHlCaHF2NmpzU3kxOEU5?=
 =?utf-8?B?UHZFUGpaTWNPZDM1MUEwRUk5bitFdnpPWEhLWk5Vc241U1ZKY3pLaVZhb2sv?=
 =?utf-8?B?YTFhQUE1UE05eU5kdUxKQ1ZMY1hPRWRUOWpVbXcwbFhnMTNGQ052MTJkanpl?=
 =?utf-8?B?eUJvUnRqa1lrSXUrcTFDcUMwNzJHZHRIeHJhaisvNU0rd3pRc29JQ0NwRzdM?=
 =?utf-8?Q?a+nxWM7s1x3jGo6F1UjuOxcThMCds4V8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1FaS0g5MnI1d1QzcjhteUN3SlMzcldOMmE4L3N2WXRwRUVCK3kxV3JwNzhG?=
 =?utf-8?B?QnJRVUFmVk9WalRHYXpoUG0wY0hJcGNtaEt2MEdya3Ura1ZySThOZFR6cXVo?=
 =?utf-8?B?UkFZanVSR2x4ditHc3laUWhSMnB2SVJ0dFpINW9ndWVtOXRyNFpxS3dDdGUx?=
 =?utf-8?B?SEI0N0ZHSGdRT2VvN1ZRMGM0NGdUV0lacXRFMXJDekpHd0RvV3ZWRHVCZ2xY?=
 =?utf-8?B?UXd2dnQ3V3c3bHg5TUhLTnBnQWhBUmt3R2YwNGhhYThDZ25pZ20zeGhJMWNt?=
 =?utf-8?B?amZTNTN5VVFqN2Qxdk8vK21MdzZZQkhhcVZQMVNjYzhGM3hHQmJCRlJQZ0ky?=
 =?utf-8?B?aXcrWWZaeElLRmU0UGRIekJyL3A5bDM2aHJSYmpXVWg0MXJxT1ZuVjdJQm0v?=
 =?utf-8?B?ckdMUUpxdXE2SVQzMG9tZXFJWG5waUYvVUgxVnB3SXlxN3pwK2wxVy9Wd2h4?=
 =?utf-8?B?V0lkeDFYakkxbHlveFYwWDVONHlLd3kwK2k0MjRRaWR5K1NTSGxQMW9sQXgy?=
 =?utf-8?B?cnNoVG92VUFyVDhjaEJrM3ZVTko5QlV6anZZWDVyYmZNOTh1RlhwZ0pNUmlN?=
 =?utf-8?B?YWZRS2R2dXVwZFFDOG1oM2cvZnI3c2NrWjBTOU9FTy9Bckk5YlNuYVRkTXJN?=
 =?utf-8?B?SU8vZ1ErRTZuaDYvdFJqRTZNU1QyY2JhMzJ2eTBDYmNYcmhXSDlDN2kycUc2?=
 =?utf-8?B?MDl2L01xczhCMXc5cHRIZld4QjJUcERIQ2hhK2tsQjhGQnRwWldsU0I4VzZO?=
 =?utf-8?B?SmJwdTRPbEZraTFRaDVQUktiTE15TzVjOHB3LzNOTjdVRCtQQTRST2FYWUl1?=
 =?utf-8?B?b2c2L0hRMVoxclJQV08rMXk5MjFOWmVnSHQwWWl0OFNjQTdvZHlSdFZJMUtL?=
 =?utf-8?B?LzBtUVc4bzVtMXpkbjk5N1l6dWd3VE54Z2lENFRvN29Xb25iT0RpeDFVSHNF?=
 =?utf-8?B?U3k2QTFva05WSEF1WHJWZDVPSFhnQkJXNnllNG1KYzd0Vi9UaTIvVE00ZC8w?=
 =?utf-8?B?VnhGSENlT1IvcDJxSGlWVGQ2NUdVLyt5NEJlSmg2bXdndlUrUkp6Zm92MU9t?=
 =?utf-8?B?ZVdPQUhRc3JNTFRpOHZrNUVzVDBOQUFaRkVMMGwxNWxZWkRUa0ViUzFvSG9X?=
 =?utf-8?B?Qnp4Yk9tNSswa2h1anV2K2gyM3VkWHBGOExmK0h4WW9vUEVHL29PbUxaYnlw?=
 =?utf-8?B?YStFZGxlMHh5bFNVMUhQeXpSOFE2WGtWQmkvaHhqY085MEp5UkJ6MHJablIy?=
 =?utf-8?B?RThPbjdzdCtFdjQ4eUdQaFliNzAvcWY3QVBsd2wrZVNzNUJWQjBLdVlYcjJW?=
 =?utf-8?B?aE14YmxlMHRGUWdOWXM5b1BvMFV6ZGlHclRaV2ZmRzZ3WWNNQW1kU1RsMW0y?=
 =?utf-8?B?cTN0NzRBdEhyTmxCdDB0TjhyeVQ3Rlo1VE04TnBWYkFYZmdNNyttWGxJbTBY?=
 =?utf-8?B?aWlscXpyVnRYNmt5eW1XZnB0bXdvS1puUTB6N3FCWUN3VWYxdmZGRXNjNjFL?=
 =?utf-8?B?ZGYrNWM4RmtxeTNmb0IwaDBndEZGVkl1WkgwcW5nbnd3SXNTNlYwckt5YzRU?=
 =?utf-8?B?SXhmVnlMQm1ROG1VeWxONVRxV2J2b2FyZGluUXlUaVlaS1U1OFdMbmNMUW8x?=
 =?utf-8?B?YXlqY0RUVnU2L2xMNGhVUmhzQ28vYVpHOHc5RlZFSTlhVCtlMEl6aERORmtG?=
 =?utf-8?B?QkxtcnRNT1A0Tnp1RCtmczF4NFJnb1VTYXJ2dW1MY2dUMkh5UmRKRWRYdHcy?=
 =?utf-8?B?TFZ4alV5QW5lc2VKcFF0NGNHeFdGSzZRelhNZ0JaUTVyaStWNWlqMElmanpS?=
 =?utf-8?B?b0JvNG5NOGtlRFIxUFpXY3pXMmttQ3Ntc011QlBxeTdZUWN5d3BQSnJmazhz?=
 =?utf-8?B?VlJ2cUFzWnlWTy84cjBlRlc0bUN1QmFWZzZhZ0hhbkFlVGtCT1hlVTBJSlZ6?=
 =?utf-8?B?em0vMW5HVzBoTVhjcUJxYkRVVGNVMkI1ZnFDd3NiU256KzloTlgycFkzZkVj?=
 =?utf-8?B?TVpYNkhDR3FRVVpwZkJiUlJyQVVhZjlndFJZSnhXRGJXRm5hSUY0S0UzWitw?=
 =?utf-8?B?UUtsTkhLNEo4cEladENWME5TZkpHMVExdjFSK0s0ekpYK21QdHRxUlFlK0lH?=
 =?utf-8?Q?JyWB3NgRbU4aFAo9lWF7H2/gs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec0904f5-1a35-4c4e-be3a-08de2b7f1505
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 17:29:54.8115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lJm5XQOXKpSCFvS2X6LU0m1UAsC8qJ90Fv3YO2J3H5xTD7ZJUHed6HCPueCNkmCM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8965
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B7C840014
X-Stat-Signature: etreasudk9f6d8wgko59a5jemnncsa4f
X-HE-Tag: 1764005399-964879
X-HE-Meta: U2FsdGVkX1+IuQq4gwkzIfxSqS+67TPVffckywBi2iZhqyH5YW3Q+AFQTdIUzmKCYlxcgYmdrk8RWykhd7GtC7lBujnYy6hc4FhLtJ2nK3memz49x+iVX3LCfNf4+t//f2E2Xc2e0ku9gQdLSZ20q3yEbu8wVRP0Th6QNRRpHXhGKfhjv+T6RWzeCWYsalyDby8xfvhlqiha+9rHOS/asnbN8jF3plNz4G8YLzN7dksrYiiOvTt51sQfHY8oDRXPLrISkxqmZIriWLBpcFjGw6jjSFYSGy+0yWF2dsXdeW/I03SBrEzx5p6EToF7IFiOq7f/aSrM63AVeSHNliBZBHwsjC54GAUppzd0KFPa9SF/3JZVWI4P9UR/9pDpSJ9NbsACwgfQ/tvy3Q3sRrx5noIDBMcWM73jgqMqBFqMH3aCZ2ryJVUaKtAW4bri+oEXTRp8tth0ClCnj5ucuNyvkcLrEU2lFDYX57SwNKEHYAKFB3+gm7grY5sYxwaD1VLjKl9Z7mtDDNdMZBn83fkh6r4y5OBXw3R/xC/N7OIZhvZgPR1pTg6eFPjIDLLC81mV8Ch3pi+l66WkZXaCcuZChQFsahP9AkT0wRCygXzHGld95riKZWl69BcblE15EqJVB9V9ME6pml01Wy0oJr+YgtPynaTWODWNL6z6AbdRiMVvjTuxuVNWYkvBqUBFc2/B3zM1so2gtktOX8OLD0OSRDl/YcfePFnBa+A3b34DGGKWK6NkKFSemP+GcvHp2ymVIICASEOUJwIDgBjUjrV7Aafg6P72Dpyv99wR2Gl382pPo+sH/JELOpfkDnJIwymYTwCG1vMgeEYPLCjMyfIL0Yd/jpCaO8hFkwpKJUMjHujaVm6T4HAnuyKeT3bt2fPKtvNy2IE2ebmNOBdrrRPQaWYjhLprBWCy6YTFTrwaWjObbSCN3EoEgk9ad0ZbuhKW7O2Mu2w5gnGOWs3AIop
 egs6RKAH
 DMBQQquRdSJqobqZcvkXpp/twmlNhZkzo0CXWii63lILSGtRq6OaK6TV3k1GeDs25eBu4jB+a7AHMsllOE13rtP1njJV9qmkGCcCbICGZnm4E193fr6UfHDcElHYqrvUeVo+OgB6sIs63+wukqj24BgKj1yQ2E2NbwMKoj7wXD9GqtJb9fxYYfS1DQyzxL5PK6n5VjVLaDpiZgQuZnZ+h+CFoT0xa609CXZEg6EL2BpFcEIMtz69OpLNtzGPhuy3+wL/+NF4m868XKvL2Klr2s2ZzMNWD2fu83PRjiKB5MBBEa27qInQgnamimJtx3Ci90sZdi+6ELDHrcRvmfl7xtQsl7ywylV1R+S2Bipjkd/EIhWC6Hw/vA1un34rswIQ2/y34NKFu3sbVv4R50JMVDsLv8DbcGvu4r+ZSV1EPYXP0iIAtQ8gqYBeLFaHHgP/GUv2aXU/FqagXo4spJl1+o/4lrGdjgJU/MiU6XvhZIYhjyJzSlgj4xyU77OhKws4FGtCu47NWP+7rnlW+WFaZSMcGxBK7XqpwTk1e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Nov 2025, at 10:21, Lorenzo Stoakes wrote:

> On Fri, Nov 21, 2025 at 09:55:29PM -0500, Zi Yan wrote:
>> The "return <error code>" statements for error checks at the beginning o=
f
>> __folio_split() skip necessary count_vm_event() and count_mthp_stat() at
>> the end of the function. Fix these by replacing them with
>> "ret =3D <error code>; goto out;".
>
> I guess the xas_destroy() there will be a no-op in these cases!

Right. And there is no memory leak, since xas_split_alloc() does the
memory allocation and code after it all never returns directly, letting
xas_destroy() do its job.

>
> Good spot, as David said, maybe one for stable then... not sure if necess=
ary for
> statistical stuff though?
>
> But at the same time, maybe users will be misled if these are incorrect?
>
> Has this bug been around since the beginning? Be curious to know if that'=
s the
> case or if it was introduced somewhere along the line?

It started from commit 59807685a7e7 ("mm, THP, swap: support
splitting THP for THP swap out=E2=80=9D) back in 2017 and more inconsistent=
 code
was added later.

Unless someone relies on split stats heavily, I am not sure we need to back=
port
it.

>
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks.

>
>> ---
>>  mm/huge_memory.c | 14 +++++++++-----
>>  1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ebc3ba0907fd..a42c4f29ce4f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3954,16 +3954,20 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>>
>> -	if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lock_at))
>> -		return -EINVAL;
>> +	if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lock_at))=
 {
>> +		ret =3D -EINVAL;
>> +		goto out;
>> +	}
>>
>> -	if (new_order >=3D old_order)
>> -		return -EINVAL;
>> +	if (new_order >=3D old_order) {
>> +		ret =3D -EINVAL;
>> +		goto out;
>> +	}
>>
>>  	ret =3D folio_check_splittable(folio, new_order, split_type,
>>  				     /* warn =3D */ true);
>>  	if (ret)
>> -		return ret;
>> +		goto out;
>>
>>  	if (is_anon) {
>>  		/*
>> --
>> 2.51.0
>>
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi

