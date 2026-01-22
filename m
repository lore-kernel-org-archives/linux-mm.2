Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A536C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 04:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8FA6B00D6; Wed, 21 Jan 2026 23:45:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97116B00D7; Wed, 21 Jan 2026 23:45:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F436B00D8; Wed, 21 Jan 2026 23:45:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9249C6B00D6
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 23:45:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 259A81387DC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:45:19 +0000 (UTC)
X-FDA: 84358360758.04.581E821
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B615A160008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:45:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kw51eDTy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="eE/2gQ8k";
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769057115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ncvg6/5fdjdIcGH0A4Nis3Q6egixoEx1JAfZ2dy6/9s=;
	b=wSd386iqoKJ2zQPIbTns8QteZPpVqGl2dnmJOYKSWulKb1RuWGcAeUT1nr4w6Dc+a2cPbC
	AXX1RpDEkVwqqMLmbXHy/mVsJPA6AVPtUFoWPTIAzwgchrDVMRvA8g9fn3bfUuhE34QVHS
	HY2LVEOAZVyzNCv4vD1TRqBSUMjABTo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kw51eDTy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="eE/2gQ8k";
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769057115; a=rsa-sha256;
	cv=pass;
	b=qZNIGgk3gvK6P5nFpnugWoUnUBds+4hQk6ZRbhmYN8n/VSTf2w9ybWb1C8PEFGDUDCioKj
	ALbR+gfKB76kpv91GIyOCS96k8Wi/A1JbfJEIzCNOdE5y8Gcmf550ofJ0jt16q92cPGucM
	UYaBPTZEYdidNJnvkxrIW356CmPjYKo=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LJVKja3523415;
	Thu, 22 Jan 2026 04:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Ncvg6/5fdjdIcGH0A4
	Nis3Q6egixoEx1JAfZ2dy6/9s=; b=kw51eDTyArpRyHqNFgHzUKU+SdepfjReHs
	kUBvOF85CFkGmGEEYp8pq09Af56Ux4aI/oaG3Q8byxf5HQDMwVapvxXY5GIBvPyJ
	P4mJNO6oGwgg2YSe6pL4okTNzAwyddHNTyKTzQM7/DVkHckfXsdsg9OG70C+gKRA
	TVriuzlYzBR6RXPEEeznNnM3aMAD+4Z6twLTq6B0GnveRhniBs9EnoBbYOe/Xm/Q
	5juWgLR+3ZLrr5QflM9JXxkgHNUqWcaBl2kxgSJo1dsn/6JF3JvjkpeqclMpaKSW
	9reKIhAMc+9h4p0G035rFLfUF4vwYTbyLz7hEwAdDC87aM8/3aog==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qfa6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 04:45:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60M2hkCF008417;
	Thu, 22 Jan 2026 04:45:09 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012002.outbound.protection.outlook.com [52.101.48.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcabm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 04:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=idkH4K852XYb0C5hbcO9lJgcaVFbUIBhCpIm+Y18u/S0QK0t86463NWO7hbji1RUaY4CL41s2MGVPk4Wr05nhq2kycdRSbhBFgIO0SPR3F1SEw9cIv1E9RpdOEM4NULIf/wViTPc2N+0ZiLDWoGHAsw5NexABtawVyGwxi7Bfv/yfiarLUt7rCA/VyWeBJ/zQcmaCzFwYUkhJkuUugVHmjenCi7uRTaJmVidVve/cJYnw374XnAirKA1tH2fZwn6e1hkcUjC+nab+hCZdhiY4DWtuVgkTytDLp9CdhcMzBXGvelpuKjRy8VzV+atS0fcMNVYVgphahN/ZB8nyJW0rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ncvg6/5fdjdIcGH0A4Nis3Q6egixoEx1JAfZ2dy6/9s=;
 b=g/f5wTtGwUcNtHjIL+wDVsNwZESq7TQzhV3TdNL0vyeqEBT0fZ0XqFrHBdFdPDvxvEOUSGR3ywFmn7oTzA388s5ZJ80qXq0NDDt6w9LhUmYpt3FqNl9eSj2oKf/VApCvR3xWPTACLb4z64QGx+wTNu3J4npKX3rhOEDKQEHeNuqRg251tG5OG9G45yPKWAXF37wk64guYKJTJoQTJn4bLwDikqks7A+4FP93ZfCr7S06re6cQHmUMtVqiVfeuHjje4cF0sysGsk+pVSJEWlvxGeUaQ/r/7TWboiEsVCWPg/wnIoRybTNaEf/lAAPFTv9gS4w6+LbowOTS532RxzKRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ncvg6/5fdjdIcGH0A4Nis3Q6egixoEx1JAfZ2dy6/9s=;
 b=eE/2gQ8kBTSafMucaJGn+mOk6ad0WOzFOsF/BwtaIveTc56dJoeYcftQ1a2bQHeKZp5yPwqIAWs8AUpQqHs6fDDbpXfvTjMJPj+KnOAEQmWNm2KSYuP+XSr4tF4G2QIUwCaTFNgLKctaGLBx6fwIvUXpB5t4HFyJ0eFtvovYIRs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 04:45:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 04:44:59 +0000
Date: Thu, 22 Jan 2026 13:44:49 +0900
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
Subject: Re: [PATCH v3 17/21] slab: refill sheaves from all nodes
Message-ID: <aXGrQSOoG_6NdqNT@hyeyoo>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
X-ClientProxiedBy: SE2P216CA0083.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::16) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 54bf9c57-ae81-42bd-0887-08de5970ff77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fvd0DLvDzNWow+vKO5jbOhrTb8Z4z6UEO9ShsUBgTUG+9FSCad7Bul6yoj+/?=
 =?us-ascii?Q?HP0ehGI2ke0MZPxoxZyS546pNjGIkcdTcl8Nco6gnnlc1vmble/i5++f8Mxr?=
 =?us-ascii?Q?GCysxvTMyGijSiGK4xzVEPWhASE6C7oMbufHIVrcSehCOM6yZfQ2LN+r4pa3?=
 =?us-ascii?Q?sq23v/FVYaFqOXOyyUND2dy3QnVeTA4MSoE8ouMV9P6SwL29LM8jYY8CqRlx?=
 =?us-ascii?Q?irzQp5EIJe3QNJ059AdN9TSU6x7xUaEgealO7y+reC8bRkNa4aocMBnNCn+5?=
 =?us-ascii?Q?ZbhoZUi4+Ela9R94XC0fzf1C3HOMxfCyTNA+Jxjqo12oLAs9/HL9mS3adckp?=
 =?us-ascii?Q?SkzHoHbPiDnz8eq+FSwLdiL488kehDZsDb3nbpfuAjFyoAEC1vswVXEzS8a+?=
 =?us-ascii?Q?YzYJhXw7YwthPnutfTf473EAOeiI0Nv4vcJ6jFjQ+lzHCbKujR3seYZGR+Ea?=
 =?us-ascii?Q?XH3ys/0E6ZSMoGQmzb+K0HtQVPObHpHtSR/ZVY+zavsIM+hls6vlFuDbOc6X?=
 =?us-ascii?Q?2kRzkQgNErTrprBeK28UAnfx/RYUvosxP/t+jxg1KpJ2ba21bsxx70aaqKfz?=
 =?us-ascii?Q?OZDt1ojVFtmuZz9vfiSEQJb/EMpKbK0rjnFuavNvOB/d4xGMjU5iv0cptT7m?=
 =?us-ascii?Q?wso4i+EsAbWkJT8/VU2RrUBu4eM/aomg4t6WJVJ7lLZWPQIrb4POUn7jre61?=
 =?us-ascii?Q?itR7ZbHiARGUlFh6bphzrYuwalAiU0K15UKMRyBHZkeaAdY6o70nf64rbVFt?=
 =?us-ascii?Q?8++UFAWWgfY9OXoEGR9ltQ2mUJeQoRgYWIzHYm4GqqqE8JVtCii0vQejLAA0?=
 =?us-ascii?Q?Uj34PkTH6mXK+KQsvjTH9Y+rOQBevRstiAikZcN3FapRcsab4awZYY/89Ha6?=
 =?us-ascii?Q?qBm2Zay6/pP1gZ3q6HVWeyub3wuhZdxCuBgFHyJhOAwWWtLW7XrZf8IbsHeG?=
 =?us-ascii?Q?Bozqzpmj6mdhgKxVWyfjZxTw9SscZLMGySLDAcZYVepQ0DOfdikpkVIK6KT1?=
 =?us-ascii?Q?uCB/cKDevmlpBnlBWet1NnrY8EfJ2rdK8n0YElxHYCeMrkYSTvsIMUu8CRoL?=
 =?us-ascii?Q?JlJKYJVGAIPIhU9lUm0o6p5n917JkTXOesIw/kGGNAA769ZJTCyTUsIBPqcP?=
 =?us-ascii?Q?Q01Boi8czYeoovVWcYVJEVaczIvhpnfjRfGq9KDnEHOXnsGZv1Kqhf+78YRf?=
 =?us-ascii?Q?daaK+r+GNIryTv+0jokVzuON6a64FUfF7Nwkt/eZQRkiIQMQjOVvDK21E/Yw?=
 =?us-ascii?Q?1rTVFZdn1EY8x135DALs2DX6JTRoUd/YvnsFfdciO1BuuV1hBX/op5paGUIL?=
 =?us-ascii?Q?2TxxjMZmrByZgIgibrGRAeB63dpxbVpFyf9Q5dlYBOKt6yVvWyGQy9mlH9yj?=
 =?us-ascii?Q?wG23hNW0L0TiSfj/R96dZkVCWsyXxhVn/ezFBj6SydGmOvEZ0tLZ3IUQEwkS?=
 =?us-ascii?Q?/nV+S91VQF8fIBIJN95V47+feCHS2kvjqXSWSqe8u/tWk3/pvGFGLsjpmm+w?=
 =?us-ascii?Q?gL1HQM5Bq6vGr3WwYKjdMqUZUSIrpJUPF5ov7YbV0ucKjBUGMTW8jqLOtDGM?=
 =?us-ascii?Q?8LhNNzxUsTiM79WOdm4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ftHZ6JZhtgeFk9RrapphdwbwcRVER2ZiJUvWtKcwAaAZyVfnj5sOvaIeX84R?=
 =?us-ascii?Q?sza5/P+W7xpfM/HUl7u80/Lhr9OYiL3HHIWFdj7rmAraKZE2CupdXAkGeABc?=
 =?us-ascii?Q?med/ZcezZCxlnskZ885r4cPhQdF531ADSkY4lh5QXlpBtabu0DP1TyDV27iC?=
 =?us-ascii?Q?G1SKiNqe+32CzC0+n7iI99LJMxIOLAfmDVfMowY11heh5zmKl8VgimEXj057?=
 =?us-ascii?Q?8LIVmUBi0LkbXlzRazc4p5yfycKvz5+0RTIBHfbgutOk+0Vt0cYedJ5rOVWe?=
 =?us-ascii?Q?Ef82FrkTdCSxz2dsXATMqwNAzdq5PoZiuF7/EI7BGfrl7IZaj2ZIaLxKzFid?=
 =?us-ascii?Q?JvetTtD6TWwPKVd2AmH9orgdcspJ/EpVVifQqPOOwhOJ80ZY00i9PyFNbDDk?=
 =?us-ascii?Q?td5ygDyIGE7rovh4Y5EjavxaoOm8hoW5luxpObVtpigOlGH6XJN+0cIFEryX?=
 =?us-ascii?Q?pudZ89GLAvcHtlb/uZa8+gyvzbbaoOLZDGV9Nyanv5sc8vbq/tnoIMq4qiz1?=
 =?us-ascii?Q?vTsa8K5VyU498kDfrfLpwKP0bLPQ9Th3kWm1j0jJk7hZBP1ULNclE1KYFump?=
 =?us-ascii?Q?4csNZdxhS2nZFVhnSj4p0HoHlUwxiPckbluN71Wus4wpjhD/gHrfO4otihNs?=
 =?us-ascii?Q?FJb1opWBQjKAyyFfuODVceiEIBmiJ47Fz2EH7CLNUznzN9FaK+CG0AlAHny5?=
 =?us-ascii?Q?CviRADPoKClFg4tFJwwNFQEp+pIp8icJS6Ubga4uhd2FMFFvSNKFj87jt7Dk?=
 =?us-ascii?Q?qMq34OcF20AoXAVg25Twf/E4twQpGBeETxvkcfxkRu1X9YyZxMLEJbDlKwuc?=
 =?us-ascii?Q?D98uyBMTmF5g6ARcQG7WX/dVs9DQC+40DJYG2blEmTTht6TYw/qbsL4FLLNc?=
 =?us-ascii?Q?fAtRwbyNklf6QFUCAQqMFujsIPIE8+cFvB8vIIdooxMbZX68pBvfWlrgHJOt?=
 =?us-ascii?Q?4YPGt/ONw6fiG58fpDy4bBFdSgd/Z35vBWtm1wDSOxqKglP+VXcdm4YftLg6?=
 =?us-ascii?Q?NCsRZRlQ4mYm5MffqQB0AjItECBC1iV9LRt5PRHNRgUFZvo710rg3aHDPtqq?=
 =?us-ascii?Q?8Mk5X1keosJe+m5+4T7RH/JXlQkwFLA1HR/ZGsFUpfxC58IUUFY8AooGWcgi?=
 =?us-ascii?Q?TsrVOd1v+TxJe3yQdXtOlBGoGz+Z6aYgEHBrvca75uFbFq2/cobW9HZE6K+y?=
 =?us-ascii?Q?yjvIm+odZRSJP+dcQh9nfjvnDhQU3mupAUGujR0RpIo8oV1bzINajDGIhqyx?=
 =?us-ascii?Q?KkrLBeMmFF+df5egZCSmfMtCLJcpFBGbKcNVuIVQCrqfX4K2yX24EB7psKFE?=
 =?us-ascii?Q?WaUByp0jYFoH58u6UIt7sjixkN5gizSKtrB4JhBqe5NfY1AEzYokVamxmGGs?=
 =?us-ascii?Q?yFOZswsnM4h+W1veh2T6/ljHZCm0p3OtcIDAG/ibfZy0omWfm4hGs6jrnYoA?=
 =?us-ascii?Q?UJCNKkb+N0eEugJ0tckswQcj2GXiuqm0R6FzCzTtP1UCar3+bIAsCLoXS7Pe?=
 =?us-ascii?Q?MXkIgqkPgcMgvzpmekSIiNecZVXkZldmCa1p+N1x8rXAf4+uG/YB/24Cotkq?=
 =?us-ascii?Q?6wZ7qbzNdYRQ1bh1HLnglsrrh7QQPxxKQjshpgUg9lgu8vKOWL/aB4419XsQ?=
 =?us-ascii?Q?Yh5KtpsIGzBWrTRABgrwoO8HxeWN8cXGWnHNjchilBMsImTEgQEWI5Zy7ZyO?=
 =?us-ascii?Q?nTKyrh8NSTf2+NfxeYn4TbAQDFQU2p4KWQ82Idut8ZUUAwpH5rt/AlPh2O0O?=
 =?us-ascii?Q?nYLApWHrsQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+2G/FKdCteHwIRooy4HoEGNn54Y2GnQjHC+W5vF4sqFzV3/UNEJLUaf9u8pFT9M3rzNVULLWeC58D5uF4tsE2iigAjIoRbTYs9ZmkbsFGo9qHq9ElBk2BW2yE58sJATq90IAKeGeOn7luQLl+6k9teUt48H9/nQwaNliDBbkA3r2+MdAh95PMEBG2mp9b3jPMYBKD8PyH5XZScVsssmW60nMQjlJhWiRt5gU3r3UD/Fk2wDUDYT79ayORhEgZAbGbyXRt/EkGIy0R2OUJRUYWyWjYgnhJoOg39FFrTy8HZLaqy9CiCCpdv2gCC1ezJkvIcZR9CmcPn/bH65yoC4QJxTvC+xoszhcUdMFq7VHu9sgIInmmG2eiZMMT461zaxJRW9AQbUsUCvMyhkEmlk+NJjYGACOISYkZ4fQkUdP7Db0K8Rl0fKTKKoFxBGBxI8on7uLGjydF749iGAWfPCRrS6zhd9DYb1cfml9QBQaKT0Nv99TBLUFVd8GSWVkll578NgMnUwuJtnpHiFkFJVyxcGnpg7NkWdeBx6WFQAxIGDAZUoEs2lbFmzkq0XUot+aHSAAflR9BwoYhqnmkgMAi8JCGB5HVczHCfQxoBGNvsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54bf9c57-ae81-42bd-0887-08de5970ff77
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 04:44:59.5654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqsyLh5mNnT93/sreV2kUjms9aK2J8i/uXnNlmMiJHoG8FHbsEVuANQv9PGyI1a5n64JuCFqv1E1rX762DlpfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=843 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220029
X-Proofpoint-GUID: pfqR5dtG5zn9GHfgPlYs2DH2Meii6YxT
X-Proofpoint-ORIG-GUID: pfqR5dtG5zn9GHfgPlYs2DH2Meii6YxT
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=6971ab56 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=OFLp2U7DW1u7eWAI-QYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDAyOSBTYWx0ZWRfX9rc9vgYyA3iD
 EeJw/tPlWHUDcV/9HNYCinqWKajMEw/vpnD55lLYl6ZLgCgAQmxXXcRQtPc1qv8yx5frT3GHp0Y
 NZJ0ramAUNfATfmJNK2GcrADFI741qZRJTrkNiyWt72HZpijpkwo0B9fg37JuwLeXXUAdEIDBoj
 TmhvK5MXYHQT5MnwMHx62NPb1n3lH4qvOnU0V7wgDuAvDBUkRELs5FVOr7wwc7OreclB43F9lYF
 zga4cruVBkOX+cnwkIer3Z2z0rVu25KTKzdDqvXTRqnJwn2fZ3WBDqjNyDhD2wKdcFablu/5Gfm
 0E77D9AWHFFLnjV0iiy207RU3Z2HCF42RI47l9ywohpbkF1Qeeu3vtfmtTKjDJP28i8SK91F2X+
 8HDFGKdPAYRa3HW++jwoY0FXmT7Yu7l/uqW38p/D8FylRHz2jtrkWapsRQt0R+IG/kCOcACJ+Wc
 cLDjW2jRgUsulvgnvng==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B615A160008
