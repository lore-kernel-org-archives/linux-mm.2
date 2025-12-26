Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DDDAE8FDA0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 09:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386506B0088; Fri, 26 Dec 2025 04:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A456B0089; Fri, 26 Dec 2025 04:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2766B008A; Fri, 26 Dec 2025 04:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 041966B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 04:24:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 609F31A0F51
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 09:24:30 +0000 (UTC)
X-FDA: 84261086700.13.EB186D7
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8504A140003
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 09:24:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=K4FHXKjF;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf26.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 52.101.48.15 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766741067; a=rsa-sha256;
	cv=pass;
	b=n4R41umIKlZHbM78+0YQIQNpjwAJrM6weW9W/tPHK3fB+QRDIYzeVS8aOBCbbRASQCNpdg
	BFYeF/yLCMY2KlZ7FRdkwV77UuDCrNIRCEmvDe1ZxeAyEnDUWxrzK11JE1JAqvOo8C+TGp
	HrPalg/QpiTR3SrNvXLxi4z+nM8Lfg0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=K4FHXKjF;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf26.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 52.101.48.15 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766741067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bs9VyY92XOgzmYaqInT0jPySZhv5hGrCh5G0XkIJ00Q=;
	b=GTg+Fw+0XbMOK+dBffPu1OTWC6Xw3EY9Ec5li9MxiVwaaXwAPG6qVpWoGdur8QaPJptpv3
	S+bv6o33boXXt2amdUvWTbNS8DzOMuSAfi/0sBiqlSLtj+iNH8BovzUGLmPUyrGcXnn1Y9
	LH64KYl1ObOTEjPEErJ3mG81LZVJX9I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dOxWzxhXErnNkVKXcARg/lwUvcNtO7vhOcUwdSCXJWbOiT1B5Nb6o8WRGYsrcbaypwse7oRt03+NWqb0saFV7No2Oixp0Nx03rEMjTgwV81cpTJHd9ZoL1jAD+HonNArQVoPQM+3iFP13Iu58AUAs23bM3RBH5XIp2B3zZwQcwd+bfI5Z/jMb5yWryVGcjvTmL6cfe0in7tnkulr+BFB4m5IpOcQR8DLoVHBTSo0eVwmYvqymlLRStHtqBa0H8aAGKhYF3VJQ5z7WumE7nA3IvcK1a1JOSk+CoNpjPl8xKZk09+wH4xIGEXNAJC8JnfEkPAyFF4reh7vB5mvOAWxtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs9VyY92XOgzmYaqInT0jPySZhv5hGrCh5G0XkIJ00Q=;
 b=FJCzwyfAO6vBACj4F9KYrj0l/lgHeKN412tUEuO/9fXggaD1GpsWo75WKh5MOMPzOiHiAKWeaSrZz0iVQzAO8gztBTrONktVdB7deQPjb3yfD0Y+UKEc+Tfx9meLMNiPkP1k/cfzXc65s8YuSu7mMocUrmCwxkz360Lh/uH50LsAvXS0QSI8pQ2FkxtpbWfCA8phqyxB06IYFOm8+nMlpEkE4ifzIIiQcjGOBQxfJTB4SOXUVGkJWUX3piXaEYXamW82uT6ixzfdKy+llzdHe3wXZizFYZujZq4IBtruxgV4e4qdyy2+75akAy8sYRC1/mHhPqci1s6pUGpbG28M9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bs9VyY92XOgzmYaqInT0jPySZhv5hGrCh5G0XkIJ00Q=;
 b=K4FHXKjFaohmPU80SNHODw7zeQAPrpt5BYMJGK/BU7vQQU5G82UF8YITcCRxv38oEHkmacfREAlpcLmrRtTLlYx06M4NJc+klFX5sInQbTAm94G59rXadasEqS9FtkykAtqc6Wq+eCRlUPvZxVMsP2aMPuM167Vkh4Q1PW3tK0c=
Received: from PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13)
 by DM4PR12MB6326.namprd12.prod.outlook.com (2603:10b6:8:a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Fri, 26 Dec
 2025 09:24:24 +0000
Received: from PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1]) by PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1%4]) with mapi id 15.20.9434.009; Fri, 26 Dec 2025
 09:24:24 +0000
