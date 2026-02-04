Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D359DE9537A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 10:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39EE6B0005; Wed,  4 Feb 2026 05:56:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D180B6B008A; Wed,  4 Feb 2026 05:56:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2276B0092; Wed,  4 Feb 2026 05:56:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A65C46B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 05:56:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B1E51B2096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:56:35 +0000 (UTC)
X-FDA: 84406470750.13.61E99B5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id C3EAB1C0009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:56:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qyNDyBl1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IPaOATh+;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770202591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytSEkF6+s5S9Biq2y6Y0q/BDM/LkERBTa/+kuuDcEp8=;
	b=6zlMyQsS0fZZKxuJ7BAjjLdJsB8e9eU7HKfZXuC8p7szRF6Qd0h0EBZ4YiDq95RUBzk9q7
	rnRIgVJ5LLYTN86jdWRpoAWW8Gdvn+MQ/EvUW1g1/vRoliD8OTUG9rTpWUnKGwHOpF8tqP
	tUatEvo2niLnr4nQf9VAVuqyUoJaJT8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qyNDyBl1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IPaOATh+;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770202591; a=rsa-sha256;
	cv=pass;
	b=HqOhWr7zRE7M9nLw5n0K7QcJiTfhXXQJQLRsMkkjiT5QRahqnS5jn7UTLwDXgDPpnqILGu
	sD65bCvkLW2w8FXtsv1CbXfqreRkB0s/cSAtQBGSDq13MOr3TiCHu5PsDN6R+atHRq7TI/
	1IfN/bU3BjNa4fY1BKvSnp0pC3aUtsE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614Asl7q1423580;
	Wed, 4 Feb 2026 10:56:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ytSEkF6+s5S9Biq2y6Y0q/BDM/LkERBTa/+kuuDcEp8=; b=
	qyNDyBl1jvdewHrkxVpntpBya6GZoVdtyvTdTqtws7aSAW5rkbZwMzDuHW7NuJrp
	V8NCArrgDtxjaeGSad/PU7UpL2q4nFkVmt6Ce1oldtiw2v44nw6FWniR+iEXUY5p
	MMYQH0Ilp4T7u9YAvnNQ7YAegPCOSbDSIeazFPIG4JqYxTJLScpGagWUsziSbSkz
	z/cCANtc0XamVUUdvRG9seARpaskmhcdoJqloUHvWJfFaPXzKZVzoH0IPp4YK2nc
	EINeWpFmUEoKU1+oiWYZYL+Zg2Uv4gQM34LrK9tbrTuvEVajyo0TcwnBOeEXYmSr
	flUMQrv0RiYx940Yw0D1fw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jsqhje1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 10:56:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 614Ag8lr018710;
	Wed, 4 Feb 2026 10:56:22 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186nt6pm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 10:56:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xilloSI5aohPlVZhUdZ3814e6ZYqBGfKeNHbOwcvlejtNQADCXHUF3DPaH0D6prI0SgMbC9nUbrkoKJYd7xKsUc9T5jnPNgBBx9VPwzSQM74sgt7cG/qU2bGzVO7SA3UOsuuZTKbIkdcC+vKGfBM5+vzfvNI3jntYDg+PFCeceCeJdcJPjyW8td9Frn2NgJpV+KmPr6ckxxUjMS0uZdxTe868/NwIGjVJRSl74z5e3SWU573Ucmgfhd+RhkR5sqz8thhHoYBknIFIa/gwPZ3t6GLVOfxspX0SSUkV1mk7Ll7U/sMgykaVP5XIZ13EdrGf+m6AIOEeH13fANyd2Bpjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytSEkF6+s5S9Biq2y6Y0q/BDM/LkERBTa/+kuuDcEp8=;
 b=Fgpich0cQJ+izVgbspG6byxQ0j8aL2sDL5QHMLKs66bZnaB1Tt+K/oXgZjszqUGZaJPY2ZKtZSTm1q9RN3jy8j4fqJFtYfgRAWv+vyCGzKqNADRmEsSyZe4vNaV4K5Z/HnmxmDZtomSk7KiLSazm3bPHNN4wFMr3rfrwmLzJ2ieznHlR5e0choYnU9eOYaexh602DBo8mt2LR/0/bApVtTHSvlyS2zSZNljCGk2C3bpWIksEAmv877cvIIXZ/VEfyB+2MRcvd/KyBNMZZoWD8ouKptlzYFDYNajxw/n8Vne9T7bo6FHEejj84ZquqrBlOGQr6VqHIL4EPku4Ht9gfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytSEkF6+s5S9Biq2y6Y0q/BDM/LkERBTa/+kuuDcEp8=;
 b=IPaOATh+zvcX4UtCc4V7UZrSc4nI7mf4FDe3K4BXfq9/SwTk8poNq8sNc3xU50vuoiqBsbbTYl07ex1DYb1m5jF1qIHaoZWzfx+f3rg0t8YQqmSPIS8ZDlWIublnwrLeeWRqyfY0M8BE8Y1Q4Sp97ILvQObbAZ258iL8n8PZLk4=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by CH0PR10MB7409.namprd10.prod.outlook.com (2603:10b6:610:183::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 10:56:18 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Wed, 4 Feb 2026
 10:56:18 +0000
Date: Wed, 4 Feb 2026 10:56:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Usama Arif <usamaarif642@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        hannes@cmpxchg.org, shakeel.butt@linux.dev, kas@kernel.org,
        baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
        vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, Frank van der Linden <fvdl@google.com>
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Message-ID: <9c1809f0-8c8b-4eb1-9ec8-6c00fe3097f1@lucifer.local>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <a0c6c8d86ea05dcf5ff96a9d48d6ec79948c88ee.camel@surriel.com>
 <7d246914-6077-4dc1-bbcf-8dabbe6183e7@lucifer.local>
 <2B979847-CED0-41AE-AEB1-BEFB267B1E14@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2B979847-CED0-41AE-AEB1-BEFB267B1E14@nvidia.com>
X-ClientProxiedBy: LO4P123CA0451.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::6) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|CH0PR10MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: ff5f51fe-b1c8-4fbe-56a6-08de63dc0681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2xBN3JBVUY3alZUVWtyeDIwVDBlV3ZCSlN1SWUrS2t4QURvYloyWGhGN04y?=
 =?utf-8?B?eUQ4NVl1OVM1R3gvdnVmVjNDcEVqNkdXT2h1R1J0d0pJbWRJNVVGOGQ5eHp6?=
 =?utf-8?B?SGNQK3hab2hRaElUdHdFRVZhM204VFlKQ2Q3TTRwdk5tWlZuSzhzSmdNUFk2?=
 =?utf-8?B?WnNNTVJ0UzhyRmc1TlBEVSsydFdLTUhzOTNRZGIyTjNXLzNDdmRJRDgrOWdn?=
 =?utf-8?B?QWErcWZsWUFibGhFVEF0N1REUWlIWmV6dVVKZmoyVXEzVVArUjhjZzZMWkdy?=
 =?utf-8?B?Wm5lWStQVGRjUVRjQ1h5cGV5bEV0ZmdzMWtDMmpZcktFMjZXdjJ5bnU0dXQr?=
 =?utf-8?B?STJDNEkvZWRRbUJxUFNzMG5WR2xFbUVkekduWGZyUitsd3Z3d1B1U3VtWjF4?=
 =?utf-8?B?dEU0OEJVa2sydnJGRWRBRFhiZlhPK0NrVFhtd05iZWFJN2diekxCT2RRSVlj?=
 =?utf-8?B?R2ViQnJHUkxLbmJYK2s4YTltekhxQ2xXM2x1YThvMnhFTSsxS3g1WXJnQXBV?=
 =?utf-8?B?bkdMM25MeW04UjFHaW5jVWxBdnc2OTYwNVYzNjdJNTNjbWdQRmk5V1d3eVJJ?=
 =?utf-8?B?SzhycTJoeGNtSFdFUk1MZ1d4bmV4N3NOazNtL2MxL0lVT0VMdk1wbkRSdGwy?=
 =?utf-8?B?WGUrSzJMampEcGR6TG9wdURWNVAvcWt3NEY0RG50eEtYUUNpdnZZYVhQL2dq?=
 =?utf-8?B?Zmk5SUJuejZ4Z1RKV2lWZGFHSkROaTdHaG54VjdFZVg1aFlVQWRNck1NUDdF?=
 =?utf-8?B?TGVnbTg2bHA4djVic1ZWRlRhN1dINTdtaXVSS0cyT0c4STdETWVxdjdOMzBq?=
 =?utf-8?B?eEhJWEkrcHdUZUhRRkZmZkVpZzV2SXNNMTJORzVWdlZlaFUxWkhxSjF0UmQr?=
 =?utf-8?B?dk9OMDg0dXlGcUVKM29NQ0RNaXoxOWxubzdrcmRvZy8xY0kwZTl5amtXalB0?=
 =?utf-8?B?T29EWm9rK3VkQ0M2Y3lXdUhMbXA2d0JTWnV4SWo1d0FVMGFpNnJwbDZDaGFD?=
 =?utf-8?B?WkZ6d2NENFpuYllkRXBqRjNIYzBUQUU2dDduRHNCNCtrM1owVllvVE5RRlF3?=
 =?utf-8?B?MnpiMjN3dVpiVVFKOWExTjdIa3FpRCtROGtiSXBYUWwxZGt3MExxQXAwa1Q1?=
 =?utf-8?B?elpLWVRockJMZjBPVk1oSzhBVWFPbDlRTGFFdHFIVHdXSk5SWWpNcFZ6dVVM?=
 =?utf-8?B?aUY0WUY3NU9wOEk4ZzBjaGNwTkhBdHdrd0ovRTVRdmt4ZlA5Ym1IRFVMMzhY?=
 =?utf-8?B?NXRDZnpJY1ZGb3kvUUljSTE2cnhXdVJxcmIrZlppRDNEb3I0QzBCNjE2ZUk5?=
 =?utf-8?B?SHdhR0ZTNWkrVzlmTGZpOXZTbmxNMTlYSytLRXdkZzEwSGliVmF6WTJRSWN4?=
 =?utf-8?B?OVNLc2RtU3JSVVo2NmsyRm1FWUNCWnhFNVZoRG9JZ3NJaVEwS2JLMmpGZlA4?=
 =?utf-8?B?V1lBaGFOSWNLazB6VUtaRWpaNVVaM2pNbDZpZEhITUJjUmozQjVWSS9qRm9V?=
 =?utf-8?B?TVFmUGhIY2NjV3FmaGlmRWUyM1VuakVCL2JoZy9xWUZXcG4reVlIcGJPSHI4?=
 =?utf-8?B?K0xEdTZnNEtCYjBURVkwalNnMDJCQ1o3bmo1Ni9pdlZSTFpKYy81RC9wVC9i?=
 =?utf-8?B?cUdSVnZVd0J5bnJhTW9GRzJqNS9NQllrRHJsbUkzL3VVQWRpL0dXK1Y1Rndp?=
 =?utf-8?B?NExBKzNQRTZZOEw4THg3N0J5S3F1VVp6UEEzMWNzZnUwaWpBZmR2MmRnRnlJ?=
 =?utf-8?B?OXdoQUZrdS9sUlJTeUo2T0RPbnBlVzBrQkQzaUVsTzY5dFJCT0xPSTZGRkdF?=
 =?utf-8?B?U0Z4L3NCTnlPcllYOGwyS0VFT0dScDlWREtYdGNyQmJMdG9vM2dabEUvNnY2?=
 =?utf-8?B?WFV2Tjczakk3cDZqYTRGdCtDOHZOdVU5bDIreDNPT2IrVXU4bEhLcGQwd0I1?=
 =?utf-8?B?cTR0aW9ScVlwNGx2L1h3ZEt6cWhYYmQwdG5LMWlPQXhyM0poTVc1WmlCS1Ar?=
 =?utf-8?B?NWwrSXM1U01ZTTlvYi9sdis5V2dlbzJ1b0huSmRsTUZpQ1NHYkxrRnVoeUoz?=
 =?utf-8?Q?pMhjQe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlVucTgyS1BOZE84Mi92bWRtbWFiaGhHb015VWRLWWF1RUIxZCtFM3hUSWZL?=
 =?utf-8?B?cW9heXVMT1NWd2FGVys4K25mak5lRDVEMFd6b3EyNlRUS01GUDJ0RzdPYUkz?=
 =?utf-8?B?MWNadUc4SEhsclZKUVo0TElyMS9pWS90blVISHpXei9XR2V6VFprWkRKSGdv?=
 =?utf-8?B?UXFaNzBKNlo4ZXpFMmU4cFhGMG50djJraGlGbmhzYzV6dllGOVp0NjVxNi9a?=
 =?utf-8?B?RjJuakFaNWw4eUM2ZlYva3N6eHZqTTR1aHJ0UWsxclYrKzEvWStWdDU1dFhk?=
 =?utf-8?B?Z2RlUVVKVktxeXJvZFJVWC9aTDc1NkUySjRSRmo3K2J3NDhGSk1EaVVBSGlP?=
 =?utf-8?B?S1ZoUjVRZVVqMkdhbWdvdUdFZkpzOUR3NmlHTjl6Zm9xTGc5UUUxRTVTU3cv?=
 =?utf-8?B?TDdSamJTaE9nNlBSMkVGOHJDV1hpVzQzblp3VmN0bFhsc3FqTGw5QjAzVVdp?=
 =?utf-8?B?am5RQURGZG5wQTZMMFlRbGtNbVlsMTZZVGZYdndmdCtsbjNtdGh5QXE2a2la?=
 =?utf-8?B?QVFnTGtGZ2FxV0JXZWEyWDNxS1IvaG5zUW1mbnpHODR4R090cC9jYXdHSnpx?=
 =?utf-8?B?dHF6NTZtK3BkSDlOKytVckVJZDdTbUZobmxwWm9aZElVVUJYU21VT1d2bTVw?=
 =?utf-8?B?UVdPZVBPMnBaYzRWR0RRNWhiWFZDOG1FUFloVm1BZ2NZOFFCSGFQcUZJblZp?=
 =?utf-8?B?U2dERjVVMXYzbUlBRm5zWmJzNFpUcXBDVktFcDJadWl6NVkxSEk1WHlvY28v?=
 =?utf-8?B?bVM0V3hDR2taRms0akdtWlE2TlRJdUFEd20xMHNnRjVKU09ZcnA2VG9lL1Ra?=
 =?utf-8?B?S25IRDNrM2hrRjhwRjI4c0hpVzZ4Q2toSlZpTXhacmozMVZJTVBzTzBDbWV5?=
 =?utf-8?B?V28zTElVRGV0Y2NwN0hBL215L0pmRFBhL2VReGlZNlJLSWd3b1JacFJWYVpt?=
 =?utf-8?B?OWowYVdISHpwQVNGRUtRbGVxN1ZMcGZRbG94R3NHdWRHd3VIQ29ZRHVBWUhq?=
 =?utf-8?B?TWJpQkxNN1ZlNitnMFNuVnpsZkpndUgyazhLR1kyQlBDWGhtTmRVM0J3WU5E?=
 =?utf-8?B?bmxxSVNvYTg4ZSt0Wi90T2FVeFUzUW95WkJQRzhzU1B0MlNNNDd4SDFMRnpo?=
 =?utf-8?B?UTh0YXNKOHBWUmovYks0ZHZGOUFIQWgwbExkbENmS0MzczBob21OaHJBcFJ1?=
 =?utf-8?B?SlIvM01oNWRVTVRCL083aS9JMVZOM2IxWVBNYm1JSlhhK0lSb2QzZjlJKzBz?=
 =?utf-8?B?QjhwTmJLc0pSQXhZWU9qU1B1MGNxUTlDcktCYVAvUWt6bjRRelhDcHg4ckQ1?=
 =?utf-8?B?WjJuT3M1L3NJdFVGNHJRenZFUmI5VjAxMEk3NWxhbkVLZEh2T1N1ME8wM3Ev?=
 =?utf-8?B?bXlybjd6S2EzSVM0eGxMNUtmUWFVNVJmQ01YSWxUWWd4dVVEZjVGMTRQTUZB?=
 =?utf-8?B?SzJKeHloSWhWRU5uOEdRL1FtVlNrWmJNOVVGUDdERHN5d3E5TzNoZ1h3TDBn?=
 =?utf-8?B?bnNLeW5XUVdYbFFocFhEbnUvN3gwdWMxYmllbDRRdjdneUsxaUFoNGZTaC9n?=
 =?utf-8?B?dkxEd3ZsM2xPaHpyUmU3NmhKSVRhWWlIekhORklUTGZhUW9yOUJmWTFNcW9G?=
 =?utf-8?B?YmtTamNrT1BFZ245S0RhU2lHSzUzSlBsV1p0UmwvbXVkc0xCWTZlaWZySGdk?=
 =?utf-8?B?RDhBeElkVFM3TktQaVp4U3lhY1JVenVHZ1F5RFIySHl0dzVhSXhIT29SWi9M?=
 =?utf-8?B?RHJPcFB1QVZDOVNtMHlpdUlmNWFoQTNSRWZFRWpObXJNVEZoZWdFS2YzaU5X?=
 =?utf-8?B?OGJQVmR6bllwUGpkUVo0UTZ0Nnp1SUNQM1JsV3d1aG5Vc0VlcWl3VDNyeGJv?=
 =?utf-8?B?cDhoaGFtRXhuM3paakFtTGNZaTdGcFM2amsxd0Q5emlGeEozbENwNFhCUlZH?=
 =?utf-8?B?SGNhVXVrV0lhekV6eCtTU0N5M1JxMndCYVBIZ1BIbUdIOVRoOGR6ZzBQZkRu?=
 =?utf-8?B?ckpGcEZDRlQrTjV2SDhVQ0hkMlV3ekV4eGZJT2V0bGRnY2Uvd0k0MXhxYUM5?=
 =?utf-8?B?MWZKRTBuZkRhQ1c3d2cySXVXNFR3NXNKTnlHNmdFVXNRd3M0aXB4cHhiZHhL?=
 =?utf-8?B?QWoyUmF1U0FvT2poOFpUL3MrNFB6dFlVZ3RJUW1yWHQrYm1MV2ZMU0o1WnJw?=
 =?utf-8?B?S21GVVhJdlVtbXVPZ2xSeDRyUUJSYy9PZW9YZzNrc3JuQTR2VWgzQmhVQVZo?=
 =?utf-8?B?eDIxS256REx4VXJkWGxoOGt6ZXZZS1JOT1dUMzVacDdFTytib2dGUmdienEw?=
 =?utf-8?B?ZEcrUy9vUjJONTRRMWYxalV3bWpHNi92OC9iL1ArN1VEek5BckdXRFc4eitM?=
 =?utf-8?Q?C3qMYRWeya9JSjW8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ULWli0MHoP9awrQLFIu3l8L3Od0NuvfUMfasunPeUaONE3kxP+7ZL0q2YQEvrl+tHUZlVLRKMY7zVC9QzBRVOOClBQFPWIvfDoPBvCKSHcUepaUYS4xrCnSFB8QRF7OwNs5E1yDq4fL0sEg7ZdKoViBbbIUX+WSPYBDBpYjf3imITyGhRFEBfuDQwGMOTucRYqvjRSK/Vqu8P8koL1eVhacRKQEPA4BiH6+UmH4jMQT1YGq6DaGvq4F8TI+78BlU34xd9S7kZQo6Oxi8/bNSn5/fN+KJiV+yMDckCt6SxmQCSWDKIkWlij5tg7Ksy451QShUO9YMWLTc7rd3ZN4aNMfft6HwSLwreP9KvUSbazMPE4lRp7es4HxQ+TmBcaFNDUjNesn2rTok/HrMDk729DC0DHKFY7ktyQ9Ua0FMKhdjSlhqnc/V12zsCjx5jAZBeNfsS7kFgVUnb3bEjy8aCD2NbfIzpptKi1LqJ6omXwe3NwkrrDl2NcA4UC7dCAvxvPTUozSECu0MpEg+QIsobVXCPw3IKy5EPPB72BY7r4WRZYd4v0Ght4fAvbNU+BN9B3QPBjtOMcQNB/27Jb5fVsBC9pdP0p2QOhnHlKWvaTQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5f51fe-b1c8-4fbe-56a6-08de63dc0681
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 10:56:18.7779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1IFP7RIxBNDx9qO0RL56GVsU7IrPcKnjEF4uc8fs6fjtYvVyeYii78mh2hJDgQh+GwB+ZoylkiQbdWHUDKkd1P5rx4rFejKxYF2mQcfZak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7409
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_02,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=970 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040082
X-Authority-Analysis: v=2.4 cv=Db0aa/tW c=1 sm=1 tr=0 ts=698325d7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=D19gQVrFAAAA:8 a=07d9gI8wAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=UD7uQ7OiAAAA:8 a=sWJDOqgAFd8g-6gPj0IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=W4TVW4IDbPiebHqcZpNg:22 a=e2CUPOnPG4QKp8I52DXD:22 a=Zkq0o-JBKtHmMz2AGXNj:22
 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: cJAZWGiPK_Tar2ayu2N2491vEOnsOuoC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDA4MyBTYWx0ZWRfX6mqKFUyqbAwq
 fctxYCXWXhM371fdM104hyIwqDZ3J1ABc49dL2dZFOqUqZSVBi6j87GqmoUVIYrhlCfSAVl44jc
 cr28WWEpi79OqyqZR+xN670Q4esGWjOIDb8PdyrQLOHMEgkKCcBm+Pho8xLi47OTAe5ON0CH1iv
 l+jrXMJShAWGe5sd7R1C1qkonLB6EY9rieOuS03Wa2o3LGGPS6w7b2i4OKQTsiG7wja/ejlTRu9
 L1yOMH3SySL5Ck7PEqKrM/nL6i3P5x6apAeu+buPYhn2PsqHyFrAVFAcAMBub3d4LD7VMEIheJv
 KEsamtb+rVlRCUpOsKFwWxHQyyD/DWeAgWw/gnNTZhD4MPUmzN2y/ELfITRP2mDlZ/7WpLAJ3kj
 e1POZzfGAGcg2bIhu3sJUPV1YtIzXrdIJXR1+wtPqD+00yz4fT/cPpT9WqD1JpBiAcbgMJaUAbS
 4m4hyo7cl5vW8EVY3dZEC2Bb3NzCox7GcgnJ9rDw=
