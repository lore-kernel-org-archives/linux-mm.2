Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D92C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FEB6B00C9; Mon, 21 Sep 2026 11:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08076B00CC; Mon, 21 Sep 2026 11:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8216B00CD; Mon, 21 Sep 2026 11:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6456B00C9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:31:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3958A508E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:31:05 +0000 (UTC)
X-FDA: 85238157690.19.FFBDACC
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011003.outbound.protection.outlook.com [52.101.52.3])
	by imf03.hostedemail.com (Postfix) with ESMTP id EAFC52000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:31:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pR0kZgoc;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZflvH9+x2U1qkKUD5MJHwa3+VJYyoWdC9wzpixpduCs=;
	b=FpBGZ+jvy+caMgj0q9UWf+3H9n7iG6vPk8QdoPLVDItNXOtbL0ZzONtOHV9M0ODl4eE25d
	DAelBPKY4CdVubdJ2AILheCr+NdJi8u35lUArCKffeRU8eCkU1j1V/B4rvAFLtWORVFtfb
	q7JR1In2SKCpLwqLKcbOSFlkYILh6Mk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790004663;
	b=wv1nRsF6UTeWQN/bYfHtvZKMWi7+4wBzgM5RnbxdDcFEsTceDPCPlbsVUtmlMQaRi6QiEP
	BCNrIiRr0y8pOlYo7yhUlLgeJ0NaQYfVH4q3FEuyCouiapX/kKlODDHlTDEKy6aRsLX5hv
	a4qZJjxn74O1rKzhEzQZhB9B0G2INMg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pR0kZgoc;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N7tcC7EnBF02fFU4AqakhW4YyAeqNacMTQD99gAP+IGeRFC4AXPTcBUDMY8fbe07ZLimi1V/UTW3VX5Gvk3NWBrIVP0uAVNOR5fUJkvsO5oDfGpyG8rnwsVMfSmopGb5m5MoNaiwitXhmt1LQrz5jE1dCVnMfx3YCCVMHOCfreUDwKsnMVMmT52pmpLdxpSNXs999JIqG1zrc8kSl7NBITqPlJSai5zA6jlpNiNTY4kJuVb4vTUzQzoqmcomXyuKyBIp7uz9JNBlMNh13RuTBFNsfNXoaBywOh7G87C4ChSxjzM6Kko7Rnsm5TLGefl9Y01FfCdFk1joZmklOBSZlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZflvH9+x2U1qkKUD5MJHwa3+VJYyoWdC9wzpixpduCs=;
 b=b8l0Ji0p4D8LfzckWZwUaZomXKGua4TSONIYtcr3bJWx2uGfwLeTdBhjFSevUSxowoMDHrEbbDtwU43gSSGH6E0hqLehDH0UdA4dpsi9EcjqeXILfgzoLg7egV11JAfdF0zIXuk0MeFsPUVCrAyf2zRT3TsV4HweqHg2Aj6D2bK/l7390dmoj3XN/p+GA0YOJONyD6c7DnP2VMqn+m76Tyh6lC8fspYldR3RZotr3736wMYDjXP2N6NxKSbG+A6WqDRaDy6EfTMQKekVVKuMGyOGtuutjNlj+UEKDsWXSqPgH7LjujSJoEX6KaAYERmq7EJZ2wUKDVvVsAnPgLFMIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZflvH9+x2U1qkKUD5MJHwa3+VJYyoWdC9wzpixpduCs=;
 b=pR0kZgocWHMaavnixzn0+SBX+EOlkFudxUFCifc+EGskqcpXYU2iVIQ3dTcDTgszYflIuEMSS6ZcJPvdtU/RcLc/kULr5n+XmnIipU5/uw4Dl7BrfKTsZXSSA97uJn0/fv+n/JeUP9OgfN4ZqVV8PRxOUDLhNvrTOp3RpzZ0bvrE09uuNBZG1Pr6xm4Yb0xhgWcrx6HewhmlJXoCl7Up0SJGsVpbSgO3f0lnw1QGR99ulFnANHFOvY7U4xGUK2NZQz7E8JgOozNkGrV7prJuepXMRo6kfPdRP36zJJpk8/qTxH+pngEMbxiBodNpjQm8zmRKHfEuyPTCUPqY0YDtvw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH9PR12MB995114.namprd12.prod.outlook.com (2603:10b6:510:426::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 15:30:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 15:30:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: disallow raw PFN mappings of huge/shared
 zeropage
Date: Mon, 21 Sep 2026 11:30:56 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <FD82BF38-AC83-402F-97DA-F14B5171AFE1@nvidia.com>
In-Reply-To: <20260921054225.28537-1-lance.yang@linux.dev>
References: <20260921054225.28537-1-lance.yang@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:208:329::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH9PR12MB995114:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d5e255-9407-4a61-eba1-08df17f5556c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|11063799006|18002099003|22082099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	/mXc5F1nlPmZGpcDSCv2HK7hXQJplIkUY9ot6igbiUcEXfc34GOYiGpOV54L6yMSYjglxBZNe1Xr6644EJk/gwmWusJenzRRvZx/3fSoNA4ErU+P6S0og/8cnoo8zX9EpRAnEndORCoLZvkIYS3BObESu5qVskC7bwT/dp6jl5e5quIHeSRmxljUa7lkTqXkuINinTrZQYIUN0NgO8uE7hZZYKYmav1MuOLfF17kyKGsbMZtQfQPEyCqemOXMzDs9DRd38DHz4Gu/OEgjldpj7RdLDAvGMc2Xl129JZN/0kMOaR42mEZK9oN9gUrsCi/Mqf2lyKy/iFKuqKSgXsFyVryd3/oyXc6r9e2Ri40WXhjWkFgaouN+/7cdY+pGsAxzsar8SyIIB4Ch0NbVGk9W2RTElwTmo7AewHrhYKZi58gU82bTkq5vqjJjYVpiGVFYneynPFpe4B//4wQ+LdygZojplxsPu0+2f7iNyocT9vCx25wtAgZVilmZKIq1liCbpU6I/JOlASPjw5mslPSxHcH5NxSVXA+fokiMXC75j4MZUAUpKX0/4guxc1MXJfpxZycSRG2YP3SsDmnxijWmq8aigjdSChvbW1b+RPol/X3TUB30RysByx273pLPE/LHBLRWW2L2/z31et8M0LJK6tBP3Xj/KvDyzlmFrsYPoo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lFFNshj2xv5Xyv+kbduf44sLOEBpxQY8GkTER+3xHIQCbbrIxwjQl/xnwOsV?=
 =?us-ascii?Q?/20F6IRr+nC47KTjldrU+9VRatWNWqW4q17GTiStc4K0Wm5ewc/myAfJ/uYK?=
 =?us-ascii?Q?UQI90op1kEY3mYFEan9MOixhzMAd1pD0Mx0DH0lyhlwbEYGfsalqzBFInmdg?=
 =?us-ascii?Q?915Akx+7sVz847g6ssuUnNDwpyS26dYKoIscEMQskU1196vY+yEAdyVqvw9c?=
 =?us-ascii?Q?V/k/yQnTPh+NbBQ8ULr6XBfMpqCBh1J2VNy+lgG4Y7AzgIVnKWh5Ok0H406t?=
 =?us-ascii?Q?Eg7vkHGt60sVWesbew4cMLCb/4Ax5EVCQcmggpNBYtyQOBxd+Wc0o07NxtMa?=
 =?us-ascii?Q?7awRRqEk+Qv3KNYF6C0CHzIU5PpXiWcp7GyVeZAD7tM4t2rx/RKALeBAOBcT?=
 =?us-ascii?Q?nbwcHXwYbBCDP9Al6XbPQ8JPCw8KpUswCcp0vEKyk1iMpk3WSpdhU5JW7bTZ?=
 =?us-ascii?Q?e8Ofhiv563xceXMjY8jfk8YgQxy4Kws3ptjiJdhp49eQK3AwjtJq4nORTTIt?=
 =?us-ascii?Q?ot/qFeIKKVhqloZhPurgf9xOK30hKsvARH35C7K8yaex60j3NcP1Tk6wwt9j?=
 =?us-ascii?Q?9TYvhc9tLlKpCTjcsyrP8UpKbPl+HmDtu6FlID+JjS9x0kg1hpwhCqEe+z0S?=
 =?us-ascii?Q?RK/auLZAIYlub5NtCUGbs64rBLAs9lAM10GijsDDpBKTW6+gy3wv/srEBv8v?=
 =?us-ascii?Q?fPxQyCGUjs+p4id0MoMcrV3BJ54rfoCodQdn8f/wsmm69F/YiICtkGCiE8za?=
 =?us-ascii?Q?oteg2/3050GGQ1uZTsQ5yPOgJ7N5eeJ0wjkmpXL0ZtUSuLKqdHki636+Xwbk?=
 =?us-ascii?Q?LIFO0d91iOkHF+r7EyCvhD04rcGvTyoWNp7FX0fE2A3NfVBH0PVWJ8RD92Z4?=
 =?us-ascii?Q?/JUfxhizrp0j1K2C/+G1NyLcR1FvrJgpL4TEkYG2OCuK5kst/9x6yKTeEk+D?=
 =?us-ascii?Q?yLqVazkp4TrSH4pkaKJGTHKektHhOJMImhkqnvrbhGmmYh8hwsy/vMV6YaXl?=
 =?us-ascii?Q?kJNidPGJVC8WS0STRUZfj849nAk2JQemnOv14MwIEIu3mdeDtOq8WJABMr77?=
 =?us-ascii?Q?BjYkOasWAjf8c3ZbI+TQl6zpFYBMifHclMYYr8jhlyl8+jrqCj5j8PIfziZu?=
 =?us-ascii?Q?HB0Vobg2r7TzZaNDDO5f07I8G5/A5/X3BsRLMaDLq0+3pIDMttBWZgXoZHXH?=
 =?us-ascii?Q?jrmakEERE9FX7O6YgEmkiBUickjMKdqhIh3lWGSsiCDYm8S8L8YscFfNilsG?=
 =?us-ascii?Q?qbZJ4ubn5qgc09jnCaFkaER1dcItF9Snfre2etR4+Eg2awkVWK2M+rittnsn?=
 =?us-ascii?Q?3CPtP5OT+dONIDaGbKm9LuFvHLhLpALMFEl0o9pBT99HTrkQRpE2DAf6p+U1?=
 =?us-ascii?Q?bBPKudoLnKOzz3HBZQDsw1IJ1pu8yTCSJ7ukAkAiK33KngBR/kunq+t+ZYcc?=
 =?us-ascii?Q?k5w0kyV6B9gPDs78L8CaBSURVbe6PlQtopDYP7xnf/1ieUEufxAOas/faGd6?=
 =?us-ascii?Q?iYYlT608sSHuImCf8tPKSiZdXefe60Bv5JXuD5fCKQ7GUXF5JTWewZlWk/YS?=
 =?us-ascii?Q?W9vg5QGU6UJM7t+Vr072OX5lUCv9rvLbSulDag/WLcSWG37wKX/Xm4m5pBvj?=
 =?us-ascii?Q?oFFPH1+ggk0d/q2dTYKuR7lSbcqmCG/lZdAqHrX1uDBwGubRA3/R3eG3DIsq?=
 =?us-ascii?Q?oLkmQ3JMiHxsiK766ESE9XuDBFQKv/yLeWqmwQ3f3HvqpBs/6LGj0Z5PrZKN?=
 =?us-ascii?Q?BvmTUbD+qA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d5e255-9407-4a61-eba1-08df17f5556c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 15:30:57.8620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNbJNNLYzeR6PYksvfdTUD0YYGqIMznXMoAMXu47ObHHmKIxhXrWYx0plPO/aqXi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR12MB995114
X-Stat-Signature: 53pxxzq5twog1obq1qngurp4uq3codbu
X-Rspam-User: 
X-Rspamd-Queue-Id: EAFC52000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1790004662-670528
X-HE-Meta: U2FsdGVkX18LyXvPoeexV/AKH+7tV0GzComKrCagaXxLL3qSPcs3B63mTsAVAIAhyy8sBTvtXvRdJSXhY1Z96QJ4fs15Cw3cnx+7bbsHE+LB+2yDzGcxv0pWlTW1DpNcLZIkrvcMJ3m+EM2zxuS7yNlBcB9YagI2wZDCj/iovoPlzlK3AZozglfb6K4GOGODLyYxnlE5XAknoy5Flm5THqnyr1XhotEOgbDZGX+NktjFrN1Ssm53b7p1pK36TvQa4ELf8ABrzlZACbb6uBm9AD9/4hrCXI4GOutQo8GRlH8pc/4tbOJhtlq4X3v9N/4qStmrurICCaVh68gaqXmu/PRBxtqectKL92b6paEY1YhP9zPUZGGv87k+46iWM8Z54NuUaf3mg+tIVbMofYBfOUwZ9CTlqskgF4q8tlTFKvjm2+kVmqf3+q5ZPNEOi2RvVNIY2kigdBqg61dPiwNb3x4LJ2jVok+v6e6vkuiVVEXen6dujOLnEb/otvRd1xXEE2PE/bYG6u7scxELhOwen9OmxnaEFr9+sFnZpzwcb8YUGpHAEP8k/OA0G0fP6REq2pI4u9xIpEqQ6i9eCnP0zOlvSEuT/EM5ncxy7GygptjBOz7pj1IHH5ukn7q92fMt+GPSFoclXSYHiQX6zzWvw9udk0WsE8E1kOK0sFg/J1zXJxEjdVuFbLQjHecvDuYsF2ycdAnxjCu6raxhKEZrEDRNORSvoVLPlQADKGkDWDVY28pYGozGV2re+KHfjCgnYPoTGgvBT8noaoYmj3usmw1JtLWePKMqyptdxfz6inODUCrwF/AYtcCCKD8odncGqlQmW1yNYtAKMbIccgD7gzzDdMTRwFcea06r6/QoQ6Rbhcf7E9xL0M0pcABk/rZdPhEcSZzDtXiA5rONhv+VODZb28PwI81hieZV+Oqxin4DENCwIO7w+zcDrUKUhTLygbmhL7OJZ8NelmeKelo
 FMWGVqRp
 3A6K2AH9eYS0HKw/d72X73ymH0vjgkOdeIvXu+YgZjI6CDQshUU26BU8YLdZUwtstWjMM/1BGWw4zEiDBK5JLz7Xz1WHBjHjGXrzRAHgLoBzf/zFRfQXDnmnSzhT2WtemUYui7qr/Ai18BBuvZp2ctQrpoYDAH1eV/K6foprQafW333Tpqd1KSA3SbFStGEbo5ejsmMt8un+V74Lu4slAdsJpZiI0fd3sF5LquVUva2OBQW1MjzxwBUEMiZsN3FoPdLOa00A8dAZZbEi4Ruz/1Qunp2Qf6cnwbBoqZzApV1hXZm6asM7gPVopKlBWGnP/G7G6bOv8jTnVuqCJeN9+/uqt2JD9yEZdpT2WFBnQP0MX+ZnrLLlrop7RAnxwz/j50zLbRQxyrMyqcmi7IelLVV5irNDIQEZo2ofb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Sep 2026, at 1:42, Lance Yang wrote:

> From: Lance Yang <lance.yang@linux.dev>
>
> Handling the huge/shared zeropage correctly in vmf_insert_pfn_pmd() and
> vmf_insert_pfn_prot() is more involved. We would need to check whether the
> VMA allows it and keep the mapping read-only, similar to the checks in
> vm_mixed_ok().
>
> No in-tree user needs that support, so reject these mappings with
> VM_FAULT_SIGBUS rather than complicate the code for now.
>
> Link: https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v1 -> v2:
>  - Reject the shared zeropage in vmf_insert_pfn_prot() (per Kiryl) - thanks!
>  - Explain the VMA validation and read-only requirements (per David) - thanks!
>  - Pick up Kiryl's Reviewed-by tag.
>  - https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
>
>  mm/huge_memory.c | 3 +++
>  mm/memory.c      | 3 +++
>  2 files changed, 6 insertions(+)
>
Makes sense to me.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

