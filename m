Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE2FC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258E86B008A; Fri,  1 Aug 2025 10:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2036C6B008C; Fri,  1 Aug 2025 10:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3D36B0092; Fri,  1 Aug 2025 10:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EED106B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:13:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85DFF80133
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:13:05 +0000 (UTC)
X-FDA: 83728380330.30.22B935D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2CC46140012
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:13:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jDMj5zWF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R2YH51y1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754057582; a=rsa-sha256;
	cv=pass;
	b=tspU9ChXjXEH8TLLgw9FbU6Dx2nmx2LNDoioVwcxuT1OkveB5XDGAVVXGRMyd2rSXm65g9
	J4CA6V/tM1jKHpVSNveMMnFxEqeXoNBrzcVq7S4t4jdUHjq9MHdRpri3VTGd4U5RxwTGxh
	hsyxcJYvut6fjBEgFlqaKHuY2myHPhQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jDMj5zWF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R2YH51y1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754057582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGkyUhAPQ4PG3CNd123IR7fwtxCWIMJ/LCmGl8WKdB0=;
	b=SK8XskyPutkbWyxT6IEE3cUsJMUzOiV8BUsxUmgpkWB+NS6o4e3Li+agAF+JSHlKzNwbv9
	DzhFLYoKVGzSbvf9uaS2P7CICoYqh4qeg8i3hLwbgZ8E1SsjN7BHvlfWmTEeyBMQb5mbs0
	Ngr9b6MwIVRYdvgSpOrTEvdc6r29CDI=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 571BLpLE023217;
	Fri, 1 Aug 2025 14:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AGkyUhAPQ4PG3CNd12
	3IR7fwtxCWIMJ/LCmGl8WKdB0=; b=jDMj5zWFFeA2z3rIVnmQIyJuS1YMV8uE5m
	xfCMc+IfW73XX+/YjAGDYYvGxVPptuz0Ojtu8UvgNCh2tsK6P652CW4QLK0bOnRG
	FAbECV/ndlCJrPgspZYs8uLr6JtHRwkaFvkq6j19L4MXudx5Vq1zsznfz6Mmdpsu
	BBDCFx22QIGN1oUtQ9EvuGH4xzsCfa2zSS1Q5D3A4xPSdRwugMhf+K8R2hBkLNHS
	DamyZnlrTZo26v50PC1EV24FqgyuPOjVbFpfdwIOcURZsHpmK0tBC+9apZXAWqv/
	ZCtXVuaH+PtWynf4dLnTec9n/jgIr4sifb0crTVuEO7gzT4qaA0A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4ypae2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 14:12:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 571DEob2011124;
	Fri, 1 Aug 2025 14:12:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfdr6b3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 14:12:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ks6/+Kr6GYl/YWGYULfZV5tEymPfPRp4ngvntdDssug8QDuWHsvtc8/+MvJNd6aKmHwbQH5qxcwZmaebZcdfsE8lcAClsUb1pF31GHVOD//VmU/BU2GiZoyxu8eiNPfp2EKV/21slgNVkaCU+WrTBukcnshkzpktFRockZDkroy7BMmUeWKmhdTrTGDoZAjSJPbDCjqWELXBNHnKgfzA2Nvcszsr+wKwQDczl3in3xqQu0TO8sEdQctDoHl1gqSmLSj5LFMPINt6lkYl1N2SHHstxj3nSAUreIi11AYKjC5THGrbzJDxearSUjeXD2sXDj2uujkv2J078lkrCbo7Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGkyUhAPQ4PG3CNd123IR7fwtxCWIMJ/LCmGl8WKdB0=;
 b=i/ivEaqKxqRado59EgmJKpp9pJY98hycUvWluFfwF99sKKjMZPyH0sRD0GnQ0FJ0GNSD/sK7w3BYTbOlNwNpHID/Pz4QIpb9cbqQyvEiu5SNSEAyiR1adyc1MhAuPUM0xvMmyGGFh8MzEqwvH9wObn/xwnwpcUSqlDPvB8P3ZDEYSdvgK8zpXD8W8zrThRRsyy7khjCV/a3CPJRAjdQNuFGJGd0ITj0D6NAH/K/YQCN2GpkoP0QvMlUrhmR20UtWi+nw1Hla9lmqzcIS79HD+9C2mvFNyMYrp0xPvHVCcOORMHglZKBVeM+iEt6iu6cduLPj6lY9eqc2dGYJQsB1Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGkyUhAPQ4PG3CNd123IR7fwtxCWIMJ/LCmGl8WKdB0=;
 b=R2YH51y11/hvkEzmXLTOPQJ/WSgB3mLq7a6P5aI54m9bUs/wMQIEO/G3/eQ8yWgmciFvQFIqBq4QUa+Ou3kR/0aRQplg76ZE8IImAMdSsQPEsuLbRlu5ixKg/IwgqhBIuXbEuXgXRKqyAPN0C02dix/y5EYit90uSpxCK8XCgCo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH4PR10MB8074.namprd10.prod.outlook.com (2603:10b6:610:23d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Fri, 1 Aug
 2025 14:12:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 14:12:51 +0000
Date: Fri, 1 Aug 2025 15:12:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
        Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        Kees Cook <kees@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 00/10] convert the majority of file systems to
 mmap_prepare
