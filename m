Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79625CDC198
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01BE6B0088; Tue,  6 Jan 2026 07:54:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5396B0093; Tue,  6 Jan 2026 07:54:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CAD6B0095; Tue,  6 Jan 2026 07:54:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE4DE6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:54:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C83413B42A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:54:32 +0000 (UTC)
X-FDA: 84301532784.13.D67B196
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id C77D780004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:54:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a3RImx+N;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GSecK0G/";
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767704069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zgpT9XxOrkD9CBa4/znwRfca8jfjYp3NinJaZfgr9g=;
	b=FOlcSawC7I7OUNcuY/DecS3JeizT9q8yL3auUK/81ul4oB2G/VBHb5Qj3mGV9SOaQ42uiM
	KL3NYwKjcisrl3AnBPP7tnv8KtPO10OdHuKQBQvHnFUjheEFfPmdfSwUeGHtW5RBHas7JN
	keO1RW7bSI+9OXeh0jAuqeeTqGZAg8I=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a3RImx+N;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GSecK0G/";
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767704069; a=rsa-sha256;
	cv=pass;
	b=24Yo5Loy7d4XQUfb3Y1X3j6CK2Sh1lusHl6wfcnK12Dye1YIpMj1x6iWqPkWHLgFOBaVmh
	tWUFEqw3OkLLQE4P/ud7MjcIWW7MaTCygM/1CVe485vTyVMoC9jHugXauifSlrRiET2wkU
	Hlms7dx/HgRufGCvANGOmSNjPiXB+TU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606CKIHf3516509;
	Tue, 6 Jan 2026 12:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+zgpT9XxOrkD9CBa4/znwRfca8jfjYp3NinJaZfgr9g=; b=
	a3RImx+NOxnXtyYq3SfwEySxLrD/xJT2q4pLtEOogSw7HMy7D64h4qpa9RvNbaU6
	2Q3rIxFHUyzlD8hnUHQXWt7GYku4UNyOTiHO5GSGw4C9TcODCWuMSkJ6T+NgTdV3
	0cDkrnV8/dk98RqKVeKKsL67QqnoNeaGcu5xDM/zTh7DFk1BATMT7nHPRRb6LtS0
	fNv+d2rPqFF1yPABKBL7/lu/ZayG6M6neJ9GrhxI3A9AKlSDS5jRrISje2C+aeMH
	+GyTd02ncifwBSX3xm0oqk4+YgiKz5acD9E/V7y7r7bT+0O3ZIeIYRU9QGzMZRrK
	wJpfJktMYUIsO7HReN6csw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh1ddg2n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 12:54:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606A7Rb5007445;
	Tue, 6 Jan 2026 12:54:21 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjtdpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 12:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFLwf8+mkI/5eKMy+uFMllGMBG3SlgBdcz6iy+TNuJUMJSmZao68pdFJoyN5jxvOR3JZ2a88bCW/lfenRsQrpG6lbxIe3RvXD565lESI6RkicM1Mr116HP9MopTaUovaEA0QVb6wfZlIC0Jyao/GRFGsKVg14nDWQPDA42iuCottfYzlkTe+BdQ0ZlPfgy3l9CtyA4V1RdKMv92zW8WD8khvIP/ab8AqySK8spkbgWh0Rz+8GwqwgjVr+/uCGtpHGFXNECOhH5QUrPdXrRaP8s8duaOq7ybiELG4UjpmR68+lG6wIYobX7umt0KSDNMfyYQJn0IIiQ6OS4c9PGRicw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zgpT9XxOrkD9CBa4/znwRfca8jfjYp3NinJaZfgr9g=;
 b=VFzvtrXk0JY4YYRP2F6dWraMr8sa20CZmlZFg2j6fZ+kIjPseNasteDKyIjiCUkO5bCLq4A376Az+sF3RtdW55Vd4hEYc4L/03yU8WntQjVhHzprNjQafh0+P1iwRJJbyF+gZY3wAkNtTg+1xB47b0gXVxSRcN9mNp8R/vJrpUFFRbRJ1xqab53uWj5Izy56qrQ3WR3hojhC74sJpJYyDTWHojgvNQPcysII3KSVcZYhliAjsZ3X7OCfFLoyK39eYotrioYftq+VcRhVHcdDYX4gvyG+9sxJLhMPjS8GLa9Ml0OzjFnOGN0iPrDqqzxMevvnQ1EMwQOmgBBCPw+4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zgpT9XxOrkD9CBa4/znwRfca8jfjYp3NinJaZfgr9g=;
 b=GSecK0G/i1uffxNzdk04WA7ECCrhdEEvk3Sw/GcQxG7SY+F51SUeNP1BzFBsW2e6oxJsU5RKIjyNyVLBKyyENqW0R7OqyuwkpSiaybXSuS3sQAj8peO28FsVWiRnI1ayX8mkznwoV1+7dCV3pimSkRmzhZaQEKGZX5jmIHoxStM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB7724.namprd10.prod.outlook.com (2603:10b6:408:1b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.1; Tue, 6 Jan
 2026 12:54:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 12:54:16 +0000
Date: Tue, 6 Jan 2026 12:54:17 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <13c66c95-ca0d-4711-b755-676ec4066811@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
 <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
 <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0143.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: ba44298b-598c-45f3-d2a7-08de4d22b2c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QndzNG9QdWRORUpPVFhILzR1MnVqOFJVYXFMQnZjWm5GRVBHY2ZqSmFZRWhy?=
 =?utf-8?B?Q042MERDNHo1MkR6SFR0NlVCR1pjK05OTGg4RHdiYVNxRWZZeXgxeXNLOERn?=
 =?utf-8?B?SUZybmF4MDlrT2xSRURaU1RvWVNSRjB2MVMwVFg3R1B4U3c3V0UyYTBXcUxQ?=
 =?utf-8?B?OTY1TWVYTXpMRUVzOFRaMVF6TVZrVVNnQlpRWklhb1FjRllHMno2OTZUTmtJ?=
 =?utf-8?B?UUdnUHUvTWJ2by9zMjNCQjBoSm1DM1pIeGhxWjZmOW9LSVdQY2ZvdGpzeXVH?=
 =?utf-8?B?QlEvbGhWOWxVdkFjM0dlMkxTUnlmR0E2TkFtbUpwazdKSlBtdGdnNkV4R3pi?=
 =?utf-8?B?L25PRXF6OTBSWGxSNVcwZTBwbTFyd1U2RmNVVGVMaUltVFhGZStjbWxReFBI?=
 =?utf-8?B?ZnQwdUIxbk84VnZpaHBtcjc4dmVVQndTVkxTRjFPQWxWTVZoV0pkeHRucDV6?=
 =?utf-8?B?QWlUcStKSHpKN2dmOWUyMmpQYUh4Y2lieU9aS2poc24vQzd1eGlhOW1CSCtZ?=
 =?utf-8?B?SXZKK1dISDdIOW52TFJoUjRCeU9pTGhhT21qTEl3NlBkYVhaQ09VcndYLyty?=
 =?utf-8?B?QnFIeEsrS3RmNlJ1SW9RTDduajVzNG1TMFFHQ25ld2JUaFFaM3BVUWtad2NM?=
 =?utf-8?B?TEZrbHdjMHl0UmRya2tYWDdTTmUzQjV4a1FITXhnTVFNSlpvTWFnUGtTOHhK?=
 =?utf-8?B?c0F3TzgrRy9YOGNTdmFpa2Y0RENpNTZxZkN2cmVCYnhnOE5QWUZsV0dLTE9h?=
 =?utf-8?B?NzdUOXZ2cThzLzlJRVZzWEE4dVZTTExUY05NaVJ3YUJSQzA3VnhYeGtlMVRz?=
 =?utf-8?B?OUZHZ0dTNi9aL3hLNE1MS2NPNitHU0s4OVNlZlo0bUs4MTJDbS9QREp6OWZj?=
 =?utf-8?B?Yk13RWJLT0l2RTdsdS9JVExBRTRMQlN5NE5oaU9KUFMyeVZIUjBld2sySjJE?=
 =?utf-8?B?TnlFWHE2bExqeHprUlBKN3hkYWlWd3VTdVhoSmRldG1zYjdtcTBPRjNMOHRa?=
 =?utf-8?B?UXo1c2ROUEovOEdYd3RNTGFTODhxTENDTXo0QWhscjh2M2tlUm1aN1lXQ3Vj?=
 =?utf-8?B?Ti9sZWFaWFdLakpsRjFjc0xZYUowMkh1WVhCSWdXS3d0TjNwTWUzT1M5dTkv?=
 =?utf-8?B?WkVWV3kvQlRnZHdwSkttY0hldXhOODhTWmc4R2p4UlhpUVhvczVGck0ya2Fl?=
 =?utf-8?B?Zm9pMzRSSWsycGc1S1BQMmJSWXBlZWZSVVBpdkdoVktZOTBuRkUybUViTkls?=
 =?utf-8?B?bDdMK2owQmVadG5GQTFCV2lyUm5ZejhoM05vYjNJZG1SWjJLNFNMVWNoSFlY?=
 =?utf-8?B?YlZtVUxyQTFCbG5GWmZxNDl6QWpFVjBUejU1Nlp6alM1NmE1TXpUbEl5WG9Q?=
 =?utf-8?B?clA0ZzlWR2c4MmdYYzhzaitZWWhyV0JIa3BIRnhXbmduNFc5ZUwyRUlIYjI1?=
 =?utf-8?B?QkRsNzUvbWFKZ0MwWUNIZDYxRmlhZEgwY2FZb0RBQVc0dHNjSnUwTHduWDE0?=
 =?utf-8?B?WlRBTGVEaUdSWWYvclBIeStaUkNjVU5ZOGFkejNBMEdvVUtHcnRIeGFGR29z?=
 =?utf-8?B?UkZ6MVdQOS9JNmhzcFRpWWN0THRoRjN6MXUxS2FlUVl6MVVSandzR1hxSjhv?=
 =?utf-8?B?YW9XNWJZMkdyWUNlSDQ2cXFBMmttK05RWm1yRm9wWXY4VVRvK3ludUlPdjJQ?=
 =?utf-8?B?QW1SdzZ6K1R2MFIzMS95N1ZqZXdRcWdnbjhveFJieUxEV2dPWkZnOTFvRkQw?=
 =?utf-8?B?cnFNRHF4TTR1MVpYY0pKSXpRWHFtb3ZSUG95U1ptbUxyeG1xRHJIanhheGJy?=
 =?utf-8?B?M09wR1pKTmx4ZERCTUVvREhLbWZ1TVdRd3BuM0dFU0pJdzd6S1VoZWhQeUhC?=
 =?utf-8?B?eDErbGR5ZjgyS2VDUkJHVEZBRlZaVVhadUFQY1g4QldwSDZBZXFpVjdjTjE1?=
 =?utf-8?Q?52Wm0f5CS5fdJ2q7sfbn4pc92XTnX2hB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekhDWU5ZU3VjNTRxMzkzSzBrZVpjSUxYRVZHRVluaVJPTG9POS9WSWtYeVV6?=
 =?utf-8?B?ZEFMdFVTdEt4RysxRkZQK2gzQ1BDcEFwV0d6UE1ITy9xTHBqRVkzWVVla3kv?=
 =?utf-8?B?NHhNaDc2OG1iaDVjQnh6OTdGM2kwbkhPcFY0Z3g1MHJEcVA1TVlEaDA4L2ds?=
 =?utf-8?B?SXRNVWlJcTRrYTQ4NFVPQjBRcGtsTXhyYVBtUm1OR0NOd2VFYTZBV0FUNnNu?=
 =?utf-8?B?VE05MEttUUZpZXNBaUJtTFhDYjJKeGdaaGM3Yzc5RUQ3YTR6aThRREJxRU1r?=
 =?utf-8?B?YjlxdzZpY3k0UUlRQTVSZFlaSzZFSGkvTEJaTURreGVrcUgyZnI5dGs5dnc0?=
 =?utf-8?B?c2RWalFiOFlHQ0J2UThLVXRJR2FjVTRSQWJxMlI4YjZ5L3hIaHJFUE9vOWVx?=
 =?utf-8?B?bnIxa2xzcnJiSTFwa0xFanRWb2hrMjZ2QlE3eDZmUDk1ZmtKNW9rTkZEeWhR?=
 =?utf-8?B?NXR2V0tqVTB0WnZtWS9YOWJmYTFabXBpM2orYXA0VW5KYzlhWDgydkNRV1h3?=
 =?utf-8?B?YUpBY25ZcW9iNjl3eWNjbU9FNXhja2R1SWM1blBrVzY2SnlzZjh4QWtKUlNt?=
 =?utf-8?B?UTl4T1d1N1dza1V2SjRTSm93SmN0TCtQRzdScTUwc0hHTmVVVi9nNEVnMjMy?=
 =?utf-8?B?UVd2Z0lFQlJLVTZPT1BhbVFBWjRoNGh4RXRSSVIvMTZ4RUZVNHRlZFBKOXFN?=
 =?utf-8?B?ZGl3YmVJNyt5TU9ib0lVaHpUck1nOEtoMjZrZmdrMjZnVTNMWlZvTW0xQTh0?=
 =?utf-8?B?MTNEdUlDSlVkaTJPc1MzQ3NNVmMyRVRhVVBWamFPRGtmUko0V3RtbWJxYk93?=
 =?utf-8?B?eEhHNkRSZDg1cVpHOC9TbTQxOEM5eTh1RzYzNHYxVzhZVGxzZFFSWHd5ci9P?=
 =?utf-8?B?TXY0bG41ajVsOTMrOUVMNmhxbnUyYitLZTJJaE03YkRxaitkODA2U3MyWStp?=
 =?utf-8?B?Q3I5TDZSd3VHTXZTYit6VkI5M2ROMWMzL0NSa1lKbzR1cDVwc3k2Tm5uQzlM?=
 =?utf-8?B?Y0ZXZk8yQmxseHRYME1hRTlKWjFSY0xMNGZ0dXF0Z2tGTnVhdGRsSmcxdEFX?=
 =?utf-8?B?T1FTL3VqSzZZV1BpclYwZVFuR0FPN0xZVjVUYVBudlhrWjJrRDRwRXYzZS9F?=
 =?utf-8?B?eTU5bW5JdGZQZnJQT3FPQlJGVWM2Szl4UUQ5UXNCbDVJdEo4aFl2R0NyelIv?=
 =?utf-8?B?Q01qZk5oV0UrSjBVWDd5OERZWDg5a2hJNENpcHpwbTk3TWlkRTZqSDRHbS95?=
 =?utf-8?B?Z3hML3U1VXVydTJ1bSttYWtlOG1xa1FvVG0ya2hrdURSbUVJMDJTckdPd21T?=
 =?utf-8?B?WmhHZlJXZ1FsWFBKN1Z5MXVYWFh1ZmJGRS8yOVNTZ2paVzBxWHVTa1l3VWo3?=
 =?utf-8?B?cExabnZaN0UzUkdaQzQxNkhQME1hZitSWGw5UDBYZFc0Y2ZISk5kUW5yWXJq?=
 =?utf-8?B?QUZlNzRTcEJXT3l0WDFsdHloUmZKV1l0YmNuQUszU0MySHUxUHBzQXhhWEt2?=
 =?utf-8?B?OFBmMDFCR3BEV2VDUkhUMFV0ZW96QVZHc1AwWVJQR2J2V3ViK2hDa0VTMmty?=
 =?utf-8?B?NUJtVDRrNm56Q3JxYzE1N2pRaHFaWUhWT0YxbkYxSXd6cW9FTXk4MDBzMHE2?=
 =?utf-8?B?dFdlMVpFNjJ2ME5MQjlaYUIrM090ayt3R2NrTGdqVmswVXk4Qm5UNm9mczl5?=
 =?utf-8?B?aXlSWjhoREZpTjdyais1OWlRVXZ4Q2JOVEZrdHF3cjYxbkc1YUd0VlliUkxl?=
 =?utf-8?B?ZWVzcUNaYWdMakhRWUZuVHZxNWZ0c2N4V3htTGVvRDYrVGFRUW1Ed1k4TFZG?=
 =?utf-8?B?eG9SMXE0RDVZdzhYQlQ3MDRQdkM3TitubXpXK0JaL1RtVE9iQThwSktRYk5I?=
 =?utf-8?B?L2MyWGVuUUhwdnorOXhHSzVFbG0wN1hJdUZyd3Q0Yi94aUNpQTNJVnBpTkpz?=
 =?utf-8?B?dmNsbnJkYXIrM20vUDl5NnQ1UjlWK3hMT21kL3RUWWlzZ09DQUhLcm9ubzFk?=
 =?utf-8?B?TEhMbnJTZWtZbHZlKzdsU0F0Qmk5V1Ayb0Fqb2JIeG5SSDdSZVE1Q0NmaGVH?=
 =?utf-8?B?V3ZDYVRtWFF6ajhWZFBrVG95T1pKTHJqWUZWcldMWHdrcXh0RC9nK00xRDl1?=
 =?utf-8?B?ZS9YZUFmN0ZqNXN3d0Q3dGFnWGx3OFk2NkxyK3RQYkx0RittV0hJQUxzTWRp?=
 =?utf-8?B?ZnJoVTB6UkIxcmx1ejVJcVd0K01uVFo2R1pqcUtHZHhzRk1XdVd4dFo2dlZT?=
 =?utf-8?B?TVRvOVo3dDBYVzNJR1RZUFp5T1RDVlNjcU43aHhiYUtMek5CcHBTd3NBbksv?=
 =?utf-8?B?SkdoSDBtTzYvZUpqWGh1NmZic1o2dmRmYVFOQVNsYVdnY0pnYTdyVUpzSE52?=
 =?utf-8?Q?ZiF7ixKfKHT4aoY0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wLs96EropsHxDdOArsoKSDPF+WlCK3GCxpjAiS0UuE4O5lSA92PdyNrsx1G5L/CLYBgj6hYCqWNWKejW4YiCu0m9HVf84nGTd1k4gs5kV15yNp+t2IIWqziZi++juXZ8onDUVPUvhQgcv15DPlsXwK8eFU+7EfdB8SDCU3164eW5VNJa7+759wQxPsA8VGNnjkVDkyIy4mQO4aIP2lwOQl91e0gqCocg/lUTR2VLyomwlCq6ll4/FIbOlHHZMQYQzfr784ajcEggJxs04AeQ6YKY+pSNbSfzZgQ747WgOb4SspeLyBbz+APnqtE6ud8wVgjcVAL+npC0ocrUZAcnSDEIdcYDUl7FQSNV2nh75Gj/3dwXG89U14nKl2KSwfj/eLlgEug3Tl1kFsHguHU8F773EP/94bV2k4/YXcofjjJP7Obs/q23h1KAEoBtLowNO86fSA9re1OrlbICR1QUOIGVuU4PIndv7lvNsLI2WvIXdsMl/hr8kB9CHK6SUQZHEBz9OquxK9/sM9+MBYru0UJP5IAW40VxrklBHorhVAYJkRjSHorDoNcNpDLNFxRfyO9kw35DUkNOcY5mSoJlE9KBe6tUt24ZLvic179tN2w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba44298b-598c-45f3-d2a7-08de4d22b2c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 12:54:16.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZPnNu+SPocpXfWHmaHHXlmxUL/Z8Y+fIEI9ePGqjn7gnFzhU92FiJbTWvkEjpj5REyOzxUYzOBDQCJIeKQ/n2zl72u0rPq3Sdx7fB3dv8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060112
X-Authority-Analysis: v=2.4 cv=donWylg4 c=1 sm=1 tr=0 ts=695d05fe b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=qQ0MjFrv9n4IjJLk5q8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: 5b5f-tcEjYXBLvDkNxPW5a8LVJnn29jM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExMiBTYWx0ZWRfX12REq/B7jLYr
 9UuRLjVC8UWPNBOUl3A8reujDq9wMKHSUwyFtzw9LFBixbQEn2rdmabsf6zN7uP+psybHOAmOo7
 klRYCJpZsFzVbcPJHiQfFTlIZ0gA2UjA8loulcqBL6lIxdX7+zb9K/C4qCgkgI35iNViQmc7iRh
 SWDxz11bMrEKxwIPR9WNUU2+U3sLBgLxhicjkqJ5S99n4j1zyPl9Pv5jDzuP7z03u40nXgbVert
 NtK/obZgEHMYulE6AU0cBcJ/BdNctv3IwFmiEq+rzcJrBeTrPyKHEChqvdcITCsw6jbVH/p0u2N
 3C4xdR+x0QMCeSSGWrNqEbGKCYBrs107xBcQuCHlFZLDmPWfryLjU0sPNl7/Do1Cn9eqno7gZ74
 qyGOP0yByFGl0ZKTJiyT/jIQkO/R5OHliPpoSQKabLgeUYWq2wJtVf4FD8g7VnImveRm83N/0zs
 voN7mmrvnSd5S7xCkkWLQdrXEOmOB2YU+jQYx2ks=
X-Proofpoint-GUID: 5b5f-tcEjYXBLvDkNxPW5a8LVJnn29jM
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C77D780004
X-Stat-Signature: ccrm8b77mqem3y4mhyddwjq5j65xfkgf
X-HE-Tag: 1767704068-625225
X-HE-Meta: U2FsdGVkX19BMYWCMWyoTOkFsrDycXYokd8SMiqt37RICMOANjW34FOLTU5fHVvMQ3WMQUxqn2Kzbb79MRmnNeQHrQHZacFtGlAC5b+tzxn+cLUgBqpQzEyFIz5GABdYQ8kBjaKlQFGEu3GVexQyhoFW3Wv9sEUVeL9r3WOQtPWiJ6Pw47I9kxnkzRmS56e93wTFjqcj6Qz532pC5EMBwjnwPr6uUihCFuYa7fJS7Vehw4nmwk+4j97UfH/03Xa4nCnB72CHT9+DOxTBvKAk+q+G+k59le5YuXcOs8jjG+srRhJh4xZFdKXYgvkH+HXWLZBuHLJVWQUD/IDzhD/sEA/bQ24VtTGPOjIoV1VOhrqYvC23aBEHiXgotGo/gudDdEnR9fVoXiWnqV+E9U+4Pn1q+or5zxUYB/HZY7yn1IiE8cAodg2sd0YRN0XOIyna6oBJRlWb2FViOs5RvU2xTw8rdRMA7mjwgCw+5CyDMzvOeMRjw61+t046+FIvFDbYxrw9Zdnjbj0HfpIFCb3gPgGcVD+4f65Di7CEt3/jiVqv5BINY9Smv22RpbR30jdAJ5BsqBOBHMvQATnUh/5MKFQpMHVcwcfBuMaXdJ4O20G/VhuwhUDWiLxeNHN02MpwPFVxVDTqfxB3zgRYd7v1dCEzUh5CBWoxSsf1iq2Yny0D3Q4v/FHNp+zBLb1o20Bby1eyHoTrogG8312gCH6+SLgc/32pT7FxlhQERK0GuV+Zgqm+L5B+KxBjIgoHfHpVRYuz5o6GJqENr1auNlWDAfNbrxFbWHsBNZD8pUMCgGL8/G/dOG1wIGed+JjYGCf/DKPRKe80W/SzylIl5viURMCJJnGc2ELIpMbrJfIKxcwugwAhZqVQNj6t5sj7IBTSZNFxGtfNvOgdy6wtcxYy3S4yuSsTxD9PShdpRSZHUBGZc5vM+L69MDHMw2oUArbK4eu5aRh/J2yJc0qf170
 ysDqhhGa
 cY9c9mCzB5kp2ip1nQB4Fchf0QWM8zLUSiAG12Ya7oVj0M41i9h8XYywmlAhMgHJWnpcxztd9Y0a5a+biiVUOGY6KelBINpOXvciR/rc97x0K0XCl3Pmzc51+glSkhJMP9dPdty7+/pTQgHYYwjMmQQkB8U+sqm6WoSg3F0vf9iC33PSZjZxxmx9T2v/nRm/UeBmBO28ZyLdPKnx/zZ90/s8shTaZ0Q4c1KFC1WhZkomLk6sZbAX6KjIZZZ4r7RNYAVMWB18H8khppHpzTtPgqohnG3rhvR4GYPwYEi5jLkSNhiTHaOYLUTmzDjIrdWX6hnvWb6VpNJEoESHOhoOuuXLQioUZbml5fYSxpf1mdy4SbvSia5sKLP3r9GCUZiekgcASLUmisoZtoxoPRuFgK2+aPZA+08G/v+iLFbKPVCdKiC9Bsk4aUE8fxMshqrWAzDZCNqDnU5Fv/P00fmQ2vdZu+Ei3FNvqwvrWcgqY8BKWrrndoBJyImXhaba1GVDFox2rYpU62tZgWeD2q1lDQ+GStjER+XNlXw8BpuHtubnOiw7OPxkSL5z7J6lFqAM0tuwc4zm+H3+uHW/w5X5e65st1E/hi2Pn7hu6/2LvsBY475euYL0l8JQ5tjgQ8qIXaiwu7WRV8z3rveMBU/zTA0YtlNVgOhyMqNCfCM9R5uis4n70RNEA9/mwIyqL7whdQ6x6G8GAVRPLqjE05XqY0qc/zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 01:18:04PM -0800, Suren Baghdasaryan wrote:
> On Fri, Dec 19, 2025 at 10:22 AM Liam R. Howlett
> <Liam.Howlett@oracle.com> wrote:
> >
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > > Add kdoc comments, describe exactly what these functinos are used for in
> > > detail, pointing out importantly that the anon_vma_clone() !dst->anon_vma
> > > && src->anon_vma dance is ONLY for fork.
> > >
> > > Both are confusing functions that will be refactored in a subsequent patch
> > > but the first stage is establishing documentation and some invariatns.
> > >
> > > Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
> > > specifically:
> > >
> > > anon_vma_clone()
> > > - mmap write lock held.
> > > - We do nothing if src VMA is not faulted.
> > > - The destination VMA has no anon_vma_chain yet.
> > > - We are always operating on the same active VMA (i.e. vma->anon-vma).
>
> nit: s/vma->anon-vma/vma->anon_vma

Thanks will correct.

>
> > > - If not forking, must operate on the same mm_struct.
> > >
> > > unlink_anon_vmas()
> > > - mmap lock held (read on unmap downgraded).
>
> Out of curiosity I looked for the place where unlink_anon_vmas() is
> called with mmap_lock downgraded to read but could not find it. Could
> you please point me to it?

In brk() we call:

-> do_vmi_align_munmap()
-> ... (below)

On munmap() we call:

-> __vm_munmap()
-> do_vmi_munmap()
-> do_vmi_align_munmap()
-> ... (below)

On mremap() when shrinking a VMA in place we call:

-> mremap_at()
-> shrink_vma()
-> do_vmi_munmap()
-> do_vmi_align_munmap()
-> ... (below)

And the ... is:

-> vms_complete_munmap_vmas() [ does downgrade since vms->unlock ]
-> vms_clear_ptes()
-> free_pgtables()

I've improved the comment anyway to make it a little clearer.

>
> > > - That unfaulted VMAs are no-ops.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >
> > > ---
> > >  mm/rmap.c | 82 +++++++++++++++++++++++++++++++++++++++++++------------
> > >  1 file changed, 64 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index d6799afe1114..0e34c0a69fbc 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -257,30 +257,60 @@ static inline void unlock_anon_vma_root(struct anon_vma *root)
> > >               up_write(&root->rwsem);
> > >  }
> > >
> > > -/*
> > > - * Attach the anon_vmas from src to dst.
> > > - * Returns 0 on success, -ENOMEM on failure.
> > > - *
> > > - * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(),
> > > - * copy_vma() and anon_vma_fork(). The first four want an exact copy of src,
> > > - * while the last one, anon_vma_fork(), may try to reuse an existing anon_vma to
> > > - * prevent endless growth of anon_vma. Since dst->anon_vma is set to NULL before
> > > - * call, we can identify this case by checking (!dst->anon_vma &&
> > > - * src->anon_vma).
> > > - *
> > > - * If (!dst->anon_vma && src->anon_vma) is true, this function tries to find
> > > - * and reuse existing anon_vma which has no vmas and only one child anon_vma.
> > > - * This prevents degradation of anon_vma hierarchy to endless linear chain in
> > > - * case of constantly forking task. On the other hand, an anon_vma with more
> > > - * than one child isn't reused even if there was no alive vma, thus rmap
> > > - * walker has a good chance of avoiding scanning the whole hierarchy when it
> > > - * searches where page is mapped.
> > > +static void check_anon_vma_clone(struct vm_area_struct *dst,
> > > +                              struct vm_area_struct *src)
> > > +{
> > > +     /* The write lock must be held. */
> > > +     mmap_assert_write_locked(src->vm_mm);
> > > +     /* If not a fork (implied by dst->anon_vma) then must be on same mm. */
> > > +     VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
> > > +
> > > +     /* No source anon_vma is a no-op. */
>
> I'm confused about the above comment. Do you mean that if
> !src->anon_vma then it's a no-op and therefore this function shouldn't
> be called? If so, we could simply have VM_WARN_ON_ONCE(!src->anon_vma)

