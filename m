Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CBBC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EEF56B007B; Tue, 28 Jul 2026 01:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F3F6B0088; Tue, 28 Jul 2026 01:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBF16B0099; Tue, 28 Jul 2026 01:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F67D6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:45:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDE4E1402B5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:09 +0000 (UTC)
X-FDA: 85037097138.24.ED89030
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5533B40002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=imLd631b;
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 40.107.209.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ca22w7ll+GJxMGnSJINXgnE+K6+MS66fTpiR7QavEQ=;
	b=JyDOALxe9Tkq1cRVE9vbGH4o58Zf3OY+0kus5yfAMAZG82iWnaB4k1chk5MYlkXRd+0Qaw
	nhTw2oKE1l7GE9aS9het+HCmmmDq031hfslhMcBooAE9K9u/iEVHZ+Va1b2k4aym6OmcWd
	kYvgpoBVYbU1t4+zCpnae1XfbCECdEI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217506;
	b=HrbVTqUt28HvxrYegdXOFMzhUY/UoFA3M7VUqM5D6g4KWr6cOZJGCaeAdA4dOU9yACMR+p
	YOHwF8BQUPS5C0SN3sCF5OVDxDQGvcyOMKKyHSZBMFyaUW5ZRZ0Me8KJdTxBecsi3rjcOG
	N7ghzRZ/aUW9/SHuDLKujEvU0sjZphA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=imLd631b;
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 40.107.209.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SXRNjq0Ytp6Z7X5ZYMWEsJjLrfYrUNeQ5ZagiBmkVcvSTzu4n8ts7dckkwqA3hLWE2zc7CWsHLj6zw9v4H2gM0fBWSCYrFpNSm94KSgu8BH4hKgAanlMpmjygm01MFWSrP7eZf+QSG8g1anCzL9Vl6q6Emw0/JBFQ5UTnxklyXfp+KSxiDpSPWpeLM09jiYSIzvD1xFFd288dob2BB0H8pXFCT7gKg0jhMmfyxub1FR1Qu5xOr50tPt3p02RXHUFrnXi47IJBV3O9FVI5Wc/wq+392rRS0TwimKaNMRC+RXTTn0clqcCrXzoy6onTaqYG2t94wkCpY0WV8Cq03lh5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ca22w7ll+GJxMGnSJINXgnE+K6+MS66fTpiR7QavEQ=;
 b=C5N3P+9GSTcgiPuboFMS2bMJVYc/TvZBiru9GnYCl5dUqVPxJXHR9W2m2+bzIBhsoDr14MfBo5I8aEeJPFxKtGP2ELd8TtvYI+VoP/dTpOovEk+3VBUUDfPvQoJy9yCayIme0wTCC3pdVQLhl7sPP9NwdQZxrzCVZEaeWPOV6BXNgGQIDckxKKsqYko/urxzOURq0SD1utxA8iFEPyPhExZ9FlRLrSgXGt+b0f2Bb2eO89OekiYM3Tl7ttROA93F6jKfTVdevLDDwfxYyguxCw/d5ERu5Sv4jREAgDUcSyI4icW9ncXgIv7DdxUHfLfBno0BwFsFTZ8sKxGCKyDV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ca22w7ll+GJxMGnSJINXgnE+K6+MS66fTpiR7QavEQ=;
 b=imLd631b9+chUPFHvYEYnzwJ/hDdF0SkxCOTRTYxkrW5BUeyxidIgxYoFtMFowXQLdpAKoLwmKvxR/rByVE4cgfDX4fKBmWGEV3vhIUH6lCtCz72dkkfCOMFpW8x7SoULuX8MfVyyy/MI4fyeRa8x60Ycxw0Z3Qlo5WyhGfI+kI=
Received: from BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::14)
 by DS5PPFC9877909A.namprd12.prod.outlook.com (2603:10b6:f:fc00::661) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 05:44:57 +0000
