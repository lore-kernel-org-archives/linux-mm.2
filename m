Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D49D715D1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 08:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6FF6B0595; Sat, 24 Jan 2026 03:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF686B0596; Sat, 24 Jan 2026 03:54:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A74C6B0597; Sat, 24 Jan 2026 03:54:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 810926B0595
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 03:54:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 133151DFFD7
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 08:54:55 +0000 (UTC)
X-FDA: 84366247350.26.F920B14
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC5301C0007
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 08:54:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kgSrgz1a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K+TIIK43;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769244891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nc7jkEd3fVbmtGcucjvsqe2RLK3FR0P6eYrQbitu12U=;
	b=VV1iTosc0nIYEWBnmhBCQ+yu1KeHqZDrE/sY1ahIW3ayWsaQWQLcX5lEwO4rihHVZJQOeR
	Rqn3BJ0kk26oN0xA9VVTUaHZ7Gl8z6ZLc64I/t2DROeKKHTBUFLrA9LkCd+g3aZMXljWC3
	PfMcJEVrEd27t+WiwCGq+cG6ufcIB6o=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kgSrgz1a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K+TIIK43;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769244891; a=rsa-sha256;
	cv=pass;
	b=Tld3q7bbmb/xqloA8itRvKjwP5zBY+6QZP0jUFl79L7trhPJ9h+rgH9wvbApHKmek8YMa8
	5/UT4ywvyOAHu4irdsdreoDqcNZGEMi1Z6UZpsTfhbO4wa530+IxdNOFfp9Ofi/TkYLhtl
	IMZGQvhIKmstMWREpI4zvK5CvYPgncc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O7svIm794009;
	Sat, 24 Jan 2026 08:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nc7jkEd3fVbmtGcucj
	vsqe2RLK3FR0P6eYrQbitu12U=; b=kgSrgz1awQYg2CQgJDDjfKGXwfnr7A/Q55
	v7896YDcHAmiK/Jp71IMetCFhEGR7PFTjTtw1CEbLffKKxO7c7gwBii5PKe4lYGY
	ckixNVl8iDv5RzTI5ByeTaZ8BVMcL4qnTARg4UGFKAfg1cSp0O5gfOw05/SDxAhQ
	L/AEOLrRcEANbIPHRyzROiYjZmdN2FlZO+8sGXMF0csKuMWJ05V7Nt16WsZnnhjv
	WxkRFxND5FJZ9L+29JKUdq7V74d5yZYMqQmq+M4bv+VSOt6GMBoQcMQ3lkPqLjVL
	vO8ku/nMWJCDh3h+ivsC59NigAmz2x+px52yx8GUIReBym8SnA5w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmv2r521-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 08:54:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O8MXEQ033462;
	Sat, 24 Jan 2026 08:54:38 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011040.outbound.protection.outlook.com [52.101.52.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh69mnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 08:54:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YA0WzD50JOhX6N17TNE8gDhQq1R2aabntGSAWL7MAUdM3JA2KtHXrmvp0F0/Q/b7iK1+BVZQ+Qp9uIcyMntS68+37MJqQuqTSv6vGh6pzMYcaQ+GBUoZc+/Tyd60WgIQ7DlDu8L23nMZXDoK3oaruun1sQys/Mkh9Bt0xUTXqbkwqhpTiZHCGEn+G+LDoj7q+8UgkO4Iagtw8Epx64TUsf2IoFxNBgveSMMWpN7BaMkmIzMM+XFlFSfykfJIlZ7jJAXlLfASXQ2p6+xODyht2OKRKR1FWZCCUXl6mAR1Icq6HQmBMefl3pFU+Ni6QOIV4rzazNjjiD43+rXflhjdXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nc7jkEd3fVbmtGcucjvsqe2RLK3FR0P6eYrQbitu12U=;
 b=hd4zPnMD78cLCx4F8Y4337Dl7ykQxG3WFMEOaoPrswXRQETX5P612ya5QdvznR1ejWT1obXHMLZe0eQM8ZxMieyqdeu/9rDCtqYSXK6gIE1/cSBuJkY1claLv5W83Au3tmArt2ubLCBWt3ArCWQa921smHiQgkHeYxA0V356mi9bzwzucKDHCZ60Hlv19MX/fzK4F/GFQMJiyGgd3xwg8Xwf+ROKiU5kWhzKS/jmtO2GkZw9jevQWY2Dc+vNrdKtOkrxAcmoDh8+kRHdC8lnEDQot81La1ANrQx1U4+iloUUQxld5finne1eRMQ2nqEWceBp2gFnWXkKhZVoKXA2SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nc7jkEd3fVbmtGcucjvsqe2RLK3FR0P6eYrQbitu12U=;
 b=K+TIIK43Pbxz5vyplGYgNwLjXyR4qXmAnq74wnKY+iwTRurTYgluISPm7VHAjPR673etCXqyxj5CxCIj8gMMJBeDgR8hAs8Xxh4C7xby82SXbr3ehDmIX7V7Jbzj+RJfLjecfx3i6yIEA0LoZaE7U/v/Fip3KdaB/2m0pRqmHZA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS4PPF376CF97B3.namprd10.prod.outlook.com (2603:10b6:f:fc00::d13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 08:54:35 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sat, 24 Jan 2026
 08:54:35 +0000
Date: Sat, 24 Jan 2026 08:54:35 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
Message-ID: <023e56e5-1c2e-4482-91f6-32765cca4bda@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEULwMTxAzxUdzfpHe2=+umXL6HFMvydkqW=tP8mB2ewg@mail.gmail.com>
 <c7c8158d-e360-4a29-9e48-f2b45b9ca147@lucifer.local>
 <CAJuCfpFbsAHr76ZfUEaRLzdxQMDjPEP+bsLNC35X9t53G_uqAg@mail.gmail.com>
 <c4d64bde-831d-4f3e-9b92-68c1beb70599@lucifer.local>
 <CAJuCfpE3D8XyR5wy+Zzq7TX5am=q3SrevarJaf6Z7-k-9CkmkA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpE3D8XyR5wy+Zzq7TX5am=q3SrevarJaf6Z7-k-9CkmkA@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0318.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS4PPF376CF97B3:EE_
X-MS-Office365-Filtering-Correlation-Id: 256809fa-f21b-48b5-e235-08de5b2632a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cIcDTn5HlQ8AooUgiQI3JfLLXuK+mVG1D4TUCIsamdevdu0FvGe0nCI9ulq5?=
 =?us-ascii?Q?Zu0mIjShKM4T212gu+nOJooHAkcphZNHsO3zV+avZdPKWsi0oGnLi+pGsR7H?=
 =?us-ascii?Q?NcDGtvwUZ64YnbdlyWet5X50QSRTSc50jXmQrzCMDCVqmKx8+t1mrbA6fxi+?=
 =?us-ascii?Q?f4b+KAwXEJFPWsgiM+xkmsLOnXd/x6SHJfED5E2vijWA+MD6eNjD87ikInDN?=
 =?us-ascii?Q?5maub1JBRX6OOereQO+DuaFwPFLei2fWeDr8KWfmgOjIVroTHj912kxM3OGd?=
 =?us-ascii?Q?82Gb/KlYbUi2kALu3eDEhaScvfu4QcNd3PTP18FbYBJYh1xgLN1hPF6KBDe8?=
 =?us-ascii?Q?sIpPkSAl9jk3Q23WMZcLy48TJtiUZv6wVZnk2GTgjk8jRQC4A4eJshRFxE9b?=
 =?us-ascii?Q?+7r05OZCAONQL/CFaRmT9zQOGWovS2BRckxJOW0K6Ro12JBxAiXC5MQ4kjbB?=
 =?us-ascii?Q?MhQmnngWqmpxYlsTssR/14/zJokyn4Xr74SeyRmiupfvHEAqgIOyrVov2/iM?=
 =?us-ascii?Q?1eficz3nIskhD+DBAhQbs2bla1ZuHOBxRHnFzRYK/Yoilb8cBRQgr+3AfvVU?=
 =?us-ascii?Q?fG8FtDaGNX7ET+0PW8rl2A85W9XqouOpUVJM7bV2L1eDbdHx+7dEF4FY/sRY?=
 =?us-ascii?Q?fjqGPvneHc3bN9itjE7fsV8SevcuLzLzS3ibf/dRRF/e2mqSYa22kxODj1Cv?=
 =?us-ascii?Q?nWRm3ScLvQQasqGshGtXKNoQposvv9anyo9CDXhZabxcFT/GcXaNKjRGr+/m?=
 =?us-ascii?Q?rb9Ecz+rTHW+t9n8JdpYvJRzyj1om0ONnDO0ETHxeP03A88nftj6fnNdB7KO?=
 =?us-ascii?Q?Tq+HbAT8OTUiM8b8eXUYjGHBX/z6JBvAV5jUXJyuEpyoODph4YG/ZKKYDe4c?=
 =?us-ascii?Q?3YohTj+8xyWDxJ0uoEmOCi0LlW8JXxzI+TC0yQLAm/Y7zpUs3DPkYfT+T/cm?=
 =?us-ascii?Q?n6d4YsYUaxoEK2VOwuR+nZvD/8sj1lIhcy8E4340ssxbr7MqgXqqB2vQf+pa?=
 =?us-ascii?Q?OxCRVztKAnHFkUHxbAZ0U7d8A+8YvE9EkrFtgyWmRmBbKZztBHrbhR1BDuyl?=
 =?us-ascii?Q?gs6sBWE8vqwx6zZN4buR2kKP7zw5jkFydsJq5nEfUFYMkORDLFbPTeuimHaQ?=
 =?us-ascii?Q?K9A4pWewL3eMFnM/DnJMUMfsVRREYG7/MpduoVyq5hJw6mtlkJYECx7tVoKa?=
 =?us-ascii?Q?HPG9rZdGmlP871VbNuzgtbcO7Q73YjaNrflY34rZ3WHDfDQ1BxdbYMgoqMdb?=
 =?us-ascii?Q?WGYVj4O73IzZNCDVYEMfO2bJBSlnnuFfSnVWUzeIMzvpzElmMXigxVAPmV6W?=
 =?us-ascii?Q?Syawxvj2UhWa0jzi9vAsX3XavD4GO/5SU/l7NOONv13a23/FQDNuymTrIsHP?=
 =?us-ascii?Q?cvcmxyyOVvxYDggbWema5vaf19v0EztkxJ+6JTdnrQvGBYFRCgassSiXe9yz?=
 =?us-ascii?Q?q7KCjwTmBSXXJ12L7aaACMQqWgmZVkwsLRpKOhNUlq/xyFIu2EnwXzUVuCbi?=
 =?us-ascii?Q?zEXgnvjvMFDqo2rt56qmE5dz9vN5UOHY5Zxze1Gsm99IpLw3Ehp1FS44qS3B?=
 =?us-ascii?Q?6FwMuWX5kJXAp81ugKM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dQJF/2ZIovB0OWR+kKoxDK4ro8irejPDsTZKp03d4XzuEy+e+SSE+huUae61?=
 =?us-ascii?Q?u5h0dWrpKUO9+dXxU/1wwNorSQzYDCJzP9976w7S2CFsL4CqFMsa3f4zIvAu?=
 =?us-ascii?Q?cHeyVIIwR9UWi1nb91EOPPC/dGiA50NeMDGeTcVXM4XrqkFABwG0ovagVz3I?=
 =?us-ascii?Q?/3XvGqoUl5NJz9D3f5IfL6ofjljUHfunA6B9CQ5W0EW9brbK9ga7FYCdPEZP?=
 =?us-ascii?Q?khqwWU6/xEOTcr+E/SQDF0QzxoouSVhKcG/MxKP1nVkFP63D+C2kAZ/2evj4?=
 =?us-ascii?Q?3KRqik6xb8lJ80U5pdyV+f7lzIZXDTenZhuVbX33uWUEqneoEb2GP5pQCGJH?=
 =?us-ascii?Q?AOCLBXkOmVi5FiHr7OXYeC/KUjSACCGIBi45UxPYUNYqQAcV0TMR3ysHfBuG?=
 =?us-ascii?Q?p8/pmhA+Jz8t9/jcQfKjtCCODkSzhthqyhqMUxIB3GZpA8DrGvZQ7k7g4Kd4?=
 =?us-ascii?Q?pVenljbpup8QTFEGZl6uiHMPt30w0sbLib2jcKtl0T6AA9fWatO5mZ5NwtdT?=
 =?us-ascii?Q?pvjwkDvyduPpNs5MDlvsVLaEjZUxoAhiWaG2IGWyXEC8B82sAabUOWw7fREu?=
 =?us-ascii?Q?0w/+tsII72V7+94HdJzRGNA24TiYSKKC4sgkxRFan2o/h7u7LDHonVPeweQT?=
 =?us-ascii?Q?OFBu5eUH9MfModJ/oMZ5vi2KvAtmN72Ekji69XboKuIUmdpDDOTs0FYzzXov?=
 =?us-ascii?Q?S44xdjmg4qtnKv8BlhYFK37+jW3LUtX0Hm0ThWxGsGUpnP+KTW5TWJiQmDzu?=
 =?us-ascii?Q?0fcM+Thoc+POiTGU9WJqqfu902mWz+0g3v5pjFWafKi6LzbB0o1iw4BH4pBn?=
 =?us-ascii?Q?VprmkuS4/et+IzgHQY1a1vxdWfSMO9GVJDJK95orxEQQuBE8Jh1dRJbdkrrV?=
 =?us-ascii?Q?4NeF//EP8Bl0684Q1JA2pI7KiqRYtGtDTG/wtfwJYt7LzO2CIkUAw5voJOXT?=
 =?us-ascii?Q?4caVc9tkKQzZGqKBmUEdimokoulwf77chZU0sBbkk8i3G1hk7NdokdVZaMkM?=
 =?us-ascii?Q?DGC17O8sEAwA99GMvAIXQJI2jDejHQ0+1/ZiUrxBN1b7+hBAO2awcw5siXHJ?=
 =?us-ascii?Q?DcUAWHw8k9QZQ84ILkn09HSfMJ/J8n8X+dcglbt58GYrRGl5fpGpYHwSnicH?=
 =?us-ascii?Q?IKTIUXa+KtGxi579k0jgfXxfCJsvILoRrRc3EsWRcDB2e+jy6HfhmvIuWFo+?=
 =?us-ascii?Q?07/FjMqQAdlsA1eWt6lQt9bwOZY6Mje7YzHiVviKLXuZ2o/b8leLHhnkogMa?=
 =?us-ascii?Q?yA//I/Rv2l1pC2xajq2vwK0h0bNSjrWJbeakC33z5EkT3GVuN3Z6E/3X2Jmr?=
 =?us-ascii?Q?cVvDmZG8D7hA5CIfDxzw395tI+aBL+BuN9rvA8yc2zJaSq2VbSt+vo2UKMPv?=
 =?us-ascii?Q?pTHhwtzM+oEfODkNoqyKKKPybDKMg7wH4CyG2wS6xK6OpiGz7H/CU+TleACg?=
 =?us-ascii?Q?zSKBgY9mm9jwQ7TA9qAd0fCNSjEBaYLlYPNK7SYYMCyoM+vEF0klsAGXO+NK?=
 =?us-ascii?Q?UHdfv8WxS6ofKpll6KHLw9DC5Q3nhQWo5ZEEthZfGWENWqj/EMmLLsShIeiK?=
 =?us-ascii?Q?4sf8KnkBC0xf686Twbr/WLbdFlik2APXRKlUNxk8aPiKXZnwSa1ZX4ZO9fCm?=
 =?us-ascii?Q?ZYJem/aRHk+NtBPDqDgqzUnidO0Vg78Mtwb1V3Vr4oOaR3uyzD30CzIH/q0A?=
 =?us-ascii?Q?0HMNwc9359zqDJ0rOVQfwOUUlsG2v3B4Lk2hREJz/FJ652uIrAYaUxN7a+7D?=
 =?us-ascii?Q?bz1F3JgbPNJWMIhfAbUFgBIKPoaZnVw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xUmBhN+5FjQSUYQbgpCBKYyJrGVU0MHmFv8Q8uV3sDLKwVwWNQfpoGlvfVjEUCDnaqSfZSToJv1gRv+0ZZ91CZGayKlXOu9zCCi+/9GZ/G4ULS5wvIOo3P0mqboK9RFeO6aCRLlUTwTXTdlkZQ1LaN4oCcBT6+wBj44Ks3ePmrgTdxK2wFMMNNJXHh1T0v2kP1OIU5ePaq7ZiK2JLvkjFdxb3XUasuApAWQcRjvEA4dgQxuwGXuksSUQ9txorvPdmmk+hO3O0PQLRo1FORZjQ7LOwYSuueSkOaleD0V4ZGY3PYyUZ43Azc6DsM48XCO1JCQtikgDfkvMgWMHThfEO3V9DsiePD1PqLGC/UzrDhnh/NoZicXTpFAk7V4wCqvFMMwA43Figg+brfZUBpFWJSeZbz64Ww2//U9BOwSF5glAXEOZaUUU38cu1M4fUFUZGmjFVhlikNOCfkpcnufsFrGt+O4xG/StDuF0Rqd85IZVL5Uq9BDg18ERrHEA04cYwBrZKp2QlypxJYSpvABlWcAxATys7ClXUooNt/Ur0XHwHE8Qz/+OgaaQsdBhVFnyGTgqRJ2CsuGZxh//KC4YtI7DOr8wk4jyYFpV0K9xonI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256809fa-f21b-48b5-e235-08de5b2632a7
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 08:54:35.1085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPTfRDi0Hk1DU0DVX34fCYgPi6K9HE8hnDW7v1cQapU+4ew9yB4ejefVaNzWE+LwGSh+GDpc0BBByjWkYsbdmS5QB0PoZ2CTfvAleRUylCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF376CF97B3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=933
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240069
X-Proofpoint-ORIG-GUID: fQdmhMwYTNOST2WD7Wrco1mc5b_Prbf5
X-Proofpoint-GUID: fQdmhMwYTNOST2WD7Wrco1mc5b_Prbf5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDA2OSBTYWx0ZWRfX2meFlXLrBQBB
 KG61r3YU9SB+1xp2YFEWCf70ZI1AUu43e/dx31rMES+cySxotIMds2bfGlwKAxuj4rPAzWKQUqq
 x8YIK+8BZmWiG44yg0HEb3Kj0Qlw8NiRDbie83lJlYREpDbwgJeee1R4+9bVb+s9of0+qjnwoZ0
 H9TOwXvlM168I1cG5Bv+ptoZBu/o7Ej3HjM1jSxRUoLX/ESAv+1HTXU6rzRHXSIsGyDinZXvqaG
 uBDPmQRFp0VySWeXfzIFknp2UNANHvtivf5o0V6IikArimZcTHrRqD1JZCPIiS+1QAZb8zM/IdJ
 PM7zx1HDbtIOmEJqQWPRk6kEfBoYN/vNssYtdfU8jjSJiIbhZW0jnnluPi/dF97Xmpl8+T9NoeB
 fJjS9fDLDvhXwNkLxK2SSDF9dpH/bLjy+qValGm68Je7qLaAkgynaQQul+nUCR5V46lPSsVohP4
 C9BDtuoPMALlUgX1IOw==
X-Authority-Analysis: v=2.4 cv=cPLtc1eN c=1 sm=1 tr=0 ts=697488cf b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=msNpOLBh4ROe_A87RKcA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam12
X-Stat-Signature: 4fcn1ss8dm5m4hfxh7dyrsqhajtpciuj
X-Rspamd-Queue-Id: BC5301C0007
X-Rspam-User: 
X-HE-Tag: 1769244891-894413
X-HE-Meta: U2FsdGVkX191ffARZ9yX6IiaK73/LAukOLpQKzwDn+vum3tceZQjaoDWkKKHvKMuxh6ctfP5BGKZrH/PdLENOAVrZofPDk4biPyYrBmymKejvLuiBt4VmmPClG2402qEZiDE819PLflYDgrVwJCxiasN6SehrlGkIbEe91aIFdmrq7NHIvog/H14VHEAJ5rGZFDOFSp4SJR1+HaEUH6hJQk8O7N2kFnp1h1O80jhH2YRn9oQwFizu6DS4/mHN8b08znbYuX2mkIg4qLIxsiwBRKl8zWe8tp0/J9g9024vvvPtEEnxro36yAKaHWZYh06rFgzyvsWerwtu6V8rwBZAzJ2vxrK6vboxWzeMOSk4DV3brPJ9GPU6MwtGzp+WnciW/lFJFRpKRnsh2LI4IQwGOyOacYRjLxitzhBde4f5TB93/RdnLqU7u4gQApgZI642gLQhcuro43GQcKgPaNwHePm4if9PBum0z8NCyWvAJrB4si1h0TRePeg0xJrhYT6Di5MGIYFBV90sAtztubU62vDKPDKfsirG+15M7LUxNTc4aP/u4eC/QcYapI+8wt4+/F2Cwp0wJyxpWlZBAUHuX5k+wlJm89wVAmswNQtSDsViwHbWTbw3UUc0ukV44tQHxmVrf/FBiGct80Vjn2MHqGEH6cnryv3WrJvOBgZK0Ogwni6KqL0ngm0ClMJBUFqaWn7wiLUOQt5GS+x6CDxyaLNz5MvgKvRQMbrT9ufZwtJCunMoFkzQkVbjsaYhBq2ySaQYIAypPUKmwjc9L9b9kbsqIFE4RraO19PwsSxbVj7AjvaKjOWinHz5suzZQjdpG0lWd7TsViDFtRO/teAJoS6jALR8OuwiLsxR9DIY1ungGpe4fAnHAgX6U0ivh7+Zt8W/z90g8yoqgPLUYZH2tpTjBi7xWM187qTAa40ITgYlQUTCrFncKuL1EnKXPoc3EBoZFb1vnHI+qwKCJn
 iZ/rh1Od
 OyQ0Iv8zrPHIvO3Od0Ad/cHehP/KTkxeh115q+EP0Y/cKX86Xesh6/iJHh+DanfzOzZKsRGDOBCe/VED1xTps3FghsP2bJNQwJuwluAdBn2A7coCMCrBy2RRHuTr/5skc24ySnRh8tWDmQQYWdeAFM6F9drWCcR+FBpWmdHnLvGtTwTiWmj+L5vDgW7rEJfN79P3ewYntdKsLC1TR/eJfWdfxUBNabnFt9tKbc0/3ebVO7hku9M7WeYBwgYN2eYcL5c/kSlaf4kqvLuqNcl2a7ergDRybVAIKNhg46XK3THYeWf0+6kk2pa9gYuB4zenGzXfLnJrBfFExPtGOrJsFOgBIVo53qyAw2DM12KFZNhx5tVglSfnzGum7z5vP6IW8gVXnVGt8bogC6/9fDVTxAcojnSJA6WSf8DsMPYW8cgdZ1RWDeLSRTe1kEl1GXEq8pAE7apfjlvL/DOZTi8/vF//iprw5BriOB7m6lGnVILIQ9NjSOSoL3q8uL0h7IWldPg+jfpD9u42sa8I914mAjLogGamPoBZKyyYKRW9AJor4wvHSn0UCUiNkI13y6o0UJP1Enj8wgJ8IGrwyQ8vFWygFFNZ09u85dzCKHFn5qt12mIUYHy46i3FU7PUtH0jsLD+lQlC1m2GHVAShwGB9+EOQk/gjFmLH/Mrcp6KSVHy8BruPlIwMQkXbE1tNsfkEliD5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 02:07:43PM -0800, Suren Baghdasaryan wrote:
>
> Sorry, I didn't realize I was causing that much trouble and I
> understand your frustration.
> From your reply, it sounds like you made enough changes to the patch
> that my concern might already be obsolete. I'll review the new
> submission on Sunday and will provide my feedback.
> Thanks,
> Suren.

Apologies for being grumpy, long day :) to be clear I value your and
Vlastimil's feedback very much, and thanks to you both for having taken the
time to review the rework.

Hopefully that's reflected in just how much I've updated the series in
response to both your absolutely valid pointing out of mistakes as well as
suggestions for improvements, I think the series is way better with your
input! (As always with code review - it is just a net positive).

Please do review the new revision with scrutiny and comment on anything you
find that you feel I should update, including this issue, perhaps I simply
misunderstood you, but hopefully you can also see my point of view as to
why I felt it was useful to factor that out.

In general I'm hoping to move away from cleanups and towards meatier series
but as co-maintainer of the VMA locks I felt it really important to make
the VMA locks logic a lot clearer - to not just complain but do something
:)

In general the issue has been around abstraction at the 'intermediate'
level as Vlasta describes it, the public API is fine, so just rearranging
things such that developers coming to the code can build a good mental
model of what's going on.

So hopefully this series helps get us a least a decent way along that road!

Cheers, Lorenzo

