Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC83606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=FrT7Ft1L
Received: by kanga.kvack.org (Postfix)
	id BF6536B00EF; Mon,  9 Nov 2026 05:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA57A6B05B2; Mon,  9 Nov 2026 05:28:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D0B6B05B3; Mon,  9 Nov 2026 05:28:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76B876B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:28:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0744E120602
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:28:45 +0000 (UTC)
X-FDA: 85415207010.16.B3B067B
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	by imf10.hostedemail.com (Postfix) with ESMTP id CDE3DC0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:28:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FrT7Ft1L;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794220122;
	b=EBpSiXSjoGig7MRFiSumCa0s0EctCWnIfo/nKqOAUxsOYTn5pYnH+L3ZDvOi0TntETUk+y
	EFmDui/9UHA0IzNks+R8vYn9++CK5lpE5y/JXFWMlPV8fUxY8sJ6LGk92rw8dVBG37+fY8
	SorqHNy3VabeF01Ru4nVpV3cneItHcA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FrT7Ft1L;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794220122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRtHK259Uyo4BEJBmeQTnGXDYL6FkcvV+BmCbaFcibo=;
	b=DyBfEtFmtXWhIspkTQkA1z9D2LraHIzeVPykbD6xOYSr/I5VRgeVFamCg6+oB9TWXa3gYR
	ydgXQUXPbVBOUJHn/ygl2mX+4pcjP2r0jMXzFzAdEJ0CZI9xfbih/GmLz1j+7XVCPkLWzz
	nBNp9LlUT99/er3vgdRkdee0EikwneA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dnmhVrE4Q1r+Q+eCdAj1KHhk0VwuXLN0njhs2vIxqSaSHKGDXiCqY0yhUfCnnh6wJcWfS5V3KJrEa4yBN62J9dKfCEk7mN9X8w4Nvhp8GWDHb9KiUmMWMyz6T3Xuf9HdTsFKVFqD1TqftRfDzCj8G72Ta9jG5NZ81rDGUVe+H4eUlEaoTwo5tfOHuZJ3T7B1cSaWReBKXaWeN9QU2JfdCEm43bcrFBDvUpu9RR1MXvZsFriSatPfoYFBV7R1Jb2xfPPupPHj9rt7FoBJefm6J32p6AHLZUvBALZqpS9wHUSeX59w7XlWQzy/uZxQRwxrsfNWmykXyoWNTzMrQ79CRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRtHK259Uyo4BEJBmeQTnGXDYL6FkcvV+BmCbaFcibo=;
 b=DC/By1bNYzuf3efNyzvTruynBlEdzw/WQRI5FVUS1W/7r37imt//2rOvF1cZqIMjiZN0AoI7HjqP7gHARVmY18ATBs4Qz8gswhcUQer5cne5j+HSuirVXEW6qD/DtFgh1zm0AM3zASO8oX9niFR24eWg/lPibUSfB2PxJN8L+3eA5n2Ek2hR0oS1AK+nZzG9rGOXhAOHg5tEN6lIHgTxhGQxCZW2uierAGOFSr7pQv6bs/UeVBrd4mjuD1KkOCfGBO3mXYIqenAakKeKH3xQgGCtnz7mM1B1jnw/lSLDAKCDhZ2UHrjJN3QH4vxem8U5CI+bPY1YY2xGFHkHw3npFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRtHK259Uyo4BEJBmeQTnGXDYL6FkcvV+BmCbaFcibo=;
 b=FrT7Ft1Le1n93rcczQwqH2tEx82byBIk8wtn4pagmgKg5Nxkup9IsfaT3YxvG0NXikCTR9ZdoVVSxwlhVo++eFit6XOQpE0JzX8dJQlNzgAB9MSDkTi8km+LHLV8C8yegqSAttHgV5oYl4B8F4+ghuBSN/gIJhNDJFY/U5UOTDQ=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SJ2PR12MB8977.namprd12.prod.outlook.com (2603:10b6:a03:539::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:28:29 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0592.007; Mon, 9 Nov 2026
 10:28:29 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "pfalcato@suse.de" <pfalcato@suse.de>
CC: "Rao, Bharata Bhasker" <bharata@amd.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "david@kernel.org"
	<david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"surenb@google.com" <surenb@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
	"liam@infradead.org" <liam@infradead.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de"
	<bp@alien8.de>, "ljs@kernel.org" <ljs@kernel.org>, "Nayak, K Prateek"
	<KPrateek.Nayak@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Thread-Topic: [PATCH v2] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Thread-Index: AQHdcBbDv5xaImtpIEaeMVl7xxEmfrclhWcAgAAEhwA=
Date: Mon, 9 Nov 2026 10:28:28 +0000
Message-ID: <490893fe6ead90740ccd1fc1011004d03e49a27f.camel@amd.com>
References: <20261109-clear-pages-batch-v2-1-2e62c4f84f94@amd.com>
	 <avGbPpm3-Yrapry8@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <avGbPpm3-Yrapry8@pedro-suse.tail5790ac.ts.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|SJ2PR12MB8977:EE_
x-ms-office365-filtering-correlation-id: ca03f13d-111c-40ba-823d-08df3e4c321f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|38070700021|11063799006|4143699003|56012099006|261021123027099003|261026121527099003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 lQ0lLpAp+9UXKcwxw2OFGVjGZLy69ig5cCbkvX87Vu5bQXoxzwBVx3d1f1irNPrly2WF7z6B1AYii4QZK9riDDeLwviUdyZJz/sYQTk2D/lc2eDYC+Ws7wHfxouAQ2f8tRQ5Gnb0oKT9Mfahh0FkYbMAM+RLcW10h8e5YN1TOrd8cqgw0ZEHwnE3Kskde6dOrITLbgGt9951rBBDWcaS9gA9aBCwQDvO3Q+w53m1EZOQ02sPJ4jIa46jInb5ElQJK3/UhCDYqsbPkoH1ZpKM+f/sKNuDz7s2aSc5apExQVAZmaE/1cA2kapof4qEpJ5Ha5JFTxlii7gKauid71WU/gzpLLOrnl6WmViXXZnVLpbwxZv0i0M2M1L12kaCsDWEpd4g69DWGtAbvzD9cCyeTLeqfo2CfxwUpg3k98CR+/fWW+juII8zXE34Xd9/y5I7YusMuW8y6Sybda64UD/3VVVgHr4NgsY+mnZHo2GnP+ttgB56a3Wi/oSU/AAtuePQiN1Ilwtc07/1ld/HTHL5WbMpLPUUHn+BmLSE+I0HTw96vWobIinybI3tByKotSTKfYQzfPw2+sX2/KB+bkkGtwGndow5UYuZnf1gU3LzkQ8rmE6i6XXE3HoQ5QtE8HvFYw4/n3u3VHJcEQx0oo8LVObEt17qrU3aSRZd0BTdVhPrCQ/7kuzVHbrSyxM31veyzGuCWwg6psVEXgFEEbKXjw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(38070700021)(11063799006)(4143699003)(56012099006)(261021123027099003)(261026121527099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M05oaHNSS3lJUjZRQWp3R2RlVXNTWUx6aEd2TVVGMjl3c0YwMFB3TWl5OVRl?=
 =?utf-8?B?b1R3VUtSRld5U3o3Tmc2UnBqMHgzOFZpbHBVTkFjNjBJeWFndERXZFBkd1J6?=
 =?utf-8?B?UG5SY08xeFNvSFk0WjJxdlRkUFVhNjRJeFRvZ3NpZmF5b215Ky9TZ1ZvaWE3?=
 =?utf-8?B?aE15ZTVNcVBEWEszbGJwQ3NrR1JrVFhvZlhwS0djeU1Qdm00VnpUV1ljWFJp?=
 =?utf-8?B?Wkd2MCtpUzIzendOeW5uS3R0MWw1U0NCcVZZanQ5MUQ2bFMyY2FhSFJ4SDhx?=
 =?utf-8?B?MWZKT3lvcUVkTHdlTzFCUmcwM0NMMlhSSCtrZTNIL3JRNmV5YmZTZzMreG83?=
 =?utf-8?B?Smw3RlJiRStNSkFrUm5hR1l1b2xSbU05NnA4QlFDZ3ZQVGZzdHRLdlc2QWE5?=
 =?utf-8?B?bEdKWTZmaHM2S2ViMGt3ak9vMUV1dlFSNjQ5TFp3bVJ5Q3JHY0EyK3M5L0lu?=
 =?utf-8?B?bGd5MllyZmtIS0JCVlUybFk0eUE3WE41ejkrZXVsRVJKNjdHR0IreE5lSWJo?=
 =?utf-8?B?Z1Q1RDdCRktXdVVvMGFHNTFMMWl3UTJ6UUhOS25FdjM2MjRBanZ3QytJSGFi?=
 =?utf-8?B?L3FFcjBYa3pEMDVqY2x6TVN4WFdXYkpvZitLYVlzOGl3alN3Q2t1VWlnMmI2?=
 =?utf-8?B?ZVU3UmV6WjNiZzQrWmVQR1hEMUZwSGpzdkkvVGllakJUdUI5a3RHdTVtdzJq?=
 =?utf-8?B?R3NZNURqNW5EMzB3djNUc1hMcFZiTDROZldaNldnaDQxNlRoa3IyRjZQSDI4?=
 =?utf-8?B?NzhKNDFZZGZHeEhxcmZLT050TmJDWFJ5bmp0a0dXR2Y2NVdkaVU5Z21vVEZ1?=
 =?utf-8?B?b3BINExSUkQ0ZGdMOTZmRXdINEI1LzZYeTRLbXJxaENKdFNOaFdZbEJCZnh0?=
 =?utf-8?B?SVAxUVpQY0diZFBtbmFoV0IwakpVYWUxMUQyS1lNVm5XYXFHUDJQZEN0N1B2?=
 =?utf-8?B?ek1yUkxLUnRMM1BJcC9BRXhlN0xVZ0FRd2pMSDVWVlo0cjljOGcwK2NJVnZq?=
 =?utf-8?B?cklLTUZ6Sm9BeEdsa0xPQzU3UkphN3R0Q1g2bTgzM0NHNVRmZHI2OEtsL09O?=
 =?utf-8?B?TmZlbWpIQm1NcXBiOWpEb1U5OS9RYklVWjhjQmZqTVR2RDBERkRickMzVG1W?=
 =?utf-8?B?R0FMRjMraTY5TEZqNW5mMkpxSkdRSUhTZ3JZMVplUWFNcHpGREdYSGNwYmcz?=
 =?utf-8?B?alpxbndlQ283RmhIUWhicU1zVGhCQXh6VTNXRndMSGczWXA0WEExTHp6cEdS?=
 =?utf-8?B?UFIzNFNEd051alVDcEhta3Vna3RHTGJCUlZqQmhoRVhha3lKdkkwanBhM2JP?=
 =?utf-8?B?RlVsMC9waXZTN2RVZFFhRnY3eGJpMXYwVDVxa25RbDkxQ0NtOEZ6aVc3aDFJ?=
 =?utf-8?B?U0dNSGRYVnloS0hiNEtlMGovM0luelJZclloOFc1WGRaQTBoODhXUFRWUlI4?=
 =?utf-8?B?VzZCaFpiMjljTWxRYmVGRFYzM3gzTzVLV1l4NlNIblFCMzUrM3l2NVpRNVZ1?=
 =?utf-8?B?ZTBGcHFXRlJhVlpaYmdjN3oxTWxuQi9Pdm1OU2hNaGVLZDBlVXVLWDhSTi9l?=
 =?utf-8?B?Q2FoMlk5b3ExVmFLWUxJc0xLSk5FaWt5MGRMYzZQSk5TVXRxTk8xVnRiTmgr?=
 =?utf-8?B?T0VQdWltNjc4WEU4WVM3YjA3OGNacG9PSUJOa2Jub1BrdzdTWXVWNVdTQlRR?=
 =?utf-8?B?SWZJUzZMc2VCMnd4RG9EVjd0TWRTZjh0R1lBN0p3THJmaEgxdzNKMUtCdmRK?=
 =?utf-8?B?RWdqTVBnc1RxMzFLcXlEcWFXczFacmRCQkcwTHNWa0pjQXo1ZlJnWlJIQWJh?=
 =?utf-8?B?cjlCb0lpdUhNRkFwZm5xYStTQ0dZOWduNUhGZ2MzQWF0MW9oU25pa1Rsc0Y3?=
 =?utf-8?B?SFpaZHNGN2IzSkZFb1ozQUVYSmRTSlkwMlRhdm9kVnJlYXVjczY3VFlabUZ1?=
 =?utf-8?B?NEhHN0g3QVhLVmwwSngxQUNsOS9OL2c2S1lrNmNNYTFNTkhJYUpDVVo2ZTFz?=
 =?utf-8?B?bU1ieVNnMyt1U3dCWVVhaEU5RkFLTmpESGFyMDMvODBMaWdnRnpKd2dXdExX?=
 =?utf-8?B?WTRYcDFsRmtjQTRvMVY1bTdnUlJOT2xxbzlJZ2VvOVBuU3FRNTd3emFjZ2sx?=
 =?utf-8?B?TStiZVFJTC9jMFJudmRoNDRkUzFRc1RuNmZGYXc2M2drQTc2ajJwSVp4alFW?=
 =?utf-8?B?cFU0cC84dFo0eHQ3NWVaNVR2QzVERC9TSVNIamtaL0d2WWVVZC9ndDNaYW4r?=
 =?utf-8?B?YkRIQWpHaHlYRlZtMGg4MnAwWkJiZUNQb2lUMGtQN2NBakQ3aVJMNitnV3JP?=
 =?utf-8?B?WXo3S0VTNDlGbHM3RG5qVmtsOUxIbUFkK0MrRzdDNGlwSm8xcUZWZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <884BCCD7B6D92E4082485A5A41187088@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca03f13d-111c-40ba-823d-08df3e4c321f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2026 10:28:28.8880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykG7UsOTEQ5O7Gojnbbt7p5nlHEpjHfpWNaiIWjByyL76f11s6/HnIRpe5vmD0J2xnYJq/Tbt9vm6BawhGJ81A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8977
X-Stat-Signature: tohoabz7qaemkt7qbwjrzrjchphwnsdi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDE3DC0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794220121-297466
X-HE-Meta: U2FsdGVkX18Gk0z8BXZ8Fm6m40+c/2DwLm7VTDcdXCFJNX3HBhRUeZwb5dmwHbJ0IB1X0wRhqptxcHqCrRE22ngauFDIEE0ptgwVcnlMA+47sincPvUP6CBo2OWcBqGgBtM2hgeVPVMoKvVfxOPtP0O2hnIw/ofz65fN6gj/7qDD2ApMZ2dyUMo4wwVOB4ftJfA0KCBNUYKcJ/zHsCHzBrH3N72r5VbZUUZGCCwGE+RcBE/ewPkw9RmwkmoBQhkx17uB7VLVy1ju8k+15bwyBAsHQ4RrgK0WopVGOvGaU0mhf1hJFxq9PA7MChUaE94GFDP8/LdovjYpwrgKx7yhKfY7GWMF9UF/nM6mJtb4C44YeZywZ20kYd17gvkcoMaUcKUWw23N1POpSptbu6zywujAuHSXP7HeGhoCRSilWTqc7bLqnDguInanEojAtMdcMAQIp8xNaR7+t8f0HOh3wzxquIrvZduRKq8lDY8TcHtq9J5dTHazXLKn1Uxc516LBkpsCSHmcGCQuLTipKt9Ja35ruUZ5kVdNxWblDY9rxSrohvNix3BYqk5DdVZ7ITBrmvhX7BEO/HaK3kkuHIy1c61cg87lLd+g9OAp2WtTREMf39eqU4g4TV9fCwbK+JSm5znLxP9Od4QnVgp7suxqZmM4mOf4iCTfPn071OXLcawmmbHiu5olK/ujmF3/fVpM9yznOukp3hh1dbk2mBg+dcZcHYxnLI0ggSWJGFKQEpe2BnroueWcVhX3WVOIhAXmus//nqimAatAFFWBPX54CnRMuN7V+S4HZOHgGnCks2SLVdFbqMixU282UIlpiSsItskyYVfaozFb1HwGoGpFOQgrosRPLmkyXs7K98r9XuqEGgj0T8LXWuojMX02SxCwghfEEsV1Ed/7/5x/4daWNxvOljQ6/wLv7OPzwoxy+8U+fagis5enNLKWYM/92n910Z+GEGHvmZX9T0lhkh
 2Wns/dC7
 T8aV2i0fM5bqNgQCsIKgnuGM0eobRvhr+eoKr3V50R+YgdMZQKNnZcBijpCD4WawCw9e405W59IsOA2+J+uK49Zhr59+3BgZ5SrdLPN/5OXdibPtVwZINE/mTSRSFvPEEZK0zv+xW8JoT+7lh+StPhuq/YmhgFjfkVBFPM+M2sLNjxOW7ic/g+9A4X6FqN0o1i22uNQKjFQAT3nQ5ZBgtjdVcwoLolpXL+ltOZj+JJHQb3QhlQBXzY/ctDYuLTZz8vONCzdd+k1Aa15yvkVxlkITcyEaX8eKkl7S5WAfRmMadENjKniR0H+3kmdzK1/YOrD2v8ihQ8shU4qT4062IIpus+floE/CBZMyLYrSpFkLA33ABVtkNIZO9vLIZH0aqmP7zkHWhD9rUPi99lVJmwMSDMVUlbZ87aQiV/6EhtJqI+Fpwfr9d5fZ1sSleOGV1hCUxpnPVlMkhGH7MeXVmxpChp8g2a9im8xI2jDDa4sKuDmHKuEapF336dpk6jxn9nW5o3bt7dPR3ccFEVL+IJ6zMCR+ZbSIqwVkIQADJOT7aFSuyqFXrYhVa6t6MK0DNi49diW19jC4DgBDjo/wnlko8cdy8KeDPNHhXGSBWoBjgG3MCETsA9MB7knbEwkoRnRhnKvYIoPZzv5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTA5IGF0IDEwOjEyICswMDAwLCBQZWRybyBGYWxjYXRvIHdyb3RlOg0K
PiA+IA0KPiA+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiA+IA0KPiA+IFN1Z2dl
c3RlZC1ieTogRGF2aWQgSGlsZGVuYnJhbmQgPGRhdmlkQGtlcm5lbC5vcmc+DQo+ID4gU2lnbmVk
LW9mZi1ieTogU2hpdmFuayBHYXJnIDxzaGl2YW5rZ0BhbWQuY29tPg0KPiANCj4gUmV2aWV3ZWQt
Ynk6IFBlZHJvIEZhbGNhdG8gPHBmYWxjYXRvQHN1c2UuZGU+DQo+IA0KPiB3aXRoIGEgcXVlc3Rp
b24gYmVsb3cuDQo+IA0KPiA+IC0tLQ0KPiA+IFRoaXMgY2FtZSB1cCBpbiByZXZpZXcgb2YgdGhl
IGNvcHlfbWNfaGlnaHBhZ2VzKCkgc2VyaWVzIFsxXS4gUGVkcm8NCj4gPiBwb2ludGVkIG91dCB0
aGF0IG1vc3QgYXJjaGl0ZWN0dXJlIHJ1biB3aXRoIGZ1bGwgb3IgbGF6eSBwcmVlbXB0LCBzbyBt
bQ0KPiA+IGRvZXMgbm90IG5lZWQgdG8gY2hlY2sgdGhlIHByZWVtcHRpb24gbW9kZWwgYXQgcnVu
dGltZSBvciBiYXRjaCB0aGUgY29weQ0KPiA+IA0KDQoNCj4gPiAtDQo+ID4gLSAgICAgbWlnaHRf
c2xlZXAoKTsNCj4gPiArICAgICBpZiAoSVNfRU5BQkxFRChDT05GSUdfUFJFRU1QVElPTikpIHsN
Cj4gPiArICAgICAgICAgICAgIGNsZWFyX3VzZXJfaGlnaHBhZ2VzKHBhZ2UsIGFkZHIsIG5yX3Bh
Z2VzKTsNCj4gPiArICAgICAgICAgICAgIHJldHVybjsNCj4gPiArICAgICB9DQo+ID4gDQo+ID4g
LSAgICAgZm9yIChpID0gMDsgaSA8IG5yX3BhZ2VzOyBpICs9IGNvdW50KSB7DQo+ID4gKyAgICAg
Zm9yIChpID0gMDsgaSA8IG5yX3BhZ2VzOyBpKyspIHsNCj4gPiAgICAgICAgICAgICAgIGNvbmRf
cmVzY2hlZCgpOw0KPiA+IC0NCj4gPiAtICAgICAgICAgICAgIGNvdW50ID0gbWluKHVuaXQsIG5y
X3BhZ2VzIC0gaSk7DQo+ID4gLSAgICAgICAgICAgICBjbGVhcl91c2VyX2hpZ2hwYWdlcyhwYWdl
ICsgaSwgYWRkciArIGkgKiBQQUdFX1NJWkUsIGNvdW50KTsNCj4gPiArICAgICAgICAgICAgIGNs
ZWFyX3VzZXJfaGlnaHBhZ2VzKHBhZ2UgKyBpLCBhZGRyICsgaSAqIFBBR0VfU0laRSwgMSk7DQo+
IA0KPiBJIHRoaW5rIHdlIGNhbiB1c2UgY2xlYXJfdXNlcl9oaWdocGFnZSgpIGhlcmUuIEkgZG9u
J3Qga25vdyBpZiB0aGF0J3MNCj4gbmVjZXNzYXJpbHkgZGVzaXJhYmxlLCBidXQgaXQgd291bGQg
bWFrZSB0aGlzIGEgbGl0dGxlIHNpbXBsZXIuDQo+IA0KDQpTdXJlLCB0aGlzIG1ha2VzIHNlbnNl
LiBXaWxsIGRvIHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MsDQpTaGl2YW5rDQo=

