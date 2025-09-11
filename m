Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE7ACAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40843940008; Thu, 11 Sep 2025 04:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFCB8E0001; Thu, 11 Sep 2025 04:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28040940008; Thu, 11 Sep 2025 04:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6588E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:40:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6F14B895C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:40:49 +0000 (UTC)
X-FDA: 83876323818.14.706473B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E17BC0004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:40:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rDMgIX7S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q9F5kqNH;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757580046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1xXJdaRLOvhmoKx7MwBZ8JwYAMjB3OMj2+Yof8jKac=;
	b=gSv77V5BGFB2ZtO6vqCkGVHDy/eQv7FrQyEwqDMoMuuDZe9aC0CO+vmU04OLxx6FLgL9nL
	xQxqkX1iqtvQoj2jYOB65MC2gAUDJVXo7iL1pQYDwvipEm5YGK+zlAzcWQlHod0JO5TUm8
	OLwXirP+u2bllvTilL8mxgg1L8yVyAM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757580046; a=rsa-sha256;
	cv=pass;
	b=PG51fcJSi7oDdZbglduixjErVQSaYflBpZTlcE1tLjURqBZ3AltF4hc/GPWBbMOEDaf7Eh
	32VlhUJunHL3rSInyHi3kjVYRqaWJNVH0cHJKepLibwC4Ct2ledPDe0/tVX9XZV9UnEgBS
	sOfJTpmqTCL5IERHpqskypL7jXjEN2c=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rDMgIX7S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q9F5kqNH;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7tgph027489;
	Thu, 11 Sep 2025 08:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y1xXJdaRLOvhmoKx7MwBZ8JwYAMjB3OMj2+Yof8jKac=; b=
	rDMgIX7SkGQpo2B020Q3bfzEttFD2dBtxFMz+PkRuWx7B/MxKiaB/yZXRUmDjhok
	gXWYkgMzROsnucn6bMpACKvJhsiLHfJMvB8409ASNS2f2Ix1uCMtPP8l42mx48hL
	gloBsuYo/JAu5IJWq3BY8/IjGFL9NXtciuL8AcqbLdQe19TDf5dAZqtKpVJv0OZs
	yIr1QjUmsOhgu8Zy4r0/D3qOxjRec9lfkDZNTmY6q322sWKdWqg9oPL2H/t1cmz0
	9XgFEs1eBe3P4LjUhYydhzVBkjikau8Z59lrQi7H4sHkiuxQ3LqIj0bikHWHxSoP
	911PiTGfeFIKDpImx2JY/g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shwqx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:40:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B72TIP012835;
	Thu, 11 Sep 2025 08:40:34 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013036.outbound.protection.outlook.com [40.93.201.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdcbqs2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:40:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jILuR98miEepZ019Zcal2kv/QFgYpttWFxFVGlsVEqiA0+Wrc3QNbM+YSMlwHHlJ5j/w5A/uKHNxBecPtXW0unLgIZv8mamLD2FxRxT875sihm8J+iBoM3zpMM1zchLVYMNj3XQ3qbgp29EArW620ixb3uNeJmZjDpqkbslOKdfxedStVPOfa1OrduOtfVC3fNeZRgkvFtESu1vtttHIxGYTgJQerSQ+cd9CvHexiT3ZYeOT6N3JKi6Ib+V6nL+GfqTp4LFzBrFDo1n37GMTlYWrJQv5OJSlm3v/Tn2uDkpVMJWHTy06PHcrx8tZuQ3mA3xFuAYoUvw4hg04/lSMpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1xXJdaRLOvhmoKx7MwBZ8JwYAMjB3OMj2+Yof8jKac=;
 b=isLwZK+acQaFgK3v1gXDaP6mggYScUFfjDB77Frjp200YtcVNh4plVnD3HGq5BYyB61zi3qxNir4GGcrRo42wrZ0JItDLJ8ZVdUaP1sZbiOOnzSGjDnalXiOkooxH4q2AOx1WevpMk/ulwEa4qKbvJiTcAXTBAMfqwr3hPtNL4mkyak4m8bae6EOqsZQ46U9gxRckwwTUZmQl0tsCY3FWb4JQS4X/sfnARpijV5v4qiPwyIXOhaO0ns3Oqwc5y4C1JEUJAkHlSbUZvL6trwLO3fbP30X8As0tCs4NrA2DHmqG34tkw8goVfjfhqCPMlhI4X9z5xxC7PcNHgbFOGj3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1xXJdaRLOvhmoKx7MwBZ8JwYAMjB3OMj2+Yof8jKac=;
 b=Q9F5kqNHXoc42sGvnzzOOMBWNztICWoLCjDb2xvLja7b8EPXY6rjHwfo/IgpCr/Iqdnf401kW5ZlqfEEr8UKdcbueGi0c3XRHZeIdZ7boDWuan9S3/fmoWtn9UC7LguEFiAxSsQaElbqYT0QE7zBm3TJUYIDiiqG1VfdzvTDhOc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 08:40:30 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 08:40:30 +0000
Date: Thu, 11 Sep 2025 17:40:23 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <aMKK9-ckLtEAdp4W@hyeyoo>
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <aMFOh1NxaIP0GtGE@hyeyoo>
 <CA+EESO4=Y4GsJ9sgnDen2tiY566z=vVOOcHF8dQYPy4nS4TPqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO4=Y4GsJ9sgnDen2tiY566z=vVOOcHF8dQYPy4nS4TPqw@mail.gmail.com>
X-ClientProxiedBy: SL2P216CA0144.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::23) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 606c6f99-446c-4a19-cc50-08ddf10edd53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjI2SnE4ajVvN2lIYXFlMzhYekkvQnlLaTU2Q2lPRmhma3ozYXRnVE9KTDMr?=
 =?utf-8?B?eGkyUm8zdUxicUxMN3JtaEYvb3JSN1pvd0hxOUdTbi9hdS9xZkMxYUV2NG90?=
 =?utf-8?B?MmI5TytNZXVmbUZwVEF6WldhckZ5ekpjWU9PRVp3MUQ0cnRoR0granh4dHl5?=
 =?utf-8?B?bmsxREF1akc3MVF0TFVpRFNmS1NDUjVmcVBhaVhZZkc0bnBHTzZCWEdrZ29z?=
 =?utf-8?B?OTQ5UVNTLys4Z0hzOWY4Zy9WcTYrMFB1UW43NHZydXdnWjFYbHUrU1E1WWw5?=
 =?utf-8?B?eERSbitWMDJTbldHOXZxejBJeWZBbUhCWmpwdGpraE5ydlIwbFYxMSsvY1RL?=
 =?utf-8?B?b0VYL2dxN1VxRmdWRjlQemFIYXVmdTVZTGUyNEZ2UTRwbGg2dU1Db2lJR0ww?=
 =?utf-8?B?NXFGV01RVTB4cVN6ZW00bGVzWURoRzdwMDdSMzYvYmtEaVlhdENuSTVSN2ZZ?=
 =?utf-8?B?VGVsaDluY0NKRG9kanNFY1c5bXUrYVQyUHBkVXNDS2pZbnJseFNleE0xVDUr?=
 =?utf-8?B?Z0sxTUQ1K1drUVAwK0g2K1ZpRG5VWXBMVXlqNUcyMkQ0SnNoU1BIVHpPaUFG?=
 =?utf-8?B?SmlJRXBtQ1F3STVHMDduMHdRQmR1TkhHdWtlVDd5dUkrV05xOXZHb1U3dFN1?=
 =?utf-8?B?UE03RTJNckNPTk1zanFIdzN1RGxMazVwOUhVNU02a0psZGFtN3ZWcnNBaWRT?=
 =?utf-8?B?NWpEa3dNczFzb29UalFOVnJCUnNIZEpEdXBYWFBYTGVXL05BVkgwVE45NVZ4?=
 =?utf-8?B?a3JQM3Y0ZGozdUhQRlVoL0pYNUNlMmdBcCtiMHhJRVp4R21taWlsVTRteVk0?=
 =?utf-8?B?dzlLQTEzZXMyN2kvOGs2WlA4anB2WDUvdEJVL3FNNDRuZUxubTNFQkxheEVx?=
 =?utf-8?B?N2hPUWlFV21lRi9uTU8wUk82L09yeU5udXdzdDBUWjNJRFZDSDhPMm9CWnE1?=
 =?utf-8?B?NmErZEtOUzlJb3ZwbEVicWpNMmxYc0psNk4zOG1haFVSSUhITHdrUkM2bDJD?=
 =?utf-8?B?S3lTWndvOXNKNys4Z3ZTekxMM1poOU4wTVJmNForVnBqMUJoVFZlTElsS1Q2?=
 =?utf-8?B?SWI3QWx3ZkJocElDdkJRZjA1aXNjdUpONlRJRUZ1SVZWdUpValpLZFJZckkw?=
 =?utf-8?B?L0ZKREZWS0wwWmh2WFIyTkI0T1BtNUN6OFBINkdYbldFSExtVThSb0EvZkFJ?=
 =?utf-8?B?a1h5dGhzcGF5WGJybXhUdzZOVDNQUXBzZGZuL041YXFyUkp4UE83UUdQRUV6?=
 =?utf-8?B?QWdEUmpjZEpMMVloUWg3VzVWdUpGWDhXdGNNRVhoYzN2L2Fyc05Md21KYzNx?=
 =?utf-8?B?S2dWWjUvZnA5ZDhJUE90eStWWWt0MDlDRXJyUitmR0k5ZHNpUytKNVlMTmx1?=
 =?utf-8?B?TVA3WWUzanJFcTZKWUloMGFXTlBnMDlPdk84RFk4aktidXdwNWU0aldVWlN6?=
 =?utf-8?B?WGthTndlQWd5eUh6NXV3eXU4YzJhRFNodUhBSHlCZlMyS0MyUXF3L2I2bjU1?=
 =?utf-8?B?b2o1ODMyeW1TSUNOT0NHRjlUd0QzSUFPVytzYUZoeWNWN004b1drZlJqdCtU?=
 =?utf-8?B?YWlrTzhyaEtic3VncXd4YWliSXl6SWZZelhFbDFaczVUeDFTb3g5Vy9xcmRo?=
 =?utf-8?B?ek1HV1BsM3RUazJodXJHcGlYaXlTKzhWYjZGRnVCaEUxMWpYSlJ6TSsrRlYx?=
 =?utf-8?B?b3NKcG1Id0d5WkpCRk1SWHpSME1ERWJPZ1JuZDV5bldKS3dnRjRSU2llK0Fj?=
 =?utf-8?B?Y2ZJaTRuTXkyYkpzeTRrY2ZwbHdiMlYzcnlSUjdvMzlPKy9ZL2NmTFZ1cHJ5?=
 =?utf-8?B?eUt0UHR3UmJGQkNWV0FwK2QvY3R0b24zdlU3OFZyb201anVNZG94NTdVZ2Q3?=
 =?utf-8?B?TWhMNTV4dGRYc0MvRk9DbUhNSEplTXZKbzRpQXBJYlFWTDVrT0NWdzUzRjVq?=
 =?utf-8?Q?4aP/f60EobWeXLGtGThcDL3dqsJE/OTG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkFnUXVSbmkvNEUzQkh5RVBmT0k5dXRwK1UxM2xGWlp6UkkxNjd2K2g2MFNz?=
 =?utf-8?B?RVJEMU9iNkoyOTNYZ3R3UzdOUlNDT09hWnNVSXNmb0Rlbmt3NkJGeXpVV2NR?=
 =?utf-8?B?dHBPUnJwa2F1OUJWa2ZjRkZvK2xjeEh0dmxKcTBYazIrdjVrZnlGUkxCRExn?=
 =?utf-8?B?Zks0blVoWlE4d0c5ZElwdk9JM1hDZUVGSE1HQVBUVC9TUFY2NjF1UDZ0amEv?=
 =?utf-8?B?UHo5WGZkSkdQdVV1SE15MWtkVWk5MjJ5SWJReVZMVWRvQzJpSEovQ1dESDI5?=
 =?utf-8?B?ajlkYXRuZEZJM0paUnovN29WTmtPMTVReVR4MDFqclVHQzdxU0hOVGk5bjZJ?=
 =?utf-8?B?RVBURGh4WVhyQkFBTzhPc1NXRVNUZC9zbTJWdGpUNHNHWHVkMmM4U2FLM0ds?=
 =?utf-8?B?bzc3em1ZNG0veXU3SUlJR29yaC9GZm44aWRqYWFOTE8vUFkwMXlKYm04SUVj?=
 =?utf-8?B?M05vOWJ0VTBvcFdNTDlhQy9EN0VGcW10cHlEOVBtcU1MZ0RSQVYzRStyQnlT?=
 =?utf-8?B?SVRSb3RkemszSDBQdGhzdkFvaXYzcmpQakVYUDcwL0ZhT0x5cDl6SVZPcEwy?=
 =?utf-8?B?bjRCN29rTzNPSFBZSit3R0NnQTQvalVjZGp2T2VpTjRpeCtEMVNPVU03dkkw?=
 =?utf-8?B?Y2pSKy8wdklsQmx5NkQybUNVdDVIeHUvNm5sOStTRUErbmNqS0FuWGZ3c0l5?=
 =?utf-8?B?WFVQN3lndllGcTdqc3FLaHlyYm5XM3J5UWF3UXdhV1d5bmZ0TWtzYTdLTFhi?=
 =?utf-8?B?Z0RoUDJ6WGc0alBzZGVodXR6TWlXL0VyM3Uzb2trRitiWVJTbUliVDZZam9Z?=
 =?utf-8?B?clRHV21xb3VFbHNJMTJDanNkTjROLzRlbWtlWFc1MFFZRWx1eU5weUhSc2hy?=
 =?utf-8?B?MVk2dUpMZmQ4cVJPZFBORHVESTdGVDEzdHV6RHFTOE5tTmFhVXAyakR1aUFv?=
 =?utf-8?B?dk1PbGJ2bWh5SnFwRGs2ZGwyQWhwRnduVG4zTFl3V3F0V25mSEZIak90aFlm?=
 =?utf-8?B?RURXc003QkxRWkNMcTFTQWVtRzdBeEdYNTltNTB6Q1lFSnJqb1dHa2RzcGlF?=
 =?utf-8?B?SllMTFNjTnE2U0liK2dGVFJKelRaREF0eGVEbXhVdkx0dElGRlptNk1OTW1q?=
 =?utf-8?B?NU1xKzhrWWI2RG92MkRZMjhDdHNwMzVwYlV1eVUrTFF2WlVmZU0wLzlmWXEx?=
 =?utf-8?B?T2wyLzM4TVMyMVAzRFRxUjVlM29OK2FGdUM3NmlrUU0rUVNxdVk4KytiUW9y?=
 =?utf-8?B?MldPbnc5UTNkZDNQS3Y5cGxJeTRvTThLRGlCRW4vV1owZDFLSnZWL202UXF4?=
 =?utf-8?B?Uy9hcjY0R2ZacXlhWG80UmtVU3RFTFNTZndXZncxblFBeWpQVklGUm9TZGFa?=
 =?utf-8?B?dkV0OUtvRUhnVldURDk2TW9XQW1LTVlkdUQvV2dFQ2ZpR01aVUVwR3BWU3hF?=
 =?utf-8?B?b3JKbkdlYy9LdktSNG83U3VLdnJIeUlLUVlERFdVT1UwYjNLeWNtMmg3a3J4?=
 =?utf-8?B?UzVNT0pkNmd6d0t1ZjZoSktabWxlcHlKVkoxK2puTmJDbEhCRWVpMU13SEF3?=
 =?utf-8?B?QjZTa2FvalJKYTQyTjlQRy96RlhxcTJOL2g5MTJHU2k1NlljT05UREVRaGpO?=
 =?utf-8?B?TVMzY2pXZlp5dGZLUVk1MXVnZG5FeDhyUnQyeTArNXlRc3k5a2tKNU5MQVN3?=
 =?utf-8?B?WFhYYzBuaXY2TGc2eUhuMENxcUhOQjBYaTJTcE55aDBNaXFmYTl1Q1dzVEs0?=
 =?utf-8?B?VkRMcUNTSENlN1BYem5mdTlyRXFQdUNybk5LWCtmTkh3V1pTUUZUVUw1SU5h?=
 =?utf-8?B?MEsvTzRTMVpUUlF5ank1R21USXQ5K0I4R1EzNXZkblBXTnpyWkZpV2diNXg2?=
 =?utf-8?B?UFV6R2pZbWxIdDRzbzVFYjV6NU1lZWk5dXhDa2FFRHFIYlZLWUg5c21qbWYx?=
 =?utf-8?B?MXQzdFRLTHJOTk44OEFRa3UzNXJaWnNXUThVMnBtOFFGR2hraFFsQWdpU21W?=
 =?utf-8?B?UUFqNTJHWjVKdmlIVEh1QURSS2plQ0RQNysveTIwMTd5Q002dXdRREZKSGh4?=
 =?utf-8?B?ZWM0bVJyRWR3Z29pdWFUNzMxd1pxU0o0SlJmNUU3bjU0VDViV0VPV0wraE9T?=
 =?utf-8?Q?PMTWlTj9YVg8zLWh0jDERpVQq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PyiXl6uUfnySvQqy1q/8j8Rrk20pih9OH/8f5kK5Q3HLHV+7ipa7OX1k1oQm2aeLLMuRjfISPkPTEdEwv6cwhmvQw10K3fziVrZY0baIZzewZYAFyEd9etl6d8CB9Gb81W2wyHgxzukX189OsCLMr7qdkWlUzg5RWTQ78ExudcFNIey/Q8EqHqYPWA7THq1Q1PSJiqgiBkxVBGLfZF8QvWp8coxVbMMgQZWTF5gbuedBMNAETmb6MRM0X93mvsBak4pTtoY6+13Cb1JmNsKfZWlG3iWcSteVjGHIKXdOhGAOCvZQCe+FdH+9LRF9VoxTV3dZTyfctTd7tscl//8UKvIiB0R51YBwxMO6qR2K6J6TIER9JeyF8XCPPgn9C7tsVOkjEaWcCL5UVYIfHRA8kVd7Mp6nxkdrS8HTn6Snb59cWPZlxgKBfXqRhjSfTCpLQa0t4UimkGDcMWGW1YDNc5BgZ0ZeGUnt/Lbu5EhowHJroLNw9i9Yfi+agKJHIlB1/GBYiVVu2YyM74SXrze3uKJzHloNA4gPD7ZuFy1bJNA6cL1/qYS9AKiwHClECL/ssH1feb3zWe4qAjQgYFdoYGPwGt6NZoCFDAUgNliL3L4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 606c6f99-446c-4a19-cc50-08ddf10edd53
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 08:40:30.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvqHRl74VtmeiPXA8Zo6Drd+Gxj227CtJ3Q4DuqcNSay93v7ZzMAzWHJzrQeIT69cOFgfbgEPbwaV18HeB5dzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110077
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c28b03 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=JiWjlwDo8-lTYsqvZGwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX2JiQuUFRBIFE
 E+YNieSAj1aIkdxc2PNra/GpGdtFBRktxiEiOFTuP1Pa4jmPS5UVB7BLxYTLlvLw6w1NqoOGMob
 HPTKR3WoLC3NOuKH7bDCIZuRjaDy7/+qopMrbV9V+fHRX6WpPC5C3T3fEVAjthH6+VmYzuIy1YY
 jLjPT4N6+qm7RnrW/g66FmzGItZbmwBK4dsqfQLiKe3LYFgmfTAjSQuHFkdmdgGvQSvh0nwtIFW
 Hifg8YLfel0uIH0agGTiJjrCzQvL11TTN7YYVbluXxo6ukHtaN2ao6VLbNxdr/c80ez1uuUcnis
 apKtRRC3h4NGAHzsfJJCcpgJdvEsC2+EA6zrf+tHQ5pFajftDoztMHN1d7xn65mTjXIf/H/MZR0
 ovWexZ6S
