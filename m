Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF51CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 07:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297F98E0007; Thu, 16 Oct 2025 03:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2486B8E0002; Thu, 16 Oct 2025 03:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110238E0007; Thu, 16 Oct 2025 03:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F380B8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:22:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82A5A56ECE
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:22:01 +0000 (UTC)
X-FDA: 84003133242.12.5C59BE5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DE3A180007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:21:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TAzfieur;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zEPAYgwY;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760599318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tVeUiWot9QdL9D/iBMEP90gV6T1QSQWOGNauDWKbJ4=;
	b=6kcRdPZvjXM1O9hzFoWgUX3nMLjNUTDp52SyuCjJb0KAn6hHXsMW6Ev1cGDw1mLAb6Aoa9
	Qj4V+mtpF1Twl8pvC4UogilVi+68iHVmilydnOWE5lDpF+ojUXF2sFE57qGt3TeXWbR939
	XiMXQxwpR5B6ffwnhnNwXl5DdVWtGto=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TAzfieur;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zEPAYgwY;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760599318; a=rsa-sha256;
	cv=pass;
	b=cJABubEgeVzwxLNF+3P/ja/t3vb2eZVmGvkJU5fLzSeuzq9Wrrnol+AMAhpFhaV5g2Pa7e
	mK9AZBy5kh8qBVL12k76pjINBKTjUQ/U+JrVZ3lsseMvBDUi72StV3nMDpO3bYh1dE/YVO
	ZktHi15qBTF3EHUmk0g5399a+9EALqU=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59G6gEb0018573;
	Thu, 16 Oct 2025 07:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5tVeUiWot9QdL9D/iBMEP90gV6T1QSQWOGNauDWKbJ4=; b=
	TAzfieurXER/X6r0Kg6roJovXpnru6cueHJwWDgtVUrCXn7Vo2LzeNrjJ2Gzp5jP
	nD+q6I/aQg+7GpoqHcYR9K7x4VFRVPYIXdiierJ9fUvpZ7pKIFfU0d8OMgUG9kT/
	lT0YCeOqb02XKrE7yyWpF408DlWTGgRhvpOb/z9Pz4ZtxlBQ3NiWC/Bbx91PrqLM
	4JdQzwWbfvxossVSgyjworHpKkcjsmZNscwgj/IKw2k22p3uZ/EEExIl5KNgHx/V
	hxkrvvtQ2753moCX3UunDFx8XmagH7Xf11/8NAgFElq62g7APbdsRV7xHLudvuTA
	g6n7Eyml9EE/C8eT5ef9Rw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qf47r69k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 07:21:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59G5Ibgf017715;
	Thu, 16 Oct 2025 07:21:29 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpbax48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 07:21:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dABoq0VuLb46slY9nLZg1GSqtFnu2MOg/sPIWT6oQXJim5MA5N4EzcQqz0qtP3x4MO37FmSx4cw5A4Rd1Bo4q3k/Z4H6IGja1M+Ne4hMKZzwYW+dsq7emnq2rOWSiH6ENVCPIP/V196BSf5WnK0GPab+PmsTAUJcXs9TJ4uVxhAdcixLtAIesm0ekOlM5Mem+f+sM4TWmXXfaRnWFmpt/UtXOhTjUL7DkTt7Qab983PEefcrHmp9CJ3cHTEICIqecT1LOPHAlADFfU3VtMDRRzHWIYFf5ld66zqYQxaFu+rsjHDZZU6S90E+JNRvoS/1y3COOUgseCZ3wuN0t/+Dxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tVeUiWot9QdL9D/iBMEP90gV6T1QSQWOGNauDWKbJ4=;
 b=aQWUSTDtK9Vg8qCxi01bsoDPGdFGA2IBxqKPx5aPlwvXbTqxLMD8BDdX4wNNUl4FLZA8XKKRlk/6Dv4jPOOyLG+xZWKo/V22VgrmrCXKGxkowksRV4iTy4R0dub+awtrcWsasvdV8KvUz10JAKbYA2QOXPBTjH2a6d/n4eOQVAIzGbVsNKwiu5Qkv3+KsH2pjJC/mhEw028cq7kO+pK+I4U/0Lz5RjWdIm+pqVF3DfuWiL69/IsS5Y+UUYDn+AL2S62IjZfqCDxUOcL38jvjLy6I6edRvqWlw3s+hIK72Wtot56xpEkuZNRbTpm96zwEDsXLk1ZLBvXx0mUMgntFJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tVeUiWot9QdL9D/iBMEP90gV6T1QSQWOGNauDWKbJ4=;
 b=zEPAYgwYxKauzDHDxtfMpZ6vRC7pbaW4Zees+nh83cSUOnfGyS3Ck6NrQjt9KD/DDJnSo5nh/6Ukd7ySaHkKGXlqXZrQ6GvEeUHYGju+dUcW3xAtrsh3fXVlhtfP2TfRdEw3/+EzhuV4P/KXcIRFkgKKX3LuZDHiLe07vAMwCm4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB997652.namprd10.prod.outlook.com (2603:10b6:806:4b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 16 Oct
 2025 07:21:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 07:21:26 +0000
Date: Thu, 16 Oct 2025 08:21:22 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, akpm@linux-foundation.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com, willy@infradead.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net,
        21cnbao@gmail.com, shakeel.butt@linux.dev, tj@kernel.org,
        lance.yang@linux.dev, rdunlap@infradead.org, bpf@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v10 mm-new 6/9] bpf: mark mm->owner as
 __safe_rcu_or_null
