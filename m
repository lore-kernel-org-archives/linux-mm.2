Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A0CECCF9F0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B256980195; Tue, 28 Oct 2025 13:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5C78013F; Tue, 28 Oct 2025 13:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FCF80195; Tue, 28 Oct 2025 13:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB718013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:36:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A27049784
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:36:41 +0000 (UTC)
X-FDA: 84048227802.28.288419F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id B55B81C0013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:36:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UL4jq3Is;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WyXCsJQn;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761672997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thrmNgSMaAkYRtCdhVCaptEDjsGwVMFBoLIFX3fWM4Y=;
	b=Iu8eGM/71H7YLMqCg3fsztCZlI/6WTygXe4acPL/bU89TPlDZXIhEIB2sAP2GPWJqwRFKf
	H06jg1BRG+qlonhvXnAvJTOxLyErQuD+9Hfb2UGDVzKRLXVQCV713HMsN7ZejBL5hQTVKu
	kj+kDBHaofa+b0HGQPimPGYdk37tLE8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UL4jq3Is;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WyXCsJQn;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761672998; a=rsa-sha256;
	cv=pass;
	b=IjJoNjBq8OR76JMwGtMza/FCGfm5PxcqTim4Go8erORRZzi1RMDsXQIY31tEYL3Eim6ETP
	gnN3EUWV6kbz0Adk54G6N+4oh95HyVQkBRZuDZRAxMv7H5m/IbayEvHFNl8XiE/AuYVpXa
	mMaR6G8d++37R8nqX1E78UPrJLW2nQc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDaKc015518;
	Tue, 28 Oct 2025 17:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=thrmNgSMaAkYRtCdhV
	CaptEDjsGwVMFBoLIFX3fWM4Y=; b=UL4jq3Isctt5hqfWYToR8eN++ux11JpVDH
	necE50pD9XJTUnHqh8Z9REOF0RGhDtapIQX/iVInaD/97kugfLMaeLyFMgnbUeNB
	aYnllFnL7bN3tGRnetTRpA1DeFW5+U7O1iXnYfDm952e2I1uuqpOFCpLmoC0Y3lm
	+GRaMQZ/luafjRA6GN0uhL8FhI0BkgeJ9Qo3VwEDVU6T4P5ViX5DjLBH2jNyLuMZ
	vbOB76YmOOB1MXsnsw33ZZW3KrMXIeb6STbH+kJGqpQ3ePdvRWtfdwJG7C0DAFq0
	HuPYysUznXh+JIf6lZIOIOh4zUPC98PshTezaJm+5GHsv3hgRkiQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0n4ypv84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:36:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SHOKu5035001;
	Tue, 28 Oct 2025 17:36:18 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012048.outbound.protection.outlook.com [40.107.209.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pfx2xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:36:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqaZIgXYeDtScnJ95ASAmL8IXO8VquqFBWH4zLhtN4kFUZvmdSHt25VQEDMRT614D3KF2SJZZUm6/fiKohyI3I26lsQwcBUuTqJVVernGUjbYLZWW3mx2UFUzzeXNUY91HQcHW7SwCcUbSIArzHr/kfHT+9td8zWjJ6qXXEHkTV8BKkLLCy+bylLlpzNnrK20X1SxvFCIqIZkrbYK5+sDjvWQ9bShiNjBBlkbgFEks9s52q8zwO1xhEpbjBjVOiNI+j4DGz2fo7AQS0JzAuGHdx7esCauAFxizXBouzVDXIytp6HkglRkdluTZgvV4ghfgPJU6EUnPvjcLiitZU2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thrmNgSMaAkYRtCdhVCaptEDjsGwVMFBoLIFX3fWM4Y=;
 b=HB1Ym0aiVPqMPBuy8H6lRExXijoUA8Hrhj0sKyfPPIN7OyMekj0uMTggVzBM81srVaB5oDS3khM6sKb/l/sqf0+bgrDIUN0bYPI4OkRbt742baSW+X9z5QXr4Y947hOG3t2+RMs8ExwdKW6t9uenAkPZSCJqO1D5Orq2qpI7TabEL+uILZ2bkCFRfJ/JPZDAWXmLFat0CfyDLLtb5tk/WuR79EDhQI+IJ9Hec7XHwL59oPOA4eUdwyU/um+PW/5Hg1f8GXkqwE76T4LM5ZbCeto3m/rdWm6XBwKTlHXATtVH8qBzwS03ca9HKABEXIjbZy3AodyP+dMorrKOzYIVpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thrmNgSMaAkYRtCdhVCaptEDjsGwVMFBoLIFX3fWM4Y=;
 b=WyXCsJQnmmLMxZMzHDe2ZHW3ZCO+OuZIbyIUviWtLCw9wt5stnKd1fia4/Dll91d6Nrq86nBCZ2KSRp/rvZ77EpHUukyFEUYJB1TuUd1XbOOLo0sRgq2EiL+fbQBoKK7de2efiKMZy7uJuH+zIFA8FlgPeyobFopIQNYluUi1CM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4807.namprd10.prod.outlook.com (2603:10b6:510:3f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 17:36:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 17:36:14 +0000
Date: Tue, 28 Oct 2025 17:36:11 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <204abe60-4022-4aa7-a201-48d148108723@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
X-ClientProxiedBy: LO3P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4807:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d95dc8-8956-4146-76f4-08de16487e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gf4W8w13ihE4FEcXO/D0PZy3xw7llXQg7ibK/vzZTHp/IBR0kFvziEGZEE6W?=
 =?us-ascii?Q?tlZS3yg/k+Y3CgGJazzWLmOcn8VJAjuFiGzKiufIy+M/CFK5en0CCws7ModH?=
 =?us-ascii?Q?D8hGmDu+8iax5ZLeOKkzyaKHrqjDZCEu8/ztwZh37Euo9KA+zxXdoVXnI4R5?=
 =?us-ascii?Q?7aBpw96oc7G0fCgdymDs1epMCe0NhUlWOGJSjs2q7TtAgk6EcnkIVJQRAkY6?=
 =?us-ascii?Q?WSyqN2LC1AmbBV5WtIr1eino162uQIsGjZg9sw8MbUWOSdTnS/EO28IBsgYh?=
 =?us-ascii?Q?vABf0+02oLFD3xgh8VEINxAxvsfPaVxv1Rhd9EIovOyYraprQ8N4kVdmoUxT?=
 =?us-ascii?Q?cEKe+7DPnCJn/BHSo5zOoOWka2yoDZ5I6gsTgVG1r9jG73go9hn85Aq2kJes?=
 =?us-ascii?Q?/lbuHVn3abM5vNVCvfS+OguS+keubNbx85gbXGVHRiJxwKgDTtKh80sfcrev?=
 =?us-ascii?Q?m1Dlru0wys15tCPcB+LRFFk7hUdXZAKS+tsMYWp2gjkj7z6U9R9nAePmq9sv?=
 =?us-ascii?Q?isipxkqt5eVaKE0aBKHBX9BBRZ/ROcJKjMD79ZvTyUJr+hVjOvhElzyedD45?=
 =?us-ascii?Q?lEs+A3Va3eXO/63P5NOucEXXUnI5/tdRuCheXnRRjrd66oiyxFrDsRwjkIS1?=
 =?us-ascii?Q?z1ztD5PMYyegsogiDnuM8SEVdjsv9P2ZISVPSWM/eJySnoPxEqQSSxykH5IC?=
 =?us-ascii?Q?+PWvxIDD0tWnhBctDq/8fe7jFWJxM6RnWtZqGpab7gb5th4kXYB06JuL0fVt?=
 =?us-ascii?Q?iCfXTiJL90IBw5WC4HrhRi3gx2p1s1ox22KTfRUYgmV9GwNHb/ywHHU/+0yv?=
 =?us-ascii?Q?5QQa+ASlzdLAYvNNNj+yUsrnDCdUdlB7hQU0DtyB3Q9ZFp9jLC+Fgsti5xEp?=
 =?us-ascii?Q?0o24EHMyDW1q7CGQ2mzqtodVUyhUk0OLPn4Pi6IL25nNJHM3aGAaqQ8P+b6H?=
 =?us-ascii?Q?VOUB/0KNzPQ8/TbtmIuzpODCot1H27jGh1BixStxcsbKYJWrvTWe10iJOd7A?=
 =?us-ascii?Q?MqeWat9W1j3Az9xuCRdCm8uzieOMlhR10+syV5osadcApJ6SVL9ZVQi2JfPQ?=
 =?us-ascii?Q?CUcf7dnyZcd+8750hHYdZNKnO6aWYtQ9MHIuawRhvfXKIlHEHpNY7RUQe0IB?=
 =?us-ascii?Q?F4WaG+VpQIoo4o9jE7YQNyG/bFUDk5Yjgo7/hroVgF+V5vtAieMXmGjUS8NU?=
 =?us-ascii?Q?26pWSL8ohAEUvgIF24aX87YCPnJXoafW4w90tZ1ppfy7B1gUV0VgDpuK1vIj?=
 =?us-ascii?Q?2SHoODFB134ixlgwniqFmhg7k4CqVWhaT28FAZXLdYGzyFuJt+1UoLFlvWhR?=
 =?us-ascii?Q?fMEcnVIimGD1wDxQO2yNEudQz5xS6W7KzxF7cHq3rcaG64ypp9vMdbpqs/2z?=
 =?us-ascii?Q?VNuyhxvIKCMNAbhfV7lFKHQvKGAadmINqPLHZUH4lyBaOKIIrMBrYtZnitz4?=
 =?us-ascii?Q?p+8bW6Nekc0NCvieZBg4gm3uwJ/qDATQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PU3pNGD5O3rel9PrifNkgSiKVca4KoYT93ABvYaxqeFWOpb+rzxcmNrFF2AL?=
 =?us-ascii?Q?bgm6vaaoqOg8Rp30QQkCgCS8XYUE6qeeIypl3iu1Uf6dXc4qLQYz3VqyLUr1?=
 =?us-ascii?Q?TVTa1iypoD6jnWbWk+b8wgxMbBrSCEP97ZjiJDvT3Sv7HohO6f466wkSU1KQ?=
 =?us-ascii?Q?rQbu0q/Z/G9kZawPdfzkKP9uB3UlM1sHOE2BSqKZ302FFNGv5GkP8NmL/oG3?=
 =?us-ascii?Q?VMHHEHLf7eMD33kmxJXiF8FI4UZedJR6eVyyVcqnhjrIupSPo6JPj55SWccB?=
 =?us-ascii?Q?FOSSE34GpOX5Mr4y2pIolCyCJ5vzive7XJwK2Ej5sMaVv/DqyAFOnCihCfl9?=
 =?us-ascii?Q?um8/Uhqe3IvYZJl5XoQQqGSn7FoiZmAfvllMefrqsPe6ddjctBUSBaUD93mw?=
 =?us-ascii?Q?K8gITuCkIhSW1PEKE0vfg8VhtBe+HSerECnO1qjZZY6SSJrUKo8+geIpiga0?=
 =?us-ascii?Q?sv2FurDqZcVHT0WxDzHvq1SLGVrCEWGNAA4AbFqt/tWF2v1p4ff0IcJvE4bK?=
 =?us-ascii?Q?75tetb/XD16jqy0RIkiFchqflggvs5IreHykF7mDD4/nOPYN+/MsMV1YYWBY?=
 =?us-ascii?Q?3NH6+U/wE78ZmST5PRc7vsdfPZcdwMEfZB19P10j8J9f1jDAMJulRtGCFd6L?=
 =?us-ascii?Q?Ajs0zXfk/74aX3w2o1CkcMwKfxqFYV3AtzcrGVBk4wtGDgukMHDXK5wZodKy?=
 =?us-ascii?Q?h+P0jESkmTeNiy901WikW0Oq6IZmH/GpqnRg8mBu+4gCuFU+TnHA0YrXfWOW?=
 =?us-ascii?Q?5yUxNVSVdpQKyHxUFBKPzHqR4J7Uv/2uUzF1/E3c2hnzFcJxM9pCNHfqwLEz?=
 =?us-ascii?Q?B5hPwjiccEUIniv0y4ZEUy8nryAbyPqAq8TZbtWxSboszjbYWcC9R/5ULG1W?=
 =?us-ascii?Q?oUtRWqYvKCj6kWYH+K7sTXSW0AHuSMsqcZTxcTLMshGJyR27kBGXo4pOio+G?=
 =?us-ascii?Q?zV9/yMDIkjThFzFKedPdbLleR9PEgPrJR9u4I5K7c3TXA3hjqHHZhmooVu0m?=
 =?us-ascii?Q?1IkD4LjzKhhdHSeotAiojDIqHjzs9OcMQjFXaRpAAPMGyAx+9Ekl+dzrbakh?=
 =?us-ascii?Q?Iyb3trl8npu+ZnZkbXZsPfHp7uqXsEKN54LiXwZZGmJdDVK+BgD0ZZwjZjJe?=
 =?us-ascii?Q?yGf8LiKGpLE3vNLPI3nbnO1WpUpJI3z2yXKWVUpQZMNkarmemPja85WjE6Tj?=
 =?us-ascii?Q?kwWW1U9DLaY9dRF1d+pas9A++o4bJlMV7pHOap00Ml/n2S0rOzpG7KScAWxA?=
 =?us-ascii?Q?KMgRAz1qC7vH4LYI3pjZadl9vU6k/KoP3Jvru+gs55hyxBdcKMIGpUGwN/lS?=
 =?us-ascii?Q?HWz52j3AjL8XqvDaH9TJ1u9CIfIAcLDvwyCL4PU7eYRysDDDK7N71tbxBbCo?=
 =?us-ascii?Q?DM5iU1QyzuwE0Czzx3Rd7MqBCJv5LNEQmRBICZ7qZl13ioGIESNo06541Osc?=
 =?us-ascii?Q?B6D5qXNqVR165YLu3mYViDYrqIUD7Ek5QrR48ZD4mfZwyBKB5QKGDq2qE84G?=
 =?us-ascii?Q?Kn070MdWziWUjkcUlg+uallvslcu7f5YVPbHORBHlMaj4Kw5yp0z0FtTyj9p?=
 =?us-ascii?Q?8rKsb7M62E8FfYNwlsvUsWu4zBtoFM+JOqkHt/HqODZSfKwOnCpK3UfbOo3Y?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Aa/YyHqs8t7H1mLp6I+ccMkEtBVZufcSyGXFJDdST4FQoxaeXatWFAq+Tohh7vqkU4PWadoYXKOhVKvmdU/fG+5+wExCS5EHs9vqt5zMUt3QwgBWtInmRTsy1uSRVJWf1EE345/RHZRfY0EEn1E79NcxT4lnFH9Xby3uBm7GBzehbgxWn1D2gpbLbIEASKFbdwUZLyPT9zhiOrnhTgQxRmHC6ZaB0aPHdFHYD7UKc62sUwPRQ4C9rXfq4F9xhfzRjvcmb7ao3lG3eKqvMAyddxRguL8JlAxIO4cH9z/AZLDbj58r21IRfoHxIn2pZbJ6UHJ7Zq/Dak2wK4XLiL7p9NjMOMNQ2sv88+3uFZDKAd4/dVyBjbJ8Of/hFpLbtngsSR/92qXijMgCzGQh2skXtmlMrRYO2Vdowjq1V6pKLjw2cezAoEstD0ANGmtyuZiY+nlC4gRmPMYfeZcUtnzMdk6eHw4ZEkcXp6gkSTUdhyb9L7anqnPVHTEPLb1FwLNK/RJ3vZHyLqlXdWsGy350difb6stPbj3VTqx4nEN9s+Pqr1ggJwUf0j8cOhVOLiJxyPicgEPjudDHj3AkE43hLyUKQtEFFarO+i+Vy9uul+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d95dc8-8956-4146-76f4-08de16487e04
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:36:14.1584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EF7EtuuCPj1N/4MA1vpGrlaUjLGhrNezSuE/kCFdzw6MXAcDVBCSdynJ3VRasWrLFzvKzZ2uanxSFKE3eVXn8JXU+tWG1epf4Lxf+TxUY3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=747 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMyBTYWx0ZWRfX/vOarjiwyd/i
 xXuiFq2JVjbkvdMOLwKzOQGNx1AQntuQlKttVKtGEIz3ldb/zGHQ5tQiKlUrL39baG/Q79KWPBX
 o5VIpBpkqXxrPE4nuvGdV3GEkAXfY21f94yUuICCzHHC0lR02BUhKhGZ/5q5UBmEdXwQQhdhjHz
 MwLS5ix40VkKFposfKv92MtCendLhwyI/UV2h6UsMaxeAFaL++TUVblNf090n4LWYFVD7HST2IZ
 JQxmdnN2XTxQn6GylrmjFCOz5ULw4q6Gwu7049V77BQcKCf+GSnrQu5gQ9gISWECAgkwiD2LXGo
 iUkX+VAf6GjyweaCH+G3LliKCMttiQOzSbtJ90cniaMjZ/kHLMhQCwH8UCeeDwp5iMK5P7pDX4N
 Zo82uZvXBryEkMnj1R751EuQ6AnC0OTT7MuhDsz7Cj6Gl+Qc8VE=
X-Authority-Analysis: v=2.4 cv=Z9vh3XRA c=1 sm=1 tr=0 ts=6900ff14 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RsKrmfdR3l-5Cd73GLYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12124
X-Proofpoint-ORIG-GUID: D2STXSdAFqQIF50i9p9Xvcj6RMKJj0gc
X-Proofpoint-GUID: D2STXSdAFqQIF50i9p9Xvcj6RMKJj0gc
X-Stat-Signature: rw11acmytsjq69qz3o1jqcujwcinesw7
X-Rspamd-Queue-Id: B55B81C0013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761672997-201519
X-HE-Meta: U2FsdGVkX1+z18npK7LIaqt2Y7aK6oGad6ug1BKkRwveBGv4C/39oQKZFkh9PkYoa4/OeJnIhScRR3zJCvQLTz8n1eUm6U1i0x7QM4It6sy1krGIPVwh/dwFwnVF3Z5a6ScMFAq0JWMkjIYdZEuTY7M+Y89ip3GpvnjEyDJIv9ZTdWwWV1gCDe3I8abmRKUEQ097kSwfbQQijdH/lCtOXLAmmp3jjzLhCX7qMYXn+NIuA4qFWpH/ofIlF0VHK6ztvl0lS53lgWS/MDVQjBPQk1V567qvTvTWN8Nb05gvKZQhSK+6biS8GtbxDY72rDOyj5TjJGkgqBuSB69RKRJGW91yCXLks7eIzrItHwnYa2SJbQcTnnyM+sc833sGjC8mg8srneQ3m2B3XR/vdTer0gVsFu1+vMl1zHC/Q4ihHvcjEKmnR33TAt6skMzq2hOprVg4LGR8luS0p9E72Vg3AOIlYpM0y6QPe7C+n6naLQJfCFA6KKC25Ul1VZSjlqlSiLrFrg9nJIOpUXUMQtCm6pp3UDELxM8jCp7RXOIYlMiLAaeQ9Vu64qiH1ZA06WpMxYVfslNKBcVDiDlI5ZIWyvZXSpPlfy06eRqJ/3fk0WIqMu5TkUwfi9A05w3FhDuuUB/pACrYEI+gbfodRqUoJP9ShIc7D3sCZaqcw1HhiWrQOQa1xH1z8L6Pkp8CGXifk1hzeklxXc9Xy67lVaNmi+xY+J1QOeqFyAB71HhbYKsnBGk8PTnO/EYcf+moPSmLR4vwPib66dMHnwm4K0BL2vQGvHUFyH9+LlyJmhZbGrsfntKiuygiMUjwGRVsHnCh5a7gKl+wMM5wCXrNVaG++mdAsSrbY0I+xsO1Y5cXccbwZ6ZIPb5ZqcmfUlRd7jQskyaJBNGNyxoKgGSC3hpjrauDvzNkHOawN39lyfXPROQTXpEKUQe9bi1wPoOviN5bvBuyIceQziP9JlGoArK
 r/hvwuwC
 90zILjpYAsUgdWAn6YZzyECh0mYmj9KDI9dKQ8p8CncCvkglm5DYSgWgwgVIt59UX+QeZ2h0NsJzAeW9HByfvkAR+Cv8yPx3SLmdIC/uyf1HgNki/a3Q3GDI+t42naL/tJt2RVzxJ6JA32i0WmXWQnY8bXLg3FiWx1x566FPEfDwWhQ4Nj4GV9VTWmb8WMGKQFZlrHndSm9w6/auc2Q/+xWsx63DipZeVHYnRI7nnCbM+oIBOJVla4Ado1A4+KyrEW8vdre1qSPgxHi9QKcfmT/f0RpZKni9RT3jlNPJmf98AOsGap5xla/CC8xs8TLVmhPsw3iiNFnh8zyiCrrkn7Fs/P+cHAXxHodBAgYeQ4y0Y6U88AjxLTu9evqXimaCQB8PHw51ByS3dVRWvHEQT+9wg7h2/GnMmpTAJIQKcoLApkRmLu47jepIkFVFXVC8hbWoe6nSnHw/bHdopKHiGW+83MYwVDp659laGahsGSS58ole+TEH5VuM56z+ftXbamDUKi+lT/uK3/UFhP+TMLc3rrai+F5loVKNBKQP2bxljTB31Q/z9E3lb4LWYCWBR9FQn/EyDmDtVrrDdn5FK9++7sV2rDLvYwa6hq0lzPUk18SVXgoaXYxrMgASiYZfXJ+VXBkv8vqyQsGo/uaAQsm81Rh6obhGFbCRL6TH3aChrl+r0Y43mQMIIi4C8czDtxNgd4vHGloHunqVpya28t6sqngzB0Z7SCvo1MCbDFOVo65A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 05:29:59PM +0000, Lorenzo Stoakes wrote:
> >
> > If we want to avoid the implicit capping, I think there are the following
> > possible approaches
> >
> > (1) Tolerate creep for now, maybe warning if the user configures it.
>
> I mean this seems a viable option if there is pressure to land this series
> before we have a viable uAPI for configuring this.
>
> A part of me thinks we shouldn't rush series in for that reason though and
> should require that we have a proper control here.
>
> But I guess this approach is the least-worst as it leaves us with the most
> options moving forwards.
>
> > (2) Avoid creep by counting zero-filled pages towards none_or_zero.
>
> Would this really make all that much difference?
>
> > (3) Have separate toggles for each THP size. Doesn't quite solve the
> >     problem, only shifts it.
>
> Yeah I did wonder about this as an alternative solution. But of course it then
> makes it vague what the parent values means in respect of the individual levels,
> unless we have an 'inherit' mode there too (possible).
>
> It's going to be confusing though as max_ptes_none sits at the root khugepaged/
> level and I don't think any other parameter from khugepaged/ is exposed at
> individual page size levels.
>
> And of course doing this means we

Oops didn't finish the thought!

Here it is:

And of course this means we continue to propagate this max_ptes_none concept
only now in more places which is yuck.

Unless you meant putting something other than max_ptes_none at different levels?

Cheers, Lorenzo

