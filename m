Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B121CCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E5228002B; Wed, 17 Sep 2025 15:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09725280028; Wed, 17 Sep 2025 15:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E521E28002B; Wed, 17 Sep 2025 15:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CBB3F280028
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:15:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 914F816067C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:15:37 +0000 (UTC)
X-FDA: 83899696314.16.7BD1476
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020127.outbound.protection.outlook.com [52.101.46.127])
	by imf12.hostedemail.com (Postfix) with ESMTP id 663344000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:15:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=fzm78YDY;
	spf=pass (imf12.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.46.127 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758136534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFaNZzW7eC5f/HUyWFmmBPcD9+4RVNfoR7/P2457JbE=;
	b=deumoF3qnYgO/xgfQ8cASbqHaj+l6sJYgoff4VckG0OKh+ephG31VtWgq7TNqyV9rBiKeg
	6n3cvKqJFHYAoux/Dx+Vr+XhOR8g2jDDGP1TLhrNxUnHAXjQtJC0LKjq4HYAKXiOz7aqQy
	dM0x22I7t6KOAdqmNkj0WUgcbgaaPnU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=fzm78YDY;
	spf=pass (imf12.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.46.127 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758136534; a=rsa-sha256;
	cv=pass;
	b=IK9rQa2cHqRLM3yJ1sd26s7bvQKyo/H0WQpdCtqk0UQG7FzdPi/Pp9vJ16VtXy5sT7jPo3
	97jafV6Rf7FWkESsjLXwBKmY3gua6Jzb1P2X+SxPB5SqWyD5EnG1o/oP6PD6PddKNLk3OP
	8RiZ1jDfSIni5jxhsymyp2NyrB78yrc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGSLxCFl6OQGL3G+L+9DASboImP7xhvrTz2kWsApYG2E+hRuHwuJKWWdnpGV4QfSKZ4KvjWb/hNK6RGtA7eCTH4IATS2EkQFgTyreZDCPgLzkSMCKTVJ+SuAEHdGzImihxrvet8ICkWQmqqxtwPnfcvAoO/hdkzniPditjeMsgk32ex8yfsrhVqAHmNnJgwfWke9jMOAjs2v6AV+Ta+LMtURgJayuN7+iji43E1gSGSFvEaHYLP8oojl9+mNJt6A9XrUqJxTzTgbmmOEPRNspFRDiQVtN3uv1ZGFArCsYyC40x8yEx9gW54RHqMX3HPr6zsnJkVFhr3Iero6ROPuQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFaNZzW7eC5f/HUyWFmmBPcD9+4RVNfoR7/P2457JbE=;
 b=mypE7PDkpO6QlDZwclsBIziQQ1jeF93NQts1MOxzcpxC+0F7avMLyH7p/KKD2GCK7U/A18V2dCGTiOkm0oVUd47QOsAFepdbPysE5EZVOjlAz7q2RfS1w7lWPl4MVOFrmNNX4rBYaUhG80TpSd5CQq2udqGdrnojZY/ujw1BF6aUJ0rIH75qhM1URGHXOnneLWcXE1KuBpEn4wo0181DqWBo37g7ue4QjudngLHHMAdDvdE9q2od3U1FBH0Pey1Mhfzmy0fpF3VCd3ze6wM610UpjDye2EUKTwnnpEBPrejvbXLs9HYDIaKwSqXGk0T6m6UWin4THTWH6AFx7BMh/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFaNZzW7eC5f/HUyWFmmBPcD9+4RVNfoR7/P2457JbE=;
 b=fzm78YDYP8gZhkK7WcSoE+O86pU1TVwz9ux4MYwA4Syli2+/k1IZr7c7Un9IuCY3wxaRQvpSp3Dra9sc94JuzIPMSgQdPJ5Ix/NPnMx7zpeQavmY257lzms7ZeAEI3V6z+qv9b30zrJZKMDD2tKpzlpDbOq7415cz0gynf4SN+o=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 CH0PR01MB6860.prod.exchangelabs.com (2603:10b6:610:101::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.13; Wed, 17 Sep 2025 19:15:31 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 19:15:31 +0000
Message-ID: <45dc2746-153a-482d-954f-11fe1cd8d18e@os.amperecomputing.com>
Date: Wed, 17 Sep 2025 12:15:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
 <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
 <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
 <fe52a1d8-5211-4962-afc8-c3f9caf64119@os.amperecomputing.com>
 <8c363997-7b8d-4b54-b9b0-1a1b6a0e58ed@arm.com>
 <4aa4eedc-550f-4538-a499-504dc925ffc2@os.amperecomputing.com>
 <1cfda234-1339-4d83-bd87-b219fbd72664@arm.com>
 <55a79826-48e3-41c0-8dbd-b6398e7e49a6@os.amperecomputing.com>
 <92719b15-daf8-484f-b0db-72e23ae696ad@os.amperecomputing.com>
 <e86e2aa5-c66c-41a9-a56d-74451df0d105@arm.com>
 <f8898c87-8f49-4ef2-86ae-b60bcf67658c@os.amperecomputing.com>
 <047c0f7b-e46d-4a3f-8bc0-ce007eac36a7@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <047c0f7b-e46d-4a3f-8bc0-ce007eac36a7@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0183.namprd05.prod.outlook.com
 (2603:10b6:a03:330::8) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|CH0PR01MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d6e91fa-778e-4031-8002-08ddf61e91ba
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFRqaG8xeEtmVXNQdlZqUnJ5VVZSeEZmU0JzNXU2OTZ3U2xnc1R2U1pHdUEr?=
 =?utf-8?B?SGEzdnhkdTBLTnhIUm9PVWlpVWxVc1lGcC9RTjF5S2kyQllQMEZhNlRTcjlS?=
 =?utf-8?B?b2Y3NWMzQ0NhTENHNmN6MFlZSC8vNi93dGM0d0cxSytsSVYrbXgzV1dkR3Fs?=
 =?utf-8?B?bjFudlJhZkxaeVFlZ05LeStSZldlVWRDRW03S0w5QUVrSlF6S0laYlh5K3J1?=
 =?utf-8?B?TENzNk8yRk1GalA3dUpMd1h0L1k1WndyMlRVakNsRlJNYXVFR2ZUaFJGZndD?=
 =?utf-8?B?Y1hUOGU0cGNmcWFHUU01N0duYWJ4NGJESCtDTE90LzJpVjR3QXBmeXBTYy84?=
 =?utf-8?B?TGtsbVhTMk5XTmVGNHNmejRXT0xkc0RNTk5rWEpLdTRYeC9oTy9kQ2pYRzdX?=
 =?utf-8?B?V1N1YzYwd08rZ1Q5WTZKa1EvcHNKa0F5RktmcmgxOVE4SWFKa2pHMjhqTmlQ?=
 =?utf-8?B?cUlYbllZUFhMT0RybWJpeHFiYUFyWG5DUUVXQTVoL0JDOXpGVFczaVFUZkp2?=
 =?utf-8?B?Q3k3YnNMekRPTjFrTlk4bUNLN3FubmYrcDd6T3RsK2RYT1UvbHV1NkMrRk9k?=
 =?utf-8?B?UmJPRDl5emcxWWFKc01sNE5kbFE5QVljU0F3NERwOUFZcDNDalB2bnRXQTdN?=
 =?utf-8?B?R3hmN2JWVFJjdjBDZ3Z2YzZjcVpVZXBDVHZpWlg0VWdLUU1obmV6N0xLdC85?=
 =?utf-8?B?eXV4RmVNaDFRekpySjQwejU1dmtaS09iWmVXSktndG1aVFZPbzcrVHhwbmpC?=
 =?utf-8?B?MU5BdVArWVYxbEN5ZTF6d2d4M3NzUDN5L2tEN09na092NkovSVB2SXJNYU5s?=
 =?utf-8?B?ak1DazBwRHdzeW9sVEdleEo5RHJ0L2wrL2J6MmJGdWdGekV2a0J4WmZ0a3FE?=
 =?utf-8?B?bUpVU1F2YUtadUoxVDFUVjlEKzhJc0hLMytWWXpEZG85L2VJVVZPL3BTQUZt?=
 =?utf-8?B?NG5MSXJBdUtrbUd6bEwyc2tHWHBvSEl1YUkrTGFONnp0eWZoSXdZWXppRXBF?=
 =?utf-8?B?YnBONU5ESzNKQlZGakVmTkY0elN5ODZJM3ZXUW01RjFXSUFUOHlCSWMrdS81?=
 =?utf-8?B?TlpYeW1oYU41eFBVYUF5a0JIKzZSakVzdm1qcVcxMWM1RW9MNDJkSXdjdEtm?=
 =?utf-8?B?cllmTnIvcFYreXBqRmVheit3cnB2azlyV1pkQUNFMVZHWUhLUnRLUU90UjNX?=
 =?utf-8?B?MWY0RUd0c29rbjlxMkhhYUI3blA2TnowblcvTlE0Q2NIQ01RSDJocS9LaXlY?=
 =?utf-8?B?KzRVR2VWc2JsY3ExMmJjZlU4MEN1d3VickRRazJGdzR1eGQwYjExbVV0c2VM?=
 =?utf-8?B?TXhCbW9NYkNwWncrOVJtazU5dWRka2x2SkZMcU8wWnJqWlA3TnJPM2U1OHl0?=
 =?utf-8?B?cjhjSDI5L21iMWVXaTBBU2ZjSmpBZDE5cmg5MjlUMFplcVJ5QUF2OGNiTmZz?=
 =?utf-8?B?OVFPRHhpcVN0ZzEzWlhEbUtsNmNjaHlSOENqajg1ZytScElhMlRWL1hLRGxY?=
 =?utf-8?B?QTNvZm8zd3prOXh3Q0pNbUZNVnZVbVlGSkhWUUxkYXRNaldQdUZCb0lUdThu?=
 =?utf-8?B?cHV2VW5jbUU1anovTWtHNkR4MVZIbmNUczRrOE1pTXlBRGF1dXJ5SUxXNndZ?=
 =?utf-8?B?ZjFRb1UvSFEzMjRKamhoaXdGTGRsU2xFNWFPTHVVN3g0NnQrVVZiTUJPanZ3?=
 =?utf-8?B?c0x4eEFZRlpSUlZ6cWdhazI3WStndCtHLzJuaGRvbWMvdXNIN2hQYjNMRXlM?=
 =?utf-8?B?UVRRQmhEZkhta2lGbjFibTVNb0pRdkxDdnZmSFVkNmZXbmx2V21FWXJmS3Yw?=
 =?utf-8?B?UHZGb29VZEl2eldzNU9hbHl1WmpJaUgxOFdkTkUvU0JLZHd2eDgvMnNsYzZK?=
 =?utf-8?B?THpsUllYWGFMbHdldHdieVNPUDR6Q1MrbjJjblEydk51Rk5RTmZIN1hPNVE4?=
 =?utf-8?Q?Q63l7cds+G8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUlxaXVQWVQ5dTJ0R0J6UGlGT0xWUU1pYkI1aWpEYkdNa1d4KzRTRm0wdytB?=
 =?utf-8?B?NkdHWUF2dmJyckNLc3RjM2c0TG00U0UyM2JBMyt4TWVCOWIvWG9pS1ZEUlA0?=
 =?utf-8?B?eld5Qy9vY2d0NnFuKzd0MVEyVEJyRTBkMGxJM1prUjdaWndXQkYzZklBV3Zm?=
 =?utf-8?B?N2pyd1J3MUlBeTRqUGtWdE1kdWR2QVZOS2RBMFgwckpTVXp2UFgyNjZuQTNx?=
 =?utf-8?B?S09mRmppTW4zVzRrQWtTMEVORmFZa3RJUnJQaSs0anQ3SUZMMTh0SXpHSG85?=
 =?utf-8?B?T3BFRERleTZBbHdBYkJqaWp0LzUwS1R4QlRMYTBrRHpPSmhXQkFuTkR4c1Zk?=
 =?utf-8?B?ZlRseGRDS095elNUUmhLbGo2c2JRNVFndWpvSFVoZmluUkhZK0F6ZnJvbFpZ?=
 =?utf-8?B?THJET1ErYzRLdHNzYzB5b2hEQ1JPOC95YzF4c05UNTJ4V0YyV0JpcXo1aUhO?=
 =?utf-8?B?OVlybTQ2WVN1NkxPZ3ZtVktuZmEzZDlGUGlXVWp0MEVGVkpFWGZsaXVGNGM4?=
 =?utf-8?B?dm1NSysxaFd4S3YrNEltbEVzZTR6eURCMkFiODdPbjROUnpldWFzQW1qdndz?=
 =?utf-8?B?K3NkSGx4RllkYkdTNXdvNzJSWnVZTmYxYnZ1Ly84bnBCWGlXSm9PVGpQbDJu?=
 =?utf-8?B?WUYxMy91ODVjWXZramdlaFNuR0xvNzZBMzJEZVpHdHR1My9SL2ZPM25SWm1t?=
 =?utf-8?B?S1VUdDgrZXk1Z1hyaDZOekNxYU9HRkVZU2wyMDVQOVl1akhVYmtORGxYdUZp?=
 =?utf-8?B?b0tLdldoSHUrVVlIbXFDL1lLeXpVamhGWVN3ajFBTCtDb2Z5aEs1TG5kTWll?=
 =?utf-8?B?a0Y2ekRJRXRPcDYraXNjRFNCZTFjdm1reUFoR2F2ck5QOC85OE5RRWdJREN4?=
 =?utf-8?B?VGF0Y1E0ZS9MRVZ3Sm9ON0d6Ym9VaTlCRlpDZ3VJWWlqa3ZVdkN2WWNUeHpY?=
 =?utf-8?B?WnFXcjlaZ3gxZW5NbTFieTE2U2NCWkpqYXdneCszQjBEMk1tQU0zNW5CRTd2?=
 =?utf-8?B?SWlBbHZzdkIyZC85djRNYzhaZjEyNS9Yb05NaTkyWWNISEVteUdFY2dCaTZS?=
 =?utf-8?B?Sm9DWDlmZXNUN0FraHMranhwTm5Eb3dwMVEvbEp1YXhVVG03Sm1MWVYyMGMv?=
 =?utf-8?B?U1JvdEVkcGNYMWtmbjdyUG5KdE5wdTlsUXhLblNVTnJkdFk1dlp1SnlZVU5x?=
 =?utf-8?B?S2xFODhIODFOT2FuY3dacW5jdWNpWFBScjJqMThwUmd2MFhkMmxreFJWR2Nr?=
 =?utf-8?B?V2lxbEg3MUxxWjIvUTU4WjFjTFlHc2lhU2c3bHg4bDFpY3llQ2xPeE1EOFZv?=
 =?utf-8?B?TkRmK096TTJDTWZ4a0FzUi9zV0JiRlFiRUV3Wkg2cVZPRUZoYzZsc2FzOEtz?=
 =?utf-8?B?bHNHcEpPQVR4Zysrakp1aUtibzY5MzlBd1l3VStEbDlQT1ByejBpVm0veTgx?=
 =?utf-8?B?RFVkTEg3OVFXdkF6b21vT1JXYlhJUDdnamliek8vK085bXVEc0w5WUNEemJi?=
 =?utf-8?B?d2R6eEhORkwxeDJzYzd5NmllS051UDk2b3grQ2xjMTFpeGY1L2kxbHMrMWd1?=
 =?utf-8?B?UDMva0E5eTd4L0xyNUFPMTUrdmdMcXhBc2RXd3pRcFlEZHNseThxYzBEZU5a?=
 =?utf-8?B?RTEyd2ZWYVhmYkltQWVYV2tWSzl4WXloYkVWVHpQYmVKTnNKUmJzSXVzQi92?=
 =?utf-8?B?alpHNkR4M2hEbjh4bi9yb043VDNTenlmck9VVmdiTDZBNE50NmtqdDJnb3V4?=
 =?utf-8?B?Y2ZYMk1XaFpNWTVHUk92bFYwcExycE0xRlAzVHRxeUQ5UHozM0RPMDBPNlk5?=
 =?utf-8?B?OGdtTkFwOVpLSGVrRG1qNHY5S3M1Vjcyc2FiTCt3ZUlrTmkrUWxUQzBkY2g3?=
 =?utf-8?B?TGtOOUwzZDdHWVJYRy9ReUFxdEJKUSswTFRsYk1LWXhPZlByaHZ2RDVsYldD?=
 =?utf-8?B?OEpoQnY0N0U4Y1kzTlJDNXluakZoSkgvQjVPMHVWVWpMR0xJUEJBUnJSb2VZ?=
 =?utf-8?B?a0xyZ3pKZVhYeVV5eWJJVjFqak5GN2l1bzVrcXNqdGJJdkN2aTJzclJzU3Zi?=
 =?utf-8?B?bzdBa1hVME5oZ1B5azUvaXVBNEtvSEs4SHFxeE9WRVlUc2d4WVdHU1BKUnVx?=
 =?utf-8?B?Z2RNSmJpT0ppZXF3OUhMTFlHdHA0TVZ6d2JISjJEdFRZNU1TSmJCTlF4QWVy?=
 =?utf-8?Q?2dkRwzUMScwo7V94nc+f1AU=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6e91fa-778e-4031-8002-08ddf61e91ba
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 19:15:31.2212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1laL6rIbUvSKopgqxVACf9xncag1Kz6T29iT8al9VWFVgCT0H2wK3+VMAGr7+h9KakaArD2+xThYua0BRQPgP3GljTv3GRargX8NqTS+9BU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6860
X-Stat-Signature: sa83cj1nxu9pfw9t5gsw1i5tzg3xd5b8
X-Rspam-User: 
X-Rspamd-Queue-Id: 663344000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758136534-379802
X-HE-Meta: U2FsdGVkX1/F8btiEana1DawTeXzrDYi+Q1Dv8CmPDkjtal+Uke2F3pv0gYOyfU9yeQdHv8MnZ6+ARPzmZpVhT35RqDbClPPHGN7AyNYreqIxeKC0MPHofni6V/h7jnjIIv0AAa6weuSBqT2+URJolv+z2DtBQhRqXUNX0YI5fXqKN1fhPop+ljbMP0nLJCIPnzSalHu71SFD6sAjGSdjgs3BAkZlNeU/1tE6/n3NGNY79U0eofNVDm6ac5ub5ug5rbVFckmaYH7nBeOwkRwKDctoCx2NIE2amCeMlcXDX/bvFFacAfM3JUFbgjGOirRU5uz94DcnOkw0Us5JMxDwrF/Pcwuo8F6MNBrGN49oPwFA/VU5SehLMTHUPNtADdOxHo72QBxJNSRiNKErSIH6gek1ZVMcnH/S1SITv1mEDqBYrsQPNASyPxOXYWzNDZ+dKHGIRW60xU1jcBI9IWX7di2PZvqZm+yRZEUISOdfdJT4A3W/WStumQZnVnsLC7oGKxBcqSe8rCOLWAGS/Sqbdi5rqug+oQ4LnwVejg8Xb3btaZGSTz7Z8pfq8RImPwS+XPM7GNzboiOi3mR7BYw1AZkvp+l2XXoUwDeECsJjhDoA/lvRZz/IHXJhsmtnRfKJFrLa7gnp/rXkidyIClZ1n95wdJhkKQ4BW54Cn/Y5XqsmydOW5tyZdFa5qTO0p5i/OHc1Y+MHBGvKBZpqvCjbphZcjnCBWe0X+BAVzIHJeGHmOKkt2w+rwvQf378TUpuSzP8BTxEToubOFxP57rMS/KjK+1qYVZusBqR0zrBKd2vY2gF2plJ0lMd7agUr1fxOfEQ0LXvyvjTgpbkMqATSGh40WD5JnHE3/mgcQ23dNB1qo//cLUlGXVJPLI+vfjyJTPu9x8tU9l7IdFygXQDGw/n/Z4s6dkArzEFLFc8nnNppKf4LxY9oicHAtsX7tFfuGjNQZDi0pytAo4AfII
 sTqQ3Nj6
 UirTOaLy/egnYkAH4ol1sMROo5gznLbceIf0yhfH2TdQkrvasGgepR+fz6GCGudxG3txfSUwNWsvxJljyT5XyUT4cSRqWBgbP3u5dbjcnWAjrOWYUZD+s4jCPMZVrD5IJB0xesulX0l/H097cKJ2CJFuht/nxyaHv/nNGka72jsR2Y/9QTsXhaXoWHzN5spD8f0NY9tKMQW+37Ug/4Ci7Uh4DQ38gR4jcpenUDPhlVTYRnTsvzGgasfq7JdgvxeE3S4OpAXQ5jQvZnEha1ztLRywiS1fR594EPQNYyW0/omkNxhMO1rlZFQHwlX3+yHRcr2mcUQYnv2QzggpchDKrSfogsDrL1X+F5irYRfheBKYYs8YcuMozGsHalKyRS4sfqEdoP3Cy/FogITIsFS96ZSXAoYCRdznUYsEkaVwr+40quQZdSQQjxga1kjPPNw8uwWWebZTjnAJW9iPJgF7C8FzWRT5hhF3UGSWE+pMoWijxMCyQa/4KC3TCbOl8eDEoOW1F//rgxOql5NkLIcIRLm7crMuOiPKjiXIR7lD1RByXEoHq82nvosdH7V14iKCi3UClj2cFkGBf8R+/DScgE2haKNnVQNGnjfOHH/aq31fs5jwazq/QOh0GAMsjQ5SoUcqczdv2OnQSmcTA2Dba+0WhuAdJuxOszl+N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/25 11:58 AM, Ryan Roberts wrote:
> On 17/09/2025 18:21, Yang Shi wrote:
>>
>> On 9/17/25 9:28 AM, Ryan Roberts wrote:
>>> Hi Yang,
>>>
>>> Sorry for the slow reply; I'm just getting back to this...
>>>
>>> On 11/09/2025 23:03, Yang Shi wrote:
>>>> Hi Ryan & Catalin,
>>>>
>>>> Any more concerns about this?
>>> I've been trying to convince myself that your assertion that all users that set
>>> the VM_FLUSH_RESET_PERMS also call set_memory_*() for the entire range that was
>>> returned my vmalloc. I agree that if that is the contract and everyone is
>>> following it, then there is no problem here.
>>>
>>> But I haven't been able to convince myself...
>>>
>>> Some examples (these might intersect with examples you previously raised):
>>>
>>> 1. bpf_dispatcher_change_prog() -> bpf_jit_alloc_exec() -> execmem_alloc() ->
>>> sets VM_FLUSH_RESET_PERMS. But I don't see it calling set_memory_*() for
>>> rw_image.
>> Yes, it doesn't call set_memory_*(). I spotted this in the earlier email. But it
>> is actually RW, so it should be ok to miss the call. The later
>> set_direct_map_invalid call in vfree() may fail, but set_direct_map_default call
>> will set RW permission back. But I think it doesn't have to use execmem_alloc(),
>> the plain vmalloc() should be good enough.
>>
>>> 2. module_memory_alloc() -> execmem_alloc_rw() -> execmem_alloc() -> sets
>>> VM_FLUSH_RESET_PERMS (note that execmem_force_rw() is nop for arm64).
>>> set_memory_*() is not called until much later on in module_set_memory(). Another
>>> error in the meantime could cause the memory to be vfreed before that point.
>> IIUC, execmem_alloc_rw() is used to allocate memory for modules' text section
>> and data section. The code will set mod->mem[type].is_rox according to the type
>> of the section. It is true for text, false for data. Then set_memory_rox() will
>> be called later if it is true *after* insns are copied to the memory. So it is
>> still RW before that point.
>>
>>> 3. When set_vm_flush_reset_perms() is set for the range, it is called before
>>> set_memory_*() which might then fail to split prior to vfree.
>> Yes, all call sites check the return value and bail out if set_memory_*() failed
>> if I don't miss anything.
>>
>>> But I guess as long as set_memory_*() is never successfully called for a
>>> *sub-range* of the vmalloc'ed region, then for all of the above issues, the
>>> memory must still be RW at vfree-time, so this issue should be benign... I think?
>> Yes, it is true.
> So to summarise, all freshly vmalloc'ed memory starts as RW. set_memory_*() may
> only be called if VM_FLUSH_RESET_PERMS has already been set. If set_memory_*()
> is called at all, the first call MUST be for the whole range.

Whether the default permission is RW or not depends on the type passed 
in by execmem_alloc(). It is defined by execmem_info in 
arch/arm64/mm/init.c. For ARM64, module and BPF have PAGE_KERNEL 
permission (RW) by default, but kprobes is PAGE_KERNEL_ROX (ROX).

> If those requirements are all met, then if VM_FLUSH_RESET_PERMS was set but
> set_memory_*() was never called, the worst that can happen is for both the
> set_direct_map_invalid() and set_direct_map_default() calls to fail due to not
> enough memory. But that is safe because the memory was always RW. If
> set_memory_*() was called for the whole range and failed, it's the same as if it
> was never called. If it was called for the whole range and succeeded, then the
> split must have happened already and set_direct_map_invalid() and
> set_direct_map_default() will therefore definitely succeed.
>
> The only way this could be a problem is if someone vmallocs a range then
> performs a set_memory_*() on a sub-region without having first done it for the
> whole region. But we have not found any evidence that there are any users that
> do that.

Yes, exactly.

>
> In fact, by that logic, I think alloc_insn_page() must also be safe; it only
> allocates 1 page, so if set_memory_*() is subsequently called for it, it must by
> definition be covering the whole allocation; 1 page is the smallest amount that
> can be protected.

Yes, but kprobes default permission is ROX.

>
> So I agree we are safe.
>
>
>>> In summary this all looks horribly fragile. But I *think* it works. It would be
>>> good to clean it all up and have some clearly documented rules regardless. But I
>>> think that could be a follow up series.
>> Yeah, absolutely agreed.
>>
>>>> Shall we move forward with v8?
>>> Yes; Do you wnat me to post that or would you prefer to do it? I'm happy to do
>>> it; there are a few other tidy ups in pageattr.c I want to make which I spotted.
>> I actually just had v8 ready in my tree. I removed pageattr_pgd_entry and
>> pageattr_pud_entry in pageattr.c and fixed pmd_leaf/pud_leaf as you suggested.
>> Is it the cleanup you are supposed to do?
> I was also going to fix up the comment in change_memory_common() which is now stale.

Oops, I missed that in my v8. Please just comment for v8, I can fix it 
up later.

Thanks,
Yang


>
>> And I also rebased it on top of
>> Shijie's series (https://git.kernel.org/pub/scm/linux/kernel/git/arm64/
>> linux.git/commit/?id=bfbbb0d3215f) which has been picked up by Will.
>>
>>>> We can include the
>>>> fix to kprobes in v8 or I can send it separately, either is fine to me.
>>> Post it on list, and I'll also incorporate into the series.
>> I can include it in v8 series.
>>
>>>> Hopefully we can make v6.18.
>>> It's probably getting a bit late now. Anyway, I'll aim to get v8 out tomorrow or
>>> Friday and we will see what Will thinks.
>> Thank you. I can post v8 today.
> OK great - I'll leave it all to you then - thanks!
>
>> Thanks,
>> Yang
>>
>>> Thanks,
>>> Ryan
>>>
>>>> Thanks,
>>>> Yang
>>>>


