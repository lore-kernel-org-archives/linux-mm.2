Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69655CAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5E28E0002; Mon, 15 Sep 2025 06:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66628E0001; Mon, 15 Sep 2025 06:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE07B8E0002; Mon, 15 Sep 2025 06:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 913F28E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:45:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EBA3160561
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:45:22 +0000 (UTC)
X-FDA: 83891152884.22.B736E17
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id DE05C8000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:45:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ky2Y+U5c;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=F1ulM7Si;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ribI/IwevH3WiEV1RSWEfOw+3kABFLZ/c8OAHRGMHT4=;
	b=xY3xn2eC49zb2czkVaExFViLFIiqCZeQU7fmtiqAm1ES6VagaO7/XOOjEAwgMMXLPIHjRg
	+TKfEZHIIVgRoWFHkywQZJhrwyFbst2vvHdaX0yez80CyZUi5bFZ79C2zrXF7J9+vTQQXb
	lQUUpNFAGmsUMsTcHaQVlIW5TVqcqlM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757933119; a=rsa-sha256;
	cv=pass;
	b=NewsRiwneqWqjhYvG8RclXg0XFn+rYmVmWM77GjSfEbhSyNUySIIJnjOBAryRBzqJZiduv
	yDFvmP6l434XxP9ienm8wPA60sUtbiqvi4vblTgg3VSkqKmZ/Mx6u5337yqnOm0iSLwgNm
	ucPwKlhMiQvB+SaUIZ55zajGwA9dCpw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ky2Y+U5c;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=F1ulM7Si;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6g0ZM014293;
	Mon, 15 Sep 2025 10:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ribI/IwevH3WiEV1RSWEfOw+3kABFLZ/c8OAHRGMHT4=; b=
	Ky2Y+U5ceJUWwVRygIJn67B5XNQXA1N5HrkvEzc+l/LDa4t6NHzh57PfBaaXZkM2
	0T1GJFXSS+g1K4vZPDxswK5XSGNqaqMWU2uWddbFIMorKAwzgFXJNzt8dBhJFZiw
	zSE+Cj9oY9p4gz4NDosvnXOTkLQsrOojD7igy0pKYphVwo6AG1tjX2iTBl8N6u9B
	Y6dkN6q8yfBWOcSk6mPL7ZbCJupesOmMzRyy14y5J24JrEEHsGlGmCFlaz/fVfLV
	C5SDY685xuAVtasfmiJfgEXS0kWU+uJa48QmmlenHwx7irTsm3Q14MmmzttAau9X
	zOvx4OZttDp3kuXT01Iu5A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yd8j42v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:44:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8mPpE019151;
	Mon, 15 Sep 2025 10:44:57 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012066.outbound.protection.outlook.com [52.101.43.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b3g28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:44:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BL6800ENn/4QtHNTC+My23TAYuPw+t27hZMdyIjNMdzgNSr0xXRPQ/TPF5gap050gBQRF7r5ZVlOx3Gm7tNGe9IDCp8YwBVtStUI0bgHUmBnlV+ntINDK4TAvrgYIjURk7QIZrapg9HR5r5RYI7+XpTstHGY2JqUIbCj13hWzhhJO18dqKhUofSpzIqXUv83cXYfWUDSKeNOvI/GSlsJqrBRrtksEjOFVBNarWe8rOjqf+JwO3NqUMeYg9qi3sjORc6f2YZP2A2f7/L75gHn4uvZDSwvAMeFW9m77SsMqYALnXsN0Y4qK1Bk2k2dDRZYW/aRf3RpgHwheVlXsOroXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ribI/IwevH3WiEV1RSWEfOw+3kABFLZ/c8OAHRGMHT4=;
 b=RTrHpDPUuze06n5yAMoSK926LmHhutYps802F821ZO04sZzTbv4rzbuI7m4nThVXJrOyOrsToO6oXM4WeJ1D5BuXhAkDN7AhnTdv5nT2yhoGbAriY30ySR2WqF6XSsLTRbIojKV48j5nvLHhJedDNWQFw7kTqrmU09iXETPjB55UOTGsjIVRnrSrIWQa9XIpJ6GcCVvrqPQxgSJ08Aa9q9Ry/UsEuBdqrZOd1BMN2RRHd4iDBn+M1n2eIGmoduN6Q7B/nNgbT5WxBKMHErdJjjTBO6Ct8oQ8eWjDAfqEOUgiafYekpNaHYvqnq9XRY3K1iP+K6RkUFkSzZM5y1Yntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ribI/IwevH3WiEV1RSWEfOw+3kABFLZ/c8OAHRGMHT4=;
 b=F1ulM7SiWYbNQ0q72yHF7iJDahbx/lKz9z0+sZlU2rh2lFZ4Pyez69T4hHP7OavGNPbb9DUXwv++pj6+IoHStQL+QWxDH3AgZoiuq9leoiKFogcyInRW+43BKLfQDbXAkvj8Co2Y7bAY15UrWF4OMKRae0l3jn5B7AA4dyVbuC8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPFF257CDCED.namprd10.prod.outlook.com (2603:10b6:f:fc00::d58) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 10:44:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:44:52 +0000
Date: Mon, 15 Sep 2025 11:44:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <41d9c544-361f-4457-a53e-023b8db8c707@lucifer.local>
References: <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
 <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com>
 <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
 <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
 <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
 <CAA1CXcDyTR64jdhZPae2HPYOwsUxU1R1tj1hMeE=vV_ey9GXsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcDyTR64jdhZPae2HPYOwsUxU1R1tj1hMeE=vV_ey9GXsg@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0406.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPFF257CDCED:EE_
X-MS-Office365-Filtering-Correlation-Id: f4a5f93c-a85a-4fd2-27f4-08ddf444e704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TERWcW8xSlJnajZQVm1qSUFkZFhrWlFxSkNuRFllRlM4Um90ZTNaZkVzeTJy?=
 =?utf-8?B?TjdRcWdwdFZXT1dlRjB4WnpSTHNHczREazhuQ091OWFybDRTMm8zNGpkLytu?=
 =?utf-8?B?RGdRYlJzY2M3NVlNRDVZN3JEazBPWmZ6VnpJeTBubDFYQTVLeU1EU2h1Z3lS?=
 =?utf-8?B?MndZWGp2VzBEV0g0cmtrWXloUWdQaGFnQXJCSENuOXg2TjBrbEFQcHFIRFk0?=
 =?utf-8?B?MG5zakM3V2dGaThITm5TVGpUZ1VRUUhxTTJ1ZG9OalhyUjRpb0VoWG96b3VK?=
 =?utf-8?B?KzZXS0tDUmlDV1EwWlVFaGowSVN1U1czKzN1T01sMU1hUnNvRGRjWE5kcjZX?=
 =?utf-8?B?S3lQVzZmL3poMXB5YTQ4Mkk1b3oyM3FkZlFTS2NFNVJ0Q01vcElWZEVaM2dS?=
 =?utf-8?B?ZGdFMTF1WmxvaDlKZ0pWQ3d5bHRjOFgzSU9wT25lMmRjaWhML2FXdVNtQ1Ir?=
 =?utf-8?B?VWhIMXBxZHU2cmM3SnJUUitIZE5EZEUxQkJCU3BGZTFrNkpjMUNJSEx5VEJu?=
 =?utf-8?B?NzdZN0pBVXVpckxWbExDS3dEcDJwODhEWEtUUENBeEVFWmdhTTZmRnNqSTIy?=
 =?utf-8?B?aEhjY1ZZT3VNR3hIcitEMkJBbHdpcE5mQWNPZDd5ZVA1YjBMa2RtMWF6MUpV?=
 =?utf-8?B?NU1BYzl3SmtkZmptaDN1cWxiQ2xKTnRxNSt1eGs3ZHpRaGROVVBvN1BVSlFp?=
 =?utf-8?B?THNtZ2hzMFpRcklYVURUYS9RS2NBNXlGUkIzREkvcGZwd1d4ZVhLcmNwTkQv?=
 =?utf-8?B?UUNORUlzOG05NjFvbXZoZ3JacXZDbHJBSm91eEozbzJzTkxodHMwcFVQUGt1?=
 =?utf-8?B?aVFjSGVDVE9yalBhU0F1UXV0MDFkaEdpYUZRR1dvZUZtbEpLNW5WMTRwQ21Q?=
 =?utf-8?B?VmYyQUczQkFCYUY4KytWSnYvYzVMYktjcGJXTEIyM2tiNHBDUDM3Mmt6VkZz?=
 =?utf-8?B?Ri8wVlZPQXoxd3JKaHFMc1Z0cVBRNFBON0Voc0k1SXJQaHVqZmhBcjJVcjVL?=
 =?utf-8?B?Y0pnTm94dmw5NzJJd1I5SzRtNElCenE2M3Mwdzh4MW1ENjJvcTNlUkNsNUxW?=
 =?utf-8?B?ZmpkellMQWY0QUg1czZzTXNvWTlEN1N0Tm5KYm5JRXJhU2h3Szc4TC8zM3or?=
 =?utf-8?B?dlZTWXNFSktVb1QxWWZhR3psSG5MYkphNUxhZ1hDSFA1Y3ZmcXRiS3ZOU1h4?=
 =?utf-8?B?VjRmMmdSUmV1MFdGNFdtakthUzFlSjFZaWtWREVITmhNNFd4RnpwaEZQOCt1?=
 =?utf-8?B?cWJ0clhSSXhST1Y3b056TnB1WFJyZ3NPN0Z6d2RCRGo2aHBrLzV3a3RGb29h?=
 =?utf-8?B?bmtPUStBTnErQVhQTXF1eU1tZWVzUlVha3M2YTFvMmFuZ3QxNVh6TjhTNzZv?=
 =?utf-8?B?QVE2NTlMVlZsdXBUTUFGTjV0UThpUk1WR3pFWm54RW9FVjJNVmdnOXA1RHhJ?=
 =?utf-8?B?bkJTbFhYYjVtQVp2SXZONnhwelZtd3lkMkdJWEhlR2dhSDNRWkxRUC81RzJu?=
 =?utf-8?B?cmxOdFlNOUVadGxHeEdhdE5OekJrWE1Zd3pnNUxEQS9PRDBVYUhFUWpSTkxC?=
 =?utf-8?B?b1hWQWNSSmp2WnNBZXhDTDFqdWhSTWNqN2xVSmd2RUpTT2hFaFA4elM2aVBN?=
 =?utf-8?B?VmFNd3hoUG45cXg5REYxMVVMeG1WdlV3MnhOR3UyVU9sMmdFb0RKQnM1aWFs?=
 =?utf-8?B?S1lKQVdrc0Z5ZTM4T1NkOFdjMWEzeUV4S3pOTnpBOW5ERmtiR0YyeVpQNGk2?=
 =?utf-8?B?MHlOWnA1cWVWNVdvMnVUcVQzR25yTnZncUNRZ3JkTm1OVllUM2VxMVRRUWlx?=
 =?utf-8?B?ZGV4dzVON2Z4QWdwR0FEVERoOHhBVUtxOWc0eVJMbWFvWWorNFRPZXZPR3NK?=
 =?utf-8?B?QnVpWUY4UkFqYnB1NytOZDN1UENyRnZwaytJVitTSWpmejA4SzdBMFRCQUFp?=
 =?utf-8?Q?Ak7yZt5m/ac=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OE5kakpEdmN5c2NUUWp1ZjJhaGRwSGc5VFlhVnJVb0pSQm54NElOTEU3SzdB?=
 =?utf-8?B?YzJPZlVTbksxN3NNeFgyZ2JvNktrOTZkeHlBS29zbWw2bC9hZTZvSEpJaUlG?=
 =?utf-8?B?ZWZaQjAvY1UzMUZ5aUZweHY4Nllad2gxV3VSUGV4YmZhN08xVVB6d3FPN1dk?=
 =?utf-8?B?RzlaMDhYZC94dHhBZ2xjaUp6NlpMV1g2S1Q4REY4eSs4OU9QV0hQbzl5OHBB?=
 =?utf-8?B?NGZoMmF0WUljV1BjSGY1TUphNXpKamJIdlV5MGVCVHQwT0hNL3BDSkd1VUty?=
 =?utf-8?B?cS9UcC9nRDdtVzlNcU0ydzJSQUpsaFc5em53SW9MT2p0N1BQSkFDMXVydDdK?=
 =?utf-8?B?VnZkdWNUL0UwTS90WGpmZVJSWCs5aVRhL0JMK3N5UTBnK2hrVEJGWFdJRjZy?=
 =?utf-8?B?SXllZ3h1alBJbWRKcCtKZlN5QnVUaWgxQy82ZjZkblRPZkNycTVETDJ4S2M1?=
 =?utf-8?B?VFl3QXhCTWdPYnBpbUlsMWVSY2ExdEJ6aXRGWisyMWNpUzdBN2pkRXBxeVdL?=
 =?utf-8?B?V05OMDlhR050d25KMCswM2NTNnVzYTN4K0ZUUVpETWFmYVY2MXJ1bGc1QnZn?=
 =?utf-8?B?ZXNLRlVybHdTSlJvK1h4QXpvTUlwcW1qaktjRngwR2tINHZJTnArWWVZU0xk?=
 =?utf-8?B?cVZsVlBEa00rYWpIQXN0RFBBL2ZjYnpkUDgrYmdCZjFKSFBGcFBrNWF4TVpt?=
 =?utf-8?B?U0FpSU5FZ3Y3a0hmZ1FMRUZHcXJGcUJyMVBXcXBOa0dpZVAraUVuODdaOW5n?=
 =?utf-8?B?Ym16YW96d1VOUVZKZW1sbGwxejFEY1VRR2ZvVGNhUE5BSjNqNC85SS9MMjQ1?=
 =?utf-8?B?Y2xyZlRwUjNVR1BqbDFORStycCs3aDZGTHRYMGpuNk1nMTZ1UmRUMkJPL0lC?=
 =?utf-8?B?NFA0YnFtamdtZmdWdGpneEljU2FDTG1oMlZRMTd1aFJWRS9BNjhYeS9NdW9p?=
 =?utf-8?B?aHpNeDUyVWtaMjd0ZFlBZHQ5cHFaZ1RUUGNqeGlmcjlrSUVXUitMRnBGcDYy?=
 =?utf-8?B?WmhvbXNRN3VZeDRVdFI3Skk2c2Frd0RvQ25tKy9LMjRoc1BxMVdFWDVqWTRh?=
 =?utf-8?B?b1VOS3pJVVVBSmlsQ0tzcHdvcHNqMXQzelZWZlpIUDZPWnYweXFjK0RISWdl?=
 =?utf-8?B?a3d4aDVYb3krL0RnTFhDRTl3OXFza0xCb1ZQSHVlbEhTaFVvcVFGaHlUalpT?=
 =?utf-8?B?V1k2aC81THJINmRVWXc1ektueFEzZ2s1Um9tSkxtSE1XVWl1TWg5azBRZTgy?=
 =?utf-8?B?NE9rdnRoYjZOa3hCUFkzTXB2VXU0T0xXR0pMM0t3OW1VTHBqMjB2TWZ6YlUr?=
 =?utf-8?B?ajdXemd6dEI0L042alJYS2hiVGdQb1BuZFVYL01VUXkwTllDTXI5cTUwVTly?=
 =?utf-8?B?K1dpUjg0OTBsUDdpYnVIUzY1cXBZZEVMK2NJUnRRTlZIakRXREt2TDEyUkRr?=
 =?utf-8?B?WEJ5cFhMWmVKTE93U2dmc0FGNVFodXdXeGRrdXBQRmRzSnVHRmVWL3N5b3Bm?=
 =?utf-8?B?L1lJSUh1V3BHVjE5bEs0ZitCbzZhTmxiajRMZWgyQnlkcjJvcjNTMkpOM0th?=
 =?utf-8?B?dytNcUJ1TW5ieXcybWpML29lTEQwVnJRdXhIeDhYVk5ORVZjR0tjYVozMUV1?=
 =?utf-8?B?Rm5IL1lkcSt5enhkelllQ1JpaXBvbHhOVEVVNHRYQU1PUDN0U0ZWblByOGhK?=
 =?utf-8?B?dGRYTVRBVHgwZWI4VjNtQmhqai9reThrb0dEcWdQK3VYZFhjVHZKNnV0M2Zj?=
 =?utf-8?B?THgza3NvUnMxdTI4VWI0a01ZTTZrMVFtOUl3RDhxbHAzZWV0VUpFc1AvWHM2?=
 =?utf-8?B?YVFibFQvN0I5M0Y5Z2dvZjJmWUNOS3NrR01lbkNoRTRhZVVVN2FtYzI5NDZY?=
 =?utf-8?B?blltbXJCOHQwM0EzeTlSbzRZSmhvWXBJZS92OEVaN0dvWEZEQTZFSWo1bEJz?=
 =?utf-8?B?aHA1bHQybWZzTXZMU0JIaXlLS3F1YWprZnBveXlDV0dMZTBncmNseTQ1ek83?=
 =?utf-8?B?SDEzMEJTQmtEL3Y1S2lrdEN0TkVGMU14Uk9lLy9manN1NG94SG5tZEpYU1dk?=
 =?utf-8?B?RVlwdVVSOUZwaDZUdS9uNFV4VVRWZlFFeERpaXJPcUx2UjZPWndTOUxuOWEx?=
 =?utf-8?B?Qmw1VFQ5cWNPVUtWeFFZM0ExWDV5NEg5bEI2L0F3RElZeEpLS3UweHVnVXFl?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	leERAbX8vv22bXZehLeE7DkZ8ATebl8JNOVemAQ976OMHRLgV+yzAIfl1Ltc7EUlb2aJRhpPCnHeHkfQMHT6uf8Wi7CgDqTGgvs8ONnYJh5j5T5G/nmA0zpPfmElnMyrR2JpVYMK34m1aYRynruhOXsNM5TEE0Hdsx/YGeAGOzimnn93aEOtWqbQrRXl4MrVf4b5UZZFKvHiBpX2pBpBHI7P12ZBaKVfhVJSkYakF03XLjLZAEK2Th56ZdDnsZ4fClL8a7ub1++zFMmifL2zmoKfTX/vJCzzQQNE2893mgPGjf0bR4Zji9rSPe4bcYy+qbOmkCOIETyvosPW33AveNt6/n3JZu6DziHijteOd293QBhKsYurBZNpMNZL6AMKx0hAaWBelhd+Hk+DTdUh7RoPKipyM1U9TQBsVuL3yekuQIkUH6Gl26SrfUsFLSlb4Su2O/VsQjx11bFzgxzTlgqGKMYrENVMIUueM4H9Nh8DHQP9lqpHu0+oz1oRkHyw1mXXtOzKcDhzeBoYis2fHGJgYHtnkrMXC0XLirY6HTy0NhbXhUpHH2zg2tzG8xr08+p7EM7lWlqW9ZqP9Dol0oBfg3yFlfhbNyJxv/PjvQQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a5f93c-a85a-4fd2-27f4-08ddf444e704
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:44:52.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltR2/ghwCej2Eewz6y+hWjglosZb1xHeUxpfTKwjcEwd6/pxMeNZIDM8820y8fFdyH03TTj436PVUI6TuS79mtuClq/27MsI6SniJx7/7g0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFF257CDCED
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150101
X-Proofpoint-GUID: QM9YOZdgk1jvy32-yCjfbbJ0tMZUzXJM
X-Authority-Analysis: v=2.4 cv=M5RNKzws c=1 sm=1 tr=0 ts=68c7ee2a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=AiKGgwP3hFj-RKnslD8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: QM9YOZdgk1jvy32-yCjfbbJ0tMZUzXJM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxNiBTYWx0ZWRfX3VjadcjCHu4x
 MNdcGZ1QdxEkvrRssxYsX8xEw95ATGdagchK4PisjwooQYbtzf6GrJTe4gPVkLRbIQ7nGEpG52q
 p66C5NboN05Y0GputdpYHVy1XZoS24xnH3FPVvi7R8ZE2W4ahT1LIjWC6CnJPkzNsSx3V44KuNf
 u0+z0pk7jXnl7YNZPrrMCBnX2DmI6QI6yh0MO42BIbRBcD1Mtf7uTl2kViL14i53zMMDu6vbbQO
 cAfyj0+AGQRpv41C8wUKT/Ra89h9Gnt8gCJhbRDKI1H9VYSbUQKFyoQ0f7ga6AGy6lPXETJKkHm
 PbOCPt9LfaFPKbKdXfa00K2oAKf+MHW6H20JmIUbYz0A9gL7HcSYX1YNLN3SdOzzc4dGXmdQpbe
 ksinAkFI
X-Rspamd-Queue-Id: DE05C8000D
X-Stat-Signature: bxsa76qbbg8dt9q67k7578c74ezsjimt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757933118-400406
X-HE-Meta: U2FsdGVkX185QUYtOkuoV5UbYBsrRDkqrhiC2hnhNhLxfD2auNh6QBDp/PN1EMlstb10fnaYKyJyT2gRsGmvXfIPDrI/1pJpP8ErjIVsOFFIrUs4cJJQx+Iv/ftPKBXPs+WqX7jDEahX/qKg+0DecTK0salpnSQqC7+6qscYqivtta2btL+6tN2OHMXQ3VBsjAO+cWmr0o5AEzKSKYcZn1LCWRIOTS/PJnfJKgvSX5gUOrhONFF2yOKsdQZdKUx73kG5KaVcEyeRmcuaKZW10wfN+3XT9Ps+7RU9u5/dtyz7s8mr0ZoJjPGaQx0gGyvfFAe1DK05lyQ352zR1IUGhay/uzT4WSOBzTWaKLlaVgEzZDx4+PARj/n7JhPgJrgohggo9RThcdm5BkW+qTsCj2DABniJgChpDZayOuVT8VPmejX9OV2yjPoUzj6Nc+kRSUcVyVfv470vTYC1rDFyr1wEEzzj+16Eie2M05M1ZrwOIPN2XDLodrgqhCVX2Q71yq548uI7+Jku88ReXRH5vwmKk6JVUItGsJxBSL+FBh7vTPMVaZEJUuPTXi6GzVHF8vfJdW/RnHa+jG8VaFECHwlr1TvvHhNlbCY7y6J3kPuMsvSPmg/PiruM/r8mfeZUOwkB0MT17d333xbhK4ZMf1lCsZ6Yb0MRjRLpN3vYQLQH96iZtjASIeUoQoKu0pUpAEqUEdTVMO7H3lCGgQipq1GofGVlfDTQbtMHxO3B2+lEl9iCWRylRiU4fyO1ZDS8yLGlyicY3STOyKZhUCG+PXuGOnXj0EjSSMDql6w/IGQp1QEYj89KnnjGFJZeU+WN3+8Ut7mqkfh7GS8Y87+fZD7wMPZ1kGOAVX4gC0L8XFrted3Fn0sSt/A2VEsWT4Ywt2CRRN2fuLqHbv/2IFuSX/jRpSQIWqRXjckgw148ZdcelArKCMrd6S8gMsQeKgrVNz85Fzp8enUsnvAgVZK
 Z8ePmgrj
 HSxL9n5EqqnPgRVrPo95RgqwYTJkCv6zHDWoTSOIS8JmhvsOI7X1rvD7UUjkWz4w46x9ksfsT9ITTm3WAlw6M/OvkXuzSHDLHmMx1XbTgt3wzLeI4umC/sdAB66jP7sLI3GGTWWQ3YgrYMuQiFDPgBVJU/R4oHSmzXztpyEOAtm5TxBLwznCwkyj2n6OgpA1X7Q8GgTcQbiqHXiUcZcR4/ni3j4Ijcf5xxs0k/SYNgXXECKP1kNYFPQb8nPBhjoFN0bVLwvZ7zxSi6C7OiozCHPigPCKNlBkwf/CEuSRKkWl1pLFWJXprwn9b8U+3ch6icACn+4GNd6Fqu2V5MV1+gppSczOSUQ4MqH9euad1kl/P++by7fQrIZEceKZAVcbUO/qlZnYKwh141R56gSnmXkDbt+LdGUpF67c+SCZbMhIKJlfHnvwY8HtXQW6zUWpE4PVqZgfb7ZIm78ZGtwLZE3Lepy6tZ8IP5s2K4OltiEdI4NDWnPjQLA8hu66DTem92EdFKfMgXC4+SIAnGONqEcaycoHd6DyAoG+nGqvYh5jvi3CxB2+UJtJVUOPs68cGqVVnIBsFegVvoNtWFsTITuifAwgcabqha91//OLS9K5CHGvBlWf2FFI8Yhbwb9JffwYR6+qCP16v+a1OL0G3wx/3USyoExbgAZJe74bexf4mfrt/7C0BhGM7xTJmXjQc3hiYcJ2ZUqGEvPbk6vEI1Ia/3lrhkLSW0KLteOja/rq3AMPnuHAjqmMsbnps+TGq0Lbk9mNTnPmrjkrgBFWRntM8bIUiNtv9lzqUx3cfHWo5+f68vv/ZysczDKzAzG+SfvNhTcHfopbO1HkareZUUK9pFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 06:28:55PM -0600, Nico Pache wrote:
> On Fri, Sep 12, 2025 at 12:22 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Fri, Sep 12, 2025 at 07:53:22PM +0200, David Hildenbrand wrote:
> > > On 12.09.25 17:51, Lorenzo Stoakes wrote:
> > > > With all this stuff said, do we have an actual plan for what we intend to do
> > > > _now_?
> > >
> > > Oh no, no I have to use my brain and it's Friday evening.
> >
> > I apologise :)
> >
> > >
> > > >
> > > > As Nico has implemented a basic solution here that we all seem to agree is not
> > > > what we want.
> > > >
> > > > Without needing special new hardware or major reworks, what would this parameter
> > > > look like?
> > > >
> > > > What would the heuristics be? What about the eagerness scales?
> > > >
> > > > I'm but a simple kernel developer,
> > >
> > > :)
> > >
> > > and interested in simple pragmatic stuff :)
> > > > do you have a plan right now David?
> > >
> > > Ehm, if you ask me that way ...
> > >
> > > >
> > > > Maybe we can start with something simple like a rough percentage per eagerness
> > > > entry that then gets scaled based on utilisation?
> > >
> > > ... I think we should probably:
> > >
> > > 1) Start with something very simple for mTHP that doesn't lock us into any particular direction.
> >
> > Yes.
> >
> > >
> > > 2) Add an "eagerness" parameter with fixed scale and use that for mTHP as well
> >
> > Yes I think we're all pretty onboard with that it seems!
> >
> > >
> > > 3) Improve that "eagerness" algorithm using a dynamic scale or #whatever
> >
> > Right, I feel like we could start with some very simple linear thing here and
> > later maybe refine it?
>
> I agree, something like 0,32,64,128,255,511 seem to map well, and is
> not too different from what im doing with the scaling by
> (HPAGE_PMD_ORDER - order).

