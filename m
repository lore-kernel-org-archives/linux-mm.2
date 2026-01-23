Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D056D778B0
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01186B054D; Fri, 23 Jan 2026 15:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE6D6B054E; Fri, 23 Jan 2026 15:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32156B054F; Fri, 23 Jan 2026 15:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B008F6B054D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:08:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BB3EBA421
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:08:15 +0000 (UTC)
X-FDA: 84364315350.30.7CCE46F
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010065.outbound.protection.outlook.com [52.101.46.65])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6161E1A0005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:08:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Gy6Y2wLZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769198892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQixQ2tfJiMZyR0hTzJPg4UY2guwY7zktsRSRtzFtVs=;
	b=n6fBIZsp8mQR9Jys7IEA+o8ebZt4NnZ7L/AJcptArty9XwgXEkihMeXxvJ5LRT3ZzmY6MW
	/KW/thRbxUOR7puXh4FBCYHcsT/gC6CoAJZ5oXzUFaCpB0vmuojfnF77520jnqvIcWdsqa
	8iNbEfCDhX+x5rK6I3nfC/JPBfqV2Nw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769198892; a=rsa-sha256;
	cv=pass;
	b=wmb08nTrJP51DNrn/lgW55qVVjFZ2xuNhskeMBlgrafQo2BQoEzKEIbQPZpVLIPoFMbDB/
	8GyDMpp9Eb3wwGxqM9nXQtyJcmeR40KlfCRTcGIZzhBXEI6RFr5avNUOD9fUZS1FXvlZ2J
	s6alyDrRlzNFywFS9fA+PVXlV1m6CjY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Gy6Y2wLZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A0+41BB1xwKrFYZVs7fLMYrGpNXhlC0fF8xSBZS3gveSd4GiIvMHfepBJ0/fA5M107l/7LS4zwisobG9J3L4cz1q3thdidpnxXk+rByqdqsM57SCENRiUxaCP1n3JiBORUHRg8TbrXGLDfcaTn92YU1TCWPJIfcR8UVug8/ThfkhpQ8bOmq5Xk1fb+/pWmuzahW7lfqup1YSGki+PonY/23+UncU24s0T/sFk3rn5OwGEakx6JydOo4xOySI2ak98pehhCyANEO4chb38Cs+muaimCK/MtgSi/DxO5Nftl5s9uAzoWPFyxmKZ92KZvFYPo844kVMRakVIB4SOrSPgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQixQ2tfJiMZyR0hTzJPg4UY2guwY7zktsRSRtzFtVs=;
 b=rRvEzHhWsQG9A/l88Mv0tqOILDeR+GNdmazHn6jNoulDjFebwQjrvJh0Y4HwN92GRiBf6DMPlojHIA2vaxhppAi3IE9W+0KxfHI8ZPXpMW3SBt82F76WKAi4hlCw6NcyO2PDOc9Ecx11TaCtklXkPcmaBsRKJe6oz4bGSuw+7347bVcnaVbABy4GWFhk7IoiOXW52e5aUmqrJrCp3TWZv7Pmnssbu5ICnUw6tmN1XM0ZrIszf3AcLPHQcc10LrMw6IeuseVkhudH3ACXS+1Of/2pkKQkb10gMq4mlH5yrVvFT0VpgHV6PrRIoJwaFUCVUz32fxTMARobMiRZQ2NkSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQixQ2tfJiMZyR0hTzJPg4UY2guwY7zktsRSRtzFtVs=;
 b=Gy6Y2wLZdf9ktUcg6gHXlqOUDVNy5P7P/Ob0GV3yVcFjiu1DJVOML95uFhoVJXnb3UdHkDKB3Wfjh+zPunV6tEWIRN0wEqLykLA/lv9/OVRTYc6HBFak8zeCp5vUSuqJCgmimdZ42PzHqBp1GsV5Xvggp/unF2K6+kmYD0cnXbY=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by MN0PR12MB6056.namprd12.prod.outlook.com (2603:10b6:208:3cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 20:08:07 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 20:08:06 +0000
Message-ID: <195ae185-2b88-4841-90f1-e68df6acbc90@amd.com>
Date: Sat, 24 Jan 2026 01:37:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/5] mm/khugepaged: count small VMAs towards scan limit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-8-shivankg@amd.com>
 <829b62c8-e3eb-485f-8d7b-01419c841cc8@arm.com>
 <d9d569cc-127c-41f8-b16d-d6e11ba7b43a@linux.dev>
 <7193b89e-ac2d-47c9-8fa5-68e35c57d4b6@amd.com>
 <836669ac-473f-4c30-a368-c05bfa86c306@amd.com>
 <20260123073738.76b9e59521270e45eae70f88@linux-foundation.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260123073738.76b9e59521270e45eae70f88@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0129.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1d5::15) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|MN0PR12MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: d20415da-fa1b-45fd-f9cc-08de5abb1ef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aksyck96U0JxUnhyQ3NPT0JqM3lzK2pJem5Gczh1eHVURHd6UWFycC94SWJx?=
 =?utf-8?B?Q0c0OEJpdkRHZmxMNTVrMEZ4c3kxZVZ4TUMybWlSTEVYRjc5MWIwd0JJaHFN?=
 =?utf-8?B?bitySzQ3YWN6YUM2LzZXSDFPcHF1WVN2QlVLTHNjQXJoWU5YSk05TWMwQ1hx?=
 =?utf-8?B?OWYwbmo3ZDBCZXBHaWNBbEpScmRObG8reFFyRXJpNnROaFNZYmJBL2UrZlJU?=
 =?utf-8?B?OXpnS3Ywbk9IdldtcERaakxNcWl0V2VXTXRXbEVRV1JsTmhYNVZvMkdSZzdu?=
 =?utf-8?B?NGRUVytUc0Zmcy93OVVSdGNVSGtGWmZQSzVpRU5KT21zRU1ieFZQS1VmQ21R?=
 =?utf-8?B?T0VjRWtQUlVDaDdKR1F6bUV2MzFYWW9BSmNrb0lLWTVIOEV6N3hWYlBBcXJR?=
 =?utf-8?B?TWFITURiMDBhRWJYME5uZjJvQzAyQ3BpdmRkVG1IZitUQ0ViN3paeXBHdmJp?=
 =?utf-8?B?TGxmVWxDN3F1SHJpTGFLU1B5QVB1elpWMnJneXlIR0lWdHc2UjBhK1BXY2Z6?=
 =?utf-8?B?VlBzcUppbUs1VzlRSTh2eVMxQ3VBQ1FHOXRvZEh6ZjEwZUt5eEpSejlKT01D?=
 =?utf-8?B?WjF5Rk4xNkpWT05HR3p5VEs5RlhoWThZTHdxN3ROeHZkRlJJaWhLeHlvSWJC?=
 =?utf-8?B?Y1E2eVBnb1c3bWlhMmMxUTVnYUlMUHdkemw4K2tFb21pRlRubE85QXZxWHB1?=
 =?utf-8?B?UWM1YmM0THJSSTZDb243YllvUHltckpYeUM1RzJuWExJSmhmVFI1TzVidHVP?=
 =?utf-8?B?WCtvVGhYMmp3TTIxQS9FdTlXcGVISElyZDQ2RUhQdVVZakh6MzMzVm1LalRW?=
 =?utf-8?B?K1hHcGVsYm5GYndabWJnUWd1OUJyM0wwbmY3OVYyM2pNcGU4clkxTnFPc1dN?=
 =?utf-8?B?NU9VN0pSeDNIU2J4bG1OdGxyck5sVHdyQkQrQ0ppNTc4ZVArNGdadUFBWkIr?=
 =?utf-8?B?N0gvbVR6YnViZzZZbUxzSmNPMG1JTVlBaXdCaHI2aEZPdkJIOTJhcmNjWjU0?=
 =?utf-8?B?SDBhNW0rb1FuTnc3Vmhwekd0V09aSjhhZ1R0M2ZiV1Y1UkwyVHB6MDhSTWM3?=
 =?utf-8?B?SVBDM3RNNlUrbXMxRGJlNUFxeFBHZ2VLSXRrK2RzdnlCT2ZPNWE0RExTK3pq?=
 =?utf-8?B?cXpUTXRPd1lHQmJ0QmJoWkdJL2FRbzd1aXNuTXNoekV1QWduMDBUQUxKSkVw?=
 =?utf-8?B?SlpVT2ZJRk9XNStLSXJrbDNHS3ZJWFZMeWtJb0gweldablpQMllkeTh0Wmlh?=
 =?utf-8?B?Z0pQV3FuZlRDdnMwVzhFdkhrSkQyWEVWQlA4cURzYlA3cy80SEZWVFlQcWlj?=
 =?utf-8?B?dFM4VnVvczFVU0tsQmF1YW5TM25CMFBIUmo4ZUhaUjk4c3I5RnM3b2NiMHk1?=
 =?utf-8?B?ZkdJYXk5cms2NGNWSUJDSWc5a25NcnpzTU5WMUR1VnNTQ2NkVzIrOG1XdEd1?=
 =?utf-8?B?c2lkejQ5c1hUS3RlaXlQQkZ6VmtGT1Zycjh6bDlLZHQ4NVUxTVdhK09VUE5x?=
 =?utf-8?B?L2NGTENGMmFxWWk0WGI5QnV4eWQ2K1pyeFJSbUVVM2pFWXFCblJ4ZVl6eDFj?=
 =?utf-8?B?cXFMektrQ0x5WHlJLzJZMTJqWVB2a1ZSZ3lFdFFyUlF4dkM3QWwxYTJLWkti?=
 =?utf-8?B?dTVwUHA4VDdHdVJKYmIyb01qWm1EMXN3L3BWUU8wVkYyN09MSE0wOTFpaHNJ?=
 =?utf-8?B?QStOZGhMSE1RR1FOWmdBNVB0UDJTWFBCQ0E2RGFsQkhwSytxSzVvYVByb2Zq?=
 =?utf-8?B?czVPbmNRdVVtNXJLSUF5V3FjRnplbENWZHIweXlkV1pkZE9yZ29GQmwyRkF2?=
 =?utf-8?B?N0Q4dDBUVVRDZG5OSFZWbi9BdTdIZVVvd044dlRIa2VlVnc4ZVIvSHQvS3hj?=
 =?utf-8?B?R00xcTY5TXVtdXoxUWtRT1RCNUJNdTE3a1ZTRmtGVG1DK2QyZkxxSHQ3ZW52?=
 =?utf-8?B?K2FTVEhvVDI3MW5hREJaV3l5a1QwV2NHYW5xK1Bhb1FTQzA2Qis5VHNHeVdR?=
 =?utf-8?B?dDZvcm1vMGkyNE1DbHdjMnR0TkpYajg1YzF5UDZrQ1diY1Q0MDI1NDZHTkhQ?=
 =?utf-8?B?bExmMis1VUNIVGlGK0xuKzdyM2Nzc0tOZnpmTXMrQ1puZzZmcVVBVys5cTBu?=
 =?utf-8?Q?6hT0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlZMRW80Nm1ZSk9XQk81VThjdHhpSTMxbmVsL1d2dS9wdWl4cm5PMkdXQTZu?=
 =?utf-8?B?YnczZDM3U0ZxUmt0a0lheFBmZUVFNlpLSzFsY2ZOU2swNmpUalFabGc1cGV6?=
 =?utf-8?B?TDVYNk1sMFdJbG5YbUpmMGdlS2t0ZXFQQnB1eTRXdDZndFlqbStUTUM3ai9x?=
 =?utf-8?B?MVhMcmVMQjQvemJGQ1doQTVaQTJBa2FJNmRaN01iM0tNWUYzZDl1M21SNzQz?=
 =?utf-8?B?SjhPU2R3dFJxeENjUmdFNlczMVVRaUFPeDJrY1ladWJoUStUQmRIRXZvNE50?=
 =?utf-8?B?YXQ2YzkrM2EzRis3THMzRG9RdFg0aVExZGQwZHMvN3BtU2JKcU9xckpsSVVv?=
 =?utf-8?B?ZXdwOWE4QWx4MGNSTFJEY3JCQ082NGRlSFcwL2JKWXZ6QXVCaDNJZnhRaktm?=
 =?utf-8?B?aHpTLzJqV1NIbUV6Z2poNTlpRnZJWXM5YlRXWWpqQitnSDFYSTdWRFlqNTJ0?=
 =?utf-8?B?UmZBeEI2UEI4ZHJlQlVvYjRNQ011c2hVRW1YQUF2MFNPRzRNSGR1ZnJ2VWRX?=
 =?utf-8?B?K2t0VGlXWG9hZUVXSVdIS01vSGUwcWt2L3NPZUZxSERWVXhSRG1oaDI4UWIz?=
 =?utf-8?B?aVlVVmRFRmJnRmp2eEh5eXo5Rk0xc0p1NlFKclJVaUFtWXJnaHJiblI2ZVQ5?=
 =?utf-8?B?M2s0Nks5OXNCL3YrZ1BzS1A4MWxmQm5QRHM3ZDB1OVErT2xCcThEVFFtVGVw?=
 =?utf-8?B?QlkzMDBDakZXVHR5M0R1VjI5dERSSzNjZWZQd1JiMnhCMlM4YjZtQTJaemNC?=
 =?utf-8?B?NXByOG5QS0FvSllyeHZyUW5UZTZzellOZWRMeDNsbnU3SGptNjVONDNzY0Jt?=
 =?utf-8?B?djhvaVMyZXlnTzBYZDNEYWJwUjRGT2RiZ3JzN29HcWpCaHU0Y0ZYOXRnVk5Q?=
 =?utf-8?B?a1hkbG5pdTFUZTFWanFMZXZGWEtIeitTN1dtc3pUTGVNRGRwYVZHNlptdkUz?=
 =?utf-8?B?ak1MSWdXZ2dwUWVQQmo0TElWSndxdWtGbHF0NTY0cWNKWDg1RUlnamxMZStq?=
 =?utf-8?B?alloN0doRHJ0dktjN25aV21pTDFBR1hFS3ZSa1c0WFpCUHVCWWRCMUdRc2lm?=
 =?utf-8?B?VnU1Rk01dnRpSmJtdXVqRWNhN2hLd1ZmRVFrTzFtR2FVY2JWWXVJYjIwNnYw?=
 =?utf-8?B?am8rdUNuUGxZRG5zNGJpdnJkT2hMRXk5WktiWC9xakV2TmVycU1oSHpsOGNK?=
 =?utf-8?B?bnowelFyWnR6OHdOZmFMV1RDcmtkaXprSDEyZm9OVXRLZjhOTWg5VjBTTDFw?=
 =?utf-8?B?QkwvckVjaVRqMkJNL2V6amU0Nml1enZqbng1N2VJdlgvRVZzUzBvc3FrTGo0?=
 =?utf-8?B?MWtKaFF0dlJ6Qk5XTlpTY1QyQTkyb2dzSEpMOGFxZmJxN3lzMlRCMVJGaTZL?=
 =?utf-8?B?WTBxZlkrcXlncXhnWGZHTUJENUN5RFFMRGFNOHJjTG5YYzY3KzJiSVNXaUlL?=
 =?utf-8?B?KzVlTWtDYk90NWhUS2dOempMOVVJbW5KQ2I2b0FCTWpqQWppVktxb2oyVDYv?=
 =?utf-8?B?M0hGM1pZZmI5NGlMTW5CalREd2FSbG9hVXNOT2llb1pMR2FGZFVKUmNQUXM5?=
 =?utf-8?B?OGNyajVJd1o2ZUpHYlVwMVhGUTltRThSVTlQd2lpVHhicG85SzlTNVlYOTYv?=
 =?utf-8?B?Y0kzcGQ5aFZJVnhJMzNIYkY4aFpGVUFxNjk2dTNaVVNFR09DK2wzSm94RnVw?=
 =?utf-8?B?ejhCb1YvSVNLOHJ2ZGcxOTFyY3JDYUVJanJWckdob3k5aDJwa1docHorWmxI?=
 =?utf-8?B?THBNNEdtOWJnMDB6MDQ1QWhLRzR0ZVI3R21MMC94QjhicEFZdzJSOHV0RFVR?=
 =?utf-8?B?RnViRXVDQjFhNkh6Rm5WOG9rT1RiZEgzam9PSHJuL2lpQnhiWjJiaHdVTm02?=
 =?utf-8?B?RHBNUTBEVEVLcnEyS3o3dFkzdENvaEUwY2xUSmR4MFdRb1lodFpWR3F4b2cy?=
 =?utf-8?B?dHptM2RsQ1FVRktGa0FiL0RGTkYzQTl3Q2pJMlNOaEh3OEVITUpXSHplUEVp?=
 =?utf-8?B?TUptUStXejBqb0x2Y2w5WGhVVTdKM0hQY2FpZ2IvcGhwZHIvTlFsdmtSWEtn?=
 =?utf-8?B?ZXdYYUFESXcxWkxIdUM3MzZOL1VKY2dvOUNWcllpUnBaRlJVbE51SmdDOVRL?=
 =?utf-8?B?eU5WN1l1azJaTTQrRzR3S1JTMjBzU3oxSHMraFdmM0d5OGF3cmVROWY1L09Y?=
 =?utf-8?B?UUdxT0VCaTNERU4yMlVIN1RIeXkxTjN5eDQwTFlTWUdNNktabTh3WHROcWpN?=
 =?utf-8?B?eVNXN3VPdzRlR0x0Zk5pZS9NR1F2ejEydkZ1bzdOTnlKakY4ZVEwc2cyTGkz?=
 =?utf-8?B?c3BSMFFndEFqOVZDN3NXTW02M1c4VUhvTTloUVJDR1IxNklvRDhWdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20415da-fa1b-45fd-f9cc-08de5abb1ef1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:08:06.0989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUv+Mizh/jfMFEiy4GxDCfMd2ekDEbmSrM6uWlMUXRGaqE/GIHG7hx8UK2Tg1t+oBDCfxrvDWTIw+JaSSOXsfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6056
