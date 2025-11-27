Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29014D10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F57B6B002E; Thu, 27 Nov 2025 00:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A53D6B0030; Thu, 27 Nov 2025 00:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C266B002F; Thu, 27 Nov 2025 00:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD4F6B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:12:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1109814092B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:12:18 +0000 (UTC)
X-FDA: 84155215956.26.640888D
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4A27D180006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:12:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gCpcs6V6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.62.19 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764220335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3NJdCh71+BpYQszap5teUwi3VCrIHuh0lBu6VWAAsY=;
	b=J5RF6X2bSfwri4hdOZLeyWJmpzjGCGiP2iczYWdbP6+xgqXwF3Q0S8pdaWHzPtEJaeIbgN
	KTuJpEoiZUX7kGoF9MGn+q5pYUhUb7Y/OqBaspPyXttXpgYWegFGJGrWcwdtdEeNUXnJVv
	MBgYuMLfAw+rrqvutoJm9Cuq8YKQU+Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764220335; a=rsa-sha256;
	cv=pass;
	b=0IWXrmNfGkfKWwQJLYRLSUmeiXJNXb5i5BxIgDvIb58m0i6fvcEZ9PMYfnobH2SwoCiEHT
	zv6dECTUE4RBw8eO11gWIbgO6qja8WyE1WPa9Fb/gNWyjSzNSR4EwcyhtQrkr8PvPttZaJ
	hdX5PuNQ1vKLRjqLTbm2yCecKQZEuSg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gCpcs6V6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.62.19 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QPuh4tr6Wh3/padRYzdWqk9dbkIkP+BGJUyaASgOYIfNyBsRlbthQR1/JctZ1V1QFEli2WvDCdH4XHP/iv8TbO0sU5qRXmon4APJ1lKkDc1JzOrM48XdPB9deU9Jw82ANkbcK8dKN9rV5MC5qfJDRiFnMEz4JyMMCgMLq352Kbhyl5njD8FYDCou7b0Ziy7zkdSDFW2g/BT8b2cJ2xuFCdI9a0XF3xUvp+r659RIGD/VLnhirG/M+GpX9Jr5I1npPS0scEBtNoVmWxc14h/ugm7vZex8Ib+4dvqk/1hgdu5+pYGvAxOVsqOgU8ZGmEXoh2O5EcZgBX5lsSnsceTOxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3NJdCh71+BpYQszap5teUwi3VCrIHuh0lBu6VWAAsY=;
 b=Pr5o1rJpfOzJ9aafluQQO1XoaghxpmOhpp55fuuhwYGNhQffKeusU5sZQ6pfQzH5SQRKDrF18aI1PY6+T/wplXNEyKpegWN2nfBnyAP/StadPavUEOZNm3ERqli/3L9Ln/0mQNJnt4rDJihbvJQ/D/xAy/uKL41rQscBzS7qIX05RfRSrXTjRXvkYM5sdsxjBt3PWMhIKDBIgnKvgaNv2Mpi7s5jAOQvsiB47qcFVBQX2YGdex57gGlxb2DUQWC3kcXECsfmLrdMRIv/qm/oLdtPdogxvFUo7VzUSVXJqXZv6i13n30FIMi8TlNyvBw2lBgayNVfX+uV44VkpAaXig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3NJdCh71+BpYQszap5teUwi3VCrIHuh0lBu6VWAAsY=;
 b=gCpcs6V6cWTPvH6MbDMMiWjACzekmK6WTwi4WMBw3FWYS9ZhfnGyZ9A16WtuMWCCfjFCfJfotJzWJDeDYDuD9YK0Rptq11thvJGtgF24N1XiaWMnjc1eXbAaTHSFmNoVKdWQOrcw6OvIVYTIGqWR7mpSX85C0FlBPdpTq0nK+pdWT4DoLPDm6rbT3IgH32Qv/NX0Ar2o5NlXhlBDhgCvsvJAZZq+q6PrAsuRqovoM7mzYVJLmAzM4luvKibatxkuMr2EBPW2LAhyecLlks8heBWNTmdyPr2mjhZaXkmvazI48s8kB3sbRuHv1RN+xJ2jqtaza0sxVQn9J5le5iKIMw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DM4PR12MB5913.namprd12.prod.outlook.com (2603:10b6:8:66::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.11; Thu, 27 Nov 2025 05:12:10 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 05:12:10 +0000
Date: Thu, 27 Nov 2025 16:12:05 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, linux-mm@kvack.org, 
	kernel-team@meta.com, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, 
	dave@stgolabs.net, jonathan.cameron@huawei.com, dave.jiang@intel.com, 
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com, 
	dan.j.williams@intel.com, longman@redhat.com, akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, rientjes@google.com, jackmanb@google.com, 
	cl@gentwo.org, harry.yoo@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, zhengqi.arch@bytedance.com, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com, ming.li@zohomail.com, usamaarif642@gmail.com, 
	brauner@kernel.org, oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com, 
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <icora3w7wfisv2vtdc5w3w4kum2wbwqx2fmnxrrjo4tp7hgvem@jmb35qkh5ylx>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <h7vt26ek4wzrls6twsveinxz7aarwqtkhydbgvihsm7xzsjiuz@yk2dltuf2eoh>
 <aSXFseE5FMx-YzqX@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSXFseE5FMx-YzqX@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: SY5PR01CA0074.ausprd01.prod.outlook.com
 (2603:10c6:10:1f4::18) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DM4PR12MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: a3c6c7b3-59fd-4a70-5a75-08de2d738448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IJCrh40oCHc/br9w6cawfIUD4/dJqRigvFlIZfxyQSBJ4n6QJL8Ug8mLE+E9?=
 =?us-ascii?Q?5nLnHPPdP667rCqggZP4YrjWkkTghzxI1P9IP8LEZOObAMnGHsmUuCSNhB2/?=
 =?us-ascii?Q?vA7Ks4co2v33di92sOJGZHfKPQACDl229FQQAfO4chChw+N0R16P3JqPQRxw?=
 =?us-ascii?Q?UnNCnd8LbshthbCPRAZzb0y7byoVnHJUGssybeDlnT0FFUGcnu12yLhqhO1d?=
 =?us-ascii?Q?Ckd0QhPbFKY0VOC6HzaizF3ygA0uWam+PTomlvCeKKNrEV4R0/QI+JZ80EJd?=
 =?us-ascii?Q?ij2v3BWjD1utPyKp3nwNfEqEwSMdUhHo1Qb3nNT+RpKAVtJ/J4niMTS/rtmV?=
 =?us-ascii?Q?PVmRQltdvxFLv/UTmX4rhl2KQxKEStlrAIBUP5EZCK/9RXuF/nZepyW89fnF?=
 =?us-ascii?Q?BtdwhhQKP2j12/u+E/ILlcr/usPzoW97w85Hqnfi0WSkx6vwPXtbCdbLT4a/?=
 =?us-ascii?Q?/KPW9J5WdLyMVAu4tFkJKo0PIHQYGwULcTIrGU9N0FlrALLhlmM3R/jp+3Xw?=
 =?us-ascii?Q?HskabyNoaMy09ExXpj/5ygEOMUTea0fafXr7O25RnNZI/2wDrl+JAINKUFMs?=
 =?us-ascii?Q?kAVUIO+VIRm1W8be8rqgO2cOchsS6hseRMnaMKKBHe9kfQ9QRqRojBXpSw1e?=
 =?us-ascii?Q?fZJrOjNRPipU8WlMy1f6B2xHR3+b7XKGE/SC/SY2YdzXCnv0FRR8CRGGqzHm?=
 =?us-ascii?Q?sH86XNGKJejgn2hRMh0sxNMyPwFsGYpBEgW7S8fHvaXdcMliDm59Jn+QD3s1?=
 =?us-ascii?Q?cTarpBRu5EGNemIGJ3DPz/Cr9BNqueLwxJdVfiHYsVxcAuzzeVLoXqlAkqw+?=
 =?us-ascii?Q?QyXgEWPqjTAC0kkx0L/iadlnG7qJyZAqcLG5qZNvo7QPBTSbGnNu6TjJcYLN?=
 =?us-ascii?Q?EdsDMzDTBRb2uFjEoey+1huxmMQMzZp7NM/oApokpMKTSUArv+aup2rcs9wr?=
 =?us-ascii?Q?+0Fi4/jjpug040d+ZZlWOSFDW1XM1fgD4PGP44lDkTnXHCsLH6x3pG2VmWUC?=
 =?us-ascii?Q?Q7p4FK+qIu17KyJOQWfLaW/aSwjRrn9XEFZq/gF1titpHtdAaG3SBKunlEsC?=
 =?us-ascii?Q?rTbVL1ZAhP89aJIbnURM8LV/SoYPPcBTHE3rjF6kj6p/qUV1Gz1VtJf+QCic?=
 =?us-ascii?Q?s7/pBSPW+ANPbYxAbl2DBRhoIbD6j9G4tf2r7nCHrSwtosLGaxC62xAxhIqC?=
 =?us-ascii?Q?5ogBmYF8C1VZCEALC1IBmKjfEFExlZqzW4p+ogBf2QW1waD3TbT6gLt2kOsq?=
 =?us-ascii?Q?uU6asBYLWMcwiKYurEVJek9m/eaBNivs0rWeqQq8WdIjHnikifJNKi2LeFw6?=
 =?us-ascii?Q?WWy4WIG+lrZ4+OHrjouIM1DXRnYWYhCxwYsuLjcG3/cgwcEqEtJEv/26XgEv?=
 =?us-ascii?Q?1r01H97B0ovoC0vqJDVclpF+S+eQXUvOmn8CfDu5NXjdHKmtLOFcYg7aeBnH?=
 =?us-ascii?Q?dJbTSXhGuXQru75uITpCB7cBZYsAjp/h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dX79tMZdEglL9NitfVR64IKdW6IwM1fcyhX9nbtYkk+TAD+1MJYVutC180Lr?=
 =?us-ascii?Q?fCHLQzQTWT9Wplr/nQZsSlSXFD/jKLRFvmPLq6qtYL9GLElYE+9Evss0Oagk?=
 =?us-ascii?Q?tCR4lwIxtjjwYS5/y1vmjHS4D1u0Fi0tXJAAcva5WLfpGM8xZyHINDWBiWco?=
 =?us-ascii?Q?i6UqDY74l9oPR55xWvm2rhUilhFOMwsAaYJTo4CEMDIko3F8Z9AVpma55Kte?=
 =?us-ascii?Q?SGd8plRG4F2+bw+MrTUv455oSD4KydRV81xSnJMwDF3fv/i9/IzOVexwt3IN?=
 =?us-ascii?Q?jrPVTr9/RHz3Bx4LrOeQLWfFY3kTyIDTKjzuLIGmJkXHRNoKGIubhgOVE6PI?=
 =?us-ascii?Q?5HUnmUo3FVL4SH80nX8LlIBgk/88HRdIppy5g7lzcn9NZjUodgytXi+sFYNC?=
 =?us-ascii?Q?O2YVsHtM2I9eU3TldHXNJ3FHHMaz1rNo9vIg4TTnPtlM6nsJmNP3qiAghWLs?=
 =?us-ascii?Q?tMzK+omoWJE7tyCPKzctQn9hv5+ui/Uoh6R/UsVSx//23vme4ZIGEHidxjzq?=
 =?us-ascii?Q?ezLiaJRUByCVkJ+BBVh0ssAdnBLOmHnJMSV4ZK7omk2AaEBr/a6jUbfdT0nK?=
 =?us-ascii?Q?ay/G6uL6F871tYYFC9DswDZ2L3E8+9TUPG0Yg0pCBGjaR4gkH9RB+CTyXPlN?=
 =?us-ascii?Q?wbPwgvCgOYVpf5s/DhKNx58kfJ9wtFWTaxpJAP409aSDvhsNJE9hrnZGMKN+?=
 =?us-ascii?Q?yYJnlqdcGo3JO5IR8ubLHjOLhbSL57jj0i/Ab7xQfIuEM7jXIxbV3F14UMCe?=
 =?us-ascii?Q?S5y5f0pAXuSzQzHXt8WnaPYF7+2HVSNJ2aDaGw6GHBh8haN3KvHaiopQ6vF4?=
 =?us-ascii?Q?xbnHh4tmKaRMYzhI1F9LyL7zN8cQ132vTAvN7nKrn/gzj72mUqdJYaJaxxDT?=
 =?us-ascii?Q?+LCp8rpSJ8miDgwKgf3iNSh6Sth29TIkyVTNLBG4R62cYc3uTzj11ZNBadNI?=
 =?us-ascii?Q?2f/lkBBnbpMZdhhB35VxPy6L7xME7I/9IljmiUr34x7dMkQH8woNCthlEwjX?=
 =?us-ascii?Q?Y6c3G3VHEOCPjQLDaOkhJFVjBmGraYyIf2fF56oFDrcRxWe0nfIoTU95cNag?=
 =?us-ascii?Q?LFwxXhXumXe13QpiiUMKd+8MW8XbRBu0LhGAFHqThda7aQXOhyZMgvXRTgxN?=
 =?us-ascii?Q?HXp6UEvUeHIsiEAUeAIO3NBNPskwoFEiXidA6gLDfSR49IqGahpeiLpk8jWT?=
 =?us-ascii?Q?7AkaAaPIOZi/IXQGuIlmbcXl5T/bjOyi3ZSM1QYkrJ0LnQz88AkjbdJoSilK?=
 =?us-ascii?Q?l/DgebXsZRHJYp/WgMYAwU9P6EQlTfFDtyfhUXFzIWQUbEBd6SipmkPjRAL2?=
 =?us-ascii?Q?8leEuTbehui1JSAYN+cSyHD6o5NJVpigDsGF9nkKI5iM4PKctWZHUuBH76Mn?=
 =?us-ascii?Q?Lq49icxC8gxcruPVHx8KY8qMKktRKklnXW/tLocgpJgT5X23eLnzVqWLiJwU?=
 =?us-ascii?Q?hSYAMkkMuxRGUK+WlSX1JfOSoelhZiKbleOrs88hlxGV0z1KXUqFUaZf5T/d?=
 =?us-ascii?Q?chm1ECm77wnnH7PhX+Vveeafur5pMHLeabiUthtXeVtIKDFllyeBDralSsMh?=
 =?us-ascii?Q?lDrR9SzXwLww99IBoM7VXjD6PD6kKUulJeOfmofG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c6c7b3-59fd-4a70-5a75-08de2d738448
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 05:12:09.9890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K2Ubp5458ki59Iqq6ItmzMj6ElfAFM4O1h1Wjy3mn86w7B4phZ0Bk/rZ7NxApLrY7pskQslwOdGUgELIxZE+/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5913
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A27D180006
X-Stat-Signature: 3fekktnon8kzwk1oqyx3o6z1q8r6m7b5
X-Rspam-User: 
X-HE-Tag: 1764220335-438131
X-HE-Meta: U2FsdGVkX1+f0n/beNjSvPrYrM7ReUb5ncyMyWHCLcJnjUgmpbWPAR3YW6D4i3bIx33n/CHZBPTE2u2pZWazYFGdQqqA/pa2YLqCHaIGw8A1AcUrI10wXOsyELeLBLwL5tpeu0wF0k6VWq5p8d7XkIGZc9wM+mmLKEuJZNqERL5dFOkY0rzgQft+AU8xV8wxnUh+52yzIbafcNpNYMYc2Bs9GA/iCEbhd1b2ZrWGggAKh75mkZAo1fqZoH8dS5q7E8cBWlESPV//sEWLS4h1BUeDOPzQMFpRNGCH7PHm2p6cEGUm+FOBXn6PxyCjyDGUcaptZcLCtxqeTOjWxKEGbB3t5La3zsVGFCDWwnJ14+yAePvvRB3x3M0ogRUg886S5o2dUNhSAmddkys1jFlF8JgnsFjs6zuKasql9gO79t1yAceiPODCupf1NJmzL7MN70xCDl5ts8tp6jBjR8dW+w/NQ4rnB15UaEmUFbI/iV/5SF9sWCn+5lrIZI8h7ROsJJBFgOc7MupIJ1ShEJ0+QeUj8DxQJWLBThsATZJyC4zwh2FcVCJZKFI3/Xba+c1brwzH2udpAlp83+jRvXEYOwZCjqm7d7h12NBHlqPR0tVptEg4hD2V8kcsT5uATWp4rbZR/rV7V6o7TbYHWerSBTpVEx2AVWRRLv12Q15N38Pp1FEe+Mfp/Xv/YuUfVmDr6FjKlvO8mTSlfkQ+twaTxoP42EIQm0S3toN6Nnu3j9Crb3qoG+D+nEThmm54ta6aVE/KI4AL3bA30PHP8d7BE50zMJPvxFdNSKdE5LDnlhgCPSk7FlZjdw7lXdFGG+4ocYJMQ9DEyjKkjX/mcHxW2iMdJFnmwVP4vi/J7op9nUZDZYuxdUZSGT0FlSld44elLoN4hbepVbzLi3wsf/6mWS7rqPMjZLex51LalCUjLzcQHKMzNHWFcSpcCknlJscrFS8KIT0o87X+tyBCpxN
 lgiXxcs6
 8d64TzWZiFsk5XUahsu7bX97GAP5I/PIrUR6KAq/RYEYjJQdlHmKOf14qfuMkYTrrl1zda98KUFZCN/6A1CVol5RFzMGponM1o0BW2MO41MrxXOZjoBWUmJXTrAW3hSAKsCQzjtk9od5eTkNblSgNs9XTzKqsDm/VuPPFvQ8YzdMQIiSVDQZY49N2exsuCFqbB4IYSYzEq1fwWAbMTD3oVfkAkPTFS9drGecWL6hcTH/Vyoh25bU5bV8mlZiiG05X/XGbtUllB50jBBn5nzWaXeeiIzreCbwU4EMl+GJXWre+3xQgy4vl+04pBC1C7SjcB8uk0oHa2yojbkvAiPHSvhm/JPNzXy/3ZUk16/qtW9ukYphsmPTGDJ7jWw/tzinMG8IUWmv2bVE2XOaQ6cYh5oslpsAQCZYhyt3u0IZf/2ce0D7/H2oBb/kUZevWwacCbJ4ImodmG89IMVWob84ePxUA+gRiqfcj/97q2uspxQfT3S9+46JsLb1GMrVeLLD3e1bFXE5gqmpIcE1G70o+C28rFmVdCymKxeW8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-26 at 02:05 +1100, Gregory Price <gourry@gourry.net> wrote...
> On Tue, Nov 25, 2025 at 02:09:39PM +0000, Kiryl Shutsemau wrote:
> > On Wed, Nov 12, 2025 at 02:29:16PM -0500, Gregory Price wrote:
> > > With this set, we aim to enable allocation of "special purpose memory"
> > > with the page allocator (mm/page_alloc.c) without exposing the same
> > > memory as "System RAM".  Unless a non-userland component, and does so
> > > with the GFP_SPM_NODE flag, memory on these nodes cannot be allocated.
> > 
> > How special is "special purpose memory"? If the only difference is a
> > latency/bandwidth discrepancy compared to "System RAM", I don't believe
> > it deserves this designation.
> > 
> 
> That is not the only discrepancy, but it can certainly be one of them.
> 
> I do think, at a certain latency/bandwidth level, memory becomes
> "Specific Purpose" - because the performance implications become so
> dramatic that you cannot allow just anything to land there.
> 
> In my head, I've been thinking about this list
> 
> 1) Plain old memory (<100ns)
> 2) Kinda slower, but basically still memory (100-300ns)
> 3) Slow Memory (>300ns, up to 2-3us loaded latencies)
> 4) Types 1-3, but with a special feature (Such as compression)
> 5) Coherent Accelerator Memory (various interconnects now exist)
> 6) Non-coherent Shared Memory and PMEM (FAMFS, Optane, etc)
> 
> Originally I was considering [3,4], but with Alistar's comments I am
> also thinking about [5] since apparently some accelerators already
> toss their memory into the page allocator for management.

