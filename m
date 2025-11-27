Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCE6D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8D16B0024; Thu, 27 Nov 2025 06:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0146B0027; Thu, 27 Nov 2025 06:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E9C6B0028; Thu, 27 Nov 2025 06:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 884196B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:39:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C3378A8E9
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:39:06 +0000 (UTC)
X-FDA: 84156190692.14.C98367F
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1FF0520005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:39:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=foot1LEQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jonathanh@nvidia.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764243543; a=rsa-sha256;
	cv=pass;
	b=IymC5hfufNjun5KaRw9pZVn6wNZiMBz9nIqFxmQ97x/QEHqhPVhzqTQbr2uq+QIh7QlD9x
	oxpbWaqrWylDWZZeeuXcp/CFAFSfdAgC70hp9iuMwLWnFtecUsGZbMYYdROQ3rlYcV0qHn
	bhfVM5mDXQkzqdHsyEQTuiFePzXhyb4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=foot1LEQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jonathanh@nvidia.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764243543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygMZzzJn8FPyqi2iur2kBp6ZdIz2g0yp5h7wFWZdi1M=;
	b=l2vJR11GrbDo4JpzY9TG4qIBFZ2osabEi1nmowfA+l8mxAcsTWwNpwWJN23Q9bcsY9xqKa
	NZ9nkRDweZAgLQitjZjC48OfJirPtwGeVHBgj2Ww3W5+T3PRgGq2STohKkvW6lkE1tKHp/
	kZIfmTp6wDHn+Nzbk+M5942ok70YCqg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZeev3Hksx2olmWOnyoC5j5hMs6yQcZhSk0NgN/zawWhX2zUIKKKish6Wm/0bH3DnSD1Xd6MxZCbE9Jkt2Y01Ord29pkmOG7pS8GFUUf7aF9kNbvm90hzb4MyJYdnucDo6567Y9WY9HWfx2/mVwS5dJgo5LEufU1MdAnyoAPVzPbad9vpKrqkR/zJsRW4E/WVH2cF8MMHw56YnxXB5l+2REJgLGVTxMQL4jRT275Ga1xlIhlGyXmrLruAj0ZEApHVM2JiqRFT++qxAN3/MveBCPIC2cuoYwXbGBjfDYUFtbt/cTucJM/pqNBDG55K5/qFa/OucdL2h/s60ceTFZCPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygMZzzJn8FPyqi2iur2kBp6ZdIz2g0yp5h7wFWZdi1M=;
 b=QC9rOQi/nN08kJGA4PO+Kyg7an8HUnlF1uEMyeTWs9/9mrnS9iurrrACp+R/+DTFHJNRypoKhmlS3o3iYjURYHqodJquhs7ZeAdSV1aaChsgbYP5Pb6+2uzUls7Jqvb1VxYGN96vJ2s0BfgkIWUTjcGZAJ3rYmxIAJnNFgBmSvG1N2+cpbk09TIfsCL803eqzAzfCmayHjQ9kGWaAR38i/wFoL8wbYkdUIJ0++JC8C0QZ+CVKUV/EhrI+igEDmtUw9+R5Ke6PsruxPronGK71unYOr2XprC6R6hi8s4XI6c4U/fHi3EjBkZO9Jrb+6pDkVA80L2diOS3lhWoir1C1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygMZzzJn8FPyqi2iur2kBp6ZdIz2g0yp5h7wFWZdi1M=;
 b=foot1LEQDAmjIvYddiD9qdtNItpo0jhpouMlrbC/CiwbRmbvQt0bqq8DDnUrO3+eGoiJ+BIUlDQ0RBGfBEPcjIWUFyCTFdfoPmQQZUSyQAmR+dcTGZGFI1ru8pAbN1vB0wxX2GWgnoRxO/ws/1cyfCZxV/Q5eRnx4OBF7Q+dFtJRHyT62APrTYMkJ4e5vPi0ZOzP+DXTTEmCs0wMlwEDUxXt84i3FzdeYn/SWA3ak1g+yrcnh6IiPwvFlHgckXPsMvtUD/eR2ehlVUh2J+vKP3kWJ5/zPdjETEkeAxDwucj1AvlVhogbz8nBgf3ST6kZ7CxJfKxUTmQxiQDvYnJAYQ==
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Thu, 27 Nov
 2025 11:38:58 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%7]) with mapi id 15.20.9343.016; Thu, 27 Nov 2025
 11:38:58 +0000
