Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D09CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 09:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC896B00B5; Thu, 21 Aug 2025 05:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83BC6B00B6; Thu, 21 Aug 2025 05:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C226B00B7; Thu, 21 Aug 2025 05:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE1D86B00B5
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:38:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89863160328
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:38:50 +0000 (UTC)
X-FDA: 83800265220.11.3AFF292
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 438E180009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:38:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C+ZoqJ3j;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="USNn01//";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755769127; a=rsa-sha256;
	cv=pass;
	b=JKQOK+K3iwyUynEW6+ZE0+3zBVjtzVazMJATYJmZmv/hQPBzJgABCD5pP/fvTM/BGDdenA
	0HrF3PqFNlR37yGY/R7nBIQ4pOw3V+QBWNqlpfnfuUzoaZwE3c+WzytQgd+TVguZfap8Mw
	WfafDCB1drTCtOTiUdekv7qwzQYoQJ0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C+ZoqJ3j;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="USNn01//";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755769127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4t5u4dqyziEWnbDdbtfpmHCYp5feS0GZxauNNlqbwY=;
	b=fXFQJB71GzPOHxX5w943cvrjVMZ2Q9AumS3qOZl4UAf95oq74rDOoQLJjyPd3WDB7dvgfI
	3LOJVefjCpxlUtqVj97+lvXyZXTZ2ZW6cXdXgZLIxMmPo3Ic+IDiHQ8AZVZ4HDdg2zzm/V
	WUMlrZM0KvZPc4ch+Dp2Tfh89PQmp6w=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57L8lvqF021835;
	Thu, 21 Aug 2025 09:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+4t5u4dqyziEWnbDdb
	tfpmHCYp5feS0GZxauNNlqbwY=; b=C+ZoqJ3jzp+IFw4VCnreXbkBQwhNEqlt2R
	xYldRhQXOApTZP9LSqcazY1Xnn25xlroqGTV1WzrTFhlxK5o8ojxcTfhTcm5mMk1
	RJE7c6u+dYZ+RJDdGgFai6xq6EqR7icy53xvlSC8QWqdQC89GfH6TNueQuBJph5Y
	49fQmpvfkrDgTECZ/tecV8odsmillAx0JiHpSBoo6sViDTdQIznKlBQMMTZFG/q7
	r7XvdlLXp7nlFdxjwkljtVTAQc+qW0wn98+QMXf5o/dQT3oZ6Qfk382lHDV2KbdJ
	PPJfSs+mRy12IfHgoRyh+JRpghsUHTB57YW2WvkOnzqLfa3WLDXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsu2sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 09:33:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57L952uZ039701;
	Thu, 21 Aug 2025 09:33:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3rv5vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 09:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F++rEZPiOvFczSUXBzMsDSbjb6tciOnt7BA7mbS9vzTRWcTDtMsfK5cmE9VjDDXDUa+GuzJ909LjZjo5jhrP23UyHhaTNWIYn93zsUTlKQMjwkqETv0a2caLXlrxaZbkdIIQ2GcSDU7zR5l2jO7DfLSWwGh+VeX0o/lAKgux4g3rwIUcoMsDDDmpF4N9s90XEXdTI5MIo0ApaujDh01JhDvJZSxc5n/HDEAAfXSe0y6//DRorH7zU2G3EvPqctR0x6Mq6aGcgS+RN+wDCTWcXkoKP0R7LgGV+nPjslQvUkObmO6nReHJ7kr2yi5F3oliDPnhRYMAA0c3Q3tLeZEveA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4t5u4dqyziEWnbDdbtfpmHCYp5feS0GZxauNNlqbwY=;
 b=fjOCDNkI+R6lP06agbBnAkLVTWVNrm/4L/onF6rqzEEMY/sK/eEngroT4yY3IiXb7Eh4MSVVHre49Glc15FcCOXl0i0DNP1TQYFjVubXicENgI1YoVDpF3mNP6IVmqgEB3ChTQQm17FHnEqOutbINet27CaNiX2KC121O/H+PjTNXy+aA/Aj24nZRWGfx2dHDLbEUKK2kHpACZ63db7bCsziApp7q5pPPi5nDCE6FVv5mj7sBVNxp3EsEW9JS2ib0FA6/KwoRUD5PxYubTIEk+ClxMCtvLEh40AwyxZ7Io08bZ9DMT8DTGvUc4QohneBG4iLJdW2/nPR+0k/1eTcPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4t5u4dqyziEWnbDdbtfpmHCYp5feS0GZxauNNlqbwY=;
 b=USNn01//lj+W3jJOhcHkNLbPN7tUmTTGOmeJOF7HqJytt970BChxxhiRKfZJp2zW0DI6wW1u9BUdOmvD4nHanYkw9xZf2KNwoCN1aawy/NcrWrftCMUorYerjwQJJOcEuWpSntvRJaTxupvpK78HsbLp9sEtuvs/RoSNrBFpUoY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4526.namprd10.prod.outlook.com (2603:10b6:a03:2d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 09:32:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 09:32:56 +0000
