Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949D91125809
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744C96B0005; Wed, 11 Mar 2026 09:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C1C6B0089; Wed, 11 Mar 2026 09:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA446B008A; Wed, 11 Mar 2026 09:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34EFF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:38:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2A931401CE
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:38:24 +0000 (UTC)
X-FDA: 84533886528.03.5ED4007
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013017.outbound.protection.outlook.com [40.107.201.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id D78A8140009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:38:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fMvzypJ5;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773236302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqfBtI6HU6oB8rDRgIYY2mFOfdhdlnos3Ac1U6oGDlc=;
	b=t/7bjPmldoDhyur7hFF0+OuM+bvO9+VKUIb6eIOTYgBC7herE8zOgIIWnjqiGcZVD/ESsn
	q/wNWtZamF3F1WAog9EyoMnwMfRus8vXS/zee9PetguVZHMdhCXvj4Xxpe4ts9rrlvRRIh
	Y9LB9Rmj9RY7Wef8/UNJTHLV0+5FmQ8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fMvzypJ5;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773236302; a=rsa-sha256;
	cv=pass;
	b=1uj0TaCxJ3QVX3eOs7yZpIRZCvRdy8gqldF5b2Z86kH9ubL5cSwzYX67R3tORW+4zHku0m
	Gu2A+VCpcSSZdR3FnMo2KzFdiivIadv1AwWncvnjsNODXdZM7isU5amYnRkCq06dfa/MZX
	taHkAX9Kxgjf5xi9wI/PByIxDov9vis=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R+tGdLSdx2/5XlB9qJMffyZee9FYg81UnjL+bTGEVEgXEmTCjkKtykoWX4IIITFPR/5u304IbgnQ+a3N8nJJ2Qc4VZlICLfFk2xu1GhP5lb2QgxnTiq60B6Q8o4MC8Cw5qqvkkiTYu9kdSSfQSQ++8lx7ezVrUvaZ8/tSFA99/bt19lGZHK48R/1SabehCR/pnM0VDFtADFyyndpund5qI3S2AeIybJVgkDii7n/eG099zEFkDnoGWMt+BXRquQel/e0SaK9PCkg1uLR9NzDhij2TpN6sRUmScJX/ZA1bUBoLAHzbrDyVLknBgny3atGtPJ2QZ/P2LteImJYs7Gz1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqfBtI6HU6oB8rDRgIYY2mFOfdhdlnos3Ac1U6oGDlc=;
 b=D3yS2whupwZAsUPv/bx7ssdaDfpY5aFUPrgyTk723PQN/CyH+whyYOf/9Oj0oBPIlLlb4RSAnTx289yGsueQaJABWt5xhubxc16XkAByEJV7cPTzqwnQMFoOimRn3MmujvSWoWSf/55JnC4KuhMyUwEKbky5TZcaYwvbabW3nY2j+8xTjRukUbTzEyqsKpqNGWQxHBcwToT3JiWkYB9Xp/twp5erz0v8hJqga3262ZveNgC74XXgR7u15gMC2tONBhVt/h+gzLmpA+q6u1LMQJx5PT1z43HDCKp2Sv/a0Kuok2wFhlLXsNIvUP7RCI9xd1smexX03osQBz0yPi5ZCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqfBtI6HU6oB8rDRgIYY2mFOfdhdlnos3Ac1U6oGDlc=;
 b=fMvzypJ5f3ziV5LMQSUNenfQWRd76UufMOkko6QEVCxVRC8BUdW/iKnWgUIbh/F+ycDfBuumlEk9WMjSm1PiDf7c2NBkoDcFgjb0kH7ZlKBxByJPYTHhfWUhw7efObjBEGBCT0EklVFBQR0uoES8SSQRpg7jAJWGMijQO4M5GuESUJClOGfWmqJAd1vFG4EWFKqnAVQXhC7bIw1fsAZw6Cx9A9l8xSFy1O3DctoZnFnCG71qJFDBqMtEyNr8MeEjs77EnNp/zPNh/QQRhF3p67UuZ19nyZDy+L2QMc3UkCtxtbpmAzZ8UG6YgPCDEnpj4r2fA6SPWzSGPMEYqQCjIw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8240.namprd12.prod.outlook.com (2603:10b6:208:3f2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.3; Wed, 11 Mar
 2026 13:38:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 13:38:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: migrate: transfer large_rmappable flag in
 folio_migrate_flags()
Date: Wed, 11 Mar 2026 09:38:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <1DA53E52-795E-4057-81F5-E39B85D7CF05@nvidia.com>
In-Reply-To: <46edc7f1-f97e-4ff3-bf11-a56feb8e33b4@kernel.org>
References: <20260311132342.3193160-1-usama.arif@linux.dev>
 <46edc7f1-f97e-4ff3-bf11-a56feb8e33b4@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0413.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8240:EE_
X-MS-Office365-Filtering-Correlation-Id: 915e204a-9ea2-41e2-209a-08de7f7371c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IphfQMAZdu0WKTp/HguvTvU4SbiPZHDhjuug5KKFl0v6x2Z4pHysAbW9CHJxfSZGfK9YuBk5oba+CWQqcGNBCiKOAVYdhaiQHpBE1DCe6DT78pnIQBI5xJs3DGz9+0RU/rfui5AM1TR/DGkDcUiOgBBY5F9y/uqnFpmLoef761Ya6HAGwhm2xuRfdZoXfHDGPCfRp/rfDS7aePRuRrLKxapE4f5XFS7cSR/2Qq+gw/9O9N2Eofv1xY6fBynPqm/wAIZIR/Saf6u34a95ZCthEWKBAt6PcfehiDuF6X8+X2+XaJk9CqklTZ3TfX+W5tvrd4FU83N2QU1rryqTFXkGtJwRaDb+pYqVn6I0uEqo7ox5CzZ3T0QbngIfc7FDGvF0W/8rKpw3URFHmzEqPRQZpj2muJp0o0WrMLha8PIHsOgvu+8nNNDPg+4Vcy9bRcn5LYlINL86oKaedwyCj9TGHWlR9vY8Eeq3tvAGrFI0lFm3DMmQbUvGfw2v7FeUBNtkQnIoZW24XUHf98I8WEmMkOB/u6MCyCRUdztFJtUp1UcvAvnxhM/fJimINgoewqkMz8s5E0vPd1qfAJz612BdxIlXQh+YdTDojkiWX2cGWChNwg5yZ1LKG1QhNrnC+I8hqUoHj1tVgpquug9wD0Yl/83nTbiqeu0r1QpYz5cM+xRLuG1PjSR5Gcm4BE2t1DHKv88VArWx+iHE4pxzizr25RYuaFunON5fts/UIdP/Xvc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/1hw4650mNGdPh5mY3FqJKwKDG0bM4bClKTijkUSIFV9jursrgp/0KaSccMM?=
 =?us-ascii?Q?JO7rS/mTT1uTqXLvC1K8fJgxF6eyF8E8OZIDxB3EQldEHNyZN6FQy8hdiNcA?=
 =?us-ascii?Q?jEv7LyvZyHvr+lc3YCp+IW0DCdbu3q/8hmMemo8kNT/R52hheIEtLYuEZpSo?=
 =?us-ascii?Q?xXN/0P1fbRw3k199/iwvE2Vum7EgjJPE56dwfy5c6U+FWMUHy+qE7VOU3jZw?=
 =?us-ascii?Q?gNMeLkZqh0+6YbkKCuqkXr9Lqz/S6jVOOgGlXW3vGAWjdHrZrz6gYq4jWylk?=
 =?us-ascii?Q?/Pxx6oj833yAIkRIS7H0FgiOz76yQoXnZ548BsHXUnTOjckyyTecA/N3nOk/?=
 =?us-ascii?Q?XNvjsYnGjxzuxpBB91jV3JfErFErfXyn0ocHZq18d+O9X1Vzyy6/iLlBUbHg?=
 =?us-ascii?Q?XYxqrKww5kDxnHufDX5MZcWMXWx19Hgp6ldPkjNytCn0Gihp0QAhyDLsxUJa?=
 =?us-ascii?Q?xyV6PAXzoKJXCVFkrVF2f/osdUJpOhHx37cPiRBQZsf26wVl/xDZMrsd6Lgd?=
 =?us-ascii?Q?nw/5TOMOCfUrO8zjpoZJY1ElKa0XlCzxiQ2xJx/mTGKvg+fm7Un+VLvbGLY/?=
 =?us-ascii?Q?otovS5ne/njs5X2bHkkq9/URUbi/zh4SZP54KLVIjrRkUhV39h4Mib2akVAx?=
 =?us-ascii?Q?Abu3+XJLgv9ZOjXTBq3og36mgPadf0W2JMCQwkZ6nIyCpSxOxs5rSnSZiWNT?=
 =?us-ascii?Q?BJeA7M7tMCZUugCyB4LJV8q6BrtJQ5QZlNuenK4cyvMHdWj5cEPUaVSAf9Fr?=
 =?us-ascii?Q?oYQllCVC54DGFebbg9sw+KmqZ/5nF6r39tJ/LmbCnyfM5+vl1mqnv+NqBfS7?=
 =?us-ascii?Q?B81Heg6UVOG4qeGkol5kkukG0J2AvLi1OSrD+jCY+AItVPE8wSBfomFidpRv?=
 =?us-ascii?Q?T2JnrcuS41d3NFQ5Fgt3p1DI0cOd5fj2zA2S5PosK3607EJsPtGNlkGS8q7Q?=
 =?us-ascii?Q?wu8rZA/R8G0LkEtfZ5C/Z0Ke81bgL522sE8JLiESngUQ1VkJAiVzWwfHrIU7?=
 =?us-ascii?Q?V+T/dimwMpCQneCCVmkaEbv1GMrPVr2fZOJJtNliamqA1dfFcalRvg0lMhiH?=
 =?us-ascii?Q?lYi8hscj3kiWQmP5uhy0QMU26Gk85W+dksHj+D4UEJHEC3rJVdc/RLt3DyDJ?=
 =?us-ascii?Q?Ve+3oVkX2wONgPYpJ5p111Wwdb9z3g9/BfiSnqgoE1XEcK8g6gMbd1H8jblc?=
 =?us-ascii?Q?Q7uIOzMU9NTwIzwsxHKzhSBndywVD0o6G/XF21YVjXTFYerEn3O3pBKMXgfR?=
 =?us-ascii?Q?6ETMvqZ+Wrurf8zBtNBtwHGpdtqTI1YV5tfhRNdkS5YC8ELc/LeLAZrz1BX7?=
 =?us-ascii?Q?GfzhTETrOexRljo521a6xLyf1FpiJ65TD+uBZtQfZTmKx/nyYN1nTNvrl1Xm?=
 =?us-ascii?Q?/CeUmdYtaIk+LYa7ufi8RfC/bV7arIPGPW4jJ0YJzRbBlwVENhnLeM4a0/xf?=
 =?us-ascii?Q?ZMBoC2K2m9Jk6u5M4xLuo+xCVxChVl92hEUo7SGx5knuL/PDnbOBTHItH2TR?=
 =?us-ascii?Q?45hk2YH0XjFrZMuC5dNL3oHkhkHea9olJaA3pz4COvRegkaPIZR6HHykH/C4?=
 =?us-ascii?Q?flTC+C9yUCyFPJo8uPgPGuFJsxvyBmWy2wb5agQBL2q/M6B1WCc66sxTsK8v?=
 =?us-ascii?Q?Zr8u+l1h0caFovoLGRT77BVX2t+6uvMQXr8f50MItF+OxgkaN1bdXLFOFV/2?=
 =?us-ascii?Q?Fe7DV8rg78Ga/JCgO+sd+Y+xoGz9gS2GBiw87E/d0Gr1u+jS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 915e204a-9ea2-41e2-209a-08de7f7371c4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 13:38:14.1702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+jVZYCpP7Dk8UrVqhRX2NalYI0X72M0yf5nc4oC4NjrdpfBvTO359v421/4HcCO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8240
X-Rspamd-Queue-Id: D78A8140009
X-Rspamd-Server: rspam07
X-Stat-Signature: qec8m7q5pkjb4q3jjn6bg4cwy5habrrs
X-Rspam-User: 
X-HE-Tag: 1773236301-26867
X-HE-Meta: U2FsdGVkX1/0mOwgyGBA31nNnvxyblk/WX6OXegBNm7Zhu9DQcY8jJdF17rnVBVo/+K9SVRdJSVLArJCYD3TdVUwQFAOWDw54C3buu7f9irebQ1G8uSv8chgVw48Vu02udooQ0cYjF5+vF2cU8KHQ0xElMMLSmVVmM89eT5I4Iy0SyPK8Il4+nrBFiY2HQq1nsn24GXQCjZ4HQV6jnOROXLRv1w72Hjm63DlUpTwiZUMZhl9qPigF9hW0pjW0IUi12XF4Fe61UlbX8svKiYtAhZhy6ejF6Q3ucu5Nm3B93oUJBGep0khG7TDa6vzm86iguH58OWyZil/PFlsFoX5ujTwPp5JGZWSS8DarX+gTlV2qVSVuPHsOVPK/5ELzZhQ8RjuZbOvtyI93Jr91nTeCd1BneWMpA2e3A/32jlLTctdcuDoQEdfZqSqgp9vymSTvka+tEREeU3fsVl0WBWTSq7OFeqmEQsP3zFhUE7ibs0ZXz2cnYoURNV/C7fvAURG+sIZ64tizbBSRHlT8qGzrEJpEJeBZPkce0DFwCodUzo5ZTGfk+7Yf9lbNQzIQEhi5cETimA0t05i7qp4ZF+iS8picLqH8tkfZuIFqRTpyvALI8mYB+76uQ3p469aDRiAtpqPC6b5Iiu4IvGHwiOc0YxAzS6PcFFQWvuf4OvVIX7ruw1C33HNCRp3DHWEH7w3GJXUCPPcdDc+wzIzH30Q0O/8d5QIMhi3sdR43MacmPVPRt3m4YCEd1fcdj7vhswEjEjVUtf4Lxq7ymjyKniObnMPllKOktT2RhjDx7GwDVpe4xXPsGJjQCm/WEFtT9cYvx7ImtE/JldIo5nkeGhl5jxx5j3fX1UuinB1ufKbAKBQ6kH501+7iW6ORvSklyNQb4YTDi8So8whBMPPxVgpqNNHg4yY+22eF8CgnAWkdADDAZ09bR7Rvtu444f/WY/nwyuyg/PmMFFh5+GRofS
 gW6D1zCO
 kIsq/RQ3E8nvhUEInsej2XFi2wiacNjntENt9vikNCrtR7UHcMrcAezbZYG0bIaAqKtBkLlFDBCsxvG8y5gZc7PrQQL8KIU9bvwvg1lTKxCtrKsbMUpkPBwZr0svd/Xn3xKYkp29fj8eZVoXAuMwGTwqViCg5EadjmSO8kMrai/oUlTuGaMdA7pJJnqDSUkapQYs5JSPe0H+hGBF5U8vv0Tb2tinKiTXVqC/d9Wp90YESk7F3aD3KSmHd54ZBLmrllvf4hDsAoitaEN98p0FbDfCKOkH0lwI65TUQHUwK2uaKJpQK1OFmvWuAxjLDKoMs/vdVtWUOsF85RTK7BOgZb30Noe8SGS+Ob9We1G3z7qBd7CqqjY/M84QvHfJHZJNRBrKex/fLCxaiu4001JSOXFhpaepoukd72K2wM5ZttUbTT3bMOTxdM9404034XD/JoAlP3bN933eZTfN00ojoYoP3D7fUd3XZAAcg6N1pQwQo9EY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Mar 2026, at 9:33, David Hildenbrand (Arm) wrote:

> On 3/11/26 14:23, Usama Arif wrote:
>> folio_migrate_flags() transfers folio state from source to destination=

>> during migration, but does not transfer the large_rmappable flag.
>>
>> Migration allocators like alloc_migration_target() and
>> alloc_misplaced_dst_folio() use __folio_alloc() directly without
>> wrapping the result in page_rmappable_folio(), so the destination foli=
o
>> never gets large_rmappable set.
>>
>> This becomes a problem when a folio on the deferred split queue is
>> migrated: the destination folio can be added to the deferred split que=
ue
>> via deferred_split_folio() (which does not check large_rmappable), but=

>> when the folio is later freed, folio_unqueue_deferred_split() bails ou=
t
>> early because large_rmappable is not set:
>>
>>   if (folio_order(folio) <=3D 1 || !folio_test_large_rmappable(folio))=

>>       return false;
>>
>> This leaves a stale entry on the deferred split queue, leading to
>> use-after-free when the shrinker walks the list.
>>
>> Fix this by transferring large_rmappable in folio_migrate_flags(),
>> consistent with how all other folio flags are handled.
>>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/migrate.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 3380021fd3db..ee1c7bc851dd 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -846,6 +846,9 @@ void folio_migrate_flags(struct folio *newfolio, s=
truct folio *folio)
>>  	folio_copy_owner(newfolio, folio);
>>  	pgalloc_tag_swap(newfolio, folio);
>>
>> +	if (folio_test_large_rmappable(folio))
>> +		folio_set_large_rmappable(newfolio);
>> +
>>  	mem_cgroup_migrate(folio, newfolio);
>>  }
>>  EXPORT_SYMBOL(folio_migrate_flags);
>
> compaction_alloc_noprof() does the page_rmappable_folio() at the end.
>
> I'd assume that all migration allocation functions must take care of th=
at.
>
> It's a responsibility of the folio allocation code, not folio migration=

> code.

I agree. The migration allocation function needs to give a folio or other=

types of page matching the original one. Do we want to turn this into
a WARN to make sure newfolio matches folio's large_rmappable state?

--
Best Regards,
Yan, Zi