Message-ID: <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
Date: Thu, 27 Nov 2025 11:38:49 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
To: Daniel Gomez <da.gomez@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0448.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::28) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 31710289-d6da-444f-d745-08de2da98d57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDd2ZlhSSk5PbkVmaXhDVzlXRFcrR2lkYWxueWI1UXdUVGFscXREY3NOWjI4?=
 =?utf-8?B?SnIzZmFRRFFxRG1KYXI4MmJmQm9pWDBqTm03VXI0eTNqTFBkaDFCSEdiWDRz?=
 =?utf-8?B?UjRIRWMySWxlbCszamwwRXdSbnQveWJjZzhRZDlKdG5SZHZFMWxCZFVhOHNM?=
 =?utf-8?B?VU1VdTRiZ2E0cWh0RlRLdlJCaWRMem9vL3lHWFpFRUxLaWI0VG53aEptdll4?=
 =?utf-8?B?Y05yWFZGTWNuM2w0MElucDZ4bVdpNXJsVVd3YmxTZkhmS2tESC9qRWt5YUNs?=
 =?utf-8?B?UXB5d1hncS9xdTFXUEpKTmkzaDRaeGxpSFVJVDRoUlR6QnJ6ZXVXWmRBMWVB?=
 =?utf-8?B?ZWRaZ1lBMHFWekM0U0N1WXdWb1VxOXA0Y2dJU0IvT29vcUE0dFlleDQrZnJN?=
 =?utf-8?B?QUw5K2taU3pJMzh1WmJ3ZVhRK0lyeXZYWUJTUVZ6YVY4WWVhdEdGQWxGNUw5?=
 =?utf-8?B?cjhqdGRxZmh2MVliVDhRY0NkdldCNU5ENmhmeWR0V1ZkSTNIUm0yaGZ3Qlpa?=
 =?utf-8?B?ejRaYWdnQU91SlA3TzhLZmo2dDNHMnBkQUIralpoWFduU3hvNVdKQmtJSTc4?=
 =?utf-8?B?Tlk2c1kvNHVwZG1MWW9BUlJPYkQxWlpqb1UzUEFCNWpQYi9jVStLMXVCVmlo?=
 =?utf-8?B?bWJJNU94U0Z5YWhGdDdVbENySTUxemVpTmtkVFd1Z3A5WU91dlpLMGlRT0Yw?=
 =?utf-8?B?RllOVmYxYS9NZEtUbnRYUjVHSUVKRVd1ODFZeEZ2ZHBlN2hmVlNkRURVdGJ2?=
 =?utf-8?B?MlRWVHE1aEVTMDdzelJHTXdSU0UzSmwwUFNEZzVVa3RwSVlrSGRZbTV2OEUz?=
 =?utf-8?B?QW8vT2JBUUlWNjdDWFVzUStNT0ZtSmZmSW9XbHVoTVVQbTZTSGk2U2c4R2hl?=
 =?utf-8?B?WGsrY3JJaTBleGNsc2ozUzVCeWYvelViVmVKLy8vUVEva2JIR3JKcUZSbC9J?=
 =?utf-8?B?TDBmTjFRem0xVWdiR00zbzlUbGthc041WnRZZWdnbnpxT1VWSVRhOUUxaXN6?=
 =?utf-8?B?NEdyQlQwd1VMRTRUV1R1OWxXRm0rLzZ4dDhPOVFOakFFbUFXK0l5cUJ6Zzh4?=
 =?utf-8?B?dHFqd3E0Nm80YVE1Um1DR2ZuZlkrdDNHRWJyOGhvTi9vNGZERUVzeW5IR0k4?=
 =?utf-8?B?WHBmSzhCeGprbklYeDRFWkdOQ3BKc1hKT3QrT0JVU1FoeXVJc0hvK2VTL21G?=
 =?utf-8?B?QWh2R1lQVzUranlQRTNBbHJVN1g2QUpScHZVMzBVL1I1Y1paVG4ySjhBTEcw?=
 =?utf-8?B?aFgxTXkvbjNDV3doSC9DNndsRjFSbzk3UUdJQnFkRm5UbUdzYTZpNVVVTiti?=
 =?utf-8?B?SXUrUm5PSnlvWFE3MHNrcUNMQnJqRkFhVFhPM1JXbG4rV2oyNU9PbElrenFm?=
 =?utf-8?B?cGl6WXlMdEhMYUN3UFZhYlZBZDFRRnVNOGoycytaQ1E3RVZrV2FqWEhTK0dO?=
 =?utf-8?B?K3c0YWcwb0E4OSthYXlkaG5VcS8xekJzNnczRXprZ2hqL3ppYzIxVmRwL0Js?=
 =?utf-8?B?dm9LRFMyN25QNjNQd2ZtdEczN0hHTTl1L0RCZXB2cmhFQnBjR1pKWUpRT1dn?=
 =?utf-8?B?YnNsbzRWMkNJYXNtb3Z3NTRTRy82K1IyK2M2WTJ6WVhDT3JReWlSM2ZZZnNH?=
 =?utf-8?B?NmN4SUtOTmt3OTArQWVhdGQyMmZWN1lScVZ1dHlpc0lQd1d1MWhCVnNhM05N?=
 =?utf-8?B?SlB0V0R4Nm8xcmNpbmphdzJtWFhya1J0bVluend6MThadW9lN1Nwa2R6aUdM?=
 =?utf-8?B?MDhxeElFc3p5by9MdVF4a1huUGJCZzJPb1BxOGZsbGVka1hVeTczZEdnTndu?=
 =?utf-8?B?T2srazVqeE1zdHpvRjRlT2Y2MnhhNkZjYlBjYVdkZTRhYmJyK3FUNUFGZUxn?=
 =?utf-8?B?a0o0TGdYMm5xMmpudEdNd3YxN1pFK0hxMW8xZWI4S2EwdkNHeUYxMDlrUGNX?=
 =?utf-8?Q?ynuYBqDMUHvkjq8uWLI7IFivl8NvBsK6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXhLLzJTYUVZeEV5eUtDY3Rqa3FmSkZTb1Y2eHVoaUh3dE5OVzZJUGZ4L05q?=
 =?utf-8?B?ZGdERzkwMlZCWUJpdlV4Q29Pd1h4eE44YnpCSHdwQzZ4WVBsWWgxTGRXa3pY?=
 =?utf-8?B?RmdqbGJoT1hHcTcwd0xxOTBzays4VHV4KzBDT3p5NXhJZVVkWXJQL1R1MVNW?=
 =?utf-8?B?ci9UZnNKQTRuVUNlWGpBQStaTU5FMDMwZmdwalloc0RISFMwTk1PK3RyN2Y4?=
 =?utf-8?B?MFNVR1ozY1dwNUl3KzcwOVFkQmk0eW9tSktRRStrRmJoODl2UHFoYkkzNDR6?=
 =?utf-8?B?SlZUOVBtS081YkttNktxNzNvU2oxWkN1T2NBOGpOb3VnM1BCbUNEMjNLdlZS?=
 =?utf-8?B?c2hvY29neDVkb0ppd2Z2V2ZQWklqMEVQempHdEtLK1JsNVhqZVViVHBNb29h?=
 =?utf-8?B?dlRpQ3BXV01peDBySGx5SytBQldObkgxOVBIbEUyMEdDK1RSdE5xaUV1ZUNm?=
 =?utf-8?B?UHpRNmZaWjN4Vm44QlhJQ0YzZnZzcnk5dnBJTitpWTRHd0VaRXI2a1VYdjZo?=
 =?utf-8?B?Q2lwK2U1Snh1TDFCcW5odWMzZWVjK2pkSEZpSTBsUWlQL0hpWGlzMmsyeDl3?=
 =?utf-8?B?TEhQQUVsMngzUGcrd0JlV2IvZUxpcW1wbFFxMWE3KzVtNXhlTUt3VjhobWov?=
 =?utf-8?B?aElyTmxQRi9SNnhZYS8yRmhuZTI2QTg4NU1yR2hwTEpYTlB2T2NlY28xTDYv?=
 =?utf-8?B?MitSeDgwa3k0LzlUYUtUZFVZMFZibVkvNXhKcjUvNlNLMDJ1Qk5PSGJDL1F3?=
 =?utf-8?B?U1cvcDBsY3dxY3ppY09hb29JUWttTVczMFRzeVhvaVBZRnVzWWNsR0FoaFMz?=
 =?utf-8?B?cjMyaVJrWVpFSmNEOTJZa0lvZCtiWUhQQ2xqU20ySExvKy83WXd6OUtCRHd6?=
 =?utf-8?B?d1RaUWs0ZHJwaFVrTFVySHhGZUJxY2tISEw1NE5rYUZxM21lNkdacUpLeTRo?=
 =?utf-8?B?L0puWVE0MWc4V0ZRSlAzZ0JGOVZhbWtaTDRHV3Bqc3RqSFcyTExVVGNReng2?=
 =?utf-8?B?cWk0cEJTR2t0U2dFbE5ETXc5Z2w2QVJKb1pab0RYTkhFYlQ1UEVUVnhKd0dm?=
 =?utf-8?B?QlM0VURIa244a1FIcGVhNEJZbjJHTWVmV0VCSE9YK0ZqOE5mdWRtemdJOEVH?=
 =?utf-8?B?SnhKdlNIZGJZalVEUjljVGx1RGQrYyt6aEhBSG00Mk13eml1UlBLY0YxNExS?=
 =?utf-8?B?WS91Q2xxb2hLOElTcTBCaWxXRUlOTUhsaEdONlpXdE1wMUNIeHliUDBCaGw1?=
 =?utf-8?B?Wml3Q25jck9BclVXbWs1V0hYMEh0c2J5UVhWVjZMNDBLZFhSWmU2UHA5MERv?=
 =?utf-8?B?eHRrcXpKcExhSldyNlVDQytxOGpZYnRIWUh0R2JSaWl1NEdkVVIxSG43L2xM?=
 =?utf-8?B?WXYvV28rVnUzalNTallEZUQ4OTIyTmZoUjRXR1hmV1ZLSUl2UXVNRmVscjVM?=
 =?utf-8?B?SGtCQ3lKMFN6dHh0bFFTOE5EdldNM1pTU0RDYkNndjNkaGJDOElzc01BUURP?=
 =?utf-8?B?Njl1ZGFSazBKTzFhSWNGR2lvd0lpZDBwUDc1WFl1eks3ZWNORnNSb0VpZWVB?=
 =?utf-8?B?QVFmY3QvVkJydnJTUE05TWpURkN2RnA5dmt1R2J1UTI4dzF6bjNmVGU3MVZY?=
 =?utf-8?B?Z2Y2aFVpeTV2dTQ0ZXFsMGx4ZDlmdjhSR1RlYytxazJlamprRFJMWnVkN2hE?=
 =?utf-8?B?aDZ0WGFLTmVJQ2RnQXlKWC9mSWJrUkhwNzYzVm9QNlM2L3BlUzVaejIxOWw4?=
 =?utf-8?B?MDN3ZHlLd250N2t1TFVxdTJFSDcrTDg4QTdISWZUUHhFRXJvSVYxVkZsU1I3?=
 =?utf-8?B?cFU2aTdDeUE4UXQ1NjRKRWZNUzdDMHh2QnpSMHhnd2daR1VMTVdtczBkR0ph?=
 =?utf-8?B?TnpscGFFYXIxd3BpL3BsUHJnK0N4MWNQblYwSWVOUXFJQ0JDMnk0OEQvUUp6?=
 =?utf-8?B?NjJIRzU2ZjdLT0dpYkxyaSs2UnZmeGxtMGhIUGE0ampvYzFNdFlmdzdqVlhk?=
 =?utf-8?B?Mkh2V3RldGwwcVJqTXYydjRaOGtIemQvVEczWTYrWW9KY0NTczJjbGRxV1RP?=
 =?utf-8?B?dDBaeTlZWDMvcDNHTkFxdTJxa1FpNWR4WHFuTW9oYmMyYnJXbFdodk5RUWpX?=
 =?utf-8?B?azJMQUxKNkFQVitaaHFtdG5NU2VRMzI4UVlmZCtDdFlSbUlsYThvVU56a3hx?=
 =?utf-8?Q?1QeXqV3/YM7N3jdZefyXn7ualM6jNlHUlf+LpReXAvmZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31710289-d6da-444f-d745-08de2da98d57
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 11:38:57.9799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39KLFunK/BkSAyjLNPq7iF3bBjKy7B/FOp6MJqoA+NfINggGpw4SCaL061ZRVChI4gGPoE0fU5GMNURSy+d6vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FF0520005
X-Stat-Signature: kymfc4rgii4cdsfkk9n34wqc4hnr4m7u
X-Rspam-User: 
X-HE-Tag: 1764243542-838736
X-HE-Meta: U2FsdGVkX19XdQOSmKe+iz5c7hzk5zbxqXqJ5pfid1opUwtLW1JVSU0V32cvl5rTGlxZuf9xnsJ1B8f0Xbj9bPPaducFxpHTMljTTRLd4HCCtwW8a0oyqnGPyN9b7n+k3y5uqShFBP2ITfZJ9w1VN4WEoOWU+z4h+9VKZ9nvvxhv4J4myiXHw4Qg7+gfIQHwcJP+5NW/50OPCl8j7L7HQN/VNJHG0ADhbqCO1MsMMUGAsDIl95llYUShk1+T0wDQsy4iUJ2f4St6rV4PDl+0hYGUQiSfwxbyucTG7c7tqf1/PWQMra9PkwIGAnADuY5EuZpUf4jfar0JmqcL2iBOxphKqVfHFbkOidd245cx2BaPRnUDexYFPBVNcFzRaGU8hDhFUDxl0TH60r/GoYPUO8lvuwBEBCJhQNkAdc4YKIhgSCZOAqlTrtlkxgcYl0J5TTrpnyqtLJ/sCvfIGPFKplSsS0nRTmx2CJjhlbWp8p02WUnHCEMGlrZXWJVS3dzyrv0xQwE3zEGnsOeT1TBExSrR1a5J0Q8xpqWNEHcxohh3ImxkVyCm5iBCdIZXLTfm2OaF3jPYPMW0aiJcBSKgHu74L/FcICTdNOk57qI/d8/W97Vw8MR6skhYFZO2+BIf7LbF65kqB4t8+UK7hq6TC0PWBC/KSQnRVaVRu6AvQAr3bNLqZ5jvJk0OKiGj7h3uDEhk2IrX5on+cfT9SiIk/bE9Pa5+P/wWpknqjEyN/q1XaH6RBw2hxiL29cVvA9pejreNwbPNAFPk8D1a6AmgcKi3xYAwBh7p6u73zsnJACIwUrBvwNZNyPqtzCjfkXQx1J69ummyq4YNJzy/z5fdv0BqGaQmLpykQKgNgLJ70Dt+hzP6NS1WhGErzX7pLgsiwt4LKyCg3loIZxmLXs2LS5F4ZXuSIXixYFwYq8jO3TuC0WOP/JX3HqT+ff34cqJ+hhNUd96qqUhXGorq/Ix
 tLdkA3/x
 bMzqF9JmRQhERd3fhVDkeq2/fHAIPW7LnfKq27ydN0J4AU7Xg/rkRm3BIj6wu7tJAISH8HLm/kgkPWrQtobkCrxI5uJwpUlJhb6ID5NP7jWMghgJFNKrD59UMrKk1wUX9gmu1YTu4Pluf8NLhC3QAVYfqCqG7WfR+fpSvSYQH6+cZWOTUvwqPuo9faoym7KlV19FNGWilVjXkUzDRJgC6JfrkU6pN9IAhiICoPYsYrHiuB/FHKx4US2FRLbXoLhbtH0YxxBK50GFlY8aRTzpCKdsI5fS+KS7AVtfT7woN/xHbgw0AiJMvYFjTIGJKjQ7CyhUN3Y4wBFvTMhxIZ/PaufxX3FiVmi+3tEvusW7QyrouEOQ+1d/e0fbcZ8OYIWQn0x+5si3jQwzzaBQbWAne/nPAGiJ9YywicsoeXQAM62qTpdqKBwZfgIu76E6i4CjC89Tqquo3VKocRbCfAyh1nphcNiB/X+5iURQBa//RaAmWqyF0l+XaqIO+gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/10/2025 21:32, Daniel Gomez wrote:
