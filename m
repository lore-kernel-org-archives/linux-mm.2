Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FC7D74EC2
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E664F6B04D1; Fri, 23 Jan 2026 08:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A9E6B04D2; Fri, 23 Jan 2026 08:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12BA6B04D3; Fri, 23 Jan 2026 08:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC5516B04D1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:45:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 760F913A6AD
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:45:20 +0000 (UTC)
X-FDA: 84363350400.01.B77BE53
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0CF7EA0008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:45:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VByHYpzJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ibP6VHrS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769175917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCEB9nAnfg+z1DKBnqbMdyGKmZ97Fd0P8Q/m7nv/CQ4=;
	b=uZ4bw1S98ptKmackLiDMGdNO7rLvNoJCCDSuA1RK53G6oZ/NMubEloqMkl38LLROYextW/
	ZYIaCd24rjiyAAsTCAj8Q+Yqu/dyXJlSvF1Te2lQ5+Tsek+w0N5BFnUmJ/al95dBppU+hA
	XauAN+3bJ7ci6FgaweDDkJLjnPjsSgM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769175917; a=rsa-sha256;
	cv=pass;
	b=lO3QOHo5Dk0Gt4CL01uPRt8erex6wNSEnd1aCkxw8gI2FASypB0DLgL18s012L6bxxMnC7
	AZ9FjGCgH5/L8Jjo4N3afCn+R9fVFsd9G0f66fDh676mF+5DXxcta7cWUBc6nSceF5IezZ
	sHtNsbe14euau+X9wdRJmf/99YefFKw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VByHYpzJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ibP6VHrS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NDVCmT2271108;
	Fri, 23 Jan 2026 13:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iCEB9nAnfg+z1DKBnq
	bMdyGKmZ97Fd0P8Q/m7nv/CQ4=; b=VByHYpzJTAUvJwPL3fp0vBTJPjWJSIsvU4
	58O3neZeX+O4w9fQbmDDpqlxbBApAyFOy4zw1n3tgUuxRF2lE2b/mf3PkMiThUP7
	5mKUjMSmmAm+NfeaM8QNB7wjOApchNNOBvY43k1WNrkfdOEXw1nrgvLmATUCDhoA
	sQgM5WiCZ/Z3fjcEKbeZ/dyY+eNgmvA7/J/ibO0p4IjyQVkTpDZGrRPQrDeaDUVJ
	xNKV9kcTtwreQ6V31LX2g4U1w7heWyS3p/u5FrWmY69YBwowdEEgtdCYjaid/cHw
	lGLPur0jZoAC0LVkD4RRVqZxI/aLB8NV01KpqImVz4snL8QZq/DQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9tgef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 13:45:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NCCuAN035914;
	Fri, 23 Jan 2026 13:45:05 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010026.outbound.protection.outlook.com [52.101.61.26])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bux4y7ace-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 13:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rq4NsfPFMw8t3OJYfLuIFazXyhFuYDqo9DNnxLqMX9nr7Fopu9CfHHQXN1Kc7WaFzHaVfBNiklzc4t+IvBqQWGeACG2P8i4JETQ4EK6RuedxfKqLh+RYYL0rJFHQ2RhZJeqIp0TKEACmSfczMbuCiuhBkfkAWxJK+b0+mlh7/66Mrrz5+vdur/rYaLY9Kk3X8lBEULAFFrAas+EgZk78MPmqfLWn33abjXvWuuT41fcu312HMs1WEeZ8K3hOOXXkErljhaqlhXWXQAiS548FRLDSehBGAoh3aKRkzB/BOkrbb3+z+/6IYY5FE5toQWLpEPO0ehbEU3FJI0g/MaTScQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCEB9nAnfg+z1DKBnqbMdyGKmZ97Fd0P8Q/m7nv/CQ4=;
 b=NJJMpq7yx/ywmjcorAsrOhguhpc0QHIKrKE1juSmYverdKkSa2FB5fjTZTuUTTXaBZfN0J+ktE5oLDnNvhgIa1u4ywHv+C2fiImzqJ2eu3YoLQ0HZK/KklBLmsHqNxBfXTHQWfExuLoTAxi1am5KExM0xrgTFfrqeaRod8ugQbOPsTPAjOM7rJmRpAmTChqGU57RjzYTplfcmi9ubYXzgm8fr+iFsF7xRy6+iEaqQMavzJMbEzav4wV5WQq1+f9aAWsFHBf/FPC4RKHylP8aeV1NHxFwq1+DLytnUw/YPrig3JBv8KAdgl2bHGo3YBU/K81mr+uHNVoyD+9ELk+TcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCEB9nAnfg+z1DKBnqbMdyGKmZ97Fd0P8Q/m7nv/CQ4=;
 b=ibP6VHrSMWRUXqU0wMvxtvPPTFoWSCjatqk8DuZ/U0T/dokSKpfaUaCg68vF5nYLOo//7FfccZMZkLjqhP3YxpbJZM8Mo57YnBetgsUQHbcSV4TOpj2gSijpNvT+VbIaBx1ya1Br3uVpK8dRlHqae5NFGpwwYxCp0ctptAPTCvg=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.13; Fri, 23 Jan
 2026 13:45:01 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 13:44:59 +0000
