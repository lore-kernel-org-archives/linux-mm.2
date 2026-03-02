Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C35CC624C6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003486B0099; Mon,  2 Mar 2026 11:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF896B009B; Mon,  2 Mar 2026 11:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0FA6B009D; Mon,  2 Mar 2026 11:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C88986B0099
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:34:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D4111A0235
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:34:52 +0000 (UTC)
X-FDA: 84501672024.11.1A8F473
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	by imf08.hostedemail.com (Postfix) with ESMTP id 920C4160017
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:34:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="R/D5KoTB";
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772469289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wgpbH+wIz/e9LGhulaqNm5Bs1d1MFlXbk+bpqAczfA=;
	b=vV+PxNDr56ASQYJ0ad/gA8qnHpwo/MvZFBkOtgwA5lk3nDDLfbIVvmXJq2qmPTeJ5eh50d
	JyStSmC7wZbNT+4JUvWzGxHKXBPREPCdoNpd9RXi4bXkYtvIM8VxRrCP0ACGzFBw9fY8Ej
	bAlF0d2BbfqyayQcqaqbaecapOTNL40=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="R/D5KoTB";
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772469289; a=rsa-sha256;
	cv=pass;
	b=up13VCRWtGscTritr8X8qCwLK8BwIhdH6X9o/Gw2UAitIPuPP/eKShQFHC0G+wSueg32O/
	scU7zb1FAUpXDjhTSPRt2BC5JhxzR6KtpkXfx0AlFqWfyEk/K1KYIBBmioE/aktd95aHWO
	ThZENS49+GUB6wJp/1lNmAxtdGPnQnY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U1aMpLyyQCK1kWDVD9MUq04DEK0pMspustnhFhDLZH347QtqKWyscqbe9VggTQbwBsFGaDmiRKztxJrMit92G7fQ53wH0dtW0AbYVYeC0Mu9VGFxoW4EV1c4bJ+pQoBA5r2j+WzIPVT33wlTOVSBoLiZjQrMQ2jklfdpIn/kf/RTCZWsihxyNdsybTzYhJ34nUdu5emPBReZSg2hj9EzXK4Z8TkMYHJ/DS5bKBx1+V1SjZbMjczRCBUVv9+AGBfzUr8pkMlHehe3fLFS1eMu8Jh4F95VxzoCJS2nsziIcLjNXjwjRZyDuJi7vj9hcBr+z0gQym/Z7INxuUfjy5wa6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wgpbH+wIz/e9LGhulaqNm5Bs1d1MFlXbk+bpqAczfA=;
 b=hn87AIsvX13iMN2tZW8c5OfHAZapa+H5KcSqR+kVLramhi45kTDLnkxg/H3YWtCo2jblYabJVFVBmeJCk3nySSQ1e6epUDdM5Yex8HPfRC2R/d5S2KnYxz5mVi7Ow9UGrNcmgVklmh/uhy9+vmh0pyj2YASSCX6zVHI06eZaHCNlOQpSWJ00R8unmPOh24Tjw2aCEvJfrr7Lqx/SJpaiq3976wPCJ+NrUBklbDtf6v6giGE9/mwnxKMbG6aBi4U+jp4QQ+RXA7xGHPlyHk4BELIDuIBAz2Yarj4UvsOSi8FWNoGKAEIqjh7isVBfju16zfXgT3a60ou0fimXV2d4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wgpbH+wIz/e9LGhulaqNm5Bs1d1MFlXbk+bpqAczfA=;
 b=R/D5KoTBBBakAZxWLQm6+2Ht9ocVtnGw1yLmBCBWY6djqHfXRfNZ8ap+idjhxzun0Y4/k0XnEfWthZR7tFFWeMOHPm+BYSApfgBk2lzANy5QAAf5xKTGlgzfceNWTDBdWPnQOScpL/NeeNwi6EMZMeeqJYlLWuhu5PliFc0dUmczTTV1JougtlJk3fCoO4SJh25my5VzKJ1dddja0vVeugeYSFzdLTtR0Zj8MuuEjr3chp+77gTSWlLwO/3kvLVM2/uAQzSYAugRHJSDTxwH+aW1Fs4us08h34n6f37VmwovxcyDF2O1ZkLleGtt4ucUJ6fjDbMJB7C4nxFOq0y4Ng==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8879.namprd12.prod.outlook.com (2603:10b6:610:171::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 16:34:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 16:34:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix a folio_split() race condition with
 folio_try_get()
Date: Mon, 02 Mar 2026 11:34:32 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <7CC37A14-9909-4F2D-9AB8-C02F6EF91604@nvidia.com>
In-Reply-To: <f41facc9-42b1-4c58-a681-715961631fce@kernel.org>
References: <20260228010614.2536430-1-ziy@nvidia.com>
 <f41facc9-42b1-4c58-a681-715961631fce@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8879:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ba69d7-3932-415b-61a3-08de787998b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	kh/V9mORTByB2XURJBWfrGiahfeQL5i+z3vcxO+QO6vw0C2oSV1FnfNkGEpQjx4DvCiTZvyD9suMIvvghNfOsJdD1gxSJJp6fmLepFBnY2DNn2pK4eEtTsKEKN143IvwA3uZX3tc7b90UJBh6RwuazlKDvoiNb8u2YA9igiQcYv0ZQnFTD+S0g5cEZcRmsPRzWlw2j/5USxKOXLyZKAcHnM5z1NOD79h1w+LXTcNAAVZSzJHzmLgd9bF74fUO0xw6Aba/yQBSO7QKzNwWJ1aQzrQwmyGj7REhT6wSrj6pkqnKgYx6TBw5APqU179AbA6/lC/y4i7RjXTP1LGT9iTbt0KeAezOmdtLdgzMIMt8Im58fRyzzPvUjPBAKRQVwIL57Z2Ae4Y6KhK6YJPwoocl8SPaerULNED0mgkDxS+YCHO0yV7KjxfNEYBvO0Q9dsmAqfAG5/15l/m1SmPuUug7arufP2ahazJHDaeAauRB7NMYCdauKyXvMqA4H53KZ1gm5wajooBhNwhAXxlFymaGLvIKuZ681jdMTzevPYirIaG4JlzxR14Ed2TDWF0Uya2HBFVOX9JkgkMltsfyzwZFJ/glCXpA3aWM6Eo/kv+UMeapbDAyWxe259TCffr0hRNNh6K5AHKg0EFDRigisT+QOM8tHJE47Y/kI+I9WqIKuZphbcwQZo7C6+J+3KOo3eMBwQquNGTZ4Qi/yY8hXUJAH0z8JcWeHX6w8PQmUIFeyg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T2FZmNLOzZp8LEX0eMecq6Ou/MWmX6R6T5bBjuij0NAtdN8x9pNCY8mGJcak?=
 =?us-ascii?Q?OewtxjGYVAh6ICATazKbgZUcyw0SR4xsLgwhITMJKn38yeZ1mfYrY9QhNYbv?=
 =?us-ascii?Q?ip38Dmt0O0xxhpGTWqaW6bd1/rx9Ry6Yrr+6vQL3bMvrXD3+EM84g7nfqRu8?=
 =?us-ascii?Q?d1RB1kmVC7asFoV1w+vQ5OUZh3UPbQmI3r8Y3mmuA+MQ/g/9oJXAo/+e42/6?=
 =?us-ascii?Q?v1eosPCo4vo5ooASH2SN1HSMrH8ZCIc4EaewQH/BgCx87hH0HpnfCPthIVlr?=
 =?us-ascii?Q?BabRTZeLA4melQASmWHQM33r0j+cEOCpZ9emuGZrPGwUHWeLSCl8LUQcewJW?=
 =?us-ascii?Q?cJWYdfplFdAGyZtLEISgzw6zHg2AXJci+2ZthIJmY9A1zL1H+vva6H2K6Zjw?=
 =?us-ascii?Q?7xyNik35/WX72Qn8Dwd1Hm5Wm5Z/b76X3lWq5twSlXN0VEScggswmzFMJdw5?=
 =?us-ascii?Q?YDXoVskZi2deD/s5Utq9sI7DXTBFYrKjczwusH3R9gCmJQTwUoFy6odFBC+u?=
 =?us-ascii?Q?SMDbLg0g5bUpr3ISbsMQtrJaB84CSZp1xivwWBdTbVYUtNfjjfL/7/PMd+XM?=
 =?us-ascii?Q?OCsgVV96bIuppxvu6b25UGQUQidos10nBXgKJcAco9t1/gK2GB1l8xQ18zK6?=
 =?us-ascii?Q?oXvOGFzKhsrC+R5Fdgz3PDo7cIpQTShRbN3XOmLLkveXOsIG8xSd97TCx/5X?=
 =?us-ascii?Q?b0AOEXfVxpGIn7Ughua4/sBuEoB04YK11jms/+XUGdHLNIPwvmMLGi4ftpkj?=
 =?us-ascii?Q?Jq/E/jC0pukiGJ5yWKFlC6Sd5WpF9NSEjrXFSiFWC0ujD9sU3EISyPHA3HUk?=
 =?us-ascii?Q?eve8J90UMQDnRfMdA1Pkj1gd1X5UBdIELrCEWE2kMabGvMLzJ+/ztPxt3f6g?=
 =?us-ascii?Q?ePp5X6IngMEfNCeiMo9iRqxR0n6In7flEcFrcSoR3WKQzN+tkN9vRkN9ot2H?=
 =?us-ascii?Q?kkNF+RtBacWUtv2pcqkTou6BCJ/eOPsYv2ovMwSFlDDT9D/itkWZuP1DMJRT?=
 =?us-ascii?Q?ktw+1iSYh+mdEYfXN6nG8V7Zk2JDON0absbRfwqv8nGxJG3T+G1hvzvuS8zt?=
 =?us-ascii?Q?JxAdq1Glzz6rvnY6VSXPn7/DX75D5BweAWTQXI9PGZLg/gcQLjymVgQRt8nA?=
 =?us-ascii?Q?RggvIHrQ5QrVw8RpNTdjVDfM2wgHpkpDs+MTJNXRxEE4+3f7OMQlMNP37td7?=
 =?us-ascii?Q?7FOOPcyMFMTc7TF2vms+YX0tRrpBDmSdEgiF6oP9TTqGY126lkfKjMTq6nD4?=
 =?us-ascii?Q?HsiIhfIH/LfRzb+hToC+Ydv+K3KVz3PndIkIsm4s2QyWUxbd4WGRciNZrfDk?=
 =?us-ascii?Q?+MmQwSQ0l5YzuZt3LA+X0JwWHAP0fq0KrjoekovZ8+qsFG/kRLDtCkHqFpd5?=
 =?us-ascii?Q?0Tux7D+qoBvwM7HFo7Eib3VW8XnedtSVx9S5zlg3w9m2NwKrmGI3bkznTIbJ?=
 =?us-ascii?Q?XkvbUIOp38fkkW/mHteZqnMICsvhd60aw9CxAm0qSEG0gPs5nAZYazMKbUpd?=
 =?us-ascii?Q?2TjCWY33+jRZBzIp8SqYjioOZ0ppt+knDmIvoymwhvoUQdMTsChL2dMio/bR?=
 =?us-ascii?Q?IxTF50r19mg9WU78FaPnDoZF9LrAWiDaHdEPLA+4C1JlooHyG4mu/lc04RGW?=
 =?us-ascii?Q?kMdejrwcvbFy7/yge/Y1JG7gsdrwgzNNoG4QfNEZORtgVJROHvLRgUwVCJg/?=
 =?us-ascii?Q?HPlsHHwYYF1i0K25a0tzaXR9BolNnJEC/Nj8heOz0R+dwppGtk7Fy15YU4di?=
 =?us-ascii?Q?M8PZcBNo+g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ba69d7-3932-415b-61a3-08de787998b2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 16:34:38.3535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8O4dZLr8BZ8dZoJd/vjGp0h9VRU6NNF/EDBQbvPTbScaaN7sx9w/LXFff26HKWP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8879
X-Rspamd-Queue-Id: 920C4160017
X-Stat-Signature: dexqgh7f4p99aacw5a1gesq8wm4jt657
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772469289-301988
X-HE-Meta: U2FsdGVkX18Z/IPeEymYtqSWYRYPHnXSoZWRPLfq+fTSaRfIbKgMyxS1jl6QTNNttwOb5WzVl9qrp60hMj/4D+gpZXdCf0z2FgBj5CRE4UzSzk5I4TcrWl87IGJ+JktAWDeIHAsZ6E5Kijlrp6/N4VMldRXGF928ONQ6SYaVi1pYvZR/g/iPEZ3slIBqK9CQ3oe0xU3tTpl5daiP+Gz1t5qR1hM0muJVs8ubPdTY305eDA/UN0fkbcluEZtH6TdcwvU4THkvcydWkZ4WB8ZqBrpztpkkP3XG4PVPZyEZT37Vp4KXIDQYjGnxTjGuaO/qPzv45NJFl7aI+P02HBhkNfuQIfS1tjQ0JNZsELHFNixUOrsmvzKDYPQQXsNQ/eZotCjtEQu2ePgPbDEGF9K3ju91+P03ZkNhRGJzU9+EDkyoG5AXcgNyc5VJ5GJFel6pmGykWWHmu+23JO3wpqk/91CFxrOKu0qfizxfZLcqoSaie0zdzsc5x8uT+tZKEs6xwF945iNGOIl8NP7OOCX7+UYWcECP+A1bqkZ0VuyXCTJEpmVw642dCIhzZEKL/KFKFVuAWyAUeGR2+dSQsB6ck9Fc70QSRH1wpxsfeCkc01ZEQPwoPoKm+FrMfUEu+xgcwNVaG27X2o5j50zBJnJTrAHxd0EO8ds50zDYV5OUGigd3ut67VOqbZglrmIBTS4Wm/GgmOvGXbUuuSdhANDi8C2WmGs6jM4wD6aihWcTKRmVW0CL0vojz3c6Pmb375qJg2TjCY0Tt1sc27ROcdHgrmBqbCIRhFH0qf1Pg6/SWZkTuuSmYHRfbdtYFSxhiFtWdk2eRH5G5F2Z66DANbdGLozieIw0pVRb/hT0VzhLpV/ANekh8uL+6hS8a8vaQqwKv8BhXT3YoiKBHDhbEEOqJGuYjGYZNX+ABxnxLc5FrW8lWCsbHM5lwO2UliZGKfRpyK9MsCkQfJ8aQ1SiANP
 tC4uIVSg
 KoMz3G2ZgtbtHXhmsa1Wg0EEudh0wJoZsg6JxbukhcobfDkgF3/z4tXL+stvoB1nOUefL6dEa2/tB01FsFy+UarZ/qvKjognyRronjxwLY0nR6B24mZI81/tHlfu0k2te2PY8xAyrzQfwhQ3t8v6kKqABwDettgVdJ/KTeJYMiFm7A5TMfWQC04jp0iTM1xXjlkAEc6ayr7TAiNsjWl7Sj6YLGUrhXtgg6K9yzG8oEB7L0V/HNZUdObli3NfPKLqSuHkYIX4p83q7OqmxoJbaIWdDfwvfp8KZaI28aZgie801g6WUxNqLIs2+i84007Cz0JcbFmjGr4foi7V9vPEKumIwl45gV76CkRTUbr6E+GN99ajWVa6+lijpvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Mar 2026, at 9:40, David Hildenbrand (Arm) wrote:

> On 2/28/26 02:06, Zi Yan wrote:
>> During a pagecache folio split, the values in the related xarray should not
>> be changed from the original folio at xarray split time until all
>> after-split folios are well formed and stored in the xarray. Current use
>> of xas_try_split() in __split_unmapped_folio() lets some after-split folios
>> show up at wrong indices in the xarray. When these misplaced after-split
>> folios are unfrozen, before correct folios are stored via __xa_store(), and
>> grabbed by folio_try_get(), they are returned to userspace at wrong file
>> indices, causing data corruption.
>>
>> Fix it by using the original folio in xas_try_split() calls, so that
>> folio_try_get() can get the right after-split folios after the original
>> folio is unfrozen.
>>
>> Uniform split, split_huge_page*(), is not affected, since it uses
>> xas_split_alloc() and xas_split() only once and stores the original folio
>> in the xarray.
>
> Could we make both code paths similar and store the original folio in
> both cases?

Sure.

>
> IIUC, the __xa_store() is performed unconditionally after
> __split_unmapped_folio().
>
> I'm wondering, though, about the "new_folio->index >= end" case.
> Wouldn't we leave some stale entries in the xarray? But that handling
> has always been confusing to me :)

IIUC, __filemap_remove_folio() calls page_cache_delete(), which overwrites
that stale entries with shadow, which is NULL here.


Best Regards,
Yan, Zi

