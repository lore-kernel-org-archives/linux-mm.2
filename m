Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FE4606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0EWDYCWu
Received: by kanga.kvack.org (Postfix)
	id C9F726B05B9; Thu, 19 Nov 2026 02:12:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FDF6B05C3; Thu, 19 Nov 2026 02:12:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C7E6B05B9; Thu, 19 Nov 2026 02:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 853A06B05B9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:12:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0645F1C43E5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:39 +0000 (UTC)
X-FDA: 85451000838.03.B8CC802
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011060.outbound.protection.outlook.com [40.93.194.60])
	by imf07.hostedemail.com (Postfix) with ESMTP id DB4BE40003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0EWDYCWu;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.60 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ti6Q8NwU6rLxuKZmbpETuA7l6PGp3sE+983E4kQfl/g=;
	b=v5sAb7/NENBkKLHGEXgjnV7sXkC/4KOyU03JYyn0TbdLA1lXk/2chhpeU2AoPTqUnULF09
	DL8cyTohR9KHeqC/7umS3h/MBuFVGDOP+MAF9HEVB/g2xHOx0/21jt/7luHGim1MBeEyB8
	ShARRWWtXlnzfGSMrjEG29l6TR6PVyY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0EWDYCWu;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.60 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795072356;
	b=ig2f1PflKyEbApUMlWyImKHl7Il8VkmFaRmMQ3HNw/T/jkH2jZO3AtCdFYyFgNFt3WQGvq
	5IssHlLwc8CP2DKW5PMmbkMMMxSUKpVasdvRMQySzlZpYG9N7L78/x2uJ0AxJQhHLkfnVR
	SL9aneT0LvitiKxOQFWSOPHmLMyLl5U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRa94FUBGRzu5PmNhEyCYs6tRRv7Gk4NmG+m0ag0e9h72dLbLKiDpXvbO91m9qbGXd0wQ5ws1gR96olq2bo/mkKbaWUEdMBnsSGMfJR2wiLZPCRO+DvdMRd1viccYakVjectAHen0CHkRGRws70eHDxWKNI7SUbZx/13WdpueaT+QNj5z1+QLsb9WyaSUsR9iWyDATn0VaePaHnLA4rBtEnxKloyAW+ATbHOILD7G8kyjKHLv0NyrNx4loHD3aQYBpJ8Oh8IIvqTLw79anZOKDHB0QQP0xH8BkDFnh8OwIWEEDm95d+s6L/KDXbFiX5tjM3Rw8GCkxyGGzFTY4dK/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ti6Q8NwU6rLxuKZmbpETuA7l6PGp3sE+983E4kQfl/g=;
 b=Ff7HhaiJzKjKA4EWo82fLvmpkRMFncY8v9KWFIa1buQhRNBLECNeLP9oPvcJ/fBa85/frbc2/UY/i5GOeBIp8U4q+QcWpCJn1zkhINdAwML/DtUlktNtNlp0yK++8guxcMJiwZdiyphglJpft/sYsOX2srC3EGY4OjnECtr/gxi69X6u2TELVPqM7IK+v9/LQgYFPFKZXvdT0tjfhS1CV2z8zYijEWXlZFdukrjFa4Js8j7Nf7QwoiQUTIXTtSrxamtMhLLOs/i47uU0jB2ibYybLDPrVEv3hzftV7cL2E3BziYNgtz1SxD5E+WL37Ycso6vpnO94+vcF2PLImL6zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ti6Q8NwU6rLxuKZmbpETuA7l6PGp3sE+983E4kQfl/g=;
 b=0EWDYCWunYvzIjuhwm1NGznsen2udZKNVTEwdiz61E27JcGBeOwkZufVLF/YUxI1QHMWR/1zTbotXC5DwsIF7uRAWS3jyT28ujUg5+nYhYQUY4I75neFIMr1WsbY1MVC/w6PUbdIQVtqFmdNN+hbS0Fton+M6qsmXTX3b5ics/4=
