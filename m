Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64767D3E79D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 07:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EC4B6B0005; Thu, 11 Dec 2025 02:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CE16B0007; Thu, 11 Dec 2025 02:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663596B0008; Thu, 11 Dec 2025 02:06:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6126B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:06:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB4855B468
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:06:24 +0000 (UTC)
X-FDA: 84206306688.28.4CA4F14
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011047.outbound.protection.outlook.com [52.101.52.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id C31D6C0003
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:06:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DSBp21Ee;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ankita@nvidia.com designates 52.101.52.47 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765436782; a=rsa-sha256;
	cv=pass;
	b=DNJBIIH/hMIODZj/hEEmIanZkklQuEbKoDxf6VZLbO0mt+TauxF1ZPFj5A7QtUSZgfyn4B
	7SDBjgq0g3lFZIFhPlXIKqCyyhYtJkMMsLQZcwk4LKijVMhIz4ml8iEbrdCBzl39jRgFRh
	RqIUNdp8ZN6tcxT5CmpEY1UE0xLkTMY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DSBp21Ee;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ankita@nvidia.com designates 52.101.52.47 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765436782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VcpIYQljam0KpUK5PJB/DYZ6loIWWWVAOjUa3+ZRMt8=;
	b=TtCfa+0yYhDv/Z0IuTSI4FEKSveT2Y5HcZMioUFaFRUbyxVULSpEglKRePOXbEFYQ8FqBJ
	dE70d6wV7S7EofXd2R5brzrEoYHH9Hteo9BdZyvm+aEB9i0WMVCGY7Em1dUGKQqnP/skPY
	rRKW2+DV9yWiK6/5nNfkodv5/MXZIvg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GcP20RItxdpU7kQOMmFhFiwILkTVsd3PID3qZ0h5RHKVG/8OIQPeusGIhewx4ApHlH79Z0S9o7RfShYTbiLl/6WrJo5SQp5py6i7VKCwrrQgUIOCGJlPLv5qIJpKPLeKDcZb8nMMwYgoyuyRgweut0YsEOAGuxjbomRgpqCNiRoZ+W0YbvpPSHlgqDwSCty3mDyzndCien8qhO9r5+P8Lnz2nSS3T3MDv5lRhbUr0SmEXET7PtkZTArlsmMrPJUqZCSlnuzHjCF2hAktMS3KeUeONJu2iQFMBtWa8V2qBTuKS3u3MTbYWwc0MXwQi3virpv8V8gUK1X0rSSNKf/qjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcpIYQljam0KpUK5PJB/DYZ6loIWWWVAOjUa3+ZRMt8=;
 b=LdgVux4457L6MYvQULhPzb/B8bwWOPFM86HgAxZicjosvl7RY+3XFqTrdMiEPIMoPPPsANeVq5EzZusL/UBoPFclLwJHQOPZPi02sbakVY+PoO26c2v4E4i/1aPxIb+cNtKWUFJNCYPgUFaaP/P7LiCSY1reD9jhQ/SW8At8I2DWme0FzhQ/BlzKNN3sHtG+nNSoRbIkpL7YsARqxGp/pHCI7d87VdCqZxrfLcETRHo7g5XU4xwV/KCLk44gqamNgXCB/ukABUYwY53nQs6N5Mg9oGHYxBu5bPkNpJHw3AV5KfdDBTt6j7fssqHUDAhgZA/OVxbuX/zUbwelHnwzzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcpIYQljam0KpUK5PJB/DYZ6loIWWWVAOjUa3+ZRMt8=;
 b=DSBp21EeTH2bQWAb0KePwdn5T4dnuFfVaYYruR9Y+wh7CTDgJ8HBo8H6JpCRv/S/vq/0G78aM893dcw4+2HcI4Uphnc87Cswmg6gSRIHzMiyqX619hVjCX7jPXE+2dCdjN/yOkzjG+uAAbYmY7m/embawqcC/gLYpDPldmAfpwKUzy4afnpmYL+iDMB8ZNtk5qRVMcLbdLZ57w1yUXIUGVYHAS346qghv9i1fR3PqePfdv2wAruXxc6uAzlfCloOWiE1Ry/KLwIbqyMumrMmdIPGEpyJUGwl8LdYkXTbUGPUK+ofF3mhtAtI92KuKDX2WAFCdEtKjKgehH0IwBC+Hw==
Received: from SJ0PR03CA0199.namprd03.prod.outlook.com (2603:10b6:a03:2ef::24)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 07:06:17 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::b0) by SJ0PR03CA0199.outlook.office365.com
 (2603:10b6:a03:2ef::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.15 via Frontend Transport; Thu,
 11 Dec 2025 07:06:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 11 Dec 2025 07:06:17 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:05 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:04 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Dec 2025 23:06:04 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 0/3] mm: fixup pfnmap memory failure handling
