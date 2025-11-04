Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C4ECCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAC68E00D9; Mon,  3 Nov 2025 21:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2398E0058; Mon,  3 Nov 2025 21:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91BC8E00D9; Mon,  3 Nov 2025 21:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B58F78E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:30:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D64BB8F13
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:30:14 +0000 (UTC)
X-FDA: 84071345148.12.DB3EB85
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012006.outbound.protection.outlook.com [40.93.195.6])
	by imf29.hostedemail.com (Postfix) with ESMTP id 60B03120006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:30:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=okAkyvDh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762223411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2ubum/A8VI8f7Lksxx55GcFPY7T2Joc3fuzjj4qLM0=;
	b=nMSp6YQlqDlc6ACSHxfP0R/NrbSAp7qhOoiNbP9Lbeu9SJajgRsBiGlMM1YYTVTgWxc/Gt
	nU+wVuZz3JS10w7Pu8pPJlgWx8HEcfeR2t2PIPu9I7F7/qXgdo71rW77ovqB3FKM/INaRV
	fmu2kaCq/lJ0ClW03Ps/ZM7ZA360lHo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762223411; a=rsa-sha256;
	cv=pass;
	b=WIdf1UV1WK15kF42ppCHNGnWpwpoWr+AJbwxMPHalopU6dgV4fhl0ji19SRq8mIKJgaZum
	oFjD3IohXFVmAaz0kN+a7aVa/b6i8qk9IE1okkgpjztZCeOy+D1+EVZU1Kkl58EQSGCb2F
	+BGQf9iR0zRWtE+rYPoXqVhVCgaRQkA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=okAkyvDh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fssNDTOezz7zWO/l2otmpUief0qkuF90JefFvsQdB+ktRUuQEpWnV/VXUG0bIR3TFcByK8KloUgdMfG+jGzeJLCv6adTeXS5u85Sihg8KniM1CSaLrPwCCxzBjCoEo2V1Et3qZHUOrsq5pLbEbhegbngpkhgBBXGl1ufIG8IRyEmuv+9KuU1ceJHCdgblQOUn0oDFP5uSLOvBzGFQvNWzNuGkFSsrjfKMn8wBHGGNjr12KGpBTH54vk2n899TGzTnoD/D4H4nLg4MEMph6j+KDxES1FgLCDznj4RXjNGr7pCLCkDbxuc7NylFlewYLar9SNJ6iI1kF9YJuM4IDlj5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2ubum/A8VI8f7Lksxx55GcFPY7T2Joc3fuzjj4qLM0=;
 b=jztZJgcqnF2EGIYXYSsHrKzoQ0gHtxuf2g+ecf/qTPdfxhqMtOY0Y8RbkD6vD8mKPp5//q8hG2YRK+sq2byOVSwnB85xRPk1mvd+0eI97e2BMIhvNyLpDJGIddr8Ch/f+LV+vchYLK8v0v4MdBk6Nodan4E/IosIOs+CtOavc7bNB2Yl25t9SHyJH8ES0obgabcC5L+csjBMtLNpQexxmVdwhyI11FQG4vISyU9Wd5rxusncXfbHa6a5AuDpa6NfOU9OtNCb2AEPq7pq+Q3/glXKT6W2pmPliLiGmFaJt8tOC4gN/NTDSb+MxrmewbUJ+C7hqOrdldDM1JgDCyaTEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2ubum/A8VI8f7Lksxx55GcFPY7T2Joc3fuzjj4qLM0=;
 b=okAkyvDh+K+O3G5N/3KxMOHv+Meo8ScmwOep+sHoc7UiNUnVWbnUzsQglHzhDjFmiVUsvWhoofNYjt2nDhj9OrGS9yBMNR9Gs6YJpGnpdajF1DYokmIppDkv49lhKm95mtODfAWhhKiXDIEUsHZzMMYI01bLGErIub9BsqEy5NdO+nWhaGDxgktERa52jp4dMLJ6kiUZ2nv4XHm7eBUAzJY9UxVs9KEDW00dAwx2x5Yd/n52qQmq87c6wRqL/LLMqMNGKRKn8AawwwjCIJUWemkuoVPcKJqebp5ZYnOYLnlh3TKhtYnFmwCeVA/U8I1XS5iNHnEtsgtie8JY/VB0Gw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6854.namprd12.prod.outlook.com (2603:10b6:a03:47c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 02:30:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 02:30:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Date: Mon, 03 Nov 2025 21:30:03 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <016650EF-DBFC-4C7A-A707-8FC6A0F93ABD@nvidia.com>
In-Reply-To: <20251104003618.adfztcwwsg26gmvd@master>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <CF5DECC4-7C92-45DB-9931-A1E35CA3C0A5@nvidia.com>
 <20251104003618.adfztcwwsg26gmvd@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR08CA0015.namprd08.prod.outlook.com
 (2603:10b6:208:239::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: dc285648-7cc2-40fe-88f6-08de1b4a111a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3kzWWZ2ZGJHc0hPMnhEbUtMYi9zYXhKQ2RlRE1JZm9EQ2Z0Vk05OWhJOWRz?=
 =?utf-8?B?T3FaTXZCWTRjRWJ2L3A3RVdQS0Z4K29QY1RYMWpQdXYydXorYmkrM1FLZ0Ri?=
 =?utf-8?B?Q0l6YmZrVnI2eTlKRzJ3dlBEWHdkRTh5eTNJK0REeDNTaXppajJRRGVYczlK?=
 =?utf-8?B?RzNsZ0kxaDZrQ0V6VEw4UzZFSVBPS3VlQk1KeVc5bi8ra3lmaFFESkJveWFV?=
 =?utf-8?B?WkxRdUhZUER3OUx1NWJwVUY0bXYzOERTYnUyQTJZanZEZUdlVnVXaGlvUERo?=
 =?utf-8?B?Z0FIdFNBS3BwUmxHeU5NazRFMU9ML3ZJOHNrOWJjRlhBK2c3S1RLUEYrYnJQ?=
 =?utf-8?B?WWZVcWJQamRWdDNLZzJOQnNwZU14dUZ6TzV1V1h3eGNGTjE4QVhrcEVidnND?=
 =?utf-8?B?MGtKMDZnd0Q2amdJdXQ0bGdnNTRKWEV6QXB3d0VpNmg0R04wb3BJTDRmQjV4?=
 =?utf-8?B?K0FQMzJrd1k0VGROUFhlTHNZbWJDbHp5MTAxQlBCTDczbW1jNlRZM2JpVlhN?=
 =?utf-8?B?ajZNYWtRdlJrZElRT2cvVW1lVkRHb0R5WHRIK3NYcGNJczNpL0FCNjF0bjU3?=
 =?utf-8?B?bHV1MDFVcnZmSG1WMDRRSUZvekk5YmFCUWlMY1FFNkVDdGNrYmpWR0E1ZUFz?=
 =?utf-8?B?OFNlWVpoNEswOUhJbkxMY09NUUdXcGh5aC80TlRFNHBlam1NZXRLbDAzbTFl?=
 =?utf-8?B?akd0eHN4ZUJJQTJRVFpmalBMcnNDMzhRc1VmZVBERTlHOVJyeU9oMktaTHZo?=
 =?utf-8?B?WFdnQkZZeUY2ZVhUdEw0a044SW9HdGVER0UvbXZtZ1Z4QkhqZXQyZ0s1M2lQ?=
 =?utf-8?B?Q2x5TmdBMWhxNzVWeHlhdCs2TkhGbVd5cUxJZTBTZEczRHQ3VzRoUXBuZGMw?=
 =?utf-8?B?eFRuNmZLZ1ZsUUVpbTFKa1l6SFhWdldMd3c0cGRHWmNXWWVMV0Zsb215dkJN?=
 =?utf-8?B?ZXd5Lzc2Z3BiMUhscUprQ2ZHRTBrSXBmSFF6UFFlZUtwV3BKUk9wbHdFRUg3?=
 =?utf-8?B?SGVqUEl5RlpGTUxPTEcrK1E2Z2JUU3NJaVVyRFpuWE1vZ3MyL1ZlQjhpSmc2?=
 =?utf-8?B?OTJiWEF4cTV3amIwMktRQXZNdXFuZlJhSGI5Uy9jWkRTcFFsaTZtckZESVVP?=
 =?utf-8?B?N3hTd0VLVzRLMmZoZk1WTUROVTYzdzZzenNqZzBtVWpwOHFVZWdJOXg5VmhP?=
 =?utf-8?B?YWY4Znc2d0E0eExZalNXYklpbVpLUlV1U2cyMUVEVXJPVVlkWHYrQm9pUFpS?=
 =?utf-8?B?K0ZqQStTdEhwSGk3dmpPa3l4RmI4TVNpZnpVcVE0M0E5TVJsTkJVQUs5eXVE?=
 =?utf-8?B?NUlmQ1FORE5qOUUrTHJrQnRMUGVWMm1CZWVocXpVOTJKZlBQa3prZDBjUElE?=
 =?utf-8?B?eFZTNjF6ajNNejFBaGFmcFNHbXc5aHM5aGcwTnpxVzRKb3E1bDV0aFBITUMy?=
 =?utf-8?B?ZHBkS3FYc3JKTS9FbmhhUm9RODNzNEVJZUFaRVc0cEpDS2I4UXAzUC9FVEM4?=
 =?utf-8?B?ZHBWNG9qMHVac0tBbHBJN21OQTRIU0hYRGFQNFJPd0d6T1pXTUd6RGduN05C?=
 =?utf-8?B?VTZ6cU9mbG92TDdDV3BwamdoZUV3UUQwa0tvc1BNMDk3Z29kQk1nZktydlk0?=
 =?utf-8?B?VUhLTktkbU9mQkF6QWoyc1ZsbDJpVzJNZ0VXVkszQWIvUzAyODdIUGhoZXRI?=
 =?utf-8?B?TXZ2aStURjBBVlIxWVY3dEZGdm42VUhJbUxBTE00Ri95bnYyTVJVSlhrc2Vs?=
 =?utf-8?B?NHZrM2Nsb0cvSllaVXpYWTVhMEN5NXJKVEZaZ25zdDNwb0RIQXlHRmJaak4w?=
 =?utf-8?B?NnFQVnFjcjA1YkJNZmZpenlYYmdIUHhTZEl2eFlOT2dvMXFVQlgzUXdydlJs?=
 =?utf-8?B?UUpCamQ2QnFwMmVTeVEyQWg5R25VeFNhcWU2dDkrejNVc0RRc09JV3pCVjVk?=
 =?utf-8?Q?KG/1Fzhzvek8/TOEAZY+4ibGhx6bzdkI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0M2QStvNmdud25rWHpMaVNqL3dIaG5pZmVTenk0OWZuQmpwQW92c3VVa3Zx?=
 =?utf-8?B?M21FQUtQVC8vNGRnSmg3bUI1czQ0ZDdOM2lINldqYkpJMkVvTVRYNEFlQ2hQ?=
 =?utf-8?B?bHdaTkVpM1BvQUREbkswZGtwRjFWZEVUR1U1NElqdGFqRU1kdjBJWkc4djVs?=
 =?utf-8?B?d2srb3RZYmN5KzNERmZpKzQ1ZlVhK0Z2c2tidkNpUXBGT2o1UTFWZ0JSRXNz?=
 =?utf-8?B?TEs1d0RTb3NYa3FYd2Jyd3ZRSGgrUUdCcnlzTVN0Smp1YVR5M1ArRUVrTDRi?=
 =?utf-8?B?c09NZUFoa0xseEdSeG1UQkZNUFdsNDh0QW45SitHMUwwcm1oNmdOanFBUWRB?=
 =?utf-8?B?NVFCRDJUazAzdUpIcG1DMFREM1NDNktWRXFYblloZDRmcEJienZnT281alBZ?=
 =?utf-8?B?dVNLNWQ3eGVXZi9CcmFNRHNCQmU1djM2eStvNHJFTUpFc1BLc21zOVZBT2lh?=
 =?utf-8?B?V1l0dHlMdkhvWUtMZUVUYnRubDQwYkltQk5nZWZVcUt0eTZ0REhzcFZvWEJZ?=
 =?utf-8?B?eG5zTmN4bEhRb2tYcGk3cHJYRXFYaVpzT3AxZ2cvV0hHMFlnN1NDYkE3dXln?=
 =?utf-8?B?ejBDUE8wWjN0Z3pRR3ZqenJrS2UvNmdXZUVBN2wyNUFpYlFTZGhleEFpVGlF?=
 =?utf-8?B?dERVenhxaStQK0JwQWhsSnloMG5nSzBQNlNrOVlwbk44bnpDRVNSaXYzblFU?=
 =?utf-8?B?bjFpeGtwOGV5dGlqSkRPUHdsMEx2b2xSdlVuS3ZveWV0SWh6cThWNElKUkRu?=
 =?utf-8?B?eGpKcWNjcS95cUc4MFhvUitqOG1nQmNyOTQyQnZYdEkwMi9jcXJNWmkwaW1S?=
 =?utf-8?B?S08yaktvclZhV2JzbGtTbVdLdDVuYzNSeUN6Q1A5cVJnNmRTdy93dVhnU3Ux?=
 =?utf-8?B?UkRBQ3EzS3VObU1GMmppM3Z5aWhkRWxkU3grWEwwZXZKUUFDNG5rY1hiSk9W?=
 =?utf-8?B?YWFtdDFEU3kwOHAvT1Q1VmxlZmhBNDN1NzhlUXRRRENQeUVUbUZFS2tLYXJs?=
 =?utf-8?B?SnFFVVl4Rk5ZaDJJcFI2VXU0Nk9XemJ1YmNFck1KUlE5SmZzQ0w4SkJjNGdB?=
 =?utf-8?B?czNQcEUrSEQ0UHZMcXZmMERJbTFqM1JucDlaL0JwRzk3T05PWi9vc3ovZlVw?=
 =?utf-8?B?NDEzWkh1WjR3ZEJjd1QzUUd1VEFvMGlHYzkwR2lZRytNbWtyemxIaTYyZWlN?=
 =?utf-8?B?NmlJUzk4dk01VDVGUGxXWWN2UTdYNmUxakcvM0pIVkNBQ0sra0FwRGFvU2lE?=
 =?utf-8?B?NFF1MjgrSmxsMXhzOGNzZ1d5T3dnQnRnNlZTc09kSEQ5L3dpdE5oV2VsTkpo?=
 =?utf-8?B?UVdxTVVXd2Z2NEZPMEpGSnBuR2tDdG1FNFZpV2FLWk8zaXExRk16Z04rMjJy?=
 =?utf-8?B?amFyMXhYUEFIcFI2emNxRitDZmRzUmloczhpelZoNFZDU3BDVnRhMThYRHVO?=
 =?utf-8?B?Rm8xS0h1ZWNrbTErUnEva3R2NjlYeHkxZU9zNWFaTlc5VGkzY2N1MGdjWVRm?=
 =?utf-8?B?ZVhZcjlLcHJmdndXNWhOd0lVNC83Q05UNThkem5iOTNNT0JycERiMnpjZS9v?=
 =?utf-8?B?bVBYNkdyVzN0WVN5RHpoNW9TZE53T0FIS0ZkeWV5N3M3TGJLcG5tWld5Vkt5?=
 =?utf-8?B?WlM4Uk1NRXVIRHZ0dS95UlNXL3l4VUlBcmlDVmZJV2V3ZWlTWTBGUzBsK01v?=
 =?utf-8?B?TTV3cDA2T1pnTVFyVmptL2FYN2IzRGtzWllqYllJMDg5dkxzcEhEYmlvZFZM?=
 =?utf-8?B?d3VBUDQyQWQ0cXR4R2tnKzRuZFpWM3lUL29BNjlMMmJkcnNidC9rY3hTMU9V?=
 =?utf-8?B?cEVXMWd5MncrTzA5S01KdWozNGVUWHFMdjhNSk1wRThDcjVzNC9QZWFQOGg5?=
 =?utf-8?B?SDZHZ3d6Z3ZXaEtYLzFLelFwTSs4VW1KQnVXNXJDSm4vQW5QZTVqOXl2Q2Fp?=
 =?utf-8?B?RDVsU2E3cnQzcmNjZkNuQzdRTFBVYXF5Tm0wRFVUTUFTd1ZCR0diTkdiTzN1?=
 =?utf-8?B?QUpaZVF5UFpwMXdqUHJoZW9zdER3NFhBRTJRUnNwNkdrLzJWZWpvTkNvZDJ2?=
 =?utf-8?B?STJ0WmxCOWZaUk4xS2taQW1zb0VOWmpIS0E5Nk1ZYmw4dzZrbWFPb3RzS3A1?=
 =?utf-8?Q?2HStvYpFlP7CoMG01UYN2RUTW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc285648-7cc2-40fe-88f6-08de1b4a111a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 02:30:06.2876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYTKCECWrbWhSnN+LSRy4KktNqMu06Df/90dizfERAp4/ROKI+wRsVfp3GU3INH7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6854
X-Stat-Signature: xxnu85akdnjt995acpktbmrom56bd6q9
X-Rspam-User: 
X-Rspamd-Queue-Id: 60B03120006
X-Rspamd-Server: rspam10
X-HE-Tag: 1762223411-297867
X-HE-Meta: U2FsdGVkX180cmSUskSpcLeJtAH+sMzH6k8E8jRIRpzY5GoJiEz6Zo7OoZnWuZLuhiNYYQoKMqsdKVTIlszNzOcISPPozxpy3SK5J/IJVIX+cmP0AAdLSsw9U+Z1NIyL3huSyLHkEQ8puYERnQ6VgpyMXd6WUzZEgXpRFhWso7Ri0smeR0vRC5AbPwET+IjxBH1wqo4NK6tFP2WURa3wwV3bX+DLtGNyZMa+CT9AOCRYFy/VHL/cMCkqoe/dq+q+LJcSG62hBXpeOz1Q54R/eLAw/oj1MftpZ1NU55Kz1wqlOzvyLR0WsoT0BAPdJe0v0owVY3oTwYaTjwK3+IKQ06jMQSRUy4VIWhew6wwGKtoJRXAgE7fhzKYXayKINIl8hsS+0CNxB/xOuZfT4epFuGaVUx0dxFNWAe5+pAk7oaCkx8UqjRa9/Z+OvuvXEA35w8tEN//NnoQ6wO9NEuv6iRZZqMiwyTy1NkRnkVrbnNqs65sFB3NPji0sO8AE/cvf/dcfbwXpMfzka20/x76S9eM7JI0IPLg/xsxclrkJJbgEpZia/lFyhKw6XomcEW3z+XZQ6zL+TOPs5TwdYGRNCLkKJqXTC5asWfHcHN19NjQGZBmA3REKnk4KqEcOFXR4kOHdEm95wXnLrnt2lB9sSStFT35Sb6whieskogJOY6Go7y4mbdd7cw4hceV93n5zsVKkRTaOByeD1yRkoNmGG2qZv0Mc8HLuvmQKzyse1/QqFnDsm9AG1IlxUNa53L9oSjS6XKAtmLMGMrReWKncS2+T706TIEPZSI9aK7eDX6m+HEmR7L4G27O6pq5IVSHMISFevxvmC5D7c2ZSzx+Tzvo4XsA7fiIup1O9refuHr/9JqBSOEOr5q6schsl+JYergBhJHMUvB0Q6dkA+7d0n9DXA4F4sGdXH6BWRcBKcdfnczVXPa/MVQrPVma51ILJ4ErvSCGsNrPg6xuxlNA
 pbAXsArv
 jFicrHZYLwI1FcUDfTrpCZRFtz2Qok2Nnu/tPv5FDe6o3C3cpCs6qnMAKSu0QB3wYFgqME3mCzPTLEYJFarA+v5p5SFRURKWoQp7a3+oUlaJwms08se1XC5CLWmstEW6lKqqBGXLXxO+er5aDikvdCVsrSSdj6q5eZQMImmsbXwF4bH/1e0VuQZfDo+lTb6oz8zw+69xiUwgFIV3aLX66fmIxacuI1YlGd0xgxCunRq4W1krehCkzCmQ+ebAbz+/rpkdRGlPuozQdAXB6ULwj5yMjfVhWLluaC5PUy13jdn3WlAhcvWeXTd5YjfSfXwOl1utWOWD2VQejmq+EYgijpODxvvMovPRY2GncyqLuyTqLQffUqaJ475rszT0ABrQOUXCjDhV9EO5gaB4RiPHUTUKQUF2iFVbgepnrZUX0KiT66aoZUVa2lGtrbqMSdVevpI2Hst1TVzl8VBXThPd6aJuiplZ8ZeY0hwgQe5Z/9RQBcEQYZCqe6iorWFxRA/qxy8/5BGl3ZeHif6SzBwIQPInihI9bWYl89MWL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Nov 2025, at 19:36, Wei Yang wrote:

> On Mon, Nov 03, 2025 at 11:34:47AM -0500, Zi Yan wrote:
>> On 31 Oct 2025, at 22:11, Wei Yang wrote:
>>
>>> The functions uniform_split_supported() and
>>> non_uniform_split_supported() share significantly similar logic.
>>>
>>> The only functional difference is that uniform_split_supported()
>>> includes an additional check on the requested @new_order before
>>
>> Please elaborate on what the check is for.
>>
>>> proceeding with further validation.
>
> How about this:
>
> The only functional difference is that uniform_split_supported() includes=
 an
> additional check on the requested @new_order and split type to confirm su=
pport
> from file system or swap cache.

You are describing what the code does instead of its actual meaning.
You need to describe:
1. what is the difference between uniform split and non-uniform split?
2. what order does what file systems support? Only order-0.
3. what order does swap cache support? Only order-0.
4. why can uniform split be used to split large folios from 2 or 3 to
   order-0?
5. why can non uniform split not be used to split large folios from 2
   or 3 to order-0?
6. The logic similarity between uniform_split_supported() and
   non_uniform_split_supported() and they can be combined with detailed
   comment.

>
>>>
>>> This commit unifies the logic by introducing a new variable,
>>> @need_check, which is conditionally set based on whether a uniform
>>> split is requested. This allows us to merge the two functions into
>>> a single, combined helper, removing redundant code and simplifying
>>> the split support checking mechanism.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  include/linux/huge_mm.h |  8 +++---
>>>  mm/huge_memory.c        | 55 +++++++++++------------------------------
>>>  2 files changed, 18 insertions(+), 45 deletions(-)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index cbb2243f8e56..79343809a7be 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page=
 *page, struct list_head *list
>>>  		unsigned int new_order, bool unmapped);
>>>  int min_order_for_split(struct folio *folio);
>>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>>> -bool uniform_split_supported(struct folio *folio, unsigned int new_ord=
er,
>>> -		bool warns);
>>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new=
_order,
>>> -		bool warns);
>>> +bool folio_split_supported(struct folio *folio, unsigned int new_order=
,
>>> +		bool uniform_split, bool warns);
>>>  int folio_split(struct folio *folio, unsigned int new_order, struct pa=
ge *page,
>>>  		struct list_head *list);
>>>
>>> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct p=
age *page, unsigned int new_o
>>>  static inline int try_folio_split_to_order(struct folio *folio,
>>>  		struct page *page, unsigned int new_order)
>>>  {
>>> -	if (!non_uniform_split_supported(folio, new_order, /* warns=3D */ fal=
se))
>>> +	if (!folio_split_supported(folio, new_order, /* uniform_split =3D */ =
false, /* warns=3D */ false))
>>>  		return split_huge_page_to_order(&folio->page, new_order);
>>>  	return folio_split(folio, new_order, page, NULL);
>>>  }
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index d1fa0d2d9b44..f6d2cb2a5ca0 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>>>  	return 0;
>>>  }
>>>
>>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new=
_order,
>>> -		bool warns)
>>> +bool folio_split_supported(struct folio *folio, unsigned int new_order=
,
>>> +		bool uniform_split, bool warns)
>>>  {
>>> -	if (folio_test_anon(folio)) {
>>> -		/* order-1 is not supported for anonymous THP. */
>>> -		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>>> -				"Cannot split to order-1 folio");
>>> -		return new_order !=3D 1;
>>> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>> -	    !mapping_large_folio_support(folio->mapping)) {
>>> -		/*
>>> -		 * No split if the file system does not support large folio.
>>> -		 * Note that we might still have THPs in such mappings due to
>>> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
>>> -		 * does not actually support large folios properly.
>>> -		 */
>>> -		VM_WARN_ONCE(warns,
>>> -			"Cannot split file folio to non-0 order");
>>> -		return false;
>>> -	}
>>> -
>>> -	/* Only swapping a whole PMD-mapped folio is supported */
>>> -	if (folio_test_swapcache(folio)) {
>>> -		VM_WARN_ONCE(warns,
>>> -			"Cannot split swapcache folio to non-0 order");
>>> -		return false;
>>> -	}
>>> +	bool need_check =3D uniform_split ? new_order : true;
>>>
>>> -	return true;
>>> -}
>>> -
>>> -/* See comments in non_uniform_split_supported() */
>>> -bool uniform_split_supported(struct folio *folio, unsigned int new_ord=
er,
>>> -		bool warns)
>>> -{
>>>  	if (folio_test_anon(folio)) {
>>> +		/* order-1 is not supported for anonymous THP. */
>>>  		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>>>  				"Cannot split to order-1 folio");
>>>  		return new_order !=3D 1;
>>> -	} else  if (new_order) {
>>> +	} else if (need_check) {
>>>  		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>  		    !mapping_large_folio_support(folio->mapping)) {
>>> +			/*
>>> +			 * No split if the file system does not support large
>>> +			 * folio.  Note that we might still have THPs in such
>>> +			 * mappings due to CONFIG_READ_ONLY_THP_FOR_FS. But in
>>> +			 * that case, the mapping does not actually support
>>> +			 * large folios properly.
>>> +			 */
>>
>> Blindly copying the comment here causes fusion. The checks for
>> uniform and non uniform look similar but this comment is specific
>> for non uniform split. The =E2=80=9CNo split=E2=80=9D only applies to no=
n uniform
>> split, but for uniform split as long as order is 0, the folio
>> can be split.
>>
>
> Per my understanding, "no split" applies to both uniform/non uniform spli=
t
> when new_order is not 0.

Not exactly. For non uniform split, any new_order value is not allowed.

>
> So the logic here is:
>
>   * uniform split && !new_order: no more check
>   * non uniform split: do the check regardless of the new_order
>
> But I am lack of some background knowledge, if it is wrong, please correc=
t me.

You are changing the code, please do your homework first. Or you can
ask. After go through the above 6 bullet points, you should get the
background knowledge.

>
>> Please rewrite this comment to clarify both uniform and non uniform
>> cases.
>
> Not sure this one would be better?
>
>    We can always split a folio down to a single page (new_order =3D=3D 0)=
 directly.

Not always, the exceptions are listed below.

>
>    For any other scenario
>       * uniform split targeting a large folio (new_order > 0)
>       * any non-uniform split
>    we must confirm that the file system supports large folios.
>
>    Note that we might still have THPs in such mappings due to
>    CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping does not ac=
tually
>    support large folios properly.

These filesystems do not support large folios except THPs created from khug=
epaged when CONFIG_READ_ONLY_THP_FOR_FS is enabled.

>
>>>  			VM_WARN_ONCE(warns,
>>>  				"Cannot split file folio to non-0 order");
>>>  			return false;
>>>  		}
>>>  	}
>>>
>>> -	if (new_order && folio_test_swapcache(folio)) {
>>> +	/* Only swapping a whole PMD-mapped folio is supported */
>>
>> The same issue like the above one. Please rewrite this comment as well.
>>
>
> How about this one:
>
>    swapcache folio could only be split to order 0

This looks good.

>
>    For non-uniform split or uniform split targeting a large folio, return
>    false.

You are just describing the code.

non-uniform split creates after-split folios with orders from
folio_order(folio) - 1 to new_order, making it not suitable for any swapcac=
he
folio split. Only uniform split to order-0 can be used here.

>
>>> +	if (need_check && folio_test_swapcache(folio)) {
>>>  		VM_WARN_ONCE(warns,
>>>  			"Cannot split swapcache folio to non-0 order");
>>>  		return false;
>>> @@ -3779,11 +3758,7 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>>>  	if (new_order >=3D old_order)
>>>  		return -EINVAL;
>>>
>>> -	if (uniform_split && !uniform_split_supported(folio, new_order, true)=
)
>>> -		return -EINVAL;
>>> -
>>> -	if (!uniform_split &&
>>> -	    !non_uniform_split_supported(folio, new_order, true))
>>> +	if (!folio_split_supported(folio, new_order, uniform_split, /* warn =
=3D */ true))
>>>  		return -EINVAL;
>>>
>>>  	is_hzp =3D is_huge_zero_folio(folio);
>>> --=20
>>> 2.34.1
>>
>>
>> Best Regards,
>> Yan, Zi
>
> --=20
> Wei Yang
> Help you, Help me


Best Regards,
Yan, Zi

