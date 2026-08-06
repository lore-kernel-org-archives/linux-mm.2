Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F51C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6716B0093; Thu,  6 Aug 2026 10:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067566B0096; Thu,  6 Aug 2026 10:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A856B0098; Thu,  6 Aug 2026 10:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABE9B6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:55:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 214B0160572
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:55:17 +0000 (UTC)
X-FDA: 85071142674.13.737C1A3
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011050.outbound.protection.outlook.com [52.101.57.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 58D874000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:55:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BUi+e4WW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786028114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qH+54KpMuI8gMEhZ4VbLhmp6MTMn1voHbqQUqp5Ojg=;
	b=qeEvpBbUBBChZMV1dqn5KHFZ2h3LwbabOX9eg0UDD61Qv4YOrGPh5iEW5s8g9+G0WGtRQz
	L0Oh5fHzO5yo797NiasYRoZNqzyGrDdL30aaJYEQhS54kImhNdHhKctgT8T5yJLST/u6ob
	gvkdt/KfG3Hcg5XcSMe+CtX2yFzbv48=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BUi+e4WW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786028114;
	b=gbripLT7WYeP4hTSRGtLKKeKZwrTW2tnPM32isn8H2FkgDYhCiFPtVoH8ydEK0hSJXmGhu
	pwX4HlYWy4Ti6Nfg7VIwr7ZWDaqGDH0oJfFDOdNgGJloGdZnG7bm8vfHxqV9jTcgSq0Xrk
	IDWY09QzjltZJ5Me4BaGY7/8NdIXpHY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APcFvH7NABm8o2B5FN+e8nkff0afgphfQo4fd6JR7Pfh4rWj08wIJWalF5QnPca0T9R3Xb2gs00V8epjCfSd6yxGpI7BoJBYipKf4RteDHb0Hd0D1LN7BQLmX1hDDJuH4TDrhG36JXHDiwYdBrZ9rb3na4ejgGG0lYWq2FcUhFPzfqaqrE0wQ4qaACUgZBPz0+98hVw7D1ukaOls6FHzcYHweXnwNf9vx3R4L4rNdjbolAQ5p9mtQ0kcRMeR3zShHviyk2zhaWiUvzLAK4kzbeMU+T46zRWqPUND0x0q4y9hIorD7hC/qgxRmqBn5VK0jOr0ZxhHLGq3W9TSmJM78w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qH+54KpMuI8gMEhZ4VbLhmp6MTMn1voHbqQUqp5Ojg=;
 b=IjpspZl0CJioME+zig87ScWWWDxxbPlxDTFPMZMRoJpNuaDzW4F1stGtQw8G4q61UWStZWs0pqK/7NhSsZqUHOa5LbHIgZULv9u6/d3IwdeLDI0L89DTyYvl1i15g8NgVOhmaANbxy46oPbm2/Bz9FNsvWd6sqmig2gtPxsPZ5nqpH6IurXQz2E50VMYUsO4S631Crlgxq4WDMeDNv3pVWWmMiYZ52DWx9iQmcDkRLj/hqUBDNkmMutDEMjXYEW0LRIB/ferAXy/xanyt26bVcDg8J8Y2vEQa5l5UaWt7hO/DcVpgLrV8LFAKjalM2I1/gV7Y6skiR9stN+C+jDd9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qH+54KpMuI8gMEhZ4VbLhmp6MTMn1voHbqQUqp5Ojg=;
 b=BUi+e4WWxVxNAlFpMydRxGPA4EhF6ZQd8unJGeKsdjp+8Updcc9I5C95qrTkMuqLjPcnjzScWbfwcpUbezAliEyl4llEbkSGg5Eqaq08KtTNAw+r5TRV+bw1ISkIS9G5vgw8nWSFnhS3uuh/aB+cQMg2QMSvXb2J4Dqko4ppBGUfP36KNht8t/BIvE3MamGxvwUyoye1pz2lgXMNmarO9AuKxdKVDxvC//aFbYKzPaO1J1P70uOm1pzOAcpgCjt4CmTfTF5nf/BP6qvFL+OaTE7FCqXcWkISISqDZ4W8942J27wukKbD3P9+5U/83wEeqIYjOsrO4RFD6tbpk/FQPA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB4056.namprd12.prod.outlook.com (2603:10b6:610:a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 14:55:05 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 14:55:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
 Li Youhong <liyouhong@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
Date: Thu, 06 Aug 2026 10:55:03 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <923FAF8F-93B0-473D-8DC9-C48FA1EED190@nvidia.com>
In-Reply-To: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:208:329::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB4056:EE_
X-MS-Office365-Filtering-Correlation-Id: edf05de7-3935-41d5-e2fe-08def3cab356
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sQDpAOQ82M8ThQ9Lr699i4DmutM74BwmTu9avNf2uEJ78SFIWrNGLZlO39MNU9Wz6HsCc3cOacPlYoYc0vDe3w7GboifIGAT9CoHI7MqgCpLUejpAJhiZ8oaaP/nFKxEl4QaJrTw1F/rbvKIxVW1/N/78IWT75witZERdDXWBBuVSvkMUi5pHLKTQp1KRclc4numRqdle81PUnHsJIdb2O+ijEGF79MK0P3QUQRjalMs61U0HwysDHprV3wM11BgnfrKeK+lff42hWjkQC1XbT+cTbT9OHqCikOxLocAqlbnVtXYlUyi12rhs+FezWEUlxsNv34obIAl0D7snuZRCpex6MUVvrWoKO/0YSU9U972AXz8mkBeK3ZsjlsYl5yC/nP/PY7qRWdwTluC514MsnFnVgrl9IA7UyqbHBaaxJP31cesL7TRK2Myzk9Y5D3nUThM1M94q7qBzbBHKxfiD4/Jw3hU3InV3mFE/fHBRTW8+1K7c8qWFiGXwwtMewY734lpONF+ugdHml8G7WeEpZ3hj/Q9dvm1zcOyLL76FlGclICofzCKTXRac+5Qz4Qy0QzVhLoznMxk9mn3f78DSlaQjPgX5Oii94FS/qGfjAOvYvMpcz+lgScFqdyqPHpLP9AAA2BQWTaProTnStf/bxCYmbyiSbEuPleAi66es1Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VaEiitxoNweSIEYa6G6XHug3i95+iMlCCGx8f5f0OCEDV7c44TjWFuO/2mpM?=
 =?us-ascii?Q?yb3kFSjpsRqSlRGfre+MnW0Y5o2GEYEqBE+dt5a7uM7CHXHoxnBrNvaZ0TK7?=
 =?us-ascii?Q?zWLpbskNtJHhFvorayGiUculJMuNvbpIDu+lXpEbdLRqF2TmRVUmX0tO6NGP?=
 =?us-ascii?Q?AleD0PlBtS1DkBQP+OCwN4Ld8DXU8RpMgozhBav4cLV5c+xfT4fKs28jrGyW?=
 =?us-ascii?Q?uYlvMDRhJCOFayi2HRBCFRpan8calXc7g+QTPeezant1gcaGuTVmVThoCum8?=
 =?us-ascii?Q?viiMf+iP9F8627EgZX4p7p/IYEJLbF/XxhH6eoLWIktNOHC+22hsO3t7P7Xz?=
 =?us-ascii?Q?E35bBGCjCw9Z6t1L26aetVIdZpAMnlyMuUiab5DcG4+ZUqv9dm4JGmwyvJwL?=
 =?us-ascii?Q?vaIgFo2+aJ2rnEb/7hBpCu/gYEesE9gwYyIclPfBYtmk90UfdMdOfEW1UnD4?=
 =?us-ascii?Q?htNqBY5vT+iwqD6M0QD9DVJrpEUqps3dhiMLtgCHA+1QZIFjfkYW5BuKzoKE?=
 =?us-ascii?Q?WCdw8/a71KIgFl6DrrXn7KL/EiBW8OfTDv/hS8hCGGtAZcjSyCgDWHJ2XzYT?=
 =?us-ascii?Q?WZGIY/5azksaqfhDy/vf4bBgWMobX/qqjTT1yH4GDsgYsSm1vvcxnaGgya4G?=
 =?us-ascii?Q?lMAnYIu+dntsBSeCukyQsW2Y0e2e0SE8fbmzSvg1OGDsvD6SdEfp3ge1ZsCV?=
 =?us-ascii?Q?BaoqpeEK/7gAnyZ/nd6BlMMU3Tc+OUPFk9TULW2n316C09vDzK6jT37g1FVB?=
 =?us-ascii?Q?zvy9O1RN0kjazbpXduKRN4+ScUsLQnNob58ACHQOdhZzR3H3mugu/bFhCz9b?=
 =?us-ascii?Q?G6qd8AN2Q+IiqxHNpoxAqA0Kf9BVlOCtxISQWzz6+SrVmRGoMpD9vM8gXBHJ?=
 =?us-ascii?Q?RtbtdRKkJcixUaY7s3xLYDk3O6mi/uxgfN92juFbwjfKWRaAt64kIUtzZxdC?=
 =?us-ascii?Q?cTp6ocrxdglh1Cv8QQNTnXvyT6OgOnO63zfCPLll9G57GTnTXn1bRpgiSkiV?=
 =?us-ascii?Q?ukCmZ8txIMWQRegOgPZC78j3CMDOVzLPWnYc6aDzUQAQjCnho1ZrhfNXkZUu?=
 =?us-ascii?Q?W+9bb2fBOHgtWszn4UPkjgtNSjfYhsDZyyRab78MtcJ+dqnDjC8A2QG4SDE0?=
 =?us-ascii?Q?AVjwqYgYp1qAloDLvny5w/7hVgxrO8V90/bomiX/6Qja9BVgXk1yAP9KxAcX?=
 =?us-ascii?Q?R8cErIWNg/c0vQTUwxEvsiHh+fBOnG+ySMYzjiQmMnN1bI7IL38htCiTSJnf?=
 =?us-ascii?Q?bJ5arRYa/xbE9W4J0DIRvpmEWIuKN8NhyXKCwFx5K238M/2yRKVbRWfKqvtA?=
 =?us-ascii?Q?GnV0VOUTT/sH6aHkI6be2jjL9uwHyHtdmWrrls+7tm41WH+HE0S5gnA9/1Nn?=
 =?us-ascii?Q?S9Brbg8tHzCyoGy4EmWO05Y/+qFSTwVZ5u+wW1neCiMiIconKGN+YLd73fW1?=
 =?us-ascii?Q?MeRIkAgTlfUVKoNd1l1OYwEbyoHF7RRPCUR6nGsWWC/b5R+ZZRwC2doCvOaF?=
 =?us-ascii?Q?22ihv68Rjbcb370XgR0/GUjnaM2tPsLH/JIFQu+QZjqiIB34so7dF0/C8h3/?=
 =?us-ascii?Q?RDbZSvfDcr0ExjzbBuZGT5cSm+aKfap0toSjHPh/bSojVOz4xDPslolFtzos?=
 =?us-ascii?Q?ZF2Z2+7TSXeDPUxHFGa34OCy3TDOjldoAAKSLy8yd9zL4cennLsU2pdfnigX?=
 =?us-ascii?Q?PpVkbDclxfmLmt/pCn7HCu9UNMYKidokPEj35TVPhKFjaoGnS1cXNJRlqVEi?=
 =?us-ascii?Q?bMTpb4Vx5Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf05de7-3935-41d5-e2fe-08def3cab356
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 14:55:05.2459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9lzXDtheH3jN7/cHy9XF0CjbKdd3dfyzoZXbDd+oDnNP2ELQfy/BFqrHBqIdsGr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4056
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 58D874000B
X-Stat-Signature: gr3bxqbrankyx4kxhapun9mtgdpnnq14
X-Rspam-User: 
X-HE-Tag: 1786028114-316355
X-HE-Meta: U2FsdGVkX19ujO4SKfA7oEwGT0ih2Ty4XBmuoGqKbVOrQZbLPTkoFbpmv5ygDLMLZHYN02xAfJemr5tHtk8QX+A09au7fmlKZE3a/6yjxyabMnCDb+ifXh9Qx7amTEpPm6i1BvOqnO3vUtzWx8tQcRr+EyDuPKlCUxjHDchF6ZO98FUaVz/TQVRZlpEqKRDnJdZQoWWSA3SHFgBBgNbRR9x1vbsmgqTdx9PVa2ec9TEoDXWh28Q1wkCaM6r6I6ay5SG0yvq3du20nrWj0cKHiEL+Cdno3bBmptwksf7rx9pWjXCO3CucYMhJV9DyShW/sGMz2rP+kgNUTbmoIXHvBBuz9ITU+vGi1BUMPVpvIPs3DMlBp9LusfJq+6aJAsyk66Zzg88rQFtjaq6DWo4Of/sLupndtJ2yks0tWdQh9qNWRnJaIhIS9xVw+QztGnrTRImmKIU4ovsE94PVIy4q2o4aNHiAhUKpA2tKwStVj07zf7f8lyEb6r5fBAAYwBlL2EyoUBJtP5mhDzPyK9o64E3UeiMK1GB1xjgrausbKhdPD6pMnyDEI7guVZEUKxH7UtmB6VLW1LJRdXVWKkzjGywTZyn+4Qi+9u/Th4ZnmgkFFLOunIIadYw9cOs3PwWOJbHpGwawzTntmnldpFlt1VfT1b9Flzisuroxnldq5ynjcOdt0NV0DEkR6lCE75H2dXkNHsd2Lojez+wJYtKCTSRG0FpocpLUhxRPqLNxO8dw7uRnGqL4Y6uSbGJnbBYPoVVvTEjAABJue5d62gcZxGkloImTC3Ice9sq+unYHnigWvEirD/IVlsd7DEKpge23reJKZVYrDN4dLPtUuHtGT29+aVDFLpun2nU/4+Fl01qCu7UnhbMbxBX6W8pU+8sDIRjPdgw5dugRXEhd//4yuwUCvp8PbSmxOU5OgF9z0vDFnaJFgvpPaMfedB+hJgcxBVMZ1u6I70fUcQ7jbF
 1Gnz65yK
 Fni8ru9gogJpJGP9pRNHjcxBfjHZIasp/4v3r985sOt2bDrurePRy0BuAVA6bhXa5XMHJFeHS0cbzj0JGdfE6h69OvMlseVFDImpnX5ndEUQnzmSslnHxnpSmdCDssmE0gmgziFHPEveSWmezAxZWg3HMwxZ2ohdVyj6YPhPlvd9z+M61fepy6NDMVCCysvRBXsVauGkWfE0kL0/Mj29qI0xdDK1ZUkbZ/9fO4x4Hk5912GMlUpUkFl4OUxYpmQbo/qelFV8D4KATl35nQci44Du9YNRppccFIQdMe9he8H87IcRV9kzv57PQSHeGdmgnwiJuI3Y1qL8kPo/wDTq9a2F8D5nOyMtbfONUC7R5neQOJUELKwRFYRpGX7xHuPn4c1dz2H3Xe2yclYmfA0MunRz2iIx5clJ0x00LNzhWt28+9lCesGW2g8fM5q6ozUtUaTDeMSCzMEfzwDTOSn4oCeouqhgjl5ISACJiyUI+MPCOxNBVNzPoLoq00dyvDk6+QIeanhKnJ8jjtiHrNsr+eQ1cVSf1Azq0lBBBE2UeytOVfto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Aug 2026, at 7:14, David Hildenbrand (Arm) wrote:

> hwpoison code can end up calling min_order_for_split() without holding
> the folio lock. There isn't really something that would prevent
> concurrent folio split. Consequently folio->mapping can get set to
> NULL after checking for "!folio->mapping", and if the compiler
> reloads folio->mapping, mapping_min_folio_order() would try to
> dereference NULL.
>
> While very unlikely to happen in practice, let's just enforce that
> min_order_for_split() is called with the folio lock held. We can
> significantly cleanup the calling hwpoison code, and just get rid
> of try_to_split_thp_page() to hold the folio lock for a bit longer.
>
> Just work on folios now, which further cleans up the code. We just
> have to be careful about doing the page_folio() after splitting, which
> we have to do already either way. Do not change the way we split for
> now, this needs more thought and should be done separately.
>
> Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
> would currently have leaked a folio reference.
>
> In folio_split(), document and assert that we need the folio lock.
> Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.
>
> The folio->mapping problem was identified by Sashiko, and Li Youhong
> reported it by sending a proposal fix.
>
> This likely does not really warrant CCing stable, but I expect little
> conflicts when doing the backport, so let's just CC stable because of
> the refcount leak.
>
> Reported-by: Li Youhong <liyouhong@kylinos.cn>
> Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> v4 of the last fixing attempts:
>
> https://lore.kernel.org/r/20260806031958.677935-1-dayou5941@163.com
> ---
>  mm/huge_memory.c    |  4 ++++
>  mm/memory-failure.c | 56 ++++++++++++++++++-----------------------------------
>  2 files changed, 23 insertions(+), 37 deletions(-)
>

Changes look good to me. Removing NOTE part from soft offline looks good
to me too. Thanks for cleaning it up.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

