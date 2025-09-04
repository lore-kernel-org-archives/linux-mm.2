Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497BECA101C
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6EB98E0002; Thu,  4 Sep 2025 09:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46C28E0001; Thu,  4 Sep 2025 09:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935738E0002; Thu,  4 Sep 2025 09:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5168E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:21:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3730784CC8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:21:31 +0000 (UTC)
X-FDA: 83851629582.25.C394364
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EC57120011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:21:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Oq3c5gxC;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.74 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756992088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMqYG2KyVOW8jqus7gOLWxPeGNzP+GYnML2NFZLUd6U=;
	b=ztDPAs2lp0aa9W5nek96AXwCUFJ5aNRpWDJnXNywuvcOD9PGYd5aUGh1YmP9AiZgam+oBA
	o2hrdDrBV9bKKi2hpRQFUG4ZU2slrweixrArne6Ef2ZRISORbKL+ik+EjkRZa5OgReXu1s
	jtI/yov6pkx2n+lnOUftN9eDtGGlJ34=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756992088; a=rsa-sha256;
	cv=pass;
	b=hGwdbBpSCJkV3pko5o1Ph+1v7gHMtYKxtaW3lKDSmH9ny4afiSKtV7biPsMRZejRkkP3uY
	3DV3v7ypebWaTOIp4pTG52TOTWa5yA6kwl03/iUICo0zIXq+D1ywO1z8NBE1kWmBJ2maF2
	eKci+izy4zey4iNvvNp1tPAc4+878JE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Oq3c5gxC;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.74 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fJrobyP/AJd6K81z5+mAH9mWMNfahdj67nkY/Gf/EmtIXLThqj8IX/gdXRPHLC1nc5IQVkwe9w312tvm0+JYlCVC4+rBPPm8piBCZNKz0F7g//dyuP0+b4A6ZRieksi3YnIOEjStLw6mnwMq3uBYXbMHGBmdv95F0roYC2iAEdD1bwjnP2XDblscLDceiT2heBHcfKZ0BPrT2Js8n5vM1tjG7Bi+LN2ymzBVwvtk/XBk7msYHhlCQNr1x2FpF0e82NqibEqznLS/eFzRoHXKM3SBwFC47yEcn0czS3r0uE9mX1+9YmbFayIy5A2Gti8JtncqVGiz300AcJBomkvVMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMqYG2KyVOW8jqus7gOLWxPeGNzP+GYnML2NFZLUd6U=;
 b=ZSjXm6/2y7JuTyjJ2watF2DmBYLGtz8JTEs+FRS0wAc5UOwQXXfJvW18FLYetyPhj5VoZy5r+rqw7SAfiIVzsqTn0e0yC+qRGS705aiPLzsOVCcNbUJzevbR1YxiiwEV4lNJEyZ5SH/mKRZQwSikFGGLQeLQj+udYDnx4CruLuI2bd/Edztvh5bF9blc1wHzx2XEM+5ylULHWOByIPoA3TBaiXuaUjnCDW7KIpSKGtZFuwGCMxthsptjasffHqJJL9PQ7yO2EIeMxZ/8ER4vmnOLDfmmEdlarifcOs99As56cbUuzS6ULIqwH5pUA4K+gBLVkrTTh9TA0CNoW86aXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMqYG2KyVOW8jqus7gOLWxPeGNzP+GYnML2NFZLUd6U=;
 b=Oq3c5gxC4MnScUr+Wdea/bbhDCTsj3gyCatOhGMHhJBgYtNg5LFyTCX2vYCxNEbaqWfSWtpBv5VbYRZFKqyvytCRc4RHhU/2Z1fxRPEA8H9/66fjmVsZ9887GHqXu24OXs99XdV1OQMvJ+cZyVRucSJhI6cIBdV7sRXWGT84oMtKsRW15PTHwIytKOQ65Qe0wRQv1HFby/J3eWVsN1PkW00qwY/Q6+WAWAeywT/O/gfDL8l/yBZw4f9oj+G9xjpJ4c2y7sZLUte9NvmSk75yTOA7KRMIWfZMI1puHGvC6+Z9CQUYFsid26Fv0671ppl15QXoXbxLQFU/9cCNfopygA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9122.namprd12.prod.outlook.com (2603:10b6:610:196::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 13:21:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 13:21:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Date: Thu, 04 Sep 2025 09:21:20 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <74886543-6038-4444-8E2F-3F3169171837@nvidia.com>
In-Reply-To: <20250904095129.222316-1-kernel@pankajraghav.com>
References: <20250904095129.222316-1-kernel@pankajraghav.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9122:EE_
X-MS-Office365-Filtering-Correlation-Id: 153265f5-48e9-4b06-c487-08ddebb5f176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6lx/jrmREEgwtUke19I4n8rIW4JfLaGG0vUM4qsB5QKHCaGDlWSHAPfUp0ZB?=
 =?us-ascii?Q?nasBLixtWj3RgX3BJDbWevNZ5rpOmPfNTl2L9r+vq1eQvi34Sw0DnCAoXq2V?=
 =?us-ascii?Q?5X3yTCPbbkTX3S8N3gmmJXVvNpqB3/HXc5IKC276wx1frTDth65kjI7IJHI1?=
 =?us-ascii?Q?d8RfuhUfHpHgHiEp97p9wIRnEXGyEE0uiQmjok0sQ8GHtaoE9tc87b4nGlPJ?=
 =?us-ascii?Q?ZH+Y550hDWHhVDH1z+1A9mnOb6SFCG8nUOGRQ6GAnmKeJb2yq50bAEeaNs55?=
 =?us-ascii?Q?hQrBbFT31cp5iBJgotuMfLkH0xNwXD7zjTrvcTnbt19MJMP5daqZkoMmSSTD?=
 =?us-ascii?Q?qAgIPgMf2kTJ9m3q2aUcyyoFBZDNBCgtP0Weu3QrePgNXjh8lqYSBw7yWY1Y?=
 =?us-ascii?Q?ML2elXXLJrpnGJrkDjsp8Ea0NmrhKZSmioxWD+AYSYbuorcXwxZjKaaWCUfy?=
 =?us-ascii?Q?dackGgaTmnN5NU3AYgo37phf3iOLbGyWEKfNQYofBDaj1LA4Q1CSuNRbqRdC?=
 =?us-ascii?Q?Bib1MH0DCwgwkEB+M1bslLnr0i5rSWNvGDaNuac3GK8/Msm/3nHnG+URR5aM?=
 =?us-ascii?Q?1ennNjQsNDQdtCNMyxUiggvVFBjQjF+mRZX2e9RgcHMoNC5okQHy3rFxoCDU?=
 =?us-ascii?Q?iI5qPBGukNOOsO+FgGJq1baC1mh+QohYoyaPx2LX57L2nw0dqJI+96xPKYoE?=
 =?us-ascii?Q?aLXdUxhaFx8DR6FAgVe5LmYzQJ+Vq79FhH2cxhP850Uh6zUJ6hzaYR+Wr4XT?=
 =?us-ascii?Q?IzVWZs+mYSgdWYufu5K8QOwwCEkjIjNeGuHroCZEF1XwfgZEjOUBA0D9XkEn?=
 =?us-ascii?Q?KkruTWUcBLy+WbbQVaesltrKq2AxrXTF60YbhHGiu5LPySsV9gv4BpNGQ+hz?=
 =?us-ascii?Q?etSi3X27D6mgpszHaMyso4tduyThGDLnb9waXA+YBvGzdEKFQLeGEZDk2MDM?=
 =?us-ascii?Q?MYd+edg4sMiHVwZhI6qWUXDCd+Ce8QKBa3R5iBazzUu2ftGq0mTTLu5bZoOH?=
 =?us-ascii?Q?YD2ZjSQhBk0wZvuQExDjznFRpJdwkpyr6tqBWIQ/1d5Ys9JuRht3omWcjjMq?=
 =?us-ascii?Q?PG3hdvyMqiIRaZyq+EBDmUNH1w73hhlr7hwBGSLmDWxNzYlnbFGb2ALC6P8g?=
 =?us-ascii?Q?GznMHufhyQPk3srGMN90wAO7N7fpiFA/BODB/wHupQPspo8vZ56cFVYHMTMl?=
 =?us-ascii?Q?d+g5MeZXeQ0ppJpAxzME/VyYgREG5KqFiiBlXJiMJlvWygz9U07oJYvHX0c3?=
 =?us-ascii?Q?KVXZPq5D7PxDBnc5QP5XjCG+oECjBPfXMJOcI7gMbjHn3InIKMKFA+BPg5c/?=
 =?us-ascii?Q?bTGPBub72M5h5Upf0QT5uBts6fjYXMGGxrOqIvVoQxql2BOaMnMyd+cp+TQA?=
 =?us-ascii?Q?9XT5XBEdk468drDpC+jZ90S/zq6deYblQCCsGS6qMCSsqNthUzDV7DVpFrtO?=
 =?us-ascii?Q?q+kOiIkhDjY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zGSs7957Fkgafw9LqQBnbS0VTsJMCFnSvSZB9Oq4Lon/Wy60GzM/z/wrwjoS?=
 =?us-ascii?Q?E2fIUKzSqdfjlCXztyDrst3WtGpRYW8NYhxM67C5uhPGm6H+XWSbQJLfpl3S?=
 =?us-ascii?Q?FlXTG37wyevVYxzKcqkiHv1rbEiECrFvdmuWZNaNXDFIu6UPUufHDfYijacq?=
 =?us-ascii?Q?/788gUhUqOOSsxX04uniRiX35y5IVV7nk/5ygAlkXjsdIyh/3ZpAUPbpQTM+?=
 =?us-ascii?Q?5WIJr+bXC+1fpxCdtn/9cEUOyar6IglRXNa/epMhGCf1oWZZNb/qqRaAWVhh?=
 =?us-ascii?Q?KR+4clEHONqNMg6hWphB5R9qTmR+Q3Umr2cdbIByD0OJtF6HGWsV5aMcbcbz?=
 =?us-ascii?Q?Ac9eYrUY8xwoY8xdNPisyd3ucwZ/23/4yDZgU9dxmSYM66Ytaaz9txQwl3qK?=
 =?us-ascii?Q?Dnt8bXee4WUdGy7nlH3cEJ/E+3DUhcpxgd+UqXkWRW9O/byFYLz3BFxwO5gQ?=
 =?us-ascii?Q?PV+xz/GtyLa275/a2XgW6oaHAn2mnZOlO+r+EeY2w5eekXuQmxKwqMFM+wfH?=
 =?us-ascii?Q?hE6ybZ2Cy8S4t9uwZLpBLMcBXy9odkfFCZt/D8mHo4xQzmKsQAa9gfTbxtWE?=
 =?us-ascii?Q?/yZC1Q22BWWoIJB549ywxftKFYbWDza4mgBeb/2buz4A7Gvnc/CG3y0AlMUL?=
 =?us-ascii?Q?qYBgBmYarG5SEticMvNnoVxJRiuIWrgixMxfwte17lR6PtEoRJc46Xwyro3W?=
 =?us-ascii?Q?ZiGA/wCTRGHF3fJ3sMzdj9/phw0zAk8Z4QATJ7NuOq6hHIr2MxVB5GwBIU/q?=
 =?us-ascii?Q?MdLcInx5UptQAupP/acYfhFsEdXB0SD0Sq0igEpzv0IfDChKFSRRVgKGvney?=
 =?us-ascii?Q?ZTTxsRFzp69XsGCKN/JdI6eLTu0b+QC+fIW5224qP9tRkEgx6z+y0rNTFIue?=
 =?us-ascii?Q?JYGy4lMX6LTIHttR1jOZ2Uk+xsr7mOrKZpSKLNzv5PxmXJrOThxEU0zet7yv?=
 =?us-ascii?Q?nKZmN7PktWJHiptqYb2OA6wZPyOJP7uk/AokC2D/FSER9IhgDJwkXF0ows2q?=
 =?us-ascii?Q?VnYn4A680lKE54txk3hfLTf+JB1X+hq8yHl19PJAfU/6bx0NTwkw87Icf+TX?=
 =?us-ascii?Q?EFoLKU6p6m4tK01lP2Dm4Pxki5TFheWeoy286W+TOxCQXQs0h/R42Wbf08Dx?=
 =?us-ascii?Q?hiRbKsszMvj7sL3eiLtAfx21knL95ZJa0Y59sVTxs0RrhqE3hK0DhhA6sZwa?=
 =?us-ascii?Q?4dSxxIyV2e0GnFbLSDJx5g40LFprJqR4+xlq5nm8ITzpYc2i/7msXh8BrHqM?=
 =?us-ascii?Q?CELDAcYJ8RZKlLMVEJRTVF33DzuMZwVg6IlO0bYfdH/cDICSQ1PtNEVdfz9u?=
 =?us-ascii?Q?sgRW/onqSOaXRpf3uFWXnfaFsgox0uFF+TC2WzcRh1eDRXCCWTPlPL+BmDIU?=
 =?us-ascii?Q?nHqmETLv9gwNQQFtvMD/5jx1qBMFOqm80tLrJCTcZkMFfsdKlWPRxQassDsU?=
 =?us-ascii?Q?Nkx974YgW3eDPo7PaOgXQ+lEwD06mI1X9sxhYrf/lGpY50U/80cW82BmN4K5?=
 =?us-ascii?Q?vAO4ofUY+6RnkzvxorMVNoA7fm7w8bK1Dlqd0Napdcl2i37J+YSCMuEtWMJC?=
 =?us-ascii?Q?fvHpJqkzthwcF1uJJ3ux9wHM9xlmjQp3FB6nRkAo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153265f5-48e9-4b06-c487-08ddebb5f176
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 13:21:23.0791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnoF175FlP5Zsqx6Fb1a7FbsQ+rQo9mTRFwHT3o9oyIg6PdT8JsAmhpwRCbln9FT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9122
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5EC57120011
X-Stat-Signature: 4to6baqqxj31ymkcau4uafnqnw9h8t9i
X-HE-Tag: 1756992088-801481
X-HE-Meta: U2FsdGVkX1+BRkiKMxc1uG0U9+OKTWwAZE0Utal2EWwFKUemckQ+hN0D4zdAh4hpiefGJpFZEw58zP7eCTBGynqP7hEr0UPAVnMfafXPJAkVxvhz3M5P0HJu52VrGeZZcAC6sqng48iB2s9XyVP5drgsx0JLtgrabLmfxaWYe//Q2h60Dbt0hoxtBdx52JkXmofC3cJK94cegek/ReCq7RK6wFhPH+oDp+pi08pp7w6R0bqEFeeAzS5zMO5aUn812OJKYOz1tP4zisXFS5/gC90Hy87lyV3ZOVzy/oyPtgEs0N2yE5wTD1IFFZpIQI16d2tSFclMw3teDroMXntZe7jzgej1tQ8OQufQGSGTkKvpF4lggE+Xsy3ixqxr7CAb90IS7xxqh2q2M2+k1mBaQMdw8UzOCGtqkheVgKt565efOMkCu0j3yOy4Gfp0gsEPcZROWkblt5MgocfnCKqCnpyBDSyn/23B20/29pV5yAVYE9LaZJo2zwx75g1zTeV2zTdcmgfR43RdYfDJhiTT5nWcCCzsZTLFX0pm+UbZ7kiBemOWOXhwDbIerYKuUgi1oac+FtTbpsvRz5Jyh/O3VUuEoGppAUMv3KcV+St5/V3ZToRhWIkWDOjvqUnHJqoCG1OFEjJodf8Ei9L5UZu9XQ5SiiyBdvIWybn9ivHI9R8xqmCasSOVkwzOGqHw3LqYqEpQc7Vu3mXuXDVR44yzIosjchJFsu+7HGiKGkWOhjEVpm22F/nHgLbNq0HVTH8mmkkHxd7gz6tp2dKIofzC+eQJyEIPlHQHgwVof50oZtgeXn+OLDd0vjQJx+r4CCoBDnJ7nXe8eulzY/pzLHQ8B9lWGfMkD4ADfL9TVmxlqeVBPAD2iY+2B5PT1+ztzqayWQRuVyUBmRLAJEailVAAgl7iiEFDVJQkQ5+wycF1q9S7F3y1fcQcb7LBwUnSQKl7qYB6DDJdBoBSBoXoMNN
 WhwmHH+a
 8+FX7hsKs2iIEEBcbhiPaTFGiH1qY+i8mRtqEZ1oIEVtnAgywhlFfl1pn/wRS2cblvj4ajsYCuK8kKSrFj4ybCDuCoCN0Z0Wb+AhQnT/fWfVIqOaNKagR8dEBBLHW1+vFECPmzMTNjVSTABfWT15BNe8liV3WjFEC8aGwaaHFRnMbK4DULhMD5lUIiIwKYKt/WSdbrFx1w/8pBgeRCm+qRoJwdbhjVbpS6Q/Z9RIdSmazmswSpt4GdqEDq4YmhV2km0VdQi0G+5xK+DVQCrpFaJGzAEJBlIirz7p9q6CDqZblYSWR1r71R0XA6iOlIIdBJFxKhgJDOasx2RQoWygtnGyCG/itQZe3b2m2YytWRskkARzFCRxNlnCkyB2Hrkl/3MlpO8FW2+Q+uxU+NH2/YVlr1APPWFY0FAVCBwASouteLV80JjvAzQ0WCEY0DYG5Yt3ctVF1WhseBHx3nrwIIBediDvB2MkugwTe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Sep 2025, at 5:51, Pankaj Raghav (Samsung) wrote:

> From: Pankaj Raghav <p.raghav@samsung.com>
>
> split_huge_page_to_list_[to_order](), split_huge_page() and
> try_folio_split() return 0 on success and error codes on failure.
>
> When THP is disabled, these functions return 0 indicating success even
> though an error code should be returned as it is not possible to split a
> folio when THP is disabled.
>
> Make all these functions return -EINVAL to indicate failure instead of
> 0. As large folios depend on CONFIG_THP, issue warning as this function
> should not be called without a large folio.
>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
> This issue was discovered while experimenting enabling large folios
> without THP and found that returning 0 in these functions is resulting in
> undefined behavior in truncate operations. This change fixes the issue.
>
>  include/linux/huge_mm.h | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

