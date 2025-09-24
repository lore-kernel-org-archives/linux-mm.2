Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4161CCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 02:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CC48E0005; Tue, 23 Sep 2025 22:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C698E0001; Tue, 23 Sep 2025 22:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614DF8E0005; Tue, 23 Sep 2025 22:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3D18E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:03:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6D6513A9F8
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:03:28 +0000 (UTC)
X-FDA: 83922496896.12.1310E22
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010063.outbound.protection.outlook.com [52.101.56.63])
	by imf15.hostedemail.com (Postfix) with ESMTP id 132A4A001A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:03:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JF1imJE1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758679406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6yNSDydaKds2SRYx1VXbpHfj31f7Sr4HF3ahyv+eLU=;
	b=GjI6OVoEKql8bWxHJRbgpdhZyH/s1kCvQP/UyqZz8UlQNWX8VGJM4E2xwEguYXb2rvWP7G
	t6eIxy1opsdNmNRvjkOjp5olZvMa+GbEa7fY1rAvFzNQc48bmkyfQZjd+U8FXOUhuBb1gn
	fn7gnMeyYTmGYNSm8FEO3Yl1i6aBpGA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JF1imJE1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758679406; a=rsa-sha256;
	cv=pass;
	b=mrXlNkv5gO5JxUyOJ0hii288J23PFEuTj+qExdIKs7yBx4wLs/ePFdNyEphhE8MZnkRXJQ
	YQJb/uAEZUHAPnciD8VyHevZhkbAlcaN8778yHq3dc5dhggawjwrMg/Ib0V+IxNPs3ofXi
	6pjezDkosabTpWu6B3jqnqbydZN9eVk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBjBgo3eKmQDELyzY3BWaaPb83q2S/o+VsWmy1U6epFycO+1B3/oEDcvtAOeaS0OILmk8VYqSD0Qr0+4lAbPwDE4RQra5MMF9+SZ9r6fdwLyghrjJWdqepzhExAwQyynWNFRa04nOC1gmV1xgFemGVV57t17GnBA6P1g6YitzcpP46GwIIIKao0pReekeqiE7qgEdFUdFc+lRIisOkk2xC7H42Vy2/Gb8q7uImDJ6iT2mh2DChIHo9loYDUUEWm64jXHaBCntGVg4KSdomjdYP3AKjxRj74SZnZlUUKdDdNINGl1g/dp/9L7XYLWwUmL4ltXKxrl2N+rtYuXyl3TCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6yNSDydaKds2SRYx1VXbpHfj31f7Sr4HF3ahyv+eLU=;
 b=pLgO6eNt3kHInx134MSg+YenEXy5pQ4txDUWlkukCK28A3/q82XPrdUusB7V1i294WN/mbyrTvwqLugzkcl112slDdKtmEc6oDh/F8rDFZlZGqyNvu5AWJNPI8+hMIGqt4YpvpJO3OWjRlDGgRw+Q5ryFgfOC3PfqQanrRn6+UwzomAG49K+ObcCr8d4Ba59J8nMvx5C/RTTy8ACAvzS7Py/L+5s0mf4DUAFKIBoZNtZcuaVXy/QRFtCE9AFVVtL3fOemmJ9GyuY0o2ACCTr0RzkH5Vlh/cyXbSknjtVO96fo0xD2pyrRqI1AcobhvBh5axDmHVcLWlADn1OX0YTiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6yNSDydaKds2SRYx1VXbpHfj31f7Sr4HF3ahyv+eLU=;
 b=JF1imJE1XUQYScq7ZsEcfQ/uVi3dgcpQ+Cfj7wtAXDO4iE6yhHoS2C339WIvsZRK4t16c069ou6tMmxBFqQ9K5KGyvraBoM8w764/TvJCfM2MQakD1QVZg74uXjBITWhozayGnbROMbjK9TejDAsqfoskmZYeOQXRF5lpudVXZlDdj/isDEykup7e2E9e5TwVn+HclkMKlzSSooqKhfUU1OmPJbKeM078Oln276oU7dr4ThxY9MSxUZMC/54XgGbSTJAr88X4iEHbSSZZEpwfi9AilakTpj948gMXGlAyRaRBCMlv+rcYSIgBC+kWu3DvTN8WRL0HZ2Jt2cJ4kxgIA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7235.namprd12.prod.outlook.com (2603:10b6:510:206::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Wed, 24 Sep
 2025 02:03:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Wed, 24 Sep 2025
 02:03:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org,
 david@redhat.com, willy@infradead.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, vkoul@kernel.org, lucas.demarchi@intel.com,
 rdunlap@infradead.org, jgg@ziepe.ca, kuba@kernel.org, justonli@chromium.org,
 ivecera@redhat.com, dave.jiang@intel.com, Jonathan.Cameron@huawei.com,
 dan.j.williams@intel.com, rientjes@google.com,
 Raghavendra.KodsaraThimmappa@amd.com, bharata@amd.com,
 alirad.malek@zptcorp.com, yiannis@zptcorp.com, weixugc@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC V3 0/9] Accelerate page migration with batch copying and
 hardware offload
