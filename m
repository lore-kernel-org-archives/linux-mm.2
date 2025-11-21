Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7801BCFC296
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8DC46B0022; Fri, 21 Nov 2025 12:25:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17266B002D; Fri, 21 Nov 2025 12:25:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF216B008A; Fri, 21 Nov 2025 12:25:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A67DB6B0022
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:25:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69358160205
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:25:01 +0000 (UTC)
X-FDA: 84135289602.15.1376ED0
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012061.outbound.protection.outlook.com [40.93.195.61])
	by imf02.hostedemail.com (Postfix) with ESMTP id 97E758000B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:24:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BQgG8BRZ;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763745898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qW2J3G4xubUOytNnfYK+CiQVXZu7G5VnmEgDaWl9cGI=;
	b=gHxnhxp3ggtbWE0Jgk52KmX4Dxe+5M/imcYGKT1EGA2X/YEfHczlCOG+k9n7DNXP7E4bsV
	oQlWLnCa6+/lhnfpKCvJQ9eZ4ecDq7xxuCOqX3aW/OrrrIsTm7IBJ+838S1bpgkGfsdZk0
	Tce1br2x7YoRGZFVmHHzsdniN+uCWNk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BQgG8BRZ;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763745898; a=rsa-sha256;
	cv=pass;
	b=l3h2HBUmCTztY6N0loVeqwkwPd33q4XXSCYVdb5IfStpAA5iQwUkkAdo1g2VPQZxx8WdWM
	tDYX0oP8bdvGBT9zvQA4AzFQtC3Uw5Iv2SlvnoxhNwk439TGr9ZqjxfH69tQ/XBzwSkB8+
	QvZ6RTt+0/xNEPTSyGjOBsiIV+af1ps=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sULaSPyCcio7iCZ0Al5fF9411KMWRTHDydl3gb0mrgXjRIyaLjMVK5FJKfn4+HRoA/Kcd6Ek6ZUmBLv7AEqktgAOAXWWfQ3airJQ3A5vL7AUjOuYwCtHz+5CHzZbRQ+pCuz/FrbzPzrJyEI90PhM6Q+k6Ryc1AS46It7syne4/lcA/TaagHT+qs47uE0n9MQRvLq2PjOEYq0dYVODIw/PwbKwxShBHxbVgtVHYJb241sDfPNh6tX+sx8nYFAZO6jvkYPWbI+9K9rBvfww0pI0JmfPaEhEGuZORa7M9n6TUuKKtRmPLXM+1vBjnTWzfVBJuDzu76lrhRR9qNwLTLWeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qW2J3G4xubUOytNnfYK+CiQVXZu7G5VnmEgDaWl9cGI=;
 b=RV6+tiH0+ox0zFDsdrivrRU3hvRk0ZYIx28PesOWXpuK/p8gm7Y4WkRN9MQocH+Tzy7+JUTO4MAbBKlDCWMkfESdwYYwgtfuWFfjhDe+wcC0KMWAG1FOhsenK9vxQtpyYavkPolsZSUvXQVOXGP8n28GnGSFhk0WUGZ/0OGPJ04PgFCIsY/G/KUDv2xPBjcSic6jRsr8+yHUdDQINZNM/xX2U5MDWt3CY5AfBaBSC+UWZqOtghTKJI4ECAxa5JCpaGUtbrbbBU4MaS0zwz4Dak8C1s3riaqSfpW4ObrMm81GR38fhJhXTXGing0vubDGOsQVO0JpdXeK+tlmPMswpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qW2J3G4xubUOytNnfYK+CiQVXZu7G5VnmEgDaWl9cGI=;
 b=BQgG8BRZuX9RrDoWVh07Jpu1BkKHRN39908CYQZQviljOU3E1AbS2MzUAd3JKaooEbVCgqtIzoNhQu2xuQMT2zDnejSnKi6IXpJX0C2p/COL6TYGG8o93Ry2C5c6UfajTjZ0UN1n8EviS8MAnCFjTpuUFlxw0mJoFAnCDLe90mOn0iRkJrsad39iXIpxVTMNwNMArsYqP7pceXDh5If/OSlqt7R0ciai56fQYOq1YctauysZeaIkJ1R0J6MXqFnhDxfa0NeoLy3oqbxeW8r8oP19uAlFM+IHZBg01JuGEzNQF/1mJQEgAKiU9IPJKs5Bt3ruLVFh+153uzBRuATL4g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8357.namprd12.prod.outlook.com (2603:10b6:208:3ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Fri, 21 Nov
 2025 17:24:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 17:24:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference
 in try_folio_split_to_order()
Date: Fri, 21 Nov 2025 12:24:50 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D9725DC7-8B7E-460D-8859-09F78312DC9C@nvidia.com>
In-Reply-To: <fa8c3018-f4a9-466e-af4c-6f97e3247b3b@kernel.org>
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-2-ziy@nvidia.com>
 <875584d7-5a68-4f7a-8549-2a9cd6c7f9d8@kernel.org>
 <FCFED9E9-56A9-4260-8B42-D0BCFC83C506@nvidia.com>
 <c29e2ec1-c607-4467-b500-617584c8fb6c@kernel.org>
 <73075A18-3C07-46F5-B8C8-9018D2CD22DE@nvidia.com>
 <fa8c3018-f4a9-466e-af4c-6f97e3247b3b@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: DM6PR01CA0005.prod.exchangelabs.com (2603:10b6:5:296::10)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8357:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a748da6-64f2-487c-c7af-08de2922e328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XeV0KSVnkr0Rues7E73uWV/P//kN0l69VzqkIaWnHXNfI2tlJ/KW+JVKjXRL?=
 =?us-ascii?Q?+RgLyVrG5xyXI5pvfhFyZcBBKPNpvV9ci+WPiqNeU5LY8PNP10IIQ6QO3gWU?=
 =?us-ascii?Q?dC6huQPCYT7QxqzcKPk4YHqNb79wWwtoDd8FRN7fRqj9zBksjHMrz2psO2Wb?=
 =?us-ascii?Q?OcDS54WHeb0Xs35W5IdkXYd/Yo2I28yp2vLVfwlJNTRERX1kxWTXl/cC/1Ts?=
 =?us-ascii?Q?l59P5bk+B3VSnXmNz61pvBqbvC0JPxVXqj3sAhZeza/h8uNp2KhVHFAWR4R5?=
 =?us-ascii?Q?of5U++Nl8SJIESdROKI+wDnUtF00PXoyDSH+45oJwGP2cIHP2hakB2Ud6UR4?=
 =?us-ascii?Q?/+PiRMT38WZB6Jrkxh25N+yBl46thO8CkRtmdWIQTWhV4JB2nOGYmeQ035Gq?=
 =?us-ascii?Q?YrxBA1H5sUNNmh/497xYHeZwv35WpDUdovFXVmTFlNeJmGUR40xprO8rrMw8?=
 =?us-ascii?Q?Ruwoq6f4cNWYu2LfayjqD2BnGzBkOKirlTrf4QBi3+uyAkSh9gaL2mapEAuQ?=
 =?us-ascii?Q?teFOTg2Zux/dSP4RQVbXVy6Krpguos9cC+fYoQM3L+kaI6HcDKEISqCbn8x3?=
 =?us-ascii?Q?AG1scKYLKHuQrHS7iskXXAAloAfgapCk7U5Td2taNwFIkVcFGmVfLaFdll3Y?=
 =?us-ascii?Q?r3i9IEMAKZgKmXlY+ZHRjc0NTv/gGDRypLyNSGnlFcPoTeLQAQryf2SbPRUA?=
 =?us-ascii?Q?3gMZUvyUNRC+Ifyydn9B1GaRQhc3+YlZ8JT9kTnhVhIPcP+XPNPg0EhYRXqI?=
 =?us-ascii?Q?JW+5zVnw4kz4TvSxMU/vw9On4E0kF6niSixx5Coce8g0hdyKPBREEz2Bs8K9?=
 =?us-ascii?Q?pLMnIaFExDMSriBAtCjDkZ7B/HteVGYYqDeugpI7UT5xA35jneqFofGEk9ns?=
 =?us-ascii?Q?tTro3el5jj753/aP/0YrZy7p94T15C8LcPVt9tLcdJY2s9A11kX0BYgDDZNd?=
 =?us-ascii?Q?SZidhTugH318APe8HrpiZ91tIsou4dJSuZNqObm78a09ciJeZvqJvGs/N9B4?=
 =?us-ascii?Q?wTNaVOSgN3GYJw7uJ4Hoew4tYiZdYt7xSVlakBCCNlMlpFt17S8j7+JrjtUg?=
 =?us-ascii?Q?wAdG8JYmhcggHaQVdj0E5CmkHANuB1dfTwgOjFwMYEXkVAnkwuOz9JGayCzf?=
 =?us-ascii?Q?k8wA6sEMffg3EQFUH6bYptaTh4V6jeRZHBkm0NbqjbvWBNUOvPAt7vVdQsCZ?=
 =?us-ascii?Q?aUKJElOGkiFS9jRqppe3THiR/ifu+YIuR2DjE3daQD7LuOj57LiAT4vO0AEq?=
 =?us-ascii?Q?ZE2jPUE5V+mxYQ9EoamqqNCiujvPnUDvg0oN567WR5eFkt/6xB2yttpqx0zN?=
 =?us-ascii?Q?8XLGbIbYeo4/KrY4T0KIsA2os/YzMA2ol5xXupgigsDSkX1TTZMK8pfvXqlI?=
 =?us-ascii?Q?PDI9ld71dhPOFpOAeI62objqNNJOp72WR4niil0zgXmYY83a55p31vbCem0V?=
 =?us-ascii?Q?vbBOeYBsoJrPlgBQIvqXFXzxXDOueJEO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xy+StMAlCAt3rw1UvGu+XJYvNZ9s48fGdf02BY57BPinhiCzo8QWkLc1mFfJ?=
 =?us-ascii?Q?iKxPd8RKv3DZcbPYTLMQPdNH30ZLM2BZ2MQ2Gm1NEiCSaImiOV3t0ZA7O2Be?=
 =?us-ascii?Q?5BN5tA8nBT+NdLcYWRnNoF/9oHQr04NN3vf/iTRNg0LbTMGYk+tqDdF57q6x?=
 =?us-ascii?Q?og/GBpoHxUe5692zSuujK3bFVQ4wbQN1LrAJwhPJYuC4fr5tfCv8j1S43DiJ?=
 =?us-ascii?Q?gxHqb63OwNJbJs/X+Y0DKXb87yjZKSTA0ishrO6Fu1P6lCArw4zBFt2ShYBh?=
 =?us-ascii?Q?f1/Laven5f1DrBFCT+FjG4JTAX9F51YAggqorgv0NGJQGa2yajQHST3j6EbT?=
 =?us-ascii?Q?pHkFMcJT/3lGQzKhltNvpf7pR2rE41X3j2gE1PsOZS3N9FTt080qupey0G6S?=
 =?us-ascii?Q?TbfcYTZwDs6Peciq68M8dR4pomZbcQR0tV7jEwc9QeUTqnhkcfsLfV856Shq?=
 =?us-ascii?Q?0Qjeb6SwbTVJyhuSEhawSFAMa5JT789XUBLyCjzzmUpvW8fau+EgczO8ObJk?=
 =?us-ascii?Q?P9sFdaoILRDiDGhrVLGUq7YgisskhK0VkgBYjxjhrxJJA8L7IjS52rlSik2o?=
 =?us-ascii?Q?VA8rQghoz+re3tir7kntRkIQPYxSgQu6ljpH9f/g2gibeRiYqbmBodTXAUBD?=
 =?us-ascii?Q?yZl7ZTFPxa5NHlAjZK2Dwy6FqaMspDRxAQ8OdaYEsrkbI2omo8gTMqK/Vj3v?=
 =?us-ascii?Q?V1zO1vXCDIOW4HgZ+JlkOKzqut1E+rW9VVgXfXOH69ytIE/6PUhNaPzD6s+F?=
 =?us-ascii?Q?QCVzkydWluc2kaKYRht4AF6Ez2bYNT4DONeBANx3dd9qZX/D/YrZJJER0ipF?=
 =?us-ascii?Q?CfoAIBvfrcZdOUGFmbzL/oyq3Bp4xuTfHOmW3xYDmgQo882h0tJ72QVyPMLq?=
 =?us-ascii?Q?qA49XCEa5oiWrmb0rd14J6KldOCZVvXVnZD73GO8hu2tCw5rrBrknsCR75c7?=
 =?us-ascii?Q?BahUsKZNUaxLRf7YAqCNhasRVOguSuUM+GDog5jWFopZI5ZTr2bKIm0UC9y5?=
 =?us-ascii?Q?7oC71hLQoL0mitFDmlAsau8Mljsne2aucho7SG8/8YzQ1rm9o6gfi6GNVbxW?=
 =?us-ascii?Q?CzLUYSSYTUrO9DEn+PzFJexIWLDg1vN2p8031Z2M0AqKTwbuKespoWnmcXJ5?=
 =?us-ascii?Q?U68otwgLu+fm5QPsC2m6J00Y2pEB0fXBIjUJMNpC9robjypLQj2LC9iqUsa9?=
 =?us-ascii?Q?0YDoU1V7zvOAHbpuFsOHTUugiJtDFOYYLXjP3I5g56PClu0gzg/5aDB/QFq1?=
 =?us-ascii?Q?zTgbaFWeR/dNYS70TTS3dZauNb+UiPR2ootFnXao3GICKvj515UlMLkjg4ZM?=
 =?us-ascii?Q?/qyeTvAS+uJqN9+An0wL9m8zGs4c9oUB704neizLcynKzNkEiUqaAWFjsmZf?=
 =?us-ascii?Q?ked1LGFIg5/0+UB35eV4JNmYaMnjlHRZlzCh+AMTdXmU7GsA7gfdpkEVANrq?=
 =?us-ascii?Q?gyJPDtiffhgJCM2Qu99zAiurl9cnCbVz74n7n8IW5Tzq3/swpbFalETToGgJ?=
 =?us-ascii?Q?2vYELpqiLrsfbMI3NUtpaj7zjfOMoXJOUsG1Mam6uJ+aX/lq/YFGqIQt8U3V?=
 =?us-ascii?Q?avE8FIlpD0az+MoYF/gz55WWqbLqeynVKoBYX5hh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a748da6-64f2-487c-c7af-08de2922e328
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 17:24:55.1171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3/KFI5zHu7g8TNep7JzHVnGa81L7WSBPc6Z8bx5B5QGCJHUvJILcx75OOIY9Ije
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8357
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 97E758000B
X-Stat-Signature: 4pgqcqjrjuummiowxcy6d13cd5iru31m
X-Rspam-User: 
X-HE-Tag: 1763745898-950142
X-HE-Meta: U2FsdGVkX19v2geUdIADZsMNxEEhr09N+Sr52xY7HIUG2FyDPyeM8Tpv8R3fjN/a2SjpvEQ/BQdJ8Aoh6hWiCkmIsUr9Ts8XthxJb4eF8ggRjMKIySBFcJgZY/Jt96TyuCLbAAbG1jmNeEdbLk8EWvAJxvZ1rsCTCZh9lrsrKTcNYHc2YJYn1VV2nk6GzO2bsMJ5Ezv49wwCY7ZlsdvrVCmV06sgwBR2XYZljjYZi2Nk823+EO4NcvdCG32KqRaX1qJvueMJxxmN9d3KlGkobqzhN3a3i3xCCF6k2GT0zlnQSxvv5Qtxyb4D//bbTZ7+ka9bXd3i6Fm/1Vt1eVdpDz7sPlEHDPmEUh3y32/6iBKjG1+wi73qQYGVHJczpLsSzZenInnF/ycIXKsKZ/+fGO3eX+i294YDMjA2igH2pL6/tUCtFP79g59TxBIbk8l/TYIlNL/gWelAtGkYHpqbZxJg4gejrOqo1zYKHqRHKDMtFC56zkMEe4210HHFN+WQsT9Zb3RQgOdI/ptFJGGbuvgFLB4ir5L+Lud3HjnAIu1YAAWdq3O2Y0y1ZlvVpbk1yLulWO59ioJrr4RQVD+ee2XJKQmtsvdjkwybKYS41erWS9fF56WayTy21RkYgow3UMSQM+g85noXqAUxCyK5AAUFlMFjV/EaCpHTryk77ohb5NTZXHTJE9swCBzegxTTtPAsPG7OEYoeRx4Wpd1OsVvqmC2X0iIhRZhcmZHIWvTn80mGDQulM5ODmRSsvF5hC5Mf14BWgACkseFr8Wp5lPdXcf/iwh3147FuNlcwRzZymYs6M4ya7zvFtKviRh6s0UgcU6fEr1VUgmEH/y9qZIwFh/+syHxFFPvKqlwBzcQ0IZXjzM7rfcKuwHW/V9WPBoLwXfDYpi8HtL55e0mee0/5890DgpU4v9d4sYLcjjKDGWePhRBvWvmezojOf3clo78Ht0lm4/1yMG4LAAW
 bJwHOJyT
 nrol7mb9AwdJCO3MTAqRynWrGPY900f4Ov65Wb2M9XOaFjnPXsnaYcVCk18c/aWiSE6InHjdx388LwsPlCoEop6SO2PwtUV6tsUGtPee8nnKyce6b2qUfoaGBtR3eCNWtpSvu/CfVZds/xlHOolFrWhQcgmnNbQg0ULnb+MZ1IAzOzhKgCvba8+ziBGBO/WGLiG3N8z8vJokNIpRjP2qSIzZUThfVgtFU37CKu00e3OeJALAZPpkF8WjzX4OALsKtsgLlq3RiOIeLbu/S9gsoleIPCT/vUrN2CQheOip7GwPv8pwehY9BnKhvFz1VTK3aVdGbzX5sU8t7rVE/C+bjPO8+yAWq1HHUY6cqQHk63c2uqWCC+VQHZipSgxAO/o/QrG62s+374gLa6pLnzmYiKxyupA49fWHjPKOnGsK3BwIJLpi01M5J7C2Vrtb8KEfAzh1pfr/vlCRmwzj9gGZO7LjGxYm/iZsJ2D3h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Nov 2025, at 12:09, David Hildenbrand (Red Hat) wrote:

>>>
>>> BTW, I wonder if the is_huge_zero_folio() check should go into folio_=
split_supported() and just return in -EINVAL. (we shouldn't really trigge=
r that). Similarly we could add a hugetlb sanity check.
>>
>> Yeah, is_huge_zero_folio() should return -EINVAL not -EBUSY, except
>> the case the split happens before a process writes 0 to a zero large f=
olio
>> and gets a new writable large folio, in which we can kinda say it look=
s like
>> -EBUSY. But it is still a stretch.
>
> I see what you mean, but I think this has less to do with actual races.=
 SO yeah, -EINVAL is likely the tight thing.
>
Sure. Will move it and use -EINVAL.

>>
>> Ack on adding hugetlb sanity check.
>>
>> OK, just to reiterate my above idea on renaming folio_split_supported(=
).
>> Are you OK with renaming it to folio_split_check(), so that returning =
-EBUSY
>> and -EINVAL looks more reasonable? The benefit is that we no longer ne=
ed
>> to worry about we need to always do folio->mapping check before
>> folio_split_supported(). (In addition, I would rename can_split_folio(=
)
>> to folio_split_refcount_check() for clarification)
> I guess having some function that tells you "I performed all checks I c=
ould without taking locks/references (like anon_vma) and starting with th=
e real magic" is what you have in mind.

Yes.

>
> For these we don't have to prefix with "folio_split" if it sounds weird=
=2E
>
> folio_check_splittable() ?

Sounds good to me.

>
> Regarding can_split_folio(), I was wondering whether we can just get ri=
d of it and use folio_expect_ref_count() instead?
>
> For the two callers that need extra_pins, we could just have something =
simple helper in huge_memory.c like
>
> /* Number of folio references from the pagecache or the swapcache. */
> unsigned int folio_cache_references(const struct folio *folio)
> {
> 	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
> 		return 0;
> 	return folio_nr_pages(folio);
> }

OK, I will give this a try in a separate patch in an updated version of t=
his
series.

Thank you for the feedback.

Best Regards,
Yan, Zi