Message-ID: <ebf60722-34e1-4607-b6a7-595fc2091998@lucifer.local>
References: <20251015141716.887-1-laoar.shao@gmail.com>
 <20251015141716.887-7-laoar.shao@gmail.com>
 <CAEf4BzZYk+LyR0WTQ+TinEqC0Av8MuO-tKxqhEFbOw=Gu+D_gQ@mail.gmail.com>
 <CALOAHbBFcn9fDr_OuT=_JU6ojMz-Rac0CPMYpPfUpF87EWy0kg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbBFcn9fDr_OuT=_JU6ojMz-Rac0CPMYpPfUpF87EWy0kg@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0444.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB997652:EE_
X-MS-Office365-Filtering-Correlation-Id: 11610e68-36e2-433c-b3fe-08de0c849e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2xaR1p0Kzg0eFJKb0NITHZjRXZZVWVCS1psMWp2VkdvSnU4VHhWYi85OEgw?=
 =?utf-8?B?SVNZd1ZMMnlkTjR3N0N1VFJFSmdLSWpmYmltc1RMbnB6WG1ObzUyWTVnNnZB?=
 =?utf-8?B?RTgrcWFSQ094MU1OVGhkK1pRLzVSWUVTUjk0UWNUSmRSL1RiOEV2NUZSaWFZ?=
 =?utf-8?B?Vlg4MHorUFZ3NWFiUUNTQndLdGpEN2l1bGt4cTdrakttenlTTklaVWNrbmFT?=
 =?utf-8?B?TDI5b1JIOTlNZHNHOVlDd0QwNkp6RjV3Q1BYcUVFZFoyWHlhZFltSjhzTjVy?=
 =?utf-8?B?empGQnZ3dDhSTXlsK0NtR1c3WTduVTBlZzdjTHlvZGJLKzZFS3ZZUTFMU2VI?=
 =?utf-8?B?MEpNaHlNelh0OUs5R1FBOHhJeTJVRlpvRWFCMmRqa0x2YU9SQTcvWmJlWlBp?=
 =?utf-8?B?a1l2bzV1M1lWbmRTODdoZzd6aWhoL1ZWdjlBb1hsbGRxNmlzazJIblhsTWFx?=
 =?utf-8?B?cjV6NE9MK3NtMlovZDBUT0RKSi9GWEc1YllIc0JSbnFTNS8zNUNOazlUTlc2?=
 =?utf-8?B?UENZNi9pY0ZOd3JtYWZNclhmOU5ja0JMSnp3M0xjZlpBNnlGcGliVm9rd29N?=
 =?utf-8?B?dllRck83TEdiSnAwYUViaHFqLzFZRkhmNnBOc1I3UUxvUjk1SWlUZnZ5M05R?=
 =?utf-8?B?V1FRR0RBQVNkOTVlaS8zem1UVXBGbCswcTRLOXlzUi9xMjJBSGtHb2FQUEZh?=
 =?utf-8?B?VUVEQUZkNFdsWDNDOFViT3puY3c4aHZmKzl5UkZyMGVNalQveUNxOGlKQVlw?=
 =?utf-8?B?TlhqNEpvSDYxdUpKM1hwdEFHQXJHUkIrT3Fad2xtVFFIejFhNTduNTFIaWFO?=
 =?utf-8?B?NXVnckxLU2hlRERoWjF4eFBNMTNMNHU1bjllWjFWN2tBWFc1aVEyM1B5b250?=
 =?utf-8?B?T084N2UyZzhlR3d1VGZmMUZjOVZhS0QxS0xBbGFVRE1GeGFveGc3ZDRsSXow?=
 =?utf-8?B?RzdMeEg3RlIwTXh4RmJvL0NSKzRxczVGbkt4cjZwR212RWNqa0dXZUVWT2sv?=
 =?utf-8?B?ZVUrVU9hV2ZiOVlVK09IWmYrc3hhZGVsR3ZybTlGcmM1Q3JqOEYxYkRuTjVL?=
 =?utf-8?B?OEZmelNHQjNPRU90Q1MreEJjUkZxVlNNdGxDQ0kzS2JtcVJrSHJobmF6Z3R1?=
 =?utf-8?B?R0xNb20vUjJqYVp1bTVGWkhsRERENDlqRkJUY0tQNXR1VjRRZzI2NFpsNnRk?=
 =?utf-8?B?d0JFc2pJU1JhQnRYeEN3VW9pamQ5UTFFekFiUGR5WXpZLzE2R0lXT0xVK3lU?=
 =?utf-8?B?RUFISmgvaUFHMWpBUXZtN3JLYkpHME9ZV2ZNQk1UcDhscGtQYWZnV3NJRDJE?=
 =?utf-8?B?SUl3T3RUNzdJU2hLMW5xbnZMWWtmV1BIY21GWUZrWG5iR3dLQmtqTGNGTjRC?=
 =?utf-8?B?M0VMM3dHMS9uL0dlWDVYUXRhMFlENTF0UWdoV0lRVndueEg3TENmeEx1YVVj?=
 =?utf-8?B?eGwxeFBLM1V1ay9ic2x2T2NLVWE0cEUrcnliVi9oUnRCWkgvSjk4WFhhUi9H?=
 =?utf-8?B?dW5FdUsyN0F2Vit5NWxWbHFCaWF2MTU4TGxZTnBtRGs2T2piN1NxOXl2NU81?=
 =?utf-8?B?QVptUlphcUF1VEgvajRLRjArUU9RZkEzd3ZrYVVIZG9kTDlhb2p4ZzM0cDBq?=
 =?utf-8?B?SFlaMnBKalVVNzNjNG9uY3pKSmlVdGtwZ29pcmNkMHZNbnVCQUV4VVVtNUo3?=
 =?utf-8?B?dTBaei9uL2k1cllpeGRhQS93NFdUTWNtSU56bWVNRXZKMGRVc1pxZHh5WGJX?=
 =?utf-8?B?WFBmMXBaWGdGUmpFZUtzRjFSRzE4bjJnR3loWkxyOTY2QXBuYzQ1d0ZsZWd0?=
 =?utf-8?B?dkdvSmUwVUNyYTBITWQ0VUVUYktlcXZ2VXprWjh1UDVnQXZhMEFGeU1MdUZ2?=
 =?utf-8?B?ZFJycXBHZ3Q5dVk3eWdTSWcvYXp1R2EvV2lwZkIyWTIybCtUZzJEUndYNGRI?=
 =?utf-8?B?RW5kY0ZINDI0Y000SnZmSFp0ODQ5TFc1dkEwSTdweEN5bm0rcEhaYkRLdFBr?=
 =?utf-8?B?am41OS9OaHZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVBEVmlQZG1zdXJrSTBUaGJ2dDU1Vkh5Ui9LeHNuR3RkcTRKRWIyc3NXSXNZ?=
 =?utf-8?B?MnhPVkFoMmtRNUJyVVE3UlNpWEc5T3p5MGRCR09NZ2xvOXQ2N0FtTXdYZDVq?=
 =?utf-8?B?SVJZcUFnVlBOTGlFSE9QcEJXYkZNMjJYcVk5d3dWNDFLTW9zc25yV3ptSGRX?=
 =?utf-8?B?OVRlN1RXWm9seC95aUxpWmxOWEV5VzRha0hCdzBVK0xpL0xkVzlCeTNCR01G?=
 =?utf-8?B?U1NBMHZRYmswNE8zVzVNYWVkcG1PS1BWMDJqU2JWL2dMY1ZockxrdHlvNC95?=
 =?utf-8?B?amUxZ0RWbDJRTGRpTjFKQ1VkeFRTSWhVOTZYd3ZrMFZvd2REOEFvQXd4QnhL?=
 =?utf-8?B?Qk1XYk1OMmJucUNRWjZoejZVMWxPSjZ1eHRoanhqZzluZk5XK2MyUjhqdVdN?=
 =?utf-8?B?SjBKUzJTeUkzYjFIMlJENmhsYTBrTnhKK1FhN0Y4TzYvUjg0L2M3QjdDTXc0?=
 =?utf-8?B?ZUZxWTZvQmtnL3JLYlhpNzhJVjdrSGM1dldONzIyaVF1YkE5U2lzQllyUVVx?=
 =?utf-8?B?ZmQ1VGRDbWF1N1krRlRVdUR5S21UMm5NdTl4RnZLNTdxaWxvUUJwQUlsZFA5?=
 =?utf-8?B?VHF2S05RU1BqTUkweTBMdkdPYkZ4UVBOdGl5ejRycS9jZjJ5UkdCS3JqVlRO?=
 =?utf-8?B?b0xSa0hwUENaTGNESS8yN3FFRWlSa1EyU2RVNHVKS2tYMWpiazJ2TVF5cXU1?=
 =?utf-8?B?MTJ0RXd5TXlaNktJd3BWbUhBMENxNmFvV1lhSStZMlZUWmZVR0ZYSGFoTk4y?=
 =?utf-8?B?NVNraERLdGNqdjgwYXNvVlRkWmp0REZzdkR2SE9UZzUxWkV3SGwxUUxOWlZR?=
 =?utf-8?B?SXA2aFA1TVNZMWZFMm9FQUxNWWc4WEJaZ01TNlBzWDhBc1I1VlMrdjkyWlhG?=
 =?utf-8?B?MGF1cFl4T3Vvd1F1eElzalNZb3ZEcXhKQUhzREo1UUVuN0o0WEk3b3I2a0tj?=
 =?utf-8?B?T200Zjc0YkdIWXl3aGFTQ2pJM1ZPVmJRV1paU2tNcnNoSHlldkYwSjdnWkkx?=
 =?utf-8?B?dVFaYk9WaW80MS9ORXpITU5zUzJNbmswT08rRTA4STZVOVVTMXBKVFc1R2FR?=
 =?utf-8?B?dXFsZDd1czRnNllFZythVi9rV3JsUDZLakpkZmIxaVBmN1QzQXZua1BuamdR?=
 =?utf-8?B?aWUyQTVpbjMvKzEzT0h3cUhMWE9FYTIvb3BOOUNBTExvY280NXRLc25qQ052?=
 =?utf-8?B?ME1sSy8wei9tQk9JVkFIQVM4QkNtL1ZNWm9GREFxZDl2ZWpVNC94WUtnTTBs?=
 =?utf-8?B?c3VBTzVxYU40V3JaR2dGNjFIMHlEM2EwYTNZZUUyYm81RDQ2UDhlMHYvbFU0?=
 =?utf-8?B?TSs2VldUdmJnWHpoclMydW42amFJOWVVNjk5RlArQ0l5WGlZblhRdHZBUVJs?=
 =?utf-8?B?VUE5eDdqTjhzVWZCcXdUUG1QNWdPcDRzZXlzRHh6K200bmpVeDgvZ052NkhV?=
 =?utf-8?B?dy9XVklZOE42OS85Z2N1Mk5TNFE2dUFMSlRrV1Yyd3V0Ny84NDE2WkEvSGhM?=
 =?utf-8?B?U05XdXZkY04rVno4b2lWejFQZ3hja2Z4QVhaSUdJc2ljRjd6NHpmUmpyQ2d0?=
 =?utf-8?B?SnBETzk4VVBLZHZXVy9sM052ekNRby9NMWVwT3pjb1ZJdnFDUkZWZnVxcUJn?=
 =?utf-8?B?eEhsalVsTzJiZHphWS9qL3hCM0dUWFF6ZnZDVG1rUmgrVTkrTzcxNENZTmth?=
 =?utf-8?B?c2pqU2hsQlJBaURFbDdXN2Q5U002QTR0akZWTHo3T3RWMkIvK0MvSnpJcGlp?=
 =?utf-8?B?TFZGOGdVQ0g0ekpXZzdnaU91ZU1zWkYrYnhYOHNIenluQXozNU1UcVNudGZV?=
 =?utf-8?B?MjRJR3NQbVNjT0xkRlYvcjhVWW1udGlVTXBQRHdvUlNJZVBrQ3ZZYncwbjkz?=
 =?utf-8?B?NHM1NVQ0em5xeE4vTG9ia0I1cHZqeWRJdDV6dWRUVHJWU0lRRFpiQ09ZcDNM?=
 =?utf-8?B?MEpIMTY3NUxzZ1MwZjRVa0xCQVZBMythSFRNTE5TdlJGK01QUi9rMy80K2JG?=
 =?utf-8?B?OEo4ZmtSV2ZtTUxqYU1yb2M3QnJwMWtoWjF2Mk5MUmF3a1dPOGcyb1BtbkdD?=
 =?utf-8?B?N0Vpa3dud3F3ejR0amRERGFJS0o4MEg4M2VEL2JoUGJaNnNTT0thUldkdDNv?=
 =?utf-8?B?ZGxkV2RWTzB3OFFLUXR2UE5xS1JSeDA2NTh2OWRwU21TUld6eDBaUDgwcjEy?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K2ZEZqIOBrMQC7xqXay67pMuNDV1vzYX3NY2dqmE6rTvNyhsR4DcJVoQNrRqfmFQGM9I9G63HJ5jyAcgNJEcKB0sibZ4G49cEu8eXhRq+Bxlt6vTmaWbhJXXJFuANfbhcuA/0RgMWxhAMnbDsiGMMpDM2QoMFh8Z6bPvFxaruvjqMTSxdpwHOxUtqH6ZPjnz7axZJJMDgOYgjzQhnGetCH1690NJmKaTweUusEQXXcfeQjXjB/box742zDAewurwUoImbmZcySr0xLKjovuaxm2QxlNuWWWrCnbxvhkwZkHJn6DplOJkmCvgTMPi6p6b2lS5PcwNsgA8dU32MhBdeTmyYU41oUAdk75qj4kXj6TGMrQPMj70T5L4VqjABd5PEFH6oUMyqDz5X+cMepNMki8SsP0/QPyOy3/MMmvkN9GVmsdTailrQY5w94aMoA83nC6n96Aq86PkM4Iqd/fgsFuoIDPNkQ5C13U8763lG/RVS1qD+8V7pLJhvyczMKFOnQo1OzBhupHzQRDPUjIAxREVtj8SonOC2ipNvKkcucTy/akbxXMCZhpIi30Tx+SFWimZAqOMGGTQmJbcE9rjYozSiIAMbFlp9WOswD131YA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11610e68-36e2-433c-b3fe-08de0c849e5b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 07:21:26.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fRbATfAZvUjtW331S9RiYhp4RZ4/8Wr7TFUsnldfY5g6RFMNp6ZMYGwGD1qSs5JLlNC+URpERTH1UrWkr3rzIZEkSrCznl+y9Y5Y3xc4Hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510160056
