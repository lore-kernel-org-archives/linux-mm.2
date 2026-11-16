Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7320E606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=BErfRCzt
Received: by kanga.kvack.org (Postfix)
	id 52BB56B05B2; Mon, 16 Nov 2026 12:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5030A6B05B4; Mon, 16 Nov 2026 12:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB876B05B5; Mon, 16 Nov 2026 12:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BABA6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:05:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19813C01E1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:05:04 +0000 (UTC)
X-FDA: 85441607370.08.DAEEBD7
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 201E1100012
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:05:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=BErfRCzt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of "prvs=7730490a4=graf@amazon.de" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=7730490a4=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794848701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfmO5nc8bFnllZYFtlnpduFp+XZbVbOsMGS1Go5TJ2Y=;
	b=PuYK46/4rcFpjdMXf3a7yqgkSuO2CrE17cMRR1Z+zIiudayYmLPjxHf1yUIvuV92xy6zr8
	uWpSwDReR0fIvqhGdSkrwe+7LDj/z5smBeT5O2Qzk6vVnhJeLsSwhAaU/XXcMabRZiK/j+
	ymvVjpRljke/7mpJAMCQ0kckm63OJwM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=BErfRCzt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of "prvs=7730490a4=graf@amazon.de" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=7730490a4=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794848701;
	b=zDua3+oTAOfe3iebW5NwYt9CjEPYXy+4JXagM/XXPG9uGF+iM/sMXM4d7XvXW48O3sTT67
	PMLUNhjL2dGxpYZsIwdV9VUYaXcr6WL94MT7t8ZaGQG1XRZYB39lSjJVxLXGVj67N3v3Nw
	61jiBrn/vMfl4/U4+cVp4pElGnulL58=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1794848701; x=1826384701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kfmO5nc8bFnllZYFtlnpduFp+XZbVbOsMGS1Go5TJ2Y=;
  b=BErfRCztaoZ2S6VcmZDTO9QP024KyFMTYYdJB1wxfWe7nbartKLTVHDe
   cz5Q/QkQ1TFPUI6+4Msqmb7ju+WoZnXtzrl9UcIxnVyQ/LxuM1mUpxWiU
   4WdBbVXiYOq2g/2IYTAxoEGS/dj1aWpybFI7TNZ6zI+M4DXdTQ0dRfpPX
   Z9KuC5ULtXULBR2yFvrOP7lgNOQTJrFfbB/ji3QFs3BhKWFpbunmfU61j
   e3sTuusRV17eXoR8PULdJhBYbnoj0ENv79lPULkIIJmbJ/ySQ5UQ+GvnD
   3vELeavkt9P+fIJ6gkoymPBrN6E8Wpi+sNUL6AApikVqg1kLMzQ6z6dzg
   g==;
X-CSE-ConnectionGUID: cr/qR+TOQkqd2yEE6rEghw==
X-CSE-MsgGUID: uHCuUU5VTdCSi6LMTm7yOg==
X-IronPort-AV: E=Sophos;i="6.27,217,1787011200"; 
   d="scan'208";a="22988172"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 17:04:52 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:20705]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.24.78:2525] with esmtp (Farcaster)
 id 5eaca2f1-9126-413d-b604-23774c230cdf; Mon, 16 Nov 2026 17:04:52 +0000 (UTC)