Received: from SJ2P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::16)
 by DSWPR12MB999129.namprd12.prod.outlook.com (2603:10b6:8:36d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 07:12:29 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:a03:5da::4) by SJ2P220CA0013.outlook.office365.com
 (2603:10b6:a03:5da::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 07:12:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 07:12:29 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 01:12:21 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 19 Nov 2026 07:11:58 +0000
Subject: [PATCH v2 3/8] mm/migrate: factor out folio splitting on
 allocation failure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261119-migrate-refactor-shivank-v2-3-f4535bd0bc52@amd.com>
References: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
In-Reply-To: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, "Byungchul
 Park" <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	"Lorenzo Stoakes" <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Yiannis Nikolakopoulos
	<yiannis@zptcorp.com>, "Bharata B Rao" <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Huan Nguyen <nhuhuan@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Matthew Wilcox" <willy@infradead.org>, Hugh
 Dickins <hughd@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795072323; l=3612;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=hnVcpC/MtHq9UiUQFoSjmi3Q3XV6n8NHdNn2Djo6ei4=;
 b=6sCR2895mdNlhvXOARhcTzdR1O3qwrBJw5Y7Jgwy2Qm53czi/itPSCdJo5qZDTNOLVWgjHGMJ
 ZDD4FbSbdu7CDIlJ5n9WUT96Dp3mGhppzFqKBOfm55umglQoMovtmSZ
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|DSWPR12MB999129:EE_
X-MS-Office365-Filtering-Correlation-Id: a617aeed-2c98-4ad1-d2a7-08df460c7902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|1800799024|23010399003|82310400026|921020|10067099003|11063799006|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261022105027099003|261022075727099003|261026140227099003|261026121527099003|261028144727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TzC+xkA5Adpz3WZnYFaHINOaZLJeUd7zsgM/hx3grrvhCVEgceCBUTncOSUp5iLeyAoKJK9yy89FOFfP/T4285fjPt7SkZPxoMKe41dPPFXPv3F+csOkxXG/iom+lfYAAlqLkGd+3cJgO0V5jE+6PwLxBGFXqF6BIVDaknPnTdKfeKvFsbJHp/ZvMWyroPP8QFVLiJ/LHnragR9kRPCWqLi3gy9aIEj4/I2FXFzomV2V5lEyZ7cCBxrYNnMHI+ojK4v94RoGK8EZCeAC7kHu8z3wK4skat7GKlDre44HTAZ6F9rVZyc2TvwNUibmIt9qzK8zWzacjQ7dpj8o1cotutKbF3m7+AUcpWjFMpRXQVfHAaAFV34ELFzDDwCNJNEnBl6fifaichoeNVQYax0xJpJ29vV7KwoaX0jh8RmeicIMOko9RPnKUBFB0TvR9b6aibkSkmXzQL2oxzTftoLJ6IY0A5rGgncIsID22Af02oVATTr8onQozvebtdssY7RGMhH6EdFEvxAiR8AyZgpyw0j0ZSKt7iuM2mw+5Fd7xYyZACSRW+MLzV2Nvy6jfv+hwTsJr2RKJLFgOieaellACXLvvjDudVjw24MA0eiMYwWYxZxxE5ZKBrF0/H77yADptO5F65odV27EQfCVtjEGB3xDhgHB5/DsazaQDLlMQn4XW6Ehh5OjMertLb/2qI5xvWqgxoBVBq4CqcG7+7earscqx2OnoSaog1aomEHdT74NAbOPUfZtsMh/z6YtRAQi
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261022105027099003)(261022075727099003)(261026140227099003)(261026121527099003)(261028144727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	63qHRl75aWvoLaScCaogIQIcYPhk/w8bKdBlMSz3tRpFI1WF/EyliVLnEh4/sFQp8dOZvjQ/FIhyK7NyHOaPplNqnO8bdF9g3gPys0JNBOiW0okU9pTo7f8mn1K/39rzlZVsSTdG6+YSsu4zT+WbgqUpynxo9EmV/Y9BVLdS0+8WNKaFG2dhmPzK6FYCfMptJwDvlm5SOhQwDcl2NukEQUq43K4XYTIi1iH1P/874SDAbu4jQForY0HUOJItJrLq7PHVM3DtvVCAPeCJPtXxP7ByFGbh+C55FARBCSIUTfsIe0RGVoUrsg3MfNexVpI8RS8e91Zl0ACAmWpYT5fAavoRwn3EiES3f1P8HUMTC+9TKok20EeChxmNJcTN30H2v0FRZW7LoaUBuJj5NIujU4YXm7BT88QqvOacktmCRsjx9g6oYaaNYgufzi9peujR
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:12:29.2316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a617aeed-2c98-4ad1-d2a7-08df460c7902
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR12MB999129
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DB4BE40003
X-Stat-Signature: r4oedmnwoc1pgibt3rbuttwmmuzxq876
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795072355-880089
X-HE-Meta: U2FsdGVkX1+1VGTAVKvYa2eILdr0UbTiiVWMWtjX6ixO3NJfaSZJ6+7X5tpcxbz535GHFGKmyzYtjd12JbsNB7PJBiaRqtfG+uEdRUlPWA/BAe2RL02wwU18rxt+zisleJC/1WsB/AbnXxeo5bj4U++oJ26yicMXWosbms/L2nX446ruwxk4+u8vagVryaPyadkAC/bqTBPVHGELpE0Icjxl98hncxy8dR2Z+xxQmr/WD6L9tEyEj9dZXuHQp6AEJb0+oBuhLIxDZH9ik728FwBJpTHhgQsN66vylCMBje/TUjBSQq7gHC4w1gysZ5MWVZeWVPNzOL7tmk+EYWvZ2aHicw1Cw5Fg0vitLe9IeIGdhj6Y1Bk4T/8FGKLijMJOaFkc+x32GJbectE/Q4bsME4Hc4KqJ+VUQssRU7zVxYBVeD/HCmRD6Ix7YfNp04wrti4q5zezhFyNW60Fyx/EN25CBLBnXIF6eLrw72iQaKr9N4JQTjxLZXZK0U7a77FtlxTvWVGGXWEzvXktZemjToGPyzXMgdiI+LFy6r/p9BFKuG1zFZ2ISg6yJGKwvAlZQSIQdHs98BXY/2KBSxIoRUzX5vtYhUFZ0bZ3hivM4TEjm8MxuYEnkPcAAFxvF8qgypShYybTWzZ40gVrIq/aNEfyXZ3b7Pllu+vdO2w3/REojSLQzOw1ploDpzKpJ2o8hCcVyyu37ANar+WTYhJqmO4LE2yhryVbWqArCCHNC6pcGW1Zx6AEyn0iPZrpgWehfTi9hZyibFyaTiqIXoqRXMSKxtSmqGwQjynk0D5dbHQzARxeps7v+ueGtRTUesIh+2Yje9FWHY2iCjXj6AVxhGP+/5jneSkgf6aO5dNTzVnxrMxLSTpdFzQ9BfbsosFWInh6Z8orWgX5ifcEFbOVbHL5Tb5V7DVcv9ACl4NKfVGgYOd9FzrT0Lq0s/AGsYXN0YIRpZzjipFt0TVlwLf
 heQmqmWX
 XSRxanS3SmZDDR/1RcZiwhytHVLXkAyyK+heQFqTcbe8BIKRNoPnFODI57VyLluSA0nCohaY7jJkzHSwJ3lXOrHzgqEttzBVxXVL838lDNanu50KvuAYKIQzJ1s88nlN9/4zDOwg7d919x5tdw1Od0mMvfo88QbGUgZjah1Bswm8Hj3xIXu+0OHwhWeBLx4XrZtNP0JiSTBre+R/Y+BwvIVGnUq+aZucajC+ANpeLryt4xg5/C79JqNttC3xfoEjL+dQpQ9spM430x3ibu5vpJmekaDFw6FD8BgLxDwi2fCCpQ40XfR1ZTizZZw/9QsUcTln6mwxDj5JMakGFVzrLUrgnKdPQ1hRJgJgk3D9KE22XrSJ9ZEGsRLQdZAtUh+F10C+6clUkF2wgLWYQeGk0JhtSsZZTEDTsIcy8GTWGZaGdbMLzdXItc1TWapwnyayyPjN+PgcdTpje6kj6WU/7/7ZfIMMP6pr3KSye4ivH9MAD3mUoI4ZvoDugprRRcLcmk5T47ARFejKM7XPubAE9pDG1zpSKbQxkwQYD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If destination folio allocation fails, migrate_folios_unmap() may split
a large folio and retry migration with smaller folios. Factor this logic
out into migrate_folio_split_on_alloc_fail() to simplify the allocation
failure path.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 69 +++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 1f4ddd23cea1..e4e3d1683d1e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1847,6 +1847,34 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	}
 }
 
