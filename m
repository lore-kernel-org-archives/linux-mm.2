Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1C4C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 21:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1679000DA; Wed, 13 Aug 2025 17:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B956900088; Wed, 13 Aug 2025 17:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A87A9000DA; Wed, 13 Aug 2025 17:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E94DB900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:59:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D1FBB99D2
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:59:06 +0000 (UTC)
X-FDA: 83773100292.03.CB3D9B6
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	by imf13.hostedemail.com (Postfix) with ESMTP id BF7F820007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:59:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AuLjbs0X;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.75 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755122343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YQMqWqypbzImJevRAd+OajkM+o095f2467q4tvTpUI=;
	b=GIcNujAk0oWapRUDdpKOi7ZteKu/c5ajayXC8OL9RJL/4Wrf54p+HV6aV9kMRPoGu9GPhR
	EDNvQaLyk+a/5dVPuDgzTPJ54kIgjMh5eeQMy4Q+LiMsnNM94d5D36/Pjdx8hrffACtbM0
	DhX8Eav4J6+uF/RjO7bbsuFKIXIKk3k=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AuLjbs0X;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.75 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755122343; a=rsa-sha256;
	cv=pass;
	b=al9/Zx+gqwu9KvalV3EeNNNX2KNGKEXe+bMFUG88BlZkApSuEJidMEZQ27oGhegELJayxF
	WhTrd8Sxi7/V3+YvPXxAKTkFoLS1f3VjDTXhI276pnh2kQWJbwwvUT0uNde7MlaFTXnrLK
	xKEyzYibA1GaG4wi9xTh66zoJxWx5XU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJxbYLKZdB4A8PUI5Gw0Coa/6lVj/sECuzVphDq6+0nbXA7GdaaEKo64z+NjGyEZXZ3u7QHGmn8tYyQAd4n074/JZmt5FR9hkC5/GI6FTyKR88kzPF2Vbg3Nh9UIk/XLNiR5H0gwpzG/VA4Db5IJmDIUT2Ux4H4tp62Y0Aau5dRlxizjGNBQa0ZOypMNQ+VtsFVorLg0VfijtQMm5p/RSckB9FG0BWuUAtIXS/sWOpAPT9adR4QaBEfssBQdthBuBAyisPKOgSJ1KHXne3R2CXdncccdwSKtTBUvfSTQVLEUoY5ktqwCRKCSiw2wsJqososxd3D+1OaZsVishu31qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YQMqWqypbzImJevRAd+OajkM+o095f2467q4tvTpUI=;
 b=cLb7qoneGcFEfzPChADGiq8B5YCTYTIB8wmkb7qpi9g4YF5L2w+wBQNNFmWZKiU6FJrMa2nf/H7Jdvkq02qCNWr0YAcnRFcsT1iowhSvv7q90WmflXN3BED5q00nTKBeGzHlUn0wH1hWGHKpPAqmmJsFYr1knYqu8zE8DvrBp9pbu2pr2lJyZBOWKn+CmjqEoPA2YkWKHu8kA9tleebOcAeiBtQsToouaDlPdsmbby1M1Hm4H5poVs7kkruZGMJdaFSFPb8h+AN6I0fSNJOlXrLObzUFhph1nQn6WmL4WjmQ9OaSgrejf78yzuMkTKTmiRKV2div1v9o5BhA+eQcgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YQMqWqypbzImJevRAd+OajkM+o095f2467q4tvTpUI=;
 b=AuLjbs0XI1ENXFlQ7mWnUZ4c7Ov7SF4FgPgWH1iq0s57auqgDMTnETh137xggpfwF/A+1Iqze/Hzv6e+TSWpMzXn34Bh54o6xPw+l6szsEhuu6Q2qb+J41ex7hZDb2b6zUCh9bH+7CoqY9e4bA078iYswiuNd4FtK73fwYH0ZsykFqfKR2kq0xBk65XcqYtWt+R/Zl5pIZvfhad7rppBT1+YW1eY1ONdokcSkGeLz7eFLqmBlfmmB+yNTvFvIVwNqMOi2iz8GeytZPLK1uPr1F6l1bh0pl4KZk7u+se3kKbSxyW9Sf3TGAuAdINxDYSUmCtr4BHGZo2qTJTKNm1Qpw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8780.namprd12.prod.outlook.com (2603:10b6:510:26b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Wed, 13 Aug
 2025 21:58:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Wed, 13 Aug 2025
 21:58:59 +0000
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
Subject: Re: [PATCH v3 3/4] selftests/mm: reimplement is_backed_by_thp() with
 more precise check
Date: Wed, 13 Aug 2025 17:58:56 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <47433AB7-58A4-4791-9C40-431D8573E26D@nvidia.com>
In-Reply-To: <20250813214112.tarr5rbamtc6cmie@master>
References: <20250812155512.926011-1-ziy@nvidia.com>
 <20250812155512.926011-4-ziy@nvidia.com>
 <20250813214112.tarr5rbamtc6cmie@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0327.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8780:EE_
X-MS-Office365-Filtering-Correlation-Id: 722a1e39-493e-47eb-c4e0-08dddab49b75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ki7ii3QkMDCx2Sm9MUu4pgGwe5Fgl2vFKhQWwTScg7Bi5fM/VBZMiu7ZAhEl?=
 =?us-ascii?Q?laixqU5kGgZqAHLfEXIQD5PLXv+RoT1WTQ9Q8clFc7RLlVIVpnJsx14uA8Z8?=
 =?us-ascii?Q?Hw2mXhbIwRyE6ubSQ2qML3dnYICfcwCRmKdF+4EB2ezlxIF1LFnZUaa5DxFg?=
 =?us-ascii?Q?8/1U029Itidd5yQPE6NJVkQTjlHfxu2u/kPu88KIHBvZSQ4McVdTcDcGSqRN?=
 =?us-ascii?Q?sNtdMKSNsNjcrO23WN3Lh2JT59z+L/s/ATst8jnEl1hMbNRlSl35F+snHELh?=
 =?us-ascii?Q?6yWFAMeUnC3bYQLat5BHezkljvOY+8hQ71sHqtt7Kg91gDIQ3uDRw5tvPIRu?=
 =?us-ascii?Q?TTiU9ip5Y8Xfo/qSvYynNSFW1NxQLX1eqL5Hq+XFD/V2E89Cj/0/pD0YELeO?=
 =?us-ascii?Q?aX1/cXf0H5AEKOkD/8cu6rpJUHQdi3T1mkF9BaQfXzEtN9o8fWVOXPzWSMhP?=
 =?us-ascii?Q?N5XspHKkmuzhQNpPS4i/1Ny/qcdOXbbRGJCAEw1C9dAXPhRprOaCnM6NGE+0?=
 =?us-ascii?Q?YJRz7dRdJpb/Quxk6eoQqhRIX1TUyErbggxqHxsnxjXhzQ0Ygymx5puWSXf/?=
 =?us-ascii?Q?p3aaQnUiKJhZN61A4kdfbNd/Y2+QEXMdHbtHaFooXF1aspYNxlNxF/LKvph0?=
 =?us-ascii?Q?OxEmp9cb3+4mNBwOaFSxz+htJSjYW+LtAnv3BxHOj30AR5k4SQGqy/av7ERh?=
 =?us-ascii?Q?r63j5qsGN3JzzcUCBcfvBdRLyH+pMikTDCBtlU8mI2TokHXKekgDj6J4oixn?=
 =?us-ascii?Q?jNJR+GqgC44CO09S4hnJTDZMT8PJg8gbPVb0wDd9LR1T6ixOqAnH3mxjfg5r?=
 =?us-ascii?Q?9HqlTMOj6ifJeFhp/ARhRTnAXzVerXlEtpG0GC3D9btoNUtt3p0UZdg9pydE?=
 =?us-ascii?Q?Q1LcOusBOcQSpB3tiRe3AhjQpN5q8rzkJd2S8BOtLBvomyJWTACXtIvPH9WZ?=
 =?us-ascii?Q?q5LHmZQzZOW63iKaOVS+zISoqkgTLfAI2f6DcYha8ZaE5sB83qApGr3Q1hot?=
 =?us-ascii?Q?r5cDQLcy+/Vq31oYRCAfzXHB/x4YcNDms9BQQIqzFMm4FglKESR7w2iDMbF/?=
 =?us-ascii?Q?6fYsalJ7pbQqzEfdTRjyG3hIpntA1GzJErBHNy+jZ4c5pewbFATj35TigXWF?=
 =?us-ascii?Q?xgBOUW0n233sqwtptXHFA6+KK+/5Ty8JVaobu7ssjB6MUMwJBLJHIU+/82Qd?=
 =?us-ascii?Q?Qs27kxyX5McuLTjxVXpSqVcQ6biHIWkTH2OpEWUSKXdjIQOjNiLWVszAfnQF?=
 =?us-ascii?Q?FhkN0IZBkxprPFNdZLntxzjtyehwN/vQ2yJmBKzTf6J2ycaV/Y4n1Vks1STk?=
 =?us-ascii?Q?7U8PufD30Din8T87FaJGJOsrWPMfCKElUIhdcSz96XEPlA+eoGyV4gXKXtxL?=
 =?us-ascii?Q?tdvVYkTqJYFsfCjq2jqnUOcHCGfFThs9GX3VrJWeRoXKItFv/w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1s7o2liJCKEWj7KCWfKmWHKu1hQmfWfn18scw7C30BngYQSKi3hLycQksxMc?=
 =?us-ascii?Q?ouYBXjJ7Qax5LPGSXJdjQko/UIxMKqCp7MWOQEoABP/YLk94PYu+IytSoTB9?=
 =?us-ascii?Q?yIAImDXehzNUBn+lbx1cyeL8cS+lV3WAbOc+FS2x13Q6ct4mJVWxbbXVD4Zx?=
 =?us-ascii?Q?k3BSryimfXzvtvCVnL19XLPTZ1upNDwOiswr+awTlKcJQSNsSSJO77dNPAnS?=
 =?us-ascii?Q?BoGNlhCqpP3evM4XXYtRXHxjoLCgSYZmnzqgbD89wzv2P+VwI+nHGU5r/gRz?=
 =?us-ascii?Q?AFoAOHOjmP+H4lS4HDkkbnId+oNW99rbrMFLtEn5wS9nxEi3sl7b/SGnhEqd?=
 =?us-ascii?Q?Vv2jX1kTp6finGK0RIhtdQ4rCoRyXvUHSMUsZhDsKNeNxWDG33jkGxoxqJL4?=
 =?us-ascii?Q?3NLJV8gNxcz0f6hcbdk1I1MGguGyitbSoqp3cShJhQllO3LsuI7wzWiilIay?=
 =?us-ascii?Q?jlF7CRewoos5JTFEzoAhG+lTCbOa4Yq+aJYKfGQH1YlMUmDmjpXWNEdIcTTV?=
 =?us-ascii?Q?W389jYblUthgmIvyZgXPjNXxyjNsvqmvrgkISWbovkKNZGFc1x2Tx2ZBdsri?=
 =?us-ascii?Q?arUaUXv9JxDWKFJpC7fG1X25mcQgDaWBDzpK9orSKsYTxgYyi86MSwTbzfAQ?=
 =?us-ascii?Q?oNO3d342A/P+fi+JoqDGBw8qKNejnpvC6vVkL3LbPmjWyeUtiY7xAfCVwKoW?=
 =?us-ascii?Q?lG7LEMh1U2c1OMetdmy9pk5MKjOLJpZfuVrNIG5+Pw+CIObAC1bMmcVkPZo6?=
 =?us-ascii?Q?tEGrdhbhydA4q+IrkCZcTPuAnp+UO9vJNFoquCIwJ4Hw0e86TJkTs2zJlR5q?=
 =?us-ascii?Q?SGYXlHVDNcmdDm7WWvwGQ1foFkeuY3lp4FHrCVbAVjXjRPQLbuheQwZCP2H6?=
 =?us-ascii?Q?22UlghR/cCIVGGDXsJcNuRpJvCwSCdKrRTHnn/Vi1ClIGK5k/7Aapb9Z746s?=
 =?us-ascii?Q?fVMMj0ivTT27EEHsaFEs37CzeqaP71T4QLK38JzhdYNkp00dwqwCpt71ZqhU?=
 =?us-ascii?Q?Zx0bxePhhqtHVn9rP2lTUIY2lp6HF0prAz+2iv8khpdtWo7mAURF6p/MxswE?=
 =?us-ascii?Q?jFrzRctYVhW5c9ycPFXYlW5GhWtXSVnFxAcb4+wlG/JUpvTfSeK66/COAj4N?=
 =?us-ascii?Q?3HVD0BpAH+YjhJa09PEhBmUk6rw6tNJ/mFUdzfcuLBehrandxfNvw33AhDxQ?=
 =?us-ascii?Q?5pGIl9Xqh8UgSOmQJFl3uEK0vTbVN7Mt/tWZX9DnfqbFSWRRwKw8g1EPdZP8?=
 =?us-ascii?Q?J44MELWpFpq6zxwhbC3DlsJRbK3hdpAgKdDiSn0dxFtqrHN7wZpw3MkJr7T7?=
 =?us-ascii?Q?arOlEf+6pM8a/HH/9FzU55+nlZssfZBw22JIwJbX3kdy7tnQwhfKcJDJpmS4?=
 =?us-ascii?Q?dPgCxp/dqkPby0zhwXHdmbv7XGJVb7SLihZ8GQXgcppfOwyX5xqD8v+a3sBV?=
 =?us-ascii?Q?+rIPOxhpdMD0k+Ub5UOB0MGMWVASeWwKIOf+hVyI2OWKDlIbP8L0h7RTlGjR?=
 =?us-ascii?Q?BWsK+QPJqU07mfEK1jLFaI2hyIRl2jQTWSdu/a+pDZhHKbo6apkjXjcdzbAg?=
 =?us-ascii?Q?pEvgCFLaPtJMIP1GsAu4pv+5lOqbdf2JvC1Q6rrd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722a1e39-493e-47eb-c4e0-08dddab49b75
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 21:58:59.5188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRYiAE5yPub8W6zRBOH5aq1rYx+EjEQZnIbJY6JZ/MARev/4zqfxLeCbDTcV2N4s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8780
X-Stat-Signature: u891np6ix9kqyysteabtse4sps8oz1bn
X-Rspam-User: 
X-Rspamd-Queue-Id: BF7F820007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755122343-41252
X-HE-Meta: U2FsdGVkX19TRrQtSIJdp+mAT1juoyWVUaLopZ1w0r7/bZ3fPrAQjiqZ9eiUkQVrqU1a/xCmYsqHPr6mA/sIitUPL7lQPLlX3sY3GmDmVFcE4yKh2xB0Mv1W7DdLLt0ytrx0dhz2Li1tD3MZtS0tRs039uaW7wigJuLEcD4fgIW7dveJOS8e0jV/6jxbuCxy5Gk3N3JonlZNww+/v9BXpsNKfK6LwkCKEaX9Srjyk0hwPYnDhffUzIjFl2zAGgGnFJL2DS5eiQMzQjB0PexYtQ6CGrhYMOyx0h7TY3fmc5WaNPtZ9OT61dYHHRmcRXTc/2IexeuDLjIR3cfAdeo2cnlrL8jJUM2HZI9706Nw9l3kKiOihjpb11b7eBfvg9lSAdAAKYj4kVHTlazWTjk4lUfbPhuAE1pqXd9U+4lLIgFzdsmoaESqzFTadoOTLIZtL5bk9IcYWUA9zqIL8Qh78DAOh/Zq+F/f1ktEgNN41LVF2vWIxNe4B27L1C37S0e59c2WLSWRbM2Swzy1T1NzNipEKW81KldK2RVFc6ZbTTBfJkZ9eA5joqhfkW47y6QYwRjinL5PhWEj+Dm/2f3FrEIZdiJjgkgkFMVgM2Gp1CPsidSG4133EpVlhFK+wDxh/ENY57MH4t+4BkDnR6DEGm8Li4Seqtc5vqfc+Dj7/tDp+JWEIrjZCVwk/2DjLPGrf3p52ircxACZPUcku5YLk0lybRfgsTnSlmFInuN3q1K6PFw8XePHYCTnuLC3QqV4aFolAhcprIWGm6/jDoUiWFm43X+nPrEb5l8Tsn2Vz5PN52QPe7/Cpn1oL2OAnyeZUu8P4Vx6/zZr+F2TJwY09PZ3RTcI0YSGD2BMBJ7jKys/o/iQkVmh/5H0jQzUyfQAx9E1s0NSXErEyuU6VNMXiS/vOsN2xI37nZlJchNn4NkMt4KnllRBgA9zASg7XSGMWNLNci7ruH3gwPCPz6Y
 TWrSLnK/
 s3AO4b1qPtn8skzZ9541oPmwPr9O4ZsEy3OTuLP1fKyd8g4cTb5HxY6cu+SFbAyb6MJKkHJutwYTNXwYuGA01poqrzkQsjYEOoQLnOyon2cSDIFG7GGO833dufghn5mehNN6JmaKOWhVFCQuD2nQniaxxaWTa3WY23bTzCkil/mW7HzfM/Bup6M9YzM8IqTmN5XfApIBrCY7qvSkm1eupvsjSrhEisxRx8o8f60NSerqRqJjKO06uAY3yojdV/eYE2RYsV+ZumVA+YIYNO7WUV5QdgH6Z2IitgRmfFKhC3kshb42t5O9vbRNlwUS1SlKU0SUA1bF7FOYn+q/oVyM1YRg4lfwu6KUYsASC41z0SsbzM+YbNic7K8g0C4EzbNOCveD7NyvRii2a7YRFNmWEUvjGZZ3pr6KA/OP+22qh6yI/RgJdROLrxPW7k7lUjhLId8pVVgmwjQ2QrGCpAgwd19SSvl+nGnzitRMmCIOrzDWJvT6y7dJz1RvUzwox9y5XQcHh3CGuqpK+VqZ3PUZaj1T6dKnQRUH6rqol4P+cP9qV6voFGeD0PJDMN8p4rpAPkN1poAFnQCaWzA/e/nT1mD0TqdGRJ84j5nhX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Aug 2025, at 17:41, Wei Yang wrote:

> On Tue, Aug 12, 2025 at 11:55:11AM -0400, Zi Yan wrote:
>> and rename it to is_backed_by_folio().
>>
>> is_backed_by_folio() checks if the given vaddr is backed a folio with
>> a given order. It does so by:
>> 1. getting the pfn of the vaddr;
>> 2. checking kpageflags of the pfn;
>>
>> if order is greater than 0:
>> 3. checking kpageflags of the head pfn;
>> 4. checking kpageflags of all tail pfns.
>>
>> pmd_order is added to split_huge_page_test.c and replaces max_order.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> .../selftests/mm/split_huge_page_test.c       | 67 +++++++++++++------=

>> tools/testing/selftests/mm/vm_util.c          |  2 +-
>> tools/testing/selftests/mm/vm_util.h          |  1 +
>> 3 files changed, 48 insertions(+), 22 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools=
/testing/selftests/mm/split_huge_page_test.c
>> index 63ac82f0b9e0..3aaf783f339f 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -25,6 +25,7 @@
>> uint64_t pagesize;
>> unsigned int pageshift;
>> uint64_t pmd_pagesize;
>> +unsigned int pmd_order;
>>
>> #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
>> #define SMAP_PATH "/proc/self/smaps"
>> @@ -36,23 +37,48 @@ uint64_t pmd_pagesize;
>>
>> #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>>
>> -int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_fi=
le)
>> +int is_backed_by_folio(char *vaddr, int order, int pagemap_fd, int kp=
ageflags_fd)
>> {
>> -	uint64_t paddr;
>> -	uint64_t page_flags;
>> +	unsigned long pfn_head;
>> +	uint64_t pfn_flags;
>> +	unsigned long pfn;
>> +	unsigned long i;
>>
>> -	if (pagemap_file) {
>> -		pread(pagemap_file, &paddr, sizeof(paddr),
>> -			((long)vaddr >> pageshift) * sizeof(paddr));
>> +	if (!pagemap_fd || !kpageflags_fd)
>> +		return 0;
>
> The same in patch 2.

Will fix it.

>
>>
>> -		if (kpageflags_file) {
>> -			pread(kpageflags_file, &page_flags, sizeof(page_flags),
>> -				PAGEMAP_PFN(paddr) * sizeof(page_flags));
>> +	pfn =3D pagemap_get_pfn(pagemap_fd, vaddr);
>>
>> -			return !!(page_flags & KPF_THP);
>> -		}
>> +	if (pfn =3D=3D -1UL)
>> +		return 0;
>> +
>> +	if (get_pfn_flags(pfn, kpageflags_fd, &pfn_flags))
>> +		return 0;
>> +
>> +	if (!order) {
>> +		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
>> +			return 0;
>> +		return 1;
>> 	}
>> -	return 0;
>> +
>> +	if (!(pfn_flags & KPF_THP))
>> +		return 0;
>> +
>> +	pfn_head =3D pfn & ~((1 << order) - 1);
>> +
>> +	if (get_pfn_flags(pfn_head, kpageflags_fd, &pfn_flags))
>> +		return 0;
>> +
>> +	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
>> +		return 0;
>> +
>> +	for (i =3D 1; i < (1UL << order) - 1; i++) {
>
> Do we miss the last tail?

Yes, will fix it.

>
>> +		if (get_pfn_flags(pfn_head + i, kpageflags_fd, &pfn_flags))
>> +			return 0;
>> +		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
>> +			return 0;
>> +	}
>
> If this folio is larger than order, would it still return 1?

Yes, but it should be good enough for current use. Will add a comment abo=
ut it.

Thanks for the review.

Best Regards,
Yan, Zi

