Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB40D1489D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904496B0092; Thu,  8 Jan 2026 00:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBB16B0093; Thu,  8 Jan 2026 00:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8BF6B0095; Thu,  8 Jan 2026 00:21:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E30E6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:21:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F98BC2210
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:21:13 +0000 (UTC)
X-FDA: 84307648026.27.DC30A39
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012029.outbound.protection.outlook.com [52.101.53.29])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7EAAB140007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:21:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nv1X6lht;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.29 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767849670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlRiDkGG84Gwsj4uUQXSCbXADGbX/b51+87euo3z0/g=;
	b=nYe4GIWxB5N7DD/dqesO+cLgaq6f1NlBnANtEBgg6m0Zv7H+MOc4xX1nDeOaglXjrC6YXz
	+wEQVFZ60P448qPw7mlRXfN+PQ/U+o373XH0egWHKEadkFahYFSB/bjseGQAv2l+1WJHlR
	d0Dpnj/MSkqa+/vaHw2FLxDcvmCj1q4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nv1X6lht;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.29 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767849670; a=rsa-sha256;
	cv=pass;
	b=yJbEYVEe03IUdjoEqf1iW1adQJlzuktmccd98SdID1UtpDvmIql4NDOMKmnxJ7T0kbcp+L
	vfNwo0fT9zF20SIgNhp0f2Oc/xr1IK0MsG6qOz7MgP25Hb6LzDUp2PB3NmpEdmD0e6iZrp
	CnV4Z/ECZcjxmuIVWM4gyaWL/q+Uqbw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aqa8x9/9jXTUKO6iHccx98RcYZbZjOv38uAYk8vWJm1pxhud7WloU5fEMpgXKbWZF1jiQ0nU3sVh/bxuXJQ5jcAqebRzPO4B1+/hWIOg6aJYdwgKQeLi1Mw3zRLSj8+KKFzYHTRrYTeDncrhilMq8isuQ0WQ36F8HQgtNQ6nRtt1LrU30hKQgiwIfjSmIr18lG408CIJaZIWEKAIPtLVKoUviZ/bi5wS2W6GLmJxPGvfKhqgeFTWd5sKHzvPyfG/ht6WwA/EMcbGvuNMz1FA+/yKONgw9FEpBu+1cCM6xYZrEVs5ZIAdmDQiBxHH2M8tsPuDrvYBFZGwn8sFUmO8rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlRiDkGG84Gwsj4uUQXSCbXADGbX/b51+87euo3z0/g=;
 b=hQlUU8V75QaXJMloEVwRTTjM7ipCvagvOJ66AsE2NcYfKLjjTmWb5U9Lw8/EBdP/A5ZcNmx/OeogHeuICMjOBF5EPm8ZWd44UCkjAif8Gtw3CBSG/DuBdEu2kROVFiL6Brnwnhgu8GZ7vt7YJ/03b3c637wCEueySW+dWRlqaeTREhicMA87ElVNaVj55TW1KgqO2NE/qSnpvmAUT2E3uxLASMmfChvzLRg5nz12CZI/uOl/L4WEOxcIRkDvb/YCilqunF13Xwr675GbUtIjtAIw3DECwnl3luTFG/8WMwwB+D7Smun/eY5EEhx02zPbueXro5lU0p6dtkav5DTvQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlRiDkGG84Gwsj4uUQXSCbXADGbX/b51+87euo3z0/g=;
 b=nv1X6lhthpeqSKhhaf9AO3BXmgIaTiaqACnghP9WcKEodo/Su3mwIDGDuDlzBBLN1pyStedgQ512n/NfsRvdGYRifxdzIFTZ3R4mTBB+yvM0NrGuSRok3WHEW2KqzWvZxnsvR7DcYaocV/olyq52yDiEjy86v67e7VYY1yQHyoJK7bA/a597u4jT6Vi57pqXMLmQdX9DrE7kGq9Qtu2TW5xOU6EfzVSyhngGqLcPaLP62U5qp5NxLaCsSWj5L3ph4EC7zRX2MjC7amEUWBRIu2wJaDoytWQnB/OZSRNqztdPFOR1+tIfWMkon07EDIbEr9L6IK/XsYRV5vW0GnDVKw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 LV2PR12MB5992.namprd12.prod.outlook.com (2603:10b6:408:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 05:21:02 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9499.001; Thu, 8 Jan 2026
 05:21:02 +0000
Date: Thu, 8 Jan 2026 16:20:58 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Hou Tao <houtao@huaweicloud.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-mm@kvack.org, linux-nvme@lists.infradead.org, 
	Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, houtao1@huawei.com
Subject: Re: [PATCH 10/13] PCI/P2PDMA: support compound page in
 p2pmem_alloc_mmap()
Message-ID: <ru35ev2clily7277fh2uwxuiellerlocfexhjkqim7stixuact@7fp5h7fdmz5h>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
 <20251220040446.274991-11-houtao@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220040446.274991-11-houtao@huaweicloud.com>
X-ClientProxiedBy: SY5P282CA0137.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:205::11) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|LV2PR12MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: da66b8bc-7897-4f0b-cb5f-08de4e75b6eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LpSP8yeaCzOPhsLDBKLwDZDUC0uSf5r0XI7UkitrMaKGHa0Rc2lQ6nuEXzzX?=
 =?us-ascii?Q?iDjxJC+HcOO+1KudYFvemWqFseJqDPp3/iO7nXPCNqlDwHL+UKrbIdON/Tnj?=
 =?us-ascii?Q?tahkFiorAY82Hnc4Z9umMBoMzY1OP5i+BmeKk+4QVxtg2uVTw76X6FIrjMG0?=
 =?us-ascii?Q?eKMUhozIu9T/U7ezVQb7ezoQIbAV0tYGaij8gbxXNg1sE4OLAVPGhNfEiCg1?=
 =?us-ascii?Q?/Oep5+7D8P9JwnWGyCwsw/1Yd38JQOBkCgjR0vXJ5j9dTLRy2gyIZSl3Gfdg?=
 =?us-ascii?Q?mltiD7QW7ucinIB6kKkPUM9mc4YV2rfa4x8UIoCFt2yVrN/TLJsSG4ezz23s?=
 =?us-ascii?Q?JkI8KUmJ/7uwamgVCcZ5jmAzVRClmDYjjfRmgIGAitDuUF9HdKozxB3VzxeM?=
 =?us-ascii?Q?7m8vZP3v6NtFCX/sdz5gV9wL04E+Kn+E+EXAOZy2CC7kYSXyezSlVv2EQ/QW?=
 =?us-ascii?Q?qyHaJqNsXCaBAGkrBlOznV59oXIyP/MEi8I3dlxCbSTV2CVw9718QrzXM1c5?=
 =?us-ascii?Q?jLyGscBJSJSTqU5kG3qbf5HkSvyX07LAu/hZ4Nx7MDArbs0Ci47Svn4I7SFl?=
 =?us-ascii?Q?OclRdCp7dSE1CGsBY/o+/7QPSoqRtHC1WJnfFhjxQkPjhzQYDLkpCZ981ncV?=
 =?us-ascii?Q?NVxN8HZvH1aZep/fh4NKhfppjYksW85PGTPk02auyqtNaVWYVpZUbCwJ/mMT?=
 =?us-ascii?Q?K8dNSKC0VGRyq3ol5z3gWXAEggjsy2whi2xZp/Hw3Sf53UU6QrLAtfj72DBz?=
 =?us-ascii?Q?mV2WVDwSydso6vy4Vv8WTblLI8EV5SjWB21+rPNjMrXUqtnpAAMHG9KsQT1f?=
 =?us-ascii?Q?1/yARA1hjVQtDV/fU/FJeLXYMWgfjxgVVg0NCW7UYpKgd0aTyqJlK/XvUREM?=
 =?us-ascii?Q?8xKLnhavi85KrkMcTL3uGmdyadhM10ZNLspxsOqnHAAOcm+GmAYIdJP1KQTp?=
 =?us-ascii?Q?2CSP44SmFAAN5dgUK0TOhXbOZJjUBsz6E9EAOPGESsoaEH9mma7r5WiyDRfj?=
 =?us-ascii?Q?KQ3hcc2SkwZUiXqbU9WTM0/SN6mqfv2cBVaWFugbAEQjJBaslgXVi7kJu7Yi?=
 =?us-ascii?Q?IKDb1WLUV3Ypz+gueRxdm6CaNYWXZsIRXtUugnCH8jq1CC1KixuBSVYbJ1yN?=
 =?us-ascii?Q?4cmIz09sRSb72l7EH8S73ElPZO7xOPRXHAZpKv+f6pfA2yunRx2joIepaAgg?=
 =?us-ascii?Q?/wu0/MzejVBHKe07kZ+cCvV3i+Cq/G2bnZVACx/srtENp3NNTht91jjkVK89?=
 =?us-ascii?Q?RNXY5pTPVW/0ahMlD5pGz8GF4GCsIIzX5U3MULCsQU9s0grHAz9R6yp1U8Vg?=
 =?us-ascii?Q?3mvXK0E5kQzyG4suTclJxKbXXPWtSsPl4EQVSL5KYyhgycNNbuf8Exj7IyOj?=
 =?us-ascii?Q?cuNZseCYAbkjHuYjI71kqXSAgUnQfqdg57JUFF19bQNQKupn/3bd1016MFvE?=
 =?us-ascii?Q?57H4bBiWwSkbzrdb7gpAMqFfxUSRfbdQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a3u6xaTyqjDGxND80WZd6Kzmd1P5+V5NbNM8wCYA+yrvU0fk3cuChh44IPEN?=
 =?us-ascii?Q?zQjIZ3E3HBBI9ZnABOXVtle9lSuRUsxBWCjUx/UqxtL8qIcxjv3tZ+iqx+Y9?=
 =?us-ascii?Q?bFa4sTPw79xyKV0C2xw68jfmvJUsZtcRICXZgv8zIApc+enmLnvKlaKYTTTr?=
 =?us-ascii?Q?oMIrOtFnOPp8PxF1QPwXUp+97ZtOCLQNgcPSqDOlb5m3INlS8bV3RKcRazzT?=
 =?us-ascii?Q?304z08fxsw6ZfTyQeh6LG+ME8fQEKen5FuYGyikBwZqXqe/3Dbh0G5G4TkwZ?=
 =?us-ascii?Q?+fkXg7cc6+zuAY5F2gj4m9nUTYpptQ/xaYvEANvhxK2MLigQRVDHfAn2yfMa?=
 =?us-ascii?Q?8wB9mFiclLsTTcdpe6/K1qP/SEdx2wjS9pM+SA/zTk/+/vYYCS97vZW/RzOb?=
 =?us-ascii?Q?ceKXUSichrF150uq01rrHturXcXUICe3SCgWyuzDLveRo0+roiIID9kBg2vU?=
 =?us-ascii?Q?igT5twU6Z76eAGninqUx3AP2WqPA0lHIJ121dJRA17Ib7gJCO353GeyNdyyP?=
 =?us-ascii?Q?nw3DNPInE4d1XD+gZE4ZGCW/Ay44zA94IosIwDABPwlU04+Wlhv5moz5scQX?=
 =?us-ascii?Q?Nk3Vh4Ad/pUMinUy4XNFTxMuBcs00JAgCUJgYqO2DIuaw2YDmWdqAUrkfyx6?=
 =?us-ascii?Q?kKlYyJ0G4ep9i8AeFKrqV6jRIV1KwgRF6LQJoW/OH1r+pYIzBDGQugtI1Y71?=
 =?us-ascii?Q?jzMj84sXOvlGLguHeNC2IifMPc6ANjWg+WAvvQnjBcmWc2fT+M18tjIDR9Gl?=
 =?us-ascii?Q?xRf+ZPFsYxMjnJS4GqPnt4YEyKpy/h8bvC2Xzsb1D5TSlbKzWXVoi7+D3Y+v?=
 =?us-ascii?Q?jJFglIBsgJ5DT+ImMZG0tk7Pw5XW8gOt6B3eMrqIR7YHWY1riB73LaCGYdUo?=
 =?us-ascii?Q?dhuobEJTde1qmBNbwuE/kojgRFnttRdU6tbE/eJkKdvNOxAwJtYGE+ypNMSG?=
 =?us-ascii?Q?/kI0wgXIqgAeetwxD7mOsqUL53KUdTegYP5iSg8E3fJN+jxOFYCcBk53vo1X?=
 =?us-ascii?Q?4dqFENnQxP27XODd5etsoUqCae94BLAmtl6sqFcJF849fyoIeBPdN+P+hpKy?=
 =?us-ascii?Q?TmW9SMFQTPoEpdihx8Fk+NtDP0fIUw8KhfUSOrR3kDqr1Mn+RW4zjiPcOCvt?=
 =?us-ascii?Q?s8V6vSE3Hsra8FpxfU57GOb2zAw3mdhxQyFazcQmhcdibIQ4cM6bsNGeKcNi?=
 =?us-ascii?Q?IwM9I5nAIxAThwCeGEZhsD5BmRq/MDPYJyLvztQ26DRZizqiwb0teA+WJfe9?=
 =?us-ascii?Q?MB/wOf8FvZwVSbYwMjvFEDAxLl0DpvezVreZnne60dFV0Px2ViU1mmkxGks1?=
 =?us-ascii?Q?Bp0Oiup8pZ0bC4WAMNywsZ/Gxh1P0uZww5DZDZQOYZgfHztFw4UKsJ+AinX6?=
 =?us-ascii?Q?AH3TKnWV2GEE8e7LxUkFMlqxGbfLExapiAMNJXlzc+ZQ9SlFHvdH2nJKj8vt?=
 =?us-ascii?Q?kU06RkVIt63hAqOM8GpXL5Tlev1artJUmiGrgYMM1g+D3BEuCKWB6TqfoziP?=
 =?us-ascii?Q?eP70RW/OCfT/cD9LV2vDM9hLMK7dMP1jRdLVLUwkpNrLejxbbrvhbBqWbUI8?=
 =?us-ascii?Q?mwtN1g4Oiky7AXAkbKxFeAx/axBEbR9UWSeefDzA9U2kHKp50CZeVaDCPHBm?=
 =?us-ascii?Q?Pr2ini2i3cAV2xnAYhNVQN5XLk8FVrtOhE5xWuwUzUssDmwmJy7eeGAHScx6?=
 =?us-ascii?Q?tSEA+3y5iK9j2KCXNvuwfxq3+yIDhgTJvGwCDI1zrD1DjLhC0jZkT0rg03lE?=
 =?us-ascii?Q?dSrYqEXA4g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da66b8bc-7897-4f0b-cb5f-08de4e75b6eb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 05:21:02.2044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8fqYuKuD944P9gOqYdpwH7r+zbLdw/0+8EOwm++XbhV7GG8tXleWIxbFu6OidPXeWl/9GliLLJ4ZNW0B9TXWxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5992
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7EAAB140007
X-Stat-Signature: oz6qynoyhss9epra4w7opncuc5meothe
X-Rspam-User: 
X-HE-Tag: 1767849670-243324
X-HE-Meta: U2FsdGVkX19ZS5+jt+qrorDtw8C2W6DY19ylEmOiy/MFTfbhQNqVOHAmQlyl67Y5gs6SueI0RvlipXisPqmSzmLTTsawQwpjJIe9KQRbvyYZLYnRX4Wf1/SV5JKr2KhFD7gkg9MbooBx5BRJUYrw0j1ArYwvnuDr7TsAAD9wr+M6wUrPFo5/MPpUxuvPHdtqn92IWxpdY5jx+RLBghHtRZ6mWvCuiEIJkVKj8EaAr/e57nPIMvywwjDx2pPQLWwmaXxhxe1LqQvjv1bHlELZpRDxOo3CBR1lvh69kUG6d/1xx7SCvLPRTBg6jO/QwevmQHZPxDE1/bwPY9m1CSYr9F0Zy6TWO4SQSEKErCT9GIo3p5FeMdKUGr8zTaseef9GtPgS4ltBjdHAJWSXFrBC8E4FRlmpl8Kttvb1rmn7Q2MkUVaTOc1BebN8Gcl1Elvwp7JzPARlAQNhA3z7FKNqUDprl74CT0s2MZ6TNrptqScYaxhFcngIcex6sP9NqwblhWd0GS2jtKwZSeKnzWP4j/HOjF7k2kF4MOI9N256h0wjEWx0w5xjJlNtwFnWi2+TR7dPDFejdisJbr8FLbDxBiLydToVmuis/+EBpDWNQ2W7sd//f1I0d3wgLdU2xYBkp3hWhPqlUb8WhdzVbVbyTblx85IQugFKa32oBWY60e/rSzVZPBrjw/pHD5/5pktZhXasoNbYfnWtbvfuOTDrrzSGm119v9JMR83QSv8qOwEbMrfcq1B5f9q88gNDiO31W+7A3+D5mjCLfy3+VVeNyeE7Ln/U6nD1UI0a9OxbolZyuEpQxyEHB6NYlovqsWHhPV980Sitx7iaKFCrikKafIQkvrqIZjP1MnQ3ExtdS4BiWhCNDx10Heu8L8MTdkK/AJJ6C1MsDPj6Jb/cPJi3CtUbwdlKQBERb9c/G/jWmvSyAZiW4Mg2umuRobulqLarQyPK0X3FF1W8y6YlVLO
 vQD2UMoP
 /uYv8DgL64wXKHz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-20 at 15:04 +1100, Hou Tao <houtao@huaweicloud.com> wrote...
