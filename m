Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358C8C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26528E0041; Thu, 24 Jul 2025 01:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7288E0002; Thu, 24 Jul 2025 01:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9772F8E0041; Thu, 24 Jul 2025 01:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8424A8E0002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:13:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44AE71119AC
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:13:52 +0000 (UTC)
X-FDA: 83697991104.05.BF8B3A7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 08B641C0008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:13:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=boQFFCIU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g+CjIYZi;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753334029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tm5sRUKNKcgqMouXQ3EH1xhGvfaryCLw87u/hkzof0=;
	b=JPel1N53tE3/XkZCi3iIfup9lAsowVfc5odbCTUhH3An2aRe8ghelQG5bjtmU+M+/NmcV4
	5um9ypVOXgN1wO/ooMW/+AQPEULzH2y2F6bicER03j1gatQFwsQsyMoFsvPoHjo5F0aSpR
	L9QTh7mHQxAAcV67aN+98SUKxY+IcZk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753334029; a=rsa-sha256;
	cv=pass;
	b=hBXgru/kocCJUMH6hU6XB53Y+wVR1vIsSQ13i7nBKZRkM36eqiE8ayH1ZJypKC6BGOx2Iu
	LRFBMRVh4gLW8REo9MpUezTwD1l+UqiVnGHDb6grVSxYp/LMUwZ+ryEveMgTeLdn+sUVyU
	w4IsWmEZdUBv5AO0Z0Lnp1ACShv8uaM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=boQFFCIU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g+CjIYZi;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NLQwLh026822;
	Thu, 24 Jul 2025 05:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7tm5sRUKNKcgqMouXQ3EH1xhGvfaryCLw87u/hkzof0=; b=
	boQFFCIUy7ixggii1UhPbw+zu6YXabzVOI4Z0IQ++Fx0x69Y2+Lo8/yICdo9ByT7
	VlTD8qgABBQn60s+YUytSYKWUVnb7aWJyLgW4yr881FDHDPaQY5Js0G2q5rKumeG
	FXYNgLoosDjFAPO/YP+y+mejQS9vPP6nzdNWIZUf1CkzQxyTzmVB/+X5cnQNm4r1
	YIiUvCf7VoBfb7AjqRd9qMZZlldBIc3C+JTHZ7YG1LVNw9ELEZI/kp058oQHcy7j
	WfIMj1+X8htMBzzQkqt/p1TQ+xGVtJQRFCAsPRK7ZTA+Va93l3QM5/SmNRrH10Qp
	sXP5DmAdGHDW/ojM6FaT+A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhub6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 05:13:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56O4EjgY010405;
	Thu, 24 Jul 2025 05:13:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tbdq01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 05:13:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kjd+FDnG5+21ds1hr39+pAs4G+aJO1d7rIpO8uYAxOrQKKB/s/uH9tJS04klho2zw6gsCmqf3ASJFcUfdTR11p4434ec58BmUWWuVQysfQ0AIgk0yHYarxE3QKs3jgkO7WBX5s8FmbJIcwKPg5orJniMMbHWiUHo9WuJ+z/JZPc6lana7w0xOS2Q+h9KHoi9kMGKIfdaXakPB3XI0R921V9WnIgZq3VEl64kb63WS5kugxokf02njUwo7HpQeIK82mZ1Ov9YyxykkWjIc4MwbhrxrlCxb+xCWP0xiMWhcBQRQH7dvMEed86psLy2+MXeGYgtUh+tpx799XG/5jLNlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tm5sRUKNKcgqMouXQ3EH1xhGvfaryCLw87u/hkzof0=;
 b=B8UDkSMubbSxDITMYAtDIk3xYAyo9DouGiNT4PgOlR1+tKveUNVkgXJu2OOHrgNO7/LVWiP61wW0I8ZWelySyKT+1u+1jYTtA0JAnj8Hq7Y+qDk45v3dlvz8X4lxlqDJcAc7C0AoNSM+f4Zg6J7w9m4AXitj4+o+yvpFxQK7vx/NwIHhDbboga+Q8vUQcumYBN7fcNcv3PShfEFPCskbW2YTiEfellM7YFe1YeCk+0pBePEN7KBQQG48dIvhbag8jkkXJw8lWqiv2qi5N59GKpyui2AWwhCVCSu1gjbbFf7MVs8WcwNfBspex0HAhvf2yJ5+2Snw/A6UuQOu9s+6Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tm5sRUKNKcgqMouXQ3EH1xhGvfaryCLw87u/hkzof0=;
 b=g+CjIYZiLhYumCy/Ax8DB+mAzoeCIIJDWGTdc5lpq/WXWpFuU1xHwBB7jnzA2k+qY5CTs0c+ZtVywb5I8xxz50+5K/N1gi44445e8TiNkFu9FUIW2GAQQT1tjWVYCpCwm8xbms/HRDA+l55kQh6+s29W3S45b6xwU7MEqQZgKIk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5673.namprd10.prod.outlook.com (2603:10b6:510:125::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.42; Thu, 24 Jul
 2025 05:13:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 05:13:41 +0000
Date: Thu, 24 Jul 2025 06:13:39 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Message-ID: <b798c84e-f3fd-486d-ad70-c827385a558a@lucifer.local>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <6df9812c-96a5-41be-8b0e-5fff95ec757c@lucifer.local>
 <CAG48ez1A17JC7Q35jmurY+Co0t_a78bPy9eRWRim7xJy9oLCvA@mail.gmail.com>
 <3a233a85-3a94-422e-87be-591f93acbac7@lucifer.local>
 <CAG48ez36AcGBy8_wo09WEHz98Dp44yKZ_FiVtFt8tcV9WiHafA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez36AcGBy8_wo09WEHz98Dp44yKZ_FiVtFt8tcV9WiHafA@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0315.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a6e4c9-4bcd-4ad2-977c-08ddca70dabf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alA1T29WQkMyWDljVkl0MCtCMGNHY1ZHTEUyUTZLdGtPN0RKTGlOeXppYmZr?=
 =?utf-8?B?bmFqcU15MGlRRjYwek1Mek56dElPYk05ekVTNGc4SHE2czBtZDhXcFZHM1NH?=
 =?utf-8?B?VU5SUmJDOXlocVpreXRtcTY3bU1xMURvTHBtNElVSjBNU0dHWVBnbHFsV1BV?=
 =?utf-8?B?SStlU0dpQndMMFFQaWYySUNvZ3Fmc0xMTnZ1UzJVR0lleVBkakdYTmo2MGwy?=
 =?utf-8?B?NzhNVEJkZHdwVlVRSWI4TGlJUVhmcGZyWk1oZ2hEUFRIaEUyaEg1Z01qREdY?=
 =?utf-8?B?VHZqeE41eFRoYkNKbXJ0RFN5eDRTOGpMZnVmT1dGTWhoVndZWEhkOVZaMFJ1?=
 =?utf-8?B?Si8raGs5OGJIR0NEbjhBZzVDNDU4OFpBTWtRL0lPd3NJZXNZcENsNjBhbnQ1?=
 =?utf-8?B?dnRUOStvRVcwWWxDb0kzWFR6UGpYVXAveGp2K2dVdzN1TUE2MGQwZ3h1Y3ZI?=
 =?utf-8?B?cHNtN2pQTkIybjNZZVdCWWJXMWpjNlVKcFNUV1FTK3BQbkNLY2p2NkFqMHBU?=
 =?utf-8?B?SGFqR2dYempLQWNiaGpDTmd4Zjlqd1JnYmtWNjg5a2IyRlRMTUw0ek5BYWpB?=
 =?utf-8?B?ditwQW5GNkg1VEJWYlloQWRtVW9pdk9NaFFWVjF5YlZjZjZuZTFKaFBmajNI?=
 =?utf-8?B?cktEUlpLcGkxb0VOT0hPZHhoWTRoRm04UlBUanVPWHlGVlZtOUx1U0czandT?=
 =?utf-8?B?aXF5ZjNxa1VpTjJkOSs3LytsdGUwakkyUXJ3VnhCcCsybGFOMmk4dWxxcDA0?=
 =?utf-8?B?eTdOaUloTEtoVXJQc3J0NVl5dDZEYnQvbmNzS3Yxd1FJVmlyUE1nbm50dDY0?=
 =?utf-8?B?dkxuenBUbUlkSDNQeStWcE5MODlLS016Z0Y2MU4rL2xZSWQvSU1hOU1nam8y?=
 =?utf-8?B?OFE4WE5KejVZWHg2TG9PZWhxWjJ4Q1pERFgwQi80SFVQWDFZZWIvUzdUQzBJ?=
 =?utf-8?B?ekZsSE14emsyMks3YXAzczROV3p5Z1IzVGNueDFuQVRmWFhDT1dZdW5UMGlW?=
 =?utf-8?B?bUpHOXdrWUlkSnVLZDZqNVhNYkxqL25uNHdGR1pSMk9EUWdXa0VPNkNVbU82?=
 =?utf-8?B?MDRxci9Fcmg0SXY2WVc1ZnBUSG41NkNqSTJzS0pyUitnMkRLTG9lZHJjY3py?=
 =?utf-8?B?ZGtrOWFJYmc3cjdnMlpZdStuT3lTTHgxQlhkMjRFZXRRUnVFemxUNXVLbzVm?=
 =?utf-8?B?d2kyZUZtMlJpQlNueFBONWU0QmxuczBUbDY5WXdZMG9QT3oydm55dWRyWFBL?=
 =?utf-8?B?aEREbDFkRndqNVBmekNLYXZra3FsOGdzd0tmVlJnR3RESW96b2FBaFZDalZs?=
 =?utf-8?B?ZXVXb3FqbzEyTlRWamZYd3VVNnVRQ2hWVVpRd0xua1dBb25mSlYwaDZuNWlR?=
 =?utf-8?B?S2JpbTVMTnRxZFd3UGZYQStPOWd6L1RmRlpOczBkYlBNalJscjVRNEI5dkVu?=
 =?utf-8?B?WWo5eTBZRFg2Wi95cjJXU0FLOVdRYldSclV2cmxDQnlSTStjN1VwOFZ5cGlG?=
 =?utf-8?B?ei9yQjJDcWtCWEQ5cUplOG1GaUpJcDUzS05HelFrRlBUcXVrc0p6YnIydkM4?=
 =?utf-8?B?NjNvS01uVUx0WHd1ZWFUVGJXTUpUdUlFclFEVVBDU1BwUFdYQ2xqekRUWEk3?=
 =?utf-8?B?NkcxNk1iTzlOTnJCbDBmM1lHRVRVb3Q1U3hXQ2daRTZDM1hwc0xLNFJ3Rzdt?=
 =?utf-8?B?WDR5dnE4QmdSSEpvRDRiZ3BIaDE3LzlpMEJjVFJqWlpOSlVqMEw0N3lQbUtr?=
 =?utf-8?B?cXVXMXN5SllOb0tKd2NvVnA4UE9sRWhBUmpGY3JGL25xUFo1U21GY29tMTMr?=
 =?utf-8?B?MWFHTU9ydHd0T1k0bzhXaHliTVBKZ2RuK2FmaVZPM2NXb3VpVGxVY1M2emlj?=
 =?utf-8?B?TWtBbjFkREN6UFgrSlNHTVhzcFdqSE9ZNEs3d2YrYkpwWEYwVEF5a2xWMDk3?=
 =?utf-8?Q?Sj+1IaHxCSA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VE9yOGxHSnZlSitJSU9aa254MzMxYjQrRVlINGMrb2JWakZXSUd0ZncvQzda?=
 =?utf-8?B?VThubmpzWlVZWEt0aDY1T0FQQXhJQmhNZHdzd2czNlNXSUtiZzBQeHRVQUg1?=
 =?utf-8?B?SlBmTkgxcVQyQnBDeEFXM1V2Y21BNnVnOUtxMVFuNzQ4TEFIY0hzVndWRm80?=
 =?utf-8?B?MmhxTTBCVGUzRjY4a0VSSkJnYUJsYVpsdUE5TVFIZ0krdHp6MkhFQ21iaUlO?=
 =?utf-8?B?cVlLQVMwWmxmQU1KODhTZmx5dytqQVo1ZU5rMmlnV0ljMTdYUXFaWjJJMGNM?=
 =?utf-8?B?YUxiekRqWHE5YVkxRFhoOFdhZ2RSN1ZXTkcxK0ZuZjJ5WXZQZnZBd3JsY1RT?=
 =?utf-8?B?RU93LzdoNmVORDRnUW1hUFJWZ1V4em1yUktyZit2c21lZ0pHMUU0M3JaS1RE?=
 =?utf-8?B?Z3dTMWZFVGdPUzVGSkIwSTNBMTFTb1hraVpSc05rQUlDdmg0RG1LcHBtRzhT?=
 =?utf-8?B?OVQ2eFZhcjJCZ01xOERhUUIxbXQ2UlRxa041bUtBR213YlFrY0x6MVYrMnBy?=
 =?utf-8?B?MVhHU043Nm5WSitjdXpITXlDd2o0UXV6OE1KSzVmYlRpbmxlMDRtcmhGV3hE?=
 =?utf-8?B?ODhDWkU3SzdnVEFYUGlVUjBqVkpsR3Z5d3VLazRhSlRDSEc0ZGlpNnVFdC91?=
 =?utf-8?B?cmMxam5jVC9vVlFacWFFVE42aUh6ekVKVUM2RGJUaFRja0lyczc1NVdDdVdn?=
 =?utf-8?B?SU5vTGI2emNlbm84bGs1NlcyeE5aeTIzNytEUHVKZEU5Ky8zdUFwNXJjLzVR?=
 =?utf-8?B?aWdqdmxlMmpQMHllK0hRTkFoUWtvR0hxcE4wUndzNUxNS1FZeFMxbFR1QTVs?=
 =?utf-8?B?OEVIKzU2dy82RHJSVXloamxXcTJ0elU4ZXo1QU5XTm00UHVMTnRDbzF3Vmh0?=
 =?utf-8?B?T1hEVGNKcC9iaWhoVXIrUnVuSG1DajFIamlmZUxtNTJ6M21UUGhTZnpvdHg1?=
 =?utf-8?B?REpSdzVtdXhsZ1N6SDZkQmJpWDNLWGJSTUZDQkFROUJqK0w1Ym01elZRbm1v?=
 =?utf-8?B?anF0SkVlejVlMzM2VnhyRTFZWGNJU3kxZVl5UzdxTnZrU3FTR3dVQmV1RUNz?=
 =?utf-8?B?VVNaclVGVG9jUGgxT1NxS0gyM3BFY3ZwNkVtYWNxNysxWlREcXRSMmRKQy9r?=
 =?utf-8?B?Y0ZWZHhSaWxseDh3NkxQQW1oL3UzZWJ2dkM3Yld1Z1dwY0NFR0VDS3RxMGVD?=
 =?utf-8?B?bUwzZ2NLNFhzaHk5Rkh3d3V1ZnJHVndUcHlBMThKZGZOV1VJc1c2a1lRTUtY?=
 =?utf-8?B?UVhIam54bHY2VmdOcE9XVy8xelFBRUg2WVB6S1hMTDB3YVJ0bitYY1dxTmI5?=
 =?utf-8?B?STZIUmUxVG15WUxGMHJLMDgxOHlRSDNlNmxEeTRaZUtra0dUdFF0QWFEM2xS?=
 =?utf-8?B?RzIydTZydkZvZ29oa2VQSHlDbHdOSDNrV2NLenBpU3BLTTBDMkVYWWIreDNq?=
 =?utf-8?B?Ris5MTBlc0E0a1FScWlISlRFSmhQQ0FkOXYxRlQzQk1QV25ub0Q1dmYzbkR2?=
 =?utf-8?B?b0kwd2xkZ3AxV1NSSDNmOE0yYTVjWVJVRDFiUURxVTlodkpGdGtEaGlkSGE5?=
 =?utf-8?B?OFp3QlVOQ3h5UXN2MC84blBNV0JUQTRGYnIycFlidUV2QUZERHJiYXU3TlRP?=
 =?utf-8?B?NjB1Wjc1OEpSN3daWWJBZENRckdUU2FiZzdjbFg5WXFpK2tUSk1JVTFBSVdv?=
 =?utf-8?B?TW9VdFNrNTkyQkVoTnpFMHgwSDlXdTQ5RVlTNDRVb3hpc3IxMnZoUGI3Ritm?=
 =?utf-8?B?c1VkWkJlemFZeTVGbjgyVEE1QzZLZTZNVC9JM0UrUmlzcGtYN0RGRlZ0KzZP?=
 =?utf-8?B?M1o0QVJTcnU4MkVWdlRjRGNXOUZPV1J6V0FzU3JrLzlDV2R0SVFqMTRRSTJZ?=
 =?utf-8?B?LzU5dlpRa1Jmd3FjNDNScFdMajE0UDNSaDRXdlI4Ylp3dE1kT0VjQzl2c2pO?=
 =?utf-8?B?TmNwcFhOeExIRy9oTEt1cTBZZ0E5SUhNem1PV09WRVZaWDhFcE9LVGdlbmY1?=
 =?utf-8?B?R3BCcGxmeVZuNis1Q3JCTzVNTVAvbzRLSjNqWEpvTlN5U0ZtaStyL080L3Fr?=
 =?utf-8?B?VFZYZVQ1WlJCLy90aUwxTnJRRWxiUXFGL2JJV2ZzdldmYklSMlBLUUUyUGFK?=
 =?utf-8?B?dlYwRGRaRXpucWtFejY2VVBCdHo4ZXRzQVByTjBJR3FCMlBYVnFDZ1FqTTFr?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IZghH5kN5UFET0FmxDhDZtr5HzVi5w3KYx/6gM5yUIwWcTOC5pW4xdsVvEadgyhsjK7hJ4egsxxt0glLdRCoEue0vt2bfDtjiTUKzcbEOwgI0vQADI9D1FA4kYkh+8vjlz7+XezReObZGr7BKodDg1nLrgcaxRGai1OvQAjhJPTpYZgQ1RjSdft7JtpognLARjTd1sxAvpDjsoIj+f5YpQ+iJTtpNVfRnjfRO3yS51iRJc3/1sFeLEQHSuKyUlHD1sjX+rs+eOlzF95eTQ2TqPVwuj781mhV2jLKVEXFKZWRP6EDEpw2IeXgbTRh52DAxWJBePuGDvdG2VM/v8yVMyQ44/vZTQowIwcLK6v33Kb3OPqRWlJltB/jCj1wRRGU5uvxviZ5Jq64gMPEXL7fPEUniO9Fb/C3KHSYp7PU9meZvd0YfWsQRnO9QRWdC/V6vFa7jznzKcy88xvaDVuUwA6tOXKNG+iN7f5K+ow29F+QQcB5MdgKADZMSErac+g+KOdJbOwc7Hk9tTJxWfkxDWUO6bWxddOK9+eEcynjVRRl/QQkamLoSFoL530mytqO3XzGEtIsVk+juSBvs2JcZLYQWTVu7TLfp4qVjoesAhs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a6e4c9-4bcd-4ad2-977c-08ddca70dabf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 05:13:41.2331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Owk3xQqI7G67q0S37iavs837et8TWNvSPVefem46kq12B6ifOc01Y8GP9YZrHeEOLYi4VeuOF1mgcOrC16OdbH1foDSkYpIZNybuekP+UU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240032
X-Proofpoint-GUID: 4nm1rxqt7bUeXZ4COBf9yDrHlUQxjzPn
X-Proofpoint-ORIG-GUID: 4nm1rxqt7bUeXZ4COBf9yDrHlUQxjzPn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDAzMSBTYWx0ZWRfX8Ax5wBtLllCh
 gIwJSFsw+pGGMnCRHhzIZ7Dazh7/GGJhI3S/BOaAuumM1JqMIi5ozU88REwKZK8Oew2Y7lcs6jF
 0mH3ZutjRJYB9CWmBUl+r12MJ5R+UvsHf4dh6fMi7V2jAlPCTPiFIkiik/K0+Lgx0zTBX5KzYwC
 aFD6hsDcRs4B7rpk3eszHTSuvNAMuvjcAbHyZRqiUy26ew8reiJcBUAKlnWb8hJae9E/x9ocGJe
 KvK/tp1CHLTarnV2iDvumDyJ/NlghvWOx+oTZBQAEz/QMOXNSA37KV/y1ICdq42HfEWYVobDzWl
 jKVkM4xE/UX3Wriaqt27vSa2KD9KaQZujNdgYBPcM1un75xUFDReuG0IDISG9DCff2NS/31NjUJ
 3nItRnEDP+h0xZSwVAaURlhBj6pFX9VJrJCPdPS9xiQV72O/ZQxa3HxUgYBBbeSQx3SGW9Xf
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=6881c10a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=7yn845ouWORMtootedAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: 08B641C0008
X-Stat-Signature: 94f7aww9kh5ujjyfyxjjtqj4gjyxcf3e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753334028-909768
X-HE-Meta: U2FsdGVkX19LXYvtR6S9CWJeTqDVrAI+X/I7p5OK848vG4SwRx2p2gAa2kWlwHOn2Q3HyC6Uy41qadJxPVk08nerCWSh6P6hnaNlyWAzsvvHln8H5/FfbuswH4w88PuaCazKqrXm0AYjpobcYbTIgzzNvFZ4HCjsBzOLJ3fPL4RXFOgfXCy2ZVC8PM/pLNJ/D5en5b6SPbnU36DlOepImj+edcOMkfB2NPECWON3VsFtqok6pj21PrXSZwwBWg3J5hz7lonj2x+e3H4U6zhOYgDjlMvAhldWR2h9J9hyjr+FXqdqN3dukVB7rIPWaSYroWjogn4plA1h0hTRgnYgDCRBTRiY3VtbtsYL55yUZkkwVJnpyQR1BXs1dwyZAndZpK/QyHwoOPKnMZH4r1nJRVhG1UtgZ4vvB0+aqax70uzvFzEEBIjRy0QI9p5lAoAomz0dadaF4vHy0ZYsOGKRgfslsw2tjokb8s8Ey9iTVEypOazRc2P64f/NbnNEXoFLA2PPSu9pp6Z/7DqzW44G+ZEEoaWbE+mH40kI69lr78xnT2ztA83tfgyRhIgcuRnSOnauUHNZf7mW07a2WViSuxi95M8mWZs3vY/XgeYqtY7Uzqb12tIQEqzEYfW2PE4FwdOKvFzosgl8Wg2N32rZ9sRtX4m78CvVXrcCmG8npGBzK7wRbUhK7Fqdap6czL/CWeRDZW3cCOysMHRle5z91uLgxjgC1mZJ3Kc6XXn2v6wQj85PIRFFa8kDZhnYWFnqB46YbWe6hAMPWIzxQS09+CEh/qZun/A+D5mSpL7TsPoMUuKPRhvDv9s7vERaqXm8iTHF8AtgL0IRpIPW8ikVXDWrgioSBswR6nVf4hG57l0R+DDhbX61a2TybB2Wt/QDVBN8CMp6peaNFstLa8qtLUTwnz28/JEdtJ47uGVJdNQ7appUGhN/auwUaUUqfTmxLpfbk+DmorUb7Rq/L/k
 lJYpnhbT
 KHgVp208OqiYw5xilYu+orxTtdxm8xS8mjS+fIq54rDZyrRs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 09:43:35PM +0200, Jann Horn wrote:
> Sorry, while typing up this mail I realized I didn't have this stuff
> particularly straight in my head myself when writing my previous mails
> about this...
>
> On Wed, Jul 23, 2025 at 8:45 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Wed, Jul 23, 2025 at 08:30:30PM +0200, Jann Horn wrote:
> > > On Wed, Jul 23, 2025 at 8:14 PM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > > On Wed, Jul 23, 2025 at 06:26:53PM +0200, Jann Horn wrote:
> > > > > There's a racy UAF in `vma_refcount_put()` when called on the
> > > > > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > > > > without sufficient protection against concurrent object reuse:
> > > > >
> > > > > lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
> > > > > rcu_read_lock(). At that point, the VMA may be concurrently freed, and
> > > > > it can be recycled by another process. vma_start_read() then
> > > > > increments the vma->vm_refcnt (if it is in an acceptable range), and
> > > > > if this succeeds, vma_start_read() can return a reycled VMA. (As a
> > > > > sidenote, this goes against what the surrounding comments above
> > > > > vma_start_read() and in lock_vma_under_rcu() say - it would probably
> > > > > be cleaner to perform the vma->vm_mm check inside vma_start_read().)
> > > > >
> > > > > In this scenario where the VMA has been recycled, lock_vma_under_rcu()
> > > > > will then detect the mismatching ->vm_mm pointer and drop the VMA
> > > > > through vma_end_read(), which calls vma_refcount_put().
> > > >
> > > > So in _correctly_ identifying the recycling, we then hit a problem. Fun!
> > > >
> > > > > vma_refcount_put() does this:
> > > > >
> > > > > ```
> > > > > static inline void vma_refcount_put(struct vm_area_struct *vma)
> > > > > {
> > > > >         /* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> > > > >         struct mm_struct *mm = vma->vm_mm;
> > > >
> > > > Are we at a point where we _should_ be looking at a VMA with vma->vm_mm ==
> > > > current->mm here?
> > >
> > > Well, you _hope_ to be looking at a VMA with vma->vm_mm==current->mm,
> > > but if you lose a race it is intentional that you can end up with
> > > another MM's VMA here.

Right I get the SLAB_TYPESAFE_BY_RCU thing, what I'm saying overall is 'can we
detect that we lost the race by knowing what mm this should be'...

>
> (I forgot: The mm passed to lock_vma_under_rcu() is potentially
> different from current->mm if we're coming from uffd_mfill_lock(),
> which would be intentional and desired, but that's not relevant here.
> Sorry for making things more confusing.)

...and because of this, no we can't. I hate how uffd is implemented.

But even so, even if we could, it would SUCK as it would leave us with a
_requirement_ that this had to be current->mm or a race-recycled thing.

Stuff like mshare also wants to pull out assumptions about current->mm, so
we don't really want to be doing this anywhere even if we could.

So moot really.

>
> > > > Or can we not safely assume this?
> > >
> > > No.
> >
> > What code paths lead to vma_refcount_put() with a foreign mm?
>
> Calls to vma_refcount_put() from vma_start_read() or from
> lock_vma_under_rcu() can have an MM different from the mm that was
> passed to lock_vma_under_rcu().
>
> Basically, lock_vma_under_rcu() locklessly looks up a VMA in the maple
> tree of the provided MM; and so immediately after the maple tree
> lookup, before we grab any sort of reference on the VMA, the VMA can
> be freed, and reallocated by another process. If we then essentially
> read-lock this VMA which is used by another MM (by incrementing its
> refcount), waiters in that other MM might start waiting for us; and in
> that case, when we notice we got the wrong VMA and bail out, we have
> to wake those waiters up again after unlocking the VMA by dropping its
> refcount.

Thanks for the explanation but I _think_ I understood this bit, what I
meant was 'except for cases where slab recycled the VMA' :), as in
_intentionally_ vma->vm_mm != current->mm.

You've answered above re: uffd.

>
> > I mean maybe it's an unsafe assumption.
> >
> > I realise we are doing stuff for _reasons_, but I sort of HATE that we have
> > put ourselves in a position where we might always see a recycled VMA and
> > rely on a very very complicated seqnum-based locking mechanism to make sure
> > this doesn't happen.
>
> Yes, that is pretty much the definition of SLAB_TYPESAFE_BY_RCU. ^^
> You get higher data cache hit rates in exchange for complicated "grab
> some kinda stable object reference and then recheck if we got the
> right one" stuff, though it is less annoying when dealing with a
> normal refcount or spinlock or such rather than this kind of
> open-coded sleepable read-write semaphore.

Yes, and again I should have more closely scrutinised the original
series... or at least more closely _understood_ it. Entirely my fault,
though due to workload more than anything (hey guess I need to work some
more weekends :)

I understand we're doing this trade-off for a reason. But we're asking for
problems here.

>
> > It feels like we've made ourselves a challenging bed and uncomfy bed...
> >
> > >
> > > > Because if we can, can we not check for that here?
> > > >
> > > > Do we need to keep the old mm around to wake up waiters if we're happily
> > > > freeing it anyway?
> > >
> > > Well, we don't know if the MM has already been freed, or if it is
> > > still alive and well and has writers who are stuck waiting for our
> > > wakeup.
> >
> > But the mm we're talking about here is some recycled one from another
> > thread?
>
> The MM is not recycled, the VMA is recycled.

Yeah sorry it was late, this is what I meant.

VMA is recycled, so different mm.

>
> > Right so, we have:
> >
> > 'mm we meant to get' (which apparently can't be assumed to be current->mm)
> > 'mm we actually got' (which may or may not be freed at any time)
> >
> > The _meant to get_ one might have eternal waiters. Or might not even need
> > to be woken up.
> >
> > I don't see why keeping the 'actually got' one around really helps us? Am I
> > missing something?
>
> We basically have taken a read lock on a VMA that is part of the
> "actually got" MM, and so we may have caused writers from that MM to
> block and sleep, and since we did that we have to wake them back up
> and say "sorry, locked the wrong object, please continue".

OK I think this is the crux of it then, and what I've been missing here -
we have taken a read lock _by mistake_ in effect on the recycled mm, which
may end up to be a spurious one that we need to immediately drop, but
because of this we might have waiters that could wait forever.

OK I get it. But to safely reference the mm here we need to be assured it
stays around because in case of this not being true, we have nothing to
prevent that mm going away right?

