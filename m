Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AACFDD1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EBC76B0095; Thu,  8 Jan 2026 16:48:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7CD6B0096; Thu,  8 Jan 2026 16:48:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA886B0098; Thu,  8 Jan 2026 16:48:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F22AC6B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:48:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 933DC1402A9
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:48:42 +0000 (UTC)
X-FDA: 84310136484.26.3FF6118
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012014.outbound.protection.outlook.com [40.107.209.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A68AC0002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:48:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OOIYWRzr;
	spf=pass (imf10.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.209.14 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767908919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqhAPP7DM7ogn67eaMlEqzcRxGfRylkyRcISDB7jZHk=;
	b=22I4i3244nln6VkUbMdjxzSHZOxUOnbFO7CPrmndm9Y2fChvlVCr8LCBrVUHdHJdZXiHpZ
	gtThwm07SgWVM6N6VzQpWTdO6GWnkdxELALo4BlndJq62NJoCJSy7J/D2bQDarOSRDHhpw
	OEqqe+38rd+KokQ4nu696saa0fgm/Uw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OOIYWRzr;
	spf=pass (imf10.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.209.14 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767908919; a=rsa-sha256;
	cv=pass;
	b=xpv7TZ7GnSimgiUagBuyS8c/m5oNT7qXDCDop9gTHA1T/EMevtoiQi1guoQEJikP2lwlH9
	NkTboXxrJmxB92lH1f7qvIplLFEZ7fhk9Ujl1X2OsmnZYEeHRVDij4/9jZPokhdcKILT5F
	XgcsNyFnTjsX70JaHPvdK032g0nQARw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rf9PHvmqWoIl08r9rRVecjw2nuzWM7TVpaGPX0f4h7OOBOg20lLnDWUFbnsXU9+PTRPDDka73TvQhWuWdH+N0A2RUUd6w4a+M715J5tvwvojVyL+yAkUNm3K9U+XC1xdRP4sAT0ybzkQPdkk9FXjgitKkir0Hw1QSBNBKTemR2pejIyqHFfOGqV92rTziCNzhlUa33xmZ7TCQROwRFYfEdbEgdicpfQNxQT97Keuq4DFTKZc8yJGTIy6lDYv6QzNiSK2GQMDslLiS93UfY3W1PofgFJxf9vIcj0BfGN+D5MD6cTOyg/s4Yb6ccxIROIhH6Ovzvyr1W2kgsbrRoeLBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqhAPP7DM7ogn67eaMlEqzcRxGfRylkyRcISDB7jZHk=;
 b=NGFdNXFqN0vA43QTBkxuMFl2EngJqUWZTI0G5pvtKIBr+fT6YX+egR9aKc5wUr/NdS6poYTkGTAt7wtPMhvtk8yZWSU4QpE6IxFd3tr5wXTOESCyujI/6X09v9g5+RjanO2ipNNt/+lZK/RXS+5apLOrx7o5EJfLGMvpYgnIx082YMnbj29wOcI8IHbAtpphd2C2Vy7fvZS9vyEVWIAObQtkywzUL7kTHuIuoJhiWtsVZDv2mq2cFCaIXsrPiFOGwbld8yhbSlmFttyN0+urs9Inr+MC2FRRVYEWswK/9ncidi5XF30uVmXAThmWTom+w/nNBPW9r/6nQUI8ZeHLbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqhAPP7DM7ogn67eaMlEqzcRxGfRylkyRcISDB7jZHk=;
 b=OOIYWRzr2bC9N5kzfBJKKE0guVkK4/9DRTO+BxFUx78QIuyFgMJ0FkVC7P9R/8fkTKh+uOfpmV9jzSgN3zaywRs5jvZ58nixuf09EmbJBTKg35x2i27tgZX5GzcEvqnJyKoQsXJgs8yegnwgVJjcxyYZ0G978G1QnEqIL5YTIqA=
Received: from BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18)
 by LV2PR12MB5846.namprd12.prod.outlook.com (2603:10b6:408:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 21:48:33 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::58) by BY5PR03CA0008.outlook.office365.com
 (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Thu, 8
 Jan 2026 21:48:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:48:32 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:48:31 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, "Kai
 Huang" <kai.huang@intel.com>
Subject: [PATCH v3 3/6] KVM: guest_memfd: Remove preparation tracking
Date: Thu, 8 Jan 2026 15:46:19 -0600
Message-ID: <20260108214622.1084057-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260108214622.1084057-1-michael.roth@amd.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|LV2PR12MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 04760073-2557-4834-51ce-08de4effaaff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cOCTgbYTQeACiRnjr7+tpTSHOow9+tYVR30dQpx9p8O4YwIT/g9PxGQpmJn3?=
 =?us-ascii?Q?PlBQeZqtySkNDRZVe55PntEWB5neK9BBUNS800kiobfyYsvVsISL/YfDSNpA?=
 =?us-ascii?Q?uMZaWfvdG2yhq9mHlE3oJdcuv+sp5J28QnhTOyedYVcLlKc0sXkRPPp1Kgis?=
 =?us-ascii?Q?m2K8V3KUMapU2SH88+ThEx1XugbeQdpmQP9a4oWPL0Hy5MEOzxXM2yhsURDm?=
 =?us-ascii?Q?fdRQNb12uFzgJkLsyQHXTAjwl2wYHeh3s3tAMgM3YK7A77ElmC5fhj+pdgn6?=
 =?us-ascii?Q?BYJCOxYYZFgrkcEG3Fmiue7j4E1RHf25UL5uNEfi7VrARnEai/KBdieNGwuc?=
 =?us-ascii?Q?nxaG5sukE/v3IPisywvx+5roFebpgPJHtZARpOVxR+mtoiCgSYZKUoV7F+Nj?=
 =?us-ascii?Q?HQ91Hoen/Y3+jeo2xt6UGtX2Ro9gbGv9rJxgjQfK1y8+KMWGKAyp7qVqY4/y?=
 =?us-ascii?Q?xDVl/ROUg+vvkdIAsn4BVRQwNbNbeOTO8DF4SKMxRamiIib0AnLHixx/1n1f?=
 =?us-ascii?Q?o+7xqwnVfOmkeubpjrrH7IPNROjj/uWEXKSLJ6bww1bsVHvztTeC2XToYR9z?=
 =?us-ascii?Q?IyOHLWti52NvrGs5X+47406McLHHL2CGtYR3FfAC+q4e65PpEzbJ5h9n0CrF?=
 =?us-ascii?Q?w24AYG7O8AaXecaQFFpqqtEFV5drDQijs+sAVM3WwuetqfLkkeQK7DC7vZQs?=
 =?us-ascii?Q?RIIvTAHr9k2SZy19WRon45vA0zl8hZXc0ZQ+DrIF256nAw290t8c/NyljWY8?=
 =?us-ascii?Q?1lkzKbz+k6+XcYcxKbcTdAE4yXqCq0F59z0pGJoUZ9LcDnB6pFOPErGECksb?=
 =?us-ascii?Q?/WTJI9cJU74cufjYRchf/z1wpctLhhcRq0yAhiWCnNY2zmsIALvytQMXGGKL?=
 =?us-ascii?Q?65KeqjGUDjmq/4HiXmUA258rfftYj6MJ2l69UdXGJvsjRpf0kvf9kgYwprUi?=
 =?us-ascii?Q?veOFm+j9UBNfc+ANKJvE6jGlWGpjaeCgDBAVXtO9cJiHgtn3AnbEYs//XG8g?=
 =?us-ascii?Q?wZ6s8mOvC9TLgeERPaWnXyBRt3YV+i4e4pHo4vKoL4BJneDN0CvdN9TN7dAo?=
 =?us-ascii?Q?D/EQVffEt6Gdhi3RLOF4sKVum5KLpnJmCNu2hp3MfXD+QPkcWnAi4PHYd3tE?=
 =?us-ascii?Q?lbF81Y+8U/+QI57gAN3Ln3+nmBmv3Vqy58b4bYUPgbaJ6djr3Q0ExQvhuYoW?=
 =?us-ascii?Q?TcbpBWAi+OieF2Wxgjzd1hBRONpQesqS98v2ecxxCuts76YmDt5wL1UBJ0CR?=
 =?us-ascii?Q?MFvfQN3KP5Pq9LqtyQfx9fsdb0cy/yCIbTiCbf6jSe9b0aBgAsEAgTr6VVYG?=
 =?us-ascii?Q?/DPFCHazJXAGHq0KzVjjZfJxNkikRB2MJtyikN5Is7uwHrA+jQlLudu6GJCe?=
 =?us-ascii?Q?3vIiRZRdd2OQKgdGAG/5jnCkjEljIKkwict7ez2ef2XUPTt8vW/Xk/hFFB0e?=
 =?us-ascii?Q?RAT65O5hWbqmWBw5G3YKlG19jWgeO6KFcUdOR9c+AzWAO6bk9uXyvwqjJD+o?=
 =?us-ascii?Q?0ldZKzqvy3UPiY6IDByinFbj6K0b/zViQHojtEgXYX8TEqHuhFGH4QSnhiru?=
 =?us-ascii?Q?LQjX+aK3Vzm/JGMsh6s=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:48:32.4345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04760073-2557-4834-51ce-08de4effaaff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5846
X-Rspamd-Queue-Id: 8A68AC0002
X-Stat-Signature: a4xwh1k6isaezrrdbmwn886tbyq37jkx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767908919-605184
X-HE-Meta: U2FsdGVkX1/387rJJhaGKP20lXVqTT4x1c+tiMGVsndFeURJv06kb1ivX4ctretWOM7MHoOO4m5n/DUIap97LCBvUb0h1bOnlwt5sOtVO9z2JzfgGNB23bijulJQ9PO2uy5tnZL8fgO2Q5TAVojbZKk2McGTIJkdrHp+SqKmRguGJuf4yOh+Fah/o5xaQ4BiQqReWnKMdE4n/2nqQRDcxXxEJi155tToc0eiFD+HO1sBpC51bKaoaCMTB+T6uTTPNm5bNlxob19iDRtC5ghmlM9CuNTBuIXPMU8u9fZRWs6TO2rBVe+RFdUo6XOPaT5Nu9ZCea3cZRCpV2n1zBcvKt1z8KcmuedKb9xmutFGSg7u3mKOjcpoZYa9q7Zkicu5NFV+zXJnIFeBOST4Fh+VRl6v+dKL6/WzDZDtcrYHAWHiIWS5WuL837GPf/c9TTynFPkiagBllAiP0+bqNuwrMKyjASuXbyXXMXENMsmz4rCnn6Hknb5Nflu5H8ipFnXqRLpQ8nENxROtK+FLB5XPFWvp98/8Y99EtNBKQFbzUGx1eBmumCNwXjq0xPWv9joEREEcql9SVk26HAW4i7UqqppizxbpY72kUUQMUhY8tHDnWKnPk+lV5obMg3D533s7X9VaABrRNtb2HZy4QU3az0cwenLMGOh6s+YssH9zW1SJHJ9mfylWL3DkLWuAYzSxr46QMmg6q4ObfBKiGGLDn08Yod/ta6MshaukOzD4mkgeXv9AdqleBttNex8zJYQ8MGQ38agWycEYJj0tGNICcpxeOULEiayZhDfRLC7eaHHWRrTvZ8fwi1wg6WWciqBud2O6lKC98uv18kylW8vSrnRo7kUxSEo72hUGnhYtGRmDsWjOY0Yduf0WFIhE+bNXIZ3DIH6aebOMUG4woo8h/WPoqnISoxkYocG06D+EIdbwTyfT59ix3PKrf5l+a1eG0SDmZy0K3C05dvsUKAE
 86cj4Vgi
 7HrfYy77c7O6NrJEWhIfOdcqUPTRwiQfZzPiHF4NDqPdtpu17wO5tfxRihdIly7DiPVkDywNeyK9oIF5aywggBa1cp+Pz0ResmQJGTdH5J0HDv1VnT0KfXzEsDgZivwhiCLeX22587HCOjpzlUtT8rzBeWvy0q1V4Cx4vTtma18IOOtlFNi0ok9PDJJohe5D5JLGFN8tgmODhAAsF0vHWSSipmiUL+tfzwzmvNfTjUrT6uSK4Y3DMEXjWVsOBmYMk1287SLt6RueEWyShpE45RfyiaRdyeluWar9OrJfadaiTI1ZtJ9llsS1Df6HatonR3iUgbshyp1Tl8SGucU/dLVsFlo8zkKHf2nzYzSiPRqFVzTl81GFN4FDahXk/XAErN4sN6P1wiP1H9J0FBmYIm50AHGmrpJNwFINU5DfkhNg4MHDHWgr6fyTOaNje4l+i/omIn/wCAx4Aqa2loDkuRJroEEVDzUvgryHPK/PdXMYn+a0EXp7c3z09XdcJQzXeWO8WwxXgUuVRQn+nyA6+1NBUp9dWBAVIDOOJTm7AJFS16LMCiielADsT6H3ud2U9gQO1AA1oKruU4A2MQy20BDpjMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd currently uses the folio uptodate flag to track:

  1) whether or not a page has been cleared before initial usage
  2) whether or not the architecture hooks have been issued to put the
     page in a private state as defined by the architecture

In practice, 2) is only actually being tracked for SEV-SNP VMs, and
there do not seem to be any plans/reasons that would suggest this will
change in the future, so this additional tracking/complexity is not
really providing any general benefit to guest_memfd users. Future plans
around in-place conversion and hugepage support, where the per-folio
uptodate flag is planned to be used purely to track the initial clearing
of folios, whereas conversion operations could trigger multiple
transitions between 'prepared' and 'unprepared' and thus need separate
tracking, will make the burden of tracking this information within
guest_memfd even more complex, since preparation generally happens
during fault time, on the "read-side" of any global locks that might
protect state tracked by guest_memfd, and so may require more complex
locking schemes to allow for concurrent handling of page faults for
multiple vCPUs where the "preparedness" state tracked by guest_memfd
might need to be updated as part of handling the fault.

