Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B6AD358D1
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 07:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D9A6B0088; Thu, 29 Jan 2026 02:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82EC66B0089; Thu, 29 Jan 2026 02:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF586B008A; Thu, 29 Jan 2026 02:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55C3E6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:21:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E269C2C3A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:21:30 +0000 (UTC)
X-FDA: 84384155940.15.95B9840
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id B538F40006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:21:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="O/mZLoag";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=autX06CZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769671286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2Temcw+yMYlK99d3VsDqesBinZkWsuJl7w8QHN8zHU=;
	b=Rihq3/QXK+Rjd6TmYqX47Dshh2gpFYMXRRtBpD74uuAA19LinqW/UOIp2bryXREg/gA4+X
	ToFwCMt7KjODL1hGr35/juiHjwdgNFJ8XNtCYaw51K/zaAKd/mecAAkJHYOYzGerNa8uHd
	uzR7cVGWwXl+g2LtxKPk8MSniJOOmjw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769671286; a=rsa-sha256;
	cv=pass;
	b=4ujVkGzJoTezIkMBwmpm1+SD3seK4px9uqNvS1jJwHVfQ06riAH1aYzUOakXY9qYUEFKbV
	OtmieFp1wDwGULhxOwB2a2mLQwUmRUo5FidSQ78Z9wWHEGus4XQdlRbUYJqyBJlMGpcAPk
	QVtMdlUYHgnC5l9inHndqupxah3qPWA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="O/mZLoag";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=autX06CZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60T56okT1337323;
	Thu, 29 Jan 2026 07:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=b2Temcw+yMYlK99d3V
	sDqesBinZkWsuJl7w8QHN8zHU=; b=O/mZLoagHr8sCI/3I9jXwZuOFJ4moLJtNT
	bc2qFYV1tkN1YJSCMj+9qNn7uPH2dm1sW68DpgETMVqWRiZOlPGWz4W7yjBwNQAB
	NT1v/e4xSzi/6dT4wlIINiF6BY/1HXwENWGI9AGJVhDVqN3/C0k+yzvc38hpXR7A
	CH/1a+EEuLAQBvw+FQjwqXBJCXZsR5UBnt0aHB3ZIU2fZFIyJYC9qpRKHSCr2qyW
	NKPw4LRh6jDBMUUx8hWkA22YEPElTqlIGKnz16jBlWcnkt9LclzplbGrJYT1Fn9S
	T3PUguf6awjy3/CoMPWwF+yMX+JIPkQ5vW3rs+5xBO2SX+yRf8cQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bxx09kddk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 07:21:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60T5L4ND036037;
	Thu, 29 Jan 2026 07:21:20 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010064.outbound.protection.outlook.com [52.101.56.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhr8tr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 07:21:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eUYRn+yogGNxcb7yOpM58n9FCcKIl1IjmVXi6ri+8kvgIZ2TL3ZPQcLWnvkrN+eFiMF0tgWLyk/41g5+hQgVQCBJD8vQQGEWMzBYOcrSc92DvTYIw7GlDxG1HiMqewuH36VwUlM4vdeeEealWKm9dz/B2nss3fvfy3sCwmXMr28DsTdoTMf3l8QslYXbk3HHGERUNNyblAoxbZNIGpBOJopDrYliw8rODhHAMnbSMklmVCfMzH1RwfZiyo/oNipCGsFCI4YVp36AJNd7funUPWxnWzROdfJ87EOYHXoXFd+fbfvxu271cr15DEtfie8wD4bKgOqIk4ogVeu09z9bsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2Temcw+yMYlK99d3VsDqesBinZkWsuJl7w8QHN8zHU=;
 b=TGTZma5Ma9lt7/Fba6bRtYaBMjwHgHCPjZrB98lV6VA2+391JnUNjUViYBaHWWr0gcmuesfXQgS13LgVSlF10FgSRr7qE3EaZzRtu1S8rrSOUbL1+uZ1rjHJR9w7SvZpmp4eHPVIH9fdmXVpmeIEzRiM0Cj/Fa9DN6B4CSteOyIq/AkOJ6ME3Twal0tKFZ0Ul57y7buS2ncOWN9fXwQw3pjP5aZEEkVHDHPi99gYCJHUutwK6rinCNqA0+RXq/AUaY7JP5UMYpYBWeG2t0IFxIeG+8uon8RLdPfIq0w1c5NUW71c3+adJI19psIFIjYwSJPX1K2iXnGjAGshXriLyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2Temcw+yMYlK99d3VsDqesBinZkWsuJl7w8QHN8zHU=;
 b=autX06CZQAae1P/vAnY50c+ZiOmI+zqLy1Sgt8jN2DdmJz4at0M04jEWnjVDErzzv2Ano4Kcnf5+naJ/Vxmz4OTFLnNy9k/GBsKthkDx2d//wOD7iPpmVYe+k18qX1AxF5ohdJAPGBnUOhks8yPTfVIZedmvaICdgIePwNuvO0E=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM3PPFEACE3F2B7.namprd10.prod.outlook.com (2603:10b6:f:fc00::c54) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Thu, 29 Jan
 2026 07:21:17 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 07:21:17 +0000
Date: Thu, 29 Jan 2026 16:21:09 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 21/22] mm/slub: remove DEACTIVATE_TO_* stat items
Message-ID: <aXsKZStTX9oGHVyf@hyeyoo>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-21-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-21-041323d506f7@suse.cz>
X-ClientProxiedBy: SEWP216CA0004.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM3PPFEACE3F2B7:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b506cc6-32ea-491f-4b2c-08de5f06fe1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2KnE0+9UuXCMWQLWLJ9vQo7ZO57uyi+0n37xZMUU49RuWVKr7Vy6HIUm7nHp?=
 =?us-ascii?Q?D+rwXeLLslG4biRvcRoBFRfg63cg3mZAHURAzSU8BFmbGJoZGXRs0UXo8t92?=
 =?us-ascii?Q?tlHlq/07KFyOIj5JMYHOzRJgVKFF9oUUuuAaVlFAzdybBfvKwlg5JqE1H1du?=
 =?us-ascii?Q?tnH5OoiMETVDH0VauKAtqapoHVjw6MKvgQId5jJO3beDg6DdHQ0RSPcORoir?=
 =?us-ascii?Q?yrb5g66VEzPlhhBFYkWuQk6tnw2ADofXG6x2WXuUOEc1IIgA3I31LEdudOkW?=
 =?us-ascii?Q?BhrQCudLK3cUkvOaMoBMFhDOvB3dbTxx9Iqli1sUP8qutt/7uSdg7vqlb80n?=
 =?us-ascii?Q?xMttEzdYv8lgR1JH+ebvb2ToI355IscbHvkznMM4ZzbYcpkUD5iKHbpN3uhA?=
 =?us-ascii?Q?Jb/zkgLVqz+4yck2MQfPAxHJ3VT8Z97nzPj8tRn3XC9bjPCQKDX/GsRwfqFm?=
 =?us-ascii?Q?X6k/euz7ur+e4Z+gFW1Wyjkg0TA1MMs3nSlWptR4B/rFPFSpHhIsrJNsiO2F?=
 =?us-ascii?Q?6Mcd2XDMKQMvQwC1rIoV3w+1jSBma7tEY62NsWiz3YpJ8D+b4nT0c0Gu6VIY?=
 =?us-ascii?Q?DOaNPmMB9GaSYd5dkSymU+Z/DbAPJe+RGaNhxxdS5IP2yuvh9PN81rdFf0g+?=
 =?us-ascii?Q?cQWkNezmqZ5ep6xAJLbajHtbyPnVshLHSI/cSZzbB0c40H2QUYl1T45xuic3?=
 =?us-ascii?Q?/f5uuHWgaL/NtuW7/q1yD7h/YaUFopZe29E7jmc4ASPP+d82c8qXGUAeDC5O?=
 =?us-ascii?Q?kSJsFX9ztc/cwhrmz02CeGFkQGp0sA79Fv82o8NoEMQRLx5JWD0Nuhg/NI14?=
 =?us-ascii?Q?8Z+7exs1dvygOZUPUfqomW6zjTsBd2LkrVHbZpXIHWR2y/lgmZJVval8b/8R?=
 =?us-ascii?Q?brha24DC21l97NwQbXAX9YA5UgupZxDufvP9APED+c9kH6yiL++KjRk5kEvD?=
 =?us-ascii?Q?sWI/pBnPgov4X7MBEnFVoL5I5xsql1PityoRY9Ym5T58YYcibhnWM3dzkxVZ?=
 =?us-ascii?Q?B4CBvFZ/uhC19CeV1UPj/Y2SR+8yyjHn5qtHUchYjUrbx6pNCz+WZzdAcXBI?=
 =?us-ascii?Q?Jp+I849aWtH2GTQ4VxF73LpLlJR/+9Xbf/JaFXLSiLs5EFc5fyrpMFpLKC7s?=
 =?us-ascii?Q?wjGNuAkxRzMz58XKB763oHeeglWzAW5fPzzK9hxWRVs8CWh4P/5d6w+LdWN/?=
 =?us-ascii?Q?r//9QVXbPxaFFe/CHgQ1eROhokQkbS0dIkZrYlo1DlUiWBnvLf9NELnMTrx9?=
 =?us-ascii?Q?sgQToYIwNgnqvYbn2Qv4RKeVeEic4E4rs4HwazaiOevfXAPPrt9E4gErA6Lf?=
 =?us-ascii?Q?/Tpgmh0BqvvKgJ3w5BAmz370RvnIAyE4+U3YJ/efemTEJyvz0RWUzac87yal?=
 =?us-ascii?Q?Cne6SYbjBip7fm8aSPwmojI2wpNAcr85Glc7vy9X/5NhrIckOqBA37+I9OvA?=
 =?us-ascii?Q?O9RVaBI9IpMfJk10G/dqlESNHxrIiU0SshM+kJa8qzfJGiHKqSLtu453ng+2?=
 =?us-ascii?Q?IDQFFmZ+KRq8rk6OyFXctNAtvxqAXrEpbOqnPpNJfZYmnr6s28a7Najk4M6u?=
 =?us-ascii?Q?L/NtADpBr0lwlne/K3I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yuRDA1Pt5zWzXS8V1eeAcFvUWrc9fdYDKRxGpLu81wPOmI72hVon8LKn1UFK?=
 =?us-ascii?Q?13BO5JR/PwCFW5jHKUoQ+tCDaEPGYzjf5yw89WYIsOnO9FQxHaW0G2R417ay?=
 =?us-ascii?Q?x1gPMOfQMwNn9g8xG8kMUxAz8DIpBannEHtytFUB+lrCCM/5M+Xy7TpbuAza?=
 =?us-ascii?Q?MSUlD0Fx17k4PsDfD/xivQM/OQTJzwz/GQPuS0j54gozz6HT9DXLomUdSO2p?=
 =?us-ascii?Q?KmEVY2GeDVoSvPsOYAXSczv1alE4DRf3HmeQCmhKJZjch+vjLbM+MMfuVLnc?=
 =?us-ascii?Q?KbKqJ5/Aq0FS1Juxz/TGezFmlrrTtwx7aeiAcjftagQFNNj+KOD96iYLH5l3?=
 =?us-ascii?Q?8S04PLH8ChryT4xRns7fFxxhdR8Xef4OwIuKz01cToWq6gsktvkaVEhSVX2z?=
 =?us-ascii?Q?ve2yPAMHTffyGjnSYUbLozzokfb94Xc+ObAhWY4ytQuV7yhIzcJJZ0Rfwpwz?=
 =?us-ascii?Q?SIdphAq5sv8xhczQr3sQEfRMc99TdKNkcn4cCLn4kkOhOLNcyM2SnM97Wh60?=
 =?us-ascii?Q?LWceB5QU+w4wPbC8RCqcsL6dkVOdqGjln7+mc+I2U5smAbakzDbdaPGKeVmB?=
 =?us-ascii?Q?Ru8X+joLs6W056gsUCVZqmhmtFjkTmaF87tRU8uksz58t9CNwWN4d73fny1U?=
 =?us-ascii?Q?zCEskvVuvriWdA6wDCLFw7OiksNDDtfQ0VczsqzSQdaLTyEdtAlxX7ajL4ab?=
 =?us-ascii?Q?/PLsiG0JJHmn/Hd3qG4aP8KklQRcDtJpuFlhuBEXOGMm+COwZht8DYqMlnfJ?=
 =?us-ascii?Q?Ooqgh/MU7nq7HM/4ZfiT41mRO/j84ZRmCiGTAPZKnvsRt7baWyM9ME880UOG?=
 =?us-ascii?Q?mMqPI2MLT3I8yXdKgTQZhQgjEGNyNyo5T97CaePp+DA9IdnKS4jpPFBBmj/V?=
 =?us-ascii?Q?16xAMOklPs5bxKDdG1YtOyGZs5FsLNqs2piAz9UrGe7Ta9le3Zt2ecStiuuC?=
 =?us-ascii?Q?UZirHDo0FBopGCne36ASD1EMndjnSs/5a9aI4xiLyHMi7VHGyliU6OJJm/jw?=
 =?us-ascii?Q?TMIW+6wUDC7rDgrJUEeqnBxCdOi+xDQa/dIixqAZBrvfbP5Q9/gnl4OqSGmh?=
 =?us-ascii?Q?S+K+qXbcTL+lIsxGa2wTp9HbXD76MaiZat0Fm1SJKT3dEZAbexFmVq9+/QuC?=
 =?us-ascii?Q?S7YV4VZntoWM8lAQRNacG1evz4IBf3xKvvEcM+5jeq7q27q0lk6lDYYY7DOE?=
 =?us-ascii?Q?PHxeyeDrkHpegxCsG4vOrBQhDog8XPZ1DVK2rg6E/YxF63g8xZt2DWlDSybq?=
 =?us-ascii?Q?1X9wNvmf2NHF9ejd6huRvP3tFjkqi/qJ/gEB5saixcx7rSRMCllJjLqM1EKK?=
 =?us-ascii?Q?4NYwJpVQRKwz1LzJomzyCopMda9ZJeJrI8r7J4Da/H7UYde07iNBweFwlVAe?=
 =?us-ascii?Q?Zg3EhP9AwAOS8chE3Q/UjcYBxWjr8WFA2kZ7dI2PRxjPinJuYlYMMqvrAD+E?=
 =?us-ascii?Q?qHuzrwZdWc5+jT/SpwK5Vvigo6St0lm5k1l+w5drJ08vN6tBF3YmggLehkqj?=
 =?us-ascii?Q?uVu7WmIZ3iK5ydo2nR4c6qXeEGbd85XUWQdvqlXyYFN/Ak8VE1QlDzm0C5ho?=
 =?us-ascii?Q?4d0Hv5Cr3joQsNrsebcLP6AlJnPrk9+wd9p0hMBCZ4JS/BDW+Rzv1gAaCNF7?=
 =?us-ascii?Q?1zcx68Na+eGwJMKpx1K3yWXXE058X99I3Ib/y5l5lKh23nu9erlfwigE9oNn?=
 =?us-ascii?Q?ruNso7WA1QeOce1MBbdcnVN8YIFCf3LHB4mizMsIOgANqZI2Aie0MEDUqjno?=
 =?us-ascii?Q?8SX4n7Xzqg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ah7fGxkpb/6oh2TlhQEjiYbEoFBS0n5GePaJzxe/P2Ma3YOkoAwF/e3BmmlsstB/CzTnyq84+iuNQAy9g+8qCjvxFf6zRhKIs0avI3U9qUWOxtzAPwhMNq0qdETJ8VjxFfyGJ4Qds1Ejln7DrRkEXchTwCgvsk5XF5Ka4z1oVNZ4ehjHW/H7L1kxlTpROfZx0pBu6PV9CH3Wj8v2A83nww3Toa300JMCMxRod+/+tauI7XAv6KxvJdK4Eihrk/hJlcf7LS684e1wXcZ1uKn7wBI71P3pHSIJVGaJfg3Cf0bnnkuU/hAKXOdV3ln5b42Pc30cfhqDdKoU8l24IpTRZFZ9cA7dO9lMAZrgGg9KyjDdVjbbts6s17ICeO3dJP4TyNkIwQ8cqzEl0ZGANbLU6sVBZt/snMUyvrG5/pnFt21GnurC4q+PbyaSZ8MXsNx8STRmn/rTdhq7VW8tA+IYbNYR6mB/kfOfG47APccMD9ibRaQ/UrPS+88JLblL1y/phJOEOSuiz3EHfgPiy5ySkOtPV+F00K8qUIooYA6GlL+4m9HHTPOZFOSTtmPl4c0H+y/JIstZba7gGUZ/t9UgDwsTH0xiCJ7pLRkBrUuxRqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b506cc6-32ea-491f-4b2c-08de5f06fe1d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 07:21:17.2572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1TadAEk23bGlMwNdip7u5i89XNKIV5B5K1M95cWCyxCDV16Tj0YxVaapcHH+wiquQTftup8VwWRvYlxelP5cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFEACE3F2B7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_01,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601290042