Message-ID: <46bf07b6-633f-43b8-8e2b-b08d437494b9@amd.com>
Date: Fri, 26 Dec 2025 14:54:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/hugetlb: add pre-zeroed framework
To: =?UTF-8?B?5p2O5ZaG?= <lizhe.67@bytedance.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 fvdl@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
 <20251225082059.1632-2-lizhe.67@bytedance.com>
Content-Language: en-US
From: Raghavendra K T <raghavendra.kt@amd.com>
In-Reply-To: <20251225082059.1632-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2P287CA0008.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::13) To PH7PR12MB5805.namprd12.prod.outlook.com
 (2603:10b6:510:1d1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5805:EE_|DM4PR12MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: f9785d30-78cb-4e13-23a6-08de44608ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0djMWJ6NXhxSEVKYUtzcis2MHA4MWJZSWswMmNHRDVTL1RGM2xPRW54RnFk?=
 =?utf-8?B?TGhpbituaUI2d0dJT2JMbUFES1NWKzE1T3VtV2FxY1dZSEFHOTZoSGkxcGVp?=
 =?utf-8?B?aWI4aGM0bWxmQ3R3QjYvRzZLWEdLVDFldkFwMEVzbjN1UEJPMUk0aVQ1SkNO?=
 =?utf-8?B?aFJOcVJBZlEwd1k1b1JoQXU4MlpXTkoveGZuSy90eG1qY09sajJEK2FkWnA3?=
 =?utf-8?B?OUMrVWpCZUVIbzJVbU1ObFRIaGgwWHJrdHcvYzhYNFRRSDkwVTFUZm40ZGEz?=
 =?utf-8?B?M2NUVE5KcWRuU1VIeG1xTjdoQ0FBTW5iZEp3NU40bTRRVU1UT0dqM0VKei9o?=
 =?utf-8?B?SWhwYjhOWUxQZTR6czYweFFza0pxOFFIZjZCa0ZOSWNYNGIrM0ZIQVl1UHRP?=
 =?utf-8?B?MDBSclFadTR1ZmVYQ1FLeXc2b1V0bTMwL0tVSGhpVWdlTldGS1hteTRTakxm?=
 =?utf-8?B?TTFJOG1MQkR1WlNTUmxKWmpIYmR5dTdsenhOaTdSV1RQSEZSQ0dlckVtNE1R?=
 =?utf-8?B?OTl3Q2JHN0FRWGZsdCtUeG5KNjBsUmhzS0ZjTXhOV0JXWTkvaTdNNFVxejY5?=
 =?utf-8?B?bFZUTGxzU2V1SjRIY1VwaWNZOWhZRlV0M2VybUp0T1hGSjh1Tk5FMWdYd29B?=
 =?utf-8?B?QmtJQkcvTUcrRFhERi9nQy9uN1VZMU1vY3piYVJSRW5aQzhXTlBzQnVxOGNq?=
 =?utf-8?B?dXNtTXNUU09VeFp5RjM0ZmVvNmVYd0tSYi9nd1NDSVk0ekRUYjlwUGJtaFBG?=
 =?utf-8?B?UlhoVWhPRFd5eGJJbjh5YStsY1YzT2NqRjI3NFJPL3BqZDhHTHpIM21jbFJW?=
 =?utf-8?B?RE1MTS9MdTkySDBoRkFHOTdLb253NjRnckVhaHRDZUhUNXJreXA3Ly8rVGZB?=
 =?utf-8?B?WmhiSlJwUnl0anVlWFFwWnJ3SkJVOGJRemR6aUc0Mzl6ZnY5MWVwU1ZnVlV3?=
 =?utf-8?B?RnJ2b3BMM2ljUUU1V1JIRlpGbGVCdUlPN1VvVnBGNWRBUGdjVXMwQU9lelRM?=
 =?utf-8?B?UkNBQWhFaXk3SzZob0Vaa1J3S3daeklrTithSUYwcS9RZzZsVG43dEYzQjZL?=
 =?utf-8?B?MWo2T29wRlFYQXZuZE5kSWhQUnQ4NnZtSk11NVpzOE51YklzVFdBcTBtdVNO?=
 =?utf-8?B?VDBpQWxoeEFHb3JJbGszejNtUVhSZHF0cGs0cFFzcWFYUGVUdnNpbmUyS0ZF?=
 =?utf-8?B?WSswbitsMnFRYjhma3JiL1c0ZmlCNEl1eTVTcXRDLzlMbUNXcUUwYWRYQlBR?=
 =?utf-8?B?eklLWm56YjhKS2FxeTlKelFVdUJUcFV3MVFGNzRpbVA5L0w4WllqZHgrY05U?=
 =?utf-8?B?bmZFZHpickhFeGtkTTIzRmlYb1FJL3NVVmdSWGNBbXJkR0pvb29nSE81V3hm?=
 =?utf-8?B?VURmN0hsUk45bFJ4RTlGTTVQS2tINW9TcFQrbVJXYXZlcmZPQXFQUFhaUUZ2?=
 =?utf-8?B?WG1VWTdkSldBUzZHOE9FSFdIYXA4eWNIZC95N0ZQOFZqSGc2RS9JTVJmc21k?=
 =?utf-8?B?Vy9TQTRkaFJTMUVENnNpMkI0bTV4SytuZ0oxN29KTkhZbmR3RTkzdnZnSzVx?=
 =?utf-8?B?cGVxRytEeVhxMUpoS2pmVFlEcWdsaWgxVGFQSW5RSk1MeGZ5U1FyWUUvTjl6?=
 =?utf-8?B?empDVFFNelAvMW1KVGw4SDVQbVZIa1doMmlSNkJNMDE0NG91VHUvRlphekNJ?=
 =?utf-8?B?T3BqZnRQVDg3ZWxRamNNeGpLaVVqaXVXUGd2VVhUM2puaFhSZ0R2ZVBDejlR?=
 =?utf-8?B?eHRiazlGc3l1bk0zL1NYbURiUkNpNGlDeGRxT0I1a1VVaUJSNSs2Y0xGOU1J?=
 =?utf-8?B?WkVNSnhFTWV6TU1HN2RxQTJpSGtScDhLQUkvSjl2L0lGWFhHS0ZKc1VQRWNY?=
 =?utf-8?B?STFSY2FrL3hkMTBRalNmT2RnSXBFcnFyMmZiT3RpTUxNaTZnQXNKL2pWOGhZ?=
 =?utf-8?Q?FephLL7/hnIbg7iR2XBuOH0cvsrR25Vh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5805.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3daK0xwemFTVklzbjhJQkVoNmgxTFpEcDRXRTZXdUFzUm13ZjFFTUl6ejhw?=
 =?utf-8?B?eUJmNkFrZVJqb2YvanEyaXlkaDl6aDlqQXAxbm1wVnNCVU9sdWZmVTZyMzNQ?=
 =?utf-8?B?b2NEK01meWhPSXdWa09zbUZKb1hlbk1yWkFSZlhTRm9hN3VsRzhWZVpxbFhD?=
 =?utf-8?B?R2xML2JubkZtMDgwZk5WcWRpbnRNOWhnZ1dpYVlhdjdJNzBBWmc5QkVrSFV6?=
 =?utf-8?B?dHlGZWNteTJpYlo1aDc2N2tQMnhPK3lLOGpHZThqUDdxM0Z1a1Zjb2UzeTNx?=
 =?utf-8?B?a1pmZnhSeWtybHJFZ1g3Qk1tcktLUzdrQnk3NUx0R1hNZ1NGMlZmVVcyanZP?=
 =?utf-8?B?cHZ5TlAybXd5ZTRML2FXeHprZXJFVXZudlRKT0E5VS9jVSt0MlhmUXhjclJz?=
 =?utf-8?B?N2x1dFBQU01CYVZMS1VJSTFTZGtYQzV1LzRneVRpWTJqcmMrYkczWkxXTWh4?=
 =?utf-8?B?QngyUkxNRFJBdVNsZTRXVlJ0eml0VGVNejByNHJESk9HektSKzFvaFV3cWhr?=
 =?utf-8?B?aWk2MmZPN0Q1QzRacWZGVGU0MkVWb3N2YkpyYW5URTFrWHBaMCtuUldaR1I1?=
 =?utf-8?B?NjFGWjdJM0FlNlNvTVNFZURPVlJUSGlCb3pNOWQwcnNNZ2VsV0hHZm9qTHVn?=
 =?utf-8?B?dzBCcm9IT280T0ZXMEdjbzc5WURlcUYwcjFyeHpaZndSdVBiSUhIV2hrQWJZ?=
 =?utf-8?B?NUpyaEcxKy9OT2IzVmdBcnJsdmF1TFdmYVE1K05KZGwwY09RZ2doOFI0eDNo?=
 =?utf-8?B?NWFnNmhhUXZ3S0V4SlZHVE50MTY5MVVyM1lrVS9JaEVma1BGQ3RQS01hMGVT?=
 =?utf-8?B?K0xEdnVMeW5RcUlWYWxwaitzdmlnb2gzZFVEYWU3TXdNMnRPbXloQ3Vob2lj?=
 =?utf-8?B?Sk9WUDRxSFUxODRwWUthUWlqaU1QR2VQTUd1WHArU3dEdWt3Q2xmdEZTeDl0?=
 =?utf-8?B?Kzd5UlhtQ1BGZldlWHJnM1J6WFgwNmh6VFBvaGh5Z2JJbkNPdEdGaldJV2xL?=
 =?utf-8?B?TFpRWWVLbVA1cE1TaTNCR1NpSTE5YThZd3A0aUt4RmEzaTlRSXZsbE4wVGt0?=
 =?utf-8?B?dHgxaWJVVHJNd2lOcFkralBQUHRyaUhyNUtYQTRsWDVFQVU5MnFLTUx0MW5B?=
 =?utf-8?B?WVc1YmE5M3haVHgvR3YzWU0wYWJmRFdSTTRLcHpJNVlqWjJRSjdIY3VsTk80?=
 =?utf-8?B?UjBCbkI4dTVRQmMwOGRhZW1MTmhvVnhac2RpTkg1UlNBYVZRdk00TDc2QnJq?=
 =?utf-8?B?VHJKSkNpREFWeUtHUFQ1QmhDOWxkc3plcXE3WEhQc3hZMEI4OHhFTUtzMlk1?=
 =?utf-8?B?c3lzKzNuLzRDbitjcmNDcXA5ZVNRNzVZc0RLTVJpTFo4eTJneVZndDVDaTcz?=
 =?utf-8?B?cjhLeG5rWWUzUWF1ZStBOWJuS1FkbmdiejRlWTJ3UHNseDMrOG5mZXhZbDND?=
 =?utf-8?B?SWhmcUJVRE5BOGVKQitlc2pmTGlrSExubmRJVmc1SzJCN2c4T242QkRacXVh?=
 =?utf-8?B?MG5xTDVidVoySnhQSXRFZlJ2YkMxRTFZTDhEcmljdWp3TkRoNzFjN2NhbkQ2?=
 =?utf-8?B?WitieisyODFJd3dWVHZSWlJGU2xFL0FLT1lxMDhyNXNXTHZCb01iU1lrNDli?=
 =?utf-8?B?WUJJeVlkU2tjU1piOWZLMW1XcG9BN3BRQTZMOVdaN0JVVWlySUYwSGVYSi8v?=
 =?utf-8?B?MWYrYXJJUzFhdTRieXAwR3BhcEFDSEp2QXgzTWFDTTE3dG54YUVVRjRKRlli?=
 =?utf-8?B?cWVLNzhwc0JGSld0bHJrUlRVcWRyQTBSQXBsc2JGa3FyeXRPUzM1V3BsekNB?=
 =?utf-8?B?bDdkeElqeWpkMENUYzUvMlFhUE01MGpTci9YNEVrNU5QR2M0M3ZsUjBZckQz?=
 =?utf-8?B?RGYrTzdHdis1MXUzV09DYVJGM2xMeTBPQ1pDK0ZBQ3FPMlc4dERvL0x4SkZh?=
 =?utf-8?B?emVPNFEwVGR5QzF6a1RweVFBTTRSUDBieHVtYThkOW11NkduNmdKZ3hTbjVw?=
 =?utf-8?B?cDFQRFQyWklFTzFIeXJSUzdObGJXRkcvYUUyeGhnUWtYUjVCdnRrcWZ4TFlv?=
 =?utf-8?B?cGU0T05CNHBMYm9xVXZlNTdlVlhNYkhVVTFETDZFM2Znc3BlcGhkajhiVEJV?=
 =?utf-8?B?OExNdnBIcVNVaFl2NncrQVZGbHVTbThrVnRMaEptOVYwN1hOWEJlcG45dExR?=
 =?utf-8?B?TmlkZkdNUU0yWXBOQzdzVWRFMUJGS1NqNy9Za3J3WmZxbFZaU2Jya0JjRVh3?=
 =?utf-8?B?S3BXN0FEd2VtTVZRWXlIVk15QzFaSHhRelJNVEFteTBZNi9ici9XbG1YTVpF?=
 =?utf-8?B?NmF3YWlINFZia3Z3SVI2YXRMNHZETWVoSUd3cmFkcHZ2dkszN1N6QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9785d30-78cb-4e13-23a6-08de44608ea2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5805.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 09:24:24.0690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Etu1zuCwMvZBP0+RAx5qHzB1tCRriI17a1modwaA7uuj1jUYS/tV72IIZt59QrLJoulnpx5s1RtiY+7UonSEPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6326
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8504A140003
X-Stat-Signature: idmcqsyjh5gtyf9zo6yrnh53suedwjpf
X-Rspam-User: 
X-HE-Tag: 1766741067-334322
X-HE-Meta: U2FsdGVkX1/bcDoSlyPib5I5+cT2CbhYuFStZ6f2LRaN47X6wzs5kaHr5zkdJBeoHgsr9TwLuz9nWQ5I+Dh2/Ce4JkqYqb3XMw2REn49aCAUK5J8Ab929nhCpigYC7XjgmnjDTrpLB0CEPez13aA8MDRlP7mGfgLBwyE7XHB9AAoOaZkGQZ5IqT41TMltILRlzkPufRgO48tTS0ovsKZb9bH7Ix6H5n1LYVejuTodiT8Z7ZdiBG79zjwiEsXxZzNaQ7gy7BjdUoMDyW5fco9MkA3ssE0NEH5SVyc9iv1j8eqfzuTuo/j8kIP4+bpk5rPJaDAn3HN2Vcb64RrSsjc0MdruS9bCyZ5/vrNr8/I7MT0pNcmHKmf6MQ16P3bpTGFv60kzQ+1buFB4GK696oqaRGggZbnYWurvbGVP2ND6hmJYXXxRGcbo309fbTrcQNYDZvYPppW2LOoF1cFxf4jBFfteEgfijKzbntNOGGI13kHizqOwHzcjzQlFEI4pH+dyIQns+onOL0Hi65g2OHUMFpr5kXfCRm7dHSs/fuGTUYLoRkZPdfYG7nbeWCsEWDsDAYyMi1LbQjlkzqUUiEgeNYogIg78pJaqQo0DTf3pN0PmCE3fK8JlNHcaR+QkHAPiYyzXs4zqHhEU5gVr1SkWxc1M2FvJZznrerXHTSaP2s4PZwa3PoNENDa0yRPuZ5nsimNBxD82oN7fR6a4O+tc9vioIiMzhSMUqXO7V4FXOSXrV4c4liF/U3fCjtYJXrFbCtEbXmH5l2xgFo0tTgctUG7pWbq87IQi+6+XW5k+Kh7PCv7VioSJAzkYUGQZFoGmy/ROnu5WIVoCgxjwqWgOHFUeAcLfzxR90KZlSO1mRNw5XgUoSKo4ne12Nbw7glgzDVWFEmCfxsp/yGjnZ3m1iV5yT6agQRS7yR9SWmexQZ/HJ6TeaGIIdzIXzKp03VyoiN/3JGKV9WAUS8PEvL
 qs72dfio
 e7DZHenerICKrpEoeNls8CXfkYq2kC4JE0R8mGUGHkkK8iIxf+2rYzb/SSOnaGUnWyW5sx9ElYxQ24O5S26wYJ22FGYDJvyP5JDh3GfSF+cWd9/0l9sNjC0P0fAn0MToXHdJRF1HZV8mbhb4a2pMBzaI7uA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/25/2025 1:50 PM, æå wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patch establishes a pre-zeroing framework by introducing two new
> hugetlb page flags and extends the code at every point where these flags
> may later be required. The roles of the two flags are as follows.
> 
> (1) HPG_zeroed – indicates that the huge folio has already been
>      zeroed
> (2) HPG_zeroing – marks that the huge folio is currently being zeroed
> 
> No functional change, as nothing sets the flags yet.
> 
> Co-developed-by: Frank van der Linden <fvdl@google.com>
> Signed-off-by: Frank van der Linden <fvdl@google.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>   fs/hugetlbfs/inode.c    |   3 +-
>   include/linux/hugetlb.h |  26 +++++++++
>   mm/hugetlb.c            | 113 +++++++++++++++++++++++++++++++++++++---
>   3 files changed, 133 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 3b4c152c5c73..be6b32ab3ca8 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -828,8 +828,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>   			error = PTR_ERR(folio);
>   			goto out;
>   		}
> -		folio_zero_user(folio, addr);
> -		__folio_mark_uptodate(folio);
> +		hugetlb_zero_folio(folio, addr);
>   		error = hugetlb_add_to_page_cache(folio, mapping, index);
>   		if (unlikely(error)) {
>   			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 019a1c5281e4..2daf4422a17d 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -584,6 +584,17 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>    * HPG_vmemmap_optimized - Set when the vmemmap pages of the page are freed.
>    * HPG_raw_hwp_unreliable - Set when the hugetlb page has a hwpoison sub-page
>    *     that is not tracked by raw_hwp_page list.
> + * HPG_zeroed - page was pre-zeroed.
> + *	Synchronization: hugetlb_lock held when set by pre-zero thread.
> + *	Only valid to read outside hugetlb_lock once the page is off
> + *	the freelist, and HPG_zeroing is clear. Always cleared when a
> + *	page is put (back) on the freelist.
> + * HPG_zeroing - page is being zeroed by the pre-zero thread.
> + *	Synchronization: set and cleared by the pre-zero thread with
> + *	hugetlb_lock held. Access by others is read-only. Once the page
> + *	is off the freelist, this can only change from set -> clear,
> + *	which the new page owner must wait for. Always cleared
> + *	when a page is put (back) on the freelist.
>    */
>   enum hugetlb_page_flags {
>   	HPG_restore_reserve = 0,
> @@ -593,6 +604,8 @@ enum hugetlb_page_flags {
>   	HPG_vmemmap_optimized,
>   	HPG_raw_hwp_unreliable,
>   	HPG_cma,
> +	HPG_zeroed,
> +	HPG_zeroing,
>   	__NR_HPAGEFLAGS,
>   };
>   
> @@ -653,6 +666,8 @@ HPAGEFLAG(Freed, freed)
>   HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
>   HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
>   HPAGEFLAG(Cma, cma)
> +HPAGEFLAG(Zeroed, zeroed)
> +HPAGEFLAG(Zeroing, zeroing)
>   
>   #ifdef CONFIG_HUGETLB_PAGE
>   
> @@ -678,6 +693,12 @@ struct hstate {
>   	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>   	unsigned int free_huge_pages_node[MAX_NUMNODES];
>   	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
> +
> +	unsigned int free_huge_pages_zero_node[MAX_NUMNODES];
> +
> +	/* Queue to wait for a hugetlb folio that is being prezeroed */
> +	wait_queue_head_t dqzero_wait[MAX_NUMNODES];
> +
>   	char name[HSTATE_NAME_LEN];
>   };
>   
> @@ -711,6 +732,7 @@ int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping
>   			pgoff_t idx);
>   void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
>   				unsigned long address, struct folio *folio);
> +void hugetlb_zero_folio(struct folio *folio, unsigned long address);
>   
>   /* arch callback */
>   int __init __alloc_bootmem_huge_page(struct hstate *h, int nid);
> @@ -1303,6 +1325,10 @@ static inline bool hugetlb_bootmem_allocated(void)
>   {
>   	return false;
>   }
> +
> +static inline void hugetlb_zero_folio(struct folio *folio, unsigned long address)
> +{
> +}
>   #endif	/* CONFIG_HUGETLB_PAGE */
>   
>   static inline spinlock_t *huge_pte_lock(struct hstate *h,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 51273baec9e5..d20614b1c927 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -93,6 +93,8 @@ static int hugetlb_param_index __initdata;
>   static __init int hugetlb_add_param(char *s, int (*setup)(char *val));
>   static __init void hugetlb_parse_params(void);
>   
> +static void hpage_wait_zeroing(struct hstate *h, struct folio *folio);
> +
>   #define hugetlb_early_param(str, func) \
>   static __init int func##args(char *s) \
>   { \
> @@ -1292,21 +1294,33 @@ void clear_vma_resv_huge_pages(struct vm_area_struct *vma)
>   	hugetlb_dup_vma_private(vma);
>   }
>   
> +/*
> + * Clear flags for either a fresh page or one that is being
> + * added to the free list.
> + */
> +static inline void prep_clear_zeroed(struct folio *folio)
> +{
> +	folio_clear_hugetlb_zeroed(folio);
> +	folio_clear_hugetlb_zeroing(folio);
> +}
> +
>   static void enqueue_hugetlb_folio(struct hstate *h, struct folio *folio)
>   {
>   	int nid = folio_nid(folio);
>   
>   	lockdep_assert_held(&hugetlb_lock);
>   	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
> +	VM_WARN_ON_FOLIO(folio_test_hugetlb_zeroing(folio), folio);
>   
>   	list_move(&folio->lru, &h->hugepage_freelists[nid]);
>   	h->free_huge_pages++;
>   	h->free_huge_pages_node[nid]++;
> +	prep_clear_zeroed(folio);
>   	folio_set_hugetlb_freed(folio);
>   }
>   
> -static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
> -								int nid)
> +static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h, int nid,
> +		gfp_t gfp_mask)
>   {
>   	struct folio *folio;
>   	bool pin = !!(current->flags & PF_MEMALLOC_PIN);
> @@ -1316,6 +1330,16 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
>   		if (pin && !folio_is_longterm_pinnable(folio))
>   			continue;
>   
> +		/*
> +		 * This shouldn't happen, as hugetlb pages are never allocated
> +		 * with GFP_ATOMIC. But be paranoid and check for it, as
> +		 * a zero_busy page might cause a sleep later in
> +		 * hpage_wait_zeroing().
> +		 */
> +		if (WARN_ON_ONCE(folio_test_hugetlb_zeroing(folio) &&
> +					!gfpflags_allow_blocking(gfp_mask)))
> +			continue;
> +
>   		if (folio_test_hwpoison(folio))
>   			continue;
>   
> @@ -1327,6 +1351,10 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
>   		folio_clear_hugetlb_freed(folio);
>   		h->free_huge_pages--;
>   		h->free_huge_pages_node[nid]--;
> +		if (folio_test_hugetlb_zeroed(folio) ||
> +		    folio_test_hugetlb_zeroing(folio))
> +			h->free_huge_pages_zero_node[nid]--;
> +
>   		return folio;
>   	}
>   
> @@ -1363,7 +1391,7 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
>   			continue;
>   		node = zone_to_nid(zone);
>   
> -		folio = dequeue_hugetlb_folio_node_exact(h, node);
> +		folio = dequeue_hugetlb_folio_node_exact(h, node, gfp_mask);
>   		if (folio)
>   			return folio;
>   	}
> @@ -1490,7 +1518,16 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
>   		folio_clear_hugetlb_freed(folio);
>   		h->free_huge_pages--;
>   		h->free_huge_pages_node[nid]--;
> +		folio_clear_hugetlb_freed(folio);
>   	}
> +	/*
> +	 * Adjust the zero page counters now. Note that
> +	 * if a page is currently being zeroed, that
> +	 * will be waited for in update_and_free_page()
> +	 */
> +	if (folio_test_hugetlb_zeroed(folio) ||
> +	    folio_test_hugetlb_zeroing(folio))
> +		h->free_huge_pages_zero_node[nid]--;
>   	if (adjust_surplus) {
>   		h->surplus_huge_pages--;
>   		h->surplus_huge_pages_node[nid]--;
> @@ -1543,6 +1580,8 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
>   {
>   	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
>   
> +	VM_WARN_ON_FOLIO(folio_test_hugetlb_zeroing(folio), folio);
> +
>   	if (hstate_is_gigantic_no_runtime(h))
>   		return;
>   
> @@ -1627,6 +1666,7 @@ static void free_hpage_workfn(struct work_struct *work)
>   		 */
>   		h = size_to_hstate(folio_size(folio));
>   
> +		hpage_wait_zeroing(h, folio);
>   		__update_and_free_hugetlb_folio(h, folio);
>   
>   		cond_resched();
> @@ -1643,7 +1683,8 @@ static inline void flush_free_hpage_work(struct hstate *h)
>   static void update_and_free_hugetlb_folio(struct hstate *h, struct folio *folio,
>   				 bool atomic)
>   {
> -	if (!folio_test_hugetlb_vmemmap_optimized(folio) || !atomic) {
> +	if ((!folio_test_hugetlb_zeroing(folio) &&
> +	     !folio_test_hugetlb_vmemmap_optimized(folio)) || !atomic) {
>   		__update_and_free_hugetlb_folio(h, folio);
>   		return;
>   	}
> @@ -1840,6 +1881,13 @@ static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
>   	h->nr_huge_pages_node[folio_nid(folio)]++;
>   }
>   
> +static void prep_new_hugetlb_folio(struct folio *folio)
> +{
> +	lockdep_assert_held(&hugetlb_lock);
> +	folio_clear_hugetlb_freed(folio);
> +	prep_clear_zeroed(folio);
> +}
> +
>   void init_new_hugetlb_folio(struct folio *folio)
>   {
>   	__folio_set_hugetlb(folio);
> @@ -1964,6 +2012,7 @@ void prep_and_add_allocated_folios(struct hstate *h,
>   	/* Add all new pool pages to free lists in one lock cycle */
>   	spin_lock_irqsave(&hugetlb_lock, flags);
>   	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
> +		prep_new_hugetlb_folio(folio);
>   		account_new_hugetlb_folio(h, folio);
>   		enqueue_hugetlb_folio(h, folio);
>   	}
> @@ -2171,6 +2220,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
>   		return NULL;
>   
>   	spin_lock_irq(&hugetlb_lock);
> +	prep_new_hugetlb_folio(folio);
>   	/*
>   	 * nr_huge_pages needs to be adjusted within the same lock cycle
>   	 * as surplus_pages, otherwise it might confuse
> @@ -2214,6 +2264,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
>   		return NULL;
>   
>   	spin_lock_irq(&hugetlb_lock);
> +	prep_new_hugetlb_folio(folio);
>   	account_new_hugetlb_folio(h, folio);
>   	spin_unlock_irq(&hugetlb_lock);
>   
> @@ -2289,6 +2340,13 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
>   						preferred_nid, nmask);
>   		if (folio) {
>   			spin_unlock_irq(&hugetlb_lock);
> +			/*
> +			 * The contents of this page will be completely
> +			 * overwritten immediately, as its a migration
> +			 * target, so no clearing is needed. Do wait in
> +			 * case pre-zero thread was working on it, though.
> +			 */
> +			hpage_wait_zeroing(h, folio);
>   			return folio;
>   		}
>   	}
> @@ -2779,6 +2837,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
>   		 */
>   		remove_hugetlb_folio(h, old_folio, false);
>   
> +		prep_new_hugetlb_folio(new_folio);
>   		/*
>   		 * Ref count on new_folio is already zero as it was dropped
>   		 * earlier.  It can be directly added to the pool free list.
> @@ -2999,6 +3058,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>   
>   	spin_unlock_irq(&hugetlb_lock);
>   
> +	hpage_wait_zeroing(h, folio);
> +
>   	hugetlb_set_folio_subpool(folio, spool);
>   
>   	if (map_chg != MAP_CHG_ENFORCED) {
> @@ -3257,6 +3318,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
>   		hugetlb_bootmem_init_migratetype(folio, h);
>   		/* Subdivide locks to achieve better parallel performance */
>   		spin_lock_irqsave(&hugetlb_lock, flags);
> +		prep_new_hugetlb_folio(folio);
>   		account_new_hugetlb_folio(h, folio);
>   		enqueue_hugetlb_folio(h, folio);
>   		spin_unlock_irqrestore(&hugetlb_lock, flags);
> @@ -4190,6 +4252,42 @@ bool __init __attribute((weak)) arch_hugetlb_valid_size(unsigned long size)
>   	return size == HPAGE_SIZE;
>   }
>   
> +/*
> + * Zero a hugetlb page.
> + *
> + * The caller has already made sure that the page is not
> + * being actively zeroed out in the background.
> + *
> + * If it wasn't zeroed out, do it ourselves.
> + */
> +void hugetlb_zero_folio(struct folio *folio, unsigned long address)
> +{
> +	if (!folio_test_hugetlb_zeroed(folio))
> +		folio_zero_user(folio, address);
> +
> +	__folio_mark_uptodate(folio);
> +}
> +
> +/*
> + * Once a page has been taken off the freelist, the new page owner
> + * must wait for the pre-zero thread to finish if it happens
> + * to be working on this page (which should be rare).
> + */
> +static void hpage_wait_zeroing(struct hstate *h, struct folio *folio)
> +{
> +	if (!folio_test_hugetlb_zeroing(folio))
> +		return;
> +
> +	spin_lock_irq(&hugetlb_lock);
> +
> +	wait_event_cmd(h->dqzero_wait[folio_nid(folio)],
> +		       !folio_test_hugetlb_zeroing(folio),
> +		       spin_unlock_irq(&hugetlb_lock),
> +		       spin_lock_irq(&hugetlb_lock));
> +
> +	spin_unlock_irq(&hugetlb_lock);
> +}
> +

nit:
May be simple enough chunk to introduce guard() above

[...]

Regards
- Raghu

