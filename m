Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1004BCA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 18:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750068E0096; Mon, 11 Aug 2025 14:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700FF8E0093; Mon, 11 Aug 2025 14:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1BE8E0096; Mon, 11 Aug 2025 14:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42ABF8E0093
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:39:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2F3481BA6
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:39:18 +0000 (UTC)
X-FDA: 83765339196.08.F7ECC29
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by imf07.hostedemail.com (Postfix) with ESMTP id C365240002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:39:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RdOZWpbC;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754937556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQhUqb5fx5UmTRf24vjHpKki3R52jItB5fHnPncwdQs=;
	b=L8Mn1nkHg9MBbm3IUZuBJVdm89ay9ofH0nuA/V87eSwOW2hVYqO135nk21S81tmi3OgKHm
	fq6M+/NfAEL30VR2SqSKriLGNZvusrQ3aFdpAWWSrMq9EJJtU3h8jKLi1jtspPK0G4D/gp
	YwZD6iKTfdu4ao0/MF/q6qcwYZgUvyw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754937556; a=rsa-sha256;
	cv=pass;
	b=EP+RfYjnWoA/XLNzAXvj+tAex8b+0Rpyv9ry19OCgvtvLASyfBA3zrK1yJdXRDQewa2MeC
	oLODAIcu92MgTASzOo/oDVFKTUtYJnqG64whns2uL2yo6KEWkzGrt9LifHxLb2wT/S4vgl
	gu1uxF/tcyKaljUGYf6N4Nt9IyrbqGw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RdOZWpbC;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YLxctmzgcFTYxQ6H12w2jT0nVRJik862A/xWOYPIsxiqIPnSJq43yO60SPTaw36lVFbTgknshsW7OD/R5dDwIsaQjWAbD2cLATkJWubPZ+XtHUFXNZs/24Ivmayrtzdt9FO4dCnYfd4MWJAjpV7nxkl0kh1jQTj+Ck/gT11YF72Mzkm4UBngZqUFSWHlzCJt6K+qwnr0e5PPKGyevCKD9K15jacchNGKl48vnAwlcm62LWd7u303BHTMcG9XCxly8hpbsk70SDYFLkrQiazZ0AYi39n8jhjuFPgqPdEUpbvbioGopr31yvdwASLzIb44CmAaGouYMduuncM1DKHLJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQhUqb5fx5UmTRf24vjHpKki3R52jItB5fHnPncwdQs=;
 b=yH2dHQiwLqW0qKderlZbUW2KS5K+EAy97md+iIL4ATMgsju/4vSBkWfsZ24aiIBlTAI2nU9bIKBbtFdrauvY2DlVfyO4XVzcJAMumhC47V6WjJxx34K/yRr8APSKItFpYLbDfelyr1/Rrjrub1vyRt87YmjhwRVAx1eFeV5UR/tZpGm8PRPZJgfRapoDMfpEMjypvuiP0/wWsSqMF5I6MhHR9tXAXYgzjxADhnQhzE/FxbhmObW6zE3jcjGGERK1DD88GQfxXZ2nWHFG44QTfRatJ+IE9t9ru/jikwuQYHYbAC5cvWgJZKZxzpK3tQBZGRw4WuEimsXhLG13icP2PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQhUqb5fx5UmTRf24vjHpKki3R52jItB5fHnPncwdQs=;
 b=RdOZWpbCgQDddIXmdWq18p5Hh+oFgZTuloW8WdiNvVx0O3CawvSE6et5qEy1BZoWsNs42e8oFIFXOcblQlyc5jvtXI7m5aPGnK0vz/ho/l/cW18mp4w1Tw4Ov7/8B5zG6MsD6s+qPQArAqzpPDBhEgrePMl9R/kBB1B3AwhC85N4N9UaAb0DRN5HBLruHge1X/2ZMXFsALeb9QVWy53GzU6SkhtQXuGW92aQLfkebVN4mRg8K8v5his9EALpfiq/sWnUj8k9pSnwkVT+n5DbSdBmgzczya1PEDz/VRTU/NM27j2youS5N9YGlq7XQof3pzTNkMCdOSoth3+mbBgl6w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6753.namprd12.prod.outlook.com (2603:10b6:303:1ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 18:39:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 18:39:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: wang lian <lianux.mm@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/3] selftests/mm: add check_folio_orders() helper.