X-Authority-Analysis: v=2.4 cv=SK9PlevH c=1 sm=1 tr=0 ts=68f09cf9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=bjk5X-DNrSWSrz634EwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: YB0znkU8f_faSJpyNBOlhugJhbcJvHXC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNiBTYWx0ZWRfX0EBz6xgbg/vk
 q/HS1VFybXMZFvu2za7StYSDq6xeclkDjZG9M6RB8drfVCf99xy6esVvxHFxcrNvyLR0Pg0/YvH
 kw7VVZTV/yhtPVCbV1hqV1sk9NE5J1l/jN1YedZjRkpmVsGPMRQkfEXD4Y9cfXMf8h8BPP5w2cI
 UTVpHtbDD02Wn3tJWm+5edFnm+OFrR7Om7069u6dryxKgst5MvgQxVbIb6OM9gk1grknoCBlKke
 LfMr1FlAvKtPz7xvqVaszpGtZWUoYZn8AZTC5R7kit95fdvGDitBV+qEztaJNygbvc1/JAL/ALd
 lj38I4k1/C+swHmz5k5kOqggMM4VpwS9KPFGqyAIh4oOVILwfOg3Zr220uArnAm3ysnsERGxkp4
 6KbDInTHP/xlBaXBBsce+Xv98AHC5w==
