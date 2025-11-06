Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BDDCCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 08:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC5D8E000F; Thu,  6 Nov 2025 03:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2935B8E0002; Thu,  6 Nov 2025 03:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153D18E000F; Thu,  6 Nov 2025 03:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F148D8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:26:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CD5C1405FF
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:26:43 +0000 (UTC)
X-FDA: 84079501086.08.08CF9B1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 16BAB100005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:26:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aaf1SSpC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PHseMNR4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762417600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swOv+Yn1cxtMZAW9I9RVf54ZT6xLc2DI99gSCCPv5nY=;
	b=pTZE5/n/CL5mF33xi2+or68PyiP3+oIskuX9EASyPSKlZIyVTLP/wA+Y6nFtm62rDHxsC8
	6saBPUhg4PpDk0cWgIJVmeI+mlG9MYV6lZa8Gq8a8Qb1Mz9sd9gISL3hNo/zRnxq0EuGFg
	SHHsUY+31OBhGkbUrauVY8wQVBFYKJg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762417600; a=rsa-sha256;
	cv=pass;
	b=HY4hWALac7qjWb1k+p6lqge/1C7rUeP6GLVnePw8fdiXGkpzxBDQZzcg5zcfRbt+fu2bHc
	jNiUpzvi7nNjLPPlbZGcdNGe1eTpuyffmfUqZD5odzHvdkBoB/LycHTuB1HVWcxTVNDgpS
	psCLueUJh8j4vyGWG6EmyGqAdteVIIU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aaf1SSpC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PHseMNR4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A61CRVi017516;
	Thu, 6 Nov 2025 08:26:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=swOv+Yn1cxtMZAW9I9
	RVf54ZT6xLc2DI99gSCCPv5nY=; b=aaf1SSpCOPI7o5umh/sq5DuvZPuhDNCNQ0
	orCXW0G0IQIF2xAHfPK8XY1pl78k5RREszVhBtUSYhnVaRQ1cmI/NtE276Tiv/In
	Zhp94CZggbpgVZLmSatHOF+RdqKFz9yOS1p1mzUmycKpu2hYtMh5wHnfS/YGc44g
	k4lsgkkMx2sj73GGYeelF1jgDDna0ZPArQ8jzgMWt1YOQsQHE0N5sNY6kHOhXzb4
	bplW0zih0e1vImPFcdTM+BPllRHgpwJo7Fk8BsRHP/3LRwEIQ3JvjV9iX+XGP/e6
	xDq4hcXuPi4nQs/uEI9PFf9VtyqkuPmd5gu20ObKXysEYV2XZuIQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8aejshs2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 08:26:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A67Ic7j023183;
	Thu, 6 Nov 2025 08:26:32 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013014.outbound.protection.outlook.com [40.93.196.14])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nfna8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 08:26:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jo8GPPi51TRDt4t05Khp4jiZDkDbLKuvyZgGbymc937vIxkvZsz+35UWl6liMiA5tAKU3OdJBpseh42AQn0g9ZGhF/NvFmvfo18k1cPp8U8AzHWjf4LRiVhsqairK726C7XUKHZLWTJjGu01VD4OyB+HBjaIiMAlReHfV+W9VmAaiN+sdWYyBZ2v7gViE8dbLQ1kzHjOtKpWcTt8gONsDHa8i9nxvWZj2b7FK8lexwnkqQM0RrjiR+I/FJ8Xg06f39D66kQN+2+932Rs5RUEc9WmolGeH8xsGlFZVX6xpZ+RJhkUKNklDfwTGBcmDG99/H8+mbrsoRH4MIYbSap3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swOv+Yn1cxtMZAW9I9RVf54ZT6xLc2DI99gSCCPv5nY=;
 b=i73BQCp/AXcrFWDMdFOkQJpTi953oDeNGZL72NqNy3JGSSya4Oo8TTbzHXdAmsh4WDVcoc+W8/wle6sRtw4Fvmwa0vKOumpo8el7eqOGI88Lu0nbKOKpCTfWbOwBoQ80szVIQKHgu2ra7JkImLmvPrEOpdiaXX9RlBWpaxOhAl9Py8v3aqqNf8D3pyfBBrUs8CZae96QWPMLqzNqwMStF36R4W0zL++ROboA7dzYHoArh/Gs+G0Xo0yYPNPVSPyru1Eo5meXm7Qb9QQsi2ed193TE8AE3Yj7u27oph5BFPF/XafKMsFFjhJ8+ika2/+/8G4qkxdo+E6AuBIn/UBctw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swOv+Yn1cxtMZAW9I9RVf54ZT6xLc2DI99gSCCPv5nY=;
 b=PHseMNR4ZKRvXxuhHVWPSbWZR7SpMGNsiNbcEwjd+dnBeeikAs8mWHjWbDKL0oEE7Y6A5Ga4CGxQT7wHAQGBfmPn3YS9wyN5O94BnnG9Usk3jiYUJdgQy3HkSc4FceLo6TIbr1Cv2y3+zzKNLBebgi8WKj+505sRngXFdj2QYSI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ2PR10MB7760.namprd10.prod.outlook.com (2603:10b6:a03:574::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 08:26:28 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.007; Thu, 6 Nov 2025
 08:26:27 +0000
Date: Thu, 6 Nov 2025 17:26:15 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH 1/5] slab: make __slab_free() more clear
Message-ID: <aQxbp0cikSkiON5M@harry>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
 <20251105-sheaves-cleanups-v1-1-b8218e1ac7ef@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105-sheaves-cleanups-v1-1-b8218e1ac7ef@suse.cz>
