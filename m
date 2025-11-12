Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8054ACD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC25C8E000D; Wed, 12 Nov 2025 10:53:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99CC8E0002; Wed, 12 Nov 2025 10:53:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88D68E000D; Wed, 12 Nov 2025 10:53:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2BEA8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:53:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62B08140526
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:53:47 +0000 (UTC)
X-FDA: 84102400494.28.9BF88FE
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013046.outbound.protection.outlook.com [40.93.196.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 91E2D8000F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:53:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lo9GHNUY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3XzKmLPp3L9abWCAuN4QYo6hrdUgfg0ybrgeLmPa0Q=;
	b=OgXlhVbFJQktJ78fGKB5MD5dhm8y8ZTxUAQxA02qi9sJ/vdiYikykdiCFaivj8Zn6LmK1Z
	WmtMoLbeWOvCdSrZgX23YoIfqKNCKDrcg3hsK5u3u1WDAoEXZCLRF8Vp41r9/AELj5qMzu
	RKC5tey/GItFkvpJPGOJLY5ZlJYfAkU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762962824; a=rsa-sha256;
	cv=pass;
	b=Wm494sQ2PxNOjS7NncmTClhudUR5KnGXpQv3qXG4ugvOGY7f2ta1mRephpGS8eTojqlL83
	ZxGuFNz2QWmO87CvRGsJVW0acT3isWgoIPIGuUGgbUqAk9ayALtZDYMGj4ovr2osR+oHfe
	vNjz8PuVDmEBr8VMDi9E51C3pkEG0eY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lo9GHNUY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OsKG5oZARTHHAZUIIpg/JfDE9q8e2VC7ABTrdiX1ci2KAPou1iPPS0mseW6o7kNdppZJJAP3tjezt5mXld3SOA1shgkDzYjL3j7RsYCSZFnd3ZREWivBKfukustPhQc7HnZwN+H4i5XSdhIrJaBDqoG+RHkG2kNvsa77GngbqfeI/ElAk1N7L2Rvur+CWJQOtL+RT8BojFTQzJUyveHkR0wmNMk9DHk0NBiY5zGfQiLwKe2psHGFIBLBzYr9KMFcpC2HFZKJ9sA+SBkrZRxKL/txAh69fkMUUcbyavLjQtwmlD3uzaAgfV9r76uftcjQFgHX1e0odblQ259/bkPa8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3XzKmLPp3L9abWCAuN4QYo6hrdUgfg0ybrgeLmPa0Q=;
 b=xZD5Ss6juEG8DNllC+qP4lN8gRSf500rFPQblGTfSn3hhedZSUMSqmcSFzrupfSW1kVneD7vJM16FkGv8SXWHuFqtpkV3Agoey/NhdNv9nVPgHHfCuqSFl7ZdzSvwLMKxHjNJfJDs8rrRf1BXPyZPbMS3rS9T8dSNuU2WVvERAGlzCaWobd2gQH5hYfK4EwiYz+UKKRFz9tT25g9sTIkvoeKYnzlAow2dyzTBeh/1JQsxmy/VXyNpBzDbttkXXPKbMZ62mR+4yDEPwHwJ3Hw8BVcQzBUNT03PuHYrbistZljMoAUO4suwf/QLc9z8EuBl3iNsc1gelE1k7z2/M/RbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3XzKmLPp3L9abWCAuN4QYo6hrdUgfg0ybrgeLmPa0Q=;
 b=Lo9GHNUY9QwOJQerRqD+8KfTW4zviQsKGKopa1i00e8s6TKMyBMlnenOIJ99rDvtrcxQOiMtFPy96obsbOoKwBjZ4FR8zeedwjdLI1U01GPaq4D/9NFtL2FjAxvtr7X+PKVdD4EWrNBZpQ9PgRFDhDqlaaSZ9k8EldZv2oa+qhCK9SULrjKr96W3dEqqJpgme5V1gM+ckSTIjxZM3fLb2Ny1gvfartrDm7+FoyYuAOzImoG1O8MbWbgPS0bUcK1DA8lKxQdK+fKfrViuGCoCDDPLDIensGK/odLhGcy0ylOPzodFuPiMz842EjMisrU4Qv5EoTrd9Mjirj820mm4og==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9315.namprd12.prod.outlook.com (2603:10b6:610:1cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 15:53:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 15:53:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH -v5 1/2] mm: add spurious fault fixing support for huge
 pmd
Date: Wed, 12 Nov 2025 10:53:21 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <409ECE2A-166D-4C16-BC41-E327572E6376@nvidia.com>
In-Reply-To: <20251112013822.54334-2-ying.huang@linux.alibaba.com>
References: <20251112013822.54334-1-ying.huang@linux.alibaba.com>
 <20251112013822.54334-2-ying.huang@linux.alibaba.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:208:2be::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9315:EE_
X-MS-Office365-Filtering-Correlation-Id: 1644ca61-47a8-4767-8b61-08de22039d0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WoXvNbmZkfBj7Zca9QwD06gq2bEfUJKYlTIJLg/JXFkNBzdC4sveYkijBsmh?=
 =?us-ascii?Q?r13DFb1JlmE5xm7E++A7k5/GDURV0sx5zQPs1DbjJo2zBxl2VL6FINijd8Zh?=
 =?us-ascii?Q?XRM2Ix5AcXoPhxK+PbZzr+qsxy4l1w5o12Dy1C0bngO4RWPfVaMWJQuHpfw7?=
 =?us-ascii?Q?y18HRqkZGPQVl/M2vMCZ2zI6vydWS8xX1dCWnEa+4UFrDL+C83BTSuUeI1EH?=
 =?us-ascii?Q?rJ2cUUPwL9ohtovtbyF2ItRr+b1KlLMia5ODL10Ua9JCkcI1h1sE9SVn+H/H?=
 =?us-ascii?Q?jMfIr7jaO8IGbCYIe1XpvRwlKijlE9Q01bVZgp+474cYRrC5lKDiiOny9PIe?=
 =?us-ascii?Q?xRB3raBor9x90AehPAvKZDmMBfdKS5FOktZ+zmzczKDDB7Hu/C++hq/gnU9V?=
 =?us-ascii?Q?A9WVohD1LU0tXBD1aI1JKFOZomyW1WUFNh//ntm8F4q2dFsN2AF01YbhU+iL?=
 =?us-ascii?Q?kP87SlMeqALf5sxLtqr7upVdvSSfwH+ptUEkflVRtocnB/i0NTNPEFrNJorq?=
 =?us-ascii?Q?ehcHUX8LSs1hVxmnb0laKnoHbjtBCNcIiaGP7hZNKt24hiY5+RvHdipaU+0g?=
 =?us-ascii?Q?xnur5aF6kOEbtSuO97rlrGmuPOoN/ksT6wSspv6zSRVsahFM/wiEYrk027yH?=
 =?us-ascii?Q?r3Fw6lKZq2XAapPrGL+YXLdYUErkTlt+3YWUmhjwLRSU4iWALAFPoW/SRZkn?=
 =?us-ascii?Q?wKmbsDPMcsaoxt6zSjTAMBKKcdaE7XBqcTgqWh6n1myIM5US+UcvF7lOygTS?=
 =?us-ascii?Q?mzYj2GK7TV3xhGcPvSBf11GCkGqGF/Poa4y1DFJ08ssxq8DFXi91W4mvm7Rp?=
 =?us-ascii?Q?jVf4QMcCb+feKLAhRQtJOo57bX4FmVZvhgLEAc7akLEN/pt9bJpgRUR2kEwY?=
 =?us-ascii?Q?Pps9UvL4CiPZn+GGB53Wi4splM/3SzfDQLaokc9V984uO0OKvrnYbH3ISxmI?=
 =?us-ascii?Q?MayxOSgc0lZBD9XUUC2RIY8BgdgZlyQZ1VX43FrhQ9HyRTV3gFkgyDpULBWD?=
 =?us-ascii?Q?BHDryFkGDpC5jNvf2+EfKAVjKy/bYW2wq8G/WsuqjT+W48nP45EGEtCMNTFy?=
 =?us-ascii?Q?MG6o1xWM4OlQY3x5cGDUC/Im1NVpDyhF/3sk1yvETKWXDRp987OTqLePFLyh?=
 =?us-ascii?Q?RggSVoGR/UqAawOd/dfdpBRiwrbqfaq4U604h6RghXjMwKlkDkbIgpGJsCan?=
 =?us-ascii?Q?Ncpstt4bLMK84q+23NiLcp+UGE/IGHxs1ugd1hfAbqDPdVDCjV9sec0JsNS1?=
 =?us-ascii?Q?/5mKXPmi0daeWwC3e9hrWb/oCRtZh+qubjeBOFv/yZ6ECKkKSA4SHKxVJJ21?=
 =?us-ascii?Q?W5oE/WFaYoozXteO5N2WDt0urKWunbkHvQQTH7ztdYZBI+GSln9hYXwNXvZl?=
 =?us-ascii?Q?qmIk2TC7F57AFt/KKD/hq/CxlosEX8RCZnGKGaVh2H6vpyFoepc9Xo8O9I9r?=
 =?us-ascii?Q?ls+TBzVrf7xbEUGtM2XZuv0P5Ykpd0Li?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w+OP02A/y9/uD9bauY63HqyWD5nsL/rCYL7nbS32kUKJ+R4eKPpuj9/OfGQt?=
 =?us-ascii?Q?7cfOmhHGgCI8ebAVDCSqhjM0L2EQybqQAk+DdVR1IaCVQz0DiKjAHv/5286C?=
 =?us-ascii?Q?8ePbu22PxT1mE0rQTJr5T1BGpeM8OA/JwRQv28lCW5KrWoKNrEyL92nQ7Zh1?=
 =?us-ascii?Q?Gt+Jlh7jMfxWN+D2os82wm3gbV5eFaxlJ+Ez4lMkoyDMu5homdKvZ/PY9R+Z?=
 =?us-ascii?Q?6AVLWqcBOsTS78aJoX7u9wIsF+mxvuU3b6fUJBckAgshxuZ7itDBlpJb3rUP?=
 =?us-ascii?Q?WhIsqXcvjG5p7YI6rW3JywUV8mmE63O4Q5YyronaZlPMfL2P4HeHZUoV9twO?=
 =?us-ascii?Q?Uoe6taf1UJ9/AcfaKjaoSpbm2Cnu5gm47xF6LO0Y9TAcIGrGkx1yeUs/R6n0?=
 =?us-ascii?Q?vsEyba9TT0/5PUzeEc4PzVzh6h7W6RrdQ9u1GuKytWbWOrgK77aoWMZj+J7r?=
 =?us-ascii?Q?hLKFw1hze6ODyxtGZ6/lcWXPLTovX3hSv16D0S6XRUdRkxhPeCiLgNS365X1?=
 =?us-ascii?Q?7iDxjhFaDWvXPtE3ywySqr5RLL1tW+yrUklh4vxfM3Ib56trdnN848A+s+Dv?=
 =?us-ascii?Q?BDoobDRlQNsC/xIiZkO86B4N3OY+yOBg10wkSBgbrKozQzpef4MjGHz6hf6j?=
 =?us-ascii?Q?QaODdhHUaOlbx8JGzqIoVbOxX3K++hCx0z32DDJ507kHvoDgdeaakTHfhYgm?=
 =?us-ascii?Q?yqcsuK6xJB/8jTCwUnmUDWZNBtJJPiDuuZ+OAyXfvdH+l4UIYYmuZqIif5D7?=
 =?us-ascii?Q?oBzYQbQmQW9VIuBk9G6To/mnr6/ok3Qn5hrTrn1WJloMMI4eB++v+wrylT+j?=
 =?us-ascii?Q?DeJ7LS+vDPvyZOC6z2DAyPItMdaKQz6SaCMqm32atqXZVQ3M/0wqUEy9/8m4?=
 =?us-ascii?Q?0XD9q2hFJyK2DbhUXiy70qwOpDs5whkSC+H0CRmwQvkbH2E2jj0CBJxy6Udq?=
 =?us-ascii?Q?BpaGilN3WQDpGahB8/dECdLHFRobw3awRdTg7GnSzvjqYvcvcjk3HduCa+Qd?=
 =?us-ascii?Q?EZRFCIoRDbJduohBmu8dgslrh6nZsL4D7fUDEYKuq8OBeSxKDI22AYG8oGVf?=
 =?us-ascii?Q?HDgrjOASOOzco0DgdobuJ2PhNXEhEc4QX+o4i4kKbH6vsVqOTLqe/ipkCavE?=
 =?us-ascii?Q?jdlbhWul4mbKV9p2e+su7s56uXNCiP9yNWwTWhHRzOZTkBF+X+Lbr2mYOWPw?=
 =?us-ascii?Q?vdFdAPDKQyFTMmzMhAKavR5XsQFWQRvBVvOqJ203F8m1LSZBAYh7mIL4jEr+?=
 =?us-ascii?Q?6QkR/aXlxid5rlIQyUs2DGv2HbXXFkvkMyfNJy9tuZfgSrj7BZzzo5fyYqUc?=
 =?us-ascii?Q?+UpSiUusAuOOXM+Ok/1GNsd1Tl7Sge4SNOIWzHJzwLD0mQ84L+VvAzN9aZTd?=
 =?us-ascii?Q?AUqEM7A2tlE9RVWK+H9AlnPEFCJLBmR/VdjgEFRj0J/BPSSs6tuAasFaTyYt?=
 =?us-ascii?Q?8vBHw3GzagozaW0G9y9aT5bY4SZ7s+wL/Fk1qA6Zgx4g6kbStot9dPS9xZlx?=
 =?us-ascii?Q?nwJm+y7e1MqyUO+vglGtn6EjJYoQkKcr+k1doTxdF1EUYBYAnhrvZtpIZbrL?=
 =?us-ascii?Q?XsDm541fx20CmtpFdCQj/dxvvm8ghL4a+RP91EJG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1644ca61-47a8-4767-8b61-08de22039d0a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 15:53:24.9656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SG6QvUpBNs51sjREPWyMCKZkRrQfOhiLn5yy5K5BjzkA+tWT+EUQplUjugNZHLlE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9315
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91E2D8000F
X-Stat-Signature: kmydkp5x1yjz5onuomhcumiayk148nw5
X-Rspam-User: 
X-HE-Tag: 1762962824-573889
X-HE-Meta: U2FsdGVkX1+XBmISVF7gPEFJmILvpbASh/BHpt+vXKcCHj5ti5ZarNsmKMtidBIs86lUCZIglY7MXWdh1BbBLlkdIo6RO15UzvoSmJ77CalF5twO0M2RxpL1wYY+tjDwKFMSvwhd/AyfUqleLwNUqF0F3KLN5wBoLLGcwsEF4nYeuYMyXkSjy48bG/9xgG64k5T33RvWerHQKchvWeDmJF8yW4ZOIqWDqwZQLAqJP+me8UJW/J2PgG+hyFN+yNpq0F/oeZ3fZSgGhXC4pqDIo9/h3nrzzPMUAwNHnZN6/PziLsOjJfxyP8oWRhbwbYIw7nb8skJSurfflT/2nrQ7aspx0hPRL387M2iMnf0nVZKRUfBGFAjlXcpQgo07IDGtW+zTfNi9xkwL7iXQexckBpXBsGS+Lw+11N5hQRiBIgCUF5moZ6PCs604xTMEfvxK4tbWIE/wpKJlyLR8F9bO4P2w62z9T6bU93LdNFJZGNu5AzUEhgJEeeKr4AOKn6HSw4au3x0NNr/zL4TuP/6w5qOwuph5QaSDimN9zH7p8jFXua7ZiAMf1iarqUISye+jTiRvfbwnFVD3anKNOy48b9vRr9ECKzliPVmdnqYAONrpLUZXdAKeFYy65Ci8hEdcAZ9Lomj2ZioJzwnuJ7ObRXOlGQoeCNVQIZUcUe/HSbeDBadcwI6gEqYz1X4cgPYWk2jP1xetIDoTwtP1TxwGtx0ktVCCluKtyoGUTi1xi+GWGo2LLQiquMX5QLYJ1skUwcoMAH1LOrxmWcCjiZVeWS9p/8JDhplZCaJbLuopmGUx2RXR/KjZ+gUTMCyyvVuAAr3Nzf3jrVj4yxo2EaDHKVBbnssH05FYg4YHFqBWnoYtCg9oUsbm7spk6ZlPrgI93tEKZqV4vxw4QhA5RaZtbejisb+WKY/fa9Zuil+e7GReC/kN/Noz56m86m7YUxNKXBY37JKUNf5U8TK/rDf
 JJ612iMa
 U8SfhB601viD6q2BS5JkUXeWufnp7tTBoW2GcbxATSMuwb59W4/KbpGgfsa86tSovjMeJlUaJ+alrAjBxq+0QxRAXBOVXbfsIRnKoi93sVEZuqgPSNuZA3lj5RGMvb39DVtOsqzDh0xG9/wOP49+ANlP857HK5tiivBDHSeW3bZEQCMF3C0Ji6tsAo7v/1tb59bv59WtRzso+LyQHun6hPzVKGXXQn0TKBM6JrwIufZghpYA+76KdAp6r5BqmNq64tJZ+NeY2xGUuXMItuoFaTXM7lXqX4h9FE4l2T4zYjF9QGNrSCbzdy/Z5OlJncoVBICk+fzcYoekCr41s4YZ8wy6Y5M62hKMYZ3TLP2GZpRQWzOxW8h/ei/pMBsnT+6fBsckM4DdT1vFfTEdAoSOu++LeqDzLjETgxOOIvXQdX4tylM5Z4ax0W5zgRRpkY1O/kh5rLubjKi4X4o7UIDvK6M0h0sUqSgKG5gSP9TduOJNT2GOia2bbss2Gc+C5AgfziMuVNR5qeuFNN8avBcXASPC6E0pyZj2gbdwDy78PcBYBa/YzlFv1nJh/6yz4m80WtJCqlYtrn0XLDpbG5n8fRtc6Vcgzi9Mg7Fq0CsX3JciTT334ssvwGY4HvaREtKXRO8kgkUn11M3UKbWj+M7mvZy/vdx6jkwxvd5yUjHx+icZPcOuayBgjKbwwz35pFoAkJ39khIJb03/rf90+dznvUkUv6rirb+j6GKUwHw34SulGxOmW7TuUuEet9jWUZmi/daZJqWBtrky9Pbt4xEUWEXQWSXB1lClhPgUIu9r5bC0pWG/U0V5Gw4XSc8uHEaLnGPY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Nov 2025, at 20:38, Huang Ying wrote:

> The page faults may be spurious because of the racy access to the page
> table.  For example, a non-populated virtual page is accessed on 2
> CPUs simultaneously, thus the page faults are triggered on both CPUs.
> However, it's possible that one CPU (say CPU A) cannot find the reason
> for the page fault if the other CPU (say CPU B) has changed the page
> table before the PTE is checked on CPU A.  Most of the time, the
> spurious page faults can be ignored safely.  However, if the page
> fault is for the write access, it's possible that a stale read-only
> TLB entry exists in the local CPU and needs to be flushed on some
> architectures.  This is called the spurious page fault fixing.
>
> In the current kernel, there is spurious fault fixing support for pte,
> but not for huge pmd because no architectures need it. But in the
> next patch in the series, we will change the write protection fault
> handling logic on arm64, so that some stale huge pmd entries may
> remain in the TLB. These entries need to be flushed via the huge pmd
> spurious fault fixing mechanism.
>
> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Yang Shi <yang@os.amperecomputing.com>
> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  include/linux/huge_mm.h |  2 +-
>  include/linux/pgtable.h |  4 +++
>  mm/huge_memory.c        | 33 ++++++++++++++--------
>  mm/internal.h           |  2 +-
>  mm/memory.c             | 62 ++++++++++++++++++++++++++++++-----------
>  5 files changed, 73 insertions(+), 30 deletions(-)
>
LGTM. Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