Received: from MWH0EPF000C6194.namprd02.prod.outlook.com
 (2603:10b6:a03:59d:cafe::9d) by BY1P220CA0001.outlook.office365.com
 (2603:10b6:a03:59d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 05:44:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6194.mail.protection.outlook.com (10.167.249.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:44:56 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:44:47 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>, Bharata B Rao <bharata@amd.com>
Subject: [PATCH v8 3/8] mm: Hot page tracking and promotion - pghot
Date: Tue, 28 Jul 2026 11:13:51 +0530
Message-ID: <20260728054356.291998-4-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
References: <20260728054356.291998-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6194:EE_|DS5PPFC9877909A:EE_
X-MS-Office365-Filtering-Correlation-Id: 689b10b8-b7f0-4bf6-8696-08deec6b5acc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|7416014|376014|10067099003|11063799006|56012099006|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6l66Hf8tjqMSo84gRQdc3xGtld2J0fj4pXs5+94908ywgCs6Sm7nE1q0kGG9mRQyY6nr40dsguFlEwZAWs0+pDMO6v79fGvRpKwc638gimQWG+T+hXT+yhx56bIXdD/svtAzWbY5vBBEVnYWYiebn3K1nrytmjdjWZ93sH1waf7D617vdpRDdCG+iIdMuZ1j6bAuRGgOCtcrg70OvTDRmbZeI85fUc0rN0ahRBXsi9UVuKuyxAbYR+NgYbm4dDvkDeuj/SfJXlwyJNn0jrtQ9UOLznvMeORSsk/LuGPj/FFRDM2M9zL5e0LrtRJEXbZdS0kiuDnH813sHCVHxUuu5qCrsUMysRgqhgsoMSZ2lkz363JvwzK0xbj2h/aYsQYdr+G2zbzSRFDIzxkS08VbRIDFfvVaopG0TeCQTpifLa4y0+Bj67z22+gMUZpK25zmaOqYLAp8pTTQ+acDHtwp9qbHzg5yDfeMq0n2SI0KNJAkhdSZ72q6jYKdp9VOnqWtpGjgaDRrsA1Hpzw3QR2+/tYSia/pbR4nszQi+Asr1Aff+2+QSPetvl460rr3dBMvWesqBgY0bCSw9d+SGtnZKH+gz0kTG42p/asUEX+echCRALkMqHDX4iibKJWz1QRGasTNoHgSVRSZUVILrnmY2plVpqSgC8wSf9Gni/UUzwhphGQWfiVx4okQBlCKqf8GaDsNjitVxJFHa15sTt3D2Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(7416014)(376014)(10067099003)(11063799006)(56012099006)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/OJwbeB9UdLIaya2UeAgU9rSufM8tIjnTAKFmRm68PK9Wf3icRKWWQ8v8HPRNqFM+Ufa83nNV1mL+fBj+VFo/NEjHykylHaNbfcAOgkvnbzfkjjYMlFJSji95xXkY2Vprrn4+0e9Kush2NUY5GdxoXRKr38qdwI4oAph7hqmlbyEuFK89zV8NZypPgbFCMcnHuu3u/V3CWyxhgMTznI0PhZkQti3BcHOfzV+lfqGhl2LhAv/RRBb9qAMaEbOrLwugvJYHvpZ+qqyMI+JE8abumJrb2lMe/gTM8I/R3OY0lv+Tx/zh4UhNKznhXpJ6V2X83e5NuS6cfEACiM8so6g5e+4a/vzjJ+v+2u1FmukBjUIvDV4FqhvkhQtem7Y5J8RuA1DZqA68+5F/szUfDNfnwaFi9HwKRFKrA4i7t3EHOfSSxGIQag+PHpRcGJcRLvY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:44:56.0856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 689b10b8-b7f0-4bf6-8696-08deec6b5acc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6194.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFC9877909A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5533B40002
X-Stat-Signature: ao7dfebqnpafe91jonyb4u7rziqo6p3e
X-HE-Tag: 1785217506-212902
X-HE-Meta: U2FsdGVkX193Zd+gITN53mGcXrefwBtCE7lVo4ZYhOnAPC9NNx6KTNVzXOCQfo0BkunBYUAjbblS/ffRU4i5RuGAV7Okol65NfdNGUOrnAlJA+7MjSCAKkjubM2OO9hMlmeSbzCn0+LrJXhSYduOuWbnKOA2+aMNUYJHi/ZoZIDl1yWvbxQyW/y0kPDXV0tnfCb4DJAZ7mnt55ccuwKm6zV3nExQ1aLe1Bdy0aW/tSaI9XRuM/zRU79/iedar4RNW5YeRWBGIp5/XCQvpRNGVmWiz/jKyk9qae1Gkc3jftd8S4i/Coyagzksh8ovEPeg58QqUZ+bHB5ftGVR0D/mVSjiNBmVMcbKqTGkQl1VcmLx5GqYMP2C3MDaWLYvUcBX5exlwfa4epZGsIjlqiv2HnKcu2HXuKoCbXPEJA3BVkiwArn/eqPh+/xH2qzZ1Q0DXge5vS3Xj9fXVEJj6SAysDgrsA/IMgShvHocOmvIdu6EcAf6Dte4JOeE9G/REl++HsDSEEV19tYe69KsvTxEfWYzvpSvh9hnGr0LPZM2OUPoyuaS/IGnsv/BaPlsqPPYWAi8Xlkk4l4gMD+TJ1IMn0Of6623oE1GgBcdYqpF+p6+yPLfmVAUtFvDnWVlER4oMce6LTwhhfb9fT+a7CgmQVfZQYYMauaZa/JwjWgJGvKrC0qCtsZJSdHpQY+TapIoFkGojmtBiBI480Y85f5/wWH+eMKsq/sWUiR2rE0XbhkXkCfT/IKFpjF0NwAj2NSGGVzCR9IKP+lRz12kim/DAVQwkYqJ3LsJQgu261pLJurtyr15VVLhRJ9UZSIF0sRbkMKG/iI/aBVnhcMv0OlH75E1mV32qKZGI9Up/Bfi7s3Y2jAO+QltQ7AeJP1fLOQC8HpL6T0Qbv9EM+LVGZkMlS1ZuJwPS8aTWlA+cGY9jhOxr9H2h4ddrptk3kc3Ayfm/T4w7rY0WNvHqqp8h2J
 tq8Sc+7s
 I8kN31ga2n4sCgTpnCgUCZyydZCKvQx23jxEwiNoNIjckLJPev6M6UsfuyuzDfdvJ6dYAt8ms/Hnv3Ua2CXD3q/24jHZsN9B0v1NkotoMo+4RuQ+gpSh2KycGOikaLUv/hs1ioNl0T7TlWIeGKHUVIlP6KtSkz3A/9KtUhJk+ohNX1DAm8Np329i+QaeEsS+BEDZOEpdtcZY7CnxqGs/1GGIrcNQjctzfhTeuk7MzE7KLh3h1Srm0CJuDRuutoq3ZN748LuG9uea5SDHocGUDgO4xcasOWOCAkmzqHSNn/u9KrzAI0drxDt0FCJ76erxq2BopnZyOjsAxRwn4CwgsGMQnsSGpPsJlCwyTWW4UwKtieWMHZqTVnm5he564O/u7HSDqbFJ5SV759xRoMX/7/wxpZM2KHmsmAQIhz41XkjqhOjb8qpHaV74qsPzz6BRaRgkvBBrKGBzea1M2WcuNEESZq9+QF9la5iN9Ryjov/qzW/gc8rhs0bYqjGGf/GGS7Tu5nALvjL5dofx7UqS6n/smWP3q5pC9M0JLMGtBa5Ln6hJFkx0uonHe3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pghot is a subsystem that collects memory access information from
multiple sources, classifies hot pages resident in lower-tier memory,
and promotes them to faster tiers. It stores per-PFN hotness metadata
and performs asynchronous, batched promotion via a per-lower-tier-node
kernel thread (kmigrated).

This change introduces the default (compact) mode of pghot:

- Per-PFN hotness record (phi_t = u8) embedded via mem_section:
  - 2 bits: access frequency (4 levels)
  - 5 bits: time bucket (≈4s window with HZ=1000, bucketed jiffies)
  - 1 bit : migration-ready flag (MSB)

- Event recording API:
  int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
  @pfn: The PFN of the memory accessed
  @nid: The accessing NUMA node ID
  @src: The temperature source (subsystem) that generated the
        access info
  @time: The access time in jiffies
  - Sources (e.g., NUMA hint faults, HW hints) call this to report
    accesses.
  - In default mode, the nid is not stored/used for targeting;
    promotion goes to a configurable toptier node (pghot_target_nid).

- Promotion engine:
  - One kmigrated thread per lower-tier node.
  - Scans only sections whose "hot" flag was raised, iterates PFNs,
    and batches candidates by destination node.
  - Uses promote_misplaced_memcg_folios() to move batched folios.

- Tunables & stats:
  - debugfs: kmigrated_sleep_ms, kmigrated_batch_nr
  - sysctl : vm.pghot_promote_freq_window_ms, vm.pghot_freq_threshold,
	     vm.pghot_enabled_sources, vm.pghot_target_nid
  - vmstat : pghot_recorded_accesses, pghot_recorded_hintfaults,
             pghot_recorded_hwhints

Memory overhead
---------------
Default mode uses 1 byte of hotness metadata per PFN on lower-tier
nodes.

Behavior & policy
-----------------
- Default mode promotion target:
  The nid passed by sources is not stored; hot pages promote to
  pghot_target_nid (toptier). Precision mode (added later in the
  series) changes this.

- Record consumption:
  kmigrated consumes (clears) the "migration-ready" bit before
  attempting isolation. Additionally the hotness record is reset.
  If isolation/migration fails, the folio is not re-queued automatically;
  subsequent accesses will re-arm it. This avoids retry storms and
  keeps batching stable.

- Wakeups:
  kmigrated wakeups are intentionally timeout-driven. We set
  the per-pgdat "activate" flag on access, and kmigrated checks this
  flag on its next sleep interval. This keeps the first cut simple
  and avoids potential wake storms; active wakeups can be considered
  in a follow-up.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/index.rst |   1 +
 Documentation/admin-guide/mm/pghot.rst |  89 +++
 include/linux/migrate.h                |   4 +-
 include/linux/mmzone.h                 |  21 +
 include/linux/pghot.h                  | 103 ++++
 include/linux/vm_event_item.h          |   5 +
 mm/Kconfig                             |  14 +
 mm/Makefile                            |   1 +
 mm/migrate.c                           |  16 +-
 mm/mm_init.c                           |  10 +
 mm/pghot-default.c                     |  76 +++
 mm/pghot.c                             | 725 +++++++++++++++++++++++++
 mm/vmstat.c                            |   5 +
 13 files changed, 1063 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/pghot.rst
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot-default.c
 create mode 100644 mm/pghot.c

diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index bbb563cba5d2..4d6810b02365 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -43,3 +43,4 @@ the Linux memory management.
    userfaultfd
    zswap
    kho
+   pghot
diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
new file mode 100644
index 000000000000..0edbe0082816
--- /dev/null
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -0,0 +1,89 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================================
+pghot: Hot Page Tracking and Promotion Subsystem
+================================================
+
+Overview
+========
+The pghot subsystem tracks frequently accessed pages in lower-tier memory and
+promotes them to faster tiers. It uses per-PFN hotness metadata and asynchronous
+migration via per-node kernel threads (kmigrated).
+
+This document describes tunables available via **debugfs** and **sysctl** for
+pghot.
+
+Debugfs Interface
+=================
+Path: /sys/kernel/debug/pghot/
+
+1. **kmigrated_sleep_ms**
+   - Sleep interval (ms) for kmigrated thread between scans.
+   - Default: 100
+
+2. **kmigrated_batch_nr**
+   - Maximum number of folios migrated in one batch.
+   - Default: 512
+
+Sysctl Interface
+================
+1. pghot_enabled_sources
+
+Path: /proc/sys/vm/pghot_enabled_sources
+
+- Bitmask to enable/disable hotness sources.
+- Bits:
+  - 0: Hint faults (value 0x1)
+  - 1: Hardware hints (value 0x2)
+- Default: 0 (disabled)
+- Example:
+  # echo 0x3 > /proc/sys/vm/pghot_enabled_sources
+  Enables both hint faults and hwhints sources
+
+2. pghot_target_nid
+
+Path: /proc/sys/vm/pghot_target_nid
+
+- Toptier NUMA node ID to which hot pages should be promoted when source
+  does not provide nid. Used when hotness source can't provide accessing
+  NID or when the tracking mode is default.
+- Default: 0
+- Example:
+  # echo 1 > /proc/sys/vm/pghot_target_nid
+
+3. pghot_freq_threshold
+
+Path: /proc/sys/vm/pghot_freq_threshold
+
+- Minimum access frequency before a page is marked ready for promotion.
+  Range is 1 to 3 in default mode.
+- Default: 2
+- Example:
+  # sysctl vm.pghot_freq_threshold=1
+
+4. pghot_promote_freq_window_ms
+
+Path: /proc/sys/vm/pghot_promote_freq_window_ms
+
+- Controls the time window (in ms) for counting access frequency. A page is
+  considered hot only when **pghot_freq_threshold** number of accesses occur
+  with this time period.
+- Default: 3000 (3 seconds)
+- Example:
+  # sysctl vm.pghot_promote_freq_window_ms=3000
+
+pghot Vmstat Counters
+=====================
+Following vmstat counters provide some stats about pghot subsystem.
+
+Path: /proc/vmstat
+
+1. **pghot_recorded_accesses**
+   - Number of total hot page accesses recorded by pghot.
+
+2. **pghot_recorded_hintfaults**
+   - Number of recorded accesses reported by NUMA Balancing based
+     hotness source.
+
+3. **pghot_recorded_hwhints**
+   - Number of recorded accesses reported by hwhints source.
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d136612eef9d..53bae80d11ae 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -107,7 +107,7 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
 
 #endif /* CONFIG_MIGRATION */
 
-#ifdef CONFIG_NUMA_BALANCING
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_PGHOT)
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, int node);
@@ -126,7 +126,7 @@ static inline int promote_misplaced_memcg_folios(struct list_head *folio_list, i
 {
 	return -EAGAIN; /* can't migrate now */
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_NUMA_BALANCING || CONFIG_PGHOT */
 
 #ifdef CONFIG_MIGRATION
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..11c547a51f43 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1156,6 +1156,7 @@ enum pgdat_flags {
 					 * many pages under writeback
 					 */
 	PGDAT_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
+	PGDAT_KMIGRATED_ACTIVATE,	/* activates kmigrated */
 };
 
 enum zone_flags {
@@ -1598,6 +1599,10 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_PGHOT
+	struct task_struct *kmigrated;
+	wait_queue_head_t kmigrated_wait;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
@@ -1992,6 +1997,7 @@ struct mem_section_usage {
 
 struct page;
 struct page_ext;
+struct pghot_hot_map;
 struct mem_section {
 	/*
 	 * This is, logically, a pointer to an array of struct
@@ -2008,12 +2014,27 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
+#ifdef CONFIG_PGHOT
+	/*
+	 * RCU-protected pointer to this section's struct pghot_hot_map,
+	 * which holds the per-PFN hotness records and the section-level
+	 * flags.
+	 */
+	struct pghot_hot_map __rcu *hot_map;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
+#endif
+	/*
+	 * Padding to maintain consistent mem_section size when exactly
+	 * one of PGHOT or PAGE_EXTENSION is enabled. This ensures
+	 * optimal alignment regardless of configuration.
+	 */
+#if (defined(CONFIG_PGHOT) ^ defined(CONFIG_PAGE_EXTENSION))
 	unsigned long pad;
 #endif
 	/*
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
new file mode 100644
index 000000000000..7b85d717f410
--- /dev/null
+++ b/include/linux/pghot.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGHOT_H
+#define _LINUX_PGHOT_H
+
+/* Page hotness temperature sources */
+enum pghot_src {
+	PGHOT_HINTFAULTS = 0,
+	PGHOT_HWHINTS,
+	PGHOT_SRC_MAX
+};
+
+#ifdef CONFIG_PGHOT
+#include <linux/static_key.h>
+#include <linux/mutex.h>
+
+extern unsigned int sysctl_pghot_target_nid;
+extern unsigned int sysctl_pghot_freq_window;
+extern unsigned int sysctl_pghot_freq_threshold;
+extern struct mutex pghot_tunables_lock;
+
+DECLARE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
+
+#define PGHOT_HINTFAULTS_ENABLED	BIT(PGHOT_HINTFAULTS)
+#define PGHOT_HWHINTS_ENABLED		BIT(PGHOT_HWHINTS)
+#define PGHOT_SRC_ENABLED_MASK		GENMASK(PGHOT_SRC_MAX - 1, 0)
+
+#define PGHOT_FREQ_THRESHOLD_DEFAULT	2
+
+#define KMIGRATED_SLEEP_MS_MIN		50
+#define KMIGRATED_SLEEP_MS_DEFAULT	100
+#define KMIGRATED_SLEEP_MS_MAX		1000
+
+#define KMIGRATED_BATCH_NR_MIN		64
+#define KMIGRATED_BATCH_NR_DEFAULT	512
+#define KMIGRATED_BATCH_NR_MAX		1024
+
+#define PGHOT_DEFAULT_NODE		0
+
+#define PGHOT_FREQ_WINDOW_MIN		(1 * MSEC_PER_SEC)
+#define PGHOT_FREQ_WINDOW_DEFAULT	(3 * MSEC_PER_SEC)
+
+/*
+ * Bits 0-6 are used to store frequency and time.
+ * Bit 7 is used to indicate the page is ready for migration.
+ */
+#define PGHOT_MIGRATE_READY		7
+
+#define PGHOT_FREQ_WIDTH		2
+/* Bucketed time is stored in 5 bits which can represent up to 3.9s with HZ=1000 */
+#define PGHOT_TIME_BUCKETS_SHIFT	7
+#define PGHOT_TIME_WIDTH		5
+#define PGHOT_NID_WIDTH			10
+
+#define PGHOT_FREQ_SHIFT		0
+#define PGHOT_TIME_SHIFT		(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
+
+#define PGHOT_FREQ_MASK			GENMASK(PGHOT_FREQ_WIDTH - 1, 0)
+#define PGHOT_TIME_MASK			GENMASK(PGHOT_TIME_WIDTH - 1, 0)
+#define PGHOT_TIME_BUCKETS_MASK		(PGHOT_TIME_MASK << PGHOT_TIME_BUCKETS_SHIFT)
+
+#define PGHOT_NID_MAX			((1 << PGHOT_NID_WIDTH) - 1)
+#define PGHOT_FREQ_MAX			((1 << PGHOT_FREQ_WIDTH) - 1)
+#define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
+#define PGHOT_FREQ_WINDOW_MAX		PGHOT_TIME_BUCKETS_MASK
+
+typedef u8 phi_t;
+
+#define PGHOT_RECORD_SIZE		sizeof(phi_t)
+
+#define PGHOT_SECTION_HOT_BIT		0
+
+/**
+ * struct pghot_hot_map - per-section hotness map
+ * @rcu:   used to free the map after an RCU grace period via kfree_rcu().
+ * @flags: section-level flags; currently only PGHOT_SECTION_HOT_BIT, set
+ *         when the section contains at least one page classified as hot
+ *         and consumed by the kmigrated thread.
+ * @phi:   per-PFN hotness records, PAGES_PER_SECTION entries.
+ *
+ * Referenced from struct mem_section through an RCU-protected pointer
+ * (mem_section->hot_map). Readers must dereference ->hot_map under
+ * rcu_read_lock() and updaters must use the RCU pointer accessors.
+ */
+struct pghot_hot_map {
+	struct rcu_head rcu;
+	unsigned long flags;
+	phi_t phi[];
+};
+
+bool pghot_nid_valid(int nid);
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time);
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now);
+int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time);
+
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now);
+#else
+static inline int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	return 0;
+}
+#endif /* CONFIG_PGHOT */
+#endif /* _LINUX_PGHOT_H */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..58d510711bd4 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -175,6 +175,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_PGHOT
+		PGHOT_RECORDED_ACCESSES,
+		PGHOT_RECORDED_HINTFAULTS,
+		PGHOT_RECORDED_HWHINTS,
+#endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..0a5bcd5d45ed 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1509,6 +1509,20 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config PGHOT
+	bool "Hot page tracking and promotion"
+	default n
+	depends on NUMA_MIGRATION && SPARSEMEM
+	help
+	  A sub-system to track page accesses in lower tier memory and
+	  maintain hot page information. Promotes hot pages from lower
+	  tiers to top tier by using the memory access information provided
+	  by various sources. Asynchronous promotion is done by per-node
+	  kernel threads.
+
+	  This adds 1 byte of metadata overhead per page in lower-tier
+	  memory nodes.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..4939a1a74c1d 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_PGHOT) += pghot.o pghot-default.o
diff --git a/mm/migrate.c b/mm/migrate.c
index 58a8a0cf6fa3..7ab15780226e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2628,7 +2628,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
 }
 #endif /* CONFIG_NUMA_MIGRATION */
 
