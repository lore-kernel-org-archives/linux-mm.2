Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDAA7C98301
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDEB46B0005; Fri, 16 Jan 2026 15:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D0A6B0088; Fri, 16 Jan 2026 15:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEFA6B0089; Fri, 16 Jan 2026 15:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA1956B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:20:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BF85160200
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:20:13 +0000 (UTC)
X-FDA: 84338943906.03.8CC2021
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id A2C714000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:20:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gFhyXovl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="f8/0FGT1";
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768594809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEOML9PqSty+DxFBrGfhVqHCg8L4owqil+rokfEF3+I=;
	b=P5S0ph8prkHy2Qsf8tcIeGPIQ5C6kHIBqbQtxbXBG1WuMVJoyj104qHm7aIxHrcCCYsuSt
	vJkfLoqehaI+tXHBBATyKRw46vaxzRnmTOLxenAME6g7JIzJ6USK25BaMuz7tP4ehLiaqt
	UKhnii2fx4ebPTK56AXrZUyZgbC4d0c=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gFhyXovl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="f8/0FGT1";
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768594809; a=rsa-sha256;
	cv=pass;
	b=r70WEYmI1xKlcj2T5hSTOvqdnBfe5oNpNq8u3js6WUlN42pDJkheFSy5EYpeG5qicCgz5Y
	K9LP7K3eATnSNcdRwawGICC3s3/XaKVIjZutM/csEuy04oqxvJ5aVXsGLPBjUQCu6XUrvL
	F+e93xy08mEyLlpZF30ISddFf0uGhaY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GEOwjg1431572;
	Fri, 16 Jan 2026 20:19:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hEOML9PqSty+DxFBrG
	fhVqHCg8L4owqil+rokfEF3+I=; b=gFhyXovlkv7nbj1HEatq6oU9mCDev5t0bw
	hooxHXK6fcM0qgyWsEaHWziAjH1ZJ6IQenxZorMueoMD805SWS80ArkPJ/zzKUjA
	59M0AzmCUmnYS2nmSyFeZg9YaTLx1Wup54EFq1nSMUeE8qOkNG4SBF8JB4lRy3D6
	yTbY4WGhzeAUVH4n4LEX8WLgx09mmRVodvZYXxAncnEgNRKvo9StMOfS5gajK0PN
	VGpYmQZ9y+YkDqaYV1xolnN0KdJitRLEBMSX3a25fCaYkub/jRZkNptE5OyItHUy
	ZTdIkkT0Cmf1rzCUCUK/XFq+XwnYiE8i3ocFRnqrk1qFBDN9AzkA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre42nqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 20:19:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GIFP5R035219;
	Fri, 16 Jan 2026 20:19:53 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012066.outbound.protection.outlook.com [40.107.200.66])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7h4ehk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 20:19:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kXwIVtbcOezj51WItqZPFZEpG5s59Fls4iyCpTBI9eBJgI+0jhZparu+QnQtAZkQ1Okcay3tnXYFhVYjntKdGajZSryEujLU7QeBzJAZ2Nr5gv7nPb4F6zMcPeDr/m6AL78jhxJmQ+qQN8K9TdRy4jgwwtzGaGSNk0yaxI8jMMEvsDZ4AE2e1jbD2FDpPi7gkvKwXm9km+WlMyWVcC7FMH/F3nSDJFmYCyHO9o/0mat9RWLrvlYS3cRT8tHYtb50sYcTOBOF9ZtevkNg3ByoOeyaLpGluP0nVD3fSQUOc3CJzrrWIvRbdDgYhSjv+7pm56xCY/exj/w8bfVC0IhRGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEOML9PqSty+DxFBrGfhVqHCg8L4owqil+rokfEF3+I=;
 b=peqJubkKYMO5cshpTFOFesBRcUsnmyA0gvybFOyITimYNjwD/8WZeet1ZpcHi9DlE0N9bssNnsyemOzhl6Z+F6Hsi7N8/XzoLMCizdakPgUQrvy8zP7cHbTgnLsflU+zEgFWaUD1by7WmxKNROKziZ1qeSw2q1r4xYrZYVIOW86/IRaz0OasYXrHh6dkFwULqVeVtoBuMOYs6PqNZonl37A7P0tmFUOyDDCRFSiYV4F+OvS06GC4bELTO/iIdPy2T4/fgMis73rNIn4Kb5Via7VT3WW3IR59S5Xt6sYaKpVn0gHqTualKtI3ejVGokZarJdegs/eekNAgnLUOGlq4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEOML9PqSty+DxFBrGfhVqHCg8L4owqil+rokfEF3+I=;
 b=f8/0FGT1xQZdUEuBn7fYomazJD56CWOwit7sUxYfE645l+ScbGuFmXD+U/9jY0mjiG2ArFYNkop7gukeUB6SwlnBZAsDA0GKIYp7idrn2PEgJ/woY7dQwh1fuiywxxFPnKcoDX60x5zrHJYtaUD4qCiIh1JMT2lEFl+JoMHk5gk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6269.namprd10.prod.outlook.com (2603:10b6:8:d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 16 Jan
 2026 20:19:46 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Fri, 16 Jan 2026
 20:19:46 +0000
Date: Fri, 16 Jan 2026 15:19:30 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH 16/28] maple_tree: Start using maple copy node for
 destination
