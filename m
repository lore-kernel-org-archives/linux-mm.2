Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DEDD11188
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639206B0029; Wed, 26 Nov 2025 11:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9B36B0032; Wed, 26 Nov 2025 11:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B166B0098; Wed, 26 Nov 2025 11:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF356B0029
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:56:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD0CF13B947
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:56:00 +0000 (UTC)
X-FDA: 84153360480.28.78B82EE
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	by imf08.hostedemail.com (Postfix) with ESMTP id D84DD160017
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:55:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mE7wygpB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764176158; a=rsa-sha256;
	cv=pass;
	b=ZWNTWW1eFrFjz3/8yiTe3n7ewR1UHaqv8d8Oah+bcE36cwxzR8gJbJZNUyoFmH1Qrp3kVt
	3XlF766bRLI5stMZ/XzliNDH0LyeNNeN+owV7rTB8b4y02dxESdL44ly+AJOCbLLQbRtS3
	FYZqVzb55cvR/PkqXVMgwqOjqmQixlQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mE7wygpB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764176158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zsg8rXjgkZaICaBAi/JHKOJRlYgFduRh6Q0Og3d7AjI=;
	b=slDTVNGoAl/j8NpABd9zJXemVJLHhWkYJc3WAP7MW+ae78v1DJ5IT4rskYm9+HnD88I9S+
	9Cu0bMI9Ja59uF/Nt4eBOB8/PPVtbaFgcjZnM68R5YxLgKGKJidQgUhZdxRWb7fNJtcCs2
	bsEPse8HiIPlOGQ0r6lSqSfSKyKkhSQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yAN8dSqQDZHgzJEpkcrUGzoH3AEpCIywCasSizOVHa1LweWHtg3tk1aW3OUmKJeFqNEA2647U/jDzM83Sum+rkbHstkGonJnJWV/+CxKqNgbHuxjBiX3RCLzEaoshoz4WP6qFARe6rqkDskvZ7TQ4GTe45oyX2emNT0qrD9bgPPqP5+wTwLSwH7OZm5zV5UdNwkQWMuGZ8y4YEsEtaZagd/jvl6m5hFz8x7XPMgOr+osGC/Yx2H5e+3HcPJfAXZi8HjvgPzmDvOa5EEHQ6l+OvZaBUENGbanmrMwagl2HWLUkmsv9LeaiNYeKuPh1Z5o8RV6wYhQZ0DL7o66gDHMfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zsg8rXjgkZaICaBAi/JHKOJRlYgFduRh6Q0Og3d7AjI=;
 b=QUvPvsEGchBBswjhCfmolB10eodU6xYN9tcsfmkVw9eP6RtuogfTL8hlcT6p6O7o19zRRP8KJFS+PlsOVf29fE8GA+BdAzv3dun6OHM/wMvbaYIYl35+abvUoHVOJSzVXYeoHrqS5B0PIGlorcGtnDF5PC9jpOmLvl8jDdOQDCcNoDmBy+DtsI2X0/Dtmk2Z62AVTo0jnMZaW/rfvPb7FwPrN2aivzq7jUpSA83Ettu1PbVQvBrt59hhcbpMjX0E5tpMWMuGH83KFFAI57TGXtHjcDDww/udrXuqLBwI7nTqdYpQUKWIEO2FpjbPEkykQqV6BV103e/eMCwEpFkoeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zsg8rXjgkZaICaBAi/JHKOJRlYgFduRh6Q0Og3d7AjI=;
 b=mE7wygpB27WfckjJRNUjmE0GyD3wh4k4+LMmXcRImdduGwrmqWzonyHMVoUmIiBgK3/MRlo+OsCUOv9fqsF8L/4XdEi4vo3D1t199mgUEdVjOrzohZ6ztxGsyutOFm3h0IuY8th6L1ZSpfR+4X67G1AdUX3dlbk+ndnePVbG3XG4IW53uRqSMpPAKExFtcWCXM9Vj3vdGHDCMrSbVLClHT1CXZUDRCFor94umOBKvnSvnrjdJ53411KiDD/WIJVu42gKtQyv3X96XDZCwxMVWyYBBqjjz2l7WnBau9A0COB8TNt5GopEY4ztFnTgsJc+Rg5ikwTEb3ZRqey2g7dpXg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8527.namprd12.prod.outlook.com (2603:10b6:8:161::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.12; Wed, 26 Nov 2025 16:55:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 16:55:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] mm/huge_memory: change folio_split_supported() to
 folio_check_splittable()