-#ifdef CONFIG_NUMA_BALANCING
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_PGHOT)
 /*
  * Returns true if this is a safe migration target node for misplaced NUMA
  * pages. Currently it only checks the watermarks which is crude.
@@ -2748,12 +2748,10 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
  */
 int migrate_misplaced_folio(struct folio *folio, int node)
 {
-	pg_data_t *pgdat = NODE_DATA(node);
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
 	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
@@ -2762,12 +2760,18 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_remaining && !list_empty(&migratepages))
 		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
+#ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 		    && !node_is_toptier(folio_nid(folio))
-		    && node_is_toptier(node))
+		    && node_is_toptier(node)) {
+			pg_data_t *pgdat = NODE_DATA(node);
+			struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
+		}
+#endif
 	}
 	mem_cgroup_put(memcg);
 	BUG_ON(!list_empty(&migratepages));
@@ -2821,14 +2825,16 @@ int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
 		putback_movable_pages(folio_list);
 
 	if (nr_succeeded) {
+#ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		mod_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(node)),
 				 PGPROMOTE_SUCCESS, nr_succeeded);
+#endif
 	}
 
 	mem_cgroup_put(memcg);
 	WARN_ON(!list_empty(folio_list));
 	return nr_remaining ? -EAGAIN : 0;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_NUMA_BALANCING || CONFIG_PGHOT */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..13ef3cf1e48c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1386,6 +1386,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
 static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
 #endif
 
