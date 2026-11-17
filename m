Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3EA5606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=OWc4EYfa
Received: by kanga.kvack.org (Postfix)
	id B76976B00EF; Tue, 17 Nov 2026 11:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27996B05B0; Tue, 17 Nov 2026 11:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFCC6B05B1; Tue, 17 Nov 2026 11:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5D06B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:49:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E65731A04E0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:49:41 +0000 (UTC)
X-FDA: 85445197362.14.E6F9266
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	by imf17.hostedemail.com (Postfix) with ESMTP id D91B740005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:49:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OWc4EYfa;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.66 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794934179;
	b=vt4WbcbOKbxAhqW9FoXHDfzIayAE/lN0f40FnrD446xlb4D3MMpvD0VX5CTllC/+dawowb
	JMAwrqVfumXCyJ9BNi5MLTPCjc7zZ6HflF2FqD46NmyKuBHdXKFJnM/xUj0JzRWOwxPnhU
	5k29kzKzFycuyOpftJyb675nCabUQ7Q=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OWc4EYfa;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.66 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794934179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDGjUAKRH40rZDuk+MAX5dHwyxkcRP0qEUGDwxPXgLI=;
	b=ZsBbe67YtER9Te53GKCwkNRqA0/jW93rc8GgTEHBsnSGDfH4sah1fDrquqlSwss052v8Nm
	+X+VUdt+9aSYOz33t1f9fVngkCTHbhojI8vAkrWBDmyi0PbNLEd0bX4FV0o17OOKhMnaMS
	bCc0GfmDhlFg4OUJ4EqpRxvOE7Ts9kE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9KhNFfzyVBU4BVxVZDNXpuBORrk6HXcex5iWPhUSlTRs2zVXK9Kn/J8+/NVkPHvQ/2PVE3fpPVy4PfPEN5nvfL6/ZPoDK0on9jUlNhQ7uqxgZRvJVDmlU/JzrYoOVXV0TmXhLU1sgCKF8HEXLS73g1HykvFWdl4qjvAF5USBYv0yGHklY4ymCaJpzhRNBg/1050zzMQaUyiyZ2jCtvC7+HkoYf1ileCigBAZNu63KUQh7rgRf+8QAZS5ouje6ZxnejyP361Q5HkfHRvf8LcqVt48NSQqO+93KA0F5bmAApi1nhnyilQU4ngVcdUDzHE6r7TbltFo4pU74gQNaYuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDGjUAKRH40rZDuk+MAX5dHwyxkcRP0qEUGDwxPXgLI=;
 b=p4y3fkqxWLVO4RPpm3qbnbKqIBv+6k6Xb/KAUwtNJ1o798wrzp/YN+tB3fqERuDvHdoOYvaFxUvwUJis8q35T1FEu0nNPbw2KDpvZpi+ShLGy7Bfs8Lj/9xJRpGOANN0Z6bHlN2dTsrnDZyudcuXbhPMAC9P7sJ7z6ptP8TtbgQNl9oKdkFMnhyINEFwqHP3NNxDV1T4C8yG18bXSmBNZU2QSGUIMqPKJHfHLQ1HZK3wPPGcvh6imi5qQuPtEgk49Fv5PpZ6xT5mEk4yxe1JSV3y70bfVanqgAuJitXrEURi/SktHlx5rMwBzUOYueBnOpOKy5wt8vAcrUs58bbagg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDGjUAKRH40rZDuk+MAX5dHwyxkcRP0qEUGDwxPXgLI=;
 b=OWc4EYfaq7gAvxyqTPaFUT3TK3U3jjSP7yv1DnW6su4I6SOK3pjjE6zwT0JoHUaF5j3kSLF/J3Bu79fp2jccCrIjALQWHFhm0pXG4Bu/CipcYNBLxN5kCnj7cpxIGAvn72xl+pwNGqXEnwjK6G5hFIjp+6VNH1SpXwPlXOQqsCo=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 16:49:05 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 16:49:05 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "andreas@gaisler.com" <andreas@gaisler.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "david@kernel.org" <david@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hughd@google.com"
	<hughd@google.com>, "ljs@kernel.org" <ljs@kernel.org>, "chrisl@kernel.org"
	<chrisl@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"davem@davemloft.net" <davem@davemloft.net>