+static int migrate_folio_split_on_alloc_fail(struct folio *folio,
+		struct list_head *split_folios, enum migrate_mode mode,
+		enum migrate_reason reason, struct migrate_pages_stats *stats)
+{
+	bool is_thp = folio_test_pmd_mappable(folio);
+	int rc;
+
+	/* Large folio NUMA faulting doesn't split to retry. */
+	if (!folio_test_large(folio) || reason == MR_NUMA_MISPLACED)
+		return -ENOMEM;
+
+	rc = try_split_folio(folio, split_folios, mode);
+	if (!rc) {
+		stats->nr_thp_split += is_thp;
+		stats->nr_split++;
+		return 0;
+	}
+
+	/*
+	 * Try again to split large folio to mitigate the failure of longterm
+	 * pinning.
+	 */
+	if (reason == MR_LONGTERM_PIN && rc == -EAGAIN)
+		return -EAGAIN;
+
+	return -ENOMEM;
+}
+
 /*
  * Unmap the folios in @from, queuing successfully unmapped sources on
  * @unmap_folios and their destinations on @dst_folios.  Increment @nr_failed
@@ -1868,10 +1896,8 @@ static int migrate_folios_unmap(struct list_head *from,
 	int nr_retry_pages = 0;
 	int pass = 0;
 	bool is_thp = false;
-	bool is_large = false;
 	struct folio *folio, *folio2, *dst = NULL;
-	int rc, nr_pages;
-	bool nosplit = (reason == MR_NUMA_MISPLACED);
+	int rc, split_rc, nr_pages;
 
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
@@ -1879,7 +1905,6 @@ static int migrate_folios_unmap(struct list_head *from,
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
-			is_large = folio_test_large(folio);
 			is_thp = folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
@@ -1976,28 +2001,20 @@ static int migrate_folios_unmap(struct list_head *from,
 				 */
 				*nr_failed += 1;
 				stats->nr_thp_failed += is_thp;
