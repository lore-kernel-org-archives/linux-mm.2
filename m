Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044DF606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=hNGdQPcw
Received: by kanga.kvack.org (Postfix)
	id 268AD6B05C2; Tue, 17 Nov 2026 02:17:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240E16B05C3; Tue, 17 Nov 2026 02:17:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157476B05C6; Tue, 17 Nov 2026 02:17:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7BA96B05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:17:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F4F1A7D22
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:46 +0000 (UTC)
X-FDA: 85443756132.26.DF9B050
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B8F31C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hNGdQPcw;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09U7UvY+B3okNAT7LE1wuAp6ZjyC3vPbdWsq64758qY=;
	b=Wnd9pAyOhyY0UffL7PVdJQctmdLUqSUBwte036b0O6xnGqAFuo3nIvRZ3CuZMCqq1EyEHb
	FIsCc6J7qVU4XpBQwgvoj2TZocXQGjRS0E+dpQQA6HMF66Q49RlZKDeM6p7e1Fb+Jqjaal
	mVwHO33vkkVsGT4fx+rqwpnhvw8MGnE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794899863;
	b=L2ArJ1+HJ7D7FtMWqAs/erg+s0WJgLivjYSjV5xLVLGgkETuUQlBPBKnRP28pjqWqK4Zr9
	/F0YZAVuWHGvfJDfuCRiDpy/5NpbSOg6wMVqsLU7Tc3wDwyMzFcE3d/TLclqaTHHkBRMvx
	kgrI+xYBnq3EtyR9CIgLf6tNnBTj+qY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hNGdQPcw;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x8TCJEseh2ncOCgJj4Q9U4VykaxC/UuGN3p0F0OnXu90DVr9yFHTCNFWb8RGdgYcf4j/J51a2tAiDlV/RKimQaBLmtNRiNkE/Uz3SoTWWaegZ66lRkGvxJiPoOFp66u3xaw98QkR5stLj0NXld67g8c/4qpJTMFV5a6/OyYreg6O7SOuCw2WtSBXJF96dt0Mxe7GbjKgKZoyxV5+kIBpYNKovoYPuJ5vOeYP5OhKTFdxf1j/nCsQZ7+yKrtlfb3rpln0fqyY5q69bBj2vUfLQV4ZLX6kILdnOMj4SAkFc67Ld7uKEzIm3Nsi+8snK07x+a+FsErva7eWIdxDSDUH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09U7UvY+B3okNAT7LE1wuAp6ZjyC3vPbdWsq64758qY=;
 b=iQQ5wmVbtZMTOkG2LViHxMxDKKMDN1VjSDl4Obnz90TjFtps75z9PTkTsmftItKhxvgZgVH3sslLIvjsZeC0Zsxl8fYZBNdUze+fMIEjGz3k8vG50kPcRdbgwSYibCTi2VXU0Dgvxd2eNZdlWEVh6mwxeNmc61eQ566a6J9i24++ymgv8hVQ7YwiXY3ivTcLHC21FlBvGWfOzdXM7b90AhKy5fq1SI7E9sUqhIkpdsdnYpQw1T0B7PxugfSQC7swFLRylHAMnYmzcpR7k5srGKMMwnmsD3z3IN3hMnPBcwK/FQBE9Fv/ixxppa0XPwuO6ilF4zfHrHkOmWOqq7Sayw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09U7UvY+B3okNAT7LE1wuAp6ZjyC3vPbdWsq64758qY=;
 b=hNGdQPcwsCl0F5b4rRHa0i3cLu3mSEDxHB88vNUQFp5teRiWmXi/zRUdKTGc8H6yuuI8r0pVs7LUnzGGjCTZBXGEcp9kxISZTY8xRwHwSZV7QmCaC/I0R2WhaGkZWIp7aKEEdLjKFE7XRJoMIDNMwz08TeHTUKGLkMxOV6DZ1GU=
