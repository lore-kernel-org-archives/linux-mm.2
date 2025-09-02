Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6299CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 23:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF706B000E; Tue,  2 Sep 2025 19:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0700C6B0010; Tue,  2 Sep 2025 19:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A026B0011; Tue,  2 Sep 2025 19:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1F246B000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:57:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A34A119CF1
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:57:48 +0000 (UTC)
X-FDA: 83845975416.17.1215E6E
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
	by imf02.hostedemail.com (Postfix) with ESMTP id B05428000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:57:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gXqztmC3;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 40.107.212.66 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756857465; a=rsa-sha256;
	cv=pass;
	b=OHtPqbTco+KLJq1yaRGSxjq+nAzrb9RWEYJFdp9pmOVMvfZ6bCVsIu8tXDEedI70j3T9+x
	FUVLC6Ecub5oQLL0BJuLuwtW21CPruGhbJBeiV4L4zTyVu5Mh/acfmkgVeHRz+Flw2NtHv
	Kgoxtdi/c/jLfR0VbMJQS3WyitJUcLA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gXqztmC3;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 40.107.212.66 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756857465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0Cg9bCPvgGNmUO3E7v3ZZPOEy4MobIeiQ+nI4szqzU=;
	b=EHMgyyr73/jZJmJR8mDo0yjfnKKFkDXSQiGXAZj4Xz/AEMoSM735xVTCceOiyPmN7xMsMh
	wyyhY8Tn9wSvuW3x/OcvGHH3QXAPlxv0e6ICuxCpriC91mpUztdnkfyf4j+zUuJwrUL1KI
	EDYem1zUkjHFvp1Kre9gI6Pg72Y7fMU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xx6spLeD/N559G5o6OD4obid5RL64z15KRBlSZZl6a9f1PWsuYSY/9nUdVfbpFulC435UfGkVidSBZwl52FHj4fs+ATN9JJtuLqZ34R9hDKFk7LKCEwoiFezKuxz4l8DSVPGYhsBp1lxIhDrT5wB3Qr2zFQlU+sLgQFEOQkBX8yaP7yaZCxxX75f0FOb84lSGnPI08pVyLYlgUVRIcdGbpVmI6Dw4bvfQ++N1DG93ooNR91vpeL+FoStxCkQ/z/0EXlVfbs0qwa8JcnlQQS1O66dlnIdzWoXeqWZQuXqSHjDgLZ8qmcyn+aqm4Bh3LglSExqcGxkldj5PjA8r/CEsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0Cg9bCPvgGNmUO3E7v3ZZPOEy4MobIeiQ+nI4szqzU=;
 b=OtlHqKbdL3z+TTPGM6aAmaUmv0z70QxgouxfwLhgPLU0DAl6bJuNhcHALGy5LAHwyMrwFJp5xZN3Iz+bN2piMBYRj8vg4QwsOpirva2eT/YC8O6+jAqp24SFkTr+rXwBYb0H9k/WEHRkA8e5F1Eoq7h6mNM8wg9A/YmstB2AkMr0zavi/2rnaZrF3JJvO668lLZPydZsAwa4yrlpnMJ98Ufjtxwr8STlCLwb40UF8ZG3opbkJTbbVavW0oNhkDPS0OGjBQ3e5Uc1jLscxnebHRboL1og/Vhj6d044fc+/mW4PcudQST+6l3LzlXRtb56Rdl+TAN+YTRyZfpOZGn3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0Cg9bCPvgGNmUO3E7v3ZZPOEy4MobIeiQ+nI4szqzU=;
 b=gXqztmC3sPJZ+1yDz+KFvo6L4xfZxDa9ymNjFSmZrzkUys/l/oQlNwh2QAOrXHO7u6EW79PsPziY66gNRDPZszGbeAh3/WUZBPPU7/YQZxOIhaVl+Ylab6/0Pkuv/k/wEOfYC2M1uRB+V4nercNyoquMapP6n8kXrvLIailO/xMbQqAo2WYEuhCg7P57CYjEweIznKh9RoEUOP6KzsorL/qE+5X6XzAskMotn/LubVWpu33tZAYnz/h6n5izxg9FCUECtccmZ2odiN6wyGpNNtrtzh4q7NdlnbVzf8EqJ0Qs2/QeoSItQwLhlhNUxzde1y65f28v+eE7rmfb8oa0yg==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Tue, 2 Sep
 2025 23:57:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 23:57:41 +0000
