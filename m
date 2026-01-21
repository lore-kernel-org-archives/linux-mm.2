Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E2FD46956
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07186B00E9; Wed, 21 Jan 2026 11:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1396B00EC; Wed, 21 Jan 2026 11:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD8E6B00ED; Wed, 21 Jan 2026 11:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B33926B00E9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:58:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80CCCD363F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:03 +0000 (UTC)
X-FDA: 84356578446.17.8DDC83C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1D2C4A0014
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=owjYeWap;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QbXRMtna;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqRszWbzTUqk+djeu7qEE3o1TwiliEvBV88vRJf0aSg=;
	b=a8LO6YnqorTEnXMoKE3XGiHXzvcZihWIPT8zCB87QGpAgk41Fjg4AJF+kfo91n48sDdRo8
	/rkPH1uZnHq+fNlwEfoylBfkz3gx3xpGUDZ6m/M/60Foo43Tha8CJnlJhWbKkbsYaaQAXh
	HLTSynSEANRJ5CE1Qzm2ADvC2ozql2A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014680; a=rsa-sha256;
	cv=pass;
	b=PNxOpF2y57WA6cEYOmUKBvRSEnchWE1E2+6YBoqALCVrKk41GNZfe9NIBncSpaXDAJvtYi
	dU6qo1Hh53E+czY1XMdJ1OK+Se1BS0+vfk0R07h3kxejtEq6W5Peku/PSIXTpSk03FOeb4
	kqdXtb8A0JdXacS+bzCQygnNiykx/O4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=owjYeWap;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QbXRMtna;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LCeNZR3524038;
	Wed, 21 Jan 2026 16:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yqRszWbzTUqk+djeu7qEE3o1TwiliEvBV88vRJf0aSg=; b=
	owjYeWapgIGZv8Ox2sPgwxuYmmLk462I6DIHge6DZErhuEZCywGruLxp/I4Dinp9
	H24lQkb0jeXx7humIDq3wxdO3B9CuYpymqzc3ViiJXPZEiKQQIBBKqjOVCyxAunj
	41YFqK2mLxOeXGeZK4OoU0YiwYTCDkMe2ymh62rkVCcNaEXCiSKSqxr+W3TdgkTG
	iY4cj00TGUtx6GhbzxRGwnA6EXOpJiMiyRKMdv8wWVf0vxwKrTQkJw6gSVe91CH6
	1DGzckkM6kO5k39ISi9+3tdoM4zjvxAvjjmndXor1LSCAu9UItGjHsjoC+NLDkw5
	OMnVN1/pfcc2TiiGa2Mrcw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qee7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGqkbN032828;
	Wed, 21 Jan 2026 16:57:51 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfanbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2m/TAY5xwXyYGGhPGasAg9BLxzjOU68JhkhJPDFImTfRsi45ns5fLgqGqUQv5umXBC7ikbfj+XPmSHF8EGut2fsK5uZifAwXhc/03waElVjPK/Zui0EXjFGlhblpYmWG/oAA4nYnn6nt7kwPHa22V71t9NH1sOPGiYu6sAbiM1g47ocfvFykCKBRuhBPdaSm7Yn7Xxh4k/PSKw+S7wwnjc3krfdjzxgoDGhted7hbPVmgNqt12Xs3KIFkUDFSY+GI/Z99IahPlbMo4Ed98id1eayCqD6Q2o21+4cb6jyhnKuWP5ltyWngU6sB927IeJDtBuUsFSi77JYxUsDfb5gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqRszWbzTUqk+djeu7qEE3o1TwiliEvBV88vRJf0aSg=;
 b=pZAqi0T4U86NnaqUE5HuQrvYftf/tj7pLFCC/1uMemf0fhTHp1JuA9R0uzU6n3BQ0RAJj4EqT0wiyD1QMbSAQe++Gim7zgHXk2vB1mpG1xAh5w4am4JF//dCdpC49Ji1lq1KH5yu5PjLjzqSiOGOlXpxR0wAg7NVUPOBOXR8HFKd5+ADOoCFKWCdxhfupR/2AsxU/iQLxksPcL91/fmHkZxIUJNmEKB869CFT+G70nUX5SGipt7BxKg3gPQD3/kqkM3cIEzQqXtsHz+2pghc4R87x0jFgFK+d0wGrmFvI62921p8E6iHIaDqy8eSJqfTlyBYMkP9AEL2xuCrlefMFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqRszWbzTUqk+djeu7qEE3o1TwiliEvBV88vRJf0aSg=;
 b=QbXRMtnaMIDUQFa3pj2W1c6Oua2YhAr1cf1cW/eAGJbnTkmvcNi0l5/Vi4HttYICGGIGp/W64ONnLNvXwZPUXpe0Sx9OWcOgRf2kdt8iAX8mLxlgo6KXOp448AJJ0Npy5H7Xq/L10PUhOoU7aiNsNxhCwjyX3GSyMgCrYo7U6CY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:45 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:45 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 27/29] maple_tree: Pass maple copy node to mas_wmb_replace()
