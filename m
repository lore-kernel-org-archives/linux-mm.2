Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B5CCCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB038E006F; Fri, 24 Oct 2025 05:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB638E0042; Fri, 24 Oct 2025 05:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572C18E006F; Fri, 24 Oct 2025 05:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 422DE8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:44:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C89D28937D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:44:58 +0000 (UTC)
X-FDA: 84032523876.08.B598EBD
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011036.outbound.protection.outlook.com [52.101.62.36])
	by imf21.hostedemail.com (Postfix) with ESMTP id CFD481C0007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:44:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YqvelhV8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of skolothumtho@nvidia.com designates 52.101.62.36 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761299096; a=rsa-sha256;
	cv=pass;
	b=Ai5M4zVOs4eGz1saNLr3Wd2fjub1SPjc8bc6rhr2WokVaaCt4PfhV53fAH7OOQqwPOcZW0
	qgCqa3bcsC3ek/tcxYXWzVe8cP6BT1B8vnTSSyb00b3VzCLxkT0+N9HVoExqVHf6/wYahv
	loKk23UMfPfS3DHTME56qGk5C9pWqQo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YqvelhV8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of skolothumtho@nvidia.com designates 52.101.62.36 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761299096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rA0wJ4kXict9x77V/zSDSfaP7Xdt2ODGuQteAEucV2M=;
	b=hcgS7GbhPFJGI6O8okogwpIpY/o3w6U6dO544u9j2CmjxcBeiCiqrnS74IwCxrnZUmt430
	KzFcozDik2W7fMIDI3e+w5BDTHNOQPCnOy2JbhhXjzolCOhllDyg5Kk8s1yHlOpyz/P353
	4TxipcoTDckN9aPFIhfUPWY5kJy6GKk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YOVP1FZ2VxmsNKxZRJtVfyqD4SlgDtI4fCRLut/Ac0W6goW9cTFzES/stowgMo6hDD1ZlidaTJo5Egn3SUlRJ0uQqGiIwpsy4hL0Wlk7nVs1ZuwxSN51kAURuF8mk7Lox6zamPbDvG+Lq7HG8jz5VtNbaYmzlmgRR4goUHOfMSBvO+NXuEkkhMPvEDxRAzIYTKgTdFUdUtKa57nscnGR1zXpxXxAB2BhfGdNw3dUG+UiRuJOune9W3WpFn7r+17cprodYswLST33sxeZ7RPWrDrBRrCets5WlNs+rRPJbGa0pvrk/9sOsa7iUaACz0KgfW7j21Y3UKno4zmK1EGQIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rA0wJ4kXict9x77V/zSDSfaP7Xdt2ODGuQteAEucV2M=;
 b=GjD0uq5aTZcWlrK4bgS2ghw169Ob+QJx+m0nHynXcftKmj96yGi24OjP3u5xnEYHj95ZC03H7QWGuK+97+Q6ggPvg8WQJarRigBTKHvEHchbl56reN/25ntQP8+CaeahPY3UYwXRN5CEWpiUJ3kHgQ/60SsDI/XW9CFMnRPkGydtMfpdcw1dpC/oZoVunRtlwC0yj8mhNunv66ICEH2wIaRpxK92DuuVYRrcjdxbplf9Izjp63M446lrORIfMlYBfhTHZyc8T8P9z3E7MU95yGKLPzpvR9ROlCTeTCcDskRzXIgZTjAYivUuL3n1byMjSJu7DKefvZ2b0qR060HdSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rA0wJ4kXict9x77V/zSDSfaP7Xdt2ODGuQteAEucV2M=;
 b=YqvelhV8ksgSkxCjHh8Ij8/1V0rCTC6Wd4bKcz1ZkVRoUE8IAKggoyAxiciV8G7iJJ4NcBPpPZ4pA3r7YqdOYTAsEj7YbIBq1bgxxRNEY1bVNLpRcj+A7t+AC/7ptmM0R1Z+ysA3gjO8VZP4XzSiMbVyaNqP1orvjohixZPZw1WyqP40I+5Wn1kV1CLp0ScHiv8fbuc0yd6cj8bfHkjvm37I4nCndTYcnqcEeojFdZuX6l8quCTpTOaGU1rH108mX05h9X1lS9ChgMPmyYu+Y5KUu+n/JaOs5DIDx580NPCn/N1WBH52+1mZ8GBv0FOHaA+VHhuPf9C2i1c3X9LWfg==
