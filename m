Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F659C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279316B008C; Fri,  4 Sep 2026 11:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A596B00B0; Fri,  4 Sep 2026 11:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2356B00B1; Fri,  4 Sep 2026 11:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DEA736B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:17:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7918BA0110
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:17:23 +0000 (UTC)
X-FDA: 85176433566.02.5C6E396
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9084EC000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:17:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=owCqIpX9;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788535040;
	b=UtGy+KAILBvRvdgBcw4eLAdWb/xu1KUvh0i6Cd1ttHjUxBiGL6aokLCXEjq762yulGK27k
	MPmswWVyWXj63k8LnUl89ka0L2wAnxcW4ZdbbWeEdXpS1dImpysTKcQgQNtac9Xzcl/eMQ
	JcJf47MyzMoaUqPbj9TOi2kz8CCQ73w=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788535040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGEpUV7XhtyRprnoQt/Gsq2hn2UfxVPF6itMIVsZwU8=;
	b=QZ7aE3JmfO+Nj04VuJlHDD1vlIvQmWE1fovpvIz74/DHGTQkJFyAflTEHOTzpoCUicduce
	rDMkRem/mVu30PB3MnY3zI0eghI5qSnRrgXc0TK2abYjJUPJuMkxoMVUtVQoMtbg29rlcQ
	2+G9Ps683KhAajih+OSQSy5vNOAU5Gw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=owCqIpX9;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHcI6DlDKO9YtNzcEGyMCQP6qlZIo1Kf3G+nCrxMXnpvM/qcw6HcmS5ykRIk81Brrt1uqkIS3yF6hejys4uOw+JLLjnKv2jBSxcGhTUx3SHdixVOLIPOEaUCoGRT0SMoHlPVF4jWj4GJ3FA4GL43wa9HwQL44R0M1g7REZGSH9QNk/XpCfjQMHcDKRXKyiOVxu3JraWYt+BMvjWk9Ldn+BhoBm0a1r0fxKOLJk6KNeR6LY+kh8blAoYqoqKukst+50WBkZo9feVkQGjwBw8jVk4rH0Pa/UV58VrLQ3lzNcsUWyIcvmO11DGLlpGPP21JxSlsJm37iDCGbqklKd2xig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGEpUV7XhtyRprnoQt/Gsq2hn2UfxVPF6itMIVsZwU8=;
 b=XE6Ss5iToy1S+3ZDZPK3LRItRtG/wDP5VEFkIstu/6pXcj4EpdgcQ6lwav+XsnhXePeegUvIXZc5c/oYvhfh9dz1rV0U/pyzyErDe71R/g4VZ+d5xfkBdt3a0LyCQ+IzlC5VLxKg+F6kcNZ0iQEbnNSkSRIDvq460AcHMnTzfB6dr+8T+DDbZ6hy00H4XLMiXYDUMcSCkJJ2YxQqj+DMkaQZWi8AcHvJqkxWAZTJIQqvovjIV3GxoZapo/ZUquE8u8f/3YJNpTehyKslNCnRsX30NJ3KCHyNx3oLO22aBAopIi5Ftn+2krcofbQsTzX5DKEF8Xm9E8kFQrYZxP4Ryg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGEpUV7XhtyRprnoQt/Gsq2hn2UfxVPF6itMIVsZwU8=;
 b=owCqIpX9M4GkKkhdsQixYCyunHLsot0i6GAEuBJVrTRtVPYyI0wR9Dlv43Xbr1ExscsIZmp06HirVqlOxccCZ7pUjhCkZvlm5oIrqKgSkAHGRVRYsZfR3lrv6urLsrS7QjTjhpZM4ShhE/xDa3u/Mo23QdaP3HRdi6SgvptvKu83YymEJJ1QhdbE9msK3dOiZsbaIz0YFVi5H9hjpshWo1KvFd+wZqXruiQr8d8pIKnaYk4g7qAagw0Nifwcuvo7KKpzrOTpwewEALM2CfWiFq7BmNcVIp97bC+VSMyvCJUFd2XuEuE1xkZGi4Fj4MV7UFmUUrWHfjpcCcRwm9DmKA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8502.namprd12.prod.outlook.com (2603:10b6:8:15b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:17:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:17:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 11:17:10 -0400
Message-Id: <DL6MR5YHGMHH.1DB33JGTEUG8S@nvidia.com>
Cc: =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed" <yosry@kernel.org>,
 "Nhat Pham" <nphamcs@gmail.com>, "Chengming Zhou"
 <chengming.zhou@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Xunlei Pang" <xlpang@linux.alibaba.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Qinyun Tan" <qinyuntan@linux.alibaba.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/2] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
