Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 247A3CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 10:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B9C8E0002; Thu, 11 Sep 2025 06:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5531D8E0001; Thu, 11 Sep 2025 06:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41ADE8E0002; Thu, 11 Sep 2025 06:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2950C8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:47:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CAA7658D6C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:47:18 +0000 (UTC)
X-FDA: 83876642556.19.39F49FA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9FEC7C000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:47:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ncw/r0h8";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VvCtj6d2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757587635; a=rsa-sha256;
	cv=pass;
	b=DARxpr4+XkVnJ535IvjMGwM6m73ukmxPPv3g5pK2JhYZOjdcty4c/zVLfYZGWTFe859k+F
	Rc1NQNG+xcmJp9L2n+x9Uqben4GZOskSAfmoB/m+QoKkqlMTiE/ZVuAEvpp9HwEhwWQBP7
	BuDdspiZTbmKcyPlk4VlOkvzpH2AjlA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ncw/r0h8";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VvCtj6d2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757587635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCf5mRmS+0d50UrQUHvhOfBl2FVU6d1A3Djg18e5P6Y=;
	b=vC9iBx6VI/YTrBxOGu5PbKNnzctxHBD1Is93xbD1JacT/gvNdvV+UcgXnvW4xRb/XZmAPY
	aHzWPTZTvf+MF76Bq5V4JN5jut3paZmowicbY8UDKOP5tgL6CBPSWqeomF8h5JBtH84FwR
	1kLS6Jnqu+9HeX762LiTiHM195eF2nk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8hAm5029216;
	Thu, 11 Sep 2025 10:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YCf5mRmS+0d50UrQUHvhOfBl2FVU6d1A3Djg18e5P6Y=; b=
	Ncw/r0h8QT3kn1+Dv1AZOjJNY/647ieE/t+KM46XJ27fce2wnSmLMucxustWyO33
	TTjaaD039KSIiKTXDbMtwmbYZzfSYPG1Lg5bUa8Lw6bf0VrUsur6K4WaElcZ234S
	1EvbCJVvgx/nSDR6DGoV4/VxEE/S058dqtnyBsFDmJ/S87k9s9YJwnYZWz5LpsLW
	twiTlQwxEsilIehXeK6VbZLAHOCnuENeDi/64SYrhcOdngeUE1L21FqwCGya6w/e
	g2vLiaDvq1Iu+kxFq/zjX8fdMAP3Yr9m8TFY7n7uS/88Sb7AeUEfBwmDW1qyojgx
	g8N0saV2SdBDpVRmX3El3Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226sx17f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 10:47:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8t9Ha032858;
	Thu, 11 Sep 2025 10:47:09 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011007.outbound.protection.outlook.com [52.101.57.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdd8ped-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 10:47:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x7DpSCGRfW4NLE/5/NVaRes0hYovNFldZQj8/7g+kHixpg+/lr4TmV8+yLoR/7bmtbTSgH7XNJWC3dA/8eDJQxU4DXqGw4LV2m1kCNOHkS7jGFXld/hmgdoH+E4YC+2Jff/xFigUrNR+VmsJ3OWUjsfwr17vcXCQw7/aXBlm+BaNKfIeWqAAaue+opyzEYyaL29BTIVDZSWiOuzrjpAozwXLAGMCd++MeoEtTuqF0ouEyXw5q7mQqRbHOR5o2tDSJx+/W9AfdPWX7tPJkUIIx+xb6ZaPN3OIE11mAMG/UWBjHLIWh/a6gCZ1x7hhQFZ4RN0BCSLqkz0gddnXWbm95g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCf5mRmS+0d50UrQUHvhOfBl2FVU6d1A3Djg18e5P6Y=;
 b=Zh6RUYUAc1BEMPWPUvQM9R147LcUeeR6XhDmwN2fHI5jZjvStPegY6uYj7P6LWJxQh7Ki2m8/fbdbkzwQt5zDc74Kh3iPGFxyTBkYaW867cgyNhXov0ZgFtati0DEnGQYXyM7Cd8p4v7vbCYbbXwT9M+q8rFu5Lum3FgF9ePm0B5ZNHvAxIDs4GK3Jhv0n176oBhv4ypDB5MY2hUfuKBx/vDprSLhnK4xxkPbbPGyNp6DcFanhSQPixpVUR8zR5AzkJ41o+T4czVAdxfO36jwr9y4pTQkmqeFFPsrRgx2KzAupr+poPjN+UWm95efuis/RsJ/cyi3IH94GxJ55woOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCf5mRmS+0d50UrQUHvhOfBl2FVU6d1A3Djg18e5P6Y=;
 b=VvCtj6d2mklpMVselT8oQ/O4hJQaF1wxtSHxyKCkIqbTVqFqiSonPAqsfIg90J7PorrVPMn4+v6ctuE66pXuPHACzYelbwkWdrGU96mSTriBSjGdwthBK3uFh2VwniBx3PPmL3xS5awQYmJIpvF8J/xgcDCMVBmuUO78DXe9F4o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ1PR10MB5956.namprd10.prod.outlook.com (2603:10b6:a03:489::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 10:47:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 10:47:05 +0000
Date: Thu, 11 Sep 2025 11:47:02 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>,
        Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
        SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <0380dcb6-ad9d-47fb-8217-2e5e66bd5504@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <fc37efe2-53a2-483b-8c59-bccafae81d97@redhat.com>
 <CAGsJ_4yxN7TXO58c3Ls9LByYAG91RM3oi10C91mrgxwd-heKjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yxN7TXO58c3Ls9LByYAG91RM3oi10C91mrgxwd-heKjA@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0100.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ1PR10MB5956:EE_
X-MS-Office365-Filtering-Correlation-Id: c74e059c-e1b4-46b7-26bd-08ddf1208c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnNHZlkxSVlLM2syNDY1RUhVaVE5THc5dTl4RUhwbzBvSnVSNmxnbjFRaGtp?=
 =?utf-8?B?THpJYkQzQlc5ZlBxZjVlVzlSekF5R1RGOTZBL2JMU3dmRHd1NHR2ZXY5T09Y?=
 =?utf-8?B?RXhaMURKQkhFMXBkWFpuOU9vY2tBOEpOelFwTDBNUHh6eW9LK0FNaGhxRGs2?=
 =?utf-8?B?OUhSK2dza0xSc1JPdmhZYU1lK2oyVDNPYk0xR1ZGS2x4dE4wNGh3dVErU2pD?=
 =?utf-8?B?and2TW9rU1QyeHdCY0x2ZkV0TCsvMk9qNTdNeXRweUlrM1ZybTI0cDZiMFpi?=
 =?utf-8?B?bkN5ZmxwbC9UVGx0RUR1WWEvaHBGZnd2UUpucWs5dVZYUkdsNWQ3UStLMGZ3?=
 =?utf-8?B?QWtISnNuOXhlTkJ2V0RxYmdtcjhsVm9leXR4aTRpR01UOWRVR2FvVTJPYlBG?=
 =?utf-8?B?MmdHaXpqaEV3enYvZVIvWUExVWN3cS9VOGcxZmU2VXBvOEgvcHhQR1dDZ1A3?=
 =?utf-8?B?cGRPeFBXNmpuTGdWeDhValFaQitpcGNCR3d3STNIcisvN3JTak9PUHEwUVlR?=
 =?utf-8?B?R1Q5US82NXJGQzQ2YThKWC8vQkxFdkMvd25pa0o1d3c1WGxXR3hNa3o5Qnhm?=
 =?utf-8?B?WXdvNjQyR2Jocjh0VnR4SEpTc1VHaEljMExRdXBqbzdQVGJYSHlqblVXKzI3?=
 =?utf-8?B?N3NyQ1ZTNFBUdko5dmQ4L1BFelJyTS9CbEpGdTlFYlhyaG5qdHBYYUpTZUtp?=
 =?utf-8?B?RTNzQkdLektVc1dyWFZ1VXhORGtqck5ieHhJa1BxaVRjdnNJODQrVVlMT0Zs?=
 =?utf-8?B?V3JQa1plS2dBYUJTNUc0N2pxb3E1QzNpczI5Q2FqLzlNdXViWHFnSVVXUHNQ?=
 =?utf-8?B?em5tay9NcTQxeHNHa0JBcDcxNUVNSmFVY1NKUThjUnlya0QzZnZVc2RQdzVJ?=
 =?utf-8?B?dGcrNlZkL1BUMDRGNCt3V3VvUXB4NWR6U1FmVkV4cjdwRlVzanpmS3dYYWtj?=
 =?utf-8?B?dmUyWExqZGhGWDVxNm9NRXBqVmRpRDJHR3VOTm9SVmpDUUpFWEZONHArOTlz?=
 =?utf-8?B?clZUaDh3aW5XVkxYVUlwWjVKVGQrNFI5UHF2RlI5cmxQZXZROWtmT3kwamFX?=
 =?utf-8?B?NlhpVWVORUtNTmNBc1Q0TENjeUxUT1d2VVEyOHhRVU93U29BVTFqeUl0dThJ?=
 =?utf-8?B?TEJhNXZpajN6WHJ3ajdQSTVaUVg2a1R4YWpoSk5MOWNLR2M0Yjl2VUpLQ29G?=
 =?utf-8?B?Yjk0YnQxRVpVMHRpVW9FTzM2NlJ4eW45R01BTHZKVU9odFcwYUtwUitUQVZp?=
 =?utf-8?B?aEdXOTJTN2xEWnlVSWZjVUV5QUdZVFdjNmtVclBERWt5b1luc2Rid01KYk5z?=
 =?utf-8?B?OG52QXdEeGFjWlZxU2VtaUw3Q1Nma1gxcURkTUpBRkIxZVF3RDNJWUY3bits?=
 =?utf-8?B?ejJIWERyblBHQ01QcGRDalZZQUg4NVFMTmxGWktTQWFma2Z4YWVndFNBaE5j?=
 =?utf-8?B?UnhYRENISEhUWU0zY2VNa0RCV0w3RUc4OW9BTW9xdkVRWE5CSXBlMWlwNVlL?=
 =?utf-8?B?WWZacTFFVlI0Qno4QzVybjA3NmlHSXZUT2d2aVlkMzdNNlB0MWloeEJKZmVQ?=
 =?utf-8?B?MkpuMER0UDM4RE1xMUNuV2RQSVlEZWxqTS80ZUJWWmdndHB5TTZpL0c4czM5?=
 =?utf-8?B?N2E1eEJiRXVoaW5taWJqMWtmYmp6bXVpTVYwRXRmcVFHRHk4NkFkSVVYUFZt?=
 =?utf-8?B?VzlzNkdEUFM2cWo0SlpIblc3M21IMWNjaUE2c3YrdWFHQjNON28xMU9HTjVF?=
 =?utf-8?B?ZHNRMVhzZXdRRnM0cXd1Z1cxY2h4dklLbHpTVEtiM1JiRnE2aGtUNnppVy9s?=
 =?utf-8?B?MmxVZFhSYTNYTFE5cDdBSnprMUo5VE9RZGh4QmJ5ekNITWZvR0N0V01pd09l?=
 =?utf-8?B?cldZN3FOa2FQL21sWTJCWXFqZ0VaYVpScVk2b1RZZUliQktVS0ZpTmxlWi9I?=
 =?utf-8?Q?FtrNqBAjyKA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2VaTWJFTmtTUHpVL3p5eGJGUktOQXBkUm1ia3YwZzk5REZzRlcyN2xjMUpk?=
 =?utf-8?B?d0R0anpVMEEyVkZBT0VVQ05lTUUxcWpyRE5rWXJ6WmJQbSs1MTl4c3RaTW9J?=
 =?utf-8?B?WmJHVjBqdGN4MHpBL2Q5eUhRZDZDQW5YUm9SY0Z3K2VqaWdtMWR3YTZ6UDR6?=
 =?utf-8?B?UlRmcXQrdmxyUElsL0xDNHdDby9tR3J1SFZoL1NKMkNIZDZLaXBtL2tVV1Ru?=
 =?utf-8?B?YTRsU214Q3Z5RURjekRPa3pHRTJ2di9zQjdQbHcxR2RxL1BsSzRHL3hzR1BL?=
 =?utf-8?B?T3FsL3dXSkRwVndSdVhBRGhneEM3czJ6dUt2d3hIWDFPMS9wdVB1aE5qRnJl?=
 =?utf-8?B?NGJpNDBwTFV3cTJxelZUWURUYlozNW5TQTNYRFBpQzZtRTBiUW05Sy9JSjNw?=
 =?utf-8?B?THk4eWhkcDNWWERZcE1CaUhrQ3plL0VMY2gwYmdWaU5kZ3lsMCtTSUUvb3dN?=
 =?utf-8?B?OHlINXVsMXRMeFJHV3BTLzgrTHlDR0ZEbTlUNCs2L2hsaGNMNGc5TGdhR0NF?=
 =?utf-8?B?V3hCRk04bVN0VmVuQ1ZTL3luSEJzUUM2ZWlFRTFsbjZJZFFQZGxNcEdDTjdM?=
 =?utf-8?B?cVRjOTRmcjJzeEZJbFFOODdIeFRUMWVUMTVldlp6YUt2enlRNWRPNEw2bkdH?=
 =?utf-8?B?cDhKYlNkYWFwMTNEVlU5dnllQjF2YUhwb2hVMVUySGIzU04wYmpFWWJXSUdW?=
 =?utf-8?B?ZzJISkhPTzVxSTUwRXhUR2hjMFl5M25TZjMvK1BKbit3K3JLSnFJVXJsNU56?=
 =?utf-8?B?VUhQY2ZtWlpyYkR3dDkvWTBoWUozbzUzcHlMTHVjME9ZQms3a05EV3FYamE5?=
 =?utf-8?B?TmcyOGw4MjJyUmhxcnd6UFRyQTh6Wld5NzJCM1FxTFVHL1ZFUTBpNjJDSmEz?=
 =?utf-8?B?TE1ITHU4WDlnTjJwTHZrajhEd1liMGhXZU5LdGIyaTlpU0dYUjBJcWFuQzJP?=
 =?utf-8?B?b25ENUpFZks5b0F1bHpQQUx3U2V0NGR1Yi9KWEphMTQ3eENJb1ZHcmdVbE1D?=
 =?utf-8?B?R05UOWNyTDNZUnJiWG5MZ0p2MVJ6UDJodSt4TmhmOE5uV21TNVIzZlFia3RJ?=
 =?utf-8?B?ZGFpUnZKbEZEWXQwRERHNGhCUWlhc3h6bldVRmZiYXFld0FUSTd5Y21KU1Zn?=
 =?utf-8?B?STYvWUZ2TTRHTjBmQlQwUGk5Y013MUJqZnQzZlhlUVlPWjNCU3kwK2kzbFFr?=
 =?utf-8?B?R3FLdGZiRFE0ZGlzUDBBS3U1MGQzTHhHVjBZbkQvcnlmOUJ5NGJzSFo3SEJn?=
 =?utf-8?B?OHFDNkhoMG9iRXFnS0RlWWsxSlV0anFvRHpWbUdRUWxYSHZaakZpNlFuc0x4?=
 =?utf-8?B?RkF3b0RxMVZndVFTMjBkS1F0WkpUZXBsL3ZNU0g5Mm9wMWd6WmJadnhPM2hB?=
 =?utf-8?B?dHVJR09SVTNPTE9pOHNtRGxlRUFWZkludkQ4K0ZMelE3VlhyaUJUYzhLK09a?=
 =?utf-8?B?RW5TZ1BZLytqam8yb2hiTHp6OWNEWTljVm50YVE1azF1anB5TUViVG5PcjB5?=
 =?utf-8?B?TFEyZWtGZ3BLQUNWTkpiVnBqT0RnOUZ6YTFycVYrM0ZGa1F1bFVNN3V4OWtq?=
 =?utf-8?B?VjlSTlp6U1ZNMzEwY0h4dlhWRkg1dE5JMThlQlRQMy91emhjcmZEUG8rdzdK?=
 =?utf-8?B?K2k5bnJvOUgxNURENFF5WFZUUWd1cmo4cElWbkhnbW9ad0grK3kvS0pGb2sw?=
 =?utf-8?B?akxaVGZ4Ynd4TWRhVDFtWFVMU214SlArODQ0ZkRqTUJaMmVYN3VseFBXdi9w?=
 =?utf-8?B?V0JML0prVnBJS2JheUU2TTJGUnJSc0RxZDdBU2pIZ1U4VmJZak1TNE03UzNn?=
 =?utf-8?B?QXZNaE96SU1KYitWMlRTUWNnNGZ3a1VtZFJsZXoyNG81clMwZHQzaDUyT3JF?=
 =?utf-8?B?SjAwdGtCNExXVXRQYWNQeDF1YkRNeUJ1UzdkUjhGdzQ4cEd1VmdHVWY1bXY0?=
 =?utf-8?B?UE4xTis5eFo4WlFCdGFSVDlQbmNzb3gzWExKWGppWUJaSUl1cDUrb1IyNCtn?=
 =?utf-8?B?aFowT05yaGdLYnpZVFJBVmFEb0MrMy9uVXJqRzNFUWxIZUpYVEFuU2lIQkpP?=
 =?utf-8?B?N0Y2a1laRjFud2pLbUhPNk90aGg4UUlXa3ArVzRaeS9VT0dvN1VjSUlPYUFD?=
 =?utf-8?B?UjlCcnA4WmtFUUtzMTlQZi9lSjlXRFBqUk1Ib3cza2JwcFVDZng4VVVQZXBV?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uRXX5/rCrzjZcr9HbzdumT5naUAK/4t7NX0Zs1oGJaKzdwn7QfGb5ofcDS//eDdHnSI/H3IT50C1758wNPUyGSCKfqAm7xQVifOSRIqfts5t2Rmqrmzo+3jAssAjj/BsJp8xQCMoVgAPTEmttS1Lo/kHuIWKz8TmgblQB7WCOSrf0CV4lngPCi9zLsn7xZJ0hQO8AgOcIp6NU14c6GwlN7HabRSiCH5EPBg/yZbJGBj+TQ0YgoAfaZV/Z2WFeo7jfJ3zmOyJfN8pmlK5Qh4kXg3OPqgPt+Pvos27yJEyAUX4PPhiYLcgvC0LZK+ZcjnTdrt96GAISBSQXauyoF6VetRDnl2bEolZF/8p3YWFIhNI5gDbR8G12LEGrqQ1CYZ0cdW31z3cSdtzm7oh84jl/VAEt9EnCBWVbLNY0QvxESJCNR4f1WKLdBaMD16frv/rnsuhKaBPzGAsEf9DKvENijWCXMeST5VEU0MDZeONHuqG7Jh+fBmeUUzLW3zbakh0YObg2LgTEtXRB3QaZbSsWZY+rLUO6n2fxEWztHYnR2L7oaxGmorimHjo8mHOlLwKAWEVSZKfvhr6bXbex67oITKU6SS5NLYJHUEfTHDJaSM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c74e059c-e1b4-46b7-26bd-08ddf1208c26
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 10:47:05.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6NfajtP3roXFGu3TxPU3xka+Qtsi9EnWkUKKJoeFWnGY7ZktHO3Qiu30Ih/rFNFLll2PQDPDuH2CsbMHTmX3NkX4ndnCcgCGklJZhHGuuwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110097
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c2a8ae cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=szrOpT0adHhZVkpH0d4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Y_KczffQsS6nIuq7twoOZN3ms0DAvq2I
X-Proofpoint-GUID: Y_KczffQsS6nIuq7twoOZN3ms0DAvq2I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX1LrWwpC4EjC5
 5pgcQgNcKhThIXhofL/Je+kjtXmFC8kd6GcGwgaqFPfxCn+jZtNDMh0BjmOksHmdv+gd125+okh
 cYyAIT+y4+37l0yk6o5787vXQn7SIukmFBxOcTLNp4OBrSKsIH1QiN5NjnxvtqgVwxNODO8qjlY
 eGSm131kmkTYs11pgtjWFHdNlLI0/0hJL9pZGd7aQmuEniDf59QdYuoacQuYMglYXOleRtTDypb
 KRH9FlU3kG76jEnUaZlN9sxpQijnt+ge47rms9I8whVocQTqeM2X62f2xI1Oc31uvrhZVmDYgSo
 Kung/x2yPWucA3bZe6KF37Clze7eGUBqy/ZSf5+Q+xwPWNwzSTL8dLGco14e5bOFC3HiE36jGOO
 OCbZgjyg
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9FEC7C000D
X-Stat-Signature: hjxues6oiatw48e1mmd6j3dqyemieeqr
X-Rspam-User: 
X-HE-Tag: 1757587635-898661
X-HE-Meta: U2FsdGVkX18Dqid194Pt09PejiTCy1GLtInwcGxR3IKp8LQXEXPrzl7y1Gu6zNXKC2exX4QroXuRDv7AaJOfFiXy7mCOdOJycSytSogj1LT2DZT5jYoyG9CpC82scodXsY3cLBFBqAYlJqnHmCwAKr5tKrB+8HPEUEsZS4UECSnmlCLjaZ2S+jbG8Csp4cM4k563VgGQFbhGk+WDpsiqykzhmsGNa1zN7XpBeH2vrERuu8KSH8ifxaLE4lihwjs8XvnnrPJwHHd9qNTc9okUDNO1EjMd+TLpHmjlnUrSd6hVhkKPFs/lOnLvAcx8Odkpn+eDzp0ikcjfHT3WZm/quCx21iYukUApTXjGcOap5BASZ2B/OxpW3HjtsgunIuUC8Zw61mEKOJy1oeeVD0F0fpcDR3wvYowuXm1MRvS69r7p2c0BVXF3ancRyc6Flreob4jpK9tA9OAuO4QhEMRwY5GFImLNz9NyZNNlmMLPM2Grj5vdY0iyEGOy4ArDMJZzqxj//W5KRjH/Jvt3DeIi2bFq+sgLshTFy53JyEjFDPnfVio5LSTxgZJVabNROM45AZ1MDusFxRMdKpa+Xvb2dItOkubACubQVgQey3dja3ulrfSdUYy4HAnI5VJZIkVNh2yMBWY+n0SeM6nOwUVbGQOQMFoew/Nlr908Cb788T1fVHGcRQYuXs4JWkwO2NcolD1gsXtFc5DJTrzHzigmdMrC0JeidFtzLSlCUUM37clAGhtoQFUpIkYukcY+MPBzLPuZ4cuKvmaLloqhAqxRNgq2ysZdvD5oPsAzEwRaaGpdzp/vOlRJxTKo5THfDZOiSfoQ9orvgNLvjiqam0THpTXS0D94Jb0tgmeSL1ewBBui8QLU1jeyz1nA3jRQnUdWtXjTnGhOcx5vRkIo2lm37j3pJNPP5m55AtsidgQu8czZixoO4LmyAt/8hIAU/FJgkhRLJKJ16JPtGGgbSOP
 YP7TlYFC
 rvYIPptjX6XqQy6V4A8KtwCwm49EObwsDRKUwqLTd4ZDnb9GdtBXpp+72bfsDX+383vgac8yHMx2/ug5tOT0bGduMYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 09:18:17PM +1200, Barry Song wrote:
> On Thu, Sep 11, 2025 at 8:14 PM David Hildenbrand <david@redhat.com> wrote:
> >
> > On 11.09.25 09:17, Barry Song wrote:
> > > Hi All,
> > >
> > > I’m aware that Lokesh started a discussion on the concurrency issue
> > > between usefaultfd_move and memory reclamation [1]. However, my
> > > concern is different, so I’m starting a separate discussion.
> > >
> > > In the process tree, many processes may share anon_vma->root, even if
> > > they don’t share the anon_vma itself. This causes serious lock contention
> > > between memory reclamation (which calls folio_referenced and try_to_unmap)
> > > and other processes calling fork(), exit(), mprotect(), etc.
> > >
> > > On Android, this issue becomes more severe since many processes are
> > > descendants of zygote.
> > >
> > > Memory reclamation path:
> > >    folio_lock_anon_vma_read
> > >
> > > mprotect path:
> > >    mprotect
> > >      split_vma
> > >        anon_vma_clone
> > >
> > > fork / copy_process path:
> > >    copy_process
> > >      dup_mmap
> > >        anon_vma_fork
> > >
> > > exit path:
> > >    exit_mmap
> > >      free_pgtables
> > >        unlink_anon_vmas
> > >
> > > To be honest, memory reclamation—especially folio_referenced()—is a
> > > problem. It is called very frequently and can block other important
> > > user threads waiting for the anon_vma root lock, causing UI lag.
> > >
> > > I have a rough idea: since the vast majority of anon folios are actually
> > > exclusive (I observed almost 98% of Android anon folios fall into this
> > > category), they don’t need to iterate the anon_vma tree. They belong to
> > > a single process, and even for rmap, it is per-process.
> > >
> > > I propose introducing a per-anon_vma lock. For exclusive folios whose
> > > anon_vma is not shared, we could use this per-anon_vma lock.
> > > folio_referenced declares that it will begin reading, and Lokesh’s
> > > folio_lock may also help maintain folios as exclusive, so I am
> > > somewhat in favor of his RFC. Any thread writing to such an anon_vma
> > > would take the per-vma write lock, and possibly also the anon_vma
> > > root write lock. If folio_referenced fails to declare the per-vma lock,
> > > it can fall back to the global anon_vma->root read mutex, similar to
> > > mmap_lock.
> >
> > To summarize, are you proposing a similar locking scheme like we have
> > for mm vs. vma here for anon-vma root vs. anon-vma?
>
> Quite similar, but with the optimization limited only to exclusive anon
> folios.
>
> The main issue is in folio_referenced(), which frequently takes the
> anon_vma root read lock. Complaints are likely due to memory
> reclamation holding this read lock—if the process is preempted, it
> becomes runnable but not running, while fork(), mprotect(), and
> exit() may be forced to wait. I haven’t seen complaints about
> writer–writer contention, so I don’t plan to optimize write-side
> conflicts at this stage. In short: the problem is frequent rwsem read
> locks that get preempted, blocking fork(), mprotect(), and exit().

Right.

>
> If a folio is exclusive and we already hold folio_lock, it should
> remain exclusive to a single process and a single vma. In that case,
> such folios may not need an rmap tree at all for folio_referenced().

We still need exclusion at root level to prevent concurrent removal of
interval tree links at VMA level.

>
> I’m mainly concerned about cases where a read lock is held but never a
> write lock. As long as a folio is exclusive, stays exclusive during rmap,
> and its rmap node remains present, there’s no need to modify the rmap
> tree.

A folio being exclusively mapped doesn't mean all folios in the VMa are
exclusively mapped.

And it's irrelevant really because even if they were, we don't disconnect a
fully CoW'd VMA from ancestors (but this is something maybe I can look at
changing).

>
> When changes are made, both the target being modified and the
> anon_vma->root should be locked. We are not altering writer
> behavior by requiring the anon_vma->root lock.

So if we had per-anon_vma locks for this, writers would need to go to the
root, take root lock (which has no bearing on your readers, only exclusive
to other writers), traverse all anon_vma's in tree and (assuming using
their individual rwsem's) then grab the write lock for each.

Hard to see how this wouldn't have an impact on performance.

If we tried something similar to VMA locks, with seqnums etc. we would need
to have a solid foundation upon which to do this, that is a place to store
e.g. the equivalent of the vma_writer_wait and mm_lock_seq fields in
mm_struct.

We do keep anon_vma's around if they have children, so this would be a
place, but now we're adding _even more_ fields used in one place only to
_all_ anon_vma's.

I also suspect that having potentially a great many anon_vma's that you
have to traverse _every single time_ you need to merge/split/etc. etc. is
going to be costly, and possibly in some unexpected ways because once you
start having lots of forking all these operations will take way longer.

Even with seqnum's etc. (with memory fences coming from atomic operations)

Any such vma lock-like implementation would be hugely complicated and
delicate, and be in fact more complicated and delicate than what exists.

We've had numerous work done relating to lock scalability with larger fork
graphs in the past due to initial anon_vma implementations having issues
with this.

>
> In short, I’m seeking a simple way to avoid taking anon_vma->root
> during memory reclamation for folios mapped exclusively by a single
> process.

I'm afraid there is no simple solution here.

Again overall, every time I look into anon_vma stuff, I end up concluding
it requires a more significant, fundamental rework, which is why I have
started on doing this in the bg.

I do suggest that we fold this concept into that work, as otherwise we're
going to step on each other's toes and I just think trying to bolt
something like this on to the existing implementation is not going to work
well.

I may try to solidify my ideas a bit and do a presentation on anon_vma at
LPC, but it's a question of time re: that.

>
> Thanks
> Barry
>

Cheers, Lorenzo

