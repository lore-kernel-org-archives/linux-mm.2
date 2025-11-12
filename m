Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FB3CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C668E0009; Wed, 12 Nov 2025 02:30:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26178E0002; Wed, 12 Nov 2025 02:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E154E8E0009; Wed, 12 Nov 2025 02:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0F858E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:30:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 942971A03A5
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:30:08 +0000 (UTC)
X-FDA: 84101131296.11.4FDB744
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011032.outbound.protection.outlook.com [40.93.194.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id A41EA180012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:30:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zr6SoiQN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.194.32 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762932605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NO9nHqpa4n1BllvLemZcCmcwFCUr6R8l5qDSl5DARTQ=;
	b=i+vMbF67NjM+CpbZzTq3+FYRNv19rTIoIX8g3jSgTnB2lmFObz8mQo303QAoKIoZcFtjTu
	tFXRtfULuUYgEOchaetO6D2yGAwZkLSQrjfcAJbh0zyCfFtP3jniNCt8R28wvV/4Uy7gNh
	kqaserOaFXo+Fe4SV6jlT4RCv9C5aig=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762932605; a=rsa-sha256;
	cv=pass;
	b=Vg6QJjc4gW4SXAiKpJBgeIjClPIKnZAuVW31VPc0FMg5wM+2pf4OBaWeyAXLeru8VUXOIZ
	pxzEDdXgmBMTzkYiSAX6joNoxAhRgFv8ZEy30mtxa5hf/F8Lpi+BznCaVjg6bnE4yeGBoL
	hiU0APssce3gE3X88rnybUDRDh55j7U=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zr6SoiQN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.194.32 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f7RhXUSACg7AouJqNhfvBgHekNRSIadraF1PzKG6gMe4relQLXPo9usBLlrc8VMBJ/u2l+gWwmuNsyz3a7ds3qau9ShtHwlgVJYnLI7ESSGKpmwfcr2kVJhYHjTJsnMzRPGQ46CJwFRII1E1fxLJW2EWFvEa4sXH+DiUIPfbhpU2o5xps7ZISve84XcSgRmKhvHEKw7a2lsNlKuXwWGsOGkXotPTIlU//VWck8FOKA1QkvP3Mlt4ZcPzpUvU14wVFxc+XSQn0FQZt6CDyphVeeIvC5Bx1a1l4Tnuw6I/i5uIA/fku1xbI5w99UnaUt0PuVKSTwKvjSZFFbeYnetrdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NO9nHqpa4n1BllvLemZcCmcwFCUr6R8l5qDSl5DARTQ=;
 b=A6/8Qj9ySEZgTZ55GGvDHGS5k6pid7YnhfKu6l/Qr/iZhmDQyqd/HvAw6+tRstD2qmnfc6UWrBjpsXp/NRZQzkxn73pHQT/s7pJG1KjxLmhyCiHE/GNzAjuUH3rpcehwoNtuLl8+jHz+npJGeNY9T00kfqgOeroDe/UxvNBEfwMBi5WRjeJmGlVqz5J+xyprb0ikmBZ05OOhtqFHedyQuZRNPGYU2LLpuQ9mFEvPdvQdWk8pJA8BWT5RS9EWGnfHOfpw4/69mybauv/q1wdLct3rmSkk3ML/3U675kQOHWvnAWn3nQAia1/YIWl+KBd8IRxH01cEmx9pK3oqGWoH2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO9nHqpa4n1BllvLemZcCmcwFCUr6R8l5qDSl5DARTQ=;
 b=zr6SoiQNydfD1o3qyt2DzHcGaebshDIPdZmqRJYTDjc12dwHaepc+LOZvBJhxiKj93XA5X1gMPJIyI5/XigXD3oMaqQ/wvP8ya8SXFTClZfH8YrwMJ+RhPK7IMQZpXR4mw0Be0s6TzBPh8jRJlb3OLHEtNrxpp5ktBqT4UmmRYQ=
Received: from CH2PR07CA0060.namprd07.prod.outlook.com (2603:10b6:610:5b::34)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 07:30:01 +0000
Received: from CH2PEPF0000013E.namprd02.prod.outlook.com
 (2603:10b6:610:5b:cafe::2b) by CH2PR07CA0060.outlook.office365.com
 (2603:10b6:610:5b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Wed,
 12 Nov 2025 07:30:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000013E.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 07:30:01 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 23:29:57 -0800
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuang@amd.com>,
	Honglei Huang <Honglei1.Huang@amd.com>
Subject: [PATCH 2/5] drm/amdkfd: Add SVM ranges data structures
Date: Wed, 12 Nov 2025 15:29:07 +0800
Message-ID: <20251112072910.3716944-3-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251112072910.3716944-1-honglei1.huang@amd.com>
References: <20251112072910.3716944-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013E:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b0a4c85-f299-4e3b-6c97-08de21bd4a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UifOFBa21tCLSvRaOtIa8XMqIl+PBS42stJKUlTTHHrg87RB1rY1e/iYhCQd?=
 =?us-ascii?Q?KE+q8Zo3y/+ApWySoS7eUoYQkquXm4Yg4tNL4l+8dQ/D9KdA399UFSs4CH0b?=
 =?us-ascii?Q?ANFy/ndTYK+nkPzLqvXSz4BMkJbaZeTM3EDLDcyn40E9hQmyXgaaAxOm6K0m?=
 =?us-ascii?Q?dO57dj3MW2QnuvHRm/XFyVADk0LJo6ebOJU7zvU70jBPS5vSBRWCo2KaEjcy?=
 =?us-ascii?Q?O/4MHIOtjby8/YnqlxQahRWfNPslmwB0Mg5Uvr+L71fvytKvtEGIVfu/nsWG?=
 =?us-ascii?Q?jz/PAFsPL+aw7Pi9WAPjpbsVmDU6WlXJCAZs/DGU8kV9NQ+SODFMEGgmw3+J?=
 =?us-ascii?Q?CiaZgK1WZ/MSv2P0kGUbRA38FeH44a0VxBunpcs56Ix3l4PPwOlwN3rXZveC?=
 =?us-ascii?Q?9R/vbHUtb/bHCbcr/0IKKzB/CecRahZtM1eeZSmqrA2f6YA1pl6D6au7emwo?=
 =?us-ascii?Q?f3Tl1GmT1R+97aJYRnmUegzZyin+xD+esSXtRs4p6NPnfk2mfCCSsDK3FjdT?=
 =?us-ascii?Q?SzY12loozJtfd4jDpdfFkVCtilUmjJl3dXVjYgXFjyuKtNB2nOTpCmPfvc+Y?=
 =?us-ascii?Q?v8smXVnmSEOioURLqMcgrww8RvCH0W9LDo1yz0PXWljV0DbQ3V20OMMxhVX2?=
 =?us-ascii?Q?RyRoN6M0ySMwQoIYZ508EnJa9czReYJ9xMTJsAeBPQN5utuAnHvFLB4Jo2rm?=
 =?us-ascii?Q?2RnnIFp5kUaX2jUTb1fnMm50qawYeheInKArPec3KIuvGYSIxA93IhrSMpvm?=
 =?us-ascii?Q?Pvysa9OJTaFmwG3qVGBMHh3Wu2T8QFijSjVKW67btxaPbqu8I1M2Q8Ia8rpF?=
 =?us-ascii?Q?/uLyUoHY/iOYX8r74OJ71l8dEOxBW0bNv1V+zA+B9MYD/tFVYJeK5F+gWUeO?=
 =?us-ascii?Q?yrct4TrPckOk45vK6VXar0ynAxhQKjjEkjTc15l4oPUetESl2yr28Mebiwkq?=
 =?us-ascii?Q?fiueXBE78JZ++vIZnJlR6YqLOI0MjhpHnxpShX/0MZDFrkH1Z6m9GuvGBnIW?=
 =?us-ascii?Q?AtRi4wdOuhAj5ycBAqF1V9aiAvofiLa2ZH7N7Oz60dOOYqEV09jtUt7AWAn/?=
 =?us-ascii?Q?kBAUZa8wJKoowQYynOIXjuqIL7vxROCt+cWPsqqyt7oVkksZPRX8bD/u/efJ?=
 =?us-ascii?Q?ZehCiweWhARk9Jp6rtVLPRLCUbBtvFcktLnDl3qHdXh7ktoFEu74eRMQxy0z?=
 =?us-ascii?Q?xEe7vZD5bak8gaMkH+pUm6EkLHa55Bn3oFA++rw7fR7z0mF9rxOWJcK6DCCD?=
 =?us-ascii?Q?Pmh4JMTI29LLrz98l+6ler93HGm3UHCXnxzzPV51XVxVz8c4QStRr7lM0T93?=
 =?us-ascii?Q?PkExCAUlzIlGcS1LIGDjg0yilZcvAN3IuJK4wcPejHJBbFOh6Y0B2WTVBHR5?=
 =?us-ascii?Q?wKiTLN4wtYooGrALZATwIJLM+WA0jQyu0C4qfxJVnDprKovr4585NrickhYh?=
 =?us-ascii?Q?QAk+fBMmFQJKn2y7NAOCb0+bu6UDbDLpBSh1MAxWXsXuBXcv4QU6mk2YwMSw?=
 =?us-ascii?Q?R/RRotL+1xSzd7bKvHO2iNVokT/iRlyIWfUUzDllKMEjR8f7+bsy0crkyqGS?=
 =?us-ascii?Q?3J9XF4n0S5hnOxJt47M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 07:30:01.4266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0a4c85-f299-4e3b-6c97-08de21bd4a73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A41EA180012
X-Stat-Signature: fe6zzsak6fwxtbhq7fzd6roztz6pg7nh
X-Rspam-User: 
X-HE-Tag: 1762932605-480565
X-HE-Meta: U2FsdGVkX1/le/fi0VPlcGV+guQR2aOxgj17VY9/tEMWUXxYR8Rz+weZUb9UYusFrnPI416sewIVtGaGBEECV8BBBh4ZgCheJ8oFQY7FIHnMXMIu2JGVYhvxq+iKdq8VqoFi6bjyTt32JedcDokl7PRXAV+oQblhDanvUrkHnsa3kphrSA2B6c2XO8zQWU5MCSLuc3rSmzllUp06dyuvDaZQjnBKuq19ma2/cNSdI+hrbdoQkbq+2bKSLI71YBsGp4gq2NGI9jkoQuS1cv1Ob9q8MMMKrZkATRG0HIXEwz2ktSIn/+kALOnAFB98dz+4p6mQVAFWcfXqBCH3kaVuILiNeF7nsc/GzPZouS/H6PCMVWkvx11o4TfHucnyDrewXKZ3/dnL5N6vJKd5OzvK8Xb/s0/2QkGhdXwFCfVylt2pgw3hGelNv8WPRXz/63rC5a9+UzhU4jAP9z9Oo/+G5HvmRkfQxOfX9crfyN9nKn7Gf0W371DNQChuyKOsYnYdAeqsunX2NUw9n7VbsdI4LzqxFhNnAMIk/UNgrlDFjPVJI/k6qJXvaf+0kWfFcDW1OfToy4p4iLvtwwlXfC0FHl7W14ZlT3wD5CkQK2p8fysYB8j3/9WJ3yaFPuO/l4V22LkbzZwQ7EoRS7buR8u//rM6bOFH1OqefeV47y6VzyG+pNh4HO9Rq72nN+jPkL/BQ1+Wns+88+z+FVBGjJ1AVYNq7lRFQX26DCNfxdpZ6Sz04d13dFoG49mwdQqbQs+faU2vhF+cYJgY3qJ/1W/NFLMG9jFrZ0d94IC19H75G/Rwjqjn1+b6cNjAFNx0z7Z/YYMkgGGriUktu0++oRMuIYOvHG6L4VH5bVsEzBe7WmYDYzPyeyh6y8RAtQ/Ph/lyUnCDMBPLQJmRdP/qqOc0rXO1dIIDSy/KmM7jC3v5XBMubIa/I0ChAQMoJKXU/HPBGAH1faGglpNEhhJUin7
 MWof4xOB
 3/fqqvG2xV/mAipam7lkpulFqFC0y08MRXgkUQsC0hueOImqLIz1ysjc6BzL1fdpRpzBDXktOcyfy4TH5PBIN4+5JG2D0+AHGYZBzYBVnY2/2al7OuoXW4DVrSpUENXZdLXpiJYjDCIfswsE6j13yeskHkHm93p8G9iKHu95aCkOlxTmh8xHInmzjtYvDkAUFcmB/NnNt8fP9Itsv40qcHnuQBqJA5AmHBCCkvtH5h0Ww2PjBzkoRJ4hEVEEGyVXC4rNlh4/LN2BqGTc4dBDT7BHLzmFbTgIAasymstW6zSSGfZ2nv6MIvf1fVjXKA9Vsy4YGlo65sLBdRA5xcdfmqSYyWgX32CqYKKgFtcayeVX9xDdOZro51t1SJk29ikBWSlmpm7XzvAq/0HVSfdvkjuvWiAoZkMr+r7mJKafQJX7OiHbiIS8+pxO+TS/b9g3s//BsjzbkYoHlj2g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <Honglei1.Huang@amd.com>

Add new UAPI data structures to support batch SVM range registration:

- struct kfd_ioctl_svm_range: Describes a single SVM range with its
  virtual address and size.

- struct kfd_ioctl_svm_ranges_args: Arguments for batch registration
  of multiple non-contiguous SVM ranges. This structure allows
  registering multiple ranges with the same set of attributes in a
  single ioctl call, improving efficiency over multiple individual
  ioctl calls.

The new structures enable userspace to efficiently register scattered
memory buffers (e.g., multiple malloc allocations) to GPU address
space without requiring them to be physically or virtually contiguous.

Signed-off-by: Honglei Huang <Honglei1.Huang@amd.com>
---
 include/uapi/linux/kfd_ioctl.h | 42 ++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index 320a4a0e10bc..d782bda1d2ca 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -777,6 +777,48 @@ struct kfd_ioctl_svm_args {
 	struct kfd_ioctl_svm_attribute attrs[];
 };
 
+/**
+ * kfd_ioctl_svm_range - SVM range descriptor
+ *
+ * @addr: starting virtual address of the SVM range
+ * @size: size of the SVM range in bytes
+ * @pad: padding for alignment
+ *
+ */
+struct kfd_ioctl_svm_range {
+	__u64 addr;
+	__u64 size;
+};
+
+/**
+ * kfd_ioctl_svm_ranges_args - Arguments for SVM register ranges ioctl
+ *
+ * @nranges: number of ranges in the @ranges array
+ * @op: operation to perform (see enum @kfd_ioctl_svm_op)
+ * @nattr: number of attributes in the @attrs array
+ * @ranges: variable length array of ranges
+ * @attrs: variable length array of attributes
+ *
+ * This ioctl allows registering multiple SVM ranges with the same
+ * set of attributes. This is more efficient than calling the SVM
+ * ioctl multiple times for each range.
+ *
+ * The semantics of the operations and attributes are the same as
+ * for kfd_ioctl_svm_args.
+ */
+struct kfd_ioctl_svm_ranges_args {
+	__u64 start_addr;
+	__u64 size;
+	__u32 op;
+	__u32 nattr;
+	/* Variable length array of attributes */
+	__u64 attrs_ptr;
+	__u32 nranges;
+	__u32 pad;
+	/* Variable length array of ranges */
+	__u64 ranges_ptr;
+};
+
 /**
  * kfd_ioctl_set_xnack_mode_args - Arguments for set_xnack_mode
  *
-- 
2.34.1


