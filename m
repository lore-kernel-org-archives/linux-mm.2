Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47596C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 07:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16226B039A; Sun, 16 Aug 2026 03:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC72C6B039E; Sun, 16 Aug 2026 03:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67EA6B03A2; Sun, 16 Aug 2026 03:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACBA6B039A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 03:48:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B449B1401AA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:48:56 +0000 (UTC)
X-FDA: 85106356272.21.5FB86CA
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012067.outbound.protection.outlook.com [52.101.53.67])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CAAC120003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:48:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=W6onujcb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.67 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786866533;
	b=JlkaExct4H0+hrScM9jRTiolY/JuTHkPcwJGXtGgHnEGDl4VwidWg/ORfb8cpGIHJPNaFA
	1+9V8rKP9QqGRAGX/8OU534MXJnRKv/btDLVni82gaiAthW36MciwGaHbnmZZvKFWTOApF
	0FllrGxA4cyvqloN/XMiv5gZ7GzLCrg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=W6onujcb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.67 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786866533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/azrFtI6+G7B9Cxzyp96sg/Xjk4Y10izZTdm+kLjdY=;
	b=SqKt4LzBoFf7IuHfoA0bm0XWIzJdMJb7QiHdfF6aRu8BwpnU8TXYeHandU+blsglL5wuy6
	YNwsH/b9Tuy8Egbp9ObmwBqHlL2L9SsmY15tMPY+DcKOqaMYaoH56xN77J1bUZB0H2DZUS
	Z8JbtUHohdoaEcM2vr5J3MWNVGbSXoE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LRJTkoFVGmmyel5mkKHrX4mrXWFDY6VyxsOdN7RC2pDr4Hn4vkuZ/wPJ2OUVm0AfrcjLNxOfvGJq+teb8l+LRIO+EYcr48zs4pM9cU/RF3uy4qrz2VzRjCI71omP4IHob0dkXDflvBLlUybeLwGCmCH2pqBTpbyLA5OTEbI248lWbAwQiCSSCdM1vBewRSY7zaRGGTdgrrLW1FWLr+2HBUFRzoD+LypCAcri9TznaotEOoelH2usyhpW1klc8LRKR8apOEhe895oK/OJxO/zmziRF+fj7MKh6CUCXGyEKBro+QL4/yH/oMew+97XRJst5C1Gq86av1QEMnsB9I54sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/azrFtI6+G7B9Cxzyp96sg/Xjk4Y10izZTdm+kLjdY=;
 b=p+z0PtxOmKieyxLDopUPVo3eXttA2My3lTomK6nCRUEZDmgxQtJO3Ddyk96rfQ1gwVwJ1YxTbfTE1DPGKMbsNV8i1zfXyp/2p60lsUeuC19n11X7CyW/hcVsleCalK5PtZvQ+I7QKrD8i7dN17fZksipC5hRTcQn7STyL2D1mmtqQvG8DCJs0tTQLJ3UlD/mmU150AAe1v3aLE81NADbMRs5CfizD59sd1pWQNTcWclmEMVF0G1F9kyx0+ShBokdu2iY/M++at/e2WGiojrBOEgRrXWKokgxEA/wGm41B1O1JGgyklwTpqDs1bNcLHqLxG0CIG449q9JW5vgFVyp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/azrFtI6+G7B9Cxzyp96sg/Xjk4Y10izZTdm+kLjdY=;
 b=W6onujcbNfAYhXRHD5q2HJUpVA8p6w1nYv6deeh94qPcZeQXXDYLMzImsgV5SNZYCU6wv6hm+NuKHhSfEWLiOK2r5cdv36Kq3uDt55e0ACT2dq7Ku7jpciop0g9pyS2cv55G6lGvGMyRmrvGjc37/04svScSnJO/xr01fcpS3Pk=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MN6PR12MB8543.namprd12.prod.outlook.com (2603:10b6:208:47b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 07:48:48 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0315.016; Sun, 16 Aug 2026
 07:48:48 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "rppt@kernel.org" <rppt@kernel.org>, "byungchul@sk.com"
	<byungchul@sk.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "harry@kernel.org"
	<harry@kernel.org>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "riel@surriel.com" <riel@surriel.com>,
	"david@kernel.org" <david@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "matthew.brost@intel.com"
	<matthew.brost@intel.com>, "surenb@google.com" <surenb@google.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"jannh@google.com" <jannh@google.com>, "liam@infradead.org"
	<liam@infradead.org>, "mhocko@suse.com" <mhocko@suse.com>, "ljs@kernel.org"
	<ljs@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "apopple@nvidia.com"
	<apopple@nvidia.com>
CC: "Rao, Bharata Bhasker" <bharata@amd.com>, "kinseyho@google.com"
	<kinseyho@google.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "kmanaouil.dev@gmail.com"
	<kmanaouil.dev@gmail.com>, "fvdl@google.com" <fvdl@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"weixugc@google.com" <weixugc@google.com>, "rientjes@google.com"
	<rientjes@google.com>
Subject: Re: [PATCH v2 1/7] mm: factor out generic PTE batch detection from
 swap_pte_batch()
Thread-Topic: [PATCH v2 1/7] mm: factor out generic PTE batch detection from
 swap_pte_batch()
Thread-Index: AQHdKtueM0yQWXpIfkS5aMhDVrNWlbabvpcAgAFxjACAAyF7AA==
Date: Sun, 16 Aug 2026 07:48:48 +0000
Message-ID: <89d8c2d6f35f7fdc3444ea3a62ccd244945d9644.camel@amd.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
	 <20260813-migrate-rmap-batch-v2-1-3c5424c555c7@amd.com>
	 <f2dbbe27-ba09-4213-ab74-92db526dde7f@kernel.org>
	 <2dddb3bb15dd9179388cef41a6564dbe722f9b1e.camel@amd.com>
In-Reply-To: <2dddb3bb15dd9179388cef41a6564dbe722f9b1e.camel@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|MN6PR12MB8543:EE_
x-ms-office365-filtering-correlation-id: f267d595-0547-42e9-9f31-08defb6ace8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003|38070700021|921020;
x-microsoft-antispam-message-info:
 alN2hiWDLtjS02tZi0WCU16+WO0pAZJ7JfLgWvuz6Y45A2cb3qKXC5biTrPLUYEYLL+5gQW+0/XgMrKhauqyV0PVnI0xBp2OFsw5KwRYAzJfVRVoGjofbNU+WwWCyQFQ5QYDkrlYWv0xDCa9SIqMxwBZtnf1C8OGDVBDDOpQAQcUHRGcsDKIuv5DwhQrJRvdhrz7CdAytyp5qCTXCykllpuYVCJKuuYhei6E0r8y+78mG86VKJSz4Q8jeYGsH/HSqOnKJxD7m8mrg5BTpy/GWh4TOSPbbw9Qc8CxMW1UBP3ixmpOoR1/ko/F6SmQ3Mud7SRUOoayCm09IA8Dk/bVPx5dw1JLhrTD9ewxwPuuI72EdrjO3ojkg1xSfOsz9Tp6btW/iepKvOW5nNUKxCnz0rXuRRhbfADIgAxM2kYjGtBI80NAtjWjlv/QEYnLe+0HshFCdp9EBZ2MEowSgji8zlq7he5tRPbEh66jozSoF6mTxGbC1WgKUwDzrZgNO8ABJa1CE1ZJGhR4EuAwU+/GSNyhsca5cfOLvFcJpcHvdd1Or5NyeiMe50zh7SgtXupC6050RjlLOM9oSUcD3dRgm4imud6AsF2BxD4y8QUZC4SIpWJkCe5iTuIU8puuL3lTVsULm0ErXkNT26Nq+9s1/R1pfSQ5jIcITiYXzzVJl2TIQR1CKfg/G+7LSETDDMPgHqvCgTHkAkMMMmdbAIoBhpk+thxvAk4fY16t7MaB2Xc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YWRkK0JrTmE1cGJiRUNuVVlZeGU4OWhXTWE5cXRQRWs1Z013SFlySjU3K21J?=
 =?utf-8?B?SkZPL1FSOWN4YXpGU3ppcHRtaW9xWmF3d3JiTnJjYjFQbjQ2b3o3Nno5bmFV?=
 =?utf-8?B?UXNBd1pNKzNUb3I0SUlNdVBoR3BEQVJMQWRxdE9FWmg1d0NROS9hSitGcVQ1?=
 =?utf-8?B?STFCdWUvaWkzQlVkMlJsMXRIbEx6YXcvZU95RXVCRi9mZHdDWnNGWE8waEdl?=
 =?utf-8?B?eDRSUWVZVkZTSzUwc1VRLzVBQ2VtRThjaEpJRzNwZmJRdFhrSkQzM1lkaHcv?=
 =?utf-8?B?MXNYYmZKTFR4Y3A0TzhFdk1GMzcvMjQ2OWthSlNxSFl1K1ZFMCtnV1JQUEsw?=
 =?utf-8?B?bTRRSWhsSjFXOWF6VW5rQWNiT29sRDZaeTdHMy9RVkYyckFCTzJiS3F0SkRC?=
 =?utf-8?B?VVBhclBJL3RkVTJqZTBBZ3JRSWlBZ2N1RkRveXEvVEU2c0pzSmErbURuL1N2?=
 =?utf-8?B?RzV6RWk2VXoyNS8wQWdReVd4Tksya3Fua045TWVHOWdBbW1KZHUvS3JSL0NJ?=
 =?utf-8?B?SGxFcEcxeHQ3Z2hZeFFEWHJDbGtseU00YmZpTkk4ME5PVVpIRG5NVlQ4andh?=
 =?utf-8?B?cVphUkc1d1B0TUdjOUJpWjZIekRHdm5GclErY2c5OWE5YkdvSzFsL29EM2dx?=
 =?utf-8?B?T0tNb2tKMkNkSk9aUGh4ZHlBZy9GMlhHQ3orcnIvSlNKSlljNW0yM3ROUkk4?=
 =?utf-8?B?YWI0SFRoNnpxRVZWOFEyVmpHR2NhbStWaTJYK3NyWXR4MjhnbW9qZ0ZsV1cw?=
 =?utf-8?B?RkoyMGFkaXVkOWFNeUZGQkJBRHFjUEdYUkxzSW1GbCtHV0V5d0F0R0xldkpT?=
 =?utf-8?B?WGJKLzZhK00ydm5HRXUxTjkvS205bjgvR3BtVE9VRVRPckdjWUoxY3NHdmRo?=
 =?utf-8?B?Y2xuOUFJdjRIR0VNb1NFa2ZveDVQcVZGWDFQaVkwYnZTdkRQUDdCYmlpUWVM?=
 =?utf-8?B?WWRFNnEwR1hoZlZtZDY0S0dBWEg0Rk9rWFRHT3lnZjNQcXRHUHp0QVp0bG8v?=
 =?utf-8?B?UFpGTjVJUVREdmtnZ3pyUGJhQmVLNmtLY0FvcUlUU0RiQjdBcFg2eXVHc3o3?=
 =?utf-8?B?TWlaekkvSXhLTUJEczU2QkhiVWszR0JVTXpoa01YZm5OODRmendHSFhScTVH?=
 =?utf-8?B?dkFTRFRuYkNjZkxoVDJiTWVhbWd4MEpnM1hpK3FuU2FzMWFva2NObVdaZGJT?=
 =?utf-8?B?WW8vY0xyZlZjN1dXcmNHSjc3ODJXL0k3c0Q0Y21TQlhoTktidnpoT3JMVk53?=
 =?utf-8?B?TFNYcmphaHhiQ0tpa2RZdTBEdUNVMklBR055UmdEYk4ybEMzOHJGM0haRUxm?=
 =?utf-8?B?Mnh6ekRVRXE0cjl0eEdoQ0loNkZ5SzQwSUwybTRrS2gralVTZ05RZVRRVkZR?=
 =?utf-8?B?Q2FOYWJ6c01iUW9mS3R1K09YYXNFYmtYOThucFVsS3hma3FVRTFxNDY1UU9i?=
 =?utf-8?B?dFBEajJscUtrRzhjMGp3R0ZHUVVqWXRhL3A0S1RDWHIyanUxNnh5K0szSDN5?=
 =?utf-8?B?eUMvTWQ0NGdtTUFMVzUyMjlYbDd4d1ozNXhIZFdwWllSRmFBd0d2UVdtckt1?=
 =?utf-8?B?Q2J2cDJhcXUraW9ZTE43UnNYKzJyQkhQWStzNmJQSXl2cDBWZFY1M2d2dEpO?=
 =?utf-8?B?UTIvb0pxWjRNcGFNTVRXZERHZ2pBWm5GeHV6SWNpQTMvb2VUSVFocDhBT3Yz?=
 =?utf-8?B?QytEdFZVYUd1U0ljWjhDVXhzRnVXQXQvL2puVm4yMFEwQUZodXYyQ0JCNmFy?=
 =?utf-8?B?b0ZzQWNJWXczUXp0OVhaMFJNQ00xQVJlWU80RDRqT2trOTBmNGlJL1pSdzdu?=
 =?utf-8?B?ZEFHRUd5ckVSTzNuQjZ2SEJpdk5yTUJsTGdtc2luUUZYY1N6N2RIVXdFQ3ds?=
 =?utf-8?B?V0lyNmJST0Q1YUFFY0xKYWlQZWRZcUp4elIzUWZndjZhNFQ4cCtWd05XbC93?=
 =?utf-8?B?dkk1eEpzSHVrcjVYMEtldUUwNU9wa256bHR6QmVrWG14aU03KzVFTm5GT2dH?=
 =?utf-8?B?dEUxWURzeWcwOW1wNnFqd2VaUGZMUE1YamI3Y3NDMlVJU2kyK1cxdU9nc1FC?=
 =?utf-8?B?SFlpVjExWVdlMFFxNFZ0NVVoUlJ4NHJYN2NQUFQwVFRZaDV0aVpvRnBWVm5X?=
 =?utf-8?B?UFBRUkRlWlJ3TkpvNllwQXQyS1RjSjdHbmxESWU1YWw3ZnMwNFNXSmVadDJh?=
 =?utf-8?B?aUxZZ0hDK1Y4WWsvWThCUHNxVkRMUGZldW91NDE0SlB6OGZ0Ui8yc2pUb1hV?=
 =?utf-8?B?ZS8xeTI1K0lWMmJWM3kwd0xyMVBva0hYc3NxQ2swZGlZYll1WnZxblFDQ0FF?=
 =?utf-8?B?NXBKWGgvRmlZbUxZdjluaFJvb1pHdmdKdUNQRnEvMmJRSUpMVndGZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E2C44399ED2A04A83B02FD2121A7C26@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f267d595-0547-42e9-9f31-08defb6ace8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2026 07:48:48.3429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QBQ3RLxpzZbPEkHNLo18GUdq2u36QUiJbsa1znluVh0vsnrkcrwtPxwMN4fUWE2thABNW1Ns3iODIrBtiTkBfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8543
X-Rspamd-Queue-Id: 8CAAC120003
X-Rspam-User: 
X-Stat-Signature: uaffitgoxqkwuyk6qhtjfndfdyyi7bn3
X-Rspamd-Server: rspam06
X-HE-Tag: 1786866533-537790
X-HE-Meta: U2FsdGVkX19DOYY4sywR/Z8fr4R4EAO7msyQmMduXd9L++WZ5cDsuCxmBoT5T3OMh3czKrD5iI7KgW+cnGKpnecrunjUrCSnfT8erOHRxaZSt/uVymmF6BJV00SjYeHFVAhtucGxvIK999yFGTexXtv43pZqEyoZmvpM4IMP32O7gj2vUNdEtcUxSTYqheUyxyN9u2XIgTkRuVffF6g2gHwGy7KV5Vevtew3fM39aK3LOYbT7I/QlY5IbBeL8E4rVSJQaInpuh5H2Q1hB0FaClCrVKLvv7SU1jTLbHGNrFUkMq0NndLOFChV7mDNPsA2hHx6LtEe4AbUYcoBOw3I9BTLt9jdgLzr+JawmQlx/e1rZ6BwaL9PXmCdecPzFVfw4svUA01BWJjN/FO/8APmLd7a5Ask56MH28TaVxJ9kgeh3rL4C1uYmrIIyB3IVPZYdLJfUZ2mzQPI3jm3M1HseFGUH89KwQR0qSQjWpXLEqqIgeqt9x8cFCEGSegSXesUzPfMz/xRWy7qretmo/brXQfgFZ95oXNCxerpXsDgtK0fXTvKFExBQCD5PrHLspOVvF8hz9i3GNzCSIMXJav7tgl6gGClZW33lzbpWRkjW4U6y2poJNQLHakcTgvaEK8e4DMke4dqVBem186w8bRT+xUnUerhOhteHIxvzvsEBCwCFlC5Kl9b/Pa/eXiDFp9qit3dPBKEr+BZnEPpB05xkIb4j1vAPJLjlXdtzwLdSQbDc9j915GTd9Xz8MwpTv23UcBz6VNo4sIk74Zl0vsrmBy7EqZG/8m9s8FlB1Sy+aFpwOrfbL96//j/4QSdRvEcysKlsUaK+Lj4uYSbb96GVlWB8Y7MnUQgYnYVmnIEOZ0FRhziKKFxO4tNbTXn2onYKXZ3iIZStUNIqU1emPPTP4/M6oWQ6pMCg77Ww/OzPMDMiIO5AjmTBxm4HmTKM9jq2XhA4Ogdi4I8nRAl+Ew
 ArnLTOVR
 TFlyuPDvWmnQ9m5jP1GF99EtcrLP4fx0rqCGCEiB/NAWCIYS+VoqC8prkGlU/P9RWbRMR7G3AbhUmRFYPyD6QX6LVbgBE8awyTfWZENNgNWC0jE44OOwv/fzWmFLs1dlS8UV7l1FVvwGZh7RllvdwRW+WU2lTk+fjrIPiR0lChB82joBQHnPT3Q3DP64TuYZ09Hx3BdeLq7cWyxkryhA7QgR7NVZXw+KFUO0WOZ8Cd8BIsRjWt7+WDg6pKbKl+0OiAbGYELpTVZbYCnNP+gjJMk4hZlG98ZIvvrK1d8Ee4koOvo3BQxM7X/aSMHC5geH9r26k+LbLpWQhIcvoNSrlQhw34CSKdrVJNd/czSnfWULt99rRdKDOwdeaxiHmR5dP1mFqjg5I3u5MS2QZctlr5hX5ejq3l6c3p3+Px6YRT5CBm2SVb8risTiCsTNpDYPYzDB+FOnKgqxdfw78P7gnAkuhSkvbIzMSa+XpInVlWXCiIWVZGeZzER5kL5v97ZQmYE2Q9ui5t0ueReygFBptBcYzWNfR7Vo9DURHixXUjM4P8V8BuNZoqHfiGyDFGby2kEcKRhO5PwG2mmHdy53od11bJlh77iZVIx7fjVi+6j5WFlup8INAJg64Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gRnJpLCAyMDI2LTA4LTE0IGF0IDEzOjMwICswNTMwLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+
IE9uIFRodSwgMjAyNi0wOC0xMyBhdCAxMTo1NyArMDIwMCwgRGF2aWQgSGlsZGVuYnJhbmQgKEFy
bSkgd3JvdGU6DQo+ID4gT24gOC8xMy8yNiAwNjoyMywgU2hpdmFuayBHYXJnIHdyb3RlOg0KPiA+
ID4gRmFjdG9yIG91dCB0aGUgZ2VuZXJpYyBQVEUgYmF0Y2ggZGV0ZWN0aW9uIGxvZ2ljIGZyb20g
c3dhcF9wdGVfYmF0Y2goKQ0KPiA+ID4gaW50byBzb2Z0bGVhZl9wdGVfYmF0Y2goKSBoZWxwZXIs
IHNvIHRoYXQgaXQgY2FuIGJlIHJldXNlZCBieSB1cGNvbWluZw0KPiA+ID4gcGF0Y2ggdGhhdCBh
ZGRzIHJlc3RvcmUtc2lkZSBiYXRjaGluZyBvZiBtaWdyYXRpb24gZW50cmllcy4NCj4gPiA+IA0K
PiA+ID4gc3dhcF9wdGVfYmF0Y2goKSBub3cga2VlcHMgb25seSBpdHMgc3dhcC1zcGVjaWZpYyBj
b25jZXJucyBhbmQNCj4gPiA+IGRlbGVnYXRlcyB0aGUgYmF0Y2ggZGV0ZWN0aW9uIHRvIHNvZnRs
ZWFmX3B0ZV9iYXRjaCgpLg0KPiA+ID4gDQo+ID4gPiBObyBmdW5jdGlvbmFsIGNoYW5nZXMgaW50
ZW5kZWQuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNoaXZhbmsgR2FyZyA8c2hpdmFu
a2dAYW1kLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIG1tL2ludGVybmFsLmggfCAzNiArKysrKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjEg
aW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQg
YS9tbS9pbnRlcm5hbC5oIGIvbW0vaW50ZXJuYWwuaA0KPiA+ID4gaW5kZXggYTVkMDQ4OGE1NGRj
Li4xZTFhYjUzYjY0MmUgMTAwNjQ0DQo+ID4gPiAtLS0gYS9tbS9pbnRlcm5hbC5oDQo+ID4gPiAr
KysgYi9tbS9pbnRlcm5hbC5oDQo+ID4gPiBAQCAtNTYwLDYgKzU2MCwyNiBAQCBzdGF0aWMgaW5s
aW5lIHZvaWQgc2V0X3NvZnRsZWFmX3B0ZXMoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHVuc2lnbmVk
IGxvbmcgYWRkciwNCj4gPiA+ICAJfQ0KPiA+ID4gIH0NCj4gPiA+ICANCj4gPiA+ICtzdGF0aWMg
aW5saW5lIGludCBzb2Z0bGVhZl9wdGVfYmF0Y2gocHRlX3QgKnN0YXJ0X3B0ZXAsIGludCBtYXhf
bnIsIHB0ZV90IHB0ZSkNCj4gPiA+ICt7DQo+ID4gPiArCXB0ZV90IGV4cGVjdGVkX3B0ZSA9IHB0
ZV9uZXh0X3NvZnRsZWFmX29mZnNldChwdGUpOw0KPiA+ID4gKwljb25zdCBwdGVfdCAqZW5kX3B0
ZXAgPSBzdGFydF9wdGVwICsgbWF4X25yOw0KPiA+ID4gKwlwdGVfdCAqcHRlcCA9IHN0YXJ0X3B0
ZXAgKyAxOw0KPiA+ID4gKw0KPiA+IA0KPiA+IFdvdWxkbid0IHdlIHdhbnQgc29tZSB3YXkgdG8g
bWFrZSBzdXJlIHRoYXQgdGhlIHNvZnRsZWFmIGVudHJpZXMgYWN0dWFsbHkgY2FycnkNCj4gPiBv
ZmZzZXRzIG9yIHBmbnMgb2Ygc29ydHM/DQo+ID4gDQo+ID4gPiArCVZNX1dBUk5fT04obWF4X25y
IDwgMSk7DQo+ID4gPiArDQo+ID4gPiArCXdoaWxlIChwdGVwIDwgZW5kX3B0ZXApIHsNCj4gPiA+
ICsJCXB0ZSA9IHB0ZXBfZ2V0KHB0ZXApOw0KPiA+ID4gKw0KPiA+ID4gKwkJaWYgKCFwdGVfc2Ft
ZShwdGUsIGV4cGVjdGVkX3B0ZSkpDQo+ID4gPiArCQkJYnJlYWs7DQo+ID4gPiArCQlleHBlY3Rl
ZF9wdGUgPSBwdGVfbmV4dF9zb2Z0bGVhZl9vZmZzZXQoZXhwZWN0ZWRfcHRlKTsNCj4gPiA+ICsJ
CXB0ZXArKzsNCj4gPiA+ICsJfQ0KPiA+ID4gKw0KPiA+ID4gKwlyZXR1cm4gcHRlcCAtIHN0YXJ0
X3B0ZXA7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+ID4gIC8qKg0KPiA+ID4gICAqIHN3YXBfcHRl
X2JhdGNoIC0gZGV0ZWN0IGEgUFRFIGJhdGNoIGZvciBhIHNldCBvZiBjb250aWd1b3VzIHN3YXAg
ZW50cmllcw0KPiA+ID4gICAqIEBzdGFydF9wdGVwOiBQYWdlIHRhYmxlIHBvaW50ZXIgZm9yIHRo
ZSBmaXJzdCBlbnRyeS4NCj4gPiA+IEBAIC01NzcsMjMgKzU5Nyw5IEBAIHN0YXRpYyBpbmxpbmUg
dm9pZCBzZXRfc29mdGxlYWZfcHRlcyhzdHJ1Y3QgbW1fc3RydWN0ICptbSwgdW5zaWduZWQgbG9u
ZyBhZGRyLA0KPiA+ID4gICAqLw0KPiA+ID4gIHN0YXRpYyBpbmxpbmUgaW50IHN3YXBfcHRlX2Jh
dGNoKHB0ZV90ICpzdGFydF9wdGVwLCBpbnQgbWF4X25yLCBwdGVfdCBwdGUpDQo+ID4gPiAgew0K
PiA+ID4gLQlwdGVfdCBleHBlY3RlZF9wdGUgPSBwdGVfbmV4dF9zb2Z0bGVhZl9vZmZzZXQocHRl
KTsNCj4gPiA+IC0JY29uc3QgcHRlX3QgKmVuZF9wdGVwID0gc3RhcnRfcHRlcCArIG1heF9ucjsN
Cj4gPiA+IC0JcHRlX3QgKnB0ZXAgPSBzdGFydF9wdGVwICsgMTsNCj4gPiA+IC0NCj4gPiA+IC0J
Vk1fV0FSTl9PTihtYXhfbnIgPCAxKTsNCj4gPiA+ICAJVk1fV0FSTl9PTighc29mdGxlYWZfaXNf
c3dhcChzb2Z0bGVhZl9mcm9tX3B0ZShwdGUpKSk7DQo+ID4gDQo+ID4gQW55IHJlYXNvbiB3ZSBj
YW5ub3Qgc2ltcGx5IHJlbmFtZSB0aGlzIHRoaW5nIGFuZCBkcm9wIHRoZSBWTV9XQVJOX09OPyBJ
IG1lYW4sIGENCj4gPiBjYWxsZXIgY2FuIGp1c3QgZG8gdGhhdC4NCj4gPiANCj4gDQo+IFRoYW5r
cyBEYXZpZCwNCj4gDQo+IEFncmVlZCBvbiBib3RoIHN1Z2dlc3Rpb25zLg0KPiANCj4gSSdsbCBh
ZGQgVk1fV0FSTl9PTighc29mdGxlYWZfaXNfc3dhcChlbnRyeSkgJiYgIXNvZnRsZWFmX2hhc19w
Zm4oZW50cnkpKQ0KPiBpbiBzb2Z0bGVhZl9wdGVfYmF0Y2goKSBmb3IgbWFraW5nIHN1cmUgaXQg
aGFzIG9mZnNldC9wZm4gYW5kIHJlbW92ZQ0KPiBzd2FwX3B0ZV9iYXRjaCgpLg0KPiANCj4gQmVz
dCByZWdhcmRzLA0KPiBTaGl2YW5rDQoNCmRpZmYgLS1naXQgYS9tbS9pbnRlcm5hbC5oIGIvbW0v
aW50ZXJuYWwuaA0KaW5kZXggYTVkMDQ4OGE1NGRjLi4zMWM3YzZhMDRlYWMgMTAwNjQ0DQotLS0g
YS9tbS9pbnRlcm5hbC5oDQorKysgYi9tbS9pbnRlcm5hbC5oDQpAQCAtNTYxLDI5ICs1NjEsMzEg
QEAgc3RhdGljIGlubGluZSB2b2lkIHNldF9zb2Z0bGVhZl9wdGVzKHN0cnVjdCBtbV9zdHJ1Y3Qg
Km1tLCB1bnNpZ25lZCBsb25nIGFkZHIsDQogfQ0KIA0KIC8qKg0KLSAqIHN3YXBfcHRlX2JhdGNo
IC0gZGV0ZWN0IGEgUFRFIGJhdGNoIGZvciBhIHNldCBvZiBjb250aWd1b3VzIHN3YXAgZW50cmll
cw0KKyAqIHNvZnRsZWFmX3B0ZV9iYXRjaCAtIGRldGVjdCBhIFBURSBiYXRjaCBmb3IgYSBzZXQg
b2YgY29udGlndW91cyBzb2Z0bGVhZiBlbnRyaWVzDQogICogQHN0YXJ0X3B0ZXA6IFBhZ2UgdGFi
bGUgcG9pbnRlciBmb3IgdGhlIGZpcnN0IGVudHJ5Lg0KICAqIEBtYXhfbnI6IFRoZSBtYXhpbXVt
IG51bWJlciBvZiB0YWJsZSBlbnRyaWVzIHRvIGNvbnNpZGVyLg0KICAqIEBwdGU6IFBhZ2UgdGFi
bGUgZW50cnkgZm9yIHRoZSBmaXJzdCBlbnRyeS4NCiAgKg0KLSAqIERldGVjdCBhIGJhdGNoIG9m
IGNvbnRpZ3VvdXMgc3dhcCBlbnRyaWVzOiBjb25zZWN1dGl2ZSAobm9uLXByZXNlbnQpIFBURXMN
Ci0gKiBjb250YWluaW5nIHN3YXAgZW50cmllcyBhbGwgd2l0aCBjb25zZWN1dGl2ZSBvZmZzZXRz
IGFuZCB0YXJnZXRpbmcgdGhlIHNhbWUNCi0gKiBzd2FwIHR5cGUsIGFsbCB3aXRoIG1hdGNoaW5n
IHN3cCBwdGUgYml0cy4NCisgKiBEZXRlY3QgY29uc2VjdXRpdmUgKG5vbi1wcmVzZW50KSBQVEVz
IGNvbnRhaW5pbmcgc29mdGxlYWYgZW50cmllcyB3aXRoDQorICogY29uc2VjdXRpdmUgb2Zmc2V0
cyBhbmQgbWF0Y2hpbmcgUFRFIGJpdHMuIEBwdGUgbXVzdCBjb250YWluIGEgc3dhcCBlbnRyeSBv
cg0KKyAqIGEgc29mdGxlYWYgZW50cnkgY2FycnlpbmcgUEZOLg0KICAqDQogICogbWF4X25yIG11
c3QgYmUgYXQgbGVhc3Qgb25lIGFuZCBtdXN0IGJlIGxpbWl0ZWQgYnkgdGhlIGNhbGxlciBzbyBz
Y2FubmluZw0KICAqIGNhbm5vdCBleGNlZWQgYSBzaW5nbGUgcGFnZSB0YWJsZS4NCiAgKg0KICAq
IFJldHVybjogdGhlIG51bWJlciBvZiB0YWJsZSBlbnRyaWVzIGluIHRoZSBiYXRjaC4NCiAgKi8N
Ci1zdGF0aWMgaW5saW5lIGludCBzd2FwX3B0ZV9iYXRjaChwdGVfdCAqc3RhcnRfcHRlcCwgaW50
IG1heF9uciwgcHRlX3QgcHRlKQ0KK3N0YXRpYyBpbmxpbmUgaW50IHNvZnRsZWFmX3B0ZV9iYXRj
aChwdGVfdCAqc3RhcnRfcHRlcCwgaW50IG1heF9uciwgcHRlX3QgcHRlKQ0KIHsNCi0JcHRlX3Qg
ZXhwZWN0ZWRfcHRlID0gcHRlX25leHRfc29mdGxlYWZfb2Zmc2V0KHB0ZSk7DQorCWNvbnN0IHNv
ZnRsZWFmX3QgZW50cnkgPSBzb2Z0bGVhZl9mcm9tX3B0ZShwdGUpOw0KKwlwdGVfdCBleHBlY3Rl
ZF9wdGU7DQogCWNvbnN0IHB0ZV90ICplbmRfcHRlcCA9IHN0YXJ0X3B0ZXAgKyBtYXhfbnI7DQog
CXB0ZV90ICpwdGVwID0gc3RhcnRfcHRlcCArIDE7DQogDQogCVZNX1dBUk5fT04obWF4X25yIDwg
MSk7DQotCVZNX1dBUk5fT04oIXNvZnRsZWFmX2lzX3N3YXAoc29mdGxlYWZfZnJvbV9wdGUocHRl
KSkpOw0KKwlWTV9XQVJOX09OKCFzb2Z0bGVhZl9pc19zd2FwKGVudHJ5KSAmJiAhc29mdGxlYWZf
aGFzX3BmbihlbnRyeSkpOw0KIA0KKwlleHBlY3RlZF9wdGUgPSBwdGVfbmV4dF9zb2Z0bGVhZl9v
ZmZzZXQocHRlKTsNCiAJd2hpbGUgKHB0ZXAgPCBlbmRfcHRlcCkgew0KIAkJcHRlID0gcHRlcF9n
ZXQocHRlcCk7DQogDQpkaWZmIC0tZ2l0IGEvbW0vbWFkdmlzZS5jIGIvbW0vbWFkdmlzZS5jDQpp
bmRleCBjMTc5OTM4MDk3YmYuLjhiZWQxYzU4YzRiYiAxMDA2NDQNCi0tLSBhL21tL21hZHZpc2Uu
Yw0KKysrIGIvbW0vbWFkdmlzZS5jDQpAQCAtNjkyLDcgKzY5Miw3IEBAIHN0YXRpYyBpbnQgbWFk
dmlzZV9mcmVlX3B0ZV9yYW5nZShwbWRfdCAqcG1kLCB1bnNpZ25lZCBsb25nIGFkZHIsDQogDQog
CQkJaWYgKHNvZnRsZWFmX2lzX3N3YXAoZW50cnkpKSB7DQogCQkJCW1heF9uciA9IChlbmQgLSBh
ZGRyKSAvIFBBR0VfU0laRTsNCi0JCQkJbnIgPSBzd2FwX3B0ZV9iYXRjaChwdGUsIG1heF9uciwg
cHRlbnQpOw0KKwkJCQluciA9IHNvZnRsZWFmX3B0ZV9iYXRjaChwdGUsIG1heF9uciwgcHRlbnQp
Ow0KIAkJCQlucl9zd2FwIC09IG5yOw0KIAkJCQlzd2FwX3B1dF9lbnRyaWVzX2RpcmVjdChlbnRy
eSwgbnIpOw0KIAkJCQljbGVhcl9ub25wcmVzZW50X3B0ZXMobW0sIGFkZHIsIHB0ZSwgbnIpOw0K
ZGlmZiAtLWdpdCBhL21tL21lbW9yeS5jIGIvbW0vbWVtb3J5LmMNCmluZGV4IGEzZDQ1MGQyMjVh
ZC4uNjg3Nzk2ZTFhZjg0IDEwMDY0NA0KLS0tIGEvbW0vbWVtb3J5LmMNCisrKyBiL21tL21lbW9y
eS5jDQpAQCAtMTg4OSw3ICsxODg5LDcgQEAgc3RhdGljIGlubGluZSBpbnQgemFwX25vbnByZXNl
bnRfcHRlcyhzdHJ1Y3QgbW11X2dhdGhlciAqdGxiLA0KIAkJaWYgKCFzaG91bGRfemFwX2Nvd3Mo
ZGV0YWlscykpDQogCQkJcmV0dXJuIDE7DQogDQotCQluciA9IHN3YXBfcHRlX2JhdGNoKHB0ZSwg
bWF4X25yLCBwdGVudCk7DQorCQluciA9IHNvZnRsZWFmX3B0ZV9iYXRjaChwdGUsIG1heF9uciwg
cHRlbnQpOw0KIAkJcnNzW01NX1NXQVBFTlRTXSAtPSBucjsNCiAJCXN3YXBfcHV0X2VudHJpZXNf
ZGlyZWN0KGVudHJ5LCBucik7DQogCX0gZWxzZSBpZiAoc29mdGxlYWZfaXNfbWlncmF0aW9uKGVu
dHJ5KSkgew0KQEAgLTQ3NTgsNyArNDc1OCw3IEBAIHN0YXRpYyBib29sIGNhbl9zd2FwaW5fdGhw
KHN0cnVjdCB2bV9mYXVsdCAqdm1mLCBwdGVfdCAqcHRlcCwgaW50IG5yX3BhZ2VzKQ0KIAkgKiBm
cm9tIGRpZmZlcmVudCBiYWNrZW5kcy4gQW5kIHRoZXkgYXJlIGxpa2VseSBjb3JuZXIgY2FzZXMu
IFNpbWlsYXINCiAJICogdGhpbmdzIG1pZ2h0IGJlIGFkZGVkIG9uY2UgenN3YXAgc3VwcG9ydCBs
YXJnZSBmb2xpb3MuDQogCSAqLw0KLQlpZiAoc3dhcF9wdGVfYmF0Y2gocHRlcCwgbnJfcGFnZXMs
IHB0ZSkgIT0gbnJfcGFnZXMpDQorCWlmIChzb2Z0bGVhZl9wdGVfYmF0Y2gocHRlcCwgbnJfcGFn
ZXMsIHB0ZSkgIT0gbnJfcGFnZXMpDQogCQlyZXR1cm4gZmFsc2U7DQogCXJldHVybiB0cnVlOw0K
IH0NCkBAIC01MDYyLDcgKzUwNjIsNyBAQCB2bV9mYXVsdF90IGRvX3N3YXBfcGFnZShzdHJ1Y3Qg
dm1fZmF1bHQgKnZtZikNCiAJCWZvbGlvX3B0ZXAgPSB2bWYtPnB0ZSAtIGlkeDsNCiAJCWZvbGlv
X3B0ZSA9IHB0ZXBfZ2V0KGZvbGlvX3B0ZXApOw0KIAkJaWYgKCFwdGVfc2FtZShmb2xpb19wdGUs
IHB0ZV9tb3ZlX3NvZnRsZWFmX29mZnNldCh2bWYtPm9yaWdfcHRlLCAtaWR4KSkgfHwNCi0JCSAg
ICBzd2FwX3B0ZV9iYXRjaChmb2xpb19wdGVwLCBuciwgZm9saW9fcHRlKSAhPSBucikNCisJCSAg
ICBzb2Z0bGVhZl9wdGVfYmF0Y2goZm9saW9fcHRlcCwgbnIsIGZvbGlvX3B0ZSkgIT0gbnIpDQog
CQkJZ290byBjaGVja19mb2xpbzsNCiANCiAJCXBhZ2VfaWR4ID0gaWR4Ow0KDQo=