Date: Mon, 11 Aug 2025 14:39:08 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B13F65A9-B001-4494-A060-23D95055553F@nvidia.com>
In-Reply-To: <20250809201836.jegaanplfcjak44f@master>
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-3-ziy@nvidia.com>
 <20250809201836.jegaanplfcjak44f@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:208:32d::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6753:EE_
X-MS-Office365-Filtering-Correlation-Id: 403e032c-54db-470c-dd68-08ddd9065d64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qe98WOMLPrQuUt5/VGOEo/+P79hzGDR+TuRNQ//YtuhMls9CylnEZcTKBxIM?=
 =?us-ascii?Q?hw1tiZ0Ao3v1+nWdZghiTiojFh0SvMYCD4M1523w3Dev9WLiOScAbjIANR4K?=
 =?us-ascii?Q?bhHvwHT/LpE8BAWMQv1+vAMaVxxAXMUBUSupbPkxYlldUSsA0PR8Ko8ohePc?=
 =?us-ascii?Q?3vtp3ZurHNSRUMR93aoRw5kqFD2d6TDvXPMqnWWSFlXYdt2+Ur1yspxNwKEX?=
 =?us-ascii?Q?cqeLHNtxw3yjanoTjrrC3+3mOvfHFUgyP8MOuotg1OYa45kHK10HPgIsSkpi?=
 =?us-ascii?Q?tqj3SsidVZfLqGr5hQh7+C0TUeb2rqVSrSix1wxK68mP13Yy277wcA0iyZHa?=
 =?us-ascii?Q?8eI1pL8B194wYP7lYUm8QA2BJeYAaS/JsxGn4Hqlpj5sgGn2Hp9PdTLwObXR?=
 =?us-ascii?Q?90imzjP+SZxldo6nooxcP9dKuJs4OibubWpUIlRMCcdsjC53ZftFIztjENOQ?=
 =?us-ascii?Q?EI1cQNPNtH82WLIjQ0ibUYKL+ZFCGtyLbkLmY5uBUyGRTo6yzvcKgvPYjyDN?=
 =?us-ascii?Q?JFon1HU+iBWE8fTpBEYOBylyh444ElnkijuDqPSA9Fswaki6yFVPzEV0Mva2?=
 =?us-ascii?Q?CM3y73d2pNRcGE7hUH4QfVfRLdW1A+c2RZgJJpaLI2mjty+rmzoZftr7dn3N?=
 =?us-ascii?Q?SKMqu17PVETd90Qm7JqeNdEUWXKSelpPoctaE78DGWqkbVR6w40Dt+NlUF+0?=
 =?us-ascii?Q?xPoLJGoBgpsdnfIp1N4j9xvccJXd9QQW1So9SQqqXSao9FO3nwzrOvhjwTZn?=
 =?us-ascii?Q?/4z4gGKW2ij3cy7BNM5Yfh9Bdo4rQQhoM0pkRouwi6+PtPplcR/mCeyZlAPc?=
 =?us-ascii?Q?uYPKQwIFJ7ezJ8krYVVZOkcrfVezVdOEfWCx9L7xRM7N4VIXmCB+6ETrCVFn?=
 =?us-ascii?Q?tAi4rlcFbdYtLfWAvYtVPAal6vtnAIsdkZqqIMZpC6nwkpWlMXbWzjaJINRU?=
 =?us-ascii?Q?HnnQLIehTM97Ezz3bhBuNI+q54R+8HmKz9jHsFNArPJFOR/MJzh3+bEGXQ3H?=
 =?us-ascii?Q?+5c6FsEDtgrtFwSfuXHw4CMpbPlDwKu0P5J+Cz1dA13EYt14qB6lrbekKOq0?=
 =?us-ascii?Q?KUmQC+pNOGVKF+u44Qu+CZCGGVIyjFpFFy1Rzc8fdO8+VZ1AuEgz8fXofVZa?=
 =?us-ascii?Q?h0T+ib4aMQ1immG1b+gZC7vKKpNOuYfmyw+1Zada92NmU3QnrdIyv3N1c5zw?=
 =?us-ascii?Q?iUM5+SxYYy8HjeTmTcpk9MFMbWXPgn9WmvzMYQb1oM+rxntB5yMMeZALz5Qb?=
 =?us-ascii?Q?+uPBsfkXQjs/no6el4SMm1wcwMBWuudTCO6me11QG7LHmx3zSGa75sUzrHut?=
 =?us-ascii?Q?aDWNsZMqxwDZvqp7BcYxXScZ8PAU+tc4pEq/9hJuinMvedtdFQwrdSH1xiEl?=
 =?us-ascii?Q?SJND7DVx/qA2Q7M4MRZu8xxHQeZyOUFt/V2UF77ECN4qak5ZRZ8u3EhhbCli?=
 =?us-ascii?Q?78UWeY5rF0o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DXgaQvvu47eJJS8KlbZLcjVvy6coq5Tm5PPUNZpjCxu7V7uvyxjBLL7f4rlD?=
 =?us-ascii?Q?Vb5A2p2Wrmow5w9x1KNghB0HkfWWhenq6gfjFXewk942gCNicIe5iFol85pE?=
 =?us-ascii?Q?UCRm/uXbf973dzW6/ZQ8HLnCddP5lu2pgaNQ2yrN3bLSo3xQQhhwuybtfJLM?=
 =?us-ascii?Q?cS6m2xC0pr6oxw95XyMVihzNUHIOdSm7ZXAluj1NQX74+QX6Tfkz949htRN+?=
 =?us-ascii?Q?qQUZJYXePz0bv3QsCMkCE9ekNWs3vq5JQMOFndg6vitq0CVR0eAoobYxg21b?=
 =?us-ascii?Q?Y3k8E2at4HMeeji7PMrMBoFh+6TFfaru3AFcTRcxXg4vpBtKfOL12RTYjl19?=
 =?us-ascii?Q?pjmOvXBj1FjlYqb6XZyGrQeScj39KQQiiZpQaoyVcmf25aWsSIxO/lAHmTTb?=
 =?us-ascii?Q?kS43rIYGsd9FKE0RRopTH5SjML9jPmthw6QvAemuoWXRQ6g6Q9QjVrIcAiOm?=
 =?us-ascii?Q?O5MgNozjAlv0nnZAcBny+4gchVPUSuhcVSuKXSFIOZflxjHU9e4uXsRRllcf?=
 =?us-ascii?Q?zPg4B3DcDIeaehHGmYqvBeXbbm5gqlTuR0cRN4NWkFBaZhf9/2iEz11nIwLh?=
 =?us-ascii?Q?q8MVAbLz5AdAnMLGC6UUO0UPwq+/ANlVamA3oMElpYuL857I4FbVI7lZvXLZ?=
 =?us-ascii?Q?Bs/vHx66wLA1l4CbLxkixMmbbLatpMHQRe40bOKmV2wSLOMTqpSHML/53LiO?=
 =?us-ascii?Q?OfuIBXI3pXeKbUzyPn+GtZpi8W+eiWvJTyuKdxRKOZD8xmeinJGlDNyhRIiG?=
 =?us-ascii?Q?oh0i9lKAeDPByrjWEFMgJDw584bcWU6B8fGIjYmSly+iafF22qv6uZSyoJGM?=
 =?us-ascii?Q?AOd2O8O576tYPlrNwmP0ZeTt3PAqMlPgv/CvKZcuTIwmwGV8NwzXmHy1d8L6?=
 =?us-ascii?Q?Kp5Z16tMBkAEGhnfo6U1c3LRi7bl/q/18pp/zkBEtnonsGQ9IqrxzEd8lpw9?=
 =?us-ascii?Q?uqZCyfxUXcsO7JAg6StApBNyLz7J+JsfoPtumWyFMCv8SiRaSL9TAxX784aB?=
 =?us-ascii?Q?TxCDbx+gh+LJzW0T+0cLS8MifcIJq5E4afRoaaz1mzgqk++nl6Mh8I7SKX0I?=
 =?us-ascii?Q?9eOBvsyPFnW6by33o0GeKtN+wUs3XDferi/oQmX9QOUsLqbIloirl7RoE2Ym?=
 =?us-ascii?Q?5KkZ6XVLlG3d35dwWx/B4H1aIzFdWbkiqBWZKs089iuuYhvaAiODCknCZUld?=
 =?us-ascii?Q?Szt2OFfCZS2ynVwyJKw+eer53KJdqIPElr18/E6OOicNdv2091B6xbxWmMED?=
 =?us-ascii?Q?T5IlF60B/iyI0vlU5a+XgIiCQJdKlWCCf9VvcG6TLkx73/ptTfRvBWoi+NWd?=
 =?us-ascii?Q?ZWNgWrk5EI590l1aUeC5r7ZDvQexGxNMCdLz3OTjaq1b9PQGjE+z400Gz84S?=
 =?us-ascii?Q?vcbI+EYgYaV/4bHkDSISPCAdMrFjL2HRiFlM/BeGsYhi/tcpTac/ON9BSKqP?=
 =?us-ascii?Q?6Ux9I74/XvzcqIKfxxblOTx/07ObG1BKV8ZT9rIbK9S5TukLmkbAKNUSvsxO?=
 =?us-ascii?Q?gylDd1Hoeh6qPRBKdWKA1yvk3y2wa0MSP+MZPAEo1yrsEMXgW5YK+KJkmSCc?=
 =?us-ascii?Q?BzMvQYwzqZc124pUmcpiphShDMreqEfNsxSP5b7e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 403e032c-54db-470c-dd68-08ddd9065d64
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 18:39:11.8076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xD3UvT/9LbXhIv25fnsFXqYXlfl4qc4fEGavPnv4txcUJ6RpdefGlDq2mF0cz0WQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6753
X-Rspamd-Queue-Id: C365240002
X-Stat-Signature: cmabsztytafhki9kani6ixyriqaepa6e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754937555-826074
X-HE-Meta: U2FsdGVkX1/BUDafeesX2QWtif24NcDT+w4LatiDxW/4/ysVzC7AiP/NgGGufAxAxIBsyTKWqrL8Ul8MNoC2tIWeTaZjMxewA07SL/ys2x5DQq+eP9brnLM4ja5oE0dRmZ9w3xR6ZKoOucqw6hi7Z4yjxOmQSMe+W4b2Uzmo8Xkl1n2Kb4P9tqFxoj8IMMQmwLL/370garWBR2MJaTwmS3nbX/CgqR3yObQ+7thDLRCwXIwEEwgUXyU8HEqIAoKYYLdmV1Fp8GnQBy12G90canefNZpLbYCb/H6afBowVVyl/haTb+VcDTfZ513CeFxSuR4LrUDq4rNKh/2zy+UQTuFhe2oZvLPGAMicaKFxCN0elsHqgMAKz2OiAfR+0DSIDUY+6+djQRec6vhuToW7KBfwvJ+TUMuXa+WYEBRmCWOIGZpyiHZxOVh3J0GoJh9Exh0MP1iMmzGymqMcTMzCjrmrRiSak3uepvTIKspPi+kjyE4xAxfQ827Q5sV/IEfKkPe3VSzHYY0vf88vatRZSdouXLZFmH4XWElXHyYcjtKpUMX9jeW1c2RfiPfdalUHuHIs3kVyO2wRAcinfrJW4yhQ0NKUp3MpQZeRrys+k6PSBajbSkg9xyEyBA6Rgvurj17E2b8FdQwtZO/5g4naob7MIu7BVF33MQoAGhnzLgRCs92Kb3I3l8UDnTHKZVd6M7IWymK/0D1nzDGbAM91zuAXKWMJ1rVUsencgU5X9+9wZUSRodn7vaxw+JJ0ksBf89esfjFqrj7xceaxViKUnIiYCGCz+41/IDqj8RuAQHxmLcluTidAJmClYDuUh3o/UledhjEdZAuLdTvg+uT9d5iMxQEcz4Z+6VxqSqi/3x/8B9kl1unTIo8X4wqxvVpx00zkhg94KmftridCLLcIsY9Zmh4Y/WoHLZdHq6QodzPsLBDF/Ejkt6gtWeMR5ynAjKCez5AovFJg8DZ4M1I
 RNAyIhPa
 vuZN1KWVFI3TQoA366halQWFSACPdXq1X+nTbUbDbA1RUdh1Faf8cGwJwLN0DIpFYfrnuzt+s1CD+Hz5oLrBfZpL7ObuZWx/NzWdGrzIROkMoTVGJa72QccNjIsoTA0rrmkLMLEH0CSNexZKxHgUjEHEGiDzjJp9SH8roFISotlBmEOFM4OGMv6MA5Sq2Gx55JnI2r7twcC0rgJtNa2nyBHQIBbkBSheSgaUctY4R5TsOqyD+MN0oJCZimmERtLejkBNdjSX3HLoXGFS+xR7KqPwPfKWdPU3IfErwaMT/ObKHxl0TJU/s+OkpJUVKRZnd/4BkFTMwxm4g8XdtWOo4n31R3NY7DMm1xKerNw8SHagps+u6vFZDkLbAXu2TqbPOZUDZBsL+MuBtozzXuwcPKU30pBlpkzs2tFmIhhVkEEEtqttnRatjD8FeTIe3wiQ5XsVRKZYP4Z8yW0Ui8fDb+3cTVyTlrBpGyauWcRAf7gb9ljX3O9790gXD4wPeiRrZB24dOrH6Mh8Et+rtLdzAhGr2L7ioDHP1p9XeG+cj1wjG5kHuhRrTUVXLTIoeyQPK4j6ysbFth9vtIQWlFMOxXlLn2qHbtdhREF1h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Aug 2025, at 16:18, Wei Yang wrote:

> On Fri, Aug 08, 2025 at 03:01:43PM -0400, Zi Yan wrote:
>> The helper gathers an folio order statistics of folios within a virtua=
l
>> address range and checks it against a given order list. It aims to pro=
vide
>> a more precise folio order check instead of just checking the existenc=
e of
>> PMD folios.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> .../selftests/mm/split_huge_page_test.c       |   4 +-
>> tools/testing/selftests/mm/vm_util.c          | 133 ++++++++++++++++++=

>> tools/testing/selftests/mm/vm_util.h          |   7 +
>> 3 files changed, 141 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools=
/testing/selftests/mm/split_huge_page_test.c
>> index cb364c5670c6..5ab488fab1cd 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -34,8 +34,6 @@ uint64_t pmd_pagesize;
>> #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
>> #define PATH_FMT "%s,0x%lx,0x%lx,%d"
>>
>> -#define PFN_MASK     ((1UL<<55)-1)
>> -#define KPF_THP      (1UL<<22)
>> #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>>
>> int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_fil=
e)
>> @@ -49,7 +47,7 @@ int is_backed_by_thp(char *vaddr, int pagemap_file, =
int kpageflags_file)
>>
>> 		if (kpageflags_file) {
>> 			pread(kpageflags_file, &page_flags, sizeof(page_flags),
>> -				(paddr & PFN_MASK) * sizeof(page_flags));
>> +				PAGEMAP_PFN(paddr) * sizeof(page_flags));
>>
>
> is_backed_by_thp() shares similar logic as get_page_flags(), I am think=
ing we can
> leverage get_page_flags() here.

