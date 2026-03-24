Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875F2FEC0E0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 17:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8308B6B0005; Tue, 24 Mar 2026 13:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0FC6B0089; Tue, 24 Mar 2026 13:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE3B6B008A; Tue, 24 Mar 2026 13:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57B986B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:15:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0BD41A0365
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:15:12 +0000 (UTC)
X-FDA: 84581607264.08.39D9AAD
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010006.outbound.protection.outlook.com [52.101.193.6])
	by imf19.hostedemail.com (Postfix) with ESMTP id 326A71A001B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:15:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZISLJKxv;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774372510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cibplpRPItnb2wDztT9aerHlzWYBD6IZ62GnTIho75U=;
	b=8FWRdB+wfdGgAoy0dtHp5aaCwUvqM13VHZU3XqHSH+evgt+Ps199CJVv0nWSDMBD+AiQpm
	BZCxSv92HPIha1QnjKHVjwAWnOt2vnkOxDw2CRWQRAAcU98iBWS6pC58T8kVTsfG36xk5G
	DA5CeH3qQPgwvflkqE6iabIFWoBkTlI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZISLJKxv;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774372510; a=rsa-sha256;
	cv=pass;
	b=Z9J57JMK4MQVvfChNsYs5JIMryugw8SnQyo9OWvxsT5WEIhZUvMI8xaYvqeXgUjAOGmda/
	IHh46UIf61GJGPokjUY5RimvX8+kS3rSOHZ8AEduGgAwcbRIhE2u3rXdDNqh1Idc9zXEq/
	r9X18FKJhIkLwRXjhiZoUunS3aoKUhU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tcPqp+NKFKZJBimxYEIXeuSFB1I7boZy46MlHwmnZ5HFmbYxypuNqHSu9qBBns+ugRy1S2v3Ho8ePcqhl+YWEzB9p+yk7IhmeRI9xzULRMa2RxjeN62+ilNkeLYMbwsUYPNmr6vP5mALM/yxS08QZBXELgC7GyGaQllr9n+1LDW6SZION/HN59dFh/j3Q/H5apxdwEYCu3lrgXUrMizTGVAWtSBP2C712boBdPLx29kBHIboKr/W06FSbSStFpmSPeSkG7YlHInmKaCPhSA/39B0mOsihGmfq57WkpRXGzBY6ODcgF+1VtSKULJgk3uu/5txBoUxCG93gE8vNg1B8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cibplpRPItnb2wDztT9aerHlzWYBD6IZ62GnTIho75U=;
 b=fQeohZ64XCN8STMYnV8uOSLzQxLItIu4hiMfLvnems7u6lPx1LHMQ0fF3gWFVD53ekbvrBOi28MQYjf1ZxSwLzikx/Fa/6ylcIqua1g2YuDSo0YtLlJc/6kYWlv+tTP57jsW9WYF9jK3LcdyZgBbS4mTqEWaGgVTTl9i7V1uAl2o9xZsvCDYQkx4WOQUJTUZjv0IXN/25Rd8qqH6h5RntiHr2zArTGDDpcIATGWG7uSGekFvNs986PrAuuWOuw0iUXQqHrn1jetJDlC0p5P7E9FNnFKhqGJDvpaUBxT1QOuxmVD5t0lJkjmLDLqrJ+u/phiQznRkmOznLHwB1SPeEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cibplpRPItnb2wDztT9aerHlzWYBD6IZ62GnTIho75U=;
 b=ZISLJKxvk7DnGj56hC1j4He9FYTOH2IVLLry6mQ0bTvzohcuqg+MYuY3S15thyEKjzDoRo4m9bne/I3VtOrJb6OCtaD+RCVBdKrDonK5mkL+TnP9H0ld4A/WaAXboeeFCT4pNug1CLJBG9dzwUYH8iBGG7o/ChoZCIb/QmVJcn/YSeHhlRzPa0fO1+FfwAfbEQRjh2BAGL8fwUT54K2bj8/xl1LDE2HW5CeuA1uCeh6X6qoJAvBNwOxHPJ9rHc0UVUXt49F7Z7nZSbP+XsgdOnvowSOKcSOH33/iISzHfznNvVS17icvHcJZu8RFI8dw0EquBE+os3qJavNSBYZN5g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYXPR12MB9441.namprd12.prod.outlook.com (2603:10b6:930:dc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Tue, 24 Mar 2026 17:15:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Tue, 24 Mar 2026
 17:15:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david.hildenbrand@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com
Subject: Re: [PATCH v3 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Tue, 24 Mar 2026 13:14:58 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <42C0A333-EB71-42A5-83A2-36831E1F5E50@nvidia.com>
In-Reply-To: <88ff0f5b-e6d2-400f-9316-4863a5d169ea@arm.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-2-usama.anjum@arm.com>
 <E976076E-68B6-4088-BA67-AF4ACC0D3E7E@nvidia.com>
 <88ff0f5b-e6d2-400f-9316-4863a5d169ea@arm.com>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYXPR12MB9441:EE_
X-MS-Office365-Filtering-Correlation-Id: da75cb53-f273-417a-6d2f-08de89c8e3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AF83+hlBkHrkKUq7ed0WmbLLiucSuwTMagcMSJ1xNb7Y1OIA+uoifOxiPp6NroeI/BhqZsahEl5LtANXgSHEqnaSJQFNKC4OX3jZq05g8C20vlnzriQTudi4Dla9PEr0BY9c6lvRRKoMbIfNW6T38hq4fco+I+aqkVXddUENpRXfk3aIWBVeRBV2OOf9VOpJjZYu/jd14doHRzni6+ZL5f+IU19dq8Ukp2xSbPpjnmB6yLucJg4ySOu7i2UIlPXCCmhyQeklpZjUzpRauPA1hj9Zd2tbBuNGvQm4LAId69GJ/DZBCESKrwNceHzlDGeum7V04UIapfhI9XuQmIbQWBntmMY51KsccKLLfKm3DX/p2cCFza+vUCBhQ45X+Jc1TkEWqvolk2pxY2fLfSs04JHc+ytMO6ZOVgpxrR01sWAsyM3Vt55U0EMdKxelCGW0LFcIqDw+A2TgJK+fdsbKFOzgu8XS9jkOgEnMcnkWyVJoW365ah2HrlTlzgaEABy0rrYhfj7PcjJdG/49XjsZEvfp8p7jTVPfBUsY/pCKnY3LoN+uEljWHNQHJxyXRJlY55EZImz/ykjXlD+edg4a2uejnFABthU9VhXTqr9TmJSBCH6L8fFMNLtps6qHo/5rzLl0z5DeSLavctihCjcVjUss/sJHZ4363ct3SCQ9Bu0SuXfC6yyQbZS66o+ilyCFrdpYuf8Hc2phLevhKxGxfcw15kBm8A8QBiejYbTjTIE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xxxsULk47wsnlW74h4cmRkyQHHZkzoIo9D8CghmTF8yiIslGbRXIOli2h9kn?=
 =?us-ascii?Q?N70NHSNHYJzy4STmxtzhrhH/bsZK14L6Mf1aQpPDW7F67Rd32puf6d9NafTe?=
 =?us-ascii?Q?Zcl8PxN7AsVftrpz9myLgHV4B/2iKNmjagcdunG42XV778LsIEcQNaMWrPSp?=
 =?us-ascii?Q?klAafzinIH9MRHb/WSGJa9HYr/PbTTa/zeU31ur3maus6iw4NvganC9Iz3OS?=
 =?us-ascii?Q?7tp1EHfNyoaukzLnk/E60xEvasZcC8hSy5EdcIlEvelKBRVJtvw7WSZ1mlxJ?=
 =?us-ascii?Q?tYGm4TtrJdIme+Lqgoy1MZFalILmBaZUsHekynz/UNRMdm9+nbSMDFQhljsO?=
 =?us-ascii?Q?9GGxzpWIfOIKt5fBDtqXOcwxLsPGkeRBtSUHBsWpT0q/UelMYBWu5jf5yPoS?=
 =?us-ascii?Q?ctdBHKqLRlMIB5/23x0058rahSwgjplrz4eMLiDEmA2q1EJ5+Csz8ARz9ERZ?=
 =?us-ascii?Q?oxD3tEIRcOm/Pt7wcWwA/rKSxm4Ve4LkBUAJvyR95XJ5pnLRe9bCAg/rWTNZ?=
 =?us-ascii?Q?wVNyzrtYZYrBIqV7vXdp+LxWFBAdoiNP/GsJZSkN2TOGUtaRQfalb9YpMEPU?=
 =?us-ascii?Q?JOh3HHD3lqe3hbku6FUNcAbQa6Hvq0bCqGX9KvID02J7+/hqcVTpEZEGosKr?=
 =?us-ascii?Q?MAq8+EEImmQo50dyyQlRWQZ1Za9J8oAWABM2xtx9C+35XJCceEvuIcWNHMCD?=
 =?us-ascii?Q?w7gna9nvJ707kBIEUgc4emMJf5VCQjI7HPQVRnw+6O7cd/95g2DLZDnw0FlT?=
 =?us-ascii?Q?ydpbSkokOdTFuSSkkwiuYFcwcJHVcvGnHW32idt2q7klY8uiReJOMZnwVrOo?=
 =?us-ascii?Q?lPinaW9KdXsXLV8Y5mFE5tybYkH6jikEozJUu70jGBNyqCv3fKFoAcTYJFVu?=
 =?us-ascii?Q?ATTxmbIRDa6pKn+pEJyLymuaDcZst/txzIgoWl7U5cl5EURDkTuDFmppaAUJ?=
 =?us-ascii?Q?wrjfTUsq9YySUdM0pN7YIGgBLaoX1UawUy44QSZ/huEz/NiWcgqDrbrSu0eE?=
 =?us-ascii?Q?RgKy3QErf/MbuiixjoIp4HY/o3EaqckYO+2A0a1FpPGQwGykJ1tj5TrhG6JR?=
 =?us-ascii?Q?YSJeeOHej7DhG/LIfJnrIglqwksa2SgmBsmvEwbZyH+2efM/9jZtYo3oUzSh?=
 =?us-ascii?Q?f0xsuIOobeOBmlo88x/Xj5h4CS6BqSfrQRVcJwbCZYc5J99cwxZVaMbDj9gF?=
 =?us-ascii?Q?tS/gHP1+TyLJVkP275V9eCMvXV1ZtDnCsljm0rGcWJacbTWMqMBLL/IN77qW?=
 =?us-ascii?Q?To/XDAcwi/ZPFWPcRy0bojbPj2xpGd42ffPGFkUoGtblEzcEDpQsRBMZjAHV?=
 =?us-ascii?Q?zfcNvleHnaTtfCPzrxiQFYNkNQiu9Y8QTzi5l2bRRPluBcwEEWqJO9tf9uww?=
 =?us-ascii?Q?sw369wSZKTBdBvH1PducQPsAUMHmkqwIXk4CznRi6LWIPA1sedlFjuM0QAcN?=
 =?us-ascii?Q?yTaK3wGv5XzHLdREL67U7nihvQwTAKQvKjfRKXNiCTk7HqbsMO+574xYDdN6?=
 =?us-ascii?Q?bHCK0QepJubwGwULk8eYn5q0Ziuxu4CVjnFW8hi7q9ZZrOR9fcPs9AomR6Sw?=
 =?us-ascii?Q?kHkp9V6RSbvelhGRRTH7ExKKy1AU27jv5VVrT6DABMJt/d31rQSYCa1ZRbRx?=
 =?us-ascii?Q?yHcZH8hjdInCoLKs2zW0q4QEzVVxKW8xmPUGCkYKNI0hdh9yLz/Pe+cUTFCf?=
 =?us-ascii?Q?fIo5dNieaQT7xHgx0hWq2nfNIhsj49azSnC+MjRPN8vIv4th8Sgua5fOYs/q?=
 =?us-ascii?Q?Q8WwLipLcw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da75cb53-f273-417a-6d2f-08de89c8e3e9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 17:15:04.5014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CIzjQLdkNaZUfzDTlznTPwEfxhLHJWr73DV74/TiZ2VcEGEU9qkqvZHedhF6/5fh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9441
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 326A71A001B
X-Stat-Signature: k8b1xj7imn4whrahctkm7omkitjj6yo4
X-Rspam-User: 
X-HE-Tag: 1774372508-168270
X-HE-Meta: U2FsdGVkX1+13MCN5n7J6P+WXnjgxnRekSf8mqBV8u9N+Y1ZWkuFTQn9OYLsKETZEsiW4AMKJwnIKFq+dMA1TsSIe+ZG2yclXhIuPKpvEyXHVleR5ajCkZfTXsUY4wJs3tNVTFMw4l+rhY3W6Os/lxXwqvQiVAnTWj/OZrgVzyUicJKbpPE/bKKjncyK7QLgpeqQPDJ1YmykHsPn98nHIsv3ertcoHkkdPGwTj1eq0SBTeIYiH83Vm8G/GMcT5QIEO3uWrDXGiFG5axgten+Xmql4Nbq5n6DqoyKfN2njxcrUVeFgsHnWHk0u9jO/0SiVF2RDmLiI0not21vEW9oKtCz3k3Yq6bhNOnVil+2N+IDoBfTF+1yPurVkswZ1NkCOUXLwE6C4p4HAgUBW/vEywpxyuSkNghhZXVdnnSPIJ8HA/H3njZEPW0SXx2qqSGP6qLxneof3BQKQ4QOpnYVWJtAu81z+Ew1KTvVKErfM6WvLAgso1z4V4SGMphCJCG/w5WDQVsoqroxFxE4jsg9m0+RpAyt6qBq4AEDAUxbvkk/t4ygyKpNKe5yZQvi/4lw4mfhj+1mh7qsxBCi51IoMYh3B+GWHNSCxMY9SbD+Lev+Yhz0ni5A/VKF70RZzzhEL4HBCDA9tfp8jnx4JHKXjIcAC4v4EPtcHa8ymanoYrbrP9Ci18+vr23op9LoVvpoPg8q+y6X9Tnn0OEKdOJeKUiLmBpROWkomylgLXY8GAVWPKQsAuohjCKZSQT21PziLFLlZ12yntJbjuE+MLgPND0rr031R8fIvj96H71Lu13ZJuKhi4WaiKaxBcRQnxE3Fmt5HWeq/CW0kJIhQRkWX/umLwcXWvD9cXPcZRcg94lnYSqPkLroVIwU3jxYN0yA33MdFwulLdwYmSi6LJcsnxSD2xGYmDbo75wvDiDhTTg+e2bYdMXHMBas3cQUsoC9s/0J0dnzojAERXLtD/O
 RiYec/Ux
 ZEZSEL6sjncUYBAad35DS5xDWyCvTbZ0irpsQS661IC2Ehackg1Zlv3PMCdy1nnfCYDcJ0i/59kjjJhyOn22q8AioeSlxpLyPKrLi7kPq86iGr/+3cTRZnyj81jkGJ4JeDLHY7f6fOzS0dKg4za87v61qqfkEnlPA5x2fM8iqzp/hUGbkpIoxHdj/0cRjG5Az8P29PEZ7J1yuAIKZQDI8yRqbbUcLNfWBsxlgSgp0YY0pR6QQ960NvcqBkHdoTbQrB+PYPZz8SvYpgSCT6CUieN26maxQWOxzDIH64HOkNm03osUsL/gb+klwvTWUXVDYPpQoTQcSqohI8mkx77r01I9K2My9u8Nc53KwRCSR/l+tGZnAGAr7KRvqGqUvKCuLpOLG/YQ8wIkj0fc6BCSCCPg+sQT2cG1xUj0RNH4GkQzvDZMYb5ffI2CkvZMQIEpVf5beV66tB2zaZAfuaWgKZMsW1LWSZU0hhip9ZNCaTG47X09pjVe+c7qWMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Mar 2026, at 11:22, David Hildenbrand wrote:

> On 3/24/26 15:46, Zi Yan wrote:
>> On 24 Mar 2026, at 9:35, Muhammad Usama Anjum wrote:
>>
>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>
>>> Decompose the range of order-0 pages to be freed into the set of largest
>>> possible power-of-2 size and aligned chunks and free them to the pcp or
>>> buddy. This improves on the previous approach which freed each order-0
>>> page individually in a loop. Testing shows performance to be improved by
>>> more than 10x in some cases.
>>>
>>> Since each page is order-0, we must decrement each page's reference
>>> count individually and only consider the page for freeing as part of a
>>> high order chunk if the reference count goes to zero. Additionally
>>> free_pages_prepare() must be called for each individual order-0 page
>>> too, so that the struct page state and global accounting state can be
>>> appropriately managed. But once this is done, the resulting high order
>>> chunks can be freed as a unit to the pcp or buddy.
>>>
>>> This significantly speeds up the free operation but also has the side
>>> benefit that high order blocks are added to the pcp instead of each page
>>> ending up on the pcp order-0 list; memory remains more readily available
>>> in high orders.
>>>
>>> vmalloc will shortly become a user of this new optimized
>>> free_contig_range() since it aggressively allocates high order
>>> non-compound pages, but then calls split_page() to end up with
>>> contiguous order-0 pages. These can now be freed much more efficiently.
>>>
>>> The execution time of the following function was measured in a server
>>> class arm64 machine:
>>>
>>> static int page_alloc_high_order_test(void)
>>> {
>>> 	unsigned int order = HPAGE_PMD_ORDER;
>>> 	struct page *page;
>>> 	int i;
>>>
>>> 	for (i = 0; i < 100000; i++) {
>>> 		page = alloc_pages(GFP_KERNEL, order);
>>> 		if (!page)
>>> 			return -1;
>>> 		split_page(page, order);
>>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>>> 	}
>>>
>>> 	return 0;
>>> }
>>>
>>> Execution time before: 4097358 usec
>>> Execution time after:   729831 usec
>>>
>>> Perf trace before:
>>>
>>>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>>>             |
>>>             ---kthread
>>>                0xffffb33c12a26af8
>>>                |
>>>                |--98.13%--0xffffb33c12a26060
>>>                |          |
>>>                |          |--97.37%--free_contig_range
>>>                |          |          |
>>>                |          |          |--94.93%--___free_pages
>>>                |          |          |          |
>>>                |          |          |          |--55.42%--__free_frozen_pages
>>>                |          |          |          |          |
>>>                |          |          |          |           --43.20%--free_frozen_page_commit
>>>                |          |          |          |                     |
>>>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>>>                |          |          |          |
>>>                |          |          |          |--11.53%--_raw_spin_trylock
>>>                |          |          |          |
>>>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>>>                |          |          |          |
>>>                |          |          |          |--5.64%--_raw_spin_unlock
>>>                |          |          |          |
>>>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>>>                |          |          |          |
>>>                |          |          |           --1.07%--free_frozen_page_commit
>>>                |          |          |
>>>                |          |           --1.54%--__free_frozen_pages
>>>                |          |
>>>                |           --0.77%--___free_pages
>>>                |
>>>                 --0.98%--0xffffb33c12a26078
>>>                           alloc_pages_noprof
>>>
>>> Perf trace after:
>>>
>>>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>>>             |
>>>             |--5.52%--__free_contig_range
>>>             |          |
>>>             |          |--5.00%--free_prepared_contig_range
>>>             |          |          |
>>>             |          |          |--1.43%--__free_frozen_pages
>>>             |          |          |          |
>>>             |          |          |           --0.51%--free_frozen_page_commit
>>>             |          |          |
>>>             |          |          |--1.08%--_raw_spin_trylock
>>>             |          |          |
>>>             |          |           --0.89%--_raw_spin_unlock
>>>             |          |
>>>             |           --0.52%--free_pages_prepare
>>>             |
>>>              --2.90%--ret_from_fork
>>>                        kthread
>>>                        0xffffae1c12abeaf8
>>>                        0xffffae1c12abe7a0
>>>                        |
>>>                         --2.69%--vfree
>>>                                   __free_contig_range
>>>
>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>> Changes since v2:
>>> - Handle different possible section boundries in __free_contig_range()
>>> - Drop the TODO
>>> - Remove return value from __free_contig_range()
>>> - Remove non-functional change from __free_pages_ok()
>>>
>>> Changes since v1:
>>> - Rebase on mm-new
>>> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>>>   fpi_flags are already being passed.
>>> - Add todo (Zi Yan)
>>> - Rerun benchmarks
>>> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
>>> - Rework order calculation in free_prepared_contig_range() and use
>>>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>>>   be up to internal __free_frozen_pages() how it frees them
>>>
>>> Made-with: Cursor
>>> ---
>>>  include/linux/gfp.h |  2 +
>>>  mm/page_alloc.c     | 97 ++++++++++++++++++++++++++++++++++++++++++++-
>>>  2 files changed, 97 insertions(+), 2 deletions(-)
>>>
>>
>> <snip>
>>
>>> +
>>> +/**
>>> + * __free_contig_range - Free contiguous range of order-0 pages.
>>> + * @pfn: Page frame number of the first page in the range.
>>> + * @nr_pages: Number of pages to free.
>>> + *
>>> + * For each order-0 struct page in the physically contiguous range, put a
>>> + * reference. Free any page who's reference count falls to zero. The
>>> + * implementation is functionally equivalent to, but significantly faster than
>>> + * calling __free_page() for each struct page in a loop.
>>> + *
>>> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
>>> + * order-0 with split_page() is an example of appropriate contiguous pages that
>>> + * can be freed with this API.
>>> + *
>>> + * Context: May be called in interrupt context or while holding a normal
>>> + * spinlock, but not in NMI context or while holding a raw spinlock.
>>> + */
>>> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>>> +{
>>> +	struct page *page = pfn_to_page(pfn);
>>> +	struct page *start = NULL;
>>> +	unsigned long start_sec;
>>> +	unsigned long i;
>>> +	bool can_free;
>>> +
>>> +	/*
>>> +	 * Chunk the range into contiguous runs of pages for which the refcount
>>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>>> +	 * free_pages_prepare() fails we consider the page to have been freed;
>>> +	 * deliberately leak it.
>>> +	 *
>>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
>>> +	 * vice versa. Break batches at section boundaries since pages from
>>> +	 * different sections must not be coalesced into a single high-order
>>> +	 * block.
>>> +	 */
>>> +	for (i = 0; i < nr_pages; i++, page++) {
>>> +		VM_WARN_ON_ONCE(PageHead(page));
>>> +		VM_WARN_ON_ONCE(PageTail(page));
>>> +
>>> +		can_free = put_page_testzero(page);
>>> +		if (can_free && !free_pages_prepare(page, 0))
>>> +			can_free = false;
>>> +
>>> +		if (can_free && start &&
>>> +		    memdesc_section(page->flags) != start_sec) {
>>> +			free_prepared_contig_range(start, page - start);
>>> +			start = page;
>>> +			start_sec = memdesc_section(page->flags);
>>> +		} else if (!can_free && start) {
>>> +			free_prepared_contig_range(start, page - start);
>>> +			start = NULL;
>>> +		} else if (can_free && !start) {
>>> +			start = page;
>>> +			start_sec = memdesc_section(page->flags);
>>> +		}
>>> +	}
>>
>> It can be simplified to:
>>
>>         for (i = 0; i < nr_pages; i++, page++) {
>>                 VM_WARN_ON_ONCE(PageHead(page));
>>                 VM_WARN_ON_ONCE(PageTail(page));
>>
>>                 can_free = put_page_testzero(page) && free_pages_prepare(page, 0);
>>
>>                 if (!can_free) {
>>                         if (start) {
>>                                 free_prepared_contig_range(start, page - start);
>>                                 start = NULL;
>>                         }
>>                         continue;
>>                 }
>>
>>                 if (start && memdesc_section(page->flags) != start_sec) {
>>                         free_prepared_contig_range(start, page - start);
>>                         start = page;
>>                         start_sec = memdesc_section(page->flags);
>>                 } else if (!start) {
>>                         start = page;
>>                         start_sec = memdesc_section(page->flags);
>>                 }
>>         }
>>
>> BTW, memdesc_section() returns 0 for !SECTION_IN_PAGE_FLAGS.
>> Is pfn_to_section_nr() more robust?
>
> That's the whole trick: it's optimized out in that case. Linus proposed
> that for num_pages_contiguous().
>
> The cover letter should likely refer to num_pages_contiguous() :)

Oh, I needed to refresh my memory on SPARSEMEM to remember
!SECTION_IN_PAGE_FLAGS is for SPARSE_VMEMMAP and the contiguous PFNs vs
contiguous struct page thing.

Now memdesc_section() makes sense to me. Thanks.


Best Regards,
Yan, Zi

