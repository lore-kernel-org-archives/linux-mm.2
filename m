Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B64CC88E7F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787676B0088; Mon, 26 Jan 2026 04:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F226B0089; Mon, 26 Jan 2026 04:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640696B008A; Mon, 26 Jan 2026 04:33:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5020F6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:33:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB41A13B2A2
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:33:37 +0000 (UTC)
X-FDA: 84373602474.18.B519920
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id AF93D100003
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:33:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RSShykh0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B76cqGK9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769420014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NuH9xOJ57bz+gXUVl9jhkKdT9uwTHzqlHZzuAzLe6Y=;
	b=lWDq2gujzIK2IvQgoxUXVB2VDWE+2p8tjihUzGzu0kyKohycvE8Zt7VIl/7+8go71RdM5D
	TUbXyxA3sKotoNE4BzxqwJwZYcG8N1kiwxEnn19EmE3frO9Rp97uYTxHwi5GVNtfyu4Iyq
	52B9xrNBdpxmQtvb31Dzefx0+wYzkVM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769420014; a=rsa-sha256;
	cv=pass;
	b=dtxV01pVztKUS6yIC8bYbnEAWRfZUrDhjo5Ej6D19vePgn/xEHSTc87qLQy/Hj3rNixSpn
	MFXJYn8txcPs08uQSb+fQ11YHIREMDmvrgNF36ZvbPUSmmX23HWKLXUPgeF+rRNdKXkNH9
	DDggNmGLXiKdn4Jl8KkbWBQrcQbMI/M=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RSShykh0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=B76cqGK9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q4sMDZ1030005;
	Mon, 26 Jan 2026 09:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/NuH9xOJ57bz+gXUVl9jhkKdT9uwTHzqlHZzuAzLe6Y=; b=
	RSShykh0J4Za7Ti12GtHcYqi9YsPMzEdJ5XYpouNxYztivsak/Z9pAcOZk8odzVz
	5B/vFqQGoUGi49BnHOmSBtkSr2Q7Ocz9NOaqqrFg444Su1b7kmnNcsFCwmamJ/1O
	y6om+/E995n5t2oasRMZt3mK5ZvEvwDNQLwEa1TSI57Kof8Mt4J6VaZaWIj5DHzO
	7kN+ZdCGGDTLyYdf03YfwuQfPQu0FZ0SK5Y3TpHL4imLyxCOniVmCWnHAI5IoFZ/
	Tdw48sNXHoOWo/eOKeWnnzRQ7C58Dhdg6YOqtgleo2H0XJH0ct7Hk6NdjYQ6FBTK
	5Il5YZ3Ef0eWqR6e8imtPw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnps9jfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 09:33:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60Q766hE010538;
	Mon, 26 Jan 2026 09:33:19 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012018.outbound.protection.outlook.com [40.107.200.18])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh7s4kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 09:33:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiZ/bTQHDqMPR+ryXcNOk2a+4q9vfLfz8qHMfsq9qYRJQDmlZj3Hd50FeQzCSfr3Cc5Mkj7KQOHNeSg7IYJX/3qF1l60MDJuVjCmw9/AMKe7X9jqDY3hfTL/NbW5aBW/4/LDfcy25GTnjcxj+U47o4vJt6pcRT0Fp5d8s+7YhIbwzU+1nir9B2xqG4laEsIm56A0Ie/Qkog1QTLqjiVNYgHGjJbi9t3NrPEEfVjQvrq8HMxRY40BOmLPL1XA+ZU725OB6JC+SMlOq4SnRXwGoTvvxJAJP47s8sA4ZpEU+YwJiXr8bXDiHY4AgxkTfJZK8Jwh+JGVryLdw3QZRk15VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NuH9xOJ57bz+gXUVl9jhkKdT9uwTHzqlHZzuAzLe6Y=;
 b=wPpngvMbmSfM6iQpwPUWTi9WZsorYlBbF0jJxDVmtlBgO2dyzSEqOvnoMQDVmlxd5wiHs519+jOowRnpQUyYxx9l88frt/pCuXkZ9+7vCd/1lHh6xrPfPwnXLPLhu6IIjLNr9E3u0+mY76oYbn8zHcFzaZAihBMjHym9n1AC4oOylSkalhpRYUgvK7yYUKY0nocFYu4xUFzy4my2lHatbjZ7RhFs3bELyjoUQtsOn461Typmhf40A8ju116PumfacLRPDFZZ3LOR4UUChmEKHXaKUFxJG3AFVc8w81BxJYSBiXlCbYCdS0HOasTMpUMNHtAuVq9IukTKu/GjVK0Jng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NuH9xOJ57bz+gXUVl9jhkKdT9uwTHzqlHZzuAzLe6Y=;
 b=B76cqGK9dg6wBlgmSyT8WdNT3s7naem1p1uciJgO9xl3NItXT5CgZSnXK7vpHv8K9+iM8QcPv2v8FvKeEgcXN17uzRE55Doli/8Nx30lLwdn/XtWCQX//i6FysBBhrCUFRjh/OhrzCjjxD36FbLXuwCcxzjZvwywq1PJIOXWNfA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ0PR10MB5582.namprd10.prod.outlook.com (2603:10b6:a03:3db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Mon, 26 Jan
 2026 09:33:09 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 26 Jan 2026
 09:33:12 +0000