I was lazy for this one. I will use check_folio_orders() in the next vers=
ion.

>
>> 			return !!(page_flags & KPF_THP);
>> 		}
>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/self=
tests/mm/vm_util.c
>> index 6a239aa413e2..41d50b74b2f6 100644
>> --- a/tools/testing/selftests/mm/vm_util.c
>> +++ b/tools/testing/selftests/mm/vm_util.c
>> @@ -338,6 +338,139 @@ int detect_hugetlb_page_sizes(size_t sizes[], in=
t max)
>> 	return count;
>> }
>>
>> +static int get_page_flags(char *vaddr, int pagemap_file, int kpagefla=
gs_file,
>> +			  uint64_t *flags)
>> +{
>
> Nit.
>
> In vm_util.c, we usually name the file descriptor as xxx_fd.

OK. I can rename them.
>
>> +	unsigned long pfn;
>> +	size_t count;
>> +
>> +	pfn =3D pagemap_get_pfn(pagemap_file, vaddr);
>> +	/*
>> +	 * Treat non-present page as a page without any flag, so that
>> +	 * gather_folio_orders() just record the current folio order.
>> +	 */
>> +	if (pfn =3D=3D -1UL) {
>> +		*flags =3D 0;
>> +		return 0;
>> +	}
>> +
>> +	count =3D pread(kpageflags_file, flags, sizeof(*flags),
>> +		      pfn * sizeof(*flags));
>> +
>> +	if (count !=3D sizeof(*flags))
>> +		return -1;
>> +
>> +	return 0;
>> +}
>> +
>
> Maybe a simple document here would be helpful.

