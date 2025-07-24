Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F6AC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9A78E009A; Thu, 24 Jul 2025 12:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0D48E007C; Thu, 24 Jul 2025 12:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B689A8E009A; Thu, 24 Jul 2025 12:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7E358E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:20:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36B8211323B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:20:09 +0000 (UTC)
X-FDA: 83699670138.21.C870F53
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id DFE2820018
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:20:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ou0DNX8W;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pJPkWSX8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753374006; a=rsa-sha256;
	cv=pass;
	b=hLwzy78s1OgzW3LKRjxiXc0Dr+yFMh/5EGXzAbVxw1BTMKEPTIP8730YwJ6Ljc5e99uBeV
	cUnK8Jb/bREaMe1uwWUO9v0HcdTXzfyULAStCfm4sFrGnTR4HEbFp0GKtXfUD7h1LLjycz
	vrkjHDsathKDmuxWA3WsqWuISCoijuE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ou0DNX8W;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pJPkWSX8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753374006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZOIIETmPeQPqGFXNEVs3XxPGuTgDBrfcJzpCp6McqU=;
	b=K7KwWxaGv4VFm9vpRpL9TViPTUVjoWdC0iTdVVu36dpXEw2FNDN71jiByCvH7iwoSYbxMA
	+aZ55jcGs8r2p1cdP2EYaZSQdpRM7WCOKs39KRsim+JE9mtd9+rMQCpKNCj2LJOb8qHH6K
	FIMnyA3ynh69h9CAtDlkAeEiRMT2hlM=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ODRMnN013164;
	Thu, 24 Jul 2025 16:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4ZOIIETmPeQPqGFXNE
	Vs3XxPGuTgDBrfcJzpCp6McqU=; b=ou0DNX8Wa+2mgqW3f4XamTp/r8Udlop3U8
	WkTG0FEwEI8+bkOpyipU4smmnfZ67UiXXFICZoMYEWsDQduE9T87kOfd+Cyi+NfI
	S6c/Li7k78N93k152WsueplMu6yJkOyOSMmOPxOl0iRfz9ThCfcd/Wr2frkAZ9oV
	HBEKA6rUwBCTPmxwfwnWm1E4MUVdd6gnbPafxfJmjU+wiCXCpfNjiLLz3mpmGV99
	9QPNU5AMOLJfGnga0uw7ExbgZW6OdlhKk4C3NZEMGM3AIXCVQIQ48p0vixXAGt3W
	LV8LvAfKZv6MHA8tfCeYx4C5H8NLdaWKwSJ4JhLxXaG7Fk5YsvpA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2hx9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 16:19:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OF2xPD010800;
	Thu, 24 Jul 2025 16:19:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tc0yx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 16:19:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gmS9czTB35BXg6qQMK419X1JzLZTIaNH7sIwN/oygLj8wlqX3puaXYCBrFrr/50UFcjC21kkc3tfG4H0VteHWuXCHBkzGvhgS81Vg65G25OMVkiFVN+o/2TRe9qPn/hQgJcAFVsfQiIf4liWY7Rs91RHOoAZwsY68y5e8vuGszI9WhOc4ys3x8smk5kWJP+XNSBwf7mtZDiFUe3rnpkKKXt/L1T8ZHS/NweiLfdCqJB0JmfCgFyYg7C8X3ME6jzLhdB9H3mXBaRUalSOAAEpYZWQlk+HfMTPJj3+DbI+QnIt/PsmI6UUftZ0m1gaRYacuX1sCtHgtTSvPQLBOCRtSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZOIIETmPeQPqGFXNEVs3XxPGuTgDBrfcJzpCp6McqU=;
 b=SNY6/hhEEw7k2279WrUAfAbDf91LPIjKqHx7qGae4BAgV2IhPiyeaMoV3XYfv+MGmPLy4MIfiog2bAOPJr9yF7rkcv4m7yvF6fb6wUloHFDn07FhjvSjNPyd/IOd99//1/nWa3OFhqf4LdlEc992SnVTr5ZqMADwNCDfl4S8cOK+ooiF3KptLcI6/CqBhy/5lCcJRHKmg764suJW7VDx6ONqUb4Ncv0mbWgVy/ZS1Ld4GZJhWVV8GzCxlqfL4Z9aAOTBT7iq4M3U/E1+AGpaRjlt+doeT74nVV7SGwjiNumIVxT+ohW/4udXAv3OI7C1aZInwrB7iwN0YkcisjBsAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZOIIETmPeQPqGFXNEVs3XxPGuTgDBrfcJzpCp6McqU=;
 b=pJPkWSX80Ydsrolx+HH99ohSB+z/aD72b1/TNjxJPxU6gNN+ywflEaptIJXfcdxBPFDGN08IfS6IRFNWsyL95ZOm5uo5a7Jab18RNSoGrlvhIvd20vm3E5cV6tw5HyjQSJ4C1SDk2Qcx3gS/vs20MIfTW8ja4dDlog2H5QD6EMw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7932.namprd10.prod.outlook.com (2603:10b6:610:1ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 16:19:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 16:19:48 +0000
Date: Thu, 24 Jul 2025 17:19:41 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove io-mapping
Message-ID: <4703a9a7-ad1f-493a-ac67-e6dea05cafb1@lucifer.local>
References: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
 <199a9d2c-9e50-4740-b29a-6ffe906e7d9d@lucifer.local>
 <ee6df343-6500-4443-9af1-4d15040e39c9@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee6df343-6500-4443-9af1-4d15040e39c9@redhat.com>
X-ClientProxiedBy: LO4P123CA0307.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: dcd4f19d-abd2-4fc2-b007-08ddcacde916
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+Ow7fimTKpjlIoEhdgaP0Ct2iYSqgNt0yHmBqRHZ5t072cQAU8n7de8wnrDB?=
 =?us-ascii?Q?5i5CuCrAlYNUCpz50XqiBa+tVNFmMzCd4wVvVWay+Z4gwo7iVSjALinhERq/?=
 =?us-ascii?Q?bvWwwLNAPhH2KV+eIso60tjJI8FOK20Wss1j55mGTnlzlWOZXIExL9xvJi2Z?=
 =?us-ascii?Q?lXKzWn6j3SCw2ITVFNNoQAzEL6wmNbs4mHv4SMKmzPvbn8vojIHPad2CO1Sd?=
 =?us-ascii?Q?ettJGTDrA20hPdBi2vaGt/KXiLRjIJF3SMPO/QugLGK/oBgq7LDt+6wFPYzF?=
 =?us-ascii?Q?TABNWm8tOukcPjqQPV+cyssiWne2FCqhZc4Qv5iVmtO+7PM0qPVkEKcVKICE?=
 =?us-ascii?Q?G7OLyAzcdYEuOGplcnnB0SEQmst1zlvE2zQAtgzRkRqdpeqg3t27bSrEuP1+?=
 =?us-ascii?Q?r2JbGLSY1+Q/ZJRJmuSCTBYOoqLlVsdQkZITkg966xCuEKTVg911xlUYOONd?=
 =?us-ascii?Q?TXAqsGDsC+Xq7WrxxLYkpFs/dRuYumJS/AaRM2FtNN681FXE5Bi34gfa6Rqk?=
 =?us-ascii?Q?oEvVXHxpNWEXd+uN0O88AIv5eniXbRTbJLvKkZZSJ/j4yIDTFMUFB0sO+RGq?=
 =?us-ascii?Q?R1UajJqikyVmlVHLeHfS4kfydFPiENdWwYV/83BaeyQQGt4mLxkkvxS9qYdN?=
 =?us-ascii?Q?4OTQqEkSO3yYNohwsZv8e5xAVpfiJhxJ5GhHSAU2Sl853AYH5NbkKCvvgfJq?=
 =?us-ascii?Q?Uz2MQJ9765BZt05xsdGA/49eJuqRCHlYFfXol3dxUJHclfwbM0ZZ+/zJJdum?=
 =?us-ascii?Q?93Y24kGrbWAl3T/j6mBUUMwb5TfC7u1bUl+alVBCaKc/lPZh8GhT/u42Kx05?=
 =?us-ascii?Q?XyaXabN5y2D5m7KGZ0auhFgpggiJVSyxGxGOVRhRgAtImrPbuqIUr9Qq3pH9?=
 =?us-ascii?Q?MYAOchx2MfvYZaIEpcy45vCrZYwibIpjLA82jgO/3PnAiFzP1Ioekp/nM8SK?=
 =?us-ascii?Q?TCJgmOwY82+gJj2yVw165luroVd4QxJrq36tPrrHlMDX0muwHM15vWUlExap?=
 =?us-ascii?Q?zAW0jTSyGR7GYJCQC39jTe3EiU63Xo3la749ErFQuw7qBhlVrdFsmr3cybHu?=
 =?us-ascii?Q?uXQnIjhRJYO6FZ8y+FNkqpopJJsybfv5TtL8tU2KeYZvTJqd1FCaPCZXu3j7?=
 =?us-ascii?Q?c4dM9OICt71dwqjMdPYeK7tl1ohTzvxEFabLc1OwcVYroNhg2+zKCQs0GPrE?=
 =?us-ascii?Q?G+060T6IQgM7by5uZN2oeG1iorLZXJOgvvJYiSENGmxI52LkgXFqsayaY13s?=
 =?us-ascii?Q?LudMoRFLTe7hO3boJiSdZqveqrlE43JVZlAOxEmaB3EGdSgShbyi2P0jBmdF?=
 =?us-ascii?Q?DwC7NHr1v6SppBqLBFN7U3yl6/6HvnL1u73YLi6bu3I7mHfdv6AsL+UhHOUW?=
 =?us-ascii?Q?uhcpAQ58j6fVzq5KNmig7b8Dz1AfkIqezPp4mGIrCnUer3tJZ0080ejP4DHq?=
 =?us-ascii?Q?mNiAQ+OHBYU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nuuY9O7sW231jnTbmSmD2cN9w5GdjsJilS1gzYao0/iet3uRaSwb5c7+TpaY?=
 =?us-ascii?Q?QgVv8SGHby/RlWjK+6sfPYAEOZSGBfSY1idfmjjWifKpLzqH6aDruexjCgoi?=
 =?us-ascii?Q?G3fwjrcr18g3uDVS/5tEVeUH/crgrWHXOyq9Gg3NjMRndAGtzjjUOQY/CiZw?=
 =?us-ascii?Q?BKv1wKDe3bn+ceW/ipoTqAKNeeYQrAdah6McAun4opkXDQwTQibxJQ4kU0j/?=
 =?us-ascii?Q?a2xrb5PWJwElvz5GAtGPTlC6RYisyevzXhrH+Z/sPyurT5kN49gBjOHXkF1e?=
 =?us-ascii?Q?hrFddhLoFyoUc8wkR+mXxXpy4uCbWS9hXueR2B2i6uR0Fxlzvd0iPvyMbvTw?=
 =?us-ascii?Q?F7va/tonOpg1C1trk2llGb3DhC0eB6nYQXt3FLzOtgUSqIaZ9s0X8snGaPAG?=
 =?us-ascii?Q?w3BkoB9PHbC/rOw/HSW/mIviTSDFUCvdrlmp6j7gM8s2dSp6V6GD55dg0ef5?=
 =?us-ascii?Q?MDwzf2K4B4zPgLHt4SnhSOSR08j47NvwQNQc1nAK7SbyW0dmUC7d1YDP9zNY?=
 =?us-ascii?Q?oGXn2r1VQklrmcCtYbkQ9Ez3rEYNKVJltHS36iAf6gboYysdyio/cx6UTewt?=
 =?us-ascii?Q?CEvOaFshFLs7dc6nUfAKVOMMJ1UP5e86GRk5lb5VV+ocA1Cx152f1XEFxBJa?=
 =?us-ascii?Q?uiiUURWRsXaOGTiCAbfiXuyWRyQPPUe1/eALN2+Uetov/acnPd8OjVoX5468?=
 =?us-ascii?Q?phTxI9pFBSmb/yLxkdYkrkBe0He8arSiw5ohy2suC0GjOPOxXqb4ALF451rc?=
 =?us-ascii?Q?FtFIE6IQ7e3dD6bysHqNBxnMrVn6lX2nHgjqkz0om4v9+mvhQeLJuAx9CwQI?=
 =?us-ascii?Q?CIYCgihbDkffI8i++pNSD7kxKrYmhIiMmn73vl3HupSjyoXZSB3m5X3uk9Yi?=
 =?us-ascii?Q?zfZ8rfnEW0OFNNLMI2Od7hCyrYl4BBQ+IcIxTwNULtfNGKQXkajFdbKHV2ly?=
 =?us-ascii?Q?nNXT38aFtekG9HfAQ8Bf0roTslbQPEDphzY3I2e3ymtuwWHV4nOHX9j3zXUv?=
 =?us-ascii?Q?sVEbum1dYKSuOJSYK6shzumL93832tljsd15kMZOsUfncdj0YMFdSBt+koHi?=
 =?us-ascii?Q?B+n+5qhbHel6h6AmLBi8mHgXtsVbL79mP9zKCwfWGq6O0mxlanwyJKLqpDCm?=
 =?us-ascii?Q?LgIM/WjhPMchnWTljdb/Nbqn3mZDXcsJSD4Gmo+xYsls8YKRYr80R70UxB5h?=
 =?us-ascii?Q?Bdt6D/dnYXzXPMnoHEgl7gyHaabyUSLyCi27fjPJaIZnhqLMo4FnPFBKNalL?=
 =?us-ascii?Q?PyYUgg0OB8umVlHNRhFCeJuXvvvHWb8Nno5vrhQrwEtjHW+3m55tUrgME7au?=
 =?us-ascii?Q?n6ChlXVvmOwF9I84hr2b+9gP2oC66f2oD+Ko6U3JN+S1dfWPzQj2PzRDuK2P?=
 =?us-ascii?Q?t715N+fohPhf2q4In8yfcdd8xIXhbPcuj8lEJ/N4jCRctGSFJFMKZUY5U64t?=
 =?us-ascii?Q?sNxJfzKWXZgaKI9n/XPo02hmnZ57y8PeRLQG8wCuBudK3tcs4P2y10x560IN?=
 =?us-ascii?Q?utOBNtv+NUm430SKrhwG5CEcSm9f1xV+6ZSgl6HWJFh/UYeQaPJWYF5GRa5F?=
 =?us-ascii?Q?/3BNecdS40700VMQl4LElOcK1Q6/Zk31F30ZACPGOY56AiaQNFDyeaWN25N0?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z1eV7+a4IuvEI7UmcQsqHrm40aKOmax97H8s+lUGHNzCFegKznO+vZXkmYouga04iSfjO1f5qfQgdopoKfp8ZbcVmMtsm86nnzGQS4eYPy8bKUJ3kaOq4lx/Aslw/L1j9f9KmYmPPfpJs5apFep09zGbZL0jqpz1xO9eWpD3DgvZe5rh8SOcWZogPh+W/Z5LBivsB907EgFqVPt0OOZsBhIgq74xl7O7mig6NoEy2Y1JwGqVZ2cuhbUdNc5BVxqrTQoxO/GAlMepVAD/zmmvlDHMKNIL8cNXTJSvo3+QHfOpR5DU0MdefpSrScHQenzRlJ+CsP9OmCQpDDQkqfcE0Gu6AFhBJzh4hgSR+kIXH9R1AxI4iCNloL/++YqF7R8VXYKHgOtIYiy8T2J7s7vsIRxCeU6N3KKJ1iaWRjss2vm4mO3svYGJ4lVCxHAWwWM1wsejZWeLe81js7bS4uGcpYTsR351GY6XalxJrlBd2HNeeTWWH5rSbpZtnS/2FcsvQze+Ga7zNSnkGEFxR0pYtXtZtB9GVNPRa45NVbniHS6BOS4OlN08vKgsZQvW+t2NyDct9MOfjmQVV4z0X+6375EXsvqi/FodfQUi8oQmJ4Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd4f19d-abd2-4fc2-b007-08ddcacde916
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 16:19:48.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHfnlZP7PeluAZv5erDHeMKo9kK0QqxmPohsXgEFEbP0JfMgBavVQkRG/Uwm4gE5xjz8NYXO+lsDvUja+8HYfORusgcVJTYDQO1Ppw/PNJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7932
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507240124
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=68825d29 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=bMetdsquFEqCRb4A-nsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: nkKHFOIo4QGZkcXr6uAUbZbefk2QnhdH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDEyMyBTYWx0ZWRfX2aQ/dXTB20Xe
 /3LuD83ohH9kaXj6qnlTbx5zZybOSJ4/IoIZoAnCUpRaWevrQQBBenh6UAiUJfPk3l25nQ4a/Zl
 7+hWbMCSv79rEc1xLAo6RJBpmvpyYfK7oQftPZJ3zc8oOlDwIJaxami/GqRRvbUZxQa7jitPNpf
 0h5BQCUiBSkCQemM0MuoReCj4ehv9RK6C+SsaRIoPapmEEFhKdlo3taFu9+NFntziA3o2TF7h5h
 /ri3tOJsBW0mZUOOlRdmVfFm3O8lZ8QhFz+giDA/KZSwcO8qPvS20qxePJVOHjzVZPErPEpZ38H
 9h1h3Db1nMZLvgYdANCm0GAhbCaBffROCO/S33+zPy4hnHWMdxMKXiTSnjqmG/ihEokPteqkS14
 FJ9QV8R3MF/YPC/O9ozzlZj4IlCqzon7HEyr7sBzoG+MYoQd9sARdKLzd9BJitndHl6dcVxu
X-Proofpoint-ORIG-GUID: nkKHFOIo4QGZkcXr6uAUbZbefk2QnhdH
X-Rspamd-Queue-Id: DFE2820018
X-Stat-Signature: bk69efxehbru9yxyzmurruxfexcshkfr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753374005-568127
X-HE-Meta: U2FsdGVkX18g75aj8tqQnigkkDPVj/SPZtCTWmQVfCTUfu6YN2nW67Kj33paWrPn+yQnUoZ/ksOZ4kj0dAYJytJJ2d5Rn2bVj4DP3gvxDsUyiaFZlc9wfsEcFH0cm42/v0O5F9IgMChPhwdkhxbQc0ab0XQ3cSKnrelNSZGC8k69LTIngs6tSKu+Z5SAxe0n5SPJM351dDZ9YkyHwKjgO3MrGxIXZfYUw2Ro9E/wKDjq2+sIJxtq9mhqjZann/ZvtDONT/lglH6xc0PvUacsinyXNR9TvdAT6Nv2+Z4AHlsHYMjQBCOo71g3YKcILEMhyNYYBwcimKbVTYgMZeH4Xh3kkzaU3/xSTuoWdykQh7kB83Bzv7SjvwtljfDYKTQAh2vFQNPUVIc+CzFxZlmAO8ubjSncjUqF48d1QUjdDNW06+SPPaxulsgV9E+kDzkXEq32gMv/mYvQMz08ApEpQad0+7e/ThfrWR9V+QA+9oJM2QLeUxCEH1e2Mplipe3vwDAX9btSjdI9GA0bNwDV0B13wJknpc50ht1DSsqFWlVN6v/m8VQ66Xe0Y4uBKmwqrngWx5MHRFlQnhqWNReF5Kl+GE9yPkkOWZrmmXZK6FgvzDUlGF6+ErAiAQX2LGkS1DWebhOUSdI56HjTMmrSJOdolo17fd86MKCEqZ29u16PaURbX2Zk6RW5WltDfnm8zr+UM0XZ4grfXeWjciYc4So23WIKHI4cHbxm4Jo7BznUxiOcPyCUEYFxNkg8ZnLpFBqG1a4GoPnYS0wMoRySJYbxD7twF2qXd578t81SDfRG06f0u/C09FMdDw+JxfuikuoLl+8C8VmNZ37HdhNO2eeHa06hTjAGcs4be1qaSFykhil9Uc8laQqfHjrAhGJ0u9UuW3eTkX2Tb27Q2CSKkoNVHm1XS6BjVl7Tim1h99bGdOFYcglIetg9F2OYYyu0qGT8qwRhw0W66PFOx3F
 +fumXvXI
 4ICYpwFM4pCzqZoTjDZQkM9Ge9MlNTerZAmX98Geh2Avq44MgO1DTuXxeeTdSNeNwR4+4xL7XGwxNiSwP3GTZk1EcYZi0tI7qoPUk/RD/1hmWmIdXKQ7k3EGQFDrHE/+PzZcg6n0MHRdSaz2Jp0quggxL2n7IXPH7sJOUhPN7i/qXR5vFQcMJyirwd7N5iBtQpywbU8cemWzE+kPOe673URfJsDakuNRVO2E0KeqpKzfVt8dd84UnujMCbBWSNPCpNlbzyKEiV5TVZHRPbiP8ARXEaqfiASmw+KFJNgqfPqDLYrnTSFU0cdXqCbON9P5DEg1NMm9FFsx2L/EJmcLN5XjLVrDyGP79WtXls0i5zRH0cRdS0v711YBmIUa7FA1IauPxek9FmLM+07jIjma2LbBY43wUzdyExDa72wow3vwCECAtac9+6FjDgbD8YFl/aM0fgzlbjPYsp2B9WSK1BGmG9jxmLOKrylsO7rVQEkFRIxbmKNkrQoGiiNtiuJQG1FjUeacyKY2/YdyiooVT4gRmewXiGj7yA6bVU5RrvnuPnFaLzn2GP27euic+TG+ZtjFg8+5gBbGKlqktOMPLjiMn9YT/dPYUevkiKUtccB7kZH2ehlQZ5SELIAqHSu2TscLoUFNjDY5LIUQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 06:16:11PM +0200, David Hildenbrand wrote:
> On 24.07.25 17:39, Lorenzo Stoakes wrote:
> > Sorry Andrew please ignore this for now, I'll send a v2 later.
> >
> > I'm not having a great day here...
> >
> > I wrongly assumed that, since this is wholly unused in practice, that nobody
> > would refer to it or include the header, but it turns out that's incorrect.
>
> So, do we have to keep all (and keep it in MAINTAINERS) or is it just about
> cleaning up the headers?

No we don't have to keep, I just sent this patch, then Vlastimil pointed out
off-list that there were a bunch of includes that I missed.

It's matching about how my day is going.

I had wrongly assumed since there are no actual users, that nobody would just
import this header for no reason. But hey. They do.

Apparently docs also reference it.

I'll just send a v2 tomorrow.

Cheers, Lorenzo

