Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE001C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05766B00B0; Tue, 30 Jun 2026 03:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB3B6B00B2; Tue, 30 Jun 2026 03:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3E16B00B3; Tue, 30 Jun 2026 03:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7066B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:29:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE4C01203D3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:39 +0000 (UTC)
X-FDA: 84935754078.30.8E04EBD
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9076540006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PQWu0mrl;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.44 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782804576;
	b=sMqyTI5CreXq/W4uAbCXEVqLx6fF0IcCRBIZcGUH6MayaoO1DetDiArpEyiAJnA+Tsm36b
	AXMGlv7UQb5rrhyFN64F3O5TuTdRkG7u66zk+NfYuN/qtAkw4ih+qGUcsw7qNYVw7v6iwL
	r5vWpBzfa3wtjAhHJhpTkx5C13r1leM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIHzBds/7rkPGaqG9Crad0Mqh7FjjnjzqNE9NlBsHz8=;
	b=YlasjtXS8WWgudoY0/tsGVoeUMob7Y89Y4IfwbSMx4JZ3tlUOkRPhAq1iBEmlY0Fxv0jKO
	XR3yvcGfSFum6Wq5MaP6AYEq98OhrkttrZknYRmB6z95WXhlaiAvzrfUSMCTp5nWSprRHU
	pi4/u/29+XD/JZ5IgVcb74/EtwqqhGQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PQWu0mrl;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.44 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LJNvn5RWGjDDy4ZfupMr1MQ4Ltida+v8g82FZWGAOWM3hlI531CJNbDCOZkQXXw/HpAmVpDPj5/UYlJl2DWkjKsELj2fIosvyOM6pODS++1RqRyn4AeE9NbA9eFE2hVDJfkwQHMJ7hr0DuHOR7LL/dQRpN/2iy8eCX35c8a5BmQ1Mfc8SzlKSZ5GJEJAuMwy906JMykGMwvLgQWyOV26HYPNCnDXWRPS26tq+CjcmAjsFvC9RACo/YbYfdbBIeypIf8boqDX09OJt9mAIJpv8bfyWTrvjUzU2mPKrRnU+R3gEq8dvfBnd/ceWdvXAEZN5fLq9/qOLWuiBG+ugKprrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIHzBds/7rkPGaqG9Crad0Mqh7FjjnjzqNE9NlBsHz8=;
 b=PgQ5Zg4ds27U7vCANtiifqbmJS0kGllawpCdKf38U+Kkz5bCaEpzPgrVTLGG66wGs8+9ELrWoQN6ktQSqhpycJrZxTPWx9sfSFbr5rwameJG6pdHAKLOC0hrvWFimg21FvIAv7020j1XinYsF02R+Av98/jFIiM0ipJ8UjI7QzXBE/BU0yaGJgj+rKpXgQ+4by3FynNB+cRqf5ElBfDwgTwgAjIYOCv2YLJlouLf0TUON4DLJc4Z9eXYWYFCSzLGKpgsoSiuA3yep5hJpVvIwFVigeIihwcrXu7eeUhpyow336iMIgpMsimt6WfblJWqoOV6KeHlWVk6a/Heg/cjQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIHzBds/7rkPGaqG9Crad0Mqh7FjjnjzqNE9NlBsHz8=;
 b=PQWu0mrlfTaaI7cMDs9AnH6GIDTVjwOGvuOfQ+RyIp2HaIXTep+YlJaU8JQ9jYPD9B4kLe4lnrGw1qnGAvf9cl9aKGkjK0LzVuS2ylPGYPNQXIJ8yJOApt5ILdJOXQg1TkNc2lKnDge0wbsKnDYPkOkvca1z6XbDnN4GNpiFttM=