X-Proofpoint-GUID: tugFtra2hwNqxk7-p0Wyy0aXUMOK5zB7
X-Proofpoint-ORIG-GUID: tugFtra2hwNqxk7-p0Wyy0aXUMOK5zB7
X-Rspamd-Queue-Id: 3E17BC0004
X-Stat-Signature: fuemginbwgjqrahi995fumu9qpg3hzmr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757580045-426205
X-HE-Meta: U2FsdGVkX1/occP8UDtTUR5tcZ5G+HD/pgWLZLMX3zcswQGfdUOQVVvA4TyLUQ4TSr4O0Id0snvr7M3f7ovdR1DHdSI1hfdzuZk6qooXN02TQIYxhNF9Qun3FSRMIuxUxLVKeDbEsTDZob5Kaw3nq21ORWwaFO9DA+3xBxMBwXi/xfsLOXIpAzKdc+wGtt7pd86OxCGmI+4FESva8NxMl410ZneceNSoGG2FnFtAfP9JC4DFH5IKrW4MLO5uPQY2lkCS8TIwPtcxaU1DBu3CRMgrD3ZVUw2fUw1ikR/siu4TeS9XgIk46E0V94lO/rp7KrQpbOcVMj+T/fjdM+X3jy0q6UrE0Hujlr/kqO119q9fST7uC7Y88nykBZzGRHy5psVY4mYJh773SZYRJplRdKguhZCKhMdv+/tBBfewgxPW7j4cQ2/6P0wXzZmxku2UkYIG7UX2md7QJxD0S5kF6pxcleHY3Ztyx40TGybGc6xAPM2c4PtfSxu3fskeuF8XU3oLPM8kESOgAVKKZFaUu3y7PpAexpUOINp7Enwb2zGnWvb7MB4GVRAsNEOCY0EJl1I6KMC7mMU5eFeqgTP647NxjKFo4cwngG7y06NSSSi9xXwv+lkcg6uXVkCZzpX9IR4z6xL74YHIjvclJAnJFOSHOBlX0SGqnWNBbixIPl+gzmwd0z42lE9GNM2HV0DLzz2uWZs8k42NEb9EZxlTNG1Kvcy9riICFVZcGLoo8ZNVc0yNNC4UE0J0/QrLae9qq2xDG8Tjaeecunw8GZ5Q32jDjU+8OYuxdQ+A1FkMosditGJgIb4qcVnt6ic/lgHtboAL76zi1Ihl3OklWiarkWFqh+wYzmVizI0680ktLjeTsgN5iarFJUQ01JQPhuq5MVH5Wc6h3rA/2ZYd7cm2fEY893DWD4MxZEib+pIA7PPuYCf0cqNlPiiBjfbme2suavFHDkxLQWFOJ2DLhkl
 +KaH2fB+
 6uFcZDLdna7/bRRGZs2+OojaBua8ta7+g7b3ioBiN08vjxeG0O25DxfB1qscX/irCfy9sgLLVXro3x0ly9WkxVcczDM+WH9W6z50Fn+9i41cQUeRLPURbR5bT/dBo/ckODVfmxCW/FEMtzzMSgl0ddQThirbf4lUmHJR76JlMOuTpcnq4TLX8S3simVBuvP6AR4qNFd7G7vDljJ1vda5y7o80W5Mmfk+4OVTqfguMJG+TaWmUeT7salDE3AXe/+Xek41gFtk96tx0jvRrCMlgCEMk5NgdzggFeLOX8h0BNMxYxP5gV/Ol7HQ6Nt1LJisQ6iIR2s8cYv4uIVWGsNbrxE7tNAHnhUrLWopKwJdXPrVBJymgiWEzqKXc+bYtMge5zXENk7ijdL3uXamzBegH995PN7WS2rAbdCuoYzZnuclQPKNlad8C4g3DZ6trv3GTHNGLQpOt8NnedzxexUcjBhNdc+Jq2Zqp7uHVvHYe6QF0ZbAN1b/8sE4x9zyhSf2CMRPnPdwpEgGStXGnu4tZyAteVX65cIsYKT67pEbfXPFkdFZyd0zYziNQGCcJGgg3PQZO9O+ET62MivtYUK/+Dlf6uNwVdLiKHHtfv8WKYOSrmtvEjORFGgZu5gMWSmnYbOh4cWh+uXFKzeD47TBzLpixM9E/LnOsDDhQpXR7gy8gPHQfeL09e2SplYUML8UPK4jNIdGru6cIEoWnR1DBkpJmDubwwNcaUINtWFnidR62EMjevgTLholI9PE0rhFsPD5NnKeoSFlqxS2+YOlr20MwaZTnOmSNZTTmsXBf6T+ZJEQquzN4W9pl+rjnVCT3BqHR5Rzhh5fXm5FSETJtbpkU3cUEEFuSQa+pCqxaA43zBZ/CcoxRM9p8NT+yndQlhSHqmCEjjZjvcUoUhDcXqEgdRizG+trDLgjGYnnQGXdupuMftvnShGrowjnAttQ1ihWUnk1MMV6aD4gbg5GibCWC4ma4
 vE7/XsS2
 np5xUDrGowVONE60Q1u41t7R1dmb0TRv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 08:33:54AM -0700, Lokesh Gidra wrote:
> On Wed, Sep 10, 2025 at 3:10 AM Harry Yoo <harry.yoo@oracle.com> wrote:
> >
> > On Sun, Sep 07, 2025 at 09:49:49PM -0700, Lokesh Gidra wrote:
> > > Prior discussion about this can be found at [1].
> > >
> > > rmap_walk() requires all folios, except non-KSM anon, to be locked. This
> > > implies that when threads update folio->mapping to an anon_vma with
> > > different root (currently only done by UFFDIO MOVE), they have to
> > > serialize against rmap_walk() with write-lock on the anon_vma, hurting
> > > scalability. Furthermore, this necessitates rechecking anon_vma when
> > > pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> > >
> > > This can be simplified quite a bit by ensuring that rmap_walk() is
> > > always called on locked folios. Among the few callers of rmap_walk() on
> > > unlocked anon folios, shrink_active_list()->folio_referenced() is the
> > > only performance critical one.
> > >
> > > shrink_active_list() doesn't act differently depending on what
> > > folio_referenced() returns for an anon folio. So returning 1 when it
> > > is contended, like in case of other folio types, wouldn't have any
> > > negative impact.
> > >
> > > Furthermore, as David pointed out in the previous discussion [2], this
> > > could potentially only affect R/O pages after fork as PG_anon_exclusive
> > > is not set. But, such folios are already isolated (prior to calling
> > > folio_referenced()) by grabbing a reference and clearing LRU, so
> > > do_wp_page()->wp_can_reuse_anon_folio() would not reuse such folios
> > > anyways.
> > >
> > > [1] https://lore.kernel.org/all/CA*EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5*4aDx5jh2DvY6UHg@mail.gmail.com
> > > [2] https://lore.kernel.org/all/dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com
> > >
> > > CC: David Hildenbrand <david@redhat.com>
> > > CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > CC: Harry Yoo <harry.yoo@oracle.com>
> > > CC: Peter Xu <peterx@redhat.com>
> > > CC: Suren Baghdasaryan <surenb@google.com>
> > > CC: Barry Song <baohua@kernel.org>
> > > CC: SeongJae Park <sj@kernel.org>
> > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > ---
> > >  mm/damon/ops-common.c | 16 ++++------------
> > >  mm/page_idle.c        |  8 ++------
> > >  mm/rmap.c             | 40 ++++++++++------------------------------
> > >  3 files changed, 16 insertions(+), 48 deletions(-)
> > >
> > > @@ -557,17 +554,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
> > >       anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
> > >       root_anon_vma = READ_ONCE(anon_vma->root);
> > >       if (down_read_trylock(&root_anon_vma->rwsem)) {
> > > -             /*
> > > -              * folio_move_anon_rmap() might have changed the anon_vma as we
> > > -              * might not hold the folio lock here.
> > > -              */
> > > -             if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> > > -                          anon_mapping)) {
> > > -                     up_read(&root_anon_vma->rwsem);
> > > -                     rcu_read_unlock();
> > > -                     goto retry;
> > > -             }
> > > -
> >
> > folio_lock_anon_vma_read() can be called without folio lock in a path:
> > memory_failure() -> kill_procs_now() -> collect_procs() ->
> > collect_procs_anon().
> >
>
> Thanks for catching this. Fell off the cracks for me.

No problem ;)

> > Not sure why collect_procs_{anon,ksm,file,fsdax} do not use rmap_walk()
> > functionality :/
> >
> > Should we take folio lock before calling kill_procs_now() in
> > memory_failure()?
> 
> To me it seems minimal (and sufficient) to put the collect_procs()
> call in kill_procs_now() inside folio lock's critical section.

Sounds sufficient to me.

-- 
Cheers,
Harry / Hyeonggon

