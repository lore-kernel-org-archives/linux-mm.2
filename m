Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E49CDC19F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9146B0088; Tue,  6 Jan 2026 09:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0096B0096; Tue,  6 Jan 2026 09:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D406B0098; Tue,  6 Jan 2026 09:03:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F66F6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:03:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA079160151
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:03:30 +0000 (UTC)
X-FDA: 84301706580.02.AD6E6C8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5AC554001C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:03:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g5yJ9at1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TQ2CEViO;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767708207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/lWgHi1sl6JEBVlFGTqubJn2R66vJwRfr0EmkFM3iM=;
	b=5TF45JGJQXeVAHMh5009Y1LbJogVVcPQQXYOjmyEAMZJY8EdNzCsXuSI92MIFw8mRAhurm
	9DytRpPM4y7IZ4txg6OwBPRg+Aj8y9RYPCBvn3tBVY4zj3TQc22tAuMyWcGLi8OFOS4UyC
	pUzvifEZNwpOLyhmSIpjvCJ73EH47wg=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g5yJ9at1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TQ2CEViO;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767708207; a=rsa-sha256;
	cv=pass;
	b=o8y9g1/Zsk3DIiVgIk+mDqCIjf88qlT2I3VbMb71rGwf79UvJRQSv5V2sgpwf/Ki2XOc+9
	chYXG971xem04H3J6VTnCmkt8vjI52xlAnSFMM/p3b2zH2XcVKwW2uBLZN8DITmhgeDAma
	3TJExjcbmYX//q9tNqO7JysajgQdmtE=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606BtSE23785323;
	Tue, 6 Jan 2026 14:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=S/lWgHi1sl6JEBVlFGTqubJn2R66vJwRfr0EmkFM3iM=; b=
	g5yJ9at1+eVTOxeBtXYZ7ifrwQw3YxGm9ZAZ6ZSrYAwFR2UDC3v2geyJMKJtM1WK
	feT3WKSq62PbkxtoyG0agej38aFw0senN8sycOy14E2ecIi6ouqMrJ3NVme1VlSD
	XQhZyigscOE5/5R7bbg5e6HmvhkSnNBK2OO27thblmdrwulZ/Jx9NhnKLFvYHV5C
	A7S4lnq+XUlRExo5J3m+2cmGsqSqokUX79yQAj2ICWO0CzLbjff34lJS189ERfAJ
	Qcpraq0KLTx3nIdd2VtbsTirwq/rpL/fzHLonIAqIxa7S1swdEU/u+H+Lv4otnsh
	5kVpqOPqGfd79Y6QOcexAA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh1xrr4g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:03:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606D87dq015667;
	Tue, 6 Jan 2026 14:03:22 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8cgqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:03:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TxsZSjkSXWALj1mBMePtA0bSK42Sa53cX/53/BOiR0SEkKRmj5znlu838Qz7lWQVc8vREht0E56FZ+6ZJ94aQo2BqAaw7Cxp3tnR52RtePhk7SeHC/JgxHlvvmE7fdKfqTmncNua74T1CFOsp85Qz04ou8qLxnbamwtaScsuT2l54pvNb5JuO96xrlFeq2DFwJTA8RyXlObuTHYfNTeumZrv2c6RP1yQXL7o7MembHLE94VP3d/Uc15bPmqdSUMS+dG/FGv499wMQ085LsQgeqfJ1dOgLrxCF8yHmcUDHUHX46EEN96xUuOPqljpW5lQePISk7bW5RgIjQ2/wAHb7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/lWgHi1sl6JEBVlFGTqubJn2R66vJwRfr0EmkFM3iM=;
 b=eRvhegy3jB/07YF6kyx2QZCcytl3Njgr7kKZ4jlRWj8hLTvycsIYgoABOs93XsJpGqqPiqo/pWNjF9FLuxbnrrEtGNaljp2AaDZ9yzWXlesfwt0QJ0Au2VFaxjbfB6cKQ4CGqop5RGmIVvYZWfMB4Wtp3BETJQ+TZuKZ8+XOp5ZBHaJRDp4eKqzy8t21FHhB/qX4I8jFX5DDb3aL/J2hQDDCVBSetig0K1IIr7w0wOhkaG2X6jUT7qd5nyQCgO7m/qxMC47ZmzBjxX2roFd7B3eM3WG0lPpAKl6JwgJn+iPQZZAJ9RotZBk7+7fbb9PAqELSoSMLnyHCDVMmDjgKQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/lWgHi1sl6JEBVlFGTqubJn2R66vJwRfr0EmkFM3iM=;
 b=TQ2CEViOQ3C8+TnUgDkGjBzsV3DHJXIxrPnZxvGaYNWMCrUQvXW8CKw780R0LfKVmFucnMnU16odnY7crBFTradlEUjXdRSm+h4KokKNBtRtLte8NEJhpxuGz22LMuLTM+C18zfBAlMAOLfO2cG0Gj98X10zSIKGGAfPWEnoCtA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB7289.namprd10.prod.outlook.com (2603:10b6:930:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 14:03:09 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 14:03:09 +0000
Date: Tue, 6 Jan 2026 14:03:11 +0000
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
Subject: Re: [PATCH 5/8] mm/rmap: make anon_vma functions internal
Message-ID: <039f5603-aee3-45d6-abaa-3fabaafd90e8@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <ff68a8f703701c8e626f0cb190c845c5d883c88e.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpHZ=SESegi=M4MxX7gfxiWN=Fmn38XwqVszGoveZp9gUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHZ=SESegi=M4MxX7gfxiWN=Fmn38XwqVszGoveZp9gUg@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0272.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB7289:EE_
X-MS-Office365-Filtering-Correlation-Id: deb3d43d-a85c-4b04-a421-08de4d2c5260
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TlZaYzBCUDJtcVkza29CRzc2RXlwSjZjOFF5aGd3MENkaUN4R0IxMkJYK3c4?=
 =?utf-8?B?cjZwNlBRNSswRkdRMExBaGYyZXJiYWZDSzJobWk1NTRKQ3N4Z0lJUEw1YzN4?=
 =?utf-8?B?L25NQ0lvQjlSYTljRVR2QlFOaU5zNHBXdWtpN2FnQWNmQjNLUUJ2blh2TWdn?=
 =?utf-8?B?anp5VzgvTldHUm9WL1l2V0JDQmFNb3dUb2lyb1pvOGhZMkd5M1MybW4yNkNL?=
 =?utf-8?B?cTFQUnQrR2sxQnpkTG16V2R1MFRrOXhSeGg0MUg1MzBCdmpoR0xEaU96QXhN?=
 =?utf-8?B?SWxUSkZOb3RsOVJqUCtGTjBraVZKMmtHb1pFekM3cWJQVlRmV2oxZFZkL0hF?=
 =?utf-8?B?QlFDYjlBSkhqOEJPVU0zOGFQNkhybWhXUGVOOGR2QXZQdmxUcHFQVnlSc25a?=
 =?utf-8?B?eG5TbCtSbEJORmw1dlB1M245c3RpVHhVb29UeFEwenpDQjZNYnpLZmZsaG9o?=
 =?utf-8?B?VzBuRFVaNm5YSVo5eUgvTVVDck5wU2xyc0x4UlVCNnEweVM3T1p4WGdXeHkz?=
 =?utf-8?B?Y3NTR2lpakEzbmZPQXI0UE1zc09lclNHUEdGQVhWMjBIcEJWZUt2NlhmQ0Rs?=
 =?utf-8?B?SldhVTBiMGhKU0crVXhLWlBUWHRZTC92Mk9IL3VhVHBmZHlLVWJ4aEZTSVA2?=
 =?utf-8?B?WldzTGhhY216bWtFSVJRcElQNzEvWEgveGlVTkIzNzVnd0tzSGZaaDFTazZ3?=
 =?utf-8?B?TEZPYXRpL2xrTEdyYzdVTklOaFhzS3pTeENWTEhzL2tkdXVFRDJQWnF1Szcx?=
 =?utf-8?B?bXhsb0N2bno4SGpJYmRPbno0S2w3V1JHaFRPWFlHaVRoWVkySkpTaGt4Mnlk?=
 =?utf-8?B?SjR1YVRjMlpVOFRGWklVWkttZlN0MkM1a2dCeHRFOWNUY1MwNXVwT3NnVFRm?=
 =?utf-8?B?OGk0NjFnYTIwYnc4SUtWcE9QQk5RZlh2WloxRmpnWGpWamNlempmbndmNU9y?=
 =?utf-8?B?aHlKbDBINTZZNkFYQTZtVm5NeWprZ2NyTit3d3h3bkNlVjI1elpHVHp4WXdw?=
 =?utf-8?B?MzNoa1JDbGdBNUxvWTRDRTRZQTZxOC8rY1pybjNmZGRnVHhSOHRmMXJWOXNY?=
 =?utf-8?B?R1gveUlaSzUvS3owTEhocUFlTDI3WVJRRG1aYU1jcFp5QndxUXBvUjhIdHYy?=
 =?utf-8?B?OGhIeTFJTVdHUVlFLzFjY0x0WU9hdHNLRDNBRkFDYnBoNE43S3BYa1ljeFR3?=
 =?utf-8?B?QnpIODNyUmN3bFhiUjdmVUdJaENJQTQ4Yko2MG0rR29qMVVqRFJjVmFKQ3Ry?=
 =?utf-8?B?OHhhU2FqSTZaV1IrTWZneDIvbHVqOXFucFM2aHpaNEdnTkhPYkJFSU5BbWtk?=
 =?utf-8?B?T1BadlMvZUhxSCthOTg2V3VoQmk3T3djK2JLdjB5dkFsRlk2VkRXN0hra3NZ?=
 =?utf-8?B?Zzk0VytnRGVFcGkwR281eEh4aGM3ZW9nZXJETW13REdvTC8zTlNRaTRReiti?=
 =?utf-8?B?Y2wxdE1Mb01keFFjNFppTVlyei8vM0tmLzBURkZrdEtqNjR6Q05pRTdnRW5r?=
 =?utf-8?B?WDIrc0VPaU8rS05CTmRBM3RGOHp6dy9TNE9lY1NialZ4aWdNb1k3alZFekto?=
 =?utf-8?B?d3VFMG9icERTdjQwa24wTlpiS0hsWXlIOW1IUnp2VjZwdlN4Rkg2eXFXVUFN?=
 =?utf-8?B?K2hFYjdEWUlHMFFwZTlJZnJPQjdwd3piZHBSTDVkOGRiMVJTN3lnZTBDd3VG?=
 =?utf-8?B?bE5aK0hoYVg1K3p3QWZESHljZ3ZVRXBUMXlUZ0Y0bHhZRkdoYnF2dXNWYmtH?=
 =?utf-8?B?ZGlVMHdGUVlHbkZQUE56STBIbkhLR0IreUJjZGpZazBUOEI1RGZSU0wraEJy?=
 =?utf-8?B?NDgrYzRCaDYxSnBDY28vZmlRMXdzeWprZlFKSVlOcjNmbGduMUF3aWFXVmRn?=
 =?utf-8?B?YkxrUHpGY3NwVlhVdzJCS0JpUml1MkgzQkhRT0x2WW9vcXpHV1ZxQVdHK0Vu?=
 =?utf-8?Q?mbIiTM0yiWFuuJ3Y6y9oeVkQ0uXgg8XI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTNIRGVOaXV6eEJCa0Zybjl1QXJpY21yREhwYlVPMEJuWitGR1hhNVNYWkJn?=
 =?utf-8?B?Sy9RRTV1dlZRcGwrK2Q2VTM5ZVBqMzQrS3NEd2FTQ05IOHVGMkEvY3lEcmJh?=
 =?utf-8?B?a1lLOVZFREppcjVqNDRLRzRZRjdURG8wZUhJVnVHZmNGNWxhaHROYXZkYzFs?=
 =?utf-8?B?VCtnSHJzaWJvQmVQNG5PclZWZWhveFhYejRYR0FxSmc5bkdCNk9xNkdSR2ZE?=
 =?utf-8?B?THh5eTcvMEFOM3prZC9KNmRlUTRNRGpEUXlRNlFDeUVQc3g3blFLWC9yYW5x?=
 =?utf-8?B?ano3WlZreXNXOHV4amRuWXlwUDg4RUdxTkYyd1RRRTdDeVVMaHg1TXZrdXF0?=
 =?utf-8?B?OFBQd2kxTnBqK1V0c3BIYTFudWVZUzhNblo0VWVveDVIcHI5WjR3RjBDcjNX?=
 =?utf-8?B?aWlDYmZ3ZHJmS2xEaFo0TEtxRTM0SFRLU2VUUkpiQWhUQ0RJSkxKTjU4QmtO?=
 =?utf-8?B?RE1NS245VEMwUVZ0MmdiQmsvU2NBa2tZWHhmTHlXVmVITjBsZ296VUgrUTJy?=
 =?utf-8?B?TDhzZW9DY0p0OWhadWhwVmxETyszSjBnNGdMWmhxOXFrTlRDTndjQUx4R2Vk?=
 =?utf-8?B?TGZpNjAyaUh5WTVTN2ZHd0Z6bVhqeENRc0pMY2piTWh4SFZ6QXJFbDJDNHBX?=
 =?utf-8?B?U0g0Ris1alNYeDZNb3VaTldFSXkrRUlKWTFPUkZkSmNEKzFDTGQ5dmV5bUI3?=
 =?utf-8?B?Z2RWNGdTUWxKVkZtY000N3RZUHE0N2thcUFqSk83RXVCN2NaZDJlVytMOEc1?=
 =?utf-8?B?cW9ERnoralZaNVE1WUloQm9vcHY1Nk9laGxROVJRbENDazZWRXlVSkV2VnZ2?=
 =?utf-8?B?QVZvaTBET0xscEYvSE92WThlOG05SW03M0xtaFJCN2xLV3BnKzg5Q3RuanhO?=
 =?utf-8?B?NmIxOVowZGQxMExYZ2VNV1U4aUN3UVhzVnZ0NVZjMWtMWVl4bzlpWkdmSDV0?=
 =?utf-8?B?bElYbUorMTBtbXlVdkhuUUQ1T2J5L3BKU2VpbG5lMEFicDhnSTF3YWpCWjBt?=
 =?utf-8?B?QjFuNVFTRVdOUFJDeFVZT3dHQnhqZVNHeXVxUTJtOHdrMVIyK2FTTWhvWmMw?=
 =?utf-8?B?UXNpdUJlRk51YXVNUVNXVS8wc3JRZlBWamZEenpGeENBZysrNWdGYVNjOHRR?=
 =?utf-8?B?MVdhYkRuUC9LL0Jzb0dQcllrTTMyM3RtenZtMlU3M1NXQnQzL0hLcERiYWdJ?=
 =?utf-8?B?ZmNEbmdHM2NLbGF4NzZPZVJ3MjM4TmJDWXFpTnFSeTJwOW00MkNKQ0w1MFFL?=
 =?utf-8?B?cDFzbW42YXNweDlaQ1ZCQ3ErZDFCSDIyVmRzS0t4aFZaSzRiUnBsTEdWTjFH?=
 =?utf-8?B?V2s3eEcwa1RRRUVlNktOMVhGZXpnczU4TkZaSGVUcG5Jd1Q5MXQrR3pMR2NR?=
 =?utf-8?B?T3FNYzBHTGVvc0xxdVRnNndFYUEya2pYaWp5dCsrMDY0allGY3Y1OWZFTitF?=
 =?utf-8?B?N0d6WVpkS3huM1YzQURKQXFpTzNzMDlYakVvaitjVlB6RXN4UTFkaWZCcFdL?=
 =?utf-8?B?LzJ2QXJ1dGlqTkxpRHZjNHFTdGtPVDRpa3E4SG1aNlh2TGNKTGx2UE94UEpR?=
 =?utf-8?B?QkdSS2puazNKWWsybzVkQ0hNY3NsdXAxZFBiRkdDalVtZTV6RXAwcG1McStr?=
 =?utf-8?B?NkEvbkhrK1M0YnlKUHpTeTFpTUI2aWQwZ2VhN25WNlNXV3dSaHVKajUwdVRp?=
 =?utf-8?B?MmZBU0gvQ1hqWUs3L1FLOEpmT2oyaEdEd1Q5dUpJRCt4ak9HeDdxeWl4Vmwr?=
 =?utf-8?B?STJScFA0SkFOQXVUeUludHJvOExRTFdsUU5MZVNNRWVNQ3c2d2FjNzVFa3BF?=
 =?utf-8?B?ZVl1eUZ6bHZMeU94MHc2MGRmY2p5TnpJc2IrdXhxU0ZqcTJub21iUGt5cUpR?=
 =?utf-8?B?ZzIyYy9DYWhNL3I4OTZuamZYZDF4VDJ2dnVXenFLa2xQdVZSbC9QdXU1VjV1?=
 =?utf-8?B?Mk4zU2Y4dy9zZmJVT3hqTTVqUnpHWjhSU0M5ODFkNGtqeFRkcHBEcXc0NkY3?=
 =?utf-8?B?bnBYcHpLdzFWUmJVWGhYT2krdXhJcVMvWEtBL283SWtEUGNlNlJ6aEF1TUY4?=
 =?utf-8?B?Zmd1OHArTStVS3JtQ25CejA0UkNpS0psY0ZEZnRHZ3NGaDQxTCtsb2pmazFJ?=
 =?utf-8?B?V3BRMVc5S25kT2dETjhwSUI2NGdLQlZ6cHF3T3lVSnlFaENyRHBYNVI5eFdX?=
 =?utf-8?B?R1RXY1o4aE1xakhQcTN1YWQ3RExqTFoyamFpZ2dreitjQzZsMSszaHJEMWRh?=
 =?utf-8?B?RXk2RkJxS3hSUVZLUmdCOE8wVVExRGNkdjJ1NlN5NThSQzJQbGJtbnJuamNr?=
 =?utf-8?B?RWIrbzFFY1pTNDhrYlVBSzdpZ2lyUHBmczFUeDhYQTBqWjU4ejhTcnBWMU1Y?=
 =?utf-8?Q?aIoFZETItgvjf6DE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r8QUcwcZqof+ri6xFnrPfGxmhXItaj0pI80z+j3Krj3i1kzvaYnrkf62xv8Uq2Rej0wxz7HWNGTNjCJ3HRubthAzNq1qZeJ+JYMsA0ic5HkOHz7VFDkns4vwMyN2hXdEG7dGbzqkNydYHaB6bphUwiUoaBB3JAO455Ez8IXXSBxJdiH2+Sm5gfBfYvF4r6AX5ARpg2b9sSxfVmJeRtjgx9BYCRWmNvZhVYGF6mRcJVLAS3v0tQ8Rv1j9j4p3iVZKmsoj00DGnVrmtqs9p9ULALaCohgF86SUAG0D3v+KzQt+zhcXrT87m9BbBQpDWnKcxps650PAHVS+3p+ZLxcvHJDnBXk18cw0jimwCbcANls/cDg/HZxP5peH03DXl02/I2YpuIN0iC5NhTaDjZQIXUYN47RkiqUHS/w3Fo3pqyWWaP52QME0W4hrtBU0H7Z05gf6jN+ljloKgIw/BSZvS2vpr5ENTx6T+i34ai/NVfeXpQ2RxeLqFoBn24is/nxPY9n0MCCOJydyqPRz0Wk3ijZgauDBlF/wqKY9XUYYUUPFRX2Ew9UiAZEkp4M9U29l1P6lRVxsILvsrj7jQ+Bh+RzWQEunBTZiwxkQAoxhDfo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deb3d43d-a85c-4b04-a421-08de4d2c5260
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 14:03:09.0286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4DmFJma/c6CaYiUCf7WC8PWG8azB29ceyMSqbXLvTQFOYfIk8BdBddHfkYbB6/HYJP6IBuK1mQJIkzW0iWrPCOJt/cKmxI9OFpdHSKonfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7289
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=879 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060122
X-Proofpoint-GUID: Eq9oO61VfCWjf8Br6bumX4amMs3g0USz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyMiBTYWx0ZWRfX1ceGVktgBOTk
 WPiDA1T13YSg5iOkl/rAQdus2N1asFqDhcpcVx6WSPAQxMNR8pNdutooE+X6ac9Fr6d/H4uCXf5
 H/Caht/J1bNEDMHfa7D+9LIQRlvltcygLqnfdHa4Zavah0QdQk5v+gAxFb52pXVaBVSHphuvoT1
 9FdDLLZNTRlltHB+9QkTrb4k35likCnCPDNzhg4EKKVtKozP1Y7GB7CqICWsfwYG2+iw4+yr7oE
 RLXzLlmnCoe8vyydp3zwRDaGxb3Nr5/x+Q1BeKZq2Q9gtC67DINQ4VNu3QHN5Q6reati3IpzOkU
 5+HIk31+OBY0nsWdAqN7Rf/pw+QYUXSPbAqzsCEwNjuD6fbIuzLUnZ9XiXgznx7s7hZ4otCTtOu
 W/+H9CXzHKmBheerqWkJRAUxDm3bO7pWdYPeSNuk/ROoJIniKcswERrwvhkT/Mj1EKoTzaLhKRV
 oyKMnKhYHOCjaNX0fPw==
X-Authority-Analysis: v=2.4 cv=J8unLQnS c=1 sm=1 tr=0 ts=695d162b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=Lc44iHDdC39_mrYJbB0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Eq9oO61VfCWjf8Br6bumX4amMs3g0USz
X-Stat-Signature: u4ttf7reqwfbymuiobnh5ebazjh5qpfo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5AC554001C
X-HE-Tag: 1767708207-504605
X-HE-Meta: U2FsdGVkX18T/M7bta+wkfk45/K8sKRE/qiuBHngihK1cszZPyKFyCMn7/q2c1MsITdPdcIVHpvK0OL5RFHsgaGia72AXL0gsI1uMj2ZPfe/xsAFU034rmvH72lnDcB18mAehHtvw8gvlpY6bGn4o6aWWVs4WpxhFuNwmmI7zndLCPnH3r5RJ15HBotOR1a0Q5PGyq36Wokl6uiuON81WlCo8VGYuaA/PG1TU2NNhY/uHIh3ChDvtOLDx+/pNQ/euxD+CyWBkv2EIdwmoAhl5mQIDXRwWz5nWuQBtA0Ygv28/FuJOSvQS+X4yn4d7p54iFrsaeZIqMlT4I+YfEPgI0sDFcBM35sUY1/fNHpZKkB9N9BneiCxyrFO/RZREP+mORweFAxV7hX04GPcMBUiuzt8a75g4HvPd1+YQ+fqlYujAch9Gq2AsjHib6Es2wxQYQlYHnVXCYq0zDipGyg7ABPVB2LKCvW2GSPLqk8rSCH5epMUKqE7dlW4TxrKpNAxcLnK3VUXTJsBpRNP8LeKUn+ZyIf9NsCdDkaNA52NdWmpHIp4nV2qQBH0MPmHo9kfWn07ISlwATBI5zI9GpSz1fNih8qAJTrj0o/X9XNRIHv5B9qlcinaj4VHmxbhi2ZCyMOtoxmycbCbIt8zs4gUdjqpfmwcFnLAmEwugEi66aZDjgHjHhSqMb5RpwTb6IKtwsIDZWFbPW7grhAzZWk+aK5RU1ovBQgesUyomC8nuRjW1qZg7FDhgmzBKbg332aRkLU/hAPy6IGoWSVcvmfSMi/kxaZm+P59fo5zmWDFfeZaKM/Ag6pIG+kvGoiy2H4FCp/Nsnlu5PrfIa6JvYadqoxDAJOepmQtAHzpXORfh8yhvfP35aZNk/Qd/4g6G4XEtkzqIZpexkoW9sB1yI31QquR2tdZlGhvX/q8bZVmfZqlvJSFcqSJI79MjjcuIQhyBQDb3BwI/aS08nS3yhC
 AzXNU5fY
 1YMKksqVdaFOTAAFQC0dNvZo0DakfT+TGwi5aVzZr7o6M/TZznHYyipN+PcX1sXFCFjW9Ej/WTRTEeJidvdZbLAUw2x+6jd7OWMTJfJu5DVP3l6VrZ/2mfcC9CkmMlds2zHw5k6HsdxDsypLJsDeJrYaQhtAjk1kM5RgPPilmK3PeBOq7mWChrZHPgPmWYzDK83XOr2LmDkw3v9tB79WUcEakYbvudjr2me9ciE3GuB/WlQFcRl6Cp5BeN8vFHod+msj9EcYYWCgQWVgHM+67TOZxZ/a0Dn74qdBMLpSlRqwJHEHNar5+eWyVUs1ZcKr4FiK4pucIyWp3nk7HhJPRPatjJWnj7b1F13Bn9D8i9CsHAE9amePDgEovOI8zBFDZ7r0WqBWWOimcxn2YoNdqiGrgKqEJf5xHt5c4GfOhebouZpo1lnw251NAaYJ4iV+DmPTC1EiPUuCSI5CUFMWRGq1NsY4LWjTbv55Zy8K2F/2YnVUjGCqCjxxj+HvCwi8xYa2WbO9xmf5WaefNiX0SBGydfgZefBtRLaW7pSl97y/Qhf//n9Sky7ui4AGdGPUpR8EeIiICeC8eKKo3mvV9WNXT+mFMuwA6qSb7PzfyY1QJ9Tp1ogDHqZDga1I9+qU+mnqLJhho4vIBi/7Qgfs4D8qwL/UQ/50Lcc4Cj3bhTdr/cyvP+A3NLH+66rVctMgEpnaN+pWVKXrf+Bo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:38:44AM -0800, Suren Baghdasaryan wrote:
> On Wed, Dec 17, 2025 at 4:27 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The bulk of the anon_vma operations are only used by mm, so formalise this
> > by putting the function prototypes and inlines in mm/internal.h. This
> > allows us to make changes without having to worry about the rest of the
> > kernel.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

