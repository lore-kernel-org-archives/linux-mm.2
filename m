Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5788FCFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 06:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25116B0008; Mon, 24 Nov 2025 01:15:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC916B0026; Mon, 24 Nov 2025 01:15:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4D16B0027; Mon, 24 Nov 2025 01:15:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89EC36B0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 01:15:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4547F140244
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:15:19 +0000 (UTC)
X-FDA: 84144488358.03.DB0331F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id F16301A0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:15:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QHol+YvI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tAXvExJ1;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763964916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deGLfnqrZBmyazTHTh7DAhi7ZQTtvvO/MudIosB6Lx4=;
	b=X0SxC+EQgZ0dh38akbX16mNp2pV7jY4jcXAkSW/wLQBW0pYnyUIrqAU0jwXSR8AwclW8OJ
	/e7wVktbouzqpWk1NRL2G+UH87PZzAAPz/TDG17n/0H5K8v4GnVlL8ZDJ3d38u07mTwf4J
	451wf3KEYvmZu+tzXZ+ax6pG2zGD43s=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QHol+YvI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tAXvExJ1;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763964916; a=rsa-sha256;
	cv=pass;
	b=BK37kGlJRLMMeVQYB3fRZYZZ/bWP+Y/9xquKwV0Of3lSmdmLCh69Si/MSBesz8DNm/ktoc
	LvcG49VIKynwuFLCD42lMuJz9BK/DqCUzFQIeEOwbc7/wHmwEH5+9EC93PJax63QvgcijY
	hl4WDLNpHKZH7Zyh2uwrJbRbbdIB6Yk=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO0SSW54078586;
	Mon, 24 Nov 2025 06:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=deGLfnqrZBmyazTHTh
	7DAhi7ZQTtvvO/MudIosB6Lx4=; b=QHol+YvIOJrSfTTJJMzyWyl609Or9G0WB4
	fsI/PtnOd/wtcJEKU3323wv0fxi2M9m+Cw9aL+jNLWWYc5gWBcKPdvYyeMQClfeS
	lxG5e40lnnB/Rx7zjhvIsXrwvy7a2qDgUURGWQOhPqM4CjDMvok8+id4gz+I/SVs
	ruvfYwiorcjMOmM/ERr4gcOPvg0I5KrqDtYr8n17uKWB66lIPnWqGxg6u8beV510
	+4YLIzcPooNmqiqJMt9dhvgg6uSMZ1te12L8gPvtQhNNK0wDg5VqjjHFZxvYj4YM
	NohZC1kCvzqpXl4kqMkLax68Bu/vceGIEU/F2NFuJb5/EWbkgoeA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8dd9ejh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 06:15:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO6ECcr032703;
	Mon, 24 Nov 2025 06:15:05 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010041.outbound.protection.outlook.com [52.101.61.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m7qbg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 06:15:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+lAbnudjNkW1VUKbD1v2NDEUXJxL4lcO+PRbeY3p9S/nEJ6rUmwhbFEicz/BKw9Yf1uUylkEyeu9nsxwxE2MQTVKTadT6mDoKz8MnHuVgydCERMvsqcBZ9GG+/ZJgslTjL3vd1viIq4R8iscSRjuymjKzA7SAcMoW5XPj6hwcGk41yiRmmA/BpfWKMfjw/OivBojn8O8LNNGQ57CFaRipoka9KsKnEDVEA90H0k1f22inW3yjBAfSCYru9pwwDjwZ490v780Y4iiApeTBfMscc5bpF1DGdFgT2zN1YeZgy9baQz2f+X2XsiczYxhuKN0OtBgVWJtMl8aPEu/Ed3hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deGLfnqrZBmyazTHTh7DAhi7ZQTtvvO/MudIosB6Lx4=;
 b=ahcnEZRAzRjUidvsmcV2DoguekEfSyCKbBNmH1t4TNC2y6cl0RjoK3wB76K77eK02ifWe/FP2AydgITQ6uhGZov9dZX10Jl/N94Zofs46PM8bg50+8gLZNHk51h0ztbdB3b5zU/IT3IFCK0byzPbRgTT3r4bXFnCljaoHkw8HMJW7BGTL1qSbxev6EYs99X0XBWGCf28DWxxhWEe2zkYx3I87CEI+yIqNpqi9Q7tdZF3EEjq1RR5wKV7tFiSPSFvWjs9Ibl6I5fk25fsJsAQDGiK/bn3iFWq5khGznF39eF/ngIe/WxBLbPBq04aMMUdIAQiPYZZtbFav7kVAS6O4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deGLfnqrZBmyazTHTh7DAhi7ZQTtvvO/MudIosB6Lx4=;
 b=tAXvExJ1y77XB3jIBf3SbNUW/sk4c78HlMMFwV38CmC9RKzi1gxXwNT3RFQ/756ePddlBRBO9KKduXqSr7vTY1QJgNtg5BYRJSrQF6lZgxGG8BlfF23iymgDi9ziBZMvsIaPotRw59Q2ffk51zqFNXcZr+SSI+BNzv3v3fn7pSM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4534.namprd10.prod.outlook.com (2603:10b6:510:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 06:15:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 06:15:01 +0000
Date: Mon, 24 Nov 2025 15:14:52 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 13/16] usercopy: Remove folio references from
 check_heap_object()
Message-ID: <aSP33DLEKcCYxYqM@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-14-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-14-willy@infradead.org>
X-ClientProxiedBy: SL2P216CA0142.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::21) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4534:EE_
X-MS-Office365-Filtering-Correlation-Id: 3561047d-7500-44fa-8ba4-08de2b20cd1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ggsq2qQAlzmu9/Ljn8nK+v/NYWzCA2it9x3yHZHq1Bizht9hzUJPlGoZeGeR?=
 =?us-ascii?Q?rJBucrMpHOaXxDi0xI2xTTObhlaI9HhSBke4wPA7ve2UL/4O68g9XpWt+gq+?=
 =?us-ascii?Q?CqN31pccIyQ+fvNRifiwa7RPM3eHY7Z6LGlcUwDqf07pwgdiSVjLeD/9rJ9T?=
 =?us-ascii?Q?9JQp4ze3+pYgMcb33gFCtvaxddwqQPshwelnPwH5hNbVvwwlznXxGQN9EoXT?=
 =?us-ascii?Q?lEZOTJdSEcwOFy/m8olf2QXa1rZvKeRDGgUyFvEK7q7T9GrR4DAq0FTOTscl?=
 =?us-ascii?Q?jNs8ZQ/dqrxU74pzEGOMmpx3NlLScJx1N0yw9+YT1hQwncMtlfZ0TV+1h3er?=
 =?us-ascii?Q?k0xroGFBHxpRm4DeiSs7qnXg4TAZYffqNc+IJIq7WrHv2tHoU8HJJdtQgJVf?=
 =?us-ascii?Q?RdlUhGLPyUs5ZWftyH3BOux6nriU6n2utuCjkC+PM1lkL9KZ/KKGRkJs12e0?=
 =?us-ascii?Q?32rEZII2r07x376Vg9bRQtM7LUpYX+AFxi5yGNqUzk2sFBLwV3R7YMsFATwT?=
 =?us-ascii?Q?MOP32EvD+5KfKJj/A+Y+XvnXkGhYteDgZSbn4gqeG4PSC4Z0aMijrGVVqrDl?=
 =?us-ascii?Q?NonB3s8oFJLUPDnRLZDxDyXb6ukWbP44EIjTVxM0yg4xt0CIG+1ax3pmqWfG?=
 =?us-ascii?Q?2FnOwu+trDBZFefN4pvKVtC7p5VQhMOfhcj4gIp12z7OvhlkpXZIl8JY2baN?=
 =?us-ascii?Q?HP2LFGoXGTQUD7K+oQyNbef8wecbyRnFFwOWrJwO3nxAHzDGZBKMZEQ3cLsD?=
 =?us-ascii?Q?vdUNiIEaZqH4DcNGkcshJI7086MDJ9Xw93JOR+cEfT1iwf6OyBMevtf0jk25?=
 =?us-ascii?Q?Tr5369SAVQZOJBhy54CIcit/Vz2jLYq68GxJLBNxt8Rken7KYJbn9+DsZWLT?=
 =?us-ascii?Q?rdyfVxmMLM5FNnxd1TFuZV6MW+OTbXs9jdEzFjaFQkxllxg9X7dNkLqVxYZe?=
 =?us-ascii?Q?Y3GusqPPVuhbUqzvj9lcds4KUbONErE0jkpRAGsSuogRD3lGGX2QDM+ce56R?=
 =?us-ascii?Q?w6xMX4zsDTaJI16ZuVCVyzVoE7c9Gpmy4oNuXmQD3YXK14Y3Q8ByViJY7mLh?=
 =?us-ascii?Q?Ak9JhqkgY24SrxrEdzjnLvfJTofh5nPLg5yvRnyDkQYYCxWnSlUXA6zPbZSC?=
 =?us-ascii?Q?y1zFOCoLVgwgwUvA5ZNbjVrDmnPC49HyY0ul5E8ivR2CcCR5T9O8iPrnyhj5?=
 =?us-ascii?Q?J09KOK74q+IGpOx8p0g5ObqKqhvEXQ9K93i53ulPEQXRcD0DtHg2kblejHAj?=
 =?us-ascii?Q?WnTvEfumaqSup1L74aeJF9mg++nGIOSrDhdAzkgjHkp4c/c/F48pnrzeSqe1?=
 =?us-ascii?Q?zX9ExEllW25bq0aed7qfelf1ux6qMEcUvk0UXCQ/32P2mhsfzwP2zPh8c0i8?=
 =?us-ascii?Q?lh8shmS0kvjqOVBihnteL5t0N8+S4kdsskIfTpac6yGNqAA/7+kBGARbSwyP?=
 =?us-ascii?Q?7E7LNmKLnrhXWNfH3fi3RHNH+Mr9uxBT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MaqQG/ibbV+EJqO/hpgWjyzhYZHV71da/lxYCGdS+2OW878L5+f8TX2/RzJU?=
 =?us-ascii?Q?QjUdmBNVH253pMMWCuyDmQVLW7zmjXx2P45LjPxFDcDAy4Wwdb5dfx/HtzRK?=
 =?us-ascii?Q?dgLI+x6y/2d5t0HOAx/Fp+7ZOZRCm9Z/yBS2UjYL61hk77uOHoXUxMB//DfX?=
 =?us-ascii?Q?UFRVAHthoiYOZnB6yoFvtt0VmxDKTt/4re7FSUQ0livNXtrc05gKN3FK3kxI?=
 =?us-ascii?Q?ybbDgweRYl8Eo4u0bBU8u9AMnVMYSDyKz3FyaY5xp/mUDKN7wcWkXNGjMiFc?=
 =?us-ascii?Q?qYlRdx2gxfqoQon4OIrlBQWdgwFYdrER3X19PK/UOTZCNfcXilsK1kFay/bb?=
 =?us-ascii?Q?BLW8fi0D2tnLhycImE2hdPQsScszC+yBiHcDstD1nDReWSSuCH69CBoxrw/6?=
 =?us-ascii?Q?ePMwqB3JU9y99E62TSKTXktycf2Y6xH1OtbPiAMYrgl0Wyc9888LjkUChlc+?=
 =?us-ascii?Q?EAFpbWA/kMGaa1IvzahImVWku1+ctlg4xVOc9NC6SYBC50BrU4tZ9WsByL/e?=
 =?us-ascii?Q?PiKJbczo+vbXlcXNI3Yf0qonXLq2VfAf5ptTg0upvwPuDdkAmIMU7pKoLwHt?=
 =?us-ascii?Q?97ShqOWxz3R5oydFzKahPGXrpXL8D7ld0Xo105ir+RpvlFfC4jKC01cYNZ3w?=
 =?us-ascii?Q?VC+oOAAJeYnXfBUNYUWUuh2C153Vb3f/G30JCi7lcozKs1JVgGCQjBpZFpvq?=
 =?us-ascii?Q?ZddLZ3Ufjx/7ZJABx/wym+vQ8FjTFlrgPH9NMsE+6dF10D1u9Mz+wXLc0Y4E?=
 =?us-ascii?Q?Ydzs+F6gyRWV/ZwSVCbXI3z+RRSLJZxYD2v2qV5dXgtWTPbpRmIkIn+LsCqE?=
 =?us-ascii?Q?kNoty6LX8PGk/pzN1WmANnQKaLDOgaeIxATbVWf6ky44Gx5FWf3pWATRVs1X?=
 =?us-ascii?Q?c5I9IolbnGT5kQdBPhFpdEQW2PB7YMC0z+FePd9O6xMoXH7Uig8Dt03ES+h5?=
 =?us-ascii?Q?ZxhboqvEAasuhp0wuxwLDEA77HJ0+enA6KenRjUh0I2QwTNPUfNoSfBInI3T?=
 =?us-ascii?Q?c3J/2Che484RtDeJplcAwU9Z5r/Gky/NZzWIlqjay0CF1Ov8zDVgSlyyv3bS?=
 =?us-ascii?Q?V8e6tpR5KuvcYsgq5AXtfSxnOVwA7UYe3YEAVD8xBpOT9a3RmKSIUfcWkvPB?=
 =?us-ascii?Q?lD/kYhagdthjdcRCx0E4zUBVoywKw9oe6Zx0y9PnSn5882sJYgmG/gFL1xWv?=
 =?us-ascii?Q?RVlIVRrn9HjNnqgXblbIkq4endf8TpHLYRA/u3vdQqBj15Muu9qHEi5xFr6/?=
 =?us-ascii?Q?pUywYJ2JFTeu4hG1UbJKPlq2eipH0kR/6rJLa4FTL3uZW0HQ4SJdLPyPr1nv?=
 =?us-ascii?Q?QGDzEI4haqooR/wqq7W6SLUIQRak+/k5KVvCq0mOoBR574z67bRoxNEFEU8c?=
 =?us-ascii?Q?FDtMTmIHN+bpgd2Zhgk6lEWpAvPRghCKIoiMX7T8hVA+nmsXEftT8c6Vwm4R?=
 =?us-ascii?Q?koXA6b2K8H5Ba77m6JRyuC1EqmzGEujv3WKDMbSOFnY1d5v1NhQrzASjW73q?=
 =?us-ascii?Q?Vs62mIZ29GUwvbcaOIZdRrKrcXlZGHfAD/an2okiYUIyk0rsYJ/xlucN+eEJ?=
 =?us-ascii?Q?j7PxjZfSSKdlgC1LDjg5SgbhBezAqIaUBtkcGjPD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aVQ405Z8m8KxOPInb5JiTRXJ56dH3uS5p9ZERmf2a9GCZgvZVD/KaZseSPXOhJXiImEHwnWXPpu3fAYutP1RWZq6yEmiIW26zCpW30uZ6xyyDPrFJIDyA3UEImjog3BrXzj4nrP2KX2XURX3vV+sLC3twyAoPH1Yg3999aDhiDziJSnekDfxVmCISgWgC3OzlPAZmNcBH10gUDB92B29UI3xuxbbUwxH0dqQaYzmg5R3KmRhu7OSXoXebQTw0YjUpP6luirj66QQcrtKfeOW8TGufwyUv4mvjkphmtsrrr9bOsaLR1ZcNsT3O+w0K32pXLoW+9VlYjyyADLGE0wDFJLaoSLtadXLK5HXpoDBPLibnVl9X6lbjnvYsyv/lbqVgA1W94zsPeBLrVByWk50etgHQI0YjjiC8lEWpezfLvn02/q+RfUtb5GlBNdJ1KSahxw7M9RCHmFq0paqHFzqrLoJ3waJ1ML56sKaMuM6ozGJP38bHtUKfRNSyR/MPoQ4iKKfvkvfdN7/TdvT8+sA33uoSIrdnvL7G/u3McQa9q1xLloF1nsmgZn/FPYkzJnl56Ei6JUIpHf20ItVfsa3NtPLmxj6iOjooWLb3pEEdw0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3561047d-7500-44fa-8ba4-08de2b20cd1a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 06:15:01.6674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwP9HuuLmiVVNMU7zyC5GnFvGe4hKaTdrrIxoTNN+ARcsd8fUKxNMxN0/MGFG5eTdKTRO4OQPrPfCeuI2RUIxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240053
