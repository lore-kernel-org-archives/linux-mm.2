Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F44CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F9F8E005E; Mon, 13 Oct 2025 11:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820398E0009; Mon, 13 Oct 2025 11:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699B48E005E; Mon, 13 Oct 2025 11:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 517B28E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:41:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0684414050B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:41:47 +0000 (UTC)
X-FDA: 83993506254.21.1367954
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9CEFB4000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:41:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e4+k8vgv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KUWqeKya;
	spf=pass (imf04.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760370103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKc53hmVPl7sepIxMey/sXJeHxYyQ8TvGgCvydy8+zM=;
	b=B7tIdv2RxOIFWFf2wWCQQ7wsbc6qyG8IWcSDjNv71toj0JVXykxQmQkROgnWfnCAjCD8zr
	3gthOE/nz72xuE73MOF1CGuBzOoHeMZacc0rd7XIFwQcDkeg2f6kcn9qUXo5Xh/744oNVW
	3otJ74nfRf446ym/mk3Aj3C58pi30Xk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e4+k8vgv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KUWqeKya;
	spf=pass (imf04.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760370103; a=rsa-sha256;
	cv=pass;
	b=jQBR7YCzdFDMrN8d8aGEscxGc83CTSYU4UdtGoCmh68nweeP7jV96Xofc26ZQKc7KfAYuR
	Bos0x3RwUGxUtdML0HwzzOlODCa7iBz2cYdK1BF+3STs3xglheXozQ6DIwioqV8vbSDBbp
	AxQO7PwsETzeODMqNtbBFaSbnlp19cA=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DEkuf5023009;
	Mon, 13 Oct 2025 15:41:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nKc53hmVPl7sepIxMey/sXJeHxYyQ8TvGgCvydy8+zM=; b=
	e4+k8vgvMk3Woybs2QiJrfrjKs8p+tTFefN622x5hV2vLfuZmp04Lc+UQyqvS1N2
	RQjp5LjKo+VHVw3h03v3JH9QiEtDvJgjbKz+E8xK1YYJN8v+Pf8ValmWJTBDFVSO
	r5WyCok30ki2Gv07pK618XXxsEtIxbj4D71LlmiRUDjPmEH6i4kQHNf/2e9gPOGA
	p17DJWr/bKSb0KY7e6n8ecWTzhxGgZtjBPa/Rn3yYc1ahogvRMM7NvGBdj7+zgdp
	d5yMQl7pcD1sNq3efrF07GtLZHzZyLT4MNdBWAjvlSibREj9iKb7KXzxLgMKaqij
	v09RDmcmfR1g+TAkyDVj0w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1q9n3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 15:41:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59DEeQ6T009696;
	Mon, 13 Oct 2025 15:41:27 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010000.outbound.protection.outlook.com [52.101.85.0])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpdqehm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 15:41:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wxoad4Sfa9vWE4lA9eYsGDGRoDCk8s0xSvJ5+xiDLNsrQ9NOhnzdrf23QE6+l24nO76+pdg1jbVbBOnwClYjFi2hYr3lFT0SPVjtO89OFkLcg7Dz4KvauBVIo6bpS1lyq1CHeM/SBIdKaLwD46VSqY8l1sRwFpLX+tfggzcEQ3WAqPSzT4lgJ3EriLB1kDVoxfPkdg8VTbHXNpYnzhW2z3r2KWJVJ5bWEoMm26xBUXC/w9ALbVPxcLjcHGLzW7JibPptfz01QDdC+nDUUiI8Tt74kB294aasV3n2bCt8EuRD/FvArc++OJXBkQ2iZE+p4V2I12Za0k+ctx0QPJUxxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKc53hmVPl7sepIxMey/sXJeHxYyQ8TvGgCvydy8+zM=;
 b=OMrLv9RoS+bSMazJ/lI4h1QzI3Ah53iuAl8yShWw5IS13ui6JdkeU+MfXAYF5XKlKetjZmXJHxJrSSLOjq4JKldJw38QVsQe7gvDv30K7veP10pXGm6kFKmlxEuOdouoJPJT2mwmTUXiWDFhyTbi6EoLP6tRh8qlqg+w6l70SuPTpwsnt58vBuoRbq7c5sljXAoSAPs43I51ymYsbGksJstBjrgA8eRS+XEbp3A7KNyhFshE+6Xu9OW+NYWYTSQhbZ6zIqtDB7a/dwjYJkBJ+U9R6QC9STX3yQrznwN2qChbxg81Zldnjc/YwQz64oafhNbW4ajPnbJYFK+PcRvcsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKc53hmVPl7sepIxMey/sXJeHxYyQ8TvGgCvydy8+zM=;
 b=KUWqeKyawJ9YZkZWuSW1hOa7rLRzm2IHfJ7JD5SCRfZKoBsDGUcxh2Y8ML5duhT9zYadBHztKuMQiMLP4Lce6oJah4s3qO4hUG0uLnzUwB9Ju27YLJr7T7lyImO3tOoRyFWKzPJwFdnKyP+3v1rMhe+gN8mEpZjibGTavCoN6rE=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by CH4PR10MB8003.namprd10.prod.outlook.com (2603:10b6:610:240::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 15:41:24 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 15:41:24 +0000
Message-ID: <915a109b-2eba-4789-9c0c-67b9b6160002@oracle.com>
Date: Mon, 13 Oct 2025 11:41:21 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: huge_memory: use prot_numa_skip() for pmd folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-4-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20251013121536.2373249-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P221CA0033.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::25) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|CH4PR10MB8003:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0be838-0f08-4a94-3f84-08de0a6ef750
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjliZ2d0U1UrSDFJS1AweWs5d0E3VE41M3d6amJFYlM2Y2FremhQLy9pQU8r?=
 =?utf-8?B?WjlPTEo3aFFGQ1p2Q21wUllyUU1aOGFpQ2w2UkFGWFBxUlViblZLNTRCUXRz?=
 =?utf-8?B?bGhYclY3eDh6eFZXMGtWWlZIUlV6eUM3VmxjVENsaTlrWGwvU1B5NnFFNk0z?=
 =?utf-8?B?S0RzWGgwdDgvTW9teEgzZlFpVTV4YkZHK1NFbW0zRE1NSStRTnNodnRPTVZ4?=
 =?utf-8?B?Ui9ZcjZyTk16Q2ZNVDFRaFVHcFBOdHdsQzFjbW1qbEZGQ3FVYzBIVXpUM1RX?=
 =?utf-8?B?REpZdkJ1ZW54b0lZS0QwUTZFeVhHdi8yd1JZNjRFcW41ODVLOWJlTHZLWWdt?=
 =?utf-8?B?eWRIbWRqeFZTSFhIeXNrYzMvb2s5WE1wWGMzQXkwRHJuNUs4dXFiOEl1NkVX?=
 =?utf-8?B?UnVmSFpQcjJRZitMR0s1VkkwOVBFWjAyMncwSzRvZFZJdjE2SVpnSkhlU1g4?=
 =?utf-8?B?eXVMWVZIeXYzUzEzT1lERVJLVkpCa2J3dnhBNGthaldKL1lpTjgzMmpKT0NS?=
 =?utf-8?B?T2NIS3lKd05tOWRnbHl5dUw5bE5HT0RXUCs3ZGpsYTJ5NkxOOVVBdDRORG5U?=
 =?utf-8?B?S1NVNnBpQ0Z1NVFmbGg2bzJ4S0pmQjgwZ3NIREJnTXBnM29LNXBBUW80MDJj?=
 =?utf-8?B?R0N1UVNqUWZqb3ZaZmorRmtvMjJaSlR0VXdJQUFBd09OZUtweUpIbjZiYzdG?=
 =?utf-8?B?RmZuWE5MMEord3RLaSs2VG5MT2s0QkIvWFNxNDA3QVZ4WDJNcjZhWFZDNHZH?=
 =?utf-8?B?OGRwaGpoTFJYQUZOcWozL3A5ZGFwcHV1aWZGdGw0UXFGNXhoVGZWR2Z6OUNw?=
 =?utf-8?B?N0FHcFM4SzQ5NjROOHM5Z1pad3dkcXJmaENMUVpyanA5YUhYVW02R3lROG84?=
 =?utf-8?B?V0ZGcWZVMUROUkNwVUtpQzVwekVyREtVWCtTMjJqRXVUcmVuOU01dTg2MjlF?=
 =?utf-8?B?ZWFVNkFCcVJzYlloVGpDdWpUQVNTQ2lPbXh4UUE5NkpIeS9NYndRQjY2SzBt?=
 =?utf-8?B?em9XQWtiWmdRQy81RTJ5TjZ4Z21OR1NmTGJqcWFtS1gwSFZJeFA1ZktFQW1M?=
 =?utf-8?B?SWN6SUhmZjhvd1VTay8xZVZSdWNlbVNPM2JtckZKQmhpNm96N3lVYXF2UWdP?=
 =?utf-8?B?Y0RWVUJaL21MaXdDNUpaZk5JSlFXc0FFajNraXZMbU1BV092YnYyR0dKaSt0?=
 =?utf-8?B?MU5BTFRnT1lwRTM3MkRxTmhhOWp6OFVtVlNjUnpUelpBL3NZVmlOdVZuTnp6?=
 =?utf-8?B?d1hpNC9JQmw0WTJ0TGt3djFiMXJjY0F2MlFMd0NpMnRIY2p2NFVyZStFemZR?=
 =?utf-8?B?MjZiM0svd3c3QUtRalVockZyTE9EM21NV2lEc0xiU1QvbzRjWDRCbHhzbWI1?=
 =?utf-8?B?TXNicjZVbmtuajJzVm9xb1NlaXpNM09qZTMxeGYrWlBiQmZ6bzJKaTBSakI0?=
 =?utf-8?B?ZkZnZG5DbVliUXRaOEpHTnhUQ0pxMElYY0ZGVEN6QlNIcHRuSVlzNVlub0Zj?=
 =?utf-8?B?ZFphOUVDN05yVzI0WEM3SUlGQjRuYWlseVF6NmxWazlRZkUxYXVRYWttZUlw?=
 =?utf-8?B?OTU3QnVJVkxFZXpJRjZweXhodXh0QkZMWitsN05vVUZsclFsaW8rVFI3cGcx?=
 =?utf-8?B?TlZwNWR3YXNTWTFWSE9pRlprNDIza1N0M2pYeFFyMmNmZW1oVGg3ejNGU3dR?=
 =?utf-8?B?R3crdTgyMjVyTlBFWUZPMC8zbWEweEFtMWdjYXpTMHV2cTNhMmYrc2t3dzFm?=
 =?utf-8?B?U1pJSEd5MlZGKzdzK2dreU9wcnIwOHRNV1ByQzdHN25DcFpzQmxTWVFBL2Y5?=
 =?utf-8?B?U041aFJRdVpnQTQ4cTlINXBFZk1rby9GZVZuUDFMaDhIS2xPRUJrR01BTzhK?=
 =?utf-8?B?enJ0Mlc3eUcrRGhvOERoR2s2WkpuU3Z3ZU9kdGdVVFZYVG8xRmF1aVR3M2kz?=
 =?utf-8?Q?KRxeLB5Dp+6UNr4y6jJqwtuMYFRLYhnp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rkw1UlNncmE2eG5kVTFnMW5wQ2w1TytRRWlVajlLcmZMRkFxYUtSaUVtVWhm?=
 =?utf-8?B?UGhTQmJ6M1RQcHJ2WllySG1JWEpqTThaVUpCb0JqWDhtdnpBTG9hckkxblRq?=
 =?utf-8?B?czh5bHJYVTQ2U2VBZmRVSlBGWE1nWFdxdzB6WXl0T0diMkJDWFNleWFxaUlY?=
 =?utf-8?B?NDErZWhhdFNtM25RYVpnR2pld3VPQXBmZXNydUszRlFCaWs1OVJBMWFPMDFD?=
 =?utf-8?B?Vlhwb3E1eFYxcUJ1RStoNHRLZlppVXE2a1Njcm04ZjZLVkJqRmlmN1hlaUlD?=
 =?utf-8?B?T1ZOamFZMGUzcSs2eUl4ZFB1c2pqeE1Vc1B0dklGdGg2eGFkMFNTZzZIUjZq?=
 =?utf-8?B?SmowcWptZVpVOGNnaDJ0ek51ODY3WmgybWNaemZvY3ZJdWZWRlZqbnZZays3?=
 =?utf-8?B?Wm1ydXVRWmdnSUZjRTNhcEdzWjNsVDBQdXp1ajI5cTR0ZU9iTFlXT2R3VDVC?=
 =?utf-8?B?MHIwcnBPRnQyNmhCdXhRUitZVlB3dUtmMit3MDllZG9GeVFjcXpIeTZnTWZu?=
 =?utf-8?B?VDhBVWRzcUZ3KzJoTlBSdE9Dc1JIZlp0WFc0cUpzbTJDcmFWZEpacjJSR2Rs?=
 =?utf-8?B?ZlhITENuM2xSeHhPN0E4NUFLamF4ZmRJcWhSdFE5aHhYMTNEYVI3bStQc2Zr?=
 =?utf-8?B?eUIrQXY2TkV5czRqeDdtY0ZhSkNoTG1ZYzZZRFh2OUE3NFVmamp2OXg2Rjk5?=
 =?utf-8?B?aFVEV0t1cC93Q1dlTS9LKzFUalhSckI5WHNnOEQwdjdtZjNTYlZCbkdxUnVY?=
 =?utf-8?B?cytwbEdVb1RrR29LMlpmYU1zNEw1ZkQrWUw0M0p0SkVSM29HZUZ6T2VxWlFF?=
 =?utf-8?B?WkVENkhVR0RGV0x2aitRMm9IeHNrbkVTbndmdXVhQzRZWWxaM3dyM2pkcEZO?=
 =?utf-8?B?bTFRZ2ZLaFFJK3VQNWx4M3J3bHJiL1JMdTZwVEhGQVdJREtrSmJuSkVoUUpT?=
 =?utf-8?B?T29ZN0RFRE5hNkNNOTQzVDZGNjVRZ05pWGtMeTMwQ0xLazJYT0lMUGNJTmdP?=
 =?utf-8?B?OGZtM25nL0l5Tmw2RDJaN0FRbGd4eURLSXNrQnhrMlFSd05uQUVhVEpUWDZq?=
 =?utf-8?B?UFUxUHI4dVVFd2J1azl1bU84NElwU3FBM1FFVXdSeVRhb1oxRFV1am5JdklR?=
 =?utf-8?B?VDJHNThiblJZWTl5WU4zMWJ4bGxhMkxxVTNSc2RtaEZFM1dLZkM4Wkd2QjAv?=
 =?utf-8?B?OU16cURCUzVHenBGRnJEWmRDelcxL0xqRXdEVExadFptYUVsbkY4SnZtYnBj?=
 =?utf-8?B?cmt5TWt2b1I5M3BxZ0VOR1Z3K2FPRzFET1Y0c01tL254TVlBTEdIbmhOL0N0?=
 =?utf-8?B?RGZqb3NMT3Fqem9uMTBnejRCdVRMNlA0bC9pdk5QV0JOWldhaGhBOHN3SGZV?=
 =?utf-8?B?Ym5EK2ZPaDdyTlhRdlFqUHhZaEh2K1hRaG40RGMwbGlRdE96Q2sxR3EvQTA5?=
 =?utf-8?B?a0lHa25hMU8zTEVKNTJwdTd5OUFtZW4vTEZKd1dTWEgzZThMRjk5TUxqRTFZ?=
 =?utf-8?B?Y3JHQ3YvRnhuTnp4Y2sydkc3UGltbkFManYzTXFxT0tuL0tGWGdEUmtYRnpV?=
 =?utf-8?B?RzhRUnBvQ1lmb25aOXpXZ1dTUjlCWXRJbkZYNVpTaFYrcVdYazZhYjNFT05K?=
 =?utf-8?B?M3o2azRwZmZJVHNoMnpNTk5uUHZsR2EyQTYzQUI2YjFoRXg3MmtJTnZwZXZj?=
 =?utf-8?B?UnNUR2NkVUZNMXcwRFdvNi9WelczVHcxSE56VVNZQ2gwc3BrVzhiV1lLaTJF?=
 =?utf-8?B?eExTVU95ei9aZzREandoRk1vSC9vMWJHWDhJSzhSMkFkRVZiWGJNMG9QRFRT?=
 =?utf-8?B?RHZuS3JtMFJxMWhXQXpxSnpVQko0bkllczlRaEl1Y1lLcHF2M3pQWUVwS1ZO?=
 =?utf-8?B?Zyt1S1owcXFoTkFOd0kzUEdxaWVHVnBlSXN0RmdRU25OVTNscWZyMU5QRGZ6?=
 =?utf-8?B?STNHeWtKK2ZhcGpFdm9vWkNRQll4US9kM1lKeUVuSXR2WlJMNkpWOTNzcFU5?=
 =?utf-8?B?YndyU283dUJRdFlBblBxcms1aVVpbHAzOUNtOXBZS1U2MFkxdEFOcmdrV0ds?=
 =?utf-8?B?QUFhSkp1Z09FeXF2WUtMV08rd2xXOVh4Uys1V2dBdlIvbXRzQVE4d21TSzdn?=
 =?utf-8?B?WlQva1E3MUhVOUt1MU5SNUJFaWx5ai82TjYwQU9XQjVUamhKRkxmUjhpMjU1?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jmo6UPmYvp0RAziWfhPt2Sj1gwUOAkD8c/XV+ZYaIXj4MdPjECRaGryVXkn2v+kPnpZ59IKr/7sKziMFaiVCE5nmxWt7HoK4uTggwUW1USqkaaJJ9eaG+1WqfE1uWTUYhENW80qlvM3wiSC+it3NFFSkFHY30rzH9WHGjelpWkgAxRh8zgewr2eeaPph6xRr0MN4PXfm9wq2b81WYL4X0o8O1pVUiw3W7Bg1zqH3BOR4YqBUsQzi3+7DM5yvEIn7xmGbdL4jKEVm8SqCryJaBdjD4noqFBCsL7+yvQKIBNnw2N4d8SLuPX3utCmF0+vwMk6Ajew6GPy6vsTI3X2docE+39PrxfxLSiUGIR7icwCI4OS74oKUj2WB4SUY1iW3fmuQf4eHrOmYZwo4OWHQIqTLvda1MQA8S++sO+A5C30Vswh8jw+Jxo+ZeJewjY1F0olMXfOD4gywuVbPaRv+iv+CrVgloIXNErkw6nk1vto1b7rRCpczPoGYXPhtu4lw7BdbNm4ax33kfEV466dANIjsYCCQ/ZSdApls5WhxlMx5LmCBvFWBW9CEpdfjFSenSFVly5XA+O+DJ3sX3zpD52s/mVNMBlvC3nLQSAxnLLk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0be838-0f08-4a94-3f84-08de0a6ef750
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 15:41:24.6945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksHTVnnBthJ/tOGgVAGgyk7jJ6dG2CVecWSo9pFQYobMKWwfNeGWw2mWAej3W3IuFLhc0cM+AABXSFZxHhhwhqnaVryokKYjh6iKm8hcW0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8003
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510130070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfXwevfdkRhDVXE
 3EkUCcgbyMdlFCiGulBoKOMYuiR8BiKUamvsWYlfIgz29iDnTEtZDg9D52JHGi/Dtzf54g5BF7x
 L7li7zW2P1Oo/dOneNyIosappZ6ijAx/bkc9ANwyrjvr4he8Ye4Sut0gOfFSm9RQfQhhVOqWnos
 qotUtJJd6vQDT8V8Ij+h4ChEMuhjuFmh8QN/oi5KQHQJq5i9jcip1HVSn2YEDWkq03MIMG3lvSM
 YwzIOGmt7L/9nqHzcxOHEJ1NtupzE9Aj1vfNN5G3zDPT1WiLwvWAXB0J01aiSg1pIMIbA4vzBOV
 63jbKhbf8JsY1Jtk67TfVq1ey+hdD+Pd08+6guTNqwS90rVrzYJy29zMWdns1ReMgYTkUmbAXyW
 lXTe+dhaE9VjsiWm2VmWwc/zxlcIdBY6wUKhmkOpJOww0Ol1mms=
X-Proofpoint-GUID: kr1K8-xwgn9TeJ6dUi5h09cLUhDh34L3
X-Proofpoint-ORIG-GUID: kr1K8-xwgn9TeJ6dUi5h09cLUhDh34L3
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68ed1da8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=aZt07LFgc2qZqf-IiTwA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12092
X-Rspamd-Queue-Id: 9CEFB4000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: iyannzwfatmrhks41s34tbe8ydszcmzx
X-HE-Tag: 1760370103-485327
X-HE-Meta: U2FsdGVkX19SF4H4rFxFHTin7QK5JOSHNLsWYyHYOnvsswmX4oCM2pg852qLRaDljNYceJikZW5mxNX07xKSj9nXQkuYF+Xt1D/lx8hK8s9nrKORryfc0SKdooyKBYwdH15dLyKdkxh0lG/d7rDuHZ/0DQ0Jh0+w468SIYMIkz9TGhDU2U1olKM65cFJSvw4eSkxMENU/M48IVVLhO7UEczorckNznmRwF1Ortu7m0g+xWwAk4YaorC46RosGqAnqj4SfhU1Mx0q9afjkIAFQx4j/YhRR8CFyB92WjyPwzcgkadM5w/qOTPurvLemcTZwODo5nhlOzfjIL0+K3WbPZbGiI3hDvhmWM5nArKBAG2NFXbtgIqaMAqx3JMBFR+IE8LDooabERSMMJ7ThPmgQaiOOpRrP7zCKpi8L73RewMyYFj104OBDPPQA1GheAzTzwidNk0wStmxD7zUPrYX7BYdSgCwX3KSkjK4Hd5xfASawD/jif+0RGudClRJZpbuGLl3avSfs3QkEQAzFN5R43pf3HhfB+wuPsHw3RRx9HEOZBZdXZ+oxV5fqcze0g/Q/eSqfB4NJBK8+z1DnNQpJ0NlNDe5rvYFcUCRtYzraPpDt39COBo64n9wpkxKXB5Mb3Eg7aJMZfrmRdcDCZWggei6bUGWEyNAy6u6xy/o7Id1kyC4+CipVNaobqEMfxcr4MV/faT/Y8HxAWS3XZxLm31JkE/kGHXDaUICs5XNh+3fz8DfUm7Pf/+QTiYOUkCbNcKtS9xfVZU2iLWvHttSiuZhYuubO7DnDumVSTilNsyHItjRGlWqvF8I53dXC1ork+dH2huvzPh3GYN8pEA4bWmtHdjZlKK92MwgqacG9WRIbIoIYt7OHAkI89djfTlsjzMUFq00HVLsHebXc18zoUknaPll57Lx6R3ZrvwQTj5jZ69WEj5iiMzoQXG0FoZ4Vm0Y/U+cv8Del3XJ0XE
 p/nu/J8B
 sOR8ZUuCznagMTBvTrC3tG2EYLz2mt95sgJHK/sscvOE4bmx2jaKRylA2icPX229qbeM2dBsT1sN00e8N7LSHwwI8eC/W1aeumnl7Ta/p5shZXyQtoe5yFpb4WdsM82FnQON0p7JNefqlmDc6hpXF/8AbiY0hoJgVbEoLoNELmH8WhQAUcGnfaWJDiwBpIG+3H/8W8yVyfBzXHBB8wpfk1B0dFRsWrTeTZPrslpzRupAkMTlZ1efc38hVSojLaA/0X2SLZrZcrKjzPTNZyZA6E3etbseIEH/+SKHxgMITf9jOweT27aqABiGe2LraSKeGUYpxrYbe0VFueCcZAONmy5VGzepg4k4IUkIqN7IJrUyHFOuP4CFxS2V59QwvBAA5XGqIzJHb+C2SyhlOXvyiZ15o21yvXztalNW6Hp25QmectqqmQSH/LWAI8v3BWO40sjif58zaeSt8vs1XUxxsH31QwNqoUq8KZ0TKt7eUx8VuLlUiySBrSAbC8Omaup1SUUnUmDM47/mA1kH8MPUhR3gxciQkmNudyUzHe/Ha5YsXHehlm6gG5lCl1A40CVEsrbC61YXzW8fT2yXL6crc57yDRWKSlRCATqslH4LmS8Ad1x/EOncnbWPiF9Vkg7vKWkZpsUXs7hPEbtr7K+PmL8Sk0sRz+1ul5ZE7P8N99EIGq6kb8Na+iDaV+kx+D3RAHoeyL3m//rUObQ7yC71ZalxrxCm8PppQL2l6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 8:15 AM, Kefeng Wang wrote:
> The prot_numa_skip() checks should be suitable for pmd folio too,
> which helps to avoid unnecessary pmd change and folio migration
> attempts.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/huge_memory.c | 21 +++++++--------------
>   mm/internal.h    |  2 ++
>   mm/mprotect.c    |  2 +-
>   3 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b81680b4225..feca5a19104a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2395,8 +2395,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   #endif
>   
>   	if (prot_numa) {
> -		struct folio *folio;
> -		bool toptier;
> +		int target_node = NUMA_NO_NODE;
>   		/*
>   		 * Avoid trapping faults against the zero page. The read-only
>   		 * data is likely to be read-cached on the local CPU and
> @@ -2408,19 +2407,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		if (pmd_protnone(*pmd))
>   			goto unlock;
>   
> -		folio = pmd_folio(*pmd);
> -		toptier = node_is_toptier(folio_nid(folio));
> -		/*
> -		 * Skip scanning top tier node if normal numa
> -		 * balancing is disabled
> -		 */
> -		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> -		    toptier)
> -			goto unlock;
> +		/* Get target node for single threaded private VMAs */
> +		if (!(vma->vm_flags & VM_SHARED) &&
> +		    atomic_read(&vma->vm_mm->mm_users) == 1)
> +			target_node = numa_node_id();
>   
> -		if (folio_use_access_time(folio))
> -			folio_xchg_access_time(folio,
> -					       jiffies_to_msecs(jiffies));
> +		if (prot_numa_skip(vma, target_node, pmd_folio(*pmd)))
> +			goto unlock;
>   	}
>   	/*
>   	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..65148cb98b9c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1378,6 +1378,8 @@ void vunmap_range_noflush(unsigned long start, unsigned long end);
>   
>   void __vunmap_range_noflush(unsigned long start, unsigned long end);
>   
> +bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> +		struct folio *folio);
>   int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>   		      unsigned long addr, int *flags, bool writable,
>   		      int *last_cpupid);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 0f31c09c1726..026e7c7fa111 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,7 +118,7 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>   }
>   
> -static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> +bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>   		struct folio *folio)
>   {
>   	bool ret = true;


