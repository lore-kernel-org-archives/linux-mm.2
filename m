Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBFD606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TsoE6tk4
Received: by kanga.kvack.org (Postfix)
	id C169F6B05B9; Thu, 26 Nov 2026 07:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED3A6B05BA; Thu, 26 Nov 2026 07:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC3B6B05BB; Thu, 26 Nov 2026 07:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D70C6B05B9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:21:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CB6BA8550
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:21:21 +0000 (UTC)
X-FDA: 85477180362.28.30C3196
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013035.outbound.protection.outlook.com [40.107.201.35])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3315512000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:21:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TsoE6tk4;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795695678;
	b=FbqJ/puvwiDOJO2lD2jrB7iqU+EGCmCPKUNLd1EEEGdD0wK1Cxyn/suU7ywgQpDbXsg54w
	fSowPagPyy6svq3ZVNasHx4r+w9RxzgTO7TLGnNIFypNerGd/PJQAtTg1BugNLZ7tSKFre
	mSKaAScTfpXX1F8fqDyJ3BnSUk6gSZk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKqbjrlBeH5cCiMV3vYm66ov3JDmFsLF8DzqSC1m94M=;
	b=IJIlKTvTF+3cPAVPaVquVhybJsZZqphDHvZw0Sq6rLsEsZkc4j89yzrToA6ULSog2VfQ8T
	rjneq0Hd4bQY7gazjxdaZQE36tJxKRN1muMYJY1zuUOHN4SvwRV50ZzB0Fmvfhbd3KlXyo
	aZ6g3L8SqHwOBcbnNpXYnfeHIwCaMBo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TsoE6tk4;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KuxmvRKDfReNzQt17LSo9AbfAUSLZyPPbBdA/nGUEcqZPECpFoyl/y0dcxEH6qmR8DCMrJtfOlFaGPyUO7l1du+hyc6yVPuaxlTBYTBzGyHytGsT062ZPTDuJc3y2lErhuHx5+/fis8taIZM5hCZt+J/UR2mCR3GdINz1yTvIJml9eUhTr858SPsOwS9xz6c1H0+M81P+rPFGFbwj+Fq9ZmmciwMZ4vVXu/mbyJMKw+CbobwouYmPWgzKyQLynL/GdOuDfbIfsVonL+ypHtu1x1cfFo+7YaEBCFEgpTBvMX1L7jEOvOI8argLhhUHrbjua7gDFb3TyFrslPNT30Sbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKqbjrlBeH5cCiMV3vYm66ov3JDmFsLF8DzqSC1m94M=;
 b=WKn7wI1J45YOT7e0p97e2eiN/1QZttvalYewM+p5f+1QEaSBLoie7VWULf0zxIXBdqYKRvRJgafEShct/VhmQXjibRjrF7WOnWgC/AFsefcd93qBuSl6kUWcWCtmItZk/ipeVdJaRVASz+8dHHy3ZvKIasskDFAk6e6Nys9kl9nDh2+qRrD8asyWSF0U1pN7qzXrPDyksPS/HNd2wMmZVVUVtDw2oQcVCScAcHNjb0bPcCWDe9MbK4RCGF0pxNl2qrQDvi4R+3Cj7r4gyOMIA7QcXvZQXf97SPRWt4tnXT8ZE68lgO7WTu8I3CowYvFX69RevlR176eh7W/ecRQphA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKqbjrlBeH5cCiMV3vYm66ov3JDmFsLF8DzqSC1m94M=;
 b=TsoE6tk4+uUY6iuNR9X5vLOpjzlgqXQZjfOIxAoe/A3xO1wn84FHSv+Y+GaK/yxykQNoSWqeEiXqsGdab9Uf166WErwGtWu5HbyRba07t6Ncw5gUk+66jmd48PYqPeMHcpWWlLhN7mEY6OdunK8Kwj+FpiTL0xRv2X+Gg0GcFbk=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS7PR12MB6006.namprd12.prod.outlook.com (2603:10b6:8:7d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Thu, 26 Nov
 2026 12:21:13 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Thu, 26 Nov 2026
 12:21:12 +0000
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
Subject: Re: [PATCH v5 7/8] mm/memory: use set_softleaf_ptes for uffd-wp
 markers
Thread-Topic: [PATCH v5 7/8] mm/memory: use set_softleaf_ptes for uffd-wp
 markers
Thread-Index: AQHdfYyPvpsxu0ObwU2+lRQw8PzZ17dARiQA
Date: Thu, 26 Nov 2026 12:21:12 +0000
Message-ID: <a13a7a785d5736b23be8ad8d71bbdc854cc20b05.camel@amd.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
	 <20261123053543.295467-8-dev.jain@arm.com>
In-Reply-To: <20261123053543.295467-8-dev.jain@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS7PR12MB6006:EE_
x-ms-office365-filtering-correlation-id: 2174ef7c-5cc7-4599-829a-08df4bb7c2cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|38070700021|10067099003|261026140227099003|11063799006|4143699003|56012099006|261022105027099003|261009223027099003|261021121427099003|261021123027099003|261102123227099003|261028144727099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 knJBx7Or3FeLJPDhBLnFiSZzGIOtxPIkfqfl4Ix6IlMoNFgHJ3tAXBtbhf8fd8H0gZDoWtQ1okJJSy0KW6kXBU/VSwTBrjMInAh4Quhgb9m0ZYb2PuTNGXDL7T/FJYwnf8ycn7/sWv/RO/rjYldbikdZYA2QgRSh1z933z9/5BEhltxrG0HGu8SlKjfhlzpKjd7WAaaGodOz82ws8fq6SFvxOI6Q/RQQVnF37gwRLPIPP+ZiS+FpywAmAC77O/5DRF2/KScajmiGKgsrIH7uWQBGbEYVYBtz7TAEvj4LfAyIT+xrOYLuLLrtZg2o8lpgov9LlatHBC+uiDQq19YVtow6tOuhO8ew8LP30jmffA6a+bnawRQTuAn5BucQtgQG/E9ySlSdzRbtwh3HC5IZdyTIt1SjDiVukOGVH3Ui0DWObYuYu1UBL4uGri1E10fEXwTFjJFL5jruV72zBfi76cbuAGw7oBbFJEf3Tg6toWSagKdhMSCcduSctKnb7D5kJcBc8bK6uIdOZ/XVyvNCv30YO6I2PGl1xkh07YiJtvc7ydPfvITYtczkmQIEZid0bFwFdX5qkitTx1X+S4aircDPFTKElxKgy3gyATb7l+dxNXctJcEHIsm0pMWxBFQaAv3nsOSfOKD1qsCHm5F22z9KbMDqMWgubeKMx01ooYtDmAVCfcuGRAm2qw0kdWTTcL4phTfH/dvgLxldwuz+oVtr9St2sMZDr2H9sks9VoY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(38070700021)(10067099003)(261026140227099003)(11063799006)(4143699003)(56012099006)(261022105027099003)(261009223027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261028144727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bEdoWWprWGVvOGVHYUI5bjArU09nL2t3blAwYVVIK2poQnozQnRiWDRsRGRD?=
 =?utf-8?B?Z1EySFFRRVJJb0Jla0VYSVVBbGNmRkJGZFhyenNzZ0lKNExLVERGRnFJK3kx?=
 =?utf-8?B?N3dzbEZwRVVuczIvNUtQWnlxcElhdkhqV2JSbkFIQUhpdno3SmwrN3RRZFhj?=
 =?utf-8?B?TWhKbEM4cFF2NGVBWTFtRmVpVGY2YlhEU1lUUnBFbGpKYWR1bS9NRjVEU01x?=
 =?utf-8?B?RzJnR2JrOTZ6a0E1N2dMZHd0dDNmS3NHZ1BHMGpHZkQxczVqTUFsTllhY1pM?=
 =?utf-8?B?S29lUU1JRlBnKzA3eGNwZ0U4Q0lCc0U1Vzloemk5TnhnQzVoUUwwdGJZb2NY?=
 =?utf-8?B?THZxRDhlSTdEMFJCUHd6eGdVcWtOMmpCbXl6K1p3MktLeEhMS29TendPek90?=
 =?utf-8?B?aXZFQk11M2tLSFViUW5wOHgwNWhuV2VwOUoxRTRDaGZKOHBwbDZVNDBtM2Nu?=
 =?utf-8?B?N3BEcER3YWR4RXpVTlhJNzNqb21FQ01zZnYvVG13RUZoNVJzNEFOQ1VCc0Jj?=
 =?utf-8?B?RXVmYkpaSnJLM2ZocUNpYkZ2UHhGSmNwc083ZXU3RkF3NXR2M0xCcDdlQUZl?=
 =?utf-8?B?M0lYbWF3SFBZendIWmdMZ3JaRWc2UGFvczVjalRDNjVyWC9mOXBCdnBqckZh?=
 =?utf-8?B?QTBUSDlnVFBtdm1oVk9jVURkUzM5d2U4Sk45UDlxY1NuTzlxTjhzbTJZQllr?=
 =?utf-8?B?U3c1ZlZwQVQ4eXltR0N2a1QyWmlHbDZtdUJacFVXNEdRUG5mV1c3MlhkYStv?=
 =?utf-8?B?NERwSXY3N09HUUtLclBEaEx3U0ltcS92N01WKzk2Q2dYTHpTVFVZa0RJa3dT?=
 =?utf-8?B?T1BJNC8wci81NXJpYWhQUmV2UWFkWVZ0ck5lUnpuR00xK3dhc04rcFppbkR4?=
 =?utf-8?B?M1Q1SklhbFE4Sm5pUVJ2MkdMaW9LRzFybEt2U0FBeUFSVTZ0dUJIVVNocVpj?=
 =?utf-8?B?czlwV08xMXMxKzBtSlRSQ0lYdEdlV0NIS3ozNkhNcldRZHA5dnZhanZtTGdi?=
 =?utf-8?B?NDhrd2RvUzlyRDJnejNrN3BYWGlVbjR4dnZsMHpPaTg5MENxaS93QXF1K0Fw?=
 =?utf-8?B?YWZNL0VzdWdubTc0L3ZvYXN0YWh0dlBxWVVhNUFtc3hKY3RNVHhQMERKTzR2?=
 =?utf-8?B?eXlXbjZPdHRXRElzNkszVkxBdWpYblp3dDQweEF5RFJUYkwrbmtUNXkwdzVD?=
 =?utf-8?B?M3lscWVIcG1PNjdycnVlOTBsZTFiaG91VnJwWGtKYm5BSHNtS3ozR1hxRy9Y?=
 =?utf-8?B?TVN0bWpBSFpmMTAwSkRVUXVqRjgyNS9vWTlJY05NejZhUlJ6Y1FnT0V4b3NC?=
 =?utf-8?B?Qm9IRzRnZFdSZHllWTRNZzVqT0FieUJydU9yWURPT0s3QVlFeVlhSkhReEJw?=
 =?utf-8?B?cG02c2ZITWhaMXg1a0pFNDV3dmhqdm9qNy9UK0wwOTJJT1d2T3NCTmxNaUZh?=
 =?utf-8?B?dUdpWlJGQ3cySXBMODh2cHlVeW9xSjVRWTFZNEdBV09QQWVkY3V4SFo1cU1w?=
 =?utf-8?B?WnE5T1d1bVZzV1ZUb0MyTEoyeXY5QlhSaS8waWdQTXV3ZllUT0JvdnFPY2h4?=
 =?utf-8?B?YUdJNkJ2ZHgxZkdvem9odXZFeURkZVpEUDF1SmJMbm55RkRuR3JOZFVvTXdm?=
 =?utf-8?B?Zk1LWUhURkdHaE5qWUxEd2dEUEllS29LZmVEYnVpUjJhaEc5emxUenlmQ0ZL?=
 =?utf-8?B?M25RRXV5UEtMRTJocVF4YThtaEY2OEc4YnZET205UEhIdlVGeDR6Y2U5Ny84?=
 =?utf-8?B?dmc4Sjc3VGdVTG9zY1oyWVJKVDVkTXdqbHZERHkyUVBXRTVGM0FVZDAyNjlN?=
 =?utf-8?B?aXFXR2NhcVRPNEF1akkvN242V0hkZGRxZndlSTN3MzZWR25UM1FSM25XQ0ll?=
 =?utf-8?B?Mi9WeUM1N0w3NXhGdmJZRVZONVVUZklDdG10dEVPVGNad3crUkpYWm1qZk4r?=
 =?utf-8?B?eVZGOXJMcmg2SVVhZVZRZnMwZ2M3L3BzQzFXdW9XcktxNmZtQTRTdTRrVzZz?=
 =?utf-8?B?bFRDTW9aTUE0WU1WbmFkZEFNOGRPOVpBTW83VlRzYUpGZjRwcGFtdjFQZDRh?=
 =?utf-8?B?TWU3V3NrSE9tekx4OW9WTmx3QTdVMHlYTmhGc3BVOWlKNkhEUUsyV1NyRVVq?=
 =?utf-8?B?bWlGTmxHdUxBdi94cmVJSGs1ZGRqUmw2T3k4aWFHNnNzWlJmWUZnRkZ0MGJr?=
 =?utf-8?B?NFczRTV4dzN1dTlFWWJ3YlpsRzdjeTJUZ2xPaEVteW8wRTBKQ0RmVDcvNU5t?=
 =?utf-8?B?eldDdzhjT3hBMUdCWFVNVldrVFgremYrWWdNdGxsZjRKUlNZbDNic3BXZHVs?=
 =?utf-8?B?eWxwbFVHZmU4ais2VDB2S0xqdlVwZWhzNlg0dHR2cEQwa2xsNUZMZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0B8F692CBEAFB4EBC85CA660169BFC9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2174ef7c-5cc7-4599-829a-08df4bb7c2cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2026 12:21:12.8653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hl9TxVmKHtHGsMCP0tVA/DKrTM+IJxoPVLcHbzj+NMWBkxc08L5bxfKZ/8Fqyq4GlUseV9UDsUFv0kA7WYIfRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6006
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3315512000D
X-Stat-Signature: fjfpxabac8owhqzsbdcgdrac9czn1bar
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795695678-51660
X-HE-Meta: U2FsdGVkX1/YIrUY0VKU8PP+Rh06qUW0JVVEbqnQN3craEqSwmOWxMilDStal4RcGTwQpKnsdSa+k9yNmaCXSJUnaW/ChzAo+YS+jcJYRP9xedDc1n04dma3EYgIHoActIMMzMfU7fb2N+nPR0eEHCeMX0xt2y577lstuxq95IiPA+RxnjWeM5Tp0sHIc1HBWK0WUA3cHCcIca3Vp1v7j3BDvG7aZAbLji94p4tT7/pDWKc2KHqVcML09nYAXFWFMappllBKEE5fGip91pOs3OqYoe+eRjhC1X/Lanv5i0gm+38RNlECbbIHhP7d9Pl+zdd6Xnio6ztKyfGMiHVIBr/ojRWQOEQaVqHgAqKgrL/Nk+uZn4v57B4pvLw8gz4lcA882b3hgQWM6BEcfG0VbKrPNlg+cSD5a45T0mMG8j6r6/X6Hkp+hLCKPm32OXr8dWI2a4PmnwhSw1bo6esZ+K97Dssk+2frIT05X9zYH66ZRvpXEonb0lzAWWEH1JL7koUFNOhDFcm9ovACPCK2+MU7S5b0J6Bxj+IOYiaRLIFkKBcZEZxFvoSfrBc6qzRoRTUf0RxCVjhYwngERudrcZauuf7liw/l9LYJ9RrCTk9dhMhCarQ4jKRpuijST9otAlafDfBA/G+UETFhRZA57kcxHPAIkegbfEm3UXQOTRBABYbfHuEvzqwi3ZNk12HFjinYGTZJ+xQ5DBmiUmbkfCAwbzAy2ICrRKPuyxQRXYr0BGkXInwDAglAS9Uygr/j4rgmxefEoVGz/wsy30P1mdI+80QWMfDrNZTCZ0k56RN57OfgHtgki7ijBvXPX8w/oXfqwcuUE+1n1maoxyBdUL8msym4CFgJNkS8qF/BHUfI5ZYrpTLgKBrEGt5eSIe7eMbNoCjCNmajUrTtCSRI7up66MeCIOK1C+5CGK0FWrHtC6F0H/PeD8KaqZRXSjVgJdpCTSlV6WeofNSur1G
 REQKmLOQ
 xA9eBULppKuTEv8wZg6TJM0JH4Fqz47zwEUsvJC3l6wQtemqdpT2wKI+uo05y0cbtuIg+i4jwhIoT170/wq0idhzqZ7owKiBRnl0PdDEIMnX9fTQK7dZ4pvFVEo5HHx8wOh+HAWXZmnF1GuMO9tMmfamWMY1JqA3kvOgQIMKd/2KWj/+xDup3W9uPUBsJy5Jaf3XdIPlD9KEPR13+Ojc/e+Yn2dJaM7muVH8QatxalgKRw/5SrTImcJ83D1cNEDBEmFD4QWjgmuct0/BPq/3Dn8hb7BcIblEYO3tp2A2OpodcsNvsv2SoelhGCtzUdBXH3vMgoBONNFStrdmBPlB03HrXensEyUjZ7mBhNf2w1gCU/mt6fc8qocKq+G+eZBHS6lkYpwUH3QCNfigGsJzBMEUsaU1Cxu2yHSzlPRhFBeKZxns0QBKk8npTiBGKZKEM4trEKcemZqek18uoYcv/HUvGTXCCI6aLapCWY7ptw6HRTb6wiJ+1YSxCMdaWaSrIWSPY2G3eMG943njKoAiys7OAiGSPIkW9ZmrB0BsxxytJ/UuFclMsmABUEdx3Yr+BT/kUnJRZAWqXYmgu095aaXBjcgc+SGI2V2HrZgDSGEk1QWqEe7GnXoYUC9ItQPeZpyBPDLLk+Z+dEDh4f6nyofIqRFKMQXSZzYdpDSHHoCTiVSAacTkSFQ4yhGkNG9VF1nZgyaTMC7T/Q8Q6swNDBzgA2AUjgOKkVdrquX4BAiU3Dpdhda5CFd+fXvitd0h2tGjIKNPtSUvBY+8wO47fo1b8vCOqQQzW5ZvXUNXoUKlfg+y23HY1sxrsXxRylGk8hU7SJjF+I0Cee437MPQZcXqjZNZ+rdb0sbn/Pmarl0Fq5eCLTHEEeO5IHUtely352gJkUsL5kuE9oIwmp5Hbhm0Ep/xpZuh9oJRgaTs5G/iR7BU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTIzIGF0IDA1OjM1ICswMDAwLCBEZXYgSmFpbiB3cm90ZToNCj4gVXNl
IHNldF9zb2Z0bGVhZl9wdGVzKCkgdG8gc3RvcmUgbXVsdGlwbGUgdWZmZC13cCBtYXJrZXIgZW50
cmllcyBpbnN0ZWFkDQo+IG9mIG9wZW4gY29kaW5nIHRoZSBiYXRjaGVkIHNldHRpbmcuDQo+IA0K
PiBSZXZpZXdlZC1ieTogQmFycnkgU29uZyA8YmFvaHVhQGtlcm5lbC5vcmc+DQo+IFNpZ25lZC1v
ZmYtYnk6IERldiBKYWluIDxkZXYuamFpbkBhcm0uY29tPg0KPiAtLS0NCj4gIG1tL21lbW9yeS5j
IHwgMTAgKystLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgOCBk
ZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9tbS9tZW1vcnkuYyBiL21tL21lbW9yeS5j
DQo+IGluZGV4IGE5YTcyOWQ1NWZhNy4uN2NhMjc3Njg3ZjRhIDEwMDY0NA0KPiAtLS0gYS9tbS9t
ZW1vcnkuYw0KPiArKysgYi9tbS9tZW1vcnkuYw0KPiBAQCAtMTcxNSwxNCArMTcxNSw4IEBAIGJv
b2wgY29uZF9pbnN0YWxsX3VmZmRfd3BfcHRlcyhzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwN
Cj4gIAlpZiAobGlrZWx5KCFhcm1fdWZmZF9wdGUpKQ0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICAN
Cj4gLQlmb3IgKDs7KSB7DQo+IC0JCXNldF9wdGVfYXQodm1hLT52bV9tbSwgYWRkciwgcHRlcCwN
Cj4gLQkJCSAgIG1ha2VfcHRlX21hcmtlcihQVEVfTUFSS0VSX1VGRkRfV1ApKTsNCj4gLQkJaWYg
KC0tbnJfcHRlcyA9PSAwKQ0KPiAtCQkJYnJlYWs7DQo+IC0JCXB0ZXArKzsNCj4gLQkJYWRkciAr
PSBQQUdFX1NJWkU7DQo+IC0JfQ0KPiArCXNldF9zb2Z0bGVhZl9wdGVzKHZtYS0+dm1fbW0sIGFk
ZHIsIHB0ZXAsDQo+ICsJCQkgIG1ha2VfcHRlX21hcmtlcihQVEVfTUFSS0VSX1VGRkRfV1ApLCBu
cl9wdGVzKTsNCj4gIA0KPiAgCXJldHVybiB0cnVlOw0KPiAgfQ0KDQpMR1RNIQ0KDQpSZXZpZXdl
ZC1ieTogU2hpdmFuayBHYXJnIDxzaGl2YW5rZ0BhbWQuY29tPg0KDQpUaGFua3MsDQpTaGl2YW5r
DQo=

