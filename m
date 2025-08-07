Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69967C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF498E0006; Thu,  7 Aug 2025 12:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC58C8E0001; Thu,  7 Aug 2025 12:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F158E0006; Thu,  7 Aug 2025 12:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0E248E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:16:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C6B05739A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:16:40 +0000 (UTC)
X-FDA: 83750464560.25.163CFC1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 970AC10000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:16:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UZJ6XO6O;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f5gJl9cq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754583396; a=rsa-sha256;
	cv=fail;
	b=LWvOHdoIIIjJ3sBHp9WbrwcONFb6lRoIK4ANGhhvfP55hwo97PYN3xB3Rfyms18dQT1sN4
	qKWFmJ/wSj+MzRP/EIi7z/vV/AP7QPXaaRstXTySn60j2HzzAtJTkLBKG787FYAhFRcI6I
	tE3U1MscQ+dnMbzROuXBvFWLmFsIfiE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UZJ6XO6O;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f5gJl9cq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754583396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzc7eeeH30MS2lK8XQkCrSEF28SpGSTCZ0VXVRzKQw4=;
	b=fegG+jAtY0PkE5OqlSDMwKS/+T07Wm6FQVlUMtAUBvkTNd+tougwMKiyHmtweKbkcWmQi/
	xp9s9oxBpX+5tT9v3p9/TD4IOlXvFu/t+jmcQLkfH7DyMVodoLLi0MvZvNxe9a1EIS5Srb
	YUGjpVvTPnWjNl7hRIhyaQHTBq1Tnlg=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577FHg9C016683;
	Thu, 7 Aug 2025 16:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hzc7eeeH30MS2lK8XQkCrSEF28SpGSTCZ0VXVRzKQw4=; b=
	UZJ6XO6OFgxt8GmzLQQ1IJk8VR9FMEpMqQTAAf/iJEcMEdyxo3SvyDig1oKogAte
	vOiUkcP78dqUSaAZ5SdNRp3Zq3YHYvK315TQxFOCd4K961prJznTBpw1vX1Ue4Pn
	hfqSWjKMkau/NOZMElHw22KQMuGfSnKZE0m2ZgAtePSidbvP2QZIMV6A2IG61Erf
	SLeF9VYQFpPl6XbFg452j1pQWXiaeEA95whfFPJydrmbeA9OYM0MljUuiVR07mJG
	Xof9PCV4RvLOga51wwgWrsWSph9OKi7YkHQPFqWymlNEuZaO6QpJ+GrIVbE7McFO
	ftvGzlZa2N+7sOrKCudRtQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvgvej6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:16:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577G7Cuk005717;
	Thu, 7 Aug 2025 16:16:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwynhe0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:16:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fFC1h7syxJlCvHyCGhW/wf9WmbAIwdzLGc3B8MxLvCdtGbqhWTDeqO+ELws2BEyC5i3u3WdiAd+DHbzoQIr72+pXmt/bMa6AjvxdsMP4qKdB09IM9JMzb/rJtQe3mnNhOMPgG/c7aAe65//jjuIZ/ey+jtQmnbS2Ftqv4v/XG1+2og1l/8pINWEydrj9ZJ3HMUk7lcUy45v4V90GWimPDTgJ4ccltRoL59ZTe3uLR5RLQrElcn5XlBlx3YGk69M+9INtwhUsUFG958Fd9j1D0U56mn0PH4rGozvR6xw+Q7PV+i8W7GUP0VEsTWdJruenE0u9MlfnMKYGwy2/5CEebA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVaXoS4BdrmPsuXntffeAK4kXMt5wuOKIBSXv8B3wcY=;
 b=rfbpwJ1Mm+WN3HXj0eu7Opasv4wkHflKSWDSIxFlNTSQaEm9Wn4S4gWlnep1SWOMwO/JaBm/q+JPdQ+hocYv8Z3h476zYt6HzSMfqF+SnTYQjnSCkJ4Z77p5qWeFu2v5AHzdlsfiShxhDYwG20LYEV8Bks8GcLvSBCIRy7XtMnKH2t8YHs9XWNPDv7e+y6PnN7+ntUnDxEkLm0BQ29kr1kenqRnx2CRVZTin2Ex+XUC67S5xJ401kIv2v8NrrkAd7tw3QS1QTLtKwTvj0L9hcDNH8vQbGkQFzbIBNAgiwi0J8/86baowy26Ynt3YG24s0GyZ8xhmZfMhUbuvAFHpew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVaXoS4BdrmPsuXntffeAK4kXMt5wuOKIBSXv8B3wcY=;
 b=f5gJl9cqCxE/ptZw/ZZ0HZQbL8Pxk5QFlfPB8fZBJK5yfqyVGDzmVogVH0hd16KkS89MxsHrTRJ58KjBJ3WC8Xz0LjZojJ9mfsOixYEFofe8MhLffCfFqzFWlFg1RgjcsX4NkZEb+SlLjGD7xpKfXB5e8u7p1Jeh+3PyJhKRJZI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB6834.namprd10.prod.outlook.com (2603:10b6:610:14a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 7 Aug
 2025 16:16:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 16:16:10 +0000
Date: Thu, 7 Aug 2025 17:16:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
        kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Bang Li <libang.li@antgroup.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        bibo mao <maobibo@loongson.cn>, Hugh Dickins <hughd@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
        Lance Yang <ioworker0@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <923f1a9a-4e34-4922-ae2c-c8d974c2522b@lucifer.local>
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <97419aca-af5f-4328-84dc-c97bb73ca1ac@redhat.com>
 <96e931a6-c70e-4a11-9e8c-c5a08da7f512@arm.com>
 <66f44615-8df5-4e81-97b7-1f6a01401687@lucifer.local>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66f44615-8df5-4e81-97b7-1f6a01401687@lucifer.local>
X-ClientProxiedBy: LO4P123CA0555.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: 82e47f09-ef24-436c-4b6a-08ddd5cdb8ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?97wGbI5WSOBn4eU7Wh1HyLcZr3rjg9BzscyCfx6EiXjZ10hNbgFLUnsL6Y?=
 =?iso-8859-1?Q?12aja8iLcC+xQFILZiYfAHVlATIx2bOgV+XCkcEhOlzouSzceXh/YmJ6YT?=
 =?iso-8859-1?Q?bSrhoTyAZvt+diCBpTrFOwiAXNZXNDpwOk+qo6LLD1/9ukL/rC4LzGf/Ls?=
 =?iso-8859-1?Q?3XtYdp5CTTHEQZ9951e+NtEPNc4xoWIm03cSkH/vR8RQghiUiVYAwVm4hv?=
 =?iso-8859-1?Q?3dGaDbVu+DLNZjXQPNXG0Txef2kO/aH3gPoN0iRlNku9N8rMRa/8ioy3Ss?=
 =?iso-8859-1?Q?qFdv20/yNE7OJl3YrB2zjqLvVyuFPx5F5PhYKZoh5x2FTft7Qx4gkFmBzz?=
 =?iso-8859-1?Q?vl5RTtBmJ33kqsiIsaQRfxQYRfidkMkIyQFdDic6STqXkgMpe3N/650lY/?=
 =?iso-8859-1?Q?4KLh5pCLKjuLdZ9QvoZkpilG372DWiTMpkHseo/YwQYlBrY7vjKpSaNQN6?=
 =?iso-8859-1?Q?tO7d/CvMibFem5WO1FPFNsbQHKlqtGtSIgdip3B0kBdKaeDBzJ562CUteP?=
 =?iso-8859-1?Q?6J5tdd/ZaByRXci1CRmD2ZEh2QEavrvByenYQmW1sdUF5b23UV2GWBfONS?=
 =?iso-8859-1?Q?cCl8U6nQvyco4rSRWd/DNmbRDccJHMTsSAck84AOWgfD/l3ZJ4ZZusDlj6?=
 =?iso-8859-1?Q?6BzE67pD0G/fziRWslUEfy9EXD2CzbTqHxSixzlLANdWl8jtLNNGvtGqJ9?=
 =?iso-8859-1?Q?t1EpfI+ZJGDXD76jm2+WKPevP2THk3fM8yB0D/woXlMI35hVoHoNOZDQOW?=
 =?iso-8859-1?Q?Pv7wnAMVeKeF4mLMsdAp5f0DYwlLogJvAuqDdNop4yZv5BG/7IrSHbsrAn?=
 =?iso-8859-1?Q?pzjMG+xj3qxLm/00AhOlRhw5doD2YnVEZMT7Nd3kW5MnlykKN7rmQ8/Mf+?=
 =?iso-8859-1?Q?oUIdyVKqK07+iUCh2Dre49fcrj07qpTQ7QDf5t9egkFKbFvG9oM4mK+URU?=
 =?iso-8859-1?Q?lF99xPB2OBMNac6exrAQ4NKmRNxjUR5fGm7QY4aC1ucwewHh8kbgaxPG/8?=
 =?iso-8859-1?Q?tKuQDt74lvtzj4Rv3FqQ7vtrqZ2ZuojgBfW+cCNeGWiLDuYXJHwku1WHzX?=
 =?iso-8859-1?Q?v6mvxPx7ZSM3STBIkPugmcn7rJCKv1yOma/r04kTUqrlivHxJDNinuPnEE?=
 =?iso-8859-1?Q?bLOicsc2W6U4eRy7XMy8CwEc2LaeaGiTmLLskoY3u42UAnmu+BL461RLoz?=
 =?iso-8859-1?Q?SLCbl91Gb5Kq7WSErsAiCrlMMTEa3CcEQK2TUiIWPKKK4vzDL7UEM8gMsd?=
 =?iso-8859-1?Q?We1ZclFycTAN3w/tnlsU+Bp+hpUQSfGeQuRO1rtyoVvvOcGMWZv4AUAz0Y?=
 =?iso-8859-1?Q?ySLVhd95BANjvvKDSexD+OSSxrhefEFBQssjTBGHNcg2cwGi1A4icJvBIx?=
 =?iso-8859-1?Q?vwFfiCKW+8Redzb8QIzyMHdK6lrUmIsMM8WWm7D8BqFgtb/GwmNVvTcGiW?=
 =?iso-8859-1?Q?sxj2BmY5pvs/7N6UM4bXIUIrrwrT4Kzz784PxlT6zCcVQ3VyHYoD0MBj79?=
 =?iso-8859-1?Q?8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?O5pOXa7JOTiasaOOAAT+NCNjt/8tYc2hnQOhsksIxtUpAULviEMI73N1kq?=
 =?iso-8859-1?Q?CzsFioWFjpQn24NFT7wQDnY+ZMaX0lpIwLxdIiglTBYzcQ8VNZI/m0kHWY?=
 =?iso-8859-1?Q?6AfIWdUqSCAzSHuvm9EUsS1AQQzpM3eTz7n0C/92Ao5MYJgsgjzzyvaTkm?=
 =?iso-8859-1?Q?usIj00UcI3x7nZjkWFWrB4paXW0ZCglpU1jD9HyWJ5T9DS1HVMgWfIp/Jb?=
 =?iso-8859-1?Q?W8wAVI5oHj95QZy7OX3lkWwdLAMuqFkZMqVXHDwta3c2SnE+QwBfejj/pt?=
 =?iso-8859-1?Q?HqEQkhKpwNNK3cGPdJDdkxw06Ne7XHemtcHdCcIbv6CFgaH1Mvngzted5g?=
 =?iso-8859-1?Q?3vuME5s+ROJL8dPDtsL3I+okSP+gA/AG7RscA5nCCC2dHoCty/rk8Ajz14?=
 =?iso-8859-1?Q?nHj1J+BY7Cn6uC2EzhCgyMzF1OdxL99N0VIAgunvAoeEciVHIxA2ExFp8U?=
 =?iso-8859-1?Q?UmwGRxGIHdy15YAcPO4pH8iFWN+KKj53tk4yFVPul3C6JMqBOvFZCKNA8a?=
 =?iso-8859-1?Q?cgnMX9cJuq3T6ygUe6XNP2g5cs3Axtt1aAyKCDDTkV00SjicTyUEMFYkHR?=
 =?iso-8859-1?Q?BAr1/VC7pSwYlksypjMW6ZaeAel1hGIlGgqOcUrfuBxaNccKB9gtQVbCwe?=
 =?iso-8859-1?Q?r1Elt/RJN3R4eoJHaK0lvM96ucuOYKvaCq4f5f5JPawXq/H1Ge8rVOcnJ2?=
 =?iso-8859-1?Q?XTClwHe/O3XagWwkvI+MB7I3ScMO5sXGuKJYReyeFWRyVjOFXXefXoobiY?=
 =?iso-8859-1?Q?iFk9o2JiSE/G6P7NNn5x4h8p+Z4/ZeDK3APwoUJiqXJs8BgNh630TPjOVA?=
 =?iso-8859-1?Q?I94BMI8r1A841wD+8auIy1QQbQG/RYD9+oIebN/c8M2/cOJxX4JhCOT2Ct?=
 =?iso-8859-1?Q?zRboyB51s0JZpFY1hukobI44ci+2boAYjjBh3pYjCe9v3BTDcKOwAn6kSU?=
 =?iso-8859-1?Q?G3iybsfd28q9tRpTPlSpHZ6DRWbZiNAOUhy1AOk37NTQHvKPkIocl6TRR9?=
 =?iso-8859-1?Q?5DMG4eYfibPQj6Xw67G+n5oWWjiQBGNQFdHMNM5dYax7f8iD/ZoBfQ24Rq?=
 =?iso-8859-1?Q?HYGBZcIG33NeC9ouGAFFOtJTZI0IunNacZVrrj9LOdUi60W9NQ2RAHNBp8?=
 =?iso-8859-1?Q?goTwkqPMl4Abd9bpA3GzbK6Yzblc9Qt45avzGh0gpG1ujhaBrpz1KfRCrd?=
 =?iso-8859-1?Q?HVcE3bWvT1xCyfPeFNgYmosDtBwVzK96b8AiMqiVf3ToPHOU4gH1ZnxNX/?=
 =?iso-8859-1?Q?zI1k9tNFy/bHRdyAg4aEEdBJ/S8+3XABxhCPqD03Hlqk4JDd7BMjlGCQtd?=
 =?iso-8859-1?Q?4C6FPaMJTygz6q91pSwUHC21geFnr3zyIs5/+bTw6gih4YQuoYV4UvAaER?=
 =?iso-8859-1?Q?he6k6UZnFit52WeyO+NAvfifDq5Igo7JSAmicmI80+XH3AT7CVxJg7FOpo?=
 =?iso-8859-1?Q?ZNlZ7OlX6fmPM1RVCRB/u4jCw2WUQNWsvv3EmFJsZ3mUeH0MLzfeKfXItP?=
 =?iso-8859-1?Q?vsNZxHQvHZDzVylyFee2CttHtwuGUFc2JsjPzgr7gRNSaK1F4QbNi5EebD?=
 =?iso-8859-1?Q?VlZEcp2s6yx+Hp48X8RFPH6yuzQ9Pva4stsZCeG7NPvbOLNd9r2FS/AuLR?=
 =?iso-8859-1?Q?FjQ5OgoT1mthqLSLabb27jWWJs2KdJnXnczY7tOC4DQVkqfC6WbOS+6w?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gM2sHetLDumiSAT3pL03eenrwRLF/eqz5WJFNpckwxy0g/6lzpPFD+95f3m5HfV0lq86hNBbBEYpmLWOB57IgLkO5R5g1H+2/UsDB/bpDWLl+YgQjS/R2PPa8t0s6xK0VBfP62b9ASYE53iHAVtYB1kReoef4/hHKUgXPDY1mqJjfz95705KDRCDEAt8JiKxeXUVA90dO0NNDKIPI455Fn+do1IujKrRLRrzio07UIuFoxOWj2xgsz0MXekH89NgQz1kVCyokQrJECTVy6ZvKHMwK9I7XBe3U/r2z4cImf9/kP1zF4hzJE6AUanHPFI8n27BPUqrLkxa0BpG8b/B1RhKXaEMGHDA1qfDJuZncCNO3o5Z7/t1rzAbjYKSqMh82pA7wnvEV2Ej7s3PfOBbEN4SdvuoK7yythdFKsG4FzAHarN0GL7x8ERQvCGNYp18fCZ+Zr1q3GmhfYF9MZsWXmNojcVoA6XkwhBszIGgtt+XXHAZqWWCbyBY1m4/KThehQO2uHtdrgmuHlY2Tsmj4UOlbHG2KBLjXFUA8qhcxDcsJC1AFT2w8opqdxAF7Q3vOlGhWIhkHRSAjiaun7J0rr7LzrLuDCe5qOXSXbku6Uw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e47f09-ef24-436c-4b6a-08ddd5cdb8ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 16:16:10.4761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9WZh6s/dGIeTJZJX9dS/d6sU3Txp4CaV+bDLB2bd9NZniGelZpZZ2TyHG9fgp5yJakx2AeNwFOCBWpf4ndkAYbIkYdeC1kO4MrbPC6jbOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070132
X-Authority-Analysis: v=2.4 cv=WMp/XmsR c=1 sm=1 tr=0 ts=6894d14e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=j7LZYpJa0GewHEq6gWoA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 cc=ntf awl=host:12069
X-Proofpoint-GUID: st0kLdBAc0y6rU1X2v8SEFdNKtEpGRTb
X-Proofpoint-ORIG-GUID: st0kLdBAc0y6rU1X2v8SEFdNKtEpGRTb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDEzMiBTYWx0ZWRfX6jVMTxnL52YI
 5h+AAiFfCzDTJEN8tVzXVO8RI3tIJ0njYZFJuHfW/N5oluWJUbKyHF0eOyIj7eJJ74O++uYKZQw
 AVMtFi9dnpuocCS6FWaWLjKi6CwKvo8IDOQY8pNdgMMDqi3k6+UuSAf75cqFpM9H5IN0GuvqZP2
 Ba8qnbkWCh+gzLmgaDLtpo5c5TwQPPQwyTbFkiP4whvUpnz3LfxydDFGqsIva6cSft95dFRsYao
 Z6rPV9me76i4B3VahNDEKgCeIns8Zp7wQWI0/Be7aOp/DH31bFoeWwGHUtuUp8aiq2DKeYxtgnj
 xckMaSPjnjfrsojcY54A8jy81onJOGpAKYLlmxlbZOLvedQzcvm0H7/KxbEz3272yLGTV+EL69v
 NUEqzu5OhVxNMwwwQOG2WlY/xVCj6YXX/v1gmcr9OPq7HaUExanAvxNykma8u//r4K/2PnxO
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 970AC10000A
X-Stat-Signature: j5gr3pa7xbab5sc58754jsrrm6m6rsa6
X-HE-Tag: 1754583396-603727
X-HE-Meta: U2FsdGVkX191CKRvjHek2ZHF1uUKQA/e33+w8LIQAu5VQajVDStO9r7lGPcAPtapRq0XWeSK9Tnkcd002bqK9t08HAFaABckO/j4XsNscKO6oyCi1m91BCINPsJRGAQkG+v9nD7yY+tkd02nulZDQTQUxZgrE9qwC0+IF8y/Rt+cqQ8AZ2lSYtAliVUtnZrxzgxGsu3l1y6B83JZaCucrNfRVsdu8MN+jw5Z0vSt1ojKp0Ewc65ja8Cz7PljQ1qP9NAyrtnEWullJbmLik+SRbcaQZkLLnoTFzT1iYNOHygwAKfti4oup/riymnm1EpoOTFEd+p+IR7dRQ9wFEbYN1Dyz+4OEpSS1l9rDYlsx6Y7nf6y406GAYYgn1F3svZATheej6dGcEsQKgaE8jxn4mmi0JH8x3fAxtSRdbUmYzASxQNOFOpFXNJQsuvghj8+hLyQWFxXzwAZs1QO5WAtlexzF5FIoYpAA/1xR0Tvu1zzgx9az8Q2FL5BMUSLDps/KjRZer5WTDH7hOEW8F0WXQId64/RGyyns3dFFagOxE2X+st5xtKV4bLHgWTjcEVj1zSYWevad3SHo1qAonyZBFPy0J1Lp+Cv/tVRsw2+XxToninTUe+Lf2WEVvEoacJKG7KGB8iHu+6/n8MQBTcQoAxU7z9erh3OFF3QL8UhCItRRsnRdR0vGAdYNeE5IcguHy1n/8Y+tR8pYZdab61zjmbc4LFLOoj3hIts+R1jvKgqWhwnWlGgT7D/O01rIefcfAkLryFq2lX9p24LqStJQu2HhTYSy57yL4bk8WVQ8NdCvAS5NVesQ8BVWZDYB323cGcgjRRZGj+yfyWW6KMUx0C51w1+X6TLV9wzNt6xfvBICfGRTJhv6tWB8i+4MX7NpTph/pc+MSpbOZXwVYJplKIBQiFPTrC46JdaVzKEwfZ6Uz+fFQyYD4A2zDiMkjxaY4wn4xc46MSkcLifayx
 yVidZ7/A
 EgKHpvquLHAIqhcqJZ8Fg9mJn4000bY2bYQXQncbl8gUxLVrVy88056HjTKEhPNQSZjIBBISTjQPNWhoE1AqBF4+RUc3rEX78o1vUmMBcSvkuYYRbJDTtx4r9RU19VJ47ONbjUVoi24CbfoJ0kTd9SodtonQoTjjuyYk5KZ7K50Dw9NDRbPG9wpiyziOZIvUeLYUdMbAZgXDAD3fneteTOVYBDGcRwIqkVAmhDGllfhqMtMXj5rZCkGbbZWgYa3fYpev9qyhCN0vVmbsub3OGpbOvVCI5E3cazCJDwxv9CRbWkpVVuU5xHQjR0eY5YbQ6DBShuMb7tStFsnDJuxLd4RyX+Pt3f65Y22ZXXvjZ7gZf+s9FRizYVHeXxHJ8+GlbY3GYa8n6SZJ4Wj2ajTFaKlVcgU5Tby6vPNkUrV6TmhAvJBMt2CvG/zzEKlSfOhqTAZi9Ikpf/x3b3zkxC/j5rriCPPblCiBIvmoFbmqo6OIIOS646rCZcT4lI0ysGsd+TiZu97WJyuK54NEaQjpUWk3sv3M3dDzeTmjW8/cLkKrrH5ZYJ4KcQMB01BP4+obDcYXNZU3HlKZFytBtxyJbRDbsUMfR4Gj1G8rVzAoZI4f1SXvKCLBAd7lNb7bK7pYIyNbLE3YNJt7lUdJ0BHwUqLuHErAngDQOhVfmyNjW8gxSVu+wwcOkyRfJ2yo8UDcw1/KnJyyUxQCMpFyCz2JQZ/EbrpGRMEOSe2iiEKg79YFmDCb73Q86Kw27mtWrglYsAiZRejNj/HRAl/pKUI71Qe7NaAxA6flOkFAyiJkxKOJiR8xPNfSx7lGQpzb5uzwSwYhIaH8y4liyfHVXD6r1mCuTqPDQhdh3k5rRRpIBWqajjv0fvdJihL8Z6K0ZlWrtNRLAHxvpY5xIANi3RhNDbDF3QbS+dxn3h7CZeBlVmst/54iwYque1vwhkMKQ68ibfeIu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 05:10:17PM +0100, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 09:36:38PM +0530, Dev Jain wrote:
>
> > > > > commit:
> > > > >    94dab12d86 ("mm: call pointers to ptes as ptep")
> > > > >    f822a9a81a ("mm: optimize mremap() by PTE batching")
> > > > >
> > > > > 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> > > > > ---------------- ---------------------------
> > > > >           %stddev     %change         %stddev
> > > > >               \          |                \
> > > > >       13777 ± 37%     +45.0%      19979 ± 27%
> > > > > numa-vmstat.node1.nr_slab_reclaimable
> > > > >      367205            +2.3%     375703 vmstat.system.in
> > > > >       55106 ± 37%     +45.1%      79971 ± 27%
> > > > > numa-meminfo.node1.KReclaimable
> > > > >       55106 ± 37%     +45.1%      79971 ± 27%
> > > > > numa-meminfo.node1.SReclaimable
> > > > >      559381           -37.3%     350757
> > > > > stress-ng.bigheap.realloc_calls_per_sec
> > > > >       11468            +1.2%      11603 stress-ng.time.system_time
> > > > >      296.25            +4.5%     309.70 stress-ng.time.user_time
> > > > >        0.81 ±187%    -100.0%       0.00 perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > >        9.36 ±165%    -100.0%       0.00 perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > >        0.81 ±187%    -100.0%       0.00 perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > >        9.36 ±165%    -100.0%       0.00 perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>
> Hm is lack of zap some kind of clue here?
>
> > > > >        5.50 ± 17%    +390.9%      27.00 ± 56% perf-c2c.DRAM.local
> > > > >      388.50 ± 10%    +114.7%     834.17 ± 33% perf-c2c.DRAM.remote
> > > > >        1214 ± 13%    +107.3%       2517 ± 31% perf-c2c.HITM.local
> > > > >      135.00 ± 19%    +130.9%     311.67 ± 32% perf-c2c.HITM.remote
> > > > >        1349 ± 13%    +109.6%       2829 ± 31% perf-c2c.HITM.total
> > > >
> > > > Yeah this also looks pretty consistent too...
> > >
> > > It almost looks like some kind of NUMA effects?
> > >
> > > I would have expected that it's the overhead of the vm_normal_folio(),
> > > but not sure how that corresponds to the SLAB + local vs. remote stats.
> > > Maybe they are just noise?
> > Is there any way of making the robot test again? As you said, the only
> > suspect is vm_normal_folio(), nothing seems to pop up...
> >
>
> Not sure there's much point in that, these tests are run repeatedly and
> statistical analysis taken from them so what would another run accomplish unless
> there's something very consistently wrong with the box that happens only to
> trigger at your commit?
>
> Cheers, Lorenzo

Let me play around on my test box roughly and see if I can repro