Received: from MN2PR15CA0044.namprd15.prod.outlook.com (2603:10b6:208:237::13)
 by LV2PR12MB5823.namprd12.prod.outlook.com (2603:10b6:408:178::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 07:29:29 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:237:cafe::32) by MN2PR15CA0044.outlook.office365.com
 (2603:10b6:208:237::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Tue,
 30 Jun 2026 07:29:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 07:29:28 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 02:29:18 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 30 Jun 2026 07:28:39 +0000
Subject: [PATCH RFC v6 3/5] mm/migrate: add copy offload registration
 infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260630-shivank-batch-migrate-offload-v6-3-da95d7e8b8a2@amd.com>
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
In-Reply-To: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Teja Vojjala <tejavojjala@google.com>, Pravin Tamkhane
	<pravintamkhane@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Matthew Wilcox <willy@infradead.org>, Davidlohr Bueso
	<dave@stgolabs.net>, Vinod Koul <vkoul@kernel.org>, Bharata B Rao
	<bharata@amd.com>, SeongJae Park <sj@kernel.org>, David Rientjes
	<rientjes@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>, Dave Hansen <dave.hansen@intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>, Shakeel Butt
	<shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Fan Ni
	<nifan.cxl@gmail.com>, Jonathan Cameron <jic23@kernel.org>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, Nathan Lynch <nathan.lynch@amd.com>, Frank Li
	<Frank.li@nxp.com>, Dan Williams <djbw@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>, Mike Day
	<michael.day@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804526; l=14859;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=1+75rFp8P4TNy5kmh5orGDwqX1QofIKYgT85I2xSHkg=;
 b=awhGcIZCOYJgIr1vcOvaw0iZxCULyrYwAi0ulLd+vCxS5ufRydOFahzSMzThmfylBV/cyxr5b
 mxbU7oiYI8uBA4aUFtBTOldIJU0JSwggKh5Qjcp7aLaoPNDRnnsUu3J
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|LV2PR12MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: bfcf3357-b400-40d3-6557-08ded67951fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|7416014|376014|82310400026|1800799024|921020|18002099003|22082099003|11063799006|5023799004|56012099006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	S4tuANOgDtB6l3mKOeVmHvhtqGwMltCYoHLTa2ooOjVxhMdWVKdFroS7q1gxGUjFr74FltZtW//6oGhUldomvmuU3qkrrOil7Ke6F3FUcHYh9H2e9xlrR6/aBuF3G6clspEk0tMrOwQedC+bR8hP84MSbx4CJVIwNyPanE3g1jWze40bFCdKif0v1e43BoxHv2zSjd7/ILNJ9S/k8zxCcFZl9xBp7sehH4echADIxJP9icrn8dYyNab7F7naHTJ9tBxbBqItYg+UoO88PdotCteYM9Hn37dXfdYgSAkZ/1yszwfIz9AZYVpIWzZ9eCLmELFRDFnPVYE/QlqrnvHL1KW2KxY8aT4Kem/U/pkmzMexyfoOqXGXELDxYI7pusngM6IFcIMuysjDSJgohQnCCExzSfGJjWgDcfQHWDR7ScxT+gpq1kWaVjaiURELzUogmfW/JIG+Ya/NmlxfcD6cvDihrqr0p9GX7cH51jmxiCR+MfJ3V4iPcXnTtlL5dgidfPi48JlttFy2p5i2zgfwOPZhdaGEGE50TZgXNIcCU0WTPzTa63qEdv39k3gz+YBGjS1635fnfyXmMCo/2cJCL3Uz7tCac3IEyi49H+x5YB0ady6DC6HRZsbWpLNRBDeZxa9T9Sb0DX3Tm/Agmn+A3NvVOGwDgH/bkBzlECZJ/ojLx31gGD814mbdh27fIvdBsE7e3k0/y6ReUb7hjhbBdem3jYPa4PnEicLcgiZh4ZJr9fGhjFvz1GMbxlPRuLxX
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(7416014)(376014)(82310400026)(1800799024)(921020)(18002099003)(22082099003)(11063799006)(5023799004)(56012099006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aeplwpce71+WEL6DfVaTfQz2jMFirDQ5+9B9n2nFaa8HDnCEHzH4G/oCFVMax6e/tYoRdzu8266oQehOs/MLWW3oQCqo9CppKLsoY263b2aMOjYfRcfScCPFZlx21XOTjaMnQ5m9e7EbirViqUpgl2tdgbzEgg/FqobtW7k0wGTnfeDXCxwFzHsA7+vLIy2Ld5J73NskbZjKJoZB1XI8Ig28irDRYbJrxQ9dDrDI6aN0+92kjBplm3TgAItNmfKN062FXyzREehebzWm/jczo4Ar7dDDlCwJXD3SNeXpH9rHk4cyWPTWXPVIlWtQqmUfUfDjjthGPqDFJuJDrkPFeeoLbhrziHMPidErwRN8sPjhvV8zgYC90d44yqvukAi0Dri/hkTOU24zs11uCS3sf/CFmluvbIv2qE6TDOnxhm+mcswHBEp/18xTCeI1lYyf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 07:29:28.7644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfcf3357-b400-40d3-6557-08ded67951fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5823
X-Rspamd-Queue-Id: 9076540006
X-Stat-Signature: tmzxh6xwzb1qy4dr6jnrmwowzsrmt7yi
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782804576-680446
X-HE-Meta: U2FsdGVkX1/Q9DpNDFLuGEFP2PzbNde73jouPzjEHXjCkq0tgZEecBpqbX/7aY97iUWE5eT2BLclKkIhx6ECPa+Lf8lDGsGuNTTAOeLKu73KoPpq4uLZ18Y97MZtVehS5+Gau4KQrUG+YBnRGUIun7VogpBtT1HbfOqw4x0KLhyUwYRZ+CXZyxrXHPVB4tXWAGdqi0QyiUccFvEPM0xJ8+QEtH/6jqqapdrYZUWrbr1qUO3Fm4FrXCelX7P/iEEPd+JEyKbo1M7/QCXwJFzbeKqTHkvP4huOTdF8r349MhKEQhMNaOdr140L7FXpT+bzcG5NdQAafvIaKW7xzwWqaz5xqezl1jQL+j0R6tWbn5gpIwI17G4BqOU6faMptJ3OWtIvHZbptR9btldZm/NWQaVda8eEakmqXPq3Zm/d2KwQg+TT6wjFXNpbFeuVExrlZNqDDIgvQmy6awOIqE5OiYnaNLM9ejZ76MqIbvTK352kZkDrw0YlTf5cJptY6E1uEj5UDYNUeRUXo/Dx10eJtHEXyLoLjibUtHOrNyN0uBB3YTN4biI0jYx2RH4NRm/YWTvsRMsYoXmzvnL5TqSWlD67AYp4FLMiq+uK9YjVcvF3Rx7oX4c+vs5ZkQxs30pCYnLgoOj46FafJ1o9fiwzt8zFh9SLBAKHBDYP0EXRLxpGbG8MLJDP8DdMbf+sYfpRdFJS8bFUgr+ug8YJZvGqpadOhE8oc0KlRXjbHrcO4O/5l/UZvLjSk/NwsuNF3sbc+VJlaxItn+QKhfZgmzPeYw2cWaMb0k6KfgtId371Czv2m5Pm5es/uOSDT1x/KEWmCeqWYOAl0HAdlT+3fTncz9qgOj2AYn/iVx6hLceKUv9GPLkvPEb8J/O5bJCcz3tsJf+Bm+gc/CEWukZIzuOBwwau12bzMpvD4F0yIrcQ5/nmGPC2PTX6rJL4P7oMAvioxWJ2jDLYA53itshfflu
 prXYGM2+
 PNCNtZeeHqqzh91L5FFixspCGMrBD7WAQGVS+ELkfns4EQn4w7hoI6Tmls4HiLm8FTXOfpqC5skXqUbMg3DjHow8ncwjEbwG4nqJy4DvE/Avy79I9IaSdM1Zdt2HelQV7a9OsAJ+Vt6fMdpUlUQ6hMiJvnj6rD5uZ68LBUM5MfPuv3MUFJiDq6DYh9k4kORrCkKfDz+rMl4acSHwm1clrRBtgpWgi1VkA/OH1P66iyJXp8sbz7ztznAA+3AJ/6BpMvZ/wqeZhi8tis+/2QXi3ud2bc/aN00BBbznDib+1nibS/QRLg0mEfM/SDOJmkTYNyZ6oI72AoF3vxxDXIJhzIGXBIYY3sri35DqqwNge5iPEN+JoZFh+grwaAIIvWqrhgDPQzLdMS5C4S/6kvqNMmBwr6rzuEZgapl1MhZDLhz3b2YfIOuUMl3h4lah6vMmBDOI4u2vPW+dLWNvMtZPxEpN+5RDthiAr1/3AarpzqvpmSI/EwMM9fO9iZBu8tMZ4NwLtS+CvMeEatsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a registration interface that lets a single offload provider
(DMA, multi-threaded CPU copy, etc) take over the batch folio copy
performed by migrate_pages_batch().

The provider fills in a struct migrator with an offload_copy()
callback and calls migrate_offload_register(), passing the set of
migration reasons it wants to handle. Registration updates the
migrate_offload_batch_copy_fn() static_call and enables the
migrate_offload_enabled static branch. migrate_offload_unregister()
reverts both.

The active_reason_mask is the single source of truth for which migration
reasons are eligible for batched copy and offload. This is checked with
the migrate_should_offload(). The active reason mask can be changed at
runtime via migrate_offload_set_reason_mask(). Also, add
migrate_offload_reason_mask_parse() and
migrate_offload_reason_mask_format() so a provider can expose its reason
mask using migrate_reason_names[] (e.g. "compaction,demotion", "all",
"none").

Only one migrator can be active at a time. A second registration
gets -EBUSY, and only the active migrator can unregister itself.
The static_call dispatch is protected by SRCU so that the
synchronize_srcu() in unregister waits for all in-flight copy before
the module reference is dropped.

Callbacks must set FOLIO_CONTENT_COPIED on each successfully copied
dst folio so __migrate_folio() skips the per-folio copy; folios
without the marker fall back to CPU copy in the move phase.

Co-developed-by: Mike Day <michael.day@amd.com>
Signed-off-by: Mike Day <michael.day@amd.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 MAINTAINERS                          |   2 +
 include/linux/migrate_copy_offload.h |  69 ++++++++++
 mm/Kconfig                           |   6 +
 mm/Makefile                          |   1 +
 mm/migrate.c                         |   9 +-
 mm/migrate_copy_offload.c            | 249 +++++++++++++++++++++++++++++++++++
 6 files changed, 329 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 762355b62d54..fa32b447f3e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17065,9 +17065,11 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
 F:	include/linux/migrate.h
+F:	include/linux/migrate_copy_offload.h
 F:	include/linux/migrate_mode.h
 F:	mm/mempolicy.c
 F:	mm/migrate.c
+F:	mm/migrate_copy_offload.c
 F:	mm/migrate_device.c
 
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
diff --git a/include/linux/migrate_copy_offload.h b/include/linux/migrate_copy_offload.h
new file mode 100644
index 000000000000..97941ebd4979
--- /dev/null
+++ b/include/linux/migrate_copy_offload.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MIGRATE_COPY_OFFLOAD_H
+#define _LINUX_MIGRATE_COPY_OFFLOAD_H
+
+#include <linux/bits.h>
+#include <linux/errno.h>
+#include <linux/migrate_mode.h>
+
+struct list_head;
+struct module;
+
+#define MIGRATOR_NAME_LEN 32
+
+/*
+ * Reasons that may ever be offloaded. A driver's mask is clamped to this.
+ * Allow all reasons by default.
+ */
+#define MIGRATE_OFFLOAD_REASONS_ALLOWED		(BIT(MR_TYPES) - 1)
+
+/**
+ * struct migrator - batch-copy provider for page migration.
+ * @name: name of the provider.
+ * @offload_copy: copy @folio_cnt folios from @src_list to @dst_list.
+ *
+ *	The migrator may inspect @folio_cnt to decide whether the batch
+ *	is worth offloading, e.g. skip when the batch is too small to
+ *	amortize setup cost.
+ *	The callback must set FOLIO_CONTENT_COPIED in dst->migrate_info
+ *	for each successfully copied destination folio.
+ *	Folios without this marker are copied via per-folio CPU copy in
+ *	the move phase.
+ *
+ * @owner: module providing the migrator. NULL for built-in (=y) drivers.
+ */
+struct migrator {
+	char name[MIGRATOR_NAME_LEN];
+	int (*offload_copy)(struct list_head *dst_list, struct list_head *src_list,
+			unsigned int folio_cnt);
+	struct module *owner;
+};
+
+#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
+int migrate_offload_register(const struct migrator *m, unsigned long reason_mask);
+int migrate_offload_unregister(const struct migrator *m);
+int migrate_offload_set_reason_mask(const struct migrator *m, unsigned long mask);
+int migrate_offload_reason_mask_parse(const char *buf, unsigned long *maskp);
+int migrate_offload_reason_mask_format(char *buf, unsigned long mask);
+bool migrate_should_offload(int reason);
+int migrate_offload_batch_copy(struct list_head *dst_batch,
+		struct list_head *src_batch, unsigned int nr_batch);
+#else
+static inline int migrate_offload_register(const struct migrator *m,
+		unsigned long reason_mask) { return -EOPNOTSUPP; }
+static inline int migrate_offload_unregister(const struct migrator *m) { return -EOPNOTSUPP; }
+static inline int migrate_offload_set_reason_mask(const struct migrator *m,
+		unsigned long mask) { return -EOPNOTSUPP; }
+static inline int migrate_offload_reason_mask_parse(const char *buf,
+		unsigned long *maskp) { return -EOPNOTSUPP; }
+static inline int migrate_offload_reason_mask_format(char *buf,
+		unsigned long mask) { return -EOPNOTSUPP; }
+static inline bool migrate_should_offload(int reason) { return false; }
+static inline int migrate_offload_batch_copy(struct list_head *dst_batch,
+		struct list_head *src_batch, unsigned int nr_batch)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#endif /* _LINUX_MIGRATE_COPY_OFFLOAD_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..c65639bae268 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -700,6 +700,12 @@ config MIGRATION
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
 
+# Page-migration batch-copy offload infrastructure.
+# Selected by migrator drivers (e.g. CONFIG_DCBM_DMA).
+config MIGRATION_COPY_OFFLOAD
+	bool
+	depends on MIGRATION && 64BIT
+
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..256fb532b672 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
+obj-$(CONFIG_MIGRATION_COPY_OFFLOAD) += migrate_copy_offload.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
diff --git a/mm/migrate.c b/mm/migrate.c
index 41b732e78a67..4fed3110ca0a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -43,6 +43,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
+#include <linux/migrate_copy_offload.h>
 
 #include <asm/tlbflush.h>
 
@@ -51,12 +52,6 @@
 #include "internal.h"
 #include "swap.h"
 
-/* For now, never offload. Wired up in later patch. */
-static bool migrate_should_offload(int reason)
-{
-	return false;
-}
-
 static const struct movable_operations *offline_movable_ops;
 static const struct movable_operations *zsmalloc_movable_ops;
 
@@ -2050,7 +2045,7 @@ static int migrate_pages_batch(struct list_head *from,
 
 	/* Batch-copy eligible folios before the move phase */
 	if (!list_empty(&unmap_batch))
-		migrate_folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
+		migrate_offload_batch_copy(&dst_batch, &unmap_batch, nr_batch);
 
 	retry = 1;
 	for (pass = 0; pass < nr_pass && retry; pass++) {
diff --git a/mm/migrate_copy_offload.c b/mm/migrate_copy_offload.c
new file mode 100644
index 000000000000..335db8e80556
--- /dev/null
+++ b/mm/migrate_copy_offload.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bitops.h>
+#include <linux/jump_label.h>
+#include <linux/kstrtox.h>
+#include <linux/migrate.h>
+#include <linux/migrate_copy_offload.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/srcu.h>
+#include <linux/static_call.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+
+DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
+DEFINE_SRCU(migrate_offload_srcu);
+DEFINE_STATIC_CALL(migrate_offload_batch_copy_fn, migrate_folios_mc_copy);
+
+static DEFINE_MUTEX(migrator_mutex);
+static const struct migrator *active_migrator;
+
+/*
+ * The active migrator's reason mask. This is the single source of truth
+ * for which reasons are offloaded.
+ */
+static unsigned long active_reason_mask;
+
+bool migrate_should_offload(int reason)
+{
+	if (!static_branch_unlikely(&migrate_offload_enabled))
+		return false;
+
+	return READ_ONCE(active_reason_mask) & BIT(reason);
+}
+
+/**
+ * migrate_offload_reason_mask_parse - parse migration reason mask.
+ * @buf: input string, either a number (hex/decimal, e.g. "0x101") or a
+ *	comma-separated list of reason names (see migrate_reason_names[]),
+ *	e.g. "compaction,demotion". The tokens "all" and "none" select
+ *	every or no reason.
+ * @maskp: parsed mask, clamped to MIGRATE_OFFLOAD_REASONS_ALLOWED.
+ *
+ * Return: 0 on success, -EINVAL on an unknown name, -ENOMEM on OOM.
+ */
+int migrate_offload_reason_mask_parse(const char *buf, unsigned long *maskp)
+{
+	unsigned long mask;
+	char *copy, *p, *tok;
+	int ret = 0;
+
+	/* A plain number is treated as a raw mask. */
+	if (!kstrtoul(buf, 0, &mask))
+		goto done;
+
+	copy = kstrdup(buf, GFP_KERNEL);
+	if (!copy)
+		return -ENOMEM;
+	mask = 0;
+	p = strim(copy);
+
+	while ((tok = strsep(&p, ",")) != NULL) {
+		int i;
+
+		tok = strim(tok);
+		if (!*tok)
+			continue;
+		if (!strcmp(tok, "none")) {
+			mask = 0;
+			continue;
+		}
+		if (!strcmp(tok, "all")) {
+			mask = MIGRATE_OFFLOAD_REASONS_ALLOWED;
+			continue;
+		}
+		i = match_string(migrate_reason_names, MR_TYPES, tok);
+		if (i < 0) {
+			ret = -EINVAL;
+			break;
+		}
+		mask |= BIT(i);
+	}
+	kfree(copy);
+	if (ret)
+		return ret;
+done:
+	*maskp = mask & MIGRATE_OFFLOAD_REASONS_ALLOWED;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_reason_mask_parse);
+
+/**
+ * migrate_offload_reason_mask_format - render a reason mask as names.
+ * @buf: output buffer from kernel_param_ops get.
+ * @mask: reason mask to render.
+ *
+ * Emits a comma-separated list of reason names, or "none".
+ *
+ * Return: number of bytes written to @buf.
+ */
+int migrate_offload_reason_mask_format(char *buf, unsigned long mask)
+{
+	int len = 0, i;
+
+	for_each_set_bit(i, &mask, MR_TYPES)
+		len += sysfs_emit_at(buf, len, "%s%s",
+				     len ? "," : "", migrate_reason_names[i]);
+	if (!len)
+		return sysfs_emit(buf, "none\n");
+
+	len += sysfs_emit_at(buf, len, "\n");
+	return len;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_reason_mask_format);
+
+/*
+ * Hand the batch to the registered migrator. The migrator may decline
+ * (typically based on batch size), in which case the move phase falls
+ * back to per-folio CPU copy.
+ */
+int migrate_offload_batch_copy(struct list_head *dst_batch,
+		struct list_head *src_batch, unsigned int nr_batch)
+{
+	int idx, rc;
+
+	idx = srcu_read_lock(&migrate_offload_srcu);
+	rc = static_call(migrate_offload_batch_copy_fn)(dst_batch, src_batch, nr_batch);
+	srcu_read_unlock(&migrate_offload_srcu, idx);
+	return rc;
+}
+
+/**
+ * migrate_offload_set_reason_mask - update the active migrator's reason mask.
+ * @m: migrator (must be the currently active one).
+ * @mask: new reason mask.
+ *
+ * Return: 0 on success, -EINVAL if @m is NULL or not the active migrator.
+ */
+int migrate_offload_set_reason_mask(const struct migrator *m, unsigned long mask)
+{
+	if (!m)
+		return -EINVAL;
+
+	mask &= MIGRATE_OFFLOAD_REASONS_ALLOWED;
+
+	mutex_lock(&migrator_mutex);
+	if (active_migrator != m) {
+		mutex_unlock(&migrator_mutex);
+		return -EINVAL;
+	}
+	WRITE_ONCE(active_reason_mask, mask);
+	mutex_unlock(&migrator_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_set_reason_mask);
+
+/**
+ * migrate_offload_register - register a batch-copy provider for page migration.
+ * @m: migrator to install.
+ * @reason_mask: initial set of BIT(MR_*) reasons to offload, can be changed
+ *	later via migrate_offload_set_reason_mask().
+ *
+ * Only one provider can be active at a time, returns -EBUSY if another migrator
+ * is already registered.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int migrate_offload_register(const struct migrator *m, unsigned long reason_mask)
+{
+	unsigned long mask;
+	int ret = 0;
+
+	if (!m || !m->offload_copy)
+		return -EINVAL;
+
+	mask = reason_mask & MIGRATE_OFFLOAD_REASONS_ALLOWED;
+
+	mutex_lock(&migrator_mutex);
+	if (active_migrator) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/* @owner is NULL for built-in (=y) drivers; nothing to ref. */
+	if (m->owner && !try_module_get(m->owner)) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	WRITE_ONCE(active_reason_mask, mask);
+	static_call_update(migrate_offload_batch_copy_fn, m->offload_copy);
+	active_migrator = m;
+	static_branch_enable(&migrate_offload_enabled);
+
+unlock:
+	mutex_unlock(&migrator_mutex);
+
+	if (ret)
+		pr_err("migrate_offload: %s: failed to register (%d)\n", m->name, ret);
+	else
+		pr_info("migrate_offload: enabled by %s (reason_mask=0x%lx)\n",
+			m->name, mask);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_register);
+
+/**
+ * migrate_offload_unregister - unregister the active batch-copy provider.
+ * @m: migrator to remove (must be the currently active one).
+ *
+ * Reverts static_call targets and waits for SRCU grace period so that
+ * no in-flight migration is still calling the driver functions before
+ * releasing the module.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int migrate_offload_unregister(const struct migrator *m)
+{
+	struct module *owner;
+
+	if (!m)
+		return -EINVAL;
+
+	mutex_lock(&migrator_mutex);
+	if (active_migrator != m) {
+		mutex_unlock(&migrator_mutex);
+		return -EINVAL;
+	}
+
+	/*
+	 * Disable the static branch first so new migrate_pages_batch() calls
+	 * cannot enter the batch path.
+	 */
+	static_branch_disable(&migrate_offload_enabled);
+	WRITE_ONCE(active_reason_mask, 0);
+	static_call_update(migrate_offload_batch_copy_fn, migrate_folios_mc_copy);
+	owner = active_migrator->owner;
+	active_migrator = NULL;
+	mutex_unlock(&migrator_mutex);
+
+	/* Wait for all in-flight callers to finish before module_put(). */
+	synchronize_srcu(&migrate_offload_srcu);
+	if (owner)
+		module_put(owner);
+
+	pr_info("migrate_offload: disabled by %s\n", m->name);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_unregister);

-- 
2.43.0