X-Proofpoint-ORIG-GUID: s9Ma2VTffzKnFPixOp7s1gm3a7XVAcEK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA0MSBTYWx0ZWRfX6Br51AbcQVMj
 HM3vgz6PhQrWwpwanhJG+1p7JtxrEQQ+ni+FhVK4eUeF5bUoNHLCRNmnmy+QEqvOfbJIYGxIqKk
 wOuS0TXKuS4qSgEf2W4sFChFnfPVmyh1M20lENwRsWshMT+lpVFBFIO+/WXHWNvlfc2/1teErai
 1qZ18TJtHJ52eMHqlpr2le9C9UZwH1tSRl3V2/EmrLtpujoKfZ6NEICNHgN+XtM1qjvoeHC9J82
 ium+iEi8qgbVb0KQzsFJOvuYRVBPkjcVZ7dN7WvHynM0oAXF+MHSqJe5jrks37ZJddxpWcCLLxk
 /5fOl2E6pLGkWwN3KxVF7RQZXZMq1LPEO5Y5V/s8537WQIIDSTuBgVvf1F26yr4fGt2B4x3DY0U
 2G3iHfibTBvFrnHalWH05G3tCor7j3whKFi7mF8v6imc0q1oAODWj4O+GdMNWwgybNrR0Kcqlyc
 kgpBhcvdBDvsrIxhMLixICxL+PJYuM8HCenLXNBE=
