Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F4DE7DF08
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543D66B00B3; Mon,  2 Feb 2026 12:02:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B0A6B00BE; Mon,  2 Feb 2026 12:02:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F826B00BF; Mon,  2 Feb 2026 12:02:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 276A86B00B3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:02:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACB171B0C3E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:02:19 +0000 (UTC)
X-FDA: 84400134798.25.63945C4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5470A180019
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:02:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D83yjT0v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EITOzitK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770051736; a=rsa-sha256;
	cv=pass;
	b=qsqAYfuVbh9Prg3mTlEMDyvadcbJaX2G2eG+dDuxyGSq23TymWZz0JOlHVSOC9NmSF2C+M
	Yx35fYLtynb5VtQxHz2sdrEIH8tECoiIz/MaZbg42tsG+UsOyl32WCp29KoWYReU84vtsQ
	I7nxr0THEQ2gRfR3MGtERDl5yXF5wR8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D83yjT0v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EITOzitK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770051736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aM5BqZXRvTITUf7qdl4kor+WPIckKLlrzdxqJO0EmEc=;
	b=eM3iunMNImUCmTIugLbgCxrdM5NldpKIxhNtBnZy5cRNFxvrU/eSvH8YZv1y1FcuxlMr8r
	xu59lIsJRgWRFbbKevQpM2cT3+DjxJWCQ4h5MwJKI69D/WaIi4Jh3RVwXx4KE7y9SKDzQY
	IOqsyH70kfrhEMczQweNzSxg3TshcEs=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128uOiJ1267721;
	Mon, 2 Feb 2026 17:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aM5BqZXRvTITUf7qdl
	4kor+WPIckKLlrzdxqJO0EmEc=; b=D83yjT0vMrQqOjz4ZvjBb7s45+F8704P8y
	eydrx9XRD0YY1CiYHPRc6biNW6PQhevzA/R+6I87pSRIdHrPim2uECXFb/VlnsEG
	XSllJLEso39Ix6Z2z9+an1Jmxq73ACdT3b/kAllafkJnFSSbAaTumjSZsXtUOFLC
	tkCoU4hnYvIxCQf+OWHW8OJXLOVLdOiUn4xl7XriUdSmW7AMHeCOyLT/bdKIV3Vb
	cGJDXe8UGxRPjq8d3ET4zA11nHZOgoSbUpqi8qKgyfucIJ0xiWEwTpFlGKgoAjKi
	GfQ/Be8TgeQn9cckcq6Uc9WBKBiSIsTgCdvKwRl7mjo7XNzuijVQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1as3ak1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 17:02:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612GxkAF018649;
	Mon, 2 Feb 2026 17:02:03 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012002.outbound.protection.outlook.com [40.107.209.2])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186k6aav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 17:02:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ny7FKDDZECfvmaGr+TFkIH4VYTzTJDrnu/Py39FsVWZptOf2UYt82cnUYrVElCAnjBWHxSS9zJimWn1Sy5Eh6PBaSQCwhwRjuzTYLnFuR0ZhvSmzfvDZYO//tLQYaJl+X76Bnick7bjUn0nY6DlyZHdY9Db3Q1PMsDYcucNVlnsA5tXoOWwdk3oCuOuTTDLg83WSTOM2YexJdaKI88V9Xulcrbs2Aar+GPUHGW8/57DLcXMUGq4uKuG9Wx48rFMvPmKgDYDI65CFzHlA099T1N+aULphB2W4h2UcvABb3K1WR4MZrAV4xbGqkErlQM/NvsgmGSJidQNdjFGZ5LjQ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aM5BqZXRvTITUf7qdl4kor+WPIckKLlrzdxqJO0EmEc=;
 b=xqlx2F7Mkl92MsIkbl6bESo6gKt2s/UFzqEzwtzLf1ZQR6LGQtpyLTeJK1lurS0oqkqPS2A2jsPplqFMe9pYAI6Gw4RVloZL5R9RJ6dfQMNkOuvMa+UuBtNFH6BB/KpPuCxUBhXmE++ugbBpRpY8cFM3tluwRtvGX6Navgo4Zum77cEXgS9Z8xxJeUP2KHqLe1ovovAo6rs/zsF2BvWI1jHHX9DRj1U2q10iG2uUpAhHSqT5QeFl/v/J6T06neK7R3ku37OV2eGPAN1vDxS+pqTNhYb0cicKLJJiSxkJgjsDeBUsg7XYQ8ifxOwB3pwEjQhEC1nZRmPb7ztK3T5wyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aM5BqZXRvTITUf7qdl4kor+WPIckKLlrzdxqJO0EmEc=;
 b=EITOzitKq9qD8ceyBr2c7XP8UJhs0borsId1byjFbovZ1Xkdk5DZ9EJXnLmY2xqC+3xkQeHeKXWbsnSAhsmDMrA6L9ZSsdX7NWfFOVhQe1auoirVuJR0k41aPkMBGcV4TJDnPyvtAefgBwnodLQ/YoPMkeCQENjjs7oTMI2OZBg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH3PPFAA02B7A0B.namprd10.prod.outlook.com (2603:10b6:518:1::7bc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 17:01:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 17:01:56 +0000
Date: Mon, 2 Feb 2026 12:01:53 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v3 21/30] maple_tree: Add cp_is_new_root() helper
Message-ID: <q4ak334ehwt4monlqqfwe7cbyxtm27qhi2isrk4ncqjixfohgw@iwclrvrjvxeb>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>
References: <hdmikz55tn5gwbl6y2bxwo4gyt4dc6bc7u57oidwbotncfexeq@efa6s2xpgkz7>
 <20260202155627.16416-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202155627.16416-1-sj@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT1PR01CA0116.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::25) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH3PPFAA02B7A0B:EE_
