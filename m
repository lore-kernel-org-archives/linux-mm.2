Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303F5EC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FD66B0005; Mon, 23 Mar 2026 05:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7B16B0088; Mon, 23 Mar 2026 05:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28C66B0089; Mon, 23 Mar 2026 05:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCC0D6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:51:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75DB81EBBD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:51:42 +0000 (UTC)
X-FDA: 84576860844.30.89E721B
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6250B80008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:51:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="u/zcCDeP";
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 40.107.209.9 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7TPfNUyF6WouorEDW3yPrTEpUlcAKBgenpth46FD3+8=;
	b=YLhrpNI9UjHnZ2P5vY23g1nHq38nhhgIM/fQV60L5Fahed1d5dnkvjMSp8j++cafye+P4T
	6PQupUs++OUQJusE4JMNkxYJ9V3iSKMyv1xliUxT21DBleKeuawT/ZFxQV/PxKIUK8qfUV
	ftDWdCU1K/y5dajfy4JB5oXHyaDTgEA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774259499; a=rsa-sha256;
	cv=pass;
	b=WOxrOhkQydz5/cXhQhMHhZY3RVO4F3nWKAtKVVWzBOMAyXhov6ZCJNhs6T6g/BbjewG3bu
	vsMwLc4OBus97cCq1Wg2J+ci9TSwnpMIE+Q6V1qdIzV//R3vn10kz8twxVcY4vYQBLY9lM
	SAE2GGPxLHDs85TAs2TYHpW5mtrl6JE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="u/zcCDeP";
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 40.107.209.9 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1O5Gmm9J41c70TlA0NoADmmWLUtIhypWeZUpJRRdhMvnk0c1D8jyfir0Wnz61+ooz4nUP8B0OahIMxRmx1jDS92qubOuUPRY9RJOZu7krEaUf5V0Maqkr9m+ft7+Mux6ONmoizeUgK7ePadzaREdHD1dIG9gytrlVmFN/2YRmmtOfJWulaWcGIwxKKhai62gj3z5L+BY+JXwYAiPZo4vg0vKZimK5AuvJxROc+uMWTIWnVwpI1BIQWTrKC2/qUYpdCAxp87neB2sfmysgA8s6rWrFAWJdQcI8pU/iKh9NnS19npqAfHlXBH/FN3kEimuhf021jHg3mrDIddBrnnUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TPfNUyF6WouorEDW3yPrTEpUlcAKBgenpth46FD3+8=;
 b=Ny/GUy2WCsnRUzXzlle/CJDkn/3sROKPm99dGcAqAXE7HOiiawDY9vXJH2t2eEgkTJQP++d7vF+M3Hj6vb19rr6xxzNVatL6RfwIZnhw4w4SP4bqAFgov/C0EpqAyfNpgejmee3q+S9OuUwbS5WLfCLgquVbTsKrBt0h458DtJ9yKyzAwwQInmU5MeHBHC56y5NMpUzERAxUImFoyO/w16980I2ClbWInYECVoVZQF8SoFQyvk63kdDFAldrGv2h1+PyjG97IWh2ZBAgREDVqWuVnEgmb3sDHo7ZGQf5uv5faRkbaX81Zqf6tZhu0C/rSwzfSVMKUSJU8i2XhMjOcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7TPfNUyF6WouorEDW3yPrTEpUlcAKBgenpth46FD3+8=;
 b=u/zcCDePBA5zUB/XhrOkW8BnRUAdGUQtKe0SbMlK8SgnWIu4N8HIy3+vJvQMG15pY0Sn2vjuJctBWEi7TF8bCZV8fo/GmIYEXOW1PVCYb/S01XXSidWkI297+uRK08TuOs9jEyFkcZjTuLEfyodRFRCBPQ/JLprYtDDDT+iUfco=
