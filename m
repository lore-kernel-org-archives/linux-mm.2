Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 528B7CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 16:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933518E0130; Thu, 18 Sep 2025 12:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4378E00F6; Thu, 18 Sep 2025 12:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CE48E0130; Thu, 18 Sep 2025 12:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB4B8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:48:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E97951A02CE
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:48:04 +0000 (UTC)
X-FDA: 83902953288.30.6520ED3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 666DF40003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:48:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T1tUY3tA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Vhuuibxn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758214080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uh15epv6EQ0pixqSqadnRrwKgO6dIyIPJpXgmPyk3bE=;
	b=PrZKKs0nof6RpDUVE4SmYsldQYghJy4awn4ejGnMDOBhkIE8Mh504G6+gibZW+nn9zyiy+
	npSvF7dNW7s3htjD7keWbAF8FfOboLcMPtD9mNb74SZcUTszKR2/4bYjNfm2vzTz1cO8NB
	YvRR0aOHf0Pl2VdmZhwBNmVY+FYmXtE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758214080; a=rsa-sha256;
	cv=pass;
	b=OIfMkkZQ8Qc2eygyn73EKr8CVaXJtmfnThHqarCQiepGoRFVFVZg4tGD0gMCmR0UHXJqi7
	EX5YBNaFIawVYqwfSSgMOAiNbOiC9sYJG2OkFruXUPsJrVc16oF9lw8Wkb7WtMNLKDKMXF
	F0im+spv4vKEmG9ElCDRSS/aqiMzyWk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T1tUY3tA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Vhuuibxn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58IG1mOJ007031;
	Thu, 18 Sep 2025 16:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Uh15epv6EQ0pixqSqa
	dnRrwKgO6dIyIPJpXgmPyk3bE=; b=T1tUY3tA0KYXcjy1+GlKscyTB8kdBnPpjL
	V4W165gZ1aVXXPIW+NNKwkJGRSltIsZMThwtgy+hp5Vu7uZFyL3gWbU5GdUUeiEF
	aXoKyISDoc8PPKG73ut//TLAf5ebcczmLmeE+3HhUfHZomvoVY6NEs5XEpcBp64B
	0g4/IIYRpuvCkWifjvbeL2soaf1FIQb70YG//UAG1g8L0c3TLdw5mcLhnZ94Hz0/
	TIaJwF3bClYNIrCcorhM9gSZbmL8JzoZ03thP6Ud5rll8qCGfokB92Exxu5zuVXA
	nNA9L94gwyzB022Oeb4fYSrtMzTRl0bUPLGEAJj6bwl2HLL5+7nA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497g0kc07f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 16:47:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IF4NRQ027260;
	Thu, 18 Sep 2025 16:47:50 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010026.outbound.protection.outlook.com [52.101.46.26])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2nngcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 16:47:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K+QXhM5JxFMDnkVfJWMN06CNv0wc1YKyVjFHnlBLV1ECLMPxOL421bDZkKXE/DSraqE/t+n4EJl+RJ25PuW64Icy2Bs3BHJ3SSLW2zgxWUF6huqPlqetgFVo1L7rI98o7wMqPKbQ/S9rZhnpCtNkFQKuZqzDMVgGpn98QKdG+94kG4L0pYS22Dnu5+wHhpXDuqD4nzopcmrK/7aBUbkp3BGJiANrX16sffqo8q30lVCEnpkSmYCC3zL6raiC5POvFsiqpCVgGKdct5JIIo9g564MhmE2FJoRc0zSJOFLw1SNoBGo9iZXXHrto0d+bktS0OLeGnuhKEk2FkmgG0n1TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uh15epv6EQ0pixqSqadnRrwKgO6dIyIPJpXgmPyk3bE=;
 b=hWbebgWbLLAG3H3SPSDBr33CgRIW60iSwcY9w84Cabong83ncwAWvhx5B4eUFMWEsCegkfTath+5YFoGLrio1kzB+K2reWULLtrjbcGrWHrss5Lw6x4MGQj6UH3J8PY6yUmNN6J8SnHcEXDD4RkD8GULiv8DBSylcQ5bPTHjWKPtwzXeelOzevUo5FoLZtQXoaMgzMDUogFXrj/sCitGK65VpPetypjFkrfpCbIEwHGGFQUBpo2vRgTtYR5A1NgKQBlhLeOxty82QaZDx1yyrRL8/TwVBYC3SUHqA8qiovZB3a7ZKT3geGtMZyUfgIRHPoX69ZDZcqB91sMGY2/RzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uh15epv6EQ0pixqSqadnRrwKgO6dIyIPJpXgmPyk3bE=;
 b=VhuuibxnOoDMJ99rms+7d3pt9sPTPqyu3Tx5r2dNY/THJlU62KYxE5BihM1UgRhiYbJ1EiWNoiF51laM2Q8fBcxkvVmevoiMBNj9O+2MjS13ojqOZ7nmt/SjURn8x3qpTOn+Q3BUweRaOLgU8OevtDNT3Y077t08HOouXcm+v3Q=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV3PR10MB8130.namprd10.prod.outlook.com (2603:10b6:408:28d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Thu, 18 Sep
 2025 16:47:46 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9115.022; Thu, 18 Sep 2025
 16:47:46 +0000
Date: Thu, 18 Sep 2025 12:47:41 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Nikita Kalyazin <kalyazin@amazon.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>
References: <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMvEu9m7fJLnj862@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:303:b4::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV3PR10MB8130:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e06fdd-43ab-4227-d895-08ddf6d3184d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CogF5EmV7Ojiod/39PJCLmz9mEBUWqjyZ7mv+//Hy9y1lFxAl/URe4+lqgwy?=
 =?us-ascii?Q?lEuC7m5iSbPc4iwYUqXDB0e0MXHd36pdtvZo/GHkDjM6F479CgU4S6AjdVyZ?=
 =?us-ascii?Q?OeM39cPIAoCiAi41xPwN8ZV1Qw/3J6i3tSuHZEiMLeGTvLtiNARkGA2LID+J?=
 =?us-ascii?Q?wJgP9Rlhlo2sSSg+CKugSJrnUR+NeXFvb+DB3aH3Z4a+OUMmqQjQByUHlEM+?=
 =?us-ascii?Q?G+l85qJx8A5l5a+0DFTbKOBuPk6+vCIJvgGIDCMvQaoiS9j4zGQs0j/EQD7o?=
 =?us-ascii?Q?aSWsNuXxsM2YNk0cxpfb2VeIKAdwfU5Fi+OzDt9kzj80VK+JNqcR5i3lUatq?=
 =?us-ascii?Q?ko73R1cUVQr12zbluVno0UB6gaizUvJ60kr6ehjO30QLXS7gy4P64sTdW6+r?=
 =?us-ascii?Q?H8qsatU3ZhDI9TerKwVjQBSb1xJn1p8cmWqoPnV+M4YFRZLrfXQ3DCrqVsGI?=
 =?us-ascii?Q?t+3Zs4uThYboZ9rlc3ySvkNuGjlhJ1q7b9sh0FVmOw6BIJd7I+UX6bJsBbrq?=
 =?us-ascii?Q?2CQ3SXpVnT1HiNWUkPEGb0qZbt/4w/QQEaJ0HU0dT4TlMGE98Qo8eMut5FD7?=
 =?us-ascii?Q?7DYiyRRpep26bYh96PmHlaE2ehCmukzcZv0d4dbU29K5bxQDCgojTvox/GTg?=
 =?us-ascii?Q?nRuGZQhhl7O+rSNhnp18OwX0Z0pM/vdQL9nD0u8Z2NPftgZpY9cynJxTCjVB?=
 =?us-ascii?Q?qxpZJdjmQkTAN/FfP8llzce+Gy9+SMISc/+pFBgihnOFUcM4b4GE00axTgKM?=
 =?us-ascii?Q?uw/5kh5DGadEtG7Q6M6tIJIDl6X74+lKpKI4wsIUYPfXSQf+ByQcs27P7iNU?=
 =?us-ascii?Q?jR6stKWRvAwiK6+Uzs8ZOUkT+cHt1E9xWiUa+bfHBmJzY8IKXwBltyN4sttx?=
 =?us-ascii?Q?iCaWEL8cG9az2ZEKWXUKWXsJFXw/w2XJjKd/oI9ZaNmfjc6JvAkHBxsp0+tI?=
 =?us-ascii?Q?Yo29QnY87v65Ms6K0uRtOZJbgNEcUKDhWkMnT2LrdoChZkXATSi0nISPpQ6N?=
 =?us-ascii?Q?V3qVoNvQUe5/Iq3kv1oeUFtAyMVg7bU3W7keGsQBrzrWz8ftwDQFyP27Wopk?=
 =?us-ascii?Q?SSEyKsCDZflutmtZwof9Zk1TOr6TwpdWuzRRucTLE4qURb5t2vAgtEdl6/oC?=
 =?us-ascii?Q?wFH2GY7/svZQWPTVknO8CUWJi1U6IQE+EOqZKRWKirooBzeGrI8MxrwYKChq?=
 =?us-ascii?Q?jXvRGkMaC/Sbpbm7hDkBmPLWhEjDtU7mUtzez8gUFejmK0UkfIFjJlRI9IPx?=
 =?us-ascii?Q?3pXw5RVkMUeXT5en1X7sNHGoMfFFtnHU6J0x0dqbNs3FY6PR7YzFuHfQL97v?=
 =?us-ascii?Q?Da81/2iijRzblXecA0fjcj5U67KSR4uFT0150Mt1N0sMKJTf+y7YQfpuhY5H?=
 =?us-ascii?Q?Kca74KhopypeiJCa3yFQh0NwtUdY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OnI0SLj1D/Uqjna8oMFvJJ7zl6P88UWqB6VhKeGcfr46UKoetzdr+6iSvfDU?=
 =?us-ascii?Q?OTee5zJw2akAf5850OUciymq9sifGT9Kb9/VFWxhjamd1V1pRRlJ2eY1QMJE?=
 =?us-ascii?Q?kZqfq5sl25S93hafztQl5F14YNJE0085BwDnO4rhSmvPTUZItAphHc+wFhqi?=
 =?us-ascii?Q?djwCPsbyrXJRBaII3e4uBylsu3ZTxT1vo6O0xKh1v/MqF7lcPh/urn8IBJz+?=
 =?us-ascii?Q?UsWFZ3n0IjDLkkLZl5cJ/b5LIOhePJ6MqisTXODtNrMOGptUpAgdyIdp8A5I?=
 =?us-ascii?Q?F3mydSAJvW2n3S83u/wleH6qptfhrSOoLDYh5OetVxfoktTVY3Pznon3exDP?=
 =?us-ascii?Q?MWMX32uAcy/Iw98goyRpvG2JJ+yoi7ZDtzFrQZTV6QtVh4RkDusGZRkGcJfW?=
 =?us-ascii?Q?NNke14VwXcm5Ls2dnS8K+JnnJF3KEKbccZiXBZacpKAA/oMBF9evkMp1xvAl?=
 =?us-ascii?Q?PotkEYqyRBuK4H3EEp8hIArv88SM4f/eSyesYuU04hnbkm9avPgvtyvpcA41?=
 =?us-ascii?Q?1mev+H1MMnAVK3tf6kpxsEC5VIDR0nCFDGNiQwJVyz6s8upPmQlztBxtIIoo?=
 =?us-ascii?Q?JohvqM/b/Fb2YDMVRYFWHF1sJJYVuYC3NNQiF4bsrwFX0FxV0arr1m6I5Fiz?=
 =?us-ascii?Q?sB2KXpipoSyplNY+yFPfAYmP7fq26f+y0FtOB46d2wPbYgSu9QM6Q9koQOsQ?=
 =?us-ascii?Q?9Rqf5jFN02Zgg3nRHbvAMwX7fg4LTRGJDkS0Gzi3qPw59rCnBgv1OigOw4ty?=
 =?us-ascii?Q?9Wd1SNIJTzE6qEmvJUPhgfJmwAVdUGkCI19iqF0Bd8Z9rxlyo1E/hV97OXty?=
 =?us-ascii?Q?Cq0yLq2BYiYExbTBoioafEaIuJINH8G+vmbGM3nbwYqYX9RbD80iWA9ZVjTT?=
 =?us-ascii?Q?BHD+A8zbkKL6ZvOCHHCAbTJdeuke62Xzsap7QMv4+IRQGXC8eDKwHfHarjfu?=
 =?us-ascii?Q?bME+V5nZEWMl7RaEMRwjhdl6JqtYck/XQZl4ATeYvKROlV52OLhP3su90MY1?=
 =?us-ascii?Q?wKNZrq+g4bev9fEzkB+0EhqXvzqWIv8FQwWRHQI9gqToxYWAna6E7rdMrjFc?=
 =?us-ascii?Q?OQ7vOPsbuJFZVPUF9KxKoxZU9/wJ8oEVDGcznilR/AX9rj+Ry0JXOZqszgwV?=
 =?us-ascii?Q?al9t+AFrCS0zWghbRj4iIDoR54D4InE6X0mnFdImpBGu/Sy632fitPztVrwi?=
 =?us-ascii?Q?Rav9lWnpjF8iuHBMhO3nfO6gXYUehL9/0Cd3bYQ5AjhdfLcF9voTwIiezV0V?=
 =?us-ascii?Q?zY7mq7EfGqSFKfmhornSqepUvGr02cg/K+HhGN6V2WYKvQvZjOBQZext1Q8p?=
 =?us-ascii?Q?FC0EbKwqlzSEdGDhCdQ+G2Fdq+0QXgz3m1UcuGUhF1Yu/sOojUffqLBOMVUp?=
 =?us-ascii?Q?KMfKM0i+cFjx/dfKLbQWZ5Gvco7jfM2swIMoFBxPCI3tX2vwX+X8dtUUk4x/?=
 =?us-ascii?Q?/eJ/eYtkUuKZXWnex6Xs7EMHhzfgAkh5qr8bCxkcSJ2RRRd0RiHUXngLst2C?=
 =?us-ascii?Q?io/KuBku0JsoBmOOxmeqCQux1xahkCSW/7c13HhJEyw1uYievFhd/qlQ6T1c?=
 =?us-ascii?Q?bO9WIMshvOUsz40le0/4vz3bJcWd0uEcyKC3jDsA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aFWu29PsiJqxlSKE2AsV26lnvBG0vL2UYh86Y9vjHhcwFbj5qnz7JayCG0dXFLv392SxxaISGaoRFFhRII70ABAL0ANUtLTCKbAQxgU/atCcuC2QpSpN3naVpTMUNF0OPJxGXi2VFXXmQFBK0QJcvvk/+RGlbInJEvY+Oa4LkwOU22DsK5F2WfvdOpmUPQU6WZWf+Vdme0oi6tKBMHU/Nf6cBiGUi6Lk+2CQNNHXIE7+fhIoDWyJO9OYhFXKie0JHp6dCGHgmYqSI0mQGQepWIvghcd0JKsP2pG1Hnn1FicjptmPLmj4BwWTIZl0xULDRkg+wezkg++KT6+bH8q8QQC/TJO20/BH7xZVByZKNWv8ArG5Fg70gYFAEGkWPkOu7Su9hQcXSaja/iMF2SnYFjkS6MBg7s8NV7WOObysI2L4U79OzTobbPxpW3JbpgHcTNhKhZ8Kybe2hwOReQ1tfusIwkuSf0s0lJnt/l1AmpOddnrJePgaEyUcD6z7cvlu1vGogUELUsH/FtL3vuvW5hs+YzVd6k1xppGL369DkWQOeRnTIZpjX3VxzV5v1hJg0puEXNBYrS/bRz4KxwHvaBoeV9j3O682ZxTOBWtxdjk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e06fdd-43ab-4227-d895-08ddf6d3184d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 16:47:46.5214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prGOBfYjek/yDVuptLBPGdbyVgPmQ0pt1JMaHkRQEh9yX+avaNTSaDLyhTPHe8Wsxf21eONxxYLfc+9jC7yuqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509180147
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68cc37b7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=vggBfdFIAAAA:8
 a=K2lvAQifAAAA:20 a=ZnmVxHca0H-DWY1hUOQA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12083
X-Proofpoint-GUID: _fbot614ydbuieqnoW50u0xT7qiXRkZy
X-Proofpoint-ORIG-GUID: _fbot614ydbuieqnoW50u0xT7qiXRkZy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMyBTYWx0ZWRfX14oM4euivxw6
 We0bz30oTvjDHljonBzcRF8uysvpdQGjpsZwMIJEQzI7Av9fqETjS3GqGovsNjErbFKYE8UlVX3
 544JnlxM2zaPEw1Sz/kqNdc3YszadhllRb49rvSMcLVpoo+JI8EsNy1EJrg7V9xzTLbpE/5wvc9
 loKbFUjjmG6Ljh7ChULRK43R8OqX5FNUduoTbKBdyvYfcwxfjxQxQJYR6PM0gGZ5zrPJ9bznOAy
 dTEnopnLHtED7Qn4W8SD6T/pGZuR9HAgSlHBUdkptpkXWjKKg/VcyjAxtVkYcd2y87/uv01SlFf
 78rh7/N7tFIqcSUbxuW09HPQ3Seq14GOCD0qdmORqEpJLKeGvSKzwNzNLpHOi6PFTXohsLVxBlx
 vQk7rC8T8qnAt3aMlB6p15HRphz/PQ==
X-Stat-Signature: nzcjpe1ni1gkqqumk3m8f7xoifp3jkam
X-Rspamd-Queue-Id: 666DF40003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758214080-407422
X-HE-Meta: U2FsdGVkX1+Mxvg8yQcQ1NZRCoNe7slby43tVG2Cw44MRjjOR7i1j/4xLnxZjE8qKbX3y65P8kdsidOhafqpQ53Xz8uL9l6otckBN6o62hO7FZRzbgj3ZM6Z79T5iWnLfhzU0RDBSll6K6/0SbdISjI92ulGANUUJTcEtDd2deH1f/kl2pC9TXyYR6C5mGFe3TdJKcQYYOvvEDhJvkf3/nfhdt0efcUaed/KBczi3SZVCVxZ//rjicWs5XORjbfapHfF5Rh1YFQzVfxIm5fgVg1WLaG/vcRbvGYYe/V/y5ybh6J/ABwhF/p9EI2Qw4OI8pXB5H0nEk2OuvmY24DqIv2Pqtc3KahNDNKwalIZekacZtxbS16XmMhjbliMH0TdvWP/Sm804eQchbkQSEdu/nMnFmrFkHOC5OLGwsnV7M8tu1LTGeoo1K0Fo6t5i9l+3QKFyKHVqDaOORrIxxxiUTtjYKJ8p8tiP9SP2zfbn6nLJfwa2k4QwQYQ5z8j4n+gTrLgaAHl8nr3hnihUd4UqCAg1Ef6LR3oFP/XFuCy1QKrSkQ0kcTGxiR+BrmxaBGaYIqDhk4CVAu42aFQW+oA6mfJWmwvXwD7P9ZQaiyLZS+22I4WeP2D+WVns3oiBV5WmcFBsBpjCb/o+I1nSw/bunl6ILuU5MbU2lRDUtSbxT2kCCAWYAGpnq56MvQpLqOvTkRgheAhayjN6Jaj06+hJdSIn9lPJRia4gT309ewIc0HCxToHBcRjhtYxmgYfI4lMG29FlX/c5KDHg1isja/a9BU6HcmDimCSY40to1gJQ3r9Q8MGWuvQBXzOt3J6LOHWPtn1QfV0bDjhuwFvBbHBnbRs3AOwhM8BgYGP5tG8I1uUq3HVJQOqptBOHiLlATZWnswgNrrAviWK90Uz/sOthHgnchFPvNK5/nQYu5Cb3XA+m+hmHdyf6VXOTDEY4h1wrQ111DPjLiIx79ZX1m
 TWEWmw6x
 eGJXNNjsaqoR7Atfdmq0mMGyJT/Jz/Pdawfj27h4SQsNRzMW2yq1zuHc9k1EWJ5UHyhW3mr6r/dDGp9zTSypAtvkmko7BCMlb9uNNspZPIcOa091nhYcMH3hrUHUlsAD9KrbfpNSPXljcfW6uiipPGMZguLDnaIGRP6i3kfNxv/eqOZtiXG4Cuxq4dOB+XQa+2BosROX/t5SbkZ3QN3JSm33webmJ2Yz7s8ERTx1HAx1J5rvA0Znid1fkW4Q774lRJgR3d4HSLvHTLZRHf7ri5UlhcAJpIQWlD3t31DxD5l/ZzNDltLHO+BydUaYKvpbLG2+4y8bvZ/NJktoJKS0//SAsu1Vt643TU2e4k9twXH3aisRV9jo79owbxVeTFp9Cp8s421wNWTdgiYeMOoyKjap8x5PrRCT52+spdsODJ8Htg59Ha7VHPlfz7brNQEY0OBuKueJbamgLJHliDoTlAiuID7r75YOV4/7lxL47t42GNLtrHBplLD1HNbDR7ApF+ciD4txkuHHMGh1ND/tczr6athu3sfoCgz3Z5tW2yGibE9SJJQloK7mqMtuKCuyJLYKnJ+Q1JzizsF3b0t7wwP4LIEGepDm2DhFejbBqAAXhRpbUmFiJWlLKNU13LaBweP9/A1Ai59e3mq9TWNa/aH2adghZFVMrxdM8ja/p41G38vN6hc/4xfHgUfeKFuuquCLxaJ6CwgR7t+t6ogFbzLyKzADDJ/iyOdfAl98DBvjGmMZdDuEjRKxcgSWM0TMENRFOXS3vcBvNyZztJRDoQ/yKSgWWxYJhGH9Rl1fxuINxtl2wFOH4TZEDqmR5uFDIkal32w6FOU7AFl6/ze8jYMJ/dJABndAplMs+5mcntfqDLLdSvTkmv0RMdQSW4KlVgbiu9C5PrFDXe+31cIzMTas33Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mike Rapoport <rppt@kernel.org> [250918 04:37]:
> On Wed, Sep 17, 2025 at 12:53:05PM -0400, Liam R. Howlett wrote:
> > * Mike Rapoport <rppt@kernel.org> [250917 05:26]:
> > > Hi Liam,
> > > 
> > > On Mon, Sep 08, 2025 at 12:53:37PM -0400, Liam R. Howlett wrote:
> > > > 
> > > > Reading through the patches, I'm not entirely sure what you are
> > > > proposing.
> > > > 
> > > > What I was hoping to see by a generalization of the memory types is a
> > > > much simpler shared code base until the code hit memory type specific
> > > > areas where a function pointer could be used to keep things from getting
> > > > complicated (or, I guess a switch statement..).
> > > > 
> > > > What we don't want is non-mm code specifying values for the function
> > > > pointer and doing what they want, or a function pointer that returns a
> > > > core mm resource (in the old example this was a vma, here it is a
> > > > folio).
> > > > 
> > > > From this patch set:
> > > > +        * Return: zero if succeeded, negative for errors.
> > > > +        */
> > > > +       int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
> > > > +                             struct folio **folio);
> > > > 
> > > > This is one of the contention points in the current scenario as the
> > > > folio would be returned.
> > > 
> > > I don't see a problem with it. It's not any different from
> > > vma_ops->fault(): a callback for a filesystem to get a folio that will be
> > > mapped afterwards by the mm code.
> > > 
> > 
> > I disagree, the filesystem vma_ops->fault() is not a config option like
> > this one.  So we are on a path to enable uffd by default, and it really
> > needs work beyond this series.  Setting up a list head and passing in
> > through every call stack is far from idea.
> 
> I don't follow you here. How addition of uffd callbacks guarded by a config
> option to vma_ops leads to enabling uffd by by default?

