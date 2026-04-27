Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABBF0FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B696B0092; Mon, 27 Apr 2026 10:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F32D6B0093; Mon, 27 Apr 2026 10:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008FC6B0095; Mon, 27 Apr 2026 10:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E33846B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:27:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 872B9120393
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:26:22 +0000 (UTC)
X-FDA: 84704561004.22.05775A7
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013052.outbound.protection.outlook.com [40.93.196.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 51F581C0017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:26:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RPvxd4xK;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.52 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777299979; a=rsa-sha256;
	cv=pass;
	b=FJ5FCcqVCs14sJJX0YF/HMRskPl11BGDRQ/fQOTy2AEBalhebkRk3mlJ7PtJpmRSdbhNz5
	evaNg8OvL9cHpOfztQa7tOkvIbnbyEzJYe3s5T84cYlfsI0b3uAE3o0hxl8xiTGfeRmzeh
	JM75xmuPaTWunnxsp2mFCuk8Ik3v6k8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RPvxd4xK;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.52 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777299979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJ0aMJ6q5PumEHrs3re93Z6hWL0nQNX+QntJkYKc7os=;
	b=hBgim73OF+1CR4rKwGFbyOEInXF8Adt/s1Ma5sK86NhL7vKy7xLsBuWIFJWH8cYu0Wr0Oh
	uJ7s3E6BBPse1HaUoKtbCAFTi5E7EvkNXmAOvYYRxHhf/H66M0yKMVIeXfFIYu8SAiC69Q
	N8UZYZYVhGmfo78Xbb3EM3hqwzbSyGI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YmsWPUf8AtN5UtIVwg9OHAOrxmG28ppQJigr+6PGzk/ZtIDkypXqcEAkat2MqQAA4/RouOY2U/emWoOgOHtGvBk3lcLj+a9UB/K2uRo3v3boAgckmDSG5P3sqbNyAUortjaocvT5iTCw74txxggRzLF8bW97N8typhuf0GBNZX+27CS+svvhAgowVel0m2zeRBY2nHtWDC8U5yGcQmW69MbJGix0xN1rI2/A79HpHV+zHnckbbLAShT6bJjRXpF3uPzI0cqn6fC+2+1YWwP892zeUc9f8kIDJh0Q2hPZoX+xhkh5TNAiAf6AgFWn/krOnIHy+21EsGXVVSXzU9QDtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJ0aMJ6q5PumEHrs3re93Z6hWL0nQNX+QntJkYKc7os=;
 b=sTBiacoO0RUQ4LM4QzfxzWwgCPD3uD2bcnkn/kFp3GjZoRB3FTmMyK8x4nm9Bwww5G4hOFaFjGO5OdNQZCUrsxEmbeMiCxGXeuUgwIhNyfAG3zYXdmCVZU1ru2OAeigUuLc15M6yoNIjuWz1e9xiSySTPEvUBhTQCTOObLvOjMvGEMZkMyAAllMg65WP21VdK1w5BZxBP46VamJ8LxJ74PURYrI9WQeJEL3NKxl7nTI+kAemNgNNxQFikmw4UE33dVGn5ikWVOkMA5wMUtZxjV2sy+dEwoxVcPgetSWMrkthmtOcvqWl/mxB0D1Kh9feNw6ZnTbGl0K/9VJ9K1P7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJ0aMJ6q5PumEHrs3re93Z6hWL0nQNX+QntJkYKc7os=;
 b=RPvxd4xKDYZhtSDKbZrxWFeQNUz+yJnqFQYHHz61wpuRhW6y2QlKZi43zCXhiVMri1x1pOe0baxAMdiCDCALhp2wayjClxicBgeeOr0pX0erJlxVu1c3Gm2OFjF2E/K9hHWx3TDUOXsCjOamRAa9O/gswazedQ5CUh9hjJ1XO/Y=
Received: from DS7PR03CA0233.namprd03.prod.outlook.com (2603:10b6:5:3ba::28)
 by SA3PR12MB7860.namprd12.prod.outlook.com (2603:10b6:806:307::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Mon, 27 Apr
 2026 14:26:02 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:5:3ba:cafe::68) by DS7PR03CA0233.outlook.office365.com
 (2603:10b6:5:3ba::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 14:26:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Mon, 27 Apr 2026 14:26:01 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 27 Apr
 2026 09:25:55 -0500
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ankur Arora
	<ankur.a.arora@oracle.com>, Bharata B Rao <bharata@amd.com>, "Hrushikesh
 Salunke" <hsalunke@amd.com>, David Rientjes <rientjes@google.com>, "Shivank
 Garg" <shivankg@amd.com>
Subject: [RFC PATCH 1/1] mm: batch page copies in folio_copy() and folio_mc_copy()
Date: Mon, 27 Apr 2026 14:20:38 +0000
Message-ID: <20260427142036.111940-4-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427142036.111940-2-shivankg@amd.com>
References: <20260427142036.111940-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|SA3PR12MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: c6a46e46-8cb9-4f61-535c-08dea468e865
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GAgcNw5pQJFNfkz52lBBo/UzZdYN8PtBLDCdvjcV5j0EvZ4GP8CJKnHTEXFkHNBUq/hxBX8msPFxYcRix/0CXg/lcOn5xwr0gf8e4BEkRVMz26jUlVbsiGyi5Sy0Hb3/bX5izr1ImDb4MDazF+VgQNd8FbN1dMLN2glzi4lrBV8lZSWLAMB3ee9ckjMuN4q7lC4PL88KnMyqz3rbPkf9fMVtLSp97eum/T8A+FWVRog6JwvsvuqLUq6qPulVbq/oLymiWQsYJgW/JV1DzzZcOhqwqV+NEg3Ebh7A872qZILMw2efGSPYRQgB0rUu1yLc0zcSTdpz9vxT/0VVNM7nPdsLYpkN7xCRR5W8phNQzCLubVqrKD0OqsLZdg201c20dL4UfJ4CfizaYjAp+dRJ2KWO2ZSaEC2ZJ0ptiwnI8h9JThMQFgev4qf7gck2VUM4QIogfcZMhvvAQgMA8SeTO6kg5GpngQvBx7Qfkzc1jZFLMAwfUyxpmCp0L3QMEDiWryoDyJfXYPM5SbtMJTurVUvaxR7wgf6NahWqWolvf0Ac/EG7EMEUCdCMY6kplAZ5JrysWWQ5489mP3g0zFsnnXPY0BVT3uAVRYZvWC/IhSKNANUBByhpFwm2uGw4G5jjlLh3V2ftPuFCVXrf0Ny806Vhx7gNtb7o0U1DuIqZKsQ6abV2xrfSX4KiRrCHol+a+MVu4mpXls6F5wi/JMoMy6TgsHxyTCH65zKuRMnLds4YBXOz1iE2sXqU4VkpZRqKpfdNI9xcvd5FvTkASZuu5A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XyUCBnoWBHuXUN3utbQj2pm3LuFDdaUhLUgjayJFAUS+UIGzc+w+Hv+TUOjhN4UKWtcRo+qNMqsLYyZy4ics1MFtNzG4pfg1EcuwempweDPfhRzbI0auUd18sIhdMomHP5kLFiUlCaUcsZhnv8QHXV6K7AoXmUjFv2RDrCMNnomOum5gYvZWpP0wCNogTKjL9WTRYA1/KgspZ41ovpWrLkLtCno/HvH1IWZsf7iIzp+3i3d/13oCgx7pnNeY1kaJiajPOOY7kpmg6et5Q3vRtxsfghyh2cI6C+nh0S5pIxAg5g1iuybD1sLTNxPEamomydVpRhd15to1D3bgwNjR+lUCkQX7iRAfwfIexIwr+I0C62VovjXE0WH5QNNleMJTyrTjLOkC2bxmhYwVosk4jdV7UbPW76iOFtVOURUpkM+CmyUInq2b7trHJaCW+iEG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 14:26:01.4811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6a46e46-8cb9-4f61-535c-08dea468e865
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7860
X-Stat-Signature: 55tp36mzy4oax85dnd3qpb96u8uchmkb
X-Rspam-User: 
X-Rspamd-Queue-Id: 51F581C0017
X-Rspamd-Server: rspam07
X-HE-Tag: 1777299979-189234
X-HE-Meta: U2FsdGVkX18Qmdkd+gNNGv+Bw3zFq7BDRharvxNWYBvn03HMSz8u3+O6nDx1PxT4FaC41nqL2byLguOPhl4ueIGFl2UH9YCw+atyX4ZOvoEHZ7l1kmL0cS2JRoYGp3coek6oTnvzYpghwG910nChxBl8nn30ky6BcJAoFMz55aPuIBChDvQQNmbpv4RZR88tGJEshW42VF2qRrrgExVTg5LAYAQd0zlW5lEhpS2jh7Q/fYgk5/3JdHHT+Md7NfiEpgclgoBNrMz7aV8oQIRlf0fQdXeLlWTKRG1P2uV7QooZzggSw7sy2dr6vymDblc54iRHAQkPjbT18/uGflBqQjxwgquwmt96sgawjnFF8r/t9z4eb/fkoTFMJv1U6Qdu8eDmW2B+LPRqlNU9eIHb6/yqLWnnz/prdlelbKjPwpDYFq2wheqVvL93NjDIBj4BhTrsPH/mbdkDjn7NgAapVJ6rraBIN2VL7yWxLO7hJS0uv8+0FyATZy+/LOQ6f7VH2sPZy+XLD3ERbNxI+QmxGsGMnkEMGOZZ0Oj5hwIAiHtn0pUr9wbhuU6cCR5GoZcllFwvUa9rmiSaRNthF/ROlmrB3REzdsaGnkdgOCD2a+kn/7zUeSpoBqbRxVsy+HfcqoIpiLet0IkIeEsUZHzefoZbNf4yuSGPikfBmuGgtAHm2A4oRQWBaOxoi1S5E29YhILam4+0Nd2C6ThS2tidMSoSLrwtjUKz6Us2WZpDze4wuCi/h8KtolUCN46QciCpuOn1qZSo8twyIKZ90CQJTMKo+Ixv3cxFVnUo9LrpAWmkRHnAE9iFlfYfHfftNhiLZqgHvb+yg3ZnYMXKr3eOpwUDhcOGFwcH/6TvXG514Ja3m9NlSi6t1YAbPgtg5kvpdPxBiYYjqJgqLtvoDUcjqolqthOThT+qzKGUSp/iA2JLBMGrkns+0HsQUKKv07PYa+qEVeyxLjQEtQidV3A
 YtRddGdJ
 efiSpXaAwtReh0CGGY8dKoPgq5LCYMtuuvCFIItmuD5BGQXRR3DbeIafbWrsKxLLwBb8Q6vGxIxD9frETRje0O/iPiwL9QVcyAx14dEpqvldJbk/Ik5Djx9ErOr/kxAL6cEZ2szGxS+KsTrmo/Glevur2aJyUg9ttaEy57DA1U780LIRB/+sg0tF8phk89CYXuramv82d/PE7I7Y3ubLVmdbnzM64QuhqAu+6c7BM2t/DYuFpT6WzMaO9yQu6mQ/Qr694qlUettUkr8HeW6aBWDox9xVKb/lmlqKdX8BU2tAKiV/074Ka494MmKm7igzFKGwl5oEIigJm98pg6gCmuMtuhnBmUoRcbZf+w+6Dv32yI2tGHfHgeyNKyzdq2TzIX+47mxGpGCRzrLV7BTFz4n+FiqGWldIH9qzQSkxqRQm0YhbmkJfPmaI7/aiFVRpKjvFbyau6R8x6U1it3g1R7yEmvDjusRijubLZ1iURtVNYIZKh7MkT65fwi7uXfKBHz5jcgFtJCwOkHrtqFQXPOISTQdxkdOUrepHr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rewrite folio_copy() and folio_mc_copy() as thin wrappers around new
batched helpers copy_highpages() and copy_mc_highpages().

The current implementations iterate copy_highpage() (or its #MC-aware
variant) per 4 KB page. For a single 2 MB folio that loop runs 512
times and pays, per page:

  - kmap_local_page() / kunmap_local()
  - cond_resched()
  - one invocation of the architecture copy_page()/memcpy() primitive

The new helpers issue a single copy_mc_to_kernel()/memcpy() over
the whole contiguous range when CONFIG_HIGHMEM is off and no
architecture overrides (__HAVE_ARCH_COPY_HIGHPAGE) copy_highpage().
HIGHMEM and arch overrides keep the existing per-page path.

Tested on dual-socket AMD EPYC 9655 (Zen 5) with a CXL.mem node.
In-kernel folio_mc_copy() microbenchmark on 2 MB folios, source
evicted from cache before each iteration and measured throughput:

  direction         baseline GB/s   optimized GB/s   speedup
  DRAM0 -> DRAM1     18.65 ± 1.37    38.03 ± 3.21     2.04x
  DRAM0 -> CXL       25.46 ± 2.89    39.29 ± 1.17     1.54x
  CXL   -> DRAM0     20.61 ± 3.95    35.07 ± 0.62     1.70x

End-to-end move_pages(2) throughput on anonymous 2 MB mTHP folios,
1 GB migrated per run:

  direction         baseline GB/s   optimized GB/s   speedup
  DRAM0 -> DRAM1      7.20 ± 0.03     8.01 ± 0.02     1.11x
  DRAM0 -> CXL       11.12 ± 0.15    13.07 ± 0.03     1.18x
  DRAM1 -> DRAM0      7.21 ± 0.02     7.95 ± 0.02     1.10x
  CXL   -> DRAM0      9.10 ± 0.05     9.49 ± 0.01     1.04x

On AMD EPYC 7713 (Zen 3 / Milan, REP_GOOD without FSRM/ERMS) the
folio_copy() bulk path regresses because memcpy() falls through to
memcpy_orig (an unrolled movq loop), which is slower than the
per-page copy_page() (microcoded rep movsq) it replaces. 
Same 2 MB folio_copy() microbench, source evicted before
each iteration:

  direction         baseline GB/s   optimized GB/s   speedup
  DRAM0 -> DRAM1     13.03 ± 0.76    11.59 ± 0.18     0.89x
  DRAM1 -> DRAM0     12.85 ± 0.25    11.02 ± 0.10     0.86x

Cover letter discusses introducing a copy_pages() helper to avoid
this regression. 

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/highmem.h | 58 +++++++++++++++++++++++++++++++++++++++++
 mm/util.c               | 25 +++---------------
 2 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 871d817426bc..daee3f1863d1 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -439,6 +439,23 @@ static inline void copy_highpage(struct page *to, struct page *from)
 
 #endif
 
+static inline void copy_highpages(struct page *to, struct page *from,
+		unsigned long nr_pages)
+{
+	unsigned long i;
+
+#ifndef __HAVE_ARCH_COPY_HIGHPAGE
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		memcpy(page_address(to), page_address(from), nr_pages << PAGE_SHIFT);
+		for (i = 0; i < nr_pages; i++)
+			kmsan_copy_page_meta(to + i, from + i);
+		return;
+	}
+#endif
+	for (i = 0; i < nr_pages; i++)
+		copy_highpage(to + i, from + i);
+}
+
 #ifdef copy_mc_to_kernel
 /*
  * If architecture supports machine check exception handling, define the
@@ -484,6 +501,40 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 
 	return ret;
 }
+
+static inline int copy_mc_highpages(struct page *to, struct page *from,
+		unsigned long nr_pages)
+{
+	unsigned long i;
+
+#ifndef __HAVE_ARCH_COPY_HIGHPAGE
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		unsigned long len = nr_pages << PAGE_SHIFT;
+		unsigned long ret;
+
+		ret = copy_mc_to_kernel(page_address(to),
+					page_address(from), len);
+		if (!ret) {
+			for (i = 0; i < nr_pages; i++)
+				kmsan_copy_page_meta(to + i, from + i);
+			return 0;
+		}
+		/*
+		 * copy_mc_to_kernel() returns the number bytes that were not copied,
+		 * counted from the end. The first failing page is therefore at
+		 * offset (len - ret) >> PAGE_SHIFT within the range.
+		 */
+		memory_failure_queue(page_to_pfn(from) +
+				     ((len - ret) >> PAGE_SHIFT), 0);
+		return -EHWPOISON;
+	}
+#endif
+
+	for (i = 0; i < nr_pages; i++)
+		if (copy_mc_highpage(to + i, from + i))
+			return -EHWPOISON;
+	return 0;
+}
 #else
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
@@ -497,6 +548,13 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 	copy_highpage(to, from);
 	return 0;
 }