X-Mailer: aerc 0.22.0
References: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
 <20260904033503.4067283-2-qinyuntan@linux.alibaba.com>
In-Reply-To: <20260904033503.4067283-2-qinyuntan@linux.alibaba.com>
X-ClientProxiedBy: YQZPR01CA0037.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8502:EE_
X-MS-Office365-Filtering-Correlation-Id: 618a0a19-8437-4a18-f633-08df0a979844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|11063799006|10067099003|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ffwEx/T4Kt/HJrm89xa99KFnHWMWue3CPX9Ek+FshQ9uAS1D0aNV+rtZLe/oRK40zB8wtvC/fysGz+XdnyY2qANmbanjz3P07LSQVBESBqPBbYLKpUBgPBq0lJOixIRZ6AEF+kGtVMc+MHXfKXOKMlRMnQw+qm0OjNXFkYOGKQq/Mz+jzQ3vdHdG7lwVQnT/zWovFYd3iRTxo2oodsEFbQ7ar93iOfaXUOyD7RW5b9ZYrU5muTbA7ExH90RGrTc5VsDJwSAe77B69eL4sL/j13hFA1zsO7A7GT/zn5c3y0yyRIWdsydI0bl0BQPZ7a9gZEfoqeWbaQbb9LgueFun4bEB5BLooDoibNU1D2pMClmVvNd300gqGvbkIvQlKggGFIJKWQLueTbpQTtSJDN1rormOBv4H8Xd5NIvoNiZN5uejVlMwqwF61dMGdZrfNmLtlFMOXZzBxK7jfozGeYaOrFjEzoACmk4zVmZVqeTaIO2x6dNlPhNYk1zPqhP3szewzK+gkpvEaqExx1c8Ntlx5a1EbORf2jWTonjgu2uDFF9NT0UOG8AqOOzec7E1LQSoc0YqzJOOQ3F83CJ2ge8CgdiPuKRd1iWf78ERrrE2PI+ZmEUXEOXyh5QBNV/PgwoTsLtVHWqHJnDf/hcr50Nkxw6SpktLVCFg4MQWHpc9Pk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OSsyNGs2dVF3a1JwTXNmaCs1YlROUWdMK0JuNS9JcDgvWFB0dWt6Zzk2RmJU?=
 =?utf-8?B?TlhZb1dLQTk1Z1dkQkxESWQ5Yjh1dGp2aWkxK3VOZVgxT0poZ3FJUkhmNWdZ?=
 =?utf-8?B?OE14L1JpT3U5OTZodGMzSTFkM0JtQ0NxMXoxSGp2NW9QblQ2TGt3dWp4aWN4?=
 =?utf-8?B?dG1RekNyNnFGTGoybTVWaHh1SmIxa2tWVExDemNtOXo3K0hBSmdhUmhMRHpP?=
 =?utf-8?B?SzBPbFFOeWE0ZEFTYVJwNm5wWkVWYk02d3ZreElXMDVWUDU5eVpQNGtXM2VK?=
 =?utf-8?B?VG5abTN4YkpiT3JyVm9NSWZmTmIvRHNjTXFwbERlK2VDbWp5WXhRVTdCaTI4?=
 =?utf-8?B?RG45TEQ1Q0phbzljYlFvd3ZpWU5oQkR4U0dtM2xUMmlwMHRwU3VuRVRJVC9u?=
 =?utf-8?B?cGZ3SWoveEFFZWVzQTkyK2w1cm9FVDFEY1Evc2kwV1RsNUJ4ejd2TzlqMUFF?=
 =?utf-8?B?NUFueEwzNWF2WGZjL1lkYnZzK2R3b0dwL0Fzb0dVQkpPZ1lVMGxhSUdJZXUz?=
 =?utf-8?B?TXIzUmJibmRtQnNtYmdBbEtsczJzYTFpZE1KZ0x3dzk2K0NxT2o5aHJWdUJ3?=
 =?utf-8?B?M3JxOWtJb29ZbkFoK1JPNmh6NE1ja1ZVektZWjRBL1ZhLytjUDlyWXRseStO?=
 =?utf-8?B?c3dVZlN3ckt6M1pZWC8zb0pGUDZJcTVTSllrRk9PQ1ZNdXV1OEloZDhwZUky?=
 =?utf-8?B?aklxR094YXBndW1CemFPQnltNE9rc3FGZ2o3bEFTeXlkaW9DN1VsM1lGOGFY?=
 =?utf-8?B?THFhUm4rZUQ2TUhxNzhyZWNaOTFacUN4VWJzYzhUUE9NYk9kblAvV1JoWkli?=
 =?utf-8?B?aVB4ME5vM1lZTHZYVlhGdGdOUnJaNVZISEVUNmFvRG9rNnpOYURMbXlnUkNP?=
 =?utf-8?B?STRoUnFNSFBQTWZWMVNOZDRqN3d6YWo4bG0rdk1oV1VsUzUvNis2cGdRTWU1?=
 =?utf-8?B?MW80ak40OGUwdEl6ZW1CenE2NHIxT2w3dW9yQlBwRnRPWEM2bExySHY2K28w?=
 =?utf-8?B?SzlvOFA1K3FSSkxtM2tIbW0za1BBUUtld0JTWlZyM2lzY2syYVg1TFhMYXlK?=
 =?utf-8?B?dEQ1bjY1LzdmT3kvamNIeFltejhYcnZUMDV5Sm05cWpFanpWeGhHcnBHWUxG?=
 =?utf-8?B?SXFjRENTZUoxMVJXdEhSUHNxbnJqNVFVOU83UXQxS0Y0M0RJTFo0WjY5eU1q?=
 =?utf-8?B?TTdoN1BKUmlqaW50MUZqai9QOXh5VG56T3Jib09vZmQ4SmUwMHFlUzIxTElS?=
 =?utf-8?B?cnl0cW1mSXdhVUV5aHlJQVBjL1FyMVVGdkZUNmFsVlkwQ3VLZ3E4bElIMlVn?=
 =?utf-8?B?eXRHZ2lsZGM5S3EyeUoxMUFPM1ZFVzVIZThlbEZsK0JsUzBIQ1hJZS85aEVX?=
 =?utf-8?B?SzBhRitjcFVYVGxHdFplQUkrQmJKMzNHTWptcHZJZ3doOW5QVmRhRDF5UzNT?=
 =?utf-8?B?VWJaNmFKSFNsSWVwUnUyTmZxSWZiWXdROEE5S1dsUTlLV3NEV1ltREk0dzBY?=
 =?utf-8?B?UkVNME81ZE0rWUFpMlQvbnlKNlViVGh2TXl6ZjB4U2pBd1dSckRIZzRnOTZI?=
 =?utf-8?B?dWFxR2JMTEZMNHJpenc2cDJhc3VzbWtoRmhDL24vZCtLR3dLVEovVTdnTStW?=
 =?utf-8?B?clU1bDh2cXdlMDNEczBMeFN2ckt4bFd2eTdHeEFRWm9kcm9DeU82b1drdy9I?=
 =?utf-8?B?aVNNM0lIaXJGMVIrVi96b2FVWXJkcFo3VzlnZzFpWHVWOHlRQmlEaWw4UGlw?=
 =?utf-8?B?WmZZcGhVZGVXTTM3Z0p3bkNaYnJwS3MxbXk2Z1lPNjdwZHRoSnhlY29vRjEz?=
 =?utf-8?B?blVqOG1xcnh1YW1KaU41NFVIdHNhWC9NZGlTallONnhUVVlSZE9MeEl0UkRN?=
 =?utf-8?B?M1Z2bFdkcmJyaHRhYWxESjZOWU5JeGVKcjNVWExTT2pmTjZ2UnkyU1JycTVj?=
 =?utf-8?B?SXlZS3RicllVeDhpWnd1d1hSMC9meGgzNXZQU3Y5QXdtanYybjJHRXI3bTYz?=
 =?utf-8?B?UlNFTEpDVGQ0V09yaFU1S3dweE0wOGdpTjFic3NRY3VUc1ZyV2c4NEFlZWRO?=
 =?utf-8?B?Z0JoSHgrdEl4UFJDNW0rT3JoVk9PTnVFNlRadkkweDdaRlFUS0dZY1dhWng4?=
 =?utf-8?B?VzUzMW9OTDhQT2FRRXRlNjFoUWVTaWgwWlhyWUh2VjBBMzdaSEg0a1Z6NmR1?=
 =?utf-8?B?aTllbnZ3bmJ2QWlVUm0xRzVpdDRxTllKKzQ4enBodktvQ2NGTEZEdWY5clJI?=
 =?utf-8?B?MDlFcGg5dnBzQXEvM0krWkZuWkN4ektBeWZLVzBIUE1jSmxGNDBZZ085QXRx?=
 =?utf-8?Q?VOhpBcsY5XUTRQ0ed6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618a0a19-8437-4a18-f633-08df0a979844
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 15:17:12.1981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /D8BM/S2ALCnn3oKZnfgWR2DLLvKoLfBu0nM29MkW8JcAKmwzt5kHXpqcnMDX+F/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8502
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9084EC000E
X-Stat-Signature: dfys69ynx98h7quf3esykofquh5a4smo
X-HE-Tag: 1788535040-534222
X-HE-Meta: U2FsdGVkX18KMk5VdEuYTUn6fJRIFqvxgQbp25600QHN263uAbzkpzjqxJ6J6STavzmn0S6OKF8P7IfaCZljal1DuOU9I9sIfsheLC8/uXP0Bb2SU0T9yXalaLIxbJX0dgUt/G8oFSnMi2bJ1TtU0i+G6P4JrN2fuR3sZEPB5s+5E4hjZXXo/wscgPdCtpbdKWKcIKiFNHR6ycFBwi0QbwWGhFMjpsJPjn45tC+h+QbAz9dLSTzfqVXzZitAXHN2xRulHo8jcjkZS+FvglKDJS+gbjoLM2MUMWNeiOiCFwfHZTkzjjuGp1ohswK+CDAK/7sHyeKp/mV7jKT7h3+mphqI8Qx3FHaJHUV1FtZU4kqMCXGzmhnmBefR48Ke8KcwPWnbQfEf9JqMaGA2Ted8l8sfj478xzQRjP40Tv8vbBNJWbRseveFkzH4IyBOF46viek6iCdzr7uQ9ZQKBSm1yUu0/CM9gV9O5jmVC6OS28CUod6YmvEQnFpHYizN91BGmxNclQ+Cb9i0p4+Mwdcc8QoW3RKNW8xiH760uK4nAF4O03hpLN0ygWpj3t+tR7QlhpnEazL5hJ5Smo2RyBfWUp4FF+0RYb+fxGP0It46M4cf1fxk1+I137G3KjNqRuwjQ5pNgXC9pNqQzjtxFLwMlXcbqpiZ00kziVqrxjS36ZF1i9UEKuG4HKPE1tWVUEvcoswotaIpLtbMVjb5N+Q4bh7C1/eNC/g0Y7fP3GloUiLU6m7aI5KJCu5JNaly254PSczL+ZKguIDS1zsf/I+30niMFOjeTHP6Md7F2i/2+32Y+cDprrrJ+GllANWtbtmjixBPFha4ZhXvojjQb7OvNgMtSZ7DYTMXatPK0aLjn0bNCkvccFbUJSjUOkS4/Li0eYkvNt0KtDEkw52uV3ksY/BCwKXtn2K63zCfVrQt+hoIBTw7spB5MAJYeKejUfPksfUdi7JqXlgS1kUUP2S
 6ZGOE2qW
 QPwDl7z9IXwxtb8F3WlIG+rrDxs0NyeCRsYaDZpYyTmlwd6ok4U7JdE+Qe3kfLr8LmoHyehivNDFZgptEtldFRQz23b/7f/RUG4lvWh/U0w+YeI9mkbWAs4XMFsLVfCMexq6l9l2LCzhgDnfz5RnOZnUTkLZZopv0H1Ll4fmrXYIt4S9E8kT4X4oiKYw6rMHntoLD272oyDzYlYK/S4EvJzpKVXreh24sgP8JdCHqAePuzhqEY0aMheh/kl734m4ZeKrKRVhJWfB8DVzQ12j0ROoekKrk4vVmTs2RZfqI2TYaTtNbNaN+E/BHh2l3BvMeG7+VaEAKWal2VWrrDWnqQXdoNRvF0CN9oaK4XZG3FrBZg/kCcQ7Yu0MbxSyJeAMjlsePphZdittZA+TFUtUMUKpfNnIbQuNUp64zGd2GwiVhX2GKlZ2Uz6OybCHOE765UgBuAa1J1lZmqSPmzWGOdbzVWpU5mSZAQWPs7dxeHxmFwVpAuFspVbTBBEDoGnij0PDRE36wQtdHfpnXd+tsMQ6oj94h8XqV0UgFrjv48t5tQy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 3, 2026 at 11:35 PM EDT, Qinyun Tan wrote:
> On a system booted with cgroup.memory=3Dnokmem, the deferred split
> shrinker is quietly demoted to a non-memcg-aware one.  As a result,
> partially unmapped THPs are only split under global reclaim; memcg
> (limit-induced) reclaim never splits them, so a cgroup under memory
> pressure keeps its underused THPs intact.
>
> This is a regression from commit fafaeceb89a5 ("mm: switch deferred
> split shrinker to list_lru"), which re-registered the shrinker without
> SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
> 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
> precisely so it would keep working with kmem accounting disabled.
> Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
> nokmem and the shrinker loses its memcg awareness.
>
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
>
> Restore the flag.
>
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@lin=
ux.alibaba.com/
>
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
>  mm/huge_memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


