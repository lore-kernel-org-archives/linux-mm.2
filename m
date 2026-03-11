Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BFBA1125865
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537446B0005; Wed, 11 Mar 2026 15:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED626B0089; Wed, 11 Mar 2026 15:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C26C6B008A; Wed, 11 Mar 2026 15:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5466B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:05:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD79D8B74B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:05:24 +0000 (UTC)
X-FDA: 84534710568.07.4FF016A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66582C0017
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:05:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QxepBaMS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=v1ZIjGiq;
	spf=pass (imf10.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773255921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0OOGy9q9Wn6Bc4/jdk6MhhWKfp+Dy7SHzn1qjDxBOI=;
	b=3cR4lck+vxn6qxK0b8+JzdFwM9k7skYa3IKx9hvw8frLwji1MbhiaXKuh98Tfa/FC5AgVk
	iz72yu2kVTSbfIeQ0/UaxrUgunIQ+A+AJX4C4OQxTNW+rCciGE9p0ZECbV9x4YA4vMeeVM
	hBUIp4PEBYwQY/7TXt2KVt/UaxXPR6I=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QxepBaMS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=v1ZIjGiq;
	spf=pass (imf10.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773255921; a=rsa-sha256;
	cv=pass;
	b=o5Yy0f5nUOqs1lON0CIic0aYLaERjajgEFNY+G4FXzlmF4VX1aJKRJsfoIr7axbx65bZuC
	wlzBTYnVuKBFNvH8nzgUy2rSjOGv/r1XynC0+owSjy6I6g1gZ7jr8Tu+zII+YxO2/6Rq7D
	NnAKuvdB2lutIWAqWti/J3MdNR2oKtw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BHHJ5f3507813;
	Wed, 11 Mar 2026 19:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D0OOGy9q9Wn6Bc4/jdk6MhhWKfp+Dy7SHzn1qjDxBOI=; b=
	QxepBaMSd+pxSW1T3hs182bDz7Cd7kHSj4ME0lcdsBzADZgCW/w5a5oB5xSHmSNQ
	dLxrxWdRR7D0s/UzJ7RmwLeIFj8kEg4IRP2ck+Rpk7URFRnehDOw7r5ilF2oPw/p
	PS8Y8U6vsTSW+GA0T/CF25hgAeQ3qvDu8U4gC84ZpVELHBsln6bxJCbHGtZly+OI
	N/84GgYVDSRFpqFPWkoQEuACaq0ad8KE8HA6nwDnvNMDNZcNBF4Jv3o0mxJyUqYI
	V0WvLV3DsOUPtAsqRaTXnkbVwN/GI6Rty6rpnGVwE+ae7QaeDMyPWtT0SGOOG5nl
	UrdeWEuHWOJ1J/8HdejMqg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cu58x11hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 19:04:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62BIQq5F020417;
	Wed, 11 Mar 2026 19:04:40 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013034.outbound.protection.outlook.com [40.93.201.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4craffyw49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 19:04:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yS2tQSGOMq69KX3niZy2kV8/1hbguFRmzFV1zAQFPYSwwidTu1S17xb53UBzz5Isk6N7tzvpeyOgobtCwbmVHzTTaPc0a1N6ps6xd4MGgOvNWzCv2gDg5eoypcW7Gz3rltTb7CpILnDOIHwzbYMaDZF4riU/NPAzjJDu9H26FK1w8so0KBlSe203EQfoS7qYxO9/kzlYVmcKVV55S+pIBYXBGNRKgzIRAW8R2rIlfrMBYHYdg3POGwLJOC/KFqrmoSBcpzUxHN7mlljz5Em6DWVOugS04gwfeNwtJB+T3pJfBbQJ1R65EQJ4o1GrvBP2dM98HLjvMiVhX904ackEow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0OOGy9q9Wn6Bc4/jdk6MhhWKfp+Dy7SHzn1qjDxBOI=;
 b=ld6RVaSPZogtHPL5B/xYY3kvSCxBKeeVvHJzAO5OBLewF2iBgB/qIKyqpSt4MjZ7kOYa1sK7g8JQnQOpLOzCGiUmtdNgrkf79MT2kPUcQXvrs8+/qqIjbq/Z3RxeH+QfLpt4rmXY+BmLHX7avCsA6MpiqocuhsCt9kAupedFQg9CpV+aaf53ySKlNXfv2HUZIEUZdRjg0UngyFi9SlVZh7dBWMWffz0Nla8P3CdD6JvHDdNZPqk+XeU66MS/zPWvwjHUKn7GMTP1zLLu5l027WgIM84Nkiu2rSDvjdnGyFYjdjzpqX/urjSFLsKlRGX3BCrBjzXw0tokAviRYd3mOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0OOGy9q9Wn6Bc4/jdk6MhhWKfp+Dy7SHzn1qjDxBOI=;
 b=v1ZIjGiqzp/xsvw2JUuvPy4ZDHu2s8cp+QcmJTK/I5qQ+D/4myJSAE3PUUx6/Jser+AAgv4eZmJNo8x67AqiwPmSDQ6S6F45vkVTMrkDo+M6hHJEzezbqqbfAAL/YMzhgA8CrX54mmWRQk34g6Uj7IL91F8fydCgyjNNcZDHHis=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.14; Wed, 11 Mar 2026 19:04:35 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::c8c3:861e:be9b:fa6]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::c8c3:861e:be9b:fa6%6]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 19:04:35 +0000
References: <202603101342.297fb270-lkp@intel.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, linux-kernel@vger.kernel.org,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@amd.com>,
        David Hildenbrand <david@kernel.org>,
        "Andy
 Lutomirski" <luto@kernel.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        "Boris
 Ostrovsky" <boris.ostrovsky@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzessutek Wilk
 <konrad.wilk@oracle.com>,
        Lance Yang <ioworker0@gmail.com>,
        "Liam R.
 Howlett" <Liam.Howlett@oracle.com>,
        Li Zhe <lizhe.67@bytedance.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Mateusz Guzik
 <mjguzik@gmail.com>,
        "Matthew
 Wilcox" <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, Mike
 Rapoport <rppt@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren
 Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm]  9890ecab6a:  vm-scalability.throughput
 3.8% regression