X-Proofpoint-GUID: cJAZWGiPK_Tar2ayu2N2491vEOnsOuoC
X-Rspamd-Server: rspam12
X-Stat-Signature: cm5yu4itdcgqadtduabmgn7fjubibpgb
X-Rspamd-Queue-Id: C3EAB1C0009
X-Rspam-User: 
X-HE-Tag: 1770202591-440148
X-HE-Meta: U2FsdGVkX1+SavvzgvbirI4aPJOCanM5XXizk/8Jp92bDGszi2bVBcKdcaXXRqpZsOAB8rzmErR/9exNnJazuVJTUAghZLuL6G7mFARVinsicXxu7b8ePLwVAH8bd5RibhxDX0dP+cs+4E+rLpNGSBCJ+Xcy/BQ52CRuxvTE2u6yCAHCHb4FTAjLCU09S2d2XaA510vnLxeVldmhnqPym3YS1Dk+1G83Wt17VxGXq1BtxX3kdNEh67vTqWmxaHz6sL5C6qdzbEMOdHy9vVSJnHN89aqVpLJdDobEsvl6NETpOVXWDpsGLRJI7iqzmgR+UcymUQWXj3v3dCXjrApI/tpurFNZ5ZddngUQ5eg+4tBsY8jVK1XdPgYAEyB9kCOOqKNzDjV0gQ6YvGSjc7xMO1JBimoHgdzcoCagVuadla254m5lbGnG2zKfNy9zP26b0oKDWTLTx6DVMBmXIn8M6ydqXeowim8Zc4DRgbxN0kbINMJVwBuLkD3s/wJrg4F4Y8Qznxvvgwt6fgfYBc6maVvKs17TAJYdpuyy/PjtuqVmdgKOQ/3u/+kZAHz3qiF4x9p/d4Sp1WAIflm+imXjDtHWKndWsBMP2/d8/cMJkNeZpDGy5hlRfBwRkXqQ/XLLTr26xP9qv3a/hLVI9BUf6HqUJ4GXHG2X1rJnShICDQevymsWA2D1NHgaelv8ytuTENJCJ94SVYRn8Vgmu8ylc0Oo5KnbWInNV2oo0e2qsNIq8IzctIPZc1OVZm+THVQA2Vcxt9N7fSncKJaZ2l66LRMQPr+k0KzAh+GRWabvaRryvM5pCqWM8HRaKQj41xHzPeRkmWyuakv9jcv1OE04c6FouOFvVF6EjY79AzAY8X2euXMIgpJvDilBOTsG4O3zk1kPnF6KFrXVEX4VC3iTW77VyqVm9d9mSaBpzQvRIPP2CBYL6BWsiBBh25iOS7EVaF5Ggxfk1vszfc5ARFa
 rbEBb3d4
 TyDnTKV4Amenm8l7ExGdX4xOMh2jj6XWKQBJreRY42D004nMkDMGaz73VwqRVCMqZNAwKTqBVpWmvYmGDJO9MIMEGcmFMUp5r0t2NQYUr4BfZnkBw+Uzsb7QyeLXrwYudi/2bmW0CEvpyUlNVu74t2y80E/I3tISh7FvdpnMUSgR2R8nXrMyrdPSXP4VPuhp0b7uvYvkUbvbVtVURO7hNFKvLtVc0lDgODt3H6nmHUlPmgtxR9rre3NOxz7ZUvOrqGbAlkPqPlHkC//NEUD+DYRo/sMNsJ7i2P4054YgozjntaQ7Wt67IMl6PZ45CNGH1VVhBwsSoTm96LvO8DXjb1YRqKaPiic3+TvTC1UqW4Qz4hTwTnq4887zt7AIiyxS218zkyRCM4jdnR3qpAxHDXSWjTkjqJhTK6UFkDaCdC3iymDOTa6eh2lBQHgJ/gW8vJyAnFpJjZ7PQj2RGpkqqYQA4SDv8wmCMdClEVI//dLdwk7mz/GF4ApkMILERkrej5TzbZAep1hShAsG0VOe/AE0o2XtqEvFK5ndmUMBBtuemogmt+GkDrm/1WVGIxWBGbXe7x5k32baLjMBvU8NWi6+mbqmWZu8Wbw8E4bz5RX0J3yA+uPp0AqLkMomlkZIO946VSoQJYL2FCdSpAI5T0LDrUtJ/ofF8f5T9ThhT6dinXeHbjXJ5xXBfoSfsXwGs4FpHsQw68QJp5S3aDBgOBefFQNIlDUkMt7wq1uugqgAjbdhgKC7TLWXZgOZPsP7qTac1KrPoJM1k8n9xJ9tGifwCh5Vllg5K0jIhtTZRkFzyjHUfoBC9ZbIgtJ9N4IWboU3llEhR1i0kW56O1+ih26HUOzwb0AaVA0DnrofUmiY++RAgI2ocWW2U5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 10:50:35AM -0500, Zi Yan wrote:
> On 2 Feb 2026, at 6:30, Lorenzo Stoakes wrote:
>
> > On Sun, Feb 01, 2026 at 09:44:12PM -0500, Rik van Riel wrote:
> >> On Sun, 2026-02-01 at 16:50 -0800, Usama Arif wrote:
> >>>
> >>> 1. Static Reservation: hugetlbfs requires pre-allocating huge pages
> >>> at boot
> >>>    or runtime, taking memory away. This requires capacity planning,
> >>>    administrative overhead, and makes workload orchastration much
> >>> much more
> >>>    complex, especially colocating with workloads that don't use
> >>> hugetlbfs.
> >>>
> >> To address the obvious objection "but how could we
> >> possibly allocate 1GB huge pages while the workload
> >> is running?", I am planning to pick up the CMA balancing
> >> patch series (thank you, Frank) and get that in an
> >> upstream ready shape soon.
> >>
> >> https://lkml.org/2025/9/15/1735
> >
> > That link doesn't work?
> >
> > Did a quick search for CMA balancing on lore, couldn't find anything, could you
> > provide a lore link?
>
> https://lwn.net/Articles/1038263/
>
> >
> >>
> >> That patch set looks like another case where no
> >> amount of internal testing will find every single
> >> corner case, and we'll probably just want to
> >> merge it upstream, deploy it experimentally, and
> >> aggressively deal with anything that might pop up.
> >
> > I'm not really in favour of this kind of approach. There's plenty of things that
> > were considered 'temporary' upstream that became rather permanent :)
> >
> > Maybe we can't cover all corner-cases, but we need to make sure whatever we do
> > send upstream is maintainable, conceptually sensible and doesn't paint us into
> > any corners, etc.
> >
> >>
> >> With CMA balancing, it would be possibly to just
> >> have half (or even more) of system memory for
> >> movable allocations only, which would make it possible
> >> to allocate 1GB huge pages dynamically.
> >
> > Could you expand on that?
>
> I also would like to hear David’s opinion on using CMA for 1GB THP.
> He did not like it[1] when I posted my patch back in 2020, but it has
> been more than 5 years. :)