Date: Thu, 21 Aug 2025 10:32:53 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, andrealmeid@igalia.com, dave@stgolabs.net,
        dvhart@infradead.org, feng.han@honor.com, liam.howlett@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, liulu.liu@honor.com,
        mhocko@suse.com, mingo@redhat.com, npache@redhat.com,
        peterz@infradead.org, rientjes@google.com, shakeel.butt@linux.dev,
        tglx@linutronix.de
Subject: Re: [PATCH v4 3/3] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite orders
Message-ID: <c2b5c573-c0a3-4063-9a79-d3b06a615fe2@lucifer.local>
References: <8e20a389-9733-4882-85a0-b244046b8b51@lucifer.local>
 <20250819151834.20414-1-zhongjinji@honor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819151834.20414-1-zhongjinji@honor.com>
X-ClientProxiedBy: MM0P280CA0120.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4526:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e2b495c-25b7-4b3c-a063-08dde095b60d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qh38LBwakVGKu9L8xE3C+74BKkvlZizPAKeA27VZmym1zP5aHXq0lZuB/sWS?=
 =?us-ascii?Q?NWoJyP7QjVHoBPTphvbM3uW1A//WKN0TxdQG29q1xN3NvOitIlTuSr0DXjAs?=
 =?us-ascii?Q?LaxN2nj1NuSgiS3b1P6Z719V2o1UEOCYrUZm+ul4Dr+YlkTC4Qg5Ig5P6thW?=
 =?us-ascii?Q?LZVkpkOEh8tyaNPrHkZC3eGyDI7mkaVoJlvPi/RnQc5TnUSW6z83irACSvnk?=
 =?us-ascii?Q?UDEi6QXbRCYRXv4Y11iuWw5o/ZfR2wbZldBOrj1cNNK/JjUSAOwoBJ5KZ7if?=
 =?us-ascii?Q?Hi6dNqDTLanR5l0F5HclRE0DPhpwMqA28+Lju6bVmSnVVLe7JXgqIvzuYEJ0?=
 =?us-ascii?Q?7MR7og6+Sncsy94qTY0rZi1d8ywKLH8BNzVX5ikUMwMI6OmCoFsCc1/2qVCP?=
 =?us-ascii?Q?+CkRcWAfJ3CvU2HJ07CO7n+Adc/lOQn0l6yGqGz4X2VnWzzI458JtGfxOiC2?=
 =?us-ascii?Q?svIdzdpXESX31FIlXehya/a06t4l6hN5UMfD65dSwlC/6UxqL3LfFMHAABWr?=
 =?us-ascii?Q?SbbTiA/V/q52OzXHHsZd4/noeYlC3R9d/0R+UdKssx1s2al5AQ9zPHX2L2TQ?=
 =?us-ascii?Q?gt3XVM/pIiRI0x778jp7C+55cGvKqO5Fp5e1R9cCVBBqTbcRTa76bzLVVLmy?=
 =?us-ascii?Q?HIvAhoSH8rwXb+Vf6D1lNoSx/gIma/Xudf9gsrkURR7IUKEMKCU4wt0I6s7X?=
 =?us-ascii?Q?/JsIPmyXjo/lre6uXOegjEjHU2GXdHtXcCKOf2c0qnSaaOrNjGyUY8HGTeR3?=
 =?us-ascii?Q?ywiS4BcmLyoH4gY+QoiReOWpenM7cNIZXLU0iioAOIspvoeqeEHq/AWP3u8A?=
 =?us-ascii?Q?ThQ/G/e45nhJLt4p6mvuCNC8wIfZrd81Ril9lL0OP2rhZuftCMoyEFrnstTn?=
 =?us-ascii?Q?UFVMADI0II6BIpp7ST9zFkvu3e3rdY06qPj/tvSsJ942DdAzQyZX66nsOUWY?=
 =?us-ascii?Q?wvq4xp1tyasie1R0lBAM/Mt02cZelw4jGKZmjwXxImyWDjHYEKy1yZsNKyRL?=
 =?us-ascii?Q?nawOpUSeoiCR7qOZHhxpPT+P2osV4d7yuvDNbIRGnV3mCbqgPY484z7S7yP8?=
 =?us-ascii?Q?VjZXFuxVo+2cYgK8+Jh1XOEIkogguC9Cf8uD9OOe4BB4cXwBljuBk3VKEYiH?=
 =?us-ascii?Q?lR6HYTM4Yveb6IwX1sH1L+DcZp3FpWtHIM6Ug8BZ0hulEgUkHYyFpBRw+yiX?=
 =?us-ascii?Q?+BeTfU+h2ZPtcg7fRpYlhTyHWfYrV9aJYS9CtbGh+IzZ2TwDHjkXCN07eHHu?=
 =?us-ascii?Q?uySQQeFuCI+onh3FXhSzAo4hKf36RM5bkL4w58yizPz4ErmupdLrG+MK7Uz0?=
 =?us-ascii?Q?m5vZUr+MnwaH9kPaplEdV1X5m77j2PdHaVikfmP6RyWT34oMEy5dGBXkZZza?=
 =?us-ascii?Q?4YgNRbXDQKPHyZWUy8+d2EV82x2JsrjZIHcS/pwtSA2b7YhlbGoyymfYyTtM?=
 =?us-ascii?Q?CUTTjct9rpg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9jrogwMLPot4zdKhGHLxa2nHkQXvrE4tZJriY/Us3bDdA4XjSuSTWTd47w3L?=
 =?us-ascii?Q?LKX5H/qQ5vKIx5f27Jkzhqn76YAzZ499q55NaqlArxqU4EjK2v+15bqyPSav?=
 =?us-ascii?Q?QpTk1MbMc5J7ZCraO3L0jMPusV4aCDlAJ8psWd9Rb5xTBtSgBR4U3JRP/VXv?=
 =?us-ascii?Q?hnQCiMmEAolC5DBif/qT2gEQhyrHs/R+tnAEU71gJ8H3bIgIjtRALSfD7QZu?=
 =?us-ascii?Q?MYewtOoNlWqNlRAcU4QPLT9M1ORaEGSmDWfG/VhvZeVVROl+MGjht0ouQH4R?=
 =?us-ascii?Q?YmiYTRmZU7bXuUhOX1Dmt6EaR0Ky8JAfQvDDDGCQtvsdki58vy3S43Dax2Ri?=
 =?us-ascii?Q?oRzTTGWn0M1AhptCadHsEryuX1Fj+uKXltIISbZsBuAPppsdgRFuX4skRzKa?=
 =?us-ascii?Q?xQVHc+/w+lsSbag2165kWplE2IVmKE9b1olY6mu0RpxUeGQXTOFCzh9vwIYx?=
 =?us-ascii?Q?5gP27Xd3htF8TXUR8iLo2qpYvY3HUjCjIriKfEsSzdicueY8DZlObZFV9VzC?=
 =?us-ascii?Q?D7lOwJBT69uqcV0vm59aTQXOOUoVvm2EfPMDu1YX/DujdwpHrbqTQApa9LjK?=
 =?us-ascii?Q?FLpzV8jH9tgH/YrIwbGD6TNFXjZ/ypGA2dOLQtoL6TdkZj23BhCCInnrewQF?=
 =?us-ascii?Q?BZ2lFP9m1s2YcVaYKwdOQIACg3f6xdYVPhIE5QvKJiz985SUr+l7MWU02aQB?=
 =?us-ascii?Q?ClDrpQhbbaUpwuHmtCrnqAX4pzu/94rOj5ngqP0n4UWLQSy0qrx1BLQZAA0W?=
 =?us-ascii?Q?O1Y3yKp3BXmbeSpAWrbmVhKiLA94fq5RiAh8/NnLiF6BBu3B/7xtzGXu8wIW?=
 =?us-ascii?Q?b3j7f9ZdyPuVll0M4Ht+3ioFPXaWVslw+fiZeQ40jKXevaZ1Bin1TYObb528?=
 =?us-ascii?Q?b0VcZXI/DNG9/fLtnbtCCk42IqlJN94FU7Jhk6t9x4/QppOxlleOxVQ1xnIk?=
 =?us-ascii?Q?SIturaZcoQkovh0LruP5t7o4xE8ANH+7rFEBb34rK9Ge/EftXb4uyEzLoPP8?=
 =?us-ascii?Q?NcNW9ctcFEjiSaqy2uWWabRKNiJYAZ5+dAutZ33/27Riz2tqOwaBdlghFTXX?=
 =?us-ascii?Q?yFPwIMuPeU3KkrgmRdjyQpeojmR8Ww0MAEDe/bXu4R/iQcsqzyttkw1suPEE?=
 =?us-ascii?Q?SepZ/vqIziDLqJdI6qBDMxMvSb1D+B4wDuoY9jPTGBwXlsl24o0ngOn5XWZy?=
 =?us-ascii?Q?D6AwAqnAsd0BjxmH+yO7KpYilT32NvveU2vsUFTdH4f4aaDdIJMiLyOuki/N?=
 =?us-ascii?Q?Df/LTlP4tqc8IBX5IUQSBn03MOmOEStVUlvgDlQrleWyMZryRbPSfhapewkK?=
 =?us-ascii?Q?lPkmlJprifNgldptgRIuKkYm2d7r8sKJZfG5ZgGb9vcn1poODnO4uvF8h7cY?=
 =?us-ascii?Q?KClsP+CIyjMsN/CCikOuUOQmX+F6QLvgsfkbhkCZYAWTU7OdTrXMi5lsgsh8?=
 =?us-ascii?Q?OzhdIFWp4LWxWSRSD4eXHIR6rnPHPj6kT4eQ6ogDGbsK03ih8/UZzBmo+RJZ?=
 =?us-ascii?Q?goqkJB3PCwYqu5RS7y57IiWB8HQdUraWl/ipDmxmbAWEg8dxMUy5woFKPJYl?=
 =?us-ascii?Q?a9sILPbizfxvkEh820SCSAXEPQdpHtmzse5RauPgXMSu8w/t5amZ0Ocsyjly?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9M8Ttquamigh1G28wfUHJERv1Qq7zUsrsqG2klioGxfEnj8W8i46qvF5SU/HCEDxe6/I1rLZawTJKynYZlAR1FVcGPtwhNk/+AwjNB/m1GhpzwJwvdUBdGFoIHlzic642N9E2FImz6Tj5v04fdwEEelpP60V/GuwMh3BbG0gntnnkEnkaqnCtgGHdGkHuplosJp9GcOeHUF7tCYXSYZKaJvCKYtUiWE2xjY6aedCtma6wPhOu9AJpIPOE6r5K9v14568w2m+xkKHUppWz9LJG2GFJOLeeVzK252j3eSj3jk+BGaW+DxRqkPFd3eqBi8+bhQVQdMhdVVyiWQYf5VMhBQN3uXwMfRTngfnEM9sJ7XGKY+VDR7mDH/R4xpXsGSl3p40VGt0P0lEHefMK5P7Q774MKyGXTFeo4wbFpKMQ0bFhlttaDVOMkm7tb7ITkH7MfRjKv1HhIvlBJNG6rxnnqPigyZgEepqLiTEJbPpdSZbZTWDedMYKeWxLeyrq0MEP3DJJtL6SLOjAs7mpymBV08bizuHZDhMKGRtZJIiIfLrVwF8Ky0oKA5aNZkwTeEA9i1fk8bhRw16E7GpSf7M9A3Ddzi/LJEnm0CYi/WXH3c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2b495c-25b7-4b3c-a063-08dde095b60d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 09:32:56.6792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmBMmUpiwnJQQq1KcfPVb13DUxeaTHdAKJQ2FaP2UieONQP7HC268h2BV+MQDGwx0qKKtJUEpTYF6nHgt3Jqa0H1qhJwPDYglpmqwPDvcGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4526
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_02,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210075
X-Proofpoint-GUID: 8fz3mGFsM2H9BOd6C7Gu7l-fSvPRRYep
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a6e7e6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=CvlTB2HrAAAA:8 a=sij-3tNmjFWCw85rS8cA:9
 a=CjuIK1q_8ugA:10 a=67QrwF-mucXG56UA-v15:22
