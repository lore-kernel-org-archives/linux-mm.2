Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA10F606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=S16ZteXu
Received: by kanga.kvack.org (Postfix)
	id D3E186B05C0; Tue, 17 Nov 2026 02:17:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15E26B05C1; Tue, 17 Nov 2026 02:17:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B736B05C2; Tue, 17 Nov 2026 02:17:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A20BE6B05C0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:17:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46765140313
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:33 +0000 (UTC)
X-FDA: 85443755586.08.58BDAB2
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2D44E180009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=S16ZteXu;
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.19 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794899850;
	b=JXKxzh9DlvZyR3AlA3yiQdVTvTvGMNfSGPrlWs6+YX7+pAheKv35J8Ahxw3M1Hh/vwpm4m
	fbYhslYWD2xzl6HJckWnlUwnYid86daN5M/KCrRmfqTV50LXobe52AmPuUb6rOUlzQAhVm
	cnYk4c5OjXPPx7Iul1g++8dhOhDJU9E=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=S16ZteXu;
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.19 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhRKRDvMYeKRq8t6wR6WauC4ymlRcWzmVHmXqCbJJmc=;
	b=kCVbKo7Gcgnu3bJ4yYgwuDnF0ue+8eJ2RluYkKHa1n3dipv0/X5Xevae5jPFaQhF5Q7sMw
	GrUxEMnRy9vrqF6VW+pKhtNs0W31602IBZ1XLI4LUaPtg5wmydXel7ckyqJ4pFqn6kekAy
	LZiA7lLGNoKlnjlmKbiW3rDTH4dH4KE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUrA45kxcrUXCNzFkSjVhlyjp04yOofBabNURNwqzP0HKlX9/CgtIHF3/CSg33ezr856WBYuyS7hMSw+mUHWRxEatGYiREqM3b0hz4M81VtFCXo0yCj75Gg+PjO01czBsjmYmCR2UawMD2er3Lx+0APy81hL5DC/w90fZxlPKMX11CGtRh7+ayHdQLqoDNEJWgSLrrH+Sfdn6oCvCk8hNXg6lm3McUtLbo2ZmTgDi0zjTSMLHHTiE/nfuPY2mu5hWmZ6A3vFc2v4kiCIWJlFyhK0j1zefdMv4TXjn4lAaFQkGtUXQeuV5lY9wjR4XECM6RAfkq5upQsm6/u0brEuyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhRKRDvMYeKRq8t6wR6WauC4ymlRcWzmVHmXqCbJJmc=;
 b=V9ORzAcCVM1okEsH4FwY/TdhBrrP0C/EpIX1TFswYUpScdTRnJ/dzbarMAVW7QillLuTP0z/pqn9ZjscvWzZ09ij2EtheZQ5Op+7C27FNLHuVYfBGvcWrxrGRme3kPSg/lMX6iyIVcXAbNNQhPZC0IEkuKsOM89i5K0EqrXl6wSVb5ZlIUNZ5IJPFg5Cmz9UJbFz8ZPwQOAzEcP34SwKdudqH/9CUSXiP+Bz+wmCK2jLEQ4FzCX0pmrgNCHvBJ+M361HpnrST+P322LqJ2ogKMevSzFB+d+TVjbq5gOP7JytZQ20hQWgqDUlREvCJKpNkqVJ+EN348FkpENQgL2n7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhRKRDvMYeKRq8t6wR6WauC4ymlRcWzmVHmXqCbJJmc=;
 b=S16ZteXuiMncW4OX0Ya89BOXGYcaMMnoHD1hhvIdG6O3FPDq46IvvxM4H95OeVXwsJ1a067uqE9OJtMYCn2vso1Gzsdicdw7DlaIHKhKxckKXyiNChYzyf3UoGqp/hf2gABZHYzsh8iP0hIVBX32Mlbak0h//Q1gCWw1qFERQeY=
