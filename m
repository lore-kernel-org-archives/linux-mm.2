Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4294CF436B7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350226B0127; Fri, 17 Apr 2026 11:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300886B0129; Fri, 17 Apr 2026 11:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8496B012A; Fri, 17 Apr 2026 11:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 070C16B0127
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:55:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A378A1402A4
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:55:57 +0000 (UTC)
X-FDA: 84668498754.07.FE2E36E
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	by imf11.hostedemail.com (Postfix) with ESMTP id C1B214000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:55:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FoGvjBF9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776441354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAxLs3EpejrEH07S1F86ZtEstXjvhTHrm7rb6vZG5N8=;
	b=uTkpL+qtOg3LV1i1Zn4m4Ltmq1CC9SWt2BnYv+sOG353CH45ijsDtIXL1gXXqYZOIxIsKH
	qYj08O0p2JOq9uQT7yJO3Jocu1LmtTSHDNcTFA12SjOvFBAFiputRD6geD3XX2N/ZcwM0f
	UyuFv6HzdnG0jR1sLyhdEHhdM6c8sHs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776441354; a=rsa-sha256;
	cv=pass;
	b=fkie49u1Q0BjYQQPNnX0pmzyitu24C6sU3xJHXZcTjCtYAgtWqui5qVi0nnht65McWC4KI
	4H5ZZAbzyDToxXqB7WVveEQTQ9nHd6q5D3EWC8lqPtz++oEqKuPUzdI20wHOWim5XCqAkx
	MI15P9e4ifCoyARfCg5Xu0boYR2UQHQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FoGvjBF9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scp0XtBX6xrSItSwFizU4i6q6X2lVSb0tacWuXFnu2M0qbSd5rtotIa1EcKIUfzh2niIvMdXt8gD8+Oadoj7EUbA0LGGw9Yz8mKtYK+VEzDTxwVR/ndxdCk/dUECEm6T3E3LDmn2KAyJ+QYw9AC/Ermq9URxL90SPHnA1NVyW3GYMQH1Oc9pdh3kTMndPN8VyzpSzhhP7Sk/4F71ITKuyMvonE+TLCJJrHNJtETtRd4JKBhVRvm5GR5U1H/di0GfwsroQNFk3uiUxPOtVANABECSekizyWzyjwIOklrikPgKJjdSPbOMJADH50BQdVvobwhpcGQkASAzSa4ysRw76A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAxLs3EpejrEH07S1F86ZtEstXjvhTHrm7rb6vZG5N8=;
 b=C4FRTkeeS4lOdBhGetlEB40/d+HpPNLIIWMm2/whFjAfREO/1ZTNOykKTgA7Nbk+O7Rag1V/+3z850Mnk6bcdbkgOzB2oBXChJw2EqGJqSQlvBrHUi7Du7VCgseGrLebHwi/kbIlgCbZzPeup9fGWbUePW3OWcfGAUf2M3t+0+aFk9/EFX21O5Td7YrQgM725/pkzfp9w4LPj5mVH2y1BytBceSaxt4RVHhX+Yju2F3F4Gl0g7dKucTvAkXvnD8dDxTZ5UAR8i7gZBeq1MPgSDeq9i6HbbgM5zCQQOPyr8pgzqQvl9H/ee58lkuMCSQZQvSbp1UGGn0JzYjHixG+fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAxLs3EpejrEH07S1F86ZtEstXjvhTHrm7rb6vZG5N8=;
 b=FoGvjBF92GqVKiMo1d3aB0iFOsag+xYZuOdxU+zuH2WvgeNr25l+wqpSQ3howHUzHuzZWBumd6TXm864d0iM7BNhxzcgckbI5yljpsrwrSFifTReTTwubiUmpe33xYbAT+pvyHTqiHU1uEWmMDfMOP0wWPUbbCL1p321osmkPGgVm0IB1qln+oWBqIWjqg3vBP7Gn2+A59SRFwijgA1rUl4q36QsQBRqPXHf6kHePvbd21vYgYoP3TANGsqoMyr70FiMtxV2skbaAoJYIM6Awhi4YUwHiPs4M7iU35yb1KICrXfNUWerPVocreL0Nt+p8tQ54kuNw1vuJCGeWioNLw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Fri, 17 Apr 2026 15:55:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 15:55:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/page_owner: add compact mode filter
Date: Fri, 17 Apr 2026 11:55:47 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <3F2D1A8D-806F-4BD3-AC41-055CE362B428@nvidia.com>
In-Reply-To: <20260417154638.22370-3-zhen.ni@easystack.cn>
References: <20260417154638.22370-1-zhen.ni@easystack.cn>
 <20260417154638.22370-3-zhen.ni@easystack.cn>
