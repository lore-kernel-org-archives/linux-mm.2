Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C23CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B696B0005; Thu,  4 Jun 2026 06:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D156B0088; Thu,  4 Jun 2026 06:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E43B6B008A; Thu,  4 Jun 2026 06:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC496B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:35:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA8484049A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:35:36 +0000 (UTC)
X-FDA: 84841873872.24.CD96462
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	by imf27.hostedemail.com (Postfix) with ESMTP id 089F34000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:35:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LRriQ8A5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780569334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VH93P3BV+lDFVEUF06jtxSdWyj/bLLqkQIB8LJQrAfE=;
	b=0j4h6trDNpQtzZ4aS8bqdVesKwT89jnOLMYdtYlX3qAgiQQ9mCqsm8+4xwKFEO84/ittfp
	ciAXjEeW5bMiz0G2rg5+aCI3umtIKfAsYEQP57y+gbir6w50HxPvnaT0fPeknS40icDVAp
	g8dAcunD7KmPGJvJ6okmNd+mF3qsfL0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LRriQ8A5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780569334;
	b=xyHX3aG9bNHtwM3UQpU6hcBpmbjaZuxSsCv15oLv+PRJ4uT+IXNChudifDjGei1KqWlWWA
	3h/7Z4D/pbCXInVmZdtJ0c/TPIEjwbkHVFWKJ/c3SX02uW4CRYEJUFhhfPJ29Z4FBOvBN6
	2gqiiTzimW7JBupZDCzUGt28YHRXnXA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CD6whB+YBUvDqhLZ6xvnFS+b7IJSpiKmgdI8FhMFjT+JIRoYi4Kf9hwsSYLPfpMfiZlJcZPQO50tcsN2b/d7Z8PW/KPd189lLMapJqUIVYugVjnhvJO3308804kBuFOEKrirUiJ/Al+Mhmbw+h3MogFnGhSw3flyg5KgyI3aVAqd28Wd7r0SvTkrk23ms49fHZ0HGYZTGZDE+vGHgLvx1bwsLYLgCFXJqVFUvv1AV52O9XAs34Q1bJqQh4ryTom+P/C5ZYz3OsxhZVMjI7MxOXd03Z3qweHOdMOV5rxoGSdTYH7FuRsvFEsVtm4Nhm5NIxjvcZA8+fYGRBuhrLttSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VH93P3BV+lDFVEUF06jtxSdWyj/bLLqkQIB8LJQrAfE=;
 b=Ajy1pkSdKenjDAi/Oxezsd9BJyUearhyvFmugAoLw9Jw3/WTJQiysiBYePMu44mwq88Yfs7fyHTZ4XQ3TV6VcdAFxwhDli2DOPOh1GAVoxNJkTeLw/eA4JbSUDnlFfn/CB676ZFZwzoLLG/MSZ8PDb7dYG9frF3gGxLjZ/yImVSGroujAieuTtprn5t5TOd6ZQ/qZTYWlQcOrm9wRnipfTwr8jJl6iy9wkaYDKe51ECZp3a8VPmAjC8MrgZFWT2YYQsp0OUag7ykpClY1BH0Jr6jg6sOMCKHgRUMkjZBle/pLnoSvoxdkX2PastDRCd02NByPYcaaKSFfvstM/U6SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VH93P3BV+lDFVEUF06jtxSdWyj/bLLqkQIB8LJQrAfE=;
 b=LRriQ8A5S2JXYGU7spdchVtn4FdODrWSIXBXZi0TegqLAai528vwIlLqz/oQlbbtQrPHmm+jyNdEVzxcVDadgGrJOsbvaOWEEl+ko61/4nxY+NZhR9cGlTKhrFfPKL6RyHwnSUBW5DkHdKIgzuRmuW686yYF/rROdPChC/892MZJRLP1YMEctJHy654aUkENv2ImNp1fHqnphOQesnm2VSbmwu17FF3H8i2USbCaMP8Zv+MqJX6zdSB5Y91huG3eAA/0bZkyv/TN19jyxoxx7+ruJptBDGLQ/gYFKZEOVuwiMALhtTYNeF4setfAD6zsjZXvN57IDBY3lGjfkUzBGg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA3PR12MB7831.namprd12.prod.outlook.com (2603:10b6:806:311::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Thu, 4 Jun 2026
 10:35:25 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 10:35:25 +0000
Date: Thu, 4 Jun 2026 20:35:19 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, kernel-team@meta.com, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net, 
	jonathan.cameron@huawei.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, dan.j.williams@intel.com, 
	longman@redhat.com, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com, sj@kernel.org, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	pfalcato@suse.de, rientjes@google.com, shakeel.butt@linux.dev, riel@surriel.com, 
	harry.yoo@oracle.com, cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aiFSZfRlFPd7qlIw@parvat>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <ah_RcTU8SpQG7hab@gourry-fedora-PF4VCD3F>
 <aiDVMgu0viTIml8H@parvat>
 <aiE5DZC8Io4SNI3H@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiE5DZC8Io4SNI3H@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: MEWPR01CA0033.ausprd01.prod.outlook.com
 (2603:10c6:220:1e5::10) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA3PR12MB7831:EE_
X-MS-Office365-Filtering-Correlation-Id: 51bfe0d0-7762-41f5-af43-08dec224fc25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	64BQWqeyNrAnfhlLTZAEJeCmL66QY+VfszMyPGuLE7CkGmU6LxEvQE9wpkSm9R1A3XEmYPMwSP2ihCgM0eIL7bXWVyHMgp3+VPludZEvzV9EJw7Fzmg6Ys7GNH+pd0yZUkqsnqkpMH73xDzntk66kNWOPg+E6vblV4qJCvqjgWenME69a4Jog9YL25Uq8YTmLHlr33q2Do4I3CRDXJLDWW+EyxS8J1cMFVi1C6MLZzoeJfYcE+wvdDL1CsWl4zEwZbpYNTc7GS3f4R7OCtzN86lb2zWtpk6H/PbUGc3W+6347Htd/SwL4GEiGnv2bMfLKl9LRIgsCW7L6kA390w55T/fO6ZrHasG+C+x+KA6GkBAFJiHdI7UCnhEqIcSulLtvS6FvHekCKErhaW/ull+crnZ5Oemn2y8LwPrVQbOB2OZtanc7Y6Pi85wsyEa4a2jwLvde3ueqfd0q7XbPC5g0RsHAtDPFMGXlvvwaikyg8Ahdn+iOkQ2msB2N3DRAtru7kbi/UgruNxxnxYS80BqaITLRcNncplkMj57QqfYlnLUuyrKcWPK513wKQouLmBfQVW4nPZoWwD6+ERQ1DtBFx7j17Iscalr6kyO081ctabVZRicNqrfqzH6MKF4D3WVzmnALg+NqoP8eA0b2D8H4PPhE35ZicEavwRNo/jew8fS3Au772zmyeJPaO9dEQJw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9lIn59rVNN7WvJ2TXr0YWRK1zyQLkfC1AtMSfCyMOJpAY4jKCH1wV+hz1RiT?=
 =?us-ascii?Q?SZ8YrWaJZuYdk9sLXrLNQKlsVtUn65zT62ZD334s/S7P1FMN/Fon6oHt6TES?=
 =?us-ascii?Q?VXKZLB1WdgUEq866CDLYm1Tc5MeWQKO8Cl2cR6d39dUpbxJfYyc0cSlRBLCD?=
 =?us-ascii?Q?vO9tCIPhk0oUnzQ4Rsjd4O/mHUGD/U0jrfcAG7O4jZ793I3wDhi4lOyb79bP?=
 =?us-ascii?Q?CwN3BgsQZLRNix5p/61QecBf2s8kzZTemnx9ILYGNfHle5uVP2KXaNlr/FM5?=
 =?us-ascii?Q?2WzcluZuCqbB8ASA3/cZ+7cznYwMz/Sb3+G3i9tCi5W3JKeTzDjcqDO/cGa6?=
 =?us-ascii?Q?v5q2225Z4xRglCw1JEmfvtDs1lNPx73UY9M/MntGl76zmoHzusxw7MnibnnS?=
 =?us-ascii?Q?lGlywO1jETTAvPg2ZhTY7CiVfsa1T9PxUjxwdMtBBrKIpqTv3O2VdyD4fPst?=
 =?us-ascii?Q?8eUhtDBMu3YcnWWUMbealjBkdGxs8GZk/DBbE2c0cBPzi4xFp76Nz9ddyUYS?=
 =?us-ascii?Q?d3TAzF9KgQ08TJGRcZvtcQO6fiTc+AkvSLxshLVXmJNxvDsboQb9rN6TYoF+?=
 =?us-ascii?Q?lOA3tUT6YVmz816+vxdl4EQwvu6pVG8SoLAJ1jiTScHprjrwbYLZPiDU5frZ?=
 =?us-ascii?Q?+1kFqPiJpliOXKWv9vHwTKNkJg43YcqBXbuOe+zEbgoZptv+C2PgvlfqSd3h?=
 =?us-ascii?Q?CifUQe7X7ZtCIiMREA+jjltZvlFFLXtsXhu5A0zL+J94iAGbDTHImKr0seDV?=
 =?us-ascii?Q?LpAoUK8vZ78HHGnPCimSpw9k7qwOu6ha4CwHY3bnqsreI3Sw5xu5lKi74jnI?=
 =?us-ascii?Q?ZMO+9WlnIM2xBn8V4fY1NJ0t8PJ9/XWrALZMvN2Zb8C5tbCtPdCtJSfAQheV?=
 =?us-ascii?Q?dQQxe1YcgiwX5ZaOxa6CLlSbU/KMfQ5lykbHtdVyTm183lGxqVg3u3c1/YyQ?=
 =?us-ascii?Q?OuErzGon0GzgtkYuhu6DALb1EmvodMytIwf3Ha9ugr4/ELjLZZRRW+TN8uSW?=
 =?us-ascii?Q?n9/6JkK2FbsSUxzdizn+E2FidthqnGeM4J4hRRVJQrKGQ01a+4nHsOBXqfiB?=
 =?us-ascii?Q?GpU0FfNAdKHVt8kY7aw8liKQpOHC9b2nIkUHxPev9eB5jRYE3R7dkkTGwLXP?=
 =?us-ascii?Q?JGwS9FkD3gEkPbfdYXRy0uzhVcOedBCBGCGQcka4Hz25NfJ5dSUlTefoS+Un?=
 =?us-ascii?Q?/5Q4BJeo8Gy83kMgyaXhwggSPSukFNUHWppEk0Mn+wgdTqCXii1JM0JNVqup?=
 =?us-ascii?Q?CAsVTskMcjzsh+8aCgBtetZP2hmcRr5cGZeqIVeusqyJ/27k3cCpKI73ifdu?=
 =?us-ascii?Q?Cc4Z9ajmLWYGKG5TAlgErxyE1mF4SxiVPqh4+4LgpM7cTD8qgcIPgVx3N5nI?=
 =?us-ascii?Q?pZ+G4vdI5u1rUu73oLaHxWWMLInT9F6fpKkIqQ4rxgrMdKFdyS9n+hE2zIZX?=
 =?us-ascii?Q?GA+CKQ6QZQSGR8tbZX/T4bmLuf1wMy5s2JFTcNF5b/8MxoL/Rg0WgTYVlmxz?=
 =?us-ascii?Q?IQxqGlhx3tLAPwcCgZlPd65sIlqQe1kqjsFXExDEYijHbGD5i2sZWLVG1AXs?=
 =?us-ascii?Q?SHLaPEuat2w64sZAAfU0wQI/GhH7TvFAOho61dg+GMgudMQui2NEvF6N82Da?=
 =?us-ascii?Q?E4rpOmbu9Dl9x1qHyBHjacMSoLFCpM3OsFYbxTyvjeYF/MpkK82S4EPBinn1?=
 =?us-ascii?Q?9cgntKIkU9evsyCi9qjYIv/pB+q6LWZz3yZUpAc/nACfLDb0f0GM/8JglqTm?=
 =?us-ascii?Q?ORyp1s8NYw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51bfe0d0-7762-41f5-af43-08dec224fc25
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 10:35:24.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQ5kfOkwzH5Ur3Mi92WaLsuxsezODtqSvPh+FEK981UOcM9sYpKcfAmi0tQGAfYwwTHB8D9SYcaUIdB8QDzR8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7831
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 089F34000C
X-Stat-Signature: a1b73zg6i7fduxfi8bhcob8ik6qp115k
X-Rspam-User: 
X-HE-Tag: 1780569333-154072
X-HE-Meta: U2FsdGVkX19Ma7TXUCxcyOikhmbpgkF73Pmi3atpL2IohdnAboUDLm0OiBhIOVtnAIEgzUuYRskf0uP8FpRkiLSZdRpQY7VNAuuz5sBnC1NGGXS6Yp6dmaGL+hBD6yqW8n2qwfXrO8jExUfFQhXWnQpl7HFkM2Acfh3xpJl+5JrZmDQiZlIQrGX4BMykaX7nBta+EjvTPyoLTfUfuPTipe74tAR9eQsJmqAZZV/w8Qn+ThIogheg+ISezm4oTr5QpEdYjlVDc6b4XzTNUHGEJC06xxyxSLyEcBJMiXLqYHxusf6xltV+nqJ7kq/By6P6sVAupC+Q0cT6/lvd3M1q2hIvF2cetuRHrzoZFkawl2IM+i7ZSI7Ww7F8zmFoxGSx0hBM1GWqNW7h1VgVBnDel/uNdR0OXXldnNh7Oe34EFs95/RD0zI1oz0ITZyPjPv0rLGz+IC6K8mgf9JOtRlcjSeOKCp8KkmUs/NjfAgLHOUM6yuAkfEbHAc15mUcKxop7kAQFaOHxRzsyA4PPm4JmBPfj7/hDf97BQTrTMV6tZbWTvB7YIVEzJluBGPCYP9grcrbNuq6cjWtAMQwot1uOyMY99F+hPhGG84GGpw1me+iPz72JN5dkZsgE6LfkuLQDXfYe4HAhIyC8Av49ETJYwb/SYgm3MtNZEly3+1vyWF6aMMD8ifQL+qlMuiMxAfX0ieApD8DdeJZNjM8AQokuAnpGu4wW5rMwXE6teg4OoMvxKiMrv+nI5riAP/Em3rzRTXL1xg+6PQhMAtwR2TDncqnd9NpTCuWOf+AR5XHhICa7c13bce3/PEBLe0J19o0eJhG83fA8Sa2IwCYxQffDFVyS5MzCjv/JJ9oCBJLYdQbPGgisXviRnMbs8FdGdNOg1mETTh1eCblL0oSWC0s4a8jjoGyBBhUon0wBS/DajaoGGzXuO3bpwmWS6/1hmcWymSZtQq+T//sb7EW85g
 5foDrh0x
 93NRA0gssM8Mt9RoDDWXsQCqoDP5BBkA4cTJU4AT4/qgTbp9AkbYJuHXWtbJ7tTOyBeAUwbcqlXGumasNGeUS5qdHS420JP/vmNV3aNr33G07zb2jzZ3YX1uAKIYN2ri2XPKGRPvJbdPSray8RrEfCk5nGk6edTrRDRJBPqDkkUNXXBOSF+CmXY0bjGqVlDcRxmzplsARNkKFOwRtefGxdQzYtkVuuwAXzTHz6/vwEKQsrJee40xBsnM7tSizgWzXvMRXW6fwvsAmzT+kKcZmoNnt3QcAFVVeeAuQARHGVCp40+Mdh/+DGOIHPBDMNW9EimX0MTbBJYQ6mGKE9Jt1ySrRi6fN+OnVFk7hk3YCW+BlYFou2Qq1+kjEHbwmY/weab6vTjXLKVsUfp6BclSm9IpHgfnP2tgahlBBLX2mBhHRwSWcup0MwSsIbLMzIl8eHxaiPOGmsYXYTKOV0UrArcbK/aGrUOQysRkO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 09:36:29AM +0100, Gregory Price wrote:
> On Thu, Jun 04, 2026 at 11:43:14AM +1000, Balbir Singh wrote:
> > On Wed, Jun 03, 2026 at 08:02:09AM +0100, Gregory Price wrote:
> > > 
> > > Here is how the page allocator fallback lists and nodemasks interact:
> > > 
> > >    Fallbacks A:  A B 
> > >    Fallbacks B:  B A
> > >    Fallbacks C:  C A B   (Private)
> > >    Fallbacks D:  D B A   (Private)
> > > 
> > 
> > Do we want regular memory (N_MEMORY) in the fallback list of device private nodes?
> > The assumption is that we have ATS translation enabled? Assumiung A and
> > B are N_MEMORY here or am I misreading your illustraion?
> >
> 
> If we don't have __GFP_PRIVATE, then probably not.  This is a holdover
> from the current __GFP_PRIVATE branch so that if the preferred_nid=
> value is a private node (which is a hint, but not a hard control),
> there's a way for that allocation to land *somewhere*.
> 
> __GFP_PRIVATE would say "Only allow access to private nodes if this
> flag is provided - otherwise treat that as unreachable and fall back".
> 
> (__GFP_PRIVATE | __GFP_THISNODE) then does exactly what you expect (only
> allocate from specifically this private node and don't fall back).
> 
> This has the added benefit of not causing OOM on allocation failure.
> 
> Some would consider such a request a bug (i.e. that caller has a bad
> mask), but I find the premise of that statement to be flawwed if only
> because we do not have good controls over what ends up in a nodemask due
> to the existence of things like possible_nodes.
>

My concern is that __GFP_PRIVATE is too wide, I wonder if we'll have a
need to support N_MEMORY_PRIVATE may not be all homogeneous memory nodes.
Very similar to how not all ZONE_DEVICE memory is homogenous.

> 
> > > If we wanted to change this behavior, realistically we'd be looking for
> > > a way to add specific nodes to certain fallback lists - rather than
> > > modify the nodemask interaction in some way.
> > 
> > Yes, that is what we did with CDM, control the fallback for
> > N_MEMORY_PRIVATE, but there is a design decision to be made here.
> >
> 
> Agreed, but also one which can be deferred and played with since it's
> all kernel-internal.  None of this should have UAPI implications, and we
> need need to accept that we're going to get it wrong on the first try.
> 

Agreed that we might get the design wrong, until we fix it up. I feel
that __GFP_PRIVATE should be an evolution of the design to that point.

> > > 2) full mempolicy support doesn't really make sense
> > > 
> > >    task mempolicy PROBABLY should never really touch private nodes,
> > >    while VMA policy certainly can.  Assuming we're able to support
> > >    multi-private-node masks, none of the non-bind mempolicies even
> > >    make sense for most private nodes (interleave? weighted interleave?)
> > > 
> > 
> > Yes, mostly, but is that baked into the design? If so, why?
> >
> 
> "Baked in" in this case would mean:
> 
>   set_mempolicy(..., private_node) -> -EINVAL
>   mbind(..., private_node)         -> Success
> 
> With appropriate documentation.
> 
> This can be changed later if a reasonable design was agreed upon.
> 
> > > 4) File VMA interactions don't entirely make sense with mbind
> > > 
> > >    In theory you might want:
> > > 
> > >    fd = open("somefile", ...);
> > >    mem = mmap(fd, ...);
> > >    mbind(mem, ..., private_node);
> > >    for page in mem:
> > >       mem[page_off] /* fault file into private memory */
> > > 
> > >    In reality: This does not work the way you want.
> > 
> > Why not? Just curious about what you found?
> > 
> 
> Because pagecache pages are associated with potentially many VMAs.
> 
> The fault can be a soft fault or a hard fault.  On soft fault - the page
> was already present, and will simply fault into VMA without being
> migrated.
> 

