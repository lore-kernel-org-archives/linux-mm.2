Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 432DDC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B8C6B0098; Wed, 19 Aug 2026 06:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73586B009B; Wed, 19 Aug 2026 06:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D615B6B009D; Wed, 19 Aug 2026 06:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2486B0098
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:09:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13B52A04D1
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:09:18 +0000 (UTC)
X-FDA: 85117596396.09.7B509E6
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012013.outbound.protection.outlook.com [52.101.43.13])
	by imf27.hostedemail.com (Postfix) with ESMTP id CACF040006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:09:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3N1kE9IQ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.13 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787134155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4INb4PervscHfdHDZVP/pRJN+atf7y9DaByDG+BtDCY=;
	b=j0tvcX9ZAg7Hod7RGWXzc9A5ojMyxm8rkri5lnMiZKBsBcwqR/2ID8Y9g3J5r6perC9Isb
	oU2IgEEH8rljPIvb1aRqRfUqbtOXaIPkeV/+BeczmvQDmkIzJpUPwcdweS1isHqdhXoTJ1
	QmfuNeGiwiNKBH8sqt4ZyNu82DE+SaQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3N1kE9IQ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.13 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787134155;
	b=fETi3v6zzTGlDbSQGxirJnhCx0WZWRAaNJEOU789c3NTJVzky4P9OTYrZRubKN28YsqXDD
	swUniayfkmsgmf2fnOi6jKihK9s24rdFUfEkR1jeOOc0TTy0DRvc5UntklAAzRXJUs8a/c
	OYaTTDhKI+srwQ4NG4rtwSwrK7SJZXg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qEmJf8W2oyXBExRT/sANeG7Twb6tc/rt0FpMhuKMqtTZMnhqZ9la9bbe68Zy9ovLTtsQCHGKMKCL4PbBHfM+bzeqeLUngZIbqymOh4pWGrRxCqv5YALot07bRfzoJDntlH6Qf0hzBCC+Tru9xQM8l3NFJm4nGWigMDslxTU+mtdJ60Z11squ624PPOPdJ0U0cFdoEFk7Fpk1SBzvs0/CHySTbK+B5tFgId359SptN3uGd29NYAM8cAmxRkeYSI54hBJuoXPtUJuR5bUahjPMCeJtqPeSy6Ows7N8nC4oSLSNTwQNYRz+QHsFnctRPU70u16s86LHZnPQkEShtSiBMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4INb4PervscHfdHDZVP/pRJN+atf7y9DaByDG+BtDCY=;
 b=In0HXhKiDn/mf6pkFPenSlzRNpbEYsGUgKJSGraJj620aeLSxxx3X30MHeAa4NH+iyhT6+u6+YhDBfy1yXOkfk3DQxJ6WHxAe8Jy2lLKAT4OgEQnMw7PdJb+gKq6ZpzxLa3oK+QbS2fxE+N1A8A7IVi7+cFYQWIiOyC5RZb6YfAn1ttipkiuQyFXObCrn3Xe9K06eS/4ArX8SyyVsQzrtGcu+eVDiEuqgiEPTxmbUuXSYGwOjmP9Zgsp2/WLOoP8cpPC1/tsPi5V+qjvfL1fgvEHwjHZ44J3QE79t4/p0b/iwl2Xcl45DXkWLG/D8OrRb5bOps5yyBtK6P8wxYEZNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4INb4PervscHfdHDZVP/pRJN+atf7y9DaByDG+BtDCY=;
 b=3N1kE9IQYeKEh7X/wARWCh8O0D3RK9oMQYhXQXbxLFhDPLfBn8qg2p6SaIYTFX6vD5295Yoa5bvOEqNfbxgPJKAQYH++bDg1TdCEGCT6QZYKxruM+62nvjUcShL+waBTZdDqAXbEM8z1I2SaEYmW2rFJQr9D1GOREUqW/r6a3rI=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SAWPR12MB999115.namprd12.prod.outlook.com (2603:10b6:806:4e3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 10:09:10 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 10:09:10 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "lance.yang@linux.dev" <lance.yang@linux.dev>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>
CC: "Rao, Bharata Bhasker" <bharata@amd.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "weixugc@google.com" <weixugc@google.com>,
	"byungchul@sk.com" <byungchul@sk.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "harry@kernel.org"
	<harry@kernel.org>, "rientjes@google.com" <rientjes@google.com>,
	"riel@surriel.com" <riel@surriel.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "surenb@google.com"
	<surenb@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kinseyho@google.com" <kinseyho@google.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "gourry@gourry.net"
	<gourry@gourry.net>, "ziy@nvidia.com" <ziy@nvidia.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "jannh@google.com" <jannh@google.com>,
	"liam@infradead.org" <liam@infradead.org>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "mhocko@suse.com" <mhocko@suse.com>, "ljs@kernel.org"
	<ljs@kernel.org>, "kmanaouil.dev@gmail.com" <kmanaouil.dev@gmail.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "apopple@nvidia.com"
	<apopple@nvidia.com>, "fvdl@google.com" <fvdl@google.com>
Subject: Re: [PATCH v2 7/7] mm/rmap: batch the unmap of large folios in
 try_to_migrate_one()
Thread-Topic: [PATCH v2 7/7] mm/rmap: batch the unmap of large folios in
 try_to_migrate_one()
Thread-Index: AQHdKtuyLgj0M/UzeUepWOgV+SBRBrah+/cAgAGM2QCAAAcbAIABmIJ6gAAHaIA=
Date: Wed, 19 Aug 2026 10:09:10 +0000
Message-ID: <827e1126c02485b3d6de5f28027a75262b6c7076.camel@amd.com>
References: <860941c2-287f-f88f-920c-6d99e2cd4483@huawei.com>
	 <20260818092032.47670-1-lance.yang@linux.dev>
	 <87tsoq5tvq.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <87tsoq5tvq.fsf@DESKTOP-5N7EMDA>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|SAWPR12MB999115:EE_
x-ms-office365-filtering-correlation-id: 4ddcb674-100b-4032-0b25-08defdd9e9e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|56012099006|10067099003|22082099003|18002099003|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 NsvJAZ+jGTMmnOx9Cp/pOR+BnPILCVH16vVDv3znDkVTx5Z7lEi+Ucnk3dZRK71DbUd3oUTWTE70tA046ulgvFQKl/uKfQGhYofgb2FpM/WCAlk81dG3V+BfoxmMsFfrsNtSFPW/3JIiMpgXJicY1mcc+QY8BFZRMLk8MgO/wdBZPpgagcrhpT4EFGWlSfRZceEQbePWfl84WKm+9LrPwzKPmErFo8EymocQClSovaVc5ch8mtIZdGs/JZ945BHJkHefPCFmhvQPm4flXLbHoA4NWenKRXzP+diktnrp/Mt7TQoQUrw4vrZcP9/zoZ30hB9E4VrMb0gAk3ACWPFr7cKgg7pMY1bHjQT9dmsXwZLLYDg5VHPQUDNmXj4c59YRy2CXnyVg8e0+Dn2tepDbZ6Yy38Ofz3GveLxMbNo6KHCMu/BldtTRlLGfsIxN2c53pc5bBt7RtRBsr/YqQk9lVgrpq4S9bAnoGkcHDEFMyXH2hx72/sHUZZF2zzWB2htd4VTx7O65JR8omkWmU9K9RJKrJOMB4Z7CXlSgWAqXlpho4Cs3wwmX67gXos3sPyYkneMgr5BGoRG1efcWGF76fAktj+WKImipMqLiIiWkdCMCjHIE8Uii2mWmUjuPqaF9c1rvB9RuxqfQUYno4z8xXbMONZAGIR7At7oOL0vXwLjXKXuWPYJDW9DrfPtOUelEPBMSrF66bjkjaRPWrgmRxA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(56012099006)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M2VSbXl2WG1GbW5OQTZ5STdlVkUrVzJaMTNNeEJ5NEJ5Y3d2LzhtSjFzYjlM?=
 =?utf-8?B?M0tETWs4ZXBQQ1VSbFk1MFRoNzJoMlhiUTVyZEpnOFVIYWR5NDhNVE1yNCta?=
 =?utf-8?B?SWVDblN4VTBNWENjK1hjajlldmdnNXYxVVE4Um5iUSsxV0JXUXZTT0YwTFZa?=
 =?utf-8?B?QmU1UmZuZUxjRWRDWC9SampWV2lFdFUxZXB5bUU2Nm1xWnR4dmt1Rm1jSXRr?=
 =?utf-8?B?RWxnVG5mcHJteVRHSk55WEZZcEdNTjkzOGZlRU15SG9nOUxBLzErM2tuNDlY?=
 =?utf-8?B?cytIdEpiMUJnOXlYaGtjbDQzcUx4YWN5UHZucVhuTGVQQ3RyYjgxZVpwZ1NN?=
 =?utf-8?B?cDJETHlRN0xQMFRXMFZiTXpQZXB1cC94Y1pLaHNjazQ1S3hIZXVRS0J5b2xz?=
 =?utf-8?B?a3E4MlhSZnUxd0kxQ1dBR1hUU0VYTmhuM2srT2t6amZpRU5XTWp6NGs3bGNJ?=
 =?utf-8?B?cHVsUE9jMEJUbVcvWFJNVFAyMlpwYSswcDhyYWQ3YThHUEZuZlMvd2xDN1Fn?=
 =?utf-8?B?d2tUbnRIS2JVVzBBY2VOYWF6NG54MDNpcGVzOHBYZkxKWjhibG1oWC96clB6?=
 =?utf-8?B?RXNyd21LRkZvZHd0UTFwTTJ1UUcrRzZ0SkdEMTBrZHRocGYwbjdIYUhVR0h2?=
 =?utf-8?B?bVB3UE0rV3VBdHFoUjZpQnhNOWVPVXBXRlpkd0FyZk5rZEExektBTi8xNjdi?=
 =?utf-8?B?cHV0ZVhQeEJiRzJ3eWVrSTRTYnpKbEVOKzNieENlY0NwV3grSG04b29pR2NU?=
 =?utf-8?B?TEdRdk9Vb1ZTQU04ZVdMaituVVEzZUFaeUhSOXFCMW9PQWRuVzU4d2V3K3Zi?=
 =?utf-8?B?bVYxTE9nVy9DTGpENDBUTFJKeFVjTHkwQ0ZSUUZJVklsSE5rNUMwQTFjYVE3?=
 =?utf-8?B?WnJmVXlIeElnUzJkbWlkV0I2VVJpWmpIQUQwSTBQeDJIamJKSmtpWmd2ZFo1?=
 =?utf-8?B?K2hqc1J1cjBTbFJvUXdyRjBqSzAyUGJtUERKbjZmQ0xHSjFWRVhqVWI1eDd5?=
 =?utf-8?B?NXBXai9xaDY4TWZ0R1VIZGxpVkVFQ1VKZS9SK0FnSHVCelFmc3F6YzFQWEIz?=
 =?utf-8?B?MDhGckFUaDgzZWYzanh2c0JhbjRJdnpHbjB2NU1VYmRpQ0FyaEdGN3hlMXAw?=
 =?utf-8?B?ZFE0ZldUNXA5YmxtZTNXaDJkZEovUmhIbDZSSmx1Wkl2OXp4c1FNWldwK1cr?=
 =?utf-8?B?N0ZxU290M1hHd3VZZjlEKzFxS0YzZ1kza1VVREtxMU4za1YxRnB0MjdQdU5h?=
 =?utf-8?B?U1h1NE5UZUhXSC8zSWpyZjlhSjdJLzkyZlVPeEpWMjRzWUEwUHpwaHdkVFB5?=
 =?utf-8?B?a25sWVlEMC9nQlV5bm1ybEV6VHp0UUFVWnZQOWlqUjFUOFR2Q2hHTlNjTzEy?=
 =?utf-8?B?bkk0TE9nOEtyLzdDSkVGL0VDNWE3TlRLRENSbTg4Vit1Z0E4Ync5ckdHdThP?=
 =?utf-8?B?VnVCWitZSW5mUnBnbmt6c3pTUG15VlhSQ2NuaGl2bTlPQUoxeHc2VEg1cTl4?=
 =?utf-8?B?QVloT1BTeWVBNEU3WEQ4bmVDVWprMk96ejFsMEQ5SHdBT0w0YnFJSnhxekpa?=
 =?utf-8?B?b20xTEpocHM1SG13bERaWTBlMGRoTzBVN0x2Njl6WFhRUmszaVVuQW02VFQy?=
 =?utf-8?B?VmFDMy9RRHVZSWxGOUV4TnMzYWFvNWJwMW93WHA5SmVSNnZNSVhEazVTdEdP?=
 =?utf-8?B?eTkvM1BMRGxvV0dRcHYyUFVRZ3JXb0trTXVqYVRBb21GazFWa3VvQWZuNFJC?=
 =?utf-8?B?UVpzTzF3N0I2SjRVZjZvZE51UFF2VXI4Qy9sc2I1WXAwdW5ETEhMdHJXQTFj?=
 =?utf-8?B?aXY5MXhmVzMvQzZSZ0JOdlF1NTJHa0ZobXNoME9mL2MvNThYYjl2Z0YxdFJC?=
 =?utf-8?B?eUFsaHc1UVZ4bzNISDAvMjZGQy9rUDRhZXNEMlphall0SGFwbXc3dnNDaGRq?=
 =?utf-8?B?aXNZWGlHemZ5WFlYOWdmYlpZMDRDc0JWY2s0ajY0eTA0MncrMEhjMHNNdFhq?=
 =?utf-8?B?MU8yZGF5bXBNUmdJblpacmdHNTIxKytaNktsVFJaR2Z2dW1mNnFGbVBUbUVM?=
 =?utf-8?B?WHh2clZCK0w0M0RMK1Z0Mit3M2Y4MFVuYW5xbmhaZ0lDMFRTQVlUdExUMVNX?=
 =?utf-8?B?WFljREY5b3FHRlE3QiticVhXSnJMbGk1ZCtnU0RPVHozMFR2Q0FtN09VUUgy?=
 =?utf-8?B?TGJEQWtmaHJ4VlY4SGNBQzVJZVUwZm5EUmRkWW1qbCtXRU5xcXBkQkhiVEVD?=
 =?utf-8?B?RFFpUkNsNUZpdkh3a1VzVERTS2VSb05TeC8wTDVyZ0c4NUtwMEtFTkNrdlJD?=
 =?utf-8?B?WCtFQmp2TEdweURzZTFLUldmUVAwZDlzd2JUSitZRUsvWjBYRTNFZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72343EDE1269BF459044A719076F9C5F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddcb674-100b-4032-0b25-08defdd9e9e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2026 10:09:10.6490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VIqbQPBoUPCZ9AwK2AC+3FNJBpKKI4CeNOn/wJo5OCwQ4Qpsrgpnup6jqOQ1sW9s3i30itASWrBVGTueARJ2sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999115
X-Rspam-User: 
X-Rspamd-Queue-Id: CACF040006
X-Rspamd-Server: rspam07
X-Stat-Signature: s6jedgb8qzjjbjdte1ahte5ywxk8769o
X-HE-Tag: 1787134154-324132
X-HE-Meta: U2FsdGVkX1+cZawuyweL2uXNCMzoQ/H6FI8xlBZ8sH7C/N8g0fh9nQ3IGJeC6KsdEZXBLoZSmyINxWuLKLhinvBdkCFSvhJV8uPJ9ezU4/q+MkjkhH1Vu4S1ojTUiiK+FfjfAiW9mOCFBUKDQ3LJU5DY4PSfg7hIwqpJdi6x4PeOvejYH4qSIRon20Yi9FTnpMifEClyYsILJSV+YZoMDVuTmr46kIDQh9nLN+TErYcNIKWP0+uOAed4usnBA3mOFR6atvq3TgZYvTVTH+cJOxsKloGGc+3GdWBJbe1dU+z3Kj5dknv9PWwEkyZwZb4aYRGQbpWUJfVtOK2Q7yqQ/HYJp8BPXObrcqhcRFaRQhyKVVtyJe9fez+4gJQxz5zG7AC6MOB4sZsmex/JwYIjLXEGNBwz68KmgMc3D2vE+eWboHeFnNNCEdiZCq3KC1Aj8kET91goOtgzUEPVbbf3TA6HpGgrg/VjOH5+LAdOJPdf8tAJCtK9qbnxrXIP+vbgunUiPh+nJpju+n0zPPCKMZ+Xw4lFyhZoz5/+2vDKVGxv6VtwecEjmEjtyVBIgcLJZjR0wbtjm4cCZPe0nuY3P9rbZrHiSk8//zIrB6QqmyFg8ND3lv6I2+/hZv00bH0Y7xrLKsoYn/0JOObu9TWF/0nTghbtA7E1Aw4k7J7S2re/SVzYjem9SbmJQLbXph3mCMbHZb9QrKMbNy/jVXLk0zn+ijLZBrM+nEYfc+eBU7TxiQZVnpZwOYea3zRHamaYlxOHly6lKLX4BRP+kJ19rPIeIGUFtf/m/v1EL0esha/L1GyFZ7kQ+9OuUT4UGX/drr9TgdH7eb5lVUK6D/6lY8a4bpyxdB8UGZERulHomFbmpVgh40LRReSWu7H6HvU02BoX6gD531HTUU2W1ojEvInKj7pD7iANGU2/u8i1YqwRLDT1r3SqYNVxrY7WoHG7eMlU5suH/cmn6AJzNqt
 Rff3lNoq
 dbRiovLZIq8Q2OlAksAvWfL2ckNNmyt6PVyt8Unj+JLL44KlzS6bhlCZzMOvS6E/85mombb5Uu4rGbkR+YyWn7qN2f1X/BMGrD+qiIylRs2OXNDkSX77qkzVNY1KFOPjST62NNJ+OL7D8Hpj7FebMKmi4FyYb7J6fSdqa3TG05EQmk7ZSuFPM9SQpaPlu/BwxpqsexwH/o3swdAB5l/ItlwO6H/8zfkYEGgXwkMU0R8mc2SMoU50Vsnt0HaL3m0UkYyHHEoHnsjkFSC4TEZHqLdWuY5r6dlUrjJcgZ1GOQuPZ5v5n7X1H4k8/M3goojg5Ujv9TXJh9/OxqyXpdmGoxbqUQAgv8CjIfQCqBW+qybSmNom0gj8X/Z0jFXZTtPI6QpLMPmAaf7qNt9ksoymjU0avmu/nG1t/i39hSK+azak6UUZfc71Y5miXLgrLfTazwSHIUMJK4c2KwlnGPyuJGLzFnZzxS22XjnRoXVsRlDDcMk7Q8JhkGaiWSRHH1yhnJ5w75Bxkp+8XHel95xiuCS+nAajihZJIZNV0zVj/1F1fiIV0lGnw0OLByPd1AI1/BKkbO90ErwMLwS8sJu25Zp9DH4JRZc7TXwE+IMH6O9a4zgVOPjS8T25sLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCAyMDI2LTA4LTE5IGF0IDE3OjQyICswODAwLCBIdWFuZywgWWluZyB3cm90ZToNCj4g
TGFuY2UgWWFuZyA8bGFuY2UueWFuZ0BsaW51eC5kZXY+IHdyaXRlczoNCj4gDQo+ID4gT24gVHVl
LCBBdWcgMTgsIDIwMjYgYXQgMDQ6NTU6MDZQTSArMDgwMCwgTWlhb2hlIExpbiB3cm90ZToNCj4g
PiA+IE9uIDIwMjYvOC8xNyAxNzoxNCwgTGFuY2UgWWFuZyB3cm90ZToNCj4gPiA+ID4gK0NjIE1p
YW9oZQ0KPiA+ID4gPiANCj4gPiA+ID4gT24gVGh1LCBBdWcgMTMsIDIwMjYgYXQgMDQ6MjM6MThB
TSArMDAwMCwgU2hpdmFuayBHYXJnIHdyb3RlOg0KPiA+ID4gPiA+IHRyeV90b19taWdyYXRlX29u
ZSgpIGNvbnZlcnRzIHByZXNlbnQgUFRFcyB0byBtaWdyYXRpb24gZW50cmllcyBvbmUgYXQgYQ0K
PiA+ID4gPiA+IHRpbWUuIEZvciBhIFBURS1tYXBwZWQgbGFyZ2UgZm9saW8sIHRoaXMgcmVwZWF0
IGNhbGxzIHRvIHB0ZXAgY2xlYXIrZmx1c2gsDQo+ID4gPiA+ID4gdGhlIG1pZ3JhdGlvbiBlbnRy
eSBidWlsZCBhbmQgc2V0LCBmb2xpb19yZW1vdmVfcm1hcF9wdGUoKSBhbmQgZm9saW9fcHV0KCks
DQo+ID4gPiA+ID4gZWFjaCByZS1lbnRlcmluZyBwYWdlX3ZtYV9tYXBwZWRfd2FsaygpIG9uY2Ug
cGVyIGJhc2UgcGFnZSAoMjU2IHRpbWVzIGZvcg0KPiA+ID4gPiA+IDFNIGZvbGlvKS4NCj4gPiA+
ID4gPiANCj4gPiA+ID4gPiBNaXJyb3IgdHJ5X3RvX3VubWFwX29uZSgpIHRvIGludHJvZHVjZSBm
b2xpb19taWdyYXRlX3B0ZV9iYXRjaCgpIHRvIGRldGVjdA0KPiA+ID4gPiA+IGVsaWdpYmxlIGJh
dGNoIGZvciBQVEVzIG1hcHBpbmcgY29uc2V1Y3RpdmUgc3VicGFnZXMgb2YgYSBsYXJnZSBmb2xp
b3MsDQo+ID4gPiA+ID4gYW5kIGNvbnZlcnQgdGhlIHdob2xlIGJhdGNoIGluIG9uZSBzaG90IHVz
aW5nIHRoZSBiYXRjaGVkIGhlbHBlcnMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gQSBzaWRlLWVm
ZmVjdCBvZiB0aGlzIGNoYW5nZSBpcyB0cmFjZV9zZXRfbWlncmF0aW9uX3B0ZSgpIHdpbGwgcmVj
b3JkDQo+ID4gPiA+ID4gb25lIGV2ZW50IHBlciBiYXRjaGVkIHJ1biBpbnN0ZWFkIG9mIGVhcmxp
ZXIgYmVoYXZpb3Igb2Ygb25lIHBlciBiYXNlIHBhZ2UuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogU2hpdmFuayBHYXJnIDxzaGl2YW5rZ0BhbWQuY29tPg0KPiA+ID4gPiA+
IC0tLQ0KPiA+ID4gPiA+IG1tL3JtYXAuYyB8IDExNSArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ID4gPiA+IDEgZmlsZSBj
aGFuZ2VkLCA4NiBpbnNlcnRpb25zKCspLCAyOSBkZWxldGlvbnMoLSkNCj4gPiA+ID4gPiANCj4g
PiA+ID4gPiBkaWZmIC0tZ2l0IGEvbW0vcm1hcC5jIGIvbW0vcm1hcC5jDQo+ID4gPiA+ID4gaW5k
ZXggMzU3NTJhNzBmM2EwLi42M2I4ODVjMGI3ZWYgMTAwNjQ0DQo+ID4gPiA+ID4gLS0tIGEvbW0v
cm1hcC5jDQo+ID4gPiA+ID4gKysrIGIvbW0vcm1hcC5jDQo+ID4gPiA+ID4gQEAgLTI2NzUsNiAr
MjY3NSw0NCBAQCBzdGF0aWMgYm9vbCB0cnlfdG9fbWlncmF0ZV9odWdldGxiX29uZShzdHJ1Y3Qg
Zm9saW8gKmZvbGlvLA0KPiA+ID4gPiA+IAlyZXR1cm4gcmV0Ow0KPiA+ID4gPiA+IH0NCj4gPiA+
ID4gPiANCj4gPiA+ID4gPiArc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgZm9saW9fbWlncmF0
ZV9wdGVfYmF0Y2goc3RydWN0IGZvbGlvICpmb2xpbywNCj4gPiA+ID4gPiArCQlzdHJ1Y3QgcGFn
ZV92bWFfbWFwcGVkX3dhbGsgKnB2bXcsIHB0ZV90IHB0ZSwNCj4gPiA+ID4gPiArCQlzdHJ1Y3Qg
cGFnZSAqc3VicGFnZSwgYm9vbCBhbm9uX2V4Y2x1c2l2ZSkNCj4gPiA+ID4gPiArew0KPiA+ID4g
PiA+ICsJdW5zaWduZWQgbG9uZyBlbmRfYWRkciwgYWRkciA9IHB2bXctPmFkZHJlc3M7DQo+ID4g
PiA+ID4gKwlzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSA9IHB2bXctPnZtYTsNCj4gPiA+ID4g
PiArCXVuc2lnbmVkIGludCBtYXhfbnIsIG5yOw0KPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiArI2lm
ZGVmIF9fSEFWRV9BUkNIX1VOTUFQX09ORQ0KPiA+ID4gPiA+ICsJLyogQ2Fubm90IGJhdGNoIHVu
bWFwIGlmIGFyY2hfdW5tYXBfb25lKCkgaXMgZGVmaW5lZC4gKi8NCj4gPiA+ID4gPiArCXJldHVy
biAxOw0KPiA+ID4gPiA+ICsjZW5kaWYNCj4gPiA+ID4gPiArDQo+ID4gPiA+ID4gKwlpZiAoIWZv
bGlvX3Rlc3RfbGFyZ2UoZm9saW8pKQ0KPiA+ID4gPiA+ICsJCXJldHVybiAxOw0KPiA+ID4gPiA+
ICsJaWYgKGZvbGlvX2lzX3pvbmVfZGV2aWNlKGZvbGlvKSB8fCBmb2xpb190ZXN0X2hhc19od3Bv
aXNvbmVkKGZvbGlvKSkNCj4gPiA+ID4gPiArCQlyZXR1cm4gMTsNCj4gPiA+ID4gPiArCWlmIChw
dGVfdW51c2VkKHB0ZSkpDQo+ID4gPiA+ID4gKwkJcmV0dXJuIDE7DQo+ID4gPiA+ID4gKw0KPiA+
ID4gPiA+ICsJLyogV2UgbWF5IG9ubHkgYmF0Y2ggd2l0aGluIGEgc2luZ2xlIFZNQSBhbmQgYSBz
aW5nbGUgcGFnZSB0YWJsZS4gKi8NCj4gPiA+ID4gPiArCWVuZF9hZGRyID0gcG1kX2FkZHJfZW5k
KGFkZHIsIHZtYS0+dm1fZW5kKTsNCj4gPiA+ID4gPiArCW1heF9uciA9IChlbmRfYWRkciAtIGFk
ZHIpID4+IFBBR0VfU0hJRlQ7DQo+ID4gPiA+IA0KPiA+ID4gPiBIbW0gLi4uIGNhbiB0aGlzIHN0
aWxsIGJhdGNoIG92ZXIgYSBwb2lzb25lZCB0YWlsIHBhZ2U/DQo+ID4gPiA+IA0KPiA+ID4gPiBt
ZW1vcnlfZmFpbHVyZSgpIHNldHMgUGFnZUhXUG9pc29uKCkgYmVmb3JlIHRha2luZyBmb2xpbyBs
b2NrLCBidXQNCj4gPiA+ID4gY2Fubm90IHNldCBQR19oYXNfaHdwb2lzb25lZCB1bnRpbCBpdCBh
Y3F1aXJlcyBhbmQgcmVsZWFzZXMgdGhhdCBsb2NrLg0KPiA+ID4gPiANCj4gPiA+ID4gU28gdGFp
bCBwYWdlIGNhbiBhbHJlYWR5IGJlIHBvaXNvbmVkIHdoaWxlIGZvbGlvX3Rlc3RfaGFzX2h3cG9p
c29uZWQoKQ0KPiA+ID4gPiBzdGlsbCByZXR1cm5zIGZhbHNlIC4uLiBubz8NCj4gPiA+IA0KPiA+
ID4gV2hlbiBtZW1vcnkgZXJyb3IgaGl0cyB0aHAgcGFnZXMsIG1lbW9yeV9mYWlsdXJlKCkgZmly
c3Qgc2V0IFBHX2hhc19od3BvaXNvbmVkIGFuZA0KPiA+ID4gdGhlbiB0cmllcyB0byBzcGxpdCB0
aHAgcGFnZXMuIEFuZCB0cnlfdG9fbWlncmF0ZSgpIHdpbGwgYmUgY2FsbGVkIHRvIHNldCBtaWdy
YXRpb24NCj4gPiA+IGVudHJpZXMgZm9yIGFub24gcGFnZXMuIERvZXMgZm9saW9fbWlncmF0ZV9w
dGVfYmF0Y2goKSB3b3JrIG9uIHRoaXMgY2FzZT8gSWYgc28sIHRoZQ0KPiA+ID4gZm9saW9fdGVz
dF9oYXNfaHdwb2lzb25lZCgpIGNoZWNrIGFib3ZlIGNvdWxkIGNhdGNoIHRoZSBiYWQgcGFnZXM/
DQo+ID4gPiANCj4gPiA+IE9yIGRvIHlvdSB3b3JyeSBhYm91dCB0aGUgc2NlbmUgdGhhdCBtZW9y
eSBlcnJvciBoaXRzIGEgdGhwIHdoaWxlIGl0J3MgdW5kZXIgbWlncmF0aW9uPw0KPiA+IA0KPiA+
IFllYWgsIGxhdHRlciBjYXNlIGlzIGV4YWN0bHkgd2hhdCBJIG1lYW50Lg0KPiA+IA0KPiA+IHRy
eV90b19taWdyYXRlKCkgaXMgY2FsbGVkIHdpdGggZm9saW8gbG9jayBoZWxkLiBJZiBtaWdyYXRp
b24gYWxyZWFkeQ0KPiA+IG93bnMgdGhlIGxvY2ssIG1lbW9yeV9mYWlsdXJlKCkgY2FuIHNldCBQ
YWdlSFdQb2lzb24oKSBvbiBhIHRhaWwgcGFnZSBhbmQNCj4gPiB0aGVuIGJsb2NrIGluIGZvbGlv
X2xvY2soKSwgYmVmb3JlIHJlYWNoaW5nIGZvbGlvX3NldF9oYXNfaHdwb2lzb25lZCgpLg0KPiA+
IHRyeV90b19taWdyYXRlX29uZSgpIG1heSBtZWFud2hpbGUgc3RhcnQgZnJvbSBhIGhlYWx0aHkg
c3VicGFnZSwgc2VlDQo+ID4gUGFnZUhXUG9pc29uKHN1YnBhZ2UpIGNsZWFyIGFuZCBQR19oYXNf
aHdwb2lzb25lZCBzdGlsbCBjbGVhciwgdGhlbiBiYXRjaA0KPiA+IGFjcm9zcyBwb2lzb25lZCB0
YWlsIGFuZCBpbnN0YWxsIGEgbm9ybWFsIG1pZ3JhdGlvbiBlbnRyeSBmb3IgaXQuDQo+ID4gDQo+
ID4gT25jZSBtZW1vcnlfZmFpbHVyZSgpIHB1Ymxpc2hlcyBQR19oYXNfaHdwb2lzb25lZCwgdGhl
IGZvbGlvLWxldmVsIGNoZWNrDQo+ID4gZG9lcyBzdG9wIGJhdGNoaW5nLCBhcyB5b3Ugc2FpZC4g
SXQncyBqdXN0IHRoaXMgd2luZG93IGJlZm9yZSBwdWJsaWNhdGlvbg0KPiA+IHRoYXQgd29ycmll
cyBtZSAuLi4NCj4gDQo+IEkgYWdyZWUgd2l0aCB5b3UgdGhhdCB3ZSBzaG91bGQgY2hlY2sgUGFn
ZUhXUG9pc29uKCkgZm9yIGVhY2ggc3VicGFnZQ0KPiBiZWZvcmUgYmF0Y2hpbmcuDQo+IA0KPiBI
b3dldmVyLCBJSVVDLCB5b3VyIHN1Z2dlc3Rpb24gY2FuIG9ubHkgcmVkdWNlIHRoZSByYWNlIHdp
bmRvdyBpbnN0ZWFkDQo+IG9mIGF2b2lkaW5nIGl0IGNvbXBsZXRlbHkuIFBhZ2VIV1BvaXNvbigp
IG1heSBiZSBzZXQgZXZlbiBhZnRlciBjaGVja2luZw0KPiBpdCBhbnl3YXkuDQo+IA0KDQoNClRo
YW5rIHlvdSBMYW5jZSwgTWlhb2hlLCBZaW5nIGZvciB5b3VyIGFuYWx5c2lzLg0KSSBhZ3JlZSBv
biBpdC4NCg0KSW4gbXkgdW5kZXJzdGFuZGluZywgZm9sbG93aW5nIGhhcHBlbnM6DQoNCkV2ZW4g
YmVmb3JlICBtZW1vcnlfZmFpbHVyZSgpIHRha2VzIGZvbGlvIGxvY2ssIGl0IHRha2VzIGZvbGlv
IHJlZmVyZW5jZS4gDQoNCm1lbW9yeV9mYWlsdXJlKCkgLT4gZ2V0X2h3cG9pc29uX3BhZ2UoKSAt
PiBidW1wIHRoZSByZWZjb3VudA0KDQpOb3csDQpfX21pZ3JhdGVfZm9saW8oKSBjaGVja3MgZm9y
Og0KCWZvbGlvX3JlZl9jb3VudChzcmMpICE9IGZvbGlvX2V4cGVjdGVkX3JlZl9jb3VudChzcmMp
ICsgMQ0KDQpUaGlzIHdvdWxkIGFib3J0IHRoZSBtaWdyYXRpb24uDQoNCkV2ZW4gaWYgaXQgcGFz
cyB0aGF0IHdpbmRvdywgZm9saW9fbWNfY29weSgpIGRvZXMgbWFjaGluZS1jaGVjayBzYWZlIGNv
cHkNCmFuZCB3b3VsZCBjYXRjaCB0aGUgcG9pc29uIGFuZCByZXR1cm4gLUVIV1BPSVNPTi4NCg0K
U28sIHRoaXMgbGltaXRzIHRoZSBjb25zZXF1ZW5jZXMuDQoNCkZvciBjb3JyZWN0bmVzcywgSSds
bCBoYXZlIHBvaXNvbiBjaGVjayBmb3IgZWFjaCBzdWJwYWdlIGluDQpmb2xpb19taWdyYXRlX3B0
ZV9iYXRjaCgpLg0KDQpUaGFua3MsDQpTaGl2YW5rDQoNCg0KPiA+IA0KDQo=

