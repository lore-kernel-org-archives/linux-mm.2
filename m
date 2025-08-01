Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C02C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48256B0088; Fri,  1 Aug 2025 06:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F91D6B008C; Fri,  1 Aug 2025 06:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899BF6B0095; Fri,  1 Aug 2025 06:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB656B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:13:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D3FE1DC657
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:13:07 +0000 (UTC)
X-FDA: 83727775614.20.C2F91A7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id C86738000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:13:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Yo0KPNv+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=r+sMnjGc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754043184; a=rsa-sha256;
	cv=pass;
	b=i471IbqIxJ0khUhF3AYZUJNZP7zcIipo19frrSG6jgA0h9Zscqnh/0cvKlhYs8frRUCuJg
	uP9Vw4NMKo5Dx2nmseKfk1/dPFiRQmlnqziKqI5ZIK0Xj1PG44jZS3qdyu2s4NSU5bEpOw
	ruIcIL7Y2w0AlKTJyTWIgT6jd6+qUkg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Yo0KPNv+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=r+sMnjGc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754043184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/E7eqbELBV3eR1EFVAVfhc+KA7casTsq+jO51x2AbY=;
	b=4H7rd5ZCy/1g3dq7/u/BkYExo4y13gNrnKuPuR8r3lafLJuh0aNmdP8PJ/1oJramkyVCKy
	RK5Oy0P5ga2AYd/hZA6neH/C9S+mgcnmEAPpPoPxnCty5N/3ob++P9qGVIzkc1bCRulsd6
	yUrD4kpJNC5sT7Ipoev29PkGsqUae0U=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5717C5HV004687;
	Fri, 1 Aug 2025 10:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=i/E7eqbELBV3eR1EFV
	AVfhc+KA7casTsq+jO51x2AbY=; b=Yo0KPNv+k4XMJETWxuvg4tbWkvPE+HzYmn
	NdSMJ8CnZybJIxd16HeR6LxpycJRg2X4QvY7A1k55lSdOAGP9brl9xh8UQuRwMbk
	ac/yuYpArIuHdKPhNPR7arls1NgE1bluBO6z0npeQ9bp4Zkb1W4qFRLgEzEV1mxT
	K2FYBNVbr7Fm0Z0pSIpz76aAzfUCR9SsY9h52/3poB1LR2bO8q04/MSXIQKZwwxX
	fzGbVpC95ibSwhMy/NBPQyVlo5fppZLZv/5u5S4Jh5yMnJR6oxTlY+sNGR1fJjqi
	rdT0qq8rnTRN/oZ2lbGUQ2CAdrbxPpNWMFY6ZZeGjOFVxTEDAvAg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q29x3je-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 10:12:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 571A6VTA020350;
	Fri, 1 Aug 2025 10:12:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfkybkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 10:12:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fj57ciuEl/fLfa98wphwwChty3UcwVe5KSORXntH71CYsz0Z1GDvXsMSUly3Ax5o3wHzIh1Dkl2fEz6R5JKMtra0BpLOG7OjUWqVqeHga/qRdC3wxr5i560v+L5f+76/W3yaFRESpTkCPTKUKl1LizCPIEPOkQhVWqeQQN9WKcD6DN4dukG3t9PMR2Qjf+6AS0KxhxCf7i6RKdX407oD0GE+qVUKS4f2/yoR1JqhW7dQg1+bPs7AG/FRHNeNXTecxv0Dh0KO/1e1YMCj5PqvzDlNw2qqJ4Z0kjvTO/vKTeEZXkhvAOyDRmuWbU25S1IY0l3n1DKaVYmeU9ntztlD3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/E7eqbELBV3eR1EFVAVfhc+KA7casTsq+jO51x2AbY=;
 b=YpijLDzzOvTgYmiMdmqGr4clW++ek8vgzzRkFa0mOegSrpwsWq8lFo9QlVgLhXq+/0dRr4hXi3fJLJgUJva/mMVy/zXVUcOPrP+rTnvCvbJn52JZhw6qbImSpPsgtEUn/lm62M4UJdEosa1nOJx5axqwkjCXH9K4Ng5U8kvpHtk3VAsj4a0znfgjSQwexy1fCVXl2Vb1onHZYtbB1XA3YREZJoRJAzmtig4MJBEYhpCQU0jhYXdkkjmmC0C44cINQ32/+laz3l+GTwtNb6V5DdACwClUAKk4m90UpUpkCmmh1jwn14F0qlrmiilFbjwpzHebzfjO3rRsqkH2XXcygA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/E7eqbELBV3eR1EFVAVfhc+KA7casTsq+jO51x2AbY=;
 b=r+sMnjGcyhlGj7lX+DJV9It8JRINVhnVst+pKwULB1op/vdi+39tVmE8wGupCM9nW981sQbyT+NrqRcI2Smvl06WhmpDOd/BSBkzD1F+/DwmVNW0+XH78DXf53G6MfxECYGWGZNFpqoWSOKA+LVmpHbbQp9iK3Og0hvp54Ops7M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF7B51A0F8B.namprd10.prod.outlook.com (2603:10b6:518:1::7ad) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Fri, 1 Aug
 2025 10:12:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 10:12:43 +0000
