Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A33EB7EAC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45DB6B0089; Wed,  4 Mar 2026 05:03:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3A26B008A; Wed,  4 Mar 2026 05:03:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80A56B008C; Wed,  4 Mar 2026 05:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4B6E6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:03:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51E621C5C3
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:03:47 +0000 (UTC)
X-FDA: 84507944094.06.A6F200F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id E2B234000F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:03:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U4znETbl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rJMtrkph;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772618624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffQhJlSp2/rAC2oiEg+0K8YCMaTvxd1eFFUdU477084=;
	b=j5EdcHRr3ryT5WE1xxXrhZVI0BJtIa3EQZYXZQ/11f8XU0IWZnWt40bRYQe1+iG/Df1Ra7
	WcVyDo00KMCckhI9R+TCnaibF3zrBxXJSN7LjZsot4p/CT2ucn5u9QPtIK9Y3Qya4XGnvU
	+OGObXo03Shkx8iSBNZfdWLukA2FDa8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U4znETbl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rJMtrkph;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772618624; a=rsa-sha256;
	cv=pass;
	b=zeMZnkVrgBl7HSKedjo9OfWvTWk2cEKKRp0jS3O+3OcvPO0uwkbYGsoOz2uCfxVDBDhV2g
	ZNBrdFMvZdmVR0jqYT5kUaeMuccQfdpTLX7njAL41XNPq79CI4fAe0HcEFZc2BUDZ4QaIq
	OvBQxKusCcI4BD5cLEgqhsi6x06HfWc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6249uWjs2418652;
	Wed, 4 Mar 2026 10:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ffQhJlSp2/rAC2oiEg
	+0K8YCMaTvxd1eFFUdU477084=; b=U4znETblSeSHsfZt4synThCTqSWmeTUZWs
	KbA5BKF0qG9hbX24Yh8n88sXbmtEfI72eyDM38OubjrTW5wL7ECnzWcgX+9zVBYE
	rD8zDXlpgTr2JwBYFsDvpILDbgu48Q1VF7AWZ9owaETQmPk79bSZq0CMesS1A4KO
	ziL8B/7tIOrzIUYZXGFw/CSvaHJZLWkW3+RyTpAvvyog/0IJjI0ib8fFDvIpNmQq
	QreObpkhxXxERkZwlKuCr9rHajx088WRTUUitKDd/OQD9gvr7+H6Oh4I2/v+tTow
	W+f48nboggPj/ri7U/m1e3WweV1fzCpZQ0VfQyTpXI516LqwI0bA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpjdvg17c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 10:03:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62493X3b036920;
	Wed, 4 Mar 2026 10:03:36 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011026.outbound.protection.outlook.com [40.93.194.26])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbb7kw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 10:03:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSNeJ8a2sFhF9gdssQ+ncJKPVOlUjlOd26CIoXzFtKwEKCjnRn0JHfuKgXXWkSl9GU5NBcpGsk1OXcHVRZuHuBTseg0alMxqeKGoVS+z2nEfWVnEE+Nbv5fNOUeldfgs+hIKNLoobgT/2i8yCV3GnbNbLEc0NnMXbUaO0ZXP9u6LXegTtWTG8hkRZ9qNSY5/Rolpnealq7gbe1VIQh+HKvLIp6ZxNJ+mFtTIVZc1bMoAEeYddb9xP2/TFQUVmVuGG8L2y0eI7UJr6pUUuw0TxEN6aZcShQ5VDlB1b4+jl5uy8aUKaLHg6TveZwvpsZ0SjajqzyRsyDrrOEBCvj4q1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffQhJlSp2/rAC2oiEg+0K8YCMaTvxd1eFFUdU477084=;
 b=fFJW4ndBbIHfWgQ+H42ItQwToDA8Ey+FFQmyxVUXdtjA7B/kV+wVC48Vex7MUCQ5fIJHorB1+uj23vAIoJ/Obf+NZ4jPX2aC3AmpJkp9AiKgtKX9FSVOVq3HpB9EcTiWugHJjxiMroWNd3cC1dMEkXb8+gJ5sGeT4B8OsFX5ARItYlFoPKZUg/3bjV2YXxLw8G/4ztrueTXn1EycUegdnp8pbwKmkP4I4FJuAfJiQY+QCzHx5+FezUXH4S0qlbaxPV4RO1EkhHLRV02dT3kwePo9xng2oH2+lV53u0BoXYfkcbzxoZhRx8AMYqvnRic78b8UgTw+r5XqzyuH3iSvxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffQhJlSp2/rAC2oiEg+0K8YCMaTvxd1eFFUdU477084=;
 b=rJMtrkphXw/EyqQkXZYfqQD7CYu4cH6UqQ11IKAfdjdhv/OYYexl+Ls9x5ZYe3gGFBWnie9Cc8EtdQuv6dXGt0h+LLSCpDZuC/k1aJbA5jSHavaIReanYMvIcZ1tHO7EvpN0Dp/a5M5QEVkhkZMV5wMtWNHRahhQIG/vHAPuX3A=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA6PR10MB8088.namprd10.prod.outlook.com (2603:10b6:806:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 10:03:27 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 10:03:27 +0000
Date: Wed, 4 Mar 2026 19:03:20 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH slab/for-next-fixes] mm/slab: allow sheaf refill if
 blocking is not allowed
