Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1438B10F995C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 16:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3647B6B0088; Wed,  8 Apr 2026 12:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE936B0089; Wed,  8 Apr 2026 12:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F1F6B008A; Wed,  8 Apr 2026 12:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02DA46B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:25:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B69D1401D9
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:25:06 +0000 (UTC)
X-FDA: 84635913012.12.F8AECEC
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012044.outbound.protection.outlook.com [52.101.48.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7E65E12000B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:25:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KIaGJDin;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 52.101.48.44 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775665503; a=rsa-sha256;
	cv=pass;
	b=yRfJzXMa8bN7gfBx1OoiM6VW1EbTp/eQWhbZ9UIWrergGWsBnZIj1kLvK3Ik67XJhZTTnS
	mx4zK08x3nUAd4xCdebfR7DnMAr2VD4rqIezNo70TzuM67V/ZPaIbG2HtHFB2qfO9fozcc
	3gjLYgduXBh93CWG3ji60H8iAQmPvp4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KIaGJDin;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 52.101.48.44 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775665503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3krT9zRcJrpdMaMtrWcgY7p+GO06AvrZEp9K0KnYdJw=;
	b=8mJzkFkxZ3e4827WlPlcs87/5Cy6YbGE5BwI8M031NtLWbDeowQ5zymDhA5QvAhvD3YE7D
	I2ZhJIY8K7TbcuKmUk3jZx1APAV/+gsNc4ZH/ULbSK5tk21KEEpmgsFiUgJdr1p+nbujkJ
	2dp4sSEw+NhEJ0iwxlsIb03T809Isrc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VyeZEDisVEyuiBu15ipKB4W/f1Dx3RgsPINSlFqyjZIDoWpgPl7PgAAqZX5HuFRQwP/WkbO2U2NpCHWiLlEQ0quq42GCdbAPER77kfGLIbjSuE2t7up6UbpIXOTygxI0aSBk9/JzCdOQOepCsomEh2/zws6FJaRG2WyLQR8BSn10kvUr+j0vi/tDYDSvHfGcIEWhY/e3Gi/jeRsRLhVhdldL2U179eXsP/MeWVb0TxeVshNuNil6VhYWyD1ZQbA4KOsj+Fv3wFo/R5kNzsZhcjBZEW1Y08p6zErFd3m6In/Ud64J6qjKn57LBm++skWbrZzGlaIGiiQW8v7lLxv65A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3krT9zRcJrpdMaMtrWcgY7p+GO06AvrZEp9K0KnYdJw=;
 b=TlpoZov7x43b1tPu2MN0sCwFmjyr7K4rxYKGWC+sdpIwCNLHwKEwJ0rp0TWgMjWia+nDA3tkS+vXZY2KukfjoyntyLBflaojy2yrYE/yRK6XA74D/zd4SYEuEjnn2WLr44qpA4Gg501l7ZLLubOcg0GihHhLDx3/tECoiNiIUbJNa37rVTmnBBgtDmmiK5U0VnSv3JAWnAS0gp3+U14QNBxy++D60qab7sSPDmKZl7PKZRcRQajBTuDCinXcqeT1W2ztoYO/miD7fqEKG36sA1kJ9lofiAvuSA1IVW82y5FbMviEjdv2x0juT5n6Y5IB3m+xDLvA0NpXoe9IBca1Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3krT9zRcJrpdMaMtrWcgY7p+GO06AvrZEp9K0KnYdJw=;
 b=KIaGJDiny9qS9EsFoZtVCoEhcSQqCgUbp45Qz5qYAKCkGJda85tYr+4HVUjZ21AMa7Poj4quuaHbvmlRuO2muiYSNMFTskKnWZwcWoJPUglT9MkQBVyzFmj8s7YBfs442G7UMXEbuTuboa/UzcbvL6xrpNZaY5LJgjALBg8paQQ=
Received: from PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13)
 by PH7PR12MB8826.namprd12.prod.outlook.com (2603:10b6:510:26a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 16:24:59 +0000
Received: from PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1]) by PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1%5]) with mapi id 15.20.9769.016; Wed, 8 Apr 2026
 16:24:59 +0000