Date: Fri, 1 Aug 2025 11:12:40 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, baohua@kernel.org, shakeel.butt@linux.dev,
        riel@surriel.com, ziy@nvidia.com, laoar.shao@gmail.com,
        dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        jannh@google.com, Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [PATCH v2 2/5] mm/huge_memory: convert "tva_flags" to "enum
 tva_type" for thp_vma_allowable_order*()
Message-ID: <de360a8e-6bfd-4033-b388-1ffae039dadd@lucifer.local>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-3-usamaarif642@gmail.com>
 <c44cb864-3b36-4aa2-8040-60c97bfdc28e@lucifer.local>
 <6143b8ea-24c0-4446-a0cd-821837f6e74d@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6143b8ea-24c0-4446-a0cd-821837f6e74d@gmail.com>
X-ClientProxiedBy: MM0P280CA0060.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF7B51A0F8B:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d0d2828-39a4-468b-b6ce-08ddd0e3f4a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4K1Ti/4kx9/Z+Lie6ntZy+Fwz+y/Oe420J8rg9YWGTv6/c35mAV4YBqrIAnr?=
 =?us-ascii?Q?Pyjr9YU91UqreaYXg+hbdbgmHDTnm48zcWiAmmOGkVFkkmv2YSSiv/wg9dd7?=
 =?us-ascii?Q?KqPzieiPD5g+U8dUbCMQOYqocW5ymGRl+8OSV0Al6Eh3EkyUxTHOEnpXEznI?=
 =?us-ascii?Q?zoUc2FxABjMepNonDC0SF5QgfT1HS4JCbl7GEQzU+esNl9qooBWP5vDF0qXe?=
 =?us-ascii?Q?bCkyBVjL9eonaC6ttTCf3m6vUGsiuGUMFhkiP5T5OATRm4+WoPbvOMMbHAnT?=
 =?us-ascii?Q?Odniic10kpw8M0xo/R3ezMawJBiG+7ESAYi8NbuhwRHwfimwzYqfXBLvhZQ2?=
 =?us-ascii?Q?pSZfxXCnFMcP9vekFtSkeseAJqhUoTECozvrfIJmf8nLAQkAqkZYQg9Byfdk?=
 =?us-ascii?Q?qy1uaWIS5oZFcIXyfLEuC3DzM+lKgFV5HsTYvvHbn0D5Z3E4jcIXli+Md6Ht?=
 =?us-ascii?Q?JK8WLHruB4VlqFUsNzYnnySfBUZipEHl6ARxP+mkpvvDyHmv9x5NIndg41bX?=
 =?us-ascii?Q?ugXRPplzuC9jO5Wk71VBOgc8f39KQOAeetqlvM4wTQGyRlf3SEU/SKK7WX4N?=
 =?us-ascii?Q?dCeOYTmKd1UGug6OYbvaKXzRP38di+72GFs8tlXNs+cnBB/lDkgLEqF8IB05?=
 =?us-ascii?Q?HHxdwi7TMVn15x3YilF24TpGKOX7/tzNtBdviD7KHY2UcSoexJlodFZqfnv6?=
 =?us-ascii?Q?d2yJr3a6sh7XtWUKBgVBq8lFupHbFPfmhb6Rge3/uhjmtyw/N7aAAamNXDPE?=
 =?us-ascii?Q?XnGt89bIBUg1zKG6QC/hmtnlK+i2IMnNMKaNqVnzpxAarmzXX5ZgRtHP8IXV?=
 =?us-ascii?Q?dzldT0yhjJnW52cNRUNxPv/v+GDhC01C+2XleGdxUiD/4gmKjvOfh0pFAZ2Q?=
 =?us-ascii?Q?IEJMBeb14L4mX9eSTyVFVVzbF9D7EKbXvVBD8wiiBcpW78VMVe7EPbq/OOic?=
 =?us-ascii?Q?J70e+Tk2Phge39uAr8SJgMkVg9fAXqIAYkhlPKHzsjbz4uyDLPdrGCsvEHc9?=
 =?us-ascii?Q?ZcEEtwuRHc3cv/Nbq/YUEISvtPqskKhSIfKysaSZQE+wPQdmejkpHw6Btixy?=
 =?us-ascii?Q?Ghqm2zHMi+K2Q2lMX51wjCKoXKIhcmY840T+ZVinBj+8S9mmXIFJn9mvILtH?=
 =?us-ascii?Q?ElCNNXcFCz8vQHEemCedHVkZw+pAhvZUUVDTJ1cJLMUxnmIbsgyp8h3TuFZ3?=
 =?us-ascii?Q?oFumNScFbGx9lJMC+0O+OaPOhqyhPZDreONSmDYAski6AeDdQZvHdMs91qrp?=
 =?us-ascii?Q?+D92X9yDaGsGMYWcuBNVAZNPYgxTQ0h8pAvEpLzP5NlEhywfkElats73uLny?=
 =?us-ascii?Q?yUP8K1UCbV0kUW86B0b/SNJYpLe/ASveIaz4N3W2qVEfQNOtBB/tjh02YSmA?=
 =?us-ascii?Q?XTpxeOXqqlFq/qE76Y5g90vIMstd4FUyehWQqJuKWNGpeBzzDAoVkI1Mbmhf?=
 =?us-ascii?Q?QQHqmpkptHs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sYRGyiwl3uS8AlYQFP7fQtSE/tgC+7XCRpB/K11ic6RfZL3oVHc4QdDKP7Eb?=
 =?us-ascii?Q?W6980lpTdLbw2zm46SEcqk9gG0E/JiGxSsGtXd4BuNmOU5VzigoW2Mue4OxU?=
 =?us-ascii?Q?c+Zirupyj4R/9/aH8Bzj3lA0ZZlX0/Ml+jJ35vGkLKHzIR9697EG4TclXw1S?=
 =?us-ascii?Q?YBGPrjUSyaMv1Xr9rhyniyfK/DpGsAwxTf6YtNqyL5qQ4FoiSQflAbjKGEvq?=
 =?us-ascii?Q?iNhvJQ1q7BlDXyeLwjRpAVG/v1iIzIAGsVoVdVkP0yOad23H3TsBsYhYNipF?=
 =?us-ascii?Q?8+q1mK0tgHBH0eJCOcXi9v8V+riOOlvc1ao+gm/AxDMct4OrdtgdB9kLkbvW?=
 =?us-ascii?Q?TIjCevruwtzPo1s+b+ZObsoeM+6/BNMPWYYlutXYV/9xo30Es5jOfXQrorO1?=
 =?us-ascii?Q?QSB9dagmSo1vRr/nIZQnI8A0v0uCdNbhr3DFksKP46wJuNwYBIpJurKGksim?=
 =?us-ascii?Q?OR7L9UFVm5KUNvoOd92+e1e1wTnRU4vqfgKg5a2/V3tWomqGVBVzGFXouTcd?=
 =?us-ascii?Q?4SLp3qt9i3d17kvkycQCPN1EDWsoRdyOa1EsYMO2sJ0wsPzpbZpLHlAS9fkr?=
 =?us-ascii?Q?6U6lTs/oZEmTcZFYtqnRgvT4LCuC888Gd5KjU0/LP5ijnFEo+HVrQdgtEfry?=
 =?us-ascii?Q?L9IZH2Cox5b7XS79DJyQsLsxIq4xgVVq5hbYF1ABWQ+xAHVv3hWm1hitDWen?=
 =?us-ascii?Q?xMDMOfH3sMJE/rT+aSyR+tER/kpu+/MNIQHH6IrkWxWzhkYISJCKLhzIlUu3?=
 =?us-ascii?Q?peOkfm7GU3LooDVOf+k7z3FONlL3LpWdv4NGcOkhQ1i3nvLXtetetHep2EUf?=
 =?us-ascii?Q?zOspoOXYsv44z1odkpcCMAlKYqfDLDvgxYtXqAU5Uit9C7MS8WprsXBPfh79?=
 =?us-ascii?Q?QtiToau4iYl3x/5sjcimz+Zs/IqzMJJ0zBurIH627fW2WCFIkLo39lNh23pt?=
 =?us-ascii?Q?VioASWGN6ec/ZMmiyfFL1QwzR3YpkrxDBc7iXjvonWP3JPt/wgN22gyiqqmC?=
 =?us-ascii?Q?p2olkaNZgyAyFGWETjNfEL+pEpH78GztLOSXyoLa8S9scE9LP2nMqIfQ7A2z?=
 =?us-ascii?Q?+EB6RF6Edr0fqX5nyeeqDiKiJidXeQNhoiW9cV87pG1Y1QviV4k4QGVtGdq5?=
 =?us-ascii?Q?Pu9+uBI/Ej1hrGeT+HeCvEGHDoVYHR5YLo4A0ASeZz4xhsLqMW0DDk3SSVf9?=
 =?us-ascii?Q?UsjkIHkCHZy1CJc0BNBFiDuZ9fwR21zR6HZx9wUwvE5ZS8Zh6b4YZS7cd0lE?=
 =?us-ascii?Q?KJ+PS6bDQHCQJyUy43D3Etvxtqf3LZ8+YSg9Q1whQC6qJ4nQKxxw7tlfTSt7?=
 =?us-ascii?Q?a0PQW7jAnHapAWhcfQdhXBx+XfkdWbQ/OhQ9vMfoQEIwKwd5slqEDNhK8Rac?=
 =?us-ascii?Q?8Q88wzugtdaChqsUWnW84QIoJBlp7GG1CeO6kGcDekNkoAHZWBRNcb0fIvTt?=
 =?us-ascii?Q?pL/RnBJEje4WFugKhHStHEfz2Gq5+JlklM47Ai6BxpCz3O1g7v13HN58ce/d?=
 =?us-ascii?Q?W1oMpfYhhtI4HmJvxeSayyI1B+BW77pKdtj1tvwnLMOtWXvdvgl/u8ikDsr3?=
 =?us-ascii?Q?w2VQE/xcrjvOsOq+7DdZOVYT1JCwxnEPVb5MZzUdt5X0MKQco1wVuJ3VqlRk?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cjmvl8BcQqPsBCWxEGPGe1fcOQoq5suEGaCzSE0jzEtm8RfyLYknjA+gS/qGxHIWlfXxzWIdyz78tlyYU+ohuFrlrYhBp5o3NNbkZ0r67dI+ndZSkAWmLOWoVaHDKw5W55cBdqrazIEQVdXb3oE76fn1qq/f5UKHvZSTBA+0+MbYBd2m//VBkiaToKzSHYzZHIhtSSegYA6Q235DoapuYTW0sYJMxTBE0ZJFDQHhuaHRPyL2v7a1w+j3ro5VA0CcZElBspBBBDDxw69RTHpDj1FPZq4YaMoU+TNU+5ADFQw1pNZe7LTdwjGF9T47JMJY4cbLvGNW/4wd0P6VNbsXIuUkdO7zdOFNp1axQarFOa2VX7qyvvFKLAHQxH8cFfeLmRms0acxvm65h0lluiarlAVoTYiS7JUSRzRZ3NkLQ67ZS3v5AFo2idnkSS/e/Lj7Ixe8JFoi3JVYqNuBPolHLffwalPjszJFx28GHTF2UBA0AZWeWfooTXt1aN1TM7twEZiiDMAq8JS6Ncdt06AxyJS4Dk6e+LvHO5F2DqmUe+bJLDYmjIJyj6bZImlF6Tqe3imExUWL2UH+bcwBgyl3zIFgNtV7tfKxMtJINoDPNic=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0d2828-39a4-468b-b6ce-08ddd0e3f4a1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 10:12:43.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6s8oKH0R7mvekdlhLpzv2I/AUHy6XXGedsf0obg3QFI1jhS53l3FEwECM8OioS26jfR5v/Luxe+3GfiSQn0LCqdvhsJX+6PQvKhr3xAyKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF7B51A0F8B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_03,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508010075
