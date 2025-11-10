Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 201F9CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D70A8E000E; Mon, 10 Nov 2025 00:26:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787568E0002; Mon, 10 Nov 2025 00:26:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FE48E000E; Mon, 10 Nov 2025 00:26:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE868E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:26:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F2965CC85
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:26:30 +0000 (UTC)
X-FDA: 84093562140.13.B7BC639
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013065.outbound.protection.outlook.com [40.93.196.65])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4A91C40008
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:26:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="zmsY18/o";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of bharata@amd.com designates 40.93.196.65 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZJilzehVO8SzHolgllba1UAWVCQwH9ekuJ+xZFkyg4=;
	b=7kTnJEp4E+SaI3Dc7LcZGfXjcT3MzWbxronguKgsBsYXv5CUyYZefkhlOcabG4EfXZbzHu
	B0cYKp+9Vgey1fX04M1XRcpmO7XYLeGxFSItXQx46sQiZOFTSGIesHV9vCPFn08n/iFLsE
	btYCSobiQiC83lVz7uqsGvfsLHkP6rg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762752387; a=rsa-sha256;
	cv=pass;
	b=6S/JqYKWoyFf+er31e2d0yVxbiXpR5ZG3OSBsOkfvp6VZpDvld5nuNeY/Feh0474DnAoYo
	KFnzkuFfA3Z8HY3Tg3HgtjmaT7sAXKduLKsl+3LzGv5hX5saAjcMP/Vma98gXIF/FB8ElJ
	B1HQ26NhhWWHpHglSye21ERwLIHqCeA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="zmsY18/o";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of bharata@amd.com designates 40.93.196.65 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LaUjzKJLlzklJtQo/3OIAvuw3rtBRY7oH1DCvv8HenWF5Gc16lc4UBPlgKPkv443ChK9Gj/gYgyOp6JqHKxZ+23xCtut1OKwmLmrMA1Lm8jxWyONypSuzGiW0/L6HJuhrSZEqV1PEV0xR7b5UoJ8/kB73Pe3Tg0x10X1V+9WA39H9R5rtZ9/cmGp6ppwc2zjcJy9HZuEMU7QytCH1At57jWE67qYcCNQ85LsssKP1sdHbkrnpWA6AEkyLQF97Ho6D1WRBQf6Pk2ns78yQHbVy+DHmJGjN0B2Xzf/LvX35J1cKv4ZUZGlcZxQR5/nICDFg+S3+I1XfLP9eD2qC8Oi/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZJilzehVO8SzHolgllba1UAWVCQwH9ekuJ+xZFkyg4=;
 b=P8FtOHOsrkp9tjrowzPFEwkmZa3pCmIFjp2Bhn+MM2rSjDDN1eJYa/2KDtfkHNTdBM8e9naNq4v9W/bZHRMsf60iWYD6sXLsNn7Jl30lYj2UEXu0RPiqugpmydOt9/XRMz2wP9NatIHjlzHH93v2kJntHmBNRh/HeTwCVRjUZMqu71F/xAD5DMhysWQoOch8OmJ8SRFwSsvQLzLIQUpdzp9T8ehWEpQ0L5vh7A/cQRe4rZqe1ZfzYyqErf1/3Q+KOGwYlmzA8VEFhU7RyALRiTHWZb3cnZ2OUBvWnCI0mokm+Dp9vsnwhhL8XeKcE+scOkT2+g9lymcNtGhhbgeK7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZJilzehVO8SzHolgllba1UAWVCQwH9ekuJ+xZFkyg4=;
 b=zmsY18/o4N3pFJSh6JVqPI5ZzsBBbZqKomtjgdkkP9lYy4EbpN1SXwXoI9ftL/wJJycjPBol4ernsOVl2I4uCYgZdTUqEgRFcPA7QZVVtjsk3aE7hQr2Cn6Gg3e0qtvCmC5u9Ulo1G50reT4tioCr4I+BcC9bhVEHbvClKir+kw=
