Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 455E8D6CFD1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 12:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9586B04C3; Fri, 23 Jan 2026 07:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0EB6B04C4; Fri, 23 Jan 2026 07:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E3D6B04C5; Fri, 23 Jan 2026 07:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E53B6B04C3
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:45:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AB481A023F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:45:32 +0000 (UTC)
X-FDA: 84363199704.13.D3C71BE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74B48C0014
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:45:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gdOh2V6T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jVjRCF+f;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769172328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxBWZ68ctIfDraRFaZVc9pDW+nnBTJDRTzkPzk0LXT4=;
	b=pDG8DyYZ647vq+YAZrp0QYC0N/vf8AP6HYX7HxWkDSZFRexlszy3g06A/LVhH6tL1pqw0m
	HC27hd2tuBFNRwADMkKyAZrFKgswkkkjsHngxUnPhOQo7GRydF3EmKpT3Y6aawFhiYABED
	a92cOZHewtuCrLIyPMFoqqis/ebFcf0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769172328; a=rsa-sha256;
	cv=pass;
	b=4HBTY+NBhLJzH7kzqj+DID3LqX8mpUfEMeSJ0F73XUq5B8NomD/EIx+ERYAA8GWbsNifm8
	IiU3ir+WBMO5jaF5OtUIelhBz/7aV2zbuFhysuiHBvV4CTqrfSgd0S+7YsBCT14GwDQ6jo
	qAWv8eSHSD44oDvk5HTecPJn/E0Qi2w=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gdOh2V6T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jVjRCF+f;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NCAEQd2029533;
	Fri, 23 Jan 2026 12:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dxBWZ68ctIfDraRFaZ
	Vc9pDW+nnBTJDRTzkPzk0LXT4=; b=gdOh2V6T8vDVeE9kzYD4ZZzFXU8Ekl4GaX
	/hnIWjMjKcIL4blVJs3QBXmAXlZncnAYvKP2ffIcOg7oWgBn9jVN8BluOfco4xXP
	++JbDXWXZIfokTjxJPu8eXgXsk441GaQfARRorN0edpsYS8f+u0ztnxOHbIJHMKO
	D8QWak6/Orfo++1Gk2iborRIk1+NKDp/ppmMFE0HeJ8z1Ry+Rbccb7vEYM5VBDGp
	YnOuX6CXul1nfcC2Z3o01BCiBCtnR2NR9iGTbIpIbZvM2NlSDF8x0dDgKnWBG89q
	CSaargixFwpgzaQKTFkmWwHLlyjU6vdjwvhoZGiP0D3cfjQXu0Zg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5t7m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 12:45:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NAg4KU035795;
	Fri, 23 Jan 2026 12:45:22 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011015.outbound.protection.outlook.com [52.101.62.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bux4y5f9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 12:45:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXbTJEAZIAiNraey2BJ8oFbM2EZ/S1Fr8rvK58wss3hANndT52MnHR3anrVuxuQkUiRKJBZ+dfemzVaoF2J03uQ+PAgE4JMuvZKazmOKOhVnWXC5Ao3wKR5WCwcfpbjqOfXx8tSa0A1tk8bSL6lz2Jyaobt+zlnFcF+1y1x6RmiFk2so9chHjAMCx3XGvUJyOCoCtJ1Cbbn4Yd38JZRIL/hF9GqcLXaCL3nok/5PLljorHBUtqYdhetwmhI8IDQ/i5IS+t2sZS0jzIPsBrcJCaY96GJJiFy8zx9KxeNElrJ11oxsmzrqV9MBKHxHDZ/f97ROPil50F5oBZk59BVZZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxBWZ68ctIfDraRFaZVc9pDW+nnBTJDRTzkPzk0LXT4=;
 b=KYhydM6iU1H6nDOn+LIsRCpbShf/7FVpveB3EwZauQ7ZEFq+8GzHMCGPKDjXhMifJWPasoz9ATNhVeW6ERD0QW5fl2RS83Gc1HkcBxntbIKmhWfI7updpfEE9FNDecnk3kyFyyYV2pzuo5guoNyranvHZ3wLc3N1UnOKfGcj1CYThm4QiDObKvIf2Vt6z7+nm5oPRYa2lWaL0CN0dxRd05KB6W/agX1NXeFN2jfVn5YhbQ9Z9u0jdv6PI51PKyYqw9+N7yr7MoZLDfe7bouLuDBXR6M4pbl8RKma/7+KWkdnGLSm3q3i3lmsK2M8GCfvKXM3Q78NeREDsF3FiYDhng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxBWZ68ctIfDraRFaZVc9pDW+nnBTJDRTzkPzk0LXT4=;
 b=jVjRCF+fQ5gyQj5eXIfUEUpyP3HPrX8CmjJ8INbzWqOe3RFXUbyy800zJc4HA0ep1ZxvgyP/BF4cIyArPl2ZyVCpxAUjX43ckhfDSvheiKx4t5UUHNEr3R41mn1YqYYF/ptQkfmXS8srjJuE0CrS7YGVs8ZTFyRT/+gMZADwQ38=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6855.namprd10.prod.outlook.com (2603:10b6:208:424::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 12:45:19 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 12:45:19 +0000
Date: Fri, 23 Jan 2026 12:45:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Have the harness run each test category
 separately
Message-ID: <3f345966-37e2-457b-a917-1f0d4726d669@lucifer.local>
References: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
 <897e1bf9-d29d-45da-926f-0c28558f8990@lucifer.local>
 <99b95c45-7bd5-4fc8-892a-cf9c69335706@sirena.org.uk>
 <04fc8a05-245a-4422-9e27-704ae2d2894a@lucifer.local>
 <56e2d214-fe48-48b0-88a2-287294520cb4@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56e2d214-fe48-48b0-88a2-287294520cb4@sirena.org.uk>
X-ClientProxiedBy: LO4P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6855:EE_
X-MS-Office365-Filtering-Correlation-Id: 232c140a-4096-4d5d-7f3a-08de5a7d43df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2IDX7K8iElHe/qe9ke+w/TqKN7R0oJW5eVGQjg8Q7VRUKmQVE8ctbgbj4Fwx?=
 =?us-ascii?Q?Lnmf6dMvmcqqY4DUCKQ1rxFrxbK2fB4V8fcLpUR/TuqQ8EF/khFpiz2FEDbr?=
 =?us-ascii?Q?deM3zY+Vn9gob61n/0z4q3BgQbXCdQ3RXzbBK1+jgLKxWFmmUlFABcd7IGz2?=
 =?us-ascii?Q?kYpCBitliAOMSh/zL4v/6p6dGFQIKMOf59fZzDCfzrHD88sNMGTA9pj+w+5t?=
 =?us-ascii?Q?fULeiyLX+KSklJdxdefKw9or49EMVNavcUVpcbukoiwsOBJsP7dbtEqArT3u?=
 =?us-ascii?Q?FSX1s1Y28t7wbvojPD+Lf1cU+Fz9VM6wuDBUpurfWU4/g6bWgNkbSLxQcyyh?=
 =?us-ascii?Q?g1snMHpGpz1fP33kKwvpjOrbfMk0geGROYud17wGiab0BbWIeG2I0adVXnTi?=
 =?us-ascii?Q?uQZgx2KuPBIWORyIqCfsq6ero6vidF7yXpSp96XefVoCDkJOkEyh5jtdBEFC?=
 =?us-ascii?Q?IOTt8/t2+iHd7UsBjIwavfM/bB0K4wM51pDjNDkE32ijogaJ0OBCcIAxZroj?=
 =?us-ascii?Q?hHR31Nf2sqGIAPPu3EaCRQW4JyGEC6ZHfQkhwtrysHf7Te2+AoJlqNDe8b1D?=
 =?us-ascii?Q?ApGSi20S0O+GrxdN7NeM4elrlqQ8PohymKRiurrF+uDvZvF3NzCdhjhizy8Q?=
 =?us-ascii?Q?fV3S3GAdAgw/nD6o9e7eav71/j5bhLeeIUb3PIi5J1sd7zjLn7bYPlnZeNlA?=
 =?us-ascii?Q?EROGmu7XedlYxOv8Rs6B8e0m8Md3YcbixIKHJmSJKtLAV7beR6rRhpgmGNFt?=
 =?us-ascii?Q?+0pwnXutrlaJOpSHtwEBgrLOx8zzNcRKhKx/6hSDUfKvZyqOQB6+6Uzjd2Nl?=
 =?us-ascii?Q?0I2NkP2TQw1Zl1+1IRuqOFcBE3xwUA7cui1zxwth7vQVaapykBDtwVKT63cm?=
 =?us-ascii?Q?+CV7RfadomdJBJfukjfJpbhwUOoJCXgFJEccGBCIsyzwKVMbtqVKcicmrO5i?=
 =?us-ascii?Q?JhmOAQHy8GJvfQ9IfO07veq4ydQHJ7vInNHF7eaiIV9J1OY/ymrgbP0dMprx?=
 =?us-ascii?Q?r7ztWW2P49rF15+Ly1xrXB6UbJn4tX/lTS2hvHFEQoDmez8roMeqryr6X74Y?=
 =?us-ascii?Q?d/hfZVK8dro/oSWieM6PUxfCbdOLCIPAs/0hhiaKrbM6foLuaT6XWMLytckD?=
 =?us-ascii?Q?3irwW49wXTFRTdYNpVrJBZp6IbVG77f8o1P1vx9lWTdslacNblpRlskmM0hj?=
 =?us-ascii?Q?7BnWaiDv1VUOpbnlRROEwi7OL6QfvGQl9na0gEnHtSE/JhGtnbBPxVcjeT8Q?=
 =?us-ascii?Q?ZKYRyTZeSj95icvHFd9D1SOYwhaykj6KyA0LRQyGM2OCjjKgJtVrQnrxU2w4?=
 =?us-ascii?Q?eI3oT6ppeUi69dS4HDP5d4M0oSfob3Jf7f3ZhxNwR6jWNjLsaEqSVcoTXA3D?=
 =?us-ascii?Q?dON8avwlb3IY9QfunhSonr3TWir9sSmdMl4Hh61GGOSlaB8m582TovkYMsbs?=
 =?us-ascii?Q?ot4uHN3We3O7K3lTLgZT0dnTAe9Gi1mU17H0Sn61irCrt4+AhTy2xjO3PsTX?=
 =?us-ascii?Q?DliBAU1Pi0LYS8MVquUKjK3J166O7YD+gOM/e8eP0IT7FT/xIEdvIlHr4skA?=
 =?us-ascii?Q?ChJIZoalYdSaFU4xB08=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CQ5FoOHH8yuvHyIIQQmQI13WQXmzB8kMraUhWxoFDw61dhbAYe+TjuWvoDQS?=
 =?us-ascii?Q?iUghNmI4JydHzHWgM0uFoUb++Dn/OE7nU5Bj97RdQIh7LfiEvdwk4kOrOJvO?=
 =?us-ascii?Q?ca0ZAjKoZJRJCl31b+tJvJIeGXCLDaV5zcyWT8aciteTlckP5yM/4Fg+m5Mp?=
 =?us-ascii?Q?IE/uwVLfSuOcIrAcIzbU+b78T6DljKoIL2rpMqyJ4ZzABYPs1XyLsDzCNxYN?=
 =?us-ascii?Q?s6kmA/eb1o+AIdCZ/FzmprpXimcoo5w78VCdxLmVi2EIaKdPFPJjJa5uLhPc?=
 =?us-ascii?Q?mmGnZkneIGVymAfkFOhT6ruX9Ubca/J0UTMsRqupP5ZZcnJm/5PptPlkftKL?=
 =?us-ascii?Q?Ekdl/ScbK4ui5o0nebvtzvkHX/Ez3glhFpVS2ru6Sq6Z4WSIYei1U1Mp2ujb?=
 =?us-ascii?Q?opJEvQsalROKt6wlAg0TPR6wzWnXdCjsrNnYh9VCdgF2OamZryNeo7YX09cG?=
 =?us-ascii?Q?Df0NFbN3VFem5jKLxuPO8XYssnTE7vQnOC6vr1HNlbszaF2gjMbdHY2OIpkK?=
 =?us-ascii?Q?5YGMQyDCyvuMuuuKMaWAf1awPPqdijc3X4FWgL+LRypCNyhW6261p08E+U6Y?=
 =?us-ascii?Q?Zv0uXlv6cItjdLoTGkD5QRpJKbwREtrMg5NqSLNtRxuMoVroc/cI+m+/mePd?=
 =?us-ascii?Q?qTfm33icJQj27WIxUvCu2J+EW4iIZpHSYQDAylzM8qG3uPwNw9kw6+XN9c18?=
 =?us-ascii?Q?rRcvBNjjYvxyc6mRR6TXKf15RpSuuHavHTfITkGTg9nyqLpq50Jwk+66GB1e?=
 =?us-ascii?Q?VCpUfH8qzz5YtXvPpv07LcxPg9tWlWMEK+rcQS4brPVoADh0qFxrRNeOa6XA?=
 =?us-ascii?Q?nX+JTS3DIMvTAecasED2E/fpTvbNQkoE27DlR79sEyVAi55V9aThgMUAdpyw?=
 =?us-ascii?Q?4MtTBT9g1vqpkSc1eDPHd5bMm7aXQVA2AKgzkPUFyJadjP0hjnMcgVvbFyPu?=
 =?us-ascii?Q?JS67pVf5HJLIBtH0p+8az4WsSAP2/C7s8Ubklz1MguQLpvX8/nRIyoqfqEMw?=
 =?us-ascii?Q?MNnVOveR9oLpMBLnXOfuMGVj7cqPqLv3/4gNO0Z/vzeWCOT/auMdlvl8AS1r?=
 =?us-ascii?Q?PVXhsbZFaT0ENuqE+OECb1D/e2e8pyuqEc0jTogD2MVuW0qsE17PFfJTwur/?=
 =?us-ascii?Q?k1Hx3UXu/igb4NEOtnV2Z+81xXSfVni4bdUXcXCWBwXdo3PHltfwfbM/gEyk?=
 =?us-ascii?Q?Hmy8FZ72UzyqIzb125K5H2IZ1Nex7nZ7w3YpKztazu2ihKaNLR6QbY0LaPqq?=
 =?us-ascii?Q?cT6iJHrLQafIBKPbg5a5Txd9sCVPpE7Y7kOKEqbp7aFqLaszeIMbw9J19XXS?=
 =?us-ascii?Q?qNRzQSSjd2LL5fWFMVSEDSmvNaYraCGz0QJPnhmmpPZVxdPzuaC2nZOvixl+?=
 =?us-ascii?Q?Q55EApkOFKVUoC1lFvycZKCTTPpjtOmOLtYyWU4OMZBM81ZhmGLvCUxcXFG8?=
 =?us-ascii?Q?xlkAOBNoi8u3/3nhsAQ3+n38oZazH4hc3oyMAC1k06+haDpOz0hbgOWRkgQn?=
 =?us-ascii?Q?CadGKAHWSxscBGDeTcmbFWhdRoj/IDSn0yTkokzXsFCW0Q9KT6a6YHyP8rm0?=
 =?us-ascii?Q?nS844KKWJJLNoVJtLf3N6OFtatmuoAg9NYvmNjKVs4ulZxQTSP4hhF4eDe0e?=
 =?us-ascii?Q?v51nIhHyLFXrhLJujFTx9fGfMFu45A0ruqsQSMh176thAi3kUzKg1NjGBnz/?=
 =?us-ascii?Q?wYNVtyjWpH3UpEb9W9evSdgh0mNYdW2JDc6l0vqt8luZSqTk1opndGSdcmi5?=
 =?us-ascii?Q?VPNAWPt+kOYN2xB175c5TtqngafJ3ME=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3KBq+JR9/5jF4PERPq76Vw/iOCxyvxeUzB5Pa3K5vU2ZXFZAx6cq8BcyqzoWfVa9iHn5xSpmrU06By3PsEjml9oGodtMVt0yLZpyrGJrqTRRNDFRW9QLKB18rjGc1wWlt1+zY7MOSDSY6SDE97STLrNBu2blYebP4RQ90KOHYLHjHp6vkCb5tRI7eeaNgDdFAkcy8SOJO3K8k8maWQh9oIAxKFjrBPE1glMlsyErmRI4yMsrjDCJgOaLqnwv6m5PbWJW2ic+bNGAuCGETXTOgo2cGwdbOTWRGhG8XozmQWKeX0hHZYJymPImtiqhQ9aryD6Ig7JqSHVfxgL/1MeM2zTrVdxN6nyFma//agNlGCEkWLYJ3n0Qlj0+Dx0REIITFXBwV+nsWeyj5vrVNBa49zVVV7vpACk0Ky2TrW79IJSX4xLpi0YMZQWZXaqoWWoBGA1nh75hWVyrFohYOT8KTzagkT6Blmh2NpmPubJM0OIBNNoGZqX7/9A3aMwYr/DIhhXUMZoPLbJguZJ/BdxubStOVZD9HEtZa2JYEp+x0wOtrE4UJJagidM0/kIp3mcSfIuC1ddasbYnl99QfpeaEqeHVUc94mnjTco/6BEaUtc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232c140a-4096-4d5d-7f3a-08de5a7d43df
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 12:45:19.0011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtgkmrrTyZaHamYNqSthV+MSXQ0nLiFUC3VJbVkYqEBjcFktlQe/LgFpdttA/yBHMIG2ZE3p5/BMsMBlmx5vsJHFoL+CHT8aCusxCRl325E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6855
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEwNCBTYWx0ZWRfX6XY1kEWpQtjA
 x89GqY9yeRKkLPvuZ1TKa10kMbst55VqP7ataoP7JlO7SV8iaoagsnzw76LmeXiXhhvzPyyMYKg
 6OQS+AYfWHPqR8xky+RnBOv6cT7seWxzyZLZ5xUB2yy97y7YrlV744zH4KIvtKwwMSn2HZsBd4F
 PWXayN+GTaxthjhY2a7D/5kzG83GvaqLN+7MjiHB4EBNndb7gdSvURgwY0UQK7WOia415W+4+mK
 /r9Jjct5lsKUffvheLlIhtD2JQ1MEjpvfIj0B3fluFVMLdIK+CS3HoowpP678hc+RABNHDfaXSB
 EeghqE+h+1Zne9VPx94PH7p1YlIb15RGL2NC6yY25BLcyLDwYRvcXmsvKR+/NOEHFYQ3kYjiaCH
 r9mLcFQB35ME2yL6z/TtcgZN4KcX1vPCAN4+0Yzm7zw4JCFDyD15yi8FVXZXAW4E3cWSJ6aKiDx
 uJGc9zfCNd2l3ceX/0w==
X-Proofpoint-GUID: QUfHu82ogZP3NXWZbJgKoHejmMFY7FZM
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69736d62 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Hrtu05uGzoMjaYZci-0A:9 a=CjuIK1q_8ugA:10 a=YMys65Cr2uQA:10
X-Proofpoint-ORIG-GUID: QUfHu82ogZP3NXWZbJgKoHejmMFY7FZM
X-Rspamd-Queue-Id: 74B48C0014
X-Stat-Signature: 8borfot1tgqnupuri4zopqi4bgk84czn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769172328-935403
X-HE-Meta: U2FsdGVkX1/QBQgieM9FdHSbeWm4qrR4KGbdAuFAVs8s73ftVQ+glojbCb2YSZngR2EsC6bzqPnMNxXePotxcs+kP1HaZMwfiNKZsV1RiL4hlddcD4ULxRdRBo+jFIB8WaODOdd66JUgh2ou2fTly5SckhW1KASUhjDfX7j6o97nsBpFPXtf2WQUJ7BzasljQcnuF+ihWbWBN/iEcr0pz55kPvFrfQmK9PG901Gu7EhGoSbHtu3nWV/WQg0Boh0la+dIpzTrif4hqbf8mMaNpoCmedk+6RQB2n49p3VUxzspIOXg5bSJEBqtI5gxZmBaZFINdP4GHsTG6Mj2t+ZCQ/pmVo+mNOnx2t3BZz2rqSf+6PeLs06Cy/3SaGJsuFIn5V1mJ/sdKZyt629M2gTzz/Ef9xXAlM6jZ6wXXazpmZMKOJvKfULYUtonhXezjVH6nhUChfUJQvHu90RbJRApoKdARkkvd2/B8vqQIdpNw/nssuVzCGXJMiWLD3UyHxJ2Ih+c4yrTihfGLD1agzmzxKlkiRXj/xRyEhXVmbV/bH6xSI6wmde+M6g8pUzXwHnk//wgBAUwNr5Mpipnqg3jatdpXrqRhoarHXWLtCvgtKDbj7ZaBKvo9DLDeD9gEd5I6UoPaWqJ91zu+wFxxcGMEbdzEM0qEka5kew0uJlF1HOGz8bDk9oJvrrWIHZD3UFXW8VjGiiYkmLLCgrqjHF5sk7KBbMQjtwiK7R+bvNGf2OutjhAC3iTxOSYh0rL4pB5rIRwLZRrQzP5MoI2Uh3ae7URtfAmMXLUGEOB7jOBCl7JqZEVFGBpk2EyzAAjferSNkiofRRXDsqRyrERgJ/qZHUtFHmglWHMgeTiMLb90PnbqA8+lCqBBvRmKH++qyN5d347pZnQWV1bIq07zY9Os6/gksnbf/BkrchkignXQzA0K6Uvi9H+6hEXDPCDxMfTbaDFxBTB6qlw5nEVu++
 odoNMDud
 z5/T+PE+7dVRvme/2J5vmjbC5CQbnTn7gtCLLbYgXH9jc7+4uIEcE0I43XtTzS70QR1lmpCoCKTwKEek5urH/Wh4/ra9NP5lGSu++ZNwTJKa9JJY7J05XUgEUBWgeMkIUmgMK8aMz0SdPOvxBos7vwcrAmDo/wDHrwga59BMgBfG6JuGqvI9+W/f3e6KD6NUbmPOcVgN0nHUSFTUBMcG971nlrBAmRhcaMcSQCB442lpsY3L/LJTDuEho7Y4GEUsThVWkUQXfseD8kfgM73DIk6UK6T0GLWe7MnhPk/TSPUJkhCUnI/k2pSHDB9vg621mzCZxPE5TKDIG9b3LDe2/5ZZ99SpULMiUkcl5vDAR+CyuJ4hA9IMffeHQj6l1EBPLcvqS8pafDuNTR6rxZJfK+b6z3R+8x6rT0xvsn92hjo9IvJI5i34dH4qw4Rui6W1MH3rN9LWkRIPG/mx/peo4MzzEX7oY9qVWpMlawSDzjztal1lSeqtnDb6YsXGCb+c8D1VvWLZwyGv0co4Oy1/tVOD6CdfUvtmmzRt/NyWREX7ufCZQnKb+Zrqb6/EAOEK+VHLqRUPZabvBATRqwskSuyh0yFP+kO7DMXcLK4E3NkoO4en3DULAWGJ5JpoLpG5o6PNa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 12:35:06PM +0000, Mark Brown wrote:
> On Fri, Jan 23, 2026 at 12:09:52PM +0000, Lorenzo Stoakes wrote:
> > On Fri, Jan 23, 2026 at 11:21:39AM +0000, Mark Brown wrote:
> > > On Thu, Jan 22, 2026 at 07:13:06PM +0000, Lorenzo Stoakes wrote:
>
> > > > # IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
> > > > # script so kunit knows to run it, and add it to the list below.
> > > > # If you do not YOUR TESTS WILL NOT RUN IN THE CI.
>
> > > Is the Makefile the place for that or run_vmtests.sh?  You don't need to
> > > edit the Makefile to add a category.
>
> > As I said, you have to edit the Make file to _add a new test_.
>
> > The point being you will necessarily see this. It'd be fairly odd to add a new
> > category without adding a new test.
>
> You do, but adding the category is actually done in run_vmtests.sh and I
> can see someone doing something like adding the test to the Makefile to
> build the test while still developing it, then going back and hooking it
> up to run_vmtests.sh when they're satisfied that things work and
> deciding at that point that it doesn't fit with any of the existing
> categories.

Right sure, so maybe worth putting in both.

All of this is pretty icky but it's important to get this running ASAP and live
with the ick for now, we can do something better later.

>
> > And since you'd need to update the Makefile, putting this comment at the top of
> > the file immediately next to where you have to put it makes sense.
>
> I guess.  At the top of the Makefile or right next to where you have to
> add the tests?  There's about 50 lines of setup at the top of the
> Makefile before you get to all the TEST_GEN_FILES.

I'd say right at the top, for both run_vmtests.sh and the Makefile, thanks.

>
> > > > > +TEST_PROGS += ksft_vmalloc.sh
>
> > > > Is this something that only kunit will interpret, or will it impact the
> > > > build in any other way?
>
> > > KUnit isn't involved here?  This is just how you specify which programs
> > > are run by kselftest, this is a Makefile in the kselftest framework.
>
> > s/kunit/kselftest/.
>
> > I use the mm selftests locally by running sudo ./run_vmtests.sh directly. So I
> > don't know how TEST_GEN_PROGS interacts with anything else.
>
> If you're not invoking any of the kselftest infrastructure it's not
> going to do anything, nothing execept make looks at the Makefile.  When
> you do a build it'll result in the specified binary being built (and
> installed if you ask for that) but not otherwise interacted with by the
> generic framework.  See:
>
>    https://docs.kernel.org/dev-tools/kselftest.html
>
> for the various variables that the build system has for suite Makefiles.

Ack thanks!

Cheers, Lorenzo