In-reply-to: <202603101342.297fb270-lkp@intel.com>
Date: Wed, 11 Mar 2026 12:04:32 -0700
Message-ID: <874immur0f.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YT4PR01CA0452.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::18) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: ad6d277d-b47d-4552-f5b2-08de7fa108c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IghAy62Y1cgOyWC/yOFunoYujbrwUvd/SzkS+pImuKK9S/czX4y1XehxNZ05dvBcoYr5BtOhmts42FF6bzaYafk9pdNwR+ccr18S+nP9a3ZliY0VjlTBR9/2DZAivgVVEJRwKvv+KXSaVYg+rr8KxrtrFfhUba2y5pvFEh/sb4xlCiqJBola52tXwLSUPhN2EAB6+2g+99tCVG+5P7RiFFzSskzrlbrdBPg77YoNR39xrySuw/y3w4YQo9hTQSIcKH4cZLpc4ugMG+8GHudf6hV4UH/bvuaAq6CIRPAgiy1OvPQIkBIFlzLM483BmQhOqXq2gPHh3jZvOmL50FfxiBmqmwEuTVyzQkpccP69vzjQs7oDPGMinSVe+129p5yMxy7gdiMbgRXYhItah1qjKdqTiQ8DNaVjXijaYZwH8x1QHVj/Jzm7bFJPBGxOYkpcAIsnMwbBBBYo2Az7SXeqR3y4Wj6ySupDU8hHidRMax+MWt979oTsFgVXSa1j99zBuWlRcXNLcZfR3teTpuZsC2/UyYVPg+dYGN7plqccbW5o0WSvA746CfQ95vO2/EcLYU+ioYecES5qj7aub9M3fFRHz15W8D82hCrJfoXidl60KmyLw9dbHjYWJfOkLiLnO6IicYSA1rI/eWV3DUjJl7kB2uIF/aA3OjV0K13MnqIesgp0dCwK3unGl7PxSDRtHTWLCtgfcdiVAGYykS8mdRMbcENrypY9oDiGoXfAspI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cThJLzEzZi8rRE50dmluY1hFMlpZRWNEeDZRS3dYWFpBdDhVQ0t1MXE3YWFm?=
 =?utf-8?B?MUVoa0dSM3Zva3h1ODEwc0tJOXZmV3F5ejl3NUZmamhWUkpsZUNQeW1GYzRx?=
 =?utf-8?B?eXNweVBsY2NWYzJWazVzeXBMUzNVOUV1dFBtM1lZQVBKN0hBUFMrTEhoRXpU?=
 =?utf-8?B?aWthOWNRbzlFanVkdzRKOWhBSE4zeVNHTmZyek85T2tZZGI0SzlLZzBUbFNa?=
 =?utf-8?B?a1JjWG1leVY2ckx0SGgwT2dtMC92RXVTbnNjQmQxdWlrNlkxNmFsZFoveDhO?=
 =?utf-8?B?S0p4Qnp2cnJ6UURkOC85eGZ2RVVVTjdldkNRK2xKZ2dQaXFQb0s1YlNmTFJy?=
 =?utf-8?B?T1ZjUE0xVkFzeTRyQ2czenUrK3BmYlc2TW9BUlduOTg1aVgvbHRnNWpRU1dX?=
 =?utf-8?B?RGJpc0xmamswS0IzY1hlckZaYXhxTG14Y2p3WjFKRVUxWlpnQXdINVF3Wmgz?=
 =?utf-8?B?MjNWMHJDcGloWDZoeFROTEdUQ2Fzd1NURnN2aDhuMzlzbC9aN1JuWWlhaWZr?=
 =?utf-8?B?Z0g1cGdxZ3ljbW1QWWZoeUJ3ZzFtWGZWQnl4RkVLdG1xWCtZZWtHbnAxRlFV?=
 =?utf-8?B?bks1cjFUa3ZKQ1J4alJpU3dNa2UwZ3EzRzVhcEdoRCtOQzdPcXBJelZRb2N2?=
 =?utf-8?B?cmF4MVdmeHBDaDNwa0YzZGRWU0tpUkwwSk5qWlR4RGx1M3h4bi9GOENuQUxn?=
 =?utf-8?B?T2FTdUFxdGRabHFSRVllMFNuV0U4TVZrem5jR2ZTbStkYVc0c052WVZIZGJx?=
 =?utf-8?B?UjA1NG9CdXozMkhsamZjakh3Nm13N1A0SkxKTDg0RDRKMEVZT2hMUVc0SENh?=
 =?utf-8?B?VjdYL2pkZlBtd25jWk5XZWVsZXkzSUpTRTVKMktBUngvTkZ5UUhsRTFhTG5F?=
 =?utf-8?B?Ri9TUzRBcWpEY1RmVHpsUHhOazBIbXBXU3JDaDg5U21VcU02RWtnNG9XbEIy?=
 =?utf-8?B?Z2ordVdMb0kyRmdBT20vRitHMC9nQ1ZpU3U0bGQrMjg5aTBveGQvSWduK3hU?=
 =?utf-8?B?YWUwZ3pibEZ6ZXAzS254ZWgzQ0tMTzR5RjJaTW8xbFFQaHM2SFZmYnY3VlBn?=
 =?utf-8?B?bUxSUzJRZjRWZ2tvaUhjNzVOOE02VFhXYVNPSXpoZ2l1Nm1VN2creE12WEZG?=
 =?utf-8?B?RytBWkFiQUJJL1lwNTI0eEE1WkUreStVOW94T1J1UFVsREMzbmpTcGxVYnNq?=
 =?utf-8?B?OUExcVllWWRlWEFBOGJNbWFnaXJ6MlQyc0NnRG43VFladTAvNFI0TGNIVFpT?=
 =?utf-8?B?ZWVnbHJhRTI5RlU1TDR1L2dQLzVVWHh4aEQycU5ZRlkwMnVKRE1wZmhiK1Mw?=
 =?utf-8?B?MG1OWjg2MVU2Qkd0WTRxMVFOUFJCV3YyYmVGd1V0bkpaVFFubmxZTEpSZWdX?=
 =?utf-8?B?ODB6Q1VOcDZxcHMxM0l5TDZCK1JYTkdNMGpTZ1F0UzI0U0FKZ0g2K1JodnBj?=
 =?utf-8?B?bFhPQy9yVnNUOVBIQ1ZZaklDemZzY1hzTmdiZDhjS3lHZVhwOHM5YWN4U0lY?=
 =?utf-8?B?blg5RXNrOC9nRXFXSHovZ0lUb3oxU3ZyS0R2aWdsd0lSdFJtZ053UDVCUVpw?=
 =?utf-8?B?VlpkS2duQmdUa1ZGNU5FcGpGd3Z2QUFOMzIyZk8waXNYaUs1WFkyNnVVa0Vs?=
 =?utf-8?B?aHc4eG1lVmtQQVlHdHdJMGV3aFR0ZmdNZm5oUktVUjJkZGVwRG5NcW9JVlM1?=
 =?utf-8?B?VUpaN0VQb01CWjBtRlFTZm9WeG81aVZpZFU3UG9LUWtHbTBzSWVuRFFaSlow?=
 =?utf-8?B?bzZhajRjQVNGTFc3WUZ2bm9HMGZDV0wyTFhHRmpiYlkrdjV5bTczcUdaMnRZ?=
 =?utf-8?B?R2xkZjNEbzYxOXlBbVlNMDFRaHlUOXUvRTZoLy9yVnRzcDUrNUkrdU5mZ3ZM?=
 =?utf-8?B?L2lzcXlKejRPeXpoOGd2ajFSOWVhR0l5WmlOM2dwQ29maDlxV3QyQVM4VHZP?=
 =?utf-8?B?djBiMU00aWxhWHpPd3RkQUVSVHRRaWFCb3VVSllUK1R0WitQWUJ2Ri9kT2VI?=
 =?utf-8?B?UVFjOHRieTM3SWtScmZucnZNVkd1QXQ2NGFqOVBzSHRTbi9zSElrdklxZ0lq?=
 =?utf-8?B?K3pkaUlVQ3kvelc3NmRVTzJxN1gxTFltUklldCtHd1RBc2tkOUZpVHFEQmFl?=
 =?utf-8?B?MGpiK2R3S2RHMjVmL1lFMWVURndSVXA3WFIzQnlsNGU3bEc4OURwYTBBNnlF?=
 =?utf-8?B?dmx0Q2lSSUhXa051SXd5MElRUkMvRExiZFRMSkFXd1pvcHlKQzFTNWR0Z2Ix?=
 =?utf-8?B?UFJCYy9XVEsyRE92MnhsRnQrZmh0STNwSHN3dXY5TUxZWklOcE1EbFZPZlRI?=
 =?utf-8?B?eUhvMnBGeGZ0RjAzWG90a0plNnRsNGp4d1MvcVFpcThSbzdOYXVYRHVsRWtu?=
 =?utf-8?Q?9RBr9Cf5Ed3C95Nc=3D?=
