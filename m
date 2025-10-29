Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FE9CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 07:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A978E0038; Wed, 29 Oct 2025 03:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1523B8E0015; Wed, 29 Oct 2025 03:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0191B8E0038; Wed, 29 Oct 2025 03:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E2B548E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:11:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83D2249EE4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:11:06 +0000 (UTC)
X-FDA: 84050280132.10.14794F2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E61E140006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:11:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TMWy3iyR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G1U6i2ax;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761721863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofNLMpf9FmSc8nXWpoMMsufQCbFZY4fRQtOKFBxqHKs=;
	b=tIsaFFpVdstrk1c6y9LyiZA54ZhNcCj3G6kzso+DSM3elBtrrwB7pb41GopVd8wt1+bynq
	vNvx1CASP8265XTUVCYV30Cc1kBllpRZHn0V7DVzO4o8V57UYlxK6MufMyG+w6CPMXelT2
	RK+53j5NigsAAKXXJ/QguwgfdEm33qU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TMWy3iyR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G1U6i2ax;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761721863; a=rsa-sha256;
	cv=pass;
	b=iUPw0BUXHAfFaYAuvJ1MscX3pyAYEgI7eSC4SRxNa3At6P8Bjy2c/VM4giRxDlYEsc3PNq
	A0OzHM8i4uOurzBSBB9X91bd37NWMvZEIfzuV9IHUCNLPSAjCFj67IHU9rGfzem1r+XJII
	B8XK1ECnAHRX4g022g4sWzBOV5p7nWw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59T5nXD5002600;
	Wed, 29 Oct 2025 07:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ofNLMpf9FmSc8nXWpoMMsufQCbFZY4fRQtOKFBxqHKs=; b=
	TMWy3iyR2ND/dJDYjJRSYMGQdkVEq/tK2sTROtSH6jmP2a3QuC2fpXtGNC+guEVD
	e/0GCK04U7V9rgDJbvQ/X9l/8Gb6lMFPtnsTbyi/IAl8Dm0BBmPupjY8/UwfpoJ8
	SUi0miDcIG5jTgK2Xf14PsHSuEWJf29B2EgqX5vWtNhK9LNIUsvtFfz394S4Vts/
	gKmK1Crhgxx53/6S/nMS/04IGuaeEn9YZ4brRHUtOOnvEBSXRJrR92WQOn7Q5iYG
	6sSiXbKWtPkE+CISLyouW16d8M/zqD/TwEKNIAkeA008uxMfyEf8+SZV7+2yFMCM
	kLQquolw+Z9UzCXm4kQnMA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a33vvgyry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 07:10:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59T73g16015971;
	Wed, 29 Oct 2025 07:10:53 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010017.outbound.protection.outlook.com [52.101.85.17])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34q79j9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 07:10:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQLq3XfEyqUoC3RNfxywJo5Qq/RaecJ1QjaICzhQh6rIj/AukwoeAk/u3pYvfDNccP5PwM4snmRt9qI2EOwiw1eEo76sHy213BqJ7RxzansiZZhqDbgOAzxTBwWOskpiiyBjhc8wYZ/sGStcl3xmPMUTkKtvqBBmQA3mkvcCYaop143eajqG9xDw+P2gbcvmvKr7QDPesMLrHs/8qJHTfZomAm8jRkXi0m7kTC4W5PXh7G57pokm16lbZu9MxQFCOD0ZX4JwUH4TvFAxbKoo2byju+kGSfDMSUgAGxbFO5nz1qyDFvvjTtJ43Q9U/JtLEztRgr2ujoXOl75cAw4mvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofNLMpf9FmSc8nXWpoMMsufQCbFZY4fRQtOKFBxqHKs=;
 b=OVHEJ2aNaEl5GdtBvV3HyFi0NheVWC5LHFDo0J3V/CiYyyaUVoqW75PJZzwN5Wcj/flG9p2pX+7mxsE4ab4sKXTX0EVSGeSbTbbj+hvWn12yyxQkoiSKmSap1cJM2wkWJ7km52po8jISb2V24DhFZYUBAHDkxZXt8hU0Y/BXz5G1aCRRiJPuvqUl+cHytg9xBhcEoH7A4t/Kuee4961M7g1E1j2QQeSu9ZxK8nBnOGl+PFp70JVtEwpMwsQB8CzOtC2XNAOV1mtfHhFdonuj1FYI7gyObqnJRGIVClYOR/JD1DsqKQ2+GvwKUwW+aUkA6fLgLOoBNcIm1tNBiwoo4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofNLMpf9FmSc8nXWpoMMsufQCbFZY4fRQtOKFBxqHKs=;
 b=G1U6i2axsB+2OQXcNT6EmHT1SEtGuH/IAtinlu7rpbCyGKOyBy+uv+Oo/ZRmqvd2jxKgdxsnbrH+pCsqWDSUSXYbIH2hQ7xe8g8n6DylG4GLkyNyv0eSzcQoRbIFg/7rjKW0HXW7YWt5a1TeonGClIEw7nWfBDvJHaJPzz4uwg0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN6PR10MB8021.namprd10.prod.outlook.com (2603:10b6:208:4fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 07:10:48 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 07:10:48 +0000
Date: Wed, 29 Oct 2025 16:10:38 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com,
        cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3 1/7] mm/slab: allow specifying freepointer offset
 when using constructor
