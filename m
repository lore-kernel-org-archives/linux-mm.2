Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC17D1CDAA
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409CB6B0024; Wed,  3 Dec 2025 18:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1076B0027; Wed,  3 Dec 2025 18:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CFF06B0028; Wed,  3 Dec 2025 18:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 197FC6B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:12:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8018251EBD
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:12:43 +0000 (UTC)
X-FDA: 84179711406.26.BDC2767
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 292E310000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:12:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=odRIhMHY;
	spf=pass (imf05.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.208.12 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764803560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCLOsP7ifp15x2RX4EWs2PawIhrX5jQagrLShoW1UMU=;
	b=Ryt0v8Lx4stzLXGCSNw4XF2xrI0y+D9wUw5pNngJfqRDUG5FxnnxZcskh6A0zJk39lWpu6
	BLaS82Z+MY/SSEBk5lSxbs4aVuWXiy6pxwEcEs6jRnOkxdqyoSz15XCNr0siDAY/s4SxxH
	0aSL//ql+ryifVkoIT/Bcueh9oNMvKo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=odRIhMHY;
	spf=pass (imf05.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.208.12 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764803560; a=rsa-sha256;
	cv=pass;
	b=LlHJ6RS/yDWYyR724iqOTMo4zj+adeuJaF4CbzUsgk4XROV7jQBhyQwB0apO3hv9WtrzMB
	O+daQvSxJjJT6nQ46GP5qS9vktE7v1fFZwTLy6n6CEFdheysOL33sumOcOuMEh0vljJ8OE
	lS+FB6aLnZdXMx6GLZxjpDQfAYYd4P0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hxgEcAk2S2h0FVEwYCx7aRG0GCOCGy8JRV+gduCEUCZHWxexx+5tYP8o36es/9aN3bkof4Fy6fZYk5iPbWZOj3ie9125uhM2E5R/YJu5LIlU0ZxVT4KXOGAQhdiEGwzHHhkB31SbkVYSB6mf4vLhbhQxQRnuuCSNqk7yNdauOX0NrVoIoy5ZGL2+zjSXhGy9jn+Al+2/10ifWZq2xSYQ//HB278O3qC1pl5TTA5f52lKJy41AfQb73edY+qgfaGmcu4mBZtTyHlUjv2IlwGfnDy5Y9JQDncBb1hww+roY0OUgrri10n7yl4dfBe5ePNj3EwIVYH33gGM/WJKowLlmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCLOsP7ifp15x2RX4EWs2PawIhrX5jQagrLShoW1UMU=;
 b=Ld+fqyVfnMOELAEa2DlKMdrSSS5JONZ2KY/NL6/I+DvvWvBOVFTlkhLuRMH6iDVIzfZioFJrylEBSrUQz5odcLp7sAz5asmXJK99RA1zY6I+W1yXbtmGKCXgL15wGKbl0a0rHoJziV+x1DFRuvURCrB/vkFOEJv2p8zDDCNwCqC6SFZyz3Lagay7oc77/hnNxXgQW09A/oNcche4ZkLx+XzSg56LDW7sgQn5fIAhw/kN3HaruZ3K1QwUYLlUBoq7WswH/OInyq6ox2xOlh9R8DVBKP5wS3ZYB/I7KdG2QZRrBCdoaXwe+lfcV19nj83e5FUlume3UKf76udP3iF+3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCLOsP7ifp15x2RX4EWs2PawIhrX5jQagrLShoW1UMU=;
 b=odRIhMHYAj3FYJbUDdNC7NPwlAQZ7JIqD/hA98PWHZyUxMCtGlBPaY4YmJn0/iMt0o+ICMzBM0e312OBIPMGhdns+r17AgxZw+6k3IN/ZLPNfmMHLVRKkIW04xQghcMfvtZYQl0wb6lJYopba0TU9D4+hV+oDIIdP5FBYl47ok0=
Received: from SJ0PR05CA0076.namprd05.prod.outlook.com (2603:10b6:a03:332::21)
 by DS0PR12MB7629.namprd12.prod.outlook.com (2603:10b6:8:13e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 23:12:32 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:332:cafe::47) by SJ0PR05CA0076.outlook.office365.com
 (2603:10b6:a03:332::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Wed, 3
 Dec 2025 23:11:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Wed, 3 Dec 2025 23:12:27 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 3 Dec
 2025 17:12:26 -0600
Date: Wed, 3 Dec 2025 17:07:14 -0600
From: Michael Roth <michael.roth@amd.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20251203230714.b6wz5s7gnhg7unah@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
 <20251201221355.wvsm6qxwxax46v4t@amd.com>
 <aS+kg+sHJ0lveupH@yzhao56-desk.sh.intel.com>
 <20251203142648.trx6sslxvxr26yzd@amd.com>
 <6930a5242dd1b_307bf1002@iweiny-mobl.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6930a5242dd1b_307bf1002@iweiny-mobl.notmuch>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|DS0PR12MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: 24d6ff8a-83bd-4c48-49e6-08de32c16d0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?llVtewH0EHKo7AsQyFeVuRjBwERMqpfuCWmBAG4bQurD2vBE1O1cIEcF0dXU?=
 =?us-ascii?Q?F6j9jn6SO0lp3Fb2IRZMmDQzgpCrNjgRwUzDaNt2t87L9+XuiTImKWEB97kd?=
 =?us-ascii?Q?NtHpSvo/XHV1Fn1nH6i+F+lsZKZiytAQk7edCOmq76UdldH8CoZNOXC4dxiq?=
 =?us-ascii?Q?HesSU3Ws4TfNWnA1jfsU8pcQqEIr9XZrc/1Vs6cq3Twib0D+6Ol3qxFmihIQ?=
 =?us-ascii?Q?lM2xy50utXV9mQBq9zFWHFTO9MAJKRa/aNk4hSXic/ITvID4EI6AW+7fr9sr?=
 =?us-ascii?Q?TXz8S0DdBVbNMrAEj3KWSN5x8l3M7wCFRUueYoFvqh8KyOQYqrN/UVBU/kKi?=
 =?us-ascii?Q?OKqWbeVwodAC/ldGJgTyGQy3clAC67mO9Hx/Su/8zs0i+odtxp4jnwU1B5TQ?=
 =?us-ascii?Q?bBBUx2iGvpgsXG5ZaPFEhdttonpY5LvGDDy7kKOoqw0dtlRTLOCoZ0VRxMGL?=
 =?us-ascii?Q?AuqMbldp9QbsLxNA+skTXyAOJmc4/ckuYIaauUCt9fgxZsHPGk2X6MP7UK/R?=
 =?us-ascii?Q?HZEUF1SpoMoEWUqo0Nwe6cPfouPg2LmYNhMfHoqPmWIIpa+b9K1hZNPnt4g9?=
 =?us-ascii?Q?szQ5QyjLExN/pCXaapkiqDE+aq5NoWyoKw1Z7hzec5SzTKvqQplYVjFkHAsS?=
 =?us-ascii?Q?15cFr4hDik8Wj+2YETMa11PSemokqE6j+ZBa3clbdFEgZkreaQE5pRmuFNVN?=
 =?us-ascii?Q?7PkblvYzJsocjKlfV1yTBdM6cQ5ZF7A/gsR4RxTeGo/dbU8y6VqaEZFd8BTg?=
 =?us-ascii?Q?j+q0m2yfkmzTCEYmhP8xw9089S+EfYbPOGjI8cYtenuhQWHBW2Gnwju53B5g?=
 =?us-ascii?Q?ZslAN59i59pZbEQVeaTDoYgUfUCGthEztlbOmpY9LQJ/Wdh5MoLm06aDATII?=
 =?us-ascii?Q?Wc96gMRpaiGiQ7KGvdcebsLVZnF6brz0l0/Ku1Z9sDaUimn6tmKp5Zrpj1CI?=
 =?us-ascii?Q?2LBHkn640U+mveGmF4dyH/j2sdKHg/NM/MVWXRkGACpBJZdUT52q74fhb6os?=
 =?us-ascii?Q?Dg+QkWUXwezU5ACvgCCWiH9O1GH/21r3n1f+unki/T7Uy22ObmBZ9pUuHlaG?=
 =?us-ascii?Q?c1nmrIeSqA/39SKwgo2FZ7EibeIvANd+6idEMf9YSav0iddXIMBEsgBlvluN?=
 =?us-ascii?Q?ey/InYIzxxwbz1FVilYuPjrb2CzalvDwTM835LsJBGCKpR+X8wH4M3XqKARm?=
 =?us-ascii?Q?zirOg6+gO0MNos9riNDJ2aek3HOmTip1oybHVMsoxbFvfp0HIag0T84jiItG?=
 =?us-ascii?Q?QxSt8hA39w4Wc6C00Npq2MmMX+WGbZlu1FaTA9tNT7tx0vLWdkkSnTNH0KA8?=
 =?us-ascii?Q?079NxqmKI6b4SVQehYXTbV/6Pk2XRHlHvASHbPDXawmRnBYAVkPE285LdEKc?=
 =?us-ascii?Q?exyJq70VxJBiyzDgyJUgLO6VP4PcBU7Ag3TbfPUoo4QZiK4VP2UTFHGYHmso?=
 =?us-ascii?Q?hoiW183OHnGskMUj0laVRt6LAoaufQv/EAQFqed0dfEaE2BmPjgVQkNBU7GT?=
 =?us-ascii?Q?Xd5g0e4oFmpENsE+p764op2/jJeGTgnp4a3P1GXis3eCnr+aAA1ROHnn5C2v?=
 =?us-ascii?Q?zUO+QrtbfnsmaeQc984=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 23:12:27.1509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d6ff8a-83bd-4c48-49e6-08de32c16d0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7629
X-Rspamd-Queue-Id: 292E310000A
X-Rspamd-Server: rspam02
X-Stat-Signature: e7a6zhf3fcp76h9wa6n6swpzikhfxhnp
X-Rspam-User: 
X-HE-Tag: 1764803559-25867
X-HE-Meta: U2FsdGVkX1+L0zx8Ek1dJTxQqvmc+MouagwIdZ3CT0DWJ04vDeEt/V5YP6TQQca3CxWxbGbjsr4SOdEKusr/Edz3PTUS53jR4t1prWhWq1r9b4maRnhmkbWJzEuyZVYiWS1adBWGORRuX/9rP2HgqWTxczNpU4HBcrsC0R6qoQg2jPb7UPe1Sbt83qO7MSoHny7qWtdnkfqgXtEzrI1Jd12y+MCKghCmZAhK5W/K+3vvCfL2mLZZM1dgnTDViDRx/4/tzy7lbpsyqKpSxfR2oToMqezIQkRfs/3C7X8xB3tMOKBVXyTo3Lf4t8ulR0/W063lxpr/xUIqMRWf46SZrD3bBM/Lk5hV6uB5fHYN2C78mnVtFQEZyva2eybK6aC/FseoOe/tX13mDcaAvLGDBt1wZX6qvGFRlM0y/vafZOqwLrr+DvzU8xrxhkN+jlVuIo9CIPSjXJpTfKj4oJfl8S5pgIT0UlBD7HBrclun1ON2v5krDi5CeSf73pMAwIj/T43HKIxYdmJ1WOmczQdxUnHYmPzOW7qjIW6jGi1R0C0SpXsh0vB5mqjJ/SqBO7jQq4OLG4/oYynmDB9i0bkHQA7Bdnl4XclLKUHf1HuUBeyx/PinnNSFgZIGpNZFqagXhwIed7bSSe2ao4/G0gUp61FdNBZIUSHIMl0lph0slMZgITFGpV6Hc29CL4Z0X0YOymafEh5HOOJHjDsvLA/Do9gmrNDGX3UMy+zFr0RbJmApHQGpk2QJeE4sVDnBqWNUuHXdKQHbj/kOxR4YMBsRbNQ6s9g5QLOjYrXumZX5mgoGM3OyuJDKjlxx11Dc3PLEb8SjGv4I+PcmpvSy8U3TcTlc4gmEj1GnbeyXOS3eNj3zxLvbMNh/KGNFloUaSxBJLOmxCBVlSZ1XAW1rm8oDsCnOPS0WthKQaWWFVt6Uv7d/Z7V/UdkcyY3q2lO77MdIW592I/73DHh+dbTK+FD
 odReR75P
 mYyRX5NirOF1aV2VKiRtMs3W0qOl4zlZANfNw5/cOdXo/c4/VTP4HhXM/pQMD0TRIXZkjqwlUqpIQIizfyy1jM9+gwhp0JVbZtc2UaYYgEHLTuCB+LgOtFmrd5+S/8EQkFsBNJoM/9VinjYp6JonbfheB9ekhDsBEHsvjNTx7IUzhsB8odIu+xz3Ec2NuVIadefb/Z3OZWWPJjxYTXSxMC4hM+ZtQoikXOKHY2b8IBsCn/I+/wVnQmQItpRBbdSjdreiU5hDhVxCwWE2zJ/fVEChvptS8PubqG74lCqHf8nmMrmlTXS3IIQian0b+fgyi4ZI1n4Foo9NVTpqB3TtUGb0OXvaxUlYhJwhIKERAJTE5eyiNIBYIdcCBpDKm0fgT5MatkkK1VREgyry4KU8h/1j7YlGASQdbcr7eCJd03nRo0saDMwRppG9kwDX+QEoCdno5bj1VAjSyVysghAh+IGemyWblCKAqTgaulS5IlULCJSH1xu3t/l8c7EZrcBmcFTj1G1NREIWH603rDa1yBykhd/euwtTCO4ws2LrwFoVYL70XkbypsUJlwmkJrnL9qVDhuWMdYDqX753nAshiP0pNY6mPjC1Vr0gy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 03:01:24PM -0600, Ira Weiny wrote:
> Michael Roth wrote:
> > On Wed, Dec 03, 2025 at 10:46:27AM +0800, Yan Zhao wrote:
> > > On Mon, Dec 01, 2025 at 04:13:55PM -0600, Michael Roth wrote:
> > > > On Mon, Nov 24, 2025 at 05:31:46PM +0800, Yan Zhao wrote:
> > > > > On Fri, Nov 21, 2025 at 07:01:44AM -0600, Michael Roth wrote:
> > > > > > On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> > > > > > > On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:
> 
> [snip]
> 
> > > > > > > > ---
> > > > > > > >  arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
> > > > > > > >  arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
> > > > > > > >  include/linux/kvm_host.h |  3 ++-
> > > > > > > >  virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
> > > > > > > >  4 files changed, 71 insertions(+), 35 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > > > index 0835c664fbfd..d0ac710697a2 100644
> > > > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > > > @@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
> > > > > > > >  };
> > > > > > > >  
> > > > > > > >  static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> > > > > > > > -				  void __user *src, int order, void *opaque)
> > > > > > > > +				  struct page **src_pages, loff_t src_offset,
> > > > > > > > +				  int order, void *opaque)
> > > > > > > >  {
> > > > > > > >  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> > > > > > > >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> > > > > > > > @@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > > > > >  	int npages = (1 << order);
> > > > > > > >  	gfn_t gfn;
> > > > > > > >  
> > > > > > > > -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> > > > > > > > +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
> > > > > > > >  		return -EINVAL;
> > > > > > > >  
> > > > > > > >  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> > > > > > > > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > > > > >  			goto err;
> > > > > > > >  		}
> > > > > > > >  
> > > > > > > > -		if (src) {
> > > > > > > > -			void *vaddr = kmap_local_pfn(pfn + i);
> > > > > > > > +		if (src_pages) {
> > > > > > > > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > > > > > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > > > > > >  
> > > > > > > > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > > > > > > > -				ret = -EFAULT;
> > > > > > > > -				goto err;
> > > > > > > > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > > > > > > > +			kunmap_local(src_vaddr);
> > > > > > > > +
> > > > > > > > +			if (src_offset) {
> > > > > > > > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > > > > > +
> > > > > > > > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > > > > > > +				kunmap_local(src_vaddr);
> > > > > > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > > > > > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > > > > > > 
> > > > > > > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> > > > > > 
> > > > > > src_offset ends up being the offset into the pair of src pages that we
> > > > > > are using to fully populate a single dest page with each iteration. So
> > > > > > if we start at src_offset, read a page worth of data, then we are now at
> > > > > > src_offset in the next src page and the loop continues that way even if
> > > > > > npages > 1.
> > > > > > 
> > > > > > If src_offset is 0 we never have to bother with straddling 2 src pages so
> > > > > > the 2nd memcpy is skipped on every iteration.
> > > > > > 
> > > > > > That's the intent at least. Is there a flaw in the code/reasoning that I
> > > > > > missed?
> > > > > Oh, I got you. SNP expects a single src_offset applies for each src page.
> > > > > 
> > > > > So if npages = 2, there're 4 memcpy() calls.
> > > > > 
> > > > > src:  |---------|---------|---------|  (VA contiguous)
> > > > >           ^         ^         ^
> > > > >           |         |         |
> > > > > dst:      |---------|---------|   (PA contiguous)
> > > > > 
> > > > > 
> > > > > I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
> > > > > as 0 for the 2nd src page.
> > > > > 
> > > > > Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> > > > > snp_launch_update() to simplify the design?
> > > > 
> > > > This was an option mentioned in the cover letter and during PUCK. I am
> > > > not opposed if that's the direction we decide, but I also don't think
> > > > it makes big difference since:
> > > > 
> > > >    int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > >                                struct page **src_pages, loff_t src_offset,
> > > >                                int order, void *opaque);
> > > > 
> > > > basically reduces to Sean's originally proposed:
> > > > 
> > > >    int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > >                                struct page *src_pages, int order,
> > > >                                void *opaque);
> > > 
> > > Hmm, the requirement of having each copy to dst_page account for src_offset
> > > (which actually results in 2 copies) is quite confusing. I initially thought the
> > > src_offset only applied to the first dst_page.
> > 
> > What I'm wondering though is if I'd done a better job of documenting
> > this aspect, e.g. with the following comment added above
> > kvm_gmem_populate_cb:
> > 
> >   /*
> >    * ...
> >    * 'src_pages': array of GUP'd struct page pointers corresponding to
> >    *              the pages that store the data that is to be copied
> >    *              into the HPA corresponding to 'pfn'
> >    * 'src_offset': byte offset, relative to the first page in the array
> >    *               of pages pointed to by 'src_pages', to begin copying
> >    *               the data from.
> >    *
> >    * NOTE: if the caller of kvm_gmem_populate() enforces that 'src' is
> >    * page-aligned, then 'src_offset' will always be zero, and src_pages
> >    * will contain only 1 page to copy from, beginning at byte offset 0.
> >    * In this case, callers can assume src_offset is 0.
> >    */
> >   int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >                               struct page **src_pages, loff_t src_offset,
> >                               int order, void *opaque);
> > 
> > could the confusion have been avoided, or is it still unwieldly?
> > 
> > I don't mind that users like SNP need to deal with the extra bits, but
> > I'm hoping for users like TDX it isn't too cludgy.
> 
> FWIW I don't think the TDX code was a problem.  I was trying to review the
> SNP code for correctness and it was confusing enough that I was concerned
> the investment is not worth the cost.

