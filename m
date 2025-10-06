Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5EDCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 22:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2A98E0006; Mon,  6 Oct 2025 18:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CABF8E0002; Mon,  6 Oct 2025 18:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9368E0006; Mon,  6 Oct 2025 18:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 798878E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:51:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05C6E87E07
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 22:51:07 +0000 (UTC)
X-FDA: 83969186574.04.6D54294
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010062.outbound.protection.outlook.com [40.93.198.62])
	by imf01.hostedemail.com (Postfix) with ESMTP id 371EB40006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 22:51:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BZzp9oSI;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.62 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759791064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7o1TSggsqOwIQGE6pg/EMisfZUY+a7pSnGrqkgogUE=;
	b=THaUuNy03feZ7R/JGTDNVtz7DBo8IL9Dx3y8pHr275/h+/F/RdgMpmv8MM0cIJjLolyiYx
	Pv9dPkbbcEJRR7nlk5DYY3nwbCzDaOaJIxXCWoVm32giVQMuGY/q5RxOkXVja3VYDftL5r
	o6//FdUswqw4igkGDiWCYy5knLp1tu4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BZzp9oSI;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.62 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759791064; a=rsa-sha256;
	cv=pass;
	b=d+CQgnZeVmJjjNgF/4WnWpm5L20xEqIv+KHtHvgw3XETnmr0kBEINAnnXZwC6KbpDHx+Qy
	JThJWdY1dz7cuMHj3/SBys8nidO/GEf7MSG+I8593GEqiRzCfBJVYjghYrAnNx0tmFYrbi
	mW7mtxMyh9k2Ec78wYRo43kFzVsptvg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rn49xCtEE/G4GI2kHviEVRZb1dljyxh124PdklHuy7U43/C6FbHiHsxZUETEcQkOfV8ebKXkuAhneUz8J61rJq3dhiSmQK0wKm+K2kgdlZmIsHzvWlnuKUQuI9WdyWb6Iyb3gnaJri5CqsSxvMBpwbeerdY31znoMScNNUXUetOQeGEkKMv8uaT2lNQGyHIe/WoZQuulFX4Z4vDDwZ8NoZeL2SHrkCRgbkJKIgXUSeZRZrKlaO5vdZMlCHZPpFnToToGCcWC/ytTpazXxMn+7Y0AjW3w4Q5AkmrcffrsYYaqFW2jJz2XSw8Fe6hHbsMhofGNElY8VIprpmjfB3TPIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7o1TSggsqOwIQGE6pg/EMisfZUY+a7pSnGrqkgogUE=;
 b=JLPXZgmxuRlYrGu/G8pCTa943QclxOHmRVar6rSoi9cIaphY9XG+GQiFE+S53DJ944KouXpd6weLxm2AV5MkihhVSfR3NfAqJmMWr9hiVeEhADtCn78ExjJ+TmA96BZdXgu7z9I/ELRTZnfaA857itacl94lcOaNgjCUzx4EqqL5ZBkyl8Yfy1KYgshnv9Qfgdw3VqVLqt+OXfSusVjnUFosqEq1gTLafpsrbK1jPH+LR43h3gWCJdfMAoQAwPV2Sb1FT7n4DTJkJzy1WEtOzpdPoMrpX3NbcBL/j3XCiYgWkVnv8BsQkra0X5qJn/2jB8aRrzzUOU8DYT1TV7W/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7o1TSggsqOwIQGE6pg/EMisfZUY+a7pSnGrqkgogUE=;
 b=BZzp9oSIPOpPsnNCuotiAIwsbwLryPedyFRFDUOy9uL76lYyrKbJMvhJ7tUIRzs/ZnlnTYlVe9srfrGuDk68+saMvFuj/lyi2UGzCFAG+HwAuH/c3riwhDWt6uJulI4gfkpJukQWI0YluV8qOJfkNPou7IH9CoqGw6mjdRlPLRmJwcAF2Wtx0HvqFa4nXGCzlQ1ZuEEKDXOrxBggyXLEQfMFhPowvwiTWezVtTZ32R6D5iRFssA9GaEbKaNIWnRYFVluGDc2XnMYDc/ytm2Gsa5heIOrhIXINir9+BuEcIlDxvCImUW/Va42Pa/0AWZg4uuKRTi65JZ2dnJeURrTjg==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW3PR12MB4444.namprd12.prod.outlook.com (2603:10b6:303:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 22:50:57 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 22:50:57 +0000
Date: Mon, 6 Oct 2025 19:50:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 1/3] kho: Adopt KHO radix tree data structures
Message-ID: <20251006225055.GW3360665@nvidia.com>
References: <20251001011941.1513050-1-jasonmiu@google.com>
 <20251001011941.1513050-2-jasonmiu@google.com>
 <20251006141444.GN3360665@nvidia.com>
 <CA+CK2bBaQEVySFcNmyQnWayZ7K=z5FxU7wTyNtmO7ja7NNGo3Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBaQEVySFcNmyQnWayZ7K=z5FxU7wTyNtmO7ja7NNGo3Q@mail.gmail.com>
