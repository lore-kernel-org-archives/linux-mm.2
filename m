Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A90C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56606B00A6; Wed,  1 Jul 2026 01:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0206B00A8; Wed,  1 Jul 2026 01:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B814E6B00A9; Wed,  1 Jul 2026 01:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89D7E6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:17:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE64F14020E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:17:53 +0000 (UTC)
X-FDA: 84939050826.01.091AC06
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011053.outbound.protection.outlook.com [40.107.208.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB80140002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:17:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="rDTb/oIF";
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.53 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782883071;
	b=Y47zbZxRYVqfkDZ1TmZYlVfJQQdP782BK4I3uQeNnI8F1YEBsPIhAby0kjbB1zK9oZKDqN
	pKvvlYNVMhb+rEGOPuM1Hp5l3l6Tr3VhDo+FiIaV6FKgHIY4GXUAWo4b5ryw8g/Clp9zqc
	9jrrd9uU3WCZuUqsBFA2etAD4o37y9Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782883071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GZog7IZ10IBd+5GoN2YMxxyXDwLKq6/QBrVn+I75R00=;
	b=ObNcive8s5CIUEAVrqd1j43/8gWL2/eYQ8IQfiTKTbgamL/N8yz4J2cddI/UzGs0FujK4w
	EQh/Fb1UwoZs5meDkAyExxS8L7sejwuNO8ICzEDTM4iNjiS937L16wcrYkl69WvagE/AkY
	aeoqSfoZYWhaxNIOWCbC+00qNzrXYc0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="rDTb/oIF";
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.53 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgbArFIfAKSLOaZgXjgtogcbgevQj5MZWidvmU1wu6rLsuhMEjZxKTXKhqtHHizOgVAaQfBNltMHHGKd6bsj5j62xec6yG01QPmE43OB5aBZfSOjzewJ8vI2Cp/GjYxXoFlDXIc4i9tjJelRWYYk+zFCrOPZotvSbOpjzHJqitd+ExScjTsundeLydxlQbL9f3MyxUatIHWi+EyyN7OxTWzFQnJUYpCiYP+A72VvPLq0Bzj3EyUkS7EivTt3hGj2cdcbgV2UtfrjTZJWDlkEiHih9rD7uAvEBEy3ci6N36jJKdE3aNknDUKUaNeS3kur9KkQG9X3C5ozkubWrQX/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZog7IZ10IBd+5GoN2YMxxyXDwLKq6/QBrVn+I75R00=;
 b=JMBQGVvQXffPSbxRO4toI9MQcP9O8v3hNYmPkWZhqVvri3CBc2wj4XwbsP8oBCkPvUzKeDVX/44CARuVfFkgoLIhg97bPb4nChxRg0pKJs65Xqnd/E9XffC0mN0CEL+040Hm0FtVXGxYrWKbuCplaUecOq+pV9d8uDLMjdC/do8G7aof7ScDeEZHOaprN1qctM6haFv4aB67NOQX2j5gItdSm2exE9g2YL6vxX/BNDrSnsurI2rkWY8hpuUH223rx2asLKGgm1YVchl9F/4AntD8FxetQUpacjWMwe97/Baj1cBgpZN/cNLqMN2mE6xZj8i7tXfQS/ZNsQliRTQ2fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZog7IZ10IBd+5GoN2YMxxyXDwLKq6/QBrVn+I75R00=;
 b=rDTb/oIF5tKAbSgMnxo9dGO9aAZEYnnT6CtErmGKT6od8p98s6QyZDIhPRV0R74TW0KFCqjFqV9rdcabHGVG4pCVP/6ZqQ5zLb4S03QZ4aBFhUrQJ7Gonxz/KG5/vvONoB9P3tFDPBjFRRvI/df2Emfa7WYRFbcs2uvkwhf2sWA=
Received: from BL1P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::13)
 by MW4PR12MB7016.namprd12.prod.outlook.com (2603:10b6:303:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 05:17:45 +0000
Received: from BL6PEPF0001AB72.namprd02.prod.outlook.com
 (2603:10b6:208:2c5:cafe::43) by BL1P221CA0025.outlook.office365.com
 (2603:10b6:208:2c5::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Wed, 1
 Jul 2026 05:17:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB72.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 1 Jul 2026 05:17:45 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 1 Jul
 2026 00:17:40 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH v2 0/3] mm/migrate: preparatory cleanups for batch copy and
 offload
Date: Wed, 1 Jul 2026 05:17:19 +0000
Message-ID: <20260701-migrate-cleanups-prep-v2-0-d9e8f17130b1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN+iRGoC/4WNQQ6CMBBFr0Jm7ZhStA2uvIdhMSkDTGKBtNhoS
 O9u5QIu30v++ztEDsIRbtUOgZNEWeYC+lSBm2geGaUvDFppo4w26GUMtDG6J9P8WiOugVe0lhT
 1zUU5Z6BsixzkfXQfXeFJ4raEz3GT6p/9V0w1KqT22jYNDdbU7Z18f3aLhy7n/AUntFQ9uAAAA
 A==
X-Change-ID: 20260626-migrate-cleanups-prep-77a0ad340cc6
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
	<shivankg@amd.com>, Dev Jain <dev.jain@arm.com>, Jonathan Cameron
	<jic23@kernel.org>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782883059; l=1181;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=ITVPY243rOlJ65p7e3wTbwlvqUE6QmPRsv7QWF5PLC0=;
 b=I8XpUpSMpIro15rzFVTl3E7WVKGzkR5gfRoBHU+PQDbAMZzOcvGT5aZvQMYBhvTX3WPXEIczz
 mojMLI3u/whDHJUTDGzk6jZshdw/ns87DqGzn6czxtfsWI+oB0Pi4fH
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB72:EE_|MW4PR12MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: 97ef6619-c4cd-41e7-ce2e-08ded7301589
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|23010399003|56012099006|11063799006|18002099003|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	1oLIH/Z0sVGxYs9L3CP+LCQwbQ2s7x1ijN/Le3WWT0QBtFIKS09Q7i4RWkMGeBv4NFQup6NisqaPEgViMOEW4I3GyJbHA4RvBzCW+MVeyl6Wj1JvJiJDJpkgCYY7s8PSl/yrLm+jqIj5Qcl7Q2SBiG1ABz7a3FscxDkJmBK5ePw9NrL6+q+9kaJd8018zqkebYktT7BOrJlXsgcu1P64ZxQEf5a+hS9wHWY1l91bkTkyTfRIvzXqCVUTpLqKu9YFBFMmRqNrkEzlE07eiIHPsjR5e2lLBakwY2Ep/g+NP6syTdVq8W2Ch7rdbyrVUTgGe3Ul3slYatAkUj6TNyGbkgqNBs1WcnaXK/xNr0esVdaeByHZtXLgamgWkTDYuaAmGDfWa/8C02eB0mQow/XOOQkVPPICPBVx2slNTaNojWEZPO2Tt+n+l4QGk0NphU1sEDxSxDBZbim0fTuSDIw0EWTvyrX/DO8jewsRkgMYBcHqL05TEFXMCvnX7bu4VESHeK6z71Be0d8qQSQLHyb6w9Dz0eS32PVMW3TNRZw4Uo1vKoMCy5rkCMHIhx+M5awoTd2BSNDr4zKzHrSR9eKKymofcdaKnT6/lMNZKq0Vr3jCyQDBZh9ZH6YS9JJimT3i1tbFt52KFNNlvQhdIE2U5yvG4GbF2SLVTRBhXMaiF13hpiupBkIzX9YUTSy9GoMHszKBXipcWWmCTfI/oJOnW8Q54oY2QOj4lKRSbxDa/1XUzgGgtxuRCDfMQiI2JINL
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(23010399003)(56012099006)(11063799006)(18002099003)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gP8J027Z5R9ZePKHk7Lq5HfrFppsly6Ihk+ikErhyYwAISGSE1kBJn9vupZZbqookhLbS5CcSF3UB3+w0gYHVXhR8S2HxQK8XaHmNOraQJxku1x63rr2JzMWGrCfTJGe8mSF2Nk3g2CmisN4xtcJk4vnarQ3VPEt6NFEMzj9HTbWzvcsUICtPAWYPgE3ejL0+mODzvH6Q0T876BwvxA5klyqJ1F/1gcHmVp1H006Bfpq6HXXkXKI+hciSOX84EAp2fOEn1chGom+pX6+W3PnBwyj7VnO3bx2ngOvaouPiUK6dyyUjbi6oee+F/ebrAC3PI+63++xtpL+4IUT9XBAirvTFyaJxTKYj92EkudFqijifCP09eY8djHEUsf0vXfcoa4M1smkjuFaZcKkXgEUYBTRsgPGk59hPMRhBqG8wemfACxgNLrqG0F4yoLrBRpq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 05:17:45.2508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ef6619-c4cd-41e7-ce2e-08ded7301589
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB72.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7016
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB80140002
X-Stat-Signature: bwr5yazw6dx5q9w94ziesd6tc9zr64ew
X-HE-Tag: 1782883070-468099
X-HE-Meta: U2FsdGVkX1+Ai2l/my5VDECrlPqhgZVpCtJzPEoHYH7+OvgUpCyUj787BoOBmSC+uOownfaq0+MDNOdxD1Rp7uCclKTT/evNvYW/8SxRqmm2gR8W7moyHyOwBkYX1+mP9zptb7EiO1z85KgXEipMMxWT4AyI87ZSTy/MTVfnYcUQBNcefl2joctdIqxcmBUL2hE+Ux0Ylx8Vzf/pZzqEoeoMAfZtNvkcMTiNgQDFDGVYTT+gBQWMS8MCGi/gc9VUE+tkk+iKsdNscteCV5UI3J/g5VYufO4kjbsDNV+8p/QSOVaxOWB4cwc6wWnBRg58FEZUU3Ly1l15hhkI9T0m5VPOAb4//pp04uVkEmeIyHNsONJ+KKXpRvdN0w8pMvGNauf9rhtgO5jXKrEIpuLCra2zl5FFO4YOerk4Q+hfon0JH0UVdqzp3RueBlB4CTX1yc3o/OP2qqbmFiKOlKKJp85KMJQV8m9Cp20j5HYhiYIN2/9hp1/mHf7pAREpqZBouAK9snglAsNOR44Qa8i0/m8gHhPL0uzKqPr1ajNVChyTodaEkvWs0QuvcbVP0gzPFR5VzyiVHYxFSFYJZ0pY2VJGB6BZSlzbEs2XIHIG0ZzJDz49O0hYgqTCT8fkZT5DXKSIpBp4KwbhoJTGfAvKpDwBjAbdM+l2V4mcu3Qxqbaj6HGmtoiQMNG8q5s6J0NZVqYVGz7ER40odHo4PWpiOjC2znwGlmg/OlLu5Oy6GByB4zQ/z6lHqix0IgqmnpeeuRp4iH8HJCfOb+/hUNHjQj+JU/9dpMYyf1Pfgt6fFSmPRnZ+l114y5Ocgy7EoSkq1mEFKImJea7I5dWT4m55mPapp976lPZrMox11XxpQsB/+jMnHeOomQUmoMDwcWokMADUBQ2ACeCDuwVfsRtMZe+A2tVhtanpujUH5CPfTPHl6L5IGdoz8QM3boJYULHn8CfnwKXkhOgqj4Pp02M
 WCIwcdKd
 Br24VRZjlUaL3g8i/VrrbIys+EwbmjfTPt1OOY+rq/F+3CYMsDftnt7HdKP8iPTMVIQcJOLdD8O1sWfJTX4jrENMWVcNcLyKskX3wjIP8XRCp30I3S1ZwAkqoUh8B3jZhlM159Swz1p1uBKq/G03pgYb3yQQz+0QB90jZHYA1EmSFmp6vd2xaCRlDWoclPcQIDUF/+DRLyry7ZqcC5dr0hdxeRd043CM7+5aUfJ/ETzp32KrinkI6do4iUeVzSvAjrQYdNbUWy5M4Ve4ZfPq15IrsU6Xh6g3aUGJ5fUWovlWuqHD3OFy63FY6vGVYpZzTOZpdJj28shgUWKD2v8DvPK4wbhiWul3fCXOybReTHOX9Hwn+t4XeYAO/0dM4wlD2O8D5haQMznAyRXzWjI5y3qcPZ7pLTNnZ6SXHyeTNqxRRvT483CQ8GbRTtvNLJ78HWCD9cdH7mQj2uued/4iy8GV7rLFvOK612dGvPwvw2EsnhgKrNRVKtht5bYz8zvZP+1iv2qlCOHVFjSDvVAZcsSRzFsr7pDnKhJpCTK0ZryYNlBOoPKWt7aK3PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a small set of mm/migrate cleanups split out of the batch-copy
and offload RFC [1], so they can be reviewed and merged independently
ahead of that larger series.

No functional change intended.

[1] https://lore.kernel.org/all/20260428155043.39251-2-shivankg@amd.com

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Changes in v2:
- Rename folio/page_was_mapped to was_mapped and unmap_and_move_huge_page
  to unmap_and_move_hugetlb_folio (David).
- Fix stale "page" wording in comment.
- Rebase to mm-new.
- Link to v1: https://lore.kernel.org/r/20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com

---
Shivank Garg (3):
      mm/migrate: rename page to folio leftovers
      mm/migrate: fix stale list name in migrate_folios_move() comment
      mm/migrate: use migrate_info field instead of private

 include/linux/mm_types.h |  1 +
 mm/migrate.c             | 52 +++++++++++++++++++++++-------------------------
 2 files changed, 26 insertions(+), 27 deletions(-)
---
base-commit: 15654b0268cd65b4e673510c0377774e61b86397
change-id: 20260626-migrate-cleanups-prep-77a0ad340cc6

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


