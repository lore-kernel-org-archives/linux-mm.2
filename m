Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC59D74EDE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2636B04FA; Fri, 23 Jan 2026 10:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0526B04FC; Fri, 23 Jan 2026 10:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184EB6B04FD; Fri, 23 Jan 2026 10:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02DED6B04FA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:11:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC5F213A508
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:11:24 +0000 (UTC)
X-FDA: 84363567288.23.C1D73DD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2BA2014000E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:11:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V5kkJ9fT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YbapJKnh;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769181081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vfl+jsXZhaZKui2LAUrBpxUYcRWSv9Ev5Ed3vCHxN8=;
	b=lPgIoQ4Io1+T6dywtV2liKx1CJ4G53YCCpEVFo1cpFxUK4LTK01crly/eqjgEArD6u6Yh+
	YgcXEtPvciH8y9NRvkEWBDgZwlG+9VfDK4Vb4zqkdES2UifHwOyrEMGQ7ROegWnrmo5Zkp
	Kfx4EhejYRnA9bBwy0QPHcx3GcNi8Z8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V5kkJ9fT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YbapJKnh;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769181081; a=rsa-sha256;
	cv=pass;
	b=Ie7H58W7sbMJg4KDDC8HC4AtKPQdtsfYMmh+IhaBosJXjvvgarFUt9xGn1Y5QExu7iDlj3
	VLWKz618kDD84Vp+cgDhu05FO2l6GaBWfwQW9SiHr0n6mEH/VSSdcC89xUTbrVJjh/JKdF
	nioV9AkpNzWLXlTV4+kMSb9OpaR2XJw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N3EEXO2401286;
	Fri, 23 Jan 2026 15:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8vfl+jsXZhaZKui2LAUrBpxUYcRWSv9Ev5Ed3vCHxN8=; b=
	V5kkJ9fTJNzCHCBGIPPhzZ8DYzP9BNJaeLKw8QK39mqIM12WUDkxoDGRI/yo9Zi1
	qKsD/jSUTTr42Jsfxa2C95f0GznLIgDeLbfTmjdnbDEiIN29F2hOHf1C6q+gJYJn
	T3DJRE/e0OZuysDv0f8922yj3jizftaqVpNYfjs/uKiLBc6BKcYN9lJe5hA8/3Qw
	8tEwxxADuHwuCizuJawZT/c+9zOqh1iN4L2l25W0lv1hpIwd2SK5hPrjHPCKLOw7
	UDWhaOLvipffIsyjGZ7x4qSl2lJ2pd3qUAPV3InC0N8vKuwHGweX724FA8yYFjZZ
	2qfqQFs4rjdhc5dqnsaHoA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qjpfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:11:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NF3mwu032913;
	Fri, 23 Jan 2026 15:11:11 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012036.outbound.protection.outlook.com [40.107.200.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4buyvexxud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:11:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ukXKBJ/xpximxuOnd5i9qCWleaBRLCmYHSs/9VGuru+CMaIqm6JoR71Kr7WPmEZ4CyoXA6qLF1Pgqh7ogYkUu/6bKno42pwaUxh0Hv2t2Y+r6dqJdkvL0l2UgHFj7lrEI5iH5EN/P8Nwf4nX1Mcf+1GkD5ZAhzAUJ2dHOw1INTuejfUc4EpGmGI6y8M+PLu0fFKEeKT+RW8JNnXZFFUZLXWPpfM9Blxg8nIb/LtHbAo48Bkeq2HHIvzg4o2+HrJ5JvqZHHNH2lELFXzkJqQ2wh+cG+ZPcyKhnRiJ3hoyzek9haK5xWCPRAHT9xxU1RikCI/7NVVon2pvAHE0CEMazQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vfl+jsXZhaZKui2LAUrBpxUYcRWSv9Ev5Ed3vCHxN8=;
 b=IkvTitAf7FcJlz5hxrz60x8nKucfj2yazVwpEcM1onrTBLQbImj5llplzbilj/jVHpyZfthVQo5s3wRHXK0hebjU8vQZsAevaVCDvLgwMFJq6UPfQbOhJOtnSfN8Imct0p85sHKp2uhcsunwkTMyM2YpIxQd2IdQ91OirDj+ISPUELQ1h/u8L5qB8R3NSYIBCf13kPCY+pp2GHAUMlyfUZxYC9uxuhjshAqJ2We5YuvUwEJOeMGO53ePkEYTJ3kv4OX3+y+xPR0nxzlPig47fEpcsS9XnaM5ixswBOhbbRYDDoM0os0kmv6azqiBROuKD0c4CLad5QoMLdO5LwlO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vfl+jsXZhaZKui2LAUrBpxUYcRWSv9Ev5Ed3vCHxN8=;
 b=YbapJKnhSRBBwiPfZrqM/8lQMnp/tV1fXLCdnIcoNN95tOT97gcphlG80Cp5NYKbqoYYCApWoicFLlTYGo0MJuSJNlPcDsKUfxRrKtu1HxMmF0nQ+fqqUxPIuDTlSOiOluwsJ+xt3cw5O4MHDhsygCoUyqulVKbUCf7zShEW/xY=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CY8PR10MB7367.namprd10.prod.outlook.com (2603:10b6:930:7a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 15:11:03 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 15:11:03 +0000
Date: Fri, 23 Jan 2026 15:11:06 +0000
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
Subject: Re: [PATCH RESEND v3 05/10] mm/vma: de-duplicate
 __vma_enter_locked() error path
Message-ID: <54cfdeef-23be-4d7e-a4ab-2db53952fe65@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <2611b2b6957b7aef587e9ae62712a888159dce60.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEv+aag1s2Aa=moCueyfB38hmSJFJ4ieZwthRdsKZEhWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEv+aag1s2Aa=moCueyfB38hmSJFJ4ieZwthRdsKZEhWA@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0489.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CY8PR10MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: cf934cbf-01c1-414f-bf65-08de5a919fd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXFHTXczTSttTkxCOUxjVTdxdGNzUmVUclBmcVdFblBaako0SktLYm5uaG8r?=
 =?utf-8?B?aDVnSVZmSnFHeStLbXF2TW9haFk0RU9PTWlHa2trS202SHZSV21BaXY1SmdK?=
 =?utf-8?B?WWlyempMc0FpNGpGdkMrbG81T1NjSXpxc2d4blhWOVdnS0ZuWHg3dWdSRUMr?=
 =?utf-8?B?VmxXSEovVEtaeGduZUFSVHhaZnN2SUY3bmJsMkVnYmhaTlo1VVQrU0pGQ0xV?=
 =?utf-8?B?bkJHUHRwL2lmYVJWT2NUSnZNa1k3dkNPT0ZrZDlseWdZbmw1dGpwWHVYYXNE?=
 =?utf-8?B?YzBnWXpMU3R1VGhML0g0dGI1ZUF6Y0pmWjRKZzJGTVlTRE4rTHgvdjVUb2lR?=
 =?utf-8?B?MDUzdDhtK05OYnRjYzVPM09BbC9RMXl6TzYyMU1kcE1nNTNNOWVzYy9Ibi9D?=
 =?utf-8?B?WWFPZWpWRUkvSHVsTWg3bmk1YlB0VmdVazRtVUthQlk2YVlkVlJFTUtDd1Ro?=
 =?utf-8?B?SmRWZE5UT3l3SEtBWmduWXNRUjlOYXVKeHM4Z1VQQW8xRWFicUhGUEJTSy8w?=
 =?utf-8?B?WjF0SXczL2tJdEMzY1YwazM4ZWFSNVRuNC9qMzB3NTVyVkFaK1lsSWZvZm5N?=
 =?utf-8?B?UW1BZVNaKzNDTlJKL3dwS3AxTXZyZDdIL1QzMHZpZDdwUUVPVVZid2t0ek9q?=
 =?utf-8?B?SkNua3NZNFFUNk1qelJ4dkM1Wk54NWR5ZUQ2TENMam1iUEpQWk1QVk5EeGd3?=
 =?utf-8?B?TXNKMVd1UGdNWFRkMG4vVkMzUW1RRGdiZWtaUTVsbXM3RXhWZ3FGLzFwSlZJ?=
 =?utf-8?B?Q0NaclR4dDIvTkVqRkt5NU5ZZkJjbEJORXU2WTZBV0J2cGF6NWNCWkJIY0dV?=
 =?utf-8?B?VExNVEsvckFoZUdDZ2JPU1FPUkFXSjdSY0lQTXlaZ1FMTzNpWjNuKzNqeEZr?=
 =?utf-8?B?YW9jTFE2V3BtVVMwZFUxUS92d21OL1cxNktCNy9URG9kaGxESEZyWVdHZHYv?=
 =?utf-8?B?QnBHSzFPa0xENGxGcW5pUlM0aSsvZ0NWditlaWoyMDV2YnRTREd4SWNpWU1W?=
 =?utf-8?B?VUtraC8vWUFRcExrSHRQRTdQOS85M0NJR2sxMnZvZFVJSGNRY0lRWXozKzBH?=
 =?utf-8?B?VHZhZm1BKzNMb1Mvbit6aEJLdVhQS0RRWElCMkp2TDM2Y1BxdFcxRmNFWWRi?=
 =?utf-8?B?NVUrc3l3cjdJKzAxekRWQTRGS01pNUNVOHg3SXRvcHV5T3gxYzk4NFRySDBY?=
 =?utf-8?B?aGZIeExjNTVoSWhuUEY3QmE0eGYzMTUzandKTHlldGhhVm11ZWxNTW8wKzd3?=
 =?utf-8?B?UG5qR3UxZkxtdGtEQmZCME1HZlJGNXNYSUpPaERLa0U3UkNQR2lJTkFFbzJ3?=
 =?utf-8?B?Z2hSNVNSV1hZcXhxOXlPRzYwUVRoaytjOHFzUmQ2ZVVpODJGN2VlYmpMdjh1?=
 =?utf-8?B?RFFsbDdiYU9HdFg5S2xWcGorUTJSTkVCajBWR1J5bGVUV0M2a29ibnFQaUVY?=
 =?utf-8?B?RlVRWlNHYzJybHVZU1VGOVIrcGtVZnVMQkNldU5mRFRTc1p3OU53azErYkZx?=
 =?utf-8?B?TkduM3phbzBMVmlVVWlTSjVva0pURVhtSHIrZVVybkdJaDhMUVhqQjdZbk9r?=
 =?utf-8?B?c0Yvd2gvTmwzYkMwYTMrdWRtajNNNUNBM0hMSTMwdkpCRktHb2JMbWpMUkFl?=
 =?utf-8?B?RE5UNWl6RitjSkh4R0ZmMEFMcmUrQ3hHdDZ3QldvWmZaWHQ0TC9PbXJsVDdq?=
 =?utf-8?B?VkMyaHYrVzlKQWkyR2R1Wk5kd3VNSFd4b0hCOVpDK29CL3lXcW5sQWN4eHNN?=
 =?utf-8?B?WklqellIbEJrSkY1dmRXNkZHeTFkV0RvcjFpWXpPdHAweUVwYU9ScTh3OUdv?=
 =?utf-8?B?UUUzYTNDdlM2MGJWUlAyblJVVUFFaHVYNTFrUjlhMG9vSmpleGJnRUY4SDdV?=
 =?utf-8?B?dUZtVUhBMXlsdXUrSUhIVm82MjZqR2QveDI0b0ZSMi80c242VGcrd2tGNjdY?=
 =?utf-8?B?MlVveU96M3NnbjRJVHhOSG1JQmJrN3E1NXVRdWZtQmRBMHlRVmdOcFVpNG1G?=
 =?utf-8?B?WkMrQWh5MTN4RjROdjEySm9ZNlZPdHBJVFBNTDBpVlltTjVNQVBoeE9PYlB6?=
 =?utf-8?B?bWRrWkxHa1VOSjZsV0xoZVpjcHVicjREdW5ZeW1CUnpua0laM0diNWd3THg2?=
 =?utf-8?Q?dhDI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXpsRlJXZGhDckF3aEtiYWdwY3E1WDQ2NDNDazRDK25DT0hndk1oaS9lSHhO?=
 =?utf-8?B?SjVtVTFuUllKNkcvT0x3QjBHMDlYUEFZaXZ4RWZGVzc5aittbWhCQ0wzZDU2?=
 =?utf-8?B?eXBqQmVJc2lPaW9ZVkdVeGx4RzBFdFlWK1B1RGZsVXo0R21iNjlmMkJYdXVt?=
 =?utf-8?B?Qm1JM3FBQkw4SnlPRGJOSXJIRWNaRzdFbFdJaWE5OUNNNzU2bGk3RHNnbGNi?=
 =?utf-8?B?dlc3L3JxSUw2Zy9RZnAxVWFabFZiZEVKQm1SVW92dWM3OWJMTWd6a0hNc1g1?=
 =?utf-8?B?WCtQcXVpbGFkRjdLTlRyZjZMTEZFNXVxVXpGbmk3Q2wwQzFrV0FZQVU0WFJ6?=
 =?utf-8?B?V3dKS2IvMGZteDQ5YWh4MWErdlZ6Q0dTdmJJTjBnWFpUeWJvVTQyQzR2OWpO?=
 =?utf-8?B?S3lWbFQzMEt3UW9NMWdyeDBSTzU0RnFjL2dvdE9CN3UwQ2NtUjA1a2YvMUZY?=
 =?utf-8?B?aWFneTl4cWVyNEQxRGxSNWdvS2E3NkJ4Q1JNQ1hyVEpOTmp2SStDc1VwQ1JS?=
 =?utf-8?B?amR1RFdHdW1yT0FQbXdyazRpN3ZWZklPV1hyenpoN0tsN3hNSkdwWmFlU2Nq?=
 =?utf-8?B?SlJKVlhZTTVBV29WdDhCRXFEMWlaaHNnRlRSMDY2RWxaYy9oM0E4bVltMURw?=
 =?utf-8?B?Z2VuOTFjZVVkdFlrUFVPa2xnVkpVZWdoSlpYU00vbE1zazA2TndWVE9BRU5D?=
 =?utf-8?B?blFZZFZDZlhSYTh4dzJ4L0VCOEZrekljMUJyM29STG45c2IzKzFpSWpqOEFi?=
 =?utf-8?B?dHJJbW5TQjltU08wbmNLdm5CbG5DWHVaL1V6MXFzK2p4MFZQMC9EdGF2Tm9r?=
 =?utf-8?B?NUUydHJiMGUxQ2hrY244VTFocmJTZjRTbmdTZ3dMaVA4VENWWmZpem44dWNt?=
 =?utf-8?B?TW9JSGpGMU5HcFRncWZGK1RKd0hqVUpYY244c1ZsalNyT1dEOFpRRllGQ2lL?=
 =?utf-8?B?WlBhNmVpb1NReitVNWYyUlcrci90WnB1Q05VUWs0K3RWMU5jY05IVVQ4N1BT?=
 =?utf-8?B?YjhLTHNlWDNEeGtUYVdLQ1Z0YnhnK2xIS0xwdVF4czEyOUJwS082T2lFdXor?=
 =?utf-8?B?ZU5KYWNwZGJoUHpXaDhQeHhQRXM1NStnTEpUMndkRXZjVXFDaW9HaVM4dHNK?=
 =?utf-8?B?ZUUxejlwbndFS3VPM2NaNjRla2VmT0FuUk13N2dPUzZCUHNsenJ4WGlzRnVq?=
 =?utf-8?B?WG5WbVVoem5Sa0o4N1RhVXlwTjFUZm16aThkUzE5eWx6QzAwMlBBL0F2Ukd2?=
 =?utf-8?B?YjhkZTRGNGlWYVhzRkFySVc5T3pnMXVnTzVBTEN0Q2RweDFtV2RxcnhXbDVo?=
 =?utf-8?B?UUY2Q1BUNENkU3JTdzlMQktUdDhNYjcvckRnZE5sQU03Z2RVOHU0c0NjV2JK?=
 =?utf-8?B?MXJLNzVBazBTMjY3cXpNQUpydk1Gckx3WUcrNjZrMmdTWXZIRWF3aU5jV3Fx?=
 =?utf-8?B?RU1MMjM5ZVBCaUs3R1I2N0ZrQVJWS29UZEJRN1JKa1I3R1pGZ0ErNnFKSkpm?=
 =?utf-8?B?WUdOM3FZNXNSRFRDZk9RZ1grbnpIU241enlnN1JycTBVbE1UYkVUZ2pQLzh0?=
 =?utf-8?B?bTU0ZXVZR0dZYmxJbHlmK2pRMHg3Y0VabFlOVUZzSy9GcVE2clI5QlRKcFRp?=
 =?utf-8?B?UW5PVnQyQzVLVk96UFVUckdXKzFER01EUC9UMWpCQ3E4eHp2NGN0Mm9wTlBM?=
 =?utf-8?B?M3VRVnFLZnVFNHF1dFUxRW5lQmpQTEswMUkrMlB4UWg5TUpNU0ljbDQwcEF4?=
 =?utf-8?B?MU9CVjRtYlIzMit0VHFoWWs2SmdWVEk3MTZHbWVFaWtUeHFKeFlTSFB0UU9P?=
 =?utf-8?B?Sk92dVRaRk15QTRjMy9reFZXNVZSeDYvRTlRdUFWUWZGbFQxU3JubFM5RVYr?=
 =?utf-8?B?UWQzQWFGUXF0TE54VXVEMGg0VXZKSm1UczF3OVlPNkFmdEo1QUpsNkxMUW10?=
 =?utf-8?B?TjBqUkRoeWlOKzJQZWZ4REtqRHVlTVFhUGxjU29tbGtXN0JkOFVkdjVCV0dR?=
 =?utf-8?B?THhmUjZ6K3VOM0p3U1A3cGVTcEJCNDJ2d1FHQitFcUt3MjEwQllTTTduWjND?=
 =?utf-8?B?ZjlIcnNLblU4aW84Q2tUTHRET2FKWTlBbHFPb0lGZXRQOXF4QmlwYkZKcUo4?=
 =?utf-8?B?eWR0aSsyeStpZ0NWOU9XQ0FoTUl3eW15dW01MTNURWJ3N3NMWHVtVXQxWHFv?=
 =?utf-8?B?M1pxWmVYR296bmRHUlpVQSs1dWExQkFyS0RzcUxoOXR6eHo2QS9zN05JaXhr?=
 =?utf-8?B?UjJZOVBPK1Q5ZUxVRk41Z3IwVWVtYUtLTGp6Qll2aWRMMWI0bXVqOXR3eW1s?=
 =?utf-8?B?Sys5NmdkMXJ1bFdaT3g3NmlyVjdnVEtzckpjWmFCLzdlR1dQS2M1MVpPdjJp?=
 =?utf-8?Q?6M5zYeLtVeCX5kMU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HKHKkJn+f+fVgZwOgjw6Oj+nrvfeNQ2Jpz5Cqe6M/62+rCDlOueFsC2LdoSIlWfmHnGxQv0jTdFQOk6NgZ38Nagie3V/Q1e2tuHrYWqWToFsANtUm9M3bpM4+Y9jNRr8AHYIN2XosBg5Ac8I+x7ieCpZum3YLiVIGLA9ffSauFIMull0JOj+e/SX4FKai+0eV5x44earMRp5mbKhduwEo8zCJVaMwkzm5v1bT/IVumQmOZOpaTmU5XLJ/FMTv/Lfsn87S7Vm88fWxJczJ6jVw/t9dwwqPJJx21q80wRnHds6E2qZjEO9Kn5NPyVWnW1zQcBCAj4GQXuvsiy/pztKn66tO1JqV0RXYHjrVJ+y0LrZLyPoJ1L3n/K2KmaWMAeYjQjvMYipywRiCDdRZT7G6LaDa4pj0X4HYEGow5DKRam9pWWgirUs3Rbt0oYsSNsSUM+5ABg8LW3/mzJzxup5yFoMEa/97ZsXWAi1FkoLF5sFFRgBMMFcjmfuDQ0QVfblj366Ye7Yf0d2g0R+TLoyQ3SQ8dm+Q31INZ2trX03KW7WI8MS2NhlDJ3/QCv9CgqJmmia+C1NQdZ2YxAtnoUrL3RKBcl8jVZLYSHXe6vep/g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf934cbf-01c1-414f-bf65-08de5a919fd9
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 15:11:03.3079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrWWFAL2sb+0Nz9pLDOWsj2B+J2Ivw/oD+4VJO5aQxHiQzfgOe9w+ETDx+J+4rXWMnRrpRJK/9uOptdu5DfHt/hSGmpWR5tz7pd9fN6faVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7367
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=961 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230118
X-Proofpoint-GUID: XteJnpijX7BBYRiMXsrXKiWWJzq-Saxi
X-Proofpoint-ORIG-GUID: XteJnpijX7BBYRiMXsrXKiWWJzq-Saxi
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69738f90 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=RSkgPbYOZ3NyYxxeYKgA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExOCBTYWx0ZWRfX6RKT6uSfgMSA
 AyO27iqLIdmDQzaEM3FtYzTXtBbpHzLZHmVkhsNsA8mdenEYZ0SLUSquQj+URxg9dFqtV1P/rf7
 O61bsauOVqNp5d4UIX1q/kOiIitz7yk6nk9h5qagf6hBqCO+gdl9s2Xk6O1ajhQsytYni6XzJJF
 rQvEeold6SDUa54NrN8euB/7cWY9vMQP0nfl/VVoyBmIRZ9BEHN4Zs1+Mt0vLalzT0grcT/MJ3C
 HnzEcXcc3k88jId9QRkoNmxEo75glnU0xR0d6Splv6F+aSd/ir9Pqia6ybAxubM55WOowQPgEvd
 QTNvmYJr2/mzJJ57eVT9aYVLr4jt78P+1xm0NP5SSwbsm0R+3FC9vxUVuoWrUdtwgoFL5VOVoSt
 Bnl4JMRmQ8c+joZSS75R8cgytzPp/65cRTbOfdgh3oyfOeV59gJhBy8y3emx3Yk3XSDGRis1rcE
 G+tiUEND86mtiNuU2WA==
X-Rspamd-Server: rspam11
X-Stat-Signature: ky5do46o4jz69q4izjyyfnmnjxwhyxpe
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BA2014000E
X-HE-Tag: 1769181080-711166
X-HE-Meta: U2FsdGVkX1+v4AKyaDwBGpA3NdFNiGbIbbSUdbBeb7GtRsx3vrb5BPpjCsFpJBoMMDG/St3nlZz16qR1Sp4Nv9GwlxwrJX9ZTRPORbll/j3W5x6IBo2H3UYfrb64hkT/DOwkb+O5u0pkPvnTz0pHyNOKRkjAYnDCWHSoOk1rTqKa76P1FFLVSMb4GfPVVsNmDVZClFJ+OIXElz84atgPB4pC1XSPLr8UdB7Gj/S2fEYStVV9wlaIYpvaaVZUzOKufHquITWahiUwZ/4hNbB3dfNhzflEQ5l9PG+GsbguwJuMBzHhn6aQ9iLZsNC2UaDOlnvmPY/KTum/bPpLEZHrwcnrshdUHXNCvo3kJXEFms0ZngbGdXIBUk+PqOb40HBmiB4gO7dXrBbhp2VZPH4QtRu1huqUWEX2N4spcdET8epH33MfbvgR1jvIpRJEu6cathXkG05RGrovaRhOMI8EK1hwoMLpsXvrwAc1g0Nj7hNtbUCtStGM1yagAy7Ysk6u6OwrSViDxqQU6ibwBIjBPHvmP65Zrih4EEPz9isDY4c2s9eAIEtwn9kOcH2nsgBVdylXG7QPMMtkgQxT0l/tMjJ+NaQbHCSie0H0hlFII8p+iCk6oKepIrTYtEGADqNJ3dJo7Mb2PH5+mKPKdjVZJ6xc5wbyBkGcKEnaRYRZ/ApiPHOIRrTUSDVdqRu8bdRr/1kuqfaNcGjgHpx5W0X0+1UTE2F1mEW8nN0BIiRTBfPzBtv3LirNEJZ+SWg0PXlipKs77t9mUygzcbBsKcSvqKP1o1gT4BsFUBdhWANyZBK2M9Yi33OlbKDue8K0BMa/7Dj40knLl3BUfhZlFuuk2PwyANUUXq8Zbn17RceKqpmq+k2X1NR544y2aJ27q9gq1kA1dGNEvTtlDCtJGvdIJErICyoix2lImvLyrvQTXXo1JcYtYj/w5aJKXVykIHqO90wzuWMKXIdPdhGMTwc
 dkbI+Yrr
 E3dw+ECQ8Mn225veqX9zKvQoja858RgV9huDI3OfuQQzHC/TvKkiACpXVsOiqYQt6znBKfe2CWUABjnC1vFCibBaEsXKohi6hpO5svdMvfDkZWxcL/tE/D6D1HcLsgG3fuTiFt5U2yFLicbvqKlAxvfxP98h1y8VSNO1hpGC2aTz6B73OQicSsi9Sqvg0+SNFjqsChU6hHWRLmcAyRZD+MFrBoy/WpbRjW9PRYtqRQpHdfy44pFlO+QMHHDOdg1GDHNVEtXnz2eBsIU6wAzCWCwifDL6VpQ1hSvix23Ce8SDVoBL6w5Jn/n3TMVhaN/rBd3/+3eqQxedO8mUJXVKxAtBFqS22b8NIB2YRD1p2dgpsWJuBbIhSzAG0T/ni7vQ4ef4UgetokdStZsss8Ru77WE44j3MgrQMyGCPE87TRRLB+biglF2o+AUq5dXMathNlr7vRQ/cIbdB1qdRbCn7RXvm+nYUWDWufyD4FucdevyPd228E+wrMXWthLHQuZYePCmhIPtmW6xqMVaW8mlTVSOnuKWgzd3LEAtK1zsF6Po1YnklCbcTKj6YWoLI5hMNjBo9eETum23xUcbDm+LS/fsPuOLgGhkYTmrNBUHyOmblP33zqoxA+3grqixVIZ4Q4PexJOGovKb0hL3JEn+i7Nc0sa1kil8DWrBB2C3gq252DFE8wMk54Afw71DytNVDLpLMtxjUxZwOVdi/+38bPSkgB3E72jJXBWDYSah5n5x9Fc3MleE0FkqY2zhX+2OCHwGrC0unKzAEkaRruZ2/LgCBmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 11:39:34AM -0800, Suren Baghdasaryan wrote:
> On Thu, Jan 22, 2026 at 5:02 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > We're doing precisely the same thing that __vma_exit_locked() does, so
> > de-duplicate this code and keep the refcount primitive in one place.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>

Thanks!