X-Proofpoint-ORIG-GUID: m_08y0IOTkZga7xFDx4ENnSVLuEmHkVj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDA3NSBTYWx0ZWRfX2jA6jAuTq+3P
 k203WCDJcA5LiqQDYmiy9dXfLL2aTgYQzC4jl2fHOXExeQEabbpgHPh2GTNJcBSxxwtor3Gpx+W
 j5FTXn6ZiYG+1KcUcirvhyv3/cde2VrWSLQnYv2oAtWHwdCISwzSzrHHKhg0JTfVXI2Rg0iuxGk
 5HZ2UiNHqTyqFK3I7Tz9swbpUpcSPnI3M65HOMwwk63KfcD9HxxdxxX3Wz/YF85QymYvKKE+qt5
 RryjoTeFAVHj2FbR4gRMZDqGWfOO3VrntC23IT9Mbi7CdpCxr6fGLhXR/m7FEJKoU/ENtamjgXs
 XVTr9eXrqdwIDTKCHYnJEItEX3UDAkQsrP6b7vc3t/fEHdgiRhtMiMAqVFEVTVseBWQ7uT2+a5/
 FoNaF/CJ/tNRwVzXthouxyVamg88/kYNcu6TIak/dbevac4SHpvNzYjTMU0C9Uko9hqsNklE
