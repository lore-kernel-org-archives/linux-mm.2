Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D88CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BB78E000D; Mon, 10 Nov 2025 00:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA53A8E0002; Mon, 10 Nov 2025 00:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46DB8E000D; Mon, 10 Nov 2025 00:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 895D68E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:26:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36E47BD50D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:26:04 +0000 (UTC)
X-FDA: 84093561048.13.EC4D1E2
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013041.outbound.protection.outlook.com [40.93.196.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 461CF140007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:26:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FOjySFNL;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.93.196.41 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762752361; a=rsa-sha256;
	cv=pass;
	b=z4DWOJEek+UhGsxP571cAD+oN5QS360a64Ag8cps5+TnfiL+v1KrE3d9c9CDmc3QF4Z3Wd
	dkNSiGM0TPsbTq242bmpFR0g+GuHzrzjnzrDLy/dHerOo1uEsV2npZymbA7Jo0g5beuQt4
	qdkzfYU3Px20XWFveVKXmQI0RfcA2ck=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FOjySFNL;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.93.196.41 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9sQPZf68Ao/dkiH50j/6nhzKkAHwFAGsGwoD5XkOXY=;
	b=K/zcEw/eRqg/th2bA1NpM0/cfhZEuTTamKnlygZWdUHmpFnrlKPQs9zk0RX6cCQfyma13S
	6fZWyAQ5KoUy4Y9A6vwZ5limz7n3EL/kcvhc6ijw7eqOoJdNNMj16W79Q+QFIB4s8oSHTy
	iYPqTLj50i0Bz1RAzaxwW8+U7dCe75M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n0XavmIhmAX413wPoiZHqQ4xl9RkmOtRrLpaDrzx6Pmvv3oaZA7jy8hiiIPoNUj9LA4VAFfCxD8XkS2NabPS4BmCB3mB7vUvi5c+yU038WbF9UOH6UdB/OheENXSgT65nfqsFwDKwSns1TjAjseSqKCTvs+GYx0ic1+mY8m7X+uujpER+L4MoG/YaeFWM8I8j9FT3p3o6dIWXOa0hDQzqgyKDU16z/Md0pzJ9zmGYo8+Cch4RIFl5NfUdI29iEhlVJGVaMnuLM1ZOUq5eD88QYP1aVqCu4oFQLbXSonRwZPIlfUVMAYWsMb7x0Tnk2BvY5gqwrg6POqXgKZJnn9odA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9sQPZf68Ao/dkiH50j/6nhzKkAHwFAGsGwoD5XkOXY=;
 b=deup2ZP7McCjlaxaz6WUl5Q5O/Xw9BcVctQym+fPIvvyf6teVhhb8ybIBLXKv8BDP2WZxnJDk5z9m33bZXuuIyvqALN+rVOUpNVbQKncHLv7wRkLe7BD4WLOZWDJD+enqhQtsNIdtTOu7GQTCaK2eNDq36Nz1wGapHHd9fMLycX+k6tafrZ3NSszk3LbKoDaTDTZPMECIVYrIL2W8sECf68YkxIurVCNclVIzRbgCk6FiNV3JikhakfW/pJcJzr/l1fHggV9iEhulEOBpQaaqFR+JWFyDdYcJtXCAL/5GT5JgTpgaM5vlxRRf8tCkU9tkdU9dj3m1kQyPwyHDfq2zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9sQPZf68Ao/dkiH50j/6nhzKkAHwFAGsGwoD5XkOXY=;
 b=FOjySFNLszYC1N5PmqHma1a+juk4YQlXbWrvzD+7lexpDS2BO5gTIknp3rEJYmlCPvRC0Mt8071YilwUGwEhHICA4VIbWgtmE/JkEcwtV3qq1B5BKLaJRwGSZkkn90/5Naz90SgVoKF2HAU2UC0ZZ9B/BHTUn0aBL+IOgW02yZY=
Received: from BL1PR13CA0065.namprd13.prod.outlook.com (2603:10b6:208:2b8::10)
 by SN7PR12MB6670.namprd12.prod.outlook.com (2603:10b6:806:26e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 05:25:55 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::68) by BL1PR13CA0065.outlook.office365.com
 (2603:10b6:208:2b8::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Mon,
 10 Nov 2025 05:25:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 05:25:55 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 9 Nov
 2025 21:25:47 -0800
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v3 4/8] x86: ibs: In-kernel IBS driver for memory access profiling
Date: Mon, 10 Nov 2025 10:53:39 +0530
Message-ID: <20251110052343.208768-5-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251110052343.208768-1-bharata@amd.com>
References: <20251110052343.208768-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|SN7PR12MB6670:EE_
X-MS-Office365-Filtering-Correlation-Id: c4813a42-becb-44d6-7704-08de20199f40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l/4Fow6rEsyDQgCpqRHLrIPDJz0h2LEpEkKdGWm0JZvAdnNFNuKy2Fi4Pg1M?=
 =?us-ascii?Q?Wr17atCwrO/BLcXfyVJyKznFaxd4HNLrPyj2yCgAe+VLlkjHVcNO5C/AsYvM?=
 =?us-ascii?Q?waBYIDcAQlMyPw7Hg3Ww//k6gXn2LfdNTa2FEo2yUxB670taQjNRNl8Mv6x4?=
 =?us-ascii?Q?UIbSrlRhB4DkRAillI421rNpjPxI6FSjrkDB/6PLPz6+v527y2nFSL50Cng8?=
 =?us-ascii?Q?4cQdyi+nDGm8prwdBX9KPtwsdnQnIaPGinbB8762ATYsYUXLjfVdW68/4ifg?=
 =?us-ascii?Q?UDwoN6QJ8Xe54DnGIH0PiRWpOSVuY+FNsbwNCEh5UJfRr8tDhWZK0J272Z0Q?=
 =?us-ascii?Q?FLXgQQPMWo6wT4TyWwgKOqGD6/zZtNn0H8rwqKqhXYfUCOxfYVM43+pGjCBz?=
 =?us-ascii?Q?UDIhDTXQZ7l+QEfiR79FB6lhQZnXL55G9ewXF7llk04tCeEWXuu96oEHMW4L?=
 =?us-ascii?Q?znZdGjNwXUA6N4EUm5WtYGNaaou7wLOnhqm/rABFKRR+mV8fT5CCugQdK5u4?=
 =?us-ascii?Q?nBwRB2uTiaB5RWO74CkEiU3HBkJZXeuZwGS5cE1XUQ84sR03fU5dJtLkCPLy?=
 =?us-ascii?Q?aor6Lql7BPACNwc5aOrgr8Uvc0IKZMHwkYnzilF4SkdAo5iVZiZxqJ0CNZ8a?=
 =?us-ascii?Q?BPt6vv6/gSyzvT+UkAZsx8UIPVZ/qYvQ9p1/cHAF9A5uQYnh/dRZsPmo8g4g?=
 =?us-ascii?Q?XFEM6e5HeEB/FqoqFkgxbp2BWnleE/wEIatCWx63jyIGx1qgeQOXREAFCsFD?=
 =?us-ascii?Q?A3Z0NxHHKYcEzT5r+x1ML7+igQ8qZ1l6SNhvmahVCmQChnQNRzkysqZMXVQ8?=
 =?us-ascii?Q?VLKT3GMGM1WHoA+DYJJxLUIp1r4wR/qTSqnz0UZQZWmjg/eF7uXVWmBUn6JU?=
 =?us-ascii?Q?nxw2h6BoM018PW5MdNZzy00VOzK/bKQzPRiPSOEruvjhqxZq03EC3ztfH69r?=
 =?us-ascii?Q?zpsVl6SQu5ZzYTjAv1kkcfBUtxD99BAnz9xPcNsKcKbq+fkEx1slktsX9Afo?=
 =?us-ascii?Q?hfg4/3m9HzHg6uiKtIJZ9mendurWdpC9Z/xh+8g8L8Et8Z3eHBYwC12IZQ0R?=
 =?us-ascii?Q?NiimSTdVp8qwI8sO6ovVsHETu8BeIlFkyV/VP5UbUqt3SDFP0SGd2Mpeu3mC?=
 =?us-ascii?Q?BdW4Fel7D/ama6swjxpKIAFgv4Zy1OltPr8dAEeEHZQIGkC6ivHdg7dU5Jhp?=
 =?us-ascii?Q?BE2pOILsD5Esmgomj34b6eGnZMrBwcOWVpC+iZ1Z0xHbCbhTrbs8VbxRRKnY?=
 =?us-ascii?Q?vrc1jPg2jMYEFG5uAvslAoxQ+WRFMKPa2rXOZvRvkwGxt7vowRjguToiGBgZ?=
 =?us-ascii?Q?XZA0HUzleKxKsH/8nW8Osj//MOQpxyK9aKf2jEhS5dUdWw/+aiL2MxtJcaOR?=
 =?us-ascii?Q?WOEo0Mwp9QFhGNxjHJoTZsTgnq5ZzKYLvWPAjPSNZc+sAQjdWWvLMS/aS3JI?=
 =?us-ascii?Q?8lmirKSUQWAR/SfQEhHWiEztY3wc1tkSq9BJHvzICmtL2XIoJzVYVGRGhYlP?=
 =?us-ascii?Q?rtP8hutAieit88/tMRLhEN9vkFAsNWHGSHth?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:25:55.0843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4813a42-becb-44d6-7704-08de20199f40
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6670
X-Rspamd-Queue-Id: 461CF140007
X-Rspamd-Server: rspam07
X-Stat-Signature: gcqr4e1u434h9qh1qcdikpbddssg6yji
X-Rspam-User: 
X-HE-Tag: 1762752361-561719
X-HE-Meta: U2FsdGVkX1+HNpTJAfDaDID8Ldm3iesy57kiYEBLNGREQiuNjqtx168jjnkvozYvJiXPTUjue3+CvPYT6UAh8iwU7XHbTnG7Xc5GhSSrXLXj0yB9r/3WAToS7eIVm4vpwKplwI3CXfpndGn8oL17R6xnUfPYGKFxEbv4+yxKl5Rgrd4a5TnzzCIqhrRKJxRjBRseI9dtM52Ex5cWugqIm3Z6l5zIl/xk0KQpTP+iWN6TMdW29V2fIHenJWrnOULxD/5Uv1RTfUUsAPGjpM9lNZRU26YTeucThuuLdl9/bt/150qIL8t3TiDZmHaK517SvEqCYwdpFLUKOVtb+Dadx8XOujW9uUwkud2hmW0YtyNUIv+DA9+Fb5bSXutFy09wVeKQ5Lywgqsb8V3bOkdFjRObtjJR5vNKvLN8FvrN+pc0Ueb9tK3ZWo6PWKRY2lwkvNY09CRm810/H0k+6qYBJyr0wUTO979dtUzX6B6LNxI8ZvRL+9bUTqn6JAbH4A9WXGY8zLvJpVGti/ZhLZsWGicAwH/BLW29yHUtYzD006EuzuJ52t/mjPM9iBGkrckF5zOPoAKsVzbJt7iCHgqB+whGlUMV4GvCY2nVDXViaQzfhSs+FbrYeySYDwUwznOSmqPhGKTVP75nYybiHb7cQ/6NHZNkX9aC45mm9HoYIuuPtN+gdp8pJ0gAYaiMae+j2t7K4wK3dHTBADF/HU5Bf/upjtyYwb8mOxghz+IGvoj3oFMUKCKzeSlM+Cam2txZQyF3M3evBf3puIwtaNxmf/13kyM2dqbBqEHmJab8k7E4he0M7MgkHO9C/rDKxl6Jmgn1qU+yeWbpUarOiUYEyLeOAvkodenOKTC7sAmTmChJayp9vw3ljObKsKsVmIKdQbOcKIf49RlfOmnLesWFfNdMGCya358TrhiXQsZJNPba8SkJkS22EIFECVWEOmOJtdnIIE2CWpWYvOEzGeN
 cq8U4hyX
 LLEkMVczaeBs0KInFW1rHyaDLmU3tmO69z4OL/J6kzGIotwsLX1cqx7+4zW6T7hVU/1/qUFPe1H29IuqeHIREKx5/AG9BF6ZuCZqF5YbK76xitAgiPXCzp0uag3kzMHdMhFatoczunR9PXLhSOYai/LsSQKDifHoZvhG+jO/b7fRytFh9LeAdqPp8b0Ka0BiknVJVqTe/rdZkV/wO7enNgLSj3LIJ6ggczPUGWoRyFLqlSmas5vj6U4lMkqSu226farr5A7iy1GkpUumqL/tzfTUfUowySUSNKSkk90ac0vXoxEiAFUlF4XULVbp9J1LGa6BDIK90yLFX5FLtkfw8PmFJNkQreTCt7ZtoTJuhUmWOCrUqJJudHFIZtrmK4JjKhSJzT9u6jlOyY8f9f4d0SJKmM6As2itK5gYGO8DlEVLrNxm8CLMfaUtDECUoGRawOcHJqxL4nyJQlXj7f0M86QuQNnwaO1he6QcXkh8V376LdsV/z3w1rdGXOLh8c/YLYx/57R9dCZx4Dz30eBxYR6nKUw6CqYNgHk8+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IBS (Instruction Based Sampling) feature present
in AMD processors for memory access tracking. The access
information obtained from IBS via NMI is fed to pghot
sub-system for futher action.

In addition to many other information related to the memory
access, IBS provides physical (and virtual) address of the access
and indicates if the access came from slower tier. Only memory
accesses originating from slower tiers are further acted upon
by this driver.

The samples are initially accumulated in percpu buffers which
are flushed to pghot hot page tracking mechanism using irq_work.

TODO: Many counters are added to vmstat just as debugging aid
for now.

About IBS
---------
IBS can be programmed to provide data about instruction
execution periodically. This is done by programming a desired
sample count (number of ops) in a control register. When the
programmed number of ops are dispatched, a micro-op gets tagged,
various information about the tagged micro-op's execution is
populated in IBS execution MSRs and an interrupt is raised.
While IBS provides a lot of data for each sample, for the
purpose of  memory access profiling, we are interested in
linear and physical address of the memory access that reached
DRAM. Recent AMD processors provide further filtering where
it is possible to limit the sampling to those ops that had
an L3 miss which greately reduces the non-useful samples.

While IBS provides capability to sample instruction fetch
and execution, only IBS execution sampling is used here
to collect data about memory accesses that occur during
the instruction execution.

More information about IBS is available in Sec 13.3 of
AMD64 Architecture Programmer's Manual, Volume 2:System
Programming which is present at:
https://bugzilla.kernel.org/attachment.cgi?id=288923

Information about MSRs used for programming IBS can be
found in Sec 2.1.14.4 of PPR Vol 1 for AMD Family 19h
Model 11h B1 which is currently present at:
https://www.amd.com/system/files/TechDocs/55901_0.25.zip

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/events/amd/ibs.c        |  11 ++
 arch/x86/include/asm/ibs.h       |   7 +
 arch/x86/include/asm/msr-index.h |  16 ++
 arch/x86/mm/Makefile             |   3 +-
 arch/x86/mm/ibs.c                | 311 +++++++++++++++++++++++++++++++
 include/linux/vm_event_item.h    |  17 ++
 mm/vmstat.c                      |  17 ++
 7 files changed, 381 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/ibs.h
 create mode 100644 arch/x86/mm/ibs.c

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 112f43b23ebf..1498dc9caeb2 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -13,9 +13,11 @@
 #include <linux/ptrace.h>
 #include <linux/syscore_ops.h>
 #include <linux/sched/clock.h>
+#include <linux/pghot.h>
 
 #include <asm/apic.h>
 #include <asm/msr.h>
+#include <asm/ibs.h>
 
 #include "../perf_event.h"
 
@@ -1756,6 +1758,15 @@ static __init int amd_ibs_init(void)
 {
 	u32 caps;
 
+	/*
+	 * TODO: Find a clean way to disable perf IBS so that IBS
+	 * can be used for memory access profiling.
+	 */
+	if (arch_hw_access_profiling) {
+		pr_info("IBS isn't available for perf use\n");
+		return 0;
+	}
+
 	caps = __get_ibs_caps();
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
diff --git a/arch/x86/include/asm/ibs.h b/arch/x86/include/asm/ibs.h
new file mode 100644
index 000000000000..b5a4f2ca6330
--- /dev/null
+++ b/arch/x86/include/asm/ibs.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_IBS_H
+#define _ASM_X86_IBS_H
+
+extern bool arch_hw_access_profiling;
+
+#endif /* _ASM_X86_IBS_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9e1720d73244..59657bd768c9 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -760,6 +760,22 @@
 /* AMD Last Branch Record MSRs */
 #define MSR_AMD64_LBR_SELECT			0xc000010e
 
+/* AMD IBS MSR bits */
+#define MSR_AMD64_IBSOPDATA2_DATASRC			0x7
+#define MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE		0x1
+#define MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR	0x2
+#define MSR_AMD64_IBSOPDATA2_DATASRC_DRAM		0x3
+#define MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE	0x5
+#define MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM		0x8
+#define	MSR_AMD64_IBSOPDATA2_RMTNODE			0x10
+
+#define MSR_AMD64_IBSOPDATA3_LDOP		BIT_ULL(0)
+#define MSR_AMD64_IBSOPDATA3_STOP		BIT_ULL(1)
+#define MSR_AMD64_IBSOPDATA3_DCMISS		BIT_ULL(7)
+#define MSR_AMD64_IBSOPDATA3_LADDR_VALID	BIT_ULL(17)
+#define MSR_AMD64_IBSOPDATA3_PADDR_VALID	BIT_ULL(18)
+#define MSR_AMD64_IBSOPDATA3_L2MISS		BIT_ULL(20)
+
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
 #define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcf..967e5af9eba9 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -22,7 +22,8 @@ CFLAGS_REMOVE_pgprot.o			= -pg
 endif
 
 obj-y				:=  init.o init_$(BITS).o fault.o ioremap.o extable.o mmap.o \
-				    pgtable.o physaddr.o tlb.o cpu_entry_area.o maccess.o pgprot.o
+				    pgtable.o physaddr.o tlb.o cpu_entry_area.o maccess.o pgprot.o \
+				    ibs.o
 
 obj-y				+= pat/
 
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
new file mode 100644
index 000000000000..de2e506fce48
--- /dev/null
+++ b/arch/x86/mm/ibs.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/init.h>
+#include <linux/pghot.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/irq_work.h>
+
+#include <asm/nmi.h>
+#include <asm/perf_event.h> /* TODO: Move defns like IBS_OP_ENABLE into non-perf header */
+#include <asm/apic.h>
+#include <asm/ibs.h>
+
+bool arch_hw_access_profiling;
+static u64 ibs_config __read_mostly;
+static u32 ibs_caps;
+
+#define IBS_NR_SAMPLES	150
+
+/*
+ * Basic access info captured for each memory access.
+ */
+struct ibs_sample {
+	unsigned long pfn;
+	unsigned long time;	/* jiffies when accessed */
+	int nid;		/* Accessing node ID, if known */
+};
+
+/*
+ * Percpu buffer of access samples. Samples are accumulated here
+ * before pushing them to pghot sub-system for further action.
+ */
+struct ibs_sample_pcpu {
+	struct ibs_sample samples[IBS_NR_SAMPLES];
+	int head, tail;
+};
+
+struct ibs_sample_pcpu __percpu *ibs_s;
+
+/*
+ * The workqueue for pushing the percpu access samples to pghot sub-system.
+ */
+static struct work_struct ibs_work;
+static struct irq_work ibs_irq_work;
+
+/*
+ * Record the IBS-reported access sample in percpu buffer.
+ * Called from IBS NMI handler.
+ */
+static int ibs_push_sample(unsigned long pfn, int nid, unsigned long time)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+	int next = ibs_pcpu->head + 1;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	if (next == ibs_pcpu->tail)
+		return 0;
+
+	ibs_pcpu->samples[ibs_pcpu->head].pfn = pfn;
+	ibs_pcpu->samples[ibs_pcpu->head].time = time;
+	ibs_pcpu->head = next;
+	return 1;
+}
+
+static int ibs_pop_sample(struct ibs_sample *s)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+
+	int next = ibs_pcpu->tail + 1;
+
+	if (ibs_pcpu->head == ibs_pcpu->tail)
+		return 0;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	*s = ibs_pcpu->samples[ibs_pcpu->tail];
+	ibs_pcpu->tail = next;
+	return 1;
+}
+
+/*
+ * Remove access samples from percpu buffer and send them
+ * to pghot sub-system for further action.
+ */
+static void ibs_work_handler(struct work_struct *work)
+{
+	struct ibs_sample s;
+
+	while (ibs_pop_sample(&s))
+		pghot_record_access(s.pfn, s.nid, PGHOT_HW_HINTS, s.time);
+}
+
+static void ibs_irq_handler(struct irq_work *i)
+{
+	schedule_work_on(smp_processor_id(), &ibs_work);
+}
+
+/*
+ * IBS NMI handler: Process the memory access info reported by IBS.
+ *
+ * Reads the MSRs to collect all the information about the reported
+ * memory access, validates the access, stores the valid sample and
+ * schedules the work on this CPU to further process the sample.
+ */
+static int ibs_overflow_handler(unsigned int cmd, struct pt_regs *regs)
+{
+	struct mm_struct *mm = current->mm;
+	u64 ops_ctl, ops_data3, ops_data2;
+	u64 laddr = -1, paddr = -1;
+	u64 data_src, rmt_node;
+	struct page *page;
+	unsigned long pfn;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+
+	/*
+	 * When IBS sampling period is reprogrammed via read-modify-update
+	 * of MSR_AMD64_IBSOPCTL, overflow NMIs could be generated with
+	 * IBS_OP_ENABLE not set. For such cases, return as HANDLED.
+	 *
+	 * With this, the handler will say "handled" for all NMIs that
+	 * aren't related to this NMI.  This stems from the limitation of
+	 * having both status and control bits in one MSR.
+	 */
+	if (!(ops_ctl & IBS_OP_VAL))
+		goto handled;
+
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_VAL);
+
+	count_vm_event(HWHINT_NR_EVENTS);
+
+	if (!user_mode(regs)) {
+		count_vm_event(HWHINT_KERNEL);
+		goto handled;
+	}
+
+	if (!mm) {
+		count_vm_event(HWHINT_KTHREAD);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA3, ops_data3);
+
+	/* Load/Store ops only */
+	/* TODO: DataSrc isn't valid for stores, so filter out stores? */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_LDOP |
+			   MSR_AMD64_IBSOPDATA3_STOP))) {
+		count_vm_event(HWHINT_NON_LOAD_STORES);
+		goto handled;
+	}
+
+	/* Discard the sample if it was L1 or L2 hit */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_DCMISS |
+			   MSR_AMD64_IBSOPDATA3_L2MISS))) {
+		count_vm_event(HWHINT_DC_L2_HITS);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA2, ops_data2);
+	data_src = ops_data2 & MSR_AMD64_IBSOPDATA2_DATASRC;
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		data_src |= ((ops_data2 & 0xC0) >> 3);
+
+	switch (data_src) {
+	case MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE:
+		count_vm_event(HWHINT_LOCAL_L3L1L2);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR:
+		count_vm_event(HWHINT_LOCAL_PEER_CACHE_NEAR);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_DRAM:
+		count_vm_event(HWHINT_DRAM_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM:
+		count_vm_event(HWHINT_CXL_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE:
+		count_vm_event(HWHINT_FAR_CACHE_HITS);
+		break;
+	}
+
+	rmt_node = ops_data2 & MSR_AMD64_IBSOPDATA2_RMTNODE;
+	if (rmt_node)
+		count_vm_event(HWHINT_REMOTE_NODE);
+
+	/* Is linear addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_LADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCLINAD, laddr);
+	else {
+		count_vm_event(HWHINT_LADDR_INVALID);
+		goto handled;
+	}
+
+	/* Discard kernel address accesses */
+	if (laddr & (1UL << 63)) {
+		count_vm_event(HWHINT_KERNEL_ADDR);
+		goto handled;
+	}
+
+	/* Is phys addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_PADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCPHYSAD, paddr);
+	else {
+		count_vm_event(HWHINT_PADDR_INVALID);
+		goto handled;
+	}
+
+	pfn = PHYS_PFN(paddr);
+	page = pfn_to_online_page(pfn);
+	if (!page)
+		goto handled;
+
+	if (!PageLRU(page)) {
+		count_vm_event(HWHINT_NON_LRU);
+		goto handled;
+	}
+
+	if (!ibs_push_sample(pfn, numa_node_id(), jiffies)) {
+		count_vm_event(HWHINT_BUFFER_FULL);
+		goto handled;
+	}
+
+	irq_work_queue(&ibs_irq_work);
+	count_vm_event(HWHINT_USEFUL_SAMPLES);
+
+handled:
+	return NMI_HANDLED;
+}
+
+static inline int get_ibs_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return val & IBSCTL_LVT_OFFSET_MASK;
+}
+
+static void setup_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset < 0)
+		goto failed;
+
+	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
+		return;
+failed:
+	pr_warn("IBS APIC setup failed on cpu #%d\n",
+		smp_processor_id());
+}
+
+static void clear_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int x86_amd_ibs_access_profile_startup(unsigned int cpu)
+{
+	setup_APIC_ibs();
+	return 0;
+}
+
+static int x86_amd_ibs_access_profile_teardown(unsigned int cpu)
+{
+	clear_APIC_ibs();
+	return 0;
+}
+
+static int __init ibs_access_profiling_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_IBS)) {
+		pr_info("IBS capability is unavailable for access profiling\n");
+		return 0;
+	}
+
+	ibs_s = alloc_percpu_gfp(struct ibs_sample_pcpu, GFP_KERNEL | __GFP_ZERO);
+	if (!ibs_s)
+		return 0;
+
+	INIT_WORK(&ibs_work, ibs_work_handler);
+	init_irq_work(&ibs_irq_work, ibs_irq_handler);
+
+	/* Uses IBS Op sampling */
+	ibs_config = IBS_OP_CNT_CTL | IBS_OP_ENABLE;
+	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		ibs_config |= IBS_OP_L3MISSONLY;
+
+	register_nmi_handler(NMI_LOCAL, ibs_overflow_handler, 0, "ibs");
+
+	cpuhp_setup_state(CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
+			  "x86/amd/ibs_access_profile:starting",
+			  x86_amd_ibs_access_profile_startup,
+			  x86_amd_ibs_access_profile_teardown);
+
+	pr_info("IBS setup for memory access profiling\n");
+	return 0;
+}
+
+arch_initcall(ibs_access_profiling_init);
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 4731d667231d..557da365946c 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -192,6 +192,23 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGHOT_RECORD_HWHINTS,
 		PGHOT_RECORD_PGTSCANS,
 		PGHOT_RECORD_HINTFAULTS,
+		HWHINT_NR_EVENTS,
+		HWHINT_KERNEL,
+		HWHINT_KTHREAD,
+		HWHINT_NON_LOAD_STORES,
+		HWHINT_DC_L2_HITS,
+		HWHINT_LOCAL_L3L1L2,
+		HWHINT_LOCAL_PEER_CACHE_NEAR,
+		HWHINT_FAR_CACHE_HITS,
+		HWHINT_DRAM_ACCESSES,
+		HWHINT_CXL_ACCESSES,
+		HWHINT_REMOTE_NODE,
+		HWHINT_LADDR_INVALID,
+		HWHINT_KERNEL_ADDR,
+		HWHINT_PADDR_INVALID,
+		HWHINT_NON_LRU,
+		HWHINT_BUFFER_FULL,
+		HWHINT_USEFUL_SAMPLES,
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 49d974f8e8b3..d99e736a561d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1500,6 +1500,23 @@ const char * const vmstat_text[] = {
 	[I(PGHOT_RECORD_HWHINTS)]               = "pghot_recorded_hwhints",
 	[I(PGHOT_RECORD_PGTSCANS)]              = "pghot_recorded_pgtscans",
 	[I(PGHOT_RECORD_HINTFAULTS)]            = "pghot_recorded_hintfaults",
+	[I(HWHINT_NR_EVENTS)]			= "hwhint_nr_events",
+	[I(HWHINT_KERNEL)]			= "hwhint_kernel",
+	[I(HWHINT_KTHREAD)]			= "hwhint_kthread",
+	[I(HWHINT_NON_LOAD_STORES)]		= "hwhint_non_load_stores",
+	[I(HWHINT_DC_L2_HITS)]			= "hwhint_dc_l2_hits",
+	[I(HWHINT_LOCAL_L3L1L2)]		= "hwhint_local_l3l1l2",
+	[I(HWHINT_LOCAL_PEER_CACHE_NEAR)]	= "hwhint_local_peer_cache_near",
+	[I(HWHINT_FAR_CACHE_HITS)]		= "hwhint_far_cache_hits",
+	[I(HWHINT_DRAM_ACCESSES)]		= "hwhint_dram_accesses",
+	[I(HWHINT_CXL_ACCESSES)]		= "hwhint_cxl_accesses",
+	[I(HWHINT_REMOTE_NODE)]			= "hwhint_remote_node",
+	[I(HWHINT_LADDR_INVALID)]		= "hwhint_invalid_laddr",
+	[I(HWHINT_KERNEL_ADDR)]			= "hwhint_kernel_addr",
+	[I(HWHINT_PADDR_INVALID)]		= "hwhint_invalid_paddr",
+	[I(HWHINT_NON_LRU)]			= "hwhint_non_lru",
+	[I(HWHINT_BUFFER_FULL)]			= "hwhint_buffer_full",
+	[I(HWHINT_USEFUL_SAMPLES)]		= "hwhint_useful_samples",
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


