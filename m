Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E0ACD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 13:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F16A6B0005; Tue,  5 May 2026 09:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1EA6B0088; Tue,  5 May 2026 09:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690D86B008A; Tue,  5 May 2026 09:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A90D6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 09:43:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3B96404CD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:43:16 +0000 (UTC)
X-FDA: 84733482792.16.FD182C9
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE4B580006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:43:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uWx965MP;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.93.194.31 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777988593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJs8AntTLNRUF/Yy5aYC8skrpY+AyCXnidGxKMam91s=;
	b=Ktb/a8Iujctbf6b/haOGmwkMRcEjHnb6mgCaZPDjcLQAkY6O5OiB5D07vECAwdcJpYVnB4
	j7+XrFOOl25Rr0Y8aDhSehvRo+YuhxKbCKTIDtfS4lH31bgl3ai9Z0TQdZ2MeTjCN6G1JC
	j07BmVgsTOfT34qcNjOOBEPTWUGOFoE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777988593; a=rsa-sha256;
	cv=pass;
	b=NLhRxVbqv0wjdmPzZa5RkPMAUfW3+dz7lcAIYOxavVbPGT9uajHdm4j1iqBZjAI/W7US9I
	mcxF/4Js5btBgWiwdQzFMfbJhzCIKyQ4vb/w3aHzLg10aAecFnQ+aTPkH4G/tuvu64T5/e
	ej6ciFX5uL1bnqFp0gNqAfi0Uaq1sy8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uWx965MP;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.93.194.31 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=otq5UXcc+Up46O1jliqYXN5Fol6NfExa14cIZnfP0hSvQ756jTpfSaoo2o3KIi93Y21gs0alopnN41WpDYTh1rBM62j1pDzReSfnFVyQ+OxgKR2bruI9lBb5hcin9F+mUZ6FuRCRLjTKRnwJFGsYWxrxoV6S/PIS32pxKO0qWsRj+oVKIeyehTn9n/rD0iZsTCKGHhY+Qj6Le7RD7pz9acsOhvLlpyEeh0I1NMJ+Bd40fl0ZNWbVm1B05hCnrmX1QE0UglkXeqt9/ecSH6ju+dX0k2wS9Jv2esGE5X9u/OZCwDJpkKMYCeTenyFx0m90mxACmLQQYQj1OinPvggLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJs8AntTLNRUF/Yy5aYC8skrpY+AyCXnidGxKMam91s=;
 b=i63aljApx6cFvssyq2Qx4QrNxNJcTZWV1T+wA0+JgsRfioRmvGz2TBYEk1hgaNnFxAZ82kxvqt0Ly/hXJWHG6Mjhvv0C3gFv+TsCXGk11cZlixouXUCJ1id4E11Sx483N/WwjaDZ5suD938nq0Bp8d/kZeisP0K3gZ3s3pyVVWZJrvq1vcnH6z5Ct63PNkThz6qaYIDrvEkCMKADAYCntFLfvTgAvD6LzXDWtk7o4QEGB3O+M7VlNplUHvnIoMgZ55qhC2v89Uf/0J5MjEBn7sj+ga8NFpTLvO488W7PLdI2buxZYL5eEnSLCdeIPGZlVelCWuDMIA5R+1rM+tJUJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJs8AntTLNRUF/Yy5aYC8skrpY+AyCXnidGxKMam91s=;
 b=uWx965MPEgjy0Js4bWTHhwOXEWkeTppXMM9uBiT7blgulqEBootl+cWaZ5aDiT57sJmLkq4oMOLM/eikCEdI6khDjogtNNXr6yQyhyTm4u7kkLXU/aqBwRilz410wKFPJts7OYPZz+nI2WiwXvn554ZMDlufxN1wZvLm9YbuhSg=