Received: from CH0P221CA0041.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::25)
 by CH8PR12MB9792.namprd12.prod.outlook.com (2603:10b6:610:2b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Mon, 23 Mar
 2026 09:51:33 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:11d:cafe::b0) by CH0P221CA0041.outlook.office365.com
 (2603:10b6:610:11d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 09:51:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 09:51:33 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:51:25 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <bharata@amd.com>
Subject: [RFC PATCH v6 0/5] mm: Hot page tracking and promotion infrastructure
Date: Mon, 23 Mar 2026 15:20:59 +0530
Message-ID: <20260323095104.238982-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|CH8PR12MB9792:EE_
X-MS-Office365-Filtering-Correlation-Id: 4468f62a-c243-4c5e-b3a0-08de88c1c45f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|13003099007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6oa5fqHyJqMz+j17izTINlgehsjPxEolNAetTX211u3qpHlTP7axT0NO2Xak9nlXHkJGQhqk6gLiYRUZOxXTe/yc+9yl6qg8Q7iAPcEpBQrIEeIaMS9hVvnf7yewHffvPtUrW+U9UeHSdJZ+ZhN0AokIYTv0sKuRiVhgptFVZKoSsz6CvYGWmobrlwkpCjzn1jvLJ+H07Sk1pGC4Ledjae04kOm4fhy897EYk6WD8CLrXNcLF8pmeH6d/u5M1WRyltYkFpMIllwdVZwGeAe8iE4AOhde4+OVF7bghrA7lQiwWamZRaPaEo1mhfs4Kgxv8IRBk3B9WjI0PbLzu97btzFWf5viwhuK1p5ZcSWcM7ljKE+CLnRJw56/b3FrgRQtGCWY9xZl1PFR+OhF36bWmyc2qWQ9tSz78olomJLH9vsNxKSfA2hMBSv2sBf0l0DwxWxEEZMt8ogVy1h7zxRiBN3XfEAnxP7MfP3ZReou0e1XvIiJEwtGag1djI/EJuKZEJnsJclMBiiR+Tda9kPJK8Ha3dWi+NFrK+NSEmZw+hSXQ5o45a1aXibc3+88FrXxe/gsdZ52MADn4JYricYpvjZo8rlYhTh4gxCrwdlGvYquHghSa4w0EClYw0e7IxzlDD2yGzpcn/p9hvJ0YU6fO/6p86VunTUB1u765VEFkbxvxhRZ6M4Kk4BqtsyUFjqrnPjNW8odr6XoDrJHjY+jIUzeogXHk0ziArm1+pZchBcu9ZXtjXSylkqnyxVXjylbITfRXvJHcWyhaH/HXqkKpPePcgTmQu5HvEMo1PIHDcs=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(13003099007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	W17dQ/bjSIFwMH1Iu8r1z5ryjXS55Dcj+f7S/XOQ8wrOzm58QGVZ5aCw0DlUC9gH39SUw0Xlief0VM1Ojx+o65THjw3GfiPN1Z9XwgVfQaYPvZyP0TjmJu6HmcqdlEqdAklFQFkAelNJwms3EovL/NS7uwHyHW8k76uRorjvOTriLvy1ssPLaBjmhpQuN0UnUHEeNLEH2U6+zyBPKqf8BIGK+XeERJNKz8p0aUeJQsV0TLT2Ks0rdzA0BiFJY5DUj5r/QgcZdtMuIfw/RajmbnRHkhJxpxrz2zbTwRgxgJ/6rQGPMhjyDQanP+JpGHgymDtytccunxdasH2QYgtPI08Sp6URC48ntGZ+RJEZ6cTJN4HnvtGNq5QojRTQUo0Zb8Fb9zWjjI8Ve3GYqinoRdl1rCy28PJmiCTahNZMxGrdUs5Pn0Bx9BFUZgSni0Es
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:51:33.7337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4468f62a-c243-4c5e-b3a0-08de88c1c45f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9792
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6250B80008
X-Stat-Signature: 8utmxmup67ch4c853ow85x4s7g8pf83d
X-HE-Tag: 1774259499-136235
X-HE-Meta: U2FsdGVkX19X+zn0SOi25xDuJFUpmcjmUyCZVfyScLVb43i1AFQ3HhrjkwLXWCGM6dWU7A+MzXkBRQAcd1H+gWKfqKXFzu2y1hDqaxgGC3e6zVU5G+02fkKvVbLX97yqMkYX7DYw30vQd7ZIFBtRVc+kF2WcfBADWqFiKO83iQpNMqqPzYvjIHtoQpSNjgNnLwlS72EIlAoAjfgZX8vZ0fzYQ2z84JudiQY33aBopiPf7Ee3iNgyS+R2lY8bvGFJcALVL4FmSHYGVjVSu1VUtDtxQpn7WnFWxOiDyp+1Dbn7KxDL5Tuvbo/TH7cY0jfWhv+RgitESyiTL2K1Gf0wp9zalKjAepoklyVmhDGON/EHckkSBdLJtgOp9Xiz514TQLZRJl0Bdoe7PzcL7G2kZohEza423f0Z74jXIolbY2WM7xlt7RHQmiOh0Uyugp0/bJCF2778lBv6UyQHVZJTNhohJOXCCaOvbJneRfvD7roOtpEyQxxtZTf5YqTNxA0Sm4xpS1hlTpsRtxbRe5CgbdFRVX5xIGC2KGoBEsITWmSZ8/F2ESk5ite0Y3Y9LnT7QseFlUpeYQTx/MIydSTuaFgVAyPCD7kzBdrJIMmvhw1HlRC8kV3LEUt6RR2VP1d7wpE2IIS+wNElB8q8ldDBUSc3f38VIAOGjZGUdv3qviH3bcu6fQllVZXdYLNDm9QhMhbWZaUkdzgAE9ViikzAs5isKhVW2/Tj7QylnxpZJU674+iXVrXJmAAucdkzUezXW3D8sRYe70eIAivtu8OerdWvUWX0RHJBcKWtZHml/p3fQ++Qy3xm30GOETRx5GruR3Kc6GmjqI4zeSQUJKW3kohQhdX07/I4Q4Ws2Pcoymi17JL+qK0SLzeVUUnz4Cm80312L2DROWGQiR7i43GJE3pDk4f8giC417ZbmKZgIGAGnqPFcfjpVMuz7AclgeWaBxdLHfDzY33Xv5hNUkn
 iZ5/FZ4K
 8uj+jP0tVUYkv+h+YVCrHHnJiUX1lRLGQG5qvPyMrJLFwYSlLeIQoszFx3MvuCnGdP3kL08ABLO7rjH5MeRP2mzyt4Thh5brMA73P3NzZismNHcIIpp5aWcPRBQNQsxpsv34GO13c6JLw1ta7w8MTLofjn3viHQH3b+IRdrhAC5RdbWwxVjYzVhHqpeycZSg9gJAiXzX9ckniOkKXTwBykbT8hUaoAht9yMCUz/oTFibT/vZplk05B3J2V4UDpO7rxsjB4Hotp6eAWhrYemsy6K1rIVjx4Yg8bGRiwZyNb6MZRDI0t2ihbQu9H1CqdpPKFhQ8IqwgsbEw7ErvqhTbTZSoRhbO8tlOgTFUZYgO1GJXIkTFQttcJy1UvDaYILYZBEJE1gsLedZ6IBqxu2OWaHcsfuJ3h1R6bssWxI3awcmMXxfxbP96uVmf/7ynk7J9vxHu51DyihGjbfH+nTec0Bacx7vEWsaNTWsEYz+KKK67aqXjWzA7/EGf8Yp0FLcYD4Vp6+VEu8eUHUmA6zmhxVaQODrvk4CRJC7ykSmok+Yw638Pic63LaiBDOU/SHRb41ZLDTDmh8LV5aHIWXnexJx5Ya31WrLmsRgS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is v6 of pghot, a hot-page tracking and promotion subsystem. The
main changes in this version are to retain only hintfault as source
and a lot of cleanups, fixes and restructuring.

This patchset introduces a new subsystem for hot page tracking and
promotion (pghot) with the following goals:

- Unify hot page detection from multiple sources like hint faults,
  page table scans, hardware hints (AMD IBS).
- Decouple detection from migration.
- Centralize promotion logic via per-lower-tier-node kmigrated kernel
  thread.
- Move promotion rate‑limiting and related logic used by
  numa_balancing=2 (NUMAB2, the current NUMA balancing–based promotion)
  from the scheduler to pghot for broader reuse.
  
Currently, multiple kernel subsystems detect page accesses independently.
This patchset consolidates accesses from these mechanisms by providing:

- A common API for reporting page accesses.
- Shared infrastructure for tracking hotness at PFN granularity.
- Per-lower-tier-node kernel threads for promoting pages.

Here is a brief summary of how this subsystem works:

- Tracks frequency and last access time.
- Additionally, the accessing NUMA node ID (NID) for each recorded
  access is also tracked in the precision mode.
- These hotness parameters are maintained in a per-PFN hotness record
  within the existing mem_section data structure.
  - In default mode, one byte (u8) is used for hotness record. 5 bits are
    used to store time and bucketing scheme is used to represent a total
    access time up to 4s with HZ=1000. Default toptier NID (0) is used as
    the target for promotion which can be changed via debugfs tunable.
  - In precision mode, 4 bytes (u32) are used for each hotness record.
    14 bits are used to store time which can represent around 16s
    with HZ=1000.
- Classifies pages as hot based on configurable thresholds.
- Pages classified as hot are marked as ready for migration using the
  ready bit. Both modes use MSB of the hotness record as ready bit.
- Per-lower-tier-node kmigrated threads periodically scan the PFNs of
  lower-tier nodes, checking for the migration-ready bit to perform
  batched migrations. Interval between successive scans and batching
  value are configurable via debugfs tunables.

Memory overhead
---------------
Default mode: 1 byte per lower-tier PFN. For a 1TB lower-tier memory
this amounts to 256MB overhead (assuming 4K pages)

Precision mode: 4 bytes per lower-tier PFN. For a 1TB of lower memory
this amounts to 1G overhead.

Bit layout of hotness record
----------------------------
Default mode
- Bits 0-1: Frequency (2bits, 4 access samples)
- Bits 2-6: Bucketed time (5bits, up to 4s with HZ=1000)
- Bit 7: Migration ready bit

Precision mode
- Bits 0-9: Target NID (10 bits)
- Bits 10-12: Frequency (3bits, 8 access samples)
- Bits 13-26: Time (14bits, up to 16s with HZ=1000)
- Bits 27-30: Reserved
- Bit 31: Migration ready bit

Potential hotness sources
-------------------------
1. NUMA Balancing (NUMAB2, Tiering mode)
2. IBS - Instruction Based Sampling, hardware based sampling
   mechanism present on AMD CPUs.
3. klruscand - PTE‑A bit scanning built on MGLRU’s walk helpers.
4. folio_mark_accessed() - Page cache access tracking (unmapped
   page cache pages)

Changes in v6
=============
- While earlier versions included sample implementation for all
  the hotness sources listed above, I have retained only NUMAB2
  in this iteration and will include the hardened versions
  of them in subsequent iterations.
- Cleaned up NUMAB2 implementation by removing the unused code
  (like access time tracking code etc).
- Ensured that NUMAB1 mode works as before. (Earlier versions made
  NUMA hint fault handler work only for NUMAB2 version)
- NUMA Balancing tiering mode is moved to its own new config
  CONFIG_NUMA_BALANCING_TIERING to make code sharing between
  NUMA Balancing and pghot easier.
- A bunch of hot page promotion related stats now depend upon
  CONFIG_PGHOT as the promotion engine is part of pghot.
- Fixed kmigrated to take a reference on the folio when walking
  the PFNs checking for migrate-ready folios.
- Fixed speculative folio access issue reported by Chris Mason's
  review-prompts.
- Added per-memcg NUMA_PAGE_MIGRATE stats accounting for batch
  migration API too.
- Added support for initializing hot_maps in the newly added
  sections during memory hotplug. 
- Default hotness threshold window changed from 4s to 3s as the
  maximum time representable in default mode is 3.9s only.
- Lot of cleanups and code restructuring.

Results
=======
Posted as replies to this mail thread.

This v6 patchset applies on top of upstream commit a989fde763f4f and
can be fetched from:

https://github.com/AMDESE/linux-mm/tree/bharata/pghot-rfcv6

v5: https://lore.kernel.org/linux-mm/20260129144043.231636-1-bharata@amd.com/
v4: https://lore.kernel.org/linux-mm/20251206101423.5004-1-bharata@amd.com/
v3: https://lore.kernel.org/linux-mm/20251110052343.208768-1-bharata@amd.com/
v2: https://lore.kernel.org/linux-mm/20250910144653.212066-1-bharata@amd.com/
v1: https://lore.kernel.org/linux-mm/20250814134826.154003-1-bharata@amd.com/
v0: https://lore.kernel.org/linux-mm/20250306054532.221138-1-bharata@amd.com/

Bharata B Rao (4):
  mm: migrate: Allow misplaced migration without VMA
  mm: Hot page tracking and promotion - pghot
  mm: pghot: Precision mode for pghot
  mm: sched: move NUMA balancing tiering promotion to pghot

Gregory Price (1):
  mm: migrate: Add migrate_misplaced_folios_batch()

 Documentation/admin-guide/mm/pghot.txt |  80 ++++
 include/linux/migrate.h                |  10 +-
 include/linux/mm.h                     |  35 +-
 include/linux/mmzone.h                 |  24 +-
 include/linux/pghot.h                  | 113 +++++
 include/linux/vm_event_item.h          |   5 +
 init/Kconfig                           |  13 +
 kernel/sched/core.c                    |   7 +
 kernel/sched/debug.c                   |   1 -
 kernel/sched/fair.c                    | 177 +------
 kernel/sched/sched.h                   |   1 -
 mm/Kconfig                             |  25 +
 mm/Makefile                            |   6 +
 mm/huge_memory.c                       |  27 +-
 mm/memcontrol.c                        |   6 +-
 mm/memory-tiers.c                      |  15 +-
 mm/memory.c                            |  36 +-
 mm/mempolicy.c                         |   3 -
 mm/migrate.c                           |  88 +++-
 mm/mm_init.c                           |  10 +
 mm/pghot-default.c                     |  79 ++++
 mm/pghot-precise.c                     |  81 ++++
 mm/pghot-tunables.c                    | 182 ++++++++
 mm/pghot.c                             | 618 +++++++++++++++++++++++++
 mm/vmstat.c                            |   7 +-
 25 files changed, 1411 insertions(+), 238 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/pghot.txt
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot-default.c
 create mode 100644 mm/pghot-precise.c
 create mode 100644 mm/pghot-tunables.c
 create mode 100644 mm/pghot.c

base-commit: a989fde763f4f24209e4702f50a45be572340e68
-- 
2.34.1


