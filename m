Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01CE9106121C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3663F6B0005; Wed, 11 Mar 2026 07:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309B36B0089; Wed, 11 Mar 2026 07:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165CE6B008A; Wed, 11 Mar 2026 07:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD78E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:15:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88BE91B65B5
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:15:07 +0000 (UTC)
X-FDA: 84533525454.18.57DFB8E
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 906E1140007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:15:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=OtYslzON;
	spf=softfail (imf26.hostedemail.com: 67.231.149.131 is neither permitted nor denied by domain of mboone@akamai.com) smtp.mailfrom=mboone@akamai.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=akamai.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loVzwqMnK62jAlv0Y/mwQJd0L81p7lBO8pqIwYFTJbg=;
	b=SPlleJmccgPIRonDTazHBI+QSRF++pPs4sCA8WgHe2UWe/JdsgP9QNm9Xcnw65CKmoFF7q
	yRZ1hrgjvB4/ZOg6Me/+qPNC/THl8MYOxpURhfOZo3Z/F0/HGC5SceevoQMxQyFR+Gbnxa
	PeCo83YW0yDEEiPVcuTv3+JJr3g/E3E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773227703; a=rsa-sha256;
	cv=fail;
	b=RW4jCVLYVqXumCz7YRCHHYeUqzde8ZnpP91FbHV/qtJgtr4F2/kEDjPCtGKwQTuuz89vje
	n3cT/O1Pf4Twl6eX9HstGGZOJmZB9qtBr1MCOx0i1HJsgoMBClqPe9vmPUIIp/9DD6+Wux
	sBo9FALSlpS8T5/KFwJh7BqPR0MYgbs=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=OtYslzON;
	spf=softfail (imf26.hostedemail.com: 67.231.149.131 is neither permitted nor denied by domain of mboone@akamai.com) smtp.mailfrom=mboone@akamai.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=akamai.com
Received: from pps.filterd (m0409409.ppops.net [127.0.0.1])
	by m0409409.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 62B4rl28842097;
	Wed, 11 Mar 2026 11:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=jan2016.eng; bh=loVzwqMnK62jAlv0Y/mwQJ
	d0L81p7lBO8pqIwYFTJbg=; b=OtYslzONRlL0YffcqT4m7ksYq+oDT35le1G+3+
	JblCZuojZpcIH7KQv3Bi6f/9/WOot6wii6SkNSH++qRJSwh5ttrBinCNiD9i/2y6
	c0L7Uhb8+nYd51CQ4ovrOg5mvIkg457wIC6P4cvIKumbHfuczjYMLkez7h0Dpqma
	gFxltY5Kl53UsgiUF30kvLWn2S6F2cjGWBhbHMpY6pl0X4BhFYST0v0NTBGH+Mnh
	5VMoqey22MWAxGAftrriRYNvpmAVUQvJKR1O+4onqZ41u6JBIK0DfGcWsEW9cOwI
	xhS6qE5vlAdHWHXq0mKebk5BZjYkb1/UATCglUPFO/Wrg3qQ==
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61])
	by m0409409.ppops.net-00190b01. (PPS) with ESMTPS id 4crx7tqwqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 11:14:57 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
	by prod-mail-ppoint6.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 62BB43q9018777;
	Wed, 11 Mar 2026 07:14:56 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.41])
	by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 4crg7ysdnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 07:14:55 -0400 (EDT)
Received: from usma1ex-exedge2.msg.corp.akamai.com (172.27.91.35) by
 usma1ex-dag5mb2.msg.corp.akamai.com (172.27.91.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 11 Mar 2026 04:14:55 -0700
Received: from usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) by
 usma1ex-exedge2.msg.corp.akamai.com (172.27.91.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 11 Mar 2026 07:14:55 -0400
Received: from BL0PR07CU001.outbound.protection.outlook.com (184.51.33.212) by
 usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 11 Mar 2026 07:14:54 -0400
Received: from CH2PR17MB3797.namprd17.prod.outlook.com (2603:10b6:610:80::18)
 by LV3PR17MB7093.namprd17.prod.outlook.com (2603:10b6:408:1a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Wed, 11 Mar
 2026 11:14:52 +0000
Received: from CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2]) by CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2%5]) with mapi id 15.20.9678.017; Wed, 11 Mar 2026
 11:14:52 +0000