> From: Hou Tao <houtao1@huawei.com>
> 
> P2PDMA memory has already supported compound page and the helpers which
> support inserting compound page into vma is also ready, therefore, add
> support for compound page in p2pmem_alloc_mmap() as well. It will reduce
> the overhead of mmap() and get_user_pages() a lot when compound page is
> enabled for p2pdma memory.
> 
> The use of vm_private_data to save the alignment of p2pdma memory needs
> explanation. The normal way to get the alignment is through pci_dev. It
> can be achieved by either invoking kernfs_of() and sysfs_file_kobj() or
> defining a new struct kernfs_vm_ops to pass the kobject to the
> may_split() and ->pagesize() callbacks. The former approach depends too
> much on kernfs implementation details, and the latter would lead to
> excessive churn. Therefore, choose the simpler way of saving alignment
> in vm_private_data instead.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  drivers/pci/p2pdma.c | 48 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index e97f5da73458..4a133219ac43 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -128,6 +128,25 @@ static unsigned long p2pmem_get_unmapped_area(struct file *filp, struct kobject
>  	return mm_get_unmapped_area(filp, uaddr, len, pgoff, flags);
>  }
>  
> +static int p2pmem_may_split(struct vm_area_struct *vma, unsigned long addr)
> +{
> +	size_t align = (uintptr_t)vma->vm_private_data;
> +
> +	if (!IS_ALIGNED(addr, align))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static unsigned long p2pmem_pagesize(struct vm_area_struct *vma)
> +{
> +	return (uintptr_t)vma->vm_private_data;
> +}
> +
> +static const struct vm_operations_struct p2pmem_vm_ops = {
> +	.may_split = p2pmem_may_split,
> +	.pagesize = p2pmem_pagesize,
> +};
> +
>  static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		const struct bin_attribute *attr, struct vm_area_struct *vma)
>  {
> @@ -136,6 +155,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  	struct pci_p2pdma *p2pdma;
>  	struct percpu_ref *ref;
>  	unsigned long vaddr;
> +	size_t align;
>  	void *kaddr;
>  	int ret;
>  
> @@ -161,6 +181,16 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		goto out;
>  	}
>  
> +	align = p2pdma->align;
> +	if (vma->vm_start & (align - 1) || vma->vm_end & (align - 1)) {
> +		pci_info_ratelimited(pdev,
> +				     "%s: unaligned vma (%#lx~%#lx, %#lx)\n",
> +				     current->comm, vma->vm_start, vma->vm_end,
> +				     align);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	kaddr = (void *)gen_pool_alloc_owner(p2pdma->pool, len, (void **)&ref);
>  	if (!kaddr) {
>  		ret = -ENOMEM;
> @@ -178,7 +208,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  	}
>  	rcu_read_unlock();
>  
> -	for (vaddr = vma->vm_start; vaddr < vma->vm_end; vaddr += PAGE_SIZE) {
> +	for (vaddr = vma->vm_start; vaddr < vma->vm_end; vaddr += align) {
>  		struct page *page = virt_to_page(kaddr);
>  
>  		/*
> @@ -188,7 +218,12 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		 */
>  		VM_WARN_ON_ONCE_PAGE(page_ref_count(page), page);
>  		set_page_count(page, 1);
> -		ret = vm_insert_page(vma, vaddr, page);
> +		if (align == PUD_SIZE)
> +			ret = vm_insert_folio_pud(vma, vaddr, page_folio(page));
> +		else if (align == PMD_SIZE)
> +			ret = vm_insert_folio_pmd(vma, vaddr, page_folio(page));

This doesn't look quite right to me - where do you initialise the folio
metadata? I'd expect a call to prep_compound_page() or some equivalent somewhere
- for example calling something like zone_device_page_init() to set the correct
folio order, etc.

 - Alistair

> +		else
> +			ret = vm_insert_page(vma, vaddr, page);
>  		if (ret) {
>  			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
>  			percpu_ref_put(ref);
> @@ -196,10 +231,15 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		}
>  		percpu_ref_get(ref);
>  		put_page(page);
> -		kaddr += PAGE_SIZE;
> -		len -= PAGE_SIZE;
> +		kaddr += align;
> +		len -= align;
>  	}
>  
> +	/* Disable unaligned splitting due to vma merge */
> +	vm_flags_set(vma, VM_DONTEXPAND);
> +	vma->vm_ops = &p2pmem_vm_ops;
> +	vma->vm_private_data = (void *)(uintptr_t)align;
> +
>  	percpu_ref_put(ref);
>  
>  	return 0;
> -- 
> 2.29.2
> 

