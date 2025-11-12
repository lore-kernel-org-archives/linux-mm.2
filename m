Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0994CCFA1E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB888E0007; Wed, 12 Nov 2025 02:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3478E0002; Wed, 12 Nov 2025 02:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B94C8E0007; Wed, 12 Nov 2025 02:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5738E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:30:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBDB34BEE1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:30:03 +0000 (UTC)
X-FDA: 84101131086.20.B1D7F89
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF1E91C0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:30:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=k7He2YPY;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf18.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.208.1 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762932601; a=rsa-sha256;
	cv=pass;
	b=2BtB/YltLDd0XKi16JIfY7GuUtBt3ojyzrm78cMD/CP5ePWMkssphenACVBJDanhryWrmv
	YN+CHmm5y/g4waj2wTUAGw7OB26Fz6487nuR0rhj2KC+QDmCOKJnzbFx51imA6gaMS66v2
	Xyrs9Podd5ztlZIeHN+VJTyssqYNqVs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=k7He2YPY;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf18.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.208.1 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762932601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLTKlYfsyFItZP/YxHj3rdg8VlpV3fo8cndrFZz2Lig=;
	b=JEvvRdNqAx26dHvxMrjTLhdcb+Xqf3+okpU/BrRFeWvJ15+Wx09eD5q0Bon8l99mC7sFg+
	4jZn3XKzWVn7DtvcOblIX1Lu40JihLC1yQqXM+rmClNEMyGvvAqadAdGR7dHeyY1T0yW/G
	re9vxLAmmt3wbDkoIOlw8XXq/y7589s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wfQCQP9o4jVqd4ImjJM2/G42EATRZbBXlzQQzXKFex0CzsW888DvXX3JJ9ljNl77sXQDRAxPiS/D12FgNO0zf2yWw77oklZihnUfFGZZ8XB/rntglhe+Js7y+ZEQDDcWJWzpY37gTZ2xmQ9N7JIl48BIDIJTHtEtV2SCC7N7f5G2CXOtXHkx7l1lAEdElTeQRJDNNz4orohYWsfaqJsH0axuIgdoWjlYFiPr90ETdhvT3zvLWzWy6FA0AxC8m+6hP2nVavgotKyAcgrw6sPDO076drz2f4ba3IMa9nYeCgClxbEaUf000bBCPbxIe0/3NAXkvSMYXHbTVOjtj4ZFlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLTKlYfsyFItZP/YxHj3rdg8VlpV3fo8cndrFZz2Lig=;
 b=mEL0s7KEVPSUoYU0bqe2SWaDfQwfiApIjyswR51ZTRcoa1j27PH4g8uWJ4ABF617KSoQidzr1POPFyBCky7loqLWVCUu4Nlyhw14XTJgufIYAV0et06dWTUm5hg1i5m4GIB1ZWLBP1gk7wt/XGs+wq6o3QZGUskjy00gpTfd1hRZB/pTaVjY7VkoCGbz8lVYaTSyw0Y3Nb0mzNIqxCwiRrRShGpCej2R80JlbCyQJdQu1gxP5paFok3r7kePEclyhmrPORNGpvXI0JVgbNyJAB/f5y9tjXM2G/XDf+gYWDJ1orjvD5554+y9AzyGmhPR46l12H7lSGu8Wzgj1ztI1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLTKlYfsyFItZP/YxHj3rdg8VlpV3fo8cndrFZz2Lig=;
 b=k7He2YPYGCYPWdAjuG8r6C3RI6r+/v/5OLWYzgUGGb6x4D6dTxtm2QutNNRVEkl5wEJKezWssmel432Ah9UkR91CyZ4cLjuXvWFhF9mPXkLswbOnzAZZe42dEp8AoZ8q3teg88dWzw8cEaWVeL4xS1B1BPSX4NUJ9LwrnB9exN0=