Received: from BN9PR03CA0134.namprd03.prod.outlook.com (2603:10b6:408:fe::19)
 by PH7PR12MB8124.namprd12.prod.outlook.com (2603:10b6:510:2ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 05:26:21 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:fe:cafe::24) by BN9PR03CA0134.outlook.office365.com
 (2603:10b6:408:fe::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Mon,
 10 Nov 2025 05:26:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 05:26:21 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 9 Nov
 2025 21:26:14 -0800
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
Subject: [RFC PATCH v3 5/8] x86: ibs: Enable IBS profiling for memory accesses
Date: Mon, 10 Nov 2025 10:53:40 +0530
Message-ID: <20251110052343.208768-6-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|PH7PR12MB8124:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a4545fe-d0cf-4cd8-a015-08de2019aefd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rV5vHfPZA6Qz6sE0HwTPKKZPOthCoqp5L4sHSOB4G9HuVhiFepoh/HJlg9vb?=
 =?us-ascii?Q?+cr1UYMB0fREK8WLnlp7EOx2O+XiiZoc4rz0qx3kjJ8W+l/ImXmw+M8s5ACK?=
 =?us-ascii?Q?zCkZFl0O6KzVAOZpqAlaugNwCqYNDnfVbBkZKApjuDE3LRDC0Ee2iqba2S3e?=
 =?us-ascii?Q?uCu8Ml6idcBVucpQ1qrG+uSeieTV0rmbwaQqKyDG8qesrKAv6DJ1+2qtfk95?=
 =?us-ascii?Q?r0tcPP3GspOge9UQwktiw6AsAVabykmVZzXcIsMjfoOI08TzpKpKz8RtWLVz?=
 =?us-ascii?Q?rQOy2kDgO6BemC5ViQdq2I04s+REZ7LzzqMD8mMAmYrbw8KgBOZyh8vkr4p2?=
 =?us-ascii?Q?tLC9b2g1BjChO2lpjw+ioxl1MIDaXaPhmau4yukJmSR8W/qX/TUjMgSk1EuI?=
 =?us-ascii?Q?Vn27InE1GQqnsn1FtTnSU1GnF/bgk24JM5Qu5IBF6WzruYleRY5q3dP6FDWH?=
 =?us-ascii?Q?SZN5GGE/+VZafhIdf+SlobiRTXb7XmMKXSnp+HmyLcN3JaAC7FZY7mDNbWBR?=
 =?us-ascii?Q?4dhwDz/ukr+xODxbhFpZ/D2O0qgZNVwZwq499xHR4sPgSW6s4EPBWOBx1J2Z?=
 =?us-ascii?Q?kSMQNrbhEaF/k0yws3o6EiUuVj5Q0K4YLoi/J5izin0W3ThpGPFBHYD0juCG?=
 =?us-ascii?Q?sntZ/+UfqkkrzEn3J+4Jn4jJ/JQsPgxvRwvakHHG++9vgKxfuNTefmjcMn4I?=
 =?us-ascii?Q?8YLgBa4qDRzMXrZHBGAOF0dOHIL5WMpZ6nQ6sbncz5MYJPI1rKFzdljDpoMz?=
 =?us-ascii?Q?/hyln03xtLrz39RnPJUbWPpEp0I/bu+2WXIe+XyMekYUrysHCNSbbX8Moehs?=
 =?us-ascii?Q?5OFt8+uNW1/cNOk4wV+OhNZC6il2n8bAXI8m5LcJHK3/NZZGQFpFglNbd3Gy?=
 =?us-ascii?Q?lvoWnHaaYLrjA+OukfCG9QmUhYrwt2VCbT2l52EN2uQQpzF9xHNonT4DrgSI?=
 =?us-ascii?Q?26AwZdI8mvU63LUQlM7SDM8nPBNk6uKLvsTmdZZtmlYSwotqmYiAbw78eiZC?=
 =?us-ascii?Q?zKRr1XzePkgmvnjJ2MYdD8AI+7SCF0R36npSLWFtHV5F4GnAak7+jDW7jdkE?=
 =?us-ascii?Q?m7nFJbV0PDVjmh04ky0j6Q++8bespT7cEyGGwOwuZbinufblhLaHtb1khLf3?=
 =?us-ascii?Q?bZGEgGHAaHMls/RvR94inozVBk4XJlBtuTk8jP6OwM5QXPYelJzxKCB8B4Oc?=
 =?us-ascii?Q?CB5FGcf6NWS2HkEOZarInAUJNM43xLPGxm+ehls2sexRlIWHHbMA10NSo57N?=
 =?us-ascii?Q?TjJOizT0tVThuKIcKztOVKoaHH0p8mcp0AXaR+LgOJPJVTr9QWaLaih+F/0x?=
 =?us-ascii?Q?XSPAkC7Xaepdcc4yIFKfTeCOPIDO+2ZufOsG97zc/JtNGgUJxu26+cExyyOT?=
 =?us-ascii?Q?muLVU4hpCoLvbRiJqATDNAcqMFUZ7gys9foVSU7ADHnRkxul2UkUUAwovyRn?=
 =?us-ascii?Q?a/B2BRJN0xPvTWP1V7zUq3b3WwXzouBpBtNtHhDR5e/Xi+Uz99hyTuDJDiWX?=
 =?us-ascii?Q?GRBBzs23UZ7OoeosTBZf9WFie9Csrt1eNibRfYn5vom93mp241AQ/H/sjN3m?=
 =?us-ascii?Q?YNmQKM97aybzReDalQw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:26:21.4900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4545fe-d0cf-4cd8-a015-08de2019aefd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8124
X-Stat-Signature: ew74i6fpownqc91fxxjzp6aapdnawe3d
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A91C40008
X-Rspamd-Server: rspam10
X-HE-Tag: 1762752387-531393
X-HE-Meta: U2FsdGVkX19GUslKp2bCso89YhWTwaYXzCIwRNGToPh2MC/j2VDyQUSLhEBhxdzdJUapfMXVIojZl9XdWwMyugsDZ+7yDt9G0y26FgiW6NwPvAwTA7WxxjDJdkLCi4O9az1p/nj/6LuIQPyo6jY8xG35LQ/pRpJomXDSJSXfAHrC6RMYOU4JaOqLLMuEKCk+8m+Ww4775RhH3hZ0kK29T5CIqaWRbwTG0RHamya/W3wvyEYlFnaS93XrDesFGoCf0ewHM7Ou6hqYELpEfo1XjRQIzCcHdSBPn+X3F0B3IwJcfd6b5kqTYtQcrcRk3LsryPI2xM0Qmmh9fJBqOvZuNWwxSw/pZf/zFJrH+Wgp3xBv2WJTuNVJGzHk2Nign+gYejzSgm+oh5oYsKWXD+VMq+qqEeIZ9Slkhe6pXaPHjrvT3JqdOtocUglRIWMN1/+XDTteWS4QrxKM66D93qZt1EYHEh9T6ue65mXY+/GTXYuxM9sawmC6yRnbMwTYRUQcnOW+f9BJBec/3o59J4BvXzBTBaMat7vGFMvVYDIOS2KR5Nk34xiZsToup+RhPwqnogtbjTFlv0+9FMUU1Gj/e1QqD8/HnIpPwxesI/+RcrFAqRTlUpDmpRaCIO+lnUK+eoOo4ZfISBFhBsOd2mwm5WYgVljlwMcGAJcjWNiPNuG+QN9Rw+A84+8qCfJ6aOp9RUlLIpTkmNa8tvHOz8otsgY4eYUrL5fKjhCd7EvcXOV9Yqm0q7pq9iY4YGPUetprp1Kt0uHSvEFqmjaTFoW4A0+awgwfIknY75fqnxi74QglagYi9JNdnjmdzBqSQY0YovIbFEnspUMfzb861kc2z10yIO846CtpLpau+yGsFzVgfVpufQCYshxntthsyyAyvjn9EXpU7Ff00szLd2nCXQ6LIJXeR9AACU397zKX4WGdVJHKzJPYjZxclQtwJzaK2PzrggWGl7f9bQn10PE
 6gi+40aD
 XGlGWrZwFDCpi7HaKdxxI2fCcVP1Hq6nxkofEYESglHFrTdQdyPyX2l//2fzqH5h4CyeDikbBJA0Sii1/SVSwj4i3PbiPsuiNTGhjIsTX2Jm7nUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable IBS memory access data collection for user memory
accesses by programming the required MSRs. The profiling
is turned ON only for user mode execution and turned OFF
for kernel mode execution. Profiling is explicitly disabled
for NMI handler too.

TODOs:

- IBS sampling rate is kept fixed for now.
- Arch/vendor separation/isolation of the code needs relook.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/include/asm/entry-common.h |  3 +++
 arch/x86/include/asm/hardirq.h      |  2 ++
 arch/x86/include/asm/ibs.h          |  2 ++
 arch/x86/mm/ibs.c                   | 32 +++++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index ce3eb6d5fdf9..46aafd34b945 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -9,10 +9,12 @@
 #include <asm/io_bitmap.h>
 #include <asm/fpu/api.h>
 #include <asm/fred.h>
+#include <asm/ibs.h>
 
 /* Check that the stack and regs on entry from user mode are sane. */
 static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs)
 {
+	hw_access_profiling_stop();
 	if (IS_ENABLED(CONFIG_DEBUG_ENTRY)) {
 		/*
 		 * Make sure that the entry code gave us a sensible EFLAGS
@@ -106,6 +108,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 static __always_inline void arch_exit_to_user_mode(void)
 {
 	amd_clear_divider();
+	hw_access_profiling_start();
 }
 #define arch_exit_to_user_mode arch_exit_to_user_mode
 
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index f00c09ffe6a9..0752cb6ebd7a 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -91,4 +91,6 @@ static __always_inline bool kvm_get_cpu_l1tf_flush_l1d(void)
 static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
 #endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
 
+#define arch_nmi_enter()	hw_access_profiling_stop()
+#define arch_nmi_exit()		hw_access_profiling_start()
 #endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/include/asm/ibs.h b/arch/x86/include/asm/ibs.h
index b5a4f2ca6330..6b480958534e 100644
--- a/arch/x86/include/asm/ibs.h
+++ b/arch/x86/include/asm/ibs.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_IBS_H
 #define _ASM_X86_IBS_H
 
+void hw_access_profiling_start(void);
+void hw_access_profiling_stop(void);
 extern bool arch_hw_access_profiling;
 
 #endif /* _ASM_X86_IBS_H */
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
index de2e506fce48..98aa9543c8ec 100644
--- a/arch/x86/mm/ibs.c
+++ b/arch/x86/mm/ibs.c
@@ -16,6 +16,7 @@ static u64 ibs_config __read_mostly;
 static u32 ibs_caps;
 
 #define IBS_NR_SAMPLES	150
+#define IBS_SAMPLE_PERIOD      10000
 
 /*
  * Basic access info captured for each memory access.
@@ -98,6 +99,36 @@ static void ibs_irq_handler(struct irq_work *i)
 	schedule_work_on(smp_processor_id(), &ibs_work);
 }
 
+void hw_access_profiling_stop(void)
+{
+	u64 ops_ctl;
+
+	if (!arch_hw_access_profiling)
+		return;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_ENABLE);
+}
+
+void hw_access_profiling_start(void)
+{
+	u64 config = 0;
+	unsigned int period = IBS_SAMPLE_PERIOD;
+
+	if (!arch_hw_access_profiling)
+		return;
+
+	/* Disable IBS for kernel thread */
+	if (!current->mm)
+		goto out;
+
+	config = (period >> 4) & IBS_OP_MAX_CNT;
+	config |= (period & IBS_OP_MAX_CNT_EXT_MASK);
+	config |= ibs_config;
+out:
+	wrmsrl(MSR_AMD64_IBSOPCTL, config);
+}
+
 /*
  * IBS NMI handler: Process the memory access info reported by IBS.
  *
@@ -304,6 +335,7 @@ static int __init ibs_access_profiling_init(void)
 			  x86_amd_ibs_access_profile_startup,
 			  x86_amd_ibs_access_profile_teardown);
 
+	arch_hw_access_profiling = true;
 	pr_info("IBS setup for memory access profiling\n");
 	return 0;
 }
-- 
2.34.1


