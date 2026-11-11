Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3C6606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=11nyelda
Received: by kanga.kvack.org (Postfix)
	id 51D086B05B2; Tue, 10 Nov 2026 22:35:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4AE6B05B3; Tue, 10 Nov 2026 22:35:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332E56B05B4; Tue, 10 Nov 2026 22:35:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8F846B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:35:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BEC1A01F7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:35:06 +0000 (UTC)
X-FDA: 85421422212.06.0ACB41B
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	by imf05.hostedemail.com (Postfix) with ESMTP id 336E4100008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:35:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=11nyelda;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.63 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794368103;
	b=GZ+WYxDwQq7vpW2++9f8c07ANreITCs3rMbWRijQAa1KV1gmsemLaZqwQYMb6Ri2poE78m
	/wqy9kOgK1wCixLU35RnZycYCOMGHC6pp3Eb8ZMSkVew3QiIFXD4RAOJs1eYCGYRQohKrF
	wVU5KFohZWysssGR7mpRq1JqNYMNyrg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=11nyelda;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.63 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794368103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRZuzCALYYn0kyXMscCwy6W1PH7kAxdyRjJUlsHCVUk=;
	b=L9bxiiscGMTa9eur94lrvtl9IhsabJ8Gbk5uCLBveZhbH6qp7AJGvpsAfWH6a9+Uysj0hc
	dbZocU+JBkeXsJ/GrzClKqtYY2V9M18+UpEGhLEnwkU6gBagpF0vvNfTl46fftVKlqiiYx
	0kqJmzGZl5Q2390HQT5JNIwjZ8HNwOU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CjrBBc0bngGSBdsSNfmuttzA09bOSGDjZ+mUfZvCYRJrmq2Wzwo8CerCT/qTYbj/iC7G7AqJRsLZQ5Z6RLsuSgSQT2RanG0wS0SuhT/IBdunFSfMwezpTmBJ61LugPhGmG+hEaERA798sqdss8q+Ai+Wy804XTOe/FQ15WUxtuByBv81qEeLrAxPHF7ZoBxVwiipX2c0jhN+M04DymsVC13esGWkk3tzvMqzz6UtR/gfEBwG2vDeAHUtZLknO1Qh/Ue30Ktq9KZwurAj15jUhKuw50VcisgsUC4/I4GhOfeP8evKtg1NIs1tQPMuLkry6DtWn/mzLCeyusgE78bpzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRZuzCALYYn0kyXMscCwy6W1PH7kAxdyRjJUlsHCVUk=;
 b=gHb2/BFznJSvgSc43rg75IZbqRGVyE2L/PRXQv9Yc3z+I6/c4bhlnrU9B2sg43Xo3TwBKRQR89GeAg4Awt83BhfgVi99YNakmFeD24I08bYtoB48ULZ1RL6LIff07iObSv5I2fN87Li39e2cxP4CFJzEWF48O+buxu7B6s2ptDGyH9CSZEqeKUHbNRVQKVO28cqS3F+QMT6CLPvSOP1hYMZ1vtbNMT1dVHlg+YxUgMMvmBZ0Hqd6xBdMua+gOjqCHzSXTTwCzqbwsXg5mfElvIyhxl+82EylsTA0hMYYID08qgXnu1eCEoBIvGTxbZTlempeVZmelP7G1yTRPv8/ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRZuzCALYYn0kyXMscCwy6W1PH7kAxdyRjJUlsHCVUk=;
 b=11nyeldati2waF07aPQ03qaY+m9+zR33vZ7T6FNm1UjPkGNb7CnlMtaYDAdK3gP3kwcF3z8hNK2OAWesyUtlV3lT2/aZlQFvuQmEgnhJ/uYyQwBEflwxxjn/tVh3anBsMiFKFXGHo57/djTly5JSKhTOCcabdu7qUA0Fmojr+hM=
