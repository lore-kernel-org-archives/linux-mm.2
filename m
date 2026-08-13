Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD67BC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5816B0395; Thu, 13 Aug 2026 00:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ADAC6B0397; Thu, 13 Aug 2026 00:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3496B0398; Thu, 13 Aug 2026 00:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 669A26B0395
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:24:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6EFC804F5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:20 +0000 (UTC)
X-FDA: 85094954280.26.3D30681
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013028.outbound.protection.outlook.com [40.107.201.28])
	by imf16.hostedemail.com (Postfix) with ESMTP id B5841180005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1pQxI1Pj;
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.28 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVf5yo691MlmhIFP/C9Zo6yzsQASTr3Bvaov1srUftQ=;
	b=DmQVChKM2eN4pff5689aA/AkjE/yF93VV+Cu12NUMC9NoDbCw4/IUfmPpjujQWAzVo3JIz
	86daaJotT7gtJAzIh0VwF/8ZfNfTb4qtp8OXtTOl4mFJJ1K2lKEEhmewyY2Pc+R77Dzx0B
	snlkiNapmKF9Sf9G6C4G5zu0HaFsxAo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786595057;
	b=YhjvvhJBjANV/43yt04ZcOicDc3rnhkSjcVmza5WdAk5eIxbqXrW60Ea6QrOJN0arvvs/T
	Yhs5UKAHL5hT+AmmjrQnzt2OwLcabVcQA41tOTY/xE/FpfH3vbSPkaWzveJAqcjKMif2Ji
	bc1Gv235Bm7Wrk6BEwih/ptqR2PBEVM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1pQxI1Pj;
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.28 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGfxcekwkJMyh3XK+LfkpSDpa4MmsBETgK1eo0DQj6bxqvoBQdyNyTFbIeCR+6peK6DBQLak50pA/wAG0y+Nhoa6gdSRmTTJ5rtMUP+mmOsV5IVwE0T98dGJI0od6vhgVs92Ux9Z1TLAe9boNknFuAfz2JY4EHz+OCEYMOiXl2GA05lwWrBtKttMB3gZsMZ0M1YqvlvhIwAhgNKGJmQqOP5+XHyzojVbHOvxvrOwAluLMQIbN/JpGbVX7jnmwMJ8EhAtWhqVSYxv7cAJn2eitNAMlKRSnduCAZpVHdcb0nH8jt/cON6lrrIgzraEgvpjxr/CgfHwdaauficQOVBZTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVf5yo691MlmhIFP/C9Zo6yzsQASTr3Bvaov1srUftQ=;
 b=e5rJUxjY9rrWpISdKZg8qzDvjgHmubZdBwz48RHWueF7qBspDURnS9CHt2j7UlSwKxjRKJOV3QSpMZzt3+xnXbsWswIlJDuMIC9GWJQbpcKPzWMxeeWUVbeJ5alIMSIRar4W9eksk6XiSVxmscZmOSsBpBrDK7MDYxBNyycR8JCJ+CIblVGMCPsAhIXLJRzao3pXASjqjb0SLzf4KdAFxP+dg3sWtMR5I9hZL0XMs5uEtqLalgzm0pPi4eEk6fLJk82U6/m8WHFNittFD8E51GrS6gJB0GWXKjSRFpjHPJKBwoRI+t7X4BG0aj5RTuduAdSKfMAswhCbwOMtntBlwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=surriel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVf5yo691MlmhIFP/C9Zo6yzsQASTr3Bvaov1srUftQ=;
 b=1pQxI1Pj2lKuORNLS4K+GswW4jMj81EG29w4+tf78U5RUqWUgFI/pN0z1tb+Ka7c/zZBc9RGKI2G6pkJJtcWjWDIlx2huvdmqoqSB89ssDu0rmESL/by0E895Wh91o4GcvaE+YD3ho5Snz+24s0lW2ITV7lBl7/+sSHqnAgvXEQ=
