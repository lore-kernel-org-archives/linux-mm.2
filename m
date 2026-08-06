Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F84FC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836156B0099; Thu,  6 Aug 2026 13:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D756B009E; Thu,  6 Aug 2026 13:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D57D6B009F; Thu,  6 Aug 2026 13:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43CD76B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:05:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C95E6140141
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:05:26 +0000 (UTC)
X-FDA: 85071470652.18.535AC77
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012022.outbound.protection.outlook.com [52.101.53.22])
	by imf11.hostedemail.com (Postfix) with ESMTP id E7E514000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:05:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ct9q1h0E;
	spf=pass (imf11.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.53.22 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786035924;
	b=nWPK3eNf8RZQak8YXlOORpl5nMrUuTlodiIWg3iF6v1lsPOBK5phHpSEhn7XV2XHqGYpk/
	aRXVe/25Lu+LGhe/pw28OIbT7Nv8Rjj5NynplRloP9jIDfBWHBu56nyp6pjgaR1IGmeQHZ
	mx/h2qvYp00LgLYZ9WO2dlhmvypbz/U=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ct9q1h0E;
	spf=pass (imf11.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.53.22 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786035924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOG3ZEzo6CFQlOfq1a4YQfog3pYcgzbPtGGe8jsw2NU=;
	b=5WQGWYHXEJheAofcwwT0t8BPSgSnCpYD8KFBc9glfaeKIsVKB2Sgi7tTVf6WsV5gSA6WqT
	CQMiJ88YWlmcOpXblZr094Q+QpxXnGFX7AFMvUVWggfyo92hpAD7slTBPxE/wp46sixmxW
	juPGunzO4bhBpPhPhAlwseZ2pC5BiVY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZqdzjNuhbaYjBkODcQ1hguHKzpfuRUZyddNmUXDM1tAbEkakFrODMgP9w1kcer5Kg4ym+b4YGL8HJjTTs2ArFSQeJXcs74gRs0Bw1Q0WWHAtsEWH1QxIhTqT69bN4kOlHiVe9NCW3NflTx5kpbR+FX1YOP1QHh2U8cMzhboP5g1srFTHaEUFJAHXUKtjARMZ1yOLxQbDfPW94wJoDTV5u82iJt4QUn9v/5YJqpqB5ARw0MoQfZseiG4teBYoKduSE9skNMyX+yeXZZ0RK2a6MUVFtsyhMKn/HrsTUcyGyR64Ose7WkO88r+vRpiV8k9sVttokh3Utbkh06ETjnqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOG3ZEzo6CFQlOfq1a4YQfog3pYcgzbPtGGe8jsw2NU=;
 b=dpMXy/AB2Z73l9Ar8stsjo6j4Y2TF8eUDTy2qPiTqVoJUaaCXfW1Ccw0HwJKg7RebMr5nG0thNOp1Z4CwXwLM/Hf35qzeuyheAdWdKiTKlWQmI/MtpO89uEVpNAMkUeT6xDrh6n+J+7XoH1UFOrqeKMRfkmsgK9p9uSn5ouX4US9z3nCO3R2s7317KPE6hNd0HZ5q3Av2vmM4GbExZjsKGpvwE+aWdmbMoCnDzYaNncFKIhm7fjzXN1Vtq3q9Hm/LQKQk7z37qYnzl4F0WLEiAYw/udPtLg2fHE8HjahMWM+vpICM17ozWzl662xypaTqJHv8mx3TGCfgusp9jmxtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOG3ZEzo6CFQlOfq1a4YQfog3pYcgzbPtGGe8jsw2NU=;
 b=ct9q1h0Es0NSl2G5q6nfrl+cAIk5/7zSdnhPWeErcJOIjVnn1DxI8VRdSH6+oSXiUeNV/L6aIwOrX5bVtxtYsgZBsjsQOSr8aV2yaegNVHNxggZHLXuIPANcjZZrLY22rx9dqk5u3axBOh7i3zJeCCFFIPIyo+Iv+HH90KJ7UQ/cV6QD430nUoiU0EumdaGIr6R7TKGhplw+S1ROwMCLl1grcioh5OZLMPTG2VZK92XPviS2ylQpItfasFw7u13tOF9nHy9wahPN/PNuM4KdEAW0UxeQiukmbwiRrI5d9JvWJ/st3q54k9YfrLq49CNMR+NzhSgp+gnwUJt1SrLtUA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 PH0PR12MB999090.namprd12.prod.outlook.com (2603:10b6:510:38c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 17:05:20 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 17:05:19 +0000
Message-ID: <10b07d00-57e5-499b-a136-f2148e870d9b@nvidia.com>
Date: Thu, 6 Aug 2026 10:05:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: AI slop (was Re: [PATCH] mm/huge_memory: let special huge VMAs
 bypass the THP) policy check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org> <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com> <anS6hcgMkEJocbDJ@lucifer>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <anS6hcgMkEJocbDJ@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0183.namprd05.prod.outlook.com
 (2603:10b6:a03:330::8) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|PH0PR12MB999090:EE_
X-MS-Office365-Filtering-Correlation-Id: 251793fe-36c3-40ee-8d74-08def3dce520
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|18002099003|22082099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	a+mdN6poUKb/zRoArnOgNG5jV1ijEETsmm2TU0IJ/nEMJRLQJM/WL/J//M9ihEP6lYMtiGHO3J+Dib2azBrugHBhVMham3qP0XV2l2qxT2QugDsp1HTd9fp7FguRtJ5DQ6XyHNOiUh7ZHwCO8IsYGHgN9U4CZCVdAnCCShHFebrOcxCFbhKy+Q49j2sTde/lUjAWrbLqexkGBE51kASB/3QzYmXo+pYMdT1QSygk2HGRYY6lRzWZxQ/mqaDmgvzkibPfbN3f4Ynlxc8fXLC6mN1k8a1X0abI64NMzEuNrYJJdOfp5x7fm5C+UL5zB0EkV8x0nCjcMdmkyt4+JI/DUfeb+M+9e+cfVxz1ieR+NNPWsESQOpAA/6mVxocESvVI26iWIk7v5A/h0+sEFmfjsVNvrnHvdnOEAEtJXO/cR2tqsfex7OIUTyItGWbVeyBmQ4ChJy6rjHZ4S98VRlb7IPBZlqbgePBmXT/du2DR8aaC55574HFreGZkTSgHb8hQvc0bO/slnCvHXWRanL0Gvb9L0jdha1/kYZbLWEjXAA4YcPxuK27Kcog5RsiwvMQ3s+jZd/yeiy614Og/+sklzljwUG3ESPzkiWL3+oU5lLG8AbUiX0cgIBPWhREZpxoXvIrjsj2fsH/luv1KkeNoOQGnCb6j0ysvLzrT7UZBbnw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTQ3bGUzMUg3YzFuLzlzMEFzSU04TDFnc1lsUitzWGpaYUh6TVBkdTNDMUc4?=
 =?utf-8?B?bzFTbnJLSTNCLzkwVGhsNllGSEFtdTBTZEMxcUlwVUNjcmo2cnFNYlF5Ri9n?=
 =?utf-8?B?eUkrcnZjcGFscDhmVWpxcW9ZVjBtaVdTYVdybExCaWhrbHM5ZStBZWUrTHJS?=
 =?utf-8?B?ZWQ2bGg5TnlETmN0UURHMGREMWR5YlR4b0xSc3lseG8yYkx5dXlyUWthVDk4?=
 =?utf-8?B?amhCSGdRWDZKSEtzb0dUejhPb1dlNlc3cFJNd1kzL2xMeVd0YUYyTmpYdmpk?=
 =?utf-8?B?QkNKQmMzQ002LzkzVk9MZCsxNk9vRGlLeVFta24zVktFMktPUXlpT2YwTkty?=
 =?utf-8?B?clczMmVkUjI1c0JuK1RxRmcxa2NKb1Eyb3lzWHk2ejg4TjBqajllNUkyc3Vu?=
 =?utf-8?B?YTFSZGJrTVNTUEtmNkNzU2VtUW5PQ01RdnNuNWJOSkdpZjRzMUZsVUtDaHhJ?=
 =?utf-8?B?aTMySWlhd2hnZ3ppSjFNdXBGVWt1b0E3WlFVcVdCVVhNb0lHc3hidTZpSFlY?=
 =?utf-8?B?dU1CQzRQb3ZYdklRdGx2eVBFVzB2WEFGS1R3S1k4RXI5YnNQa1V0QVpyV0RX?=
 =?utf-8?B?dys1RWhBYytmRWF1eXJFOU9yNEVEa2VrVmFHN1BTNHMwd1NXUVFDTWZuWFRP?=
 =?utf-8?B?U3dQTytsbHdMaU5ncW5EWHJ0ZTRUOG5Wc21ud3NDMncvRDhqT2d3YVhCdWtH?=
 =?utf-8?B?bUxVNVd2Wnhzd3RiOWlyTXZ3RExhTzNJVWNTaks4V1dOcHgvcjJMV3IrRFli?=
 =?utf-8?B?bXlTSHNrNjFjQkZqTTFiSjVFdVo0M09XN1FITDJ6Z0k4VnVmNWV5dzhHd3g3?=
 =?utf-8?B?elduQ3h4eHdpeW92Yjczb2txdGc3OUI2cW04MDNwV2lOcjRaOUFNMDUwcjFS?=
 =?utf-8?B?NCtBaDJLNktXM1lyV2VGTTMrZDRtREF4eWNOMGZhUVZhQ0xNN1U5MGs0WWJi?=
 =?utf-8?B?cE81eHpHWmRsd2dFSkxrQ0k1Nk5GNTZLRXgwU0puM2lJWVZEYi9IR3UvN2Qy?=
 =?utf-8?B?NWxSVk9rbUNNcHYrWUpOV2tVSVZqY3d4a0VYcHJRRExQWWZkbTAvSDJOcTFh?=
 =?utf-8?B?OGU3NkFTa0ZPWTd6emFISnB1eTE1TFh2N2RoN2NWOTE5OHlkd1RMc3RSZmJz?=
 =?utf-8?B?dFF1TmVmZlhiMmVjRHVXUUJkdm1GaVRqVC95K0xMcGtnS0hmd1NwOEtmS3RC?=
 =?utf-8?B?TjNvbkFWeU96T2ZJYVg5VDRTczBVZStvZHpxd0I0RW0wVTh2SXVuVThHaTUr?=
 =?utf-8?B?eHl1UXVwRy91UHo4blQvM3IwUkY5RTROY2lOdzUya1dnSFpqWDBIMHpZTkhl?=
 =?utf-8?B?enJISHpSWkZIMC9hRDVrZDBRWE5FRDJ3UkdyYWFuUCtHM1BiMjdsMWNlbXBG?=
 =?utf-8?B?aXRqWkc5TFZJVExDN1hPbmJuTWpsRkhBVHRveGd6WnU3ZlZJeE9YNXVOaDBx?=
 =?utf-8?B?VkoveXVQRjJqckxVdHNHcWRyc1BIdHJ2RkE1QVI0dFBPMWlYUDFQZ3RhUVN0?=
 =?utf-8?B?WXNoek5EaDhoNjBjejJNNVB6elBWZzR0OVZHTXg1U2hEWVdCVDRzUDRkS0xi?=
 =?utf-8?B?T2x4YlVvZEdnOGNSdkdpL0U4d0tieUxVZmFnUGNKMG1ReW9SS3pKTURWcWVq?=
 =?utf-8?B?b3FsYXdTN20yejBkL1MxaHh5YmlIN3lwMDMyNEJLZHlJcEhsbTNHTm1EeFIv?=
 =?utf-8?B?eXcxMDBFbjV1RThuWCt6QnRuQ2N1ZEF2QlRjMTM1ZWZDNnY0bjZTdnU0aVha?=
 =?utf-8?B?QXk3d2tZTnNLZDZHbnJwQkl4RE94bHZjMGwxWHBHbkt3c3VvaCtTaldCaDZw?=
 =?utf-8?B?M2pKQ1FDSlR5VFh3ZU9aS2E5d1c3VlEyajM3aTZLSTN0WHR4SHNKWlUvTWVv?=
 =?utf-8?B?ZE9mK2FCM1lKNnFnb1lFempOUnJ4VC9zd2NkTVBzVTdtZmxsN0tETUNIajRh?=
 =?utf-8?B?a01Fa0g5U00rK3Bua1FWcHZHTU1xeVltRlFySTFsRWo2TVdDZFp0dXBWeDJh?=
 =?utf-8?B?MDFiUzBBOEFpMi8xQ1VlLzR1QjVMM0xDMjN5Yk93Nk9iYk5sWmFvSUpQV2J4?=
 =?utf-8?B?clN3UUM5emptNExwMWM4WHplY3JZL2oyamxnK0lJNUc3N2JWQ0VvWERWTWZu?=
 =?utf-8?B?WS90MXBLMGY0SytGQ0xkRmNsbDRVNm5wOTVuWDVzWGJOc2FpZS9pNGpmUDF5?=
 =?utf-8?B?NDRTMG1sNEtrdnFsOHN4Z0U3Nkd5aHorTy9taEF2Uy95UmsvekVPMndBaXRN?=
 =?utf-8?B?T3hvckNUNE9sRHB1VCtoZ1FsZURKa1VmNE5NN3kxVWNVc1EzbytrTjhNS1Vr?=
 =?utf-8?B?eHZQc0pKYVdSdEpPM0wxZS9GVjZDQ3J6SlZ3bUxSMWYydmZlWXhrUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 251793fe-36c3-40ee-8d74-08def3dce520
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 17:05:19.7989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUcn+WspUTgJz2mWsEe7+jRf9rDLMB0r4glE9XsmwsaElA6aJGfWrGdrr3P/oC2BsfoHJZtFxCQHqmfh8SBVgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999090
X-Rspamd-Queue-Id: E7E514000F
X-Stat-Signature: eeq6k1itu7duu8hdc7o6yu4inzi65cnq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786035923-773185
X-HE-Meta: U2FsdGVkX1/y2CqTbD9NDiWjBpBjSG59GxdmE7NIWyfP48LfQO2b7HnFW/GIFm9OQXUEEncWjlVEcdgr7hrBtokYEYTCYbtGa5d3SVl6xehBKYxuvlJzwPIXyKWBRQgHYhx8vMUd80gHFTgbpVaj9YX2dGk5IjtITOGebXIkv6Y/E++ijmJHjx3TgoR0FPwtFhnCTAchyARuQUlBsb8SNDvuJYzfMfUVSneHrKo41eaQ1kjbKOrR1Ks1umGVGXTmD0vLYEp8LylNY6EhGfPHj8Av5MNj47QFi0pDGwcYwUfUpqKX+8WUcl45nU+o9Y+bloBTL9r/gS1waCavJiVj7af5BUr6Jeg535MNVGzrZDbAwzo8jbbIRDsDwSjcVSq1pUv92S6HYWwoUuYa9Q5ce+XTFazVF8ymuf9VWol4AylMyk9NniPLitDD5/7eDF6uwIYeEYKvih62IFpITslZQuNrUvF72M7dTzsCAAtJQv94XtN058OBxzrt6DAzwZIXeYJXylnNHxUQAzMDjIC2TUwQfzRBNPNgitSKq4qzflybP6MfAuGrcIHj1VY9Y/DlS/nifE62BFY8gC8Vxyn4/05by7yVjGfMplafGLrgagVhAO9YWNItludaV5OSkin6qXcT1/jHGOVt/r8wMDTMIY9q4nefTpDeXTJEvziL5HYCny34L2GzyhYZRSUkandECDPy0700d6lc7TaTB9mjUDr3XY0UHbcJQ7bF4Y+80N7ixHGPMnfdlDVRV+lV+wVpZGoefzbG9vsp+fsiFjf8bBtQFKOx0MEhdQ7ntxQyZ2S8fRRz6+SQCzdyn8Vg7SNA5NJFO9dANHZ8t1SuIGOfdsG9lB5kBCBF0fkIr2tMBhJjj6kpoHaHqGFrJM5eP+GM3zWLpUOS1Nk5sAnQs3yz2WzA8SociYXczNhMmq5Vm/e+mAwP0hoeEoha5nPjBAqHyussCTNM2HMaxhyWztC
 1VZVisrK
 MY8FV0LecWsFXBwpFBDMUZKE8y5LVC9zvbW6oLDJbgNXYoJ0PFpVvA+MWUfzjufCRdfmpMnXUzvJjs+4kwBWS+58D3esiZluuMsJMqeW+4/s8CbNgatRrcnng2fAPky14LXU0CgdwdhLcUpMoCdTzlrbDwRz3eFsMjEOn3VuXgmA4eFnUFrX88tyDNBURKGAZwfc7HabmVda4s64UGeXVs1opuHY8hPcB2eEGQk12yZCoKp5o79t53uRpvTpE7DgZ9Lbs8Iws6FIFVEFI7qzBiUqD0Y12cfSQDuXqwmqdd9giB7KDdRSk5Q2PhAp15pr7Isep0OYqj6QFkMsNbX982SErxv0HYkyDesUX9QZqn6tzKELnHH2MMDVXBznsCTBJbkOCCht5m/jrd3q4eKIVzlVb6exIrJhk2G5uxLQSDDl3WY00P7/SuUyswR40a5SZaAD3J7Zq02Pc2b8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 9:50 AM, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 01:45:17PM -0300, Jason Gunthorpe wrote:
>> On Thu, Aug 06, 2026 at 04:47:07PM +0200, David Hildenbrand (Arm) wrote:
>>> Just to be clear: Unchecked AI slop in any form is making my life
>>> worse every day.
>>
>> I think eveyone's life who contributes reguarly to the kernel.. The
>> only ones who seem to benifit are people doing drive by patches!
> 
> And they shouldn't - we should make sure that nobody doing this can
> benefit.
...
>> Yet responsible use of AI seems genuinely helpful and quality improving :\
> 
> Yes and I use it daily. It's really helpful when kept on a short leash...

haha so true. A *very* short leash! :)

> 
> We're going to have to move to a trust model eventually IMO where random
> new people just don't get to apply anything until they build trust with
> smaller changes (and with measures for established people who start
> sloppping).

That sounds like a good move! It really is all about who sends these patches,
and what their stance is toward creating patches.

And furthermore, that's not even a change in policy! Because traditionally,
that's how people started anyway: with small patches and patience. It's
only with AI that they've been able to skip that step, to everyone's
detriment.

There are some patchsets in my inbox that I instinctively just skipped,
because they were huge new patchsets from new AIs (not people, really),
only to watch in dismay as they burned up other people's time in
review attempts.

thanks,
-- 
John Hubbard


