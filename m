Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 793A1C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 19:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403596B016D; Wed, 12 Aug 2026 15:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38D996B0172; Wed, 12 Aug 2026 15:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E426B0173; Wed, 12 Aug 2026 15:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2CB96B016D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:59:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61DE8A0462
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:59:01 +0000 (UTC)
X-FDA: 85093680882.05.8D92A33
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78F3F140004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:58:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g3qJQXou;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786564738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNy2RlgN+93tij2pItmSE+mEg9Su1aKTCJppfcTAfps=;
	b=jt4MmRWhjnybGDV1YNew/wIXpaHrwB8JkoFa2z7aRILLhrKx1MQng3rv7KlfRZxk2+5gzC
	+Me+Zxbsnt7hQyoYV7CoSALgG+pZT8cknPL1RPFfN5GAgQleBlQF/teieloC+OXJ6i93Bi
	va8P8aunNklHSAZWmePjDwV3HYMTwyM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g3qJQXou;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786564738;
	b=1diA+d3D8Tre9YtVrcPLNmLRKFtPEzNcD+FCulIff8gsKnlxXEsPb2ZC656sPlHmktlm12
	bjz0HOL27QsXzbe1v9c6dbZbudaqu67AoT+l/r3GEZW5BxEWrFWK47wsqoo/3ig/VxfTsC
	qsuUeJjAcNZ5VG5OTw5th7ySpK/sbwU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nj6iqxz49GfzxzLdyLMbbfl77Jg+n2OFlhal0mNEXOJ4oGYWBBJkgBeuOpkAyfjOx5T5zVwUYuL4bBD5s6CLHWtPjd/Ww7SXHtdQ5+6XRt0ADjRQPezgeLSrHgtKP3enR0MEZA8KB1jf9RFSPb78DoVMFVhLJ1SpqXNgw+XCszvmVYST5doycF6ugC+a5wQy27s3CZm9xFduVQml14KMDGrTyg0Y0fScjrG44Ui/3sI/zPzY5nL250M53WZWByDBaqT8wXnTObD0nA/fPQE3o91gudbrLdvYQ96DiHtpB3wMuMjYHsRjE/1VwpF1jErWh8K5MobxLP2SUZNL3E+1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNy2RlgN+93tij2pItmSE+mEg9Su1aKTCJppfcTAfps=;
 b=wJHpI5zF+cUKWp33b4qiIXC4LLlzyCa/ezP59wQmWeb8BpkflYAev1DgcUZEar65z6GmypFr6LOCWYybwbGLfiSKZ0QeSA4kj+RMKSSGSFc+fQpWwWt0mNFliWnv0eBxK1jEifC/nal+SvfqpKg+53KBU8MQbCA0hfPr5fOvKlgoTYpR7O4f6fH+9+67qgWoIYkehbiIbq5axSmDBBtWOT/YrAl8Q7sNYQ+Lxi3LVPa+H19yHIMW9hbC2m/7ZdJjK84DTUR8+5WAuiOWTjcIzvEDXQVd6fkka8psVgQdHVxXGlqbVA7vrtfccYBbd2G8bd+vIvMQpv5irEH3sGkr4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNy2RlgN+93tij2pItmSE+mEg9Su1aKTCJppfcTAfps=;
 b=g3qJQXoucKN4LiEgQ9UU3YOV/1AcEAuDuLSVgL9WCgW2zVjxoT4+PrvgtbHBDSqDFUkYsuSyPdh3oTVOYsfsnMLDz3hqeOj4JOfCEUeQ98NvHG1nE2ZWwn73mCXY2xbH2N/9AnUUl/dtpYOZqeYBlmn7H3W7n0/trjmWaeoir41gSeLcJxTBWSwQHpemoYeejLdB/wwjUTSeA9QO9xU4VxibbTaazzg3E2thq4cq3HHnRfxI7UZNtAuhAGF5dfaAr7Uov9VY4CJQ41ntrluidEN/7uPwsyahtY9PEs4QsHULTFH6xrWkVQ1F5kVcPWUnvThQZk+Q/c8Uwi9XjSn1qA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8135.namprd12.prod.outlook.com (2603:10b6:a03:4f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Wed, 12 Aug
 2026 19:58:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Wed, 12 Aug 2026
 19:58:53 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Aug 2026 15:58:50 -0400
Message-Id: <DKN8CAY6257F.6TB3KM9OX4AV@nvidia.com>
Subject: Re: [PATCH RFC 13/14] treewide: adjust comments on PagePrivate and
 PG_private
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Zi Yan"
 <ziy@nvidia.com>, "Ilya Dryomov" <idryomov@gmail.com>, "Alex Markuze"
 <amarkuze@redhat.com>, "Viacheslav Dubeyko" <slava@dubeyko.com>, "Trond
 Myklebust" <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>,
 "Richard Weinberger" <richard@nod.at>, "Zhihao Cheng"
 <chengzhihao1@huawei.com>, <ceph-devel@vger.kernel.org>,
 <linux-nfs@vger.kernel.org>, <linux-mtd@lists.infradead.org>
To: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-13-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-13-142c97ba3562@nvidia.com>
X-ClientProxiedBy: YQBPR0101CA0188.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: b08462ee-0485-4256-f9d6-08def8ac22be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	O3k5fabA0ZwgSZA7eGIl1YsQm/52dhAiwJFGse/HtG5BRVOyq4IS4jhvnBL18BJH501aCBbGpZUkzuHmffwsLCBTcuxY7u27odzg47HYCB20t8+3dDwWy8mQ8RzmOSm9Q4FmFwvqNI0a/HZQk7KN2/EQ7Gdiqf6yEV+28hX1yCqVgybtm/lw2vjfbgRo8sVSrhaJPrzNhJcOPw1xAnxWeBrM9uNC51eQTgrzlORX/jmrRqFwhxV+ZMDAewvl+xJQdlB4WiK9lCR1nb2R5hxWMW4Yot4hfuPA2bOzaMX9fMTXbGscqw3W0C0SoxZueVjq1QqH44zBBZXDWUemdXTiuy8hIp6W0plLIiNd2it2Sfxho4vRt2UpKR4Abs2gkr+vZ4PfedXwqUdcyNX71H64+S3lerASHTGveHe77AzLmafHnziS5J2y3xZgeOZvAXmW9cl8G6uF2ukMuCoaZpmEUdoff8JWDJXVUeny74CXkRjb56h7FY60HuaBKC+X3hKi15MIMGlZSpK6eoXwL1Ck8gkB+CbwW7RVRUo+IbUfLVSdNoV7XAFWcX7Bl/0dIYLnTz4MN++xyuf3pyOTOzDr0J6xUCHEBkD93CxyUXpM+BIeIRER/F1j3YWfS9eXPdgeVDgYhxeqmSkky9a1ewdnIMghgUz6Nrk7DHsweoJ1QkplcvW1pNy5uoqcCLFJDHLrXLDdE+fl/Pmytw1BYY1oPg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1ptVml0enZ2QnRQTnNZVHRaYU0zeko2ell6OXYzV3RFV3pRSnN0RHZFcS9S?=
 =?utf-8?B?cldHWXFWVnpiWUJmNWlNbnRXVTkyV05QN05TYllRem9BSXpYSUR3QlFFMjRk?=
 =?utf-8?B?SlhUdjJlNWxMMTdGRHZnTnJTd01pWUtvZ3hCVDdoVUFIRXB1dlIzMGpPekkz?=
 =?utf-8?B?bVpZRDlmanRKSzA0S1ZNbjQ4U2FRV3lvZkVJMW9wY2lNY0FoMjBENDlraGdY?=
 =?utf-8?B?U2IrMHNHdXV5Y3NuUjd3eDR4ck5ueC9TSVo4dVlXM0xIRE9nWHhOQi9EdEJr?=
 =?utf-8?B?QUFwekd6WVo3dkNPQlRTc1RYdUVwRFpjTkhsT2IzK0NFZktHdDVPZUtKSjVj?=
 =?utf-8?B?NHVNY042c1UycjVWdXJka2N2dkRoS3d4RVQ2b3NSWnRDSUdmZmZndmVmeHl4?=
 =?utf-8?B?NTFXRTJlRWRsczMybnMwT1RBQlRKS3pHM1VLYkZETVk2OUFmcDljaFByYkJZ?=
 =?utf-8?B?azRrK3VDbndKL2lJbHl5Z05xQ2h3bWNET1N5OWJ2WjJTTnIxa2tZb1hGSXBH?=
 =?utf-8?B?SkZ0bUxLWVo1eTZUb3QzTkVVTlJ3Z2ZvVVdTeU1OVWhXY0s5cnQ2OTlqcVA3?=
 =?utf-8?B?eGhMUDRJWTBPeFV5NVE5cDFlZjNaM0ZVVlZBalZvZXUvTmRGNmlRdFhZOEF5?=
 =?utf-8?B?c1JkVmxtdTkrWCttLytRS1cxTktKRDN6ejZUZ1hkNzlqTFpWVXlHaFEwVEFo?=
 =?utf-8?B?L2RVNzBFOFN2Y3R2S1M5b0JnOTlFRVJZUzJZYnhpNnczTGY1NWRWQ1ZPYjEv?=
 =?utf-8?B?YXF4Wll2UkNsYjV4K0FRQmhjZVk0aTc1enpMM1NoNmRyVzZxRWpOTVdtQ0tW?=
 =?utf-8?B?T1ZUWDZORzdUdGI4V05VVnYwUlNHbkU3SVZmQ1JsVzRsVHBkMWRZSGNhbGJO?=
 =?utf-8?B?dU43c2ZSTnFDS0Fyd3NBRHJReEMwYko2WGs3NFlJUGZrVWpiVjdMSHF0T3Rp?=
 =?utf-8?B?TVU4MS9RWUp6UHQyeEhuQUVjb3ZxVkZDOFZZZittanlFY24vTjExdXF1MTJ6?=
 =?utf-8?B?Ung0cXVtTVpvMDBxNHJaZVpHZ1ljU05WZjEvajNEa1lTeEJ0bmZnSmo2TGpY?=
 =?utf-8?B?VkJzalFnTUZhK3VPa2F4ZnFTYXJVYThXYklCOURZVm9XczdTY0wwQm04UXZq?=
 =?utf-8?B?V0JVY25EZW5WRmx0c3ZMcUhFT1BucTJqcCtWQnEyemhOeDV2Ykxwc3BBWm55?=
 =?utf-8?B?QUNLOFBOdkZ0YzAveTFEcURLYTJqdWRXWjdHVlh2a2VvSDEvZmhLV2RpMHcx?=
 =?utf-8?B?NWxrSXNuK0J1TDMyUEVHejVvSXhaR1ZRd3VHYWlka3A2YkdlNG9FeEM0VDE3?=
 =?utf-8?B?bk1Yc244d29jbzFDMXo1dnJVQ2ViUUtVNjl3U090eHp1V3JNcXRFREoycFBR?=
 =?utf-8?B?bkt1MGp2emdacldMQzQzQkxJTlNtWEdRRGo0QUZCTm5pVGVOYWlmNW9yaGlS?=
 =?utf-8?B?QUxCMXB0NlFBRE9WQ0MwUnFQWExpTnczem9EeG1WbjQxWnZhMXptU1RMUE1Z?=
 =?utf-8?B?UGppMUJzbHNEU29sUFp2eURxWXVPN25Mc1htU1pLa1BXbW9PYndnd3lHaGhF?=
 =?utf-8?B?d21IOW4zeEV3Q0RCNHc1cXlvNldMVUNuNDhadGtHSGUydit0ZWxiWXV6NFor?=
 =?utf-8?B?UDROWG1KYTVoM1dtMVBhQlNudlczUTVyK1IzQksrVVlRVWxHc2xHcmM2SlFw?=
 =?utf-8?B?S2p1a1BBME13YnRxVnJKc3FkU2ZDNzMza0pSS0FPdFo5L0d6dmtXem1uMTNN?=
 =?utf-8?B?MzRhb3FrQ1dTdUNGS2w4NU5iQW4xTU9nVXpRcVRxR1d5R0VsSFpXUEFxa1ow?=
 =?utf-8?B?bTBNUy9TT2Z5bGI2cDRwT3g0ZHJvU1Q1TUpQalBPbGRVMjZmZUs0WkJrMldE?=
 =?utf-8?B?eVJkOWdhOU1qTUoyV1FiWEw4b0RYeHJSRlByNlM2U25xdFlDL1k0TkV5M0dQ?=
 =?utf-8?B?UVJTNlZMNXFLMDA2ZlNZVVVuMmVRbFNxTWN3Zjk5UFJ6TWlJa3d6b09wRngz?=
 =?utf-8?B?d244ZkkwWnhReHh4TzJLUnhVcUZwWk9jK09zWmdMMVA0eVQ4ZUhnMERyczhZ?=
 =?utf-8?B?cHpiNVpwdFRKOW9zVE9yV1Jrbnl6UWFjaFFDRGk3a3JXQWdSSmNRdWREdzRj?=
 =?utf-8?B?ZDRhcXJvZDRSOGZZM2pmRUExSU92VlRNcHdvSjFRc1dEKzZiWnYwcytuSjNt?=
 =?utf-8?B?OFpDVkhGN1RZZnd6dHFOT3N1WkRmQnJNcmRaZjBucUFmQ2Nqa1A4TkUyVHFi?=
 =?utf-8?B?SG5DckYxK2ZVbjVrdEZEMFUva0pINUkveTBUN1hERUVHVHJwS1BjSDdhczZs?=
 =?utf-8?Q?jAyPRolBpbHKn1g3B5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08462ee-0485-4256-f9d6-08def8ac22be
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 19:58:53.5945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/TFg1csI58uyq/xgiwRdSzyd07LLBUfTmwVbyvGI713Du7jncc2KnxKFxE2CEMg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8135
X-Stat-Signature: 1h4npgwmj4uytpst6u6huqg8pcptofb4
X-Rspamd-Queue-Id: 78F3F140004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786564738-384642
X-HE-Meta: U2FsdGVkX1/i8CXplRsfj3pkI6joON2JwK0yXm8fWu6f9pNQCQBfSjIKthgbFLmXXr3MMDg0qrf2pRKW4r2cbyIQcJkxcwEbfnDXSCmbzx0egVr8/s5UeVsx2X9m/eTWBvlX/00pYuLp38uxyhBSOTqez3VWj5K+UJDAUHpYg3Vh8pGYkHA0OQQQMbxylJRnvVXcWBxDbev2HAoWVc97CPqEaiApbb2rr3pfnmGJXttPe5IZhBB2BmpXOH7i/aviIsPq/qLg+16kdaOCb2GBEdrFnehr9bt5dWrKFZN8/TqY8I7lkwQMr8QtWjQ9/ekmTGf7ZhecaERilZ9fjsG/om9CeEkLcI8/qFqYHqw7JKMqhg5fRsnlgIhZ4kQ+WjX7SVIEy6iaMO5M4Efz1t2p74aWn2jHz+hXe7tnZxWB5eAR98wpcWvQMiQKU3SJeAqgcEMWfV9f3VRUBADYhAf6s9DpC1RD3Yyei223ilUF3eCNaoZG53/tdxXTkHZ/On/wjgZ5RjPDtMKugtoWpaNNXritVZjRv7g8uwfKO5EP99nJtAUpL1iWmHkHBduh5dFs7KJm3WOrM5xj/FiSDTNypLZ0Pl5gtyPxaNtJ61pHTAKCg+DGXlYvUrn7Pkyb/8im1/xFw+jMnH4t+MGNescR+a2O751dkSR8g59P6VLw4+reFeEfynTSJfCkFMcMWWmxFDeL9Ov+qm1FwoNdj+kKst+LIcRpKCZJzq8gUn6JIJhv4YUMpYQxxOib0L1vGNrdtz6dXh224YbTvnB3+XmdfF9KcBtLvG9Djy+NtTMxv7VecpOE8oGj95MYIUe+1OKM/HzOXKI98LboIe8Uz2fxdt+NrmP4Or0Z8aVg9yPidEuh//iLLhXN7IZww8HnjUz+qH+BngyQtCxjHh4lcNCXPVakUOBmvLdxNMP4RmifPlgYTPqGJBTy4Nawnaf3OBOdHywrrx/gNleERUBzY0g
 Lh2SxCBo
 tJFDlnTod3Na8/bpKznMJXOuUmapEAodVr2k2CIEPfFMxqDNM0a9rRJ6Gtx0oI08QAeiZLlqQoWnDyL/0V8P7SD1RiTn2DjyisM57bnciFjEfUisgK7xBtKKukfqcBfwFAO38AiRfgfSLUhC2C+rQaatxb+BQMuCQjLWz9GQAgLI9XXrFkbGZ/SOZBIOpbQ4EVTQmyqCozkEv1GOaIJCI53PoH3zkGPGb3rn4LecqoXPtqcpMI6Um/hOO0CkeSbfHzM5HGUd7GOqidyPxNeFD5LgM/3pQD1XnIEbivGisM2d+nSfyE2BgKZdjj9SexOi+Tf+DnvgEltSrQ1xWOw197RMh0Uf9nuW+DKAq+tExjTGUvErcGjooDXu8FCaLSdnewHqcGJKM5BencRzWnZKKxNGKuUhRY2GK9F5u4O33srnfqGRd3m28tuw4vWFENbJy1GKX+ClrnsFus8e+qiwD9Y7KoQpU4j/YzoD0qWNLudvCyFcX5VDuUgniCWB95ARrCeIJNg8oSGKzyZ87i12fwNhrLRMPfwdruvp7JMmhjDslPLak6o3Rngp1yrJBfJMOf+gASmEDH8arVk1Qb5Er5EE+cKdUmn/PfoBsyMIibrFVtWZTZZp7cJSR98fjffJF4pB6DDJgxYXN6A2mOe4Z+H3PxyGzlUTD1VuyMcMMDuWDtp21t4VP2OvZaxDUxLxsHx1307dihYieNmkkdxnKfC7c10Etph/1PPMSv0N2tA23aVY9HYefflOVWapPBpAUqEfK2/vf5/EZ3yWye4W+KOVMEZqqBe6F6IG9s9VAEqGE0VgELt2zKSjc7LZLHTf4hbQFzge5s+drk2xc5vbA7WFE5d8dUigvgidFStepzTE3cmtCSwXvcAx1J3Zn0SAys33y6jY0R/W8j15L0t3xCq384msAgBkTEN3o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 31, 2026 at 10:13 PM EDT, Zi Yan wrote:
> PG_private is going to be deleted. Adjust related comments to refer to
> page/folio->private instead.
>
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Ilya Dryomov <idryomov@gmail.com>
> To: Alex Markuze <amarkuze@redhat.com>
> To: Viacheslav Dubeyko <slava@dubeyko.com>
> To: Trond Myklebust <trondmy@kernel.org>
> To: Anna Schumaker <anna@kernel.org>
> To: Richard Weinberger <richard@nod.at>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> Cc: Zhihao Cheng <chengzhihao1@huawei.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: ceph-devel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-nfs@vger.kernel.org
> Cc: linux-mtd@lists.infradead.org
> Cc: linux-mm@kvack.org
> ---
>  fs/ceph/addr.c           | 4 ++--
>  fs/nfs/file.c            | 4 ++--
>  fs/ubifs/file.c          | 6 +++---
>  include/linux/mm.h       | 6 +++---
>  include/linux/mm_types.h | 4 ++--
>  5 files changed, 12 insertions(+), 12 deletions(-)
>

I will fix the issues pointed out by Sashiko in the comments from
include/linux/mm.h, fs/ceph/addr.c, and fs/ubifs/file.c[1].

[1] https://sashiko.dev/#/patchset/20260731-remove-pg_private-v1-9-142c97ba=
3562%40nvidia.com?part=3D13

--=20
Best Regards,
Yan, Zi


