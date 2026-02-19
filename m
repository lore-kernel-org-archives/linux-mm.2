Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D1FE9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 16:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1461D6B0005; Thu, 19 Feb 2026 11:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA7B6B0089; Thu, 19 Feb 2026 11:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBA016B008A; Thu, 19 Feb 2026 11:53:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4C3B6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:53:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97E1B1A05D7
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:53:16 +0000 (UTC)
X-FDA: 84461801592.28.CE9EE8B
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011002.outbound.protection.outlook.com [40.93.194.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id DB5374000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:53:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uWodNIBA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771519994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uBAN99SWJIU9UghNLHeXT7FJCTY9F8E5rXkSigE9kk=;
	b=p8bUkdMPkhj3HLyapk5oBqMhe9u1YqiQ4fIZMCZMCLMw1tqs1XqDJGDpPF7zGNBWzS+7vT
	V8DWbttX77PaqD/5iYBPuYGKL49OALuRkh/AGOIumsrFuDdRoZgUEqLRcvNOHGKVRVmyVd
	Z6Y62yxAmj3vLChiAF2QgXjjjteC2ko=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771519994; a=rsa-sha256;
	cv=pass;
	b=YjD8eGJxeDzlkZYck0SmqYYGHjqMU+y88Hxv3l3ZxJvsTtXJCUTI22y7ATeo5N0REqPZ1k
	kYnKSliJF8ctpTkmyzgfH7kjMbT199Gc/tP/Mq6vPfu4tMJBRUkhK3+ZK3/kLmL17+g3Y9
	n/P9cGOqNptHZ27sJCQXFh7eFieCOdI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uWodNIBA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VFyNupvjLVi/RsHJkAiPXLYBphAm1pIOlelLWiZTsE+vJ3u5PYbAgUSMaG3h4jKv36TcPf1o4aGDJrGyZ/UPAuYMbnx7xeHqt0rhVJrzMj/c4fhPQ4yWq9rkFnuKJRLiGbRxZoQd3rZLYCdpVNCe1ZvP00PLBLfT4I67hfRgGob/jFtVLKmdN7oaj6Jj9JO/LzV1TM4spHqLjCWuAE+xzfy79+FtAkJSR5E1W05hP4D+HBlnkLw/9Dbi7+Je4n3wteUpDhmyJxwQryB7Kh3OYeo45RjYVCndg9+nWC0EA+d2iN4akQl6VWyqWN/MSG7ie2EzQR8WyKJh6fNg5S0vNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uBAN99SWJIU9UghNLHeXT7FJCTY9F8E5rXkSigE9kk=;
 b=AgeEkLZF5OOFuP2rVLDZOQomkNA3BxPhLhYmAlsDVENmXn4ig/go1zT0FGgNRqBGhFPHj1KmphhIdY3NaMaewRqe+rgTgGipNMtZBJyiscCSZ6MG0u04DfIliHgR+cmhYRH6BSd878JaHIL2z08dfkey1OgyaxkL9SE6giGI/9Wu2G05EBTm00UdI1mQoNN8tCs701/5Gh/3ia4wwQcWu5GkFQlv2FKpprwZmm8PKIhY4cNYBpVzXw8TSdqOmExubUji1AqImkrvZdcZJm6DSugc9CYC6L97ly86ZY7VsZt32E6DiYz9Oi8HvSaPtcqkZmvbt5PkvHCCRMnVmCWcnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uBAN99SWJIU9UghNLHeXT7FJCTY9F8E5rXkSigE9kk=;
 b=uWodNIBAdef2biEO2gjmUok4HSkPKKzX7LlvDJ5h4lcGQMBM0tujq+43wGMVMJuvVC4iOHf/f0f5KwONljwPckx2wRVC3J5x2d5zBFBK2WefMR0hCnFncCS8Bjo+mVp8VsJ58eLIgabpRaHfIb+ejo/VrOwsrSs/yqY4Yc9ToiYuZ1SmFT1V3Jn3BhCEYhNAjLf8xsfzUyCNMWAlw4+KsAo6Whtn+sy0vVltRNDKX4HdThPhurYl1vPGmG8GiLj9E+byrGksgt3mtjyGCH5ErV2p77QuR1JJ9aEGJhjLfpjWpbhIAaQlZ7ZTrhehKUdUAGvIpVOxMmr11HU2SLVJ2g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB9476.namprd12.prod.outlook.com (2603:10b6:8:250::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.15; Thu, 19 Feb 2026 16:53:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.015; Thu, 19 Feb 2026
 16:53:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, willy@infradead.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, riel@surriel.com, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lance Yang <lance.yang@linux.dev>, Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Date: Thu, 19 Feb 2026 11:52:57 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <A4DDD3A2-104A-42BD-B174-676012166BEC@nvidia.com>
In-Reply-To: <aZc-8dMBz1XCJI3n@cmpxchg.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
 <aZc-8dMBz1XCJI3n@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:a03:114::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB9476:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a18f0d-211d-4d6f-b68c-08de6fd758c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWp1K1p2c1M4R1JncTVyQzVsMWNvSzlteW5tQmpZNDlpeXJXclZZOWZtSFFS?=
 =?utf-8?B?dUdObUVMaVFLSmUzYWdWZit2OWorZ2dYWUxrNTdiT0UvSjBnRlIzblR1Z01B?=
 =?utf-8?B?eVNFQk9SUUZZK0ZSWTFDQWM5Skh4R0NFVWRJQ2psU3ZVNy9oT2o4R3VuT09s?=
 =?utf-8?B?L1E1MkRUMWI0bjFOd1F6UzArU3BKSjZwTVM4NW5RL0Y4RnZ3S2dhQlFGVlVS?=
 =?utf-8?B?UWN0cVBBZ2thNzVFbTF6UFd3eDBQcTMxSmhtdDlnTCtsYUhCTXp5dGRzcnJY?=
 =?utf-8?B?MWREWUhIOFhGczlvbXpTQ01CTFBpRlNjRG41NDI5ejM5RUVOcEZUN0krRHFE?=
 =?utf-8?B?Qm9QckZCSVJsU0tTVG5reDVRajJQZTlxcHNsY1VlV1ZmbDlYMkt4NUN2azZJ?=
 =?utf-8?B?bFFKREU0Z3N6TW5zZWk4K1lRREVnc0J4ODQrMEJ5RXlobml0L1JaNzZQTGJH?=
 =?utf-8?B?eGhVZWpyaGxCRHVZOE1yZkh2K0RRbHgyMmNIdHJIc3pUK2lDTk9oWXNrRTRl?=
 =?utf-8?B?S0xKWUEzR3U2QzkyMy9xOTQ1T1R6MXgyc3d0ckxTeTd4WnllMkJLQnVVMlBi?=
 =?utf-8?B?dTVlMWNZcmU4aWRzVzNUR2k2ZkFGR0VKN1c4akhvV21YQXZSY0JMT0h4aXBW?=
 =?utf-8?B?N1JXYlBxd0dTTnJ2cGMvV2Mya1VCNEVjOVNIY2thY1hTanV6N1pHR3poOGdB?=
 =?utf-8?B?UHJneWx1bkQ1cURpUVVzSVF3Kzc5QU5OaUpHd0xvL1l4VmdMaFFzR2RYcFhS?=
 =?utf-8?B?TXNsUmxMK3pRdzVyc3pUazJRRUFpbVBVcDh0WXJMQ0w5M29VU1Y5Y2t0b0h5?=
 =?utf-8?B?YXFWOVhhN0FjL2Z0R3RKUWJyT2xlSnNxNkFKYUpLWnY3UXBESGxBNlBXWEpm?=
 =?utf-8?B?bXh1NSttYzlDT0dId2IrZ3FCc0o0ZWhyditRaUxZTVlONkJWVGwzbWxpUlhZ?=
 =?utf-8?B?WHRuVElkZWYrQlpwSWxXM0FzTERsR1JNWW53YkY4K0s5bkhJdHR0MEEybmZj?=
 =?utf-8?B?WFhsR3dSaFBUb1VMODR1eXBnbWZVN2hlK3Y1VlhUWUtPUDJVa0k0Zy91VWw3?=
 =?utf-8?B?ZW1iTFU3RlBxb0ltbitCZ0pIM3czd3ZhMVJwR2ZwNVlteUR4ZGJpQlUwVjFY?=
 =?utf-8?B?UGNxeUIxM0ZIa2g0WUhWd09ReXlvc2JkMmhyc0d5NDV0TU5vdW92MUZDU1JC?=
 =?utf-8?B?c3BrRnJrV2d5QVNuclBKK3ZCVmcwL0tnOTVNbUQ2VERBTFA4bEx3UDZOSVY3?=
 =?utf-8?B?VmVLT2ZFT1dhQk5XM0RUQ2ljbHFtRFdNSzRsUFZXUlhJVmFPWUZsTDFZenJp?=
 =?utf-8?B?WlF4d29SdTNHZk80MHFmZ214VzJnaTUwKzdOVmlySnl5ZEl2dTBSK2FmU3Fw?=
 =?utf-8?B?WTgycnBLSWRUSHl5Z3VlMjcvV2FtTngzL0o5NGxSZHNrMXZSbTRqam5oVEE0?=
 =?utf-8?B?T2VuNit6bUM4RmpRVXQ2NFlmZDZIWXl4bjhnT2ZwUEdWbHJYYnkvYWt5YUZD?=
 =?utf-8?B?NVJIZFlCejZtVGF1QU9aZ1lQbk9aQmZ4S1RZTE1UZWw3RWgwdHYxS1dJNWcz?=
 =?utf-8?B?TFBVRll5bC9uWUt5dnhPNm9GUFlJZkNtMnZKMzFnMk1tZ1hoa0hXOE5VazFH?=
 =?utf-8?B?eDJUQ0RzeXVHNCtMbzl5aWhQemhwTE5UVE9raTdwcm9MS0E4TzIvS1hCTzRr?=
 =?utf-8?B?b2RWN2ZCSkUyTkpvYktqUTNnZTdHNlpsMSsvSVRJUUQ4Q2JXMERCV2F1THls?=
 =?utf-8?B?VmIxcGx5QWNBcEh6WUtvcHpHTVl0SDUzUmtVMmVrWU5WcnduWXJjbS8ydjZk?=
 =?utf-8?B?aVFZWUZrU0ZYUHVKdGhBS3luVE9OMDlLcFM1REFoR3dzV3o2ZnFkZU83OHdU?=
 =?utf-8?B?YWFINjJ1M3JHSTVXMVlrRzVzNzNJbXFrbUpJb1IxQzRjeWNZdHl4Si9OZ0oz?=
 =?utf-8?B?TytKc3RLVHNzOFVjMU9Fb0FJSkhqSU1zcitpS2FGUXhUeUM4STROdkpZaHpN?=
 =?utf-8?B?M2dkeWczNTVyRXNETUVXOTlpNjJ6ZFVaQkV4NC9UdVhJVFZxUE5nVHNmek5T?=
 =?utf-8?B?eHdoZ0FuSFk3Y21GVWc2UHJPME5YMStyeHdaaldrQ1FzM2Z4YlJybFo1VXBt?=
 =?utf-8?Q?irmc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDhhdDJUTmlLL3lTQlJDOWNBR3ZEdGZJVEJNQktRQTA0WXhHU3JhZ0R0MGNR?=
 =?utf-8?B?QjhOY2NKVmJtd1hyUlFjSHkzMi85VEEySWd1eWs1Yld6Sk9lS2s1bkNiQWJM?=
 =?utf-8?B?UVNtQ1lPQW1pc1ZCSDJvVWsxb2ViK3hPcUJqWG9ZeTBFblBZMlgwZG81d2ZK?=
 =?utf-8?B?MUN2WnAyQWRnZzJsL0FoTWMxSXlTYVhaVlZEQ2dMdmpISHBnUCtBcExxeXdp?=
 =?utf-8?B?TTd1YlV3a2NqUHRaV1NZMVlGc3BVK05wY1prUUpOYVFYSTdRdWJuNFREcDJn?=
 =?utf-8?B?K0FFaE5vTzh0K0t2SFdLQ0NHV2Nzd1NRWW5GYWdSUDF3TDJrQno4cVN1d2xT?=
 =?utf-8?B?RWVBU0JoZlFiT3FLczF6a29YK0trYVFOdkY3YnpSQTNsWS8ra1U1Ky9wbStm?=
 =?utf-8?B?bThHbjRuaEwyWDB1NktmQThNZGZuY243MmxGUWJ1Y2FhN1M2WEtaeFg1N1Vs?=
 =?utf-8?B?ZEtLWEpDOW1wSy9TRExCRktmbUpWdkpSZGJoSmtOSVBSVXJxYTN2aE0rRGZG?=
 =?utf-8?B?MTFlcE9BZkM3RmtKOTZ1aFphTUw3L2tuZjlyRXdML3lKR2xMcnowWE04TE5t?=
 =?utf-8?B?c21rYU5rT3lsRkZQeXZ2emI5TG5ad2tvM3JrY0hHTjFUWkpUL01Kejd5YUph?=
 =?utf-8?B?aTRJbUdNM09ReWJUWUlhc0lNS056U1VlelRJdGFQTWhmRVJlekF3MjViUTVE?=
 =?utf-8?B?dUhrYytCempjOXZpSENJMXI4Y2s5VEYrUTBEZm43QzZoNSt4WWpJSFZJSFpN?=
 =?utf-8?B?RHRFQ2lVVlltOFRCSHB1Q0lNNC94UEY0bE1RQ1ZQUExmcEN1MjUyOU5DWXJR?=
 =?utf-8?B?ZzBuRjJIQnVaNmJjZlprdVFkemV6K3VoUStPYWU3TUJUVEs5cWlRQ0t3Zm94?=
 =?utf-8?B?WlZyY21aY1FaalJ3bXBpREpaVkZ2Q05pUmdCemJnZWFWY0VLOHNmbTBoTzZp?=
 =?utf-8?B?aWp1RFk1U0ZhUW8rSERuV1h6Yjh1NnBhK3ROQzFkQXdFTVJVOEZBQnJkMUo2?=
 =?utf-8?B?WjhrR2lRbm5Bemp6Z3IwZkpteFJ1UkdMMko4N1NhOTJxc2hHWDRmNTloZTdp?=
 =?utf-8?B?TGQwbTVxMVZMSm1GN3RrWWE2aTlGNy9yc2gwSTFDclgxTDc5dmlPRW1aSHpj?=
 =?utf-8?B?QUFYY2NDVXJ3SzFhWWVKdGVKR3dBaGJWdVRWdUUxUWRDb3dKQXg4Mk5ibWto?=
 =?utf-8?B?eWx4elQzUVpBbTZaUUF5VHVZOHJpZFcycXA2a3FVTVZvUlZ0YnZXTDZmQlBX?=
 =?utf-8?B?aEpEbFArOERQaEdZUUFmN2hPWTBFeWVCZmJOYytJOHZqL0hvNjNNK3ZpbGNK?=
 =?utf-8?B?VTFoU0dlZjEvK1ljajBUY1lBU3VEZlEvNC9WbWdIZk16VlR0M05COGFvTTUx?=
 =?utf-8?B?QWVESW9HQWJtTkZYSzY3cDF1YUYrYVRIQXJNWmxIcEh2ZU9YUVpjdGlaRS9X?=
 =?utf-8?B?OHJsaTJTbm0ydFBMK0ZmNkZHUGg0VmFDK1FJZFZMSDhrTjhIVHJ6WVJLdEgr?=
 =?utf-8?B?Q1BIQ2M3a0tXOXJzSEsyUUhLQzBBbVVsakFCS3hkd05YUVJXeG1iT2lRNmNi?=
 =?utf-8?B?U2JnNnBOWVpyeFpRRHJTaTFBU1VBejdjU2FCOG5TNC9CQkxBUE1FWWZYZGxG?=
 =?utf-8?B?QitnQ1BSNlhwbFVicW9QNWdQWHRMaDNvRzhubXdOQmozTFlNQ3d5Z0s4a3k4?=
 =?utf-8?B?SW9zZHVIVUFIYUJTL2FMdFlEamo5WFJnaVRFNUVtcFdDemhOTkMxU1ZaSm9R?=
 =?utf-8?B?RkZSRWRKSjR3ckFSVWthbGpnT1JTSW5Sa0F2aFQ4Y3IyajYwZ1lRZWVlaXdl?=
 =?utf-8?B?YS80VTBrNENoQ3dtYjdsWmpwdW5NcWtCdjRtc1Z6WVhndUl5RWNUaXZ2WHdl?=
 =?utf-8?B?ZEk2MTdYU1pGdzJMZ3RUbDJBZXpyQ3dzQ0RyR2FKVmNmamdPYjlTa2JBeFZm?=
 =?utf-8?B?cVNkSVdHcTlnRGJYOU9GZHN6MjNrSTVhV3B0M0VoeWhVNldQaEptWVRIOW5B?=
 =?utf-8?B?NE82UXJ4RHlCMjNNSFdHbGJRbzh1T0M5QkF1Q2dUSkMreHl3S21KTXNHOHEx?=
 =?utf-8?B?UGxPeTVGRVJ6aFlzdC9pT2xzSjJnb2o5M3laS0xTR3NlbUl2bXhwdWhTNEdJ?=
 =?utf-8?B?bVNGQUFJUW1wQ3ZvM0dEUlBXTldXOFR5OEJjSHk4ZlZicVE3VEl3NVdaTnJr?=
 =?utf-8?B?THprMERGWWhoa3NYT3lYaGh4LzI3S0hFYkE4RU5zV2dIZnJDcmZ0SGRNVjRv?=
 =?utf-8?B?WEppbnRtbHRTTzNKci9wMlZKVXdYa1o3am1DdmNnQWtyZVdiVlpqZ0FIck53?=
 =?utf-8?Q?1ytLz1UySrEWBHF0w1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a18f0d-211d-4d6f-b68c-08de6fd758c5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 16:53:03.2468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34K9ABottIhTyltwDtO/HkpAgXirIqgQyY1V9ClXsQru7d0eGkcPCN2oUnZLkUqs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9476
X-Rspamd-Server: rspam09
X-Stat-Signature: 7c9587dgb4y6z4bd4ayiy8wem6rwxj13
X-Rspamd-Queue-Id: DB5374000A
X-Rspam-User: 
X-HE-Tag: 1771519993-718796
X-HE-Meta: U2FsdGVkX1/7vJgzFfMRj9LePMVnhu/LEaTWWAIOEi+RppBO6eUvtQic0arEKtwgHLgH5kbfXNGpPj0vaSkQsOVw3867qOprNZlcATRT2GJRcggXI6AbSUBfj4iWkZ2xbCU542QXUslcRiizme9OfSI09zUSY/Crvcis8W57uBgGqITTTjp704n0NVNM1bBE8zJKFY0O4bDaRXwXsXfLTezhdk85b2SSCs5q8aQIY4ff6icp7GRfiqw8SetcHs1nu4veBvqcd5z3jlMV/B5iV5FUNopIDnZygceoRnvZP9uBoqN4aQSYd91Rjc5onQLiS05P1oyGUEamsEoAp3MT8OiTWkJMJu67Vx8l0BSDP03lH1o+U5rS3FxLFKDJAW33b5oboavN7ZGHsXVxB8EufebjKTFWYXFwuvyfKz6XIjgT5BRQKUDgoOvy7uKxgdVik12EhPu+Sp6UJjYS6KCzS1NcSdyCbtq3AMcecirHqQ+2W5cu/YLCDhnyfNiPYuEL7i1sJyOXedgIjIRFMVCrbZ4D5mXYw1GVQc8WUQFHtwDaI4lY00s4sa6+V/s4I36J4u4KHqjWjiBhYAVfYw7deyNUpHGEU/fjMhcatxMGBLIl9qyo50yNsS+uzZ3d+dWyyvKJt4pIZG8K3x6ajlsjmiv1CEOzBKB07qcc6OV3GeRMBAMu/hzdAb2PmleRBSfnSfPpUTPTouVDLUl3y1vZbel+YK3crguJl4qeDXr4z6rNdLvlBPX1CjCBNlE9Jlb95Gl5sDxBHroM4dgdD/S1GJrz2/SLSzuttyNpDQ/x0IkRDsW1kLC8qJ/e7isaePU6Vm81E4ADOjRGsgCM62E95CELGEgCOil2VHiPOhKyMH3C5ky49lMvCJnN9bylRnu/b8VIPuyz9LD3zBYKgoN3Pr1Ch2BHWQlK4pKfuxHVZzKk8X81EVn/+4or6AZ/hDD4PMrS7DxL52SYERrfC/z
 zy1KFA1f
 8batjPTErA0ZCzFHWAMETp1lDQHw3EgIHCtWh0koHe9/A1xFz+5/CVqOU9C8bINKgvKFSbvJ7Hw3Rm3XKvfHgX2EQhDBftIETJi/qukNi3AEDzDw6DyyM0eB7YyH0fIwaTWcyUqflMR6lR1nOD5DnGdMdZRnnZ1Jl3BMrJ/pUznCXqhddP8IYfRl9btABSQ22vMmMraxmz1HTEQrpgmZqrcCbTHHWIdt1tMJKqrUOOIHjRHKtyqnKGye+wDYH87pS8WBMFXV5s82+fCe1/r5rb07/z1ndSwLY1MzYRZKgjlbYWu+ZZnMEnWWi72/I+JnEJIGjH0qMseahydC3M6kb+wVWcNxSY9LGk/x3J/Jj0uv2rNe6x9GNA9+Br4tA4MAMn7xRbtM+GLg12p0zn8mMGfhf0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Feb 2026, at 11:48, Johannes Weiner wrote:

> On Thu, Feb 19, 2026 at 05:00:19PM +0100, David Hildenbrand (Arm) wrote:
>>
>>>
>>> I see 1G THPs being opportunistically used ideally at the start of the application
>>> or by the allocator (jemalloc/tcmalloc) when there is plenty of free memory
>>> available and a greater chance of getting 1G THPs.
>>>
>>> Splitting strategy
>>> ==================
>>>
>>> When PUD THP must be break -- for COW after fork, partial munmap, mprotect on
>>> a subregion, or reclaim -- it splits directly from PUD to PTE level, converting
>>> 1 PUD entry into 262,144 PTE entries. The ideal solution would be to split to
>>> PMDs and only the necessary PMDs to PTEs. This is something that would hopefully
>>> be possible with Davids proposal [3].
>>
>> There once was this proposal where we would, instead of splitting a THP,
>> migrate all memory away instead. That means, instead of splitting the 1
>> GiB THP, you would instead return it to the page allocator where
>> somebody else could use it.
>
> With TLB coalescing, there is benefit in preserving contiguity. If you
> lop off the last 4k of a 2M-backed range, a split still gives you 511
> contiguously mapped pfns that can be coalesced.

Which CPU are you referring to? AMD’s PTE coalescing works up to 32KB
and ARM’s contig PTE supports larger sizes. BTW, do we have PMD level
ARM contiguous bit support?

>
> It would be unfortunate to lose that for pure virtual memory splits,
> while there is no demand or no shortage of huge pages. But it might be
> possible to do this lazily, e.g. when somebody has trouble getting a
> larger page, scan the deferred split lists for candidates to migrate.


Best Regards,
Yan, Zi