X-ClientProxiedBy: SA0PR11CA0050.namprd11.prod.outlook.com
 (2603:10b6:806:d0::25) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MW3PR12MB4444:EE_
X-MS-Office365-Filtering-Correlation-Id: 99d5e976-5f58-4b62-e412-08de052ad010
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ngPdKNN/vdkPq0SyB2evStumwWCCL0mTTlX6Hd1yJWpTWheWB4UfYQgZldqR?=
 =?us-ascii?Q?dkcDRpNLRz8j6z2W0r0QegsNq493y9zHqQhr6Hsez/4FYOQ6qnFv3NMn+ZrE?=
 =?us-ascii?Q?ASOZqOllMJ73MirWPHnLohO/I4pBExgDOSsRNxK4Wi/l3aikby8zi23ZwQsj?=
 =?us-ascii?Q?pTbZiUmABUe7Wk5AV8G60hFeS4Ivw7C3Z1MqUG9bqgawIJ7BOQ+huxYvq/bA?=
 =?us-ascii?Q?2yG3ztGqLZ8alLcvRp2ab8Qcm+uaq86Hs+ZiQacz/WVfQya4Zz76V2yjLCYQ?=
 =?us-ascii?Q?mtbaftsbKZ6fGPSb/qKrvusrezCAtCCHKQJvdOjGeez7wGcJW23bUIhL72P6?=
 =?us-ascii?Q?0xKcataI4dZGtxJtnKGmGLJ/79mtonttJ61cSMbrCs6Za+/KNwzey75WA9k1?=
 =?us-ascii?Q?BoDgdihZ/jG0j98RuFeFl2A7r052x41o2u6Lp0w9yqTLKD32FO1uAV7JO+LW?=
 =?us-ascii?Q?I/8cqFashZItMJY4M91jgJSdBZF+pOzgnd2l4HKSMFBut5yL9bN5nhXuz9Mg?=
 =?us-ascii?Q?6YPTCzuEhLNDroAvTeZzhyIPVoLWUETkKOiTWBCQ/OVlAHjZWnQC3ezV1PaO?=
 =?us-ascii?Q?VN9vTNA3YtCg9eq9VRLHPPBF+AV0VUM8cGBuVj8lg++R8jOY8v86KY/u4th7?=
 =?us-ascii?Q?vQxmchDm+8VjGuxcmFvLSQZXwF6/8hJmU2KuwI1oe3gIu4TMCx5XIYAGzbis?=
 =?us-ascii?Q?6hhse+2Ct3NBz+rbwbVUTwyElUOtl6vhGZStZVCB0J/ag8XvNl+rhMlPtIg7?=
 =?us-ascii?Q?ATN9fxJtE9fvcHinGJ9UpnesYm7pTLiX69yw5EBbfAYO0V8P86lOH6GU3Rg4?=
 =?us-ascii?Q?aRSkOa2BQ3UbqDfgmKoI2cuyN87pOWJ3ieX4O4+RaECCQhkS/qSU5dMsaQup?=
 =?us-ascii?Q?Y34qhAzRLM7xEvNAv3cngMadRl/6KnOFeNoV7MAaEcjChbO2bofQVETooMve?=
 =?us-ascii?Q?TScp8Fn8CefAHBjHKqpor0ub6GwTRIceKZBbRyjcKYpOH4/gtzuQnbHklxgO?=
 =?us-ascii?Q?rhOY1VRuu7F2sZiWosnudEF4BMSqwdvSqlAOVeSx7x0IxH6bfM/rSzmuc0Pu?=
 =?us-ascii?Q?BASTKJxjHYCekjmKN2/OVGui+5BSVDD/tmPCtIQlpELaL6I8Y+pJcwg/5QUz?=
 =?us-ascii?Q?YUG7zhZx0dYqHUUbvKqGHjFAQr6gY55Xbw+DKUTSd3+tUA2QIr6fdhH8ofkm?=
 =?us-ascii?Q?ozth9j6+C7wGn+8lYtnZqUYhyYryNrysEPC8X0zaNf9KoF95sUfCvgUSUUj8?=
 =?us-ascii?Q?WS4bFbYuByy/9l6YnoWxApvcFMWNBcgzc7lbyORrR+l6g+llukhMDXBE6wGc?=
 =?us-ascii?Q?YjnezNeCenIwv5aH8m7TzzOwML336QBUtMy5rcDWYJRTaOChQOdpJ1Z4o9Az?=
 =?us-ascii?Q?mv9gOXu3zsGl45zaRJ8lUpITNP96YrCXKKDlb7qMpv1lIhI3iXFB8xUBiJKf?=
 =?us-ascii?Q?LNCN7dqSOKnyA5rQHzrX6plMRHCDE1wc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pCUL8/WdqRuMcJtFChm7jA2gu3yT0Jo2VHwcphV9f584IteHUXx3k6HtTf8Y?=
 =?us-ascii?Q?A5blTfUtU5uNBJ4mSvwJVR0A0ekHQO4oKpPZ5c9XR5XGCJztaj4WHMjgZ+04?=
 =?us-ascii?Q?4v2ZJDQrxEB0Ix3bmK0b8p5hQtJ0ZWU/dH+DheVzEjo6lrIpOhy+4+buge6Z?=
 =?us-ascii?Q?aSvFGxh2Ezyev1rOG68WlcYs5zxY93x+YB3SYZ0iigkmvdq7b4EaA5MgIutD?=
 =?us-ascii?Q?5WJMF+WjJUeK9hx3ZgYWXaUIKdMadgncIbyT2NZ1eaTvfuYEQHA5gkeybSh0?=
 =?us-ascii?Q?6LABFrMH5scOsLQMqHJqQLHiApG72oM+FOpFsEA95WwBhiWgRwphMRaQKOFS?=
 =?us-ascii?Q?g4Wr96D/rENNKDxCUNx63qJU9lwT62Pvj9yZflQE2z+ex3sAZzdhNjx/G8ng?=
 =?us-ascii?Q?YZb1Aw12lAegTjZ0NgDFqA+u7LtCN5hSdATArmIgLumJ0LWsbqm/LosFhT2g?=
 =?us-ascii?Q?ua+LuQGNTo9u2x026oCFVhr6C4efO/6f6xOBdFgkZ2h4nwlyak9WZ20C9wts?=
 =?us-ascii?Q?BB3l6FiQabHzVAL4ePAloLAXDeF0/Vf5MyzqoInqAjf/R2GDUpECja4K5uZa?=
 =?us-ascii?Q?P45/HNB8NTpqLet1JlJug8WxH1aBMplbf4JsJeTaFqSHQfKEE6o9eeweogG3?=
 =?us-ascii?Q?c1Baqlwnlt8ygF3M7T1oie/IqHdAQaDve5FXB3kvzhZtDKxtM8TgP8jYt3N1?=
 =?us-ascii?Q?kCDAbvc7LZwJQCfGQ/CGVyrdDWeOdQWBoZ1HR/+zYDqpv0uCqpcP6uPO6tXD?=
 =?us-ascii?Q?8/Ok4BItBRGM8CtAf2Lo9oEDMAG9HwlOek2AwEoJcq66JEDw/MImBmMupRnU?=
 =?us-ascii?Q?ZAEPHMku/unS03hYZKByJeKsLLFvCpoo2ogMJVpdNhG2gwHqQTxWUBuuuUAo?=
 =?us-ascii?Q?vkVQjhm7JBu+oWh7DvanJB9GeuYjwlb6K8HrsKn/Y6+miG10jUNrDHC6+HrU?=
 =?us-ascii?Q?MDdc5J88zhzhrQf/Zs102VxGOLMFdvcXrfi7pmIMDHlTMXyRMGyqPdgKcg25?=
 =?us-ascii?Q?TGE6Ya897r5b9fGWybcSg6rjutAbSuTxE9Jf54IU6ob6S6omR+oQME0TlRFG?=
 =?us-ascii?Q?/11bOmYWBAVoevfUtPl3R5fgQ9C92k8qxqx46mCdLvHQaesvpU8eqMn64I5T?=
 =?us-ascii?Q?fHkGU4br4Xd/I28SdLIV33ezUhiLy49vqzGXD7i73etLRtBt51HJqNm1x3z/?=
 =?us-ascii?Q?l5G2F0KlNuFpoBhpSo9nBQIeTjy1fANHU1+UAu7Yr0b0b08WMGgrsU0IeKRr?=
 =?us-ascii?Q?b9I/OKfXeb12Dh7dCGZzK1M04nWjtbWxbxdyhIyD6J4D09y3k3O4QDXVbhfY?=
 =?us-ascii?Q?gJ9jMdU/lrfd1cc5xosdcigMeaoPCyfXq89LL7Ie+ULymnKPKpHaUoBE0SHG?=
 =?us-ascii?Q?y17wNWZF7Y96las0LYNl22kaIspgZBn4iBC8i/bXMO36zfzH0pZp+5kChm/e?=
 =?us-ascii?Q?o97mb0K10HYdP5OhNlSN++hIxC2z6ttSnqqwae1mYaLpyKTt3yJs4LyDStmV?=
 =?us-ascii?Q?jF7IEf0h3vC1/+wjr2NV6um6+EjTviEK472zoDmIXdy4aeoX2FKgn+95lFa7?=
 =?us-ascii?Q?g1c1AUELMsyH4Lg/7KKR9MACKZnxEor0RLh0d9Lv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99d5e976-5f58-4b62-e412-08de052ad010
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 22:50:57.2913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5WO0Ys8dI5BSOg3jIwFs8nvZaWcVQDgEWigQ2FSMzH2iNLFOxN4Xv1IcH2TH9xS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4444
X-Stat-Signature: 3j6isjoa776zes8s6695hypae44n3j16
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 371EB40006
X-HE-Tag: 1759791064-756513
X-HE-Meta: U2FsdGVkX19tdFqSKPC3GMaaK64XdmDEajHfgWOa2/72btHzUTfEK88ZyHLHxsATV3DzkuKV5rBuJF4DljKOdGbSz+X1e+YexeHMcsu/STTkeAK7LCQVyd32sEIwCWi+/aIJew21cAxZEfShgVef6dQV9p/8050oh7ugk+jXHxUXIFXUurPcVEF8MJ8sDGLZpB+PCAcV9Yv0TeFVKZpTUxAIznOK99TZoYmAJZiUYImiVoMLpUi3Y2ZQsOde5OCS5Ft6uvQzGNb0mJcEOKiaWBua6E4OKbz+KbjL66V/Cx1+URqp3SR3wVPVf5V13dKFA2XmNS3J0zscF7yxfl46q5XZ+PxEHCUZ9qIba0RwXtAqdML0BZXgfH7pFuzvJ5HEaziUb4jMfeOYJxbb4kkOewA+NJPUmIsPQFuto8AkGV9NkLD87RAqiug9Gr5BZuMyvYjOPaY2i7c4SOkJ5nrekyE4nj1mJFQA5EsrfrwT5fBp06Td9DnV+pn3kIixC7KOd7NzaDilqKgAaSxEpeYbJB+n0eMb/lcm4YSoZSisMK1hSHi2LMARi/SSzdHiADJJkeh3nVfo71HIl3LD1+pBfK99INMG1yJYWTeC2VZj4o8a60/fYNRYO7oeZTVzKDBzcjlJtH2wBOFWW6lS30pnz/lTMLxwyac1C4ddV4LrBM9ZSonqmM3ots5lTrCvlpHouS8CFL7PqismGxzCaoL72FXp9gb/hyeAecvIoXFz0vX9A2t4uNwHV0qKwOXK1+e+wUO/imo0JOlB5kjvjlX0dF2NVA8/+r2x1krp0YqeWm67Oqi3YYLnx5lRjiwybmwNIdLqDj/3UPLP+cGts2bhCiXZjl5pzMGdhxXoah7DUkluruWHQOCZQ/4MRa/ovEBkezn8nHv+x9cJBhf9PV+1iDKUo6FyhAH1RjCb5K4uU8y4vXQkrFtzNHSd6/t6nD6tyZjeYoEdJ6/j+1bJ7m2
 oZfNkCuA
 SNUEVyyw6j6m0uA0LtR6a4kj2467jOqvL+kNaTI7zJ+RVu6553IytD17tPoMb1l6uQQ36EhoiORSY4RuXpFkphsdXPCREbBdTBYwHH/Ci18/AWvRwL2mY9RHEvx3GnHwu11gDu3uGssmC/jlfMdNfSk9tOh1ze0hW5y+9lT5SnmqqbEgnNzPxinuf3maPjIvEwAGM7kfh4g4AtrpwwS6A6G+uqYqXO2WOTU1v91IOo5DkYFIhl+OkJhyk9/eR79H7PYsMPQ/yEk6Hbu2u0+hvPRZHwHbafSRL6tN+tM3QGnrOx5KgNF8YNTT9AIKF9MdMeNhDpRzh00HvCWc4Ol77wJbhKbKbowtGWrHhI4tgm1/6A979Ia7VukJybsR+BdLQ5lMh7MKyLFFapKx0Kbh4uomoiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 01:26:57PM -0400, Pasha Tatashin wrote:
> > > +struct kho_radix_tree {
> > > +     unsigned long table[PAGE_SIZE / sizeof(unsigned long)];
> >
> > This should be phys_addr_t.
> 
> Maybe u64 ? This is a preserved data, I would specify the size, and
> not care about 32-bit arches. Also, if we ever have to support larger
> physical spaces, this radix tree version would need to be bumped
> anyway.

Yeah, that is a good plan.

Jason