From: "Boone, Max" <mboone@akamai.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: Alex Williamson <alex@shazbot.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka
	<vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan
	<surenb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        "linux-mm@kvack.org"
	<linux-mm@kvack.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tottenham,
 Max" <mtottenh@akamai.com>,
        "Hunt, Joshua" <johunt@akamai.com>,
        "Pelland,
 Matt" <mpelland@akamai.com>
Subject: Re: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
Thread-Topic: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
Thread-Index: AQHcr+1eklEgHPr7TUGT7iw+X10ZcbWmpDOAgAAsNgyAAKuYgIAAKNeAgAA99oCAATQqgIAABJcAgAAJ3wCAAAMtAIAACA2A
Date: Wed, 11 Mar 2026 11:14:52 +0000
Message-ID: <928CF80F-7436-42ED-9791-F63E3D699CBE@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
 <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
 <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
 <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
 <83842620-AD01-4619-845F-8DE7DF1F8F31@akamai.com>
 <0a652e7e-339e-4f98-b591-7fe5680e2006@kernel.org>
 <6CBB0401-26DD-4EF9-949C-54BEAD3ABA33@akamai.com>
 <5fb9beef-b6fe-401a-aa24-aade48b795d4@kernel.org>
 <0A734214-9E4B-4A65-AFB1-055883639358@akamai.com>
 <d7f3c613-92f5-4400-812e-a368bee45a41@kernel.org>