Date: Fri, 23 Jan 2026 13:45:02 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 02/10] mm/vma: document possible vma->vm_refcnt
 values and reference comment
Message-ID: <b5e16d20-0ed6-401f-9c01-8efa35c49f64@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <a28f56dbe5057385b07498684dfb105918bf3644.1769086312.git.lorenzo.stoakes@oracle.com>
 <7876e97c-9afb-418a-8ef7-5f4f306b7eea@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7876e97c-9afb-418a-8ef7-5f4f306b7eea@suse.cz>
X-ClientProxiedBy: LO4P265CA0133.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: 48376743-1d86-4198-062b-08de5a8599d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cYL6NkVcs7w/PCZ2cf11Xv+OZ/OcB2K58WKKPlz0744hS+N601mJln/yKf8n?=
 =?us-ascii?Q?VzqaT7RNWvI3Zf0pLrm5raI2Uog9bhXukHtXsJVgz1LnJYnW/akcJIGgHWuJ?=
 =?us-ascii?Q?7N0PXH9bpCCy7Tvc2mV4Nh55nu7DKp66mtmvvg8BNeA8KwkGohZJjinP6tNO?=
 =?us-ascii?Q?Qojy9/35qbqfpdibyQz+3HEzBSr0XAuRBGHC8Dr3pGl/aCm5avdquA8yTQk0?=
 =?us-ascii?Q?yT8BIjWxJ2NJR2IqCouZ4HZ5v2zO4VaPpmQOo9XjEJbR8LkdlRzPnar0+hSX?=
 =?us-ascii?Q?lFVmOjPiM6spJwZw7D/hA1dQL6HWpOxjXAHSrj+d9iw2rtpEOBX3CLzKvLwx?=
 =?us-ascii?Q?j6XJWokI+NemZchYAITPRHuuuvFSRRBsuBxOnk9pIp6Eny73wLmtFzgrPlau?=
 =?us-ascii?Q?y4/Nrm+GqlBkdHPW+eiFGB9ehjBMh+/vqwWfFvFPJ2sC2XKQxNZJycA74GX4?=
 =?us-ascii?Q?QsZIaw83vmo1z3/JqeF/EIERz4WWQz8D4Y7xgGDuodRkdXr46hfBPO/tv15Q?=
 =?us-ascii?Q?55lFNXBlAYDh5xALUBKmHV5eyxN/Ln2lHv7d1terpGHQnWY0B/5uqsRPlWrG?=
 =?us-ascii?Q?t/U5fstEm2LIt2lf0HKoc6XjwxDHfhudVBgr+vDmjzmwto/2EJTcOdlcQKZI?=
 =?us-ascii?Q?bwbKWx+A++xaS08A1JEoXXJKLaED8bL8XkLMECVMn2BSYloyDsUuCR61JE5U?=
 =?us-ascii?Q?aX2knwnXRTQzQ0QXsa0Bhk1UxK5hjwqSPW8Wj/FB5voZ7UEILpC0ZlGrqkSS?=
 =?us-ascii?Q?bjII9ajvL/RIaLU8dBd+JfFC+l+XfSpcNlbVBgXHdUoNup6gj1N4HV469oHv?=
 =?us-ascii?Q?pRGjjJqd3GxZhoWj+54dkvzx/0V8NZJRaEFY5bxvojXUbgQIFHBocedenFB1?=
 =?us-ascii?Q?PKSvqRhRgbe576ajv4GIZBPXCvNgza111ZFBR9jTP2RU2cmPNQvuLjf73kv5?=
 =?us-ascii?Q?VYmxp1B2LOIsxjNW+5DyPCyycmJjlAqqtZnA3LLS2qTHpBiv8Wy7LRewuTJZ?=
 =?us-ascii?Q?rMUn/m8I8HP4rzj835L3LUIfyqlfeY1Mqn5bmscerTrV1TT/RBgJ19GqU0gl?=
 =?us-ascii?Q?Bo2XKOZK4bzZDpic6AWz2sg5efwVVgllev258atVAOWHifC7nj5wSwbfEJWK?=
 =?us-ascii?Q?4sJnLyyjdT83rtAQGZ/JabTYdy/ixaoJPuuk5270Cd3CPHxrQciWz0Hlt3YP?=
 =?us-ascii?Q?hqUJ8uFDHuf137Wg45f3/0rEPluIq0k5KQ6/yJ2Bcsz9TwjiSqhV898G0ZVu?=
 =?us-ascii?Q?lc32RhKDY5y0eacE0mUsvwvtS4s+VSvL8RTC/v9VYXxfQFq1hHdejDs7Msy5?=
 =?us-ascii?Q?N579529o2mT6KMOmOlrfPVIo6WhOFMFywiq922B1BP/dlMG2YR7CXJNd66iM?=
 =?us-ascii?Q?2qHHC+ioOi0NZs7e3HBM36SYRCnhst85bV5cmyUS52DA4N+1rZYJfgeBzHz7?=
 =?us-ascii?Q?hBt6KtGjjN+gJVMXieNF+G2z6iqtOMXl+5VkPlaL7IxWITci7VVWBBQk8zNf?=
 =?us-ascii?Q?PIdBfMFD84ScVudTWnqdyrNksHLqwwrRui7ElPdK5x2/moD/8MehVsTAp0Dj?=
 =?us-ascii?Q?MqRlxWyG+ew8Qz48aW8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oKG3K1d+HxpmD6PJGTgFtCadA+eQ3Kny6y2JPFaaG6Tx2yWG6/asOHk3Budt?=
 =?us-ascii?Q?eg3GKBVIp0Gc/PGOxDq8Gd/AoCtNZowjNbgglffm2Brmdmz7NSZSFWW6Vycd?=
 =?us-ascii?Q?DW4Wv2L5Ba7wWmplyezl0ew3yGNZ7bqagDWl/ujDJAy1qBnZ4I6irhECLXtp?=
 =?us-ascii?Q?9KCdCDJP09suDmnbU1chT8JwVZ8TEMY8ICtpWVAS5eLSVRfEpXwLCuZBgXzx?=
 =?us-ascii?Q?H4UI7bOpH1DlHcVW8Fbr8kUrhfOPyI574FDihJ2Zz5LurdiPxcsVIQJD13kP?=
 =?us-ascii?Q?s42FEsNPmoKUamfflRzUXlJCOAbvKV1O/gOSKyUawJ/Ro52B6cvkjANbv16k?=
 =?us-ascii?Q?IcnL7pKxUmTOgeTsJ3Z1E4cj1X/D/NvY3t6K/py+qkoaIDc3nUXh1cs9BeIm?=
 =?us-ascii?Q?017thMB5gzrK16qqRLA9OnGz4Lv/k7m6Id+WtEjCXKVahZyG5kPlxoSrO+HF?=
 =?us-ascii?Q?CRDHXuvYlnVC3Va7VvXejiSweiPEzczmoDRnRwCC29TOtKOw/axuIVeT9nvA?=
 =?us-ascii?Q?Wqnp9Z3dqJKkAA4kyFC1J2cPuDyU+o1inRS/ktUClQFkFcGWIc/oKp2va5YJ?=
 =?us-ascii?Q?rfsMt+hE7huvvvt+8QhoaEXC8M6SGalHtsMCO5PZJrRGSSydh/f+xwIABwoW?=
 =?us-ascii?Q?5dIxP+b+laK+QahrIKhlhlFAGUHeU1zADl/nzIXWhbiRDig+iLFWiiKbKcnh?=
 =?us-ascii?Q?e6jH9g2rznZew+ae4gOBwQwtocULFQnj2UDTxWINOpQr/06E9jaDiiijbmmG?=
 =?us-ascii?Q?SbQx+rt4AECl/p0M1lDgrrAwP02P6mpoF01P9tNNbWrtTXPAmfiB/dEXR773?=
 =?us-ascii?Q?O8s910lipMlz0MhSqsxmztxUpnXrPOniJW5n3ETZRZ7yw/o7vamuCgHkEsPf?=
 =?us-ascii?Q?3FsS6XsNv6tUbKhkeWkVRXxdeL6VEgRvq05jFSkii2rojuLLI39iYQJKQU5I?=
 =?us-ascii?Q?027ZubSrFQfbPcEZGaTlvJ3HbBM2OeX+qbyZEXgVJIIRMmFRJv/Xbt0IY1oB?=
 =?us-ascii?Q?tLSJSeGRKgrHbQq+D/tWXRInTHP9hAwBNZIRtKuLBpVknbbtEz+S1qC9zz+O?=
 =?us-ascii?Q?CsvQakHWcZSLgIP8K9flUYcYZZMgLIRlUDtp7svGvQ6JmCVCCBOygwcSAfCa?=
 =?us-ascii?Q?FjgKp2LnEVdfAaGySXJ34o6c5MP7TgwJJgIfXFTlXT/RlfWd2y3hK5dFEctt?=
 =?us-ascii?Q?6alTpngiryKPM4QT+4v/oPKx3Nb7M8r3tHtdq2SS5/lImQ0DMf+FMXiajUml?=
 =?us-ascii?Q?VOhVg86QfsdKExPbmNU28SIIKxfAosGb840pnxeK+NClpMaz0e6izC46Lv+M?=
 =?us-ascii?Q?Ws7lZWffaTWFnFBBw1PyRKlEA+Huwv09GlTCGDeNtRQ9GFYJ3JUn52BQE9jZ?=
 =?us-ascii?Q?iys4wrVYeJkmmXbwn9/lr4HGTQnDEKZ69L/9DkE4Xkx+2KSm3zPY5ET4Y5pF?=
 =?us-ascii?Q?EUGA/oLb9lu8QYRAZx9H1GpFrE77fJd8MzJw1UrJ5kIc8AqsRXCrsU8xlr5R?=
 =?us-ascii?Q?+OUfmvhQfJkZBFszv+R7LSKvxGqLP4prXIFpevxM74WBG3U8shaqdZdrDkP2?=
 =?us-ascii?Q?D9UVOBphnQtE71Et57n4leIa8EgsYCubxAeOOj4Gb+U+nNFRML5ek4TUSaHS?=
 =?us-ascii?Q?abSJEmfSPg0e0t9U9YSJgPfMITHQ/f69LZZ+FD++tCEgpwM2t/gR+cEMkIYA?=
 =?us-ascii?Q?AXwuXN5ZMPWLa4tjpSdWZcMxScE9+/YBl9huGva1o2sV0T9T1Kbg97a9oN3w?=
 =?us-ascii?Q?DyD6wv4SXfyfngzwjxzpBYpdmk89XDE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LGwq+FtUONaE89Shng/ppWhMo4uJf3BHlfZjtBG9FUVNxrPqmKilgbRYU0XSRIlL1GTl2WAU44UDghFtBoz48OM2GEJ94wiJzaGolCPUaTvRP77lYZmeZon8aoV7GnjU60sOQcu0JRPvMTfYAuT2XShO6j87wOr+ycnxX9DKUM0yzO3yawAh+eJb6qOHm/05YzXqQWStrU/vTn3LW3IKPcHqqAdwC2eN9xBo2gRtTHmyHRMpAp9Oob1ebOww9TMEcCj3UcqgjyzC9Gt1H1RXXYCVcSZre4pB9LENJ2zvr2er1TDX5l8JzgLrm1V9PwCdQZa4w3UHv2twgvbv402dfE0NDH9r8lEnBvXwwIZrVStzLnXYtVTErQwi4IGNXkaJPIzKsUkJ4dYlbpKXscrOal/K3/ELz1R5yGOmMvd+LXI0FpLcWTZmdLXx2Nuv70xmCCMkzPmiJKAk+DzBiXcciU3myenKIBXnTe2IFpbSO+q3GHuiZFyhmw2ykjZ6F8D9svrE/xCfcV1qwpcz0JNJOIE1kgxB3jtdfF5k+goRjt9iLnMYsGdPFZ8+whZ4CdX00SPFeJZnKBgORHfLT8WsW82Gwk/mfscu3JZZaNHvajg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48376743-1d86-4198-062b-08de5a8599d7
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 13:44:59.2938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHW4b0Z3A6AgHaKtDBZvK/IrKdarAnYvUxnPnMH4CfbyOyIPo/dapQLRnJrvahvGVYoj0L0aSWZrzyGu3Aig3rqHhaGEjM91znANQ8D1W5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230113
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69737b62 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=EXwbCB1cwIVMgY1J_6gA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 6F9iNxYq1qjQhhGepznP5WpMeeGgGxnO
X-Proofpoint-ORIG-GUID: 6F9iNxYq1qjQhhGepznP5WpMeeGgGxnO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExMyBTYWx0ZWRfXxUAYuLbIKBX2
 JabsO/O9bn2KSRfVq+Y2ueZmhubrCzZgIShjTGJkD00vjqFZqlmfOGfWcT519RFkv+vXUUyjB0M
 5YoE5o43SIYsWlN4iqeZGZd/KdSDu1+ioflgrR6CmokQSv2yzW7Gghkv/hfLQU0ESIe5oOmu+Gp
 eVMcVeP1uI9NzR5W2AoXBAhWwCkSgj3Qdm8x26GTReUPhLCscEUkjaol95kUuFeL4GZKbObI5J9
 3lDcOcpuTfl4hugoxIrUO14QPVVKXS/raUlyxHSfsW1dpAzb/NuRuSHHkqhFyNsKh7wB7IDxJQK
 KBw5LZeOp5VrncbXgSZMiIRj0zilCVubZ/axzxrPdLSTwkLL30rLLioeG/gts58MqcQOmtc0trh
 IUN6RTSqlqj0VWNSec8Q47w7ui94s6/s41BRTq832Ak6HjHMzYqp9iMGpqDzRVHJCjX2EZLkcGc
 kjrRkCCrwlnG5yG4D9w==
