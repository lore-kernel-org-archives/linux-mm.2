Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A76CAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3A86B0005; Mon,  8 Sep 2025 22:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCBAB6B0007; Mon,  8 Sep 2025 22:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2286B0008; Mon,  8 Sep 2025 22:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD0996B0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:03:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84A04588FB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:03:58 +0000 (UTC)
X-FDA: 83868066156.25.8E32E8E
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8964C000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:03:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VVtpbjhP;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757383435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViFTs6h7gY+MX0vs/xmmC+fLi/3NeEls+xoN8PoK95w=;
	b=rN4Rb8AgcRYep433h7zUiph1YEhv+E0WUerQ+BQOC2FFPqt0Yrmvpym/tBSbSRz/G9H0xo
	/wYm56thHNESHbamqmbrMM3eBC+g7O/C8EDO9Mo6TtxKnwYjhtwmyaBmu6O7QS4JC0Tjia
	JZm2BvolOTN4kGTFTxdyNMZC3R/gdVU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VVtpbjhP;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757383435; a=rsa-sha256;
	cv=pass;
	b=x7/ah6s2RSSqNdUANtwOWc7eF8mb+EPuaUIpQK6D52ZMEB/49NQYP8+gNSHtDFv8zO5Jft
	pY1xF1jkjVeIei2gpxSth4mAr/GWQrwlfWH1sYIV8oW+JDxeFgc7gvS7MlFqBYMp1cMH1C
	xSKX9x2Bxb3bfHihgDdWFw58uo1bvWM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BeK+/MOKJwGVllqFbRQLclNrn8UQF0M8P6KfYhfXFt6VYklhH79oP2eopwr7AYcW+gpTgBk9GvzQHy2uINZHle5+5uhKV337O5/du2+n26PJfqj+Pl9uP0Bv//9hiuBIIr6HmXpJA4/WJeb80zdX562nFtyKwJ4Ecu9nSswcXpXL7MGAxmlUCEXIGYe7v+b4ZgklXKinjydbndZXwBV9xTx4xkfgXNpDgEaAej+XjSy/2W8V8Skndw247y5OOFIbPbcNm2pJk7Fo2QLIHOxACwcvlzdazcOww2f8apYqmh5Ij3N5Lf6+VKqb2v1bFVV+fa/WaqGVLyW6wHN5ONBT4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ViFTs6h7gY+MX0vs/xmmC+fLi/3NeEls+xoN8PoK95w=;
 b=xUsCnKAds2YzXTGh2bl+Y+OZzE+I9wJHdCv4uQ8ljZYotEiZ+rkThhRskDp2fYQJYzZgkU+2Gsrd/ZM/X0+85GAKEH/Q560lFWfgNYri+5LMwOwirBgYba6Dt/r+luOtTunBdBu5hDItLOxSfkG1FiOsgJ6wWdKyHjtky3w/ftnRmz1GcPA0FFx6CAxFm9HEvfi8xNWTNG6nOc2CCDLUTyK7vs6Iv5Y32UsWFboUtcp3BwbcFyc7X0TppcVzWxyy7IkwAtSM1X9cxpQshtNZABs3m/Yg1xZ8l2lXTVUBpCLZ7niMCSsE0eTufaz2LK2NBzgHGSKhk6B0xmgKKsa60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ViFTs6h7gY+MX0vs/xmmC+fLi/3NeEls+xoN8PoK95w=;
 b=VVtpbjhPDBOxDlIOSeGNWS+ojzJOWuDi27TbBzfzYu/D+rodg/6+IR+uN9b7gMs+aGHgyFM1ko0wtWNmJwOxipjAQpGDNUhDXTLOmKKOz8WkZpum/gieaxFGYSAJ/rKt/80vaGzT6M90J0xwTy8aGSXf50pHwfz3wLdCxeMUxcxSjhiKz6S2EtlsZ3KFCe6YoJWJz4Z79vm9k85aKzVyY6fIVF5Gs0lgYKPkkzy9byfrnXQSC9+8RrPiDVIQwGdyHhKlY9+XBR11MPQw8wJPsIGppeHxy4dFYXQttghtvWZN5iqCxpj7Nr3Xw2MrX2cbPpFpbfVNreow6F3/P1Ihmg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB5836.namprd12.prod.outlook.com (2603:10b6:208:37b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 02:03:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 02:03:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 7/9] mm: cma: add alloc flags for __cma_alloc()