Message-ID: <xeipv5m2xxjfyhoqifdigymobmo5lnh6kqqloowbg4oiejqyp4@ns5iehb3kzof>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	kernel test robot <lkp@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	oe-kbuild-all@lists.linux.dev, Linux Memory Management List <linux-mm@kvack.org>, 
	maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>
References: <20260115193647.1695937-17-Liam.Howlett@oracle.com>
 <202601161750.eDtUQiJr-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601161750.eDtUQiJr-lkp@intel.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0457.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: 14c91f92-962d-468a-98e6-08de553c97ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6nXO1RSBLGc2IrUWRFx7rcvd6Hyig5ABY7F4ndfu1hm07znThNt8dCLRwn8r?=
 =?us-ascii?Q?nhY4oJaGo0kn/JMtIhy2XdiufzofVLdmL+kvytnQtkKs3kNhwtrn0lYnV/qJ?=
 =?us-ascii?Q?2U7n/MdBaAgMoxd96lSZJKiI3bkViD496i9Ek6Gcr7jycajlxtTMGs3H9iLj?=
 =?us-ascii?Q?tI+i2TLHzBWv6rh6TzGz3lmnx5csJ7Yz45KfjnGxI0sYHX1ejk/X5QMGPi4w?=
 =?us-ascii?Q?q0guPMeDSbqvzmmpu3tBYigUWFJKTxuBS76vD0pF4SB0I6Aci/NL1rz9i/FW?=
 =?us-ascii?Q?ht2FQm4ui/POY3c9PoLyeG/6LxrOzYsV70LqxY7zkT1Z/p5FAMvZUHH+LpXe?=
 =?us-ascii?Q?fmAgg15I18oQkzNpdEYcnclDRnrXYRyxC4sI1/9YyEApoy6WgJEAM3lYwt4O?=
 =?us-ascii?Q?JPF/d8X4hyiq+aDqNLRJai9nIIsVnynmnOMNkvaNpBTP4CIPOojFkNaibxxy?=
 =?us-ascii?Q?HY7q7Utjzc4XZF8sgRbRGPmBcSeXqX6EmUx5+rZtG2PoZ6/WUk4KhvTsuLVg?=
 =?us-ascii?Q?FV5KrAa+TBHfO8HhVzMh0MaUeC5fJylbTEX5aXKWCuluqoQJTg2gGikOrmhN?=
 =?us-ascii?Q?HrI9NSesrcF+aM7nW25EHnvj8SYFQ2olOxQzK+TKLWKXHid8LQERQyyb6aq1?=
 =?us-ascii?Q?hATb7EjIwfDaqBShOkybD/hmVVbx/v34B/naXqlrAhAA8jmRnk8G4E3RHqaH?=
 =?us-ascii?Q?48/chbdUW7jJgRXr4Do9qm+6Qxi2P2Bm/3+QCGQuEeHAjUavj1iVxKiCnD5B?=
 =?us-ascii?Q?WanIDwUjRz3BqipFmAAlVhpTX6IL2IiIuwJwfNiMpOMJ6yQGBzW8CUZecPAd?=
 =?us-ascii?Q?YMXeIbQSpeL5GLo6DHkMLW9O2s0aVoLonBOsc8vdHasFtgL0vzy3yOaSMyIE?=
 =?us-ascii?Q?3oeeZdgnhHBgeJpQIMKOc+07lEk7mBwHvfXf+5D3FWVJ8pOkhQlawJuX5FCC?=
 =?us-ascii?Q?87bCU+kZOTDQzgklP4MQjCn7YEmZlaE2vHqYPtJ17kaACYCpbyu+JzatQpap?=
 =?us-ascii?Q?SiPHOX7RZvOblTz+ziGpRTD+qR5+6dON79v1qIrKVRrCCOwiKf1kWmm5vZH1?=
 =?us-ascii?Q?C1C+xAMK6ZRpqPOvCkI+Q8PMbLVdX2RHJTn29qEWeKOB3W9TC5Dc9R07Dx2K?=
 =?us-ascii?Q?/BY48ZoXDQHmC0+NjOSGk/wJWTwnTIeTYZzFJ7yGxfjh+Zx8VkyZT/a+EFXh?=
 =?us-ascii?Q?FATWi29d5oBRS2tzFaoI/ZuKp7frgf2nR7341h8NLtR039yh2zLjuS3YRGDp?=
 =?us-ascii?Q?L+Y0IVSXJDo+CNP45hTdbO886WoEHEvtix0bSju64V4n1ELNpT9JLgLjcMRY?=
 =?us-ascii?Q?o/4DLjh9VzU8bzWrkJHjbssIwOYaWPoAJnuN4IXiMxm+jEuPe4PyVNeJK3JC?=
 =?us-ascii?Q?SbzNgyXvBmfD6LNx8Fl5fTd7bZOLcxPPDH16xDPssY5w0JVwj0qmY6aM+6vz?=
 =?us-ascii?Q?eC/A68wwRazQhzUe4GEsjP8TCjl38cMH1w0zcG8q6nwdvspSJl8Awhxjsn/x?=
 =?us-ascii?Q?ZrRS2bj0Y3AYpY5hyh9w1yeML5gRICJVWGKFCe75e8g/Y+yeYBiiG0+bIvr4?=
 =?us-ascii?Q?rAvcP85OntOpzgAIaTZ0gSfDueN+0uje/7rlx0Rd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9VkbvIsaUWwTqK9HvT4E7Qw7jcs0DGW/5wFHRlWKStxfnDSPc4onEovQsqmy?=
 =?us-ascii?Q?NxlfQ8nPxhXaLdEizQ2O3Ymu/x4lCnbSlNrzeKO81hHfKtomxiDhGJZSMls+?=
 =?us-ascii?Q?5E51zzXvTB64oDbqdeknvS8hKFvBz/3FwRSB2pDWxvTalPYuweTrlzdTJa4M?=
 =?us-ascii?Q?vHvr6Yf85R++U7NpHD57H/zf/fVm7Kgex75H84y41RemCVmIWQDT0JaPqs2o?=
 =?us-ascii?Q?wsUqzacvuSMIhZ3agH6W4U6DZXBwly7NWz1/95MhPUiBRbVgTg9Le/o8nMDq?=
 =?us-ascii?Q?ZyrUU+801s0fGKb7/G+UUGPk/B2SjGM2HSSzWAmmgOz51bX/jSolOhNHSvYr?=
 =?us-ascii?Q?Wz70q1xugytu7S/hAAKParaxoaH5YMzcTZGiJKu6yTZxQPgRIt9AKu7ubI5V?=
 =?us-ascii?Q?O8aCmvbIL2jEZ4oBZH1N9iYUnSCytyRGFLtP0hOQLQ2UmwwZzjAdf8ihy76D?=
 =?us-ascii?Q?Jmi/I2Jl9cbpIz+JqpTcO66LenorerRkHWPL9km9hOJC1lEV37iHhNQVBzpS?=
 =?us-ascii?Q?GtlCdtpC7VqY2BxyG7OldO8r8zWdFIrz7SrgsILRHB2F/E13GLugbbEyRzGs?=
 =?us-ascii?Q?7RKQ9iTUF1oMMwGkXLxTkLZPt1m5nGIwa7VLJlvmauWWQzXPE1+/YOnV/2lF?=
 =?us-ascii?Q?WkOZdxBvpIdexs5J989/QQPKNWzWrCDJnDW3vPHrrAUXZh/qvljkuLNuXsWc?=
 =?us-ascii?Q?dvlr2mpP42v7zIiCEau7way09EVZOulDsVk69kx3IsVn4fQcWJEwHv6EbsuG?=
 =?us-ascii?Q?O3z2M/F28uqnZ9cBPGcuCYODu2vopGeEyFSzgCnkjRmhwT+hanzSV+wueyDq?=
 =?us-ascii?Q?45MHlXz+pnhVOEziRneG+jsOhJOektWIpRhXcAzjfyH17FHokpW57g9rrrH9?=
 =?us-ascii?Q?BA1qyQwZloeu4fVCztoFsWoPJfZQVB+G07jWoWbBgV/peRiwq6qPx13ZRDEx?=
 =?us-ascii?Q?9cjSfoq0t68BSJbf9IDQlxWvzfH51TrI1i4nw6HX1sYRASw6H9ZrsAZDKV1F?=
 =?us-ascii?Q?UjxGfJXiNYfqsNbrCsqR1uJpopxyNGcgox8pmFeXc5Sh2/CM9IPFVljMZYXK?=
 =?us-ascii?Q?zFIWudB/kxB982l7Er5XrJtHIjEhECKPKdxdI3qOUmRA7oc25WkOe0Abdry9?=
 =?us-ascii?Q?j5gJYS3ksy6i6jb/HYQDDLV9q/vGnU2Jak4R7EPFCPXJHYSzJm8AT9RvQSRH?=
 =?us-ascii?Q?zlV9U8kiNuRqB6GIDa1TxOPBFXABFqzx4BQ799IPP494dzNRettmC3e7EgFl?=
 =?us-ascii?Q?XezgwcwXiKvUDw07N7wj4UunTkX42AATxxKLsG8l/G2Yz8a3CH0cl1rfjzur?=
 =?us-ascii?Q?YLf08k5INA1pYl5u8IY2E++QIpWKnimq+WFUm8mgEoxMchzME6byYI8A0z03?=
 =?us-ascii?Q?7JgseNontlBv3l7FZqGLOrLWsERPRwSiQVYmsBlBY5QHG8BRIvbEn0iJUvZo?=
 =?us-ascii?Q?glAC9cS4Gx2GoipOWknVzthXSp2kd4QsRLiYPrhGdOrBIP5igbvdqJzDz6pI?=
 =?us-ascii?Q?3k8Dl+gLgkf8TvEHY1SmoBa21Zs6xi6U/5RV6ThPzMIeJImKM6FLgIZOLlbl?=
 =?us-ascii?Q?I+ZEluxwMLdREm3HJFbaL1U/jtWDY5xiFvyHocUFwhuxW4yaMMo1uk1R4ZsU?=
 =?us-ascii?Q?qi6bb6NEOza1MSEfPT4Liwma5Gnt5feD89GpuSMS5tNQ1ZjmT21K4RW2dEM9?=
 =?us-ascii?Q?lY3MwVB5Aj53O8FEZxQ4Xq3UXyt2KnCp6bhBWbJytMDtI2DD55170xE456J1?=
 =?us-ascii?Q?ZCfWFuxtgA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dvgmMTgPMNwq86FYP6zIuW0++TS2Ht1Zc2RtrpB1MRhXo0bSz0ZFWuvV/G4f31A43g6HS+9+btAgLxuQ+QkYJeCFpnCtXM9jpwZiXQ2zAJ9FA22ZXl8/+SuNHDwNmaBELA5IDfQpRs91H/La3cyZchc0G+qiD3Q6LrahdqwkkM5WnLMkjfcDR/EFoyd0hasynFn9qGgn2ob8gI7T/8C7vX5/gugGv4rhoW1QcnhFsVzoM9B3f81sAsNsxe6mchJ/9MLJKeh/10/V+Ya6nJPzAC0cnksQ+OJK9frKHb/Qc98ThSNKtLPuBVg8prXKbk07wKEh2+T3L+inVNl38jdqysVNkk1VBiDg5QMp/3a0SOSlACGOLYQ2sA9wyJtNeeNiW6WdTdiFfiCuP7Lamuqx836VE/uJTnxCsb+XGZSssTMluG3v104eqjNWvSg0Qv/VBQvKNqvBC/mDBpeclf7LCyAk9/vfv7Ok4AfiqnO1HDomuBMpjSnRXGq+tN+PK9WMIa9NWIYIvtkE6QcRXd4INBWRvQsw5jLuSa1h+yooNkhefduwsOKfJYLnDNAaZNJnBZq4srFWOUIegj01GFaoQNYDyLp5EdqLl3utqW2b5lo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c91f92-962d-468a-98e6-08de553c97ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 20:19:46.5731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lWbWf6YWGfrseHYITEDuqP+ztSbi/Ll1oPlUj6PGc0qvcf8qZ7ndDa7NccRGgG0lY2DMsrrzZcewOA5GISaG7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6269
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160152
X-Proofpoint-ORIG-GUID: R6IlZ1j7YZpFhWiYQy_zZ3cR40D6MRwS
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696a9d6a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=170n1hLx1v98HaIW2eoA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE1MSBTYWx0ZWRfX2whF1X+lqLwv
 AUFzjrnZcGxqeLo5AiU0oPtD3l1H45asyZRvOfnKWPEw54swjhWyyBs/oHyV1ZiOOYulcCAXskp
 ZQtENi8prbzxuF0YzYiCNP1FjlLowg/ubpNRz1qGrYh9GV7Q92ej4EKsspm4dz6PzQ2U2TGpcVM
 8+dnnOyPKty8wvQy2dTvRc22Y/k3Dizl03FSyISCiqa0bE5itp6YcixEDJUqDpDDJSrjG5v2guK
 BSDtqFvFPxhp8GJaFIzc/S7zn4cNCJBghIH9sfkIRtMfAbg6ipeoJbqLizav7b+1OD6IqDXoSOT
 St0aT+Yexoo4qVcrPr7OlnPzOHLfrI5zwsDfr7BjmKn4ALL4OLT8pgxDEc2jGk2aJP3cJjOQthg
 8IaR4fSZycENvHUIelT3ZqjOzQk4xRrseNw/UKLXgOsUnlmOLKdeqEm7HITRsxLyf4H8DGCaVu4
 nk3vymypbO/T0HPnL56Rb12kz+m8EPSwdUu25x6A=