Date: Thu, 11 Dec 2025 07:06:00 +0000
Message-ID: <20251211070603.338701-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c730aca-f12d-4d94-3242-08de3883c79c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2rBFsXxfJBVFRd4Q3TjWfatMUg5pNxSPArUdDm6SIZipJp06MsRpdC+QwiwF?=
 =?us-ascii?Q?hk7Hm9Jpkvi34Z0xnVtD7HuCNp2wI1DqwtNQCdvf2vmX1QBcWzBjhieblwn9?=
 =?us-ascii?Q?68OZhihfFIoJx9DtyS1KxtOUFMaYhIWiJKVDgp1ZpDfWC3Dk+Cn+K0RfghVz?=
 =?us-ascii?Q?JJrsISDEss9/VFNcfvlbwuJIe8YIK2yNmN3s+0ZZ2kFgyQ1D8QAcrYNUWuOO?=
 =?us-ascii?Q?E7aYT/urT/efhkrQSGvXqrtXJQETOp6sQqDvNLxseINqFAhFxu6C7jvvKr6N?=
 =?us-ascii?Q?XCh1yMmBKKPSBewKnhiioxvKFwxse/AjMImOkmaHQ+UVDEsPaRIER72VsvSt?=
 =?us-ascii?Q?AIJe6jFWQqrGKEIQw86lko86iaMT2uEB5+7E+ACNveOMSRkL72IXC/P8wJTe?=
 =?us-ascii?Q?yl0wQu+DnNgm0r3H7ROMAk9M1afrxreF5lf5DI1d53BkuS9P8YZVVW/308CC?=
 =?us-ascii?Q?/NU6rVPogTT0Dq4Eyk6o/oq0NUuJEIfgDxtN2HiPY3WuuzaWYaKjpg53TMt0?=
 =?us-ascii?Q?jbo5eis/QEJtBSmksSVkd7yWIRs0zjXVml5NoNfy9p7nrvtptr8Bd026mKYB?=
 =?us-ascii?Q?NbQJSPE+baC4YjPf2/F8aXtlDJj/Stp8l1fcdCpzKH0iWwO5vdrts+iutxbI?=
 =?us-ascii?Q?hAIkIFS86ILXIxZeR2FRhzGllT4EHXChM5Ivk3L6nJQpWYLZArPsN5PvACp9?=
 =?us-ascii?Q?AoHK6hSNFWBYYbkQxwdX2F/jwszlqkGPXYkYu39L30iytnah3ily8HJ4wXlV?=
 =?us-ascii?Q?fbk92haROYS7sHjGGExCR+jE5MVc4PNsWqEmjGCP659smjM5/7hRrMD8XDj8?=
 =?us-ascii?Q?DtRI7i6FfL94/IJC3FgzkxvOCTfIbxLrPsxbg9NfcT/jqTHvhX3T48/9CZuy?=
 =?us-ascii?Q?DbIQ9MqALgMqTGtSLKGhKUjzkT2FGFm3j7BiVnUWMA81yr838I9AgN4t2T+u?=
 =?us-ascii?Q?XJvGVGuFRNN0yrT/Jv3KJw9rDBcWwaFelUKlWYppMMkDh5w1Lexi8pMWLUYr?=
 =?us-ascii?Q?WpEc4IPbI1G7U+lmiDFipdKfBlUgc14Lr/mvlZV8kepHqHWhY4aSv3m1blm1?=
 =?us-ascii?Q?EjbSHMJiLn06yjiX+TcosDd/LwkBQwwYis+IFODdMZlz5OEoLrMba6ih2YD3?=
 =?us-ascii?Q?auVD0SxTXGlhfnRIpmQjLmP0c7cAFjvHZ/aXFagjcasHu4bOtswKTwATLIqh?=
 =?us-ascii?Q?8JUqmxMcINrRy6E8+gxNupIJCmzsUX8ap6kvneiZPcrzzo/fwbvbwqViNQb9?=
 =?us-ascii?Q?kMZcNvGZrMzM0c0sWyniqOCOz7D49ercVuIGMy+djtn0xFwDGW65IbLaoyID?=
 =?us-ascii?Q?6staa22i0cT78lDj8Aip0hSd3tzsq1lLa6hRTDVh8qWtofWWSifVF5V5FvyF?=
 =?us-ascii?Q?/H63pZAJBwKFIR18BlBtl0KtW00VuXmcgd4nsO7dAvZ+zkA+pViyRtnYylWf?=
 =?us-ascii?Q?eTMCIVTb0q0/aO4eFhg+KBy0LYMOHF+pkls7TXKy1Cyo6p75vrFx9rIRsITr?=
 =?us-ascii?Q?zqYS/pmWWRqiBIFh8gXTnQB083zN2wmW/pe363gBP/SUEbPuXKZWEhKFZ6Oy?=
 =?us-ascii?Q?W89G965Ac5OPouq29LucP+FSQ4MA8gW3N/mcSSx/?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 07:06:17.3541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c730aca-f12d-4d94-3242-08de3883c79c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Rspamd-Queue-Id: C31D6C0003
