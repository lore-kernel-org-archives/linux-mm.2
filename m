Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6665CD8C94
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502498E0007; Thu, 13 Nov 2025 11:02:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA118E0002; Thu, 13 Nov 2025 11:02:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1C38E0007; Thu, 13 Nov 2025 11:02:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 257FD8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:02:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C50B614067E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:02:43 +0000 (UTC)
X-FDA: 84106051806.23.E552BB5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 406884002B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:02:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VcZIDrrd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=C9GaZ08+;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763049760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+SVSffNjWEZpsoBwDjT7Hu5EJbzqIlqvMkL/69YD5s=;
	b=SEF+ebRKeEVFJRhghy1eeV2WiyPJ0ZQ6VfjCSXy6ij59CoD/Lr+35TjLVea0FYk0yMVKH9
	tYEKCFlCFHSXEJn3al2a/XB/fz+aJIsSSBh8pFfLGBQ4fvIE6CmF1y92TbCj3KeOmKSdIi
	QIdIeTSaYuj9sZ+nvDEdAPcQzq3dYXo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763049760; a=rsa-sha256;
	cv=pass;
	b=HKAj0w71FqIf2zr0V7lCZhMXZmiXBXZCWaUnRR5HOS4vEnP9emsWsTxIAnZKCwOWv5Hlwb
	Z1X2s0jhr/KQFdWXK+DPkiup2fSorKuW21pQLKwb/zUMa/nVTGFYqzmgw89HTJnlOLCyy6
	X9AqRHRHRZ8XKgP32Iy4vGIp83GQcAM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VcZIDrrd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=C9GaZ08+;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADE9xnO005893;
	Thu, 13 Nov 2025 16:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=q+SVSffNjWEZpsoBwD
	jT7Hu5EJbzqIlqvMkL/69YD5s=; b=VcZIDrrd5lCMTM8g8U11a+gTJ1MtHjRkgp
	wV3YI9sbOrA4ku/YqElMyBJKg32wUy1SQqenB8xbU9eO0ueDBZRGPYVOfcHANwhA
	6mgfk74CVuikJPT9RALGmwBier3yoONzAH1FBZVjTv3qDPOVBJBQktWM9CXTNUBh
	HUtsJKb/UxAjyo9QWsJrOCU14oS6r8ip0PVnVsdRNgs3hWwx/h6la6OI4vwz4+Wx
	/jb1YoWKljdfNKF0cGc4cco5is2ly81FXq4TIAYJpSPGJYK9GHqCv9KbevtJmW+O
	f/QVz9zmrXt+INdoWMLZraFu+0q+DSnDx/HO/na+GLkYMPmESbPA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyraa26b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 16:02:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADEGTXd003143;
	Thu, 13 Nov 2025 16:02:22 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011004.outbound.protection.outlook.com [52.101.52.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vacu7t7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 16:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=laB1A5YZt5OZnGWpvyhcjqiQy65PPckXnxjXvrnoGtxWe21KlsScxulOyEbKWnYWfyAbxmtPeG8J4gci6GmRKCuCNfZNaLxG66jpQb2tIlbfT9pgxOiMMRqtI/yJAKPD4/gGNZ8ywBzY9oYcZq8Tw2v74XJM1/A3rAkmknIY/indyQJIr3vUwJwyfnONeoezr/K0KvTRxE8aGPjDBcnuqMceT+iV8Mt4dfh+vThp/k9rZisRenu2Lx+60ZkmN+bwuhUG+keiDfTHtuRkeJRNMsQYk74+J42rAb5uUkj0PXfc5lsmLpwVGmW4acmc2fhZHoCgCX+6qOOdpDsZ3z+tKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+SVSffNjWEZpsoBwDjT7Hu5EJbzqIlqvMkL/69YD5s=;
 b=O2uGMCXQvIJEV8yU8nlTLLWQlmV+tJNkvChFqHaIddSY8Ytw9mBb2zgk3TEeVxUg1CGoxwcXT86AcPZJlxDGX/qlWhHCjY2KK558gZc7MkekFFCvflHlpVyJh5uOfCJ6w4p92zys92czjnP0g1IzhwFbmAoCCEyU+O45N6+UUP2pYx49LVHqDZr9wZwmWK7uJPfsee733wkTBafT1tGRbk2/c5o/p7HIlysu8usdMTLRhqPxcKSICZxi1MRP1d2EL5y/oeXaaIdFZLYwjCT77QMGmIznwOqHKmTEdfvW6lwvm9N6koJ+dWHLop4Fds0nyDUGhbrohE1Q7jceZPihUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+SVSffNjWEZpsoBwDjT7Hu5EJbzqIlqvMkL/69YD5s=;
 b=C9GaZ08+m/dh4fTm9GskD5BY1gIMoutfcF/Icn+ISeedvEKSv55R4OR5E6c+czQXy5B0FIqTXpidA7UqjRZNF9M4p93ByZyyLlgUnHMPjuoJ2em9TjWATGW9IrNxRdJI2JbmhaYep0koP9remHsoPdk8SdbMVEtpmeqL3mOasuk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4266.namprd10.prod.outlook.com (2603:10b6:5:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 16:02:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 16:02:17 +0000
Date: Thu, 13 Nov 2025 16:02:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Francois Dugast <francois.dugast@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Oscar Salvador <osalvador@suse.de>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>,
        Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
Message-ID: <8ffcbd7a-511e-499b-919d-0c56ccc3c63b@lucifer.local>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <aRX62SR8NLps2NWH@fdugast-desk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRX62SR8NLps2NWH@fdugast-desk>
X-ClientProxiedBy: LO4P123CA0138.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4266:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c0f51b5-c882-40f8-ffa7-08de22ce0503
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2KPFOTJ28PratNQ+LCbEJw2pMt+j/vPBFVAX2Ej13OouEfafvbX4P+gaTkHC?=
 =?us-ascii?Q?rtHmQUGMhgZWbvYweY+R/BpIr4+hvuRyhITGSLt7oSEhk38LWbYoHBJB3frg?=
 =?us-ascii?Q?OEASfGtxdLU3I/w2Z7i9/0bdprtEsuJI+W9i1Up0axcCt4tDfFgrcYJUIp6R?=
 =?us-ascii?Q?sgCYwVc8eQPllyvAMRhiEOAidzHijxb7J6Fb8IQLlrqlbvcaspxKs5QNnpmc?=
 =?us-ascii?Q?YuyQA7gXiYalYQsQIpfnOzANsBs4SYOchJG6LA4FrbXfuCa6ln1zjID1FgeU?=
 =?us-ascii?Q?4j0l921Hokf6H5akhswW/rGy9eDpLlp8DNfwaeANeDCSANObatx6uk5H9Llv?=
 =?us-ascii?Q?YHh2aXrFJC0NpS8xSQL2kISm2N51lvnOGneCYB27O6ybDtIm3TgTQnmQo3EU?=
 =?us-ascii?Q?9OGlD/WQsdf1PveGqVN7+Bdn4yiZ+nRxkGpWjHbDkmPJZEEGlTKhjdyuBlqV?=
 =?us-ascii?Q?0nj6qbuznf6vXfHaZDdwQCexcKA+Ovn600fk3tR74e5wmTP/aM8OZxSIi39T?=
 =?us-ascii?Q?E5r4I9T/RFM/vIZ3/HHpNSnVX/icDXd0/0QCcOUWT1mJoGzUtp7iPJSIho5s?=
 =?us-ascii?Q?osmpgQpW2/+VV9VbffkD3SUBzkRrguyBLTTWh79sCbO6zwhhtiyLnDrYARmf?=
 =?us-ascii?Q?YMoI4HspnZ0qAUsvWgYpg4ZMAVbhLrpqdPSxGBo1PZGIn0uB9896Bs+MkyE5?=
 =?us-ascii?Q?sIAtpgWFBl2MXrTHwLM1Vx0aSN0ODDg/WYyKeHtLQ1CLPsVcKD3yEaMcsbf1?=
 =?us-ascii?Q?B57JnS7UIrqmDJ9mt5Z3RGOIX9k/Hv6rlU1ZEXHYw5gSzBGM/ObcddgQpRuT?=
 =?us-ascii?Q?Hq7RzP6Gj+3ec/FlgeP93t1Tpg1JtsSN0Vmq56efb03ZZoynXirgqHThxeCw?=
 =?us-ascii?Q?TBKqDmHeFBRorahma+CJuXVPY/4Hp0W++x5fV5BpmMGJKfsQpzZamLM7zaDK?=
 =?us-ascii?Q?5aRZRKke6WMJJ9eLsgboBmXT3ttL/Uj4PFan3DEKiC7VHsD6O59ifrZgPqM3?=
 =?us-ascii?Q?VIhRSHTTbhothDCMde/DIytzCFKFJhgDXvHaJwlF+FITBGo/QzszwDSdpYAN?=
 =?us-ascii?Q?hZYYfE9rNHBpOBXlrNaXptQiIfO+se0mU226wfqizIX0l8z/5CUc9/VnG7iR?=
 =?us-ascii?Q?dk2nF30Dxf26FU1+uRjaQ34llYRWrTtnlwhTV8Xgcs0+SZKylfBYTlmUNi1e?=
 =?us-ascii?Q?wkz6MbKUYtA2CRSfSdGaKCTGmpPs+cyRaR6AbosyIzTFmUC0SpOt3sLRhJf7?=
 =?us-ascii?Q?hZ8f4iiTVisCwRmlpGPeHB/7zCaAoNkZ34IBX4WF0O42AgVQSCCoB6/JULEC?=
 =?us-ascii?Q?Bg9NON6H+1VK+Yd4FJv86hCZdPcKgqanzlIxg72njfpe4sn+dcmSXYji1cDH?=
 =?us-ascii?Q?lpmoJ3l8mnb1XTVIWX1YXaYbljkElVPquxDa4ulKDIZrqSvvo9HTJqTWlODn?=
 =?us-ascii?Q?jgC533gyV4f0c3huIRHWaP+tiEtsvv/U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QzItvmgWcVTVr8O8A1a0AdiRe7NhJXFhq5r4se9JmUvMnUWLaDzXX/Kw75bd?=
 =?us-ascii?Q?/SkXARs3/T95tDGVQwIQPGQbG2uz7xR5CszYjJHbJQdQAM8wQoJeu+G9PhY8?=
 =?us-ascii?Q?L4xxNQ0QXQGR4uTsvMqQtuio5aMTW3E1KjWqjMtNkAWscvuVYRx5dOJha4P5?=
 =?us-ascii?Q?j3tMXmm8rqIBiAad8Spy0xrPi/Nq7K5kBhKKklbwgQB2FOJPjL1telfgv90y?=
 =?us-ascii?Q?CgtyhcouKtZQOQQAKybT1lDDvbE65ph8KqeOLzYj1914Xe3QWjts8HqDPK83?=
 =?us-ascii?Q?btIXz3Eb5NEqxfThM0u7IxhkEsuMjZ6L8iFaoDFJlPLt9ZLJbaZp1I+uFtkw?=
 =?us-ascii?Q?yEk2LZAquhlwXCRDk4a2Jj3PjGWjdKD/g06x6AIZhBBNia8qu4hnyBX5XFo8?=
 =?us-ascii?Q?Z+30LpxrxQgHe5RUmPZUaywvkkCr15ejhvB3DN6q6AAfYRyl1yPfzFfn/FNK?=
 =?us-ascii?Q?SS8UlkY7zDEKcYG3qcGbHGxgapR+krd1npWKsF6eoI7I9Tuvut5slfMGZE0j?=
 =?us-ascii?Q?PXhypi8h3KVr/4J0QxG8ATySr4v343ffO+iDhWAhMkCWdlCnTH6YqWpf1O1y?=
 =?us-ascii?Q?RpumzFX7/Biwuj6/nn032+iHz0ctJr1FlH9foBgbDAVfRmxBOzg9e/tKPY0j?=
 =?us-ascii?Q?YnHyNbe491Xgf1GKzWpJihYch8TYp4NdL8GPRj1W/hFwFxfy0/jq6gKBnyXX?=
 =?us-ascii?Q?JxUxhY7Cly45xGqgEJee5cQe4XFF5G+1qe4KEWtWS7dIJbvoqhxRLBnUlHLB?=
 =?us-ascii?Q?gwPgGXDdYdxXBN9ILbkzKNYHOuuR37YS1MOzu+7sWQWwIifbvQlrHSV7fpuE?=
 =?us-ascii?Q?Gl7lcze8ioPpwV4JzxoVHC/QSjjZ1k9brNaM9iiGK6yaTSJXQ8JJVpuM7NoO?=
 =?us-ascii?Q?cLsP6zXYUc4CHS5yWbf+MD2f7E9YEq5FKkYgycX0Y9gVwkl28F8KuAdtBAb/?=
 =?us-ascii?Q?8grUZhfD9vhCufduWDaiadVjMiINEzU/4C3Gj7+kQJhAgNmBWKjFPwZ33IOt?=
 =?us-ascii?Q?OPDpCEF4FaMNk6lJ0eqNiE5Plt3Z7EQTrkTBWe8hpav0CnOwTUD+zPUvfwSN?=
 =?us-ascii?Q?1UBij3jvuTcOJOcT/fO417buIvcT/UYTsAPw0G7flGTQiy+PZK58uv90MD9R?=
 =?us-ascii?Q?yyoAqaQH8J0BFvctPQ52rVdOI/KWCXGwQrpCJ+EUCXIY35JIeoFpH6AGwvte?=
 =?us-ascii?Q?+XgwSBNS7+XxwYEUxqXAidt0YipvTeLrXpH2Go3KdSAekdIZ5ZwKNT7sqXJJ?=
 =?us-ascii?Q?bnE4GJv1GULm6ETnbuC6xCYcTVGVPYuvvtklzV7LCryOK37xeU5tNZs8vAOQ?=
 =?us-ascii?Q?lfQkV1iqWvhkY8hpWrYekaKbHlbeJeS/TKi20/w3dXZj2lF3n7b7Sedb0Frs?=
 =?us-ascii?Q?JNRDyvm1rtEVIKWY0zabDsOP67frbuNxrcQj7C1qhu6y5n31FUTrA8mh7iwQ?=
 =?us-ascii?Q?RWUkXvMy8ZQg1kXrqAHUvbDXwvhg6Yif3q/SUX3aNupvkBB6m0rO4bV8BNc3?=
 =?us-ascii?Q?+lWvHbBrQYBFVixxLA1DFzsTaVSMlYj2x1PqJL4U4GOW6auaJPcaVV0UBgZ9?=
 =?us-ascii?Q?ewVt7i8/eh9dqqTMjL2x01SutMxEgdvLNzgCQhXxjlpBwfZ2X0wT4AgpF9lh?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YBId9IqyRXYB7YiVIbzctgmRAUuao+jWajFr2uwI1mYxKS9UcQamO1XruIZopEG03XwUDDEhuK6Aeqddkz+gkWGH026c0zFD1kB78knCym0DfppJVWr45bm2GmfZ1K83n2iG8PmrW6CJE+m0UEtgaTqdocamc3f7PXqr8H2Si+VjSHgL2kngeXnzCQLv0DVllghQmCRoJUsD9CIez27YMIIwN0H0v5iIXqwTLwrtmogeCxkkBYebHwZmgpLctU/UAs9YbQXWdodKMQ2ne+RU55/FkO3F7J1FLxEoAXU4Vk/s6xg4oIsh0avGRledakVRwFuo99bC0QMLZcW8Zcabm0K9C3tx+4QnqONdZGbexQDHmZsA5TLXd9qFhCnGoHd/0h02a3lUEp/hliJwUhWo+FjGHYMq9tjwmQpddptUlI0he7CCsF9tB6Fa8Ls1Sd8wDj0T1sBChZUq0WgMi/W8mC4Y6vTRE2LURIJAR+4rKbyZW/+5E/E+qomctSAC0gPYtpSuhsfzA10UVWuybR03Yl1u7nPTjgufc3R2lZKMRUo2cCohk9GEGcG99AAL0HKyo7uwzBTqrdqaDSrJ18iLjKgDGNowSfS2Ibmyz5zZSm8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0f51b5-c882-40f8-ffa7-08de22ce0503
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 16:02:17.6772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVdy99VfStrWT2mavxcBhPAF5g0+fwPYoGHXGwfUlp3kxuPDHo69CKoQXay7Y7zlSGMSBLAwnPXsFlYTkItyhkHZ0sSkgX9D03hxzNpvJpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130124
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE1MSBTYWx0ZWRfX5p+FsA5ccG10
 3fbcP5LK3XuRoE7LmqCJAFwPkpdbl1nr0a3fvVySUYvy8HyDvAlVqeVKwMCMDe+xO6x3OXPa+9U
 pkZ13AeTOovI21O0DhaG7QInSeaYg4UJw5wIbGojaDounI6jBU6x3Slr8sdYErVdLiLFbtZqo95
 wu7tbkPV8KOvUdqowtYkBXUQ1zBYxX3k1aF1zg/PQyDCdiWg5up60C1qHbI519DaYXg8G5JwBDX
 aqDL8HaK8xiBGskMwvh9Sp+p6a+n1VMAI/+Y1d8oTLw8MwBrx1/TlhGWQ8Ng9Cl+47uLwfu9C0X
 XN0m7aVxxIdocDniu6cgEJBPCEwjRGL7MaD/MYw4c8EsMAUDaqnWnX0GY+yKMM+kvgD+desrrfk
 DntEq5foU270gkHTe+zOPS1gpTC3Fg==
X-Proofpoint-GUID: WvEwNXcHMngDw2oVeH-Oh3SNh6hiwA3t
X-Authority-Analysis: v=2.4 cv=ILgPywvG c=1 sm=1 tr=0 ts=69160110 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=m4Zi-tyCpbIv3iXf_lYA:9 a=CjuIK1q_8ugA:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: WvEwNXcHMngDw2oVeH-Oh3SNh6hiwA3t
X-Stat-Signature: ixhjps6wkkqgqt6gxcnqdjze9zg1sdmu
X-Rspam-User: 
X-Rspamd-Queue-Id: 406884002B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763049760-939911
X-HE-Meta: U2FsdGVkX1+W5uwVkGP5rB/8Nuv+PPs+z1q2iEEEDy5RL4xn1l7SD42tISpjao7J5p+l1KyQ4QjBMUPug/mQB72HXe4X9ThyU6avOLM0GRW4EinKhElrWjHgkHWBd2dY1BcplEe3f0RqxEAcPB27gl6GLuRwFSHlfy9765680NyObnu9UngqVl/MNJi7BBGe6CW3Eb0o2F4AzyWCV+cx3gniMhSOoDbIAJiMomnRg2m5fEbMVu9+WodC8kwNfM7p2EZJerLCw+rBBmCHIWzVcboWMnqtj6e5AqGNOk0y9bVh2Y12Ue7d/CcCl6iGyA+bnet678mHevkCC8mEkjE05Cw8c+CCOpOWRE4QE6kDMQoD8GduxAQZdFkW6NDjbH/c613pwoy4KbKQFhsfNQ83YMHC0Oq2WXHpSAbdGtIZQKGWhlKNnEct7MNmG5LsB80dIE1Is5fgCX/EFRstqgA81SbqYOxAHaOkC1Tc6Jm6I6tKn9ZMWdPk3cCnsr6PMZDSnwpcAx8laEJ226Wfs5JW7QDzpY7mACPwQsA/2HdfjmgBApIsfN4kSskN+CKcY4SrpBTeO7ayu8EJ21ucIS0U9/xy7TNxAmjP8LHaU5INSJgAo0jXuN2vqVZmeq8NHUWc5y6Q2zh/IQENYot/qsvvHGv50zgOj6a833K8+FGT/rDkAGQLwX4MQSEATvf/GDglXAA3rxRNnIHH4K245CEffI89j7uFM5W+lfJ5aY+2hUP19X58mBMPcsGsWuzif9qXAEB19E5a9C98WEQCX9pZgTF9/FVGaquOU4qr2PIe2j+UIDe2hize5WdohEPW5RPDr1m1zF0ShVm6ddiUoV5ouUksSbWitfXayoi5XlZPa+mjtwvm+B5sTiVXuNSig0dsAoqGlWzHWfNZOoFnhCNPxx6cMzAXwcMCRSA4YhT77nfY+PKW/0xz8oerZui88Y0Lj2rtYM3HsT7zoYUBXzq
 8f21IXDH
 p3XP+4KWSNn83dq9Kf+lP3TWmJ76ir+jPjzxD3RadvT+hxyrQqxNXRPooGAfOOZoG8AB0I/8ztp6sLebhvUND4E40jzPqfhZLQOIv4fs2YFDIeIyi2BjRBYdxKrkFO/QJrDvEdlpPx1hBMhKws1EPx90G53q0O9UBro/VMtJt22YmTSbt7vUJKKKCvJ0OK3681xedp4Gy9yN/vYt9JsM1dRDcx/fReF6JyOHIaZIEth+7XKp/hU/80A13XBZuuOCGGu933ZbdEUVohQblKkn5MFPUMrR5gat82yEe6XDokJCSeyqTqjKv1sypM8HyszUUmH9OEpkOayQ8Uzjdu8bTkEaf8FSd03Hz9eK1zEHRZx2Mod1kfL5eCISkDk4TI/pCIkG0EiybKYhRcmKNIEd8L7NLTUbALY48rEkzqmjXU341WJRexoKncu/uNSd78SlfATnNydSGZTfm/WiYka+DOZ6d50BSQUOgD0zeOeDPjV4pBDOyREMqOcUorJOVFXyRRlPgKBls7idJUN6hU24Hiz1c9zsg5p7Bx23BZzVrKKgNi7cRxVU+AzFXRvXWwiFC75ID/bE+AtQpRH5/ng8gGlEFTOb3FqDZLv9TCSVFOHjeNIc33TbeMdfacomAKKXemd0YPCaUd/GpHtNIrEGuVS3d8IJPxP0gTLbdvjnWJ7awYIg2lEEG9svbxiY2sKECl0xlFcq/Dv67el0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 04:36:01PM +0100, Francois Dugast wrote:
> Hi Balbir,
>
> On Wed, Nov 12, 2025 at 03:46:33PM +1100, Balbir Singh wrote:
> > Unmapped was added as a parameter to __folio_split() and related
> > call sites to support splitting of folios already in the midst
> > of a migration. This special case arose for device private folio
> > migration since during migration there could be a disconnect between
> > source and destination on the folio size.
> >
> > Introduce split_unmapped_folio_to_order() to handle this special case.
> > This in turn removes the special casing introduced by the unmapped
> > parameter in __folio_split().
>
> Such a helper would be needed in drm_pagemap_migrate_to_devmem when
> reallocating a device folio to smaller pages.
>
> Could we export it (EXPORT_SYMBOL)?

As a rule we don't export things from core mm. And certainly not to non-GPL
modules.

Unless David feels very differently or there's some enormously compelling
reason for it I'd really rather we didn't.

Cheers, Lorenzo

