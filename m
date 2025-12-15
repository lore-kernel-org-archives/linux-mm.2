Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A9FBD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 05:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027BD6B0006; Mon, 15 Dec 2025 00:58:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AF86B0007; Mon, 15 Dec 2025 00:58:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBA56B0008; Mon, 15 Dec 2025 00:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA5516B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:58:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F0E68BBAF
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:58:14 +0000 (UTC)
X-FDA: 84220650108.16.591ECCB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id E0662180008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:58:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YllQHuD3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b+B7vkyd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765778291; a=rsa-sha256;
	cv=pass;
	b=Jwv8nHQgmAejTlqQeotpCmPh4FNcx/UOS6PLFW77jaaONQVf6lm/92zHsn00mSQmdixKrZ
	vvF5QCXzwk3+BO+LGZJuvAm+JoWtFspSPtdYSJd2Y09+X1x6Cpjcl+4Z3IQB39brZvwVNk
	+RMwueuoXSSYvP+iworsXiqT0WCH9IM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YllQHuD3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b+B7vkyd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765778291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoSBcslQ38LLpUZ63Gb4iJuBDDdyA6IlE2Xr3VuhNY4=;
	b=FUPuFtc2kvsMPsOdPHByn76eCA6Vz29uheFg5rkcRyA/OMn6oc2p6+kqUeQvCtLJ5im9Uv
	Y47CCiDwFXb3L2gpewkOkfPmd0fDc4qO6ti4LpoqwQvoUxnpnlJSWy2cfVEFarcJDC2NsH
	6mzjkFw5Q2/U1R0vTKRb2cp34Uep1+0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BF22TO01078062;
	Mon, 15 Dec 2025 05:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JoSBcslQ38LLpUZ63G
	b4iJuBDDdyA6IlE2Xr3VuhNY4=; b=YllQHuD3qHZQWlKi+b26sM6WSysqmoIe5W
	JuZWpr8YC8KJ1Nk0vlK12W/oR4KI6khIQDVdfDXlsGfMpOW5OLD73hAju3hfx/AZ
	g9ZrqL7LzlEHYHeMH8nkAaILEAjjOHVlb3Ys54CkRSL2rXlcQa8lmXzmYvEqQvoY
	uH8QmYVBfpposUrLdRDCHQx2RXhNk/j9jJjcGInxVdUTRsP+1yjNDBveRRhwLdBi
	aIyOR2U1i1k+FygW0xRY8IIxouRaiN0O4DKEfDlSo0gDzA9V9OqPxLtWUEXt8Nw5
	CkaL5sow0DLlpFy+Ai8mj8cHhprl5Zi5+kMQPoMOllfErC4YqsOQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b10prhcj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 05:57:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BF5pVm6024494;
	Mon, 15 Dec 2025 05:57:47 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk8t1v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 05:57:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PkFicMwKDlO2JYXkiVy0eHSQpjDGAw0InTFUJ+bA8UvNrxhTWlzJnb9AZYb2r3Z838A2ZiNIllhNonGUoG6eV0hNj/34UEzGML8SYYxsYG9RoQlm0hQMQyV+26Aurwt0t4E4yBWiLHwvJjPPhJuKqju2eHWizdALJK4rdkw+80Oh1HmNMpHaO9MlZUQRLI17fUfNVgWeA/vlVejC6PPWoOrF4eOkmMNjLMi5aqmysTcisoRo+w+U8hUwKsRRzPMqWHOBihk+kcS/z0ol/p0YeObUh+JsNoAfVA2BWfEcs2CZMRNMZu3bMmzHTKVkzf7BaYOiR0omMVgBJApkD5CkQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JoSBcslQ38LLpUZ63Gb4iJuBDDdyA6IlE2Xr3VuhNY4=;
 b=hD/01IECe99BW8CibLyQBmIHh61Dw4IzIZ6xu/iElHqdyvEfefD/Ls71txpsZboLu13ecF5mvLHXkO4nH1arbFcJpSHFE/B5A93SLjSsAgmP3TOfcv6bF8NO8Gpi1kVRcUZXvKdV1aF6N7SfpQPSYfU6Z2j580f0iXdmtx7rwBMMuhRJRarlpzmUvc37Ru2ZFA1HKTqiWnAF6UghjVJgXjfOyTsywdaSUchwkppDoFDtLxFGgzeI8e1GBSWHNgt2GZ4yTeuhQZbyUOytixeo8jO6RLQCEqpvLL6KB2JB2ZVQooE1LW6CY5iUPqBD5nCa6aD31sVeSGJAa+wK1GOTug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JoSBcslQ38LLpUZ63Gb4iJuBDDdyA6IlE2Xr3VuhNY4=;
 b=b+B7vkydfmTwmKkkMGJkCp5oTcM5GKh45fY91nnxcFDslaeQDJSV1mLhNome84fzFpD+4IXE4agX/gM9CbH0qWgPimUORpDq/uDsmR5bEWSdS3awk8P835MfWtys2SJjScvrWOjfazwRcoIqm7qBD4rM1l5gFsg3BRHu8aatxOE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6287.namprd10.prod.outlook.com (2603:10b6:806:26d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 05:57:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 05:57:44 +0000
Date: Mon, 15 Dec 2025 05:57:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] mm: leafops.h: correct kernel-doc function param. names
Message-ID: <da50f1b0-0466-4a59-b5ba-f75117de6ef2@lucifer.local>
References: <20251214201517.2187051-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214201517.2187051-1-rdunlap@infradead.org>
X-ClientProxiedBy: LO2P265CA0350.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: c35682d3-03e4-4902-2a19-08de3b9eddbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R1oGmTFVzaPe6GaIiROvH/iXBVBG1hhsXcFAncd6zmpsuRnhDscFe45neru/?=
 =?us-ascii?Q?A57kupZGfymszxsye8GvDjFb2QLvNHqPYpb1U3uY1AAyK5LfReLn6NxsB1UJ?=
 =?us-ascii?Q?Z6/Z1R8XVPxF9n8SqRVcpqYYIB8Y3MZN3fpmkGHYaVdwG8Kb3Ha6DAM0Wbd1?=
 =?us-ascii?Q?VnEZjCMBlqM41PbSwYzJsXFlmEZkW8og9D+AzGbEKy9l7M0zVd5nIAsU/nC2?=
 =?us-ascii?Q?2tMaxu5mE4u1istY4/c6SFUNgIslq7RCeBr7iXJCH65fDyc+PKC485YTOafc?=
 =?us-ascii?Q?Jzay9Q/bIzTLmoSJgNr7u1Qt5+rMweyK7yVKbhEEdhmHX8cTO6t/n01EDWhD?=
 =?us-ascii?Q?kIuA1R+jKzxH+/cZy3pae83MdbAWRSlsVPX+IwwF/OKENLR5LrLR/0u7MSWU?=
 =?us-ascii?Q?asKbjdSOCJ9T4T0iG3mz6bdQkzXWt2iBg9Y20gOgU/GeXwmp9jXMZMIv/ZmS?=
 =?us-ascii?Q?/quucHGXRYfSNPTU22LqrCTt/bT0fvPH3WucwR2Nvwy7SbAN/BDi3UPUWZpn?=
 =?us-ascii?Q?e7Djqo+xxxaEfkxwwZP5fyFztQx/LQytVBml0s1Bm049lEIQnukKXa9DnkQ4?=
 =?us-ascii?Q?dUhFLDk7CgfKmpd0XcWFPFq9iDMtfcr5ee1Ue/mT5DpeiYecZq2EAqIlkzD6?=
 =?us-ascii?Q?bEN2J6E0fi3cBMmCrVQrefGKNuApvnxWTA0rIgce/IuKSPLFRp6hZCtHwRxv?=
 =?us-ascii?Q?Q2SEKvZWURLa63ZFHlV0Yrg18F3X0QghfC8xxrXtISmQKafU3NXaS8YkSseQ?=
 =?us-ascii?Q?xverPCCPs1/X8p5YlLPu/U+iFszrSKH7MSY5q3u/k19J0QYUCcB6e8nO4o5x?=
 =?us-ascii?Q?auHDXafSdBRIrZJW2QUYlRZkFzjVL+j9oj5bOVrAhRrv/Z3r9aO7q8KDPD2Z?=
 =?us-ascii?Q?zf5ZINAupFEZrcemr2hbjJVvL35MwEJhguLfchJ5tgNr01AjDiaeMukV7brc?=
 =?us-ascii?Q?uOvrGNFcpM4xZ1sPmKsB6MIkDvtVVCDiX7o7N6B/n/GIGW6lOOMQi9z7sZdK?=
 =?us-ascii?Q?AE60Df1BaMnJPF0LdXIyIWViL1MXrRneCH1CWxI8K67U/crQqmhKY9usaElS?=
 =?us-ascii?Q?ap+hqRJXRQQMBW/GXYWxRWjuo/Q9H+2wkFjiQfzqMK7oExyhVT/DqxCETnEA?=
 =?us-ascii?Q?2GWM7OfElGhfpahtKnRujBqrGE+py6dm1cr5kAwd4X1mU/mllMAZ957HF3Dx?=
 =?us-ascii?Q?BN1nnENC7fWbpP2x0v1veXLho/3aYsiNdE8r7kCOQr4x17DKFUtMo0gA4lHm?=
 =?us-ascii?Q?9RumO8/VrPmbQKpnBy9an967ksgKmSNXP95zTKO0QSqtr5YdhHK7whkjgiV0?=
 =?us-ascii?Q?yXoX2XFo2pzv8D9BcsCApUeTNeGI0oEU9xYa/xxIG/M+Fnc3FX4zkXiZuQbw?=
 =?us-ascii?Q?+LRMU0a45SlsiBtPSOpvQbM5g1u0kncDxD8/vz62m/XOb9xV4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Xgt8oTAt7WD2pwMR1WNfXLNzLS4A5GYkk62Y56I+/7Xnoa2p0Vo0prSvkOz?=
 =?us-ascii?Q?3d66mFIhNkyP9qU6ntKjCafVtYzu86M8qHoDIslreOh4Xkvlo6vhEXUAX0/N?=
 =?us-ascii?Q?OOMJM81xeRWh3OnjTvnhRo699ufUoIdX8gDKmCJB9c+xSuh3io6ThzDXH5hf?=
 =?us-ascii?Q?ThEIU2Vbt0qtp3YsIHbfbCLeAeMJgPmW7YapPqcG2zvhQQJwDRVs7Fpw2GLX?=
 =?us-ascii?Q?DDa1/DrwPe97UNlJ+Yh7NCYSjD4rkqbIwYeWciMaXq13nRrNZgJY+BZTHn9p?=
 =?us-ascii?Q?KuWLk7j5O1ufCQgc1ANNtTnT9afVpPUeo2ngfLBhxto1mVUnM2Pxf5Pl3+Ke?=
 =?us-ascii?Q?+R4SXRODTMUMN3nwf2IK5ORC9N40MMVOh7VTy1UgZ2plFkaIcQSk+C4ts9Qp?=
 =?us-ascii?Q?p80zEI+t6GmxY6BWZG6FwAQolKstmBL9JvdqGGYI32T+PLcI1FoDeg4OCzCQ?=
 =?us-ascii?Q?jxqzG6kxfi2GJsNVwJYDYuou5bwicVlB8DYMK+f3mfTTbcP2NfYWFXDhNULe?=
 =?us-ascii?Q?e2AO+kdo54Bl4aJ++lE9aPHJ+FseCtnYQtucNJV4yJdNO5F5yHaFgrvSic8q?=
 =?us-ascii?Q?K7fUO0jkMdzFzdVJJFoyibzyw9COjL6XXy2SpU//5gJdx+rciDicybUOlBYy?=
 =?us-ascii?Q?0yA7Jpsa72qz1XqxScqgoEzgfgOb0QsWsVDjnCB3b8Rf0GG2QupeUm/WEukW?=
 =?us-ascii?Q?+tfRp8ueXpFrbchs5IR8u3S3a9pcTYJRLzF47FcjzF3wdhns60sP8VkyIzbk?=
 =?us-ascii?Q?y+HPFN+gr5V95dwMFtCw6h1Ur1h0njjGgLuVWYvxcWgl6rv/1OUXIymrFAdr?=
 =?us-ascii?Q?xbrg/Hp+ht+vyDL54gzGtTkXm+RLyDh3JWZYTw/n6HeOsnN/GYYCN6BhsOSz?=
 =?us-ascii?Q?wtn051IzgfkMnHCJT7Mzey0VsFUWoLfq8kk3vw1dmQjFcugy1uKnsKEryLq5?=
 =?us-ascii?Q?nmIsdKA3wh4/65UDXDKbtBVAcdzS2CHz2+3hwl9HjOl/06jYFFjMOgOILP0u?=
 =?us-ascii?Q?4zs+oMuBKTO13l1hPxKBZNwDG4lO4jedb+d9bOhdDaj0uRwjKJyUiL4TL/t+?=
 =?us-ascii?Q?9ZmGI2SCAqSs0r63+a8uLrxReQ0Osg3c80E1n16wdEEb825Ia1OfJI1+3tu0?=
 =?us-ascii?Q?3sY5Dlr/lDyPchOmuWApbDY6uwh9VJqMmNnfPMb5l3juCsvz5IlqgVhsgb6R?=
 =?us-ascii?Q?oJDMyBRMyEcE+Qz4eTfQc4sqH2JDFdz3cSRetSs8Qity+VfcwilqbQvCQDeU?=
 =?us-ascii?Q?X06x7tXXLqnrgkUSSStxJP6kPT09jrzK5iofufYvhPj/RwAsg70wKFUaTxy3?=
 =?us-ascii?Q?ie+0+wYvG9Icp0Mnwh2WSs5z/voAr42BdilUNuBj7uI+5GBia5QpgHlf0b/z?=
 =?us-ascii?Q?AX7FAr5v1znxare2FjgvtKR0fvr01Uujx+2Q94KVPsbfr7tX5pkvi46gZlT9?=
 =?us-ascii?Q?onbyedmpVeIukaKibgt1Ml87UjMT2nqhTJDvryJ4TxW0muWwg46uVeOEWd/k?=
 =?us-ascii?Q?gBEY0qt+00Dt1jUnd7CulFTCZcd+mAZujdhlcOgS3IPZxWOh8dyuKWg+fGR+?=
 =?us-ascii?Q?7nSIMFvGSxpOvpdOnGA4aTqObbjZ3owujpWyMSvBVECqxc+PT3TovQC36eh4?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kvXZwS0vZgsbBEbovlbxTiPFP1GTPlgxAQnn4KwOouDLRt/geTjHzExSdYaDPEj51o0ldFMVAYWZ5kbN1E8oSSf0UDID135gO9j7TZRtOvFQwHjCzEVbUa2tpRpPjdSZspzRMGrOyxD80ajcU1ExZa/lyHwvtPjBopxwQ8awW30XG04LIWjb0raXAl3ZONrBCE+ixckNj32cnnEBaVQM/c7iCf6MAbrwuf97FnMwPPtzAork2Gi6ZqqpW3+tJmBVBXCpqq7epAyFiTZDGvuMBpbpu/rK1wU74uqkh0Eb0IRR5vKx7BMGidZlkzb82hJHXNOlrs0u/LiNskzJY0Hoj4symzH9Qe/QBLmof9ZLBJvWF0Mv+PoWuo575WDG7famvE9mVG7sffa0KXYxeabtsbsiP7a5gUAt61c6h/nZ2thsdxvXMocOPgkd0qEDEEdhXD63dQJdASHnPO2dhSstfodz4VQp+/0rnKc2DmxHMLGGumBd44SlQGIv7nfAcXbbscTQV8igzaqBmonrlAY4Z4tyFKFoXqcNiQkMuevDN6iBqBd0HiZmyrLI0VUmPKy/wZJZNKitFjoaVva1d6wVtzb56rDY0xaZgjyRnA6HzRw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c35682d3-03e4-4902-2a19-08de3b9eddbd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 05:57:44.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYZW0p4NZoMT9zUU7s4W869WR3Bhm3fWNdwZsvxGooNiL1WPPo6WRAbdKrTWpQuxhUQiVyPEUyyYCLYlHmYiLhvHc1DCH64DA+F3JgQGe2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-14_07,2025-12-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150051
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDA1MiBTYWx0ZWRfX0yGySNq0kc0y
 6TmY2XJOC1hzKrVrsG99VWkfplr0bfHElPQQSUobirDF48tWY1qfDkE5nPMzFPJLuJzsSdA2iaF
 Ph1ChD44c9nGkdtOYAkLsAPTx12jkRobwOWDYgS1Y+ssH9ZiBMzzTqgEqk/JNZcaZkQgEohvvjQ
 35JQy7H/DKZzOJycv7GDVhXGiYbgbavUQaFYQeW4MCIKZOQsZje/8g40JDUKEtwVMS0k0iG92+f
 Gmt/Oiz0l3rCpWV/NJ9xNmwFitJlMWwwKJL39CpbiM+x4T+PsLQZ5+nA8Y42Zb34U/SFOvjwG6m
 fgd3i1HQELh5OhTvSHs6xjSjlxntqHJgfpFxGhlVQU3ysak79CqMCN07ZN5fYFuqccV5ooMRN77
 LPujtUmTTqezAZoFep30I/9fZPQwDg==
