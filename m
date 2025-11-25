Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBB9D0EE00
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DA66B00A5; Tue, 25 Nov 2025 12:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75876B00A8; Tue, 25 Nov 2025 12:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65806B00A9; Tue, 25 Nov 2025 12:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6EE6B00A5
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:15:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47460140317
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:15:01 +0000 (UTC)
X-FDA: 84149779602.14.F847F38
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013049.outbound.protection.outlook.com [40.107.201.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4CC9340012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:14:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YZViXMWy;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of skolothumtho@nvidia.com designates 40.107.201.49 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764090898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=asBFX+VQbEmmjaMePYdyDRP388R9FuoW25aAx/Aw+Hw=;
	b=v5Us9M/qEPsDayWnUCUizcSv6NXZ7mDAbjXP709Yw9KRgT3FiwCog3O5aawEkTqCu1dSv4
	zpk4BQIUwMZQ73go12Ng6OBCAZ8wKoVGlQcZnYKRTXXq0vYHDRDC16GZbtLkl1FLoAnTP6
	Nd0mK8hJgv2dbq1lTVr5LXm+P/vE7iI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YZViXMWy;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of skolothumtho@nvidia.com designates 40.107.201.49 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764090898; a=rsa-sha256;
	cv=pass;
	b=IYvVb8eLUdJFKvPlaslh1BBcbWDpooeHsiXShHpgK+2CYDTau8C3Il6tqBCGillknxLufz
	zhDvXuPWP2ugnQOD9P7xWEmJSgpp3x0gKfUIpXHogZHV6VBF/yHs+Chjf/9UPZ1rQ/vT34
	+YAm8Qk6pjZk8emzv/Ol1nUPNO+qSdk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MnbTNjbi19ekkjJekr9eT3UG5tkwSgXT2hKPIxshuwUhlK8fUTEHsACUvEHFQct0b7O492buJVe5EIDeAcPMx63CjW9hsPCoZu4GqwGmKV1tksRIKUf+D7JpUOjT7nETyrAv4AN06BzJT2UPkxabPoPlq0gCvouSxdDp2KmYXkyJjwFPzNP5TgyZtS+w+VKQ++N4AcEuEW7VSSBugLNSF4Co203oRbF4dwROkwP++w+lX5T5fDxhWCY9q3dTfg9xHiWj1o+AmAhajdeT6QeagiUOoR3TX+Z0oo0INNIYi8TfYYzHdUYM/kCu6SGXIFc/DNUmsVxzq9ecUhvWSgXp/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asBFX+VQbEmmjaMePYdyDRP388R9FuoW25aAx/Aw+Hw=;
 b=h1dKHfDBKaQjtCwfF4s+JnRfnH36pCwWfsnYAbCIiJHtes3rYVnp2OVDxbHp5y+9kUGYolDvEG/xBzEcz1280kEo1Hi7JHZ7ZxkE3DtafeuP9RGj7cy5Kg4bHsAvVvE1+mwEkVybcyIfn5ijnBlnhfvqjOOCDU8ANLu7ndd2GePSbNbV1pdy0k6nlr5DbxBeFd6it9Bycd6EZpzm9KwkkcJ603CpdFqwQA4X/WtEFFZ2iAjIN37qB45P8582XqVR+1SfHIaozd9oijpyQPz7Dlhs2PfXGiJITE+0jNeCiTHOu4iPHJrboMr1vayiY3Nu6+0BHZQuKlWNSO1DE2ts4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asBFX+VQbEmmjaMePYdyDRP388R9FuoW25aAx/Aw+Hw=;
 b=YZViXMWyjVtBnNRFBQLbC60uUQ6ZSpRERk7RAFU4edtaA4YT5U8jiy0/TjkbLPJY8XFvGsW6f47L72YHm3W+QdMHcr36hcQpXeDhZ/Ywkp4W8qIPc1RW2IFz5h+AXZsUUxpvl+LWUHkO9tl+SnqOB7WYJkRPOEXbKup5+mlarF59YR4kmQ9doRMniJ9VbMvmUa6KbQ3tXX4/KQFo2IV4CUyjOVO6RrVi7dQrX+491jOcAS0xDRHGBdfb06llwtMfeMb6DkB/0WTWzZi4fAlrMv8SrvGnG+qTOgTHDRB+Dft1JpM5dQws60ErUMb/ikN+3TsAEfOgzLRkqe+kHLpG8Q==
Received: from PH7P221CA0074.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::16)
 by BY5PR12MB4082.namprd12.prod.outlook.com (2603:10b6:a03:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 17:14:50 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:510:328:cafe::17) by PH7P221CA0074.outlook.office365.com
 (2603:10b6:510:328::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.18 via Frontend Transport; Tue,
 25 Nov 2025 17:14:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:14:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 09:14:25 -0800
Received: from NV-2Y5XW94.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 09:14:22 -0800
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <vivek.kasireddy@intel.com>,
	<joshua.hahnjy@gmail.com>, <jgg@nvidia.com>, <nicolinc@nvidia.com>,
	<nathanc@nvidia.com>, <mochs@nvidia.com>
Subject: [PATCH v3] mm/hugetlb: Fix incorrect error return from hugetlb_reserve_pages()
Date: Tue, 25 Nov 2025 17:13:50 +0000
Message-ID: <20251125171350.86441-1-skolothumtho@nvidia.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|BY5PR12MB4082:EE_
X-MS-Office365-Filtering-Correlation-Id: a7556eaa-137b-4351-64d7-08de2c46245e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gE95zG2ihnOSEgikR/lX5znp3OqTiGx3RLa9ssr7ytZ12aJcH060dfdDv3L5?=
 =?us-ascii?Q?h3bn87ysFw5a45/13GNBTB/a1myYPN+NoLVJBEIb4jaTLXQUUx936h7xWmqR?=
 =?us-ascii?Q?dUqvqDt5DhBMuj6Ah08HhLcl9jkJI6w0QXvwKnXshc9i7OA7Igi4FUmnOxsO?=
 =?us-ascii?Q?zhheqFGyPMsEKYpxmZibeQBz9nKzQOSkNK3h/yCN0UjDJpIS/elXT16bMXqT?=
 =?us-ascii?Q?onZk3PIQ0w5Ipa05AshiKIUZ034pSkyFmIRg8KzEzu0UN4yfkvWNiUGr/aYs?=
 =?us-ascii?Q?8nbAzrPPE9tAEEWjB5yB6rzeXI7CwZ2eShZa9P+OSZ83nalqwcLqZAKm1IPG?=
 =?us-ascii?Q?vhsyrMtaJHZ0Fz1ZdVEUaRS4HoBd2jj3avlCC9pXhw8KvPQFpRNCtKpGECc9?=
 =?us-ascii?Q?2rWbDpvSaaOhECswscImqyER+Ph4JTKsQqqJbC+n6T4bcqo54fq3Hhd+6hxX?=
 =?us-ascii?Q?qg+CnGb325ptS1SyZwzijpFYb1fsKv+HKwfr5oO3yvUjhid+qM6lR/WaSLpw?=
 =?us-ascii?Q?jgUGY6gIpYGAuLaOxmzuWfRYS/zbpeJzixhRzp0pvTig30v17eN3WTfKeW2i?=
 =?us-ascii?Q?qIFHQQxFmUxhiZ9SA+MdfBnVXkBXQ/sjiRtJ2hy7DA47x+J5OLQHFBvn1zgi?=
 =?us-ascii?Q?JqDxVDVBagXhBMECIuAXQF7ywzARbuiUWp3/MT0PLd9l3bxhEjvMVr4H0Q/Q?=
 =?us-ascii?Q?ynOrOem90N7B/8HN9d36kX91SskGIA6KDLIKbwIEL6I6SOH0xIK/CBZSyk+5?=
 =?us-ascii?Q?J1wBvfCxialkhPE+bSWMJC0w9Bmo0mjAiaHmO6kyviwuzXcOMtcplMQH3f3h?=
 =?us-ascii?Q?yFl5GqxTlqmRAPSg8zy8n+8L3Gq+W/dDzeO9LggAwFCfyj99sdfLTt8pSqH8?=
 =?us-ascii?Q?xYlPO0M2XktXRv+lkq9gE0LqGMhh0xjZy/9rE2wcPl1+ekL7XAV4Nx19kahW?=
 =?us-ascii?Q?xmz7pwjw+Xd6c7LHl4IMpM1kVP/5NjTac530FkOB8gqwe3CmW/f5DDL5FU46?=
 =?us-ascii?Q?NmxYISD3sG/VR33Uy0ME+VWwARJsfTttHbbCXh1TM68V502hxXj33M5QP1Sf?=
 =?us-ascii?Q?ObDJXhL+8e19FZioA8hdBQpcjgZNiBiEcn//SzhreTCgWUg9vLwTR4Ax4Q8r?=
 =?us-ascii?Q?g6OSnw1C1yGzH5uwkzh938434Rjk/C7LbOebLMlz8NjE69V0tIrZbt2IWM/+?=
 =?us-ascii?Q?hFqIw88Fj527k5n/iR86lgfbsdD6D+VwJkjOxuSgpxmddXWpW64Ai7oXrmiv?=
 =?us-ascii?Q?uehvPINQpK+fq4VkA43IWfosWLrb2Da3+Fl369PdYF/ZCQUA1P3XAecpeF20?=
 =?us-ascii?Q?pcniwi3jW4Rcir/r6MNQ1HkXG/lD7VtgzDVmlHXNI3XVYWzUJiJrrGF6LBcm?=
 =?us-ascii?Q?U72hP8+q1KSfWCTxtgha/naGkFuxSPr0CeveXH6EhjGQSKkQUAQVpSyOXZFd?=
 =?us-ascii?Q?aOn2zYvlDaEMPW9x7ZUWsYR2YqNRX6WovZxdns37UCZD12/p7YMmDVkgqhRS?=
 =?us-ascii?Q?UsSP4CVCBdzvZhXp7iC596Z8u7rtQZ71lE+RGgS8OARfORlFjlV2PGIp4vhQ?=
 =?us-ascii?Q?FwAg18b7cT/2TXdjp4r+IJrREZwpIyWSd61jk/RH?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:14:50.1764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7556eaa-137b-4351-64d7-08de2c46245e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4082
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CC9340012
X-Rspamd-Server: rspam11
X-Stat-Signature: qbs489fhajaphweaj3kpzi6tbzjtmrpz
X-HE-Tag: 1764090898-74610
X-HE-Meta: U2FsdGVkX19dMoHUpu1WO06T8nZxE/x5NzcYTrJTWxComXzL1dq1FG3wLpvcPRBh9IRmxQ0+fD6bfSITWcHoFI7H3tFNFvsr4gjOMjBnFLRgDBI0Xj3nunSTIvmiNpox+eUSrp0SJuO3kaVMZIcpYj5UAyuiVjOGFBFWcOPCyI7QYA/6i6GgE8iZKblNUw0h7RON3v2fjQ072hqYZunAaGz8ggWsvcKKB77ynvKLLsPMZIVDOiBN41dHULWSAk6xDnOR+4H4n//szaOxkUixqlliXQLDNzwzS+0SGQ+dccVH83UzjuhjuH9AHjW5jwxTxOamJ+9kDGl8W89caWuOw7kWBT6WxunHNTTquYsqnTl49djKZMWQNruvjtfJdrc0IPfDEHqF4Dopq+c4E/q+ClzqKfv37KisYCyoimeKl34jB9KRVC1MiX/MrKHHi9lti9ffCIHBCWh+LtqaUq8lomGorxSHJDKYdf46erPIcZQDcJN6VcKpCUbridFyq71Wf+KQYUoBGPT0cRVH8gE43pHo+K/O1WWy1ywJHcGvSWq/5clMBm6GA/UEhRAXGi+iJtegqH12YIwFYdGE8BuYehHNvMrDNj+OnPByRqjFacvgfOtxxEqXieW7B0y5jvtVUjkH4QIprXZ++te5kFWA7VtaT/4jrrFua45rHMvfkUAhclKSG+87kCRNWHsfzsIE0JQgA29rn96K6PXN1hqUluNvQ79yCWAgsVNhhaNKTzRBXvjOP74vG1YDzdUMBPI+sKv8Jk2m5MSkKlWpPMYrE/VwsW+i28R1K3BKUqo9Wbl8OPI+Z2IRohWQ/TyUPlfzibfs0H7Eu1B57dyTUCVOzHA4Vpfl1GZKQpJbpUoEa/7UdZORMqIhR9t/Z1jMCJbRGjOlZGxA/gjgCyF4WScSE0enMe6BGP6ZVWm6GNXd9dfWDy+3DRtc0jzK78vcg2cM6GeM+ncKzkf/lsVzsBd
 Cg6xK4Xd
 TZCOxyJlxgT3bATvJ5OpUHc/ldfQdO+m1TWA1kC+SBS5c7z6Sxbt0mFMkJa0ZT5CAdPt9TTL/KjCGBuG0fpgHXei8OvQUUoHGLXvghqWGGQlHZJir6FR9uZM6osKJ+9m46mqxRnVY/kjWe3Vbj8DNjeL77DS3gZO675Nd91lVK93pnSj1nfTUvDaUK/FowUu8kmwpbsOALxFKehsSeUvdJjJkde91HAHKR98Vt3+zqH4vZk3//4K7M8N5vHsz+r7jONARCgesCBCFn/JDj8Ui2wJAx7iBgLaCJwiXRT+ZnypgwQzB5MpMuXGE8mqYKvoyff86+xEHoCcdSRXKogji7dPX5Ci16NnKg0V045ufga5G7Sfq4vrGjHLWp2KKBvfAVk78p+lW/obUt6qH2V4vXxTPJkKP9KxSZK8SikUQgdtGZHJUjHQCzCNKtKaBJoXuu/QCWuYtr5SGY/mmQZzgpv19S7Zw54MOaDK3550eEc1dKKxY0mzOg8HOVnozpi6icP2vFLeIMpxTpnDml7VWyQLeUPkpUxRPQUwW7+ZgNcyQtBwNr9DREHE/aU9R+0k2PX7sdr0HnGJN52CkqchIobi+OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function hugetlb_reserve_pages() returns the number of pages added
to the reservation map on success and a negative error code on failure
(e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return -1
directly.

For example, a failure at:

    if (hugetlb_acct_memory(h, gbl_reserve) < 0)
        goto out_put_pages;

results in returning -1 (since add = -1), which may be misinterpreted
in userspace as -EPERM.

Fix this by explicitly capturing and propagating the return values from
helper functions, and using -EINVAL for all other failure cases.

Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated")
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
---
From v2:
 https://lore.kernel.org/linux-mm/20251024094240.337630-1-skolothumtho@nvidia.com/
  -Changed err return for resv_map_alloc() and region_add() failure cases.
  -Added R-by tags
Thanks! 
---
 mm/hugetlb.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0455119716ec..868caa6476f5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7269,6 +7269,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
+	int err;
 
 	/* This should never happen */
 	if (from > to) {
@@ -7308,8 +7309,10 @@ long hugetlb_reserve_pages(struct inode *inode,
 	} else {
 		/* Private mapping. */
 		resv_map = resv_map_alloc();
-		if (!resv_map)
+		if (!resv_map) {
+			err = -ENOMEM;
 			goto out_err;
+		}
 
 		chg = to - from;
 
@@ -7317,11 +7320,15 @@ long hugetlb_reserve_pages(struct inode *inode,
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
 
-	if (chg < 0)
+	if (chg < 0) {
+		/* region_chg() above can return -ENOMEM */
+		err = (chg == -ENOMEM) ? -ENOMEM : -EINVAL;
 		goto out_err;
+	}
 
-	if (hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
-				chg * pages_per_huge_page(h), &h_cg) < 0)
+	err = hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
+				chg * pages_per_huge_page(h), &h_cg);
+	if (err < 0)
 		goto out_err;
 
 	if (vma && !(vma->vm_flags & VM_MAYSHARE) && h_cg) {
@@ -7337,14 +7344,17 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * reservations already in place (gbl_reserve).
 	 */
 	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
-	if (gbl_reserve < 0)
+	if (gbl_reserve < 0) {
+		err = gbl_reserve;
 		goto out_uncharge_cgroup;
+	}
 
 	/*
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	if (hugetlb_acct_memory(h, gbl_reserve) < 0)
+	err = hugetlb_acct_memory(h, gbl_reserve);
+	if (err < 0)
 		goto out_put_pages;
 
 	/*
@@ -7363,6 +7373,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
+			err = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
 			/*
@@ -7423,7 +7434,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		kref_put(&resv_map->refs, resv_map_release);
 		set_vma_resv_map(vma, NULL);
 	}
-	return chg < 0 ? chg : add < 0 ? add : -EINVAL;
+	return err;
 }
 
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
-- 
2.43.0


