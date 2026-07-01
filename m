Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD91C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62A0E6B00AC; Wed,  1 Jul 2026 01:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAA56B00AD; Wed,  1 Jul 2026 01:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DEB6B00AE; Wed,  1 Jul 2026 01:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19DD46B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:18:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99425140224
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:18:07 +0000 (UTC)
X-FDA: 84939051414.12.B0CA2A3
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010057.outbound.protection.outlook.com [52.101.201.57])
	by imf06.hostedemail.com (Postfix) with ESMTP id 683AB180003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:18:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=w39CAdLc;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.57 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782883084;
	b=FqS746gtsdryrlxImQkhGFh8YLVIvRhgIeEGW63qBGWgSYE6R1zLSJ4EV/VOmdZOeiJdF3
	HaUH21+qQv0hs27p4buz3HBgfSc4+ZeuRf7q3eFSJ3lsqYoDX7hmt2H9mJjbBqDgEut/jX
	7JNKF36YJLypIvUObgvMNcpBVohGF8E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782883084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwgZVydpBqnQ9RsW8z2ja6i5+awkijiRTjXEgaTtbuI=;
	b=SFq+/V2ldBU6RpqNCyEEw4tf9bcV+VmvnbExO+ZQXFIcye/M0OZBl/qrhkJOnHsvSnnwJy
	enUhf7uLjrMKKw+/uG32KANPcJOWUyx0CKnxwgqxHeh0aNz4vHE5HkN8Fly/09jlr1a2YP
	LziO2l1E15P5nWSd7qWmwETVkmREEGg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=w39CAdLc;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.57 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O75I3jESC97szLOoOybPH+ANi8ezUhqUf+bjDsnlGHv1+SRZlxZdE0bDIH4NF0A5tD7VhiGYwv9QyNeCKxKnj9VQfv2purYs8d+XDMv/vKKXvuGo7ROmRu9BBlJKgWLfzqMFmBGRHuN3Qsw1M8DqfDBYDUQ1PBVsMllIDqk6UjmndoQbxK6EopYTmVP5M1UDR+dzuowUcotaTcxVe4/0d+GDjA8Be7hAVkFGWX+y77UDKf13HMfZxoFi+CUIQ+kR04fc3/0GaWjuEkr9KiP7VIrRk92VW1tpQX8bL/efO2co+azCRUzhMvpHbRDP16p796mWM5jJqzw3fdAt8xr6dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwgZVydpBqnQ9RsW8z2ja6i5+awkijiRTjXEgaTtbuI=;
 b=tvPVfhhq4xryrSFlc1pA+QdIH3SSpyQ5sCgIWQsdfy/leiEIknRYPeyDL6yfOnw8TbBRPGBazV/EhfNUEicRzg2/QHjlRZ2SZrcDHUgSmaI+y0qzgWH4LGfOITGHKL0+435K/sCUyQO+CVUE/xDVn9hOyNTgSBM0CwDqD9nqNdaLMuXqU2eEctWsLKxLSv1fws3QxNY9en3NxvQkAWXDmtK0U/gX6Y2kN5DKiEq0rYUVfElZihpJAXc79ioo5PTnihFm7avtmpnbrDheaLYiXVl0Hp55lEzwARfC4ayhHa5B41HU1zEH9JgJPO1n0Wqb5o1cswSOmu9mssplbh8XaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwgZVydpBqnQ9RsW8z2ja6i5+awkijiRTjXEgaTtbuI=;
 b=w39CAdLcxOPVn2BBn7sHGdfCmgHuYP9GRwOPIFsciL6ButpQQvEKPLhmKNdECcSes3ReENJ8M3okzKGV+Kjquge1/6UYKF8BOi3n1oZaupjiHKQKlawENtGMylvWsuLFJPt0Dl1mci4XYFNf0kTLp4YR1Di+hTbEhlOqo6wYfDY=