X-Proofpoint-GUID: Ytn7S9kPdpFmU2bDHivcDR2Mqx3fUs7W
X-Authority-Analysis: v=2.4 cv=ObqVzxTY c=1 sm=1 tr=0 ts=6923f7ea cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=s6f2M-gfu8gXJb6GzYcA:9
 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA1MyBTYWx0ZWRfX3fvLtvwGBkAr
 wHG9dUpTebbR+2MCln2mopbDXX4Aq3ZGwBAWFo9Byql66+sC40BjWZidPJ4hl6RnkBQvs1ppQEI
 OIuN74Dl3W4A7oSN43D1YI9/lA2i2Tq63yZXw8WKt8xmmBxoRKd53iGC/TXF9C+H/8iB5yqP1Y4
 t6u9MW8Wwv5Zjjn9HC62PUtS46QGL4oCdvT3TixdHe/wJFqJ8P/Jpk6e4vVi36YTQRBgwA8GKHr
 jEwXy1x5z25UfQJr7TUJc8+8vbyVomgRvkEMDjaZj+8sWgtyRp4K/Vi9AeHukKn5Aiez4+dPJSg
 D45sORpF6+BMn2n6Aog+b/F2pZWGaDWoBGzMcJa++vYB5qZAPHcZBxX8ipHgk3ZsNKv8fbyR5DR
 WhuIULU7VSdhNVcQGyt6x/I7jiLB2A==
