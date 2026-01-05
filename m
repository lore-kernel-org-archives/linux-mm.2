Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E15C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE456B0165; Mon,  5 Jan 2026 10:32:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55306B0166; Mon,  5 Jan 2026 10:32:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C976B0167; Mon,  5 Jan 2026 10:32:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87CCA6B0165
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:32:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B906B62C3
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:32:31 +0000 (UTC)
X-FDA: 84298302102.05.DFB33DC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id C55EF20005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:32:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bRZ0iI0v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KhuaytMG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767627148; a=rsa-sha256;
	cv=pass;
	b=VL4zrSKfSys3EhV3BRouODKL9hp+PV4tdsZEguCdN4kj7biiGKHwfpI9jbdRrIjlX/MlBp
	KTVczqMsQ+5B0xufU+TTAdb7/qkwdFsADJhZ7OqU25Kv9NkU5ElFcQrNrViUCDuPowaRm9
	UAB1K5I5V/kpaA5bYM5tkxdrWuL6KVw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bRZ0iI0v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KhuaytMG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767627148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6ojasRNGUJc9YxFf0f3PqnugqMUWMhojIwfFdsm128=;
	b=ZhkSkCeIVJp4HsKhIss8cLsGq2hJhIvuXgZKkJrKp8BxqlADJuIrwR3OV14GyxvtEQtmeN
	1hfRRdwoWZlsHhb4LMVqpRefrMV/utuSYE4uRX68bFBQafRPkpOABiwN84LJ7s/ijvinuV
	+an3J13xsRVYYpnvS9sro77ExV/c66o=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605FENpG1455827;
	Mon, 5 Jan 2026 15:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=D6ojasRNGUJc9YxFf0
	f3PqnugqMUWMhojIwfFdsm128=; b=bRZ0iI0vgN8O6fWWHSFBVppeELk2SAVEYr
	FToV+3XLzhNCdY8Jmp7EIIhIdi0f89FgjGJjXlrlK0YifOInb0GN8oUgit8CRgyb
	sSucz/VKj4JjGG5ZAcQ07NnA3jLzsHA4LnI4q6B7xlk/vUok9lMz3HwiFwGutAG/
	4CdyjTrhjJxQwGhoaM05O1294qplDEg2Cm5y81ugB4FdqaSh3p5mJXGG78Zz2gEp
	P6cpEVWZ5qlacXfqrlfVj/dAnXXZ5qFFF+FGNVNKIYX5wPBjilqtzHowT2yL8SA2
	LWhxLn3xQSfDk2iYA2MsCYJBropvmuvEHHnBM3uHqUXvwi6CCJwA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev641vjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:32:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605Ektv7020495;
	Mon, 5 Jan 2026 15:32:18 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjhghm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:32:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mPoy0V7kjRJbdWkvf36pdC/vpH1pfNxOSDW+x9LKB5jGGVooR8L010fPS7HniHDoKqLevSwVh6XhrWDZtNNL1ooZJglSWlPsRZgdFQ/4BSrBoluAQz9lIyLniARSM+EagNIWJtcDmuBhIlfNx9UgDgD1S/ZXtqXGEyVMzMx0b2W/i+5S7zEQkzFJ9aIrKBejSjjKNHDnQNNcMDbFXW3RtaAUIBDjAP8PUN9mJErcsSv6rncC7HhhyN1WNOCVLaXLNa7lSx84+BVTX/xqDSHGjv2zVgFIyCYz1+c6CfLSXA9pDsb4Wgqt/Q8gwLcfuvsGKaj2CvdSVo7unPBjz2neYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6ojasRNGUJc9YxFf0f3PqnugqMUWMhojIwfFdsm128=;
 b=eTBhGtv1QJigosppR5Kh201hzWjN9lfvct2jfYhTVijbDev5rI9I3JTZ9JmtLohTWaXqD+X+WLhVPIWiThCbNASHsJCiAs1yBaDE3eXyIExqRTUKM76UildPo9NgulqAwgYRU14e5WrjOqK+dqHeTDtg/T2+D6kAHsGfzzRRO/yt3CR+pz44AOJQxfWAAGt9xwsNRqqks9ko72VYNg2CuUNqmJhipuhHsO1VO23n/yM4GK+y8UQQ5+qDBqz2j0idkrwk5hxwVoHJ7c2DKqifJtyB2GryzWWAE+dsGxkXWVHPx/enkBbITFQEa0KMiZykvcxHlu/pokTKg9bPILuYPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6ojasRNGUJc9YxFf0f3PqnugqMUWMhojIwfFdsm128=;
 b=KhuaytMGtNPqxNFx2aazFLxVS+k+ywr66EglDC52Dm2MJvPtcNNTQ/My88nCfRkNuQae8zQncg6967frVWhGsAgZGJoWKHJjGW8cuoecTRn7mpeQMPUQJYxvmlUBthlrz9IzwruCuQcCEgcTud8YybRlypOYDQL2iHnAG0ESCFE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB8007.namprd10.prod.outlook.com (2603:10b6:8:203::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 15:32:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 15:32:15 +0000
Date: Mon, 5 Jan 2026 15:32:17 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted
 merge
Message-ID: <b5ffe4ad-690d-4668-97c2-9b94fc1da32b@lucifer.local>
References: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
 <aVtH-9rUDNAhjc6V@hyeyoo>
 <qhhhf2s2vaajvr3u7k6r3vjbpx6r4ama46kwrt5xsusdoccsi2@ldazcd63kqbb>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qhhhf2s2vaajvr3u7k6r3vjbpx6r4ama46kwrt5xsusdoccsi2@ldazcd63kqbb>
X-ClientProxiedBy: LO4P123CA0337.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB8007:EE_
X-MS-Office365-Filtering-Correlation-Id: 3057e80e-750e-4351-e88d-08de4c6f9aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xtxUeZrFSe5hEyyBXLjo5w9BiLHwhsSvMCGoIxbVt+x0mHSHIPQp6WGOj14g?=
 =?us-ascii?Q?ZGfBvBno/0vrVzgljyT12DX02VZUW6Jm/45lQHDIH4CGf5Xr2ZmYP/yLcpOW?=
 =?us-ascii?Q?Wa5nfBgrtk/2fZz3rd2gXTsyUpgB/ZHfhxU/KWyQAbdqu2dv9NicqLlfFBww?=
 =?us-ascii?Q?BUL87F7sGwcskN/fQaSi1rlyhp+tFP8oKYI/0YeJABIT3jI45V1SVetKogng?=
 =?us-ascii?Q?zibRNoPIfBdgl9xyNXdN0ONanP2JpJep4qVz/xxthcWOMrG4Jn7yZ8AVfDPg?=
 =?us-ascii?Q?KkPDe8OYvJnHEZRqc2FB4DCKCUXMIHVtVWDy8PSV5aY9KfeD36iwJe5waxHq?=
 =?us-ascii?Q?VbspvpiU0kSBpuPhvaxw/fZxzxIY9ILz83ZMezGk748H5+8eFzi7/e5Y6FCl?=
 =?us-ascii?Q?C9JocGTiQWz6P6jc9jfg1Qt3O6THmsbmNRdel+cjBaLJF7SZFBSyzDA4FtGa?=
 =?us-ascii?Q?w2r3A+6QeP00NAee7K3cdCyRp/Wv2WbVox3DZoJMSgUFOvey3PIun1FTmuL0?=
 =?us-ascii?Q?xd9gDKfgJt/pMicjhPM+i49ozXlskJr3iYLlPtMydxV/hXW2aj0Ln7pbiv2g?=
 =?us-ascii?Q?wKe5VxlS2OSKG1f8FqD9MD6wqxgoeMxO3+Fke8TsmQLqk93a0ujbNNEBDTPk?=
 =?us-ascii?Q?2eLkL7qhXAPF2/kmjKy52QgPSKzMndTFycVkefCyHvu1MVPVje46+aj7gSAf?=
 =?us-ascii?Q?okhrvgQ4Un/bimD9wCqPGwiKnFJF7PXKSkr99tb1+f8VENc3IsTuoLl6bKKv?=
 =?us-ascii?Q?MTNKwI6Rrows7+V/wyHn/QLNPbu/5M8FFTzMBtH1boh0O4tOMwIF/idaBbBb?=
 =?us-ascii?Q?1lsulrEhsptag8wS6E7ixcikrQdyHs2NWIHdh6YW/1Byd6xUIVVay9IxANlj?=
 =?us-ascii?Q?Myj8jdCmvFWr7VrcPfikDpe0R4aMTmP+E3Os+ziZlANa2HgxwLo8ZhrSq8l7?=
 =?us-ascii?Q?oHu4BX1OuE4aSh57G0mv5m9L5oOng8PXDdZP+RxuRICcALhUNy9aeqnN9lJ6?=
 =?us-ascii?Q?6Hma/6XRgjBzobTrcTddJ7NxC4sYTuq8Yjx0Do+t0pyXFNYaqtssYSeMt+AY?=
 =?us-ascii?Q?qNNVu9sAftq64MXMccvKLTWHI7BgHJgFb5qHFeiI/GI1h592/I9O6+t0Xd9Y?=
 =?us-ascii?Q?WvpcXAetZd1mU2C7MTzNRoPEOahI7W1bfqhrzv1VWbByaMektSR5MFIBSOtp?=
 =?us-ascii?Q?QqvQq7Nb8zVuc3BjSzUvlcHBo9sqOzc3sagfttk+SyaYUJd+yWMMCAfVg6Pr?=
 =?us-ascii?Q?hvJ36lkaGQO7UQcd3lTONFVZHYDfOXjwj0WYo5KCcCmG61IgPzuLYaBgYp/f?=
 =?us-ascii?Q?4AIhnzQjR/kSXgple24QVfj+XJrxV001VDdgU1Qg5/ux9kKKKeKAucfL0U44?=
 =?us-ascii?Q?Flo0ZaPuAE3JH8Jz8kIP8APHUKGQGc/9XBoFnnuZT0s5KJ0YydVnhHJc4UJW?=
 =?us-ascii?Q?KsqF1r7jA0zfi6TC+LKKUzmt4qvh7ZMiLH1A0EiGbE6I9bvLel14e4z8w9Y/?=
 =?us-ascii?Q?9e3l14BSyTVgDrU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jh1+JNiP5xYbV6FJht/QPE7uk1PEuvh8YjSAhfifLamHG8IfufVkvNC+P0kd?=
 =?us-ascii?Q?T0dIKU9xQVzZM/s8azcRGeJDv59sYoSPhhFKl2/i5xJ6a9aDQLeFelLX6Df8?=
 =?us-ascii?Q?31cc5CGeswfbuF8Hmo2lsE9vIb85QtftFnAocbq/PHY5i/qrk1e/gW4U45Ti?=
 =?us-ascii?Q?PtbIWqintrlbP2skhK3oQLVOLBAE9k64nrkCYjCQN5hCk/tGKeXVCwzFWrRi?=
 =?us-ascii?Q?lmdguRQr9DZgTXExdGe/SLQqtKx/Rlw3hOtq00gSBCrCtBBnHTHtlCh8P1BZ?=
 =?us-ascii?Q?VmQrKXuQ7JiopYfU8FaoJJKX/VvODKGTk4Biyw4/U898Azo7mOZEmaHNSiD8?=
 =?us-ascii?Q?r739pzFPHSXdCthDjWQgBIN06LicE1RgvLQ90LD0bsWIRdqlTZZj8P1Fqw51?=
 =?us-ascii?Q?OTaiha8ux24HBiLNW6OmqPE55W/GcXZaDHxsjgzJNWiazNJRTm115pAb3+PK?=
 =?us-ascii?Q?HTeG+dA9cD42PEyhTyhitLYz2AHkCQXI5O6beGsOx1r6RiccCtpRsULrJnBt?=
 =?us-ascii?Q?8opJbG4Y87sgISOyqd4E9D2WiybAZRRAAyq0Prz/ztkvkuodtm56J1V3WqTJ?=
 =?us-ascii?Q?AYHOnu/HgsGFvvMly4NVNlhKAwvnJpEhvazYHazB6tak6o0q15cJJEbAokiX?=
 =?us-ascii?Q?VNl/T8WHTZArRAOUnH48OH2u1VX28SUvs4wuMPjziEYhYK8LdBjdXQYKQ8a/?=
 =?us-ascii?Q?f4++tWUmOg1yjrJWErB7AFP6uhBYCC9+/XYEJFH0Mic4YpqFyjQaMX8C03GK?=
 =?us-ascii?Q?hvGAvl6O3s8o/X/nKaPSWsGabuMfWgLgpAZg95WIHq6KIdx6iEiCzq9X4O84?=
 =?us-ascii?Q?MAsaix0xhuJ304lC2IsJattuSIyuA6K3GgLC4hMO5DcAZKbBJCxRI0ppcHNr?=
 =?us-ascii?Q?WnlRfZG5VBySBHdzkwcD3qb9+7/kpnz8wrwuktVdsN970ukG1y20d7tprwLD?=
 =?us-ascii?Q?2uiJmU37yDqOKCn4T1xAZxMWaYUMvi823v0CZD5FvisVQBcg3bXIczZlWnbq?=
 =?us-ascii?Q?vGupkYf5djBGuC7bJGYG7IzMiqNoCFGGZlIFHlBK3dBnd6y1uRM6D3KM0IV1?=
 =?us-ascii?Q?9L25G1JrZUjVrcp7YoiOHRk5w98d16GexqSEv29g3xqeQEDtmUl2vhxRkjLO?=
 =?us-ascii?Q?VNF8Gv5auGWjMNKT6D7F3iT8Yw/dOnmCTUKmvZDjo55TYqh/P5EGCcBvyy57?=
 =?us-ascii?Q?Z9RmX2G0gxPvlE7n7diyZymmw+mfSwwnlXi6BsL0ND0kIy29sRqS1VwiRMVV?=
 =?us-ascii?Q?M7nIe2qzXhA3EOCRdGmudB2jL5pT4aTPO+bHapB0mdhT9flwrk5xAnz+bPQ6?=
 =?us-ascii?Q?2FjnVpctwtAVlL9anQLaDm6J2q4oqXHimPejihf9m8ZX3DOzpD0aKMOojUTz?=
 =?us-ascii?Q?LFcJ9nV7tNndRfr/J9m0gAldKnf4wHue63ngk09VeT0uqajW/lzXARZHMdAE?=
 =?us-ascii?Q?gf2rbOgs2R/osJyk+aWeuHSXvL/oOOuv9gT6C97ZB0Ieh4AQCBEh5wBC+ufP?=
 =?us-ascii?Q?MylxgZj4BJ2h4XaGjrqtSpPiFji+tLyFRC2ZglJnH9TGdFKfDkhgxMVcWzd/?=
 =?us-ascii?Q?fpl1g3PjToYGXOlm6Ix9e4/UBYHVUmVp1KYkGp8xgiYyOXL1/h8ylxzfIUa3?=
 =?us-ascii?Q?i7CgErQivQ7H00J5owua62g4r0KkuLWGMxNJ2a4+0yT+UDDq4KX5ag+GvY4K?=
 =?us-ascii?Q?iGfUULwHeWHfCSDMXOWNBtJXtx49f+R0kxwgBeeTKkrqNrO5H6WVB6h8V0iT?=
 =?us-ascii?Q?2DGuKiGh6BxABVDSWttsEBQKArn8nU8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ErSZmTZtbDaimtmPIlITtvPkIun0yzdidl8S94pXX2TtqNct3QkyXdEKEkRvUuN//Vvhs5QW114McJTSklnuCzNGJgsf8ZkNH0eEVEV+d6HNHAxrofRuLwYE8fkcbRSmaNGDyjX/dF35UO5enb9LaCGbqDLxEZom9Eoi0nySDIy2FX4bh6qyJ6xClRijdlA+NpQOWeOu7LuKtjKmfdo0OF2iXHKB9OZssmen270dDlQGXeNeJFsz9GE64ozZnRxzrERGoS3EBorQFmgtJbVK4/LNXqdMDJ7DyKCxEAo1i/Eyqxx2A3jsmw/8v/AlcXj3yrzkgwTucM8TyPMar/Yrf6o8Sg2frrQIBTv6uQTxRx+d1Ly3O2gm3dcNCRCUqhsNFB0KOrz9h835JpoBId/TPKLh3tVCWFR6Re/o5m1R22WTW+yEufBhz2R7vcPdWQVMhGXOGLUyfWRP+9Fe45R4x+2HXc92/3W15OjAVCs1Gj6vYh76AAsywcYAZyI4rucsZFg6f9OwAqP6Irn6lWBO6breQzzGnnW/LYXWFUmOSjAbqyHkhFKUdHCvvXquuyhCXrO00W6vou0BHdzrgEKpUF2OZTvdPR3B53PhGYQJ39o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3057e80e-750e-4351-e88d-08de4c6f9aac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 15:32:15.4564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7q9NlZidiBJcKXH2vyoGLxO1jAw5+K1ALEdsuoJ/4l8rDMlT8DeTCbguuew/s3iUSCcWW5SCy1mGXpa52T9YP37g9a+rwHsqsl7NheHCPkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8007
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050135
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEzNiBTYWx0ZWRfX6cQt5NnQK4Wx
 Au40KGqjSGqafOOw9Q5wF1fK41dkh8rst/X5IFlqpMJeZT/3XPWy1gQ0b1wCd3JXnND5AEAqgPo
 3wvtJCJyP4CGxx2aowa7gMhqWuYQ8yqYVLmOBYx+4TsYelU9ioW5HH9rY8La1cfCwIbxxgqgrt2
 KCSQUGWQMomaSvMOySLpDS5fbVmUZE/XvtfFBtdy4P1wOUrHszKJfNDOofxj1bbbqvrNVRcEVgB
 2vECq/IABUIzlxPzCEOaoFkUlrbQyq15xCsUCRyUFzgMf0asf0o3nYF2mpL0MLhwylZKKtLyIPe
 ICILlXvPN5M8ECphBxdBa0wxn/kcmniL9BK+o9wuOMhLXW8aKC552Wa7czv1BMbINIzQDHV7K2e
 Z0WTrlVB6xiK/2sPxDbyqtPqHxcJPPIDgU4fr2YBkKTeuicsIYKMgmCmYTr0Ua8tDB6ZN3ho6dw
 ikqjIO85U4m8cooY0CVzY1HXWcnl1bYJLhmb3ctc=
X-Authority-Analysis: v=2.4 cv=W6w1lBWk c=1 sm=1 tr=0 ts=695bd983 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ddsAii9sUIcyj83RRToA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Proofpoint-GUID: 261-IY4DWgHupTbGQtrz1kgZOZaIVraO
X-Proofpoint-ORIG-GUID: 261-IY4DWgHupTbGQtrz1kgZOZaIVraO
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C55EF20005
X-Stat-Signature: s5mip5cn3sg19b1u3epdo8emedycdt7x
X-Rspam-User: 
X-HE-Tag: 1767627147-186351
X-HE-Meta: U2FsdGVkX19qRwaOJyfWXHmoHx83MzoREyFQlzUpZryeYALc5BG9XMoPrT9Zl3gOA7n8N30WbQhkWe4q91BUdClT9uKAxliB8eQTM+ZJZuY5zZNawFZMIKpAwyfJ7LxmF0+QgSqKij1JpjYIv7tV1j4wL8B/sLE8Tv7B625J7GY0mqLd6RmV5ijSvJSX3lZp/n1le8gUSNF4R6tr0kABtzwQlZrBEgT9hgB/lx1otpx4m/P5DaxUokyP/+q3GrzG31tMTq5bKhguW8EkaVkXpBVKEQkK6X6ZJ0eWcxRykz+HSUx/DSoLXKB6w/oN4uM2FgzV3zjdtqavy5PDDQHouKUMjEYiDStDKYPlcWAeFd37mSu7IxlNrODK0wtcAT+NYGzYEwihLUHfAdhIPLmj9ps1TV2hIr82OUixnKydKu5qLWcQW07UucRB5j7tWcD70x9Bhumwzz3g3UvLzxalCvZxNdKa5uk4999uVb+UZPDlp3+nq+XkdBiL/bHb0IytKhH2UWL0WhsMHsR+oBfB7f9deo3wKkuwuMgzl7DYYJtr8TFcVyb3RGwv6vgwDBfGdPSdCBY6L0NSFh0jVSGp3yhSldS5JhsXdlVTBXlsVHJtzo5i5y9rXmb/JbXSWGkmZHBspWu74fOibs3J0E8hDcibDGFoCg/O5Gqzr1/GN9mf5hPfijLa5cDTbyRxBZ0tiB/WjICSBLC2KaKs3ZFJH3DspMwiDe2eC6gL9rrOjgJdC1TR4wqaXoUaZ47c7zazIA7uBkluW0IHKAVklXY6llVEWmZT0FwwtRuO/GDqwlkPHH3qMokGV+AyP6toM1zbybcmrI+1tSrUFN9g6OT5rPv19i7x+AKuuP2Gi2pfAD9sEZyOgh1m0feY096hiUSN9sXRybbTYLtAfbwGWspquJjLlWlAXDQ/gMxCXlwLefuHzaMvOt1Zc0U0hTWvkYZLrpgCZSv33//UFoTrtlK
 k8ObQ82T
 Uz4Cbbqa12TeQ3Jz8+F63Yp7u476MVqjKb2c8cyjkBsWgmT6K9FbGk9v0wyv8ZsfLOfhW51m8YG3vLs/t8iPJ2YVQkKL/3vLUecAA9hkIdTmVwiD3yLpnZbJYQ8DJ+MJoWFaUQiuAdPr7FW1xb3sYNVycnMtfB0biSZr9mJTAWMoZEcN1XqtTzV0JqhkjT6TFqtnw45RDtQ/hc2SBVo8ARMGj8RIVwS7YGTJaYOuztAys8ctD8f86/zuo8KjSe5AXi602kZu8+KS6M/hS5OQchXfukqP2em7im4NaoOVasI3sX1U6iRUc2qPgTHJawr0zcseIImrYVDTqADqECw/UTvWCJNXfeVbKyjiMGa2zIfcWAP/vlqpC0YFXyXOTfIPTkrK4Kv67Yh+xh0OxD+OTYDoJ7FOLo3OaoL/ol+woGroEOv0Q7YE7d7S125lA/y5sPn8mIZucpojr2++4zerIMXF3sm6dsSxl9jyDYz7nkUp8m/HN9NyW3JFOp/RSxt6QNo30XHywOLaw90ENTzQ75UMfMbBN4ANiN/+p7PsDeyJanPHr+AuHytkvIRH7ofhum9YhBnBn+q+OzhaURKVXlMeYOYGDpjwPLbkx6Sg7Wdzy0BNogHBiJfM/6v7hj3ukKUqSckZ5zyYdTtSQHIvpNAI1JKfvrhP+HqMVZeMdscaeWsc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:24:13AM -0500, Liam R. Howlett wrote:
> >                                       mremap()
> >                      |-----------------------------------|
> >                      |                                   |
> >                      v                                   |
> > [ VMA C, unfaulted ][ gap ][ VMA B, unfaulted ][ gap ][ VMA A, faulted ]
>
> The key part here is that target == prev in this case (as stated in the
> email linked).  So we're going to dup nothing, but we really need to dup
> VMA A's anon vma - right?

Yup.

There are a number other cases like this, mremap() of anon breaks things,
because the copy_vma() case violates sensible assumptions, in the way anon
mremap() violates many other sensible assumptions.

I have a generalised fix I'm just finishing up the tests for it now.

You'll see exactly which cases in the v2 which I'll send later today.

I also noticed another issue which I'll fix in the same series...

Happy New Year! ;)