X-Authority-Analysis: v=2.4 cv=FvIF/3rq c=1 sm=1 tr=0 ts=688c9324 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=xR7C8T5FZ3QHdc8ZM9QA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12071
X-Proofpoint-GUID: m_08y0IOTkZga7xFDx4ENnSVLuEmHkVj
X-Stat-Signature: mfjy8pjyawz4jbz4paefxpejjzau4fyn
X-Rspam-User: 
X-Rspamd-Queue-Id: C86738000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1754043183-292146
X-HE-Meta: U2FsdGVkX1/WGUvw5E1bEEBqK1u5XZBu2aT8KYnugqarth6PnUBU8eNsWNbZbf+Beg+OJIZKEt+91pP/CeHFjWbhiWIyphx93/oYw7qffejL6wg2oWBPbTeuV8ZaanBs+rjurB9/xvRE80MUW7YZZ87zh3PzYhMidZowWnr6zoqvBSo1GPkNycWFrwPOZIOYfcJg96eMprlg2t+8jalesBCTKJp0Af7Wea6cERwRATxI3HUwxX4UzzwSHDeL4jcaavIaF3EPPTgqXA8yDhh1tydOc/Blz9724r1LTmB5cTPNkbaSJUmaRc6/9jPj/KHiCc7EEjngIBezrHN0ESdUiWQwKczin8CvMsVt6W9vwuhL2yQjHe3CndRme1mMMHg9zCdR7fpo/6QfRkfKkiMFzT5VGtRAkkWrlzqLH/JD2U5P9ys9ITeFbSY7DmF2OC10HfZHfEdfdErr/UziWOqRjpIeClVkkSVFZ1oGm6pziux4Eou64V/XllZjq0IYUZUNLws2HGBR+BJoY6aoUERPTLqKAhGz2h9y9ftn94iU7lo/j7k8/x+WYXt4JwQhnsKzL2UbWq16pHhbAzUQSGuJ+SWqlsslSjh6y9A98CddFP8psortvTVkSL8aftrZYoCMW9tJN792sHgNynQVX1x53nXz98jp2fw7ilX7ECi3j0WU/pjlbHHB/mnrNvEfDOQ9+Q3Lyg23ZK2t9A5RCaVArNWiY2b/U2x+12waHac5u2dIRlQzvCZjG2uHGevU8kbA+9Q1qvYo5nvgeApYtf6YXwWOMrJ0JBtnmKVJ11ZtPLKO2iCp20/NjugW9bcUcQvSlTvKlhdg5qjYg2TB5VPhzX8oUvDIkc/4eHZ6G+LTc92oZhbCPzph/SuTN2bdFjHt0rNICmIhSaevwjOA6/ypMYjj7KNbitLt8xuNqRShNwxKu8m/pzGchmz7R5NItuvRaGqiQDhfSz/yciqyYo1
 O7YQg8kP
 f9Go23xnDClEbgH4jHpP/VmSrtiB1im54itPU7vIDI6kqyajygF1SNWMG0fOmfBd7yKY4JrjbInIFscyL2qE2kHlj4S+1JxnBIZ/hjWGUL7hQ/ijWL1XkzB6LxOFDCzv2L2Adwh3ahhCoGsCPm7jTNe+Mz4HsxA2P8f3P6KwGrzm+XQQ+4hG+oAFMhD3txujtgGwN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 08:20:18PM +0100, Usama Arif wrote:
[snip]
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >> Acked-by: Usama Arif <usamaarif642@gmail.com>
> >> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> >
> > Overall this is a great cleanup, some various nits however.
> >
>
> Thanks for the feedback Lorenzo!

No problem :) I'm glad by the way we've found a solution that serves the
needs you and other's specified while not encountering the issues I raised
concerns with, the approach of extending this interface I think is a good
compromise.

>
> I have modified the commit message to be:
>
>     mm/huge_memory: convert "tva_flags" to "enum tva_type"
>
>     When determining which THP orders are eligible for a VMA mapping,
>     we have previously specified tva_flags, however it turns out it is
>     really not necessary to treat these as flags.
>
>     Rather, we distinguish between distinct modes.
>
>     The only case where we previously combined flags was with
>     TVA_ENFORCE_SYSFS, but we can avoid this by observing that this
>     is the default, except for MADV_COLLAPSE or an edge cases in
>     collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and
>     adding a mode specifically for this case - TVA_FORCED_COLLAPSE.
>
>     We have:
>     * smaps handling for showing "THPeligible"
>     * Pagefault handling
>     * khugepaged handling
>     * Forced collapse handling: primarily MADV_COLLAPSE, but also for
>       an edge case in collapse_pte_mapped_thp()
>
>     Ignoring the collapse_pte_mapped_thp edgecase, we only want to

