Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0B8CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 14:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98FE58E0006; Wed, 20 Aug 2025 10:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9474C8E0003; Wed, 20 Aug 2025 10:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA408E0006; Wed, 20 Aug 2025 10:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 625438E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:22:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BB8280E6E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:22:54 +0000 (UTC)
X-FDA: 83797352268.14.F782C69
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8D7EE20005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:22:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XaBR6ICI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ov1STpVR;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755699770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AE1BMp2xV2Fvl7Mjq1+xUKr28npkzzI3R64kquTCoW0=;
	b=GG2MYLC8t7T+WsqtXCX+eaEIh+shvAgoURIPxHzkediivufAcrKyjB34PzfaCycMWT8sTe
	c2m8JwQgzo4g4U74qGKABhrk4qfLoCMO2JGBBSkhmhAc30dtSLkpvBLG7wBgjV1VDFS7Vf
	PQncPR2hyVMIlTH4XcsflPgIvZhh7Oo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XaBR6ICI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ov1STpVR;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755699770; a=rsa-sha256;
	cv=pass;
	b=Z3cobAmO+eWet4lAiqu2aKwDjY8OnzMAEOanQrXbg5d79HUPOcEsrr4Ngw83f9jSNwUHUt
	OX52k2mQxekZAPzElAUBi8Nd3ZndR5yNEGQv1MyAxomtRd1BQEg70IwD3a2rGmu9Op/T0f
	R3a3L9X83VIyPlqsVH+dv8FE9IcEpe4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57KE7J7q011145;
	Wed, 20 Aug 2025 14:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AE1BMp2xV2Fvl7Mjq1
	+xUKr28npkzzI3R64kquTCoW0=; b=XaBR6ICI0yoKzw3GgT1AxJxUWIvk8lCnbu
	No79lAkNKFNcU+aW8Z+9rYj4YMOT0ocPsUBZ9P3cQ8otI8RvVN3s2mMY1hS2WlCo
	UE3Kxx2XCXyot4smjQdq6XRnya8V4aBeUxR94b2NJcX6rPvM4NI250MfBWFfwsBl
	TRLXUXfVD1thwf47Ic+HMoLZPPs6JlHamAXOBFQTkVt0OuhyRQw1GN0NMUkct8/e
	pL5aFGQkZ0Brptu+OtzYMli2IkqbpMOrh2lB68NASMak0C2Hty6OmCzjOaJOeo4o
	UQS46LFnQzsltVGEmBxGK8QeK3QyCXzSKBSAyjki8uH3SoZLzK8A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0w29ddp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 14:22:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57KDHJVU026405;
	Wed, 20 Aug 2025 14:22:23 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3sw9saa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 14:22:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aHdpNg7XIEPURP21RFcsgIbsO1nfRlOZ4DTT1u915DnSaV8HcbiH3FvwpCXu5hfM4gddGqJTVbmqsunlseGk8KkULtsL409QXmdipAUnBfdx4RzlZYp2Fuyi5tNmUkx8jmcMb/S5gP/E5GgrEvDRib3r15CkTys+CPK5uKdVixGIq4jWCfD2335QoP92c8eIUejeOO6IshsF3zIXYt0YOIwMwSyuwvwBpBoXSIsc3RtuesMTJS17aEoLj4F37Mr4deC4y2DRFv5/ARXbhcYcKsrajkDC9bYyEd64QKZp95wwNvpjXalhPysC3lvAI8MO9U0UtgTAMC+fs91VcHAacg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AE1BMp2xV2Fvl7Mjq1+xUKr28npkzzI3R64kquTCoW0=;
 b=S+2biVFJm59mcqZz64lR9vumaTvmI6ncyjdjjIkJoX9ybH8U4Ga2ZPmNP0JR3zWol94QeA+lggw50E+8jXw/HJSD6vqfVGcC+NXHNxrngFATWXhNxy+XTdqE4GKv7gj9kG31vsT83XIEvSpf+5DufWQ2lX0xVOh1q1XAY92ZoL45jO6+3PR+uLuGKuHKIC1RnLA9uUd/rTKE9UD6QPRYVwgtY/AKWVVqGQsCT+nY/2eOU6ZNFc6dPXqUbxHqZUWDwp35UB3tPE1SULFMZpumFqoBiI9vCGMZsqrYi2xOxt105X9SOwBXsVJVDrJQcrLvn/y/5M8t5AV2r99amCE92w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AE1BMp2xV2Fvl7Mjq1+xUKr28npkzzI3R64kquTCoW0=;
 b=Ov1STpVRn0J87Qem1QlSHDjuZPSV59swhv0nGkgujqQBLB/z9Wj5jnATR4GsYy4vHpC94xofYqoI85bTqad7ZBCBsbVQkf77gTCe5F9fny9SEv2hkaqc1Au2tNfu9ZeDBdDcqmW/OcG61qh+6vMkZP/RnEu2pbWfaw5OlfxHvzs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN6PR10MB8144.namprd10.prod.outlook.com (2603:10b6:208:4fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 14:22:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 14:22:20 +0000
Date: Wed, 20 Aug 2025 15:22:18 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 05/13] khugepaged: generalize __collapse_huge_page_*
 for mTHP support
