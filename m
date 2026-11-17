Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA3D606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jzP8likt
Received: by kanga.kvack.org (Postfix)
	id 2684D6B05BD; Tue, 17 Nov 2026 02:17:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F776B05BF; Tue, 17 Nov 2026 02:17:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155E56B05C0; Tue, 17 Nov 2026 02:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB9636B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:17:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 786BFA035D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:28 +0000 (UTC)
X-FDA: 85443755376.04.E30B02D
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011027.outbound.protection.outlook.com [40.93.194.27])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3944D40006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jzP8likt;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.27 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794899845;
	b=mhbDdXgTt17Stai/NOslTTc84FbDsJjD+PwtRip93eXShZs5TnqCuQ2Z8gEXC3gXweR6Mi
	x/rE+QOx1Hc635WFeIpwJqN0V/TPvByxgw9STMdiwHxAyNDNzEqmMSS960XjjjD799Csjg
	jDOWzn/kkITmhE+O3WBaNFJcs/sfqHQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jzP8likt;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.27 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GONDpkblcOJvLVbypKC+BDQYgzFpZgqqFHYTmmwdxyE=;
	b=4DhbvzD95z9oXJ26kLyJFOG9vW117Re7B5sMZqLKn9m6qVHBpwN006WGrNOnAr9p3h2AJc
	sNt+UZPzt4f6/B8D4INzSW1iJX4xPs4xgM0dMFrT7jjNltfvvHsoTiUUeNiFabryosQR0o
	h3Py7wtcrgyy45UY8bfXrNdGHMqJBQo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dZ9w4pOzQnXhVJxsKI+nJfYQsm2qplsrhauzaqUxxHM8VpVgnBrvtxV3cytdlQO+OzzqY+G0qT7vIbILU8h27qR/0ddzN8x/vwaz2TolDoQG9IGAm++2Svtk7cMNeaMNMxImhumeU7y0Ilj876hgnHGpkSOO3kaQra4IKFwUlZhl+DZ8ruvBGOqQu3S5nZSHw6gDuGxTKf78X/xX3cLDcUpKuYvCfIODWyYDWyu59KVP7ci7Lf7f9Hel5VCki5M+79N8IHd4VA2DQRIndKIvARdCc8v089+i81kKYx1V9061nVhR4a8NyAwqjRUDWwvbS1rxdO4yBzFiXEORKjtDIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GONDpkblcOJvLVbypKC+BDQYgzFpZgqqFHYTmmwdxyE=;
 b=lBCkbmT04C6kLMW3nGQiVzFTivuLlOxlIydlkDpmljU5md1zTceXy6PFtDSXbWYqZnVXo0LyLVs91LfQ9oI7lQJ7vSRAHmUeAmj3NWMyGHL0cg0Mt24Y0+4XSlI7evsCAEqaIWdoPCEod+LjYajE+tfT+2DJ/faeZ8p0MIon92xB4SwbL6+KuxqXh2YsltKnkeRIemtX1iHLsywMpMgfDTHZ+1UzOZ/5itT/VgcEXlsBlhkYU/hBILherQMK+4KMmgkgASeVONT9ngzvTZU6+mzSJYq9+yOrQeXV8zSjV8vcS9oaIH30OlsjJrhYMETcZpHNdhHiNGXQpgJlRNVa/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GONDpkblcOJvLVbypKC+BDQYgzFpZgqqFHYTmmwdxyE=;
 b=jzP8likth+eqRZizIqcboKKQm5Wgt3cR5SDsoFGSnt+mt3iw9ALPrF4JY5EcdM6WRLGJrrIMUWq13Ak1Yk9PplLG+8HYaIPnMX5mGRTObrpVajOZhPl0A2p3dtpyA+IFSnQNmesmSEfRloMlDY6KPbF59SNaeYw+akbZA5gRJsE=