Any new memory type that uses the above interface now needs uffd
enabled, anyone planning to use guest_memfd needs it enabled, anyone
able to get a module using this interface needs it enabled (by whoever
gives them the kernel they use).  Kernel provides now need to enable
UFFD - which is different than the example provided.

>  
> > I also think the filesystem model is not one we want to duplicate in mm
> > for memory types - think of the test issues we have now and then have a
> > look at the xfstests support of filesystems [1].
> > 
> > So we are on a path of less test coverage, and more code that is
> > actually about mm that is outside of mm.  So, is there another way?
> 
> There are quite a few vma_ops outside fs/ not covered by xfstest, so the
> test coverage argument is moot at best.
> And anything in the kernel can grab a folio and do whatever it pleases.

Testing filesystems is nothing short of a nightmare and I don't want mm
to march happily towards that end.  This interface is endlessly flexible
and thus endlessly broken and working at the same time.

IOW, we have given anyone wanting to implement a new memory type
infinite freedoms to run afoul, but they won't be looking for those
people when things go horribly wrong - they will most likely see a
memory issue and come here. syzbot will see a hang on some mm lock in an
unrelated task, or whatever.

I would rather avoid the endlessly flexible interface to avoid incorrect
uses in favour of a limited selection of choices, that could be expanded
if necessary, but would be more visible to the mm people going in.  That
is, people can add new memory types through adding them to mm/ instead
of in driver/ or out of tree.

