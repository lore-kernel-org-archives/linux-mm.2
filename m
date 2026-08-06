Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B22BEC55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B7F6B007B; Wed,  5 Aug 2026 21:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED71D6B0088; Wed,  5 Aug 2026 21:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC61E6B008A; Wed,  5 Aug 2026 21:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDC86B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:00:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70708404DD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:00:29 +0000 (UTC)
X-FDA: 85069038978.10.6AB9D5D
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012044.outbound.protection.outlook.com [40.93.195.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 907571C0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:00:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Kc+g5KpW;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/auAtIb2LQma91X6m6M/7Q2/FIClsknvJAZM+dJs11c=;
	b=6hvm5aK3EivUdxKj7r4GHFL1/XaBAGx+maYQxHr1oaj7b6cMjouXHQjnczvoiyKdZTnucj
	yccMDcIiAiMYTjYY1TWKjVlNpvza0DTJQw8eBYElyWG1TUM5ht1+/bBfyf9BXzbfAAIe7Z
	G1ZlnNY5LcZEpiFLYAGCLq4/vRRq8eE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785978026;
	b=cnhT4z3X2hkPSaOcacoLGgW/Qs9Y+Pcbt5zhhTxpXj7bdLGjlwM0S/ih+bLvGqK/nqyvvn
	Onol8PK7smT6qP3mx5uYenqsXHIkpqF1xzh/1R501VgjnMu3z9j8AJSmooHzDc4a8qIXmx
	/2msnbGm3y5k3NIhQrjub1FWi0FId7U=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Kc+g5KpW;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SweQGUcUskt3zkbs34sSKqRNTDuO9ld6J2azg03GJaPQCB9a5aNa2eHDkES+/FhaD9bPprlLS0k0ZOua+xESNBrAUtrcZ2VKc5arO67MWFkJkwGkjA4Ykvt5D42Lq27CbucN90CLuZ57DbksZ30xVxxTI/L1dtfZkJuEUeMQ/zz/0Y3JEg3DU+k0VCo/wqtScEwczMgvzPn3Xq1+akxrHMdZ7dMDLFwpXYyL22KGYuJKhl4+oiXYJ/tCvySYL8S7xCXSdmwwKIPFdMg4eF9mrJAsIPGu6xwrhfDJnagEXYhThZXFWe1GMaX9imSpWchO6FWSFG2oYD8sH8I2FBigYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/auAtIb2LQma91X6m6M/7Q2/FIClsknvJAZM+dJs11c=;
 b=fYBsFz3f568n7+wc4Dymq6MjA1Uba25uQ7MCV/BJz2yuakvKg/9UWb2NFQpUAOiuSW/mHMExdmJz7YtqSNpHmWTFbbqutxY4YFjQ9YjmAig++AP4oOsSXzPHjfUe1dbGM8VkDcFDVLIBmptXgHcmUuhMBbw6mkDUtrazQ3b2BTQy3w9DA5Vy2erN5E6wHNWefs3YJ+LTLQghCq4sMfdHQ3YU/ChQ+93lgJ/SzoUcrMX83CDdLTp2pDO3da4/ZJS5SSpnmQRPo5rxafXqOFKvmmZs2VoyygznSnO74+eMdJfa345Vn062Ht/cllUpmugvz5kunxAw5ZkKjBYnP6oAhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/auAtIb2LQma91X6m6M/7Q2/FIClsknvJAZM+dJs11c=;
 b=Kc+g5KpWXWS/SHVEJf9EXm/CmeIEVJ2/TPXYU1vUDBRxcJWD9+1WMrOl0ZmvxCFYxBqUdDC/ZkponMUefuuPh0MAnE8XnfZeZtJl8AreuR5oT6vwinKXR/vJTekonnqOn3gt2S763vviIn/3f2EXWm8227reWHEPQkzxHY0iNQSclGv5HLLCzuJ5OCRGtVOpx0FTWGRHeV2XmPsAhcndMxVEus2Loc1uJeGxiTRFByDqf/efE7V2OZsh44+lyBkQdyegErCoDpuDHTEOYd8OkHr+UV2jJ6tvCQFkDKkNcADuzJTPi2yW+5RWMS7+lYD0dbhkuCd4N1RanQ47/HLH3w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7561.namprd12.prod.outlook.com (2603:10b6:930:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 01:00:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 01:00:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Aug 2026 21:00:18 -0400
Message-Id: <DKHGDB7OHCAY.2IS7K0DRGBEZC@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm: debug_page_alloc: fix NULL buf in
 debug_guardpage_minorder_setup
Cc: "Ye Liu" <liuye@kylinos.cn>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260806004556.2633049-1-ye.liu@linux.dev>
In-Reply-To: <20260806004556.2633049-1-ye.liu@linux.dev>
X-ClientProxiedBy: BLAP220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7561:EE_
X-MS-Office365-Filtering-Correlation-Id: 38c21841-8498-4e2a-66f2-08def3561602
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	POo5c1ahhQY/Hgmo9sPkNPmBR8CECyV0gBv9LhWOAaeXkDzy854xNmAE8EoHgqfwd0t0u4H/pl3nKeo1EelshStOFR4kSatiTrPFy/11B9BE0dBye+auujpKq+X3YaJowCQFwJDb07A0V9kzozp0ybR6Dal+ShKilTLHy/bv/VzkHYJ9CN4RViuaqKx6mWBCWlPGmbpacp7xqO4At/uFCfb8f3MFZLQ8gZcI08UcqVQJdep0Pnv47w8xNY8lU8d8TX9c+rOfvR91blkhK7VTSYGlgb+QLAndCIsilELKbkgSUzZiSHF4ZGpLfpdutDLlsJKX7Il9qy7h4ffG8xYFo+jeZxbODv0xe6w6nFMeyOkbI6IuHq4JHc6jjSp0wg4jeiTeHvOYEsL9SYIF+zXM6ljQ6qo5nQtCjDUsRekEuyQqCFaZyXeIUVjzhrEByWQGYqH6VAGm59qUGTBvwUoHL381FK9ED4XLt5oH15UuBycJCIZnQ575YRRhir7ltQW6fiBVIoCK80BxXBk5n4CPVFrG1oNL6gy5raJm8oy4LNNukX1Wd6hYufOAfyW5qGEtOB+aqMWsp78gBtCNKwaYZ936ss1SkNITjAXUg0cgomSeoOA7OPXFIR+NLNQAKZpGcJ/YzVOQ1KXIdUy2KrACM6kTvVRKfeedm3x/qgYB8WY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L25BTTVHSmdnWG9wcVF3QWZDQ3FQVDdrQ3YzazZzZGFjYTVKdHR4VjhaRkta?=
 =?utf-8?B?RW5idHNVb1ByaFZxN2FMNU5DNnF3K2pXb2pqd211ZVkvZ3k4MEplcjhDd1Yx?=
 =?utf-8?B?c1hVS01XQUh0Q1VnZDc5emtibU5PMmV5VThUdExacys3MDk2MWg4Wk5GcXNV?=
 =?utf-8?B?UERKMnBlWGpnWDRDVGdZVjExcFpjYnVZMHA2b1BTam5NNEppYnh3MENpNFNE?=
 =?utf-8?B?TkhmZHZrYmhLM0pCaWJ1ckJvTTZCTTliNzFuQndTSGtWUTdWRTMxcGZmZitY?=
 =?utf-8?B?MW5pTkRqSm94MUcvaEVuRi9aSk9xQ2JWSGdLdkVrVjBTemxkTUJMSnhxa1Qw?=
 =?utf-8?B?by9HTzhGNXMranBHZ3FTK0F6UTRoQnlkVmI4NnNxTDE3WlY2TE1ES1g5OVQ0?=
 =?utf-8?B?NXEwbWg5NVRua0IwNkFsNlVUK3ZnR0FabHp1eUtqR3hUVkNubWtNRHRESThi?=
 =?utf-8?B?Yyt0dldid0NKY1M1cWhEeWZpMCtlek1mbmxWOXdaYXhZZTJLSk9BVzJMZFJJ?=
 =?utf-8?B?Y3pnSWhDSDFtSGI5cG5Ja2J2Q1hhNzllaUNVUFFNTHJ6dkVkVjB6K0k5dTRD?=
 =?utf-8?B?a3ZvV0NVa3JQWSs2M0ZnbHMwR0RVN3JiSmxZTFJ3aWJ0NkMyZTVhL2ZhVDhz?=
 =?utf-8?B?aHlPVmZoZFA1ME5pZTBySmZqVk1iK2xJSFdSL1FXUllnYnNXUm9xUkhVaWti?=
 =?utf-8?B?TDhGVWhwNENybVFxdFJoeWhGcCtLck85ZWxiemMvNzhlZlY0VThXWkFsbWdT?=
 =?utf-8?B?U3B3YnNLRGpKTnpScEFodmt6RUlqdnhmQjZtbGcvMkszK0xuZ0RoWTNXYk11?=
 =?utf-8?B?Sm1JNlptRzU1SHM5eE9vRUJUVGxXTEs3UFJlLzdTd1pMRFNkYkFBaUNaamZB?=
 =?utf-8?B?K3Z3ZUhXM2NVT0p1QWZXSDY4SXNIR3MxeWtJaEl0Q1JQdGRkRWRpRDloRExY?=
 =?utf-8?B?QUVsaitKNkhNNkVWQkNKZlVoa2V3Qk1nZ3dJYS9yMVpNdlpUZjd5NTZBRW82?=
 =?utf-8?B?eXFVaTNhVU9CUHIrVDhKNVhxZFlPaUZSczR6MGRINWtWd0NoVElDSldYZHNC?=
 =?utf-8?B?KytXMnc2SGRYR2s5UDY0a1ZvcEgwRHo1d3FvNjk0NmdUVUp2dzJIYmpiaVI2?=
 =?utf-8?B?ZU50c3lGOStvZGV0ekh2elRRblFCUnNiMWdYdzlqd1hjczNGSjJyWUltWkRJ?=
 =?utf-8?B?ZFVTRkNOVmpjRWRKeXpZV09Od2tsajVwa2xoeE9CcjBhaUJ3SmlBakVOeFF2?=
 =?utf-8?B?RHdrNjJEeFNWZ3JLcUcxTXdvb2hjZlR4VDVVUkZVNVQ3U3hmaE5rdkZYa09L?=
 =?utf-8?B?R2NRK2dkTFYrc3N4U2k5VHhtZjNuNkV0bkJDKysxL2l5U1d2VnhXM3NncTRX?=
 =?utf-8?B?T05kSGtkYWdGSkptZzVCYnZtajNYZk5JVFFlS3FneWJIaDN5bnordHFEYkp4?=
 =?utf-8?B?S3FVTWNMM3llcEd3VzhqN3FFZC9aOXFMRno2UnJYcUpBaEFxR1JUVDU5Y0Z1?=
 =?utf-8?B?OURjVTk3Mk5zQjJxKyt3dXh3Smx3TlVMODZLVytZblYwUUhOY0FCUVNGSjR3?=
 =?utf-8?B?WVFaTkJrRVVZcE1jblFYck1UNmpvNVY3ek9ZbllXOGU4MDBSTytoYUE0Tlp4?=
 =?utf-8?B?Wm90NlBhZndBMzc3VEVsSUQrMlNaT0JrUk4ydlM4WXZYdkxBOUxGeHJ6NmNV?=
 =?utf-8?B?R1EvSWtJbitoOThFeXc3aVgyb1lXVnk2ekNNMlg2bzVQVnlWZktLcTIvYlNF?=
 =?utf-8?B?TmFYWElMOU5ycWVPZ3ZYdmVtWERFSlVGYUlkemlyVVV6SHZ4cVdrMFJWZG43?=
 =?utf-8?B?QnJIN25xZEpvTitXSEZmSjBvVjRqRytRSVF3V29YUUh2U0lLRU1kQ00yUHpj?=
 =?utf-8?B?dmdWOWdPdHpZNFBVZHZoYy9kY1d6T2I1QkhjZzZ6WnJtcHp1Rmw3cWtHYmNP?=
 =?utf-8?B?eDFyOUR2bTFQMDgycTl2OVNoUGllaldydG9CekY4em9CU1lyRm1tcGR4UTl1?=
 =?utf-8?B?azhGNk5tbGxnU3MyeXlMbnAxS2dHUEJ4SWFySWRSdGhGcGhKZDFISmlGRGdE?=
 =?utf-8?B?dHl0SjJaSE8wL3RsR3BJUkF6MjlTem8wbjYwWWZ3aTRuNVFsYlczVHNaUkh4?=
 =?utf-8?B?TEVXZnh3bkpaVjl4VEtaVVl1Qk9PNkVMRGJCR0NNK1dueHRZSS9FMHQybkdP?=
 =?utf-8?B?NU82alhQWTlNbXhZZ205VHF3K1hOaXZJRG96eHJKbkxDanlFeDZHbWpXTHh1?=
 =?utf-8?B?bzJjSk1ZTzB6OEdmUEhzUVJDbTN2MjB2Q0VoWHZYc3krbEhWaVVTejdESnZV?=
 =?utf-8?Q?DPvwVTO8Fkqp+XIJM1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c21841-8498-4e2a-66f2-08def3561602
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 01:00:19.6991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HkA4YclrBFVUtWHx8Y8k5NFxq2cAdIm+m9HXLzwdiF++A0iTy6wontnsH1LTJgfW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7561
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 907571C0003
X-Stat-Signature: bejy3w44bxq6hxcjzpot9rtzkyk41xe7
X-HE-Tag: 1785978026-694966
X-HE-Meta: U2FsdGVkX194aZRJ7MD4chnIlUg2SmNqQgSCb1u7AB4F6L+UwVZY2oNzmfgkQ2fJltdzMaGMQ9cYSVjow3AiY83ztgpOVygb76Isk7ZYbPa6KUMDpSru5GGgj+k/+ifIvzZprRgQV0fixVimdQcvnYVshCYZhZxVQutGZCKJPw99Dijbw7M9Si/DZpPqTFFdz0nImIwIXlYxcfnmDWbjyYbJBolv1g26UNSrwe0TpbJwSzA7yet9sF4jZpsK5Zyc757BNZlYDs/fQHqItkxkvu4Xd3+hvynobiJ2Bty6c4cmX65kHvjn8kh3nvhfCeuki7wnhJHdA0qenc+jJPuEy+f1d4hVW6ShRp6IkEAxkCGFs7WaP3N/tsKO+6kshelZzjGIyv1UJNZVDtLXTTM4ejbvds4RMw2Kry88GKsgmF9JtoJnF1lgy5P131isGcZF9Dg+tV+lsUAALNXvnbwemDsDrjhnhx8W59+gHIxnl6UqqTV8SLAYpgekJU4MYUPODf8qGR9CyO2u4bYjNnmYgVeCV2/DHWaq8hoXJknjBYxCENSRmjMhUjlj0PsCorT6OQUuuV4oxPfTEBqHhFGybWXOsLtMe3AyFCw5blxeNjlaPtEyXyKqX6GPNl12GJBrSZYwv9C3XV2c5DUySFXwfm9xrVW9JY1875na8/B2dsQvMlVDrNMjyVydeU3UsFuD1BbYWJz8sP2x5G+kgTObKYU2d4+u6uBWiK4REaXy85ISKJp35UVUrVRTkkMpETDQ6k6ollgcq/SbH+Ck/EJw63J06LcWWK16KzD3ShSkx2L3ZcIP96BHAs0tAYt1jfhoET2T/Z8QIc5w3kZ4i+zd6KQy2f9WikCSMoOrlRjLE9xzqY1VtbZwofxin0x9Xv+Naz41PBffURvLhaqe1XReTN4LuJISm+QurfMWlEu1IHkEZecqKlkWDeYaG2f15uiIcgtocUspTso3jRw3I6H
 QQCjaBsc
 GcedXNJaGhIczbqeckNJj/UXLZYtUe6JMunHceMMlJlC1R0IsTYCd24hbJvk+ucGwiikR6AmgkmjXsb8r1BN4ptoryFLvVTMxcnaXMxwN3V1F5E/Krfq6Y/NvSV4SC5FniOB+MBzzGGljy7pXjmRGiNKCgswM/D4N7jP0qhHxeI0JkSTEyL0yyn6yQnaahhpGhMe8dA9gBdDS2We/onrAMUDEEDTQiLyPrq07JYMWCWSYhOqvijD+NWnIsDaBqfmgxVNX88JbaJopX/TGVlm3rsksyXqdZtdu6Lqu3KNFNq9lfr+yB8Ja41eUW9cwsXanBfo+J4FajGB3kuMluw6di7ImLqhVp6I4yq+1lkHn6BvAHqy7Foduln+qGmY+PccgTtwrRi58ib66J89Gf8dfNbDEvxUcscB/DyXjPGoOaxr/P/P0lpWuxABRRqUNoCX0i+07
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 5, 2026 at 8:45 PM EDT, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> If the kernel command line includes "debug_guardpage_minorder" without
> an equals sign (i.e., no value is provided), the early parameter
> parser passes a NULL buf pointer to the setup function.
>
> kstrtouint() does not perform a NULL check on its input and calls
> directly into kstrtoull() which dereferences s[0] unconditionally,
> leading to a NULL pointer dereference and early boot crash.
>
> Additionally, the error path's pr_err("%s", buf) would also crash with
> a NULL format argument.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/debug_page_alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