X-Farcaster-Flow-ID: 5eaca2f1-9126-413d-b604-23774c230cdf
Received: from EX19EXOEUA001.ant.amazon.com (10.252.50.110) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 17:04:52 +0000
Received: from FR5P281CU006.outbound.protection.outlook.com (10.252.51.94) by
 EX19EXOEUA001.ant.amazon.com (10.252.50.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56
 via Frontend Transport; Mon, 16 Nov 2026 17:04:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NNHfVqvNCbf4Jlpk5h+XmDCzOYFCOZ35XDRN2rVwL5vMcBkGkFoP1Yl3Z/MBicNBO3wxXO3rtwyfUHUwKgc2Xf9d9T3MJvGZ5tQMLthWx/YI4LMNhnrQRp3WT8a/weY0m+Npr/uPNd1oLEhhAG/BCBIQvVtUOya1Djx8NqRPHoyJo+elsq6XtIbvdCL4DkUBLXz8gr+hi1G24Qobario8GH8hzBtc44o5n8V9Hat0+uXMLCxqkbX63ZBKzXlo+Cy9kUm1EGEDMkPsM2eGg5NNyiaueBJ4ak4GC/rArVZljJRWGsYmrnb2hwGkXDKm5fbwEVnapsul7kRgbCSkpwxig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfmO5nc8bFnllZYFtlnpduFp+XZbVbOsMGS1Go5TJ2Y=;
 b=gmfSINkU1vHgwZQdiyB0/oZ/ZGBLX3+m2tG6vnISM5QyRi2IHZqeBXsYTXnsp4tszebiCQ4zVl1em+3TASlChWque8ic6nqS65OiGHoylGImdxg0Rltl1co0qK8aehSmvs87u4IGnTTb2+TZxpSFCdgJZQQzZbBLdj+Ha9z8YRSqXpOVCMb3oRPxxXHn8Y9cXUl+/xQ9kmw+Ru9rFDqnPl5XBs/I4Q0AIyl4Tlf33+fosN53ZsmB5vCIlUN54UAeuRQQwPml5582ZWUKK4g19UOgdabEtU8oF1b4pX63qoeSHaqMJ/yNUAegQ2pe5b+p/xp+wsnMuKj+/Pj7gN6jLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:20d::13) by FR3PPF061F5055B.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d18:2::108) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 17:04:48 +0000
Received: from FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7b1c:7a5d:c405:6c4d]) by FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7b1c:7a5d:c405:6c4d%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 17:04:48 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	"Robin Murphy" <robin.murphy@arm.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 05/40] dma-contiguous: add dma_get_numa_cma_area()
 accessor
Thread-Topic: [PATCH 05/40] dma-contiguous: add dma_get_numa_cma_area()
 accessor
Thread-Index: AQHdci4rOtGOjUeI40aBT+WSWM89XLcwrUyAgAAa7gCAACyTAA==
Date: Mon, 16 Nov 2026 17:04:48 +0000
Message-ID: <c33cf6c8-99f0-4473-9509-97c4f98f1370@amazon.de>
References: <cover.1794300002.git.graf@amazon.com>
 <CGME20261111224311eucas1p1eb735607894271094a8934b187647ad5@eucas1p1.samsung.com>
 <a1294df95fbe0a2ef5cc3585824d396854c7242c.1794393490.git.graf@amazon.com>
 <2be89ecd-2809-4182-b2c4-df062fcf68b6@samsung.com>
 <021dc899-3e57-447d-851a-ae05529e2a43@amazon.com>
