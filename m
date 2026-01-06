Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD5CCE9D40
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB60A6B008A; Tue,  6 Jan 2026 09:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D316B0093; Tue,  6 Jan 2026 09:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9307A6B0095; Tue,  6 Jan 2026 09:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3206B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:43:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 487EB54F10
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:43:46 +0000 (UTC)
X-FDA: 84301808052.08.3AAD519
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9F73160002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:43:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nvbe3gGW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=otiFIfeA;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767710623; a=rsa-sha256;
	cv=pass;
	b=3kIbshO7er53AHZQPlIpsTy4R6aAjfHo7MpWivFF8rCZzanfLCBYmmONTsRIwUxWj7Tl2/
	wWhTk4kZ8MjBwZzqGg+jzpACAXUwYRCrilduqlhKZpSvxim4hnUgxRCXJn3IfN6SAKkg7r
	JHKRwgD6FTcxWITfLObCvlv2TBsvZCc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nvbe3gGW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=otiFIfeA;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767710623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/J2V6x5vMAtIVj/as34amZGWl3bVbX6BMNot247Q1fw=;
	b=8lDq2yxJtZv3I5x/eC8SuwBtuC/GCtJiKPv+5C/GrWp7K/cSnS+YdTlsBk0uS3PESWA3Fy
	MIKBRqdX4Ki+lH4bRZQq0qjv/Rp23qgxu6lrvnY9bJv141aLufhQpbNyLJE6956Rd76XoY
	+0NYPn84I2qCRkeJeNnGXCOlNBJXKmc=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606EKXec3952260;
	Tue, 6 Jan 2026 14:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/J2V6x5vMAtIVj/as34amZGWl3bVbX6BMNot247Q1fw=; b=
	Nvbe3gGWBRlNbrBZfx6Xkx3L2HvngG2YWkpJGC/qLy8YJ/8qG83VlNeDwhHiePTp
	oX/ZA14GRcXH4yEgfJ4txE26HSTVwWY+QnDrxa7L6z62wBEvKO/tOmcvVMtnqwjZ
	Vfzd/D7umF8dCvb/HsDcc5sMM+czj5RF2kEL6fC4VxWgLpt/NbHAyjaxzfJpk+u6
	Dm6W+XZ89It5RHxl1odpeCaFWOkyRmC+G/7xQWj91MMtMXNaztlX+E+LAuQe8Sj6
	kNBhOcsuWof2RyTIn9sAOPBYEc2tObJ1+rikVwHPgLcthBCqxFC3C27hne+MLipg
	9yIO5MonIHXo5d0x8gYLHw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh42ur1as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:43:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606DQ0C8020480;
	Tue, 6 Jan 2026 14:43:32 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010018.outbound.protection.outlook.com [52.101.201.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjp655-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:43:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OjfVavD91A3/LvVbd4WEeYDPmZPSM1/ap3JaPBTWc0bCfffJqS3AFHCSBqjOYnuouwK3BJHw1y1sjyENKuIDKVeQ8bp68X6l2MPmuxu6eUCxK3xOr/8EmV8Eqw20+W7P4kHUugYXpGujQsqNOn3HWRXqSPHJrCKSDY40RcfJL3asumhaKySVCoxN+81gZhDOXksbuEQYJOpzGLkSWSXKO7E4qgdT/UmjBODckbL1JE7pHcTfALhHDVzGfk7PHPuiJvm1obiEcxLSs3+90aA+4aaOJ1IsUWFNFBk5G/3mCOh/a9rsh0qkT9yGYbefl+zYAmJJ0qGmx70GnooQgAg35g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/J2V6x5vMAtIVj/as34amZGWl3bVbX6BMNot247Q1fw=;
 b=gfszL3z4ejxVxJIeikavLKT7NNQ2LE8XFCTPwg/c9np2CWdGHhRWGzNzYd2MxnSMFlGQf4u6lOD2JX5YEjGFiv8Uqy+vWZ60kBkCcLivomAlrEj7HSA8iuz8LMGYGvM/4Kv09fBtE/wAOBftPLb0wI9NhCyTSXvNWVxlhQ+q40lcte4M4HiAihZRl3g4gCzJogPzCmi+exO/K2ssdsgBQmKilqrbwaIVDk0t0BDrnhz8rlMfaTSfICJErcjRAOCWIHEsGa80d3h5eRcheolTLcn9ZGFA6XtF7DkOZSC54VSSDAXW3k79ZbYq/WUg3gt7oYyuFgbSB1hhjBFWhWcDdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J2V6x5vMAtIVj/as34amZGWl3bVbX6BMNot247Q1fw=;
 b=otiFIfeA+acV23/Vcv/IlQ1P9B3Q5Y2hwWJBMYluRgoiR/jNAuRv9VRg6znSZHiIsEUSG0J4q9g4dwpnA3rtHVCGcT8WqOWOLJCpAuy8MyzP9UJsZrro4r9o+0+mOVVsv+SQMLtp3s+6tOa/j/i2nc6mai3kQOCZPCezewuLpig=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6333.namprd10.prod.outlook.com (2603:10b6:510:1b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 14:43:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 14:43:20 +0000
Date: Tue, 6 Jan 2026 14:43:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] mm/rmap: separate out fork-only logic on
 anon_vma_clone()
Message-ID: <21daf689-89c5-43a6-b83b-2dc405a2fb57@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <175d29b48f7e49ce9a1b19e3a6c72cc80c0c5bb4.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpG=D_MbZyauk2WJZ4evvoUQ0XEXwhwYpqS8rXqCGfVEng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG=D_MbZyauk2WJZ4evvoUQ0XEXwhwYpqS8rXqCGfVEng@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0373.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6333:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d1242d2-945c-4ab9-84c5-08de4d31ef71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXlzWVIvTTg0bElRYUhWZ2hEYlUwYmVpcG1TcFRZVFBmSDZxek40NFEzNHFM?=
 =?utf-8?B?VG1EY1A0bXJkNkl6cmFoRHAvQTQ1S2VxQWRGSHdlYjdnZHhXTU5yc0JvZVVt?=
 =?utf-8?B?QVhLY2lRY01LVEZ5dXdPQU1YVUJYMGNDdnhwQWRzS0ZyemhscHFHYVQyOENa?=
 =?utf-8?B?V1lYdGlXZFAwMTVxTHQweHUxZkRiZDhpT1A2SGVjMEg2WVBqdjMzZFFrNkZP?=
 =?utf-8?B?TDFJdzdyRDA2U2xPMk8vK1lNT1VDZ1prWUF2Y3IvSTBxVFllK0xKMUN0M2Fn?=
 =?utf-8?B?L1dmUmFNTUU2UG1OeEd2NEZHN3c2RTNpTUlPeVAyajREeHlHaWZITTAzYVpT?=
 =?utf-8?B?TzdTaVJ1WE1TWVdOdEtpR20xWlo0Zkhua0xRTCt0MmxzNnFhc1dZTTRkeGhp?=
 =?utf-8?B?dTJHWjB5aTJGcUZETkt0cHlscWcvbEc1SERVanB0cllKVVlvWjhNMXBzcUFl?=
 =?utf-8?B?YWU3a0cyWE8wY01ycGhqL3FWb2ZVQjRqMUpKWG80MUxXZU1TbncxL0tJNEN4?=
 =?utf-8?B?eVpwS0xFUk81cEljdCtPc3hFcW9lMFlCbE1od3dPWC8yOTZML2JBalpOVGM0?=
 =?utf-8?B?MXhuZFpRZ3p1QVZ1Tk9WRXNEbFl4citRVnZoQnAwN1BqbXowUUpzK2RjWDUy?=
 =?utf-8?B?S1ZCMi94MVE2OFh6Vk5GYUlwcFpzTTdSOUZqQWZDVlZnQzUxOVpUTUlCR0JE?=
 =?utf-8?B?VElYSytLK29KVis0NTJDV2VlQzNSRXZzYVpyT0NDMkYrWVVOazF5YTdlNXNO?=
 =?utf-8?B?RTYxQVJrNTRibWQ5NFFhZ2JvbzdMNDdtamVhUHU3MzJhN3Vyc2NuaDZtTk1Y?=
 =?utf-8?B?dUIyM3VKOXpBR2RtMmlJMVpHMW9CaDhhaERqVkZKbHdVTFN0UGc0VzhkWVJG?=
 =?utf-8?B?RXhWYW9XQ0JRSUJwd0dwaWhFczR6dStEMVVkaTczRVErTlI5Y2JyN1ZPbHdC?=
 =?utf-8?B?VG9JZzVwUnB4NnFRbllWZEtnR2JLMVpCbkFWVGtEVnRrWlN3R1JkUDA5UGxT?=
 =?utf-8?B?VUdkUWhHQjhRdi92amFEUEFnWFVmaUxNNFRadXorZlVnb043RS9KemNESFpS?=
 =?utf-8?B?MVJXRVo0SW5INVlaWVFzNTZURDRxWGtpV3lIdk1OalNUWUNMSXZaWWV5eklF?=
 =?utf-8?B?TFZjZlZUOUtkUWdaSjZWUGtndkV0MWhlREJHdUE3OWxlOFNEcGFiWFpnQitK?=
 =?utf-8?B?UHpIRm9qVG5zcVZza3R4UitUTURoblhIV25JZ2hJMHZKWHBVZldxejc5SWR0?=
 =?utf-8?B?T2o1RWR1a3BSZTdwazFIRlhVd2tLYmdNdGp6emcyYWRYeUo1d0E3RTFsM3dP?=
 =?utf-8?B?cGM4eUNqaWJDaU9mZGVudTZkSUJiSytNYnExKzUyNEpVRkdhd2dySlZhNVJt?=
 =?utf-8?B?bDdLYmF3cEFSSDJBSW1JT1ZXTU1adDFIVDJadTc4UHB4RG1aMDVvOURZRGpD?=
 =?utf-8?B?Z3R3QTFtVDRNVTNPT3dxMlpzVzRqU2ZpRW90dk0xYUxkUTZCUFhCUm9ZVjlC?=
 =?utf-8?B?clIra3FlTFR2c3krODIvbWtXK3F0RkNxdnNTMkhGZHJxS1dJNFhqQXJWLzNQ?=
 =?utf-8?B?cFdJT1R5Rkk1MEYvUUhNTkNvd0h5MjdWZ2I5cXZiWkZlVll2OXloL3kzb1Nx?=
 =?utf-8?B?SW42TlNxb25NSTZIelpxaUUvdytHQnMyZS9ZKzF0QXZhZnJCbVpyK3pRTzMy?=
 =?utf-8?B?aVJwcUdEcEFxNXp2NjVoaWplMEZ1b3VaaWRYekRKT3V3SEpUMWFlWXFjZk9I?=
 =?utf-8?B?Vi9lc0lnSzZBWHFwSS9hbjQ2TGhxWmhzK3owQ291U1hZYlBFcVV0VGtNZGJG?=
 =?utf-8?B?UkkvWXMzSXA0MHl0YXpZOTMxdmc3WmNvdnB0RDl5SitpTWQzOUJNQm1uaVQ4?=
 =?utf-8?B?VFZibDI2dFpCUXQ0cDYzcW83eStHRk5TVFc1eGR4M296N2hLQ2V6SmU3UTBV?=
 =?utf-8?Q?NrEqIn0IDGDS0vM4DVgT/k5wy661Am1Z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3NXTm9Yb2diUkF3TjFxNzFLWlJ3NlFJNEpkbmN1dUkrQ0g4YXdnUmVkQzFX?=
 =?utf-8?B?REd6aGgvUXZRcGV4ZllDMFM3V1FNS3d0QTFEc0Y3RFpUZFArNWxwMk1TQWJG?=
 =?utf-8?B?UVZoYmx5cXN5cVNKcElnZEVsYTZMajVMaG1wM3hsRkVLVmJiL1Q0YXJ6Tjhh?=
 =?utf-8?B?a1V6aDY0dTk1Q0FlVitVUklDME1pM09Da0FWVGwvKzZmc2hOTTZDbDhRMGtZ?=
 =?utf-8?B?R0haaVJnK0F1QXNHaUFXYTJ4bDBLYUhNT0NvR2J1RWZ2ZjArcWg4MHkxTmJw?=
 =?utf-8?B?RGxlTGppQnRDMzBJY29LTnZlZFhmSnJaNjc2N1JWczMzNHFVTlBPUVBwbUlL?=
 =?utf-8?B?QlUyYWUxT1ZCMy9FWXhJUkVjcXlhNC9yNk5ZMjRESyt3M3dKaXl0bitJbWhk?=
 =?utf-8?B?NnNOSjVodEtEVFlpN203V0s5Q0o3YzlVVDNLblpTVkphanVuTGF1MndWa0c0?=
 =?utf-8?B?b3NTUk1paTdmKzlZRlNFYjVLZmU4VVYyNWVST2VXQjV3SmJNTUVaeWZ5NUpl?=
 =?utf-8?B?bFF1K0xmajVoOXpjdG50ZCttU1d1ZDVQNk93b25pN0FxcjhOREplWmp1QTBu?=
 =?utf-8?B?YjV4MGw2RVQzaEpwQVNJUDIxRzN6Y2NCNnkxeGNWb09laFNHZzBmYnNxT1ZS?=
 =?utf-8?B?M29Fczk3MlU1QlY1cHZuZW9TTERseVVMK3ByYkZudHIwVGpXTlpsSGJucGp0?=
 =?utf-8?B?UEg5Q3l2cEI0cTQ3d3diK1NxZWdnYTVvd0RMUSs0TkJYWmd3UExVMEY3MlZ1?=
 =?utf-8?B?Vi9nL0hMRWpIMXFmb0s0VW0rb3FxZGZUQUZUbEZYeEdWU1ZIN1kyTzc4Mnpo?=
 =?utf-8?B?WDBCVWtzSW9iblI5Q3ZubEEyQXlqTmJ1NmozYlQ2MWVWa1ZTVGVDYVppY2ZO?=
 =?utf-8?B?SjlyUEljUG5ZTjZpNUZ3VE1CQjY1SjNmRE9nYjFsKy96VlpkL3hnbnZES0Nl?=
 =?utf-8?B?WlB4cWJHMTJ4V2ZwTyt0aHBEUE1GRk5LV1dDUEcrT0NqK3ZvOWdkTnZYTTRv?=
 =?utf-8?B?bXBBNnJNNjVINkt4cVhKMEhFTzZPeDFkYUsxWCtvOTVheU1mL2FjektJYzU0?=
 =?utf-8?B?bkc2RFVzZ2RxTDgyN1F0em9KSVlOL1I1cTM5WVRvaG5YajN3WHVJZk5pSjRa?=
 =?utf-8?B?RElMNVExcTUwcEp4TE9OUXVodkhaeXJRNmhCVlV0L3VwZ3BUTTFwM1pYb2lq?=
 =?utf-8?B?MkVNSHYrM2JoeVUvaWM4YnJ0MkFiZDF2WjIvYU4zMy85WjNSNTVHWXRBcnVE?=
 =?utf-8?B?Tmt6NTFYazhXWC9TWEUzaXY4NW1PY0JzT1BPOGZERlVKMDNmNzFSS00wVHpp?=
 =?utf-8?B?WWl2ZTJmZWFpdDhaK2J2ZlpKNCtmYUtHa0doSjN6bnR3YVQxZklYWk1jbW1H?=
 =?utf-8?B?T1Zvc3pCSlNCdGJ0Ym5laVhBa2lvOVNtVzVVczNudjAvNFRCbEc1STFwQzJR?=
 =?utf-8?B?a1gzdXBzTSt2SENkN2xBRE9GN2wrdXZKZ3pOWjFXd0RlcnMrMmppV1NKaHFQ?=
 =?utf-8?B?U3R6SnVndEo5NHdqUmRyek5rdnFCczVMTXpSSmh2VDFsQUM2ejFNUC82cGFp?=
 =?utf-8?B?UGJpNUpRQXMrbThvaElNcFl4TjBqdHI4SnVtL0JCNFMxNTFybkxtMFdvWjhh?=
 =?utf-8?B?YVVQdWdWZk1NdHl4b1VDSUpzeXVRRUNjenZTZzl4eGNmRHJSTHpreEUzRFFS?=
 =?utf-8?B?cE5oMEJnUWJsUFRrR2VRNm5QRG5QUUQyVEZsUE9DeTUydkVSSUtRTVNKdG5u?=
 =?utf-8?B?K3ppSHEweWVxbHp3TFdyRWJJcUhXd3dmUGNUaHArOWp6Q1RuOXhYdjF5SnV6?=
 =?utf-8?B?bUtRczlBbEQ1YmFYaElaSlNBS2h1emtTb2Z0NGhEK2ZNNXVpc3ZmeklpNWc1?=
 =?utf-8?B?ajFkU3lCUWVtQWhtWVpjaEFOS2xsVDg5ZzJ1SUFZeXFOTksvd282QVlPK3lq?=
 =?utf-8?B?UXlCVlU2MkNXazgzblpqcHVWbjFzRlI3cURRS1J3Zk1nQ0xWZDBsNTdwdVNT?=
 =?utf-8?B?WmdTT0VQQ3hKSE41dkhBTEFocGVzMlRtNDdwM2Z0RmI2UHRLUEJRNjZnR2Fr?=
 =?utf-8?B?VTQzSWxtK2R3eWM3ZElYTTVFVUxwTjFzUlEycitqSXg2K2dHejZjUk4yclpN?=
 =?utf-8?B?b2ExV2E5OU8va0swL3ZFSW43NG1Qc0FoeTdXQW44YW9BN1dESDJoUVNGdVlo?=
 =?utf-8?B?a2hKWDltSHREWHpDUXhnc2xxaVEveHZOT2lENlJ3RVlJNStGVG5iaVNTOWt2?=
 =?utf-8?B?YXgyY28zeTEyZVYwRW1PMEJmWGRldmZIR0t0WVFPMWMyQUU3OVdDMGtrdHds?=
 =?utf-8?B?dXZESEpxSWg3SlRlMWZXd3ZRbFZLVXp6QTZobzBHZlNXejJEYXVTWlN1V0Jl?=
 =?utf-8?Q?khg9JJp6s5g0YhoE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zs8nnwpCCv4bGXUAv1tin4L7cIFFD2aiqYlSorVlpD4eCUMH+kVrM+5XOxNL4uEiYO2Bn4xWGcoWE7NAjK1C7BoFmvEp2mHjSvvN0O6OIsm2msqrXpHiinLkOOCd+pWmt+C/JrQ7/TxjJJn1Ahi36tYaPRtlMLdTlKs29piz+sgTAeRE03MR9a2K8QkrrsxNwVYX34qTWns7RXPJe0ku3ggrTnF1gxoqZn+PEtcr/pcz5HuSS416pLOhRxg1GB1Mz+VA3KBdTyzj3qNwst0nI6+lAB6q8zC8QxaDbf9h+LXXqvMx6Th9DhUnsdNbDiW+otCMyi3b5TAP2cMFySuzsKgAZ7zQX/XwBVSZOwIxbgTnsaEE3LnydpDSfRDZk2YXEzhWdRQccGWKjy092jkM/0XVAQ7gqYtLLu0AouYempuRvo8TZ9+R174RFZ4YdASiin7ztmxV+95HL7hVbLXmLx2t9KLTlaPvXG7yb1P6UtR5PXzqTS4sxlHDv9zbR5sRGN28YjZdqDSNZkv02JoEdn+s1Lf+ylbDDb3jyBvFy1w5tDvHzuPfw2idoEAsYb8BwYCpzULhCmfmXDGtqUvsDZ6Vi0h3hRTroc61vz5ogOw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1242d2-945c-4ab9-84c5-08de4d31ef71
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 14:43:20.4196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMLALyTiLaNatXC42JcJKpk+gAW/HJ0TS2bVYuunZ8f8Jq664E08RaHLP8jB+TRQLKZVdOx7rybQw/4KdU9Q2rodfLzRczGfMUzgE0hPps0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6333
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060128
X-Proofpoint-ORIG-GUID: erwwvRKYxGW_pc63SUNYi3npMuxmJ1Fl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyOCBTYWx0ZWRfXyJYgm/WUnEJJ
 GxNRJkgqrI1spofB8oCLucpxPVfE9JRZhrLJTPU2QAo9Ha+Y9Vv5Qz7DNDQothN1hXgvYeXj3vG
 cR70FrhtPokYk0kXqmUqAtrMUVrR0BOBydxO72pgH+j/tGBq5ymSaxVqQecsi0MIUStyi2ntcaI
 d+Gtbb5pFVCtOEfPaek0DNjRRunz1Y2rzJ4bL3Lp/ARvEWsds7wcowJLQ8ES9rigE0EuqVepwxm
 2rm9hQVWa9pSQL8C0mv2tHTiTn8aBpNtxE2lPaQ80ydH+ybtAotCOb3i8HXVjY5ifECcqtZ9LlE
 b4D25vQGy/415W+bz5hEwF/kWGMv1fe49uDDjuVo6j8T+L52nuZ2PNwhm2y8jxv58t872JII1QU
 zI35hKtZkIINUGYI4/2Yic0udtr7xmSli2wBW03WE29RXD64yCym4LRLxVsGdoLffjTFsxibd/V
 g77mBw5n8YLvSkfKdrD/o9wp9OP94B0439W0FUmM=
X-Proofpoint-GUID: erwwvRKYxGW_pc63SUNYi3npMuxmJ1Fl
X-Authority-Analysis: v=2.4 cv=HdsZjyE8 c=1 sm=1 tr=0 ts=695d1f96 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=5Pv4FBV7lQh8LuRdVzoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12109
X-Rspam-User: 
X-Rspamd-Queue-Id: B9F73160002
X-Rspamd-Server: rspam04
X-Stat-Signature: 5eygg7ockaxtgqjrzm47f7hjbu7u6dgq
X-HE-Tag: 1767710622-462657
X-HE-Meta: U2FsdGVkX1+90VSZfn6611EAzD81qCMmWaIOoEO6gO6AigyyTKmshz/3GAzqUTmT/71kybkPqAixOMV476jzBjHwpuUXHcuhZe9djkWgrEPpgyLlrZc28W3CHFKFLbwhMD4xgLKHqWYVOHg4wpeITX2kXAxcY6gMJT4fUkhzpvYD6m3VPY9AXq/ac3AJlnl5IazWbfksTTcYSC9Ak/k6qFSbMal50h13S2MeRfFJRDz6cnlVaXmaijvu1a1b8MJlqYn29btleg9fHUPJHRRDLzwQNXM+RuHTtNH23fgRd63D6CWGfF1zWZ9kvU4wrIDPRDm0pJWCr7XaHTJgtG89K7cjjQk8DbJ7kBaRR5n+YN2kPewRqg0STZeOJAma//GaXKHN1UIAzAh8teQfB7QgaHM8Uc8MCwNd4Fg/sVL28NfWoZmZ/zkxpEhVMJZru3rW1Dn7Fi1HvARCqIWNnEABeGChEzN1zsWdExP7Bymu66GLqKtZKqTTdbhGydpGZYJ4GOWthyEsNFoahfpIKnDhIpYDI9RUkvj0P+jPoSa+1uRLRAfCMOGg9tFydzOAFONll8PNO5HHRcFYDkcUgKUjvgxRtiYOOmMf6BfoYZFH6QFMX19J3Rz4BvkUd22TBdLM3VThqMM0aXjqOrfUXrADvKlpDTdPds3ghSQ1gCdUoga2n2cwcuRJ+1auw1nX1ng0MfQSsvcAAag4jfPBXcyfl6sFoRyaR/V7Qr8yAfq++kQPuQwV3q6pI7mi5bYwJgw+r7k0sAekBmhBwvA/e13KKt3cHKd9kCUbbl3fUuT5vRJMuDD8Ro8oaVcEPA4PHZYCPELKWdl2AzdsaZmwmRO70GOpkFzMsXwwhL7hchYbc7d0lelSixGBiACZlTm7BaV8pYrA4wXtK6H04dIQ1DQ/VCFWqPD8+sAYTDPXVbmBfLedt5FCQ3lXA2XVC6ebZ3V39HULyPfNLdki2VC6HEz
 GbnXMiEH
 U5W1esUspjdw0vBb+cH9P5xp8F3j1sqEQg4zGIEkMcgNZUZLNBzCUVUEI+47bDDS38cz0A1vCCxSjseXdEkgHpsaFow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 02:02:29PM -0800, Suren Baghdasaryan wrote:
> On Wed, Dec 17, 2025 at 4:27 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > Specify which operation is being performed to anon_vma_clone(), which
> > allows us to do checks specific to each operation type, as well as to
> > separate out and make clear that the anon_vma reuse logic is absolutely
> > specific to fork only.
> >
> > This opens the door to further refactorings and refinements later as we
> > have more information to work with.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/internal.h                    | 11 +++++-
> >  mm/rmap.c                        | 67 ++++++++++++++++++++++----------
> >  mm/vma.c                         |  6 +--
> >  tools/testing/vma/vma_internal.h | 11 +++++-
> >  4 files changed, 69 insertions(+), 26 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 469d4ef1ccc5..b4d4bca0f9a7 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -244,7 +244,16 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
> >
> >  struct anon_vma *folio_get_anon_vma(const struct folio *folio);
> >
> > -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
> > +/* Operations which modify VMAs. */
> > +enum vma_operation {
> > +       VMA_OP_SPLIT,
> > +       VMA_OP_MERGE_UNFAULTED,
> > +       VMA_OP_REMAP,
> > +       VMA_OP_FORK,
> > +};
> > +
> > +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> > +       enum vma_operation operation);
> >  int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
> >  int  __anon_vma_prepare(struct vm_area_struct *vma);
> >  void unlink_anon_vmas(struct vm_area_struct *vma);
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index de9de6d71c23..f08e6bc57379 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -232,12 +232,13 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> >  }
> >
> >  static void check_anon_vma_clone(struct vm_area_struct *dst,
> > -                                struct vm_area_struct *src)
> > +                                struct vm_area_struct *src,
> > +                                enum vma_operation operation)
> >  {
> >         /* The write lock must be held. */
> >         mmap_assert_write_locked(src->vm_mm);
> > -       /* If not a fork (implied by dst->anon_vma) then must be on same mm. */
> > -       VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
> > +       /* If not a fork then must be on same mm. */
> > +       VM_WARN_ON_ONCE(operation != VMA_OP_FORK && dst->vm_mm != src->vm_mm);
> >
> >         /* No source anon_vma is a no-op. */
> >         VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
> > @@ -249,6 +250,35 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
> >          * must be the same across dst and src.
> >          */
> >         VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
> > +
> > +       /* For the anon_vma to be compatible, it can only be singular. */
> > +       VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
> > +                       !list_is_singular(&src->anon_vma_chain));
> > +#ifdef CONFIG_PER_VMA_LOCK
> > +       /* Only merging an unfaulted VMA leaves the destination attached. */
>
> Do you mean to say that for all other operations dst should not be yet
> attached? If so, "leaves the destination attached" is a bit confusing
> choice of words to indicate that attaching the VMA in other cases has
> not yet happened. Maybe reword as: "For cases other than merging an
> unfaulted VMA, the VMA should not be attached yet."
>
> > +       VM_WARN_ON_ONCE(operation != VMA_OP_MERGE_UNFAULTED &&
> > +                       vma_is_attached(dst));
> > +#endif
> > +}
> > +
> > +static void find_reusable_anon_vma(struct vm_area_struct *vma,
> > +                                  struct anon_vma *anon_vma)
>
> Naming is hard but a function that assigns vma->anon_vma and
> increments num_active_vmas should not be called
> "find_reusable_anon_vma". I would suggest keeping the name but making
> it return the anon_vma (or NULL if it's not reusable), letting the
> caller do the assignment and the increment.

I mean totally agree this name is bad actually :) good spot.