X-Stat-Signature: ci58omji6k87qwqrchuxa7i93rhxp8bb
X-Rspam-User: 
X-HE-Tag: 1769057115-583758
X-HE-Meta: U2FsdGVkX19L0ZphJbqbnNKdHu9dmKDjNyfnf1dpWFmyUFfQzAfMlLPJOvVLz54lbRSHw8uH1U6mrRZid4IYQA5bGsA21ltvWpABxZJG84rVkKUJhSBo0hQuoIjgpBrXarQQNL8mzXajP/rpWRJd+oH40TzKpSjMMb0yq1bh0Ac8m9OLj6gebNWUWgg/RPjOnRf4qJ5W5VkzpminR78ELDWsn5u8GvoHdyd28RmMI4rKjCUpBNtKir0cuuDsotMHAL4So1qi4kwbD2Q8sWQuC+MT4LfGc6kpxcglPMgqaUV7R82nQXlJayMruty/UDDEYrxWZvxBx2BMswkMP3RYddOGrY593+huUmU0tTCUZqrDjcYAAXixqSQduHuni9TUBVTEhJMYyv1yqACxP1+NM6FDs2UujW1YK7me37CzxbsfSAzXp0YDqJlIOMj4MbzX2oBLespa4SGbCqOsiZIND3vRlNTpySlrvbj8e0eXs8hwu5UpItttybM/yeaWeR/6BNUMJS2OsDC09gPXewTJrvmNreIgbT/N88lf1F7NOWTxYmPdKTBtNQaGxCbbStCNG7K/2JufOjrrptrlQipypes/nS5uNqnSsjLJaf2/je+U0lxncYxuTmgFq/NCwqOZHV8Zj8+cyK4GJl2xzQyU8V5h1J3ZoFC4fPW8whgFECs0WD4Nv9iGS+N7Wr5mRa6gkkA2KR/yQAFDHMe0UgMNxdmaS1HLjQKadnrg3BTQcfHQZo7AiY61dGX3kznt6vrRj7A/uewPruNqMiXLro5WSH8bw8ffQUlEUSqbjMOj+2vA9c8XIphVVBISJW343tfL2x3jnyubRgIedMLEVAf7qtLGppM/z8m/+2vZRVBKr0/genpONaFMQX89jUSkt2G8MmTKZXYx9c7GdVpvcjv3yq9hLM+Vq7MKui7K0YtaJusFdbMkYkGaB+nZ9L9iLSgHIoOXMlZ64VffK+h2ZHr
 5w2Yzc/p
 SqwtNnpMhnq/SzWvv0D/B9fALvWnFBn6m/9A1EmKk4z5oQnhgzkUBXLHF9EVOiam3dKIQ/y8UPq5K5n4PvzmNPb/24+HlP4WyMHPtCz4Sd/Dv+mFBghUnqzCjO6wTetwH4aOziZ5dOrckJDX9z4wC7qxNUFJxg5F5qQYEIhbAbGTxmYBeTkTf2Td5JBOD7CDxYPyFqK82F2CnvJvDFRvFEg2B6Q1G+ByJKDl0BVljQVBIMMFFQYEbkaPx8kU17hvmAugPY6pMmNG7Ml/67WEsG54k8d8+ynsSW8uzrZkiEjlR7Gju1nX9AhAweQ+boi3AYJaMHTIzDrfxOq0JlK+I6HQmGDZ6adn7KW3nJJ9I4kcs7qshfeo0jskfBtFeKcIO69Y5bpz/riOfInyGztAxVWrtAbE7KB6AtXyHCIdsEph+WtJlZqfJHwtKiUb7F1rnNlr0vcfBW+vZV3F2Lk0x1D0nSiULbVuXqWUIx5s2aP/ROFSLITsHooFBPkMculusX/iLrQyFrhdd31zQ8G7oPjzLHRo7oWsAWDM8l5XyxcwqQgps9we437VaK/mU28adV1FyCneeFQ5rqmaX/DMirguuaqFsYlQ33f0Y17aDACvJ/uC5BKP58fOjAuObXk/jN5GjaEt1Y24FtWDreoWB1oUH8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:37PM +0100, Vlastimil Babka wrote:
> __refill_objects() currently only attempts to get partial slabs from the
> local node and then allocates new slab(s). Expand it to trying also
> other nodes while observing the remote node defrag ratio, similarly to
> get_any_partial().
> 
> This will prevent allocating new slabs on a node while other nodes have
> many free slabs. It does mean sheaves will contain non-local objects in
> that case. Allocations that care about specific node will still be
> served appropriately, but might get a slowpath allocation.
> 
> Like get_any_partial() we do observe cpuset_zone_allowed(), although we
> might be refilling a sheaf that will be then used from a different
> allocation context.
> 
> We can also use the resulting refill_objects() in
> __kmem_cache_alloc_bulk() for non-debug caches. This means
> kmem_cache_alloc_bulk() will get better performance when sheaves are
> exhausted. kmem_cache_alloc_bulk() cannot indicate a preferred node so
> it's compatible with sheaves refill in preferring the local node.
> Its users also have gfp flags that allow spinning, so document that
> as a requirement.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Could this cause strict_numa to not work as intended when
the policy is MPOL_BIND?

alloc_from_pcs() has:
> #ifdef CONFIG_NUMA
>         if (static_branch_unlikely(&strict_numa) &&
>                          node == NUMA_NO_NODE) {
>
>                 struct mempolicy *mpol = current->mempolicy;
>
>                 if (mpol) {
>                         /*
>                          * Special BIND rule support. If the local node
>                          * is in permitted set then do not redirect
>                          * to a particular node.
>                          * Otherwise we apply the memory policy to get
>                          * the node we need to allocate on.
>                          */
>                         if (mpol->mode != MPOL_BIND ||
>                                         !node_isset(numa_mem_id(), mpol->nodes))

This assumes the sheaves contain (mostly, although it wasn't strictly
guaranteed) objects from local node, and this change breaks that
assumption.

So... perhaps remove "Special BIND rule support"?

>
>                                 node = mempolicy_slab_node(); 
>                 }
>         }
> #endif

Otherwise LGTM.

-- 
Cheers,
Harry / Hyeonggon