In-Reply-To: <021dc899-3e57-447d-851a-ae05529e2a43@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FRVP281MB744463:EE_|FR3PPF061F5055B:EE_
x-ms-office365-filtering-correlation-id: 6a7f0a5f-f4cd-4169-be47-08df4403b8b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|261009223027099003|18002099003|22082099003|261021135927099003|261021121427099003|261021123027099003|261022075727099003|261022105027099003|261102130727099003|261026121527099003|261026140227099003|261102124227099003|261102123227099003|261028144727099003|11063799006|56012099006|10067099003|4143699003|38070700021;
x-microsoft-antispam-message-info: qQb4ZhljyDeiFIfSMwsiOwvB69d7fJRkkO9EWCyvuOo9ZjHJBO4b3ckNMncMhT4sZz/VBljr6S/QzNQsamoYFVxYELXzrN54Xx2Kbpfhrjy7S+xOpKjpl67Z1kzMgUONlehxomwHznY6Of+H2BLyz0fukI/JilEBNxVBctIRIWZEUA5VAyfqlG2SHmeZD5cMC6MSccgoewlDN8eqHcGZsys7NlR3q0NoQ0FPDxfqZio5ywTaIbrkP/IZnQuL4YsM0lrVSMqE6K3z4moo5oDauIVFpEAlF4TXAXM1NxjD/hLhJlbtqDI3kOmPcJN+zjd7AW/ObuASYX5LG7sHwvJ/s4VP5EfJxEWgrKglVQ8uldGVfp5aHSgX6f7E7S6qA8Lg98YIDUKHQB+kYmkbzKM6w1vnSiZnfoamHD2260q627sE3eq9j/vXCA4YOui8TvGdtYMZy3lDE5wdoJMxqBlpwHosRTXSWsFtvDJ3TaJWcnkjwdEFTOgvlbskb4oyP84RwAOf7lppRvnTJnRqAoKU5AsxJJui3OApX8707drrtnkpG53hnAFpdpfmizvGj+tk/Lsw+Rvqit35T+YblQsb8NjQUkc8ypSL59O3rjlwD4WGnYWe4uc/qesJHL1ytB05rwzA2eR4s/cPSj/H30Mx0RoUs/V92uyl3aBThV9DI+I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(261009223027099003)(18002099003)(22082099003)(261021135927099003)(261021121427099003)(261021123027099003)(261022075727099003)(261022105027099003)(261102130727099003)(261026121527099003)(261026140227099003)(261102124227099003)(261102123227099003)(261028144727099003)(11063799006)(56012099006)(10067099003)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGp5Y2dORGk2UnVnbXJPZnQ4NzJJREoyYXlaSzNqZURSZ25VaHVSMThaMDYz?=
 =?utf-8?B?Z1E2bENpUTRwUEY1SmQxNDM4Tm56U1VCTE9kSm0vd250SzVIcVY4bUV1TTFL?=
 =?utf-8?B?Wmx4S3N5T3B3UmhWZ3pIVWswdFJxcmZOQmtGcU1rOThXUWs3WTZLcmJ0d1pr?=
 =?utf-8?B?d3lqNWNVdmNHZUx1WmV5UWdTaTExUkZ3NnNRN1ArVHdkS2JPRDRyZ0FCTDVV?=
 =?utf-8?B?d3FkYmRSR3hCemRkVWN2MUE2ekUva1BxZUh0N0Jtc0VWRG04dDhhQTBuK011?=
 =?utf-8?B?Tis3bDMrL2I2M0dMekZ5UVdWckFyTnR4SEZUSzdsNG5YQ25MeVBsWUNibkRS?=
 =?utf-8?B?OGhFSUs3RTYzNFhDM05aS1ZDSWpGYXcyQVRyZlVFaUJWNmVvb2x5WlJMNGM0?=
 =?utf-8?B?eDk2VTZxM1R1VUU3RXRiL2YxZ2hrM1A3OC9xV1BsOEY0VlRkcmtFNng5Q0t3?=
 =?utf-8?B?dVVMckdKSkV1Y285algwZE43K1hwdGs0bTAxcyt1L1o0V1kyclptUnBlRFQ4?=
 =?utf-8?B?WlNRVENKZGVsQWtleStEcEl2djZpenE1RU91MGRNeC8rVjZJWUhxRmlVbmVV?=
 =?utf-8?B?Q0VQUVJLbFpkVWhTbVlrZDkxYXd6MXFkRXJPRHlGbEFIaHphVTh4NVR6OW85?=
 =?utf-8?B?YVFsTmZhdTJTL2htOWd6OEJqcmdwODlmbXZwbG0yajlDZmt4WVFxR2lkYVVk?=
 =?utf-8?B?a3EvdFJVT3FxS3k2aW1lT2dPVnpMWHl2R0lJREdRdmNBdWc4bVk3akJoRlQ2?=
 =?utf-8?B?R1M2Q2RhTldDcklIOUxQTHB2N1plTmdaT1NBWkJhOC9DSmVKYXVXRkVlS2hq?=
 =?utf-8?B?QUR2VUZMYndnRUxBOFJoSEhEMDZBQVN3RGE2ZVJoM2svUDVaRXhFWktRTFJh?=
 =?utf-8?B?K2ppOTJGTU1uOFFNckU0dDRGbW52UXlNNTZkRnU4TTJhZktoQ2VsUVJQNVdP?=
 =?utf-8?B?RFFZUlVZT2YzSW9IRXJJRzhhYzNKTTQrR1V5VEhENjhqMTBjcjBaaW14K2lJ?=
 =?utf-8?B?bG1vN2lsNXkxaDc1czZlYzBTM1VtOWUyUTFQRlRYcWM1WTVMQkF5OVZxeVBX?=
 =?utf-8?B?dFA0Mnd0RWljblNPdUYvRXA0bTlGd2dheVNDemZUVldXWHVPc1dFWGI5T0No?=
 =?utf-8?B?WjBRMEhpNTAzWXpjQlBLbjJ0QW5YS3A3bEtCaGNwdkNqV1VDUWxveTZGVVE4?=
 =?utf-8?B?cDg5Y3JTVUh4WExvMXYranB2UW8zU3NOVStCdWF3NVlXb0lYTWxGWVhVTXdE?=
 =?utf-8?B?RzJCbEFEK0l5UlR3Rk5TNStIQWhQMmY4bnJXbzlSYTlOaGgvQk9nMFFkMk9T?=
 =?utf-8?B?Nm1BQWpGNk8yUVdxa2NsR0R6KzRnM0h3a2N5MTFjZzM2Uzd5VG9EQVladmlU?=
 =?utf-8?B?QzZwblUwVHdMTS9KY0IyVDNXUFBiVElwbktBU25QN2F1TGdDOW5QZ0dkYnlu?=
 =?utf-8?B?RFhGaWJDcmJ5eFdGanIvdkhGTE9RamRNKzUraFlIVXk4NmxneXJRM1ErUVVT?=
 =?utf-8?B?UG4zb0c5VUlBUUlFTThncmFjZVhVTklUNjErYkxoSzhMbGNVV0t0THVEZm5u?=
 =?utf-8?B?MEFCU0JWWXRESm1RRTRJNWVIVGd0KzlEQWNMOHVZNG9HS29QRU5DUkJ5WXdD?=
 =?utf-8?B?b0l4VXpRR1pnTmdFYkdHRUtmcEp1TW5taXFoMExteGwwNkxQT2pnc3FKN0Rw?=
 =?utf-8?B?dEI5cGFSUmJ1QjVzTW45NWtZVzBQS3NhdkRGNWg2U1B0K0RzcElEb1I1WXF3?=
 =?utf-8?B?RHdNUkhaZHRDNmJZUXh5eDNXM2s4YUFpMHVzNjJKeUpINnFFTE9kaHYyeURC?=
 =?utf-8?B?UDc5R1pvTU1WdTNmRzFXOS9ERmZ3dXdYTk9iSm42RHNSMGFWb3ZST2cveFRF?=
 =?utf-8?B?WG9zdTB5aW9RNXYwMm1jcmpkb1RDTzRKakVVSW1zT0I4RHRIS1BZUlFyQUQw?=
 =?utf-8?B?ZTVLUTVmL1A3ZkQ2aTF3U25CQnhyVEt0QXFMUS9ucGxqRGNWc1JKb2xJMnll?=
 =?utf-8?B?anhWYy8rRUdENnhCMUhpZ0FtUy95NUxGWExUQzBXdUtROVlTbFN6Q3JSRmpi?=
 =?utf-8?B?SVJiOXZPNXRPMFBmM1RMUWoybzdaR0NFL1VidmpJbXBVeWRrMGtuM3dONnJM?=
 =?utf-8?B?cmw2Tk9IUmp3NTQrWU91MEFEZ1kzakNyZnpERlJjaGVqYk9VSXZuU2g4a2lr?=
 =?utf-8?B?MnEwbGwraFpxRVRMdGFIVHVwMGZxVXpsd1hiYS9zUnNMSmhtalpYbmJiem5l?=
 =?utf-8?B?eWV4TmtCYTFvakEzQm1yQk5ub0VDaGFKY3BIRkhjUHpNTmU3dkltTWo2cnhu?=
 =?utf-8?Q?sEnXSeZQn/7Ei1VuoG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C05F0EE11F00CA49A9C8B6499A0755CF@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: CH1Cjk41hGOw1BZ1mPcAP/wFVuZyX0fGMWChweO2FVYRYCxlyW9JBEBT56o0zqa7f6Rh/Z/bJCtjQjTzV7JUHUolZCA1Xf3JlwFsBGfWL4jutGd+rUbGZfv0I597Vxpc3NHlhl+Zqe07007CSuzOBag2fSGutHsHIMSfNPO4X3U/lkZGf+NQpfAgALrlgZs04SzChNviYxL+5zNIruMfxG5SsJTGm+Fx/28BzDOjgwFDhWqeSZswwjCJao5i+HfQDbv6zqOBnMtEoqHsfi5YI8CAWYuTHPyuEHg0DVd9uFBdSuVFO8cYKVEWXjQxfOPwCaD8du1aMZQKWgoRlSviUQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7f0a5f-f4cd-4169-be47-08df4403b8b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 17:04:48.4309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kbwhpHpSg6+ueg3OLTaUX2rSona2Ei+o/+PhzPxxqK5RAp8rt2e3oXSVKF5spfPc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3PPF061F5055B