Will do.

>
>> +static int gather_folio_orders(char *vaddr_start, size_t len,
>> +			       int pagemap_file, int kpageflags_file,
>> +			       int orders[], int nr_orders)
>> +{
>> +	uint64_t page_flags =3D 0;
>> +	int cur_order =3D -1;
>> +	char *vaddr;
>> +
>> +	if (!pagemap_file || !kpageflags_file)
>> +		return -1;
>> +	if (nr_orders <=3D 0)
>> +		return -1;
>> +
>> +	for (vaddr =3D vaddr_start; vaddr < vaddr_start + len; ) {
>> +		char *next_folio_vaddr;
>> +		int status;
>> +
>> +		if (get_page_flags(vaddr, pagemap_file, kpageflags_file, &page_flag=
s))
>> +			return -1;
>> +
>> +		/* all order-0 pages with possible false postive (non folio) */
>> +		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
>> +			orders[0]++;
>> +			vaddr +=3D psize();
>> +			continue;
>> +		}
>> +
>> +		/* skip non thp compound pages */
>> +		if (!(page_flags & KPF_THP)) {
>> +			vaddr +=3D psize();
>> +			continue;
>> +		}
>> +
>> +		/* vpn points to part of a THP at this point */
>> +		if (page_flags & KPF_COMPOUND_HEAD)
>> +			cur_order =3D 1;
>> +		else {
>> +			/* not a head nor a tail in a THP? */
>> +			if (!(page_flags & KPF_COMPOUND_TAIL))
>> +				return -1;
>> +			continue;
>> +		}
>> +
>> +		next_folio_vaddr =3D vaddr + (1UL << (cur_order + pshift()));
>> +
>> +		if (next_folio_vaddr >=3D vaddr_start + len)
>> +			break;
>
> Would we skip order 1 folio at the last position?
>
> For example, vaddr_start is 0x2000, len is 0x2000 and the folio at vadd=
r_start
> is an order 1 folio, whose size is exactly 0x2000.
>
> Then we will get next_folio_vaddr =3D=3D vaddr_start + len.
>
> Could that happen?

No. After the loop, there is code checking cur_order and updating orders[=
].

>
>> +
>> +		while (!(status =3D get_page_flags(next_folio_vaddr, pagemap_file,
>> +						 kpageflags_file,
>> +						 &page_flags))) {
>> +			/* next compound head page or order-0 page */
>> +			if ((page_flags & KPF_COMPOUND_HEAD) ||
>> +			    !(page_flags & (KPF_COMPOUND_HEAD |
>> +			      KPF_COMPOUND_TAIL))) {
>
> Maybe we can put them into one line.

Sure.

>
>> +				if (cur_order < nr_orders) {
>> +					orders[cur_order]++;
>> +					cur_order =3D -1;
>> +					vaddr =3D next_folio_vaddr;
>> +				}
>> +				break;
>> +			}
>> +
>> +			/* not a head nor a tail in a THP? */
>> +			if (!(page_flags & KPF_COMPOUND_TAIL))
>> +				return -1;
>> +
>> +			cur_order++;
>> +			next_folio_vaddr =3D vaddr + (1UL << (cur_order + pshift()));
>> +		}
>
> The while loop share similar logic as the outer for loop. Is it possibl=
e
> reduce some duplication?

Outer loop is to filter order-0 and non head pages and while loop is
to find current THP/mTHP orders. It would be messy to combine them.
But feel free to provide ideas if you see a way.

>
>> +
>> +		if (status)
>> +			return status;
>> +	}
>> +	if (cur_order > 0 && cur_order < nr_orders)
>> +		orders[cur_order]++;
>> +	return 0;
>> +}
>> +
>> +int check_folio_orders(char *vaddr_start, size_t len, int pagemap_fil=
e,
>> +			int kpageflags_file, int orders[], int nr_orders)
>> +{
>> +	int *vaddr_orders;
>> +	int status;
>> +	int i;
>> +
>> +	vaddr_orders =3D (int *)malloc(sizeof(int) * nr_orders);
>> +
>
> I took a look into thp_setting.h, where defines an array with NR_ORDERS=

> element which is 20. Maybe we can leverage it here, since we don't expe=
ct the
> order to be larger.
>

20 is too large for current use. We can revisit this when the function
gets more users.

>> +	if (!vaddr_orders)
>> +		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
>> +
>> +	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
>> +	status =3D gather_folio_orders(vaddr_start, len, pagemap_file,
>> +				     kpageflags_file, vaddr_orders, nr_orders);
>> +	if (status)
>> +		return status;
>> +
>> +	status =3D 0;
>> +	for (i =3D 0; i < nr_orders; i++)
>> +		if (vaddr_orders[i] !=3D orders[i]) {
>> +			ksft_print_msg("order %d: expected: %d got %d\n", i,
>> +				       orders[i], vaddr_orders[i]);
>> +			status =3D -1;
>> +		}
>> +
>> +	return status;
>> +}
>> +
>> /* If `ioctls' non-NULL, the allowed ioctls will be returned into the =
var */
>> int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>> 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
>> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/self=
tests/mm/vm_util.h
>> index 1843ad48d32b..02e3f1e7065b 100644
>> --- a/tools/testing/selftests/mm/vm_util.h
>> +++ b/tools/testing/selftests/mm/vm_util.h
>> @@ -18,6 +18,11 @@
>> #define PM_SWAP                       BIT_ULL(62)
>> #define PM_PRESENT                    BIT_ULL(63)
>>
>> +#define KPF_COMPOUND_HEAD             BIT_ULL(15)
>> +#define KPF_COMPOUND_TAIL             BIT_ULL(16)
>> +#define KPF_THP                       BIT_ULL(22)
>> +
>> +
>> /*
>>  * Ignore the checkpatch warning, we must read from x but don't want t=
o do
>>  * anything with it in order to trigger a read page fault. We therefor=
e must use
>> @@ -85,6 +90,8 @@ bool check_huge_shmem(void *addr, int nr_hpages, uin=
t64_t hpage_size);
>> int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>> unsigned long default_huge_page_size(void);
>> int detect_hugetlb_page_sizes(size_t sizes[], int max);
>> +int check_folio_orders(char *vaddr_start, size_t len, int pagemap_fil=
e,
>> +			int kpageflags_file, int orders[], int nr_orders);
>>
>> int uffd_register(int uffd, void *addr, uint64_t len,
>> 		  bool miss, bool wp, bool minor);
>> -- =

>> 2.47.2
>
> -- =

> Wei Yang
> Help you, Help me


Best Regards,
Yan, Zi