Date: Mon, 26 Jan 2026 09:33:05 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 02/10] mm/vma: document possible vma->vm_refcnt values
 and reference comment
Message-ID: <aaaf33e1-1ef6-4ef8-84e1-c0ae423d8dda@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <d462e7678c6cc7461f94e5b26c776547d80a67e8.1769198904.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEHDVe6==dzb+U5E2Tx_50rH7t1opes8gnzZDP1sKjKhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEHDVe6==dzb+U5E2Tx_50rH7t1opes8gnzZDP1sKjKhQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0416.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::7) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ0PR10MB5582:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a6f79e4-70cb-4712-e717-08de5cbdec8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MjByck5qK3VoSStIaDM4UEJhTnNmcFpKT3hLY1MrbEZZZCtSelFiWTFEK0Zm?=
 =?utf-8?B?N08raGt0Zkp4MlNaY1o2RU9HamNtVzhySmpwR2lkL0dmM0hZNFdoYUZmWlNn?=
 =?utf-8?B?WTlndGZkZnM1TGRiT1ZZTXM0a3l0cWU5Q0wxcmthcVFLSjRpcXRlQllwclhK?=
 =?utf-8?B?citMOHZnd1FsZm1oL0JUcUhKbzNqWG10NzY0aS84UUZuYi9jTlc4ZVJ0MVo1?=
 =?utf-8?B?cXFPUFVxQVJnb3JMQllBTC82a2NxUmxpT2Z6WFF4NmUwUUI4ekVGOWUyNjhM?=
 =?utf-8?B?NExhNE9SMVRpZG5ObFFrTDc4a2hDSU9KQWEwSEZlUnlWWHJPOEJHaHZrVGZW?=
 =?utf-8?B?NStHMENjc0tXbldJUnB2dC9jWHpUM1NwRkh2eTFoaWZCV1Q1dUNOZUFMN01x?=
 =?utf-8?B?SzFaODNQNlJCSkF6cFh0NThkZHNOVGlCcVQyY0RlNHhPNHJVYlkwT2dLZWNs?=
 =?utf-8?B?YjZyMXlGL2dqenczOXFZT0Jyc2lLeVQ2VXlhTzliMGFkS2FuSFN5R2YvTzRL?=
 =?utf-8?B?UnZVSGwyQStFVThPL1hLZ3gra1orQTZCeEgxMDZ5dHpTaXBPeXJqUFhBRUZl?=
 =?utf-8?B?UlhQTHA5bk9CU0dxL2tsOGs1ZWRydmk5VDdQUTlWYkVWSm90Vkc2WHg2emdh?=
 =?utf-8?B?cGlPTDM1SUxzd28vVU5hMjdRc1dMUjJ5TUR2Qlk1NjFEV3ZjNW1XTTZ2UVdL?=
 =?utf-8?B?a2t1K05IVWw2Z2ZwTnF2bEdUbDBILzBHYVo3bmpJdlprRDRycEtaclBBdFpK?=
 =?utf-8?B?NmNNVDlzQUwzTndYK1JxK3kyejh0RElWeSsxQXZDMEUyLytLZllZakh1WWJE?=
 =?utf-8?B?UFQrOWlxSGdwRnRaYUprdVpzK3Ntd1ZsNDRKUERKVzNvNHh6TFFLSmNNRldD?=
 =?utf-8?B?U255V2FOY2pJTEdaVTBnQ1VaTEpwQmNCbmk3K0kraXFReUNUNGtSVXQwbDdY?=
 =?utf-8?B?SENqd25jK0tHc0JBTWVUcXpmdUZ3QjlYVnFOdXFNOXRqalNsSXB6UGRiaysr?=
 =?utf-8?B?L2xDZzIrdVcrNjBydncrTTZEMUF1ZzZjRkFDS2dSc29BdlZReVlRa29QazVY?=
 =?utf-8?B?ZlJGVzFFbkJoeDB2bC9TMmpVYUFXaVVPT3I1SVhrL2pkSHcrdUdyb2FnYW9S?=
 =?utf-8?B?RU9YM0FGTmxkR0tqeHJacXZsTjFydlhQbjh1UG81NXJtN1NqeTZrcE9aOXlr?=
 =?utf-8?B?UDVwa0V1Mk14ME9YazlLVHZtNEp3TXlLakh2VnpCa0NRbDRnTnJtMnR2eGJI?=
 =?utf-8?B?RDR5OXhtc0hKWTZ2RzZ2NTFWMkZHaVhnaVZHeFNxTU9WaURLNXBHQmNyOEI4?=
 =?utf-8?B?NmFlYVZ3ZkdlTDFLK0dRaHZuM3RkeXErTmVlQy9wdjNCTjgyL1dLVHJlUEtu?=
 =?utf-8?B?SXc2SHA3TTRNTG02T3hyc2tudkFWN1RmSHJ5QlB2MUdKRXhDb05LcU4vSHUw?=
 =?utf-8?B?bUtuRjIyM3p6WVg0ZzNueVBodHJCZFMwdjM5UTVzK1ZnRTJSVk4vVGpMQXEr?=
 =?utf-8?B?THhoYzhSTFhrZmd4WjJTY0MxbEdmZU96YVdOZmwrV0h6YmtXbkJGUk1xRytK?=
 =?utf-8?B?OEVtYTU3VDlMUExHaTJIVDk1dm94bnc1eEIyYlRZM3ZlcVlZbENMcGI0em1I?=
 =?utf-8?B?VFpncXM4UHdHQzBYbGtFNW40VVBoZkdPaXROOXVlMTRjdFFJbTBtY3NLQnpr?=
 =?utf-8?B?clFLaHM0QnlBSmdHYkFQUkRDdkZqWXBYZ0prS3RtZnVjd000QkhnMXhxQTRZ?=
 =?utf-8?B?MUlEWW5Cd1k1VlJoNHI5RCt1ZDFPWm9xWllyMEFuZnR6VGU3cHBHWGN2b09k?=
 =?utf-8?B?eUhVM0xzVGNtamJwWDhiVmIwb3VDUDkrZ2c1enFsQUZoT3ZCWVZicXFFSVE1?=
 =?utf-8?B?eC9FRndJZ0JhTzZyRjlMelBDeUwvSVIxQjBOWTlpbWNmQmd5TXpZSGdwdTlD?=
 =?utf-8?B?b2JobzZZeDhTWWNOcFFWUy9UZjA2TUxyalo1RWFHYjlsSkpiLzJQY1NZNXpu?=
 =?utf-8?B?Z2FYWHg2eW1ObzBoYXRrcTBSQWV3clBQSkZja3JwUXhvRWNGWWppVXV5NEVa?=
 =?utf-8?B?NFBvQnJibGpieEk1M1B1Mm1aZUtRQ3g0RkJDWGd6NEUzS2xvSVd5QWZmR3Ju?=
 =?utf-8?Q?keEA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3MxYjVycVRYRkRIZ2NEemcxdFE4WmRrNElnZHlPUDA2UEZKVEdxMXVXek5k?=
 =?utf-8?B?c0ZENkJLbHdIckp2dGd1QzJRWEhXenBSazRUWFlTbjh2aTBXT0pzYXFEcGxl?=
 =?utf-8?B?MHVGKzhybjhtcURVUFdZVURTTnJmRFFvOWF6Z0hYNlZwMklza2tlUHFxTGsw?=
 =?utf-8?B?aXBsQnlYRlB5SWJHOVB0dnNtWFFEUlJzZDM4WGp2bDJEUkdIMkJmdU4zaXRj?=
 =?utf-8?B?ZWhxV09aK1UwSk5RaXpzK1VYR3Q0eU5oc3kySHJzTUJxVmNjUFpyNnZ2bWpB?=
 =?utf-8?B?dStqT2N5RVB2TmdDcitQQmVVcU1YY1RoSUpKVTlQWi8yZEF6UU0xRGczenFy?=
 =?utf-8?B?WXY4dGZEdUh4d0UyNFFuTUg3R2xXZzJTbURnTDFUUkcvcSs4UDBmeUJuRkpD?=
 =?utf-8?B?ZERMOWExQ2gyMUNadXl3OFdueVBKME96SVppeEZsOFZqS0s4L0RBNUYrS0Na?=
 =?utf-8?B?M2xDamFkRkNYeVp5RG0rSzVvNVRzZlY4RWZybWpDVythUEtXeWJxL0dvMS9C?=
 =?utf-8?B?N1ZseE9qaVdHVGlFQXliRGhSWkZ5WXZ6OHpSMVJNSFZFbjdLOHZQejliK25P?=
 =?utf-8?B?aUJaVUR4a1Rib0xiYTI5OFFQNWtsQ1lMcnREaEs3Y2ZjbzlPNlFWMnFsS2pD?=
 =?utf-8?B?dUtmRWdUVjdLdXdIc1Uzc3RoQ0JXc1pTNFpqZ0xBc24wM3hhdmhSTTFSWXZG?=
 =?utf-8?B?OWFtVzMwU3RCN2dFMzQrN0VJbjA1S3MwSkNQQWxQcDY3SlhmZ1lBZGp4Qy9n?=
 =?utf-8?B?RExGQURab0hIWUQzK3RPd3RMTkw0N2Y5bGZYNlpGdzVuVURYdGJmWVdCaUpy?=
 =?utf-8?B?R0hGZHp0Qkh1bmY3VWxhNDI4VFpCNmZVN09VNmZnNWQ2S0RhM3VBTTVLQmtS?=
 =?utf-8?B?RExFSUdMSklkMnVBLytlejVDa09BS1ptTG8wR0RhZU41NU85VVIxQUZhN0ll?=
 =?utf-8?B?ZXdhWVVJMlYxQ2N0ZUNsRkM4MVpSSm9nUHZJdVBhYXhLR1J5UTN2bHpVSVFv?=
 =?utf-8?B?bGpFM3JJaTY4WTB0a2dkU2pUbUdXS0pTemdTcDhQUUd2RCtsazE4Nmd5NWcw?=
 =?utf-8?B?K1dlT2oyU04zZXE3U2Z3RWVuUHRaNWkwVWg2N0xVS2hPd1V6cVdVRWN0SUpY?=
 =?utf-8?B?RENxeDRTa0s4dUc4Z2lqOE0wbVlzbFl0QVNBa3dVdnRwT0lCVjBrNk1Ob29K?=
 =?utf-8?B?MkMreW1SR1YzclFMZnR0cHdDMEhuSFFxeGJZcjFLaStROEw4aGJ2bXZ5VVox?=
 =?utf-8?B?N3FQdzBLL1A5UjlXUWR3TWRScmN4UGk3MnFaV2ZyZUpiZ1h1c0JBWXNUZ0Ji?=
 =?utf-8?B?QVZxNU8rSGpWcFpQaDhLeFI3R0Z4U29mVUtuRG5oL2J4SzhYMC9iR1d2OVRJ?=
 =?utf-8?B?bVJhOEZueUZWL1JrSXZKSU9WV3YyUkpMUWZXZDVlMmtwUnhsWlFtR0R0NElr?=
 =?utf-8?B?NlY2UmFpN3lyUG1JTkxNRkhCK1ZKeU9FbnlnOExHdGwxK3JCaGJpVHBJOXJB?=
 =?utf-8?B?QjlkVkNnOVlUZkUzdDBWNDdXSUdHdXo0alRONlgxYzVJVDI4UmdHWGVZbkY1?=
 =?utf-8?B?Zm9ZcHdKY1BlV0tXbWUzazd6SThETFdyZnV1UkZYL2pIVzZZNExUZzJyK0dM?=
 =?utf-8?B?Q1FhK1dTQUN2T2hVVWVZT3hXdzVXRSszbkFLZVN2aWZtRk5EanFiWGJHaVNh?=
 =?utf-8?B?TitZSUdQbHoremxXbkttODlmMEE3cUdxSlZPdk1LN0Uwam5PeGlZWEl4a0VU?=
 =?utf-8?B?NGFsMzY5a2pGamlrNmhYa2R1c1VVWHBzaDBGS2RTWmRvWnlFQ1daaFZJZXV1?=
 =?utf-8?B?Q0ZkNU1oeC81OHN0aW5Eb2hJcFIzek53Y3VkK0tEUWk1QlJtUTU4ckUxN2NC?=
 =?utf-8?B?VWRpeHVUSGtTREcvZDdIZS82KysrTXMzb3ZPaEx6SWJBcGdmYmVmY0haUjJa?=
 =?utf-8?B?M0xtb2xxVVVvTHYyckZLZ0pUVzFETU1SNHl1OGlLZkNqT3FJYVprZDhPS0Zi?=
 =?utf-8?B?V3dGeFh1YXBCU2wxcE1WcFl3Z1RkZFpNZktES0pJWUNxazFzRnBkRjZrelpn?=
 =?utf-8?B?UzdkcnZlQUlvSVZOR1Q0b1lHREF6QithUUgwL1JRcXZsWDRETDVOS2xxQnBN?=
 =?utf-8?B?YTJuZ0tFVW1oMDFYeDV2UlE5MzFJMkM4cmFZblVncUxLWWNXWGpzZVJQVm0z?=
 =?utf-8?B?eHdIYzFXOFdyeEhDcFU2ZGZQdm5NWmVJdy8wV0F2U0pMUmhNUk91R3JSQlNv?=
 =?utf-8?B?NmY0TnhPNXlPSzR4RW5EVVhmL0lJRXdKWi9adWNRUE52K2JBTWZHR2FZTFJC?=
 =?utf-8?B?azU1TjY5VlNnMkxsTnpydHNyUnJma0dCRzRPRWg5Z24xUTFBOHREdHBiZG9a?=
 =?utf-8?Q?3KTjH3M1Y40fMFdw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qvDnZ2sRMFo/QDxYRHO7cfxRh7BFi4gFKnqSB1hWdAxUTY8ZSGoXHP4EKElcQXTmD0B8kdTUicOTKTG4//OvLFbk5SpUl6RusDeyxHY8txSJQl6aQ+wNMQ09oko1OPPaw9anCTczMg5cz+aFJbDYwrpcMWTZpnThkLxDeMRJIe0WzAa767nU6PjWT48j5/ciE+F6+h7c+2wt4TrG8i+AOv/4c5N2bpayU1VeCl3gTC7+yz5epzYCjclA6f2wgYiNlMS3LlBe1HbMIMim5i2tAl6rs3mkfIT2aUww5NJ8dlQmb23/Ur379yTcZXi4rHdUDaNdOf7Z7iL8xzbPy76tQULQVKqGCbJQAJ+K15SlLVUB8Iov8dcPcMVEn2/M4XqHl9lfwh4unEtHxWCNTfzXWcxjF5BEWer1vDPEujmC/oAszyyKcyE1I/KNi7mfpBSxv6zPy6JR90wzsvOXPFm+ZgeEHdWNlqErle/VBGe52/h9vyy+e5E7+zxF2vPBOt6WyZzwpbqOvjX6W49LUVeuYj6Kv7Nec6NW8oYRHZCFLApxkUnZHJ0weGkfGNLm7ZleOU+c2d5TaHlEmhndKp7JXc9L+pi83h8WbAoXRGQtZOc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6f79e4-70cb-4712-e717-08de5cbdec8f
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 09:33:12.1511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bCrjcUboxPGvlkb3ZLu7xeMeR7nA2kyTTgs6Syu8qrcgYF27Mj36wO5J3uPINmL2K8QrPvMmJstG20FjJRA15/oqYiagbiDDvVlZoGuoUjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5582
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601260081
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=697734e0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=DPStYy7rvKqjGcsp66cA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cvuo5s02D_di2c32dEn2aHVxipqCw6cV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDA4MSBTYWx0ZWRfX71u8IeRYlNr7
 VV3OyAj9M2OBnajNubBIneasi4Xo2xKJzT5ODtjgGpjeL9+3ePQmNX6f4TstsiVO5+hdWCp8V89
 S8hNrraLQDiyrSueJEqiDyemSqAGtozMJMFTfutFokGVkZDS2qVv5ErcwIEGSuoQQff6I7fk8Gp
 nElwCtCxLdISEv3MIAs6p77mYddtypolIgy2v8Qf8e3qJ/CxTlepz3ToiVTWTHx/4Ry+RV3g8sG
 PFGkCoa+DV1BwpionqhIVvUG7GCggFAMp5pzn3nkhS/pOWc+WinTO4IbDWdHLlomaKdwHHEqTH0
 7u9Eg2zfjtKyyl/me1VSv++D5KsNKVC1U4rXA5jRr+9M4Ik7H6FDhmW2ZH1vJ60m0gP9KXaAk7K
 aApf6xYAYVRgctJTXckOvf/GOr0vCzkGW9mebbYKo0hllMzV4ikTio80H3qbW53axA3MJ4ZnJ3v
 rhBwl8vXTU9kwVjPtjQ==
