Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49B5606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ymOMeQXe
Received: by kanga.kvack.org (Postfix)
	id D8AD06B05BB; Mon, 26 Oct 2026 06:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B576B05BC; Mon, 26 Oct 2026 06:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03786B05BD; Mon, 26 Oct 2026 06:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91A816B05BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:33:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26E9C1A06D7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:33:28 +0000 (UTC)
X-FDA: 85364415696.17.86340D9
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010010.outbound.protection.outlook.com [52.101.61.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id EFCB5160007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:33:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ymOMeQXe;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.10 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793010805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K48RSWxVXjf4bGBRpdIX/SFHhy2jrUVYvk2CD0oWZik=;
	b=iHjpNdP1rhXMQYSozSJqoSX3mKelsmty+stXnHrt508NdhrIKtfROewkm0w7lmHmd+j1Z+
	nBgJ7hS9NQG54j6RCuUIQq+R/SVvDLmtfwruivmArwi3vsDCnWlVQbaLWxFOsjn7M6auMa
	sg8R0XbhokaNQ86J1wvV2cXxPn3wvkI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ymOMeQXe;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.10 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793010805;
	b=LG9Y9bIzdtsQLNzpa0VfP9weqdZb6idEW6FPEUisxfOiGc/vpB+FUnBoUKtlvhKLmwkd2r
	ithWwLP/bbLFOolXJSEAxHRf7C8JHLIYBGGuI3NY/jNTgOxiVbab8DDOWIb1N9bQ1WgCKO
	z6NFkL3Uq43YiJR9Bzo15xdFuR6OLUs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1uYD6AQQVEOj28fRdDhg4oQSKSvqfaE+On6KRXBaaHo9gftDMTxgcouYF65Cpr/3DxM2rTBmEdWoDvWrL0U26/muZsWdt+A7Md/sRR8EjsKrjwxrfDTIDduSVusAlLXE7pR2p/3pjqIe11QBqx5vdGLCv+ArhJQUKqwh5wOdjHCt7Z0J/7qBjAN0snMkYpBuY83fQwVntH/tvXBS4OikJuV8oA7YCX4oyP2/QAKpZGUWLU9yLCwNlIPPi+B9dk6f5mpHeYmr4LbDT+l59vO+kWkqnKZWzE2PAEgf0f5kv20EWozX455NyGw4PN3NuND1/9aEmUrDhSHoDcSFkoVmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K48RSWxVXjf4bGBRpdIX/SFHhy2jrUVYvk2CD0oWZik=;
 b=QxjfEaNGwQhJW67GWF/OJcvG/DA+yyiKLwVuls70iR/RVs5JBSaA78Vrl7HCFYEOX4huvl+qvqzsW1+rWsR21wBK5uPnBOivMWUfPVmFgs9WVEK36TLWiuGink8eHy0PZ7L1Hh/tv0xry2FP88fcywWMBspB5gLqcbhYjKMHYmeepmcbk+aFdfMxpp/dwDeuqtU7feUVPy25+0Z5YnNObsDQ66xuUAiTEfVTkLFJooo/6XgKTeNhcdxANOXS8sEu+FvTJQ2DC3Wg2HJYl6yxYUfQOqQzrp3V1bExBcZjOw1/t+Aav/vSBRFYCISDuxUMajJYe+LnuPit2zIoJYewIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K48RSWxVXjf4bGBRpdIX/SFHhy2jrUVYvk2CD0oWZik=;
 b=ymOMeQXepOByZTMj+9dutznE5kwHvh7Pk3xhWo0hiKwjt/3asGAbNDh055QoitpkfUb2ChAecPsnlvBdF+BuKEt6x7+HPhr3Aat0IMZFKszD5T/WwEK9tl6PqvbeYyIFbXGY5T7rWuXMiZvh+OqbTnfgO7amKBy/OpGUbkS69aU=
Received: from BN1PR13CA0024.namprd13.prod.outlook.com (2603:10b6:408:e2::29)
 by CH3PR12MB7665.namprd12.prod.outlook.com (2603:10b6:610:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:32:49 +0000
Received: from BL6PEPF0006C3DB.namprd02.prod.outlook.com
 (2603:10b6:408:e2:cafe::13) by BN1PR13CA0024.outlook.office365.com
 (2603:10b6:408:e2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.7 via Frontend Transport; Mon, 26
 Oct 2026 10:32:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3DB.mail.protection.outlook.com (10.167.249.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:32:49 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:32:37 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:36 +0000
Subject: [PATCH 8/8] mm: nommu: remove unused heap_stack_gap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261026-unused-sym-v1-8-82ca2dceabe1@amd.com>
References: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
In-Reply-To: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
	<baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew
 Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Hugh Dickins
	<hughd@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
	<harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang
	<lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Youngjun Park
	<youngjun.park@lge.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
	"Muchun Song" <muchun.song@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
	SJ Park <sj@kernel.org>, Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky
	<senozhatsky@chromium.org>, Alexander Potapenko <glider@google.com>, "Marco
 Elver" <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Bharata B Rao <bharata@amd.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <cgroups@vger.kernel.org>,
	<bpf@vger.kernel.org>, <damon@lists.linux.dev>, <kasan-dev@googlegroups.com>,
	Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=584;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=ddFOUUq3+2yZUzqYkl1mGXYr6ASv4jHOikmqwb/T8uM=;
 b=1+pgLWuRDQs4MF82tYrHU85Ic0ciGsbUX+A81e84zi9BOimRiU9ayDeVEJSgAtnzqUYQj2x9d
 Qdj32hk8atyDxErgE4OiQauteSXO1BTWonctlilbHLxdPsD+yLQjzzo
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DB:EE_|CH3PR12MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: ca67b578-80dd-41d6-c18c-08df334c7b6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|23010399003|376014|1800799024|36860700016|921020|11063799006|56012099006|261021123027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0TstBheUepTYiETAbc2PbfEvfr26gKbAEDfnsbXhkBoOJuaoXyaSnpHamDMLFGfX670AIQsN3uVKjPQgoiWq5Bwa1FDRegB0oIU6WfKw2i9BeZMyE96SvnSi93r8mLQzO3mniExD8H+rtlEJIXmV0wKgK1sh5MRnCxNDoXmGv2jx7VIXFQgno30HO6rUuL6QfsjN6LV7m7gnwUBjinOYKSLEizfQqXFsalkUN2naR3a5Z31gABE6Ljvds7ahEnSpb1WY/PTzchBnuZCkAD+PwPQyEQ43eCCZjLIf8pGjTTeoe09782sDY7djXM2oAmb1ioyJqulNVW0V9Yr0A1zwLaA+9t0ciMokluAuS7wgkySCrrLIOVb/NOcKVpdNzrB/cU+9aglf5ewSTQ5HTh8LDsXQVya4mfV2v/DduxKDIAnHAXtBNn3iHJzqPdP5ofpo9z42SBvuMKx9I0PCGbG4iixIBiRBVAdJVWiPfhbM/fUhYBZiEFdbmsah7O1GF9JOVs4e7+mwI7XUNs04EiXJsLy+GjQJq1Q2YCwHBBQbAhIYk999GM0TRw1g77xY3jaCiLSaceGJiFt5/8US29q74zAzqiZzr7Cpjigb4+2F/JqC6t5PF9PvCJbAht4Pnb/GdCoJO0kv4jFWyEX/0WvZTV+6x7C3l5k9KpkpS01+97VprPyHaa9qGI/LcXBLhv8A4bsYPJu4vU60TYc49cATXQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(23010399003)(376014)(1800799024)(36860700016)(921020)(11063799006)(56012099006)(261021123027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qMmsE4uUT4/wfscg5v1gFM3jzmfAEyR/w36Ai3p9WLhFx5CoTbZxinGezuONxPI2eIITaMkCR9d5NH7TiA3dnD9TvcYOBAnqM+y3SyQo4jDa1a8udbXzS3eZN58nw9jhAf4d03ncsTOQiaSv9JlmgG/zE0YWxxmTHxTMyuqFk19xFwmKkh5+MMKQ2R1t8mZxhpcYcvZNii13nGbBtoShjZ2ZnKkHY4yLdGwEhsV8SpvDz4AggnildI/Y5xW6Y7Y4ra0a4flgUSeqTWqV4YTcpjMONuNHEHacmHSjSiX7+L9ryFFW3erFBzWQDfR14pVSJFgnaimtDDut7Sx6lESfYEJgd83WiYHE/jmbKNdnsods5ypSS7LMnH7Vybi1lzYp1imiaMjzkmQIKxbP4E6Biu41QEJmvdy9jZpAT5s3B0dcTSTkAMPMY/TCEXHed4x0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:32:49.0849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca67b578-80dd-41d6-c18c-08df334c7b6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7665
X-Rspamd-Queue-Id: EFCB5160007
X-Stat-Signature: 33zoberjmqr8yjmri4bpdzw73dubo6r3
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793010804-721418
X-HE-Meta: U2FsdGVkX1/6DsJv5f8lz7jkv1CqnN39TTuNHDla8IsFS5aspWectQ/TkN0BUo9y0dD2RY2SeaN0JT2ZHlL+2FZh5606R2rcEDRk3/ApJeLqiUDmLDbs9Kf5A+0fmZMDCUpCXJ1F0r00MGvdL+TbFmhPg+na0LDUS5Xryyl4TERwiNA1Vfph9Q1GNsID47b5jfQuUPuHB6E7bq7oFqATtmEJSa1230v3TwC85xlUOvjdS8NEryiCSkPJ4Fs2/DCnS8csfQM5A94NYd8xW3LjvsfGWLjQucAIH1F+yF0nnb3HbGBQc0jcdppcVqvwSd4OyvzajF37sHv3toHsCVrcaFL5yeeFjHO2u8wZKA+YNWjJuLZBjKaXiE8kO6+NWlz5CQDWsf10syWLRX2MO34hyrnMim6fmHg4Mw2LVADcXv91yWXCKhy001pxvzyrpA4fv4rBpjUc+g+oM8MY9kdH7SpNYYIt0SY4kSGeUrO7YOJ1UIUuoaN4KC0ZgtlzZQ83pLbHhdTtEODMR8uAuoHtZmWEJM5F9eOqsskwCyPxz8f+4mw3ORoDseTZ0RDb/ctfToyen/kC/eeGE25Fzc805gB5MXSr5jNJf95n7HYFZl0GUFCScMWOAYKyGqKwR9TALhT2FuGduFVHpcaS6TAHfc1HmaDyfyEORE237C7C4d0v+OhhvAnGmKH8U+bnzVYZjSSG0V2x+A52s9Qjwty050GocCjHaWq0oFc6JXZTX7sSo8xkHMaaLaTWbC34xS9revwOA06oNpUUgBpQr8H43W9tTlFjHDsYCqBX1QywpoLcG2QRtIASneJEwlB7lJPLhr7TerI+Ee8y45ALWC+72KqC9ke1Jwg4W/cHk77Fr9sfCbS7IYwbbZGpUYt05b8RJG8g8sevDyS46oOzjVQuJktv+1sgUtG6381mZ3f19Jrxpt3YJVktjUzxfE1xA5ghfCOwQAIzk4yXXAgjMDN
 H38TbNjm
 Wo28gril6p0loymG6jX11S9084KEi5Ytn6U31xggwsh0aHz3BoQGHblrPeADVFzb/fV5cmP0XPdofW1YK7e5hvUTv83B1qrKZbKVxDjeytLSr0Ql8XlXe7FqqeoHrx4911EZhawtnDsb9D8aa1VZ4np46KaQlgIO9+WV0DRxTqH411WS+FlqQYsdK+TtLF8L/fSezYm2CX6g1i1ED/+roa3bsf04Mbr0jOLehISPq1rOzNhK99E6cxT6W+kqqsE48bSCpRfiO3/JAonFn1TAhH3skgCDibk88G1A9pVr4Ccigh6s4SGJOUvGnjn1QVHeflhNEp1mxO7ZuCwdRK7XC5enM6jrBbtvsYN37i7HFBd//IeuTUDQ6jNCMPVxDqCRVdAn46Y5wVgsaAyyjTdP8nioWWvVs4mVIvaJPvxCFbGRUeH9ix8O+eP0whiMNB35Sem2cOptLNdyXAIwTrBwGimX9ViXliZKpfymBzRDBHN+IPGJVbg5kAsWkOx3rGBqORHOw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

heap_stack_gap has been unused since at least the start of git history,
commit 1da177e4c3f4 ("Linux-2.6.12-rc2").

Link: https://lore.kernel.org/linux-mm/20140430083620.GA4711@dhcp22.suse.cz/
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/nommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 91ab65afda70..df8ef1323e18 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -43,7 +43,6 @@
 #include "internal.h"
 
 unsigned long highest_memmap_pfn;
-int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
 

-- 
2.53.0