In-Reply-To: <d7f3c613-92f5-4400-812e-a368bee45a41@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR17MB3797:EE_|LV3PR17MB7093:EE_
x-ms-office365-filtering-correlation-id: 6685ffac-8b1e-4d1d-086a-08de7f5f6ac5
x-ld-processed: 514876bd-5965-4b40-b0c8-e336cf72c743,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|6049299003|4053099003|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: 7XCHiBsulG+cGhvk3d70CSgRVjrAHgJM2Qk1Y0URoi0SXyyV4915Ai3tFxNsh5boo36tfpxVCCexcYsaht9d4vQJp7Sv6TjrKPxWg55MOvGoY1Qi8WU4Nxk1s1QICbUMxjU3aP/Q+csUVzXtskQ6HubRv3HqCTtU0BlntviNDzVYAWZGkMsRwh1Aas24yoETK7oumPTS+zaxYdUOJurpvMWBUQvFnKpApKtgEaaV+NOk7I/hEJDgorv6WI+GYXNES91P4mm8e7NHryFRnwz0l5bgpt1O19brOsk052tUhe6xcmfMYbt25AsdEHqDoiK7WZOJ6ftQLwxyUbo2Du0at7rYZu89h6eKXJpjfTOvAS8CBy2tQ7gLMzrdYe0995fCPYu0bGho+sdmB04HTBxSGTtzcx5tEhZRDjT5WH0R6MFZ9uZhtM5kpmx2oId4BrdweXBt9oQvc6ZtWPD/++vcQWOD8HqGM9RT6tk772N3UQv2vKaiKO4p9XidusRoZxuWFKtm378PQQlE9zOlKbO6aPKgSxs98e4AXGStbu4SWyvtw7oW2qxLDaMoOPGUf5Qa7DDA1zLQ46oL4VcghpMmtfaHZCeApFCSCuVTEvK3V5QtoSYJf/Mr9QmWx0/A7QfrNRSZD5H1XlzX9NkUX2PJ750IfuXWNR7XNo95WZcb2aUpspMH6X/YoVWVgCHOXiM8sr8wpz2vDsj/50WVY7sQznNG1Z1agoIoSdsqTEmmUjXZOHeAYfkdnfduiu0rDq0HiH+M7pV2m/Q2hj+ht0LwB5LBCltE2fXdEFwo0+vxrTU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3797.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(6049299003)(4053099003)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0oxc0lGK3oxZkRyaURNbVdteUowN2xPVVl0ZWp6MkpxSjk0V21FeW83eklJ?=
 =?utf-8?B?Z3VHU3RYU09Sbk9Yblo4T21nNXdFTUp2ak1zY3ZlL3FmUWNkTTRyMkR5OXBI?=
 =?utf-8?B?VENCWlJZRXJHemRickw0OWVCMCs0ajg4WlBuZ2NVemoxZWxrdEZ4QmdhSDlD?=
 =?utf-8?B?VFk5QmN6NEgrc2RJZXl4L1g2djJZVXpkQ3cxQmJzNzF6bldjYjdOYndhMVd5?=
 =?utf-8?B?UWloT3FTSEVCUU4zZGlWeXRnTW1LQnJXQW8zYVRNTlp1T3QyZ0ZlWmVNeUtj?=
 =?utf-8?B?WGFsY1g1dklIWWFONmZObVhMQVE5bk4yMS9nRFJtM0s3ZEplSlJ2RzdXUFlB?=
 =?utf-8?B?WGQxcWdjek5Wb0p5L3FLR2xpZnc3MEQwUnpGaFQvSXNrVnB5NjNkRENKZVVi?=
 =?utf-8?B?aXNkUWZiVUZvcXkvM2tyQlYrd0tTV1FGVmhFcmoyaFU1TXNBL1FqekZydnFr?=
 =?utf-8?B?UDZDd05mL1c3MnZUcFNuUWdHTGpBbzN0R2J1SFRVMmZLdTZvZmZGeVpqSlBV?=
 =?utf-8?B?ZUFVeWFpUElQS2pPYndCc0NRS05yRG13STRaajZuTHh5UUNBUzUvTlV4R3Jh?=
 =?utf-8?B?aXREK0toYmZEb0lQZkNrN0h4eTI5aGo0TWhWZDJ1ZDNTRlZuVWkyUDkzMlYx?=
 =?utf-8?B?VitqcGNydy80UEVNckNlc1hIaGNFLzcxemRFMEo3NlB4TlUzQmlLSGQ1aEtY?=
 =?utf-8?B?bEkvNDJvU25IU01nVmJUa1Rja0FsUWJOSXVFVkhIMTh0ODJEd01aTDN3OTBP?=
 =?utf-8?B?V1Foa0JLc0N2RWtGb3ZvcXhZcnp6N21Zb0hBR05jZmN1UlNHS1ZFRENyU2p5?=
 =?utf-8?B?bjNtVXorRmNPcWNDcWxHcWJlRE5UT2l0VFBJdlYvemlKdlhsbzZQUi81MU9N?=
 =?utf-8?B?T1VieHVmUkF4L2FRcVFTU3ZQcEFtY3J4dUhDTVcxVmZzKzdDc2ovSXJMdm9z?=
 =?utf-8?B?T2ZHUGEvVkZSKzRwRE04dWpSLytnWStNZG9RZ0pTZG80cU8vMXlOSWdXZXBH?=
 =?utf-8?B?WDJvdTAyd3lEeFZxUEZ5SU56UHkwYjlNVXp5dGw3QnM1TGl2Q0NRd0JDYkps?=
 =?utf-8?B?KzB3L3M4LzlIUVl1L2YyL0hUR0V3cHdJLy8zZTFEeU9WdkRZK25CZFB6bElD?=
 =?utf-8?B?Um1Na29WNGYrbkZqNGxNdFBqbEwxclc3Vm1xY1QralFBRi9OcXkzdVdibTdt?=
 =?utf-8?B?UVovMmFVeDd2RTdyUE5zdlc5OTV1em42Mi9sZUc2Y2wyRWZzWGJ2MGszL0pk?=
 =?utf-8?B?YzhDWm1OYnJFME82dEpaS3JyZmg1aUs4R0tnRjBrbk1oYVg5azEwMndZSUcr?=
 =?utf-8?B?TDQ2Wk45d1B5UTg2dTgwS3h3UkRTWnBBK2pxMXRjbnlNRmlPM0xNRTZEN3ZS?=
 =?utf-8?B?QmUxNk80U096ZXROcm00dXpHNXk2TXl5dTdSekgxeWxnd01EaGgzdHovNC84?=
 =?utf-8?B?OGRUK0JYcXhoSlBiTVMwMEEyUGsvZE9mcmhSeEJPbDgwZFdnbFJIQUtXbmo1?=
 =?utf-8?B?MkxaV3hvZHgzczJRK01HWVRaSEN6UWZQZ2lnMHNZWElGdHZHa2NwZS9FZU9v?=
 =?utf-8?B?R3BFNFNnMnBURWFxdGU4Y3JQdi9NZjRQcHVqOTVSN2JtdW1wUEZHSVd5OEx4?=
 =?utf-8?B?bE56WEZiMmNzQkdyQXkvNHdqRTdzY3BpdTZRalVLZlZXeWVJRTk5d1lVR0lv?=
 =?utf-8?B?c0ovaHFLTHJYR0JRWDgzeFFCYW1rQmhRZmd0RlNXTllqUld2YXNpN2xLQXQ3?=
 =?utf-8?B?T29zRUFLSmpnYWpkNHVLQTZKOXlOZ1g2WVVhTjM1WW41bUNKTjNpcVR0SzA3?=
 =?utf-8?B?ZDVmSVZZUWJDTm52ZkF4YmFvMzhpMzF0Ri81eWF4MVJmRkF4anV6NXppcFdj?=
 =?utf-8?B?N1dCT3RMazVCZk52cmY0WWwwSDFrOEN1c0tFY2ozTW5aT3dEOEcvTVhaV3VG?=
 =?utf-8?B?di9uYTlFRHlTNWhSRjhMRTlsZXQxay9qVHJ4SVAwcTRpbHNwaERnMDhwa0VV?=
 =?utf-8?B?RjVKcldLTnozRExnZy9kekd6SWlDVzg4YmZKZjk3ejRmMDNLZk0zMkxNKzdH?=
 =?utf-8?B?VU9hbUM2UVhLblJaYzFpODZaMDJSaStoZk9CbGozWEVrM2g1NFpNVEZaSjlz?=
 =?utf-8?B?UEE2OGRQS0ZuMDhQZDhCOUxRTi81MUNTWlFqQmNZdXhqYkZ3RGdaZmZrRDRk?=
 =?utf-8?B?Wm9yWlZOZ1ZHemVDZEJWdVpRL21pSmlqM2hXVyt5YXdaWkhpc0F4aC8rOXE2?=
 =?utf-8?B?N2drTEhPa2xHV1dOam8yVWE1ZStyQXY2MWNHQ2JoSWhHUlJTZ0Jwa1hTbUZL?=
 =?utf-8?B?TDNuRjZacnpqalJTL3UzSzN1RzhRVjJNNm5GRkdiYXcrYy84cDZKdz09?=