I think it would only be worth it if we have some reasonable indication
that someone is using SNP_LAUNCH_UPDATE with un-aligned 'uaddr'/'src'
parameter, or anticipate that a future architecture would rely on such
a thing.

I don't *think* there is, but if that guess it wrong then someone out
there will be very grumpy. I'm not sure what the threshold is for
greenlighting a userspace API change like that though, so I'd prefer
to weasel out of that responsibility by assuming we need to support
non-page-aligned src until the maintainers tell me it's
okay/warranted. :)

> 
> I'll re-iterate that the in-place conversion _use_ _case_ requires user
> space to keep the 'source' (ie the page) aligned because it is all getting
> converted anyway.  So I'm not seeing a good use case for supporting this.
> But Vishal seemed to think there was so...

I think Sean wanted to leave open the possibility of using a src that
isn't necessarily the same page as the destination. In this series, it
is actually not possible to use 'src' at all if the src/dst are the
same, since that means that src would have been marked with
KVM_MEMORY_ATTRIBUTE_PRIVATE in advance of calling kvm_gmem_populate(),
in which case GUP would trigger the SIGBUS handling in
kvm_gmem_fault_user_mapping(). But I consider that a feature, since
it's more efficient to let userspace initialize it in advance, prior
to marking it as PRIVATE and calling whatever ioctl triggers
kvm_gmem_populate(), and it gets naturally enforced with that existing
checks in kvm_gmem_populate(). So, if src==dst, userspace would need
to pass src==0

