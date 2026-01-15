Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B245D4661F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4436B00F9; Thu, 15 Jan 2026 15:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B486B00FB; Thu, 15 Jan 2026 15:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7EB06B00FC; Thu, 15 Jan 2026 15:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92C036B00F9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:43:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2791614048B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:43:11 +0000 (UTC)
X-FDA: 84335372982.11.1B8A0EC
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FF2A14000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:43:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Yl9B21fh;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.61.20 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768509788; a=rsa-sha256;
	cv=pass;
	b=4DNQCGD4IAhBgduL9SpSFRIDIshrL+ADzZpj+ZSI68FdB00M1i9OyqjV6eh6q7t7e+ClA0
	NAi+dHtFQayxtgJA8lWKi1ncexBDp+wdbBsbgzMyMx8udaJWtqAsSshRMey5tqdYbwlqlQ
	U2ehyvqR/lXRtwGVDlg+p649Z/mFtHo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Yl9B21fh;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.61.20 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768509788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tG6aswMrZLskA8xDWMPUlmKN0wZHXUv5UIvJUGo0bg=;
	b=2n8dtjavEsP2+28P7NeyqqFya/jZo44fqWs72cVoi6fcA4JtY2Mi0MbPbnsul04amqDhfa
	z9tgHL5Z6mzf5o0C4h0b30iZBq0RgU22OcbdFep3btuIegQJikBsozjdTvzAhU5y2SxP73
	MMIa7NHItepmqj6Td2+c456cPNAu2FA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AP77vAii7jqFJt3vgEpRWFCc3frxmIlr3JQQn9lgZ15MrBctEDNVX2lkCD1+TQ8OtsncCXqm74rDLDLA1it0D6xHDI7tfuZ0yyVEm75WZmYCu0QwzY61J9LsaIiuIZ9iLvhkrlPEcw9uJDeiogb++ivsURLuOmqgGl5/yVkcmT9qbq6OIpd3QfC3s2u2gdeUVEgy0LKw1HPMbQUXy9XNog3MED0EiFwZ8znJsdzb83UpHYCFY7anKIPiUTmJbtSziKiJR8AmqvikFqjY5L8hQATxtpOzb/+y9Htvo3XH2r7t8fGDuac3Fp9qSF4Rmpxp5PWNac12qRssgmwf6By25g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tG6aswMrZLskA8xDWMPUlmKN0wZHXUv5UIvJUGo0bg=;
 b=YZ/ZmC0Tsq+Hi2y1vcx9Vm63ZhSiHeyRp4TzfF9Gx6pTnvKZ9PqRcvKHqRekz2sSyA/JhUezAExFbi0Ls4Mjmv3iS0C9JJ2+0IXkbRz6yiAptvaADQPuf7cemx4MUdD4X7Rrh6VNIjyMoZRt7mVRlTVpwdbTm3oRBlZrKvV505LAo64pnTMyNhqSNJ1VEugWKf5Mdlp60BolTbQ/C6kOQVVQsNwGA1j3ECHtlN2z0pxXRFvpxEOl1/VYmyMHAhDpX7mUpnbRqiwy+TM6pgV+8qWncKoa8dIDO53UEhaTX20SRFs5Ladeue9ssDEy2KXZt9YzTH6EfHU+HIHACB88gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tG6aswMrZLskA8xDWMPUlmKN0wZHXUv5UIvJUGo0bg=;
 b=Yl9B21fh2oQZ166h/DkJWbvbMoyqGNzrdt1Oo1obBHgU5+RXR69fTEM9+rr+PvMrSCS/LJoL0Aaxl3Gdn/KMvYFGysclJ5pgij5KlFpA8gIPBzhdzh1g8lfEj9KiSbvlLicDAGnd+GE6D+v7osUzSpDkhvLnsEPGoPb3+u1n1aQ=
