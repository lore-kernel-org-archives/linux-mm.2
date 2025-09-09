Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 043A7CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378B18E0006; Mon,  8 Sep 2025 20:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3501C8E0001; Mon,  8 Sep 2025 20:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217A18E0006; Mon,  8 Sep 2025 20:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE638E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:15:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD44C11965E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:15:57 +0000 (UTC)
X-FDA: 83867793954.24.C4FF9D7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2FFBA180004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:15:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oNGCVi5l;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JPgc7xGa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757376954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7uevRBaClJDF0cplAdCNLbBKeoCPZwjKKEwXPd0iAk=;
	b=2DUtBlmIs7zNXaDalbOPJ9d7Ts6KOcilz3LMd3HcWU5D+OsImpkYlTYH07GivE9MMcDArw
	4SQDy9w81YvHR0L718mIMyqMPAZFmk4AdgNwQQDHzIrTYPHiMaBYMlQxGYNE13koR917NP
	TzB5Nfdw+DuY05VO7Mz5bUT4lr8SWCU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757376954; a=rsa-sha256;
	cv=pass;
	b=Jcc6uYAeEhT6+wI7XSQdPP536cXgDJ6o/kqaMavQS94w5TveEp3gbg1eSFiPVaHfHrIfku
	5PMB9xzD1shbskNMYP9VDgP4hmQ+ue7wExTNNebx0Pak9JykhuB9wJ4atfz2OGzrsFx6BO
	gchtZzge/5iVpoeWRLAPgAUXBU/9L6A=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oNGCVi5l;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JPgc7xGa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LBg6t027343;
	Tue, 9 Sep 2025 00:15:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Y7uevRBaClJDF0cplAdCNLbBKeoCPZwjKKEwXPd0iAk=; b=
	oNGCVi5lW9QcHLnev7igroNqNxjFKLQAT6e18RI9c2WaT29SSAM/fKOVwIF2ZpOG
	DeiqcX0HySqWqrxTxyswKQ8RtZNUdoPIUMeoRLkzoXF6qxDIm2zc4Cu1mEXsvrF1
	P0ikh7gYt4F9wuBUrbLFYezIIFcZNiaRMKuHrHdZaM8GkG6cPdlx/smIU0qhQtMx
	+834+PBC1LbhNh/KcyRcK9FRDXIvoohuxtENVZGcgnCoUBo9wWOtEniyQcQXBM9X
	1OCDjxiazmipHO2PyPXhYx2zG0UCdwxpAhLJbJrfEiYOvFjjMaMWhUnSE7gyUcvk
	srtvNMVbhVAX5gmikiXpUQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jgrqcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:15:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588NkIaM013598;
	Tue, 9 Sep 2025 00:15:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd93rqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:15:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RWpT9iUOSnM3MNKSM9qx1HtExMtGX5Tw2wZkBtYFPuOmayM0yEWZyS5XVyVvHE82kgnQGHabA/ZlNBOUiP6HzIDZuZxppKgh6Au6RdbkjI3sd13VD0HGKkXuZTVYe4zhm8hNOO6orEPN4xerdtC5BeeYTLj3gg+mSB4fS/fmXfc3R0aWJd9wFhSsqyiXIm8qDHO+53haG++Kkd7FfEEfk1TxUSohJfVNXvOMzV/zJUMx1McR+UwY4pqjXlH/d3TPvvKwSp7SC/ZkRf2Y1DylvlWnb7vLRXEFX5o69yaCdPSFaJh6bUxes/SC7ZFAIJPQG3+WB2EFmRnCg3T0vJh2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7uevRBaClJDF0cplAdCNLbBKeoCPZwjKKEwXPd0iAk=;
 b=o8Rbx01Z8uqQqcd15c5P/MByAWR50YnKIGqcEib6N6t/cWUmZ11+o2TA6+8Ii6Y/fCvq3ibvz5tcoF84XNQHYiUEnCFcZu2XPMuvWblhsasIkC0qjWf0vq0hXOpwFjhkAwi8CIvJ+q/O6E9lKOdSWY3f2gSL8+P4j2JuGUBYqJRtDdlH8egJScMPPWc37WMzhJWuhtTx9UiVVShg441bB0YOCWpEt6KXgi1JQk5K85Xgf8TcwQ/W7qcO2JnF9EV086Bzu8QOdbb9cXibaumKvzmiyAcnmw+AWRLtvMyaIAbbE/DrZ/WGP2ANLR+qLouXOFi/1b8eN0iehhGitMbQxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7uevRBaClJDF0cplAdCNLbBKeoCPZwjKKEwXPd0iAk=;
 b=JPgc7xGab0bNTBQRvxkig8LAlGjbN5p98EeI3BuEAwkvsq5NnI/7bgiOpikPq+is8LrsGX//CkbUFrmUUa+8megejy8o0ydW/gKSsWjhYXIMC/WR3niMwhxorFsCNB/nyl3A0WYBY5g2j+aaCASwt9mc4A8GkD4Hkl7T/9dX8e8=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 BN0PR10MB4840.namprd10.prod.outlook.com (2603:10b6:408:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 00:15:40 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 00:15:40 +0000