Date: Wed, 26 Nov 2025 11:55:50 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <7E76988F-A17B-46A5-8121-9D348821AC3E@nvidia.com>
In-Reply-To: <e545a153-bca2-47fd-a768-dc310977de15@nvidia.com>
References: <20251126035008.1919461-1-ziy@nvidia.com>
 <20251126035008.1919461-2-ziy@nvidia.com>
 <e545a153-bca2-47fd-a768-dc310977de15@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0206.namprd13.prod.outlook.com
 (2603:10b6:208:2be::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8527:EE_
X-MS-Office365-Filtering-Correlation-Id: 659ce207-dc3e-4e31-16a2-08de2d0ca971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+5inXZy8mJBkTDW59sZPo/mcuuX+r5v0Bzxwa+LP5nOic7CpSlS8r6go4Moc?=
 =?us-ascii?Q?6FYz51k+Al0i54sWfKnnXHYLM27FlnU4FFZKHMmz9PtasSUU7O7ikU3E1+89?=
 =?us-ascii?Q?fNJKhQXz88Icww3XhXql+6FmZnVe1CcvOqj5mYFPEfVOAzpO9fRuJ+Wy92bs?=
 =?us-ascii?Q?F/lE0so7l5IS8CB0HYL9KKz8MOl2vvPLVxYuEhrM7xeqc90D/LTrYP9P87gw?=
 =?us-ascii?Q?4q276kwJr8oijUSeIU69J6zx+82oBoDdXzcx/2RHo2x6kmEgIrvNqa8LSqrr?=
 =?us-ascii?Q?cPvrYuTQprT2eFp1iIVRfey+VH5VlvJsbFNByRv150ZkCHhr/5q6zxB8V9tV?=
 =?us-ascii?Q?cLMcoDNytIA9ZlvU7LovT4DuyX1Znmgu+IWIxp3f3XYbpvhZ/DjRTyfmsZWD?=
 =?us-ascii?Q?rpBJNCesd4mWHrzSoRUl6FInTWB4hdCBvWE274aCeY2+pxPbdbdmUNZmY4yz?=
 =?us-ascii?Q?2CEFmvk2nW4TaqFCB+oXhQX9ZdYYtKZviZO5nsB5PBaTxa17qQYk5UqqAY/c?=
 =?us-ascii?Q?F2DhSUv0Zz4Rs0STcBVi0/Iz9o5Ya7hGkROOBYlzFA3OOAl2rrb6QXtl7TGX?=
 =?us-ascii?Q?KvQZScnt8DrM6HcslsCicD1ndkhL7JO6TIDY1VdmAgIjgsdif4pVumtUOkpw?=
 =?us-ascii?Q?HN2I397x7xTxmxG2vdLLY/ZyJYSvLwQSbNMthq/pohiD+zu8m+Jn1m9dghWi?=
 =?us-ascii?Q?cBbpBAXtx27fBahJ/9S4z3qzVKB9qY82sp8Kn7aZoQX8qGHGsiVCED+cXaZu?=
 =?us-ascii?Q?FpZaSP1cot9N8DBFnFDoWPxatHp45MOTuGnTy3i3mu3gfupM3pgwHCiKIKT7?=
 =?us-ascii?Q?eP1jekzs9k3TxJBtDg8wUtsRxJj6DRulxxwjNyZTwQhGMx600zShWrBz/FHH?=
 =?us-ascii?Q?WLiIyRk8hGzGYV0a7/czKgwnD9cDhDoLUspLqUF/Ar2pxB6zfSU55OjI/s70?=
 =?us-ascii?Q?OWrqmzQtC85MeDLeYy2VEaGOGLhu8taiAyo5WLhTd0cFE+FVnEv0cOGnwEum?=
 =?us-ascii?Q?XDJ5cBtmUgaVasL+NZerkaOeS90BcjybVJsWznVRvqaytuNQ9vyryWDFomF7?=
 =?us-ascii?Q?bBuXYd+I8j7EL681/XNobbY8rWUznWGJjKenT0lnEyZQxSN6uqeOiO9EdmqX?=
 =?us-ascii?Q?PW51Pxr19OnEN+QhEnK+MBY7zaZWc1gxgxv7x78JvHx6D0YBp7fzYOAwSwpl?=
 =?us-ascii?Q?/cLFas0Oc/Qfv0bGDPTkT5CrwOfD9CSEkUTcxqY1heG5fDBscvjG4rwgDieT?=
 =?us-ascii?Q?dGfkQjmeaeBUNEsfDU7T3fhgYtTHlO9rPEVbD+xWCh4IPhFV8NLxKyzeL2Gn?=
 =?us-ascii?Q?uu9dZNUEhHuymrtgnAiKzLLd7+YkCAtoTw/tYgsXHSpA3MAx2Bp1pbYq79Gt?=
 =?us-ascii?Q?QfjezevZu2Bjz1UdL324FcCqH9UODgO4mZSFsNpef/XWVjQxCbxcDjwpZky8?=
 =?us-ascii?Q?b0kK6pDQV0v01OZ8as/jDn+bQ3eG/sku?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?of1zlB/lbL1U2oT7hD7L+6pIAIlVDB+gJyI4cgmQTRY19W6Dw0AtzfgNgYZ+?=
 =?us-ascii?Q?iDuBRbK6TpKI8uqAi1VeBgz8iJZRl5gjSLX3GPhmK1JdvAoJYWl5LNsfnFVa?=
 =?us-ascii?Q?KqToxdVCKWuxbbxaeYcZqwFWY/rBBSZTYli44hgIwi9qpnWmB0ulGPGfvXtn?=
 =?us-ascii?Q?gRkHJ8jZ3MzWiWFP8qNWNTEV1HIyEluKoAiB3t3Ljn/NVCLD728Jva6YyQrJ?=
 =?us-ascii?Q?NbofKbg49w1LD6n/yODXdss5u60v5H0GplD+zypGv7snxfjyUm1n0JcjbtoL?=
 =?us-ascii?Q?mcklZ633rhWzr2K2MGuq0f1U4nxtQ4xm8dQtvpeGxD/SspV7Q2QLuBvrS43V?=
 =?us-ascii?Q?G23erkugU/CcVVzz4gsPIH05QxuTbteaxp/bZx917M+sQpanA7YZPtS4koqy?=
 =?us-ascii?Q?2N2KXP69lfxGc5NE3uhogWGbBlNMVKSiyEtU2nMn+5ZRWHrudN/3jLMYV4yH?=
 =?us-ascii?Q?myKWVcue582ap1TD6aDwOAJJcK5oGz4bIYrHytE+Wl4TF5UnKXVHZiZV4rnl?=
 =?us-ascii?Q?uxf4b9GtiafvkMzawsfR14o4YsLxsXUeOUpo4BOuJaI7qLjH6JTmGUWrKRQ7?=
 =?us-ascii?Q?6dQtxDlcwJL0t44J1gHwlWUlXSd7ZKG1+86JY1XbbYGcrVIxy759MjKz+3R5?=
 =?us-ascii?Q?eKYBCHC/xAYXPjuPL8YT1g7i6vGtLQZunhtNN+HrOPa802VtRCITzAPAlQg8?=
 =?us-ascii?Q?h1L39ib4NUY1YY3KwGHd/cDYGYssBytsFoJSMeQ2c0yLud5tw3gfQLu4hxYd?=
 =?us-ascii?Q?G9Hb5lbswKWXhmm5///Xp2ZKuY4C2x6jFK+/MAjnkSkqYtET/sPk6Eh5YySM?=
 =?us-ascii?Q?2FM4pSb1Xtd8EZVhWSDrY9wGbmEKRJGK0lM2qQW2e2UtfLsxYfNSfc+bGwDU?=
 =?us-ascii?Q?YYqolwnHsC+S61PfUD/FXQxfpuex+YaFm5klBVA1FFoiH1ieRVSGV15hwg4i?=
 =?us-ascii?Q?yZJjfrEJWhHpE+czTwMVU9qCJyLppPPcgjbipMpNr/zxNCFpuwHcY5jx72fX?=
 =?us-ascii?Q?xXJXN8+fj4QQNtPcqSxlX3snJSSC/stgqxDyFJ+8sFA5oLmC14WC3uvjR6RD?=
 =?us-ascii?Q?37MGm2oGPor5xNKFv9EoKPu7XSs9KiUTHsiXx9GVWHEjLhiTPYShTzQJuDhy?=
 =?us-ascii?Q?XgQIfuexMsTgVpuUpRiubVU+GyxcuoRXfd/j3yTY9XbIAOyz0Mrq3ILMuzM0?=
 =?us-ascii?Q?pPa+FxXDg0PQ0vPbb8JIWeQ8XnX9IuzSt7vAEAGbHV9XXGpbyEpRVaVQviaK?=
 =?us-ascii?Q?6BANFsvfHpg/VxMyxz1V3PqZIxNU/kTk2f7qws0RZm6ofFe4dbRZCPVUKlA4?=
 =?us-ascii?Q?+E3VIkBM/QgHZyqTbUYH2m/01SRyJcH3RT2AZPo0q7e4n8bGUoGWK5izbJMo?=
 =?us-ascii?Q?bsS7x2mKAueFsH+gzMHK322cQUVRV7XnPvOuya91qto90Gp21aovySMJJ8Af?=
 =?us-ascii?Q?YH+s7VrnJKA0AU6A+y6UnDDp4vpuM6Pt21P5h5wgADYmnCnS3anklx2OCSCq?=
 =?us-ascii?Q?HInTbIVVTDj+JlTp8CLLervkV+q+DXfCHaHEfnZYAMSQPDnOEQeRMjM3XqfY?=
 =?us-ascii?Q?dbjQNbjmR1UFRmZdSt71WrwcR9qawhEpAl8AKR3c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 659ce207-dc3e-4e31-16a2-08de2d0ca971
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:55:54.0347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZE1YSqg+qnKqB/IGKC2BW5S/ZqCUA1sSbCr2VqpMiI5N9d7Kw2rGQriTV1qNb24
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8527
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D84DD160017
X-Stat-Signature: hqugpunu4itgxfk9u44xjxobop99pmde
X-Rspam-User: 
X-HE-Tag: 1764176157-772466
X-HE-Meta: U2FsdGVkX1+e9Sdc37t+IA0fbwkWeoFGXjfWZE6eOnYAmu2OhoVE4rRRtquk2YTs7UUged+h09ieLVhPwYoF5BSLuenUOElJ6wrfHBoREmgHHCc+qpwZ0OVG/689XxfiSGZ7feGBDgHe+w4vwIUpDGFfMrVAxNmHNnLYKceEBPC3/mavYn3/u3QDYN4uRR2Jcbe6IdZQXTXMKtsADysd2VOIW3xqnH1f4PafU/ySjyM+sQ2KkRMPouXYiWFgK85OU5oM1EmEg7zVi320s3TqgGIWqs1ZgcjngM/36Yc2wy/+n3KD/noNhAY6mNGUtgaL/27P9efLkhY2uf/8CXZwlfG1jP9OhsqlyFpTJ33rcSHfYfFIJyRCREzeP1SUSnQIijPmtk8yF7ZP9a2Q1w9eaRMTR8veEGIWK8jEFfT6altEdKt5kkZQOQiIm5HKkuuRMFkNrbUjesWonLXbR/GN/HvPGo0X0AS5G2+B7fpncqRaS5WR1ZNKEMSNp4oNetGYZK8tLzzhiQIOf7atk7cLIclOxP7VTOdcPbp2/FBAqT3Pe8ASiW2SQ5+GvCHgiwL678v/hhTvQ1F2aJemKRchTWUocXap6XXKBQTUCfdZDGqT0RX4/sCo1dvUlC51EtQdIgtRzcVpyDfyKFD3ffP3H5maO+BypWT/X82kOOKcKV5Y1pqtnM83dfq9t8QB6KgGF9JTohrV9R1/KISJuH6aRIt7H9e7XtXoeQaaGD8XFKfVjJ+BOv1nMnHf17yNkxmQsU5JdxEYJbU6UNhBALmN+prW4szKNHhB1SqDaD86Nkwub6MVgeVqAHLNtWS4FseIY/dHuqxP93ZixegsRVEsLwMjP6T/0qtuI4oz+uoJ/OrBq09UVVV3L/hOka35EOZC863+DhT+g6pj0MB0y+lKSHZUMYTaMVl/HZ97PyJAHRy9T29s+ELr/fh8Wnc37f7xtDxD6foWu+snsT9bk9l
 RZy3BRQT
 WDcQZjtGOytXFWHTWHdPin9bB6dlmuQcI5WCxifrCjs67SiXTqKvfdXyYVryiT0WDK+1eA7wfVvgv0zY4TA9dbN6nlKzxG1OD4V/RK46EXGdp6ASWoZ0BL3JaeNnBilGcVEpuGw0y+eyWtDPr7IzlL5L97C2Ziyd3d8J/odf9omzPwr4NCATveNWZUMlZqqwFNkDw6ve8SrkWHRWAlMDjssHnv+nucnRxyfQISdjphvOIl8Jggs2wzYJGy1TtjMg55xsfTLk1pVNE26DZHx7zMeWDlEp0lG1eV9hXUWQIprwmAn8eyODofaIkfTtH7nCjHWb9C6B0E0IsBWzgIQfid+0DPd0dN4TWBF4oxkS6sy/dWlTkoJtfBCkjWKFxsIGVgS6okg6bRYYIOdq9TVRxBgffvfpwFw5DqkRF8vbLws77HwOMl/6PVru33FitX7JHlSvXPfLkHxRxEXm0IrO5M2szxewp7CE/Tfc+FmbNhrKBJnfQJHdbwHyT1QLG0oGzh9GayMv28SFsbp2B0hZstFZQuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Nov 2025, at 23:14, Balbir Singh wrote:

> On 11/26/25 14:50, Zi Yan wrote:
>> folio_split_supported() used in try_folio_split_to_order() requires
>> folio->mapping to be non NULL, but current try_folio_split_to_order() =
does
>> not check it. There is no issue in the current code, since
>> try_folio_split_to_order() is only used in truncate_inode_partial_foli=
o(),
>> where folio->mapping is not NULL.
>>
>> To prevent future misuse, move folio->mapping NULL check (i.e., folio =
is
>> truncated) into folio_split_supported(). Since folio->mapping NULL che=
ck
>> returns -EBUSY and folio_split_supported() =3D=3D false means -EINVAL,=
 change
>> folio_split_supported() return type from bool to int and return error
>> numbers accordingly. Rename folio_split_supported() to
>> folio_check_splittable() to match the return type change.
>>
>> While at it, move is_huge_zero_folio() check and folio_test_writeback(=
)
>> check into folio_check_splittable() and add kernel-doc.
>>
>> Remove all warnings inside folio_check_splittable() and give warnings
>> in __folio_split() instead, so that bool warns parameter can be remove=
d.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>  include/linux/huge_mm.h |  6 ++--
>>  mm/huge_memory.c        | 76 +++++++++++++++++++++++-----------------=
-
>>  2 files changed, 46 insertions(+), 36 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 1d439de1ca2c..66105a90b4c3 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page=
 *page, struct list_head *list
>>  int folio_split_unmapped(struct folio *folio, unsigned int new_order)=
;
>>  int min_order_for_split(struct folio *folio);
>>  int split_folio_to_list(struct folio *folio, struct list_head *list);=

>> -bool folio_split_supported(struct folio *folio, unsigned int new_orde=
r,
>> -		enum split_type split_type, bool warns);
>> +int folio_check_splittable(struct folio *folio, unsigned int new_orde=
r,
>> +			   enum split_type split_type);
>>  int folio_split(struct folio *folio, unsigned int new_order, struct p=
age *page,
>>  		struct list_head *list);
>>
>> @@ -407,7 +407,7 @@ static inline int split_huge_page_to_order(struct =
page *page, unsigned int new_o
>>  static inline int try_folio_split_to_order(struct folio *folio,
>>  		struct page *page, unsigned int new_order)
>>  {
>> -	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM,=
 /* warns=3D */ false))
>> +	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM)=
)
>>  		return split_huge_page_to_order(&folio->page, new_order);
>>  	return folio_split(folio, new_order, page, NULL);
>>  }
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 041b554c7115..771df0c02a4a 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3688,15 +3688,40 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>  	return 0;
>>  }
>>
>> -bool folio_split_supported(struct folio *folio, unsigned int new_orde=
r,
>> -		enum split_type split_type, bool warns)
>> +/**
>> + * folio_check_splittable() - check if a folio can be split to a give=
n order
>> + * @folio: folio to be split
>> + * @new_order: the smallest order of the after split folios (since bu=
ddy
>> + *             allocator like split generates folios with orders from=
 @folio's
>> + *             order - 1 to new_order).
>> + * @split_type: uniform or non-uniform split
>> + *
>> + * folio_check_splittable() checks if @folio can be split to @new_ord=
er using
>> + * @split_type method. The truncated folio check must come first.
>> + *
>> + * Context: folio must be locked.
>> + *
>> + * Return: 0 - @folio can be split to @new_order, otherwise an error =
number is
>> + * returned.
>> + */
>> +int folio_check_splittable(struct folio *folio, unsigned int new_orde=
r,
>> +			   enum split_type split_type)
>>  {
>> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>> +	/*
>> +	 * Folios that just got truncated cannot get split. Signal to the
>> +	 * caller that there was a race.
>> +	 *
>> +	 * TODO: this will also currently refuse folios without a mapping in=
 the
>> +	 * swapcache (shmem or to-be-anon folios).
>> +	 */
>> +	if (!folio_test_anon(folio) && !folio->mapping)
>> +		return -EBUSY;
>> +
>
> Nit: Shouldn't the order of check be
>
> if (!folio->mapping && !folio_test_anon(folio))
>
> works better if folio->mapping is NULL

It does not matter, since folio_test_anon() checks folio->mapping too.
I can revert the order in the next version.

>
>
>>  	if (folio_test_anon(folio)) {
>>  		/* order-1 is not supported for anonymous THP. */
>> -		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>> -				"Cannot split to order-1 folio");
>>  		if (new_order =3D=3D 1)
>> -			return false;
>> +			return -EINVAL;
>>  	} else if (split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) {
>>  		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>  		    !mapping_large_folio_support(folio->mapping)) {
>> @@ -3717,9 +3742,7 @@ bool folio_split_supported(struct folio *folio, =
unsigned int new_order,
>>  			 * case, the mapping does not actually support large
>>  			 * folios properly.
>>  			 */
>> -			VM_WARN_ONCE(warns,
>> -				"Cannot split file folio to non-0 order");
>> -			return false;
>> +			return -EINVAL;
>>  		}
>>  	}
>>
>> @@ -3732,12 +3755,16 @@ bool folio_split_supported(struct folio *folio=
, unsigned int new_order,
>>  	 * here.
>>  	 */
>>  	if ((split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) && folio=
_test_swapcache(folio)) {
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split swapcache folio to non-0 order");
>> -		return false;
>> +		return -EINVAL;
>>  	}
>>
>> -	return true;
>> +	if (is_huge_zero_folio(folio))
>> +		return -EINVAL;
>> +
>> +	if (folio_test_writeback(folio))
>> +		return -EBUSY;
>> +
>> +	return 0;
>>  }
>>
>>  static int __folio_freeze_and_split_unmapped(struct folio *folio, uns=
igned int new_order,
>> @@ -3922,7 +3949,6 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>>  	int remap_flags =3D 0;
>>  	int extra_pins, ret;
>>  	pgoff_t end =3D 0;
>> -	bool is_hzp;
>>
>>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>> @@ -3930,31 +3956,15 @@ static int __folio_split(struct folio *folio, =
unsigned int new_order,
>>  	if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lock_at=
))
>>  		return -EINVAL;
>>
>> -	/*
>> -	 * Folios that just got truncated cannot get split. Signal to the
>> -	 * caller that there was a race.
>> -	 *
>> -	 * TODO: this will also currently refuse shmem folios that are in th=
e
>> -	 * swapcache.
>> -	 */
>> -	if (!is_anon && !folio->mapping)
>> -		return -EBUSY;
>> -
>>  	if (new_order >=3D old_order)
>>  		return -EINVAL;
>>
>> -	if (!folio_split_supported(folio, new_order, split_type, /* warn =3D=
 */ true))
>> -		return -EINVAL;
>> -
>> -	is_hzp =3D is_huge_zero_folio(folio);
>> -	if (is_hzp) {
>> -		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");=

>> -		return -EBUSY;
>> +	ret =3D folio_check_splittable(folio, new_order, split_type);
>> +	if (ret) {
>> +		VM_WARN_ONCE(ret =3D=3D -EINVAL, "Tried to split an unsplittable fo=
lio");
>> +		return ret;
>>  	}
>>
>> -	if (folio_test_writeback(folio))
>> -		return -EBUSY;
>> -
>>  	if (is_anon) {
>>  		/*
>>  		 * The caller does not necessarily hold an mmap_lock that would
>
> Otherwise,looks good!
>
> Acked-by: Balbir Singh <balbirs@nvidia.com>

Thanks.

Best Regards,
Yan, Zi

