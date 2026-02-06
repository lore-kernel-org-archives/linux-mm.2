Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDA7EB28D1
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2096B0098; Fri,  6 Feb 2026 01:26:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389096B0099; Fri,  6 Feb 2026 01:26:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287F06B009B; Fri,  6 Feb 2026 01:26:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 169AA6B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:26:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD96F1A0725
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:35 +0000 (UTC)
X-FDA: 84413047950.10.E82318C
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011051.outbound.protection.outlook.com [40.107.208.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id B6A694000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=qXwbI7Tz;
	spf=pass (imf11.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.208.51 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770359192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhkBBcRyt6qidp6navqCF/Gb6+uUaK3CYV7I0esqeCs=;
	b=KF08r6dovYUwzwbvZDb62Xs5lLQqH/ZXA6+iWMS91MEOF2vBp04fV9H552e5d1mfytbE7P
	2u0zNlkdHOmHjmACeckQBJj4TsQxy3nCYaZKggOHuIu2zPVlTnyhxdiGrWpDYYbZikBGw9
	l+UPvFtC9NbUghiBxdgDWdyH0IMIXMg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=qXwbI7Tz;
	spf=pass (imf11.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.208.51 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770359192; a=rsa-sha256;
	cv=pass;
	b=zPk2w+met5U4RasXPxFfcUSV9TPkvpE/mwVGvnUbU4/0d3TkjeZ4M+gKasTfXqa97YEiAy
	kmNl3J98NK2Yk2nUjNEgj4NwP+CXZfqMXDhJAq+8So/JaeI4PdK1EXDOjGFOigstIAZEbM
	l/ExtopsCZJp+rUosaaEg1A3nwO/Shw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKYmwGYy5whpGi10Aq8jC8iaqowyz71vbnrU1L2bYNq+T/3D1rjSrTzGvy2kzEY9MuGLNKelfo7n6oj+WhRChem8g0/YIJWEvKMIRfxlY9LpVBD7JMRoRulT1KLTxiTL0gtQfBXEAU6GhqG3c9sl7qw6VuGulOx3/WxJj++BpTOY5Gl93MlxY9AfqMaDK4GvjaF6jl/XEErj4ry1qq4Wj+n18ohZHTpvxZgP994TWwMZDCB5fvx8PRI8z0Y673tcYklO6reOokOW4euk1rpFKZPkLEPd74TX1rsEM+mGumb7izRC3uUKxsptqnPxlwKi4lMEEptiFjU6ZVi+hf4Lqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhkBBcRyt6qidp6navqCF/Gb6+uUaK3CYV7I0esqeCs=;
 b=vauI9IwUDFo5oxGwII8/Z2OJJUPUonw4NNUBLjt5pEUY1Q9pwHXJp6Vgy4hF3KFV+SR8SIwiCDx3n8JWb26s4SzTL9EMkClWmKG6brGEMXrdDx3nULUSGuLLVMO7FiDffniHfH1UxQuIJxueLoRYODM0ol3p9WZ0NZk9B4fg8DufjG7DZuvxWEbv1UtTfK+3hXiadPIf2x1zl3FuIXW0iUVhgscEyI1BWcz/OVMIjXgEJrrQV5VDX5AVKEo65T6PVuqV9KTnW83bTt8WObm84mWA9Owl+VGCh+p9a2V1L25ReMnt1BgK8pJxu2/EmCrq+h1PpDW0B3jw6za0GMKYqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhkBBcRyt6qidp6navqCF/Gb6+uUaK3CYV7I0esqeCs=;
 b=qXwbI7Tzdwi5ak4axFHBYFtviLNMdNeJ7/U7vPl1nW/l4PUPSR8Ms6cqUJx1wzaO0jLlPDSzFMjOpp5yoZT2pB/juALfOkhxZmCFWCDoZQI9qTt/5E/yOAk6mdp4JISEoH9mzFqD90GY1IpFw5+ZO9basoukg6+TlnhJqGJqVbU=
Received: from MN2PR06CA0012.namprd06.prod.outlook.com (2603:10b6:208:23d::17)
 by CH3PR12MB8657.namprd12.prod.outlook.com (2603:10b6:610:172::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 06:26:27 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::e9) by MN2PR06CA0012.outlook.office365.com
 (2603:10b6:208:23d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 06:26:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 06:26:26 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 00:26:23 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v3 2/8] drm/amdkfd: Add user_range_info infrastructure to kgd_mem
Date: Fri, 6 Feb 2026 14:25:51 +0800
Message-ID: <20260206062557.3718801-3-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260206062557.3718801-1-honglei1.huang@amd.com>
References: <20260206062557.3718801-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|CH3PR12MB8657:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a7a478f-54c5-43e3-3234-08de6548a853
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V6x11yN5iE/zSDIKUSPRpZL30GLIEd20p8cQw9pxs2TQ5Z+xh8Jmw1stsgc/?=
 =?us-ascii?Q?bMw5FVXCzyq/QzDDEulGACA47kGdaq3QxJRl7PlkXcgSbBU917cp96LXjNCp?=
 =?us-ascii?Q?yYZwzE7j8C99eqgE4aa8dFZNZ0GDr/S0DOeHaN5o4zYPBteMeYLq1dyNGupO?=
 =?us-ascii?Q?YpWaeQGlj18Z7yLHmP6AiImxKddHf3jlOO4V1efMYnMvUds0FFIfhiFH1wap?=
 =?us-ascii?Q?7gJVHurt+5AUCct6d3GnuilTuIWUcwqSANyQlXdPROkNeVitGF6YIt5v2Exf?=
 =?us-ascii?Q?cWorxIft7y0ROXOAAaVe7VKIQPaRGaVKmHniEjIDjtWNCXZNSIJq4MbuQ50E?=
 =?us-ascii?Q?VmFB+qxrQWYRFJWe94XwNw/tN5jRR5Zyw4YieU3BnORLHobIT9QR6a35k4q5?=
 =?us-ascii?Q?zPxRpXJMW63Y5EIHOZ3obeNL8SL978tcNnIoRfCz28MiA5eWaODKPEEgxpLw?=
 =?us-ascii?Q?Io2Yj+z+wAxEueJKzjpC56IInxfRZZIl7TkQbvC0VaSSD730nfFMAhB6+EHb?=
 =?us-ascii?Q?mIBWBUkxOu09zQPeo2KEbmV9oDo7mvaxDz82k0s5+XQELY4AWMBS62ZW3Mwz?=
 =?us-ascii?Q?cxa0CULhxpxH9k0q2Os0YyAI7adi8XN3CljUMu9Bms9ozhRKrJwiqoXKidNb?=
 =?us-ascii?Q?uhBcOah549nEyi1B22pittssinN+eGuyYJb9r+wvf9t5HfZyHchBI1pWLbfb?=
 =?us-ascii?Q?S+TEEph0z4Lz26ZLZx9YAtxMc/z0KIxdbiVncTfi7jeI7TajIJqTqoLXy3m8?=
 =?us-ascii?Q?+KepXz/Fgt1oh07qh+nprHyxqHxFUxEXOMVWbtWgVebM/hnhDE5ISEIeb75b?=
 =?us-ascii?Q?Pn3DiNlgpbfWPFAfyz983l5TKcnpq7BRJF5017IXR3kYazGHUDA6s7XlLbDa?=
 =?us-ascii?Q?pqkunF/pYvcqX02FTPr2HmOZjLVBiY90NAVevKlip6F3w794U1exgDjxl1Ay?=
 =?us-ascii?Q?0MCbxsBoQMlVgWKBQ9KuY4235qWMjvWmps8NVJPNzgBd+i2EHnd7qf0aZUSP?=
 =?us-ascii?Q?9F4P3aG/TEyg0vttzKESFs6Ziin5BA9HThP2/wgzqdcRWg+H7RJ/2Fp9pjuf?=
 =?us-ascii?Q?jZQR1ivTRZ76KBN/MWhkfPk3BRlC6WyS2DTGIQJxJ1FmaPM3yV8VVL0Nyfm2?=
 =?us-ascii?Q?LTwRXJDvKQ+rsFHv6235mrnpxugtYLDGoYmNck0evECFwX8Qu3YrZoxXP3Sw?=
 =?us-ascii?Q?N8Gsf0KFHjR8tpf70iMJ+hmqVsEiMRxMHVifnN0g/1swm9gkW5VCGkWpkyzK?=
 =?us-ascii?Q?k/K2+JgrFMSTLM7bCwWoT2XBk1m3UsaBqJLUZTU0mNP3PgsLq3yQqBQUfoPP?=
 =?us-ascii?Q?dDn8CgRJhm3kwF2svpbHFmrZkKzN+Ck0/aXv0tq2PMD5h1+z6Vk6MzM9UHYO?=
 =?us-ascii?Q?p+iK6nIPhCYX8cLjbDUJ6x+OQZyrg/OfbSeS28YLU8UtBUF0W5G6gCiWm1xK?=
 =?us-ascii?Q?wuHuYhIAuna1IeDj+NGMAq5ypJPRb7GITt6mwZ/HeXb9uUivfg7P++26EsV3?=
 =?us-ascii?Q?72dT4/yl2sK4C96reAo9k6cgU/Sy3Cj2kE/vo7bGQU6IzSkWpR02JoYveAQV?=
 =?us-ascii?Q?GK+R+F1UBDZ7D9gE2DvYIzbadOaL6Ya8j5A+p7MlkO8bNdZ92BwDbpxyRuXU?=
 =?us-ascii?Q?ico6PU4wWv4COKyJvPUnSBWKv+TeU5sfgGJH6g/K2P/RhQsM8fI7ls4Nc4MM?=
 =?us-ascii?Q?ki6kEw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g5uGtav2SvWoVG+TFN9PHM3yZFqa+Uyo+eR4EWhWlh/GBih4r2jx4PTyE9IOmPKioRmiH2MBpN7aXcNbA/pF5YNPUeB9ToicjifOeg/H0NXms8EFs/4qmJ6sXCbEnS3yIoqUPmQr9reXYCYBgSaBCdfwzc5CmiEvYlb4JysyBxusvvlU++Ig0t5F+4wZ1W4rgw9/3qoUSLOpcrgDL09nBD8ficofazWLDWLvrmtrS7Pw4eZrU+6KqSu8qxwgGRqsbjSILbiHOjeLSo0q4PdD4PBIX7oFeBUxWK360J8D6bKLona8oBk4GUwpqCzjt7ojkonJ3VPzeLXJ+AfaQIbfuoqDQ4UuvfT8Ov/18CGK8ky5jDo9huCHVK78Mf2GVGCbXKpW59Hk96Nc7VnAcHBasqMSPhBSYvJs87CcYIs3UiQY/TgwFyhVeRUfS94kY3HK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 06:26:26.8831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7a478f-54c5-43e3-3234-08de6548a853
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8657
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6A694000F
X-Stat-Signature: rkis9zxwpu39kphnx4fk1xxn9ropb3jh
X-Rspam-User: 
X-HE-Tag: 1770359192-286135
X-HE-Meta: U2FsdGVkX1+DekWnXQAynVryRNUzp0x/BSGvv1BUjoNrVLAfUpwBcTpxAIFmmC2IbJflY/K4zDHMTqpCSZfnk1EPHfFlMMK31GDjg6LKieVqDOXg8+Y15VNyHLm75Ks+I/BOcJnwV5qsS+HeM171hn/vnhLUMdHVe7zNmDqLKNqyplf/D69t1R9XhTM4JAYuao71202WMdFdH8iUBkX11MIjXdamLNWqJKOg6snwQLeqpojR8Yp7UXGN2/UThUp5LeNUj+Oj4B3+7IZDo68LGMERsyPPdhuz9p4LxaFTqHbDVG4upDKNQxePaP7+pHIt9bW8aveAzZpWCHLTBpnovLKX8KcLr2XBan6s+I3NTm6UJEqpKG8N0+8JVfh0gZxgg+WCCz45upg19nDWJclk5cIgO8SftmsuNYAwkuiuD56wHxEVY3crHmZ0rL+MopS27r5f6wSL83YZsdpT6OxzY7TGmsO7/CbJI5U6k2EMxrU3zkeZFAEb07iAfa6jz879/v6AUw/DE7s7sE5khhfL/RdVEJRYuom6twADSx1Wi41xfazatUF5x7qcqyFkevzBvsfANdiiSUE1mAx+Rv58P5ab9iYi+hKJZXxggLvfYgO7iDJJz6SFhXpT6k6ISafEuNw1ZaoC6l90XY0k3lnP273SS0/LsVpUhFSliso5o4zZ1XZP/jOyp0hp8IntM7lJKUmYOX9aVBUt+EuEU9V2iS+sn/LCZZbEOgtH5sAdLyapGt2rOKd3uapaageO7z7YxyUAt8vpDQngbqTyPMzapQKVsgwLy6eGy46XPQpwbfcReINLwxtdj8sAOD3UHqlCy7Z+9VaJpK8VJgSACM5nSK9A3YJArcb0OuTq31IpioRT7GUTSI7Cl5dtrVQT4aeYqRNr/zbaURJAu2/WyoJyKJ1m4wX1tYR6j5mR3cLQP/NmBSC9Cj25lHcHeRn/ra+eLbkoMMH1Qi80cejJL8F
 IUU5yF7m
 RZklS/C19UWTkQorm4fjhl8ONKBEHvQjSc8v1kqNYEVi59cCf/RdOV9z3GqvYOrWbnjAuCD3bx0wPM6GtbwoyMSvRYokqrRqZbFj0ydolBZumYqeRmE1A4VQlb7zIJSK+KKhnYbxJF6SMrwKSsn5OsK2FL/6/WWhIjr11ANz69Zkxlzt7wcAyW8wxQMN+7WjlqeoFvnLp8aCXaDOHeDvCjj+Iq8B+mySBpM2DrBdyWRAJhQZOHe1Y+KPiOnbDex+6w20hyEmAUhZqb2XedhlDgpPWrhfzhj/S5l9UW4MoH/y/7fsXkHkhzl79ZIG9zPBsRCEbQCr/vMaybJC2P3DofU4fRj/bL/E19IeU5d9AhMD0H94xTxfzi87Dp3rD7T402rDRtPLz5W6R4a9xX6sB2zdlm1fqNoIIFcJjtw2NEOk8Qpc2SpqIHrqDUWDUyUAxYhAV0/59NOMy/sT7DsYBonD/G5hs5Oq+YmrxTQUNrXXX1BUp9ulERvAB2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Add data structures to support batch userptr allocations with
multiple non-contiguous CPU virtual address ranges.

add:
- struct user_range_info: per-range metadata including HMM range,
  invalidation counter, and interval tree node
- Fields to kgd_mem: num_user_ranges, user_ranges array,
  batch_va_min/max, batch_notifier, and user_ranges_itree

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 321cbf9a1..58917a4b3 100644
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
 
+/* Individual range info for batch userptr allocations */
+struct user_range_info {
+	uint64_t start;				/* CPU virtual address start */
+	uint64_t size;				/* Size in bytes */
+	struct hmm_range *range;	/* HMM range for this userptr */
+	uint32_t invalid;			/* Per-range invalidation counter */
+	struct interval_tree_node it_node;	/* Interval tree node for fast overlap lookup */
+};
+
 struct kgd_mem {
 	struct mutex lock;
 	struct amdgpu_bo *bo;
@@ -89,6 +99,14 @@ struct kgd_mem {
 	uint32_t gem_handle;
 	bool aql_queue;
 	bool is_imported;
+
+	/* For batch userptr allocation: multiple non-contiguous CPU VA ranges */
+	uint32_t num_user_ranges;
+	struct user_range_info *user_ranges;
+	uint64_t batch_va_min;
+	uint64_t batch_va_max;
+	struct mmu_interval_notifier batch_notifier;
+	struct rb_root_cached user_ranges_itree;
 };
 
 /* KFD Memory Eviction */
@@ -313,6 +331,11 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
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