Message-ID: <aQG97ocbfd0T-clN@hyeyoo>
References: <20251027122847.320924-1-harry.yoo@oracle.com>
 <20251027122847.320924-2-harry.yoo@oracle.com>
 <CAJuCfpF5gG63njY436vctG-Tzbco8X9a1w3YA=u1AGrRqxVshg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpF5gG63njY436vctG-Tzbco8X9a1w3YA=u1AGrRqxVshg@mail.gmail.com>
X-ClientProxiedBy: SL2P216CA0116.KORP216.PROD.OUTLOOK.COM (2603:1096:101::13)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN6PR10MB8021:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f552276-590f-4d81-06e0-08de16ba491d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3ZXdUhLVTFVdlhGeWJzdHRlU1lMeXhaRWtFZVQzMlVUNTl3VDVJZmRTbWFD?=
 =?utf-8?B?RVRDNGRtZzZQVjBURXZDVGlTZjIzS0hvbmpKYjhVZFBkQWh2aWlQQ0hUMEc1?=
 =?utf-8?B?MGJzdThJY1hWaG50anRJa0E1d1lqRXgreWRlTUMvNlpid0tEeFcycW9RZCs1?=
 =?utf-8?B?QXU4Z2oySkNHeG9nR1JWZUZVM2tiSzl1MWhVM1E4dW9FR1hkbmZiVUlFdHV3?=
 =?utf-8?B?eDdRajVlQWltOXFmcUtCeU9HdmdMVGM2UEZKSlNZNStPZ3pmRndKNmIzQjVl?=
 =?utf-8?B?RzZVZHlCc0tHc21yZndlQ0JPY09hb3JkVWlDa2cxMGV6OUxVVk82MHNJRit5?=
 =?utf-8?B?eEFha0lzNzhPYk01REJzb2J0ZHl5NlY4RzlHUVBMRHU4ZmM1bDBiZUJ1Um1U?=
 =?utf-8?B?RC9xbUw0cTIzZ0FUbEhTd1J6NkE2TnhiZzEzSXM4TktBdDFvWUJGNWZvU1ZY?=
 =?utf-8?B?by9PTVZ0QWplN2JUUVBCQ2g0MWRhdVhNTGxNdkxzc0hpZGFRa0tNVWNKUGNP?=
 =?utf-8?B?eFViMEF2aEJtMkNNVmZ3L2JBSmhuSUhoZkE3OVN6ZkJlNUZjVVZPOFY2Z1Z1?=
 =?utf-8?B?K0o1ZTExT2tQRWVXWW9uWUxnVlN6eVk4aTkwbk1YbmRacjg5ZmsrTVFVODZj?=
 =?utf-8?B?MlFEUmhOSzUvc1BHZjhmd3E3UDVXekZGZWlyTzBTeko0UGtqbjZPSTNvYWE4?=
 =?utf-8?B?SjhzUDhENHh6blJnZDViWkN1WVRmdFpHalA5SEpWWUN0OFM5eDNXOTRHTE5R?=
 =?utf-8?B?djk3anFXa3psTXFuZHZEOTdGS1NrWUs3aTE0a3lEWCtqNEh5VVl3QzhsdW9N?=
 =?utf-8?B?aTd2b0ZSbUY1V3BmSmc4TWw4TmtRSWNhbERQM0Rkb3VXbEFNMlZOZGU0TVN3?=
 =?utf-8?B?V0NVU2FTYTJ0cy9BVm5BSXltbFFtQVlFRk54SU54Vis3TmpNc1EvNE9hUnFq?=
 =?utf-8?B?ZVk0V0dHaFRJWFU3cXZSQkFMV0tlNVhrVE4zYkxzczNueVMyZU9rV0t1a1o1?=
 =?utf-8?B?TWpDNkpEZGRWTGdhRDZhb1lCei9ScVovZ25ORHA3SWpGRFA2Mk4rUjFZeUlt?=
 =?utf-8?B?SEEvRlFNVys5eTFIOTBPWGl2LzFud2cwWFUzR09JeFhLVFlnN3FTMnJMZWRo?=
 =?utf-8?B?RzYzVFBJa3JXNG1WRUlUektmUlV4bGxBN0RvYkxEV3A2RlhwZFZrSUFySk9o?=
 =?utf-8?B?RlJOZkNFRHF1Q2J2WjRTVnM5NVR5TGhseXl1dDJDM1M1NHUydm9CN1pvTFRT?=
 =?utf-8?B?UmhUcS9jRTlwdUw4WXZxcGtkWUJRUlduenFmZXlncmxJbHFJY08xdUtPNFlw?=
 =?utf-8?B?OFlTR0RWc2FLRDhnaTlnYUt6bzhVRTQxM2lkcE1FbTRha0N2T0wrTmtrc1lO?=
 =?utf-8?B?YlNCRmlaSWJJZmpkdlBDem1lV0pOeVVaRjc3cEVYU3ZvcUpPMzFXdE5TbS9W?=
 =?utf-8?B?T3k5NWpTYzFTVWRwdngzWlF6TkhjWVEvVFV1MEtUTVBFd0JLeEpTb204Sm5P?=
 =?utf-8?B?QmFqMHo3NkFldTdqNmh0YU9yZ3gweWF0RGRBcGlUQlRIV0FhZ0pOcmw0cExH?=
 =?utf-8?B?dS96YUJla2JCZEs5YWpkWEpvaE93VkMrSzY3L3dLK2xPVExVd1poRGZQTkFI?=
 =?utf-8?B?ZHRyRzMrRUd3SDBnQ2c2OGZ2YjdlUzFVakJuZWlieFlRbUJSSjdDWjFrditP?=
 =?utf-8?B?UngrbXV3bTdmOVlxM2FVMlpKZkx0czlRckR3YktPTElvVFNUekEySGNBdXJu?=
 =?utf-8?B?RGdxVTdjTTIvSEdmN1hDZXlMbzBoQzVoZm81d2JMallsMVlWbEFaVjM5eXM2?=
 =?utf-8?B?UWo0L1NtelVSS2FRZ1RlS0liRnJsVDdENDJGZjU3NGVaelczZDR5eEpXangv?=
 =?utf-8?B?eUs2enV3Rzc3TmIrTmZ3aVRrNjlQOGhUdG9YSzI3ZkJoblBkaHhyblMvYWxL?=
 =?utf-8?Q?pw1fLLN2XROZq81CDvXLGBi8+BqK9yX0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QS9IcHhTOXNnRzkzT0xNK0xnNUF4a0o3NDdUUWxya3NyNGtIYloyRk1Jc3dy?=
 =?utf-8?B?OVJxeWJObXNIcnU3TUw0di9sdVZkY2l2aFg1OUJDZGJWN3lmeWx0QmllMDVG?=
 =?utf-8?B?VEdqZ0prY3ZQM0VCNmgrdFcyVlpMOXQxKzJyaktPZ1c1UUZmaE1haXFwUlVp?=
 =?utf-8?B?WDA2NjdaWFc4WEpMQjJsa0xZNS93NllJZkZZVlBCNWljK2V5OWcwc2p2UE81?=
 =?utf-8?B?MGkxYWZTM0cxNWI2SDdJZFhYL0NtRDRkS2d5RWhnUmJIU2ZhM2kwS3l2alRJ?=
 =?utf-8?B?N05oa0pKeUpZRTdhTDJQWlY0clR1QW1CNTBjeUVHS0hLK29RZk1SK1JReldP?=
 =?utf-8?B?K0Rzd0JhUGhsOHZFL3hLS0xDRHQvM0laS25BR3Joc3F0Q0Zha3BES0xXVDFM?=
 =?utf-8?B?ZVYvY1lQVlQyUXdOb2kwWkdJN3ZWNHhxSFpXMEdQNzQ2WisrZDdhQUF5RkJE?=
 =?utf-8?B?c244WFYxNDB5UXdYa2tCaUZCZ2k2WG5laVFPK1krZTd6RFNmVEt6TzIxd1dO?=
 =?utf-8?B?YlIxMkpWdmJSYlpua2ViS1FvSzQ5VFlDdDRGYnNYUEZmTGxOaVV3dmxYdlBV?=
 =?utf-8?B?dytGUVY1MVJ4RlJ3SHRKVkNBTU8rY25pK1pUL3RwZ24rQ0VvYk5hUHVVSzl1?=
 =?utf-8?B?WGIycmhrRHFmcTlablg2Y3k5a2ZRbEZyT3NmL0plbmU3ZlZOMDhSMFlaTWIx?=
 =?utf-8?B?UTNrQzBZMGRoU1RrYTgrNWRSV1lrYzE3aUEzeEhDRFJBdk16UW9ZekcweWN6?=
 =?utf-8?B?dGNTQ2pZVGM0d3Z6RkYySXBCak10Sk8wN1VmOGR1M3lPR1VqSUZSR0YxRVV4?=
 =?utf-8?B?NnZRWEI2VlhBZGtOeEFPRWhYSzMzbk10MG1iamU2RDQ4L1UrMTdUZWlwdXFv?=
 =?utf-8?B?Nmlqd3lkc3FzWlo2QnlLRzYwWDVCRnk1d3Q4aFdraVFkNzBmMHRJeEpkcDRl?=
 =?utf-8?B?S21tVllrR3NxZEpiTzA1TzkrejhyUENsSk5QM0RaM01VQmxIZGxHQlNXNTd5?=
 =?utf-8?B?WWtEL0pDWDkrNExnLzM4MlRFV2JSU1g5cGg0NlRZS0ZZeUpyUkVIY2VUVXFx?=
 =?utf-8?B?NWFVVSszQTF1L2dSL0YvSmZwdml1UVViSk5VUWlDVlN3TWZIMEdWUmRlYzdJ?=
 =?utf-8?B?MkR0dVhrRFhQTnl1MC9EVHRGaHVtdnBJbVpReGp4QWFobmtiMzllRk41dDlL?=
 =?utf-8?B?L25uUVJrcStvMUxIVmltR2ttS2RQWis0bDZYeDlERjFVZG5rckZaSzNZZDV0?=
 =?utf-8?B?WWx1dUYydXM5L2tzSW5LWGx1WTFQUmllRVJxcGRWbGJUUGQzTlRXb0VnTXIw?=
 =?utf-8?B?emY2a05IRk5PdW5SaDRzWTlMcG5KU3BwOGV3V0hDUzRWcTM2Z1RzN2h5K0ND?=
 =?utf-8?B?WVZ0TDlOTHhNN3l4U28wbll5K3QyQkxReXpWcUU1amNrQ2xucktnWTQ4UDIx?=
 =?utf-8?B?RXM4V1g0d1d0aWJucFVPa0JPUU5LcHJaUmhtRkxKNE1NMmdOaUZ6ZWppWUUv?=
 =?utf-8?B?Ym9ZVlV1b3FvUENRQThUcUd0aVVVbkw3bDRtdUo3UXpQSnZHZUoxVHZyc2xU?=
 =?utf-8?B?ZmlsMS9tKzlReFFmaDFETkx4aUJqKzVaMnl0OW4zS3g3RmZOYnpxV1NTM2tF?=
 =?utf-8?B?c21DU3gvUktmbXdEZVBoYm1wRkZEVUt6cDVVZTBETmVsRkFFT0xZNVlkREZq?=
 =?utf-8?B?cnRCQkgwODVFeW5GKy9UNlNyQncranJhYTFjbGkxZE1GWE5BZ1ZWZDV3azQ5?=
 =?utf-8?B?c1VnUkgyS1p6WDVOSXdVYS9aL2w5aWNDY3FjS1Z6cHZ6UTArRTFSaFlQbU9y?=
 =?utf-8?B?L1htNmNrSDNNRE5EQ09SRWRrbWkrWGNuMDZXOW9iaDhMRjhFekhUNmZKNGZj?=
 =?utf-8?B?bStlcjhlcityM1FlMmtOaVNTQVd2Z0VOd1BBZGFIOFRoNTRqV3BRNDMwQ1RJ?=
 =?utf-8?B?RXJWb1lYb2NPaEczbGY4eDhncDZNdFR4QithK2l4SWhBcmxGSnRkWGNSem5i?=
 =?utf-8?B?TUNXcjBZUm9GeUJIcUc2STJ1SnJxVHY3MTQyWVBtcWh5aFg3M1BFSWVHM3FQ?=
 =?utf-8?B?aDZFRFlMdWFjV2dncEMvTUpUR2d2RUVXenVHblFBVmNObmlIVDRPUUhHNENH?=
 =?utf-8?Q?5gw1Gw2Na4djukh0Z83T+R4zB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l21yw5sjhOLiKcQf7sgHjUTImLvdaHwKRTnzKsC5miijk239jmDNa1JpWfR4Bsbma6t16eA/cQLvS+2LjybJYDtX4nmjtg5CH9fNylH0r9aDdoiWWcDu4Ng9Kh7uw+Ku3gSQqZmtMRdFYyPcNRcikAVwfGADksEpNpdrupNTUTTfmhnwcoQOGQnuiW9XXEthsg1YbPS15Q4aQPIAH4y44gwF3P1PwGIbEeqjJ39jjIGG1dV8UxUEa18g+GlR6Q4IMtzVppN682QCHuEzWYjZNDEvBl+e62yKqX/8gS/uMaVyIMvfBgLMn88CgBSt4pMUNP/ZDMR5jzx7C9r9/q6CyvmQ0GEVqgVQCfwyG0CHwzRoWH1k9a3riVQFxgODRDuZ+u2HZjkAytcYRh18vCqB41Ykg5UIrfUN37GjiZveEmrhkv3TszwqgOFcGdDf9Dj8ZCm3HMSV7OUiU5XhO/ytvFZVqDZhJvByWlg3LQ9angX9rUsUDTCw4bsBa38DprPMsN2OjDRZvN0IPPLZ1oaxJzcbibbEJRUwqvc7HZqJKYmLEb2wh/0oafVyNHsk6aY38d62PEJHm5t0xcTzO7MIZWVl0NPR/6A47R0jJQraB8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f552276-590f-4d81-06e0-08de16ba491d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 07:10:48.2686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDROHB36k0TUIW6j7EiJejmL/CX339Hr8Wat5Pp9iDF7HmhLW5of0tMOOtiFgx9HFR2520qNpYfp1BwgsZfsFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8021
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-29_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290050
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2MiBTYWx0ZWRfXxHcWEk3rK0Xc
 6dR1wBsf2kigqSik+roVTK/O+ha8XaR9cNOhzms3r/8NbmqpJjdsrE/DEeoOH6Cw4oshglkoobA
 OwZwb0mxfZ35emL/LUZWehlGQ/5h2ERS/hMBr8fpmtlUqr7XymiUwtSJaQ3/3XPTIVHhzG6hE4k
 3vZ+eehYlUW5X3QmaptNOCsUjHWFqiterVHICa4k1qqsGGuWQe1h0BZyl+ottFM8GiIaVfXJz68
 FdG+KY3Kk4sV2AMvulK8AoOhH5eUB4FSXdhHy1L0ymssGW6FKewwJ0+hxTz+tSaGcgvbiJ37U7A
 KflKL1nesZ4DRhishusBm2wPC8Ub0ELLDfDikbpDQcI1KoPD4Kv63NHJBcGeeVwdW7oFj8UsBSj
 hMnpgTLsX4qgvsJLi78VyBXLtxqjwGyAq1Pf7Naje9HEGSjWDGY=