X-Stat-Signature: ow5k6y3d4neffe1wydbtch3qzqosrdxw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765436781-181778
X-HE-Meta: U2FsdGVkX19GfgTR1Xr2kmdaIvYTmHPd0Mz+gSwRjCPuO0HtMiPeTD08HLuX3VLlnCtIIeZYJGExn4wy5N0bO91whJ5CN3az8VM8irKp6mLcrf3rUpCedmHRP2BxKxpLl8V51jMrZxhHJ9RQ8iNn41/IAJY2MOx+OzC82/moEfxMKO2T0cbMXewtWQQS23Sz9QYhA6wvbmUdDIAXqsidI9AGCRxVqu0b/b/LhZzwQKlRYhqmrNDVUcgkcCv9M9giuDtO+VdhzQc1W3Q0/j526x9YXeT77gsYEeUUxUXx0LeyViPNUaPCArVY92LpqtS4yclgkSepep6bWPE1CyZmnLqmlMuvDVKh16M8+/Q5TbVCV6fiHHEC81X9U2/ZBY8vnxEG2SfiMb9AY/X3gEQ/VQ2Oi9J3P9+dr2YNGtZ0r8fWJxn/Bzy2i4TKYV3aHKmqZKxw87xMTOlDnKEwvl7zYg2ylBt/tRBn+SSmvHxZMFCOJKpzdDgSWr8QBFGg35uEzLguNQAi9Q7DqdkwjNxz01cm7I0YWDy3JOIqFbHr5N7gU5/jp8Wr6vzzvlkx2B3vxNryN00DnGD7FZbY+yPmo8r54TtVtcLBEPp2r5a7Uyh9tjx1fCfaigjAb0mB2GsML3ft7izpYpL85RLKvTMr+c41YRd/WPaSsqPkxd1xXpzksZa0MT12S0EO2nTpdMVxXkqztLIIhU8v2nJm/VbaWT2z0lDvYZ/9ou6XWcAKBdAWhJwuJ2mUIXWLYja/C/n1ayiVafDiOwm54WfzvaMjNwB64Q5WSVH6orVXp3jE2KXIuh80/XjeRwIzRLpLKL2hjpyLjVf3MLifa3yCFWHjnb6C5AKa8LjyTa72xfQkbwthXYNzNDi6vQUudC9p4PxLyI6Dgt+DZRVSqmaUWvZfU5ZVijrRPC1ZQ5KCcpQY8Y4y7J+cRlX6hvar8YGrUIodB+9cSE66ADpE4kk6MzE
 Hnpak5rX
 TpsiqfAtzqTMfbmubSKeYNG/W7ujyjSSUlp9UVRse6+1z46x4ktlosaeFQm18UhZzjaMTlQmsl26K0TLv8OezCR0Py2EO58km9alX8rPvvYGviHnc13tO0psXVw8ZSTufc4+1CEjG5nukjnfyCUrggvQW6Bfovaei+AIBYLLXYBVu+RSErzY0BKTMHTw/lB4oO62SN0iVdtC+mK4oZa73DYLIpvIU1ZZVotA2ywM66YLaf1O6SesUJUMO+MMKcwy4FdRq/Jy9y3TZ4a7K47svp9aNf+SYQT32IzVaEECYgvhYylaXUunaxnP/44Jvc+5c39EeMYLOAiK0DWdP5F5h+z3QhnTV2yWZw7ziDfpCzQ/4db14CX6XwahDYqy6Q8NiHtAEoNHef5KFf88T3GhwA34NT51IvgagbUnuPHZxATglJHJkZWIoYeTse0zVMYia94ftNttBq0llecJEIVMxJjgfc0ki1TVbzdc7eQfVx4gr9xI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

It was noticed during 6.19 merge window that the patch series [1] to
introduce memory failure handling for the PFNMAP memory is broken.

The expected behaviour of the series is to allow a driver (such as
nvgrace-gpu) to register its device memory with the mm. The mm would
then handle the poison on that registered memory region.

However, the following issues were identified in the patch series.
1. Faulty use of PFN instead of mapping file page offset to derive
the usermode process VA corresponding to the mapping to PFN.
2. nvgrace-gpu code called the registration at mmap, exposing it
to corruption. This may happen, when multiple mmap were called on the
same BAR. This issue was also noticed by Linus Torvalds who reverted
the patch [2].

This patch series addresses those issues.

Patch 1/3 fixes the first issue by translating PFN to page offset
and using that information to send the SIGBUS to the mapping process.
Patch 2/3 add stubs for CONFIG_MEMORY_FAILURE disabled.
Patch 3/3 is a resend of the reverted change to register the device
memory at the time of open instead of mmap.

Many thanks to Jason Gunthorpe (jgg@nvidia.com) and Alex Williamson
(alex@shazbot.org) for identifying the issue and suggesting the fix.

Link: https://lore.kernel.org/all/20251102184434.2406-1-ankita@nvidia.com/ [1]
Link: https://lore.kernel.org/all/20251102184434.2406-4-ankita@nvidia.com/ [2]

Ankit Agrawal (3):
  mm: fixup pfnmap memory failure handling to use pgoff
  mm: add stubs for PFNMAP memory failure registration functions
  vfio/nvgrace-gpu: register device memory for poison handling

 drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
 include/linux/memory-failure.h      |  15 +++-
 mm/memory-failure.c                 |  29 ++++---
 3 files changed, 143 insertions(+), 17 deletions(-)

-- 
2.34.1