I'd say 'disregarding the edge cases,' here as there's also
hugepage_vma_revalidate() above and being really really nitty we say
'ignore' a 2nd time below which reads less well.

>     ignore sysfs only when we are forcing a collapse through

I'd say 'ignore sysfs settings' just to be clear.

>     MADV_COLLAPSE, otherwise we want to enforce it, hence this patch
>     does the following flag to enum conversions:
>
>     * TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
>     * TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
>     * TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
>     * 0                             -> TVA_FORCED_COLLAPSE
>
>     With this change, we immediately know if we are in the forced collapse
>     case, which will be valuable next.

Other than nits above this looks really good, thanks!

[snip]

> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 2b4ea5a2ce7d..85252b468f80 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
[snip]
> >> @@ -921,7 +920,8 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> >>  				   struct collapse_control *cc)
> >>  {
> >>  	struct vm_area_struct *vma;
> >> -	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
> >> +	enum tva_type tva_type = cc->is_khugepaged ? TVA_KHUGEPAGED :
> >> +				 TVA_FORCED_COLLAPSE;
> >
> > This is great, this is so much clearer.
> >
> > A nit though, I mean I come back to my 'type' vs 'tva_type' nit above, this
> > is inconsistent, so we should choose one approach and stick with it.
> >
>
> I dont exactly like the name "tva" (It has nothing to do with the fact it took
> me more time than I would like to figure out that it meant THP VMA allowable :)),

Hey, dude, at least you worked it out, I had to ask :P

> so what I will do is use "type" everywhere if that is ok?

Sure that's fine, it's not a big deal and I'd rather we just make it
consistent.

> But no strong opinion and can change the variable/macro args to tva_type if that
> is preferred.
>
> The diff over v2 after taking the review comments into account looks quite trivial:
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index b0ff54eee81c..bd4f9e6327e0 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -98,7 +98,7 @@ enum tva_type {
>         TVA_SMAPS,              /* Exposing "THPeligible:" in smaps. */
>         TVA_PAGEFAULT,          /* Serving a page fault. */
>         TVA_KHUGEPAGED,         /* Khugepaged collapse. */
> -       TVA_FORCED_COLLAPSE,    /* Forced collapse (i.e., MADV_COLLAPSE). */
> +       TVA_FORCED_COLLAPSE,    /* Forced collapse (e.g. MADV_COLLAPSE). */
>  };
>
>  #define thp_vma_allowable_order(vma, vm_flags, type, order) \
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7a54b6f2a346..88cb6339e910 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -920,7 +920,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>                                    struct collapse_control *cc)
>  {
>         struct vm_area_struct *vma;
> -       enum tva_type tva_type = cc->is_khugepaged ? TVA_KHUGEPAGED :
> +       enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
>                                  TVA_FORCED_COLLAPSE;
>
>         if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> @@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>
>         if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
>                 return SCAN_ADDRESS_RANGE;
> -       if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_type, PMD_ORDER))
> +       if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
>                 return SCAN_VMA_CHECK;
>         /*
>          * Anon VMA expected, the address may be unmapped then
> @@ -1532,8 +1532,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>          * in the page cache with a single hugepage. If a mm were to fault-in
>          * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
>          * and map it by a PMD, regardless of sysfs THP settings. As such, let's
> -        * analogously elide sysfs THP settings here and pretend we are
> -        * collapsing.
> +        * analogously elide sysfs THP settings here and force collapse.
>          */
>         if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>                 return SCAN_VMA_CHECK;

Nice that's fine.

Cheers, Lorenzo