Date: Wed, 21 Jan 2026 11:45:24 -0500
Message-ID: <20260121164526.2093265-28-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0018.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: efdc3504-2bad-4ed8-18c0-08de590e32db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sI3WqSKXcFDf2e4G7ehCxngMrVeLVq9CkayoJ6ZeOaV0Ms4wmWV8AkE8ndfK?=
 =?us-ascii?Q?hsnhrlz2IimE9xNhWdUVpvgAmye7FQQwRpMTAfAOm9gn5fsIjdlR8RXO2MD1?=
 =?us-ascii?Q?3BN/asUlZ/ZpH3FeS290bjMT5nw+2NdVM4aheGpmK3AMUkk1M6wSM36guijn?=
 =?us-ascii?Q?zQs2BnHgSpzB1aKWwSF5IA97jXuJRpchqmdk+UfyZy6nWRzfyn7KLCwQFKU4?=
 =?us-ascii?Q?U7tIIitUDqjN+grUoEumZMO3b9gmZzwTrw15f3I8rwZlaSmqORNCXgQ4GNHN?=
 =?us-ascii?Q?QX0LMg/Ljqa3zXxiyLNUFteE7xUWhOsqO4u6BiskW1gSXCMzRpekZNIVxNT4?=
 =?us-ascii?Q?aofS5j+8wN92FRcIsVQ6uqLbjorPlkF7S+dmweFtlBLo/7lDjIiSjXv0AGO5?=
 =?us-ascii?Q?0sAUT6RfZ3dNDT5Q83srlWVf3cxtxG4saY8dLdkDpiWXf1RW4SFx42Sty11h?=
 =?us-ascii?Q?Mf75H8PW/7KcIHdfYLpvHyN8n8fDoPdWJ8fh9MjP6ftB/viELOC8zl6aU2fY?=
 =?us-ascii?Q?Mxzp7U7IKSIaBOkhuUSWAFTvPi5KJirLCIyj0eSiiILHWJTm5TxwzzshM09m?=
 =?us-ascii?Q?788KjvQD9Fv0dUrSA0LTTHlk3HWE9Toh61hRvC8jQnk3dLwrLzcRyTxi/G0x?=
 =?us-ascii?Q?0cfF+Cledg5283R+WmJpvbBs/cf++FjDGmbXxTZu9jwYq5ag7cQFV0K8uktn?=
 =?us-ascii?Q?6Vr74qDTAY+WeJut5n5AwU5z750BvVTahpIAICXlkScpd17NY9YrEeFxwshK?=
 =?us-ascii?Q?dLxkdASDAYsCQXfpBZT+IDPa5Bt3XEBVsSmHwkraJIee0WSN7kpcn1FzCDQY?=
 =?us-ascii?Q?MyAvptoOHlNOfLbt1CNa1JNBhMFwLNdta5dy1qW6miHu1pbhu5zA7XWaa9gw?=
 =?us-ascii?Q?481fMzmHGuXncReRpvHPRXUpTf3ayR/rhkWVoKM7yiRJMV2Xnc0PeltDud6b?=
 =?us-ascii?Q?PmBk9RgsdIht1fVXVcLAMqcbHSTjxJRGEqgb8Jx19bgbiEmVMocv7/yP56J2?=
 =?us-ascii?Q?yuQjRO6M5jhPzDaBOjMZfNBLsihAme8XdKQE44Gcq5kM50nNkgU/MXzqPFkC?=
 =?us-ascii?Q?aHVfVqrMv1PbuJ2XqxU334GJsexGtAVB+xpt+IEjjMEMlcXpXAXpGaPMSz6i?=
 =?us-ascii?Q?A4l8q7fnxvXje5prEafet8xdf5J8ijBntoF4D8Oq9VSWPKPP+J4N9XnBZWAb?=
 =?us-ascii?Q?6Tp8eZNpB2ahGBWHusO6uvIMbjjSpyw2kKOPik1sCuKlhV0/VeUWWKAhMafS?=
 =?us-ascii?Q?MH0aAx83BQWpNx6ufadLIFbWrWYzHUbFOzakXVw9BwxeQyXAERrRAq2tgHHJ?=
 =?us-ascii?Q?m5LEE19xnabL++spoekIS1TYBbShG0YxE3T06ma8j4jvkYLYb17MdIxM5km/?=
 =?us-ascii?Q?l4BzpEcWvEZFOfnJsWX0XNiFVh3fqgqUYAnzPZ/+Db+QExQo1/X5A/I2Vyfz?=
 =?us-ascii?Q?EODJ7OFgaFXWMByCtE3MLqJugvrz/qrGWLI64D0p13JfXs9AijJ1kSfqwp9Z?=
 =?us-ascii?Q?2XnFTaIvWA4bJFlTyKw87odeZ8e2kl3giuPeI4MDAWeAWLPvTTkw+BfhYU98?=
 =?us-ascii?Q?xkXSvkNCEkWac9+txYY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gF5pY3+TN202C/Akel+XTMX9jWmeO40dKT1jqds5Ui5uw6aNU1vo7KNTWpHR?=
 =?us-ascii?Q?XubjfgOKtii+OoMn1a5AjUCrmJH2quRgPjotHPeE6JOlTL0RLqQk2Xn0rvWx?=
 =?us-ascii?Q?4No4Uc+9wW6vg7qABnDXK1g1XZKbpg+QukK6Bh4jacDHQW4XlIf5XGgXjEO1?=
 =?us-ascii?Q?zkOmQYbzUYu4IQVUuTqWTwjgKm2NQmvPCyCqCZFb66uoezMEN0lWVAEg1W5Z?=
 =?us-ascii?Q?l1h1nooew1cAy5hMq9G9FLGCa+OEkKTWLNfBXmLhn57Qgx10HyYw944h2boV?=
 =?us-ascii?Q?b7wRn83ufbNKLkbHDm/X9m6kTQgQ4wDeXreZvp+Gt6UdxD6J1N2JWW5m61wq?=
 =?us-ascii?Q?hlzPwnSIafVAEGhys4AsvOMGpbdsIR3j2y+oy0lrU/sf/ARsd3FCLIgMl6V7?=
 =?us-ascii?Q?+02IpJTBXRUWEML6WoRLgSiT2fh4agZDy3FSGKwh3jU6iJt6HBc7xJOaou8T?=
 =?us-ascii?Q?EwX59hV7akH/y8Yq6c9LJjcKsm6Hi39d8fbLK4RPW0z8Q5Sc7WNVQtNIfjEU?=
 =?us-ascii?Q?okiP9boy6oxku20pz2JZi4ew8sBS33ou7uz1vifddm2O1hdn+rtToj1z2BPv?=
 =?us-ascii?Q?Or2xsZiblHj4vXLeImLmADiWFoCWXepaBS2c255Wk3wTpxducmpdk1RgG5Yl?=
 =?us-ascii?Q?B82UKIP+sGPcJyrz3Rhbp5l+/1QswrulItNVbyZFWmyr8MKztivl925RCMyZ?=
 =?us-ascii?Q?0fkTuH/itr8gc4io24EymyP3hM3uCDs4LECjv5GTtiou2CZ6/9UPnbyet8nW?=
 =?us-ascii?Q?Jaxk7KKu/ua17lo5k+4swSThl79zd7Yxycg3yrHsZsQosYpqBesxmfq5N9MY?=
 =?us-ascii?Q?MJNKnpcMWxfRXNanN1VPje7n9h3FBzMhJ0qfpu6WWdwi+G5sEfo1WMVp2dOU?=
 =?us-ascii?Q?6W5Z64VmtirHYt6GvREKgz9BKemUAg9QbRUqZPJ1OGltKJvfbrqMxdnMMPHv?=
 =?us-ascii?Q?xFtKhC6gNwl39n+N+B6wtMvqqrQVVyPmkoQ9vJqNim5x9+jC9rp1c62KGikx?=
 =?us-ascii?Q?QwXVR8rbf9MDcPh1XgLfN//hXsXuPHm9sK5a2r4V7DNywIy4+VNV1O/91ADp?=
 =?us-ascii?Q?Rq6LxLoHHbHbxyqw7TA5qyrlqMVmY1w1lxb+p33oml130Asmax4SQckkvgbY?=
 =?us-ascii?Q?tbUpFoo5o3NDv7ToWlBlWxDENAIopuatyueRP4Em8pExAJ0o1KRHoDDxIVkO?=
 =?us-ascii?Q?P+pzjiqO+lwhatSWwFpJudST2IX+0K9VrNWt1J6YFDrAmbY5ZqPGo5h1Q4sl?=
 =?us-ascii?Q?Rw4zXNFIFuKfygrWGndzBP39wtxXOihMk1CRI1HISUUiDrD5mjTIAbU7/vtg?=
 =?us-ascii?Q?gTQ5efqC8TJr9J30wZ6SMHtV1m92MGX5tuldFz2BEjY1K0Ltckl+ybJAU01o?=
 =?us-ascii?Q?ZH3JDJg+iPhWGd1x3SLgW6AzcFGFSsHSRti/MHpEHbz6MjtoU/+pDLRaKKw4?=
 =?us-ascii?Q?QQknGQkdxqO8rE7GJv3FvH2DqE8uLQ03X6BgoGKo+03NUe6SmeFtdwGy8yS0?=
 =?us-ascii?Q?UKexkWPO3qUGOxeycnt16j9FiX20in0hFFLzsTh2GUsLiw/v6lf2x1jFQ9aU?=
 =?us-ascii?Q?XgtglybPCW2g6muOdBCaSpu1QG9sxh9cSus1EXSmpQ85668/37xHWqGbvS7/?=
 =?us-ascii?Q?hrs1jq7a2u35L7CaF3dKwHe9SFC71UnHq7/rZxVhxZMav6adK6Ddj5p1854a?=
 =?us-ascii?Q?QL76zFPE8814aEGXHXy6y9PPCST8Orppcvo4PSo8A+xH7BtDZKOJ71Oh2tAH?=
 =?us-ascii?Q?nkBS908AzA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6wjt/Q6/sZOkTpa6ogUVfWMHoSK5XTehB+EhlsMl2n3HIdY62+BJ2P+7gPr/FfLhty+yC5KqRa6YDfXmPw9qii0TVDpdDw98d/cV+In2yDrmGxuoCaorCKRVxqy0ZQLt7feTfEoGlAMX4XVWiIZtVwUuzb/oxgF8QCSsW4YhYP4lRYP7VwydcykV+8a5QFE9nKpnlvFeiR3pUzDRqRYBIFfd6Txx9H+43UC/Re01dQPw625qBJIKOC4ed87rO6/sQP0JX3ZpwO44Um/+AJbXTy49keAb24QlZ3bTkzM+bH0KZO9mP1Sl25pm38twgzC3nmFfVLoqyFeaLNJQIBcWFbyGg0AD+3JwihPMFe2U3D9IjmppVtpa7I0nbAA6o4SSOL2TcJ8MPRk2CI4wtQY7e1SseIS/bE1LRHwZre9bWD8WCi7U3dWMCFpRu29yWpevw1gSuCMqQEymoiSrl7fxO3+AMO2EsdneM4W5ggdTiGHJesbelnlxHVvElpo/GahYeP4CiU8FaVgYgNvI+qpz+FFJUCL4B4akk4fobOLVdSfCtB3iyh20lsPkHV19U8anq9KWKToP+PHJxEVxHGb37hLMYnNv8OYOv5OLT0b0IDY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efdc3504-2bad-4ed8-18c0-08de590e32db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:45.2043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: it0u3GUj7ogWNo9vyYwqnr1kXMD7NImZtd+y5JgXf/9TeoSvdgVGUJYcBWfcCJhvE//jXXpBPmPMSY+MEMzNqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-GUID: _hhtF8SZK4VSVA4YjLVYtgtvTpQ4ZQgR