Received: from MW4P223CA0002.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::7) by
 MN2PR12MB4125.namprd12.prod.outlook.com (2603:10b6:208:1d9::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.27; Tue, 5 May 2026 13:43:06 +0000
Received: from CO1PEPF000066E6.namprd05.prod.outlook.com
 (2603:10b6:303:80:cafe::50) by MW4P223CA0002.outlook.office365.com
 (2603:10b6:303:80::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Tue,
 5 May 2026 13:43:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF000066E6.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Tue, 5 May 2026 13:43:05 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 5 May
 2026 08:43:05 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 5 May
 2026 08:43:04 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 5 May 2026 08:42:58 -0500
Message-ID: <c1c19860-83bb-44f4-83e6-cb1f7377bb0e@amd.com>
Date: Tue, 5 May 2026 19:12:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260504060924.344313-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260504060924.344313-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E6:EE_|MN2PR12MB4125:EE_
X-MS-Office365-Filtering-Correlation-Id: 82050296-754b-46f8-24cd-08deaaac3c8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	83v9uF2WHvx/MZO55SA2uM6nvY2cut6Hc5HZb5AVh5e/T4BneCVk3u5elXIsdZptCok5rpUBEG8so4q5Ou15KJZhfnWqlirDv36sVv7cfGQAFKmgvjy+if+Au/sWDZCBIGARFSWkXytnAuqMbUEVBrTfxvmIQHdwLoVrkC0WIdcHpeDZiSpzGvAy1uO6Ai7/0xD+D8Dj53QXmBiGKUiV26PtApfUlDH4MZmT597L14qMwNoIUMTuMmICWjaDk0e5O8Gmky6EV+zjCZ9qGU9kj9+/YXpILvc9lu1QYyNB0KrVYtbhv4wdBirjhqkLepIQmYYQWsDN7D4RIMKdzTJAaLSQCwRpdWp9zF34OuMtwhXVCxCaRPKiuhgzfjMWOwMsWsjfmTyRKVYFbN0LOfsghLwUhKF67W1DuOdQz/WR/UYIcyIV9WrfHsJ2Y+hczGBZFUrX59M4LxXWvSVD8+669EJ6DWCUKG4s8edpSi8/HWGw0TvoXjWQyd3Cz9lNAUkwAK61SjTTi8RUlylbw46as4LaJ2fHh7BVbiSJoARTuFg7mUwikWtRY6yNJqEJCJwaUdzzG6UhxOpGqb/54+50VChTOFxi2miF3B3aqceP2HrkeWEZmjVCPsO5OJgN39YLIcPd3HZtPh0UR9kuIPEVFwKXyAg3y7+2JF6n/eK+vMj0+8ehh2/E2HR/tbVK5UVKsZzrvBgB4rM3XhzENhH2Vx3QsFaeQcrxvDUHHqK0JwM=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y1Ld0mSNQoTgLEUg3zIzKiXlzTGcYyp7yYhpdWAKylXoiEE6Uw2WTJU9lulMpaZJFfZE2Jbxh2MSEqCf+RtdRvQJRy8y+9d09tlLcyrbLzHEkg09SdEaqYehYiJJX6wKCCiYFVM2qUhX7ZApiNzetSkaBOjlNh8NCqGYoXXk4pD1fyxh1YSLkoyuFVRD5KbHMPRi1KCai2bD2CXQ2C6wNAK8/88pbPu1r7ng3MOtyr8ES7nTMm/7eyYJ3t77ZSlFPpVkWNuDrsr83fhYwbyJnpugYExW2BxmHtUdL1mPaDTBwNDIM3R7yPJ99Z0kd70E287mLd7Wtadhy/6RU8jmj939WAL4c2cxLI6wTRx16OeCAbWVHypgb/8jTKi+3e07STCerc6UHVEgEoqcscKtORKzrTxGdHDXPEuVaxPIr07NPzs1s0sZRnE5LDVvXGZe
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 13:43:05.8638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82050296-754b-46f8-24cd-08deaaac3c8a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4125
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AE4B580006
X-Rspam-User: 
X-Stat-Signature: zigaigez5ssdpk14qwb3f91twfiqjtpp
X-HE-Tag: 1777988593-508908
X-HE-Meta: U2FsdGVkX19X4oRrv9PWEEfkq51TsVo1Ob4NN637KHsxxj0x7op5OklJ4AD26MF2B7fQMKN6BUZ5HVVFuglErjyLhGBmDa8Oo6yeaQh95mfk9rqF3kxa4wYh4PPZrTl9BBz4VlO7ukuEwH0l0hv35D5ZiW6JQAmPeivxpZjHp8Lk6rGdLn2qqaxlCKJNEvKa+9xkIu+tmAdDcElNBcrkJgzZCoKT8ahZdjZf+mMbYJsJ66aLyvk/J2hd/RdWCISg0JGthAqCBtrF1VaB4FwMPS+ZopNTuq9Hjm2JI2YVdY01DB3cA3rhBu2cYYsMpK0GP+Y3CCOPrPpvze03Yln/QBIsPuogll3CPUzMEwYMLLYkSCV+5o+WypFFk2HZoutC/+rUvvpFcoCeU5AvKpS7VAE9qjroSokbi1ELXpKijTddzgpQ54ncW8Eve0jWNW1HhX4208p87CHOeh+IwNwrT2Uduu9b5Y6IaUs6pTC8i6veBmlqiISKWUSyjsM6V8TKLjtKc//xtyKSGogbihx6qXfwm3KUZGcP0+jENYQy9Hs2Wacv7vn4e1RmeAolg7tzBCzXktwbCdFHWRl6wYbIeY14DlCjeBTYs+nDrsBTJmW2enl6iI1MjJH77EHyQso0NUSC32W7RdV17NTlRQvs9yS36XcGKAjhq9mYfRQ1pjCMcOy6Amrj02zrl0s2giZmRiqnQwW4lCC7Ny7Uon3dKzv7YU5uV2ygZFmxucP4knOXrRmUVny6O2nR10kAUKwONJALCkX5qVYPxXw7Eqc8WNavNC/fz66ohBNpo9tpWG/Im5N8OB4kRb8JeWwyxeEJ1CzXb2Z90FxbnvmxT/OIFUxyl3orR5rg2ReCuvuKObB1XJNSntF9loaZS2Z0CuUo6CpGISvKlW4DX4pkYd8aa8+8ll8QzH5V321ORfIuCABUQKC+24ABPKd7kE1dRYWpiyyLGRoCScP4hEBvISs
 8N+vzT8e
 wx5WhJzyLFOjzsfHIrc98+BlNoI2EioOAnvfF5uRXO0s2Y7qmyZ/uYPKMM7Yg9dyIgBxUDqUNGt8cM7/a1OouUApHpDqgNG3xdXOLIUDT1oqC5CZsoXghHb3YB2iAkumeOqI7OH6asmQytTcrVvxTIRnSNAEh1s0OEtPf3d6JqmGbMKK/P8OCqW1HtrTCeIU3q2CN+4L6KeG0Qd6KZ4qWSfTewIe6gUR/HMi2t1/t/81F73Mx/TSau/kbVeLtHMSi6qCnDIGMjltqDwlNlm+vyxuCIDZS5JKcGgUwicCKzZYW9BKyXPBDpxl7UbIJQOr3q6eV59NqXJCiInIkYT5vf8F8TP9VnHUMU1+A8HxMCJr0CAAMJvzI2qvEKKN+lwH2MuWCMAqwq+fDt30Kq0pq72TIF01uUY0TZM+1NVPsC20wZfyYO7LXUJLqoP0LQfu8mAsHL0Owr/OpPqjR22/r9vV9jd4swpZdkXQVgdMRMhLOXkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-May-26 11:39 AM, Bharata B Rao wrote:
> Results
> =======
> Posted as replies to this mail thread.

Initial Graph500 benchmark numbers for IBS Memory Profiler source:

Test system details
-------------------
3 node AMD system with 2 regular NUMA nodes (0, 1) in NPS2 mode and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node distances:
node 0 cpus: 0-63,128-191
node 0 size: 257715 MB
node 1 cpus: 64-127,192-255
node 1 size: 257845 MB
node 2 cpus:
node 2 size: 258032 MB
node distances:
node   0   1   2
  0:  10  12  50
  1:  12  10  50
  2:  255  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the pghot case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the pghot case.
HWHINTS - IBS Memory Profiler as source for pghot

Pghot by default promotes after two accesses but for NUMAB2 and HWHINTS
sources, promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

Graph500 details
----------------
Command: mpirun -n 128 --bind-to core --map-by core
graph500/src/graph500_reference_bfs 28 16

After the graph creation, the processes are stopped and data is migrated
to CXL node 2 before continuing so that BFS phase starts accessing lower
tier memory.

Total memory usage is slightly over 100GB and will fit within Node 0 and 1.
Hence there is no memory pressure to induce demotions.

harmonic_mean_TEPS - Higher is better
=============================================================================
                                Base            Base            pghot-default
                                NUMAB0          NUMAB2          NUMAB2
=============================================================================
harmonic_mean_TEPS              4.09614e+08     1.28401e+09     1.47926e+09
mean_time                       10.4853         3.34492         2.90342
median_TEPS                     4.10086e+08     1.44584e+09     1.85957e+09
max_TEPS                        4.1661e+08      1.79773e+09     1.99242e+09

pgpromote_success               0               13746029        13412213
numa_hint_faults                0               13753808        26669823

pghot_recorded_accesses         NA              NA              26669551
pghot_recorded_hintfaults       NA              NA              26669823
pghot_recorded_hwhints          NA              NA              0
hwhint_total_events             NA              NA              0
=============================================================================
                                                                pghot-default
                                                                HWHINTS
=============================================================================
harmonic_mean_TEPS                                              1.52334e+09
mean_time                                                       2.81941
median_TEPS                                                     1.57446e+09
max_TEPS                                                        1.72014e+09

pgpromote_success                                               3415599
numa_hint_faults                                                0

pghot_recorded_accesses                                         3440912
pghot_recorded_hintfaults                                       0
pghot_recorded_hwhints                                          24475210
hwhint_total_events                                             24475244
=============================================================================
While no migration (NUMAB0) at all hurts Graph500, HWHINTS with pghot is able
to provide similar benchmark numbers even when not migrating as aggressively
as base NUMAB2.

