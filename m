Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B0F5CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 05:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD7E6B0088; Wed,  3 Jun 2026 01:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95DD86B008A; Wed,  3 Jun 2026 01:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826126B008C; Wed,  3 Jun 2026 01:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE5A6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:00:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10021140226
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:00:19 +0000 (UTC)
X-FDA: 84837400158.08.EAB97E5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011038.outbound.protection.outlook.com [52.101.57.38])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36165180006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:00:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=baP6OAdj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.57.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780462816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCW/QLLpRGGLbWCkWLPVcWArUftfeG7Y5hVWbTZSvvY=;
	b=J90VLR9Xh87BzcV+IFzW1quD69aXExGy0dDlFmnGuErF/FwqmgEKVssH0Oz5lhEiKcRoUQ
	sh10I79O/XA2TLnP7aUSJQGbKzj9xiHIWXn6OSPRBBU7T3wgHHs+Cp4A3o+chFohoNT2O3
	vl7mS7vAbcP8OPz7FKoNvsfT1wbikBc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=baP6OAdj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.57.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780462816;
	b=q3GYoWdRWinFdu78Cbhig0qXVUTZ+sBohzxRKQGt0QRc9OlSN1UKow5/PV5Nw3hwM6/NcT
	A2Dys5jaxsTO7oUNUKyynOj8v42uTRwiobVCEUjWRyiE1EywtZSOz4FvpsKWMOasdf3EQX
	blLVDZdY4zeKjMW9geNrL1wvwpOa5BI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVT38OtQkpc9RepAN9aN6IxbQpKZ4XuL5ezYSC5+bvVVBz9xcaxk/Ly/1IDkIBYGiUlWtGuOgdD3hzroQHI7zrqCEKts+JFFc3fxHFIhHqh/zuCuOQb+O/KBwcA4+c34jIXSjl46FS8HMayWYis28sWkbJNzRnjEPkJgyY684LVFWlTxkj/F0U1Gov3MXaagHefDbP522Q6VfWj4n9sBxFhPAB2p3fpHxBrX1nJrnXfJe6KIYUweZ1DQmhZIywF/wifvBnRLGvhL224nsVqgY67I1Gop06GvFN3667eD6WWrE5DwAuHYphOTmBSBAeonA3ttQSQ63IRFNzHKZmCRyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCW/QLLpRGGLbWCkWLPVcWArUftfeG7Y5hVWbTZSvvY=;
 b=XFgUiGNgaPsyVYiekus/pjceRLlB0maBViBN5mmV+2WmqTAncA9D/K0mjpuYAJQPsgsrzBcIHMQlZMX7YZ75bWtxMfLSN9i57bPseMF3UA2E7ZXv1dHIjqoYmGU3+295r4nzyPR/EOyPY9HpZsOHYKhVpJYHTQv5kkBcGwXctqC7rnm+KqT51PScv3n6GcXqMO1t6scEeSCypbspK1OBgk/RFIiiTgBFr81nIkQLmj7j4fc8/qiQ4lsc/Jev9qaMCkjh4D7hRBiJ2J2bcFJHLXOa0W2pG+eQNKi7ZeMHp9yf/W1phIKWRw+7BdHG7WjGl/V5ryeLPmB3LZAxuYnhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCW/QLLpRGGLbWCkWLPVcWArUftfeG7Y5hVWbTZSvvY=;
 b=baP6OAdjRhLxqqOyQHMF8AE15mY8ydh0chQu2gtD4zntM4diVpVliT9XodbzZi6v73NOZoBRrHoYcwuZL3TsIwYdIr1HeleA5teKCF7MMufP56y47OWhT9WFQUlBhoXHoUSnIzhdi6mjb8yhZpG7CPNbmw00kaChEjU95BOKPDJ1bi7T//uGcOD88cnVoyd2ociJO6+Za1ClZMvspConf7SvtFJ2Smpx8x6wBV076pS5qbk7i3hZRNacrHfsNf3kKDQQZ1TvbPfa3PtHIRie82tK3U1Ireq4Rx8zDbOq3Wx74gWpY4Oz9A4Rz8dtjkvIc5jCGp1vuW2akgD0mLnONQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MN0PR12MB5788.namprd12.prod.outlook.com (2603:10b6:208:377::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Wed, 3 Jun 2026
 05:00:07 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0071.015; Wed, 3 Jun 2026
 05:00:06 +0000