X-Proofpoint-GUID: EIskiNaJwcuiIxwGnVK41igMTTjQ0PMI
X-Proofpoint-ORIG-GUID: EIskiNaJwcuiIxwGnVK41igMTTjQ0PMI
X-Authority-Analysis: v=2.4 cv=dParWeZb c=1 sm=1 tr=0 ts=693fa35c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=yYpZH5GtoI4OFmg0MPwA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0662180008
X-Stat-Signature: 7y8w9don7uosxu9ab9neqfucmiatkkjt
X-Rspam-User: 
X-HE-Tag: 1765778290-40812
X-HE-Meta: U2FsdGVkX1/dSPB2oEv5pkzJki57c4i8Q5UA7SrTm18WTxALtMP0EPnVY7q0TYoNLbsIIxrnSpsOgFnKWTVuU5Onlfis2U98ytG1qhk19ee/tFSYnEwT5geXrMrfW2yPtyeaGyoK+9AlU46L7X+pQoelHjDzyXC1YT4ydbUyDQXAHrhfM5ljMnFqkoEKyQg44KxbCO0bERIcMh4c+Q4wd685hsddbIYsDpZa5xphZzu/Iba8NUocies0bnrwPx9yXWcpMWKt+xEUqe/S60LY0zukLRXgeu9JkNQ7gPPa+UIgjLBmQ3sMDo4AAqr1AKTqM97SoWTiDVL9Kr/JKZAKwDmfDBMk/YsXLAlxt2K7RLanGbGfY0Sa+5JF0xIaL8/xsDHsuZZX3kxkYmsZP6ECQRn0VwqlLn2SOK58ckRbiARlJsJvFBVzGe+xY5LvTji90iBdpkRnue0UXk8pzpzvWdlGrNj5O1NEOTTW54fScu6aq1azpkzPzx6TgBV1afEwNoNOBHSY1W1X0BEdMxtAYgptveSfbVeP+lLJGKKFfiLXGe9WBe1mt/92BDFFE2vPFyJ4lxaXYaMDFNXuMkXvHR4oQZmNjTJw9p8E5DZQ5YOkBr0I07m7oQiBRsseJ7UffPkv6sEctZ/CI/ZvF1EFFA81O7gUW/3E8gVxm9cbj4ypk1x18jzodZetdjs/gEXmEJ0Ty4co1bXjr24dXjYhP5wpQO0v1+alTD1EJbJecA196rqsRdqdishFftobw7XcHPjDtbvVZIlZvj/h2v0xzUjA/xTp2vYJZzLAH1jjH7UsNiJqw45v9hFRNM4AWxn+ZzmhWQl0B/ww0x5znx11fVKVRUgbDurX0wr4Dgv2bfun5Z6MQC/xREJ0U0gm/MHLMzsHRRSITSWvr1NVzK9XbTCdO7e9Qcu1SaQdMdT4J2zi2kivgb2EwCvffW0pKREbhUGvKibj83eNCRwB71f
 rwWZ/r6/
 u6Ml66lzUJ10/PqZnF8oV4nepexof0lzkR5Rp+fcBeW5D/7FBqVUZjUtk33vc8zTEWWbAP/Ac51aWkndOgHKkVtTfua79I3ib8lbCBgOonBxuyAK8dkJr/hYKVrNhePdnFmJlkQsPSR2sSsQDWLtk99EKgx9AeIoH7TCRTyNjGuugcEleyAlGEJ3+GfkgnOl7WqPKNG3J3pZ5Rw2eavJKJ1IhDndAMT5pzTHqgMiA8HX4DhUbekHZdRuBymOmyRFDlLE5yDouJoT+ssnVS0jtzzxUuNEdlmBQYsif95fWo18OfvwH5WzbgHV4tG7iQtOHFyAdyNRIz4wnyGNskqMuoXGvNWwglkLV8/XpLybM8ttkD8t17SfN1UDAylPQ9Yij5Xs5U+k00jmdNB4LlsCOwP6kGzocwQJmSG19Nc9XKJ63oTsvY/CAQztKmc2eLZsYi0Q5Rj+6unkEFLQJignEUp874OEMhmdhml6JzVa4gWZ2ichj5QsHtA9k7GJusL2/wXchqa5HJa3yfNe6QV5CFU5tBi3MN5fmmpjNNSB7sZuGsEKdKdgmcgZf3kGoc4H5Syk46+erjDs6eaAM0WCtZbVZ9xpCYQIzCgmfzg3AhOrwBwmudIMxGUvQV3oxJ7ii+OWBGNoDTAATOrgCFAhJVWN5wrz9e8s353E9CGxOoQTsb9wmD76uZurrcYRdYKKVBgO8t19uKoJ5TgTxcG80mNCcGkDWpSPpzV4EevUU8+8hOLdqd5jSRJYAF9HmM6XjW2QsgQ0UXn34y0LpxGDok+1gc8rhRG2HQ2pH3sImSjtg3nYqYzdD5Q3yr2dng3a+epaL6/vEdAdlWiA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 14, 2025 at 12:15:17PM -0800, Randy Dunlap wrote:
> Modify the kernel-doc function parameter names to prevent kernel-doc
> warnings:
>
> Warning: include/linux/leafops.h:135 function parameter 'entry' not
>  described in 'leafent_type'
> Warning: include/linux/leafops.h:540 function parameter 'pte' not
>  described in 'pte_is_uffd_marker'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Yikes my bad, thanks for fixing this! :)

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> ---
>  include/linux/leafops.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- linux-next-20251201.orig/include/linux/leafops.h
> +++ linux-next-20251201/include/linux/leafops.h
> @@ -133,7 +133,7 @@ static inline bool softleaf_is_none(soft
>
>  /**
>   * softleaf_type() - Identify the type of leaf entry.
> - * @enntry: Leaf entry.
> + * @entry: Leaf entry.
>   *
>   * Returns: the leaf entry type associated with @entry.
>   */
> @@ -534,7 +534,7 @@ static inline bool pte_is_uffd_wp_marker
>  /**
>   * pte_is_uffd_marker() - Does this PTE entry encode a userfault-specific marker
>   * leaf entry?
> - * @entry: Leaf entry.
> + * @pte: PTE entry.
>   *
>   * It's useful to be able to determine which leaf entries encode UFFD-specific
>   * markers so we can handle these correctly.
>