+
+static inline int copy_mc_highpages(struct page *to, struct page *from,
+		unsigned long nr_pages)
+{
+	copy_highpages(to, from, nr_pages);
+	return 0;
+}
 #endif
 
 static inline void memcpy_page(struct page *dst_page, size_t dst_off,
diff --git a/mm/util.c b/mm/util.c
index 3cc949a0b7ed..93f0d9daffce 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -749,32 +749,15 @@ EXPORT_SYMBOL(folio_mapping);
  */
 void folio_copy(struct folio *dst, struct folio *src)
 {
-	long i = 0;
-	long nr = folio_nr_pages(src);
-
-	for (;;) {
-		copy_highpage(folio_page(dst, i), folio_page(src, i));
-		if (++i == nr)
-			break;
-		cond_resched();
-	}
+	copy_highpages(folio_page(dst, 0), folio_page(src, 0),
+		       folio_nr_pages(src));
 }
 EXPORT_SYMBOL(folio_copy);
 
 int folio_mc_copy(struct folio *dst, struct folio *src)
 {
-	long nr = folio_nr_pages(src);
-	long i = 0;
-
-	for (;;) {
-		if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
-			return -EHWPOISON;
-		if (++i == nr)
-			break;
-		cond_resched();
-	}
-
-	return 0;
+	return copy_mc_highpages(folio_page(dst, 0), folio_page(src, 0),
+				 folio_nr_pages(src));
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
-- 
2.43.0


