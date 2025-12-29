Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE32E9273E
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 16:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C2F6B0088; Mon, 29 Dec 2025 11:43:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134F16B0089; Mon, 29 Dec 2025 11:43:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23D56B008A; Mon, 29 Dec 2025 11:43:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E105C6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:43:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 880EFB7CB6
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:43:27 +0000 (UTC)
X-FDA: 84273079254.04.BA3834F
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013053.outbound.protection.outlook.com [40.93.201.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6AA4A40004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:43:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=M5rT8ZLX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767026604; a=rsa-sha256;
	cv=pass;
	b=6AToJ7dttrHrl3XZpAFlgxxjMcPPkpIQuTaKKEMxTekOQv2G6id+tL3tJ//kKKX1liLXGF
	K7bEfajvQxUmRRkJ2Q39wPjnAAySVNe/gcsra2/vfWqO5TrOh4rsAUupYbzO0C9597DUmK
	IxER/C8L5tui38EIDwbS2TOCJFpnGpc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=M5rT8ZLX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767026604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJGJ7sEebQMkuj3Ho14ZoKu05VcI60/Sq9uWjazS6O0=;
	b=62p2WwtJJQcEvmQCcPFFs2r8aBtQDi3RFXO4EScY8GWzO9UUwuHDuHNNChxBeZMko7S8p/
	euA6/q147eTAUiIkm8fKxt0yRd59gA7YPwZoEX3dqbbnQKr329jgVaPoiquK/2XL1fm1HS
	lobrJA0m/ppq7+PJZNUi3Jo45lqVWWs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LMpMprSdFesBvP+fJT7K8Rd+GzISohJBUE2I99Nuw9h3+9cvHrXzTbtV1QwHLiX0XC2UaORvSbLCrDVE+vTptcgLJC3sB+jl4S6oIkP5tlqQ2a4ptH/cIiwHogWcE6zfJo+Jol51kRWlsRjG6w6CCODA2i6KfY0jl+N+HQNoOh8L+pp3IkjzgB/550UlmStwDT8izfw0RGPDBO8BWXWe8EJ1sBNXQvk5f/tO8sbrkJz2Nn3R+t37F3iRCmsh0FOGxYcefE18VTsugWbsJMmAswW1bUgmV7y7Ksyx80ouBtmTFlDZBs1JCgKk41/ZYMzD+KDxyHnNJtFxara8V08FwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJGJ7sEebQMkuj3Ho14ZoKu05VcI60/Sq9uWjazS6O0=;
 b=zBJkkKO+FF8mEZV/UKPLfvZb+rqpUfLkmXz5uB+H8qlh8AXXtdWENE8DrG6AX/wigImoYT8Cdjz2/bC+CqtiBUB5sPzJDBB7Hs7uoLNyc+BPm0Om89jGxUW/JMkVpdMUtF5vy6AI1SDp50SLjyHweIHpd8mm16wH1l4h6xXNfzkbbVonuu1A0EROjNA5CgoPpvcsacDiI16IzstkpFvjH6AmN087Bl8leyVeEIO8xmtl1IaygbIyUDQJXbZ4G5g9vX057sL5x52v7euGjFBFZj4//5YMA/l1PaXhOPXdh6bc43JPtKH6AN2i2CqbO/+8NiUtNnAp9+5Cx4K3zQYmBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJGJ7sEebQMkuj3Ho14ZoKu05VcI60/Sq9uWjazS6O0=;
 b=M5rT8ZLX9B2qUshhRPNCnz7AXVe/38sJgQXHT2L0IHprjkAOYROqfemBmKIrd0aLIzFS6mhJW86pMfcOSCjsb2MGMBhvPYHHKWXCiln6xTgwcAj3NCxOeMbb05uokJiQ5klY0pWXicbTlFxconhs4OCDdMtSc4FNuM1bPqko04JHncqwh0oz45fkL4y7lm9nqX3l/saPaGw+8L1g30isLHaBx7zTN1xRhw1phwMAzoQ9gnba6plDal6PSgjRo8euw3HVa5DaIxQpKSM5eQ0T/dfJLKGP/sPxrZWfI7e+UrPsghzvJUcDj6EQ8V/L2nYRU7GAGRWqQoaNXbaT16T2Rg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7288.namprd12.prod.outlook.com (2603:10b6:303:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 16:41:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 16:41:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] mm/khugepaged: use enum scan_result for result
 variables and return types
Date: Mon, 29 Dec 2025 11:41:49 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <16B602CC-6D4E-4809-8A94-D63DEEC3AB83@nvidia.com>
In-Reply-To: <20251224111351.41042-12-shivankg@amd.com>
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-12-shivankg@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:208:32a::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7288:EE_
X-MS-Office365-Filtering-Correlation-Id: bb62bffe-9152-4789-daa6-08de46f92a7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iRqowSEqnC56MJEe+EowRIhj3VTrwXK5fcuINVioSZIaHe2D1aDcNytqEn/A?=
 =?us-ascii?Q?KJ439DXv30uqfUurRumKqlcpHSnNTRauyMHUsG+dIWg8idLY3rgLK7tQ9vzT?=
 =?us-ascii?Q?RvvhHp8ipUbJSjf1EysW1uug8iajs8b3Z1eHNz57aZ2m/i1Mirfe/UC0x6cv?=
 =?us-ascii?Q?lbqOsHsy7FWgxxpFFAxbmfCHZOWMgy6fff8o0MeWIZUCdf8VWpc5qvYNYSNd?=
 =?us-ascii?Q?47SuyZJcrxGw2gjduChihhgCZe/QIQk6LY1oRErmF8lV/o1F4nJ59n/I7II4?=
 =?us-ascii?Q?o288qCR7I8t+wn6mmV3KkoCvtLrEMtYyujSh4kPyxi3KssuSmyNwMSj8HfGO?=
 =?us-ascii?Q?nVuQ26Sqh1kGvyGXdfllZ8Znm0kokO/5LaJXkmcEkpzgtNpJrEJNbIBgUWZJ?=
 =?us-ascii?Q?a1QZgtOXLiU8yUwwo26/YvW2OmZ4DE8ot809fQG/Sax0LtrQCaw5AjBKgxIG?=
 =?us-ascii?Q?NTZncmEwTnK2XooxQdAqg4kplx/xcnpJT1IY1zUA19dpTGszDRhbJ39alV+I?=
 =?us-ascii?Q?y/SdmWcD+UUu9X+xHcMw/cC8cxI+FmIVkCPWo9l/bmFpt0FKza2bpB/XQxT2?=
 =?us-ascii?Q?mNMEW4v/D14XeHU0IjWNcusAkxeHgzeHvqULWewnTkT0A86B5h7bYFsyxgv3?=
 =?us-ascii?Q?EaKomMyDdLZjy0ypluMxlGZ3bgbe+DsHlhDTdoSfcx5s3gSoWcZ2Yov1/uLO?=
 =?us-ascii?Q?mZrJhi8qdjgKBMv3G1UUIQIWqF4oekgLGJKEdQ2cgLSQpm8lKZESCaSqsKvZ?=
 =?us-ascii?Q?XhTgeQQqZwkxZOwlbECjCUpxHiXMocrGvB9Q9yhqlqotYGhUiyjnZamRUGIO?=
 =?us-ascii?Q?XggjPVKoYFmWi997p6hWDKvksCq/RkLNcb0g9QVpyPf+R74QAItnh/teh44t?=
 =?us-ascii?Q?eF2VEWg/Vs/TvKjO/+DV0D2R6CNA6FyLS+eiSO+SCeMlT02YuxIfcRdC0sML?=
 =?us-ascii?Q?KqqKCha2VAMk2MZvB4gW8myBRjCbRXOU7i61jE3WPjX898yzBw4aPx+3lyK2?=
 =?us-ascii?Q?cWuQN7uFu7Zuh0ULU9DqEc6uUTrATfFegLzlXvx66eAbklY6hXHx49Sw7Hro?=
 =?us-ascii?Q?rdoYUgnb04sK0xkjoZ70i3oZzm8ivP1nv9bSaXJQ6t+ycR6RUOImmYd0zoEZ?=
 =?us-ascii?Q?ozAesLRl8EnydMkdf5+U3fyr+Fzj2TVutKiX87odVfiszZ44BFfdfiwNWQF/?=
 =?us-ascii?Q?CxJfVd1r6EcTTkombJaqhb2lFno1tZAsEjq6DjjxqFw6yDWyOjvh/yBWLq24?=
 =?us-ascii?Q?RDOELp/aEokS9jPTzwctuGjgka9dgqJN5z9fy3oRRHd3EV36p7/2MKutCNq7?=
 =?us-ascii?Q?LSKfwxc4b0QE5f1JleUiTwzF+IwfPxr9GXzYLu16OEwc0g6cyWwAZmEdQTlt?=
 =?us-ascii?Q?klAosXg+2WyARl0VJ9nHExBC+HHhRP10DNXGcCARgNtL8ZHk8QzPnh3NBfi7?=
 =?us-ascii?Q?N5ruj2LcUA6z3UqQD/vD/MTz+nnudaTe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?srp/6Dt42pKzCbzXXPMvpl8CQPaNG6HHxl8aq3sAAzKZYSwOuDQAUh/jVOQQ?=
 =?us-ascii?Q?iNXMumV8KXG9WSQZX6aTKClKRbq8qS0yv8jkRAenUfsi1x1rY1qpBbkdB2eQ?=
 =?us-ascii?Q?4/0jV5egY9AuYxefoT8p2M5AKOI33LsrTDlaTEZJx9r7QIBik4/QHh8uUu5k?=
 =?us-ascii?Q?05Nx7bOHS6vtE52fiOhG5jVSBtoWHmZiourdjrrwPCFpjBholJSr3jcney6R?=
 =?us-ascii?Q?I9QShKa9RIxI6Sz1mC+SgrisSrV1WIy2cuJuLFX3wRh/2rRlxJC5xD14xlx4?=
 =?us-ascii?Q?jtmBs/c7ZnfDGSQNzYVDpRFpwi3xRVaM4GGo4OxHJ61dS98Htiz4nNwleSH/?=
 =?us-ascii?Q?Laz9Ru831qNit6j6LaD6InisXvH+cdid2u4S6Wx/C4XJw+2iKN3VEq2fB9kg?=
 =?us-ascii?Q?mpD4CaboGlMpdmxGCIr4udbhlHC8v/6amw040xUROyaj2tbcmDV/sHGpBn/P?=
 =?us-ascii?Q?3Dx35LRyxcBjGqBzlHLEaNaZH+n0rIAJGYpUh0GqjHTp16RneGyfz+X9XQ3h?=
 =?us-ascii?Q?CyvsciRAMauLEWbAoPaN88QvRkxuc0UmPQaZec0q1baeSYFODer9AHNtYldd?=
 =?us-ascii?Q?yH4odj4ucKmAmC6dplscCXTCYnrspQaf/0LUSYPKPHK2GymKMboB0Syb/i0F?=
 =?us-ascii?Q?tlpNl4tcWLP31LZ2hIk3Kylazmy/kj94+kUfWngN0rp6zS9l/SJj/3zUCSdl?=
 =?us-ascii?Q?3LP6cGEFFrtfe9yC7BmcsKJxotyA11/YSrSDzOFtrT/dIbu4Kzyf+N4VlLfO?=
 =?us-ascii?Q?Mj9xFH15gHmy2WDBvRtxUhG+wbyiGlQz97z8UNY6kEF5tRTfAdV9XH2cifOq?=
 =?us-ascii?Q?MW+isZEBhASauPar2mvUJB/lIIdCoL3uGVyekVlG/F8OFLeiGdgunEmA2xRW?=
 =?us-ascii?Q?aMfq/XdgB15D82IrMU7MOPjfJLJ/QRwA05dw55eneO59f8Rdlc5vrF4otHcB?=
 =?us-ascii?Q?SKyMY+XJCISrGPpBcfYC3GZlx2Dm3PLySOGBXKUTkfUSzyT7sB3O2NBCS75B?=
 =?us-ascii?Q?+4cyRLXfdJukD3G3OVvuf2mxowvJhLygKmjwc8rm/H6R9tXSjVyFz17/N+2p?=
 =?us-ascii?Q?foUXG+lIq3I6J/vdZup0X0mZlIBQD+zqJwAWp3rcUOF3S3bkSmBEMP9YD3Ri?=
 =?us-ascii?Q?VbQ+oOYZirawkh4Sp6FkMUNpLo+gqFbJ9ZWqFeyz7pSIx7adF3p3fN+RMgqG?=
 =?us-ascii?Q?bkKemvmLTxZKnk1uJ6Q3ZMRTHcOHhiNcMsy8g6XGuS50VV7WwJr0vJscUnPf?=
 =?us-ascii?Q?hLBcUfEGvZy4IgAH53gQpmTvsrUoOfZFi+OeDie532pGsTapqeSYhWVHgD6k?=
 =?us-ascii?Q?3Qdy8KCYiVfNqvgYlWIMI0yAHfbQZ6twMmafHLIi7U9fmIIb5jiT3XL/KJGg?=
 =?us-ascii?Q?4BMufBT9xB9jCP0X2O1rM7dqQOQ4vFL6oCdgotsH9jRIw4qILtXYrGsSD6Eo?=
 =?us-ascii?Q?n4i9e05fbvmEVeVx6Vp3zscb7b5R+x8+PTPjwxy7EJ+/37PvCeSU4GBwIjRn?=
 =?us-ascii?Q?O1Kz4fM0kmkb1UihCwSzh5PCzd/pB4HFDGFgqeVhrE5EWzclvRZDu5MrhWRS?=
 =?us-ascii?Q?kCh5wTY7F/6SMXef+YhIJ9X1cy9SI66130U3zCiSWSF2xwpFyysiZeg17YV6?=
 =?us-ascii?Q?3UEyoQZLaMwR2Xk/UL0kqOOrYyFcQOOzOL00ru3Qa8otDM2tZLtLQ174HMyA?=
 =?us-ascii?Q?Z8Mzub5/f6RWEL+WAIUY0Ef8IW4LN+0EH5TuuXJTarNZw8dj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb62bffe-9152-4789-daa6-08de46f92a7d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 16:41:50.7937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUkrfWSeG87bZVDkvcDs/KNziL9BVU9poY5K/IcbreGXuPmD0gtWOleS15kLHRwF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7288
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6AA4A40004
X-Stat-Signature: cir5etfb85g4xgoyioq7dgg3ype4857h
X-Rspam-User: 
X-HE-Tag: 1767026604-869304
X-HE-Meta: U2FsdGVkX19CJFUQZHN19T69HCcHEph6LzaC36F3BflAOEVJxcM44IWw0jGKKOkXnUX3mXGL2SBwLRmugNlko28jMqQvFCTHmchiBUsaoyTkaWbgZ8kMea6K+Gfedkw2K0wXQX4qt9wyQL+NnDVLj2GBzBRUnowyOI6ux29dkncLcxakrecGK78TxPgAq/3vM9XDHz/GUfL53ycr+iedsOBbsRF6syqRf+c+lkUaGxC3bxs+5IpzYdujskPo5PbZ1p8YgGFE1AZ8zOQAo9UyWnmzTP9jmueHQTjDDiU6mCNJFgIb9K/MrQwBnBJkp/0EC4I/heT75imifRkWLLQnjnxqaBxx3iz+pg1rBfresxRMO5w3E5Rgxm1yozGLxOqvxVJS0PpmHHc7RqnaxrkQ3MDLa0WQXu6a0vqA5pPCNrdOtJyrwwygqPC3Dg9MEoykZ1A4iuLpl41B4nXUax5S8IJSwMCDzmVr/04GtAUUlMBMSj85rhXpeVy3wyYqUnhyS4wPNkZaEzRoBYF5IVegHgyqc/SMuCn4SUyzcnKOxIgIlBWleMe6Yn1mLWgmFn6rTmhOJjMtrJdOvdOlCbi1YLuca35rsqmDo/qpeo4rUBJSIw7oB/NfYdOe00+R7P1EQUpD3rj5id6lkl83ipEHP2Pt7O/mTKpLCTfFUpFVi3XOANkGMUx0n5xemc8Qciwvr3zgJTYlt3Pv/wQPlHMpnLsuy9Ea6gUVu+DBI5z5d0vUI6ns0l49xbRWSTY3YHyrWlQKIRhVeQwtkWx9bUiOoPXg1LC+PXrJbdWsJ9pj+/A2gNzP062vB4rYYS1FLWPEtnf9y8HVHFvxQb469yTWBCqFtw8m7AJHbMhIuKkNMhjxP9B+V7onqARw5ZSecla8/JQqSA2pGfAUul1PY1a0uJK6E+svOrcfCPyRFble/2nGuDs3K+g6P4j6TkCJk5HrpPD+KlS1BHPVDNBZE/y
 SQJJTxu1
 Blgr7TUf8gcP0tvPcubfwKzugRMd85Bkyk9WzIsJ6pmwLcGXsWPaS5Ow8p5rmQHG16AkyCqefIPyJ6tn9uCKjlgartmM6qK6sg7MV1ywvFQgL/Q+yB872TdNeNxw98NgkZTanpnByQ5WJW6PeDL7q9rR8jDYeTMOhmWxB1g5WiKvKEWHEcp8pm06i/YEtEW08ay1s3HpiRjvQd27IEFN0vTkfmzgEKqMDQVWZUjBpMMNRqjQaLW0glQyvUboR9M8QJA3ym+H2zCFOalgBwPGnebHMkOcpEezPMwSTg6xx0ctMxsrljEmo8MM99fUP+lrtS8gA1qBml3+hvHWGABER7OP/+K/6L+IC2B/8tfbqGOqQv9aShdVWrSa32oWDz5YwPSnMc4BJA+wHUbCPWv5dfSQbI8x0mWoe71u0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Dec 2025, at 6:13, Shivank Garg wrote:

> Convert result variables and return types from int to enum scan_result
> throughout khugepaged code. This improves type safety and code clarity
> by making the intent explicit.
>
> No functional change.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/khugepaged.c | 111 +++++++++++++++++++++++++-----------------------
>  1 file changed, 57 insertions(+), 54 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