Message-ID: <3cf76128-390a-4ef2-85a7-e3ee21ba04b5@lucifer.local>
References: <cover.1750099179.git.lorenzo.stoakes@oracle.com>
 <20250801140057.GA245321@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801140057.GA245321@nvidia.com>
X-ClientProxiedBy: MM0P280CA0113.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH4PR10MB8074:EE_
X-MS-Office365-Filtering-Correlation-Id: 8951ee45-1f8e-4147-0fab-08ddd105803d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cXidssy7RWupVkmbwwY9I2IAoGi1L/3fiJWDrviPkd1vl8jjiqGrCE0UvyM1?=
 =?us-ascii?Q?cX3L2YCgPdrnQRgg0afymDb4gXgCqpgYKmwOXzeFj+sJWmG8UCpHpu1tbDyX?=
 =?us-ascii?Q?cTcStV55vjkhrnBi6BcQDSS7S3H7W5cEMUVeScOggPsfPtXwq+9FG3oGIyLj?=
 =?us-ascii?Q?o/WqsqkUQDZsABMC17tlQyH5uluMr9afrtzdZ2PTxmx+cKmZbGlBtUbeQkdG?=
 =?us-ascii?Q?fL+xRacOhNU5KagNpvjH/iYCR8B9DSumFl3VCEZ86dhuao2oZ4OZDsZ8AAvA?=
 =?us-ascii?Q?FW9B4LplacY7qSi+FHNNbFeD4mX9KRuhHmrlAaKhUvOfORvTb6RHtpatwqpX?=
 =?us-ascii?Q?543H7vJIzCQOlqT9QTexQG0ujKdRxYkzzXj31VJiHzRnr6L5Y6SU+eIawa2B?=
 =?us-ascii?Q?zDDxOLaDlC0S4zdxYzCVzl/SV+wqn+zgQuhraOi4+NxUeUoLA7agzoBW2maS?=
 =?us-ascii?Q?Ch/iJ/6koQ79oyIJrMAKnUY9p1fIxBx07gafxNNM18zOEXbfYQe+2QxJ6zG7?=
 =?us-ascii?Q?ji6/OgBbZbd3qgjMREd2AfeaQEehit8J2CDPTSd194QxOGj9bq47pRDPPRL3?=
 =?us-ascii?Q?LNhXVExluV4WKpkwDWs3Sdv6qppRa//ZYipAKFYX31hsZ3IywdTrN7Ns/hoR?=
 =?us-ascii?Q?+xfcyMKfm+Hz5+MYxizUEvVbPiqoBOAEAPV7CHVfvVQ+xVaLwrSvJfgSrA73?=
 =?us-ascii?Q?wdFjfKvbJta05jixYCQ4BpwH2JoQmtNqwLkoqrPFZ4VFcgFK/KHOdYdQuEC6?=
 =?us-ascii?Q?+3u8CutEfGpC1twCdsdUp1MPVtBV59zj7HeMaXDsIeB/hjAiKKCueDNoikBm?=
 =?us-ascii?Q?ZeTBW2rob2ytnyObF1lO/Zd+9d2J1WBhdl9FmwJIyDyTQr7UC6L2nc2na2oy?=
 =?us-ascii?Q?hdZWywvhHeHPpYSgtkTX+c2eP23XDJzutvd61usP4xpuaixpGAXebcHvTJXL?=
 =?us-ascii?Q?k0qTWbfg5RT/eAYFrE+1MdZwZmnWSRFI1Za3WA1xnZtgPmF1bGCTMugCDLeg?=
 =?us-ascii?Q?HbhKg87gDWK9iYnx6Y+39NLUsQjhH+9Nl6Wd5tvK3oAzau+0s1RZyoknST5q?=
 =?us-ascii?Q?uwGe0jlhuncq1t4Uufb73rNpHmSHOdvd2BbxJEk9zbP8DD2aB796AUP5yla0?=
 =?us-ascii?Q?6ibXsfH5YMj3YEZ/I3E4BjLjmtfMZrplhd49z8bxxxAb7OMud6Qba6cJe2Va?=
 =?us-ascii?Q?MQ9WrTtL3RUlVonu5q0op97smK/rjWxKOa16MBbgTzm9J4wBKNYrLKFhLdNC?=
 =?us-ascii?Q?VzfvDveiw9AgH5I+zFJ0+g4S6hVwpMShw9c0AAKLIDGgmO6maUXLtRJG+v3l?=
 =?us-ascii?Q?7S4FV0U8nMLUu3Qq+mtl5ZVF100vbFxNAXpP0W02Ow9Vc0eDqBzQQLwUNgqt?=
 =?us-ascii?Q?Y8ySU42I3oUB55VBj4rmQIpQZT7fKP1soGyaNpnRbtx5sn8p5RihGX7L++Rd?=
 =?us-ascii?Q?bX9MQ8UDti4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hMur1fYUXHLjY37kgwp5PsYTropE/9skCvRq/T4iNlkFqfKVPYIWhk6jwvc9?=
 =?us-ascii?Q?seFed85vwIIQCqgK5vrYVu647C3Puno1AVWZYF/3ZLHa+/K/XC/6Ag6S/TZj?=
 =?us-ascii?Q?Ruwzm7fZOQBgUeHBhmjIVGd93DJumLzrilqhb7//ghxYXf9iz7B/kB+D5tYO?=
 =?us-ascii?Q?LpTHCQemb2HikrmhvOm0cdHCDjkzDXmZULNGVJZRMKs0pAuL+yTJiJQkPqbH?=
 =?us-ascii?Q?xLcGyyeo2br2QnnqWod6PSR/FGWfYWgGmdvu7ciBf+Fwzs2GHzD1utUsAAy7?=
 =?us-ascii?Q?FPxUR5fwcKIMKcv3B/OKdAOrdjYB7nMcz/1xDXQTJ6RZyPpq93mfZECf52gW?=
 =?us-ascii?Q?7j1OFJbKUOVA/2nhNEn9nEXZPd5dl4MBqbaHT/HK2VX4odZ+Im9VEry1gERn?=
 =?us-ascii?Q?8rVELhwK1NNZ6LSoczr46c3NXoTnWtWEZCDpZceeMo0/RiPUFjoIi9Q6hMFl?=
 =?us-ascii?Q?Ga5++AS429C1vNzUBB80GYCEuLEMB6hKap0lt6g7l7AF9JEUZMNqdtyptAcj?=
 =?us-ascii?Q?p16V9r0JH5QWtObjuxaVlp4TuoB0JC+g1f4KCE446sVNByEC9T5Pnxz7JZkY?=
 =?us-ascii?Q?rIVMMQISaaF85oc+c2Tcs6qk8p3dAC4/xgc35o8Mba8CkmxQw5G6cccCeGfd?=
 =?us-ascii?Q?mcPB2nTGp3l06Mujy516y3csnd1EJnit7Pza07PamC35ksMOz8JOtG3YbzEx?=
 =?us-ascii?Q?qRPALjAdcS15L68LQ/rRak+dzvQnBKvsURLCbMVPJmEbMLvHAVvGuo9bj/ed?=
 =?us-ascii?Q?uGoxTUVvxrD/bXXZo0vhJcE11QTTTmLcm+ywSYDxuqEZ7q0AgO83/FUs0L0r?=
 =?us-ascii?Q?pamOx9Fz8EG8ktunePuqK0gz+pOxoXObWSMKEPqzGfLg0G8kjPUNyZCom6Aw?=
 =?us-ascii?Q?UOK0OGppa8QPWQeiX1utWaNLVu9QhRNlYnGz1p4PkL8IrnxGch1ndhENvVoC?=
 =?us-ascii?Q?Jil8O1+/HGh5Juz180XLsYoE9p5rMKpLOoFHs/nj6de3j/vw8iLIJIyhR5Re?=
 =?us-ascii?Q?aYVcdng8Ov6oRgL7DLhPeQDEXaWscvHXzLRaFN5CreT50cb15r6b6RGyTdVS?=
 =?us-ascii?Q?g3h+KU6LJCbEoTl5+uAYzMZtsVEEZLO+UP+0tE6YBkw7tiDBG+oAohB+tsjd?=
 =?us-ascii?Q?ASbBrUMLhMXRepTCX3w4S04IIx2Qldd0L6T9rkI4wIUX6kBCy/41ew9rsKLB?=
 =?us-ascii?Q?EPyWL87oqg2Mh+0PEQrd0Cp4buf4ijUPhWN0zbO5BDjsrSQC50/2+urMzvuU?=
 =?us-ascii?Q?SP0S5cs7qAzQbDOdWg5Sk8xwgUgtjd5wHAspXsXmnBevNSt5FqfxkudUJMpk?=
 =?us-ascii?Q?LGfX04+Qpp5RGZYPqOS91mUL8nqqOVdoN8UXZw8/y2Qa3rkgcxKXJom20DRt?=
 =?us-ascii?Q?6+0gx95sE2ckGnMMt9bI7LZDl4CLgQzVceBU0a5+9QsW3uqR9XW84aEVplym?=
 =?us-ascii?Q?SlVeeJK8vyqsn0VqpTKM+vcbF3/40etSByPSsIJjSQQiRkeA0U2ldpNpIQLO?=
 =?us-ascii?Q?MCgicU1ke6xtxju2Uwa5gKaOTFbjrpf+e3HxeNP/4RQtHUATKrQ7y1AfCcdO?=
 =?us-ascii?Q?7bTSxUXBzdWVbKC+i2kHg906rZKW7z+Ymx8xRNOa2ELE6YOcp7/41Q1vvir9?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z7QfW3CuzXo1KiTt403WH27N5INLDkq6p6eAwS26rpFg+P9k6FTThgSkmHysFRnYz++8dbkRC8dPE8kMhAKmESexLy58bgW3vMthhUHhBkKZ1B5+XRXGH1QgHcEr+y5+LRf4T6q9OcJWn7FtwZ56UEZRB5Glpdm6vf/6eaTPA54UtPZPAQVZI8jCwzXfbOQO74+2i0+Heg7bXwbiG5KfQ9I/V9Y5Td63yOhtO6+KJqsXxqn/YCLjqC7YlqhpHnD+oAXWrqqhZPpkj1FNpQoAqUTQOe11OkTmkmEEpyG0Kde7a2Ip7c8Z0/vU+GhSEWimT+/1t/ZiB5KiAu770dbeZzeuqQOJFIwvCgel+dyZ4z+8jCncCdPIHnUJwzidQ/Fn+I5LcRWBHQgfcCVDrsGu7FthJHaYEDhjX0pQdjx3my7zUCS/ACiyL7P5Aqh0ERuVhZpugyq+chdNhPKqymvKF9HmtkAybWKYSdxmUsT27OVdHDpMJlV4wawRBhy7ZjUwpNgKh6NQ8IbZ3T2WbBnCw7woSv8dJX2TyMo1jbxKl9cBsyEKrzptNt8sJMELcbcAThdZOb4bb1fMwK5NHlK/X7Iq5S7DZbOkt3ay7Oas1yQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8951ee45-1f8e-4147-0fab-08ddd105803d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 14:12:51.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mvGVT7GjASVEO/0QWYiQJED2Jq3Ewbw5gkFd079z5q2UXCWbTUygxu4Ahu75Qnz0tH7FhSz3okw8Z/6AZhP7vfY81nwTuUr2Esj5IPUVjv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_04,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2508010107
