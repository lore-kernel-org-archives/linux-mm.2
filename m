Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F0DEB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171D66B009D; Fri,  6 Feb 2026 01:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE256B009E; Fri,  6 Feb 2026 01:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA726B009F; Fri,  6 Feb 2026 01:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DACA36B009D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:26:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EE808C4CE
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:44 +0000 (UTC)
X-FDA: 84413048328.27.2C776E6
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8698C40011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GNBY55Sr;
	spf=pass (imf07.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.201.22 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770359201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzALAS1XYkf2lFaOnKhc6iRiArYlmarmcvNNz75KjJU=;
	b=8n/STu4ogHNccL0WGaKRgQaR539jwPAeT10i/FOiifgJwW+TwWE8THYwu+rdUjutU5lKNV
	6pyamc6H4fJD3euM6WyVMb+B0kGGmyADAR/5og7+ka2jSRf8fvJYoC+XiAtW+uhAtBMK76
	pvQDH2CBcgJJnsm64uepY7fkrXlg7M8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GNBY55Sr;
	spf=pass (imf07.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.201.22 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770359201; a=rsa-sha256;
	cv=pass;
	b=Deav3Toz0yb486C/ZKknE3XIzbVYQW6RUnRqSKRYJ3OUf1jF5nNs1pnQZ4m9/gDrr5Qc8W
	Reprg8K6UlA/+ByzsP1Jnzgs1DfxqDzRkNzaxTjH3rfrdLlfrKbqv0zr1PLmGNvwaKjIbF
	bA25Z2uKdlgJhjJTcjeeZ48ebTwdLps=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W2DUmIlGwf7uNp/q0ZwYLeBGU0gtoTQgd/AcT8/joR0ktffM1uUwrgp+SWMJanU02YmRTxLaTgwL/ULzErkWvRA5IT5510+W/xTsFy58URf/14Yr5Lwq1z9FnDMS+l8uh56qLWgkKiHBjIL1lcHf8oSSOp5rS5nmegGhOzIIzVisw3uSeuz6MC4HsHJF5LYt4NWg9vBtdJx3PqHYs8p7VfKzQbwAg8zvH5fwC1glRSidF7x7YIDy3uAtHfAmKDoOmkgIWD5H8XJWwRdDauCzFDNcZwnXRAjzp47sb5fjJekCd7SKFokODO2lWBE4nl9AVEUWPm8gykv0RkaLLyhF+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wzALAS1XYkf2lFaOnKhc6iRiArYlmarmcvNNz75KjJU=;
 b=Kaw20EDljgkbbjjDIU2MA77NAYiPSWLyELjNHloTFCjR2rZLthRxZZyeR6X7m/UuK5VZg77zZHYaaA4ILzLPpzrGMIAFz8nfg3hhOYJcOc5auoXX6oS22I2XTgXWFdmsLMNFpG5SVnXXz+he6clsqMFVVWFjcavVNgK94wHFPaFaTZ35TI2WCVN+5J2CJA1u2mcalWBxkUGi211ztyZzmsEM6aBxoigYzD1jVmrbUxGidtlzVnJ+nimhhiNZIe6xni4rD85bpzV5KoUZogyOCOt026qcyoDr62ULiZHWvPfYGW7C39dpke4hTnnqS3Uma33JXBH7NHP8epaFCGZBIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzALAS1XYkf2lFaOnKhc6iRiArYlmarmcvNNz75KjJU=;
 b=GNBY55SrIYiza2A02UsZBThZ08sb76jvsjyvdeNNAKyBwJGaSE5fTYe4sl2k/qJWRRHHSeovIBnisyfe07agzqWupIfg6MFO6ib4x9l/mcQPm8x17jaK0oByxUW+uF4eGfe9utgolchnivGnT7/d0BZTLnzV3pmZmmZk3hs4k64=
Received: from BLAPR03CA0103.namprd03.prod.outlook.com (2603:10b6:208:32a::18)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 06:26:37 +0000
Received: from BL6PEPF00022571.namprd02.prod.outlook.com
 (2603:10b6:208:32a:cafe::64) by BLAPR03CA0103.outlook.office365.com
 (2603:10b6:208:32a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 06:26:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022571.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 06:26:37 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 00:26:33 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v3 5/8] drm/amdkfd: Implement batch userptr page management
Date: Fri, 6 Feb 2026 14:25:54 +0800
Message-ID: <20260206062557.3718801-6-honglei1.huang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022571:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: d863adf1-8187-4f2a-d29b-08de6548ae84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wLCO4L9d08nlfx93L7ytZvvI+KT0vKhb2pQS6J/umA4BTsKr9m4JNkFfkg2u?=
 =?us-ascii?Q?z3iVN0e+UKl2fQeIIcLUwsfoIsiCziqHY5zmMm7H4cKLiL7KUegf5xH/bHWR?=
 =?us-ascii?Q?e+cniB2636ypwh7Eoo9OMdOh/3RLYxYFO+HJgAT9OTF7zOXfkXMg71nDANBx?=
 =?us-ascii?Q?6GBh83TJByocqh2Vozj66UZNvRsDRvMdtbeXUWPhSNkh7UsHeoAhtTbezsiq?=
 =?us-ascii?Q?TqWvxRnIVBHZp1ftR9lgKx472FPhACqAUK6G71bPe9otWmfQCiEKnD3NyfvK?=
 =?us-ascii?Q?zKfgNjb9zDtVha/9rFtbWgh49aBvYtrEa91sMYhBEqzbkDOURPknLWgOwF1A?=
 =?us-ascii?Q?o5sL9mzZprT1zt9jGJve8IlzhWO1rwEH2ah2Kl9gs4pc5jwHKIPTPcZjNECi?=
 =?us-ascii?Q?olMdaVt7TQ7S5GJ/VHvT0m1bzxJI57BRm/xA+4aXhr/dbymYAoC0WoX+hSLZ?=
 =?us-ascii?Q?7vplklppUNkRsWhQzR01SFOGv1UODpdHTGXe1dTaFsg5VRiYw2bTmPVY/FKC?=
 =?us-ascii?Q?4KFK3DjvvzNiKyvgsgexTy9Ewnht/Yc9/wWJxhQnrJT7SAeCwQQ79a8Abu/F?=
 =?us-ascii?Q?MYYdsjSlHwkfkEVaarIIqy/hj/Fc1LSa+k77dPlvWpCtAyVs/qYa94YUtelQ?=
 =?us-ascii?Q?PhSQK6tsXbaa3Kw4ARx1T4Kdzmf1d7OGotKxG/sNPqLCkBfNPuapkdoFNvbS?=
 =?us-ascii?Q?XRsXrOTyD5Fcmk4htaBQdXusTGrnxv8DGCwy+Z0jF06Xw607JCIWBb5ILWK/?=
 =?us-ascii?Q?YzYwGeB7Y8sc7G1bS2q06YvbRezwvKSgbe2u26ElXcaomVnXZSha1F39S0g3?=
 =?us-ascii?Q?Q9A+kWf62q7SkQ+DlBv5fFU/Fr3mz/mUc/kPb7MT8lW7IsdqJLA1GAFNXGDj?=
 =?us-ascii?Q?diNgm6klTNAeF+S5QYTS4InV53DGX4blcG+IYJn40pv/mUxDOXpMXzTBuX8R?=
 =?us-ascii?Q?SdRY4MMFAhAxXavqnANPLy7rKS/H76lWAWmLMzAkCXSNVXF9gIbZOsxYPyXG?=
 =?us-ascii?Q?lLaq6/dsiHg7r20NaLEAvZnd/HIHMY/X3nOqHhU7jTQ5/9kHm9DTKpDVxeRg?=
 =?us-ascii?Q?bzq9+lNPE7qVuQIcEuuAJ8SdMFDV5WcIbsxnAWkaKzZo1mC+whNisLtbPjWt?=
 =?us-ascii?Q?DWdSLe4vFGeJnMVvyt2AaUNi7RUsvC+JUTouDQ/eK7pDaFnFdJZgxKaGmm2k?=
 =?us-ascii?Q?TKP+ZF7WXyh6dtlhDWeBQsglmOEPtZcdNl70bFxzcc3/R6Wy+j/1LQemGrVi?=
 =?us-ascii?Q?4ODdS4dYupQqFd38dgSnJJd13xvU7axSAJbftuGpCNfOgiAMJ7H8Syac+Cf/?=
 =?us-ascii?Q?6cTIymHEGYIy9RW4qVCirbiMDAzM23K+bzIJWcgAzegeY4gBP3U7fh+D4eKi?=
 =?us-ascii?Q?Fz/vZZc3QY1Kkfu16E9I1o+d4DR64wS2fyIGSh5AxR/QiO+WgpzUJlqV1qth?=
 =?us-ascii?Q?RdB991g3q7QxuLAmYjLwoNo1w4FacvNZCH0ub158JecaBtRyJWFenPaHhtyZ?=
 =?us-ascii?Q?i0jwjZGKWsjBQsYBlsR5uh8Cwl4mh+DA/jr+G9qSIl7SKU6W2PeZ74D0Rubu?=
 =?us-ascii?Q?kJMQw9B9O/3cFyZWowbmX25V0v3Pc6OZwBzFgucLDuR1GAOX9E2MIZmz3V1R?=
 =?us-ascii?Q?EtMCcZ60iKccXmOmr/JdXiLfTZ9W8OU3Ad8zko5hrUuaxawqFtg1H+ujDp+X?=
 =?us-ascii?Q?Hb4lJQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ACe0VkGZRadvBPx9ClOgovBmRnrHFuG7YUrlW8eTujvI0n0hYXA/4ES7rTvr07/F/XoRs7TnsDxrToJC+dtV2hzGJnUdHOc//D2VsxcCPqMXjfMp2p+G6oTGGZPZ2/4Kf4neLU2nqp/Tta8osmdKBNyv3DmCuD6vtEdCX8jw4qkSbQIdZJb4juPJ2YavTP2SvwLWp8j0adPJ2cb4zWtaJpg0pF1J8aNgPZWY7kCQE2pfS9j82592x9/30g/cy96ek+QY7rsSqqdl2X0XEnK1a+c+0NJew5gHnV37cMvPct7Q+y+U1B4bPMxkP3DbEcEBw4aYD9dqGFO5vn8kNtISkhXAkebSMip/Rjqzgc9vXWYOacP+Hk4EaCWyXwQEPYnD3KH2p6nyIlCRyJ3lq5pewR7D4d3kVExzY1rdNh/F0A7zGewu1wk275sNZhBPrYAE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 06:26:37.2732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d863adf1-8187-4f2a-d29b-08de6548ae84
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022571.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778
X-Rspamd-Server: rspam12
X-Stat-Signature: 8afizei5b8758bxj91wsefuuk6f81tu9
X-Rspamd-Queue-Id: 8698C40011
X-Rspam-User: 
X-HE-Tag: 1770359201-684933
X-HE-Meta: U2FsdGVkX19BdDhB6mVY3VhF9Jt9iulblJaeyYB+Ls5zCFfUAYDCGQ+Y6zdveFWJ0/aL5aacTVhmiSwYou3RbcZSi9sw22IJyz6aj90dhauBpps0S7YcxKg7Yg0hPj28DPZiJxXtlHwvJRw90vPpmG3rcpQXsudQSC/D0Llk/i0Ku/gns394+tS1OOmM2cuRRNFzwIW8QWFZDxrTKizQLLF1M/P7DTK9mGPrV7URuamuVIweoakkTV8f3esCmfvBQIGS8OlecGcYhO70L6f/Tu5UExFhh2pP2wI5v/kuSE7gi7LLVfTlrVXaCcqJ9QGtG/QnF5EVHlpxmeEDtKzDTkijgbWfFYnoi+/BjcvsI6sr2M4kv/5KMe3CGMt7ynwdTQpBKh9fn/Jd2kzbACez0cq9Xf7ZVboWiln1vSoGTTM/aEQhB6+O784a813qEQcnmerLTujewHun/6myXleU5kFqPiAWuFoKoqmpXlXCJDz00Ii65CP3lQCukCyi/qKJQMRJWeZV1vSf5/f/3gzIOVqZGI+EMA03DoCAvOXeNATJLEVs6nR39muHyUYcYouA40NErhd1H0la4LscCdkayXnFcmrcs2Ap37QQYQaG8xhQ/u3zocV+UPMCY36208uk1pMy4ShJdPrte343IHLwhRC3GGVRa8s7ZoNVQMtkrkn/YsrzX9vULCc/+DY65CCBNU+hP/FqIGs3fLOLzqg0v5SWcOGb5k4n5Wkn6pMt27hCjYXrXznTO8fgUq6CWE9qliViqg4WCaggxo0kdNNXwfxdW9PAQJjaldWy7PAMUYj2M7cKeSGr9TRFxgeIdn0xoe0TOVGPPz4Ys0uaozEklXBnzRsGtmNnnQISGf/qdgtbt7tFSaGpMpPNeyO6VcnhhkO/aT9xjetWQ6uyCFOj7ZUwGZKXbKjh5Vu4ExfqCtT1lwyW3eLurWiB6puKN4oVXhZpU/Sre6JtCjA7Zjd
 Gm067maE
 Nsfnnb6sIFSYOQPcPck5MK75JoTcCNNfkH9CwXwt2yZOeVMbv8mTGJH4Xq63X8EPb+rwuVv0SwCC6RTz1xb5pxlIzfPNZ3M8kZ1BsKSEtIcuDhT69snGLTNyzF+40/qlbBN2aXhn2z/ASyv0TAMlMuem63+S+erBKzVrfB5zivMQtmkrk+q8SxKvR8dlKywfSbdBHF7wCXyByYi9hn0MlIWt/3gLV6gvYc/msB49nKVQIsijNtQCAJwL56VHrv8d4NB9Ifj+Wlz38VCMglW7jwZZCUf8hJdvhyb7W0rV/Hq200XOUN9pe8rB++ar1ZdQgIB28jLKQDyYc51hdEQIIynKJXI8vQwtIJpeNqj4WDRiwaQGxsbMLpuh7cYXnJBkmIbY0/FJfMtjrU1oaqrAqIafNIfv/AtLzBECWHOvsurhrQRDgowmVUrUjudCrWKBTCWfImPCCZuWPPJRsJjQ2GaSMWxa0XtMY4heya5je2oMUmc8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Add core page management functions for batch userptr allocations.

This adds:
- get_user_pages_batch(): gets user pages for a single range within
  a batch allocation using HMM
- set_user_pages_batch(): populates TTM page array from multiple
  HMM ranges

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index af6db20de..7aca1868d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1200,6 +1200,60 @@ static const struct mmu_interval_notifier_ops amdgpu_amdkfd_hsa_batch_ops = {
 	.invalidate = amdgpu_amdkfd_invalidate_userptr_batch,
 };
 
+static int get_user_pages_batch(struct mm_struct *mm,
+				struct kgd_mem *mem,
+				struct user_range_info *range,
+				struct hmm_range **range_hmm, bool readonly)
+{
+	struct vm_area_struct *vma;
+	int r = 0;
+
+	*range_hmm = NULL;
+
+	if (!mmget_not_zero(mm))
+		return -ESRCH;
+
+	mmap_read_lock(mm);
+	vma = vma_lookup(mm, range->start);
+	if (unlikely(!vma)) {
+		r = -EFAULT;
+		goto out_unlock;
+	}
+
+	r = amdgpu_hmm_range_get_pages(&mem->batch_notifier, range->start,
+				       range->size >> PAGE_SHIFT, readonly,
+				       NULL, range_hmm);
+
+out_unlock:
+	mmap_read_unlock(mm);
+	mmput(mm);
+	return r;
+}
+
+static int set_user_pages_batch(struct ttm_tt *ttm,
+				struct user_range_info *ranges,
+				uint32_t nranges)
+{
+	uint32_t i, j, k = 0, range_npfns;
+
+	for (i = 0; i < nranges; ++i) {
+		if (!ranges[i].range || !ranges[i].range->hmm_pfns)
+			return -EINVAL;
+
+		range_npfns = (ranges[i].range->end - ranges[i].range->start) >>
+			      PAGE_SHIFT;
+
+		if (k + range_npfns > ttm->num_pages)
+			return -EOVERFLOW;
+
+		for (j = 0; j < range_npfns; ++j)
+			ttm->pages[k++] =
+				hmm_pfn_to_page(ranges[i].range->hmm_pfns[j]);
+	}
+
+	return 0;
+}
+
 /* Reserving a BO and its page table BOs must happen atomically to
  * avoid deadlocks. Some operations update multiple VMs at once. Track
  * all the reservation info in a context structure. Optionally a sync
-- 
2.34.1


