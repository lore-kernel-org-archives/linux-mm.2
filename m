Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F09EFB806
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 06:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CDC16B0088; Tue, 24 Feb 2026 01:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670FD6B0089; Tue, 24 Feb 2026 01:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529816B008A; Tue, 24 Feb 2026 01:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0066B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:35:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD7F958F8D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:35:11 +0000 (UTC)
X-FDA: 84478388022.06.9DA6FB3
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	by imf17.hostedemail.com (Postfix) with ESMTP id D097A40010
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:35:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pn1Abjyf;
	spf=pass (imf17.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.64 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771914908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsvboxnFR3FEThRy/qiw2YT21kkbYSZ0od0nFotkGDo=;
	b=mMnElLIkSB98ikX3ySH2E+fPB0BPTyYvUriQCCwPgXZjS3nTKe+v2Lg5vgTyB68gQIXUKQ
	RTDqy9Zk3yIUmcfwCW6NbNFzF1vERXQyDOQ6uTGdW2tlB7SU9stpFs3Ag7WC4lPwnc9C5i
	F1cvuAdaKYLEyH40ARbnFALp1jR0ctU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pn1Abjyf;
	spf=pass (imf17.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.64 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771914908; a=rsa-sha256;
	cv=pass;
	b=v2oQChmoH6lh0L1gBwOD/fcys2KZBK9jVqnZ5lzJKI4hPZvA6V+x544cpDMJnS51Q84axX
	vy2dRASdsDWjD9VY57Idd6ZI6HIWQF/yn0CHDmPR/Kyq/nPgXXFEmIU4u2Lgw7M8jx4P06
	a8zUgE/vhldQySkFWXZGgx6YKxJd3nM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwqKzUe11/Z58dPUBTlu34v5OSgx6CLJyHTo2F1Ic9ZJIXTKhec5c8yTs6c+y+s1YEfftmZMFqimLiaJUviBogVdIh3iFC5yUfa0SZ919HvBvFcJHpa+WRNYmkDtSSUIY3431U40rpXkXMcmA0NMCbQH1y2TbsQVbZXX74Aj9uYQbpOLtyfNOXecg5vYbiTgvj9dSMd9MqrXu/6tVFJHmTIr6IOZXpObkjGj1tBpLJwQmNzAJal8wUtcXTlaLdg6uHt3arxJomElYrJ1BQ1YJXUl12WTr9+Cd7bZyjYVEO+PpZoeIpsIvzhJTYIsr2oYyEh0QVArWtZX6H9YcmDqKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsvboxnFR3FEThRy/qiw2YT21kkbYSZ0od0nFotkGDo=;
 b=uMB4+wiLuGgm/HypAyOtB+/bef0hItgKXTG3EHgqb3dqLZgDEvaf+0uX7cbqNZeQ1naC7bZN4svSfiuyAt+XmrmOz7Kh4gXX+VVCwJr/zxeY6mqsbTzEYLIeSQz3x36ntC2OYchQrSJ6yvOWMlEbhupwOfwqHPZCLrZbtO/RFPuYSn+ooNi9M+fXnXi9yFkvSPFjOV71vhWAq8FyZwYOcXkv/ZWbKW2hvxThPOGfoYgPVmgBnKI9TOwNe/LJfqNE6/4ehCiEmN2kxV00KJb7cY0lMbu0x+rwcCYWdAtoLj7A13RekWUpwJRnt4p+4ry+mDPYUwxxBXNluCCbd8Ynrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsvboxnFR3FEThRy/qiw2YT21kkbYSZ0od0nFotkGDo=;
 b=pn1AbjyfMrUQ9nAbzPOLSHa4LULp2l9ei03uoo5GAod7NwObVq1dY7z/rkmYTebYfijOU29C7ntKMTsM95wq02jdFHSGuaTtU/UVgUzyAreK2Ca1/ou8jX5PosYdxaFcN9Q5KnuKJTS0JFhfgAbyCBudim86AytwjZu6Y6cEZeqycc76Pg4u/9plrBLYXlbtK9YTdnxrwWx4Ob5B3vsyc2d42hZ3C+iIDbUAcq4cT0Wsn1XBeFnmyshVWKOJ1IUsZxTaIeaZvXv3+rjUnO6fNdvXgC1KhoCN/NPqHTjiPdwxxhuzjyRF6+StLtnItML0F0GXzw1XbBkYMeMgCMobPQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 06:35:03 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 06:35:02 +0000
Date: Tue, 24 Feb 2026 17:34:58 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mm: rmap: add a ZONE_DEVICE folio warning in
 folio_referenced()
Message-ID: <p4ir7f5fut5ih6satedb6vrk6zwokujr2iecccfcbgthlkdsdk@hhgpbymchzvk>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <e91eaa86a6fbb0682b4e308082048c688a57c035.1771897150.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e91eaa86a6fbb0682b4e308082048c688a57c035.1771897150.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: SY5PR01CA0006.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::10) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 34880f58-2c48-40f0-6e89-08de736ed73e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OhVHqsw+5mPKsKxptz8aoAdwtvSMiRRfTJFOcnQ5gjCDc6qDNCcnTAC0uiKn?=
 =?us-ascii?Q?yIzeYw9w/b5TBDA/We9aujg99cBuX/5SbxvvIwDzANIV0OWVtmsPE/WtRVbh?=
 =?us-ascii?Q?RKTEFYCUpOBsx3dbB3JzTOomqgltokAuq3XOwf67qTaNjKGPYk7b01NBzmoH?=
 =?us-ascii?Q?kr+0Xgjv82FEIYf3axH8MzKBHhT3gvOc8ETHGcajTrx9CFRYByRoeZq70ePZ?=
 =?us-ascii?Q?bjmPwcblbSUzHYjQs1ZD+8GZ7etH0gV/wFXwxmDDgQEmHp01didskV4NIXRE?=
 =?us-ascii?Q?URQi8095q/6AKqNwy6QEblApo8KdS142PGVnjsJ3Ojo4ghBGVaXq74/i84ft?=
 =?us-ascii?Q?CmbcZBsq0G+DOBoyvre7r2/I13rLr58phgjMVGVSF0qibVn6OP4irUtY/IYU?=
 =?us-ascii?Q?vZ+2d8e7n4lVYYcz+WwWNBUTAs5zYZd5bOeuDGVzno/xRUYM6mLb4rC+B8O6?=
 =?us-ascii?Q?OsBeMccYAa5iVHVtMShBomboskCSPp5qdBqV3SGozo57mLaJCjlQgv8EDOv2?=
 =?us-ascii?Q?DlvS0rXDSNzSNOwEfQ+SiTv1tY3INLr9UfAZ+etOqcAl6rgWKz4IWz/kCx08?=
 =?us-ascii?Q?kz6k09MLVJAxzd4dUkZV+IJRoo7uUEU7o871VHcS2oUQFo+yHKVW+vdwVsec?=
 =?us-ascii?Q?18mDNufKtES1qkezlLeuwHGFEyDkwr2QGd+v5o3VR9oGbHzq0A5qIGI6dggt?=
 =?us-ascii?Q?l2gc24AJuCeZVtwYaYd3vSTQeXa2bhus6uKHPCCa7x1tIH0g1azOMGGv198u?=
 =?us-ascii?Q?XlXtYR3a83gfcpblRCkRCjDXHZoiZD1Dpemur3+in6EY5hrYmiFJjU35JnbP?=
 =?us-ascii?Q?Viu2u3rWGdFgJQV9h/iaS4UftCePNsbOED3/FzEpU+7/16JsDEFQzAvQoNQj?=
 =?us-ascii?Q?ieueItspal4dikLtfom9fRyr2lqaISY/REGhcDDRZfRdM1fXAlI2Ik5roTcB?=
 =?us-ascii?Q?XYYrDanIUzbJPk0ZWVXekk2z5eY16ifDmbYhPdYuGVZi+/5kBKh14yd+gNXe?=
 =?us-ascii?Q?A8zBg8mzL5Pv/f4Emxi2MW4RWgUxxwji3AXMBqs2zZQ3mSOwiWecFxOfz/jm?=
 =?us-ascii?Q?yXHLYfr78YcyrGq6k4qdv8Ji70il/grBGRTg5WmppJ8nEFF1s8bvR7XzDFKl?=
 =?us-ascii?Q?Z6sW+M2uWYkMCxIEnxg3+d6exHme411zpLDpLGc7/gcRGuGS52Qx4lZAcg2w?=
 =?us-ascii?Q?x1obBRClDblg48UlAE1eX3qhzsZ2wocT5gskBY/Tkp97srXvCDDOiXjl68M4?=
 =?us-ascii?Q?gizN5in8byyMbG2BfzTrL6XXDKFZEke23TAhyZQcdJYt+SujbYLLSxrFXQs9?=
 =?us-ascii?Q?9Fmvd2hxySq0IX8YKcs+SF7xq8DyyfIMJJGFIid6J09S2R5zSjswB5fbu9Tq?=
 =?us-ascii?Q?ulhv2gCmxfg7lZTYAiWayt13hFA/903M8qC+yMcQhpmsyNcUm09x3OVRU9b3?=
 =?us-ascii?Q?46VbI9ywzcv5NaZS6/1T08rdij5pCtQSu6hq6PMmMNAo3H2Lxl7D0RuqCciC?=
 =?us-ascii?Q?uAqLuZEdiNELpAsC9HyFf14Pmk3SBzeNvJpLcUgqQFE2GYm+ySyal06ug3Lq?=
 =?us-ascii?Q?HJmm1v9HWElFwxAjCPhQO+2j5dSZIRmeKjg5n3QWBN8Wz0AuHjMQrrEslS9Z?=
 =?us-ascii?Q?TLfT/3oq8Uqo28H/CV7Amko=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V6d1oiPKovPaK9nOongNnubKp2FGiT8ZMdLkhQCWbm4LxXW3L7qWi5itCOWg?=
 =?us-ascii?Q?xjdovo1NYfgNu18wcJ9DOazjie7N/kIA/WmqkcFmB+nX4EaYCQytMwXrtRPI?=
 =?us-ascii?Q?IC0IP/n2OxJR9a3BgTfUkLVCyeZk5fegOtKDvkAjhLh3DRCRsnf7KyqFUk/x?=
 =?us-ascii?Q?MnpDDf0E8X8gi2VGYefd/JrXCuhtAbwofOvGVX7UaHD+vmQLoU+i0Vzty/E7?=
 =?us-ascii?Q?kT1nbB6gMuful/SwMqVf2PGFvKEdJ7TLOz9T2mRwrnUP5/0jZps+SWlgqqa6?=
 =?us-ascii?Q?qqJ6GPn4iuvPT+cJcn4Jx1uxWzf1tg3RrsoKiz3yugmoQr9UZsEptvtS8PaO?=
 =?us-ascii?Q?l7fHB3mL8sMSEQU5JSg7cjlMS2Fjw5IedGgaPU7pZ3X4cNq3+SMMQN5FFUcN?=
 =?us-ascii?Q?WpZHPm5IrVIONNdK+8qYVuFya8r4OsF308gxgV3+e1dNeZQ30QKQndUvIUMh?=
 =?us-ascii?Q?08Mbronbkuz7qQZKHxAnUz0vHsmsbuVw+b83TU16J2bxPb/1NPoRsK6+8nCD?=
 =?us-ascii?Q?yj2EGOz6sP07OgktRp1rqjSUkXKZsDh6qXHtK28pcBm2O1MuxpQZ0Hnoag0C?=
 =?us-ascii?Q?8MKGZRyMg9n3lru4JzZdsHiVLzph8Qj/GJdRrrp3US2PVNagCE23qCFcaBB3?=
 =?us-ascii?Q?GtUaARZXHQqusR7otTQIL4ZDTIqE9oECxK4Z6etPAywRGD0u6XJrvFuzHGjM?=
 =?us-ascii?Q?qkOU54suNPOQ3GTxqouHJew4Hrk/9LNmt4aIN0CeijJYhGbTHDYvEj2MZN6x?=
 =?us-ascii?Q?eoN7zntTYeSC7HjgO268fgCWOtV5EBGdKwIHa7gR4gI6JIYVkChAvpXJOsxX?=
 =?us-ascii?Q?A2CoB+CHQey4TmghnyvKufYnbW82Y+f8KZVWqJRf90j90rT4UYHJgHptA97u?=
 =?us-ascii?Q?ypxMmmmqwmHM+aamRUKpiNL1pfLEfF6JMo/Br6GLV1OvS8DDK50Of7d/wdFS?=
 =?us-ascii?Q?Vd2KX30dlpgUs9+uGSzkYgxsQseIGQ+yg1mJ/0j+KUn4rHbOjcro30QE0Pzg?=
 =?us-ascii?Q?W/St9mh8+m6SCFNNguII/tNe9X802fGKCSxaEeSVn0vhfsFeGVyUIeTyxv9p?=
 =?us-ascii?Q?CGiYyPSDZbxyHadwTet+sqQAYsCK8XZLSqaFya+dyqu0Kp9aJNwVVh5m0TKu?=
 =?us-ascii?Q?jufBAJdYRg3Bv8JM8/+SL0dp9jLt2OqbLk+2PN5lxt8VxZLJdtMCzowXHbQ/?=
 =?us-ascii?Q?OlX4iTQpm2Qn3DCGeZUvbjkLtAI3WZxQ8Mg/2nCT8EqzKbgfIDOGPtYZfugj?=
 =?us-ascii?Q?Im96gVW70mNO1i1FkEgztzJw5dj9d5bLE6t7Gn0OaEUuomlAXVCrmWxLGWPM?=
 =?us-ascii?Q?ZDY9fEElfdUZaC8rw9UeYQxw3ONvIZ63dpH5zLem/Msbe61zYr/EsnatjBM8?=
 =?us-ascii?Q?dElaDoTJGisLIgHIlyMm4X/FQ1t5eIgAWxo28InIR/gn5nZS7/XenqWvI4pT?=
 =?us-ascii?Q?goTfMYa9+xot1pkOXiPl6jah9q5WqaRHzNIwj44uOqikf2fQYPu+uQgDPVO7?=
 =?us-ascii?Q?Y3byX274eC/QosaGJpDfAXrQIzJp+qo3frE065cIV5TOWREmHpCTjeyd2c+Q?=
 =?us-ascii?Q?slDlpO9rL2nzLKrhpJsMvqMeJR5B4iprt++gxqoHyTZ50yYuuLuLc4B/RKzv?=
 =?us-ascii?Q?VX5fU5lsOPPpfYt2q4OP30we7rOQzzo6ndtSpULfjGCSPRv1arZVRN7AT2fC?=
 =?us-ascii?Q?5wYVmsssba7YAQydqw6CZqErkdO2DW3HEZg0koRpOZatRpkyIxGNXX6YGKoQ?=
 =?us-ascii?Q?JOkfmCR2rQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34880f58-2c48-40f0-6e89-08de736ed73e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 06:35:02.9400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omZN2w4uZ75p74XqlW160TMRx51ojigBhEGDhd+5H/gBgD6gXWLm9G1o1Mn/9UNj6w0yaGsr61UFzwwb3q5KBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D097A40010
X-Stat-Signature: 7d7ugwh9n53zhyqpk1obn6n1z536ycxt
X-HE-Tag: 1771914908-338041
X-HE-Meta: U2FsdGVkX18oRoOgrRzec44Of8UjyY19h4Jz8JUe4zSn4mi0KiYsGzsTTsfKgR/bkKWCXuRPMkub7ih+/SU+w21LhGxe/Ads0mDc2g08I4c0rB5zDE6GnYjbQzIFtL4F7HcGOdlHRhNVl5RmJiIDV3V0IIucGTKQ69qD4B/iDkc/AbUEcTypJ7yE4PFVj3m9F6aFWNQJfS6BudWanZFsT0IOMvfkul1tOiyEAs7LhKSvJURj/wIUB95FaS6scCFJ0LfyWWMH2LX3IwxDu0es8rndjb/x2YoWDztDC8OX0lhAmDwsRppOPrc9Zdz+miBKjghZeHKr2RJ4bpI9IQgrRacLtzGDRqUyfIkrjOk3YQ/nsTwtmid5+5AY+41a/Zw7lodXguOwjKOVxWpxDEEVLAebfvMYsPzDKK5nXQhm+LausytANgpziJnehF6O2DlKYWsPGIYEe5oFX8OesxN8GrK5rHftxoDxD+2uCoRaniEDFi2xFkv3FHgqT3QkGU8cHSxjcVNLlWGxVNbIuNBZvjv1xLvnFKy++StiEJk5YetY4gj9qD7B+SteZFXk+IZh7acLDCCeT0TgFTibP6WIDTc1fb2ApSit7Ol/kF4pyggy2wv8wQ97wa8/DdSRUSadMa5B2bdhsRZ1yn3EQBJdD999IVngUCFKvpIsnUybEbWFin5eZWeKt2Q4QvnUTQ5hflrqqG08ILisdW4VmnwJFekClW36x5iMwdxBgCTkrEP1TtLehtaSPl9d3vOI3zbgJgIEqw+cN89WV9YQ7mRUeh8F0URE5s+/+j2kBNxCVp1ftD3Mzklk0h/HT4AP7yQXqoMRIs6Jh/iqMoeGCLVFbGsAARcaNugefC2Of+lX0lOMucUB5oOyVrSRZKeyZTE1jU/TukpSA5QeSzrgQNZsi7S8k3rb5LRy+G7eZM1y/ndscTyO7uGvbjuPsvX+jwxJTqzL9c7ZsAy6JvFDg/3
 a4hcvwzH
 s8KJeBWgHtVOVY3lqwjKgzlSuzpKxf+ykHlPd61QxtyXwvW0dVTXCkNdscc5qa7KvZ19i1pClKrDvlfVHV47sf/J4D3Gt51o1LmrPFT7bHyHwZCT/oQrZPgJ8DiB+FgmT/cD2JZBj/TmsrcOwtRezquQULISmnul2WnVOvywlnLlmNSf+APZ+FipCXnf6xceuRjz2YG+wgK9flCHtSecbOtqosb+oS5QEg4WV6Zm88k2b2juyIQN73l5ex6UwvanvobIyy7oiRkbyoW/2LaTa0nqEpwvpUdus3SLw81FvkKXD0sa0A9ZVW4bfEEb+N/ZxeGgmCEtLEpq8V6Ut3k1HyJeyNzsltCDxHd9DoMgvx2ZmvaOGI6kTDgpmuP7k3g4M50zOVI+H/Sf9RhRUq0E/bKL6sg1gLqasn3de3NdFXz8RKHWfDfCFItfH9swrAJ4VGDxslREv2QqRxjPK1RWaHQBXdlTBVMjfm8yfUnqdNVH41Z0uB9d5OpVDSWPThn/uyDZ/qaA5EBmhvNs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-24 at 12:56 +1100, Baolin Wang <baolin.wang@linux.alibaba.com> wrote...
> The folio_referenced() is used to test whether a folio was referenced during
> reclaim. Moreover, ZONE_DEVICE folios are controlled by their device driver,
> have a lifetime tied to that driver, and are never placed on the LRU list.
> That means we should never try to reclaim ZONE_DEVICE folios, so add a warning
> to catch this unexpected behavior in folio_referenced() to avoid confusion,
> as discussed in the previous thread[1].

Agree with this so one you've handled Rik's comment feel free to add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> [1] https://lore.kernel.org/all/16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/rmap.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bff8f222004e..be785dfc9336 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1065,6 +1065,7 @@ int folio_referenced(struct folio *folio, int is_locked,
>  		.invalid_vma = invalid_folio_referenced_vma,
>  	};
>  
> +	VM_WARN_ON_FOLIO(folio_is_zone_device(folio), folio);
>  	*vm_flags = 0;
>  	if (!pra.mapcount)
>  		return 0;
> -- 
> 2.47.3
> 
> 