Received: from CH2PR15CA0018.namprd15.prod.outlook.com (2603:10b6:610:51::28)
 by BL3PR12MB6546.namprd12.prod.outlook.com (2603:10b6:208:38d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 07:17:36 +0000
Received: from CH7PEPF0000001A.namprd21.prod.outlook.com
 (2603:10b6:610:51:cafe::9c) by CH2PR15CA0018.outlook.office365.com
 (2603:10b6:610:51::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 07:17:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH7PEPF0000001A.mail.protection.outlook.com (10.167.244.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Tue, 17 Nov 2026 07:17:36 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 01:17:30 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 17 Nov 2026 07:16:52 +0000
Subject: [PATCH mm-new v2 5/5] mm: nommu: remove unused heap_stack_gap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-unused-sym-mm-v2-5-2f845e94dd50@amd.com>
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
	<baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Minchan Kim
	<minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794899821; l=584;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=xutkpMVDsubOUvN4qaxfBq/hpdvEFD2ITbH891JolTM=;
 b=680/aZQMqYQI1ovcbYrJ2fCjmGwoXYkXsCjlBmyUv81oM8JlvmGg1TSZ3wr5Ebod0YvGeaNUf
 HroUr+8ucKQBT+eayrMqbHh+PEmV55ItHWRNjoGVgX0Cox4Yz9sad5G
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH7PEPF0000001A:EE_|BL3PR12MB6546:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b5a415a-1894-420c-6c90-08df447adb06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|36860700016|82310400026|921020|11063799006|56012099006|10067099003|261021123027099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	USa2tqs12Qjsc8anIERjTafGFPXjga6zPgoacVByG9WAnBSCDILjyv/5XcwIbY2t+nWAJlf1nEfD9ss4oAWgxMHZcgL/+PNRi2hDXMBU7bR8glf/pup4b05SR7IrGU4c2KSgD3bVxoDxAqFTnx65HSXr9JIua/gzOQImity3/RxVAzNeozQ+wcgpHwv4TFPq1ZRdQclWThG/AyjBYd7OmqP1XgoSC2nYa9LbOirwg3O+8WLgqPLVmh8/w5QAYNrYmrqXH1JKrEbRcWCJX1zXe3EsY2y/f4jxyViDRJdqxNrRWvpMNR/6vbZcgWF06QXNQF4Hc/rDzIhgHamcB4g0WeaULgo+V33j4Q6sNi7lj529SqnhfGysugt5aBTQprJRizjFqqqOXuLW7pJedWoGMXr1lU6OCnKcjEkVum1d1ESdCS50lpx6VhjtSntCIiPa04MmdnxaoVM+3jstUxOnfHSfUM0RumHeSVx5sqJROyurFcp4YpQwOIW+xFVUrJuy6C2hlBm6fbpdU5NBJtSw7NBN3El//YaxoYkICkJu6HkuLYkhA0c53wNiz4TVs3gX3/NuCS36m8Kq9GoiLdW8yIxF//2RHjEqD2IrEvqWwQd/lGmZqcKxB/kT1rB1WtC4vz0RRnriHjvDNRcQAFwHyUHM5TsUwc8CWI5ouBwbik5/jq80orLALTE6nzI17V3Rx02+LlZzKeIHGorxuJsANA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(36860700016)(82310400026)(921020)(11063799006)(56012099006)(10067099003)(261021123027099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EvRImdHtkAklAQXYJcBijJPQ9M1xWXsVpu6NcQ/YwvMp6sXPNDQJMkUm0zpu2NQriQmnZIOAzx+6MUHhIV+H9DJXy1RNBzuKJFXCO1Fbt+NENbVDd739ek2iChD3uInDni06yuAhYgFacOyOaVXs5mXDp8vvHVoK7IgQEuP5VA/jKpTIGNI7f4MUrHUvT58w056954MjW4XEs+o0dYRS3AatENg4Q/NcPzfe9VaZ11b6tLecMGvgqnykcW28LyjtpgD5JmKpkhV+gbTNKqJL1C5JMS+cLGczgFlM6kES4fjjvnFGMpeoCWNWI/rb+Ke3YHzBlPKaLxWMlqTTLzsUR/9+MTVqaI67D9AqdtMPTPDRMVmk+Z39PuvZzvMSj3NMIc9HV0Oig2R4YxrT+qWhi4YXEbG514B0Sdc15GGW488T4MqY6Kqnx0feBeQQTaSo
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 07:17:36.0688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5a415a-1894-420c-6c90-08df447adb06
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH7PEPF0000001A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6546
X-Stat-Signature: fkoynb85pngqk8bkgtxiyo9gpmberamm
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B8F31C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794899863-431371
X-HE-Meta: U2FsdGVkX1+5c745zZVxh1EdInFVKTNd4Lk3YO7vuJSgfQNdQe4fK8ro+IvbTUu7DB8GHM2ZKWWbeeL92vx0JprI/i9WD5MS4dJ84UkU4sJKJSpGsPgROua2KkXdowDZP6WVyfdQWCM/nM3bVgIwZ68DuSNtZIV40ow3TTVcVL+UtBnvUe4UZ63Eomb3hm4YYQ64wPmC36ACUkAWnClVgwC/vZM2hVjs4ftNUuiwa9tv8BgldFXVXBNabQWVRz6eQxDqQV+2lRai6FBOtDgNuxCEBk0luQzPvgnW3iPKpCcqgWjzT28GTFNsnmmVcQ9Ws7PGFkWG5x7kLNSMkM7ALnnj9AtfHV9hJ6cKSe18kEWR/o2dvbLOh1074CIQ3ZJ7G3OVGdzTQ1DUzSMa3uN9qNrrxl58gmihDCOeZ8oZ4CMsBsuDbSiza+vEpWzd5OJ9mis4/ZyjwACNrlA+lnGQYf+y9kkc65B9h6lN24532LyeV9xkRipfm1YQTVKY5Y+xM/8g5SnctFewCsqLbrTtGhzOoranQsgTVEurMNyGwEyr1FUJwiscEi1CBQywRkc4Y6wpj0b5CQsx3H2CVFbC5ciNtobeSts3V8B4uVZfVnlsNXPrWtTQJLNK0LzHUg0iElesHGlVPF6d/CzGQjCFUkgTqc8+9DpdyNXUlG5ciMumIVn3xFrgBsbVyFpjrMnto+PvtsrjvAVoxa6pfdq68tf0mWm+Zrx13ivq7iWXYlgnLEaSlHZgwyj+Vxtq4HLXD/oNMVN8St5PHIVkKkfjLRc7HDYsYhm2oqj2olRoV7oa2Z6Al9D6BR868twREd3cwWkHDhfusFQIkL8PW9jFtaGYGykP+pFfiDF2Mlg8Icm0bYlFi20HlP+gNmbr+h8lsK7t7LjcZof66G5ZNruIvqPoolCRmo0nfJlBWzN7mdaS7r2ltK2qr1mdCGDHYyTqv98QmHbYPUUlpJflVd2
 RvECcAdu
 JKnC3Owladf7jktBVXg8ZJDVzywWiB23VBld6mM4cdQ/HChko7O0IdBxSEIn3fmdYTeNZniJTjGehxZi63daMJ6vh3an1KGxPLdRpcXjPqsxms787NGmB+w36fA38rDz1towvbYbqK+/LYFjFxBP0uCIdyKhrCP63c5RgVw/wJNmZao7aepCrRM13+/fxJP9UAXUOn9WhblXi5lVy3N+HUdXr8Apu7mLC+tiscyJtqd1mmZKld4naO114Oj5Fi+beGpKZYxVgvZCuJAmHgkMUGjb4zfYc9NLKrmkAmzMqvJ86IOuXwWHwZfHQ1lc1nD9xNYJ99GFqAOaSY4V54dX4S4+ehUVdPia6MmV8WCJkVIRaNY1W0rV7Dft9ynVfLPgqPDa+8U6/NUf6RTvpUUHP8zij9Z7htrrIMf1GdThE/QK6bEYQmfpWJf8P8Om/xd8SOBc/haPnLrX4XNnFWp1It54BZQgliKIcuq5owjJBmAhlB3Fwu3b+W5VAZgHuS+RQH//oFfJRx5sJq5H972IrZzOHzgOc7XaXuQiw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

heap_stack_gap has been unused since at least the start of git history,
commit 1da177e4c3f4 ("Linux-2.6.12-rc2").

Link: https://lore.kernel.org/linux-mm/20140430083620.GA4711@dhcp22.suse.cz/
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/nommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index df99495c8902..a971c12f2732 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -43,7 +43,6 @@
 #include "internal.h"
 
 unsigned long highest_memmap_pfn;
-int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
 

-- 
2.53.0