Received: from DM6PR02CA0084.namprd02.prod.outlook.com (2603:10b6:5:1f4::25)
 by BL3PR12MB6620.namprd12.prod.outlook.com (2603:10b6:208:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Thu, 15 Jan
 2026 20:43:04 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:5:1f4:cafe::15) by DM6PR02CA0084.outlook.office365.com
 (2603:10b6:5:1f4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Thu,
 15 Jan 2026 20:43:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 15 Jan 2026 20:43:03 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 15 Jan
 2026 14:43:03 -0600
Date: Thu, 15 Jan 2026 14:42:48 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <vbabka@suse.cz>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>,
	<yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, Kai Huang
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 2/6] KVM: guest_memfd: Remove partial hugepage
 handling from kvm_gmem_populate()
Message-ID: <20260115204248.q234qzaj5f3flpw3@amd.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-3-michael.roth@amd.com>
 <aWk9PusYNW0iADuD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWk9PusYNW0iADuD@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|BL3PR12MB6620:EE_
X-MS-Office365-Filtering-Correlation-Id: 447c09c7-1556-4b3a-919f-08de5476ae38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3PpsgVBySXSmXo8W6K+F0L/CNBPQjOz+9bhCMh+4b+Vm9RoW0eCTz2N7207g?=
 =?us-ascii?Q?m2fp87BeGBvXlWDM4YQ1zJaTCLxTQWJGKmalmBBsvWz9343z5X3kZwdgkRwd?=
 =?us-ascii?Q?14m08gjOdFQVbM9/azvwaQwNuB72BA7iQqbqC3qeMyhu6LtrVQO3gq9mU3cW?=
 =?us-ascii?Q?fUe8FYBxJiVDYT6LSWmOp7LcQR7FRWgOu/OhZsAnx2hHND/fgVjl8xnu7DJO?=
 =?us-ascii?Q?I90ETg6TkFq2yqkEtO0d86QKrLuLSuZLQoGJcfXSrY6NszSsuVXNcx6sYwlz?=
 =?us-ascii?Q?Ve+QNGl+KmIqb/R5OV3uHXNKPMedAL+TVc9z1qtcj5lA7v6mNhmPbBpl17hs?=
 =?us-ascii?Q?SOGRbzb4LL1NgOZ9IMm7g0b1TZwpcfGQfJXwJNuHu97or+uxDc1X1aSXw9Aw?=
 =?us-ascii?Q?YKinH+lA/MaFkmgABmxlVJewX6H7uP14EmEQxMJax6zF1dtJhFPRzpW6Cryz?=
 =?us-ascii?Q?gJkrdYctxM7fOzi1CzlXd4en/3bFrg8BRHDmAmpktsZ4kQdrxbGpsfhj60I9?=
 =?us-ascii?Q?mmucTdvvtOHlG/W9amWL5K9wGmM1k4Wwn61m+2Q/lLuW5slnGuYr2xH8V8w1?=
 =?us-ascii?Q?pNndjKhrA55fhS5Y/iR7XCHb6YxadPYdasys5ke0dNdz5wuLIpW9FtD97mPG?=
 =?us-ascii?Q?RMI0BxGopQkAvldetyfRa2R78fuzTQL2nw278o7chFwp3g8RWUMVtkKXF+L7?=
 =?us-ascii?Q?do8EdJRwH2eWrPPfwZsJmjdSH6HmLjW20LHSMWBE+UWFk0wh5myntqqZCYxl?=
 =?us-ascii?Q?zdIEjJkr/xZDtcppPpl75uJVAlqUV9w+u6y2JkvgEDr5fEVtbBc/l3JIfjIN?=
 =?us-ascii?Q?O3O5b6D3XZu0yrUF8pYoMh2t7XSYmOCVi+/Kr/KZBeV68CUiooouW6/3ysJj?=
 =?us-ascii?Q?kwZeGZLHAMj1seJYT99WFWn+DUweSgAQvjk/tnfx6h6lB4TcRYmHfLR6vq9H?=
 =?us-ascii?Q?BQUYbP4RiCW2/3Z6Q6eEvVvj2fQX454f6O650tQWec0zLZe0e/GRkP1oPUrb?=
 =?us-ascii?Q?/nB0i1/fcj7gGtY4L+jKKZ6vGiI+Ipa23KrcX2MJ3Aqvqwg5Eq6ztyL1zYiT?=
 =?us-ascii?Q?ZbNyX89OZhgXxnE3bXRXGXG0W0V34nhaxR211y1CBvrjVKoIpeFAdpscQXzh?=
 =?us-ascii?Q?NtH4aK+A6LPQVmI0aP8zNVqKrKI8VDGOHpXzlTfsfIAvdBGTY9FzswxFXLuk?=
 =?us-ascii?Q?hAatSDHbAM7AjmsXYzKgbt7ccXkIkiBpxSR2DyxQCArlRcpOfi47Gjacd+4T?=
 =?us-ascii?Q?cTDNfjhZ4D0QWYjgRkYh7Pc0FgwFOjOmeMyxRk4WxxWFvBNwJW41xUEB5bzh?=
 =?us-ascii?Q?fMRkKKrRQKhLCL1AEkK//Tku5EqGiXnhcLbfITbNQiBax6Cn236X2XCUw0mj?=
 =?us-ascii?Q?a6qD+1Bw/xryi9Udk8YwCFjTY1tu+IU5EwckcjxaZ/BvM0yqSoxIFldktl0z?=
 =?us-ascii?Q?uiiyDjYH2ofnKV2ak48/FJz7jncfHoNdGgcW1hOVaNyowxCgC6fYuG8NLkx9?=
 =?us-ascii?Q?2som2s+QZ83phyEv/eG7py67g9pY/qx1rT1kp2HBeRlKXRxfhVo5Ja9pL8Zf?=
 =?us-ascii?Q?4KzeceWaRXpq61xOjHLZk4t2eWnwuBje1RXy8Phymhfg81SxV8XCDzMC91xB?=
 =?us-ascii?Q?q+zN5xJvsYP3OkLfVwLB8G/Ti7uEYn0ZxN0kqsiD1+XCcpS/cFfD0e3Lnyaa?=
 =?us-ascii?Q?W/0cKQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 20:43:03.8316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 447c09c7-1556-4b3a-919f-08de5476ae38
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6620
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3FF2A14000A
X-Stat-Signature: x1x113sygh1bqpx8jayb9cwe6ah1neqh
X-Rspam-User: 
X-HE-Tag: 1768509787-496340
X-HE-Meta: U2FsdGVkX18tq0GVoE7n7WVVqdJgZEBPwvS9/UxdFt38A2ZxuTm4wpTTqr8hyw4TUJb5GrG4lJcSPFRFldrNQKL0ZlfhtIN4HKyXD1+OoDzqBhcvV/ZxJNowFChAA2Gb5IoHUeyMtXQluqaNORrNORMH01tOlKsDtSdoAFJzo/fhnpo4f8OaUnRkWFn0GFJnQy0BasPPAihJ9XWPWdpQNWKRmHzogFTSS/2/2az+ag1WhBspBTSUJmIH5qjI983UrTC5C284/LN60PJ0E0eah4jRAVqvxvYj29uT70VjIv1HdQT9USfsX4Xo8vcN7gKwVJm7k5TNk8nwj6pODcC/et5TUOP3s7CFLB4LntNRhcrgG5kmTuxnKg/GjsmI5w0mfOs87XylehO9+BbRA193fRjLJHj7OFXrPjaAsd5tn09aLYpPnXll6/CWEwUoA3+/IB4XqZDornOkNeX72mnJegrlT6+NzO6GHaEC9l+62KHRszlqSnaOeoGVvfdzeC0mtBtIhjPamfdThoAGEgfJhy9o0G60mYYSILz0StVqnxcsduHe8z6qYKDoOCAxS4KUYYkIxT3Du6Duzx43dCR/qjmlXaEzd6zqoomtTt1VzarATFDle1swOURNIdFWDrHMk3z/K+w3lmkFufVeUMnbgFTQVGamkIigeePR/ixKQei4z4QGVD9g6WaqQ1S+b1mko5WP9ckQBEpnXDAX6vQZw56SQJ8xV0LKKxSpedsZKYaByBr9WSgoHYm9RoiEJ+gZiibMGEdzHEm0IMq7KHjJxOmBP6htrVVSBMomfxpORWc1j/iE5xNBVoXULYsdDpxBEWsrMxVRHi/2CltyYHU2HSkTJv5OedMt7cu1/Z+HkDgIRhdLxZrcGeq2A7umFfP4Xi638/GBH+UBjoQBgBqpn5+56UXtkL3bcoOz9aoUNRHCIOUiqHea+eYA5tXjJhdXUYF5BQQUgQjyZ8FAl7o
 qd3BrpR2
 XEV5khh8yLoJxCAAyvjyo/jnw9ZWuDSJApoUoyapaqTC+dQm+rgotn0ArTzBCiBTuP4f92p/9sFcwanR5GlAHxZTuVnreiSa+VevmyvRdBgYzJUb07bTB7OEbFKd6w/5R4PnLz67FICdSiZZpiOWTuMwo2IDJoY36tQHEbwajoXMr2DlBeSLS6ZWhWdMIEFmR1qKiCYrB1U+EfZ2RT+Lq90UjOB1jRtbUId/pn18w915485UdT8GzsYLrA0Es08gRb/1fG5twLEdES3SZ1ABYcjx3P8xKDaE0bWPL7l9OxaKO1N49kbnZb2fErfpRfKFV1vg0J+IOCR6AUWnx4GDaO4ppood8Ych0izvuE6YoTqQMBYSkLHBej77snXJvnKpCfHRFmiFGGty8iouhU3eGgj9Ef8a+CBUi/L4zLA1ydvfFw7MneFd0M9S3zsQ9k27uW6MEobkDBW2pGbbnKhImfnBYMWr6f9zf29GaMbfucil50hs5p4WJ4vOdq11yni1cxFTMysMoksnpqhjuPwr4QD5+e8cnteinPli7KK/XzcmMuTgtmtXUfIxGjf9LFH5JxxbZbvSQikQPpZDo4OSCADDAeiMavQ0TjIYS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 11:17:18AM -0800, Sean Christopherson wrote:
> On Thu, Jan 08, 2026, Michael Roth wrote:
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index fdaea3422c30..9dafa44838fe 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> >  					 mapping_gfp_mask(inode->i_mapping), policy);
> >  	mpol_cond_put(policy);
> >  
> > +	/*
> > +	 * External interfaces like kvm_gmem_get_pfn() support dealing
> > +	 * with hugepages to a degree, but internally, guest_memfd currently
> > +	 * assumes that all folios are order-0 and handling would need
> > +	 * to be updated for anything otherwise (e.g. page-clearing
> > +	 * operations).
> > +	 */
> > +	WARN_ON_ONCE(folio_order(folio));
> 
> Gah, this is buggy.  __filemap_get_folio_mpol() can return an ERR_PTR().  If that
> happens, this WARN will dereference garbage and explode.
> 
> And of course I find it _just_ after sending thank yous, *sigh*.
> 
> I'll squash to this (after testing):
> 
> 	WARN_ON_ONCE(!IS_ERR(folio) && folio_order(folio));
> 
> avoiding a few emails isn't worth having a lurking bug.

Thanks for the catch. FWIW I double-checked that kvm_gmem_get_folio() always
returns an ERR_PTR() instead of NULL directly, so the suggested change looks
good to me.

-Mike