X-Proofpoint-ORIG-GUID: XZ2mYevw3fe5zQ8MLiScwM6fUlZgRyfr
X-Proofpoint-GUID: XZ2mYevw3fe5zQ8MLiScwM6fUlZgRyfr
X-Authority-Analysis: v=2.4 cv=SJ1PlevH c=1 sm=1 tr=0 ts=6901bdfe b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=P-IC7800AAAA:8 a=yPCof4ZbAAAA:8 a=PNEi0H-t83C4m5-Zz44A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf awl=host:12124
X-Stat-Signature: f6dgagqth8m6wgqf9aj5onw7f4bdqke3
X-Rspamd-Queue-Id: 0E61E140006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761721862-683651
X-HE-Meta: U2FsdGVkX18MwTxhwYOcuxRrvgrDIX/NiO60mNgkCuBJBAt1SP13JDdt8+9NTQ/i4kESrEjnjiEIQlF6xp4W3QFDWRMB3ReUPJgVEgkU1+v62HCNVYtoMGaoknmZjSX3h9PZe4WmGR1azi6OYxzkaEiy8PaTIB91x+4t/YLEOd3H3FAgpfPeCfVYMVXBJ1upYsNt4U1SYOfMBjjsIo9xWg+whnYIZSZbUOfcM/iuiPA3N/xkv85hZMh6uH5Aa8b2v+ct5aMH/PO7RyHoVVXX8xZ4Ij9CvFEdy1UOhG6OXCj0da2LBjiCUHY5igqJtWwB8dtcQ7gP7lI2o96cZ31Bw3awm04pb0pN1m4dSNroe3PqwclzsoI6V5olBx9flitzeJcWjHGhTGsQg+RLO9yQ88E+wDkcasrfjXTkCP3PjPRnbtF74y/FgBPSbLWRFnJc99GCFkFTotUraG4vJ6i852lGSs7kbXCvHLKYvQjAPl5NVkDft4i3gZJhIFHmdKblE2KCS1SGo3oivaXlgMMzDa7oaoXD/M9IRizD+a5rlcPL352DpUyyNdeziHYs26OFmqS7hF25dOUi1bZQ6Uq+KCndoiRcUGDWFAaNcaD8xsYecgIguCiXBXTV7Fh57SZZ/64SIkGxYMcrYBtlnOEzhxcV6px4aeFRs6UhWvga4/RPHSKDnaBff79Hg0SbaSgrg/kBFIG0ApOKw7kp/jgLU3edXLPRnu0nSIKtH956sNHR3ul350isJxHP/S2UTxLTTDr/m1QGbBrNZeOhrEeYU5d6nAr112hHFx/16IRMdNkHqxXChN262Qsb7TAZssjlwQ0ekGCJnWJQOcfmr8ZqGoPlO0hZGnWwVMfSDyPg3Ru9zkc2WuVyRIutHOifkrbaSTXoQGcBzH+xA+t/uQWlo4Qg7sBJlfWGK+P4suaIH6D6V7vjDSs43zJVelOw7h41jOswIkywAt5xWOp5psY
 divAymsr
 p0Ah7Xe8nx7Yvf2AgLQFH8jqjtLLk0G337XOw2no//XWai7M5qjyi9HnJT0Y8+rHPji3pkw0fai/KFecSKcUghYOtNMTV+XE/YVFj5Zaha+nNHhF+NVmc5a2Bh2AvYeTkyB2h/+d7+FfNEQNR2KY/IB2J4BcQeenR4G7Sj/xYbD/sKshpD2u6t8thwjVXCy+ZEQ16Mj6coC2vGZJg/7lwTw98pmtiGFv0vW/5ms6lhAlN2EBl72OHMXi5/U2w+PCreYgToWS2LX7zGnKsjWRWcLtcmEsGceJJhCwVdDvscOmI6QI2tPHewEMWJ+GjDat1nAL7cLkV6+HceBXgz9ylVci/qqiSW0wICE969zkQ3ZBL57IxjHhaXqqp4P5qVPoBvpdnA25Z6zvKG3y5xen3QRZ4aNrAMiiMst1BQ3/4x3GfFLBjAemAXLmv8GMNp7OlnreJnkS0HWuN/vYAJGIkMY7tE9eynLmZP68RimVNF5GgNCdyZiwqTvN5LS1mPXhuWAvU+y8kbt24uSuBqDHlbeOdDmNlqoYXlJTmEw3MxXoLaJd+t9cmvZza0DyCXNLGLPr+J3UveYNHVqlKm07ejzAzb6p5SbWk2Oesc/DSraXOo2cHsfCfEQH5H9tIAGp7tLvYAK1PVdf51LjRVhCyHJ/jxLWRemmYS6Z/aQM78Z7vcDULHkyKaiDrddnt0YjBfFN0t3o5buaebz6tfkmSwWABvsEpQXwdWLNbMjgVctWo5/Hm3reFTMRjG+lLmGahkRbt224NCEBWcPhfzb37QDcoHHcXfEtmbsWeYOUxH2Ir0Z2WEFwq8TKaCqfYPrVJwcedNSGhTIz96zDQmX2BkGquDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 10:43:16AM -0700, Suren Baghdasaryan wrote:
> On Mon, Oct 27, 2025 at 5:29 AM Harry Yoo <harry.yoo@oracle.com> wrote:
> >
> > When a slab cache has a constructor, the free pointer is placed after the
> > object because certain fields must not be overwritten even after the
> > object is freed.
> >
> > However, some fields that the constructor does not care can safely be
> > overwritten. Allow specifying the free pointer offset within the object,
> > reducing the overall object size when some fields can be reused for the
> > free pointer.

Hi Suren, really appreciate you looking into it!

> Documentation explicitly says that ctor currently isn't supported with
> custom free pointers:
> https://elixir.bootlin.com/linux/v6.18-rc3/source/include/linux/slab.h*L318
> It obviously needs to be updated but I suspect there was a reason for
> this limitation. Have you investigated why it's not supported?

commit 879fb3c274c12 ("mm: add kmem_cache_create_rcu()") says:
> When a kmem cache is created with SLAB_TYPESAFE_BY_RCU the free pointer
> must be located outside of the object because we don't know what part of
> the memory can safely be overwritten as it may be needed to prevent
> object recycling.

The reason the slab allocator requires the free pointer to be
outside the object is the same: we don't know which fields
should not be overwritten, since users may assume a certain state
for specific fields in newly allocated objects.

If users don't initialize certain fields in the constructor, they
should not assume any particular state for those fields, and they may
therefore be overwritten.

> That has the consequence that SLAB_TYPESAFE_BY_RCU may end up adding a
> new cacheline. This is the case for e.g., struct file. After having it
> shrunk down by 40 bytes and having it fit in three cachelines we still
> have SLAB_TYPESAFE_BY_RCU adding a fourth cacheline because it needs to
> accommodate the free pointer.
> 
> Add a new kmem_cache_create_rcu() function that allows the caller to
> specify an offset where the free pointer is supposed to be placed.

I'm not sure why Christian added support only for SLAB_TYPESAFE_BY_RCU
and not for constructors, but I don't see anything that would prevent
extending it to support constructors as well.

> I remember looking into it when I was converting vm_area_struct cache to
> use SLAB_TYPESAFE_BY_RCU but I can't recall the details now...

-- 
Cheers,
Harry / Hyeonggon

