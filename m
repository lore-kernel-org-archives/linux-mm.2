Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53250C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E796B009D; Thu, 20 Aug 2026 09:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176136B009F; Thu, 20 Aug 2026 09:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D0B6B00A0; Thu, 20 Aug 2026 09:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C59BB6B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:55:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E4DAC0171
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:55:28 +0000 (UTC)
X-FDA: 85121795136.25.8BB4F48
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5C7B71C000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:55:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="BQ9k/s5Y";
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787234125;
	b=zLuiEcNfXa2OiBz92EtEhO9pnWf4CymxNK2BLeSk21G0Quqngm48gBKNx1SfsLAGwcXXBU
	Xphr2CzrREH4mfx/RMoQ9q/CySD9SIFBsS39UBODj8lGc0RpyoboggbSblvs8OLE06eF8l
	rw7oEVQVW0nOqUqhOfExYGgD9ur9wAU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="BQ9k/s5Y";
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787234125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MR0riYFoStxJ9ZDWdGWFDAfq9ysgw2/0WqpT2b8cRm0=;
	b=CfuWdhqPV/qlFMfzLhWcy1l3k0wfvDbsnIpAoDB2KFrI/pYLaKSxo4ni8iZ59QnXO2zzSU
	Ez9jLa5sZAJf3/UCrtIAF4GHn2efkVi9s+MY5QGqG0hyNPkpdU9rpWL0aceehtSDFpl4Jo
	M0gdx7ZV+V0KP9kDurEo+y16pV6+SUQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CaaYvG5XP/RYbQaukWnko8vjB6annPCbDCFVYE8sAS8e4dviP/aKKpeq5C9UaFJVvz+BIqYVPjAshP+IH5AXNeS3ktyksY5aVb58i8AjxSWDVnAVJCUbd5S+JEjtjFmnyW6OItBWwmguP+Y3keEKYT0oDFJALXekKsdKzyvUpT6tv1sSqLt3h73IuIoEaRaO22RUs8I/hJuGY3HSUrpL5Hgy2NB3dlCi+TzbrmajapbenvdtpmpDVOaet2zBaNCIroNZIghVAzu0ry58kBcH0bShKtuEdNqcn7DZtli0tXaqRTIK7F8YjJS+id/grAYh4FRJ8+mu41hlSpNTA96sXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MR0riYFoStxJ9ZDWdGWFDAfq9ysgw2/0WqpT2b8cRm0=;
 b=klkPdjcU8tzZMNqaqSLprzChCdaRrXYONu3nYQeFj/N28My8Tl/sndlGY1IB1ApSBVL0dJxkWKWUlzndLsHZlwgSeNCvoyJYGTd4Kfx6JWRVj85ZbjE9oX2BjTXv1bYqcV9pMGMD5kuvZ+0vcndKJ7Fd8Z0t2O7YMIOe0l3K/RfD3pT8BsguQ39o06tv66TM3kebZ/YED88x2baEXaUpF7qL69bCk8MLSj0KRpEhL8RpwUrXYOu4fe4HdVg85BM+EUUPb/7I525KgUzJHtU1+46Ji/l5A8k6i7xMYdwgRaLLpyeexkwCvHJOc3PXiMw/ybSXDYWaM29AHtrhwuoaUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR0riYFoStxJ9ZDWdGWFDAfq9ysgw2/0WqpT2b8cRm0=;
 b=BQ9k/s5Y+Y1nS0jC1vncyi+yqDuiaGrgZZFejRRaNo8VcRwaalIsUl3cuP5pJ4MkmbSJlVln6pl+DIL1FVeTw33jVk2OS9zX+zORzEGetfIQJ1vNR8qiiSL/7z6Eb+iNVqq1ktzR8hznot7iZ2nVIzr3Y+FSp4ufRmWElt3j/mxL945qOcTIwYV19e1156EmkqgJolPi73vqxRMass/qfhuEtVSu9R2VVXD964xJyc0/vHc18ZQc7hGALr/jQPUjmHDJsFE5estd7/AA6gM3d456fewd9jdGDf7we2YRtxgrC8TmMu+0sMPlHDfpOEru2UuMswGfvf8kHwxe4IC6/Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BY5PR12MB4049.namprd12.prod.outlook.com (2603:10b6:a03:201::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Thu, 20 Aug
 2026 13:55:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 13:55:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Aug 2026 09:55:17 -0400
Message-Id: <DKTTMAS94IMH.2C6ERY0ZIVWVZ@nvidia.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Cc: <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>, "syzbot"
 <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>, "Alan Stern"
 <stern@rowland.harvard.edu>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
In-Reply-To: <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
X-ClientProxiedBy: DM6PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:5:333::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BY5PR12MB4049:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fce1ceb-b7b2-4b2a-2f6f-08defec2abff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|366016|376014|11063799006|10067099003|56012099006|4143699003|3023799007|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	9OOnFgs41SxyuJL8cGKFy6uXz1EewCBr1tKH4i7cGOM7jbLjg7D+4Ayak6o4Grfn3VxiifuaAPsDIV811Vy0W5bNZrNv0Tf5TIKY6r/t7ykXLkkeNncDt+Cdn065cc7bA9akEJFY/WtyUYbVYR3iuZMOYZYbokNxtKyIda+mQ4yvtLJZOU12AuWeFjHX/QChSaOBG0iyzbNsftDggFHInQqzuDkq19PkUAMh1ANfGDgRHZqAQTmqwmipKFy7e2lMaulqlIjAgzsGp/QRgBt0OLgF7xf/qacv3sV1HCCLcT22HDMTq81TXeFtaN8nEnibOjbQUtQ6CkO/P16YdwV3FLT8krpub6cyWWRKSrFfI8kaqCTelNdMsphVhJMrMfLZ6okYzCZd8y2bVguK7MHHU+VEjYLVJ/3QzvnviTkwEdDGHobw+XreJxvtHn0nYC6UavEu0UKB38mg7XTrUJ3VgLvVAfSw0pAnZjVO8xlJYFLLcpMwKxAYkp5JOiSKdAZT7Zc7uU76jW8DU5sYFFDGgAILj3h9d2VTzk157cc1owKACKyVX3Yb9a6j+sGCJqqSfAbjmJq0x1wj/xTiKmE9r/ZC3+4T1y3QLyQmaXFRNqKC5fLtGRQ7SRoS55TgMWTRKD/PGkOXChfznR5ULmOOektOjzIyuaa59BJHxgR8+QM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(366016)(376014)(11063799006)(10067099003)(56012099006)(4143699003)(3023799007)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWdtemhzRGRUUytpUWorYk93U1dtL0o2d216cTVvV3ErOXhnYjdLa0VFNEp2?=
 =?utf-8?B?a2JaV25sL2NsUWdRTDNuU1l4VUdFZS9aa1hiaUVrR21mZlRlaUNDZzdGWkNt?=
 =?utf-8?B?bFM1bSswZFRhQTBweGdJSzlLc01FQVBKRzQ3WHY0NWt2WGgrQWtrL0NaSkJK?=
 =?utf-8?B?cGFPT0l0Vi95MlJ6UFM4M2ZoRUl5cldzTnEyVHpkMGEwNmNQTDNZUUZ0aUVq?=
 =?utf-8?B?L3RwQXdTMDM1M0lMOFdYWEt5UUNZeHk3UGFSZjBqR2R5diszYTFQanRsUmxS?=
 =?utf-8?B?R1pMQUpodUc4elFyNDJCTjAwc3J4ejRwVmhpQTJLbW1sa0luZ05KT0l1ck9Z?=
 =?utf-8?B?NExTK2RXb09LT0ZGUzF2YVNwdmZqeW00OC9kMnNpcFVIajNsVlF4Z0FnN1Z4?=
 =?utf-8?B?K1lFYk5SS0dxWlYvOUoyR3VHcFN4dTJ6dEl4dXhtYUFqdGU2b0UvSmJoajlV?=
 =?utf-8?B?Z2VsYnJRcWhxM3R5MzhER1M4VVo0KzlKQi8xS0JzN3dBeFI2dG9DZmlnZk93?=
 =?utf-8?B?RkpTYW5ibDlHbFpFYk8rL0szU3ZFUTdPaXFWM2pEMzU3bmVLQ3FPanROc0tj?=
 =?utf-8?B?TEJGTGR6NG0xM3FlY01NdUlWY0hxTVdhMjlHYzRtMUU1bVFLdjBhVDdab0l0?=
 =?utf-8?B?bFhDc1p4bkhacU5aa0YwdldJQXBzSGx5YXVUR2plNU1nT3lkOGRSdERabXo1?=
 =?utf-8?B?OWxFaHh1Z0pSendVK3B0M21WbVNhTVdydDF6VG1JS1BCdlFNTldxam4xTHNz?=
 =?utf-8?B?STJEaHNRS2U1TkJaQnR0NFpRNHdONnZOUjIrUEhXanFWYXZmSnZQak1wKzky?=
 =?utf-8?B?YmoyQnRIYVcyMWN6WWpOZjJZTlU0WDJmclJDcUVRY1M0MXVkSkdiRFk0V2dp?=
 =?utf-8?B?Sy9TSDdnT0p1NE1jOWo5L05OdGxycG9pMGM1TXg5cHpNa053czRENTcxTUVE?=
 =?utf-8?B?RjJZbExBbVpQSVdLL2lHYW4vYzY0L2ZEYm9HY1Z6cm9MKzQvMktWZG9uYlhP?=
 =?utf-8?B?YWRHR3BWTXVlZlhPdE5ibzY3YlZqenBUQm9MUGlKaWJzNHJLYjFwQXJETXVu?=
 =?utf-8?B?U1JCdXl0N1JqV0QrK3NYT1VlSEFRQmkrVTJHb3F2ZHlEbW1iUnV5N3MxQzAv?=
 =?utf-8?B?blM2S1kwOVNnajlkVHhuckk5K2h4dis2WEdPcm9saGpKK09kV2VFOFJiekJF?=
 =?utf-8?B?R1lrNXZXdjU0U3VOMVloVnZLRnZXOXlYNDB1ZUJ2YzJjNTFsTlQzVWVmcm11?=
 =?utf-8?B?K3p6emJ2NmFKWmNJcUd3Zkc3NW0wYkJsQlBEcnZVcVlPRFVVemw4cDZ1bmhw?=
 =?utf-8?B?UVh5N2c2UzZrdlMyNms3U01kL1JWQjRybk9rL0pLSUtHdXBDejFpQi81MGQv?=
 =?utf-8?B?RlU5NW4xUjl3Y3ZsQmc1eUFKeFQrRUlWaFFLeWhWeStiSnVXcGlLYjRqMnZG?=
 =?utf-8?B?VDdjQjRVWE81cFpONjU1Tm9aMWQ5Y1VoYWlIN0FnN1cvOHBqZ0dtdVN0aktZ?=
 =?utf-8?B?M2p1VGZ6MFFtY2VKRXVoUy9EZTJRTHNxWTlVMklhVFNTaytxMWI3SUFTeFk5?=
 =?utf-8?B?Z2hSbm9ZWUVxYWNIa1FqTHZXTW9RdFFsZXBEdzJkSThGYTc1MkhWWHJ2VU80?=
 =?utf-8?B?dVArMGxCMWpIdTNnUFZZL1lKSlo2ZnhkWWxmdWU4Q1BJQXFVaHB5aTFGV05Z?=
 =?utf-8?B?Y0NzYlBzb1l4UDBuSlpUQXBCYUpPTVBlS0VZNEZNVHF3US9YdTI1OEljYUNy?=
 =?utf-8?B?VWdwNnhqMDlrU0J5YnFSKzE4dktYcDZFZyt0SlBiVXVnNnVjdnlLZnQvV2dF?=
 =?utf-8?B?WHFOWEthdDNLMVJuQnd0eWJQWWhuMjVTdmMwSkFjY0FTVVE2ZFlEenZBV1o0?=
 =?utf-8?B?ZEsvYnAzTDhVRFRwUkdXQVI2clMySGNqRldRK2w2clk1WjhxT2crM0thcnQ0?=
 =?utf-8?B?MEpOUTVUN3JSRS9vUXg5Y01VRTRjWnl0V0RUcGlkMHU5b2pzN1JDaE9hVUQw?=
 =?utf-8?B?U0VoOExXcUJJOGVoTG1XaUNOME9ZMEN4K2NoK2t3cVJaV01ZMWl1Uk5DczBw?=
 =?utf-8?B?MlhodERqQXR3SWovSTFRMXVGZ0FsVXJqYWlDRVVFV3lsZm1Ya3JsMFhmOUx5?=
 =?utf-8?B?Mjl2dHArOE9RT0F5S1ZERExqYk9xOHhkRUVLNmk3emFpWWl3WFFhOURnMFZ4?=
 =?utf-8?B?cDVmYUxuK28rYkdZeDA2dHJBMHpsK3JXWGxDZzljR1RHdlpjemhhOVhrOHVw?=
 =?utf-8?B?Zyt5RW41bVB4cjMvLzdCeFJCQ0tQQ3Axb0hGd1pkWjdvRmtJeDRoOVJWQlY2?=
 =?utf-8?Q?Cw4jgzVkP+g4kQDAg0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fce1ceb-b7b2-4b2a-2f6f-08defec2abff
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 13:55:19.8122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owdXnw4b+pssDFuFIBrBlKx84jCXFJUqKWdhM8zUYqJgZhr17ATrVo1gwVoFdcB4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4049
X-Rspamd-Queue-Id: 5C7B71C000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: r94tmr9cqibyu3zjyr9opquyfupqmrwr
X-HE-Tag: 1787234125-748126
X-HE-Meta: U2FsdGVkX1+z2ZPfUwODYRqUctoY54z4aepWjoi9V5+1xlrLGHq2N/prdNsZ2N/wxvsCheHRqoFPnY5lHTzKKi2Do1UjJgSCnOhUXYnon+PuVkZtcrSTdhIsW9Ro9/T8Mq91GbeVXggqXNM4bQQHbZQCH7TUPUIDij9MYJ+4f6CyoSbbLSyW9v+zvLxnp4xJIHMTbcuUbTGpPgZygDOp/KJo6gtplw0QV2M84M7Gz0NJ30ex1WYgwiwiZWQZvSDN+mctQvKJcxDWJoqSXXOq3PbEOl1hn7HkcrUfHA/vClacJgXPHXpJXY2HW1oLIqSpcSFKWAO6uyshDERe4x9KuUZYyds/npGpIeQGYSzjFzOFdunKjfqkUClMJDgjI3b1xZ6k6jwOX6tFK9GnjWtbVSzXYmzGYdW7EXw3jECCSkn7tpOWeipsBqWSo6VwRpfaOEHAFmsizdzOPbp/BQ4V7fvAQDYv0famS1HMuxdJHz72s20Nsy5KGEGQi4xJ7Dmh8/yCQdekRLi1m+TOp79MIY/MdTuoUTHKixBmUxTStgadR1WXcPrFJupgQug+P/kW+2BnyaMsj8I/agCC2EEs19QDIxkszazgCCJju2aBVhCeZqo7rDaTANIFwgTdWDIqVVIvi3eWaqImppk3gAbaH4hdfkQvpqA7m80dxx03jnpG0BbTeVWAuRsaqu7/C/HyO0BZnXwc4747ua9FKyEUHED69mLPftnH+lRGzMsNAKKLjtKnGm3+jywh8MZp2jfDkDqXL8rS0jPx+GV5WgzsNEvvOWBuA54TiASOgfA6xqB9maXlr3Q4XzXIvftNmTAd8rC6/7zsBxKWJF7L88FonvAuCHQEtGCWHCn1vICbhpdUJmOUFcep4NU+0cZ6Pon+vLCeBm50Q8Hrm9bm50WhjwiIbcrVpjS3LsPFp2kwNN7PY45PCc7Qnh8ZElUlDxwrZTaAD68mE1horXGajYl
 gxrJ2tyA
 TfkVYwjxu25pgmSpSp7+13m23G3rgKU4q3dY95jEo8p9RHAAG3vlECQLbdFj4+TNAWVRt7T5QOxkmUXYfBAHP9DqjQz0OOlD3+AcwsSA31t1p7m0HVD00AAOctK/uls1DxjNMtU9lxukCHvCup0BcOEfl8JWa/QLZuEgVBiS/4S946d3Oei3Vk6jEHt1HKRQpggfLVefxRz1u0eXnQKtzx/9YeKUkWoikt/HWkYbyxvdnZUeYEWYDvKx8O9VB3J5UsLmmbnSXaEP4/YD1UpQjNDMLh+CaPt4hRKS5v0WjrfWCptL8caa3iMBAP/E+CQcZ9L5RN14KiG66873ZcNvemJ1LfxfyKlr8RuY25weZkx+U0Ac0msQG30+xYPzgjkm90uC5aJxJijYnodOqHwX3+QahHngJ7aRNrSYESv4JJ9RxlaHq3D4TLxjS3TL/KQOGvqGywj2bKXv+HLxnrcFS1rL+8dZ2mqQ8c9TxkNysD4tRz3N+DuzkoeJ54VqZ0BydnvGlh1piyy8haIuKsP1QTr7yv+O4YdrNtdSKO3UW52WUY2A6coj7OyfR1JFPmapC+F9zfkIt35CySUNfSWuh/+AlJZzcEfsrxmEHrxfAJeDCfyyCLYKs6E4UOjbWjHRA3WF3Dp1nCJlh3BETRk4FFd8wKGZrIZrVNN3Xx3UjZA6CfoHHEoihs+IwzGrTdF3IwE5XpVesFRmogfHp8k7di8UcXuxhav7fuUoIbFt1Jzq7k4r4t/XsBU9P6IsF4q7L4tme5Dm4dn1i4BQR/AoibVKu4RTgBE44fk3Ge+WVO+9oDDne1AXnNtkSB47RIsBf724EQ6gvTb4CocK8jZ//LNE0E/d7l+euM1KGJ5GGR/8BB7/oC+LdHKYHiUKDiGrR2zGbTMZBxNJBtzUynwdqg5HLTmX2LwySUwd6i/WOvx14asaFs9Cj9wCdQXA5N8Loz/njzwO3Ccqr6WrAlzhLiIISLSrY
 Rafcc5kH
 TfI/qcGOUxIWvJ8LOxoDdomUfcRIkWGwHTtBEaFqAvDgD8IBYAP//BL1sE/u86vcmiTPcm0S8q6Yg7EzC+kYvWNZJJr/PhUy8adA9+jOZuhI/7o5sJuBk+x2Qx6sHP3mdHWzoW8jp+u9ZZ1T15kkY0/mC4Fj51jIg7+ZROzkwFWMZ/qz7+3JE/dSuZN9/zVsDc13/j7hUBkL167SsP55etgFtSGmW2K3CF7yNk4dnF642TLi4A4jcHwuucLmY6Ar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 16, 2026 at 4:52 PM EDT, Andrew Morton wrote:
> On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@sy=
zkaller.appspotmail.com> wrote:
>
>> Hello,
>>=20
>> syzbot found the following issue on:
>>=20
>> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.=
or..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D159274795800=
00
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da59830cba91a=
1981
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D805630f1453e49=
0427fa
>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e2=
55-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>=20
>> Unfortunately, I don't have any reproducer for this issue yet.
>>=20
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/=
d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlin=
ux-3d6d8176.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/=
bzImage-3d6d8176.xz
>>=20
>> IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
>> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>>=20
>> gadgetfs: bound to dummy_udc driver
>> ------------[ cut here ]------------
>> 1
>> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380=
 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
>
> Thanks.  drivers/usb/gadget is the offender.
>
> Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
> memory allocation".  https://share.gemini.google/5NzjyttO0ULc
>
> I expect an easy fix would be
>
> --- a/drivers/usb/gadget/legacy/inode.c~a
> +++ a/drivers/usb/gadget/legacy/inode.c
> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
>  		return -EBADMSG;
>  	}
> =20
> -	buf =3D kmalloc(len, GFP_KERNEL);
> +	buf =3D kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
>  	if (unlikely(!buf)) {
>  		mutex_unlock(&epdata->lock);
>  		return -ENOMEM;
>
> or do what Gemini said.  Me, I'll add some cc's and run away.

Let=E2=80=99s do this instead of suppressing kmalloc WARNs. Since a similar=
 WARN[1]
showed up yesterday and that WARN is better handled by a bound check,
I do not think we want to lose the WARN from kmalloc/the page allocator.

[1] https://lore.kernel.org/all/6a863306.ae6ddae5.3da009.0013.GAE@google.co=
m/

Like the patch below:

From 732ea7074854ac3495bbceb274cdd01966118e57 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 20 Aug 2026 09:19:12 -0400
Subject: [PATCH] USB: gadgetfs: do not WARN about excessively large memory
 allocations

GadgetFS passes an excessively large user input len to kmalloc and kmalloc
gives a WARN (see below for details). Suppress it by passing __GFP_NOWARN
to kmalloc used by both ep_write_iter() and ep_read_iter(). Follow the same
method as commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively
large memory allocations").

kmalloc is used to allocate physically contiguous memory for kernel
allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
because kmalloc allocates an order greater than MAX_PAGE_ORDER.

Fixes: b3c466ce5129 ("page allocator: do not sanity check order in the fast=
 path")
Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@googl=
e.com/
Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/gadget/legacy/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/=
inode.c
index d87a8ab515107..278a0a2b39f4c 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -604,7 +604,7 @@ ep_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return -EBADMSG;
 	}
=20
-	buf =3D kmalloc(len, GFP_KERNEL);
+	buf =3D kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
@@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from=
)
 		return -EBADMSG;
 	}
=20
-	buf =3D kmalloc(len, GFP_KERNEL);
+	buf =3D kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
--=20
2.53.0






--=20
Best Regards,
Yan, Zi


