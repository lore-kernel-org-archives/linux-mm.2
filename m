Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C51A606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=QvUDwfpE
Received: by kanga.kvack.org (Postfix)
	id 992E26B066C; Thu, 19 Nov 2026 00:24:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963C56B066D; Thu, 19 Nov 2026 00:24:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851E86B066E; Thu, 19 Nov 2026 00:24:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 560B56B066C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:24:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E68141C4331
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:24:00 +0000 (UTC)
X-FDA: 85450727040.12.C17494B
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010071.outbound.protection.outlook.com [52.101.201.71])
	by imf17.hostedemail.com (Postfix) with ESMTP id C13CA40006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:23:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=QvUDwfpE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.71 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795065838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lpVDviGQCevWPEAKBDvDeIXQ7kd03+3V0tNe4zGXVvU=;
	b=Ks3hHKfaQDC3WtWIXB6SJLhXMgjAvrhfQchwyC29Xx2PQYUtVVHK8/aS3RP0nDzpTN9clT
	tBuxv65eKljC3s/HLbC7MMEqqQRUVMsWNEzAhDya8z91F8ZlyOx6oEAGUIZB1Jk9rUPSlJ
	7G9uXbi/k2hjWPM2B5mabuUbAaUftsM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=QvUDwfpE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.71 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795065838;
	b=PYXCiTb9fMX9WX5NGgCfuMP9MKNqJccTD6CdA7BK3JImCYJUPSr1cdUszdG9Q2j+UQlUoq
	DD7g2dKiKj+zRHKZAqpjzX2wg2WIQ69JvLwTo02mf1LC8qEfd09btnK83SaRps3r1ojVSk
	xb81plWqPimRF9NgLMKwkuJBORI4GM0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VQ0o8huimvvrbjJGY4R+JPXfitdbt/90nOZY+VIPwO1bwxeyVh3/IsJ5EWYdEweiiOk9c4ZAtI23YFx/XBrjY5YPJER7ZHVGZD5OXZoDfpkRuwlYQYm5In6qlqZUiOmkc/OxxQ6G9ZNDPOnqpl7Jq4jqfHCRXAh81xSPRV6+N75xhmrqP9j4bocAgznbskH35/qIxglXEQPfmAwTaBdl57+cOigoyCYdedPbRh32ASpORNEjOQZmdF3d84akSn5N9raHV3Bey55FJc20C6BnuNSYAxwfcVTOi6uvN68JUVh6JeJ14biAQkqoVhVsSP9yt7PNUwhT3aVi8q9kDgr49w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpVDviGQCevWPEAKBDvDeIXQ7kd03+3V0tNe4zGXVvU=;
 b=j5UI9dO0OF59Ge1UiB9FUh0jy+3URHMktHqCKcIoMnz6/TagYZva1A/HkY3xtcLWVHEu/uBl+s+H4J3kWMhalNlVikRIw4hNJ6FAEPn9OwRC0+GspJAqKsmGfWTZauxTghc+BWZl1Cp28XQ4ej+MVgSPONj/IQpjE0Q5aQ9OyjTsIOzDP5jmk8f69AYKuh3za1dFmRV7Px6Y9K74QI8jAjb2ImNfqs7iwHAoS28O6kZPomFwNRNQhexqTjtxcErPWplyyD2ArftBx5h+fUGv60OEJxuR1j+JhyS1DDnhDi3QwiBV74UE/gcBdf3yhkY1Od9JV11CjaHfeItBNqwGEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpVDviGQCevWPEAKBDvDeIXQ7kd03+3V0tNe4zGXVvU=;
 b=QvUDwfpE1MhcDXCl1+i1RJaFcXzYbPocnrTC2/BDzOo6siVGVEmgZ62Noy9LUbpCjyDQNaRZckFiRyw9yx4GSQ0drnFM/85zRuuORjXWEuXAGCZy2iujoybt9phLG0SD5dYx1pXkcZa0IVAmijCmvev1srTE5N/xcvaiW61zOWk=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS7PR12MB6168.namprd12.prod.outlook.com (2603:10b6:8:97::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.16; Thu, 19 Nov 2026 05:23:52 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 05:23:52 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "pfalcato@suse.de" <pfalcato@suse.de>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chrisl@kernel.org" <chrisl@kernel.org>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"youngjun.park@lge.com" <youngjun.park@lge.com>, "jack@suse.cz"
	<jack@suse.cz>, "minchan@kernel.org" <minchan@kernel.org>,
	"baohua@kernel.org" <baohua@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"jannh@google.com" <jannh@google.com>, "ljs@kernel.org" <ljs@kernel.org>,
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH mm-new v2 2/5] mm/swapops: remove unused
 make_guard_swp_entry()