X-Proofpoint-ORIG-GUID: YB0znkU8f_faSJpyNBOlhugJhbcJvHXC
X-Stat-Signature: hxornzfr9mk8cttkksfxdt3qtk6yo9fb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DE3A180007
X-HE-Tag: 1760599317-319763
X-HE-Meta: U2FsdGVkX1+SBQMOEfaF7xAo09IrZLxSmrLHdKAufds+b2W0mWnyBJrBXPziuv5Y+Q3CtVaRDl8aJm4O1n1t44zb6uCbJOj5gCnFjH3D/t8u6q0aI69+2zkGyiaIfQPX7buvSKCnM0gRQzOMLcyI9vPojVr6VC1JTlVcHv2ZRDJIzSFox1nt4IDGXKHEBxajUf0joYAQ//HZHEYsnGqjdE4VovWQiwQlA9k47BBy7nF8T+YW7hfez3VeFO+YlOLisfIDnpa5USj3GUuA8QAjA6E3mW+1U78+HQdlRj4S1bbqFsSzqhnADa71N3x3/7vLTfmftFtUPvj8KFMHqdVecUKaoDOgl4ZZi08Kn/7DBjMPK+XJuJ4h8zharI4BSjrBIUbLlvxPS0DCjLKe9GWEPexcomC0rrC+GLyAsv0YDSUkPt3rQgv1OfDrmG8Rnn8dQGv43FTHJnoumYyRVbKw5mNaRYrFjf7L5Y+DUPptSPooLE2SMoMPYEiZCeF9LrThhA7gk7JHHsnnm/sOH6SHoUzA5rSgLX+jAWU0JEPFxPfvdj9OdyZK13ZJf2bQyUX0OYOVPl6HK2Xmy3UNNjl78BhwwF2V3Z2j4ZDgRYRRYD4T7LMjS5TvvhlTYP8WmQ2UGlBXgCdbp757ldYZ/EGIXJ+mwViK+60t0sLpMgXO05wz9ufGhZupPnAE3lIePzSARAwu6b4DUpoq5NKEz5c6ZcreAevviaboGMB3K9Gv9k5EWgneD8O4eUoMPwuX8qmxzJ1nEItTjji8k+58HBgg0nM5VkNz/V/4S3C9fAejKt4KoCsBbMd2nb3l8R0VNVBOMeufLZPX3QHTwgvRtAA8lNUBH32nZzvHfxeIpJO7Xh5Dyf8bwP0pYtYCYf6dlxm3r6uCFr6Lzj/Ilr+xTQXNPjtXi8tHxUN8GL29zwoauvTuFyY9Cdeb7Y+eYi8pgHTsNfG3mxFqCjRC3WXuY+9
 peXFKDbj
 9JRW/8I/QyuIyOdEyIhj4Z6C72+ci6B1Z+NPpZoS6bsfmzIEM8dMt6Aoly7yNdYr1GdQCpZgD8T+QTH4PEKCW00ba6YW8FlQAisXIph85ALdQHMgXSwP0PjwpfeRWjUwqVQ7Uf/4N/f50AOo3YWMpDhCwAt70cOySS4qs2zKZgj1Jo4gLKFY/9N3ASV3D0yGIsD0/YYbomlbhW8e6kwwHKLaBztzK2BBGt4zg/rZoVdYLJo2JeCE9am11D2HzweuCO2YI1B6M0a2x9udwx7ytrQyLWbMBvW+876Nf5cyMOkVWlHmY4Um0YL8oHMq7ZdsL1SjQj/wAxMiDJZZygbRh3Oc0VECHBuzDnYFe/JyDA2jm9qBUnr0TOFt6IFpPcXOc3NWcoSs0NIDLcfpwZobLVdTxk2lodQPA5pRSghFENCxMGLdh9m2A0XLtQG9H4D2ifhrUIWhbzSr9/sx4aJcn1K9oWtv7Ln2j99+EzY8q2d/W19uKJq9x37JfXGz0Ujy021P7O2QIbLU90BuWr1474WYnDwFiY60iqRAXep3S+lpSoQBbpAc1ab4Lwo/ASWw3lG9xOPYXibnvbG7NSURlqDfNXTQvsIMVVXIujx+EETKPkfxo2W0NcTWUz1+YuI+QorGLI38lQf4nh5sL+p/04NK9VIhCEkxwaSKrpY0aVj8T6IMzUP8K34GYcETO9cn97Egui/XNpSClhvo4pY5rWphVpZzxAbktDG0wm2R59tZXK413ue+glYjEyuMIPcRFxPxB+5uObhN1+5qU7Dj9BaReIR++0Qg9awA2jXISTfx4FsIu60bn9xoOiJDR1Lh5AbUHZ8Wn5yZTOKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 02:42:43PM +0800, Yafang Shao wrote:
> On Thu, Oct 16, 2025 at 12:36 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Oct 15, 2025 at 7:18 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > When CONFIG_MEMCG is enabled, we can access mm->owner under RCU. The
> > > owner can be NULL. With this change, BPF helpers can safely access
> > > mm->owner to retrieve the associated task from the mm. We can then make
> > > policy decision based on the task attribute.
> > >
> > > The typical use case is as follows,
> > >
> > >   bpf_rcu_read_lock(); // rcu lock must be held for rcu trusted field
> > >   @owner = @mm->owner; // mm_struct::owner is rcu trusted or null
> > >   if (!@owner)
> > >       goto out;
> > >
> > >   /* Do something based on the task attribute */
> > >
> > > out:
> > >   bpf_rcu_read_unlock();
> > >
> > > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  kernel/bpf/verifier.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> >
> > I thought you were going to send this and next patches outside of your
> > thp patch set to land them sooner, as they don't have dependency on
> > the rest of the patches and are useful on their own?
>
> Thanks for your reminder.
> They have been sent separately:
>
>   https://lore.kernel.org/bpf/20251016063929.13830-1-laoar.shao@gmail.com/

Could we respin this as a v2 without them then please so we can sensibly keep
the two separate?

Thanks!

>
> --
> Regards
> Yafang

I do intend to have a look through the various conversations on this, just
catching up after 2 weeks vacation :) in the kernel this is an eternity, even
during the merge window it seems :P

Cheers, Lorenzo

