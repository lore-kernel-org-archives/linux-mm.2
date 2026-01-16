Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE8FD4A615
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A2D6B0088; Fri, 16 Jan 2026 04:11:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EC86B0089; Fri, 16 Jan 2026 04:11:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2766B008A; Fri, 16 Jan 2026 04:11:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7626B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:11:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC82B59833
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:11:03 +0000 (UTC)
X-FDA: 84337257606.30.B7E0429
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44E53140006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:11:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nU37Jf4c;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Qk7H2n5z;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768554660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNhfF44brELCbGDRQD/WkhD/tQr3Sbqj/d1mW3i/uSc=;
	b=qfEVDieIClkcPqlEpbVte1hoS58Ijt3/yYQGYbxgxMQOwi3BYNpiTZXMMIDQr7Hfev5NGl
	ffwQVje2craVdRTprMwgwxMqBddcIxwTgPpLa7mnGik6Xm2A7amnhXM7kxU7zwBsgiVc+I
	+DxjTCyl2iGkwUhzrTCL2iuP9hQ7ncU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nU37Jf4c;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Qk7H2n5z;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768554660; a=rsa-sha256;
	cv=pass;
	b=Eu3hHvYnK+LBCOCh40GKaFJc6G4ROV1s0O58nEhXg2PZZwmst1i+kZdOTdulUaUX5Gc1ug
	LfdesnXR/AMKMmXIVutrZuExc+uduDAbzkr2JMwfRVePWWy8txKLZh3ZStAnGm6dhxJOkf
	e1MdelYgeIN5z1cSsldK8n7mZ8AEkqQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNUvo1430386;
	Fri, 16 Jan 2026 09:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yNhfF44brELCbGDRQD
	/WkhD/tQr3Sbqj/d1mW3i/uSc=; b=nU37Jf4cyjK2mbqvN4JktxXmIvb6tvrw9r
	/lbwvUrVoRCGQ23Hpt8ZRTu2TLYmgsPdYaUqFAvC8wQoQ9lT6dzCvJQbOqCw+c6k
	CIjss+Z7uST+4tjLA7M/3gctqtwHXyZbXbKZERDqcoCm9ZqeXbH+DJ7jUpcNzJFk
	IMeelHQfZaXFBi6c3mk5a+Hjlg8Wg10ABHLWTy1yFWTQrZMbIABlrnhB8TKf47cm
	l8waV1uGgeNbaoPy4VjY2G/wMvz3JgABBzICk2IFempWsWde71ianOCKJKViB2lq
	07RnASz09utq2VfjNQvZy2xnUkPEpMcQTyZI5QObQ9gZ5uYHBW2Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre41psd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 09:10:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G8BLFt004333;
	Fri, 16 Jan 2026 09:10:35 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012043.outbound.protection.outlook.com [40.107.209.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7pfabb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 09:10:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AiQn+TW9oEM6/Pgf725VtVVnuiRi0jn1yrfp0oW/xR68X9n31kTBFSvBqCza55dQnMdeB51u++dzYSCRBriNSQJorTBIQWsbiTMYUT6uhiQYPXGWKwsByiY2pGURoDBtzwr9xisFs+OpbvfMq2GdZUrmPJjQQmyUVgFd8UkANAnedKbS7aL1joiR0l0pA6Pp4xkYIQZe0/EyZ6tNSvHpkzFLgark/0prxPvvUBTFrcsP+Z/h38vcoMmUu5x2EAgVXvIlHj7c5LM7XiQoa9emHAIKc49gk8fdhh2fT3NZXUPECxLsQeNeGKKv4u7Vj7sVaxKTAZGNrLzuE08cqXjl9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNhfF44brELCbGDRQD/WkhD/tQr3Sbqj/d1mW3i/uSc=;
 b=ZRZhcnj7auNLVvcNzr9GKrReoMycYpQOs9jpVbMntLmp4BxW2OiMjOGYLXMnwvypmoGPBeO8lrNfXRFlXVl6U0dFaDCbbJ5jw03yeHd6SSlyPiAJBDZaMSj0wRVcM/iXFUZmOgRwrxJDwLeeZRFm9nfYVncGv7Q650Hp9/CZxYzNapuZYsrwOyn74RINi5I7pY9AMZ8UZZsd2Soq1PsG20gelKHBap+e+cvY24/0EWz/XgVoRVyMOl2ONp0Lkz/Mp8aipfSefGF7ugtyt/jruPG8T25hD0AHjYQZ0zYn557dVnLTQg4RuT9XNaLGImVI9u6LjUM5d/lPEXDNRu7sSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNhfF44brELCbGDRQD/WkhD/tQr3Sbqj/d1mW3i/uSc=;
 b=Qk7H2n5zFtlhbQrCV03SvMfgbs1G59RiLqD3TkOAh2CKtOFSW2+wpsJfaoqzsX7G+aSK9NipuWfjDatxuBKZE6Ki04WN9jZ5k67x26+gd6kTHVQa1T8ktzwyiXECvp0DO/h5zZrrBSMoLmzOTvojlhHDGRTcEjjiIRL5IQEGqLY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB5688.namprd10.prod.outlook.com (2603:10b6:806:23e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 09:10:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 09:10:32 +0000
Date: Fri, 16 Jan 2026 18:10:20 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
        kamalesh.babulal@oracle.com, axelrasmussen@google.com,
        yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
        mkoutny@suse.com, akpm@linux-foundation.org,
        hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
        lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
        Chen Ridong <chenridong@huawei.com>
Subject: Re: [PATCH v3 04/30] mm: vmscan: prepare for the refactoring the
 move_folios_to_lru()
Message-ID: <aWoAfDVNRf_1uJpm@hyeyoo>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <65187d0371e692e52f14ed7b80cf95e8f15d7a7d.1768389889.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65187d0371e692e52f14ed7b80cf95e8f15d7a7d.1768389889.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SE2P216CA0106.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: 65f7e898-7582-48ec-e63b-08de54df19c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KuSNkQpexcEaqCAHv4geWRPPIMVcQbOo1w1fiVS6UyspCgvHs4UFz2siofOP?=
 =?us-ascii?Q?Vq+ZnsEbW/u6/4VJOzjY48Q2siIWUROan34sclXFLadYYKYXmscyCmi1ER4x?=
 =?us-ascii?Q?IRxKw0sNQ4hLeH6+u8civ2Q6/vUmAel+/YuOpOtS6sU+Yd3vVf7S+iDzDESU?=
 =?us-ascii?Q?4j7HJtQEO9TCrFRs5pvJZhpck23+Rc3XpLWTri1RnkaQx47DlRxfL4DjDQVr?=
 =?us-ascii?Q?RWjkmel3aHe8N6E8v6U0fdKyGM4surzYHbNYk63PHKMyBTjsdrlzmMX1BIn7?=
 =?us-ascii?Q?wGESMRqB/IrLeAoNHTB8YRUUERKoCQliQLOxcWbe5wHMmBfO1lFIvOsCbhyV?=
 =?us-ascii?Q?dHd9xmsmlvWCUgCEOfLbNb79ovZtsI0H4PN/cUwtPA1I5V5OCfojGG2LVNlQ?=
 =?us-ascii?Q?LSo2R3LuHZGw4LuGzsXpQrD/MiM+fV0R4nTw3jiS8NCFVi/YstbzIOlS7yXl?=
 =?us-ascii?Q?vFYuIazAnwxPHnqWRtyNvC/DqipwFUXcWVsaNd54wmgg3xvr5R6ceTGtLW5P?=
 =?us-ascii?Q?gmfPkNsEMjyrdnJblGsQ7eYuWaYRVGL86953g1aYrsxIAxqcxpR+Rl3MSiaC?=
 =?us-ascii?Q?VtdZp/jXZplkUZ3MPWoslztimUr7edgTW8G71NJmnZf+p1D54ke6PetuQDJn?=
 =?us-ascii?Q?YXKJWQqUQDG9k3JNwF3Nj8FYkJqCk7Y4Jw8IlMySWHc4UJjKquzFvaJNpenT?=
 =?us-ascii?Q?SsP28l2rdJoQTjDL7+DH7eZhgRxYVT3dUvQsI3vI5aWS6D/Dt+O2ulA//NKW?=
 =?us-ascii?Q?XEZqGryN26fVIgYIpBs9CBgL+LKsj3cIqJrAwlCTI1W8M3mTbsnv4IK5K29E?=
 =?us-ascii?Q?L5T2yR6O7ameV+U+GqG1AHaog+iDO/jOvI5E51/Jam8h+B9or34ogpyOGThv?=
 =?us-ascii?Q?X2yvZmtqbvB3iqj4FuUP/YInnZGGXyXGKxuLOpwrqUCGnSQU/ILBdGZZ2v5W?=
 =?us-ascii?Q?OUMmF6QjE7Esu3bCjZXtn/x1jZYNO8bu1VVWmL8atpwtFBIYSGAuJRXSCltr?=
 =?us-ascii?Q?XCyLtleH+UBW9Z8wnI9zRNTb0hzYwPtlK7B3HDZQb1KlNfUM2WCTqPPe1n6e?=
 =?us-ascii?Q?XWWaCqGcpsI8WdsqVqFEt4Q1MdrG2A00n6s4YAq5yAQpDJcbk2jHowMjiIAx?=
 =?us-ascii?Q?kpHhes0bVDMJHw2fdJINgrDpNFVSvRNUJbGu3jjahCR8zjFm2CT269DFtxxF?=
 =?us-ascii?Q?zBu+ZGGNlxeEDlTzFfFBGy8seqBQnDozA/8CNJ7eX/gvnzN5a+Zia5buMt6E?=
 =?us-ascii?Q?oMbSOfMQRWgRK7Kkby3UPCSmRo/djcScZ6XWl1BdifWuLJaqMVrZpOFkBL4Q?=
 =?us-ascii?Q?UF882mwCUKE5JcvyV3GCs8IoS4SBSpYigHh9yzcallF4sS/dbBNy00mlKbNo?=
 =?us-ascii?Q?xd5MGHLQjFtp8wbRKdVjx7U7TsywD/QT1IG9M0iUMefKSRQBh+0GsiHrkXWA?=
 =?us-ascii?Q?tMIL9rKY9mvkllFCfGq49g1zwdjZMcPbnKX2cTFDv5TcaphggcGIKq9LqPHQ?=
 =?us-ascii?Q?i6AWjV58IH3HSV87AJwyWRb6gfMYgMAxHCI/llpuARoznU5ybdsuP8jKPLtL?=
 =?us-ascii?Q?VBig150jPv4xL51anhM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TTJsY6NUWDUbEDM0PiBxOqDFiVfB0k4rAOREuigrlb1FMJkeapBq0ew3YwDm?=
 =?us-ascii?Q?8mINYnA3vmQXXMMeVqdV1l/mWtN8wpZPPNLrI6dA/2tAtVuPkKL3tJBlK1+8?=
 =?us-ascii?Q?h34b4iq3n4Ot6MGa2nkwAZO+D1DDMpd1U6yTf9tVzrHPRTLtim0z3U2CV/99?=
 =?us-ascii?Q?tC0qY15ZWgqflW95Yk+wJ7a7sIc2A9PCVPz8YChHJWAgN+OydXtNQaViTJgW?=
 =?us-ascii?Q?Pcfh1uWNAaam9wZQ2dirvKmlAHUeWOHZbysDfJ+ivTQrcT6SxafGgsLHxsnr?=
 =?us-ascii?Q?JXaBgicN/54b42lTGzGv8btUgf4pY+NrjWssGfHpR7OGKvZXd4gQwwQ/yXTt?=
 =?us-ascii?Q?bJmpEOzdo00euRRpVAfmpF0iPuCWsTljA1HhVJ2sdNKDrjy9mHdI/MCOIIX1?=
 =?us-ascii?Q?VVjhbAVP4h0SS/8YqUA4pxO5AVxbEiZ5iXqSeWmIE0sgcFXzrYBWn5JDtLuk?=
 =?us-ascii?Q?VbCHsW7xH7S5NuxmG4vbds7YCt0VIdc8oGxeEUdQ9nRv82+3XaSuOpH9qfYS?=
 =?us-ascii?Q?PfTqb3SmzkU3Co6xblwi6Av+8KwLTge2FRu1CuttYhzM222Cka2ZFPjddM20?=
 =?us-ascii?Q?TGaPoMn4cdKXLoZOg1uURUCNH6mJUZXQJ+hN1zHW5g14bv3q6vsEbD0gh9/g?=
 =?us-ascii?Q?aiRAeF2BNFbdC+4NCB7XnDkAKVjkisTaAtJ3ZUZ3R7lXCqetkbuksq3kPiXH?=
 =?us-ascii?Q?6EFTYxAFHenWUeanPljWw1M5+aT7X683rWI+nnKOtC58zPOuPydCDtFoePem?=
 =?us-ascii?Q?jRLMCR831opH1qGLeevP99RVE/ur+Lxb1xTyKQ0YDeh/Btjaj9i/4pNFWLbE?=
 =?us-ascii?Q?AYILKzfpYUPffpwmEfvNOz//SMAX3fljUxLYarmyEE4LrNYc0OOUI92oN9uS?=
 =?us-ascii?Q?A1INVkif4InfIoCFXAKCGOQlukboNtbv3F1kL3EOnjxXk56E+lI4pCCxWDYy?=
 =?us-ascii?Q?Cd1FBkrGyNn7aCxyeSuurn3d3TsiQOU2OSM8N9xXfQi3EqqIAPBkz1b/mRDJ?=
 =?us-ascii?Q?hy5PUeud4DaRJi5QPhMHSi+CAUoeJBJW10KyafPjxCMR1G6UHEPqDD5sMgG+?=
 =?us-ascii?Q?W4eJgiAkS0Do0VNPIgFlaygSlKCg+X6fF7n6k0lJzv5YlbQL5JVTaOO/muJ8?=
 =?us-ascii?Q?+LPJCA75QVZ/8tyEx42/xP2e9xe9uKN+W12eyAWVtGpapjxgbetit/ZnWbWM?=
 =?us-ascii?Q?o89lN9BigwnwR8wjQYWH+m3OgSP4ZngMLoidh33fjHX8NFs3iE1I/kBFovMu?=
 =?us-ascii?Q?CFlmLnm31sMrm1N99jQp0dV2yvdeQCW1hohCxVF092AhSSNSGfnJKfz6O6mQ?=
 =?us-ascii?Q?3ji3vHykt19NP0stma9ATU3+x2pGndbWyL/j7BUJFzSGXuDNlj/Yqj1L5k5F?=
 =?us-ascii?Q?enq+ZK/roL0ESOsnF6jhrqnnsRmC5wCtbWGKIwPVT72omLrHxzbobiBjVayi?=
 =?us-ascii?Q?xRWv4EAbkAdsgvuujEGcIpV4pudWA4l6FYH4w9FMjNpfBp5GopvlenWwf1eN?=
 =?us-ascii?Q?SMD78O2ts0+4HupjKbTrdcb93ry6QEhtgY+DJbrv1oAK+IBWP1ATXRxedbOO?=
 =?us-ascii?Q?9dw6roelyuDtqQQz2O4VpNUsdxNeUWZtCCT9jjeCk5r70vxgi5ywwBqtFWz1?=
 =?us-ascii?Q?TKnnRRuNoEj3O+8fWFm6ceH/HqDqIVULFcBg9LHZOiIAq3bVx8qbeddzuJKI?=
 =?us-ascii?Q?xR4+4d9n8DGRi+WQaZJvW4YH3AYEaWoslIOecqetzdL44EKg2cfrAYaVmQs/?=
 =?us-ascii?Q?nh3zJ1RE0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rIjo09eMb4HEIDaB/rWXlBFmKfAKxUCsXcP6ioTZnthM7hW14i2Rc0rsjRBimzSUdwRbvNjiOpd+OEDqqyDrlaoissSf8fqu8lQA5ojwmMpLzHbXebwwgCuieRwFrN4d/diNUTLFTWJm0fRQUoD1BZOenub7HO7kCEC28O7J/49Pp129ypNbB869TpcLuTQc8CCmeKRDwar1RDWYqVNuMKLJtwMzm8ko6q5DzDDXu3aViHauKlIxJA2Spo9XQeqU94qqZTRbtKSnXDTW6NBoVfELE9vF5LgfN1gjR6cdRvIXg/LbsjvYOKMc5/DtmruaR/ghdbkkB2PxRWthKeF5UT3OPv1NtfBlTnEIUjU8Vr8ev0rSRAqCZJ780fegIv5Ul2w7vtLjGpId9zK7rcC0XDWhXgR19QWZexXf5SnJU6gbtFe/iD8UQMTs/m57o+h0vt7fSzXQh3Cezi+y77p0p88kbiz0iZBvQdAKlF9Sz8fVjgoJf+7bQIPDf4zX2U9ts/SxBkdyKVueOiDfkXjrYaIRtb3egummbiJ/WboAPqwIdPwBA+70IgPHPeL7ujwbj2l+k0zl+a3Y+tCK4oXBCeb2jRkHTirYjuAR1YgdnZs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f7e898-7582-48ec-e63b-08de54df19c7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 09:10:32.1276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 21Uv+lUD/LX1sEd4HoyKuZrJIl35ZrJ6+DibFJBhXRF5cWufDK1P/gCLCNNy17wXO5KrCY835YPSWCTgGjur4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160066
X-Proofpoint-ORIG-GUID: 9uZj0e95Hhy4LzssLX77IXbCsikmRu08
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696a008d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=ufHFDILaAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=26_1naic6F-fIHU1LKwA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=ZmIg1sZ3JBWsdXgziEIF:22 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA2NiBTYWx0ZWRfX7qvYURGRqIl8
 zzeO6SZO6XHAkUPyDP8+dC9c815IvsSib1ZYXBa+23eJtYzzbGTGOwDwzgbbU1/GDIC9vCImCVg
 fr7NlMp+L64baioWgOsWm+fde8cfLptwEW36zJ75UuQdphhq1tj5ew/3gLaLdNGP/6q3tlkwEo5
 pfMx5lODCktQny629e7RKFqzY3gC4rsEfWlmpznLqUYh9IHT7gvQWqsE21aZORANrg/+19m1Sdy
 t8HKIrz/QzLkR5oQ2ZdjS57HL718wuU5Uf7NvasGLlBFGEU5Ic4UxwPyu14kHS2KATbSDYt8Wvp
 R3Vl2ZFx1FkMLYgKUjtdRZXZ50W2vNfuggLHJLaF+wyrq8n0uOYNFubrMIlWJYMDROe9At4JZz9
 a3dtNWIdvVhYASyP7xvK0sDTitU4EcU3AFbaFQ/nbxMj1/2Tm0tyPy/mx65W+6zxkTua9U4SsC7
 W3Yh6QXn9drv6SJq+dQJsDLpK3HDTEJvlycJA8ow=
X-Proofpoint-GUID: 9uZj0e95Hhy4LzssLX77IXbCsikmRu08
X-Rspamd-Queue-Id: 44E53140006
X-Stat-Signature: es9w64xrcheq1ac3s8y9jowr3qmgsmup
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768554660-192304
X-HE-Meta: U2FsdGVkX18AF3MC/psqs81/6XXOSeNK4F8wa7aHCxs2DwB6B/oRbrFrOelikmGv1VxtAy6/aD4NcjGXMiGktCD3v+loG15jzlmpyne/OckQCwPJb0s8RxiI0bZ4srHSMKam7+Dzl2MkOk7ATVMPwmSKAL+/Cuiobtvef3OYcuDnUJwJ4Xmg5C6SKCL7RsDmEIVMB/4Z4U369I4fxFrgyvZsKGlfqUlX2u2bOIjaNiTPZWTQqsFdt2IxgrH7nDY01GMiq33yCXiq52v+QLUOZdJDtMy6f4uBPbLi0curr5w9GTtQt8tpulLMgIsM0PaRKlfHZKvpl9Uw18HM7l7QSm7mhdWGfGlPhWMnnihhMUIXtCxiVB3FSWdJF0/ExSbblOIHXs+MZLKFBDFWr7Rb9y18I5xtvNMex0hXBZqjraCnG2/aawJqYn2vgc5Xj6KHNm1TM16977b85W3ziT19dQaLY9BotjCSypxVdhebm7zqWYSbMuPm6r6T35rlscDScN5rou+pwrKawKOX/T6rjUkE0q+QvovRkyRw928Oj7iti9AITi9zhL0HMqzlrRntk0deckFpnsE5JIrmCQhc4pBBLvHYcTco88RGaEg20raSCqCMEtzZEMAKnJ+rFWSK6Vbt/qNZpirXdwujlvuNZn20sDvWNWK6IuOa6gzZ3Sj3BJAVpRBBulWhqfhlttBPs7yHEdx8MnXrcejGajXv74JTpVGRhT6zD+w3iKUpwTZxvn4+aQRKSRBq5LZgP9bffHIyv5/ycIqefio5cvv2f6rz6gn5KTebaAMTRS4cjuAIH8oq0X29X/ETQeZHD56unnTnrC+6sCCXq8LYSEdhT40NQJycHwB8ROOgO9C3BXApnPqTrSZsjelRgx+L6KV1jNsA4TvKAn0an8AWHEHPxMO7DT6xWAAfXWiFLKssmv/hGHKmz2yrF4OHZeMgkuaWJ4MTVrQ75PTcXDtI71U
 Ck0EhckE
 eK4iVdM9ipJZxvk+wcVdP7G/YLvjaLH/qnviXGtGAFyKeIuqYGWHkCS5ZhizR9yIA+mTYADldxd5UTKvRYAsrtLeqOnAJyj+knBzwT2YQl2iX3GkNYpZVXOGCuoHU4eWLEpvYF66uOlx/Q8ShhWVeDVX2mVFYvqoisGkK8j57UDdXyoqO/3jUexFuKAv8K1HS4bb1h0ZNaqTVvFav3JslbldQjIaiyanvWzlpX8E4vMSaWNTECCgfdq5txnn5/NRT21ahfGxBOpvpj+qUza+VMyoct5spUPp10FkCVeLZ5iQUFz2QEUyWYvS8AtuwXHXus0CITPbsvDQgf2HFxzY3cl2JuZAByLmeQUpa18jUCJAQG2RCjPp+YoZcg61x2lm1m1ZjvSNyhFWAOU+czWVjo8si1LqZF9qL0fY0i00UN/NY3+4HaTUmhNtgzZ478/mUWdMb6ad2RSrz0a0DLwO2syaSmuUjJ2xP7bzfhEkF29VzXSfTS9t+lkv8neh7o83HTh2R4NfpSu2M3cX2wjDhm5KQcLsow3g4uLErvLEoJMkdJGNsmWCiAbkVcpvliIv2rZRbMW/1A54llNPBgyZRiRJhH73hQvFlffuwXiaqeURWn6nnzJ9PNYqVtN0iJoJo8fbUfH+ggfLcQV/lMIw8BmIuq6jPmRO8jV+WszC2v7jm35O9JW1IKuwwg7S/MAd5EwS0lsSS5nviWacgV1Ab/8bWGg7MUKbvr31qeWxfOZMBoo/4CGC3/TVFenlDoglGgpqMJYEOxQ4xjG3SavgVIf3j2mmh2eJp8q6BGu3Tb3HWyk2VVElTsGRcO1URBl7sRf/3qz2bqEsRJPN+cv9ZhXWFZjBs+O4GyYZeJnn5C3uvbiSrvJxsSWgX8L6Y85gmb17k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:26:47PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Once we refactor move_folios_to_lru(), its callers will no longer have to
> hold the lruvec lock; For shrink_inactive_list(), shrink_active_list() and
> evict_folios(), IRQ disabling is only needed for __count_vm_events() and
> __mod_node_page_state().
> 
> To avoid using local_irq_disable() on the PREEMPT_RT kernel, let's make
> all callers of move_folios_to_lru() use IRQ-safed count_vm_events() and
> mod_node_page_state().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Chen Ridong <chenridong@huawei.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

