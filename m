Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E719CD343B
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 05:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF63B6B0088; Thu,  7 May 2026 01:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6E16B008A; Thu,  7 May 2026 01:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F576B008C; Thu,  7 May 2026 01:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B25796B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 01:52:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A58A1C02E9
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:52:41 +0000 (UTC)
X-FDA: 84739554522.28.8D6A2ED
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010004.outbound.protection.outlook.com [52.101.193.4])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4CE6640008
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:52:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="gFB/m+Yi";
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778133158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6qKsFlwJyWWjyNnCw7LMqqMM0FAJ7PrAiEboSmxZKQ=;
	b=zVOGkzLZRjScNPBU3cpSkyquQ/jAKDtK1Wq0ywDBKHD9HUJiRewmek3xztQ3koSL9p5LSm
	vXJwZ1PwogmJXcrl2xtcOq4LU/zVWBXtT4+eIelfxrtY+2OjIjk8GYmr45WfNeCitKE1/a
	0tYxcjzmxD0VrXpLmoI7s66kM3ldAPo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778133158; a=rsa-sha256;
	cv=pass;
	b=ssUiLjRt13JuN2LTluUC7Au8Wn25M4WgMEIs6g4rWVMRPknRg1/7g1ic90IYRQkNXK8T+b
	dJv2tJydX2vieo9Fwl8wSfGa1b6gtp786IR07vSkLDL8ObuL2DOE7It1fK7QDB88jUJ3q3
	rF+pbs8/gDIGet9WJz/uNrLu+fK44CM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="gFB/m+Yi";
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F099egUDaeZvVUicLU4FTLilxuexY5DIA/H45nftr0Z1d9sbYpljVtMc5tyW8rWtljRRYCsdtqyxcdIcVdfOuWbEOI8J47I2SVOltGnV0ulCjrBqYGr/b3p7nyhjfYGc/Sy6nekox0JMRqsyLIksBsmlB3LurSpHfVhrpQXEx78adLQo1ibL1cKQc4qy8LFPyeapEYYxiMPJzjG6rWiX5VhdRt7vyesgc8Cm+5a5FZYDptmkJXwz5fdfCGKrkXhLNwFMvZO7wvCBm7USGK9UfUQ+GNCNSEgZYsROqfeHOTl+Y6l40+/dNC75wUhs+VOQxTcm101tIV9Iv0JBr2OvWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6qKsFlwJyWWjyNnCw7LMqqMM0FAJ7PrAiEboSmxZKQ=;
 b=V7rS6iaLIwTDVQEwEaaoBHzcpPJ5k72YLe+hpVhNMiU9DUzO3ugMZIbRn2P7zHaOkIcPDf3bMmyjYXhpwBerUdQMnAjXtdaoaDFc3iWcdo7ixbhQPqFbW7EElRG6ZGVHOdnVATZ5bQwMuGfC44nL6ymRZC+wagajA4tY07/fzL6VjRGmxBoMlOyQQYvRjvIO5wjH7DR8m2Sc6xShitmWbgaZBFaDbsbTwnb/uu9QV9bmmS99uUI/VgXezyu+MQBWd97RTaYL/pYM3S6adyYsGHai2PZGWZiYOBsfvnm2RvPZf7Mq4zt2oS+nDUJ1OjHLgMu3w21vs1kGr9W9jkPHVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6qKsFlwJyWWjyNnCw7LMqqMM0FAJ7PrAiEboSmxZKQ=;
 b=gFB/m+Yil/wIfQ/NNTAu0Eb5+1WSmhp/8CGvZi1pDcAuTydXb+95LZCfyWpL4OhWDlMJ6BKmbq1TSl3eOtlDwlvDE8I8QBi3uICrb9n7BlA0u4yY9GvLy2wjuaEZZ44EPp+JD3Cx/OagB20RDOcnFc/2V+IH+xrzL68N1vFTfFqfcuxK8jhUMjXvIsQwUluTaPHxZaIZIbv+Stdam+74odcNMJ3iYQyD3SrkqRoq12p4R+pOfBuL/nlGQX/+1v7vpd7m9zgCR5/FU6hUiVy26aIR/vCGlAAcnX936bo1hnH5VYIBn7BT638tA3MIipzU48sBV2nUy3RPaHrcEXXtLw==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by SJ2PR12MB8034.namprd12.prod.outlook.com (2603:10b6:a03:4cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.16; Thu, 7 May
 2026 05:52:33 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 05:52:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>, npache@redhat.com
Cc: akpm@linux-foundation.org, david@kernel.org, willy@infradead.org,
 songliubraving@fb.com, clm@fb.com, dsterba@suse.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 07 May 2026 13:52:18 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <2BF9E08B-D35A-486D-B934-B8537CA9EA45@nvidia.com>
In-Reply-To: <20260507032956.51667-1-lance.yang@linux.dev>
References: <aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@redhat.com>
 <20260507032956.51667-1-lance.yang@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|SJ2PR12MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a2ec45-26ec-44e2-b327-08deabfcd517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DOXx/KO8RANfu8ppTi0PateAa3A655xS2yH79ccZ0t9KzcbLIgKb/4VzEu4XYDQOCZEZgNv4pa2MGDAY1mFOmMHI+62fpPUuvg/Vc4C2crILSFMYAdPAWuCdk279lRan93Bpkw1VdX3k5aJz/kRiOCSb4QfM5usR9Htuid5J/7a4v48212QBmkCHJqoI5vAvjKp4raZL432uLaLdpFq2kNvrKKicU1p+Yui5XG61a2aaADBdwAoCnTeMsKOadtPBwzrPty7sxbQ0j0kHl8a4tIGD+M+B6Vsehgxhyu9HbiH9jrwLyWDXmnTb6l86IdMpfcFmyB6Ar+m2yswDOUNvQZLRy+BDgbk8G6OriV8FtbFsIxA9oSJIk9JhkJqkka+YviEfXL/AqGUcfu3jHysosKwv/GNlZ9LGOQsXpYD3Ap3HOyFkyo1uJ8F4mK7FdbZ5oNHKcXFq4p5U7PS6d9UtdCfMveXX8X6rjCWXw27+2YAX1SdUGLZtZV+Q1RRAgTJJZ7aAQ9nOGmai6ziEc4oqiw4n7YNMtEWFbyPNgXRvsSwa22+bzLt9mpZ+9aLONKWZvFZusiyX9tj5jgd8GjQfqDDi/Kw5mT2tcwgS6GfD8px6Eg9b0NhUe5gK8cC4q3hS/tsvNpKOgXRX7cfIOiJ/h1/Y3z0Ub3P4rTlWAAaIbAW83QkBDm/4CuI3Hw6F47vD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aL+Uzl9lphVzIdObKrSwX27CJ8PWhfRYyLqjF1A9H6Qeg96In/C4mpGCQiFA?=
 =?us-ascii?Q?hvOLjRqrZO3zWhaayQFKyN6zcI0l23gVUnbyECjsSJFFGo5g7+uwk0+gRLzp?=
 =?us-ascii?Q?qMdu65IpoW9CPmghTQPbm6wJ+UU8lv7n6ndTBLH7Qx16mUgafl3XfyRuQf92?=
 =?us-ascii?Q?NMpnImZD9nucgXjK5a7cSFgY9+Xr6RVYEyadePH1SSS31P+eu1TU4Nwc4vs8?=
 =?us-ascii?Q?IDT4w1eL+dSHgAxu8k0phVpvctd+VUpb54qg8kGeEGlVXd7LMEQ08ZqiredO?=
 =?us-ascii?Q?xC4a4cF6gKATL623oax4awq39dunp/0bSdWu8WQZqQ06I5mrbRGEUhx68QB/?=
 =?us-ascii?Q?iZtBfhWd99jH4XMvPiEn16mx/v+qjV5HUsRpYTPs0dtzUghyyhOUlBk3U6WO?=
 =?us-ascii?Q?B85MikVhpyy4BKqrscxizPeghHJ3VO6IlFBECFmj/F2yPQWW7b4ORtC0hnn8?=
 =?us-ascii?Q?vbLwcgLcA0kcbAP8UwkdIQva6j8LstWYXRDZ5wj7OvtTcj2NyXPu18YeM1yc?=
 =?us-ascii?Q?CiEnh6IbYAOLHte2bs+EgJ+83qsxg/IHfAgfj7//V3Fef6B/jeOPUO1mLDfj?=
 =?us-ascii?Q?QdPzgXMXwK6gSrQHJ/f7q482MtvGwAzrkv4riZHIJs9YGP43WFhRglYJ+ehn?=
 =?us-ascii?Q?h1+W+ssMqwsRL4HWC7JpMKfLrU9x5TRzFQyBmONQaVT5mwauOXxbDThOGoDl?=
 =?us-ascii?Q?Gs03Igb/2592+53ix74XbLIUt6C8LZjoX3eOUJE4kcF8+liaGkVGVaFec/GJ?=
 =?us-ascii?Q?yLtcTA8P72F3GIGGHrgnbbfZYk2Te2GuMAcFfZsQ4bsylynmaRtkcKe9UfzH?=
 =?us-ascii?Q?TrbzkydACptSF32sY2X/Fj4EWDfYAEbqwcH8z9CJwC/KjcTlZcQHUu+I9+8n?=
 =?us-ascii?Q?wQygaqHBN+yPg5M6jJBh6VI5zBGOKh+MKz1OlYKQJACg2WT6PpxaSVrYGemM?=
 =?us-ascii?Q?lle9m3BD+/eEL6AwY5CBj2Z/p9knTfaMYEa6fOBp0T+OHEO4eiXvEe0KtL0S?=
 =?us-ascii?Q?GxI9DpV8bV2/piblnmeywsdirEBZzi2nFCVWeTG611jLAMZ7tavG3aiC9uib?=
 =?us-ascii?Q?zJ49sUxL0LgAMcq6VkmXlDz7I+rQjaBTCAvcv/5t7blRCtsB+/MzIU3rVwxK?=
 =?us-ascii?Q?LOJSBh6RtVM9eFJ1lvTYLXMyk4y3Y/0ti5YnyIMYhWGxjd7mN614xHdQYvby?=
 =?us-ascii?Q?YmvjE68Sh5Pgo2fpdXRv1h1+SIfQRvZN1sF4QsE3vUnPZE/hptInpzIf7Z+f?=
 =?us-ascii?Q?EPhWM2ZyyNwnTYG8ai05CDUojirVCx+224gRLsFGmwNysCKD+XXNHGt6wsfR?=
 =?us-ascii?Q?9ahnoALNQw4bmk2kSDJTHlzyGYLVHSkoiIy9t2bXN06OMkhOYjQgD6e3Xq/5?=
 =?us-ascii?Q?er0vycB2HYFCpx+RcQHrE+YHTK66cV30yW6/OJkeMXuDTdvypOFc4hnAuQEz?=
 =?us-ascii?Q?/Sc4f/j0jF9TuX4Vd02NfNKlNK45X8k0KKPOqjmvjgnu1Xgong7ShPrCtTCy?=
 =?us-ascii?Q?Yd1qJ9H/pVi4eisYy0fo0hYEG6OAyGQrYjBvs0TTYoraFl4GtyQnn+2QUE8g?=
 =?us-ascii?Q?PzsSUXkC2i3U0AwKKaRKSALMS/cksKxLb7VFzVSK1q80KTnNf5DXrPZl7mjU?=
 =?us-ascii?Q?yS0lPov5q/hwdJTmlTR8usk/wJQ+0Ow6Epx8mKTfrZ2OujCyO7CLoo58Dsel?=
 =?us-ascii?Q?K5kx/sKDhDf/NMDCIhfrp+zApHGlLw33/C1hrwjan8CWr5wG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a2ec45-26ec-44e2-b327-08deabfcd517
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 05:52:32.9613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tCbg7EeTWh2veF9vA4mP44Cz9YRz6dN7oD8+6TjRQXpom/0Jjq3L+KsQvnRpIb9V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8034
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4CE6640008
X-Stat-Signature: a1cpua8ybgh37gxos11nn37f61hgar54
X-Rspam-User: 
X-HE-Tag: 1778133158-824928
X-HE-Meta: U2FsdGVkX1/Fruy0AvFE/r+ew6e366M5Ki3Y2Zih+SY4vhDLUR82bRRdlyL3s+pAF7F2EgSvFls9cMM8+YnkTQEYYLUW3zVKkUsvqaKsGS+S1TwPGW1FOrYa6BlW1OqYnVMRSyXYiMjKWfK3LQL5ZKPGpF26euaWaZ9syMdQ77sTkebw87wjAhzP/XpJ2u+pqTIeT4R9B6mcnXXMa60LvTUrRfknzIwzfZDs7sk264GxsDPCCrdXC76lyu8NA2X+ENAjP+fxTo4idj5d83eqJnmRMOiVRqYs8gWEgOzEdbeC+6Nb+zF1pwSEUlj2oIXHFV0eQJDXXK2Fo79NdsvpsuQeOaPLRKEFHvkHoE3foUJYP7K5vuPFLw5UR8hEN1pVBpuspqpUBjZ9bERbuQ1Yyq/auO14wSkSdUW48yG0PZ5rusey4URwvmYsjER7sCzC2ocsv/mjfjyUi2lH4KF+z11eRgljQ4ENhv3/8zzlGgQ3d4bNmogyFi1C295egUSiOvQrzQrbECs2DzvwG3I3eR//Q0ZuezLykQftK4umHF9C6Umz38CahHcT/xJVTNlhMxbAZMJJAys/7j7ndqD/lf7nNER3FaiXsHa+2f0zuRNDqYOr2ZGZVkOr+zVmX6igeRDLwkh7/TGwbe3Yy5ZWWh+d28vYckG0hiv9zNtppBgorAD5rmlUeIjxY5gBt08zz+ui7m+12/NP87Cax5dA1aLgtVE+yt7LcfQNYWKNLVNS82KxBP8uanfqepchyyvAT9nz78zmE03dWsRk7d2sbeaZyT1ar3aZCxpteFQ8+q7Qa5rjfwLiVWsSDlNk9iIsI4Q8jW7vKBTARfR/yatnvA6Qb3Rw1LWT2aO0gClZ0msYqWqcsyCOJYlg8QOAGRpi5EGsiDKSMVDYVUavvYCc3kqo5iOJ4RhTHU+ZjPHg+AFKRjziPBOqnuGF6VS0sx9pGT+fe4lk8AfNPIvfelD
 zqo9OGBT
 tgfIfmGKAq+N9+AFCS1FLl+hAfYpJaR+zoAgIa95/qQq4HmVXrGhZLn8gybkYcDT2BAhUFOd/HssIPmbY0TR7XChY8QiEeRlUm2aDa1hDi33/rpQHNQOQRT2oEG4BEkjOcUru/ZDVPLS/DKvhzlHjQuL4gEtXWH/t3AjqH2ECwbU2NmQSVZ7WqXGP+OdhxIJ4YgDiBGfqvzewSkmo/0VUTXAeDXVFPGNAEXTf4kI+2d+hlSMODMYdNqnMf0yqFHL0clvYJQPKobukWPT9Tyah5AL1j63xslK6xXbtY+BL1MgGqcMY9YtSaBTywZGd7dT/1Nuly7Gz3SGDIJEN2B67Ma9ZwuNL/An0pPA0qhH7mJo5pYEF38TjzP9Iz0NeGAvMJO/QewHWhZlCCdZk3mTqvjgroxIzCJq6s+cV0aF475pSBMVCKdjNWPxeNW/+MtCSc5Y9GN2Tv3k2Tw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 May 2026, at 11:29, Lance Yang wrote:

> On Sun, May 03, 2026 at 09:48:40PM -0600, Nico Pache wrote:
>>
>>
>> On 4/29/26 9:29 AM, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shm=
em.
>>>
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>>
>>> Add a helper function mapping_pmd_folio_support() for FSes supporting=
 large
>>> folio with at least PMD_ORDER.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
>>>   mm/khugepaged.c         | 10 ++++++++--
>>>   2 files changed, 34 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>>> index 1f50991b43e3b..1fed3414fe9b8 100644
>>> --- a/include/linux/pagemap.h
>>> +++ b/include/linux/pagemap.h
>>> @@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(c=
onst struct address_space *mappi
>>>   	return mapping_max_folio_order(mapping) > 0;
>>>   }
>>>
>>> +/**
>>> + * mapping_pmd_folio_support() - Check if a mapping support PMD-size=
d folio
>>> + * @mapping: The address_space
>>> + *
>>> + * Some file supports large folio but does not support as large as P=
MD order.
>>> + * If a PMD-sized pagecache folio is attempted to be created on a fi=
lesystem,
>>> + * this check needs to be performed first.
>>> + *
>>> + * Return: true - PMD-sized folio is supported, false - PMD-sized fo=
lio is not
>>> + * supported.
>>> + */
>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +static inline bool mapping_pmd_folio_support(const struct address_sp=
ace *mapping)
>>> +{
>>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>>> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
>>> +
>>> +	return mapping_max_folio_order(mapping) >=3D PMD_ORDER;
>>
>> Probably a stupid question, but I dont know FS thats well.
>>
>> Here we are checking that the max allowed folio order is greater than
>> (or eq) to the PMD_ORDER. Yet the function asks if PMD specifically is=

>> supported. In the future could we have some FS that does not support P=
MD
>> orders, but does support larger orders (eg. PUD)?
>
> Good point.
>
> IIUC, mapping_max_folio_order() means "maximum supported order" not
> "the only supported order", so mapping_pmd_folio_support() just means
> "PMD order is within the supported range".
>
> Also, mapping_set_large_folios() sets the range to:
>
> mapping_set_folio_order_range(mapping, 0, MAX_PAGECACHE_ORDER);
>
> and __filemap_get_folio_mpol() treats max as a cap, then falls back dow=
n
> towards min.
>
> That said, if we want the helper name to mean "PMD order specifically i=
s
> supported", the more future-proof test would be:
>
> mapping_min_folio_order(mapping) <=3D PMD_ORDER &&
> mapping_max_folio_order(mapping) >=3D PMD_ORDER
>
> Thoughs?

Thank both for raising this up. I agree just <=3D PMD_ORDER might not cov=
er
the exact requirement here. Let me send a fixup.


Best Regards,
Yan, Zi

