Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D9CD7497F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611926B00CC; Fri, 19 Dec 2025 11:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1726B00CE; Fri, 19 Dec 2025 11:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492726B00D0; Fri, 19 Dec 2025 11:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36C296B00CC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:33:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A914CC04F4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:33:14 +0000 (UTC)
X-FDA: 84236765508.12.AC5DAD8
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	by imf21.hostedemail.com (Postfix) with ESMTP id DAD6F1C000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:33:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OVojwHFF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766161992; a=rsa-sha256;
	cv=pass;
	b=c90JBCeRVbg8npJoLILJLkaUP66UZTV6ci2KRCKNLb9/3pBKikurN5BGUmtCKS0JpObSVY
	ZaM4k4p0NFMTpT5eUEXQK12H09WTPjk1Gr1TOQfxek4SePNbuB+J6exr/r7hUH5ELhQpjJ
	OFTadvaDniiH3KNnSOkaPgiKMb0JoLM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OVojwHFF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766161992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLHMI/d6itRcxglL/eqZZEOHr4LLTOzqD1+FGjJAnNc=;
	b=qkdcyQXgB5vMmc27wfsfoABJiRbbZjuu3k3yMVKBfUcJinbWG4iG4aCNFNC9UH1RUBALI1
	tPucjdFL/C+TkiMFxtnl8bLQ61QSd1W9oWFm8JFp0Qwoamed28T62+NOQWVVukK4wUDhrP
	KOt0hxIXM2aHrVsL2CQtUBDxY4ybsPY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T8S+aWvPiLNJCrqTAyXWlbmYa1s8/hhmWvMyW9mF45srp9JiHObE/sJW4+Mx8ztyFBh5D1ylb49S+ZJxKjSRNDpVlDHKycNZmrHcTCNpto1hQeRjIjHBb0UZH9OGYitMm60zenp5QuQAQN9ETbEodBd8PGg0bZBNUvkl5QFMSMy63FCDWzhbWpZYRUSiXceTMpLJ9rDmffeCi5zb5xtiRSNPekUwoWTHFC0muAPwn11aHjfFB6Yj7YkFqH2dbVFNSt5rLZ6UwuC7gAdChAaaLewi65crvyaWV13gGJRHLSwr/pK6EA6ItMzCOArYy7xufnNsi2Dn3ndj8U3AL9XCRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLHMI/d6itRcxglL/eqZZEOHr4LLTOzqD1+FGjJAnNc=;
 b=fpYwInzda5tkRXq1g/TMKPJY51TydxU/3LCTeWNS3bDlFiUPvEG4/A8AJZOynDlA3jf0yJCh8Aj2amnxr9NdjVXLMmycFsmDhfhDAbQ7veAx0/mNpn7akn/u/feIOn/FCAvAgtyoO25WjJsJhFOevJgRPdDgp+I/KHLXQUn8t55l6MprazODe3SyM3tJlZYItMNTVUNjo3yMrnE52dMTJ1KgzKrQbdCgXycqK5eXHMQ903ycSbMqZKVXkI3hLdrwXEKhzUovJacapUuJfRcu82UQZH5OmTfzQf8YG8WDSw2p//Hex/UH/mUNQ8i4xcxleTQj+qfhDhyq8ZBSboyvTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLHMI/d6itRcxglL/eqZZEOHr4LLTOzqD1+FGjJAnNc=;
 b=OVojwHFFiAY0MVb24VeDxSu8e9OlbDM2hg/pUkDKOHtLw4u/wu04waROM94F23mryQj3eUFv1m9STZXS7ZhdP4wO1U5JxqVb9bFPsW6yujiqUfbCiMQhXCYy8dzNsXRyv0mnNd0vI7aIOt7iwO27iP8BdwrJMLpy+QCoQUIW95w95AeXlEgxLO4oMDvUYkx6StrUfmK0gfumitJMIjHA836JDJsDDWyg0F26NaXlnOqQsuOIUkB0RQmGAlOqYhzv1eabXWwdqhlkZIgbfCIyQ570ybD3j7VNpBX9E9idUtKksTd2DpSN95SSY8ei5ZFnYxszoNED0jsvGE8mR23osA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB5665.namprd12.prod.outlook.com (2603:10b6:303:187::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:33:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 16:33:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Rientjes <rientjes@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE
 THP allocations
Date: Fri, 19 Dec 2025 11:33:05 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <365C1F3D-504E-4FC0-9506-AA1E83EC525C@nvidia.com>
In-Reply-To: <20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz>
References: <20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR22CA0012.namprd22.prod.outlook.com
 (2603:10b6:208:238::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: ca3c111d-31aa-4bfe-c6a3-08de3f1c4a8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fXAPrIo+PRk/DLGCcq55wISqB1Wbk5c4UN1JK4+B6TVqjdmbX0UIMWRNuO5a?=
 =?us-ascii?Q?LvO2eex8xEY4fJUEI0PhTIUhMDLOz0XjLibdMhjojCSw1W/i7uYWx5IH4Sdt?=
 =?us-ascii?Q?jjAGDaJ7oLaErUTrFqk/jRBPxffuC+ei986eAH4DS/E7rLMX75E1SqibmsbV?=
 =?us-ascii?Q?ptayV9/02iz5EzqNJ6QfAdiajpzOkUFNbaN2TQWaZw++d5F33ewo1mcw3f/R?=
 =?us-ascii?Q?Cay8w+7mtaKG3VEXiqUgFFF3Q9nYmv2lwnyFd5WSOm3r824SOZ+ytKW0S/ok?=
 =?us-ascii?Q?4dQhZjLF7tQomPw3yAKdXF+0DkTQfnj2/tkwCFInPNata+YN45SFjV5O9GM+?=
 =?us-ascii?Q?chg0S5ojTT84PFctxIoPDMeXzet1Gfp6Qgkazh3FG3G+VSI8n5/wgDOMVFTF?=
 =?us-ascii?Q?8YPMpFmSG0yEagsBvS7cRmiuTe0PsL8tsPNwMcGnLIQ4+gjTFqHUk7lIViN1?=
 =?us-ascii?Q?jpwJ1yYcUowCX5Rr+f3xSkWlkWNTBCJMhPrzFxyNRrVOx+F3p0kUqxkIwkW9?=
 =?us-ascii?Q?7qCb0gaNV+A5vFk4pafOvH7YXDAsutFv3sMb2qSrXfdVGm4qro4X4k0vzAWF?=
 =?us-ascii?Q?161i6k8BfACrN2uyaTALFgX5rX6fMNQzmy8C7t9X5un4MJNvFEvFQi2un5Du?=
 =?us-ascii?Q?GwH88wfscPrI18HVpA9Ud80kJNOpKzPdEwVF4sVYa/pxDzDA2BoX66KHQG0y?=
 =?us-ascii?Q?0hWIQLyxPNwNgeti9j8pQHqBkgK49XhMzwmnyreMReeABl4kaVUmztOBWPqE?=
 =?us-ascii?Q?nln5aFwJvyghVxWfkabZhAYSXEK5N+Cpr2CUsr+YOY7876BNBVggTdFy1oSx?=
 =?us-ascii?Q?klySX/OGWj57wCVYpmmxGl8G8XaOK8IP4MfBDez2L+3T4DWk36VA3pKH2XF8?=
 =?us-ascii?Q?5eTYb2MkGGPeoOizI0euUbIG9+EeSfOeNrZES1gzyu+Ce4s5RPa8xcVAO0No?=
 =?us-ascii?Q?rAABKvhlAXpmDEN26LGMBZKvuPX7EYMhOt9Ocu+Nz5FW+sqiPcT/tVm1HMWd?=
 =?us-ascii?Q?GtmS9+sfbZr9EJ3Zwr3oV7nhGroJPWBjyzPmjnNHAJIwDhvTe3r4+ZrwNy6D?=
 =?us-ascii?Q?KKkG8DeXPf3t4NDtnAz9YXip9etbatIcvNts/vLoB6DkmbbF3CYjck5a4263?=
 =?us-ascii?Q?mlCQmnduLbYYgt+cHDkS57rNKAnQhD6NIuzPaxPqSye7oATwlWMMNie8T6bB?=
 =?us-ascii?Q?RHmjznG6xxBkG52tShF8uxAsXEFHT0JYliglksunMJexi3MGtOdweneyDwK/?=
 =?us-ascii?Q?HGgRM4kaDrkeh6oeliylGEUQO3tGwws0iNYmZUfC+WUnHqDolL3TwQ6J/tHr?=
 =?us-ascii?Q?3nraE4zCg2kMUj2NosQr0ZLOpZ37r+gE9lXxJV8LYtJ7d3miXet33N3a8Q49?=
 =?us-ascii?Q?bPUQVE1f2qcF3fKZQ1imWhkh7Fnm/T7I3hq1LQaSj8/T3KG8DWkFlkKZtDFz?=
 =?us-ascii?Q?HQQdpcLIkk1gh35SKCnxREsDAhGhZwDxzNHaKVW7fnFcUry1eJScrw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yR4U2vCAayWaHV1VYAAnL/Ikc6k8N8dMMVtozQnphXBRg9uI+cBeY98HqOAi?=
 =?us-ascii?Q?GOc80OEYS+H3kCUL8EH64joSHiDEw8WuLlXlRx1xIMq2rtuOue+dW0HWXG8x?=
 =?us-ascii?Q?9QiC6Tt5YgkEpsUNlem7XPaHaXJlJ1xbPLttjVAf7XEzONsYuLuZpO68HyoP?=
 =?us-ascii?Q?DosH+W3O3CQnce4/jp5JU2hZDBJq4pUVtVz49UtltlPJLNYQyy4SgjbuBiG8?=
 =?us-ascii?Q?CQ2Ho9RWCmfqXemKLtVlfhl50uWiDl16vFkOny9xXwcONZ5fNcD5J/c78XyV?=
 =?us-ascii?Q?wSnl6hIBndPeSTkACu8G4+/+xhTp1yZeGHEvd+G5nTLKRCBEfaz6o77IHX3v?=
 =?us-ascii?Q?RnoBOJrW3MfFidVPNgN4gpFQT5CZk6oQxtkYaXU2h+Z7IwjTnNiBW0/u9kpR?=
 =?us-ascii?Q?tU1IByANUMCAD2NoFFOkVhCRgU1YBbGhkFlnr9lvQAmO7uZWM40R+TFJjDs2?=
 =?us-ascii?Q?SbpgWO5O0kKILj00/U4kc9FeA1bVrKUDjpmPp/6D5ll7Q9M2WbTWEF/KBaI6?=
 =?us-ascii?Q?CC4NTyQvfem4p6ISJbc1NFFRSQ5f3Fzx5fumnjeNkvmWqK05xA/qiveSeVoz?=
 =?us-ascii?Q?lgVFgiZ+VkQKAk2KJNfm3LXqnj59nMIDRjD/1cxJFOnYT3kmI0Y7dZnnhnK4?=
 =?us-ascii?Q?V1Xh+B70exw1v/INGJa8gVyjTpt9qFBz5h4D4+CZjzKrrIsWX6IfUTlmyOb+?=
 =?us-ascii?Q?dszWD9dV1+XKLczopKEq70arX6iRVeVZpkh4VyuRLzUpzH/9exh9F+KhlT8N?=
 =?us-ascii?Q?OPs24QoaX5Z437q2MqbyWWDSxeVqzic3UV4bA1SXzEd3DgxtxslJyI84GewU?=
 =?us-ascii?Q?aI1G0QKQi8CTqQFlYBayPW9QwCdRTYH2t4NKLtTXcF3TyDqhAHOe05y2AbQh?=
 =?us-ascii?Q?reRCcJlVli8Eq7EL6iZ35G8xKv3WC8Igfnr73Na2S5w7qmrtGsPe3xrZyTVJ?=
 =?us-ascii?Q?kFvNIvvZqFUT7rGryZtxhCeFXmJnI++ksY0QyrigtfcH6zwjWYCE3vLqoGuD?=
 =?us-ascii?Q?z8e47zGuNtWsVeQmof1KPQKgj6nVr0VcexJJWd6vuxlXJtV8PL6vVk1Xeceb?=
 =?us-ascii?Q?pmhfPqKPUk8J8+4P5ak8YOcvu5QEhYuGgYEkqfyi5dkWkLyeqb9JJTStg5qB?=
 =?us-ascii?Q?xrSKiTHSZXpuiZTKRNBjkpxQ+y5pxUHJFJda7Ve8Vu4TUv6VQaHSPT21ikFy?=
 =?us-ascii?Q?MfZwFqLuJ62GL/UkzNMLkmNplSPLogKxzomrhiHpDbG4j768lzrpwCY6zfBy?=
 =?us-ascii?Q?ocQ97m6j2IXXeXQp5kFWokntZf63t7IXE3j0Z7i2FQ2d5fYQccwEgJm+VVh1?=
 =?us-ascii?Q?F+oxL/b3yv2hm10Ajw46218qTydqLb/eAL4WKai9x7LM47XuEvhjN8staXvp?=
 =?us-ascii?Q?+IaMUVspfG0S7thfm8DJzBAGA1ygCTdla6U3nyyie7yuyRafPVw+SdegelUe?=
 =?us-ascii?Q?5H8oNDZ0LbY74pM8FssUnyPwX7hqkJH/BqiU/pqX+xMWvz25VOi5/XjSuEV6?=
 =?us-ascii?Q?OdVRCvoZ69qJpSVCTh6fVY5OBe5sHoU4pn+EIkSSt1X3pp76V/NqJjoOQhRd?=
 =?us-ascii?Q?3tk8IcvED7upQrhkXJ4iN0SnLwVFi8HfdBSixcdGdwUwGk7SAQzaCLaLjPGt?=
 =?us-ascii?Q?FXoGte/lYElIF96cNjdr/H6i4LnJ0OSZ/7D/c4jvQnWehQD/LHzKmX4pUG3G?=
 =?us-ascii?Q?XgDIhwdE9IYAyWs04zC0f9vP4yPSchZRtofgipV0JPHaqHFd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3c111d-31aa-4bfe-c6a3-08de3f1c4a8b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:33:07.7269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxwdihXYb76NZdOEmxSIzhZ2ivs7v730bmVpq692RBkwp4aH5MBZtkcI5efQTrkp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5665
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DAD6F1C000E
X-Stat-Signature: cagcytguh7tthrw3owec8ppa1yqpmma1
X-HE-Tag: 1766161991-985771
X-HE-Meta: U2FsdGVkX1+cgghRIuiTnxDFD+8JcNMxxTlrNkqezzKpLSwyNFqyt7Ie+wvV8HDgxtdnVyRfIN1Ch9aEbx/0qoq0d7LSO9Lf4ovo9eOId4fuh4EP/R0qZJFtcxPGABGbNABjKXF/X7bvRzhwvBcBVXF+4Lw85Qz+OP41ECrnKJJhKfBv4DL8yYW8tt1Gbq/JwbsGzqj5F+FoERgtxyi4M158Kn/V7c7utkNb0Sj994o1RTUEoefiaXP91DC0knS9XuuE2irDfa+E3ot+us72D8AqsqSt00BlCep2vL4ejJux/pk6AO6mirUNlWEPijZ6127zujCUr1AYlBRZNNW1cYtzIOQtcO/2Uk5jqbfrmuNXU4aKTlB16CxdFBn1DNIwQO8dTxiTzDctjLGeCxLuYFfJZ4UfkMO4rTw3AmbEoGhpojK+Ku4k03ZQIdYuoO4qGu5KSvqSFaYSenAKlTq+sxnU6XaBT6t8VowG49u6B2eoNd7LNiuT4ZPeg+pbh9LMOVnFVATD66tySNlJ3ZCthiV69KiFWOceUldbIFU2U/NLOe+rOojREXOK0UfKZuh/0XztadrDSU/qdUjRAFXT8qkRQ8RaibQh3FabZ2qbeAhzFDOHijvxz4aogxerGp6zPN0cevArLcqZEz0nsSfQ4M3Qy6/5CJT2D3E6OBeQfuXG899O3JUoy+0g0J51gB0a2e/UmWBE0L80aN/LBwcnJVYTv/8WpwEJ75qjjCtuujn6QjKTf060xq8HV+u74Qbm5IpRZrkUeuSlxp5no73nyszHj6qlwg9vBg6vab5y7sL2OFH7QCFiiwHHH/4xiBhHHDu+6YW9nk97l0ZVb6/yBKoQEvnYekYSU0BivC/ue3shiZYThM+yUh1x2WlSa6vJjmTG5vGDrixzmAEXTdwH7vwE/Xqc90hcMFhdMdyTOgY33OMMu+ip0De9ftsyDBnZtzVhjPtrkRS4SNen3jZ
 fJ44XOFL
 ftKYDQ2DUA4j5Y+3Ooodq/rAKwlBiSFaT2cYu2T1awA0IkWGcBBZMj8kCSfPTCB7GuRPaYar9f21rpNVVzAHKi/SBGtSfknkGahdHN+nwvSH7RLWOqPKJkBdKAPUncJyILrwX4aTVAMH3mSeJ1eriFjCVyrQorQLvPbv1r6VEiZdYDyvtENjHWv2sWJr/TFvBSU7qe6XEl7/TUSU08uUGGLZyo45i9asnHQ/6Cif9rOaa4e2VKeftDM1BP0NePuYXYSeI+RGl/VSFLEPUUmSDfTwQ4h72d0jHJEEHyRmFuWovhK48ALw67AqqDTZ55Lt2+HQIbvYWOF/wt6+77/bpNWMbon2BbUlTJyQ1pP68ZGapWAHBsRjCNISywLOSg99t0YRnWUZAGAIPFOw01JqNxSv2xzzlxiQC9GITIAVmQcHJxErEjRtcEuRik699QaH5u1WV1VDsEzVYIIRngenaHgtJ7+F2MWsrC2Opu7TsKQlXUKdLGjMRESl7ors3pmyEmvU876gwKwxlDRxxQ1SajEZwychDqHdp9g+G7Pi/q5iwK5rHSoSFeqdAW+sfFL6sII7DbNbxIjNionAuqaMyh7uRBsBI+Yd5mV+bRmw9suuy2pMMEIiMYxMY0kEy9ciPM6RcS2Qw+d6ogXw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Dec 2025, at 11:31, Vlastimil Babka wrote:

> Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of=

> local-only and all-node allocations"), THP page fault allocations have
> settled on the following scheme (from the commit log):
>
> 1. local node only THP allocation with no reclaim, just compaction.
> 2. for madvised VMA's or when synchronous compaction is enabled always =
- THP
>    allocation from any node with effort determined by global defrag set=
ting
>    and VMA madvise
> 3. fallback to base pages on any node
>
> Recent customer reports however revealed we have a gap in step 1 above.=

> What we have seen is excessive reclaim due to THP page faults on a NUMA=

> node that's close to its high watermark, while other nodes have plenty
> of free memory.
>
> The problem with step 1 is that it promises no reclaim after the
> compaction attempt, however reclaim is only avoided for certain
> compaction outcomes (deferred, or skipped due to insufficient free base=

> pages), and not e.g. when compaction is actually performed but fails (w=
e
> did see compact_fail vmstat counter increasing).
>
> THP page faults can therefore exhibit a zone_reclaim_mode-like behavior=
,
> which is not the intention.
>
> Thus add a check for __GFP_THISNODE that corresponds to this exact
> situation and prevents continuing with reclaim/compaction once the
> initial compaction attempt isn't successful in allocating the page.
>
> Note that commit cc638f329ef6 has not introduced this over-reclaim
> possibility; it appears to exist in some form since commit 2f0799a0ffc0=

> ("mm, thp: restore node-local hugepage allocations"). Followup commits
> b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction
> may not succeed") and cc638f329ef6 have moved in the right direction,
> but left the abovementioned gap.
>
> Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations"=
)
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> This is the patch 1 taken from the RFC [1] with review tags applied, an=
d
> should be ready for exposing in linux-next.
>
> The rest of [1] will be another cleanup RFC with changes according to
> feedback and likely to result in more discussions, delayed by holidays
> etc. So will be posted separately so the fix is not held up.
>
> [1] https://lore.kernel.org/all/20251216-thp-thisnode-tweak-v1-0-0e499d=
13d2eb@suse.cz/
> ---
>  mm/page_alloc.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