X-Proofpoint-GUID: R6IlZ1j7YZpFhWiYQy_zZ3cR40D6MRwS
X-Stat-Signature: 8yfptdx5bc1rb11xh349ugnkydrbtnti
X-Rspamd-Queue-Id: A2C714000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768594809-703318
X-HE-Meta: U2FsdGVkX1+z3G8599Daaxo5hf9/YNmFWaWF+ly7y9tDtzaeps0obeBKECogxlpOkG3C3C/qe4uU59E0NMvxLjMLhZVzPEsG84Z8SjKU3qh9WwKNzAA5fM/ZHXTWuIxgrxObhBkGS/V7ea3El4J73RiEscnBRN3VB1N2J4p1bZz1dW/okI4QBdLPTYAbeWRVpk1+vNQV9ZxWO3FIrema+ARQ5XuKr7d6h/ryxkb3ln18GVBOdalwGTIBO18oykcqhCnv8KsGjLpgiyGnfs9KCOK6SBRQU3LMnnL8Z9tu4hgbMusOQyXgATVZfVko2Tnsj/tJHIUO6qxX7Df9i8MN89DsO6VZbeQo2WaD50ajxULLU4sols8vj2jHI06aC9doLAysMS3uh+wg0TehHaglQAL0Bpe9xiFBsLW0Alb9gc1SYWqk0mv3QPAaFrQEN6KBbxGUv0BSiY6eK1PFUbXEJSCkh9W9EXEUWE2MNR+cSuU/rGrJm4zOd7WZY18hVD4oniGsbCmX6jv/gttT9lL6GGV49LTzqQvy5Y2yuM3EDhADBX6kFweyy3EY3108gT2DSMNnocwIwAFsCPV31qT+MB+hpElM77IcvgxMT9Mnd3XXzH8XqJDZfttFa4TJnYb6vULDUhmafmnNKKLrO34eyoj6/S/IWa54fEt60PgmU7a49mizDADmzOprrWiTvZl5yIV8cE2EBqlXyEULiiGtEazaquVPaF856Kp3yknoCBdiltkHNBkXgkTfoNZNGVgYfL/3OKHwsHgXKbIw8Yr0CCH+0ITa/pQS5syzRdrzxUjm7uUt041d/85dyNr5rDCXRPu8GgfLqVVlttdIMg4pcWgsIUjkBuSau4WtxXe11gGLn7bCdtEjF4zpSvaW51AHt+CzqsiPRJGf1nthDy8GpH54xArNd5xSfGsYD0hNQYv5/DSCM6rZ/wKWJ0MgUR3Hd1bs3qWueVR31rNetCh
 7T2f0Amx
 L/DwQCiEzhK4k8eE/DkB4aDLr29ewaehUFdkUK4RMgKyz3/lV1Ug4oFkIphhwVzvtu4ce5Dkr2YkW+PXOlrmnWd8xNKvPSNiUqZjFg9sS95Ax+XImyrRmgMyd/7PWEQ6jrs0poIjeEc625vG1cvPFZUBTVCe3YDoN4yiuwUrRwCXtPaU1gVigKiSCp8CmWis36trZNxxHiuFkNIIJ0IiB0HSD0/nLnkUIfc7ghBXzw9NXW588MOJSSu0goZKHgU47PKK4OsJX65u6AxY6Td1qwnzjIpwEw9OsDbQiLUzlYnbH69+URfDyqLc8SUDaSsDy+aR/D+g78+VC8Z4qBjNP9NGcqPGfbdrg28gY1lkAyxS5yEXWICez+AN9YFW0T94O667F2nkH0L4qn3v+lWj9yTNCqFwYMNiGU2KvFEVOugZ7fAE21mYgqXC5ocpEPl5fjl1sHdE5L8LrdyRf5SwPZQj2Oikcv2Xb+GMeHpS93R3S1KclFtLXahY0msoRkFIWPu1E57o5J19xfy8Qm/mBZN/QBejAlDWBk/nfHAzrBHHDhGV/IF5t+pePS3G+j5mo9/T922nCMz5mWm20bwVgNlu/axrRtqLa+z867gOQ4H3aRpUMHBrkIy2WSO7eMR0q7kSlq2CzqV5yw2LkjIqpUnmmnnl4gyxxuC391UJ7ooEgsckwEvtYCZZiLyK5ChcCbNuaUouIAZojvdLjiZ0qJtQsrlM2K6K1usyeWQH6uXNtQ636QVCNq0E/XmVeZiB3/ke6HDL4/ukngejh0nb4tWkXC1lMXOOkwfPQTVLjUe6YafwwFznccuL02z5XmxRZX1Wku79ddwogBf1EfUrik0duTvSEpkVxDKPH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* kernel test robot <lkp@intel.com> [260116 04:37]:
> Hi Liam,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on next-20260115]
> [cannot apply to akpm-mm/mm-nonmm-unstable soc/for-next linus/master v6.19-rc5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/maple_tree-Move-mas_spanning_rebalance-loop-to-function/20260116-034135
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260115193647.1695937-17-Liam.Howlett%40oracle.com
> patch subject: [PATCH 16/28] maple_tree: Start using maple copy node for destination
> config: x86_64-randconfig-121-20260116 (https://download.01.org/0day-ci/archive/20260116/202601161750.eDtUQiJr-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161750.eDtUQiJr-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601161750.eDtUQiJr-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> lib/maple_tree.c:3355:37: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got struct maple_enode * @@
>    lib/maple_tree.c:3355:37: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:3355:37: sparse:     got struct maple_enode *
> >> lib/maple_tree.c:3358:17: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct maple_enode const *entry @@     got void [noderef] __rcu * @@
>    lib/maple_tree.c:3358:17: sparse:     expected struct maple_enode const *entry
>    lib/maple_tree.c:3358:17: sparse:     got void [noderef] __rcu *
> >> lib/maple_tree.c:3397:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct maple_enode *node @@     got void [noderef] __rcu * @@
>    lib/maple_tree.c:3397:19: sparse:     expected struct maple_enode *node
>    lib/maple_tree.c:3397:19: sparse:     got void [noderef] __rcu *
>    lib/maple_tree.c:3139:29: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got struct maple_enode * @@
>    lib/maple_tree.c:3139:29: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:3139:29: sparse:     got struct maple_enode *
> >> lib/maple_tree.c:2558:52: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct maple_enode *enode @@     got void [noderef] __rcu * @@
>    lib/maple_tree.c:2558:52: sparse:     expected struct maple_enode *enode
>    lib/maple_tree.c:2558:52: sparse:     got void [noderef] __rcu *
>    lib/maple_tree.c:2803:29: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got void *content @@
>    lib/maple_tree.c:2803:29: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:2803:29: sparse:     got void *content
>    lib/maple_tree.c:2806:23: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got void *entry @@
>    lib/maple_tree.c:2806:23: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:2806:23: sparse:     got void *entry
> >> lib/maple_tree.c:2558:52: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct maple_enode *enode @@     got void [noderef] __rcu * @@
>    lib/maple_tree.c:2558:52: sparse:     expected struct maple_enode *enode
>    lib/maple_tree.c:2558:52: sparse:     got void [noderef] __rcu *
>    lib/maple_tree.c:6899:30: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got struct maple_node * @@
>    lib/maple_tree.c:6899:30: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:6899:30: sparse:     got struct maple_node *
>    lib/maple_tree.c:6899:30: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got struct maple_node * @@
>    lib/maple_tree.c:6899:30: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:6899:30: sparse:     got struct maple_node *
> 
...

Andrew,

Fixing these in patch 16 means that future patches will need fixing.

I can either send you patches to fix up this and subsequent patches.  It
might be better for me to respin the series?

Let me know what you think I should do here.

I'll also include a final patch to correct any other sparse warnings.

Thanks,
Liam

