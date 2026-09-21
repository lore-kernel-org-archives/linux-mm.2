Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F58BC982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DFEC6B00A6; Sun, 20 Sep 2026 22:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590E96B00B3; Sun, 20 Sep 2026 22:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B5A6B00F7; Sun, 20 Sep 2026 22:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE456B00A6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:53:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85785A5ECF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:53:20 +0000 (UTC)
X-FDA: 85236248160.28.095072B
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013052.outbound.protection.outlook.com [40.107.201.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id BDF0B40003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:53:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dJIO3xkA;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789959197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywqAf135TLii3vpD5jzjfSfn55+KWxrpydN6qnniizk=;
	b=ReTNIka6Sbhpt2Y/qI+CCJIlKye+4t38hY1CEezIwbLEAWkbci+aPauNSKmNsqw7X04W1+
	a1/HTxASza2ONEj+wfJK/IpE1BoqRiXWgT+Jqa2+QbnzGgWPM/LqHf6aqSdGGXsNd5m6Pt
	I+Ey8GRWrsL/DsIqtWm6d1a50PFDSHA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789959197;
	b=1HzyJ8zz1pVJf1JvjPVb1/6Qo8BLRCOD9btVHXSxpyC2m14BuBzCyTKxGQMpWQSWP5gifA
	pJlQqOwl4qhpEbPiPv2K46Kr9Qh1aMMbZDyixzgNUkR5/0rk+b+ADXQo+uyyjkVYNwcfqT
	zFYdYjf+knZreOSpbodBvOywEfjEnN8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dJIO3xkA;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YNtOCVaB5FGyvfLy4yEy+Y1lKsfSPj/I2T8jZSNW6MK+f5fdMKXl6P/Ydx89RhQByGJWa8N6NEegZ6jYt8ftxY/l7a5cOGKUcBiu6bR3FUPwsyAWAWxQbEs/CuKZ9OQ0Vf9CTxdV89TO7xSW2Oc7B/uzUyEyoJg5rJyEI1bsvcYYW04kUe2ddb44k0Tr48nM41jg//vm6ZwWFN4z6F/Lket5cOEPAI0LOL+FBpS6JaB1KOMcq8hxeHH6g7E7WJgek+Ysd/rLy1XVXS951hEGYyqIrpvY0TCQenj3M9Yj9IDbGFRWBuU+uLzJVTGWX6JCu9zWI6GDC/wz6KJouv+VKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywqAf135TLii3vpD5jzjfSfn55+KWxrpydN6qnniizk=;
 b=zNhGpOpGgrCN20xLqbDakz67lwVGh6nEe3YD1tUyt8G0nDKX/GJ1x+cvMIN/axNwphDRnPPR/UOIqfCbULWsYKrD4KA6wZqN7eXnkAy/iTTWc6GoBV669i/F0WgCtfrN8iZWv0oJdRbytFVY6wHa12+MbqveHHdfyn3dIVuy7uMxqg6y/7442UUtw+oa+VfVA3DO3VwclMJJwhrEnwMtJqVOHes7SK4XG1wubZbVcFxsAQrOPKMUt1gngKI9xSunej6UEJ4+iwtC0cmDCyASHsAEUKrRyPrKxABLAoJ4ozcB6pW+SiiGL2B/hbGG4Ut8FNZmt8CfLKWVSUymGXN9VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywqAf135TLii3vpD5jzjfSfn55+KWxrpydN6qnniizk=;
 b=dJIO3xkAIBKGp6a8V2pc5HKItodlBT2HH6e9WB2MV2HpM5ePqlLptL/19x/WTN3Mc/n6wA1mIpi6KIuyuamjtYrwP+ff49Ylqk1NSLNpkhJ/4WrLiuwk7azReIbiErc90TCpBx1NP6MvWWt5WZpBcFXiKxCyBy2iD2gGbT6W7Mg4lKo/jtXKRGzUpAmuLsudvX4/KbO72XqMAtSRTO9LUmRPL73yPi6rIE/8lpX17QJXv6yUl812Snz4UB3GN7itxk1lJtHUovLdJRmFM+1zYc7TXRVZz9CAcY7ZNS9Z65Ag0WgtKphMCeNVrflOOFTVbFKh24F7YdxHz9vTU7R9xw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA3PR12MB880420.namprd12.prod.outlook.com (2603:10b6:208:628::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:53:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:53:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Sep 2026 22:53:13 -0400
Message-Id: <DLKNKTQHSA6H.6XC9WV37LSVR@nvidia.com>
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist()
 out of build_zonelists()
Cc: <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
 <liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>
To: "Gregory Price" <gourry@gourry.net>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
In-Reply-To: <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
X-ClientProxiedBy: IA4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA3PR12MB880420:EE_
X-MS-Office365-Filtering-Correlation-Id: 64f14e7d-af6a-450b-e4d4-08df178b7b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	c+qbDSRjkcNtjA/3IjrWeJuGb3U2TU5k6Xgo8ypyLLvb1w3zzB2v8IY4MPgJmqLuQr+RwSvU3W7tb1mANDvVO9IWMOVp3TxG+vYWVAtiBLTSj11v7tmSW3+IM6Qqsrkrb/YDgJSbz4rEjE6rGKdWZO4tW8xkvOa47eBYlF2Bl6GfVBugitxFaiXpTrmglklYvZ00lv+Pp8vwnKq2iK+a5o32h4uEgVP4AzEyVmqTWHmPabwcmsE1s8M0EROm0Tw84Xw9q6aJq/rVuGHQHaTbPrKpb6t4WxpSSQ4s9cZgprl8vdcHPA46xkUU/xPE7xElkAFongjTvjeVzDkDyO/EZ0TLYzoUrKeaxIa+L5rVLtS7sa5w2EreVz1ZjvXHYG8N1TYH9vrbPHzXBP3+9cZzOj3+Xg0KHsfCcZMAdZsm1lroRJ91Oe3aSby7lsWg1gpP82TH9J2yxt0BiqhiQq5lzRqDlfJJ7XG99Ubb32lsoM6JQu/8f/Vlh3K5RCfUZATFcGRj+ho2XUeMvCV1J4IdeV0SUrI8cLgz7s1VEdWERtjmLew8pRycGXnfndtfJORQUfyaiBkXLHpGM2XQPWIisSh4v7AJ33NOYJPGHcMuVeFksVn7dmoRFWddsCJj+215OsKNkvoCMhYxd8EOI5+Rsg64mCz/hipMc6FPPXHUYBw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHR2aEY3TTNOUkJUanAwanJ2VE9IM2ZZa0h6TS92WnhEd0UydEh4cFhHZC81?=
 =?utf-8?B?c0FJaXo5a3V4M25aaklCaUo2a1c4dUhIWXp6VXRyS2VJa29vWHdIUVVyc3hT?=
 =?utf-8?B?TmdYYlV3d3JrRHdKWUpoeG5zYm54WEE4NG1yQlhZRU5JQkxreGhjbkFYVGpL?=
 =?utf-8?B?L1NIR3Z5K29SRzRveUJOT1dCWUZXc1Y3b0RLRDVCNGhoazBvUWcvOWJML0lk?=
 =?utf-8?B?VVVtdEF4QzRJbG9BVTBFSUY4VVpwdVJFcDVSRklIQWlVTzdWUHJ2L1hsU21M?=
 =?utf-8?B?ZUI5OHdiTktHbUVsZ2FZcWEydVJ5NkdZZm85a05SRVVFYmpQdFNXZXNEOGkv?=
 =?utf-8?B?cjNpWXpwQ0lVZXo2L0FSNXpUMmJZTHBhVlNZMmZDTGxmdThuZXJ6UEp2TmI4?=
 =?utf-8?B?VzM3QktnSEVrTnE4Mm9CY00wVThqU0srZTlTdklEYnF5WnlDamJtby9ZYVBj?=
 =?utf-8?B?S3UvK3hqbVRmK1NlNGE0a05NL3BITCtoL2hOcU5jMTBseE9sV3puaXpCS2RP?=
 =?utf-8?B?cFV1dEJCWCszTUk2amVST2tlMnZsM2VuN2haNUk5dCt6ZWJFaHRzaFFFVVgr?=
 =?utf-8?B?cE5XMFhuSEFzdVhoY1luOGJ0cHMwOEhBeFFva1dTaklTbjV4dDI0dWg4UmNL?=
 =?utf-8?B?YkNGdVNLc1kzNFljb2Nzc285RlBYSzRZeDkzU2NBVjlXYWhaMld3ZmNxSGZO?=
 =?utf-8?B?cXFzSTdyVFVMeE9ER0dQVDcycEx6Q1NRbG5iRitWS2djd3FOaDRHTGNNRnZy?=
 =?utf-8?B?bmhUd3hBaWJEMytzY2NEdXNrTjVlWjUzNklVQUVGbXlnYnIzYkV2VFBERXVt?=
 =?utf-8?B?d3BtbXNLbGhFbW1vZklLSjVsYlBIdTczZmY4RFI5SjZKYXZVTzVhcnYzVGlH?=
 =?utf-8?B?Y2JORnAzNlZNQzZJQlBxZHpWVml3cldIQkxnTDJwVWdZSXhmbS9BRkt5WXVU?=
 =?utf-8?B?cit1dUg1UW0yLzkrRk9JVkZmUzBjb1ArVkRUUDkrdEhFeDJtZlpzU1VoandK?=
 =?utf-8?B?cHJxSHRLWVVKUGpULzFyeXBuSGV6SXNYc0hLaDdqTk55Tm9MYURxU0tzdWEr?=
 =?utf-8?B?amJKVHJTZVZ4STVaSE9DZ01TYlJlYitjLzNjcUFVaW1RYi8wRGtQZWM5UjhC?=
 =?utf-8?B?Y3djbW9UamRQRnlRZk4rdW40NGVoc0ovUG1tdm40VmFOb3FlUFp3bDJSbk5r?=
 =?utf-8?B?THZnVlBEdTFuVHArY24rSTJZZUpFaXFzNlpld1Q5NGlIYnVWVnY2RzJHOUt6?=
 =?utf-8?B?cUZMVDVuVUU5UHJMNTA2L3d6Q01xUC9NVlMrWVpmaENHSy9OWEFKMUs1WmxS?=
 =?utf-8?B?Q0Y1d2N0ekdEZXdrMGlScDByVXhlUklsaEt2djhuNytZTlNJRGNSL3lpWHJm?=
 =?utf-8?B?TGhFWjNBMGNvSGp0OUV4YUkrRDRUeWY4NDd4TC8xdFpBZGVGcVJxQldxYzBB?=
 =?utf-8?B?MDNnYXoyTXc5V0ZWOUdBN2N3bE9QVU5PRnVPaWF0bHlEOVFNaVhQdWVoeHBX?=
 =?utf-8?B?OFZ6TVhmQUNCdGZUMlhqbDdsOXhHQ0IyZ3VUTnJ5K1lqRGwwNll6SENuQWRj?=
 =?utf-8?B?a0U5dldEYTVtVDhUZVptb0ZGN2I2VmJNMG4yQ0ZSN29lMGE1UHl3WGRHdGRm?=
 =?utf-8?B?ekRFenpWa01EbWx2QWgvelV2MzlUQXE3cU5uRmFNbnZyY0xTTmk1c3YvQ3B0?=
 =?utf-8?B?cE1BenB1bGkrd1FUVlFzQzJnc094cUFjYmZ2VEE5QjN3VmVqZVcyeXRzS1Zk?=
 =?utf-8?B?VTRJMTdNeHBiVkpiZ0dCUUtDc3JYY1NnMjdlUGJlL2lSQlQ0OUpQd1NnMVVG?=
 =?utf-8?B?M0xRSUV5SnR1bHFmQ0pIN3dzWWMvS2dhZDJ4d0VNS3hQZkNFLzdPbVZLeDFM?=
 =?utf-8?B?OW0vLzJlTy9McHZrWnlUYi9iazd6Qjd4MjcweEpnc1ZsYlRDN2VkcXVqYkpI?=
 =?utf-8?B?TFNOVDlnKzNFZElZNXZEWTZEN1VLQVlsNUZ6MXhQSytYWFZyVzM1UVFwOW82?=
 =?utf-8?B?R3NQREZlUXg5RlR3eGczb1VnTVkzSWd1Uk1XVmc2bGQ0MUhqeE03bmVnVkZV?=
 =?utf-8?B?SUNpU3ZTdC9DaXJxZHphVUJTTnpDL2hVM2ljcWtXYTRVQko4dElmTTJ5L3A4?=
 =?utf-8?B?aHNUc1JLOXQxZk5EWnVPYlpici9XY3hRSUFyeUJ4ekQ4OEp0b08zSUtFeUxj?=
 =?utf-8?B?N3BRQWxhYzBnNERGU1VwVDBMV0RSdGhrY3hxcVZzeXpDbjdqakM2S0l0UkpI?=
 =?utf-8?B?K1dsQ0dDQ292Smw5UFJQVnIwSlFIUk9lVFQ3RkVoWko4WjlaQnhEWG5WSWNH?=
 =?utf-8?Q?UD450XOnKEqXeOCsI1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f14e7d-af6a-450b-e4d4-08df178b7b3c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:53:14.6544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwaTkwpN+3cFKKe3WhxeRstyZcVDLWsLXOT55n0A8iI2dcjy0N73JVhEoVwjDTIv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR12MB880420
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3j9hg1s4fog55groz1mzbokaqs4ak9m3
X-Rspamd-Queue-Id: BDF0B40003
X-HE-Tag: 1789959197-266795
X-HE-Meta: U2FsdGVkX19hR4G8kvybtpvEDuYbRPlbDfQVphMk9N0QDq/BBS0AmYbhRD2W+peok6FjWdLRiV8SVRMuFUykaqdduAQkRoLbtzFf7FReQw6YZIfVZkOKTIfQKu56j4m6N2TtCPemJlxAfV3I7/39bxfVo9WdMO74ZTnArNP+ER3XrVN6jikXHHyqxhZ5Ud1GySQcaTOFINLVjpo4qwCNrInQpT79KJRGUVPJ3dY6n/TzBZzePAgPzJLHlt+CeX3omMW1bA3ua5k8V15szn8eSFirUPt56gJn/sn1aT6/93rnkx6hWwzAb5EKbpkcaRfcqd3n6nc0sLzPINWgoo2tbJvi0m3OHjTFRZAcTg8cnXOPKsft5XB3aBBRvoiCMnvKsYo+FLK7y5tTW5zLUIEE7AHE6tMk//PhN8dEFSmNqRbHJFRHSjqy6fPLq7e6vBjPiKgCt7dKfMOWDQb3z1g35lcK6kIViITeI9SLO9aJoSXX2++Qu+Pe4B+rKyuIfhVUi0L5Y9fv/v39f5V2kUsRlRoxCL32h1L9ehaouvdO0OG8L34b6eNAFwxlzkGyjkVfx5l84rn227LsMbPEoBwzV69DYS0mAK5hnKOQNX8vYQbQIJvmCzdSckIyld08GekU4ovl6D/mIiUWdxah2TqyM57+jRRGZa+yGv1VEwPO0W7kGO4qcGO0FUAz/VUW7Yq9uD9bdeFVlL6a0iBscdjYi9RYag7Bg+ZKwOj60sC5VAweGc3T5n7evELUvRLNIlBMZ11O14XC9mSTGZtTsGG5Mha1Y6oOLovIdoZpUCvFfv5/LO7T0Fv5hYzJAplk/uRO+PV0j+E6k3hprdODju+0qmjsO7QX6jQ9Oi5KKR2IkwEmNydbbZHP//QdD03Quf3BD9O3t+fxfnUCDfROmXZAdzW1/z1Z+xZbd/8aSGNNMax1jPOemkdYBwbSAc7wRrOYX7tS3XpC5A10SJxWpcL
 XSiOYqBi
 Ar+wESToWB06sFIe1wLHmFunObgIaFxed1atpNKSEbuOkeUC1RSjWVYP9D5oNEdmIpGByl3LTbEaRfKvIhDEsEZt8Knco8R1PkbHfeHePAV94v/57rKDldSmnXD6LPP/R1pQJt0AIbIF/J13g3TKSvZsWVv/e26q8V8qNpt9LYsj8Vi4EdRZTeRS7HKiN1dQ/AbtYYOyXVn9zsyjcgc4dLoeFSljMIvCt5vgl0iMYN880yUnE6L16LNKl0dC1YWxoOOr/DwkSb10rl2svFTD639o01n+8RYvnq+/xqpCPH5tFH1v/pm30RwPFEIZLuWvDLPbHU4m5laAxCpkydEag4uowB4KPfMGeZV7fHLmCpZlxiJoeTOgpGBOZdNt/SDW0WJxkxp0TCxHx1uOd3RFqAh2BRIHXdr/3LarJ0kpt5X7SVmkD/kpVBvogeNd7D14bNz52CRcramOY99Kt6k75rVqZoCjTbMdZAxNa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Sep 20, 2026 at 10:49 PM EDT, Zi Yan wrote:
> On Fri Sep 11, 2026 at 11:04 PM EDT, Gregory Price wrote:
>> Extract per-node fallback-list construction into build_node_zonelist().
>> Build each selected node directly into the destination zonelist so no
>> intermediate node_order array or node count is needed. Print the fallbac=
k
>> order as each node is added.
>>
>> This lets us build new zonelists from candidate nodemasks instead of jus=
t
>> the default N_MEMORY node state list.
>>
>> No functional change: build_zonelists() builds and prints the same FALLB=
ACK
>> list over N_MEMORY with node_load updates as before.
>>
>> Signed-off-by: Gregory Price <gourry@gourry.net>
>> ---
>>  mm/page_alloc.c | 63 ++++++++++++++++++-------------------------------
>>  1 file changed, 23 insertions(+), 40 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 7efce139d562..d1888d5630e0 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5857,31 +5857,6 @@ int find_next_best_node_in(int node, nodemask_t *=
used_node_mask,
>>  }
>> =20
>> =20
>> -/*
>> - * Build zonelists ordered by node and zones within node.
>> - * This results in maximum locality--normal zone overflows into local
>> - * DMA zone, if any--but risks exhausting DMA zone.
>> - */
>> -static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_o=
rder,
>> -		unsigned nr_nodes)
>> -{
>> -	struct zoneref *zonerefs;
>> -	int i;
>> -
>> -	zonerefs =3D pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
>> -
>> -	for (i =3D 0; i < nr_nodes; i++) {
>> -		int nr_zones;
>> -
>> -		pg_data_t *node =3D NODE_DATA(node_order[i]);
>> -
>> -		nr_zones =3D build_zonerefs_node(node, zonerefs);
>> -		zonerefs +=3D nr_zones;
>> -	}
>> -	zonerefs->zone =3D NULL;
>> -	zonerefs->zone_idx =3D 0;
>> -}
>> -
>>  /*
>>   * Build __GFP_THISNODE zonelists
>>   */
>> @@ -5897,20 +5872,24 @@ static void build_thisnode_zonelists(pg_data_t *=
pgdat)
>>  	zonerefs->zone_idx =3D 0;
>>  }
>> =20
>> -static void build_zonelists(pg_data_t *pgdat)
>> +/*
>> + * Build one zonelist ordered by node and zones within node. This resul=
ts in
>> + * maximum locality--normal zone overflows into local DMA zone, if any-=
-but
>> + * risks exhausting DMA zone.
>> + */
>> +static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *can=
didates,
>> +				int zlidx)

