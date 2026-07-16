Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8098C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 17:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9069A6B00A0; Thu, 16 Jul 2026 13:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DDA56B00FD; Thu, 16 Jul 2026 13:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F64B6B0104; Thu, 16 Jul 2026 13:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49DA66B00A0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:36:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5A7E16026E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:36:18 +0000 (UTC)
X-FDA: 84995343636.09.321C388
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011040.outbound.protection.outlook.com [52.101.57.40])
	by imf14.hostedemail.com (Postfix) with ESMTP id C01B710000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:36:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aNMnSwyZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of noren@nvidia.com designates 52.101.57.40 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784223375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=knyP9Hij3wAxmwOgQtefrprZZasyE8hTckFnPpgVV54=;
	b=ofCxgb+vBC5zk12zUBKoI3ZGi7gwSoOUyY7KaWD1jYglakQ5qMb/WkR1kyIEwysyXJ3sx1
	4YwcEcDeAFijYRCLN17THiHpNAewCPwbmBybTV6zCjgsrt6YtMbP21dOekIxJwsQ6OMn//
	YE7aek2YllINr5I6YGQhoAbsOFOk27c=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aNMnSwyZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of noren@nvidia.com designates 52.101.57.40 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784223375;
	b=eZLT2BQNcpIdXmFcym6dFfd+Iaysvq1W1RjV/BVpJ3OxpXCikYQks3XxYjFaxJZzmS80fg
	j8TtBP30oATD+W41tCo2cqI0oE8cbZSWz7iNO3CRYlD41qzckB7yoXykEAc54CsffAMXYb
	tV5RBCmZpyC3TRxviqBhEGQ30k9U8jc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CjXBdBUYitRWbHZx+HjxQyuq9lSTMmS4Vzk8ClNpXP2g85BdEEyOUZnLsOEQwuDbtdQ2IqsJwOPH3cIWEv8fZESBrI4ftUUYOwrHS3vVgbP1LT1CFAxTfNzxNBL/a09/q64G2KvDctmHMmCA7gIr1jATCZ5ho/mbfNFYyMLlcAPQrHsAWOf9qUsWyFf5SGIp0haufJjVt1k5kNt+oET7zxTdMKOKoYgUdj7hyxj7JRf8OQhFKtuqnDQrYVJGHIFj4XZrmzKAM2dnC12x0IptpMdWHBSAxXdT+w30I33qf9Tr00o3oQD+GNiTE8CoeiCFdfDU4/di8Eje2enM3wm4/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knyP9Hij3wAxmwOgQtefrprZZasyE8hTckFnPpgVV54=;
 b=UmlZvGawnFUZpj04UYTe4rooPIaPuYZ8KVlVZWNoE5yqa9qRb9acwLTuS3v5SI0taJWGgCUsif93rFTKxJEWsyYTS60h/BJp9mNcBGZuU5Wxmqo97ZcksUJ8k/1AesxcyvyiG4XrwU0//KFNYySAHZYthe1WRcmzcUmWtCGeH3vKBPjh/Y0LN1lLtBAaOWpCmqHuL+uO3DhyaiTbhKM/lPC2f22qzS+Rky39PdY9G6SprUY2eldQkIAZ1/nPr4Tqsvw9oZh+B2WKl1zc4HuZZ7kCSU3WMU4X7cl0r6sOeu2q04xUkOeEcGOeGxQiRL70vKzuZQE0gniNTsjMwaoPog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knyP9Hij3wAxmwOgQtefrprZZasyE8hTckFnPpgVV54=;
 b=aNMnSwyZpIQ2ICcLjs0761NL4vTIf3579gUc8nj5NEepmMGc67P4sdmVpwYVkbU45wlpwc/1GRD9oa/a/JHjdpQQPKKdExNxwiHZXckbZQ+ztCQVqbREnU/FjTJXEKNUcVdbf0efHqkTL4sS7HTBX2HrtZnwqKOUERVrjRYuML0WZ8gQycwgjf+vEnMxHf3hTvY6gxi33MmW2p37J9KmOyQWCFrJLkBwD3DgaYoCYwaGIbTATaPeYG1iYxb85I/ki2X1hGQpMeojftNT/XwbW+D1gyphDeO/nsnfRiB4YpmgeXmW0Qj61TWFdLSYcr9++QQ01noxuIV++iVCfBrYDA==
