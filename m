Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6E0606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=fo+8Nqbl
Received: by kanga.kvack.org (Postfix)
	id 69A6E6B05BA; Mon, 16 Nov 2026 09:25:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6724F6B05BB; Mon, 16 Nov 2026 09:25:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561406B05BC; Mon, 16 Nov 2026 09:25:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5D06B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:25:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD88C40118
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:25:26 +0000 (UTC)
X-FDA: 85441205052.16.397BC07
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf10.hostedemail.com (Postfix) with ESMTP id 064A5C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:25:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=fo+8Nqbl;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf10.hostedemail.com: domain of "prvs=7730490a4=graf@amazon.de" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=7730490a4=graf@amazon.de";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794839123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Y/W+T3mQYr/h4OdDSuI0AlR+5U4+rDF+oH/5ePJ4zU=;
	b=Ud+SmCWJguMs/5/R4Aj23ZMxv0YRipuU6nQQ5rM8GFcvOEtroyJ1qdNzTEs60i0bDriTPr
	QnfnHTXspTUJeHZ9x8CaN08dqhDxAKOKMW2Ydmlrt/RKZmbs2ZrNKTBBWMMOs1/0nLD+uJ
	xl9JkafFH9SrYqNoyKdqMSGNAs4xHxM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=fo+8Nqbl;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf10.hostedemail.com: domain of "prvs=7730490a4=graf@amazon.de" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=7730490a4=graf@amazon.de";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794839123;
	b=n0nR7J0oGbYKJWIoc0KVGbpALVEUjcdtvpy5aDbsoPySsawS1EICvtdnNH1TEeXDuMQQIu
	8ifFQ1N2s45Lzc+1xWdjomyy5Gmt8Gzz0vR82gir4qx6ut+JCrOYzJq3oXpV1gSwXH3JEm
	VflkEhBhzCOvf8hGVtPryHekVjxpaqw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1794839123; x=1826375123;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7Y/W+T3mQYr/h4OdDSuI0AlR+5U4+rDF+oH/5ePJ4zU=;
  b=fo+8Nqbl0ojXbmOwk4L56LQsQRQYm5ywF/MdSkGp+osEOLYyhb+kwREQ
   iGAU5VbAnr+n6KEyqyxWJMKb7vFhHewl12kudUWZSHnvNVNNsdZN/se1V
   6zExJ8XPNY/ECn+/iJQRFH4s1aWjwBYZNi6R3bJPgUSZMa4of3kB0y9wn
   kZ9jhL/LZTq9gB0lhqWQ+nxMYpJ+ixLrGIQcqRYW9tLrZq+GDIsi36ZFf
   47gyemTNyl1KDz/kh4q4J7IqTXvrcvE7oGy3ZZpVqGuHK0WuWH13U9/nf
   uPo9b+q+JrXIb32tj/JKIMPzjBT2cNDYmCCdWTe7DpU6vO2Dy2mPNzdmF
   g==;
X-CSE-ConnectionGUID: JVhUv8eyQ2GJSvdP8mXovA==
X-CSE-MsgGUID: OsVPV1SyQMCURvXVOftPFw==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="22880647"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 14:25:18 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:11664]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.36.162:2525] with esmtp (Farcaster)
 id 28e45152-4665-42ea-8316-556d2be5ed7c; Mon, 16 Nov 2026 14:25:18 +0000 (UTC)
