Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD6BC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699A86B009E; Mon,  6 Jul 2026 22:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A286B009F; Mon,  6 Jul 2026 22:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512136B00A0; Mon,  6 Jul 2026 22:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13E896B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:12:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D5671C7577
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:12:16 +0000 (UTC)
X-FDA: 84960355872.20.D17C49E
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id B1B154000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:12:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pqbWFbOj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.2 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783390333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAep4Z7YZHWpN+0mlNJbDGkhzQbeuCt/R48sLWPFmrc=;
	b=53/1vDfNHag99IJd1bpjfOBon84Ntb2sDsXJpIXNWwmw5A2BB8fugaHqZtyF9bhWIxK+Gf
	5NIh/zVVxR0nEQ5uhLO5lQpV+Rus1UTG59PP32NnEsPqOvXkePfK2J5IORgBogmMlV0eJw
	Dq11mycpQZzBpNDzFeaSjAUS/RpmOSY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pqbWFbOj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.2 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783390333;
	b=nd8UblGrphd84lwvk4OfKGRDrNZqAn+AgVQESx9h76N85MEsd/oKYFtDQIRZ4i8GhyLqZ1
	QKmJtQL+tBBaNprKRSLgfuOU7X0MuEMOvu7NuFNkP7hKMLynGjo6QF9Dt0hpxPtsFkOit4
	iOX2bilFX1X9v6cI+cZmUiaFnGY2sbY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rI81+BhvSOllLdmzUul+PrWx4xOwng4w6m3Hi7rNaWdgVtf29qaoryPLRaeK4HHxeWJJCCFDYtNQgyboBPSY1Kzv1G79dZuDNnpsZ5n2+3FLRrvnNlJJnn3Wvz5rg5zjXffbIthKSd38U6TmN/FLlhaI8QYHJ8Nkdvz7aM240+jhQ4qCcASCX3BvjyiSR/MVBwmMZuiIJj7LG+xHaQDKfD7xUp62aWdWoZm7e2pDrdTsgBPFByDdCItV68Tzd4rPPswPIzh/8OmkjYkEDYdIX4drTkxQC1b8Yyfce480Qv74gY2SaX3wOJ8TAp76INlWrt/vI5KAqyzYiR3/WhPSew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAep4Z7YZHWpN+0mlNJbDGkhzQbeuCt/R48sLWPFmrc=;
 b=IV9cV+t2hrYhLq3UFInbaq+H/FJCO7/Ybl41g8u+9/CF8qjWSsLiL/1hsN1QuZw0Ou+YyIjBUGD+LBe4ZIMmoMklhs20hf/4JmpmAH3owO++Nh7ODZW7m6afpl/PiYh8Hn7F6Al5w2PjKyHabz6wOZc2NercPxUOePvv797/Z/b7nhDSlEzJuI19dxWoKoIQIGMKkbPYQmyjGfxweWjWwnHtSoY/usyWr7gILKRxsq+e/qVFcuUxx3ao3kOrZlPxjldI7AOI+20VHRx6eRhkGQ/lmPuWmaZyM4DdL/iRxk8DNPP8n8ctheuAdhxa8D65rBVB+1GLQPGX0VjT2eAxrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAep4Z7YZHWpN+0mlNJbDGkhzQbeuCt/R48sLWPFmrc=;
 b=pqbWFbOjAgxqavsHcPQLl04BefxSn2OPmoWGJn7+bY6DnQLvK+RD52kgDEO0Q5LndONPHI95rPzgU0Yb3Q9zBYstaRYbRm+Om4aNDFG+xjbWkIsWIcE0M5Sogm6yQnfxmYWuPB9RD+8DFhF2wSwfc6T9gn1bEaK92Ut4Si9Q4Z0Vpx6a/+tmIog+JeQE/tHBX7588MGj77RN81PJK1qY0X8ImItthPaU0YoDj7BXWhapFUe2uwiiZifIWkob5UpQ4/RtjMcjs0upsVZUngAPl3gf4exwAvDgCHgVHS+a5aPS43FirUNXPgvYccXw/c9M8cAoeSlWeJboXmwzzo756w==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH7PR12MB6444.namprd12.prod.outlook.com (2603:10b6:510:1f8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Tue, 7 Jul 2026 02:12:09 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 02:12:08 +0000
Date: Tue, 7 Jul 2026 12:12:02 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org, linux-arch@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mingo@redhat.com, rppt@kernel.org, tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH v4 0/8] mm: speed up ZONE_DEVICE memmap initialization
Message-ID: <akxc3nMedKYo7Xdv@nvdebian.thelocal>
References: <aiEoByaQdRR3xtM5@nvdebian.thelocal>
 <20260605095243.45803-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605095243.45803-1-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY5PR01CA0006.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::10) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH7PR12MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d265dd-1fa0-46fa-1e80-08dedbcd25a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|22082099003|18002099003|6133799003|3023799007|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Yx82ipFP5NGopnzvCRxU7N6F4mbSg37a3XANOKxg+hdRCiAR91PxyULcNAQOr7WflpbBgRxUFoRMZNScn5D8Jp4BpSgdRhaRSSl3LXyun/jFPy6eJMQKdBay/Cb7xyeJ9HsrRAmBNQ1lRU0Q0K6Y0t8Y5UWy6Z68HOc2yY1Q1ay/3ftk+i3g21QI/5JLLMFQtvHL5SatFgkSDtCNZACdO8uce9xnuiThhm6y2E7mZbLGhDuP+gCwN8sx76sI1yrLOHD6nk14PIapoPJHHB1CP+EYYtjSlPLVvd+eqky7zViJqTIsDHqTfnsaVRoLffY6p9kPgZ8xn77ScR9syfNcMpQPUTM796QThalUhc7JRY+uqbK9ch582wsXcSvrrnMdy5FYy75c4R7SEhukq5b9vVgjXf3GC0fXAG9FESnscjiH9C627R/Td7gBndvm0AbtaUSJb3BP2QeCG0YI2SnV9a2YZS2xrQGwQVJ8ENJ19C8IANkbtwKqHMk8mo5DUqxteTYwujwIryVmJVe53Vt7XfVEtoJszdG17r0KYOfAPo+/tx1GFzO8X3c2QcrpkVWyoBCL64oCs8ChT6+xQ8GPnM11ZEGWYqJna10Nczi4wE0/KcqLHY7X6hCa99ClgchSXUNZSTeJCiqhZdJLZR/lorQlNQ6lbkYQKUHFBg8UShM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(6133799003)(3023799007)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ncHhGG9nduJ+pph605CivG/Lq5DZO3jdmh5QoLMae00hXOGd5IxNLdqlB2Zk?=
 =?us-ascii?Q?g6PRe5gvttUwwSj6qZndO1jY3RLkVTl6Vt7WKHkdXCm731JHoI02HbseADWn?=
 =?us-ascii?Q?eWMudd+AwypduFtP//wEyItLHyJ4/39YvcF3VItzx7xTbrbuyZp9uV/jhV27?=
 =?us-ascii?Q?6V9gtCjRLW1eRDL9RO7D7tY5dVOQ2sz2LNVn1z6g32ewFUuZLgYsW5NgbWW9?=
 =?us-ascii?Q?Rq2vj4L4L2W4hwYsNZQkc/AQPtigWumzVDo0wKNXDW2+5lYhEngHRjNt/kCQ?=
 =?us-ascii?Q?bF/lPeIdhh3yMYuKRTU7pj34+io+hHMe0SA8cxtNf6abQyJ3TBRrccF/6qGo?=
 =?us-ascii?Q?ka0A3/7B9PyV7UfF6sv74kl3/CTBkrHHybhv6KMCUAkX9SNajCRj5P1uEDAL?=
 =?us-ascii?Q?6RB2oA0RHpZs2zQYdNYzKEckLMKgb/lsl76ue99DH3XDb32AEute3eZqwVvV?=
 =?us-ascii?Q?0qYhB4kejltUAC30c8dTCAifl9AUEx027F7IiBLUn6L5cF9IS2s7NdlMlJ/x?=
 =?us-ascii?Q?mRzFIYLrkq5LnTDXt2jgvsHylVrjVTCt8rc42fT5afRMVfEyO/DA7HBPIy80?=
 =?us-ascii?Q?eaPRN4yzMfuDhmYFKmqeVAyO2Y38L23CcLlRNO25dTwG4F1wElCTWQa1po0Y?=
 =?us-ascii?Q?0k9tqLoO35I95Qzc3Y/i3EXJW2pFLIgv37D4aphMhuUVUuTdye/WPlKqbwAD?=
 =?us-ascii?Q?su1wEBQ/sIYPlIC+yIgEW5rF0iX0D7t8UgcozuJjC/xKzfRmFuLtF4d8BHJ+?=
 =?us-ascii?Q?7jpJftfM3I7vFUNrTmhk4KdGvo8jvHFjl68FHGBeG+w00HHSnQu2UVQVk+tm?=
 =?us-ascii?Q?d6MCz+Fy3c3i23nRsGOq1eUclRFKhgXTAdcKiYqTEFB6ioK53S8zoiSXvpoF?=
 =?us-ascii?Q?DcpzEOThztUrfLHXf1qc8tB/XDIgc2yDTizbiYphXmOM3R5MwFA9bauhN6xz?=
 =?us-ascii?Q?r0NAPtY/UYQFoXur2yJZjO+4avD3N3jcwoVjkH3auy5Wqv+GjnVMDCTw1Ihf?=
 =?us-ascii?Q?aLZNNw1bHwPhProokMrAvfpLxSlYJIBAAp7cTxo6oKUwDzzdgEK1+MxwRjY8?=
 =?us-ascii?Q?27xqzAHFgxkSH/BxdIobiBogIm8ncLzRpAvmUrAE93bvjc3aq1JI9iJwj08j?=
 =?us-ascii?Q?ekAFvNdV4gBKsHjLIprWBfAe9Ftb0cscy7gZaC7IbOC2hscg+Vd7xm6joQeL?=
 =?us-ascii?Q?Iuyr8m0lMNVQlYFKdNovepHU9Z+fw5+xPo8ZkNVsdGbku7OOtMQIlMGldwew?=
 =?us-ascii?Q?rKN/HZ1p5RIqWBbjtNyw7iTaMQX4zqtukg+zYKR2XtAIXWWQceM9qoDdCS+V?=
 =?us-ascii?Q?Bf26o3cfGXKrvEKW6DTS53gM8MxaAWADATZQA9nYD9aW8absuiAveYq0lvfk?=
 =?us-ascii?Q?HKYuk5rUSNAPIQ3DDddKvXMOs4/GRKXI3/vvFCtyEUJUxh6hPeE5VFfIhfFa?=
 =?us-ascii?Q?90Qn8Zvct/z1Hrmd5u1a9PwLkE6QMjZjhmxCSLjbKfsGWkOMIoyWCyGXwcP8?=
 =?us-ascii?Q?HEwo53fXCzJVaHEG+qUpLaIAGju0Y4/BoPXxj6NHAq4HIZTZH/kecmo0owuS?=
 =?us-ascii?Q?iB2KxR3FNpWm2kS4mFRjOM83vXzDARxmLBXibb8mTcTdOFpFm1zzbgXBjkcL?=
 =?us-ascii?Q?S2CAC3g4Fn8l8BRdOVFoCLlxXeGbqk8CLXFN21BsulbVJ2Muk9QFHzcuzLiK?=
 =?us-ascii?Q?KDLEMJGrWOs2o2me6Kbo3WBPuJk1ZemlQpKEGKzNROVG2dj3L3azEFryZbaY?=
 =?us-ascii?Q?BbJhcB43hA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d265dd-1fa0-46fa-1e80-08dedbcd25a2
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 02:12:08.2706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V49MpHYISMq6jUat0DGQ/GgP5oYtzoMI4AkQgs0S4rp+DPbKnlgQbscXK7IzLhD8Y0kkeinxLkxreaenkoO+5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6444
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B1B154000A
X-Stat-Signature: 5jfspyp6uau39pin9h95medcd781zs15
X-HE-Tag: 1783390333-368672
X-HE-Meta: U2FsdGVkX19H24KSBqNNL1XN7px7hiXUZ3iKOfwMTUnmMWA5yY6L4E6t+V8fQxlADmXqIJCbgYqSzvvVYyN9cEtPQjdVNvqWfYE+PEZbkf2qKfstyyl5NF2baPBs7rTJOhk9Giu0dtNQvMC85xFavdtIm0P7kFFi8nMkHSbZMhBo0O2tDvThwVE8ZksnEhx7PruRrzPUCAhOqA68naG8BT5Q6gKDGrdDpxJVlkAGWdM4qqZDu5Rj/UX9QiFfZ9KFNzJ7wVpDh12XsCXw/fDbFBTVT/kQr5I650ISZ3q8rdA4d2aNlbvwFuJKD6xpv6FYFd9VqOe7c9ILiNcXSnra2M4C06AoExhf6z+ZQ0hTmCmgxOq+wL3xSDpZ+T1aBUcz3vaGkTUZLE5vZmVXiH6pNzNkkcZyK9Z1eXbDWmQklmNUAwMksCu9TLnHw7u38jnsLhaD99X/NVvlniz/i6VZ/H2QTEKklx/z9Ynbe1FrlX2gV96rWGjU4nhyShfKINzggHPd4yg65QVLQNBIdcsiNgHSQdpy7DOjrckx32Q5YOmScckvXvVm6c5OuMM7Trwef0N+hhDcjb/+0pez0diPZV64/WqaTLl0NmE+HMUA4AuxY9TtJYUIWgGrC4Cs8NEGPaSx3W5CH6zseizkzZr/87idd7AqX8O6QgId+rySF1ZWZlrCI7hSEChIjuvS0iXImtnXPgCRkVvrgj3sEsADkb3PSQfOWSDuKb4FfSzWY5nRuz65bcjr17eM8miNxAtNyRMAUmZlRr/U3NO7KKmbKlIA2glt78CsmZfQADIbCIgTuMRCiLfaI5zFfu+znahy9uFHty4znA4VPk0G/rsE36rHzpKf1vVQ8Kh6hfENFlSLro8k1DS2a83RIkLwcmL1J5DYyuW7TNwt7J3Xek1HzKjomX/YlNClNhngl6QJZNNp54eM3fBd4LZk2NBR4bEB20ypDnEIhq1uq4QoujH
 UNtz4KPT
 eTTn/HIMJb+XoFX7GT4xM7VhPY0rhA1kfWLLji3VL+2CjXxvbfJJl6l7DPebCb3iItM9YPqXq8pB6BLD9KvLKCKOsJTqGhqJsGAG/Hxxnj8SusPwzCFi34fmBuSmYmdMiX4mfrLv9nO/n9HuyEvTHiR3cGH2F3Aagd4ZgDCHryMk/31gNV+IOczhkl084F7c1l/QJ1EqJETPfQ21Blf/8/hNBUKxgKTXTAnprS4HGg+gfmSvlR27Bp+JgKNPG2VH2iuXu0opU6SMaPRe8IrBNN7SFDivo4HrsOhVWKemM195Kmta9SBPV98l7SgS1lpjCtIXtG1tV4SblHbRxZ/9udr2iBtD4/nvfmK9Vmbz8xKWL4TkMzvwIGqLQbMGKNhObl9CKbr3Jqco8HZ444WJiH8+iPYm3jSKpTgCMJ/h1q2iQGI78Ka0ZA4+oZQtVBjDZ3uBiNeOO7aqMy89/UDKZ1EmoHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-05 at 19:52 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> On Thu, 4 Jun 2026 18:14:05 +1000, apopple@nvidia.com wrote:
> 
> > On 2026-06-03 at 18:01 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> > > memmap_init_zone_device() can spend a substantial amount of time
> > > initializing large ZONE_DEVICE ranges because it repeats nearly
> > > identical struct page setup for every PFN.
> > >
> > > This series reduces that overhead in eight steps.
> > >
> > > The first patch fixes a stale comment in __init_zone_device_page() so
> > > the documented refcount policy matches the current ZONE_DEVICE code.
> > >
> > > The second patch factors the reusable pieces out of
> > > __init_zone_device_page() so later patches can share the same logic
> > > without changing the existing slow path.
> > >
> > > The third patch adds set_page_section_from_pfn(), so callers that want
> > > to refresh section bits from a PFN no longer need to open-code
> > > SECTION_IN_PAGE_FLAGS handling.
> > >
> > > The fourth patch adds a template-based fast path for ZONE_DEVICE head
> > > pages. Instead of rebuilding the same struct page state for every PFN,
> > > it prepares one reusable template through the existing slow path,
> > > refreshes the PFN-dependent fields in that template, and copies it to
> > > each destination page.
> > >
> > > The fifth patch extends the same template-based approach to compound
> > > tails, so pfns_per_compound > 1 can also benefit from the fast path.
> > >
> > > The sixth patch introduces memcpy_streaming() and
> > > memcpy_streaming_drain() as a generic interface for write-once copies.
> > > Architectures that do not provide a specialized backend, or cases that
> > > cannot safely use one, fall back to memcpy().
> > >
> > > The seventh patch extends x86 memcpy_flushcache() small fixed-size
> > > fastpaths so struct-page-sized streaming copies can stay on the inline
> > > path when alignment permits.
> > >
> > > The last patch switches the ZONE_DEVICE template-copy path over to
> > > memcpy_streaming(). It keeps pageblock-aligned PFNs on regular memcpy(),
> > > uses memcpy_streaming() for the remaining write-once copies, and drains
> > > streaming stores before later metadata updates that may depend on them.
> > >
> > > This is not intended as a steady-state data-path optimization. Its
> > > benefit is in pmem bring-up paths where memmap_init_zone_device()
> > > dominates device online / rebind latency, such as:
> > >   - fsdax or devdax namespace creation and reconfiguration
> > >   - nd_pmem / dax_pmem driver bind or rebind
> > >
> > > In those paths, the kernel initializes a large vmemmap range once and
> > > does not immediately benefit from keeping the copied struct page state
> > > hot in cache. Reducing write-allocate traffic in that one-time setup
> > > path can therefore reduce end-to-end device bring-up latency.
> > >
> > > The optimized path is disabled when the page_ref_set tracepoint is
> > > enabled, and sanitized builds remain on the slow path so their
> > > instrumented stores are preserved.
> > >
> > > Testing
> > > =======
> > >
> > > Tests were run in a VM on an Intel Ice Lake server.
> > >
> > > Two PMEM configurations were used:
> > >   - a 100 GB fsdax namespace configured with map=dev, which exercises
> > >     the nd_pmem rebind path (pfns_per_compound == 1)
> > >   - a 100 GB devdax namespace configured with align=2097152, which
> > >     exercises the dax_pmem rebind path (pfns_per_compound > 1)
> > >
> > > For each configuration, the corresponding driver was unbound and
> > > rebound 30 times. Memmap initialization latency was collected from the
> > > pr_debug() output of memmap_init_zone_device().
> > >
> > > The first bind is reported separately, and the average of subsequent
> > > rebinds is used as the steady-state result.
> > >
> > > Performance
> > > ===========
> > >
> > > nd_pmem rebind, 100 GB fsdax namespace, map=dev
> > >   Base(v7.1-rc6):
> > >     First binding: 1466 ms
> > >     Average of subsequent rebinds: 262.12 ms
> > >   Full series:
> > >     First binding: 1359 ms
> > >     Average of subsequent rebinds: 108.36 ms
> > >
> > > dax_pmem rebind, 100 GB devdax namespace, align=2097152
> > >   Base(v7.1-rc6):
> > >     First binding: 1430 ms
> > >     Average of subsequent rebinds: 229.12 ms
> > >   Full series:
> > >     First binding: 1273 ms
> > >     Average of subsequent rebinds: 100.17 ms
> > 
> > The results here are impressive, but I've been having trouble replicating them
> > with hmm_test on my local development machines. Both an older AMD machine and
> > a newer Arrow Lake based machine shows ~3% worse performance with this series
> > applied doing ZONE_DEVICE_PRIVATE.
> > 
> > This is based on measuring the memremap_pages() call when inserting test_hmm.ko
> > in a VM using the following hack to measure 10 64GB memremaps. Is there an easy
> > way for me to replicate your results in a VM? Or is there something in my
> > testing that I'm missing here?
> > 
> > ---
> > 
> > diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> > index 213504915737..a1d5463dbc86 100644
> > --- a/lib/test_hmm.c
> > +++ b/lib/test_hmm.c
> > @@ -34,7 +34,7 @@
> > 
> >  #define DMIRROR_NDEVICES		4
> >  #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
> > -#define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
> > +#define DEVMEM_CHUNK_SIZE		(64 * 1024 * 1024 * 1024UL)
> >  #define DEVMEM_CHUNKS_RESERVE		16
> > 
> >  /*
> > @@ -565,6 +565,8 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
> >  	unsigned long pfn_last;
> >  	void *ptr;
> >  	int ret = -ENOMEM;
> > +	int i;
> > +	u64 t0, total = 0;
> > 
> >  	devmem = kzalloc_obj(*devmem);
> >  	if (!devmem)
> > @@ -613,6 +615,22 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
> >  		mdevice->devmem_capacity = new_capacity;
> >  		mdevice->devmem_chunks = new_chunks;
> >  	}
> > +
> > +	for (i = 0; i < 10; i++) {
> > +		t0 = ktime_get_ns();
> > +		ptr = memremap_pages(&devmem->pagemap, numa_node_id());
> > +		total += ktime_get_ns() - t0;
> > +		if (IS_ERR_OR_NULL(ptr)) {
> > +			if (ptr)
> > +				ret = PTR_ERR(ptr);
> > +			else
> > +				ret = -EFAULT;
> > +			goto err_release;
> > +		}
> > +		memunmap_pages(&devmem->pagemap);
> > +	}
> > +	pr_info("avg memremap %llu ns\n", total / i);
> > +
> >  	ptr = memremap_pages(&devmem->pagemap, numa_node_id());
> >  	if (IS_ERR_OR_NULL(ptr)) {
> >  		if (ptr)
> > @@ -629,7 +647,7 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
> > 
> >  	mutex_unlock(&mdevice->devmem_lock);
> > 
> > -	pr_info("added new %u MB chunk (total %u chunks, %u MB) PFNs [0x%lx 0x%lx)\n",
> > +	pr_info("added new %lu MB chunk (total %u chunks, %lu MB) PFNs [0x%lx 0x%lx)\n",
> >  		DEVMEM_CHUNK_SIZE / (1024 * 1024),
> >  		mdevice->devmem_count,
> >  		mdevice->devmem_count * (DEVMEM_CHUNK_SIZE / (1024 * 1024)),
> 
> Thanks for the feedback and for sharing your test results.

Sorry for the delay, this got lost in my inbox.

> I reran the measurements on my side using two setups. I do not
> currently have access to physical PMEM hardware on my side, and the
> target use case for this work is a virtualized environment. So my
> measurements were taken in a guest using a 100G emulated pmem device
> backed by a regular file on the host filesystem.
> 
> First, I followed your modified test_hmm.c approach, i.e. looping
> over memremap_pages() / memunmap_pages() and measuring the average
> memremap time in the MEMORY_DEVICE_PRIVATE case, where the vmemmap
> backing comes from normal system RAM. On this setup, I got:
> 
> - base kernel: avg memremap 222.0 ms
> - patches 1-5 only: avg memremap 206.9 ms
> - full 8-patch series: avg memremap 264.1 ms
> 
> I also enabled the pr_debug() timing inside memmap_init_zone_device()
> for the same setup, and the numbers tracked that closely:
> 
> - base kernel: 221.0 ms
> - patches 1-5 only: 206.0 ms
> - full 8-patch series: 260.1 ms
> 
> So on this path, patches 1-5 seem to help, but the full 8-patch series
> does not.

Interesting. Thanks for replicating my testing, it's good to have confirmation.

> Second, I also tested a benchmark-only setup corresponding to the
> FS_DAX map=dev case, where the memmap itself is allocated from the dax
> altmap range rather than normal DRAM. On that setup, I got:
> 
> - base kernel: avg memremap 200.8 ms, pr_debug 196.4 ms
> - full 8-patch series: avg memremap 117.2 ms, pr_debug 113.5 ms
> 
> So on my side, the full series shows a clear gain in the
> FS_DAX + altmap case, but not in the MEMORY_DEVICE_PRIVATE / DRAM-backed
> vmemmap case.
> 
> If convenient, could you also try the same kind of measurement from my
> cover letter, or at least enable the pr_debug() in
> memmap_init_zone_device(), to check whether the delta is visible there
> on your setup as well?

Will do.

> Also, if you have time, could you please try your modified test_hmm.c
> setup with patches 1-5 only? On my side that configuration still shows
> a measurable improvement.

Unfortunately I'm unlikely to get time this week or next, but I will try.

> Given these results, I would also appreciate your advice on how best
> to evolve the series. My current understanding is that patches 1-5 are
> a more generic optimization, while patches 6-8 are only beneficial in
> some cases. Do you think patches 1-5 alone would already be a
> reasonable candidate for upstreaming?

I'm looking at v5 now, but they generally seemed like a nice clean-up overall
anyway so should be ok to upstream.

> For patches 6-8, I am not yet sure what the right direction is. Would
> it make more sense to expose some explicit opt-in mechanism so that
> the movnti-based path is selected only when desired, or does it make
> more sense to use that path unconditionally for FS_DAX map=dev case?

I think it's better to keep things simple and do it unconditionally - even if it
sometimes results in a small (~3%) degredation for the DEVICE_PRIVATE/COHERENT
cases I think that's an ok cost to pay as these are typically only initialised
once at driver load.

> I would also be interested in your view on why the FS_DAX + altmap
> case shows a large gain while the DRAM-backed vmemmap case shows a
> regression with the full series. I do not think I fully understand
> that difference yet.

I'm not familiar with the hardware used here but I wonder if it's simply that
the performance difference between movnti vs. mov is much greater for pmem
backed memory rather than DRAM? In other words this only shows real benefits for
altmap+pmem and doesn't make much difference for DRAM?

- Alistair

> Thanks,
> Zhe