Actually, I suspect something like what David suggests in [0] is probably the
better way, but as I said there I think it should be an internal implementation
detail as to what this ultimately ends up being.

The idea is we provide an abstract thing a user can set, and the kernel figures
out how best to interpret that.

[0]:https://lore.kernel.org/linux-mm/cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com/

>
> >
> > >
> > > 4) Solve world peace and world hunger
> >
> > Yes! That would be pretty great ;)
> This should probably be a larger priority

:)))

> >
> > >
> > > 5) Connect it all to memory pressure / reclaim / shrinker / heuristics / hw hotness / #whatever
> >
> > I think these are TODOs :)
> >
> > >
> > >
> > > I maintain my initial position that just using
> > >
> > > max_ptes_none == 511 -> collapse mTHP always
> > > max_ptes_none != 511 -> collapse mTHP only if we all PTEs are non-none/zero
> > >
> > > As a starting point is probably simple and best, and likely leaves room for any
> > > changes later.
> >
> > Yes.
> >
> > >
> > >
> > > Of course, we could do what Nico is proposing here, as 1) and change it all later.
> >
> > Right.
> >
> > But that does mean for mTHP we're limited to 256 (or 255 was it?) but I guess
> > given the 'creep' issue that's sensible.
>
> I dont think thats much different to what david is trying to propose,
> given eagerness=9 would be 50%.