Received: from CH0PR13CA0040.namprd13.prod.outlook.com (2603:10b6:610:b2::15)
 by MW4PR12MB7190.namprd12.prod.outlook.com (2603:10b6:303:225::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Tue, 17 Nov
 2026 07:17:19 +0000
Received: from CH7PEPF0000001B.namprd21.prod.outlook.com
 (2603:10b6:610:b2:cafe::63) by CH0PR13CA0040.outlook.office365.com
 (2603:10b6:610:b2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.0 via Frontend Transport; Tue, 17
 Nov 2026 07:17:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH7PEPF0000001B.mail.protection.outlook.com (10.167.244.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.0 via Frontend Transport; Tue, 17 Nov 2026 07:17:18 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 01:17:12 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 17 Nov 2026 07:16:49 +0000
Subject: [PATCH mm-new v2 2/5] mm/swapops: remove unused
 make_guard_swp_entry()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794899821; l=678;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=cbqqr7piF4YSkr6W1BfNjAnWbO0ioXEHfqpBufV9mOE=;
 b=HEWEpPe4f4Ay2ZJA82gZ/ns5a7GyQKSGOiU73CeFbHUnPdGid9v56zYN0ouXC8if+/LUzl48G
 r7hZAsH4DkPAV7h/rWq87+2hRuTVuTW8i9r+EsG4Is3bPe3TqiKQqSi
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH7PEPF0000001B:EE_|MW4PR12MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: 6069f1e5-ed64-424c-3e74-08df447ad09d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|23010399003|36860700016|921020|10067099003|11063799006|56012099006|261021123027099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VgicG9X/go0iyHTqhYMno9rSVZRUFhfGgLfXapYWsvf+aj+/FewaogQ4CNsXFyzO7FKVb5HmvVuj7ilqzxY2m3bOWqgIAPkCzYwJ+u5HniQ/E2S1Klp2MV7egUPnUKb0Hz+7zsrdmBBBMvH9qAnCmJj00y/NkkLIH8opQyOrvT0rGnOSh0A+egTMH9W5Mixs0N4YN7qwZzIexXzcD0s777qZEE5CJ+9o5zKk6H8rtLN3gNNzGmC8gmIOcBNE19Nv93aBgjtKNFaE5T7e0xyr3985/GI/G9wjeoFLdV7HBvTlBgGYJbj4Ms9fRu7NB/6hBXA6EKPvasEfx9AjqhUZcaNTh1BNI7neefj++tOCGma1+h7vu+7mrMF+rAaAlcHy3Fg2c8dVsO3EhCteEYjhVsZbEOzepPhMf5fCAQvrDZpKYzNTER+8EORpnVCGqwBXjuuylL1UiHcqEFRfe5uRIy2sZvpO552sW2CdHDL15YF+O+PVFyjKO/T9jqlaEAq3nuZ/9r6iafHrrXQ55p435HaKga2Hs4I6NH+g4gSBDb7nn/iQw/nscUNGuZxceNC2uoyEfsA9oCP1Z8IMPgMNMU+wGclej8zbJRPBVkTWdMPXgru3jE7/dVdAtw0s/cL/2Q1zKkDNKQAlSsogd+ZwRtprvC9AybW33VCGMZBmTQeD55iGMU8Z7Uamf9T19X+fS1H3JKJW2030RrQxBvFP5//wSjfDZc5w+AOR2koBqeIGlOHpITLnwXbOLpQRDtv6
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(23010399003)(36860700016)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZUi74z8kcsv3LE28EzhPDKta2SUOT6QMWx88Dl8TBn+z+a2Gq5Vnr0vR7pp6UTA6Jr2QqrOAj7LrJopZNfMBIGcDfVO/04MNUCrSB3aVxd8SyO2aUAdbPBdYD3YX/JqZgQOdtbmpVeWPPIYtrv+QBGxt4N3NnB4+n6Gli5cnC3XZX77pygjtMaizlptPHsWKeApJ47d3Ak+eP1Z/DN8KezS+tHH5QOfoMYHsN48Q4RHxKI9aOmuC51QQ+6jXkeky/z5NGr1dOHnx2HL+IdKJmQLhZ18/FJB1zcVRu2n2hzKCBiBc9kLo6fZ7k4mP3eUgIYCJI37xnrWGNQHj73HSb2y2PY8SygdvpBVvUOORE1lcaEkMCQKPs7xWN5r+MI7RhaG2sYI5tZXjQFpaLfp6Nc8LgFIhOhvi5X4aMtq7HDTFFzoKejZEnoqOrJWOLNPt
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 07:17:18.5924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6069f1e5-ed64-424c-3e74-08df447ad09d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH7PEPF0000001B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7190
X-Rspam-User: 
X-Rspamd-Queue-Id: 3944D40006
X-Stat-Signature: reh76wnyhana88k5tdufhxy6z7by6pdz
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794899845-379714
X-HE-Meta: U2FsdGVkX1/pvDoeQSV8PC+qMxxwJ5v7k1E5bbarsYYyzYLAVFuxHaogH3yH4CWwOFcZt8vdCsaISMw6CSXaiBp8A3pqL2q4cwyD1fdK4drSFcne0H4EUl0kGUv9SY9fSgdo9fI04ypzXUPr1SjZn0Ojet24gCyzaa+TXJ77N34oTVYnLdtHeBbOkfm3yydydY936BpYoI2sc3dgcy8QWHwkO0B56wpDJTmRYULOzBYXGHUXTLKY+ik46owIDzF8vNhYRSHRPZppYcI2twLrINib9JzOK5/RwfVo2JDm54T1N8LL7YhXPe4LEpUN5/spWHzDswrECnU0ruNY26lif1wT56YzfaIDHdBxuv2fy9GR9sRjxxWJCFmyNebsMP6XMZy/XIrlZwewRS++dzcZdkasSECi8xHI6/EMPy5VGlJHCW0MnQt20EVR7EmS8CmvxxnS4w1Jyt/wmMWKQubixWpC2Z6vxfVVfJ+V0QvT8USzVeFcSp1RUyFTQf79b8as3f+t05pDtCBBE/0j72StzlUZd3Gu4aiASBg3KX70H1M6JpF31QTWHfIVNtqOeUqTDoZ1Yp9+0qtwnuDVjvEaPs2tUvUrI4QaGLnyZQ9dwe7WaFWUNixI/sGY+8mP7SuJs34DEpl9A7kwfkf0w6LT8To/qtAVlc/wzbUIsOBV7iXd9+Zhx1u3xopAl63gTDV/90rNFR4kHeySF6BvldxjHdJZ9jknrpQvb4KfiBAXxmKC8L507FxMH+b+BHxC5h6Vs+KMX1spJGD/+DkrejdsUJsb84cbulkFWg+aB1TdOzAk4fbqMYfvnUZOOiJezDQSBdI2mZumkTvPWdkPpQyOtQyCY52zVHiBtKuToidA11W8r/JhZV9n9/DP8CZlGK8adNkavC0mtWzYRHJFzcoslYz9j5GMyb93adeD205XeZInj5Yral5L3XC+WJUGIrXhSCjegHICHjatr7dK+Z0
 APQ1nnvm
 WSwzA5hhz4kw1VloqqJVDPZP8V9x9MYgI0Eu5bdlcXMVnXHAb+hKAclVu1t9sL5VVmnJEy8NxmHji6NjxULAHt8Axs75ypAgmj0Bjd/a0OnC3ogfEBnpA2o/NaS88Aggqtg3VTsiu9tzZpsEBjBlK74wx0R/Xb1LWhx1dtyGyKWswIhIa1NetKnw8rdFCHlYpfxdOMoihtUQ/Z/GlN1cymojA4mTZ3fvqJOiWZ+UrrHrXSvyYvp0vN2ZGYeM6yuF9CuSAycOs0DEJCAW0a6r5HW+HOTnpRxRBn9N0xVOei/nT2f19kNnsbZoZIGBaxARDlG11GKn9oSRKYNYkIkO4lQ7gFf4FWzuIgXUn4pKKTwlUmw6UMYwdhsqiwe3USxngxW4yfZLP5O7fQIc8xxwrWUdEZKk36aKEWNpJ8HDaV9YWnwUY6ilgGryJXIFW9yCHwB7QiBWr477Mnbvga/D68aznBQdrrfqnBUkXDs9/84XFGN8/+RepHnDeHdBAjPDbv7pb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

make_guard_swp_entry() has no callers.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/swapops.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 603f9e3f909c..6f62fc3c8cfa 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -306,11 +306,6 @@ static inline swp_entry_t make_poisoned_swp_entry(void)
 	return make_pte_marker_entry(PTE_MARKER_POISONED);
 }
 
-static inline swp_entry_t make_guard_swp_entry(void)
-{
-	return make_pte_marker_entry(PTE_MARKER_GUARD);
-}
-
 struct page_vma_mapped_walk;
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES

-- 
2.53.0


