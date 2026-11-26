Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE9B606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LMlbWiZW
Received: by kanga.kvack.org (Postfix)
	id 3C5856B05B9; Thu, 26 Nov 2026 07:12:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CCF6B05BA; Thu, 26 Nov 2026 07:12:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2653B6B05BB; Thu, 26 Nov 2026 07:12:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B49E86B05B9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:12:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D64D40368
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:12:46 +0000 (UTC)
X-FDA: 85477158732.10.81DCFB7
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010016.outbound.protection.outlook.com [52.101.85.16])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0CEB518000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:12:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LMlbWiZW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.16 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795695163;
	b=N6KrzfujYru7xM79mTnnsLIwJtI2kCw+dZGL4gRHEB+O9dMwtZVus2r3z6R7txaonbV03c
	m4A/hdb/meTDxb+TqQaF85zcIBDbSvrN6zxa2Bj4cpaZoXk3pqm/ikXsjOYgnzE2HHf/1Z
	y5II99al9+x8khjcdWw8UHBY7M/ysDE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aki+UNXKbgfN5vYKj4gex+SjfOiSMLySK+FrAYSGkg0=;
	b=gRrAQyLoG8ZEBZs5MzEg69n3kfUFO/barDOD65ufD0J5FYrmDkDz+IsuMLwixg7Fa6oZwK
	ATUDM09k349rVxSY4goo7OL3lCDX+AmiQZYAFpO756XHkX6r+ND90/ohhmuQU+WtU/qgt7
	xzMzmm0uZaHms4D5cCGHgZDStvz4Thw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LMlbWiZW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.16 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AIJOVYM+g2Y885+MRL1gbVkpG7DMQgT5ZUehYUZotbTFJGsiDRj7354ubPIALCvnMRaE6XxY2tAR4vDCkVrFKl/sVxunRNxdChQlbjex8zCPnsRCPdZWrdPn8EhLTr225n3NnUecvKxu/vI5ybZ0MFUUTXEf+gPaQCUZpIzqkEjXIjoe4isLcD38PxVBDNYFuL+EpWIfaA/yZ4ARiJWoHM84x1j0pRfDtE4E4375XOr6UALlGqAHoNbg9DuFMJ9KJOpBToDUcWm+cF3mEo+poPvXn8BdmyNxRws6ouJoWEy0t4gO4ZGpVXupJI1IY4qzq2NmC3L2Mxf5BWnv+++/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aki+UNXKbgfN5vYKj4gex+SjfOiSMLySK+FrAYSGkg0=;
 b=tJKOT6hK7pKaHggFUJYnB4SrzZCKsxqfIuh0AgVYjDT7xf4CusklxzWwp1b1bgepSTgSjqyc/CTlSQ0JZzyANivPOziKCvinAnPFq6c5BYNqA3O0DNwaNa82KnLt4lE7Z9wkoHXsE8nqL+Ac8D2+4+XMopbRVkcYEYV5+n7cTIoBHMPU2eXh9P+zbZmAevm7fjKjx11AD1aQXF+MQEIWEgzJaX40R4QWvmgZIWnOfsqZttMmrPoi++9r6BX7JpWjBfiQRvx6yEn8bFbftkCkncIHN7WZ74xk20QCKMhbiBV+0++JAHPNZNA3eZzQAzI4QmGf1qjZJo3unIQUSbi2Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aki+UNXKbgfN5vYKj4gex+SjfOiSMLySK+FrAYSGkg0=;
 b=LMlbWiZWrUgIZz33AozOxKq78fXHv7KP2UA7xsm3IcyTiLiOJjOUyn4LPJmBM0yFSAGCDJPJ/tTFZZckXBChgEG+5A0yTIR3c/gGBIqRICaXPvSXcnZTjcNoUtD88A4VsPBvmDPcLgat+hi8QpPhs7ACmAVlqW9FscPELEJxZzg=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS0PR12MB6463.namprd12.prod.outlook.com (2603:10b6:8:c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 12:12:32 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Thu, 26 Nov 2026
 12:12:32 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "dev.jain@arm.com" <dev.jain@arm.com>, "chrisl@kernel.org"
	<chrisl@kernel.org>, "david@kernel.org" <david@kernel.org>, "ljs@kernel.org"
	<ljs@kernel.org>, "hughd@google.com" <hughd@google.com>, "kasong@tencent.com"
	<kasong@tencent.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "baohua@kernel.org" <baohua@kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "harry@kernel.org" <harry@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "anshuman.khandual@arm.com"
	<anshuman.khandual@arm.com>, "surenb@google.com" <surenb@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "youngjun.park@lge.com"
	<youngjun.park@lge.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jannh@google.com" <jannh@google.com>, "liam@infradead.org"
	<liam@infradead.org>, "mhocko@suse.com" <mhocko@suse.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "pfalcato@suse.de"
	<pfalcato@suse.de>
Subject: Re: [PATCH v5 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
Thread-Topic: [PATCH v5 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
Thread-Index: AQHdfYyOOE+Nl4Da9EeYop+fxcDa0rdAQ7gA
Date: Thu, 26 Nov 2026 12:12:32 +0000
Message-ID: <76199f21d2b39a7fe44323ca5655bb3aa55735d5.camel@amd.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
	 <20261123053543.295467-6-dev.jain@arm.com>
In-Reply-To: <20261123053543.295467-6-dev.jain@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS0PR12MB6463:EE_
x-ms-office365-filtering-correlation-id: 7a0cfb26-80c3-4e20-f8cc-08df4bb68c71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|38070700021|10067099003|56012099006|261026140227099003|261028144727099003|261022105027099003|261021121427099003|261021123027099003|261102123227099003|261009223027099003|22082099003|18002099003|11063799006|4143699003;
x-microsoft-antispam-message-info:
 AOhBsVIyudbJwbGr1qspNRnew6sJkd4oygzOJDWVYhAiJT6/GNpAAb/8JH2RwteINmCpeuaN7L8pVq2uTSVx5TXJ/f5d88vLRO8/SKTKfx11eJ7wuHRF+gvb2z98nNOozPGzaYhs4H5Fcx8Pgyj1hh5UElHuGc8w/5TPo09h2MXtU5f4BPj2PdPBbJcu+kHFjR1lKar9dRc3rRsWIvuWNl95NcK44w82CQiqhPWE6FF1iXPxdar+L0Gh90sQN/MgAGaHnxxOKNZIAR+2hEI4FOUBMi/ZBBUyrsJ5RauS3dzmo60EOHt+E8Gr3Cqz8VCEzcOisqXieB4tbQE0unR29WlqhJHZtv6/NKf9WX7h80U1H1zHGHHmEEL/8AYCRhe62YlN0dm0x0jC1yCPcMStXqK0FDArcm4IaVYjq89Czg1cGBIfFc43Vc/FbFkBY1N+63MfatEvXlyCwxj7oWtIUob8Aigtg9rkjadagXdHJO3da1dJPNrer7vM4N2xUOZ/pL5LdXq45HtGBFvW46QHls/IhBCrLwRxfDnbxuYX5rfTiO2pvTZWDzf8aG0LSPeytiIcVJWYvpLwAvXrYJeKwqqZdA96+WBiUIrdw2WJSVIcQ30UsrqpcA8RCznmeWbet3wj2XAu2RV56DwXrPTbHaynbOWG+tGHeQxXix3U47SthFdRBt7fDuHJ89fxXstlWNMGGuGUae/9M16gaI24l9FUFgafyvlOXHq/BhDRCwc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(38070700021)(10067099003)(56012099006)(261026140227099003)(261028144727099003)(261022105027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SWZLK0JQNnlSU1U0ODQ2ZXkrOVRkditsbW9mT0Qra2FSa1I2R3R6bVcxZEZD?=
 =?utf-8?B?Q1hMWGlRTU8zeGh3eUR4NDZMcXluNzlIeEJlSHpPWUhZa0xtNHNwWjY3SWpQ?=
 =?utf-8?B?cDZUN0owOSszckRQeUduVlkyN0FqcWVwSEVEeXZsWi8zTU1HNjNuaTVxNWxL?=
 =?utf-8?B?M1F6dHhiOTFhNzdjUmFpM1pyL28xWDQ0elBrRzluc040c3FWejFRbGJsMVNJ?=
 =?utf-8?B?N3lIWDd5ZGRHc0pvZGdXYk9qMVlJU3JmZ0plQXc4R1VKNWhzekxFT1JJa205?=
 =?utf-8?B?dWlrb3MySW05QkVYc2E3U3FQVUZjYkx1UlA2b3hrOHExMk5kYmFGTVBQclg0?=
 =?utf-8?B?dHNIcnoxUHFaMkM1V0xXeWlrTkhXb000Uk8yeEJhZ1NhOGduZmw0WXVNRFhV?=
 =?utf-8?B?SklUYi8yK2JmdFAvNCtYejI4N2w1aGpwQ3JhVEJ1SzhoZDNLK0syRUFBSXBB?=
 =?utf-8?B?MlJ4VndYMXpnU3F4SXU3SFljM2ZuTEZjdEtOMmVCY2p4RXZ5QUFnVDlyMGlG?=
 =?utf-8?B?cENoY2RMTittUHdSM0k2cmpXbUNnTldNZHJQM0JZdm9BR2VsSi95SllFUWFS?=
 =?utf-8?B?VDFFdG0xTG5vZFl5blNXM2NMTkRRcHo0UkRGd1dHb04vQ242ZFU2akJVOE00?=
 =?utf-8?B?K0xSQWxhWmJGN2hqYkI4dDRkTUtsYnQ4WmVRR1FkNitaYnBzRWw1VGpjUDdH?=
 =?utf-8?B?dUJhWG03c0ZSdG5wYnVwalZIRUFRZmplcC9sbUNMN2RwclhXV2x0eW1wVHlJ?=
 =?utf-8?B?VWduL0IrOWRxOTRDNWxzRDNnSTIvYU5MWFR3OXVrZE9EbjlDNmF6S1AzdWFt?=
 =?utf-8?B?NisrWDRqbTVJOHlIWjQwTENMZnlUTzhZMDc1aGpkOU43K3RDL2VLRWZyMlFF?=
 =?utf-8?B?YUw4dHVIeVVtandwanBZNEVGSkd0NVo0R1JsTzJlK2krMy9xM005S1ArQmwy?=
 =?utf-8?B?eWRsYi9zb3JFbG91SUl0Z2xaMnJGSEJEOG4zbmNGelBXYjNzOXRoQWFWdEtH?=
 =?utf-8?B?VmxoQ054NTBKR280RGNTR1lyR3A2SUpLZVkzc2p1Q2xKYlNZaVQxVTU3YXA2?=
 =?utf-8?B?bkwzenV0T2Vkbm04QmtseU9YZ28yaElSMVo2QWNFUVM0WHd0RHpDSUlTSXZT?=
 =?utf-8?B?Mi9wVGQvWis1d1lpeS84OUk0MElta245bDVhVm5tQy9wQUFvQUVndUwxTnhD?=
 =?utf-8?B?d2pqV1NsWUVjMUEyZDRvQzNCdDZwZHFCcTIrNmJoU3YxUlNkV0I5L0twRmxW?=
 =?utf-8?B?ZXlkZ3I0aGI4M2Z5VFRIcHRWWEJoKzNZSU1jMTl3WXArWVIyMUVJWXRnU1dy?=
 =?utf-8?B?VE9SL09SbHRGNDh4MFZSaG52bkhid0huTldZNmVMaW44QzhZU0lQTlNWaEw3?=
 =?utf-8?B?WUpIc3dyY1JGL2c5ZWpPY2RVMmdGRkJtYzFlbFlqWThnTWZ6OW40eHBZV1dN?=
 =?utf-8?B?Mm5QdlVvdFovcGovWm1YNGcyaVNRYUFTL21wblYwMGREQlIrNkt1TllHYjUv?=
 =?utf-8?B?YmJQbW9FKzNJMU91c0dOODlzVHk4OEhqK0pEQmZyTkwzWlNyTHVvRDI1REJv?=
 =?utf-8?B?cWxuWnAyU3FmcHJXbVIwclczM3dvcmxHK0c0Z1I0R3c1QzROUWNKNlh5Y01s?=
 =?utf-8?B?c2dOWGlGdXVaVmhXdC83YU03SFIwbUMrMzhLOHZoWmkwckdWQUk0WGhDUWJ3?=
 =?utf-8?B?eUlmQXY4NTQ1M21JR2hmRE1zWG95OENvNE9RMVQrOWN4MlRCRzN5b2psM2tu?=
 =?utf-8?B?TGZyYThDY2E4Sm04MUJxaEdKU3lPd2wwbWZJZ1dlRUhrdDBaRWEzV1BQTllW?=
 =?utf-8?B?MUVyVGtSbmdpbEs3Y2NBaEptVXJabHJuZVFzUTZnNC9YZG01aVp2OENLTVVp?=
 =?utf-8?B?TEhkYjFScWxDRVhoTUlqTS9ONkg5Q05LZXdzSTk0aDJPdXlOSlhCbjZLbGgz?=
 =?utf-8?B?MklBcEE3THRVckdKb2NSc0ZBRHRoekZ3Y1ZDTGpWZk96T1RaeU1lMFY0Qnkr?=
 =?utf-8?B?WENPdUc0UVFqbEx4S2ZzVXVBRThaalhucm9FUkJNWXZQQlp1aStoRUV0T1NR?=
 =?utf-8?B?bE5TZkxqNmdrNkFJU21rLzFVMExmR3lOTS9vZWhnQkFBUUk3U2ZjNldrU2V3?=
 =?utf-8?B?R3R1TEpuQUkrVE01cHF4Z3lRSXIrZGFYcXVBL1pOdy9LNU80ekQ5WDJjNDlr?=
 =?utf-8?B?ZzNkWU9FV0NhbUwzRUd0bGJUcnRZWXJ4WGVKWlVadk9hdFBVa2ROanZNWnQy?=
 =?utf-8?B?d25ESVRFVDQyYnVJR1g4bjB2N3luRlRHT0NwUng2a3JCNk1yYzI4dFNFM2Nh?=
 =?utf-8?B?eUlxSVVnaXUrdEJvL1J2MG5iQnZTUGtkeGtsVlloYm1FeWlFKzNQZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EAF1CE651738446811566091F609102@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0cfb26-80c3-4e20-f8cc-08df4bb68c71
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2026 12:12:32.2075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrhMD1rLUdNoNwXiJ9hdnneRmaSuL8EgYaGSNkxin9pK/AW7GcQ3z4AyReLvJC+hCQxmz1pbpm+cbXMxWaYeiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6463
X-Stat-Signature: hoj73y8oqg745nrix85mfd8pces1mikm
X-Rspamd-Queue-Id: 0CEB518000D
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795695162-223853
X-HE-Meta: U2FsdGVkX1+/kBsnanM8GEgZtsuVflJxtGyzgrF+SUjkcs41ltml/XcFO9kIlzUTlQFzgVZpNNOKd8EbsTcAqr+2IPUubPtxwpYxX9EKTnyBBFjq6drmBB9XhBjG2N9ppYT4uX2xynYZubhyELcXK2NDNSBTESATsMkMPHpNY9F7pVfay4LuRDnAY8JZCXuMoW2PMiAeMHmT5h6ZHyWe4xAz9cZePfxQEdVJXtK9jepOM20lXxpHwK7OTscBhE9M1eRbTxE0H7lJmWlOnXkDJqtZuq9gvbf5+59zjvNmLKBH362bKz7th/Z3yb+MpdV5xYza/6A+Q8oHZz0RIYYryFDZ2lcHFJUgrjei0Zc68rT0UVJDsrGMZTRY8YuAyWe/V2351G09r609S6EAGgHDpaFQs5yDgjVnd7d/hNOymIDzYz7aGv4gdNpjd1x0J9rB3Yl4vaDnO7L1rv2DWPOnP2b4gVmV/GwooaODrq5nV8aO8Ugwzaa4IoRmwxKnmtdeHiPr38f8mcwlXDBfXgX4za9PPspuQ0l5Xb6r3gBDvBNqFOIBRsXJla0BwHK4j0uwv05iMaOWBR5Ox/83GXQkPHMDn8Kb9Pa+B4tt2033HgL0Gp0vn/9SeZIuPHI8VQu4jFTQcDMnoN2pg6epuBJaKzMIeWwF7d3TJTjVbR5KnB1iUMY4u/gRhGmSKRR1g96fizh1Gl/YffyKJlOq/hfVFWRFFtcpYUbqpRipq+2WnNGUMcshsFgfIk7y4p0BuDCAvf9mjCQPZiDHvgk17uWb7ceOc+HljJap716W98StSGjS5ZI4duemU+aaDEkeERZjEZLCf9gwjjsgkhPCbvDELDIyxRLEzG0/fdvhl0v2LKhYUmEH2h2BDG0BZ4wwfuO3ZbQZ76LLwrAI1Y9Ycf813Nif32MYZZSUHLr4gOey03vbfWRMQlQliNFvYYgqC/Pt08XTV7bb0XxxhL97wOF
 8fLm3+Qr
 bsTt+y5CyznSiWVPr+jd54rWJ1ZBLrdUgpxC8iQCB/N/eKV5U6RPQ2RVKzGE0LMf3teHggjbzXSOrjalnKVBExC+ImFOcm+AKOxl2/gDFb5hR736TR7wgczk615NFbVy5r6LewRXjwdwwje8C8RgvQjjB3R5NVaq23rWCYCHNqQtqpTzyHNWA3poOXrr5bitECFti1nBjUtPln/HC4sHPN4ToWxJQNIJgTcuucT5Cbmia3SJUr1Ot6J91JtNKzIsjFxeRFarN8L4sGItWS6RlQtKKfBgo25DKF1iUyltYdFhQxaOGrrIVNHqfPVaFbRi4Y5HM/GED5bxJNNyFDI0wD0WcGNG/jFBBXqSa5yH9MvxLgvDjD6GIH81nk7/81XLzsFQC2gWZi2UkIWrgVPQ9XtCHhD9nj+f8p1jltvObsQMKLMFQjHg1D9Rp6DtMDjh3UoDfax1ZVygYItgNtw9Oequx8wg2gKqmdmjtN46fPYN2a68/95UfurlLquepxG2HhdETKmpUrtkbIHd+3nDeAFfORAQj6rriUCfbY0yPiTloPH58Moafrr0No/wruBMIb+bqxmEpM1hackii+goPUeksElUvHa5c+oNsUiAF/gOnT7WSw3MZq0qFJiUBb4vCdF/pTx9qLrxCvN1x4FMLubvTzL2ld7Um+2CzlOuQWFgQVY6/kmHfJM4KH2opHXNu5qgLN+sKVsEX3thJNUYBHddPI+GAr8Chj88RbrMsoep6XTGCB54BGOu9QoJYRxW3E/RUGN+vfscT6pkytGHi0eKrdNRC54Qct4Qpc4MBurkBqXOqx/X03vsV5iFjHm5AOlNpvNMoPpNseKlnac7CNGk/TI1acUIMiYz6t+o7d1ts8MLt228YGhtE6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTIzIGF0IDA1OjM1ICswMDAwLCBEZXYgSmFpbiB3cm90ZToNCj4gSW4g
cHJlcGFyYXRpb24gZm9yIGFkZGluZyBhIGhlbHBlciB0byBzZXQgc29mdGxlYWYgUFRFcyBpbiBv
bmUgZ28sDQo+IGdlbmVyYWxpemUgdGhlIGhlbHBlcnMgdGhhdCBhZHZhbmNlIGEgc3dhcC1lbnRy
eSBvZmZzZXQgc28gdGhleSBvcGVyYXRlDQo+IG9uIHNvZnRsZWFmIGVudHJpZXMuDQo+IA0KPiBT
b2Z0bGVhZiBlbnRyaWVzIHVzZSB0aGUgc2FtZSB0eXBlL29mZnNldCBsYXlvdXQgYXMgc3dhcCBl
bnRyaWVzLCBzbw0KPiBhZHZhbmNpbmcgdGhlIG9mZnNldCB3b3JrcyBmb3Igc3dhcCBzb2Z0bGVh
dmVzIGFuZCBQRk4tYmVhcmluZw0KPiBzb2Z0bGVhdmVzLiBQcmVzZXJ2ZSBzb2Z0LWRpcnR5IGFu
ZCB1ZmZkIGJpdHMgYWNyb3NzIHRoZSBtb3ZlLiBUaGUNCj4gc3dhcC1leGNsdXNpdmUgYml0IGlz
IG1lYW5pbmdmdWwgb25seSBmb3Igc3dhcCBzb2Z0bGVhdmVzLCBzbyBndWFyZCB0aGF0DQo+IHBy
ZXNlcnZhdGlvbiB3aXRoIHNvZnRsZWFmX2lzX3N3YXAoKS4NCj4gDQo+IFJldmlld2VkLWJ5OiBC
YXJyeSBTb25nIDxiYW9odWFAa2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogRGV2IEphaW4g
PGRldi5qYWluQGFybS5jb20+DQo+IC0tLQ0KPiAgbW0vaW50ZXJuYWwuaCB8IDMxICsrKysrKysr
KysrKysrKystLS0tLS0tLS0tLS0tLS0NCj4gIG1tL21lbW9yeS5jICAgfCAgNCArKy0tDQo+ICAy
IGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL21tL2ludGVybmFsLmggYi9tbS9pbnRlcm5hbC5oDQo+IGluZGV4IDUzMGMw
MjIxMTdhYi4uYWUwYzM3ZWUzNDA2IDEwMDY0NA0KPiAtLS0gYS9tbS9pbnRlcm5hbC5oDQo+ICsr
KyBiL21tL2ludGVybmFsLmgNCj4gQEAgLTQ4MCwxNiArNDgwLDE2IEBAIHVuc2lnbmVkIGludCBm
b2xpb19wdGVfYmF0Y2goc3RydWN0IGZvbGlvICpmb2xpbywgcHRlX3QgKnB0ZXAsIHB0ZV90IHB0
ZSwNCj4gIAkJdW5zaWduZWQgaW50IG1heF9ucik7DQo+ICANCj4gIC8qKg0KPiAtICogcHRlX21v
dmVfc3dwX29mZnNldCAtIE1vdmUgdGhlIHN3YXAgZW50cnkgb2Zmc2V0IGZpZWxkIG9mIGEgc3dh
cCBwdGUNCj4gLSAqCSBmb3J3YXJkIG9yIGJhY2t3YXJkIGJ5IGRlbHRhDQo+IC0gKiBAcHRlOiBU
aGUgaW5pdGlhbCBwdGUgc3RhdGU7IG11c3QgYmUgYSBzd2FwIGVudHJ5DQo+ICsgKiBwdGVfbW92
ZV9zb2Z0bGVhZl9vZmZzZXQgLSBNb3ZlIHRoZSBzb2Z0bGVhZiBlbnRyeSBvZmZzZXQgZmllbGQg
b2YgYQ0KPiArICogc29mdGxlYWYgcHRlIGZvcndhcmQgb3IgYmFja3dhcmQgYnkgZGVsdGENCiAg
ICAgXl4NCndpdGggaW5kZW50YXRpb24gZml4ZWQuIExHVE0hDQoNClJldmlld2VkLWJ5OiBTaGl2
YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+DQoNClRoYW5rcywNClNoaXZhbmsNCg==