arc-seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uqmZDxZkCbSKWoS23g67Wrtrm9noRQDhGt1xSZVeKI6I5o/9jfwkPebbZ2jZI/FBUDKfEDzk3lA7HerFTF82MUeUzT19tC8utAGJau1MNc9h8yJDfPcTorc8+ZuJ9xQwDFQDL3ZeoQHLwaSyMGKXMbxrcQsRFpj3Fn9CdFcpMh/VwYeaRJ9liXyEqzrfuMOrv0fLUVYdiuTldnZFkAaSMVJNWZquhiUm/KetFmeR0fVKfom81y+615xu5G4NIUhq89wlTA2ZTWrFBffhSx6NDqVzYE/9e9j6ystnJvj+RqN+Zojzb1n8RaxKBsyvLI+Fjl2BOzPV3WEocMPnQNPKlA==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7fBMEEsgI5sPBEmL2Pt0xG4SHz8uSq86uC+qKT4iko=;
 b=k3Pfu8tpDpTqCt1QfxfFXEe4yhpJkGLQTDyRNbFkv/A1NGGlzrVeNB+z0RJ+Bk12kKEDJsw3j3p9r+4fBOjRqbXvMeVGrzTdazdiljdCBxAOKvuA4qySM3mn3CJHcVR8sv8+1CLLtd8TDBWsxH5acW+bpH7smlR7k8p1xgzmZx1mUqV9thmfntGfkAni7WCYEihLYHyly3ifvuL0gm8LXX6GMBYt/ebvmoI733FFAHVZqJzP/C1MGOqoxHTsg456VGRFkeuRU3aOYqh3cUxHruzyDC+sNZlJMeo0QBwi24zHkqSbHV8N1ZPm6+2NCuHTwdd15IK1B42CzS3r0vxtBA==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