X-Authority-Analysis: v=2.4 cv=Qe5rf8bv c=1 sm=1 tr=0 ts=697b0a71 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=mAjCH3kBFYbhTdjNtgEA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12104
X-Proofpoint-GUID: s9Ma2VTffzKnFPixOp7s1gm3a7XVAcEK
X-Rspamd-Queue-Id: B538F40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ufuppqyt499ainz9xbduychny48zpr3y
X-HE-Tag: 1769671286-256172
X-HE-Meta: U2FsdGVkX19IW0ZkeOquyfbDlEenHy/76Ip76P7CwNnPHbJ8ORtE7X9uhRSl13uycnoaKUvKTMnN65qRzpaS+mO7u1MgPccG+gRXxJReY2dQnNdRcq0y1XxEp7vBN270jfBNij8UQYI36HUds6Mfg4Vrr4/2pylYTv1AbJu7gNVTW0mDR8dAoZhhmZvkfZ84hsusZcAY75Hq0C9t14G9ZWDcMpRSOD94UXTv3OowOyBf1pxwoPhc2Lmn9jmpWPb6f0BDi8uA7VE/WkDlvfBC8McGlUTUihPTxsIL8lKHpfL79GmUTE+TsQT6LMIc9RfaLu33evT/YWqtAAPrdS2JcfTuO4Kk8OflgogIXCTILXjOS+AO0t7lEMNdh5C+Y/JVeGR1k6kdTFUSHBINf6wbZswzKNTC8ogE89pC0KSKZHnh+N21MXEV8KcIvTsr4cDYah5WaFVkDV0oCzfEuS6RsrLwKpqRyQPJZDxq/f99DPOkLSzCWFXP598QMOqH0TN/HiX+WkH8vqKsDwQlba6Nxs4AzvZuhk5Lwxf82GMoK/zfhZRk5NiUVYEk2IExkOsWbSznCWWylkWvTT427PP996Q+4m6g8liGp9QT3FePZdptxEnu+QHWoMgXBiCumAjVXMtlje9We9gGI2FlPDq6vlRhQY46dUxifk38itjuIiXKCxS+PdXQJKZ7Rj1GQ1VEW+CdLxHS3MVOXV+hmFNlVIAc1X4RJ8NYMvy3rHZrGE+0rW5aSU5xumlz3Ds2E6vVrqr8Lhe/9GWdgTDOhBtlSWOAiD9Qdwiak6bKrCIEVWkrdKKU47R4BSXloBtKsTRuWrMndx1yWT7dtWZ1q9+OQbZ+Cqf9r+c1ODSlcO1UpDeHjd9V9LN+H/USlX5Ypt64CQfg7/Kc8qD9Tz1tXGNE2yYY7Bqf29vRS7AHO+UnkKqwIbg//KyQbLotkJtv0b1nlIbCXTCOF+cI7mvHymG
 oYzSSh9t
 I0CjROPFGnB9m1OKbuqGObMsYkD4+VEFruQFqeyKWy/1o7WLeTHIzVCYgobvGabwa8PuHAx9xOCqkSZEEJGX/4J5/9rJ8Bozm/8A1q70wVJdYSe81tn1SEz+/euzOCX6Ds7LD+OR+XWNGts7NseHfML/1zrXyH91U6QsfZAwwNXqJOfV4rSF9+tqangCt6rxbJtr86wPirnT5Y23Gqj2mGQBoWo7iIPm317q786Tr5m3BFUFU/nJ8BiHIyj6wPzKepYfaYtJXNJQXC3QtPF9Z1jXiNBsCOn1aJ9U5Wei4huWflGhjFSzkNmC/WYj9i8ws2GKE47OmtaNNxQACkHqFW0YMVabuRl1m18qVQge5/cM9wzJ6WZhKDQqRteBcD5KD1ubIOKt4ch72nVZaCdXtA8aycmItrvWiprQkRXSRuX/HOeeeiQXr9pqpysooLvdRfa97E6z/ko58NwkPYh7I3dZsKrhcIk1zT3fscx9qwhGZPIVBhPgcGHtVR1ZE5kNmBWxKg0fPlVAvZpG0afvx2blWCL3V57FLqH8d/2sl7qeMQAXxNgU7yW/MZ6XYZviFBsBMWWapWYQFa1CiTh687+b0GBPhgUGLdDxkCawOVXpgPv4niNqdC+RYbTzAs6eSpmNCPLtekebL2kXpmGJVKPXsT7gEN/PMviPVJnzrh1fzZK3sIlvbkhbnBg9LWvbLGa/6sQ+HUnVn5B6Zrzp9xa5UymiHqvej04Zh7AJF1dAjriz1il69V8u88J7NWcFJLCa/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:52:59AM +0100, Vlastimil Babka wrote:
> The cpu slabs and their deactivations were removed, so remove the unused
> stat items. Weirdly enough the values were also used to control
> __add_partial() adding to head or tail of the list, so replace that with
> a new enum add_mode, which is cleaner.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

