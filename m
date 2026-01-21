Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1ECD2629F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 00:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488036B0005; Tue, 20 Jan 2026 19:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A8E6B0088; Tue, 20 Jan 2026 19:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1DF6B0089; Tue, 20 Jan 2026 19:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1633F6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:59:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB8D6D268E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:59:11 +0000 (UTC)
X-FDA: 84354162102.01.01814AD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0891340003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:59:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mbUWk4ue;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c52Y6Amb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768957148; a=rsa-sha256;
	cv=pass;
	b=nw6HLjjlUJMr+acIgrh92lj8LToX5iX9Cf6WNtmFZ9uQRWitdepcLRhpV4EIAfw7AgmFTV
	7oLuofstqmbayNHQa4PL7qGkkFTGiQ62tPqvP3raPoKJStHzDdY5O/lLv7dJQAoX9Kbd1N
	TcmuPRwDkhOWVmVxWfRLQJkE61mbR+4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mbUWk4ue;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c52Y6Amb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768957148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjNnL8lR3YR15Ql1c8QanUwwXFhCpfBxy8KB+phjPho=;
	b=e8VOvoISO9A32mDbnDRLMpXOzfy/0MHixfIwvRz57hObY9y70l7anyGwJd5Gd5HxP9ZZIt
	VHTLMGZYwjg0kEnNlFjG4K+g+R3MklMpsLj3QZvBATxzGPPcIwRjBKo0EYB/tDgM1BEYZV
	ZjlLVHKTRR8PHW/fHbtWGc4tAiPDPhs=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KIV7Lm3031586;
	Wed, 21 Jan 2026 00:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KjNnL8lR3YR15Ql1c8QanUwwXFhCpfBxy8KB+phjPho=; b=
	mbUWk4uezi6GskqgIquHn+XBeEcUJc3T59RqaSxMsKBUG5ivpgbKbk4NfAB9RYp1
	13oOLPUHMOJmWQ/hLyB7tXeTwPrn5crkA+kCtMaGiBabl7iJ/cQj/sJQ4XC+C37f
	i5dsLqmUljo1NyyPJQ78IJ6fQU6XBan8ohPAlXtoSnjizvrkqFxiVNAHZrhvWzn6
	mjgCWzSKUybweGGG8vVV1mtNlpA1LAfXz4SfVR7LyUZUxFe0EubMAeFatIk2XzeT
	BN/E0Ct0/Ti5MP7Q04kXKu03HdfvIlCEdi5WXl1FYr4OKMizBTonfZe2elo6rWK9
	E1shu6MXeJiXyzMZL5VMPQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypvqh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 00:59:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KNgIF7015530;
	Wed, 21 Jan 2026 00:58:59 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vagex7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 00:58:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rxowNKHjZChpP7V0TbimGVdBPlUkfzpCgsPB5tCcanAOMoQ/xXK/0KAH8i3wkqc/dgHBBuhE/bFfVu1Am6ZQA3MqbYFUMUBD6TiIVGsXEMF7ckpQJjYbpVBnuNTMKh+936dSVDvde2+XXDRap1GTDBxkt1zxdqK1qxURja1+tdeF4dXurUjgXX7VhO5B7HuIKoM5/Srq5hzeQxSLXmOUJltW3r3EakBHXGqG8+nfkgtcndxaZkiFH6YVGsPdlEc9T0LgVtiCk4a4QArJvxLYLaBwVZsfsrMe9M6UPU9It3cZLLhR95ZZH49+PC3gM87jWBWRBuAG7V7kRd2v74yIIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KjNnL8lR3YR15Ql1c8QanUwwXFhCpfBxy8KB+phjPho=;
 b=rbCrrqXwzs/1QykO65GMgU0patV9EfdSAMKWV6rjZStJaI3L1AEpfxIMNyKLSRvctTgihGFYuF5hijKC8S1zTD1ejV7BMeXn4sF9v6bB6PALnZlqrMRN2Ej91hqaSQqZ6ZSqHOKEcUgdxL/puCt2ZwQMYl5VXcW64OhnrNHjQX72dJpZvF7cvhy+31XddCcR9v9N3eak06uz9CgEYgvdbCjg9L7ObEm59MUSrt4HVJ6AILqyMThlg+B3Q2Hf2ZqhgNR3X+I8NGqrYyyS5z7XLHKIuSD4zsTvoXKuqghdL9Afz5WF0GVjiSOaW4vPc5PDC/Ok8KQ4H5plR164jvf+lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjNnL8lR3YR15Ql1c8QanUwwXFhCpfBxy8KB+phjPho=;
 b=c52Y6Amb0mWVlg/GgCN3pMsU9uiETV/PwE6Z3jduUozCfFONShajmEw8KGKGrqN/PTsnap81uRlgWPLte824vIt32uJ6nwZC1xfeg0uTZE6ewVMJZw11fFy1MqPgSXYypfp9twH6dLpSYwmLWjHXaoPKOvYc4lEUkkqbmslvZFc=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 DS7PR10MB5165.namprd10.prod.outlook.com (2603:10b6:5:297::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.12; Wed, 21 Jan 2026 00:58:55 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d%5]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 00:58:55 +0000
