Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA69D74ED8
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6216B04D3; Fri, 23 Jan 2026 08:50:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDD66B04D4; Fri, 23 Jan 2026 08:50:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F7A6B04D5; Fri, 23 Jan 2026 08:50:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4626B04D3
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:50:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 967861A02D3
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:50:58 +0000 (UTC)
X-FDA: 84363364596.13.69558DE
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010024.outbound.protection.outlook.com [52.101.46.24])
	by imf27.hostedemail.com (Postfix) with ESMTP id B09F740018
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:50:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EvzMft5Y;
	spf=pass (imf27.hostedemail.com: domain of jgg@nvidia.com designates 52.101.46.24 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769176255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kwkv0CPCm+LrqMV02WPMv2mTlRAudQjYt+uuDKxdFjU=;
	b=N+QevlcGU6cJwVXdQ+iPQn1LvZHy7KVwpSfbMUP9OIcoofIqyl/ABuLcfvv/4F1S80WKRx
	lWoXDBBflg8r9qi22V0MEHNo3Md8i6SomsZ+msDZhpot/bDrhzu5IRPcs7KnNDkpUjU9nF
	uSph8K1taFXO85TDepbxCoHhHlu2R5U=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EvzMft5Y;
	spf=pass (imf27.hostedemail.com: domain of jgg@nvidia.com designates 52.101.46.24 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769176256; a=rsa-sha256;
	cv=pass;
	b=eGa+FBUBdXVtm7t/KpSVLD+PzgqV3L/82afMyP7XEg9I8zyxKHphSUd86pvg0WspB14H1t
	iFMyT9NlrivKKzS29zfBjacyU/6l6Qfc0R9g/T/gNf30PcCOYFOkpsXVe4OvIWuokX5yAm
	EKYEDBRBSZ9UeV64/v/+NDg2WU75Xf4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ORX5KQb+sUpI+3viBQ4yY6j1/Kca4/35sLpbMQE4IJeUYVdG3mQTHywkT/skGTQHRkGyqb4QWZ64aIdCDCdvH77oJv6XC7CraQN2Hlsw8SBwyezC4eQU3GxTy+WZgQ5uRN2F0FBWgJZG2XsEQgBcJt6/nGk0taSOFcUfqmC7Put89V3VsGsO+w1XdAlpZzPXUgKYFOfe/ia1KJs3EJIirkN902A4L+qUhsWkh1MX3LJHI56d8gUV7Z4azuolWKbjwrZEk3Z+cHeyB2oS9CtsvzyvhlEQEftJq8ayCtwhpdjWPsy/Nb5as9oIhqWbvtdC5cJB2NLSgc7qQOhN9jwLhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kwkv0CPCm+LrqMV02WPMv2mTlRAudQjYt+uuDKxdFjU=;
 b=UVYK2A6xpKqAGR5StexFNtdtnj+7Otj6ZsgVwRUzvBk2FacvmFCc7oC2y8FWO6IXV2md3VV7KFYeSH3geX36KLCk6YdVXG9qzdTnbAmgVi4gwslErB5AYbL4fHKwx6Lk+jFQL8Y+WBiiG5bFBckkFIV61nncxKv8ucmuNECuqlKTNeSPNyxo3ukELWIjsUvoaXkCo1s+InlQSM8PMYNXpkz4jUeuNCJ+W33z0maJeiQ3ma0v4pi+O/r1LM0d9dsG0f8A64e/nozqaHHUXiicfaoRT2dPZ0CdroPeAcJhaL9/Y/LdqYv09shzKuVtZFOTWo4ginVcISz93yHJha6ceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kwkv0CPCm+LrqMV02WPMv2mTlRAudQjYt+uuDKxdFjU=;
 b=EvzMft5YJ/df9prsh/xcQELZ0389OaP1QN7p+DHYbTYBLLW9FCN/HPzsy7gcRGekfcx2SMtBbvd5TAmA4KEoiPbeOMGz5P7IWLZYOl/ar3uE0o766B0PRRZyMevkS00WSPABZ5RmxE7jl0fTV3cuSDV/SWIyNpMXdzXJnDy7560AJC5kv1YMMxHQftWMXawAs8nycYQ+2RIIkkpWUte70/Du4aJUJC6nGIF1VfI46h2H40dVROqk9B1Q9K5SMJKXaLV5VGggfxtUT7wQQ0cWDDJb7UbAqNuf+ORVLwk3iDBGmt/clOkY3tfDCdN2cdvuZvjPNWdxAReSz+LIlwVAag==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9655.namprd12.prod.outlook.com (2603:10b6:930:100::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 13:50:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 13:50:51 +0000
Date: Fri, 23 Jan 2026 09:50:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>, Jordan Niethe <jniethe@nvidia.com>,
	linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
	airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
	mpenttil@redhat.com, willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org,
	Felix.Kuehling@amd.com
Subject: Re: [PATCH v2 11/11] mm: Remove device private pages from the
 physical address space
Message-ID: <20260123135050.GV1134360@nvidia.com>
References: <20260107091823.68974-12-jniethe@nvidia.com>
 <36F96303-8FBB-4350-9472-52CC50BAB956@nvidia.com>
 <c9afedc6-f763-410f-b78b-522b98122f06@nvidia.com>
 <6C5F185E-BB12-4B01-8283-F2C956E84AA3@nvidia.com>
 <fd4b6553-3e9e-4829-a12f-51d29a5d7571@nvidia.com>
 <16770FCE-A248-4184-ABFC-94C02C0B30F3@nvidia.com>
 <sezye7d27h7pioazf4k3wfrdbradxovmdqyyp5slhljkmcnxf5@ckj3ujikhsnj>
 <DBBD65CA-A8F2-40AC-AFA0-FC95CBDB3DF5@nvidia.com>
 <0C16A79F-5A7B-4358-9806-7F78E7EA8EE6@nvidia.com>
 <l5jxxobpj6shwuuthsyxlzfnhs6dx4spvzcqxrycn4chtywniq@e2eaio4nhorq>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l5jxxobpj6shwuuthsyxlzfnhs6dx4spvzcqxrycn4chtywniq@e2eaio4nhorq>
X-ClientProxiedBy: MN2PR14CA0001.namprd14.prod.outlook.com
 (2603:10b6:208:23e::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9655:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc29591-dc62-40fd-74fd-08de5a866b85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A4wW0D44C/oxAKRogWI/ujFJVZ5ltMY6Hwv9i533fwU/IYuc0hvogf0Xp89F?=
 =?us-ascii?Q?16ovx/A0CCymnP8pNvDrjf3TBz/SXlFg/us6O1YlEbJ3e8gA25uxnIhqCLl/?=
 =?us-ascii?Q?/Qzk7SGZBlQetyeR0Rvkusa54TgC2NyBXtDuWRt4WtHQQZaOaguYnPBS8Isp?=
 =?us-ascii?Q?B7cUyK61uZwd5BHUsjzwfIuHM7oF9kbBMgOc+O5h+b0FHCLRdwua259YVA4w?=
 =?us-ascii?Q?gV+SDy5aheZLaAAujauhBbx5AEh3Wztt7FtGjnjwfC9w4c2R2r/6g5wRXC0r?=
 =?us-ascii?Q?9F76QufySD5yrAo4MqZ7uXX6SolaokBm18yWiSIqzmQ4UQbJmJeUnT0tByvn?=
 =?us-ascii?Q?BHpzHb6qO0He3LgeVSyQBpUSNbc3wudeEO3PrD3PwciU9bZtEyzWexg708Jc?=
 =?us-ascii?Q?jnP1x9WXfb9zA1STgR7cTH1GYMZkHHMsEferQxwat7mIerZ5TeY7pC3+zidE?=
 =?us-ascii?Q?vi8x2ownDAX9GaDgYJSZD8OS1QHvjD49H7zImGENyzWUVd9+LZV5rchvIB5a?=
 =?us-ascii?Q?UDHp+UThp+oWufc3F0BXaIh3aOJvCPW+G2kK/gHJYLZ3um9uACQ6dl1dA94T?=
 =?us-ascii?Q?osS/rsRQgMPgZywARHZxgAXfzHEq+vtbiXq0tjwC1GDPKcOsV5CwsYxeFBUv?=
 =?us-ascii?Q?f9E2LQVpCs8DFttH+iLh13P8lFHemM55WVOeD6xTTZ4sCTvB32r0aF4SyEDl?=
 =?us-ascii?Q?GDri7sGaLor87tHBbCziKaAROZ4KQwTbdIkUVy0YtmgVqAnvCFh4CdImZo4h?=
 =?us-ascii?Q?uY38wuPGAKaScBUiCkYUw5wofnMi5Rs+kqSH6LlJx4cBk2skFwstwv0Ptr5i?=
 =?us-ascii?Q?J8xVwn+/71jWwsttbcorUkg1PXEyj0uS/O2fXWXGfBdmwY9BfcrhNXe0aF59?=
 =?us-ascii?Q?5ejo9GZjqaV5rOITZoeE5uqKUqPtwurDhOqXer5cB4EwliIEGH+HZh8G8GhF?=
 =?us-ascii?Q?2Uvw4xRs0aJ8Sj0/xsXYlyD/Hj0qAWuQP/NjR/qZGc46EQZmsPF1rLFFZFnb?=
 =?us-ascii?Q?hmdZ0I8mz8nCJgLeLNINY7CLsyy00TVAxuhbeVKD4twx4g/XWg4ur4DEollQ?=
 =?us-ascii?Q?lEHI31tasCTh1B7vdm+mqzM3MGsBUucKeZca0ROZymJ+DPybREQDLDLqB6mB?=
 =?us-ascii?Q?JZyQnX1MoNYTOigZkUQcN3rAYUhsINs3MfhGHM8IQmvLtGdHE8uIcIjm2PU1?=
 =?us-ascii?Q?9Jurub3cWJ20JkeOBlNGcWr8Y91v1IhTH0ResGF41O+rgqurCe75YfA2zshg?=
 =?us-ascii?Q?EvMsWtbuABtySbth8TxD/RbTaR0vVlvyJzC5Eea2b15kuuw/i0ahy+6Vb/gz?=
 =?us-ascii?Q?d8m/qV+FvJ6t6CfAINgDrBsF6IaIQhvAlT4H1XicGb3O1IzVkYx7UP1lpUcd?=
 =?us-ascii?Q?vg6L+Vx6P5HjlgKS5fp9c1NMdNhLh/CyuuIEaJnaXJR9kw1cv2jcoTCJstBj?=
 =?us-ascii?Q?s7/NuC6Dxn4UAZm5BYXd2QqGASuE9eJ4bPq8Pu2xUjsDOmiN9e8GK1hjqfEV?=
 =?us-ascii?Q?js5152yil416hxUKiQa36GZ4gq3wNMhISObW3MFnZtiRuenku1LcKYKOylaV?=
 =?us-ascii?Q?aIJ84syENlqjOWhrj4c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6n5bbpHPt/ZRXAxW/cRAjMitrJ6ClygL5kppuG9OHQ6EygfERfSxKMVcKnaX?=
 =?us-ascii?Q?EXAJ9Z6PTt+7vvNNqB+a5L5nA1xhnZhSP/DmepcJ+fdoZ1lYbm5jn5pqIuPN?=
 =?us-ascii?Q?Fh77mzDZRyt4LyNe0eYWAEjd+/NWV/htkko+aJc12VtlNcWmLJEIwT+TcpUy?=
 =?us-ascii?Q?EqzvrlvkcFpaLGkWFpsMwciaOR/XZ1eTi/lUfvef5gg9EpySurhxP1klqkep?=
 =?us-ascii?Q?9ytiUBjeSgiCeUF4umD+7AMQc+4++I9MKJvm1HNOroZ94/4S8Flk+qlKOIKM?=
 =?us-ascii?Q?j4wkLm9u03kjxRY0OizkKYpwue4H84XodEkJzh8hDGdTWP4minypilOaBobS?=
 =?us-ascii?Q?eOx7ZpPJVneetKQ1UxuR3aTP5l+sjKxxzpiaqIOZNFP1MZurYCH5NIvWaiF3?=
 =?us-ascii?Q?yYUCRH/j65owbS0Dod/nGgvctaGVT+cq5sCOFwoEOCL1+YpKXav20lM3KCmv?=
 =?us-ascii?Q?6Ubvru98qtXQR9CY5NyTihnhBq9OGmPbEA+xQ+KwOb6LogdVpZ5fiyPKU6DF?=
 =?us-ascii?Q?/6cFw/3sJOxRzfYgq0IVIWhcPsJOK20knximwCN2XYQ0SAoCBqhnPq6oBVkq?=
 =?us-ascii?Q?9yaNx+YO7ATDJ24w/nbUvllcxwjW+AkLHzfmxMBsIzFREuJVoELhuFZhKm/8?=
 =?us-ascii?Q?bH20imouET3K4uHD1R00XA2HkU4KhnM7Zuq/2J/gTnwkfc7818IF70xOjsXA?=
 =?us-ascii?Q?xYZBh5IWY97ffjwIac0hOq4G3IlK5SHa6q/kiehpzrE4jq/4RdjtDorErXrl?=
 =?us-ascii?Q?vRc3t5wcqQBBpcHCBh4TXzwjbMnPMHranGJzB3kKnwWXXlzD+m2oiiJYh8Z+?=
 =?us-ascii?Q?uvdrodRxJluwG2pQ0j3mYInlAfwD+pAfcls2dy48irnXdopiF4uNDq7xbpdg?=
 =?us-ascii?Q?ddi0vRbNJ/WnEJ71aUtjBJPVcY0As0ECUj4oU0llYSmLv5aa9rtP+sJ+hY9z?=
 =?us-ascii?Q?QHiFyOky+ai+Fb0CjBUXiFHOR8m+2VcQGk5/mUdcBNLfRV0tGjM5NAkSYO38?=
 =?us-ascii?Q?ncAxVK1wrpL+V6ehVQWeSE6GTCquOv4EuogoTw+wOoksOnn3D1gE6jzHFh0U?=
 =?us-ascii?Q?NxpamDRX9hYgqEqJNbJ4mRd1/LLncCO+RaNJU4Mnk5N/mLvaNIb/q0+61iim?=
 =?us-ascii?Q?HqzV5FggZSYTUEFBLraCdwoYHQb/UgyBRrqHv6TOVLBle+WPNYXJjU556WQV?=
 =?us-ascii?Q?HV/ORRRRbgjkmvlS1+hZ3iuY25EVVTp0SZUhxrOPZOiOGDahQ58c4wfIxB6t?=
 =?us-ascii?Q?PufVzs0BfRUPQxjAntD1gxsk/rQ0+JXmI7QyBkzWO74P/i1dFV/0wTnp43OG?=
 =?us-ascii?Q?nJtQvJ8E7N/1LALj+lPePNyGisA3czpxZR2kivDJpZatLyjy98CN/oH41xoq?=
 =?us-ascii?Q?v4R3uVRTYWI1rB+fCc1JR9FMpJDX6xIjiVwDlChA1O8jApsQd6CjnaoW4rqu?=
 =?us-ascii?Q?+K1zF9mWcsQq//DdDH+lOeaBvZgWkjVPCJyAIPA5lPrwwWJBDSCf05VXlR/u?=
 =?us-ascii?Q?wP4lCle2VLx45LOMRQYqXTH8C7faBTS2KQms4nQBBjc17WeF7cf70P57BHCx?=
 =?us-ascii?Q?HP3zntQ80Ikt9pfd/+f7cgFv2BBYM/yQBDNPrfHzPIrjZDIxViX4eCmDs9Tq?=
 =?us-ascii?Q?JyADniIUhyZrF/ghdob41Ecbex8QP9lwwKxRctsEdOUjPkmHosvUqUAi2uT2?=
 =?us-ascii?Q?XRuuzlioMzCwody3epeVaLh0x3hdCVvUn+6WKR1pBaNTEXxIOg9aJ3T/FKLu?=
 =?us-ascii?Q?p0cw5dzvQg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc29591-dc62-40fd-74fd-08de5a866b85
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 13:50:51.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0Dcu+lYo9RzqG09W5FZTgTlAgHF0BbKGUhWGGo1ryzJTCTzDCMQ+18J/9Hb54CE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9655
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B09F740018
X-Stat-Signature: 8i8ux7e59p5r7tbxktfzxbpo17h9r5s1
X-Rspam-User: 
X-HE-Tag: 1769176255-577789
X-HE-Meta: U2FsdGVkX1+4jGkaLxxrKFQMVJufkxdc9y8DsG8yBdik4CUdKmogZasYXmhabXuknKC0jry3XW0kfoVqZU8BWAzrGveHd7gsnXw6VOKVnXkq/B8GoXaT6Vglax3EmUiiEsyK8CDFCKi9a7oM8VTICEVB4DLbfgw3ERqnXAypmGPCNYWqvBldSwYjJttOHOV6rJaZPAfpb+eMe8qExyXpfnbEvFVV0HIzypH41fcoymGlWvTn/UcMMV12n7xCrfgkFEaXwD4qvc9g6XRuXshfzPcVlAoUClJ9EooX9llwNiRGfxR5lV7Y4pfV7eITk8EYXQptLluL4xeH5jVy6lg9Fow+n74c9LECk1oXDEbB9pktgwWrLqxtpR28Y1xrhu9W+PjBNlWf15dKQfHUufQJ+hL+JMCoGwloNUeoHyAJUpHjZT7gdoN0+Oc8oiJI2GLh77XgK/93mE6fOT903kL17SufVj9hjzPruXaz2xUjbu/TQV9OHLO+tvNq0kb3GdoNfwKl5LGUM/+YP1BMWVHc7cKXUNreFuTmQUnoELoEzABWTM8G/6H6X5yEb4EIR4qu5WGWleWVLPyZqKlJxgu4P1OwMB5r/FR9y4nkt7Y9JmXaA8aQPbEBeNwUBLj1WKy6YrjV58RyuEV+YU2KvyqRbi+tKwWZCbwuOBtN2Y2WsO566Tmn3N9NFZUWYWFB1yfTegXeVjd+ouS7O1ObY5AOS3X2iDowqNVlxrztzg6EmMWGS1h6AfhSYoz1rk5yzLobwwEArq2Lf1ImdfzfVaiA+JY+XP86ap19PKYj0S36eSXsIhNrFBmfJezqLQhuX8VocRon9GWe2bz2RNU4Z+hehhgOIvWEG7zgKNYArR1YYMdmowRnGG81dwRFu2cvCxMqaBoFnR59+/0gZPoyQ9mS5Yig8p1E3Jrj1wM5WkcYY0pA4MP/MXrutKBrGFmy8MD3AVWg+zx67r3kUmZpp86
 QQh84eoD
 JitL8n7c+8KnNtc/Uj3K//PejSwPSMVHKqN3fFSUQXF0WRz6yq/e1TMTE+72pe6FSHOs9sNP55yGK9MeT4DOnSu12bP5fOmOlmfi8yhQIh0HW7qMZWdH3Z6fhYp8cyxttrQsQBFbaFTtZ66aGwsR4KiF/lTlhYVmIdhz0Wid2fDZrASCcnY6SWxktFBVwHJ1xBtKmsRGGo93FLguxDdhfccL4YnIBW5UstD9gQOBF8sJ2fTL9NXSrF7cBoI+voopwXAf5Q7QqjgtYg+mF+OrML7EY3zEG5kR0+2qAv/QrW3XPMTQxKLhMAZ1+WAhUEfUKs3xNAuHLZ6C4Moutb+dSLYTZwJcbf9huGXATnasXqXXPiEY1Wv7MmpTLpV9VJHhFUIfRhnFw2nLBnRZxYoqKSoR2Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 04:38:49PM +1100, Alistair Popple wrote:
> > >> We need to be a bit careful by what we mean when we say "HMM" in the kernel.
> > >>
> > >> Specifically MIGRATE_PFN_SHIFT is used with migrate_vma/migrate_device, which
> > >> is the migration half of "HMM" which does depend on CONFIG_DEVICE_MIGRATION or
> > >> really just CONFIG_ZONE_DEVICE making it somewhat arch specific.
> > >>
> > >> However hmm_range_fault() does something similar - see the definition of
> > >> hmm_pfn_flags - it actually steals the top 11 bits of a pfn for flags, and it is
> > >> not architecture specific. It only depends on CONFIG_MMU.
> > >
> > > Oh, that is hacky. But are HMM PFNs with any flag exposed to code outside HMM?
> > > Currently, device private needs to reserve PFNs for struct page, so I assume
> > > only the reserved PFNs are seen by outsiders. Otherwise, when outsiders see
> > > a HMM PFN with a flag, pfn_to_page() on such a PFN will read non exist
> > > struct page, right?
> 
> Any user of hmm_range_fault() would be exposed to an issue - most users of
> hmm_range_fault() use it to grab a PFN (ie. physical address) to map into some
> remote page table. So potentially if some important bit in the PFN is dropped
> that could potentially result in users mapping the wrong physical address or
> page.

Trim the quotes guys..

hmm is arguably returning phys_addr_t >> PAGE_SHIFT. This is a lossless
translation because everything is aligned, it isn't hacky.

The value it returns is not a "pfn", it is a hmm structure that has to
be decoded to something else using a hmm helper function.

I think we take a number of liberties going between pte, phys_addr_t,
pfn. If there are arches that use a special encoding for the mm PFN
then range_fault would need to call converter functions to get to/from
phys_addr_t.

Jason