Received: from BL1PR13CA0248.namprd13.prod.outlook.com (2603:10b6:208:2ba::13)
 by PH7PR12MB6788.namprd12.prod.outlook.com (2603:10b6:510:1ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Fri, 24 Oct
 2025 09:44:50 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:208:2ba:cafe::b1) by BL1PR13CA0248.outlook.office365.com
 (2603:10b6:208:2ba::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Fri,
 24 Oct 2025 09:44:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Fri, 24 Oct 2025 09:44:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Fri, 24 Oct
 2025 02:44:31 -0700
Received: from NV-2Y5XW94.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 24 Oct
 2025 02:44:28 -0700
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <vivek.kasireddy@intel.com>,
	<joshua.hahnjy@gmail.com>, <jgg@nvidia.com>, <nicolinc@nvidia.com>,
	<nathanc@nvidia.com>, <mochs@nvidia.com>
Subject: [PATCH v2] mm/hugetlb: Fix incorrect error return from hugetlb_reserve_pages()
Date: Fri, 24 Oct 2025 10:42:40 +0100
Message-ID: <20251024094240.337630-1-skolothumtho@nvidia.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|PH7PR12MB6788:EE_
X-MS-Office365-Filtering-Correlation-Id: b16330fb-16a4-48a5-4bba-08de12e1f9b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8IN1yS3TUTYbHxEIwZuv2kMDQg1h/f+PZ2PxQMcYn8Ia5vtw3SgAvZhdPn5f?=
 =?us-ascii?Q?Q+DdFh/esv8MXlGMIJ4MRyGTPt7Tds6kFI3jILjDXhaDurbKzM25E3qrsiLD?=
 =?us-ascii?Q?s3ghJmnNdrx07jPxzU0BI7v4I1Kk4GL+mn7GYrRD7bPKhpjGnLd840Ax0tvS?=
 =?us-ascii?Q?NiJMyt89rQjQTkPE/xpWrPcK7N0NPipaQ/uH0901fpvBAKDGva6rsfn/T3IN?=
 =?us-ascii?Q?oMS+vLfv4nvwuUOG4teM2a1mH8/k8ehs1HLGFqVRYFbBM9x6LbdiHE8LM5pH?=
 =?us-ascii?Q?h3mfjNQgNSMx4qStlBSciitob+u1knUMq1p+zG1pR30Qy3qPlRxKCS6eudmW?=
 =?us-ascii?Q?ReccAHQ67ZdZQKnEF1+HyWml1bZX6NCIBsXt67lEZJfdkOz0y5MrB3qLaTxw?=
 =?us-ascii?Q?UUz6nAJIPE7W+IMIqCbMZHRcmrn6+znzcKeYe/WOOqSbZlrVS+IFBkGeV7X1?=
 =?us-ascii?Q?oSp1qk1PzdkuiXoiv+o+nQmwnu9TQrJdyC4vmeHaJBsg182jewctdfmNMxRT?=
 =?us-ascii?Q?9lXp3JBaHUVQ1rCuNaeRPGCTbI8qJfEYz3Du7k42xh93H2fW5GZSLVod6vzg?=
 =?us-ascii?Q?bgyjLYpFIlPMXGCtqXNK4IiLp8heX0VNIyLnc78/xrVbJqTx6T/n1vDhRzRG?=
 =?us-ascii?Q?RioRGaOkU2d/I2EZSh6BxpEZklufUS97bTLfStE4Qdu5tm5pcPik2OvkVdue?=
 =?us-ascii?Q?XCZYiLbSeZ/+wWftI9e2k0mCwUh6/Smz9nTOKE99zQGblRFM40WZcPPUmNu7?=
 =?us-ascii?Q?qxKqMoTj5qZcY4HHPbE62+5X6gU9hzfcVRJltkrNjsIAmixkl6qaTHAoYytY?=
 =?us-ascii?Q?dFyjpuuWKHjQhFRQ3fECIe6iIXQckO6c+v0UxVWzd74ch8gQvprFKpUrQAdn?=
 =?us-ascii?Q?EEDC68WxW9Vzjr/ubEwG0SIAfqrBwrT+9JymxdzTjE6FhS+bbGEthbh+u8yC?=
 =?us-ascii?Q?LOn5bsK3+yA24acThIaD7Dl/CRfvge24WJ7yoPt28qiBZGnSCjYXuvIrzRb+?=
 =?us-ascii?Q?5xjA+RX04TSZynmRU2t7Oqp3OgVWmftb3Gev+pYzIzUoo8WUSp2SjeAgma03?=
 =?us-ascii?Q?i2WZg9rt31gc24qSnExQSSTy0j3MTGCaqxZyy5HYpWAx3nwGhv6RnEi3bYf8?=
 =?us-ascii?Q?+Z+ojfyuojVC6rOWdyI74Tamoc1QjO5KbNU8pJ22zAlxDKTdLPiFpB31mKnx?=
 =?us-ascii?Q?YAaUsLwFTGbDgEXtM8iHlf6QczY36higCvzDe1scy3DLX/JWkBpWOHUeQ5q2?=
 =?us-ascii?Q?uJBLMvPYeVSI2kfYHs7oqDwlck80P+tpIKVWnuEAdDjb2xeoLyvG0EfESl3o?=
 =?us-ascii?Q?5N7AZAifwUxBkLjrZvj/tZa2M8HUxwRQT7UOAZLea3vUgbMByMDLaNucKB3f?=
 =?us-ascii?Q?tcnXNyjwEY+65hoepTlF0yecClMim2rBrqBdjJ+Hm4GhRpIAV5UBVMHLDE6d?=
 =?us-ascii?Q?fmuwHzNgKYqE+8TYKheRq42qD0OPEC9Kgj5lASp5kK18qVymbHqlFrfRB+rD?=
 =?us-ascii?Q?mt69PAt8Hh/G+lTO+/SjkwOABSP7hMbZnElCjyLg7YcY8T60MfedlCJCqo5F?=
 =?us-ascii?Q?NcJVS08f94kKRuzzzRBGLVVbFunq+WQVt2yS+hBS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 09:44:49.7344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b16330fb-16a4-48a5-4bba-08de12e1f9b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6788
X-Rspam-User: 
X-Stat-Signature: 7her7n4shys44podgwu8n6ckhfsf68ym
X-Rspamd-Queue-Id: CFD481C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761299095-84960
X-HE-Meta: U2FsdGVkX19rZgo04iNVz2Fjy/ZIOjgO2uoFWi1JNgDkrxe++i3uPwh4z6FOtrmIoI//fTuiQujy/zr2aWGUQbBOQlcc8KhzXtqSoSrt42Vn7M3p4GtZfutNUfwlVCE0XHDufYbJ2SP83cYVDqYOD5/Wj9xA6Zb7ognhgPBfUZpaHlcBEksGX6FeFekYyzNhVUPLy1RXYp3qDxxQ+VV9NUMqCOe5q1slC+wARt0Dpq6DTfEKgoLYVJNLUqxTuNCzrWWzCfB/+MQ8wEjg002+kIkalQOyZ13UBva5tHGxcUsOmnsMnlPq/PW8JUocJbjhhJQbNpsHk7dqj8zU+TYo2Kl5bV5HxO+RdoHr+q747D73Ww/vxSSt9SeIrDOt0CQTvdAsMFWWgMFV5fsb01R9gTQyHGit9fol5kWz4HNv7TWL5r0Gvsn1Y7WveA7QN9eK3DjjHFHGuxR4/gEx5/1BxcHLpfLCUoax+pSgS2jaqbTp9uoJwnNmhAKBbGS31MIHrL5Ip/aDQ3at1jsd2V9N1lmO9BPU1rmZehGvLKmw9fQC+RLaZ8rbxQ0ppZtFap9JM85IZfWWSGDzUeN2U+T5uKth/ovnB0tK2UC+jxHPuJxGSJ7UFfYy/c49TuBwoRl/Nl91/apHHbzjVv1q4VU4h67NzWUJ+R4KHPkc49zykOgEYfE6VKtI8HdtSre9t9RUreUmbyd19q/DHL/MX9/AUxOXvi1f4mIUo+Fs53XDD1B0zwGPaYAfxtlbrWczHaWOfoKU4idTcuNHcjO9glOOjNNAWgHK2/vchC2b5tNSKDx6Oei1XggbFc/XQ4Oiu3de2/JVK98MrOBySGLqasjD6afURy/TYLCJR4+Hgsj5UVyMbCZ6tUCjbBr0KxzKFCJrw43uCr0uSFy8kXdscjF7yDvA6XdQ4yNIvieLLuznY9ojJDrznTEPd3JI653RInfrokyEskvN+mLiTkZ/KSe
 5IBDXOSl
 hwzy5KrW6e6svGv/oBWjrsa4iYKlzloPwecU6Vh4vNXIDahLDLDXmJVoedmVV0A5k+awWnuN2Li861MiCIw5iQwDaOxG05AAuYR5f/Bu900XomQkgQhvBRYHd6eiHdEy8/e54yRiPc63J435Uadx2OOCqr1weXDFZAxfvlTp32TIyV/gdJFjHHLZ6lCV+L5ntuRKTWYB4Z/IOU23cT30snBGcyVy/DD0vWaGHqOh/kngDjQ1ghO82CmWxc+Xi6XWD1orx31QFctm17sd9vAxoKpzO0V8INws1dHZphZw+yZ+ftcJn0IfsyzszkU2iQOri6xRc6J7mX7ZLtzr0KxTwOXZUuAdTgx/bcUpNcCY3Z9jFDwgUmbI97hDUpf06twag8qKwEme3023xgKNGTtlTc4atRvxU07amviJQpISUZAqTLvv1WXVdQKMYO9QQuLmtzoPWXxJ+BvZpAHXfT2yp64UKJkDqzY7ggfUnYFKUTFQjg2kzFSX60Rmh8cGKn10WTmVqcd7tu98rP8jNXzycgifDi+Ty5YFCr2yO
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
Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
---
 Addressed commenst from v1. Thanks!
 https://lore.kernel.org/linux-mm/20251022102956.245736-1-skolothumtho@nvidia.com/
---
 mm/hugetlb.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 795ee393eac0..b6c0024ff5a5 100644
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
+			err = -EINVAL;
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
+			err = -EINVAL;
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