Message-ID: <aagDaOUvgMSipjXa@hyeyoo>
References: <20260302095536.34062-2-vbabka@kernel.org>
 <aaehb5EwDKygrXGW@hyeyoo>
 <a7494308-cec6-43c7-aa17-a438747b50c3@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7494308-cec6-43c7-aa17-a438747b50c3@suse.cz>
X-ClientProxiedBy: SL2PR03CA0009.apcprd03.prod.outlook.com
 (2603:1096:100:55::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA6PR10MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: e474ed95-980b-451a-9af7-08de79d5477d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	LREEbM2OJohn36JHWfGRtAo6+TvRD8DSiK25td/3NMBSC1djF0eBNJ18wfQKo/vni2Dq9jAQHBUpvBIv5nZFwSZhu41cOB37EjG24xcCpNXOLljKCbEHtrbx3yKgUmMTRt2Fo80H0jRW4s7ryf0kLC3dD2Xh/h7fa2geVLJ7Anw5LDV2ZB/mh4tEgAd38/4sq97q0sPHEom7xI8Sd/alBL+faI+7ntgf2/zTOs14pqW9g3vNljZVDfUdu1AK5+WXbr1hSleE3zK1kmba9ZW0XfUzoHp9DL/4MUbNoNjQ8C7PvjKd0qFhenvCtEVizQbIjbhZOBdeZQUi1qZxF/LZ1wyojLg6pnfsfMX2IJHcKuWjC5HrbYCsqT6Mda/nsch1+e7fh99kFAB0ty5WKalSHe0XHDnDyFWe00ELB216EOCmL+R+BUUDjIZuMPYWqYMgAoc6SjgUtd9jiN8sWUgdoWMJ/l0ny09DlTqPQtC0dthOM1D+L7hkPtDd9J1QF3x1b0i2IJjVDp1JwWoNUwvtRl29tqkQQi/efrELYBRlsmEHgNApsAREOwHN43+gUw85SkAju4BbpUTqLYv5quFHMk5CdR0I8EDXSUS/NbpWb8vj8c6J5UH5JPq1w6lNQG49D89nx6Yn8GDKRlj4vka67WCo6iaeFuUF7trD/26Ve+GwjlvnEqOiPOmopCqFILfXhIrFDNFRS4yJ69TLd2sRUNBQkjrwi45jOGx2k7iyNQ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PnofLJiyMtbYFfgwN2X89ch6BqTF104PEEsYMp28H81oc+KinhajLQCjXPZk?=
 =?us-ascii?Q?8OEZiGRlU9TeYa1hLWDPMIvZ3HXpYKlVDjjMJSlSkPw52ljIvEQn+V/vrqkO?=
 =?us-ascii?Q?urtEPyBmRKLsJZr/vfLjPJaBheyxDfrLW57RDwltuq7tLuTtqZJWuX4F+vBd?=
 =?us-ascii?Q?QW3B7ujJHLzlSt1554f6VH51Qt5a31DI+3BqCkGMqGrWMxtmWMRydyoiij87?=
 =?us-ascii?Q?hDxa7o5oXTU5jXqG9KCUFWBhTKw1LS3ygDcZvTEPnCL3JFo0b37w78BC9wn8?=
 =?us-ascii?Q?B+EZqOb2NCzUMw21QN8wXJYCGmZHTL1jIFdeYlXSajC4ISig7JJ0OlEK/U4P?=
 =?us-ascii?Q?JIgLWdStdMk3/8FNHv2BkkPOQesu333lCSlq4PVEYtw9KaR10tIlL/kvXupK?=
 =?us-ascii?Q?9gJMQZ7Bz09CUKABJoaYgLXmgXkJfl1LGtgKd8X8QXoG4MYIFARaUSWTtp1y?=
 =?us-ascii?Q?zRRJ+IctAubWJ/RqnwrKcxnn8EXSsZG300LZi02BimefK1nUjM351EA/Fmgp?=
 =?us-ascii?Q?aSUqI5hK0XHQWjRLmkfG20JYGDBYnkf2g51yKpwbdAkCpZ8YT1A/0x0BlEl2?=
 =?us-ascii?Q?ErdBM2euBrobD5Dke4QTRi2Gz+fB1IU5BAV18dNnux0gWSYNMXvSaiWOsggK?=
 =?us-ascii?Q?FxFrwTVVdRtvsEtEsSdk+r3UectCUWxBBpktX09Q18AIar2/SrGeahRcwBHi?=
 =?us-ascii?Q?MRVOvqoEBmhrhP60F3nOLqWrd/Z1o8hmxq+wXSRpPCF8jbd0uMxk51Jgh9LA?=
 =?us-ascii?Q?iSnLaW9cf18Caxo5i8U9lsR4aRLrhfiyXoxbZTBdRQ6WSeBZWCjlv9gr/O59?=
 =?us-ascii?Q?rYq9RJGC3McmWCyPTFP64ovULefO8wGVcOW5z6Pzl6Ev7lrEmBwzz0HK6AlT?=
 =?us-ascii?Q?7OlTXpbYpOgTfs/vq2OpOW+P8zqThXhr7Ift3ZOwshgJktFaRIuxwf7Cp3ur?=
 =?us-ascii?Q?GqO5YR78O4t4jnh34Jc4zTFEpiD8YvVHyM1D5ccM2x8oz378gJuJ17oZq1Hd?=
 =?us-ascii?Q?F5HPaSt/95RLTCKh1D0HZKbAfTIiNC8uOjHvXRL34V3VrC6Yu/sjwDtytFzq?=
 =?us-ascii?Q?7WVTpCoP2lam22zaVCkzPvbacFp5zodi/fnDQyzAidEF3iyavdyP3f5/7j00?=
 =?us-ascii?Q?gkeChM2YPFvqdwpYS3QCs2stOprgxu92zR2qqMXblDgtQyC2DXJUFc2DihYG?=
 =?us-ascii?Q?248JmPwCdMPZqi6z2RZPLIR0hOfxuG6nAHeO0Nm1Q/eEe2LSjTPoylbdPKNW?=
 =?us-ascii?Q?FvfmzzqczN46/xj0ZjLC16ka+jMWNhuIoq47Q34B/L1pFuKkCcZpYbqdepvt?=
 =?us-ascii?Q?Iybf+jbLn3rkUrSoEB8kCf2//ztMuun1R73Kxy4Bap3QjX5c7BfB2QwoJ0B8?=
 =?us-ascii?Q?kZMw6X2p7lq78RORAymomJA0Y2to/m0GexIHfHr11bl7Cd67iUIUm052aWjA?=
 =?us-ascii?Q?fXx05/hspLywOturWwGwVOBW0SAaAf2mUF2RkopZX+kEyzJxCXk5gP2xAExv?=
 =?us-ascii?Q?TOTiqSmUsxdobVvAtWMiCDmAOb1BwuRIvft9NhyRX79uK/rbRuLz8/D0IwlJ?=
 =?us-ascii?Q?4aHYv9j6k4+h1LTWAuuPFk+njgG3ugUy40sSNunO5YuYvqBrc+Pz14qzURNy?=
 =?us-ascii?Q?5XMUOhPauzjENNLKiS9Xikg5va2clffYcvBHrS/RYWHFJQe3Be9c1k02gZd1?=
 =?us-ascii?Q?a7i4GvSnkFgW8fDGvNX+G6ldJiR1rHw7XSusyZeDk4vtxOMJWKDD9HtnaYqz?=
 =?us-ascii?Q?NRduwg01ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JLFiWj4al2o21hfxKib7CRKlhyCeY7V1Rs1bxLmEPePE9o0aRFZLE4RAzYVvwwIAziMMO85RTQafusxTzUREJrUo0mglj6/vZblC2HWUJFf+Jn/6j0e9zC+q2dCoH7ySroO3dQR5l8s6T9pV3+Yd9TPDHC3C7jZqpYAQa6nNKMn3yr/jGxwMpMpfhPray0JFRHKMad1mj8I7AiAp9OV6AJp+0bwBFLnVoammph22qL0YQGtt9eXGEQ5LJwm7NXMUVG724DpCSfE8ihndQMliyuax/KpbW8zTaTD+XT5eErJAzb8xPzZZOYsZFGlNC9PLmPjUaNOHPUUCzrn3XqIWXu60Y8L3aL2FEO2s4ERPAt+jCKfsgbLybE9HwNQQhmx5ueJaxh03fzOCu2CkToln78E9WfXkZl/hKUSjlt0nvpTMmwH0QyGLQxrmT35vPg0vmZbpauPbQ710qJ4Upp3ystOILyWSj267c/vXeW0IqYH5YUbS0DA6Qy5O1uXxCRiRocRtcbGzQFBhPJiU4WQk02sVcGKlGd7K8VE0l+0RlVwJefgI79hLH/7KL9caBh1g2u3JOh2+L7tlm1exgpkqutZj1tvX09ZEXkxsn+ZHbO0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e474ed95-980b-451a-9af7-08de79d5477d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 10:03:27.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUBnZcmyuLy4sBzarezp5Njl1SeuVKR/mSSPE/3DYWSFvjzxRNuk4cmxLdHcMYaJP1w/SmGg/WGZ7T2FmPp6fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8088
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA3NSBTYWx0ZWRfXwv5l+q7iggTb
 EeiLzpyNbdVQKsm8TtcQ/gaXQMHweahxOszj6Kg6CtWa4AchA9zlw8tAKznl6qQwNyTo7ybGj72
 oKFLHLqXoVreafrebaKCCMEdgNdTOi4rqF2qTHyJYe532uYLq99a1uglCxzJkD31NUlgEXlzQNz
 DsP25EP+4BQmRWJ71voI/MxDa+5qf4LnknFym3S5mjM2wdyRDoAmIwFR/d0e9TpE1ATg8D7PW1D
 glet3aMSLuVnVHSyZXp7pipU3aI3y1TKIriJPG0IpOsuobaBU+zokTJiec3/jveMIQYdLwNKhkj
 sAKcKD+fh3Iztx4BpZCEw8lmu6BW0NiDVBweZhqu4Zh0DOYrKWgDBHmIsYcHvH/xdodZ7DPH6+4
 gHvlhYeTFQWEz+XQNTzevjjcm7CJRi0c5KHXbG0r40lZkVXCdNzxP49RWl65hJZVsaHOWbI1SYI
 9EMV10m5dND36YLoIYw==
X-Proofpoint-GUID: O71RTjYTxofL8RB7mVVSJGiig_4Nb7E3
X-Proofpoint-ORIG-GUID: O71RTjYTxofL8RB7mVVSJGiig_4Nb7E3
X-Authority-Analysis: v=2.4 cv=C9/kCAP+ c=1 sm=1 tr=0 ts=69a80379 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=AeFOY6yjdt1Wt5HR0lsA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: E2B234000F
X-Stat-Signature: emgkxgh1p5jmp7kou97o9sjupyypokks
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772618623-82991
X-HE-Meta: U2FsdGVkX1+/uJpRDFLUxgzGeAYHq3ZkeNn8H14+FgTOmw0qW/k2RTefEVnDXhjHXt/ZryQS/PCMuHsY6m75EPYkmvTi4Kt5vAUrtSavEg+fcR6l6eBDApywSoRRT8vaT+r+vPQ/vPzPIdPUQI8kcNfhZ0qCrbpKMVHBL4I1lY16nRhACRATa317aQkdE7aOoSnhCLrVFfYkC1hWgopL//PtsDCSYAOjL403u3enApSACuKhH8o/RC85Idm2/LFY3xiL4i96LRIYeV5PDx+pZgvmydWKfo5Dl8dfgA4IftL1JQaZDqNFXkkqnVrtvuKB0M2EX8DHdeaVDi9PDfQSQPIzez2FunZuziGdsaYNry16U8DugQwa3Ml/9MwZd30Sr03gCYr9X4/t+GZwhgQdos80f3oj6TBXYtcw85MPGWqAhDy0OSqynUTW3Wn+spdpVfePwfY1X42SX/qXIFNYYwmV8PYm+0pEADN00Szb0Xo9ANh98x01dRgnAQUB5sBgoqjetdC+tssIb/bKana5n6nBMmN8hszllkX0znY3P7BKMCojeVWytwgMM/LsWNSC8R884YT4a1x1cSTmK1yn5xEPeblBWStF5hOVyt7RLbvLcpSP1ZI7t6ai8ks+PDwUZ9GqPV9BlVqhM9cC/WTTiuBhAtIOBePZmv/S5Lx0Ff1MC8I26ZVAtCtYQJJBPnFHHTRF+9GfNvcEUOFqwq+DtatUuq6RkGpP8WPEFIQDP3m92xaQKXdq8lNF9tOavvofx+xYW0RqplRj8K6LtNwThO5aP0VxUil1LdOkqmzp9uzU2cfLeJqLSVHzhRXrQNQwDsNywOgWAsvK1thEXVzRZDyvE3aiugNIsBJDcInkLGy5CA6u6ZO8g50e5V6cWED5Ps1oSiVqYPrKrecuUzEAXMAk1tSszIZXY95kpvoS7hpddfX1wbEySBe6k48kNc2JQ8w01piG+xX2DymuoIY
 Zp9wJ4cD
 5Ia0Po1JwpHCB069WGio5j9j37zRJwABcACXvs1czYLBO12iz3RDNMm+pkGC9xveXyqvkkXGziiQUra+mwg8pQ4oNhuPr2hFqcppNd8E7WKZJeJMuYLyyL0eDHwspZac+XZ+sz3zb9/N+CKk3eJ6bHPnpFHiMn+YUTlfMDWNeHiNNbSWElOU0zUHiF5d7t1+roXoGS8mZEsEXd+K71gZXnq3iJm4uhjBjlCuy8DJ6+hWy8ZYx2UI7nb26BYWbFhBYpf5IUXduwAjzo2N+KiOM6D2qm4TJZ1b2pf9eRf0D4+LKT+ZKY1w4wn0uZvWgxHaglcA4MEIzbopd5HxPNdH2YRYDDUbncqg1mR5RsJnkI7XXSXDk5xA+1QY9eZrgxW88ahtongOeDbKuH4UKhUthJPC3PaaLbNkCyyXf/xR7ZW5UKaj7zgeyPnFs1z2LTxTx0hlgniOOcMPMRpvE48afSSQV7KTuV3e4svUmHxVKAfK60I87shbffcs8f1jiOKihtsOzOjyXu3z4Z+JFniAbkn7FXTwd7iG7qCIYPFjTZ6TWRg0jxjB7N7HbYYczh6/kWaY7960exlLG0pILcV+PRRiCKb0/qLkhnpBBlcHv3AUN+dk63/E68dw34InRKdCxlSOO2L4s0bVW2EpxxDS8zSsmb6k5p3KpwnaFWOh3cpdD6/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 10:58:58AM +0100, Vlastimil Babka wrote:
> On 3/4/26 4:05 AM, Harry Yoo wrote:
> > On Mon, Mar 02, 2026 at 10:55:37AM +0100, Vlastimil Babka (SUSE) wrote:
> >> Ming Lei reported [1] a regression in the ublk null target benchmark due
> >> to sheaves. The profile shows that the alloc_from_pcs() fastpath fails
> >> and allocations fall back to ___slab_alloc(). It also shows the
> >> allocations happen through mempool_alloc().
> >>
> >> The strategy of mempool_alloc() is to call the underlying allocator
> >> (here slab) without __GFP_DIRECT_RECLAIM first. This does not play well
> >> with __pcs_replace_empty_main() checking for gfpflags_allow_blocking()
> >> to decide if it should refill an empty sheaf or fallback to the
> >> slowpath, so we end up falling back.
> >>
> >> We could change the mempool strategy but there might be other paths
> >> doing the same ting. So instead allow sheaf refill when blocking is not
> >> allowed, changing the condition to gfpflags_allow_spinning(). The
> >> original condition was unnecessarily restrictive.
> >>
> >> Note this doesn't fully resolve the regression [1] as another component
> >> of that are memoryless nodes, which is to be addressed separately.
> >>
> >> Reported-by: Ming Lei <ming.lei@redhat.com>
> >> Fixes: e47c897a2949 ("slab: add sheaves to most caches")
> >> Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  mm/slub.c | 21 +++++++++------------
> >>  1 file changed, 9 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index b1e9f16ba435..17b200695e9b 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -4632,11 +4631,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> >>  	if (!full)
> >>  		return NULL;
> >>  
> >> -	/*
> >> -	 * we can reach here only when gfpflags_allow_blocking
> >> -	 * so this must not be an irq
> >> -	 */
> >> -	local_lock(&s->cpu_sheaves->lock);
> >> +	if (!local_trylock(&s->cpu_sheaves->lock))
> >> +		goto barn_put;
> > 
> > My AI buddy says (don't worry, I filtered it):
> > | When local_trylock() fails above, the function jumps to barn_put and returns
> > | pcs without holding the lock. This appears to violate the function's contract
> > | documented in the comment at the beginning of __pcs_replace_empty_main():
> > | 
> > |     "If not successful, returns NULL and the local lock unlocked."
> > | 
> > | The caller in alloc_from_pcs() checks for NULL to detect failure:
> > | 
> > |     if (unlikely(pcs->main->size == 0)) {
> > |         pcs = __pcs_replace_empty_main(s, pcs, gfp);
> > |         if (unlikely(!pcs))
> > |             return NULL;
> > |     }
> > | 
> > | If the trylock fails and pcs (non-NULL) is returned, the caller proceeds
> > | without realizing the lock was never re-acquired. This leads to accessing
> > | pcs->main without the lock and later trying to unlock a lock that isn't held.
> > 
> > And the analysis sounds correct to me.
> > 
> > perhaps it should be:
> > 
> > if (!local_trylock(&s->cpu_sheaves->lock)) {
> > 	pcs = NULL;
> > 	goto barn_put;
> > }
> 
> Thanks a lot Harry. In fact I realized this mistake after initially
> sending the patch to Ming in a reply, and fixed it locally (same as you
> suggest).
> Or so I thought, because the fix got apparently lost.

That happens sometimes, yeah :)

> So I'll do that now in slab/for-next-fixes

Thanks.

> Or actually I think a more robust way is to set pcs = NULL after the
> unlock, unconditionally, so I'll do that.

Oh, that sounds better!

> >>  	pcs = this_cpu_ptr(s->cpu_sheaves);
> >>  
> >>  	/*
> >> @@ -4667,6 +4663,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> >>  		return pcs;
> >>  	}
> >>  
> >> +barn_put:
> >>  	barn_put_full_sheaf(barn, full);
> >>  	stat(s, BARN_PUT);

-- 
Cheers,
Harry / Hyeonggon