X-Farcaster-Flow-ID: 28e45152-4665-42ea-8316-556d2be5ed7c
Received: from EX19EXOEUC002.ant.amazon.com (10.252.51.145) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:25:17 +0000
Received: from EX19EXOEUA002.ant.amazon.com (10.252.50.139) by
 EX19EXOEUC002.ant.amazon.com (10.252.51.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 14:25:17 +0000
Received: from BEUP281CU002.outbound.protection.outlook.com (10.252.50.44) by
 EX19EXOEUA002.ant.amazon.com (10.252.50.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56
 via Frontend Transport; Mon, 16 Nov 2026 14:25:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDnT1fDpnfuGb4VdnRRbRdO7yO4uipZ5kj2QUDQk6WbJOHzIFNp7Ql2eSu6whJB6hfQ290Cz+nIdhRkJq5gfeKSDOvXm9xWmRymMgLN0/TiM9ebKpd1ppELyccEtGy+tblaizbcoPKxFYFRj1TPz+5rnDzN9PEd6W0HWdddP2cVYllbECLY9OKJ1sCuam2Qq8xI48inmYOxQ8fEIhM6in6ogTD6AAWKH73wX0SrmJghVjYGPXchA8c1aQiu9+TxfYdCP2mA/P3L0AyJw9i9wOj1NyyjSsYCMk4OQyLX4ynZKP/kra3HDhTgvFrqNu/UavNL8KVaan90HdEUAMNnEUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Y/W+T3mQYr/h4OdDSuI0AlR+5U4+rDF+oH/5ePJ4zU=;
 b=a1RP2ppt2/CnaATFicaCOLkNYaA8SD134ClgeU7Edf0pcpiEmtMoCsHmohhSaye5hYWFveTk3uAGabOGl4IrgiEiH/u+i3IS7fvlJeY5asoyKHIEZ0ev0QE7Bwm6c0e+EbKbxLRvcMqPBumBDkCVJFZb+v3e9MnGg/uy7Fop9mA38kzNH2U+7bFOWOoYIACbTavL8SavqD4w9Hws5z5QhP+OZwyXyCAbolFnJMmM5o2pHfU7UrqjG5pNCdS5qZx07WhLOZEI1uaG6Kn/tGu5C6eFV6frpNCh404kTh4BUNM+FT/JZVX9PPWRvZp3OP1R7jFe02ioJA1app0EnLNclQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:20d::13) by FR5P281MB6289.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 14:25:15 +0000
Received: from FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7b1c:7a5d:c405:6c4d]) by FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7b1c:7a5d:c405:6c4d%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 14:25:15 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 05/40] dma-contiguous: add dma_get_numa_cma_area()
 accessor
Thread-Topic: [PATCH 05/40] dma-contiguous: add dma_get_numa_cma_area()
 accessor
Thread-Index: AQHdci4rOtGOjUeI40aBT+WSWM89XLcwrUyAgAAa7gA=
Date: Mon, 16 Nov 2026 14:25:15 +0000
Message-ID: <021dc899-3e57-447d-851a-ae05529e2a43@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
 <CGME20261111224311eucas1p1eb735607894271094a8934b187647ad5@eucas1p1.samsung.com>
 <a1294df95fbe0a2ef5cc3585824d396854c7242c.1794393490.git.graf@amazon.com>
 <2be89ecd-2809-4182-b2c4-df062fcf68b6@samsung.com>