+#ifdef CONFIG_PGHOT
+static void pgdat_init_kmigrated(struct pglist_data *pgdat)
+{
+	init_waitqueue_head(&pgdat->kmigrated_wait);
+}
+#else
+static inline void pgdat_init_kmigrated(struct pglist_data *pgdat) {}
+#endif
+
 static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 {
 	int i;
@@ -1393,6 +1402,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 	pgdat_resize_init(pgdat);
 	pgdat_kswapd_lock_init(pgdat);
 	pgdat_init_kcompactd(pgdat);
+	pgdat_init_kmigrated(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
diff --git a/mm/pghot-default.c b/mm/pghot-default.c
new file mode 100644
index 000000000000..ed66a867a644
--- /dev/null
+++ b/mm/pghot-default.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot: Default mode
+ *
+ * 1 byte hotness record per PFN.
+ * Bucketed time and frequency tracked as part of the record.
+ * Promotion to @sysctl_pghot_target_nid by default.
+ */
+
+#include <linux/pghot.h>
+#include <linux/jiffies.h>
+
+/* pghot-default doesn't store and hence no NID validation is required */
+bool pghot_nid_valid(int nid)
+{
+	return true;
+}
+
+/*
+ * @time is regular time, @old_time is bucketed time.
+ */
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
+{
+	time &= PGHOT_TIME_BUCKETS_MASK;
+	old_time <<= PGHOT_TIME_BUCKETS_SHIFT;
+
+	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_BUCKETS_MASK);
+}
+
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
+{
+	phi_t freq, old_freq, hotness, old_hotness, old_time;
+	phi_t time = now >> PGHOT_TIME_BUCKETS_SHIFT;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		bool new_window = false;
+
+		old_freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+
+		if (pghot_access_latency(old_time, now) > sysctl_pghot_freq_window)
+			new_window = true;
+
+		if (new_window)
+			freq = 1;
+		else if (old_freq < PGHOT_FREQ_MAX)
+			freq = old_freq + 1;
+		else
+			freq = old_freq;
+
+		hotness = 0;
+		hotness |= (freq & PGHOT_FREQ_MASK) << PGHOT_FREQ_SHIFT;
+		hotness |= (time & PGHOT_TIME_MASK) << PGHOT_TIME_SHIFT;
+
+		if (freq >= sysctl_pghot_freq_threshold)
+			hotness |= BIT(PGHOT_MIGRATE_READY);
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+	return !!(hotness & BIT(PGHOT_MIGRATE_READY));
+}
+
+int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time)
+{
+	phi_t old_hotness, hotness = 0;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		if (!(old_hotness & BIT(PGHOT_MIGRATE_READY)))
+			return -EINVAL;
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+
+	*nid = sysctl_pghot_target_nid;
+	*freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+	*time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+	return 0;
+}
diff --git a/mm/pghot.c b/mm/pghot.c
new file mode 100644
index 000000000000..19cc023091f4
--- /dev/null
+++ b/mm/pghot.c
@@ -0,0 +1,725 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Maintains information about hot pages from slower tier nodes and
+ * promotes them.
+ *
+ * Per-PFN hotness information is stored for lower tier nodes in
+ * mem_section.
+ *
+ * In the default mode, a single byte (u8) is used to store
+ * the frequency of access and last access time. Promotions are done
+ * to a default toptier NID.
+ *
+ * A kernel thread named kmigrated is provided to migrate or promote
+ * the hot pages. kmigrated runs for each lower tier node. It iterates
+ * over the node's PFNs and  migrates pages marked for migration into
+ * their targeted nodes.
+ */
+#include <linux/mm.h>
+#include <linux/migrate.h>
+#include <linux/memory.h>
+#include <linux/memory-tiers.h>
+#include <linux/debugfs.h>
+#include <linux/rcupdate.h>
+#include <linux/pghot.h>
+
+unsigned int pghot_freq_window_min = PGHOT_FREQ_WINDOW_MIN;
+unsigned int pghot_freq_window_max = PGHOT_FREQ_WINDOW_MAX;
+unsigned int pghot_freq_threshold_max = PGHOT_FREQ_MAX;
+unsigned int kmigrated_sleep_ms = KMIGRATED_SLEEP_MS_DEFAULT;
+unsigned int kmigrated_batch_nr = KMIGRATED_BATCH_NR_DEFAULT;
+
+unsigned int sysctl_pghot_src_enabled;
+unsigned int sysctl_pghot_target_nid = PGHOT_DEFAULT_NODE;
+unsigned int sysctl_pghot_freq_window = PGHOT_FREQ_WINDOW_DEFAULT;
+unsigned int sysctl_pghot_freq_threshold = PGHOT_FREQ_THRESHOLD_DEFAULT;
+
+DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
+DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+DEFINE_MUTEX(pghot_tunables_lock);
+
+#ifdef CONFIG_SYSCTL
+static void pghot_src_enabled_update(unsigned int enabled)
+{
+	unsigned int changed = sysctl_pghot_src_enabled ^ enabled;
+
+	if (changed & PGHOT_HINTFAULTS_ENABLED) {
+		if (enabled & PGHOT_HINTFAULTS_ENABLED)
+			static_branch_enable(&pghot_src_hintfaults);
+		else
+			static_branch_disable(&pghot_src_hintfaults);
+	}
+
+	if (changed & PGHOT_HWHINTS_ENABLED) {
+		if (enabled & PGHOT_HWHINTS_ENABLED)
+			static_branch_enable(&pghot_src_hwhints);
+		else
+			static_branch_disable(&pghot_src_hwhints);
+	}
+}
+
+static int sysctl_src_enabled_handler(const struct ctl_table *table, int write,
+				      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	int err;
+	unsigned int enabled;
+
+	guard(mutex)(&pghot_tunables_lock);
+
+	enabled = sysctl_pghot_src_enabled;
+	t = *table;
+	t.data = &enabled;
+	err = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	if (write) {
+		if (enabled & ~PGHOT_SRC_ENABLED_MASK)
+			return -EINVAL;
+		pghot_src_enabled_update(enabled);
+		sysctl_pghot_src_enabled = enabled;
+	}
+	return err;
+}
+
+static int sysctl_target_nid_handler(const struct ctl_table *table, int write,
+				     void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	int err;
+	unsigned int nid;
+
+	guard(mutex)(&pghot_tunables_lock);
+
+	nid = sysctl_pghot_target_nid;
+	t = *table;
+	t.data = &nid;
+	err = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	if (write) {
+		if (!numa_valid_node(nid) || nid > PGHOT_NID_MAX ||
+		    !node_online(nid) || !node_is_toptier(nid))
+			return -EINVAL;
+		sysctl_pghot_target_nid = nid;
+	}
+	return err;
+}
+
+static const struct ctl_table pghot_sysctls[] = {
+	{
+		.procname	= "pghot_enabled_sources",
+		.data		= &sysctl_pghot_src_enabled,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_src_enabled_handler,
+	},
+	{
+		.procname       = "pghot_promote_freq_window_ms",
+		.data           = &sysctl_pghot_freq_window,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &pghot_freq_window_min,
+		.extra2         = &pghot_freq_window_max,
+	},
+	{
+		.procname	= "pghot_target_nid",
+		.data		= &sysctl_pghot_target_nid,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_target_nid_handler,
+	},
+	{
+		.procname	= "pghot_freq_threshold",
+		.data		= &sysctl_pghot_freq_threshold,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= &pghot_freq_threshold_max,
+	},
+};
+
+static void __init pghot_sysctl_init(void)
+{
+	register_sysctl_init("vm", pghot_sysctls);
+}
+#else
+static inline void pghot_sysctl_init(void) { }
+#endif
+
+static bool kmigrated_started __ro_after_init;
+
+/**
+ * pghot_record_access() - Record page accesses from lower tier memory
+ * for the purpose of tracking page hotness and subsequent promotion.
+ *
+ * @pfn: PFN of the page
+ * @nid: Unused
+ * @src: The identifier of the sub-system that reports the access
+ * @now: Access time in jiffies
+ *
+ * Updates the frequency and time of access and marks the page as
+ * ready for migration if the frequency crosses a threshold. The pages
+ * marked for migration are migrated by kmigrated kernel thread.
+ *
+ * Return: 0 on success and -EINVAL on failure to record the access.
+ */
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	struct mem_section *ms;
+	struct folio *folio;
+	struct pghot_hot_map *hot_map;
+	phi_t *phi;
+	struct page *page;
+	int src_nid;
+
+	if (!kmigrated_started)
+		return 0;
+
+	if (!pghot_nid_valid(nid))
+		return -EINVAL;
+
+	switch (src) {
+	case PGHOT_HINTFAULTS:
+		if (!static_branch_unlikely(&pghot_src_hintfaults))
+			return 0;
+		count_vm_event(PGHOT_RECORDED_HINTFAULTS);
+		break;
+	case PGHOT_HWHINTS:
+		if (!static_branch_unlikely(&pghot_src_hwhints))
+			return 0;
+		count_vm_event(PGHOT_RECORDED_HWHINTS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	src_nid = pfn_to_nid(pfn);
+	if (src_nid == nid)
+		return 0;
+
+	/*
+	 * Record only accesses from lower tiers.
+	 */
+	if (node_is_toptier(src_nid))
+		return 0;
+
+	/*
+	 * Reject the non-migratable pages right away.
+	 */
+	page = pfn_to_online_page(pfn);
+	if (!page || is_zone_device_page(page))
+		return 0;
+
+	folio = page_folio(page);
+	if (!folio_try_get(folio))
+		return 0;
+
+	if (unlikely(page_folio(page) != folio))
+		goto out;
+
+	if (!folio_test_lru(folio))
+		goto out;
+
+	/* Get the hotness slot corresponding to the 1st PFN of the folio */
+	pfn = folio_pfn(folio);
+	ms = __pfn_to_section(pfn);
+
+	rcu_read_lock();
+	hot_map = ms ? rcu_dereference(ms->hot_map) : NULL;
+	if (!hot_map) {
+		rcu_read_unlock();
+		goto out;
+	}
+
+	phi = &hot_map->phi[pfn % PAGES_PER_SECTION];
+
+	count_vm_event(PGHOT_RECORDED_ACCESSES);
+
+	/*
+	 * Update the hotness parameters.
+	 */
+	if (pghot_update_record(phi, nid, now)) {
+		set_bit(PGHOT_SECTION_HOT_BIT, &hot_map->flags);
+		set_bit(PGDAT_KMIGRATED_ACTIVATE, &page_pgdat(page)->flags);
+	}
+	rcu_read_unlock();
+out:
+	folio_put(folio);
+	return 0;
+}
+
+static int pghot_get_hotness(unsigned long pfn, int *nid, int *freq,
+			     unsigned long *time)
+{
+	struct pghot_hot_map *hot_map;
+	struct mem_section *ms;
+	phi_t *phi;
+	int ret;
+
+	ms = __pfn_to_section(pfn);
+
+	rcu_read_lock();
+	hot_map = ms ? rcu_dereference(ms->hot_map) : NULL;
+	if (!hot_map) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	phi = &hot_map->phi[pfn % PAGES_PER_SECTION];
+	ret = pghot_get_record(phi, nid, freq, time);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+/*
+ * Walks the PFNs of the zone, isolates and migrates them in batches.
+ */
+static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
+				int src_nid)
+{
+	struct mem_cgroup *cur_memcg = NULL;
+	int cur_nid = NUMA_NO_NODE;
+	LIST_HEAD(migrate_list);
+	int batch_count = 0;
+	struct folio *folio;
+	struct page *page;
+	unsigned long pfn;
+
+	pfn = start_pfn;
+	do {
+		int nid = NUMA_NO_NODE, nr = 1;
+		struct mem_cgroup *memcg;
+		unsigned long time = 0;
+		int freq = 0;
+
+		if (!pfn_valid(pfn))
+			goto out_next;
+
+		page = pfn_to_online_page(pfn);
+		if (!page)
+			goto out_next;
+
+		folio = page_folio(page);
+		if (!folio_try_get(folio))
+			goto out_next;
+
+		if (unlikely(page_folio(page) != folio)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		nr = folio_nr_pages(folio);
+		if (folio_nid(folio) != src_nid) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		if (!folio_test_lru(folio)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		if (pghot_get_hotness(pfn, &nid, &freq, &time)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		if (folio_nid(folio) == nid) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		if (migrate_misplaced_folio_prepare(folio, NULL, nid)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		rcu_read_lock();
+		memcg = folio_memcg(folio);
+		rcu_read_unlock();
+		if (cur_nid == NUMA_NO_NODE) {
+			cur_nid = nid;
+			cur_memcg = memcg;
+		}
+
+		/* If NID or memcg changed, flush the previous batch first */
+		if (cur_nid != nid || cur_memcg != memcg) {
+			if (!list_empty(&migrate_list))
+				promote_misplaced_memcg_folios(&migrate_list, cur_nid);
+			cur_nid = nid;
+			cur_memcg = memcg;
+			batch_count = 0;
+			cond_resched();
+		}
+
+		list_add(&folio->lru, &migrate_list);
+		folio_put(folio);
+
+		if (++batch_count > READ_ONCE(kmigrated_batch_nr)) {
+			promote_misplaced_memcg_folios(&migrate_list, cur_nid);
+			batch_count = 0;
+			cond_resched();
+		}
+out_next:
+		pfn += nr;
+	} while (pfn < end_pfn);
+	if (!list_empty(&migrate_list))
+		promote_misplaced_memcg_folios(&migrate_list, cur_nid);
+}
+
+static void kmigrated_do_work(pg_data_t *pgdat)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct pghot_hot_map *hot_map;
+	struct mem_section *ms;
+	bool hot;
+	int nid;
+
+	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		start_pfn = section_nr_to_pfn(section_nr);
+		ms = __nr_to_section(section_nr);
+
+		if (!pfn_valid(start_pfn))
+			continue;
+
+		nid = pfn_to_nid(start_pfn);
+		if (node_is_toptier(nid) || nid != pgdat->node_id)
+			continue;
+
+		rcu_read_lock();
+		hot_map = rcu_dereference(ms->hot_map);
+		hot = hot_map &&
+		      test_and_clear_bit(PGHOT_SECTION_HOT_BIT, &hot_map->flags);
+		rcu_read_unlock();
+
+		if (!hot)
+			continue;
+
+		kmigrated_walk_zone(start_pfn, start_pfn + PAGES_PER_SECTION,
+				    pgdat->node_id);
+	}
+}
+
+static inline bool kmigrated_work_requested(pg_data_t *pgdat)
+{
+	return test_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+}
+
+/*
+ * Per-node kthread that iterates over its PFNs and migrates the
+ * pages that have been marked for migration.
+ */
+static int kmigrated(void *p)
+{
+	pg_data_t *pgdat = p;
+
+	while (!kthread_should_stop()) {
+		long timeout = msecs_to_jiffies(READ_ONCE(kmigrated_sleep_ms));
+
+		if (wait_event_timeout(pgdat->kmigrated_wait, kmigrated_work_requested(pgdat),
+				       timeout))
+			kmigrated_do_work(pgdat);
+	}
+	return 0;
+}
+
+static int kmigrated_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret;
+
+	if (!pgdat->kmigrated) {
+		pgdat->kmigrated = kthread_create_on_node(kmigrated, pgdat, nid,
+							  "kmigrated%d", nid);
+		if (IS_ERR(pgdat->kmigrated)) {
+			ret = PTR_ERR(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+			pr_err("Failed to start kmigrated%d, ret %d\n", nid, ret);
+			return ret;
+		}
+		pr_info("pghot: Started kmigrated thread for node %d\n", nid);
+	}
+	wake_up_process(pgdat->kmigrated);
+	return 0;
+}
+
+static void pghot_free_hot_map(struct mem_section *ms)
+{
+	struct pghot_hot_map *hot_map;
+
+	hot_map = rcu_dereference_protected(ms->hot_map, 1);
+	if (!hot_map)
+		return;
+
+	RCU_INIT_POINTER(ms->hot_map, NULL);
+	kfree_rcu(hot_map, rcu);
+}
+
+static int pghot_alloc_hot_map(struct mem_section *ms, int nid)
+{
+	struct pghot_hot_map *hot_map;
+
+	hot_map = kzalloc_node(struct_size(hot_map, phi, PAGES_PER_SECTION),
+			       GFP_KERNEL, nid);
+	if (!hot_map)
+		return -ENOMEM;
+
+	rcu_assign_pointer(ms->hot_map, hot_map);
+	return 0;
+}
+
+static void pghot_offline_sec_hotmap(unsigned long start_pfn,
+				     unsigned long nr_pages)
+{
+	unsigned long start, end, pfn;
+	struct mem_section *ms;
+
+	start = SECTION_ALIGN_DOWN(start_pfn);
+	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
+
+	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+		if (!ms)
+			continue;
+
+		pghot_free_hot_map(ms);
+	}
+}
+
+static int pghot_online_sec_hotmap(unsigned long start_pfn,
+				   unsigned long nr_pages)
+{
+	int nid = pfn_to_nid(start_pfn);
+	unsigned long start, end, pfn;
+	struct mem_section *ms;
+	int fail = 0;
+
+	/*
+	 * No section hot maps for toptier sections.
+	 */
+	if (node_is_toptier(nid))
+		return 0;
+
+	start = SECTION_ALIGN_DOWN(start_pfn);
+	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
+
+	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+		if (!ms || rcu_access_pointer(ms->hot_map))
+			continue;
+
+		fail = pghot_alloc_hot_map(ms, nid);
+	}
+
+	if (!fail)
+		return 0;
+
+	/* rollback: free the sections allocated before the failure */
+	end = pfn - PAGES_PER_SECTION;
+	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+		if (ms)
+			pghot_free_hot_map(ms);
+	}
+	return -ENOMEM;
+}
+
+static int pghot_memhp_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	struct memory_notify *mn = arg;
+	int ret = 0;
+
+	switch (action) {
+	case MEM_GOING_ONLINE:
+		ret = pghot_online_sec_hotmap(mn->start_pfn, mn->nr_pages);
+		break;
+	case MEM_OFFLINE:
+	case MEM_CANCEL_ONLINE:
+		pghot_offline_sec_hotmap(mn->start_pfn, mn->nr_pages);
+		break;
+	}
+
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block pghot_mem_notifier = {
+	.notifier_call = pghot_memhp_callback,
+	.priority = DEFAULT_CALLBACK_PRI,
+};
+
+static void pghot_destroy_hot_map(void)
+{
+	unsigned long section_nr, s_begin;
+	struct mem_section *ms;
+
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		pghot_free_hot_map(ms);
+	}
+
+	unregister_memory_notifier(&pghot_mem_notifier);
+}
+
+static int pghot_setup_hot_map(void)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid, ret;
+
+	ret = register_memory_notifier(&pghot_mem_notifier);
+	if (ret)
+		return ret;
+
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		start_pfn = section_nr_to_pfn(section_nr);
+		nid = pfn_to_nid(start_pfn);
+
+		if (node_is_toptier(nid) || !pfn_valid(start_pfn))
+			continue;
+
+		if (pghot_alloc_hot_map(ms, nid))
+			goto out_free_hot_map;
+	}
+	return 0;
+
+out_free_hot_map:
+	pghot_destroy_hot_map();
+	return -ENOMEM;
+}
+
+static int pghot_parse_uint(const char __user *ubuf, size_t cnt, unsigned int *val)
+{
+	char buf[16];
+
+	if (cnt > sizeof(buf) - 1)
+		cnt = sizeof(buf) - 1;
+	if (copy_from_user(buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+	if (kstrtouint(buf, 0, val))
+		return -EINVAL;
+	return 0;
+}
+
+static ssize_t pghot_kmigrated_sleep_ms_write(struct file *filp, const char __user *ubuf,
+					      size_t cnt, loff_t *ppos)
+{
+	unsigned int val;
+	int ret;
+
+	guard(mutex)(&pghot_tunables_lock);
+
+	ret = pghot_parse_uint(ubuf, cnt, &val);
+	if (ret)
+		return ret;
+	if (val < KMIGRATED_SLEEP_MS_MIN  || val > KMIGRATED_SLEEP_MS_MAX)
+		return -EINVAL;
+
+	WRITE_ONCE(kmigrated_sleep_ms, val);
+	*ppos += cnt;
+	return cnt;
+}
+
+static ssize_t pghot_kmigrated_batch_nr_write(struct file *filp, const char __user *ubuf,
+					      size_t cnt, loff_t *ppos)
+{
+	unsigned int val;
+	int ret;
+
+	guard(mutex)(&pghot_tunables_lock);
+
+	ret = pghot_parse_uint(ubuf, cnt, &val);
+	if (ret)
+		return ret;
+	if (val < KMIGRATED_BATCH_NR_MIN  || val > KMIGRATED_BATCH_NR_MAX)
+		return -EINVAL;
+
+	WRITE_ONCE(kmigrated_batch_nr, val);
+	*ppos += cnt;
+	return cnt;
+}
+
+#define PGHOT_SHOW(name)						\
+static int pghot_##name##_show(struct seq_file *m, void *v)		\
+{									\
+	seq_printf(m, "%u\n", name);				\
+	return 0;							\
+}									\
+static int pghot_##name##_open(struct inode *inode, struct file *filp)	\
+{									\
+	return single_open(filp, pghot_##name##_show, NULL);		\
+}
+
+PGHOT_SHOW(kmigrated_sleep_ms)
+PGHOT_SHOW(kmigrated_batch_nr)
+
+#define PGHOT_FOPS(name)						\
+static const struct file_operations pghot_##name##_fops = {		\
+	.open		= pghot_##name##_open,				\
+	.read		= seq_read,					\
+	.write		= pghot_##name##_write,				\
+	.llseek		= seq_lseek,					\
+	.release	= single_release,				\
+}
+
+PGHOT_FOPS(kmigrated_sleep_ms);
+PGHOT_FOPS(kmigrated_batch_nr);
+
+static void pghot_debug_init(void)
+{
+	struct dentry *dir = debugfs_create_dir("pghot", NULL);
+
+	debugfs_create_file("kmigrated_sleep_ms", 0644, dir, NULL,
+			    &pghot_kmigrated_sleep_ms_fops);
+	debugfs_create_file("kmigrated_batch_nr", 0644, dir, NULL,
+			    &pghot_kmigrated_batch_nr_fops);
+}
+
+static int __init pghot_init(void)
+{
+	pg_data_t *pgdat;
+	int nid, ret;
+
+	ret = pghot_setup_hot_map();
+	if (ret)
+		return ret;
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (node_is_toptier(nid))
+			continue;
+
+		ret = kmigrated_run(nid);
+		if (ret)
+			goto out_stop_kthread;
+	}
+	pghot_sysctl_init();
+	pghot_debug_init();
+
+	kmigrated_started = true;
+	return 0;
+
+out_stop_kthread:
+	for_each_node_state(nid, N_MEMORY) {
+		pgdat = NODE_DATA(nid);
+		if (pgdat->kmigrated) {
+			kthread_stop(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+		}
+	}
+	pghot_destroy_hot_map();
+	return ret;
+}
+
+late_initcall_sync(pghot_init)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..4064ead568cc 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1489,6 +1489,11 @@ const char * const vmstat_text[] = {
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
 #endif
+#ifdef CONFIG_PGHOT
+	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
+	[I(PGHOT_RECORDED_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+	[I(PGHOT_RECORDED_HWHINTS)]		= "pghot_recorded_hwhints",
+#endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