Message-ID: <2501aa93-4e4c-4bb5-b3f8-a6259d4e24a1@oracle.com>
Date: Mon, 8 Sep 2025 17:15:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] mm: cma: add __cma_release()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Muchun Song <muchun.song@linux.dev>
Cc: sidhartha.kumar@oracle.com, Zi Yan <ziy@nvidia.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-9-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250902124820.3081488-9-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::28) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|BN0PR10MB4840:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c554e9b-336b-4759-ed08-08ddef360208
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEs4all0NUlyK3ZsQTJ2eTd2SHNHM0t6d25FK2NoK1E5L1RqOVpId1cyN0NH?=
 =?utf-8?B?V0huZ2JhSzZ2QUU0cDlKL3VORHhpd0d4T3JtRzdGTGViUFlYRXEyYXN6cy9C?=
 =?utf-8?B?Tk9jdmdvOFM3VUk5L2drOEtQK2lhNzdwZnJKZXNKYzU4dlppTVo4WHlQL3hi?=
 =?utf-8?B?Tm1yZ25kTmREdm9JUWkrZTFIeHIwQ2Npc3gwOUlRTXY5ZDJmTmh5dU13emtQ?=
 =?utf-8?B?VnVRdEZHNHBSQjZaRVZFUGg2TXVxdWVwMnV5NVp3Y3Y3TXlncE1lT29jUnBC?=
 =?utf-8?B?bG1rSmxrMFIvUHlCTENwU1VrVXBaLzluNTlmRitzeTVrNHZGemYvOU9Sa0pn?=
 =?utf-8?B?eHh3MzFtRGV5WWd6d29obVJzU2JoNUkzTDE0Tm9iQTkxb1YybGcvdDk4ME1K?=
 =?utf-8?B?WkJwY2VFUmpJSWU1OS9Ua1U3cHEvOHMySkx4ZWx5Q3pzcFh5ei9lTzVLc05T?=
 =?utf-8?B?dVloS1poZUMyYWppVVFmMGtoYzJMa2NBN0FtY3hIUGExZEk5TEJqd0ExMnht?=
 =?utf-8?B?MG1Fa3FQK3gvQXpyZnZhUXRuM2hLZ0dNU1lXbGV3QmE4a1I5bkFIQjYxaWU0?=
 =?utf-8?B?UzJSVy80Z2EzY2xPMDFybmdFdHlnSlNET0IremlEK29PeW1xVjZnTlNwbE8v?=
 =?utf-8?B?MlhvVUFQalpja2RGZTA5aEpnaEh1WVp6Tk5jdkxSdmw0NzNhZSt3SEswVE9k?=
 =?utf-8?B?NzEvdzFDRDNqNEhOWitIRndIcUFEQ0ZyNzhzQm93bENjcElLVGI1dUxGWjAy?=
 =?utf-8?B?dHJhNFpubmlZY1JHRUJuM1hzekc5U21BeHVYVHVkVjJBNnZIcXZ2MWlkSTRm?=
 =?utf-8?B?UEV6cWlrUUdITGVIVXBhT2ZGRXhzUHhQZlltMHFCNXFxVUM4aHdxc3ZPVTlp?=
 =?utf-8?B?YkEzdlVwWTZWU1JaSHkyeWJMZEhrU0RKbTBxekVnb1NPT3pJRG1wRFRXQXR1?=
 =?utf-8?B?aTR1V01KeHFQVUFLMHZmaitHMkY2aTdMK1Rrb2g3N28rM2lvaWE2WlluYmw4?=
 =?utf-8?B?c3h1UTJ1M3hNTlZHaThXdGZVc2tlQ2ZhR1dTcGVNT1N2dWJCR2JBb1FTR1JW?=
 =?utf-8?B?R2Q2am9GR1RLd3FmU1lWMUpkWXJBVk9iaWRwMHdqOE5wSlc5T01wRXRBK2pw?=
 =?utf-8?B?SlpJREs1amJJZmJXYmVGckNsZXN5K2FsdS9xUmdNcXhHTlI4OFV4TElpeU5L?=
 =?utf-8?B?RkZqTjBudFY3cTJrSFE5UnZKeGpNRmNuYzFVTGNhbE5BR0xNNFB6dlluTGNT?=
 =?utf-8?B?QTJOOC9rb2lEL3p4QTZ4SzVHbTRKVFdxRWQ1M1h2QVY3L05uZ1JXZzBreDZQ?=
 =?utf-8?B?eWh1djhXOHpLZmduV1ZrVkRxbXA1SFpERzdCOGxlR1dYeDFLaGpOY1ZqZmpv?=
 =?utf-8?B?TFMxUktkbnRBSStWL3NUQnhVWUZBQlc4enJHWTVYdmZrR1o3WTBnZk4yTHc0?=
 =?utf-8?B?L1FzK0xXRDlTMmNldFBnbGJFYjcvaXFtZ1p3d3o1WFU5eFFHeXZOeUUyZlNp?=
 =?utf-8?B?K3hYakdSMzRSUHNVNURMQi9saHJ5YjdsRVE1TTZDS2QwUGI4ekNGNXlvWis5?=
 =?utf-8?B?b2xOVDA0MUZsNW5SVmt4WCtLMG8zbmNqSzAvS214OUZaT05tQ0czSThPc1Jp?=
 =?utf-8?B?b1dZd004dHlBeXZhWXBHUE03ODJDdDkxNU9SOUZ0WVk3SEppK1BKQllGT3ZE?=
 =?utf-8?B?QngyTjFTaCt1MEZWWlJheUZJaW9LdEEvNU5GdFZRTTNUOHJ3LzM0bmR2eEpH?=
 =?utf-8?B?QzR5aWJGclVlNjdQbmRTSUYzcS9KOWdXZWJuWUdrMGJaK20wempPMjl4LzU1?=
 =?utf-8?B?Y1ZpeitTclJIYTZtTWdONUdub2dNMFFwU2JwOGZndmJjQ1dJYUx6Zmo3cnBE?=
 =?utf-8?B?cFM0cC94K2dKQ0RQQnBPNXYweThLaEdialczc2kwalpCczg0S2I5RW5mTFh4?=
 =?utf-8?Q?PZ1dnf7i0jA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUE5cy8zZmhYYnpmRGU0d0d0ZjNOdS9WQWVJaHdBNUlDMEpWZ3UvTzJVUURB?=
 =?utf-8?B?bU9xb09DbTREL3R0TlgyN3A5VkxXVGVqcExnQ2NNMDhERjNndDQ1aDBmdEVi?=
 =?utf-8?B?ZitlWGtoeDJoL3ZDRHd1VW5ENFROWGR3aWF1OGZuMjZWbGJsclFmRmZtVkN3?=
 =?utf-8?B?TGRvZUNOWXQ2VjlFdDFLVnVhSFd5OEtDRjYvcXRBd1N2NGMvL21zZ0FLbDk1?=
 =?utf-8?B?QjYyaGo2TGRBZjFUUEh2aURUSnBOOTZyem5XL1dkZitrb1hzd2RDTnBkQVd5?=
 =?utf-8?B?OEtqSTY4bWpndDU2VndnVUVJb0JVRDVyU0x3VHV6ZWZMcVV6SVNuc1YxUHlQ?=
 =?utf-8?B?ZG9iK3U3VVM0b0RvcGdTZlkzODFlN0x4eWRyalFZbmoxNHNUeG5VQWc3ME4z?=
 =?utf-8?B?by9vV25UbTFtY3dLdEM3NTVvRjhLRHVpR0hWT2FzZkNtNjIvSk9yeWtBL0du?=
 =?utf-8?B?WmY1aVIrb2ROV1hnVmd1QWRzamp5Y3VwdmF2bFA2c2oyYndTelptOFV6SDRu?=
 =?utf-8?B?ampqOTF0ZFI0RGpvY2UwQjQ3alVFRmtLSFJuQis3VExrVy82a0k0SWFhd0Nw?=
 =?utf-8?B?UTFsVUEzNmVlMkhma2ErUGRZWUhDRkczRHdCOUhXMkJPTjQ2d0daUTRzVmpq?=
 =?utf-8?B?RlVjREt2MjJQTnArTHd1RlB3K1dScjViek9UUnRTMDNhaXUrWDAybmdCU0tI?=
 =?utf-8?B?WWNrY0pIM2ZTLzVQanFORC9VSDMwS0tVeXQ1WS90L2pYVU04Yzc4OE84OThu?=
 =?utf-8?B?U0xyUW52dzZtd1NpWEVhYlZUSldMSXk0MXg2S3ZRbUNOUVVsZ0puZDBma2tY?=
 =?utf-8?B?dUVFc2M1RWdyVWwxVHM1UFozQUV5S211U3RXVC9jdkNsWWhIOWRNbWpST1Zq?=
 =?utf-8?B?d1VIdEF3VEhET2RLdXdLQ05qL0VrME9vMFNLSmpuY1Q2QlV0bGpZWUh0M0Fn?=
 =?utf-8?B?MTVUSUlHWkthY2dPem9jYU9CUU1xK2VUcUdjSnIyYkM5SXdRUDQ4T1NXRERF?=
 =?utf-8?B?YjBTT0xrcTh3blk1SEpjNXQ5cGhYcnVEWEVJUDJiRG9tZ2l1U3VxVFhOdUxJ?=
 =?utf-8?B?NDdGcXh5U1ltRUhpaXRCbGNENVUyYXRLS3NkSFljWkRicW4rQTBObnB5KzA5?=
 =?utf-8?B?ZkdyeHF2NVF0Mk03R1ZmcVRXdm1IVEs5aG5QMTFNeS9ra09ndncxaDcxWmZy?=
 =?utf-8?B?dzdwM1dEajNVRENqMFU0VU0vanhhSEtQZk9wa3YvMzJsTmpzZ3IrNldrZVAw?=
 =?utf-8?B?Z21hUDFxVEtwZHhsWktIOWV2T3pFWkN3YlE5dG1YeFVIRnlCNktJWnVOaGVm?=
 =?utf-8?B?cEFaODJFQnpMQU5SMlRwbitOcEVXR2NxRmMxYTE1bXRpWnE5TU9TN0NPbm1R?=
 =?utf-8?B?NmRKcEIvQ2g0L003eEZlYlNFRDV2NXZjdGppOHlCZ2ZQUWxtMzZrU0lqQjNo?=
 =?utf-8?B?KzJJL0JLdmVMTXIzcFIyaWxlNTZ6dTRLM2JvZkZwTWZxM3lmMHlWREVSQm8r?=
 =?utf-8?B?ekU0OFd6ZUVDN05mUXh2cmd4MkZCVU1JTlZTL0JpWVVlSWliL2xMM2c2RnRW?=
 =?utf-8?B?Nng5eVBLdTNWMHY5Nnpldzh0S2FtSGRhTW9NQnBFTGlIbzFRbmFPSU43bUNL?=
 =?utf-8?B?eXJSSUxMV2lsK0I4ZGpNZmwxNVpXdVEzSXYrbTRhMnhQNjIvRHRkTGE1bWZF?=
 =?utf-8?B?amNJeXNacFJLRUFPNVdtTzNnOW5Fb2xPZGNBZHVqd1NUWmpPOGFxaFU5K0Rm?=
 =?utf-8?B?bDJ0TTBGcXNRem5nNnZ1N2tqSmNlaEJEWVZFK2x0MjJDN1FJN2NtUlE2VTgx?=
 =?utf-8?B?ZmZCSkV3REd6cExZRXVZTWhmRmlMVzlTaGJ6Mlg4WnR5aU1ZRGN1c3VRTlRR?=
 =?utf-8?B?NmluUjFvSGI5YXJoOXc5QVhqakxNa3ZVdFN0ak4wa3lhRUwyZGtNaS9nOTgv?=
 =?utf-8?B?UDlXSThYbyt5WlVIUU1vYzVLRVpnQkMzb2VqQlZZVmpYa0toYy9kM2t0VU1n?=
 =?utf-8?B?Wmh2MDdydzRGbWYwZzdOdW1mQUpQVjU5V1g3bGVMWmlrOU1WOTdwUjhMZXdM?=
 =?utf-8?B?TnRXUVVKQjFncWtZSUVEdXNCVS95NmxSV2sxU0ozWnRwR0Y5dll5WHJzaTVE?=
 =?utf-8?Q?rX4RBrst33P9BsCgXFtaoWeOe?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+VJg7ewoavznOt65ytgVnk3ZMn3JJKLEXvpsEC/cXR0xHr0CEheLk+s3c5c2/Xfz0wx7wE+Q6CAV8GW5r1fUQGARH+M2ZW/AAzizkmkAhmupINN03Kv5q1i+nYJnlmyiithll9ePwnPCY3OK071nCmJhPg1nTjYdaF+jLhUGHD8p6zArRwEKjaweCc2dCnCQuEFnB+DSBnXk3Z/5sao6M7SxhfOurcNZYAZckrEVN0DU76PbbjR++Y+zdBGfBnLISu1mPdh64eavWa05zfVZpsMMDJcXOCIHS9/EJui3kAUW8kvcuCSDDf84kVvkEkcGeV3OIXJqcPjbGr7x8axw9AknyLkq35qgA//PCufdGJ9gOnZaQUFsVd8ulmbAWKjLrEO4uh/XlKNp0rRZQbSfA2F0EX/r9bw4hlWVHPB9UQmpApqLuCnKiuoeFmdPxUGwQg/R9ImfBfrejr/1zhs8+HBLfbyf2O41C3SYjLCDiEKg/WsM0FUUAu9ueJHIx2b0RzQKTUNcySTplwkT7yxvhVyqzVYGv4msgcQgZz0B/nzNKqLsSSKhB2S4PaCKSp/B709DoyRhU9O8YrMLD2F0SkekpR8ZU3xksfaD4ECu9es=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c554e9b-336b-4759-ed08-08ddef360208
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 00:15:40.0182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oOgCuLBeyJakl6y0it1deAkxtpCzqFyCaMYdubGJNx/ZVD98WNVQXgPPsmiQVCXnD/msbBrdHwxDD8zrnN35Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090000
X-Proofpoint-ORIG-GUID: 3VfTEx02WFs6TBl_xoe97bV-qVcQcjG0
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68bf71b0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=IsveBStheV350DT9e90A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3VfTEx02WFs6TBl_xoe97bV-qVcQcjG0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfXymXLBgTG62zJ
 9UsW4iEsRYYffqdc8MWvhfmj40bjDZ0EQwys0/qLscyt51ZcRphdGHpKjuwkPbUPx/4/9Ed/nuB
 SxoD2S9ND+I8nMV9DLzjDbfDaHLvEVqk6fKxLwDd+QkUB5x49g72WJzsvQ0KeMzJGfUvZ/r84rW
 IZq5gk/RHq0ozg9ZZxwzTzxwWsEiSI+Z9uKMeZWBpHsAcl5tx8npSemvQvWasOqoAz1GUZuPYNE
 vMqoOLEZkhbN1hvr80f0ZNl4aEQ1mUKRL7kHi+HGS4DlxU6sDmDcSQq2Kj+xTrwmylUJ73FZ35O
 NWXqLlnZt19Nt8OmKmtc2OWiftF/OJTdZJzWktBZQqkPj2KxkR6G6P54UMXTtlrrBy6sJ3NexOV
 b5BYTGf5