In-Reply-To: <2be89ecd-2809-4182-b2c4-df062fcf68b6@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FRVP281MB744463:EE_|FR5P281MB6289:EE_
x-ms-office365-filtering-correlation-id: c989bca7-6d12-43b8-0559-08df43ed6ee6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|38070700021|4143699003|11063799006|10067099003|56012099006|261022075727099003|261021135927099003|261021121427099003|261021123027099003|261102124227099003|261102123227099003|261009223027099003|22082099003|18002099003;
x-microsoft-antispam-message-info: CgynSsyirAt7IH8rzgI7UUX/QiZA0oTi1GU/GMTZXtnRjAKoI+we92PN+0MIcKNDgHGIlu3+K6aLjtY2UGPUCVSLVC1yCN6MN2WKZlL4DvADqbBoON74FIgSTZeJUWAEi3shIW9WkXh8/54E5w2j61K+5UTPY4Hsl5j3Qc2IgN79aJxHBKD7IKql6NXhpOVOXoMhZcdO6EpNlw6Gj8c9bQ3r3vvB88cAaqDm/eqBFMkDXyDOdjvL4iIEwFNrtgNVOpD0IhxPmMwGwNdIQNwmkLjccCcBeQQYgShrTww16SMf3H2s+fQ3T6ZcvhCF7656W4GzG3dVa7Q15Gqxu0iJEis2/5CXtKpUiUZmOmGDxXHGK8W+SQTvnZDx7XtmRPLAdOqNXAWnqVCG58jSSdq/VEOSmp0e+mdRHq/jSIaLZ503gt/9QhAFYxBqkU2IBhz6hBGASO+DtRka68eue7MQM4ZQT8hRxrC6O8qdYeSENqAGyQwT+6BE8wGB6WeKEXhovqyfekf9Ql3Wk1I0UMbv7DJKo9llvg6XMLyuIABJ8OjKYTS5/F8lklEkLAUustfLQlbDnJgrKx1P6pjWfk3WJf7KSR/Qm1A6VRSQj3qltivYW7IhgKRFvHz4VW1DbEm5u4m1senNG6EE+XSokvMcb/2rU4XxImLu4h0UOzHI15U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(38070700021)(4143699003)(11063799006)(10067099003)(56012099006)(261022075727099003)(261021135927099003)(261021121427099003)(261021123027099003)(261102124227099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODNtaGdHT09MTEd3dC9wVVU1U0pWanp3L2Q0VTZOMXBBOTJUM05KQzJqUno3?=
 =?utf-8?B?b05pSThCdTBzQlBYYTduR1Q2dXY5UGxueks4VlBWcisrTXk5T3NHMnF2YXN3?=
 =?utf-8?B?aWJ4UjgvVHJRM1d5eVVRaE5Eb3NQKzhTSHJZNnhGTzVUdi9vNmVzME5tMzFi?=
 =?utf-8?B?dFNQRURBUnEwRURYMnJqQU9YSkF3dzlLVHVMa0hEOC9DanlEckVueEo1Ym9C?=
 =?utf-8?B?Q1hVVzZtQlc0czN3U2crbXVSbWJ3SlBPWGdOOFB5VTFRcGl5clBhVFhtRkRX?=
 =?utf-8?B?Mi9BN29uekp0YVV6VGxRTkFYUXRmNmdEQWxLNE03SWpDWWo1NmVqYVA2MjNs?=
 =?utf-8?B?em9HNlMzL21TbTE0bG5SY1FmbEN1WEExK3BaWHBWU3VYVEJ5VEJxdzdvbDZB?=
 =?utf-8?B?eFFDYUhuYjFKR2h6Q2tXcVA2bGt5bnlpY1ZieThPVHBwSTRzRGxQYXphOEZJ?=
 =?utf-8?B?WVdkalFxZWgzTTR5a3ZIdXlMajlSYUFPKzkxbFdLU1NkeW5UV09HNkppMlZa?=
 =?utf-8?B?YzR6akV2Z1lkME5ZdlhYbmtFLzVOeDBVSEN3WkFsU3JBVzZoaHVwRXIzQ3VG?=
 =?utf-8?B?WlZKbmFNMmFSMkdvSTk5VjVzQ0NDNXBOSEJPWjczL3ZZN1FYUUpmTWdaMG5H?=
 =?utf-8?B?NXIrVWZZald4Vk50U0h6UW56SXBGUThIVGoyM1k4aU1JSElwQ0lFZ1pCMit5?=
 =?utf-8?B?NmVjbVFBRW5PVWphMmZudXhTMUZ3UUVLRnd2VlNhTjczZjJZalpYY2l2eFJO?=
 =?utf-8?B?REJUcmdMMmh3QTJrY3hrZnluVmN2VTZLdjlpYU5mRUJvc3Q2OHhjRFhoY2VC?=
 =?utf-8?B?OE1rRWpFM05lNC9KMytpLy9GN3NBbml5WW9CWTNQTXBmZEVZY1krV0xyVmwr?=
 =?utf-8?B?S1hudFdTdlY3U1g1ZjYyYWNNOFhaWGRkNDVoN1ZTaDdvL0cvZHNQVFBDWWFT?=
 =?utf-8?B?c1lnRDd6SUtrcWVWNlBnT0c4M1huNE10YkxaSWVZQ1NNVDJYUnpuVmNJcVRY?=
 =?utf-8?B?TnVjdWVjNEFRUi8xTFpmT3MvNWNRVDlsL1BxQmhLcGsyUExCWHZZTE91WWJJ?=
 =?utf-8?B?akdFVDV0VnhsT0MzVllybGwxK004NXVGamxEdVNBNStvTlZpRldoRm1YaytG?=
 =?utf-8?B?Sld5VXhaTVk1b2dhbGtSTXF2Q3ljLzlSYmFvWmdJNExNSmtwL1VSTGlUMmVE?=
 =?utf-8?B?dFlQT3N3aklHZE9UbzRVNDRxUGhENG5xbmxOejl6NytOang5dWQxb3FMRDJk?=
 =?utf-8?B?QmhJbEN4TFFRQTgxQlE3VnZ3NS9WNkVIMDNYRnpaemFjMHZ1VjAxM3hWM3E0?=
 =?utf-8?B?K29RR3E0YlhKSHp5dnE2cXRuNjVGaWwwQms5R0NKUVBJekkvWlJEeDBRUmc2?=
 =?utf-8?B?TFBLdVJkVTF1NGpLNzlSd1pCaStWUkNvZG1Uc1NrUG1Bei9EbnNMT255bnVC?=
 =?utf-8?B?V1lYWE5zUkY5dVBvbXE4SHNUU0YraThOSDNyK1hxVk5KQWVWekdUaXd2eFZR?=
 =?utf-8?B?M3N6TUpYR0FRU0s4WTlSL2g1REtuWmVrT2t4Y3RWdUlxTWwrOTJkc2NoRXc0?=
 =?utf-8?B?am4wNTJaQWREYUxOZEhrU3NJaU10cWJjbzAyaFg5ZGFKWmlJSlZLRWJQUlli?=
 =?utf-8?B?NDBQUVkvY1BjOE9zUW1RTGV5MEpDU0NiVjVFMlArbW9mK1ZZWnJYMmovc3hr?=
 =?utf-8?B?SDM3VzZwa2o2M1ROTUFFM2lvbWZlNzg1bVQrZDZTa1JFb2RBb08xckRsbG5G?=
 =?utf-8?B?ZWdsOWZDY1l0T0VSVHQ3MmZtTGZGZHhzMG1SaTc0MGNrUlM4VDlEOXNVUjNN?=
 =?utf-8?B?Qk53c1V1NDlNQmRtVXdWNjRhSnFkK2ZWMzFQMmxLbC9wZGdKKzg1RFdZc3NV?=
 =?utf-8?B?M1IrTDdFZXozRjFiK2tvWGFVT1pqWE1ocytqNjh0b0oxM2FTNWZQQjM1S1Zw?=
 =?utf-8?B?Yk51ZW5MT2JEenVXNzJPMGx5eFg3UVRRRzdvdDd3bC9TS3gwWWtsWk5ITEow?=
 =?utf-8?B?TFJkcE9iTVBFR2grS0MySkVycFZubHVBcUQzdVRUTDN6dmw1b0lvb0xHcWlE?=
 =?utf-8?B?YSthWlJCZTU0Rk5vMDNhVzQ1eFBqR1ZXbll2WnJXVDBrRUJFUjhSUnNOZmdL?=
 =?utf-8?B?NmhlZ0RsZEZMT29LNmRPbzJwMWY5T0Z2cWgwc3Ftd3o3K2RvaTlXblMrSWhG?=
 =?utf-8?B?L0laTzF5MjZJak11QXJHdmhqeld5bHlnQjRaTExHeTN0VWhSWUJZV01rQWRO?=
 =?utf-8?B?bUV3emdidGZmOGV6MjdOcmRSL3Bnbnh4ejlLN2p4NzRKMVUyWVNWTytUckFa?=
 =?utf-8?Q?ZoFg4iNXR/dDpUdiUh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4ACCBB7BA83DD148AAD3EE139A9AE1E7@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: cvfEm240ZXIxry2T8ZcoXBzRoEXTOm3lkH7zr6MatQOrzVgtUB4qgzvpGsWZHy0KLrf+rVjhNZoa62NiYSxIUP2DbxpqYDVYc7NX2H41ls+GfegLuQGza/PKnV/pssTs2wJWQCkyuqIiuePOxptWNZbZaB8QE0vvKOK01qMqjrWQ62bi7kOOxSKgUmqLFlF1JAp4z8xAwsJJcdC78bHVYg162mHQp6/q93v4jHYvqIVmuZyefZuccNbAFHqAPBYLc2O57j8a+RixH20aiB7VNJ83VRxqO4AxknvlMDLitnbBqOZ/9BuQ/Zub5acV3Sd75Q3Vvd3dW9hqQEno4ydodw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c989bca7-6d12-43b8-0559-08df43ed6ee6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 14:25:15.6565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yQ99mQ0bhKCgxT8pX62165sqIHqlLi/6krR31Vk0Iu7VAmwqx4EfFyEBKS6PK/L1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR5P281MB6289
X-OriginatorOrg: amazon.de
X-Rspamd-Queue-Id: 064A5C0004
X-Rspam-User: 
X-Stat-Signature: buax5h8w8zhz8y78r9miqajbr1ykis51
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794839122-863730
X-HE-Meta: U2FsdGVkX18oXd4ZUNKSGjSJKWIJUnK+Vu3sJtLdI+HifCtrMrLFKejEFUQf6zROwo5Qe7pkqQ8rNT6jhw78L3wW8oLH54V2ILg/jRwsVTybBYuA0G4WMMuxoxSRc42zzABTOBHLTZL0m3AtjUFe7mvMw/5xMNdcJxawgaHqQOvY6XbIjYAms9+M1/WgBpzWkamBtDFKbvZUWSCKXMUdMoRIy6Y5WQzG/dfxLLIisMrivoktz6uCJAGe7slQ3Vtjo1oW/xuA+fegZAnLspt99hrwP9CwhNGlYNtPQ4rZPVFkuMpJY/Zc/yLgKFFrrjreMdCsM9IrzweNy6/fMNqnNpfuSk7QoEEHLMuZfEFKjJx0y5Sb/fJ8lHOcpupkYfHnIHNsWoLoqD1JiaYt41ykWBerz7g5ZatrSalXbGQZawz/T65wOhDR1u0hsfWJy0ugt084bxyV8cjUiotkSZhoZQi2bj3Mz5j5hfOj+yGrhNHGEUPMe1Wp4mI4Qz8HOHOYzPO+Mhg89nFYKocwQfuMmaVunts6Ud/uGC13obGuijPJ3mn+iT51iR6Ba/oY7F+nf376wtiwTnVk+6ggtTE+rNJGGhH17vj67WGax1IepUGWHoLjLg087vWMcqKb+z2swVlrAO6Gbgd9Kzm4MwvyVo1q3i4lYzu/ndeV0PTqe/Kw0CieFfR5KNRJRnHv8un5vRq55Lmq8CKnB9Xm3x3dub7BqVvh5SKnMYfj+fRDs3dVGOZmMOIXVxJbghRcXsebecmZ8KMno5+vW48gByr+9mSeNdcOU5/65UaYHeXPApRzBf6i1VTbMzdPvBaoJ8uDTpCR9BopL5ZWcU5GuJD5IkbN8IFNI361c09/mWKTNElI9TDgRMfLyC5GTJkKEWU2qyvzqmCEIJ0i+Ib7o/BFz5SdNHMyB+9+Rw7s1/ZXMw1EZFUjpWdj6et8PV0ENcC3ypTUMRu9aajkPDiaUQ4
 uwvGkQ6g
 KqHDC38rE7SimQGdEa8dP2ugOsDOryYwaN/+oD0ED1jQlrZXAfbhivKO1pHfJwreO9JCHwio2To+WUy0Xf37cj1R6K9oglK+CtnFFbSpNSOIIKKpAbYxXqyIpLtp7BrW0DzQAC6OFeiEXeUMaE/4fZcQm85m2Z09ujDDJkxZdpbX2cUV2bGyagVZevw5DWmYq0fCJm3u2kBtNddUeKHPnMlVe0CZy5lf66yFIiQfPHSP+dk6yF/0Z2n+kn+uV/Cfenwn77lwWcOr1L25tcVj0XGVRB+Hm+yvbqfKLVI4EJwCxhbizSSbZXV8+9qHwTvtfWofrIc7jQ5PXM3B8al8/lqLjfULOXkiPvJRkSy85dsha5dWsH0agMQ8sPbb+xlgCSs0rXS5IZVk4qIvtCvDxN4m4ls4LMOK592bsiGGfcV47xjC40IAxBF7VAAO2c2zopj3rALbY+HbphVUgSONCEc++RvxFQUoLguRdmuRBGri4AuaeL+7lp5ttjmoRZsq/d8qlwJqZG4AJs8MFBq+ZnHD6cLRXHoDuLC999DWjBin98STfTJFBXHDaIk5n3EwmPGM/dlhOBKLYRYfKsYRCYlG2+GwD1gjxq39p/f+m4/HHels9jvr/7XcRiY9YQY9fi/AKvGtrHj6MpWEY7ftGSK3Z/J1FYDJFnfGpkRZLpRlGPRnJ7ZxLK16mARsZCUR4cNN+fzV7TLIkcx45cAyVqto4bbuuDjYdBFqcLg1k9HfwwQapeJpRcfNdx1Vu/NfwrNyeKu8XZh4cA6W64DUhaL1FegjJwMtNlIIErzn7mjNWi++bolu/JD/g4UHSTFjKC+agp1Ja7yfkpInwdhc9VmaB1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DQpPbiAxNi4xMS4yNiAxMzo0OCwgTWFyZWsgU3p5cHJvd3NraSB3cm90ZToNCj4gT24gMTEuMTEu
MjAyNiAyMzo0MSwgQWxleGFuZGVyIEdyYWYgd3JvdGU6DQo+PiBXaXRoIE5pdHJvIFNhbmRib3hl
cywgd2Ugd2FudCB0byBhbGxvY2F0ZSBwZXItTlVNQSBtZW1vcnkgZnJvbSB0aGUgRE1BDQo+PiBj
b250aWd1b3VzIGFsbG9jYXRvciwgYnV0IGhhdmUgbm8gcGVyLU5VTUEgc3RydWN0IGRldmljZSB0
byBwYXNzIGluLg0KPj4gZG1hX2FsbG9jX2NvbnRpZ3VvdXMoKSB0YWtlcyB0aGUgbm9kZSBmcm9t
IGRldl90b19ub2RlKGRldiksIGFuZCB0aGUNCj4+IHBlci1ub2RlIGFyZWFzIHNpdCBpbiBkbWFf
Y29udGlndW91c19udW1hX2FyZWFbXSwgd2hpY2ggaXMgc3RhdGljLg0KPj4NCj4+IFNvIGluc3Rl
YWQsIGludHJvZHVjZSBkbWFfZ2V0X251bWFfY21hX2FyZWEoKSwgd2hpY2ggcmV0dXJucyB0aGUg
Z2VuZXJpYw0KPj4gcGVyLU5VTUEgRE1BIENNQSBhcmVhIHRoYXQgY21hX2FsbG9jKCkgd291bGQg
dXNlLiBUaGlzIHdheSwgdGhlDQo+PiBuaXRyb19lbmNsYXZlcyBkcml2ZXIgY2FuIGJ1aWxkIGl0
cyBvd24gZ2VuZXJpYyBDTUEgcG9vbCBwZXItbm9kZQ0KPj4gYWxsb2NhdGlvbiBsb2dpYyBvbiB0
b3Agb2YgdGhvc2UgcG9vbHMuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZGVyIEdyYWYg
PGdyYWZAYW1hem9uLmNvbT4NCj4gVGFrZSBhIGxvb2sgYXQgdGhlIGZvbGxvd2luZyBwYXRjaCBh
bmQgdGhlIHBhdGNoc2V0IGl0IGJlbG9uZ3MgdG86DQo+DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FsbC8yMDI2MTEwNjE4NDQzMy43NjE0MjItNS1rdWJhQGtlcm5lbC5vcmcvDQoNCg0KTmlj
ZSEgVGhhdCBsb29rcyB2ZXJ5IG11Y2ggbGlrZSB3aGF0IEkgbmVlZC4gVGhhbmtzIGEgbG90LCBs
ZXQgbWUgdHJ5IA0KYW5kIHNlZSBpZiBJIGNhbiBiYXNlIG9uIHRvcCBvZiBpdCBpbnN0ZWFkLg0K
DQoNCkFsZXgNCg==