X-Proofpoint-ORIG-GUID: 8fz3mGFsM2H9BOd6C7Gu7l-fSvPRRYep
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX8HyZSaCVPWcC
 pFHAZQ60aajFz+pVu2VscRtR6ozClVuanuUbCtc76m2ctKYeq9to6XlpchhTlqNWMt9fMLPPYA+
 lkmJD7+CH3qyroZPVsJP+jLEa0XMaBcDaXGVoaiyWDAvx6n1qv8kzQC7kwQdZxP0rc7K7v5fH7f
 9wi1kPxb/kYSACd/2XckU3GwNObJjdI71tqGXnS3OiOkknrSIp/YlgpuJwH7f4mgk4XU7bI01/l
 3Qi3+4mA84d6sF6kSMz9/8KgZ17KD955ywmZr1PhNwM5paSdnjOw7S55x8ZdvvNrEYoieDX5bcH
 NA8MbzrfQRu1BH8PfXKVO8tnuJEA3jujHwtYj9urH3z6Tkl6OC8ZpZwrpWRSo8bjb+1rXmue3FB
 v8n93pWyehj4w4LfvHsPf/tzR0SlCQ==
X-Rspamd-Queue-Id: 438E180009
X-Stat-Signature: cys9wkx81816955xzeemb4knaowx9afc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755769127-323748
X-HE-Meta: U2FsdGVkX1+0p2xva4NjZrg9xeFonNZ/ApDI/kXK6EhJaeoUeIC8DeUTJLTCvYJ7QIhFTaI/q1gDAMsCOACi5ArDY0YnQvQ0AFIBVspr5Vv5g7uZMgyUkMRMa3inwEzaA/JNptTD1fwevZEvGtnU2lJH7qOli0lF3mzAdXr6d+96ABXe277GDXnJk8LM1GIVlzwohtUS/WCKjz5O4Zmo+O0fPtFKsnUw6bwnKMiH94xVxUO3gQDL1KV+soYS5Q9P/f97SPD0Dt7PcXgcQQhbY7jJNL2BrE+AXeXuU3h9RBf7iWNtnf8vJ+fzdYUkH3XHHFdbiPdZY2GY2sxvG2Ua9SzfZOqHHo+/t5kYezXkOt8ynxXWIohLc6lkugkDXNug2dJuQRh5/uaxVtUP2tpSXYJKlMhiP4D+c2Ind5Fu2JtWZC0/4S1/j8ZiErIUb6nXGXo3wVesJKR2LYikVC4V6FTR6RXnval2pOgUJPL0DreQJIS4FOr25SD+EhceWDrvwTbaPdL1aRBxfD5dFo7USRAVuq9s7vWIZ9f8XFH4v+kG9tGei+jzJAU8ysU8fIPcKQkRbLAxofejSR9qiP/d+Wyd1m0n19uxrs8jcA3AhmxPzbeHcrAWun2VMEGg552Nd19w6ZUP31+z4b4ftLXPWtWAajfDAFLxazXWZM9JjodPKL4nuoTx8XlX5EF30oYfg1iox0JIjCrGC7t+ZgzSGxxaDC3i4ZLM5NoUbvu2Cgsi9vpghAeOexv2JsiCBsBNE16rIbg98h+mXWY/jFSllIv7n4r1KadvttipzYuuU3djnGtjVszsLX0HOciv+6DUJw4k+F8RsmlwzmYjf32HE8ebw23eMWMO8KrHkcoDvupqMo+XymAx3/DBsx2sZ/3R9iFxWkEdxTN2zAwClfKW2MD8miXG/mRFG1WnkjwDFE62bIRFx3uCFx/uGf511DE3S7SVbLGIn25zfHKG0oz
 WKsMHy1N
 6zsyaAxh6WZ67R9UpV2rmCtKFhlCDL6cstPA/utJHYKbzTX0uYwU9XVaK6VIAJ+YsQ+Eh1/OYyAq5hhdVKZnMSzCRRi/Uc4OQWlEmm24BKSNWguj6dSiHABFGtB2so1ji2ouGxkip4zaiNQlQnlEnsJ1YJcmIqtkTT9rfpPIw7f8pZmc5m1+C7s6UsmHDaY/rtYnEn2eIwZVwPsY8+iqD/y/XP8/CD80pNK7+XHsyobCo+clgCSh4+Ti/dcPlBUlJ4KE4/znnPYcGLKz47qs41zgPZ42hPaK7rwdVkiIC8oK373u5bZzGOl7Bm0pJKJwWipxCbZTHAObdxryHJ6+hIF6+/62MyJVTz6zPlI1qIfgLk8NHTRDwdM6PbMpZzGXHEiNgh4selTTXRvqVzJva7zogSzNWhN7/CRTJm/P0VTG29Te7TBmOtRBpVEaz23UDC7L+oPKY7ltqF287sO0HdusgJcz9fw/OO8Yixar8RsXQFO7JktSwRfwLA82dcVSkDnAWf/A4CsxvNVQgFz6dLBJ5GCs531aHIy8hTMROpN9avEcpXpaj6njJzRlP4NLUfJHZHhwiUrkX2rMGp6gEHNwWCDPngpCeaSH5HE+xVimClXwJ6NE8Y2yE9Nf6Off0FAwBqEc8srHP3hlcJiGsaSTTBeJwUUBU5YfhMkrSzDfc84gWe2mQO9/W8giE7eY3RfYAU3T5SlSp5OV3wdQB4Wc+l5Gk9hfX2F3VU8Tjs7mRGbSyL3X7xh3oeL982DsFVaa91py2XlNOD4VMdNX+AAwG2Uny7ai8oNMETM6xehiDfv9SPiaw1BDVMeauD6f2t8aTfctWb0lIIbol0o3UPI1mVNu6c7aZjRqS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 11:18:34PM +0800, zhongjinji wrote:
> > On Thu, Aug 14, 2025 at 09:55:55PM +0800, zhongjinji@honor.com wrote:
> > > From: zhongjinji <zhongjinji@honor.com>
> > >
> > > When a process is OOM killed, if the OOM reaper and the thread running
> > > exit_mmap() execute at the same time, both will traverse the vma's maple
> > > tree along the same path. They may easily unmap the same vma, causing them
> > > to compete for the pte spinlock. This increases unnecessary load, causing
> > > the execution time of the OOM reaper and the thread running exit_mmap() to
> > > increase.
> >
> > You're not giving any numbers, and this seems pretty niche, you really
> > exiting that many processes with the reaper running at the exact same time
> > that this is an issue? Waiting on a spinlock also?
> >
> > This commit message is very unconvincing.
>
> This is the perf data: the first one is without this patch applied, and the
> second one is with this patch applied.  It is obvious that without this patch,
> the lock contention on the pte spinlock will be very intense.

>
> |--99.74%-- oom_reaper
> |    |--76.67%-- unmap_page_range
> |    |    |--33.70%-- __pte_offset_map_lock
> |    |    |    |--98.46%-- _raw_spin_lock
> |    |    |--27.61%-- free_swap_and_cache_nr
> |    |    |--16.40%-- folio_remove_rmap_ptes
> |    |    |--12.25%-- tlb_flush_mmu
> |    |--12.61%-- tlb_finish_mmu
>
>
> |--98.84%-- oom_reaper
> |    |--53.45%-- unmap_page_range
> |    |    |--24.29%-- [hit in function]
> |    |    |--48.06%-- folio_remove_rmap_ptes
> |    |    |--17.99%-- tlb_flush_mmu
> |    |    |--1.72%-- __pte_offset_map_lock
> |    |
> |    |--30.43%-- tlb_finish_mmu

