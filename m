Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C260EB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34376B0096; Fri,  6 Feb 2026 01:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C6F6B0098; Fri,  6 Feb 2026 01:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B586B0099; Fri,  6 Feb 2026 01:26:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B07FB6B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:26:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74755C281F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:31 +0000 (UTC)
X-FDA: 84413047782.07.A987685
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6C39B140006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="aj/C8Wb0";
	spf=pass (imf23.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.201.45 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770359188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMbvLyaAvNXsFoSV0KbS9N3tGeqxMjOmorgMDw9FoPY=;
	b=r+OlYgwrs32jpvw5xjdd5jTr0gmuMu4ObadjM2CuPb06ulq1lGf9zQOLil4Qn6ZP0a8UOL
	q+3LjrBDw/MtWP848HDUApDiBjy+WKRPOmRkVVKIMBuapPFs+MjffAx3OnwGhc24L227bv
	MDb7seDkIfAvUBePWJOVzUZ4n1jKa8A=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="aj/C8Wb0";
	spf=pass (imf23.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.201.45 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770359188; a=rsa-sha256;
	cv=pass;
	b=l9Mi8oJfo3D2m1LAk2O/Srq6Ihfj+ddOiEuU02GlfxWbXh3OURGRWSkkfa2iXxrUFwwbAX
	YdaZvZW5QoRtbICbjqCNjcT9MvscBlLNodrScx8UqDukusoK+NpeXtmO1Awv7uaFQ+P0Ul
	Cbl374xKAeiktFg/nz+do1WjzSQJxG4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDOC2vsLmDBsxT7B0BNW9uCBjCl70ihNzMXPzuBid0+i5BKCFMyICI8/kGM6NxFIiRyi4KnTwZmzIn2pKXmIqdx7du/mF5a5F/FihF6N223TrbYQ6DCrniTZPK7K5CaK3xHRyKDCOTGr6DZ8a7kFjkrK9tZCLia59SZmyhRsV2+O2ua60pt7yr4s792KxOhHdSnlchTNgJgFl+nwUSTdRTwEwJWGMJMclhiC2Ay2LXRJSg01r+TGfV7EBfGc6nuGpvVdZZAPRy+sePBJEZUkDAdNminGezd9lVzPTHH6wqH+4NEqgr6wgHs+VcXLzDXRIBiR+bH1+UC4FcDRpUMQWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMbvLyaAvNXsFoSV0KbS9N3tGeqxMjOmorgMDw9FoPY=;
 b=F8gMEihpPcOsLES+ozyeyv7xVerSQT/JCvbdcJISZFErHnd9+oz7E1l36Au0CXyNeUDBwv5eiZ3HDZDtS1P9VVmbuCY0EBIlVPCUB6De0v1YhfEZPS4D7kEF1xBuZOGDj25u7V/eJ9oIfxY7uQuDZtJ9wS8jweUmGtGIyd0wRRd/y1H2CC1dI7HQ/WionRrvqn0YxxESWWbfKtEBrSYrffV3qTPfVmSfcKng0aZNdYbWb8e1Mti/VQn22CjYfNlJvDGVAOQt7Ex9AK7+1QWdtwvF/eIW6DJx5Q277vC6ELiMZWpuGNDYHfjQujVaU4PxKfUjnaOs1p/9UMhBtvrh3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMbvLyaAvNXsFoSV0KbS9N3tGeqxMjOmorgMDw9FoPY=;
 b=aj/C8Wb0uo6CLzsKj5B92Zo15siL+eKQoB/dNwDdXoSUlHrvw5oMmFFRLfg/PUiIHuuEWGv8jn/fVW+ppAe3C9OrJRiFD0iyIw2ZjPBjqngkTdc6IbYN/AOsrIf0/s1VI5+KLy6+7v34dd3VBEFb2G9Gm7upyVgiDgi5hJkOCsU=
Received: from MN2PR19CA0017.namprd19.prod.outlook.com (2603:10b6:208:178::30)
 by PH7PR12MB7331.namprd12.prod.outlook.com (2603:10b6:510:20e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Fri, 6 Feb
 2026 06:26:24 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:208:178:cafe::13) by MN2PR19CA0017.outlook.office365.com
 (2603:10b6:208:178::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 06:26:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 06:26:23 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 00:26:19 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v3 1/8] drm/amdkfd: Add userptr batch allocation UAPI structures
Date: Fri, 6 Feb 2026 14:25:50 +0800
Message-ID: <20260206062557.3718801-2-honglei1.huang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|PH7PR12MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: 40bac1fc-05cb-4284-9b8f-08de6548a645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eEsZhCWrbj3cpHqRHpBd8dlmpw2kXA0mapk0SnsJIpakx84Og6Zx0VUPSKqf?=
 =?us-ascii?Q?f6Pf1QK9LSbuhRdeHAOLOQ6GlLiPYx7NGbuSyhD8L89XXmYCPgBmWVQ7prP3?=
 =?us-ascii?Q?RzCONzNafVxsjL7+xNJEWhXkUi/wBrsIitJJ8PoHlxSI4hRW6U9C7AJfF2kd?=
 =?us-ascii?Q?PFlc6vq+Bb+WnqsByP3DLuBQmi8XAXi32uIKHLDtgbG1K10iaD2tosTdzox5?=
 =?us-ascii?Q?oZLnAuJOESBpM8Mf1QZN07NCHxNZ1N/v/fKQOn1aiJz1C13Lv4VRBio4ZYOZ?=
 =?us-ascii?Q?UfC3gAM/tFcewEWiMa5xUnrHS1cwv3V+RiSiz3V6hPqqFo9NnGBNaA621npM?=
 =?us-ascii?Q?6VvpBNdTTHLsNCP+/+0M1EqewLPRZk8he2sneHm9lY8JSQamGJ6QlgwBjrAz?=
 =?us-ascii?Q?TyaQjQXIpSXDEvhJhsSl5sUkAcqwpzJN3ffkj0kmeu13n/yNBrrv947Pr3Sj?=
 =?us-ascii?Q?rIha/mWQ9HyTAmtMo+7VR3HiRchQUnMJvdG6DLEpIhC2OlgyVc3OPSHzYxvn?=
 =?us-ascii?Q?YQcxSfM3uUdXmd9OAqI5FwJlHxLT7LyD1mUVptdTXLHWUwm/q8MruKSZ1tDU?=
 =?us-ascii?Q?6HfO4mr0ujebm6Ytb0lD9DPvM0oPmAZSmMPBQgL7H95NWNRVQN0kO3wVoUOj?=
 =?us-ascii?Q?SFdWAI5dOKN+QHnwKLeyhR1oDf45ACmyQ72pr6t6lhsZJ9HxHhiINZqvfYN7?=
 =?us-ascii?Q?wd/0yQ4YYbh2zbT+aJcxW+aJPaM234FDMCEUanXYdUBIewZoO3WFmUh4efCn?=
 =?us-ascii?Q?fqh48kFiDjR9/NjcOcbaFG3ikclELlvRV2D/IIXKXXuZQJeDeF1mlq6Mhhn0?=
 =?us-ascii?Q?CnBXb1r2ccfekRYoHTEvo4bqlHlWCOkpfHYtamTrOBj0Pt78w5AxsPKIH8g4?=
 =?us-ascii?Q?WZ778K3CCP6LwNA3ryHPSH7mvRjrbweU2oA948D5OA7odfAw6ClnsKShuS3Q?=
 =?us-ascii?Q?5dJNymjNn4u60ZQzoZrk9t/eYYR0s1G/78kSFGXW/LeAANPbe0C4zh5RGsYV?=
 =?us-ascii?Q?ME4so9OWgdpeHQEkx4khfdabZTWcvGpwVwnRerm08kOqdpbdSc8cCIjSuXi5?=
 =?us-ascii?Q?LHUdgF9o3GfNbS63yNL2Z8Zh9gi5hLuYWmXWz8cIVSvTv6w6V+80tBrbqMmI?=
 =?us-ascii?Q?v3gXVQDkrmSdqyNG4RhztNcyl+4O/zP8bq3ZLcu2/Nyjw0mQYZyXAlZA4k4g?=
 =?us-ascii?Q?QvruxN0r/3N7pEP1plGCus+emCRsNCso5sh9/HFdxG/GLOVg38PAsX+dA7Lg?=
 =?us-ascii?Q?EI/WjNfRH+2Paoet9GrnJccLXeiDBDrROZoPEHz80tTbpL5r43Zh2oQP3pCQ?=
 =?us-ascii?Q?6Xa21kCjAFxl1i3gZyAJyCyjefplfzEVvwyrhtYQL+PXxbMLwdc76TJLzFQd?=
 =?us-ascii?Q?5iovCImZroPivDhDkke7Q23T3anf67BjUnLXuxmHki/NU6EJGexz0UItgiQ5?=
 =?us-ascii?Q?qJjfaDdE0MD+vcTwjAStmULIl5xCYpKAOFcYQ2yMXMgx4JsHkFTbgUQH8Sqk?=
 =?us-ascii?Q?jB2mO1DSjr4v0Ingt600IP0gl+tzkFWjv6fsX/ByTz19sBeGzoZwoPecpl7g?=
 =?us-ascii?Q?8GXfv0EHLqFoufCE1iwac1wNLzvd5lnhPq/tsxGusQHsBhg407j3LmM7xnN/?=
 =?us-ascii?Q?VM3HlxBY20GdpSHmubklckHoQfmpJ1/L+bt+fWWTUG3e5E4ZN66uIWyA0kIk?=
 =?us-ascii?Q?s5pOsw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cF6WSFBq0CsnqAOEIz6544l2KRQYcbJ5azGt0XKaiWjz9twxvknuscRRtG/zZ3qDX6nlgK/aBiJCVIdO/TgksbRR/RGZrnO5VaYQ19Bqe15PxXJX3II2Vo0deoWvt6d9purHG4TDCFX0SIBf9SMZ5JkzxEoTqSqCe5N0Bh/N6jL1+Ugv2OjjAqydMmSyAmdE4XuLQnrTre6vvnIt0nwAvPRWxXdo88luyqYB88cOSCYrA3AtpiE6Y2eohWvyyYk5LxyBz1IYpgg0XUiUnMWFccsCq6lJWqr2n6IHIn/EJzT1Mle1ChR9NfV94ALB39FQgp0JWIJTJ13IpFCKkkSND8+2QD/h8ehAeuv7eqszO/LVvWBU/UD3kbDxQJWhR1m8KvVOC08bNw45yAwDLDyeOLRub3lIQ/c3WXHML0wyT0XiCYFXiZziSYZZu6cLfzEU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 06:26:23.4375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bac1fc-05cb-4284-9b8f-08de6548a645
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7331
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C39B140006
X-Rspamd-Server: rspam07
X-Stat-Signature: fgm3kdt739s9htawq36fwe6pfpedxhex
X-HE-Tag: 1770359188-22883
X-HE-Meta: U2FsdGVkX183cD9WsTNzW1TwBbpTau3vS5ATK05TqZtjRgHEqxmSDwYO90d9q9OSTt+D641uLNXdPXo0nH9ajQCu5TDgEU+ABuoKgJNBZupCFLZHsZ/jCO9bWtB4/A4OYsif/X1xuERaxpqNFeEpwdk6G78nzF2A9SkQPY2c44vSfHzKK9VmLBUGr95ZKY/eA92hex6iLMESNhf4p7F+kvjfoI9aM5DSrLHzWYC/XhoXcK3NJNu2KWMFEwIYNVzi/3I7Dh/s5ngmsbXDa8lFYPn8VUj/sFOQrVD7TtWh2hkcBPZAWzl4T4hBwSJ/MdHXxIA6YyeW4oF370p+1eiUh51M7u3f0oXFVS+/JkDc6Uetkm6u8BXS2lbrfOusmrXY+AHV6BaAjfbHMiAJ0QUtqHXkgdKCp5oS+/mMIV2afguJuu6uqaIPNYlCB2cs0Q7cmKnjyjEXA6cJfF3YlOhB8yAj9d9HEIyUijF3sQqcySQf7UZG94LoXIF7kSH2NhPEQ7Tu3ggHQmiZcXV5I5b1Hbchb5haWfZ/t7x5GDU0CZfeiNgPl3g5L2TUTx8N5cWRbp/8EQsVsha/DQCcpprEuOBXQjp2fWyDs28z5Ff+hWI39pNn1NaqAwLTZJ0vXxHSl1o19lNukkbR5zLW6fJa0FnlmNG0rs6pzVFmhl72zociKnStXI8hDqPZQkktZo/U+PnsjYJdAQ1MkIj3GXZNThhLJeS17eXUTDs/A9Wju51x8q4tmx2BQBh+1Qy6zUOupH1Q4jxOqzmF+0ZXwZPQvqiUYFlbF3MgFRJkqXNU7n0xUCGmG2dm7FqopgLrqJz/X5BZihQQOSRK2TjuaWKP9NgSL2DEHQ+4f5yJfD+S3EomZ9KPssKQIq8tZvrs0rpStwa87ugQueSWF3OfNWOjT5q+evsqChgOXqfi3MYkPvOliIfen8XXZuSK1ZwLiTr1NVLfhhPiqkvQ7Aam079
 R8abTyhS
 5U6dAB/av/t+JLacmWWw3Il/W4xRuKBegKMbVjk9cbp0rp+oZmjrSApNZnjQXkq5/w4rNFUKd+DS8Rh80BErP6QCjzUbIpVKjRKm/KTgOs6fpl7OV2RjTyk0aI9cACZg1/YX/0ymKVZ5NR8iItUvo2gwoBuw/88UBGZUW+bXMPpmxd09KOrlvnq6Kh9z74vcqopCt8Bt3szRRKCwd56k/r3X356QRbrAbBV3t2EgL23k/6b7DNUKJhP6a+YUL46FcxR5grHByc4UZ76EEYs3W8GZ51CF40uolwZinagdubNH5i9Vqv5nXtbM1PFspuaFB9xwr5htcAlHnV9zhIPBN/v/TKmwDriKJUBX5p10EW8SVbyg9muVOIH+yrEJDDfIF+eraklRSCDwDduVkpWaMmo1VGDALfIpSzvJgLZPQIabW3k43Aqq4HhHFTaI482/thusO6PWYqEG/Pcw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Introduce new UAPI structures to support batch allocation of
non-contiguous userptr ranges in a single ioctl call.

add:
- KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH flag
- struct kfd_ioctl_userptr_range for individual ranges
- struct kfd_ioctl_userptr_ranges_data for batch data

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 include/uapi/linux/kfd_ioctl.h | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index 84aa24c02..579850e70 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -420,16 +420,45 @@ struct kfd_ioctl_acquire_vm_args {
 #define KFD_IOC_ALLOC_MEM_FLAGS_UNCACHED	(1 << 25)
 #define KFD_IOC_ALLOC_MEM_FLAGS_EXT_COHERENT	(1 << 24)
 #define KFD_IOC_ALLOC_MEM_FLAGS_CONTIGUOUS	(1 << 23)
+#define KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH	(1 << 22)
+
+/* Userptr range for batch allocation
+ *
+ * @start: start address of user virtual memory range
+ * @size:  size of this user virtual memory range in bytes
+ */
+struct kfd_ioctl_userptr_range {
+	__u64 start;		/* to KFD */
+	__u64 size;		/* to KFD */
+};
+
+/* Complete userptr batch allocation data structure
+ *
+ * This structure combines the header and ranges array for convenience.
+ * User space can allocate memory for this structure with the desired
+ * number of ranges and pass a pointer to it via mmap_offset field.
+ *
+ * @num_ranges: number of ranges in the ranges array
+ * @reserved:   reserved for future use, must be 0
+ * @ranges:     flexible array of userptr ranges
+ */
+struct kfd_ioctl_userptr_ranges_data {
+	__u32 num_ranges;	/* to KFD */
+	__u32 reserved;		/* to KFD, must be 0 */
+	struct kfd_ioctl_userptr_range ranges[];	/* to KFD */
+};
 
 /* Allocate memory for later SVM (shared virtual memory) mapping.
  *
  * @va_addr:     virtual address of the memory to be allocated
  *               all later mappings on all GPUs will use this address
- * @size:        size in bytes
+ * @size:        size in bytes (total size for batch allocation)
  * @handle:      buffer handle returned to user mode, used to refer to
  *               this allocation for mapping, unmapping and freeing
  * @mmap_offset: for CPU-mapping the allocation by mmapping a render node
  *               for userptrs this is overloaded to specify the CPU address
+ *               for batch userptr (KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH),
+ *               this should point to a kfd_ioctl_userptr_ranges_data structure
  * @gpu_id:      device identifier
  * @flags:       memory type and attributes. See KFD_IOC_ALLOC_MEM_FLAGS above
  */
-- 
2.34.1


