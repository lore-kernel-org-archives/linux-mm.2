Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB2CCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 17:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE0C8E00EE; Tue, 14 Oct 2025 13:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5AE8E0090; Tue, 14 Oct 2025 13:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866578E00EE; Tue, 14 Oct 2025 13:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5318E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:41:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D93691A09D2
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:41:23 +0000 (UTC)
X-FDA: 83997436446.04.84A3D23
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5667520004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:41:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kfA/Xhkk";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IdN4x+cH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760463680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iO1HRJQVCmwKhL3G0r4w7Laf1J3M+3/w+1akf9AcDqs=;
	b=ACyIt5jpVP9zflDpqWyksErjTaKp/dlCLDiwe6YLuvGkp/64kS+YtBnCfbO+eKSj9NoPX1
	F+fymdBze52RMDfcXIXEe//2XugI+RtS9yYvrDj9Cf5qWWYGUR+DqPLPUWRS1/sjNuKS3U
	/N2D3fdpKagQ0By1ajBc1G0Frm+7VFg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760463680; a=rsa-sha256;
	cv=pass;
	b=4w6Syp7dDhXtGRsf8Ed+ItyDV0keL4rAiwBUx7vXwnjzSKdVvCUdLzvyx9jL523kHR+hjA
	bwnaXJpQCtGzwGIIU7L3DCT1yVOqj7GVIzZbbsO9+Si30uNph1WOPjVtxwEK/wuOe7lMa7
	NVr0POFijEuwxQ4bDozYByZylEnoP1E=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kfA/Xhkk";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IdN4x+cH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEfIgV003685;
	Tue, 14 Oct 2025 17:41:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iO1HRJQVCmwKhL3G0r
	4w7Laf1J3M+3/w+1akf9AcDqs=; b=kfA/Xhkk2TKLFScAdIot4e5sDCAMOo65kz
	BOghmnht9rBpdWlZzcimPtod2jHcjWpLY7Vc3kOvXEaCJK2eYEy0yG2fbhQci9G9
	P6OREkaagEFx6njKBhSgIffhXjABoq82GKRDnZ/rmrcvO5ygZbpIgtmIzq5pcOrE
	/Fe7KRwLvct6y3h17UeP0FoXxZpGyGjXlh3fMTQq1uSlt7/Ce7alPTKU7ufSav9z
	3oV2PGHKJiehxwVpZRtBvXtSUqKKkiN+q3ddgSLZzfhD6uX6SsDw4F4nsqXfuJmJ
	KjLwQZO9g/kboU9f8YxU5qi8VareegLz23zdmFPsySmooXBbLYBQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59cy4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 17:41:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EGtwgL038223;
	Tue, 14 Oct 2025 17:41:11 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010025.outbound.protection.outlook.com [52.101.61.25])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpf9bjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 17:41:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D4eG5iaU5B/blLhLv3OOM3OUKoZESHydic6fsNsPLf8u+GY3h+KRYh1n39pEt98BxPVXzDfkSU4ZKVYgJvBWn/VgG7D3vtB2BV92PCXZFZHQ7qQjg2DfUUoyyTuuxldgKYG1RyRrzwtdnFDw+hW/d/CHYPbpdWQCidlGeNTDQfQeuHVHpboevZl/5RJGHn+XkqB/TRkYRIyVyM7hP+t/TC8dfLDVwtAmPzRzhvqiJ7Q83iaDoNUNmd/394+hKXqAT3f3pf94CKZjGuKeZFxWXoX4qMxmKlvjdMXkWpRIJI6nFzG8qV7mfQmxqRDFGBlUSjTqHss7S9FSugQxIGI3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iO1HRJQVCmwKhL3G0r4w7Laf1J3M+3/w+1akf9AcDqs=;
 b=VqvtUzPtbL9EQuaVohhC8MpXHcXjcPXZmb2NwhQjmBefM+xEwPMFQm7FQHjWmP8bYaKNZu3+aGlaiK3/a79sOhto6fI81Q6Tnqf/Y+vvO4rSQGHWpzqJTiVP2LgOZatsbmheWvf9U/1zpL3GzVMqjPvxSDXI7CaO6BPR3uLwEpMNoaFC7HvqbTbin2Zm5ncrlJcu1A+pr06rgPHBIX/OJeGHyYL0qOTSSQg5tbCnp9SMcKoqV8NyvEeZhzRGtBpfQ9c2ojT0bKlV2CYUIzUPJeYIkBFim/ixhfWIuGsfkBMcA/fX7QysFmVPstejbMcxALGbNxJhY2zhhz9ZmxsOVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iO1HRJQVCmwKhL3G0r4w7Laf1J3M+3/w+1akf9AcDqs=;
 b=IdN4x+cHu7JMXKfAW+hkIr7Gk+8h/SM3iw3hXC/IyrEkSdiYKuWR48XEbT560wNYJ6qRzj0I+EmQyerIWpe8Q9HvjzVCGcuF+Qbc/ZQsSrsn13ICeDCIDz1TQBOLjkBv6HWfb7cX2kCeeAJ+FwvswcmEuhfwIjQLLfvEW+i/65Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BY5PR10MB4242.namprd10.prod.outlook.com (2603:10b6:a03:20d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 17:41:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 17:41:08 +0000
Date: Tue, 14 Oct 2025 18:41:06 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, richard.weiyang@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Message-ID: <04734f2d-ea1f-487c-b01c-c3d6e1b4a778@lucifer.local>
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-4-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008043748.45554-4-lance.yang@linux.dev>
X-ClientProxiedBy: LO4P123CA0171.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BY5PR10MB4242:EE_
X-MS-Office365-Filtering-Correlation-Id: e996e785-d9b9-4148-b044-08de0b48dbb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CK8vGyaLyrvLWQzKttuhGkRPR+E8XAX1NO04UAozBDCGbmXNP5w34JADcPTk?=
 =?us-ascii?Q?UmMM+dF26BVTN7ZX1FxxvBvYZP7tgWxyjHfKOQA7fSaXglx5qm6bT/KKVl2g?=
 =?us-ascii?Q?LqBcs/r70JoPqDWXXHoueT6rm/F+I0lKONzi01Zf1LZsr1UnOrjP9z+HOSsY?=
 =?us-ascii?Q?yNfVgdh3jjtyFukE0y6oDhMCbc1DYmON5pObwwmRWWdm556fZKT95VvgRAqM?=
 =?us-ascii?Q?NgRK4xrhnNok7/EeOL4SWOtYzmBoqcd+lg9ifgll8UILcPHs3YKC92IblUMC?=
 =?us-ascii?Q?gWBd550els4G35SBnC790v4e8Cq9D9jP6MYN8EwHahR9bpb5+hKfnWrWSez9?=
 =?us-ascii?Q?s4m53CtBez+ivDx5szXKM74gGuPZDpMukdmTbmJHlMd1zfHx860xIslMVnsC?=
 =?us-ascii?Q?6VcPnqr/a5es9nm44oikepIO2vjBgf2uy4e7fguMvRglY0yTQOkrZ2IBF3Mz?=
 =?us-ascii?Q?wYVALs42e92M1cGyj7ZzU67bOGp4Dbcc93exOp60u4VzeIfaXtGAzD7TQXs6?=
 =?us-ascii?Q?xK7wYc9DEZ8TZ2QQzzcBCGzLzsajTs8XHngQ8WLXnKyTtquQRGS2RUgjgNcK?=
 =?us-ascii?Q?SWoR1JvgswnumLnIPRPhCn+75RBzbh8GDsld3QSFI4R50KH1UMkEP1O1H1Ch?=
 =?us-ascii?Q?lrQZnVe+CuRfMiggtUm+qvv7/gSsI0t12YQ05um9WPVQS13v5JwxyvghAeFJ?=
 =?us-ascii?Q?+x1K/WsIbob9Qnfl3s9YMoEYCtS4+Nl1G5XpADW8lU1V54y5k+IxFVicRntR?=
 =?us-ascii?Q?/pfca54aMjk9YYjfEP/hHYXX9ZYuBe9b5Vj+geWqzIEgpMNd9lXB2p67cfpz?=
 =?us-ascii?Q?WkIBgksUZojm7HWSIEmafUdYIv7ThuFoIQGvoMOggY/gv8gIud19gJY/YTFd?=
 =?us-ascii?Q?ptf0rSa35o5FpU2xspXoT6kltk1xPMXo61WZPZhqDJqOs2n4cvmEayH4r6lU?=
 =?us-ascii?Q?hnHVGKwfZ6BXCj3HaGRV3xVliPQTsA84DEQIS1rWUK36qYUrLQRKOqw3RdCc?=
 =?us-ascii?Q?8Y2/1ggSPaG3MdzrMH7trggmIJrKlLEPcMMn2HPnTgFBfMlYVtqyAvJ48wRN?=
 =?us-ascii?Q?tSONJuslOungjaZZPWyZ3qPLWkcM1sBv3/0BAk+zYfU6M8EPCnbG1qf5GWHn?=
 =?us-ascii?Q?pHpk0SUeCYBippHepb5O+LA2I6IV4yx8ltFkOJLKGYhkS4DDtIVn6nT5nUOP?=
 =?us-ascii?Q?CSefQOhoZuSmTtgQZsbjtJ8uXbb9JjlJwTbhKYl8uOVqWbW2+6ozc4Sa+M8n?=
 =?us-ascii?Q?Tawb7YMnY/LzyP7pAUlqOZvqA7Orx1acfq2cmHwFLIS+KyvVoTna3HyvrWxA?=
 =?us-ascii?Q?B+ZEGPZ2o1cfNZrP6Dl8BqA9H3oxLgDiQ6PtpP7K2/cNe/uvs9N+ig+3mfKM?=
 =?us-ascii?Q?IjiyOohPSXGo59k6U5QpWrLTP9aO79ECEa+v3B/tzN9c402g4zVTUnXGcr4h?=
 =?us-ascii?Q?QV2im+naM4EgEH2tqLiTsWIj+PP4nGqa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0yKdEE31AkN8m/8FgTxd8HAPZNw0Sz5V7+d7gK2eW2FVG3fQSVCu8oMmhKeJ?=
 =?us-ascii?Q?CJUrFMYr1l84ke5V3YEDGsum8QlidjBpNarqB2Xqkz0Fp5XzZdD1P+LR0JGK?=
 =?us-ascii?Q?NfW5cpF7AGa6VA572f7WjhE6GQmQD98gwADQt5CHMH/3VUkpxXz9CC1cfrCT?=
 =?us-ascii?Q?uC6Wuz0lBREOv7Q+TVXjwVaQU++uqbvLoLyayuQcPr9EL7LfRsmv9LttRBk+?=
 =?us-ascii?Q?vFMBKi+AAxT4DG3/n/u6Sh7Cpa1i19WQsNDzqvMk06Nv1+PYyR+f0RnBCIaB?=
 =?us-ascii?Q?eNmHZLn/GqMCFwFqxsPLy6BMRP/0cTPPNNd8FuMIJmlMguJ0KlvPoFeYFl/E?=
 =?us-ascii?Q?OYvs9iMJ8vSMs1a7QpTlM/FeDtVK0tInlbUZ+DBb2xUxHXbfBjXck9oZr0J2?=
 =?us-ascii?Q?90YfYUR9sxAWDIVRix5h6mbEwCjV2dIb3uVIaS9qs0d46YBMGhE/R4QROv9u?=
 =?us-ascii?Q?q5JTHmUUKa5BIwYbq/S2sM0YNuvQtAO2hTPqCiAIv/YwucMO5Wn+M0Y9QcR8?=
 =?us-ascii?Q?BQBZ2MUU4GDapdHgFjD5qsQMd9AZGLK0x9yQVqDgB5Cmvgdp9KBlUoCtfIEj?=
 =?us-ascii?Q?obu74LetdOSDEKqvGGbcvej6rEnETONBlBioozQfKOnPMi/82cTBOtHzN5mz?=
 =?us-ascii?Q?5GlaDkISrjWxtepKNnzRJ4d+5ENQwvn/dZeG27lo2l312ApfGqCBV6pcoa5s?=
 =?us-ascii?Q?3ttc9m1pkEFXx3CrC373RWIEXBMPcG8gQcJfUq2TzqOU//l6ORJ2MQf2g21a?=
 =?us-ascii?Q?E1MMCYAH74h/YxMsMkWC8wRISMrSL2yaEpHFGQFUA1N3ghtgNbekT9mojtw7?=
 =?us-ascii?Q?ybp6I3n4uxIjEmOEGu9u8cby0DnbYGUleluvcjeBTGLN9Fp2o4mQs/gBm2wL?=
 =?us-ascii?Q?ZWc/b0ZTqjLBsx83loWagRVMpoOtPF14vLAZqBmpCqlMCarRDK6HLsI8yhXZ?=
 =?us-ascii?Q?uBtfR2l4dAbGpvgRgQJ41j8CpEb1RjgRewkibr3D5Srd8QHXe/QCLfed/ZoW?=
 =?us-ascii?Q?B3S9A9cnC+23Tkk4DUDdDAOSY9mEKwzv5yL608bWYAB6rQghQHc5/rgy1FmR?=
 =?us-ascii?Q?49lXUYWZtZdvz/0DrCD4BnsuBRe9zUFjRWH+WvEcX7HRq1GOBXAa+QcgQXzF?=
 =?us-ascii?Q?Uh6vl8v0BvlyAEOf8tay0SNGxrVTXpspTD0bS2Fzx0a5nFv5pgXtOtkDAMsR?=
 =?us-ascii?Q?2BirmlOXD/+zmhMMkK9Pch4jWAcY7UQrQpvotFyD2JPjQl7EhGEkvfaMHJOu?=
 =?us-ascii?Q?3nK8Z7IozdV45fMzH+QDRJli00gBzyCqe39WwPjSRAiPtfJrHSpPGS1MKtKk?=
 =?us-ascii?Q?/HbTM9fnLyzs1SyHpzdYWzJjJJuax4qC/5TSR/e7lYpXM7PxJiZLF4NmoLh2?=
 =?us-ascii?Q?H/HKDObUMAWfrcxEv1DXWuWqsrUzSv+mlG2auxOcut58HBrRn+4yap/+rbNd?=
 =?us-ascii?Q?LQR6n6lBkix4/wNUTd2YAW4WDd0czX9YJTN7rDVDOpQ2r7iikrpLLjFZxKvL?=
 =?us-ascii?Q?RpjzDRqJmniggiZv4gYnM+E99jq7DkMvpJypTHlX0Gxbj5NS88tm3u41383l?=
 =?us-ascii?Q?MkF7xNCEruEXUbiP38Yuq8AybgnXF3bww4RdOak+QOrlgohbbvm6t+Bzqr8k?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	98Sni7iWahEndVrg3dFySiwilWb4p734ABYCfLNeZebg7HyRIUqpGqWPTigvZ8qpvCNbNmgQkxQe4sRYO45W8mPJYy3PhK2WuY34c1sM1vq+VZFLvWH2Y3uYJb/AKQ81teqnwXb/QctYn/COvAcz1gaTvem/UM9w7odhcg6/E0xIH0gYkNdr4rr4idtRCsV/T9C4P/vYD/muOePl6QQIuUZMxQWS/1z8Tp9hTMJhhChMXxY6kU1IXfRqwSObvKxo7texF7l06v8wNsz8jFMAuVAE3y4nrwXI0OvGAz1bN2CsMD6FPUzJLvBffBiYu4SG2h2o2+NpUcJHQmJDSdx+v6ju9fuRHfOEMXyS4lx/gfqS0UDcTETd1Rhlus7Q+Gc7iPsByQ9QIBzULYR+iqkhpZEDOr3eiyxVxb+WNesq99Lig3fo59FR/LQcs6VFFQaTA6ZUbu9W+xG1H5Jm04l5fOwosMGZK0wCqXn9AfEnTQLf9uHH/yP4sun4Nw/6iaZBQv/87nRYWX2TOLIBcmDCFj+u0X9uwPsYznuZ0wkO+FEYarP7wnwcqxaRUBbAqlsr/jI773Jrh01UmUVD9a2E0/TuI4oRg7Ji8Wa24o0FR0E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e996e785-d9b9-4148-b044-08de0b48dbb8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 17:41:08.6836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9B0s+F1ZMI9YRJOK6QmE5XZcu3ZvYvAC1tLis1NIeCNoYKo1kv9AIkdhpX8FGFgo9/fyGJrM+Y6LM0A1LclBFPoN7hAq63mnj7kqLU3Pcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4242
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfX1Zg4nFTmkAJc
 tQ1bxjVmkawgKfxxp5rtOmU93eQe9bEiPP6oC6bAYhofmMAvuuIKiYaxb/6MG50jwpd4AfGrITm
 KxCCRbjSZWSjVbmBY+avvgqMbJAGHFhVNXgw2rFLJIG1EE4AnO2mazRmub9rFn9DaAAZoC7Z/UZ
 t+1uXnTCkVHjMBzJ68YRr8WK4R4fTbQOy1RaoPVTDYqhbx9QBwqrC+uVthep37zxYa95ibx7Znh
 8yBsCJdmw/+BxxyzlhuEITNf0M/jajtx87Vk6o2xA6TYz0FpmbJz+gPXP0b0U9odezXOkjJ5dlO
 VMJ6hHwJd5KAidrapKO8u/wmiqIEeL2zAsAEvw/IAVNysRYNuYhhokqnp9zVMHTxrux0IgVR3Mh
 dcrXH93+VLSwJEdPC8L1RyxeMifeBDa+blfX3gtXrkryrYNMxN4=
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68ee8b39 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=cSSlqb1ANJ8e14efYdoA:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: LA7x7i8dkwJHnTNS_2-goFoRtwr3EAeK
X-Proofpoint-GUID: LA7x7i8dkwJHnTNS_2-goFoRtwr3EAeK
X-Rspamd-Server: rspam01
X-Stat-Signature: m8o47s76znd13q7fa3nhcfddcbkddhoh
X-Rspam-User: 
X-Rspamd-Queue-Id: 5667520004
X-HE-Tag: 1760463680-85110
X-HE-Meta: U2FsdGVkX198hDXVke7Aga27Mxh6CbEVCqugaJ029xOajFPyr7jfOMERzi2ANL7JCTClKPOJD8bYgOEQVaztOiGBXYrVOqZ6vVCz1B/X8znC0iJ1HXaXZgJCfHziy3ucoV8g6j8ks9fk/REE7q/MzUAjFlwZe5vU2BC2y1XeeV9vP+2fQCmcTYRwDhbly96QxsFfUbEe0+Cm+ogWoNaOWs2DfNZjuj7QULFfXuQH60vqEoKGfBAzckruGir6y+3QaWEVRoGX8Jn2doQ0G5CJ2YE3Gzo76z4L3rlpK9uXLeXa3nhkIADDT4z1Kmjj59lUf6R6BuM4gb2GGn8+NQKk/LMJeg+WET9l2Kc2S+IerYwGHSGblNy+5HxBntklU6p2EQJXSoCKcroAiZKWxbnrivBfV0h1bL9ZgJ+v0KoFBxpFD1EWwDAUG+RIlLdNjHZlJeiS6X0HQ+6EQac0YjHB8qjmM6ztb1cG4RNotmvCgcQhgTAqe70qrzBZibwQ9sUiMjLRDoy9uUEuJOtdV60DEl7Qw01bIMJe5igfgFdCf2eVASzaNDNgUKj1CDkLrRbzKhrLkhXUA1AmXbFFvxIfcuhVkQA3Sa3/P66wBY9WYPJkL3qcm3SzDDEcL+mf3TVoWs8xKk8QLFJ9lXqu7A4FfVKvynoU5T8epndnbI7L0xr2yJ48NVj7qkPY1toobwXESHDzD0+A4avh57tmnAY8tB/k49e0w0n1AbyKIR+zGvcH5Svosl1TFENrdntMVfxMc2UbauUIlv6ToerSLrJalfFKmUKFmDQ5wnTMcN+GOivmUi0q10WldkHU/wNhd69qbF29CwATlB9bAoKFdQqvwM+csA9eos9Pt6Z8Ok6FXhw8yad1xxcAombjbsoO/EoBjJdxFq+Ogjw0a/nrujL3q02aFRW9ctHi0vldUzR6o2cjLzNvxiEOW4v7sN+kPIVUGD07qCLvWDscwFj3Y5n
 hzSfOJxR
 cUgEO+RD6S0Tt6dVx2UScuO8+JSW8idn5+eAS412+V46B7SQtiXWrsAomorWDTv/2u5TlKJE18dZ/t3sPtnfrNCJs/wacRgvEBBYZ53iv20LbZSXdHVEziNWh/end32sPOYRZK15uzKK/ekULQpyF2JghKrAQhCt4VeH6D/gz3H3X4QrgirLwl53OrKphE8fWPANb3MAdN7ZGA/In7S0RrmJYK/Fg/9xQKav0DmVsP5E5WCLCvSIi+ahspJopYjvW0zVdFVS9nReXnak37Smo/fZxI4u1HSLZ64a85jPFbQ2FW+fSdfokAae+T97znkX5tUk/hgZMS2crSnZxc6GL3VDxQdKz5mQCMLPNrcpuO8WOyduZnLMLCLneYl8T0JusWU5jxq3WMA6+PxaQSvGwLBkPeE3qTW/S7jEipJps+9pTysvpc8zMudu3uF1DURUrx+UXbKheoYcAj143XcnD65mxfHFZ9HyeigiSjwb8/HsyBPTMiO/8OQqRGkts/yIkLc5/hNH0kXB5zm/X9tUQBkhWHWOS9bXBz9wwecp3OQk0gX18Py7rW4PsFVxbH4PHnWwAz7RzHVRzEbMJnytRBxAhN1gA6sW97Ykv7e08HLrNiQJClxbyQhdMbwNSISw9mxT6Q4RRHlSPZpCohZFCYZhbZaKERimQk3J2ZZvKhOfKEUmie7hv/htcQNL+tvEc9UrmYssSDE5QjceVbg+3yqxKahHyppZzGTouMHvbigF4iPlSyFbCRTKZBp8IxNqRlg1XF7R8cpqy60awsB+I8t97tbczZeKflkIeKCLpAiZjfZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK so this patch _is_ based on [0] already being applied then?

I don't see any is_swap_pte() here so presumably so right?

Can we just respin these series and put them together? Because now I've
reviewed a bunch of stuff in [0], which this series depends upon, and
you're saying we should now review on this instead of that and it's a bit
of a mess.

Once review here is dealt with can you combine [0] into this series please?

For [0] I would like you to reinstate the is_swap_pte() conditional as
(copiously :) discussed over there.

[0}: https://lore.kernel.org/all/20251008032657.72406-1-lance.yang@linux.dev/

Thanks, Lorenzo

On Wed, Oct 08, 2025 at 12:37:48PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
> and __collapse_huge_page_isolate() was almost duplicated.
>
> This patch cleans things up by moving all the common PTE checking logic
> into a new shared helper, thp_collapse_check_pte(). While at it, we use
> vm_normal_folio() instead of vm_normal_page().
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/khugepaged.c | 243 ++++++++++++++++++++++++++----------------------
>  1 file changed, 130 insertions(+), 113 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b5c0295c3414..7116caae1fa4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -61,6 +61,12 @@ enum scan_result {
>  	SCAN_PAGE_FILLED,
>  };
>
> +enum pte_check_result {
> +	PTE_CHECK_SUCCEED,
> +	PTE_CHECK_CONTINUE,
> +	PTE_CHECK_FAIL,
> +};
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/huge_memory.h>
>
> @@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>
> +/*
> + * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
> + * @pte:           The PTE to check
> + * @vma:           The VMA the PTE belongs to
> + * @addr:          The virtual address corresponding to this PTE
> + * @foliop:        On success, used to return a pointer to the folio
> + *                 Must be non-NULL
> + * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
> + * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
> + * @shared:        Counter for shared pages. Must be non-NULL
> + * @scan_result:   Used to return the failure reason (SCAN_*) on a
> + *                 PTE_CHECK_FAIL return. Must be non-NULL
> + * @cc:            Collapse control settings
> + *
> + * Returns:
> + *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
> + *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
> + *   PTE_CHECK_FAIL     - Abort collapse scan
> + */
> +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
> +		unsigned long addr, struct folio **foliop, int *none_or_zero,
> +		int *unmapped, int *shared, int *scan_result,
> +		struct collapse_control *cc)
> +{
> +	struct folio *folio = NULL;
> +
> +	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
> +		(*none_or_zero)++;
> +		if (!userfaultfd_armed(vma) &&
> +		    (!cc->is_khugepaged ||
> +		     *none_or_zero <= khugepaged_max_ptes_none)) {
> +			return PTE_CHECK_CONTINUE;
> +		} else {
> +			*scan_result = SCAN_EXCEED_NONE_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +			return PTE_CHECK_FAIL;
> +		}
> +	} else if (!pte_present(pte)) {
> +		if (!unmapped) {
> +			*scan_result = SCAN_PTE_NON_PRESENT;
> +			return PTE_CHECK_FAIL;
> +		}
> +
> +		if (non_swap_entry(pte_to_swp_entry(pte))) {
> +			*scan_result = SCAN_PTE_NON_PRESENT;
> +			return PTE_CHECK_FAIL;
> +		}
> +
> +		(*unmapped)++;
> +		if (!cc->is_khugepaged ||
> +		    *unmapped <= khugepaged_max_ptes_swap) {
> +			/*
> +			 * Always be strict with uffd-wp enabled swap
> +			 * entries. Please see comment below for
> +			 * pte_uffd_wp().
> +			 */
> +			if (pte_swp_uffd_wp(pte)) {
> +				*scan_result = SCAN_PTE_UFFD_WP;
> +				return PTE_CHECK_FAIL;
> +			}
> +			return PTE_CHECK_CONTINUE;
> +		} else {
> +			*scan_result = SCAN_EXCEED_SWAP_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> +			return PTE_CHECK_FAIL;
> +		}
> +	} else if (pte_uffd_wp(pte)) {
> +		/*
> +		 * Don't collapse the page if any of the small PTEs are
> +		 * armed with uffd write protection. Here we can also mark
> +		 * the new huge pmd as write protected if any of the small
> +		 * ones is marked but that could bring unknown userfault
> +		 * messages that falls outside of the registered range.
> +		 * So, just be simple.
> +		 */
> +		*scan_result = SCAN_PTE_UFFD_WP;
> +		return PTE_CHECK_FAIL;
> +	}
> +
> +	folio = vm_normal_folio(vma, addr, pte);
> +	if (unlikely(!folio) || unlikely(folio_is_zone_device(folio))) {
> +		*scan_result = SCAN_PAGE_NULL;
> +		return PTE_CHECK_FAIL;
> +	}
> +
> +	if (!folio_test_anon(folio)) {
> +		VM_WARN_ON_FOLIO(true, folio);
> +		*scan_result = SCAN_PAGE_ANON;
> +		return PTE_CHECK_FAIL;
> +	}
> +
> +	/*
> +	 * We treat a single page as shared if any part of the THP
> +	 * is shared.
> +	 */
> +	if (folio_maybe_mapped_shared(folio)) {
> +		(*shared)++;
> +		if (cc->is_khugepaged && *shared > khugepaged_max_ptes_shared) {
> +			*scan_result = SCAN_EXCEED_SHARED_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +			return PTE_CHECK_FAIL;
> +		}
> +	}
> +
> +	*foliop = folio;
> +
> +	return PTE_CHECK_SUCCEED;
> +}
> +
>  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  					unsigned long start_addr,
>  					pte_t *pte,
>  					struct collapse_control *cc,
>  					struct list_head *compound_pagelist)
>  {
> -	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr = start_addr;
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> +	int pte_check_res;
>
>  	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -			++none_or_zero;
> -			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> -				continue;
> -			} else {
> -				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				goto out;
> -			}
> -		} else if (!pte_present(pteval)) {
> -			result = SCAN_PTE_NON_PRESENT;
> -			goto out;
> -		} else if (pte_uffd_wp(pteval)) {
> -			result = SCAN_PTE_UFFD_WP;
> -			goto out;
> -		}
> -		page = vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> -			result = SCAN_PAGE_NULL;
> -			goto out;
> -		}
>
> -		folio = page_folio(page);
> -		if (!folio_test_anon(folio)) {
> -			VM_WARN_ON_FOLIO(true, folio);
> -			result = SCAN_PAGE_ANON;
> -			goto out;
> -		}
> +		pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
> +					&folio, &none_or_zero, NULL, &shared,
> +					&result, cc);
>
> -		/* See hpage_collapse_scan_pmd(). */
> -		if (folio_maybe_mapped_shared(folio)) {
> -			++shared;
> -			if (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared) {
> -				result = SCAN_EXCEED_SHARED_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> -				goto out;
> -			}
> -		}
> +		if (pte_check_res == PTE_CHECK_CONTINUE)
> +			continue;
> +		else if (pte_check_res == PTE_CHECK_FAIL)
> +			goto out;
>
>  		if (folio_test_large(folio)) {
>  			struct folio *f;
> @@ -1264,11 +1347,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	pte_t *pte, *_pte;
>  	int result = SCAN_FAIL, referenced = 0;
>  	int none_or_zero = 0, shared = 0;
> -	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
> +	int pte_check_res;
>
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>
> @@ -1287,81 +1370,15 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -			++none_or_zero;
> -			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> -				continue;
> -			} else {
> -				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				goto out_unmap;
> -			}
> -		} else if (!pte_present(pteval)) {
> -			if (non_swap_entry(pte_to_swp_entry(pteval))) {
> -				result = SCAN_PTE_NON_PRESENT;
> -				goto out_unmap;
> -			}
>
> -			++unmapped;
> -			if (!cc->is_khugepaged ||
> -			    unmapped <= khugepaged_max_ptes_swap) {
> -				/*
> -				 * Always be strict with uffd-wp
> -				 * enabled swap entries.  Please see
> -				 * comment below for pte_uffd_wp().
> -				 */
> -				if (pte_swp_uffd_wp(pteval)) {
> -					result = SCAN_PTE_UFFD_WP;
> -					goto out_unmap;
> -				}
> -				continue;
> -			} else {
> -				result = SCAN_EXCEED_SWAP_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> -				goto out_unmap;
> -			}
> -		} else if (pte_uffd_wp(pteval)) {
> -			/*
> -			 * Don't collapse the page if any of the small
> -			 * PTEs are armed with uffd write protection.
> -			 * Here we can also mark the new huge pmd as
> -			 * write protected if any of the small ones is
> -			 * marked but that could bring unknown
> -			 * userfault messages that falls outside of
> -			 * the registered range.  So, just be simple.
> -			 */
> -			result = SCAN_PTE_UFFD_WP;
> -			goto out_unmap;
> -		}
> +		pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
> +					&folio, &none_or_zero, &unmapped,
> +					&shared, &result, cc);
>
> -		page = vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> -			result = SCAN_PAGE_NULL;
> -			goto out_unmap;
> -		}
> -		folio = page_folio(page);
> -
> -		if (!folio_test_anon(folio)) {
> -			VM_WARN_ON_FOLIO(true, folio);
> -			result = SCAN_PAGE_ANON;
> +		if (pte_check_res == PTE_CHECK_CONTINUE)
> +			continue;
> +		else if (pte_check_res == PTE_CHECK_FAIL)
>  			goto out_unmap;
> -		}
> -
> -		/*
> -		 * We treat a single page as shared if any part of the THP
> -		 * is shared.
> -		 */
> -		if (folio_maybe_mapped_shared(folio)) {
> -			++shared;
> -			if (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared) {
> -				result = SCAN_EXCEED_SHARED_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> -				goto out_unmap;
> -			}
> -		}
>
>  		/*
>  		 * Record which node the original page is from and save this
> --
> 2.49.0
>

