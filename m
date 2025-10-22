Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990AACCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A048E0014; Wed, 22 Oct 2025 16:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC818E0002; Wed, 22 Oct 2025 16:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC41B8E0014; Wed, 22 Oct 2025 16:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C66EE8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E750160944
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:29:14 +0000 (UTC)
X-FDA: 84026889828.24.8416CB4
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013052.outbound.protection.outlook.com [40.93.201.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87E75C000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:29:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Tz14tQ2F;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761164951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSXjHM/TMmXXJmZBgJVUDzm3lFdRwIcZxTO26Jem2hU=;
	b=tap65k9/Rzb6enybEAaaaDgBnIF763yv+bS9WgSmZO08546mTksyAy+A5t2qTuJLQj8o5A
	P1hiywC4aQ0FBm32BhmO30xXgrE/1WMt9cWAwxf2VoDNfUjY5sN8M3biL9jA28nw+ylfos
	7uCiz4zzXySHYrUyIcAcrGuvATHQqAs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Tz14tQ2F;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761164951; a=rsa-sha256;
	cv=pass;
	b=PAgrOtt9fS/luVZcZSbmy79NXt5u2y3Aw8b2FTcgjZP4Ogl4xg4+2StRO6HtMRgY6zZ7Hl
	eJCdNyZJ6FPxZk50/AMiGtWLbiZyCkOWizi5hFPVdtlhi0kUKYgJ52HLlCPR4OLdA7ntp3
	gKBBgufJ8ukaiD+7WifaTN/SRkASTeI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfpMBKVS8LDyUYiAA57hR266QqYgxuDuScRdjXUB6WXQ3kbzvCVMqbTxFdjYDbmHngBn8YGt2YnLjiCoqUvPHZ0x3jQS6iP1jLTlI5tX9xDIXt79K8ki1HIHLC4/J9u+YtTiIu59XDz/9phgnqMVhBLFoalNTEY1Jr1TvuL4Rn1X45rycyoCLn14uPFC+oCRfRlvTgJktbXvlhVfQ1FkSFddHfztXZKDqTlnglEZ8vP/yvReoGVe/BKJIMVvKP/r3sfLVtB6sKIYTTKLCks1pba84UJxZgyyGpN5cmxyZ2nn5v9w8kHJPixNII/W1JgiWxYm8hZ4z46TtVAv6gmtGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSXjHM/TMmXXJmZBgJVUDzm3lFdRwIcZxTO26Jem2hU=;
 b=iwIc+yZ79npg4vnCaRa65ly6q85uugtBCnvs3UATkIO6zYJq1RBm3ijrNkzywBHrfr/pV40GV6ppJhyEe5vQrSS9U2w7aXS5MbR6JyMCsa0+eyXQa3/k/Y4IAX16dvnGE6ZJFILbf/7qcMQlwIjfGXpQv+LeFZ4WSlnNI1d3tg3Za5Yw/65I5rJf6M7fhqFvNcv126WvVuZtnYvhC5oKy4yM9a0R8q4lFRw3KcW7OYGY96TW8NjpZeB3jH/oytoEzwhpTBeYQ/8pNUtdISVCqcNE+7pzsAua+CQkCt/3ouQXeKnqAKliuvQ9X3lLgNv+ymCq4dBiXX5GQABtwwiQWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSXjHM/TMmXXJmZBgJVUDzm3lFdRwIcZxTO26Jem2hU=;
 b=Tz14tQ2FMxBQbcj4y7ZnjjHZOknZleUoGPWgeVYdVO88qqaozoNyU0dpIt9f/CSTKpW0QPDeSvj4HhN2y7ghtvamzHXb23PoGFPEbP3HeJlZPY3VYsQZLD4MjV/rVMoCnkEs49Sce6HQAtJg/KBS4dEwDc3H7WPEXnhtQNFeJ7alXMUSlPpRLcG6yEIPaTdO77lbVtJlHro06KFjkbMT8nz8maJmWECjK68LPpYIfJUSFXySb7T6rhjDkok5cfxuND0d6Wy6dAmP2pim2K/O2Ha3qeA3LfQ2UFnoK+9YG+xyhGn4xUTV81n12tQxSRlwoPQS7Uvh9xJcyP07h1CagA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6194.namprd12.prod.outlook.com (2603:10b6:a03:458::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 20:29:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 20:29:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linmiaohe@huawei.com, jane.chu@oracle.com, kernel@pankajraghav.com,
 akpm@linux-foundation.org, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3 3/4] mm/memory-failure: improve large block size folio
 handling.
Date: Wed, 22 Oct 2025 16:29:04 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <3A152581-3A99-4610-B16E-1A34A3039E55@nvidia.com>
In-Reply-To: <6279a5b3-cb00-49d0-8521-b7b9dfdee2a8@redhat.com>
References: <20251022033531.389351-1-ziy@nvidia.com>
 <20251022033531.389351-4-ziy@nvidia.com>
 <6279a5b3-cb00-49d0-8521-b7b9dfdee2a8@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0300.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 00837a4e-e1e7-4dee-22a6-08de11a9a610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0Uzz6qGVda+Vyy86GO45oO9LpvCp2HgFuvBFiaMKgb2US4R3R2Mz/UB7VUaa?=
 =?us-ascii?Q?CRPA9ATn8y+hAA1yzsI/uLcEcY1P/Pa6FGuE4rKtLn+JGRNPV9idrosMhdaS?=
 =?us-ascii?Q?KQzAlCPj7qYW6PUz2fivKJg0dJGrAQ/tobMyghb5j32OW3gqnwjbJQiqPPL4?=
 =?us-ascii?Q?/D66NEu0RceS71mfw2u0GvVnjsLVV5Jvvi4g6C9SVi02z9W75psH90aNJmtq?=
 =?us-ascii?Q?jREAF08Rf8MTWR67gbImSKWT0ZnCtb2nZHwxQ5B5ukemZcgFUZWFfZFqXODI?=
 =?us-ascii?Q?DaR3ZYyRgxa0WsvAzLDdb9vGVrhh+YFRS6SVZ7spuVp0CtJan5T+mbmdkuQZ?=
 =?us-ascii?Q?hI/NChU+09Cy8osbJhpDNQwnnLHqt2BmdG5Z2ibahPu+cgJ7ddwBWFICAqT3?=
 =?us-ascii?Q?qHuksDOQzrNiVXpN1FKkDB4+q+OeWF8qMxWGQAT6liQqbAxdgFHUOz4ma+90?=
 =?us-ascii?Q?OjWN2qISVuxNV4T8o46st2pbIanLISC0oPs2+XrjDqADD5qUqpajo/aQ7zFE?=
 =?us-ascii?Q?wPiPy86vkf2M1gmdLSKRwImJksWImREvlsi/LZ0uK6qKZlorJRqv3Y0h8mXg?=
 =?us-ascii?Q?g2FF7pVuqglTWKDlf72W4xhw+a/1MiGzPPNE6GKm8IcB+Fl25ecl8JIcEB2q?=
 =?us-ascii?Q?Yi8vb7Rc8VqD4YdjTFYc9ao6VYvd7o/rllIeHVGyt3UTZNg4zuFkzbQYLgDd?=
 =?us-ascii?Q?BOUwj3H8cB1V7cIfAwfr/0euSpnueD3sN7Xt4NIkYCNQMJQbslKI/RJshpWD?=
 =?us-ascii?Q?OBDKiPeaLCuDyiv9GK7LbQlrhanN4vPy8W6ePrGUL2/3cJdWIg5nmbTITRiQ?=
 =?us-ascii?Q?8tkODWnRBdKwWW0dsIPXVDHEQr+jiMdN4p2cS8JSEOVtCU9TDKXDrQCOUUQd?=
 =?us-ascii?Q?yBfug56tFbx9a5ZgM4y8TRRNObb4KvfALgV3m145ONGtORPQ3+WPjar9Jn15?=
 =?us-ascii?Q?brUcACNNCBSXU6XhD7Frk+NfToajxJbgsR/aVXYieAPvR67i3pcAWmPjCJ1P?=
 =?us-ascii?Q?2+rMPDsN4cSxZQpt2bSsKfzP9Y9FA9XS3E3x0p7vnXaIxOf4vCQB0sQs7eC4?=
 =?us-ascii?Q?xF9i/0+FRNVVvQtr1HbGqdgIUA44Nre9bYapB06AQdilYIrb9H01SyuLcToL?=
 =?us-ascii?Q?/PwzUr8LJgThAOLs6u10ma1pvLLPw3Ql/nIinQfSAPenXpBCKaUTPSadb48b?=
 =?us-ascii?Q?YHJN0+Chq1rziKl9pWI/wgzJ4TxuyoBI6Z5O5qClDfO/36ZBzon1IX/AsMpu?=
 =?us-ascii?Q?bcoZRCUFLW6LgNJhvSepcyShigWRqYJiLYff+ue6ti6Xf15IoeMPGLkS1xO+?=
 =?us-ascii?Q?J7kWAb+Fk+qv/CHWWxSnEJtgPYQLDZXRA9yicXH3QsZfQvm5nOe8Kb03GOll?=
 =?us-ascii?Q?oeLvX2YCNDM451wkYlUQDZNUJmxfMhzV5+pytaIQBUrugtZhXWUoY839r7mF?=
 =?us-ascii?Q?vZIxPhuhJjcHCZBNsjlokX0+HX+LlVzL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AvzXxF+esu1T9kBK4fEpdEdTYT88kjmK1Jp9HVNZTSoEudrU07f/21Om/0hd?=
 =?us-ascii?Q?W9hI5wjQ8cD7jQko9hnFeEUBfNVmG/DhOAjIHPSsYPEp5nlVDW9OkwgUhKB9?=
 =?us-ascii?Q?iDoPNqdXBF3e0zyOel1Kq1SNykvRVb9L2INWGUjCxx9/kYfl9Rjpkapyk17Q?=
 =?us-ascii?Q?c+20FLVY/8meZF7gjSBJDF9vCUOXrHDNO+KW6FLF61ujMOCiLQb7KaFfyyVH?=
 =?us-ascii?Q?fXulwiHEECc01e1gyjlLmX9TL/dd+dZa2o/hRfkKeUCBCIhrscHPjOs4E1HV?=
 =?us-ascii?Q?SXhHWd7bg8PBqQh2v844P+PicEpJmCIWeusoe2FZI+OLm0Px3JDDLABdihcy?=
 =?us-ascii?Q?OUogB7lu9FqJ4s9O27pFsABcTFCRscNqhpUK2dbRhRNeT5b6wjPWUFvCBV7T?=
 =?us-ascii?Q?HTGgxVX3oDkHkXNyNkyXyrVv0Bo/6W7af/juHQK6gDbWBDeW7U0jBrZSApLr?=
 =?us-ascii?Q?X0u+Dg2RsefW1PM/SBvvGGhIqvOAfu0BdVEllC68nrlC6IeUhbsUiBjU3rW+?=
 =?us-ascii?Q?+Qp/f2mWd6cnom4Dbb1eYBJTUFxcBl4z88CiBL3JzjPVXqKsgLHA8ZzWZo1h?=
 =?us-ascii?Q?VgJo1zMoYrL21MRkg7ISfk8oNgO5DGCAzxegjpeqIwtN2S8ESP1VbuTxfiAD?=
 =?us-ascii?Q?+1ggf3vA+gwPqiI70Tfd7X6aa9kkeJlv8cXJqf9hp6UnraFDc9LEJEkbOaq0?=
 =?us-ascii?Q?S+OweTgrvYWwrf+DB2az8efvsjMqErA6o5IRXQLU5LIPUinCbev+Qw/RA9fx?=
 =?us-ascii?Q?RNOLqoOAQ/IpEQVaUFnbO5Ay6M7/SlMTtxYzjCr1sgMIeA6+sxok2HKuZfzz?=
 =?us-ascii?Q?+vjEuosslsE8ymRRZfPwIJCSnyR3+a0I8u29KXm1bLF8gYPpFMvOIYCP45HD?=
 =?us-ascii?Q?9q24cvoM5ZA5LTLQWGHBO0sAPdMl5WqiT+Avf1Z6W9UJDJDA71shffnP5nKA?=
 =?us-ascii?Q?MGiCQCyJiQ0dyqTAJITHE8eklZlVrYbQ3GM4k64U+8j0mX8ZHR+T+n3sp8at?=
 =?us-ascii?Q?o/BNwBRXeBkenF6ofeu3TjlDzpuqlwHghnYxYFTvz5XGxPUMlzkZDy0hDm3+?=
 =?us-ascii?Q?rYylb6YGK/bUY9Rs6OnvyKNtagILFYJp1++WfPjv30jxpRvtwjHz8SUh9CBP?=
 =?us-ascii?Q?Zg2udZMdmpMPQUDJFjuoUOZqCdVSXk1JPYtJjq4M0N6865GvVm7IOxfLcFt0?=
 =?us-ascii?Q?WzXDJhIVm5aluXTm0ZGJuooexspQT1cSI447M046HSDC0loKNthQrBHheJQ4?=
 =?us-ascii?Q?4Yk/boNRzD5qcTsOHvn81m/DDlDuG0iifwUyvzlPAmwaO+8PMlRZ+69ti2UH?=
 =?us-ascii?Q?eHLX6Ijf562+4G3PuuMaiKS1uaiPVy7YuzkuoyGIPhjTMFh/KnTtKy8+29s3?=
 =?us-ascii?Q?N5bL4Y+BSXbP3+89vFwae8wsRRi6yjCbmPwKZ+mlszp3XtB62vB6F4uaVTC/?=
 =?us-ascii?Q?OcAAjInD4xvtMSviIDfktkS9EKSHWRJrUVwpW9/9R9SgBKnFt24sN1mKTCoA?=
 =?us-ascii?Q?KEGwTbNG40c19jSv8pEMcD0eJvNFb2cggJm+qAW7O5YwJv+t5TH81Q8EArYB?=
 =?us-ascii?Q?qxDgbSdpU0/M3NGp52QRZxcf85m9zUwXbqPAlC8w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00837a4e-e1e7-4dee-22a6-08de11a9a610
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 20:29:06.7988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDa5e3geIOHrNxfXRwLa+MA7GoS/0lcoVROSsu71MIeJ142Xr/g3ct2pY6lDngqF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6194
X-Rspamd-Queue-Id: 87E75C000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: h5jxonuswyz1e3nrm93t6q4pa16j78e8
X-HE-Tag: 1761164951-932422
X-HE-Meta: U2FsdGVkX19uwmDnBlXwuRhcZp/8mLK0u/ycwzvqDDVXLLD9sk1vR9G2p3yB+02XRGXfLq1H1Fktkq1eRAGnLkbBeHdzmY4A3gZdRf23B4jgukHLqaCPPu0F4in3jnVkWFlZi6CJs1AAATO1ltGZmjbqGT1RE3d/wGMNa+hpljOyTf0gEdmb78g1b5k5kyMcFFrvAboe8+zS+RkN18fcl4QTr5K0ekHxXnRff9gGKa/vVpLhYMhC/ceGiTMpHIADLqLsFlWy9CfX2THE1Y4yz0YPawfzuY5g7lNki0zJ0242rDKAiQTMVhJVLeiJ8P1ahyhv9Pqb6dWw5XmwITrKRXcgVaAzF9wEtFG5HwylsRGU5DRdXBlhDE5rh2Vdc5fkMAbX5EWEV8Hrpiw3Revpn9yo+F/5bq+z74+rveRqvSxXckBcBMIAwpFrdwiEINweb39Ycm4lJniDffywajjLCzYyQ9qod+Bw232mwOZowKRWQ92xXGvgrPik2k+EYF3FoUodwSmDfiBKcHFqHAx9DZDUs3Ovv0Z5Ig225Bgv5VGFgEgmT2lacKVMxyPB5mPV4xxnheRGP6iaR2QxaAsulDVP4/DKldK7Hye+biam4uyNAZUMp2sXBWqthSg4fMmlXBLkzO6NsI+VTr1CXN5I8posXmz/SuXgQCEnRapjSAropE/H3X2bx1ApnVrdutxXQwBAp32u6KT0k+KUEyPgbgBI0G4tA8o96hkPZNvqSr+pkmUvx0AsQpoDUTKB6lk7ewsuYoOPPJaq7HeTCZSC3XTB2igHLyYS3C5lENIkUypNlQ5+EtdYvuvyr4tBjf6ozvgSM0duuIkFgNaEUPvx2y1p2o3tq6XTrK0FfckKllfbEzmSpZJg1+i4sKS1kgWJADVTGYSboLTc/dWRkkDhEJyTh1ZDl3oaOV2JD0K1rWxQXwlD1YamU/JZtbX+4zW8is9lXxsXzTtHv7GQNSn
 3E4FuwEK
 krMM10w4A1h/p5MLLj6/Q3jveMg/Kbnvb4vpUlSeLxFN9kJoZ/QKV8KTDhBrSVYiRl8nKRAnUAVQkIrktFnLBpxnYTOkvfYM7YqT8g/1rz8m2PTYwEeJ0goKTmrD/FBynreZlMtTUKbHfQJ14qZBiwy0I8vBelDblf+tw6ReclP1ut+yxZa+DUBFSUTOSPNjJAdzTEN0Fw6QZNKNW/7UMJWoPLXaObkVg/ChNSwwMzIa2BZmhr9n9+zpEgor0Z7m7+vSbEfP0fMS82/KiJyoPGX3X5L7EH9DplGsFWefjWYlFP262ILuR45HcFsaWrpmH38Nu5PJEePpKZ8BGtBUtyTnXEByUE5BPOcIH2kTHb5uTbl9dKOIaQi1OPw01PvbMnGqgGLIOIkjRktq665c6xBPdpg0QKyxaiTxxGgTd9F8biOfvfgDWTPnxRvn1YdTEyinyqz2Z0H/SQIk6k8lh5yAZ0sUK5S2t/bgEGrJAaijQXWRP1iBaDGhbdwdSzY7fx1alpjiGaqAW3RtvVcOvBCLEVxC5L9KmxREgskq5iw3t4MQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Oct 2025, at 16:17, David Hildenbrand wrote:

> On 22.10.25 05:35, Zi Yan wrote:
>
> Subject: I'd drop the trailing "."
>
>> Large block size (LBS) folios cannot be split to order-0 folios but
>> min_order_for_folio(). Current split fails directly, but that is not
>> optimal. Split the folio to min_order_for_folio(), so that, after spli=
t,
>> only the folio containing the poisoned page becomes unusable instead.
>>
>> For soft offline, do not split the large folio if its min_order_for_fo=
lio()
>> is not 0. Since the folio is still accessible from userspace and prema=
ture
>> split might lead to potential performance loss.
>>
>> Suggested-by: Jane Chu <jane.chu@oracle.com>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> This is not a fix, correct? Because the fix for the issue we saw was se=
nt out separately.

No. It is just an optimization.

>
>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>> ---
>>   mm/memory-failure.c | 30 ++++++++++++++++++++++++++----
>>   1 file changed, 26 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index f698df156bf8..40687b7aa8be 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long p=
fn, struct page *p,
>>    * there is still more to do, hence the page refcount we took earlie=
r
>>    * is still needed.
>>    */
>> -static int try_to_split_thp_page(struct page *page, bool release)
>> +static int try_to_split_thp_page(struct page *page, unsigned int new_=
order,
>> +		bool release)
>>   {
>>   	int ret;
>>    	lock_page(page);
>> -	ret =3D split_huge_page(page);
>> +	ret =3D split_huge_page_to_order(page, new_order);
>>   	unlock_page(page);
>>    	if (ret && release)
>> @@ -2280,6 +2281,9 @@ int memory_failure(unsigned long pfn, int flags)=

>>   	folio_unlock(folio);
>>    	if (folio_test_large(folio)) {
>> +		int new_order =3D min_order_for_split(folio);
>
> could be const

Sure.
>
>> +		int err;
>> +
>>   		/*
>>   		 * The flag must be set after the refcount is bumped
>>   		 * otherwise it may race with THP split.
>> @@ -2294,7 +2298,15 @@ int memory_failure(unsigned long pfn, int flags=
)
>>   		 * page is a valid handlable page.
>>   		 */
>>   		folio_set_has_hwpoisoned(folio);
>> -		if (try_to_split_thp_page(p, false) < 0) {
>> +		err =3D try_to_split_thp_page(p, new_order, /* release=3D */ false)=
;
>> +		/*
>> +		 * If the folio cannot be split to order-0, kill the process,
>> +		 * but split the folio anyway to minimize the amount of unusable
>> +		 * pages.
>
> You could briefly explain here that the remainder of memory failure han=
dling code cannot deal with large folios, which is why we treat it just l=
ike failed split.

Sure. Will add.


--
Best Regards,
Yan, Zi