Date: Wed, 3 Jun 2026 15:00:01 +1000
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
Message-ID: <ah-0CyZurn5D1ezY@parvat>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: ME0P300CA0035.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:20b::25) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MN0PR12MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: 4913df85-93dd-48f0-fe32-08dec12cfa7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099006|18002099003|22082099003|6133799003|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	EUyxNe2YsJ7vMHWc70ED249CIGfTZgmJBAyswiljQTh9ZmMfFcqpd64KqlPaMFSEwbLv4jkLjZJoOysY/msHYxQzYSovMXO6DfVqoOSetjSralSLnHZ/HhjEITg1nqS9I//zzZnA2a6svhGvdCH5N7RYK0jkggs5NN2A2ssYLxTXJm6j94/dUhXqXONTSnu5FxnKcnaFUgpmUJyuQ18dQ4Ai9dI0APv5z50Kh1em3qba9nrOsr2VOD9qCo5J2YV8xe1WtrGiSYZy2vDipRY/wQkpawYQBuFLk+s/+3lIoOGePNDUtBwZ2j7YR/ZlfbTmVJqKZOQNddQMaDc1e+mYiZu2yZjGxAACcb5a92JITuPQo8EaBnlMOpAitdhZ3IxcuPeobIm6KsaLkYl6kIZYwrasnNd8zNPFrH7imhkT/c1rOW/ftcM/zRUf/A7yHZTE4QHcOgDMPODH2V9vu82iZytnh2TUgATcfJet/r2ukoo4emOwHi5zc0bb6TDBjygjyAi7ENlhCK7ZVGdCYrI5vsmMD+Z04ELFTrxyxWeo2wzs/OPmguavjpMt87x1EfS3Ps/IovvvrI602eMKqvVg0DaARdZ61WXNEfIoEreQvJdrV/taXI4gncIV7IhwRHg3IyZhdc/ywXjgYTznLv+0B/7IclJ3Z6otZbOBiyNODVaSXQcReA9DjfghhoBUJXX8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099006)(18002099003)(22082099003)(6133799003)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r0XFHs81mfteDqi4BFNoxjlsNueccln1XjkKfSFyBJqye5l6k4dItEaMRzvm?=
 =?us-ascii?Q?c4jFhP35e73sMQA5Ro5E9FVeAlJmJ5TNeChl0CQe5YYoyGBw00ksoDx+mJvo?=
 =?us-ascii?Q?AET2ZvvnXR1M4EGTyo09inJvvFcVrxuFa+QzHqShExMSvEoIfpar3Z5t9HdB?=
 =?us-ascii?Q?tutB/Ctd+lYdS2NLzRgeXGWDj3/msJ4k6oVZZ7eNfwi7loA43NkfELoSf1+t?=
 =?us-ascii?Q?XRANMWbgpwcsY8aSinGbPrIvfQoRghOz89hlQKLgNu2+qxifz/Z+eV61uWVB?=
 =?us-ascii?Q?14jQrIhLHXbPYof04KpY6z6Z1eg4R1vwn9ysOr3WLILjPGgsT/ykXKSi8ER+?=
 =?us-ascii?Q?zCnlCSCM39+pMiBMDXf9QBobd8yKriwjuJ/EoCBnd4j13CZRMJMM3lJ4Gzk3?=
 =?us-ascii?Q?wNntsqilTUB7lUgKQOQ6+gyWdMpPy/Pj39tZ95WE1uPxnIcxSRao/emYR0Pk?=
 =?us-ascii?Q?DhkUyWU+Gt7SBR/Hm1RBXSn9/Aq3IP6b3y2jx+jkI1i/iN879ke5iEkBns3/?=
 =?us-ascii?Q?9Y+WOW/MskAW/LZH0XbBmWPoOW4inejGJ9/7Z1KqIGC4N0a4v650DFwGmF+U?=
 =?us-ascii?Q?KB/0w2xNVpZFLEjIVgnW5FzmLQZypdfghtVNOPRDN8gEV1rwenTG31+YKgaP?=
 =?us-ascii?Q?cchB+1nvCOkqqu1PGo0GO+C0PRo2yZpsqBk/pZlZtFKBfCArzvHaKsLvHBtc?=
 =?us-ascii?Q?RRX/4ZHVG2mya5a2PH7eZ9KZtxwsgikb7vr8nFhoCteHMyAb+sX7lOvWfJiO?=
 =?us-ascii?Q?y9yA83lekSeKCKkr9aMErCzg0sGKEmvPoTx+EFuz3+/HL9grX6bUAqqo1H/n?=
 =?us-ascii?Q?t3vnY+p8JaLEYx/stQdqGYBxb17AQjwsPexb9v4le/IKXoCVn56PwnZnqsiE?=
 =?us-ascii?Q?+gBi65EtC345eSKQ6SSkLlGiWWLKScc3AoZVbbU9VdcZOYnAo7I37n8Il9MT?=
 =?us-ascii?Q?oWllIJCbOaCrtPTlkSGNH5O2dIimdvyFDiU8v568kwJYQ+bEQ7xN4CMzuYXY?=
 =?us-ascii?Q?WERCJ8DrEHVOrXvwx6PUyyraycE/iisIcQGXcA78dN/vsdCy/aLHkj4b/HzP?=
 =?us-ascii?Q?mc8VgwECyTDyRMJ0gr1to5flLGg1dbj6sEO9tFtW67g2FaQ5HKlgMvBlJHqa?=
 =?us-ascii?Q?JTbsmCCQkpFXefWL/ZJgmIzNIhMJA4nG9aFld2y9o+h1iti2dSyWw1l1WVaa?=
 =?us-ascii?Q?HXleQoN+OgxfmmAYBN9zs0i2DeEb/5CX8TGDhYH3IHmGcl4X8AUBFIMFWzet?=
 =?us-ascii?Q?e1KUzv/FDb1brU9/IiS3/jg9AdlbVZEiTMYcQYItWI9at5VzXW+Fo7UYxqak?=
 =?us-ascii?Q?eVXNV7wHtRPmQsI5DbBcTGxurTGTv1V/ISFbwnaskl2p/5G07iSMbx6FZ9Ik?=
 =?us-ascii?Q?vrLTYSaV8mqsf4xvxdmRJSn1pPvANFihb5DoezJshU2TKVF5ZJF7U/zf6mBo?=
 =?us-ascii?Q?223EbJkrteJ7Y3e9QSYxudi40bpfifZt1RNNYsrtGvhY7w89NWygwH4qTXGi?=
 =?us-ascii?Q?ZkwGwVLb/tYSPwib0xs/yI3vhJe/iD5PheCIM8+W0uqXseFSdoZhWqB+/vXx?=
 =?us-ascii?Q?8UbolJHVr+ADKDiBiJO5ft+1gIpShUhM1rOhTcBhPn9hvVWztN4//squ3NGx?=
 =?us-ascii?Q?OrcL/raHK2954JfVqAZ2yBuATtWAZa3Xaz0nqQWuRmme8GvXqyuFbGGpgJZa?=
 =?us-ascii?Q?hDKDE5Pl7LaAISKxFgIxohWu/vZh4XZPUPCWOe19/raTQzZ1iHm9ATEqBQye?=
 =?us-ascii?Q?LGADBMoiyg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4913df85-93dd-48f0-fe32-08dec12cfa7c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 05:00:06.0768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZ+GcgQQCHDt1JAI8jVUCLvmCnoQTUX/MGDKWAvB321YOidmmwAqnY8AV5segEqT7XLj9fXWzpws09C/YgRiHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5788
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: j8rp597e3betdgoy1wyg8oaywj3bnik5
X-Rspamd-Queue-Id: 36165180006
X-HE-Tag: 1780462816-672303
X-HE-Meta: U2FsdGVkX1/Fr0o3HuRarCjyq4ohCc9wMaChg8dJVkiP+PlKWzyZPQZjn2LoLog+gPKco92Kr+sviBWk4vcK2x71Fjpe+LNTk3+qoAs5alk2lHQWSgnGg1ri5nzc84xmKnGRB8Htx1t0nVthm3JDBLOC01FCX6Sug2vHxG8O4e3MZ+zamNvB42gI9ldlUYoMFT74xfzSyVdw9PgdykA3SPreKcrn2qro65cPTBr+kU2+Jw92LVJoeDfmBjPCV6mIPMqsZV+cQ6x9MJMY0quHD8XI+SCozXhiHciounoyAcFPyNciOZhmaAkmWRM4951+ZHXTi+seJj7ifLvSo4aamYzS6Dz08Ia9TXKoBbbizDodniBeXPwPR3Und2fvdtOfUmVTvu5iPJk/ARY1tdHjL+s/Q87xVRQokeuOd+CcmbFPMdp1CNjAy1SqWae8B1Uc4fg1ljAthKxNP6+FPoOegD15eI45YFqYSrYDcJ2/EUXf7eOfPrecq0hc20mK/SnFpCHu0w1yWqH8wLIEU7qC/gsAV73aPlrk7/ew1QRKN4mdhUMBPz/nq94P2/aikNr6UkS+d7nkh8CFQvsBPC8BnZqTi9fIkFfnCc7DGCEcLHx49HsZkfY9YRA51yOPy0T/mqPe/hTCa97YFron0MtbgaSCmOttcj9FmCr4Whh5cXlCpAO+eWcx4kNZdVGkdglcQWxOfj9YezmR1huf59WobT3IE1InfmJyq4HuJgTsJZnyFOrB1WFW8FtN4Yvxlf+SSW0INN8kNz6c8DonIRwT/pbojw5OOmy/bQ83LXIR9AunUFX/BPX6VZrvGOxVyHW19EzYl20fHEkw+XZ/yJOw8oZaFFPENRGBq76Rr/38bjhmYMyDscz4djoK3jiRGONYmMmPJe22NWVfrzAhM1xl+5ufCTPMjZaSCaw0F5NO6LgvqOZoXbdt4Jj7mGu0ZUsktpouw8DKofFynSER30l
 WmVp7Nf2
 joT62YMFUD8WIG0i+wIheGz9yZiyuioWDDRe5GBnU55+7cj0I+AvyEVZKDUXeIb+rkkIC4TB1fdhHOTl5QTtZhzds58cZDW9KKnzfCAQb0Tt42Cc7CsoTkokRO6xXOYvHI0jN73kDemrPdgZbuWY6rqIZPYscrcNGST60RnnCfbIb8je9Pr3DFZ1CJn/AgGDnQCe6xb2+YWWCpo2dzEr0Iij/ovTzvGVaa2MU0N1E7ItqoChy/242fr/8KfyC8RtnoGjgJv6wf2IN9C0JQyBWRzS0vrgaAXAktq/GrHjG/Btnb0oJ8b0lp9PS4JTzYkbwxP4n+kEnDv7RxuRmiONSOZpIpZ3XhWOcvbH+04UgorkTU7WoDVVvN/qxQc1Npkb/LpUf8G0FX5wNiZKKWPTsY7sWOTTAxXpfkPnZtlNe1TW/59tQmi66VHn/Z1GWmd5P51ZEBpB9ZxzrxkMtGiLXICJjaIsmisYu4XfK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 09:57:48AM +0100, Gregory Price wrote:
> On Tue, Jun 02, 2026 at 12:16:50PM +1000, Balbir Singh wrote:
> > On Sun, May 24, 2026 at 09:50:06PM -0400, Gregory Price wrote:
> > > 
> > > I'm debating on whether to include OPS_MEMPOLICY in the initial version
> > > if only because it's not intuitive how it interacts with pagecache. That
> > > needs more time to bake.
> > >
> > 
> > It makes sense to look at it and then decide if it makes sense.
> >
> 
> I am thinking i will ship without any OPS flags at all for now and the
> have the introduction of ops as a separate series.
> 
> > > alloc_pages_node() is the kernel interface
> > 
> > I was think we wouldn't need explicit flags and that allocations would
> > happen from user space using __GFP_THISNODE to the node or via a nodemask
> > based on nodes of interest. Is there a reason to add this flag, a system
> > might have more than one source of N_MEMORY_PRIVATE?
> > 
> 
> There's a few things to unpack here.  I discussed this many times on
> list and at LSF, but to reiterate.
> 
> 1) __GFP_THISNODE is insufficient to enforce isolation and otherwise
>    not particularly useful.  Additionally, from userland, it's not
>    something you can actually set.

I was thinking mbind()/mempolicy() is how we get to it. It already
accepts a nodemask.

> 
>    for node in possible_nodes:
>        alloc_pages_node(private_node, __GFP_THISNODE)
> 
>    In fact it's the opposite semantic of what we want.
>    THISNODE says: "Do not fallback back to OTHER nodes".
> 