Message-ID: <2ddd1403-1bda-4875-91fb-7060804a50c6@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-6-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-6-npache@redhat.com>
X-ClientProxiedBy: LO4P265CA0215.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN6PR10MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 7521c8e4-058a-4261-215f-08dddff4f959
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XzF9rMtq/P4OBCWCevkeV8wnELUZ4JQxHXAplO3kUK2HG4l9D2hcVCVweH+/?=
 =?us-ascii?Q?Div4371Kmam0ffMo0JNt0NXTv6C8Lzd1uepE20AE40qpK+hnJISBpFBaO5kN?=
 =?us-ascii?Q?K2OD9loYzSx7Q/V4CZvlHnU1B7vfmF5/bemIsYgPIWQGBRTxJdaXH1JGsHPp?=
 =?us-ascii?Q?LsMFFa+hH9Ch1Ku4ovWAURZiCABsS9WQdmUgRtilm+pb1J7hgMzfkUzxn1B4?=
 =?us-ascii?Q?vzW17d4i+xiaONg/Un8E9Wr+bahyr2wWVRtEL/v6msmRq8LeyZKwSJWlv1bC?=
 =?us-ascii?Q?LIMBZfMuY7JbqxnTmS/pxkKD4nZY04uJT4l+28sveRTw+MYLH4/r5UmIOKuD?=
 =?us-ascii?Q?hw0QwGmfyKOvmRnsfQZ4kOsoLuGwxYdDJJ0bohI65O/ckmjS+TxaN/6viAe1?=
 =?us-ascii?Q?FuzOj7lrOIbrsQjGrvuR5Srk+pUa1dQs2ibJPBCIPLehVHwkXsDPcIDvIcJc?=
 =?us-ascii?Q?vJ67ajJyR1EJJs+uXnuuqc+wNltsnjyS09coer2tb0IHm5O00OQz/EVIOxCN?=
 =?us-ascii?Q?38Og1W3KVcaItne3wLCL96rL+1rrRBtkagdc4UoB3UqM7RBiUNp1Bl1XgtiE?=
 =?us-ascii?Q?qIelQ/jjJDTj2bCyJGitAET66rW0tG7MsD39Uycjg6vBxYcV5nhvvEa2mA61?=
 =?us-ascii?Q?Lt+NrdoyEm1sE+x8e2bQHBAQohCYVNg5EW4KFMfpmccN3vQ+7UJo8pJ65eXC?=
 =?us-ascii?Q?IgkwhXVFgUO7XpZChvF8XAsfnc8CvYCvRBrAx9t+nJWmCUjNV8xDOwWSfDo4?=
 =?us-ascii?Q?MZ1Y9BpaZ8rI62OCUMNP6cUFdf9lWd5Ei92RX79bsqGulUFjyHqCvDbzfsy6?=
 =?us-ascii?Q?6r0cXd+bJgUNZVsgulgkIR9BfSgaBIMpODI2imeqRKgUiaOVx50p/rN5WLAI?=
 =?us-ascii?Q?8otuOut5FmXYIhFJ+Nt43gT7hzWzMMATdq9OgE7vSUX9Ef/pwLSLujlfZBLj?=
 =?us-ascii?Q?Mpj4LaFHHz3AB1ez7GCaAdxf0wW0wBF2BQRdCwMBtBZQbo+N2u8VV1cD0INd?=
 =?us-ascii?Q?PYPGv6BViKj4ZGTh9/aZWmjadGk4JipnNBqyoVrENy6Z9X2B8vhTK9SfLyIY?=
 =?us-ascii?Q?VFbtUOxy222ChXhqUkJbKHk+1tRrcm7/D0gLO0+LlA7gyTB3dNy70yqbto9i?=
 =?us-ascii?Q?4tOuP2NLvOsDGeEWyoNKfKr6A6lD0SMcnHMZcAA5XMRQj4JAonCEi1WoorHm?=
 =?us-ascii?Q?pOpNPS+kQEGSiU7Mz6479lmqW8CnEokFHjCG0dFl/899JjD4KaXRFcODhvoi?=
 =?us-ascii?Q?voZ7a+Mdw04WekbM/Kpd2wRENZwC49N7aGvZUsAKhj2fG9vzRpShCI/NnRuZ?=
 =?us-ascii?Q?UIuk+LrYGJcYdQrfe9gaML+tB6EkxEJfHzYazh6JZOPfWEKj1D0rRqO6hElX?=
 =?us-ascii?Q?ycn+3r2EzhWqftzc+B+o28Y2eKvCsKU8Mw9PzKKxHH1Y0T3dDW7+R8uXbpMg?=
 =?us-ascii?Q?qAg+nhnawZ8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NVDpO3hCdn0+8qmR+r9aCvi8A5jf9UhwXBa3WAiYeDzpgy95m4CBKZ1G1xCf?=
 =?us-ascii?Q?HditeEVeSaUDdFDZ46IzhdG6bjP6ukWLpyUb44McxVAFH/o9VZ8IlqfcuVYH?=
 =?us-ascii?Q?OAx8gJEmG/7iVgUC7eHxgeHqaVgGJlwwm+FKh95ybjc0nRd1MfP2sRsdDnDd?=
 =?us-ascii?Q?yMVmgxOEq7Qp8PsUnxzerCCaGh/F6RuVRV8jj+4VDg/8ev2GTAly3omlozH1?=
 =?us-ascii?Q?mxBRylZNaxXxz5S+S5go8Q7BQUMqRLncVZAt+B6wfE5/DVL5U/O32/8JViyr?=
 =?us-ascii?Q?o2X3u2ZPUxZ3vaGLvfRLlPft0kAdMEvKfbp7I38j/ichLHSjIkgC/HGp2Qf7?=
 =?us-ascii?Q?cg9ENi6gZL0cVb8NrLmZ+bewYjhxjHQCVV3AVrzd1ZQ1ALhq3CAdmlvkCc3C?=
 =?us-ascii?Q?cTtXR+kad4VsQNCsGw8lLM7pOUCVhCQIrQk0CL2o1LJ+St2kw0U3/meFPrbQ?=
 =?us-ascii?Q?wgoCWLLx7EJ2mkehvpFcuo6gSWiS9Eu5yG1dWbaNpVrimc2lTvWDXWA5D5NB?=
 =?us-ascii?Q?0WiM5qpUkcFoVnuSFnO5yJZ3m4Fk4PgOW2TgxdaYhWGYWfCSrFSC1BV4CFnJ?=
 =?us-ascii?Q?HCPMFYlwsdxEamISLHGR42ZAqYXWa7FyFU5JMGIjclKJjeUCeodnirZKY5zA?=
 =?us-ascii?Q?cMdpTqVfPyb+KcTD66J0i6/u5ia/a+2HyxuD3amrze05+bEx2gjYhlrToJoY?=
 =?us-ascii?Q?UqhU7tME8cTGZtJqxWr8/uKGp7ucAtXGkiVxAls4XsToa3JSScBY00t+EpJj?=
 =?us-ascii?Q?lDHdAL+USHgrRwEyrqLpCINxiSZ/Rw7+qEb56+vz31REPfApDnE3TNgjGCVT?=
 =?us-ascii?Q?EOjYg3v6leoGTN2DDt8AwS07MUhpNRLvwbiJAHRtk2MNlvJ4arGdsyp2cT5q?=
 =?us-ascii?Q?gQKiB3iE9E5qdlruNS6zAsjCcluJhTVWZK+kK/EPitmp/aCW3lr9WEGXhdND?=
 =?us-ascii?Q?5WCbjYOUmoxbhXhCI5NfwtGSH/laWQ1fStwqmx7+yPruuw9PxueM6jbaP8sB?=
 =?us-ascii?Q?ztmdf9vjSsVdOL0Sy0GqayT/HJ8fLAfIyWBDyWw86MyV8Tn/VAuJMLEfj7j8?=
 =?us-ascii?Q?vXcBkvBNcQ+q7igOObZzHudXKahqPCmwgQy+WmwEnOsJfIK2uC8li3B0NYW5?=
 =?us-ascii?Q?8sN9qC8BYuylj/NRKNH13l5Z4jMayebmcKCRQsS9lhJ8e1xsvhwfidZ8NE74?=
 =?us-ascii?Q?yTfl8J2PMW0HMZjtEbTjrJz2FNJjqwVJwi3z/VVR97tk+7ktmmyu46hGTiCG?=
 =?us-ascii?Q?TLYAibD5qaw9bNYdyjkjSHIaXaHJVhL0jStJy5SMVnWGHijh1otfZgzgnY+e?=
 =?us-ascii?Q?sHSHrS7uI2WX3GKgMq+dbhujZXZ0yoKwfRYZGT05O/03Io2o3f+JEhkQt8N7?=
 =?us-ascii?Q?08eiizn+7f9RYNkpLZqkNUuDmteGF1yMmGMUWGF37DN//egS/Vn/vOzGl3aI?=
 =?us-ascii?Q?8iKPonJfvIU+6A8HxulwtE4fLzCaw34BoULTntfeMpKs4L8z7ahmcVmlZXxB?=
 =?us-ascii?Q?uC863JKzoCQRNVttV6oRcTNYJ3RcB4cBgncsZ6akoFQDlZt6ujFvUOrUHr6f?=
 =?us-ascii?Q?301Rr42agfzexF/OYYnqfllFwbk2+0gtVTejJ5ak2K/8luYrzwSMB8fkNZXW?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pVtjIq1b0HhGAJ1zmvacflUHmc+ODw/mHiHHNsLiiS6nsX9EXzP9svO2XFCXx0F+QUKBzbWLUfGPfbAZ1qh0CqnG3it0GMyfYkTMs+TsTcGH4T+dGNicHbDIH7eceqA/lLi7Q6/dWY6Ho9aAysGUv7x7TVLN+IgR81ROlBXvXSZUD8Bh00AEjr+0mDDnTL9+Uyjepr9quXN/tjmGQzTUdmlJNZ5A2GTjvt7FZqto+pLcYUrrVPnq7y5M7EDd9iz8drNPWDW6jI858jLghAf+dDfsSxUCi6IsIIBHQyAb8gVhyEIHCIh+seEUGZ+vJh/8fB4mH642shanOr591LWXoPQe+aDOLQnT+vPzaxnEcKoDo0XPmbxX6wFnezTck+n6r4fDH0MCk0Ukn6WnWdRmj9yVjGaY+9b3/hQnV/YmRx5R+Fb+Cv+MIxQzpUZWwCHxeiPzt+/tjvqF1IeYKq8zDeYdb75UB4DJjcjlEXHw6STtQjtTeTB4pdHy5Swif0SvzpZq9b6RAtV5ZVERF3rjNrJxfYqieQf97UW9uNzl7k60hHqmpdJIqIiD3fa554Hn/6BZ+bkplropTHuiyJEX68H9JlY2DCEkI3Np04xbR6s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7521c8e4-058a-4261-215f-08dddff4f959
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 14:22:20.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gt/MUgwKbuj24H3t8U9aCB2oape1V9nQkWVbm/vVlrCnPiCIKZ9QtV1Rx3XcV1/4HO8a8/usvPGcF5LN2QkgOLeSiHCg1v7R7cNQkzdW0b8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8144
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_04,2025-08-20_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508200127
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXy6HZIAPTRyTh
 V7v0xb7pIWuQME0KAGIRmZQ/KZYY8ZDw7LPGuDyU4D4Qzr/9R5GljF//Oyyl02KAIUUuwZ1QAIK
 snYxKu38kfuLnlIFYTj4b51aqvmLzjgcgfib2zBWJs16vDnTFlQEjDuI6I68arwxrhR4PSzTunS
 WzBDmufTRvBWZVpGgzOe/eE0cZMIiFxsJapgbZRLXgc0ofFJQCyBJFUUD4LxCf7hREh9W/Ev1aa
 GoitrOd/YLXIXKXkTuagFJRENq8Sc7/sbrx5rJt73H4QP2DiNQ3nCxqK3hL0dc3CVswSqYD9lda
 dk3CLLZGT8bZids5E/xtd3z0VrsRRNIOcudvQ8GprjLDuHqRVu2QLOvsBB2Z41bxBaB+4gd65fW
 GBsS+A0N9SILLB1Dqcthq7ECD91Sgw==