X-Proofpoint-ORIG-GUID: _hhtF8SZK4VSVA4YjLVYtgtvTpQ4ZQgR
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=6971058f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=BeRG0LNnq5H4T7Nsn9oA:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXwFClQmdlitFr
 w44ZFasrgebj14mZlBPZp0xksATzT1Rm71wj2xpK3u0P85rHMdbS2qJFEXEyMrvRfBJEib3Bn8P
 6SMdgw80eSwKPDmCxTfUYRvpC3Ylaq6W8eAjNF4rRLGXnB061+ZaqIYPfi05Goqf6PXzigMAJI6
 Tw1n6RrFg9k0QU+4kcOQUWhr8vTb36jCUqgoqROmXgDrsFSNhxHmGUmA1fut1OsZKy91PYOE4aq
 0b9S95xvdrgrtIVKNnWqOfnJnNsxU+oHydkfJLCjCx7E4Ggy+ew9BDBiUW0MPANND/wMUa3Vafn
 w8FSQZMp1Meu+9hmPoegPbKw93t8SsLZYgV84zkZ2M2Yx131/0XXFwe1ppoHo68+pVDKDe6E2sw
 CynQSN15k9U+QqKMkAR5qCR02xGmXfZIggu6+AaLc6tbhTupqTmdaHFGLef32z09d1OcAkx+4Xa
 NDbxXnewWxGJCZnPxOgUnM1gBsdaRzuLTZsQRAZw=