Thanks.

> Re: Slow memory --
> 
>    Think >500-700ns cache line fetches, or 1-2us loaded.
> 
>    It's still "Basically just memory", but the scenarios in which
>    you can use it transparently shrink significantly.  If you can
>    control what and how things can land there with good policy,
>    this can still be a boon compared to hitting I/O.
> 
>    But you still want things like reclaim and compaction to run
>    on this memory, and you still want buddy-allocation of this memory.
> 
> Re: Compression
> 
>   This is a class of memory device which presents "usable memory"
>   but which carries stipulations around its use.
> 
>   The compressed case is the example I use in this set.  There is an
>   inline compression mechanism on the device.  If the compression ratio
>   drops to low, writes can get dropped resulting in memory poison.
> 
>   We could solve this kind of problem only allowing allocation via
>   demotion and hack off the Write-bit in the PTE. This provides the
>   interposition needed to fend-off compression ratio issues.
> 
>   But... it's basically still "just memory" - you can even leave it
>   mapped in the CPU page tables and allow userland to read unimpeded.
> 
>   In fact, we even want things like compaction and reclaim to run here.
>   This cannot be done *unless* this memory is in the page allocator,
>   and basically necessitates reimplementing all the core services the
>   kernel provides.
> 
> Re: Accelerators
> 
>   Alistair has described accelerators onlining their memory as NUMA
>   nodes being an existing pattern (apparently not in-tree as far as I
>   can see, though).