Yes please David :)

I find the idea of using the CMA for this a bit gross. And I fear we're
essentially expanding the hacks for DAX to everyone.

Again I really feel that we should be tackling technical debt here, rather
than adding features on shaky foundations and just making things worse.

We are inundated with series-after-series for THP trying to add features
but really not very many that are tackling this debt, and I think it's time
to get firmer about that.

>
> The other direction I explored is to get 1GB THP from buddy allocator.
> That means we need to:
> 1. bump MAX_PAGE_ORDER to 18 or make it a runtime variable so that only 1GB
>    THP users need to bump it,

Would we need to bump the page block size too to stand more of a chance of
avoiding fragmentation?

Doing that though would result in reserves being way higher and thus more
memory used and we'd be in the territory of the unresolved issues with 64
KB page size kernels :)

> 2. handle cross memory section PFN merge in buddy allocator,

Ugh god...

> 3. improve anti-fragmentation mechanism for 1GB range compaction.

I think we'd really need something like this. Obviously there's the series
Rik refers to.

I mean CMA itself feels like a hack, though efforts are being made to at
least make it more robust (series mentioned, also the guaranteed CMA stuff
from Suren).

>
> 1 is easier-ish[2]. I have not looked into 2 and 3 much yet.
>
> [1] https://lore.kernel.org/all/52bc2d5d-eb8a-83de-1c93-abd329132d58@redhat.com/
> [2] https://lore.kernel.org/all/20210805190253.2795604-1-zi.yan@sent.com/
>
>
> Best Regards,
> Yan, Zi

Cheers, Lorenzo