X-ClientProxiedBy: SL2P216CA0148.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ2PR10MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e0d1b2-5590-44c7-b223-08de1d0e2e1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LxuA+olbTjM0JnlNRbDnrNWn4F0NeFu1urkaEvhwEPtRAvvGKPl9sWcLmF4J?=
 =?us-ascii?Q?uxNFUcKOxgCm+CStNizir4xEzYst3YpFWa4jJxNc2Lfp8uKJoeDSt9w+oW8F?=
 =?us-ascii?Q?e7yi+LVcINJ7QLWzng9oOGa8kV3Z6TJaKJHQI29jcEgJcDyTxo0HEc+dKRyt?=
 =?us-ascii?Q?3JQAj0rMDanW+UlgkHnAW7fxMPMgNC+PMuTYJ3OQ/wrT3hHhvEUjoDlaRQ0E?=
 =?us-ascii?Q?ita/voamazkiWRbgMkEZoalsOTfaQmLX1iYVA/ti2emXCS0DdvnW2q9jApbW?=
 =?us-ascii?Q?J5ztGW0g+hvlPhHgzMRoqYfMblGMqqTGRgPD+Fpd2HfJFH1dB/GLxYH6I/np?=
 =?us-ascii?Q?rs6wW6+9j+O72gF9VOAudSUiJdiT7kU5uQ0H+k6MJBSf3AforxcvhfVP8r0h?=
 =?us-ascii?Q?i8ks9ibA7vaavO8t8RAq0eW7TKf9V1mHGHKkcdoqO4udhgfriB4KqpQp2E8i?=
 =?us-ascii?Q?u8WDDfmHJ624JV2jXraWkNoaIB6ZkodfV7UvP03ywzOJBDHSk1qmLIwsin6j?=
 =?us-ascii?Q?U6+MGDxUeIVIyhM4zmY6S8lRDuLNZx8NP+l/fa/OzqWx4txdupWAxxKacmyv?=
 =?us-ascii?Q?koXIXSYJfFodkvlCPABn4G49NxBhTewp75QMuOCoCly/PT9DSy73c01sx6d8?=
 =?us-ascii?Q?lR0msW6+Aqh6370+OYuWDxbyJgEyD/famqgc0tLpyZBPlt1JR8Xvj1PlanZF?=
 =?us-ascii?Q?mgQw6ZDbX46T1wmEt19HZ0idUBtftz7aKWdqIULZkA2XWX2XLIhEzmRyMQdA?=
 =?us-ascii?Q?YG9AzZMbvxrDj+WfzAgUgKZdXuT1jwcjj177jnUHNEYTaK2AMKARFf1gC0fF?=
 =?us-ascii?Q?eWx/ziogFLBiPe8MDwCs7v90fYM+KOo7XBvfw2Ks1XIeb4NioGJxcVylqzoE?=
 =?us-ascii?Q?oWvdpF3oAAKnDpmFaRlBFcZJG5T6YaJhaCC5B0RM16Nt7tsh4GAxS/VJa0Y7?=
 =?us-ascii?Q?RLeA/xQqqMXnj3dnu7YWdcMgW07D9VLm4B+6fQbpVN0ryUG7DgCraTawxgP4?=
 =?us-ascii?Q?Cbfp/b36NqpCsQXlZU4oOJE+4yo3K3DlS/rp4edacxyCT+ExRJ7HdXp/UQid?=
 =?us-ascii?Q?MtICYJpjd5V0pdcfJxtyq0FOV97Qdpfjqe6UQFFsWy2AltJr5oJZ7La3gKNC?=
 =?us-ascii?Q?aRRjR0WIeijOD2+IPbXSnmZTETJaVVDNlII1STUdWRKeXanzEwKMcwkjl5kB?=
 =?us-ascii?Q?eAfuvB0tgLfBzX7qrKuQwo2EyCs7jcm/RrSGyhxaQ5cELyrsbVJA1J05KPrp?=
 =?us-ascii?Q?+Vg1UHcFMwPezSnmeGYH44QtVzCEbnXPh+xVLV/vTTKpdf7ttM0RUutCjU+6?=
 =?us-ascii?Q?i2oBp2rnAYYT9XJChHI1L2Sf9rBwCI92mLY+DC6keIJUZYX30Es3nWdlIpjZ?=
 =?us-ascii?Q?oOzHB4IMw+55mi1ec7uIIF0r2bAjJY2z5CGidRItH2EaiaOdXs4x3feeBa07?=
 =?us-ascii?Q?/ez2H7QVZqTd/XhYd50ytMYPJ85FdVu0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fk3Ig+9x5R5na8EOGJNAFaD97m3tCwa3Z4x8g/j3HFfipnZvcAeCl700ecpQ?=
 =?us-ascii?Q?zE8TkhP6H5gRm3Vzd+a/d5D0L+p6G4gzB82Gx/0gYx/Xo3jR3u/r14mU6sUG?=
 =?us-ascii?Q?KgjZrp9ocV36kZO7obh6BUmbivZYWUd5/ZQ0PAQFmmo0ONRjFcGhaJtGvCfv?=
 =?us-ascii?Q?od+J+MszQFiQJ1cuCZLKpo9y3Jg4vDG2/mAJ/mmpAcHvgXVJbuVR4rfia3/S?=
 =?us-ascii?Q?RT5tsieRayW5KPhLol3V8N1TA4BbDbPH85d0ybixKFfUV55h3+aa9pk33Dsr?=
 =?us-ascii?Q?j5IEtsDXLAxcJG6BovHmyyoRp4GDy1fik38qeqGJQ3ciTHXTXrHR1P/3CxJ/?=
 =?us-ascii?Q?ECb2gAVoBDAo9fDbAEHvTLl7BXzJbHIwU4yTWOGeQNRhYy6584UeG/Fm18KJ?=
 =?us-ascii?Q?Gp929Pas7hvnqD0xR/tF5FJewEt4yarW22ULveLkNUSAwJb5t0vMmNKAx/8V?=
 =?us-ascii?Q?hv2w95iEjeNPTzigHCg1AF15QlHaeJokBdLhFGLPd/csF0kwej42IOHKVFIq?=
 =?us-ascii?Q?tXFqnnny6dZPrXk40Ak63Hew9rVRsaTiyjX9fNrR3PPIj10G3XOC3Rjotm3v?=
 =?us-ascii?Q?06s6idzGpPzWHLiI3NslW4kSheBsT/lft+pwxAZvL646sOD3xVauG6JIGRER?=
 =?us-ascii?Q?JVNeK/E+3lyKxE34n9/eh9EksKx30XxUUe1EZ6g8uE8DVQ6V1csMtVDlWxYE?=
 =?us-ascii?Q?JfNbtZtW3tei8e+TL3NGOAP6gIEQZzwK53hGfBr5LeUsf6bOWpos3Ww22FU1?=
 =?us-ascii?Q?0NbFcm9k5+7V+Fi9WArR7rsAY9xZ66d9YJqkOHu73MWiQ7mSk4oB4aitocFp?=
 =?us-ascii?Q?tqRDKcVq7FgxFKPBkWf2li8p5m7lDYmRvZq1Drv/zyY1+Aeh2kVFhPZmkFo+?=
 =?us-ascii?Q?8QJS/q0gqRDAtB2w1c8dNwi/bSOoc3xuJhauXG/sYQ0cOYl2CEU7+z9rU6xF?=
 =?us-ascii?Q?mggOYKgDRx8MMxfW+FXPFBTf4n3/l0Yov3bm5ZQN2IX6wVw6W9m8QSULkuSE?=
 =?us-ascii?Q?8L29Pa4aDqxoztVxzlmF4WVs8OHyLLHNuofeCUsZFN2BObA9J6+Bv5Vah5yt?=
 =?us-ascii?Q?FogWVln49UMIL6h96MdBR5Vx9tP3Egs2XvKOimb00Qg7de8G83yaInon8A7O?=
 =?us-ascii?Q?dnKLsepL2CZe8brp2FeFsm/M5ikjX57E/KzIIdhs3d6JmVMwdp2UmQDxP8UD?=
 =?us-ascii?Q?fu8N08GQNw910TFXMoJx4OYCkjg2Hf0HIIsI8Nyyb3WPOxIhw6vwUhrwbkAa?=
 =?us-ascii?Q?pq/Dr19CEYzzBOQs2pJKMlbJTsXyIbWcSEdy1I+G36d1eexqGmvaMZ18/8Rk?=
 =?us-ascii?Q?R4MyuRtJFNnXUQDzQk1b61kpnMmgzHw2HbcumJTosycJ6bLVAIqNGsu9VaRD?=
 =?us-ascii?Q?+kjbi+DDSx7h6d455uei/G6m2pYD4pZlTvavaeC7kcixyg3+53931B5oIAYY?=
 =?us-ascii?Q?B2QHtkJxGHj4rxaBwyPbt70P+1MV3My0NNxs22cwcv5jUxph3eZFh+u4eJvg?=
 =?us-ascii?Q?zRwgpy6dLE3JVI1wdJDbrOPJm/yczM66RpmNt0SE1Flgr9cAvQcNUerywflR?=
 =?us-ascii?Q?H8EH7UqFeCfDzpRNV02BRfMxO3b0mEAQDfqU+KG8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qRq7k+WVcy+fGKng5LQ4/ixQyKZ6XqeaGBmE/bmpN/a+hiAbaTHHmSrPk/30+BEa0SmhyNUJmd5/qDCyvJ1iqzVHSgdfhqi4dFm62VbPmka9HA/1xBiy91edu8pmwt3PJjheH38Ot1I3boYMrrgtSugt3BQDJQRqr8CEeLtQ+Wl91fItiHMlNJnjrsnnQvvSx8fFElJmuy2hI1GdazkFmObOapyTO4oehloqYwMvRXVxUlwJa7vT3hAt8Act40xZ8/gePEfOigfGPNbYhvfW3ClqDECjVx9CdoQ+3XoCYKfDhs4I6txaOCj7ite5Ub5gg6rgIMcckH/OsbQ9JwROj6zSY+OFFrSxG9BpgO6pGN1IPiYH6k52A3ZtoDGk5pLoIOV0kGRCpmd4ChH7Hv4+jF30OGb/YxMiW6jrLs/c739tx5lMd5K3PLL1suDvqcP0FJn0AMEu83qZjyGLSIwx9abTIMyrvi/VXDy33mFTLFXDrPFzxRtAOYSfgfwRCfqpEPhsGpQhZ+RxtUBnxN9pDjv2UnhraBnX50ArPfQAmU8bXiuWq/FEueZsT5sdtmhoepvBXtMX56cpYoxCsCRtnYsSvw9jo03ehZ+kDhV03EA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e0d1b2-5590-44c7-b223-08de1d0e2e1f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 08:26:27.7056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pLDMyJ2h/9Iqwxozau52dlKA9LaTtPISujM8ZlzH7SodTV9ULxHzi3QjcS/h1XayaN1Dup0PwSNdoMP9mVDiRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7760
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_01,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511060067
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMCBTYWx0ZWRfX5mlzTtTFNGOM
 WQKDFptWios967NlwJmk2m05m1m/nQQmuyNdlfeRp5wrxdxN0hSp4k08NLVPd10kwbpVBqDcFco
 BPJt5idfb67cSWhlV0g/5ASL1wPh7FlUxPmDKS+RigAre7OS9Wc3jU9JkXTVdCK3kxtgcX0dALN
 6KYCo9QhRfOTA+NKgJbYkCcG07ykh7CFpPCwGElSE6rYOrHEP46FkiWv4jU8vu6DjnI22h1WbXM
 Q7Kq6u2flfgzITG2+aWDKhHdLQckZqhjYoKFhb71PtaHF1tVsIlGYq2e0SOsa/kNovVT6WH6gEP
 xkTr/zNysXJR906fDv74V2LeSDXua06UlOuKPJxmMdBr8JyoY+oiW39MtkakM8SErdQAr5kpo1X
 sFiwnERyFIrcELw2j/zU7Uqcirtspf7Jx0VWyE/ph2sZVdZAKbw=