Yeah, sadly not yet :-( Hopefully "soon". Although onlining the memory doesn't
have much driver involvement as the GPU memory all just appears in the ACPI
tables as a CPU-less memory node anyway (which is why it ended up being easy for
people to toss it into the page allocator).

>   General consensus is "don't do this" - and it should be obvious
>   why.  Memory pressure can cause non-workload memory to spill to
>   these NUMA nodes as fallback allocation targets.

Indeed, this is a common complaint when people have done this.

>   But if we had a strong isolation mechanism, this could be supported.
>   I'm not convinced this kind of memory actually needs core services
>   like reclaim, so I will wait to see those arguments/data before I
>   conclude whether the idea is sound.

Sounds reasonable, I don't have strong arugments either way at the moment so
will see if we can gather some data.

> 
> 
> >
> > I am not in favor of the new GFP flag approach. To me, this indicates
> > that our infrastructure surrounding nodemasks is lacking. I believe we
> > would benefit more by improving it rather than simply adding a GFP flag
> > on top.
> > 
> 
> The core of this series is not the GFP flag, it is the splitting of
> (cpuset.mems_allowed) into (cpuset.mems_allowed, cpuset.sysram_nodes)
> 
> That is the nodemask infrastructure improvement.  The GFP flag is one
> mechanism of loosening the validation logic from limiting allocations
> from (sysram_nodes) to including all nodes present in (mems_allowed).
> 
> > While I am not an expert in NUMA, it appears that the approach with
> > default and opt-in NUMA nodes could be generally useful. Like,
> > introduce a system-wide default NUMA nodemask that is a subset of all
> > possible nodes.
> 
> This patch set does that (cpuset.sysram_nodes and mt_sysram_nodemask)
> 
> > This way, users can request the "special" nodes by using
> > a wider mask than the default.
> > 
> 
> I describe in the response to David that this is possible, but creates
> extreme tripping hazards for a large swath of existing software.
> 
> snippet
> '''
> Simple answer:  We can choose how hard this guardrail is to break.
> 
> This initial attempt makes it "Hard":
>    You cannot "accidentally" allocate SPM, the call must be explicit.
> 
> Removing the GFP would work, and make it "Easier" to access SPM memory.
> 
> This would allow a trivial 
> 
>    mbind(range, SPM_NODE_ID)
> 
> Which is great, but is also an incredible tripping hazard:
> 
>    numactl --interleave --all
> 
> and in kernel land:
> 
>    __alloc_pages_noprof(..., nodes[N_MEMORY])
> 
> These will now instantly be subject to SPM node memory.
> '''
> 
> There are many places that use these patterns already.
> 
> But at the end of the day, it is preference: we can choose to do that.
> 
> > cpusets should allow to set both default and possible masks in a
> > hierarchical manner where a child's default/possible mask cannot be
> > wider than the parent's possible mask and default is not wider that
> > own possible.
> > 
> 
> This patch set implements exactly what you describe:
>    sysram_nodes = default
>    mems_allowed = possible
> 
> > > Userspace-driven allocations are restricted by the sysram_nodes mask,
> > > nothing in userspace can explicitly request memory from SPM nodes.
> > > 
> > > Instead, the intent is to create new components which understand memory
> > > features and register those nodes with those components. This abstracts
> > > the hardware complexity away from userland while also not requiring new
> > > memory innovations to carry entirely new allocators.
> > 
> > I don't see how it is a positive. It seems to be negative side-effect of
> > GFP being a leaky abstraction.
> > 
> 
> It's a matter of applying an isolation mechanism and then punching an
> explicit hole in it.  As it is right now, GFP is "leaky" in that there
> are, basically, no walls.  Reclaim even ignored cpuset controls until
> recently, and the page_alloc code even says to ignore cpuset when 
> in an interrupt context.
> 
> The core of the proposal here is to provide a strong isolation mechanism
> and then allow punching explicit holes in it.  The GFP flag is one
> pattern, I'm open to others.
> 
> ~Gregory