Received: from BN8PR04CA0047.namprd04.prod.outlook.com (2603:10b6:408:d4::21)
 by CY5PR12MB6132.namprd12.prod.outlook.com (2603:10b6:930:24::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Thu, 13 Aug
 2026 04:24:11 +0000
Received: from BN3PEPF0000B374.namprd21.prod.outlook.com
 (2603:10b6:408:d4:cafe::a8) by BN8PR04CA0047.outlook.office365.com
 (2603:10b6:408:d4::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.12 via Frontend Transport; Thu,
 13 Aug 2026 04:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B374.mail.protection.outlook.com (10.167.243.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 04:24:11 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 23:24:01 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 13 Aug 2026 04:23:12 +0000
Subject: [PATCH v2 1/7] mm: factor out generic PTE batch detection from
 swap_pte_batch()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260813-migrate-rmap-batch-v2-1-3c5424c555c7@amd.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
In-Reply-To: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
	<riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786595034; l=2122;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=Cxu9ELvKmplpElna3JI88TGVrIhnPavPEhcP1F10lYE=;
 b=hUlCPlvLE/GULh4fk/h3JpprlQXcCH/R+38RKBmsk8G0avdiTfmqgwLZd+ESs8NqhZRmLw2Vq
 oFZi8XA04ksC/qUBYK9IKsSAFUuiciZeOZLnx4zWuqVZx7ofXCMYlr2
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B374:EE_|CY5PR12MB6132:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e95d8c0-6e58-4184-c813-08def8f2b9b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|7416014|376014|10067099003|921020|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NnLZSNR02sdKmqwSle1M/Ha+MPd0/JUmmdYloEvycHUPIk7T4hdPlM4J1sxHDMYG7d3+7zx9xIDdMvwrDido7VwpPHxD6KBICvYgk61twwrc7aRSY337aEuoDddgBI0hg2JHFdyUlm4B5TRx/PGo+Q2hhtZ++oQBcFZcPNgD3XCkE6UKAu1A0Wr67T5fXjbLOTT8t0UABQ3oK6Zmf2Bh+o0GEztGybm5DxI2II39UcRJlTklk4iMsdMH0v7JsxbGQdPVeZdajdygJmn1h/AvwpxU+KtBg4dNESkpbtu0NmJDpQ+VpsUPK3uN6vyyvjSM+AbjH//KUmz27k9eg7fL0ELgUJJadmvhRL6GefdEXAmiGky/IKSnwZFLyssOerHg12959k5g2FYeCi+PRliaPTOd1SzNh3m+lhGKpaHuEeaRJBkrL20yeCp0FeBjH6GmJTpFuzOLuXJ1y1Hw0ihhhkXvaIqsuMOgjKCwDh2JmKkJ87CN5H/qJTpceeeA0MobiYAi9AVithJchrvajou8v1Jv+2lK458slwa4eAL63DV5eGHoc21Z2AtZFrCsV0Akhm1l9aktxMXjZuPAqfrl+RglokR5aAbRMxVVLEi/QU7N+bbnRegX61gNRsCJ8uga8NsqFRsA+oDQMVf0E8thQL/aE+5NrF/MwM3CwCb4oBCLmgLgkIW8VcE7rIDt/Fdr5uTkCiip1GSSMGn/uqGcUtvXonmfzhZ/kYAKuKQ4TzU=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(7416014)(376014)(10067099003)(921020)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h7BV1CY9wTu5ZpYpwVTcdZHW2lJAbAZBEG6mHHuZTXpUo3gvZD+3a6M5FwJmoAr3/bKs8BBPPYhbIwKBKowEf+VzuZCAcvxNoPifYZmZwTt9TY+TJTBmRCU044z51Sj8xTg4iusLQW7mnIjuliF+TA1wPoNj6aYmnoHaaULIXt9Do4RQ/X5nd0/Il9MCS2HU+ENZB9Yqyb4LtgisgUKzf5sqix2hKoCtVgVpGQdTTf4gi9yJsR6Ihr9G+c1AC8kBLgvl64HKvP6H3Hj224ghMo2XtHZ3o8zVVrc9ug9VSMGnr82e18dABeemTseQlGAmwzeNuebZXw3T7Y9H5wrfg2VinLnAUUbDU9T8I8ZR/J7w2gUmFog+1UVKqnQeWT0mxaMN8kWCIbGLWc5xzRNMVM3vrkXx9Hw8wuy65am/qogpyPezJtFe+3lhzASC1svH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 04:24:11.4244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e95d8c0-6e58-4184-c813-08def8f2b9b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B374.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6132
X-Rspam-User: 
X-Stat-Signature: aczfg6smzryupkkxghj7uhh9tz8kpd1n
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5841180005
X-HE-Tag: 1786595057-561270
X-HE-Meta: U2FsdGVkX18WkmFRb0oefpQSsN68aNrFbE+t3V1EXODkDEH7Uy+0JB9z8StYJsCigJ9dTtTRoo6kTvMdH1/0yHkT7qgC8csc/lqHIK79m8VSK6qgqcnyeICLAPlFXkNd3MSn+r8yswCZjRCoXfdZ8nfS+P0XqXppHsWyJzZTQk7khK+/x7u7mFn9a2f+7IU0F/GZeHmuYQAV23tJK9iTsA2YpAJNFmQid+QgouBv2KObmCRsvtV7oDWA9itUNEnEAjKkuHYP37HNipISTQn9/VMHiSLrAqIHg6q5dVfw29skZQi74JjDcJq5KssLlcc5/P+ON/pcaMLY7HTqInQLmf/mgAHkGaOP9TIzgFgSokCGKxDCL2TScAB/Nh4yDSGcAf5ECi7vNuCT/UoANRi0fRVC7S+3ZYcNEr62gJRSZgj8AHi0VT0cX6zslX3gzzRvo9XgzIeT5fSAhBnrgSHhBVsVf/Wm2PQ+o1YuKkozBYS2tboK0Vasdd6LEG1KjREUNW4ljOhEyNDhLN/lpvYQ9J0zAlTOMSE6U3HiU1sJYjXsatj3Z+RiCTANGMZ7FOyZpI9THsi/SmCHl8FRglgfGNziMrgS9OzTfn2I5AME3sxyxJl6By6RMvCpfW9KmJPdpnP2US8zfvq7zTu4VFs7lYGzDNlMO1jfPq3ZpOJVJrCHT9RWuMhraJTf200LmPEh8SxzQp50giJDJ/ot63pzz01/LPKAzhJJxWtzX4En/+Z+vti3rzEMhiPBoZc+4PUanBM8eS3FMSQWLzVqPfEyPueIpxAiYVGdlX/RJ7lL8xUBsp17lSTT+ZYnw4dvLQKUt1TMqSn+w1ictJBXABYEWEsfB8R+vW0mE84ktz7Q6OKOCJor0Fq+3zFrkWbwsbGtdDT+QRcUulcfOB/4WxkGFWDDHUoFYP41XmejiXt6m2t2ptOnTRGluvIEZ9hMSlmz/TtNPj171wRG3Zl0TRh
 Q/afPVsT
 StfaVIY5JafI9ERoz2sP8sveVgyS1Z7yCOdNhnfoAvmDVMKkRREHQHXnY7r+XhKRoRrsOcxi28bAVoRL7HbtsE92ZYaOoL9lXtlW+th4D2uBVmGKDcMrd5oo8OGLH10XeiSdEVyI+scfllqY/HWwZZrN9O9LZN1FIwDze8PUllFwvV/Jztzv9aMd7+yZQHcyseY7rPVG75PTxT7Qc14+I3cW+jRbCbgKKDe8HgX1T/7H/k+5i3tKB2HJT+mJHTJwak+pa1LJKUIVPJuikdTgkaO43S1bYCPCU+LfcqmMQvjKTrL7puBoCuLD6ymkZxOqiQ+UUyJpTPrZxixvmBgJ03byoiVSc2Vcr2+oK2+LQ640XuWsTZIzfvS6LHgn/4keoaDqDclMICiJuZ7bl7zE+VOu5H9nQEuOXJ++nG0Aoyxi/VlBcU8Us1+kpIXptks8ZUieL43pTYxaTlChOdpphEERxk5TDBLZVNBWD+MoXn62hJXoWTEIspeGYElbQKUh318BJBxN7eep0RVZGf+v++pQPkPak//gzkPW0fNIshS8WuKSp7y9Ak+uBe7cUt0gfKtrfTI9FqYt6WOpGRh53yqCJBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the generic PTE batch detection logic from swap_pte_batch()
into softleaf_pte_batch() helper, so that it can be reused by upcoming
patch that adds restore-side batching of migration entries.

swap_pte_batch() now keeps only its swap-specific concerns and
delegates the batch detection to softleaf_pte_batch().

No functional changes intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/internal.h | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a5d0488a54dc..1e1ab53b642e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -560,6 +560,26 @@ static inline void set_softleaf_ptes(struct mm_struct *mm, unsigned long addr,
 	}
 }
 
+static inline int softleaf_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
+{
+	pte_t expected_pte = pte_next_softleaf_offset(pte);
+	const pte_t *end_ptep = start_ptep + max_nr;
+	pte_t *ptep = start_ptep + 1;
+
+	VM_WARN_ON(max_nr < 1);
+
+	while (ptep < end_ptep) {
+		pte = ptep_get(ptep);
+
+		if (!pte_same(pte, expected_pte))
+			break;
+		expected_pte = pte_next_softleaf_offset(expected_pte);
+		ptep++;
+	}
+
+	return ptep - start_ptep;
+}
+
 /**
  * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
  * @start_ptep: Page table pointer for the first entry.
@@ -577,23 +597,9 @@ static inline void set_softleaf_ptes(struct mm_struct *mm, unsigned long addr,
  */
 static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
-	pte_t expected_pte = pte_next_softleaf_offset(pte);
-	const pte_t *end_ptep = start_ptep + max_nr;
-	pte_t *ptep = start_ptep + 1;
-
-	VM_WARN_ON(max_nr < 1);
 	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
 
-	while (ptep < end_ptep) {
-		pte = ptep_get(ptep);
-
-		if (!pte_same(pte, expected_pte))
-			break;
-		expected_pte = pte_next_softleaf_offset(expected_pte);
-		ptep++;
-	}
-
-	return ptep - start_ptep;
+	return softleaf_pte_batch(start_ptep, max_nr, pte);
 }
 #endif /* CONFIG_MMU */
 

-- 
2.43.0