> 
> Given this potential use case; the above comment is more clear.
> 
> FWIW, I think this is going to get even more complex if the src/dest page
> sizes are miss-matched.  But that algorithm can be reviewed at that time,
> not now.
> 
> > > 
> > > This will also cause kvm_gmem_populate() to allocate 1 more src_npages than
> > > npages for dst pages.
> > 
> > That's more of a decision on the part of userspace deciding to use
> > non-page-aligned 'src' pointer to begin with.
> 
> IIRC this is where I think there might be an issue with the code.  The
> code used PAGE_SIZE for the memcpy's.  Is it clear that user space must
> have a buffer >= PAGE_SIZE when src_offset != 0?
> 
> I did not see that check; and/or I was not clear how that works.

Yes, for SNP_LAUNCH_UPDATE at least, it is documented that the 'len' must
be non-0 and aligned to 4K increments, and that's enforced in
snp_launch_update() handler. I don't quite remember why we didn't just
make it a 'npages' argument but I remember there being some reasoning
for that.

> 
> [snip]
> 
> > > > > > 
> > > > > > This was necessarily chosen in prep for hugepages, but more about my
> > > > > > unease at letting userspace GUP arbitrarilly large ranges. PMD_ORDER
> > > > > > happens to align with 2MB hugepages while seeming like a reasonable
> > > > > > batching value so that's why I chose it.
> > > > > >
> > > > > > Even with 1GB support, I wasn't really planning to increase it. SNP
> > > > > > doesn't really make use of RMP sizes >2MB, and it sounds like TDX
> > > > > > handles promotion in a completely different path. So atm I'm leaning
> > > > > > toward just letting GMEM_GUP_NPAGES be the cap for the max page size we
> > > > > > support for kvm_gmem_populate() path and not bothering to change it
> > > > > > until a solid use-case arises.
> > > > > The problem is that with hugetlb-based guest_memfd, the folio itself could be
> > > > > of 1GB, though SNP and TDX can force mapping at only 4KB.
> > > > 
> > > > If TDX wants to unload handling of page-clearing to its per-page
> > > > post-populate callback and tie that its shared/private tracking that's
> > > > perfectly fine by me.
> > > > 
> > > > *How* TDX tells gmem it wants this different behavior is a topic for a
> > > > follow-up patchset, Vishal suggested kernel-internal flags to
> > > > kvm_gmem_create(), which seemed reasonable to me. In that case, uptodate
> > > Not sure which flag you are referring to with "Vishal suggested kernel-internal
> > > flags to kvm_gmem_create()".
> > > 
> > > However, my point is that when the backend folio is 1GB in size (leading to
> > > max_order being PUD_ORDER), even if SNP only maps at 2MB to RMP, it may hit the
> > > warning of "!IS_ALIGNED(gfn, 1 << max_order)".
> > 
> > I think I've had to remove that warning every time I start working on
> > some new spin of THP/hugetlbfs-based SNP. I'm not objecting to that. But it's
> > obvious there, in those contexts, and I can explain exactly why it's being
> > removed.
> > 
> > It's not obvious in this series, where all we have are hand-wavy thoughts
> > about what hugepages will look like. For all we know we might decide that
> > kvm_gmem_populate() path should just pre-split hugepages to make all the
> > logic easier, or we decide to lock it in at 4K-only and just strip all the
> > hugepage stuff out.
> 
> Yea don't do that.
> 
> > I don't really know, and this doesn't seem like the place
> > to try to hash all that out when nothing in this series will cause this
> > existing WARN_ON to be tripped.
> 
> Agreed.
> 
> 
> [snip]
> 
> > 
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
> > from with this series: let's get in-place conversion landed, get the API
> > fleshed out, get it working, and then re-assess hugepages with all these
> > common/intersecting bits out of the way. If we can remove some obstacles
> > for hugepages as part of that, great, but that is not the main intent
> > here.
> 
> I'd like to second what Mike is saying here.  The entire discussion about
> hugepage support is premature for this series.

Yah, maybe a clean slate, removing the existing hugepage bits as Vishal
is suggesting, is the best way to free ourselves to address these things
incrementally without the historical baggage.

-Mike

> 
> Ira
> 
> [snip]