That's why we need to control the fallback nodes carefully for
N_MEMORY_PRIVATE

>    The semantic we want is "Do not allow allocations from private
>    nodes UNLESS we specifically request" (__GFP_PRIVATE).
> 
>    __GFP_THISNODE does not actually buy you anything here, AND it's
>    worse, in the scenario where a private node makes its way into the
>    preferred slot (via possible_nodes or some other nodemask), the
>    allocator cannot fall back to a node it can access.
> 
>    __GFP_THISNODE cannot be overloaded to do anything useful here.

Let me clarify, I meant to say, let's use a nodemask for allocation
and __GFP_THISNODE gets us to the node we desire, if that is the only
node. My earlier comment might not have been clear.

> 
> 2) We're trying not to expose *ANY* userland APIs for this, at all.
> 
>    The ultimate goal here should be one of two things:
> 
>    1) fd = open(/dev/xxx, ...);
>       mem = mmap(fd, ...);
>       mem[0] = 0xDEADBEEF; /* Fault device page into page table */
> 
>       In this case, the driver is responsible for doing the
>       alloc_pages_node() call.
> 
>    or
> 
>    2) mem = mmap(NULL, ..., ANON);
>       mbind(mem, ..., private_node);
>       mem[0] = 0xDEADBEEF; /* Fault device page into page table */
> 
>       in this case mempolicy.c is responsible for doing the
>       alloc_pages_node() call via the _mpol() alloc variants.
> 
> Addition OPT flags (reclaim, compaction, whatever), would
> (optionally) allow mm/ to operate on the device memory with, for
> example, mmu_notifier callbacks to tell the device to invalidate
> whatever it's caching about that page.
> 
> This would all be relatively transparent the userland, all userland
> "knows" is that it's getting memory from a device (/dev/xxx) or a
> node it's otherwise aware of hosting device memory somehow.
> 

Why not use mbind() API's? Do we want to gate allocation/privileges
via a /dev?

Balbir

