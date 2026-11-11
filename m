Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA58606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=MfPZk956
Received: by kanga.kvack.org (Postfix)
	id 2F95A6B00EF; Tue, 10 Nov 2026 22:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA826B05B0; Tue, 10 Nov 2026 22:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1721B6B05B1; Tue, 10 Nov 2026 22:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE01D6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:34:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 257B9A00EC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:34:59 +0000 (UTC)
X-FDA: 85421421918.19.B897DC3
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012043.outbound.protection.outlook.com [52.101.53.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id E2EFE40002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:34:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MfPZk956;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.43 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794368096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=enokiadHO5dXxABbBcazqdN7iexetKJszb/hMskTV6E=;
	b=NcbGPqIXB/gHEgIRdwxnWopFoY+Kjcou4/1tTIfZumnmNdcbZ696Mxe8CoxBC/fUh9mkxO
	7IRjxtcmysA1fds5lZINPcdbl71HWaoNwbMm85rZAuqGHWAZB37fmBnr4y2ipaDSmUz4Lh
	YNXzhtZvGHcqtTAm2d+Omca/jlYPb2Y=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MfPZk956;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.43 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794368096;
	b=jEdcON0V/25f1eJLJRjWB1xpPFcBm+lksG83KPqfU2UlSqZ2TgRL58ZBvRXkT9kyvya3Sv
	M+C7fwds8aMhokYQogDz2nq+bVkXjdIW17CgnNWPdpA3rEHhks9F6IWSvAW0NQ7w7m5JYb
	6PV4nK9Y2SV1l1QhampzudnGs6BMuWU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G48enS5LcP1u9wFBZJxL2VS9lflph4Q+M7qFYooRDUMvXCgq7HrkcCDikQF5Cs9RmsTF91Y21jU08YLa5OTW7uENWP9v8SvQWu4QlwGkSJGDIVb1MHP2wAd8quo6AL/a7pNYNQ21SSlqs6ENtMKWgzy51+GQuhOer10bW4fWeW+/Q+ZmbdWi1ZWnQB9H1VlXU9n679J76P3xj7Ur7myR6V65hK2beW/PJYVrGgCMlTmz9LqKJevlbHOJSnvmJCuS9tLAZQGvsxdgHli0WLzb+765zvSrlf+0Fg6pNZ7wGaj+w0mIxGi52k4G/xcxuYFR+gKXfL44ekWtfPQLelpXPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enokiadHO5dXxABbBcazqdN7iexetKJszb/hMskTV6E=;
 b=c7759iThad0e4DXfGNYJGjJ3Io2C6EGVMhwVOzksBs9xv+1qdfJ3LwejIK4cGOH7uK69YVZ+aot3jYLvLZ/n+2lE5sVs8XcqNGla9biUs2+AwiyIZsXaYRBlZt2s+bSlMYBRWBiaWtjGcf79BQP5zJs1uF2fH306FLN9uyrAwAMZl8n77CtxhJjH9GZENARM8E5lWnJj/MlAktCTOiWxaGiU5ntI94pkOECW1T+kPIQLftgH7xk34DwoHfRtAmlcldF7tEEBv/GuR0N+cQ6StTYHn35/80YKEeaoS6UuARe+2wUTodW16EiTKa748imxcL0X2E6oyBcyR8/zgj6fpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enokiadHO5dXxABbBcazqdN7iexetKJszb/hMskTV6E=;
 b=MfPZk956ReMxha2tL+yV5mDm2YJ/8+lluyatbdz74IryN+zd2aZXhwh0AYrmsaEx6pHkTolY9KKDERDkwG+j3qRge+FHCBPyNh2gQjnZcBkxjslVtpn5sZrdFdpHw+Zi7T+qHsZgHdk3IFfDRVC5fBwgeuT/+oqYgBHWOsMWNRw=
Received: from DS1PR03CA0023.namprd03.prod.outlook.com (2603:10b6:8:233::11)
 by SA1PR12MB6800.namprd12.prod.outlook.com (2603:10b6:806:25c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 03:34:51 +0000
Received: from DM3PEPF000265BA.namprd04.prod.outlook.com
 (2603:10b6:8:233:cafe::a7) by DS1PR03CA0023.outlook.office365.com
 (2603:10b6:8:233::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Wed, 11
 Nov 2026 03:34:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DM3PEPF000265BA.mail.protection.outlook.com (10.167.23.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 03:34:50 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 10 Nov
 2026 21:34:50 -0600
Received: from [127.0.1.1] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 10 Nov
 2026 21:34:47 -0600
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH v2 0/2] mm: remove unused vmstat and folio refcount helpers
Date: Wed, 11 Nov 2026 03:34:32 +0000
Message-ID: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQ5AMBBA0avIrE1SJairiAXtYBZKOqkQcXeN5
 Vv8/4BQYBLosgcCnSy8+wSdZ2DX0S+E7JJBK10XhTIYfRRyKPeGdg+EqrWNcZU2ZT1Bqo5AM1/
 /sR/e9wM4dVIrYQAAAA==
X-Change-ID: 20261109-unused-sym-core-08c79d42936b
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794368087; l=1164;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=a7rfllFB9pEo73S9E89qz5htRD+ZCafRKGzOwhMkzrM=;
 b=MAdbXqYsoTmqU4JEoYzUYunALKCOkAT5AJe/2aA8282DGXr4m7XcHZ/h0XeVHSsdI6e+F53m+
 XkxmPiYOmkWDF/r8yR+8nNdz7ONZO5+ZNTHx/CK+NxATkjSGx5RJU0y
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265BA:EE_|SA1PR12MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: c0144346-ec5e-46f9-927a-08df3fa4be51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|7416014|82310400026|13003099007|261009223027099003|10067099003|261028144727099003|261026140227099003|261021123027099003|261022105027099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	5dYbRGXWkoZ9Q5yDp+TEgzqq0jBJCSG271vwqOkaKLF8KT9G3fI48C/pI1Ltc3VDmoQgX6yQmKcvZ/XwCcz+3nVerj9/LXPmwpJ/xQVJvPWPA2q8+CEEccc+oPQr1/tr5SXf0Gw81cOaMBC6EQII9Nc+H92YT/RWyZvDGBWKFt90oFUmC6SdMUuRDicyd2b+tHWb8eqUWmRYHouXwg8K9vuAM/EKR+NIxLFRH+s1vjdEi35Ys88h6yQOYaMbt9sn4tmUZ2HEVnI+E914EaQcw7M8FwfpyYkCbvD20M6yuMsLyhIJiELJsbeNQzrfwH3TjmrTAZojncnUzWZW4mr+aaky51mtoYEuFQJKwHSIwJeJXZnMO+6aBaZEliKDel9vQy/zgjQEnKi7DJLOaTsVOB2LyyEWCiuWxN7H2WDx/QfPLgopR+32oah9DrKbE//FddPU6FY3vCWzePgNtKxUkVkWy9Vm4Yz3qh1koCNsItAookZhbOyHp9pgfYCq6EfoJWpWrZx/iNhRR62Yx0DNrTGCVMi/WXGq0lO8jrFdEsSoIXNifC8eGoGsikjB4oSHU4butXeioKHOf5tylocEIhGsuccBbAPnwZ3sgbGTUi47BrFmlx2VBG6o+tq4A5iWh7SVdT0o6W7TE2dXuZCYryo9AzuoQKpyIxrk5IWzXhQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(7416014)(82310400026)(13003099007)(261009223027099003)(10067099003)(261028144727099003)(261026140227099003)(261021123027099003)(261022105027099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YeIsnSaVLUd6HEPmM8D0wFgWJ3E8QJ2B7wbI/Lg5ZaaR+Xx1qBlvVLBA+k3b6GrxLB3PXc/kNRzcQsIPhvmwo0ribXuftsiKbUIHtVYq8TuQLEGbs3HkSPpcwfE6IL59StYPmYsLAJRtpy4FmFpxVXM3qZvKyDrMhvkxkFcqZ30JSTNvl4l9kiLT6P2nICpfY6Y5WBQfTnoXLCsZrtYJkiosHkhkDLTkD4KBQzQulFsdw8/UUb3hQzximxaiyWw5XT1d6p6XTjgZRarsS489wlxF4WYpCPpdAVXwGx7QKDpN1LRkNeVejtT1AQJviJFshzEDfyYzRSPJ40KRA+gYPSaQ1XW615LnDro5DJeGs3IP8TjLNKLGcLTfjnTiznSkymZaAA0KWGI3euKpUwUdF665mfOKDESCC+S5DWRV4ILxImWbQZSsU2sdEaAtBL3+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 03:34:50.9704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0144346-ec5e-46f9-927a-08df3fa4be51
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265BA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6800
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2EFE40002
X-Stat-Signature: 9wc5h8c8xcbsutybtdn3c5oq4tcakfw9
X-Rspam-User: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794368095-3573
X-HE-Meta: U2FsdGVkX1+Rveb15IWR06YeHwmRwA7VSWTjgZj6ehahJ0WjXDtZ7v3D7Y+iFzlmzCUTbSYrtcaIz80vtee/POanXBLNf1B5J0FnvaipX66qFBCG6T5wM7rHFwYhFbPhG39LWanHWSnXN7Roqz6iFmezij/6+Id+vsd9nDwXtFafMEAq1M6diMaqvMHUIqpy0WzwR8FOudjfqaRnFDP3iLu8qXIB8BXowHIzp3DMBTOkrLd8tZoZ2pa5fLeVBc77WNUzJS4MVzPv4i4XAYH8dvMd82BYNoRzEunAiGbUceuvMoHymBOq/tRVhtzf4GOevdEFn++jhwRUhTMFU5x4VH3osE4mpaLv48syRq0Fnu8ekzdk4WjRssdzOnM2yqK1QMb3jgkEUZgsHlktpeHNMLHidzpBnToII8Nl+9AGWjj3RMKLyZoXhzHtvsMaUFRLMLYtT48Iy8XYbZ/UVJDB9ZRkQv8vIS+FAt0eT1NpAwrglbPmFF/T5sJU0tvee/laogC3xGjH77ch+LUW88wT+HxU8c2mDnwEIylH/fZ0pC0g9Lje3VxTxNqGlPzE3FBZOPXZjDwpW/VQGSnKKcsiNV7kDqLjbCxx4StVHj+xV4lGpuLbpN+sKVZulrWt9VROgkMqEcsRwOoDDqSn5xL1CqugqrLzLI1tNx/neYuY+WFIPdkp9Uzhk8pmSkclieGjLEpSiwsZkeB5gsmJXMRguMQkmktjRkQEZFnBhpkzf0QP50rxYUoKsoszAKUkTmGpoN3B3xzEz6z42PFRR1MVS+8ml/TlOCxGG1z4T3rIcvfXCIF4UTfgUCeruYCwKvx3dd1I8HhACf42ishjDN057DyCAF2JzvIqYrvzdMgsOUMu3YSh0aSf8bqTIXWNzQBfX5KyeZBGIxy0syIODb5m4pKIB4ahrtBBdl5Meyy5t/8bh03oJCJkKiRuepoZDEoq6V/RTkOrp5x82xyHMi8
 0MWoOg2L
 ieAbxa+5NMvVfFJ5FVO65H1C9B3Uwb0D+RfEGWL7QaCnZjLpkYgGf+Mule4xH2vYPCOosVF/OpJjEE3Gyda1ktFHEeZozifTfo/dEkEg5Fa7Z9vYH6M3V+ICaWdFkehQt4wFAnttSvA7aicbuFi1t0y183oNP0lVnpkdLBbYrwbP4HimytWZ9sdbm1LMps0sXKLrKjZsZK5MBxoeetnJmiPgVRYUhtJFfKnRnVUwQiMcDbRRS49IzfRWZzQ69cKW01zWl4gXPvP5594BvcVNEgnwvQjZsG3No2AoxPguBEM56xLUd5NUCvWkLt5AZNGMuYYU9r0E/KF98G9ve8RFbcySo/zplOo42OoGcNEEghnZpOs+P990Q8Ywn/qQHsVnahPZoRqi8MEUkOt6Gzii1aLX+eLum1dK+TdqNDJZpiv9XWpAFEpWDxoQBPDaaN/ZoW6UmEpH2YTUF1TNFxtbbEiL0xRGC1bm0HC/QPO3WPtB6TclUNXut/jwDGFXp976ariuy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series removes ten static inline helpers from
include/linux/vmstat.h and include/linux/page_ref.h that have no users
left anywhere in the tree.

I found them with the kunused scripts [1], which I wrote with LLM's help.
The v1 cover letter [2] has more details on the scripts and how LLM was
used.

Changes in v2:
- Split v1 [2] up by MM tree, as David suggested. These two patches are
  rebased on mm/core.git/for-next. Remaining patches will be sent
  separately.
- No changes to the patches themselves.

[1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
[2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Shivank Garg (2):
      mm/vmstat: remove unused folio stat helpers
      mm: remove unused folio refcount helpers

 include/linux/page_ref.h | 24 ------------------------
 include/linux/vmstat.h   | 36 ------------------------------------
 2 files changed, 60 deletions(-)
---
base-commit: 94c0b03721e5a7187b7a017a18f58a50cee4f29e
change-id: 20261109-unused-sym-core-08c79d42936b

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