X-Authority-Analysis: v=2.4 cv=R8IO2NRX c=1 sm=1 tr=0 ts=690c5bba b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=nN8h-l-cuGAFRwiFnzwA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12123
X-Proofpoint-ORIG-GUID: f9kxo_ICtnsK7CDNRqFQjmQpJhmaJMyK
X-Proofpoint-GUID: f9kxo_ICtnsK7CDNRqFQjmQpJhmaJMyK
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16BAB100005
X-Stat-Signature: h9d3o978n98o4qr6zopwpixh9gzo7dzx
X-Rspam-User: 
X-HE-Tag: 1762417599-114330
X-HE-Meta: U2FsdGVkX18U/mRyQqsHocdZ2A2o8PYf5mUfe3PEtOwCgN6lzmXJJIiVpS5ZegsW3Ia565URuw5X91/kVyrkL+l/GdJqTLmRN3wDexNKvgAqH3/hr9QqG8xzmkzK2Mz+WUNHJPAQJmSql2v1Lmob7jkUOcQ6tzaMDK/7Te9BUM98aFnXllSsN6An44xXhFnCpo5ha/2D6TbswSSj2rZhSBgrqLSJV61Uv/CIWEr6kAJP2VkScSJOvOoWBfe+HbZvzHQUW47M1/7zrZ7sDwzcETf1A2r0pOC1mOVpOTAHYW4WQH11S8GV7aTXE5djQniNpRMM9rMNPHlmCLMFEqDmB6n1uI+z2Y2x5/Jnj8d8KgD7YtvVdBHQRz1fk5RnvevK+yI7Iq78nIHzNovU/YC45KYwjjwoftsNf/Ge7kzTA/4XsH9wW4I+Sfy4gdTO0w4l8dOR/VXTUVvJ3ltNjGM/VoNsSCmcuidZNyQJi76rz4jbfCI7v5210uY78udqsNYJRrJKr5gWfvyhHkYEwvqjUjjBVrTkPDH3soisrhx6Jy7IBPnaaQ1YFLk0AVd4U7nhQTFyTM3fNQ9DfiME/bEm8k/9wdVA1/NB5ldVvMnqR4mu8eI+RDVWtwq9Xxoj6757EVJaRfd/qmv8BC3Kf0jU7V3JGpk54dqdGOiND/ug2hAh6mT8P2WFwETm7+IaMtO+9/WhigXRS1ZRNaitpcSDY9+aVhXRLYK5KvKimV13iIlMBeyf6Vxv7ncctGUCwtsBRoIbKleJ1vUEnQbOWEy2/vx+gTHFyBeNHrhvYSFw6Tx0m5TueJdshO3Nwohcb2zyqDYlZRz55QGnWaZA5GvF6iSOF3STdBTNL7msq5tvOhLOvkH/LO6zpCa1jdGMQP1iIdlMOTjLSS4JmsRj50kH/t/2lQ/tmFhhDk6MmP6KNZb5PwGBmjcbyh34VY59sY3DlNATNW9yAHrAg6r6H/j
 RQkoJ6ub
 9Vkq6H+HkQDgGFmTseMWXTr3YWPvDP1QD36S4ZOyX0RRuFzMhFqBLV3nMMOV552aVNXVVaQi/oOy3sb5NnfrmGVgw4/niEM/QHhEmrbAaQphhjYGMoMepfjunOcQhyHQRme/84ln/GiZDIiIvPrcf5PEKDLkWcGlHHqVC/DPNEDmsR0XIvSDKHcNQgwUs3u413SehpiSw0zQQp7X3cU3DjJKY3jp7LiWwXPGdoJeZAbhDi3Ju7+7gtZK+r1lxXlpbBwi+X+5/Gd7EyLZwMVry+m1CaxO7bqhPmssz3LWkSpaJNj+c5f13NnqP7yRUBbXLjIjotybSle0jAgKpe7fMexBX5l3qWlOQ5kynfHMdRvOfIvDNyOHkTGkoKQ5k5yQHJV1uvJjZ+zIPcUNJJ2CqZtwx7XjzsjKgzC525viPuf+n8Q2IQDVdeg2YzGOjP0RqdaagWVjpaVXWU7BQYzs/JCbkq+sVb8Kcgya5e6mXQsROfAcokH61lI+tLPkpP4x30Kifn+WEskUF9QHhV7S2QyupTTkgZUQ8ncifeEIrk1lwM96HmajEgktEUOb9zymdKofWsDI0SMcys5rVXjdyRvwe68gzYH5YG+KzmFgskzS4bYOkaYUWtZDt0/stJgcGYNcKvZW8dTs0UTuBLFQF7R6XNG8mK5oHgfDO6j95nugdV4jxZdWBrzQfgz0WNQiiEGAjwVVHB/sEXfTOGRW4IHdxRL6hf7M86Dx7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 10:05:29AM +0100, Vlastimil Babka wrote:
> The function is tricky and many of its tests are hard to understand. Try
> to improve that by using more descriptively named variables and added
> comments.
> 
> - rename 'prior' to 'old_head' to match the head and tail parameters
> - introduce a 'bool was_full' to make it more obvious what we are
>   testing instead of the !prior and prior tests

Yeah I recall these were cryptic when I was analyzing slab few years
ago :)

> - add or improve comments in various places to explain what we're doing
> 
> Also replace kmem_cache_has_cpu_partial() tests with
> IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) which are compile-time constants.
>
> We can do that because the kmem_cache_debug(s) case is handled upfront
> via free_to_partial_list().

This makes sense. By the way, should we also check IS_ENABLED(CONFIG_SLUB_TINY)
in kmem_cache_has_cpu_partial()?

> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

The code is much cleaner!

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

