Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555F9EB1050
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5676B0088; Tue, 10 Mar 2026 07:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5534F6B0089; Tue, 10 Mar 2026 07:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5436B008A; Tue, 10 Mar 2026 07:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 296C46B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:38:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B434C160149
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:38:33 +0000 (UTC)
X-FDA: 84529955706.21.9D29C46
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id C1FCA80009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:38:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=J9UIx3kv;
	spf=pass (imf30.hostedemail.com: domain of mboone@akamai.com designates 67.231.149.131 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773142710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aK82tHj9oOyBu7fkmobkw7fE8udZGJVz02kG6XMfO84=;
	b=AUTkFKaqI1RTQBGuS9T2oNuB4sg8nKhhploDHyzhGHaDtWhyrOkvJavahXqEgt0/QNxNkS
	usbhtNYqx9Se9JHcaDIEKgsRsNXRUnabbwKypinki7RXsSkukI8J3t5dMXQvNWoxWoxif+
	LWhf+wPvL2/qXTPFCBMdlyPziWQ7Gxw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773142710; a=rsa-sha256;
	cv=fail;
	b=d2rOuTiU5HxD4NHKOJTxqwTw8fJZy5SjmJFVze/mHXHY+fZ8CxU/deAB9yYBF/yUwIi6Xj
	+PK2lvui8K5N/n3qhf+JDUOYAaJq6cI32c9BR5FRE+e7N9ure0hWOYkU5EN5lkq+CVrb8E
	tI73q5OGRcpisWB3cLpaBYFgtf4tnNw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=J9UIx3kv;
	spf=pass (imf30.hostedemail.com: domain of mboone@akamai.com designates 67.231.149.131 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0409409.ppops.net [127.0.0.1])
	by m0409409.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 62A9L78H2061176;
	Tue, 10 Mar 2026 11:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=jan2016.eng; bh=aK82tHj9oOyBu7fkmobkw7
	fE8udZGJVz02kG6XMfO84=; b=J9UIx3kvXeKO1DFa00qC2RX5vcy+WDdAJU0P8j
	3a4jUDSYmA/rIt+I4hSjoimpyB4SMF3wkg56x2lfRO3rU9GoX5mVaaKx1pAc/QHP
	+K6ac7VWOkqOJz7jbh4Nbq4g7yCZKV7CNWnegHFpcdiAUCGQ7vzAMdc18je/GwxG
	VPv2qxfPVmyuMbCfSWW9Hvti4Mn8gh+SgwbSGTsPRxBRuwvlpsdYWi/s9hCp26Iy
	iTO6/Juhtsck5Hzad/Sf3UFJcajnjKFUbFcOWNmSPBIJlVapeYlGAOW1j8x1meLa
	4xcABSVaqlLXuccdmBBg3Uw76ZYV5lTC8Wcc7FeX5SqHKmIQ==
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
	by m0409409.ppops.net-00190b01. (PPS) with ESMTPS id 4crx7t9gna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 11:38:16 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
	by prod-mail-ppoint4.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 62ABXvjW026656;
	Tue, 10 Mar 2026 07:38:15 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.221])
	by prod-mail-ppoint4.akamai.com (PPS) with ESMTPS id 4crg7yyuha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 07:38:15 -0400 (EDT)
Received: from ustx2ex-dag4mb7.msg.corp.akamai.com (172.27.50.206) by
 ustx2ex-dag5mb4.msg.corp.akamai.com (172.27.50.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Mar 2026 04:38:14 -0700
Received: from ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) by
 ustx2ex-dag4mb7.msg.corp.akamai.com (172.27.50.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Mar 2026 04:38:14 -0700
Received: from CO1PR08CU001.outbound.protection.outlook.com (72.247.45.132) by
 ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 10 Mar 2026 06:38:14 -0500
Received: from CH2PR17MB3797.namprd17.prod.outlook.com (2603:10b6:610:80::18)
 by BLAPR17MB4195.namprd17.prod.outlook.com (2603:10b6:208:27b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 11:38:11 +0000
Received: from CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2]) by CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2%5]) with mapi id 15.20.9678.017; Tue, 10 Mar 2026
 11:38:11 +0000
From: "Boone, Max" <mboone@akamai.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        "Suren
 Baghdasaryan" <surenb@google.com>,
        Michal Hocko <mhocko@suse.com>, "Alex
 Williamson" <alex@shazbot.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "Tottenham, Max" <mtottenh@akamai.com>,
        "Hunt, Joshua" <johunt@akamai.com>,
        "Pelland, Matt" <mpelland@akamai.com>