Let's split this into two:

1. unmapped page cache is never impacted by mempolicy and should not
   end up on private memory nodes
2. For shared pages, mempolicy would be hard, but it would need to
   be on a set of nodes backed by private memory, depending on mbind()
   policy

> You can imagine the following
> 
> Process A:
>     fd = open("somefile", ...);
>     mem = mmap(fd, ...);
>     mbind(mem, ..., private_node_A);
>     for page in mem:
>        mem[page_off] /* fault file into private memory */
> 
> Process B:
>     fd = open("somefile", ...);
>     mem = mmap(fd, ...);
>     mbind(mem, ..., private_node_B);
>     for page in mem:
>        mem[page_off] /* fault file into private memory */
> 
> If process A runs first, and assuming VMA mempolicy is respected for
> file backed allocation (note: it's not, see below) - then the second
> process will think the memory now lives on node B when it's already
> living on node A (pages are not migrated on fault).
> 
> filemap page cache means file-backed pages are global resources.
> 
> Re file-backed VMAs - see filemap_alloc_folio_noprof in mm/filemap.c
> 
> struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order)
> {
>         int n;
>         struct folio *folio;
> 
>         if (cpuset_do_page_mem_spread()) {
>                 unsigned int cpuset_mems_cookie;
>                 do {
>                         cpuset_mems_cookie = read_mems_allowed_begin();
>                         n = cpuset_mem_spread_node();
>                         folio = __folio_alloc_node_noprof(gfp, order, n);
>                 } while (!folio && read_mems_allowed_retry(cpuset_mems_cookie));
> 
>                 return folio;
>         }
>         return folio_alloc_noprof(gfp, order);
> }
> 
> We'd have to hang a mempolicy off of the file and use fctl or something
> like this if we want a file to have a node preference.