Since you might already have populated so we can't return NULL, so I think a
rename is better here actually -> try_to_reuse_anon_vma() which more accurately
describes what's going on and takes into account the fact it's doing a stats
update also!

>
> > +{
> > +       /* If already populated, nothing to do.*/
> > +       if (vma->anon_vma)
> > +               return;
> > +
> > +       /*
> > +        * We reuse an anon_vma if any linking VMAs were unmapped and it has
> > +        * only a single child at most.
> > +        */
> > +       if (anon_vma->num_active_vmas > 0)
> > +               return;
> > +       if (anon_vma->num_children > 1)
> > +               return;
> > +
> > +       vma->anon_vma = anon_vma;
> > +       anon_vma->num_active_vmas++;
>
> You moved num_active_vmas++ here to fix the accounting later... Sneaky
> but correct AFAICT :)

;)

I would say in my defence (perhaps unnecessarily, as being sneaky is a key
kernel dev skill imo ;) that it's no more sneaky than the code already
was. Probably :)

Really this is about making the situation clearer in anon_vma_clone(). We could
instead have:

	if (dst->anon_vma)
		dst->anon_vma->num_active_vmas++;

And with the assignment here, we cover off the fork + reuse case.

However this doesn't make it clear that in fact for all non-fork cases we are
_always_ incrementing this value, which is what I wanted to make super obvious.