Message-ID: <938cf77e-6b66-4a89-b0af-d9126d497b8d@amd.com>
Date: Wed, 8 Apr 2026 21:54:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
From: Raghavendra K T <raghavendra.kt@amd.com>
To: "Salunke, Hrushikesh" <hsalunke@amd.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bharata@amd.com,
 ankur.a.arora@oracle.com, shivankg@amd.com,
 David Hildenbrand <david@redhat.com>
References: <20260408092441.435133-1-hsalunke@amd.com>
 <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
 <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
 <aceb0077-b206-4484-b102-07de537dcb1e@amd.com>
Content-Language: en-US
In-Reply-To: <aceb0077-b206-4484-b102-07de537dcb1e@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5PR01CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:178::8) To PH7PR12MB5805.namprd12.prod.outlook.com
 (2603:10b6:510:1d1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5805:EE_|PH7PR12MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: a6919d3a-5bb9-4ae2-3f72-08de958b6092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cdO+SPVgrhe5Luin1Lo2Thh3EgSCb/HD0XmPMBZxUBXDCHjRKMccyHuRwVqMiNstmG9LofrRLNyxq7JWXuoYA0Or/3+nO8+cbZYuu3UWt8IouGYFwufnddn3Z39zLe6PTuTYUDEsmpV0xC3XVy+Ui+B2fnCkBor6ZusE9JLuGb8UhBzKbYIzdR7bjPL9cbE4PWEyvYIHePmDz4wmoyUozNdCxUj3gyrc0Eju5jdn/091FKjKl6WDF0sOv8Vf49pRs14CR8rbsFKMAUR/ESD03qklQEZKzjWBAPJJXERn7nTk+w5mytoat5lzd0Duy3/FWaDm/G1/mfFkgMCIy/rHM5U51l2IU622hZWGGW7PG090J/TH0x+KsYFf7Y8mDA9aF6CKY6jfkuyhs9H1zZjEtMhE9dfO2ao7kj45QqTmMOwIM4gvLlER6zSXhGdRcKpw70ZkunYMnsg3Ww0EEXcoJNu4JPvYsuN2FUwU3tpzYlFQohc4O/j4/a6snkzq/zBA53bkMYYYIURS16bsXdaMirvw/k8rv2sLQ2ys6BoW9kkY5Q33scXaWDlxadWT7VBYC1pnsQNxYFgDsCIMRv8LVN0qezUY1E/ieaDvPTeZv/TngcN5KP4GNvz0n3/P9SKLs/eN3kctZ8dTSN3T64eByTv1Ak5Ad4j8PzxLGQ5k4uqhIBMYSc8jYULUQ90VMHYB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5805.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjJSWml1TERCTHNza3A4V0Y0UWQ5Zm5YNjZTUTk1TTlYaDFxQnBFREFjWllz?=
 =?utf-8?B?R3Y0UVp5SFFhVDQ2TDU5bEFmSG9YSEIza2JqRnc5bjJKeTErYXVPMnNYMEpp?=
 =?utf-8?B?Q0g2OGpQa0xGaWVBZkhrWTBOM2s3WHZ2NGM4TUZ5bFA3Y3FEclBCZm9WSmRU?=
 =?utf-8?B?QmZCaTh1NFRNWWtwblNrWGtYZ3F6aXZ2NXVMaUd4MDd3L3ZlQldqZkJjd0Mx?=
 =?utf-8?B?dzNvOTNqTzFWY3Ftb0tOb0ZxaUJabVVMNmRrckQrQVBFUGdlSlBxVGptbXVo?=
 =?utf-8?B?V252c1I1ajg4MGwrTEgycWhhNFphaGdLd1Y0SkZrYTNPcWlQVXA4bVNNWmFz?=
 =?utf-8?B?RGc3MVlVcXNZTllnV3FPNW1HWDZnMVVCYVBpWW5LZ1JZSERldjVobGZKSGNI?=
 =?utf-8?B?THVVeVVYWEdLT21LMVNLUlQrZ2pqdjR4VjIxc2FyQ1RnaU8zdUJGWnJjTlRS?=
 =?utf-8?B?STBkdkFzOThrbC9tTGVvbTZxUVlNaVFDY2g3MzFKUHQwM1N4V240c05BQi9Z?=
 =?utf-8?B?Sy9Id21pQml1VHQwZTl5Nmk4OVZkdllNR3kzYXVTeElRcVg2QXh5RDNXd0pv?=
 =?utf-8?B?Rzl3QXFDRUJ6M1Zac3RGZUZTemorSFp5UjN5QXRESXJBNFRrb2xPSWZWOWg4?=
 =?utf-8?B?N1JHSG9qTHRNYU1XUFQzUVkreHhWNWJJQ0dnL2ZsWXRFODNoN21FY2tUWW5s?=
 =?utf-8?B?aXdic2RuRys4dnA4ZXpZQm1wODNWK1dEU25Fd1BmNHdqNTlVYmZZWFdEaUxH?=
 =?utf-8?B?eTBSYUxnS2NuWDh3MnNpNHNpd05hdHdsRDV6eURjdGcxRUhPaEVkQnYveTJP?=
 =?utf-8?B?NXNzZVJ1L3BjSEdKYXZpNi82QUhJbzdoR204WndMWDFyUUJ3Q2xqcmRhcFl6?=
 =?utf-8?B?a1RaTnN5SC9EZ28yaGY5ek5rVXVVU1V6VWZSenNVU2FaSEtIb0J5b1YzdEV4?=
 =?utf-8?B?MElYSThIZEwrWmNQcVVzck9KSGNvVEQzOWtyK1lyL3pFTDJTOGxnVFoxaHoy?=
 =?utf-8?B?c2o2NmpVZ3ZadGhVRXluSW9UWDFyV2pmUzYvR1BYSk9OTHo3ZUcxZXBOOFJp?=
 =?utf-8?B?K3VJaFA5WDNadjg3cWhabjJNNFRqQ3BueXQwdFh4eFVyNWY1WGhYVDdrRDMz?=
 =?utf-8?B?K2tYMnlreDRSVHFBZ1NUVDRTRHpZZW9tSWRQS3hHOE9nUk13azJvZStCK04v?=
 =?utf-8?B?YWQzZVFPazhyNlZFNmJCdVN0NDVsTnlBdmllNytOLzY1VEF0WkpraHhVUkww?=
 =?utf-8?B?ZHQrU3B6c3lySGgwOWlqVWRwVS91clZvM0lTU2szRHRaT1ZvUGl4bkd5SVl4?=
 =?utf-8?B?NCtjeE13Q2NJTVRYelFveW5GOGdkQkFzcENQYmpzMXg0dnFqTVZZblRLd0Zl?=
 =?utf-8?B?V2xoc21YaGZZU1BlamJydDNRSUdQK2N1cHQrYTJyMXliamUzSlZVZm9zTmFI?=
 =?utf-8?B?QWNzdGc1ZXRubkwyeVNNd2xiaFFrZDdQd0xlMU91RzREeVVXY0R2OGZ5Vk1t?=
 =?utf-8?B?MTc5RUxOS0hBMFBkY0wzc2U3bUtpUVcvZUl2b1ZlZDV5VXhaQnhQeHBKc3hv?=
 =?utf-8?B?NmJ3NWFNZWQ3ZmdCOEF1cGJwbm4xTUxnazJBdFZnSVVaZVQyOVV5ZGI3Yy83?=
 =?utf-8?B?K0JsQXdPSW5uMGFOSU1TM29yTldEZ0MrZHY2b3g4UWxXanZhZWNXZW4wNVY4?=
 =?utf-8?B?ZnBGcTVqZUZtWFJaU3RDVVR1aDQrK2U5WHN6a2pWaU0rMTVNazhlOWlBeVFX?=
 =?utf-8?B?VUM0TzFiUzBFbnNqN0tSdmtjMGovU3RZZ2ZKeUdsUUgyUHpvZGxPSU14WkMz?=
 =?utf-8?B?bXZkcEk5KzlRR0N1d1ZWcldRbnk4Vzdoek1kOTFncEIvS01HQlBYcSs3NDJp?=
 =?utf-8?B?cUR0UFEwYVQyMDV6eXBFKzVsTC9qTVN2bUZuS20xeFpQRDBUaC9tYWRYbEg2?=
 =?utf-8?B?RnNtZTRic0RCbWdYc0pFNHNsV0dNRkwzdXNOaHZKUVFoMkk1MjhkTzJIbllG?=
 =?utf-8?B?UmprWXpJaFFUUW1tWUV6a2NlWXcwd082bTZBOWwwUHRLZWpEMjI0OUV6elFs?=
 =?utf-8?B?b20wUjgzNXh2UmVVVW82MlJqcWxLVWdORU9GUWFzQ2JIQUwvdDNyVlZSYUNY?=
 =?utf-8?B?K0t2cUZSS3kvb1ZSdUFqM044cUx0UWFIYUhJUFh2bFlQRGF4dktHMEU2clQw?=
 =?utf-8?B?NXhsTzBpZnhOL2NYRFY1d1ZFbXJUMUxFUnpHUTIxcGtzWDhpeEhsVDR1SEU3?=
 =?utf-8?B?YXdzeXB3ZnVmVzFuMkxCTW9udlRRR3RXWnFTb2VzYVZoVUVva0ZlUFowcmtL?=
 =?utf-8?B?OVZQVmplTSthUmd3S0g3WmpLSkE3U2tiMmNaUUQ3cktGN3FDY3FIUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6919d3a-5bb9-4ae2-3f72-08de958b6092
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5805.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 16:24:58.9842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zLH/9/uDB0e/RvvWeSZRPcUklhlNOFf7GsDtYo4BOvuTZHIQLRGcLLz7tvvmTKiD567PF4gH87CucBUPEabXUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8826
X-Rspamd-Queue-Id: 7E65E12000B
X-Stat-Signature: xuwxgtfmkz3fikeawc8g3acb9tm7anoz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775665503-880340
X-HE-Meta: U2FsdGVkX18YiaZjzj9VIaxdVITVND5miy1YykG/SLX9j6HLfh9j6E2sbmr8TylEqTHFFdM8BgtDL6tJcdp+KqzixjNxtwkdHZVD59jmRLW9r85MTyGXoHUYI9AXZrWUMh+mDPug6J0M2nGJGtkzfAjV0L2HNTD+zCekS4Z4C8sQDdBMnY5MaaqltGoIXJSpVOLM2rGl0WAwb7EEAQOxTTu5yDLakP2fQv7gxQVEX5GT/06LmsvqHhrwKsOP826CjtTokvuRHVKKZvWuiD4CgOH0syoOCS89+V34xG7gBXjQ28P3kP8BrT4pqM1DjrF9pWALbx0w1GxJyvg+wFPy0AiU93NvoJWG1xqT8EpMQEDAtQRwM6i6fT4fGbKsqlZmZpaJoEg4idkiSFOIvh8q7sruZG0088X/+P8kkXMFgqIKuG08COns/EwbKzbDOqeBurtOaKRLhdks0qsUIZya61bq9FJA177C1wS1CTtbZmfiyOsIXWEcNvKMqBJcy2GxAjZhwJqXVUclgTbAkcf0miSqJsm5WCiDOOJC+OFAY0Y6xdocyZ5z0bPhN9s45RnvUqGpaiqmR4m5XFbFzCKXSDqRczQ+fiAiQNG9T29DAHiHBhXLmtcl2blbl3li/PqTpYUgpeMn7nX3r06oG31gUFLH9n0thM8YjcGEgyR2A8ZolBpdzdW2LP5mhuAx8vdECjuza8a9b7AObYjRE9QSjA3R6rs5OYxbxEVjn84solGeoxVbDCjo/yxMiwkMALDQO0p8EhJNBrEBAL7Vs2rceKQMGmTykl+TDSIPSxAIYfMlNkAhnKbJ4xoL9jsoW1XJcW7lA1xfS5paZgF7LbUVkAKNGsik1spr2BL2OzCNUN2lFeLhvRRCfZ6G50zv9NQzt8SL5DB5TpJRsIVj4cyQl9rht62R9W4RnMYweCyL7KPP404p8h86nHEJVF0ncTNs/BA6T2w8sR60xtSsG2R
 I8mqBPlg
 ra9R88aFKIm8gllesnLd6m4+DPO+YcyWAmdRfSFcna3C8yQ/Kf9s2W0I8xBSXLFsGOZRx1H4BmtDWA9mlUW4ubtNgmtZB6kl7tFHU3Iec+1CX1tE0sTvUrNW/rtx4DfnfA8peIHqF1S0uiMHAKHVpJSh6u7p9a2TDOm8Pp1OFNoqUuolqSzo4ReYGQk/ZeeYl8D7mtr/YEbP11taRZ23j+Ds6Oavy/TSlE+Cr1FNcspS5h56MsfE6SZ2iaGxoLRLehIXwcD3m0FlEhH0FoqyCsSwipnbU96FQbxZ5io0cw0CARei1kFcjUQ4wgE5BQhSo2yjbPvaNiqDWAzp3zQzVTpxPfc5vP+B4XHHpqixifJZXkGtaXDp2Zo3gZcMOIHpRb3IW8ghb05urYZzuzYR+kixRv7igQyfB8T//YujZXm+PmI9AyA+5sRp6mU+qMamlSLVMijitoR8irDcWnJRXge+D6/sZj2SklqIHG7muAcCM0RoHNu4JtcjzrqSCrO57Kw7wbFqlxgOaROHNftmjDGc/PRREZepEw1r+ium34Cy+4W1OsiLQmovo1MEKQjA1GKa1KyYPj3VSGDUs3rkVcuAJI9N+crVnDYQwixCufNNeiOGVr6QoXyjkxK0k88u058I79o/CLXK2GYOi3w6E48jedHDYpG3TAopwbyt5F9WrmgPGOTg26K8/esbhPzjwrezMaRYxI9FbTWgJcjsrxCsN2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/8/2026 4:46 PM, Raghavendra K T wrote:
> 
> 
> On 4/8/2026 4:14 PM, Salunke, Hrushikesh wrote:
>> [Some people who received this message don't often get email from 
>> hsalunke@amd.com. Learn why this is important at https://aka.ms/ 
>> LearnAboutSenderIdentification ]
>>
[...]
>>>>   mm/page_alloc.c | 19 +++++++++++++++++--
>>>>   1 file changed, 17 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index b1c5430cad4e..178cbebadd50 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -1224,8 +1224,23 @@ static void kernel_init_pages(struct page 
>>>> *page, int numpages)
>>>>
>>>>        /* s390's use of memset() could override KASAN redzones. */
>>>>        kasan_disable_current();
>>>> -     for (i = 0; i < numpages; i++)
>>>> -             clear_highpage_kasan_tagged(page + i);
>>>> +
>>>> +     if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>>>> +             void *addr = kasan_reset_tag(page_address(page));
>>>> +             unsigned int unit = preempt_model_preemptible() ?
>>>> +                                     numpages : 
>>>> PROCESS_PAGES_NON_PREEMPT_BATCH;
>>>> +             int count;
>>>> +
>>>> +             for (i = 0; i < numpages; i += count) {
>>>> +                     cond_resched();
> 
> Just thinking,
> Considering that for preemptible kernel/preempt_auto preempt_count()
> knows about preemption points to decide where it can preempt,
> 
> and
> 
> for non_preemptible kernel and voluntary kernel it is safe to do
> preemption at PROCESS_PAGES_NON_PREEMPT_BATCH granularity

s/preemption/clear_page/

> do we need cond_resched() here ?
> 
> Let me know if I am missing something.
> 

I do see Andrew also has same thoughts, (to remove cond_resched() and
sorry for being not crisp :))

But please ensure you test with the below configs to ensure there are no
surprises viz., preempt=none,voluntary,full(/auto).

Regards
- Raghu



