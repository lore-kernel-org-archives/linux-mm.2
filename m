Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8782DD2F35E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E341F6B0005; Tue, 13 Jan 2026 13:52:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01B76B0093; Tue, 13 Jan 2026 13:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D326B0095; Tue, 13 Jan 2026 13:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B633F6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:52:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 869C616023C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:52:20 +0000 (UTC)
X-FDA: 84327836040.15.582E417
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id E2597180005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:52:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cdeCVw1A;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="HGYhT/em";
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768330337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U82JX+Nq2ofB5FWj5Lh4wIh3tik34r+7t86n7xVbfNM=;
	b=T/h6mNUxiLZlMYzWm5XupfyPtLDW2F+FPax8pI8Obb/4Bh0OW2U1J/jlYsCscrlZ8rnTTl
	PspQN8JHdPQQX+8PknSkK1HjzjZAbKHRHPWS9Ocmj+Nl6UXikY7jd/9Mpi42T0m05XGeE8
	35Oc32nPL/7VBQw05MCWyyMqxZbpRLM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cdeCVw1A;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="HGYhT/em";
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768330337; a=rsa-sha256;
	cv=pass;
	b=8CC6TQFAM28dBwyiC3BXtf9p6A/NmlC/TL2MpTm3zIfbjcfzFbQ8SPogagqfpHf++a7Nun
	Dycq+GyPgY35LzdfO6vkdIRWwpxa4di86jMAtQCh/BrL73Yj2TVWJ9sXImGP3yztO46f3/
	XUcs93R7eFfSkOlsKxotfrUumj0BEOY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DFxekc2419350;
	Tue, 13 Jan 2026 18:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U82JX+Nq2ofB5FWj5Lh4wIh3tik34r+7t86n7xVbfNM=; b=
	cdeCVw1AfrSFgRW0qXN6PptsgjaNqO8E+5j5gxfvvEV95TpoeylxLAXfFFGsYDoJ
	glPx1cKCj4CTlH2sTfwYQpNQINgjRIolct6EPZ4R7FfBH58SwD65h6Bkmw9v6kQy
	X168rgy96kKm322DLN/eUnlXYowoG/6U9Yury3YFjWj40lg04Auj6UQMOy9rzO17
	CNfXw2t3DPSfSJMcsI36SEVEWJ5muMEZBx/n/gxquShKEyo0Hu64V6BI4SZ08qTP
	zTabUglnjnEC3aalS5OOYerCzCcnj2aMrVxwaB76okyspcaBEigscfAjwIZxwHWp
	cstlApkiUbcrOI6e4o9yKA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre3v08f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 18:51:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DIHMUw004253;
	Tue, 13 Jan 2026 18:51:55 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7jvkpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 18:51:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2EjEFWx4MHocJZyYUeBJi/a1km/FwDYyG+pTxWxnab2fCeI7NxTM6QXvJNH+bbUVTJ5XURcq/GRT3H8M/ConeXBC5p/uCGYmbj8DWP63mz29IrMPSGoehiAxtsD/wmKmqrD3EC63tq7ZL5F1kWvD3lqoDizag8yAgRqCdRljZkNmE+59dfVAyRtyDGuP5ElrSVK3Tu4oXE8/7/A96DQ6T+0+o66nOihEbyc8XfwW/Cn5lcz8KEMBJsP3TbNds5qeonQTxn9hsXry+A19ZltAuyVsF/fohZuuUPKEjUQTFYw6sGNMzKMyb9mOM5vPwhUkk2EdiFLMU5bgJ/qn2g37g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U82JX+Nq2ofB5FWj5Lh4wIh3tik34r+7t86n7xVbfNM=;
 b=qoJUkGj5vSSsjXOp7zqk+4CoK5RMf9R1cP2dnnaGR4ydgG7Ij+9VEUM3rKq8/YWlHzKRjO3+2Aw5eHEkJPWhNbJwhZzTeHwFixkis8xm7OR0/lMfRlBT/vvxUFZelDUeay1rhQmjtqdrxIpom8jz5dVlislmz3GxAwWGVC1b4vNEKlg4uf8GmJ1CF3ZJeqV3gAXQlVnFTnV+NO3heJah9WOzjjwYzDTEYFEaY2GLbmG3A/uPFlhdkrvV/nU3s/QHNivWGSF9ekjg+i5qcdDK004S+PwL4ARKHoSlD3eoJzTNSiRgd2M7rXRE2Y1c0sIsQGGrerl96cXPjcXpSYNm7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U82JX+Nq2ofB5FWj5Lh4wIh3tik34r+7t86n7xVbfNM=;
 b=HGYhT/eml5aWW1P2e9H2EXDtechXajzYjkG4PG34j20IdTWKbSytVeXAUiKVf3p7rjd066fuFGotNoNoM/c/RbvxNd55oHeprsQjGWXqQqL8XYgNcr+1pw+ieYR8UcP581NBb0Hzyae6YmK5dYz6aXLq4V/LdZY1ueZ+vEzQQsQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA7PR10MB997774.namprd10.prod.outlook.com (2603:10b6:806:4d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 18:51:52 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 18:51:51 +0000
Date: Tue, 13 Jan 2026 13:51:47 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 3/9] mm/vma: Add limits to unmap_region() for vmas
Message-ID: <keo5dm3fcn4upqdf2xt7epdkkgsryjgemaz4ng5r6sytkkpgon@gbnqq35blm7n>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-4-Liam.Howlett@oracle.com>
 <CAJuCfpGSX3VMnFH3u67mKZTe1pXOYXoFc92XiU+TVjPs==5mcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpGSX3VMnFH3u67mKZTe1pXOYXoFc92XiU+TVjPs==5mcA@mail.gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0276.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA7PR10MB997774:EE_
