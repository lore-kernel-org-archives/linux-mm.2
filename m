Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1CDC79FBC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 19:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E026B008A; Mon,  5 Jan 2026 14:54:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DBB86B0093; Mon,  5 Jan 2026 14:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B37E6B0095; Mon,  5 Jan 2026 14:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4D56B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 14:54:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 134611AE47
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 19:54:22 +0000 (UTC)
X-FDA: 84298961964.23.A55DBCA
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010026.outbound.protection.outlook.com [52.101.85.26])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F4AF8000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 19:54:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=L4JvuUEz;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.26 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767642859; a=rsa-sha256;
	cv=pass;
	b=PK1maq9c4Uf1u16STRPQwGIXzZC7DbV6cBbwI0bD9L4Bflp18fzXo27A7GVUxfD+eiupfe
	dlK893NYWzHBUmHx+EC+v7nm9nJjglJiwFVeYVDQSzmFooy80itC9n3nqGp0KMe1qccsHh
	MCl22yDDICToslPpB0FFyMbfH17WKBU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=L4JvuUEz;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.26 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767642859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIUoP9WdAfkc9xnaIv55N35YJfXDBEgGTziGbyx3Vc0=;
	b=Xq8Lf8iqlvhuI8DoCAAwp0i7UU1DV2x5MR7/zASnvHD4JQyAWZKMAN3E8p3BdTCIhsb2bM
	YK85gUzlSsxvrVynfV2wA7ZTqMSr9fjc7IVK5gSImU8/hQdhk1s14r26W+u2X96WXQLyQ7
	U9eJOD+6PyMiHx32G++Ak6xRPPe2a8c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HCrWKSY2N8XBdMf+0slJCh5Zic782WE/wQClkeNIoLKyNoFq3doB0wEWecrPbkWqb9xuDzYolNNpKBILS9upnOHFmqHpV3XmVlg+wMlsY9/kjK65eGunjcK9Ki+8btu+vOC8EK+gh17Xgy1W8+nL4KxlJP/AWlajpeOFtx25sTcUGUupq5/q3ppmXIfcHJPjpl1xEpnnSf+HKsfN6HuktdGl+LWWzudKD58h0JuznKs7DEUuPSAf3CUyZWFlomwabYMcYzVA7xhEEvajzh9n52YSQL7tsODDtngJFEatIML65pkApBX7UsymcLpISU0th1qgODv80bZ8wOjC1c8MHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIUoP9WdAfkc9xnaIv55N35YJfXDBEgGTziGbyx3Vc0=;
 b=po5k74NjHzBpiXLWgXiJ69fA8tYUs9xIlLS5ORPWseINc62lYUhVaROp4u44tpyzGtlRfiihzT9z/HlTWeIjScLL79EkXXjqE+z24jAu6D2M21ssqauZr/RAi3fgig9C5FKEbbSyi3wZWMNHPiHMCbaE/XriURLcUNuJ9dELTE/mGndy73QxQEfpCoc2EpinLxT+C0j1j5Vih2H89qmj7uNW/7WLRxqNOeEJhoLmGCM6nGyp7AJDBPQkJbLstp6S5592gTHuQkf9z+N1ZzCTSUVdlCEdkdNCbfl2qa2GY2TkCXYlOI3ocGJ1TYDLD6Xkz/ckIPzpRtd40kl6R6Fllw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIUoP9WdAfkc9xnaIv55N35YJfXDBEgGTziGbyx3Vc0=;
 b=L4JvuUEzRL8/rLcZKyoPGpvYH95/v+l7iXBngm4hAR87+6+FsWPak31jV4JyBTBB2+GHBZTxoKZ9gXkDE1ab7MrL651AdOJPcmwhkOOW2ovvgSWu22FZCfHTkeGqO1LgZnApTMoHG0bhNNMTl/FNSquEfZyWOwZPpOPiy8ZywAY=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by SJ1PR12MB6242.namprd12.prod.outlook.com (2603:10b6:a03:457::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 19:54:11 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 19:54:10 +0000
Message-ID: <d1cdf40c-9535-4d79-abaa-aa1675ec62f2@amd.com>
Date: Tue, 6 Jan 2026 01:24:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG next-20260105] khugepaged: kernel BUG at
 ./include/linux/xarray.h:1441
To: Matthew Wilcox <willy@infradead.org>, Calvin Owens <calvin@wbinvd.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <aVvz3tYdu49TGkjI@mozart.vkv.me>
 <aVwB3t2wD6Dyt6yT@casper.infradead.org> <aVwHYFesgoSSbKmz@mozart.vkv.me>
 <aVwPii7dfR5owHbV@casper.infradead.org>