Date: Wed, 21 Jan 2026 09:58:40 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 11/21] slab: remove SLUB_CPU_PARTIAL
Message-ID: <aXAkwLsGP9rqamKL@hyeyoo>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz>
 <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0081.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::9) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|DS7PR10MB5165:EE_
X-MS-Office365-Filtering-Correlation-Id: ac7d9783-c076-4df2-c010-08de58884015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWdZdWE1cWlmKy9WMG9UNUVyQWY2SkRlUy93dEtsMHc2SXU4TTVBUTdaMHEv?=
 =?utf-8?B?V0dOdHBBY1hWdWxGN2tkRnV2SFM3dTAvcGdVNnpjQ0c5R1BiRll3ZktYYTJU?=
 =?utf-8?B?RmZUTy9wMk1CNTVYd080OFQvRC9iNkZaUWRKeUtkWklyUFYzbTNVb0NTdm5R?=
 =?utf-8?B?d24wWE5kNzRDQVF3blkzN3R6dHg3RGd6Vm10SXdWTUpXMU5ZVFlxZFhjemJ1?=
 =?utf-8?B?K2JMb1huaFZKK0xFcTBQV3BqUk84S0xMUG8zMWtROHZwcnBLcVgrOGVrWktz?=
 =?utf-8?B?c1BHcTVjNFdaQVlJSFdMdENIWkNaNXd3N1I4UzVQL0ttclRSN0M5cUcrZ2FB?=
 =?utf-8?B?d2pnR2kvVHRrelh6MHE4QU1tTHNFUjdVSkF6N2wzck9xbG1naE9IaTNoUTdF?=
 =?utf-8?B?ZlluMTh1RU13SzRxemsrcm5YL3NjbXdOVjB0bXJYY1RmRjhsRzFmbUJ6OHNx?=
 =?utf-8?B?SFNxWEhKT2UrbzZBMldFZk5hR25nem5KZW9BcEZ2YUhJUEhYeS9xQjlGd0pO?=
 =?utf-8?B?L3Rkc0RwdkxRNHM0TEp5anFLZFVDK1hXV1BOWUJMQ2xRYTRSeWxOK3kyd28y?=
 =?utf-8?B?N0xibzROUUJ0eldzUkpBSUFhYVFsQ2IxRUdEL0c2QTdHcVV5MFZqMGloQm1a?=
 =?utf-8?B?OWVMSXdYODhRVHV6QkFUNTdZWnUvSU8xZ3o4TXFGbWszZXl4ZVp5RkZCQUll?=
 =?utf-8?B?M21lQkNsNjhVYmluTUd5VGxYT0YrQ1FsQ3JaZEFGbDVyTjZmOHB4blFLSkF3?=
 =?utf-8?B?ZlVjRUZpQUZTYzkyYnBPbE50MUxRczlqNGdzclJYSlpLTDJpN1J1anZuSnA0?=
 =?utf-8?B?S0lNODhXcEJqVENaYWloNStnMmJqWE9OdzhER1JhTHUwZDUrczMxTXRyQnlP?=
 =?utf-8?B?R3pUTnp6YzBjMm1GcTdWV3ZWeFY5Y3QzRGZBNmlqODIrdEFFa3h0dEs0NGZB?=
 =?utf-8?B?dG9VY3c0eHhOYmw2YVVuajQwLzVFbC9sekxqYmNsc292WUlWcnRUNlgySlpJ?=
 =?utf-8?B?WHRycUtmcXhWa2R3L2VhamcxNWErRFFleXl5WGhGNXA3TTJGUzNKTXVJdnYx?=
 =?utf-8?B?aGdPQkRITDNxKzBQeE5rK0JKNGg1dTUyWDMrTFdFWThlTTFmK2VYcmM5WUhY?=
 =?utf-8?B?QmY1a3JycGRlRW9JY1FEeFpuNVd5Y2IzdFQxTFV3YkphV1g1U0h6QXc3Y3Uv?=
 =?utf-8?B?SFE3TlMwZlZaeDNwbU5DSjd1TGd1S21aTG8vcGtiSjMya2xwR0Y2cDNoeVds?=
 =?utf-8?B?QnZvMHRYSUUxdHpBSFp4M2dNbEdFazFzcmhScWtzdXorbHl3YkV5bkZrVjdE?=
 =?utf-8?B?QUJadXJhQUdZUG8rOE9WMUZNWWJuNWJaU1VXbHJDRW55b2NaSUZSY2tUWnpE?=
 =?utf-8?B?dm5oK2lzT243Qm1jeVRkeThheVVQSFZyRmROTW1Nb2VoeGl3a0RBeFdUbHE4?=
 =?utf-8?B?OVM3amZlZG9EYzhUTzVDeHpCVDYxT0NyNmU5ejN4cHFwZW1pWGJxUDQrS2lI?=
 =?utf-8?B?dnN0TTR5UTRPVnFkS0R0Yng0REt0RTc3dXIxSUxsZnJMZnU5RnVhSXZFVTEw?=
 =?utf-8?B?WkNqNlB3bERyOHJaVUVKZVpXVE95L2Z6OGdrNmNVeVpET3JqR3hRK1F4cjdh?=
 =?utf-8?B?Zks0cjVtNFFOSGR6SFB3MkNVNGcyZ0M4b2RuVzlCWk1YZmt6YjNjWVdnVU9Z?=
 =?utf-8?B?dWZRQmsrdW1BdXFkNDQxK1pxR1FOWkErclVXV1V1b3BucXVNK1dQZUlybjRH?=
 =?utf-8?B?emFUNDBjQUZyV1g0TEdHZzZqWEhZNzdiaStYSVlCdjVrbStTbzNHQk1uNjly?=
 =?utf-8?B?b05RUEJiZ3RXK3pHVkFmNWZPenRtb0V3VmFmeVlQLzJpYXppUkNFeHk5R2Fi?=
 =?utf-8?B?ZHo0bjFsbUQ3aFhoa0JocC9TSGFlZERhMFNweE1rdm1qelVSNTdNQ2NWYXlU?=
 =?utf-8?B?V1VXMStVQVlzL3I5azdkRTBFZmVLd3JaWGVKQWZGd1o2elRyL3lLdGF5UlZk?=
 =?utf-8?B?TlR6QnNKVXRhQ2ZIeTI0OVZRN29aTXNwdlJNY3FUSHYvcWVPTnh6L0pKV0Ns?=
 =?utf-8?B?dzFjSnVJVlBlbEFVV0kybVBFSU4yemtpTUVsajBIaDRoaDVtaEFZM09Sdy8v?=
 =?utf-8?Q?Ug6w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXlOZ252YnZscnB6TW14dE1tY0VCZjB3YjFFOGVVbDlvYUpLSWZCV3hmbDUr?=
 =?utf-8?B?WUhsSi9NVmdOL2tRbXR0eVV5bUZxV3ljUFFZWXNKejVhdlllV3ptM0RScjhn?=
 =?utf-8?B?N2NPMWZXSW00NmJlbXp4cWtXbXJ6WkNFRFpIai9MYW9HRC94STdnR25MTGZN?=
 =?utf-8?B?RkVDQ3FDMExLU3dncWhVNVBJRHJySU5GVWhWcVI0QVlzNnp6OEFBdS9JbTRI?=
 =?utf-8?B?cXViTys1TVNJQ1hSVHNiZ2R0dEdvZERpWFdMRjkvbzBIUmpQL1hZMkdud2Jm?=
 =?utf-8?B?Z09zVk9kZEZFdnRUMXBka3dyR3RkSm1tNVA2bHEyVG5FQVJqc09FcjlUbU4v?=
 =?utf-8?B?YjZ1VHRPNjdmZTFVYWlyTUFMVm9TRGQ0cXRjQmQ5MWVyY1U2UTF0Rjhva21T?=
 =?utf-8?B?bnhCSU5zTnQwOCthWm1WT3YyOXpnSi8vSjJaai9FNTBLT21IVE9keGk1VGpq?=
 =?utf-8?B?RmtPSXVPbHZVSXBOL0M4U3JRVktLRHk4WExTZlRtUk56MGkxYkNMQlhSRms5?=
 =?utf-8?B?S0hOQzJBUmFPU0VGYzVwQnFKVE50R0RhTUwyY3JRNitLdHZTS05MeGpMaklw?=
 =?utf-8?B?T0FXbmdBeG1QYnRsbUxxcE1GZ3RXeFZ2U3dTL2cwTlB6biswTWlDVitqZVh6?=
 =?utf-8?B?RTh1RDgwUzFCTm1rZ2NNbFI3OXMrVWNYZzMycnlQMllnWmlycytIMVMzQmxG?=
 =?utf-8?B?QmhlOGpxb0FMQXR3alF3Vllta2xPU1BDdk9UajltUnpob1hhUVBXVk8wa1JU?=
 =?utf-8?B?Z29UQVFXRGxwZytYTnNFeVltOEtabzl1WEJNVTBmalFtYXByOGhoV2ttdzE1?=
 =?utf-8?B?cGZDT2tVOHdwdU9Mb00vbkdBY2xyUHZ5VXE2TUFLZlRvQ3U1THJZRzZWeGVL?=
 =?utf-8?B?Rit6Z0krbnVPSGNXaXNoc2JxbG9Ta3BtSjlWR1dNZ2NnM0wvVHVkL0N1T1Bm?=
 =?utf-8?B?cmpneGp0Q1RBWnF5Qkx2YmgyUU9CeHJUODdBK3k2UUNKR3R1WmJza0tQMmR6?=
 =?utf-8?B?Y2VETWVmamVuMDU0dUlrb0k1OWltd0tvQ0s0ajgrMHVHMUwxWmVhWHF0M1ZT?=
 =?utf-8?B?OTkwcXJTYlh4YW5IdnU4bms3TUZyWVRDendvUGhZWVY4c0cvMElobXJGd2I5?=
 =?utf-8?B?d1ZBb0RjTzVNYzY3QUxNUit4M1NrNWFMZWt2Y2tXOVR3Y3Y2MmIzRnhwUVRE?=
 =?utf-8?B?emJ6R1YxYWVON1gvRUkrOUwzUFVjSHRTandxQ3J1d3ZZUi9RdjViY3NET0Yy?=
 =?utf-8?B?OUhhUmVNSEZpeVJhVW1kTjVSOUJNdHozQkRRUGJWVUkxV3RhZzdwcjVGU2g4?=
 =?utf-8?B?cGFHWlJ1R200b3ZLSlhDWEpUNnZPZ0hEbHpDUFlHWXhBMFhlSU5acnZubDFp?=
 =?utf-8?B?a215cTJ6aFRUL1phTVdObmNZWk9XaFc2TEdxUFpORWQ3Sjdmci95RHU3SFdS?=
 =?utf-8?B?cGlLUFFsbVJNZ0tuSVVnTVpzVDkvK1QvY3NhalBhdWFZbTBvTG9CMnFxSW1U?=
 =?utf-8?B?Z3FJd1NTNzRodDl1ajBPK2l4VGFpYlhib0QveTRGY2V5MWxDRlpYeTIvY1J3?=
 =?utf-8?B?UXR0NFpKam5PU2cwaXhTczBUUk90cWdZN2tRU0hHZE9VZFNjcENuOHo1WmZI?=
 =?utf-8?B?TXUwc0luNmNkZHpRbmpzODVEVEJ3dlZPL1IvdWlIaHpyTHVYOFh5QXFKU2xm?=
 =?utf-8?B?SXYwNE1BZENkanNaVkFXNHZwZGtYYUZwUHlHNGpTcWtub2lwT0pXMkZFeHgz?=
 =?utf-8?B?N0JudWsxNm9rV2FVeGJram80aTFNL0p0Z2ZycnZvUG4wTTdKdFZwMUZZRU82?=
 =?utf-8?B?KzlBYlprT3NqRDFSRjQzQ096WGx1WVRBc3ZtQ0FYNU8xUnQ2TE1kMkJRYTQ2?=
 =?utf-8?B?VUk2MnlSMGtLeGVOMmdpcFgrS0NKeHRqNFg5Z0hXazRnMzdMWUg4MXNHQ2M2?=
 =?utf-8?B?U1Z1dGl3T1FtNDNGdGFHWkY2bWhQWDd0U0x3NG9ZcXBKTzdZOHJ2QVVabzZw?=
 =?utf-8?B?UUJqdURhd2pTbEJUZ0tETFhYQjFpWkp0NUR0Qjh2dFFITjN6anNXMVN5UGk1?=
 =?utf-8?B?cFJsSEJGT3pBNUI2TWkxSndsOFVmTU13QnRGV1VEOENtQVY1TVkwQUpES0xG?=
 =?utf-8?B?bUpBK3ZuWjIvOThJL2Z1ZXpsdnlGV0FIcTZWUWViVkV2MUNPM05sVmc4YVVW?=
 =?utf-8?B?bjhWVVJEOEVNL0V2RmhLM3JsUEI4WEt0anhBT1pCbERiQmRpUmwxelV6R29M?=
 =?utf-8?B?NXg2Q1pOT3F3QXlTcUZBQXhLMDJZRG1zSXE5bmxEMjNoeEtQRnpvR25jNEJi?=
 =?utf-8?B?M1hzWkh0YXA5eDJwY3Fuc2RnUGc5Y3pXSFA4eElhcXllZFJTQ2UwQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ak8ak22IX4IzgkgrPdBQC6PUnYrUk9JxBwi9waFoqo+cAzl/Qe4wLMpQ9jSr77vyOgmrWpVYK32IjIgIBuB6Xtzk25lNekMCCGTNFExXmXH+44A6paVlV/rs+ur6drOSSQOi5SANExrMjFXxkqNTbK1QZYfeFpjv3nJifvAuFU3MLIXMNMMLzfttpynT0EdUg8VvyxcLowVtJkEpgWQRcn/H45ocGUDRl62ONTIGk3uAtMnPGEFTs3aH0WA4w2rHkEw7lcv/+QEmMGXZ7VawEEVnhodOHHAZZIdJZViGX5U6O9NZ1kXmldqf6DuyuXpLZkxL7dymGBzt69EzuyKL02eGX9bpyAKUefKXdf18GuSrh9Ux30jxmgdocBbDhjhQoSHqMGzbEJ3zycrbMmja+TDfejG7lCEF2XW/QDqRAfcSJEChWrNtvz1G6mx18hivy8u2uP3zZxNJIadoi7Ts7Ua6VoQPLciEwjWhV95To5Geh4481S/I5XECfPJoF7GB/37fXsfoAjdqDfqP6fGFQayl0b/L3A4o4Y2ZlOYjU0Ly4VEDo886lSLH0nhZgknsdFzHRzRHc42WbYdpFk4fHBadE6y5jnjafmHC0Rz6MFg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7d9783-c076-4df2-c010-08de58884015
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:58:55.0060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJzdtgXI1Ko2w2hsbTT+XjpfvUwIPxGVKRva7AhhJkPyzW2e8CyBib/KSUYYKXLI27T4B2l490Hqq7M6I/y8oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5165
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_06,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210006
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDAwNiBTYWx0ZWRfX7g1k214FbtIf
 wWFTw+mkXQkoAcIm8z5kfaS/4Uoxu1MZFRJBWR6nJ+yrID03+5wq5YOAkNH8fCQuS85YL+tI/D6
 Pc02kiqSFTK+jZ3qvb5enPm5TI2yrAXA+EPVvTJP5gJPExwTonGa6R82J5EstRj+38pY2zXBs4v
 syRhcgy+tEj1CYNP+kTVLuGaAJY6YoEFmwz3elc5TQ3SNj4mCKS5gw5U2XFr/HOG3W66Kguxuu5
 mi7gIufA3czvsHCiH+I9OLQ+5K7lqdpcDRDKqIItrxBXm0xJfYljBg1T2GsDKqf4LKyssS+aCqu
 YZbugUEvCDdnD30xax++PQD+/RhGL/pBU+Sg/6JLNtkpCO8O1n6C3Fqii/u690Y8itjC85O3m7z
 VqCIz/qQW0poRooVL3JzpN5+tnTrTtLsrEzF03LiN9bj8lMEy2zh8iS2q0+wbcdn8v6k2t4Bjes
 2shWsXTB7Ep67xc13+w==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=697024d4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ilIx5R93HM07YhThfGoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: rUyndBHi8Qq4LtpzV-O4pLu98NGVmqb8