Date: Tue, 23 Sep 2025 22:03:18 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <C8E561B3-B9DB-4F58-A2C7-4EE17E08A993@nvidia.com>
In-Reply-To: <87plbghb66.fsf@DESKTOP-5N7EMDA>
References: <20250923174752.35701-1-shivankg@amd.com>
 <87plbghb66.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0401.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: f74df7c6-d13f-468c-8967-08ddfb0e8a0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c3yQuTDeK9DIxsFBYwd5N9kLfgbMMU15Ejx6oglHsLlEqghtcciRO0ASsEpk?=
 =?us-ascii?Q?d+pb1uzYQAeS73o+SOAm/Gc/OKDlsfRajpHrSEE7ANik2pyqKqWpcK/WvkS3?=
 =?us-ascii?Q?s/9wny1xyWdtPnJaJUXIXux2GaN8FBrfLGlMdyGdeZqiGBSqzHSD2iNXHHmv?=
 =?us-ascii?Q?ThA833vYinJffzBsj9fAmfhZqVpRWskEIjTZ4bXX8ksL5G/dr7hbhhQRsejH?=
 =?us-ascii?Q?AlJjRXfKvWAWH9pLnzaaGAHQhoBIp6fWhsJ/6vuKMB5V2BOns6wi6xJ8JbTi?=
 =?us-ascii?Q?tKvkqa1ngPlPohhBFkcFvSzPEgfaqw1aiMnRieUVB1DkbFEmjPK4GeukyvIF?=
 =?us-ascii?Q?MQPp6KMut+mdItEMNnYARl5+x3UPvpDLlCwFV3JubChr1qVpNSlLCj+3plxV?=
 =?us-ascii?Q?ztLYulR3dF28kvTtBDeePlLfIIgMWIZ/3iwB2fBotH2f2SAKNDg9n4/Lb+yI?=
 =?us-ascii?Q?E5w+CxM1fu0te/0gF+cHyoCFkl+lsVsbrtT66tLCcR353B3KsfIchsRMfW+7?=
 =?us-ascii?Q?1OEaMihalb0xhl8nlqSOkTTHT5X8hnKpMDHugJgX5+bZ2D4E5ViTMksjU4nh?=
 =?us-ascii?Q?xDDYHp2m3U5/JfsEvP5HQbtdumCKTTf1KsMhI7ab1QUZRwBf8zW55IGSTBir?=
 =?us-ascii?Q?NJ+nL1MgBsCwzpOXIkeRLX+3zVzn0cXk4tvO8XvBf3hCu81gDOSz8aMHkGQ0?=
 =?us-ascii?Q?HKYJabSD2o6b75igbeMsPg/OUbo1OpqnUEzQrygHhbTH0FZkHHFYjqXkmqSP?=
 =?us-ascii?Q?9itVb3RmKRODoiJCxVGPxrpdOY+qjoMqMxEuZppoJ1uAuWmTBDKmz/CMyQ3t?=
 =?us-ascii?Q?s3iZAeP/h6JuL6tUeeFAJO/V1fED+2AUhQmetoX6ESMQHNrDNjpMDLLbFV5v?=
 =?us-ascii?Q?D2pkVq78/kRYFfQVrfixlaSA0AmXxBGNfkulLb+WcORxJ/XIYUvJie7sfQ1e?=
 =?us-ascii?Q?SvVZ08X2Ew1STBacKdsvT+d2WUrZlIqmViTTEgf+yAyCNVGzwtbLZKK8C94q?=
 =?us-ascii?Q?lk1pbMfUVV08RcxJ4OdIAjJTyEpMmZlepn40FKpExvRca8EammlJRHY5c8o2?=
 =?us-ascii?Q?qq0+OCYxma4qdV47xU9oed2yAP/atRAEOHPYACxjsPXonFALjXtrztFEly6B?=
 =?us-ascii?Q?tOF826Fo19OXr6jz0/vCnsjdfpxV5DORzSP4VQCQ5KhEcZtBkAsBLgaUE8Yd?=
 =?us-ascii?Q?iJNu+J3KcdaEE9WNmzFtaEqJuR9sYXfh6A+00RslB0PMsHlEQyHeO3gs7wjS?=
 =?us-ascii?Q?xOX30njtRBEj9LT3OBSp79aEiYA73e/51tjLhOYfXbEWe90Ysa54+SlZDKoq?=
 =?us-ascii?Q?6HvtB4YJ1US2r+BB3nHsbZE2Al2L/Y4PzcYJIqHGxRDcP6m/ijTIue/B71cQ?=
 =?us-ascii?Q?/58n9b80OEL/6FsaLmkOqHMPzdhi9vhp5+1Hqo3aV9islfm5agm/UbQZ+R09?=
 =?us-ascii?Q?3zYMpZmT9tU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xfcMf9ZgJF5BCvwcDM1UX6Stjy16J5TTS+1BmHi/gSn6v3eCHa652JpXZF78?=
 =?us-ascii?Q?TkvWXP4sBvws2BDeTQK3kvXAbWv7NFYROmY0efZLWNidK3RriU15dm2OHwyJ?=
 =?us-ascii?Q?aHf01GZjEfPT0sKJsXESC6ab9ZJrl3HucUiNt79fLuiO0WomDdRMIyp5ToY3?=
 =?us-ascii?Q?o6OqWmVLZOCHHcPk+E8nRWGzzJLveiMfTReubzP46hqxK78uUOlGFhKfa61g?=
 =?us-ascii?Q?TIxCLeFbKOCBQYgpGabew9Cd47W3Xfz+VjodR5sJunJyzbyIAUbiiJFfmP46?=
 =?us-ascii?Q?07qG2aC+kxKYrCOckaEgqc3+O23A6FhVFKAdgQNMq+Xb6xyQYwE0JyvYvIvu?=
 =?us-ascii?Q?Pc/caTlupEXgyl3lR1Qb1xx7kkcGuYI1jdKInwOo7XMBomJVua0E0X8d6ohu?=
 =?us-ascii?Q?lBMLmbUFFyifWky4kqhL0o79L48ZOqlJayyH0dI/DpuzzrV5mnIiL2GqXKHx?=
 =?us-ascii?Q?yMGqZk3rrrDbTC1Z8f1TgtCsErKPGpDKRZiV0SAWgGukryWM0frCKBWHH/97?=
 =?us-ascii?Q?as4NODPoZ4uH8RUemtgNB/OdgYbefxKLfiG4iC9PnHhSIEcGjQw+lCzrWcl+?=
 =?us-ascii?Q?92M+x1pAoMdDwwrAXyNOG9iMNEH2awXpwc2SuCFJDV+6IRBzRvjNf8UiCXu8?=
 =?us-ascii?Q?KNp51LDgZlSTnDze6UXvF2YK0vktIJn1oOtnNB19V7JUfp6GGt0blWAx8Ep0?=
 =?us-ascii?Q?a2dnzryv//hyqnQ1VdEKcYuQGN6ZFUM1rxVhs+vn3ZfL/D1og5r3xCG7XhZ/?=
 =?us-ascii?Q?YniYCcJ1/7IQmL6WwMj0furvv5ZFoWJj7CzLHhZWqKE5MUbcrThvNZweWiTP?=
 =?us-ascii?Q?gDx1xPIMoQBOTMeAK8TVqZQfpY8E5uUsM0BeCt53HpdORkb3KoPKXajB3D/V?=
 =?us-ascii?Q?x0Hr8BrMeHL3w08B9o1XRlF/cSPRlD4kBZWwNHg/D3qPdoRfZ3ZZGqeebjGv?=
 =?us-ascii?Q?SJ4znIA4Rr9Y06eNn9pN1V2vqICeseWRc86uGetb5j8A0xpPKJRtMPKXfuBe?=
 =?us-ascii?Q?KC9iwQflTG8GRDoKwBl/NLuZvBbSkHhHOVs3MPvZqK2jWoi+r9uccgKqSMOe?=
 =?us-ascii?Q?qRBALWZz6yiAws7tYD5qmr8j8unP76JUyaCS51ym8vrDDjML5Q2RCKhEPRg4?=
 =?us-ascii?Q?XkuyQpp9Zcwms4nowUqIuFYxb1b9Exjh4DjNVJX8OZnpg/abJO6eyNY0br5t?=
 =?us-ascii?Q?VVYlEgkXzBdmrz4mf+kz7lUa31JiaADNxxfzFdomFMQmXeg7lltmQDG/B9kw?=
 =?us-ascii?Q?C8MqmZ2GlbSvdDXqMTbWE5MrkjcQT+A7q+9gTw6U8jyuzSgYQxERWwiXvHfh?=
 =?us-ascii?Q?9cx9PCsLAUxp+Bw18vdIb+8s5P8AAUX6eiNUclkhoZ2Q+hxgTwAcRUPfpJo5?=
 =?us-ascii?Q?9hcakM4A0zj/iSAzHlCHuj8wNlfQB0li6u4KS+h43SsLGxaBxEa//S1Ma2TL?=
 =?us-ascii?Q?tVgY0a3A59NYqx8LIuS4famDrc9vjHxXYU33pv+8lRpO7tP/Ryz1kC/N1lx8?=
 =?us-ascii?Q?3hhxSMTk7D3STL49mxel0bEk1lPzjsoElYC3l/amgsAMDSBbg55AU3j9AGpx?=
 =?us-ascii?Q?uFixrHg26WMdxeiOvwmchQhxlCb7MONeBRL1jPVz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f74df7c6-d13f-468c-8967-08ddfb0e8a0a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 02:03:22.2379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ObVlkNxRaqUvbGKMczGNOK1BiciH5+AS74sHJAU7Wgs6uLBcG11+ECSJf4mP8K/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7235
