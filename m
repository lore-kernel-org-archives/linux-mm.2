Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B171FCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86808E00CD; Wed, 29 Oct 2025 14:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D2B8E00B2; Wed, 29 Oct 2025 14:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF128E00CD; Wed, 29 Oct 2025 14:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9CFD8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:57:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55C52BB9CB
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:57:26 +0000 (UTC)
X-FDA: 84052060092.29.9D04EE2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id B74A51C000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:57:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LhHKBxZ1;
	spf=pass (imf21.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfQzdq2DwYHhsed0mb14XfXMadKgk+YUzNYxAkraSXY=;
	b=YSYCTBcrgDY48Jdse4wB8G+79VfdLrbcoOXXEqI93+gNdg60RDd6fg23iG3V1c/zNjwqPs
	jkiApvrQ1END6i+5Mf9XfHgl2w2TmemfjKW27QeeGv3P9px6YxeJvZjnm4fkUpUS+JTcBN
	EXKHnEkNcD3jsqNtM2+dNViMQ2jkpbY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LhHKBxZ1;
	spf=pass (imf21.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761764242; a=rsa-sha256;
	cv=fail;
	b=DJRFm37ZmkfkR7bTXDAY61/cbhqJDqIoSSwWbncKzQM+/ZzpGqFBQ0T8Eo8cXpdF5rwbuA
	EPhXFA1dXXI7J6QLwCvKY7VfNpZZvxy8PzEnRIX6y0YVd32z8j18R1lx0awv/NNFeEzxv4
	AB+9o11pMRuXkPmPw2t4CXe2tTkjedM=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TBn4wC026059;
	Wed, 29 Oct 2025 18:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=QfQzdq2DwYHhsed0mb14XfXMadKgk+YUzNYxAkraSXY=; b=LhHKBxZ1
	rAIjTInVFg77BFCOijYJwsIwGgMEh2EJl8VRXt7thXURYsznUxfSZvbMzIPM2BVq
	9DHin4JvwWesbYDzdczc3xNYmrQwj7ZEdLjNdiCMpueoIp0gSomYpL4crhyZoSJB
	aTLmQ+LiV4g0L3n6WcRe71rTf2yaQLOOvLt102C/lf/4cd/thRzVkL6XW274G+CJ
	haU7WaTruZKa9pwj7yvtutyJsuEoN3LKAx2zld027YmqQVvfq3P+PoF91gCI4hW6
	yeGgZLoiwoSGQi7day0owKutU+yIgtTLQEmDo9j/Teu6zp+GqDKTInLufUMRG+Pw
	NMLImQQifjw3Ug==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34aamvrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 18:57:11 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59TIu5YO017178;
	Wed, 29 Oct 2025 18:57:10 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010067.outbound.protection.outlook.com [52.101.193.67])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34aamvre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 18:57:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bAvnxgDUXOxEX7AuLqUhGmYNywlhn3PZBUDCblZmIngP3MqV/qEANqIPvVZWxTMy70nv/kuNJNpgzcGUWG0cghFtIwtGmjMj/+hCAQBQfzLvzKorYV1RcxUtzLNx6M0xxH9BLzPFQOcnM5X6ZBn/23lzGgKCMKMf4ecgeWB5CxZ0l77rLhMZGT/viknikbypVBc8eZ6IdKSEDX0TDZJk8AqE3Xb6Kb+F/nrudG8hsWKcbWNBJJd/82pYsutXsNNNvdqjOQfs/hocT2CWP9P7WBUD51zils8EXLn5pqndnJ5STbPSU6zEJKvtri9Nr8OenUgGr45R/2VRCdxyGqfdUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfQzdq2DwYHhsed0mb14XfXMadKgk+YUzNYxAkraSXY=;
 b=K9GqBj0wEa3YK7b3vSs9k2cvtvm7giw6yfYPVKW7bfbQDqoCkBnrLbeKNXgxZO+Pb/ANpFLJ7VPJ+CsumMczVMyv24oCOfrdYtPURwYXUPtak5icKqWqsYMQsLdRBNILnd2Hr3l80f+aSWa4Yhx1hxZt59XEIGapnTHAKckkfflvgfPj8CgZCJePIymb6ko5n321M5d7HFwRMm9A/nsZ6h5CPY+Gb6A3MTgAqxNuzNw9/qKY+MYnAik8NKpTOgwChX14p92dm4plof6ez6p5eyAs/17XqShepMeIeQdLEj0KZnyhK+z5AkaJwAAqsYa+ogFMOry2jFOPmCcvLEx6bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BY1PR15MB6150.namprd15.prod.outlook.com (2603:10b6:a03:526::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 18:57:05 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 18:57:05 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Alex Markuze
	<amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
        "rppt@kernel.org"
	<rppt@kernel.org>,
        "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
        Xiubo Li <xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "david@redhat.com" <david@redhat.com>,
        "mgorman@suse.de" <mgorman@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
        "vincent.guittot@linaro.org"
	<vincent.guittot@linaro.org>,
        "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>,
        "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "surenb@google.com"
	<surenb@google.com>,
        Valentin Schneider <vschneid@redhat.com>,
        "kees@kernel.org" <kees@kernel.org>,
        "peterz@infradead.org"
	<peterz@infradead.org>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "juri.lelli@redhat.com"
	<juri.lelli@redhat.com>
Thread-Topic: [EXTERNAL] [RFC PATCH 1/5] sched, fork: Wire BLOG contexts into
 task lifecycle
Thread-Index: AQHcRMJAD+D5vK9eDEGWqh/dYr2+4LTZghwA
Date: Wed, 29 Oct 2025 18:57:05 +0000
Message-ID: <b46130d7e9232b3163db4299fdd09f73668f059a.camel@ibm.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
	 <20251024084259.2359693-2-amarkuze@redhat.com>
In-Reply-To: <20251024084259.2359693-2-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BY1PR15MB6150:EE_
x-ms-office365-filtering-correlation-id: 1b5bff09-19fc-4d31-1cf2-08de171cf3ed
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?aEpiOEdZOUw0ZGpiNXE0VSs1S29JR0xoZEpuclFvY0JuTE03NDkwZVFSUUg2?=
 =?utf-8?B?Rk1CZDZiS3FxNFU5VmdCQlVkaVlvUmxiL0ZqK3FKZytYRjhYV0ExeC9wVlpJ?=
 =?utf-8?B?REw4ZGxacDhQbFN0K1hUaHViTkNqbUtPU05VQ0VieExpNitPT1kydWtGRHZ1?=
 =?utf-8?B?WGR0bWVuNEIrYnZFb2M3MFc2ZDN1WVRKRTlRMlRONFM3alZZSU4vb3E3dUhz?=
 =?utf-8?B?dVVoWXZvRDRoV2dlYjRIbENqbmtjNjRoSlcxb1JXT1RFVTgrTmh0Rzc2Qyt0?=
 =?utf-8?B?RDdEcHRsMDBCVWw5bEhtWnlCSVFYNlR2TEQ0UHVOL2ZuYjhMWWZGUm5SVnRi?=
 =?utf-8?B?c0dhSHl0YjgzWTVsaEt0U0Z5bGRmeElEMEhaRHFmaXRiUzFPcm15R1pRYkw5?=
 =?utf-8?B?VWNXOE14b29nbkM4aWtWYUQ3Z051NXZ3QVJIU29LUmwycU9MdFowVng2Qjd5?=
 =?utf-8?B?V0tZUWxwdnNqcjVvclU2R1hJcnRHa3JmZGhOY1EvN3gzNTBvV0RIWC9UTmY1?=
 =?utf-8?B?cDBTVW02YkpWN28rM2R1TitWNjNpQnh4VWI5ellxUXBGQU95Zis3MW40a0FB?=
 =?utf-8?B?QXljTCt0WnpIdDNseGdXSWdtc25yVWMwd1R6WGt2MTFHb1hobXArbUFNK21p?=
 =?utf-8?B?TkRFOTQ3QWRuNFRVaUVVOHc5UVNBSGJoU203Wkdua2VMOEhoZ2cybi9LNWQ2?=
 =?utf-8?B?N3d4UGptOWU0cEFyb25MaVA5YUY2REU5cFR2dFA3UEdzQlVVd0pRS1lSNzg1?=
 =?utf-8?B?Y2ZzZWIraEJua0JWQWZ6Tm1YMm1Vall2M0UzWndvNWFpQjF2bmkxYXE0Q3Zu?=
 =?utf-8?B?c0VhcjVybTNRSiswNkwxNmdMaklJeTNVbThXd0VRYjlKaWdKcExhSEVKeitE?=
 =?utf-8?B?UWtBWnVTSkt6ZEFNbk9mOStCVitFRVVxY05ZSkk5Z2xQQ2h1M1hjakZzVXV3?=
 =?utf-8?B?RXNwdWlMai9MVDEyTDJzcDJJZTlhODFJTlhBa1g5UkZtYjNHM2tRVXByL2xM?=
 =?utf-8?B?cjdTQ093clN6Vm1qblVRMEd4eWhmM25jUTZyMHNWaGZRUnY5S0lKU0RWaU5G?=
 =?utf-8?B?TE9HUHVqSy9ydGRMRWQyc0lMaHpPci9kazJ5OVNTT0lZZUZhQmhVc1JLWHNz?=
 =?utf-8?B?UjhtSHZ4WW1FYy9xWTM1NWFNSUVJZ242cFYzRjErUiswRDExYmR3U25zcEVy?=
 =?utf-8?B?OHJHYTV4bCt4T21nRnlLeFMrTktINFBIVERlaW8wQVRWaGt1Zkk1ZWo2NUZW?=
 =?utf-8?B?V2RZN0I5bDdzUjJSbmxjNUM2bUlCVlBVUmF5NmJ4b2c2REh2NE1adE1rTmJV?=
 =?utf-8?B?KzY5dVhVTTM1cGVnRzB6WVhFVDI4Wmc1eXZseDlOTXJWZ2hEcmQwZmJzTHcz?=
 =?utf-8?B?RXB4SFJYeWdhRmZFbWpDMmFWeFZUUERlbk04Y3hqeW1KRUZBbW5zblBZck5n?=
 =?utf-8?B?MGdQcDB4WiswRWMwUC9uZXg1VzNYeTFQVnNvNzhtZDBzMWI0S3VIT0xBdW1R?=
 =?utf-8?B?dXR3aHFzaXNTbUhSTUd1ZEViTkpac21OaEs4SGVLbWYrdzhRaXBnMmwyRTZv?=
 =?utf-8?B?d3pFOUQ5MjRRbVMyckw4WWwxRE05Mk0rZFJvMXFiUGd1dzA0eGROOGdkYmpm?=
 =?utf-8?B?RE1TNnNBOEpoQlhqVzlnbDJuTWZ5cy9pSFMwUlRSQ0djNThOZWZoSmdDRlpl?=
 =?utf-8?B?UnVSMXJaZk5oSzJKM1BrazBrYks1dFBKbVFGU002Nlh3a3R4RHNnWFl4UXZ4?=
 =?utf-8?B?N25pVXpLUEZJRU9jSkw0Wnc2Tk5aMnJ2K2NNMFVVRjNicWd0NmUvUGNmejFm?=
 =?utf-8?B?bXpkOEpWQlpMOHpIS2YrMGJleng0aXV0VkRpeFZWRnRmQU1vY2NBUEE0a2Y0?=
 =?utf-8?B?WWNqbHBteXhhcTMwdTBFbUk4Y1IzRVU4WW1Ib1N6cE1XMjBOMTBmK0JKaFkx?=
 =?utf-8?B?enVnL1E3a1BzclcxQ3hwUVdxdU1vSWtTTkIva1FsZCthajFPZ3RPWmJQbjBl?=
 =?utf-8?B?WSs1bXV3WGJXdUtLSVZQTlFHTEFyNlhQN0hIU0UyZ2FwUVIyMnlZdzB1YVB2?=
 =?utf-8?Q?QzDR10?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bTRnV1YzUGFFVi9Db09aNEJlNFU2aFdzaXdSZFhLMWp3Q1k5RjZER09xZGZP?=
 =?utf-8?B?OTMyUWdTZWRkRzMwOE1EQ2tKcnExQktJUU9ndlVOaGRMTG5pRmpFczl4WnBr?=
 =?utf-8?B?V0dKd29xMm5BUTVvTEpqNTg0aFd2cm1iNk92YWRWZW5YM09JWDVXeTlBeVJo?=
 =?utf-8?B?eXdIN0RtN0hQYXE2aWwwSEV2Qis0SjFCOG1xOGpwdS9OUXlLU1RDbkExaFRa?=
 =?utf-8?B?dHArZjZhc21jLzdCT1U4dWVQWk5aWHVLQXNkbjEwc2szN2t0em55NXJSREpK?=
 =?utf-8?B?Sk9JVmgzd212TlRzRitLMU9tMHdINm5lcWlkU1d4M05SYUE0bkxUTXlQNnBK?=
 =?utf-8?B?QmZjMllXWWVGb1VqNU9FYlhxdjFLT29NZEZTUHRUa0NmUDgwU1dibmh6MEtF?=
 =?utf-8?B?cmtzdEJGbDVuY0J5TWtuUjNUem9FREtKN1JOSGJydEU2S1BoMm9LNmhuRXpB?=
 =?utf-8?B?Z3lmV2N4V0IyaEVRREJZdzhsNmRPM0NxZmxVS25KWk1EdWxYODVSQmdJd1hx?=
 =?utf-8?B?ejBSTUlFcjFvK1FiVE1WZWNXcXBUYzZBaWxWY0F5dmdSdEgwVmdrWWxQNUhD?=
 =?utf-8?B?T1VJNWxmVC9QeUM0MVNDS2d3eWFhZU5sMFU1VXQ1dHlYSzdKK0RHRFZUYklW?=
 =?utf-8?B?aEFHYlBtVFptR1QybWxFbFZjc0Y0R2QreXRmTHR2eE5KNkdoY1JXREFMUU9K?=
 =?utf-8?B?ck5OUHpEbVFvcDJvZC8xcUs1WXRnak1nYnMrcEp5aTJ5cnNWcUVyUGEzQzlV?=
 =?utf-8?B?NnBycUppY254NXpjcDMwRlQzV1Jhd0VmUFZ0Nmc5WjJRbGVIWmk4ZUxtazQy?=
 =?utf-8?B?Z2JSL0FScTN1UWMwbys2R2JiNzZ1U2hIVUNpM3JrbEdscUZXeWkyVmZ0emR5?=
 =?utf-8?B?NWlOMjA4cVkzdFUyQlRiUnV4ZVFHMk5HdXloSmk2SFRHeHprVis4ZFlMYldp?=
 =?utf-8?B?TTVkUGpEd1FrWlk1R1FjY085enJwcFNMc1RZN2JlUDhPN0dhdVlKdUIxNytS?=
 =?utf-8?B?dlRldVlwU0w5M0RtSzdDaGJ5YUJQaSswT3pEVXVPV2g3Qk1mRUpBdzFqWEts?=
 =?utf-8?B?Q282QSsweWVlVGQ0enV5ZFNLODIvYkxxNUlHeXZEcCtHSlYxNSthWFNaUm04?=
 =?utf-8?B?ZGowYmpjdkpRdlByZEl0OW50RWFqN3lHbGl1dlJxRlNyQTZONjk1UG9MRFJq?=
 =?utf-8?B?T3crOWRoMzZ6T3AvS3Z1ZWx1dmorMi9MQlNzQXZsUndWbFdJdGN0VzgzTVZJ?=
 =?utf-8?B?blYwZC9RNHk0WWxTZEtkYkdLVkwyeVE1N1lYcVViamVZbS9PQmhjSXpLT3ht?=
 =?utf-8?B?NENmVW11YW1RSDQ1TDZManNIWCtKVTlJSCtzN2hLc1VLMUFqRXB2ZnVCNnF1?=
 =?utf-8?B?RnNJbW5xMU1RK0VyT0FEY0hyV1haaWEvTkV1eVpNR1FzK0Z0RmpoNHZDclRz?=
 =?utf-8?B?YURaR0cxMkt1Y29CSm41dkx6WkxWeVNudDZSeHBzaTZxVElkZjdweWdISEkz?=
 =?utf-8?B?OUEwRGNQYVpxZmZPRmJBeWZ1QWhRQTJrNUpFa2pkSElpYm52MWYxL3JtQXAw?=
 =?utf-8?B?aHFkcHNaTVhiQnI2SU02SS81UFAyV3ZoL01DM0RVNm0ydHN5V3ppYndMNmhI?=
 =?utf-8?B?cjAvV2xPeHhTTGVoMVVPZHBFaU96bFl4SkwrRVErWjFGSmN6SkpOcktxdGdj?=
 =?utf-8?B?T2tlKzdBOE04L3JTdytsTy90c0VTZ1ROZ3cvY0grcnBJT3lMd09UR253RFVO?=
 =?utf-8?B?OU81MHlmaDJBRzd4MUlLeVBqVzZJUG1BTnZuN2Q5bWtVSS9ha2hhaG5zTUIy?=
 =?utf-8?B?ZjlhMG9Ga05ES0tnNDRPd0V5N20xTUo0ZUN1NXFpUC82UDBiUVRENWJtbm9a?=
 =?utf-8?B?MGt4c0FMeXgxeU1Ua29yMTgyenB0M3U4VFVaaVBVa0FLeENIbHluaE9vMW82?=
 =?utf-8?B?SmxZc3RDcUtVMWcrVFV6K2pMNUxra2M4WjgrWFhsWlhuNElVWGppWHdiUlow?=
 =?utf-8?B?QXlvc0hob2lCSjFnMXRCOUNRRE9BVGVsZGFkbWdWa3FzS3dIM3VqVWZOYktS?=
 =?utf-8?B?L21MbWtwT1Vjd0V2NkV0L2ViMzlWYzk4UFpuYlRMWGNZeUF4TnYzTmFYemZp?=
 =?utf-8?B?WWE1R0ZTMlpYYnF1NkphREdEenVyRHFIaWZudmhtaDA3YmZ0U05RZHFiZnFT?=
 =?utf-8?Q?H0i/TR9tb5cnpEenRDbB1os=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDE6DEE53EBAFA4E8325132AC5F61CDD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5bff09-19fc-4d31-1cf2-08de171cf3ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 18:57:05.1679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rcbx1Cp8gAvG79oPpI6DjejOpnVX37FwtjVKY8n7JbG5Op0XYcz1OfJgQoOUOAH1UG6mklULT6I2yt/447Fynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR15MB6150
X-Authority-Analysis: v=2.4 cv=ALkgKXG8 c=1 sm=1 tr=0 ts=69026387 cx=c_pps
 a=4Gx/Bq66bxzCWlClXrtOjA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8
 a=WSp1uS29RV6y0AwjGRkA:9 a=QEXdDO2ut3YA:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: uD7pu3c0XxWjuVG32ygIiPdDH8dFxPp2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX2f0uArDjXKF/
 0+jAy7JEKI/G7bmjnTILnVY/eLzAoXpIRG2zp1RnP+emGFD3v+UJS8Gubtudv4Xlx8D9NhlXQAD
 o4izOwoyxdvj7PnabUXqudfIbgdQ0AYN4gHt9oJfGVfOPMnHLUqHlsaL2Kmhtq1mSO1husBwIfd
 UWTNyQBG734RPZkLyx2vpyNfzgmNPJfZHhsGNLTg2o8NWvlzo9n0jFelUPh7dywJI3X77cmPgdl
 1yanOv//eGHFYrVF4wMl5ptujGxkGSXJDyHz2ZpW00pGxJr6gc5ddECFvsypeYhVZl1bDwv1WBf
 K/4YJMT7XbZsCNtIszef+EgMTaY2auLJSJd+pxn7vQZZ/GC2r4MkB+ssjOvlUXY+YlX/X6PM/YG
 6nQ4SRFjaX7AUs4+sr3Oj0KkpyI1MA==
X-Proofpoint-GUID: h7e4nmM_Sv5Cb_G7bG6hWqgjsSzA-kGw
Subject: Re:  [RFC PATCH 1/5] sched, fork: Wire BLOG contexts into task
 lifecycle
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166
X-Stat-Signature: ni56e35pjshb4ajzwxo99pjbrx9ifgpf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B74A51C000C
X-HE-Tag: 1761764242-151856
X-HE-Meta: U2FsdGVkX1/wsWeOX3aBaE5btriS2tMMZSNim7/fNQKPrn5MfMgxQChqerxNSZmqfN1DZWk4zvB0wtG6ulZtuDO+pHdjV44iPxUXECwTfcv4L1AqabXYmqRLkcfMXreJURLSZwQdO/LM0ECTmg5Jdxd1QdXRUDhgz5kzog2NMnoqtsiMffstOO8lXGsNBoQVCmYdcrG2uzFrNdDKfKTECZhFV5PVXvozYH3ITMvBiDujd1YGIGSuN/2ug8ChP5NLyUG5Hlw1vqWnSQKGyd3JuEIPNUFuwktj4wSDITca8ZUvYHoyw+NdWbRjwOAA8wR4Qz+Iezgq4DM1wPjT2DmdnK6fzg02yDj2pJz+4WuUBH7YWCjMPvBcs61UWuijApZKlI9WaDpnHvXXoAvgKA6ep5OeRcy87xE9sdXQ3XKcJpLiNkx+MnNBl2qY6IBBmvwqSss4yGuEhwCL7MUF2WYyU8Pd2HIWByvVodXlTjzWLgE4sXJZsmKe3OXnW89aKgfICn/i6qNsiUfhnvIhHsvNSKvXEUy1A02tAHcp8yPgVZ0K5m3CGiMtaLElF3O92stXWAjzI3BVcI22e8drZXO66E9pHaeZs2UhwxWK1rlfq17U9N4oIUMH2VlX1r/X2fICRXQJmVGnGPCUSA0p92JFpayYLSv4YCT+QFs07GmQuDc397m6xhuoV/i93Z2l0++w6vn0Ea63n1Tqc+6zojmD9UlPilg0rgsPHOUvUuCNgWF8J1AkyrZu8i7MDMpujDgLor0mjfveVnJOmellnU9x5E8j1WyCBT5bTloQXQnHQcNKOVvF2HPmAMG+G9kaU0XPA3V79udm0uBYShkrpDYIozRZGesy392JkYG95WUTfJC4aFGS88zKe2Yvll41zIaE5/rm5PwjlYzc/L0qrXQ7F2E3/0XPdbfAVC08nzhfPYhLXoffkcyb5zDtrYqrT8TettjcE4Fx7rEu22vrwHp
 vuyJN4S5
 DUOFCU1Q9+9/wIwzYSr1lV3YSExZhCZ+en/c+k3IGgY93xqObab8BxOaF5qZvDTmd1qQJvfAbwAMj0ZEgUhg4pf8FGf52eW35GrFJHKvvOUmPdn6eRQcZW9Qe7cOYId2g4+HIjSXaACPpbfzOFL7dbRkcBV+kn6K7eB271KxNBygye1mWaAIzVmQFzjKx9VoY8Fu81fWInVS8KERYuBp3rTEuaMS0yMqmXtpCanA3z+dRKspH9xdN7BrP+RwFx2vfRVhZOsuGx2Lsgp9SYG/eNzjEI7ULmWkTPL6Xnp8K+9S8iQFqj49uxfIRt5AoHVNlUqDO/YDga8+RFmXa1DXw2nL+W1RQm6+Co2l9+/ZySn+sqewv8Y5Y24UGoRFEF0I/T/Z1Fh7+RA1uWtsaobWT4VUQe6V0+q0kh/ODVvWYB6oFuGvw6qT4xkUy3gm1slR4P6mS1sgt3RLF461BhFXBdMnwhot0XNv7tIlXsaZYfDhvbRS5qNv6QrlFTEUPbLho+u6sy3S35WYwHQJw307bl9S14gnc9mQ2e+3+HfEv8Ryade9YS8UNfCByR95slq9C3gsgFVSLouyBRvUyDv6ym/V45fFHGM4mYz4fMZAO/7pQxAeD+nhg3/IjTqmvpsBJ6AXG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gRnJpLCAyMDI1LTEwLTI0IGF0IDA4OjQyICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IEV4dGVuZCBzdHJ1Y3QgdGFza19zdHJ1Y3Qgd2l0aCBhIGJsb2dfY29udGV4dHMgYXJyYXkgdG8g
aG9sZCBwZXItbW9kdWxlDQo+IEJMT0cgVExTIHBvaW50ZXJzLiBFYWNoIHRhc2sgbWF5IGhhdmUg
dXAgdG8gQkxPR19NQVhfTU9EVUxFUyAoY3VycmVudGx5IDgpDQo+IGRpc3RpbmN0IGxvZ2dpbmcg
Y29udGV4dHMsIGFsbG93aW5nIG11bHRpcGxlIHN1YnN5c3RlbXMgdG8gYXR0YWNoIGJpbmFyeQ0K
PiBsb2dnZXJzIHdpdGhvdXQgaW50ZXJmZXJlbmNlLg0KPiANCj4gVGhlIGZvcmsgcGF0aCAoY29w
eV9wcm9jZXNzKSBpbml0aWFsaXplcyBibG9nX2NvbnRleHRzIHRvIE5VTEwgZm9yIG5ldw0KPiB0
YXNrcywgZW5zdXJpbmcgY2xlYW4gaW5pdGlhbCBzdGF0ZS4gVGhlIGV4aXQgcGF0aCAoZG9fZXhp
dCkgY2FsbHMNCj4gYmxvZ190bHNfY2xlYXJfdGFzaygpIHRvIHJlbGVhc2UgYW55IGFjdGl2ZSBj
b250ZXh0cyBiZWZvcmUgdGFzayB0ZWFyZG93biwNCj4gZW5zdXJpbmcgY29udGV4dHMgYXJlIHBy
b3Blcmx5IHJlY3ljbGVkIHRvIHRoZSBtYWdhemluZSBwb29sIGFuZCBwcmV2ZW50aW5nDQo+IHVz
ZS1hZnRlci1mcmVlIHNjZW5hcmlvcy4NCj4gDQo+IFRoZXNlIGNoYW5nZXMgYXJlIGNvbmRpdGlv
bmFsIG9uIENPTkZJR19CTE9HLiBLZXJuZWxzIGJ1aWx0IHdpdGhvdXQgQkxPRw0KPiBzdXBwb3J0
IGluY3VyIG5vIHN0b3JhZ2Ugb3IgcnVudGltZSBvdmVyaGVhZCBpbiB0YXNrX3N0cnVjdC4NCj4g
DQo+IFRoaXMgY29tbWl0IGVzdGFibGlzaGVzIHRoZSBmb3VuZGF0aW9uIGZvciBwZXItdGFzayBi
aW5hcnkgbG9nZ2luZyBjb250ZXh0cw0KPiBidXQgZG9lcyBub3QgYWN0aXZhdGUgYW55IGxvZ2dp
bmcgZnVuY3Rpb25hbGl0eS4gVGhlIEJMT0cgc3Vic3lzdGVtIGl0c2VsZg0KPiBpcyBpbnRyb2R1
Y2VkIGluIHN1YnNlcXVlbnQgY29tbWl0cy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggTWFy
a3V6ZSA8YW1hcmt1emVAcmVkaGF0LmNvbT4NCj4gLS0tDQo+ICBpbmNsdWRlL2xpbnV4L3NjaGVk
LmggfCAgNyArKysrKysrDQo+ICBrZXJuZWwvZm9yay5jICAgICAgICAgfCAzNyArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDQ0IGluc2Vy
dGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NjaGVkLmggYi9pbmNs
dWRlL2xpbnV4L3NjaGVkLmgNCj4gaW5kZXggMDc1NzY0NzljMGVkLi5lMzgxZjg0MjFhMTEgMTAw
NjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvc2NoZWQuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4
L3NjaGVkLmgNCj4gQEAgLTEyNzgsNiArMTI3OCwxMyBAQCBzdHJ1Y3QgdGFza19zdHJ1Y3Qgew0K
PiAgCS8qIEpvdXJuYWxsaW5nIGZpbGVzeXN0ZW0gaW5mbzogKi8NCj4gIAl2b2lkCQkJCSpqb3Vy
bmFsX2luZm87DQo+ICANCj4gKy8qIEJMT0cgc3VwcG9ydCAtIG1heCBtb2R1bGVzIGRlZmluZWQg
aGVyZSBmb3IgdXNlIGJ5IG90aGVyIGhlYWRlcnMgKi8NCj4gKyNkZWZpbmUgQkxPR19NQVhfTU9E
VUxFUyA4DQo+ICsNCj4gKyNpZmRlZiBDT05GSUdfQkxPRw0KPiArCXN0cnVjdCBibG9nX3Rsc19j
dHgJCSpibG9nX2NvbnRleHRzW0JMT0dfTUFYX01PRFVMRVNdOw0KPiArI2VuZGlmDQo+ICsNCj4g
IAkvKiBTdGFja2VkIGJsb2NrIGRldmljZSBpbmZvOiAqLw0KPiAgCXN0cnVjdCBiaW9fbGlzdAkJ
CSpiaW9fbGlzdDsNCj4gIA0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2ZvcmsuYyBiL2tlcm5lbC9m
b3JrLmMNCj4gaW5kZXggM2RhMGYwODYxNWE5Li5iMDY4NDNhZjA1YTkgMTAwNjQ0DQo+IC0tLSBh
L2tlcm5lbC9mb3JrLmMNCj4gKysrIGIva2VybmVsL2ZvcmsuYw0KPiBAQCAtMjQsNiArMjQsOSBA
QA0KPiAgI2luY2x1ZGUgPGxpbnV4L3NjaGVkL2NwdXRpbWUuaD4NCj4gICNpbmNsdWRlIDxsaW51
eC9zY2hlZC9leHQuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9zZXFfZmlsZS5oPg0KPiArI2lmZGVm
IENPTkZJR19CTE9HDQo+ICsjaW5jbHVkZSA8bGludXgvYmxvZy9ibG9nLmg+DQo+ICsjZW5kaWYN
Cj4gICNpbmNsdWRlIDxsaW51eC9ydG11dGV4Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvaW5pdC5o
Pg0KPiAgI2luY2x1ZGUgPGxpbnV4L3VuaXN0ZC5oPg0KPiBAQCAtMTg2LDYgKzE4OSwyOSBAQCBz
dGF0aWMgaW5saW5lIHN0cnVjdCB0YXNrX3N0cnVjdCAqYWxsb2NfdGFza19zdHJ1Y3Rfbm9kZShp
bnQgbm9kZSkNCj4gIA0KPiAgc3RhdGljIGlubGluZSB2b2lkIGZyZWVfdGFza19zdHJ1Y3Qoc3Ry
dWN0IHRhc2tfc3RydWN0ICp0c2spDQo+ICB7DQo+ICsjaWZkZWYgQ09ORklHX0JMT0cNCj4gKwkv
KiBDbGVhbiB1cCBhbnkgQkxPRyBjb250ZXh0cyAqLw0KPiArCXsNCj4gKwkJc3RydWN0IGJsb2df
dGxzX2N0eCAqY29udGV4dHNbQkxPR19NQVhfTU9EVUxFU107DQo+ICsJCWludCBpOw0KPiArDQo+
ICsJCS8qIFN0ZXAgMTogQXRvbWljYWxseSBkZXRhY2ggYWxsIGNvbnRleHRzIHdoaWxlIGhvbGRp
bmcgbG9jayAqLw0KPiArCQl0YXNrX2xvY2sodHNrKTsNCj4gKwkJZm9yIChpID0gMDsgaSA8IEJM
T0dfTUFYX01PRFVMRVM7IGkrKykgew0KPiArCQkJY29udGV4dHNbaV0gPSB0c2stPmJsb2dfY29u
dGV4dHNbaV07DQo+ICsJCQl0c2stPmJsb2dfY29udGV4dHNbaV0gPSBOVUxMOw0KPiArCQl9DQo+
ICsJCXRhc2tfdW5sb2NrKHRzayk7DQo+ICsNCj4gKwkJLyogU3RlcCAyOiBSZWxlYXNlIGNvbnRl
eHRzIG91dHNpZGUgdGhlIGxvY2sgKi8NCj4gKwkJZm9yIChpID0gMDsgaSA8IEJMT0dfTUFYX01P
RFVMRVM7IGkrKykgew0KPiArCQkJc3RydWN0IGJsb2dfdGxzX2N0eCAqY3R4ID0gY29udGV4dHNb
aV07DQo+ICsNCj4gKwkJCWlmIChjdHggJiYgY3R4LT5yZWxlYXNlKQ0KPiArCQkJCWN0eC0+cmVs
ZWFzZShjdHgpOw0KPiArCQl9DQo+ICsJfQ0KPiArI2VuZGlmDQoNCkl0IGxvb2tzIGxpa2UgYSBm
dW5jdGlvbiB0aGF0IGNhbiBoaWRlIHRoaXMgQ09ORklHX0JMT0cgZGVjbGFyYXRpb25zLiBXaGF0
J3MNCmFib3V0IHRvIGludHJvZHVjZSB0aGUgZnVuY3Rpb24gZm9yIHRoaXMgbG9naWM/DQoNCiNp
ZmRlZiBDT05GSUdfQkxPRw0Kc3RhdGljIGlubGluZSB2b2lkIGZyZWVfYmxvZ19jb250ZXh0KCkN
CnsNCiAgIDxsb2dpYyBpcyBoZXJlPg0KfQ0KI2Vsc2UNCnN0YXRpYyBpbmxpbmUgdm9pZCBmcmVl
X2Jsb2dfY29udGV4dCgpIHt9DQojZW5kaWYNCg0KDQo+ICAJa21lbV9jYWNoZV9mcmVlKHRhc2tf
c3RydWN0X2NhY2hlcCwgdHNrKTsNCj4gIH0NCj4gIA0KPiBAQCAtMjAxMiw2ICsyMDM4LDE3IEBA
IF9fbGF0ZW50X2VudHJvcHkgc3RydWN0IHRhc2tfc3RydWN0ICpjb3B5X3Byb2Nlc3MoDQo+ICAJ
cCA9IGR1cF90YXNrX3N0cnVjdChjdXJyZW50LCBub2RlKTsNCj4gIAlpZiAoIXApDQo+ICAJCWdv
dG8gZm9ya19vdXQ7DQo+ICsNCj4gKyNpZmRlZiBDT05GSUdfQkxPRw0KPiArCS8qIEluaXRpYWxp
emUgQkxPRyBjb250ZXh0cyAqLw0KPiArCXsNCj4gKwkJaW50IGk7DQo+ICsNCj4gKwkJZm9yIChp
ID0gMDsgaSA8IEJMT0dfTUFYX01PRFVMRVM7IGkrKykNCj4gKwkJCXAtPmJsb2dfY29udGV4dHNb
aV0gPSBOVUxMOw0KPiArCX0NCj4gKyNlbmRpZg0KPiArDQoNClRoZSBzYW1lIGhlcmUuIFdoYXQn
cyBhYm91dCB0byBpbnRyb2R1Y2UgdGhlIGZ1bmN0aW9uIGZvciB0aGlzIGxvZ2ljPw0KDQpCeSB0
aGUgd2F5LCBjb3VsZCBtZW1zZXQoKSBiZSB1c2VkIGhlcmUgaW5zdGVhZCBvZiBsb29wPw0KDQpU
aGFua3MsDQpTbGF2YS4NCg0KPiAgCXAtPmZsYWdzICY9IH5QRl9LVEhSRUFEOw0KPiAgCWlmIChh
cmdzLT5rdGhyZWFkKQ0KPiAgCQlwLT5mbGFncyB8PSBQRl9LVEhSRUFEOw0K

