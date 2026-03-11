Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA23104BED5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542BC6B0005; Wed, 11 Mar 2026 06:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5107F6B0089; Wed, 11 Mar 2026 06:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7286B008A; Wed, 11 Mar 2026 06:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6B86B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:35:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8640D1A072F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:35:00 +0000 (UTC)
X-FDA: 84533424360.11.0EEF40E
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	by imf04.hostedemail.com (Postfix) with ESMTP id A8CAD40007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:34:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=aYgXepNI;
	spf=pass (imf04.hostedemail.com: domain of mboone@akamai.com designates 67.231.157.127 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773225296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r08YF/YZwqZxl7nDe1dtEKePaY2L5dGnyL6lj8kfV8o=;
	b=5Sn+EoKNYMQmIx68mhBCLdOrEY+KVVSKNUAAsxUmt/2dOScfCUUIqQMa1qMlzQe7bU8b6Y
	2WcyQ3aQqTjGKFUcTdgr5G2HddjpZAylQfh5ZikQQvwjiiBksA8zd0LqP6jecYRFb3Gt9d
	09+kFTEOJS5G3eFjGV1IrHEMyTRdqWY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=aYgXepNI;
	spf=pass (imf04.hostedemail.com: domain of mboone@akamai.com designates 67.231.157.127 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773225296; a=rsa-sha256;
	cv=fail;
	b=SI1WGzTjotP+ORrBLn58zYU1z7EqHIDDNKWLNjIUvRRD544SU48GdK5c0rpV0nQC/K/PYi
	vKVHm5rkMUvd8Ht/Yt/kBTlLahfAUzIKh+5SP4oWD0J6G2SmU2eLc9vjVBx7BZUyw3PEwv
	UD11yEmbfupwA8VqCVaCDo/1AiA8Cdk=
Received: from pps.filterd (m0409411.ppops.net [127.0.0.1])
	by m0409411.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 62B6xBe63013011;
	Wed, 11 Mar 2026 10:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=jan2016.eng; bh=r08YF/YZwqZxl7nDe1dtEK
	ePaY2L5dGnyL6lj8kfV8o=; b=aYgXepNIwpn1988UlX//jvZrGjU2FB0OdaRp1b
	jbGcv/sr5D8yT5iWESo5+b9MdDcfBB2RvXU+gQ+Tn++9M39x+AIRU8X/6L9+y98m
	c1shTBDi4hJympMDrGXjh7oL8S/Y7sHFBG+mnnoQPUkoyybRRq/7u+vNwMxyC261
	1d4S5Ev1BC47z+RtmS9I10JAKA4K9e2N+dPfhY6U7mWJHk7x68dES0fvrJ1ujqGA
	X4kUEGqUEBQwO9HKKIqiXiaVfqYgGBAj6C3P14xRxjY/n9TlryhhSf2ANZMhMqZE
	58mb8XKrQado6BIpsBN68DWLSvpxjGqJAlRNEHahrMvlY8gQ==
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
	by m0409411.ppops.net-00190b01. (PPS) with ESMTPS id 4crx87uk4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 10:34:45 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
	by prod-mail-ppoint7.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 62BAY6ja004673;
	Wed, 11 Mar 2026 06:34:44 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.220])
	by prod-mail-ppoint7.akamai.com (PPS) with ESMTPS id 4crg80051x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 06:34:44 -0400 (EDT)
Received: from ustx2ex-exedge4.msg.corp.akamai.com (172.27.50.215) by
 ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 11 Mar 2026 03:34:43 -0700
Received: from DM5PR08CU004.outbound.protection.outlook.com (72.247.45.132) by
 ustx2ex-exedge4.msg.corp.akamai.com (172.27.50.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 11 Mar 2026 03:34:43 -0700
Received: from CH2PR17MB3797.namprd17.prod.outlook.com (2603:10b6:610:80::18)
 by BY5PR17MB3857.namprd17.prod.outlook.com (2603:10b6:a03:239::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 11 Mar
 2026 10:34:40 +0000
Received: from CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2]) by CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2%5]) with mapi id 15.20.9678.017; Wed, 11 Mar 2026
 10:34:40 +0000
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
Thread-Index: AQHcr+1eklEgHPr7TUGT7iw+X10ZcbWmpDOAgAAsNgyAAKuYgIAAKNeAgAA99oCAATQqgIAABJcAgAAJ3wA=
Date: Wed, 11 Mar 2026 10:34:40 +0000
Message-ID: <0A734214-9E4B-4A65-AFB1-055883639358@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
 <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
 <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
 <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
 <83842620-AD01-4619-845F-8DE7DF1F8F31@akamai.com>
 <0a652e7e-339e-4f98-b591-7fe5680e2006@kernel.org>
 <6CBB0401-26DD-4EF9-949C-54BEAD3ABA33@akamai.com>
 <5fb9beef-b6fe-401a-aa24-aade48b795d4@kernel.org>