X-Proofpoint-ORIG-GUID: cvuo5s02D_di2c32dEn2aHVxipqCw6cV
X-Rspamd-Queue-Id: AF93D100003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zkisrhb4iesgkbmcd4krhktcx4zg71ru
X-HE-Tag: 1769420014-879211
X-HE-Meta: U2FsdGVkX1/h6oJIdZrjuqU0lfw8OIfkjzVWOrvx9JeCnBtzYlmjgEb0R0jOoppJb2LSZ66mTJAjbtYpEGqt701emDAT88x6sv9fUsI1tji1KOEHUqewL+cDbP7FyGqEEBUrwII6hwxxs+Jq065pqxW7YEriuNBWaW1RYTeYvV4kjlXjvkQwoOKQgkTiDIDreI0BrScKCeafeg/eCK0SBcZH6ZH9ONdnL1kr5SzFOB/qbpHlhqP2cxv6Sjfz9tJeN/rqn7PO4jRbf+XySz7g1e46ihBZIZr2x0rOBwjD23faCCliF1bBZ0BA2JYOLkztKJs+qr0HNxXbcWzCv/+9akV7CGXF/ICoFPn5aVtNDB/zyLwo5UKfvGuxY1qzZvDW4vb9+ZlpCUfjWB33upQuuUWmFM1nCb/g3UPe9WWHIQcb7BWLy2FJmHCR6zGdIaFwvqbFIxS7jk3zZhSAgJMixeG1Np/zq8TStQ9a1fJ94aCJ/iYTBMarLj+0zHQAW37xt08vu+cE1gn9IyqBBPmsgE6W5WXqlla+6IY1LJlUA4CiiHOVmEFWaODDiOgmBMonO3aQ7RiyANVY0H+KCgpA3h32EOQXOP6NSNNJSvjnq6OyyFJYux5U4mfS5UWj1NINDRlA46dNSz8DUr11EXJkHTUjcw66lgpyMPZ2BEWfpD0W7lGeJkyFGgyIh9Ny2x6349HOQcULDfR0jrMXdRSpqdhD0sDNUvwBsdxamBwiWCAq4q18UzQU1EurhM5eXspecOyEtLzN+Uh7A334hXJKc327lkOFnAPNgGHFkxhKk3kLyKSYi3sdxi+HIDysWAFFNzH2WC/gM6rXMSTwGSeo69q1WcZrvZX5lz3Co1fxSc6iimBfYe1HHj0KFUcymhP2CnhpMRJQaDsUWToLy4s7bZuYtgL5brHAJJmkeyYOVEo6j+FlJhmtpwxQCpxio+WlpwySyrZYVNU7NK3HRuT
 y4Xx1xdq
 I9XO6JUF59RPJNV90smlWo6RdUCzxVnhFNlEXbxKfI7qQX9noOWGyoCWVvONGennxqxBC4XHyL6ouKTwt1xSDAhd/syyuBBClMr7SjdqcsH942AaX9GRRxruR5dZHTRFy1Z4RBchm36XtE5PUqv3OhGPA3NdUuyCbjAio
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - could you fix up the typo below? If a pain I can send a fix-patch
thanks :)