X-Proofpoint-GUID: rUyndBHi8Qq4LtpzV-O4pLu98NGVmqb8
X-Rspam-User: 
X-Stat-Signature: 6r7qjfgi88noyhwaobw56uesoxgr1b7h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0891340003
X-HE-Tag: 1768957147-887318
X-HE-Meta: U2FsdGVkX18L8xGQ5qLUQVSe5zCTBo2CtXXKpeMgWLifsO7eR84Z0CXiQlSEDRMD5lFcdDmiRCPSxM7fTE8v+lrPgJ1cydQCgOyzl4OG5nhm/QdDggqUpSAG3IlLO7Pu5J0lfgp+2LOs/oG1M5Grg+ZM8RHRoa23G1Iwfxf2xXZZ/zQFpzMNU8GO+1RlvZJfPtBgSyvh3Y7lET3NRzkzqiGdmCoxKSRY+ZwKHADM6Rmjs9TOOnnK4tQjfrXheJbYTvwbw/yx7NPIYsZDOONSC1+IGpFPW1Gd7qEiVF6ak75wgc1amo4WnrarfAjvW17zIw3CkXWQZ3CdZERbcUFXVd9M2MwGS9ff6NliGbjF0sb2RnluI4mBOGw3yWMjC3Pcc8CzBaM33F1spx7hChx3eFnVIKWMDkmWCo8Y2mvmRJXkEpKXqgWW/QWZlaCiSS6rZuJsTAEqJHW/eBEGa6/kHG5f4Tw5DPt9ms5WSqoPgJpiWFd+AGgTliyLhAoDqNttsAmqk+pS3m/EmT5MDSMuYx3ZK5als/wT7dODJVlB2ipY1igaGHKZT/0lG7qhORD1u/tn3SmDzyodAz3lm38ISo6f1MqEf52s9/A8e8ztPljajqbax7GB+OIWVxx7FzROyxtK9wBF9SiMhB9dx8vl1HMQioDsKkhWFeM3wPmG8QzEuNy3mXcNZLB9ZNlmzGAe8z7RTlxkXJnZ7RVxaGp+SsiSs2iX+6mTzYEzo6Qk/C7vgnAOEYTYLD7HLSxua4cD4m3s12WqPcdMu1PCMgYilJrNaFj8t/xyeJiAD88ZrRIm6bcyCiokGXDlZtLhArSL42GugIc/ByeBQef+zo9dJwrLnprbWgnWXV7D50WFKGKLyXJ0aEx88WZ1TOAZiwLh5hQmyNOZElwIKI/9E1JdjW+sVWO7caVBXqlA95mb55uiDRfCuTjuZFOK2hpfiK3kb+BPdvkSSvWzWE42iuT
 i9ZmC95H
 +nCcJn/qQOBxpJlnPmS53p9PH8brhmgCCYAHXJeXUkRUd1jxNn5PoxKsiyghOk5s7jtrdP8O6jlfH5ed4B6kG63ZR8H7/Qjush6ngdhm6gjSh2tcYEbSrPfJkTvaYIKs6JIVJ6F2JPZUMSyk2+p1f/k/Rd0ajGWQfNFohh0zLAe2aaB2B/FZKkxK3zhVUbo0nw0eMJoNb63VEeb0/pfp/yKLPTn48knFcbvxhL6orRh7mn9NKWz1UZgH5iZvFJEqxmDnf1VJnyJnflFsnttMWlGHJMI/sEFiljLnuudTZTjMrwkETMAp8A6M+AA539Fi7eSI7Rsu6mpPNtpJWqQPlOxyKSkdyBILexuu+xVG3WOA0Ks4Okk8VoglVIqkwQsy82pNtW0tl3y9Oh04L2fqgSBhpb0VbxDAG/X3ARpnKl90TLkGa1rUeU/y48rKdZQ3o3xtHDsAsOBbiieCnAGal49FImk5hWoS7fNQZHdqnXyAbCH/CCoSWvAswkNnFa3bYWoCqcp2XQHcg4+QRpe+xMJH3A3LuV66c9qwqXL5kjR1Judi6KwLXKUuzanH0bYyquNrx/pEizaNWPB3paBd1pgzO0+MB4i2rT9h7czT3envOVEb3s6eeNoDM8LKCQwNe0FG7TjfDsdkY0vWu5htDqZshWqyzXYcPIXy0hcNwiIqVm2p1WGPV4iMZrqOleR5CF+H7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:25:27PM +0000, Suren Baghdasaryan wrote:
> On Fri, Jan 16, 2026 at 2:40 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> > @@ -5744,10 +5553,9 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
> >
> >         /*
> >          * Objects left in the slab. If it was not on the partial list before
> > -        * then add it. This can only happen when cache has no per cpu partial
> > -        * list otherwise we would have put it there.
> > +        * then add it.
> >          */
> > -       if (!IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && unlikely(was_full)) {
> > +       if (unlikely(was_full)) {
> 
> This is not really related to your change but I wonder why we check
> for was_full to detect that the slab was not on partial list instead
> of checking !on_node_partial... They might be equivalent at this point
> but it's still a bit confusing.

If we only know that a slab is not on the partial list, we cannot
manipulate its list because it may be on a linked list that cannot
handle list manipulation outside function
(e.g., pc.slabs in __refill_objects()).

If it's not on the partial list, we can safely manipulate the list
only when we know it was full. It's safe because full slabs are not
supposed to be on any list (except for debug caches, where frees are
done via free_to_partial_list()).

-- 
Cheers,
Harry / Hyeonggon

