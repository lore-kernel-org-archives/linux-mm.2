Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4CDF483E7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A686F6B0088; Mon, 23 Mar 2026 15:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A194B6B008A; Mon, 23 Mar 2026 15:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0F06B0092; Mon, 23 Mar 2026 15:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2476B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:47:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2007EB4975
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:47:21 +0000 (UTC)
X-FDA: 84578361882.14.B024D5D
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010059.outbound.protection.outlook.com [40.93.198.59])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8252F1C0004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:47:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XYUqQE6N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774295238; a=rsa-sha256;
	cv=pass;
	b=VVX5TgSQfh/mVJDJUXNfGNaxfOQlvXSzZD6iDAhLefKFARpxU3Pk1R+XOBZ04pXr2KOB1e
	wCVAuppRs+q0S44cBiynMqPiXH9vreYmx8xzV1aO9D+QethEsNRIiNaELeVCNSHbkEfvAw
	cQtrVfxQ5ZD85C2XMBzlN85mofG6kLc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774295238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ciH99q3EKR6091x/8JBfdCEBo/KhTUFldFYlf+SIjE0=;
	b=7t50swRqELk9hDI5L/vlgBPHa+78jPSvrPrLSic4ik1mQsIwvDYGEpL5rRpHpd4WKPJl6o
	OUSse+mTPdhYn5L/i4TK0SFHlXrdoVXoAA2z3RSpc/ubsJP81LwJvWyMZ8ueC6oN5lTrTG
	Q4B9e5lkxijgbFS7RdxEygs52EojU40=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XYUqQE6N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WIgRgRlu6ZS20wCco76St5DOaAn2oYao3V77No+3trnFo4q1CAqQLgknzST6ESFbUtcweqRaCjUKgY9aZZ4fjFzEYVZEPsnSkYjG/Bu0ApHIzJwfhm9/ET4cFCNgOKBzTAnJm0njm2errSAao7883rsCsnrfJFcuxoAdlXJjNolYybgoHA9SWzTu9AKYH+pFDQ/Y1j/OmNG124oyExJs9YWv4MbCZUnBEo74sYVOWuxEvzY+Maxs7cVrJ+TsN2U8Tw7b6JGyb0qXCYsJTynhpRplCkK0YeIZC8XZ/p366avig/LL1Fx132HG13ID3JHRERxMrbUcsJnFRXJoUzPBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciH99q3EKR6091x/8JBfdCEBo/KhTUFldFYlf+SIjE0=;
 b=mEG72L7aPjGuOfSxIHSNQ9uy8lVGWt0QWaPK+/Xircn08ezO1CuBVGfmTbM8nUAv3264/y51tD8+GuIklzwebKx0ElfY12uOOjDgqfxrIBwjLC6WsESS/rR1OAmoCnXcxjnxpsXoTYsC/UyZmlVszPrTjiR8miJTPHoboup0ghX6h1C5Pmvs/lYOu0wCmt6Ztpsu7f22i8oxT1+gfgAJPcaCfmJGSpDidS0KX19tkqxIjcy+Gg7q5gSbamv7KrkrZJTv31mNCEF2S6n+XR6lWCdvNOzgsWKWIkppStkd736/7X8IP70FAmb4T9e0OqzYeeT5W/eFO8VuqkWcpn7U2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciH99q3EKR6091x/8JBfdCEBo/KhTUFldFYlf+SIjE0=;
 b=XYUqQE6Ns60Z5CVELV/BEknY6Hw7QPx4JwbqJfn8mRs7XSwrs7TZOqPzJwDRiJMzg4ghNKkCkeAwVUF3psNH7enH7ZlYDkv493DIQS5ejXUY82MEkCN+AE5z2gwW+FnHmtiMgpxL6RXLtMpdJW/yV3SL5NOieaojTNMPH6joIeb4q0lv5+sUu3poTaIl03rfz529K7oePfVEhAGaweUwTDf345QAyjIIo490w9tKmcb4eKEjml/UktYYn2cl+gK2AZvw6xkyg7XsqtqvphU0dWxq/XeFBjTwSClyYrn7hJjpjKZRSgi8L2YHGb9R3t6Qk0ZmBRLymBbS44/egbMpyQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9028.namprd12.prod.outlook.com (2603:10b6:610:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:47:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:47:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
Date: Mon, 23 Mar 2026 15:47:02 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
In-Reply-To: <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1P221CA0035.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9028:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a15440-f285-49a5-e766-08de8914f661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KxaO0cGbS2jAaJOuZWxNT2quk5Jr5LyyVDkiPJeVWmCj0EA98y7i/EEB0fgrbPuAm4eUrwmCQoQS+GzxsjPk/5a/IHDhF2kUJzc+kUwC+Tgp23Lr/nhY5xYstNtfWvhuPG5AzE0SEB9QXlfu2XQCqut5ppRvyiiJRF9niKcXkIXiuuTCy1EHIIgDEawrHbN8VaioGqjspsIkyei1+CVoeKyEA38BXmJqL6gKwxf+AWBCOt1292NCK2SPYVdWLW59Kcn0gop4CZJdiZRuo3CeI5UBglPYdkC218C5Xo6mgKYhFhch0d8FixR8HZ2yVr8m+HUOIGJMV4Ddo+0zWt0VR1vF4pUQLiz3Qmf00HNUXru3uqkIRmrZfId9bmi7/OERpJA9Cv/oRJjNUKo2NSKFJ+lsExuPdc5MO0C94E3FSjfU9zkJN4ge1xrLZIYZ8dCIieepne3QLbWkNtK4GrFgrcv5Y3BjX6Qs9JBQUAsUHAOCjsarh+gmm2XAvLBUdXiw5JAO38xjfyCKzkSTQN/TCD+n9g7Uqo3K+AHgwmaPeY/QRkqxUcxp0cdDXq3NU1cq4tw9wvKu6KExremo5RlAWTj4NKGxitksuj3M/SeMyVAi/PWuzvM/wybhsc1TS/IJmMDu63BwCwiEtClPMKpRdaLDCkFg5rBDX6WfaHunSx9YIDeP93zuXwsR9/6VUOEN7H560ROWHFtVV0jhtcpgnFbop7EoSlx43OoZvbm+HbU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KxiwWQTf1fq7u14JpC5LmrnNrITAwDxbm22/pYLhEkzlLJAK1mMY/rmhe+gA?=
 =?us-ascii?Q?Rz9jhM3lCjuO/PivlbOB6DFQuAXvAWXzAhWdwz4hz5Lt/mYEQZeX/mCtSnu5?=
 =?us-ascii?Q?OFgfhKMgTBWprK7B3kGS0FmFTQPmGrBVWGmyt5s0iFwKcuj8sHkQZb3uEHAX?=
 =?us-ascii?Q?perC76ZPmq+uMD1XLeT5mveAhzQ/2ZOdYVZnqPyJFaMFGruqk40jg9QO+eRJ?=
 =?us-ascii?Q?tTDvoTHQMYfpzh5Xubc5XqqXJMNsAiow4yMG+OJHDjZ/JE8X5Y2wY9JI83Gk?=
 =?us-ascii?Q?SYm7+nr5Xg4Qav8SwtHf87JukAIhd22aO1JWQrqY1ju4jrp0EQxzcPHNnZn9?=
 =?us-ascii?Q?90T3Inu+wHLh3tjo147C+BPkz5Uji17LYok8GvqCfu3P1COgugI4+NEgXKWq?=
 =?us-ascii?Q?11Osu1D6uNSl7r5xnhcwN64vT5L6QpisQi4CynsUZaiM5jefR5EaYXZPZxhg?=
 =?us-ascii?Q?gNrl8Ykko0tGOtEZGUsL+0GhdxKGP+UeRRns1nHc4XZ0lNGSAJ15aMLlOpiZ?=
 =?us-ascii?Q?14XClt5h2PbE/qN0sKXDaMmbrDFMXuxd73JrAleea6F0suW040x5hWakt5Hd?=
 =?us-ascii?Q?ICTCR8tOInm+4L2MVnOrpHai/dMFbqEHxjbjXZBb4U1eLKRgXcGsWCuXq4z2?=
 =?us-ascii?Q?edq+BvBlknB/bMREn5ISmY2GPt6DWIyd5lbPEQrlRv00fdQwh0iTcykmuKjy?=
 =?us-ascii?Q?CPD2auZB/YoRO/MV6KVpZFjGliERNUh7gdlg2fNi498ymLz/5Hzd0FYPpRua?=
 =?us-ascii?Q?Mvbq2TTP/HyHBWuaLg/sm0X0XITFY7WcJUUw1xVfTrnyAztOYmrZEKixsM4k?=
 =?us-ascii?Q?HhBfwSrM3kSn9+wodU+JcmNR9qB5rxQOk1mRYPWTzoTLxI+mBGgu9dCVT4K2?=
 =?us-ascii?Q?cNt2GqST6Kj/V6PgP1ir2PL6lwWmMkp1iIMZue4ZvPAJ0eSGFlGJ/UWa2Iea?=
 =?us-ascii?Q?jfKlncFJvwxvzePkjIn+tAGPJM2gl/NaDpvIPT5mxxpUpi5NQrfmYZSPIf8g?=
 =?us-ascii?Q?IeeWpsiYuaIaZNc/B8EkYz09NNcz3ngUHRer7yAq2uD1h7/lytd1qe9N3dMe?=
 =?us-ascii?Q?9pz2MSZMzcvCCt0NGhD7B/i8cS1kHf0B+NT2HnWzsc6lus8/rvQ3yrSZlij+?=
 =?us-ascii?Q?A0vhL0CylIznhYgxwUy4QxDyU8dQ7Lo4baqvqm9gCMz7QZBu2ZSlqxLRkXfS?=
 =?us-ascii?Q?3MMa0Dr9zlcmf5hZMOVKhzFIN6RBZ0Oh1lS3x6KTY3VR/oHfT6NEkgL29JZa?=
 =?us-ascii?Q?b5n2SfdTbsN5siJd3yAtqOWc2JBgCSPNol9D0mVsxpQR5oDEBbIAIzK6yAQh?=
 =?us-ascii?Q?kMa9Recj9Od7qXhuQaTdf+6tfK1s4FRubSpiiu1pIPXTsPcfzrXdLyAddkLk?=
 =?us-ascii?Q?fN3w76KXZU3jpqQdJ5dRLNV6AYokT0psesxGFtq00bdaGoQznP28LpuufVCy?=
 =?us-ascii?Q?otMBOa/I3oYNTaSZu/nnapv/3J3JOu8o08tIInbucJmHjhgl7qZtRN9ip0LK?=
 =?us-ascii?Q?rFRdyymgse6WqHz5Y5j4sB2ls4jBGA5St0PbVVFT+KkXRXAerBY0yYJRSX57?=
 =?us-ascii?Q?MMF7Ed06igIq6BvrxjibRCQ5bPnJGqGIDCQTnRFyDlmvnYXQqkb5smp/vWql?=
 =?us-ascii?Q?nXjzrbJP12JQpVX3qnlC2iWmu27j8OajOyv38cj2QHPk5To/SKeqk56JM1wd?=
 =?us-ascii?Q?S3r9uOW4XYKfjdy0NpIq7vm+O+69PNYeRr5T2uldLwUOYmiEHWpJbJu+cXJE?=
 =?us-ascii?Q?UjPtl0VFQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a15440-f285-49a5-e766-08de8914f661
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:47:06.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vBpcZZBQymR2+SdNmulTzw1PVRErvtY4E5unx4zMs92XlRhGebOOMhrrVF+FEEf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9028
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8252F1C0004
X-Stat-Signature: ydauasposoei6yzoeynow7duzjnk97m9
X-HE-Tag: 1774295238-463586
X-HE-Meta: U2FsdGVkX19z0hFH2JdLbvHc8Lk6BOe7fcpgJ48/8RqCplgObHxb8vzhG7evK/WymKrvqBNMX9J+2Hxmxcm0zErKOWmkO739ZpGCnOJLKcAnVtyiBlPheSe7tKd5U8uzgbIBGhXqhCFHC9m9SVHXtpLm16hwpC89boELuN+1c2jdUYIpz2NmJtBg0X7ggvycgDhtNpIlSAcnCiK3/BajKR3fqX6BDkMDWePEIawEDl82Q8yQatKJDVPjy3UCMGt1NJf5wkQbaChW7jLScxvllrV0i5u6xdpb/k0rwKUhqBq1mDfbZDklQVPxTb9Ku+N/TEXZbrdC6ecUWNcow9nFDy+lO6bw+NS5B4VdiHbo0luHEqQiJtG81303MhtH9hEOb8ore7m34hSH4a4nTKoUFYkExjVk2nj1LUiZcb8m4ztIiS7sjwvQekp4yQqjGEHx1XRKq99q08/2jwcxk6by4S70ShIgeIJfY6BlBSdLYo2g9UViFE9L8c6w2RU5uCnu7AUZ08Jtv0IFUI7dY7rsx3UGJA5AJZ0I3FTyjYHf10oFgymG/wXZ6zKRmrKjWF9ShRkm//dX/c3vmSiJVRnc6VTjrE+sS3JI3Mv9pCs6jw8jPvyfOMSq9bBtAsKJTCqQU5SmBoz1RqVzZJrnGYu52UHX1DISHtTmJ7VQUPGetzq+OF1o2Ykmrpyx1yysiHFj8DhUkJ/cn1UgiS2v2r14TVekqKXTo26UYjU07OShQDSJtqEzJqXePXwDXaDYSUz2wVDE44+Jha/Skba7D9GSxPodvHMgyiTgY1WKpdAKGm4b6T7M+pG/Gj9zxaYAsUZyemmdoWKgUNi7xKmLMALZ6cbxzlXPvInTkS22FbntrDRQeeNZNYgj1ofe2GjDR2ylAgZkaLArRG1CmW9SOBKxYi83wfn0wUSmhX7Rtc2kmg7FliqiZBPAznUfx6rbIQjY9l4rRHVw6S2GOF+Em3+
 cKe8fpWP
 31xm5tsi4ktSsCRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Mar 2026, at 15:41, David Hildenbrand (Arm) wrote:

> On 3/23/26 20:06, Zi Yan wrote:
>> READ_ONLY_THP_FOR_FS is no longer present, remove corresponding code.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/khugepaged.c | 159 +++++++++++------------------------------------=
-
>>  1 file changed, 34 insertions(+), 125 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b2ac28ddd480..39f0b8959535 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1899,7 +1899,7 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>>  	int nr_none =3D 0;
>>  	bool is_shmem =3D shmem_file(file);
>>
>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>> +	VM_WARN_ON_ONCE(!is_shmem);
>
> Oh, but if that means that khugepaged cannot collapse large folios in
> FSes anymore, then this is the wrong approach I suppose?
>
> I would have assumed that we would now collapse for any files that
> support large folios (in PMD size), not stopping to collapse entirely.

My understanding is that collapse_file() is only used for
READ_ONLY_THP_FOR_FS. If FSes with large folio support also use it,
I can replace IS_ENABLE with mapping_large_folio_support().

Best Regards,
Yan, Zi

