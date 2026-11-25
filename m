Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0501606A332
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=s+Yqqy8p
Received: by kanga.kvack.org (Postfix)
	id EB0F16B0A6B; Wed, 25 Nov 2026 11:12:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B0C6B0A6D; Wed, 25 Nov 2026 11:12:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB5D6B0A6E; Wed, 25 Nov 2026 11:12:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A38286B0A6B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:12:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D4701C4A95
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:12:34 +0000 (UTC)
X-FDA: 85474134228.19.0401D53
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id C2289140002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:12:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=s+Yqqy8p;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.66 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795623151;
	b=L3tN+sYsejh7hMFIz3A37q7r1Qx34cstw5TL+JX3SalX4U6S/5A301u33fJFeHLmj0A1ba
	CFtM+wcTsxng7YIbMspUmYziDzjkDY2w2zBUePQZNYdGSit5AWVg3FkDfr6EKuWp06Xcs/
	uldu9mbln/jK1+4X9Raxbn6yMRl+95g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795623151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUPZr3lJEpurGCSkGWIEufzy8zm+PT5Nzerewm7EPO4=;
	b=GvFPYlTgaUvxY7cLYlM36pswq1fE9QuGARqWBuMOvW6FBZKUASq2IZZzSUDHA4N8Ebt0tT
	VWl+JsmFQirTsHqwRiOUOnyKXZ11pZBu2s5l1diE6nPM8AtGbh5KthZBiu2cVW744Myhyp
	u571KKvDwKV/dS0i0XdtanjX6nIIkR8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=s+Yqqy8p;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.66 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vO5davv+rE1lODQ7haJxGENHBomb3zv3ToNxPHhxV/XBY4paAyvZEPUCwhm8bnYod3n9MgD9dPSwBKzJY7RKHLNfCbpj0UlrpyLpjja3GY5VJ9w4bUaakwPrRNdSV7pI0S9d4rCK1qVVuRbzh8JtbORwcrBxSFK7Z+6BbR/UUNr/TQE/1glk8XPFiBy/jEiRLQSKxQ14NzQPksw6PBZOuru0k23k+dCYMdQcXxLWF/1LLup3I15evbRPLxArN2tJqbCjKw2VobpBBMkg3zFvYgBhE2hFXYO8uIGpfa6QuYTil19X3ei1oRCRsi9A9bzI6qX4WVPypKUYnBPv9VNuWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUPZr3lJEpurGCSkGWIEufzy8zm+PT5Nzerewm7EPO4=;
 b=Fp4JE7kZvB1dxw0l7ab1osxANviFBTgkKrvg5SYuuRAxIwugrFEY0q3nPTLGSrk2nyC3gl4pHmq0W8L5IUKhCUJjjwz1elnb3pwMWY4kd15ZdLDTg7nMQ//jKbTy9tsJm5SXtFhOu6g4xM2IAuw4wWv/jk9FMcjzYtVRL3q+oxq3Ts2O8yOkGizgS48Cuor6Ncbhxxgdknxhh8P6ZE23TZ00KniRSRJw897T6PJAJXR95VEE9PcPQdZ2SiN1i4AW6O/+5Ww5dcst1foc4OGW10ByjU5qtpi4fxxwt465czfRKT/CjaXK0XfMs5IS6k5Pu7lP85Dt0iY9pfW2wIn82w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUPZr3lJEpurGCSkGWIEufzy8zm+PT5Nzerewm7EPO4=;
 b=s+Yqqy8p8vbwh/9DPyKl1vfA+loMETKkAnoLoIk7Ckwim4+mvVYiLix3yp01D7Kp5/jv3AO7dFUp5T0tBr96idM6Hslk1Ui8yAjN2zA7779KFPMoFYc+1vcQMx30Y8VldtGCwAs+z7dbN0f5Od+duxvkOZBMuLoD9HuCO5q7LWg=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by PH7PR12MB8795.namprd12.prod.outlook.com (2603:10b6:510:275::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 16:11:51 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 16:11:51 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "usama.anjum@arm.com" <usama.anjum@arm.com>, "nico.pache@linux.dev"
	<nico.pache@linux.dev>, "rppt@kernel.org" <rppt@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "yintirui@gmail.com" <yintirui@gmail.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "emmir@google.com"
	<emmir@google.com>, "danjwade95@gmail.com" <danjwade95@gmail.com>,
	"david@kernel.org" <david@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"pgofman@codeweavers.com" <pgofman@codeweavers.com>, "surenb@google.com"
	<surenb@google.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"usama.arif@linux.dev" <usama.arif@linux.dev>, "kas@kernel.org"
	<kas@kernel.org>, "ziy@nvidia.com" <ziy@nvidia.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "baohua@kernel.org" <baohua@kernel.org>,
	"liam@infradead.org" <liam@infradead.org>, "mhocko@suse.com"
	<mhocko@suse.com>, "ljs@kernel.org" <ljs@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "wine-devel@winehq.org"
	<wine-devel@winehq.org>, "avagin@gmail.com" <avagin@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: fix soft-dirty false positives in mprotect() of
 large folios
Thread-Topic: [PATCH 0/3] mm: fix soft-dirty false positives in mprotect() of
 large folios
Thread-Index: AQHdfOGHEUgq95w8VUOHW+Vokl59fLc+zCWAgAAhPgCAAAgzgA==
Date: Wed, 25 Nov 2026 16:11:51 +0000
Message-ID: <8b1a6f9da685a0e0ef44c67e92e98e37f37bd42f.camel@amd.com>
References: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
	 <380e029a-2d9a-43ee-9048-c4b490c11f41@kernel.org>
	 <0308f0ef-9989-4a9b-aaa4-2a3169ac1f02@codeweavers.com>
In-Reply-To: <0308f0ef-9989-4a9b-aaa4-2a3169ac1f02@codeweavers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|PH7PR12MB8795:EE_
x-ms-office365-filtering-correlation-id: 5f452acd-0294-4e3f-7b15-08df4b0ed101
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|23010399003|921020|38070700021|10067099003|11063799006|56012099006|4143699003|261026121527099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 Nckaq0Qd0ultOiOI8z/A4e+j38EMNqEtDwt64s8N8DGRfzDyyCQBoty0L6V6A/Vm+KOGyAn55p9vhtjitb2Vm9lOUBw8EvqHnWPXwftsLjCTP3JlChZLZSxBqk1BW01VuQqJS/C1JsQc3oRfR3v0yNbrUPJ3ArSWHC0QFCP48uIZfVn4F2AHJ51pM2cb9TBSMrk0o6SLjuu8CX3ouhqSrvtbNdNVka+2lk5NP3WkWqrmFkV0m0hs9/jsBGMZXDPAZzuyweeZnvXPSnzIHUChHdMYk25Dz8coUoXr8JjgEAJDUsHTi2Ae/teB6zs7HsvIP6xEQaolFTGgONDr6ohbDpy2y+YNGK61nmXHEXj5cGbM0VLSjlGmvyY62C7DqPoLx82RBSAr42ZdyDPkAAJ6UBM+/VvqsLvdshOqxegHD2v3RY/yXIyOIXfbdtByAVVOHcY30UxQKe14ijO9fopI3xWvGBRRuNZIL/9An0p6trSX+BbEhsZ7pGZOy6AXzMXEjwwKPcuXMa0+tqNpz8fgXOXVzLt8RndEjtGaINa9lXwA3BeNASbConC7raGMjNYWpsQB/vcDw1v4thMnJLtkA+iLJknUFJkfw2g8MGL2Hxx0GqUea9QA0AQn03SiRPMbc5XIxkc+9jXuYuVZqJhvUfTJ9oDSQGepvSkoj9KrhHh3y790U/Yh1Vyiax3FFw3SX9GRyABWzEVBfh+kYuvUQDWzb3Zvo9X2MEuSuTCBLqQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(23010399003)(921020)(38070700021)(10067099003)(11063799006)(56012099006)(4143699003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dXdMYVNod1V5aElRZUUzTEdxdEJaenFuQmlyRStzNkZwa0YvbVNmRVFpSG1z?=
 =?utf-8?B?R1BidkVzRmJONy9MSDdXaUdiOG1HL1ZyRE9hUWs1NXhnQ3pIWE9ZWXI0ZlIy?=
 =?utf-8?B?cGgvU2lkTWlaVGk3NEsrUUNHbnRQTHE5ZXA3Ti80ay8vK21QWVVZQ0t6TTR4?=
 =?utf-8?B?R1I1WlZMdmJqYXBPalhlYkxyd2xhb0Q4UWw5QWlWUmJPUjVnMVJaS045citG?=
 =?utf-8?B?SHlETCszS2NPRklQa2JsbmpLVWZYRWlneHJxSFdqdGZvUFhKMkF1eU1XY3l1?=
 =?utf-8?B?dU5NdVR0ZWNkc2pvRjQ3dEg3dDRBckthWFZKNVNKM3Z4WGlEdy9pNFFBUEQz?=
 =?utf-8?B?TmhZUjg0Uk9PWFl3Q2RSYkZuQjJ4UURzbGl0clFIeXR4cjJiN0xMNVpFL2ti?=
 =?utf-8?B?WHFVRTFGS0RKVElxVU1vZjdVdkJ5eS9lVWdDSUVsOE1DNWcvaTF0VmQ1TkZZ?=
 =?utf-8?B?MVhZVnhuMXhwT0NYOW1qQjlpTW9UWW1HeFpPMEhDNW4rL3hrRm1wWURwbDlt?=
 =?utf-8?B?TlY3VGYyaCswb1FtSmJIbVluVFMrVk96RUxiUDEvbTVGMDF6MVRCNGt6cUVz?=
 =?utf-8?B?cHZUcVlmT2ovY2U2K2RXRitHQ3BJRGhlT1BlS2p5ejI4SXMxbEV5UWZERlRL?=
 =?utf-8?B?dmJVbHMzb2o0bGQ1OTJTZ0dwNi9UQjNhYy9YdkxGa3hrYW8xTlpLUWN5YUFk?=
 =?utf-8?B?Z08vOVBxOFNXUGtPYUtYTk1uMDR1R0xXM0RKV2hKY3hoVU1sNGowZFFncjRi?=
 =?utf-8?B?Vm9tNmVqbGlSQTdOVzJEMkp1a1ZDamRNblQyL3FOM0VPb2FNb0xHUmhWWVdE?=
 =?utf-8?B?WkFhUEJRUGI1cEp4MzQ5dmhNVklJajVmUWNPR21jTXlvbFIyVWNmd0FyQVM0?=
 =?utf-8?B?YzNwZDFSaHpQeFc0Z0tacmR1bm1EM2NmQTdMR1h1QWxNWHBWSktzejhtazJM?=
 =?utf-8?B?cW1FSlNRY2Y2V1RXenFaYVFBUHZERXAvOUFBOG00OWFSdjhvWTJFdWtlM25T?=
 =?utf-8?B?UmxqVTAzVFIzK1JqMzZkREl4cDdvKy90dWVCcFdBbTFCSHhYQUNLVGE0eGhC?=
 =?utf-8?B?SmNvSGptdHNmcWRJdzBuYno2S1lKMURzWFNqdjhWSzdjMU5ZYUVKSjZieDlw?=
 =?utf-8?B?ZnVyV0d3Nk1LYlFNQ1VRSlY2WWljWGFCMHZCZnZEVWY1cm90dW42TnVRdEZV?=
 =?utf-8?B?RlNleS9ZVGFucklMQkp1bkxVVlpJb1VwQXJUajBoSHE4VWRYVHdMMlV6Rkh5?=
 =?utf-8?B?Ui9vblIxa0hsenowQmNPS1Zod2E4MnhrODk4cmhmc2V5NEVjVXJBaEYzdERh?=
 =?utf-8?B?citPaitCQ1h6WjRWNHBvekprelR2TzBzU3cyL3RrK0IwVXRiN0xsekU4bUly?=
 =?utf-8?B?aHc3OGkwcGZTR29lV2xNNmp2OXNXZHZ6RUxKbFQ2OUN4OFJwc1lMb2hrREdI?=
 =?utf-8?B?ZW1JOHp4dEpZcWxKb1hXc090WWhvejZzamlkMlkwNno5SWF6M3lWM29pWExh?=
 =?utf-8?B?eDJzbXRlVGVUMFdMQ0ZGN1hWaVE3MDJZclo2Wk55N1FLdGlzREsxUU5JZ2xM?=
 =?utf-8?B?czNIQkpMdjMyTlhSRjRIaTJ5SWRnK211N0pVaU5wRW1zSTNxNTNvZ05hTXhR?=
 =?utf-8?B?dzdwMDFndHN3eG9GVGQwL1NyT2lzNDZXVTFkaU1tMm56S1REZlBlYUwyWkNY?=
 =?utf-8?B?RmNIcGhCbEZibzNGK1Ewem9OTmxwN1lxSUJDS1ZIaVBqc1Jub3pXYUVnK2x3?=
 =?utf-8?B?bXVJK2hBQXgzc3diM1d6Q2pwdHoyLytBNDJTMmRIbnpUWHgvUzNpcWVkS3Q3?=
 =?utf-8?B?cENXL21lWU54Um5mSjdYZStZd2Y0eFI5aXN0Rzh1SFJmM3RHbUtuczBVTFNK?=
 =?utf-8?B?T1c0WlhCVXRaQ0NpczhxV2p3TmhZSm9TQlJvR2laY2FORlo4d1Y5ekc0MzRi?=
 =?utf-8?B?N1FMOEtzVnorVi8rSUpiQVdGL2dOZG4yRVp2a3B5TUJJTFNSaWpQS2FoaEQw?=
 =?utf-8?B?bjRJczBzTlM5bk5XSC9jeFFnUWxoWUkxYVUrVC82ek04cUY2VzA4cVZ4T3hn?=
 =?utf-8?B?QkRZUmlBOUUvMTNHVlNwcm5YMXB0TGtpY1FSV1gzOHhjVFdxblJRaFN3MXJw?=
 =?utf-8?B?d1dPMCtpUElCWkNKMzZHVlFWYUk4SHRuampvZFBneVh3SiszWGNmZ1g5UitF?=
 =?utf-8?B?ZFFsRmM4anFXWFBOV25nWDFrSlNMRnN0bnh6Ym1OOGFpZEw5THp1cGNGQ3Jr?=
 =?utf-8?B?NEJnVlpRT1JZUTZYWjhqR1ZGeE9MRFBJQll3ZnozUjZnOE5lQml4cG1JMHVu?=
 =?utf-8?B?RXQwalR5YnhuRWordU81OHN2bUk4SzBqanNQV0dSdlZ0RjQxek16UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F232C3D1F7A7D4B9D720FF7F9672010@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f452acd-0294-4e3f-7b15-08df4b0ed101
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2026 16:11:51.7465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZXkcK7CtjjHUJzUS8lDOPv3HccDzwfkr+r7kDuDuQpmgBvq+0bYcjEanM2Qca2tAAibpJSq3OO+0NOr8N0966Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8795
X-Stat-Signature: mte1xdnz6znimc5sseibfgm9xpdgdsxg
X-Rspamd-Queue-Id: C2289140002
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795623150-935573
X-HE-Meta: U2FsdGVkX1+afVk3VdUDvXFe5G5xwqBXE2mJ24mQVgum5IhIVBtQf8sM1HP8BuahrBMJIEmtwy8TE/Ny/cjWyyfDrSxhiddZBc6aZxS2x+GxCCrxlJ93c4QZnfQUutHflwsLEw+fBJ0RfAJSNOlQtMCqI/30fxeFgrwmkTuseoPaGGScNu8Uwy7P3gfmSy9AQbMND5eUC+MEir95NwoymnzwrIn7LkAOMl19Rxc4ELBiFw+ot23oOMrNeptOc/B8yxixIZmfaTw8Oxr5th0LVrUWmknGw7PWLlpY+GGoV85Qztrdd3ukFxfhOrUnrtvCxMytGzYiO52n/QjYPxRrxR/2XLOvsmL5+SLRm2l1fdJlEdhWs4f/fqgONGT+Vh8zAQx5gqolrlco/p4UohpU2E77iOpkx9dogx7k2cAf89iBM9M1l05+cyV9PJTObReIriIob1XdM73/MwpOVXtbHDlGpC9XDAbQMXINpvW3nPRONyNo2CUQr9V0CLd2M/coRApMz9ZKu4X85FO4XraEWZRdUc8vUFUa+rvVtkuv5LHj62Tv4ord/nLHY/w9NrRsIfUbmq3u7qsxWAT4qqWzLr8Eo6rG/lhSxKSAQDmeoiRSVTxcf9bfefnDYcJJbP8sSsnfnMw+jNWHqb7pS7JRrtxtRVCZnl4t6OeUt6p7hvJ7rebGgPfHYLkeaz7CK93VwgNynn7t0nnmLIXjhDEF8Bu8affd5UB+a/8xgJrbCYSPlxLGY9x+rnSQCFReWOj9IoC/bgv1RaWazep07T9jX1O1GzT+YjG1DT3TaJJb623QKWCbOyHtGsJw4PWYQpmaFS6J2o0Gb4XRa9YkD2VqRE99k6pVAJDfKQIOIRaYpqUnQaR2EJ1sqJFq2AStK4WbwlVZ3MSHBRmRBpEcxYgsDgacB8WQPIfoNEIISjbO3IkWeElfulTvZmnnC2ign3K/Eufwj172nFWtAfk2g5j
 ELU6F9wL
 MnmECyeuULOOvPnJ5m1gDKyQter2kHNoGQBFKFAf0cgnWwcZkwQ+Kp7KVrAEpFVITmCtHtZILKjCJt3wVfYsuxRwACWDMufNgkxS+gSTvTznO79zE58QSym306fBnz+N6NGBNVr5vx8eflq8pYD/6FXA0flp3ihxF9QKooS8sbz2KkntOACyReQKgvyYF7y6Ry9cbFiXHD+j4wtJQaPflFKrTVq4di1H+mvXDOcR0ITnLrHKeZLh2b9ABoS4b/WZtfJP2pIB7zZ8Mx6fWNjvDi5pgApAfTxTBTFXO67xWJXF89oC3Zbw2asWDNrOmkqx/vWfn8uhuMqUHVTlHIgxgsSpiLUvQ3Rl+kJUxJH3iYFYqmg6nBef9g3Gi7Bf1ZdMz1Hx3UzQqVriHF6jIogENL0wurHngO8oNNSebDQk9FKomqcKrcZsQrxEwi6acrmfq07W2S0pJiBH1LMILO/uMWTMmqYNt4+dvpWdDJH5Jxr21w5ASYf+yz7PAm8D2qIvS4MXH3x23RRzYU5vTpXHg+d2T1e0jB5E3N7bMhH4kbDX8jgZyPWjHV0jN9RmB0Yv6RCe66j5hN88O47pAFzp91ursGhgFCe93N/Dy8sJT/bWOEItE6ci3teFp00q6u2Vo9PMCnkU2jofj4UcmDznyXinwbVjc/F4uYHdw2noUhpiJjtUDWzMQ4OquDr+PyVR2YAG3zeY26ef4ci1W8w4iitfkDDwQ1nm4BLfT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gV2VkLCAyMDI2LTExLTI1IGF0IDA5OjQyIC0wNjAwLCBQYXVsIEdvZm1hbiB3cm90ZToNCj4g
T24gMTEvMjUvMjYgMDc6NDMsIERhdmlkIEhpbGRlbmJyYW5kIChBcm0pIHdyb3RlOg0KPiA+IE9u
IDExLzI1LzI2IDE0OjMyLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+ID4gPiBtcHJvdGVjdCgpIGhh
bmRsZXMgdGhlIFBURXMgb2YgYSBsYXJnZSBmb2xpbyBhcyBvbmUgYmF0Y2gsIGFuZCBtYXJrcyB0
aGUNCj4gPiA+IHdob2xlIGJhdGNoIGRpcnR5IHdpdGggcHRlX21rZGlydHkoKSBpZiBhbnkgb2Yg
aXRzIFBURXMgaXMgZGlydHkuICBPbg0KPiA+ID4geDg2LCBwb3dlcnBjLCByaXNjdiBhbmQgczM5
MCwgcHRlX21rZGlydHkoKSBhbHNvIHNldHMgdGhlIHNvZnQtZGlydHkNCj4gPiA+IGJpdCwgc28g
YWZ0ZXIgY2xlYXJfcmVmcywgbXByb3RlY3QoKSBtYXJrcyB1bndyaXR0ZW4gcGFnZXMgc29mdC1k
aXJ0eS4NCj4gPiA+IFdpdGggNjRLIG1USFAgb24geDg2LTY0LCBhbGwgMjQwIHVud3JpdHRlbiBw
YWdlcyBvZiBhIDFNaUIgcmVnaW9uIGFyZQ0KPiA+ID4gcmVwb3J0ZWQgc29mdC1kaXJ0eTsgd2l0
aCBteSBmaXgsIG5vbmUgYXJlLg0KPiA+IFdoeSBkbyB3ZSBjYXJlPyBKdXN0IG92ZXItaW5kaWNh
dGUgc29mdC1kaXJ0eS4gSXQncyB2YWxpZCwgYW5kIHRoZSB3aG9sZSBmZWF0dXJlDQo+ID4gaXMg
ZnVsbCBvZiBob2xlcyBhbmQgYnVnZ3kgYXMgaGVsbC4NCj4gPiANCj4gRG8gSSB1bmRlcnN0YW5k
IGNvcnJlY3RseSB0aGF0IHRoZXNlIGlzc3VlcyBvbmx5IGFmZmVjdCB0aGUgb2xkIHNvZnQgDQo+
IGRpcnR5IGZlYXR1cmUgYW5kIG5vdCBVRkZEIFdQIGFzeW5jIChVRkZEX0ZFQVRVUkVfV1BfQVNZ
TkMpPyANCj4gT3Zlci1pbmRpY2F0aW5nIHdyaXR0ZW4gcGFnZXMgd2l0aCB0aGUgbmV3ZXIgVUZG
RCBzdXBwb3J0IGlzIG5vdCANCj4gZXhwZWN0ZWQgYW5kIFdpbmUgdXNhZ2Ugb2YgdGhlIGZlYXR1
cmUgcmVxdWlyZXMgdGhhdC4gQnV0IEkgZ3Vlc3MgaXQgaXMgDQo+IG5vdCB3aGF0IGlzIGNvbmNl
cm5lZCBoZXJlPw0KDQpZZXMsIHJpZ2h0LiBUaGlzIG9ubHkgYWZmZWN0IHRoZSBzb2Z0LWRpcnR5
IGJpdCwgYW5kIG5vdCB1ZmZkLXdwIGZlYXR1cmUuDQo=