One thing here that I think would help is to rename vma to dst just to
carry that across from anon_vma_clone() and to make it clear we're
checking/manipulating the destination VMA here.

>
> >  }
> >
> >  /**
> > @@ -256,6 +286,7 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
> >   * all of the anon_vma objects contained within @src anon_vma_chain's.
> >   * @dst: The destination VMA with an empty anon_vma_chain.
> >   * @src: The source VMA we wish to duplicate.
> > + * @operation: The type of operation which resulted in the clone.
> >   *
> >   * This is the heart of the VMA side of the anon_vma implementation - we invoke
> >   * this function whenever we need to set up a new VMA's anon_vma state.
> > @@ -278,14 +309,16 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
> >   *
> >   * Returns: 0 on success, -ENOMEM on failure.
> >   */
> > -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> > +                  enum vma_operation operation)
> >  {
> >         struct anon_vma_chain *avc, *pavc;
> > +       struct anon_vma *active_anon_vma = src->anon_vma;
> >
> > -       if (!src->anon_vma)
> > +       if (!active_anon_vma)
> >                 return 0;
> >
> > -       check_anon_vma_clone(dst, src);
> > +       check_anon_vma_clone(dst, src, operation);
> >
> >         /*
> >          * Allocate AVCs. We don't need an anon_vma lock for this as we
> > @@ -309,22 +342,14 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >                 struct anon_vma *anon_vma = avc->anon_vma;
> >
> >                 anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> > -
> > -               /*
> > -                * Reuse existing anon_vma if it has no vma and only one
> > -                * anon_vma child.
> > -                *
> > -                * Root anon_vma is never reused:
> > -                * it has self-parent reference and at least one child.
> > -                */
> > -               if (!dst->anon_vma && src->anon_vma &&
> > -                   anon_vma->num_children < 2 &&
> > -                   anon_vma->num_active_vmas == 0)
> > -                       dst->anon_vma = anon_vma;
> > +               if (operation == VMA_OP_FORK)
> > +                       find_reusable_anon_vma(dst, anon_vma);
> >         }
> > -       if (dst->anon_vma)
> > +
> > +       if (operation != VMA_OP_FORK)
> >                 dst->anon_vma->num_active_vmas++;
> > -       anon_vma_unlock_write(src->anon_vma);
> > +
> > +       anon_vma_unlock_write(active_anon_vma);
> >         return 0;
> >
> >   enomem_failure:
> > @@ -361,7 +386,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
> >          * First, attach the new VMA to the parent VMA's anon_vmas,
> >          * so rmap can find non-COWed pages in child processes.
> >          */
> > -       error = anon_vma_clone(vma, pvma);
> > +       error = anon_vma_clone(vma, pvma, VMA_OP_FORK);
> >         if (error)
> >                 return error;
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index feb4bbd3b259..e297c3a94133 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -525,7 +525,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >         if (err)
> >                 goto out_free_vmi;
> >
> > -       err = anon_vma_clone(new, vma);
> > +       err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
> >         if (err)
> >                 goto out_free_mpol;
> >
> > @@ -623,7 +623,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
> >
> >                 vma_assert_write_locked(dst);
> >                 dst->anon_vma = src->anon_vma;
> > -               ret = anon_vma_clone(dst, src);
> > +               ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
> >                 if (ret)
> >                         return ret;
> >
> > @@ -1862,7 +1862,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
> >                 vma_set_range(new_vma, addr, addr + len, pgoff);
> >                 if (vma_dup_policy(vma, new_vma))
> >                         goto out_free_vma;
> > -               if (anon_vma_clone(new_vma, vma))
> > +               if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
> >                         goto out_free_mempol;
> >                 if (new_vma->vm_file)
> >                         get_file(new_vma->vm_file);
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> > index 93e5792306d9..7fa56dcc53a6 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -600,6 +600,14 @@ struct mmap_action {
> >         bool hide_from_rmap_until_complete :1;
> >  };
> >
> > +/* Operations which modify VMAs. */
> > +enum vma_operation {
> > +       VMA_OP_SPLIT,
> > +       VMA_OP_MERGE_UNFAULTED,
> > +       VMA_OP_REMAP,
> > +       VMA_OP_FORK,
> > +};
> > +
> >  /*
> >   * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
> >   * manipulate mutable fields which will cause those fields to be updated in the
> > @@ -1157,7 +1165,8 @@ static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_stru
> >         return 0;
> >  }
> >
> > -static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > +static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> > +                                enum vma_operation operation)
> >  {
> >         /* For testing purposes. We indicate that an anon_vma has been cloned. */
> >         if (src->anon_vma != NULL) {
> > --
> > 2.52.0
> >