X-Rspamd-Queue-Id: 132A4A001A
X-Rspamd-Server: rspam05
X-Stat-Signature: izy5oe74uztmz3fa7nyy78q5zkzipnk6
X-Rspam-User: 
X-HE-Tag: 1758679405-921790
X-HE-Meta: U2FsdGVkX18xvheDE1+PiNeycVpjszNBMzUXBpu/ahni4wQgbyqTFRJlE3xliZHs9kFC2JBwqZwcPglBOUNwcVMCFkT9pXBOb7qtRpSVnd61Bbgv7UpYMCocwgDrPq40NCuah5AnOx/dGNUKSWmpAZw+YdiTFpZuKcRbLj846/USsVCo4JD5DikrJe24NLWcfpB/l8p0b6M3AYjLEuSH/sfxw+IGzIHNjXCyQ/t0/UZyR235J72wU7JByuVgKgA4mpw93KV9t421DbaL7HrNjoKjrxArd2NB2UP0Q5sdZZ/DBUxJ/7hAaZw5K3ehvuQNxXr74ejkrt1CvKNFhYHA48nYPs09phYbyMWSuZ6AEDnh36ke6FRJ42fTgZil4e6npiCbEXxmzBD2f5tGOZw6FzbI6y0EE1T9SKsyG7O3cYLVsI+cPjbKdm+AIaqdLOIgzaBxCN42Dm63mP9Rhgb+vx8OMscmyQ5RjCQjWk9TrvMTNAW82gRL8kwD+dT/LwVmIoIGHtnjukP0IEymra43Vs0JPx+kS9p2GqSIVzzHSHMdlv9MGej2UN9x08PiMytbO5Vtj65qLj6C9pNogB3LzEXZSixmYdNgZ3t1wFZc2294lrnWillble3VIi6stPChjhPWr4auKSCsgMhf5wq+POhdNx0+2MyDh5ygmJgItfVwcni7zBk1C9c3gSSWvQcScDEVBZFAaPwTfyle2MvEhsa4MxELfB8XPmiYMiKHMBPjpjEYjdpL1cI9GN5r5yOdcR8eo5eLvaDfOzdKw7QtEtxoVWb/AYthP8DeAaBeuSqvMwZ3fXFsDf3jofgXdol5KP900xNq8m3QT9p/S/QVz7phnWro1RyHUXBnffYuHCZxyj7SXruzldA8hUstnqhk73acNQT7ThAjziUXrPK0/L3UbUkfiQ2Uhx/gyxET+jMcnkIP02JW8Y4l5eXDWM1vB0+4lu/FH4mKHDqm5ue
 krnb2Prn
 WAhOWTHBlyxRkxHevWS9QhIa1jmXZN7YjIF3UDGx51Mrdd6OoPZOLpQ0nAW66DTC06EQGYLy5QGpRzSh4uij3kGm+kMPL9Em0xStkJOFbZJ+decCqMvBUC/muG929pqikwj8COLRlj0Ifg3tIU/vFBB6EpmFo1etLdpZzj/YS0q+74ilUnxs7tOgHRzDrkFA1M0k97uWEjspigSGmCP0BXmuolrmJ6lbgI65WjMxw4b0qZN4MgstIb/ETkhj4c3DlXpzBVir2rS9xj8zyhQGm+hwkWttR/HxU8YPgxGq8Yzdr3Z1uc9neEJAB7NEbV+ejzpIwuSP3MMTvl8vGWFuOs5nWBuFGz0x45BAAUeoAhsCf3jECSDr4GlYLj8sRia6WMbFZ8Fk2jZusl+kw9npjuya930Jmzl42ZbMFNN6YBbzy8MTeBttVFZzM3AD9w525IvQuuRpHgSQRtRJ5cAeVnfYblf3i5HGSfeqzWd7+553GJlwccM+kYZw/VrKM9kGgTlXT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Sep 2025, at 21:49, Huang, Ying wrote:

> Hi, Shivank,
>
> Thanks for working on this!
>
> Shivank Garg <shivankg@amd.com> writes:
>
>> This is the third RFC of the patchset to enhance page migration by batching
>> folio-copy operations and enabling acceleration via multi-threaded CPU or
>> DMA offload.
>>
>> Single-threaded, folio-by-folio copying bottlenecks page migration
>> in modern systems with deep memory hierarchies, especially for large
>> folios where copy overhead dominates, leaving significant hardware
>> potential untapped.
>>
>> By batching the copy phase, we create an opportunity for significant
>> hardware acceleration. This series builds a framework for this acceleration
>> and provides two initial offload driver implementations: one using multiple
>> CPU threads (mtcopy) and another leveraging the DMAEngine subsystem (dcbm).
>>
>> This version incorporates significant feedback to improve correctness,
>> robustness, and the efficiency of the DMA offload path.
>>
>> Changelog since V2:
>>
>> 1. DMA Engine Rewrite:
>>    - Switched from per-folio dma_map_page() to batch dma_map_sgtable()
>>    - Single completion interrupt per batch (reduced overhead)
>>    - Order of magnitude improvement in setup time for large batches
>> 2. Code cleanups and refactoring
>> 3. Rebased on latest mainline (6.17-rc6+)
>>
>> MOTIVATION:
>> -----------
>>
>> Current Migration Flow:
>> [ move_pages(), Compaction, Tiering, etc. ]
>>               |
>>               v
>>      [ migrate_pages() ] // Common entry point
>>               |
>>               v
>>     [ migrate_pages_batch() ] // NR_MAX_BATCHED_MIGRATION (512) folios at a time
>>       |
>>       |--> [ migrate_folio_unmap() ]
>>       |
>>       |--> [ try_to_unmap_flush() ] // Perform a single, batched TLB flush
>>       |
>>       |--> [ migrate_folios_move() ] // Bottleneck: Interleaved copy
>>            - For each folio:
>>              - Metadata prep: Copy flags, mappings, etc.
>>              - folio_copy()  <-- Single-threaded, serial data copy.
>>              - Update PTEs & finalize for that single folio.
>>
>> Understanding overheads in page migration (move_pages() syscall):
>>
>> Total move_pages() overheads = folio_copy() + Other overheads
>> 1. folio_copy() is the core copy operation that interests us.
>> 2. The remaining operations are user/kernel transitions, page table walks,
>> locking, folio unmap, dst folio alloc, TLB flush, copying flags, updating
>> mappings and PTEs etc. that contribute to the remaining overheads.
>>
>> Percentage of folio_copy() overheads in move_pages(N pages) syscall time:
>> Number of pages being migrated and folio size:
>>             4KB     2MB
>> 1 page     <1%     ~66%
>> 512 page   ~35%    ~97%
>>
>> Based on Amdahl's Law, optimizing folio_copy() for large pages offers a
>> substantial performance opportunity.
>>
>> move_pages() syscall speedup = 1 / ((1 - F) + (F / S))
>> Where F is the fraction of time spent in folio_copy() and S is the speedup of
>> folio_copy().
>>
>> For 4KB folios, folio copy overheads are significantly small in single-page
>> migrations to impact overall speedup, even for 512 pages, maximum theoretical
>> speedup is limited to ~1.54x with infinite folio_copy() speedup.
>>
>> For 2MB THPs, folio copy overheads are significant even in single page
>> migrations, with a theoretical speedup of ~3x with infinite folio_copy()
>> speedup and up to ~33x for 512 pages.
>>
>> A realistic value of S (speedup of folio_copy()) is 7.5x for DMA offload
>> based on my measurements for copying 512 2MB pages.
>> This gives move_pages(), a practical speedup of 6.3x for 512 2MB page (also
>> observed in the experiments below).
>>
>> DESIGN: A Pluggable Migrator Framework
>> ---------------------------------------
>>
>> Introduce migrate_folios_batch_move():
>>
>> [ migrate_pages_batch() ]
>>     |
>>     |--> migrate_folio_unmap()
>>     |
>>     |--> try_to_unmap_flush()
>>     |
>>     +--> [ migrate_folios_batch_move() ] // new batched design
>>             |
>>             |--> Metadata migration
>>             |    - Metadata prep: Copy flags, mappings, etc.
>>             |    - Use MIGRATE_NO_COPY to skip the actual data copy.
>>             |
>>             |--> Batch copy folio data
>>             |    - Migrator is configurable at runtime via sysfs.
>>             |
>>             |          static_call(_folios_copy) // Pluggable migrators
>>             |          /          |            \
>>             |         v           v             v
>>             | [ Default ]  [ MT CPU copy ]  [ DMA Offload ]
>>             |
>>             +--> Update PTEs to point to dst folios and complete migration.
>>
>
> I just jump in the discussion, so this may be discussed before already.
> Sorry if so.  Why not
>
> migrate_folios_unmap()
> try_to_unmap_flush()
> copy folios in parallel if possible
> migrate_folios_move(): with MIGRATE_NO_COPY?

Since in move_to_new_folio(), there are various migration preparation
works, which can fail. Copying folios regardless might lead to some
unnecessary work. What is your take on this?

>
>> User Control of Migrator:
>>
>> # echo 1 > /sys/kernel/dcbm/offloading
>>    |
>>    +--> Driver's sysfs handler
>>         |
>>         +--> calls start_offloading(&cpu_migrator)
>>               |
>>               +--> calls offc_update_migrator()
>>                     |
>>                     +--> static_call_update(_folios_copy, mig->migrate_offc)
>>
>> Later, During Migration ...
>> migrate_folios_batch_move()
>>     |
>>     +--> static_call(_folios_copy) // Now dispatches to the selected migrator
>>           |
>>           +-> [ mtcopy | dcbm | kernel_default ]
>>
>
> [snip]
>
> ---
> Best Regards,
> Huang, Ying


Best Regards,
Yan, Zi