Is build_numa_aware_zonelist() a better name? Since the old comment said
"NUMA-aware ording of nodes" and the code uses find_next_best_node_in().

>>  {
>> -	static int node_order[MAX_NUMNODES];
>> -	int node, nr_nodes =3D 0;
>> +	struct zoneref *zonerefs =3D pgdat->node_zonelists[zlidx]._zonerefs;
>
> Why does build_node_zonelist() need to have a new zlidx instead of using
> ZONELIST_FALLBACK like build_zonelists_in_node_order() did?
>
>>  	nodemask_t used_mask =3D NODE_MASK_NONE;
>> -	int local_node, prev_node;
>> +	int local_node =3D pgdat->node_id;
>> +	int prev_node =3D local_node;
>> +	int node;
>> =20
>> -	/* NUMA-aware ordering of nodes */
>> -	local_node =3D pgdat->node_id;
>> -	prev_node =3D local_node;
>> +	pr_info("Fallback order for Node %d: ", local_node);
>> =20
>> -	memset(node_order, 0, sizeof(node_order));
>>  	while ((node =3D find_next_best_node_in(local_node, &used_mask,
>> -					      &node_states[N_MEMORY])) >=3D 0) {
>> +					      candidates)) >=3D 0) {
>>  		/*
>>  		 * We don't want to pressure a particular node.
>>  		 * So adding penalty to the first node in same
>> @@ -5920,18 +5899,22 @@ static void build_zonelists(pg_data_t *pgdat)
>>  		    node_distance(local_node, prev_node))
>>  			node_load[node] +=3D 1;
>> =20
>> -		node_order[nr_nodes++] =3D node;
>> +		zonerefs +=3D build_zonerefs_node(NODE_DATA(node), zonerefs);
>> +		pr_cont("%d ", node);
>>  		prev_node =3D node;
>>  	}
>> =20
>> -	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
>> -	build_thisnode_zonelists(pgdat);
>> -	pr_info("Fallback order for Node %d: ", local_node);
>> -	for (node =3D 0; node < nr_nodes; node++)
>> -		pr_cont("%d ", node_order[node]);
>> +	zonerefs->zone =3D NULL;
>> +	zonerefs->zone_idx =3D 0;
>>  	pr_cont("\n");
>>  }
>> =20
>> +static void build_zonelists(pg_data_t *pgdat)
>> +{
>> +	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
>> +	build_thisnode_zonelists(pgdat);
>
> If build_thisnode_zonelists() means ZONELIST_NOFALLBACK, why
> cannot build_node_zonelist() imply ZONELIST_FALLBACK?
>
>> +}
>> +
>>  #ifdef CONFIG_HAVE_MEMORYLESS_NODES
>>  /*
>>   * Return node id of node used for "local" allocations.




--=20
Best Regards,
Yan, Zi