On Sun, Jan 25, 2026 at 09:15:04PM -0800, Suren Baghdasaryan wrote:
> On Fri, Jan 23, 2026 at 12:12 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The possible vma->vm_refcnt values are confusing and vague, explain in
> > detail what these can be in a comment describing the vma->vm_refcnt field
> > and reference this comment in various places that read/write this field.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> One nit, otherwise LGTM:
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  include/linux/mm_types.h  | 42 +++++++++++++++++++++++++++++++++++++--
> >  include/linux/mmap_lock.h |  7 +++++++
> >  mm/mmap_lock.c            |  6 ++++++
> >  3 files changed, 53 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index bdbf17c4f26b..12281a1128c9 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
> >   * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
> >   * vma_start_read() that the reference count should be left alone.
> >   *
> > - * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
> > + * See the comment describing vm_refcnt in vm_area_struct for details as to
> > + * which values the VMA reference count can be.
> >   */
> >  #define VM_REFCNT_EXCLUDE_READERS_BIT  (30)
> >  #define VM_REFCNT_EXCLUDE_READERS_FLAG (1U << VM_REFCNT_EXCLUDE_READERS_BIT)
> > @@ -989,7 +990,44 @@ struct vm_area_struct {
> >         struct vma_numab_state *numab_state;    /* NUMA Balancing state */
> >  #endif
> >  #ifdef CONFIG_PER_VMA_LOCK
> > -       /* Unstable RCU readers are allowed to read this. */
> > +       /*
> > +        * Used to keep track of firstly, whether the VMA is attached, secondly,
> > +        * if attached, how many read locks are taken, and thirdly, if the
> > +        * VM_REFCNT_EXCLUDE_READERS_FLAG is set, whether any read locks held
> > +        * are currently in the process of being excluded.
> > +        *
> > +        * This value can be equal to:
> > +        *
> > +        * 0 - Detached. IMPORTANT: when the refcnt is zero, readers cannot
> > +        * increment it.
> > +        *
> > +        * 1 - Attached and either unlocked or write-locked. Write locks are
> > +        * identified via __is_vma_write_locked() which checks for equality of
> > +        * vma->vm_lock_seq and mm->mm_lock_seq.
> > +        *
> > +        * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikely)
> > +        * write-locked with other threads having temporarily incremented the
> > +        * reference count prior to determining it is write-locked and
> > +        * decrementing it again.
> > +        *
> > +        * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> > +        * __vma_exit_locked() completion which will decrement the reference
> > +        * count to zero. IMPORTANT - at this stage no further readers can
> > +        * increment the reference count. It can only be reduced.
> > +        *
> > +        * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
> > +        * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
> > +        * thread is detaching a VMA and is waiting on a single spurious reader
> > +        * in order to decrement the reference count. IMPORTANT - as above, no
> > +        * further readers can increment the reference count.
> > +        *
> > +        * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
> > +        * write-locking or detaching a VMA is waiting on readers to
> > +        * exit. IMPORTANT - as above, no ruther readers can increment the
>
> s/ruther/further

You're depriving newer kernel people of typo fixup series which is, of course,
why I leave these in patches *ahem* :P

Thanks, hopefully Andrew can fix up trivially!

Cheers, Lorenzo