X-OriginatorOrg: amazon.de
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 201E1100012
X-Stat-Signature: cwk7og1f56mo5darkkta9jjd9i94u7qe
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794848700-336706
X-HE-Meta: U2FsdGVkX18mfHdThiaLPpz7uipTDcT4J7ck90l5X1ETBQZOjAfwGiBqthrONX3QEIcmYiLnFcAUiaNGEuVzhod+grJP/EUh71OFpXPCGzreNUSW9BGMAO2LORb0i+uDih0NFM6l09Prxr8QsKW+e0bb2oU/6+SdjTs/0RUK2c4uMqlZdh2lm9+FPWdXib6FXeGTRE2Fqi+r6xV7GH7XEh3XWTwirFmLzaTZs9aLauFj6P+nN+ATjCNoLJaV2GOr0MOCqIVCgkHBqMGRXJZoPnYE//fjeVWnEuL56zwwqtGYgxSSmjQIoi9HqaISFMoLiKF1PmNSVR+eRfGFfh4Np1iisEBwsuaGjkNiYKu2WtnjXvDcj0u7dGZ+4ucnet9fw5XsYQhhOJCXzrurKK4e4YrslXKQe6GMMR2NGxtfZxrK5Sm4/nU+wdDxBgCYBfSX2/FHrrYS4GcNlg6GK1G6DfHihxN6HRFNfptO3MITWodZuDIW7Ag7ByFNUxer+xEBPeFtRKXgMw4PME99IzYKNyKuaGZWEzP7Ih1EozsJ2JWLh/aKVBHJAI5tqWdY1gYzhDMMgIdRDi3YVG2X86GcJIoCUaQnDNbCZ1cI9JiRgK/tfNAOYMwspyMgRzfbmOXPMcHIktjEJtb3NZn1y0YYnUBs1gZjgF0xBBRdfzDQlQ2UVROAcWx4dhgcsK3XPuimUToy8KEcJSqY9oeI48+foR2GYGzOCmB2L3jWKODdpR1dPMuMxHydn3IdBVKz6MM13UvbAh6Da1zQE3YxXxdmhr/l9bIZjcVFeAJRf0+LlBcoiPaqvZjf+lttWKgN5rr8mnvD8Kcw2NLkvRnbCdHzVTujMHE/kdKbYH5waj+mq20sMOFFUIyvNeImqSyv0vY5Zm1+PoC+q+e7YZgw3HskghltpwYXrGrVfd1Zvuz21Txppqq+KWps8cuaKaNH2B1qeSxxyrXPs2Ek/udgmPR
 sBTk/Km4
 VD/FWrLtbgOa59J21IuwfmhP5MJQYvw4Eur//baQT4DlBMb2K7/EbV1J29dzOBm/Rii4GhB2oVYCav4aBa6shVO/rwIp0ev6DI+CbIK+AliqXNNPY4onYWQZW8HPwVtWI9WoOC2NaUyMJYo/A2L6f7mIvKH80c4jhyWK7IEg6G83iLQi3D7QKVFm43Fqvxs94UqPYb6OZJ5hcKp+3kZS5sVuN4K5BIZbP585hJX3589PfSicRwd9E8WcHzYtZ/fkzsu2c78OZ730bMWHdjPVPgyb/ng4Kqqc2PAofMeBFMtwd5fgGYipXAxlrrU8yrUthP4/oFlMkLnKzTalfesQakz/53qbcdNDC4C7LWblJxK4hqjm2N8wAVFmC7Djut64xr430l8cUVlrLZD7DLdxvO/MP5NCOTZ14P8wT3laMcdmkDnj93kmLFYOYDdY54ZqIGqQuy1l5psXbPvSZLzGqx7JQre3pUlTzoo02TMCC5hoQuNAbmuL1/HmQNIS7A3HKEhN+hXpvRijEIwl28nIojZx/lXX/CM83frOSAwzAleqA+k7iskK+w1NUoOpddstbow0DpGhA2kYqJkN+bnKCFMpXboULHrr1qegYnRtXB3nCVSWXicDd/4xMbvUqT2HW2XjuTcUBLv7RzwUuwk9gRjH/Jqaxjce+ExCOKqEl5fkAmVMH0NejjmKg4dQ+TRqBsw9YBH8yGUrLwTHgi8wCkQzXq0dmJ/vC++SkYocFlmC9os3ybqOM5SHCWNoyIwS3vdCZFT8RS6wrjlLHV8Tpxv5UhzF2autqJ1cw6ws5qFK4svaZN0bDuMtuusdJ8CzDLkylSf6OFx9iTdCHULBlV8jqS/kCG24SyGHmtGWoohWanPeOlJqB4soNaEsKUxTAUYdA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DQpPbiAxNi4xMS4yNiAxNToyNSwgR3JhZiAoQVdTKSwgQWxleGFuZGVyIHdyb3RlOg0KPiBPbiAx