Content-Language: en-US
From: Shivank Garg <shivagar@amd.com>
In-Reply-To: <aVwPii7dfR5owHbV@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0117.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::35) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|SJ1PR12MB6242:EE_
X-MS-Office365-Filtering-Correlation-Id: a17fa8d2-3b9c-4197-12cb-08de4c9431aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTVFOXhLaG0ycmttRCtrOVZiN25qdmZTQUx6eDh0Y2U4bWxQU29Vay9iZzFx?=
 =?utf-8?B?eDhhZE5TeDU1WTNZbTYxanhKZDZyZ0N5dVlqSHJhaVlEWFd1cnUyWEpKVmZp?=
 =?utf-8?B?dGEyK3V4WjVibWRrVElVc0d0dmNtV2tpdDNhSmM2REthdWFHWHBhTnE1QWds?=
 =?utf-8?B?MjIvMUwyWDc1WlhoNER2RVpCNXNIMEx3UmF4YVpydmxra1FkQkcyOUpPcHJw?=
 =?utf-8?B?Um9aaksrVlFodzRyeHFSYktkUU9MTzhqellnRnpZY2NMY09FSlphRVlDc2Nz?=
 =?utf-8?B?OERDdDlubHpEbHV6TW5XOGw1RE9Yc2xUN1lnVW9EU3p5SlFldXBMcS8yZWtD?=
 =?utf-8?B?R0h0MlBWR01DdWtmT1FNRGZCKzBOcHVKbm9tV0w3RFc5L1lkbTd3T3F1ZEN2?=
 =?utf-8?B?Qjl0cytHRnpQWGhyT0RuMlA2MUV2bkdacEZZai9YYyttYy9SL2VaQ3E5R1k5?=
 =?utf-8?B?UVBBc2hzQTFVL3N5UXI3RURSajlrYTNkNU1DOHlXRDhTWlNONUpNeit5MUFO?=
 =?utf-8?B?ZHVOYlBHV0hZcUFLTFJEYTRnZTdTWFllZW5KbmZuVVJ0Q2JkQzVTRUFKTTVN?=
 =?utf-8?B?Vk9ld2lBQ2RnYnV4aURWcVdNR3ZiUTN5YVY4VXVDTWVaM3ZpbC96VG13dDRM?=
 =?utf-8?B?MHczZFZhWkhsQTBRd0E4SWZ3UlVteForUmRmelo1Mnp3YmF0MW1Pa2hDNytD?=
 =?utf-8?B?U3daY29Ic2NPM0VlME8wK3J6QjRkQzlEYThuNkhTVjNlZjhLbFRndTRKOExo?=
 =?utf-8?B?UzFrN3I5a05SbTMyTnpOblV1Vkx0OXRkVUo1RjZYNWxhYVNwb1dSRmNGK0dj?=
 =?utf-8?B?aG05d0o0VEVlNGhZZGpRd1BMQzFLUDJvTFU5L2FDa1N1aUJrUXFQeDA0NnMv?=
 =?utf-8?B?WkdydTR3WFl1dENBZk1sK2M5NGJXaFoxNTFMYnZXeWhVN2JMczVxbWN4Rzhw?=
 =?utf-8?B?N21mdG9NZDg5akhGalRaL1lkNnVtY2ptUFV2VDBuNFB3bjJMaElSbnFQV3JQ?=
 =?utf-8?B?M3RUZVpKdTRHOGgzekVRR0IzY0NRWHZhbm04aG85enh6YXB6TTZ4OWtINGRn?=
 =?utf-8?B?alROMjNuMmJJQWsra3Y4YWtCR3hSRWl1bis3cmlBcUFqUmhVU1JSSUVMUFpl?=
 =?utf-8?B?RmRZS3RYRkxvM0h1dHNsWTQ5L3hNRHNMWSt3VzdpY3NuNkE1bkUyL29QRTd6?=
 =?utf-8?B?cGVWNjdnYzUzRDZlc01ySWllaTZEQVFQZzN3S2tzdmlxbWtoa3dxR0t3dGMz?=
 =?utf-8?B?dHRicUJ4S3JSZ0dheDB0cTB0WmwxKzJpd1E3c3RFdWVIRHZHUTN5RVJVWVh2?=
 =?utf-8?B?VVJTY1QzYkFaRFZlVmZIMWVxYXVLamZzQk5JY0dzSUlaRHhZb1JQSXY0OTNk?=
 =?utf-8?B?RTk4TmNjUjFCNFlRdkhtR1dtRXJDWmVqelZwVHdtWUF5c0pGNjFkSXlObmZp?=
 =?utf-8?B?ZVkvclZwM0hNbi9RaTN2RWUxZVlNYkxWL00veHVtYk53KzBPU3ZqTmtEQ0E0?=
 =?utf-8?B?UkxvRmxDV1p0ZXlaM1I0R2VhTm5YWThMd0w3UDhiOWFNZjJpT0ZPZy9DQUtu?=
 =?utf-8?B?bnNhT04xRUJSaEtIQWF1QzBkVU92N2JmN0NvbWE5akxsZVNSd2k2dnpGbkN5?=
 =?utf-8?B?VjRtMjVIbCs0QzJObzZVb2x5SmJZbnRlK25iK2p2Mk80QmhEZnZDd2JSc3Fi?=
 =?utf-8?B?MmE3MjRPM3lXWlZzSXNHZlhqblhQd29CNTBPY1oyWGd3Q0hacDhuS1lBM1V2?=
 =?utf-8?B?aXlMeTNXNnhzdTlCRFpBS0dPODY1SU1YYUp1d1dna0JsWnRWWU5jcXExdmRu?=
 =?utf-8?B?YzVhYzBGRlhtdkFLeU9XQTZJelRUREFLSGJFMFB2eFNmTkwrMkNlTEltUm1R?=
 =?utf-8?B?TTd4Q3dCWUE1dlJJVlRtcnlaVnpwT3A5RlhaQzl4d1FJcmFNelFsRmpGOGhM?=
 =?utf-8?Q?qVkH1q1Q9+juLOrVOLno9UaTL/wWKD3X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2ttRElTb2VtVElkclQ5dHJlZkFMVG0ySFAyazdzMEVvbEVsVEp4YU9qQXQ2?=
 =?utf-8?B?TWpqazN0eDlOQm10Y24vOTEvQ2M4Y3pPRkNKYjNSSEdiUjhjM3U1enJnbXVT?=
 =?utf-8?B?eFE5dEpWeU0xcVlZTFova0NlL29ORjYwYlkvazV1QUVUWXdGeEFra2k3NTJl?=
 =?utf-8?B?NFJTWlN1Y2ZKQkFpOVBHOGtlKzR5TlJYNUpjQW5xOGFLNjYwOW9OTkpHSkda?=
 =?utf-8?B?NkJpOVB6K244NEYrYzVnN0c1MS91bEFKaXhYcHJObDZiNGJJN2NpQzY4MXBp?=
 =?utf-8?B?OXozR0FiRTBCaVJBR2JPSDd1SmtKSzFMa3R1ZVN3NEVtS0YwWXIrUSszV0xN?=
 =?utf-8?B?WDVmbEpFWUJldGJwL2FYMjk0S3lWNjZnOVYrLzlrSXRBczE2STNWTGpYWWJh?=
 =?utf-8?B?ZEZwTHRnNW5XVCtZRHNYR0NJVzdtN2FVTVFpSlM3azFrT3RkTW52Z3NnZlhB?=
 =?utf-8?B?VWgyN0EwV2tja1FqV3pySXR2OUZvMTd3ZDBPUEZNcjhHTzVhKzUwY2M2c0d2?=
 =?utf-8?B?NlMrOUdXWDRpYkloZXVQVnlPeGdPczVGZzczdDY3eHN5c2VLT3lSM29JWHow?=
 =?utf-8?B?enZsWDFtZEx6MEhMSUIyaVI0Q2xnOGRJb3RPRFNDN0xGQ3lmb09zcG1LUFpv?=
 =?utf-8?B?a3dqWXd4OURPRk15eWdPVDF6Q3BDTTN1THl1YktmdHlzaUtLS3JRMzh2Z0xO?=
 =?utf-8?B?QjBqemZMN3IrazF2UVYzVHhjL29QK1VJNWVsVHNRVytQUjNlZFFhR1lWZmVS?=
 =?utf-8?B?a05ZbHVxSFB6NlBQYnBLdGhmTk5oOVBsRUdWdkg5SjV2ckJBRWt0M1ZSQjZl?=
 =?utf-8?B?T1hCZ203djdwcy94aEVQblRITTI2WU9OZDh4NlYzZEpqL3QwUk5SenhBazcz?=
 =?utf-8?B?cXpRZWtGeGozSTFybmd1bXMzYk5JRExQTEpEK2c1a0F6VzgySzZjcW9lSnFD?=
 =?utf-8?B?ckxzaFZVTGxxUHpXTHJhRVJCTENiaUVzQ3dzZU0xS3YvY2FBZ3cySzZPQTZv?=
 =?utf-8?B?MHNwc1d6VmlwQnFNcENPY0cyb05YSHQ5a3VRMUpwdWxSanpFcTFLVlNFZXM3?=
 =?utf-8?B?MjVRS2w0NjZneU03U293Z3VGWkZ5Q3RRYXh5NXAyRmFJWG0yczc4dkRLaDZn?=
 =?utf-8?B?ZFJ5ZDNXb3psSUkrRlV5VTRRdEZCZHNXQWs2NDg2WUpua3ROclB0d3doUU8z?=
 =?utf-8?B?a1hRWktYcVFQRVlHUkV4LzZjYTh2a3A5dE1iaUszVUdlM29qTExOcEltVW9M?=
 =?utf-8?B?eU5paEY0SWNSY2ZRd2tpU0I5aVFwS0xIUWhLWENDUG4wVExPamJkMitMUlFm?=
 =?utf-8?B?Y0kvZzNPSkJlTktuL3dCeHJ2Q3REd2cwSmt5WnpZb1laNGVMbFVaMUEvbDhC?=
 =?utf-8?B?cHRMRVdmeTZ0VGYwbEFuR0owREdpS2Z3YTNCaHkzeTFJUUlVb1FnTmNNSDUv?=
 =?utf-8?B?emVOSWE0V3Eyb3liWjRtVU9XbHBVUCtmMzhjQ0NMek53aXN6SzNNVElxVUNL?=
 =?utf-8?B?dC92UGxrNFMvMUtqdzJkUGFWeS8rK0YxTDhBMlkxRDc1b25NMURzSXAvOThl?=
 =?utf-8?B?TWZjNE9vZTZ0MWxwc2RXNjJUcDZiWlV1bWtYNTdqRklpUDJTejdpOEduNkhU?=
 =?utf-8?B?aWVIQlFaR1UxbjhwOGtacHNJTXlTeFp5R3dxNDdwT1laZUVYM3p4UXJ4Vlpw?=
 =?utf-8?B?bTh3Q1JCek0rY1JPSCtPRlc4dzZxSjRuNWhGcXVhN3JHeS91R2tzTjgvRGtO?=
 =?utf-8?B?dU13Y2JPa0pKbW5aL2VIR0RTa3ZpczQ0aDcyZWE4dm1kdlpRVDVHMG15OFg4?=
 =?utf-8?B?RndJdllDSFdFTFFRb2ZiRDFCQXZTRXZid2hwYThvdERsMElhZkxRQXF4Y05G?=
 =?utf-8?B?K3M2b3NQbnM1N2VoaXEvdDl5ZnUrUnN3b0VxZGg2QkR2WUV0a01OYWcwdG1u?=
 =?utf-8?B?b2xtVkFIbEJ6UU1LZVJ3LzhDVFlhSlRydDJCUDI5cnd0cExXWWJtZmpUZU4x?=
 =?utf-8?B?WWF5QktIUEdwbE5VN2dYT2N3akx6RFE3SFVLbGdLK0ZuV042eDZRZy9aWDJF?=
 =?utf-8?B?V1g1RlVYcGtDc2VWbFdyTHdsd2ZLZkQ2eVNmZUVYRXF5TUZIVnYxdXVJblVV?=
 =?utf-8?B?NmdBQ1NkMklZYTg0ZXUrQnRXMHMzR3Z6R3FtSXBlT296TkVGdW4xRytaZUdz?=
 =?utf-8?B?alpTSE5rNDBGQlYrWkpxWHJnNlkrY1M4YW9MekdRZFFzZklIMi9uSjBtWjJC?=
 =?utf-8?B?S1lmVzUwQ0luY1pPTmZoOXNmN2ZId1lDWnVkSjkxRjVEdWw0VnY1MVhsb1BX?=
 =?utf-8?B?Z3BEQUZhZk5nNGQza0tlVHJZKy9HdGsrcGZES0J3ZjJYUjNZMS9WZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a17fa8d2-3b9c-4197-12cb-08de4c9431aa
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 19:54:10.7231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBIMES+4gvnQntbKzHXHBO0p5atq04dcYPZmcJonQaEvhkgazZX3/gYFIu2SipghkA2P3BuAhE+WSsIFgKxftg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6242
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0F4AF8000B
X-Stat-Signature: zdjnhoex17eug35rxpf335bfifupufyp
X-HE-Tag: 1767642858-708274
X-HE-Meta: U2FsdGVkX1+lFpHdEDcEWEGHG8MmwCGz3Sor3JTSoU0Kszl6UzDHIyyqZ3PAQnBia7rvS0uXBZGH0bdhphVe+6PW3ONjWI4AC4TXgscAG4/mOucn+7Ph75sEhdKmnU+QemhqteXgN89UT76jQ97sdEP9f5BZxE+yDfINE0ZG67bSUipv3T6nRMJGyHW8ew4fw6rwx64JMNKK+KBzHse0BNS4Y0fXEbvR1BvVSXshQX54Blvks+6De2Dr+RSIwXWKO3pUk5fGqtIQPNEn6pvW708wY/2FAWYPQfRh9hxr5xdRUCjPK7IyEQhl+Il0Vu6Lf0Jl+8U3rKF0Ti6vcAtJToVOE2qHIVCY3RA11if2LAo0Bj0Jl8CtH6YGx76dFZSNqgP8ae3xvYwR053ufuCRZ7cbRvdtGX//31oU/vlVN88lX1GZMNIr2y8IHznBT6zSdZO/je0TZV3ADkuftO/82aXe26CCGlvsTYxYmYZAnY7qpRPSwFtW4/2RyIWxLspPDrXXujikyBNlPfTINSEtl81j+vqkVp/XiItlLLhgTBpCUjTMwW3mJZH/kOGO3aTNid3Z6TqGj6Cqx0wSGeKyPlu/vCcWl3FQ75xRaEzKx0rd0HL+EQDvwQZQ6C2qNTlsbjvHShb5wvQD4clJl8EpGMT8ZRYQfCV1AAvAdkbk8WbKqhz9DAmoffzv5syqPKN19o7NmnW2Je4266TDUNToV5fV/VpnDWAZRwyrp3M9qY+8iG2aZouU9BHp9HlUFCTjrvyGsprXZM2usoXXtgc08sSJGx7Vvq/GOdVjhauIcR8SKHVMApwrG1BwIMNFQ5aMKamfyZNYeqRthrUE1l+ysZQphsjfswGRc01LPdhlfYOHXBIEgawDZIF8/7IfFIFCxkoonxs0g7J0avnlPmsAZZLQ2Xt6iuZnZU0zAwm+RFVRzaqPLpw65Ag76u/R2zy8du75lIJsfMaW1YbNTgM
 RTfNbEhf
 FT48Dgx8h38fTkyip0GbSXiMzAEEauLFYPmKSf+JhOFojmF6Bm9nrAG0+qrTui/yxovmB+999xYfA719Q+OX/8oc+zrJI8TgohPiwAEpt7W1XK/BOQ//NPRrOpR++j32LW7t0Q5QEsXbfSEE8FGd0KuFxi8/ujumpegvhk4rkpKOhc88gikSERLRjzvkCETLiiTaEfRm4l79HCTcxj8rS0uoFTy6KKgcpuEFcXBtmpWCZphF61a4Jl4WisQBk4mxxjopgvGpGXtr1ow2mMWPnRdPqkUNoE+HfT1PZfY4Gj+xdVDK1iJigIw212/UO8+Ttvs0OFoTo8JOTkgiTIdJWB23fabc+l4Jgbkgsm1BPCf0Y2j5TBT1eNV+GQSxUM7xmr6mNqSfbr4KjYd5SOsmvOsUsn8q8fxmA8fJHcxIDb3NAJA8EfqIh62CtuS5W1LXL9I3SR73MP+D3WwcRqajH0HO0kdtxGzhGLrAWUMLfLPkPXAeK7W5QPxlMsIQ7fazHr12WDstHSEkrtHLfNRXhj98ya1wML6lKdjl7u2nbOskrauI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/2026 12:52 AM, Matthew Wilcox wrote:
> On Mon, Jan 05, 2026 at 10:48:00AM -0800, Calvin Owens wrote:
>> [   16.042275][   T58] RIP: 0010:hpage_collapse_scan_file (./include/linux/xarray.h:1441 mm/khugepaged.c:2042 mm/khugepaged.c:2389)
> 
> Perfect.  2389 is the call to collapse_file(), then 2042 is
> xas_lock_irq().  And this is exactly the kind of thing we want to be
> catching; we drop the lock, then reuse the xa_state.  In the meantime,
> the xa_node might have been replaced, and the xa_state now has a pointer
> to a dead node.  It *might* still be safe in this instance; I'll look
> at this carefully for a bit and decide how best to fix it.
> 
> 

Hi,

I'm able to reproduce this issue locally. 
I tested with xas_reset() before taking lock and this fixed the issue.

Thanks,
Shivank

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6c8c35d3e0c9..641523111830 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2039,6 +2039,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			try_to_unmap(folio,
 					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
 
+		xas_reset(&xas);
 		xas_lock_irq(&xas);
 
 		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);