X-Proofpoint-ORIG-GUID: NG3Qmke8XUIz4sMLok4UodyUjmk5xnO8
X-Proofpoint-GUID: NG3Qmke8XUIz4sMLok4UodyUjmk5xnO8
X-Authority-Analysis: v=2.4 cv=GoIbOk1C c=1 sm=1 tr=0 ts=68a5da21 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8
 a=7CQSdrXTAAAA:8 a=L7AKS219auqWtKgpIgEA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Queue-Id: 8D7EE20005
X-Rspam-User: 
X-Stat-Signature: q53bifpomkh4gftuofxf5tsde1gzz637
X-Rspamd-Server: rspam09
X-HE-Tag: 1755699770-413830
X-HE-Meta: U2FsdGVkX1++Cl9vGNk9WxWGhVvHLcj2l7giw/afa3ZCC9y1lAj5QUSrfzCg6FCa9KZoGBg17XFlWxlE8HCv0pPcbXktGinJfZl1IOmqrDFaZ7lA3UFPnPJyaXSTNX//MXaNqStRVZBJH0dmo4EBkzEbu/eGWe4lwcpMBOsTw+J5cLZ07xxhJKukSZanNcXSGqYNErObLrTUM68I3ju44JdCTlMLeA5l5oc8jKhu6PyEiWODwTw9q1trB9fVNAXnuLzqEfebfoRCRYM74fPBShIWqIbcWXCGtn7ooEiNee8BqRmVawAMTPIunAT+4t6UWSzlaePh6Mgz5Vj+qYzh2dl+lo09oSwLW2nJFGtJm0U0oHv1EF3PL98EtPeQew1pEZETkuEzbso9/gwYyIQ7iOt5j0pX3mDuLInQCcA98FC9cMKiXheQqG23ghVPnRYlSp08laL8G9SjL7+hMWb+8j587txiI991RSQ6DsClxCZezaYDArbO29VCByjy7GOKIAUdyPMe4ThOzUqrcvNj/kC283T095VQyKmKHgElDB/1Pxh8aT2BqWPRwkcKQ1w2+WUBkYMn5ueo8rG/B7L6zw42PlCGKNJBxOi37zMKNu1sGHp79gmBMq9IgoTk3tDdVgvjKdQxOKqVKaL6rXUcFcrZ9lAaRzg+wKHs8jd/2ZZ0Ud3bNb7tuFABEVXPg7RUx8JF0JT5gBxgBDgvuugIeNUrsOFh3XJrnW+x+RWMsb091LAgCykXZuIWsEA8yYm56RovgOol9+WXbsDD5IsoxVQGjUqCo7YsIXswOCFYA5qoBB1jynoec8MOqAaqjKrmhQ8SFUOKOtt6Et+SLgkTCeK1whLPcL+BoNtuqdla4SUf2KsDvj3L5Cyi5wuo8PKI1iMGeqohZNhnEo9DlsWKOYqrqn3QQCo7/043n8G8ajhZEOAqheHZmCFVUAdw7N8/U0/W4WCnNxW350lPg3Q
 VMIkaUua
 Mfa96zJbmchjWe4NVBofSPBfhuBA5IuzdTad/R/FrHdkrg4f8Vbte/sgKbhtTKP7nIkGFE9kB0yThsdcftSXTW+rnRAGiZIJy4Aa/K2ACIXYIugrM8n6eiEV9skxFjtO4JVi9AFJT+TPEhNVTmIp6ZJn9Xo5T/mx4buIT7/ucI+cmjE7eF3jkT8VKpT6t95/wb8DG2P8OaKuWXQZVbw82Qqcnvm0uiOrn7IF1ygLY3awr6nz3dwg4IG5922tu4nv8gotyWZqcuHjoyvYflcdgzdOw8C1yoNqte8AE4NZ40gtzEQfkmHxneCyHgvUhZvBDchOiLbURyAG0x2+Zx7eJNzoPh90QNMK2H3y9UZOAcVhHHNHDNvJDjpSzXuFljyyNfaU5z8V7LI6N/laLzAmjQyTedXbYM0W2nlrtd7C+mN9jThySUtwvEGbiD5cCJyrHN1OqDt/HCFgfz6FOyyfCol+aM7/z56s/WePTeXBQ5S53N+R7L+w+ckVIPa3v3p2QrygcfI1QGehcUYdtVpvJcGniP35/oVZCebOcey/tksARKQj0T886cUZ0/c8WkIgWgxIJePaOFthIlCcs+UiZjRXCf6BVOVSPd7DXNasD3Aes7qDZnGOqpu1nP6SzRgrGxZJRRebHVpdybQ50XTheEdsiLWbws8XeS4CaDJkEGcwcaq3tBs2d+e5fDNPNFaE8hqkSlRIUiof/D1UPnefiWzQHPRzGW66u79teIiWtnA4TeBz0I8kBgGWDhhR9uC8KjBGVrTxKlWI0K4P0H7nMk6RhhhV0mJxvH6nvV1v7DBqOFQ9wCD6S/KkhJ3PjCxAwezsrvlgkJJ8obsYf8KjXpb4MPAYUAKs2wgVpwUkYorjWhlqopOg5a0TBQBblc8+vrywpMvtadQ0j3UZcWO8j0GH1PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:41:57AM -0600, Nico Pache wrote:
> generalize the order of the __collapse_huge_page_* functions
> to support future mTHP collapse.
>
> mTHP collapse can suffer from incosistant behavior, and memory waste
> "creep". disable swapin and shared support for mTHP collapse.
>
> No functional changes in this patch.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 62 ++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 43 insertions(+), 19 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 77e0d8ee59a0..074101d03c9d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -551,15 +551,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  					unsigned long address,
>  					pte_t *pte,
>  					struct collapse_control *cc,
> -					struct list_head *compound_pagelist)
> +					struct list_head *compound_pagelist,
> +					unsigned int order)

I think it's better if we keep the output var as the last in the order. It's a
bit weird to have the order specified here.

>  {
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>  	bool writable = false;
> +	int scaled_max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);

This is a weird formulation, I guess we have to go with it to keep things
consistent-ish, but it's like we have a value for this that is reliant on the
order always being PMD and then sort of awkwardly adjusting for MTHP.

I guess we're stuck with it though since we have:

/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none

I guess a more sane version of this would be a ratio or something...

Anyway probably out of scope here.

>
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> +	for (_pte = pte; _pte < pte + (1 << order);

Hmm is this correct? I think shifting an int is probably a bad idea even if we
can get away with it for even PUD order atm (though... 64KB ARM hm), wouldn't
_BITUL(order) be better?

Might also be worth putting into a separate local var.

>  	     _pte++, address += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
>  		if (pte_none(pteval) || (pte_present(pteval) &&
> @@ -567,7 +569,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
>  			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> +			     none_or_zero <= scaled_max_ptes_none)) {
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> @@ -595,8 +597,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
>  			++shared;
> -			if (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared) {
> +			/*
> +			 * TODO: Support shared pages without leading to further
> +			 * mTHP collapses. Currently bringing in new pages via
> +			 * shared may cause a future higher order collapse on a
> +			 * rescan of the same range.
> +			 */

Can we document this if not already in a subsequent commit? :) Thanks

> +			if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
> +			    shared > khugepaged_max_ptes_shared)) {
>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>  				goto out;
> @@ -697,15 +705,16 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  						struct vm_area_struct *vma,
>  						unsigned long address,
>  						spinlock_t *ptl,
> -						struct list_head *compound_pagelist)
> +						struct list_head *compound_pagelist,
> +						unsigned int order)
>  {
> -	unsigned long end = address + HPAGE_PMD_SIZE;
> +	unsigned long end = address + (PAGE_SIZE << order);
>  	struct folio *src, *tmp;
>  	pte_t pteval;
>  	pte_t *_pte;
>  	unsigned int nr_ptes;
>
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	for (_pte = pte; _pte < pte + (1 << order); _pte += nr_ptes,

Same comment as above re: 1 << order.

>  	     address += nr_ptes * PAGE_SIZE) {
>  		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
> @@ -761,7 +770,8 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>  					     pmd_t *pmd,
>  					     pmd_t orig_pmd,
>  					     struct vm_area_struct *vma,
> -					     struct list_head *compound_pagelist)
> +					     struct list_head *compound_pagelist,
> +					     unsigned int order)