Right yes thanks for providing this.

I'm still not convinced by this approach however, it feels like you're papering
over a crack for a problematic hack that needs to be solved at a different
level.

It feels like the whole waiting around thing is a hack to paper over something
and then we're introducing another hack to make that work in a specific
scenario.

I also am not clear (perhaps you answered it elsewhere) how you're encountering
this at a scale for it to be a meaningful issue?

Also not sure we should be changing core mm to support perf issues with using an
effectively-deprecated interface (cgroup v1)?

>
> > >
> > > When a process exits, exit_mmap() traverses the vma's maple tree from low to high
> > > address. To reduce the chance of unmapping the same vma simultaneously,
> > > the OOM reaper should traverse vma's tree from high to low address. This reduces
> > > lock contention when unmapping the same vma.
> >
> > Are they going to run through and do their work in exactly the same time,
> > or might one 'run past' the other and you still have an issue?
> >
> > Seems very vague and timing dependent and again, not convincing.
> >
> > >
> > > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > > ---
> > >  include/linux/mm.h | 3 +++
> > >  mm/oom_kill.c      | 9 +++++++--
> > >  2 files changed, 10 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 0c44bb8ce544..b665ea3c30eb 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -923,6 +923,9 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
> > >  #define for_each_vma_range(__vmi, __vma, __end)				\
> > >  	while (((__vma) = vma_find(&(__vmi), (__end))) != NULL)
> > >
> > > +#define for_each_vma_reverse(__vmi, __vma)					\
> > > +	while (((__vma) = vma_prev(&(__vmi))) != NULL)
> >
> > Please don't casually add an undocumented public VMA iterator hidden in a
> > patch doing something else :)
> >
> > Won't this skip the first VMA? Not sure this is really worth having as a
> > general thing anyway, it's not many people who want to do this in reverse.
>
> I got it. mas_find_rev() should be used instead of vma_prev().
>
> > > +
> > >  #ifdef CONFIG_SHMEM
> > >  /*
> > >   * The vma_is_shmem is not inline because it is used only by slow
> > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > index 7ae4001e47c1..602d6836098a 100644
> > > --- a/mm/oom_kill.c
> > > +++ b/mm/oom_kill.c
> > > @@ -517,7 +517,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
> > >  {
> > >  	struct vm_area_struct *vma;
> > >  	bool ret = true;
> > > -	VMA_ITERATOR(vmi, mm, 0);
> > > +	VMA_ITERATOR(vmi, mm, ULONG_MAX);
> > >
> > >  	/*
> > >  	 * Tell all users of get_user/copy_from_user etc... that the content
> > > @@ -527,7 +527,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
> > >  	 */
> > >  	set_bit(MMF_UNSTABLE, &mm->flags);
> > >
> > > -	for_each_vma(vmi, vma) {
> > > +	/*
> > > +	 * When two tasks unmap the same vma at the same time, they may contend for the
> > > +	 * pte spinlock. To avoid traversing the same vma as exit_mmap unmap, traverse
> > > +	 * the vma maple tree in reverse order.
> > > +	 */
> >
> > Except you won't necessarily avoid anything, as if one walker is faster
> > than the other they'll run ahead, plus of course they'll have a cross-over
> > where they share the same PTE anyway.
> >
> > I feel like maybe you've got a fairly specific situation that indicates an
> > issue elsewhere and you're maybe solving the wrong problem here?
> >
> > > +	for_each_vma_reverse(vmi, vma) {
> > >  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
> > >  			continue;
> > >
> > > --
> > > 2.17.1
> > >
> > >

