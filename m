Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD0AC9830C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 00:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240886B00DC; Sun, 18 Jan 2026 19:17:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217C16B00DD; Sun, 18 Jan 2026 19:17:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11AB16B00DE; Sun, 18 Jan 2026 19:17:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00F786B00DC
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:17:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B3CF8C152
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:17:50 +0000 (UTC)
X-FDA: 84346800300.12.7682DF9
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010048.outbound.protection.outlook.com [40.93.198.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id D1B6140003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:17:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GwvgCxUX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768781868; a=rsa-sha256;
	cv=pass;
	b=5HMfnzSbjJ52vobnQEU4tD4+u9bh+b6AJWq8fImvXSRq4rDj9R/443Q3ThZLVHaGj387Z6
	IgiyPNTlibXi5+ZCToSfqyqDvB9IWtrBARMsD+jUqJ9RCXWnm0BlCDYKnwfpZFGfpX686/
	OPfaAgi4mYLOf1Fhl/urOtJtfLs6jLA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GwvgCxUX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768781868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tU9tGy+3q050H1vglWCZp7NzXwL1dlcySbZndy0NCGc=;
	b=TiEVQXyp2BdmJD9qoqbYMCBwV1hr+rn7BuisXmDvWKsSZvRxUGxJcKucNOSgmio8SvxEpr
	azpUGka5/m4BKoktElSCZ76ktmcnqGk/a4kRmGGh8qa1se10qOysfImIi9VHZZoVwkopC4
	8OxeOCODUDBX4kN24GjVKqy38aPBbl4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ogTFL/U/uU5nYTMQwqk0aWANmO/rVZFePSopI33kiQV/L0xIq53POHuOOSJn3pKJyiLrY1shEJCJ8KpWyrMm03dUk2mRX+1TM+8A8bMagVf4dV0XTQEwr3ie1ZPMoFwbYf+Zqmna4QVCKMaKS0E5eWJrD+KXwE8eFXxTcsOtBfSbUHzF6OIGuQNdFEW3gEhABYoAdaU4KUjgf9Gx6BGZ0rXbjrr/X7CTn29C0Kppp4j0gTMsSq9vnoe0OfCPBc1RSOz38PptuUZ3wTG69SBLVy9HBvm0XfosDW9mY8BMchIU992QgYcgy1fJlyrgp4IXU66HPhbJ0QNPPcxgW7Nkkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tU9tGy+3q050H1vglWCZp7NzXwL1dlcySbZndy0NCGc=;
 b=fTpqmyb8H2mNA5r1IW0SCxUxlGTbp8WRsmq4QdQklnYsL4W8G+2LnCN9bOuztvrerU4hD1G9fODJksPx46QSYT1GJT0bXbW26ISYDmp3OF/OryDhNelcsCB+A0qi6hM2EH3zQwomlqDrTgWGDBGlXAZRaC73WHdaQB2Kgh3pco40hcW9neMpjqth9g1cjjdPgRl6w4e1veEC+1V3xW7TOzciQ4HLghdASwVHqW7qJ/cHSHaeNRcU21leAvaNI5wnMsv29Mx5ldaKQS2sjMRVt5p5iDZNAcsMNYKmIGdUqkE/9oHdb5uYH2b/uyHgg2Z9gf+MB16xkZkLFIC+QTo5Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tU9tGy+3q050H1vglWCZp7NzXwL1dlcySbZndy0NCGc=;
 b=GwvgCxUXIlRl4tsqngP8J+0BLniVmz+C329VSTr3Uo36YLk8mx8+xXMqSljYbhK7EcnoSYAEHtA6lSoCCZckgLGD3rvjpNGtF7PnfN+AKKYiVTX+vD7mgv+1CmEIxuo0ALYKGqjh88tNlvPrpRxp/0UhK16nzN+Yk50qiv7Wp4SyImEIoSbyI+pk3x1P4h+nEwlFUuXx6Op7o/9/i+gMArjMBS+sLkjXNhUFIaOVqgfRy8RkSI6DHAEhLxJ1EDq98l2f4QbiV6PmC/+XCi7EgPQN5hy7raDA50kMvgwb6IsF21FXGaV6fR3cSsi4lCSBJRKB0hLFrCAno/K4HpXaKQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.11; Mon, 19 Jan 2026 00:17:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 00:17:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/5] mm/khugepaged: cleanups and scan limit fix