Ni4xMS4yNiAxMzo0OCwgTWFyZWsgU3p5cHJvd3NraSB3cm90ZToNCj4+IE9uIDExLjExLjIwMjYg
MjM6NDEsIEFsZXhhbmRlciBHcmFmIHdyb3RlOg0KPj4+IFdpdGggTml0cm8gU2FuZGJveGVzLCB3
ZSB3YW50IHRvIGFsbG9jYXRlIHBlci1OVU1BIG1lbW9yeSBmcm9tIHRoZSBETUENCj4+PiBjb250
aWd1b3VzIGFsbG9jYXRvciwgYnV0IGhhdmUgbm8gcGVyLU5VTUEgc3RydWN0IGRldmljZSB0byBw
YXNzIGluLg0KPj4+IGRtYV9hbGxvY19jb250aWd1b3VzKCkgdGFrZXMgdGhlIG5vZGUgZnJvbSBk
ZXZfdG9fbm9kZShkZXYpLCBhbmQgdGhlDQo+Pj4gcGVyLW5vZGUgYXJlYXMgc2l0IGluIGRtYV9j
b250aWd1b3VzX251bWFfYXJlYVtdLCB3aGljaCBpcyBzdGF0aWMuDQo+Pj4NCj4+PiBTbyBpbnN0
ZWFkLCBpbnRyb2R1Y2UgZG1hX2dldF9udW1hX2NtYV9hcmVhKCksIHdoaWNoIHJldHVybnMgdGhl
IGdlbmVyaWMNCj4+PiBwZXItTlVNQSBETUEgQ01BIGFyZWEgdGhhdCBjbWFfYWxsb2MoKSB3b3Vs
ZCB1c2UuIFRoaXMgd2F5LCB0aGUNCj4+PiBuaXRyb19lbmNsYXZlcyBkcml2ZXIgY2FuIGJ1aWxk
IGl0cyBvd24gZ2VuZXJpYyBDTUEgcG9vbCBwZXItbm9kZQ0KPj4+IGFsbG9jYXRpb24gbG9naWMg
b24gdG9wIG9mIHRob3NlIHBvb2xzLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZGVy
IEdyYWYgPGdyYWZAYW1hem9uLmNvbT4NCj4+IFRha2UgYSBsb29rIGF0IHRoZSBmb2xsb3dpbmcg
cGF0Y2ggYW5kIHRoZSBwYXRjaHNldCBpdCBiZWxvbmdzIHRvOg0KPj4NCj4+IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2FsbC8yMDI2MTEwNjE4NDQzMy43NjE0MjItNS1rdWJhQGtlcm5lbC5vcmcv
DQo+DQo+IE5pY2UhIFRoYXQgbG9va3MgdmVyeSBtdWNoIGxpa2Ugd2hhdCBJIG5lZWQuIFRoYW5r
cyBhIGxvdCwgbGV0IG1lIHRyeQ0KPiBhbmQgc2VlIGlmIEkgY2FuIGJhc2Ugb24gdG9wIG9mIGl0
IGluc3RlYWQuDQoNCg0KQWZ0ZXIgYSBjbG9zZXIgbG9vaywgSSdtIGFmcmFpZCBpdCBnZXRzIG1l
IGNsb3NlciwgYnV0IG5vdCBxdWl0ZSB3aGVyZSBJIA0KbmVlZCB0byBiZS4gSSdtIG1pc3NpbmcN
Cg0KLSBBIHdheSB0byBmb3JjZSBhbGlnbm1lbnQgdG8gMiBNaUIgKG9yIGV2ZW4gMTI4IE1pQiBm
b3IgdGhlIGxhcmdlciANCnNoYXJlZCBtZW1vcnkgcG9vbCkNCi0gQ2xlYXIgbm9kZSBwaW5uaW5n
LiBJIHdhbnQgbm8gZmFsbGJhY2sgdG8gdGhlIGdsb2JhbCBwb29sLiBUaGUgDQpoeXBlcnZpc29y
IGRvZXNuJ3QgYWxsb3cgY3Jvc3MtTlVNQSBkb25hdGlvbnMuDQotIE1vZHVsZSBleHBvcnQsIGJ1
dCB0aGF0IG9uZSdzIGVhc3kNCg0KSG93IGNsb3NlIGlzIHlvdXIgcGF0Y2ggc2V0IHRvIGZpbmFs
IHN0YXRlIGFuZCBob3cgbXVjaCBkbyBhbnkgb2YgdGhlIA0KcmVxdWlyZW1lbnRzIGFib3ZlIHJl
c29uYXRlIHdpdGggeW91ciB1c2UgY2FzZT8gSSdtIGhhcHB5IHRvIHB1bnQgdGhhdCANCmRpc2N1
c3Npb24gaW50byB0aGUgb3RoZXIgdGhyZWFkIGFuZCBhZGQgbXkgcmVxdWlyZW1lbnRzIG9uIHRv
cCwgYnV0IEknbSANCmEgYml0IHdhcnkgb2YgZG9pbmcgdGhhdCB3aGVuIG15IHVzZSBjYXNlIGlz
IHN1YnRseSBkaWZmZXJlbnQuDQoNCg0KQWxleA0K