Subject: Re: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
Thread-Topic: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
Thread-Index: AQHcr+1eklEgHPr7TUGT7iw+X10ZcbWmpDOAgAAsNgyAAKuYgIAAKNeA
Date: Tue, 10 Mar 2026 11:38:11 +0000
Message-ID: <83842620-AD01-4619-845F-8DE7DF1F8F31@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
 <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
 <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
 <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
In-Reply-To: <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR17MB3797:EE_|BLAPR17MB4195:EE_
x-ms-office365-filtering-correlation-id: fb01ccdb-3ead-4062-4eed-08de7e998275
x-ld-processed: 514876bd-5965-4b40-b0c8-e336cf72c743,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|6049299003|38070700021|4053099003;
x-microsoft-antispam-message-info: /x64rFmS5yG/cdF3KA+WlHPmMfVUct/Vi0uCevELqyrL7EHph/cneYNgeNUIU5iPOKhV+wXgydXwhaFun+zsrsjQp27vqvDYyf5xLwtoE66tCYd6kcuZm0aofpMaUh/6+dbz8LOoP3W1+kfnUKYfPi+ShLXIYwRWcFDVxJa0mrs6Q/JftB+wVsmPmkbOJwt69NMKmfaO81U362j/Qphz/wz/jogFe3EGrQecm2WGv9DAS6MBW7G3nExz7jEjCC8zd9U3DDS5CHI3/X2Thh9XqfC/YPG0xCEaNJ7P0QVKijOCWR9hIS/9GSS28RkJ1YrfpM2bUCxlL27VLHFrbSEt1yDtDL5tnMrsH4NIKopK2ukhEI66Pim/D5eEyNChVcv9Wws9g77Y62h+9i6/LmoiHCbMLscCMeMQuNwDkzRXw3h1L5hatszN2GDz+KKksR0UyVMzB08Fcb0qQTWXd1CmfTMwc8kk0+dVijJt+/bMt7R+qhQkMlS2VgjcBJas1IlgMui3W817ijVPA/HWUIbmBe2cFxl/zKGqTHU0Uj+l0kGMVoEaFEHjrjro1kFfxH7jZalGOl+45eqYonPpJPZt5m47/s1VXrQhZYFHiivY/Nvctu1x618xYYMX3uPP4CPO8L8zvAq0uDLgfNoSCuwFW0LoYWj6VOiBSYdaD3dVe0WmxX4sm+Kc+tGK7qcSAlxUquk2GO5TAAXm87A8pvB4Yl67E3hJ9lk/TMeXc8WVExCwq+fYGaQRNsNV7gi05I41RP5OUSGeRaPs0Jk9QhiKMPRv947nliVPuBpBEoplhwA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3797.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(6049299003)(38070700021)(4053099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dU9rcWlodXlCWjdudXl0QTFoVVU0Tm0vVWF1amE3d25DbEtOZ0FrYkQzeFhv?=
 =?utf-8?B?bWVMUHZwWXJzeEUvSHpNYW1jMkNIcVU5OUg2cVhGMXYveVl2TVcvd3JoTDgw?=
 =?utf-8?B?U2tBZldZakZnRUV1M0NQQmR5Rjl0L2tNNFhyL1dPb1NVZW0vSzJ3OTVpZnJK?=
 =?utf-8?B?WjJlWFE0bTVWNE5IUCs0dEkzVlloT0FGcm55MHU5WFBpUUdKUnpacStvTkJZ?=
 =?utf-8?B?emdVSWJrK0NaZTNpaDZxRU9BNjcvTG15VXdWMGI1aVgxN3FQc3RGWDJ0Y3Va?=
 =?utf-8?B?cDB5Mjd4blNXRlY5cEViZVZnSXVZRXFmSTdHOUd6K1d2eERoUi9yZjhFMEJM?=
 =?utf-8?B?SHBvdE5mcUhUdWM0STIra2p1eWZZTFZuZ2pET1JWVTJUMmkxc3E4NzE3dGNs?=
 =?utf-8?B?RC9OMjU1Mk8vMlQ3Q0JIQ1ZuZktjQ2VqM2Z3elJESjV1TUZTc3JEbVIwR0t5?=
 =?utf-8?B?SXdERWpMS2pVOXIvY3VIdEcvRThXby9XZnVYTUVMaTdLL2cxU2Q5aG56bWVS?=
 =?utf-8?B?L2pKQVk5L2oxaVI2djhGbVhPNEx2cHordnZNTEVWRS83TDlFMjhZTlBSVDA2?=
 =?utf-8?B?ZnJSanFha2hEL2luSDlrWmdUWWlUZyszL0F6T1FTdG9YVHhOS2FCQkw4VVFh?=
 =?utf-8?B?RDJwTWh2bHdkMmJvUFNiSWFwNnJzeTgydnlFbTBoR1V0blBXcmZ4cng3dmVX?=
 =?utf-8?B?SmhEWm93QzZON1NlU0YzZ3VGMDFFTWhJZEc4eFM3dGRSYTZtS0tJa3FEZTJG?=
 =?utf-8?B?YWlyMTEzWmQ5TDN2WmZpVVVTTzdxZEpaS2Eyc0VVY0RVRTVWZm5DVXBDZTlH?=
 =?utf-8?B?RkUzckY5Zjl3bGo5OVJ6cW1FdGNLUVdiaVI5L0lDdG81T3l2UVQweTNyVkhy?=
 =?utf-8?B?aGtXTGJHd21MZUFJRkU1dHJjWXNHY1p0V2lvMzI3YW9uaFRFVkY0ZVVVS2dM?=
 =?utf-8?B?OTNKM1NQTnczdGhMVXhqM3dHZVl0ZGhFQ1hKc0U3U2sxVlJNZUVWL1dOWUtQ?=
 =?utf-8?B?bjgxRXltbzcvSXVwdm9HWHdIZTNqQU51cmh1eFUxZGpDWTZ5TmJvYUVyZjc0?=
 =?utf-8?B?a21nMDhaUHo0TzJxNmdZeFRyWWF6YlgyaTZQYU12R1A0UHl1ald3OUVNbjNq?=
 =?utf-8?B?L1NCeGdyTVR5Y1VxYkNHWTVGeFVpMXFxa3U2TCtYbUFKNVJqMUdObFQvR1lw?=
 =?utf-8?B?ek1jZWYzNmE2LzU0Tk9DZjZDOUJVVVg4Wm1SRDR1NEZBUjZreTZVa0drbm1K?=
 =?utf-8?B?a0ROdjlUa0U4ZG9KSDRKdUtERlVMeTNUQmtFTjVEcVRnWGtEUy9BNW1GL2V0?=
 =?utf-8?B?UUNPT3E1by9vclJlWExnZlJ0RlJ2c1FhZ09yS1ZZMG9lMGlKVTU4UGcwZjI2?=
 =?utf-8?B?VGV1ckQ3UlJVVysweUZENXRCbEx4S3Z3RnRqRTFVYXl1UGJvZTBUWkFwM2Ra?=
 =?utf-8?B?SlFhQzRxUHpvVDhBWUtscUlaQnlsZFlhU2Z4VXdSaU05a05DMi9TTVFybHkr?=
 =?utf-8?B?TFFkcERZcWxyQUwvZHFuUFYvL0ZTMzlqdXpMRmpJdjBpVk16aDdabGNPMHVL?=
 =?utf-8?B?TXRNeXRpT0R1Q09TVlFMZldHZnlDL055TFRjcU8xQlVvRlMyQ1JjU3RyeXl6?=
 =?utf-8?B?VWFkbjhZSEdlcm5wUktOSUZ5R0tPdlR6YjdqRmpoRWxVNjNFd1VwTDZqaitK?=
 =?utf-8?B?TWkrZkYxbWE5UHhYZG5mQ2FaUjk2OWFTYyt2SDhiMWZvV3lHQmFldnYwd0pH?=
 =?utf-8?B?elU4clpuaks3YmNnVDBTRHRaeDNJU2RKTzYvLzhSVis5amRWNVJhT2VrZDFo?=
 =?utf-8?B?eDdnZGdWU1JhWTdvV1g2RjJnT3g2WW14Sm8xOHBxamdKZ3BuK2czbjZ3U0VF?=
 =?utf-8?B?SWtrdlg3OHFVcENXVVRLZVRQb2M3K0lBWHFGVnZKTG8wdjlkbE02Zkx0eUky?=
 =?utf-8?B?U1pUdENmTmpsZ25qZTdOWjVuMmd3a1BRRUMxbGsxYXMxcy9tUC9pWkczY2xX?=
 =?utf-8?B?ajhkalAxN0NxdUhxTms5UFRVSFEvQ1MzVG5jUis3UmJjOHNGTmhwVlZhcmdG?=
 =?utf-8?B?YUlaYTk5SGtjQ0xGUmRTNFcvelZRMWNBTmJpN2hkUnp5VHZxaUJ0SWtYNW4r?=
 =?utf-8?B?RGxlZEgyZktHMXIra3FhbENrQnRRSEloWTBxbm81bGN0d3BTQ1dkZW5IN3FZ?=
 =?utf-8?B?TFB6NzdFYjJVYi9vbFlXTEZqVis1WUtoeGFPVVpNaEUxVUh2WVRaN2xXQmVD?=
 =?utf-8?B?Vk13eHVoQmRJUlJNN21SN3JZb3czSFZIeEtNcmJOSm51V3lQNWNZU1FCcThD?=
 =?utf-8?B?SlFESlhZaTVhcmtyejZ6enQ4R0RUY0pmeTZ1cVBZblE0MlVZUHVtdz09?=
arc-seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ejv3zucQrsadeauZ/ta++swC79yEf2/VaonXpVi4/183aZw00NOzD7MsXWaQWkN/Tj/IUnYe96YcSoDWrzyarC9zHCboKNfR97VUczgPp4VXE1BHmF9HqDbJYtsFOHAOPMAG48NI7XBNdxwtN7WKJmx6VEOhYeI3Z6tFm2psR57c8Gvy6fd4VmWhB+gsr3YRhnFwV8d7f7ohXtgkDopq7m1+BpsS7TBsd3p80fxRfjNmPv2Mqxx0SMMqkb0flHFaS30LYGR9O1co3ZRMl6GwK2HK7otmaD7Txv1KIFMPkywhZ1BKQkyYgZ75340UrDKw0kTBlgVOyK3v6shGg9Mh5w==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47YnjLcoEb/YWUAZozN8VIE1u4Fxzw5hmwIM/pN3rpE=;
 b=PucnRFVFRHWpfQEf+vivhaar/MkFBBMzOYRGDYgbutAhYDmMCqEewl5O4WsgUEU7oaKNH2TeLuSSbpU5w7NfNa8/aL70RsjrQ4R9RbTOEUNspdRSr+tVZObeEzyNBKhte5pyiso2dDI7sLNGwTMInTPqiB0iNSXY9pWUk3liJYBQ1YQJZM+eE8KuuXmzO4QP6VXysKzxXeCxmAUFEWKZHRHRblRJE95qGi+9qmZ3304P43pAqCeyOaWJLz6greuPx14Egxqrftg6qhMkjpUM4Yq1T8ve4ZccHI+tzdMepCEMkF3pn/BX63FTJaULI3fNS2UC38p/HmxUe/vovNJg7Q==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
x-exchange-routingpolicychecked: MO//t6i7bUQIhq1U7fwoHvoPeQYE7GP8vM8c7eG7XPJsZu2x4EhPTOyL3e991GcrypUoTYQAh737ZzAlVq+JwfV5/+Kn/WOV9AcCxbeF60GyhNkj9f6TdKVuWx5nVc+53u2hQEfkOs36ZmKS9BxUKycjdCYaSeCrUmlHT8h+okQTHRAlJr+/HB0jG//RgsF+AZe+XVuWyQ/elZYE4+VE7LobIYJLcBLW2qmaxO4ZdZjxSFq+0rfClfFvHw1x7luufFh0kwVPPoTNi6C5WdG6GC4u5v2xJ74tmAD8bVkzDGigJXaxTXlRudfW1GhRBXeFIBLbdGlxLFqXRVAkY1mDQA==
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: CH2PR17MB3797.namprd17.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: fb01ccdb-3ead-4062-4eed-08de7e998275
x-ms-exchange-crosstenant-originalarrivaltime: 10 Mar 2026 11:38:11.6635 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 514876bd-5965-4b40-b0c8-e336cf72c743
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: ldapG64o1OcEJ5IpRKKxGxK2joKkvyIMD/yQoHw6uhTiwymr0nkdhSNjkF4BVV1MCLCwlFGu5gSn/XxxQe0Cxw==
x-ms-exchange-transport-crosstenantheadersstamped: BLAPR17MB4195
Content-Type: multipart/signed;
	boundary="Apple-Mail=_3068F63B-7775-4E24-BF9E-33B5F38DD1BC";
	protocol="application/pkcs7-signature"; micalg=sha-256
MIME-Version: 1.0
X-OriginatorOrg: akamai.com
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2602130000 definitions=main-2603100100
X-Authority-Analysis: v=2.4 cv=KJ1XzVFo c=1 sm=1 tr=0 ts=69b002a9 cx=c_pps
 a=NaJOksh5yBwW9//Q5C/Ubg==:117 a=NaJOksh5yBwW9//Q5C/Ubg==:17
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22 a=TTBIr9FR-UdC54aaq7Eb:22
 a=VwQbUJbxAAAA:8 a=X7Ea-ya5AAAA:8 a=UOGrEu3IzCGmyEfMkscA:9 a=QEXdDO2ut3YA:10
 a=XV0iAhCzcV9UHEWjWxoA:9 a=ZVk8-NSrHBgA:10 a=30ssDGKg3p0A:10
X-Proofpoint-GUID: flUpzGP53OHq4mOh2AM_YvS3nPty1pS_
X-Proofpoint-ORIG-GUID: flUpzGP53OHq4mOh2AM_YvS3nPty1pS_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMCBTYWx0ZWRfX6CmDOIdDFiqq
 /XTs9++Qd8kCX/GQEd4bbC56dKxBHCzcrji0+COGkC5E7C61vbBU6SGV7vBkYN+tYauKD4oa79X
 klF5Uq7hVwf0Ohrbxhocwt3A06NpFh/gJKYXgszcEyxHMscT0QGBYt2TgrW7XIkQQWIPv+U6hFn
 pf9IP2ABcnRXpDGaDxy2wGazOZF/ad8XGUbiYRUKtREpu4sB2m81m5Y4lGAS4Yybenvlq8TZPKy
 XnSJUGI3wa5MtfCYSpogim9hqrNSRwG0E99FxuJyj4L6vkeIvatcYDCMoTv/xk3qeXLieu2GjoW
 N6qg9PSOsFnsMb5ma020Ow7LQmJgdLSE/kp5kVjCOOc4Gxd48xrCZKffH1zKG+9yl9MdzaBsAor
 jDcaHq1fWS5+Aw78DyXEPtcomRXhbGNjRFd8OPsLmLak2ZBPCjGMlhLpB/Fxr3KSVeP/e8m5o9c
 P7ZPysNLp4Fs87tQf4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603100100
X-Stat-Signature: w774zrqhaxftu6xe616oqqxadrw1az6d
X-Rspam-User: 
X-Rspamd-Queue-Id: C1FCA80009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773142709-889966
X-HE-Meta: U2FsdGVkX19HMEKqhNzF/yJOGrhlmQrh/HcP17UIOam+f0T04+yV/EtcPGrfyd+enKH/1tinSJxe6pzlzKnHwCpm81qatROorcY9KWPqF4HrHi6WSMJ7lTLh2bnzP10yi5AxV7+y/Ntif5kHh5SI1ab0CyOkd7gAymNT5cL7XCY0WCNw81pQweIbLIQHagVH4bzBfW2F/+f8efuwqHuU0QD1/EKAA75XxYNgRpZk/fbaydiuInEvqDeFFyIk+dRakKf23xlwlMu3QYK/tASuUMYj/lVDNjeLGPBHZFSJIQiRC64NE39mKzvcYoI2cUrfLVm35FgJ5ET54Y4C0BTm4k4UfXR3EylionPcc7QczlrCnYzvDw45f1NUMCqvA2pPS8M5lELv2inEUCbJM/A3QANB/uoZ+rgtaeCPMG+OEWUm+A9FxMqhQR/auOlI3YYn4qYNUUG5vSq1b1fhN4xswN8ycdFdrtiBH/9IDhXGfgVKUYh0kbnJzK0PxQJ1KWWB4qvHABW/9ne35/FE2Gpe7nKnw3N0tRnbpSN6QFkSJf0FzufQpj7aJMTmHcg8mTucXTht161cPofdxmAJ0qTCQhSUYOO6puYrpIkBR/kEIBtN2nVdBDQy2/5NHCQ9EPLsoAH94KNS2ZW2XhtLTu59k5BLy4hyMLecCy0P9XZMvKb0pXVOtThEJAVSfuNcwk8cIRsi5DD+30GyIwuJkJOQj5+7CB2X2xBdqH7PyZHCiHFYYLa1Q0mkh6rJGm0jqfyVfPTT+kLS0UcwG682SNdumlUMf1VV1JT7cOsvqhTu+Id+vke/ux6ZVIGu9zHT7xK0j6ud1J6CMhPefAOUSX12GKhySjvQWOWFsziHkmf4TQbOq7FnaDf63uLKi1Y5WUL361mpwMOW1TyoiE6DNF48cbqLPZnZ7SpAM3nmmwLcr/y56DCS7iUL5zam60k+Z39xPRHcoF1qMY8eY0+RRql
 1EPG57uO
 BdqETNss1R4lMoWEETkilxunXNGuqo/FhPhgT7IUgeqr6fHkhRVSZeAZk5ozW7b1cOzDyOsfbGFFUjTBWxSqd+O7TrDN6kkhf84htGtJSmSJe53OTSVk7W6LqggLoqhCgBOghM/c8J53V4AGJJECO0+DZiJtCfrl7dscayQxmjHXwxAAmKoRHrbdXazBkdx9q3XN0VITJePScqnf/TkWdQ93BGO71dl6zPX74RZCuKMUz0wnmnuzJZyblm4SWcnKRBzmNFKMCGJZAnkt1/keG+fiXI83zQHqTIeg6lh2TCEPkg317H71pBU53U6sdIbgvNsilmItTliPBI0xiVqrk8jW4Kbpt7XbYAImbKGvddeWCSq0lZDiZvsc6xcF9Lnw5IhfmoxOFlSzFJ+1YjhESZtarPI2hXtXdOtyiaDliW/I13pn5NHTC14NDXwZQkG97SeNJopjzRxu9k1OAnj9b3zGb+eIzlKdMBnTh9BNkWAkSxLQCZRW0UQvFISZTkKW8VWv2v/L9UxSbkUOjNZlHsAe62x+paA21wLe7XDWbT+Fxv4JeoyK4YvHqDpDvopq/gQIh28+YdOObzA7dozan5vWdLvrwWLWm8X9WRp5Xmpm3sNIklq0rZXLXnePWhKKMRJ6v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Apple-Mail=_3068F63B-7775-4E24-BF9E-33B5F38DD1BC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Mar 10, 2026, at 10:11=E2=80=AFAM, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>=20
> !-------------------------------------------------------------------|
>  This Message Is =46rom an External Sender
>  This message came from outside your organization.
> |-------------------------------------------------------------------!
>=20
> On 3/10/26 00:02, Boone, Max wrote:
>> On Mar 9, 2026 9:19 PM, "David Hildenbrand (Arm)" <david@kernel.org> =
wrote:
>>>=20
>>> On 3/9/26 18:49, Max Boone wrote:
>>>> Don't split and descend on special PMD/PUDs, which are generally
>>>> device-backed huge pfnmaps as used by vfio for BAR mapping. These
>>>> can be faulted back in after splitting and before descending, which
>>>> can race to an illegal read.
>>>>=20
>>>> Signed-off-by: Max Boone <mboone@akamai.com>
>>>> Signed-off-by: Max Tottenham <mtottenh@akamai.com>
>>>>=20
>>>> ---
>>>> mm/pagewalk.c | 24 ++++++++++++++++++++----
>>>> 1 file changed, 20 insertions(+), 4 deletions(-)
>>>>=20
>>>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>>>> index a94c401ab..d1460dd84 100644
>>>> --- a/mm/pagewalk.c
>>>> +++ b/mm/pagewalk.c
>>>> @@ -147,10 +147,18 @@ static int walk_pmd_range(pud_t *pud, =
unsigned long addr, unsigned long end,
>>>>                               continue;
>>>>               }
>>>>=20
>>>> -             if (walk->vma)
>>>> +             if (walk->vma) {
>>>> +                     /*
>>>> +                      * Don't descend into device-backed pfnmaps,
>>>> +                      * they might refault the PMD entry.
>>>> +                      */
>>>> +                     if (unlikely(pmd_special(*pmd)))
>>>> +                             continue;
>>>=20
>>> In general, if you're using pmd_special()/pud_split() and friends in
>>> ordinary page table walking code, you are doing something wrong. We
>>> don't want to leak these details in such page table walkers.
>>=20
>> That sounds sensible, there is a check in the split_huge_pud macro, =
which previously included DAX memory.
>>=20
>> Related to handling that macro, I see another proposed patch for lazy =
provisioning of PTEs for PMD order THPs [1]. Possibly adding a return =
code to the split functions allows a better solution here as well?
>>=20
>=20
> Maybe. I think the behavior of trying to split is ok. We just have
> to teach code to deal with races.
>=20
> Because the very same problem can likely be triggered by having the
> splitting/unmapping be triggered from another thread in some other
> code path concurrently.

I was previously testing on 6.12 and didn=E2=80=99t see any changes to =
vfio-pci or
pagewalk.c which prompted me to check whether I could reproduce the
bug in a more recent kernel. =20

However, when I tried to reproduce the bug on 7.0-rc2 (after adding some
tracing to get a clearer picture of the sequence of events) it doesn=E2=80=
=99t happen.
The VFIO DMA set operation is much faster on 7.0, so possibly the race=20=

window is too small for it to occur in reasonable time.

>=20
>> I'm not sure if making the split (or rather unmap, calling it a split =
has been a bit confusing to me as it doesn't allocate PMDs) a noop will =
improve things - as to my understanding it will still try to descend.
>>=20
>>> We do have vm_normal_page_pmd() to identify special mappings, but I
>>> first have to understand what exactly you are trying to solve here.
>>=20
>> Specifically for the page walker, avoid splitting and descending into =
the PUD-order pfnmaps that VFIO creates for the BAR mappings - as these =
(can) represent hardware control registers rather than regular memory. I =
haven't been able to reproduce it with PMD-level pfnmaps, but I'll build =
a kernel with PUD-level pfnmaps disabled tomorrow.
>>=20
>> But if course I'm mainly concerned with fixing the race such that =
reading numa_maps does not cause an illegal read, resulting in the read =
process crashing while holding the mmap lock of the process (and =
subsequent reads of proc freezing, waiting for the mmap lock they'll =
never get).
>=20
> Right, that's what we should focus on.
>=20
>>=20
>>> (You would also be affecting the remapping of the huge zero folio.)
>>=20
>> Ah, good one, I do think that this race can occur with PMD-level =
mappings, looking at the walking & splitting logic - but given the =
PUD-level mapping triggered the (rare) occurrence I'm fine to focus =
there first. I guess it helps we don't have 1G THPs, but it would be =
good to treat 2M and 1G similarly?
>=20
> I don't think it can happen for PMDs, as pte_offset_map_lock() =
double-checks
> that we really have a page table there. See __pte_offset_map() where =
we do a
>=20
> pmdval =3D pmdp_get_lockless(pmd);
> ...
> if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
> goto nomap;
> if (unlikely(pmd_trans_huge(pmdval)))
> goto unmap;
> ...
> return __pte_map(&pmdval, addr);
>=20
>=20
> If someone re-faulted the PMD, this function will detect it and reject
> walking it as a PMD table.
>=20
> PMD handling code has to deal with page table removal, so it needs=20
> some extra steps.
>=20
> For PUD handling we don't need that. Once we spot a PUD table, it's
> not going to get yanked underneath our feet.

I have indeed not been able to reproduce the bug with PMDs, sounds like
that=E2=80=99s not an issue.

>=20
>>=20
>>> A lot more details from the cover letter belong into the patch
>>> description. In fact, you don't even need a cover letter :)
>>=20
>> Hehe, first timer, still figuring out the process.
>=20
> :)
>=20
>>=20
>>> IIUC, this is rather serious and would require a Fixes: and even Cc: =
stable?
>>>=20
>>> I'll spend some time tomorrow trying to understand what the real =
problem
>>> here is.
>>=20
>> I think so, the bug can be easily triggered by repeatedly booting up =
a VM that passes through a PCI device with large BARs while continuously =
reading the numa_maps of the main VM process. The reproducer script is =
mainly to narrow down to the specific part where the race occurs, the =
VFIO DMA set ioctl.
>>=20
>> Should I raise a bug email to refer to, and resubmit a new RFC v2 =
(without the cover letter), or keep discussion in this thread for now?
>=20
> No, it's okay. Let's first discuss the proper fix.
>=20
>>=20
>>> But for now: can this only be reproduces with PUDs (which you =
mention in
>>> the cover letter) or also PMDs?
>>>=20
>>> For the PMD case I would assume that pte_offset_map_lock() performs
>>> proper checks And for the PUD case we are missing a re-check under =
PTL.
>>=20
>> Have only seen it with PUDs, will try forcing the mapping to happen =
with PMDs tomorrow.
>=20
> Can you try the following:
>=20
>=20
> =46rom b3f0a85b9f071e338097147f997f20d1ac796155 Mon Sep 17 00:00:00 =
2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Tue, 10 Mar 2026 10:09:39 +0100
> Subject: [PATCH] tmp
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> mm/pagewalk.c | 22 ++++++++++++++++++----
> 1 file changed, 18 insertions(+), 4 deletions(-)
>=20
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index cb358558807c..779f6fa00ab7 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -96,6 +96,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long =
addr, unsigned long end,
> static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned =
long end,
>   struct mm_walk *walk)
> {
> + pud_t pudval =3D pudp_get(pud);
> pmd_t *pmd;
> unsigned long next;
> const struct mm_walk_ops *ops =3D walk->ops;
> @@ -104,6 +105,18 @@ static int walk_pmd_range(pud_t *pud, unsigned =
long addr, unsigned long end,
> int err =3D 0;
> int depth =3D real_depth(3);
>=20
> + /*
> +  * For PTE handling, pte_offset_map_lock() takes care of checking
> +  * whether there actually is a page table. But it also has to be
> +  * very careful about concurrent page table reclaim. If we spot a =
PMD
> +  * table, it cannot go away, so we can just walk it. However, if we =
find
> +  * something else, we have to retry.
> +  */
> + if (!pud_present(pudval) || pud_leaf(pudval)) {
> + walk->action =3D ACTION_AGAIN;
> + return 0;
> + }
> +
> pmd =3D pmd_offset(pud, addr);
> do {
> again:
> @@ -176,7 +189,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned =
long addr, unsigned long end,
>=20
> pud =3D pud_offset(p4d, addr);
> do {
> - again:
> +again:
> next =3D pud_addr_end(addr, end);
> if (pud_none(*pud)) {
> if (has_install)
> @@ -217,12 +230,13 @@ static int walk_pud_range(p4d_t *p4d, unsigned =
long addr, unsigned long end,
> else if (pud_leaf(*pud) || !pud_present(*pud))
> continue; /* Nothing to do. */
>=20
> - if (pud_none(*pud))
> - goto again;
> -
> err =3D walk_pmd_range(pud, addr, next, walk);
> if (err)
> break;
> +
> + if (walk->action =3D=3D ACTION_AGAIN)
> + goto again;
> +
> } while (pud++, addr =3D next, addr !=3D end);
>=20
> return err;
> --=20
> 2.43.0

That works, awesome!

interestingly enough the VFIO ioctl now also returns =E2=80=9C[Errno 22] =
Invalid argument=E2=80=9D where
I would previously see the process reading numa_maps crash.

[dma_map]
dma_map iova=3D0x000000000000 size=3D0x000004000000 =
vaddr=3D0x00007f7800000000
dma_map FAILED iova=3D0x020000000000: [Errno 22] Invalid argument
dma_map iova=3D0x040000000000 size=3D0x000002000000 =
vaddr=3D0x00007f5780000000=20

For my own understanding, why is this patch preferred over:
- if (pud_none(*pud))
+ if (pud_none(*pud) || pud_leaf(*pud))
in the walk_pud_range function?

I do think moving the check to walk_pmd_range is a more clear on the =
code=E2=80=99s intent and
personally prefer the code there, but I don=E2=80=99t see why this check =
is removing the possibility
of a race after the (!pud_present(pudval) || pud_leaf(pudval)) check, as =
to me it looks
like the PMD entry was possible to disappear between the splitting and =
this check?

Anyways, regardless, this patch resolves the bug and looks good to me - =
what=E2=80=99s the=20
course of action as we probably want to backport this to earlier kernels =
as well. Shall
I send in a new PATCH without cover letter and take it from there?

>=20
>=20
> --=20
> Cheers,
>=20
> David



--Apple-Mail=_3068F63B-7775-4E24-BF9E-33B5F38DD1BC
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
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYwMzEwMTEzODAxWjAvBgkq
hkiG9w0BCQQxIgQg90dyiPsjZVOvnlfLV4iz/SJb2x+ObfkCp2qa39/xLBkwDQYJKoZIhvcNAQEL
BQAEggEAykmxByPuHPrjz/cLP+8UhRjylbYo8tuuWtlHuWktTY5osXryKSwEpBXcrucspWCiYl8f
AWNbtnN9PeDn+718KO0uDnHqaPS+qQWgXwEWW1O0oYJNPxwxoXz08TyKqACY+azDc/FJBdr8HiBS
3KAdiS940rs7kVQxy9ekg2aYNUU78q9n1U/OpP6aqXL3RETbYZN+qhCUggS+5PBbX1RSkQ4mwXT6
cdmriSAzDn8vyhHXozzSTnOU8VuR9VTVH8DS/sFwjdo23yLZy5pQ7U0AeTUy2/G1Q6zCLYouSh0t
3bg+gj9EdFLsgr2SRgM+O2LDoIWRHEfCZTFlVH/VVFTGHgAAAAAAAA==

--Apple-Mail=_3068F63B-7775-4E24-BF9E-33B5F38DD1BC--

