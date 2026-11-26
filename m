Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CCE606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LVAcf/bT
Received: by kanga.kvack.org (Postfix)
	id 6DB7B6B05B0; Thu, 26 Nov 2026 06:59:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C506B05B1; Thu, 26 Nov 2026 06:59:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B696B05B2; Thu, 26 Nov 2026 06:59:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4A876B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:59:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01EB04040D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:59:45 +0000 (UTC)
X-FDA: 85477125972.26.4837BF6
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012032.outbound.protection.outlook.com [40.107.200.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id B409814000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:59:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="LVAcf/bT";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.32 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795694383;
	b=coVkJYs21/cyPTaB/i2QigV9I0++nm1jKdwWtoMHCAylay3gpNAgBzKCt58BZtvV9pUMJk
	SVYXCrDBLL4HCpAfNttgN/BqIRFFgBrQ/RZ3xxaGPV8sQ9KnDR+2DvJwAIBq1HMFY2+Lxy
	CdKA98KW/J3mi6d6iAlAexWZUnMZE2k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795694383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2derhCRrXrS/b9K49fZXnDabJ74woOo1KME6X0z5q24=;
	b=UQNWZfSPVG24Gt2q45FynW7T8uXIM+7HgVsPS7dZq75bvk+M2Pedw5K+FKS21tC4GFTrnf
	0v78n71wFNmxgcXpP845qJy2eJxhuYM0AcMo4wjl3VHUjVt/ldBV0mNnhuLqT/Rf8cV6B0
	ALUKAeh7XVBlMNGSfeApvdyfpNi0hWs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="LVAcf/bT";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.32 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k2ci0c5qGRHRVrCDcYwM6yXy6/qTo4++MapE6CdVL9+devHiknI7d9/89oyeB9BWxV4rZgi8xXG3OC0IbQJ3ZZwODju0FNEdXyChV1fwF7JzVHCXBJisJ0mylk7nP8+L+tbNKwHlBHYujpRqU6BMAFzCx3KFYb0Qc2OWGPGSA9rBuQNJf/wE9t1wEZiW01JzU23x3k2f2ySbT3O7JbI+FpppLZTcs/DBYLQ8B9Tc/ez4VHGAfJPgywcJOIr2OejpJ7/uBitvILKsPhIM+BkGgvQQtH8NT13y7rk47Cc9GxHoZpWMjkKKHbZ19lTYc8+OSLYeNDGk3WoZgg/a1NmkuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2derhCRrXrS/b9K49fZXnDabJ74woOo1KME6X0z5q24=;
 b=uZte/Mq5m6aGXls+Y5e5RI2tmWMB2KlEaKQoMwyR3DtFnKiBopL1leoIRGjIc4W9SDvNRkLgNDyNQk2TcpeItzyLHOQV3EquwLpGwkkRuwA6pQFnJ/ZoT93fEM1qHspukUePlW+LqEKXmgXojwDPRJ91Lq1CSrtQOR/6Zxern20Vqgsg/hTFgrxv9dECu+U/+ChfNqpZscOT2t5WnIdO1qAN/vP9b48tFQg3YAcUsvSQJGaA327nnWOERAp3t6VZU7ggcu5Rc8wiNmAMH5jF6DQinuCCvuyDYyw3Wbht9SAVqqsEaxinUS0UxHYPei10RAB976H/utxoAb8wwhm76Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2derhCRrXrS/b9K49fZXnDabJ74woOo1KME6X0z5q24=;
 b=LVAcf/bTP38CFtG7qef4f1e7SaXHeSDIuUsD0YFb+n46bcsBPY0EHeJWq19glZ+KdIEJvJvjT6lWXSlY3JMCQvFcZGXj6RHdrIDdNtIuNMTVXskCUFE3yxqJ8n6Li12MTdZRSRO2LefqEw6yLCKbOUjibsw+umtCDEorFNy8a8k=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CY5PR12MB6202.namprd12.prod.outlook.com (2603:10b6:930:25::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 11:59:36 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Thu, 26 Nov 2026
 11:59:36 +0000
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
Subject: Re: [PATCH v5 4/8] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
Thread-Topic: [PATCH v5 4/8] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
Thread-Index: AQHdfYyN0YFNPM2FxkmmgIT4+Va7mbdAQBmA
Date: Thu, 26 Nov 2026 11:59:36 +0000
Message-ID: <046c70e4c18993f8f6d79859bc795b30bac55a3b.camel@amd.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
	 <20261123053543.295467-5-dev.jain@arm.com>
In-Reply-To: <20261123053543.295467-5-dev.jain@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|CY5PR12MB6202:EE_
x-ms-office365-filtering-correlation-id: 76c38006-67c5-46be-64f5-08df4bb4bde9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|38070700021|10067099003|56012099006|11063799006|261022105027099003|261026121527099003|261028144727099003|261026140227099003|261021123027099003|261022075727099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|4143699003;
x-microsoft-antispam-message-info:
 ueyU0pXwVGrUnv4YZg9SlheEAR7S+G7rFXwYIRqfwZPZ/3RSZa76JLAEyf6p/kR1qcaWN+OYKRQYt0NASN2YselahzbStsbt+jtQrGc/DfneLgdYVrOW1RJDE77LyznyToNd2qZJPyiAfBF0OPfbbJKFS8Lg0Tfx1WOo2nBtllSh+Fm2/T6z35Tg9iGkmameKb6j+x4Ik933I/ltQmqENxhJ4AnPYIdgItNBO6l2qHcwIh9bUYFVik5XIRazFY4UEBd24O2ly1u3NyhrW+hvAWjxi8kW2CgRC8M1Mhs2c+tmI0kBAbOAj95R4vWCFmtrbzLJRM8E0bY6gR233Lg1NjgxHEgBuQVXjaDowdI3LlSYiSnur3UyiVbjJqM42Ogu+wyF4nlWlhejstE8W1VgG3QZhrd4ksP6nJl0fmMpa8iBNc0/BZY6y8OB3F2Fj1QSiGeBfF2lN8tBA+wRJyYX82X/+79z9Nka5CZoATqsckulDAMshibgWEX8902Iabj+HkP+di4fHGbI6ginXjaVMowuacofjEYLclSL0WweHcbOv+ngs5GjIDKlgin1Ze6ZBFzpjuopj2pMP0qjchCMWBqX6UouT7U+GCSUk8kM+efa9AfozwVf6P0uaPWVlDFcyIoisZhnfJDVULhVMs8w+Ju2sSndF5YCZuzlvGoHrh2BpJYItCqlKsLd8zoYC5Ya0RmzD3OlOhhu1HFtVWst8kwV99GyygsD0kMakcA1c0M=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(38070700021)(10067099003)(56012099006)(11063799006)(261022105027099003)(261026121527099003)(261028144727099003)(261026140227099003)(261021123027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?azZRL1BhS0RjWUtDZFJOWlJrdHBQYXVhZWtUUWhZd0tvbDJLQzlqR3prbTZ2?=
 =?utf-8?B?blRHNjZ5enFEZStwVHJiZ3ZCZ3ErVGFYYnBOcmNXQ1JWdFgrUjM5NW4wU2h1?=
 =?utf-8?B?RE9mMGtMaHJTQ3prWjlTK1pwUTArSXpqMVhwM1M4V2JuSDJtN3hTbUtGc3No?=
 =?utf-8?B?N09Uemxxc2lMN2g3bDlrOUFjUGkybHFDWE5FK2ptRCswajh2R1o2MXEyVjZR?=
 =?utf-8?B?Qys0WVpLUWU0YTB2MnFwSkxkSnZZdUJZcVVYazRoaDVwenkwbUJYdW5zNTNT?=
 =?utf-8?B?dURwMWlBTkxQMDBoaFhHcWZFNmd1dk5McWpEVmNTSlMzY3c4NDgvRzZ6ZnBS?=
 =?utf-8?B?cVNHQlV4TmVvcEZwdVpFYjd0MWw0NjRZRTEzeEx2R3VRRnlwbHBONGVlSWI0?=
 =?utf-8?B?UHF2NStMOW9NZ1crOGlNbmp2OUNxMFRCSjNjUnFhVms5SStXdUd5UkVob1o0?=
 =?utf-8?B?Y1gyalJzMkNjTndxL2MrejZPQ3lETmxITlJnSVRQbktTR3gralpKMjd0bERo?=
 =?utf-8?B?aC9lOWNPdmdVUHJ1T1lmbXd3TlFaTkRSZzd0UDY3MzFtUzRwNWhVVFI3NHJj?=
 =?utf-8?B?UTFWaWJId0JCT3Y0NVhXRnVCbTk1c2ZURVYyRkVlaHQwL1p4MFI1YS9TM09X?=
 =?utf-8?B?VlhMc1dxaE5SUXBrdDVpTnQvMUVQV2M1S3RVbUNZOXZyLzdOZmEwK0NZbndw?=
 =?utf-8?B?ZjFXd0Fjd3EvQ20xU3U1VEI3OHBkUEV0V055YThzU3N5dmJZYlErK2FxSER4?=
 =?utf-8?B?RWlGaTcxQytHWk5xUHFnYytFYmJDby9jS0Qxa3VIdVloRE54Mmp1ZVFTWUNB?=
 =?utf-8?B?Qlo5SUgvby8rWk01RGpEZjhRY0E2bGQ5N2hvbXpMbHZjcktmbHVIQXE2QTdo?=
 =?utf-8?B?d1dBczl1Um40aDBYMGRqTmphUlBhaEszVHFic0prdEJVYWxQZHk0N0FVaGFp?=
 =?utf-8?B?Vm4xdjgxQkFVNjNvZHhTenRFeXhkbUNYMnFySExxamJ6VENUTngvV3ZkZHcx?=
 =?utf-8?B?MGpod0loWGw0RTNaMmEzNlRlTXJxTGtjN3JMUlA3RmVhTUZxUjVFeFFXSmE4?=
 =?utf-8?B?S3VEV3lUbm9SS0QwSmxWZUNvVVlSMWxMb1RuN1F3dkErZDZiTkd6NS9KSU9D?=
 =?utf-8?B?S2pVWGMzWTlvNkVJL2FNL3E4a0dHV2ZicXB6Y25uRS9sdGgzMGVEMm1oT2x5?=
 =?utf-8?B?WU9XNzZIcGUwRDh2NFJ6ZFEvdXBuSmF0OFA2Q3grVG91d0tKLzFBWEVrcXI3?=
 =?utf-8?B?ZlNONzN4TXpobkpaYmtEUkdJQWxOckZnTW5YR1oxUjVvR1NtSlgxYnpPOEFK?=
 =?utf-8?B?MTZmckZEcHpHV0dJaUhhNkplWW14N3l5ZzlwU2RUSzk1cWxHeHNENWl4NUtK?=
 =?utf-8?B?Y1Z4R1NPVmk2UnZnYVZNVWNkRnRPMXZZWnVMNGxwSURHZGlsbzcrNjVlUFZJ?=
 =?utf-8?B?WUsvVkJjRk91dkF2UG1LbXhxZ1ZDelN1TVhzZTJHSmM3b1IzR0dWVUhhRFEv?=
 =?utf-8?B?V3JmTjVuSkFnREdVRTFCa0RQeUJGNUwzcnlOODVnU2J1NVVIbSt6Q3dOMi81?=
 =?utf-8?B?Y3BmU3UwWXQzaUlYTUhVT1JZWWQ3SEpKT2szUE4wUE10b01ROWlyUmRsMWpV?=
 =?utf-8?B?ZDl4WXVNc2g1QkZrTFFodjJKQUw3cHllQWcydG9XYS90R2pMejllQngyUXov?=
 =?utf-8?B?U3krNWhtMktBV1NiRy9VS1VXYTdaN2lOeWg4RHZnMitPRHZ0MkNLSXRORTlk?=
 =?utf-8?B?dkxBeUNYenBxUTZVQ0JycWVhd2E1ZTZhOEJaY1cwTXo2N2dybTdNWDd4TENr?=
 =?utf-8?B?KzRuY2pUVE1pY3pNbjhPSDNSbVJXQ2o2TWhjV3VZWURYUlNTSDc4eHRwS0Rl?=
 =?utf-8?B?OGlIUDROK29TZ3oxa0RGdzF0K2xQWVZDWVJUdG1tSnk1SFBVdjQxTkEybG51?=
 =?utf-8?B?ZlV0OEhBNmY0THFidndYZjlCallGYUY4eWlIbER0amRMNmxsTkFLdmorc0ds?=
 =?utf-8?B?d014ZEJaUzRlMHhNS1g2N0VQdmw2c0dGM1hRblJhMWtIZWQybnMzNmYzb2dO?=
 =?utf-8?B?b2ZnZ0FSNjZXaFpLUDhub1UwcW9OcHBSa2Z4ZTB0cWEvL3FkRmU1OFlnWTZa?=
 =?utf-8?B?Mm53TFNYazljNkplQ2QxdU0zZWk5TmRWTXVLd2lWUzBNaWVRUmR4eDBMS2xU?=
 =?utf-8?B?cGgyd3k2UC9OSmg0ZXE0RHMrL0o5a3BPZVBCZkZMMmVoeUJ6R3ZwZGRtREVq?=
 =?utf-8?B?RHFZclhCYWFjdS9HVFZMQlcxNG8zclBaZWNDSUFRL1JFaFFndGlIYTBzaGUv?=
 =?utf-8?B?bENLMnhhU0FoaG9JdkRraUFoN0g2SlhEOWs4ZXRqeUVpOGd6RGZkQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB0D114A13CB73498E563CC3EE7E4C90@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c38006-67c5-46be-64f5-08df4bb4bde9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2026 11:59:36.2178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zjMSy8zU2Zs7O6IZwF+0n2Rqx6+uasHNoFDV8jRUblMOO+jrKbre8/K8TNM/6I5zZ5TCNaN6fdUntRHAJeYZug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6202
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B409814000C
X-Rspam-User:
X-Stat-Signature: 39b7w7ycoix5z4asfgn5g5kx36cx8tho
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795694382-286088
X-HE-Meta: U2FsdGVkX1/BkslmOVnsmyibVa+f56nNyvv9VPQt43OZzsBopp++1NoESOO/MKhlEFc6j7fvAzJio8BF5cMwyYlGrTc0guvlThsVO0oU6Uj4dn3MZ4HN/Hj/JPufq0gPKojAwFasnmduQ14pK1nGnUvZsr/gq1Yl+bwrqHnThqGiZaPh1UAf/G3Si4zRQ/NtOIYksRMlnUTJQrDrMwoMdDjkOWKSJoIgl172RdPy5AEtZqDwlsfugKY2JsHRBHcWJFljggTnEmNo9V6AUkrc8d156reQFgr4jQIaob8BtBh6zAzYtRf7XaQbW5OKQQ+YUaIQw+gYvF1tVotaQlngrKw4s2v3YaCHiPDEDiDOFBlHJ7qr9xWhpW9yAOt0Grb+U369dV1yCht7/SVPFyg4tlp1WnkrDzfKFofzj0CDT9aXUUpu3i9d5mXVc0EGudiy3t7SGw9HOt3xk4ZN/s/lOKJSfQWjAQnNYaLCl/v8AcHYfN2LKvc7A92ByR3jGoGC9VEsLuUJjXz2q3qbEHByApsLuVZ9gRpTAYBtsZZp9Q0zUr+bsz+IGmAttv5Tw/UUfA7F/SGtzrIngq6e9xEcCnh0GNjIeuFknGc8siopF7gk4poQ77f0PVAEPjZI3AFpbbYVucWi74stfTXOSaselIx1zIYpJg37IU2syQi8wl4NzoshV/6psAvWxdwEjV8gY6BX6OOg6Cwrg6DFvvQESMqe/B753IvTzcATpYmUQYbkee6DZ5REni9C3FyifWiJoFmrsnRZ3kXDATCkYcU+nK0E67m2yXok1FfafgvBd5KIX5B3kz3fQDunR3hlsEJeaRtyeu5MG0A2tj2qEO23pjzDtlTiSMmLsGjW/XdpZkifwphrYKe5HOCN62Y9XYdYfKUssKJme3lz+DukVdC27uJ4f2DdCd4KkIl/dLpUQ2XvzAUB4vg99vbTe0Dga9SuYmdPsM1/cHBwQT17QR4
 gTcvcAb6
 qCz8XUj8DY/X5Bk99qYXFk80VPWgeu5Fo4QU1KugWRwPRWVoWtBEMYC1esCYdq1SJ1pkJ3+t6B09l/bQHZWz/gQSpfrDXO3etABjT1nJPRseRwDQpJ3YQQnFvHPDnvqFg8JetqYnWoAdoXJwboCMDCbk06z24G1w3TFEsPOG9lOn6qgNVbXbC9g+VOCNi9xyXqHusC6iy+5GS0nqhGKYFzL8qwLSAc0HDnCdyKUWo8ItOX3aOdaEvr1R+oBvQbTr+ExgdYXv3d+P5H1WPm775txv4aocN5g1yYJMl4IJ4aD/t1hy1ks5hybsv6Mz5ApgbdYIeGLThAxKARi0kvwimLsmTF5gNwRyFJ1U+TxDe132hKJHjAh+hgyI/j9ZhWVrRiP8aGTAlTFYlp9e+WWgLN3/iW3HHq3AyMzg/m3q4oToey9BbCpdNsBg6rXcFUyZFw5v28R5bP3U4nHeB/OI3IkX3L411z6ie2TYdjQNHNStAP6m7DUN2o8HBit9apNN+i40HCEj+mTPG8NpVwnClNXUm0A/wTTZorX88fKW1Xz/dzc5jXOUBRv5xzJ5+z8i9+g9pF9WSOWyq7PLL+P4u7/RZXBGnDqDWc+RGNHzXIIL8TyPmjRmwee9eqUVpwgZijodELv1F+2Reaqrm9IlHU84k9c8D+muScIkDXB9qIYTySrndj/bAW0L+1O8ahoaYbcUMOBJo0A2QQA/fsbOGG/MwWif4Hppw4r1tnzLuaLFp8Q8KRU87WxwJ/g8IZA82OIL3P4H6H3Pj659oOsUiefsRI3nYiCJN2ux+y9P1Ox54qHESq8O++PMRbi8EJsNc8miYLPlwe+UpxExiDN91HXOTnW3dFZ4HS8DA/wYUDT4WhXRQ4dW9QCVEGxPXDMtwSJPGA+vsEL16EI8MKbdkVWDFVgy9JaE0yLNIeRz72hfTdkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTIzIGF0IDA1OjM1ICswMDAwLCBEZXYgSmFpbiB3cm90ZToNCj4gVG8g
ZW5hYmxlIGJhdGNoZWQgdW5tYXBwaW5nIG9mIGFub255bW91cyBmb2xpb3MsIHdlIG5lZWQgdG8g
aGFuZGxlIHRoZQ0KPiBzaGFyaW5nIG9mIGV4Y2x1c2l2ZSBwYWdlcy4gSGVuY2UsIGEgYmF0Y2hl
ZCB2ZXJzaW9uIG9mDQo+IGZvbGlvX3RyeV9zaGFyZV9hbm9uX3JtYXBfcHRlIGlzIHJlcXVpcmVk
Lg0KPiANCj4gQ3VycmVudGx5LCB0aGUgc29sZSBwdXJwb3NlIG9mIG5yX3BhZ2VzIGluIF9fZm9s
aW9fdHJ5X3NoYXJlX2Fub25fcm1hcCBpcw0KPiB0byBkbyBzb21lIHJtYXAgc2FuaXR5IGNoZWNr
cy4gTm93LCBjbGVhciB0aGUgUGFnZUFub25FeGNsdXNpdmUgYml0IG9uIGENCj4gYmF0Y2ggb2Yg
bnJfcGFnZXMuIFJlZmFjdG9yIHRoZSBmdW5jdGlvbiBzdWNoIHRoYXQgdGhlIGNsZWFyaW5nIG9m
IHRoZSBiaXQNCj4gY2FuIGJlIGRvbmUgYXQgb25lIHBsYWNlIHdpdGhvdXQgZHVwbGljYXRpb24u
DQo+IA0KPiBOb3RlIHRoYXQgX19mb2xpb190cnlfc2hhcmVfYW5vbl9ybWFwIGNhbiByZWNlaXZl
IG5yX3BhZ2VzID09IEhQQUdFX1BNRF9OUg0KPiBmcm9tIHRoZSBQTUQgcGF0aCwgYnV0IGN1cnJl
bnRseSB3ZSBvbmx5IGNsZWFyIHRoZSBiaXQgb24gdGhlIGhlYWQgcGFnZS4NCj4gUmV0YWluIHRo
aXMgYmVoYXZpb3VyIGJ5IHNldHRpbmcgbnJfcGFnZXMgPSAxIGluIGNhc2UgdGhlIGNhbGxlciBp
cw0KPiBmb2xpb190cnlfc2hhcmVfYW5vbl9ybWFwX3BtZC4NCj4gDQo+IFdoaWxlIGF0IGl0LCBj
b252ZXJ0IG5yX3BhZ2VzIHRvIHVuc2lnbmVkIGxvbmcgdG8gZnV0dXJlLXByb29mIGZyb20NCj4g
b3ZlcmZsb3cgaW4gY2FzZSBQNEQtaHVnZSBtYXBwaW5ncyBldGMgZ2V0IHN1cHBvcnRlZCBkb3du
IHRoZSByb2FkLg0KPiBJIGhhdmVuJ3QgbWFkZSBzdWNoIGEgY2hhbmdlIGluIGVhY2ggZnVuY3Rp
b24gcmVjZWl2aW5nIG5yX3BhZ2VzIGluDQo+IHRyeV90b191bm1hcF9vbmUgLSBwZXJoYXBzIHRo
aXMgY2FuIGJlIGRvbmUgaW5jcmVtZW50YWxseS4NCj4gDQo+IEFkZCB0d28gV0FSTidzOiBjaGVj
ayB0aGF0IHRoZSBiYXRjaCBpcyBlbnRpcmVseSBleGNsdXNpdmUgKGZvciBQTUQNCj4gY2FsbGVy
cywgbmVlZCB0byBjaGVjayBvbmx5IGhlYWQgcGFnZSksIGFuZCB0aGF0IHRoZXJlIGFyZSBvbmx5
DQo+IFBURS9QTUQgcGF0aHMgY29udmVyZ2luZyBpbnRvIF9fZm9saW9fdHJ5X3NoYXJlX2Fub25f
cm1hcC4NCj4gDQo+IFJldmlld2VkLWJ5OiBCYXJyeSBTb25nIDxiYW9odWFAa2VybmVsLm9yZz4N
Cj4gU2lnbmVkLW9mZi1ieTogRGV2IEphaW4gPGRldi5qYWluQGFybS5jb20+DQo+IC0tLQ0KPiAg
aW5jbHVkZS9saW51eC9ybWFwLmggfCA1OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQxIGluc2VydGlvbnMoKyksIDE3IGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcm1hcC5oIGIvaW5j
bHVkZS9saW51eC9ybWFwLmgNCj4gaW5kZXggZWMxZTg1ODU1YmUxLi5kNjVkZTgxODRlY2IgMTAw
NjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvcm1hcC5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgv
cm1hcC5oDQo+IEBAIC03NDYsMTcgKzc0NiwyNSBAQCBzdGF0aWMgaW5saW5lIGludCBmb2xpb190
cnlfZHVwX2Fub25fcm1hcF9wbWQoc3RydWN0IGZvbGlvICpmb2xpbywNCj4gIH0NCj4gIA0KPiAg
c3RhdGljIF9fYWx3YXlzX2lubGluZSBpbnQgX19mb2xpb190cnlfc2hhcmVfYW5vbl9ybWFwKHN0
cnVjdCBmb2xpbyAqZm9saW8sDQo+IC0JCXN0cnVjdCBwYWdlICpwYWdlLCBpbnQgbnJfcGFnZXMs
IGVudW0gcGd0YWJsZV9sZXZlbCBsZXZlbCkNCj4gKwkJc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2ln
bmVkIGxvbmcgbnJfcGFnZXMsIGVudW0gcGd0YWJsZV9sZXZlbCBsZXZlbCkNCj4gIHsNCj4gKwkv
KiBkZXZpY2UgcHJpdmF0ZSBmb2xpb3MgY2Fubm90IGdldCBwaW5uZWQgdmlhIEdVUC4gKi8NCj4g
Kwljb25zdCBib29sIHBpbm5hYmxlID0gIWZvbGlvX2lzX2RldmljZV9wcml2YXRlKGZvbGlvKTsN
Cj4gKwlib29sIGV4Y2x1c2l2ZSBfX21heWJlX3VudXNlZDsNCj4gKw0KPiAgCVZNX1dBUk5fT05f
Rk9MSU8oIWZvbGlvX3Rlc3RfYW5vbihmb2xpbyksIGZvbGlvKTsNCj4gIAlWTV9XQVJOX09OX0ZP
TElPKCFQYWdlQW5vbkV4Y2x1c2l2ZShwYWdlKSwgZm9saW8pOw0KPiArDQo+ICAJX19mb2xpb19y
bWFwX3Nhbml0eV9jaGVja3MoZm9saW8sIHBhZ2UsIG5yX3BhZ2VzLCBsZXZlbCk7DQo+ICANCj4g
LQkvKiBkZXZpY2UgcHJpdmF0ZSBmb2xpb3MgY2Fubm90IGdldCBwaW5uZWQgdmlhIEdVUC4gKi8N
Cj4gLQlpZiAodW5saWtlbHkoZm9saW9faXNfZGV2aWNlX3ByaXZhdGUoZm9saW8pKSkgew0KPiAt
CQlDbGVhclBhZ2VBbm9uRXhjbHVzaXZlKHBhZ2UpOw0KPiAtCQlyZXR1cm4gMDsNCj4gLQl9DQo+
ICsJVk1fV0FSTl9PTl9PTkNFKGxldmVsICE9IFBHVEFCTEVfTEVWRUxfUFRFICYmIGxldmVsICE9
IFBHVEFCTEVfTEVWRUxfUE1EKTsNCj4gKw0KPiArCS8qIFdlIG9ubHkgY2xlYXIgYW5vbi1leGNs
dXNpdmUgZnJvbSBoZWFkIHBhZ2Ugb2YgUE1EIGZvbGlvLiAqLw0KPiArCWlmIChsZXZlbCA9PSBQ
R1RBQkxFX0xFVkVMX1BNRCkNCj4gKwkJbnJfcGFnZXMgPSAxOw0KPiArDQo+ICsJVk1fV0FSTl9P
Tl9GT0xJTyhwYWdlX2Fub25fZXhjbHVzaXZlX2JhdGNoKDAsIG5yX3BhZ2VzLCBwYWdlLA0KPiAr
CQkJCQkgICAgICAgJmV4Y2x1c2l2ZSkgIT0gbnJfcGFnZXMsIGZvbGlvKTsNCj4gIA0KPiAgCS8q
DQo+ICAJICogV2UgaGF2ZSB0byBtYWtlIHN1cmUgdGhhdCB3aGVuIHdlIGNsZWFyIFBhZ2VBbm9u
RXhjbHVzaXZlLCB0aGF0DQo+IEBAIC04MDAsMjkgKzgwOCwzOCBAQCBzdGF0aWMgX19hbHdheXNf
aW5saW5lIGludCBfX2ZvbGlvX3RyeV9zaGFyZV9hbm9uX3JtYXAoc3RydWN0IGZvbGlvICpmb2xp
bywNCj4gIAkgKiBzbyB3ZSB1c2UgZXhwbGljaXQgb25lcyBoZXJlLg0KPiAgCSAqLw0KPiAgDQo+
IC0JLyogUGFpcmVkIHdpdGggdGhlIG1lbW9yeSBiYXJyaWVyIGluIHRyeV9ncmFiX2ZvbGlvKCku
ICovDQo+IC0JaWYgKElTX0VOQUJMRUQoQ09ORklHX0hBVkVfR1VQX0ZBU1QpKQ0KPiAtCQlzbXBf
bWIoKTsNCj4gKwlpZiAobGlrZWx5KHBpbm5hYmxlKSkgew0KPiArCQkvKiBQYWlyZWQgd2l0aCB0
aGUgbWVtb3J5IGJhcnJpZXIgaW4gdHJ5X2dyYWJfZm9saW8oKS4gKi8NCj4gKwkJaWYgKElTX0VO
QUJMRUQoQ09ORklHX0hBVkVfR1VQX0ZBU1QpKQ0KPiArCQkJc21wX21iKCk7DQo+ICANCj4gLQlp
ZiAodW5saWtlbHkoZm9saW9fbWF5YmVfZG1hX3Bpbm5lZChmb2xpbykpKQ0KPiAtCQlyZXR1cm4g
LUVCVVNZOw0KPiAtCUNsZWFyUGFnZUFub25FeGNsdXNpdmUocGFnZSk7DQo+ICsJCWlmICh1bmxp
a2VseShmb2xpb19tYXliZV9kbWFfcGlubmVkKGZvbGlvKSkpDQo+ICsJCQlyZXR1cm4gLUVCVVNZ
Ow0KPiArCX0NCj4gKw0KPiArCWZvciAoOzspIHsNCj4gKwkJQ2xlYXJQYWdlQW5vbkV4Y2x1c2l2
ZShwYWdlKTsNCj4gKwkJaWYgKC0tbnJfcGFnZXMgPT0gMCkNCj4gKwkJCWJyZWFrOw0KPiArCQlw
YWdlKys7DQo+ICsJfQ0KPiAgDQo+ICAJLyoNCj4gIAkgKiBUaGlzIGlzIGNvbmNlcHR1YWxseSBh
IHNtcF93bWIoKSBwYWlyZWQgd2l0aCB0aGUgc21wX3JtYigpIGluDQo+ICAJICogZ3VwX211c3Rf
dW5zaGFyZSgpLg0KPiAgCSAqLw0KPiAtCWlmIChJU19FTkFCTEVEKENPTkZJR19IQVZFX0dVUF9G
QVNUKSkNCj4gKwlpZiAobGlrZWx5KHBpbm5hYmxlKSAmJiBJU19FTkFCTEVEKENPTkZJR19IQVZF
X0dVUF9GQVNUKSkNCj4gIAkJc21wX21iX19hZnRlcl9hdG9taWMoKTsNCj4gIAlyZXR1cm4gMDsN
Cj4gIH0NCj4gIA0KPiAgLyoqDQo+IC0gKiBmb2xpb190cnlfc2hhcmVfYW5vbl9ybWFwX3B0ZSAt
IHRyeSBtYXJraW5nIGFuIGV4Y2x1c2l2ZSBhbm9ueW1vdXMgcGFnZQ0KPiAtICoJCQkJICAgbWFw
cGVkIGJ5IGEgUFRFIHBvc3NpYmx5IHNoYXJlZCB0byBwcmVwYXJlDQo+ICsgKiBmb2xpb190cnlf
c2hhcmVfYW5vbl9ybWFwX3B0ZXMgLSB0cnkgbWFya2luZyBleGNsdXNpdmUgYW5vbnltb3VzIHBh
Z2VzDQo+ICsgKgkJCQkgICBtYXBwZWQgYnkgUFRFcyBwb3NzaWJseSBzaGFyZWQgdG8gcHJlcGFy
ZQ0KPiAgICoJCQkJICAgZm9yIEtTTSBvciB0ZW1wb3JhcnkgdW5tYXBwaW5nDQo+ICAgKiBAZm9s
aW86CVRoZSBmb2xpbyB0byBzaGFyZSBhIG1hcHBpbmcgb2YNCj4gLSAqIEBwYWdlOglUaGUgbWFw
cGVkIGV4Y2x1c2l2ZSBwYWdlDQo+ICsgKiBAcGFnZToJVGhlIGZpcnN0IG1hcHBlZCBleGNsdXNp
dmUgcGFnZSBvZiB0aGUgYmF0Y2ggaW4gdGhlIGZvbGlvDQo+ICsgKiBAbnJfcGFnZXM6CVRoZSBu
dW1iZXIgb2YgcGFnZXMgdG8gc2hhcmUgaW4gdGhlIGZvbGlvIChiYXRjaCBzaXplKQ0KPiAgICoN
Cj4gICAqIFRoZSBjYWxsZXIgbmVlZHMgdG8gaG9sZCB0aGUgcGFnZSB0YWJsZSBsb2NrIGFuZCBo
YXMgdG8gaGF2ZSB0aGUgcGFnZSB0YWJsZQ0KPiAgICogZW50cmllcyBjbGVhcmVkL2ludmFsaWRh
dGVkLg0KPiBAQCAtODM4LDEwICs4NTUsMTcgQEAgc3RhdGljIF9fYWx3YXlzX2lubGluZSBpbnQg
X19mb2xpb190cnlfc2hhcmVfYW5vbl9ybWFwKHN0cnVjdCBmb2xpbyAqZm9saW8sDQo+ICAgKiBS
ZXR1cm5zIDAgaWYgbWFya2luZyB0aGUgbWFwcGVkIHBhZ2UgcG9zc2libHkgc2hhcmVkIHN1Y2Nl
ZWRlZC4gUmV0dXJucw0KPiAgICogLUVCVVNZIG90aGVyd2lzZS4NCj4gICAqLw0KPiArc3RhdGlj
IGlubGluZSBpbnQgZm9saW9fdHJ5X3NoYXJlX2Fub25fcm1hcF9wdGVzKHN0cnVjdCBmcGFydGlj
aXBhdGVvbGlvICpmb2xpbywNCj4gKwkJc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2lnbmVkIGxvbmcg
bnJfcGFnZXMpDQo+ICt7DQo+ICsJcmV0dXJuIF9fZm9saW9fdHJ5X3NoYXJlX2Fub25fcm1hcChm
b2xpbywgcGFnZSwgbnJfcGFnZXMsDQo+ICsJCQkJCSAgIFBHVEFCTEVfTEVWRUxfUFRFKTsNCj4g
K30NCj4gKw0KPiAgc3RhdGljIGlubGluZSBpbnQgZm9saW9fdHJ5X3NoYXJlX2Fub25fcm1hcF9w
dGUoc3RydWN0IGZvbGlvICpmb2xpbywNCj4gIAkJc3RydWN0IHBhZ2UgKnBhZ2UpDQo+ICB7DQo+
IC0JcmV0dXJuIF9fZm9saW9fdHJ5X3NoYXJlX2Fub25fcm1hcChmb2xpbywgcGFnZSwgMSwgUEdU
QUJMRV9MRVZFTF9QVEUpOw0KPiArCXJldHVybiBmb2xpb190cnlfc2hhcmVfYW5vbl9ybWFwX3B0
ZXMoZm9saW8sIHBhZ2UsIDEpOw0KPiAgfQ0KPiAgDQo+ICAvKioNCg0KTEdUTQ0KDQpSZXZpZXdl
ZC1ieTogU2hpdmFuayBHYXJnIDxzaGl2YW5rZ0BhbWQuY29tPg0KDQpUaGFua3MsDQpTaGl2YW5r
DQo=