X-MS-Office365-Filtering-Correlation-Id: a63c8a04-f874-4274-7769-08de52d4d075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1dsRU1UOVFXVmVldktqai8vRk4wSC8wM0hJcTBLYVg0aXA0dzhaenQ0ZWlr?=
 =?utf-8?B?bG1WeS8yZGs0RXdUc1REUXMvYjFFbksrb21OK2lCMzlWYkt6T09EelBLRmlI?=
 =?utf-8?B?UllVcHNwcmhwSjFhTTRWdDhPQjJZM1hkanZySndJbzY4SjdUaDFxaUE2eElu?=
 =?utf-8?B?QUdIS0wxWWFlYmN4UGtmQ0N1M0NCZUlrNDVHODZwcHJZcEZwZjVQS1M3NzBi?=
 =?utf-8?B?aDRtbE12WkZpQnVuamZ6c3RzRSsxZXBnMXBSY0R5cDZ1UXJZOU9JR0xFYXcr?=
 =?utf-8?B?WDdGdGdEaGZXT3pXa0J2N0ZydytsUnc5ZmdITWR1dXFTcnpqUEgzOEo2Ukkz?=
 =?utf-8?B?a1pGUU54UXNPNFJCWFJuYk51UEVkbGVDQlJpOVdTTm5Wd1paR2V3dGVGaGR6?=
 =?utf-8?B?OGQvSUh4eWdBbmk2cy9wdTZTZjY2Q1ROTmdUZ0NvbXJDUXM2OW9OZHdhakU5?=
 =?utf-8?B?YitRbXRaandWaVpwcUlUS3JlMStYUjNPNkN0NUhYdGpLUGJEZEJCRmkzbnl1?=
 =?utf-8?B?NDNnQnFhMndZR3BPa2lkTUR2QVk2a24rUEN1R2txR0pMTHhYV21ub3I5bUpq?=
 =?utf-8?B?WHlUa1RPS2pmaFdtb2gyUjc4SmhGYzNPNmN0Qng1cUM4aGtiSk9kK1ZtcFJY?=
 =?utf-8?B?Wk5zQlNETXhBV2NOYm02azdDbXppQU1iN20yeXI3aWVHTHlmL2lWOHpjSmo4?=
 =?utf-8?B?LzNIK2VnVFRMWExZZWhXOFRrdzlyL0s0MFRYYU16VFVBSXMrajFRbm1MbHYr?=
 =?utf-8?B?dThheTkzdjlXdHpLWUdnRUkrdGs0RElIZkxBQlA2a2FTWjZTUDFKZWgya3VY?=
 =?utf-8?B?YzZjdnpRU0kwdTlsSVhMb2dibEIwNW96dnhjU2toMVBibnNLMVlZME9DQkw3?=
 =?utf-8?B?YTB4eHBIWVVSNlhFR2FlRmhNWE9PRTBMOXhieUZlRkdwVHRCY3BnK2czdFFp?=
 =?utf-8?B?cHFRY256RytLZ3hFcjFKOGNuL0lnSXVMMDBaUEJLcnNSVlRURW1sdk81ZTlX?=
 =?utf-8?B?VDRLempmNXYzdVFvM252YURIMXJLQytiUldkQ2JJaXFZbDlGSkpFQ2luUW4y?=
 =?utf-8?B?Y3Vpd08yWEVzbGlaYWx5dVQrWkFNeEltL3g5Qk5iSWZPbC8raW1xeXVGUG5a?=
 =?utf-8?B?MTlXTXlLR2V4SzQzaEdVbzlubnlTVFhxcStPZXBEdStIL0NJenNOZkdsSEQw?=
 =?utf-8?B?OHJMalhoTERBUlFKQWkvZ1psYWg0Ykg1clp3MzRIWHpSRUtRUnJKOGpZOHFv?=
 =?utf-8?B?d1hlUEwwQ25LMmRPbm5SNURVU1FYckNzc005a1FrNys0RE93Mk9HQ0lEamVD?=
 =?utf-8?B?Yldwd0orUnhCSFlpZDZCN0x4bjlPQ29HMlJ1K0NDOTFZNHA2M0MxbTZWSzZH?=
 =?utf-8?B?UWFSRG5ReHM4Sm9kSDVLN3BHKzloalhyekNmSmFJMWgwN0ZBS3MrTUhKUlg5?=
 =?utf-8?B?SGd0bWFIdzlZM3FoemNSU2R2azh2U1NtUkllOUJLN2lNbVdOSnYvUTh0elFq?=
 =?utf-8?B?Q2UreEVyVitBWGZSSDBmWDRSVHErNUxDZ0lrVjhpejYvNWZKVnNYdjdOdGNZ?=
 =?utf-8?B?TUtncE05REphM1IvaFgzN0J0SGVyazVyUEVvTWx5WERwWFBNNGhhOFVTeE0r?=
 =?utf-8?B?R0FMMWJjYUIvdGRTazMyUHprZEYrM051Zmt4R2U0aWNBbDRZZU93RmphSmxT?=
 =?utf-8?B?ZmllY2orSTdyajJpQ3Jud3Vxcm1MYjdQUm1Xbk1XdFc4Zkd2K0o3SU9QWkVI?=
 =?utf-8?B?NmJqb1p2Q0hMSk0zeGFJdXBoWjhGZEdwdThDaHZnNmE3eFA5Q1BGRVlFUFZY?=
 =?utf-8?B?WU1aU1lEekVPK0FHS3YwcGU0VU1ReVBNWmozSWVUYlhhcllDZFZRT0xFT2pu?=
 =?utf-8?B?TzFIYjNTT0k4UGFDSExhUXlMcUp5WDlOeWdmd3dqSHcrc3B3U1ppdWdZT3pj?=
 =?utf-8?Q?H3ioxztNK5GNlIpeoZfro8bx4boqgANn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFRoUUJXMDZ2Y2dmSWtiTlYzOGtCaW43OGFRVlBDOUQvZUNOOHpIVmZ2QlJz?=
 =?utf-8?B?L1VGTFBVVktiYzB5TjdUSW93R2prOWFQT0hsYU1ZaWNzcFNPSGJDeXMwV2Yr?=
 =?utf-8?B?bjFsdDUxaGF0Vi9zMnFwWFhJdkNBcENtc1VGbFgzY2xGcDRrOUJjd2pzL0Fu?=
 =?utf-8?B?YjNaZTlybjQ5a0lLMFVCczhuWkhxekE3MXN6RnRYbHU4dWNLb3h0Sy91ZEg0?=
 =?utf-8?B?Wi9xbHdRb1lmOEJuNnByVXhTN2FObE5DeVhqb0tHQ09la0xUL2toeXZleHBs?=
 =?utf-8?B?aW5kdkNYeTNrSFp0UzZrTlBrUDBXUjcwY2JMRGJ1Ymtoam1pUTMxb05PQUpt?=
 =?utf-8?B?RDV3M1E4L2lyQUpBcURCb2JPTDRaaWFXMWRSTElYMmV0MlJjY3M1ejk2S3Vq?=
 =?utf-8?B?aXpnZ1Y2cUU2bVM5ZFBwYmxFZjVUa2NMbGYyU3U3RS90TXJmek96dTFhWUg5?=
 =?utf-8?B?UlkrSmN2ZndiVlUvN0dNOVZZZyt5aUFyVEFKV1BsSWhRQUE2WWVIbCt6K3Nz?=
 =?utf-8?B?OGlWWnhiRXRZQUVHcUJyazVXbWhrbisreC9EVm5TeEZNNDQ0RFpjZDhVOCtB?=
 =?utf-8?B?TnhXak9BSWhUSFAzWEowaGE5NERnL2tkM1hpclR3eVpJUHA0R0JKa1J5YXhr?=
 =?utf-8?B?VWU0WEZKdUlHZS9Ta2IxUGFsWFdFMmdoU1dzc29XK2p6TnBvMkFONCs3RnVm?=
 =?utf-8?B?aUhwdWtJRW5ET04rQmVwc1VhdEpwZEx2RnpGOExhVGRUVEZVeFlDLzBuVnBS?=
 =?utf-8?B?dFgwV3h0bXNWRlZpSU9VcXZ0UG04a2JXYzN5YVhTUEpPRWlGbXpLbS82ZGFN?=
 =?utf-8?B?QURhRU1HMTArNE80ZUg5RmFrRkRwSmF0dzNKVXNTRCtKd0huVGhKOHRrQzhM?=
 =?utf-8?B?aUF5TGllMTMxVGQyYlRrcVpJK2hHcWVERVBRTVd1QUdSMkNEMTVDeVV0aFhK?=
 =?utf-8?B?bUpOQS9KeGlTamNuNmg4MzhFYllWdldkL3Y0Sk1LOXNBWmtvQ1BKbjhKN0dO?=
 =?utf-8?B?aG15RFh4Qm9MYjcvQXJod0RpRlFiS2luMDJCWGhFNEsva2Ftc0JXbW8rMDl0?=
 =?utf-8?B?VFRkZXRCSkwySnVFcWhWZjlWd3Ixb1crZXhrdVlOWTlhUllLSVMyUUFzK1ZJ?=
 =?utf-8?B?OGtnSG9sY0FOcWFEU0RVLzRtOXl4VndQR1ZIaDlHblN0V3RzSllwSFNUL0kz?=
 =?utf-8?B?MEVvb0RXVk9JWTl4TlFZek5ZUE9NckxsNzRnMlpHRkQ2V09RaUlaWlBKOFl1?=
 =?utf-8?B?VnZoS2FJNFRDRERUdjl3ZXdncmtvK2dOa21TcTE2WFBjaGEzYjBTZEVrL000?=
 =?utf-8?B?ek5Fc0xjbkdJdUhFeUFaQjJ1dFBaZVZ6NmYyNW1kUzMybEIwUC9NTjgwbHAz?=
 =?utf-8?B?OEZvUFk4WXM0ay9ubVJIZUIzOENKeUIwcUxZRHk3ZnhCcGU0MXJzU3ZaU2Zj?=
 =?utf-8?B?SmRTZUVJTk1hU2ZNQjRtdk5xbEptVHFiQWFZTGpsRDFFYno5VFJDZlJETm1F?=
 =?utf-8?B?MFo2cnRJYjI3bkVheW1BNmJmMHprbHBheUFvM2V4N21rUlFZbnJTai9Ddy9E?=
 =?utf-8?B?Vks5VXpuelhoeDVML01mb2RqWHhEb2RxUjNqT2hVNzJBUnB1d0pHdjBCeisy?=
 =?utf-8?B?c3ZWVlVWMS80SmVyclRYcVp4STFRUklxNGdUNnJXNXU4dXhjTlp6aG8wUWc0?=
 =?utf-8?B?cEZmUEZKUEVxVmR5aUdWTGlCY1puSlFDNy9wekdiQXplMVBXUlVrUHJFU1la?=
 =?utf-8?B?V0pXbHJ4RThYemhaSXBId1VSWkFQamJWZDdxMjhZOERHbzZTTkFoclltY095?=
 =?utf-8?B?UklpdkRSNldEVDZ0UmdFeDAzbGRyai9jRVR6T2M0ai9hN2dVM3c5R3RZNVNy?=
 =?utf-8?B?bmhuOU1ZcW12YUdHZXUyRHZiRmdxVVA3Wmw3bXJtNm9wS2hzeXA3U1lhdWNp?=
 =?utf-8?B?TGI0UTYrNGpMdFdHQVIzQUprNGRFeERDTTdKOWFmekJxbnFKK3ZZYnMySFgr?=
 =?utf-8?B?RWdJWDlPbU5zZUdodUJiSUVOUGZlR210K0MyUk1CSHZ2YUcraHR3WkduemxG?=
 =?utf-8?B?QVdUWlpzcXJFVUY3eGlDZ3dzck1KcUJTdWdQWFZuSG9DMkErWXFPTytOWUJL?=
 =?utf-8?B?V1I4L3lzWVkwa2JMV215SnhHRTRsdlhLS0c4ajVLWnE4bit0UlNRVW4vdVBC?=
 =?utf-8?B?YWdiRUFLVHRJeDg1YjY1emFtVGpDakU4b0FLWFBBQ0ZVTy9PRUVMR3gvb2Ji?=
 =?utf-8?B?ZURYL1RqTUlUNzJRMFdKRFRMMjRZZ0V2by8ySzNoNVFDald5dVNkTVpVUEsw?=
 =?utf-8?B?UGY2VHE5dWcvbVAzakxsUTJpc1dLNUtpenBacE83MUQzRU1VUUtoUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9pXGj/e6EXnugRJJ2Z2hv3NAZeRS9zS47qqY21UFNOWGexuts32UoArHpyegwc2I4BW7fHigwY/ykU8jiCd7DxqjgiWv65wH/LuGaStLBC1kuWrDiDdNIt0MPV9UQTb74JGNOwpgRLQTtpNQfbobXchYHxVb8dQMIYWTrxdph5eCYJG1yxRpghZHH2y2lc92u3Pwq+43iG7Kyk93bClTc2+5LZrBUXbx1F9FogvsQkRhTAflsa1J2F5fvOy6v6hHzhK48IZjzMq0ZVFAmbfsbl6rqYsom5VAAeQB3f29rQkCOoy+RqFZYFyiyETFfYcXT7s0moDVU5+slJNzbpDHPBYProO+3E0bwgHtfKzqfjUI55F/ovmSZdJzAqAuu45z3288YBH4Ryn3R6bh18HLsAbfDW8y9dLZY6HSvsf7QvVAm7ReJZCGVqQD/6lxuv+CzMWix8EuuWub4OLGqMpVbcqjRGP9LBDdDvSxB34mtC1dljANtALGHxz70UCVLvIYnOY6Jf+OKD1L/sJJf/po+3XtrOoqLvQZ6g6bhtYOVrhlLWOD/I/SJoMVdgtbAHJu26by0Juh7YGlMr8jpGT31HdOtnm0nnNIJl8YRn4zWMw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a63c8a04-f874-4274-7769-08de52d4d075
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 18:51:51.8467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNNYKbAZC0frCyrVgOhfzow0QgvjBUijJhLZ8ztW4038STKsA3GHCSiL9mTPEsYZygXaF6wfnUH7NU4ewgEiaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR10MB997774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601130157
X-Proofpoint-ORIG-GUID: QkB6y3kU9c6MI3TPrP2oPzTIfsk1XyLb
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=6966944c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=QgicZdYFN2riInb5wd0A:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE1NyBTYWx0ZWRfX47vp7F/KmyVu
 oP526FYsKsAYWL69x8nulQUcemyjL8fFMBAKOlMoJevgNWEGW0bNaMzFRCBT90hDPgHVYihzs6o
 F0r2Vje7uwnptUx7aA4JTeQ5uihwPiNtVY8oAA6jciW0xlMLBH6NBcWGuRov8cXS1mxRqjbfoua
 J22P/N2X31XkFNqp+qgIgbqar6lXtlY/Kk1XDRlZFdIIlvPJ3sGIt7pK+dWINq658F79gdkC7Yg
 7eu9hZvS4CZJ49Pza9/gb1HvlcP+4PZiQZQjKIATjEE410MdOLke+cO11VWiu4lEaBWdCis/LAO
 18c49UcELjXTTaGXnBYiZo+47ybQx6D21DY02LY+HFL+TuGF69P849027HHoFEPG4wWiSTOUa/P
 KITY2ADflXF6GXTo721YrylqgOfIYnxGWpqQS+FuQ3Xizmub27LuxhvwJplxQ1n5b0myq8FBGgC
 iN++M8H1kFz/eX8qQqdZS6oL5H98IyMCS33ftEN4=
