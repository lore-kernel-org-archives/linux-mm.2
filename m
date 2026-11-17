Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DA0606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=dCL8BFU6
Received: by kanga.kvack.org (Postfix)
	id 9B30C6B05B6; Tue, 17 Nov 2026 00:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9632F6B05B7; Tue, 17 Nov 2026 00:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AAD6B05B9; Tue, 17 Nov 2026 00:27:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A91C6B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:27:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6C7F140308
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:27:45 +0000 (UTC)
X-FDA: 85443478890.30.33EF6B7
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010005.outbound.protection.outlook.com [52.101.193.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 881D740005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:27:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dCL8BFU6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.5 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794893262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOPZVEEWJJMy3N+J9cihXiuIotz90KUMvKgIwTms13E=;
	b=4kFvcP6Q8HaNxksqpJajg/5XuFwp8eS3BreMD4znsKHdqIVLOwPlkeAPcifwmLf7RIrVg6
	A5V67ZvACiF7NTDdBnDD+D4Dp+GfxqZE+TgG6g30AGKvHhWzHdcCBT/zCQ9eCc+e5V9nrg
	0n7KejZifVsbMsZMWltyOawpnIXpLvw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794893262;
	b=qmKefykc9iO2j+OKn8c0o7pyVnQAy2Cpe4ho7ZkPPgjcyzyv6mFwmPhlQlebM44Fod2FUx
	ZXGoUTOqBe6xsE8RQ80uyC4Hjt/Zuzj2VfNwyaAWFIpzjaN5gIyzWPNDyt/vTEgR0tvd2d
	M9AY62rzefPHySYdg2vnNz7hoWmBWzc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dCL8BFU6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.5 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JPuoEND7fLqScIL/rQu2dQvkHcVnZNzgx8hY2lm6vLD+UpGTKJKSrhPWDHd94RV7Gxy+2JEgViD+lublbT/xY184uixvyA99ITV3vMwzhZW/mXO+aFXGSEyCX20ZGAQjoJeSozXFGme0irNlM8BOSNimX2vZV21LU5h3WsJMiwBzdj4ix3Cmu/dBqXnIq8S7YVsjTXtzFKcX0t6SxwTCx0jbabhqo1OQOJr7HJ5zi1Q7CXM26d4B9RxibDKwzvR0a00i8snvOUWZcaCCmASfAbWNEbyhFCHVw+ql1wvOUO28XmMHlbMM3t52NnA0ewsedC8OgnFs/xaQqJkABHU4zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOPZVEEWJJMy3N+J9cihXiuIotz90KUMvKgIwTms13E=;
 b=dBktSEdETpcyxjDuNMT3yHMYXMHSOCVZgUr9KnMWW9XxIWzxMHp7CZq0hbEebM7Bf50KEA5fV1byjqWnHklsAB1NXs09x0tO1ej798FHa93mmXVmFgVuALOohBZg32JXbb1nlR6Wx8U2tYEVsogTiWMpNOEWHUfqvhNGmbAyQ50ttYi6ougi8tC3Cy0gYFSlqUNRqLrdZoyBFrzGSiaL2w4MuKtEV1f62D4pYAZyyzNE8TbO3+oRVTlULIlGP0YqkJ70Cai71HmI17ukxkOQEI8y7hq+/IOq8jN/AqT5dz077OG200zERVAtqTjWZXpLjS+CK6LR9874a2UBw3wN3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOPZVEEWJJMy3N+J9cihXiuIotz90KUMvKgIwTms13E=;
 b=dCL8BFU62Y7fltKWzvwczz0sbwgjoItaTbpc8Bx2f5rimUSv1XofISEHunWSSMAVJLaccFs5wZEBHvEeO4nQ84MyWeDtvIh67O6EZZkOGsK4uGBQHqgb0xMSJp4HAPfyHmWMoeDs6fKUwWkA/HLQhTY7ogFO/7F1XEDY4+YNcGY=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SN7PR12MB6715.namprd12.prod.outlook.com (2603:10b6:806:271::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 05:27:37 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 05:27:37 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "tejavojjala@google.com" <tejavojjala@google.com>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "david@kernel.org" <david@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "surenb@google.com" <surenb@google.com>,
	"sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	"xiangzao@linux.alibaba.com" <xiangzao@linux.alibaba.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "nhuhuan@google.com"
	<nhuhuan@google.com>, "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>, "ljs@kernel.org"
	<ljs@kernel.org>, "rientjes@google.com" <rientjes@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "torvalds@linuxfoundation.org"
	<torvalds@linuxfoundation.org>, "kaitao.cheng@linux.dev"
	<kaitao.cheng@linux.dev>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
Thread-Topic: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
Thread-Index: AQHddFtW3mKkxLhMt0e2UDb2HN+mjbcxv/2A
Date: Tue, 17 Nov 2026 05:27:36 +0000
Message-ID: <2dd5ed03f167563d8b37a4e1ae4b17d2d8aa31a2.camel@amd.com>
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
	 <sashiko-outbox-214828@kernel.org>
In-Reply-To: <sashiko-outbox-214828@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|SN7PR12MB6715:EE_
x-ms-office365-filtering-correlation-id: 0477f868-dc97-4bcb-2b43-08df446b7d9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|22082099003|18002099003|6133799003|261009223027099003|921020|11063799006|56012099006|10067099003|4143699003|261102123227099003|261028144727099003|261026121527099003|261026130827099003|261026140227099003|261021133027099003|261026135527099003|261021121427099003|261021130227099003|261021135927099003|261021123027099003|261022075727099003|261022105027099003|261022113327099003|261022115727099003|38070700021;
x-microsoft-antispam-message-info:
 TxkKp2Te+DiRdnJ+QBOUEb4q0DiG9Y4rrztf1EpzPVvsZ4CiFDxmGSm1VR08KmXAQ1IXl61iqz4qdxP9G2HsNNwRnhGQINDBVNOt1fwW30mYssujaBXEeMkqDoFsT5gCcu+Rh/fhtyarlPrguft409BFqvF33gmsHKL55FoU6LIcwlEc7+9U+fl5QrBV4oi+qslMgK3uyoxbOtLTNSnbFWPk/IGnjYjNXovN/mKxUCj6z+1KxAk6LdLifKACBuhnycjcJZLY800NfSlV2C7sSNQs8XlIbQGP4RyZDKawOBu1RPXTQmQd4B+DbkMFJ5LkdFVhFyfapqZsctzzR53y3A253Jg4/TQEI98s8ysbNKhI1JMT7skKQXOUIOGGdNdDbB+1xvcX26NoE9LMEzhikJEWQUPgYbxQHTUYfItny70pG1M+tKc8YUv9ifkK5awY4J+RlyKgduCUoTytDcT5F9XuXeFqV7xlv9uah8cvmK42/Q8Na4OLSj4JLWbhWiKtbwv96IYS9ndhZUCbeSayLVn9Wu7p96Y9KuH4GyYionOOQyRO8s/rWns5ww1EnFGpQ/QKYDBJgYXzCofpRi81iuMPRTsJNR8S/zXMCKx5bmLEmAohcMMwyi+TwgK09DJNx8TtFwhLk4fcsGizUo5I+1IAZ8T6Dhf+jvE7LPKFj3BMUWNObzyVoS2KFkT5llMp
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(22082099003)(18002099003)(6133799003)(261009223027099003)(921020)(11063799006)(56012099006)(10067099003)(4143699003)(261102123227099003)(261028144727099003)(261026121527099003)(261026130827099003)(261026140227099003)(261021133027099003)(261026135527099003)(261021121427099003)(261021130227099003)(261021135927099003)(261021123027099003)(261022075727099003)(261022105027099003)(261022113327099003)(261022115727099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M1VTcFdzdnVWMWsvT05WeXBaOUZvT20vWFF4VzhGaVZxbURBM3JSdU96ZEhw?=
 =?utf-8?B?alU5MVNBQlN3b0FWcWFBVFRzRW5kck1wOXJEY0FSMG5RdzVzWkdMWHp6bFNX?=
 =?utf-8?B?aFN6encxMnJKL3hmSmd3N0Z2ZXBiM3BXNUR2LzJDZHRsUUcycktlK3krMlFj?=
 =?utf-8?B?cXloUVU5V1MvZk9pYVVJZlAyQUY0RlJ5eFgvNVp1SHVhRldRUmFNdHBSMm1k?=
 =?utf-8?B?MXczejlBMGY5WmtHV2I2QnRUaGRxV3I2N005NlNQOVJ5NVFSSllFc2l4T2pv?=
 =?utf-8?B?ZGhFTjM5NjZnb2VaaXplTi9QSko4eDNQQWc3UFo3d3BIc3RNTXFNZnVmM0oy?=
 =?utf-8?B?NEk2bkhIc2NSclBHOFo2MEJESWYyS1YxN2IySUVVUEQwVlRGUzBzQjlrb29x?=
 =?utf-8?B?YUpoMms2RHpOeVJPNmRvdFVLVzRjdWRNRVlsTzdFNHEyS2JScktuU2s2OVl6?=
 =?utf-8?B?ZEg5RUNUaEczb28wQUJzZitNcXdVZllqZnhLTDcyWGliZ0swdndLZktCQWZ6?=
 =?utf-8?B?N1JWa2dhRVl2K3JCSFVMdS9uenNNK1U4bXdrTDlBazVTN2hlcGQvYkE4VG1s?=
 =?utf-8?B?OGZGbkhiejJMd0VqdEtwT053WWF1VXFaQjFmRGJ0SGpVMU4xbVl1a1k2Z3Jq?=
 =?utf-8?B?cnc3R3BCOXc1WnB0WmNMcklrcmNXVy9NYm9aTlRPM1VYNktGR3NITDgvSGo2?=
 =?utf-8?B?NXIwRHJrOWRlSWhEMStzTmhEdjdHNzFkeVYvV0VCNjV4c3Z1c0l1NkhXZHA0?=
 =?utf-8?B?bERyeGgvVktMOGlYZGx4T05ZNHB0OURUU3pKMnllVDVPck9UeGk3elo2eFAx?=
 =?utf-8?B?bEtLKzRuL0RqSWcvanNEa1FNa09Yc0NXdVJxOVRpZjg2eit5NXAyZ0pEOUp5?=
 =?utf-8?B?YWJaV0k0enVaT0JycTR3OVFWRGtVbExCOWpuazB5M21ycXFvVGZOSlhlL3Fh?=
 =?utf-8?B?VTFydUhLejAzVWhuRVQ3cnJURDZBSVFvNzE3RTcvSTVFQ3JVV2FDQ211Wko2?=
 =?utf-8?B?d2hRT3J6OWxpRkpadnhtSG9abm9DblcvakJuUkpaWm8xMXJvay9VRGdsSExq?=
 =?utf-8?B?ZXpTcVI2TVAxRlM0UWNFSVIrYjNadEVlQUg1WUlYSjhXQTloYjBWek5aMEZu?=
 =?utf-8?B?TkJtZXVqYU1JZVlNS1ZEbkYxODFhWFZwbE9wQjRnZiswcWFiZ1grTGgvT3kx?=
 =?utf-8?B?Qzd2T3VTempRVFd0US9Qbys5REdTQUlkM3pNakVWMXNJdE9SWUtkMVNISFNx?=
 =?utf-8?B?cHNPTkFFYkU3cU0xTDcvc0I1NS9SY1IzMEU4MVhPTCtrMUJYeGxabTJzd2Rn?=
 =?utf-8?B?WTNxM1Q2T1ZhQVAxZk1jWm5pRHJ3Ty9La3VYeVY1eEp1MGRIemtPREFobXpy?=
 =?utf-8?B?aloyU0UwL05pU0N1ZWVTNGV1QVJkY2tMODZNSmt4ell5dlFXNlF1RVNGVWF0?=
 =?utf-8?B?WjlDZ3NoWktJR0IvcW1Ybm1TaGZGNVh2SDF4Q3lTM2hsQ3BPcFVTbDIrejEv?=
 =?utf-8?B?VW1vaCttYzZISTJVVGpETkJtWnE2ZXRvSWhWcmo0MktEU1dib3doakkySDFX?=
 =?utf-8?B?SGJva2tUWXBBaFFiUCtFQlFyenFndmtyUmFZazNKS1FHQXNLQmdUMEYwSnRW?=
 =?utf-8?B?Z3E2dGxIRDZaZVEzZ25iR0srRUJMcnorMUViTUVuWVNBcW5KTk9QQXpudVRJ?=
 =?utf-8?B?cWFMVzZDWXpuUWVGcE5TZ3BYWHVpdnJ5UEVYN2JRcGVXeG9OTThlZGE3TVRo?=
 =?utf-8?B?K0N5N05wL1RYcDBsa3Mwb25ZWUxSSVB4cTRYYWNYU2p3WTNpbHA1SFB3Z200?=
 =?utf-8?B?blJEZkVRZ1dOQjF1ZTd2b1ZBTWdOQmR6SEdFYXVlbGM0YmZDNmZaUkxSYlM4?=
 =?utf-8?B?QytXemlGQktiZ1h2MlVGcWVlNkRDV1BBUjJ4aGR0Snk0bEQzRVpLRitkazJV?=
 =?utf-8?B?QzM3bUIyc0M4RHlNTGhhbTdLWTNqeE40TFcwUzkzSjd6RWNhWmxpcGR6Ymxk?=
 =?utf-8?B?YTN0ZWU4am1JZWk4d1VBeUN1RlJIZFpNR2JDdFYwNjVIdVVuR0RzZGVWbDU4?=
 =?utf-8?B?R0lTZVFwYTlDK1ZaWHZaMEY0TXplRjN4ZlBFK0F1NmJqSkUyTndqSGtXZStv?=
 =?utf-8?B?enZzSkh3QVdWbGJ0OUxOSmc0VzNVTjBHT3FUdGZPUlh4SkFDenQ4bW5jSzAr?=
 =?utf-8?B?TVNSVEZ4Z003TUlDUE9LclZSeUlUUjJPeXZBVnRZbGR5OWw4MnU5WUt3YTJK?=
 =?utf-8?B?aDJ0VTd3cGJZMHk2U24xWG5Ma0tGdmF5UGV2UWhzZkVpTENRY0lzcWk4d00x?=
 =?utf-8?B?c21uU2Y3d0FhVnlBWWRLWVdIWUhQcm00ejBxblZtR2xjNkp1dGR5UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BF97B0242B8734F91436EA1EFE9B812@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0477f868-dc97-4bcb-2b43-08df446b7d9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2026 05:27:36.9054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gLL8dmgP6tfUU6nUHHQZ1izEvCtARkq6mDE2cMiCnpeF16JeCFNTOt7SPYOmMA9kHmLtT/m1eJH7uyKmCD/KSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6715
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 881D740005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5zbc6mu1ptfgssg99z993xz11die1z8m
X-Rspam-User: 
X-HE-Tag: 1794893262-358738
X-HE-Meta: U2FsdGVkX18HaCeoL+yoDfk/+PgPdVEylyKkU+Sju/JbHxEgyHVxMTIUK9vXYFCm8vegbtQDJsyaiAF7Lg73EcNIVRMXYdJBtdAEwObsmCpmrkqx3x1yXQJpfROQg61Zft6gKMf5DQN3gtRIbVNLrp8tmuKdX0B6wxUCTzk+Ek9TCJqQ9fHB3uMDXoSOIwBSAbbtDjE3ixTu31OFnH9xHxoIZBT7tfEoamCpcZBOgg9zKMO9/06NG77FUyK7NiSBMgUrb0qBAveidWWuWcO3SlJaFZWfgSEOPN5eGxWOD678oXChihGxgWHLg2kc0BLKwWFbFLtSuPlXfnG58h9INEOee6XLAkqinIoNR+i1fe5YhOsMqeAiS/8D/Y75wg6QTpPywBrjGefsjqJBhNsx2vcoIoVxE5kMLnay3WKJNc68SziS21E2jZ7kITajAnAl7Urj1yXvkT82FA/VxIW5XPx1+LvPV8lbQbh9sda5wvgd9KiM77tQWWUkZ4ImVBAidAILwwr9GT4zSoCcrF2tDw7T857ACAoJTG+sBfiAkjo8y2bPMQggTsqyDAOZw8nEwCU5CKUVSMpoEMtFF/IjFGRZtoGrKELyUHU/qlIxdzsCHsAEJk3IQ3AVk0hqkJTlkyjB6+pKQhHEcNZ9IcQNWnymSO+SLy7msCjAw0LdZB680KkS6YClGepk2Yg2FvyAq4GiXzzo70rvVHozWA7bGXzUEGk6uFkqgvfbl4RPFHGEsRcgrR4Xiv0aDr6U4WgTBXRjPByfZ3By6r3y+fWh/SeZaVUIG3w00SDtkMC2UaP4/SfwuAlhorhdouqmbFLO1U69oLj8F07c0DNmw2P610pCbnlyqUYIC2uPnp193r99aAPIbzxGgiz38Fs/cnc4eQt4vZNUF6RIXCKQT3+BZUZUDisPAX5pihXMpHVWjP6cR7QWMBkzBhfRzveeH2AhDLF6T+tXjGnkCOBRq3p
 CZQIuuQX
 MKPfILgpfk4Vqr8WHvD5aprL9fL6HSgAnzMFgnCHP+ho0t1VlC/oCYMeh3OVBMzg5UDIU4YF4kB2kcg7bIpeRqk6Up0Ziqw/zudmnu2XoCp1n6tySzad3w/+Uo9c9plGM3mpkxrC1PT4RaU4q//m7NbsJI7b59VzyHG8WbKU0Adf6kzlcG2mE1TqqmGxNmNhfnyVC2VXjliNHleYPh8yWDM4aZfPjUP/GOI5yJg3JO/liS+oEiC132fP+wOCPq6/uXUcGXtZaW2KwmTT7jsZllF6t2njoJDpXKWjPn1cdRQZqEI+IAmklqd8xAHiSCa/4SSO3PlEOa6C0O2etV7s3ZPdqHNpm7BOOC3motFlcTbAl6D4y6cMJ3d9wNvZmEtbMvF0WZvH3b5x/Rx0EbfIJt9pBVk8XWavmD8kB9pZgLn0840BxMCAzGgmHj9mGXZJPeyetOgMmdGKDW049jXvurTtphH+DsvOu5HW5Md2moiofi2xQp6nLzmW5LWw9TadxjrNDXE8UGgsuzBZVs6pURP26iRAZ5RtfchFSfe25YYgd1OiDdfxuU6AvbTFyVUszwzNZ9Tg4TUcxn5QRS4I7++z504VO1pih4HiCy9NWAgwdSHFfE8ICLFb1UeuWFugvpPzA0r5M9NRges1oQIyaa6dabwCS48dv4SbicsrPQv5hh//HKBBGrjGYP9VmznbU0tslnu3pjXzPD/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gU2F0LCAyMDI2LTExLTE0IGF0IDE3OjEyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCBubyBuZXcgaXNzdWVzDQo+IGluIHRoaXMgcGF0Y2gsIGJ1dCBub3RpY2VkIDEg
cmVsYXRlZCBwcmUtZXhpc3RpbmcgaXNzdWUgaXQgZG9lcyBub3QNCj4gaW50cm9kdWNlOg0KPiAt
IFtDcml0aWNhbF0gbW06IG1pc3NpbmcgaHdwb2lzb24gY2hlY2sgaW4gY29weV9tY191c2VyX2hp
Z2hwYWdlKCkgYW5kDQo+ICAgY29weV9tY19oaWdocGFnZSgpIFsxXQ0KPiAtLQ0KPiANCj4gY29t
bWl0IGZhZTk1OTcwY2NmMjYwN2Q2NzBmMDY4NjJlNDBkM2JhOTMxMzIwMGENCj4gQXV0aG9yOiBT
aGl2YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+DQo+IA0KPiBtbTogaW50cm9kdWNlIGNvcHlf
bWNfaGlnaHBhZ2VzKCkgYW5kIGJhdGNoIGNvcHkgaW4gZm9saW9fbWNfY29weSgpDQo+IA0KPiBU
aGlzIGNvbW1pdCBpbnRyb2R1Y2VzIGNvcHlfbWNfaGlnaHBhZ2VzKCkgdG8gY29weSBwYWdlIHJh
bmdlcyB3aXRoIGENCj4gc2luZ2xlIGNvcHlfbWNfdG9fa2VybmVsKCkgY2FsbCB3aGVuIHBvc3Np
YmxlIGFuZCB1cGRhdGVzIGZvbGlvX21jX2NvcHkoKQ0KPiB0byB1c2UgaXQuDQo+IA0KPiA+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2hpZ2htZW0uaCBiL2luY2x1ZGUvbGludXgvaGlnaG1l
bS5oDQo+ID4gaW5kZXggZDdhYWM5ZGUxYzhhNC4uYTc5ZTlkNjgzNTljOCAxMDA2NDQNCj4gPiAt
LS0gYS9pbmNsdWRlL2xpbnV4L2hpZ2htZW0uaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvaGln
aG1lbS5oDQo+ID4gQEAgLTQ4NCw2ICs0ODQsNTcgQEAgc3RhdGljIGlubGluZSBpbnQgY29weV9t
Y19oaWdocGFnZShzdHJ1Y3QgcGFnZSAqdG8sIHN0cnVjdCBwYWdlICpmcm9tKQ0KPiA+ICB9DQo+
ID4gICNlbmRpZg0KPiA+ICANCj4gPiArLyoqDQo+ID4gKyAqIGNvcHlfbWNfaGlnaHBhZ2VzKCkg
LSBjb3B5IGEgcGFnZSByYW5nZSB3aXRoIG1hY2hpbmUgY2hlY2sgaGFuZGxpbmcNCj4gPiArICog
QHRvOiBmaXJzdCBkZXN0aW5hdGlvbiBwYWdlDQo+ID4gKyAqIEBmcm9tOiBmaXJzdCBzb3VyY2Ug
cGFnZQ0KPiA+ICsgKiBAbnJfcGFnZXM6IG51bWJlciBvZiBwYWdlcw0KPiA+ICsgKg0KPiA+ICsg
KiBSYW5nZSB2YXJpYW50IG9mIGNvcHlfbWNfaGlnaHBhZ2UoKS4gT24gYSBtYWNoaW5lIGNoZWNr
LCB0aGUgcG9pc29uZWQNCj4gPiArICogc291cmNlIHBhZ2UgaXMgcXVldWVkIGZvciBtZW1vcnlf
ZmFpbHVyZSgpLg0KPiA+ICsgKg0KPiA+ICsgKiBDb250ZXh0OiBQcm9jZXNzIGNvbnRleHQuIE1h
eSBzbGVlcC4NCj4gPiArICogUmV0dXJuOiAwIG9uIHN1Y2Nlc3MsIC1FSFdQT0lTT04gaWYgYSBt
YWNoaW5lIGNoZWNrIHdhcyBoYW5kbGVkLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIGlubGluZSBp
bnQgY29weV9tY19oaWdocGFnZXMoc3RydWN0IHBhZ2UgKnRvLCBzdHJ1Y3QgcGFnZSAqZnJvbSwN
Cj4gPiArCQl1bnNpZ25lZCBsb25nIG5yX3BhZ2VzKQ0KPiA+ICt7DQo+ID4gKwl1bnNpZ25lZCBs
b25nIGxlbiA9IG5yX3BhZ2VzIDw8IFBBR0VfU0hJRlQ7DQo+ID4gKwl1bnNpZ25lZCBsb25nIGks
IHJldDsNCj4gPiArDQo+ID4gKwltaWdodF9zbGVlcCgpOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4g
KwkgKiBXaGVuIGNvcHlpbmcgd2Ugd2FudCB0byBvcGVyYXRlIG9uIHRoZSBsYXJnZXN0IGV4dGVu
dCBwb3NzaWJsZSB0bw0KPiA+ICsJICogYWxsb3cgZm9yIGFyY2hpdGVjdHVyZSBzcGVjaWZpYyBl
eHRlbnQgYmFzZWQgb3B0aW1pemF0aW9ucy4NCj4gPiArCSAqDQo+ID4gKwkgKiBjb3B5X21jX3Rv
X2tlcm5lbCgpIGRvZXMgbm90IGNhbGwgY29uZF9yZXNjaGVkKCkuIFRoYXQgaXMgZmluZSBvbg0K
PiA+ICsJICogcHJlZW1wdGlibGUga2VybmVscywgd2hlcmUgdGhlIHNjaGVkdWxlciBjYW4gcHJl
ZW1wdCB0aGUgY29weSBhdA0KPiA+ICsJICogYW55IHBvaW50LCBzbyBjb3B5IHRoZSB3aG9sZSBy
YW5nZSBhdCBvbmNlIGlmIGNvcHlfbWNfdG9fa2VybmVsKCkgaXMNCj4gPiArCSAqIGF2YWlsYWJs
ZSBhbmQgdGhlIHBhZ2VzIGFyZSBpbiB0aGUgbGluZWFyIG1hcC4gT3RoZXJ3aXNlLCBjb3B5IG9u
ZQ0KPiA+ICsJICogcGFnZSBhdCBhIHRpbWUgYW5kIHJlc2NoZWR1bGUgaW4gYmV0d2Vlbi4NCj4g
PiArCSAqLw0KPiA+ICsJaWYgKElTX0VOQUJMRUQoQ09ORklHX0FSQ0hfSEFTX0NPUFlfTUMpICYm
IElTX0VOQUJMRUQoQ09ORklHX1BSRUVNUFRJT04pICYmDQo+ID4gKwkgICAgIUlTX0VOQUJMRUQo
Q09ORklHX0hJR0hNRU0pKSB7DQo+ID4gKwkJcmV0ID0gY29weV9tY190b19rZXJuZWwocGFnZV9h
ZGRyZXNzKHRvKSwgcGFnZV9hZGRyZXNzKGZyb20pLCBsZW4pOw0KPiA+ICsJCWlmIChyZXQpIHsN
Cj4gPiArCQkJbWVtb3J5X2ZhaWx1cmVfcXVldWUocGFnZV90b19wZm4oZnJvbSkgKw0KPiA+ICsJ
CQkJCSAgICAgKChsZW4gLSByZXQpID4+IFBBR0VfU0hJRlQpLCAwKTsNCj4gPiArCQkJcmV0dXJu
IC1FSFdQT0lTT047DQo+ID4gKwkJfQ0KPiA+ICsJCWZvciAoaSA9IDA7IGkgPCBucl9wYWdlczsg
aSsrKQ0KPiA+ICsJCQlrbXNhbl9jb3B5X3BhZ2VfbWV0YSh0byArIGksIGZyb20gKyBpKTsNCj4g
PiArCQlyZXR1cm4gMDsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlmb3IgKGkgPSAwOyBpIDwgbnJf
cGFnZXM7IGkrKykgew0KPiA+ICsJCWNvbmRfcmVzY2hlZCgpOw0KPiA+ICsJCWlmIChjb3B5X21j
X2hpZ2hwYWdlKHRvICsgaSwgZnJvbSArIGkpKQ0KPiA+ICsJCQlyZXR1cm4gLUVIV1BPSVNPTjsN
Cj4gPiArCX0NCj4gDQo+IFtTZXZlcml0eTogQ3JpdGljYWxdDQo+IFRoaXMgcHJvYmxlbSB3YXNu
J3QgaW50cm9kdWNlZCBieSB0aGlzIHBhdGNoLCBidXQgY2FuIGNvcHlfbWNfaGlnaHBhZ2UoKQ0K
PiBhbmQgY29weV9tY191c2VyX2hpZ2hwYWdlKCkgKGFzIHdlbGwgYXMgdGhlIG5ldyBjb3B5X21j
X2hpZ2hwYWdlcygpIGZhc3QNCj4gcGF0aCkgcmV0dXJuIDAgd2hlbiB0aGUgc291cmNlIHBhZ2Ug
b3IgaXRzIGNvbnRhaW5pbmcgZm9saW8gaXMgYWxyZWFkeQ0KPiBtYXJrZWQgUEdfaHdwb2lzb24g
WzFdPw0KDQoNClllcywgdGhlIHBhdGNoIGtlZXBzIHRoZSBleGlzdGluZyBiZWhhdmlvci4gUEdf
aHdwb2lzb24gbWFya2VkIHBhZ2VzIGFyZSBjb3BpZWQgd2l0aG91dCBlcnJvcnMgYnV0IFJlYWwg
cG9pc29uIGlzc3VlIHJldHVybnMgbm9uLXplcm8gYW5kIGZvbGlvX21jX2NvcHkoKSBmYWlscyEg
U2hvdWxkIHdlIGNvbnNpZGVyIHRoaXMgYXMgYmxvY2tlcj8NCg0KWXVhbmhlJ3MgcGF0Y2ggYWRk
cyB0aGUgY2hlY2sgdG8gY29weSAhY29weV9tYyBicmFuY2ggYnV0IGNvcHlfbWMgYnJhbmNoIGNh
biBzdGlsbCBjb3B5IHN1Y2ggYSBwYWdlLiBbMV0NCg0KU2luY2UgaXQncyBwcmUtZXhpc3Rpbmcg
aXNzdWUsIEknZCBwcmVmZXIgdG8ga2VlcCBpdCBvdXQgb2YgdGhpcyBwYXRjaC4NCkZvciBzb2x1
dGlvbiwgc2hvdWxkIHdlIGNvbnNpZGVyIGZvbGlvX2NvbnRhaW5faHdwb2lzb25lZF9wYWdlKCkg
Y2hlY2sgaW4gdGhlIGZvbGlvX21jX2NvcHkoKT8gSXQncyByYWN5IGJ1dCBiZXN0LWVmZm9ydCwg
YW5kIHdvdWxkIGF2b2lkIGFkZGluZw0KY29zdCBvZiBjaGVja2luZyBlYWNoIHBhZ2Ugd2l0aGlu
IGxhcmdlIGZvbGlvLg0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vc2Fz
aGlrby1vdXRib3gtMjA4ODc2QGtlcm5lbC5vcmcvI3QNCg0KPiBOZWl0aGVyIGhlbHBlciBjaGVj
a3MgUGFnZUhXUG9pc29uKCkgb3IgZm9saW9fY29udGFpbl9od3BvaXNvbmVkX3BhZ2UoKQ0KPiBi
ZWZvcmUgY29weWluZy4gIGNvcHlfbWNfdG9fa2VybmVsKCkgb25seSBjYXRjaGVzIHN5bmNocm9u
b3VzICNNQw0KPiBleGNlcHRpb25zIHJhaXNlZCBkdXJpbmcgdGhlIGNvcHkgaXRzZWxmIChhbmQg
ZmFsbHMgYmFjayB0byBwbGFpbiBtZW1jcHkoKQ0KPiB3aGVuIHVuYXZhaWxhYmxlIG9yIG9uIHg4
NiB3aXRob3V0IFg4Nl9GRUFUVVJFX0VSTVMgb3INCj4gY29weV9tY19mcmFnaWxlX2VuYWJsZWQp
Lg0KPiANCj4gSWYgYSBzb3VyY2UgZm9saW8gd2FzIHBvaXNvbmVkIHZpYSBzb2Z0d2FyZSBpbmpl
Y3Rpb24gKHN1Y2ggYXMNCj4gTUFEVl9IV1BPSVNPTikgb3IgYSBwcmlvciBtZW1vcnlfZmFpbHVy
ZSgpIHdoZXJlIHJlYWRpbmcgZG9lcyBub3QgdHJpZ2dlcg0KPiBhIHN5bmNocm9ub3VzICNNQywg
Y2FsbGVycyBzdWNoIGFzIGZvbGlvX21jX2NvcHkoKSBvciB3cF9wYWdlX2NvcHkoKSB0cmVhdA0K
PiB0aGUgY29weSBhcyBzdWNjZXNzZnVsIGFuZCBjb3B5IGNvcnJ1cHRlZCBkYXRhIGludG8gYSBm
cmVzaCBkZXN0aW5hdGlvbg0KPiBmb2xpbyB3aXRob3V0IFBHX2h3cG9pc29uIHNldCwgb3IgdHJp
Z2dlciBhbiB1bnJlY292ZXJhYmxlIGtlcm5lbCAjTUMgd2hlbg0KPiBjb3B5X21jX3RvX2tlcm5l
bCgpIGlzIG5vdCBhY3RpdmUuDQo+IA0KPiBbMV0gaHR0cHM6Ly9zYXNoaWtvLmRldi8jL2J1Zy9s
aW51eC0zYWY0YWE3ZC1kMTgyLTQzMGItYjk4Mi01ODNmNmFlYTQ1OTQNCg==