> 
> 
> On 10/09/2025 10.01, Vlastimil Babka wrote:
>> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
>> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
>> addition to main and spare sheaves.
>>
>> kfree_rcu() operations will try to put objects on this sheaf. Once full,
>> the sheaf is detached and submitted to call_rcu() with a handler that
>> will try to put it in the barn, or flush to slab pages using bulk free,
>> when the barn is full. Then a new empty sheaf must be obtained to put
>> more objects there.
>>
>> It's possible that no free sheaves are available to use for a new
>> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
>> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
>> kfree_rcu() implementation.
>>
>> Expected advantages:
>> - batching the kfree_rcu() operations, that could eventually replace the
>>    existing batching
>> - sheaves can be reused for allocations via barn instead of being
>>    flushed to slabs, which is more efficient
>>    - this includes cases where only some cpus are allowed to process rcu
>>      callbacks (Android)
>>
>> Possible disadvantage:
>> - objects might be waiting for more than their grace period (it is
>>    determined by the last object freed into the sheaf), increasing memory
>>    usage - but the existing batching does that too.
>>
>> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
>> implementation favors smaller memory footprint over performance.
>>
>> Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
>> contexts where kfree_rcu() is called might not be compatible with taking
>> a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
>> spinlock - the current kfree_rcu() implementation avoids doing that.
>>
>> Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
>> that have them. This is not a cheap operation, but the barrier usage is
>> rare - currently kmem_cache_destroy() or on module unload.
>>
>> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
>> count how many kfree_rcu() used the rcu_free sheaf successfully and how
>> many had to fall back to the existing implementation.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Hi Vlastimil,
> 
> This patch increases kmod selftest (stress module loader) runtime by about
> ~50-60%, from ~200s to ~300s total execution time. My tested kernel has
> CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what might be
> causing this, or how to address it?
> 

I have been looking into a regression for Linux v6.18-rc where time 
taken to run some internal graphics tests on our Tegra234 device has 
increased from around 35% causing the tests to timeout. Bisect is 
pointing to this commit and I also see we have CONFIG_KVFREE_RCU_BATCHED=y.

I have not tried disabling CONFIG_KVFREE_RCU_BATCHED=y but I can. I am 
not sure if there are any downsides to disabling this?

Thanks
Jon

-- 
nvpublic