X-Proofpoint-GUID: QkB6y3kU9c6MI3TPrP2oPzTIfsk1XyLb
X-Stat-Signature: 5fnh6hq9t67mojto4g7c83bcdp8zhib4
X-Rspam-User: 
X-Rspamd-Queue-Id: E2597180005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768330336-352603
X-HE-Meta: U2FsdGVkX18WnlXhai/y5/tSngIe974ZLu6ooST9thKjvvmIm4iqjogNt0OGNEem8uGzkB7HbnNLP2hBX8qRzFJPVgapvJh0mWwxvIsgZhFIqg4PgsT4mX18YvI+emtcSjiw4BpY/bi1q6YfK8vwxwaD+9PIa6g8f71w2lkuBLiKLUtrQ6ySP1Wt6ReZ833Gxx4rfkZnMZz7Z+uQwfiYAg+1Xmb/ig+TieGqSLurGqnAm9cWLmxnArt+wmxt+ZQy1df1bG8EgYLXaNrX31fD7NouUYjZzKWGMWShhJ4/YuX9Kl9ChxvZL4PR9BGVmbY7Xr0OtdUUost3XI5TeiZTCGQMYybAHnS4RXWPJp8TrBwWgKnyGrjfRtmO8D/f6iBSxtp87t5pfIzqC47bt/uyh9UBCGi8y2f118Keqhzr/LTVwqZOY7bDCmboDj7v9MLEC9BOQVQCVbjK7WypUSt202KRFceV637D18qmlHuIxXmZrOdFmbF1G151zuMURmhDHYkl6wrvll8G9InGVm46s0ZIZlpiw47v2IqTmJbhJAc6kUjL8hpyd6U8NH7cvYWrvTg4IDoQOeVKKKxyDqScO3aqBdpk7xCSMXrOC54q6dxHD0Qy/iWNKP2nE69/GYio7C3V6dEcQ6TbhrLhdrvh3dr8/cm9QrQrc5UBuKhjp89sww7XPYBkrEJ9VpKnP+yDOzj7CUFs11QGYmwz5DkArHmNsIsmDmIUD9e1NI4uN3rSX/b4y3N7lJrDvGO37DaSI4OrEQgv8AUBgphgiHDqCxUv5/crzXUMRq3zg7M7A7SiCJSYEiTew3bVHr1Z0pbMcFZigmI+9sCf/D8qSksVVu+QP9uB8sQNZ+K46kZEXExngGk9CeTma9Nb4APbZywvMSXUTX+fz4zZyMSOYbdV8I3ifLg5PXbSw16x+EG47iHI4fjmt62QN64RtRAvn5y60PY6i7/Cjir/2/98lZx
 G4ZgDv8G
 g6G7aAalzj7PF4/GsZTITV1q1EyVJHA9ULiSd2GKmrgDIUbUIK3/Ewl2+GzwfHHzm3Z85Xil46mp8ZHkleTy3kxjZ7DIxoiu/MC0i5dOksw/0YWpQeYCOXR3oDVYb9ZtP+biVOLpcJNq6Bu3jJpa5RTU0LkUfq+U0tS97wcFisr6H8YUcQLmmcZ4uGx1uVnsrEdxPYbf3mesoPeF2cvd7KNX3hu8v03OR5LNqR/nolYVG1O0AXQSAFPXIb9Oj42Pe2mSIJNuQq7CoOCMOUcNVM6fn7I1AbuEuEV4CzVKtgy9ae2MSXI2GLoYFawf1EYrZcf7ezbDReIiW42qqg+WsNSIV/rmAMU9h3VRwrCFr2zEg3l0cIsQxKxZx1r0LATUaM2Az78OsSDP/xj9g2h0qggSTU0o62prWWXI2nmg5PJI83Ba/+1DbrEzto8DeRTUTf3HSy6rgDnSYRAx9p61nJT4pmZQ5yMD0rkzxfptuyEnYBeRg3NSY761DXhff1ceEIx3jyB672uQ3/SpEc6epfm9eSxo0ujw5RaQ2c3nEZFMKy5TF/7qnifybBvyYA4sscVBb4ITHi5e7ZaLubw8t4gvXM7XAqN6WPb+LVMwj1PRvnMwl9cXOfgK3tEV9yKhh7/y5rs9vXVsnq7A9WqN2XsJDo/O2op4j1YzPykyvfN/9UadZrW4YyBxe6av2Qb9y2N1vCYQTOitKRFw2L0P6ue4AM5cwWY1cgd9ZAIf5qB6aNpXtJGrHckHv/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250909 16:10]:
> On Tue, Sep 9, 2025 at 12:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > Add a limit to the vma search instead of using the start and end of the
> > one passed in.
>=20
> Would be good to explain why this is needed. I'm sure I'll find the
> answer in the later patches though.

I'll try to expand this comment to include why.

>=20
>=20
> >
> > No functional changes intended.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>=20
> > ---
> >  mm/vma.c | 6 ++++--
> >  mm/vma.h | 1 +
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index abe0da33c8446..a648e0555c873 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -474,6 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
> >   * Called with the mm semaphore held.
> >   */
> >  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> > +               unsigned long vma_min, unsigned long vma_max,
> >                 struct vm_area_struct *prev, struct vm_area_struct *nex=
t)
> >  {
> >         struct mm_struct *mm =3D vma->vm_mm;
> > @@ -481,7 +482,7 @@ void unmap_region(struct ma_state *mas, struct vm_a=
rea_struct *vma,
> >
> >         tlb_gather_mmu(&tlb, mm);
> >         update_hiwater_rss(mm);
> > -       unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_=
end,
> > +       unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
> >                    /* mm_wr_locked =3D */ true);
> >         mas_set(mas, vma->vm_end);
> >         free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_=
ADDRESS,
> > @@ -2417,7 +2418,8 @@ static int __mmap_new_file_vma(struct mmap_state =
*map,
> >
> >                 vma_iter_set(vmi, vma->vm_end);
> >                 /* Undo any partial mapping done by a device driver. */
> > -               unmap_region(&vmi->mas, vma, map->prev, map->next);
> > +               unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end=
,
> > +                            map->prev, map->next);
> >
> >                 return error;
> >         }
> > diff --git a/mm/vma.h b/mm/vma.h
> > index 9183fe5490090..a9d0cef684ddb 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -261,6 +261,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct =
mm_struct *mm,
> >  void remove_vma(struct vm_area_struct *vma);
> >
> >  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> > +               unsigned long min, unsigned long max,
> >                 struct vm_area_struct *prev, struct vm_area_struct *nex=
t);
> >
> >  /* We are about to modify the VMA's flags. */
> > --
> > 2.47.2
> >