Received: from SJ0PR03CA0109.namprd03.prod.outlook.com (2603:10b6:a03:333::24)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 07:29:55 +0000
Received: from MWH0EPF000989E8.namprd02.prod.outlook.com
 (2603:10b6:a03:333:cafe::14) by SJ0PR03CA0109.outlook.office365.com
 (2603:10b6:a03:333::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Wed,
 12 Nov 2025 07:29:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000989E8.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 07:29:54 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 23:29:50 -0800
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuang@amd.com>,
	Honglei Huang <Honglei1.Huang@amd.com>
Subject: [PATCH 1/5] drm/amdkfd: Add KFD_IOCTL_SVM_ATTR_MAPPED attribute
Date: Wed, 12 Nov 2025 15:29:06 +0800
Message-ID: <20251112072910.3716944-2-honglei1.huang@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E8:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 7796e9ec-7b45-4689-355a-08de21bd4672
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lIM0yT2x7l509NUPb3wIeAFKfF/vEKQU9oZyqcOnbtj1d6Imawr+ThFKEkAS?=
 =?us-ascii?Q?YQYRlgXv3QmC0ZmbZNDhueyhdBHk5sTcSfGDZpvzofsL7VeTuuGc8y4/5mae?=
 =?us-ascii?Q?TqcVWwbnhp4Pp61QQDABZwETZ06NJu5TgYoWgYHkmhhRXdXyqZhZ4kjz/uLL?=
 =?us-ascii?Q?3T5W6LhWWPZ33wtTgFQEI5OTO4KFGHI2Y1gDbT7zeusTOiMaUj+9K3PBRbRH?=
 =?us-ascii?Q?2mbiaG7stOBdCQkwnHYPDqLtdfsaPPxRXalwSxQaUISBGBsMGuVkF2YJfz1U?=
 =?us-ascii?Q?TUzuokxyimoiMD+bDMnynMFFzq5nsJhMXISq1n68+XMC3rAb8VUjZ5BtQrB4?=
 =?us-ascii?Q?8MGMVbiOfdWH6112qCTAPXjr2Ky1CUVAHJiDXmMrjhqqzGOktMF/x2kLtUGH?=
 =?us-ascii?Q?qR3KLceX9Nealt5PD0CnkQEypd0jCXNe/AFx4hVnszWmE8KuV4BCamxF55/S?=
 =?us-ascii?Q?lgEW8MwgyJHvUWutWsTXVeg2MJzdZ8iYoLjgl8BuWuAufbG2//tmZ25eXn4Y?=
 =?us-ascii?Q?Cm/EumrCJTIQd+rFGNUFUzaJJ8vuChRmf+ns7a2PQcHXSGQM2n5Qn9gmYw1G?=
 =?us-ascii?Q?c3+OVtq0oNJ3N5ND6pCpMT1al95vcR4e4gozczQhjLDM6t/TDKStiYsi6npd?=
 =?us-ascii?Q?duBGiFGiQgTeSGPLZZp06ifZpF+AsJM3A/pzR+xfnlU+sXFvV+wND3HC1Fsr?=
 =?us-ascii?Q?JvofDthbmXTE8IBIDoXcn/MTxDgtHVVdp8xT1TYzNxDXLKmHMCJyu/JInbZu?=
 =?us-ascii?Q?vsN8RCkzOJEseN9RvaYQQqnH+j8vg2Hs0Jh0QZAU/Os4m//PL27JOgGZlmET?=
 =?us-ascii?Q?qJkk5F9+ndbEYJzOWKfwvTYyuKqhPNj7rnrVZkC5JGgn/qfcUe1tl0R+tKTO?=
 =?us-ascii?Q?fOxzluc/lYcGDoLmFk2IkwsxmkeJop7E7lwL6FBPfKKhR5GrO8tY4Lj2rj7r?=
 =?us-ascii?Q?U7UnLM8RvQy3uAwBkcCx92omOf12NNfOsWW8iaQUcOu1mVRlLa1A9E8zpejP?=
 =?us-ascii?Q?i3TZj4tB/Uz6p1sAf1ECRbPeLXO4bMS+4XBT2JzxQa0fGSQWR1Aiwg/MkXUM?=
 =?us-ascii?Q?LTlGZANb4m8ULDtVqU8Ntju4HS1Wmtdg90EgxN3Wmth557QLl18Qkbkoko61?=
 =?us-ascii?Q?ef0I3XqjWYp9eF7AhDhCNzjerL2m5HfS+UPVdvjjQ7Sttspf++rVnp8j2s2q?=
 =?us-ascii?Q?yKM7vZ3hDh7I1tJtZg0kDn8To2Z27EXMsSA59fWLt3wQGFKSrwGDiyX48LDn?=
 =?us-ascii?Q?MwuXJNr0SxePXVy5WhyCF2UG23HKe+BomgJJLLPDMkIo+SBdbHDXx/v09Usm?=
 =?us-ascii?Q?gFnc/TtwYkbB1CsrZHWZkUwlRNJA8Gl8znCa6IEpUsHg7TJ6yPRsOv7Ka7cs?=
 =?us-ascii?Q?dzqAA5viC6TXD9h5NcQ2teoF/Y7DovEdNpHgRcVmtU9oB2nVDqLr2B6J6lvv?=
 =?us-ascii?Q?2JYg8qvFdKlD42dcJZAgwreg+WWHrHFISGVZJk7qWsErjkGCNQ8SbLZAcaue?=
 =?us-ascii?Q?f9V77rzutl6OFt3XwEtPOhadR7VwIAIw6rdTK9E4Sth0N1Cgu8X9vMeTiSLw?=
 =?us-ascii?Q?FCB182HLBG22eJoU/EE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 07:29:54.6289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7796e9ec-7b45-4689-355a-08de21bd4672
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DF1E91C0003
X-Stat-Signature: 99jdytm6fcdosq8z5yri36p5ahy8nrwt
X-Rspam-User: 
X-HE-Tag: 1762932600-698856
X-HE-Meta: U2FsdGVkX19YqxxWaDe5WVdMnqUfX/uHeaAn429wGoodrnJbY7WmbFAuyL1HMinXS6lm+A1q3rPRloSW51mR5Bw1IS6ZFW+/Xlbwdh26Nz2Y0IjhcUFu2HIF4XievvJ9iFKEy45vNTnGlVr9PNsUiCogBcteL9VGUTakPrQpWviies9YPR958tpoV5UBKQXE57aSaBFziCaCYJlAH9g8P+AwAw/u+udHiQjkgCRkL+gSfGAsIAYuyGC537OdEK577UojLIgpMYNqOT6AvRxWmxZmy8KhalfZcUwBt4tKRGscvsKwRzwoQH1l8uNzaDW7Y9sYnc/voSwudPBJ9elmH2SUO/K+6VerWDc0bV2txEhsJWEUZF/uETk/X+oLS8/yPmpRZWkancUcMqMuu2huiQM4YOOXUMp806B0t3xyPKHrznNjH452HtdsGI2adxDj0zBPevSrwqTgqhH/JRNzJAkqeUWzldA1nIIuhRNK/Ib5zj8OFHIgLd2bPg4Gc9oN0ehd1iuVQSCTmyTVzia0ZqljIhqUT/9Dv3nNxzhvugFtB9aJ8qsrTIM4/LuJuTdaa7LhsbUWJoKPt5o7hcDvCi6Pe2+czsdfpm2FgVHahXKrKJEsczCxWKPgMOuDyDFW30dok/rsZGJzDnhYIhB0lEcroLTKwHKqaHTE+kgpQ2xsRWRaEIQcWREoY+8NxI9seF365kbN/bf+JaMFXs0N7KQjcY0relLjsUCwlprVo70gKukDx/B6Qve8PmbrxXRuQJQx3137opdJAIf1DS+XisR49Q4bZHyR9rRWZwg1oo6kCSW4ZCIfvqKhMPp4TZf3S7yniEvvUvcf+sfXwMjYtW6+g5iVUEET5G2VDQ6seEdRJCVEMtGO635ZgK0FwNYgPdlLRgg7vABPM3BEj9H/1zDvKsmmiiGc4x4FAVnxkYWIk4+RCniTN4SvLZZIt3OWjMM/yMbOkR9evpmxkZw
 JSAX9rMF
 4Up3HrG6qi2Wb9ftPbbZ3AMox44FQQkWA9CAILYxMmyhPp4GZo/E5w+t3q72jh6pMeIalA4ViJ87UKSuGTOdMavvdiUzl7Ssl/sVSdqh6x8tgkTpTwIgIuWw6Usnr/uwysVc2XDho4Mfn1nTIS1KLdLtWSIIBrGY1CCPVBqQStwEL/JtTKfevLTEiH03gdmonucpnzBxrFyCAQc9RED47lE4B7c4k5QfsVLiozim96F1yEp2kJt6U372aVIQsCLQ+07rWqOTdB3u5EQM51Ju8G3OyOhroANxpsteFQankRs1eLVJmbXoQWncVkLtJyCsFQVeCaNrK9om3lhSy25/VfAqk8NrSdEe8rXHXYIWjRXcoHcyz+4h3+Eaeaxy2pBMuRsKwvHupI7psNYEJifI3FloxnIdXfIDVnBjZXdQUDJQRLKxvz1/ojSJqV8yMQFk1ZUmHj6rxkl1ZVOmFhUl0Ztg5mnL8c8pNOj+QjFTVvjYOKuPmYi+90lzu6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <Honglei1.Huang@amd.com>

Add a new SVM attribute type to indicate whether a memory range is
a special mapped VMA (VM_PFNMAP or VM_MIXEDMAP). This attribute will
be used to support non-contiguous memory mappings in SVM ranges.

The MAPPED attribute allows the driver to distinguish between regular
anonymous memory and pre-mapped device or reserved memory regions,
enabling different handling paths for page pinning and GPU mapping.

Signed-off-by: Honglei Huang <Honglei1.Huang@amd.com>
---
 include/uapi/linux/kfd_ioctl.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index 2040a470ddb4..320a4a0e10bc 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -703,6 +703,7 @@ enum kfd_ioctl_svm_location {
  * @KFD_IOCTL_SVM_ATTR_CLR_FLAGS: bitmask of flags to clear
  * @KFD_IOCTL_SVM_ATTR_GRANULARITY: migration granularity
  *                                  (log2 num pages)
+ * @KFD_IOCTL_SVM_ATTR_MAPPED: indicates whether the range is VM_PFNMAP or VM_MIXEDMAP
  */
 enum kfd_ioctl_svm_attr_type {
 	KFD_IOCTL_SVM_ATTR_PREFERRED_LOC,
@@ -712,7 +713,8 @@ enum kfd_ioctl_svm_attr_type {
 	KFD_IOCTL_SVM_ATTR_NO_ACCESS,
 	KFD_IOCTL_SVM_ATTR_SET_FLAGS,
 	KFD_IOCTL_SVM_ATTR_CLR_FLAGS,
-	KFD_IOCTL_SVM_ATTR_GRANULARITY
+	KFD_IOCTL_SVM_ATTR_GRANULARITY,
+	KFD_IOCTL_SVM_ATTR_MAPPED
 };
 
 /**
-- 
2.34.1