x-exchange-routingpolicychecked: U0LCrbvowb+N+R1V9ZpWqQrmX0nxKh7Zw8hNC6PfgKt73IGc6+73F7MIhLGHS8CZ88alQN22FeLi15CTBiinjxN4866OWINRWl9fJ/qJMg9ZVM41LJt/ertCO2u6vsloaIaA8ydrBj476ESatcM3F38huhvLQ7g/LNPr0sgOmhheSrtbJJgkulzjxNZVsavwOBtmxXanFoT3pNqVwX4w/NqidSek9WFdVLr9whOQiRSrxXusbrURdA3lfvHaGAn6EX+DzPkLdMR/M/n4esWZY/cybTSqJXVKfSDHBPUxKxXNWQJriuAOqwSOkYPOWtKK9iHRHuH+Yl2bumDPjFFZSg==
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: CH2PR17MB3797.namprd17.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: 6685ffac-8b1e-4d1d-086a-08de7f5f6ac5
x-ms-exchange-crosstenant-originalarrivaltime: 11 Mar 2026 11:14:52.3049 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 514876bd-5965-4b40-b0c8-e336cf72c743
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: TtMfEywSehUP14bfIdUlCEZ1VQYxJp1OM5HEh5SKxHFnOHpXr135rtBQV/hxJHOE3wgWGNHlpFFO06DckLQFpw==
x-ms-exchange-transport-crosstenantheadersstamped: LV3PR17MB7093
Content-Type: multipart/signed;
	boundary="Apple-Mail=_02321BE6-5527-464E-950B-8A59BC1BF43E";
	protocol="application/pkcs7-signature"; micalg=sha-256
MIME-Version: 1.0
X-OriginatorOrg: akamai.com
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2602130000 definitions=main-2603110093
X-Authority-Analysis: v=2.4 cv=KJ1XzVFo c=1 sm=1 tr=0 ts=69b14eb2 cx=c_pps
 a=WPLAOKU3JHlOa4eSsQmUFQ==:117 a=WPLAOKU3JHlOa4eSsQmUFQ==:17
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22 a=TTBIr9FR-UdC54aaq7Eb:22
 a=VwQbUJbxAAAA:8 a=JhIoQl7jvkQHYgSkr4cA:9 a=QEXdDO2ut3YA:10
 a=aUQEjLJJORIxqg3IqZUA:9 a=ZVk8-NSrHBgA:10 a=30ssDGKg3p0A:10
