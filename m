Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31914CD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACB66B008A; Tue,  9 Jun 2026 20:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D816B008C; Tue,  9 Jun 2026 20:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C596B0092; Tue,  9 Jun 2026 20:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 527486B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:07:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B07FCC298D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:07:13 +0000 (UTC)
X-FDA: 84862063146.21.5BC3FA4
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010042.outbound.protection.outlook.com [40.93.198.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id D76A3A0010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:07:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NcDWOeuA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.42 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkbhkGkzPjl4y+cGzKbn//W9V7DQAa+9uXxpKOR+vPQ=;
	b=juFjk/MPZolvtWF9qgHBuZwOyGhuvLlCMgYnt8+wdtZxsgRZnelk3RGIBd8OjLBJ4I6R1Z
	VoHIDlstQ4Zl/QWQrKcVrWsrtL+t1w9S5DTRtJdB7XQ98g9ry/aBqZcADwrECx9i6xmz1U
	f+chPsOlnQXMNttAlU8web6lAL6SOaI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NcDWOeuA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.42 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781050031;
	b=rpBjhOBpSKvQJh0iOSnloc2h+8gGhfOP6fFJRVfKLHNP2NZHU4psLrye1UZ+bD2gz/nERO
	p55jfDWHWGCBK5f7m+x7cK6PC+sjzvEaz4TYZ1Z58bdmYTBt1o6DktRG/GXUlZyPlVDxAj
	MzwD/lliD6ZUIlo//1A+Tf5HK6d8CF0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BK2tStXrUTvYFBehiQIyoM5T0dsLaGCpKJin4s04A1ddO8cwZyLVeyglBOEjsj4UWtBJvJdWuyLNYp9ZcNIpzTZUiYOUNLkbXH38N+39rEYmYWNEneOVBjMWpfoqUDb4NK54OpsHiC3uNqHIYYtjY6HPulw9lZOpbGf1gU+RMBbnmUfbMHtGWGRLtCybi8TrQv0MeARjx+/PYvtk2Y5lh6S1Rz428LJock0KlfuNebNKDbzvHTNUEp30cJbf+yPQVUKr2GUnWjhei2n6vGr6NDLs7n2iBjbIm1qjsIchI+Ic5Da+kbf4LTJwP3g/AthOgZ3yl8jygkrU3f6Q1Es7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkbhkGkzPjl4y+cGzKbn//W9V7DQAa+9uXxpKOR+vPQ=;
 b=XwlZDSLXPqJUXdHfJcN9ctEmp+b6JKLkQQF7Xfbcp0x+J6pq743d8HXqMoeQrRVCApPOUOfc6iZkxQxjjHg/n2GG/rzYmjoKb8OKGVgg+XUl7R5mWipXt4NGrw6iUvnYot6wA753aLxJjv56e0sdUflKPnyIKrzCN6ypmu9LcyRTf9d3uWBIJkDs3MHvBdM1H+ONlMbiv/svPqbBGr/GPOBCmG3gBAYW4lhBVgAfgKalIBgQRt4oXNhkcUFizJTzMltXTZCePzTW99+Yst9jUwkpIJY9EG0Q2PxEr2e5DfmlWH57fURjWiZo/swhpMEjXkYRwrS7OLyrxakra6kghQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkbhkGkzPjl4y+cGzKbn//W9V7DQAa+9uXxpKOR+vPQ=;
 b=NcDWOeuAq5Swn9OptVkLYienmFptO0w/8O1hAHtcBM3nM0cAT6tnOEpuYtspVwuG1WiCRxPobiE4NOeZRxp5SIPtS1Anqllwa/aK1qw6UYqzWG+aRzJk9TAaVemqYLp7OjW2UZMDipx/duXqmUPWyyzacczelHyp2wsHYH73yh9rA46ULqpVmwqzTVVv7H2hYfJrKUJX/bN6oW1OPRL3rhtcwAL2UqWxyOVwf5XMMPDutaBEW6v7XdB7loCvUuLIgwFX1sUasbbv1+1DlQmMArV+EGLH98iwqJIXyIjeAQim2PNuDeiZD636jvamdOUefzWeCyaZJAyF0QpGafFObQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB7799.namprd12.prod.outlook.com (2603:10b6:a03:4d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 00:07:06 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0113.011; Wed, 10 Jun 2026
 00:07:05 +0000
Date: Tue, 9 Jun 2026 21:07:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
Message-ID: <20260610000704.GR1962447@nvidia.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
 <aic6mdiZ0qUJpFca@google.com>
 <aihLTgs1Y49OXQaV@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aihLTgs1Y49OXQaV@google.com>
X-ClientProxiedBy: YT4PR01CA0380.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: f1b697c4-4665-4c18-4d22-08dec68434ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|18002099003|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	zxAeXQpo4vTvQOpehrl494RudWGQm0omaXSu3I1QjkpdRcHHCBrYtTR9wBNP94hB2tO8uHUBPIZCwp4ezc0y2t/5quMETC6lJ9FLiqRfbpcnsxn8c7QllQc4x/tcjQONxAPakXcWPiM2dof1zIm1b5urC3tv7VedQ2oseVEywMpZjH/38eUYgFhU42DsVklXEaGI25RwSUMFhxAkYkUOYKb1SXvrbX3WPTaEEyxJ1tZpMI2ZCCOAHCl9qBFiqK0UH1Hb8ztkyhRUzogeChVaMXqXGAksjxmMozvCD0L/i6AcQjVvizzB8YbHAs5IP6DV/6o61p32TDhUS42RPuS6Y+RcKkAv8S1HjKTtNCund2ZT3ttf4pbgfH3eUxshTwhXG31xWR9MbfK1IJO5hKNkKe9EsxV/hzzb1VsMizRSupUvl7mh0rt+5bZJHDMGspKAJmeM6lllPQCT4zUAGA68AcFCJPgLC0AAkfb6kPJd4vzNrHRYxSSqEJGqeH37sbfhOwJjZX8xQh93p7PIIUa9U1v1IZvctWqD6XF/BCOdvSgy7hEb2/YQcHfX48I7h7d82ec0KFTIwW2pYxQ8wqtgHLCLncULUdgwoZaDzZdxebT1sf4sj/t68Y1f3c/Ul2HLvFVqilr9iaJKrK/nrg7nXzNuJ4VQc0Qt7BtTdOneVKj8YNL3sjs42eZ7PIsOnw1m
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jdzs1Lf70Umdrm1JHkH5Cmz2HNoLQlkFSptgH2hElP+HQV7EcPs9IUPIpktu?=
 =?us-ascii?Q?fhqv0M/mLsZnR5pHR9VH0X6bLG8fT0a6fZb1cNv6it47KTKJpMhpcgnwJY1b?=
 =?us-ascii?Q?hyiESzk7KuT7tS54a5exZCrlxYde+oF3Jicn8Uk8WmbRgyRebI7rr+jWQb7B?=
 =?us-ascii?Q?b98PhgCDcq+YrBf7QVy9z0KJZsJ5sOoNKvKHvuzQXlDhBWgMkOJFbDsrst6r?=
 =?us-ascii?Q?FsrLs2IO+0rCAR9CeCmzxj3GOXhLQOYPAS5Sg0j1YhSdk8QFbS5Oc6o1O3ef?=
 =?us-ascii?Q?p3/R/8R9MWiW/ANyyonJnjp5wkn2q4H9LVeUY9xb0k/VM2UO2SEH2JBqaoDd?=
 =?us-ascii?Q?93QObgE+9f8SZ3wq+0Uc48/kcyuY/3BswXLzEa4qC2041WJRyinhdE4SzZsI?=
 =?us-ascii?Q?m0nEOmAw8hf/qT8dE9IKHsoN0WMccpnMlFUPWPxKshpv/om62GuN8Kwfca9j?=
 =?us-ascii?Q?+HcPnIHByM5/Eyz16yvvMoKsMQ62aeu/dm2XLUmEf7pcPtBCZTnz8HsuqAtE?=
 =?us-ascii?Q?ilK+1BCkdVGnWb2931YRdYlblo9u5NY04QWFZe8EIjv0dR6pHVv0PiqU0h8k?=
 =?us-ascii?Q?NrCtfgJo7SMzhjbOWHlB+uW0XFn1gPgO15S9+3qh5mjXZXB9+olqb8h1QFnD?=
 =?us-ascii?Q?dpxRvPc5NiEFKDZ+F0zv15AwVJKlcwIX3GZR+yE6wUvs+sVtQ8H6lnlYRPjq?=
 =?us-ascii?Q?Hv20bLlL97i2tURo4GYA3uFvfevoQWbld1+Dy1u9+qeABD7i06Uv0B7KY6Wf?=
 =?us-ascii?Q?LvBNMFlQEKxo1E9TYhjgYy8U2E88br/+CCJJ9lwpXBB+3bYg4bXcjSqnrrBm?=
 =?us-ascii?Q?g/w5rD0l698+hMSRFbsLsAzII78sQkyDhpA/TzuXtFycHVqbK0Z5vbuGJpPT?=
 =?us-ascii?Q?xxmp/mn8V60J2ie4TvB9xSiIsfa8EpgwRBOkatekNo7XUGvbp/WL8Mq0wcg2?=
 =?us-ascii?Q?LjOAP6lWyOPIEjIdb2NrlY+mj8Sxoi1BrySRQP71tD3CI+No2PV7Z2VS8eXi?=
 =?us-ascii?Q?iQNC1zrJ7crY77JQ9MeJDA6kvYOxayWme5xJF1d/afgSdvCQQRvKuNG/E2W3?=
 =?us-ascii?Q?qkBD8puG/pnVN6CkW529U7y8gB/iEGnvQIoxjdmeKfzKAXu9HH7FC1DIO7+k?=
 =?us-ascii?Q?Z9K6beQwhJfW15xHDZeHZcbwnN8UmtmXDL/NKG+heKUaZfEabbFaVL+IYVH7?=
 =?us-ascii?Q?avV+42sUL/EWS1QUULHaReHb/UXllWRD75FIzqQWjJisp1HIUFLrxNw15iUb?=
 =?us-ascii?Q?cr2ilpKQzxDsg5PBMX6+xRmyffgtBrQCVjIePgRtr18sN3VA5vbQE189lMI1?=
 =?us-ascii?Q?VQ1sKwxec4VykOXKtpLTQ6Lrt08gCnHfa2NAG56ONJxSsV5av3KtHNdJ0jIz?=
 =?us-ascii?Q?Q0Ie4tgX1kpHCHOlEDUvLAYr7wdnMjXCcT39geE+S+biBfIlhM+MmT1IWG+c?=
 =?us-ascii?Q?Sq4MInK3bCMLE9hXJYg/4ZLz7zrIhyep26JW/spusqkJ+awgXrlsKvs9aYwQ?=
 =?us-ascii?Q?CReAAWR8OTPuuzh3nBh+QTLq7uQ+WK/yb1RFnxjeF/taMju8Ad7oXyyqh2f+?=
 =?us-ascii?Q?DECSz5hvNmq4kEMMP+nHRyLkuxBgBOxybfGOcI+jHYQDDkmfFck4Gb/2wHZe?=
 =?us-ascii?Q?2RBP9KNqCWHWW8R26YnzLYKI4RpVJvSU2/YBTFVyUfn0JWh4xxkNOSkxhy2O?=
 =?us-ascii?Q?IUZ4JWZr2cLAKytmbLZgv3cIQ8sIoGdjHuRFIYL1Z7vSDq7E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b697c4-4665-4c18-4d22-08dec68434ca
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 00:07:05.8498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WgR1ZrIUSuJEB7IPLgPrJjRoU9HRx+YnzNs8ZBBh6gUJazMNadsqY9yeCOMHWT1i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7799
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: j3h9yprjsczij6g69ednt83jmhdo78be
X-Rspamd-Queue-Id: D76A3A0010
X-HE-Tag: 1781050030-201358
X-HE-Meta: U2FsdGVkX19pZUO9UKFUnNZ4AyhBRobNu+Lan4T6ghQ/Trk1jg+fuGKce2yVgFGRm9jHHLWD0sNcc5mOwf80AxIQ5EKS1j6ZGxMj0ViN1Klk0K7G6vgFRu59lefAux0zmgcEs0BVNNHcz6dRNaPpfujIVs1Vs14X1YzrV5tmmM/wYM+iBngKlf0GjUsAhl6RFUL/ztrkWTSL+iqzCrtOOtLhKGzcrZSJsssx1MUlSj+1fI4fsyU8il6H/eS0nZ0DWMpvfXPqUU5vTGESOrAXoCDPnNcX/S8xY5qHf8COUNWy2kmAjYBVZSZP9K49aeh26fb0TyVEPo5RB4Rw55NtTYXSfAgqxgiskC+e3oc4TjQDvk8Hxw5kUaSnev0m2o0mn4MOTEqr+O26ukhXF7Ch2r90o1OsMsK9GUK+PKcMq8Fzt131jX2XvIFq2wo6bOo77IGX/Gq1kKw1wiYhomBqG57Ak6GW4amI4HbGWglX9BIsnZqD9U54qo9qS2zmn2jdY64P0ibahYyQo+Et80GrGfWMY5hzPSQgt4YTdTwwNfp3A+OsWy1DRltjh7TLmU6VvS2nABKtvZ4bVUVpRSkeBDfsyKE3B5sL55bafmtZ6P9SvW+NoIaPVpdxN2Oni+zbR3EvTznTLkkqoSncliy3KxaEX6KLKX0dGjGQ7w6qxHaBrZClAj+Lgp+OUvtihJg5eNlFTZfkPhBkqvzel80ezoKgDJPBUtgK9lfQ2bggXG9Gd66eyd5zvH6JTXmb3h2xpU2TFtqq9l0IA8UCwyRj/JvjU1crlL/z6UJ+NqnyyevVcfAj2QsyaOB/Jnzy+xiYJuh3B5oVGBkKQenhtqKubVyUWFx2dHzc7WmyUheE7XZl4du/rsoLtEhoDoRmq10JV1DpGyzMs9yTDk/hZWIqVnCo7OnwuRFV3QImYR72aoGPjyEw7JMmbOLZ0Zw9KBgiFrsFozDavleL1CQXAe7
 WIuAf8lv
 nKqZSM/HroD5r+uOrcqJSTh7Dddsy/KOe7DaU3HppkF3HTEckGsvuqn1jkHwLb46EAM8SZFiaHGi/C32L6nz42atij533NaYD1hH8yhKvO/ECSVbxkuc11pfSx+UHFanJg3sPzHOVZxFhR44Rmu9tRaDgiHxw4uloLJNJukRfWIZDNGQTvoAnbb/Bhd/5p6Je+DcLICX9vRs29M0tRC3ehKVxFmrUn1NqiGDF4YnPhTDn5FVG056aOwTu6HrrheuYP8DVf/B8oIVbEajd5V3BRmUbvKmHRR/L9cYsOn/0/WeDyMK8rUsUI64tXrZ134mb5Cs/Y7FsMsNwn0YDv9JG5MhT2m5mEX27VXN6FyTgMRFvLwy7DlT36zyfdZkHkmXjLkmwK24/OxCVbW01hQbUeG7mpMvZ2lfGPCv/uzjlKjwYaSsiN5jU8nh4gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 05:20:14PM +0000, Pranjal Shrivastava wrote:

> Now, the attacker has an opportunity with Liveupdate, since the devices
> are already assigned, if *somehow* it flips a bit like ACS_RR, the

If this is possible then your environment is already security broken,
no need to involve live update.

Jason