X-Exchange-RoutingPolicyChecked:
	WFpHr8pbfRwguFRl1mtY70xopmh/EWzRbrvy3378O3nGzpifzA0Klv17VI3jhambv3+mag2wiHZqX4wTyB5/1f60d7DD/xQgo9sShgxZRYLdLoP2qala4WEl2eTzpgqIouxxWxc6KeLHK2vvhf42pUMKVEVNPIfpMQSQH7btLQJmSU3TL2Gid4i6SU3bfMK85+MwV5kpE2vXQyXmd2k1wzM6afMMDaLSQ81sHCAdxivuVc3RAPVYdgKd0KbVhvvNhmPAuUYemLaQkAAPcvZQ5mj8ELaJjwGtrPM+ngFQC2e4OMWOeGfeER/eM9KCsn+i6pl401ioVogauqlYLH/SuA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5n8LVZl9LYSgnOCbINgvYxRdsPcQ7W+8aw9YwGeciYF4VbPMh4K0pEutGT0HWeIke+LCkk7QqhID+VTm7lT7FSZHGv4Cb+lcYqBcrGYE9m7sFTNfgqHDU6hS/GW2Ucv/OEHJCawG8Ef1SeodbX7VwsJP5Ei57ZxMQHGb3T7dDilH3lf4wbj5aZBBpqQn3D6tZT8UsJZ/Can+SRIw1upBzaFgXkt1zSRxXFwQJ4Svbyx3L/+Z57N9TF8ey8vGNS2ZtbxzjYbwNuNTiY+i8457K2qN2h+qp62WIy6oA1aqSEwRUK8P8XU3BD9aXtpTemuO/yrTTHfaiVa9Yi+s8nj4QEBMWK6eZWvlySOupoBgxbIWH7ytumeUxXiJvDP7FMu/D6lkUVBvA2VMLyfiJQ09gHXBUysIWjFSl714ApioOmdVzmdGbzJ25NwY13xkpSQopdZKvdThYKlMl6aoZDk+hUd18dQaByDagJN2c9Nu6Qozk5G3FzhrTERrt+ucySoav83mFRT6+RL2hqtte3apjDkPw8DJPiPr06jpar8TIFqolls9uOJCQLShytAdVYx9EhXVt2kqHIyST7Jd+ngYnzErB2mFOsoCDYVWsvkjWIc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6d277d-b47d-4552-f5b2-08de7fa108c2
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 19:04:35.3478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RjC4YnA3ILCeTAXkn2hjJrS8Zd5EWU6MIeOCr9w+kC1L5MN089kMyKq7NfpxswQhFwt+jpqD2AyAEc+jdfvFg4z6JdFQVaWA/68mOfuWn7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110161
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDE2MSBTYWx0ZWRfX0HHXKmS0tfIK
 2tVSQa9awNE/YVlsugxCCfmDv3Xs1vkoqj88mIwKPES5e9fMU6fMuphHV3TFQ7USspRvGrRuJlz
 sWkPtvwLXBiaQoVoyYW72m88o+W+K/hVNqvS8toCKrh1nHdvTNEI68ZfYz9XEJUiUFmnvEVuf3u
 aYZJid7h8JjsMi3XyKMEKunLTAx1Kl8BIRVPikfTxF8g4MzLMNxzyd3cC4PB4aeCk582FhS5pZ9
 jReT16Zh0YFVqyqtiuQHTOAt6+/8UUdjZdcD8hdzlo+8Stdm4xPxw9hwp8y45hTvxKSV2oI0vgF
 doGG4GCAQ7VwzJrAh2qSd376fT9wse+JebQPrZrZqEMmILhaPE/KB9oLrzH6HBUxsClq76t9h4j
 0/9vVc1fv6l64rJeV5mV2kOTb8ST7MkNtqag5I1NWXFKq47lTKyhwFcP95gzR1APcO63Tf8ENf4
 iGrnH2d7/RCHnAXTC8p91ik7AigfnXxTNBM6Nqbg=
