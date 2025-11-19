Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2848CF2588
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3136B000A; Wed, 19 Nov 2025 02:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8941E6B000E; Wed, 19 Nov 2025 02:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B9C6B0012; Wed, 19 Nov 2025 02:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 637E86B000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:01:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE86F88268
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:01:11 +0000 (UTC)
X-FDA: 84126459942.24.59FE114
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0C2E240016
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:01:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wEbi2g2i;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.0 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763535669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svG2IZ9T3C5lXTpUdUl1iDMvz5BD639NBdBSKXjrmdM=;
	b=fgjThLoo60KwKHfcjZQEbhEynn4LUxcB7PgYxmaKeRvJzLU4WVRxffB2iuzHQjb1LXVuF5
	OzQ0EQnoLxCLtBwqwtPAMlXdH2VBVqCpT/dcl0aPgSupCwGi/sYS+Ea9pI6A3l7pX3vN3Y
	RNvfMBs0ULTtHpch+wFvIXkLRgBVooo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763535669; a=rsa-sha256;
	cv=pass;
	b=N7ZVt8giLKwI5K3EXt08fNXMxK8xpPKv7j8e8Ld2YGH1gSoCNw96KNHRaMfKZuikLcyH46
	yuZ7JLGnwQ8ZfgpMtUR5idn3W56YzV3J0c5am89hcRRJA2PiMk6YZgetkUEHmsylReC3wl
	L6YUJkBS7gRiZLCS5KmiLRL6EWQdqDQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wEbi2g2i;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.0 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=srQjH6NwTOuNnAB51OnZDmOXp8p2SjqBpEzXH1fqn3h3bqB8oMsJgYaTAYTZt+Pn3N49Ffjx72/ss3aw9EGLtKsOrTDBDLirVeugIHizo5JgKXw1vN0VbtKmgiPaz6tHEEDERw1jrVE0S3d7T6Xk9yEpjBnutW6MiaDTDJSoev8S37ZiZPWbb5L+4B6tvUsygGGoDYBd1OKXJGPL1q5pTs7I9CfH/7nN9hCZt3x4+tlFI20iJrhOrGIreaEBa/u5RjEIdXyCLsvLAMRuzTK0L+zUegbv1mvuQumvqbLJHgJhP+UoWW3SMbbELh10WzA5WQme4dpoNVfVMyeLOlyeqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svG2IZ9T3C5lXTpUdUl1iDMvz5BD639NBdBSKXjrmdM=;
 b=WCkgOn3ukqqqQsVzYbdo3edpg2VT4S1YuZDk2sQmNvI9CXkBEhx70hmnAW29/LqkX8d2xWgeimxj/WpqLtTGYoN0zoP+I8993WbSFwRhkdA7lalJJhqzCm7L+j9B+JJuKBLLMGz6t64DMFBqgaBv7y4jawbnbZ7iha5kq5y1Wu8qlSkFaEYA99/WtsXizuQ1FUQ0TpHYzF3jT+VtrIq3EaHgrh+vBDYDQFWIET4G0kBOfatd5GCnrrWahH9Zp7Cei6H1grdSxR2Kmr1PFugBTsa3M2WHmJbtZQNZ7FpIcosDw1F3ykW/0kPTeiMQxSM6YYgx1xN0GUL49ik4TVIRLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svG2IZ9T3C5lXTpUdUl1iDMvz5BD639NBdBSKXjrmdM=;
 b=wEbi2g2i0Xjq8s9CKAOUVmfA2Hdcv7LatEJE3B9km/wQHipUpVKY5mRfKiUzUjZdbQvp2eP9osMNPRB1GDyWBpD/NhJVjtSJsU+vQQ5cw26D3kIdPGgpov9p+SkBbSYRxvbyDZO4OkYE7fuxwoydNmo+/IUN2geK9WDDAsKSovE=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 07:01:05 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 07:01:05 +0000
Message-ID: <c558cbfa-3539-40de-b0cf-4c6ae160aacb@amd.com>
Date: Wed, 19 Nov 2025 12:30:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/khugepaged: return EAGAIN for transient dirty
 pages in MADV_COLLAPSE
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251110113254.77822-1-shivankg@amd.com>
 <20251110113254.77822-3-shivankg@amd.com>
 <4ab54ae0-2607-443d-8698-788d8e951bdd@arm.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <4ab54ae0-2607-443d-8698-788d8e951bdd@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0031.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26f::14) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|SA0PR12MB4352:EE_
