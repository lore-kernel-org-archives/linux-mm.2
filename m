Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F125606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Sj0bg2gh
Received: by kanga.kvack.org (Postfix)
	id 26FDB6B05B0; Thu, 26 Nov 2026 07:17:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F906B05B1; Thu, 26 Nov 2026 07:17:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7496B05BB; Thu, 26 Nov 2026 07:17:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB5D16B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:17:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50F2BC0416
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:17:04 +0000 (UTC)
X-FDA: 85477169568.17.72E66A7
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010066.outbound.protection.outlook.com [52.101.201.66])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1BF7AA0013
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:17:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Sj0bg2gh;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.66 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795695421;
	b=fk1Rhz8wx5Fn8VcCPzLTRigDcm//5dgScPGinXJ9z48F0zY0M6WrxGQVpdDRumLtPAkmoZ
	/zNPQaVK/H0zcKXpX3ekP+6eJT3SxmZebbd/340AooBwI4YRBuPILr2YyTfL6WmVvzDnrv
	Cy7rQUcUpAQ635aqONniW9Cl9iRIecs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okJHTXCigHi4y3A8YMtCpoer5SJadxz+AbuRzFUJdNs=;
	b=rC/xOQ+ZEIjTeN3qsX9+F4JpWRE7RwD+sw+iP8Vic8TW8HX5z2aBRcwytAhIy1yL6thtWX
	yiRQt8jJiC8WplejwSDuMBZOANFTL0A4gW8roK74SwE13ePZ8qVUdpdKiey8JYA90/tDpf
	E67JVQahV8VbOCYedQ6Zx++KmsTsV4E=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Sj0bg2gh;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.66 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQ7H89Foz9gEjBHLZkWhHAXdprYhL4+CZ2dEe9z9VfeUdX1cHQ0VesFo//nnJik5at/SZRJHH+dwzWwdgWgftoXRYMU577Z2Zbc46NWv0Bm7oAYgL04HbjumS1XBs/jsfNvm4Bb1uf3yyzL5r+n2aszxe17lzYKYGwrZN0LbGt37bM62q3+g+sN3yjxuF4kSL38EfBFE0tEIkR2UgnQT5C/z8zXYj1hFW/C/L1bSWQoVmIYk9yB+VOab8528Bu66mNdx9vtck1y9QGhn5zUG8heRldCKFUce9r93u2BX0NMJI4zS6Hq7jSejL/JJiLoFLBynjCT7p22tSBC8O9dgqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okJHTXCigHi4y3A8YMtCpoer5SJadxz+AbuRzFUJdNs=;
 b=WQmBOlEkh+hWp6I8QsqgM8leOxbM0AU4hRppJ/XphjVLXgVej+tZJxRG0vgbFoUZ8SyLvsTWbGlAaNiR1oSj9+G+gG6f5oWnf5lu4J2l39nM2rKgiggf2md1kdEdYjb0I6AG2Q033O9zTmNwa/bIER9bcHXFiNIfjyZgGNiwOE86gaFZYhNXgWJrninmBtjXZ0PfD/VUNx9bflvqBVb3KQCYi+T85n6BZCU8jBg1jG9twBhZUW7MLAVmGStxYvGh3Y4VTrXnjjXBh8VEQWQMbVswGaYvHhhu2niYaIusNDHI0z3iZLg7PqT2CYDPHu/iEQrqtNAA9Cq3wVwacFFNdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okJHTXCigHi4y3A8YMtCpoer5SJadxz+AbuRzFUJdNs=;
 b=Sj0bg2ghsc6/enPDRfr3kGZJ455G4hq5KCqWVryeDBauLSx8GS4sKKdwBxWQ501MWSETHjwS1j6UwTpEOES4PQr7tv8YB1AmOpYfja9NKYo74DSOr/2/Cm2lLwKnDz6GjBAIA+fxsn/R63ozvBiToZ2tAuq8PrIUA3H2bzSuqmc=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS0PR12MB6463.namprd12.prod.outlook.com (2603:10b6:8:c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 12:16:53 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Thu, 26 Nov 2026
 12:16:53 +0000
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
Subject: Re: [PATCH v5 6/8] mm/internal: add set_softleaf_ptes
Thread-Topic: [PATCH v5 6/8] mm/internal: add set_softleaf_ptes
Thread-Index: AQHdfYyPZDQhA89qo0SFUp24mgzPO7dARO+A
Date: Thu, 26 Nov 2026 12:16:53 +0000
Message-ID: <b9b835e1bdbcac8c289a76a08fef08a0b290e939.camel@amd.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
	 <20261123053543.295467-7-dev.jain@arm.com>
In-Reply-To: <20261123053543.295467-7-dev.jain@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS0PR12MB6463:EE_
x-ms-office365-filtering-correlation-id: 367b1058-448f-4767-279f-08df4bb7285d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|38070700021|10067099003|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|11063799006|4143699003|3023799007;
x-microsoft-antispam-message-info:
 ckC7eSjQg8MMNyszUB7uW08jMkR8cLkZyntUnT5XGpYUsqsimVmk8SRv3wbkN2hr7syqjHshH8aPhcVf1PS8ho3lyUoPfohgYaMV970HRknBWJE2z3LdK0BRtczvrzjQdNPCDHh9xudIRBtiXq3JO5cP+0/NG4y2f05CXZmjj7kVrYVWrjYFVDt09+ecw7UenpSbhVb7S/UulR1nT75WZ6aqPUYL2KxQhhriDadbOgbiU/L18V/tStb7nwR6jHq0BNipd9KQDahZ2QiXkGZVJSDkqCKUpboKaH6uHQ/8GEQzm9aQ5XsURSJrQh1pdG1IACJ8x6wRncwi1UpU7BYMbBYYV0OzqijTWzeQPtLMC7duGfmbwML2SiqvnIO6XChqB/oodhkGwhKuex6DGDdIBklQGAB6seqXZWQVUa9fRIsBNDJTW6do+0aubUpOTYwpAeoR3CJtCXpNxxbLL49I+2Dioq8BrWt+Dig54lt8sNjSiitdWti2BU2prgOsqKUr1m76M+5SfL12p0DlXoWolpiet5zNsTWtN082q8ft2OvLunS29KJis++Yk+lipaGk6KyNPolOqK3ArlHvXvnsdoPv4behRqEDjQNB1ZIm/fisECMCbRmu89ezkDDm7uCz9UDppoH4u4/7M2CzN4foLW5M1Sa1zUtdM9euQ4DsxgAIayr0C9i1h1Bu7s9RkZ/LPG7fajbjyBYtbkAl4eGcx0bIWiN+5KnfokKMcfczl30=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(38070700021)(10067099003)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(11063799006)(4143699003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MENpenM2NHE1NUpzQ1pqQ3pkY2lCU0l5SW5aV2gxZlhEcjd0Q2lOSUpWSG1l?=
 =?utf-8?B?VWFSNWJYU3BKTlNQemFPQXd5Y2dpeEREcVRYa0FZa0taU205U2hiM1k4LzNX?=
 =?utf-8?B?YUk1M0EyR2dJMW9NUWVhbldTbENjdFA5ZE1sU015bFVwamtwd3JLVW1TM3pt?=
 =?utf-8?B?T1JxQW5LaXhqNzQxeDBLUGIzZWhvOWd1aDdHNVdCYlRtQThYZEhvSmxUVjdJ?=
 =?utf-8?B?Sm52TUxuUHFpRDlCTWhkREg4OGk4dzl5OXp5djZlTlowcXFiTVpqL3JHTU9I?=
 =?utf-8?B?SEowblh6cUFYUkJYdVZoRjZ1OWVHcWs3a3BCaUFGNHVoSHA2L2dpS01GdjZT?=
 =?utf-8?B?elRQczZZQ0U0engrV0VMMHVseDdFWXM3L1hDUDdPRlRYclNMTmFMRlZ2ZVJT?=
 =?utf-8?B?M2pWVlNTWDcwdzJMclFHMlp2cXQ3czVJRDhKNTRuVG5GSG8wV3IyNXJJZ25J?=
 =?utf-8?B?b1psMUZvVDZEN3BFUmRFRElxUjVlSWlVZWdaWHplTmE0M1Y3d1RtMlJCWnZQ?=
 =?utf-8?B?Wko5ZjN4ejZrSHpSdGNVVXVlU0ppaitzRGVzYTZDSlpNYUZEMnlCZDgzSTlN?=
 =?utf-8?B?eTVjWWxyUnl5TkRtZEN1WWpHUGxQYVBIWjU2MDlZUlJzUUhCc2lhbXJZMFRU?=
 =?utf-8?B?S1BmWFJaZjdOMEVRS29MUnB1VXdwNlh0bWlTd2ZoYU1SQTY4QS8yZnhKZnJO?=
 =?utf-8?B?MVNBMmQ3UjY0THVPZVNTNG1NSklHUDQvNXU0ejFpeDRQd0NoTndzUE1zVFdo?=
 =?utf-8?B?Sk9mRnlDYm5ZUDNYS1N0Z1puMURQTFYwSDErVmlWWHM3WXp3TnFZRzZQNUNy?=
 =?utf-8?B?NjhjRzlYNit1ZytwWEVxYjBWbmdyNEdIOEk1K3NNYitvNWh4L3BoTDRWMmxZ?=
 =?utf-8?B?dmk0ZmRNaFFKeEtPd2ZTNC9KQkJtYXMxalBWcy94NE1SZlJ5T1Y4ay9PYWhD?=
 =?utf-8?B?Z2hScTV6WnB6MDRZSXM1N3BaYndXbnd2MEJ0K3Q4aHBqY2o0Y3dJU1J1U0xH?=
 =?utf-8?B?VGJwQ3E1eG9kZlRsSWhDVjF3Zy81S2hDbU52ZFNkMUhoN0lxcmROdXNXODNy?=
 =?utf-8?B?OElCbGRhWVRjeERENEQ3TWpyY1lNeXptTlRJdDY1NjAvdEFQdUt6eGhUSnkx?=
 =?utf-8?B?eVM3YUtWZ3pDRE8wSlZueERuaWJVbkd4Uk1ZaHJGYzl5TGlKd0Z3UEI3SWg0?=
 =?utf-8?B?UHRqcjB2UGZyN2dPZVMzdmRKZmJlSFNzNDh2enNzOG9wdTRrMi9WNFRvOXFU?=
 =?utf-8?B?NnNLeTBmU1ZhRHYvL284MExBUDFiL0R6Uyt3NmpVY09wWmFVa01ZRTF5azFG?=
 =?utf-8?B?VjZ6YlFkNGlrSjlRTkJiSkQ5T1RYbFlidWQ2UHpDSWpvZVBWQ3JpSFNybDJZ?=
 =?utf-8?B?cmZYTXNwYjRhWm1QSWNXK245eHBhRFVjOWxQL09pUmVTU2lTeDN4Ym91VDBj?=
 =?utf-8?B?THo0aW56a0Y3M0hzQVVobVBkR0N6THM3L29tM29tSldZTFQxbGEvZG9LTHFH?=
 =?utf-8?B?dkNJRDZZdnE5MlVSUkk0T2U1akdpcmlNcTVVTTNHWkRFTXNCV0JoUDY0anh5?=
 =?utf-8?B?d0sybmZzcDlmQ09aRXA1V0NyWENUUUJBK1hzM0ZTZ1hWZzNiZnRjQzc3NVNI?=
 =?utf-8?B?c0YwallTTE92SGw5bVZMMlIvSkQza2N1TTlJcXdGNXhXSW9jUFNCU2Vub1Rv?=
 =?utf-8?B?MlJOYTdyOW9oUitOc1c3RE0yV2h0NXB6RmowR0N1eGI5cGt3TE0rSkl6ZmNV?=
 =?utf-8?B?N2FiUW44TDNPL0NnZHdoZFBLTldvWlp0bFIyeEg3bFViVnZaaTJYSHJKY1dQ?=
 =?utf-8?B?enh5bGQ1VktzS3Q3OXcreUJjeTE0aUpRdndhMnNydjl4MlEwQVJjVlFna1JN?=
 =?utf-8?B?aUtCQUsySndtSDNPT2QrcjFqbHpRNmg0a0FzKzNHMVdhNUg2K3kydkhMeVZZ?=
 =?utf-8?B?bUU1aEVJeG9tRjhHY0cySnlmU040V2VFL01QVEl4M3NZV1BIRXBHUTkvV21j?=
 =?utf-8?B?L3FRUHFNenpQS3VjcnN5OTFQTnVPb0R2TUp0cjVXbXdEQWIzalpQcWZYOUNn?=
 =?utf-8?B?VzZ1bXVjbi9CMDJKcmorakRSbkdQR0N2VXFvUDZrYXVxWHVGRmRRU3pXb3ha?=
 =?utf-8?B?aEZrN3V3bUNZcUVVSG1JbEZjUm1NYkUxMkJ5R0hHN3RieFVQZUk5ZzJsRGp3?=
 =?utf-8?B?TTg1NlFEUzNmcE9oNnQ5b3pxemw1aWZNUklHWUU5NTd6VUlKd3JMMVdXODg1?=
 =?utf-8?B?QWxsdFFXcGdseXVsK3Y1WU9ZblNoQmFvVHVhSklJRzlZQlA2cUx4UEY2N1lJ?=
 =?utf-8?B?Q0dBaGtMMGxjc3V1OUhleW0rR2dEZ1ZXNnozUXpHOXJYUHBhZzB0QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AF3512F445BFC43BB1124C00A8EAA3E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367b1058-448f-4767-279f-08df4bb7285d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2026 12:16:53.7466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WSl8Cj6bkAXJ4RvgglFKNKIHevbmEon7tZjEl6DDXXFW52ncQJ3lt+c3apHs+j/EoXdZjBH/S4+Yk+pip46Lcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6463
X-Rspam-User:
X-Stat-Signature: adyd8c1rcfdnfxrpis4xogacsjwqjzzk
X-Rspamd-Queue-Id: 1BF7AA0013
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795695420-558952
X-HE-Meta: U2FsdGVkX1/OXx5T98c3N7wWEz3hFvFZeAD5puzuPmWRX3Tm6DPHV3SB1kXhd+dwg/E86DF1liv69TSdhn2N81YriE8r8zDlmvL+nVi0r1VWb0nsAYoXjeaF3YtQ6m/fPZAQB5guxz8/tAIsKYOcAbqkdQKiDXsW8IlkQhPwf/eeTZpJILZavNNHdWCrUf/avlieTBE8GlT5i+twwrc8tTlq5Kcw1f/ftuavuzR88e0NryUaEPRSt0G6mfpyaqfKHEP6yBjTLgpf8CAh80dpnlNUlzc7FsmyQfQJZbWFfqK+rr/9GALju09bkEY5PnOFXetLKRCKfCyVRbq2BtdwcHJBUXYmWaTs55luDsaC+hNIRgwyS+JIVO6AERD+CYmfXxmM5YWyTyEB5IO91auPnx4l9iM48bM23gRai90m2e+SpTXidyk1jpbyxLGMtLEMmVIOREIlOpitoOO8X5x4NED6XdZ54fA2oF48+SeYhFxAeEzmhSadlXFhBLc6v2I7L9r6bXPIWs1vMzB/6RzGwDXDJulqtC94htAKGwFTdgnv1DbN+2s0XHXMeTm+XerCcVqFpFb06qqlvCunesk9CVW/flwoo0xdItxRZTxZEU95NiqrhmCgPJUfHIQcv/BLHWsRtaC5ZYHouQ7nvHAOkNfyWyMVk5siOfUj6hxOycY8632yF02rexqb/m73rEKvMg2g1QzHsLAWU23eW14tlSLuqRefM2FMFKaVVN55hyzX3g8W7tz7EVVNgf14GTEzl9K6zL8p8v6F7kXWLM36YjU0vuyquTNcl+8UyHMOMs9yTbHyeFeYYcoCbA662HkBSnnlH5ZbPJST+VZ8rSFm+s/ki1RCCqW0sMMgN9t6xA7MNYRu0HoHbxCxrDZ3RNM01b7O3AQ8tV9DMKum88GeQdbqcnmUTWQkCVt+A3Yzp7dFfK16Zv8G/l1SercK8HBdKwb8cgZmhlsSvVO6ixh
 I/q47i/T
 cGKiWfYpHzgt1Y1c+Ihvdv9bQ5PMYOQii889Xv7a0Ww3O0hmxo1c/sVrdRu6/YokcTonAVOGOnpu9GmVA01H1QfcmiDlFw/EamQk6H3KDmH+2jhNLvcDFZYYfEvaJAc7/F7ZFrLVDIdUXecSUHW7pFxLBk8t66jXwSgnCIG0XBB24g5/6I+SQnuBvpODEUHk3wDLrcfxNC9pv6Srxietr4QOuOHocBnIuQ2AO+kK+Mo80bC6WbM3RTNwQKiA/b7mzGo44wLIA4Gd5K6jiamwWQPXa4T1NuCwnrXKSRr/pVNwxOIHCuL11c37fXH6g2hbZSvtNOFmqBiuO/GJXO8C+RZxCdsYhTFdmhgsHYD8aW31cdYbA3mD+3UTpypJjwnVnuL/bA8qxKHxkH+JVdZyy3L6JSRbJsyT8RPLHkotJqa6t6MA4PPWGhMtRRK9YaP3JWLBaFrHp/CSJ2bsLC523cqJD1wHJ0durwQ5q0SuaAdOv/Upy60FfCvEoQAIJQYBzoVcCPDknrfQuG27nkAMiSxlznYVrEBI8LLEE8thJO7IaB8IvtR2qNgRy0UgYryas+2ceNyM2vKszwCRJsXH/YRA/ykMY5VE5D/uUhawoWwjRCMdchIJZaOYQCWZwPIUNO8r2kD6259wFtgWpxRuHCd0X7L0q+oldCZudIpLIsbGADAZrRzFmtFX8F2Aks9aRi+SNbIxbLNUW+hZ8F60XxMFgHg/hgvfXnpiBfrCExF/9+FQbAqoR/6BT0SHo9q/py08bxIjAIW9u3Kl9A63a4wmZi4VbWU7lNNY2qOk3eQHLHCzc8HxtpyCLf78zo9KM9H5NU5OfWtBRRyofjwbSrLseJNDx7yzU3EByZVRY9sYSIujya9Gk66pvwaYwNg1IECdBMQyAxIdhqq8YcdjTCm7mV4DcuUbYOz3Qgo/rc4tS4Y8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTIzIGF0IDA1OjM1ICswMDAwLCBEZXYgSmFpbiB3cm90ZToNCj4gQ3Vy
cmVudGx5IHdlIGhhdmUgYSBoZWxwZXIgY2FsbGVkIHNldF9wdGVzKCkgd2hpY2ggaXMgdXNlZCB0
byBzZXQNCj4gY29uc2VjdXRpdmUgcHJlc2VudCBwdGVzIGluIHRoZSBwZ3RhYmxlcy4gVG8gZG8g
dGhlIHNhbWUgb3BlcmF0aW9uIGJ1dA0KPiB0byBzZXQgImNvbnNlY3V0aXZlIiBub25wcmVzZW50
IChzb2Z0bGVhZikgcHRlcywgYWRkIHNldF9zb2Z0bGVhZl9wdGVzKCkuDQo+IA0KPiBUaGUgc29m
dGxlYXZlcyB3aGljaCBoYXZlIGEgbm90aW9uIG9mIGNvbnNlY3V0aXZpdHkgaXMgc3dhcCBzb2Z0
bGVhZiwNCj4gYW5kIHRob3NlIGdyb3VwZWQgYnkgc29mdGVhZl9oYXNfcGZuKCkuIFRoZSBsYXR0
ZXIgaXMgdHJpdmlhbDsgZnV0dXJlDQo+IGNvZGUgY2FuIGNvbnZlcnQgcHJlc2VudCBwdGVzIHBv
aW50aW5nIHRvIHRoZSBzYW1lIGxhcmdlIGZvbGlvIHRvDQo+IHN3YXAgc29mdGxlYXZlcyB3aXRo
IGNvbnNlY3V0aXZlIG9mZnNldHMgdXNpbmcgdGhpcyBoZWxwZXIuDQo+IA0KPiBUaGUgb3RoZXIg
Y2FzZSBpcyBzb2Z0bGVhZiBtYXJrZXJzLiBUaGV5IGRvIG5vdCBoYXZlIGEgbm90aW9uIG9mIGEg
c3dhcA0KPiBvZmZzZXQgb3IgUEZOLCBzbyBmdXR1cmUgY29kZSBjYW4gdXNlIHNldF9zb2Z0bGVh
Zl9wdGVzKCkgdG8gc3RvcmUNCj4gbXVsdGlwbGUgKHNhbWUpIG1hcmtlcnMgb24gdGhlIHB0ZXMu
DQo+IA0KPiBSZXZpZXdlZC1ieTogQmFycnkgU29uZyA8YmFvaHVhQGtlcm5lbC5vcmc+DQo+IFNp
Z25lZC1vZmYtYnk6IERldiBKYWluIDxkZXYuamFpbkBhcm0uY29tPg0KPiAtLS0NCj4gIG1tL2lu
dGVybmFsLmggfCAzMyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIDEgZmls
ZSBjaGFuZ2VkLCAzMyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbW0vaW50ZXJu
YWwuaCBiL21tL2ludGVybmFsLmgNCj4gaW5kZXggYWUwYzM3ZWUzNDA2Li5lNzJmOTU3MTYxN2Ig
MTAwNjQ0DQo+IC0tLSBhL21tL2ludGVybmFsLmgNCj4gKysrIGIvbW0vaW50ZXJuYWwuaA0KPiBA
QCAtNTE5LDYgKzUxOSwzOSBAQCBzdGF0aWMgaW5saW5lIHB0ZV90IHB0ZV9uZXh0X3NvZnRsZWFm
X29mZnNldChwdGVfdCBwdGUpDQo+ICAJcmV0dXJuIHB0ZV9tb3ZlX3NvZnRsZWFmX29mZnNldChw
dGUsIDEpOw0KPiAgfQ0KPiAgDQo+ICsvKioNCj4gKyAqIHNldF9zb2Z0bGVhZl9wdGVzIC0gU2V0
IGNvbnNlY3V0aXZlIHNvZnRsZWFmIFBURXMuDQo+ICsgKiBAbW06IEFkZHJlc3Mgc3BhY2UgdGhl
IFBURXMgYmVsb25nIHRvLg0KPiArICogQGFkZHI6IEFkZHJlc3Mgb2YgdGhlIGZpcnN0IFBURS4N
Cj4gKyAqIEBwdGVwOiBQYWdlIHRhYmxlIHBvaW50ZXIgZm9yIHRoZSBmaXJzdCBQVEUuDQo+ICsg
KiBAcHRlOiBQVEUgdG8gc2V0IGZvciB0aGUgZmlyc3QgZW50cnkuDQo+ICsgKiBAbnI6IE51bWJl
ciBvZiBQVEVzIHRvIHNldC4NCj4gKyAqDQo+ICsgKiBJbnN0YWxsIEBuciBzb2Z0bGVhZiBQVEVz
LCBhZHZhbmNpbmcgQHB0ZSB3aGVuIGl0cyBzb2Z0bGVhZiBlbnRyeQ0KPiArICogcmVwcmVzZW50
cyBjb25zZWN1dGl2ZSBvZmZzZXRzLiBTd2FwIGVudHJpZXMgYWR2YW5jZSB0aHJvdWdoIHN3YXAg
b2Zmc2V0cywNCj4gKyAqIFBGTiBzb2Z0bGVhZiBlbnRyaWVzIGFkdmFuY2UgdGhyb3VnaCBQRk5z
IChlbmNvZGVkIGJ5IHN3YXAgb2Zmc2V0KSwgYW5kDQo+ICsgKiBtYXJrZXIgZW50cmllcyBhcmUg
cmVwZWF0ZWQgdW5jaGFuZ2VkLg0KPiArICovDQo+ICtzdGF0aWMgaW5saW5lIHZvaWQgc2V0X3Nv
ZnRsZWFmX3B0ZXMoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHVuc2lnbmVkIGxvbmcgYWRkciwNCj4g
KwkJcHRlX3QgKnB0ZXAsIHB0ZV90IHB0ZSwgdW5zaWduZWQgbG9uZyBucikNCj4gK3sNCj4gKwlz
b2Z0bGVhZl90IGVudHJ5Ow0KPiArCWJvb2wgYWR2YW5jZTsNCj4gKw0KPiArCWVudHJ5ID0gc29m
dGxlYWZfZnJvbV9wdGUocHRlKTsNCj4gKwlhZHZhbmNlID0gc29mdGxlYWZfaXNfc3dhcChlbnRy
eSkgfHwgc29mdGxlYWZfaGFzX3BmbihlbnRyeSk7DQo+ICsNCj4gKwlmb3IgKDs7KSB7DQo+ICsJ
CXNldF9wdGVfYXQobW0sIGFkZHIsIHB0ZXAsIHB0ZSk7DQo+ICsJCWlmICgtLW5yID09IDApDQo+
ICsJCQlicmVhazsNCj4gKwkJaWYgKGFkdmFuY2UpDQo+ICsJCQlwdGUgPSBwdGVfbmV4dF9zb2Z0
bGVhZl9vZmZzZXQocHRlKTsNCj4gKwkJcHRlcCsrOw0KPiArCQlhZGRyICs9IFBBR0VfU0laRTsN
Cj4gKwl9DQo+ICt9DQo+ICsNCj4gIC8qKg0KPiAgICogc3dhcF9wdGVfYmF0Y2ggLSBkZXRlY3Qg
YSBQVEUgYmF0Y2ggZm9yIGEgc2V0IG9mIGNvbnRpZ3VvdXMgc3dhcCBlbnRyaWVzDQo+ICAgKiBA
c3RhcnRfcHRlcDogUGFnZSB0YWJsZSBwb2ludGVyIGZvciB0aGUgZmlyc3QgZW50cnkuDQoNCg0K
TEdUTSENCg0KUmV2aWV3ZWQtYnk6IFNoaXZhbmsgR2FyZyA8c2hpdmFua2dAYW1kLmNvbT4NCg0K
VGhhbmtzLA0KU2hpdmFuaw0K