X-Authority-Analysis: v=2.4 cv=f+RFxeyM c=1 sm=1 tr=0 ts=69b1bcc9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=QyXUC8HyAAAA:8
 a=4Ue4PALuTl8keY47RncA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12270
X-Proofpoint-GUID: d9n-OggB8Qyx9aVYSHD8a2YH4bAml8FU
X-Proofpoint-ORIG-GUID: d9n-OggB8Qyx9aVYSHD8a2YH4bAml8FU
X-Rspam-User: 
X-Rspamd-Queue-Id: 66582C0017
X-Rspamd-Server: rspam08
X-Stat-Signature: 7yah49y1gedhcjhzwsr8diezr9d86sju
X-HE-Tag: 1773255921-526352
X-HE-Meta: U2FsdGVkX1+9iv81TKyipBOre94nkO2Xw/2P4MeTnjpskbtlbjBF/gprYvhXeS2uwxlwcY/zown+EckktSJrDYFAZb68hRkO3CjC8lK83vPdwLCEywQHK81RrAMfjPZtDxSPT6Bc/GSpoXqxoDJ5HCKJjN7gp66h9NpkYKtU7E3SZjq34YsybXdKjHfdR6LoTE0u/nnoDZH97ndxLP/alEoL0anbASCJnayv4u+nmkQkWPcwMc6HhyT3UolQoiYPFSBbFEeOHS3v6IOxe173pBsjqAskmwOMVgQ8YbO3CsRL5u8Q6Nuxi9gQkR/mqbzfMKqs2jujA7WUCx7o2Ga4BkqwMh4MoJXNCRSRKMO1hxeYDunnjYtZQsmhXphqr7giji508cdyNGUVpCTqkMu+3dNkdYehkIZCrmFR5fpLNw+/80IQtQbCyNDdN8QCF7YeBh/x6mVMMofOT/7O83cZ1q7G/CF4JlbkNzPjwLo3cM7ZbyNFXwj5lymt1p5syjULZX6f4YJDkd6Gr4BwGP9F8FJuOehLZqhbJg/nJ52O/c5BDiKXJq2TbU49L3nns4cTqRsDa+d04kJuYYRQ+YEFyhTGTxy+YSe6X0V2VVEJlSf00lQnxHKv0VkpqgT5OCWAwByRDrF96Qf+Llw8GNY1Qqpp3JE6b8REdBKQ1K/MqqpNlUuPtl14QmLd1mwwdqlEcZII/t2+xQzq+vBG71IK4w9fSRgTIQU8gbxtYBWjZVlTae5ivFoSff3h8pvPRZIPksPGlxJHHm18cFlpUibYYmgi2EDd4/ClFVB7WHJVWj78EZpTIi1H8ZugG/euOAzDySk5ADqmhmvQJn1Np/u5blloE5Nq0i9uItYpCnjCweIheNkyuPJ2H9FaxwcnQ2oPUc8YJfAIeXupbh82blZUefBGJegNbx3EzIVZsrwrNj+rLOvwgiYrOMPDHCdFd126X0fiOHIlaaG8q8W2Dy/
 DLEMIe9w
 0FkKgVFeG42onzYLvqogSCwGwJMQK6dlhns8idN++cOZS+64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


