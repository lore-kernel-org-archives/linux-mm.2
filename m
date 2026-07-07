Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 410EDC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA436B009E; Tue,  7 Jul 2026 16:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB736B009F; Tue,  7 Jul 2026 16:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72CA6B00A0; Tue,  7 Jul 2026 16:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8918B6B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:55:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 098351C8156
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:55:11 +0000 (UTC)
X-FDA: 84963185622.06.6E3C769
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2A6391A0006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:55:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hEaNRRUu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783457708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjsnMfz9WSERfumV8DEzwbtj80128N4tbi/gLa6YmJs=;
	b=qufikzQHDw5YcsZe3HzraFM/q25+fWSUlehdYDVLue8eAg41AOGnWSaJKA65DygvM9pYQ7
	QxAfRBbWvSXFtMqrhEzufLx1y07bTHKVKM+hhWGcxz9a4cANA1ihj4UqRx4HXBC+kGo1Y0
	n0RChKvelb6CdFMU8y2UhAjdBjRNNSk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hEaNRRUu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783457708;
	b=3jzUTy9Tmgs6lAjI1WJ7LV/2H7CE6NuhPStTGwZim92RLeVAHi2bk6MKHKXJFZtbzdryXR
	U0D6OpCeWRPtQL6GH9Py295SR2zOlghy++iN4q2WvLwSYK3F8JjnJtfRlWmccwEqdVs36F
	BVW8644yYgdmEjoyudChKf2hXA7YvWs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rgk2Nod3O0GbEJ/gFx1WXgQ5giEh9HasicxGpoMNMiyk2XTJnqfkc8WDO4JVV+3m4ca0Y2pd22ijlyi1uWxKauES/sHN2HPPvVl3h/2KhQLJR2MF9RpawekdCMCQYWJXHC7pp/l3vdyqb9Co9B28+74pli/FvvuZS6W1CKswnjvOhsUeH4LEViSpPXndV/GDEsadkntz5BtzUfTOeoDr7nyf8JnNbSPaqwtm01Q7pJcJf2T8imffFwnJprIZUsgL7/NB7WtE5bqEYIptf6B/0dxYXgXgP61pf9sc0DsVRy0ZvBBz45jQAFCWMZ0RkORyyF6M2DDw51dPsSh2S+9i2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjsnMfz9WSERfumV8DEzwbtj80128N4tbi/gLa6YmJs=;
 b=ODkFHzCTjZCfDPldpjxQUdprZ9u4pA/xyDw6RHB9EMUpy0w+PHOcsEj9shO1bXyAdwtcXzP/NnBTqEhozf775bhHixwJNh5s/wtTWSu6HR0wK6CGJdEdP9Yk42NNy0Mn+WwWeqGBWNZ9TbTVX6hNZZEosomonuGv34T9E1KMekDQeb88gKBYCnm4nJ8M4hd1nmGp77AceWQPIQ8vkmvfzPPa2pCFtNAJzzpk8MVcfAUzIU6tZnCVmqA0NoONsqDyoeAnefMbAP2Qz3MxZVRVWHEV/RCyz1OcOJ2GZXb1S3cit002oetTkzMDqh1ztkdjK3WyddK91A764F8PLOxRhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjsnMfz9WSERfumV8DEzwbtj80128N4tbi/gLa6YmJs=;
 b=hEaNRRUuQ904ScyNNVIi5j/aRTq7bgTg4R+81vKoO10TaZr/DlmqvkhYc/Ka+pu4yCKNLDn0EHVKlf9NgcHDlciQzQZPnSvvvjGm0wk2juYqewkwmshK1iBxkQYDsZ0cNWg8xNZNrES4rggzx3GCbCZA5wnUYok3Fd6jO4RXXzRCOjINyofgFQZpkBvY3743IFJom0XzAj9a3+oZlBn86Mc7/IYZshSPsU3rexMU8igE5vAcUFkyhPay6/tqVKSPWGA7jjpRfEh+ClvLF1VHhnKWH6YwF/VHblr6Z+4rO8XNkrAWuRS05jW+/IVGK+lGH+u2OE24qSSiEnFV0fJ2tw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB6530.namprd12.prod.outlook.com (2603:10b6:208:3a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 20:55:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 20:55:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 16:54:21 -0400
Message-Id: <DJSMZ6YCRHFI.2HX4JTG2QUKNG@nvidia.com>
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Brost"
 <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, <linux-mm@kvack.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
X-Mailer: aerc 0.21.0
References: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
 <20260706110113.920498961e5b29b212c7a199@linux-foundation.org>
 <DJRYJCAKQVT8.1U855ME5LF6EF@nvidia.com>
 <61cebac3-936b-4366-b1fc-35db70a2f1d0@huawei.com>
In-Reply-To: <61cebac3-936b-4366-b1fc-35db70a2f1d0@huawei.com>
X-ClientProxiedBy: CH0P221CA0034.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: 2557cfdb-395a-4bd6-219b-08dedc6a0241
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|18002099003|6133799003|4143699003|22082099003|56012099006|5023799004|11063799006|13003099007;
X-Microsoft-Antispam-Message-Info:
	RDHBOAOnR5/j8caE2KhsPRT33+pKa6q+9haGY/0X1pZhYaSDRZJhEVN8QQSqAodng+yw48LbxXvlXu8wkAFL+YXPTN98KUDuG6FmH4558Ui/JjlvHJgIVczaulbC3yxdP+NzshO96RsdI+fluiMhEreBL37M2fVoPkj+HP1pPPZGr96U23t0GYFQGIl7ezk2JqRwku6apNceFYS0IwU8ENoYPvoLA7wRRTxEEyygyKusbNX8wrvzM9GpSg9wSSnp/qzopqBG3duWz/27o34kAGSp3g6+oGbVaBEguzafqh9iLWv3OPhyRAZB8i6Fp0isVDECnMm1NJVSXwyV6yaXMuSjzRYB5RmuCIRKpNKZXt94iB2I/NSLA4xkdnBn0l6iVHLyxDJIEl8JxBvKsP8gFfnDTLA68wMUG4J3NVzqhm7Ijgs9yqzzLqBSpraahop3SNwA7oQs4md1ykpT3zvvYqxAPN+FZ9FWNjmTq5FoKaidv03I37JcC0/uGahkkDbhN0BebaSqES/DBj+AiiWQ0hadVZkExT+3LQG8PV73qx5/67UjVtRm7K3Wv6QSsV0KF3uEw1+uEijPAppRnLkoItAnLQp9Njm1hOznArYt9W0xgUgueKpFKeOHErpD+YwXn+LiCQknU36n2r1KIA3jUlcJ8gB++HsdDNVTR3JAbBg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(18002099003)(6133799003)(4143699003)(22082099003)(56012099006)(5023799004)(11063799006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWJCK2wzc2MzMWlSUXlOWTlXaUJyaFRWamlTVVRnU2xVbVBueFFJTTZOaUJD?=
 =?utf-8?B?dlUvZWFLK2N1cXNERm54T2IydFN4QldHYnBQSTdFcGc0VVY5OHp4eDduQ00y?=
 =?utf-8?B?aFNtemN5QXlLa1NteGFXWHorTEpGL2RyVm5UNkN4eWtSNkRqell4UWx1OWVa?=
 =?utf-8?B?WXpZQVpERGNaZEtUWWp1TEFtODV0aGRwYXdaYnlZdkFxZzBBM2dSVkh2Syt1?=
 =?utf-8?B?eklhMTZhU0I0Y1U4Q3prS2lGUTMzYVNkVzQ5b0sxN2xFTE15cU53R3lMQ3NL?=
 =?utf-8?B?ZUZqT1JiL3lSYkFhbmZ4RnJ5c1BiaTdaQnVUL1VqVnJRSkdBbytvbXNNcUR2?=
 =?utf-8?B?N0FjZ01teUxyYkdKdGloUkpEalliOWovbi9STStIaHdsWVZlUXhuTU1CNkE4?=
 =?utf-8?B?SWY0cmgzTlFvRjduLzRrK21CRkthK2kxdnB2cm9lc0JhQ1M5NkVOaE1rYk5n?=
 =?utf-8?B?cTRKS3NEWUYrOG0zcU92WmtZZ2psYXkzRmJGTkRZdG1vbUZnaWYwb0VLYXNF?=
 =?utf-8?B?YnljcTJUeitEUW5JTEJiSW5SejlVNHlSeHVYM004VHRvZ2psTjBqR0NTNnRn?=
 =?utf-8?B?T3NTWVhBTnQrdUtZTUdCb3VraTZXYVE4WXpFTWN1QSsvVURJcGVCSVA4RW1B?=
 =?utf-8?B?Vm1uWXRuenpIN25kbyttcDNBSW5hWm9rb2tTMkc3N2ZoNUNHV25Rcmt2VXI2?=
 =?utf-8?B?UFVpbXF5VmxOTUJwZWdUREh2YUxjeXhqNGFhdHR4eHBLRHJDWmxHTTBRWnNY?=
 =?utf-8?B?TVBKWXlQcnEybytxeUJ3d2hmdytGNzltMldRZURlQkJMZUJjSnNuYW5kaHNS?=
 =?utf-8?B?L2pENXF3QXRVY1NtN3prVHo0aE5Ea2cxU3BFMExqWGNMSGZoUUVJRGpSWm8x?=
 =?utf-8?B?ZFZXekl4SjBqQWVwZS8zbnBYenlON3htL1prUkVkd1RzeStUU3BWMlRhd0tG?=
 =?utf-8?B?TlFMYy9JQ0VxSktPVFRuZTRCTGJwNk1takRzdEFQZ2d4Z2wzaHoyL09rcTBD?=
 =?utf-8?B?MngxNVlFY1ByVkdPQUlGTDFQWDZ1eEsreU9aZzh6eWk5bFlMamFvbzZKSllQ?=
 =?utf-8?B?aU9Jam1OV2tTNU1XTUhKbHBuU1RyOFA4cXJlQmc5bGxrMUdSVzFLeGFCQ3Mr?=
 =?utf-8?B?ZDhUem9QYW5Dby9yNG81b2R2WVVha2RVRWw1ZzRFc056K1VKa1htM3VVRnZy?=
 =?utf-8?B?L2NZam5WQUhhY2lrWnZJOW50N2FBWmxzZnI3aXF5YTVRNFJGSXZZRFU0WlAx?=
 =?utf-8?B?WkFSb3dZcmt6Qmcwc2gzM24xSHhmSXpSRHNvUmFtUkc3a3lJTURLSkk5ai9o?=
 =?utf-8?B?U0lMdk5hME5wSHBCbG5GV0czRzNEY2VvcXFwZmhVVWQrTkZ0WFNFTzlEL3Zn?=
 =?utf-8?B?OGRpR2RydmFDZXdscW9kdGtjald0NnZFNFcyY3NFaXB5RUlaQmI2NEpzSmVi?=
 =?utf-8?B?QmptN1NsY0Q2eC9CZnV4akZSMTBudEVzUSt3YnBodit1QUJtUWZWamZKRXp2?=
 =?utf-8?B?dUlJeFEvZmZYc1IveHRMdkZyTjVzNVdZdStqQ2FndW5BcmQyUVFvRk8zNm1Y?=
 =?utf-8?B?VGpiYXdXMVp6WUVyUTFmV3U1ZW9jNHczRzFpTHFvS3BHZGpHeVRFVUVqb3NY?=
 =?utf-8?B?UkZLdmY3bk1OaDBLZE1ZS21za1grYlJCVk5wT3JQeXlmQ09ONlAyQkdFd3lK?=
 =?utf-8?B?VXlneHpuVEtWTFZqZUYzM0NSSTN1SWlMVEE1NXJBbWJvdkd3NGtyQ1BjdEZV?=
 =?utf-8?B?b3dHb0MxaWZLWmNGZVhMNk52anBSZU82Tk5pOHA5SG5VRDZwQkdvNTBmRDdY?=
 =?utf-8?B?MEc0TUpnMGRvTlRzU1ppeHNuMlB4bzZyOFJYeFpIdjNDaUNrc0xiWXFFb0lH?=
 =?utf-8?B?Z2RhalNXaWVVZ1BYeUtCQys2c2UxN1NGZk1WTzhSU2Y2Y2VubHZ5RDFscGw4?=
 =?utf-8?B?N25KV0FRZkl2YTNpb1pIKzhkL2IrMi9mazFDb290cVlSdXdZYW85OE5NRVdi?=
 =?utf-8?B?TXZTNDViR2FwUmR4WTFCeTMyVWxFMmNNeVNmenAvQktpMUM0bmVnZGp3d3ln?=
 =?utf-8?B?TTJjNnBHKzZpY2NsTGpOU1A2dkFFQUt4L1J6T1l3TEVDaFZGQ3VmaS9kd3Rm?=
 =?utf-8?B?QVNaWDVOd2dPWXJQdDY1eU0xVFdZNDI5N1FpL09YOTVGendhTVlqUUphWVp5?=
 =?utf-8?B?aHV6Y3BrdGJGcG9XS3pFR1FCMHpzYkNVMDB5NUJqaWlOTVZPSTdpSDJvSUgv?=
 =?utf-8?B?MmRWZ216dU9tWnlnZ0tTZVlOMkFhV0FaWEtDMUVvM1pTTzVLM09ENE8ycjlQ?=
 =?utf-8?Q?zzrWy6ELQOWh6PIVKx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2557cfdb-395a-4bd6-219b-08dedc6a0241
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 20:55:00.1023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5A+1H98Azl2nd7cvVYLy20lt6RusxQ5rJEbpoeh4UHVdiSl8Xf/odZZWYnhbNLb+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6530
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A6391A0006
X-Stat-Signature: h658p79x36k8mang8c6ihmwzoffhg3ag
X-HE-Tag: 1783457708-604901
X-HE-Meta: U2FsdGVkX1+2LRg5nC6Mu30znqTkEda8dEJmNa9L3A4LyNpMKymnZk+5pTN552PBUq9QPLAi408eMz0IHhAM7r/2yOVnB/2XBR23Rasl6lcq4kU49nAHqVgAlJMNiSntuWBgH6QFtduQfYYWrGzRZvWq6HBkjj1CKYYGX1PZ33A41LltUEUOwQTHc2L2xim+g2t4uWSP85/jMs5PFpsLmX/9JhhDVVZOfS2DGoNH+xo09EPlWyugRAFWaeVEJ4tNiTTzwSvxSiS68cZBiJkKy+a4H+KzxmelUtjw4Gim+3wwaMNoFZvqGXnNfRXlL1ZGiTOzdGnfjwFkGqshlLFBms5ceYy/nDsFtwKpb33pMPhri0k29AzAP8KtXoocMIGaFT9Ii+0eNkAjvJRw8BdNOlpEoLSXB3uc8OJqM1Q5PaU1ECfvnTaDgNCDaVUjeLrAjkY9mX/a2dUqAwTaqt1SVHopdGQ4JdBxHz3y4dyjEmEPvHhEW7aDeoi3ztpHfobW+cxRCp4F2M8gxQUMqXU8ndhoO60rpI58gqO7go9V7500xnV7zSYYIi7012OLu2t67gLYv7JjPP4e2R+9KiOTgNLJJdfo2aHodde3hyWBFFeGw/Ob2AR8K2/ce6r3Losjca0Fmt/YtUOFbxQRnmllMNVVgZuXW1XlM4rTkI8oyDLO/XlHN+1oGzAJUOUp8yqmQUzL5nl6OVzoDIQoe18KTYWiASpqD8PahhPhdMnUqd1kDGqWSaeOcaegV7MHW1KJ5GiTx2mM+rLIP4WcKbUlHt4xvdFKnq2aE8bzf2xN+Avydud7BZioVvwUW9z2/XwM9krAWanbXdSM2R3PY6kdMndxVOvZN49STdCxoAlEap8xonIsLzxxtfPohJztIwEau9zXBMLESQTnlKj55DRzyBo7nMK4LUBiFfp5/msPkCp75XG1mGyMq8ccY/X/DjYu/OKGDFJnZPNH+p6x0/0
 uR26knrp
 wdkjNpvrV7+UWgRpS5X1CY/1hlmNnNPsVpqNyUB27pr2Tgz1c3Q81rmu7aLFk1aaIVCpSp/CNnETu1m7x/jTUTXsQETeZJbeBu0n72Q8KwhsRpIF122LvjKBqjzTkYph5DdsyFPiFmTbk2ph1X2CYo7w8q4dCKP5QzvAGgEfdX/Z+qUeu/dU6jM50QK4zJFwUWbMk87oT42kJdRIjwc2O3p7sBQBMTMpVCeoi/rtQwsErFLf/gDgKkogJCXcS/NxmrO7tNYUPr27ZyJLQgC+wvJxm6+BkGDzOk1RzscFYUce8oiJmCdNGEw/IMpdkA2oL3LYpKA0bVJYoQu9FMawal6dtuxWWjvpg0I4oqFmek4ABzB7HYaFzzD9QtQ4ML+gWVl7xK63/pcLn/Tu5BCqiybqRpBypqRsBYAiRHuZmRoL1iB1V6lEIt3fqGwN/5QmnAlbNZvU9W2o4otZ3ZSJMXCeJMCxqdGAEva9cNb2B/q18bSzNzSMdZ1n7+uy3TXumu5pUGP0oqMV7NNE7dyxDWh44bsfv2mVFgiuOkftKIwkH4qN6WuWGw+bk8Fhbm79N2ae9KikgNXv2hh4utRdhISrluvEu8W/Zzg8NXxuF38qlufVkXJM54EODcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 7, 2026 at 4:00 AM EDT, Kefeng Wang wrote:
>
>
> On 7/7/2026 9:45 AM, Zi Yan wrote:
>> On Mon Jul 6, 2026 at 2:01 PM EDT, Andrew Morton wrote:
>>> On Mon, 6 Jul 2026 19:19:58 +0800 Kefeng Wang <wangkefeng.wang@huawei.c=
om> wrote:
>>>
>>>> pte_pfn() and pte_dirty() have undefined behaviour when called on a
>>>> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
>>>> invoked on non-present entries (e.g., swap PTEs), leading to potential
>>>> crashes from pte_pfn() or incorrect dirty folio accounting from
>>>> pte_dirty(). Fix both by guarding with pte_present() checks.
>>>>
>>>> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page"=
)
>>>> Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_pag=
e()")
>>>
>>> Should we cc:stable?
>
> Yes.
>
>
>>>
>>> Sashiko might have found a pre-existing issue:
>>> 	https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.wan=
g@huawei.com
>>=20
>> I looked into the issue and came up with a fix below. It looks ugly, so
>> feel free to make a better one out of it.
>>=20
>>  From 7fa06512638a0febb79a00dba63f12818a85788b Mon Sep 17 00:00:00 2001
>> From: Zi Yan <ziy@nvidia.com>
>> Date: Mon, 6 Jul 2026 21:25:29 -0400
>> Subject: [PATCH] mm/migrate_device: avoid scanning/collecting PFNs withi=
n a
>>   PMD
>>=20
>> migrate_vma_collect_pmd() can drop pte lock to split a large folio and
>> restart. But the code does not handle restart properly and can cause
>> collecting inconsistent PFNs and overflowing migrate->dst and migrate->s=
rc
>> arrays. Fix it by:
>> 1. avoiding migrate_vma_collect_huge_pmd() if collection is in progress,
>> 2. skipping the rest of the range if pmd no longer points to a pte page.
>>=20
>> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zon=
e device pages")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefe=
ng.wang@huawei.com
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
>
> Thank you for your fix, it looks good, there is some repetition (3
> times) regarding flush+skip in migrate_vma_collect_pmd(), but for bug
> fixes, keep it minimal is better. I don't have new ideas to improve it.
>

OK, let me send it properly.

>> ---
>>   mm/migrate_device.c | 18 ++++++++++++++++--
>>   1 file changed, 16 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 052167f9ad547..d86b3989d0c59 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -257,7 +257,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>   	pte_t *ptep;
>>  =20
>>   again:
>> -	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>> +	/*
>> +	 * Only check pmd when addr is at start, namely no pte is scanned or
>> +	 * collected, to avoid collecting inconsistent PFNs.
>> +	 */
>> +	if (addr =3D=3D start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)=
)) {
>>   		int ret =3D migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fau=
lt_folio);
>>  =20
>>   		if (ret =3D=3D -EAGAIN)
>> @@ -267,8 +271,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>   	}
>>  =20
>>   	ptep =3D pte_offset_map_lock(mm, pmdp, start, &ptl);
>> -	if (!ptep)
>> +	if (!ptep) {
>> +		/*
>> +		 * Skip the rest if pmd becomes huge or cleared. Flush if any
>> +		 * pte is modified
>> +		 */
>> +		if (addr !=3D start) {
>> +			if (unmapped)
>> +				flush_tlb_range(walk->vma, start, end);
>> +			return migrate_vma_collect_skip(addr, end, walk);
>> +		}
>>   		goto again;
>> +	}
>>   	lazy_mmu_mode_enable();
>>   	ptep +=3D (addr - start) / PAGE_SIZE;
>>  =20




--=20
Best Regards,
Yan, Zi