Date: Tue, 2 Sep 2025 20:57:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: Where to put page->memdesc initially
Message-ID: <20250902235740.GD470103@nvidia.com>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
 <aLdcPeb8zrfDwd2p@casper.infradead.org>
 <20250902211514.GQ186519@nvidia.com>
 <aLd8l8v_DL75NU43@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLd8l8v_DL75NU43@casper.infradead.org>
X-ClientProxiedBy: YT4PR01CA0404.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4484:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b4adb3-80bb-4dd9-4371-08ddea7c8097
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bcD2uwy1uZtxw7MfNRrcRjtKHVG8dS0KVpwUa2eF00UdlwNn9bo99nfMoj3q?=
 =?us-ascii?Q?KXrIKtrnQkJPvRiuHZpClgEgeWRDNFRdaPpzkodr+H5JvFQ00jkIOjxpA24v?=
 =?us-ascii?Q?PzG7D0t+6AGJ22Q2XlChpXoaWrFRDW5ViR4+S6t62D4VUkekAVTJDWA71s/x?=
 =?us-ascii?Q?5aBuM6YgEmqrcXtO93W4A8MdR2hLenNVwIho0EREF6E4bg9q1D6lxKlcpf1w?=
 =?us-ascii?Q?xpBire/jS2ebLM0h69+FfzAz2k8i4xAwrVyiWUrh7z74/5VkXab5bDj+XUDW?=
 =?us-ascii?Q?f+y8mfBga5itrUIfyZ02gNOnyKSOAQOQ2AtYZ+bCOCWmdwvVuUHYGdKf/WI3?=
 =?us-ascii?Q?UaWzEXs3owCn1rffs+YpIx9xEdRI6mk4MLkih1q8KQX+PE+O7930YocCvgxh?=
 =?us-ascii?Q?tpXf8ytBIOZuqEwy5okBvLC3KDTthXf5Du2mxfHUex6ZlC9KEKCJ0RykBjQ4?=
 =?us-ascii?Q?Nze0TbufhZ3txt48MBjMyZ2HHuapsaSsk/wqPUJFMGT301Jp9p6CuwCgoFEC?=
 =?us-ascii?Q?8WHy91XUpn/ty2rTpBkzJ5NXXWmwSBueXy4XWI2nXJSSxVkPxgF/A83dasAL?=
 =?us-ascii?Q?BDIeG1GtCz4/aydX7PEy90zNRVr1OMzboOLj4tEqqAyi0sD2/fjjdJQS2cXL?=
 =?us-ascii?Q?itZd/XfWtQEOgMk1Ch8TdwGAatXu3zoJOExlVGpLczgWLz+XCRc1XE+DB6cX?=
 =?us-ascii?Q?PRCmiv32samqXuxoEkR6gLzF6jF2sgQzgMa5nuwHF9HRs0qPxR584O+Kv8bC?=
 =?us-ascii?Q?8Q+vBvKCUqEck8bGaySkwSTYLMOsqJEPKDSkNramKDIgCV857fQhCN/T3EwE?=
 =?us-ascii?Q?/y8jxjVY5oQiAygmAB+O+Lk9+/I/7Ny6HOnYzthaTmd/Ec60rPW9FHI0B/aP?=
 =?us-ascii?Q?SEJ+q6gwMY4voF5c7Yp6otx42t5htPYUqIsrft4Jj1GQkUwi6EI0NynF+AJN?=
 =?us-ascii?Q?snFo8WZspen3C5USOqaq8xrLoSXbc9946iPUjjn9sU8KBie9qdOjRw++pucn?=
 =?us-ascii?Q?pVSWkyX2mZ0XJQo7CdEkCXt5oS5RBWAuK1t9K3sqb061upYbXdxaiAQX1jED?=
 =?us-ascii?Q?Zl7FUS+zlnKgKwK7bDy68o3MdtTkce3EOoovYz0PzdyOTNMNgEMQYDUNZrs/?=
 =?us-ascii?Q?8u7FGnBA/1nv1XDRJzaI+X/wj8I7ApcdNMtJNK19cebDF0yGFe9s6tymc4H5?=
 =?us-ascii?Q?dsasKcH4VakviDCuo+3oyOHidN82s9j8sr7+6ilmGEfcaqf6QK4nQQsPA4Uc?=
 =?us-ascii?Q?lWH0oxJiBDXJaDFmeEL7vvP3ABEFtKjBQWKPChyw4YBT/0ZiqJHWeMuVF8iI?=
 =?us-ascii?Q?cmRA93aKJzY/s7TPxIK/xHEl2gunVML1BaeK3xw6YBnP+a/SIi/IxrpJlDRM?=
 =?us-ascii?Q?l5Kj+PGqGOVpZ6Epb82sTu71qQJcKB5TQHkmbgH1F259QKi2+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DMvrAx5hrhJ1M+XcVO8n4J8HxntXvttOgmQY/kHCB+6DJvD8/pJ6hWwwByQX?=
 =?us-ascii?Q?mIGRXm8CPal9WxrQIvr8Zr2NnJO7/i6mMNE5Xi7WmsmRvE77bNZv3Czl1R0w?=
 =?us-ascii?Q?ATEGM2A68aGCLv0/mGpFqiEQleDR+PT5CCYv47QiRbo5oHBG4C7ww6Pur4DS?=
 =?us-ascii?Q?ipx9iTLe7LbPIDwDQd0rbUbbipEf/YWXeXihUKJUVQOb0Q4k8jmqbSNvl2Hr?=
 =?us-ascii?Q?mOFoIDYVrQ+3S908otGqpfauJ8Pr4//ANpPUhM6lP5WnZKX6/JltzBNohs84?=
 =?us-ascii?Q?gmtydSkWk+8XrxH97s7k1OVv9un5riuEPamVnWkgCyIpZqePKc9UdJohG8bR?=
 =?us-ascii?Q?g3UHJe9xJ4jgU1Z7HGdWdn5oEltf07gUof4X16sZJSi4el7SQmGsafDS1o7d?=
 =?us-ascii?Q?3pND2OiV/ov02U1rgxxw9R7aLJgjEPpUnVQ/hCSFYuEv+LxuIo7i6IA+qwCU?=
 =?us-ascii?Q?fu6cAnw0J8EcIWKQ5T3X26qjdwtkusgPHfTVdHeI9Dh8b6CvScaNefq1TEom?=
 =?us-ascii?Q?ximf0n5UK5hpnsxiL6D/1831/XAbpf4cH15l/ZjcGy7V+NaNzqhB05zYa0ip?=
 =?us-ascii?Q?bJh/Q77Osfu8prusKwin9ODGeIBevAfSnBYsJnKaan0y1aBOMghS/EoKSx+0?=
 =?us-ascii?Q?AlSfCRvQWqbACWKDGXoyfw0p+VdeSo5EGS2NoUCSf1e3vYho0xakfw3utRUZ?=
 =?us-ascii?Q?v81kmsWDClWOTYY33ijgWWUS10xK6qyj/+9lIHOZPyLodFNhmw3jRb6wxZtW?=
 =?us-ascii?Q?tWbM1IW3QOfA5pTiLmdRqc+4V1+JALvOATEzbbfwJkcmDT66RxWOOdw4HHoS?=
 =?us-ascii?Q?QJTw2RJ2X5bx+/uHEam47orNlEDKoCv613XI/t/57wQOWTCZWBL/w3bi7GP2?=
 =?us-ascii?Q?0eGCspbZlnO/jI73CaLp0Wr6u/zOWCvLa3tKHW3omYpAkPFYOSK2u81qPKaX?=
 =?us-ascii?Q?tyznKhhJ1O4TbJ9YMHxU+U5eCuFeB5ow18pJgYJEWIrMpCjyieA+SJPGYQaQ?=
 =?us-ascii?Q?inBhTeRFPWnzYLz6NnK5+VMO81VVnRl+w7bn87h2bGV4PDamjKNJZ6diM4No?=
 =?us-ascii?Q?VgBFxGj5GhLC4S8XZGYI6TjkJKJRS/9WaaBvhhrgsgOy8AZqSv68h69E+Npa?=
 =?us-ascii?Q?ewv+fII78/wlEHrKJkZ3SSZgf/DRiNRDp9SeVjmJ48SkPO7oKDQRdsiyiiAU?=
 =?us-ascii?Q?5GG3epFuC0tp+xbwfCEL2rrocAwM8Ie9e0mWR1dduT26bu0TzI0sS51SM3Nc?=
 =?us-ascii?Q?qDPNk4Kn1eXIkKVD2lbp+nScuqjps+NM/Y7Aro6kKEacfOJ/zjlyMlj95Rc7?=
 =?us-ascii?Q?ntA1peal97BPPAonNyNmM0QBEwxDdHMICGtSwLVxP87ARisgTLXhDDFkDsAh?=
 =?us-ascii?Q?0sH8nqFPtTnmIPmJ9ZsGzFD7/mApN/jzdymyGTsqlJgP8B+9IMk9wmkXpw3o?=
 =?us-ascii?Q?yfR34jeoCZgPjvxoABPuooHhH6g77dX/pxo8bOeVHKYKQOXhfo+yzi5AAKH8?=
 =?us-ascii?Q?2ewPO/ihx8aLdxXVGJtWjG5gEpMajiDzMmS3quaZrGVcyUrktAw+lFh7lwnU?=
 =?us-ascii?Q?ltXjumJamaB6KNgfOj0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b4adb3-80bb-4dd9-4371-08ddea7c8097
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 23:57:41.2311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /V6HhciTJToA1ca/krx80nsJs422wEu31wbsB14lsU61daApvK9YqvF5TIMkaFht
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B05428000C
X-Stat-Signature: gi47w8snjaht7kbdo1enucdyeu6hnz6t
X-Rspam-User: 
X-HE-Tag: 1756857465-600434
X-HE-Meta: U2FsdGVkX18JBURiD8wvFPnPA0iihxntXI9vQBxNM8R1ibvltdyJ9aRV/cugm8xf3KKNHtYZTFSYM0UGXOXKE7yFMP5l0TMY8cc/Qzve7rK+m8oMW7gF+xrArpV210xtgX98i27whmTxYqenxGGtqJrZdgBhGAdFv9USt7LPfUgNVzHOzg10hpJde4tMWJhMS5JT3ocngX9hQWjumLPub658jpboCUmrwJUeuECxK2p7kHF+Jub2trZjPw4m+o2uOQgzaKilujoe9njezBwBUtUYH8kNPmgzAM4EQMQannfvCAt1J5isaX5s14CjA7x8cibassg18CtnXfPXMU8qz+kA5/Qkcc7HA4FqqF8mGNK3u61LAUJrRLHU2GeHH0viIgfSX06w0hWiES0iroCpl8kQfX5hHQ0k4CGwDpdkE1441SgKPk2jBUs3pRsNeBdqVijqPSS/TneRt8XFNGdyWOpGjLzkAXBg14bUEuqQjYQzTAZp5tggnBjwkm39+Ioj27GeX25IofUzSbaLyPZBM+qLrRdnmTm8rndiq0BxRlUALJ+ofkk1JxEVpmYup/blvtFNJGumZkOhguI3zY7EJCqM3HO6TQ+U6c8wurr/b0A6uZ7u05azxIg85vrrn7EG1DLQ/K6ZKyR01NoRHNIv6jC/RoHwFA/3QwR+kjrQKicdZhbS7xM9IpkNb4rWeCMwDiNiNEwjSGGTUctZpVUzC5ngyLiSjb0RbNHwYNXV7D4LhnYXPrYD/LJGYDicPRE6xPomsgkzbTrXSVnU9v+aXJpmWR2FXp+io0OkbmDXaBxvnhK07JaLt6BfXf+d5gCrXVBPuG582P2S/NaTDi2eS3vOjfLH1MMTn+6a0gyuZKhXU0/Pyi1p8GtoocpNGAtDRU2bhc3mllciUy2W7yvJEiguv/4rkOwy0X3r9QqirCMefxdeCNytI/7cBd402rBqrj85lxtvOoXkiYD555J
 9+qbiwaM
 n10ngFv+97luJjYDvAebCSJed91t/uiBR0pfpQNol9mY/qv485rIL35SerzFAHuXaEskfbRYW+IpR0nejgz6GggGrWW/LENaE6g1IvTOmQ3GAI3e7LYE/dF0oMFd4A1zJIqWZ6ql2OiLm5XIzRfVfNB8Nda/UVWk0uBGy54l8nCCU2puHEj6L4IDeV6Mr9wrVG72uPK4w3CMTarW+1zfLs+8MLf6sl2Q73Vpk/NLjYhypJ/EzsZgLkcK/SiRDW06/2zO0ooy1TU0YKzp+6Nxusfevxirr4uEKv9SH1Upynruy/L2WTdYsmVRFa0UTREzNrw5vItfCyOAkSlmL+ts5mWo0x9r433buuXXIXi6miGpvSoR62bZLPIMYMEbt72Y0YUhKTuy91JOEV0k2ruPzpnw//R8wCE8R2C8oouevgn/oGaAod9DIgBkr0U02mDipOKwb07aFGj9A3N9Ljr/zdVirVi8K3chYnuO9oH4a4ZdkoFcOwuMa8AYyPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 12:24:07AM +0100, Matthew Wilcox wrote:
> On Tue, Sep 02, 2025 at 06:15:14PM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 02, 2025 at 10:06:05PM +0100, Matthew Wilcox wrote:
> > 
> > > I'm concerned by things like compaction that are executing
> > > asynchronously and might see a page mid-transition.  Or something like
> > > GUP or lockless pagecache lookup that might get a stale page
> > > pointer.
> > 
> > At least GUP fast obtains a page refcount before touching the rest of
> > struct page, so I think it can't see those kinds of races since the
> > page shouldn't be transitioning with a non-zero refcount?
> 
> OK, so ...
> 
>  - For folios, there's already no such thing as a page refcount (you may
>    already know this and are just being slightly sloppy while
>    speaking).  

I was thinking broadly about the impossible-in-page-tables things like
slab and ptdesc must continue to have a refcount field, it is just
fixed to 0, right? But yes, the code all goes through struct folio to
get there.

>    you're silently redirected to the folio refcount.
> 
>  - That's not going to change with memdescs; for pages which are part of
>    a memdesc, attempting to acess the page's refcount will redirect to
>    the folio's refcount.

My point is that until the refcount memory is moved from struct folio
to a memdesc allocated struct, you should be able to continue to rely
on checking a non-zero refcount in the struct folio to stabilize
reading the memdesc/type.

That seems like it may address some of your concern for this inbetween
patch if a memdesc pointer and type is guarenteed to be stable when a
positive refcount is being held.

Then you'd change things like you describe:

>  - READ_ONCE(page->memdesc)
>  - Check that the bottom bits match a folio.  If not, fall back to
>    GUP-slow (or retry; I forget the details).

gup-slow sounds right to resolve any races to me.

>  - tryget the refcount, if fail fall back/retry
>  - if (READ_ONCE(page->memdesc) != memdesc) { folio_put(); retry/fallback }
>  - yay, we succeeded.

It is the same as GUP fast does for the PTE today. So this would now
recheck the PTE and the memdesc.

This recheck is because GUP fast effectively runs under a
SLAB_TYPESAFE_BY_RCU type of behavior for the struct folio. I think
the memdesc would also need to follow a SLAB_TYPESAFE_BY_RCU design as
well.

Jason