X-Proofpoint-GUID: LS7buuPAmCrjs8GGKLJz49Gxjyvi4YIG
X-Proofpoint-ORIG-GUID: LS7buuPAmCrjs8GGKLJz49Gxjyvi4YIG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA5NSBTYWx0ZWRfX/psddEFm4RvU
 S6IF7jjN/f1QS0RbW4QyECoI27G240ZY7DQSaX+m5jdOO5YLHEdfsQU8SYdCahtClmmhIZ02cJ0
 0knSSW53ARq4cc/zdBtrsHjY3S0WZB1ySnZPzOWNGj1PvbzoyGQ+Nh2bjTxzbh+7+QBImr0sHEy
 MnWP5FlAuQNGKlsRf2HwF/GklJU3YgMP2xRlr9vOJGT01XeVrtip6NgjGplclmbkyhPhWojZOpy
 UG58hw2oHkJDs91yEMiTlAVG/D6Vx1OR32L5OAkZq80bCpvnn3a8opcnxa5MKvl5vBbCYw4T7ls
 wvE5I+uPhqcy3VJ2XZyKePmz2tOjMI0rM+I7CJx80PkVPN1VbZrsZhPg41zPncjdD9vKwQARCVd
 LZSyJfku5gg9Rjxi24+NsqSyKVgBgDFz98Obz1LVmD1j2IPjDXUK99I5ETlnPqNzJmQbC71Q8Xp
 8z+dFNoUbo0Dh+87VZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603110095
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 906E1140007
X-Stat-Signature: wqjxux7cuse8dpw7txbk5fu6mhuky4dx
X-HE-Tag: 1773227703-746070
X-HE-Meta: U2FsdGVkX1+TZhURLqMbQr206vckwkz4fiEHNZIDkO1Mcs1uUPTbNgeod9ATrPevsDcbDa6ziIga0re27KTtRQKG/RThgL9ZlnY/t/nAEckJk6XkyvoVUt9K2oeBWBNqK2h37h9DTu9nUFNbs/VjuUrGzrZUvhzNAJWi7EwpaBMbi9sEHFH1DhZLRTpqlBY12fiyphb1L5YrxBYAAyktqHyECaXaiKaBrREFlKXkOUOjKqKI1WOjGswdjz9NpFpoVLBfEs3Agk8BLpsufKvzPa1IPGT/oCU3lDPVyDa94fU9ruickUnZtHnI0y12QvMYTej++lmJH8KHfSPN5GwOKWkNJ4izVId64CLC1QKnnFSuML/cHHGdXSkSacQ6FB7sQXCaKuCgQfAdvcPp5cieg39CRwaPNQgoo861lPdAnexleSnbJ+ZGBMHKdpu14LYFpK1sL9/o1WACS6lAXwI99xe4vy3NENMYur43ZNEBwUgQCBrUFEFgRsihcDirYZ5sOCti21Bj0Lt4bI8Fiu4RWpuQt+YEYCI1xdPYwo7jZPB3SJoCTH1uC9QOE6eldudnLZzn7vVCmgv0uf55tsnwZoi1goxs0ZtHMoyIAIOTxFGRuWpHKxa0H37BapO9Ck6pBfAqIyrkPYrcn9UZEib1q1bsvsvIzfF3/vmcHrhac4oCE0gAFnhVyazK5uu+2bUYBBxTaJHjMpNMThjmNHcYLJFyqNKE7EYV7F4srbJCrS3V8UM7/7alxWYSnGw1hawWyD2kzAuhL7K5leoT72NAbyhpjBJ6A0o4FOz8i9oX21QDYds5SiwAcDKm6r4TT5F05kY+J/7DNBR9pSC1u8waBCh9+1emDd4K5oJInMGwZEmzkI45o73O8CjImG8rP0TxL8dsyf9iKX9mYxnRt0cUegu7sf7keipBORTlpSqeio61MG6mPIHl4hXlvDBAp8+dqyRq1Nu2pC2xci9Y6xm
 XjNLMbCQ
 aoXj8Iw4MKVhq80wCa6XhN2og+SSzC1kZPDYxVfz/EDGSvLLfKUnqVIpGaJUV8I2btstLrr5FLhs8swsSSD2gRcqVDG33x3U/BXGJVZUbxPqOi+AJQyUXPLsGSz3p/pGEeimIbeDkHQ+bw9Hj1ZbXtYN01DSa68Lkg0lFNS3lHeow8xzUBXpmwvTZwtOO8F6H6UOIfal9gKim8pAHgeG5vWOzU6UHb69K2arnlRbpT7a2DXSRrBiNp/qatd44qF/E9wirfUu1i5BeMkPBL0eXFOWs391efrTYuSIH4sRkNVFjpX0FcF41PuBPyWbTndr93oUFRQMAGyQQoZOF5FBro6IttpcHJYfLws3bFMuElGN/7MkrA//x1HrGpL8HQkhrqLjquxBsWYow39NEne+/egK79kh3mdAWcO/zCRcICTYEg8tBsO4oAQ8RnwoHHKk0aGHYjGwuVgCRQ90z9mMahGdsDCL3pU1VL2fxTNqmQSSBbSZOrhw+wPkNDYBWkjPDjyY0HKN5xUEGZkg8FGti1OtXLX+HylMUeJZZK5HTLbCAQ8+bFDfkm0c+WvyyiUDTkm83mDkJB75pveWxhzNiL+ELS1p/VGuAycVqdqYtyQpyH7KILpEDnVIslkH4HOYeCfiaOv+feiIVctgZnK4TnW1adL0vNU4owziifRZ21CW0t2kKaBlagJJh35yQsBoDeVbq+dZ1mFrWNw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Apple-Mail=_02321BE6-5527-464E-950B-8A59BC1BF43E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Mar 11, 2026, at 11:45=E2=80=AFAM, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>=20
> The code in follow_fault_pfn() should likely be updated to handle more
> than one attempt. That's also what GUP does.
>=20
> Likely, follow_fault_pfn() was never taught about PFNMAP mappings that
> can be faulted+zapped (in the past they were always static).
>=20
> If you turn that into a (possibly) endless loop, does the problem go =
away?

Yep, was just trying that - with this change the problem goes away:

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -532,7 +532,7 @@ static int follow_fault_pfn(struct vm_area_struct =
*vma, struct mm_struct *mm,

                ret =3D follow_pfnmap_start(&args);
                if (ret)
-                       return ret;
+                       return -EAGAIN;
        }

        if (write_fault && !args.writable)

