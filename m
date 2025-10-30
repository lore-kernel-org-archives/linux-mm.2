Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBCE6CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67E68E01C6; Thu, 30 Oct 2025 08:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F8D8E007D; Thu, 30 Oct 2025 08:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2DA88E01C6; Thu, 30 Oct 2025 08:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF0068E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:42:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A83614010D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:42:06 +0000 (UTC)
X-FDA: 84054743052.30.9B21FCC
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013047.outbound.protection.outlook.com [52.101.72.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7FA5440011
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:42:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GCBBGcdD;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GCBBGcdD;
	spf=pass (imf27.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.72.47 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761828122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5MsNLOIBSY0LKAFECKbMwvUyPhWpgzsohsFsa036F4=;
	b=xQB3aJv1L3jvKzd/yKzhsSyJFeofBExrN97g1hJn3klpGbMNgEfzdjuHRTpUDU7J/b9WBD
	zK41147J/7hxczK1xMPacFYBJI035kmCwQRtHPxEuXw7MrL1UYOE3+9l2w7rSWeO+Rar8y
	Gh/5FdKep1nian2yen/+RlbATaJeA6M=
ARC-Authentication-Results: i=3;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GCBBGcdD;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GCBBGcdD;
	spf=pass (imf27.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.72.47 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1761828122; a=rsa-sha256;
	cv=pass;
	b=nFYjcObr1KP12tn9S6o9cmsCp+G71n9EMHfya87/zeT1g4iNlE9OFszRvm/huK+Ter/ReC
	pM658jjY+NF3XdISCEWhE2gUnoadROJpCxZoE/naLi7e6/X5Kd74c8US7GZxLg/yIYyJs7
	d5LJ+RxFRp/YdUplziDdn4fO2QCMk8s=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AEN/myAeYxjppsDwEBMcH4UVuZwicH7E8nfNzLc9sM03DnijT6B63hmnNRhRK1y7SvnVspCK0rt6RCr2JL7kl81g3/o9lmikiyEkkh5ofRsywLk9qXoSW/kJleFdnN4Cakv1Nd9Bp1srOi78GnzhUyl4vsFCug4ILc47tE8ZOZypUuE7R0bbpi/WLb4m+rozmU6w1imVtDNKqN1GG1OlRIbY8roIBHrw8OSYs9HkJC5jVDNdW9rZ72QbeZs3ZCQmZ0W8AK6t3A/Jc9gbXVefJJ6I9MpjCxBQVe1ZhAJgqRDO7soAnCf255Xdbh8t9ai5Cy6Ic8QrLvMTGSdM0WqOCQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5MsNLOIBSY0LKAFECKbMwvUyPhWpgzsohsFsa036F4=;
 b=axx7r/p/jPxm/xjclpABWs2azBAzzEEQDBUKJKP8uNc+J4uEWTp2ZtvpkhfGGnvwDmyoCmPZbK6//AqrMrbY5iNEyHGY1mjLhptz8lHTfq8VyKZ4arHFkdkc6ypGkI/aqZzlKUFRd/xwOL3fBfRJdnjI40/76ziNysskoi33X0kjh8eNxX3hqmVcVG0Zn/bQC5z+HHFu38MYhHjSPVSeF8HnJ3K0FJ6iGq1xZtzodz/5NYvsEOgB91fntmAA5oYMG86iru7G/v1rBVzAzuh1FZccZ00k+XXvE9WToRtaLWSyHbwlry24R/SbGsLRciUfsM+HalIbgV/lsXg0RbndQw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5MsNLOIBSY0LKAFECKbMwvUyPhWpgzsohsFsa036F4=;
 b=GCBBGcdDS4PAofzskd3CbITPbh/W/OV7dsi8jkaTugGZtl58Yy8CJWWOEoBCEeMHbKuitpqtOzNNHHq+QpBe0XEKxeyy9vbOPVetlZFqxd/UWXGVzZuGpBAtKRb1RZQOs7+Ix2Ap+I+PBHL/Am6L3ic60SVaWv1h3BwIKz3MoXA=
Received: from DUZPR01CA0281.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::9) by GVXPR08MB10613.eurprd08.prod.outlook.com
 (2603:10a6:150:14e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 12:41:52 +0000
Received: from DB3PEPF0000885F.eurprd02.prod.outlook.com
 (2603:10a6:10:4b9:cafe::95) by DUZPR01CA0281.outlook.office365.com
 (2603:10a6:10:4b9::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.14 via Frontend Transport; Thu,
 30 Oct 2025 12:42:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885F.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Thu, 30 Oct 2025 12:41:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eq/sTnkefisYzpniACRdmlOgDR4apmFkKdM0UAcaAaUiqOYVXxAWxMptHIMIZgQoYMLQ7ewewh3Z1XkQikwIr1TTPPnvS+qybSklq/pDAVcUZGmy30eq7l/thuuwgsLULRtbDzR6YVZ4ECGGmcK3PHcsiJIClD9XMAMG4yXTZAZWI4zpuXxgSZtvem8R27kavstLzBP95WT538doB2cBW7/KLdT2YNtEuaOiESGnEHClIe/C8nvOB/7cxSbGyfoqVeqhwqjE9dX+s4sknM4/btFDvtmNWGZhCFSKWLVUE+aOCBd3DQImQfZ1MUpqYQ/ZFKItscpbURNglfk1M661Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5MsNLOIBSY0LKAFECKbMwvUyPhWpgzsohsFsa036F4=;
 b=I1SV0bW0TroXWExyyzFG0Gs4o4rIoSYXVPWe6EPjuHTci7wuIC3DbjlH+7pc6GHmY/NzcIucejk5xrBco0Q+lCIEhxJQ2d48ZecxQG40GCcsu2EtD7+mHnIpEROV2qWqfOit3T2PKzW4Pm2ApEGU2YiLZMAcTL9WO1QmTHcYnHwxvlNmLyYbR0xpYu5B7A4FZXH64TuQSDJp+3yj6Mi9ZpB9s6luUyM7nivBoDtclSw8sba9kOFAZbI36CqcpSJcCL/jTU/GA7olQAF146CwbG8ySotlOx8sxdCbjxc2q0pG7fcv+zKe68lYE3cGwSv38QFV/tFLAhsULGP2mHAzIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5MsNLOIBSY0LKAFECKbMwvUyPhWpgzsohsFsa036F4=;
 b=GCBBGcdDS4PAofzskd3CbITPbh/W/OV7dsi8jkaTugGZtl58Yy8CJWWOEoBCEeMHbKuitpqtOzNNHHq+QpBe0XEKxeyy9vbOPVetlZFqxd/UWXGVzZuGpBAtKRb1RZQOs7+Ix2Ap+I+PBHL/Am6L3ic60SVaWv1h3BwIKz3MoXA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by VI0PR08MB11082.eurprd08.prod.outlook.com
 (2603:10a6:800:258::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Thu, 30 Oct
 2025 12:41:18 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 12:41:17 +0000
Date: Thu, 30 Oct 2025 12:41:14 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, andreyknvl@gmail.com, cl@linux.com,
	dvyukov@google.com, glider@google.com, hannes@cmpxchg.org,
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
	rientjes@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, surenb@google.com,
	vincenzo.frascino@arm.com, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3 7/7] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <aQNc6hCN56LfJGw1@e129823.arm.com>
References: <20251027122847.320924-1-harry.yoo@oracle.com>
 <20251027122847.320924-8-harry.yoo@oracle.com>
 <bf8f2ed4-0b3b-4ddc-9ce9-0d0b1a64c914@gmail.com>
 <aQK2l29EczfwYQNZ@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQK2l29EczfwYQNZ@hyeyoo>
X-ClientProxiedBy: LO4P123CA0104.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::19) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|VI0PR08MB11082:EE_|DB3PEPF0000885F:EE_|GVXPR08MB10613:EE_
X-MS-Office365-Filtering-Correlation-Id: 827a9a89-2e14-406f-7e2e-08de17b1b37f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?PZ2pQFgwtLQPOWlNiskaQtVn3NOFXTz27ZiEOB6wIneH951ajPu5e/HPrhyO?=
 =?us-ascii?Q?ECX69g9F4hGCOExExyTYnBM5IQvsqu/b55NeWc2muCYe6iWkoTLUs9jAIyyx?=
 =?us-ascii?Q?OL2EoMjzgGSDIHfTfelY5LWvW5hVyhUf0uk3kuWZ4oSuBlr5U6nMAPvYf0BU?=
 =?us-ascii?Q?bkQqHfQ8d57L58TMEN2mHJHK+y4YNLq+cma2m9s5lEHZoe4jIoBvovygtOjK?=
 =?us-ascii?Q?Q4NQepZ2zF6nuV94AGDbNgMxkuk0hlNXdR9oVVbuvVr8JDn95lmSkqXaj5wl?=
 =?us-ascii?Q?6ZavcKFW/til1q7Fdh6kcI2t/+MnS92ZhXy1tW6sav2wwn2nDaR5bcCCV8N5?=
 =?us-ascii?Q?iSuEo/Qy2a+C+Qzi1ljWy4zk6MZiCQQiLKfKH3O233iUgAN/0lCk3YHgFJ7g?=
 =?us-ascii?Q?ik8+JNtOJXv7u8v/j6Ytaz+LIc9kh31bi67wq02Kve+FLhQghOfacKfL33fg?=
 =?us-ascii?Q?jiQvdobhYzDw/kpHz4bci803o4B83NlvjflvyXOBRimKERQMHlbv4cTW6vfc?=
 =?us-ascii?Q?MjJDm5pipsySQ/cHf80A4/08ebKydBsxI0j0xG3jigYHnewxqK+Uhc9gaFbx?=
 =?us-ascii?Q?mtwUU8ZJtwJVR4bfgJ/6z1VaD24s9T3gdDkWJr4LoR3Qh4TOinbpleIUsHd6?=
 =?us-ascii?Q?XNNIja6JwsIEtBR6mu0+7GdKRn/6eScbYYpRvyeqMIS8/DjY/8WT0xE08VIk?=
 =?us-ascii?Q?0Qf6DHQKRpn+Womfgwyr+zdzEzyewXn3nWfpYAxVeSjv19fFUSCjQKHVq8ol?=
 =?us-ascii?Q?E9LdQgzjZHQC3/UP0Xm/+mCg3SPJzLpnLdOH1idJ9hufsJ+8VMp+mekCqQzg?=
 =?us-ascii?Q?F3iElv+dc0tuoWRVeat4bXovi0gfhzlCYYXwLG4qZn/BM2JUIdrj6xruWy5W?=
 =?us-ascii?Q?tfTpspbThqRV6YrEAb7VUUSczMiB0vAABc1UDDNjU4clVKMCE/k5u5oV+Yol?=
 =?us-ascii?Q?ldLWhj+sb6RwvdfDzL+ir0NjlW9G/EuwX/bx6P2Lwgvf5GNCJk86x0VwtaSf?=
 =?us-ascii?Q?n4RTnskARZO/eUTYQQ6NlkD11Sn/g+1eKvDM3JbzGarlmR17xTXR/8VoxAEN?=
 =?us-ascii?Q?1x/etIyy1lxlnvcoV4HHhnlo7DiKb6ZYYYEXc2Kvtq8oULdgvXQXNnsExQ6Y?=
 =?us-ascii?Q?x7XdTOXRr+3hGrqN25K2cYNb1BpJSWLZx5Fju7TL87fH9pbv3kXTBzg0raFv?=
 =?us-ascii?Q?l/byUfd7chlmdmtJlNhUBtFb2Rn6pWgsYfVmxA/2jKJdOxxkPy6WBBP640lw?=
 =?us-ascii?Q?y+okocjSr/+hnsxlMZImVLbIOyX50obACBCuMzH3Yt11C0jnwRwd2gZa9omx?=
 =?us-ascii?Q?HA9/7c+ByHBSoZjbH0JC+WAKTWBlFpPUFTzKrw2BVrXre7l3yP7gT04QWo0j?=
 =?us-ascii?Q?p5eafsLTy5b82KHGTlqDr1hZHhyGcX5YDPg/EqgEfPMnbUjulpAL2l5uTa62?=
 =?us-ascii?Q?0FMeIGii3o/sT7Jy7GXQuLGTTKUeW326?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11082
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a0ba105f-6590-4f98-8733-08de17b19ee9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|14060799003|1800799024|82310400026|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xo+K5aIeZUgIz1F9uhgDCFW4HljfQmvXMQ0+JqMyZ/7XIDCES58fvW+Ymy3c?=
 =?us-ascii?Q?NuW1UQECtSitsBWItL8y8tulu9CoQdG1Gk1zruwWPhP5Esjp+ZMLevff4vgE?=
 =?us-ascii?Q?CShZa2HhnFmBYR9Jpf49eFJ3scw/IeFB4oUq7UGRDtrFDeA2ZhF+d+XbUbcl?=
 =?us-ascii?Q?xCtqle5HLsRUyQEDyNnGecFdjgNqqREyatZutH4dNHI7Hu9Dj0KbC5oZTPXJ?=
 =?us-ascii?Q?XSiG3YIzmY3pvqxtWs1LNn5VpCiHHSJR0oMCRskz4M6HWW3IBzCGGq2ZATsh?=
 =?us-ascii?Q?BmdsKuCqv0X2ZLsaKI5zUdy0egcSSPJqMKxJKPW74AN59ZD6t2YAmT+uhIWI?=
 =?us-ascii?Q?8NjQ4SIaYOrqlP6imC8rrjZoG4nITM2DfyyCj7o4h8TN/v7tg/K9V8EVOdjL?=
 =?us-ascii?Q?r+F8yAWFWnZt4ZnxiL4oGsWWpaF6yoVFYv6YYDnrFbIH3rDQhAPhC8VVfcZC?=
 =?us-ascii?Q?5yVfh7O5J4y1EoDX94XZcmGCyLHt5c2Qo4N0MH2tgG7ehx5XcUlAVgsYfvM9?=
 =?us-ascii?Q?TrPerG3sWdsdMVJdSOlVooebh0vnWC4WNsRC3ycOjIS35xZmSqwcZmB/ywPs?=
 =?us-ascii?Q?G+7Aud5HaAhbR6143d3MB6+GA02sZecK7P5nqtsmgVwvk5Xi/JM5m0yeRttL?=
 =?us-ascii?Q?b+xCDX5uwnYsdU4fVx/L+sr/5X0Xbt7Qe2wk44l6PbyN0fkZurZsd7odov4x?=
 =?us-ascii?Q?is/yMQuKfGf8qhWmewv3IFZV3lDQ4OFoNlERgKUZNcByr5bJmTE4WGQK4X3N?=
 =?us-ascii?Q?G4DCp2nX4zKdqTGF+Ie51Onr289LrEUWgCdVyJ5C7CWxcCG5PSpVnWsHw2Ys?=
 =?us-ascii?Q?R3hFXrOUHZIctFHtGBxPUTlJUDcIG5ZKfs54T4cDI8xLeS803xcQefXE14/H?=
 =?us-ascii?Q?JWOw3T7uf9EcSKbk1vzdvGrxFstRzvCCm34k9XvFXBbbjNuT5WR/+1K1ccP7?=
 =?us-ascii?Q?ECbHAo3RyNvhMH3am8ix1lFxPR7UTog0febd1UVUoxqYPUhvt9RbrHFafJ2I?=
 =?us-ascii?Q?vWv7uoZranCA9paXPwN+1CL3+He8MPMBozkGaxdmWdu2oFSKpvoFCzR7hELx?=
 =?us-ascii?Q?saALiaXM475LG0i7qluCBDVKpZJKZS+pFz3AV2SX85yX8iRUem9/f3vegrc9?=
 =?us-ascii?Q?CqT5oFhdVrazuYb/553yu6C+U0DsVA5DGXPClVYRN4amRNIat80zhGyV2IH1?=
 =?us-ascii?Q?7KGELjrxfv/Hf/VylQEvB5FUS7wwtLcwW8ICU9iaw3AjONOh/LDWRvPVQCqq?=
 =?us-ascii?Q?W7CDvrQER44rq5JZnDMhcoDxgPrR/6wwEgR7M7ToQuSzsn7gn3w3DYwAblWa?=
 =?us-ascii?Q?9Nq+Mpmqx7VculatD7UsO4Vr05fySikZtfQrryfz543kyUd/gFwWI/TQ2hRH?=
 =?us-ascii?Q?rkpw3KSfd5QY+DUQG4QlidWo2xP9/XVc0NmUUCiUtGe7oIOPVGvWZfJHItf5?=
 =?us-ascii?Q?JrFPtIs2fd6enlkEQDxgkDI9XMwczRuAtf+aR7m5p5bz+eCRSGMezRL+Nezo?=
 =?us-ascii?Q?vg8cZRKD3FtgGOnKZC0ynYtoXclnmUtaL0/n/YgDQbkBqsB34HLpvQ5xXrJv?=
 =?us-ascii?Q?D2A2ZebtweNgIzas6CU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(14060799003)(1800799024)(82310400026)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 12:41:52.0355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 827a9a89-2e14-406f-7e2e-08de17b1b37f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10613
X-Rspamd-Queue-Id: 7FA5440011
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: d3hgzh95danfyuya1xzbrqrr5ipegzzh
X-HE-Tag: 1761828122-311623
X-HE-Meta: U2FsdGVkX19cTsd2Yg+7AOIzPes/lKW1xW2U6nfzK02F9dvWA0ai3ZmFc2vLh4VTYNOUz5IozYaDrSOgK+JXSHcRqjmmhuoaxFPa+nncCedhPJdXQWVLDOYWbocUdwUbH5bh+ub2NHPgC0wSD+KpMtrKYkW1HqsRqG7T7+lHeRee1TfszL7L6XBkX27ICIOmKvr1PaSWRMBVeCWOgisFk0GV9l2UJKIlBqJ+mAPzQdMHaxcRJ4wH0NJgRybtQhsFLQ8doW2zdCXl1GlqZgdIXJ9Ffz35eq875STgwLzOiKWQhGyS9Ov3qYmVLOZ8GkMO13VWl3kqpDU0LqLnnI208n+Gytv2xokdQTn2tj+PabtobFr4auKqINoUZqs51q6UH0m5LA5DnhrJ0KDVc9f35toZpN3ErWbDteWzH1k/ED8Zt7qwo4jzLzx0/h6QRdK3zqMS3oEO+cszJir6C3h8RTCSvJefCfaRpmWbWCUW0uQWuA82TmYdhPzqcvSjFkSOGMfwPJhDpNheFzxaIiSBMkV+pAn/YsKRixJDp1pFLmwrenVvkR8Q9kerLvTWxGVkgul3n5/GQQObS29KkHVFKdCUGgN7F+2JdXVM1rE6ttXB5F+QBsev+BrGbAcXPiZ3Vkn7MbcYBLfLVYDA7W21brtdKPzCqj2QanPUiZH8pQi2TxTyYeGLwLkkRkLahFClMKqqOw1I7m0QnpDOraS70jQPxWAqmwa5HL3oBHwUrmgFInh9K+afnAO1e3J46lfR6GGl7RjyAhbUgf6gSbUqkjpW9+oaysGrUf92N4iQSXbxSPRkPlY06pt8lQQRuJqgzhNu73LkFsSANcYOWTHRydw7MvCcuDwzIErDTbj5SR2Mijb+uNCi31xvc3TOBlEjmLf+Vsgy68xOXoIPnnGqFySNXuJkgKpqGoeulOzzKkAgAaEonRophkYwf/yYO+PZukJhyYlcqWgbLyGJ9mZ
 zlaQkJEP
 ya65D5djBcIaidJRXX3B0EyEcUKHy9cPWST5Ce+wRnp43N3nJQcBxMQ8jcV7I6egOtRMdgC3Wt2wGduu7AnDXd6UUVkSG3W5OBED6/TwMaZLuXZpao6kypNcc+skjw09Qy//7dXrZ/RX+SHB78/sOLCx96SexxNVBG5pq/Kf/IjS2TJPdqvAa0CQEQ2149TbKGpWwvkWH+oqm5EYRbThvlNqw0XK+wl0KN3mlF3qpjrdcGB12ACybxcXMpA9bF9ovjgohLxQlrfY40eHdyLEtz6CdqwffGasDgpZ+o0/fcSfH+zkkxR3z23yV8iqPRep2AuI2V9BW5Rf3UDJJH6jM8Yk1oPWLE0Lsq1AsG3kcYjyirfycjD0qlQT+ZNGy0QYfu0aGoxj9HS52R0GJMKtuYPJ92C/gtQ7z+ywpVXONYO7xjpERQkNC4eJ716egvM83hS903Fi7cEyuMf9Hps/fCZMJ4CuLpqejIPDMZjCF53UvV3EODSde6OKSRceCmpUnDgg7xmfShFhgbuhePWq+lmI6Hvdyc03wkPVlx7shdhKxduZhlYH0N1WiLYr1W8wtGoRX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,
> On Wed, Oct 29, 2025 at 07:19:29PM +0100, Andrey Ryabinin wrote:
> >
> >
> > On 10/27/25 1:28 PM, Harry Yoo wrote:
> >
> > >  			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
> > >  		slab_set_stride(slab, sizeof(struct slabobj_ext));
> > > +	} else if (obj_exts_in_object(s)) {
> > > +		unsigned int offset = obj_exts_offset_in_object(s);
> > > +
> > > +		slab->obj_exts = (unsigned long)slab_address(slab);
> > > +		slab->obj_exts += s->red_left_pad;
> > > +		slab->obj_exts += obj_exts_offset_in_object(s);
> > > +		if (IS_ENABLED(CONFIG_MEMCG))
> > > +			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
> > > +		slab_set_stride(slab, s->size);
> > > +
> > > +		for_each_object(addr, s, slab_address(slab), slab->objects) {
> > > +			kasan_unpoison_range(addr + offset,
> > > +					     sizeof(struct slabobj_ext));
> >
> > Is this leftover from previous version? Otherwise I don't get why we unpoison this.
>
> Oh god, yes! Thanks for catching. Will fix in the next version.
>

Not only this, there would be possible case for WARN_ON() in the
kasan_unpoison_range() for unaligned address with KASAN_GRANULE_SIZE
when:
    - No debug information.
    - object size = 24 byte.
    - align  = 32 bytes.
    - sizeof(struct slabobj_ext) = 8 (CONFIG_MEMCG=y && CONFIG_MEM_ALLOC_PROFILING=n)
    - using KASAN_HW_TAG (KASAN_GRANULE_SIZE = 16 bytes).

Thanks.

--
Sincerely,
Yeoreum Yun