Date: Sun, 18 Jan 2026 19:17:42 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E560B4E0-68CD-4773-B35B-30745D56E8B3@nvidia.com>
In-Reply-To: <20260118123442.f55db3e141388836df0c7785@linux-foundation.org>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118123442.f55db3e141388836df0c7785@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:208:23d::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 95230391-29bd-4beb-1f56-08de56f02a71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vvvyfrmpl0eey00vVVlju+XcX16z/H//C2zvh+Zt64sr4tWs4q+1ivdb2uzb?=
 =?us-ascii?Q?icqz8Dxo+FpzRGvwYFoSzejXtDfuv3vMBIIzeDN9LqFlmSs3h9GHlOn/3ZF/?=
 =?us-ascii?Q?YgwrSPSYqWTcZnplEhaxacjYpwGawhrIdq9958xLWxc06aH5Jt6JH53vsL5N?=
 =?us-ascii?Q?4rP6HcdCytx6hp3k1Vjx9SsFfIkipfGJeQZDS4lwPCM51s4t0bfm1RChiFKy?=
 =?us-ascii?Q?slee8pZ+67SPtl1JqGVVp6LFZK+d2Ja2AY6i7ZkN8jR6AAJvcnbLszxOdmTg?=
 =?us-ascii?Q?wCC0JU/JONWBMiTERbTm8CZKSiCY9O5c+pyTia/7MGM9mJgRArfy6l3ddSA6?=
 =?us-ascii?Q?DrjlXudLPjkMItksGXsgWCVezfW2y7pN1nUOb/gWsV5viGLUj9abH2r8bQxZ?=
 =?us-ascii?Q?k07mwmhHH6/xG114jsRigkh+Nv+qUxzr2oU2SEmNpVZV0rdQjveaaS8xtYa1?=
 =?us-ascii?Q?9xHu1LBpSRMiGy0sWkqBlAqeLdYOtzuDaZnhBzOtPKHqR/3x+dqTdqgRgAXV?=
 =?us-ascii?Q?MtUvCKK5H3sCw1uDFCWE6kOMGfRwMshDsRStoaNNOrMcELhFxSW78CNI1ean?=
 =?us-ascii?Q?SgPwlMMOSd/HN25IINYa79stdLvR8zttPWNL+fOKX4s1mOIefgdQLy30FxcL?=
 =?us-ascii?Q?kt+CLBPFOIxLzPz2E8pq9Tf4ZHoV7nrm+GZc5BlLbuHG+lkvZ8phcPNGzHc9?=
 =?us-ascii?Q?I5AYnuNbna1cIV3TaMXJLYUzYjzFDGKByn3smqcwjyhqJ/V3U8QgrBhqAI0o?=
 =?us-ascii?Q?tZC2cOP+4BRnTRJN0c4TxgHfMiNe5YcOhUDWp0bnl1c3L/V1SfqYs0eaJG53?=
 =?us-ascii?Q?cgUknQBDX4Hdz/rX0K+ToTDfiIsEOteQP6xbV8PN8htm+rUC12E8SupXZmDd?=
 =?us-ascii?Q?+3EbrqDYw2Sh8nAAx9GwLGh0xRTS7KN4XgWyuWVhfH7itkD/7V6BAHAfEM6y?=
 =?us-ascii?Q?YMOkzk0wkMvkJiMFojggCcxF5roalvG7ItQoPmJ2GMBUU+LnC4NrcH4cu5+4?=
 =?us-ascii?Q?BgjDYz3AVGZmngMQOU5DzrpKOrhPqlpKWzsqBYt6S9UCxVnCrWT7btfEgQ7x?=
 =?us-ascii?Q?QKF2zqBxKTkpvFfK23AYVsGSw4caUxms+NmKINEI9ZDAT2uxSHqaz4bljH8r?=
 =?us-ascii?Q?t/DqH6aeRY7frhSrakurSyMzHn6NtuqwFVYYOKj1kBKLFkWLSZUYHZK0MhXI?=
 =?us-ascii?Q?BVk5NQX8ik8TsbXh/UOjQNK7W97AMYBYbMszfAO78XlxRH1DaVgrLmgG0Iad?=
 =?us-ascii?Q?pFdsfvhJnwlLpNZMSL1NCahps7L0lVhxgB8zgix406WZPRM0nJrqgZSI8cvO?=
 =?us-ascii?Q?jUgAsA/9ldoR2ygwM+gr6STobktjX3JjPMhyRNqRftRFqO0YubUOG6QCRXYb?=
 =?us-ascii?Q?b2cS66PzjquVZ3dudW7tS7p1HU0AQz+MVdfPM7ZbjndHTJz4TL19GrZ6nX3u?=
 =?us-ascii?Q?I1e/+2gasVNqr8UcLxd2DGaAdNHa21EPj7+VHfuFa3Z8YaUTfQg7jag01VTP?=
 =?us-ascii?Q?9EnXzB0036pbeikwJ1Qhn10dU1ERn5J3V5QxONuc3hakD5znCkkHBjBNq9ME?=
 =?us-ascii?Q?u8Yqg3rRH0MUkA8tuT/6jh6ayY2XBRnBlfMYyCr7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pPi9Grurqlp9q6xo0pBco5VNiqY113QbbGUMmG04SolgHFzXSqQrPoNx72iN?=
 =?us-ascii?Q?TkEXjI/x8vlB2IBogFrq4pYY15VbHYNlTUiy8jhlVktPjm9980nl2aZ/popE?=
 =?us-ascii?Q?Xy3AVL4+W1cu+qhyi7wczPt4DPTIfQL0F/P/ompeIsNzYCBjDFYjZG38n564?=
 =?us-ascii?Q?WmVIrnFigUMKkmriXI1MlBFT32J15IPhm5Y4yzdhSWIo0WSjDCMzXJprU84w?=
 =?us-ascii?Q?CJuPQB/bQW27oiKNe05wAc1eODS/ChKwUY3nGCvF8I/FeF57eWA9XWdf4Jiz?=
 =?us-ascii?Q?wj6pfNO0NeZTjyMfPdeGfmWRCzX4mhmwRtOzO5mIUHqkYjdNRpBfZlE1ZH5k?=
 =?us-ascii?Q?Ezsiz1jDHDlgAVyaQemNkG0hxm5j958m2D53J3Bs/H9kDAclfNfBxO0zhCPx?=
 =?us-ascii?Q?gy5PY6JkJnWmuSLlvtaGdvXUEmF587VGLMhGLEI1x6aDeYTu3VlpWSyZDvKi?=
 =?us-ascii?Q?DoT72/uc6MK3NjL8ObGaAUBUv1gARpbjAz23L8+FtdmXXYBBw9IBUSftiZnS?=
 =?us-ascii?Q?cINUFqPwq9hOKijdS3wxhApjU+WXAJ8T0OC6igu7xFlApSadFRNw8DzB80/l?=
 =?us-ascii?Q?WvnvY3mvF2N/aS3y1LMQsFm3aYROVYTC/iidmtEurEvfi/8BJ3Uu20UxycuI?=
 =?us-ascii?Q?i5oRaeqQt5WFCi6AdyA4/tokR/r2Y+IRHiadcEWFbMdPc3o9eCe2/wo3PJE2?=
 =?us-ascii?Q?jHcU4qo6TIXxeCyKy07S08Z7AcajDByPUU8erEm+32RWfmamF7G4Kwtxv3OG?=
 =?us-ascii?Q?PbbZaqm87Sy33nVnzg3xYTfXNB/fKJF9Zbq+H9RR9WaM1lbhaN8jU6dVWoKR?=
 =?us-ascii?Q?ih1XkiE5eg0zozK0SHAdvsSAvSUdnJbOyiqzmWv6JqMrjs+6DkoVeQd03Ovo?=
 =?us-ascii?Q?sw1CFCZiRMht2KKubFiCFRZp9s6qTxzmLFE5n/WMGVu0iFjDWyriJJdP2fRr?=
 =?us-ascii?Q?FFIRijZOZye8GAMxVBTAtWQd8qoHHDZcqg8KeSDRj328YguF1X8ogV1SrhgX?=
 =?us-ascii?Q?Lj7AIKkfkjIqwe/ueUBFtKU5jwm+KyJTz1KUizcTDWGhsklJfRJ5oFMJoN6z?=
 =?us-ascii?Q?x8sIzQEaxqX7IQnUS7UY09SaoXclzpWGW/QNN9qS9ktVi9cvCRH9ETUG78sx?=
 =?us-ascii?Q?BgJLuGplCquNuLyaTaipypZq6Rqx/+nO8jaN9WJwRRuvxMtxaS8QUTtCWQ1T?=
 =?us-ascii?Q?b1/LjLQuTUg/SBGhyWcuugXv1eJyWKB161NIR0Nj1Lkn9vP30MhZAglXK2xi?=
 =?us-ascii?Q?UsDuWsHgSkVuqRErpO5QEpcYI5+29fvPXgEhADExrsvMpEG0AI3KCBzOFXHF?=
 =?us-ascii?Q?R72YQZoryqv+PKvo6oNbFrz9qtvRGAVHc88vyL5FjYwldao+qvbzBdJr2uHd?=
 =?us-ascii?Q?YoJCFGgS66Ng7LBEkpTGl0qUYVZnemsecGnsV8Am2jKJ5zE3KHgiY1WZYm25?=
 =?us-ascii?Q?EXfP8XsYMp5mXWcaPrAADZ6LSVl3FIy8f8JUdDTJPPC4o3ExzYFaJJ6doHo1?=
 =?us-ascii?Q?3YqBDL+XX35LkLBFhCSeKAKr9+DkPbrRHw2JL3Q2A1UY6SZ8esDDM+71VV+v?=
 =?us-ascii?Q?aH1SpsUePGNnjgQcKchta6o7IiGgw8bf0FrOFHf5BFY3zZp0dBFuPqI7zFiS?=
 =?us-ascii?Q?cvi5GjsvasOwOuwMm/AnzQ520No8GDnZP5+/KBcd9oGx+n+l4a8SklkRMHDA?=
 =?us-ascii?Q?weS0vA16nmROLoPA9KmyBEGlJV+6y8jEq3PNtrlTYBFiSeZE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95230391-29bd-4beb-1f56-08de56f02a71
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 00:17:43.8507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5k/G2jZ0GVthtjszFnKpVgOhRKdu4I8r2IeleTluLSC8Sj0odq3FAvlinTiM6/3+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Stat-Signature: wx9c5a7pgq8bsoonf9xrt3y6x1i5ukg1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1B6140003
X-Rspam-User: 
X-HE-Tag: 1768781867-756460
X-HE-Meta: U2FsdGVkX1/AnD2ZdhBFVstJPEsLIAqdNCqNu2MOrFMRDSpR+gMFbpOwTHSJPy0XO0Jkic5rv4GiqQ1OC9X5xrNKKFAB+Ch7Zdvu82Zch8mP8lDJJrfybtOCqy35KBQxEG1HK0OTgOJBco9GXt7wu8Su2da31lVtWhYycQQ94IdyRUItmoeZ4WV611vp6C/Ex3t8D78LvReeQU89bKfX0N8717kJyniWlpyN2Wsyo/qP29hRNrk8uvgdBz1dFCKvQXO97lzRUObIJ75tREkxSu6jFJ9emU+uXwcwUcjEIdp+DtJUTq0RGDuEbivr5OQdtThbqD586Fj1PedrZCD/W0gPq4B1ozD3v0rERvf8zq0y3FFJpTRjO+5JJjP6HQ/CDzScIthlTP7AdZ+ZftKiiw4gFYhE7RhfKtiqUUnJ6IITO2aKHmJ48DxWirYLNTxZisEwZVPnoZnpA3GKsqiFcUQpXQF5+rETmOmzgrLuEvTDGn7ASPoy/tdRjaaGkfDrPF/xxozOKCZdziDaYfWb4OLXpdHZsigcv13LEjLIoPE/zoaNfSXzj81pWagoY1GDjmn/WLUVJGC8GV+5Mb/Cgh+nRw45x2ql5Cn8jBihmvLjng+MALOoKoY4fMhlL+SpwwlnJu7NkPxodZx66ua4aD+gtOJQjFtE5T52L+6cpd/5r7VnFeMISxHGDEgmN1qYT6fT3B6zKYF3Mr+vt7/W+QV36y8lzjUO0DzLPvrP+L/ICK9lvKzu6aVkTR9z1496nX7f2llawaBXnr96/4wZ7vE2sjrwVgLpzlAPy2X3+zANIlfpPcbon125qwDJqqTkn2l6j4q4+o/s5BZQritR64ply/sIg/MD/dma/O9Urz8gkx69BAROrzmagAZUiwy9zTs9AnpHNcU6I1oNDbkdWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Jan 2026, at 15:34, Andrew Morton wrote:

> On Sun, 18 Jan 2026 19:22:51 +0000 Shivank Garg <shivankg@amd.com> wrote:
>
>> This series contains several cleanups for mm/khugepaged.c to improve code
>> readability and type safety, and one functional fix to ensure
>> khugepaged_scan_mm_slot() correctly accounts for small VMAs towards
>> scan limit.
>>
>
> That's a lot of changes to a well-reviewed 24 day old patchset.
>
>>
>> v3:
>> - Fold mm-khugepaged-count-small-vmas-towards-scan-limit-fix: add comment (Lance)
>> - Remove extern and use two tabs indent (David)
>
> Are you sure?  The v2->v3 diff is large.  A lot of (unchangelogged)
> alterations from `int' to `enum scan_result'.

V2 has this change[1].


[1] https://lore.kernel.org/all/20251224111351.41042-12-shivankg@amd.com/

>
> It all looks pretty simple/straightforward to me but again, can
> reviewers please check this over fairly soonly, thanks.

I have reviewed it when it was out last year.

--
Best Regards,
Yan, Zi

