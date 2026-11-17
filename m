Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7884606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LfXOIZBP
Received: by kanga.kvack.org (Postfix)
	id 027776B05B1; Tue, 17 Nov 2026 11:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41C56B05B4; Tue, 17 Nov 2026 11:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58C56B05B5; Tue, 17 Nov 2026 11:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8FDF6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:26:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB833A8048
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:26:45 +0000 (UTC)
X-FDA: 85445139570.27.4618349
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013037.outbound.protection.outlook.com [40.93.201.37])
	by imf16.hostedemail.com (Postfix) with ESMTP id 898F4180007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:26:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LfXOIZBP;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.37 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CRX6/8jSTyoplS7t9Xibi95mJz7CUHjkZMs9HSQC49c=;
	b=ED91OPHLBpwbNFeHIiwVW3K8NkkfNzcieokq7awKzsVBh7Bji3U1dfKy05EVyOjKlPJSZR
	t3aqXS6t5rQiTvZlCvzG2KAyk6p6kOL9HQL9W8aevNveHGQEAhgq/z79rSa6DRkzGQZm/b
	k5iKtgr/vO/PtVON9sgV9ZaBDnPmtzk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LfXOIZBP;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.37 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794932802;
	b=szbJEbhgsV6w1Zd1qS+KrT3US7cJ9FDonWtmFPOenA10aS9VIopwL2xBf0e/inq+9v9mXO
	oTEU1f7HNRQfP9aaHcCvGk2oXbAn3TRS6dcMkusCGWJg9jDPW6Ns9tWh2zyxDeMSfVHZiQ
	FsQpwd+5FB99QptAI2Tby/pLwqTl3bg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=flXfumyxyYwHb8mVZT1aikS/5VnfvPNVk4wN/E7/QFqL6/9k2OdLpHLgE03xhHAIgTDPx6F9itfFXebMDtxbijnADTLQRyeVOZ57A1E6SqTTr6bMlbkyna3Uv+lbk6oTP2QW3enBzH5+MYdwG7inK5wPMWeDN+4b1nKiCXhsAIOPB8EFw7LcYACvc1u0+AlqlAI1z6+Y0motzfQC8mY6l0eweNJHfSPKz5M604IkUDPF5a5AYk8/Pf5ZCyLoJB7PULzuqyrALLCyIvBVpMJYBwUL0v+3qG8t/Xi9MbQSqZKiHI1LmYCbDu4yhemTFElXVpG0C8tAlHQoyG4hXqSSEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRX6/8jSTyoplS7t9Xibi95mJz7CUHjkZMs9HSQC49c=;
 b=W+cnwqg2+XFwW9cWTzmKtM7y3ImhcXm/Ocze8FRflVXWE3jv4DZw+uE9uIp7LqCiQyMKBJ/CPBtyY+m6kccuhIbKu7Hi7WleoFc0m9X8zMheRxN8CSCsKlvMeOW3wN2QYqv7Uw0/5ZsmwICCy5g0t1W1TtADUtwc/mzPk9PyUkxnHzd0T2actm/0Mxd3crAB7rMU0W1VXKL0sfsp7pAIFQTHVBtMZvZwtyw4dXcvcLV5J3mRJZxAwezojDYz5DNeRnH9cUi9umJbsJahdg346BQyDbEJCwYoj5KQhkbcY3AJXQq7rGJ3cj2NH1s9aYy/NDNks6qbxBDquhWtHUPsDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRX6/8jSTyoplS7t9Xibi95mJz7CUHjkZMs9HSQC49c=;
 b=LfXOIZBPB2VjY+LABUxgdlAW2nibPvbdv5GgNmPdXarrnN3Gm1MxwZNzilyXfbzpe7OyqugoZ39/Fi+7Qgr6RKh2SXbXewSP/3cRVBVEKu+2OLjobGBirbTkHvSvjPKUFgDfkzdaoxvcoOSqxmRDTaCHG0ybGMwERJhF9O23SIw=