Received: from CH2PR15CA0027.namprd15.prod.outlook.com (2603:10b6:610:51::37)
 by CY8PR12MB7636.namprd12.prod.outlook.com (2603:10b6:930:9f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 07:17:24 +0000
Received: from CH7PEPF0000001A.namprd21.prod.outlook.com
 (2603:10b6:610:51:cafe::46) by CH2PR15CA0027.outlook.office365.com
 (2603:10b6:610:51::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 07:17:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH7PEPF0000001A.mail.protection.outlook.com (10.167.244.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Tue, 17 Nov 2026 07:17:24 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 01:17:18 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 17 Nov 2026 07:16:50 +0000
Subject: [PATCH mm-new v2 3/5] mm/swap: remove unused folio_to_swp_tb()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794899821; l=812;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=4PyAIKcMg5mDnqU/Ax5f8TRMcaitQtbJu5JCfPDiymQ=;
 b=utq/lbiEeTxoXTcOMh5yHlgUCrh2Rj+wZGLz+HLp0oU51cNX7LWSp9PB81vU6h1kRCltQypAQ
 ASpcz0vX+W+B7w+Y0sXTxF/x8oFKvZ3dqN6I7IoRyVbONIsnnjjmA4F
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH7PEPF0000001A:EE_|CY8PR12MB7636:EE_
X-MS-Office365-Filtering-Correlation-Id: 44c64ca5-3c84-4727-ca05-08df447ad41a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|82310400026|36860700016|921020|10067099003|11063799006|56012099006|261026121527099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eG4bXr38PPnTw21cXmlGjYsS/dYKm1bjcUmcElNoS6oEY07FzDcgJg+JOWEGSQnUpHtdOPke/eDbUUpMTM056fKIkcjOIkL64V4x9ON26CLWYUHC040WCq50lB/ZCwHK6K7MIxPk0kqRrlBAYLLP463tMI1HZnLB+ajiPGuwQzToHoLdqnFHXd982B0MG3ohMozCM+uUvKsk0jv2yLawkerZSKjnSvvlMmj2qlZbYuvxlOltDBPoltCX2fRPPgtdPLqZFjT72iFm6+uzNvXSMMw9tpYGDIAGGtk4yyL5oW5oMcbnLY7JamRcpglli32aBdnkYX1O4pBokPgGT6utCh8rSGitRfoambDdUHS+kxtcqqruRYmocdOO4a24/ndxVf8aZJ9QR8JmBUH4I/BKkWQxQOD1IKylXyoGsfabAv9B43H3dL5XuVBK6kwVn9aRDzb6q0j+KuNqv2mVlIF7SndenTSQxV71S9hA3VlnaKltfastu554qPY2m0Nw3jul7amP9TDHK/QnsH7MFe9+RfFDiJngKGhU3k6Ryq15+AavnlzYX3S4VS92ckOBjxm9ETLNcmsVTttlKF3+yWwEq+T2dTLIld/BMxSaa1AnJ+E1kxJJusWJYMvm7+uN3qt6o7N/u5zRxr91wC3L7anOYkSadNSSQrjAOGb1kbcC5p27HHEDMg8di77yD/MDy5sHk7MaMivA1RrvqnEP5hIQeL8xbibdRwyed3R+O3I09Yby+r9/bQLJ1Yr6pjMYZzh7
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(82310400026)(36860700016)(921020)(10067099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yZp/ZdwVPNcwFabsMpBg/2z078H1GRdIbV3VgzqBzQILzF1nhgg8yrtw1zPO6eYkNo/sJilIabnhEs4Xxj323mRA+kD9UO9YVUxqS7JZA+QzkCYV7D8sGjK2VJHDx5TFfNG7nDITC8qBnp+ngTWmXdXQ26Ji8ny6RznVwGkdyzrxlcu70ZIk6bx4XjXfCqDhThC/yOgRBkMsxRWjHWMzjFO4vl9lq/p0gHsRjJiIk4tMiRVe7v11fwNbU7r5v4YcHwhP5/jtlhkI2khIP6Y3GnAMSiYYtpQMsWV2phPdPUnfD4OmIWHdMyHnJ8V2DYUc7Pb8dytmpaZpjKjjYkyAVp3JFQnxuiyEOPMMsU9KVg2fXrfjeFdNG2l6NKFctwV0erCZ1/kG1sDewBkAtjMAJXackG83nZ73hDtWusJ0eUL+kV3ZbKcjQLoJfUoSB9Ql
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 07:17:24.4573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c64ca5-3c84-4727-ca05-08df447ad41a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH7PEPF0000001A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7636
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D44E180009
X-Stat-Signature: mi9rwtujn5n35djyse65d3tcoad3h7oy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794899850-66290
X-HE-Meta: U2FsdGVkX19GLG5gNf/BglXLYk73dDG3aE5gfHCvdfCA3c667E6nKmL7OEP/YiwVHoBZmUWmX55Bd9y+h2u0WZhW0Lh/ykYSklvr3QAPuObsGIRGwiLBsG6jMRtfTPoMAtnxkqh3bELSZrPej0gddnH0vkrHE88GMgHu+KHaMWjulrbyUuX3Efz0iOOGna2WfLu4KP/lrMhe238nrbExbt9ZSndfP+gdrT9w+lpc/jTWeAySsYD9Ilo+s6iMa+SBRzmp7hAOnfwk0D3sH26sDNq2y8a0eA++n6QN5ZMeHm3AZp5cD+52U51kymXAflFhqgFGkjH0SY7REyW6V4MTcXNCgHoAlRunEI7AEfBz3cDamHv1+bim24yltJfwzKTqnMCpy9R5A0xewnocpWYoofUX6AkIktdmX/9Cbz3g5MvKrIw1E+4huggLNpc32SBW+1iTp3H7LzNFgm1M9G0Je3Hujb+A3ywudE8IsBpLliyZ+JcLUmrYZRJqa8aAtI6j8x15i9n/ptLEefgfhg8Ye6aN5dP31mDH6mox/CHRduH77NeCY7VeDVBm2UeL7lyEgUgULKyX3q5J/2/0Sz0AaRUcP8aCfLgQQPepIZY1Ql7cX97NWl8gPqehLLnTv4DBYwYYvNXZoWR1eL1NpVoF4ErfZXG2TBIk+mUIpcPXYu28Mtc0vHUSxxKSIItubYATAhwUyfQMFb+ehA7gh1RX5dHVEPHcymMbatGsITy//7qMvea8/eqnX+WFh4cfPtJnm/yZtOtCLCqaZZvIYFd8uD9ZNt8vCQm3ibYKHueaxsJRjUVahJVO44xKmMqWqPiQDPPLwGYPWXm1wfJVRnBDB9jNIkNut0isPfBzOZapN1mJeZsLGZmSYIi6FSBbXqSxtnH+K5x2+HxrzeF5WPkIdukDmNaD8vE4BKNGG5JIKbWpKt0pIvaOwLlokjR2cm6EybsjIHkWNzTsbPnjsah
 zDGstKnX
 ab1EmZZ9Gd7WLdl4w1FjxA+Ga04mrPOm1tRXWI+KRMJeuAmpObL39LaEZdRsOmHIkftX7q3PD0LR2QbcaQ6nCKsbDpBspPrC7J03AWEP+VlXHYDahDlV3HyfhBLHBVJ512SUBsTRm0lga4k3q0XzmwRfgLtglwlZga/zN3N+TV5gWWHnH61oFzIZHU+WtiD4c/3AixE991jTaWJMlLJEDd8rjzWPROQ/WFm0btcZliKsV0iMLuaQX+comsPGn+pHE4MGAX802QJbOkB0CmbaFFhYg1LqwCaGfVISsZA+VRg39DdwRMFtCnThMCtZiBMgvQhnclNimBgAgE8jlYu6L/rk4RaqC1m3q3XAsxXKM9LJGcwCebqoRI6uEv3rwseCE8xsGt3Ek6fai4d7SkIFvO+4uu9VonYeUvRYH8t9EsiV90lBhlvGJsxS+0VMuV07lD5l11QpHYHTWyOsv5MHQQ2t9axiuxejEuAInmgYeh32cKyYJNFa+gwVWb3Ru5N/7m8s0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Its last users were removed in commit 0d6af9bcf383 ("mm, swap: use the
swap table to track the swap count").

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/swap_table.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 072625d60d54..022d2251884e 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -135,11 +135,6 @@ static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned char flags
 	return swp_tb | __flags_to_swp_tb(flags);
 }
 
-static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned char flags)
-{
-	return pfn_to_swp_tb(folio_pfn(folio), flags);
-}
-
 static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned char flags)
 {
 	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=

-- 
2.53.0


