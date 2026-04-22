Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32207F9B600
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 09:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74BA56B0096; Wed, 22 Apr 2026 05:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE406B0098; Wed, 22 Apr 2026 05:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F1F6B0099; Wed, 22 Apr 2026 05:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42DC36B0096
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 05:39:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC3FD160C5C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:39:28 +0000 (UTC)
X-FDA: 84685694016.29.EA41790
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012069.outbound.protection.outlook.com [52.101.66.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8BBCC0008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:39:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Vm7s8xnS;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Vm7s8xnS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.69 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776850765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnlWvWHIN7cTZ+c2NoLEk/vLzJqJRVUAF9d9s6hmhHI=;
	b=oaJ7l2nWzmaH44kgSkhX0H6+6fltnu45wu9lmscfl2TUmtjQOL5F6yXufxWo8NJgXHVDlo
	vEI4BmGCYnsFim1p2XvGDMHV3SvIk7egVQU/fFGwVdGlPyEaugsiLcNU9YeKDG1YnIDHIS
	O2Ww3rijPTzm6C5Xpg6NscYk+uR0Kg8=
ARC-Authentication-Results: i=3;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Vm7s8xnS;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Vm7s8xnS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.69 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1776850765; a=rsa-sha256;
	cv=pass;
	b=RZWQWiuhkDN4qrFZqi9bLchjmmzc3nzDF1p3juDIuRcxJv5xQ1vRWkDZdejrBAft/7M+Gq
	PLfaIv0Uq8UGG8A0i0ZoV4t1o7uozpeIzab05jAuw8mNCOpgW3UDaOLc3UpXPl+pt+DG+N
	DNIs9W0CUFP54OhQxLFP18zrSWekXh0=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NdK3ho+/H3jv5+ZKQ7Yq7cxrkdazdZBp6Smqj5P/6/L6vcThQq5WQY2MF0lA/1gBMwDQZYLSuVoeZATq0jgsNDav6VuEtXNOCKYhxEC0pgYWch5fkTYCC9ntrRUQ5vlU4J9UTSxdE2nFPbbNpAQOmdoOxfXArCzgijDBhJyrk25sKyVgweHJLCXOTVOLlPaXdlA357iyTeCEMtTNVZLbiK68YKzkvxKjvgMN5xNDxLqfzVOaBTWUy00SRzA528a2qWsqVAN9IRBbdYjMeQOjMWlBUHLfHOuVmNkYplf2n58YXTOzNhW9Rp1fi3DB2kTBqW7aKfjLcW3kqgFtxQ605Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnlWvWHIN7cTZ+c2NoLEk/vLzJqJRVUAF9d9s6hmhHI=;
 b=qaCRi4icN0z1QyqqRTKdHiCcBDsZ3amZtWFRefrJZ+qx2jxyT/KIijCaEsqG8F33b/DdfDcF0hiHYgtprzyEkzvZK+4CsuHZ/7VW+K/ilA5SBKNKTNnLpAK0td/koohrFrjoV2gf4flzl5rQHNnE75L/QhHS9tadr6VIDYvkELvnxU4/PmyetmrgpklnkTvbXuLFlPBXVYd85o1fsCxbMzaG/GHIPXiJez9snnBPq9/MYaE9bpvV6/N9aRFaB1jccJMVB0JLsOG/mgvmV2VfzB3IPQZjjqeTjBTbNMzJmOs4uvLFP16sQCVFEGoC/xs+K6NA+OO+ukSR/0lBn1j6sQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnlWvWHIN7cTZ+c2NoLEk/vLzJqJRVUAF9d9s6hmhHI=;
 b=Vm7s8xnSC/VQojmM5pV9canyiQ3D3U7j8DiKmV+quTBONO1I2qeISMTYvtY0solZWDvnr2CYUZCx5E/Dj2Mvkppglle3FYIdjfMkz7elPdJtphNIsGvB2WVOG32HQtBihubYNIUEvwhN3moh3+gGHMBsT1WyM9AYEGPaaHYC+Sg=
Received: from DUZPR01CA0349.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::14) by AS2PR08MB9367.eurprd08.prod.outlook.com
 (2603:10a6:20b:595::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.18; Wed, 22 Apr
 2026 09:39:17 +0000
Received: from DB1PEPF000509FB.eurprd03.prod.outlook.com
 (2603:10a6:10:4b8:cafe::89) by DUZPR01CA0349.outlook.office365.com
 (2603:10a6:10:4b8::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Wed,
 22 Apr 2026 09:39:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FB.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48
 via Frontend Transport; Wed, 22 Apr 2026 09:39:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5T2uVT+PzGD+kw38tLIulXy7srhxorTyfi/OTBalnsRNxxMlPGevIOwatixZmgBRR5JHFAoNTvVRVj5iA7MHk6ctlZ/4AoN740YPyzdygx0UqKrcpz44LVV7MVz8pMkHbGPvU1qXQLYrOSgQG2/AxP4M7HZreK0pbCU5Gy+GkSESXtRijlyHTv5JuOwyBUVDfpt2QYKr2f3R/ODoKmYAYV+Aa4qxONg/Aioj1fxJtJPC6JdH7QFahALZU3hVVP6KTnhj8sOlY69uhJpxKnQNyT43yfkMCgk2UFlGGoExCmoLS1ammSw5f0ZupSoJ0n/2JZVX+/FtK28hdLcyYb4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnlWvWHIN7cTZ+c2NoLEk/vLzJqJRVUAF9d9s6hmhHI=;
 b=vmplVdZ/sH/iZn6v6LtQH/xJYiCSsDj8TKP4SFzc/8IeN9Yha6s7DN09LtwFZrD71L5vfPpespUXY9SUhdwnrhzDqaY1l1GVpRuZdxNVqV+h2FcGCiMidaeO3rOBOdoP7BFcA1n/+gpLqIG9rtbATJZLfQ70wEG13DRTyPtgrqp5/jJrQP12M70dDyxwYVrSgK9zW28xaLECs5SBwp6iWnSeNV/T1onva0HzDOKfj19O13sRuAc2Khw06GAaLhkvpRBVxaxyfZvIKeOD/1Lmg4OBQzuF8pLlgUCq2uZsf0lgN0G+Wwyrm7ri8NY/d8oFpwT65tvMEYj2Em52areltg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnlWvWHIN7cTZ+c2NoLEk/vLzJqJRVUAF9d9s6hmhHI=;
 b=Vm7s8xnSC/VQojmM5pV9canyiQ3D3U7j8DiKmV+quTBONO1I2qeISMTYvtY0solZWDvnr2CYUZCx5E/Dj2Mvkppglle3FYIdjfMkz7elPdJtphNIsGvB2WVOG32HQtBihubYNIUEvwhN3moh3+gGHMBsT1WyM9AYEGPaaHYC+Sg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU0PR08MB8254.eurprd08.prod.outlook.com (2603:10a6:10:412::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.18; Wed, 22 Apr
 2026 09:38:12 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 09:38:12 +0000
Message-ID: <e5098a53-32f9-4155-a935-de1ee09b42e5@arm.com>
Date: Wed, 22 Apr 2026 15:08:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/53] selftests/mm: rename hugepage-* tests to
 hugetlb-*
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-7-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260418105539.1261536-7-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0091.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::14) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU0PR08MB8254:EE_|DB1PEPF000509FB:EE_|AS2PR08MB9367:EE_
X-MS-Office365-Filtering-Correlation-Id: 5531a25c-aec9-4f3c-c26b-08dea05305f4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 T4CwtaWCtQE51BwD23TZScB7U4TYVq8S9e+uno5njrqbJ2kIQL2qnkWfF28WrIPGxgnlfhmSF0OUlRxI2i+QfVbtSC5RWZhMTyhkkseFjdJvRFRePHV4HdSIt6r16jLscClJy7X0pKBye2P/2tAKkNTz5sMneCl2cTcmPfM0KFpgarYnS6PihhzFtxSrod2HJYdcRZ0agOOTC/bcGMbgMxIgpi+MZPe1MF6rd2ON3uV0SZqdRfDz8vQtg8sJZb0fZN6h06Q8tS55JylTxrRnvmcwaPYSYsAgk5Q2/UOxTWlyyzN2C7xmrGB1uYnogymxUQ7hhU80tBpqGe74R5AQRjRLBQMiY2xsQ9tDcXCUTmP3I/5DAu7CsbcjyqRVeYwq+1y2RpeRYxQOYWTSRPgvwEcsb6c/Eqne0AeMlVwr71RCaS5jIM7BTl8zCJyQ1VDn7t3kSMig9fG90+PNFLsSHDLgOxIfJEoFRQD1JFV7t7lN0fiU2d+4QSgXxDf48/WxR0E5hngI0nPPO+6eL1obvWSuqtruI5xES9S95YSHT54VVjy8z78c91deQkb4JCPjzg4FQh/iRb74HrPLD6E9nUAjpX47bgiiiJfIpf2cDuTYhOcLAMTSohZXwniK2Qjx719EBGY8apQ9MtOoOdBV6ptvUsXGUxzJTqrAw3+V5rnpLmAZJtgO1/G5Vz9oa5jlHEFPAEktm0PNNpyN5tvliHIGo9Is9DxpMOLauLN/FVc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ArcWHbT9e0pzlP9TugDokWJ/8jLCuTAVv1+tS9u+q0bpdbZgGjnIqdHHtdMo00esLUoFbIPhroDQZLdkMHQmd67ife02BpXSIkgSxxCOiep5WoMaN56E4OrQ4ZwxJx3yjwhMDp08TuUphOO9MGeRQX2W4BUUKhW4e3i1xy4sWA17yqLfe78GjyZBmz0Ufx7O+2rJCtGjo7ANopumivy2Xp1MJIvn0hDOhALCx5rZE+Qzbxe0KRvpcsPvKZDVcLLC3wETvQRgh6PebAKcgPwCmyK/S8FZPDAORaTSSICr3nX4YXtgqlZCYgAw7PLhvLbtNa60DLpv/FeDWXHeojJMDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8254
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	57da6710-aee8-442d-a09d-08dea052de99
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700016|376014|7416014|35042699022|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	QiB5jFMzklReean4/wo1SV136Rvcyl2aXrMy27G4U7VYBLpbSaUC3HlCLicC2D+VozmiIaV/KBomun7pw36z+wenAtVGTBfdU1AsMxSXICQqt/bj7S+pCXLC01o27kka5XGPbVwd1vX1V4pBTB1dDDoEFvYktBryrdBob/M7AEUYBghSuAPDAbyGSCrlmbtT5RAogGzbXE4gl3wrnmDcvqWqP03Sq/E3EHdBK9+3lflwd+4mANtkLhsDQYXolZMm/wO+TtAeIy/030cO39mlDyP/E3y8/Ksa0aQAzvf4CeWx0UG4NW5rLyimIUAyxpayUlR/+OXC+xoa00H6TGd4A34ssDf0EsMH6XikvudGwqMic11BSVIZ34798BTLWLgXR8gAN7ksIK8QMC6gGXeC7167F/1QBfqbd92SeaIbBwgkmC8+yhSP0zAna3s6lysOqEOI79luJ63DN9ZMpeVEXzG1EefkVGbTMQZprKmrEJL7+zZKblAC+NQEGkHAYVhl4t6bl6dv9RQYjQRue74j5+Di2S1uJeHhkqaAAuFjTJ/fc2WS0H4GE16Y+u9XWqUOf749VsrddJ2mSBd9u57rbU2FznCSoMORk8F06HcmKj5x80c9VBnafL49iMlRgdH0vNvkKs8cMqmayHDLB7Wh1wrm3SvwQyGOai+QiCtSfb9kNN82AXMt3xG2yQpoUBf1P88WK/V9D1DfjQW6BaGjnLX1u15UxAlwisxPtnGM46ntBAvt98QUMhXTW4ARmd4M+8NGX7jf+IwdPO/Fo6jnSA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700016)(376014)(7416014)(35042699022)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Q4Yutxh6s4hOVRwSr0O75sWvsZwTOb8cpCQyU/5sC1G8dbsSBH7hBUNf7p7/EE6w6gPypGRUOvy+rWpISphgCnQiIHUhsxsyqPh57RU8kSnKghjcamFOkhNB6N8LrTwk/04R6svKU62QmLGVrugCNyYj5MHrSia5gZfMNaTljxJ3LhxPvTmrbG0iAhJgd3mj5+5/qvPTx1c21M6UZLZ/Dxd566RpvIElsgTl/6pH01sV1FEdnFoQd+B9l10lz3bjc4jqmYbqPm1wnQOc+j88ks6micb0eHnN7Ov34eyP/p2kbVMI4qFEefFi9UkuWXONyZIpyez13pHu2/R1ZsEFMZeALt76jCL/WAL2HvepoBgK15VUjUdHt0WrS8gTJYRKpMiSyWNTg6wI6dmjB5cBLBaNMaJGp4+x65HsMW4coebm00/ztCWAA/PRu4XhNGx9
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 09:39:17.4716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5531a25c-aec9-4f3c-c26b-08dea05305f4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9367
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8BBCC0008
X-Stat-Signature: rajhsojdt8wsq1sa8c6ysotjcky8rxn1
X-Rspam-User: 
X-HE-Tag: 1776850764-987084
X-HE-Meta: U2FsdGVkX1+eGJZ8P7Q4U7uY+NUo7B6ic1ezg6XPAIP37SMA0li7OFHyUUbpiPVhmGpIQAqjFnivUuX1zbIhJtLiz/viu3LDREnpTWy2F834/Fmv8AJ88Xj632aUXEG3TxN7sYFXBk8olyDb7fAkZ5yuQwLBSihG5VGjOMyMi3gh8vlYGpvsSg9+iBLlRkvj5qSfcjVBtAbvzWXZn/AKaJp2ppZZOtAjbpetzO9MynaBV0wLLzpNEzg6KCvdPlSPPlHHRY7SXqiCDC/NrHdzj0JOjwhvbgiAicuTN3qbtg3y5rPAIoHCeaE83LgorrJ/0J+6g3gd+jIZ6NyzxEhJgwhhI8Vm6PEHHJI4RFyqJqCdAoX9meF7hvNwiGy4X6PcdVEnpXHjWl6WuqLCG6r1Kcf3cujUxpmFDipMrNmFaPNULqqp4VG7UDU2wV8WM8jZrIl/SzMR5ZwMVoSR9D1SG3uX6QobJ+Eikh73b+f/tqvdCYNAOMsAQuoMVP1+eauGfCmxEqMkBWvKZehYAi4cMvFP3E17EQ0d4VyPnc+6CN8bY1KveKfs9QNtJR+FoElqls2k2E4PAAOpLPkq4Ipz8ZqqqPDb3IsSMRG5z0MHYmfgYU6xk5Foqgnn5pLCRj/zA/7NXtotiDKKdazIwogSC3rZ/MfdSSkIpBQaKtOSWG0hcYIMPK49eWUZwM3U67bUk9gL13c6LAsPDaWEgjBf1b8e3Vdcl7NxTpPST3AKJs1mh5eWro0XBTpk1jMh2dsy/+pvQwicZZ5CqqAtPo8g+KqZDFnYVQA5Au34gwUJSt5Z6cd3Jlz7KZV4xnR/VN/2Lh+JmCeAwG5mniGni4JWWyme69tV7fFwkfBzZBBuiNMwOqWGnUHRv0cmDy42hxagd1Q/miAZJcxdgAxGCAu77x5n/GvJOcyvsBJ7RJikb/3r9l/98+erEXEA3lH2FC9vnID93tFFnxiY/r5rL97
 FY81upB5
 pgiD0AaqXxOpxMwKt8huTNIM55KOc6XwnMl5OwzxSAtF8Ri8qivV863n+znFwxGVptbcBAWwf90ivBQGPlr0wJSQPRoXs4VR6ywFc56YB0+fmNcOuCvTC5TfVGSHlPcwQOPRCqqSnJjmbYDNzcf/OwmMnSYi2aSia06PqFG+8d8xShbwkfhzWBFQWVw9T0fQ6u8eJ7/q6NiuPZFLLwlhL16UVt5Eguf0exZog9FrZj/efLIkOuX6szTDxdaSpScOErKtyF1VME74MmFx1lR22c/be53CW4qMU7B0dAn9x5zS7tVmjHB/MqfkPuYPk4ExNCvT6mPDKVjPyuYXcZp9Ae49+WCZd7lYJIUsq5CTCuQS5rMDe3HDdp5pL8S64nLxte3eJyYYZfMaUi0QKso5Nb7RGXBd7gZrUw59eR+/8US4XfhZKv4R22gobTppgCgIg2nVHskWrwViuULcDoP8zmO/EqfP3/JurIIPl89b78qFO8K9tuDeEMUt83r58+prufGPRpFpQnQVFk2hYUK3P7VQEBYPCkDssH9dEKbVQ6NgjVn2aCH4VnSDRD/lPsRxhTeQwjW3dvJ0/zfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/18/26 4:24 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugepage could mean both THP and HugeTLB these days.
