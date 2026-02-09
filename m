Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24213EF0712
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 06:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F320B6B0093; Mon,  9 Feb 2026 01:11:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F063E6B0096; Mon,  9 Feb 2026 01:11:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA866B0098; Mon,  9 Feb 2026 01:11:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7F0A6B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:11:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A135C258C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:18 +0000 (UTC)
X-FDA: 84423895836.20.F02A2FC
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010048.outbound.protection.outlook.com [52.101.56.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id A19F5100009
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bxtYlMa5;
	spf=pass (imf05.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.56.48 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770617475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wf/6hVSjZ33ruWCNlfjJdVzYU6gW/NkkhjSUi89Hosc=;
	b=Bjih4o1XSLbHhmBpq5aMN98DJAyZrGl3lvJLMPRM8OMRIEPKprPXWKnq9/tonNyN1WqQte
	t1tFeNyvEBikgB+ZJeDPXDGXzic+AftUySSvvLLWfHM/0rvV33zaJimpKFQretzK5iyLQh
	7rdqvv73rDQcm1Kb8W5eiyFWUde0TpI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bxtYlMa5;
	spf=pass (imf05.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.56.48 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770617475; a=rsa-sha256;
	cv=pass;
	b=sGXWZ3WUqDIQw4oiZThI8+o+lV4UPkuf6Se1S1aLq9qQchZUS1lHxzdY8cY512I+/Nh1YQ
	vI+Ch/1b/GtI+sh59vYv2lTgYX1Hjm+MzgvWT+2a8OsEkr3YVyk/N4phdW23L+ueUdqZTS
	n8kkcVLlDC9ZJDqKJRG1PORi2dC8zDw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FlJAlDNSyhNtaorBg8uvhCtPnssvT+gOEp2mVdcgleAYAUAHcc8lTgj5axg0f3M0Mv6iVVDeVHakKJHxrpPG4SAjeSKcdNlS47Y/H78p3BdmhHjXwsVbhaP4iqCDjJxF4REnJB1A9rSItGvACtyS0kMCJGdsPVpeGp8eL7Cu72bWd7odj83kNPrW5WgRD9kt00Gk4A7JtQk5C2CFWxqY0+/aYpvXqoSz+u7CgrBzRxEd6KSjQLLi1DZLKSVbHaGX2J5ZtLW+PYvLc+VDAenJytVn390iUHa32YC9BD+gIvQQgB8cGlzKKlk0tNnjZ9JfrmHCkC6V4wYCtZwXWQ/JZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wf/6hVSjZ33ruWCNlfjJdVzYU6gW/NkkhjSUi89Hosc=;
 b=KIC6xrZaw4zQ0rXBwQ+QcPNX4i4cYnev7jyIGa7xOCTmBRmtgAAM1UP65TWW/i5ArNxetWt9GLP5iRiFw/0CtKf9vslEmTNR4z+umn+aejkQW61yUPUwiCR1C6XV2/4eQ+QkJ6bV3v9YVM4Olenm8ITMrfqJL1gEWBujeHRj5E5uBfLQJSJxZPKqCBLFzRJ4a3DtCTdJHLch3wxiC1EPBEJBzWfG9PshTjbcoQdvgTu0jwgSIG1sozqN9he49evGAVq27dRiCzXzhLkTpiKdfU5Mh+essC3VoJdITYhKcDE/DZxqu/FnmD9Cu2WbjCj81plScs8HJm7DM1BX2reu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wf/6hVSjZ33ruWCNlfjJdVzYU6gW/NkkhjSUi89Hosc=;
 b=bxtYlMa5EsiasA3xHtuhBzkQClXa1wIyq9Wqh69LXt2pNfOjgTZVa6gtvnlR/iZcJqfopsJ6Ue1ZF+D0VuUrGq4jY4eYDR6SJ1uvfxF/V5p6wJSKXCfoj8+0mvpIOAjaYcSzU7OOQTM24ufTzQfvc2Y6PVjS0tCL37A8PkqseMk=
Received: from SN6PR2101CA0012.namprd21.prod.outlook.com
 (2603:10b6:805:106::22) by DM4PR12MB7525.namprd12.prod.outlook.com
 (2603:10b6:8:113::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Mon, 9 Feb
 2026 06:11:11 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:805:106:cafe::ad) by SN6PR2101CA0012.outlook.office365.com
 (2603:10b6:805:106::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.4 via Frontend Transport; Mon, 9
 Feb 2026 06:11:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 06:11:11 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Feb
 2026 00:11:06 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Philip.Yang@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v4 2/8] drm/amdkfd: Add user_range_info infrastructure to kgd_mem
Date: Mon, 9 Feb 2026 14:10:41 +0800
Message-ID: <20260209061047.3881808-3-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260209061047.3881808-1-honglei1.huang@amd.com>
References: <20260209061047.3881808-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|DM4PR12MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c8024ed-29c7-4e57-7ae7-08de67a205e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qOlsQDLVYa3KQZhjYVMMmHe9g83qDXZvWvAhSsvx88VWItKuK7DzCN95efs/?=
 =?us-ascii?Q?WJvo7X7rOcnV4wOV/MfqeTfvUBFb4M2km77/3aAyMNTc0gX3xHfHsyHBlm32?=
 =?us-ascii?Q?DrsnIus5P8ri2dWfz4bEE92W8nWnLqaRsAM7OCehV2YiIA8BIPu4Kz5td52p?=
 =?us-ascii?Q?BB71vzyGFyGGGb4jWEp3bNtigX0Wgx0m1pDLRw7d948KT2XPu5ttB7us6UgR?=
 =?us-ascii?Q?h4v7VrjLJhmsOp2X8nu/Mx4pkuGvmnanYGqbjwrXtQk4cMrCbA3l/AR/s5jt?=
 =?us-ascii?Q?xWsswr3jfXLPXMUFKqJcHYifqRkxyQb5spTzXbqXyXJlD4OCS3KYgK1pDdwg?=
 =?us-ascii?Q?+ynLP9M6Cd6OwiI+qEx6st0S/Q+OG3K+BFdvUWnJl9SE9UUeulOCkO4NGoxw?=
 =?us-ascii?Q?yqAgm1roonBRMKACfzFKYqmjAf8RNOOtLT0iBQUFKANz/cTqZ5UcQKTpg9x5?=
 =?us-ascii?Q?2sFDFY3Wkr2LyTR95kHCpin86rNB7aPOz7b8qW5ks/CE0bT/2HGIG+s/dz0N?=
 =?us-ascii?Q?QttgMhzFCgbuRA4Z938pHdlrePAXYc5wDEX0jltsvpx6sJUJzgQNyUEyozMT?=
 =?us-ascii?Q?QezLwJEuRSzOiNssguKQCUhg3H12NamWv7nmqeu9OG/QKlZCtpBHc7/FJqjz?=
 =?us-ascii?Q?g2WrdLoN6Wlx096qqGgRTCBO53TE+xyJOi3WijMJ1MTgP61YyT2gMORgLnby?=
 =?us-ascii?Q?Ke8WmDjr3DYAOZbGoA+qf4MybNDV+hfDjcJT5F4voeidpoiYTFS2KWF803zN?=
 =?us-ascii?Q?Ag3Xh7ZbnY3abBY+IbKSqbJULiZjRcXWDCCHCO7vIyICn3ffkRboAc9jvAWm?=
 =?us-ascii?Q?MosiegyqRbEaRHS7hWR5aY8zDB74vLTK5VryZCF5XR77wTCgbRQvzyyNUmVk?=
 =?us-ascii?Q?uIfPaqbGVUqvh61rPHFTikDdveMLN1Qe9Zh+XIGRlSInmwSRXNxB+OlCw2AX?=
 =?us-ascii?Q?BbDxU9o8uQMIU9Y6OR0c8btTJtSbFWVIAzuIA6OO2R9M4a3J7FR/MGqaMc6j?=
 =?us-ascii?Q?j5gdxGPKeZroXnnQgKn+20xq/oW4aC2lldFdy85un+yw9ySO+s73G5o/addf?=
 =?us-ascii?Q?A74Uh1P8U1SvxahOC+tSPSUsMIC748H6XmCsxtZcapfAfGVQ7C/5y0EDVw+k?=
 =?us-ascii?Q?UjaSLLjNGdlPg0V3ZNvFkdBzyo4yYe+Wx3zI3G0n/mB4rj3B61hpT4MXBHBZ?=
 =?us-ascii?Q?Dd7mKgxFFP1jMMN0BxNt1aTlXFDwTlQkZc8mXAu7RFA8hPxpcMPWRnfwn6vv?=
 =?us-ascii?Q?WfnTt0i6E+edRQRZa6tjLqbRc04DPTH/vZjOXxPj8V0sOTxDwRoOVvZoWW9j?=
 =?us-ascii?Q?f/W4dH8AnzTPOeY6hcOjQxhdwvJRAgBLD9w40dNbv6o7XeAaWC+JgV1cVtvo?=
 =?us-ascii?Q?MToxhZcU8p83Bd0UWdzdyglAQUBIFm1hYpD+IvR98CcGXz45xfcgPLXok2vl?=
 =?us-ascii?Q?fT3CEUn0rZjyCl3UvL/3nzwzOLPnPZm3rZP3iour+/HPTYV4hi5svNd5IRQX?=
 =?us-ascii?Q?wlHiS7l5f1+6m2kWNUzicsGKOw0crrBDziVGWmI1gyqSsnMkUluT6/kYKw9m?=
 =?us-ascii?Q?vyxIbqb7e8SdfDQynXQE29uL+jNGdlaIjbhQnavN/w4DQd+sbE9t9Koay81/?=
 =?us-ascii?Q?X9H6ro4cGtkZIo/nIFi1e321tYLLFfN2gNtM0zQgtSM2jsyo+vykTi23LhDV?=
 =?us-ascii?Q?iGviaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OJQR+SUSTJMimMrxejpf0e+/qWmjn0l6qPh0vdW3qXTN8N/mnmKGoZOon1kj76+TnTruO0Tze8Oiod89lo2uT6xOCGnyKk4GiM3bkfYWJCLw184TniIiKzlzyWMeguHBPkOJDudN3RFkGeGtMwYUer6t0GcRx+qALtAc5Z2E1qJYrrUtww6tdqbOGqgeC5+geSmzciJwAdJnFQffq0u+l2BQMQwmrv9nqTA6UddPROhK2JUqTEHspr3VZFmA3K+4oHDUVANiISe0oU6upE43ObMpk6Lmcxs/ok891HDvZmAN9CG79gSB4496eOITCf6zLRTA9KXkeZuDRZl55uvLePmRR4zkZOpdziPFmWa95EPrQJ8PQFvOqrVxoqTsgxq6W3L5QSfO/htA/eEGp4vxiGSjrFrjbKl/bIEQNl058fdjztmCeYJQ3K6zZt6jQTvg
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 06:11:11.4256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8024ed-29c7-4e57-7ae7-08de67a205e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7525
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A19F5100009
X-Stat-Signature: a44t1efytj1sdc3ekfxxhyoyr1jy1rqg
X-Rspam-User: 
X-HE-Tag: 1770617475-611184
X-HE-Meta: U2FsdGVkX18bYfDg1A3zPV2gk513QObPBkFpRsZM0nDzhkOBMLbny28VZ4cw/aRY70rIIvGix+ioMs6NgpR9/Cx6Xy+S4gefZo93xv2Itdg/vLPqFsGzpfdG/gRQjQEqCH4igi9nzVlYTW+5MucNHKGDY2GW7iipLF2/j1YHaKzr4iLUUmezUiUDGsBK6CdAk7VHuEe24d3GhygXIEcwYTvpJeHt1qJcaCPlAE5I4Cn5+WBoLUq0oYAk3K2FMKTbjsg6aZDDADyR4fkR6QdmCAh1y98FfCEd3+6KifvnGs1CJa1uuNFF8G0Co+ASWzIZeIuzttJAgg17tkIjEGX9GTnnrBryZraWkRWaSdaX4w/3dY72nu6p+gb4k9b5MI8i3i1bKfqoXaseEgHcMXRp8m1IiYdkpH9DisS9aQT2ihFmIpsFRoMacKMSGet3dtrWiPHSF4qYMU6JCintUmyLsPQqCsLnZeqSPnQaYSzxBgFBY9ISVRfZIm0PHZ4kWwWiiHkRO1zML3jqizziV+nVTzJ8XAU6h5yE/QuHFXaRc2maHXT6avYqegZICpFlXXYJqA98RVstTpdBy650StQbNDwkOJcLQ9UFzgy4q3DeW6l+eX4Lw/qFLBZuO9t83sYrr5Gqobyys/OULYqfD5FR6FsMk/rK+QS5AXU/wjWP32SYVm+HNwFWzfuzgKNf7AmtFFDPCvV8T6ZfOZsL10a+bf2uW9K9G5Utcn3BNUDaxTt6JPMQViN+kQo0HqqQ59xL0RpVGnZW3NLL8ezJcURfo+CWmZv+OgUh0Q17txkpAS1LLgUA8Sd1Q7wITwDGdbALvjBb7fTSN2LshQVAD2YXfJF3h/xqBQRN8o5IiX7RiVarwgAOA8pMYr1tjz/A+QhRplpIUajwCBSQowMAm4IXjaGEEMYgCBOqYAVjRC5KRMqCniudD8jNe2KMwNb2XvUBeJGGaT6bANES/dJT6KT
 b5ljMH62
 Gj4N7pozyTK3ASA0i7/IzvWqrhWr+BmIeUW6kZuUJAnufn+lUQR3fDpRiE2d0zbVJwJxWDulvK/gQ3asnXYj61Xr5irUYDcXroySVpwQBSP6zmS+PXBiUssuGpZKGHm3D3+r1T+p49dHUD4QyaemZDrdTg9TzQf5Wd4KA4Kckkng7frzAI8xsnzrM+cbJKwKitkxhzFPukojOhAueAQsmMElyJBz2KeFowVuR3TbYsWcc9SBRcGjb9tv2XC65Zi7zB5q3Ucn5Ue+pBDl7WLNhnI/MxxVR6ZT4U62wTnlV2ZsY7M0F1ZhGc4dwtuCxDCLzabh1u55dDdQNleZC1IaHyV+oW4WHJXTogHhwbcu0qB7WJyuJe73HzCX0Js/5WA72krcseba0KY6fBujVoJbygMAQIbu9QRxXTIPOJ9YxpUKIuZvWdTBJkSjjCRj6+cVEcH6qMjBBAlBtCK0mWzHyDhkoQBON0YBGqUMimbP9lC1p9h3B0C7hJhVpHQ==
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
index 321cbf9a1..5b6d399f5 100644
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
+	bool valid;				/* Flag: true if pages are valid, false if invalidated */
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