kernel test robot <oliver.sang@intel.com> writes:

> Hello,
>
> kernel test robot noticed a 3.8% regression of vm-scalability.throughput =
on:
>

[ ... ]

> testcase: vm-scalability
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @=
 2.90GHz (Cooper Lake) with 192G memory
> parameters:
>
> 	runtime: 300s
> 	size: 8T
> 	test: anon-w-seq-mt
> 	cpufreq_governor: performance

This test exercises the THP sequential zeroing path.

>      15142            -4.2%      14512        vm-scalability.time.system_=
time
>      16939            +6.1%      17975        vm-scalability.time.user_ti=
me

stime drops because folio_zero_user() is more efficient. But utime goes
up because of higher user miss rate since folio_zero_user() is now clearing
sequentially instead of the earlier left right fashion:

>      61.69            +9.8       71.51        perf-stat.i.cache-miss-rate=
%
>  6.147e+08           +10.7%  6.805e+08        perf-stat.i.cache-misses
>  9.904e+08            -4.7%  9.436e+08        perf-stat.i.cache-reference=
s
>       2.17            +8.2%       2.35        perf-stat.i.cpi


I had noted similar behaviour with anon-w-seq-hugetlb in 93552c9a3350:

   vm-scalability/anon-w-seq-hugetlb: this workload runs with 384 processes
   (one for each CPU) each zeroing anonymously mapped hugetlb memory which
   is then accessed sequentially.

                            stime                utime

   discontiguous-page      1739.93 ( +- 6.15% )  1016.61 ( +- 4.75% )
   contiguous-page         1853.70 ( +- 2.51% )  1187.13 ( +- 3.50% )
   batched-pages           1756.75 ( +- 2.98% )  1133.32 ( +- 4.89% )
   neighbourhood-last      1725.18 ( +- 4.59% )  1123.78 ( +- 7.38% )

  Both stime and utime largely respond somewhat expectedly. There is a
  fair amount of run to run variation but the general trend is that the
  stime drops and utime increases. There are a few oddities, like
  contiguous-page performing very differently from batched-pages.

  As such this is likely an uncommon pattern where we saturate the memory
  bandwidth (since all CPUs are running the test) and at the same time
  are cache constrained because we access the entire region.