X-MS-Office365-Filtering-Correlation-Id: d84e03b3-90fc-4142-58de-08de627cc59e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cLTV+IRybtAtk5LBWC54JQ3PalbQPJH8sRuuJ3Z4aYeHMfUlK4MrQpnhutG9?=
 =?us-ascii?Q?OSTvVMYiRoqbxrQ/lIVfiYv1UQbArtgPpb4uWWPJEvV8D1dUbz/UShG2rGgk?=
 =?us-ascii?Q?sGJsoSQe9XVnszy/Wglqa3ffT9KrbMoN4H0UF5XKWQlM/Jg6VkRMEox2U0Ot?=
 =?us-ascii?Q?5heJcZxkbji6P0FwF1gQwrRAOMkEScmGJOIUUzaVa8s9oftrdTUaXqZM0qeb?=
 =?us-ascii?Q?Sv4cNqlkC72Nuj+F+rUSGUh/0v/2Ur08nV9FSxCS4jbNsRqzrZ9qIh6fYn2a?=
 =?us-ascii?Q?6fV/fVn4ryuH4mBzQcAxBd8npG5/fcA4hG8nbzjsiXC7RjrbRv1J4Cted5jP?=
 =?us-ascii?Q?tBbxP6kv5ZeJzucTSIuqzS6PXa9xJaZRriycTObbMWjUXYfPETPuvGmwdN99?=
 =?us-ascii?Q?GjxBPP6KtSavnvdyffMXYFqbP+6cOqbZFa2xO+i++wwdPNSbnXqyPNFN8iQM?=
 =?us-ascii?Q?aEenQuKq6DI4gGyZ/eEK4FHbW5AT6K3bpgCuVUiu5BLfdrT/+V44+AieYQGR?=
 =?us-ascii?Q?oP+w5GJcBOj2odN/apmHIpQ7Hpy77AsENCl7Q82RF/YGJjz+86giCWPXFKm8?=
 =?us-ascii?Q?YZ3abvGbJ6jXJkiuE4AOHKLQaR2OHiIaezrzWw12LUY9EPVYfpqToLLglMmW?=
 =?us-ascii?Q?WiJ9J34L22V+OumgivOEIrMx4NeNgkCWt/K75xOZKYiw2wLBqEjW/f2Ab43Q?=
 =?us-ascii?Q?jU3LPqKXE+BCG20/nL6VU41J5FEold+TIgkkak45yxtEaCTw99ogKznavRdc?=
 =?us-ascii?Q?Wwo5wJ6aIF+Vga+Y+4Q8knLS3gRv9rDa7NbtzntPWSjYlw0aGQhIyH55OJb9?=
 =?us-ascii?Q?yq35K872yeaTWS73ue56/ofDJPfPwGCIrknEgwZPtKjsXUAjEZeuUkw9TGxY?=
 =?us-ascii?Q?GHLYPS3Voptzrs91HsMACP5WmUGrxuTiNMKLXK7nUW0Cdh4N4d02dKSKS3fb?=
 =?us-ascii?Q?ffx607O+Kyqexg3X0H/yNGbNshHGG9SFiZRUP+/odaA0x/7cOkuG0DNuhiIe?=
 =?us-ascii?Q?33mjiyNK8QtWTMdGVWfJUaz4O6fseLPtMzoFkdpWvlA6PzKzFk9eotzgMmj/?=
 =?us-ascii?Q?d6/MxxTm+Hcp7Wi+T3eveJCW4gQSZWythoRD29CRe5BrdUXkD0B6c07uLXca?=
 =?us-ascii?Q?yEOd4v8ypt43b27YpIIsABTJJChN2HhFr0f03XnOH6XCsFwSbY3HrIMwtmCJ?=
 =?us-ascii?Q?vaXXgxXQCbKFvHZj2S/3RdaJG2w7P/7IlCzbw2QuvvGzYlKtHfRbQY1mC3Ye?=
 =?us-ascii?Q?ixjJxoriMaYkE+AaXCnOiGZ0IsIcHAPv6787Ud+NAAXE0C/McH3StJRj23s/?=
 =?us-ascii?Q?EaAjGzvTzHtM0qAR8MVDA+cP0uMEGzVxDwjEQj7M5BP7Ybgv9o5yoFS2KEnQ?=
 =?us-ascii?Q?hXa/6SzTIBcvzp2KLseEr+9lXFa6BFvFk+l3Kz/cqQEpmvhd7E0dUDjrzCYh?=
 =?us-ascii?Q?SkicDLiqCN522Rt2Pe0NvPX6tZ79tYXuT1q1ycYTbcf3jtcyU0wz4RFNm8C0?=
 =?us-ascii?Q?6O5qbLOz0vVrl/bnMNr5t+/CPpwAv2OefjVOQPBxlqrbMGuMKGQn+gV4Xpgq?=
 =?us-ascii?Q?mSVemFTqRZLMxF1b8+nsk1nnSouWPwD6srz9Hw4G?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6F+MDxIrlt8GXNK+9kv2ASFgQIQIjjftqGzuyLvZc49l9aSb53aUrBdi0O/r?=
 =?us-ascii?Q?f+tc4pfDLrVufaTiBqFyp+Sftyu71ip2OWa+zXfMGTUDwdA5xd3iB1snENOU?=
 =?us-ascii?Q?eHSPIvvv8iLDBKRJv0qxsi9bJToZA7puuPlQ3Xsr6eAbzPHfz2uxTbW9xJiQ?=
 =?us-ascii?Q?5enJWLbDUaRFgfipiW9yZb1Du/ID7CG7DeApZ0KFBuDF7hm7IvGHix26x9LT?=
 =?us-ascii?Q?+6tMqG5LUyiWf4YVv23QNa7f/P5wc4sUF22afo/r2zNCozTRU1tMRNdSW/dB?=
 =?us-ascii?Q?LN81cAoyjwRAHzgOP25pUBUxye8xVqI9YyJFzyk4D2Z0kgbAEyL7JrP80wjC?=
 =?us-ascii?Q?Z0QNZxxpP+wQNGGhlMGkauBI0wZB8ZTHf9HWX1vrHd/Xo1xqPCg7+fwTBOWy?=
 =?us-ascii?Q?2i2GpdIThMp8489oQgCe3nt7gAZC7vTvM1ru/N3gu00ex8CaNcWZVoxg+l67?=
 =?us-ascii?Q?3O/BFFilOwtvebRmNKiQBKy0WXy1tDhh1S/hknej+z4CecZnyRc2BsPtwOqn?=
 =?us-ascii?Q?P0lM/5EmAOEk8shbi4gsffxtjOIQrRsYkz3MYoQubIEC3TeHywq0guppp6Fj?=
 =?us-ascii?Q?ujU0zUypWx5wxeaDT1MRz54Xw90gc74+Yrd37F6YM4GNQ/lbanJrdduZy8bO?=
 =?us-ascii?Q?Ik6oguE/7vbTTjNZXMLQ0py6hq8hAoFYuy1lP4F79T3f7NJN3fSkz0ttoNNq?=
 =?us-ascii?Q?XTOM45ilGMXapcfXZ/VQXwnggx2ddJeAXK7yxvxcir5/XbwQqSwnKTbD0lCF?=
 =?us-ascii?Q?Wj5YtYOvhUdIgzZA9SmZ7TT4YbDQlEc44VJ57LsNkH5v2jghpYk/JkRFoBGw?=
 =?us-ascii?Q?EG3tmbgWtREXBbd6EcqV+cYJPnOmhglHKcNSW8rLtVgQQDYgcamUIdKvmqkA?=
 =?us-ascii?Q?myUetT1Ma3Z/YObWRARcwKoO6xukfd5Ixl7bHYoAHSjqJ3kmqIrHEBwXxX0H?=
 =?us-ascii?Q?tLhAeGJcIV1J7KC4f6efVmPCf/D3TgENODcQNK9wUhjgdrC925JL3XfcSwnG?=
 =?us-ascii?Q?ELNozi7PFL1fopICcHacfD6emSn//+Qp+Qesn0TjgmIkEq4uw+cicxQ44UcV?=
 =?us-ascii?Q?KT25QJji8paB4FbTsOp+q/V0QgjQR5bzJ7lDb6a8ifp/tXS7Fp59dF/quguC?=
 =?us-ascii?Q?qTZpwg3IlJbn7el8n/ZvOxukpnMe9XZ84NDd48zjUnEi6r9jSYNvrdB14+El?=
 =?us-ascii?Q?2w+Jd6kDEfet0rlutrMIs/rsZUGLz6oGoFzKFlJsaYIdtKLneiRO8ZgZjHjS?=
 =?us-ascii?Q?DTA6SS5IqW0MunmqrWna3+XCHK08c2CX/rZ0SnK5/7uf89YmXMlJ32c5D0DU?=
 =?us-ascii?Q?xBk1T9gemn3lgCBdKhNjPthlAk4T56AM/W0iJhdPpBK3AnXU+//FygaAgrw2?=
 =?us-ascii?Q?2WyIGN5Tz72CxAVGN6VLzhvOga+m4WfPsxe29vOCDNU2TLy9IuXCauo6SITh?=
 =?us-ascii?Q?xtX/8IRqADS3doOsI1UA2BWd0eHf3XPTtByOr5fmhFKVTCKx1cDtkDkbjtaO?=
 =?us-ascii?Q?znCXNQDes/i5ErlrD+FpSIVCu0haCyUhXSsNiJZuNJ5UO0MjARm5w/fWlL8j?=
 =?us-ascii?Q?K92W8rIbW+GqNR/cR1b/4dkA21V55ttLpFs/bkA2chelWNtmtSAZaAR3DmcO?=
 =?us-ascii?Q?1uxAaDUf+xsRe2EGahCNFQI43f4swPc8K1csxjYgFvFPWK8Pb4tWgiy7ecxS?=
 =?us-ascii?Q?Kz/bU5uZVJyqIc6mCgwWFaDjwIf1CbmpJPolFydYJ60NWxi1pV65dNaiAy6s?=
 =?us-ascii?Q?PFVZbPFZoA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d3s5ONrgVXa9Em0y6OJP1m75sL9Mzmy8k4A8qScrztvqA50OFl6qUszuuRjnVte6FQCXQjs1l4bNDMnf/DY9hnNOpHujJHaHswHsEcp9/UUYJnBwfpDdG5rwBl3ROaXw2DUfjGIWicz3NCmF+uxW9/v+jxoFgQshR0sOR+qk+EEhN3usjsjoio1qSASmstFgL37Vsxe30a1ND3IGtfaBUwJQsFbMpsVFw01jIc4aupHL2Qj+M4FqgVL0dSz3oAFlXx6r367MHoZTEtWeelhSezI02dDGDx5JML7LkSRB1ibyNsb7jkyh2BjuPwHgm7g1VFWjAogmMR2nvqnrm/Sdq87d0OI8PxQuv7+ezkL0D9awVZedpPPmRSwqD0i1bXscGF25lydyLJgu2JBd9wyR6nITNmPPxWI/V9JWd2dCpKNF9UZkD1KfHamPQRPvcWuGgT0MK8Qkaaw8DGFAtYP7pMD7DqkHbxqHcjLSBGnVuHvWoutN7A4L/VAIEzcS5PA5o7FSVj/Kxpfa77vB8/OMjmz/XmwTWCAHVSGksYgArTeDomuHJxPNN4N/G+Ff2OL1/03H+xaBhS72GdgwjJafoCRp+CKKd7P/QLFvheM5fGA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d84e03b3-90fc-4142-58de-08de627cc59e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 17:01:56.5851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xm79rcvO9IlaZhMv41hDi1Cr5OI675Fg91w0xzmg0gCIZ++Kr7j0OfVIosE7KNsUYGohcxzLT2rNVBGg1s/vsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFAA02B7A0B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602020134