Thread-Topic: [PATCH mm-new v2 2/5] mm/swapops: remove unused
 make_guard_swp_entry()
Thread-Index: AQHddmOwLMOy1CS8vUmg++CtT7qV9rc034uA
Date: Thu, 19 Nov 2026 05:23:52 +0000
Message-ID: <be3c4adef1bbccac2e113f4be2dae96abd79c570.camel@amd.com>
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
	 <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS7PR12MB6168:EE_
x-ms-office365-filtering-correlation-id: 94cfdfa8-9b91-494d-a47b-08df45fd4cad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261021123027099003|921020|38070700021|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003|261009223027099003;
x-microsoft-antispam-message-info:
 xH/bTaDvn2v9Od3lVns8htwCjUnZaHUQT3188W6Y4U57KF+658YGaLEMDt+Bx2N0MhCmBglDAGlhiuBvT9GfG80zuzooKAyNEmuoig8SHU0P3+lrn/SSP72cKvf8D2jSX/So2orRzrnQm7svOp8rNXKTTx+3Cg0RH+Wz3IpTNGTl49ARmKpqSZt33yW1jbZplxbT181yWyBtZKm08Xm8lrgW3z4foZ2PrWzWBR0bDrLboQ0iKTU5+umZPKw04mzLKEjJ4zTconZbn3/4w/Z+i67EslIRjswwVAxJzwBWjU6er3rKdo+SwNW1aQ4hi+rCxXuFFieUS3tq//ZEJSPmcOeFCLM/lSLZ7WLyGu53avFCV6fFBU42qe2WBYmpv2Vl0AubEareFHkuz/4TDJdxl5NTFOzSn6z0F88TD3tB9++on3t+Fe9X5lOdi2A+ty6J5rsR1ZH5y3jW25FqO6qJmVJKYORXVo7i04Cn3qzoCzFM4TobCJQQh9zqfcoqoa1OLJLwkwmeklOQPyoGwJnpoX36b0+Amlv1lt8KN9cDDGyMD7KUOs65/vDLkEk5/7AjQaRuUY8KkLFCrw7wBP6uNfmMZQmcibOT/c5TuM68vG8PVQj4qOONMNs73Q6g/v1W1qcmxdVuWvGauFjZX9FT3iQcu0d8HoexI3fKx2AQ2tzpRvW5J6ymXv7d4Cji0gext3mVGdzRzy/5sF+2PV3bLBLrxmaRQ2r/wOD7yJlQTvjozTTx5qTVpNcgzDBEjcXp
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261021123027099003)(921020)(38070700021)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cDlIYSsrWUpZUEhINVNGQnFMV0libXoweFNMTVE3M3FjT2hXc0Q5RnIxelEx?=
 =?utf-8?B?NnRNVUtSVWRwbC9VTmZONVVQMVVYYzQ0YWNVUUVHRi9MWGQrRDVOKzB0RTln?=
 =?utf-8?B?YVgvNEtMMFA3MnJZSEFNamk3dExlWTBoSCtTWjhXSmNOcG9WU3BQclo4WjAv?=
 =?utf-8?B?aXRoWElZbzJSUmdiMEtMY2hDMkxqMGNpTzhrR083UTFIWGhqbzJnMElvdW1q?=
 =?utf-8?B?Vy9iM2xSTHREdU1NSUlKbXQrMENvTEc2TllkREhRZWN0Vm5hY2NINTBYZlYz?=
 =?utf-8?B?ZlVQVXdxTisvZEl5MDBEcnlrRTNCS3VqNE1nTVRVaEV2ZytYdDNmQitRaHdJ?=
 =?utf-8?B?aXhsL29qODhDWVcxRWI5MW1mbGY4NWRjN3czV01ERVBpMTJRYkRLQmhPaDdO?=
 =?utf-8?B?Tmg2WjBHNjY0dzc5TCthSHQybnF2OW1nK1BDdDhFVlR1QjBlcjByVXZmV0VL?=
 =?utf-8?B?TWdHeUV6djJ1ZW03dzdOSHVQeCtsNUs0WjZYc3JCdm80L2dmUmpEbUhOZjk0?=
 =?utf-8?B?Z0FFdTZEYlJVMTlIWXdubDFBaDlSK3VMT2plWjRoL00rMk1mNnQrQ2RrUnVL?=
 =?utf-8?B?QkgwMVJpVFlndkdoYlE2YXNrZW5Fdy9GTzVUN2hsRVUyTGVORk1IY08zZkpa?=
 =?utf-8?B?RFBZdzF1LzBnanNzNFVFUEhSdTVJRVVwMFEzcW1rRE1STlR2andLSkdYbGlO?=
 =?utf-8?B?a0x6WGtQTklhcVFxcnJNOTZWNG9vcHNSWmdyeUFQL0ZzQ3A2V3kxSW1CUWNU?=
 =?utf-8?B?VmRHdEcrVjNOTm1GMXJhbE13R1haUHVKS0FiMFE4ZW5xaU9JNWoxalZHeEFi?=
 =?utf-8?B?VTVLTU15Umt1UVBaWW1HYTBFZEpSOHdxWVEvSGFPMmxmYXB6VlBSUXVBVlJR?=
 =?utf-8?B?azdjNktES0dmTVA1VmRXNTBObUpvSDBsOU5Sak9adGs0dkxuOXMyU2tsTUEw?=
 =?utf-8?B?OWloZjVmYW1wZXJ3cWIzQzc4OW9nT3lIOGl0NFI5TlZhV1lJK0NlUVI4b2Fs?=
 =?utf-8?B?VFkxR3ptUlRmQlRjbHJVb1ZudzY1R3RqL3BvSTYzUUlyVUZoZ2ozQXZJVDBO?=
 =?utf-8?B?Nmc3KzFrNGNiWm9RMVFia25NWWhjV2laanUveFoybEE2eml5ZTIzQUFCa0ZT?=
 =?utf-8?B?di9icGZHM3crc3Q3Q1U5SC9iZjl6c0k1d0JKS3U3UDh5dTQ1Z21HWW81aE9u?=
 =?utf-8?B?czNrODN6R3pLNC9vTnV5dWw1SStoNGhsL2llUGtiT3lnRXpGRnlPR1djcWpj?=
 =?utf-8?B?dFJ4QmtNd2ZwNXRkeGlleTRLVFg1K1lvOXNsQThYSWZBVy9xa2N2R0xka0U3?=
 =?utf-8?B?K1ZMWFFjVEFlZWRkSDFKbkgrdUl5cVAyRjVpNWR0aSs0VjRCL25nVG9MWkJP?=
 =?utf-8?B?TGQwbUg1NUZZL1JOdUNRK01FNWtXRzRFWmdNV0xKVWxOeFd3UDJSNGNxUGxS?=
 =?utf-8?B?UXNzeFY5OXhubUtYbmE5aDE5Wkw2TXdVbDVYQktGVWtjc1lueGhGcERkU3JR?=
 =?utf-8?B?ZDh0NDVvc04zVWJNRnI1R2VUeVRsZHpwUkxjcVFKN3d4dTg3UjAzYlkvZTNt?=
 =?utf-8?B?amZ4OHEyd05CSWc4ckRpM01xM2NQZEl1R3c1TDR2YS9ZenlOTlpsSlNSNy9u?=
 =?utf-8?B?Y2ZIMGRIMlZsTU5HMmxKcWJISllETE1OclRtOEQ1QllHanVTUHh3S3RYWnJJ?=
 =?utf-8?B?Y0VhdFhKdHNJMjM3N3FzL05iM1R1YkRhWVBjTGhDSCtvWXVFNEs1dFNlbzly?=
 =?utf-8?B?UEJPTGFza01WSUR2MXZ1SUpNc2c2NktFMDUwMVpQVVFzYk1uU3V4djFEN2Vp?=
 =?utf-8?B?b3B0MGRJWndtQWN1cXhJbS9VcXMzei9zNEJrYTZBUXBKajlqcUZmWXExbS90?=
 =?utf-8?B?UnRkcXhPcVhtd3hMMGZNWGw1dVMyMFJDdnFlN3BYb2RzSnRrQi9oL0ZxMjVn?=
 =?utf-8?B?UU5TVDQ0RnYvMDdwc1k5OUZPcUdaZVh3Z3Z6SEpCVDM1ZGZFVnpJL1hPSWRP?=
 =?utf-8?B?S2pXZ1BkcDZOYjU3dU9lRE92T0JXdnhQa3dNV3Q0NnJHejl0TEd5Snp3VWtP?=
 =?utf-8?B?cTE4TElHMWp3T3JqSGJVS0NZZ3JrVXF4eDJyWFVCYkdYUzQvTVg0Mnh5eStm?=
 =?utf-8?B?dTNjd0hPRzV6WG5KbFYybmlxd1NuMGpsQThudXE4bUJwc3IrdGFjYlAzY2F4?=
 =?utf-8?B?ZklieEdVOWNmM2NBNFNiUHRRRnltSENFbkxRWmE2WkNoWEY5SHM3Qk5ReGpY?=
 =?utf-8?B?UThIOHVvOU4rNXJPUDVBN0FGZU5oOXczNk0yNUpveU1JUmZrVDUzanFFOWNS?=
 =?utf-8?B?eko5NnQzQnZzYzVSTWVXR3ZGKzdrSVhsQnI4MjVBT1BVWDRna1FEZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC128863368440439A247985F64E2B2A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94cfdfa8-9b91-494d-a47b-08df45fd4cad
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 05:23:52.4702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9mGpTdrn6CuZzHDZgPuxNbEorU6Shc/DHJhTelvZFdp9H7K7X2K0pkiqBXzb/yIfhiLN1yifeW7atLr3wBJ6xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6168
X-Stat-Signature: k1jqor13sf1j3exzm81ue9irdmjbzzh5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C13CA40006
X-HE-Tag: 1795065837-174149
X-HE-Meta: U2FsdGVkX1+q2Fy7M0Zrm5tYS6kFidSNY2J8HUY8d2cmsYq6fYAcNcpwaIW7BLqKNtryJU8eP8+rZkED0CUKFTFgyKuX6DMgbcoY0qXS0GU0axJKG9RWh+CAcCtz1eATsWdemv5Zu2x15Sg/sgaryqkBmqv4lKac3s3hrnsuqJ83pr1/raL3tLPjdH9zT2ADtmqLv2V4SxbP3DeNkjE1hRwkEEf8AZT5KEIICG/2+mCPi+JLmXDbadXHXOInewXl0cl/5e0ORNWRAVm9VPbo3LMdHrTYrtgEPLBvKF9357ASa3n5kKIgHONdFAqBPl/pUzEaKtwkKG3Zl5U+4DPgFLMnk5QLPOZ+rFemMo4FPHDF+FvtKgm3SKd/zkQFoTyhlRVP0zh5UwkPmYxZ/Qif16Xitm7CysCZmLd1BJPojqI5RjoY7vfpndRNbxh01XVUnH4ksupZIAap5ec04KZY1QXxzXdKkVg5pZ/KEorln+IYeTrX1A/xkjuLhdakKuxDEc2zFaP3nlA45npR506W4WSb4tlhfYloGG9pxX2z7AlFP0pRImxyI0ybiTtxWXvbpBpmZ0HYRRFFscf/3F4WRmXHyEcuKMPiaNVxGzdRfgDBaG/nR31uXx5UVvR0LuA3hnsgaGYzY3NvkxJk1ZIcjqv23hZO1bGyn8Z3NcnTCfIBn/mIik6eOhSQ4wWBULNJaPEep06bdOupKiVMOKPCPoHZKaQKx1zVHdtizlA47/RM8uxMt8GbS//+N6Q3KizRaG8WshhbWUji+cTpcp9wbcAzRLISdHxVyI6l2/Gj2HU21Vfry/wXdJLXMtykHmLR8A+EiDrCufRBGFTFj0+6oT+vwoH0bXv99jUSTS+MKUMF24OhIdOxKwgA4p9E1JC+aNLyh/zhHlA6y0O4AfNsUsAv4ykuQKzlEVS/6iGYiVZeOql5OGfRoAuCwlFAWwyca9hEad5jSQz8fwNZDrT
 b5FjCfRj
 Uh7L+lz4zlcAaDjCKBRJHmN0Xy7vPH+Ahtpnodfr/3y522DX0BtK7U8Ehq7oVgrVPHHHfOgM8gX3qW7vcnHW0TQdc16gMvjC2bN73wT0TOgTdNdBloLLe3BNN0RZTkJ3+QU7tI/FNZ2Jn12WPBPKLvCW4WvRgXXBn/UzvVpvJDMMO55BZzEv4coPymL29OaoFNcKu6Kf63V1w2Kb+XrnQEQLjAWHQbh3sCUM+0Kd4Ab3bP1q/Uw2Kq6rtLcnfebFdOPD8oiNiijp854bRulU1/zgiB1PxAbyu5rKMapgPG+dj4zbQxtJdxXb9Zjav+/kLZg/YfTJNTjD0OOobBISBE8cVpwhPANXX2WhiMGiT89+ykU6o/F2fIJw6tTQHZG0etGsmOUBu0mqrJOuflT/UAiTUgCUm7zSpAVBWgXtYbQSmWqcFo+g4Abl/QQZdwM3AaqKv0g52jc0MQEJ3cLg1v6sDOUgqXc/zlafeH+jEnw5gK+swvtl05HBRzlEkKbUDRD9ubC79FYXi7es=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gVHVlLCAyMDI2LTExLTE3IGF0IDA3OjE2ICswMDAwLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+