X-Rspamd-Queue-Id: 1D2C4A0014
X-Stat-Signature: qqgqxbqyhbdjwznetjc6jjcgtpuago8f
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769014679-145817
X-HE-Meta: U2FsdGVkX1++ITyrsK0uDNvsjQQzfvuOfkzg+/yCnWZxgFy+I7kSyNKzmKTLth43ERXEP71BUrJUB3SbJYnUZEtpr0X2ve3TgYwFIIY2I2H1I/m/ObCCcVv+lQGJLGmMcxTmfwHyRFe9PY/6DX6xzpOKkNd/QTY9K8zWFyEwgWcKG1W/EqaUAXHbXbuNSgop0XBwPeH0Ai2drUv+mGPVyULMSnqSH2oLTLhf6kqitQRgn2eKnthG5qXQp8e6b4W9MPKNdufZ4DmwmQ88x5pEJ4eoTX6S11cqGcB++k+a1gnnZ4YmZK6GNPWsEN3J9p7Qy7eKJNDOS7UI3mEJ3bNCDmDyfaMXcD3FXi2FY8n5MOXSTFYl6uuJ0l4145ejsPbDlnd5+pgFcKtWHJWCtF6xzWjGf25Ly+JsHRlsVtJzyyp2BJknRTLK+cPyIq3tccj/jyXWOSbPFLTwOVoPkRasqmukkZ/GbHIBTkW3xs8atEfBVY+sSoVQHnpfxq1q6TV+K8v6FwNXHg1o3lL1YjMyoyIXv+C2n+8uIJaPnBeKItW9bucAmxV4ZsxFYVu70aBhs6bdJHTohjnmnJV2H0oaS9unN/zwzCDxcPLhu9Wv3RXkSu8m/8mhv/b4AlieiDakZ4w+UtHWAqxozah8XjyQEaKa4KJw/VxM64+7vNy1HfLa88OFE3g39zPcCa8h0/vdRqpaSpIBuS73p0UEWqMQ+LUtFlPnVwFuVwvDu4OT47d3Ja4R+dr+dctOQpWqZmI7YEJUuLTlI9tT0ei1DJh5e/DP5AiGqogm6661nPc4itLEPw+Yt16EULn6LZ/jP4W4+R2lxcHaauE2P2RFOD574HHUs8OeR3iA7yxSaBgZs75D8zsguHWldKSPRKpqrvJL8A9xrE9GZJ9ZeGPH5HQhnSTG7U2K/8F2GbnKL/YSMYkDp9SzQ7vAn2PSPZ/MXQB+vxGDefwMcyXz0haGnYT
 VUoWgTOw
 neyWbCxeBUaxuMvaNLJHYFQ6GIVAHDfCd3IyPbsT23LwVpCxE0vdU/UKZOCHQKyo4NcXj0doCtHDVUPZ1X9QQ4m/Prj8wmrxfq4htULQxQiqCx4LJTRED/Yf0o61Ou8p0w4eSjluu/vq+x8QKwJzuPdYqSUJOixhvQTiF/Rx7fXpXHNcW4GKRQj+lUC7KHNSom1oVwyV0K8LtW5HAMydZIOYuGfOO4KcGeLZZnfN/8WuCt48bF7Mj0fx9A4WxqkrPgtK78q1ECSkbanfmnFhXy04JHBEY3t8QWwUJEwsldSxCi0Hhu9MC7Ymi1NqT4pwu8cmqK8acz08Cf26UbY8RbtRB29XMXK/U8uF9eo40KeOSyv8wKwI+421jFNdcNGHHLHbOR5f62UmzTeoSmG8+bVfBhwrh6HqGIZ97MD9/pgDkHzgpxhKsa6Lb5iCpD6oGxr4G/hPDQz7bEKYXMQzFZ62wSbKuhe2bwAFx2DX3iKEpKqCGXk0A5o6fFEVJLYDxAzh9mbGVEgPh8hxLyhWF/VAgv6Mk0YrvRCrG9lVPGs+r6B4lHgN5un94kt8JQ0AKO9cVHec50w9e2MHZCGlCYl4WMT5KkoCtqO1+LCrRy/COWTpcrzBjdfGUY/zRSRiLGa2FGbmlLJCFguN15wJG9JOXcn/6mxVM9p8hzwBfANumcrJtF2lBXI1rEkdX3rEHH/yVvDqkAD7qrNF0O4fzQ+ROFLb+OXQMtPX8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_wmb_replace() is called in three places with the same setup, move
