Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 783B4CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 00:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD788E0008; Thu,  6 Nov 2025 19:44:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2008E0002; Thu,  6 Nov 2025 19:44:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B5B8E0008; Thu,  6 Nov 2025 19:44:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84AFB8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 19:44:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DFADB7FFC
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:44:27 +0000 (UTC)
X-FDA: 84081964974.01.5E8642C
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011027.outbound.protection.outlook.com [40.107.208.27])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7317080009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:44:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UQHPCjI/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762476264; a=rsa-sha256;
	cv=pass;
	b=al3jcVRoXtc/BWmHAs3anEslW1K1af4LWVLjDwoPGki769CbLIQKaWnJ+NbPzJtZtLaLwE
	4yOAN53zuiVXprMaZE9ZD4X+mnHifTtue/VT3PA6xF3LkMmTDe21xLf0yyQjFwU0xfpKuL
	NAqxJppK9uBjXAPqelqcxrlL9cRGf68=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UQHPCjI/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762476264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kb9ccyNGJpuUxQbmB9ZAGCMH94JU32frpJjRZP57jnc=;
	b=ZAjdFhHsCRRAJ9sGlWe9v4rOA3Z9T0Xti63E6IRRh5lmtxjnUGg3r7U9epVAMekMq2Ovgr
	gIxwrYxoXGWFlvmzv3dFcPY0j6SQM3mwRtesvVNDCehR56g9TJoi7jB/unbaSIZ68SdpjV
	7tRoxPLPA+PdCI4qMEGJNMgUWfIlx5Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hul/7gJIvtpvraJZvsiRVig+d/j20ZBkhlzpq1Tw9hfjKsNDlSXUXc1v1dWky4m9+VGMaiRagTIfCDQqAPVMjD1fjQ0b40EcOeoNnEHwA8il3VCMpQ2VtBo9ttZ55TRvEAEHAkaWCFZGLl5C1mteMvDHoDM7spQuydHuJkpR844qpdHTEm/kZjf40oIcSc+KElmU9RB0KheCCHG8qkZIu0KXe4b9tbYeVdpLuG5Vd5UxGvwY0w6Br+jkfdMFD7t6LXBFnuCKb2jJvOT9YLbRJqEaM+PO6a5KCi5cL4Z7dkQ/LukO+N0kV4ctPkuNIHSOnmMIo6EjVo+w0MBx378HsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kb9ccyNGJpuUxQbmB9ZAGCMH94JU32frpJjRZP57jnc=;
 b=DLLXk6r0cT3IYmHtcQmnbEbqDnh2NDNHZS2sHHlwvgGkD6NPEZj5q32zJTPNt5EXJrvR3bpyQdrN5ytmlDDJnWPePDccXk9E72nn6jY8GSV4lmia51StkBXzFTKuwvpYtw7kPdDSSIgC6kbY+pxoIXYweg4O0V51yC4qwbtl0fePAOyBMawj+olxqeNoMH5KElpF3hZrlZLWVcWHHzq9sZ3OsyVEg5r73+gFy2tBz00LxEpyAF1WS4Iicn5Vsn+EuHlYuSUAQrDinUIlhZtojl1Ic6rciBPEVACgUIDPvDy5QJTn3rdMBxdF8ex4p8DaAfCO8LUZoeMEZE7xmSqMdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kb9ccyNGJpuUxQbmB9ZAGCMH94JU32frpJjRZP57jnc=;
 b=UQHPCjI/yog2UnNXdZknpVBZy8tmEegtcgMZ1IMmKJzLm0rfYvp/j7S/N+CHLZVlKIvX/VwE3N/cHbAOTecOwiLiAUkcPYO8WDLtDJOqZ3rH7p6QffyguwP+U+tFjLK6dP+TL5N3RQq5SluQfKAdsGAdYvgT4Uiz7NQNHfnAm+two4OTyYY0nUbBy/Jk97LG21zAZtFmsQdBP0jaRb6Z+Dt6iEqSNm08I/Xv0xXWeEH26Pfhy6qEriXz0YQhgkazA81a6erkFTxcZVDAsEQ5kxVyHXaOA0a8xnh/Q+6ojinsavjmWCo9waPhEwHOHra8NeIelNfPB6FC+/C/A0zkUw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8774.namprd12.prod.outlook.com (2603:10b6:510:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Fri, 7 Nov
 2025 00:44:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 00:44:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 1/2] mm/huge_memory: introduce enum split_type for
 clarity
