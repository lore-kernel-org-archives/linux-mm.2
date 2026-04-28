Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C1CFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703726B0088; Tue, 28 Apr 2026 11:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B38E6B008A; Tue, 28 Apr 2026 11:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2006B008C; Tue, 28 Apr 2026 11:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 436D66B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:51:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0CE9403DE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:51:49 +0000 (UTC)
X-FDA: 84708405138.27.67BDDBC
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013008.outbound.protection.outlook.com [40.93.201.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9532E40004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:51:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MxkzgQrT;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.8 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GDuNcW5OKf3FPunqzJxWuCCldavdMM28VvUJCz8+SIM=;
	b=fz2eBLtVUU3eiICi3r3K3aiiGvHTDHY18UBeVWr/LYSQbqSExv2CZOmggVGtl7mcn5unjf
	+nRWEalGqKUY5psUxdleatUlp+yfHt0ePQLe2CvTADbB4XFNopKD5O+xY9IzTg79WbqH9b
	KY1nGVnMEaQAWtYl/YuPgfJHX1K0GI4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MxkzgQrT;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.8 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777391506; a=rsa-sha256;
	cv=pass;
	b=ruPathT3F04h3rfprF5K1AbGuDdtutUYyI9vSG1D2rXszpALWF2RSaftpXTKymjuJL/1X+
	dLO6HK2FxI3ZzsGX9kkunw7mapoxKgUCyxQGH664TmMQU/qTMZq9o5119LBG+zXNswuw4Y
	h5psqkPcxAuT6Zz1lYHklUiTiRQG6HM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lWazakMQoFOguOA/y7ZnGPkd5HSIMwCdAIbZbuE3MpSWKm/xVubF5HfHF2mftVhVOIq8+AcIM4oo4tZtfyQvN+3OmH1HGgVJdNx0Ff/1ShCVIn/KKxeSz+GHCXarqXX/QL4dQgFYqffYIEvfMt2Ja/FGEpGYtGA0bhJwtP1D8zVMdi4WL4Kv/G90Y/WNLpO4gVxmJTlXpwjLW+JsxBDYwE+P9U+KqTTsoKIaVrp/J9EkMwzIShefLpyfqQ593FjAuBuUQ7WfjBt6A5Ok+XcscLWjSMNp0LDngO48XJqYOqIMTlvvVQXcvZtnJsqO3uzm6uagWvmhUg/rAB+GcByg/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDuNcW5OKf3FPunqzJxWuCCldavdMM28VvUJCz8+SIM=;
 b=Uant5BCwWmOPIu+IEY90Fy8e5+mPR2k5JmCWpefaLhycL0jZHYoSf5ubE3OJCGd9wFiUyPdQ+xcpcJinY1U2UXv/hud5xssOANTZdMjU9eeLIaTZdZoFneoPDQGNUXckweDDPTj8DtevM5UBiWvYgaZr6r3mG8qGYoJst1NiEVpgn2E8SLY89/6pkmPM47p8e5zNlH8AM1V9dkAY+yWV/P7wvBA04VpcIWKbW/PdW5K5ch2Xd0oYjwaqP+rOUDD08Db9dIEf/eg9ewQtkeR9FlMSOBRzIh/bPQCJSRTSvG70Mw+OIkklMO8NsFNmu0no7qIlH0iiqBv9SzmoslH3Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDuNcW5OKf3FPunqzJxWuCCldavdMM28VvUJCz8+SIM=;
 b=MxkzgQrTpMFvXJq5OxfHEBPW+AN8KDTROA6D4AE3h9hNUF0wLfGBS2bW2yJh1RYoC6aNYzq49AEPy12Zw6xvtlpIyyn7aW137Z9WoKia2bPDjWVfaa8edHAUGRlyrzFDR6LnBQ+zLBMQC90G95v2Tv0mdEmsEyP5/yENHjN9XJA=
Received: from SJ0PR05CA0098.namprd05.prod.outlook.com (2603:10b6:a03:334::13)
 by SJ2PR12MB9244.namprd12.prod.outlook.com (2603:10b6:a03:574::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 15:51:38 +0000
Received: from SJ1PEPF000026C4.namprd04.prod.outlook.com
 (2603:10b6:a03:334:cafe::ae) by SJ0PR05CA0098.outlook.office365.com
 (2603:10b6:a03:334::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.25 via Frontend Transport; Tue,
 28 Apr 2026 15:51:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000026C4.mail.protection.outlook.com (10.167.244.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 15:51:38 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Apr
 2026 10:51:26 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <kinseyho@google.com>, <weixugc@google.com>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<rientjes@google.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <jhubbard@nvidia.com>,
	<peterx@redhat.com>, <riel@surriel.com>, <shakeel.butt@linux.dev>,
	<stalexan@redhat.com>, <tj@kernel.org>, <nifan.cxl@gmail.com>,
	<jic23@kernel.org>, <aneesh.kumar@kernel.org>, <nathan.lynch@amd.com>,
	<Frank.li@nxp.com>, <djbw@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>
Subject: [PATCH 0/7] Accelerate page migration with batch copying and hardware offload
Date: Tue, 28 Apr 2026 15:50:37 +0000
Message-ID: <20260428155043.39251-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C4:EE_|SJ2PR12MB9244:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ed50a43-fc6c-4c27-e54e-08dea53e08ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|1800799024|376014|18002099003|56012099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	FwunOcCY4x1uWAHg9Armct6G/ThOfQVSUmEn0/aZ9AoxaHCqXrxLymmk8BQhi3IB11wBYOu7sPl0K7zoC6SH2BsdG1UYzGp86AZvd0FwA30uCAr2p35Sj7TBTL6SvwnleSsNIhPFjzmISPjeStATSMGq3nsVaH878ywe5cK5Bt2aMHt0Lq0kXYJ5kovqemzCmxtvPsyb00TlxA68M5OKT94kWjEyGUFUiEXo5s4mq+IFT3DtAn+ip054otUV9CPPFvP7GG5IpCki1ZQHMVL8QU8jFmK+FHT2E/K2lH9nuyhOvKVZdNB2SJwP59ZpRuDNYsVS+Et/fhojJHlu57nmB6x2vV4t9XntQGxKpyu9tt2fCZ6E4S4KWnPCrqHpFzDOhLy2JIcoidTIh5tzmaq2yS0dYTuYuLxc5QmKuY3sIjX9/Eyk5HiKJGsonHZiwiRFfeqaW+irYHeVE6IzVC5jkKo9hdUxYGFDWiA9/cULMRLDepWQvBtojDWufM5BO5y9SVBijLHzaiYGMyC/Z9CcQOeXO9eFVu6BF1GnnTK/UZcBJ+qJnD/kqx+i7Q6an0o5MmL/aDAh1YC5sWhOJFnJ0xAzr+ug/jGk1o2EURSnhRWGPzS7MbZRjIKTTLh7nPYdTzeVf2V6OB4DeO46VfnGR3gbYWrFy8S4ukgAf96T0CUtWJKkdMrI2w4GKdste6WsfN03zvyNSFlvAwBf0YF2gg2F8NMho7dthqAQ4i+AlxU=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(1800799024)(376014)(18002099003)(56012099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uBir/47m9aL/VhVnmU0mSlcAff/GKiMaXdSddMd9/2hlY2lCpM2oNRD5T+KecsrCxjS/cUBv7SyjjQRX3vxL6ls33eZkfo3dyQO5ibT8t8OEvofNAbtyg94eoTVIiEJBCwQ+QWgpKwPDY5Z/J6NiqLXX6+RT8gMrqif/dYKGKwZACL0W2O1PyipwkPXkSFeKAs10AWYXu3o/6CnKeKZQYq82vlCblM5wzx1pj2BWuGDLBDy0jzCAUpF990PFD5k1MX7Yv+LnIc8EJhdYXjahWJ2ntKTnOurzxxwd0pT1C3zQ61nm45W+vt3hu9OV4F+UEfWNS2DEA1YusbeLnbbVUoTq4pzySKfpl1XsnqhH3gnUO+QuGj4SWeUsY/oj8pZJQ7RQQ5WpABYWP2j7VDjJiYSFZHSJZQx+2SpJSvjeQ8DFuMRD72j31rvBUa5ITIxB
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 15:51:38.8273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed50a43-fc6c-4c27-e54e-08dea53e08ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9244
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9532E40004
X-Rspam-User: 
X-Stat-Signature: m6miccg1zecegg5s3oaxih5ta9esbunh
X-HE-Tag: 1777391506-72612
X-HE-Meta: U2FsdGVkX19HPi5lSG/dG68In7TUopsL4rSBIxDjxSQBudJuxzpULmyKm2a8mSLYe4ue2Lhz0sCfqwc4eOI3rOKRg1aaMS/zIaC8pKwosNjm6DUGvBIQYVbkH8pOkB5WemxNWTWazFJ084t+nuKDV+kaAuNHZHKNeU1hjMJwf3AsPuayEthG7s7ap/8pqUy748sj5AljpiB33/+M1n0c/rqa8ch5qebGmnZAtwyIaHn64MavVQkZ3It2CDF2/NlvuNXOd/bWT+kyDdIpmYC+7CU04i+gJ3yoL34BrdGFys52U8nZKHZ0gbjxQU43FPuGMLvdz731s/I2HTTx4AdkXT5bx6P0QjaZAnem457t8AoMQdkFujRMtYdjvJ9qp+JMYMupDGyL2hwU276eT5/XLxeXxt3/iV0PUP5m/FOqlvNfq8UhhADYisRFeYtu0SocaOdcC8cQDDRIwW86Oqc2QFYlPbRsce1B1YIPitAs7Zf3uKPXfK2RD3rsQ8lJkxl7tLLw+ph7fU7fnY99bziqNdEAOQBMUfvSXYHqrJIh+CMGsSttTKRy4XNdnvyEe6YOcV8upgD4UrJW2rr9cn2TmfFNAgzJ98hJvfCqMfQZ9IbeYsPThgf9sw5un3X+WABD1ETeW1N3d01Yv/BcvzeCdQnX2Bj2536KBxN8SO7DbBO9+M/zqxanIzfsfSlzl0+MO6gqivy7WD9+30ApAkX1ldrE/E3SJEh25SESV46nlVVk6583X+fckEaP7RLuaFU/wjOdK5AlToVk0c5zyBVOo18CEfC99MVUjqVvE31LmXwX7RwR82XjDaNdVKXKB7FMix4sEtta7nmQ4+Y2fbKvPgEjJfFvKY4B/RCjqmtBn7DzHYj2HTLuNvAs9OOjX8Z8OACHIooOyr9UnRXy+SvOJjjfwavv6QzMWMAY76mgmuol4H6CJO8qPHmfC4ajdMn85vZ6vbSMgb3B/Unv4Zn
 qP+fJBcm
 ue7Si2TuDijyb9ntB2/wIRfn1MtJiUqLS8kP4hvP2tVzemPpjyu7iG9A3v5ydJkpr8d8azqcvflY0ko+t70s+w2x6cU+AoTofciOYQigB9nd+HXtVu2XMShgxcLSmwpvx1/qKy6Dn2BXzmk5XFLL7mPLz372pRmTjeglpYBOIjUjw1UFIkbTxdR2pjpjMnSiVdJByyXlMvsl850vp45k1COxI5Qh7dDTlg6RoLRwagjF6fP3OXd9IBcIxVmNSFE7kzIfHa8fYSazpgDuUTSTEkjIsFrnJkwhoXQRhF/+hLKiKPl4MEiY8g2KBqOl9ih9xcRuo0aov9v0n6EU7T87Z/dkLKv3C/x6sEjkRowRSohp/5kiojEWbek6BVzKOdtTlXvUcghBKBbITWMAGzZuJG9n0O2X28H53Z9Yk5K42dsTYL2mbr+CZb0S1jkmsI21f4K/OfpW3ayKIPVHtyMjt5oG1snpCT6oxTju7SEDM2vppfQYEFJGrDD5mwrwcu4chfdU3zQfexie6bclOz/vC6bgpvhPzvOuyUUZZxOchTNJ/QnAESP6MRqK4MVfLM4AvEK1TG+q8TFI7yaaClntsuEhRGDKvgrTLJImJLfasv4jQViG/yyvVHJtoP1tzPpNpng4zU7eGvj1NQoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the fifth RFC of the patchset to enhance page migration by
batching folio-copy operations and enabling acceleration via DMA offload.

Single-threaded, folio-by-folio copying bottlenecks page migration in
modern systems with deep memory hierarchies, especially for large folios
where copy overhead dominates, leaving significant hardware potential
untapped.

By batching the copy phase, we create an opportunity for hardware
acceleration. This series builds the framework and provides a DMA
offload driver (dcbm) as a reference implementation, targeting bulk
migration workloads where offloading the copy improves throughput
and latency while freeing the CPU cycles.

See the RFC V3 cover letter [2] for motivation.

Changelog since V4:
-------------------

1. Renamed PAGE_* migration state flags to FOLIO_*. (David)
2. Use the new folio->migrate_info field instead of folio->private
   for migration state. (David)
3. Fold folios_mc_copy patch in batch-copy implementation patch. (David)
3. Renamed migrate_offload_start()/stop() to register()/unregister().
   (Huang, Ying)
4. Dropped should_batch() callback from struct migrator. Reason-based
   policy now lives in migrate_pages_batch(). Migrators can still skip
   a batch they don't want (size based policy). (Huang, Ying)
5. CONFIG_MIGRATION_COPY_OFFLOAD is now hidden and selected by the
   migrator driver. CONFIG_DCBM_DMA is tristate. (Huang Ying, Gregory Price). 
6. Wrapped the SRCU + static_call dispatch in a small helper. (Huang, Ying)
7. Requir m->owner in migrate_offload_register(), SRCU sync at
   unregister relies on it. Counters are atomic_long_t to avoid lock-order
   issue.
9. Moved DCBM sysfs from /sys/kernel/dcbm to /sys/module/dcbm (Huang, Ying) 
10. Rebased on v7.1-rc1.


DESIGN:
-------

New Migration Flow:

[ migrate_pages_batch() ]
    |
    |--> do_batch = migrate_offload_do_batch(reason)  // core filters by migration reason
    |
    |--> for each folio:
    |      migrate_folio_unmap()        // unmap the folio
    |      |
    |      +--> (success):
    |           if do_batch && folio_supports_batch_copy():
    |               -> unmap_batch / dst_batch  // batch list for copy offloading
    |           else:
    |               -> unmap_single / dst_single // single lists for per-folio CPU copy
    |
    |--> try_to_unmap_flush()                   // single batched TLB flush
    |
    |--> Batch copy (if unmap_batch not empty):
    |    - Migrator is configurable at runtime via sysfs.
    |
    |      static_call(migrate_offload_copy)    // Pluggable Migrators
    |              /          |            \
    |             v           v             v
    |     [ Default ]  [ DMA Offload ]  [ ... ]
    |
    |      On -EOPNOTSUPP or other error, batch falls back to per-folio CPU copy.
    |
    +--> migrate_folios_move()      // metadata, update PTEs, finalize
         (batch list with already_copied=true, single list with false)

Offload Registration:

    Driver fills struct migrator { .name, .offload_copy, .owner } and calls
    migrate_offload_register().  This:
      - Pins the module via try_module_get()
      - Patches the migrate_offload_copy() static_call target
      - Enables the migrate_offload_enabled static branch

    migrate_offload_unregister() disables the static branch and reverts
    the static_call, then synchronize_srcu() waits for in-flight migrations
    before module_put().

PERFORMANCE RESULTS:
--------------------

Re-ran the V4 workload on v7.1-rc1 with this series; relative
speedups match V4 (~6x for 2MB folios at 16 DMA channels). No design
change in V5 alters this picture; please refer to the V4 cover letter
for the throughput tables [1].


PLAN:
-----

Patches 1-4 (the batching infrastructure) don't depend on the migrator
interface, so if it helps I can split them off and post them ahead of
the migrator and DCBM bits, which still have a few open questions to
work through.

I would appreciate guidance on splitting the infrastructure portion
ahead of the migrator interface if that matches maintainers' preference.

OPEN QUESTIONS:
---------------

1. Should the batch path run without a registered migrator? Patches 1-4
   are self-contained and use folios_mc_copy() (CPU). I have several
   options like making batch path always-on for eligible folios, or
   giving admin an option to flip the static branch, or keep the gate.
   I'm leaning toward always-on.

2. Carrying already_copied via folio->migrate_info vs changing the
   migrate_folio() callback signature (Huang, Ying). I went with the
   field for now to avoid touching every fs callback before the design
   settles. Happy to revisit.

3. Per-caller offload selection: Today eligibility is by migrate_reason
   only. Some are latency-tolerant, others may be not. Is reason the
   right granularity, or do we want a per-caller hint?

4. Cgroup integration: How should per-cgroup be accounted for different
   migrators (e.g.: any accounting for DMA-busy time)?

5. Tuning migrate_pages callers for offloading. For instance, in
   compaction COMPACT_CLUSTER_MAX = 32 caps DMA's payoff for compaction
   (V4 experiment).

6. Where do batch-size thresholds live, and how are they tuned? Per
   Huang Ying's split, that policy lives in the migrator. DCBM has no
   threshold today. Open whether it should later be a per-migrator
   sysfs knob or hard-coded; probably clearer once a second migrator
   (SDXI, mtcopy) shows the trade-off.


FOLLOW-UPS:
--------------

1. dmaengine_prep_dma_memcpy_sg() in DCBM (Vinod Koul). The SG-prep
   variant cuts per-batch prep/submit cost (=CPU savings), but ptdma does
   not implement the SG hook yet [10]. The end-to-end migration throughput
   delta is small because per-descriptor execute time dominates.
   I'll post the ptdma SG hook + DCBM switch as a follow-up.
  
2. SDXI as a second migrator. The SDXI series [11] is in  review. SDXI is
   a generic memcpy engine without DMA_PRIVATE, so channel acquisition
   goes through dma_find_channel() or async_tx rather than
   dma_request_chan_by_mask(). I have a local DCBM variant working on top
   of the SDXI driver. I'm planning to send it as a follow-up once the
   SDXI series settles.
 
3. IOMMU SG merging in DCBM (Gregory). dma_map_sgtable() may merge
   contiguous PFNs unevenly, so src.nents != dst.nents. DCBM falls back
   to CPU for safety. Though I haven't seen it on Zen3 + PTDMA. I'll
   understand this and address it a follow-up.
 
4. Revisit Multi-threaded CPU copy migrator once the infra is settled.

EARLIER POSTINGS:
-----------------
[1] RFC V4: https://lore.kernel.org/all/20260309120725.308854-3-shivankg@amd.com
[2] RFC V3: https://lore.kernel.org/all/20250923174752.35701-1-shivankg@amd.com
[3] RFC V2: https://lore.kernel.org/all/20250319192211.10092-1-shivankg@amd.com
[4] RFC V1: https://lore.kernel.org/all/20240614221525.19170-1-shivankg@amd.com
[5] RFC from Zi Yan: https://lore.kernel.org/all/20250103172419.4148674-1-ziy@nvidia.com

RELATED DISCUSSIONS:
--------------------
[6] MM-alignment Session [Nov 12, 2025]:
    https://lore.kernel.org/linux-mm/bd6a3c75-b9f0-cbcf-f7c4-1ef5dff06d24@google.com
[7] Linux Memory Hotness and Promotion call [Nov 6, 2025]:
    https://lore.kernel.org/linux-mm/8ff2fd10-c9ac-4912-cf56-7ecd4afd2770@google.com
[8] LSFMM 2025:
    https://lore.kernel.org/all/cf6fc05d-c0b0-4de3-985e-5403977aa3aa@amd.com
[9] OSS India:
    https://ossindia2025.sched.com/event/23Jk1
[10] DMA_MEMCPY_SG comparison:
     https://lore.kernel.org/linux-mm/3e73addb-ac01-4a05-bc75-c6c1c56072df@amd.com
[11] SDXI V1:
     https://lore.kernel.org/all/20260410-sdxi-base-v1-0-1d184cb5c60a@amd.com

Thanks to everyone who reviewed, tested or participated in discussions
around this series. Your feedback helped me throughout the development
process.

Best Regards,
Shivank


Shivank Garg (6):
  mm/migrate: rename PAGE_ migration flags to FOLIO_
  mm/migrate: use migrate_info field instead of private
  mm/migrate: skip data copy for already-copied folios
  mm/migrate: add batch-copy path in migrate_pages_batch
  mm/migrate: add copy offload registration infrastructure
  drivers/migrate_offload: add DMA batch copy driver (dcbm)

Zi Yan (1):
  mm/migrate: adjust NR_MAX_BATCHED_MIGRATION for testing

 drivers/Kconfig                       |   2 +
 drivers/Makefile                      |   2 +
 drivers/migrate_offload/Kconfig       |   9 +
 drivers/migrate_offload/Makefile      |   1 +
 drivers/migrate_offload/dcbm/Makefile |   1 +
 drivers/migrate_offload/dcbm/dcbm.c   | 440 ++++++++++++++++++++++++++
 include/linux/migrate_copy_offload.h  |  44 +++
 include/linux/mm.h                    |   2 +
 include/linux/mm_types.h              |   1 +
 mm/Kconfig                            |   6 +
 mm/Makefile                           |   1 +
 mm/migrate.c                          | 211 ++++++++----
 mm/migrate_copy_offload.c             |  94 ++++++
 mm/util.c                             |  30 ++
 14 files changed, 784 insertions(+), 60 deletions(-)
 create mode 100644 drivers/migrate_offload/Kconfig
 create mode 100644 drivers/migrate_offload/Makefile
 create mode 100644 drivers/migrate_offload/dcbm/Makefile
 create mode 100644 drivers/migrate_offload/dcbm/dcbm.c
 create mode 100644 include/linux/migrate_copy_offload.h
 create mode 100644 mm/migrate_copy_offload.c


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.43.0