CC: "geert@linux-m68k.org" <geert@linux-m68k.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "harry@kernel.org" <harry@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "anshuman.khandual@arm.com"
	<anshuman.khandual@arm.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "surenb@google.com" <surenb@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "youngjun.park@lge.com"
	<youngjun.park@lge.com>, "sparclinux@vger.kernel.org"
	<sparclinux@vger.kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jannh@google.com" <jannh@google.com>, "liam@infradead.org"
	<liam@infradead.org>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "baohua@kernel.org"
	<baohua@kernel.org>, "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
	"pfalcato@suse.de" <pfalcato@suse.de>
Subject: Re: [PATCH v4 0/9] Optimize anonymous swapbacked large folio
 unmapping
Thread-Topic: [PATCH v4 0/9] Optimize anonymous swapbacked large folio
 unmapping
Thread-Index: AQHddrOOoRK0/oYJyUWJ5vzwhCg9vw==
Date: Tue, 17 Nov 2026 16:49:05 +0000
Message-ID: <4c351ae2672a817df071b5a8b6b402846b897a75.camel@amd.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS7PR12MB9473:EE_
x-ms-office365-filtering-correlation-id: 0851e31e-092a-4b3a-0bea-08df44cab0f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|261009223027099003|11063799006|56012099006|261028144727099003|261102123227099003|261022115727099003|261021123027099003|261022105027099003|261026140227099003|261022075727099003|261026121527099003|261021135927099003|261021121427099003|38070700021|10067099003;
x-microsoft-antispam-message-info:
 fUZuYSsa3xjI2muGYyTT0oOf1N519cYQxcyee2Yaafe4VvJbgXRejKCTI5/oFTG3GJx1/AjvHSi3bZqDGIjwK19zNJQE6KAwir6yK6NlHTYrcXBvlyj9FY23MA88WKxGUfordPjzvr2v1cXPRjNlaZmnr3d2Q159gbk9HREA/dfS3wLDSKy1OYppshdAN/d7HxnmttEit/TDCT0gzDGG9XomEYA4F/7IeYvWvbtDHqrqVUKL5F7yOHJyYgPiFbZ95jyAvs5GxSmQXtnAKrMABRDmuTPeiXIZdoA1PFgM4IEypV4fgO91hc8PZqeLdn+fFvY99E6TEFI5NWE6/nIWsTOk2KI7PO8FY+UFW8ycQgMTLtMfQj1+TaE1AAtc4YiEl3IvbYmJR1Fthi51qmZxz9GrRAZjaTWmCNUzXQJPbMFTzY+xfJ3am2w2ZJMnaMws2kLQUxi5TQmwa+PO4CLowFe4TRFV15bsE4jcBrT4fcYKris8spWkyCU5tX7Es03yqWPRpyOhRD7LrtkYJPNkcK4XloDZrxQyUA2rAruFyMcWYag4EPRtKanKHk/Ak0ufEPP8T/3fOG8p9FYHC9eLY0tsaJhpj/AUi4fcghxNy7ilBPKd6RTnjwsragY+nVVEOTczym4st6iSU5AMQsIHFdq4WyYAYDx9kNIEzdpyQio=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261022115727099003)(261021123027099003)(261022105027099003)(261026140227099003)(261022075727099003)(261026121527099003)(261021135927099003)(261021121427099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZDZUdmNERURmSHdXQXZMcDJOYkF2WVRIRGxORmxhci8yYjZ3UHYzK3UrSnhr?=
 =?utf-8?B?OE1tZlF1ekFuMGZNYzYrd3dvb29ULytWVmhmWkJ4SE14K09xcFFBaEx2Z3Jn?=
 =?utf-8?B?clZFSThqMENpdkVjN3lNSzZzUlBwYmw1MVlVOTRMZk1JOUs4RWNibjFST3Nh?=
 =?utf-8?B?Q1FjUGJoT2pWdCsxY050QXZaWHA4bDVqTjVQYVJxTHlRYkVJQitueDQ3LzZu?=
 =?utf-8?B?NzluOTJFeEJXSWFjT3VhZk9VNHEzWjdYSDRYUG9aVWR6ZnROS0Vaam03WDNi?=
 =?utf-8?B?VVE0WFpQaEpXS0VSdHZ2WHBNeWFpNmRWZFJJUFloYnpIdGF1cG1DL3pwekR5?=
 =?utf-8?B?YUxWTzhDazZDL1R2a0c3ZVBKc3pFK3BoazI0SUcxdm4ya0g3bFRkYTBTeWEx?=
 =?utf-8?B?RE9tM0g4WTF0WnFCSERHYnBzTmFPdHNxRWRWak9LUTlQTkJuRzdGNTJqYWxK?=
 =?utf-8?B?Ym5WdzB6TlI3cS9Lb21EdmRhSGE5REVWYjg5aEoyTTU4Skc4K09meW9Vb3Jz?=
 =?utf-8?B?ZngvelVCd0RLR1IxNWdpSWdqWUdOTjBIMU9lVU5MbmFjUUQyOGJyT1hWTmFJ?=
 =?utf-8?B?NnRjSlBhRXBmYVZId3djaXhnckFkYVE5NVlQOWF4WnlIYkxCckR6Nm1PVlRE?=
 =?utf-8?B?OWhNa056eFcyWUkrT2lRVlFpbEl2dU5CcG5teGM1aW9tUWVodDgrSnpDSVNq?=
 =?utf-8?B?NHl2WXRPSDdrVTVtNjVWTFJqSnlyQ0FPQUxkOCt0OEI0YXJmR2VLTERQVUgz?=
 =?utf-8?B?UmVIMCtlRDBEVnQrdUZOM05ETHRmbXBOby9GSVVEOTJhRTRmeTJSYTV1WWZN?=
 =?utf-8?B?LzNxcUUyck1FYUYrZlBqTHFPOHhLMUNaN3Y1b2tobFVaMnNHMXl4a1JwWmsw?=
 =?utf-8?B?RGJzS1l5VWhaYy9LOVAxMUI3Y1RhZWJybXZKR2lCbFNhNk1UMUcyYmJsckkx?=
 =?utf-8?B?YTUwWjNzRW1CcW04SjlwU1VpZmNjdll5SFZSN1Z2TEJURzdMc1JsV3FUdVhp?=
 =?utf-8?B?SFhGejhUdFlUMXlFR01KdVFITWJsSXQwaG81UEZHWWowNlVtNHBUZ0RuaEhL?=
 =?utf-8?B?blRINlc4NVM3L2hDR3lCQ05SMTNTQXBNN3dRZ0RJc2JMLzRKRFU1NHdLcFRY?=
 =?utf-8?B?UnN6WXJHMlByaTRjQ0ZmWXhLYmV6UWMrOXVYQjBzY3RJZ0NPc3c0NldPM1or?=
 =?utf-8?B?RlpETTNmY1RJY21IbllaaytXa3A4ZUc4Y1k2N05vTTBVL2dubm8wY2psUTJG?=
 =?utf-8?B?Qm1CQXdTOThUR2xPckU1NmRVUG5sVFdMZGVNN2ZrNXEvb2ZvZHN6dENmTnVN?=
 =?utf-8?B?OW1PMkpJNnJUZktEMGZvVC8rVCtLVlVONGhXVzB4TitjekZ4bzF6MElsU045?=
 =?utf-8?B?RytYYjRwalYxSVZEL2Rjc1dQWm1oeHJvcm9EdzZrNEtWUWkxSHZCek5CUkha?=
 =?utf-8?B?Z0J5Y0YveE5Bdnc0RWFpNTFhYWMwcmNZdXlwV0J2QmdrbmFXcEdGUTdtaDBw?=
 =?utf-8?B?aFl1TWQ4aGU2SkdBN3hYa3Z2ZEJtVVZRMGVPdmlrVVVQNGh6Uy9URFFuOWlk?=
 =?utf-8?B?YWpjWGVSZEtwOGdackJVNGN6Q2dBNjQyTXYxK2ZZRVNlRXlYeVluMm9QZngv?=
 =?utf-8?B?cE10QWV2Zm1zSU1JRGxWMC9oRFd5Qm9KNDlaV213SGRRanhtTSs5WHpSa1Zq?=
 =?utf-8?B?YlU3endjZmpNN3Jjb1Q2ZkFrbG9VNC94OEE4OE1HOVFDdTFvU0w0MTJxTmpo?=
 =?utf-8?B?UXhPK0tCRTNsdGhwNXo2N01KUkwrQXI0ZEhqUUpLa1dTamt6L0liWm5GRy9v?=
 =?utf-8?B?ZWt1L1VYclh1bEh0Q0F6bi8rZmJvN0R2REtwOFpaL0p4VkJZK3czdHl6aUFt?=
 =?utf-8?B?ZWdLTWVkMHc2QmthK25WQzNpTWNxMDBENU1QT1R1N0NMUUNncWtFTWphNlZ4?=
 =?utf-8?B?YzRIdW9DWE84dEJTZVI4TzBsUk8wUTFsdzcxU1daVU1TRmxUM21NcEo4dnd6?=
 =?utf-8?B?Mm9sVndrR3VrcE5YRHgrTzI4SmNGT2ZuRkVvdVIyWWlDZ0lNeDJ4aWJxYnYz?=
 =?utf-8?B?aVpHZ2NIRHNFaWo2T2VuU2N0M1ZMWmdtUmdqejh5c21yNnZxb3hrWFAzbWho?=
 =?utf-8?B?WFY3VkIzY2hxSW5MMFAzM2xtUXZZb0xnVStyalpGRGViV0ZQN3NweU8zTEFK?=
 =?utf-8?B?SW1pa1ZUVWtMMlBvL1VlMVB2WVhqMFphTDFtWmNzS0lSa2Y5RU9mWjE1QXY1?=
 =?utf-8?B?YVRadFRRdS93TCtIemlrRFNDVjlSRCs4L2E0Nm9EWmhCdTRST3c0dVZMMklW?=
 =?utf-8?B?NU10OS9RRW12RTladHNORmtiZ3FDRHRvVFk0bE1BdDNLeFlMQXlBZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBE0382165A2964DAD58B6355D988C90@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0851e31e-092a-4b3a-0bea-08df44cab0f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2026 16:49:05.2793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6s4t+V0W2VEJ7HdTk1n//k4XladTX6k3dtxSAp+fOhMAw2smq0XnodoHcGSodailaS+cHqfqQ/0zY4GSlEtIbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9473
X-Rspam-User: 
X-Rspamd-Queue-Id: D91B740005
X-Stat-Signature: bxru8zmkfawgkc93fdu9cfp5zxc34mtt
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794934178-276553
X-HE-Meta: U2FsdGVkX19LjneSzp8ckHfjXkIC4ZzqRRm2RUGNo3n7Ebf5a4fVmARyRWsLm6ulCpigZ1MrKMFnhM+HqRTtEGVpJPpf37/FMuTkY7GimZovnImluv7FRxOSRSrdCwLWkpqOBeYDr1aFOUiQ/8W1e/+LZ0/mz8ZhdSjKri85mmbGqakEMW4lzBmxKXzeag202cStKvjkqN+yytBB8sxhUtjERDfIDJ+9DorLGKkd+8tD7r7P7KCixhhoLd85cKaAzkwV5GLxfVrBrUQl1JhKgABIdva7H9bXWDjC4OdGg/2H/ydhnA5SGCxPxpFM5FCvh5Z0GYIJQUA6nqdRB2YBC0OIGhM953mE61G47C7k5qYa0nZmWEKUguasjz6PwlxaF53NxviSoadghnJQdIUx9vz/xxxQm+KUL6BEO6TeEGiQ1AEnyKic+c19SaIdYXHT6v3iFqD2OdgaMtnegNcW5eDuLUdcjoAyOHyMYPUSV30klqNMRW0qeNlWBRMsoekuqZuflSGlYP2WKX5KLJBy8vAZg95M1PZtUY5Yf5dbPZtR+o91Xp7xC2YmKAm5yowFz4SSTsBjRf5pHmJZpGTxEJotMyKD9En3qNaHYx//pP5qKuHPV2ghalFoBfYokX7Ob3/xlhqu7Uh1U+I5bYnHyhkLYAJX8qgdVGPZHArYUeFZvL1oWk8ZNl9g02ebtQDMSCmV/gnK8pHsSnxvu3tQLzFiLbhhKaPfmEaqz2kLRhI6fqbIj6OgEWezqwevvgziP0K9P+R9J+RqX3eufuEvuJ0V/wD+643Lp7gw119yZBCXaa31bDEynsUGyM17O63YQFC2ZteaQgC24yGcz043467dSMyBwTw8EBpqZnmqmb1ZP2ufpvdnSm5A/4ZkS00fUYdFI5tRzn3EsgKYB/iH5llV3JJ6R3RD/R6Ns4ccjU2PytHccGxXb1+ovPqg5eslZugXLK7sfM3XlEzfUmx
 uxWDPqNK
 hCC7PCw0uMnfFXgg517nZqBUpSrY9S8pKeZjSXkFSX/nqJ3R/iKfzL62bbg/wteR3H+Nnn5EaZzrhToiAb2kTHHClfPMp0WO1F+Gx9EuGNTNfaRF1nVDcBzASTm1sEOqAyraBcM07HQqTiTPs2t7rTX1UrRR1c9UJ2/O2O/7fjoIDZCf9fYEsnanuf+VXx2sEff0AKmYwgll8IIEy8RXiwuNJdjThY+nr3LanFM2jyPmEEBqe8g0JmdU+AHQF8b+wy5nE2EH2lez0oBsuYsbKsa6MYULwr9rMQwRg7IUpkQ697igY0vg2pomdp7D10BF8jJU9OFWxsWM8DUHKavCYnerG8jiAvDop6yxmxBGtSM9rIfIkTSTPMPCU7rF0R9a2neFgmHrXwtVueCN2iIGVymfOvPdHh7okpMXXhHNMYB+5Cs0Mx5Xi96y0ffejqaIe9/ldRwDeOp4wBYnM51x0/x5PYV+TXUL6FhbRkvx849q0jv6YL/J0z19+POyIWglwSvbF6WLrM7rOTQGsh4mWxdwDYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gU3VuLCAyMDI2LTExLTE1IGF0IDE0OjM4ICswMDAwLCBEZXYgSmFpbiB3cm90ZToNCj4gU3Bl
ZWQgdXAgdW5tYXBwaW5nIG9mIGFub255bW91cyBzd2FwYmFja2VkIGxhcmdlIGZvbGlvcyBieSBj
bGVhcmluZw0KPiB0aGUgcHRlcywgYW5kIHNldHRpbmcgc3dhcCBwdGVzLCBpbiBvbmUgZ28uDQo+
IA0KPiBUaGUgZm9sbG93aW5nIGJlbmNobWFyayAoc3RvbGVuIGZyb20gQmFycnkpIGlzIHVzZWQg
dG8gbWVhc3VyZSB0aGUNCj4gdGltZSB0YWtlbiB0byBzd2Fwb3V0IDI1Nk0gd29ydGggb2YgbWVt
b3J5IGJhY2tlZCBieSA2NEsgbGFyZ2UgZm9saW9zOg0KPiANCj4gICNkZWZpbmUgX0dOVV9TT1VS
Q0UNCj4gICNpbmNsdWRlIDxzdGRpby5oPg0KPiAgI2luY2x1ZGUgPHN0ZGxpYi5oPg0KPiAgI2lu
Y2x1ZGUgPHN5cy9tbWFuLmg+DQo+ICAjaW5jbHVkZSA8c3RyaW5nLmg+DQo+ICAjaW5jbHVkZSA8
dGltZS5oPg0KPiAgI2luY2x1ZGUgPHVuaXN0ZC5oPg0KPiAgI2luY2x1ZGUgPGVycm5vLmg+DQo+
IA0KPiAgI2RlZmluZSBTSVpFX01CIDI1Ng0KPiAgI2RlZmluZSBTSVpFX0JZVEVTIChTSVpFX01C
ICogMTAyNCAqIDEwMjQpDQo+IA0KPiAgaW50IG1haW4oKSB7DQo+ICAgICAgdm9pZCAqYWRkciA9
IG1tYXAoTlVMTCwgU0laRV9CWVRFUywgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwNCj4gICAgICAg
ICAgICAgICAgICAgICAgICBNQVBfUFJJVkFURSB8IE1BUF9BTk9OWU1PVVMsIC0xLCAwKTsNCj4g
ICAgICBpZiAoYWRkciA9PSBNQVBfRkFJTEVEKSB7DQo+ICAgICAgICAgIHBlcnJvcigibW1hcCBm
YWlsZWQiKTsNCj4gICAgICAgICAgcmV0dXJuIDE7DQo+ICAgICAgfQ0KPiANCj4gICAgICBtZW1z
ZXQoYWRkciwgMCwgU0laRV9CWVRFUyk7DQo+IA0KPiAgICAgIHN0cnVjdCB0aW1lc3BlYyBzdGFy
dCwgZW5kOw0KPiAgICAgIGNsb2NrX2dldHRpbWUoQ0xPQ0tfTU9OT1RPTklDLCAmc3RhcnQpOw0K
PiANCj4gICAgICBpZiAobWFkdmlzZShhZGRyLCBTSVpFX0JZVEVTLCBNQURWX1BBR0VPVVQpICE9
IDApIHsNCj4gICAgICAgICAgcGVycm9yKCJtYWR2aXNlKE1BRFZfUEFHRU9VVCkgZmFpbGVkIik7
DQo+ICAgICAgICAgIG11bm1hcChhZGRyLCBTSVpFX0JZVEVTKTsNCj4gICAgICAgICAgcmV0dXJu
IDE7DQo+ICAgICAgfQ0KPiANCj4gICAgICBjbG9ja19nZXR0aW1lKENMT0NLX01PTk9UT05JQywg
JmVuZCk7DQo+IA0KPiAgICAgIGxvbmcgZHVyYXRpb25fbnMgPSAoZW5kLnR2X3NlYyAtIHN0YXJ0
LnR2X3NlYykgKiAxZTkgKw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAoZW5kLnR2X25zZWMg
LSBzdGFydC50dl9uc2VjKTsNCj4gICAgICBwcmludGYoIm1hZHZpc2UoTUFEVl9QQUdFT1VUKSB0
b29rICVsZCBucyAoJS4zZiBtcylcbiIsDQo+ICAgICAgICAgICAgIGR1cmF0aW9uX25zLCBkdXJh
dGlvbl9ucyAvIDFlNik7DQo+IA0KPiAgICAgIG11bm1hcChhZGRyLCBTSVpFX0JZVEVTKTsNCj4g
ICAgICByZXR1cm4gMDsNCj4gIH0NCj4gDQo+IFBlcmZvcm1hbmNlIGFzIG1lYXN1cmVkIG9uIGEg
TGludXggVk0gb24gQXBwbGUgTTMgKGFybTY0KToNCj4gDQo+IFZhbmlsbGEgLSBNZWFuOiAzNzQw
MTkxMyBucywgc3RkIGRldjogMTIlDQo+IFBhdGNoZWQgLSBNZWFuOiAxNzQyMDI4MiBucywgc3Rk
IGRldjogMTElDQo+IA0KPiByZXN1bHRpbmcgaW4gbW9yZSB0aGFuIDJ4IHNwZWVkdXAuDQo+IA0K
PiBObyByZWdyZXNzaW9uIG9ic2VydmVkIG9uIDRLIGZvbGlvcy4NCj4gDQo+IFBlcmZvcm1hbmNl
IGFzIG1lYXN1cmVkIG9uIGJhcmUgbWV0YWwgeDg2Og0KPiANCj4gVmFuaWxsYSAtIG1lYW46IDU0
OTg2Mjg2IG5zLCBzdGQgZGV2OiAxLjUlDQo+IFBhdGNoZWQgLSBtZWFuOiA1MTkzMDc5NSBucywg
c3RkIGRldjogMyUNCj4gDQo+IEkgdHJpZWQgbWFnbmlmeWluZyB0aGUgZGlmZmVyZW5jZSBvbiB4
ODYgYnkgdXNpbmcgMU0gbGFyZ2UgZm9saW9zLCBidXQNCj4gY2FuJ3Qgc3BvdCBhbiBvYnZpb3Vz
IGltcHJvdmVtZW50IChsb29rcyBsaWtlIG15IHN5c3RlbSBpcyB0b28gZmFzdCB0bw0KPiBiZW5l
Zml0IGZyb20gYmF0Y2hlZCBhdG9taWMgb3BlcmF0aW9ucyEpLCBoaW50aW5nIHRoYXQgdGhlIGJl
bmVmaXQgbGllcw0KPiBtYWlubHkgaW4gdGhlIHJlZHVjdGlvbiBvZiBwdGVwX2dldCgpIGNhbGxz
IGFuZCB0aGUgcmVkdWN0aW9uIG9mIFRMQg0KPiBmbHVzaGVzIGR1cmluZyBjb250cHRlLXVuZm9s
ZGluZywgb24gYXJtNjQuDQo+IA0KPiBObyByZWdyZXNzaW9uIGlzIG9ic2VydmVkIG9uIDRLIGZv
bGlvcyBvbiB4ODYgdG9vLg0KPiANCj4gLS0tDQo+IEFwcGxpZXMgb24gbW0tdW5zdGFibGUgKDI0
MjMxNTk2ZWRmMikuDQoNCkhpIERldiwNCg0KTW9zdCBvZiB0aGlzIHNlcmllcyB0b3VjaGVzIHJt
YXAgYW5kIGNvcmUgTU0gY29kZSwgd2hpY2ggbm93IGdvDQp0aHJvdWdoIHRoZSBuZXcgTU0gY29y
ZSB0cmVlOg0KDQpUOiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvbW0vY29yZS5naXQgZm9yLW5leHQNCg0KU28sIGl0IHdvdWxkIHByb2JhYmx5IGJlIGJldHRl
ciB0byBiYXNlIHRoZSBuZXh0IHZlcnNpb24gb24gdGhpcyByYXRoZXIgdGhhbiBtbS11bnN0YWJs
ZS4NCg0KVGhhbmtzLA0KU2hpdmFuaw0KDQo+IA0KPiBtbS1zZWxmdGVzdHMgcGFzcy4NCj4gDQo+
IFRoaXMgYnJlYWtvdXQgcGF0Y2hzZXQgaXMgdGhlIGZpbmFsIGNvbXBsZXRpb24gb2YNCj4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwNTI2MDYzNjM1LjYxNzIxLTEtZGV2LmphaW5A
YXJtLmNvbS8NCj4gDQo+IFRoZSBleHRyYSBhZGRpdGlvbiBpcyB0aGUgZ2VuZXJpYyBzZXRfc29m
dGxlYWZfcHRlcygpIGhlbHBlci4NCj4gDQo+IHYzLT52NDoNCj4gIC0gTWFrZSBwYWdlX2Fub25f
ZXhjbHVzaXZlX2JhdGNoIHJldHVybiB0aGUgZXhjbHVzaXZpdHkgaW5zdGVhZCBvZg0KPiAgICBj
b21wdXRpbmcgdGhhdCBpbiB0aGUgY2FsbGVyDQo+ICAtIE1ha2UgdHR1X2Fub25fZm9saW8oKSBy
ZXR1cm4gdGhlIG51bWJlciBvZiB1bm1hcHBlZCBwYWdlcywgdG8gc2ltcGxpZnkNCj4gICAgdGhl
IGNvZGUNCj4gDQo+IHYyLT52MzoNCj4gIC0gcGFnZV9hbm9uX2V4Y2x1c2l2ZV9iYXRjaCByZXR1
cm5zIHVuc2lnbmVkIGxvbmcsIHNoaWZ0IHRvIHJtYXAuaA0KPiAgLSBEcm9wIGEgcGFyYSBpbiBk
ZXNjcmlwdGlvbiBvZiBwYXRjaCA1LCB1c2Ugc29mdGxlYWZfaXNfc3dhcCB0byBnYXRlDQo+ICAg
IHB0ZV9zd3BfZXhjbHVzaXZlDQo+ICAtIGZpbmlzaF9mb2xpb191bm1hcCAtPiBmaW5pc2hfZm9s
aW9fdW5tYXBfYmF0Y2gNCj4gIC0gQWRkIHBhdGNoIDkgdG8gZG8gYmF0Y2hpbmcgZm9yIHNwYXJj
DQo+ICAgIA0KPiB2MS0+djI6DQo+ICAtIEFkZCBXQVJOcyBmb3IgZm9saW8gc3BhbiBpbiBmb2xp
b18qX3N3YXBfcGFnZXMNCj4gIC0gVHJpdmlhbCBjaGFuZ2VzIHRvIHBhZ2VfYW5vbl9leGNsdXNp
dmVfYmF0Y2gNCj4gIC0gQWRkIHR3byBzYW5pdHkgY2hlY2tzIGluIHBhdGNoIDQNCj4gDQo+IERl
diBKYWluICg5KToNCj4gICBtbS9zd2FwZmlsZTogYWRkIGJhdGNoZWQgdmVyc2lvbiBvZiBmb2xp
b19kdXBfc3dhcA0KPiAgIG1tL3N3YXBmaWxlOiBhZGQgYmF0Y2hlZCB2ZXJzaW9uIG9mIGZvbGlv
X3B1dF9zd2FwDQo+ICAgbW06IG1vdmUgYW5vbi1leGNsdXNpdmUgYmF0Y2ggaGVscGVyIHRvIHJt
YXAuaA0KPiAgIG1tL3JtYXA6IEFkZCBiYXRjaGVkIHZlcnNpb24gb2YgZm9saW9fdHJ5X3NoYXJl
X2Fub25fcm1hcF9wdGUNCj4gICBtbS9pbnRlcm5hbDogcmVuYW1lIHN3YXAgb2Zmc2V0IGhlbHBl
cnMgdG8gc29mdGxlYWYgb2Zmc2V0DQo+ICAgbW0vaW50ZXJuYWw6IGFkZCBzZXRfc29mdGxlYWZf
cHRlcw0KPiAgIG1tL21lbW9yeTogdXNlIHNldF9zb2Z0bGVhZl9wdGVzIGZvciB1ZmZkLXdwIG1h
cmtlcnMNCj4gICBtbS9ybWFwOiBiYXRjaCB1bm1hcCBhbm9ueW1vdXMgc3dhcC1iYWNrZWQgbGFy
Z2UgZm9saW9zDQo+ICAgbW0sIHNwYXJjOiBiYXRjaCBhcmNoX3VubWFwX29uZSgpDQo+IA0KPiAg
YXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9wZ3RhYmxlXzY0LmggfCAgMTAgKystDQo+ICBhcmNoL3Nw
YXJjL2tlcm5lbC9hZGlfNjQuYyAgICAgICAgICB8ICAyMSArKysrKw0KPiAgaW5jbHVkZS9saW51
eC9wZ3RhYmxlLmggICAgICAgICAgICAgfCAgIDYgKy0NCj4gIGluY2x1ZGUvbGludXgvcm1hcC5o
ICAgICAgICAgICAgICAgIHwgIDc2ICsrKysrKysrKysrKysrLS0tLQ0KPiAgbW0vaW50ZXJuYWwu
aCAgICAgICAgICAgICAgICAgICAgICAgfCAgNjQgKysrKysrKysrKystLS0tDQo+ICBtbS9tZW1v
cnkuYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyMyArKystLS0NCj4gIG1tL21wcm90ZWN0
LmMgICAgICAgICAgICAgICAgICAgICAgIHwgIDI1ICstLS0tLQ0KPiAgbW0vcm1hcC5jICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAxMTkgKysrKysrKysrKysrKysrKysrKystLS0tLS0tLQ0K
PiAgbW0vc2htZW0uYyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDggKy0NCj4gIG1tL3N3
YXAuaCAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDM1ICsrKysrKystDQo+ICBtbS9zd2Fw
ZmlsZS5jICAgICAgICAgICAgICAgICAgICAgICB8ICAzOSArKysrKy0tLS0NCj4gIDExIGZpbGVz
IGNoYW5nZWQsIDI4OSBpbnNlcnRpb25zKCspLCAxMzcgZGVsZXRpb25zKC0pDQo=

