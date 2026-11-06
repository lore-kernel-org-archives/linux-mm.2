Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92086606D80D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fnFPTHZC
Received: by kanga.kvack.org (Postfix)
	id 9E52E6B05B0; Fri,  6 Nov 2026 05:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98ED56B05B3; Fri,  6 Nov 2026 05:23:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8574D6B05B4; Fri,  6 Nov 2026 05:23:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F92D6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:23:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAED01A0A84
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:23:14 +0000 (UTC)
X-FDA: 85404306708.16.C1B8F9A
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	by imf02.hostedemail.com (Postfix) with ESMTP id E195780004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:23:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fnFPTHZC;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793960592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaQh/817iI+4/BcEunP8YSKGn7MHyBE9BsrR0admEkA=;
	b=GFceqhIo85r2QlKF/9SfFMOczjmt+YJyGthWtaa6jbe4wkOCD1BAIu9k6mQFLMeXLh/QMr
	5yfl2KLiMpDRLQbe/k1eWAqqRRAQV4bpAxEede3U2z5tLpDiFlvjcnt3iUKeKTj1IKvDTO
	K5rCPu9hMNFOBIBKkqI67f8kProd6f4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793960592;
	b=q4ASmeqEiMJRJSyZZH8XcKje1uPrtkxkpeC/GP/5n5YUfIz7zIeMkSigDNi87UBOpWTBIW
	W2UDYygrY+4rDPgiPUuWpS6Pe//WfFG23LBlJLnIe/zmYis2juBemU6Z5ysAicPtrYuCZD
	pq6304vqk9Hp3fMYe+iJbYm3QNlDr8o=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fnFPTHZC;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fla1GZzZLqgJr6ZJzmX2jqhc8EoH+izK/LGZm7GEXdG5mfch7bc1kvTJC81/kdQpiSSSRP8JV7b0WAoyxQxjaUSiP+CD7vEsIvafc52Xg3jyAGwZ4RD/PLdHS9+aKsOfKxeZJ8raZgo9MqdOOrqfDyj8N4pO2vynUoICI/dyxXkk3jgK5ix5vTbzJjOQHA1/qjfePzJFPTA47BpezohDDgu7xJwd4gzOPv4TTw1bIeIyShRwzsoNWPpsaZUo+1UouAZ83EL9JSBhW443EP+kRcP2MC+S4/2sENlscrSQNMZjzT1VuMIF4rZe3o6vzb5WEWtRtdP4skBd3n0s2Cuu+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaQh/817iI+4/BcEunP8YSKGn7MHyBE9BsrR0admEkA=;
 b=XlQcrQBWF8cO2bhyvoDvq9A/+99Pt/VZpKF5I1pUha+OionbHs2/5CL3Y9uukuQ+xN/m8o/ckUBVq4X0ctD29Y04YwsLugjTqeuuvWHBxCkGAetc22qsyGEncpsTj7yYKg0PoXgzGeRqPyvgr5TuybrNaKgZ2A9EwOA/RamBvBwBdgmbkW+tul5ub4dg3psZNwI/1bfNbWXlV/w6NuxEDppB7wMUzOtChv1F4F8wq48FXL9oUd++3B5gLOoTm3AhjTC9wRM2xDs1noJyUmvhfNtjCZ0mnL0ucAPVQv8uhFtE98cdIcnU5j/NMM6lmROokvpau3SoAyH3AFmuaSAJTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaQh/817iI+4/BcEunP8YSKGn7MHyBE9BsrR0admEkA=;
 b=fnFPTHZCwQcEPB0QbbLbYJYFR8pfOoqCgXEyEcJxbl2h4V3MXihYAzAdvUS24LXs7YITU1J/x4JDwKk1R0ev6EWMOaYIRvL7DFKuG/A4WWc63ZVX4qfyFoHZ3EGD6TVg6sU1wTuavmbaaq5gxMAEoUwGl7LK6QTeqQGN0PtrNuSSRmHcFqRqpjbEtyyyTHFRUH9a/tHo1tJhS1tNBeWnSUKBjR+e0jtFKiMW3X3SYwfdXdaITcG/4Fkc+oCeA/Yf8FS39xNpvQrD+fYveRpkxJRmsNI7zY0mhgJTugj2MUlX8fsmxHo/CMjnzOwtM2kYECuSn/Dlkf5rCBQ6ep8dIw==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by MW4PR12MB7357.namprd12.prod.outlook.com (2603:10b6:303:219::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 10:23:07 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 10:23:07 +0000
Date: Fri, 6 Nov 2026 21:23:02 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, rppt@kernel.org, apopple@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap
 init
Message-ID: <au2qhlsxQt3SRwIu@parvat>
References: <20261105120615.16817-1-lizhe.67@bytedance.com>
 <20261105120615.16817-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105120615.16817-3-lizhe.67@bytedance.com>
X-ClientProxiedBy: MEVPR01CA0018.ausprd01.prod.outlook.com
 (2603:10c6:220:205::13) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|MW4PR12MB7357:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f818435-56e3-4f3b-759b-08df3beff2ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|10070799003|366016|18002099003|22082099003|6133799003|10067099003|56012099006|4143699003|11063799006|261026121527099003|261026140227099003|261026130827099003|261026135527099003|261102123227099003|261028144727099003|261022113327099003|261022115727099003|261021121427099003|261021123027099003|261022105027099003|261021135927099003|261021133027099003|261021130227099003|261009223027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	yj7GJ6yoAcL8xSoFCFFY2PQAnLAeYpwnVrcvGNRQfIvveM2ciEroJhUfF7AZDpKqUGptrmP/ylrGfyU3El0anJ1+tw11D32EIxeW4I9dy1/zmoUwYz3M3nnGm7Bfy3mn0KteBE1bFGrpbN84f2sOPGBqtKDjyQkG53DpNSwb38iOBn6XmTAPL1ek4xnZuYQjBXml6FAUNnjVPo576T+7z8tIniv65L/DrsuA1b68Y8Y+3qEVu7kN6HGSPoxjnCaMgLeTJW3OS/NQfzt6Td5dwm7rbd1SbVTO7QsWRANqvaoPJdRf+gJ6nQ4tBsXV2KkDv2FoW3BCCkKBxHaUYDNnv/OwSDdhl8RhQUskNIfeKE6r9yQG8J6ZFvwHMoI5eu8uthLJYqbH+tvd8WEIRiRlSee6lTDnBVT0JP1M4Gs9SAT5agPViazUdB02g5RKZsaseMUlUe3l2oQ3TMpiaVPpR45PGkt/CmdduiZzg5utfuuWaxDrW4mjZNoqzlDE+Kvs5V0d4BdzEtuQ8cQIRTZlSmPJFP9MyAOmlbIHmDY/wgshgtMa+P4k1FYSyVI1PIfibZP4hbcYd+F/x5W59/WxFye3Dwq9rSfJTWSjfcWPYcrmQ7ksJSGkLu/HjwMhsn2qh6T3BLVI1qJjTaJ8a4jKXbm4FWxi5Ihpd03tcLFKfEA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(10070799003)(366016)(18002099003)(22082099003)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006)(261026121527099003)(261026140227099003)(261026130827099003)(261026135527099003)(261102123227099003)(261028144727099003)(261022113327099003)(261022115727099003)(261021121427099003)(261021123027099003)(261022105027099003)(261021135927099003)(261021133027099003)(261021130227099003)(261009223027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CfxgSo8SeTkzWLklC0HtQqC9+oQjb8mid1BEfVsCI/U3PQ6yTRkrA8q7TN3B?=
 =?us-ascii?Q?V10T6QSt2D7K9nTwc23DzPZ+d0CP4p6J7E9bpKD/nm1q4KOF8gVAteK68Q7R?=
 =?us-ascii?Q?mUs+BNv7WwlL22miGdU49Dq3ET1+S3ksq5FY56EEgrCtZueZ3tS5LvoXqxCs?=
 =?us-ascii?Q?/IMWSPBY/517w1eniDKx/qRrXTQL/PJcGx5jDZOzuQc6vzPYi3odKw37lH7L?=
 =?us-ascii?Q?+iZSA24tMWEdZOuE7kkXBdA7PQFubN07AVJaeWTtMTmV2BHp4WcFLH4cDVRZ?=
 =?us-ascii?Q?PfevWLLbZTP04HVoC4Bxjeqq05s4GXN+GyuwV7ijFdQYTMMtOofh35xCq+c7?=
 =?us-ascii?Q?7cdmjTWN+9ggvA2LxMvMthw6Kgde0dPqCdd8piKqi2hdoVfeKfVMI2U/jlzp?=
 =?us-ascii?Q?8i5kj2LbsqCPusbsj7jZyrt7T41t9HyLkrVrdJsRDlN4PuK5EMFEwi9TME7q?=
 =?us-ascii?Q?SZQne0nF2COZeF+Dhl8EP6erRKGrEQ1cgxgAx51Ay3grXkSkCGn9+pQjg3Xe?=
 =?us-ascii?Q?F/SUD/hQE/ZeG/3DUBnJNqhDT/lwc0JCL5Hl5sbeKtvJsf9CqPeUydTQcWad?=
 =?us-ascii?Q?0V4qSvBdDYVB11GMsvbfPufylrEC/pwutOEZBeW95TfZr0JUauqqN3pwLHeK?=
 =?us-ascii?Q?GUikjSgIUVL3npCUJ5yVCzPpznUD7x/q43eGOxWcn5FJ/ebmSTPjTEUBH0Fe?=
 =?us-ascii?Q?OmpFnwezoMtAAJtp63pEL8q03V0Wo7H8aaxEz9LTh4PXL0Krk6Gl331tKU5f?=
 =?us-ascii?Q?l28mGSdT1C4HbVu8VE+IPi0JCwzz+3b5M602ZXMpfPB4VThn5p3oFwaqov0Z?=
 =?us-ascii?Q?IBEudeMa5URKuq6Pizn0+x5IzFCLbjybtrh4Ma9RVsUvrTWFz40dLLHau6Lx?=
 =?us-ascii?Q?Rxg1Kh5VZL9BrMQIfgrCsXfsTRdA4X0W5ThG6NC6SYgezHRjUF7s+T0jf/PQ?=
 =?us-ascii?Q?0UH2VYbx1lwEs6ijFyrhYuopB89saRcg8Fd/T9QD4b7CD99kWvHbpBc6DhJh?=
 =?us-ascii?Q?/+UwNRG/cxq8Me3ZPY/cN2XkHZvZfdNbPhol3u1/4wsBqygYAFXqWIsZ9a3O?=
 =?us-ascii?Q?Vh6GSakhQwKddkDMuUF0pNRsk6BhBG/jXk3A7YkYqCW/DB1W6NiJg5zfA11r?=
 =?us-ascii?Q?qnC6wPRCJxxbH+mkmK/KKxd1fC/bGJaHxGOc7Fag1RJ+cSTEaUqkBGOwspDj?=
 =?us-ascii?Q?oUofZj1+Zr8PqkkIoG/QniPYlFFsoxvqrnrZO9CTVAfw0SwYmjHJ81MmfeTG?=
 =?us-ascii?Q?VfXPjakLlJbmdfmSGBHcfy3bRXfKU1FOj9Kg7lhe4AL8OOwX2Yt6UbM8gyLo?=
 =?us-ascii?Q?hF/VsqzHf4PuG7Md8y1GxrF42SNeUBXKSrpDIs0flwtRHelFG00v6HWzqN64?=
 =?us-ascii?Q?JkDirm5h1BDIlvT/VPYcQDBbCNpZ6a3DLQSGLPOXgbwZdq5xGd4B2+AUt9ei?=
 =?us-ascii?Q?ZeOCrYklFX6FbbEZGNU+qiNCaCN8TrDqHSBQ0vHASa6+VbL97VJbVWseG3o2?=
 =?us-ascii?Q?zuwzJfntxVZ8bgAFlseQLGhQG4wKrY1ytZw/AGg7zd6jaRWakpzUNXEfNN5H?=
 =?us-ascii?Q?aH/U7YyKsUjcz+0hz9nA5/8bkDP0TgAFJikesHYtMMB2x681T9tUJJd51/n+?=
 =?us-ascii?Q?jLxMR5vJvkfjPzxaXYOU4AwflwVxsNOCUliOXeOQp6GNz14JlAVDuh1toA8f?=
 =?us-ascii?Q?Q3f4vh62xD21bY0Oh2EVWYkV69ak5HRHSh9IcA6jS74+NznKeWIMasvo2d1L?=
 =?us-ascii?Q?q2y80zs6QyrvZX57wHTZeZpA7E3gUl5jIffNg4jMGQDJLJPu2tUZMNpCnaux?=
X-MS-Exchange-AntiSpam-MessageData-1: zbrvju/R5R2vOg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f818435-56e3-4f3b-759b-08df3beff2ed
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 10:23:07.1538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vttigTGxNXehUC44iwoSVxvsDYQjppqXtqO2wSZJAlWdY7BsjVf2BpHLxvGqDmtv93UqoswJnLTCSVJ51N2ODQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7357
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: d47ggmewd4y3i46cu6hfoj5nkwmmt4kx
X-Rspamd-Queue-Id: E195780004
X-Rspam-User: 
X-HE-Tag: 1793960591-773914
X-HE-Meta: U2FsdGVkX191qJGzudxs3j18jo3gs4pdSOoB+Ak+ssAYfcl+Jd7IiKFhQpBsrAp8PaaL4sbL2KB9z4DK0HHhJF4PPk4Fw3AE9Q+Kc+uCl3cKlhu7GrNSbIJFuqarQ0KDvceigKR68SMBFIf7p+WpNk4pdRN54IIqVjdBHUjKMzGPitv3LdBev1l7eeKLMV3h7eb9R3dXrBAgxYkVq/QZ1v/wVc/OcwB9PUmRQi+cUgzLsC+ooWdIyLB+N1GrbHWsDGW8wHcYJFKOnEnOM3oHRPya55OkztKxXYnLLzpkSXLqkbWmHS2zzGAaCegsWgxiyd2fqYJae1eYaQaLLeSP0m2/mfT4F6iyrgqSqE1eBgWlstTmlDEsp7nvrEaX+PtR4PlsdkItOfTvTQpjskrOHK+Jg+OS8npEL+NtAs8eI4oInzspfw+9ZJuGXBr4BXMm0OovoS3KwjzmcsAseedYqquySwGLl4hje4gdaOnrFU5FHqaHe8EhJN7TlGVfnZ0r1ZSjy0Auw+MEunthXXDZGvoa++oTN72N2ezVGJNU1U5fFQgHSc2lofjU2wBbonWFIek8gKSZkbZc5C41foDovFqyoHgGKOADBIEW9RgAiQ+dPSkwiCykXw6qsYv1Cq452hbVu4zZkT6nBoozgPPXUwEQqQ+6qUin3nn0HHe8+xGoWOJChwAyXUCWYKJVf/sNlHTmSd9xa7OhIn0zRtYh3beBXUSjRMvT8tib1MSCLAPROT76pQGOMrun/bzTG7RaGICUxwaAcjr1Dfbc8c3wbVF4XLejwi84r1sDKl9F+jvaV3hah95fqTyZrnV4BhtfUzbykfW/mgm9lqwdeAEH4qGmhNKhG/Mh5N4pxahknWUmBEQMUbqlwTvs8SNnH1Hrm/3+vzTTA7JOBY4TPZlRQ9EgKRJYFyHHlqV+dOnem4QbcML9W1fOzJPPqkeu8Sv268sncT5UW2sQ72R4dwH
 1U0tWza+
 768otDWwAl4Fx2fA8mbefYJrAF9g17/HZAHZXxq3O2t5NBuhidzAWsskvyB86oMjdwFoYwc2RBvA7ykJObfdVxloSG1R8cxFsN3gijEb8FOsJAYcdpU8yOy5wZPPkfeZN4lkEi+GAutKm/NY71Af0vCj/4FOkGmzN7v8nSiVmHdzaOGyhnFczxuHhPojEyF7ZR12CfhryRmC9IFvvm8mFqrRHwLAWe30DArlV2QWIyqS83Va8FeSmCCtJE+UctSd8vPL36VmgrxKPm2Qs0qRZlTMO17ZecOga7Co1u0BynBVNsY8sefdebm3mpxmD1iIon5FBFlzL1L4hAwQdpIIRp9er19mQmess3uOPA/WGZkbc6Z+yCEGYpaHGhTAIIatbss09j+j3C/dVIOTfB/cv/WrPuBweIwbM/oGP4qh6ngTdKWODxPmrcATRiYDlv4pFD2cbdv8htsRbmZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 08:06:15PM +0800, Li Zhe wrote:
> Boot-time HugeTLB allocation has to initialize tail struct pages itself
> when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
> gigantic pages, this can cover a large number of tail pages.  Most state
> installed by __init_single_page() and prep_compound_tail() is identical
> for every tail page in the same huge page; only PFN-dependent fields
> need refreshing.
> 
> Initialize the first tail page normally, copy it into a local template,
> then initialize the remaining tails from that template with
> memmap_init_page_from_template().  This avoids repeatedly doing the full
> __init_single_page() and prep_compound_tail() sequence for state that is
> identical across tail pages in the same huge page.
> 
> On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugepages
> (HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
> initialization time improved by 36.43%, measured with a temporary
> jiffies-based printk modeled after the existing timing in
> memmap_init_zone_device():
> 
>   base:             318.4 ms
>   with this patch:  202.4 ms
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/hugetlb.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index da5d04edf7c1..987f16a5ea27 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3219,19 +3219,32 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  	enum zone_type zone = folio_zonenum(folio);
>  	int nid = folio_nid(folio);
>  	struct page *page = folio_page(folio, start_page_number);
> +	struct page template;
>  	unsigned long head_pfn = folio_pfn(folio);
>  	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>  	unsigned int order = huge_page_order(h);
>  
> +	if (start_page_number >= end_page_number)
> +		return;
> +

Can this actually happen?

>  	/*
>  	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
>  	 * we must initialize them ourselves here.
>  	 */
> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
> -		__init_single_page(page, pfn, zone, nid);
> -		prep_compound_tail(page, &folio->page, order);
> -		set_page_count(page, 0);
> -	}
> +	pfn = head_pfn + start_page_number;
> +
> +	/*
> +	 * Seed a template from the first real tail page and refresh only
> +	 * PFN-dependent fields before copying it.
> +	 */
> +	__init_single_page(page, pfn, zone, nid);
> +	prep_compound_tail(page, &folio->page, order);
> +	set_page_count(page, 0);
> +	memcpy(&template, page, sizeof(template));

Do we need a separate template and page?

> +
> +	for (pfn++; pfn < end_pfn; pfn++)
> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
> +					       &template);
>  }
>  
>  static void __init hugetlb_folio_init_vmemmap(struct folio *folio,

Acked-by: Balbir Singh <balbirs@nvidia.com>