X-Proofpoint-GUID: yktMyh5IFfyR2GSVBzn8LYo_b5ikJERr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDEwOCBTYWx0ZWRfX6wIV8/aNUJs6
 MOmGTqBGldNJdEgh/LJFtw3B5PE2wIY7qSzaUuMKBUJLljTy7xbxvlSxA/E7hYDMf9+epXev/gs
 6pBlja6gx4YkAI2opm6IWkqKwlMZ3QiW2eHS2rjMCgJYF1QyIKQoXZgYDOZw2j1x+t9cibyzcwF
 VyECdcqZmvwTCioQJJ66TD3Nz/QDm7daG8z/umRiGQbnXMR6NYkj8c8mAhB7zNA/qs17zeU/RO1
 a68W8hV5vqJ96f1e0N1zQeIPN30x7iysBHtyMdzBYxxaslOnBnd7ANpIZ9H9tXdVKhVh5HfL7r3
 5+fqMDwdZVt9YkEUMg5EOeTwl/osb1ofiTX3hxF7s5iUi/VmT9hoM8B0h7Cjjdat0tV9F4YTpUf
 pFnSOrZkLEj+jCfV0tSc9d8IaiNzBwoYKppT8n6xHagPKIG2Pi+LZ7p1avS0svuLlAO1dQyI
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=688ccb66 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VvmGNyESjq9KKQ0KLIMA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13596
X-Proofpoint-ORIG-GUID: yktMyh5IFfyR2GSVBzn8LYo_b5ikJERr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CC46140012
X-Stat-Signature: ze5oa1regt7z9ic9gkiy7eiqkk455oy1
X-HE-Tag: 1754057582-89987
X-HE-Meta: U2FsdGVkX1/TzcGusSyXMhsECbASO34uody10jvvIgOVbNTGDJuD/ND/jEXhuEHTvwF89RYys7je+X6jsLGQeC4ZrVPRStDzIgIwi7G3ixsidrXmA2nON611gUMAFyv3k7Ldr2HH1NFnZGhRkGJDHg5Mu9Is0xCcViN3bjtSa2059y+uel4Pxuss5ibDhSB4WRlfOfD/3Ypcqxi2hyTiWdWP6ZryaTyqobSW4y9qisSBYP1hQJLK8+D4sKYxMFXIwZQ1EHZIKqMjEylDM+3ZagXS7TQZx1Asba5XRKH/kw+TvEtw9wu0CqK6HVBurBKdFa4f+tlwCTpXW6exBikBEfF3EA/nX4o1HpmUUs+gKGPwSuNqYfKnmcqnzwqrjg83CJ3T2oVgPZ0Z83rOQ4trS+fIXLGUB48DMhYWmk0E1WSFLGz7OfhcImyh/GQx+MAkjMqUKSQ9dyqk5oHnrY+7L3xwWfzPOBXJxRJGnhIhNjdPj6MGAhhXMTmGpORvmK3JKC6PqkTlEd8bCgmTPLpm53Y5lIC/PlNDuMKLUTVrvIa/FkBLJ1wuBHrG9Dabfld+uQUYyzVwZHz4A76NWSXPsLY3rkTiLbs1q42xjqDJ0BVYUmYk5XWOObYuZVroyiUvL/haEF2zcbzWJUA6Wh+Pf0CePEqsJevNqbe08BD3JTcMJgc+R5kUTMlpyC2UlhH4HxZdQ50n9ZEc6X8wa3mZztAI+RsjMBorfdOGQIICxq9IMMExu5bbcHokM8UHgv7/iRFLdARdido3fXAhLtOWGzPKPRuroAf0f5oQcXnYTotKJ2r+Da7iWwG58jQMNiCSg07ZFPi90WQQgAYAVcf3KpvsFpHtDdSjZSYcLx1bQdlE+OG+/D12L2PTv20ImmyAQND+HNwtvnGmtbDU88fm2d5MfO0hzPR/nuug4rfxHpN8HtBB79ikgpzpNroVYWg9wAhqARaWrrzAgTazxGU
 Zq4Zq5vO
 xfhM8kKP92G2LqVOgd7LFIvasGFiB7D4N8LAviwgt3P+HmbhG6eKIOFaeE5UftaPH5y+6Yhxr5mb5RowIohaMYRx5MbxAiuKgaiZ+ZgQMqoC9IyztFglhPmRZWoAKUIpKV+Df9FQwEDgy813VV/di41abVFssGqrfrfesD5KR6wZysJqiECfVNB3bmrRE+XFHNYWKt1SNrc3lQJRO89GSTreEba7s2RFMFMcmFnZ7aCPN3onOyoO+MpTRLcCvfHMhpTbrtYvAkWlpGtSMDZsRuHsq8n0vyRdIFHFmAVsbyvd3cJDpzNDQmzy1ugzzNtvxxuq3BVR/mkUsFsjMIutsxRSt/gae9b0chhzHbkqpE58eRNi3XULM+GJ8D1EC71C3r19Npo37fPMeucliDMa2/hlSBg+k/cKMZrGRKiSxsgtfjvJlzFs+NshzuITwLPtHjOJXN0cYB4oWaPHdGi23XLu/Wzzxreo8JjeDcV4G0MuDWAQaZWF4yzlA0AJ5O1ukK+7/86NxAAEIP4b0czao0j9RmtzwfD8vQDvPFOk6raRyBTEp20T4ewtQdt8DAOT9xb7blo29ZKThsEcf++fXXW6eYej2KSHOCleS3256ZymOlxU5QXPtKkKWC4mEWBcoenFGmDuoSXTHLXFaLp7z/cNfEZJzPxoqz9yp8D1cmfJFU9c0rAV8fz0FKvluyLp+qh7MIk3ACXY0pDZsMJOHuXstzvR7XHilY5UyTwMFbbweWQvxq1V3z+yw9SQMOnSRM5emJZRClXGaRN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[culling cc list down because for it was insane, +David]

