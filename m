Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA553CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F486B0005; Wed, 10 Jun 2026 19:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117BD6B0088; Wed, 10 Jun 2026 19:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006D36B008C; Wed, 10 Jun 2026 19:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E47C26B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:54:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E0E61C27F5
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:54:08 +0000 (UTC)
X-FDA: 84865658976.04.6DC14C5
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by imf15.hostedemail.com (Postfix) with ESMTP id ABDB7A0006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:54:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rXbZY0Ox;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781135645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEKl4kWwl3uNfvcbVzMgjfI3E3Ljfhc1HBtnZNu1OUg=;
	b=EU9zQa4AWkuTD7/nhrH0Ysp6BrGelHn9tPLHeIRA+gM92YfOSPbf/7f7sWZcxWMXHQNjPI
	HDTZ5Dp6j+Nhxe80NYQ/BDDhkD1l+4UJG4iKW9FCPsqreFHTapiJVbUu0iTQ6L+Qyo7w68
	4LgEIDT4dtHa/TXnBUn9Uubkx3hPuvU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rXbZY0Ox;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781135645;
	b=KUqsvZTxiqDKEootB8ErgzrPb6yOhx31kfzPXhCjO16mg48maLIdEUVtkEX+kPSKe8rNfr
	TgknezRCVqxvUvVGqKfyTPF7rImIkEtpOo5j90VSYoaOLeSW2NLTNeBc3Y/q5sqhzRpEvH
	aF7Wje42kdQyNkFLG8mf9Pi4yD9bJ44=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2oCas9l6xj2uw83dyOIK9Coj4OCnkFDSnfOXMHhxDAmewl6EyqBgKmH/7KzlQ99sve8l3Nv4QEghqWd/3H+N43RB00HtBUZJPNp/yrSjBJffmJF+Mk3HzCxbYv22NgL5BoXrEYIPRWg6dl96Bk+KThWuPtKuC5LaDsu39sFcsb2QZYi8/EZkk6+ZAGFgx8YhAi0p2/dHBvrJwt5XZYZw+GoC4BOkcAe/W+xwGgk7cjKVHEmirHSmucseHL51aLt5+ibYDhKrU328n6yyS3NtCSls0ZxzQS6fxDxxyVO1ml8+oLH//xZ52VpLdEDLv4DxP0I7+cDJOzBt2eYoqRO/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEKl4kWwl3uNfvcbVzMgjfI3E3Ljfhc1HBtnZNu1OUg=;
 b=uA8mspHIUzLUhDYhibL3xwGKDV5W6oF1Eq5XleSVPvOCI9V30PmJGWaVwHoyFlv32ZamKeDdWZ86nBG9oGRaWOsB9VKKz3c7axUSSvZDBR8vmoc/CM+ueHQBv+fKSsPz8wfSuk61EGocVw6/uAMbwdL2reiZMMUFot0vBVXZsxOMER2ErnswYrmi0N8NaEXtArLyCUOo2TM4MdPy6LUhY9A+lW0zjeWFBAb5ZWuDX324O8tvwTP62VQDJFqTF7K3DCSTmfkmB7SIyvuGKP7WfVxULuE+RJx3FsPGXsFVb4wG4OeeemYpQGRTKLCM+OFpFE9YY65HL6a9ab97aNONkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEKl4kWwl3uNfvcbVzMgjfI3E3Ljfhc1HBtnZNu1OUg=;
 b=rXbZY0OxfCkyRWR9s2x1Z8juH4XAS2BHACLSk8cfO+ejFLi5jOoorhkqgmDHm1D33oaTo9kA6egHUofF89XBHHb9Dnt7mgPbfUhbwDcRSizyMmDShcUtDcVqeHvrFvJDK9hmEqSGlwg8gIxeOrpky8cUMyrRlQqWmR/lH5PUkBAzQYke6Ps82GbwTrlXV8exYA01zANZ83MhWY7oG/QZ77y+GRCBxTch89j+TperwtytxFFI5vGDZ4HMwkBpYm9c2HawmoWYIQ6UfLXynFsecLUui51OirO0M3H9XNALhrBsrocPKc3yKrpISacJM9+oEXyKwS9EEhe/93LJpGs/FQ==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by PH7PR12MB6466.namprd12.prod.outlook.com (2603:10b6:510:1f6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Wed, 10 Jun
 2026 23:53:56 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%5]) with mapi id 15.21.0092.016; Wed, 10 Jun 2026
 23:53:56 +0000