=E2=80=94

I=E2=80=99ll propose that with the VFIO folks when I get the patch for =
mm/pagewalk.c ready and will refer
to that patch, or would it be better to propose two commits under the =
same cover letter?

I can have a look at follow_fault_pfn but this problem is my first time =
diving into linux mm
so that will probably take a while (and some reading up on my end).

>=20
> --=20
> Cheers,
>=20
> David


--Apple-Mail=_02321BE6-5527-464E-950B-8A59BC1BF43E
Content-Disposition: attachment; filename="smime.p7s"
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCCcow
ggShMIIESKADAgECAhMxAAAAIa0XYPGypwcKAAAAAAAhMAoGCCqGSM49BAMCMD8xITAfBgNVBAoT
GEFrYW1haSBUZWNobm9sb2dpZXMgSW5jLjEaMBgGA1UEAxMRQWthbWFpQ29ycFJvb3QtRzEwHhcN
MjQxMTIxMTgzNzUyWhcNMzQxMTIxMTg0NzUyWjA8MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9n
aWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
QgAEjkdeMHsSTytADJ7eJ+O+5mpBfm9hVC6Cg9Wf+ER8HXid3E68IHjcCTNFSiezqYclAnIalS1I
cl6hRFZiacQkd6OCAyQwggMgMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFOa0
4dX2BYnqjkbEVEwLgf7BQJ7ZMB0GA1UdDgQWBBS2N+ieDVUAjPmykf1ahsljEXmtXDCBrwYDVR0g
BIGnMIGkMIGhBgsqAwSPTgEJCQgBATCBkTBYBggrBgEFBQcCAjBMHkoAQQBrAGEAbQBhAGkAIABD
AGUAcgB0AGkAZgBpAGMAYQB0AGUAIABQAHIAYQBjAHQAaQBjAGUAIABTAHQAYQB0AGUAbQBlAG4A
dDA1BggrBgEFBQcCARYpaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNQUy5wZGYw
bAYDVR0lBGUwYwYIKwYBBQUHAwIGCCsGAQUFBwMEBgorBgEEAYI3FAICBgorBgEEAYI3CgMEBgor
BgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAwkGCSsGAQQBgjcVBQYKKwYBBAGCNxQCATAZBgkr
BgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNV
HSMEGDAWgBStAYfq3FmusRM5lU0PV6Akhot7vTCBgAYDVR0fBHkwdzB1oHOgcYYxaHR0cDovL2Fr
YW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNvcnBSb290LUcxLmNybIY8aHR0cDovL2FrYW1haWNy
bC5kZncwMS5jb3JwLmFrYW1haS5jb20vQWthbWFpQ29ycFJvb3QtRzEuY3JsMIHIBggrBgEFBQcB
AQSBuzCBuDA9BggrBgEFBQcwAoYxaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNv
cnBSb290LUcxLmNydDBIBggrBgEFBQcwAoY8aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFr
YW1haS5jb20vQWthbWFpQ29ycFJvb3QtRzEuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vYWthbWFp
b2NzcC5ha2FtYWkuY29tL29jc3AwCgYIKoZIzj0EAwIDRwAwRAIgaUoJ7eBk/qNcBVTJW5NC4NsO
6j4/6zQoKeKgOpeiXQUCIGkbSN83n1mMURZIK92KFRtn2X1nrZ7rcNuAQD5bvH1bMIIFITCCBMig
AwIBAgITFwALOJfLRtbGzZc1dwABAAs4lzAKBggqhkjOPQQDAjA8MSEwHwYDVQQKExhBa2FtYWkg
VGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMB4XDTI1MDgyODA3NTYy
OVoXDTI3MDgyODA3NTYyOVowTjEZMBcGA1UECxMQTWFjQm9vayBQcm8tNDZZVDEPMA0GA1UEAxMG
bWJvb25lMSAwHgYJKoZIhvcNAQkBFhFtYm9vbmVAYWthbWFpLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOX+npfSrX/rwhOySq6aejQMUVslPFpNvXdEnmMlnEjR95gq0Ygp+wQc
Sde+JGBpGHsPMzHT1Nd3V1acm4cW1WB1aRqJOMfSLifg6SLkq2EM9WsftEiA1G4BT4UP0PFZY2Os
6TXvebAuVg6LwhB417rEJ2kuS/DKpiG8trAVDR6Uy9vbSMBp6iIewBc9r0CjW8l1zgRr+uQpXEUP
mF2BV0l3Qo5r0nhPqTWR9oAX4/oTqnhbEhQ3tOFYTjzO1K9DdzX8mVggVSZz/M0v0gtkZVvO4B1t
3Sh+1lla5eMY4hlVHW1/FKqMe4EMXmDH7goTEuXPpelJiNRdBh7ud7xNNFUCAwEAAaOCAsowggLG
MAsGA1UdDwQEAwIHgDApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQBgjcKAwQw
HQYDVR0OBBYEFO0y/xWMpkyOUMuNKmuzNtjXpdtRMEQGA1UdEQQ9MDugJgYKKwYBBAGCNxQCA6AY
DBZtYm9vbmVAY29ycC5ha2FtYWkuY29tgRFtYm9vbmVAYWthbWFpLmNvbTAfBgNVHSMEGDAWgBS2
N+ieDVUAjPmykf1ahsljEXmtXDCBgAYDVR0fBHkwdzB1oHOgcYYxaHR0cDovL2FrYW1haWNybC5h
a2FtYWkuY29tL0FrYW1haUNsaWVudENBKDEpLmNybIY8aHR0cDovL2FrYW1haWNybC5kZncwMS5j
b3JwLmFrYW1haS5jb20vQWthbWFpQ2xpZW50Q0EoMSkuY3JsMIHIBggrBgEFBQcBAQSBuzCBuDA9
BggrBgEFBQcwAoYxaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNsaWVudENBKDEp
LmNydDBIBggrBgEFBQcwAoY8aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFrYW1haS5jb20v
QWthbWFpQ2xpZW50Q0EoMSkuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vYWthbWFpb2NzcC5ha2Ft
YWkuY29tL29jc3AwOwYJKwYBBAGCNxUHBC4wLAYkKwYBBAGCNxUIgs7lOoe41C2BhYsHouMhhtIP
gUmFpcMQmtV/AgFkAgFTMDUGCSsGAQQBgjcVCgQoMCYwCgYIKwYBBQUHAwIwCgYIKwYBBQUHAwQw
DAYKKwYBBAGCNwoDBDBEBgkqhkiG9w0BCQ8ENzA1MA4GCCqGSIb3DQMCAgIAgDAOBggqhkiG9w0D
BAICAIAwBwYFKw4DAgcwCgYIKoZIhvcNAwcwCgYIKoZIzj0EAwIDRwAwRAIgD5UL4MI1RXeg64RR
kifZAeItCnkZ4ecrqSEGpLcXV+ICIAdB9vZdM1WGxtag0rlqG0j0FBrCWixC0cdHNpFrqNx/MYIB
6TCCAeUCAQEwUzA8MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMT
DkFrYW1haUNsaWVudENBAhMXAAs4l8tG1sbNlzV3AAEACziXMA0GCWCGSAFlAwQCAQUAoGkwGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYwMzExMTExNDQyWjAvBgkq
hkiG9w0BCQQxIgQgCs6OVTDg0SQYY71+hATZmIx5zV2be8G0VF6ckCOqjtgwDQYJKoZIhvcNAQEL
BQAEggEAzkMinc3iWGeflxyrSOuKUAN7avikpVMkVm3VtBy63Q4hjSw9QzqZfcXZ5ZlrB1ZNnwu6
PHbITBpYWKCqsATE3LfLk9GyVjylCQScJT52IMSqmSeOGD8R9P9bdmvPrZHOWMpX1XBUFZBnO+gT
tq9HxKTM4QkdwzSVLpanrPHS3fiAO9iUetMN1ieTOQHLu1LunaM87M/4Gnl/YcWHklAQ8S3CXebk
5D38K/URoyGOE2VvDv3UzWZtCZl2hVMSj2o6uJhBPfURsuqckyXb3/qEn3huVi+JOvDeGDeV6+3j
UayTHtGxxRnprCPZESG3Z3B3L9PfsIDx8K63P/JXUcP5pQAAAAAAAA==

--Apple-Mail=_02321BE6-5527-464E-950B-8A59BC1BF43E--