I think q

> at 10 or 511, no matter what, you will only ever collapse to the
> largest enabled order.
> The difference in my approach is that technically, with PMD disabled,
> and 511, you would still need 50% utilization to collapse, which is
> not ideal if you always want to collapse to some mTHP size even with 1
> page occupied. With davids solution this is solved by never allowing
> anything in between 255-511.

Right. Except we default to max eagerness (or min, I asked David about the
values there :P)

So aren't we, by default, broken on mTHP? Maybe we can change the default though...

>
> >
> > >
> > > It's just when it comes to documenting all that stuff in patch #15 that I feel like
> > > "alright, we shouldn't be doing it longterm like that, so let's not make anybody
> > > depend on any weird behavior here by over-domenting it".
> > >
> > > I mean
> > >
> > > "
> > > +To prevent "creeping" behavior where collapses continuously promote to larger
> > > +orders, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on 4K page size), it is
> > > +capped to HPAGE_PMD_NR/2 - 1 for mTHP collapses. This is due to the fact
> > > +that introducing more than half of the pages to be non-zero it will always
> > > +satisfy the eligibility check on the next scan and the region will be collapse.
> > > "
> > >
> > > Is just way, way to detailed.
> > >
> > > I would just say "The kernel might decide to use a more conservative approach
> > > when collapsing smaller THPs" etc.
> > >
> > >
> > > Thoughts?
> >
> > Well I've sort of reviewed oppositely there :) well at least that it needs to be
> > a hell of a lot clearer (I find that comment really compressed and I just don't
> > really understand it).
>
> I think your review is still valid to improve the internal code
> comment. I think David is suggesting to not be so specific in the
> actual admin-guide docs as we move towards a more opaque tunable.

Yeah thanks for pointing that out! We were talking across purposes.

>
> >
> > I guess I didn't think about people reading that and relying on it, so maybe we
> > could alternatively make that succinct.
> >
> > But I think it'd be better to say something like "mTHP collapse cannot currently
> > correctly function with half or more of the PTE entries empty, so we cap at just
> > below this level" in this case.
>
> Some middle ground might be the best answer, not too specific, but
> also allude to the interworking a little.

Yeah actually I agree with David re: documentation, my comments were wrt
err... comments :P only.

>
> Cheers,
> -- Nico

Cheers, Lorenzo