-				/* Large folio NUMA faulting doesn't split to retry. */
-				if (is_large && !nosplit) {
-					int ret = try_split_folio(folio, split_folios, mode);
-
-					if (!ret) {
-						stats->nr_thp_split += is_thp;
-						stats->nr_split++;
-						break;
-					} else if (reason == MR_LONGTERM_PIN &&
-						   ret == -EAGAIN) {
-						/*
-						 * Try again to split large folio to
-						 * mitigate the failure of longterm pinning.
-						 */
-						retry++;
-						thp_retry += is_thp;
-						nr_retry_pages += nr_pages;
-						/* Undo duplicated failure counting. */
-						*nr_failed -= 1;
-						stats->nr_thp_failed -= is_thp;
-						break;
-					}
+
+				split_rc = migrate_folio_split_on_alloc_fail(folio,
+						split_folios, mode, reason, stats);
+				if (!split_rc)
+					break;
+				/* Retry this folio in a later pass. */
+				if (split_rc == -EAGAIN) {
+					retry++;
+					thp_retry += is_thp;
+					nr_retry_pages += nr_pages;
+					/* Undo duplicated failure counting. */
+					*nr_failed -= 1;
+					stats->nr_thp_failed -= is_thp;
+					break;
 				}
 
 				stats->nr_failed_pages += nr_pages + nr_retry_pages;

-- 
2.53.0