X-Proofpoint-ORIG-GUID: _KeOQ4FIS0O1-7tux_WcR9ZP2CF1pog_
X-Authority-Analysis: v=2.4 cv=Sq6dKfO0 c=1 sm=1 tr=0 ts=6980d88b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2Fb9NNp6AAAA:20 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=60TsP1jbY119YIoaQVQA:9
 a=CjuIK1q_8ugA:10 a=bA3UWDv6hWIuX7UZL3qL:22 cc=ntf awl=host:12103
X-Proofpoint-GUID: _KeOQ4FIS0O1-7tux_WcR9ZP2CF1pog_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDEzNSBTYWx0ZWRfX6y8JAngaGS0S
 HgmF87OrPoe5STJU52LrHIJLoDzp3mIgBeTosk37XouAqAsfzGdeKxvmgSeE3U12Nqc/sI2c2Rn
 TipKyD1PfUygg3faZDT2nmsd+arbQBqmowuHVcZcUAOzEo4nJv7y+c5YtpItacJOEckk9fK28VC
 +4vF5/B1FVHpYx2EzEvv9JO3GN+oA75cHGgUWI7WQDd346ZmR92PjOF6vmW9nMP3RYVmgY0l9k/
 NuhuybGHYBpp4qRAcKZQ+B+Fcmxcgm93d7cPNvXGRGtTuT5ssepi1EnwpzCd1NjsL9S2HE6KzA8
 JmVFuQdqMrBE88+0AvjoqU09Obh9Q+hfwllTfduDj+7wnxERtDNC795up2jfD/SoQS/sCdORyXK
 RWXGZah972/98lHURaA92zB3nNGExTovjNt53ud9VEZhnZSnMwXlDXKk+7lqAE0W/0qtD1Noc3u
 MYWD3qHp+mRPD5pDQwzbOqknNtsWIAuleJUwKWNY=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5470A180019