X-MS-Office365-Filtering-Correlation-Id: a217075a-6e34-4704-75aa-08de27396842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlM0RElVTFVoUUlWd0pyOXN5Z0dXY2JabmVqdk9TSUlPUDNJSlNta2FCWFZT?=
 =?utf-8?B?UGJta3Z4dXIySzAvMjNJaVNYOFB1TzYxY0xMZVlJL0tIYnN3dkdDTUhaMTFk?=
 =?utf-8?B?czVLQm5sdTFLQUpUYm5mTmZtOGkvcERBc09zdW1GRkVTaG1neTlMQ0lCRUoy?=
 =?utf-8?B?Q0pHUkxTWm95VnM1Qk1yVWVNYU1hK2hGNWxKZ0pBTUI5VEg1d2lBS1VqYzNj?=
 =?utf-8?B?cVd0cnNiK3dtNExNd2k1eG1ZRGtKTVlsUnFaOXpnajF6ei9HS2tBQzNiZDRM?=
 =?utf-8?B?YjdIam1VdlJpRmZLb05JUXV3VTE1MWlqNkRCV3ZPWXBSQjZOVExqeUFhVVhr?=
 =?utf-8?B?Z3ExTzZiSE9IS3lTUkxmdWdWUmJWL0U5STR0NW5RY09LQmxxNk5icldhbUF5?=
 =?utf-8?B?U3BnM2xSS2JDcU9jQVlsbHYvZTlGd09JOUc5WjlRTWFaYjBJbTVNSm42dFBF?=
 =?utf-8?B?VERRc2UzYnlYRTIrdmpWZ0FWdFlWbitjN0tpNU9aZXp3bFpTa3paeUpBbVBZ?=
 =?utf-8?B?L0luaFUvUFpaTmEySTA4UkVlckJGN0ZIc3hIZHdjdFVpYmIyNUh0UmlqR3Rm?=
 =?utf-8?B?QVRSQ0VnaHFoU2FVODNQMGFMQkgzRFJJQVhSa0IwaUkwam45TDNqNEJ3djJm?=
 =?utf-8?B?NVczR1Vsc01uOG9YQzkvMVcxN2NVb09SRzEwSWJsRUl3Uk9ocXhub25mRTFD?=
 =?utf-8?B?Y09JVFBUeWxFbUtzMWNtM0RtNXg3VWtJSldyYllTZkY0VzhzeCsxR0JISVhP?=
 =?utf-8?B?VTJCbWQrWnpnMFZxYndNRTlBa09WUWlRYjc5M0RBY0Q2TnZaMWgvSVJXektM?=
 =?utf-8?B?R1lnMUdQY3U3bUh1VldKNStBbUIyOC9VQzZTUWNKcXpMRGdLNERZVnR5NzB5?=
 =?utf-8?B?SDZwcHUzam5LQUxsV2hFMlg4NzlFUTMrbjBxTkhUS3FUYThHcUJlbUxtNklQ?=
 =?utf-8?B?RENyKzFaRWFramVlMDBIZThQUm9RTzNUdEhLUDF5WHhLenNySGpUMGxUcEQ3?=
 =?utf-8?B?c0kraUNsY21CUXRzK0dTNGdmV0tGaS9ZZVZuRzV1dWJIVFRNMm52NVUvRWx4?=
 =?utf-8?B?MFhZaWVLQ0xwcURtOEZKcWpjTHV2V2MyQTBwNUVES0JFZUprQ2t6RUtDbnFh?=
 =?utf-8?B?cVBabkdFRkQyRjJQWG9yNUl3ZXBLdm5HeTgvVXdnd2ZORTFkK1pydGtJanEv?=
 =?utf-8?B?ZVlLV3dUWVVpSVozWndGRGN3UlBLV3ZVQWNwcWFkZVgxTXlBbUNSUG9JdlY0?=
 =?utf-8?B?V05TZGFYWm4wSmYyVjBKMGJldDNITVJaTUNiRm93WDZKcW96Vy9SSmMxSXNB?=
 =?utf-8?B?MWlKa1BvWG9rUXdaY3RrTTVvdVpqTU5JUjhlNm5PaEVJaUtJSkhhVTROdVVm?=
 =?utf-8?B?bTBZQWRmOUVxY0R5YzF4MGZWR0JwcW5VY25RYi9ycnNQMk1sWmhPTjdIUDBZ?=
 =?utf-8?B?djNiUGJBQ0wxVWJyVVFIRFVZQW4rWUdhUHd0OVE2dUc4enlNc242Y3R3VmZw?=
 =?utf-8?B?d2xTMTV2Y24vVXE0ZDVrcmhMenFHQTQyc0JsTGJJWXdMN3Rha3l1dE03aUFy?=
 =?utf-8?B?S3ByaTZHWWduSzY3MEI0TllBd2wrSld0Q0pqek9LYndlN2xQcXBKM2IwNlVV?=
 =?utf-8?B?bHdldFp6TGRnZjY0T1VZUjA1UXczY0k5NnN4TXFGTi83ZzBTczNSM1gwZS8x?=
 =?utf-8?B?ZVg1cU54djZGWVpRb1h3eFVJcUJTKzhSSXRxbkZzSnl3QkZDbVNkc1Q1Wkwx?=
 =?utf-8?B?M0pQaVhROUdkMDVaYUtXaHhydTY2V242M2RKSlc4YU42dmV0S3JvckQ4VFNp?=
 =?utf-8?B?SW8zZlppZFU2bkhMK21BL2hiQnpzd3NmYUEyVHlWQXdDQTExcVlML01mbWZj?=
 =?utf-8?B?czg0RTFyLytDU2IzZnRGVUZHVjNoRXlIcHc5MG5PNTB0cWJNT0RyQzNyVEMx?=
 =?utf-8?Q?JV9LdMgw2lNowiBkwZgMVhgEeRijojmG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czRXcUl1NVNBT2hqR3hkVHc0QTdVK2Fpc1Zkd055WXo1QW9KTFNhY1dHa0c1?=
 =?utf-8?B?bkJqR1IzR1FScjlKclEzQmo4NFhvWlQ4QW0zR0RxdFVxcjVSelY3RUFXRUdR?=
 =?utf-8?B?aHNwdFMvelJZakg1d285djliZmVEY1lPZmVTTXZFVHNEUks3bVNVYWM1Mlo1?=
 =?utf-8?B?TEo5V0x5di9Qb0dzWlIxdEZQRGREWDlBNnpjOFRMTFRTQkZITGh4aFlvR1hV?=
 =?utf-8?B?NnlJaWI5T3UzTVJpU3RFYVQwQ3RLRVVic3NLMU9MVExFVlJ1ald5enpUdGtz?=
 =?utf-8?B?cWpFRDVLZ2dwRmNJS2YzUldLd0RJa3dvLzc3QXhHM2VtQVpNdG1mMmtsU2F3?=
 =?utf-8?B?UHFjKzVuUW41U1YzQnJFZkFyOGhoQ2JQQkNMcjJ3R0lvWWVMNnRyVzZudlVT?=
 =?utf-8?B?Uk1mVXczZStZSGk4VW9BNG5FYTJiY2RTT0l0cklkbDFoYkUzaE1sOXNtZDBo?=
 =?utf-8?B?dk1kQk1MQWNqNVYwRVdTdjFVRmdVZncyM0xBTWxlMytGb1loNHJrNnRCWW9i?=
 =?utf-8?B?VmdzeXhsR1VlT1oySGI1NW5wN1VyMGIrK2tSdUdKWFZUTThkWW9YeEh3UmEw?=
 =?utf-8?B?OHRlNitMdURvdFJBTldNc3VuNk85OHVLRjdxRFNseUpCaHRTUzFMSDdFL05B?=
 =?utf-8?B?czRvdFA0cmtSUFIrZHhBRUJta0xqK1NHb3BSYjY2aFE3cnRJVkJTWCs1UDdu?=
 =?utf-8?B?ZXFnQnh1YVdpaktZKzFTcDZWZnQ0M1RjaDB3a1VQajNzV2lCQTRHSXZWWGlN?=
 =?utf-8?B?REVmYjV4SVVlSmM2Z0xuQmVCd3JXSWhPMVY2Si8xOStuVlZLRWVZZXh3aXc0?=
 =?utf-8?B?bFh5WTFpdmNIajg3REVHTWZESHZhQU1aNEdqTEd0dVpVeEp4eU9Ma3Rrb1FT?=
 =?utf-8?B?S3Y1VzN6ejAzbWkwdzQ1TVF1TW1MKzVKVTFVSGV6clV5cFd5S2pSaHc2ajNN?=
 =?utf-8?B?MFlOcXFWZ2JXaFUyMHFqeUo1U0tObVJya0VmTXNYRll2b3dWK1RuZ05oZTZU?=
 =?utf-8?B?VXhTS3U4dHA0Mi9ENjRZRTB4VnBUaWJINEtvczFPT0Y3MTFzNG5GWlg1d0cv?=
 =?utf-8?B?TURlSTZUVFdzQ2EvMkZVSEpoSzArZllBdS9zbldrYmpTcHlaZHVLeXl2NWhV?=
 =?utf-8?B?bldrdlYyRktrcVR0a1QyTzkraUVWajNxMDhwckR2dktkbjYrYVVMMWNUdFVX?=
 =?utf-8?B?TFhEcXRGUkNjRTBwUDRaeFAzQ05UTjVOWE5NZmVFNCsxdHkyYmxmMTV0L2pn?=
 =?utf-8?B?TXZ4U2RCN1RJbDdiZWlYOUhWSnNKVEdMRjhKUnE5QVVYb3FSZXpBNkhObGtp?=
 =?utf-8?B?YXU5dytKaDBCSUd6U29zZ25oeDQ3NkxKUG03N2U3VURqYVRqOVN3KzNpeEtp?=
 =?utf-8?B?R1pPRkN1Mm5VTkRkcGNLaE02b0xjNE5peG1yWUhxRTF0Vk1OYzZBK3A5WDBJ?=
 =?utf-8?B?aDNXcXZpNmx4aWtiWXRRc29oNWJCdDQ1Qis4WXAwMlUxSllCVjFhQmVzcUJh?=
 =?utf-8?B?d0RWck5nWVJ3WnZYSE80UjR5WkxJdWV4WlI3L0RIb24wVVVFRVlwVVFybldD?=
 =?utf-8?B?Y3BIelZXcTlvZXdIcTRtdFBldkFFMElUV3NxOWl0OVgveWowOEpwak14MEJL?=
 =?utf-8?B?RzVBWlNPS1UzSTRMMDlmUGVLcy8ybVJXS3NoOXM2SE9tU05jdU1CTnZ4WExo?=
 =?utf-8?B?ZnprOGJYV1B2UEZUWTJtdm4yQysxZjVjYUp6QjdqOEl0blhBVDk2UGQwckZz?=
 =?utf-8?B?bllpd2w2SWdyMVNNbTVlckw3YU5sZjZ3NktuZVdna29LbiswcWs2YWZvSkc1?=
 =?utf-8?B?SVo5dUIzV3pFNmk1dlJNTEF1dzlJdHhqdUc4aGMzNE5DUUhxbGJRY2VkUm91?=
 =?utf-8?B?MTVyZXhwNTkwbk14STROSzJ4ZDZpY2d6emNRdFN2WUQ0L2kya2JMdXZZQjlL?=
 =?utf-8?B?SDMrb0p3MVkyWlIxckJWVXk4eStjR0xtTXB3Y2htdm8wQmxHR3NOanhacFVr?=
 =?utf-8?B?NGJ1NlRpRmtNRnF4akZmNi9WTzBYc09zRmNnWVV5Mi9aK2JoNm5FbWZLSFpo?=
 =?utf-8?B?L2ZHNmRaM1FaUzJ3Q0hBTVFUbXVsdkFHcHVYdk9sYTMxdVVjTjRJZG5aUUZB?=
 =?utf-8?Q?Twn35dF2hc+ZqVFEBHXn6VbkX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a217075a-6e34-4704-75aa-08de27396842
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 07:01:05.2720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvK2x2Y6It9nXhyUyX4ln/JwbUbxCvEy9wilpexUtWQHhjUzk3OFtDLOOwMfX2ZMGY5NnVtZxu+++RHUKBhDUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
X-Stat-Signature: et6z1b773n3ifume8ms5iyxxyzbr7u4t
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C2E240016
X-Rspamd-Server: rspam01
X-HE-Tag: 1763535668-737616
X-HE-Meta: U2FsdGVkX18uiQejT8cXX4rhKONnw+gnpjrdn1iHDcMwgwk5+FvkyMDca6/T1iqd+QFDDKlTgbD1RSBCB10t1QHgT/R5RxG1lgdJKDnb1gsRmjzVcBQIJEbYOs71663FFQwDyvNVU5q81kT1nJQVgRB/46ibFkMBFCA5lkD/3V48isZbdhN5F2vZPOCLAJderz62PA2Yivvh8QZtPGyM7wrOv0atco6WIVx1TGbNiiyTWCrX2f5COW/4rxDqq1iTt4cWygnrmRAysWvfyydD8iWMfg/fCAfbc9JRUrcXwjCQKZbnSZF0h1swYiB5lt4I8e9wOdl5yXjcb15fOeM7XNNKED4DchA8mMj9dgef81zEyCuLYHNjiLXQpB57x/FOSk3qSbjGUzhagE8Rl8HYeQ7sA5PbIYLVRvGdT6UIH1r1lnwVjvlXbIFwoaECnXdetfa1OkJ2rCva9+v+Zrk9+46qA8zAFtHjOyB0bYInIFM3H/8cbk3mPRx1pRrr7G3fCekKIfjzGUxIE3VgSOnaIhz8Abf5vA9RUQlQPnWhSSV24NgGWtdWB1S6+dw2b7MLF6JMtPLyrGt2QIQU+4HBq7aehx/uO5r2drUhgt2154jaLiTIh2+POOZVpMbgg7RdgMEbvu/3vjs/DaFTjQadDnqsKWz70zSPn2lRN2petBfDHGKzOfMITc6LOkRupB8+xd8fgVVo7/sVWQhKiSvZrrrKrNXWErUOY7uT+KRogkn6Sh0ccheevC29JTogfpM6zdnI0xAs5E6JRoOU5be0ZN5AnxibbI4HGL2jAH5hlRvMcKIWMZSodZJ+/hqJ3juVq5ErQbEYb58VGwiyLx0dp+IJk8/4wA7F0MhYBA0DK5EAXB/V5OjR5d4lVY8MDo441iKIwC13DxQsJm2mFjHG1y4iibvIadLnQYR5sZGr1b9jqmIpakrBzYyupQu3nyLaoAJbxsuqlYwJSS7td3Z
 PfXwKCSC
 XA5NROQy3tTDtg6PKGwt7wsoV3J0o+eH6OTCJkwoMcYbt8pjnfUwbmb1YtCZS/VTSU81UN9CtNTAp6nAgogUSCEGc6iiYQ2SKm+w84WD3OUVKFWmc8mE9rLGISWDFT6gA7WsTOUwA9Y3R3WhEXuOQxLr4W38mNUU6LBWbUu+WjSky8x5yXdC7538amljOfhMALoNrzj1XzK1XHMAEUKNBiOmblNBcCmmRyiGOS3r59ShlUrnzyFfA79XzI97RlMhz01DUn8rhXrz/e6Y6dl+KemlszSSm8xxozQapzX9SpQ0W4acCHkhNMWa5Gg8oiaAdXNU7VIkIpKTsoBW1875xmr6C8tkYCWlMWMg0NDhCWy2IangDDMUoUR8OwupG5NdrmJCr02K+cb/MOONyTnp0ALPWHJDSno8rNdhBSwtjn3wML6kZ2oqs2iFGgZSULBp958hhoDgvIxJLxIMffN1yZgjIXCQmyqMPwcm0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/2025 7:16 PM, Dev Jain wrote:
> 
> On 10/11/25 5:02 pm, Shivank Garg wrote:
>> When MADV_COLLAPSE encounters dirty file-backed pages, it currently
>> returns -EINVAL, this is misleading as EINVAL suggests invalid arguments,
>> whereas dirty pages are a transient condition that may resolve on retry.
>>
>> Introduce SCAN_PAGE_DIRTY and map it to -EAGAIN. For khugepaged, this
>> is harmless as it will revisit the range after async writeback completes.
> 
> Taking a cursory look at enum scan_result, I am sure there are other error
> codes as well which redirect to -EINVAL when they actually should to something
> else...
> 
>>

>> @@ -1967,7 +1968,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>>                    */
>>                   xas_unlock_irq(&xas);
>>                   filemap_flush(mapping);
>> -                result = SCAN_FAIL;
>> +                result = SCAN_PAGE_DIRTY;
>>                   goto xa_unlocked;
>>               } else if (folio_test_writeback(folio)) {
>>                   xas_unlock_irq(&xas);
> 
> Now that you are at it, it would make sense to redirect this folio_test_writeback()
> branch also to -EAGAIN, and call the common error code SCAN_PAGE_UNDER_WRITEBACK.
>

Good point about the folio_test_writeback() case.
I think we can use a single error code "SCAN_PAGE_NOT_CLEAN" to cover both dirty and writeback states.

Thanks,
Shivank