Instead of keeping this current/future complexity within guest_memfd for
what is essentially just SEV-SNP, just drop the tracking for 2) and have
the arch-specific preparation hooks get triggered unconditionally on
every fault so the arch-specific hooks can check the preparation state
directly and decide whether or not a folio still needs additional
preparation. In the case of SEV-SNP, the preparation state is already
checked again via the preparation hooks to avoid double-preparation, so
nothing extra needs to be done to update the handling of things there.

Reviewed-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Vishal Annapurve <vannapurve@google.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 44 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9dafa44838fe..8b1248f42aae 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -76,11 +76,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
-static inline void kvm_gmem_mark_prepared(struct folio *folio)
-{
-	folio_mark_uptodate(folio);
-}
-
 /*
  * Process @folio, which contains @gfn, so that the guest can use it.
  * The folio must be locked and the gfn must be contained in @slot.
@@ -90,13 +85,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
 static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
-	unsigned long nr_pages, i;
 	pgoff_t index;
-	int r;
-
-	nr_pages = folio_nr_pages(folio);
-	for (i = 0; i < nr_pages; i++)
-		clear_highpage(folio_page(folio, i));
 
 	/*
 	 * Preparing huge folios should always be safe, since it should
@@ -114,11 +103,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
 	index = kvm_gmem_get_index(slot, gfn);
 	index = ALIGN_DOWN(index, folio_nr_pages(folio));
-	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
-	if (!r)
-		kvm_gmem_mark_prepared(folio);
 
-	return r;
+	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
 /*
@@ -429,7 +415,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 
 	if (!folio_test_uptodate(folio)) {
 		clear_highpage(folio_page(folio, 0));
-		kvm_gmem_mark_prepared(folio);
+		folio_mark_uptodate(folio);
 	}
 
 	vmf->page = folio_file_page(folio, vmf->pgoff);
@@ -766,7 +752,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
-					bool *is_prepared, int *max_order)
+					int *max_order)
 {
 	struct file *slot_file = READ_ONCE(slot->gmem.file);
 	struct gmem_file *f = file->private_data;
@@ -796,7 +782,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	if (max_order)
 		*max_order = 0;
 
-	*is_prepared = folio_test_uptodate(folio);
 	return folio;
 }
 
@@ -806,19 +791,22 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
-	bool is_prepared = false;
 	int r = 0;
 
 	CLASS(gmem_get_file, file)(slot);
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	if (!is_prepared)
-		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		folio_mark_uptodate(folio);
+	}
+
+	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -861,7 +849,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
 		if (signal_pending(current)) {
@@ -869,19 +856,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, NULL);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
 		}
 
-		if (is_prepared) {
-			folio_unlock(folio);
-			folio_put(folio);
-			ret = -EEXIST;
-			break;
-		}
-
 		folio_unlock(folio);
 
 		ret = -EINVAL;
@@ -893,7 +873,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, opaque);
 		if (!ret)
-			kvm_gmem_mark_prepared(folio);
+			folio_mark_uptodate(folio);
 
 put_folio_and_exit:
 		folio_put(folio);
-- 
2.25.1


