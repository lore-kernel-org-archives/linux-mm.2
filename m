Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BF1D148A4
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD04D6B0089; Thu,  8 Jan 2026 16:47:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90D96B0092; Thu,  8 Jan 2026 16:47:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CB76B0093; Thu,  8 Jan 2026 16:47:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 976FE6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:47:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 387C61A02D7
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:47:38 +0000 (UTC)
X-FDA: 84310133796.30.84A5553
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011057.outbound.protection.outlook.com [40.107.208.57])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4E44F1A000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:47:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=v7+kFNTU;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.208.57 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767908855; a=rsa-sha256;
	cv=pass;
	b=sko9y6hG3agfDaqQ4SqAHnVxrD8MlGnPrbW4vT0q480MkwXGk1cdbovXklKLidKri7R8Il
	Zxn0D6kL11Nw27A63/aKwbUyhyvmxhA6iSzzh0gvrPzO9Ob7JJ4Evd7OnF/gmqh+LGCQxp
	t30RV8qACiTAWba0JdzDA+GMiKhsyIk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=v7+kFNTU;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.208.57 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767908855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IBPbyt9UqMeKnoYVnUG4p2I8HULyUtB7j9+R8f4hFnI=;
	b=HBt6MOQl1zf0LNTmxv9f7PEbJi0VLrEQrCYHhf8Ak1zaOunhI8+KSdzKPncocQm6+j+7uw
	bMjnTGbUW2OuvaTrfSvNbeuX7Ic7gG1J7pRT2HMhYRkTPS7oafhv9VOsiz7pVe1zJpbN+F
	9/mcnboyLBqvOzYyqkl3vNd33WswM+I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iEs1Whjhri/woDJvqxy+8V6cy+Tnxd7oivhSzRl3VFtzfgzVYq3dUcBd/M7E/c8CQ4WLKTJq4ZlRRxxv22M9c89qCmZQnJ+ZZ81phBoX/sU0w4pcVi/xUEmnRIbY9d1Qy0lBI+tByKKR5ldfrR6a68ctQW+eTwXEL91EUaEUwjsUGxtRtRtW7S9OqZoWYnaAlKKGpSNNo0A+ZPAdNpaF7gOanyaiL1ZlrmNIYthDixozv52dhIgjwuS52OvXu0xdhXtTzihMNdNruO3d9TKir99e3x27t06Ms+4IoLYtBEZo19njUzQ1kJQ3HVmawyVCj8aGOnZMHNDqBU57sPn0nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBPbyt9UqMeKnoYVnUG4p2I8HULyUtB7j9+R8f4hFnI=;
 b=thBZ1VUMWjbfrwWM68NDTMyflDKalCObwlm4r/DOvuVI5hm9eAHCiYiOOfKwV0+oTHJ0xUeu7MqXHIwSwQMudPfgomDK54/Nc49RjYA4kjuvd1HDVyxLJ8xX1yrxHugUK/Ag+lVUEpapfi6oWDyRjmUX2VA0G6xbzlfqUa0/LFSXrs8dKqW8OrflcsqPsdyR3d+GBtGJabR7Zs4fhbjuwmD7WsKyTgXjhQTAyRJMEOa/cYFvxq+1A5ERlX/cb2loywK2mc14IkQ04iIM5J+KFo/McKZHKBtv5jURZ/vWrtajExbMtHEQM2gr1PGul/i4kW47eMdptm3/mpeaVOjBYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBPbyt9UqMeKnoYVnUG4p2I8HULyUtB7j9+R8f4hFnI=;
 b=v7+kFNTUHKtBux8CuqgY8PLPMXX8/weIw8nKw5yeXQCnXcObMBpuPbCMciVpGy+va8jauW78zDJGZjItK9Wz2PIFZl6/GBa36o1b9SINDlsm3Mky/60AsZmM48xWlHc4BBY1+Og2rOzYzOAq9GRUHmo7ibgLA0tU2og6da1BmOo=