I'd need to think more about this. For now, my basic requirement would
be that unmapped page cache should not come from/to private nodes.

> 
> > > 
> > >    I went digging and we need a few mild extensions to allow
> > >    migration on mbind to work for pagecache pages, and the fault
> > >    path does not necessarily respect the vma mempolicy always.
> > > 
> > >    You also start getting into the question of "what happens when
> > >    the node is out of memory and you don't have reclaim support?".
> > 
> > Yes, we should discuss reclaim support, I think we should allow for
> > reclaim. It allows you to overcommit private memory the way we can
> > with regular memory.
> > 
> 
> Reclaim support is feasible, but again - crawl, walk, run.
> 
> If we get the base private node infrastructure in place, we can break
> things like mempolicy and reclaim support into different work streams
> to enable support for these features.
> 
> Different private node users will be interested in different
> combinations of mm/ service support.
> 
> For example:  compressed memory as a swap backend DOES NOT want explicit
> reclaim support - it will need to manage its own shrinker.  This comes
> from requirements associated with that specific use case (which I do not
> want to get into here).
> 
> That is why this series introduced the concept of NP_OPS_* - so that the
> owner (driver) of a private node (such as a CXL-enabled accelerator
> driver) can tell mm/ what services it should enable for that node.

I am open to this, I was coming from the blueprint approach of:
- Let's mimic N_MEMORY with N_MEMORY_PRIVATE and then pick and choose
  what features to change or make specific to the implementation

