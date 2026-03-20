Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A46108B8F7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888B86B0005; Fri, 20 Mar 2026 07:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860256B0088; Fri, 20 Mar 2026 07:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7016E6B0089; Fri, 20 Mar 2026 07:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57EF16B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:20:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02B92140114
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:20:52 +0000 (UTC)
X-FDA: 84566199186.22.3037678
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6AE28100002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:20:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UMBoSu4H;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zga4uED5;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774005649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYrGOAp6WAoZdu8wML7pk2toj6QWqktnAI2WOUyyBVY=;
	b=d/K99uMZDhy8HaGs6t1695aaFP3wJUaxqNm7SOwh8k6u/KjtVBLoNXabYc5WrFut1c7TlG
	h4p3PZ5pTYMzFMpyF12fFc/1xLhSuTUMwPSl7nyrrY/YWu7hh+5IQoDC9SfL7NIT3VfrP9
	a+SYy4FaTKP+nsS17PzUXTIg3Ga7LiA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UMBoSu4H;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zga4uED5;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774005649; a=rsa-sha256;
	cv=pass;
	b=TDdVYjRDGvJEuUfFs2z4MyTCYzuUfNdlJ1nbMqBStIpWD4ddjLg0/1Nrl+SJBG8MYc7uL7
	Gy6e5VGYXG9aa7uPINWTDPGh49iLTHEDEIp1pTGUQLonCUUPzT737Wcn6JaQ178hOB1GsQ
	U7tFTxEZYms6svdWltbNLATgBi+kQX8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62K8XosR2498394;
	Fri, 20 Mar 2026 11:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uYrGOAp6WAoZdu8wML
	7pk2toj6QWqktnAI2WOUyyBVY=; b=UMBoSu4HZzHt9M/tYyKp+xXOVVfYDbMyw7
	igOsIRc9E/wKXdrvKtWg+uaBVy4UmtTleEAW/vApK7O3DM0hZaZBAlC1v432xwYH
	HQyp5jdSMtICpxbF0pzN0Rd95Y+XTLJUcPNdSzfmRF/Fa9rDA3jtK1CIixREXCSH
	6n4TI2knkZPGywGyvIZyyqsE9fQFpaR9l6nI+gANhxHKdsVxQwWhPQl3isgoL+k4
	bX//CWbnR3iSn9W5zehdC4yLcH+gEr5EMW0b8FV2ggnLr5hh3oZR2qogf+zrlyw0
	LCuw8abqzSTaLBnxudFDKJM+DYNxaotjNhKpWDYCPRxX7KS9lAVg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cw07rhhgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 11:20:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62KAA371038237;
	Fri, 20 Mar 2026 11:20:35 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4e5f4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 11:20:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WM+f2NeoPFzLFpsWUZ/pymF16a/v/OubXI7TWVxJm3ZriRzstp64T9qRuXLAW4KUXmfNLUchqordH8NbzLBzKbKUn0HA0xeh7KYz+Lg6Ut1eNkgkgMTLieeUxqsv7PbK+0qoIR0EdOk9h6rob9TbctPNq89W79rcsbT0/K9+iOs6rHypytIQkVQJk8PPKEQwDz6cft7nKSDUAsWwcludlf/r0BXi+AdKQl8Oqr9BMc1MNZ2hpwnPnZYQw2cqEkxE3tAPwljQ0Lol2gc81e2WW0ZiWCvEIawCMJf/yVwuxv5Z/SIicLL8N5xLLiAjFi6uIRjxTJz8joAcgTHUVYO9OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYrGOAp6WAoZdu8wML7pk2toj6QWqktnAI2WOUyyBVY=;
 b=Hiu/+U7D1i1ZPKjSIK6tuyQsf0Tdr7CoB6YpASVXJ66VvD/6jbgMyXejcipdjNOmxKLjx+t/Jtd1GWNyUjMk1hFcE/2got1v8VHEDm4vu9tQz/vIcIvUidShxBaKL1fHGlLi6I4y8OnTYf7AHDNEuH4lxyBX5eb98cvchSCnEvbOaToju1GEo15yJSDNmf4yVjqR/a/inR60Jj9NVj1q+zaZ4WUHomqsN8MGCeHY/w8RZW25gbApdEHldrf+oya+paSS7Q4CL9pQf9HHgMpuBxsuVqYCX02Z9UYB2j9Xlx9mF0cbelMpaX3NiSlqE73eG63iMzHD4Fg7GUQoY0ZoAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYrGOAp6WAoZdu8wML7pk2toj6QWqktnAI2WOUyyBVY=;
 b=zga4uED5smh7tMxpa3q8r/0xeygFmKAFSNCd7Ia6ZNb96Px59AuDQWpmq2VJhJsBmmlsIjuIFsgbsKQxS2b6TI9BY/t0Q47iovGw6sVzhy+IJcxp8XZave1qdLyw+dtK4j5ikoe5ZaC4MKzWZhjdBDZBDqRtWbKpOCmgXIxSX7E=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6776.namprd10.prod.outlook.com (2603:10b6:8:13b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 11:20:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9723.022; Fri, 20 Mar 2026
 11:20:32 +0000
Date: Fri, 20 Mar 2026 20:20:22 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
        jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <ab0tdhzHjhIlzRtH@hyeyoo>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
X-ClientProxiedBy: SEWP216CA0103.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: cec6c65e-1051-4b64-d068-08de8672b2f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	qyy0t7p84atCZsevEiIR/QWYeMtTl0Eb1/bHF4047FQsHv6P16N9o1f31ttvituKrgMWzHNhXoy/MroXJe5kWmp3AxygSXKH1RzovSwulj03o2UBsgIFrLBCSonQ0TZ5KM0j/X0uGRlRkHakffnq9dHNuMojaPe66iY8cJ6fX+Z4qKPcToZGgVpPhySQXKa6PqWpaxpfOig2ERBHlWsGLiMybTE1cADzte4IFjpigTQXzbQGgCZIrE9epmVqTWpdUUEvDBLxlTUjTLdU3HQM5fJzRcF+wpH3MU+zfB+SEAiNx76rqONnuIknJca093dTWWgdQ/2WUBzO5iv1CW+gYZDbRVM8x2HRF3jME+u/8a7OTkavE8+UEHsClj3KjCSega+kJyDtg1k+Wf4sd0Buwk7llvBbfvkQAoMa5GH026i5OaSnNruCRuz+XxneRicZvo7DA9qGDbsSACA9RHf5WehuUnI/YiJCVJi1upf0XZLdA4kzj43sDAHxKVr/2A3g5wSmK4UD0vGmPJSiX21HaphkT2rqX5g63l+3hcpeo+a1h43jDvV/afTn3/0benrrlB824rwgkCLi/H62kB9Yo9z7kDiOjuTPJm61jcP/W6FEDM5K4JKven0/WZXBQKlV6KACxfjVx/wp9xyNjNS/TW4i3qeS/zz4FD4MNc/4uOrKKv/tw7YMYG9oLN0I9HnKHpDLTfx1FUvGHpZqbYHQuKqbaAHfPwU5uDsDKEz54Ro=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WiCYJIg+A70CGF0vwHSJ21T6V2irIh8Uf3UPhB2x/kM8e8imPID+IyrYdWkP?=
 =?us-ascii?Q?2irmGr9IP2sF38/AAVnKRje2+/fZM80cmR9r8cPPmQPaefVjUC5aTbpVi6oM?=
 =?us-ascii?Q?hXAF4m0fRvVCVM5veaiZ/ob4ylplH9OkyTYfw40EK9KqxpfAdZy6ClaBLiZ1?=
 =?us-ascii?Q?1+kGZgUoqKFkz7zkrQDUFDCWDl6UtGZ7VKOB4zOLh7SOvsvvhjK5WKSFk505?=
 =?us-ascii?Q?r/EcVh48sGFAAArdfjpkYpVHeZFnHPh4Vh06MftjyfEK9RIRoGbusP4ZaS0e?=
 =?us-ascii?Q?7nTzx5Qwz4NzxW9C9amoTHajbQYQK/iaMVxNUk0eO+aBirL+gA5EYvLDMGJ2?=
 =?us-ascii?Q?xHA3E3/2BsRao7+DVj8U0BaY1yBU+YX5LGOzd+vJjrtNIIX/00bU9wtKfVsj?=
 =?us-ascii?Q?BFIO4FYjcmQiC2yJfK+LkvTrOKP9u6yY4avLJR/Qnhk6Tcd7X/68DxaOySjE?=
 =?us-ascii?Q?MRSQ8ZJ5E7gyGEryJetTpSfYYNf0eIPpqjKJuXN8tZd87+Bj+Yi9gP9WkcVr?=
 =?us-ascii?Q?8bduvS3D6k6C74Lql6u/1Fj2v4dmjNHGOzWgqUusmlT4dfR9XfD7G/qwYVx/?=
 =?us-ascii?Q?hjqT8pUavSY9M7J5V34PycOycgzYOrDA4EcFkuK/IdiyGJPmjUi2PQTLKgR1?=
 =?us-ascii?Q?SBgu1I6qiKMjyJynVBgTDtmRyOXxl+zkRml5mocsO8DkR8xPvAZHqEomjy8K?=
 =?us-ascii?Q?YHqldKUXpacO6S7+gVsUk40fcgMxZB0VJ1imbznGTnM8v0HHI3WBoSrfbeMO?=
 =?us-ascii?Q?unEdtqjRKazT7R3skqC9BU1CoMkCrbuPYkNT9LIkWi7L5Xi/CLtHihsuBBKY?=
 =?us-ascii?Q?TzdHIim03w8C9eLkxDacxyfxAUpUfuXXQw1KFvPS4FwT05yttBbBDYyJArnD?=
 =?us-ascii?Q?yOs5fFm6zI8yiscy9+jRDSFMDv0DgOhyMeUW/u2eKAanOGkbRkCJ396kxC4g?=
 =?us-ascii?Q?YjYofasFpXQLj2nZZwR0ZjRVXR2qoU4pAm6xUlQ91/6nIbB3tgNjmqYswJwT?=
 =?us-ascii?Q?9SxgqnPL8c/Ufcxdv1KRRYzH5xfw85dM2SHeWoCpCdsK7w/eispwvBDbABBY?=
 =?us-ascii?Q?akyI5zOcV1UXnjIggXFE5y3iBC07UjnNk3kmpBsW64BpHgqiJCyBdpIQByKL?=
 =?us-ascii?Q?U0j1BG6lPK2FttBYoGo3yuPP3OrLz+1MyGWURTnwR8Dzm41DY5Is1bV6rakO?=
 =?us-ascii?Q?NYlGASKhRrxS8NMVrU4MvX//NXFiaCViQv02sOYu5MqMaW9y1Gy8aITX8SVa?=
 =?us-ascii?Q?3u0a9I2O0I/nxVyKu59tyYSLFIQ4OtRYL3Ja9YzNGkRo4HzG0bXz65MVxDOv?=
 =?us-ascii?Q?xZTbXIRc5yi9uMREhmi2ccwrzdrx47Pyv22W2Llms9mkZknnqi48vpXaHKmd?=
 =?us-ascii?Q?8FF9GJuwI6is/g5AAoKV8wV8er8vLJC0jfbVzlLucNL0xLJY5OOwtWsUeBId?=
 =?us-ascii?Q?t5ZU9Wg66cc/AMNNeobTq7murDMz5VfLlHrYIR5hL68Fbuszzdld2DY6ZtSu?=
 =?us-ascii?Q?Y1fB5MvqzFg8AYLaZRD2sCpXYG/yPna4vFhGlNjRU3qpilL3rYtVAxdqJ67x?=
 =?us-ascii?Q?oOBaiND/K9yeFIWEH/Cj8sqWca8EsSUlsfeRtQqD9jLM3SrCMnAgIQhY+FTf?=
 =?us-ascii?Q?zeNZ2sQTwlwUsVyYXmgbPnNa+tHRzyt+AEoxNs7NFgEd+U8p1xOPfklKlWpC?=
 =?us-ascii?Q?Iy3TcOOLFedy7D/Bc+g+J08UBrMyT3q9ZsyqVna6xVoSprlMfS7c9ahaeoKa?=
 =?us-ascii?Q?Unjb7/+4dg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	WY7Mo7cBNDUvqVAWzWu07CKrnvJLypK3LUuOVQD2ysAL6l36PdT1LFuvFocv5ZysZN4nS8zJvqQXjIXcp1YAePFIguXam8qQjpvodw7jWpsgk0Fo/7j924bjQ2rv+4gknn/6DtL4ASEDeYRiS7LyqQgwGyXCDkErQSYc56W9YYxBnZBMEnAvFLEXtwdAI4TFT0Su2z0/rvNfXJ7Hb5T0YFIcpskgQCVd1nFL1/ycO71KYPt6TJKUtgYO9EECcF50jofOuokvUAC0nJmbzKJhX+m3xPAYifE79Ft2ZO+2CJXoXUE9jiN5oL/ZimSYuoJrCVTYYUP3wFNppjBAho6Iww==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fub0NzsSHRIcBiR9lwORSuEEkYuOthyHQV5Uebd7WS/8ca6AguuLC8d1C55NGtFMkIXMzyEpDu4CvavFlRxbQdy/qJhX6rEYCTJE/LWfqSdyVqg14zNsOZsRKYc/qq09NvzgUW60OtWktdn1GI1CXSEJUeAhKWbF4OPD1f1zCaLCq1z7dVbCykzQv7fgtV/d1HN+TZa+FqaNjq+wEiwRvkGt6IRU4SGoAsEvLMt7TcGjzgcT7R/r4gSNTO4zcDHD/E0xZgfkfKi30MyGDvmzMmXtsH77zTrsNDKXcwE4i0O3lGowRa7h5JTYMVh7TerPLC8CRqwPfrwcGlCELcJ0xL6cWD/zPYWNUktuE8Hhl2qCStEzrmOTG2RB2/8JnLcW99r05fUlcLpN5hntF+gwacJOpqn7CSGAQez8Xer46cKRIbeqqu6O9RXskUk4gr1rAgSzQL3AUe9Nu7tTKHbtSz8fnQuEDd07iwpHUlKeHPrAcqOI0DegMjYCf99fmQlhSiaJqbBdzONGsAAjqzEBs6+zeb+uQ0yp6ZF8TQLdLCcVOpDI4+iq6y8HMECKU6HeEnwiUOIuzwgATF0MMSU1VIyzUqEW67wU7DcrNOMeE8U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec6c65e-1051-4b64-d068-08de8672b2f0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 11:20:32.3847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AiPQVBG9raLOnfGNewsSYADIVLj4XwI3zFpgN+Jk5bHOmoYLH156PRBSG2m/DbtLuCHPRTJAWu8G/tzEv/ZdfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-20_02,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603200088
X-Authority-Analysis: v=2.4 cv=HcsZjyE8 c=1 sm=1 tr=0 ts=69bd2d83 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=8i7A3EpTTfZRYE7KBIgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: nkJd7NMDC9flUqRMr6wljdUkBmYvjoOG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDA4OCBTYWx0ZWRfX9xjcjiA/Rk2N
 AyXtA+002U0OhBd2sQZp7lOQlFyTPoM2oPC/9gi3+jTuTOBGu21oKlwzupqEeGjg+8+YQvBmAyI
 NcpjgHZuix150Zv6wh6KbG8gVFIJ4w9GJArzTW384z534QXiYdO8Han9UsXM7jvix2WgRt4Bobo
 op6jiZ2L09+aSDC9gHoy9vOCUoubtxxW901/amdHdowD7kSEWxdWLxjW46zDL3L6MLr5HhKSra6
 uZnQ6zZ7MI7uIQnGuhQ66fy4iCu3xpVIChMHp1rwuk/rMKBA9n3ZEyikjMnRHKktclCqQdKlWVv
 h1NmKM6K06Bevds/jLin1GXtCRW0expairtY5noDVC8Pr7PiJCzOwKFfbUZrliMAZu+hVe56AFc
 AZhIm9cbNaX4f1MSsOR7IK7k4S2fcdotreYIE2dITDI0kfrSepsBnSp+2CPo9TE3hhsJokYCk9G
 N2/YfdASFHhHbFq2c1Q==
X-Proofpoint-GUID: nkJd7NMDC9flUqRMr6wljdUkBmYvjoOG
X-Rspamd-Queue-Id: 6AE28100002
X-Stat-Signature: zgz4nrgo9fy8prmbnrmj6wyztw6zkgtb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774005649-530475
X-HE-Meta: U2FsdGVkX1+YgX+QBIXNWhKM6JMHz4UVuif6s44kvtn6BefSysPdT5f+f2SLZyaZOTh1fw4eUMrQiJfNOpCFH/N5+YXC/BZQxNfC4L9/wsdQuvnQV+RbYvFeYOY41dFY7ZAjzl47joGQIcXJblrJcr10lriUiLZYF5/kIVbhbo//3/QbUEjfDf3etjEfXs3RpebtSJ/28cWH8krC3q6sctTehrLSRdd5TCzkdybHNe+yD0YNumFgBncyOUIEfAg9zKEaJNKxC7FKvbIu+DLLCL1qUOQ+8fOLdIUI6b37WrIP+Sp0ZfCkdrJ4C7PEV0ZYvkQ6KLHbBIiRUcHm5cvmidCnL15P/L+mp/rPFUaeJbBMiMN/+ifboNx2nes+G5BY4+5cRP6Ay2aEzAYmBipxA4fS9X1ejNUYv4m/GH8mm5TQAbnYj/MKnDhaFvj6DwA0Ql1SN0R7vuawQR+6CbcI4bTw6Hga5yiSXv0IgRVd6QR/EVUmLLtssjfRDdEA20omMsSePK9pSHFoPimgcsASjwFfsLpCJlH0a/xyuB+F4oUzpJJBn+4Wy6yxiLGTVzlvc06Z6uObAj/ZSFR0wbMMYWJ/l7XvTmybvTAOwva6tnG87NN4Wzz17VOg4kyqCgsaTC5+/MPTsNoGyuUu9bQTnROdae2cY+118nLebJ+2bM1iI4qDL/VStGgIbddzOIDvu0hS0ErkXWLSA9dtqcUByGt60o4npBMkF7W8u2Y1MWd7MCLdb8kdfbI1ShBsKqVoWVVS7o2Kqb2lseZmqOUWfXoHaXa7qRQi+M0V2gGwbyZWMVT7Nv6pRlv7CSxVyRVevFcRg+kZq2BAQCJJtoseRjfUvj6Bj69ZqpNhuk6vIFj/XqNy/cDAFuOjml2iYXnb1Azt3enDdk9VrtW26PHmdYWSvnpFUp6V8AfGxwMD1AUEpimfREpTFWZLFA9PDj3435Of8pmk4fS/HqSXsce
 uTgLNWvU
 49NAAfRTj89cf0tqc6AfehjJx5WTdbEg//jFuspfYuM1EaS6oxOG17Lj9BKLmpfdU24a2mhnMxjkINAodjrPcuqNJqeodSeWUzrOC8o0IHMaazBOP8kJW8oS1je83gjsYpt6uUvh/Cqv6sMJwfFT0670hoONrUjlkkAKG42CoWxO/1tiFswWqbGZIqPqbLaDsKsqLga+aeU0nwLeZ45B/9Cvsqt38XGEku7cqMPAOh5xxpfZkbC1BXZDNTNprgzzl0S2qaFd/1J9jrqACNPApctHjFLsL5y8bSfwfjUXStHHSB7gmV/nw4NHtRWqLuqCpnkuqzQc57u5Y6Vncwvxy8/vttKcRl2VKRG6Z03hxdieyLMshfxMIMy/Tzsd/++v7B/IeSLjJ9gb0ft96CWlq6SIS3XqcGU0TEOrBBcgwod8RMIBTP266YwlHf+yODAU7z3SrCGBo0+BIm2x5aDeDyocJxzClP5lUi4NZfpI7uUVnvo7lYAQ0qwxXkKTqEoco18L7DwAjbdRPLCLxq942/zKXshruN7HyFwVciW6p7WjW6UdLZvag/BrswXyddx8pXtOlu/dMkHq90pHc3YgX98lyjSHM4NC694xFsvBNfe8i+y8LDGQ+ekqXHDW7KHDHU7U3/Gksi2XBRDD3VmSw0suSk5MLeZqcbZMSsW7Vs6JVW+vvuDkMLzr2MBSambfBi88VE+Ed9XMMzzOcvABjNllsRHLdenbWhWTBOjHv5gQ2LQ0AmG3Ou28grQhUY6UzrK0l4XYUpuqGo8eSD4aHT5lu6JRIqUzKy8JXCoEuXXfgtnUJDZmZCvW5ADT7M8ejArd0w4hn0V4qAf/nJi4+O8SWRKcMiBBD4W0H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d79acf5c5100..b401954f72a4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -107,7 +107,7 @@
  * Kmemleak configuration and common defines.
  */
 #define MAX_TRACE		16	/* stack trace length */
-#define MSECS_MIN_AGE		5000	/* minimum object age for reporting */
+#define MSECS_MIN_AGE		30000	/* minimum object age for reporting */
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 #define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..73f4668d870d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1954,8 +1954,14 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();

-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr)) {
+		/*
+		 * The object is now queued for deferred freeing via an RCU
+		 * sheaf. Tell kmemleak to ignore it.
+		 */
+		kmemleak_ignore(ptr);
 		return;
+	}

 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
diff --git a/mm/slub.c b/mm/slub.c
index 20cb4f3b636d..6bdf409d427e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7537,6 +7537,7 @@ static void early_kmem_cache_node_alloc(int node)
 	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
+	kmemleak_alloc(n, sizeof(*n), 1, GFP_NOWAIT);
 	kmem_cache_node->node[node] = n;
 	init_kmem_cache_node(n, NULL);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);


