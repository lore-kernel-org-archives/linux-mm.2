Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34E1CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 14:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22EAD8E000C; Fri, 10 Oct 2025 10:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205D58E0003; Fri, 10 Oct 2025 10:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDAC8E000C; Fri, 10 Oct 2025 10:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED15B8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:35:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96B04586A4
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:35:34 +0000 (UTC)
X-FDA: 83982452988.22.1318F36
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010044.outbound.protection.outlook.com [52.101.201.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id A826C140014
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:35:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h6t+ksiH;
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.44 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760106931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTTtJU7fMX1RWQZnoC6TF86y6LHz5IBAxiBTOsRIV/0=;
	b=zBKRhr8+lUFoco1OCnF63VWMg3VQC1/3gPzE+kGAvDuNjq76EycNrE71RmuiU/rt2cOA/I
	uYn5xIahJhp65CJCZWErqZ674z2ljHWCbo6EHwbcd2Ct+CWPKO4UMkIOCEP3MocrlzxziZ
	NlaLH6zI5lhEIRDB5LgU7ZR4+oHAS6Q=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h6t+ksiH;
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.44 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760106931; a=rsa-sha256;
	cv=pass;
	b=PAm02XVxE4X0EJlSxOIVa4nBoklGFp3yOaeuc41NmmoAo6c9jMG6P6GOzbaAubsPB6ohTW
	mTa93NZxOBYGymvt1Xspm3M2RXQkGQGUfnaPdYFYWY2kg7CEZGfg/090B9OWnpyNqucvmZ
	KzQGX//Zl+xJiu0S2tQL51Vo/ULx0Ik=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MgNVsM5gbcPjyfzTbVGtT9qjo869kl9NcgScyg2GGdAKHUy5DPe955glQnBr72NkiWsQVweCYWS9YyTOVo4N8LI7GSprZyDifADwnFNvhQD2mGeXKVViFZAzoT6oZ9XOPAojZszPowy7WaL3X5VZrKCGEL3+1YqUYYBOHdEFLa2zD/oUxR77dK9hCl8PpdbqB8T7saD6O2jscS/+xwnKEZazRh4JerXLqeKPXFzIk8Wr1WwJ4hC/t9zQAIUUSYtJp3Ii7LK7bBFOwt2jtCxuDIw/5Jrg1lChFra6i4apMieDpZXmOEQKJyEV1V1y54ZIA6jPCHXSIX5w8YxIyd803A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTTtJU7fMX1RWQZnoC6TF86y6LHz5IBAxiBTOsRIV/0=;
 b=RvSfyyHRQB2+5RMNn5ERDgPmJg0PCzJNWvK7EjcnycpVtrZJVwjoPdOp/DC16NCvb00yHs7rsc5ASBpcA6k51otRGQgGvcfC2dLoXdM88nQgRJBnddXRbbLl1/y527Xi9V7Y2ZxHSuUvzZ8iyyGsYmGlRHKo6w5C44c7ExNT2m0g+0REWvI/M5k2btU7WG0A1YFf/PRCvi2v3/SBeLYF75EIcGWVfpwbHVVUr9+OwkuodHPm0mAlPEymF0y4ZqtsUDS/QMChQ4wGlf05mhKwn3+xv2yqsq4Oyor1osZ+egkIN6xdxtuwkH6/5wR0v5UbuiLo6SnZRyIYaKVbHHSMgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTTtJU7fMX1RWQZnoC6TF86y6LHz5IBAxiBTOsRIV/0=;
 b=h6t+ksiHAdKqR1Ddz+f2TZHe9QdnGpFKPzll/xgUgyxT4F0wAWqSD5K2s0ZZRZaVSf4/iS62E9IfESYmfo/pMlbswG3Ny0vxDvSjdtLxgorJ9DspA6sTI6e+hjWDT7BoZpW+ZJ918PiT3hNM0eD5TVt41tWYXxTLu5hORIruKl4bN5IUOkbdy5JHKFVWTVjc75zmhH9aqDIjRKiHK84oVxNV6HrtkDJbhmtBIjm+Xk+yJQVyfbQEhvX6tNd9txNvZwVSVLaubmCrr/5hp+1UR7LU95dV7g/9URzktqxeLT56j5k65H09iG2nARfJkOCIJPM+bDMoh5CM0GQC5tiCGQ==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DS0PR12MB7704.namprd12.prod.outlook.com (2603:10b6:8:138::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:35:27 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 14:35:27 +0000
Date: Fri, 10 Oct 2025 11:35:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com, hughd@google.com, chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
Message-ID: <20251010143526.GA3901471@nvidia.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
 <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com>
 <20251008193551.GA3839422@nvidia.com>
 <CA+CK2bDs1JsRCNFXkdUhdu5V-KMJXVTgETSHPvCtXKjkpD79Sw@mail.gmail.com>
 <20251009144822.GD3839422@nvidia.com>
 <CA+CK2bC_m5GRxCa1szw1v24Ssq8EnCWp4e985RJ5RRCdhztQWg@mail.gmail.com>
 <20251009173914.GA3899236@nvidia.com>
 <CA+CK2bBtrkdos6YmCatggS19rwWYBXXDLwiUWmUrs2+ye23cXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bBtrkdos6YmCatggS19rwWYBXXDLwiUWmUrs2+ye23cXA@mail.gmail.com>
X-ClientProxiedBy: BN0PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:408:e7::28) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DS0PR12MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ed0f520-fb4a-4f85-fd15-08de080a416d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzBLcXBzYWVoUWowN01lNVVORGFIdlNxOEZVSmgyUVpnMlEzR2c4TUd0VE9L?=
 =?utf-8?B?NitBUDI2MGFtREVWNndGZzZ1WTloVkVKSDZZWEVOcXdMd0JTNUgvL2dBNnFl?=
 =?utf-8?B?cGJzMnI3Y2RURlJMbFA0SHhuQ25qVUZHV09aekpQQ2lMcmF2VjhZWXdaY3Rq?=
 =?utf-8?B?OWlRV1lQeENlZFd5b1FsSUNyL09lTVZ2em9IZVllOWwzWU5VYkpkSEVPRkRh?=
 =?utf-8?B?akE0ZmxqSXdXQVlZTytCbU00SitxZ1EwNm4yYXpBeWVnc2NmTkVsa1hoc1B0?=
 =?utf-8?B?L1ljVDVBVmZLU0szaWY4cWltdmZTZTdmaGkzSURabm1Uci9OVVRUbUk3d2lt?=
 =?utf-8?B?anVsWm12ZGVHVjFhRk9NNU5URE96V3Jmc3k3RWs3TUQrejlrWGhadW8vS01s?=
 =?utf-8?B?bnpCNHFVbCswb05vWStjS1ZRTlkxdGRPd0JJT3cyclhzTzB1RHZMc0w4ZWla?=
 =?utf-8?B?YldaYmZ4T1JTaGxDRThFKzFuWHlFOVI2bUgyTEpLY2lrUlVQTHFFZTJhSDIz?=
 =?utf-8?B?dmNsWkFwMWphNHZzV2F5K3lsdDZQMnRGOUt1cGl2QmszUi9zUjg0Z0IzeW1q?=
 =?utf-8?B?QS9ROW5WaFZHZStvdWc1QklYS3Y1bzNkdWZUcUkrMWo3QkVwaDllVUhxeFVm?=
 =?utf-8?B?WGJ4V21MYWxrSTY1K2hYK24xWjlmTWRvYzA2Mm9nYlJiT0dBYVY3dXl3MVBF?=
 =?utf-8?B?ajNvbFJZb3ZURG52UzkrNUV5TDlCRmltczRWMFRyaXowWjNpeWRWSDhPc0ZW?=
 =?utf-8?B?dTlOTVl5K091UnJaYlQwYStYUVNIRmhGdUZVaVFjcDJUcXhGY1BvcDkxdWhK?=
 =?utf-8?B?TFBNL3krUmdrL1FpSW8vWnVNNEZXSnVrZktma1VYdmZwMFFGTXVhb2Z5dE4y?=
 =?utf-8?B?VVZOZFpGUGR5NGhtemRYQ1hNUW5ITkQ0N2YxL0IzV2JYYUJaVyszTFpSSTFl?=
 =?utf-8?B?NUd1NVAwa2ZzTVd6L29oM3hzK29uVVJPT251czVpTmNQajM1WmdkYVZqaHdz?=
 =?utf-8?B?UGtjMTA5cmZYOFYySHNVVHVVbms3ejZwUDR6SEhlM2src001TTRCZnhiYnZU?=
 =?utf-8?B?RlhhTFZjVW5UMWE0RFZOSkNOSW94K05RcHlZSDNOdnU2dG9XSEhOUmlxcTNB?=
 =?utf-8?B?TFhnR2VNM3ArT0pBdXhLS2lsY01OUGJHeHFpeFpnRTJBQ3d4RkE4M1JvTzJQ?=
 =?utf-8?B?eHBadnFjUzlxUitKdGJLZ3g4czFQOHM1djBjckUyVDVCazF5bXRENzlJTnNr?=
 =?utf-8?B?ejhiNVR6QnBrUlBscGo5OFZDTXp1cThCdGx2cHl2aXRMaFRnR0RobXZuckJI?=
 =?utf-8?B?MkEwYm9OdmFzNTRvREE1TWhpOEk3eHZHN3dKOTg5TzI4SkZEckt4Z3BGcEpn?=
 =?utf-8?B?MC9xbmk0Mll6M0liNTh1U1JXeE90N2lYRnFxZmxvM1JIRERxQlVpWWpZT0Vp?=
 =?utf-8?B?bHJLY0ZjRmVZNWFadzNUcGVic3FSZzdETFB0a05aazZ3aDh1aE9YKzZzUG1V?=
 =?utf-8?B?ZU9keTczdkhNK3NzVGdlazFrUGZ5MDA3dEU2c2cxK1NJVkNGMGlNeHduM0xN?=
 =?utf-8?B?Mk93OGNzV25uS3VXRm0xV1F0MUpOejV3ZUd2WlVleHhrOXoyaDVFQmVvZ3lz?=
 =?utf-8?B?VkQ3SStGelphVW0yOXd6RGMwZERhQk9vTWJ0VXZKZnliYmN2VUNxWXR5ZTFH?=
 =?utf-8?B?cmZ6LzVvUURrM3hkMkNpZEVLclNnVmlIcHhBeTlCZFJBWG9mQnhjYmJtQU9L?=
 =?utf-8?B?SUZQMVdjRSsrME5wdG5QeWlGQzg1MXd4RHJId0wyK3pyejViRENsSGg3WFJj?=
 =?utf-8?B?Z0xrTmNLc1M1UDMydDFXdi9WbG1DU3h6M0RVNWdETEp1dWl5QkFpc2QrNnJG?=
 =?utf-8?B?K2ZicG1tNk9obXVnN2U3WUtiSkNNei9HY3RZK29xTEdyYVhMM0ZCS1hvdlBS?=
 =?utf-8?Q?LZw6NPdOHO7LKpTvVYjnZsRtJ0IHNgKJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkdEeWhIMEgyMHlxbVYzUFRub2tTSzNqWVZMNytvaTdqVXMzNnQ3eWVaWURq?=
 =?utf-8?B?Z1BxRTBIMUlYaW5YeWpIdHhKb0hPL3lEZXhCZFNoZmVLVThGUkFzY3pWMnc4?=
 =?utf-8?B?ZHNiZ0h5R1lkNHRPZkVhZDZLOGFlU0dBaU9JQ1ZVQ29YUXk5MzF5RWZZZmRO?=
 =?utf-8?B?TVpJaTZHOWdLOXdkRS9XZHg5SkZPd2tWR2liVnhkajFXN3VraDFPakdEc1V5?=
 =?utf-8?B?Zy9jTTErYm1yRmN5ZjM4Z0d0V2tJckZRcm9GVVJJLzNzR2h4TWh0dnQ2MjJD?=
 =?utf-8?B?dzdJTGU1UnZidlBaeUtId25tWWdhL2NDWi9hS2o1azJvc2FQekVDNEZ2L2Nk?=
 =?utf-8?B?MG8ra1RaTVA0TmY1My9TRWg3RmFHUFNDUHRKSlhveUdmTG9MSW9zNmI0VlF0?=
 =?utf-8?B?bFR1RG1WYXdaRCs2Tlh6VG1NS1NzRWY2ajB4ZjdvaWxHdVZRM0Q2YldBM2hB?=
 =?utf-8?B?dFVrNE1zQ21DV21PODZBRG0za283NGx0QXU5R0xxZTFwcVZNN2VUZzhKK0dh?=
 =?utf-8?B?NE1UcStzL1dsT2w0aTdPdUdrNUZKUWoxQW4vV1FtR1RZbDdKU3RDbFloQnJK?=
 =?utf-8?B?ZEpiYzZtUzdlVlNmZVArdkJkeGJCSHVjdG1oR2RoTitjbHBLNEV6SzBoQlhK?=
 =?utf-8?B?dzZqUGZOeVg5R1hmdXpKVy9sTUtjUmp0aWNCR2xvK2NmbklUNXFMSHg2QW9q?=
 =?utf-8?B?TThsVHFPZ1ZtTC9rNWN2UWJzS0N6Y0R5RHQ1YVg3UnJGMTlQSm1leE9zdm5u?=
 =?utf-8?B?cU9VUC9BQnAyNXNrWER0YVVQYXhsYVRSNWx0V0ZUd21WbDRHSDV6cm9CL2lH?=
 =?utf-8?B?ay8wZVpPVXc5dFI5NzE5b0RxaXhMSlZPeVdWT1RodmNtL0ZsR04zdVRHRXpl?=
 =?utf-8?B?UmNyYTBCbnlGMS82VGxTbmZrZWhrT0R4WkowOVhlaDBtOXNkSlVrTmVVSUpO?=
 =?utf-8?B?UmVHZ0hpRDN1b1pqOWtZczJ1V3YxcWdkU1Q5Ynhqc0lRdHNkdGlnVzdIZU9L?=
 =?utf-8?B?ZVlkQ2VXeDFEellCMnBORFo3K3FYbDRqTkRPUXFkZUR6M0JjdElBb3g5YWVq?=
 =?utf-8?B?RXFvYzNrbHJBMEk3S0Z6TCszTjIwWk1FbVp2SEN3QVZmcm1NZk9Tc3JnYlRS?=
 =?utf-8?B?U1Z6VlR6Z0NsdUF3c2FzR0JZU1hsUnhBQ2lZTEw0M2trTk15YnlvS0t2Ny9Z?=
 =?utf-8?B?V1BQSEptYkt5b0dYSS9PSkxIR2p4VkFYRURudWpYamhQRkt1UVhSODMzTlk2?=
 =?utf-8?B?a2x1MVdLU1R3R3pnU01xTVFMMlVucE5VRVJoRUlTWEN1N1I2ZTQzWlQwYXQ1?=
 =?utf-8?B?OGxUOHBoeFYvcmsyQlMxUkNyQWdZeGtESmRTa0xicEx5UXc1aHhqRU03UmtX?=
 =?utf-8?B?elZRT2orUTFsL2VwTFJDaEZHcXFIUEMvWmN4QlZlTGxOY2k2KzQ1S3pHYzFl?=
 =?utf-8?B?QVNkOVVCQXcvcVJSblBBelhYOEhxU24zVktCclk1eVkvbzFyWElicVVaNXJQ?=
 =?utf-8?B?RTVtZ25JS0I5dU5uYUovaUo3alJlZ0FRUXphbTBaT1AzdkxMRUZjSGpib1F1?=
 =?utf-8?B?cnVMNWltK09ZZmxhamt0TlgzTTQyektPSlpNcHZEdVZGVDEraFhJYjcxTERz?=
 =?utf-8?B?dzJ5b3ZrcXA4RGQ2ZUhWMnQ2dDVnejZOcnV0bnFITFNiV3h6VGY2Q3lqYnEz?=
 =?utf-8?B?c01XcHRyQVRyK2h4dmpwcFRHT0szc09SdS9YcHBkYkZEMm1wR3FHZXBZdUpw?=
 =?utf-8?B?ZU1pQ0s2V2QrRVZhTXVrNzhvYkc4cWFzVUhoM2lJWVpMdkpRUjZrVFplNlhZ?=
 =?utf-8?B?NUU1cEJQTk1IbHNBZjE0NndWcFpaL3ZXZ2JBWEJ1bmU5TG5JYjVXVWgwT3Zx?=
 =?utf-8?B?bU5ReUs3VFJBUWRNb2hLSnNiK0lrS1BWdWxCUXpkemY0ZXFaOUtEdEtTNnJa?=
 =?utf-8?B?MXpjYXdMZTM4dFhySzFIMWNCVkRkeWJ4MzAvM2dvc3k2am1NL01HdWcydUp4?=
 =?utf-8?B?clN6ZHpFbnUvdnJXNldhT2Q4dm92OGNiNUFLalowUENvYjVYa0MzY1lQYito?=
 =?utf-8?B?T1MwTVM4eGxHdXo5TmYxVU9vY01zL2FCclhld1BlYmkwUGJEUkJVeWJLQlpm?=
 =?utf-8?Q?ugxw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed0f520-fb4a-4f85-fd15-08de080a416d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:35:27.5756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHyjW/cVAhm2akO2wC7v6yLPNmJMcp45oj7b9nZQyDk8KfZB0oVOrRvUivPBgDEC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7704
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A826C140014
X-Stat-Signature: 6hicwxe9e7js8rdf1jy8wacc1afnp5yf
X-Rspam-User: 
X-HE-Tag: 1760106931-186086
X-HE-Meta: U2FsdGVkX18sJLdkM0IpLkl2gNYS5Uz9ic52AihpWBRIu9K3gFJj1WfOXuSGeKWKpxGBjrF9Vh1D3vBjEAOkroBRdWZDXeskjrHwHduImnd/kwxJ4Gzwhd9+tYtuKSYJb1RiyfUO22pxE740sqNhEL1acwE0HWySXdJX4N3rPqBm4qVI30NB137OVQFvrS4QJi61bRCPMjEayMJWpkeyQ+M38wgDA0exu+NRP7e6aMvZYEjkVv4SQWDTXkerSRqUUzQ/ORU6lu+U9GzDrkuKV6cXqzurTSAU6TW7nmCNQ/e6Xt6bIlNPNZ6X/g5Dy4UJKFqnK/FGMsHnvPrK+AHBUGYNCK8vvXdWbtJ5MRFrGXCP9mMNteWvEkjHrfnkxw0PvSEF7I/SN1UbUARrSdEI32/cyrRSKwFctbPlRi6GSWJK1R/JFF3H7fBrzP1qO47ysSbfvv24P4EdjRlk2sj0M7bcx1Lie/HQktGlwZe58dPI5Ke70p/XsfnKOGojTAHOYv8rB24L6bwhRbfKMvQ5e2ZPb8uHIC68muAG6nVQqDRYZF0hQznm2G4/PUGuxcCKeSRKlcoW2ZLnWkBrYso5hAZGsFprAij0TV92lzwZzIWPrbrA7827f3dCg2o1fYpdNMHUpHa200g420RZlTbs6HCKaVuoh2HfV0Ngq8ioIXLokLbdtaZsgzOPQ4HayNtkKMHI8BGxllmH/FBgFMV15pv+Qj/hTNre+zrNLTs83tyRRBdZ2Ne01MhzzcOFyvK/LBecDhIH8E/9waC4Mer4R08shV/Of+aKho/P5iKEAGBNTEDIYpAXHr8tBGk/vkng8ucM+9tU7c+Z0lS+0Y5BGVHvIO9zVvmrzrOLFpz4vv6/vSVnN0cf34j55kWjcYTMK6crpup1z2YZtU3O+wU1PdwcX2l2xb/QQb9HsvoNSzUD9Rkfrf/gtIkLmtluumUqdDGGO56Et2qw6tclebP
 NSZbwclY
 r6mnPBmS4zhDSNaJKdh4Lblsar3nfKuEi3pFz+2SlulsK6Mh04n+73/0Xr73B7nTB7MdHqpUu27aP0DS2pSYKjg6Ui5LjCvnPE2S0zHkzvbyq0siZ1E17SFNCeVJwc4df7M3oZjqeu2B47BoSopw66EnBjO2u0Ynm8GKN+e+XqKlxXqJ155YbreLihztdaiONzNv4hTCdmeGY4Gy2akiDLl5XZ2ukLJpNco+jY7dAlnlZOICeulsc5o31XnQIAkMm/rIKb+y8uYGK4zSfjqm2ytEyxotBG9qg8wOR8Nr7XWMshu4naIXmGtxtJk0OGcx3tWM7Zj9goln6+zxEMvRjMfrzr3LEc0w6Dr8po6nSeJJz5sWJOK4EMj2arHSguNr08NtyYCzqgdlOEYvfIkoi69E9FkbPZi/tctmq82l5qCRrP0DcNy6zkWNzkfvAZzVRIMrdtlRqV8YFZmeyYSRDOxqegiCBUi/OB0aoK1fwvrPZIdw7FvVKyWRqlQ/KpotSId95PfaDrtflGy2l37Ka7yhMbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 02:37:44PM -0400, Pasha Tatashin wrote:
> On Thu, Oct 9, 2025 at 1:39 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Oct 09, 2025 at 11:01:25AM -0400, Pasha Tatashin wrote:
> > > In this case we can enforce strict
> > > ordering during retrieval. If "struct file" can be retrieved by
> > > anything within the kernel, then that could be any kernel process
> > > during boot, meaning that charging is not going to be properly applied
> > > when kernel allocations are performed.
> >
> > Ugh, yeah, OK that's irritating and might burn us, but we did decide
> > on that strategy.
> >
> > > > I would argue it should always cause a preservation...
> > > >
> > > > But this is still backwards, what we need is something like
> > > >
> > > > liveupdate_preserve_file(session, file, &token);
> > > > my_preserve_blob.file_token = token
> > >
> > > We cannot do that, the user should have already preserved that file
> > > and provided us with a token to use, if that file was not preserved by
> > > the user it is a bug. With this proposal, we would have to generate a
> > > token, and it was argued that the kernel should not do that.
> >
> > The token is the label used as ABI across the kexec. Each entity doing
> > a serialization can operate it's labels however it needs.
> >
> > Here I am suggeting that when a kernel entity goes to record a struct
> > file in a kernel ABI structure it can get a kernel generated token for
> > it.
> 
> Sure, we can consider allowing the kernel to preserve dependent FDs
> automatically in the future, but is there a compelling use case that
> requires it right now?

Right now for the three prototype series.. Hmm, yes, I think we can
avoid implementing this.

In the future I suspect iommufd will need to restore the KVM fd since
stuff in the KVM sometimes becomes entangled with the iommu in some
cases on some arches.

The issue here is not order, it is straight up 'what value does
iommufd write to it's kexec ABI struct to refer to the KVM fd'.

Jason