X-Proofpoint-ORIG-GUID: Ytn7S9kPdpFmU2bDHivcDR2Mqx3fUs7W
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F16301A0008
X-Stat-Signature: wedkqibcpr4d6t8ugfbjgwnhtgrcumge
X-Rspam-User: 
X-HE-Tag: 1763964915-141466
X-HE-Meta: U2FsdGVkX1+10BhlGKrS8lthL3qKBXBiJ87XsjLVeaaxzWmDx9xBxrnWnjJx1KRYWELSpw/WhuNALnEXOhHdvZvrPJLkm+poLP5qUFWMOYU8AHy8igQsa83E5mzABY1G0lxpyQTjT4cjEiQT4mVTsJYR3ZPIAPQI7CCB/nTK5Ofjk2fezR6+NyAAD4HKiUxewDe8GyQaEAmmObKjGyJZFMaq1vnyl0OW9IeBP1xkHgIDP2smrk6NjI+VFDweM3kdOORphNWOb13aaGZeTz3BLp8KI4hCGag1e1cpCo+7X402IO/ll7P27NYxyn7ACJV+i8K3KXj1OeEXcRa48FdAdBRucjNnwNOiLv0Gwy1mBK3dx+MRnhRFC5SkvoSkGpuYspF1yXLcfXJIkazvBOGy1y5wRIk2T4d6IM3URSz+X7u+RJQcmV3uUHWdj5CdtlO3sqw3xlH3RyXUCg3XyhboiDjCFZ+ajvQTmGF2v97XR9PXwvx5mrAGN2lk/cN5PJU4dP5TW6cINviXWHagFMM/ajvIjEx8dNWYLfkOZiO5+8jHqYNtzNIy2iwYLliledJiKcDOi5l6gQyxFQu3awj+KB9BsSxUttcKl+XztD4mS5Do55bBxmSPGl2E1IHoPuO53c5RZv36JoSO8l4gPNWNcC6IF2IkmOwWwPN/tsD8+949VPnch8fokM3upQESa87xxM5fhZXxpahLUISNfNagliVlpEdgP7FwuOfQeuEF7JldekYZYLhmwoy4136WmfEbt/WQsYLPVB/U9h3EKoo+8n9RK1VSFGDTV51WNdDLI0nn8AAOgQGyJ3QfN9A1kQtY6ZgS+jMwq0uxOTua5SFXwm3uTpighQt37KW5IW8F3N4VMmGzPTdtPT1pQ37BsxxWStPzQnk9hs6UJo7hWn0FIHzswyfubekUsC0nUxUhoDUOTN9jJi+cpdXD5gLX5orNFrGzwyjzdAlvne/mMPD
 0ct40cdC
 9X3iIApYr+SR6XyR5aacykv5LO2wxVihUrF3acagQRxV1W8bNBw3OnQokXCvrIFnLBFCAM2vBVwUY+ceGMRDXsklTgbahIMZSrmO79jeoEdVYP26TL3+RdBnrIpgm7Ypxgzt2XUDtFxOJuDl9WL4OPEjQ8sfCJm56xQHH8biuBjRAwvq4A4Nipz4cOyjb8UMUHSyF/Ys/Xk4/WMKT1egmY68foHv3cV2LguyAfLp7ekZ9fJBGHhHfd3XkDw2QmP/OoFDzJXQF18Wlwy9uplxVzEpxNj6zz43qpJTIaIlcAPhCNDA4NlCG0SFTjGI/nHl631XQ+2gycIaET874CxjFw6fjdz94uRNVsvIOU7BiaAiX94N8vKrbv5PeztXqFwmE1mskm1cR+CQ7eBBr7lC8ahsFxplYKO8DuTRdxGLWfU3g9DCQH8XNobJbN7vd2GcO3ziwwmdCp7fMTyTzK5aL3c4dCKTUK8UQeUx0U6Nej39Gd+dgRQcJt8FOooTMvKYdgvgk3vESaYZw7zczjYV00YKXtlxyAQ6XISxr+9cugToUoPqTDcjmNcpFIVL/gKCMwJY7Bn8q+00qGwZhL721ENLbtCKJSGYiMAQtHHZ84qMwdUSJnBfZ6l96+RyzjiHq61j+SIUZ4g7EezFUDf568q4ylIBhOIGvxI8iNXvJm8MjEttZE99qz92oARwdiiJbYHPbzASNhfBjv+9sRwVcdo1ER3pWGUXzGHZh6AXHOzEZ3emjc/7zI1RsS+68MpTETMsVx7jiiMfgqrL49ECoQfI70Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:27AM +0000, Matthew Wilcox (Oracle) wrote:
> Use page_slab() instead of virt_to_folio() followed by folio_slab().
> We do end up calling compound_head() twice for non-slab copies, but that
> will not be a problem once we allocate memdescs separately.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: linux-hardening@vger.kernel.org
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