Received: from BLAP220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::16)
 by SAWPR12MB999165.namprd12.prod.outlook.com (2603:10b6:806:4e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 16:26:38 +0000
Received: from BL6PEPF0006C3DC.namprd02.prod.outlook.com
 (2603:10b6:208:32c:cafe::6d) by BLAP220CA0011.outlook.office365.com
 (2603:10b6:208:32c::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 17
 Nov 2026 16:26:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3DC.mail.protection.outlook.com (10.167.249.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 16:26:38 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 10:26:34 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 17 Nov 2026 16:26:18 +0000
Subject: [PATCH v2] mm/page_ext: remove unused page_ext_iter_get()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQ5AMBAAvyJ7tolW0uIr4lC62IOSLkLE3zWOk
 8nMA0KRSaDJHoh0svAaEug8g2F2YSJknxh0oY1SRY1HOIQ8yr3g5pKma8dy7KtSGTdYayGVW6S
 Rr//adu/7AY6vYXtlAAAA
X-Change-ID: 20261109-unused-sym-page-ext-3fb8316ac777
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Brendan Jackman
	<brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Luiz Capitulino
	<luizcap@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794932794; l=1564;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=r4dP+OQNvDE/PmEeoe3sdWcNribjujq5FuwHUJbJp5k=;
 b=KZp7VbpuV6eJZAAhN4FjPTWZ1r+wdkxvdnfKs6eqj6n68ROSYhjsxAhapDhrsHFiQrI+4vq19
 zPspBABipxvBKc8nL2AZPhFHw4vNCGcZ4xQJocPq/nt1q7RjJB833At
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DC:EE_|SAWPR12MB999165:EE_
X-MS-Office365-Filtering-Correlation-Id: a8ce710c-0555-4996-8cde-08df44c78e49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|7416014|376014|18002099003|261009223027099003|13003099007|921020|11063799006|56012099006|261028144727099003|261021123027099003|261022105027099003|261026140227099003|261022075727099003|261102124527099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	MgUTGCyJcBB02k2wY1NsqvlO85JjyfbveKd1KZgwabYZYBMsGZBZqevnXyczshPv0nkaco4HP8sVVd4B3HCrvAgfjBgvoP9J9vrNcZmi5vjFRSY2wBLRkhGMBz84FxO7RA8htRnXzsMHO8ipdOZj5BvcLwLCTK3CJB7WUivB65TLZ0EqQRxk/BIfglJkw5b4DdbpN1z3+yjyAjU/dW9hAovqcj1ST0Tw+hbnlxrOqPMBMSrUA0jaYi1Rdgxxp5ilOnfVj8fW62kxTOiSZthRqsQHFYu5WElRCqNpt1ZuJIvUbFkbxZogOpcq2mBGReJkTs7qqk0Emadzd5hWpVPXAiccasPXL8VZHuwDacO3yQ2ZUL+yM+PvY9sR40F6yUyMZRga83oMrMjnqh47GP9JYAHIXoHs/eJpMcKClq4nS2u7ppFZtBZpEJpsIf4OjeryY86kojC4Zz3EVzlbDYpR/rQrxx3meOTvxKAU4xkUPRZhBRNhrwJ6sM5CGfvxVHDAZoZhZoYNRuB4rjV5bTgRoOAXzv2bhVZyRTO0UeeGRiVYQ3DVXoYYVMS1nFByPCw5d1gTVDm4UoQxD0cGGQclTVDVTP3rKXp7I8yNmLH5MOvAzZg2BX+tnjlM8BVt95+Cuj6Sz7qPeZN3Wz98WjSO261vcngEssBbm33QrE+VOjiHS8RpC1xNF3dHdOLXUE9V
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(7416014)(376014)(18002099003)(261009223027099003)(13003099007)(921020)(11063799006)(56012099006)(261028144727099003)(261021123027099003)(261022105027099003)(261026140227099003)(261022075727099003)(261102124527099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CmhFSIdpT8dayGpT2AfjmDpd3fALgB+MUhrnlLZMFrFpN3p8FDpZ6haQVYzjeNgww0L/P2ttPpy0yETedzBxnOV+i7sCNvMPT56iVBu77iHghh/0RPN3oHFbxcn6J6FmrBHqKuYPgAezSqyDW1jAgd4GIn8+cZPDj6nTaW/T2DTLW8tfHJ0QfgU5G1xmSdBk06eNMJlT1+FewEnBtwyQbz7oMOWB7N0TRNHU4SJ81cu4e43dCjLoSjccY6TD0/p3OHb8lOr37ta0JomIlqZCvpaXXBfBtDiDqQQv/FJDl8LduiHs5gWr3/BnHsasUyiDSKRn59XMkKYMn9YXPmnW7w8Bp6iSSOykOzC3HGjDEG3EgPQZrN5DsX/ZzXy51kMU/iCl2O1/ic7D1l9BKet5rmxG1vKFgHbM+Vy9Wl3wdmnZpCrjK6E6cX7KoANo9mQE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 16:26:38.5813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ce710c-0555-4996-8cde-08df44c78e49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999165
X-Rspamd-Queue-Id: 898F4180007
X-Rspam-User: 
X-Stat-Signature: 7f3xehn6hbhookr7dhfybrfd3aawrytj
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794932802-333098
X-HE-Meta: U2FsdGVkX18PqEGRVYoet3uwNsvL44ATCk34O90T1yoGnz3laiLdwpKg/KeEC5Je9tge71rjAQU2ZCS023q/xNYiznuJ1xe634+Yexp1UVHzXy9CuDCzJmLa3BtxmAZfGKaMJwZTbBD1VWUbPfNh9oHG9sAYqZ7D26qAKQFOC9yxs/gBwjUBn2yGdYU85Q9sZc2o/SVzzFEPL+lHILFol+v/H3uiL2HbkEgrwFhiu7x3Sb8fkDayUjHa0QxAEcbUpoAirYaZ+cMaJjXhS8XYiNEnag2JklK+NBaMmyip19I5mjKEukwrTDWp0xMuI7KaY8Cm8HcUg4CngWBab66PeqwMCCqhP2EaQ5bWrflVAgaiy/3eyyn7GNSiUnTeARc7EgRi0LMJu3K8KUn60Z6+MQZ5WuvI1CAzD4R7I/Y9YLMeS2NAthS22+ltUy6b0LbB11uhVm3SIL4IpyJOT9Lg2PWfpIHuKs3OxbjxRG7xCmHJIinpRBd6Lmt/UI8Dw8UAF8kxNXQb0ybBCEJ+M63ZMv41EHiSQ94htZahODnZAxSRR77Azmd/4kf0ZSosKQRGzRakfZbVz7G1d+to8Ii5l3WoRQyCMLqN6VFV2OTy8gOO/3P4qUjZXHipllCbc6A2deExl5bQAf4g/fVv82gUhDczPjlzEHFhgvoEcMbEmdplv46fRA27vvDsxJQ7U1dczjaBN5j3n9XVR09n4Lmhxp/QQUaIOCQQtrm8nVxo3AqyaL7KQA6m8uA3lSnH3Xlh1CytZRj3GwEQZ0+rLsAwpZA8xvdVkkXkgoocgXjxNpKzPVdk4C4HM1X015C14AStjq0QddF9Drq22o99E0PooXYBSbig4UG0DP/AJugaIgNJITzLfEIUecK2PmtIod48u2wSXppob340yfVFsuR4r7T89l+gqtTMdBLIDqtsEh2vpuQgD5X14q8S/WjpcnnLaBL7YPamUGQ1oAcFJDA
 /DmG1jjN
 E6AZTxgHXe8TSGtOENZoOlrxr9Y1arQRJVZVcHEE+nuwp27YZQX/DEmc8vsCXKt9Dz8Zx+3ExIOXGuyIOZ9b01W9KteNphw3aPmmixSmrI9UqcroPn2obB26O96HVQPli0v+LrBYhrj8O5eM10YbmSY3uPQSxp/MgtBNmnNCtDck3fw9unWSAq2yUS7JrhPFFDY9u9zC8qWn0jy2OUl8jtgfXjR6HjHgo5D4956MTiLBBBwX7hYZ/uS4vShshUIutawFiiUpIicIxlkcYrlELcLUyqX6g7PDWoXMXMabD6OURvYUFwusXQlIx1dBwNvIC0anJ7wzkodWYbPbD1Pykjxbhy250bDTAQ2HxkxyCzsPBWGL/PtOLVFb9OICDiTe9yDv00rnx2JSu3KS5Vsc/3nR5qBV6KF2l0mqGIsvALCFM5tHdfAMxLuuvijXJ7yaVrgULP7CdlSH3Q+gGKs3VhSe8st8J8j8+4XjKNoDDC+AtxJ3ofbWqxI3+a9jciEmloGLhra0lLIFd7r8M8LQ+rv54wrDFXeOv2TdsC9SwFgih32sPt8o6whP43A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

It was added in commit 9039b9096ea2 ("mm: page_ext: add an iteration API
for page extensions") but has never had a caller.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
I found this with the kunused scripts [1], which I wrote with LLM's
help. The v1 cover letter [2] has more details on the scripts and
how LLM was used.

Changes in v2:
- Split out of v1 [1], as David suggested, and based on
  page_alloc/for-next. No changes to the patch itself.

[1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
[2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com
---
 include/linux/page_ext.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 79c53ec45dfa..52a8b70c525a 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -167,17 +167,6 @@ static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
 	return iter->page_ext;
 }
 
-/**
- * page_ext_iter_get() - Get current page extension
- * @iter: page extension iterator.
- *
- * Return: NULL if no page_ext exists for this iterator.
- */
-static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *iter)
-{
-	return iter->page_ext;
-}
-
 /**
  * for_each_page_ext(): iterate through page_ext objects.
  * @__page: the page we're interested in

---
base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40
change-id: 20261109-unused-sym-page-ext-3fb8316ac777

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


