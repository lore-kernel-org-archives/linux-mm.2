Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B06CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5088E0035; Mon,  1 Sep 2025 07:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC4E8E000B; Mon,  1 Sep 2025 07:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594818E0035; Mon,  1 Sep 2025 07:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4475C8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:05:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1A4C13AFA8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:05:45 +0000 (UTC)
X-FDA: 83840401050.29.4D905C1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 60370C000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:05:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NHPJyomB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RufdzI1j;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/jZXAPr57A7/+iMVuOOjyUpGy9Ccky1QwITkYQfRSg=;
	b=J9dD5Tj5/fMGCgpQTaqC/9wd6kSkGlGa+49k983C+3i/scIKv+dGmJx2QWFixj1b5WLcnO
	fQQh5LeZbx7vHe1j8GHL9AKT3cEhoArrB/uz8LHmlM3sMTsnFNBF42POrjLM+D4UxTT+bj
	Mxpj2rf4h0gK1Jc7bvFRKwvnRcbW7ao=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NHPJyomB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RufdzI1j;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756724742; a=rsa-sha256;
	cv=pass;
	b=aOHKUHgxvdqFS3gc0bQRfARvUWZhhIYYTEqmry97s5MyMqmUCR64BgBvS1Cd80qTsaogSB
	kIRUvoKOiJpJ0D/ASHoVxO/XeXpHs5we0c2Prw2+lKvMd8OmrPGJujK6MLfWapw7LQsSFd
	sYp7L7ZWzED1huq4N4tB/M9VwX1DFM8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5815gvmn001828;
	Mon, 1 Sep 2025 11:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p/jZXAPr57A7/+iMVuOOjyUpGy9Ccky1QwITkYQfRSg=; b=
	NHPJyomBYj6NmdB2OzRHblSlBJooqOmj4ohtl6niPAOPFvpew1krkAR1js7SfA51
	jTsrm0VO6TF9vpIE485cFteleDcl9/R35wg97mPD+WtaNXev4BmcUQfdHeiFWi/D
	2GbLuTOO3rStm8HRxiw4fkTGa4wILp07YtjJV7BSt//oaOkHT3xGy7p65n42f8iX
	NvZ7nl2kSYFXbTh0o2Y3bP5BsRr4051YyA82uZ9//ABrwTWKdSyk57XqX9WjA8v+
	h9IldAw02KpkMEavBYAt8nokQsapAg0LKXPJgAri+x1BSYriX6pInsbm03MgnPTQ
	epeiYB/akLFcb8K3i4X8DA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmna9jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 11:05:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 581ArCnY026754;
	Mon, 1 Sep 2025 11:05:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01m9f0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 11:05:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9YEqy6pXYMRwN9zewshHUIvMpuHcFAywVqGS+Wa/w54edwMUrOPAbZuVVsJi9ud5D7wjlSIjdSgK5/NQA7LV9MS8peGvD3eOi7XQD8DXDUSW26WlfQahiSSrh9DcTfl2S9WT+wv7aGdkFtkid3wpo1520opffDkJIfqTXw7WrHKU1nzAxEBeKop3tEj1nofyPuKfgLRHzvxYQR7tlfe+6lMF2ftqdvOlg0G9jLiz1Ap3dKUF4eEvcBxtlqjvZOKZZ21ApCp9h19SXeGwS2IENC/p5V7YPtGOI8T5EVQls+r8uhzUa0fo+SHL/h9GnQLpq9Fqgbm65wqsHEoecRdOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/jZXAPr57A7/+iMVuOOjyUpGy9Ccky1QwITkYQfRSg=;
 b=I5TbJfIAOgue9FM2YLYh4CqpTlD/TEvko1X/zrm13a6Dkabo+e/+x7RHidPfR0H5wpRh7u5OZGE46LfQeTILHccWEAcG10f7PLvng/vtfkKqkVMBYi2kgMxZjv44j3AXOSPHkB9/gdhHs4LhVrsL69chi+GKgdQnv7qkGmMZC4tzvSTuzNjofCZhlZt8YTSnIMx6kgkbb/w5Hn9jX1lfU+DQpPTrSeo0BXOYZJ+yCnQwpu3O1tURX2YupYDd358hD9KsqB8xUXW73YiS5jPBZDr7qOhfm/akpzgVXbY55Hk9bXvNfgJfVRg/da6gzzeUkkue40K+GVubjwGPoX58Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/jZXAPr57A7/+iMVuOOjyUpGy9Ccky1QwITkYQfRSg=;
 b=RufdzI1jY52o5DaWflNsH4u5HUiw8pKTchdvyheQtEytBL6PzUrvQYyxQJmGnrKMEk71myI+ki5xA3lvaVkCL19yYfqQS32EBqGYTAOBIyBY5pd9RhCCxD+dG2m7Vhiqt1GDs5b0rRF5CVObKcAG00dn8PUq6yQU4CPJGcak7wA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6775.namprd10.prod.outlook.com (2603:10b6:8:13f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 11:05:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Mon, 1 Sep 2025
 11:05:06 +0000
Date: Mon, 1 Sep 2025 12:05:02 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
        hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
        linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com,
        deller@gmx.de, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
        weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com,
        shakeel.butt@linux.dev, thuth@redhat.com, broonie@kernel.org,
        osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au,
        nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        conduct@kernel.org
Subject: Re: [PATCH v4 00/12] mm: establish const-correctness for pointer
 parameters
Message-ID: <801c5eb7-33dc-448f-8742-256ac40f357e@lucifer.local>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
 <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local>
 <CAKPOu+9smVnEyiRo=gibtpq7opF80s5XiX=B8+fxEBV7v3-Gyw@mail.gmail.com>
 <76348dd5-3edf-46fc-a531-b577aad1c850@lucifer.local>
 <CAKPOu+-cWED5_KF0BecqxVGKJFWZciJFENxxBSOA+-Ki_4i9zQ@mail.gmail.com>
 <bfe1ae86-981a-4bd5-a96d-2879ef1b3af2@redhat.com>
 <CAKPOu+_jpCE3MuRwKQ7bOhvtNW8XBgV-ZZVd3Qv6J+ULg4GJkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKPOu+_jpCE3MuRwKQ7bOhvtNW8XBgV-ZZVd3Qv6J+ULg4GJkw@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0050.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:b::9)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6775:EE_
