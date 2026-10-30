Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AE7606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=klzhDZVr
Received: by kanga.kvack.org (Postfix)
	id 3AE816B00EF; Thu, 29 Oct 2026 22:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386466B05B1; Thu, 29 Oct 2026 22:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E986B05BA; Thu, 29 Oct 2026 22:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9F3C6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:14:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E88A31605B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:14:58 +0000 (UTC)
X-FDA: 85377674676.18.CBFEA06
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010061.outbound.protection.outlook.com [40.93.198.61])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1EA0640003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:14:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=klzhDZVr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793326496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwalU9KoKC4ZBaGClYnM49I4RLKqn6c1U5K/O5xUFgM=;
	b=Q6YLcorabKatQg9J5FfrpiVC2q0DSn2p5N7jRTCCUYEmz2yIPtFYFl1R2YSioTCrMfNFLd
	AGlhuYZoZoQQqWe0OKNdzq3xXqRFJcLV+oMmMLhP2/SngIHlcO78MUfrmXF66bkPiNmLWW
	v+hZhblBP45u0yCHztTL/asmXOn/I9w=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=klzhDZVr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793326496;
	b=FEkts7teGgnZHYFp/nFG0psms7TNGIbSZWgcx9IpNiv+V4QqSMxegkcUVLa27AvVrdTOoP
	uMrZVeMU5G8KTW9PsnQC3py34C7L1i7LKt/I/YAd11wn74rbuu18isT4qFhW2yLbHxY76Z
	v6+olHD9bAv3BMYrigKzcPyf2ezoaxs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F2AmC0HndNGvl5X8n44Stu9WuTZcXmDaI34Rg898398C6KcofgJXcHkRdJjZcaaTq/YWKNa5led9t4aKdnp/EwZfCu5QDjvo1ZtOz0d6qU13ibWs88RlEWmaqRcFi6aJDq8KokSELWT4enl45dPcHEgN+kiLquo+fwWxmA6NEshJ8b57edMkNVHNSdAm/7fpUlZfpoUwl/LrCQ+hWPY2k8qUzcWpvrq4Ln6jtLDB9NWRxkMkr1TqaMrEFY8f9HJSAfP46sKfP3CdWAAand6FsYCCyqALKtknCnqLbV/TpXumuGvngd8Bh2pjbMDKIfQLi00FXxPn+MaxmuuJzjNpvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwalU9KoKC4ZBaGClYnM49I4RLKqn6c1U5K/O5xUFgM=;
 b=VSVx5cySfNMRIZ/J+KaWbBwn/aMK2HZOzKQRs5V5i1FWqxop6kJjI4IB7KtIZAH3iaUiR+jA0Cdt9+RHU+H6xifl/j5G5YrRc2GQAueO/6qqJAIF58Uz+6fOj27GFIi2eA3JbF7758oADWEY+RJUK5zAGvgThGAnUaMgC7mxzRZtws4K5489uo8GyGhIT/Lnb7keIfZo0hwu0h8XfvKfELYyCcKnPsvY1Wv6OquQPvky52zVmHnkjdbCtOAscqQ+EzJ3nv5cShjq7apQSZlS5lSwOlURiw1E2sLZzUFMgPsHFpkORGmVXwJuXWrFn9jpr9R8vFrxOcZMTlqsUjmfvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwalU9KoKC4ZBaGClYnM49I4RLKqn6c1U5K/O5xUFgM=;
 b=klzhDZVrKhiZx1J6jDSHtORKusdtSAUgP7AlhiwlftdXXJmkNuXtghnm8BYSjMQnTx1g3jUg4EoO7sRch5pSB7ukQnsM01JBe4eHSJ5lRpagHR6YiIzVyrS214k9m6nyfK/x4GU4fPYImtrVgrmy65DL949WQKBqsK6UNXB9YjkS1IbkEFHDfqbpse/cuEGVJjfOuiEBI7MusmRqzIrjdNcjdqZbqb7ApJS2qAFB271X4iQo9i53qGozolHMryRZw2tR8O5Cpcw+EG1ZkkE1O0nsSDbCy+brnKKKM2Hplvz0JuvSUxKnzUfEideclo81Lt6dVZig3EOO4eqM/RToVw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB6014.namprd12.prod.outlook.com (2603:10b6:408:170::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Fri, 30 Oct
 2026 02:14:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.007; Fri, 30 Oct 2026
 02:14:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v3 1/2] selftests/mm: track the modules run_vmtests.sh
 loads