Date: Thu, 11 Jun 2026 09:53:49 +1000
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
Message-ID: <ain4uajELdHbxjlO@parvat>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: MEWPR01CA0308.ausprd01.prod.outlook.com
 (2603:10c6:220:1d8::20) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|PH7PR12MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: eb01e513-cf0c-447a-ed0d-08dec74b87b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|22082099003|18002099003|56012099006|11063799006|4143699003|3023799007;
X-Microsoft-Antispam-Message-Info:
	hD7g1lAGymA5aqdmpQAJ6wMhqU5+t7nSwVDkqlpZTcZwnuCqk6iHAGiZZ38FTfH5ms076f6i+upCVT9hO+u+3KGl6xICjp54jlTmati1i/Cx3GV6MemAZguVbI6Q6lKhimgRzSGoFylPPYajPvwgbWRuLzWgItOjvYcj6lg18ZW3xuLVGsss0G4LBPUarJiHg8JgQFKHdkEkoeYr3Jkae70wHDLrsEC+PKYbcXHVdb7gIKaI1sgkTuu2FE4mLaR+FM71G4u26uBEfm1B8+rIFJZLuzigoLOmeCBrogVgA0GbivZHBPiQnnO0jNk8QUQgiLKgVY7qhYNGG0nXTvy9sBJDq+ps8J4u/YyPDQQvAOTsOcgBGj94kVJk5O0a1AsFWjt/3zBSrO2lwYGcMKjrqVxKDpSdUkxCvUqK/FV0L5St/uIDLnG6tNZXszK/7umwiuEB9Rhd7QRGjOvzF8sdIwbAO1D+jxpOe9WamV6H//31vQ9Q4DbHdhyNP2Mu31Lh5fQVre/HM/wjemH83DYRZ4eLcMFE4HcF2/7G0TlvR+exXmwofSPlanaZTfMLONXV9C8Kj+YYvXnUXRkYxfdPUXNoMTC996RmgeMFoanHQ2iowT89JtQ5fR+W2jzEeHu1OTYGYaKDSqI0MfntQ5fE5ArsdG0VNJIzr+q93D0pcffNxMPfjFJxdCvlvdlZy2NC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?29vodFp0TWGmfRMN7RvZJZ9lAPHvWyNyqr4YF8I8o9jU6SHVomtVmeZ8fZfJ?=
 =?us-ascii?Q?BP+r04wOsMG5u7G3VfSH2JkAtdzTF3Bc0ySh3KfalLCoRzeSEYRSSMQCFr6D?=
 =?us-ascii?Q?NRv8uUDAjIUh7j9UJVSPII4oadzmcNaHmIqB2scY0JF76XvI/4d2QeLv0aQi?=
 =?us-ascii?Q?5sFYNClARHMo9W5fvqcN0QLQoADnkZfSt4xUjjd4L9DNhseEmAJiVvqRGmC9?=
 =?us-ascii?Q?18xuUS3FGyiOuLnlXaceifkJe/wUFeZuNHnE+plh7Ifc2WU5EhDwQa57lv+b?=
 =?us-ascii?Q?HWdGDjUyZXOlLiWy7Whywag/OurSvMhFlEY8CPyD0ccJp4MrN0KKtgSX69dW?=
 =?us-ascii?Q?/pwEdK5oAWnf+KabCaMXuCzhl8Ne2sYNFnnpuoJd95hCG5ZzLTuE1/KLzzFM?=
 =?us-ascii?Q?a81eFD3bpTA3kadIcwGnuoRud1SUNFU0X+NMRzmce6x68VrkTplN02GllYwm?=
 =?us-ascii?Q?AzUQZwZ7pCN+lCTidspnkqIFh53t3l9QFyzuTpy12Z7dOEZNjv0mji+o82rl?=
 =?us-ascii?Q?2JtRLSMuWB3HzuTX1QVc5Z67kAoSWXTRB648PwId6XjdJ5KhYrzVS7mBM0kt?=
 =?us-ascii?Q?56ztsLfEUZsuJDeJCBciXTbhfSN0wxSR7PW0WQxPpsy/+EQuT3WuMTAaspd7?=
 =?us-ascii?Q?WFbgi2u3nM/w7hBSKGQaBuo6YbRpzMVhYOdl7Ss1hYjE1AhYNXcsMPSEq6Xe?=
 =?us-ascii?Q?tyHZa5OVem1x9uRpy6Vcooae2OXoSpfPoTOxG2jWJ4xSErJYuIg9/kuZmErx?=
 =?us-ascii?Q?PY9sA3CIX/tU4tjCUtv0SxVb3WXIu0UreKL6cb30ekyH+HoDAQg9CHAi82OH?=
 =?us-ascii?Q?U5Ti4v0IY22rzDbPFE4fFhvp/ni0ZafwPHRAoC2iMWUVoEzdO5YfUdr2LmeX?=
 =?us-ascii?Q?AP6HKSOLNBzgJMwR9g80Qc8mvL71VhEbRcpAJ2SJ/b/4Q99Ua4g539Av+r3C?=
 =?us-ascii?Q?8fxCQ+lQMH+SouC4Nqnp1SwzmXwFjW0m68+IQG5l6/oo2rKhrOO5XwOHOkTr?=
 =?us-ascii?Q?EA4P9wIGS6QBmDij92sOza+S+Y7tNT2tXGm4tW42dvHCmkcw1sBFaEfUjZr5?=
 =?us-ascii?Q?pLWSPuDzb+NPmJWcomgGgbALvwvUXPPLOzwBD7oWu31jIZVzpUA42J+Z7+B1?=
 =?us-ascii?Q?QH1YU1KC248jliECa7Ww0dbdqkxT5MYqEcj4O5T9XIR6BfCUwroNmXx5ooc7?=
 =?us-ascii?Q?22pQr4ZXBKyHUP9AbSAi8qNMZQIKp16QRhhhnPB+pHuTSeNnRlXXptlQBG2c?=
 =?us-ascii?Q?NZ1hl3eCfrhfikQI1Ov6KuB1LwMJk5bxGI6DOMxJuFQCLyX3i/eSM6iL8e3U?=
 =?us-ascii?Q?62TYBwrsblUfOLy14P6Uf65nAKgDxFHDp7yZCIA/E9ucMe88wZffLvUrMFSX?=
 =?us-ascii?Q?x3N41HIQn3UzfHl6CUeSI6OkNO1IemeC6YKoOAoDKmtbCM36q5sqNVlhSj06?=
 =?us-ascii?Q?kocWy0d3CQhFONa5CcDF4yM/0LJ3mzjmgEj2vYUFsOKSFctBxXjfIO8dTFgK?=
 =?us-ascii?Q?r/3wBKIW03rVobRrsT4xdeqw5IVk9hAowUgCcNJDGyEUERdISbB7u4rTeIjk?=
 =?us-ascii?Q?nSE2aGcqhD3WqyE/wwYnquycCdvUJEF1BK7KTnpBYbt++scIr/sxFzvofmvT?=
 =?us-ascii?Q?f24UdJfqvmBNwsSP3sqHEoSyfv0sc0mbXtCXqpPZUyGyrbkhdgJjM26TkiBp?=
 =?us-ascii?Q?DkWbDQFyNK4xz9TpdC+gWq1rizLqLefz0XG5fkW26p7yVJA4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb01e513-cf0c-447a-ed0d-08dec74b87b5
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 23:53:56.4946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QoA7tcJPRAw+fqtWfIZ4dj35trdfAWVgLP0giHXyPE6ySHfrFwRGILqU2K1zo5IvQe7TidkFn//6YEvjyPwhWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6466
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ABDB7A0006
X-Stat-Signature: hpeu9etq57sheqkoji6ax95x1fzkdsty
X-Rspam-User: 
X-HE-Tag: 1781135645-349501
X-HE-Meta: U2FsdGVkX19tjMAltkdCUxUM+53pshvUKjjZw7TMf5rVTzqSLM9vW/2QCFWoGbomSzfa/D6YxYRJp+PcMLhe01g6eXLNj7zdIPZ88+s17VmChjLpEjrL20ubLnjrUCTfBwSb3qbyXBwckxHGdm+tfkkPwEY8iTLwVBUwsyw3EQ/TOIWWJs/KqBlc6uB60RPmVQyRDfpuiNULjAgoXFUHEgsTs8d0WJn+56ocY9MBDMq/7ol5BKp1Ip51jnCTzG4zarkDwhakFmADj5XgQdVBsdFDirA1iPFm06bjXa0NrDxTg6HBRo0rMk72tXzgR097+HZwjNOLFjo5nA385wcE+bWAc5pVWgUnxJCfJfvAxFoGwRkNoC1u/DeZELS8pKfm9eIgUgR9MReZW4YtlaT6CY/HvWXWAyYwsDDMlpVXwQNol8N7WmoGeWpdFWKXyxaSVCJndO+BA2/M/ghIb4akpBBdtW7ezR37Kiet+zc+q1Pz8HUDRSibuxjsYYLQhbT4UsWsN2t9fBPx/q2pTQnS0Vkqik/g3n5akiHqq/ZHUEphsJKGEnUo1EUHvhUknubw12pG8V41LFXQQnJtU1JFPyJ73mHUU5djPpkWufZf24uK40h2kSMhK6f/peEWaP5oNuycMcTTQDj0mOmh3m93Tx3PGWMkP0K35ptkvJ9OwFxviGlOg3vFcZBvN5fvjIIE+7ORH/XGV2oSGz+MAwvuc8boJYPHuUdWzq0xyx3HUdSvudjZkg5CG17XMM24ygU5PGufjK5ZRtHlUVBHiQV81XGTO02zUoPa7+5DGZHKLaX2QMEOhDhcq4rRZzrr1dRqk93y5qgMBuCee/TwdFSrfqV+YuHDd313RDtncmZsfsUpxQfZ3Ji11Hkh/yMxfNalmSYSSZqxMZtpQ3QD/82V+gvXeHMnF62Ur9s97XcgF9z5XgnnyfyJ2v/b8VquLG7hnHqT/MFF+2JxS+Hhc7N
 sFA/cPhG
 RosKeo/9gpvmEdU3G8kaS36aWReLc+nd5wsRbpcZg9t2wusqdoLvis5mMxVtYal4SSe2Chmli8YvdVHRUIWDaY1Tvy3r70051M7Iyuq3Su1o+dvJVtTsOPSfVAOUEFqU2H4RvfGW1yAAbBjTELn34u8uRNIUbzqwKiuSQ9bdcBNrGuvNt1gzPZJoLpJgZKkmzjahbjPFi1yzi7XP9aCZDYAEF+xtGyiAjL4aODyfsdXgBlpXjCJjnjMuwTDI5ayVl2IhleqoQ2gv1VHPamgysQL88SO0XADcHX+HMQoxG3tqc/nDtg0MvV+nRg55uMAFVmm9wtaqfNirTTKCnF+gWTkCRpr5dtUM4wAdb94qdJHIlz9JBPXHuxfyC3CoNYFlR7AstzXuO1sLbwrQJxiWLQ9Ofw9nWl+cpySzqbslRu+4db+dG4adCA/i0UMB9u1RKXfK06GUeniMAMExcpu3EJb9EX0Po9NliLDvn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 06:41:57AM -0400, Gregory Price wrote:
> On Wed, Jun 03, 2026 at 03:00:01PM +1000, Balbir Singh wrote:
> > > 
> > >    __GFP_THISNODE cannot be overloaded to do anything useful here.
> > 
> > Let me clarify, I meant to say, let's use a nodemask for allocation
> > and __GFP_THISNODE gets us to the node we desire, if that is the only
> > node. My earlier comment might not have been clear.
> > 
> 
> I've been tested an stripped back patch set where I drop all FALLBACK
> entries for private nodes (including for itself) and only keep the
> NOFALLBACK entry for private nodes.
> 
> This effectively isolates the nodes for any allocation without
> __GFP_THISNODE.
> 
> This also precludes these nodes from ever using non-mbind mempolicies,
> which I think is a completely reasonable compromise and something I was
> already expecting we would do.
> 
> Notably: slub.c injects __GFP_THISNODE internally on behalf of kmalloc,
> which causes spillage into private nodes because slub allows private
> nodes in its mask.  I think this is fixable.
> 

Agreed.

> I have to inspect some other __GFP_THISNODE users (hugetlb, some arch
> code, etc), but it seems like fully dropping the FALLBACK entries and
> requiring __GFP_THISNODE might be sufficient.
>
> ~Gregory

That's good progress, thanks for the update!

Balbir

