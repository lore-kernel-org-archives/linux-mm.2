Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B879606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=BF8zoI/h
Received: by kanga.kvack.org (Postfix)
	id 2175E6B00EF; Wed, 11 Nov 2026 14:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8136B05B0; Wed, 11 Nov 2026 14:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08FD26B05B1; Wed, 11 Nov 2026 14:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D633A6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:37:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6776F1603AC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:37:21 +0000 (UTC)
X-FDA: 85423847082.01.34A56F7
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010014.outbound.protection.outlook.com [52.101.46.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1CB14140003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:37:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="BF8zoI/h";
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.14 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794425838;
	b=vXAOtI/uEVr0ZiXtUSX60hUMsIfIkw+dxJg9LJI37nC3vRVGXZT9WVXm8zifaLGiBIXjty
	YEmgbexW8CBd0viOkxbLo4WPI88hMFs10iumvX8MHJK8TgA7z7NIa/fWmwjDb0yU3BkvO3
	MgaWHlZStfDGDl8RVMhYDijhqP3AC9U=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="BF8zoI/h";
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.14 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794425838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AUl9Ut/8OJAUj5bM5RoMgoP5Zj0mVCTyaZ8XKO40Ls=;
	b=Jl/SZd2y+QX3JwevhjUq0NpMAWc0ETEARUA7EIdsTbzRWRdCdZ+1W6YIdoX9HJF46sBXdT
	TabTadU5uuiXpj5eA4oQOKm+XqmX5/ltU1vQAFBi7hLDwlnWrOneGIwP1jJmCZxrdpnQia
	NQm6ifXWEK2Cn/czfKGrwYKWR1ANV7E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TrBmxsvfoRwvRL9weUXSuDj4FRdy5geXUyBaDsOTuGv0pr4w9Kh968/C3SGw3D0QUbXSTBAdjwJCf0QbFgAsalpJscoqzkGDGgrmaA3wMVjQknlK1yjywsCWfxDT0/3IWwfpc7ZiZT5I0dKldTzd2lP9+aIeUVTfI3GxztPRSitmuhTy4EGncRTK0xbuTBRrH1pXfnuu4Bl8qinHh/pIKUNOijPa1hJ9oIsPfatBXlIo3c1zxvxhQoDljcHhVMiUxMiU8bNPc0sfexxFPeZ8awtl2fW7o69ZeLkluHzNPya3QxQo/ux0JKRlXaG2Ceb3wPx0VxJ5pLOw8fe8HnNOJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AUl9Ut/8OJAUj5bM5RoMgoP5Zj0mVCTyaZ8XKO40Ls=;
 b=t3uwOsK+zG7BCRwOpzen4l59wcrOpXxb44ZlOG6K1Ya6bElud1Ia2MlLoBLS3sL33sm9xem9lwCKOe2BN4K7qbfOmIiOZdGUMLl4uJcpiRUfItIooYveZwKoN6O36dJPDA0cUUX/tz3TTXXrWICc4le3kEzU6vk3AoudvclbH3Udy91v/KFy/baSgVgz5QwTqoY3zyP9rRg9QYBc7uIHh5mPUvnD9PGEsxIJ0YjIa19EVvcvuUHwBtSeFEVzvSvHb+pdVzeg4qsT5vjlC2CHgC+bF6k9alaGgX82YTmN7jcqtJwKbx6iOUqem07HMleZwCcRyAJHfGZW9uMWdZfDhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AUl9Ut/8OJAUj5bM5RoMgoP5Zj0mVCTyaZ8XKO40Ls=;
 b=BF8zoI/hChR7f7BqT4REq4Ca+dMaBEgVJ5JBS/Cw3f9JMXZ2F8Ogr5Xq2zkcuXUY0n80sxSsixAe2Gmk/KsrLJ7iHb9WF181cts8wMkbNmQUr6ETbBDTh+u5+2PSJirgBb4lDYr06j8Ju8oVCEEgYJDNQlZrQwLmi32O5wOrZJA=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CH3PR12MB8545.namprd12.prod.outlook.com (2603:10b6:610:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 19:37:10 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0592.007; Wed, 11 Nov 2026
 19:37:10 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "joannelkoong@gmail.com" <joannelkoong@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kmanaouil.dev@gmail.com" <kmanaouil.dev@gmail.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "weixugc@google.com" <weixugc@google.com>,
	"byungchul@sk.com" <byungchul@sk.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "harry@kernel.org"
	<harry@kernel.org>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "riel@surriel.com" <riel@surriel.com>,
	"david@kernel.org" <david@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "matthew.brost@intel.com"
	<matthew.brost@intel.com>, "surenb@google.com" <surenb@google.com>,
	"rientjes@google.com" <rientjes@google.com>, "kinseyho@google.com"
	<kinseyho@google.com>, "Rao, Bharata Bhasker" <bharata@amd.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "gourry@gourry.net"
	<gourry@gourry.net>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"usama.arif@linux.dev" <usama.arif@linux.dev>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "jannh@google.com" <jannh@google.com>,
	"liam@infradead.org" <liam@infradead.org>, "mhocko@suse.com"
	<mhocko@suse.com>, "ljs@kernel.org" <ljs@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "fvdl@google.com"
	<fvdl@google.com>
Subject: Re: [PATCH v2 0/7] mm: batch rmap walks during large folio migration
Thread-Topic: [PATCH v2 0/7] mm: batch rmap walks during large folio migration
Thread-Index: AQHdKtuV/eiFrK3jmk+wSylHll9Sibcoi/SAgAFGZ4A=
Date: Wed, 11 Nov 2026 19:37:09 +0000
Message-ID: <2ed65a57aaa676a59651abd671f18dc9b55f9195.camel@amd.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
	 <CAJnrk1ZkhvyGLUyZrf_gA3XBv1XTfHArGOMgqr=5XbSCBJHz4Q@mail.gmail.com>
In-Reply-To:
 <CAJnrk1ZkhvyGLUyZrf_gA3XBv1XTfHArGOMgqr=5XbSCBJHz4Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|CH3PR12MB8545:EE_
x-ms-office365-filtering-correlation-id: 4551b37b-f7af-4f12-300c-08df402b2d61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|4143699003|11063799006|56012099006|38070700021|22082099003|18002099003|261022105027099003|10067099003|261026140227099003|261028144727099003|261026121527099003|261009223027099003;
x-microsoft-antispam-message-info:
 Y60wWgIlhvADbvq6jJZCokQYQXX41hRX0EDw4R1JWcxw1vZwhucLlTHRavqp2cDVIUodvvfzEQefK5erZJhhzhqnAMImRXwFQF5Ev+kVnRF77sQyiudrQkigpbvRBMqm4k0j5tc+vtpIDGm4kFoNvwRvb8Ll3TVXZPYaSM/Si0OrjSZSx3vQRaxACbts1QVg5W/QUwoVyiJ4vcJOXiCXPHukDxqFsNbbBSR/wZ2AzfZNxLFI1Y4YZxinwHtREYKf0O9VpOFJRzMueP0KKZh4a+uDyl3GgRa0dTjFWCFbeTAX92ucom+ZuWx6JHA4zR5Rfvf34lbSQMQHpI0XGCYHy0xR9FnJ9q3vLlkO9xi0jY5KIArSISJLPLgZkYPF42RGeuaLRKKGGO/8WVOmCtQTZcFGm/P+ZxJGf1mLAi2g4PZRgtXicbVT9zdp8iTbZ20c8A1KC8ulZNnr+VlAjEvBYPS9hfrI604jwKJhJkktSsyK/DT9yFV5WLI5F3Jz3mUyoC14/HyQKY+EbyMddvNM85dOn68vO8szfj3NLpb0cUfGPjHnKnOb5NGcHcjIrpek3m+VCcyOEqC8P1nE7kc0yFLifr70F5nqoaDOU4U8abpzTT5D7xQem570xKyMKcDiHgtS8SD5x4y9n9aT2ccsrzWBsyj0/5RPIet/ICsYA2o=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(4143699003)(11063799006)(56012099006)(38070700021)(22082099003)(18002099003)(261022105027099003)(10067099003)(261026140227099003)(261028144727099003)(261026121527099003)(261009223027099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WHQ2UFRqZ1ZaeGxsMTIxWDl4YlpsQTNsaExVN1BuZ0haOExQQVRiMEROdHow?=
 =?utf-8?B?YXZRb1ZxZnJ6S0dPdUVvcFJPSXNUQkVMbkZ5TTZGOUZWWjZjbm1vandSdkpK?=
 =?utf-8?B?L0NpNTBnWFlLd1F3eHdoV3FTS0V2aTBiNlZzMFhuUWtITXZuS2t5b1ZpdlNn?=
 =?utf-8?B?cmovZWlLWVJoMHllb1E4QmZnOEVwaFdnL2ZPYjVIMlhZcW5GSUs5OENwOXVZ?=
 =?utf-8?B?Snp2a0VUd1lQcW1wLzB2OHVQUGs2emNCNytud29iVXUyZUFUODJGN3JSeDN1?=
 =?utf-8?B?azdRcDY1STRUc2N5WEhFNGxFbDR0WUVUbExkSHZZUmJkbklPYThTUGxoa28y?=
 =?utf-8?B?a1J0WkFGS1JjaHJYU3J1QWVEdWk5QnZVRXovVmtZRDlZNXVFdU9NRjhYU0V4?=
 =?utf-8?B?S2gzRzlkZWFJZkFYUzBDMFRyelpRT0M2RlBpck1KNEVoc3dDdCtweThrajBH?=
 =?utf-8?B?VXVscHdMOEt1Ukc4RzMwUzByTEVNNm9KRkpKV1ZjQWp5T1BOSmQvVHNiemRx?=
 =?utf-8?B?M21pYlBoR2lhS2lEaDhSZUsxUTdyb1dUSTBvNkJBNFhxQ1AvYldaN0lqdmtD?=
 =?utf-8?B?UDFOMnBPZUJSTnpwbzJkZHFEL01Wam9QeU9CdVJKZUJQeUlSZ0lod2R3dERE?=
 =?utf-8?B?VXFIMzFxdmZUR0RXdUgyWWsyWjcxZVM4MU15YllabUdtWGVSUTJRY1hRQVdS?=
 =?utf-8?B?a1B5WHNDcmhqNDh5Vzd5Y3ZqNGZ0U20zZDdLWkI0cG1XQ3F6bGxCUWNoT2ly?=
 =?utf-8?B?OThxS1I3MkM2VnArSjNtRXBhcEVtU3hKSGZNa3FSQ244TVZoczZhNlppK2lk?=
 =?utf-8?B?NG9lbWlIR0V0SDhQV0dIU3BSSUlqeUJSNy9zMy9EdHgyMEdEOWFKd0ZVNzJH?=
 =?utf-8?B?anBxK2lrN2VIUmY3Z0N2TkdNWmNnR0s5TXV4aXFobXNiZktLVU14RCsrbjVU?=
 =?utf-8?B?amNtSHUzNUlFd0dqdVlic2NWMjdyTkI3Um83WEZFYTFnZ2cyUjYrWDNzNm9I?=
 =?utf-8?B?UTAvOFlGYTFyMnJ6NEJOKzlRMEhuZ1ZBdkd2SGsxdThwTzNGMTUwSXFQbHpx?=
 =?utf-8?B?Y0w3Szg1SUVIVjBMTWRjamVBVnVHM2x3UndRc1c0TlE3TWJFR3dVYVBqVFFa?=
 =?utf-8?B?ai9OTmdDcGZZMnV5bkJKa3lCWkljZXdtN291d2JEc3dmUGNCM0g2bGR4dDlI?=
 =?utf-8?B?OU5kYjN5TzdWa0lyTEZYeTIxT1d3elA3a3FVcS9XUXNocEI5NVlNZDcwTG5C?=
 =?utf-8?B?c3dkcnZZdTV0RW5uWWZZUTJQU3R3cmNvemZlOEg5SFdmMTRBSEpLekphMUZ0?=
 =?utf-8?B?QlM4RkNWVUtPVFAyVVljbVlPV1JCS1g2NzNuaG5MemFTZXcxNkdaZWZYYjAr?=
 =?utf-8?B?cTZIS202dFc4OFNIQjNvL2dsTXBkN041S3J5V3JnSlU2SCtnZGhmd0hhNUo4?=
 =?utf-8?B?eVQ3SHAwYVUybDdYaytPazkycFY2alpmbm9va2FnQ0paUUxUdStuTmdwOWlG?=
 =?utf-8?B?TWpsYVZQdXA2ejB6Ny8vaGduRlVBbjNSVUprV3l1SlRFWjQ0ajMvUTlWWlps?=
 =?utf-8?B?T1dyc3IzUHNMT2lPdmNyTlhSYXR6Qi9WK1IxdlVwTzZRSDZKNXNobVUvQUdy?=
 =?utf-8?B?d0xCMEl3cmZ6bHN5NHVnMXlzRExpdFE5dmNDV1M4VEpXNU1jWEgzSWZ1OHIz?=
 =?utf-8?B?SkhQdndueGVFcHZ1TjJTZ3N2QWpzdXJXUGs1bjN1Z0pPTVpvVUVTWFh6Z0Vy?=
 =?utf-8?B?Wm9NVTYyR0w5Z1gxK2htNGhpZ0xYZTI4ZXUyTU8vRjI0Z1hBaEFORXFiaDlQ?=
 =?utf-8?B?L0NNbmVoaTVBSllWMEoxdnd2cjQ0cnl6cWJwQUVvRWFBTk1tWldieittb3FF?=
 =?utf-8?B?QTllT1RUVjJ0WWtYaWxZZWc5ZE5MUjQ4TTBBc0JpVm1WTG9tVHlFMHZPeXMx?=
 =?utf-8?B?bmhsQys1QzFBSGI2ZDgrTGg5endJTjUrRm1Wb3NMWTVWcjZmZHp5K2ViWXBw?=
 =?utf-8?B?Vlh3Y2o2Kzd5N2ZUZER4dloxQWZ3SXpvZ2VrY2JZWVFaejVlQ3RyQWVtK0th?=
 =?utf-8?B?UksybmxQUVJQY25JTDU5cWQ3cFI3VmQzdjlDVVRqZVpIb1pMaHhQR3l6ZkZr?=
 =?utf-8?B?YVRwTlQxdjVzVnBOMWVFaWJlWlNlUWdHUG9CL08zMFVOY2lqR3I3SW1jUEcy?=
 =?utf-8?B?T0cveklDUWg2OHM0d0hDbW10RUpuWURFSnJLNk1yN0Q2N1VLczFxcXNUYmsw?=
 =?utf-8?B?TzJ6Wmh6ZEdoRm1wcFhqQk5XVXpYcGtEdUlSTGhhTWw2NzJRTFllODNwV0d4?=
 =?utf-8?B?QTlnRGFNeFJXRm8vSXBsZzlKb0xWTGEvSEpkbGVVMHpRME9QZlNodz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84819FC9B853B64EAFB99700B0FB30DB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4551b37b-f7af-4f12-300c-08df402b2d61
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2026 19:37:09.8451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tj00nz1yxLm0KhlAslnLdUv/csPe8mrg6sQzv6sxhYqaAQ2DMiC4jv7MHkT+NaW2YeH1uBpZaEf0+nR3QS64hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8545
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1CB14140003
X-Stat-Signature: kqws661sbztk1x9a6ruan4fgk17crkwb
X-Rspam-User: 
X-HE-Tag: 1794425837-317687
X-HE-Meta: U2FsdGVkX19ufxlE74GZgjz51yp5oIbj5zqsUZgJ7njBJpimHo5AiZVQ5L8SwTXNPVIr7eaqtygwNm/vrNpp8J6Yfm2OrtPvSSGLvPJ6W8RTbZgAs60aqZB0bc1CzPMhCXG0iEfF6jnqy0XKbmgSBrUjUPTPI3GkE/IlOG5shGrT1mZT7mPqRustbOyW3GtQ6hrpfYYeAcGRJoJ0OgQRK2MgSsgdzwtq9kYWIybG3DHysWYlQhWsaN7J7YoX8HKD44QN5hLi2EdySEytex6Z9TJpP7neyTEPjQOpo01ufaGd2hekxR6jkSEd99OfXfWDkf1A440YCzrM02rCsw8AkpwBcfkojne+1qZHA/Qug5MeOPivUfOWOvUJOOn48oZiep3xwRFUKzh7SWVDUb+XHcPmv57lvPRnENDZQFqli4dSr5+ht811390folIbykJZs1zi81yB1EQaF+5ucyVG+ADWK4CLRAnsu/7ziYceELtGYOaxidQ0sARU8UMOZ7vC4B8krdDLggpg9fuc+QwuKVbmAw31pIUztw+Or/ZT7/SppZGGQvdP+b/z5WB3jlmeq2b2NqPHx+KtgfrABh2DdXic/PdwWKgrVZieMT0McI4TfAJkq01hgI3mxoY8S4myAQmAwvJk5wO2stpaKj90+3FbAJg3/5sZ5eNZULJi5MB9H/rriomrRs+KzR5tcqPqnTIREAw/jIPARpxOR60goH33dzq+EvCtpQYyqaAoro5xMcLZ6dCZakm3ajBtRobG2dvJAnI+d6x8ncohJ17OhdnVGdPO4+Vgc97uy0ORWRVIO59o/ztHEVeWOH3Cr4n4mlQ5ezJ8SWHjuahoNTyzFPT2cimVYS2CUc7pjeA+vUVrCAZC8tODo9kxCIVaaA0yyeIOBtas/+mwdj3irjmMTfZi3wrHtqZJV6Gwgn0Ck3tnzFIvOP6B03P8vMrWD2BnHsLTA+/aC66gddLe8fe
 85NftIKx
 tFu8D7uPQo7trl8KBwVcLglzFmj98E1mxPvcuSiUbVcLRqV95DWJ0HJP0zJnaqd5OIGHpjHLxtfHJoHEdyRIB+JQP2c7tpv4NhWc7/Bls/LbZNE4YzrhdPRusY2V7Rg9FW8AbYxl7E8GvyM0ME/CZWxUNfPK0d/POuvewHVGf4UWMzzD9CYADIBGYFwAp/4AHiih0e+wVu6M39piiZvfoSah3UvhNaBpoD4cVCteL8DjdBZhHGCNORjwASL92ksdqqMLxgw17aO7+8Qbedh2EbkFYtQGl76nzck505e2P9vO7RqJWFRcgqeFJkTknSFl7vIT96clEuQ5/+Y+Q+FecPbxoeAW7tGF+oIlM3klx1I/b2m/r1TfcVyEQoRCwySw5eGU5mkgYIsk/qyFMyTXLAAfBlV+kG6W6t2G06KexSjyslOCFou/hY/IkdLY2VOawlR+tXseSQmYfSjz8gwFvOdc+ipSPG92zQGrt0d+bn2LPLLarp5BIUobgzQFWuNfzEAVDja9ZhR/tduyJTe5ZVJBJx2lbjlTbfgkdXOARzpikwJ/Z5BOGiaYQYcy4xoO8rJVVquxVcOeSTLgePagWyScD+i3c+/9NPjirOUV5bQ3BJ/y+9aP6Nq706W7aiJ2LVrbZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gVHVlLCAyMDI2LTExLTEwIGF0IDE2OjA4IC0wODAwLCBKb2FubmUgS29vbmcgd3JvdGU6DQo+
IE9uIFdlZCwgQXVnIDEyLCAyMDI2IGF0IDk6MjTigK9QTSBTaGl2YW5rIEdhcmcgPHNoaXZhbmtn
QGFtZC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE1pZ3JhdGluZyBhIFBURS1tYXBwZWQgbGFyZ2Ug
Zm9saW8gY3VycmVudGx5IHdhbGtzIHRoZSBmb2xpbydzIHJtYXANCj4gPiBvbmUgcGFnZSBhdCBh
IHRpbWUuIEl0IGRvZXMgc28gdHdpY2UgcGVyIG1pZ3JhdGlvbjoNCj4gPiAxLiB0cnlfdG9fbWln
cmF0ZV9vbmUoKTogUmVwbGFjZSBwcmVzZW50IFBURXMgd2l0aCBtaWdyYXRpb24gZW50cmllcw0K
PiA+IDIuIHJlbW92ZV9taWdyYXRpb25fcHRlKCk6IFJlc3RvcmUgbWlncmF0aW9uIGVudHJpZXMg
dG8gd29ya2luZyBQVEVzLg0KPiA+IA0KPiA+IEZvciBhIGZvbGlvIHdpdGggTiBjb250aWd1b3Vz
IFBURXMsIGVhY2ggd2FsayByZXBlYXRzIHBhZ2Vfdm1hX21hcHBlZF93YWxrKCkNCj4gPiBhbmQg
dGhlIGFzc29jaWF0ZWQgb3BlcmF0aW9uIHBlciBzdWJwYWdlIG9mIHRoZSBmb2xpby4gKDI1NiBp
dGVyYXRpb25zDQo+ID4gZm9yIDFNIGZvbGlvKS4NCj4gPiANCj4gPiBUaGlzIHNlcmllcyBlbmFi
bGVzIGJvdGggd2Fsa3MgdG8gcHJvY2VzcyBhIGJhdGNoIG9mIGNvbnNlY3V0aXZlIFBURXMNCj4g
PiB0aGF0IG1hcCB0aGUgc2FtZSBsYXJnZSBmb2xpbyBhbmQgZG8gc29tZSByZWZhY3RvcmluZyBh
bmQgY2xlYW4gdXAgb24NCj4gPiB0aGUgd2F5Lg0KPiA+IA0KPiA+IFBlcmZvcm1hbmNlOg0KPiA+
IA0KPiA+IEFNRCBFUFlDIFpFTiAzLCAyLXNvY2tldCBzeXN0ZW0gKDEgbm9kZSBwZXIgc29ja2V0
KS4NCj4gPiBtb3ZlX3BhZ2VzKCkgbWlncmF0aW5nIDEgR0IgZnJvbSBub2RlIDAgLT4gbm9kZSAx
LCB0aHJvdWdocHV0DQo+ID4gaW4gR0IvczoNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgIGJh
dGNoLSAgICAgICAgIGJhdGNoLXJlc3RvcmUNCj4gPiBmb2xpbyAgICAgdmFuaWxsYSAgICAgICBy
ZXN0b3JlLW9ubHkgICArIHVubWFwICAgICAgICAgcmVzdG9yZSUgICByZXN0b3JlK3VubWFwJQ0K
PiA+IDRLICAgICAgICAyLjk2wrEwLjE1ICAgICAzLjAywrEwLjE0ICAgICAgMi45OcKxMC4xNyAg
ICAgICAgICsyLjIlICAgICsxLjAlDQo+ID4gNjRLICAgICAgIDUuOTnCsTAuMTAgICAgIDYuMTLC
sTAuMDggICAgICA3LjY1wrEwLjE2ICAgICAgICAgKzIuMiUgICArMjcuNyUNCj4gPiAyNTZLICAg
ICAgNi40OMKxMC4wOSAgICAgNi42N8KxMC4wOCAgICAgIDkuMjPCsTAuMTQgICAgICAgICArMi45
JSAgICs0Mi40JQ0KPiA+IDFNICAgICAgICA2Ljc2wrEwLjEwICAgICA2Ljk4wrEwLjEwICAgICAg
OS43NMKxMC4xOSAgICAgICAgICszLjElICAgKzQ0LjAlDQo+ID4gMk0gICAgICAgMTAuNTDCsTAu
MjAgICAgMTAuNDTCsTAuMTYgICAgIDEwLjY3wrEwLjIxICAgICAgICAgLTAuNSUgICAgKzEuNiUN
Cj4gPiANCj4gPiBJbiBwbGFpbiBtaWdyYXRpb24sIHRoZSBmb2xpbyBjb3B5IGl0c2VsZiBkb21p
bmF0ZXMgdGhlIGNvc3QsIHNvIHRoZXNlIHJtYXAgd2Fsaw0KPiA+IHNhdmluZ3MgYXJlIG9ubHkg
cGFydGx5IHZpc2libGUgZW5kLXRvLWVuZC4NCj4gPiANCj4gPiBXaGVuIHRoZSBmb2xpbyBjb3B5
IGlzIGJhdGNoZWQtY29weSBhbmQgb2ZmbG9hZGVkIHRvIERNQSBlbmdpbmUgWzFdLCB0aGUgY29w
eSBpcw0KPiA+IG5vIGxvbmdlciB0aGUgYm90dGxlbmVjayBhbmQgcm1hcC13YWxrIGJhdGNoaW5n
IHRyYW5zbGF0ZXMgaW50byBtdWNoIGxhcmdlciBnYWluczoNCj4gPiANCj4gPiBUaGlzIHNlcmll
cyArIFsxXSwgRE1BIE9mZmxvYWQgb24gUFRETUEgKERDQk0pLCAxNiBjaGFubmVsczoNCj4gPiAN
Cj4gPiAgICAgICAgICAgICAgICAgICAgIGJhdGNoLWNvcHkgICAgICAgICAgICAgICAgICAgICAg
ZGNibStyZXN0b3JlDQo+ID4gZm9saW8gICAgdmFuaWxsYSAgICAtb2ZmbG9hZChkY2JtKSAgZGNi
bStyZXN0b3JlICAgICt1bm1hcCAgICAgICAgICAocm1hcCBiYXRjaCBpbXBhY3QpDQo+ID4gNEsg
ICAgICAgMy4wNcKxMC4xMyAgIDIuNzbCsTAuMTEgICAgICAgMi43N8KxMC4xMiAgICAgICAgMi43
NMKxMC4wOQ0KPiA+IDY0SyAgICAgIDUuODXCsTAuMTEgIDEwLjY2wrEwLjI3ICAgICAgMTEuNTbC
sTEuNDUgICAgICAgMTcuNTXCsTAuNTYNCj4gPiAyNTZLICAgICA2LjI2wrEwLjA4ICAxMy42NMKx
Mi43MyAgICAgIDEzLjY4wrEwLjE2ICAgICAgIDM0Ljc2wrEwLjU3ICAgICAgICgyLjU0eCkNCj4g
PiAxTSAgICAgICA2LjU4wrEwLjA4ICAxNC4yNcKxMC4wNyAgICAgIDE1LjI3wrEwLjc3ICAgICAg
IDQ0LjI4wrEwLjI3ICAgICAgICgzLjExeCkNCj4gPiAyTSAgICAgIDEwLjYxwrEwLjI0ICA2NS4y
NsKxMC45NiAgICAgIDY1LjI1wrExLjY1ICAgICAgIDY1LjY2wrEwLjg3DQo+ID4gDQo+IA0KPiBI
aSBTaGl2YW5rLA0KPiANCj4gQXJlIHlvdSBwbGFubmluZyB0byBzZW5kIGEgdjMgb2YgdGhpcyBz
ZXJpZXM/IE15IHJlYXNvbiBmb3IgYXNraW5nIGlzDQo+IGJlY2F1c2UgYmF0Y2hpbmcgdGhlIHVu
bWFwIGFsc28gZml4ZXMgYW4gZXhpc3RpbmcgaXNzdWUgd2hlcmUgd2hlbg0KPiB0cnlfdG9fbWln
cmF0ZV9vbmUoKSB1bm1hcHMgYSBQVEUtbWFwcGVkIGFub24gbVRIUCBvbmUgUFRFIGF0IGEgdGlt
ZSwNCj4gdGhlIGZvbGlvIGxvb2tzIHBhcnRpYWxseSBtYXBwZWQgcGFydHdheSB0aHJvdWdoIGFu
ZCBnZXRzIGZsYWdnZWQgZm9yDQo+IGRlZmVycmVkIHNwbGl0LiBNeSBtVEhQIHVuZGVydXNlZCBz
aHJpbmtlciBzZXJpZXMgWzFdIG1ha2VzIHRoaXMgbW9yZQ0KPiBjb21tb24gc2luY2UgZXZlcnkg
dW5kZXJ1c2VkIG1USFAgc3BsaXQgd2lsbCBub3cgZ28gdGhyb3VnaCB0aGlzIHBhdGgsDQo+IHdo
aWNoIG1ha2VzIHRoaXMgYnVnIGEgYmxvY2tlciBmb3IgdGhlIHNlcmllcy4gTW9yZSBjb250ZXh0
IGNhbiBiZQ0KPiBmb3VuZCBpbiBbMl0sIHdoaWNoIHdhcyBteSBhdHRlbXB0IHRvIGZpeCB0aGlz
IGJ1ZywgYnV0IHRoZW4gRGF2aWQNCj4gc3VnZ2VzdGVkIHdlIGZpeCBpdCBpbiBhIGJldHRlciB3
YXkgYnkgYmF0Y2hpbmcsIGFuZCBaaSBwb2ludGVkIG1lIHRvDQo+IHRoaXMgc2VyaWVzLg0KPiAN
Cj4gVGhhbmtzLA0KPiBKb2FubmUNCj4gDQo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
aW51eC1tbS8yMDI2MTEwMzIxMjAwNC4xMzU2MzI3LTEtam9hbm5lbGtvb25nQGdtYWlsLmNvbS8N
Cj4gWzJdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzIwMjYxMTA5MjIwOTU4LjIw
NzE2ODctMS1qb2FubmVsa29vbmdAZ21haWwuY29tLw0KDQoNCkdsYWQgdG8gaGVhciB0aGlzIHNl
cmllcyBoZWxwcyB5b3VyIHVzZSBjYXNlLg0KDQpZZXMsIEknbSB3b3JraW5nIG9uIHYzLiBJIHNs
b3dlZCBkb3duIG9uIGl0IGJlY2F1c2UgaXQgZGVwZW5kcyBvbg0KT3B0aW1pemUgYW5vbnltb3Vz
IGxhcmdlIGZvbGlvIHVubWFwcGluZyBzZXJpZXMgWzFdLCB3aGljaCBoYXNuJ3QgYmVlbg0KbWVy
Z2VkIHlldC4NCg0KSWYgaXQgaGVscHMsIEkgY2FuIHNlbmQgdjMgc29vbmVyLCBhZGRyZXNzaW5n
IHRoZSB2MiBjb21tZW50cywgcmViYXNlDQpvbiB0aGUgY3VycmVudCB0cmVlLCBhbmQgc3BsaXQg
aW50byB1bm1hcC1zaWRlIGFuZCByZXN0b3JlLXNpZGUgc2VyaWVzDQpmb3IgZWFzaWVyIHJldmll
dy4NCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzIwMjYwOTI0MTMxMTA2
LjE3MzA0OTQtMS1kZXYuamFpbkBhcm0uY29tLw0KDQpUaGFua3MsDQpTaGl2YW5rDQo=