X-Stat-Signature: hidpnauwjfjrcs4ai4k44o7swyqs1s1y
X-Rspamd-Queue-Id: 2FFBA180004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757376954-340962
X-HE-Meta: U2FsdGVkX196NtGCKUEkxnKgMJeJh0JXPPDjZrcFcYKGQegQ5sgBuMAo8UqS5OuivHJyIUA/xLHnbGCJTj70382Eb9Tj9u2oCmGJzVteyzJmeThY91IUnfRnRIEe6USpD391SKqCdVDM0sO0NXTjLAFJtRFsj11d95gqNVHOsODbwFIPxFAfPS7NlFhsK6sSrUeTTi4kRuBFyr99tTIo5p08VlBYens1N7Juo0OMrBoKpJ56V08CB13BD6uhLU6W1lZUoA7PqNTOf6XKPILAtxHkCG/1YskhI+2OORyVxEyQ3OPvSSjAlr0YeWEqKpDekdN47YGrSSK75OBY6mxGCDaLefobZcV+WXRM5ZsIilJ9HBn28nOY9X0SrUevE6BxqTta7FVd4ocP0u3IpfIsvr9gpYCAhYSYYmrDsCsCSsW1H/xZVAPeLFOWVXuFJU5W2tWP8PS9QQYn7c3y0FpATZcGgLLzTJudCx6yksXYkmMPfqr3LibQDAKkNpobTClph5O64HTaR/7S+BDpzKtq2UrrGD4jZIw4AnZdyxw5dXdjrTl6VH5MtSzcRVhqRv8tU8hnTyEuNiyOxJbDlCIIhRZnobYOAVFkALgBBDuNd676IWCqNadebPYxxOpL7d9x+qrVWR7w8o0DuufWnpL1WaKAB370UKb2UmsbeC+0kwpZ/5KeEuDtJsaOD3LWYvrrgW//9UMahaeVkFBVOOyp1MM2g9YcYaenGqd37xwBFJbi7sESFe9zAw4gdaHR7jOK4QlY03Kx8AiwptIGOeKt9skujxVIFVg20NShP4FPhB7tQHTMDcDPuSV4W4ome/1zxmhijzBg5j5KaMrrKW1NewCzS3b9hJLB5bN5qf/RbT2ACJ0hi84I8kohqQbdMw7cd5mgvHyfpYCDjZmho4e2hY9COR4vOW6A4oFwNZRyJRDzTHZ+H/aEFMGxHZJ9ueLFQj5SzW55bH3dCEq3NIU
 xSBFs6CJ
 gV9sa0yPLkHTgORSoN1CENxOV2hSfHokylsnqKIfrMajM6S5rU2UeeiCnQkGCp/2etc8+s/LkD84OBKpn1aEVOE4DXYrHBzL41dDu3ndIKqlGekQmj59ziMvUEW92m9jnBJcYkUvL0YCPNAq6x+WtikNrlS+XAitDQjBmKBQge8/H8HIlO9YYIuWDOLkDk7xFWfFHxca1gwLjZkOcB116IsChNBCuITFPobIi95wO/F1MTMvxRQHgUCM02mSfd/Z/vRsKJ3aAq30VZ0Kzd5xX3/2QQUHLMJJQRdhkqkCzTTDpZN4y4Ce9A8mp2to+we3Jsy34U6LtpGnxHmfC85yRbn7PeFooBbPhpDEPznarvLcGkD4OpUgVmbxY9vWoVNKoe1JE4ju6Glky7ixl89qZppnGR6J7AecGUnp3Z6FLiDW6HVrbuYoaAI7z7LjUNgYx9uxpL4lKojhjVUQvy55m79G8PEerlakGPtKoB7HGUTkk0DUkaRNAHWh488nu/6oN5lO44CRYVlAcwAzzo+38F809RtWxbf53YCb91xR0u3WIoH9H26+CLhf0YN6PZ/23jlsYmkiUy43RjqzuGgVEkFGdbjLpAutx7Vyy8/JXxPVasfwsptZYe78BIBDvV6X3BlBRF2Ej6F50sDL/61/CcRPGD3npCifbKQobDl3fvmbNkwWGh17JOWiBm1Ph8nHF92kzVcvA7j5xVij9o6C7JpMo9e3rfT7dWhLQ1yaBVR3gWqAHw7EjjpiW5ZAyJa84Un88HU9ah8NhcMs2toyINbca6KvDgIQwzPewCs/dGMcKqdYLssuWGyJaEv/kv3h/+az40En9W5dV4YvzfqggtduvVfJPjc55Fkr+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/2/2025 5:48 AM, Kefeng Wang wrote:
> Kill cma_pages_valid() which only used in cma_release(), also
> cleanup code duplication between cma pages valid checking and
> cma memrange finding, add __cma_release() helper to prepare for
> the upcoming frozen page release.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   include/linux/cma.h |  1 -
>   mm/cma.c            | 57 ++++++++++++---------------------------------
>   2 files changed, 15 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 62d9c1cf6326..e5745d2aec55 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>   					struct cma **res_cma);
>   extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
>   			      bool no_warn);
> -extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
>   extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
>   
>   extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
> diff --git a/mm/cma.c b/mm/cma.c
> index 3f3c96be67f7..b4413e382d5d 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -936,34 +936,36 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
>   	return page ? page_folio(page) : NULL;
>   }
>   
> -bool cma_pages_valid(struct cma *cma, const struct page *pages,
> -		     unsigned long count)
> +static bool __cma_release(struct cma *cma, const struct page *pages,
> +			  unsigned long count)
>   {
>   	unsigned long pfn, end;
>   	int r;
>   	struct cma_memrange *cmr;
> -	bool ret;
> +
> +	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
>   
>   	if (!cma || !pages || count > cma->count)
>   		return false;
>   
>   	pfn = page_to_pfn(pages);
> -	ret = false;
>   
>   	for (r = 0; r < cma->nranges; r++) {
>   		cmr = &cma->ranges[r];
>   		end = cmr->base_pfn + cmr->count;
> -		if (pfn >= cmr->base_pfn && pfn < end) {
> -			ret = pfn + count <= end;
> +		if (pfn >= cmr->base_pfn && pfn < end && pfn + count <= end)
>   			break;
> -		}
>   	}

The only difference from the previous code is the now missing VM_BUG_ON 
upon a given range that stretches across the CMA ranges.
The warning was introduced by
  c64be2bb1c6eb drivers: add Contiguous Memory Allocator
about 15 years ago as a caution only.
I am okay to just return false in the potential error case.

>   
> -	if (!ret)
> -		pr_debug("%s(page %p, count %lu)\n",
> -				__func__, (void *)pages, count);
> +	if (r == cma->nranges)
> +		return false;
>   
> -	return ret;
> +	free_contig_range(pfn, count);
> +	cma_clear_bitmap(cma, cmr, pfn, count);
> +	cma_sysfs_account_release_pages(cma, count);
> +	trace_cma_release(cma->name, pfn, pages, count);
> +
> +	return true;
>   }
>   
>   /**
> @@ -979,36 +981,7 @@ bool cma_pages_valid(struct cma *cma, const struct page *pages,
>   bool cma_release(struct cma *cma, const struct page *pages,
>   		 unsigned long count)
>   {
> -	struct cma_memrange *cmr;
> -	unsigned long pfn, end_pfn;
> -	int r;
> -
> -	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
> -
> -	if (!cma_pages_valid(cma, pages, count))
> -		return false;
> -
> -	pfn = page_to_pfn(pages);
> -	end_pfn = pfn + count;
> -
> -	for (r = 0; r < cma->nranges; r++) {
> -		cmr = &cma->ranges[r];
> -		if (pfn >= cmr->base_pfn &&
> -		    pfn < (cmr->base_pfn + cmr->count)) {
> -			VM_BUG_ON(end_pfn > cmr->base_pfn + cmr->count);
> -			break;
> -		}
> -	}
> -
> -	if (r == cma->nranges)
> -		return false;
> -
> -	free_contig_range(pfn, count);
> -	cma_clear_bitmap(cma, cmr, pfn, count);
> -	cma_sysfs_account_release_pages(cma, count);
> -	trace_cma_release(cma->name, pfn, pages, count);
> -
> -	return true;
> +	return __cma_release(cma, pages, count);
>   }
>   
>   bool cma_free_folio(struct cma *cma, const struct folio *folio)
> @@ -1016,7 +989,7 @@ bool cma_free_folio(struct cma *cma, const struct folio *folio)
>   	if (WARN_ON(!folio_test_large(folio)))
>   		return false;
>   
> -	return cma_release(cma, &folio->page, folio_nr_pages(folio));
> +	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
>   }
>   
>   int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)

Nice clean up.

Reviewed-by: Jane Chu <jane.chu@oracle.com>

-jane