IG1ha2VfZ3VhcmRfc3dwX2VudHJ5KCkgaGFzIG5vIGNhbGxlcnMuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBTaGl2YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS9s
aW51eC9zd2Fwb3BzLmggfCA1IC0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNSBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3N3YXBvcHMuaCBiL2luY2x1ZGUv
bGludXgvc3dhcG9wcy5oDQo+IGluZGV4IDYwM2Y5ZTNmOTA5Yy4uNmY2MmZjM2M4Y2ZhIDEwMDY0
NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3N3YXBvcHMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4
L3N3YXBvcHMuaA0KPiBAQCAtMzA2LDExICszMDYsNiBAQCBzdGF0aWMgaW5saW5lIHN3cF9lbnRy
eV90IG1ha2VfcG9pc29uZWRfc3dwX2VudHJ5KHZvaWQpDQo+ICAJcmV0dXJuIG1ha2VfcHRlX21h
cmtlcl9lbnRyeShQVEVfTUFSS0VSX1BPSVNPTkVEKTsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIGlu
bGluZSBzd3BfZW50cnlfdCBtYWtlX2d1YXJkX3N3cF9lbnRyeSh2b2lkKQ0KPiAtew0KPiAtCXJl
dHVybiBtYWtlX3B0ZV9tYXJrZXJfZW50cnkoUFRFX01BUktFUl9HVUFSRCk7DQo+IC19DQo+IC0N
Cj4gIHN0cnVjdCBwYWdlX3ZtYV9tYXBwZWRfd2FsazsNCj4gIA0KPiAgI2lmZGVmIENPTkZJR19B
UkNIX0hBU19QTURfU09GVExFQVZFUw0KDQoNCkhpIEFuZHJldywNCg0KUGxlYXNlIGZvbGQgdGhp
cyBhZGRpdGlvbmFsIGluZm8gdG8gY29tbWl0IGFzIHN1Z2dlc3RlZCBieSBEZXY6DQoNCm1ha2Vf
Z3VhcmRfc3dwX2VudHJ5KCkgd2FzIGFkZGVkIGluIDdjNTNkZmJkYjAyNCAoIm1tOiBhZGQgUFRF
X01BUktFUl9HVUFSRA0KUFRFIG1hcmtlciIpLCBoYXMgbmV2ZXIgaGFkIGEgY2FsbGVyLCBhbmQg
bm9uZSBoYXMgYmVlbiBwb3N0ZWQgaW4gMiB5ZWFycy4NCg0KSWYgeW91IHByZWZlciwgSSBjYW4g
c2VuZCBWMyB3aXRoIHVwZGF0ZWQgY29tbWl0IHRleHQuDQoNClRoYW5rcywNClNoaXZhbmsNCg==

