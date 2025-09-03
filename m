Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C89CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3088E0010; Wed,  3 Sep 2025 12:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8ACD8E0001; Wed,  3 Sep 2025 12:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0D98E0010; Wed,  3 Sep 2025 12:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0C98E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:30:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5766311AABA
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:30:02 +0000 (UTC)
X-FDA: 83848475844.15.0837EC7
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8D6161C000F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:29:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HCZtbJmn;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756916999; a=rsa-sha256;
	cv=pass;
	b=NeCWcQsDP4yML81vleWSLcXYQLBMQGwPVAxN8yv6eNiJ9yrieZOlXTrxXGDj4XpueOeVzb
	RtrYuqKsp3iWsI6KFCY+QAczBbLeHXhYiIMd9DoCxhZX5Oxce5r/cwMKHzPcn4FROyPldV
	epjO64+1zs6gDq4lPQktNPGla0rmiw8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HCZtbJmn;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756916999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OjmunQBu54e027PP35ODtznCf71kKyBSfpoliEopJo=;
	b=Q0CO5p7C2iGk/q2jxbwcZjxFKOnewV6k2ZOnTSzsp3pCXZe1oGsG4x1aNkOVX+SBD5hzeB
	Ej1EppymzYM3h5VlfsDRW97D9xCcVPbSTGTLlAKZs5UrE+eXk/0dRvahIRW6xg8QXLtD/n
	US2LeuZoZQUw27yEBxKCgyJbq6ChYsY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ga6ryYl78bvKvnF8Vv/wcCsFcQ3gg7m55Jura53Yt52Q+UGm8d3NzOvCz0j6uEvT1mx6yx35QTmjRyLtpUpKB3INJpAxQbgHKnh+788LO/W0Bt9/5CHpWqCO0hJ9ESKxq6OZX4QqhDAB6JP0ytzGCDR8sAQvIfZzjvhxENppbvZSodQG9R37mBVdG2zl1pScOS12wpIYxqtbf1u0M83T9I54KaCSnBYQaQ3ORF4X04se33TCaxUUHwiy6wIuc6wBuFsXzj1CNLS17FW+TisK3l4o2UuOdwdLt4DPTyj5JuIZi+OwuQTpNMrivqhc9bX7bYzkAOVfUENnkIQQOnrbkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OjmunQBu54e027PP35ODtznCf71kKyBSfpoliEopJo=;
 b=uxHSm7jT+u+TNt4o+cCa+RJxmlOqneqwxjwy2Wi1MilzC0s2wpsjbnKSAxNBvw9ev1IEIpSJcrd24yGLifhTTKoDpulAYViim3K7CwPukTbAKhQORf54ud/QhQ9vGXFO5sNgN0RlN+1lijx2WNCnCbuVnO/5skA7AOeY/KT6Eryqp3TytJ18/xLoYKds+fhZZcnyBZLw2ndj0WFoPKCq0XVzvV417APaW52ME/5yUn/NmyjQCq6IHGJHwFuAJVT3ul/4tAU6M/qZNHPldmuhpkWaj0a2xhdY5xsYupaY3DCf8koOvgoxJRXtj7PEPp3xfLzCsiiXY2cj9S2nB3yQQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OjmunQBu54e027PP35ODtznCf71kKyBSfpoliEopJo=;
 b=HCZtbJmnSLS35UNpb8BT0Okv5/PlIgBeDQVEqCBlUAQv+hAZ4DRtJlmeFoPmFLUeVwR8D1B2hDQ6Fg7by9k0Mb5qsFZWmbgQZCWQ0UBnrAq7iG8zEvGl3kFCINpXcdehAhONz81rbJjBTPjeHvea/6EPYOodckE++aJnZEws1w4psyxjhG9Ok6dQ/3IbOBENHpKyLG7KxqVxBir90DL1/oOg8lPplGyEdjrAHIOVzHxFkLCT4aYpaMS455fXRI5RxZLhzggfumfhqDHEr6nGsdIgaEtpnptrAXTkyhHDHPD6WY69VgKRQy1T+1aEktYeh2CPymJ4X8rDzw6xYOUNvQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8850.namprd12.prod.outlook.com (2603:10b6:610:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 16:29:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 16:29:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>,
 linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling  before printing
Date: Wed, 03 Sep 2025 12:29:51 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <33E58899-F5E1-4E24-B830-A3E914331083@nvidia.com>
In-Reply-To: <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
References: <cover.1756897825.git.pyyjason@gmail.com>
 <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0567.namprd03.prod.outlook.com
 (2603:10b6:408:138::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b94b76d-491f-4e5a-0618-08ddeb071e88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LAc7JlB+0gimUM7SJMhTc8le4IwKCBDCCSV7xD8JOsSbXWXa6YTPabCaBHmM?=
 =?us-ascii?Q?gmgK5qTZwPoli/pCKhiBSCf8hYYE1SDuKUMMY68dYrJex9nPO94tNd4DATrc?=
 =?us-ascii?Q?0mxwrhkbKfQU/FRhtJXemDCiGtDFPNLTMB/qzNpKiaX8lvZq67ImnNTM/tKy?=
 =?us-ascii?Q?AsM5+v8zm6zMs6L8Zmc4uHC1xXK9kUVFTFzH0R6zGAjcc+1QOY0cQSc7wj6G?=
 =?us-ascii?Q?2/hGiEHcU8xuvURovuzFiE91OMS9+k2/q47Xn9/sey3lwIkuRUB6rGcxkfrs?=
 =?us-ascii?Q?rHjMWyRgoBQkQCLqgcwsemB8pTFCaSOTONthKsZ4vHdYzKn2RHgamOASwaoz?=
 =?us-ascii?Q?hjSqeziWibI012bCYQzxpFFPZ08cMjZMorBsNSQx1dn4my2t00uJ/3w3w0zQ?=
 =?us-ascii?Q?qa/sMPe9qzL/jrB9Kbs1lIvKkhAeRSAmjrFB1OMo45SizlsHJUkrbDfb97Vq?=
 =?us-ascii?Q?OcPuLs8KVll5YEZs0mVaflzqIAVUkFNx4aSElflhyMa0lFmDjw2DooKCK2E8?=
 =?us-ascii?Q?N1uzGELPVOtOHFvLvTAFYqEGcwGcj91JAzgq0qSwP93ZIK6YxeCz6U556JYS?=
 =?us-ascii?Q?ku3oKvLaaMK36/DORVcbLY9ac2XXAu/hjWzno9zzcZTe7DQnzK6k73QS/UV1?=
 =?us-ascii?Q?Dwx5PSdg0YjapLnjeTZD/8DUZmWieTRkPS/z+xXfEJlSX9w/MVYg22PBM7J8?=
 =?us-ascii?Q?4tAer3CQ0n85NR/xwmlHpszvFM6KFW02P0Rah+kvB3yrDER2AbdZpjAQRgpC?=
 =?us-ascii?Q?cOgD+LPIKtvm3B02SHlKTR/e04SLIs4IrKs/Iib/33a0xmR90thX+EoCr05/?=
 =?us-ascii?Q?np+ChWFXeGwYi64/kp5hlVkdHQa43Bq6ABL3u24+GBH56neT6Ph+U5qCLeAs?=
 =?us-ascii?Q?ZuUHI6ssD067xiPbCqka+h94ftGxcYVg4gDDHgU1TA6qncFJpoiuvWUGK+n/?=
 =?us-ascii?Q?mBL+8whFRxYDZWHk2L8gB44x9FSkhyqUo2u/umFh3jfXbbymT4M2IrmYXumz?=
 =?us-ascii?Q?c/HEQxaL2nR0/6HaK71sqPSeOY2RfI39N5YEtMX1iIE6V8gg9fq/aTSbZ0jx?=
 =?us-ascii?Q?rrMQAPF5jPssdUllpkAafrgd4M80CZYNH3P36ux2Q/JzYPLeYp0RqUe5d81P?=
 =?us-ascii?Q?3kkYHv/cGuVf8540QbIGZtrDK7FqNLNrTVQJbJ9xq/UUtff31pLAoj2HNUJW?=
 =?us-ascii?Q?iWqtB9b0Js6UqZ4Yk/x5Iv9H2YrPrdg8HXJ6D6EarvnDjB6fHf6T6uqAQwMP?=
 =?us-ascii?Q?hHTsBmgVXvBToBu34EuQF4I3CtEMcrg3GjS8hU2DMIwBQymJnXkvgg+gPYUx?=
 =?us-ascii?Q?SrP4+CIVmBM18hLI+HdvzhIHg0enx+gV0w/yB5zmaJ2jHirKZaDyCtJNWfF9?=
 =?us-ascii?Q?vjNmGeW1rfPhD5nngyqQAWXpGKCY/PlcuCuL53YJHEBSFsp3yKraQISfMMc/?=
 =?us-ascii?Q?lOaMKNkbWAs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F3xXnlCtYAFYVUan8xcJ3lpqC18HraJ7ro6l9ufT9vZoIKrTjnsDcoK56Ye/?=
 =?us-ascii?Q?0G6FUYTwM6YBWvL/jakuQu0gmEYw9Vo7WnL8+jdbEECUkuvSPUL6DGcjt4bD?=
 =?us-ascii?Q?FRTrjzTtYQvODqBI2ujXSk/qvxGmNaCOIPXIqMHB/XlSqwWugp5xupYNSU2S?=
 =?us-ascii?Q?nFYhQyrbSEr1hMYtvdUsVzaWqtulQuQl76pdg39b3D8q48G0rwxxmD6UhDfk?=
 =?us-ascii?Q?NIQ5gWJc4/Dao6ECT/RGftc4HJJdN7+F0PJR1U3tn9xnvY+Nx4SXPPmFOKxI?=
 =?us-ascii?Q?TDS9jNLVpr8UK6P16W2wHEEfS4Cpi80byLNWFoqq9KG6MzJNPgmBmHHhAusC?=
 =?us-ascii?Q?VGe5ys0CSZxTFkKe/WqUvpNeftWiytfOYSJd5GX/lTIX4TENeP3aftMLPOhs?=
 =?us-ascii?Q?7384wGTBz96WxOEqRt8H8Dm/HHl1gJQNEwczmyeCY0Oe2tMHoEI9qNsiT5Jj?=
 =?us-ascii?Q?mEqx5pZN4bmZ/l+S5yll89YDIVhrAZt7O+Q2WvF1TAYShUt1irWbySxbVSMp?=
 =?us-ascii?Q?i5MT64lxX4KTCocqYlU3UfkbArWSiweai8iFDUJ0cOcilFgR5n/yPAhgricV?=
 =?us-ascii?Q?qY4FqDCPxMMDLdqIysImitntfQPqVztPef622PWu/hdafhC6LWUq76QdFAEH?=
 =?us-ascii?Q?Zh663fZSXi8SDPzpUNU1fhEdzRjGv7Mifadacjql3R6lXqyYkNwgpT3bsNr+?=
 =?us-ascii?Q?57cciT2W/hz0nojM66hGDz7hp3ZaMXNgqMhL9KjnxwoPl16tzLELhdK8+tT/?=
 =?us-ascii?Q?x2lTS1ZMk15mQrE/tqyIBxKPvMlmkm+p4PgVX2lx6qn3tWOyB6WjiKzAx5mH?=
 =?us-ascii?Q?/eEu1c6N7Yvr+nkO266skpwdgCvu+wfXaeTtvrhWcA1KzMhll+sDfzs93SHO?=
 =?us-ascii?Q?VPhO5ipB90ncm4+oDzOoIQizrPPiwcammblIZ3kwBfEk4UofHUccgn7HJoEJ?=
 =?us-ascii?Q?6GNP6ghOn/jcFajGGbf+7RGrBfV4286hYCoFaN+Quw/nc+pDot5pJt5jG/KQ?=
 =?us-ascii?Q?4Vqr4W6kGVwpg7LTIekii7dyIIJGvzVGEVsV6k6RFM0dLf++7x5RLYaDYpLi?=
 =?us-ascii?Q?H9XCGe0WAVaIxPTwBl6sIju7b9b5mYkNF//PaKf/8PLqEt7ZabBbVMKwr3E+?=
 =?us-ascii?Q?LQ/waCpuoMtKLpb4kKpKVvQzSq+uBEBfvyKOj+I5sVCexMzvSC9ZQMbXnAjO?=
 =?us-ascii?Q?CUR2eSPhh8SkCa6uLj5f3FrtQzQjxUUPnz3H1ktdtSjUix32lZ/IoTzeVOmC?=
 =?us-ascii?Q?o9rgAWQMzUvLV6ABnlfvMV26eLTX3B68tCn9jXX1rWuvZ7ZKe/ugZJAMMHEd?=
 =?us-ascii?Q?cSAsHv+R4bvDBMlwSlxEoNoNMTQTGf/vklxnXhdSLOo0jd9tmqhntfxZyT1N?=
 =?us-ascii?Q?dGC5tqUi1zpkNrKod9IXkksCiMu4WYaKfSbVOu4jMTR1pxp3DtUjR1QGMNn6?=
 =?us-ascii?Q?c6b0mPtyz8AV5NEWZc1lF+Xr2y60V6p4rV9scqk+W3R9Rtj2gEsJC4svEnC7?=
 =?us-ascii?Q?BujkmNjqgTZz50+fqbGFUKQExOfryI1vaTDoexgdZK2HxruCvKth4FbiRxqe?=
 =?us-ascii?Q?7WIJgj84qG2OBOTvEiP65n436qg5MKuvmKU7Rig1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b94b76d-491f-4e5a-0618-08ddeb071e88
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 16:29:56.7357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFTayTw8pEPXwjkr8IOD70Ag6AHK7TusA9waG2WWGjYUct/4LVzS3GIiNHY3HT2r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8850
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D6161C000F
X-Stat-Signature: 3wxamconfw354gc33wwjg6434xasgrjg
X-Rspam-User: 
X-HE-Tag: 1756916999-358634
X-HE-Meta: U2FsdGVkX19DAnWQdYpNzdZ+JAGyKrgXcXQATeECHjXDEMayD5n67wyQ5/08xrxotPLS+1ouG5hOKE+BT/GE86pAxthwRsg++4w0WlrPQ93Q9NKfbPfQyL5wCpbsflbRR/3694brGWd4gBtW74nz9RSHYKVfd3GHzIU/Iq/iw1NOndT5k2S8UkrZnMAKJhDR4r6JNzZ83kIs0ilNvtufPyEFmUkGUbsX8AdA1SEgVBIpRAZVyxddovsfKD8maasQDcmkFSPvNWDQi3xwHWaiNwSh75jQnHSeq8dndpGd8Gf4WVIGRNaboLtOLbF6VX4EaSvBxwyJMLHXGPldvEFxEUCxPaZL9g6KJqWw1uDZ1nvMNyFlCZ0YeN3wniC8d1ZI1d3jOgprTFVQCnwMemMB/p9+H7JpK4mBlm6RJaaFS5qosMPKkfJmZHNhXobvHsHUXOTvDxe3a4IRt+AIC22Z2S4Zcv4/iVB+pW8twAOqkEt+289XkLokpk3X1aBHEx1bXIDavrm4+eg5CKLq+8GcNw+iJWuCm7CBV+IwcVdyLFKErziHtvyoygU6/fTvsxCA3OcsB999OqcT9Xsqfzd0C3kEZ3RZcgK0vTr6LAQegeMcorw0B5TAv4qg4oTlaokx2DKimC9x6X+qZ+3J7kysFEGm4S+u5JDFHzQQPTkFvzZ/5DBWSpuASUVjQWKxSyJfTcL6hGkDqWF3k587ofDoUaGWbTTXeaTKk50NVxzrbu3cPJ8BZ5tac+J/yjX3+1GPpa3kPHbYtEv0mNa8PNKweVrQ4n7ToGjHrVFOFuVYMLeM/vCq+fcitxARS1h2/kpf8iK1PUjYQCpZAGAtUaJfXeKnWS+L+t6muzJHHzCrvCJCjeQZL+3utryymKh7a5JR+Enz/Ct1Aab9qVs+nMz8kzYVWLDKQyPxDaGpux3m9lUx2yw1ddMMmnABrgaQYu7+oj6YkLMvQu/pZAKpl1W
 r2L0WO4j
 /XrTSc1dnGBtTK2MA67jrgMUMCFwka3FTg2ojCWqRpDCSS2l8ZVfT9fdAR56MMxtEhT2fYGpqYYVe37XqoO66BHmBaPthztdODvASnz/Q5DchanImddgPZ6bQQ0rOT6+ILFGgCija6J4VQn9hXVUtn7ETG+JHKebjA0mpgPIpatlIOWZGkWmrz2XYFdsBAalHZddCHHe6QxVEjuEiatVAt+bk53Z/Aae7FqrY9T6PZxONLae4sl9AElQkoUJz+Pb6qvwnXHri6iYzalb/BBlPUHNgdB7RlbFEfxCdnUaFUETTwKBHjdrvsgHAjPlMPbI/NDwVdEBhO+/RsBlGnXTzdqMkU8vhKetf2R8ycexZlSg+sq+6BmM4qtlxjcS6yk3wE64+DgEtvHdKSqtJQ3AS0V5WRS83Gc2nNkK0Ktl6akTdJ8yC8YgTyaH5OT0ikjk5nfRyJ0AiSXa+C0iuWbd7HHBJvpsvq6z32ezAtDAYQTON9BIxtVroxZxTMdt4ZPtEVCuPCRKrEyafSmiGEaotvdEt+HFM9/KJEXi0umVvftsWQEXePGB7nkRkjXxK7360D3OK0mqlP6/GMxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Sep 2025, at 7:16, Yueyang Pan wrote:

> This patch prints the status of the memory allocation profiling
> before __show_mem actually prints the detailed allocation info.
> This way will let us know the `0B` we saw in allocation info is
> because the profiling is disabled or the allocation is actually
> 0B.
>
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> ---
>  mm/show_mem.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