X-Rspamd-Queue-Id: 0CF7EA0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: btix3w8a6i7mn6oy6qx7qkb8agj3icmi
X-HE-Tag: 1769175916-908324
X-HE-Meta: U2FsdGVkX1/UsMRGMOfsCXquOuwLpzn3nYgKqDW1+tNSfSfRwW8p97x9udUsnRHRCzh/ka1VkbB8m+VkildTQvhjE/1QgZFdu7zZ4wNYdidrqGro2scfEdmRoniNf8PovARmAHXl5cGS66bLE1s74R0v1+FGEORFP2MRysSjMWJzVzxg2xg9SKefVumiSPQRB4IMgCcYRFCLcdXLKTkXQkeBsWe64jOHVjRncbwUCDWA9jqVGoRGM9h6mz4kro8SltoB7j8v7PbSe+lbhKmbxjUvDyn5oyKjeV8ovF1L47lWSSpqvqmcK/WPnegfwM4Y/6J9znO7eXUesQ5M3wrHBrO5mhNIxptJPTbtCbu6+kUPpeK/iaQE95RsoHUTtD0YqzDWMrJ0y4ByYqu7GmZKb1XFKOm53Q0aq4PlZWBKdww0kqiPjpKun99a7GuyVGhht1Z8+Nf3DCcD1Nr48XrGXg3e5yH8whjWObyCycyEgNT4jWiZxR+tRYj+0byYBzpWrUSDsEn+1kuZPe5TBkOVEBCZgpQO//U4qYbbaM3QZSSatHoqgkeKxy15YVetUiDy4lZwEHZIU9Be5FxH9/LThM4aR6z2AAcmBJo9jo7sp4GBdSG+zxCzPbZvWU+I578coG4pIX3ToNGNmBb5Z36qMo7QJxDSwfnQVO5AWbrDEnS8GyaJ2rRS8bw6TrNftPWBAjn1zkpUFWkXKK8WN/3jtuWyvYFu1A6fTVNULRrRt6ZHLD6vuT2M7jCp4qZnw8mFOOO6qQF+2BiBlTcYK5ifG601JbFnQru6LvP/c+w36i19XZ7SfwgZLg5F4Up/E2TU4EtK5sCko4yWEdBIBzxi0mOPAH//LeZo5HLraCpcFfFGOnIyWEabHpmcM7WjKJ/qx7eIbWQp4XDsaXim2/oZ2Vco4PV5AroRmMBptwqDM73NqerEVxFfpVypdXgHkNwdNQu1YmZXSGHvHuRbHDZ
 UurhKTyl
 YnTFnZpedZNJuHsDcHdTQFN5MErU1EuE+403DmAzrD1zeXx5CIbPWOxggvTQkzY8C7BoVCttHpm5cHWrDFHF3wcTzb3wdV9gkCwYLxFCDPr+5yrRS4npougb0exCG9vuGGGIAznuCKE1aYnqKcLExzahuZBVZD5uDt30XUeaIuUiXfKlfZKE5NR6xOpdlV3WIeCet4DBqU0WbYpLE3Ahp8Vpu9n9/nbykCyB9utx9jIvC68WMUyCJW0n/ZooUCbWOOExN9Chzk1jKeo+NV1uR2mu75YtG4ITTuyFiTASKfgcFGslQpOqStAXTksFPdgBtRb4gj97e0vA159jsH7i7h16Z6MCbbkFfLQ+fcsXdslbYapvzcUMTmpVExL/qZok/fp0HABNDCB36Soorgf+OS3+7lrxF/LuxLpO0FJk+cwDPmgr0KfegxOJUt8izbi+I+MvYYYzQHS0P2OQPw76mIMWSVAojRusIZFOAaHcONbV7HI/p0cnQl3NCg227I0knL7gletqZW8rb4u/TiUan4KsM6ORbATr+9YdO06oj8cISFACkY3BbnMjv4q/r6lyzm35dBoBArHFBgo8791XRPvuGhblVn117qVDutX7oBrdQNN6tMAQ5dEXZmKzB3MngX7ggXU7QEQUqAGb/UovA0lZY6nmqTDp2FNNIYKjr35uaiQzYDuxkHi9GBTAm8SY05LX2XzIw9n21enUZxQ7vTUIoUiCEsR6U00Ml
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 05:48:07PM +0100, Vlastimil Babka wrote:
> On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > The possible vma->vm_refcnt values are confusing and vague, explain in
> > detail what these can be in a comment describing the vma->vm_refcnt field
> > and reference this comment in various places that read/write this field.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Thanks, very useful. Forgive my nitpicks :) It's because it's tricky so best
> try to be as precise as possible, I believe.