Received: from BL0PR05CA0029.namprd05.prod.outlook.com (2603:10b6:208:91::39)
 by PH0PR12MB999087.namprd12.prod.outlook.com (2603:10b6:510:38f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Wed, 1 Jul
 2026 05:18:00 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:91:cafe::43) by BL0PR05CA0029.outlook.office365.com
 (2603:10b6:208:91::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Wed, 1
 Jul 2026 05:18:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 1 Jul 2026 05:18:00 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 1 Jul
 2026 00:17:55 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 1 Jul 2026 05:17:22 +0000
Subject: [PATCH v2 3/3] mm/migrate: use migrate_info field instead of
 private
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260701-migrate-cleanups-prep-v2-3-d9e8f17130b1@amd.com>
References: <20260701-migrate-cleanups-prep-v2-0-d9e8f17130b1@amd.com>
In-Reply-To: <20260701-migrate-cleanups-prep-v2-0-d9e8f17130b1@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>, Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782883059; l=2633;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=1esM561UZzenr2kNIbDUUKxF8Ahuv7wmw08f+nnKnjg=;
 b=skd/T6VtebbL/7NPFd3ymIqUDBpOWYRRtdTVtgNOkNdLaSggth1Rk5F/ezvUc4bLBE3qCI9DD
 a0ahk3KpNC5CyplQKIzvtsQ0nsuU+M3ZsZfjnlaNH1DMiBIH+BfIJ6P
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|PH0PR12MB999087:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b11487b-a96b-4777-de71-08ded7301e6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|23010399003|1800799024|56012099006|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	v6CoyVyqBNYDKLR6JpEV0YZuvx4jWgdX/zW+LfxdO3OkcMklKWJwwefoRZ/T7LC6r7N/8pRnOhUVqT+1sy3ZL/97EkGuLeFqWRzOofUNR4dc3O6F2/COmET8WE4cERoGZklOendIYaCnmX5CJhLamwLeoBKMSV0JcbRJMON2r/mXc8r56Yc3wPZO0m6GtWigZ8ZhPG9zpfhsKMWjw3b4QIOEUpEyr1ZCENU56CjZnzI1BHweKOTPPDheuQx9BXNiK9oyL3rnnFyKWlrfNsBMPx6O+CnEjk4B76zGJY6a7HZhppHBTTwTRl7Gyy4CQnokZg3OhD1iSL6nxUM/nAPS2kqFpe/IdzgeAwbKfaFCur8oHqVPvKwAeyYs8mZFNPAerL4Xt7iRtRceosY8ue23x/oLNpV/P2X6T53L3kqdtqZ24AZRRpxQMp622iOv4cYoKXZ+cTK0qRy7RflLsqTX5hE0FNgRI+i/i/H4yG3RpYXleK/NgbGlJ8sm75ruR9CY7gKSoNFv5ddjoEktV+KvywoAi4eX3jE1ue4VslqV2ektYJqeaUE1TLPMnDxiTPQi6+MmPhr7486UKY1CIR9YGkAovkP+Nq1D/bQRvThyi37ZCK/VB7MtXAHelMA8YZpVT9JQKKm88D5DucLunDj5kNbUfGo7hQPnDooTRX8QqwfCK0zULN3ZON6ZpWmz1T7JYXlncHy5gBxI3LLiN0g8yuV6V3aFLuzq/0XFCcV4jg8H1qsCT7x/sRscPQv5273r
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(23010399003)(1800799024)(56012099006)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UeTXXN07cAjXzE6v5k2cWPyFbxzjrTG0MklaEDDKOiE52jU86HsKHawBlfccJND+iahFls6mfDf5McNG/YQfXhmO+ei6iLndFlZwae+y+HuKxg76FWoIS4h7bEFRuK6ynBHwE/d1xddLyEnQm796/JHU+qjU9P2Ftj1lHKdSl9B/71XUkI6KwBMhIEe0xXYKqKAyV72rCOqCF1qrA2I9o88dpTukemSBBblecLmCnvmzHpDVgYfPrB81NjsqFxDM7LVcNoal5B+4XQeBlCuJrOrTrf7xXJOHTmmUwrKJtNQzsZ+SPLSAAYtEGm4lMLoSbW/voZmghAqYm+HOmUpwS6NcOko4EllzmMJu9ssu6MEK7lle0RzvuG3RsCw9rnNLNWoHkyxhnAxFYjywNSHfOnWSnXz5Rz3dxX4arjWyY36IH7PDuYkt+NG7GaQJyvWp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 05:18:00.1626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b11487b-a96b-4777-de71-08ded7301e6b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999087
X-Stat-Signature: rhno9564f1o6hnja5f1p9gjjhdzcep6u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 683AB180003
X-HE-Tag: 1782883084-563594
X-HE-Meta: U2FsdGVkX1+jY+qgU/85zpsQIH5rj4e6LgCYZ2/+beytmZZPR7cB1f608fAsKeVEZc/R1b3Cxef0uU08wyVV6WXCfcz0E0Gmtik02k7UO4I/4wagwmQgyzFi+3VLfivLAJ10LdI9Mq/d8j2fc0LIBFsNq9Cf6NomreA4IPNz3O0hOxhjIPfN7vRKE1Tv1eZyHvGqk/6fYqarEYObsHL9xW+VrRgdG1cz4Y+UIUSfzyAO8rB5KHRKzeNBl1B1hi5pbSRW0dM9TOevf46gXLdyLx+Py4MFS8D3UZsdY6xf4KgSEYHzASV4JlZRPOjUGr+3gOh8GRedXoElDE5y1wtrKknN9Gt4RKehpFqJ8iE2qb4+i0fWJbbCmSox1xgnyvbgRPMU58vO/nSqb36ZDN3TjZP1MXbuZrkd5yC7UmvS5Srf+mq2JMAbawrK1xNGgcY5xXaAUvueuEXL6JZUMF9aT4tfRtx4gRVj6IHvD6hUSvuhhU47XQJ9lOdrDIkOKc6DqTIMZ/MRT9CI9i48ERFuShvxsIeir1mGsN0kAm+lb0cL0A/Zcxc8AgVqObf5s+duz2u19n4Jfm1Snp/lrzKBE3jBXWeHLTRU+qKAx1lLSquuEc2WZksAtEpNSble/MU0X86AF/N/sntCK9HbHV7rGi5D/r8Km+BkNLWd67bFIeP3j3o/DTLDjxWb/quXaW0GXbFR4bB1MkK4lDijl1sDd8wjAtSIw+NVk8951euejjQjDAR235vD3jCus2X/7Rop7IrF/BqxkfNZe7MpGrbBYqFg+lw7AfcGBuAwoe5azZQekJ9jwNLJV3ssMteqqfvktUQkM1yoy0LbOStSVCgNQuhSpUF+7G4/K0oIrCMB8c5PSsTlYNfvjYONPRIaEf/ewl77QiF2BitWhx8tIgByywnUNzpyA3Q8ZlNLqWik4v8Dt+6DdvKOSjGF6rwRy9RJ9G65xCNhRHGdCsbYmhA
 9BAIyYQ9
 afuxHwnQ5U2pzkkCj9cHczzHRdyOTMq86iSDNk5+cX7SYtbsi7FoKtN3QaSvv3HVykNZLrNVc71VTtoTshV47nJEwT6ZPaPILHkB0ZLqZXcXpN5PUcFuADyaHmyeTxkQ5WmhZCVpQKaAsl+vsQ4/ifNUm94iWQRrnEmOr08KUMRJbOA1Svpdqo19b+ws3BLjLnvnobc3pNgfUujhHrQlrxL7N7pkaW3+TY3ZWobHabxGDM3+c9AD86GEbzUZjW2Ljdri9JaAfbBnmyatlf2BjebFPjLORqgg6AADd6fFddPT0xGFUHypuvkNcV5dgageTFvkMFBb+zU5XlICy5zY23QSOCErMzKZnRKLkbn+awWjutQwZUszol0btUxeWOwo6EtIslYAZUsy8u6025tN6Ta3iKVQIg5ktA+Yka0BFEmhnmD0dIToy3JKC2p8sEoSAwTMR2Oa6vW9gjW0uGrBUNtVxZnPAbz9dNeJjx6TvMz6MhpdVnkMeLObi90SWiI17Ff+7GAjB8EeI4Psi3fLUQuPOG27vhsa6vxjG+0tcE/Xpc9eJPX1ZXIlzURtqq47SkC9YJzdx2jRRrh0G1VsBEla+FBIwM1lRUEVg8WMgxUFWHuupu8s6RZF3qu12EDapCrq9/RyfQZZHhv8TCHNV08QnQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an unsigned long migrate_info member to the struct folio union and
use it to store migration state (anon_vma pointer and FOLIO_WAS_*
markers) instead of using folio->private. While at it, switch to bitwise
OR.

No functional change.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/mm_types.h |  1 +
 mm/migrate.c             | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..ae9bca4eda5c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -427,6 +427,7 @@ struct folio {
 			union {
 				void *private;
 				swp_entry_t swap;
+				unsigned long migrate_info;
 			};
 			atomic_t _mapcount;
 			atomic_t _refcount;
diff --git a/mm/migrate.c b/mm/migrate.c
index 5bc81d61116f..6fb6f46eea5f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1130,7 +1130,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 }
 
 /*
- * To record some information during migration, we use unused private
+ * To record some information during migration, we use the migrate_info
  * field of struct folio of the newly allocated destination folio.
  * This is safe because nobody is using it except us.
  */
@@ -1143,17 +1143,17 @@ enum {
 static void __migrate_folio_record(struct folio *dst,
 		int old_folio_state, struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_folio_state;
+	dst->migrate_info = (unsigned long)anon_vma | old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 		int *old_folio_state, struct anon_vma **anon_vmap)
 {
-	unsigned long private = (unsigned long)dst->private;
+	unsigned long info = dst->migrate_info;
 
-	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
-	*old_folio_state = private & FOLIO_OLD_STATES;
-	dst->private = NULL;
+	*anon_vmap = (struct anon_vma *)(info & ~FOLIO_OLD_STATES);
+	*old_folio_state = info & FOLIO_OLD_STATES;
+	dst->migrate_info = 0;
 }
 
 /* Restore the source folio to the original state upon failure */
@@ -1214,7 +1214,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		return -ENOMEM;
 	*dstp = dst;
 
-	dst->private = NULL;
+	dst->migrate_info = 0;
 
 	if (!folio_trylock(src)) {
 		if (mode == MIGRATE_ASYNC)

-- 
2.43.0