Ankur

> cb431accb36e51b6 9890ecab6ad9c0d3d342469f3b6
> ---------------- ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>       0.08 =C2=B1  3%      +8.7%       0.09 =C2=B1  3%  vm-scalability.fr=
ee_time
>     357969            -6.6%     334511        vm-scalability.median
>  1.034e+08            -3.8%   99382138        vm-scalability.throughput
>     634243           -13.6%     548120 =C2=B1  6%  vm-scalability.time.in=
voluntary_context_switches
>   12706518            -6.6%   11872543        vm-scalability.time.minor_p=
age_faults
>      15142            -4.2%      14512        vm-scalability.time.system_=
time
>      16939            +6.1%      17975        vm-scalability.time.user_ti=
me
>     251227            -6.8%     234071        vm-scalability.time.volunta=
ry_context_switches
>  1.791e+10            -6.6%  1.674e+10        vm-scalability.workload
>       0.30            -7.5%       0.28        turbostat.IPC
>       9203            -5.5%       8693        vmstat.system.cs
>       0.08            +0.0        0.08        mpstat.cpu.all.soft%
>      25.14            +1.5       26.62        mpstat.cpu.all.usr%
>       3.13           +18.3%       3.71        perf-stat.i.MPKI
>   6.22e+10            -6.6%   5.81e+10        perf-stat.i.branch-instruct=
ions
>      61.69            +9.8       71.51        perf-stat.i.cache-miss-rate=
%
>  6.147e+08           +10.7%  6.805e+08        perf-stat.i.cache-misses
>  9.904e+08            -4.7%  9.436e+08        perf-stat.i.cache-reference=
s
>       9303            -5.2%       8823        perf-stat.i.context-switche=
s
>       2.17            +8.2%       2.35        perf-stat.i.cpi
>     598.97            -4.6%     571.28        perf-stat.i.cpu-migrations
>   1.95e+11            -6.6%  1.822e+11        perf-stat.i.instructions
>       0.47            -7.2%       0.43        perf-stat.i.ipc
>      43153            -6.5%      40334        perf-stat.i.minor-faults
>      43153            -6.5%      40335        perf-stat.i.page-faults
>       3.16           +18.5%       3.74        perf-stat.overall.MPKI
>       0.02            +0.0        0.03        perf-stat.overall.branch-mi=
ss-rate%
>      62.11           +10.1       72.19        perf-stat.overall.cache-mis=
s-rate%
>       2.19            +8.3%       2.37        perf-stat.overall.cpi
>     692.89            -8.6%     633.07        perf-stat.overall.cycles-be=
tween-cache-misses
>       0.46            -7.6%       0.42        perf-stat.overall.ipc
>  6.121e+10            -6.8%  5.705e+10        perf-stat.ps.branch-instruc=
tions
>  6.054e+08           +10.5%  6.689e+08        perf-stat.ps.cache-misses
>  9.747e+08            -4.9%  9.266e+08        perf-stat.ps.cache-referenc=
es
>       9124            -5.6%       8613        perf-stat.ps.context-switch=
es
>     583.66            -4.9%     555.21        perf-stat.ps.cpu-migrations
>  1.919e+11            -6.8%  1.789e+11        perf-stat.ps.instructions
>      42389            -6.7%      39549        perf-stat.ps.minor-faults
>      42389            -6.7%      39549        perf-stat.ps.page-faults
>  5.812e+13            -6.5%  5.434e+13        perf-stat.total.instruction=
s
>      40.26           -40.3        0.00        perf-profile.calltrace.cycl=
es-pp.clear_subpage.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_=
anonymous_page.__handle_mm_fault
>      40.76            -2.1       38.66        perf-profile.calltrace.cycl=
es-pp.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page=
.__handle_mm_fault.handle_mm_fault
>      42.59            -2.0       40.61        perf-profile.calltrace.cycl=
es-pp.asm_exc_page_fault.do_access
>      42.54            -2.0       40.57        perf-profile.calltrace.cycl=
es-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.do_access
>      42.54            -2.0       40.57        perf-profile.calltrace.cycl=
es-pp.exc_page_fault.asm_exc_page_fault.do_access
>      42.40            -2.0       40.43        perf-profile.calltrace.cycl=
es-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.=
do_access
>      42.32            -2.0       40.36        perf-profile.calltrace.cycl=
es-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.a=
sm_exc_page_fault
>      42.23            -2.0       40.27        perf-profile.calltrace.cycl=
es-pp.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_use=
r_addr_fault.exc_page_fault
>      41.70            -2.0       39.74        perf-profile.calltrace.cycl=
es-pp.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fau=
lt.handle_mm_fault.do_user_addr_fault
>       0.76            -0.0        0.72        perf-profile.calltrace.cycl=
es-pp.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymo=
us_page.__handle_mm_fault.handle_mm_fault
>       0.72            -0.0        0.68        perf-profile.calltrace.cycl=
es-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.v=
ma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page
>       0.67            -0.0        0.64        perf-profile.calltrace.cycl=
es-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.v=
ma_alloc_folio_noprof.vma_alloc_anon_folio_pmd
>       0.72            -0.0        0.69        perf-profile.calltrace.cycl=
es-pp.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do=
_huge_pmd_anonymous_page.__handle_mm_fault
>       0.56            -0.0        0.54        perf-profile.calltrace.cycl=
es-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.allo=
c_pages_mpol.vma_alloc_folio_noprof
>       0.00            +0.8        0.76 =C2=B1  2%  perf-profile.calltrace=
.cycles-pp.asm_sysvec_apic_timer_interrupt.folio_zero_user.vma_alloc_anon_f=
olio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
>      30.25            +1.2       31.46        perf-profile.calltrace.cycl=
es-pp.do_rw_once
>      40.49           -40.5        0.00        perf-profile.children.cycle=
s-pp.clear_subpage
>      42.61            -2.0       40.63        perf-profile.children.cycle=
s-pp.asm_exc_page_fault
>      42.55            -2.0       40.58        perf-profile.children.cycle=
s-pp.exc_page_fault
>      42.54            -2.0       40.57        perf-profile.children.cycle=
s-pp.do_user_addr_fault
>      42.40            -2.0       40.43        perf-profile.children.cycle=
s-pp.handle_mm_fault
>      42.33            -2.0       40.36        perf-profile.children.cycle=
s-pp.__handle_mm_fault
>      42.23            -2.0       40.27        perf-profile.children.cycle=
s-pp.__do_huge_pmd_anonymous_page
>      41.70            -2.0       39.74        perf-profile.children.cycle=
s-pp.vma_alloc_anon_folio_pmd
>      40.83            -1.9       38.92        perf-profile.children.cycle=
s-pp.folio_zero_user
>      63.93            -1.2       62.77        perf-profile.children.cycle=
s-pp.do_access
>       0.95            -0.0        0.91        perf-profile.children.cycle=
s-pp.__alloc_frozen_pages_noprof
>       0.78            -0.0        0.74        perf-profile.children.cycle=
s-pp.vma_alloc_folio_noprof
>       0.95            -0.0        0.92        perf-profile.children.cycle=
s-pp.alloc_pages_mpol
>       0.79            -0.0        0.76        perf-profile.children.cycle=
s-pp.get_page_from_freelist
>       0.63            -0.0        0.60        perf-profile.children.cycle=
s-pp.prep_new_page
>      40.31            +2.5       42.80        perf-profile.children.cycle=
s-pp.do_rw_once
>      39.77           -39.8        0.00        perf-profile.self.cycles-pp=
.clear_subpage
>       9.54            -0.3        9.23        perf-profile.self.cycles-pp=
.do_access
>       0.55            -0.0        0.53        perf-profile.self.cycles-pp=
.prep_new_page
>      38.35            +2.6       40.96        perf-profile.self.cycles-pp=
.do_rw_once
>       0.36 =C2=B1  2%     +38.0       38.32        perf-profile.self.cycl=
es-pp.folio_zero_user
>
>
>
>
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are prov=
ided
> for informational purposes only. Any difference in system hardware or sof=
tware
> design or configuration may affect actual performance.