Date: Thu, 06 Nov 2025 19:44:17 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <D0586354-E123-46EA-993F-7A4931390931@nvidia.com>
In-Reply-To: <20251106034155.21398-2-richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-2-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0072.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8774:EE_
X-MS-Office365-Filtering-Correlation-Id: 23745c54-ba6b-40c8-0da4-08de1d96c9ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P7qlMxqGyHGi4pKpUcnLvd5atsG86gEQ1BxWy3TiB8bGSVNAKV8qdWZHxtP0?=
 =?us-ascii?Q?V8j/f2nKy2DiFY7xhuIMoJvrnZmczoSTlmg2VwxS6jLFs3Z6wps9eqjTHi0r?=
 =?us-ascii?Q?Y8eiVlvbowSGthbu2S52TGvXSLYVkVxhyHu5tnlvAQ4dUpeGy4ZoGfRR4kor?=
 =?us-ascii?Q?T9RDSXfGZtQ/4pIw2au3lXXpnRVFD3cGplsoqT5DvYSF/HfC+zQaBnbG1jLm?=
 =?us-ascii?Q?RIHxxccsHAm9TcXOxVb9zjz6HJvSRtTt03XOMx2b0ECEMjN8jjxfR9cW3Tdv?=
 =?us-ascii?Q?zmPOnzZPKx6+yFJdMEXcfbdEJQ8I2dZvxxIdCKUpJUFiwlQKHepj7rCwzZ3Q?=
 =?us-ascii?Q?RMm6r0e/MlWYDp+yk0bY7b8/7nYBa4u/Cd6UZuFkWJLnH+QUlkIH4QeK7C+8?=
 =?us-ascii?Q?27Pkn7YFiFmbzDs3FcYfmscB5/DZwQlwNgqC31aShV6240VHjukb8sc9+96w?=
 =?us-ascii?Q?r4Id620TUoJUXvbkBU4tqLIxWDmofSpf+Y3YeUbFQ30fwFnoDbgWcI1wnpPE?=
 =?us-ascii?Q?EiuYI2wrnb0aLAlehwgUy8Ga7HOm8fJRugWhYJFPR6DKesir0CWTjmX+k4Hp?=
 =?us-ascii?Q?uca1pqxLMgT3exmVPWItYZTQijoguNUSm+pzKqJgoA5t/36EOR2TJAedi0Xi?=
 =?us-ascii?Q?vzDJWEpluvkpEsHnK/WpJDK4ejNy2Pk39LK3h0Opl35ZWdd0OFMMi7EGLxZf?=
 =?us-ascii?Q?832MT/hEmnpDKlQXwdP0EDpHsDtBbFevU/PnJb7cY9Usvwt4yTy3qySarhzY?=
 =?us-ascii?Q?iNplIvUQRUqBisud7QUFHb3L2L+YCIXRDcQZHG+N6OKeu1ET5Rk6CEM2t2L/?=
 =?us-ascii?Q?5GSqAhFXNghA1nFRA79r6F4SdtSo1NPaD5MWul14GuHHtzxbV0803g+NAWD2?=
 =?us-ascii?Q?ZPzzfV2w5oUIY3CMyq7HBmX0nh+P7+iFnHv42qq3L/pjeNiWPji6ldUcYHkR?=
 =?us-ascii?Q?wIy65mr+7iuNfOh3q8JxXuJ2nT1IG1Y5Sr3A6LQfuoosdzep24QT8zOPRsvW?=
 =?us-ascii?Q?IZqOSz9Xv2wummsyc8M27C6Gn2nMFRE2bhw1X5kbP6EtI2yYmDW3vh2wIEmH?=
 =?us-ascii?Q?zZWhUmCyTRqRXvbn6PPghJpHgUVGPrWG7xbOPjaZi6hXVI5XD2E+ZCbwsoC8?=
 =?us-ascii?Q?t4+dJWagY6c5b1QK/AdNbyK4ZuKPvVgCKv6wVXw/o7gyV4Z6ORkTxCzKba5c?=
 =?us-ascii?Q?1Q2JBQJsz5iJE4I4qFX+z1no6d2J/IS8qOG98kNsUhHi2kwVN3ZUzYd3VxnL?=
 =?us-ascii?Q?TT8y/0azrmolx6TTXgAEcnDPuIerK59ILvPO2xtXYyko4o8nkx5wvTkvcawy?=
 =?us-ascii?Q?ccxLbedLxZG0+iUWZ0iHKCSxKsfWkh2cFlbNdWX9HJA6AAQKeiCYOX5kzBdX?=
 =?us-ascii?Q?NJAz1juMuqshtpX21D8NA8gdZiid1evno8ja5amIdKieyBEEVx70u7pgd4P8?=
 =?us-ascii?Q?0MHC/mAlKFxqWV3bO8CCYrEB5YRqcvUt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+IjhzR2JYEogOwoAh6/knyg9cPu5aeYf7brxUcVOeGDg2G9DX/g7aBvS2jJv?=
 =?us-ascii?Q?KGxA/yCTiSCydEbHXhUGl2bRr3/AHofEsz9OwvniT29LpBJmTiBq35icBrOG?=
 =?us-ascii?Q?WC8yo5UwzSjkS+HnA3D83m7YWe7T1YnuEU1A9C1ENztaSvgmAW0SUQfD4ZBu?=
 =?us-ascii?Q?wdnDTATKp1pM4bjMG8F+q1UZK73FhhYHPvl/X97pYW81Hv//jsW4noD+67xU?=
 =?us-ascii?Q?Nr/cfchPl1tkbYBOYwnBj+Ct+qSrTZ7bXu9FW5Mm4gm5grXpHwVUrp+EY1dS?=
 =?us-ascii?Q?0WZjt4f7ViWqIP+CjVz1whHr+gVTOerF24zcERxSHKHmZuJsp5lsWaJzqUpl?=
 =?us-ascii?Q?aavj666SI/OaXMQ/yhIATcjmmSO8nJPt74eBmP/ogUAmmv9/6jVSJKBlJRTX?=
 =?us-ascii?Q?u0Wa6jQ8ZrftiftFSKtr+In9bHLy64KpoEwkM7iJdeN4N7TdaL5N4hv6z4Sj?=
 =?us-ascii?Q?WygMgPIUnUwLu1ArqeNtOCJD0xptb/lMkGAxcx4FG3Came5BpsyvfGWfD2Ss?=
 =?us-ascii?Q?hQY7fjEnmi/VRl5MPtJNWC83UYBMxB3lxl0+8ZaINXlqfvIpASHTkVufqSic?=
 =?us-ascii?Q?WS2ItB5+T1sIfop4AHmShFif5qTJU97bKDNY1jaRdV0AKP1lhFgOAJ1u7YV2?=
 =?us-ascii?Q?7NjeDEMU2ywoRcctiEo0NFfluGxe/utOoCJeAweJ/lmNRanB3zRtCdfP82MW?=
 =?us-ascii?Q?GhglfCs0oEgCVX5vf31+WQ18tShZKtit1Xfd1ijhOoe+CA3w52Z76erA1Ew5?=
 =?us-ascii?Q?vmTgtyKXy796DprTtzGoDeLPDQyLqkAPoHpEG/OlmKW5ReCln/ParapejNnG?=
 =?us-ascii?Q?rANnz16Stfx171QwNqxCkIIgAHrhnoyZa17cnn46iltb45WbU0Fy6sSax/ka?=
 =?us-ascii?Q?gL5rhM6TI1rlizOXdkSBS+8rTDHRvqSo3muaZ82Fo1AwfPOta/Qtn+gBJPB4?=
 =?us-ascii?Q?z0LKe/iWbup+BgPSmPeHQgpIEcvlu02PULoA4M+tzJgs14ZKIXczPRu36Wrk?=
 =?us-ascii?Q?nuTZX7KtqbrTxOk/0HYTCOHABprXgWHJAN1CXOD+ha25EC9408WI3X19vqSm?=
 =?us-ascii?Q?BR7wmBTfjolke/cCHDLBpDvyByLN4fbS7RPFQYUo7rfFQvNpSLKYBCOe5gdT?=
 =?us-ascii?Q?+V8g+cu8Y4gpbnQ+TCRbtt/JHm+CtRRwsvQLq3ODJ+NWmzj32Of9e3JNoebN?=
 =?us-ascii?Q?yHLGUwTz8RH6HUpkRfLjvcK5lOQdyS8d6+hwgBgTlu0/dN6plLqUYBbIYyGF?=
 =?us-ascii?Q?DQKxh1m547BZMgN70nfMr3X0fJGf209X4dlJorz2YDYepNTYinNEtqVWoC/B?=
 =?us-ascii?Q?uHzAPFlxEHDDAfOYZh0gXvoDvq7dKPMtHfGq2icn5QHFKxB2XOMunx6/ski3?=
 =?us-ascii?Q?NQZKpn6X4n/YFMcQaEyx8P72+oEf5Wh50Y3T2U4QuAIS2awu2yEou5gzxfcE?=
 =?us-ascii?Q?nCbE1Y39aPYBgKeQLulWjL0evvrVh5Th9iTv+S16D5/rNTeKzwgpaFjcP4sq?=
 =?us-ascii?Q?4Wclj2yiA15Apf9GNGAQx8oQXtMlGB0FYhT0u427iFBHOHM376ul3H3Tj32U?=
 =?us-ascii?Q?ltn8mnPwsRn+UUa++TdZIta2KHfDgL/2pQQPLk1h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23745c54-ba6b-40c8-0da4-08de1d96c9ce
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 00:44:20.2480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPqrKLpXd5hShpmutulu87YMsKemwCTP12CnmQK9pwevjQsPQxe5Ha5iKRsIRACj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8774
X-Rspamd-Queue-Id: 7317080009
X-Rspamd-Server: rspam07
X-Stat-Signature: j1be5r38kjzwpboq51uhbb7xo6dhquuy
X-Rspam-User: 
X-HE-Tag: 1762476264-575372
X-HE-Meta: U2FsdGVkX19T0vrzNvdUunugCq9ZGye2VuGFRj3bIdhjprdnSBimffn8rfuCSMjldRwprNJuG6f4yvs5FqISCmCC7JVCl591VMU7zAJj+voEg6liXq+TCaPDfZRiMXTfD+Am5LZlGnQ5R81fJJLhZRZg8ps4rxdUp+RxoMBIokADpr6oJ9fu2HA5XyOp+PljzR5esygWU3Pgtk0pMnA+SpLtCya2Q3cDALcDJVJlozSuNBHjVNjzu5iv42EkDYxSgom9vMj+YzmY3PSAGV66WucyBM43lK5UHBFYBDwwHL4Y/DbFWd+O9dHxgTcaGSu5OtVKNipA10whfXm5X8EbigtPl33nNwVWbsr12O6vmZJVH9FQl33FA3k6g1mgtnJfRbZ0Ryexig3jWfUMmGOkdFCjUu1UeER8zxAGPKjDH79D72RB7GiPazTsE5tPJR60s8obLiy/gR9qMDeoD5fXAw0kez8mcCUy90wjQIc+9w0FWpjwmJ8rEnNwnztkWyx9T9GTOr3zJU6RsnIbtXulDB7Z77+P0HOodVOHKF943nm//bunfI/j00Zp5W97uML6UECcTHK4K8hyHheLWvAaHtC6Y9BVCoNdBIXKx3NXRPTAHFEeWFeX45qUqTkLZ0W5sfi6p6jiVG1UD9k61VHJqnLqdXqa5QFAqMxk0IyqUHgvYn1DqGO0Bf4jIyKFr7MFlcdlJJkfd5FNDUn6FoXHCrmn5LqzjmJxXCMmY9C5BoTkTon7Mw9qr67xEWSuxpQpuaPZS+ZMprAm0SE+pgU1jbiEcQjy7xQ638+i8hk3bwKV3itexMYz9CxzJEEPOWxgs/kg4h/mEkJisYY8YushPyTYXcwdUK+FV+02CgodjcCu9SixWGo7V1F7eZyl18w5MaA+ac+dbZV29SV3fXrxV87+wy9C3Q/XRg2K96P5M/ZtDSKQRPWHWOR6t7QXeuAIDd6SMXJyb6QLRKeUwnj
 XW3L0IuN
 +FWV2pYf0d7+Km+BUwpwJ4cIOyfqODNAtZzso5xV2zeByr+U/VsWkecEHHJrtKH0Cjh+4mSAKqeXik3BbGh7rDLoogjB/ub1v09CEdTscMzu2wWA/lRaUbTQ3zlmrH6v5EcKVQbggXhBgNZ8e2SXR+AWNM4fRSXpfrSKtz4mi1eT1foNkvG1BLIbPk1faEozimyNeI76wTXM+xYbd3KlMTFN6W31fhrSSpXlOFv26hEt0lyRlRKKUYAxOhxIY4hLy5w6ehT5HjHmVUe5F7bFcb2wVtRm8Dx92lxMHRMPUjHNQVjvxk5tyL9glaV4TbG3YGavujNFH4KgOLZPiD3X4WScAOfRcKhVysEok/eAC9AwZRjTgV0NZARzn+nNZW1ODB0gFPALndhSqRX50haHBG2PjvTs52Y2imN43u8HnIGzlrmm+jLnwzq9n+VoDo8lFcaGj7lxa/nEBk3iw2rn1I/zOyIvLeAEtyl+9qL3QwECjyybiCj3GCYDcnPwD9T7TXsjt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Nov 2025, at 22:41, Wei Yang wrote:

> We currently handle two distinct types of large folio splitting:
>   * uniform split
>   * non-uniform split
>
> Differentiating between these types using a simple boolean variable is
> not obvious and can harm code readability.
>
> This commit introduces enum split_type to explicitly define these two
> types. Replacing the existing boolean variable with this enumeration
> significantly improves code clarity and expressiveness when dealing with
> folio splitting logic.
>
> No functional change is expected.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> ---
>  include/linux/huge_mm.h |  5 +++++
>  mm/huge_memory.c        | 30 +++++++++++++++---------------
>  2 files changed, 20 insertions(+), 15 deletions(-)
>
LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