Content-Type: text/plain
X-ClientProxiedBy: MN0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:208:52f::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL4PR12MB9478:EE_
X-MS-Office365-Filtering-Correlation-Id: 590e7f3d-0736-4116-b9da-08de9c99cb96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	acNCakcJesDZH9uUbhK26/dhNziSksPBd+j4xHQwFPRetiVIzgCpKke+apkUs7QDHw8sG129gUf5YK+6ygDQsQCplwKU4KAy86wOIh3/Eg6Ww8uJo7sQ7+cvg307IIwXOisKELK9748FhztQdDHTzFxY4xI3yrI9swXTuNE73vqFvLnS0OeJE64gPp4GgDSsOkSMH5FceCeTyEq47hp7RF1fgHIhghcE9vhcKniUd5SyHQX9PGhWobh4YsgdWx8aLoz2PF66jwyjDsw5rag9wjbF/UQe0bZ8DJFDYzasDBf8LSXvOFi9OxHmmmOidBICX5uCcNYUthYlz8Tijg+bMjocHogxm8CE/0yrEQ7rpZGI7Adw9saI9BU0rBAwm9vSaQCGBeSSaqGbkZH6QE3XI+2P5DpqGsH4JM5KQx13UkDZwz/qT0mnMDeQS+2YIhgbkkq7LxeNzCTE80EEv3zzN6uQMra2iZgVlvm/e70C39HL3e/2ImPyh+MTIKwDfwVaMrn+TYPkmVwefkDNu488K2gBOlxR22MsYLyD3ybzjRQ9/N733PzqePRhPjfZ9gCXsXnmdKCPradn4Ye66ZpO30hEbC96COwTJEDQ3Ejd6MrYgU7aK183E8rUtl5KXSmNLD/9TKMafs2QtyKpj2Qyh2YGL7nbhrDNNSnNXUszCyt9l7YkBhBk5ZMLiQ2l5mlqRH1McLD3EJibtOKCWTSQ9RQYbP7satMAcG9TbuwpANA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fpdq0hQ4cG8sWqTB0Hj1J2IX9K7igEXoWQMuAfWXLIlZ3N7wrr1L8k5YpuSO?=
 =?us-ascii?Q?J3DEEBbLdG8+rdYMvJsKKQanHM6Nd5nmw0itlpQ/bNZoVxZyYHzBzdzBy4Y9?=
 =?us-ascii?Q?NstsUZRmjlVrb3z5mwFbCI78+Wf2uHp9AHLGdeD/2ZmM8K4Q4gWIRS3uwCd3?=
 =?us-ascii?Q?R4mT9c+kgfREjwmqakQBB/xNcSvT6QpLkR5rOoxKF0HFB7G2XS9T/BqxQ52h?=
 =?us-ascii?Q?eK4QzJ0Zm7PXMPHDRnXYrFacEB8WF67JK3JFyy+TbgsTs2qq0OW9rA/QdMcC?=
 =?us-ascii?Q?2c0itfMilY/YekhkYylukDV8efGqF7wcACXkdF/b+gqISmUfZUFC78eaXUQN?=
 =?us-ascii?Q?zQcI52UQ0+0qH2jSGoEkAxBXOiapym/jYhjt2kqXHOcatJMiDBZYfIk8PThT?=
 =?us-ascii?Q?HuSDnUauMA4HtnSlT94QDwIjUqVRVZxiSMTFxeUsgf3WA4oJ1isllRgTS6lp?=
 =?us-ascii?Q?4s7jAo231oAYRhRIBfvYGAQpKpxGqy748krmolz/2ZWu7dLtyD8/TfrMk0cR?=
 =?us-ascii?Q?ZFZWHQNWpr5XCrPir8eSr3wI5BeG7YoN6pyOJmvSzeaSbDaD67eX+WXueiIo?=
 =?us-ascii?Q?BrOwAx7UZGzHFJ7l/bTJ6cC/IXfFHTcCOb3i/4DVoYnyGxheidWKWiJCjj7R?=
 =?us-ascii?Q?gmOyxLv1uv2lMeZrxTJHeNijKb6GrObjOChtflKjFFe4qQ4D9r/cc9SC0mnP?=
 =?us-ascii?Q?QaulFLc+2OdKoUXQeiqdyW0A+HNLWPAuKO4ztCSpB3t6vyVrWUXY/hsZRxqk?=
 =?us-ascii?Q?eNbQtJ1uiNDa5HeuSUFC/czEEg4FppFhZvJWPME5o7y6GSWNDwrt1IjgZ3GP?=
 =?us-ascii?Q?7B7JaIipfVWqUbuZp187uRxOH52+TBf/djN11oH0IKlGyy4xwM2rXvnVwSlI?=
 =?us-ascii?Q?gCUhvmUuH/Z01SWbQenRDqe7l23F16MfED5Dh2byVRKSkwuDbKLrVJgc+HpG?=
 =?us-ascii?Q?RfHjQjFKFdLUPWN0z/RF+KstUOLxKzT+iWWZw3RFwMfuk3nNXshTWYOxBgUO?=
 =?us-ascii?Q?B/rq5XRU+T6Ljr50UMDVtPXXw3DMJRCq8rZkFlpuOMxdhOTL9wVW168gAzn9?=
 =?us-ascii?Q?7BzUCLV9yXvZPkeiYPauiF5+bZqcMbz3f/hiIjDIgOIC3Ui/DvpjwpSr5L46?=
 =?us-ascii?Q?Fw2c6o3Z3X36FtJ28e7oz+l5tiZtYGDVlghrwa97FYAIP/pOoz0O/4fMJoDY?=
 =?us-ascii?Q?LztY0IwuIdjrIEr2U++uSUcx3s/fFyn6kVhA1EC9mIkCnSkzt0FBkXlr314O?=
 =?us-ascii?Q?NYKvJ8AEepqfodY86ZPDvo5HUqXtVvftAkrKszTeSqDD4RAMhDp3vsvC82hG?=
 =?us-ascii?Q?FxsVIT2g5mgBMRKh+wCCbTmGswLO/3onHgS6+KZKDCwk9EtmwVLGo4K/oZdm?=
 =?us-ascii?Q?I5G1NQt80nxTmyL1tVS/JIg4Q2kubhwolMLSFwTres8GN+8W/2HXeeK4RByi?=
 =?us-ascii?Q?RKUFFqFd+KOKLQhSjRl6bXzpJ6WnsKnn8KQU0/ZbHl2GjUDl6yIGxQfD8D+c?=
 =?us-ascii?Q?+JacoooQOrZWIqiKHbOtbmHljHsbO5n6ZZmUJ2zaD7iTVNw0qYm2KR/hF40e?=
 =?us-ascii?Q?CLgSjD13MRmP/+g+AsSNzx0uxC5DUO7ZIcNp+znw2oWYnNUvA6hKWkiP1Jym?=
 =?us-ascii?Q?qXhUPhn5iMS0q1w6LN/hxskDO8kmXPjjZLDQYv+Yy7NIgJQKJrEFNV6B9138?=
 =?us-ascii?Q?S7UynSduu2GYOgt15l9TkPjpagLPQRgiqWgP6EL5VpmyV4Z7BE1VbXaukWFK?=
 =?us-ascii?Q?2J0+5j6W6Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 590e7f3d-0736-4116-b9da-08de9c99cb96
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 15:55:49.3874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WK5CfJrv3zNqeRwGvHvZ4M7uAgv0t7jJLYq8nNicWwh8er40CUntUBvUViQSgaKY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9478
X-Stat-Signature: n6319a7ajacp9fr3sn733pykeg6jf6xt
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C1B214000A
X-Rspam-User: 
X-HE-Tag: 1776441354-192709
X-HE-Meta: U2FsdGVkX1/7FnhBQT2zaOgGvRpfCCxS22xEUim2j9hlPdsdYU/rX81GuhGqyPdBK8wA9E/Vrdnk7aVeRxZB1qDjrxvh/iBgA+4cCymevI1SeOeAThQAe8Dw+MK/Q1K3sgRnJaKlT86gczVPRLdzxOcBu2WmRe2DypX85BUUjYcLKugTDlH9v/v2ey3519LKb145oKbskvrXm6DO1af7J04py/mzDkvcAoNL418one0KFouJqQv0An0m4WS/WOmSHqYDq6PRDhrHywpeuCdc6EPr6mclg5+ariAghfSmWkEJaBpuorx+Xwh3goIjEyyPWKSJRkCyoX7iVqRJ/quswkkA1RB+tf9rYDHRT0O3jAd5nBkx1uR3FLljy8SFLEKjrTQWITdwFzOxCXofch8EYAIi7jiFmzgjUNE62XB5fWnjWe78ehQ2237J2ig+W4bCIRPqt4QCkJ3F37W9+p/Z5pPBJjEobzyBr442SSu4lRBzp7Ks2k5tFlf9XsQOO2VE4XgPAE/3+czpYePiOzBOl4b2MFhRGQZc6Vb4rlrrZHVFYC6vgp1ZaqNQGc8dJNUYAdjoUcQiwqE+fsL+YG6a+CduWaJ984zg7bSZygfDjIIIe4HP1vkKD4XwD3wYGjdBDJmerN1/2jwOZ/QPdPYB3kkspQkFW+y2DqNkereg9Pe3N8SyvD7aK8YQhU6ssEyN0o5DWwNMY9U09NvVSM7qYgvMJ+OnQSWLkm4p2NZ0afjuEg6x+UIH2bcSJAwuWuXeEEycekYuvIscGdXeNJyZALyZe7dmPSnzNsKp0IypOSIV0Vt8ZwrI+Hxz5bmw+gLHz+RAmpLee+UGiPMNpYRYoOeb+tcLsx87XDSW0LL+K7fHi492Z2GCKd7u6W/7VifzD/m4T1RAtvfL0VrGzUaf6i4y9SpBEjlvqE4Tbuz+88Uhgbg6U2keicD1YMEtFOftw+NlBHCC0BWvY8Zv+TU
 pxsjgyId
 JxtyYXGeS3tUpps7tyeGsFBOBS8o5nb5/WghEkUkj+4NhXhRFOurDjt9WmyipRtM+Vco1mA/jhmV9ZS8d9hB1ErT38PbWNCN6nQAmCS4K+8qzC8f80dONg+mWkrucvoeNAIxfS3mvWx9lyLzeuo86Ff8lPPg/8iYgeITwayfMmtj9JOGipwtwk4E0Yx1f1yUnWac3dbBetfWts6Gt3So03J5oyIZpNyVMoHDk2eyjIkIqbbSCxt02BfxqG69lhjzlsgeidrxRF1Rkqwlys7FCVEBmCpybO4atWSXm6RqZOpbeIwSL5dCkNIYCh0BGAVIGH+HtnhNIjILOybqYVC7/kTr/RRLx1vDXGTc1IHsp9dCPJEGvIy2Qt0hwLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Apr 2026, at 11:46, Zhen Ni wrote:

> Add compact mode functionality to reduce page_owner output size by
> printing only the stack handle instead of the full stack trace.

Maybe you could add an enum type for what content is printed.
Something like PAGE_OWNER_PRINT_STACK_HANDLE and PAGE_OWNER_PRINT_FULL_STACK.
Since compact is a very vague name for what the code does.

For the sysfs interface, stack_handle vs full_stack would be used.

>
> Example output:
>   Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
>   pid 1, tgid 1 (systemd), ts 349667370 ns
>   PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
>   Flags 0x33fffe0000004124(referenced|lru|active|private|node=3|zone=0|
> lastcpupid=0x1ffff)
>   handle: 17432583
>   Charged to memcg /
>
> Compact mode significantly reduces output size while preserving all
> other page allocation information, making it easier to analyze large
> volumes of page owner data.The correspondence between handles and stack
> traces can be obtained through the show_stacks_handles interface.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
>  mm/page_owner.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 6811439bf9e4..214b58eef3d8 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -585,7 +585,14 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  			migratetype_names[pageblock_mt],
>  			&page->flags);
>
> -	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> +	/* Compact mode: print handle instead of full stack trace */
> +	if (READ_ONCE(owner_filter.compact)) {
> +		ret += scnprintf(kbuf + ret, count - ret,
> +				"handle: %d\n", handle);
> +	} else {
> +		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> +	}
> +
>  	if (ret >= count)
>  		goto err;
>
> @@ -980,6 +987,24 @@ static int page_owner_threshold_set(void *data, u64 val)
>  DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
>  			&page_owner_threshold_set, "%llu");
>
> +static int page_owner_compact_get(void *data, u64 *val)
> +{
> +	*val = READ_ONCE(owner_filter.compact);
> +	return 0;
> +}
> +
> +static int page_owner_compact_set(void *data, u64 val)
> +{
> +	if (val != 0 && val != 1)
> +		return -EINVAL;
> +	WRITE_ONCE(owner_filter.compact, val);
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(page_owner_compact_fops,
> +			&page_owner_compact_get,
> +			&page_owner_compact_set, "%lld");
> +
>
>  static int __init pageowner_init(void)
>  {
> @@ -993,6 +1018,8 @@ static int __init pageowner_init(void)
>  	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
>
>  	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
> +	debugfs_create_file("compact", 0600, filter_dir, NULL,
> +			    &page_owner_compact_fops);
>
>  	dir = debugfs_create_dir("page_owner_stacks", NULL);
>  	debugfs_create_file("show_stacks", 0400, dir,
> -- 
> 2.20.1


Best Regards,
Yan, Zi