It's a no-op :) so it makes no sense to specify other fields. In a later commit
we literally bail out of anon_vma_clone() if it's not specified. In fact the
very next patch...

> but checks below have more conditions. Can this comment be perhaps
> expanded please so that the reader clearly understands what is allowed
> and what is not. For example, combination (!src->anon_vma &&
> !dst->anon_vma) is allowed and we correctly not triggering a warning
> here, however that's still a no-op IIUC.

Yup it's correct and fine but it's a no-op, hence we have nothing to do, as you
say.

I thought it was self-documenting, given I literally spell out the expected
conditions in the asserts but obviously this isn't entirely clear. I'm trying
_not_ to write paragraphs here as that can actually make things _more_
confusing.

Will update the comment to say more:

	/* If we have anything to do src->anon_vma must be provided. */

>
> > > +     VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
> > > +     VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
> > > +     /* We are establishing a new anon_vma_chain. */
> > > +     VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
> > > +     /*
> > > +      * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
> > > +      * must be the same across dst and src.
>
> This is the second time in this small function where we have to remind
> that dst->anon_vma==NULL means that we are forking. Maybe it's better
> to introduce a `bool forking = dst->anon_vma==NULL;` variable at the
> beginning and use it in all these checks?

Later we make changes along these lines, so for the purposes of keeping things
broken up I'd rather not.

And yes, anon_vma is a complicated mess, this is why I'm trying to do things one
step at a time, so we document the things you'd have to go research to
understand, later we change the code.

>
> I know, I'm nitpicking but as you said, anon_vma code is very
> compicated, so the more clarity we can bring to it the better.

Right, sure, but it has to be one thing at a time.

>
> > > +      */
> > > +     VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
> > > +}
> > > +
> > > +/**
> > > + * anon_vma_clone - Establishes new anon_vma_chain objects in @dst linking to
> > > + * all of the anon_vma objects contained within @src anon_vma_chain's.
> > > + * @dst: The destination VMA with an empty anon_vma_chain.
> > > + * @src: The source VMA we wish to duplicate.
> > > + *
> > > + * This is the heart of the VMA side of the anon_vma implementation - we invoke
> > > + * this function whenever we need to set up a new VMA's anon_vma state.
> > > + *
> > > + * This is invoked for:
> > > + *
> > > + * - VMA Merge, but only when @dst is unfaulted and @src is faulted - meaning we
> > > + *   clone @src into @dst.
> > > + * - VMA split.
> > > + * - VMA (m)remap.
> > > + * - Fork of faulted VMA.
> > > + *
> > > + * In all cases other than fork this is simply a duplication. Fork additionally
> > > + * adds a new active anon_vma.
> > > + *
> > > + * ONLY in the case of fork do we try to 'reuse' existing anon_vma's in an
> > > + * anon_vma hierarchy, reusing anon_vma's which have no VMA associated with them
> > > + * but do have a single child. This is to avoid waste of memory when repeatedly
> > > + * forking.
> > > + *
> > > + * Returns: 0 on success, -ENOMEM on failure.
> > >   */
> > >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > >  {
> > >       struct anon_vma_chain *avc, *pavc;
> > >       struct anon_vma *root = NULL;
> > >
> > > +     check_anon_vma_clone(dst, src);
> > > +
> > >       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> > >               struct anon_vma *anon_vma;
> > >
> > > @@ -392,11 +422,27 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
> > >       return -ENOMEM;
> > >  }
> > >
> > > +/**
> > > + * unlink_anon_vmas() - remove all links between a VMA and anon_vma's, freeing
> > > + * anon_vma_chain objects.
> > > + * @vma: The VMA whose links to anon_vma objects is to be severed.
> > > + *
> > > + * As part of the process anon_vma_chain's are freed,
> > > + * anon_vma->num_children,num_active_vmas is updated as required and, if the
> > > + * relevant anon_vma references no further VMAs, its reference count is
> > > + * decremented.
> > > + */
> > >  void unlink_anon_vmas(struct vm_area_struct *vma)
> > >  {
> > >       struct anon_vma_chain *avc, *next;
> > >       struct anon_vma *root = NULL;
> > >
> > > +     /* Always hold mmap lock, read-lock on unmap possibly. */
> > > +     mmap_assert_locked(vma->vm_mm);
> > > +
> > > +     /* Unfaulted is a no-op. */
> > > +     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
>
> Hmm. anon_vma_clone() calls unlink_anon_vmas() after setting
> dst->anon_vma=NULL in the enomem_failure path. This warning would
> imply that in such case dst->anon_vma_chain is always non-empty. But I
> don't think we can always expect that... What if the very first call
> to anon_vma_chain_alloc() in anon_vma_clone()'s loop failed, I think
> this would result in dst->anon_vma_chain being empty, no?

OK well that's a good spot, though this is never going to actually happen in
reality as an allocation failure here would really be 'too small to fail'.

It's a pity we have to give up a completely sensible invariant because of
terribly written code for an event that will never happen.

But sure will drop this then, that's awful to have to do though :/

Hey maybe we'd have bot reports on this (would require fault injection) if this
had been taken to any tree at any point. Ah well.

>
> > > +
> > >       /*
> > >        * Unlink each anon_vma chained to the VMA.  This list is ordered
> > >        * from newest to oldest, ensuring the root anon_vma gets freed last.
> > > --
> > > 2.52.0
> > >

Thanks, Lorenzo