Received: from MW4PR04CA0260.namprd04.prod.outlook.com (2603:10b6:303:88::25)
 by DM4PR12MB7768.namprd12.prod.outlook.com (2603:10b6:8:102::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 21:47:31 +0000
Received: from CO1PEPF000044F5.namprd05.prod.outlook.com
 (2603:10b6:303:88:cafe::a2) by MW4PR04CA0260.outlook.office365.com
 (2603:10b6:303:88::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:47:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F5.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:47:30 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:47:29 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v3 0/6] KVM: guest_memfd: Rework preparation/population flows in prep for in-place conversion
Date: Thu, 8 Jan 2026 15:46:16 -0600
Message-ID: <20260108214622.1084057-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F5:EE_|DM4PR12MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: 3384d566-3e11-4634-641b-08de4eff8613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iKUw+a+9fPSTV4hgviGhtjN9ApuTWovtSpYWjoE/pOvg8g92E9VVfzbk0wJG?=
 =?us-ascii?Q?TGfiCA06K6pBVOL+4TSnpKiJ4WWoSJHOqoE/f+az7AgpdemvQFDAxtjMdCHH?=
 =?us-ascii?Q?FOMk592Oz05WUoe9Nm8CoadbKfS1hkG2CzU4wjT1s9pAAVMWrU3FtjNtlMxQ?=
 =?us-ascii?Q?Yz6KjiAq8H0RzFSnAblzrAstX3Aqw/xzRcf6ibhoYvfHxo9t+uzvDUE0ybuq?=
 =?us-ascii?Q?/5xWPvAB21DHxsXLI4ibCgFf/3k5HV2YqqR7OUel/n9hj1X8u65lFskfRJtb?=
 =?us-ascii?Q?YXXc8kIcXWoxOinneBrL5pJrvrAhiqL6a+S3lALTmnp0Gw7jT3pVVnLvu7hg?=
 =?us-ascii?Q?epc999QRvtYdmYKPn9CS8NvqkwhFxnbwBZBXiyMIj0uTp9sbf0WgxPbHLHEY?=
 =?us-ascii?Q?ag/8BReZJiW6crJjVADnzfD72iKkrUMW0X4hPdq4ZVnfPcPVHWbrYHqiin8l?=
 =?us-ascii?Q?mGwO3O4NtNmRBzLu9YutwE16nx+9PidlsfrisZ7lBH1iln/0Jq9g5ykxKZPb?=
 =?us-ascii?Q?mZN9vRx0Bphq7HYp0zDWEvzPWh2KXMvAwFHSC0yaItgx0OxS1+Wkv7lhm3HM?=
 =?us-ascii?Q?nypigzo42zrdQDwOLuEaOSyMwbgC7EfyqM54Q5Lu+9/X2getjRZ166P/bMzS?=
 =?us-ascii?Q?AV0dj/DVey1zdVtwef9P2eXkPEhs3epK4zSWISUpSjjOoMZlnKAz8VI0DD45?=
 =?us-ascii?Q?Tbb6hd5BekBzniiwqHdwjXmZ2jvUNDR/L7t9HhgB0DS1aTm6Z68w5u9Mfo04?=
 =?us-ascii?Q?y/3dz1yWc/PU/YtPrRMh7YPtt46H6X8ctDCkqQGNcu1ViH2PJQ/heaydQt1G?=
 =?us-ascii?Q?oCnpHYzbdSD57tn+ft5p2P++xfnn58L8H+fB8cyohMvPWXp0SiXR/AV4PAGM?=
 =?us-ascii?Q?hRMlWLyybXjpTzNsvIe/gloNCSi1y07puxVtvHQ2jpjnYPT3UMM5y6Axhe0o?=
 =?us-ascii?Q?65Tndm0yE4zhXAbyvXN7uJnvEoBOkpGzjUPwh4wcn6GxxPtmQmhKV+RcVmcq?=
 =?us-ascii?Q?l/THwW90vzx4hUX2wpYTvO5B6gtE9lYeVWApyhjedji40r38Ey2Lzznk/iRz?=
 =?us-ascii?Q?XZSoyQH6z+9ro52Ikwva3pUYEGABNu9OkPSaa9yFWw+48nmJWvD1tBxEOiN2?=
 =?us-ascii?Q?4SiVMY4tl9fAPd10zv0TVtZ/DMmSpIPZB4TkEAAmn0Y3I6MWXl2ut4Or1cUV?=
 =?us-ascii?Q?Do6L0T3xYydJntkwcM3QlJo/0YmhkGoRodPCkPj2IobSgOpvCyyTv+IPyqlp?=
 =?us-ascii?Q?nT9EwQT/QkrS5p5coYgHVLh2nZAOwgHE087OK4u1DJK1MbXuh+Lzah4z0c9C?=
 =?us-ascii?Q?Y2Yf1qgkMYZR8xuoQJI98wXDjTFyuyJK1/StR69mIJr3olx+Xax5vMP7fXHe?=
 =?us-ascii?Q?mu78h4MUHU1hGXNzQ6+pCfs+PmxMp/he4+uEO2XzJkgGbixxtakdQU50Mn6U?=
 =?us-ascii?Q?2gaskkPMwtC1qv+TA0OhjBTLPDSsxbHPu7udVioYPNbHEQTp64fBE0nEoE2v?=
 =?us-ascii?Q?pnC9F/gZGTTb4SzZ0i1UfKf1OJlR79R+l0mG6jcIEk+G6n8EwrNOwSXCTPFM?=
 =?us-ascii?Q?WkHGE9V4Jz+sdVvPKSzYHt3PFpuyRgJo19AWI7uj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:47:30.4904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3384d566-3e11-4634-641b-08de4eff8613
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7768
X-Rspam-User: 
X-Stat-Signature: hydryhxo39fad6mst5ctooq96qos4rdk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E44F1A000A
X-HE-Tag: 1767908855-76699
X-HE-Meta: U2FsdGVkX1/j9YmmSrfKqvKIUbR9wSk34B/8gEYaFsmTHD0P7sZyxgvFfKj4Xz9Pn6d9YooCHnKN5bB8PkVILdNq5/3wlDYeXksaIsmYRWsTrBidEd/lkoZvnRncCXiRGvSLvAVQHhdP2c+5sRVsk05gc5P3s7r5ZMiCT0lC3WQhgf4HbjRgzQVFbmB48/d3aQpaOpp/mm4kl9X67IuZzJJn705kY/pTIXR+nGCuP8EZIIG863vuxeELBjObE/o9SCUq/upr1zAFqLFTzL5Akgec0n1oS5L/UOsvpH+ZtsalX3v6UtvxejGN6BpNGp3/32SZuBEPfAOeVFlc/4fR75ZM/mWoU3mPqIFf9U7VedoAuEfr3f4ko4HyHlX+HBRg/JPKB3JeMHwoVMdWJ0ejbRHiBJnti5N5v4aPDbQcAMc2htwZ24CFWvTTI38U9PDVCqAZjtNzgTSeMFWgfq0T/sIn1YqmdJYfsry4vUCOBdvtazx4Ktt3GiYrJofMqw89LFjk700eAl6rgRkQZsbfvOqC+uo0dHvI5ycN+5k/d92P2j0QRI1N+QkieGs3uMqUGbJ97ZFxJYv41H6sqSGcl7YRgjA4SdMequCZv8jUjchw1nX7MdPqjfj5crxbYhq9XtOAwHwB5WNX71oDLLt5f1awQv8BDICTj3NTHi+FuriWxza5RNXQXQx2DcTArPNlq2o31C0r4EhpGlvj8Idct7w72wowzsyZvvqGnunSWT6F/M4H6rrPtp5jPnny29cY7mRmlxP4iUUjRB+OyOTcFvbUJODZtNpPLKZZg8+y4S+OV+r2OVuD+CBBDHypuJVWcNCirNYbv17PM+mRoXKvN0QLl3Tnx2yM9BU5BK/IukhtW6UYKDQHP7rDKe80aWUR7YDizXa0YUyB+c5qA+U0MGvNAEcWsJCatw0LGrPL7NmS+TSGKjJ1sgN8H9dJqoSC0vUoM9L6+xaObp10OAj
 MkboTh43
 b3Jpq73NodG48MM5KKd3KXKKMe8T5lbqxVCOV20ycdpUe4RDYcuOEAQxKPUCISe/wpZ+VnFeZNfs/FSY3I/FcrP1Q1vOIjFlVe2ThkBteNeVuhDIjEVtK/+w+CZBDKzAxBCHeRVCaDWLPrWW9FegJzL1miNvETVZLUXqObdRCL2drbl5Gdq3CJYl11WYq+/e1uukrKJVGFRnzKl8mdKY21Vlt3J9T3lS2Gn2gvDvMJAi894+kV3yNutyfoUWmIb5B/2emetjwlWQd+ZaT3oLd3+9PbkxtXI5VhWzPQdvTgBV9Es//0IcRbnyySW1NHGBkk6CuAAV73L9AaAoVkf9Lcj5vco3tj7++xYp/m35gcJ3kHL2+q4drP+Vu4WpCWNdOs33kIn2TDgpNO1ebMjvwbPzHrpPHtNSugdd7nwN2FhRpVgV1GWyZFrPOyb0hyFTiIhBOHirM3iqMTP0Pv9yU3L3WLUNBmgE8IBtSRE/wUXfzKZpbwPPDEwQvtMkTs4B/fo8kKrh0IO0+mNz9P3iHU1MCS3YbAaXuuyit8RmRewCAtpOW7qAORNsSx8CQAMW7jMnUqBSZmwdNipYSPdPxfZRorCuPu3IptuOYJXDVaEGkfRRQaaA2Fkiwbi3D9NPhceCVhIJV24DnVZ95mxoOi2uTig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is also available at:

  https://github.com/AMDESE/linux/tree/gmem-populate-rework-v3

and is based on top of kvm/next (0499add8efd7)


Overview
--------

Yan previously posted a series[1] that reworked kvm_gmem_populate() to deal
with potential locking issues that might arise once in-place conversion
support[2] is added for guest_memfd. To quote Yan's original summary of the
issues:

  (1)
  In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
  changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
  invalidation lock for protecting its preparedness tracking. Similarly, the
  in-place conversion version of guest_memfd series by Ackerly also requires
  kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
  
  kvm_gmem_get_pfn
      filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
  
  However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
  in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
  filemap invalidation lock.
  
  (2)
  Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
  resulting in the following lock sequence in tdx_vcpu_init_mem_region():
  - filemap invalidation lock --> mm->mmap_lock
  
  However, in future code, the shared filemap invalidation lock will be held
  in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
  - mm->mmap_lock --> filemap invalidation lock
  
  This creates an AB-BA deadlock issue.

Sean has since then addressed (1) with his series[3] that avoids relying on
calling kvm_gmem_get_pfn() within the TDX post-populate callback to re-fetch
the PFN that was passed to it.

This series aims to address (2), which is still outstanding, and does so based
heavily on Sean's suggested approach[4] of hoisting the get_user_pages_fast()
out of the TDX post-populate callback so that it can be called prior to taking
the filemap invalidate lock so that the ABBA deadlock is no longer possible.
As preperation for this change, all the partial enablement for hugepages in
the kvm_gmem_populate() path is stripped out so that it can be better
considered once hugepage support is actually in place and code/design can be
kept simpler in the meantime.

It additionally removes 'preparation' tracking from guest_memfd, which would
similarly complicate locking considerations in the context of in-place
conversion (and even moreso in the context of hugepage support). This has
been discussed during both the guest_memfd calls and PUCK calls, and so far
no strong objections have been given, so hopefully that particular change
isn't too controversial.


Some items worth noting/discussing
----------------------------------

(A) While one of the aims of this rework is to implement things such that
    a separate source address can still be passed to kvm_gmem_populate()
    even though the gmem pages can be populated in-place from userspace
    beforehand, issues still arise if the source address itself has the
    KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set, e.g. if source/target
    addresses are the same page. One line of reasoning would be to
    conclude that KVM_MEMORY_ATTRIBUTE_PRIVATE implies that it cannot
    be used as the source of a GUP/copy_from_user(), and thus cases like
    source==target are naturally disallowed. Thus userspace has no choice
    but to populate pages in-place *prior* to setting the
    KVM_MEMORY_ATTRIBUTE_PRIVATE attribute (as kvm_gmem_populate()
    requires), and passing in NULL for the source such that the GUP can
    be skipped (otherwise, it will trigger the shared memory fault path,
    which will then SIGBUS because it will see that it is faulting in
    pages for which KVM_MEMORY_ATTRIBUTE_PRIVATE is set).

    While workable, this would at the very least involve documentation
    updates to KVM_TDX_INIT_MEM_REGION/KVM_SEV_SNP_LAUNCH_UPDATE to cover
    these soon-to-be-possible scenarios. Ira posted a patch separately
    that demonstrates how a NULL source could be safely handled within
    the TDX post-populate callback[5].


Changes since v2
----------------

- add a separate pre-patch from Yan to fix a missing kunmap_local() in SNP
  post-populate callback prior to refactoring the code rather than silently
  fixing as part of the refactoring (Yan)
- add a check that to error if src_page is NULL in TDX post-populate
  callback (Yan)
- use kmap_local_page() instead of kmap_local_pfn() when a struct page is
  already available (Kai)
- fixup commit msg for PATCH #6 (Kai)
- collect various Reviewed-by/Tested-by's and rebase to latest kvm/next


Changes since RFC v1
--------------------

- add a prep patch to remove partial hugepage enablement in
  kvm_gmem_populate() to simplify things until a hugepage implementation
  can actually make use of it (Yan, Ira, Vishal, Sean)
- begin retroactively enforcing that source pages must be page-aligned
  so that kvm_gmem_populate() callbacks can be simplified. add a patch
  to update SNP user-facing documentation to mention this.
- drop handling for GUP'ing multiple pages before issuing callbacks.
  This will only be needed for potentially for hugepages, and it must
  simpler to handle per-page in the meantime. (Yan, Vishal)
- make sure TDX actually builds (Ira, Yan)


Thanks,

Mike


[1] https://lore.kernel.org/kvm/20250703062641.3247-1-yan.y.zhao@intel.com/
[2] https://lore.kernel.org/kvm/cover.1760731772.git.ackerleytng@google.com/
[3] https://lore.kernel.org/kvm/20251030200951.3402865-1-seanjc@google.com/
[4] https://lore.kernel.org/kvm/aHEwT4X0RcfZzHlt@google.com/
[5] https://lore.kernel.org/kvm/20251105-tdx-init-in-place-v1-1-1196b67d0423@intel.com/


----------------------------------------------------------------
Michael Roth (5):
      KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
      KVM: guest_memfd: Remove preparation tracking
      KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
      KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      KVM: guest_memfd: GUP source pages prior to populating guest memory

Yan Zhao (1):
      KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()

 .../virt/kvm/x86/amd-memory-encryption.rst         |   2 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |   2 +-
 arch/x86/kvm/svm/sev.c                             | 108 +++++++---------
 arch/x86/kvm/vmx/tdx.c                             |  16 +--
 include/linux/kvm_host.h                           |   4 +-
 virt/kvm/guest_memfd.c                             | 140 +++++++++++----------
 6 files changed, 131 insertions(+), 141 deletions(-)