In-Reply-To: <5fb9beef-b6fe-401a-aa24-aade48b795d4@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR17MB3797:EE_|BY5PR17MB3857:EE_
x-ms-office365-filtering-correlation-id: e471aede-26da-4f3e-cdfc-08de7f59cd58
x-ld-processed: 514876bd-5965-4b40-b0c8-e336cf72c743,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|6049299003|376014|1800799024|7416014|38070700021|4053099003|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: bRwi/d7TFlErtltMW/lA2hwkLKFb7sSwDoK3vUBUyb52Ryn3DoAR9YMp+Z2zoeIxzubqmBRtzBq7RWigqVxXC43eLdqBouTnOM5wwtZ3qpgVAV/hOP4ClXGTYI2dEvdnHBX/16rCGiRxF+VxDcagt5Soo3/KhZhILFkQzCyS41Bqg6tg6SITTPtWE57ydH0XDfjg8Vq9I+OnvMzqImggnhi3rK3ZSIcudQpTRjtL5nZaKZ48631NI6kZc0xP33hQCTQXI9+RoKg+kxTC+PKAH8+hMC8pPCG/hDCOd0IPLgEDobY0dNrKkmXr6+MEhPCBzXS8p+TsniZipd3PcF1k2zqWexUcbyWNMfF6Av7dxF1DoyS3qKEFUr4ren8+f3AIT0mS9JVY3jCVEy3QMSVWBldVGXZz7yZsso288mm9rELgsJMfaVBVM+VvRIgxXTkhJdg2yaH2gJaIlv4gcyi6ogafopuSEZCsGDRUrBOLXV1UZtwbPsA+dt+TxOdMShRN0MXLiElxoCtoDntyD3fUvM0dLSqc8rfP38y+HgB60H9tVrhQdMJm8kJFdasI7MIEJS6rq9syHRMzuy1AHbgjL2e4IfJ0eOBMjKMviFNtqUlDWH4rbv/CUsQnkUrmnqPzDL7rFZALRWCT+jpm5DU3ZdPvcKSXXgdt3rB1OsKEKNILir/Y7vlHC07Wn6NOC09Yc8tftnxvKezxPxoU13z6KfAr73jZEmMDLB+1+IrV83KraRHAemfXQcd9rHcVFHsKNwIzI2KlTgZTzGPLHr6d62ItyVJE8Ul4mBJEQqK28fY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3797.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(6049299003)(376014)(1800799024)(7416014)(38070700021)(4053099003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WERVOXBHYjFSQlBtM2VFVXRIYUU2QVh6d3d1NW9NQ2tLU2xqQWdaMUxyRlJm?=
 =?utf-8?B?dUVwcmRtRmNHQmFMZVFudGJZeFBWMkRBVHVVeEFkUytETENSVVp4ZXZBWVo3?=
 =?utf-8?B?aDRvNGxLRUpIVFZXb0Vxbkd0eXVvUjVWNUNTcWtsYmhQbXRDSTRKWmhYWFpY?=
 =?utf-8?B?cGlvYXh4SmRiYzBLRkhWSlJxbXJmN0k3ZmN6VHd1YUVTUUlrbXZxSE91YXBI?=
 =?utf-8?B?b09kc2txQkVhYVRzMFR6dXc1MThoMnBlTTJ4RjZlNW5zOXh4Q2x1V25UblRk?=
 =?utf-8?B?TVZaTUtSeUN4dVBzZEZlcGhpNThMS2lGUXB5UzZjL1hTUzRuYy95cTFUKzVS?=
 =?utf-8?B?NmdvVlF6SnZWdmc1blQrcnR3OGxMR2NhWi8rQmNrQVFuKzJvS25FMzZjK2ov?=
 =?utf-8?B?NXNkK2NKa21ic3JhWUQ4Y1YvZjFFT2Y0cnZWdVNFaFdOaGpoZW8xT2QvU1N5?=
 =?utf-8?B?VkNMSnBBVjZRMjNQR2xqNTkxMVlJU1lncWZwdmVNWDNNSkwwdWNyRU03WDV1?=
 =?utf-8?B?NXpWLzdtYlVqRVhNVUVtRS9ma3dSRTJ6UGtsdFU4VlZHL1NXWmE3VnlKTzIy?=
 =?utf-8?B?UjJQUGNqelhkZVpZQkg0SHhUc1VqOUFDbmphazVkMktIS2lweWdwL0JaWGVi?=
 =?utf-8?B?MXNLQjVVT3BEZWlwWXgyL29mMGVEYnVpRUZOcEJuZEtVSk9ieEtOeGREdjZ2?=
 =?utf-8?B?cHZ2d0VOREdEbUtBeUhIZWZBdXFwVWwzUG1kd1laWi9GWDlJaVZDdUkzS2Zh?=
 =?utf-8?B?cys0VUo2My9LMGRqWGI3bHhRdjY1Nm5kRFA2MGt0cWp0dkZBcGdhNFVEOWRs?=
 =?utf-8?B?OTN4dzYvRmJuN0Nzc09Sc1p0NGVzaGY5VitlUVNDWEN1TjV3L3B5LzFRQkFV?=
 =?utf-8?B?dlZuWDNLUFBPV2ZZZ1hNZE50N1ZWSERNakRQOE0wZFdGbkFUQUE4dXFXZys2?=
 =?utf-8?B?OTJaMHpYREdJU1JkTmVPT1RXV0pBNmhLTmc3MEVPRU9oVUd4dGozWkZVUko2?=
 =?utf-8?B?YjA4WDVMWUIrcmdnTFdhLzJuQitvc0ZEWk9MbWZER0ZOL3IxRmxNQnBiOHgz?=
 =?utf-8?B?N2Z0Z1VNWjZmckhvNmU4NU8zbHBQcmIyb2RNcE5FNmcyME8vSjRiZlNzM3d4?=
 =?utf-8?B?c2o2YWNJZWNLYURsUzY4RWVWSVlYbUkxd09Va1dKd3pRRVA2NlU4ajA5QjVy?=
 =?utf-8?B?WnFnbzRUOTA3R1NDWnpPZ1hCVjhMRWkra1pEYm03V1o2T2loYWMwYUFPaWJ6?=
 =?utf-8?B?MmVTVzRJbEIrU2tOZkx5TEFIK1V3YmNXOWU3RVpTUnJCdHhlaGhiZDNtMmN4?=
 =?utf-8?B?WDFFUGk2anpJbDZPVWk4SUxRc290NDl6L2F1T3FaQXJDY3I0R0tOTnJzSUJC?=
 =?utf-8?B?NTRrZDd6MHNPTzBYcWZiVnYwMkJvclE4WEZhSGRBSzQ2QzZOVFN6bkVKQzFC?=
 =?utf-8?B?OVBFRUJ5N3M2elJHTE5VcVZFZDVrWXN2TjhobDRJUTNaMjNkSHgxWTBLNkRn?=
 =?utf-8?B?NkVTTGxSS2VjNVZOMHlTdWxyWWhtUWdBUXhHTENIeTJ1VzREcW9OV2QvZFBH?=
 =?utf-8?B?VXhLMFpmekh1YS8zZFFCQVo3TUI3MVlZRWt1TE5mSE9YZUZkUDhhbWZIZnF1?=
 =?utf-8?B?NjY5YjVCVER3Z1M1Zm1QSzAxYlc3clduRkdlRkpDZWEvLzJFbGdudG1zQW1E?=
 =?utf-8?B?bnhRNFpUZkZhd05XcWx2aDBtTEY2d2tRRytmNHhoc0o4WUphYk13UTVJM3kz?=
 =?utf-8?B?TE1kY0lmVnFNa0Y4TG4xOWYvUEtJcnhud0RKRWxaM3ZzbFEvK3ptZ1lJdjRD?=
 =?utf-8?B?dTRTeGZIQjdhUVpieGp5VkVDNG10R01PQTcvOG04dTNqeXlZNGM3NzJLMTgr?=
 =?utf-8?B?Tms2eDE1UmJuSkF6WStFMENXYjdSbnZSM3pkZ3k4YkdUWkhrNzdTQ0ZjZnFF?=
 =?utf-8?B?cDVuVHIvQ2hRYmNTWnA4bW5wbU9yZGVuNk5hbWxoN2RTZHh4bEZvTUNLcEVz?=
 =?utf-8?B?ajQwWFlzOS9qZndsbnV5cjZzZlhzbHlubE9Ic2dzMG5ib1pJQzU4SEFPc0NR?=
 =?utf-8?B?cVdneHVTSXZ4MG5WQ25ud2UyWnFqTUp3V3VYK00zYktwbGVpRjZ0bEFNMkM1?=
 =?utf-8?B?ZFNJb1VLNzlCeWVWWXFXaG1xeFNLTW1IU2FLNjQ2THhDSnhwVmhYR1JKRWI2?=
 =?utf-8?B?U3pvYUFhZlNHN3BGNFNmS3J4TTA0djFVbzJDRkVXS0ttT25tcWtiKzMwb2pR?=
 =?utf-8?B?VE03ZmRsMmZsZmYrdk1vb3RvNDFVN3JqenZnNlFDSmttTGVtOFZ0OWo5TTUx?=
 =?utf-8?B?eXJhZ051dWZUVDhyRzFqcDA4a3grU3N4aUt2ZTlIYjA0YWVhOCtkZz09?=
arc-seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pmLlXbk8kf8zEI1bfSs3HqmhpB6TQJ/7xTwuxPisC/uxdw6inZj3dsDwh2+fOaSV/N6NljO9doE8nr6GDPwkCBeNere6sPN0x2TxDpL69HbkVofC4JcS5NgiQ44ze8hpiRol2lMSw9loUdQhL0p++EyjPL3Md7t0woY/w0rdKg2cyexFO4PVGinF4W4kBaYRt577EaZvt8xSmWnj2tWbnvkCktUPE176VhMkYDjpg9H4XUUo7api+96ZyGG90fIKcJu9KHknkaM9X/ppTxWNuMPzzIWwslGjVS+2mJcMkmGZYmtyw5U+D4qhu7w3Yto4moVkatZ96zckhEpmEoU0TA==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4Ijub9RgJwF1Vapezl+zkncrijwnnbfr3x25HI9aVw=;
 b=avuuNhGz0cuhdVuFNPM20MLUes8I6BKPxZ1DrJ8oUsxKq14xn5IE2niveqpe7HDSErujgLV/VCgE5wTswZ/0J6S7SWTwPtR1l6VYtQasL9F3Q1qE7wpaBJ4QQm0eGS9T1+q/KDTNwhdnFxj1QT84bjXecj6Hb67dHXWK4/vZsfbTd7weIQC8YQPw1Q8dI66Yv3abl0TauqUAwMUA1i/V233kHi+n5O2PH2Wmr0Vp6tF/L/lLdskGyNWfvj9fwYL9tcdXI8EiI/Or9oYqyqFfN8dXyDJRrdZD/5WC6GOdnvoPvuN65EVQJ4giiOSBdurTwYlOP1eGXK2chCbrg0KwHQ==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: CH2PR17MB3797.namprd17.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: e471aede-26da-4f3e-cdfc-08de7f59cd58
x-ms-exchange-crosstenant-originalarrivaltime: 11 Mar 2026 10:34:40.7018 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 514876bd-5965-4b40-b0c8-e336cf72c743
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: xJp72VVSeSmJiQBx9KB4alp4ZzTc3JNtn8UCFQiwOp5KXsCSR1/mSA2XS94MXGJOheJSxg7hc2vmcZc3IihE6w==
x-ms-exchange-transport-crosstenantheadersstamped: BY5PR17MB3857
x-originatororg: akamai.com
Content-Type: multipart/signed;
	boundary="Apple-Mail=_C9AB1496-4264-4194-9482-1C91D0A06859";
	protocol="application/pkcs7-signature"; micalg=sha-256
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=942 bulkscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2602130000 definitions=main-2603110089
X-Proofpoint-GUID: x4w5Zl3F_EpeRLGbhUzOCKH7zhDMEcuO
X-Authority-Analysis: v=2.4 cv=RoDI7SmK c=1 sm=1 tr=0 ts=69b14546 cx=c_pps
 a=3lD5tZmBJQAvN++OlPJl4w==:117 a=3lD5tZmBJQAvN++OlPJl4w==:17
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22 a=XKgOefoLEnF0tNwW78TB:22
 a=VwQbUJbxAAAA:8 a=fa4XDqL16vIEIxEkZvMA:9 a=QEXdDO2ut3YA:10
 a=aUQEjLJJORIxqg3IqZUA:9 a=ZVk8-NSrHBgA:10 a=30ssDGKg3p0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA4OSBTYWx0ZWRfX4QhvUVD2vLEW
 QHx0lU7T4afSWUOkqTrLM2Up82cr72tZDSorRUmH9QhsNwCJIwx2slxNwE1QpDdvRRq9LkOGppl
 jFxgXcRazYk2ao7nAEX+tCVWuRH0Syv5zaROHZ6oJAC1snGt4N1rtZqiPxaH5pJnozHmiEoU/LL
 Uk3anW8JY3V68sqWmJo4lm296wxBHVgls6u6yD1Co5hTK7j17p6ruA3MboPx4B5nvuB77ODEjq/
 xfb75GL5sXpojTbPodBPgeoxdH56FbrAAvBFeqtL+N3gr5wVXkIUPYXUZT2Ir9nSua8+xx4/mtw
 8G4+32KiT53iM4hNyQoxs6Y868nUq5hGKCepXg35NaSgN7dO82h+z+O/fRvH/9TsbhCtZ6EDop0
 tR8zF/7EhDpJyDks7FkGkofaC6guoUUFyERJF5eU39xapr9Dp7GgLIF8GO28deW7m5dwS3WMneh
 ucI++QnPIM787eptwmQ==
X-Proofpoint-ORIG-GUID: x4w5Zl3F_EpeRLGbhUzOCKH7zhDMEcuO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603110089
X-Rspamd-Queue-Id: A8CAD40007
X-Rspamd-Server: rspam07
X-Stat-Signature: is9ecwe5uwsaatrs5ydw5dxpqitmg68k
X-Rspam-User: 
X-HE-Tag: 1773225296-885767
X-HE-Meta: U2FsdGVkX1+xGbAzf+7byaFQj3wUl/uMuLkWfFe/sTor2MfKK6c1CpOzFVnIIR6d2plLUr/0BCRi30BpNxE7tVBopTSAJcArWY9zXW4Kb1zMORfnJmwvM6LWlN+dO0sqHULHLcrByUWPz0uLWQpo4LtfYmUv8ny4XX9AkqjdhOE5+Va2ONXXBlu0/92ck1yncjS8hsax+sTo86NXcYlePN6AJyDMnanN+poGml0bSBqwAOtBPoPf7sIL/R9OsNILddm61QgPXqPG87t6z1N+8Cp72uM62yL7JKAqBpNsEHq9HPv8jItYaMwJPeRxFzagPvJbXfLPzkgnJ2lL1fr324CTigcnMqIhDUsphsgDr8eRSypLBEVzmwrjOUGxmA+OcWk416MXPNibar01w3xMj24vUu5erBUIFc2cOsjO3sAoZjlTsgzf9XS+wrvCNUZoFVKkNldn6MDp+OrrzykxYgFS1V3PDiK7+5gd5ZFPMZv1ieA9P8ctmuznnZjRKl91ygn1FpBqiYHJWE8eZizp/FoTwCqQAFGGDRKOq4YUjDJeGDVwnFu2A2zdEH5+TYltxDrgiZkw+VkH5XCEWULFUj/CkrPOfaS2ubQ5VY9u+ivGn8rElCFbmbda8Jh+Wuin5ZdeX+AZ1aHI3ye1aROT3AI1WglW8hi5CT5mAVqdOvUi226vZWSFAfx3ANBf02r4D7IIdMkuF5dPkV4ci44KjYerpjYa58oBAvo1ZqMcatPmxAhAa+v9sP9ipKmgcQ2UCuJKrHE5hvLabycEeYpM0KlKjPbYbC5zbJlp++5T08sK6UEV3N4n8K1nNjGIWc5SoEkj2UJUBMU5pJ2uNHLbihMM8W6OuT36qj9aiwAWvUhoNWBzDOn45eVuePPVfB1fwtyRXdWjS1vmtPCRhOi/P+UjVlCCscy+zZwdbVChJQSMVwe1lNAmydH8ClUSOyRA9H466Ti6whZze71lbg7
 HDB49r0o
 o1Y78cE+Qm9ofWkULnMmC9VkGsN6TIVooVuy/f8o/KHT30flvIJFkIWFMrKPAm0GoE90661buU8/srqg7mIQGKvcZKlzqcOun7H6RvPqo9GDQrZYop2L/IPqctWga2x2eaoVni8t5kbx9lnp44ER3fDON/5Yq/huezE6Ko41gYBoY7IxklIEdiiD17dHA7Q24hlJzQ6JZOKIqK+xuazlnJId9t4WbRSPWAqC/GW2F7QAGHiSup05MNu+TF8iyi4d3VzbV4Pz/8b5/jZ0d1/8RGMausYFCYL2JZ16rDNy82qcCCR0zFmDhsHl47lrvJ624Gd4jUiApzUQu0yXc9cQHimwxxHu7SLnySt/0vxtBkybs0jGf20ysqXuiQ7fbayZnppykln+N8HtIUkfnWciyzcf3LBw5Ysq1ivebW17DUDeUdegmiSXfQ1g+/E+RsW6C2jqxMHECW5ybQXeyA4S6Z8ME+exVbMrEFaAsxIaeLkvnKx4t8Z1qVyfYif9dpPEb8FUCYy7Z4RlMnymlf+HrhsYrXu22Nba/KR0ZW1NOo5/Ni7BNB3X0dupqQf1RiLfiki96Dnv+J67lz13jLSeVxWS8l5jZtd4PCrRmqNOgAFm4BMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Apple-Mail=_C9AB1496-4264-4194-9482-1C91D0A06859
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Mar 11, 2026, at 10:59=E2=80=AFAM, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>=20
> !-------------------------------------------------------------------|
>  This Message Is =46rom an External Sender
>  This message came from outside your organization.
> |-------------------------------------------------------------------!
>=20
>> The -EINVAL originates from:
>>=20
>> vfio_dma_do_map -> vfio_pin_map_dma -> vfio_pin_pages_remote
>> -> vaddr_get_pfns -> pin_user_pages_remote (mm/gup.c)
>>=20
>> Possibly that=E2=80=99s also the origin of the concurrent PUD =
modification that requires
>> the retry in the walker in this patch.
>=20
> We'd have to find out why we manage to trigger a -EINVAL here. I don't
> see how anything that this patch does could trigger that. So maybe a
> problem in user space? (calling it on unsupported VMAs?).
>=20

It looks like I was mistaken the EINVAL being from =
pin_user_pages_remote,=20
rather it originates from:

vfio_dma_do_map
  -> vfio_pin_map_dma
    -> vfio_pin_pages_remote
      -> vaddr_get_pfns
        -> follow_fault_pfn
          -> follow_pfnmap_start (mm/memory.c)

In vfio_iommu_type1.c, follow_fault_pfn first checks whether =
follow_pfnmap_start
returns an error; if it does, it calls fixup_user_fault to fault the =
mapping in and then=20
retries follow_pfnmap_start to obtain the PFN.

Sounds to me that the walker is likely re-splitting the PUD entry =
between=20
the fixup_user_fault and follow_pfnmap_start calls?=

--Apple-Mail=_C9AB1496-4264-4194-9482-1C91D0A06859
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
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYwMzExMTAzNDMwWjAvBgkq
hkiG9w0BCQQxIgQgF8w8w251LSRUMrzXHAR6b2Uyo+8XAOIGqviVAIII73EwDQYJKoZIhvcNAQEL
BQAEggEAvVBsJJ41Key+7Nzl+iiQ0zfteltZotdhrzpVbqq9v45bMSG7ORsPqdCKafAMCurqPGlt
O0kIDNNlE7SIjTFT4zdpVzfrJriVMzGQgKNcXRQX5r1jIF5C8k0NpmpYNBvsZkkFB+RP3SJI7beK
Cdb18QFWY9xdATH10A9aCnS071++W6BzTFMCrCqCuG8a8EwoSdj83iysHkDBvjkrZ4QLk6xYGbJj
fOi8vmDFQoZhmkG9oiXO+/eI4yYYUWiuPkE5xn1miyiCuxIx1DZQD58n3zJxZ+BRkOjPgoE0jbjv
kZoif6/Nnt3+wGP+q85EC7sxQLsq3kQthLOFJvm8GFYSxQAAAAAAAA==

--Apple-Mail=_C9AB1496-4264-4194-9482-1C91D0A06859--