X-Rspamd-Queue-Id: 6161E1A0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: y918zontwggm6fuuenoxbcyyc5i35irc
X-HE-Tag: 1769198892-89111
X-HE-Meta: U2FsdGVkX1+kgFokFvT2AhpR0UO99/M4vzxN+ekOiXbultnmuqlUZTwkkz6o1CVZ+yqDmMKvKsU6kLJuSyRZd0Gz/7g6rYoacRYXFDRmkwXy0TYwSFVih7mwAPFbKwFOML2OdvQzkd62EB6pPNWYzjBiAL0h4NvUnT0Y3HRw+sluMcayAhuSMKhuI0MBPy9+CuTqm8npMB6IbyaP5FK3wP8y/WqMgFYpcWcHNLIb7kTnTROYdo7PJZ15EjaPKaghouKcUJDw1ks7gpN8IVxZycdN4tpyYsoIeEw/buIEGpIUNksk58Heeb3bRAbYxGMU69xYKMCggDeXf8PLqtm5cp4LjVe9z8jwM2meFDUaJy0cAwcNjV9PMl6JqJBTP/pLBqrRPSf1ypQd3kuh4i1nDDq91mGUXp0+QUJokREWoLCg3tbWSfLwEu1Zy+P3P9zLOFYfQqAUKRjbC7aIbQsaJoEdf9jClVwcDV3AzSyiWR54F2fBIHUbVLofFE+cKPMHGXmd4Sr38JdDjA30inIzaVCMCJHJGhn5cQ2iXRwi4CxUtlpqObE1Uth7NishgCPRQ9MXyKy3VeYqfKjsmiPigMc0I5jsX+PY2PiYPEvy7kfvlZNxSWh2QNw3jxAItNoDq8UK92/8iFhhF3hvhDGPs3nZAFbO4NEc7TxRjtAsQjaSprf3ydef7gE7hnZqF0tsi5l6b/HW+9ymGvOV/IpM8qSSxD+w7ZECQYuGmXHQGvlLYWfkFkMo5kPrh+oCA1WDvIOu13k19lkvsRYCjDKEWU0fSzQlx0EuJXLA7+Gi5i9VLDq0iQ5Ww2H9ixYJLavC8YpSPqiaYMDgt1WZbO809M5LtQseXW2m3LkRoo5lTai2wWJJdYXYfxiNOU8rSUVaI9PTIuwTZdDcs8goqIwQ6asauwyQJZgvS8Wexxdqn+NeO3fic0+y/fsWMwjqT1vpLUJ56QJTIqRgeofQVWr
 aeLlsAK1
 4iNlaMXos2KKphDdH9FjcB4qzuUyeqdbaLQvAODk96t2mbTpojvb6CjwEt1B9FT7ba0h178dGa1vuDOFS05AV8puIuVVyPbhP/qTsKrWXkakAXNncP6yLcCLT/McJD6OEi1XSDoRfJZL2GyLg4DbpKakJKPwLqBp/Ll4ZUtMQGzmtWqbIXTa3WQIJY2hOIVv/JaeBrQ0ZOZ4BLemnkrJbmOcKkDJ7XM+Eo8t0iMSG7Nr57ZXdyU8QwZgNkokQB0Y/xPHxTp5eoRPzl2e//92XeY9plDVk5BLGESkSbtGbug5lKzfgW65ROmSoku7+ltfMCrDKQ7f5nee7V7oS9ne/YFcd2NtSqho9ppOqtGHavQaIsRh9X5UQ/1Gsse7jRo3jPbQLx67oZPGR2TI5wdFoJNyVFF19yst6OosbstYQ/hGsqrybrnj9V9PPQwzCgr6JjSq2mbownWec0T9y04GAGgRD3Bnv+FR1igrq1ube6tL4TjHCIgMZHWc8eNbgYSJ8y/43aUpbzfNCBdozduS48Wi22XDF+BE5A0w6Zwc1JmcLtNht7dcsC7YvQ4h56tZnetyX0OzgIYhfrmkB7Rzc9noQTwkUHrFif+jOGjqQD58nVAgA3WvtqwatNYDC14u4iHIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/23/2026 9:07 PM, Andrew Morton wrote:
> On Fri, 23 Jan 2026 16:12:07 +0530 "Garg, Shivank" <shivankg@amd.com> wrote:
> 
>>>> I was worrying about a case that doesn't actually happen.
>>>>
>>> You're right, thp_vma_allowable_order() is taking care of this, making 
>>> hend <= hstart check redundant.
>>>
>>> Thank you for catching this.
>>>
>>> I'll drop this change and send revision keeping only the unsigned int type 
>>> change for 'progress'.
>>>
>>
>> Hi Andrew,
>>
>> Please drop this patch.
> 
> thud.
> 
>> As Dev and Lance noted that the hend <= hstart handling check is redundant.
>>
>> The 'progress' variable to unsigned int is not critical either.
> 
> OK.
> 
> Were you thinking of adopting Dev's suggestion? 
> https://lkml.kernel.org/r/6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com.
> 
> If so, let's defer until the next cycle, please.  Now is the time to be
> focusing on stabilization, test, finishing up review, etc.
> 

Thanks Andrew, understood. I'll defer Dev's suggestion to next cycle.
Thanks for the guidance. :)

Best Regards,
Shivank


