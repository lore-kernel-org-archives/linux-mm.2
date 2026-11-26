Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC44606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 10:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=H3nOkLNd
Received: by kanga.kvack.org (Postfix)
	id EF6046B05B4; Thu, 26 Nov 2026 05:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6CC6B05B5; Thu, 26 Nov 2026 05:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6DBF6B05B6; Thu, 26 Nov 2026 05:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0B056B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:36:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F04FA8809
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:36:48 +0000 (UTC)
X-FDA: 85476916896.19.9DF703C
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013064.outbound.protection.outlook.com [40.93.201.64])
	by imf23.hostedemail.com (Postfix) with ESMTP id 27FF0140003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:36:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=H3nOkLNd;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795689405;
	b=c0pi3bt2M3UhdMA/34jmJdHaYNyRYSfEWsSKJbenQZO5azGr01SzbroCPosnR5/ORgFfor
	lWIOUjdrDl60u/YF4AwxgomRY8rkbH3wtqFdqRy7g0WctQEMjQHlbxtSyd9hBMvBxXE/7v
	oAhQ2Way6mc77gk8a6Gh9AJOJN1f7XM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795689405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZtvu3I44CB1HT1okPm6jy4UccZB6CoAfzbcHHs1R/g=;
	b=t5y23TXgkhunSZW7NncwKRc3SdappW8/N9lV3eHxooHBtAq0k/gXqgpn6bqRWsnZUm0hmZ
	Da2NeStTQ0SRQcBqiusaAwCaeP4yy5YOLCZU40oOVOIQAPDSOjuk67eRvEW21GSjcotRCA
	YyxXISs45vgK5EoUpI/6SmyUI2/edOw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=H3nOkLNd;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MnbKIMf8mcahTppb6o01pWB5sqHc6ThyGZSy2zaao9KX2iV2P5gg2MEBHCQVLZyQ+YP9YFaUSQsTANdZxkzQQbP1qLAEicVIzakpbaifqPecB1NYKZufUJKxUyeMuS8rWBs0QWoVw5DAFUQYeGi2ibk9GSztdEQgwi42j9jGo+xFuJVsN6E3halZ/07d8oiayqU86VyOgTXXUNz6L5j9pAWn82k4qp7xGRZhblJPB4AFBcIXX/9U4ZysHRTwCZ52NfYQ8ThvrbRA2FWSqJ0zQfbfU6rdKnl7NcMvj8JVPbluTCyQU3PP8ena+lWXmSsnZ/gjivEQdgHlzwvXanjIjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZtvu3I44CB1HT1okPm6jy4UccZB6CoAfzbcHHs1R/g=;
 b=OcLmV2DuVu8t9oyNdMtAChP00yCyPqQrNm5cyrWLkZ/vlSQr3ihAVWb85lkjwob92RTWFvfg3lG3jBIUSRKr77TXTBWKeWh0DrhT8IlTz62CBHjMDKp7gi5+L0NW0oadIYNL/fTOlzcAo10BDIr/73c830sq9wVAlGbgelBkKEI3Hnr2RVQUvgQUKlWY2Y0mEGvOkiixv2E8hPZYdh5Sqy3OuwprGvOLX/XPuDD9xTMJYABRg60pveDBvjmyVBAG7w426pezgezrfKXIM2cdykIjvkoUjIWBF6LMa8xwyO1IGHVx+bjA/msDramgtU8mGmKDoNiKtjY/PoQRniwsLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZtvu3I44CB1HT1okPm6jy4UccZB6CoAfzbcHHs1R/g=;
 b=H3nOkLNdcE5s0OWtoQ8ctlxL7FfDopbt9w7ZqAwNHEzfuKvVjWm+nefPgik4MuhJp5DegLbDElz+OdICte6lI+ROzl80Q4F/Dfz44N1GsMeUmWKDljQ/Xn2+qn/KUafRqgQnS7sY3IeCQYSJrNgcwbwJqz2s+L78OSrji2WGto0=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS0PR12MB7803.namprd12.prod.outlook.com (2603:10b6:8:144::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 10:36:39 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Thu, 26 Nov 2026
 10:36:38 +0000
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
Subject: Re: [PATCH v5 3/8] mm: move anon-exclusive batch helper to rmap.h
Thread-Topic: [PATCH v5 3/8] mm: move anon-exclusive batch helper to rmap.h
Thread-Index: AQHdfYyN1LyXuNyjpkicYJabIu1ynbdAKOwA
Date: Thu, 26 Nov 2026 10:36:38 +0000
Message-ID: <54b76e018f98ebe341f705cb9b7d64d392d197e7.camel@amd.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
	 <20261123053543.295467-4-dev.jain@arm.com>
In-Reply-To: <20261123053543.295467-4-dev.jain@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS0PR12MB7803:EE_
x-ms-office365-filtering-correlation-id: 3dfc2b04-9826-4c49-58ce-08df4ba9271e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|4143699003|261009223027099003|22082099003|18002099003|3023799007|56012099006|10067099003|11063799006|261102123227099003|261021121427099003|261026140227099003|261028144727099003|261021123027099003|261022105027099003|38070700021;
x-microsoft-antispam-message-info:
 Mt5y7mabBCsk+F7znECAFhLLKCKj1JTk0k9U1B4T6a9lxl0Ea9fp0sFJB6ficvi9RfP0o2Hm56zapaYHBodPJyEQ3UU/WGLVt0AZvSrxHNLuYGDbeNEpq8WeoMyi/lY7pRq6E5xTeunLcdp8JVubn94oHl9q5zb9qpO0oxHaHMOISZrdcKQKvlBDoIjn1Sw0ny8boeH3A6tSDheniIQ+zCs4lIKWHn43gFhHOh4C2AxveJG5i1DfpGFqdF57x4SUeezZGt4+YewdnATelFNzyN6+aG+3XaWkRGuIXq9vdDEmMTV0PUTHLJr/Va4ThS4wjAy7zYwsjqLeoNtCMMuOpoKzmFL+bDCb49BxrrjSJOOWVPN5JMbbc8t+Ok1W6jSzsD/z/TOJ/he/A9J9Yqp9ytiaohvAdoqvrx902nh0az9AlXTAO9qqC9kWC3/YmtMg25IU1Fz1Ue8MoFs52UUHS/Vp3kLxCb+QblEr5FJpW5NSNAj54sV/OZLyjCb6lpOT6Lh9HIZ6kxyYpqLGMGiUUmd4ZNNGGcj9VZsNFPJMdKJhy3v7lk/NJcekDWpXZcx/vvA12/jkW6P+AmML2AolFEn4BKN2/YCKJMjPTVpF1g2t+iL5Kf4QFwTci0Ru1MQefjwECWeEnSOLfiR7wq1ZbfO5s+tN+TAXRcm4CGJVK8UKiMt/KWMY8ZAkGKMkfaYHSldEL3sMCAmpuDEXX5eUiDP2T0DLyvpTr1rVFEeu5r8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(4143699003)(261009223027099003)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003)(11063799006)(261102123227099003)(261021121427099003)(261026140227099003)(261028144727099003)(261021123027099003)(261022105027099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eUdGdjAyREJCa3d1bHNYekhNbTRLYnlzMU9KeDFFcVFqWVNyVTBORnh1ZzNk?=
 =?utf-8?B?SVNxV2lKYUtaQ0dNTVprZXRTOVFCbVFkZWVwOEtwQmNQWURma013WHQ4cnNK?=
 =?utf-8?B?Y3lBSEhyR2N0MUd4d1dGNkxHYXBjRE5CU1ZUTVh5T3J0U2c2N0t1ek9uSXRC?=
 =?utf-8?B?L2J0WUYzdCtQazR3bWZLdFZzU2Vadnp4cEJLN0s1TjZSVERsS1F3RnFWNWZE?=
 =?utf-8?B?TzVQWHZRU2IwbEpYY0p6VFk1NFo4UUNuWFJocHN4b21JbW1mYmxCb083cEVZ?=
 =?utf-8?B?QjZMWjJkNzRBQzBucTBEZkd2TG9mbU1yeGc2YVN1ZnA5OFEyQzN6MHkvaFJX?=
 =?utf-8?B?TE9Sc0hrSVNndVhQaE5zc0owVUV6MUJsYXB0Tm9DeHM1WXFkbWsrcmtLbHBN?=
 =?utf-8?B?Rys5OFczKzZFQjIxbEtvbURMenhlUGpFbnphZzd4L05heTFKcGVIMHFxR3pT?=
 =?utf-8?B?eHViVmMwWFBTMTVVNUFrUk5zVXdDOVUyakJXelpoTEwrRDZROGNhbFJiTWdt?=
 =?utf-8?B?aUFUaDl3N3hQaFJCd3hIR0hRMTdpSllPWDBMV3hrUFZVWUNoM1ZoUlBad2hn?=
 =?utf-8?B?bjNiZGNJUytjQ0tQMVEwUTRxeWs5T0JOVERKUHRFRVRZeDE1SGtwY2FOOG9r?=
 =?utf-8?B?aFU2YlArQVRzMTlvM0YwOUE1N2VkWDdCN3J2aXlld2YwejI4Vmd6MVpwTEFs?=
 =?utf-8?B?ZmtMcmV6WmRuWnJWc0ZrZHFha0NzNVE5L0hYd09WSlJEV0FIMnYvRzlLTjBp?=
 =?utf-8?B?WDlhRHl5M0VSZnRnYit3N0ZBbnBBR3NxRDk3TGZNTHVPK2w1dlJRam9zNTYr?=
 =?utf-8?B?dkp6akVudVFtakQxR3cxMGVOcml0VS83TkhCU1lrakpYNDBGdjY0WFc0NCtn?=
 =?utf-8?B?RWNBRXRSVHR3SWQzWVBFamQzK0VSTVV2MTQwYk9VWDlrMFFoai9abnhObWlX?=
 =?utf-8?B?allVYkVHelNkYVlwaFIrbXVjSWM3bUEvdnBZK0QyL1FWZGh0UkwwblR0Rlgy?=
 =?utf-8?B?dFhaVVdnYXRXeCtCTnlYVEVjTGtpSEVnWVpNdHowdXQ4M3lDZ2kwMS93NVlV?=
 =?utf-8?B?Y0cvVHJFb2pKN2hubDNrSU5yTDcreFRjRjZKWDNicU82bUVWcHdIT0tOWWVX?=
 =?utf-8?B?aUxhbDgyNEpYTC9talZZOTE0aUc5VnM0ditzRUZUaExLVk0zK0ZTejJoMFJw?=
 =?utf-8?B?cW44eVUxM1RwTWg0WVljWEN3aTZ0TUF4b3YzSnFkSUlYRXRwYU15YW04dVVy?=
 =?utf-8?B?aUZSYXBRZWxnb0V0NUJjQVdlbVV6M2lWQ09mMHp3bzBhc1phajJTR2tmQ1hY?=
 =?utf-8?B?dzdYdjNuK21PZ2VvVmg4VmcydG5UM1B0MEdGclRQTE9hM2V3dkc0clo0dGR1?=
 =?utf-8?B?cW1kR00xOGFWSTdFMmV1NlZZMjQzRWFwNlJLTmF2cGhSdlF4bGlveDh0bnZR?=
 =?utf-8?B?d0k4elUwekhtT1llZDBjU2dsUzlWaUdDaExrMFExc2FqbHZPdUU1YmIxdmpJ?=
 =?utf-8?B?T1lTaU9XalphNUxScHppT09iQkRSdGo1TEg4NHNyQmhBVFBvN3M4V0pCS1A0?=
 =?utf-8?B?Z2JZTE9WSnh2OTdVNnpOQTQ2VU5uK2NteXorYnluaEk2UGkxcUlsSnBUTE13?=
 =?utf-8?B?NWFkWWpvSHd2QnJvdm5IL0JqYXJZNWdCdWJGNURROVhKWUNGNktnZHpHZG9q?=
 =?utf-8?B?WDkzZENYQlZxV25mc0pJMDdaZTNRZVpXMlYybnQwVDJFZWNRMmVkTThqblUy?=
 =?utf-8?B?eGtwUVpFTmpmNkxEVFdPSlZOOHBkYWVocUlnTXJmcFdtQVljZmt1N0E0NHhh?=
 =?utf-8?B?MTFJeFVGeUFJVW41OWJuend0VGhPSkFmL3dVNGgyaCtjRHNkSjZ1QnZsNXp5?=
 =?utf-8?B?a2l6WU94RENRRXdwV0xzUlhCbkZJbUV2enYzQ1diK054bzhtMkd5cUpSVnNH?=
 =?utf-8?B?bGkrOGdyaVFRNXZEUll5dlpDOGpkVkVkVG1rTHBSR3ozVzlLckk1SVNUWmQ0?=
 =?utf-8?B?ZmVjTUdSWkpVdUJJSEhHdm9uN1VyUElxVExtdUQySXJTUWtqZVplWHVzSEFO?=
 =?utf-8?B?U0pFeUNZTStCL014cXphYnJYRDFMY0QzUzh4ZUU1WEZTUUVtcXdoVlVyM3p2?=
 =?utf-8?B?WmFnTmxxdmw0aERMTEVyVWk3ajhpam1FZ3YrS0ZKMkhQOGpaSVN5NVd3TXdJ?=
 =?utf-8?B?WTdwdHRvVmpvMTcybnhjVWNJZ3k1YlcxVENQbVNrUmhIU1VCRk9ZNVE5YWlx?=
 =?utf-8?B?elB0MFpIQURGSEFVcW51U2ZOTkgvNmFzNjI3N05GTHZ1bjVVVHJKT0JoeXJK?=
 =?utf-8?B?b2Uvc3ZKMXVIUHJQT0VGWHJqcnhjcnhDdll1ZTdUWVJtZ0pVNXNiZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E90A9C5215175418074B562B292D530@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dfc2b04-9826-4c49-58ce-08df4ba9271e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2026 10:36:38.7148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t8+HMNZH1Z/alAoMSECRwaFp+IbJuK9TiSrjYyPiOQlfHmiXmbTWlLdaOubKp+lmWdhYk6aAhXLtH0Da3noSbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7803
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 27FF0140003
X-Stat-Signature: 94zyog7abrrgsbik3p7mfncfnohq611m
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795689404-469227
X-HE-Meta: U2FsdGVkX1/doORnNjDjrCaneIWwuP1V+l/TpcqqJb/9eRBykvMJ2M0/TTcR64sS0A0/znt/yJq/2nhgTLKHTRLEunaRaYNkoY2iyNoYJ/8wM6BDUrcTdH7bAT1Rzn1AADLOos/I48bbNcqizq5dliJFxfnymXKimPSYzAlpD+9LU7cMAphWzjyYLrJ3R8y38E9cS6GrkGfvh2UaDaf/7dSFAd3Mc9YpVZOVeHA1cDHHsxgS7chJzf4bpgeXSIUKAWfgyUTtOITNxG4OSD1tWvkhVmp0flK0wJYJcSWE82tLfVJ4Owz8L+wBnGBjf+MfGDlaPsc3k/nqxYiC3hnqzTS8kHda2vjjCyBxlZV24qKSar4JcqdFLcRWM+UJGqcId+2dahhWVOv7UPj2VT3r7/Jl7vCLDMNVb7IXaE/9afFC3805LJ1CCAwDbgDn3w7hh6Q4rjujw+3muEGV1NkeFXMb2W8q24Kr6CE8oRqgdFZXdNzOnEVgsR5M6usjKr6/RWqZz/eJQp7hS1wf8KiDWQdA7q6jaJcurebh4mjr67jxdgIh0fu007TSxWj/4unPO9Jqln1rEvzWg2OWXg+DmxNimMCxM+hKEd99YtuB9AoH5idd7onHeAoH9HfghYS7zvJTQSfs9ZPBUURPy5UXjI62lolCEiYlrQakRCogaqHgq0Hg5jagbTFmewf3rcMcEVcRiSfXQM+xPU/iBhh1+ndp1IvfJeTrCmuOPT7NN8qrJHNRdPtVLWrp+x+zqRlhnV/ralHlcSW7Q4wzZLCWt2Hl4m9TV8QOhLn7Jh6RK+lJE98gKP3wukuTePTug/tG8U3a22RagTy+31zRJU+s2R9TSJs8PKA9yWZ4i7u7gPbcZwke2BfSt8qY8+UIdsJ7gZYEFhQPy9OIoLjBin7HBzEssSmIGewxp+aplWIuPSvRs3ttlpanLs0WnNKWQOxMKO4n816M3/GLO3CK+qb
 ZNowzVA8
 qd/pvtEbfl22q1YJ5+4QIlk/UvU+HGDadlItjfymoWe5K9/MUQgqtDL2Fr0nEyfQT1+kpGBF1BRJbVQfJtQNntS8xpJcl0tkCuuv0fvvrUWFzlIXhUSnk6CSr73Le1sB4AZF7qtUlvZpVAg9XDt/MjR8YkDutuUpCeRGZ3OFes6jSfch9RO2k7aW6RYy+xYr2CmgGFoFK9NqqxgBPxJSb7L/756L+CWlER1oyjHDSMn4QF58anLbLXuHmHJAAb3+UW2YNkyFfJFT96JWsi7DWtwsTiFpfWLwVN16kvCEClp41PXiyKNHmw0pJXOSErHKC63ml48sEvkoQ1dgiosZXmTRXvP7cx6KSmTj0CN0utMD8LLJFD7DaT53fVvLKJ3fp04r73K0EbBuYlRTkLWgHWmMmslXXIiU3lE1PPyfIOV1Ql9nn4kz5hfpCkcgyU0zr39Kv6HwIfcEsbmDvpK1swJOaIlwLzy35S7dSywz23xM2RUQ5NZoI7dBEHH5pG35q4ws+NI9d3xW23eXT4gnHpHYp5FA7UMjTYyZGD4orA+M4NT6ikjG3jeqaZmHoQ1Vbv6vzSCJ7q+mhtYX1Z11DVAjCDLrUoLUDEGpeJmA6xHEssvthaQPDhWxIujQP8xZho8rV+XfA2wjM13nd2aDWdVN3AFIiQD5c6IJh6D83IQEDSFPy7ETB1kk1PdSILuyLrURFDPhEt+DHRG3lQ7dvLEdXKH4spk/Y7hXYz+pMsy59ByCyfG8jCzOWoWIqnnKK5HGgpjy2bLP1J7mVjj04P6Uyz5qTFPiEF6TGFiDWFlJ74K0bJMv+6GIYy1Ip8iApG360Lj+UZzLUiGKZm9mpBbW32PDwyCSYGofeSz+sFYO9QdE7SiANcSGJ3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTIzIGF0IDA1OjM1ICswMDAwLCBEZXYgSmFpbiB3cm90ZToNCj4gSW4g
cHJlcGFyYXRpb24gZm9yIG9wdGltaXppbmcgbGFyZ2UgZm9saW8gdW5tYXBwaW5nLCB3ZSBuZWVk
IHRvIHJldXNlDQo+IHRoZSBwYWdlX2Fub25fZXhjbHVzaXZlX2JhdGNoIGhlbHBlciBpbiBybWFw
LmMgYW5kIHJtYXAuaCBhbmQgb2JleSB0aGUNCj4gZXhpc3RpbmcgdXNlIGluIG1wcm90ZWN0LmMg
Lg0KPiANCj4gVGhlcmVmb3JlLCBtb3ZlIGl0IGZyb20gbXByb3RlY3QuYyB0byBybWFwLmguDQo+
IA0KPiBXaGlsZSBhdCBpdCwgY2hhbmdlIHJldHVybiB0eXBlLCBzdGFydF9pZHggYW5kIG1heF9s
ZW4gdG8gdW5zaWduZWQgbG9uZw0KPiB0eXBlIGZvciBmdXR1cmUgcHJvb2ZpbmcgYWdhaW5zdCBU
SFAgc3VwcG9ydCBhdCA+PSBQVUQgbGV2ZWwuIEFsc28NCj4gbWFrZSB0aGUgaGVscGVyIHJldHVy
biB0aGUgYW5vbi1leGNsdXNpdml0eSBzdGF0ZSB0aHJvdWdoIGFuIG91dHB1dCBwYXJhbWV0ZXIu
DQo+IA0KPiBSZXZpZXdlZC1ieTogQmFycnkgU29uZyA8YmFvaHVhQGtlcm5lbC5vcmc+DQo+IFNp
Z25lZC1vZmYtYnk6IERldiBKYWluIDxkZXYuamFpbkBhcm0uY29tPg0KPiAtLS0NCj4gIGluY2x1
ZGUvbGludXgvcm1hcC5oIHwgMTggKysrKysrKysrKysrKysrKysrDQo+ICBtbS9tcHJvdGVjdC5j
ICAgICAgICB8IDI1ICsrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hhbmdl
ZCwgMjIgaW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9ybWFwLmggYi9pbmNsdWRlL2xpbnV4L3JtYXAuaA0KPiBpbmRleCA5ZjVi
ZmEzMTdhNWMuLmVjMWU4NTg1NWJlMSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9ybWFw
LmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9ybWFwLmgNCj4gQEAgLTEwNiw2ICsxMDYsMjQgQEAg
ZW51bSB0dHVfZmxhZ3Mgew0KPiAgDQo+ICAjaWZkZWYgQ09ORklHX01NVQ0KPiAgDQo+ICsvKg0K
PiArICogR2V0IG1heCBsZW5ndGggb2YgY29uc2VjdXRpdmUgUFRFcyBwb2ludGluZyB0byBQYWdl
QW5vbkV4Y2x1c2l2ZSgpIHBhZ2VzIG9yDQo+ICsgKiAhUGFnZUFub25FeGNsdXNpdmUoKSBwYWdl
cywgc3RhcnRpbmcgZnJvbSBzdGFydF9pZHguIENhbGxlciBtdXN0IGVuZm9yY2UNCj4gKyAqIHRo
YXQgdGhlIFBURXMgcG9pbnQgdG8gY29uc2VjdXRpdmUgcGFnZXMgb2YgdGhlIHNhbWUgYW5vbiBs
YXJnZSBmb2xpby4NCj4gKyAqLw0KPiArc3RhdGljIF9fYWx3YXlzX2lubGluZSB1bnNpZ25lZCBs
b25nIHBhZ2VfYW5vbl9leGNsdXNpdmVfYmF0Y2godW5zaWduZWQgbG9uZyBzdGFydF9pZHgsDQo+
ICsJCXVuc2lnbmVkIGxvbmcgbWF4X2xlbiwgc3RydWN0IHBhZ2UgKmZpcnN0X3BhZ2UsIGJvb2wg
KmV4Y2x1c2l2ZSkNCj4gK3sNCj4gKwl1bnNpZ25lZCBsb25nIGlkeDsNCj4gKw0KPiArCSpleGNs
dXNpdmUgPSBQYWdlQW5vbkV4Y2x1c2l2ZShmaXJzdF9wYWdlICsgc3RhcnRfaWR4KTsNCj4gKwlm
b3IgKGlkeCA9IHN0YXJ0X2lkeCArIDE7IGlkeCA8IHN0YXJ0X2lkeCArIG1heF9sZW47ICsraWR4
KSB7DQo+ICsJCWlmICgqZXhjbHVzaXZlICE9IFBhZ2VBbm9uRXhjbHVzaXZlKGZpcnN0X3BhZ2Ug
KyBpZHgpKQ0KPiArCQkJYnJlYWs7DQo+ICsJfQ0KPiArCXJldHVybiBpZHggLSBzdGFydF9pZHg7
DQo+ICt9DQo+ICsNCj4gIHZvaWQgYW5vbl92bWFfaW5pdCh2b2lkKTsJLyogY3JlYXRlIGFub25f
dm1hX2NhY2hlcCAqLw0KPiAgDQo+ICAjaWZkZWYgQ09ORklHX01NX0lEDQo+IGRpZmYgLS1naXQg
YS9tbS9tcHJvdGVjdC5jIGIvbW0vbXByb3RlY3QuYw0KPiBpbmRleCBlMThkNGUxMmZjMzQuLjAw
YWU3MzI4NDkwNyAxMDA2NDQNCj4gLS0tIGEvbW0vbXByb3RlY3QuYw0KPiArKysgYi9tbS9tcHJv
dGVjdC5jDQo+IEBAIC0zMCw2ICszMCw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvbW1faW5saW5l
Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvcGd0YWJsZS5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3Vz
ZXJmYXVsdGZkX2suaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9ybWFwLmg+DQo+ICAjaW5jbHVkZSA8
dWFwaS9saW51eC9tbWFuLmg+DQo+ICAjaW5jbHVkZSA8YXNtL2NhY2hlZmx1c2guaD4NCj4gICNp
bmNsdWRlIDxhc20vbW11X2NvbnRleHQuaD4NCj4gQEAgLTEzOCwyMyArMTM5LDYgQEAgc3RhdGlj
IF9fYWx3YXlzX2lubGluZSB2b2lkIHByb3RfY29tbWl0X2ZsdXNoX3B0ZXMoc3RydWN0IHZtX2Fy
ZWFfc3RydWN0ICp2bWEsDQo+ICAJCXRsYl9mbHVzaF9wdGVfcmFuZ2UodGxiLCBhZGRyLCBucl9w
dGVzICogUEFHRV9TSVpFKTsNCj4gIH0NCj4gIA0KPiAtLyoNCj4gLSAqIEdldCBtYXggbGVuZ3Ro
IG9mIGNvbnNlY3V0aXZlIHB0ZXMgcG9pbnRpbmcgdG8gUGFnZUFub25FeGNsdXNpdmUoKSBwYWdl
cyBvcg0KPiAtICogIVBhZ2VBbm9uRXhjbHVzaXZlKCkgcGFnZXMsIHN0YXJ0aW5nIGZyb20gc3Rh
cnRfaWR4LiBDYWxsZXIgbXVzdCBlbmZvcmNlDQo+IC0gKiB0aGF0IHRoZSBwdGVzIHBvaW50IHRv
IGNvbnNlY3V0aXZlIHBhZ2VzIG9mIHRoZSBzYW1lIGFub24gbGFyZ2UgZm9saW8uDQo+IC0gKi8N
Cj4gLXN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgaW50IHBhZ2VfYW5vbl9leGNsdXNpdmVfYmF0Y2go
aW50IHN0YXJ0X2lkeCwgaW50IG1heF9sZW4sDQo+IC0JCXN0cnVjdCBwYWdlICpmaXJzdF9wYWdl
LCBib29sIGV4cGVjdGVkX2Fub25fZXhjbHVzaXZlKQ0KPiAtew0KPiAtCWludCBpZHg7DQo+IC0N
Cj4gLQlmb3IgKGlkeCA9IHN0YXJ0X2lkeCArIDE7IGlkeCA8IHN0YXJ0X2lkeCArIG1heF9sZW47
ICsraWR4KSB7DQo+IC0JCWlmIChleHBlY3RlZF9hbm9uX2V4Y2x1c2l2ZSAhPSBQYWdlQW5vbkV4
Y2x1c2l2ZShmaXJzdF9wYWdlICsgaWR4KSkNCj4gLQkJCWJyZWFrOw0KPiAtCX0NCj4gLQlyZXR1
cm4gaWR4IC0gc3RhcnRfaWR4Ow0KPiAtfQ0KPiAtDQo+ICAvKg0KPiAgICogVGhpcyBmdW5jdGlv
biBpcyBhIHJlc3VsdCBvZiB0cnlpbmcgb3VyIHZlcnkgYmVzdCB0byByZXRhaW4gdGhlDQo+ICAg
KiAiYXZvaWQgdGhlIHdyaXRlLWZhdWx0IGhhbmRsZXIiIG9wdGltaXphdGlvbi4gSW4gY2FuX2No
YW5nZV9wdGVfd3JpdGFibGUoKSwNCj4gQEAgLTE3MywxNiArMTU3LDE1IEBAIHN0YXRpYyBfX2Fs
d2F5c19pbmxpbmUgdm9pZCBjb21taXRfYW5vbl9mb2xpb19iYXRjaChzdHJ1Y3Qgdm1fYXJlYV9z
dHJ1Y3QgKnZtYSwNCj4gIAkJc3RydWN0IGZvbGlvICpmb2xpbywgc3RydWN0IHBhZ2UgKmZpcnN0
X3BhZ2UsIHVuc2lnbmVkIGxvbmcgYWRkciwgcHRlX3QgKnB0ZXAsDQo+ICAJCXB0ZV90IG9sZHB0
ZSwgcHRlX3QgcHRlbnQsIGludCBucl9wdGVzLCBzdHJ1Y3QgbW11X2dhdGhlciAqdGxiKQ0KPiAg
ew0KPiAtCWJvb2wgZXhwZWN0ZWRfYW5vbl9leGNsdXNpdmU7DQo+ICsJYm9vbCBleGNsdXNpdmU7
DQo+ICAJaW50IGJhdGNoX2lkeCA9IDA7DQo+ICAJaW50IGxlbjsNCj4gIA0KPiAgCXdoaWxlIChu
cl9wdGVzKSB7DQo+IC0JCWV4cGVjdGVkX2Fub25fZXhjbHVzaXZlID0gUGFnZUFub25FeGNsdXNp
dmUoZmlyc3RfcGFnZSArIGJhdGNoX2lkeCk7DQo+ICAJCWxlbiA9IHBhZ2VfYW5vbl9leGNsdXNp
dmVfYmF0Y2goYmF0Y2hfaWR4LCBucl9wdGVzLA0KPiAtCQkJCQlmaXJzdF9wYWdlLCBleHBlY3Rl
ZF9hbm9uX2V4Y2x1c2l2ZSk7DQo+ICsJCQkJCWZpcnN0X3BhZ2UsICZleGNsdXNpdmUpOw0KPiAg
CQlwcm90X2NvbW1pdF9mbHVzaF9wdGVzKHZtYSwgYWRkciwgcHRlcCwgb2xkcHRlLCBwdGVudCwg
bGVuLA0KPiAtCQkJCSAgICAgICBiYXRjaF9pZHgsIGV4cGVjdGVkX2Fub25fZXhjbHVzaXZlLCB0
bGIpOw0KPiArCQkJCSAgICAgICBiYXRjaF9pZHgsIGV4Y2x1c2l2ZSwgdGxiKTsNCj4gIAkJYmF0
Y2hfaWR4ICs9IGxlbjsNCj4gIAkJbnJfcHRlcyAtPSBsZW47DQo+ICAJfQ0KDQoNClJldmlld2Vk
LWJ5OiBTaGl2YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+DQoNClRoYW5rcywNClNoaXZhbmsN
Cg==