the setup into the function itself.  The function needs to be relocated
as it calls mtree_range_walk().

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 60 ++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 744df5a596550..8ce4b252c0696 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1893,26 +1893,6 @@ static inline void mas_topiary_replace(struct ma_state *mas,
 	mas_mat_destroy(mas, &subtrees);
 }
 
-/*
- * mas_wmb_replace() - Write memory barrier and replace
- * @mas: The maple state
- * @old_enode: The old maple encoded node that is being replaced.
- * @new_height: The new height of the tree as a result of the operation
- *
- * Updates gap as necessary.
- */
-static inline void mas_wmb_replace(struct ma_state *mas,
-		struct maple_enode *old_enode, unsigned char new_height)
-{
-	/* Insert the new data in the tree */
-	mas_topiary_replace(mas, old_enode, new_height);
-
-	if (mte_is_leaf(mas->node))
-		return;
-
-	mas_update_gap(mas);
-}
-
 /*
  * node_copy() - Copy from one node to another.
  *
@@ -2079,6 +2059,28 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 	return NULL;
 }
 
+/*
+ * mas_wmb_replace() - Write memory barrier and replace
+ * @mas: The maple state
+ * @cp: The maple copy node
+ *
+ * Updates gap as necessary.
+ */
+static inline void mas_wmb_replace(struct ma_state *mas, struct maple_copy *cp)
+{
+	struct maple_enode *old_enode;
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp->slot, 0);
+	/* Insert the new data in the tree */
+	mas_topiary_replace(mas, old_enode, cp->height);
+	if (!mte_is_leaf(mas->node))
+		mas_update_gap(mas);
+
+	mtree_range_walk(mas);
+}
+
+
 /*
  * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
  * spanning store
@@ -3036,7 +3038,6 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct maple_copy cp;
 	struct ma_state *mas;
 	struct ma_state sib;
@@ -3104,10 +3105,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
@@ -3425,7 +3423,6 @@ static inline void split_data(struct maple_copy *cp,
  */
 static void mas_wr_split(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct ma_state parent;
 	struct ma_state *mas;
 	struct maple_copy cp;
@@ -3446,10 +3443,7 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (split_ascend(&cp, wr_mas, &sib, &parent));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
@@ -3462,7 +3456,6 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
  */
 static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct ma_state parent;
 	struct ma_state *mas;
 	struct maple_copy cp;
@@ -3493,10 +3486,7 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
-- 
2.47.3