Same comment as above re: parameter ordering.

>  {
>  	spinlock_t *pmd_ptl;
>
> @@ -778,7 +788,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>  	 * Release both raw and compound pages isolated
>  	 * in __collapse_huge_page_isolate.
>  	 */
> -	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
> +	release_pte_pages(pte, pte + (1 << order), compound_pagelist);
>  }
>
>  /*
> @@ -799,7 +809,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>  static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
>  		unsigned long address, spinlock_t *ptl,
> -		struct list_head *compound_pagelist)
> +		struct list_head *compound_pagelist, unsigned int order)

Same comment as before re: parameter ordering

>  {
>  	unsigned int i;
>  	int result = SCAN_SUCCEED;
> @@ -807,7 +817,7 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  	/*
>  	 * Copying pages' contents is subject to memory poison at any iteration.
>  	 */
> -	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +	for (i = 0; i < (1 << order); i++) {

Same comment as before about 1 << order

>  		pte_t pteval = ptep_get(pte + i);
>  		struct page *page = folio_page(folio, i);
>  		unsigned long src_addr = address + i * PAGE_SIZE;
> @@ -826,10 +836,10 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>
>  	if (likely(result == SCAN_SUCCEED))
>  		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
> -						    compound_pagelist);
> +						    compound_pagelist, order);
>  	else
>  		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
> -						 compound_pagelist);
> +						 compound_pagelist, order);
>
>  	return result;
>  }
> @@ -1005,11 +1015,11 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>  static int __collapse_huge_page_swapin(struct mm_struct *mm,
>  				       struct vm_area_struct *vma,
>  				       unsigned long haddr, pmd_t *pmd,
> -				       int referenced)
> +				       int referenced, unsigned int order)
>  {
>  	int swapped_in = 0;
>  	vm_fault_t ret = 0;
> -	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
> +	unsigned long address, end = haddr + (PAGE_SIZE << order);
>  	int result;
>  	pte_t *pte = NULL;
>  	spinlock_t *ptl;
> @@ -1040,6 +1050,19 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>  		if (!is_swap_pte(vmf.orig_pte))
>  			continue;
>
> +		/*
> +		 * TODO: Support swapin without leading to further mTHP
> +		 * collapses. Currently bringing in new pages via swapin may
> +		 * cause a future higher order collapse on a rescan of the same
> +		 * range.
> +		 */
> +		if (order != HPAGE_PMD_ORDER) {
> +			pte_unmap(pte);
> +			mmap_read_unlock(mm);
> +			result = SCAN_EXCEED_SWAP_PTE;
> +			goto out;
> +		}
> +
>  		vmf.pte = pte;
>  		vmf.ptl = ptl;
>  		ret = do_swap_page(&vmf);
> @@ -1160,7 +1183,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
>  		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced);
> +						     referenced, HPAGE_PMD_ORDER);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
> @@ -1208,7 +1231,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>  	if (pte) {
>  		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> -						      &compound_pagelist);
> +						      &compound_pagelist,
> +						      HPAGE_PMD_ORDER);
>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_PMD_NULL;
> @@ -1238,7 +1262,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>  					   vma, address, pte_ptl,
> -					   &compound_pagelist);
> +					   &compound_pagelist, HPAGE_PMD_ORDER);
>  	pte_unmap(pte);
>  	if (unlikely(result != SCAN_SUCCEED))
>  		goto out_up_write;
> --
> 2.50.1
>

