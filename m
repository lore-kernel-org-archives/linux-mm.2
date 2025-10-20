Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5D7CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A358E000C; Mon, 20 Oct 2025 13:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722088E0002; Mon, 20 Oct 2025 13:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E95B8E000C; Mon, 20 Oct 2025 13:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 479368E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:49:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7256850F4
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:49:49 +0000 (UTC)
X-FDA: 84019230498.21.651FD26
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 570B6C0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:49:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="a/d4+SWQ";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ATw8sito;
	spf=temperror (imf10.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760982586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8PZgDt27f9zWMJrwqxnWCO106lGzayeiGLGneLQGro=;
	b=RnBOJCBaVE7XRZ3Y6AWaxwFEsTDQAcfMeGOT7Y7Ht2E3y3T/Sa1l1nph8DK7vU3mknxfxS
	0ZX3v0mGZRFS7zKm8Swe5OHuFctgIZx+7UnvQVFTbgCiTGYmrwNQh3Uo5ALPKPEcPDCriu
	kWdUqyt3BbWeqXdSLWzlNWyKmw6oLXI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="a/d4+SWQ";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ATw8sito;
	spf=temperror (imf10.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760982586; a=rsa-sha256;
	cv=pass;
	b=ohSTREmMPAs+6lRNyOpNz7zGDWhtre6e1IZvRVjVM2NPeIknaXlPVDuZDpZegGMzF6MQ++
	xWZ7hvwiX/sNNC5Oua1vr8wmTUpG+Fp5lFmiv9h3gyR6W27wPN7jqgbYf1o62xUGvulQy9
	bDCt4EEPGexKe5FQPqqhY1iPWwqfjB0=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KFkF7j031864;
	Mon, 20 Oct 2025 17:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=v8PZgDt27f9zWMJrwq
	xnWCO106lGzayeiGLGneLQGro=; b=a/d4+SWQZPNCSOE+7vZ1/4Y2OCFYstE3+/
	t466YgAVW6y7BtLCNdRKC72qGSnphIgSRxn+Gho8KSsEnumqHzxQzwQruRM8Oes/
	L87R+EQEm4kgex8Zk8vOtDO3Esgsv7B1+SbHFEXCVHEUHiveARRtPV+ydOQIumtL
	lVgmRRGJLoX67q/oVVh2b64hraMa4kzbERKWAHH7CodBCYqWbTTanbGA6odGzKMw
	SkYmarx+IlmB2yr3K5un8r+2yUlAh9gaFvWt37bWEF0+V6VUywtK9SbFf96Eky7J
	KvIjnC8JL6bLNOuwwkcSiTE/TTdGhtIcK3jONdORqxTdtsQiyjkQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d2tmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 17:49:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KHC9Bw032281;
	Mon, 20 Oct 2025 17:49:35 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbybts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 17:49:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mKk5chCfUFmzymyieM8r7MWMGU1W//w6anStmcEQTGtPI/zgmB4R7QrPfsbJfdg2WCV4aENL97eiqRdt5Tpko6/HofHuc8KKoCBOSJY0N532cVzG9Rsu01QM37daPDLB39zOtkcJxuteh46eGx/3sBEeFYkT9GXCg3mjfYhOOiNbLk7nixDnppBiX4pyoAwI9ihWbkeFBIhnJ+2NGGhWQ5VoAfTgniooRx2BpKuPhDHKXhVKYeWD4frdUxF7aSaM2OyRxF8Ec0D8nsX/04RK3dpv+TVpGS2zXp+uPkyiA8kBQqOjjI4sT+YJMrTg1JCkxZWXgqy/d/+PvPJEGje7oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8PZgDt27f9zWMJrwqxnWCO106lGzayeiGLGneLQGro=;
 b=rCg7NY0mml+rvEF7oewTEtLSB2DOGvczIHmkZPG5wgSreaskrxzjNP1cPeBMPxsVXpoHSeghYplzWd0IIbWGGNh3UrCksAk5LthD5vOPSYQLdIWLPnqs6T5PcuvPiZEMb8ZwuxNjCWUVW5PxfKW548JnjAK8fvb9dsFn3cBrON6Ab9FVvBWz3p4JCN/2i+cmoPwdVMaQRGSoYgnkL46l7Ddq+pzBtOdgwLDiogXaILgPpCZ83ckB5SXYWTdiHwzogr4bm+zjcuYBLzRoY2Ze6SFOzwsIsVdUs8pp2ER3/T7+MkX41bTGz6SYY8Zqvfw8zPqSiR6gdrVituNjh3CWTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8PZgDt27f9zWMJrwqxnWCO106lGzayeiGLGneLQGro=;
 b=ATw8sitoiG1ahyUJrGqruQjLz8QJAaCFNNu+bGjM7bP7VhlLft904rQKb3/QaQsc7loXkpI1USfmqLmdm6yn4aCe1GHuGD62u/KW0xfXGO4AyjK7RkVfN4okktFq3SMOKLbYOxXae9iJZnUJR04sjeW7UFuSUSyTiSrqbal2p58=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6179.namprd10.prod.outlook.com (2603:10b6:510:1f1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 17:49:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 17:49:32 +0000
Date: Mon, 20 Oct 2025 18:49:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
Message-ID: <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
X-ClientProxiedBy: LO4P265CA0222.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 981b7af4-8f15-4f95-2fd3-08de10010698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ylZFR9Tey+fp4UCCPD5FlGEdFlzuGk3vG9/VEktptBDbd1O1GTvBNntVG6+u?=
 =?us-ascii?Q?9GVdzAjhq132lRvhhk6jbyjPs+zPRa8sU6+heEcojG5nFbyFozaybfOM/OwC?=
 =?us-ascii?Q?qrOUbpMkJvy0KHLQ55vo4YAgEj6+DJtwr0fVhi5dXOEyOLcszqha40y7IWtr?=
 =?us-ascii?Q?lvS+Onpb92Szv1fDnLtrc/YBF+fxRb7qqdlhiuqegMt2WXA+x3zLhnExjjaJ?=
 =?us-ascii?Q?Zc7/sXCyG0+EwSGcm7+S6qpY2HYDmyEbK+J77JVxqKuB0YoINlqgS7F5p/vV?=
 =?us-ascii?Q?RivcBU0jxvbcJmkfd1Gpw+eLYA4MRD9LdO5AS1JaHrHns4oCJN2QvFVfr9LB?=
 =?us-ascii?Q?66vZ5xZ6vQ4l6gXieYxiniJ/h49lvokEvm5pLZw42WQ3ojNGRzurDPZFQ47u?=
 =?us-ascii?Q?EGkWDWzcyDqyRVTLoUcGAkrarunHSzaGLqqOpW16QEczobZjkblVGMKuZT5B?=
 =?us-ascii?Q?a0ajCczILoEiUmFfHqggiS+mABoJ0QmEUuR9xDlXBebyXYEIBu9nHsc6ixV+?=
 =?us-ascii?Q?y2b7J4njb52qvbvWPpDEd9xIlvsxaSQ7x3YpsQFmoqDQQDaFnbbDY6msWv+e?=
 =?us-ascii?Q?W02pzmwAwgrbvf4dxGBPjp0SxpBGj0dlPQI9OgLFiEqvIZH8Byq9cKa2E88F?=
 =?us-ascii?Q?7sfkCZuO4oB5O0LzaAIY5me4oW/lLdYsNZ1653A1MLuIqr+Q6nreREEXTpnY?=
 =?us-ascii?Q?CEK4K5iHtfQSpWDenIdJA/KVhzXwTUQIfEzlhkZKfFhBnUOaWHlY3/5J+YPB?=
 =?us-ascii?Q?6Aykk4Rs9R5AVxIG7eSn05f/i30uPTyJQJojFRHaCF6UZRw0pdVTXomurlIy?=
 =?us-ascii?Q?yojaQjsKMf2ZGYLU4050sJqQVcDa3cV7Gpi15Ncc6Ru6glP5QbT1KkfbjTK2?=
 =?us-ascii?Q?/V4gli/wfT2g4kFO/UZoXGqWLCCtUwcpcy7080Bm5SLWTNxG/BUrsAM0kPQ0?=
 =?us-ascii?Q?UVUL6zmBHuYrQy2M566VeQ9caS7NBLItuvCKLUGP8JDIEhHgWq8YL2cuS1ad?=
 =?us-ascii?Q?gcJYypPzahyt0ZPMUnb5nZBusC9HNYN8AJ3YJsmACpGa6rzCnc63MA2vN6Bm?=
 =?us-ascii?Q?fuRs1DioTxwYRLrjEAxrsISGsWtX6b3EpYNCP8aBOAwNLV8WNfX7IzGB07XJ?=
 =?us-ascii?Q?7Fjy0OOcpYHoL4xTu5NPzCCIE9fI0bCA2cQQunCrcsSju2LAjwgn7QOrWLSQ?=
 =?us-ascii?Q?stGXLf3nxgLi17vDgfzY7aiQmnc0f5PqPRxAMRqvINcNV/ob3VLcRZoU3vob?=
 =?us-ascii?Q?yWsIXEnVwNEQ3TBovFAw4nETrqg85oDRVhcpB1x0oS0q2PsZGRqH+U4u3TLC?=
 =?us-ascii?Q?PwXsZfOOMdw6Pdzxxob/Tn3Lsowz+1xEkMkyTDuAAabI4BXA3aCCY+PYEiIr?=
 =?us-ascii?Q?swQBtJnfw1ElnwRIEA8bjAfuz0GkqnavvHmtR71sjZRyfJShGxWUVyvmQc8T?=
 =?us-ascii?Q?BRuTav4LXflEW7bwcpiQn/q6ngJBKN7h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h9HhVHfzLDjPyEAxZ3zdxv/ACYWR0kArQWSAs7TigW/2zES2/KZBSb3YieX2?=
 =?us-ascii?Q?eFTbsZZaBEF/yypUR1PoQ1OAPTPeffpiu+QoTsogfVSU8RHx4kbjcFbSyfL2?=
 =?us-ascii?Q?rNke3v0pvFaj2qvO8NwGeads5WoSF3S37fOdBXZh/w4AbXi1oG6lNhMQwJQu?=
 =?us-ascii?Q?wIUFJ3BzEFqzw2mBnWm1fQyzxCPwbHkhECIxNFTlEg1+04oT+XmTEL5AFs6k?=
 =?us-ascii?Q?SPrCuY3cxfrzLR86BplhBkFdORunQpKUvaTJdm4UtTYUjgL6cMW/zFFOn4DV?=
 =?us-ascii?Q?ViVmiVSif2zUbJ0Ok54xvSsR/R+3ck6OeonaNztct8tlo1pDR+0IEZP6BD2w?=
 =?us-ascii?Q?4SiZarPoBjoUr7lytoWRpCzQPzm2wxwqg8tyIuD5Iad22ff2o4kimOs9e3R1?=
 =?us-ascii?Q?sokAqVL/J5i/EN2d+tqjyH6Cu7oQLAemIhxx9SmzVB1VZOtieARUSC+QAJXk?=
 =?us-ascii?Q?O8wsc6vtk2mTs0j3/mFS5g+71Sd2HC6SzitDg44OBuDs+ka4P9N537adUS7K?=
 =?us-ascii?Q?TIvE1znCiSxxby3IcI5MrCrZhea4deHutcrdP0lznh1TfXG7ua1UP58SCCN4?=
 =?us-ascii?Q?d3d5i0GyX5NC75gNvtTJz6oXzfEe0X0eYAM18G3lcqNGnE5aoiXgkt2ScCH8?=
 =?us-ascii?Q?sr1h1sQZFjQT6PortNpNijk87YA69G2/qGhEGIJcrag9FlM3NBr/LyRt7+z2?=
 =?us-ascii?Q?c3F+7XI6S2XHQAQlf//gw+w0/cEuc/W5Jpl5i+oK3Ue85ONmV2ba9wrOAATS?=
 =?us-ascii?Q?CeCDJgRMWjFBmS2kX5ftgILg/niytjNeQJNF7mrNmjCs6HOnt2pnUMNj7SnT?=
 =?us-ascii?Q?+5Gu+ksmDi9JDbFWx+geRMOgtACGP1KJeS5fE/SHBDIm6bXMbl9SinWkURAG?=
 =?us-ascii?Q?W+NvRtVECYas3Ne7bPA+EMo+0qIrK5gS6agD1M8Gp6Rq9Z2t563ZZ4eXCwuK?=
 =?us-ascii?Q?Uwm8O1oNOIZQpLoiM0as2OGS5TlFG5pIX+Cak8fe4ycqKm4a8jQWkFQLRAZa?=
 =?us-ascii?Q?TbWSRYfs1XXq7PPkAEWA+lZ1YUIgdYqETpktlQIetOL61eat641Cdna/nbIU?=
 =?us-ascii?Q?Y08dfVN3zraKbnCHVbxZcDGjwrkpg4VqHu4c4qsVyiXHgDmdcEF+NA6uNw9D?=
 =?us-ascii?Q?2V+hEmxsKNatBSU91KRaVHlEz3vaIPRjZbl/ZPm5liBnilX+Mie6h2mlQg/N?=
 =?us-ascii?Q?oih1pwO9K5SJZ7eTmWT0RXVUROhwpqANQTkAFpnZrcQQqZ3D2CnoFV2KABgs?=
 =?us-ascii?Q?275nTRb3OQGEHIKVONYVYtGueO7jZnooZpTHuWK4JY22nHqL6cVB58iOzLgm?=
 =?us-ascii?Q?aDbCYTLptxRg+QfE0RgwxzT3yrzy2vyZ/6CnR5yQSnMx0oJUPKWvbXrriBEO?=
 =?us-ascii?Q?FepzL6+DYrqFSjKWLYrqip/64pZxqMoIslvHNAsaxKwkonXrm/NV3aByuGiV?=
 =?us-ascii?Q?OTq5Y3IRmmQKG6FrUEcnGxytVvVxgwRnLomWIauZZjF4+h4JGo8TZcLTAn0K?=
 =?us-ascii?Q?2IT148rGbTxKOVfH5TZ2YcJfKdemJBqxvETPfKtypqpiCecIqVo+l3x/1js2?=
 =?us-ascii?Q?ht30DhToKv9hpV2PQJ/1d9JvirvpKfEt/De+J/3rZitymA+K5WqARpoTaN/0?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j1PdtBLd+TCFcabjBB8VMWpPgCvQrIkJnYLKoTLxblQuGUjwXyle8OiIyoxN2GubXzUi+Z8y/47Z7pMrKgF44mvUMBnMNSYmt68ryEPBd9w5HG29NTZ98/xojhJZ3a3NY+33viWQyBsahTHeumnr5PQDwxO/8bThp0pvROPu6rsQha9NxhPvlSIsFxuovAJPdK0MKDykKwhcZwn5UTeX5VNnJFXTun0aP7PS77z1DAoBgdOwPwOjuCCxUjQimUMeVwsvE0nsMDhIkCF8qGVA63egSaFbxjAT4t0tTnTanMuwXvXDYAf9k+J+kvfK+MjHnEgN8mCDWl7qVsOEYoSqVeS6NT6s2v7agtbca8GfazK4zDfJKF2hql4eniS1kkLXhQqibI+mVCYUNVsFlYqP4VbukogYSs7ROBnmhsw64hoNebAQBy82SPI+m23StgJOJFIOl+SOCD8xQAGna69itzfij6BFf5G1ft1ZnEIZJuLM9JUCjwQDdlyAw/n6F2zndq5bc3zXG8bwro/w1sPH+dGA5PG38x++8IOgBhrkn0wztiYebaQCDumDMNhUBq95MyvYolY3B1q0pwdnllUU+eZc6hgesSpRvidNZ9wHazg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 981b7af4-8f15-4f95-2fd3-08de10010698
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 17:49:32.5407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o+UKuww7WLN1QKS6CgrNqAcExId4ggrazqZerZSrWIGpp4LsytATdLLbaSO41A85XyMfsyaOOQNf8yrJ5C6FaHhu+7M922Xv6svepAh3AE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX41srwIb+0chK
 JQQda9T7qaYEAuj+xcgL48Fl0pkErIBjj66USuo6lFmQl6mXCS0z4eQVyEGULtZ94W15SEMeU2Y
 KBNNyV7+rD7L2Qmjb19AW7Yd5AUW3kkCJ1XrOzn0D+Si/8GIlADqRWIguLK1Z5p65jMMjgW6EWy
 8qGZi5H1uGqbmdJ03QkJhRo1pxkvpG2nXHxi6SguDVYjnCdeBIh+jAtc8jhZqdEWQYnqQNUHX5A
 xAuc4SpKmQ2qehNg4krU+Lb9WihL3yFafKKilRWCLtXkHShgp4jdzIM+AZRfYWwB6Dyvq8Ps4SA
 qec4EWQ+rMXbK5pku+UXdxp37ooq94DdAr2mVkquliKzvs9F8IG8VhuAFe/mXyU2SMFoKaihAP5
 I6/mUqjtAknOYcbgFJlfnpVHMlvi78dFvdVGDY14paUQH/8ssnw=
X-Proofpoint-GUID: IM0PwEDdhjSniqaeazqS1qgN-lIvnxnG
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f67630 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7DBLd_y_emxzxYoTdZMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: IM0PwEDdhjSniqaeazqS1qgN-lIvnxnG
X-Rspamd-Queue-Id: 570B6C0006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: udtue6pzyrtgtfu165uia8x9wkwuyiqm
X-HE-Tag: 1760982586-38327
X-HE-Meta: U2FsdGVkX1+jlhhM4v04dT9dgbpunUXL9tEd7GRbq1z7jsWOnhlPnasGrfpQhy3lq/RgdgeDT1xALL0gLYvQ7CanhxJODTSVnGqAG2RrhQZg7QsANvXBrRtFArN8tDD95oBQUdUZP9JdkiNDOCHAGKYbgd1AfAqLKCqgthpF5VdJAITxGNjmPgz7wa6XLe4RFsQOP05bQCjb00F5qF3gBCqFeII7BmSUkZYnAnvRAjkESFJas3RlpVn8XoRPL0rBUiyLWIEKHifln4lRyZdsL5AvffKd8R634spVnCVPvdWP+BONxgW23+WeMihrlDKMOa6zDu8Gtk+eRC+0T0GA4HeiDEdAv1lZnLEHxalZj91WHGmOi81Z7SAnAt1AMIU3SPKNl5ILdEjMqZrfc5vLaae+HJ+zuTWwcUuTQb0uNpghvBJyiWNlumyxHwk7tafXO0R3IYuZL6z4LVfbkRu6NsgipU/CirHaKu7LfloGnBvPCojVXbSbzQT3R1cgc1U7BRHcaK7hivLVWQOfpHopMXJAeFkFSZlmpXkxIKCyiyNQWCnJqODiI2EEDVdh83JLD6a1mtpCV1rrUoaNraDTK3YBYBb9vBIpn561gj/6vFtzEjQUNfAcxIbs6++JzlJU4ltWdGUJRZnoshkv3lzblaH55glZRPxGMDuUjinW1AtgjYxkLY30AL7VuCS3Io7jHHza9enFGrW5F3E4aZm8Dxwb3B6TXcZvzoykbZF1SloNds30I991nTpPyDFkc6BPoi+2fwPNJpq0SSov7n3vlh+YTk/Tw1JUGTQ1HmvJnaRjeT/kP/6IgXbjCaTm6Mt56DxQ19fPqY+RUgbKWGBEyWzxGMAy+MkutgO16yZso+lOC0Ce53TotIhsqYh2h2SUolnbn9uIs63HrC+LMt9IYFiuHiBK2pXeSdP82/nL4RXmNDvfIEeYvr9RLJBmu+fxRxSvHgnMe2xFU9jfqik
 l6YBCNK2
 /k/yYVVFCGXHXmxE7WSaKJLgrsG65RZB7iVsTqL8wSV9eR5Sg6+H0dSPpn4n6jIl7rSfZ4etUEHpIsLBJVxvzlsBftqc1kj0569myYk8z1qKtKfG272BVjHSyjs3/izi2iUr7zomAFlDQolhjkDjbxVN5JX4LB0hAiPE5QPKiSfCs1jR2WzwK9CofMPaWxkt3ptMafzu/KUdYvUFAPIkFwj1IT3xWdpRyt1G96sMM1rFrlebadE8Om6hpY6XWd4c6hrDRrnq8D6pWOVYcPB42IxwbsghpMBEEOY5IrYR7Dzsp34MIn5FjDj3LgZ+cF63PBWC0Q40i/JAXPD6iL++Gn8bO898fkPE9TP26QP3W3spSrtDBpycjAxxMkqBy+xgdHbRdPySedmNYGoVORuRGQcS2NkZNuuHVv1gQLdgILQtzTJLFYrxFQud3l2m9ZrJ/O4s13CS9KcYv+XF44IRgOQlvo+0ij1vz6Y2mnO4NPEX2ShH0024yUtDVFF/JtNgqoRO+AMNCU5zY9AQecLxRVBXd+PyO5IBnK4JxWwOsQnCaTi0A1MK/M94kqUUFeoQSZlpQGlVkCEb1Zji3W8i4XXKju9KObdwSR7GpJhu2Qqn8lbWonLhxh4vlrSLc7sqSSppGHayFlzFRcJgzggsv4PgWQnXF+GizshvHNx/u/HtmPu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 07:34:51PM +0200, David Hildenbrand wrote:
> On 20.10.25 17:14, Kefeng Wang wrote:
> >
> >
> > On 2025/10/20 21:10, Lorenzo Stoakes wrote:
> > > On Mon, Oct 20, 2025 at 02:18:44PM +0800, Kefeng Wang wrote:
> > > > The prot_numa_skip() naming is not good since it updates the folio
> > > > access time except checking whether to skip prot NUMA, so rename it
> > > > to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
> > >
> > > Hmm not sure 'folio_needs_prot_numa()' is any better in terms of indicating
> > > that you're updating the access time to be honest.
> > >
> > > Also it seems to suggest that you're determining whether a mapping of the
> > > folio should be made a NUMA hint by the folio alone rather than the reality
> > > that the mapping is being considered for NUMA hinting and you're checking
> > > to see if you actually have to do it.
>
> ... because the folio doesn't need prot_none protection for NUMA hitning? :)

folio_xxx() impliles to me that the folio independently has proeprty 'xxx'.

So it's like saying 'here's a folio, does it NEED prot numa?' right?

But that's not what we're doing, we're actually kinda doing the opposite, we're
saying 'ok we want NUMA hinting, but do we actually need it?'

The sematics are hard yes.

>
> > >
> > > prot_numa_hint_needed() seems better to me?
> > >
> > > folio_xxx() stuff all seems to be derived from the folio alone.
> >
> > Naming is hard, David suggested it with folio_ prefix in v2,
> > the most check are derived from folio, but I could update it if
> > we like the new prot_numa_hint_needed().
>
> I prefer what we have here, but I will not fight for it.

I also dislike the 'folio' in the name. We're not only basing it on folio, but
alsoo vma, targe_node.

It's hard to put all that across in the name, but I'm personally not a big fan
of the original for these reasons.

>
> --
> Cheers
>
> David / dhildenb
>
>

Cheers, Lorenzo

