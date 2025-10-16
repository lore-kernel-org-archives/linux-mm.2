Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9AE6CCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA09B8E009C; Wed, 15 Oct 2025 21:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51778E0008; Wed, 15 Oct 2025 21:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18BD8E009C; Wed, 15 Oct 2025 21:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A08208E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:28:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 377D9B616E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:28:52 +0000 (UTC)
X-FDA: 84002243304.27.236152D
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013046.outbound.protection.outlook.com [40.93.201.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5BA3A4000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:28:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nkG2M+qd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760578129; a=rsa-sha256;
	cv=pass;
	b=s2mrr/JJCNVmV9Rd8FsrFxRVBfUeBbeK/N7IJTBAa1gZ4bw2Usj0SLgKNTCLAhxB0qh0Be
	MNuCwKCoYrxjpgwzQxW9z9DtQZsedtiUCeYLxVrU94qxM3djyPBJTBi2Iqt9EJWyP6p/Jj
	5Di0L1zfPfsxfgth2Mh5UMlgcWI5sDs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nkG2M+qd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760578129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEK4XYHXRrwlsVZiUSgxw+RU+uQD75j+3H5fuvCb70M=;
	b=JBYIwuRrGfti/htMMgdGB4DlbWf2sNTc4TCEX1BwBIYa97yNfk/JpKIusJNLIoiP2dYNQV
	i6ULFCaC/ZMnfJIWax4yiQadPmG73U+nhBaBC5ENSz0p2NqhTn6vPuUby2uI+Ajs/SKts1
	v3q4FOkazFTU/zAMwX6aXQGyMN+jsw0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKlkbOWx3ONWG42PgF9V0QvSg756S0E+i4gDosi8zd65ArCh+7n/e70Ay8R8rXfwqoEn3Z2am0v2B4cE2obtgieYfjLojOcZBuMi1cxefyxRv9H94sJ9coDcWQG4XFeqrwhCC16vy7pIV+kcFnim25CccWObs6z0SnkJhG+JCQkaA6NYSUEnKTbIwKwGkH6qCPHKBal+Uxy4AmQvKMjzbPLVGFJlszteQu+NTB6J0Ujtjbb4QzgR17IMGyZCvkGtUeHtYw4BNN1TfIAHunKjnp4EZyp2qri6oyS7+1h+mAPnYtRjqIaCy54APDTZeByfdM2EdwJtwrArd5BCuwDjKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEK4XYHXRrwlsVZiUSgxw+RU+uQD75j+3H5fuvCb70M=;
 b=srAB1FtV2r2trfb88GDBUpfGfEExrdmM8M1wXG9BmyppFFk4nAeuWczYCejgDoUDwSpWtvb5xjTl56/6Ys9+ca3hMDaKH2Ta19s7EpH7Ztz43/Nr+jQSooEKdYndvGDr4bRPFUkSUGBdmYzBBM4/hwqjW3Z/jBeNvZibs9WzVGc+Qea9p+2wgb7wsZtgwQO1vwC69CEFU+95toiZyQV9dX1tPKB2izRjVwkyDyCaALLpelSmm6hiBDCOUdidV4YCTWIGQx46/CzQqBLUNyi0e2TOjv7TnlP4L8vh4iiUX8NZXZBCIKKWHz9Gky2nsf6EHCdI86HxFk7+uKJZYg/y0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEK4XYHXRrwlsVZiUSgxw+RU+uQD75j+3H5fuvCb70M=;
 b=nkG2M+qde/818a1G2vVUR5nLSuReqePzCmEsfxPXG7//4bTXHGcsDwznuAFm6+9ATEod+73Ba18VcAwUzxOrfcDqKXq5zX2V1UeSOk+dCjqzCvF7QSBAnCFsqkt4xJ/ZvvS63Ieoi6jAuhQbib+RhuR8Od30s9Px3EYq+1vfOYiyc1dVHsYmIftcTjjoOouNE3c9GOsdTpiEneTRDWTmmtSd3mPDP8u9qrUnbrjRmErE649wag8/j1e8RfHlSMOs9u3WXNvmEvVn9QIMWnmMUsaNaWk1CGrMFdueU+MiLzvz70vWWlhyEiWwaMbpyV65bAfIGR3UNgAhZsSgQIPYvw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6354.namprd12.prod.outlook.com (2603:10b6:208:3e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.9; Thu, 16 Oct
 2025 01:28:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Thu, 16 Oct 2025
 01:28:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
Date: Wed, 15 Oct 2025 21:28:41 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <DAF946DE-0D7A-4B15-BF28-BF6464ADFD2F@nvidia.com>
In-Reply-To: <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6354:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4c6092-b654-43ec-333a-08de0c5357f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?32FqccCMRKJxCRJZF/YoWG/aJQRKgNijS7UWQidJUhgv6HFIMyi0UIhAnr7l?=
 =?us-ascii?Q?gs+gTJlqqCig6UolGuf3Jr2nYtBRumV7x3GY9V7zFaU/XV8VbiyCY7kTM7kI?=
 =?us-ascii?Q?FsqyRx6deT3UidS2Kb2f2FfRrxVnYHyYD7wt8Kvk5Q77wRYnnO8SAVs9ZTHY?=
 =?us-ascii?Q?FmVfdz5oc06l8Hmz3EaKVxIixHe4moKFp3S+7eCeRaV7j4Ts1XwtY1vkb8pk?=
 =?us-ascii?Q?ZMN2XO301ZgFZx46WbaU6v1+nbGGEgl+joS3hQBOe8wzp+5HeJQuYI3HYGVU?=
 =?us-ascii?Q?tl7pu8bXjk2nZuZ9QOlRNbVUChXrqk3Q/JWQ+vzGtL7hjBA9BcdgkFncxn6H?=
 =?us-ascii?Q?Z6hUxQwKvYWl7cDVwKFewmSXROT6W0RXDSDPo+Y9IenfJRhkKfMZh0+WlELE?=
 =?us-ascii?Q?vJf3bIgdXvHlGccBM6WXp5LuCrw3G83LosMA2OV9eQKAsL21v0OT2STOfGuE?=
 =?us-ascii?Q?FKcTPYPFuw+90QbJoa6cXZaYURo8r+MEwSzuTNjBAidbOFPn55UcX9wYXkMW?=
 =?us-ascii?Q?icbIMjn2U1RXZ0U0TXCeDcZPXVGZa7IkW9g8xd8oQPtC6vlXIObnWdpgoXB6?=
 =?us-ascii?Q?7Gjxw5EjKEjVeod6e40Nl6b6pBtwh1V0L3wuKPicVnoOMsjG3u3Iw/H+lRyh?=
 =?us-ascii?Q?ulBPeq2xLEgbQk8ql/ROcuT0n/827RCXBmlcpzNMEfI4Vi/JRxituGFL0idB?=
 =?us-ascii?Q?3hAcvET9i4jFVOuG669fvVuTt5uH5aCjFh8lVlhPVrm3dbmERDqwqoD8Nxnc?=
 =?us-ascii?Q?Mg4xs1tB/nkAXxkdNFdE0Ruax9Vk3Un/0L60vqhf/f+f7Vz/uu5fCkpnqqxl?=
 =?us-ascii?Q?Jrni0xZs02y/rL3E+KepFRZk9+zJTeaJV6G+YobrtCl4KlV+dxAKFTR7TEoh?=
 =?us-ascii?Q?OLIxyrVPRZjiynDhTOottrhwidW3rTvrryzoAUbiOnBOcBifSEQZBz0hcy5S?=
 =?us-ascii?Q?z3yDvUcGaA0rXkXhWovC0J0g8bO5fUEZS41lAP1nTrYr7rQfxikJ7ANilv8V?=
 =?us-ascii?Q?N+S53T5q9ijJ/DBODUletMcGrIHayx81Xql+yr3kAPAAwuu+vCf6zPGnLJRL?=
 =?us-ascii?Q?Q6pG3zX6v5s5oAE7eI6sYkEV61aastJ87v0pm1RNuEQq0nvKMEsj5LW8kpvc?=
 =?us-ascii?Q?F+BCQ/11oljT/9ztMa7VOCzUu2lawVxk1ci/XEjAn8yf5D19nAAWFXnf/S6h?=
 =?us-ascii?Q?mlEUix/pgJVEHw8FS48Jp0vESGVFaGZvrqpX7v1AFUWGPLjZ2U8SfE+F6sav?=
 =?us-ascii?Q?7IJ/5BEzOVHKEQ7jegjESBR5JZbswz5ESdf9g4enZzhyO7H0UGjRzV7sUBIg?=
 =?us-ascii?Q?tc7+eW9AGDTW2xpfYhDtLJ90t2OhpOy3Gtv5bAdyrq/SbC+KWQJteq6ZZnhD?=
 =?us-ascii?Q?msO7S0RYD2PPc2gUglO3ZrH5KIVQNIBEz/ZYcrZaPMFIKlYTnVhJY9/QbQld?=
 =?us-ascii?Q?M+xbBxMAzeE3kMoxdjpk6cTK+sHj98XC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3F/Y2+6Dmm6lL30Fwm2gX2PLBbnusxcl80f4UEdg8VvZPk2PROHZAOD6EUBg?=
 =?us-ascii?Q?aXe86mJ7c/RspurCFw9WfjQw2GpW0pK4M2AweuSVOad+yoUwA126UKVgOE2c?=
 =?us-ascii?Q?3cTuhALGxK5zgD5/zNlN9BcA7qu0KFQoUyK700ikSLTEUL6Oz8GQcc0KkrEg?=
 =?us-ascii?Q?PmlKhnq/guW4W7SwMFqSx1VgFY4kAcQkBdmfWw5SS4tZtVihQbSAvRBKXjWe?=
 =?us-ascii?Q?XkiioeDmNw8VZFrFVWdDuR7Sk7+vIgRmW9OEzks+dq7uqMIRPKceJxwHI0k+?=
 =?us-ascii?Q?9s6LJDBO03lyDpZLq3pmYS1VHoPiGdsnTAxS9RCIzEBEk97KyUlVkrGbhSXG?=
 =?us-ascii?Q?+mH1W0FhgwSUhtRH8yV3ptPezVgPH6SXS8B/I6k0Xm9OjhqoiHQ+5JdRtgoV?=
 =?us-ascii?Q?+D4LCPTcyXmETevOn2pLt75lKu/IFsKGcfnPk305EtKnLAyfzy/V2PTOiBJB?=
 =?us-ascii?Q?AUk8GReVC7Zh9L0nPzHD1I2zFX2VTYxyrP1dncGPSAPjTuoD1ThrskG8DSc4?=
 =?us-ascii?Q?HuDmbF8spe4ax1WvPPFNNBFHIvpGb9L/jxy2kosG7EENk2P2RjAI3c2oS9cd?=
 =?us-ascii?Q?yQ30zmAVzeIFV5Z8Tl8mwQvkEvDW/1KR04a5cplqzlG0ziwtONykcyVxDp3h?=
 =?us-ascii?Q?yjYUdXv46mhXVmlIipTgyYreg4ZAMZu5AdJV84194pw2wQeJ4wC65sPZDPIN?=
 =?us-ascii?Q?RMkIHPuSeAnTA9Ty+6doHtPnG3BQv3eJklBw96rTj0VYAMYPn5hdhEPFF3gv?=
 =?us-ascii?Q?yTnzdjtJa6SyAUyLSnMyYAYjXHhtmnrwa9nEk3wWWmJt+5ylcYCXTB+8PUXJ?=
 =?us-ascii?Q?wbqkEvU+aPaSyMwrMpbAZx7f1nPhrV+9XAvqQG9alDAKkfXYUb4NV8dbuxAe?=
 =?us-ascii?Q?QK33x9QRatRmg6rY0dZuZRTT/uO0co5fUvrFIICWEEwXuk0Dd1dwLDePwzWp?=
 =?us-ascii?Q?9zIL22OxAwOe0I/uMyd5iQHFVn77m1yAAFwbsIGOtbG6KUm9DMlRdwGOWsWl?=
 =?us-ascii?Q?I4kcoo1yU7tz/Es7lM3CxdEJkmB+Vum5UVD5D+I9MPirtU54Np/BykoHz9Wq?=
 =?us-ascii?Q?WuzSkQo7RMfyMIe+5RI2ChKK2+Somx7vl4jvcHwYdv4K+1kfVV0vtJCej/rV?=
 =?us-ascii?Q?5YcotzF+J23ajgxdzKf+Ii7XYQdJsYcJvmn4vAhx9refAIdg3Kxbg4S8OUdq?=
 =?us-ascii?Q?JxJR5FPVSe6rLcMDR2b9eg1a4OqEz3xTFeAwgGieKOXXOZit17PLkCp0y2FJ?=
 =?us-ascii?Q?eiS2Orvt9bG0nPQSaN1c7FoBhm9nUIvqJ3ooLRiFBHLKrzewiphMuND0Gp8a?=
 =?us-ascii?Q?yz5n12YBJ7JGP6x8KZShwI6oijJWUcmZ6VvFvVlOqbL+l5sQw2AAOPdkG+hj?=
 =?us-ascii?Q?lqueoHdnu+eP4k/VdaqNNiRcd8cnKRFYjZkxilyTbW3p49ibq+iLdTNZe0r1?=
 =?us-ascii?Q?Hys/XxZ/mnfBddae7JEYiO1b8cO/f5rC+79a8SCaBGE25qsmpcJ/kgvG7Dv3?=
 =?us-ascii?Q?2+9o/Rt2AZdS95LwTTZxPcxhHisesNQnwSlPod1gsJFZHiJg2BRlP0M/xLv/?=
 =?us-ascii?Q?k4WUyi3C2HLoUpt+5kzaq/cOYbU0HRzqP1bMrBsb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4c6092-b654-43ec-333a-08de0c5357f8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 01:28:43.2120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWb7+SKybBuLMlEKuyU9iP1ofrbTsWjf1GgNCsLvUhcz3lrgpnDyih4L7i8QAH76
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6354
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5BA3A4000C
X-Stat-Signature: su1k1ror63rm51czewns6zwyfr98p7k4
X-HE-Tag: 1760578129-613180
X-HE-Meta: U2FsdGVkX1/HCdB0qb2NGVk0kgm40kbmDy83OAUtlY7/zXaf4o7VXmmXqBVtdbb+3yBN2o1mbhumX0inWbGvkX4t+Hyi5yGRZYiR6A87Ze0yB0lhsMQD8kbZdHnIUEpDdfTh9I8fFiQBemCojGzJ1q6bU4e3xFTUp5ZTU60qLL7TQFgY+2hUUVa23JHlIF8aYIBoMeajw+laKmrrmnZUziuZzeGZuSU9BGN5qUAK6Z4Oa1Nx2V6tKMBZS1iezQ4hIgteZCD+sZDOtuK7twk0pqScXMDDsCG3XOW+RASMGkI607mpJLrhLNJIv4Zw6uPmjvKdpURNY13jZhvgRMOj2h7nH3sY09dMYXQWSGXpHs4VulSlQ3shRXwapLbInIDa/cNs9ctUJPGBUS+Xo3Dc1vTMOe3Crdbbtxa23Lp/oxXZ5fWbzzB22jlLrNrkKL8c481oWRBwvBoZ3lo/7vIhLO0oPtOFkeSLh7Rq8s6Ayh6QGqlueK5p2Gut0Dc+/S663NjqUlD/RA434IOeshSe2tWNd8LsOC3dTbfVAKij/0VqCIh0utu+Uajrxg6uVtqRPaRCXlZuVTkmT1v6CXybvXSSBqDQFJAw8IXf/LhoeUld2HKE335ziNdoZtugO+TYZ8WXl3FVB0qXnOk5ss8Wir1dUprSUYNJev0iYKUL9YtIqjYaF8Ak5xYvmOOagYnsa9V/gKfziEYqTukhWvSO0wFk7CcHez2ZqBVGso+/yko+EdW5TgxScJy384yl+KDX5xyNOk83TRDldD6W/Q2wV8FfE3rNK5NQTx+GRcoiBcUfnAmfzDeSnpHQXIG8n2grhSwIMcHSQrAYnyNTeMDjKC9vOwuHuzKD3sbDa8iK+VhO+EUPouZX3gxMomGseSY+WOe4LF//sqXDllo/dhAQxw+5ajWSlF1F7AOcyhHTR0jl9zJg2FsO3eOaOHfZlyagnTi2/Xn2dN9r6Q5jwc3
 eFFlnPiy
 Fs5TBgnQe22hXFLIx8XfrkVhQTxktlqWH+klQM746SFUUzGoSJXgmzyEwLIYC1sH1AQn6e4bBmtFj9uNPEWWK9a0jn1OFABXjoOqIJFgnTN7T3LTAe46pevXmNH5S9KG7o7U2YVGjpEeb8ZwVmqmcC52V74Y5rKHoc4SG9m08TsnBTteX19R0QL4NO1ueJAwDDjXzzsOnZ4XUeE8q05cfgfccOrRLrZnMw3QwsfAKp43METJ67np032bvXOWy/SEWavG7djEtwI4qUv6xdnFfWRsPiLOmmpNporJe2gqN4iv9qEb6CEefcd/R2HAY7coa8urZZ1xmm8iDArh4K3vurS4tymF1tSuNzMl+C831i8xSzHVEUiOaem7CvY5xDgp6Ty8FiNNua5qEQla0NU37XijKCTyvzX7iEHogc+JJ/lx4funEkl8p2k0qzsdXxWpVLf816JoNfcJlYONx8PL8NaERFbh/4Qwvu/tw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Oct 2025, at 8:35, Kefeng Wang wrote:

> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot=

> numa, the performance test of pmbench memory accessing benchmark
> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cach=
e
> footprint when scanning page tables").
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mprotect.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index bb59a42809b8..ed44aadb7aaa 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio =
*folio, pte_t *ptep,
>  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, fl=
ags);
>  }
>
> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long a=
ddr,
> -			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio *folio)
> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node=
,
> +		struct folio *folio)
>  {
>  	bool ret =3D true;
>  	bool toptier;
>  	int nid;
>
> -	/* Avoid TLB flush if possible */
> -	if (pte_protnone(oldpte))
> -		goto skip;
> -
>  	if (!folio)
>  		goto skip;
>
> @@ -307,23 +302,24 @@ static long change_pte_range(struct mmu_gather *t=
lb,
>  			struct page *page;
>  			pte_t ptent;
>
> +			/* Already in the desired state. */
> +			if (prot_numa && pte_protnone(oldpte))
> +				continue;

For a folio pte batch, instead of calculating nr_ptes to skip, this just
skip PTEs one by one. Looking at folio_pte_batch_flags(), this way looks
better.

> +
>  			page =3D vm_normal_page(vma, addr, oldpte);
>  			if (page)
>  				folio =3D page_folio(page);
> +
>  			/*
>  			 * Avoid trapping faults against the zero or KSM
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
> -			if (prot_numa) {
> -				int ret =3D prot_numa_skip(vma, addr, oldpte, pte,
> -							 target_node, folio);
> -				if (ret) {
> -
> -					/* determine batch to skip */
> -					nr_ptes =3D mprotect_folio_pte_batch(folio,
> -						  pte, oldpte, max_nr_ptes, /* flags =3D */ 0);
> -					continue;
> -				}
> +			if (prot_numa && prot_numa_skip(vma, target_node,
> +							folio)) {
> +				/* determine batch to skip */
> +				nr_ptes =3D mprotect_folio_pte_batch(folio,
> +					  pte, oldpte, max_nr_ptes, /* flags =3D */ 0);
> +				continue;
>  			}
>
>  			nr_ptes =3D mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_pte=
s, flags);

Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