> 
> Rename hugepage-* tests for HugeTLB to hugetlb-* to avoid confusion.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed by: Donet Tom <donettom@linux.ibm.com>

I ran

./run_vmtests.sh -t "hugetlb"

before and after applying the patch. Tests pass/skip identically, only
the test binary names changed as intended. No unintended behavioral
changes were observed.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/.gitignore                     | 4 ++++
>  tools/testing/selftests/mm/Makefile                       | 8 ++++----
>  tools/testing/selftests/mm/hugetlb-madvise.c              | 2 +-
>  .../selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c}      | 2 +-
>  .../selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c}  | 2 +-
>  .../selftests/mm/{hugepage-shm.c => hugetlb-shm.c}        | 2 +-
>  .../mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c}          | 0
>  tools/testing/selftests/mm/run_vmtests.sh                 | 8 ++++----
>  8 files changed, 16 insertions(+), 12 deletions(-)
>  rename tools/testing/selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c} (99%)
>  rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (99%)
>  rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (99%)
>  rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (100%)
> 
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index b0c30c5ee9e3..9ccd9e1447e6 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -4,6 +4,10 @@ hugepage-mmap
>  hugepage-mremap
>  hugepage-shm
>  hugepage-vmemmap
> +hugetlb-mmap
> +hugetlb-mremap
> +hugetlb-shm
> +hugetlb-vmemmap
>  hugetlb-madvise
>  hugetlb-read-hwpoison
>  hugetlb-soft-offline
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index cbda989f6b6a..a6955660a806 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -63,10 +63,10 @@ TEST_GEN_FILES += hmm-tests
>  TEST_GEN_FILES += hugetlb-madvise
>  TEST_GEN_FILES += hugetlb-read-hwpoison
>  TEST_GEN_FILES += hugetlb-soft-offline
> -TEST_GEN_FILES += hugepage-mmap
> -TEST_GEN_FILES += hugepage-mremap
> -TEST_GEN_FILES += hugepage-shm
> -TEST_GEN_FILES += hugepage-vmemmap
> +TEST_GEN_FILES += hugetlb-mremap
> +TEST_GEN_FILES += hugetlb-shm
> +TEST_GEN_FILES += hugetlb-vmemmap
> +TEST_GEN_FILES += hugetlb-mmap
>  TEST_GEN_FILES += khugepaged
>  TEST_GEN_FILES += madv_populate
>  TEST_GEN_FILES += map_fixed_noreplace
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 5b12041fa310..898cc90b314f 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * hugepage-madvise:
> + * hugetlb-madvise:
>   *
>   * Basic functional testing of madvise MADV_DONTNEED and MADV_REMOVE
>   * on hugetlb mappings.
> diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-mmap.c
> rename to tools/testing/selftests/mm/hugetlb-mmap.c
> index f4fcc7c45875..c0d58dd7cbf6 100644
> --- a/tools/testing/selftests/mm/hugepage-mmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mmap.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * hugepage-mmap:
> + * hugetlb-mmap:
>   *
>   * Example of using huge page memory in a user application using the mmap
>   * system call.  Before running this application, make sure that the
> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-mremap.c
> rename to tools/testing/selftests/mm/hugetlb-mremap.c
> index b8f7d92e5a35..1c87c39780c5 100644
> --- a/tools/testing/selftests/mm/hugepage-mremap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mremap.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * hugepage-mremap:
> + * hugetlb-mremap:
>   *
>   * Example of remapping huge page memory in a user application using the
>   * mremap system call.  The path to a file in a hugetlbfs filesystem must
> diff --git a/tools/testing/selftests/mm/hugepage-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-shm.c
> rename to tools/testing/selftests/mm/hugetlb-shm.c
> index ef06260802b5..de8f5d523084 100644
> --- a/tools/testing/selftests/mm/hugepage-shm.c
> +++ b/tools/testing/selftests/mm/hugetlb-shm.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * hugepage-shm:
> + * hugetlb-shm:
>   *
>   * Example of using huge page memory in a user application using Sys V shared
>   * memory system calls.  In this example the app is requesting 256MB of
> diff --git a/tools/testing/selftests/mm/hugepage-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> similarity index 100%
> rename from tools/testing/selftests/mm/hugepage-vmemmap.c
> rename to tools/testing/selftests/mm/hugetlb-vmemmap.c
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 61b450032af8..b9e520194634 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -282,18 +282,18 @@ run_test() {
>  
>  echo "TAP version 13" | tap_output
>  
> -CATEGORY="hugetlb" run_test ./hugepage-mmap
> +CATEGORY="hugetlb" run_test ./hugetlb-mmap
>  
>  shmmax=$(cat /proc/sys/kernel/shmmax)
>  shmall=$(cat /proc/sys/kernel/shmall)
>  echo 268435456 > /proc/sys/kernel/shmmax
>  echo 4194304 > /proc/sys/kernel/shmall
> -CATEGORY="hugetlb" run_test ./hugepage-shm
> +CATEGORY="hugetlb" run_test ./hugetlb-shm
>  echo "$shmmax" > /proc/sys/kernel/shmmax
>  echo "$shmall" > /proc/sys/kernel/shmall
>  
> -CATEGORY="hugetlb" run_test ./hugepage-mremap
> -CATEGORY="hugetlb" run_test ./hugepage-vmemmap
> +CATEGORY="hugetlb" run_test ./hugetlb-mremap
> +CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
>  CATEGORY="hugetlb" run_test ./hugetlb-madvise
>  CATEGORY="hugetlb" run_test ./hugetlb_dio
>  


