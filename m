Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE7FCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 23:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88518E000F; Tue, 16 Sep 2025 19:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D386F8E0001; Tue, 16 Sep 2025 19:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00808E000F; Tue, 16 Sep 2025 19:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA0588E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:34:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B0DEB8123
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:34:04 +0000 (UTC)
X-FDA: 83896718808.29.D66C60C
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	by imf06.hostedemail.com (Postfix) with ESMTP id 515E6180007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:34:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=K5GAjMmh;
	spf=pass (imf06.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.195.2 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758065641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cj8fLV3BBwNmrLeQQfjwntZ/T4urDB8PG/NecqD4WrE=;
	b=xm2oNmnu3lhSVzf0AlN4Jf99lTbDMociV0MRO26EMAOFM5BFWwfouRnVkWe6BlsTwW90c8
	SYUqFPZVFaiSezCNSx0qxpwdkKV3xSIZ+hnlf9DSzyHKvGJ4nu4og0UMaexwZTqZ9GHSUW
	2bdTpJEj8D+TmBAOH5XU6IbCpbaAPNQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=K5GAjMmh;
	spf=pass (imf06.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.195.2 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758065641; a=rsa-sha256;
	cv=pass;
	b=e+PTZbyPGDYJwaFM6S3x7fCWgF8UDwW+YH0DqrBVUcdCTs/zZe9v7k7lKRNcinvbSp4lCK
	ga3Q9wKabhPyeLDvLZnABXykijjKRNa8s7mXE5vu1EaYDw1m8d8axJt38qZXBBSkKiN8AO
	fBZQhHMplhJnI9A/IXFV3Oy8rmjV6Ys=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPBzAIgUyzmyLzAUM8xfoKkR/3IzuWpfbmrH4n82d+KfVHU4gEqsB1X4cAzKBeT4o4DVKtay21If6PLys8Pnajhrli+LTXYb4g9wn4bFQ8Yslt0lN7ObpP94s4b5U8AahpxZBn7petXpYdNKeYzHfN6Vwvb4hSTicZjZYkAsQlG0U6q0/5h3SQ1tehqa3GORzlGRrdJ1+TK3GPM6pu56V2nw/YSMGqb9Z5OkNzZ4dqMAyBN5+TF7FmgFtjnX2jNPLY0kKQ8TRD6E9pNRW74FpdG/L2EJ0KmYcaT3aPufHiHYIkvDwCDr+X5og4/x8LIDqRWcsRLP69GBKGX7/1BJWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cj8fLV3BBwNmrLeQQfjwntZ/T4urDB8PG/NecqD4WrE=;
 b=VEoMgFpaAkj2/GmFNVe+g1EM7HnZkfKPKe0VfDdVpu57/8bmt6FxTZ6YpaLvmakQCkxhela84pssX8EF9HtlUtuFUsX6T3XMzqk9kWNz08my6mHWAkjBMSGatZFBwSynlklVow6JSIMRfcur2qgDnkGLBLQikDbWtcQe33vdGg5rO699c5S8Puxo8jpKY1qKFI9OpBwp37UUnLtQBtCBcLWRkygUFF+k6ve/tstgIXTv95dOqoY0SwjD+trEHqc0W5wjU2cS6KdWfculytkWdAT4jb90eCZrXW66ZWrV8PW04ILJFenOYfYCeT8bJOYL1d3G015mtQNGqD1lNZsPGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cj8fLV3BBwNmrLeQQfjwntZ/T4urDB8PG/NecqD4WrE=;
 b=K5GAjMmhQuRje2tg2YexhXkkGVV4I+v/AM3GuRRDk0tW2qYhjCqw7HC3aAbE7C8w+OWnoD8MVIxhl7b25d34OYfmQprAcJmE9KBS6ZuPFSDbs+4HeyGX5uV9Ij7eP1s/B3jCPDL8KtKO39ekBNZnMz4U6d3wFp4P5TxNC9Z6qj0=
Received: from BYAPR08CA0003.namprd08.prod.outlook.com (2603:10b6:a03:100::16)
 by SA3PR12MB9227.namprd12.prod.outlook.com (2603:10b6:806:398::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 23:33:55 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:a03:100:cafe::e3) by BYAPR08CA0003.outlook.office365.com
 (2603:10b6:a03:100::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Tue,
 16 Sep 2025 23:33:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 16 Sep 2025 23:33:54 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Sep
 2025 16:33:53 -0700
Date: Tue, 16 Sep 2025 18:33:35 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ira.weiny@intel.com>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<joro@8bytes.org>, <pratikrajesh.sampat@amd.com>, <liam.merwick@oracle.com>,
	<yan.y.zhao@intel.com>, <aik@amd.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
Message-ID: <20250916233335.wv2lf4fiejlw53o2@amd.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com>
 <diqztt1vf198.fsf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqztt1vf198.fsf@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|SA3PR12MB9227:EE_
X-MS-Office365-Filtering-Correlation-Id: 578fca2a-af35-454c-4542-08ddf5797feb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CMNN4QLmxXNsrvAj+KuNh7HH4TK3kRkWPsR09mQSvoKuUotxXdWrUgoku05z?=
 =?us-ascii?Q?EEjZu25hS695YlUATCqylgG/RoKztOJXSpPW3xL62J1fhmRlX3sb6SMexNo6?=
 =?us-ascii?Q?1cB1cTLp6CmU+rgx29oCYEoU5FuMoPR5+F6QnW83xV0vA0xerw0KaltWg7e3?=
 =?us-ascii?Q?68hWySwUf2wbS0onl4F52KJXpU3zgHVIABjogbwJ2siNrl19/ekfp5gt5/PD?=
 =?us-ascii?Q?nUzjCIK3CcRXSoByr1d5Jw/KDMH+Kpcy8DQQNnCZZhZFyM+EMKnDHX1aAUjx?=
 =?us-ascii?Q?zj7tmWiRpiRo/MTG2Wdn64fjwCBbMRWELPWIvDwSXbP9jacpt5CsasnoQGz4?=
 =?us-ascii?Q?4XkdfJ3dgrBdv9Zxv6Ni02NfqD8/DSLHJs0gUHW4UDAkHgbniwXD28n11xWl?=
 =?us-ascii?Q?xPRolsiQtuaaSGohmJkPBxfirW1gH2vuzPkA3zKQVd73f/NxbYAFNa1e6KOz?=
 =?us-ascii?Q?OrNBI12mmyWIbL9WfdQ3bqfHVFH21V/gtZLh4by3Jq7Gs3/BWpHICxFw/JVS?=
 =?us-ascii?Q?/h13R14kFPMc6FJT90bJw799NWb59hHsv9IKiwPGZwcgtBMOEzYH9Xo9+iBj?=
 =?us-ascii?Q?fbCSMZ8OdsBIxRYDBhXaDcWXqxno85voyV7E2QFqlIlG/YJbtB8F2em+Ksm1?=
 =?us-ascii?Q?s/BuBuMU7rlpnliuhyOExv071dKN1Wy7Fh3hdVSAAV6sajMBRnb8jyzrEDux?=
 =?us-ascii?Q?0jxfhkyZRqK56d3n185XBZXABQ3oVirkAojyoc7YyFUup8H/gki7w7TppF1O?=
 =?us-ascii?Q?slPg4f+zU33yyyxIxnZ01QXeQUw9OscmjlgxPZzB8RjELBMj9Vf0hsaG9QJm?=
 =?us-ascii?Q?6Gf/XRgbe275lHwu6gSmV/lxo9tHA1fjMFDw+E3B2bMibzejmXzG+/MKvnSF?=
 =?us-ascii?Q?O0Qj5QT8loubao4GT3HiGxEafvQNbASJQQJlzA/k2QsZEU2HHP/cyyDTgPDO?=
 =?us-ascii?Q?L1ViKcouck70+tbkO1vmUJccQuH5Tg+ymNzldWB9/etCofC2kUMZD9gjWHEK?=
 =?us-ascii?Q?/yKtjzMVcDgAsYof/OOeZVzrdH+1MHtwCH336yy3CU6wgwA/yimygwzodFyR?=
 =?us-ascii?Q?ObiQPg8j3wF+3QTGrUXxvOooU1iBsPAbHjtetc5xzAicdvSFjpNLTeULV312?=
 =?us-ascii?Q?31OqM33CSuhioozQowFzGMINwqjttel4cHrdzACSUHY4GbMPZy4t8eh9RcPi?=
 =?us-ascii?Q?74/XjCqqvoxlViOlsskS2ay1RwWVyQXL7JdDslm1r/K/5J15sOjoyeVK0wai?=
 =?us-ascii?Q?j4aztq30kR/zAlZ41fjjvZIXN/lIJ2tzKxeeDPWN2KZzrXN/Pvh84jhCk8k+?=
 =?us-ascii?Q?6MjRJDk3T74V02dqrR773LM8XfmNgYRchxSIZ1cnl9PiEkuAy2WlSGlx6x+a?=
 =?us-ascii?Q?OfTwYxOm1V2GRGdp3fRsiVh9xxI/Uji9PwKDjNqJEpa3dLg6sWho+ZyE3mQI?=
 =?us-ascii?Q?hINOt6okx6WNcivjtmeDwrqxd5WhP16N8y5HLriDoj26PTg02rPre9FXC+HL?=
 =?us-ascii?Q?LE0GOHByw+Be7HE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 23:33:54.1804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 578fca2a-af35-454c-4542-08ddf5797feb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9227
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 515E6180007
X-Stat-Signature: 75e5wwdyxs1ganbfyz46bhus4o3ah6c5
X-HE-Tag: 1758065641-924176
X-HE-Meta: U2FsdGVkX19mmGqSNgIfUxELUCaO2QBn3kBJfaNUBUsRRxBr0l2Jd2Kv/QWHpLIVF7rBM0Lpby8sFAIBGOVtl7RV8gF+P7ldV+H0YFBWNQed2TzdPJDIflHX+2T0Ql+atLoXvKZUHh6vafDmCYq0XtEGQoY4W2ybpNzTkXo1wtW2N1NpAREMpPDR6A1mhxAblQgD+gamle/qpLu7Ewvodg7+/iZ0aPzCzvsM++7lHMKcXDEDTK/WZXMFjDUUyweBbtD8OpDisR7DUtrx/v1biio5oll6f6Y3znv3ntlgi1ig93Hv62SsUVYQQhUgQNlczSDPlPd2ZUCpQVcnxpiXokASaKe26stOr/HO2S8DDXJGlR4nbm7UCS5JW16fsvc6OjVxd5YbbYpXVzjt0FT+kK8HjC1kQC4DyM551O1LNDTQPf+JUqCfuzUXfVjY3usv8e39K33ewgrSaXSk9zdC58q3ZJtln9GccHKKG8MMOAN7napLLqNXlt84BxISmNeL0F4IfLVuwz1BCgYCiPpfvzigbru/Vzz+8q3XWLxdJ1aDwm++zcyVNmVH9gfG259DMuAhJop51u4RRGxdoMRvJM3zXs/XS+Dje+PP9SwIqzlYxnHuvkQ1+0MXtfeDp9dYgnCo7chjCjlHlh6+48EpNImr5peEUl/Pg9L9JY0KrDyJzcQefJXzidIJqBSv1YVs42jojIm+SLilSIA1kQGa1erDIOOP13TvzH5pZPdGE6GENKI2C4PT7G0DouqU4wXu2GE66GM4fskVBjhI0l+Qg4Q8pQ1bnRemZLN4YUMVLN5Hg0oXBQW5HrXcp46HxUGnhn30Md7eLURusCZwPs/HdYZhHveoblf1ftVDW77c6oQzMX8MxvTYmCTRWtVAmHtjRdSqT4PUOsk0y/3cQrHnwvxOvJYtm/EqX4WkjrYtGBoNJa2ceKdANXXdJRtrh3IsY1wCCT5LrWpVE6cIZHY
 viBCxibX
 HKc2MAdXMngzFJ21FeQC3S/gSFhFiFPMi4GFD9Eviy+Mdw6DdrqgRIbjPU4vJny0bng1d1/UAKUKo4UprPquc8LCn8U3wNyAGDQZsqPyoPaMfPQonJRrlbgMygn580LbogvlSJj7M1qlYFfU9jwM/F5mNi/c5Am9EXB42sukHhAbcZfMCdxRptZmnoU4cB7o293JMhaZD5pVan6OPp90tZbyVJMM6qxfgoqEewln6ypnRYYHCb+t6LBG7g9EraGyaet+mp4lSXy/wFr6pXCFhZkTJTTeDk0SxIvC8RYeiNtaHvVw6HuHRLdDxHOrBQNYROb78LxxnBwYx8/LiM/oToAyTX8zObjbyr+Szmptl5oOOW/B9/Di/NsxDF+u8A8xugRtzm7Gts+EUkHUtYtoqa2kIfO8r/ov5cCkMTqyB/dUtbvjYrc4Fw5OTy9qx5EL8Le9bAuSBWTNaXuGoYeuMLsz5n96AvcxyA32er0TIOy18AER/a9QpAgtaHF6qjm5rFvvZEKSuE9xYm5sz1341RyyCcsvEAbtlVufmi1LTbk1GAxU/Gjzy+HEGryRLe9XoqxRS5p0rE3Jwgza0rNhwN7cUQVg2PWtZbIvcYrFZiLIr0LFOtBthkIkOKEB6IC/3GPQGUFhhBBram2+CLZckckDl9I7imNPRL1WfMX70TOgYPe2IwUVyrTDdhglXhKEC+VS8RTYSrLfMesdO0qN2/N+u5T4Y06V2252OzuyzduDlPWH256eZ1wkO5wptBHTwdi3yuDseyUqD0WRfVUSDtKuXQd5yiCMjrck0Sh3Jkw+wSl4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 04:08:19PM -0700, Ackerley Tng wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > guest_memfd currently uses the folio uptodate flag to track:
> >
> >   1) whether or not a page had been cleared before initial usage
> >   2) whether or not the architecture hooks have been issued to put the
> >      page in a private state as defined by the architecture
> >
> > In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> > there do not seem to be any plans/reasons that would suggest this will
> > change in the future, so this additional tracking/complexity is not
> > really providing any general benefit to guest_memfd users. Future plans
> > around in-place conversion and hugepage support, where the per-folio
> > uptodate flag is planned to be used purely to track the initial clearing
> > of folios, whereas conversion operations could trigger multiple
> > transitions between 'prepared' and 'unprepared' and thus need separate
> > tracking, will make the burden of tracking this information within
> > guest_memfd even more complex, since preparation generally happens
> > during fault time, on the "read-side" of any global locks that might
> > protect state tracked by guest_memfd, and so may require more complex
> > locking schemes to allow for concurrent handling of page faults for
> > multiple vCPUs where the "preparedness" state tracked by guest_memfd
> > might need to be updated as part of handling the fault.
> >
> > Instead of keeping this current/future complexity within guest_memfd for
> > what is essentially just SEV-SNP, just drop the tracking for 2) and have
> > the arch-specific preparation hooks get triggered unconditionally on
> > every fault so the arch-specific hooks can check the preparation state
> > directly and decide whether or not a folio still needs additional
> > preparation. In the case of SEV-SNP, the preparation state is already
> > checked again via the preparation hooks to avoid double-preparation, so
> > nothing extra needs to be done to update the handling of things there.
> >
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
> >  1 file changed, 15 insertions(+), 32 deletions(-)
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 35f94a288e52..cc93c502b5d8 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -421,11 +421,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
> >  	return 0;
> >  }
> >  
> > -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> > -{
> > -	folio_mark_uptodate(folio);
> > -}
> > -
> >  /*
> >   * Process @folio, which contains @gfn, so that the guest can use it.
> >   * The folio must be locked and the gfn must be contained in @slot.
> > @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
> >  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  				  gfn_t gfn, struct folio *folio)
> >  {
> > -	unsigned long nr_pages, i;
> >  	pgoff_t index;
> > -	int r;
> > -
> > -	nr_pages = folio_nr_pages(folio);
> > -	for (i = 0; i < nr_pages; i++)
> > -		clear_highpage(folio_page(folio, i));
> >  
> >  	/*
> >  	 * Preparing huge folios should always be safe, since it should
> > @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> 
> While working on HugeTLB support for guest_memfd, I added a test that
> tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
> gfn.
> 
> I understand that config would destroy the performance advantages of
> huge pages, but I think the test is necessary since Yan brought up the
> use case here [1].
> 
> The conclusion in that thread, I believe, was to allow binding of
> unaligned GFNs to offsets, but disallow large pages in that case. The
> next series for guest_memfd HugeTLB support will include a fix similar
> to this [2].
> 
> While testing, I hit this WARN_ON with a non-huge-page-aligned
> gmem.pgoff.
> 
> >  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
> 
> Do you all think this WARN_ON can be removed?

I think so.. I actually ended up dropping this WARN_ON() for a similar
reason:

  https://github.com/AMDESE/linux/commit/c654cd144ad0d823f4db8793ebf9b43a3e8a7c48

but in that case it was to deal with memslots where most of the GPA
ranges are huge-page aligned to the gmemfd, and it's just that the start/end
GPA ranges have been split up and associated with other memslots. In that case
I still try to allow hugepages but force order 0 in kvm_gmem_get_pfn()
for the start/end ranges.

I haven't really considered the case where entire GPA range is misaligned
with gmemfd hugepage offsets but the proposed handling seems reasonable
to me... I need to take a closer look at whether the above-mentioned
logic is at odds with what is/will be implemented in
kvm_alloc_memslot_metadata() however as that seems a bit more restrictive.

Thanks,

Mike

> 
> Also, do you think kvm_gmem_prepare_folio()s interface should perhaps be
> changed to take pfn, gfn, nr_pages (PAGE_SIZE pages) and level?
> 
> I think taking a folio is kind of awkward since we're not really setting
> up the folio, we're setting up something mapping-related for the
> folio. Also, kvm_gmem_invalidate() doesn't take folios, which is more
> aligned with invalidating mappings rather than something folio-related.
> 
> [1] https://lore.kernel.org/all/aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com/
> [2] https://github.com/googleprodkernel/linux-cc/commit/371ed9281e0c9ba41cfdc20b48a6c5566f61a7df
> 
> >  	index = gfn - slot->base_gfn + slot->gmem.pgoff;
> >  	index = ALIGN_DOWN(index, 1 << folio_order(folio));
> > -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> > -	if (!r)
> > -		kvm_gmem_mark_prepared(folio);
> >  
> > -	return r;
> > +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> >  }
> >  
> > 
> > [...snip...]
> > 
> 

