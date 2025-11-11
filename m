Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CDBCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 01:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F407D8E000C; Mon, 10 Nov 2025 20:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0748E0003; Mon, 10 Nov 2025 20:00:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D922B8E000C; Mon, 10 Nov 2025 20:00:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5B388E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:00:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CE6487827
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:00:12 +0000 (UTC)
X-FDA: 84096519864.09.6EAF23D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id E455818001B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:00:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sSFLJmyj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Gtu3pGpD;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762822809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mj3sFWy09ZIZ9CuU+yPg6vID0GQyqmUY5URyqmjQRU=;
	b=fxjyUckUPpk2OPu7pk+oZRzkP3E5xzSd6WvBEaHTpS/OdB+6ic6Hpc8nSmNS/NP9bThXD5
	8R9lMmXum8Q19oIhtg0sqP+OXmojps7COkmBWDFAgj8XgOOxsvxoYtCfUk3fGOssPyAk+B
	7oN03Dr9JvL9UQRv7ZGbJnFHnQBTNiU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762822809; a=rsa-sha256;
	cv=pass;
	b=DLqGUAZExsWVQZwW1sXoMjId4lPi9WKBzkkU3vMwe95riFpimAhu6+uHxyrbN2zhfb/vTY
	bIq6GkfW60r6i8wQhh55wks2Lo4pvk77DtwCG5nNSw5YQa0VHv1SmeXCyXYkfQRUc9ETB3
	XF26QzEAHd5UVhh+/TW+zY6gk6MbcZU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sSFLJmyj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Gtu3pGpD;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB0TNvU000315;
	Tue, 11 Nov 2025 01:00:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0mj3sFWy09ZIZ9CuU+
	yPg6vID0GQyqmUY5URyqmjQRU=; b=sSFLJmyjh6Ez3GuhM9oIGm94bzn7oPxuYd
	NXf1kfiDHO6cLTH4pwDw7O48EB/TAeXJrlVJTVg7tYIrBW4ePvFf4lSkhNrYQHVh
	ZarSi5ofYhbzj+iJCTbFXvf2XM3zrib6Q02kJwRAs6GUnhz/gb7YcdUgQN/BWpXu
	8rd9eI19obzRAxsy0gX8Jmx/fXcVB5je80dUDm1mntXdwy1mFZSQHRHP4cp3qvYR
	d6akW+tEYaE22M9eLUY2sMPS5Tv0Y+GE9/VWjOxwU0KDTYyO98OC7G+t/hRANZ9c
	98i89jroHRs1m0SmeLYBuODfR0tvYxzGqr281DWDOcvNgWu0bTXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abswx037k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 01:00:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB0WOZF039929;
	Tue, 11 Nov 2025 01:00:02 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8w0e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 01:00:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IdirRGiyuV/TFPfKDmrELTjy/g8LvxAnFX1iTBJsa3CuMjq5teP4aqwNgtGgIJ1Ta/ZopcBgTmNytpW300MmUOo7rLE+kGWNVpotA8fu1Do7MeNKzwbkuveHC9Qi5a6Q2sSBIjUP2ez31qsnG0jpvgowBSz7xLuQQ4KTqgUqlEp5kydLVp+HZAXaImghHBs/R/Gqvo688HgEEIE3aIosAr2iYLcQkQHNGmEmv1WMYEjDqLFYCsoL/OYVBbnOFQviWP4gX/6BoMj6owWnygoZMwVUBuP1zMSdaHMa5xTD3fJJhvJrj4MXzveEwS5BzdCdfmRCRx3VZsZ/7c5J60sx9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mj3sFWy09ZIZ9CuU+yPg6vID0GQyqmUY5URyqmjQRU=;
 b=oWU5mKPUcGXQ5Q0ILqkotvCejYL0NyGpMJ03b90Y8tSSIHud7qHlRr/8pUkljwDk+lRgOFudzv0yfRRiZwZhsSTgQ/XkwRq8SdbbikmrwWqkNPKSBbdRHNBITVAikewF9F0/hC/DNm32+aXWNNNLw/wZOMdVXMvXeX9SfpQg3nJHdUgpuL/Zj8sL7CafR+lSylRe6TUbG0c2JCQn+Qlshlxoph5wg/ejmOC1/GZ9AxejRmNXnOvbR3fd9GDpqKMqmVQDVUvYN+v91Yf0Yhm97QRhr2j0jJv3FW+O5plLkDIsDg95gJcC64lJTFlBk7DWZ6MJwgicAuFfu/pfzgiucw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mj3sFWy09ZIZ9CuU+yPg6vID0GQyqmUY5URyqmjQRU=;
 b=Gtu3pGpDeakn24wy6XJsIGldy7JEW1ZUCKUUMA9BmxknRA6qp0iTDgqPyOTAvg0qlHmhWjzSKMGP6BnQBJ1gl94gCLRMXr/BRty8YqfYVafABnhr2h7XBbVfRHz4lxuGEGvjyx5kxJ0Uej77W3/JuP9AV3XK1nKZ1z+PUCNFPNY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN7PR10MB6384.namprd10.prod.outlook.com (2603:10b6:806:26c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 00:59:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 00:59:58 +0000
Date: Tue, 11 Nov 2025 09:59:49 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Message-ID: <aRKKfdN3B68wxFvN@hyeyoo>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev>
X-ClientProxiedBy: SL2P216CA0204.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN7PR10MB6384:EE_
X-MS-Office365-Filtering-Correlation-Id: 95d7b601-a96b-4c0b-f8bf-08de20bda2d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8vFu0LO1RXonPZGyh1bMD0kP/PwlrsRnJJTkY9IjLmyFRPScSyHCh+Df5Rsd?=
 =?us-ascii?Q?b3JfpGHN2otlRwq1ZPq5BB2VPQn+dSUYVMR4eAnR1tckLdKmr+sijkYFbw0r?=
 =?us-ascii?Q?xYWAEnVguYNR9rZ4+bWoSgE0gtfj1XYnIXhD8ez/ezBS4PLm+2lYfGmLB/kk?=
 =?us-ascii?Q?pyYf7tqNCgoWITZ4tJD1BRGDJ+s/nSiQye7YPr3MgQ4XUf2s7I6Lzphs4Xqf?=
 =?us-ascii?Q?/9cliiv19GYpfC7GrJeGStJoQPvURFevr2xT80eStzw/f/yIe90ybsscg58Q?=
 =?us-ascii?Q?NKIi2dp3aUfzeIMOM+lujiPUz2j0/r3bqT2bHFmSDbrRXLPgoyIIVJXexN10?=
 =?us-ascii?Q?4jiUcjEPMywWbYTY/qVYe7cxdqTmVFQ2Tjmccj13UR0EnOHwygt4YQ92YboF?=
 =?us-ascii?Q?vA8BDvbeOBc+O8e32SrSlcCjMvwy/5mrxI4kSMqQDDEOL3RhdLFPI5uefj4n?=
 =?us-ascii?Q?LaiHXcFxAyBBCG+VGs7Ky8hsB1VqCuc2mCkzhMBCbEvIQojOu2Ot2xtnpzpj?=
 =?us-ascii?Q?OwRImmFqsi9x17jzJ/42DvVPeLbJ6TfsCOEQRYI3nwFjwJRIBTWzoel0hG9H?=
 =?us-ascii?Q?f6qWo9xDMA4zqWZsYwj2f1qdobBjxQUG7cW7Cni1URRUod6dqqgVLwp+h/cR?=
 =?us-ascii?Q?rDG+ob6eTkj8Q0YBUQPGQIa5BLCN7eemZo9wUQCLU+eODmsFSzgLx7U3XCST?=
 =?us-ascii?Q?psLPF2l+h0wu2jMavvW6DHmVV/G0ogsEiOKZY7W3YMwSOz/vyPBmLX217xrL?=
 =?us-ascii?Q?pDzXnojKam2GSfRw+8aTqETsTRIPZFIxAZHVzXAL8exC59glq1qUzAhGKjab?=
 =?us-ascii?Q?1e8582j5zzuPLmm50dC4hagJEoWwL2U9KmSuFEiBM9Hmoy34uM5cNiOgMlDd?=
 =?us-ascii?Q?Svew7bfJgVmr19jDvsyTnWTdJFpsjmwgzMTjEaJYgmy7HMKE4GSBHtxmzpE4?=
 =?us-ascii?Q?zcYZwN9zr1fkQRFeSFYU2v00xc4QLVSSMbXQAVmsWBVgoQCKbm5sz966y8+i?=
 =?us-ascii?Q?0PbMpUoTtm3S+OTsTvjMVxEt8V10TVc/0cRfUBLrTv6jcLsZjWYzny5ofJKb?=
 =?us-ascii?Q?2bZzmjZyQhA3pYRaoX9BOkkU7FOi31LmWvGbY/DyAL6b/xy2a2NMCi4f0sBG?=
 =?us-ascii?Q?lD1/HtTrQqL5vdkBmVzZzvTbs0i+/KWOpP4ZXMECgsG6oUeR5G0OQ9YuOR0g?=
 =?us-ascii?Q?rI72NduYErHFrL3iCyQIr8zf3VChKKW+S1rOgnFgHWIJf46qn0eQiLNI/gs8?=
 =?us-ascii?Q?PPzxagRj+E67G+1wGhQyEx2iiDyS4CYyIY7FmqKtxOMaqaUzUmiN9oqiXNYS?=
 =?us-ascii?Q?AEaen2QHCEysL1b3ofxyBaNUkCkbdvHB0tQ0OTv+foZKoYpfPuKsF/tyn4PN?=
 =?us-ascii?Q?bS46GKI20g/BsTaBIRwDnC80MGp01JRcazD+YkDip7i/X1ZKuph4QDRZkdor?=
 =?us-ascii?Q?wLZ6F9jDk0tQdHRt+bkl9QTFbKr9igeX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?05kEpyCNWUrRmk3tFGSXtBDjxQWsmiqtfUbm0YeQVT9+yg565ifoM2RlPTaR?=
 =?us-ascii?Q?MEikpefu04qc+4oH55ntzyzfUAlkP6dBAwVOm+HOjrDzS0zSisPWzKOjLlw4?=
 =?us-ascii?Q?jxoGOC1BEs8yfKt0qmE0KOoyBO/2A50RH9PHjGSH647Cgp5efmyFSXlOpu3+?=
 =?us-ascii?Q?GhsDx5zVylndyGbB/EbP7na8YiPizBMvHOJmRzZqpAtBInre9YEm7uZS7/fh?=
 =?us-ascii?Q?GyJDScz0aY5pJZni8dwtoZxd/rHFFml7i6QqRKkLwtt9BSTXBT0AD/UPEs2C?=
 =?us-ascii?Q?Q+DpVcq4bOPnJvRMjxFEmhyXveBwRGVti/SQNjDCk1xPaFv0AnoIFgjayaZq?=
 =?us-ascii?Q?ipUz/326T9EJeNx4gTmK+a5PjyReXu1PqGGXNM+yPzb1aBR0vSTQi8llwOcC?=
 =?us-ascii?Q?s0xPWM/fQhfFbG5UzWq+LtA99bBuCiV9LOBEEzP1gChsJFn7ar03QiCspw4b?=
 =?us-ascii?Q?SG8Sxpx0ou8ZyQMHFZE6hDy102gd9Ubyacl5gu698c0yu6PMvbAh0H31TZBS?=
 =?us-ascii?Q?Rc/fSqVyeziPt4jL0Mmc8tLnd0JjDvbLSg5aYYh+60MR3I+HVQaT7Pn6x8b4?=
 =?us-ascii?Q?dH0qdyXZywvWC/qQLVLjcOYesca+fqe+fuA9+GCyCofkjF0fI++C6AJzj53X?=
 =?us-ascii?Q?EtuGCVJB5bm7HEVfj9xW8Ta/oC7MJExUCByI3CyHORYaDYkzguxAwpjWSGhL?=
 =?us-ascii?Q?mnTt5IiJ5oTtr3ppcRELxe7JZZkaM7E4QB4z++HpS82BPSMvopjwJh7TZJK1?=
 =?us-ascii?Q?vl+IXQZ7OV3/1J8FhERBjZAkQznXK0/5dt2Bl387Uesz+LDpLU2+fq4Y4JwN?=
 =?us-ascii?Q?xrJVuaJ8u9BrRbvVD8hGivmUXG9KQyCIz5SbAk422kje0NgShJlE79QxhI5V?=
 =?us-ascii?Q?RtZIFgntB3KewGBvtExj6gicd8EEm0Z1RLzHWQ9BFlK4/dOkdI4dnT0fXfZP?=
 =?us-ascii?Q?7ybrSqEFKAiqApPpRwsd/EXnolFQGW6t3+uufBLB1ZC30lVNLXu904mErV+i?=
 =?us-ascii?Q?nPT+kEfhxLT47/NksemqrUW/LUg9FAs7nUinQtCwqU/EQ8uqcx2wV/F3K4LK?=
 =?us-ascii?Q?FoY21PiIora9ow39u1vAuUPEMKz7t5A1nTY8F96s+EXpZdgL2PlhzJL6U5K2?=
 =?us-ascii?Q?G4MA2q9GvQ3Pk6fFqISY/stJ7pn/GXLiF9z0KETXXWXUfzXlLU7gQ7ju5tYc?=
 =?us-ascii?Q?xEFRNGMWSt3B8xqpD62C0Rbw9cC88gvaTiJ/kvq6XD6aB+dRHa4QpDo+kyxT?=
 =?us-ascii?Q?1Pl0oomGgOwruxvz9ulaFh61oYex/HxALhptbEMBY7X76MkHxoMhcp0qes1X?=
 =?us-ascii?Q?n6kvaJ2HASTmE8a82uVhzyjHQCB1BOF40QsjKLvfu4koz7F3vw86anYONaPx?=
 =?us-ascii?Q?AFUkFWRDmh5z3uwRzYhrSdghrbhZUrY++Lgyn/8ILIt7fdamyr8ZD2KcWPTs?=
 =?us-ascii?Q?r/TqL9Pq9eaG1xgIaPNpRh80i1cVKLZXePTzYl9bwSY0xn3L3SbY3SC5jn9f?=
 =?us-ascii?Q?++zQSYPJl4GOg5ucXVLiu0ugieZ7xAdo0yMBc5IH08eSW4nPPPGHKz+FeiY+?=
 =?us-ascii?Q?uNosWEIqHPvQ6Q4kQQLh4nQjU9dEMHX6CpMaE1Iq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ybtIpjWreDXL3pDOqI7jKudEJ02CVYfAzPy5g7b0lNB5Wp+Ttcl+05SKabOvM5IRCqocsECc3Z/m3f1yq9ZyJeOFKk7AIC3Uw4PTfX54gPl8332/IFhdCsMDdsrD+Jmf3mMgVzRmZWu6Y+cTfqeE/4To5XUqIHo718ZOoGKeBs5gZBFwklevANl0XT4cJCj1Z/cGxdtix5CLHwnQXvd3PQAJB0toKBgc/T3c6QtP2uW1fEF9eLrOa301wXybe4bmjwZhVrqa7qYqefzf2b7EyTVKmcT/7dadbCGIV1qIMqUHEVL9LGgXk73VWrWSnyuDEEtQ3GKqv0p2aQUcqUwUmUA/wTmeaEmKj67VQzC5kBMbi/6RrmkbEcMDM785YPshD5brm/BznoIKqDoqX/euQnFJIQFHdF1LYeNr75Gra6VTYElNjxKQS+d9QhvOBHl3eb0nt1ur8WbAVVg+QoiHdQX0sp7EcMCbJ1W7DMFfPoXpez63ZnLQtK5Vs/vypdHUsOyylfqww5/MO/XX5G8SMDA9mtWwoFeE+xbcF97B3zyedIS+9hlZlsBdGtsFYXO9T0FMcDW6tzf1aac+/kuERgqqNp37VktPRlIC8451lIQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95d7b601-a96b-4c0b-f8bf-08de20bda2d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 00:59:58.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0b9Boykm1WXinWu+FvI7/TStD0sPQMo94/RYUSwuWNmHX+j2f8MKez3fvPwQmUx8fLs2gUX92wPMzpu2p7Y0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6384
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511110003
X-Authority-Analysis: v=2.4 cv=L/sQguT8 c=1 sm=1 tr=0 ts=69128a93 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2Ihl8k3y6r3_0f3FCn4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: plIkdyrDP1jCdRbuKPJdszAk_JwqeuKw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE5OSBTYWx0ZWRfX7MAsQKaqWIDy
 TmC5fQsWr8Pt0dZAt1DgEfHiwKuXmO8cZwUhYwRboPueHX4V+nY78WD+jAaz6TxSqgudsCAdWMi
 R111IDk2ZDt90RgNZVkbLx4yckwq69sVocUpdqfq/9yUArlzQGc/MKuP9LzRqNLMjkSpoJscAJo
 zboEXE6mF1+Vv80Wn1o2RK4qgBNlyjoYXcN1gMGaqkmpOsLXgrR6E+yWR5LSIcXMBgRJ76/US7h
 yCKoTMu8YQwbC5HNSUyokXFEB8gNvUPXQn1r3B3b8HPt6B6QDGcVoRlGKu0z1Xv2g8JGiYcxTnP
 Hg2XVUxOg8hUF4DDZRscYPW7X3MYVMmTj3Hzg7tW4JW1reAEBTNRORrwW3VT6wULLBBa2u1A097
 lu+Yq9AGFjqcmQXflxmSzPoHrBqjdw==
X-Proofpoint-GUID: plIkdyrDP1jCdRbuKPJdszAk_JwqeuKw
X-Stat-Signature: 4dj5gipoprg9onqiw9xcxpk7dpouwtm1
X-Rspam-User: 
X-Rspamd-Queue-Id: E455818001B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762822808-289022
X-HE-Meta: U2FsdGVkX18Qq43o73/N2ZnGNnUYGdpr1rVHx1mh4H42r6jSx8yx67I+BosLL2DOMZfIlPmaOnhJdS1qSiX1sqi76ao54tZGJ5acWI0HHWLzSklWC9I7QZcLZkikuV+xaDx7RtiRnlwQACTIoUAz84o58Xn8ELq6kxBomH9lZdYFqCx3AzWwmIq1A6JKlBLE9YLRFQZjnF1T5G6jQTmAPewjHQvrBtaiberlE9HM8nrZoHkJmep78e4We5FpERbFiv35uVN1NgJpvfmd9plJj8gVfNtha+gozi4fIvL/jJ2p2yLNIrzSHaePWDUU4lgCc5dN170Kb5jiXJexjk6Uj3QXfsgmWWXPssUVTSsVMzgZZXREFoidgwTtQKxcJMlSBhVxXoNOw79R+tInqBQg39xIPvSiOxhubbyMXQExp6guoIyvrrWGdW71/vaQSzw4ler1WMzsMza7V05lY0CrUJ10Gdjt/Ip2zF3JeoD8Scr2fV3iQlkAi0kFCJlU107jEcsFUfey+OT7Kujxj337/sSCeGTAbpb/pynhbQ+o0ITIEPdALV1h1Zkwdo3Fw2Q4LA+dZf4gMzSFt833Ale/wY9OBBjT3aXjyoVNymU4Ql1E93y0cpduJ15vtiGrmr1u1S+0yl8sTPpoHVc6MhYGtEdnUf2LP62B+AuPu8SbDmXQP3gO3CCERRKbc2+0JPBwDaqiqmC3SN1r6/hYFQPgTdFZ9Xn+54SB7XqrTzS7SqsovD0CY8hOTnvH2c03imalg4/Ygjrn6mzpIXETo9I/jYlKd2GdqE80m0TfVoxlqOUafIC+4AlvquPqzZxBxri1j6NCw2ZMrirhE6Fsu2Gv7o2iELGRuAv2Vel8VQN8nKugwNnS7y9zgbBOztzgcuNquHFoxeJi5ykOxM//TRHqRzbuHIDDlUhpMputUXiM0XJqvq5M71G+xTPnSlJYuYPl6/xhr0lpJkdBpo39bSb
 8OCabpzQ
 zzv+Q5aB9vbJE5oh5KuOQxc/NRBtD5BJ23gTsYKMXfyTMapiS9ZK9KILOxVZpkvOkKv68h6sbUxqvOpKYaWBIcJQyMBvH6bJb1LkEmxur9f146XwJkX+HcBMWCqJEB0bTy3tUwr3YI2KN6rmM7iirEMIrTQiOYNB7Q8/b8atoRiUxZ8tw47HCE86xrpIZYzPqitqA0yPvBmaUEJM5awPVsAHZOjdj+zfa9xP7obDNZEkdVwIBFTd4LXrsp73foDM7yiqYLDPpG2o/P2B8jkKCJ5r8j0SOz2+q/+X8tha2voE+Lnt1bh8B6gLhkG2V6++ZBIm7ibodmxN8lxSk18O7Bx/XfaEgrwH/BDpWRgQGfQhSMkFPzzlXaQ6ti7+BOizQRh3pQwwWd7Rybt8T+GshDVnZ2I2yyZYlarWb/hZAD+IaDB1YaxzO7DuFf2hSjskbeI0G4Iih7ThazuHnFPD3AV0ctff8Yy8owE3yN4HUWHlzQx7kpv7yandoVXwvaQBcRWE0oFHw7wYHhTUuqBzqg+959/p6HCnfVI1s9LJU1oihGFUTBgmimAk5P7VQQJwckWvCriFtger5BE2zUUwZI2Q++bzK5Xv2ad/+Xc363A2iYQjdBWwum57hdQ13n7Gv0JdakT3OzvzCkz4ftgkKbf+EUgjHtZhlIN4+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 03:20:04PM -0800, Shakeel Butt wrote:
> The memcg stats are safe against irq (and nmi) context and thus does not
> require disabling irqs. However for some stats which are also maintained
> at node level, it is using irq unsafe interface and thus requiring the
> users to still disables irqs or use interfaces which explicitly disables
> irqs. Let's move memcg code to use irq safe node level stats function
> which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
> (all major ones), so there will not be any performance penalty for its
> usage.

Are you or Qi planning a follow-up that converts spin_lock_irq() to
spin_lock() in places where they disabled IRQs was just to update vmstat?

Qi's zombie memcg series will depends on that work I guess..

-- 
Cheers,
Harry / Hyeonggon

> Shakeel Butt (4):
>   memcg: use mod_node_page_state to update stats
>   memcg: remove __mod_lruvec_kmem_state
>   memcg: remove __mod_lruvec_state
>   memcg: remove __lruvec_stat_mod_folio
> 
>  include/linux/memcontrol.h | 28 ++++------------------
>  include/linux/mm_inline.h  |  2 +-
>  include/linux/vmstat.h     | 48 ++------------------------------------
>  mm/filemap.c               | 20 ++++++++--------
>  mm/huge_memory.c           |  4 ++--
>  mm/khugepaged.c            |  8 +++----
>  mm/memcontrol.c            | 20 ++++++++--------
>  mm/migrate.c               | 20 ++++++++--------
>  mm/page-writeback.c        |  2 +-
>  mm/rmap.c                  |  4 ++--
>  mm/shmem.c                 |  6 ++---
>  mm/vmscan.c                |  4 ++--
>  mm/workingset.c            |  2 +-
>  13 files changed, 53 insertions(+), 115 deletions(-)
> 
> -- 
> 2.47.3
> 

