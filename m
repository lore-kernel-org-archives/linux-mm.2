Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A66EB28CB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA846B009B; Fri,  6 Feb 2026 01:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D882F6B009D; Fri,  6 Feb 2026 01:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86C16B009E; Fri,  6 Feb 2026 01:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B57836B009B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:26:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8299E1A03BC
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:41 +0000 (UTC)
X-FDA: 84413048202.14.34D6928
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010035.outbound.protection.outlook.com [52.101.61.35])
	by imf19.hostedemail.com (Postfix) with ESMTP id 856701A0008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=tIRumDAE;
	spf=pass (imf19.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.61.35 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770359198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVlxDfsPiBs/8ApMubMs+MIKCmFJLd+FLDafHNtFdI4=;
	b=cDuLaqsJGHbJCVVNPNRFvjyPNSlGiDk9obpkV6v3BKJMogIt8cyEyQfZA4cdWfQEoW6im6
	7ubeoH06z+fui2Say4QqUxRDbiFyrGe1/F65g+lqaOol+spqd1U2lHS5A8Xq+B1PtQlhGu
	tJ1ZQ+sGkutAi81vWuMdLG9aCRYgV/A=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=tIRumDAE;
	spf=pass (imf19.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.61.35 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770359198; a=rsa-sha256;
	cv=pass;
	b=lScbTvr86HuP6+C/AdTMSkZItQbsf75MrzFH6qhXqKW8gaT3KY6O2WT4KifxxSOWVOo+Yf
	8I2AnU6gdGpe4B/lSkwg6rUtDOfeZDg/MTgG5khVeZBGoOa93PeJGp664qG3TA3fDNMhw+
	N/HQ9kvkl7LK2s6vjrN33hgoBCYFKRA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XS9rPW3PmJfiR317pTpsLNVf49R7MoJGqmDgMmc3rrx4Lqya2MFWxEmIKCOaRy9fqy9iUT3YZeEgHQON/BvDZB9QLp8vjNXo1lDdfEzvh6g5vZ88As5OF6A7L+PGayzhhd3EGAiV/sl9olNNF5q+ankro0uIfRW3lGksUhvs92mhcLATCY+rsS3j06RvQyymn0UZkS4llnGSKssjHocy+42y1sJ6Qcspxio98S3Z0j/q9hjWCuoiU2/0kP06ADcTrB8sDaGCuh9sdZQGS0zC1kwWsBDuzWkto984RZFuc9NF9INEnCaSl7wo6iBI0MtEOJNR/yhq6Ad4cY80MS0n/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVlxDfsPiBs/8ApMubMs+MIKCmFJLd+FLDafHNtFdI4=;
 b=kaCkvRdZElOGUqDypND/ZkP7QfJCPkFD0OZ9H88mjiqV1txaTm3CxCN1anfLouB1tUCU//jjqTYdrKNPxik3pyDaDiGTdXMNehxSsYQWE3iNlevkxWvrn62hqoK7aoxi3rVWe9p1D5Ow7gQ6mb1n7/Zw5d7bQlILXJci63B0PB0xQSFi+8QJN3CBz56Tkd9EPXj1SqIn7g5o7cvuxrwv5JLlXSycQ5jvHP1F0BulUc7bxqoeENOjV2uf6fMPwJvxE9qjfSizL2qc8US0eylAQWb3+/G79QU8G1e3dgzse6vGwyxN0SdecsXVhUuHqIhU66zxaBdUwBctNPypXPTADQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVlxDfsPiBs/8ApMubMs+MIKCmFJLd+FLDafHNtFdI4=;
 b=tIRumDAEGWcbCNA8DIvMy4ULkumP8G0z6kUCQ42BcYsWX4HZViaFzM1DyNdErtFmR1jdgLZG32T4qxK2bC5pjJeEpVTMKEFzgCUjkaukOxOlbYELlLy8EvlOtV/RbJvK7jX97Kf4PWlp0wPGWkq9AJ3FjgIBtOyqiWVca4p8KWw=
Received: from BL1P223CA0020.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::25)
 by DS2PR12MB9663.namprd12.prod.outlook.com (2603:10b6:8:27a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Fri, 6 Feb
 2026 06:26:34 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:2c4:cafe::2a) by BL1P223CA0020.outlook.office365.com
 (2603:10b6:208:2c4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 06:26:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 06:26:33 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 00:26:30 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v3 4/8] drm/amdkfd: Add batch MMU notifier support
Date: Fri, 6 Feb 2026 14:25:53 +0800
Message-ID: <20260206062557.3718801-5-honglei1.huang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|DS2PR12MB9663:EE_
X-MS-Office365-Filtering-Correlation-Id: 735483d9-9614-4722-f304-08de6548ac73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uYFyBbY+LO5cxKw2jAq1N4BC+nI0caNQckFnhSUskeweXcuTqP7p4/3fs8gt?=
 =?us-ascii?Q?N9rvUviPp0tEOXtAmbuKfLN/4ewVsP4GYjWUMjK/AyCS26pHeG57eNAn3BXn?=
 =?us-ascii?Q?86ItMnGKU1Z3cVFCfi+iWtRt2IuUUBHO3nVb8K+D/INVYh4Zgkoczo1kVGeb?=
 =?us-ascii?Q?cEYAg4F6ra9Csjf7q3erFrKliwQ0CswTLcMdPv0sdWz8WI6COAuX646EvPv1?=
 =?us-ascii?Q?UWLGDfoOiGQ9NvqXObY5RkK8aNrAbuNTyme7B4ud21TBRgEwklFsMI/Nd/v4?=
 =?us-ascii?Q?WvMDM0kizDzq8dvvGwsIda37t5tdzPYnmAmphAy6w3I4zEOkI1uNO5yvD0IR?=
 =?us-ascii?Q?D6isb8P9XJZ/uvf8m4/qUQizYIgzn1372hRGNeeRxJ0vMqbE5A8vPg+OLwjF?=
 =?us-ascii?Q?29EWDPNS4szpQNppVtt7pEerd/LJxL/V3k/MZXQdn0ihHV3Q+1MfXUCHDixH?=
 =?us-ascii?Q?3vu+0OQD3xbiXh0VzFnSJoBfcfTXzeFG2nda2D44Llt5O7PPH5ddtRibieKi?=
 =?us-ascii?Q?RvawHqtLGqaOcpIzWfIBG3F55MdHua4PBEguXUpZ23CrDg15t5atIB1k+Vow?=
 =?us-ascii?Q?9jhC9inal+k1jTFpNe6qBcNw7Cyu14kgmw8uVh4X6N+rO3D690nXyWkTAimJ?=
 =?us-ascii?Q?4kpUDm826BWC3R3rQns4OvtqWu8+ef+6UGq9Bu8Hmgm/Hq0UrCT2KxEWqkrZ?=
 =?us-ascii?Q?cBUIY7+YLy7DxbH2By6k9S4sS+FikTUW8r34Bu/0aVki66SdC66yoqFpBHDS?=
 =?us-ascii?Q?LXJJgKL00LCf1T9kjJbjSzrmKiugDTOf9xrySOH5BsEpXPhNKTeWEMwoO6Lu?=
 =?us-ascii?Q?Q86lF4btdegfJN3qrOy8PRyOERfk/wzodFugjuMwFiIGaaDqHBEfQvcvnu4M?=
 =?us-ascii?Q?DrFN/8ja6ShPiqwjO4M948ZkL3+Zf7JGTTTTX68Hl4+wOpmgdFQ5T8nfH56E?=
 =?us-ascii?Q?TpttkMowkzuLCpGPU0TxV/lCvS6sB2iSLp4nyTtQL32MmKbK14Dl0TQ8iH53?=
 =?us-ascii?Q?siG8AYgUEFDl7baRqwXyGk0h7SPDCNfMGhgx05/SjlDOi2KR9rGYzz4MqM0+?=
 =?us-ascii?Q?9h19/dh0Ec9o+u/ZlMHs8UKd3CA+oopbY5+lz6I3ATQu5G0qIyydrGphr+KH?=
 =?us-ascii?Q?YFK+OFz+/yZxut5THHyjQC7SLxgUxcPkh1Ict/BvPbmXpwj9KZcO/XmmDRJD?=
 =?us-ascii?Q?KjLZXNv7vwp3avYFK2smasTlFGeSue3PTk/uIykO8lcFCfQ2kax05XFd+U0H?=
 =?us-ascii?Q?DN1vfOkRa/yRThh1PkhU2WY2rfHq6JK7QY4/TcOoHPmkA4p6MnbSO1Ns2oYP?=
 =?us-ascii?Q?22YFFN29TE+6abEboS0cG6N4ZPkDvNjUXLZDgPv3F+rGhyFyzjbrURto7eoK?=
 =?us-ascii?Q?Jc371Vzs0xBt3kgYrFJe2jiVRD2W6Mv352cUKTQPT14JgnqovV2xkVEUzlHn?=
 =?us-ascii?Q?HZMt/o6ulOBRyDvT+UxsO0ZOuAs9Vde9d9ZgPnMsL1ltSlooQrg+BNkjrK+e?=
 =?us-ascii?Q?p6bbE3ySVWQUAGfIedFCDZLcGWhd9nZ6atGt5J8jkQ44b8NUNC6jtjOx9I5h?=
 =?us-ascii?Q?YSaL+WjzzTrw0M/rhUtodWPoav7z8qSiPvH1xj1dCt0ws7FnH78y9kliWvUe?=
 =?us-ascii?Q?Qn6H7ZdZQltsqaad+DdAhq66h0L1Cy+hZgKoEFLfjlYcGtWxf2MZs6wVCaZZ?=
 =?us-ascii?Q?KJyStw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QtAlBIJdJU/0MDYTD7ZRpqd66XWKIUgHXD0dZRnJGopjUhb7/vgKSrBo16zyN5u+G4CsGUVEA2adOfbBTdLuIgbew19UifpP30Hm+wo5YqwKaaewRLZ1KNPhOx3AILZ5njy/8HUMt9Di08IYE65gqABJ8ohgQiDNo5i+cDFxNWHNxoqX7YkhOIbxE05oz6J8GZeLsQZKCHhcl037We8zjXvVT3ebFuVSOyrgPuXKOuj8MzsjtRUhZtqkoFZrDAA9mLDvncpKFhfskchqldB+pqEtubbccIZdQ50yGVEgXFcW0HW1oQ3bLSoxEt7w/T+ioD7UVJ11B1KZ+iGXO43ZqyiAO79RB2KN3vG/spcB7Bil/5kGXwRb2VpphKqW0OBTD87LUuGvGTMhNLgmr+BP+lnBI3EkJe1XfBIFyIaEx6eeskaiHRN0FP8USutsw5Qj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 06:26:33.8087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 735483d9-9614-4722-f304-08de6548ac73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9663
X-Rspamd-Server: rspam11
X-Stat-Signature: tb68o7gremhemmp3sp5edu1tjxu3az5p
X-Rspam-User: 
X-Rspamd-Queue-Id: 856701A0008
X-HE-Tag: 1770359198-289223
X-HE-Meta: U2FsdGVkX19otR0Yh0mT1bZoOKn2k5s9ORlp3bM+TUS3UzTc0psX25cKDd2TcDH1IjUMXlgAodK3SWJQThcnJLJ9Rzk/B4XgP5gS+5J83oOTfZab0GQhHcoQXhApxin+B/Q9Z5U8me6/sWgyA1S2TGwHKuHN63Y7wNrJj8Zz/R/AhZx739fTKe6CCZpdhlyeQ6ecJr50zOOg2zmCe8XzkMkIfuIaMeChB/g9/QfyUIfDblmxsj2Iiw8+SLDyjNsQylRPpfMoVviwtUaV2uWYGf2rRgD/mDSmMvjdxhoRpVjvvgyDU6QTTaRBvt9AQOqVLW3gihC3J/mJyUwVC3bUstx107L1Zx/e9odrlN5uhUCM8r006rZ2eXVG4X8pSS07BjFo7ISCu88EwOgqderSoPRMPWJQACQzZAfzfIqWpLiyGjaJ7fZfMJfRg0Rw7cpN18pbLy9y30pi3DH1hUvRui6TyThn0A1yYVivpdv8CkTJ63NOvg+P2ZToWkAWpuCZHzN5bEtTd8LR7c8MM24imZX0V3Q4s/8sUSlOOWeSPrC2LehNvarGlbld4kQcBjugsnRq2hEsUfY05P7OOUcDHf2yO4pCemTewLlpeUYeUhGh5qieOnTY5d1LtQLEcK4vcAhrJMVHZRMwf59q1J7BNX7aRiYvesurQKrM07ett8Y/uJnFBmJ1orK/Ki30SWRZOyN/rLMo1/JfGc/UbpiEPJPDscHsqqXhC/rpoZvFk1iEjSjRr7EO9ReroYxpHu2dbBu6vPW1bKGvFPTr/VCaO7WCvNl9p62O4/OwdpWjAhQhW7nmU/P0Uh3SrsfveebAo+beu0YAOrfMz/4B0ylZ8cLgE2GXdIsLMLRn7EzAaRw6alrXLtzqY1jyM/e9Fv7oZw1YU8H0kbJKSq2eHo0kGUihYOse/ENAaa3wSE4l6DhYYzZXYCZEDhTKJpG4wtbwyTIceuVrFJ7Duig7S9i
 nMs6HdA+
 /YErGxATw0ESkow1ACN985Nm6eQ7J6kLEK0WHfvfB57ePcOEMLzwj1dmTVmfby9+2X/Mlo7hL+zecmYcP7s/oYsNWEbvD0BKMhyuvmf5VMgmBmjOGTMdQdW7PC6csPks9HIAtggAE59Kj0i1odj1VxLhTUCP1jkBZN8OdZ7NrIrOjbkMmlLweWaaRfAjf0aB2y1Tlv1sXgHNOybVADfLwoykUmCiewA726aWL8+K1eNiEwcKO8mQa9hFEQXFi5lyUebVuvriwzEyuEjL4CdSQgd8XTQixoSrzM2NAHyBW68QiR+zE/aBShIuChs6dsBdYBGJip/lecPNBTLhDzq/bIm/oFMP1Qqk1zxDZ3ISx7YqzWku8+wYXpy2EeY9UQ+2/rZsL9LDZAqZPTJMoezK3zc3Zr19/UIjaaekFjPLbj7LkTNjxnz5ePCiRrpONnmJAWmL3OtRe4xg82XU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Implement MMU notifier callbacks for batch userptr allocations.

This adds:
- amdgpu_amdkfd_evict_userptr_batch(): handles MMU invalidation
  events for batch allocations, using interval tree to identify
  affected ranges
- amdgpu_amdkfd_invalidate_userptr_batch(): wrapper for invalidate
  callback
- amdgpu_amdkfd_hsa_batch_ops: MMU notifier ops structure

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 3b7fc6d15..af6db20de 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1143,6 +1143,63 @@ static bool mark_invalid_ranges(struct kgd_mem *mem,
 	return any_invalid;
 }
 
+static int amdgpu_amdkfd_evict_userptr_batch(struct mmu_interval_notifier *mni,
+					     const struct mmu_notifier_range *range,
+					     unsigned long cur_seq)
+{
+	struct kgd_mem *mem;
+	struct amdkfd_process_info *process_info;
+	int r = 0;
+
+	mem = container_of(mni, struct kgd_mem, batch_notifier);
+	process_info = mem->process_info;
+
+	if (READ_ONCE(process_info->block_mmu_notifications))
+		return 0;
+
+	if (!mark_invalid_ranges(mem, range->start, range->end)) {
+		pr_debug("Batch userptr: invalidation [0x%lx-0x%lx) does not affect any range\n",
+			 range->start, range->end);
+		return 0;
+	}
+
+	mutex_lock(&process_info->notifier_lock);
+	mmu_interval_set_seq(mni, cur_seq);
+
+	mem->invalid++;
+
+	if (++process_info->evicted_bos == 1) {
+		r = kgd2kfd_quiesce_mm(mni->mm,
+				       KFD_QUEUE_EVICTION_TRIGGER_USERPTR);
+
+		if (r && r != -ESRCH)
+			pr_err("Failed to quiesce KFD\n");
+
+		if (r != -ESRCH)
+			queue_delayed_work(system_freezable_wq,
+				&process_info->restore_userptr_work,
+				msecs_to_jiffies(AMDGPU_USERPTR_RESTORE_DELAY_MS));
+	}
+	mutex_unlock(&process_info->notifier_lock);
+
+	pr_debug("Batch userptr evicted: va_min=0x%llx va_max=0x%llx, inv_range=[0x%lx-0x%lx)\n",
+		 mem->batch_va_min, mem->batch_va_max, range->start, range->end);
+
+	return r;
+}
+
+static bool amdgpu_amdkfd_invalidate_userptr_batch(struct mmu_interval_notifier *mni,
+						   const struct mmu_notifier_range *range,
+						   unsigned long cur_seq)
+{
+	amdgpu_amdkfd_evict_userptr_batch(mni, range, cur_seq);
+	return true;
+}
+
+static const struct mmu_interval_notifier_ops amdgpu_amdkfd_hsa_batch_ops = {
+	.invalidate = amdgpu_amdkfd_invalidate_userptr_batch,
+};
+
 /* Reserving a BO and its page table BOs must happen atomically to
  * avoid deadlocks. Some operations update multiple VMs at once. Track
  * all the reservation info in a context structure. Optionally a sync
-- 
2.34.1