Date: Thu, 29 Oct 2026 22:14:47 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <F4BF41F0-3148-41E2-862F-DA83D9B5BA42@nvidia.com>
In-Reply-To:
 <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-1-16ad772850ee@gmail.com>
References:
 <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com>
 <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-1-16ad772850ee@gmail.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CY5PR15CA0174.namprd15.prod.outlook.com
 (2603:10b6:930:81::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 860a529f-d110-4f19-fa0d-08df362b94e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|6133799003|22082099003|56012099006|11063799006|4143699003|261026140227099003|261022075727099003|261026121527099003|261021123027099003|10067099003|261021121427099003|261009223027099003|261028144727099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	ZIGIyTI26F91j399LPnIwYL3cJBV/CNuTptT9DD65vh9nXfAlP2irj4P5Xp036BH6LP9SokweH+fI8v4fz2J2aT2zDRWFHB3a/QU5eeCenllm2YPmdsYqSFeHc5Lpt9XpodjhciTtaVvHYqOyTcb8aSBvIlcK7HQullK5NN6LIocDnGW1w5lOgDcjClYRZxeGM3THQL7LVASNKynLg9q2e7WlowjKRkWf75fv+0ocSoksN6kcZaP//c7U/qgC5DVgcxCOFSlyePufa1BfRiOvLeiuqJRfh/L2UJ/FAkowKTuCa7OJmhLeVGAz+OI73GYiOVTBxx8CBt/144aJTXRZUP7ShuFU+hxiCtQSWuprjkbByY8RpJc7Xnce1XMWcTR/Uh7oyg9Hvq0YWxeoxC2Ol7fSpt6GpOVpBbRzmNbjgby4X/aD9VmBs4KRu2MbGDsa9j97dymv6M5I40Pr6y1RDDe0bXZvrG8RERfEyVYrJpBryhWCzLwdlNF/H8AiPGb+nuGENNzkXmp7+ntIdgnBpWqQmRfgQjlyE/XNs/nuJzG2cM+YjIUCdklHfdvAQAxZpTMSlB8g+VLs7DA0rvx5OJYx9c4EwGeEhDFFqlXLKjwtV9kklR3taxM7SqllJzC+EPEw/SVQLRaMCFrPC3M9WjqOy4IXBxyuzvv3plHQtI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(6133799003)(22082099003)(56012099006)(11063799006)(4143699003)(261026140227099003)(261022075727099003)(261026121527099003)(261021123027099003)(10067099003)(261021121427099003)(261009223027099003)(261028144727099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wj2b5T+L5P/bfq/tgubAdumE5ePn3RVC7179GrwBRNUHF35rAda0YwVkKiu2?=
 =?us-ascii?Q?Jhs8LFgObiwieUdFXc+XJ2fSevXWkMFGiGNwZTtJ+ns+ADprhF42SnikoIki?=
 =?us-ascii?Q?1t0I9tJSTFy6pWunejpKReFBcgj2hWUf223rH8khzym+uRNzxiV6wfy58peA?=
 =?us-ascii?Q?kGNidTLGSUug7GNyuLiViygzcRJW+yyOocwIN/u1bjUXDNX7Z2VMPzo8XF3G?=
 =?us-ascii?Q?qBW6NQF04n/aKkSgAG4FFRX0piTJvIJAyOda+Lt6CbtSF0ApvzTUC4LFaE9Z?=
 =?us-ascii?Q?fr7et81KzHLHGd1JjPSKhBVnQNhIZw9Cx4H+gf+yAoDGWtyv/vsDRfH72aKE?=
 =?us-ascii?Q?WdkvLbLtBPyhWSEYlcX+CjDWTpaRSX8glJR+JEW1Icg5BM9ZmY4Jc18hiZcP?=
 =?us-ascii?Q?kc8DPT83P/zgRTjHPXJMBsMwwVI+EJRmMNnmNCoL33kCNtEA0VDh6MswnKyw?=
 =?us-ascii?Q?iyokDe+3ZmSLTv3TttmS+mQDpzGnrHHdqu9Ns9Ulf/LcXhpMW50v4u47iw2x?=
 =?us-ascii?Q?SKEpbfpQJv5RhjrpEmYKGUVOw9T6BFPDKq/hQq7Pak0mDazkgcL2LUnzfpoD?=
 =?us-ascii?Q?jBoIbKrMX/g90SmrSXJxOXwUWCYkcasE1du+yaVORbOUaZGV/lemR3NbHDiS?=
 =?us-ascii?Q?DTGG3ibSIW8rBjDBq/UkPfS9pDIYZJZ6pWuwNij76DDUKsNsctYmyqSxXQnO?=
 =?us-ascii?Q?qN5NXbtwohpW8ckmM+Deb3/IGStRBGouQOOk/Otb9hV/QWDMIpvCvwQuZYL2?=
 =?us-ascii?Q?pWoa4111GO9oP4LhPwgp6GKsZk1VHwE0TxJVUmLxdYkTTpkihGJa6qgMviNj?=
 =?us-ascii?Q?6C+swgGpcE5H7PB0qggVpovq3X9bA3wA7Aq5E9LvQcR6SjJeyRBSj7FJP3GQ?=
 =?us-ascii?Q?Ryc4wc3W3vwTsbpVJzrLWaIwYF+Yu5y3EGYHWof1CaAYlJah8XsGu2fifgb8?=
 =?us-ascii?Q?cv8OR9rPzj3wCL/l20N6xkhximQBNVEGBnYApHmfFwBEKR9hoXZP5BaiOXrS?=
 =?us-ascii?Q?ZoVMVD/lyIArVAgK0wf4Zw1KB6xjUK/v2tWq/0RBtLxFJqLNPrq3KNkggneC?=
 =?us-ascii?Q?DHVEK2kH7LAP2UZjR9DCKRUg85zLnTyuv68y+7ZF7TNTd5lbLDDiEeI5JvHV?=
 =?us-ascii?Q?fMWtuOrKwww04vHXB2tgmCOFKWV6/1X3aljzXtjR+PM1YWcCR6vWS4QZGhTc?=
 =?us-ascii?Q?xXC1NxcNONnY+20/Jltj+HeuHa/SyCl2YxEMAWups+N6seJcgekeULMgtM8d?=
 =?us-ascii?Q?bJEQDowjxa2PMPM2oQuYTvpQGVtnWlDHYK/b2QjOYYetu4O6s+HZRux1HROE?=
 =?us-ascii?Q?7kknZRcYW9kzACYDAko0dZJYb2DPA0JJHgfDLY2gbXO0dmA9Em3z3V62UHhM?=
 =?us-ascii?Q?XhsG9YgFCcKIa52/kn3f8x+xxrMvkbMfFUVGB4TQPHXyLe7VG4R90E9vYKIR?=
 =?us-ascii?Q?kZ85YH6cDA3CNYbBVVxZsP1t8Ze4m1qKTZrSbH6ujc9C84wJhlnWRXR8X1bb?=
 =?us-ascii?Q?t7HJCU77KwPV2i4AI3sTFUw/l5kWspGrJ5hVCijxL3RYTTiTWj4mY/xy5gRd?=
 =?us-ascii?Q?yIPFNYLI/lGudeNXY29s4V4r3FRVC1tbQ8kw5Ltad1rZuxT3e2da3C4OMiWj?=
 =?us-ascii?Q?hLTs2+Jpod9Uc8XB21mZl3sYkngdzKDy0aNo3Cr33vndHo/K/34cu5zPLa1S?=
 =?us-ascii?Q?2sRLHUiqtHoOSPCy9B7mXXkYv5Kn8/OyaVuVlrq+HRc4INXS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860a529f-d110-4f19-fa0d-08df362b94e2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 02:14:52.0369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kPUvQCnkVPpOWHb133AeUVLlBxlMUIP5vgTPt2RQfKf2x5FT0oPh12E9i6dlbUeK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6014
X-Rspamd-Queue-Id: 1EA0640003
X-Stat-Signature: fgm1syojx6n6a8c8fcu4unz4fr3n6y74
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793326496-192667
X-HE-Meta: U2FsdGVkX1/8QE+vL4OhPq2VZXXwYi0rIIZNgUGGLt1QzXhYvrIYaGl0NILhwJXYAXW9S3jomS0afya6teSHspcrcM7MK03PGDcZz1rnYBPn+M9C4Iem4iqihM1WsOmstczNtHJL7rlTfiO1bMIGTDpqI4nvFw/a61MJ3X2GyfR/ZB9EL0pOP5XJ64vUu1cIrfeMOh369Pp2k3Kxqodb8YVuzDWqm+1HlB69F5PIFE9uFe4UlUzKwex9CTlqJ1bmEYG9DyH3unJlpNpJyU7GbDU3xBxtkcLNb0T8Csujzy8V4Aaj8q0Bd/fYchE7f8eND3Nswabr6+h9DBdJoUErpk+A5WXC7CwDUg2PLA3/+DMN0p+QukqEhYPSXrgjYP0XCKY2008iIqgNM8mtLl60b7cT2D38FiRIeN4tU29Pv0pidTBHapOUuqFLVl2kR7nSF4NmYhQF0p4f212J20SDtE5p1nbyb7af6TL9DtMftQ2oQVbpcJ1Iqr6of0NqTQaoSHIiZC9x4StjgdXSxAQmyN4QyYrdOe819IqWdMl6zmbuFsR2iT0A/VDf3ebUWjNqeReQzJfOZ7E/xsSmF+Q71mgBWNagHYUUWj8iZqgcbaK2cFLLIsbkgbyEdhObgmG7WBzQNpVIY0qS6IT0lh9k9bfkWYz0WoA3wGu9PGSQIhDsv5mCRR1a7eAU60l+LDNgyOcMgGgADsNKmwe1DBXCOYVz12ZPVzXT/cPZaUE2yCGriTo5A+TQjtadfKIjTnsJ2PvcDwGe0FsLF+TcaevPQ1fpyvf9woBzu55nBVpJJTWIiZzS5zZaHshEPx6GrGjltBIbAsjlN4FRdhKkqyfvnUBDKTTHWUeb+vDCSLK3IMQTbRbhGAKcGTcIk2oy//j0rJ/AqTBNAkKegiTgJTW0IbMY84NgkholH/EZOxfEbF712dEVeqGPascp2ht5CESb3BOjKdAKB6b9lfrWBUj
 awXOJnsH
 z5fYyT+2gri3sAmUeJmDAjZb8kANz9fnb2SnQVTXfVqVxCVPuesOE8CyFBQsSiYUqkgGJqZeARVwhIO9rJYCmvfWKy+kYloPpnySgtbD+1IKXOvFTt6nN550ULRbGFhatnHq7gknsAXEonWbt0o3L+/w42VE0y3QCup597IqR1QD7B2LpmTK8ijJ0nKD3qGL3t04mG1XBlAwyHHGfBbsmtyZqmbJBfNhBYs8zelhP/pxjsbQkGHsPkZpTWcnUJoduUIOIMnuquKQjmvMvpA9xsypgtruT2l3XqKRZDMHTdTH+AkCDEhGmua1EVot2rE+zjTkXAWDCvIjhEddeqxjA+C6Q8oQpmd1hvHoYKF3RAktQqhZCt0UbP3ymDUTWfuNNieKJBc/MNtcOScnO6rsd6MB5S8BcCeouoIkOhFUFrMPIwPUkJAMvTOaWpemvYyT5q9OH/nkSgiPA9n9kOSQpzXj1kPevEVsoLceEwgybX9e9AZDfewuslrjtHvGkv9ffKlm0eshny/D09/ArYHhgQiQe0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 29 Oct 2026, at 2:24, Qiliang Yuan wrote:

> run_vmtests.sh loads hwpoison_inject for the memory-failure test when it
> is not there yet, remembers that in a variable local to run_test() and
> unloads the module right after the test.
>
> The thp tests need xfs loaded in the same way, and repeating the load,
> the bookkeeping and the unload for every module that some test needs
> does not scale.
>
> Add load_module(), which loads a module unless it is already present
> and records it, and unload every recorded module, in reverse order,
> before the script exits. Use it for hwpoison_inject.
>
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
>
Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