> 
> > > 
> > > For all these reasons, I think the be mbind/mempolicy support with
> > > private nodes needs to be brought in with follow up work - not
> > > introduced as part of the baseline set.
> > > 
> > 
> > I am not opposed to the follow up work, but I feel mbind() should
> > be the fundamental work and user space API.
> >
> 
> This is informed by a single use case / device.
> 
> There are users / devices that don't want any UAPI for their memory,
> but simply wish to re-utilize some subsection of mm/ (page_alloc,
> reclaim, etc).
> 

But then, why do they need NUMA nodes? Do we have a list of use cases?

> > > 
> > > I am arguing for #1 - the community has argued for #2 and "fixing
> > > existing nodemask users".  I think we can ship #2 and pivot to #1 if we
> > > find fixing existing users is infeasible or too much of a maintenance
> > > burden.
> > 
> > Again happy to discuss this, I'd like to make sure we agree on the
> > design. I am wondering if there is any experimental data to choose
> > between 1 and 2.
> > 
> 
> I am trying to test whether, lacking __GFP_PRIVATE, any normal runtime
> operations access private nodes removed from fallback lists are reached
> via something like the possible / online nodemask.
> 
> I remember, maybe a year ago, there were per-node allocations happening
> during hotplug and that's why I originally proposed __GFP_PRIVATE, but
> I'm trying to re-collect that data now.
> 

Thanks, I look forward to the next set of patches. Let me know if I
can help test what's on the list or if you want me to wait for the next
round

Balbir