X-MS-Office365-Filtering-Correlation-Id: 81765614-a871-4efd-3a88-08dde947686a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3JSa05NbkEwL3lqeUtrUVdBd3Y5VTlTK0ZNNXhRbmtSVEYvajdQVVpIZ3lI?=
 =?utf-8?B?MWVpOFFZejQvOEhYemRRZ0hsSkd3MUUyYjMvTUo1ZExuRG9jZXlzc3pvQzlB?=
 =?utf-8?B?cDA3djIrVlJwL3FlK1o2QVBMcXV3bDArd0Q3QVlGTHFsWjI1V0I5RGpzVklR?=
 =?utf-8?B?RGw3YU5ncUR1K0x6RE45SWxvSENSYmpvY2tNSXpwN2Z6WXBCaWsrbTNFZjJM?=
 =?utf-8?B?emtVdE5GN281MVpaY2J3ZnFjVmtzOGpSd2RiaDQzZXhGUUcwWFZpRW1ON0Vy?=
 =?utf-8?B?NGxKenlKTkJ1bytwbWNxSm1BRG11YlJvRmtzdyt6bWZ0UVRvZWRraHhHcVNT?=
 =?utf-8?B?c0dyM3dhazBiNFFiRWlsRTBTTVJlUklMVVRJcUQ4eFp5TnBad1JySE9KOHI0?=
 =?utf-8?B?bUtZUDIyYjRPSDY4dDAwa1daeUdPTDhQTUlVUjZSbzk5UzZTSnlkM0FVUDVn?=
 =?utf-8?B?N2lXcWFBMGJDNmJIdnQ5dy9taFFDMFlucEVMWjhsVVpKR0h0UkxEL29UUFRu?=
 =?utf-8?B?MGV6RW5aRGkzR0NWNkV4QUx2QWw3ZWM0S0dDejAyOFYzWDYxZ0lpUVVpN0Ur?=
 =?utf-8?B?aU03dVpJNG1GR0lBS3NDQlBzZXVFNG4yOUpIS1p5VnVSUWhsK3gydmo3ZVlp?=
 =?utf-8?B?RWwrcDVsWHF3QS9XQjZReWVBYkFobGdRYVZYeUtWViszNS9zR1ZFNWpTNVNW?=
 =?utf-8?B?blhlQzdhNk5JckZVajViR3lLQ3Q3OUJqZlNJNmdoaE4xbnVnZDNpNFhBZlk0?=
 =?utf-8?B?SmVRYVVkY3ZTSGJyTXpzaUhna2xTdmI4L004Vkt1aGVoSStSMVhPVGtJM0xV?=
 =?utf-8?B?U00vZElrMDdielltT1p1MEoybXNtTjhENzY3c3EraHZLenJZdWhPejE4cDZh?=
 =?utf-8?B?djZvdnVLRGV4M3R0N1NvZElvTVl0cjRVcnZWQXJzV1VWeTc2cGxGdDFVTVp2?=
 =?utf-8?B?YlYxbWtUYzBYcXg2MEFrZTVBSCsxZ1I3WTNUMnBZYjdTMW5weWF3WGduQWgv?=
 =?utf-8?B?Unl3RDluR1BwRFhCSElaaFNRK09Ea2hiMXdzeEJqSkd2Z2d4RkRUY1lGdDE2?=
 =?utf-8?B?djh3THpOMlVwQWRkaWR0cFpLNVBxdC9VZk5WN2tNNWFBb29tZjhkZmppUW11?=
 =?utf-8?B?bWFncnJ5VmtoNlJGWEtMOUJIM3ZhOFVXV0E0S0xMZUgwcEhLVlM5UCtMci92?=
 =?utf-8?B?Z2lGc2ZYNWRlVWtIejJ4dGJWbEp3K1lhU2F4ZHU1TWZZVlRwb0g1d1h5aks3?=
 =?utf-8?B?MW5iRm96T0xFNkdCSVp6RDZSU202K3A3YTJkL3JsL01Pa2ZURnNBaElSelUw?=
 =?utf-8?B?bGQxaTRGSzlqTzlFQVRvRkVPeEUyS1JrVDRGOEhBb1pxZlI5RHhOZGI5SnlY?=
 =?utf-8?B?MmY1dThEYVdGV1FiVU9wZktTVWdnMjMrUVZ0aGpGNTNZQ0JRVEE0emRGVDNh?=
 =?utf-8?B?aUhRQUFsaHJtbm82Mm9oS1l1bFp0SHNPSGkrY2pSZFlQUjdBcVFlSk9qem5l?=
 =?utf-8?B?dVBnSVBqRVpkMmtGVkIvWXAweEVkTGl4ajJLMnBCWjN4R0tXY1BURk5Nb1E4?=
 =?utf-8?B?cElqZEhySjRTN2xBUnlaTlVxRU1EdEt5Y3A4U0hvU1BHbWdpdXAyMTNMZ2dn?=
 =?utf-8?B?cGczL2dMbU5FT2JndXZSay9IVVg0NWxaZ1Z1OG5taURuOGVMOVRUK1dLNUtS?=
 =?utf-8?B?NmNVeEV0SWhpTHlJeS84S00vWEVCSUdiTGkwZ0sxUE9NNEtLSkppbXNkK1E2?=
 =?utf-8?B?Wm9EN09WdG5vLzZYYmlnSmJjdUtiK0o5elZoakxpMnp0KzRGd3U5UXh6TGU5?=
 =?utf-8?B?eC9RdnNXR2RNdUVTVFpLSThLYmQyWHhOQUpaVXdnSkpyV2xpSko0VGIxTFVn?=
 =?utf-8?B?bVJkaWt3Um45T2RvemZpckJobk9ZZGtkcG9sVEZHUkFzZHgwMGtuNmhub2tK?=
 =?utf-8?Q?u8TCLoGSQd4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M05LblViUTIxRHNrUFpHMnlUVHo4czZBbmxzaGxpWmtNOFZkNUxOcFplRElO?=
 =?utf-8?B?b0lIaE1OWGd0SERVMS9QRUJUWnBjMFFMT2R1UitYZzMxOXNkNnYyblN4TEI0?=
 =?utf-8?B?VTlTS1hiQ0JXTFpTL1RQQ0Z0OFBkcDc2MDU1L2EyM0JqMU5IZDJWNFBTZUlh?=
 =?utf-8?B?YW1XTlRKUGlUNytCNXJPRHJ4dmJJNjBVRkRtemxudzZIUGhhL1U2OSt3VHRP?=
 =?utf-8?B?SWprd3NFZWFzT0llZ2hjNHpEMGZ5Rk9sejNyOFlLNkI0TnBrK0pTbTBMUHFq?=
 =?utf-8?B?VXc3ZStmclh5eWJaNzhxSjFxVTcvMFdZUSsxd3JkQUdVVEZQSGdPcitSOGpw?=
 =?utf-8?B?SFlZU2txRWRqV3BqaFdVQUtzTUlFSTRUUEE2RE9CblRYSUt0UXE4NytJODZ3?=
 =?utf-8?B?d0tNMGVBTW9OMXRLZzVIRnNxY2Fvb2lKZ3N6RWo1bmhwRndub3JyQzl6dGpO?=
 =?utf-8?B?b1FTMjVtYXdjY21RNDV0SmRIbGZaaSswb05oNXFJaGRrT0IyY3dNVDlWOWRS?=
 =?utf-8?B?MkZZSXlmcWcxRWRGVWhvcm1qM2JiSTRlOHJIdFozWFgxNko4TGI0bG9MTDNj?=
 =?utf-8?B?QWVWenpENHhxZUUyekQxL3pZY1FoeUMzWmNYL01BeW1FMlJPYTBqTnZJK0hz?=
 =?utf-8?B?V0FhRXRrTUp5aWg4WWdVRGdzYy9DV3picWFQTFlPR096ZTY1K0tGRlV4NnFD?=
 =?utf-8?B?SU53NnFrL1QvR2hXakN4b0k5Qi9QR1plb0Z3R1lsRUNONXg3ZjRFMmU0cElB?=
 =?utf-8?B?b1pOamZtWDcrRUkwUkUwVGQ2c3JBejhDMTdvQS84UXgvM2c0dTVoSXJFTlE4?=
 =?utf-8?B?eGxVdWdOUmkrUVJnc2tXMUlmNzZGVjQ4aE0zektpdnAvNmVYQ01SMFlXZTZU?=
 =?utf-8?B?OGtCNmgzam43M0N6U3ZQMDNNdXJ6aWlFbnZNUitpS09qZjVMNW5uZ1pKQVhm?=
 =?utf-8?B?TGhRcnp5eVNzRkZkNnZ2Ty9KTGpUcFpjZU85TUxrTnNWYTA3ZGlvVjAwZnMw?=
 =?utf-8?B?a1ZHZmliRmh3bVEvUC8rK2dmUE1jTE5idm52K0d5Q3pqY0FuVmJ0TjNpSGNW?=
 =?utf-8?B?Y0hOQTdHQmZtNllNY040VnZCbW9FQW1lalNHR2RpcHl3RVBQYjM5d1J5Zllm?=
 =?utf-8?B?WGVYNGoxZUl3bDZ4WXZVVHQ0VWE0dEdlbTR1alVUTHZ4d24rN2xqY2hQTUs2?=
 =?utf-8?B?dFNqYy9RUllTajBvQ3ZPK2JQZnVvaWdXQlVRSzNabGl1WlJQSmtpZGxMWWNm?=
 =?utf-8?B?OUR0WGpORHNIdngwbWozdjZQMDlDVGJMN0h4TlRqTWM1Qlh1Y3dySW1EanhS?=
 =?utf-8?B?Q3FVcGpTaFNqOEYxQk00L1RmcFZkNDF1T2tLYXpFT2NVZVJlb2ZWNHJNakY3?=
 =?utf-8?B?WmxFNm9qcDdKZ3krdWRRRmFFTUdBYXl6TzN3U1hWMGdiTjhJVmNVZ3MxUHR5?=
 =?utf-8?B?cVF4K3hSMjR6emorVU1CTTlRamFzZ2lxaUFmc2Jha0p2dG90OHJLemN0bDRp?=
 =?utf-8?B?L3BqeWg2Z2o4aDVmQ3U5UWRJRE1kRi9oSWRUa0JyenRoNUJvV1VKbWxoa3Vn?=
 =?utf-8?B?ejFBQnhhem1jMThCVnJHVk9DWXVvc2RTc1JERWdMOWJDVlFVc0FpWkZnYUlw?=
 =?utf-8?B?dnlFV0pDZW50SUhFSjU0eS93VDFqR1Ayck9RODJVY0VlTmIvSFFzZUtUNysx?=
 =?utf-8?B?a09tWUc2Q05LV1NGZTdpam1GVzd0R0xDNWxvVC9vTHA3bzg5YWp5d1FKbXly?=
 =?utf-8?B?K2JyVFd3aGczZEc0YmFGWlJmZXBmQkZJeTA1SzU0VEJpWjJHNVhzbGhSNEYr?=
 =?utf-8?B?VGtPdmNEdzUwUDE5U3hGVzNseHczajRNbitYMWp4SVhkTTVDSDdkc1p2QXVP?=
 =?utf-8?B?VFBtdlNNWHVTb3lCMUpndWNtRlQyTXFaNnVCWCtoSjZJOWFibEtEZXg2N1cr?=
 =?utf-8?B?VWhqY2FEcmhCRDIyYTVzeW4wVzdqWTRLbDF2K2pTSmRhL3d6bWtGLzRrb1po?=
 =?utf-8?B?eGRsUzk1MDhjWm1tbFBBbG9WdldFVno0dTI0azlYQjlONEpUMTJlSkpsKy8r?=
 =?utf-8?B?bWRuOStILzZqang4MnFsMTFTanpTM0hoNUFWRjVaVmc3T2NtMDJTSnZYODh2?=
 =?utf-8?B?dDRsUEtRUFlHK1I0YkgvQVhhMEZvcm5ML2hMbzB3cUg4OHJqZEZLZ01vRUdN?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FV/Em/BuCjKo+K+3uSP846sBXRM/k58+wFebkoExpAZjT7HNBtzMrPzZjHz9DegJTZ6xqlu5ONvhzbj7xW/75Jl2ux7NNHoBFuG4k17+fEJ/5ypZVMNwvEKoWuN0bEDQ5qtmO7ypvXVELc2qMy5xhK+wkS5sG2nqex6MtSU/JkAeCnrQpaLn2be7/M9ty52ehTmZIQLWrsn18kk4A/FDwUuZtvodUQ788kSvAdhCn+SGTGJ/6OAwZ3hjomXhZWaEhwXBFDvWEb4MJXhgDl5BL6ItTQV9NkvWaFWk0+hh6CLUXc2txlRB72EuDNBnCWM8xl8f8ILulno0n4t9V8sQQdksxieUcNmHqlOUlEFBqnAdxNG3qq9/Httvld7TYQWMrgmbFkOW5MS7SudfC44kG3ww8St9e3ripndZ0sGg1/usM9qWSuFZhKYn8x5Tgi78Kf6UE3nSBjVPRL6IvRBMO9sfHQq85Cz81XFzIhlfOrGAt3o35KB8kcSdFkCl6AduoPHBQ9xSHbVW9rSNI4ZSpxmWUlhSmE3EHbMnnrlKe02nOvD28dWjXXoMXbE2okf9jURq/wddNt/duJf64NYLWBgkMEIjKm97OMcrD5f6M4Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81765614-a871-4efd-3a88-08dde947686a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 11:05:06.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2No/iLWKzl+tro0D45T6dslgmKvhgO9FRF5GlkCYSbaNnNX3TDZrX6JZoMmnKaJIAAvqfMDMlF2+ksFpEn6Q4JCvCBk6PRPWZbW/AofV40A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6775
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-01_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509010118
X-Proofpoint-GUID: 2OKkVM8j_FiUIFn_sxRBQnvPDlETOvWx
X-Proofpoint-ORIG-GUID: 2OKkVM8j_FiUIFn_sxRBQnvPDlETOvWx
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b57de7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=6dd6xkbKkwb0OfQoy7sA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX7LCMpKcTZtsz
 8e9HqDlbBWmk76ykUBoQ8l8syge/kvxiI0YV3wnRxNHFcQWYHffFalfwbO3CaRaUfGs1WE0Oxn8
 RndgPGKhalmUYTz2PDsea3CVIjUn2AHzzYA1/sheLABV/iXs9t6SZEWw+1b9O/TZOjMygXZgi6c
 uS5OpyYXmkj0tBRz4Re5kgQRtd5AYZ36BEbK5yxz6izNYuf9O75seZwvx0rx7ZkmirbmWDT4nbB
 KVugD/9Pw26r6OUMuPH7lTDj1cEKNPVG/xEVVEvYcJdhBXNr4V67KStQV/e28Cc3eCTDIiGiHWv
 Fykr+LUdpcjwtswmlLhc92kQSaV/CNn0D8yZH/r8uGS+pqUtAmi20gMPAGmL6sVsw+qoPvSyGs7
 k63C422Z
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60370C000B
X-Stat-Signature: gr6jaszyzqu6461yss165y4pqt4196kp
X-Rspam-User: 
X-HE-Tag: 1756724742-349865
X-HE-Meta: U2FsdGVkX18AEGPnnrCS/bQT3AxchKUEvdOYm2qQrIIn1yzgOTEiHk1m0tXvYy1O1b5/GBWOg7q0NEQxD63NgEm3jkK7RPhEyLxCnbLv0Yc+DC1QvlNVWN129H+emgX9Z18/JcCaEOeFpPqTquq4VSbG+cP2SkrsEBm4c1328OjufXD05sz4b6RF5zVDJnEXo9xBqmADdc/fDa8HTmDtXA2CzahQlJ9zdtH1AYZoJDhXTqI4GglU8EX6fi8Y+zW2GCEMWMFbYWUpzgRXhcz95XWDu4gda0PZA/ihRaUGD+d6klwdoCdbr76PBjBZebg5fqjJJ2BCXFxplLKCkF9iqGy1k8s9YrLBxvUD9C16Lj61JR24mv4TlZRlpdRiSvi/msr0Oh3VG1lOHLJAZWFD8HVJc4URIwPnP7Q9+IYDSDyqnysmZVJsjfVF7BxKYCMKkvaUZy84oMp37tzKlL4ZXM56ctb2+Vd/sCMX5uCVSDx9d8wTECjx7iP+w1BYWs5tW3s7+TcKLl3x8V5GxrlqGAlYErR1eHbkYAw3KgT0Ck36xIt1Hx85NrmF7TYUwFr7UqLuDQu3HCtS0VZPhWlOt9ulsf6kZ+iVbE14W+zIUNi3kSytS8LjDzHdS8SWtuhXAra1lo2sF1huzNf9JXDuk326NE4G8RUk3k8Orj7LRjn5CQX47rOCxdFo226NjQC7LkZsVRAIxVLWSmSY9vbdgComwmWOQ+Rn34ZWLucsHAzGhP8U2686kpcb3ejQbMlb59NKH4JajlfdK+Ua9yr3qW7mAOqj/FauaCv/myZStISZx6+CbS1BO7O6KEbPEjY1rqnE/iWDroWgecXUmijz+kltjYoOw2Op7IsnGWbfamldr7AUUxSAe1pvohuK+kM7ak6XOf+bNJ/CHauhEq+mjAcyyuBcbnK2blYge6Q/npt4m9JjMNPbbrFDls5tIcybrHjxP+nWwPRnov2vUlL
 KXR+0Eds
 YKrL7UH0srVeJIkNoys9R3Qxbl7ZAON1sYqFPCr6S0XqQoH9DTylsL8ZXGvrNu4iuWdp55Mf8h7ioNxBebMksU9iMYh+6NzMAVg4/k4SRTCASH/bM/FpfQKX26x3TXBwGbC4u4/FfszLL/Z2gBDQ7SVDF6Px9Bhg7OwDeo2CimuuyzecvoGkhyDQo/XDN4K4a8yAeU2am5D1oi3zm43Dk3FNhaAT1zqQxY4D18w3ayc6J/uugAi/9z+gVdhvYwDEGWT4jtUArEyCalLuuUVfpAFFGX8nPjvw5lVNldLGeKKytFtmTQFNqDec76Vh3fSwT0RCidljFkEu67UuoLFzzSQcTX4t2k0rwolT+JWkygZwiRw7Iz9IxN9bpoEzEJ0aVOK54OePpnze90CZ72LDhATTdhgfaRbspKz2ooFY6IYc+CryTr9FLUfIwZWUk8w8s1Pmm9T11vdAFPqcaWY1VUmKO/ZZC2HcJM09ClzccVfimW3uH/MMc8yxQoyMrXTQolQ04D9lV9ejrH/TSM0BxhTINptefWYiwSEzbnbLsI+3THGKkNw8++33xMjZWj7mjnED+tMUVeFHh1HC90+CGAU87MUElIePuh3CCL59NtBWZ2oBi5Go5jMptsVOy446c6w4x8onJin+hQmgV/Jti1II4f58oX/bUDzNr1OYXEz5X667Uau4AC4JMKavQADZql/C2AMwtKSww9gtJUK+stNzWnSKVNE3BfOxbFWSB1zu/2eNOmzt5SfpSz7+BbCZdGRUt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 12:54:40PM +0200, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 12:43 PM David Hildenbrand <david@redhat.com> wrote:
