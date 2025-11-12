Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1BACCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600C68E0006; Tue, 11 Nov 2025 21:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D87F8E0003; Tue, 11 Nov 2025 21:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0608E0006; Tue, 11 Nov 2025 21:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37B038E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:18:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC4781602C3
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:18:53 +0000 (UTC)
X-FDA: 84100346946.16.C2AE0D1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 344DCC000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:18:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BJqtqrUc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wHbSPnHb;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762913930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlBss3aDHXH2BBR8gw92xics3PPbTYOILAeOMzYXeFY=;
	b=0DjVeApd6ZdymSoh22fMFUOqjDrqWo9otRasPYQOxV4BrJPtNB7uyZm+9lw1MHrm75GR26
	nfqVHYdeYI6qlYc0c2lt06wR3Q+uKEO9OWfzpoM6rru/045POSqSHgdbEk5v1+hf/r+u7z
	25Lzb2AN/DRtRgs7Eibw2zI/X/8I8YU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BJqtqrUc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wHbSPnHb;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762913930; a=rsa-sha256;
	cv=pass;
	b=BVRNkf3Lhg6RtB4oCdyVAg1jRXCOcreD9xKp+p+0ApwTsH8BeVKvU38m/b4UHekJmRyjYN
	GAPZl/P8Otzj5SqWOCwL6RDrrxGxbiKiUq09nlezu9TbjMBuaRnskDB8itfgFvyb6KJIjW
	hAf1+6eJIIWKuhzke4GA4W9M8pfyAYs=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC0Fb9x027149;
	Wed, 12 Nov 2025 02:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vlBss3aDHXH2BBR8gw92xics3PPbTYOILAeOMzYXeFY=; b=
	BJqtqrUc5SxAajpZPAuZXHb2UsqN3S/2UD5r0s2/e5d3gAh3iCiga7LVzNOf8PuK
	D3EDszi0VyWX4MrfClDZy8B8S+hHdiV5RQ3W9zQPiWYiRAbSSVsgaXA5F3l2BlEd
	nheiD7ckb71dbtjr6y9OHAMLyfuyYqQUzGeLeT1U7btj/qfdfZbXbmOgK8Sp3QeW
	F+zYog8ZrDY8XNwMkausiPlMlQSdg+vURu48jlUrGXGjRooKqJ5t9Q42ZPg8NiK8
	ca0ePn+8CC/99jHwvJERYiKOV5erqx5LLcGJ4VlbjI1Kf27LQZtQg5hgfhnKaEbv
	84Xq65y3l5T5apMhx/cAog==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acd468cxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 02:18:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC1ZIQR007462;
	Wed, 12 Nov 2025 02:18:46 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaan9uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 02:18:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ngchBkCIdtF0ZzorLwBXq331DP/WeA86HjE55cBznZYSwW7xducc3ZMSvxVMi5NAlaHZdh1bPUUNdS+CS8PfCfcIk3GmdEtXi4G73E20erIEo9zG6vgGJVlMD+F0eZsoPtlHTKVL2sK/WqzBV/FyBDGnAlb27Im9lWmrAYGp3a1Uj/yZWxN5Fc7XXMjJIj2MbJ0dn2mRrhJqEc9JV8HmCZpVrIQDSAjAE244gOTzrs7UqkOqHmmT9tr+XjJ08abl3d3Hw8KUch3iuDvrgFoD6x1wv8uyKHOpURFzCWYaUD2uldfew+DAZOkR+GtV6ss0XD5jc+4HWPVd9NYySlT5SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlBss3aDHXH2BBR8gw92xics3PPbTYOILAeOMzYXeFY=;
 b=fjsJkL3MitBM8TiFQ0czn4BPr2w/Z0axSKcz90HQN1xFkAU6VbvHyTm9kIXO6liFORZnu4h3m/jYw8lTPt9eJ0tFLIGfcGXxPCqOTw7ey7ZL13cn+RHSrkxumi7yVbyfceazNWlipesRl+k8+PkapUtRpmhuvS3kV+X1k8cY24s1FbtuyAuxjFAMMj1nWiaJKZ4oi2lZ4XwajYY8lzwA/lAI5+Ilzkw/aiAqktEGfVemWNOESOxAJba3p5X+kPgvj1vI6l6sbLSCQBBWlqFPkM73ZuEIyLiXtmGHj1u8C9F/2VXfHfifgJdlsKAFpVfDxFDD5p+m5H7RO7hmWYrEYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlBss3aDHXH2BBR8gw92xics3PPbTYOILAeOMzYXeFY=;
 b=wHbSPnHbVKW1p4wZ5sqfWe2T4vJkGn3uCvpSxag1ckqPEXNIJ8COxDtT7c49p8Xrhns1zboU/hPPb7w+8ApYllUoC1jPGPBSSv2QrBwBuS69TfJBdkvy+kDBEydlZS4bYqAvi1tK+dGn0dk+uao/kUB30fs/ijkLp7EqoQM8xac=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS4PPF80E5E852F.namprd10.prod.outlook.com (2603:10b6:f:fc00::d2e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 02:18:38 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 02:18:37 +0000
Date: Tue, 11 Nov 2025 21:18:19 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        stable@vger.kernel.org,
        syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Message-ID: <aoq7jyue2qamctxmvtlic4nv53phskj6k7iizh7k6kwruwdgxk@qgjnaib7xgze>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, stable@vger.kernel.org, 
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <8219599b-941e-4ffd-875f-6548e217c16c@suse.cz>
 <CAJuCfpESKECudgqvm8CQ_whi761hWRPAhurR5efRVC4Hp2r8Qw@mail.gmail.com>
 <kfqzb2dfxubn6twcbiu3frihfkf6u34g2rcnui2m63rbc4x4kk@dh3bxvpzpnmp>
 <CAJuCfpEWMD-Z1j=nPYHcQW4F7E2Wka09KTXzGv7VE7oW1S8hcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpEWMD-Z1j=nPYHcQW4F7E2Wka09KTXzGv7VE7oW1S8hcw@mail.gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0073.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS4PPF80E5E852F:EE_
X-MS-Office365-Filtering-Correlation-Id: b1479b99-9250-45f0-0f89-08de2191ca00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkRCNFBvTmN5VW1HV0dvVmpHOHExTS9Gc2VBdlYrN0k5bkN5VnVNU1VKT2Z2?=
 =?utf-8?B?SmkyWFY4ZDZJbWQ3b0ZEY0tCTXNmZ21SZmorRjJmQy9MQ0RZTHFnVFQzbFJ2?=
 =?utf-8?B?bUhEZjVOQm1KMVNLWm1KMFVsRU9sOHRqeWZhNDI5RmhTdGpUemU4VDY1UWdB?=
 =?utf-8?B?Q3FDYktWNzZ1WjE3UHNVZnNha3VrOVlsR0xsNmFQMGx5TzZNZnJZV2J4VkxM?=
 =?utf-8?B?ZjhxN05zem91aE95Q3VpZ1I0SDdxZHphZU1lRXVYMFlTNFQrUUdySmNhWEVv?=
 =?utf-8?B?bkJIakxEd3ZUMUV0RWcxclhJTjFnV3NvVTJZcXJEYTFzdlp0ZnJqZm8vNTAr?=
 =?utf-8?B?S3dKM3hjL282SmhjT050ZTlNc09tNDFEM0pxV3RpNDV5ZVpyQjJFVnI0TSt0?=
 =?utf-8?B?L3VGNDdmVThHT2xRSjlmN0lBdGJha2REdDdMSHBzb0U4WktTNHhtU01LOThU?=
 =?utf-8?B?Ymp0SE1jNVh1TEdpR1F1cXBtdi9Na1VnalJxMzJFNnZ2QVNrVU9vd2lzcDZ0?=
 =?utf-8?B?RmltUmtqMjNMajl6akVzRFJtbGFvcTgxbmlEaHNzUkh0MndwTEs0OExCN3VE?=
 =?utf-8?B?UHgvZzJ5ZGNDK3IybFMxb3N4VnNyWmdPRzVVN1JIbS9sYnFYenlQbmt4Y2F5?=
 =?utf-8?B?K3A3T3VLbDhzYnRQZ2p4WCtnVmJudWdCUkxaWTNidmQ1Y0syd1pEL1grRC9R?=
 =?utf-8?B?cTRHVjB0YU0xUlhDeUYvS0o5VkZkZldpbUpEVFZLd2FCTGpuRitibERUcXVq?=
 =?utf-8?B?MFZ0dDlwVUM2d2g0ZlM4b29takhKVVo3QjYrSjQ2dlJDRVpFSHBRSUVBYWhY?=
 =?utf-8?B?bFhaSys0RUU5OU1DZktqT0pwdWo2dzdwZURvTWlHQjhXV3FpcGtrYXhyMXRi?=
 =?utf-8?B?bGF4N2V2ZHcwUGkrWDR4eFpJTFVtR1BDR2g1eUwzM3F0SndwTHJvT0t2R1Iv?=
 =?utf-8?B?eEoyS1cyM2s0WGRqcEdVVkxUaVpCOG9sSGRZY2wrcWVQNEhvYXIrT1M2WlFz?=
 =?utf-8?B?V1B1dXRHdmVteVFyci9FY1ZwbzBVT2l4cWVRR0Vva3J3MlBCaVBXS1dLVEN3?=
 =?utf-8?B?OTI5czlVd2tOSldOWmJJN1Y4VkpsMU9qRENJS2ZZV01TN0NxbUloYlRFY0do?=
 =?utf-8?B?RU83cmkwdld0QmxtZW5sQ2x3TDF5cDZSTG1nMkdBbVlsRlgvUy90clJNOEpG?=
 =?utf-8?B?cTMreVZ3dnEwUVhGTGJLSDQ0bEVzRk9PM1FKa1Y5Tktzc0VRbmJtSHJiUEVG?=
 =?utf-8?B?RVVMTVQzbXQ4S1FSY01QUS9sYnRreGNaamhEaTBiZ29VYlVEeFhVQVdsOHBs?=
 =?utf-8?B?TzFOU1VleXEwUkpsVG5oMFF6aUVsMjArT3dXa3NUbjZteTg1ZWVQeGxQdk96?=
 =?utf-8?B?UjNmcTRhWm9YUENDQWY5ZDJjWWc0NWV5dnhsVE9sM25KajNuRVNoM3AxZk85?=
 =?utf-8?B?WiszTEhLT1BXd3N6WitZYStobU51L3F2MDMzekh5aHRCTFZmRWZwdlZmV3Vx?=
 =?utf-8?B?Z0xRSHNjdEUzd05OSVVxZCtUWmlFcVZsdG5PYkVpNFZFK28xaG0xN0Y0RFcv?=
 =?utf-8?B?TjR1b2tXbGxFcWNmSmpLblJwZTNNNDlvUUMxd1pmSTRKbmMzR3llRGlNY25L?=
 =?utf-8?B?WkRMR0pzMnhyQ1VpZ0YrODIvSWowS3FKZWFPTGswTTcyWnhWMlAvTGdOKzVC?=
 =?utf-8?B?K3dUa3Roa0R3MVR1KysyMDdPTmJtc0dLcUNOb3d6c2RKZ0dySHdKekJ3ZlAr?=
 =?utf-8?B?S2FZTnU5aGVMYUF0L0ZxeVhoRmpYdlNpSE4wOVBta3V6akwxVjRRMkRacEVt?=
 =?utf-8?B?c0lodHRMc2ZZYTdEai9QRWdkc0ljVWlxWktId2c1cHpXSDdRNXdIOVRKZzRD?=
 =?utf-8?B?ZWFBb3RsakJVTy9DeWNDTS8yd2ZFelJPMFRnbnlPZW12a0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHBwK1RKT0p1eXdVUThlSkZQN0hpM0E5REtCOEFXNm1Pd0lKUVEzRDdWV1Bv?=
 =?utf-8?B?Y1ZINjRVK1MveXZIZk4xcExIQXVyTnZuUFk1T1lld216Z3B6Uk44Zkg2K2FK?=
 =?utf-8?B?ZW1Rd3grY0s3UW1WVHZ1ZnNFQXEwOWs0elE4MEErcnhyL2gwaFpuUndHVm1w?=
 =?utf-8?B?WmNWejVjRE5Ja1BaQVlJY2RXZUZGemo5dTM5OGRBZVVFM2w0b3pheHdUUWV1?=
 =?utf-8?B?SlFtNWNoZVprT25qTWw0ZVBNRTVIanM1NHdVMFl6alh1ZmhUYWF2WUJmOEk1?=
 =?utf-8?B?cFRoMjdZR29LZDRJTmRKb2NIOEdxTkRVVVdPdU1oMTZhK3B6VnhhbjR0WFpz?=
 =?utf-8?B?N2wyazdUeUw2VDZvQ2VEOE1Ia2RuSzZuWUpsSExYQTNLR1ByckhOdXkranBt?=
 =?utf-8?B?c0lxLzBRc0twbVdKSGZOSk03M3pNRHZVM1Jtb2thZjJ3SU5SM3RmTHpNYXpD?=
 =?utf-8?B?NlQ4U3d3ZlhSY2lhd2NkRXF0QlBOUS9WOFJ0YVhUUTZtdzd4ZzhmY3VSYnFP?=
 =?utf-8?B?eUUwQTJ6QVZMTk8xMTE2YVRFQlFDbEdLcjZ6RFk1SlhmeUdqZU5BWGViaFBt?=
 =?utf-8?B?aU5WMGxSbkRJajJMczU1UG42bVFOOGpITGhrYStBcW5JU2ZQU3k3OHFIM0Ur?=
 =?utf-8?B?cndqd0duaGtNdkdtMW8wQmYvOWFkckF1Qm9WZXpoazFoR09kOGJOdTdqTnY1?=
 =?utf-8?B?M3FUZUVKZkdxUmVEZDlQcFRIcjZWTmIwN29SU09waGl3Q2IwUGF4TXgyS2x2?=
 =?utf-8?B?TTNjK0FhQ3h5eUxTK0U4UVJCQWpmdXNFbFcvd240ekR0eHhVVGRGUTRubFdT?=
 =?utf-8?B?ZVhERmMyclhWcmRwM0FTTkhkaVMweW1XSFJxbUxtNmFDRTIxOTl4YjU4UHc0?=
 =?utf-8?B?MFp4cDJBN1RRekNtczEvZ3FyYm4vSXpDeUlXS2l3OWp2SDdyd2FmYWhMSUU1?=
 =?utf-8?B?V0xEaU4zS3FBOUc4d0VRZlBUYVZDbGRvd2pGSmxMTjVDYzlXa09lekdsbnJ1?=
 =?utf-8?B?TDFTRThCeDFiTVVCR2NoVWFvSE5KZFZVTGFTakliVnZoK1JvakNYY3BieDFj?=
 =?utf-8?B?V3Z0N3VKVWh5MWhxczlaV25nUUtzSDZxZE44TVJuTWMrcTB4SzI5czRtQ2s1?=
 =?utf-8?B?aTNnT2VWYW5rVFNBUSt6TFhkMytKY1NTeWk4OHBtMjZQd2hmMFlRdDRuNGpQ?=
 =?utf-8?B?QW15UmQzZUNySjExZ3RoYTJiVVZ6MXk2Y0lhek1RZWFRQ0Uwd3U5dHFRNm1M?=
 =?utf-8?B?U0tyZ24zSUMwczFxekNENkgxRENvaTFCM3pTQ3hXTmNIOHpqczZ6WTEzd1Vh?=
 =?utf-8?B?YlJ2NW5MdmJGemNUaWJUM0RGWW1sb0FjZkNmSFpjT1B0Nnc2MFJUZnUxZkJE?=
 =?utf-8?B?WXNkUEpVNURSMlYrR016U2MzMjk4NXROWlNMTGpPaWRPcHBJOFpYa2FQWFAw?=
 =?utf-8?B?WDJPQmlrdFJLdWlTUkVIdmxTS29keUVZSjE0QUUySU9temg4YkNZSTNsT2FM?=
 =?utf-8?B?MHZhUUFvaG0zZGVCbXkwTm5hT1NTR08zWDA2MENxWGUvT3NJRzlFRWYzNnBD?=
 =?utf-8?B?bml5aTV3ODdkdW5JdzNqZWdEekdVblJONVV1VXRJS21iK2V6bFZvWHpobHMy?=
 =?utf-8?B?b0pMSnRFWlpWUnN6QVExY2k2K2dOVGVJSnY2OTlpUmRscVNjNzFZQzlvV0RG?=
 =?utf-8?B?dWkxclhnaDQvWm1aSDd0VnlkZS83clRESUtUYzRBZndvN0VZS2JMdHFJOWtN?=
 =?utf-8?B?dFd3UWNYOU56d1hwZDhzSkRlTFJuRndrZ3VyVGlxb1JOVzk5MWJxL1ZUQTdF?=
 =?utf-8?B?MC9RUkI0VCtTeXBJVWpCaTJSRzUyamZnMm1qdEQ1cjd6b0o4K3pYVmJRdGFE?=
 =?utf-8?B?ZFhLeURSdnZJOHJCNjViMGE4T2hFNS9Fd0F2eDhTQ2IwQmxPelM1YWJrdW1Y?=
 =?utf-8?B?eWJZUS9icHNIdk9qeEh2R2N6djI2NU9ybU9FVDJhWUVVTHIvTUk3czg2Wjd6?=
 =?utf-8?B?MGUwc1NJSWhKTENDUjQ0MjFYZzhQcTdsL3dNTkRrWXh1TlNlLzd1aFB4WTAw?=
 =?utf-8?B?d3NrMVB1Z0F4UFl5MXJ5VC9kczhxeUxVSit3RnlYQ1h4bmxyZUJqTGFoNmty?=
 =?utf-8?Q?s+/AKpRhEUPa6KCQoFnN6jXbu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DH5MV3TxQXxUsrpnS0vahYc2tt1CBsqX+oF+E7/MpX9KG33/IXJ/LK0TYsirz1Ve8MjI5C0nYv341y+ltP1+tuCID/5livqqyNmt0LfdKtedpdS7+1a0VuT6iuymWTzxrHqORpFScZgKVTCV1l3QKgWK/irGfpSOAzsQMndaqFXFBaJulBJZ7+UG6oLoozVzbJ0/3Rh3NkYUDXJIgE2IFzQIrXX2zWnmISqZDVvkNFRLoY3q2H4qVSW0OC3zD15PWjzZ7umvmxFeK/XSK44u9nWwyvexxdoT21wejnDA9bDfTlnfoMbP3ub4gvQ6X3Nf7jUm51YnzdkFj5qww4vgEhtsVyrZWLKRqEYclWstKrqvQgn07WnnbEXbLQ5lrPnkJ7Jx69ZDHHauRcBCso1BIgKAcP4eFHZpBjgbttTTUDFrymoJb2am2V0Nc0pJ878P9x3htdUy+ZdCs5iA/Ykh8By82D2hUtWD/tOhWaLxgW3r3SInBZiMWHTR6oIYg0ujRCZ2mNYy8lx1zS0a3I79UmIJVD1jxZSUhTYbgcZL0WesvQkTzh519Vis2HtejxZLBFElIJqi3qFhVK6UA6hgGl3kK7ki6CUl0qaWDHzhPr4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1479b99-9250-45f0-0f89-08de2191ca00
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 02:18:37.8566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OfcgLevUrcTLsP/5k8dikCmFSxjPWJUWnljx35El36Atg9mGEAYzchLCxF+FMwrb2OtiWaNrSNhLkw6AYXorRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF80E5E852F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_01,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511120016
X-Authority-Analysis: v=2.4 cv=DMiCIiNb c=1 sm=1 tr=0 ts=6913ee87 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=hSkVLCK3AAAA:8 a=e5hHg2YQfrC2PJfLeyQA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 a=cPQSjfK2_nFv0Q5t_7PE:22
 a=poXaRoVlC6wW9_mwW8W4:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=SsAZrZ5W_gNWK9tOzrEV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDE3NSBTYWx0ZWRfX0rJnLdv/oyo/
 qrNV7/ClYs1oQZHI+GFmh0ZQzH0zxknmMP0hJQDa6oWImth6zPmS5UcX0imrdcbI0x6rWBsVh6E
 tXVhNI3na5CUiQ5G4v5rT9EBBkTIiNeNKWJKNOBe/sSLwDKlnGazzRB1eYmjWAQTJks2rzni6aV
 w6lIoVWTx2fQqZgWq9EIhR5M5xpfl7K4MdBYAW81o1LdqAMkC+8WZtbOuIBtZBlqHUv8BrACd96
 L8qYujpLcrZ+s+JKi20K2M6V3V8R7wMl5iTgXEa3mCLopmjnkWnRY1TFjgkm14N2RvDM+4B3i0j
 cCDxl6iNA9dify0xbGDagdQuk1qAQxX4Nb8nRxKcWNOQ57P1bhZl1/iIG5rtQaG8jAChwP1ni6F
 MhxL7AYB2v+9w82HAc4Iu0NMPj/3Pw==
X-Proofpoint-GUID: WRjV-_TKvhHMcykufhQrqIzr1Lf-0Yr7
X-Proofpoint-ORIG-GUID: WRjV-_TKvhHMcykufhQrqIzr1Lf-0Yr7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 344DCC000B
X-Stat-Signature: cf73jzn8na9c7y733wy1xb5syqfws7sz
X-Rspam-User: 
X-HE-Tag: 1762913930-844620
X-HE-Meta: U2FsdGVkX1/WSclVEGA6tre/LW34UHHhmaCkj3TqRVZtEkioZM+EmK7mmia8lGEnRO2sEeNoYjrqzrvnmPXXneK7Xr5CIS0UCXzE3uT9eRnoirTmystRYLbObQwhwX9tC/ZF826Wg2v6mNrepo5IXCQblm2FAao6qx2NzE+VJdNXidX5k4fBwqaDmghTRVyCz3pQIxqqU/OhlEbaTDUu7ogIoD093hpxmUJXQ65cAGWc1emwO2q4k8tYI5oVbMVnnzgRqrs5Kv5OYGDuwTC16qk8s3JrBMMjco4E8mPuf9kb2YF6nBZfkuox1ReDxWBDkPmk3UBo02ntpoYsOuoDqH9A8KsowWqJMDMxJ8SOdvosqf8kQvLXDGfkpr68it7zBDFtN8Br9qPL9k+lA2Kk6eS+JxktBD8SMKaphWrWB/GfIA93/2G9wG08Qz5ffMfx/hvtD3wbsvcJps1rPqRvelelEqAaNgC1gzwsvYuhVsE6bg7am2IGPSLj+9H0mV1PX2z7+nrhqIISn04uKJRLPmu7qh9bs4iCMj0QN/CQT3KnMFpGUvloA7Wi/jQTRno0rYo6CL0jG2DsvPyt9CJRwA/+tluG5JRENydrYEGqWBCt8TnY6QA4Rus04I/K/UvCtg0sXw6cnZRPHFgaDrbe4ZP7rKJdoOEUaGCz+Gs2WijTEJhcAX4SP1wrzCltjlm+d/EdJ7VeJSB2rYZMGBiHERwACNxCT+s5l5yE8TGWDmf0ynxTwzn/1DSlqbddv5JufPze61bXiWNLkFYKgMgkZqgNwbccST5OAzTzi95VCPSESR9FakCtFVf5GAXwsJ3JcBdYv6JfdyjADx96QgrFhpW0SkOq+hNe6kdnkXr4q8oloaw+VVKbcLyHX/xAZklqdIz0L9Ur6hiGNZi7Ec52Rm10b5SKjp//LZHIMEMRm1sWDGt/XL5B64tgEkPsi/ZoNSzSAnDOhEl6zUAWHuO
 6e+4W+4J
 uiH/vyX+IO6s992Ys3hg1NGNTTXI2AfGyXbytH0bhYS72/zuVd89r7c7HvkqhfPbq6V0LVRL9Lm8HneNZwMowGxuOskTpakpytM3ql4Zs1ZUnEyniTz5vhSNV2iuwvu//3cKW2FUBZfGehHTOQkMMIgwRvzP4BT4pOkz62sOYotWvjcoFAClBTVb0yH1v3mvzGcLZzLSAbU5qy+OEwoxJB0VOmqXC62BGjqT5SPyQoU8qDBCOhjCgy+DQWHxeQcw7Lo7KJrU3STCv6ZiLWCYYwRhOUE5ThnrtFN2mNY/nXB3DgzEs2PQR1Wfn9Qwy6RaPUCYF5zsFKNW6oR98Sf+x3QvFKFdwTLzquURrvCPb/FAuE3XByFYVVFZqHTWaV/IFcyHWs788gC/wk2HqtmOHX40kWpjEcTIB6DVIMegzjY7n3LSo15s/gNKc2oWDqdvEjWFMUGsc2egLiQnkGNkMjValIbWDREj/p1xgOVy+pvAtAZg6bTsCSBcsqublE5VlzrnykjAerclzLKpERPGKAuqjBIhlB4uEA61y6RD5j8o3wopQ1fPFIAJxrwzeuXYDE8esJNVXbpbMWCrqYg7qIdNOksI6sJitxsDcPxdLACAl7vmJkby6OhsCs/VZ/nv7s/2rtfDnOsrzdRdDZhxdNwC5kwyfzDpYNQCGX5eKBotgKok6/BY7y/UEm7s7YLhFfc4pAVaa49KAVin2UdAC4Mq6F5OSUuomz1dCB0Sy0HdmwCHDCqT81cTjH8E8IPpjt4sRbk7bEhPGFtLICQol+9EVl6BDlMYl+esn9wDyMmMTrTYomvJXX6s9xRW8SZRVfW4zLyHUvjJVjngE9//O1AEyKsobegdQHATN4aWa6w2Y+v7CGIP8iXox0kmxOzlNrY4P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [251111 19:45]:
> On Tue, Nov 11, 2025 at 4:20=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > * Suren Baghdasaryan <surenb@google.com> [251111 19:11]:
> > > On Tue, Nov 11, 2025 at 2:18=E2=80=AFPM Vlastimil Babka <vbabka@suse.=
cz> wrote:
> > > >
> > > > On 11/11/25 22:56, Liam R. Howlett wrote:
> > > > > The retry in lock_vma_under_rcu() drops the rcu read lock before
> > > > > reacquiring the lock and trying again.  This may cause a use-afte=
r-free
> > > > > if the maple node the maple state was using was freed.
> > >
> > > Ah, good catch. I didn't realize the state is RCU protected.
> > >
> > > > >
> > > > > The maple state is protected by the rcu read lock.  When the lock=
 is
> > > > > dropped, the state cannot be reused as it tracks pointers to obje=
cts
> > > > > that may be freed during the time where the lock was not held.
> > > > >
> > > > > Any time the rcu read lock is dropped, the maple state must be
> > > > > invalidated.  Resetting the address and state to MA_START is the =
safest
> > > > > course of action, which will result in the next operation startin=
g from
> > > > > the top of the tree.
> > > > >
> > > > > Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to dro=
p RCU
> > > > > lock on failure"), the rcu read lock was dropped and NULL was ret=
urned,
> > > > > so the retry would not have happened.  However, now that the read=
 lock
> > > > > is dropped regardless of the return, we may use a freed maple tre=
e node
> > > > > cached in the maple state on retry.
> > >
> > > Hmm. The above paragraph does not sound right to me, unless I
> > > completely misunderstood it. Before 0b16f8bed19c we would keep RCU
> > > lock up until the end of lock_vma_under_rcu(),
> >
> > Ah.. usually, yes?  But.. if (unlikely(vma->vm_mm !=3D mm)), then we'd
> > drop and reacquire the rcu read lock, but return NULL.  This was fine
> > because we wouldn't return -EAGIAN and so the read lock was toggled..
> > but it didn't matter since we wouldn't reuse the maple state.
> >
> > I wanted to make it clear that the dropping/reacquiring of the rcu lock
> > prior to 0b16f8bed19c does not mean we have to backport the fix
> > further.. which I failed to do, I guess.
>=20
> Ah, ok, now I get it. You were talking about vma_start_read() and RCU
> being dropped there... Would this explanation be a bit better?
>=20
> Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
> lock on failure"), vma_start_read() would drop rcu read lock and
> return NULL, so the retry would not have happened. However, now that
> vma_start_read() drops rcu read lock on failure followed by a retry,
> we may end up using a freed maple tree node cached in the maple state.

Yes, sounds good.

Andrew, can you make this change and also drop Cc stable tag?

This needs to be a hot fix, as Vlastimil said earlier.

>=20
> >
> > > so retries could still
> > > happen but we were not dropping the RCU lock while doing that. After
> > > 0b16f8bed19c we drop RCU lock if vma_start_read() fails, so retrying
> > > after such failure becomes unsafe. So, if you agree with me assessmen=
t
> > > then I suggest changing it to:
> > >
> > > Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RC=
U
> > > lock on failure"), the retry after vma_start_read() failure was
> > > happening under the same RCU lock. However, now that the read lock is
> > > dropped on failure, we may use a freed maple tree node cached in the
> > > maple state on retry.
> >
> > This is also true, but fails to capture the fact that returning NULL
> > after toggling the lock prior to 0b16f8bed19c is okay.
> >
> > >
> > > > >
> > > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > Fixes: 0b16f8bed19c ("mm: change vma_start_read() to drop RCU loc=
k on failure")
> > > >
> > > > The commit is 6.18-rc1 so we don't need Cc: stable, but it's a mm-h=
otfixes
> > > > material that must go to Linus before 6.18.
> > > >
> > > > > Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.co=
m
> > > > > Closes: https://syzkaller.appspot.com/bug?extid=3D131f9eb2b580757=
3275c
> > > > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > >
> > > > Acked-by: Vlastimil Babka <vbabka@suse.cz>
> > >
> > > With the changelog text sorted out.
> > >
> > > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > >
> > > Thanks!
> > >
> > > >
> > > > > ---
> > > > >  mm/mmap_lock.c | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > >
> > > > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > > > index 39f341caf32c0..f2532af6208c0 100644
> > > > > --- a/mm/mmap_lock.c
> > > > > +++ b/mm/mmap_lock.c
> > > > > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(str=
uct mm_struct *mm,
> > > > >               if (PTR_ERR(vma) =3D=3D -EAGAIN) {
> > > > >                       count_vm_vma_lock_event(VMA_LOCK_MISS);
> > > > >                       /* The area was replaced with another one *=
/
> > > > > +                     mas_set(&mas, address);
> > > > >                       goto retry;
> > > > >               }
> > > > >
> > > >