I could very much see someone looking to use this for a binder-type
driver and that might work out really well!  But I don't want someone
doing it and shoving the folio pointer in a custom struct because they
*know* it's fine, so what's the big deal?  I don't mean to pick on
binder, but this example comes to mind.

> 
> Nevertheless, let's step back for a second and instead focus on the problem
> these patches are trying to solve, which is to allow guest_memfd implement
> UFFD_CONTINUE (or minor fault in other terminology). 

Well, this is about modularizing memory types, but the first user is
supposed to be the guest-memfd support.

> 
> This means uffd should be able to map a folio that's already in
> guest_memfd page cache to the faulted address. Obviously, the page table
> update happens in uffd. But it still has to find what to map and we need
> some way to let guest_memfd tell that to uffd.
> 
> So we need a hook somewhere that will return a folio matching pgoff in
> vma->file->inode.
> 
> Do you see a way to implement it otherwise?

I must be missing something.

UFFDIO_CONTINUE currently enters through an ioctl that calls
userfaultfd_continue() -> mfill_atomic_continue()... mfill_atomic() gets
and uses the folio to actually do the work.  Right now, we don't hand
out the folio, so what is different here?

I am under the impression that we don't need to return the folio, but
may need to do work on it.  That is, we can give the mm side what it
needs to call the related memory type functions to service the request.

For example, one could pass in the inode, pgoff, and memory type and the
mm code could then call the fault handler for that memory type?

I didn't think Nikita had a folio returned in his first three patches
[1], but then they built on other patches and it was difficult to follow
along.  Is it because that interface was agreed on in a call on 23 Jan
2025 [2], as somewhat unclearly stated in [1]?

Thanks,
Liam

[1].  https://lore.kernel.org/all/20250404154352.23078-1-kalyazin@amazon.com/
[2].  https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.w1126rgli5e3