> > Max, I think this series here is valuable, and you can see that from the
> > engagement from reviewers (this is a *good* thing, I sometimes wish I
> > would get feedback that would help me improve my submissions).
> >
> > So if you don't want to follow-up on this series to polish the patch
> > descriptions etc,, let me now and I (or someone else around here) can
> > drag it over the finishing line.
>
> Thanks David - I do want to finish this, if there is a constructive
> path ahead. I know what you want, but I'm not so sure about the
> others.
>
> I can swap all verbose patch messages with the one you suggested.
> Would everybody agree that David's suggestion was enough text?

I'm fine with:

"constify shmem related test functions for improved const-correctness."

In the summary line, but, as I said on review, with a little more detail as
to what you're doing in that specific file underneath.

You don't necessarily have to list every function, but just to give a sense of
_why_ you chose those.

For instance:

	mm: constify shmem related test functions for improved const-correctness

	We select certain test functions which either invoke each other,
	functions that are already const-ified, or no further functions.

	It is therefore relatively trivial to const-ify them, which
	provides a basis for further const-ification further up the call
	stack.


You can re-use this kind of text for each adjusting sensibly as you go and
noting the dependency as you mentioned I think at 6/12?

Just something that clearly expresses what's going on in plain English.

Cheers, Lorenzo