Received: from DSZP220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:5:280::17) by
 DS0PR12MB6462.namprd12.prod.outlook.com (2603:10b6:8:c6::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.12; Wed, 11 Nov 2026 03:34:57 +0000
Received: from DM3PEPF000265BB.namprd04.prod.outlook.com
 (2603:10b6:5:280:cafe::94) by DSZP220CA0011.outlook.office365.com
 (2603:10b6:5:280::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Wed, 11
 Nov 2026 03:34:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DM3PEPF000265BB.mail.protection.outlook.com (10.167.23.248) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 03:34:57 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 10 Nov
 2026 21:34:57 -0600
Received: from [127.0.1.1] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 10 Nov
 2026 21:34:53 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 11 Nov 2026 03:34:34 +0000
Subject: [PATCH v2 2/2] mm: remove unused folio refcount helpers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261111-unused-sym-core-v2-2-3edc7fb8581f@amd.com>
References: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
In-Reply-To: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794368087; l=2154;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=M+/pny9yuCAqKJNhALtl0LQlutxxgfbmdI0JnRD5gJU=;
 b=xqXii487oOE8Wrsdjw6TLK7BLtNsQFkhj5x2rYDQ5k6N1B17ziNwrd9yb2k86gI523PpIRz+T
 seXrq0dF9zoADSH+8LQGxqPML98FXDEDMFX2XF2p/uA4nyNoN9HqmP+
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265BB:EE_|DS0PR12MB6462:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dc66e5d-ad71-4cf5-5fb5-08df3fa4c221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|1800799024|376014|82310400026|23010399003|261102123227099003|56012099006|11063799006|261021123027099003|261021121427099003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	d1KH74EFbxNCfIQeR/+9MgHEZo6eXzpJ/V1dbtUZ4MV4X3B/5iqENBYoVTm+VyRO/mxwdJ5VDYHHfMfb1eXik3RzPS94OmYvqzwnoViby6ks3xETFaR+RUUBv9jl7AWHrQf6CZ2Tt0nWwYDKb/7FcUoZlwX0B2nOqGetzuyT5YG8SM4G0KzwEwwX6nTVRcG8804cMDPkzx/xrtXXa6IUdpCDAla+w9726pruV6GGRWVXZ/00crjOszCxtbMiYZrkx1eO0yVGacvL95JKQ7oxAamScnXP7AwSzxiOgCiRhQ4OBjtYHTnhxEg+f68+az1PM0UjPJjoumjM4yx2kKy8JuNXc43V+qP1aZWnfTaHMAUvIU6V/cwwAldH6w2W+/uUi1WCfv3IlGtYvvoH1ugGMna+u6xP9xbkbyB257OVrud0X96jIsOs+nP55l0BXe+YnzIMvdK+6EjUCfIcyt8qbyTr1/u3VhDF9uk+t0YfnJSnvdtAcPrMj53TpQ8fX4FD/Zfw3oazifhSapynSPj63c0yFofbkwfhs4tP19XwgadpNfy6RriW7EmXn/nZ7IqAPE181JJXgKAPXcM0+euO4jckW6/3MJgjO6VGmoJd1vOTgN/ibQ5GVJmhi5XorjQGOpr/+wowwqnxS1SHvjG6v+gp/IZ8wq9qbafkuusfBJ+opQt/jAiMwEvmFVGGeyQg6wtdRBABe6UCRSjv6vMH5Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(1800799024)(376014)(82310400026)(23010399003)(261102123227099003)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NcCXNQh2p5Fpca1MYul6moxUopldkCqNwUTgys3pumcDmjrB81fhZgfvL5wlMO8r85KD84OMrMl6JRq9YxnAgr9fPC6gNgBzxooqOAJ1k5054rPh0dMaYbobKqYS3V5s+Afk7rbRBxH/GVOpO+z8k+UMpfIO1+o2JdW57Hw1x72rgDiNjYKkgSsCu/O02T7msIEUmBbzNwz6ACzrVpqf2K2+8TpefvjRDNBgC1O00XStS8/TxZIaN9tK0kaRXwuDGE7gWI2uL3WA2AxVRWE0EcBdw1D5eLQ+ZDDdE4OQaC41bT5YkVbvedR/6D/D/IRba9xScptQwKwUISfKbrf38HLQSQ3jq3fCa5q8vyikxKG8Kb0p9YsQZja7Qydz4k/OobxScCVYNnwJBkEeQd/amd3NtxLiEkQBx3UY/0PO6kgGn/VwSQBW/3EwNkjMoQYF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 03:34:57.3542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc66e5d-ad71-4cf5-5fb5-08df3fa4c221
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265BB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6462
X-Stat-Signature: c6y3i9coqjphtj4xitq6yignrde75y9h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 336E4100008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794368103-925035
X-HE-Meta: U2FsdGVkX1/PkFM5f6TLlc93L7jS8R4n8k24vInrkdmHxuJqKEV3/hkQgO5nIkl+qM9JRIf9b8M0t/mkHnvuQSIb/qXdBCwKJ/040xiUdR7dcHCytjWm7NHhqh/yHQWieWqt46dWTYzMnpbHfel+OFZNnauklSBkdgH+ZVbW1aa5msCQ+HSoHuoVARaoX48FtQGw4UgnqTK2Pl+4WJDzAaVbwIoV3qUFMPPA2CgUjXrVKNYbhEGp248kMyxr1KtVs5IMlF+GgVRJq5AVL1MvHI/f8PpQQDSV/262g60E7wInKgGqO5Yfk5+Ly6oADotQNwHTmAEW2r4ApoL/wijbJuQPCymbsIDV0Kk2jXMp2k8IbTT9wLQMxVaEl3Bxtykj6UlYFS1VHAzfav2SBcVsojPZB7TKuiaedII5W0jvX994OVt96WkWMJT8lLw0X/nni1xDADE1gBjrfCteeviV/y2F6Sy+Ao389AqpmDB/iYr6LpVlwSyTKdWalvQMiT9g+kL8ZuVDtDyutKTPLJzuC3ZyhnfdSd67LWCs6KxYdiv0EbKXlKtx12I1Dv5d9+ss4AsQX9rTRvvq1yfaERkXWX2JigNeIFCX49KF71hXx3BX+AvxD7diSxEV1VWKjhOuVdTrkuO/KbiBDPKZMts9bkv6Bb9NdtFTfdLEBaPeWLRk/W/cXXQXTGJG7zdm84ueP8P2Wrchqon4ETL9nJZwmfsFAIfbDVVwDVwBkjNul3dfHR3D3bEXp+esnT4CU7hAaF18pb9YsSuZtohxVhBqjzieOmPJ2mD9WLJhtVKoUFqDf41oehmkyr2M4tFUTWVEoYLu7djuJiByOwdqjKcNnn1/mZaDY4hdTEtBbeif64hJbc/v9KWxxwhFl1wzriG790QWvX3SGxHJmyy4dNgu74dY9DP4FDt+9amljFfYZTZRgOC7xjZxWnxBHwhFwH2aYoenWLNedMnSMlppc5l
 aSC5N/HV
 VoMirIvEKTm5yIKAGPbOWDOBzR0IPwSFeZbEgoTwWAqu+9bf8cEUA+27TZbYPHVsnY3axHATnKDn4lM7rcPKXezwuLULJfce+v9tZ9kPCI9QFSiYx+hYf3DrsGKuJvseuaKmII+pFHjfBjyrxKA8I1i4fhvowkxAOsAO8cbzSjob2vIiNQRtabzZINujZ2y4VXjw79KJGzEFDWYuZAVckTpBoIfVCCa2HmFtMyMrIpf8R+kUnL4tkaSh+v49OWQX4y1606pcMNxqmsOV+vRa+EDwi+dwef7YlVCb6SeJdgdwQRBke7hIse8oI4ZA53gwP1bsCmfBSRWEgDbh1ez0PJqizXe6dm9ZalVqDcPwZFbDB48OXElVxtBLowgiaamYI3ugxXxG3OBuPbuu+YS0aCBdna/lqiPU0MTUe3mEuqOe2aJMAp02AlHIqlEI6URYf2G4Uw8Wi6Q7ufyMhTQ0vIuwmSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_ref_inc_return(), folio_ref_dec_and_test() and folio_ref_dec_return()
have had no callers since they were added in commit c24016ac3a62 ("mm: Add
folio reference count functions"). The last folio_ref_sub_return() user
was removed in commit 38607c62b34b ("fs/dax: properly refcount fs dax
pages").

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/page_ref.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 9f5c75d06f76..6fc20a49fa84 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -157,15 +157,6 @@ static inline void folio_ref_sub(struct folio *folio, int nr)
 	page_ref_sub(&folio->page, nr);
 }
 
-static inline int folio_ref_sub_return(struct folio *folio, int nr)
-{
-	int ret = atomic_sub_return(nr, &folio->_refcount);
-
-	if (page_ref_tracepoint_active(page_ref_mod_and_return))
-		__page_ref_mod_and_return(&folio->page, -nr, ret);
-	return ret;
-}
-
 static inline void page_ref_inc(struct page *page)
 {
 	atomic_inc(&page->_refcount);
@@ -213,11 +204,6 @@ static inline int page_ref_inc_return(struct page *page)
 	return ret;
 }
 
-static inline int folio_ref_inc_return(struct folio *folio)
-{
-	return page_ref_inc_return(&folio->page);
-}
-
 static inline int page_ref_dec_and_test(struct page *page)
 {
 	int ret = atomic_dec_and_test(&page->_refcount);
@@ -227,11 +213,6 @@ static inline int page_ref_dec_and_test(struct page *page)
 	return ret;
 }
 
-static inline int folio_ref_dec_and_test(struct folio *folio)
-{
-	return page_ref_dec_and_test(&folio->page);
-}
-
 static inline int page_ref_dec_return(struct page *page)
 {
 	int ret = atomic_dec_return(&page->_refcount);
@@ -241,11 +222,6 @@ static inline int page_ref_dec_return(struct page *page)
 	return ret;
 }
 
-static inline int folio_ref_dec_return(struct folio *folio)
-{
-	return page_ref_dec_return(&folio->page);
-}
-
 static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
 	bool ret = atomic_add_unless(&page->_refcount, nr, 0);

-- 
2.53.0