X-Stat-Signature: mwynawf6rgrhq3qm1bbft9ryi66ehytr
X-HE-Tag: 1770051736-80648
X-HE-Meta: U2FsdGVkX18+ftZ4S/J0dV8tg9bzYeRxXWhq6hy4TPgnAx5Mgv0IPJKGxh5AKJVUIPM8HPQ9VgmPS2touaXkjbp2jRs5XM9/I85wHbJKu5EXSoYxhHiqxQE0p7GMSVw7JO3pEStqdy6mN+tbeNKX2+EH2MVkxu43K/28KAtl+Xf0soMvw+wPlRR+S2iRwXQgPbl2vdeogGJRZNRACLAVwq20yDbq8Q031o7OQpCgSpybTt5Z9errQH1Zxk32NjNt2CwHcb7K3qHCaSdBB67iAB07CgPFdDTJdSllusB49oe563NCSKrKNZeroWjZqd5iEJdsoAzmqItr4cU7p586u+zqSQyZ465j/Ru/MaT44HhkoPOZkBN5+LD8OTnkTf+9fQF5McCxPVxZOSTHCEY0fTYFptLpJEfhqqcYsZsf4nK0OtGENKOTTkjmBl7t6Pm6aqsLadpmTjaQJRFYR5t5LSoMBSKixvu+AfW0b8FMKJULuzOuPGRvC4o3VA/68c91HbR3+bZAxdnJqaLLBESxykO7qT8DnCXzqYminw3dLB4+S/z7yAKeTSWjzC3fkOVOhILdgCXF7ciqi9BwmlRNeXj95JTOTGmafvVDkyhTTeypYe5OffDZ66BXVwY4J3XdcAGCD1RQqDJWnFL2h32PYbZD8BA81TOEMqj9g3y0c3MNtqT6o/X5yv+hMC+QSt2IggBKV6d+jSc8RY8VqZOLjceqiUZPM3JC6w07R/vZBBOWvBWy/z2owHz7KXHO+HijylxMnDFWtiWDjt+pfUyvOKPJVLbZvFe2rfX2mZSlMJKDdfjq57see8ARbmQAzTdllSHQumjsu83IVcGA0do/yd9egacOOP2owiZz0i18FK2TiqkhLcP/pK7ut3ZToTJPiZlvUdNHz8FThZ8wQECjitxavAsry6eEUuvmA/h6zoCySDixGHFS82uXD5vlZ8sD9ZqagmlBsrAyVSSoZJC
 FKAuBCAZ
 uvu+MuL/CR8RkcAARKmn1RKPtFMIIqJtnphCSazp4dvSNYja+RsBieFe23vT38TxJbv1HB6N549ASLc9rAbCJPU+NJvmo1c8Cm6hU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* SeongJae Park <sj@kernel.org> [260202 10:56]:
> On Mon, 2 Feb 2026 09:58:31 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > * SeongJae Park <sj@kernel.org> [260131 19:10]:
> > > Hello,
> > > 
> > > On Fri, 30 Jan 2026 15:59:26 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> > > 
> > > > Add a helper to do what is needed when the maple copy node contains a
> > > > new root node.  This is useful for future commits and is
> > > > self-documenting code.
> > > > 
> > > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > > ---
> > > >  lib/maple_tree.c | 70 ++++++++++++++++++++++++++----------------------
> > > >  1 file changed, 38 insertions(+), 32 deletions(-)
> > > > 
> > > > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > > > index 5280fa6d2d6ec..42038e42a4c7e 100644
> > > > --- a/lib/maple_tree.c
> > > > +++ b/lib/maple_tree.c
> > > > @@ -3337,6 +3337,43 @@ static void mas_spanning_rebalance(struct ma_state *mas,
> > > >  	mas_spanning_rebalance_loop(mas, mast, count);
> > > >  }
> > > >  
> > > > +static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
> > > > +{
> > > > +	if (cp->min || cp->max != ULONG_MAX)
> > > > +		return false;
> > > > +
> > > > +	if (cp->d_count != 1) {
> > > > +		enum maple_type mt = maple_arange_64;
> > > > +
> > > > +		if (!mt_is_alloc(mas->tree))
> > > > +			mt = maple_range_64;
> > > > +
> > > > +		cp->data = cp->d_count;
> > > > +		cp->s_count = 0;
> > > > +		dst_setup(cp, mas, mt);
> > > > +		init_cp_src(cp);
> > > > +		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
> > > > +			  cp->dst[0].node, 0, mt);
> > > > +		node_finalise(cp->dst[0].node, mt, cp->end + 1);
> > > > +		/*
> > > > +		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
> > > > +		 * documentation.  Since this is a new root, there are no
> > > > +		 * read-side operations that can view it until it is insert into
> > > > +		 * the tree after an rcu_assign_pointer() call.
> > > > +		 */
> > > > +		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
> > > 
> > > I just found the above makes my build test using an old version compiler fails.
> > > Fortunately, seems it is same to the one we discussed before [1], and same
> > > mitigation like below attached patch works, at least for my test setup.
> > 
> > Thanks SJ.
> 
> My pleasure :)
> 
> > 
> > This is still with gcc 8.1.0?
> 
> Yes.  The test code is available at GitHub [1].
> 
> Nonetheless, another test [2] that is using 9.3.0 was also failing.

You have two failures: one in 8.1 and one in 9.3?

I was planning to test 7.5.0 and ensure everything works, but this
implies my plan will not catch everything?

> 
> 
> [1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_m68k.sh
> [2] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_arm64.sh
> 
> 
> Thanks,
> SJ
> 
> [...]

