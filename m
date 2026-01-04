Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C49C2A077
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 07:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47126B0093; Sun,  4 Jan 2026 02:22:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7586B0095; Sun,  4 Jan 2026 02:22:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74E16B0096; Sun,  4 Jan 2026 02:22:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD65C6B0093
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 02:22:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CC6916025A
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:22:26 +0000 (UTC)
X-FDA: 84293438292.03.C8142BF
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011044.outbound.protection.outlook.com [40.93.194.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7D0E11C0007
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:22:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=P0OWxGep;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.194.44 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767511343; a=rsa-sha256;
	cv=pass;
	b=yt0vAmBPqmMxLbYgbxL0ZiwSFXcR1LlNC53KO46WWNK14VGwKAQk2AnZYBXyP5myhilruL
	G3f3rAr6lHBKGi5M7zIKSe/bXGIW6n+AieKS/4NTqfgp9WLbYsdUXUmOA+BMul7rMFL9PE
	idvH+IPkCbog03LEmJLkFwhCpZosS9g=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=P0OWxGep;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.194.44 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767511343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dpLn5Z8YcZXnKrImFME3nTGScrYCqcOuIPhOYRuvzE=;
	b=Y80eOqkrd9cv/wPH0gLTR0GK2GgiFob8Aa8v8QThPYNM+/z10NnwurzUrd413aoLuTjyNi
	9I1nm2Jn+Krfe0j+culf65ksBxVngtp14QZp8huH2dMJff1GNAZpk7ilfwZcwwksyCvSHQ
	Y2nIB7m7zLLksaMYmANatoF3ipwoehc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4px8xk5Odqhjf0drNe499jFEnvnCup1jFi2TMuo7xgxgq2EwXCEWGnNLF/ojzoEwCFqimLOd4HDteVUhayj6ty72mDf6DDeLDF/O8yivSG0SIrR4BC6ZktFpYS3zo5ry1Lbh6/BeWfqI/oxfG59Q2vUnSUWRlcWBY+g6VrZE964X7q/zZZXnN8zytvWTcGqjD0ql01B9pKEYHvrE5G/zMQwbPuwMnc7VF48YjBokPVkl0lTgPEUScpuuWOQ5LNKEzhNPajnRUaytzA+9OS0u6d2Jlb1pv26ZskNvQ19hcgvoTv4uAVbhN4rl9zxva6ctPDzmCNA98XWdzTuZHuLUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3dpLn5Z8YcZXnKrImFME3nTGScrYCqcOuIPhOYRuvzE=;
 b=HqClIdxu5ic/4Vw2o9WPOPF0957OzlZtd/ORZubhfUs8cBRVk0zOO/xC/Hizfjl5IbIqTmHPqzRdzhdetjjq2Bzr+vbBz4P3RqUHiwYTHklFcJ3pxxrzya7Y98nPfGEJ6e0Mp3sBhA/vUAr6PLawucH/4Re8WPA29tQ+QX0FwK/L3Uc0aK69ePtn6zEqxRf4fJ4y4I7MPDeMQmde92PRmjYJEzoqMEgNCIhiUbPgko/psuE82i6wt0sSH9BeuX61hWHgIa2NubYVpfZ+RAPfZxIFvZgqoL6ubHYScbz60xI61/XRf2RCSE4tjZua9Ov+wceP14ONfVcs4uH0kfICHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dpLn5Z8YcZXnKrImFME3nTGScrYCqcOuIPhOYRuvzE=;
 b=P0OWxGepKC+PsUjdEAeqq7BuR5xuK3vB9mpILOLT2M5wh4RSG5N8ScnT0MeO6dmJmuhQmqwuN91+p+fSgMdZUvOvM9tEoEvgKF+lAk1je9s4KC8P8li6Rp1tZ2uO4rwvcmcoMzm0fZgPJjkOhtM3+Qok+U4SaQ3IvKaxk87aaz0=
Received: from BN9PR03CA0077.namprd03.prod.outlook.com (2603:10b6:408:fc::22)
 by PH7PR12MB8595.namprd12.prod.outlook.com (2603:10b6:510:1b5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Sun, 4 Jan
 2026 07:22:19 +0000
Received: from BN3PEPF0000B372.namprd21.prod.outlook.com
 (2603:10b6:408:fc:cafe::4e) by BN9PR03CA0077.outlook.office365.com
 (2603:10b6:408:fc::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Sun, 4
 Jan 2026 07:22:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B372.mail.protection.outlook.com (10.167.243.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.0 via Frontend Transport; Sun, 4 Jan 2026 07:22:18 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 4 Jan
 2026 01:22:15 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v2 2/4] drm/amdkfd: Extend kgd_mem for batch userptr support
Date: Sun, 4 Jan 2026 15:21:20 +0800
Message-ID: <20260104072122.3045656-3-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260104072122.3045656-1-honglei1.huang@amd.com>
References: <20260104072122.3045656-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B372:EE_|PH7PR12MB8595:EE_
X-MS-Office365-Filtering-Correlation-Id: d32fb6cb-018c-4263-77e7-08de4b61feb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qRZhiBxtowjhctkdDZlpFW+lXnxMq44KTGMFvDBqBBArhQQM+VGP2qIXA46J?=
 =?us-ascii?Q?ZUzNFhth8stlwWb4v5sjIU2YnSifA2ni08aUOYqKQCqCfH5dBsEztYYYVoaM?=
 =?us-ascii?Q?IdQEnU6lw+0CL6TOmS8XHs0ws62uZ1rUcya6IyWOsJGN+uWAUsnrE5yw1saP?=
 =?us-ascii?Q?VL9SZqolNh5xG3jPLf7LShySCLyDWskQm8Jme3rLEtYpIif6xKGyDgQED1vj?=
 =?us-ascii?Q?kgnMdUk2l9f2bPxzDrz8Nta2XkgVrBhbw4n0U5Aww4Um41GOXao50e0+EsrD?=
 =?us-ascii?Q?U2Bbj215UTjYCQ3zsHpcGlSWrWwGgBYA6ftIvlcuvlNzxdV4StrqRBHZ03jg?=
 =?us-ascii?Q?aNcsfCAbgMYjQi/6UsIYbY2RKUZOSziiKlDVgbJ86JCfHyxfQKwHXGPte8Kh?=
 =?us-ascii?Q?qwTHGeInthP/ru8+ed/8AiddIcY7djQUxvJHuT3DxbKOIL6MSxy4QnnGk0qM?=
 =?us-ascii?Q?pN1YuBlOOhIHfUOONu945WTgKqIgrWC3WExNm3v4RjukbInzKd3ksdytFvdH?=
 =?us-ascii?Q?dRL8R3kUyG87OlCS5MIVzfWXLvCnGy2+CtVYS8L3IeVUBy5Huk/yoAf0EXii?=
 =?us-ascii?Q?Fk5yGPIKhAB80/2vPSWLa+1yx3YC8nx3LcYNeGK4THggZVDOaDTwj4Yd7IKV?=
 =?us-ascii?Q?3WvNjMC7e1gAfCDdALnifun1bETXxcKCZZz+gyCJvjPgCq5pR1QQMkQUtM9F?=
 =?us-ascii?Q?4ANhTKolCvs5BrfXwsQ92kwHBrpL2iVvXFjQiQU/ICC1Ky6Zav4lGrJoFkuc?=
 =?us-ascii?Q?HneE2t2wco0G0zes2AqmwkH7rcHbLi0IMcvZE0d7ZZ70Bx4UZsBCZPKbLeUD?=
 =?us-ascii?Q?ZTvq8rC9cu29mjO0inoHIrThTrMExjLvZrgv4n22OfDw3o1SY3YprxfoeTP3?=
 =?us-ascii?Q?S3i3fMGpeepCqhGu+n+Xn9GdEWLcXig9Fp1NZ2azIomPRJ00yGqvbQ0LbKDk?=
 =?us-ascii?Q?y4ZeNvojxEoDB2+hSnmE71Bj/LCd0QJ3487+szxPV10j7etXhEW2PmW1OYUZ?=
 =?us-ascii?Q?XcAo/8fSNixMe/ixOH56ITsWoBGYY3yDcT+5XZFjS81bUNCxbBSkYho7thBN?=
 =?us-ascii?Q?n1j1s//KxMIyVtX3TWKvIEMRnbGvn+ptn0DoNESCHl9cCOWWhSa63EbLPwQm?=
 =?us-ascii?Q?zcuCH2ia5JJkkeNRADU+XQFnwBJ9e5Hr6D2hr3bTKUWXywluhD7CoalYfBRs?=
 =?us-ascii?Q?xsWJwciHN4BwpWV4+qQNwQnrya2EZA4tstijt7GdER5qSIORil5LC6DHU/J/?=
 =?us-ascii?Q?YB/tNUIDv8uggizCCKskw0+ZYYd6M+D1v0yy/fr2LSa5+l8GffGZUL0b4WWz?=
 =?us-ascii?Q?dOjy2/GWcZvY4djwT5wj8qVIrfidfvwryeCtOCbtJKPcE6jFbN1OWY6/F1A8?=
 =?us-ascii?Q?uUiOlZ6fy2S3XF7hB5/1UI7KUBnUF56oIeoGnVH3nG73D/uVfq+MX3Hc5YMr?=
 =?us-ascii?Q?LA6SxxdgfA5HbmRKYFf4md81+OTAmIn9KQj5a6BzLab19hvMnpUEgNiJ3KPk?=
 =?us-ascii?Q?j6Fleeteix0BUtYYPULHssV/3y6mPT5PKdfyfy5onF7AFujJAV72wVihwwZg?=
 =?us-ascii?Q?lyL4+NR5XwZ/XVB7luI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2026 07:22:18.9857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d32fb6cb-018c-4263-77e7-08de4b61feb3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B372.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8595
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D0E11C0007
X-Stat-Signature: bo6enq9nrn7fu643juobnbkzk6u46cxq
X-Rspam-User: 
X-HE-Tag: 1767511343-487621
X-HE-Meta: U2FsdGVkX1+8GpAEuH1RJ7g6o887+1yIokQtEymNkUO4Nk28MsOBLyPM4TVSzYrZoxYk7jriw+TaUkmlRH4Ewu38zfapZOAYikbhsGk5drQdE8feolganJDGjHUPWVugn8Efz6M/3pd2pr1IDV3RQErusKxsCbStdErQD6sSpDDX+tOxcvooiApkmOamgTS7aVQBkguRpT+8OW0l7C1LTybyN9mPfh64hfD4zDJ9LjW+bMuDWtKd8KSwz9A8CyklSP4AKSldjXSXjTNfzqHWglph5G9+roRwIS5QxxnBsDzWfEKGkqHmRcyVowgo9K6E3+WOAylfUex3WNgixRQd9V3FVYv5jjsDpS+JcsWP00zUs18r8JO+g9mNGhniHOhwHzl+Z1xvIWc36fIdTbA17ntl8WwcwdFtrZk+Y9cXdRJePfVQmvj6QGkH5HVZA55CkrhI0XzF9q3jeei6YU+YI7/j/VQ8dK/CZeq6ScGXrF6K1AAgpqyGO02MgRJ8nFwT8YWZo5YQfND/VH9F7h2gGMx5Ety25mqjqhP4TV3Pr0QcLyCgrZPWxcGV8nheR48Lei8AzooEaEh686/WtsVsXaj6CW5KljkDB5AvjOPufBuaDQtMZq7tKQbddJUV1h6oTojEyKoEYZXCaUxDiKehIZJ2SDlr0j/V1s02XREYazM1zwdZJnmbC6rHmpFlBwFtZt33Qn1OlJjGK4Mp4zf3qLEJK00jJreroime/lVZ3drx4tkd1NXyAN3uD+7wivV3O0GfuggF3P2BnEDD0S43ekt0SlCbo/MyDUQrPQEDkaJFqHv3wRHMfdvcEIPblAS2S8zDJqnUeUH+DW7TdcmFNDd5JN6kuGkC/psfVZ1n7PeZCeLknD9qnB4WLy4GPLh3jYiHuIr92k2pw6gUvE3ERzNIzlZynl3qCJgTTrSgRS/USZpRGrTVeZbLgFF7kEQSqaihHrtRPupmFjSf/WZ
 obsG+lx5
 IPpN1CCsUbGTQzCRYkzdrdjQ9hd71ZlER0abeDkLBGmlu9vO2t78fBwqpQWSpDGGVyl3PR+K5vxDkbmlOHjNx7yYZfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Add necessary data structures to support tracking multiple user
address ranges within a single memory object.

The user_range_info structure tracks individual ranges with their
own HMM ranges and MMU notifiers, allowing per-range invalidation
tracking. The kgd_mem structure is extended to hold an array of
these ranges.

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 321cbf9a1..1883833a2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -48,6 +48,7 @@ enum TLB_FLUSH_TYPE {
 
 struct amdgpu_device;
 struct kfd_process_device;
+struct kfd_ioctl_userptr_range;
 struct amdgpu_reset_context;
 
 enum kfd_mem_attachment_type {
@@ -67,6 +68,15 @@ struct kfd_mem_attachment {
 	uint64_t pte_flags;
 };
 
+struct user_range_info {
+	uint64_t start;			/* CPU virtual address start */
+	uint64_t size;			/* Size in bytes */
+	struct hmm_range *range;	/* HMM range for this userptr */
+	uint32_t invalid;		/* Invalidation counter */
+	struct mmu_interval_notifier notifier;	/* MMU notifier for this range */
+	struct kgd_mem *mem;		/* Back pointer to parent kgd_mem */
+};
+
 struct kgd_mem {
 	struct mutex lock;
 	struct amdgpu_bo *bo;
@@ -89,6 +99,12 @@ struct kgd_mem {
 	uint32_t gem_handle;
 	bool aql_queue;
 	bool is_imported;
+
+	/* For batch userptr allocation: multiple non-contiguous CPU VA ranges
+	 * mapped to a single contiguous GPU VA range
+	 */
+	uint32_t num_user_ranges;
+	struct user_range_info *user_ranges;
 };
 
 /* KFD Memory Eviction */
@@ -313,6 +329,11 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 		struct amdgpu_device *adev, uint64_t va, uint64_t size,
 		void *drm_priv, struct kgd_mem **mem,
 		uint64_t *offset, uint32_t flags, bool criu_resume);
+int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch(
+		struct amdgpu_device *adev, uint64_t va, uint64_t size,
+		void *drm_priv, struct kgd_mem **mem,
+		uint64_t *offset, struct kfd_ioctl_userptr_range *ranges,
+		uint32_t num_ranges, uint32_t flags, bool criu_resume);
 int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 		struct amdgpu_device *adev, struct kgd_mem *mem, void *drm_priv,
 		uint64_t *size);
-- 
2.34.1