Ack.

>
> > ---
> >  include/linux/mm_types.h  | 39 +++++++++++++++++++++++++++++++++++++--
> >  include/linux/mmap_lock.h |  7 +++++++
> >  mm/mmap_lock.c            |  6 ++++++
> >  3 files changed, 50 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 94de392ed3c5..e5ee66f84d9a 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
> >   * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
> >   * vma_start_read() that the reference count should be left alone.
> >   *
> > - * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
> > + * See the comment describing vm_refcnt in vm_area_struct for details as to
> > + * which values the VMA reference count can be.
> >   */
> >  #define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
> >  #define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
> > @@ -989,7 +990,41 @@ struct vm_area_struct {
> >  	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
> >  #endif
> >  #ifdef CONFIG_PER_VMA_LOCK
> > -	/* Unstable RCU readers are allowed to read this. */
> > +	/*
> > +	 * Used to keep track of the number of references taken by VMA read or
> > +	 * write locks. May have the VM_REFCNT_EXCLUDE_READERS_FLAG set
>
> I wonder about the "or write locks" part. The process of acquiring it uses
> VM_REFCNT_EXCLUDE_READERS_FLAG but then the writer doesn't hold a 1
> refcount? (the sentence could be read it way IMHO) It's vma being attached
> that does, AFAIK?

Right the intent is to say that, in the process of excluding readers, a write
lock can vary the reference count.

It's a pity we can't describe the refcnt in some sensible, logical way as it's
really being overloaded quite a bit for multiple things.

It really isn't actually keeping track of references (other than read locks
taken).

OK so I have updated this to say:

	 * Used to keep track of firstly, whether the VMA is attached, secondly,
	 * if attached, how many read locks are taken, and thirdly, if the
	 * VM_REFCNT_EXCLUDE_READERS_FLAG is set, whether any read locks held
	 * are currently in the process of being excluded.

>
> > +	 * indicating that a thread has entered __vma_enter_locked() and is
> > +	 * waiting on any outstanding read locks to exit.
> > +	 *
> > +	 * This value can be equal to:
> > +	 *
> > +	 * 0 - Detached.
>
> Is it worth saying that readers can't increment the refcount?

Added, updated to say:

	 * 0 - Detached. IMPORTANT: when the refcnt is zero, readers cannot
	 * increment it.

>
> > +	 * 1 - Unlocked or write-locked.
>
> "Attached and either unlocked or write-locked." ?
>
> (see how "write-locked" isn't reflected, I argued above)

I'm not sure what you mean, a write lock requires the VMA to be attached (or it
bails out on attempted write lock). So it's kind of implicit right?

But yes better to be explicit, so have replaced with your suggestion.

>
> > +	 *
> > +	 * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikely)
> > +	 * write-locked with other threads having temporarily incremented the
> > +	 * reference count prior to determining it is write-locked and
> > +	 * decrementing it again.
>
> Ack.
>
> > +	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> > +	 * __vma_exit_locked() completion which will decrement the reference
> > +	 * count to zero. IMPORTANT - at this stage no further readers can
> > +	 * increment the reference count. It can only be reduced.
> > +	 *
> > +	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - Either an attached VMA pending
> > +	 * __vma_exit_locked() completion which will decrement the reference
> > +	 * count to one, OR a detached VMA waiting on a single spurious reader
> > +	 * to decrement reference count. IMPORTANT - as above, no further
> > +	 * readers can increment the reference count.
> > +	 *
> > +	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - VMA is waiting on readers,
>
> "VMA is waiting" sounds weird? a thread might be, but VMA itself?
> (similarly in the previous paragraph)

I was trying to make it a bit more succinct that way I think, but agreed
it's unclear. Have replaced with:

	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
	 * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
	 * thread is detaching a VMA and is waiting on a single spurious reader
	 * in order to decrement the reference count. IMPORTANT - as above, no
	 * further readers can increment the reference count.
	 *
	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread either
	 * write-locking or detaching a VMA is waiting on readers to
	 * exit. IMPORTANT - as above, no ruther readers can increment the
	 * reference count.

Cheers, Lorenzo