Received: from BN0PR04CA0161.namprd04.prod.outlook.com (2603:10b6:408:eb::16)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 17:36:10 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:408:eb:cafe::59) by BN0PR04CA0161.outlook.office365.com
 (2603:10b6:408:eb::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Thu,
 16 Jul 2026 17:36:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.3 via Frontend Transport; Thu, 16 Jul 2026 17:36:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Jul
 2026 10:35:46 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Jul
 2026 10:35:46 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 16
 Jul 2026 10:35:42 -0700
From: Nimrod Oren <noren@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Liu Song <liusong@linux.alibaba.com>, Hao Peng
	<flyingpenghao@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Nimrod Oren <noren@nvidia.com>
Subject: [RFC PATCH] mm/khugepaged: cap pageblock contribution to min_free_kbytes
Date: Thu, 16 Jul 2026 20:35:04 +0300
Message-ID: <20260716173504.760369-1-noren@nvidia.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: 1705b121-c06f-4e91-3065-08dee360b915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|7416014|376014|18002099003|13003099007|6133799003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	KQpTvcTn7sNHHJFPEcNR9kaUDIYUwmIm0e/GL96EpYhcCCtYZmt6s2CS29fjdH2ddEyFXK5K25U4+7MlEjHarro6MG3qGpPrurkN2wVFaS8rjoDx9JWKuFCGAtpIupwYvvkg6M2aJrq8Ic7wY/G6pD5QLqFvEhD9BuZaETiNqbsPJpofwaQXXjmHqoPry1rSHmVxcU0iBdXD2oIw7I1aShbLC8usxWnDiWwXvCkW1xYkTA5edPDSTxhJo7RM/9sItYBe8yxFaHoWU/8e0LgJz6sbkfAbvfveADgdQ0nmfUEmn1UWT+QwwDqjFmrdZC/RnfBKYOng+MfcyfSfBVyhVPj1WSa1JZxBkNHyIC9ZTkj4TlYO6tQQ7Q+qLRAwRBjCMjlx0sGlpCZUNg6np3Ioz7eR6NrInyzAeChdomfXo8EWiFsm+quZ2JbRsU9lYTliAILXBDINdcpHLanUmKZbDPxYFQZeU/xtX8whxzjGE1pcwuWVGOqbUSTQqjyDPase3Q6XvWKsQK0yPN4F4h9avlgQu1yAnEPRB4greiZKIgzQ6Xrcpa+OW4q++D55V8K3sEB/xVmeYEU0OfCPoYtcVvBCaT1YdDdtJRwXAkyteejqRLveOK/ulhTkQFRAeW3jaEQHQQalNNVPM31usXP0Wu9g9CtFcHZ5tISEMQGFL34+8A95o46AmI0YVirp0Ugyo60JY5NulJBDmQov8KaEaw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(7416014)(376014)(18002099003)(13003099007)(6133799003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	v6L6RaDUG3hwhbsF/BcgCVqFKvl0BeYJ3kXrxxQRFAIx+IrObf4XWvvhH/GX1AqDaUZocu/WxGYS5lBFxNyEP2+g3CFu1VFGnAVSFDCf0Rbu05OhIJnj5ZvRxgZsJcgMeBoYZ2U/P+4qZ9U7WaNZ2m6fQGY8d3RrG9Qor0VKiCUr0yc7GEkF0ZgGw8vAusBDN7VBM0bHOH2IduR2EsItrs1ju8f9t5OIA7z0yQSFWDrD0Ib7+Q+jF2Vw/cNBO2sWUtGJYX/+I+A+pVDv7ZCeJIjBHncFhTx1bNGZ2lCsrSjlPoJik4+NSuwuok+bK7dcSYAX2AKRQmj31kTGavjfbmmh2JXq0X/+QRShn/lNJwDP64LuvFiaqSwbFXbkjvQks5faodzn1LW2RX7zDnMfDDF+zI2NY2svEZpCJKFV0dsqt5mBcht/FkpBBIgNMY+d
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:36:09.2719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1705b121-c06f-4e91-3065-08dee360b915
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
X-Stat-Signature: 7mzbgcccixw4b86urftk5uwd5jrf9j3m
X-Rspamd-Queue-Id: C01B710000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784223375-839626
X-HE-Meta: U2FsdGVkX18iUQxWSn8iGIo1hoUeszGfU0fRU95n4l3V9v91vCW1xy+cIyF4nCByuAq6OuDp9SNWQRp0nnhcQgYEzRdIzvaYNDSjbXfnU0YWgoStVx6uVv8FtEUIojuEhktV9utkuozySu1/Woxs1cAlw0OwPZ7J9QnMfD6sH4pjGMl9947ot3xJviX5Sto+6tXPMULPWjpYDT0BTNRguL6p0Z1l2DV334sDYPrPPFTGQeNnANP5zwWnCBgmWp/g3obCvcAR8ovYQ+YSOKdzmLYpy1WPnfxkcV3Y5a2TLDRWaNG9H+Q/B7/NyeELGtV8ek8DXBmFiUMOwjcikOWZK6ZWK8uzsJ45s7uv043NprDdQ9T7O7OcFMA/N2aex2yM90g9Bd/DhjPe0zRG4DbDwqj0hAnSmEJtpjZ+CFJDHUIFB+F/92X0YN86i0vR8akSZi+KanxW6sD26DBo2KfSLN7UASM4FYbE6+/lHHahB9VmEC+pCEAdnT7qAzl3CCJc/2mNgNFhyENz/S69sMHkXendXNtf0lPDgRurdgoh610F+TqvG/BKK7SIYN5wVmOSztcr7g/ysECJ0LtjR/vuKZFWwxu7WsCK9+hewF/WQiA9bf90H/EC/iSvdk6e8wVZa8dLzXwS4jRTrJBgA3N9mzlSOvjpMQUb5RqqACiyZjYokqUIvTf8MUUvOnxcjo4HsjB0QpLmrUdT8p4KA77iYsL5LHwElpOk8zaTFINDvjTCE8cqbRWQFHAyn1BZNbwStd9b1BKmXZLEkh5+WSvHMndgb4W46+A7B7+pmLLh9k1NX+QbxCFoPKUjWYVcv6+WQFLqb2nLYUin7ISB/WwjYLZT7rP3/ZuEc1XzrfEIHI6itrY8QR59ZoYM6gDsPpheoFthoc0yGGXYod74v7pUxoo96Xd818unOJI4Yj5xyLvjvZHfyUUCDAavItGE4RJvUxohGXPpYKVM3xREUap
 dCSYu0Df
 D2RpQIUazUl7hPTZjzVD0sitR0g5j0tnd5PwydMfnNbh2OfSgl+lx68isrkId4M3gwFHngCzJnzo1bBkq6WSqzT8h53tUA7Z15aH4TbxrDSH3d6+K+8Hdgw02jUALoVxqUzPn6I/BRIR7ykD+WCBXNtKqwGI1xCWN17YY7TsX/L6DGb9O5cpUwK0J+Sx/yRkSjJJSys5ELvMwd1TPwGVooBjIfXLneYenQishewJnZ4FNLJtPs7QmwoX4VqVOfsyeQmOWqyk9Lff+nic8nhqQSuVzKTZj0RLDnwwQEgI7mMJUws8CK4qtzd9kcNd5i9JXQnWOp0VuLgxQrVrZ0FowHeaRTYQRgaQwja2bdwgKNyoqehRMbZXNT+KpDv+CTppRamVhR/T7gVHbNwUOIWXQ62uj147jyf5TiE5/CipxoIWDtBvJypTj/3IiQpROTLpECwgD0JZ/4xihFJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When THP is enabled, khugepaged can raise min_free_kbytes through
set_recommended_min_free_kbytes(), using a heuristic that scales with
pageblock_nr_pages. With MIGRATE_PCPTYPES equal to 3, the formula
accounts for 11 pageblocks for every eligible populated zone before
capping the result at 5% of low memory.

This is reasonable when a pageblock is 2MB, as on common 4KB page
configurations, but scales poorly with larger base page sizes. With
the default arm64 pageblock sizes, the contribution per eligible zone
before the 5% cap is:

  4KB pages:   2MB pageblock,   22MB per zone
 16KB pages:  32MB pageblock,  352MB per zone
 64KB pages: 512MB pageblock,  5.5GB per zone

The 5% limit does not make this harmless. On an arm64 system with
128GB of RAM and 64KB pages, the current calculation resulted in
roughly 6.3GB for min_free_kbytes. The corresponding aggregate min, low
and high watermarks were 6.3GB, 7.8GB and 9.4GB.

Automatically maintaining multiple GB of additional free memory to
improve the probability of 512MB THP allocations seems disproportionate
for an opportunistic background optimization.

This RFC proposes capping the pageblock contribution to the
recommendation at 2MB. This would limit the contribution to 22MB per
eligible zone while leaving configurations with pageblocks of 2MB or
smaller unchanged.

Earlier proposals to resolve this problem involved disabling default
THP on affected systems [1], adding a knob to disable the
recommendation [2], or deriving the recommendation from the largest
enabled THP order [3]. A fixed cap requires no new knob and avoids
large changes to global watermarks when THP policy is changed at
runtime.

Reducing PAGE_BLOCK_MAX_ORDER remains possible, but it is a build-time
policy that changes pageblock granularity globally. Its effects extend
beyond the scope of adjusting min_free_kbytes.

[1] https://lore.kernel.org/all/CAPm50aLPxJCiVTqqwiz00oMNiqHggB84sXB3x=tv_HUAd5UktQ@mail.gmail.com/
[2] https://lore.kernel.org/all/20230817035155.84230-1-liusong@linux.alibaba.com/
[3] https://lore.kernel.org/all/20250606143700.3256414-1-usamaarif642@gmail.com/

Signed-off-by: Nimrod Oren <noren@nvidia.com>
---
 mm/khugepaged.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27e8f3077e80..c0570bbb1f4e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -23,6 +23,7 @@
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
 #include <linux/backing-dev.h>
+#include <linux/sizes.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -3066,6 +3067,7 @@ void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;
+	unsigned long capped_pageblock_nr_pages;
 	unsigned long recommended_min;
 
 	if (!hugepage_enabled()) {
@@ -3084,16 +3086,23 @@ void set_recommended_min_free_kbytes(void)
 		nr_zones++;
 	}
 
-	/* Ensure 2 pageblocks are free to assist fragmentation avoidance */
-	recommended_min = pageblock_nr_pages * nr_zones * 2;
+	/*
+	 * Limit the pageblock contribution to 2 MiB. Larger pageblocks can
+	 * otherwise make min_free_kbytes disproportionately large.
+	 */
+	capped_pageblock_nr_pages =
+		min(pageblock_nr_pages, SZ_2M / PAGE_SIZE);
+
+	/* Ensure 2 capped units are free to assist fragmentation avoidance */
+	recommended_min = capped_pageblock_nr_pages * nr_zones * 2;
 
 	/*
-	 * Make sure that on average at least two pageblocks are almost free
+	 * Make sure that on average at least two capped units are almost free
 	 * of another type, one for a migratetype to fall back to and a
 	 * second to avoid subsequent fallbacks of other types There are 3
 	 * MIGRATE_TYPES we care about.
 	 */
-	recommended_min += pageblock_nr_pages * nr_zones *
+	recommended_min += capped_pageblock_nr_pages * nr_zones *
 			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
 
 	/* don't ever allow to reserve more than 5% of the lowmem */
-- 
2.45.0