(apologies if I cut anybody who wants to be involved in discussion, just
being practical here).

On Fri, Aug 01, 2025 at 11:00:57AM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 16, 2025 at 08:33:19PM +0100, Lorenzo Stoakes wrote:
>
> > The intent is to gradually deprecate f_op->mmap, and in that vein this
> > series coverts the majority of file systems to using f_op->mmap_prepare.
>
> I saw this on lwn and just wanted to give a little bit of thought on
> this topic..

Thanks, sure.

>
> It looks to me like we need some more infrastructure to convert
> anything that uses remap_pfn/etc in the mmap() callback

Yes absolutely :) I realised we needed extra infra, and later noticed (and
in discussion with others) that remap in particular would be a pain.

I wanted to lay the groundwork first, as we could safely do this, convert
nearly all file systems to .mmap_prepare(), and get a big win on that, then
take it further in the next cycle, which I was planning to do.

>
> I would like to suggest we add a vma->prepopulate() callback which is
> where the remap_pfn should go. Once the VMA is finalized and fully
> operational the vma_ops have the opportunity to prepopulate any PTEs.

I assume you mean vma->vm_ops->prepopulate ?

We also have to think about other places where we prepopulate also, for
instance the perf mmap call now prepopulates (ahem that was me).

So I do like this as a generalisation.

>
> This could then actually be locked properly so it is safe with
> concurrent unmap_mapping_range() (current mmap callback is not safe)

Which lock in particular is problematic? You'd want to hold an rmap write
lock to avoid racing zap?

>
> Jason

BTW I'll loop you in on discussion/series here. I think what you outline is
likely how this will work.

Cheers, Lorenzo

