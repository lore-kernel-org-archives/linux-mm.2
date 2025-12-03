Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED2FD1CDAB
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BF66B0029; Wed,  3 Dec 2025 18:12:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23396B002A; Wed,  3 Dec 2025 18:12:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9134C6B002B; Wed,  3 Dec 2025 18:12:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B55C6B0029
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:12:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 209625B60C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:12:58 +0000 (UTC)
X-FDA: 84179712036.21.8A7E06C
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011012.outbound.protection.outlook.com [52.101.62.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 162D18000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:12:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vBi4DuFt;
	spf=pass (imf02.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.62.12 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764803575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkB3o/wUQUGgj8yiFLlo5lC3iVP67ZDWW2Guef4y+Iw=;
	b=vnu6gbjRb7GIEx5RhYH0Sh4ev5n63uL26We7pbMpVKFMX6Uo6ZNT9YveLxiQRIAk3uLEy8
	1J2l2XpqdQLAs4NwVDi8YaEPw7hqFN+RWPZ3nXlLdmyn4vGvyRNmOUfvJM1KTYJvAfgovl
	W7zVEHU2KFqg0+unKbfP+BJMYHih5+A=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vBi4DuFt;
	spf=pass (imf02.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.62.12 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764803575; a=rsa-sha256;
	cv=pass;
	b=H/YJmWFIYu3NiteoIFxsEzBZcwiJkAPs+wmoeZtUD7ROnGeRwCOVyl/Cszy+7STuo5qGTh
	ubR+e/EI/+TCYwzl7yEuMvsTSMRkJUJ6AMmCHurM2va3oSaoDaZg/947PZ7HfZZQVwMAIN
	EbWBxmpqo38+G1l3F4e5bXFh15/1HgI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hrqec/H7P8jMTrc5KGEmbO1oSTulGaF3s3gg9WI2h4l/Cc2XZxrTAZLK4TGLtyhp0BR1mKOUnUjtE7LJW5uu60Y/NT2dnxuMae750rGihszrctStFWbycFYHwcIHyDX+PRPTbtW0Wag7AoWkfZ54Wtij66HknJQg+keXcTcsph86g/oMVRiw2cgXBVUpU+uNxQSdKf9V+584bXO30aQtb/lVIApZHXXi81sBTAtwfv6jcXgUAamElBmfYZJKvw/uDvssbpFZoAIR7qCCD0bGbivQTEP9PEv6IrfVAIFEdEwcOhuaiZXVl+v/WliAA4ENmHSxH5B5lW6pJIIBUHgE/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkB3o/wUQUGgj8yiFLlo5lC3iVP67ZDWW2Guef4y+Iw=;
 b=Gx7PQNwD9jTK8CfY3NDm7YMHLoih28bWLayNqpnSYQk/+38jrMkb/xn3v0uRWfmaxY9EnE5Z/Ui0/Nphti4JvmgQVug9X8HXpj4pD0k9JEWFskIGH5T3QICKql0Dx8W6pKF3mwGoxX6jZZWrWYsxnOMxKOLONG50Wcy7CuLaMtbsMTUrrA5H7bdDLuj2mruKsNJvAb40UsHTMUqLu0RrMgDVVWqIe7MYyMlclvEKrA25QXn0fhbbjUdg3eKRYzeGMxdXxa/BqVwxo4oEO8+a0MsE3Soda+z6S8lWR4C93OPND5jJVNo1xWrtSb4GiRM5jirI7A0MGYIOa6QZNcWqXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkB3o/wUQUGgj8yiFLlo5lC3iVP67ZDWW2Guef4y+Iw=;
 b=vBi4DuFtziaH/ISy9W36a2Dbnb3XGrPWFtESrtJ+L7xUsW+nJ70E23fVwKGgSXh77Rzi70hJvcMrRp15o6s32b6qbeAElWQsmlXQtklflvL7E9BvAXJvwCrkZf/CEZ6Cyf3vwUMopK6WR2q3MfxjPtLAxfAyZHN1Tm7o0FmPwJE=
Received: from SJ0PR03CA0364.namprd03.prod.outlook.com (2603:10b6:a03:3a1::9)
 by SJ2PR12MB8134.namprd12.prod.outlook.com (2603:10b6:a03:4fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.16; Wed, 3 Dec
 2025 23:12:48 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::de) by SJ0PR03CA0364.outlook.office365.com
 (2603:10b6:a03:3a1::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Wed,
 3 Dec 2025 23:12:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Wed, 3 Dec 2025 23:12:47 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 3 Dec
 2025 17:12:47 -0600
Date: Wed, 3 Dec 2025 17:12:08 -0600
From: Michael Roth <michael.roth@amd.com>
To: FirstName LastName <vannapurve@google.com>
CC: <ackerleytng@google.com>, <aik@amd.com>, <ashish.kalra@amd.com>,
	<david@redhat.com>, <ira.weiny@intel.com>, <kvm@vger.kernel.org>,
	<liam.merwick@oracle.com>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <vbabka@suse.cz>,
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20251203231208.vsoibqhlosy2cjxs@amd.com>
References: <20251203142648.trx6sslxvxr26yzd@amd.com>
 <20251203205910.1137445-1-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251203205910.1137445-1-vannapurve@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|SJ2PR12MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b5bd549-8c54-48d0-f9d4-08de32c1795b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?37hGoggHpEaaP1OLqEx6y9S1J+2wib7+vpQAKQMFyoufIx/+OL/A026b3cHG?=
 =?us-ascii?Q?N4F3LhwClxLEyvO7Fi99hcln9ExaXIfqhM/3o7oM9nhEHpnk5zggdbwIqWUo?=
 =?us-ascii?Q?etvvHiP7TGHVd0In/Sz3o3UCBld0C02spnOT+WNksxpN3O1hLWvIl88x3Zri?=
 =?us-ascii?Q?f4ditmS4AtYESwYGh7y1uZuLb+ZcI22nWOVpPgdyv2oO+zmd2g1JhE0fuSh+?=
 =?us-ascii?Q?SiWp9KpumiuvGSWvPsb0Vy0Xw34Rpz6caDtd1N6Lhpu3xU/GT/GKN8ATxACL?=
 =?us-ascii?Q?jstaxINNREZHyeKg9cJqQPP5Cn7mM+pPNZLRj3wx2CUQd4RuVc2yD023jDfw?=
 =?us-ascii?Q?Fp/7tPGJZzluN3M7Bo3RofOXHWEJnC8XOyhiq5hmSWAP/1btc6X6t9Knvyra?=
 =?us-ascii?Q?nGZ3wNdNcfJ+H4+Ovi3Np04CEBqJpXDRsl3HI8Md4SC5snbBjEvu932iUwge?=
 =?us-ascii?Q?F1GWT7hrrBbcyfgXxi/vc+SfbBEmDKHWxQ4450drsekw8X7L3s+WjPM9RCv3?=
 =?us-ascii?Q?+T9w6KvTYzWucutZSpJFxcmcx6urJDxm0qC+G4o0nDdZgV+d016cgBNL2mAW?=
 =?us-ascii?Q?oLmaejHaBhey+6p8VpuE2OKKsrDPV/e+IMigyVJlkYFEOFACl3yRvRAcXtYt?=
 =?us-ascii?Q?gYstA/HSHzNhW46X0SG06sJCabH38rnsPEvwcJ8cu7D1lU+BErnInXeNItUF?=
 =?us-ascii?Q?M1Psn2q5UBbPwic/kkUcUvcx98vOLv0PEyVknZ+GbFiFjYb4pjv68BTmzrO9?=
 =?us-ascii?Q?SqrjZFzzuPrmgslMNnkxrgJp9NZppAqUV8GUcNawTYsvC44T/9Vlh5ZskdIU?=
 =?us-ascii?Q?D9YoPngTE9wCz2FRaPJAlhfDNTS8SWSl34JsjycWw/Fe9kRjzIi+QMo4evSP?=
 =?us-ascii?Q?CRyurvrcjbKD603ahkUqAVdBETl41NVfDdlWebtQz9zKGNJz6hFoYoaq70It?=
 =?us-ascii?Q?eka1mebN0TpC5vVTt15BdmWI/qETVE7j9p+1+uGbPJlZRcV+4IG/1sI+p0eY?=
 =?us-ascii?Q?t5KkWZP26qqwn6aHaexaX1uPqh9/5hmQhydcbNBOFY0tL/QanhpuPp0BjEEC?=
 =?us-ascii?Q?SjM5bK8VuGAhzGipi964rkbrXlL4xQrw8hIZpjrhuGG6Fd0EgoXV2n142zS1?=
 =?us-ascii?Q?+HgfgwmH3mhetMeUgfAAEKy5Ctb1pOVhLiphc7gFiO9j7jXP+kMZojEw3i+f?=
 =?us-ascii?Q?Sx66U8AkSMY8c53ttxdyBt4Os16/phv2+zYgifZVYafkA75Zad99IIEh1qZJ?=
 =?us-ascii?Q?/M0JcPNaMUfaE/hc9bmpxDETkdDkYAtf6I0E0XvcSF5rTURV6VkrsWMcNz3b?=
 =?us-ascii?Q?ssRynG76Ir+LZ6Zuzo8Rj72LlgelDQNQokjs+/dfqjqsFRs/o+ID9VtGf0iD?=
 =?us-ascii?Q?O999TcCQ6PVxFX6MRZwiIUDBqpIrJUVDmbjLqvWiANcgV13Z/RUvKyi8bNHB?=
 =?us-ascii?Q?/HTU1moCTxEidBe+5wVkBKOjBNdrRg5dQ8gKDx5PCqnHPcr8jit1IaT6KWOg?=
 =?us-ascii?Q?iCsZEnC2osttjD8keSb7+a6TfjL4lyk2yR+GC9uChuKs3LnuTZuMn2f0xzbb?=
 =?us-ascii?Q?dBQtG0GRlLdjIV+u6DE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 23:12:47.7992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5bd549-8c54-48d0-f9d4-08de32c1795b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8134
X-Rspamd-Queue-Id: 162D18000D
X-Rspamd-Server: rspam02
X-Stat-Signature: ycmpsu6teaaijgu5ue6i15o8f3okzg7n
X-Rspam-User: 
X-HE-Tag: 1764803574-656728
X-HE-Meta: U2FsdGVkX19DhUSCKSiFJiM7XqLKpxi2XgIS7/rXWQYi/2hSOOSiBh0iUXNbVaTvkq2f/NC/S2WOu4KdOwUXfEONqrd2X4Lka/JwTuMy88rrfiS92meSrHTMxu/NY5GNR+pP0K4becA51qXTXkvEYFTuGIWTBv21hDPPm+GRcPi4HFd8s3+B77mefr+vHIHR3d71ULlENr1EruZVzjtxvRgNSbw4F31ppLXLfofdgZeGxwCNaent/9VjF4PkoUzCZGHH0+7RpWu8kNicdj6ToBwXwUoK1a7osDOkllxs6GOKhGT9A4wGBpnnjilXwt3VEjvvvtvNymOjzE1ckrMdqEpbx6CzgwExWIODym+YLHgq6RwJgO0nXn7BG/yuwR4nyZ7fu++di6V4vK5ou6tAqeosvTnJBHbhRdtdwBdAycOBH9hI81vs2VPGRE3jYX7cCOusIYeQ6GDldHy7PCg5JQls3pyV7L9J5kUzZLFFlAWRvrb9a+LpwwTNgCk0CqSZUVZS42sKOIxUMYE5MFflQXNERnofzon74Db8TRoBOEBop8ldSN9kPFRnYtqmKCSX4i7iu34OzdGlcccW8pmMqGg8L+DrDgGxI9fxdXPkbGFFX5T02mmXFC3DfHnfP6lVb4MVS6Qzijj0xLa8CPQ5LCc4T5CA9SJkFME06d4ftrvVcCueC/T6BhMSg8kU5MkGK+duoEbRI64g2/vPXNXy2MSD9d0MSUyilP9NyY7GtMZt3Zk2VDt3CDx1ohlUidf9dvcoqrXomCB2q3mQ3xPv5AUNyaR1rG0bN7QAvXjPXlOfI4rV9S+9YClPhTc38Mpzkg8pLc6onLFDjSMt5wM7JpjAI4EDp/dlpqFzTKX6dQ7V5T/DLIUZVNbvg48gUsdd39f8AqQKqDKetTfKYx/acSyn4I03Qdj4ggBnKr5I3AGhftmp876hTivx2FFbvuoZIB6F/EO3SBLrr/5Q971
 NSJWCw4S
 OlR8jqrEIApo31FNY+LHUi9MdsLiXOHG4ggj0Ptl8X/NnRBtLTAdeNokhXoaI+GaqcQTK/SZzUI58QFc6JtPli1bolZqrTw36LJhw/wdcoe+WqmBa3pJbXZ3BOSo5wsj8voY+Vv4yZ/as/0Ke7MStSdyvgKJ03p4Swhv3QkM0CwfGQjsJw3DNJsf+xD/gxmxNQS1MZiwSJlTz1+QXP/dIPGB8L7EcygfzyPuPo+UZF4Ol4tCQE80IVhSo+5ynABjnpy5kuFZ01AUs0DeJ/JwX+b10iOGqTj4B/xL49rBU2IPQi1tz9xl+r4u5Cf1ZsiM4RH8r767j0VHBXCTMaXk820qEclUjjikdyH7cHF6psFnd2dLLLgN+Xr1zSQ4Adj+fo6hXEKmqvIzf2ClZH7E0LLTq9E33/fQFfMtHzhoes0tbIPyNKwiQOdszliEA14tBUJGCuQh5rc39KW9E39d1/KUtCgBOAB6YRdsUISEfi/ijjJiC5y4ih0fjnMLej5su0Z5bPsXVS27gtM/QF+Y8mQc/pQzYlcOtMZOJwIMqCIr94ZvnQpnXPG4hXM6gthd9ey1EdlMDz9pbpyb4DlvhCi9ZxDDL8vgorNwl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 08:59:10PM +0000, FirstName LastName wrote:
> > >
> > > > but it makes a lot more sense to make those restrictions and changes in
> > > > the context of hugepage support, rather than this series which is trying
> > > > very hard to not do hugepage enablement, but simply keep what's partially
> > > > there intact while reworking other things that have proven to be
> > > > continued impediments to both in-place conversion and hugepage
> > > > enablement.
> > > Not sure how fixing the warning in this series could impede hugepage enabling :)
> > >
> > > But if you prefer, I don't mind keeping it locally for longer.
> >
> > It's the whole burden of needing to anticipate hugepage design, while it
> > is in a state of potentially massive flux just before LPC, in order to
> > make tiny incremental progress toward enabling in-place conversion,
> > which is something I think we can get upstream much sooner. Look at your
> > changelog for the change above, for instance: it has no relevance in the
> > context of this series. What do I put in its place? Bug reports about
> > my experimental tree? It's just not the right place to try to justify
> > these changes.
> >
> > And most of this weirdness stems from the fact that we prematurely added
> > partial hugepage enablement to begin with. Let's not repeat these mistakes,
> > and address changes in the proper context where we know they make sense.
> >
> > I considered stripping out the existing hugepage support as a pre-patch
> > to avoid leaving these uncertainties in place while we are reworking
> > things, but it felt like needless churn. But that's where I'm coming
> 
> I think simplifying this implementation to handle populate at 4K pages is worth
> considering at this stage and we could optimize for huge page granularity
> population in future based on the need.

That's probably for the best, after all. Though I think a separate
pre-patch to remove the hugepage stuff would be cleaner, as it
obfuscates the GUP changes quite a bit, which are already pretty subtle
as-is.

I'll plan to do this for the next spin, if there are no objections
raised in the meantime.

> 
> e.g. 4K page based population logic will keep things simple and can be
> further simplified if we can add PAGE_ALIGNED(params.uaddr) restriction.

I'm still hesitant to pull the trigger on retroactively enforcing
page-aligned uaddr for SNP, but if the maintainers are good with it then
no objection from me.

> Extending Sean's suggestion earlier, compile tested only.

Thanks!

-Mike

> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f59c65abe3cf..224e79ab8f86 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2267,66 +2267,56 @@ struct sev_gmem_populate_args {
>  	int fw_error;
>  };
>  
> -static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> -				  void __user *src, int order, void *opaque)
> +static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +				  struct page *src_page, void *opaque)
>  {
>  	struct sev_gmem_populate_args *sev_populate_args = opaque;
>  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> -	int n_private = 0, ret, i;
> -	int npages = (1 << order);
> -	gfn_t gfn;
> +	int ret;
>  
> -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
>  		return -EINVAL;
>  
> -	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> -		struct sev_data_snp_launch_update fw_args = {0};
> -		bool assigned = false;
> -		int level;
> -
> -		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
> -		if (ret || assigned) {
> -			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
> -				 __func__, gfn, ret, assigned);
> -			ret = ret ? -EINVAL : -EEXIST;
> -			goto err;
> -		}
> +	struct sev_data_snp_launch_update fw_args = {0};
> +	bool assigned = false;
> +	int level;
>  
> -		if (src) {
> -			void *vaddr = kmap_local_pfn(pfn + i);
> +	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
> +	if (ret || assigned) {
> +		pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
> +			 __func__, gfn, ret, assigned);
> +		ret = ret ? -EINVAL : -EEXIST;
> +		goto err;
> +	}
>  
> -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> -				ret = -EFAULT;
> -				goto err;
> -			}
> -			kunmap_local(vaddr);
> -		}
> +	if (src_page) {
> +		void *vaddr = kmap_local_pfn(pfn);
>  
> -		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> -				       sev_get_asid(kvm), true);
> -		if (ret)
> -			goto err;
> +		memcpy(vaddr, page_address(src_page), PAGE_SIZE);
> +		kunmap_local(vaddr);
> +	}
>  
> -		n_private++;
> +	ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> +			       sev_get_asid(kvm), true);
> +	if (ret)
> +		goto err;
>  
> -		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
> -		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
> -		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
> -		fw_args.page_type = sev_populate_args->type;
> +	fw_args.gctx_paddr = __psp_pa(sev->snp_context);
> +	fw_args.address = __sme_set(pfn_to_hpa(pfn));
> +	fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
> +	fw_args.page_type = sev_populate_args->type;
>  
> -		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> -				      &fw_args, &sev_populate_args->fw_error);
> -		if (ret)
> -			goto fw_err;
> -	}
> +	ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> +			      &fw_args, &sev_populate_args->fw_error);
> +	if (ret)
> +		goto fw_err;
>  
>  	return 0;
>  
>  fw_err:
>  	/*
>  	 * If the firmware command failed handle the reclaim and cleanup of that
> -	 * PFN specially vs. prior pages which can be cleaned up below without
> -	 * needing to reclaim in advance.
> +	 * PFN specially.
>  	 *
>  	 * Additionally, when invalid CPUID function entries are detected,
>  	 * firmware writes the expected values into the page and leaves it
> @@ -2336,25 +2326,18 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  	 * information to provide information on which CPUID leaves/fields
>  	 * failed CPUID validation.
>  	 */
> -	if (!snp_page_reclaim(kvm, pfn + i) &&
> +	if (!snp_page_reclaim(kvm, pfn) &&
>  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
>  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> -		void *vaddr = kmap_local_pfn(pfn + i);
> -
> -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> -			pr_debug("Failed to write CPUID page back to userspace\n");
> +		void *vaddr = kmap_local_pfn(pfn);
>  
> +		memcpy(page_address(src_page), vaddr, PAGE_SIZE);
>  		kunmap_local(vaddr);
>  	}
>  
> -	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> -	n_private--;
> -
>  err:
> -	pr_debug("%s: exiting with error ret %d (fw_error %d), restoring %d gmem PFNs to shared.\n",
> -		 __func__, ret, sev_populate_args->fw_error, n_private);
> -	for (i = 0; i < n_private; i++)
> -		kvm_rmp_make_shared(kvm, pfn + i, PG_LEVEL_4K);
> +	pr_debug("%s: exiting with error ret %d (fw_error %d)\n",
> +		 __func__, ret, sev_populate_args->fw_error);
>  
>  	return ret;
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2d7a4d52ccfb..acdcb802d9f2 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3118,34 +3118,21 @@ struct tdx_gmem_post_populate_arg {
>  };
>  
>  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> -				  void __user *src, int order, void *_arg)
> +				  struct page *src_page, void *_arg)
>  {
>  	struct tdx_gmem_post_populate_arg *arg = _arg;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	u64 err, entry, level_state;
>  	gpa_t gpa = gfn_to_gpa(gfn);
> -	struct page *src_page;
> -	int ret, i;
> +	int ret;
>  
>  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>  		return -EIO;
>  
> -	/*
> -	 * Get the source page if it has been faulted in. Return failure if the
> -	 * source page has been swapped out or unmapped in primary memory.
> -	 */
> -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> -	if (ret < 0)
> -		return ret;
> -	if (ret != 1)
> -		return -ENOMEM;
> -
>  	kvm_tdx->page_add_src = src_page;
>  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>  	kvm_tdx->page_add_src = NULL;
>  
> -	put_page(src_page);
> -
>  	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
>  		return ret;
>  
> @@ -3156,11 +3143,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	 * mmu_notifier events can't reach S-EPT entries, and KVM's internal
>  	 * zapping flows are mutually exclusive with S-EPT mappings.
>  	 */
> -	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> -		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
> -		if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
> -			return -EIO;
> -	}
> +	err = tdh_mr_extend(&kvm_tdx->td, gpa, &entry, &level_state);
> +	if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
> +		return -EIO;
>  
>  	return 0;
>  }
> @@ -3196,38 +3181,26 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  		return -EINVAL;
>  
>  	ret = 0;
> -	while (region.nr_pages) {
> -		if (signal_pending(current)) {
> -			ret = -EINTR;
> -			break;
> -		}
> -
> -		arg = (struct tdx_gmem_post_populate_arg) {
> -			.vcpu = vcpu,
> -			.flags = cmd->flags,
> -		};
> -		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
> -					     u64_to_user_ptr(region.source_addr),
> -					     1, tdx_gmem_post_populate, &arg);
> -		if (gmem_ret < 0) {
> -			ret = gmem_ret;
> -			break;
> -		}
> +	arg = (struct tdx_gmem_post_populate_arg) {
> +		.vcpu = vcpu,
> +		.flags = cmd->flags,
> +	};
> +	gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
> +				     u64_to_user_ptr(region.source_addr),
> +				     region.nr_pages, tdx_gmem_post_populate, &arg);
> +	if (gmem_ret < 0)
> +		ret = gmem_ret;
>  
> -		if (gmem_ret != 1) {
> -			ret = -EIO;
> -			break;
> -		}
> +	if (gmem_ret != region.nr_pages)
> +		ret = -EIO;
>  
> -		region.source_addr += PAGE_SIZE;
> -		region.gpa += PAGE_SIZE;
> -		region.nr_pages--;
> +	if (gmem_ret >= 0) {
> +		region.source_addr += gmem_ret * PAGE_SIZE;
> +		region.gpa += gmem_ret * PAGE_SIZE;
>  
> -		cond_resched();
> +		if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
> +			ret = -EFAULT;
>  	}
> -
> -	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
> -		ret = -EFAULT;
>  	return ret;
>  }
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d93f75b05ae2..263e75f90e91 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2581,7 +2581,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
>   * Returns the number of pages that were populated.
>   */
>  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> -				    void __user *src, int order, void *opaque);
> +				    struct page *src_page, void *opaque);
>  
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
>  		       kvm_gmem_populate_cb post_populate, void *opaque);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 2e62bf882aa8..550dc818748b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -85,7 +85,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  				  gfn_t gfn, struct folio *folio)
>  {
> -	unsigned long nr_pages, i;
>  	pgoff_t index;
>  
>  	/*
> @@ -794,7 +793,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		return PTR_ERR(folio);
>  
>  	if (!folio_test_uptodate(folio)) {
> -		clear_huge_page(&folio->page, 0, folio_nr_pages(folio));
> +		clear_highpage(folio_page(folio, 0));
>  		folio_mark_uptodate(folio);
>  	}
>  
> @@ -812,13 +811,54 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>  
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> +static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> +				struct file *file, gfn_t gfn, struct page *src_page,
> +				kvm_gmem_populate_cb post_populate, void *opaque)
> +{
> +	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> +	struct gmem_inode *gi;
> +	struct folio *folio;
> +	int ret, max_order;
> +	kvm_pfn_t pfn;
> +
> +	gi = GMEM_I(file_inode(file));
> +
> +	filemap_invalidate_lock(file->f_mapping);
> +
> +	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> +	if (IS_ERR(folio)) {
> +		ret = PTR_ERR(folio);
> +		goto out_unlock;
> +	}
> +
> +	folio_unlock(folio);
> +
> +	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> +				KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +				KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +		ret = -EINVAL;
> +		goto out_put_folio;
> +	}
> +
> +	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
> +	if (!ret)
> +		folio_mark_uptodate(folio);
> +
> +out_put_folio:
> +	folio_put(folio);
> +out_unlock:
> +	filemap_invalidate_unlock(file->f_mapping);
> +	return ret;
> +}
> +
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>  		       kvm_gmem_populate_cb post_populate, void *opaque)
>  {
> +	struct page *src_aligned_page = NULL;
>  	struct kvm_memory_slot *slot;
> +	struct page *src_page = NULL;
>  	void __user *p;
> -
> -	int ret = 0, max_order;
> +	int ret = 0;
>  	long i;
>  
>  	lockdep_assert_held(&kvm->slots_lock);
> @@ -834,52 +874,50 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	if (!file)
>  		return -EFAULT;
>  
> -	filemap_invalidate_lock(file->f_mapping);
> +	if (src && !PAGE_ALIGNED(src)) {
> +		src_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +		if (!src_page)
> +			return -ENOMEM;
> +	}
>  
>  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> -	for (i = 0; i < npages; i += (1 << max_order)) {
> -		struct folio *folio;
> -		gfn_t gfn = start_gfn + i;
> -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		kvm_pfn_t pfn;
> -
> +	for (i = 0; i < npages; i++) {
>  		if (signal_pending(current)) {
>  			ret = -EINTR;
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> -		if (IS_ERR(folio)) {
> -			ret = PTR_ERR(folio);
> -			break;
> -		}
> -
> -		folio_unlock(folio);
> -		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> -			(npages - i) < (1 << max_order));
> +		p = src ? src + i * PAGE_SIZE : NULL;
>  
> -		ret = -EINVAL;
> -		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> -							KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> -			if (!max_order)
> -				goto put_folio_and_exit;
> -			max_order--;
> +		if (p) {
> +			if (src_page) {
> +				if (copy_from_user(page_address(src_page), p, PAGE_SIZE)) {
> +					ret = -EFAULT;
> +					break;
> +				}
> +				src_aligned_page = src_page;
> +			} else {
> +				ret = get_user_pages((unsigned long)p, 1, 0, &src_aligned_page);
> +				if (ret < 0)
> +					break;
> +				if (ret != 1) {
> +					ret = -ENOMEM;
> +					break;
> +				}
> +			}
>  		}
>  
> -		p = src ? src + i * PAGE_SIZE : NULL;
> -		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> -		if (!ret)
> -			folio_mark_uptodate(folio);
> +		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, src_aligned_page,
> +					  post_populate, opaque);
> +		if (p && !src_page)
> +			put_page(src_aligned_page);
>  
> -put_folio_and_exit:
> -		folio_put(folio);
>  		if (ret)
>  			break;
>  	}
>  
> -	filemap_invalidate_unlock(file->f_mapping);
> -
> +	if (src_page)
> +		__free_page(src_page);
>  	return ret && !i ? ret : i;
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> -- 
> 2.52.0.177.g9f829587af-goog
> 