Date: Mon, 08 Sep 2025 22:03:50 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <921FBFA2-2F35-45F1-9F74-CF91FF2FACC9@nvidia.com>
In-Reply-To: <20250902124820.3081488-8-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-8-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BN8PR07CA0009.namprd07.prod.outlook.com
 (2603:10b6:408:ac::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB5836:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb0ad14-1310-4157-e165-08ddef45202c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vLo9H97jhMo1XNPUM+Z8EiKun9RqYFTzFqypCo5oKgYySyYPOtgB3jqmyOFv?=
 =?us-ascii?Q?VGhswTt835zchowLebCXYlRiM/Caxp95ZXKobfBm6kUxnpSgE7M76OlDlC+q?=
 =?us-ascii?Q?xyMBxSuoLyyunGgAEc4hDEhurZsa8RJZ4VnIvdomG0/q/bPiA5jlVsrpi9RQ?=
 =?us-ascii?Q?ik5YOLgimjRZFuHfUelQICvp/ByZDqKM/IQ931TMfE3oL16ohNnDEp2sbGXv?=
 =?us-ascii?Q?GsAetFFKffnl0vXSF4bJrlSN0nzVztHbV2p3jjkdSHdJf495VVi5XDrSDbT1?=
 =?us-ascii?Q?1jUD9Cxxvb9ek/oL69lvsFnHCpBECaVkeyeJ7h+48xSzVEVNoColIAMYLwHZ?=
 =?us-ascii?Q?bQFLnCrDSfce6AFHhVxmeza4pWx4L4VsB5QMapvbFks+ptJ9EFhP4npHEF3p?=
 =?us-ascii?Q?9jmKA1QstDo/niN/PKnziYEEVDSIB8TxHRJCOx4HLciEQfkxXKXPNv+fJWrc?=
 =?us-ascii?Q?JkilbTnxDoKj0fDYoxqsy4Y1c0MIquXWCffcrjqe5X/kWwOC8NX6tpa9e0lT?=
 =?us-ascii?Q?eHMidmNllpAo/StOEcbwmN368I+jVYE8I6RdQf1BZfrmS2JUtefrb0QjR+1/?=
 =?us-ascii?Q?LoFZactphRLFX/thbJOy2Uvdd0Hzz9SMuE5UIoogkxkVXBtHxnOgY9ZCMDF4?=
 =?us-ascii?Q?8BeoLfdHq0TxVT9ZLBgBWGmB2OQaXDf6YXyrAjW0UrP945LpEYKKumyFI06M?=
 =?us-ascii?Q?eAsFSZfeLWnBNUrK4xmQc4TDDH4Iv54Rk+UV4R69C8J6xvPRHwY/xPOX5yLH?=
 =?us-ascii?Q?+jBhgdkqKCcIXEh/VaHXnz4GB4HIk4PN1pPTkEvh786vL49pHXDnnTHeKJFV?=
 =?us-ascii?Q?R8o55z5bl8/tQK5+2+KL3k3JSBWlg91CuEdYXCmG2ZVB2cnnjYSLgZg9KIv3?=
 =?us-ascii?Q?6a3pFfKpEl2LRQvB/cXURiB9oey4ea7sDlp83z2bPeR+xmeu46lmOytISPZt?=
 =?us-ascii?Q?pSRBrGcU2eRo20sSX4mKnPKzI3RS/m7Mvp8I+Uwz7atAtYU8iPnMrcTX4A+M?=
 =?us-ascii?Q?+1O8V4ni1jUPm5otCkjdr8fJh+cw8rT8J3p0cfzdHP2wmpa48YoWXuayX9OL?=
 =?us-ascii?Q?mx1BJzUM/I0R9Jd6jNYjQ7OUPd8aCs+WeprSFkQ+uSF7dp9n7P6z6TXrZzWn?=
 =?us-ascii?Q?Y2DGfbVq3PeN37VRkJAeRIa1rQdCGQ/Lip/yDJhV7KrgOZXe3xe9bsOB9yfp?=
 =?us-ascii?Q?v0lT+pDaAW7RZbxZLj4Ss1az0LHBH9GzfB6HdwqWml5s5CJh/hl1SSRgwnEX?=
 =?us-ascii?Q?6s03yki0xdvJIKUDwtLdx1uFNLgMJHzi3lnC8X85Ap0nwyM8eFhNYsoDNRK0?=
 =?us-ascii?Q?7S0BGF5nkEUOphn7EAi8URisNt5yA9SHINcs6ST538KHkIACWUF3T9RzWsVr?=
 =?us-ascii?Q?ColiqNtJAdAP+tSgx7VtdK8z47nPPQFOo4AyKyQe6xRyHA6sz6OiA7h8vG0V?=
 =?us-ascii?Q?hFqg9B4PZ6M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pOvkVjS1OLOO/lUR09j72mty0BTAYZrO95j1UN+xLVrls8nWRJTKKNM2iHtC?=
 =?us-ascii?Q?1zSM4vITGBFNEnxekRhnnVprAhYLMqmsxRWVtAQ/ikrCTjn8jOoVsjrxS3hi?=
 =?us-ascii?Q?3E8Xa1DptO9G+8pRvywAbamnlFmxkv2UPGK/MBYUSi+74mAmi52CX7sjVoAn?=
 =?us-ascii?Q?9PLbaimiTk6lSENt6BOT/TjvXyYcSdPPZHX8ZnvSsUrMeMOEKZMuJLvTuNYp?=
 =?us-ascii?Q?CnUPzw06QQjy4TIu+rDZeSgjPHC6TP0xzsA7j3I3sWgXqop9nPMgA+bxKvnE?=
 =?us-ascii?Q?tK25La1p5fvFTbQyp6BG3DeQ093s7cMYd4TL4SYQF0mp+BguedMcBIH6BsK6?=
 =?us-ascii?Q?awvzFegKzpF1nh9MiRt60LsyGE0F5oPBfZOdz5t4UfZIBAHhFDKMqh6nFyPs?=
 =?us-ascii?Q?Dv7HDSivjgTgJZHL8aZmejbmuCqgvLooVD0RDPdpDxVcJMuHKXPJn5KRysPQ?=
 =?us-ascii?Q?ixuALBpIGcA1dmxbDiDYtOYmrVAfxgjs0i8T+cPR1p8M+shb5xroV61P3Llq?=
 =?us-ascii?Q?ZsMQvWbcgPqJkENo5IaAS+ZdkRBIbmd4nRcMa1GOpWQi+ndG+xG2IDGV4MwP?=
 =?us-ascii?Q?FLBVSp63/tZ6vspse7BHzdlpuShu74EAxgl3QNeKAEeCAde6OxFsxXJ1ykLe?=
 =?us-ascii?Q?EBNhnK62Okm60Hws/HLq0mavj0fAkls6MI8b6DnamGkWjCciqleA36X5gsVt?=
 =?us-ascii?Q?r/SAbw3ZRnvGx74WLNKiabDC1I2jHLhMMJKeqmhDNiOUwbHD8Fkmupt0908Q?=
 =?us-ascii?Q?VyNT3jxJlPryBqwrhBqrqUdJJHG29XE6w4AeZl756ct0MXydu2DHfZJnuqTG?=
 =?us-ascii?Q?+AT76zX5jMB/cYYfMmsyj2bm/cIQlv/KJ27FrIWp3IszVp6TcigccUN7nxvE?=
 =?us-ascii?Q?bOPyjYJ7417o9jETo7GT1ph5+OuwExp9c28b2Dz52yZlF3i/zvtpbjjBrVQH?=
 =?us-ascii?Q?EYvEpS35eQBAhrd77cYyj7RJkAiccrZUbja5p/QyzNPjBPrwZBMNbxYvv4vk?=
 =?us-ascii?Q?YOsuJvZEyk0mPuNabTIXQe7rCtYFmEtcw67DLuXEVYNVDLshfn+vk4Os5NxS?=
 =?us-ascii?Q?osRlr2zxyzeWw6XR66DcuW0la7i3ZW8FYxSMhr+3YhDNKw1INak+UQPlM+Ms?=
 =?us-ascii?Q?S3tY5RxYM+V+UT2yw3SDQvmcf/P21s3HLGmdVFL08BdzbaHNB1rfacVQwi5Q?=
 =?us-ascii?Q?Ns3z1OB3Od7ijN18SEbzuaH9yU5OVI0ReonZdZghh8aZFYNGN/4bsloETWuL?=
 =?us-ascii?Q?tZfPfv/hoZ02ZpVW61KeeZ/3w5Kk9WBIEzYzlmVEwIS+HxxYM0Wc43EDuV3l?=
 =?us-ascii?Q?TnQ9Dy/B6+rBZRvz1gOfR+ybvowh2/bm/PJPzYo3tlafUxgrw0KiiJ3BYABO?=
 =?us-ascii?Q?JSfNh1+qL0ygX0rU+2Rtzft7IHF+4kNGwI+40mCjusdcx/L4toi/K4PTFxv/?=
 =?us-ascii?Q?8+ypLKMFixA2pkbQM/KAtrXeF7Btq2oAkZcQdOLDUBT6pyU52qlJIR/S2YwS?=
 =?us-ascii?Q?/3fkKk1fPakb16LqkD5OBaNkikdxso0iSzEKySFMUSEz7jXku+3nnvPsBtfj?=
 =?us-ascii?Q?BqGu7XDEKQvWspxXWdCJCwoLM6UrWrt7nc0GmT8k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb0ad14-1310-4157-e165-08ddef45202c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 02:03:52.9330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mT6F2T7hcxV8RsIFWhuXb3zwM3xKAxhBZUhKyfHO9DmjcKUO4KIr179/OfWeAyLg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5836
X-Stat-Signature: 6bc4ooydkkzc4m518s49gwuxxfw1bgjk
X-Rspam-User: 
X-Rspamd-Queue-Id: D8964C000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1757383435-257280
X-HE-Meta: U2FsdGVkX18WvcMTsFXDaZWfAn8HtnBo8lPlDvPNghcMoe59loKmLT6zrOglUvUu6u+mwuG2ChgVBy02t8yPeLwNAwYnvDDQTPPy5nURzTIFZETR52fYE8J5d3cuNexQDKQqefaaAJnYHl4SKwrkGPjru7Q5O+zd03BSD5AOvdpX77472zyhVx6YLBntp+TFky6qJ+amk9qf9doWq9IvVKhQetw3maLdRN6cbPxYVJ/K0EsLGTbft+KGbFOUF78vMVZEJZyo68f1dEDBQaB3bKRphflv3+Eq1DDpMN5Oho/aAszAeMmKBdKk4QUgARKa2VHXmSOqFlcwSA0gRdCyJPcYmabZiq/yCr2JtMIJpPoUSvJCl78gCrabQwGI7KmKfYd6lJZfBOzGTqy1D2tI+9UCdzbZUghiiCPM92fSG9JiwrV4fzSgPZi58IrSdaDRERdWU3JE2cE8Tsky3ufJFUHqBZe/IMKCuq4uKDkKue9RDR+JRUhXjlvJYNN2ZF+quxitSOoO6YBjh6m4Eff7p+9gQYjxIWbdRxPgbppF1Ia0Ecg4MaSpm9jMgZ6Wv5SnYOOCXKgPw8Xs8YXyuKrZMLJxbfiHX9jTt7WgQRwBoZ404Lj8nkvRMUI3MOHOjfv+D0yZFvUBJZCyF6mmOYINsmv5tIDPPjn/BfJ7qf/kJ14gobARE39+Ff5prXrAlDyY97S/lfqHBa/UK4wKjCGzgXTgiOjTFfhITv8klEmCeuaCPAyEiQk/mxkDBxSiKJlfDgyDnd7nKS9oMqSK9R2Wp0r2/vQ/bTNXrafhTeGYNXd4HsVn20dSYCDMBN2QLRuwIV/5/Q1qQig1RK38zCOQfFZ2G5XLutXorhQ4ADBecMJYei6xG6nnWHgNNgM5hfpX9cuvVZAkQrSaAgouCa2hZz9acyByk3qsKgFopYOUt/Dgkh+Vk8G6PeIHPHNwBZoOPV7Vt+lAGEUbrsCxhdS
 HQrQPId5
 BUfQs6pK+UDznHVIMCIK3o1ISdajy9tTDI5xaSiSrPFdNsmjhqpkkBI7YCEIEldUYcS4QN328sLfv0KOuX00sBFHgAemyPtqf8yw3TwCahd15Nmxdo3rgoefjTEvjjyhPPG594vNqURW0aa+VkWeiOGYZrdLaLwa7nvaiccU+t6o6SfkjX3i7TcnGVB5VVqtPCzP18IRGXA+QD26tHulAlIoLd9nIEx/p7+cgAnLZavnyzC+MBE+2dcJkPwqU+Tn4IX9WD/nuWbTNdsRgbzkOHgPGIVwBFSOfYeo6iQfhOwLhH/MKoZA3FGhLN8x0wsXEM/ieti6Zm8xXuGlcOVM0KdPifxOddAL28gAdvRm1iWVXtMzRfm4IJMRVlyenjlUbMITsAaxEs84Qs5xE584j9hEcS7yayMyhH8AjwB7MZgScMqcWMr3VgFmotFMxigF18JvGJcB+L0uUU2PsIhi+sOBCECs6cckb0PXvnq42H8oNeL4MI+dp/gA1nkFtxi11K1sV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 8:48, Kefeng Wang wrote:

> In order to support frozen page allocation in the following
> changes, adding the alloc flags for __cma_alloc().
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/cma.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>

I was debating whether this should be folded into patch 9,
but it makes review easier. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

