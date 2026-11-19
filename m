Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9ACB606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Ak8p7ssa
Received: by kanga.kvack.org (Postfix)
	id CA1B96B05C6; Thu, 19 Nov 2026 02:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75456B05C7; Thu, 19 Nov 2026 02:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF25B6B05C8; Thu, 19 Nov 2026 02:12:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD476B05C6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:12:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF73B4095F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:53 +0000 (UTC)
X-FDA: 85451001426.07.88E0919
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010032.outbound.protection.outlook.com [52.101.193.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8CB79A000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Ak8p7ssa;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.32 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795072370;
	b=liY93DwSi5AKL7uLr+ukLHbjTdOYPQKFvjPBJhXSK3GkgKcIG1I4/IhB3vVECRodN80G+5
	qGp1B4tO9lmK8342A7F3r+v0/ykQ5Pt081QdLGvYMfXF6BpdkcvGGZPdFX0zNU2uzt8u6S
	kqZFkQcziZJd1hC1j+48g7egplLGN4g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjLYXpkqVoz/ejG4D3YMeq61W2B6+uYQ9McMScanRVo=;
	b=isG6gXn9D9Z7v9qMvu5JfHhnwY8R7MNl7N2Tlovh/TdKPnp7EW2yGA/fYvWP6NdzKXFkYE
	y6n98gFkH4jHAorewvqpzY2M/8iYQE8QgO2s/bg2ybRyzbCJsN27Nmfu7kzoBKdmXHQIRk
	BEpluOjbKEDTqK+aYXcszbhHGCkyniA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Ak8p7ssa;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.32 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=drkX4hIvNx+g8fIVXaPPdhKf+VjCJD8+n835U15UAD1mVgexBFCnZJpTaSMcK0M6S5y8U0jUgneLNAAkI4HparEEz4EJp5tW1ySiuFyWmZGE4ea1o06fFu7M0sYEiDXgr+fyEYk9jIoLTKimCCuV8qW9DIELu4Pzln8Ge32SVmalr+7NEIQNviY/n7TOk1DAXRJNyr24WgeUmgZuqP9agnUeEUvWvzo9spVP/t9sJFLq3Q9CFuSXUDlQ5f4C4an7B4uGIvXRJbbajs0mWvsdBbz0pBJwVahOUnXj7SHrWcC4XSkzKwlicCBS008RyGuBcJ6rLyjIHSujoY4ALMvuAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjLYXpkqVoz/ejG4D3YMeq61W2B6+uYQ9McMScanRVo=;
 b=TzO9FiUUCImPpBDf5+tzucRrjq/eAKhWahuf83qM9lrfHUJcvZ+Pp/1rF3EAdFYlVEjefAlwf+b+JXNST66m6dilKcZGUMDFWFO6Ng2ISR6LUSoDJSW7dOd6FgN2gYZ58ZDbQUs2bcgUU+p5iXdgKZ+rvYtBIOnLD9Cwg4kCcIs1jgsZKGVSrd8Ls4YoyHzTuXGjRMdZDcE4rJbFJy40VnkmdP6uq4uleJGl9M8rR/FBVkIRrRfCH2IyPXn0AfHVwbas0kkaVqktB1CkJjBdHzp/fzj53mjpDbuRIlkSOlc8gBXMYbBbGV5G198gRhK1rjHOyoivBNo2PmpU+9D8gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjLYXpkqVoz/ejG4D3YMeq61W2B6+uYQ9McMScanRVo=;
 b=Ak8p7ssa14+sY0aQguJr0wun+tWEPgS6GXyoJrJE0UySLTa+aVUQxELXLOemJkeDOL+NeQ27mQRIFxwCt+I4VtajrUHWKslGQkevxn/QsEzVQ9ZePZZixIf83U4jzXKNjC4ic8rNmVri9h4d97ODMpqNVnYdbTFumcZNrUrh0q8=
Received: from PH7P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::29)
 by PH7PR12MB6977.namprd12.prod.outlook.com (2603:10b6:510:1b7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 07:12:42 +0000
Received: from SJ5PEPF000001E9.namprd05.prod.outlook.com
 (2603:10b6:510:326:cafe::7d) by PH7P220CA0010.outlook.office365.com
 (2603:10b6:510:326::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 19
 Nov 2026 07:12:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001E9.mail.protection.outlook.com (10.167.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 07:12:42 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 01:12:33 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 19 Nov 2026 07:12:00 +0000
Subject: [PATCH v2 5/8] mm/migrate: add a dedicated movable_ops migration
 pass
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261119-migrate-refactor-shivank-v2-5-f4535bd0bc52@amd.com>
References: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
In-Reply-To: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, "Byungchul
 Park" <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	"Lorenzo Stoakes" <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Yiannis Nikolakopoulos
	<yiannis@zptcorp.com>, "Bharata B Rao" <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Huan Nguyen <nhuhuan@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Matthew Wilcox" <willy@infradead.org>, Hugh
 Dickins <hughd@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795072323; l=8586;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=7rrNhxMR4HWx+QmDfRkWIk8JOGmFFE1mY5b53s2AVP4=;
 b=YRnFtavvwjvpINBp7uSodmDnSD9HejGx22GBEXACk7tJV/VDsIgxA+i5uqDxGMCxo4F8RaNiX
 n+6Ei98L/U0DD21pZKbE8UVS84aHIOlHQCscVM5nbydCkh7tEihwGUH
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E9:EE_|PH7PR12MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 892be29a-48d8-4f96-4bb5-08df460c80b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|7416014|376014|1800799024|18002099003|22082099003|261009223027099003|921020|56012099006|11063799006|261021123027099003|10067099003|261026140227099003|261026121527099003|261102123227099003|261028144727099003|261022105027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	uqIOzOzMUDz++mst26MTNagQrr9gQ3OmfT58TiDq3xBgntBcRFWuEYMkLk2ravQCWKCM8PB2VnOv3IruB/s5ofrrh3JPz3I2EqB3sSQVhP7tGcqeMtq9JruziFoGFWYaHVYDNqBNTFMy2d09CkGQI98DfeVgmPeTQXTIMIvBpUodhhg37LLhxnwbghYn6CuxGzruB86JY0TRh+47FWr98QaYq6ri+7Gg3T5Wbk+PEbsIlxdeuZEYub/mPA3IdWoQEVCGT7V4SCJ0uMyOAvWQvuJhYGUfkMufs9N8v+DISryuJoWQg2eMupjqbzUTzdv+R0XpjJpTv00LziYK9DhCS4nd7H9UJ9KIgeoUrUBgE2KWCH6cB6U57hUNz9tuIg6MNHJpU61vg0HJYMCIuIjfipBHm1QIB1mDHEjsGaP6RLekRzKodwu8Nqh7//IVOloYe5qGV7TaF7jGET1XAhYFnkOKbKGpwtLw9JtJqPQU+zAap/3rDBARiEvcHLcxWF2xJWFbQstj1eeuML0+/PWb/9ohCmna4jkXHZj0dvxM/EcWJlUOE0Cxuev+6cX+fGuTuBmdBXR/Wq5QaHoYAQxywqF6H/n/mrCj7Iz89cxnyuB9qQyndUNI53y2q/221iRrQTW7MzFPZ5qIHfeWLV1xzd5xgAgDv5gorlWZxWxCP7hPgvk2bAZBTK++hjZI+UILjpQ72S4sIUEYO5zOyPr0og2yGfLCylsGNmWaeHPQyEqyRDWBLBwLmj+Dao9I+Twk
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(7416014)(376014)(1800799024)(18002099003)(22082099003)(261009223027099003)(921020)(56012099006)(11063799006)(261021123027099003)(10067099003)(261026140227099003)(261026121527099003)(261102123227099003)(261028144727099003)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1ZGCLonWe1wu+lQO+J1IrtsivZRThCsFViEN8W5LXEq2NlhwLmHFcJt+1a/gSxsnoG6TacHfeZnVDj5P3iB/EF6MzH1jqK30Q/Y/cYXS8vaJz+48Xlgk6Z/pwvEshYSkYHO7wbbV34LtMmW+3ZxIEM+murOed7bAlLBG+wsN+AUPK2SQ0Whp3RuwKr2veBGUd5SxdtXuSjKDovl7kbPnWgYtq9Kx+0MyNQu64vqhYfpW98hixeN21y65Gld77djX12mGQBq5HsQ/tlxWt7SfMPzFQmSa03vDcfXXCF0DJpXtS5Co1wOG29/8+X8GstJfkDxKAwJufI73iKpwOVyMoyLV6PL98qIRDHBANyScnemAaXNXmFAmWvJd8YUnk8sAs5wbQ62YQqPw2j+exn2lg0sEqw3jFVPAC/oaqO76KjyIqK9+uAIbs9kFZX6U3qHV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:12:42.1718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 892be29a-48d8-4f96-4bb5-08df460c80b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6977
X-Stat-Signature: y7eo1hurnk7xzuqaqnqamyeebtngaisp
X-Rspam-User:
X-Rspamd-Queue-Id: 8CB79A000A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795072370-565213
X-HE-Meta: U2FsdGVkX1+YxrbtM5+f1MB7koc86y9peur1A6fHdfNS6AbHQ84YkGr2eiQJeWpSmENkqBBkhmdsF+gmPmAXZgug2M8HKqFIWxDKwTN2UPUi0waqweSZMDVk3zN0miCbLBdEe9Ef75RBzgM20iD90YdMN7Gkc6+l2dP7jcqPVM8D1wsCHe8QS3iVUxAwV326WD6eu4fk3TxTtEmaSez5OotCBonYwN0X7zrB12NPc3qzhNVpN/kXihSkdam54cDkr4ejjnWQWMkiUUXGaaQfo214hRrp3K8iEEz3HhdVeEVwTl12T9vx/eWioqvmU2qwnuJSCpN0NBmAHd5g8gNZQTqYaL+fAJP+5qPbfiQC2Eyt6aSVuRexcTLITO+Y0zBMDd/6x4OyRbx9MLHpgKRc/LRHwMg5FvlWnAIchzqgYuRF2tu1LLMxY1rJAJLFDRCNGkJS8nRx6wb2IduMEMqsE1aiGQhtw114yNEFtUlwhLt4PFZrTklriJfu1SylUYg77YJ9d0npTwJbir15VF/zO13epASx+LluHN127nm2vO81mRZDtCqjatIjmGSrHI49Vk0YPKMXT9OsWAEo04xXSESNqWHX4PJDwhNjo3Dl3VrbZqw3iJAp5g8G+/laH4cDYz5x1vXJd6V9j93IRHoxoU8S6WATw/acp5hilf/SfM7J4coAp4emrdg5aOmQDGmPPEfrVHS7/KVbzyjsywuZOby4xWYQVaIhLUKY9lFf4YFWVcQQm/jsknBNdC3dWADFPJVuEaiGZiQd12r7r5PaJzvWxBDH/P/slUA7V0VeEt+TQnN/I4V8LIQaHZkGnpkbR4kRxr6F2jJxHfkSQoLgeZ2Mt0QI68coHIzlYjDi0RYD0gcfnUr6c62WDlzzZ9WDkbz704A6buMon20fS5FHb+KapqUKI/6dMaTTUe55Sw/ND5IMEKXqaPd36atXTI7SLbxF9t+63gpRq1SMQbF
 CvLz8Zuh
 y1yCz0j4AS0TJCulA9/Y+LWPfz/G9QktGCNMAz308LDEorYWehsSdCXreCjvFobhsu1I4CgyWx/7uxRvHBSH6ruFuqJhkC3ihMtcNAj3nnUlLlCDRbiDn/kXNhu4uMfAU+UZRnapRpzKn9+iqC/yTmrfn6ePdEmqJBUXKKgXmETsnpp4/b6zNxObG5EzEKMCq/u9Targ7N4lIMkDGShizpjkrsFzclSs8rgEhfTew6HNx6kDR6huB5oz5ASk2M2zNhblcBxe8I3nnIXnVtHEhTylPBxpBIhqmQzdDVGTz6D5itiKsNpsg/Dzvcek9vba8bdf6kAxPNDY6ZIoYlTCUMxgPaAVbBAZ0g83wKs7nxLeq4A6+w6srhwqfEGxJdhAJ6Z3TN9Slv2/EdOqEabPAfxvSXI0YaNyy9o+1IavfmgscNY8BWWngoR7F716oQ+tiRwHiOnSr6UKk6XA+pl22LX8prCsB/wOajT43aKy4hqdl+w+62YjkU6z/8icsmUGvBPtZcdWmfu1kSkP+4KAXVQgfPtk7H3XnsrrEfQCF5Ar+mrnNYBXEcoYkJAj4gAGsJ+nl7VpJCU8S8mv1wVzTqPNM7QzYejJn1ST+gCw8mVIGabFexz3YR4G4As7kfLdCmZKdDETe70lodo4WDLtNwS0tOzqHATVah2dG4SS1vpOx2dm+d6h+jFrFcxkWHPsjGOEOGCu3/G3+PwS1rtkgdlJb8qGCvtDMEryXdu+gn8xR+gzd4kU++yr9ryV+irXfmZILvttUnGyZVFbrEADbdpATtSc67MIMkj8B4k98h6RW7Zwa9vzJls8HX0FFbKo3OdcvH9NZiXa1MMdi8ykNGykNhDiPsSwjVdLqWuh0f3sYY6N2rNu+kwCV8cNcNxXBhHKi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pages with movable_ops transfer ownership through a driver callback and do
not need the unmap, TLB flush, copy, or LRU handling used for LRU folios.
These pages are expected to stop being represented as folios. Separating
their migration from the LRU folio path prepares for that conversion.

Move movable_ops pages to their own list in migrate_pages(), next to
hugetlb folios, and migrate them in migrate_movable_ops_pages() before the
LRU folios. The new pass handles allocation, locking, retries and cleanup
itself; pages that are not migrated are returned through the source list
as before. Remove the now-unreachable movable_ops branches from the LRU
path.

This changes three details of movable_ops migration:
 - Pages are processed before LRU folios rather than in source-list order.
 - Synchronous callers use the requested mode from the first attempt
   instead of the LRU asynchronous pre-pass.
 - A callback returning -EAGAIN ends the current attempt: both page locks
   are dropped and the destination is released, so a later retry
   allocates a fresh one.

The MIGRATE_SYNC_LIGHT !folio_test_uptodate() check is not carried over:
PG_movable_ops shares its bit with PG_uptodate, so it never fired for
these pages.

Suggested-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 152 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 135 insertions(+), 17 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 3dfdf46681e3..bfd38e6339cf 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1233,7 +1233,7 @@ static void migrate_folio_undo_dst(struct folio *dst, bool locked,
 static void migrate_folio_done(struct folio *src,
 			       enum migrate_reason reason)
 {
-	if (likely(!page_has_movable_ops(&src->page)) && reason != MR_DEMOTION)
+	if (reason != MR_DEMOTION)
 		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
 				    folio_is_file_lru(src), -folio_nr_pages(src));
 
@@ -1342,11 +1342,6 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		goto out;
 	dst_locked = true;
 
-	if (unlikely(page_has_movable_ops(&src->page))) {
-		__migrate_folio_record(dst, old_folio_state, anon_vma);
-		return 0;
-	}
-
 	/*
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
@@ -1409,13 +1404,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
-	if (unlikely(page_has_movable_ops(&src->page))) {
-		rc = migrate_movable_ops_page(&dst->page, &src->page, mode);
-		if (rc)
-			goto out;
-		goto out_unlock_both;
-	}
-
 	if (folio_order(src) > 1 &&
 	    !data_race(list_empty(&src->_deferred_list))) {
 		src_deferred_split = true;
@@ -1451,7 +1439,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	if (old_folio_state & FOLIO_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
-out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);
 	/*
@@ -1844,6 +1831,124 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	}
 }
 
+/*
+ * Migrate one isolated movable_ops page. Keep @src on its list for retry and
+ * move it to @ret_folios on permanent failure.
+ *
+ * Return 0 on success or a negative error.
+ */
+static int move_movable_ops_page(struct folio *src,
+		new_folio_t get_new_folio, free_folio_t put_new_folio,
+		unsigned long private, enum migrate_mode mode,
+		enum migrate_reason reason, struct list_head *ret_folios)
+{
+	struct folio *dst;
+	int rc = -EAGAIN;
+
+	dst = get_new_folio(src, private);
+	if (!dst)
+		return -ENOMEM;
+
+	if (!folio_trylock(src)) {
+		if (mode == MIGRATE_ASYNC)
+			goto out_put_dst;
+		/*
+		 * As in migrate_folio_unmap(), direct compaction must not
+		 * sleep on the page lock.
+		 */
+		if (current->flags & PF_MEMALLOC)
+			goto out_put_dst;
+		folio_lock(src);
+	}
+
+	if (unlikely(!folio_trylock(dst)))
+		goto out_unlock_src;
+
+	rc = migrate_movable_ops_page(&dst->page, &src->page, mode);
+	folio_unlock(dst);
+	if (rc)
+		goto out_unlock_src;
+
+	folio_set_owner_migrate_reason(dst, reason);
+	/* Drop migration's reference after transferring ownership to dst. */
+	folio_put(dst);
+
+	list_del(&src->lru);
+	folio_unlock(src);
+
+	if (reason != MR_MEMORY_FAILURE)
+		folio_put(src);
+
+	return 0;
+
+out_unlock_src:
+	folio_unlock(src);
+out_put_dst:
+	if (put_new_folio)
+		put_new_folio(dst, private);
+	else
+		folio_put(dst);
+
+	if (rc != -EAGAIN)
+		list_move_tail(&src->lru, ret_folios);
+
+	return rc;
+}
+
+/*
+ * Migrate the movable_ops pages on @from, trying each page up to
+ * NR_MAX_MIGRATE_PAGES_RETRY times.  Permanent failures are moved to
+ * @ret_folios; any other page that was not migrated stays on @from.
+ * movable_ops pages are order-0, so each failure is one failed page.
+ *
+ * Return the number of failed pages, or a negative errno.
+ */
+static int migrate_movable_ops_pages(struct list_head *from,
+		new_folio_t get_new_folio, free_folio_t put_new_folio,
+		unsigned long private, enum migrate_mode mode,
+		enum migrate_reason reason, struct migrate_pages_stats *stats,
+		struct list_head *ret_folios)
+{
+	int retry = 1;
+	int nr_failed = 0;
+	int pass;
+	struct folio *folio, *folio2;
+	int rc;
+
+	for (pass = 0; pass < NR_MAX_MIGRATE_PAGES_RETRY && retry; pass++) {
+		retry = 0;
+
+		list_for_each_entry_safe(folio, folio2, from, lru) {
+			cond_resched();
+
+			rc = move_movable_ops_page(folio, get_new_folio,
+						   put_new_folio, private,
+						   mode, reason, ret_folios);
+			switch (rc) {
+			case -ENOMEM:
+				/* Count this page and those awaiting retry. */
+				stats->nr_failed_pages += 1 + retry;
+				return -ENOMEM;
+			case -EAGAIN:
+				retry++;
+				break;
+			case 0:
+				stats->nr_succeeded++;
+				break;
+			default:
+				nr_failed++;
+				stats->nr_failed_pages++;
+				break;
+			}
+		}
+	}
+	/* Count pages that exhausted the retry limit. */
+	nr_failed += retry;
+	stats->nr_failed_pages += retry;
+
+	return nr_failed;
+}
+
 static int migrate_folio_split_on_alloc_fail(struct folio *folio,
 		struct list_head *split_folios, enum migrate_mode mode,
 		enum migrate_reason reason, struct migrate_pages_stats *stats)
@@ -1969,8 +2074,7 @@ static int migrate_folios_unmap(struct list_head *from,
 			 * If we are holding the last folio reference, the folio
 			 * was freed from under us, so just drop our reference.
 			 */
-			if (likely(!page_has_movable_ops(&folio->page)) &&
-			    folio_ref_count(folio) == 1) {
+			if (folio_ref_count(folio) == 1) {
 				folio_clear_active(folio);
 				folio_clear_unevictable(folio);
 				list_del(&folio->lru);
@@ -2182,6 +2286,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	struct folio *folio, *folio2;
 	LIST_HEAD(folios);
 	LIST_HEAD(hugetlb_folios);
+	LIST_HEAD(movable_ops_pages);
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(split_folios);
 	struct migrate_pages_stats stats;
@@ -2190,9 +2295,12 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 
 	memset(&stats, 0, sizeof(stats));
 
-	list_for_each_entry_safe(folio, folio2, from, lru)
+	list_for_each_entry_safe(folio, folio2, from, lru) {
 		if (folio_test_hugetlb(folio))
 			list_move_tail(&folio->lru, &hugetlb_folios);
+		else if (page_has_movable_ops(&folio->page))
+			list_move_tail(&folio->lru, &movable_ops_pages);
+	}
 
 	rc_gather = migrate_hugetlbs(&hugetlb_folios, get_new_folio,
 				     put_new_folio, private, mode, reason,
@@ -2200,6 +2308,15 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	if (rc_gather < 0)
 		goto out;
 
+	rc = migrate_movable_ops_pages(&movable_ops_pages, get_new_folio,
+				       put_new_folio, private, mode, reason,
+				       &stats, &ret_folios);
+	if (rc < 0) {
+		rc_gather = rc;
+		goto out;
+	}
+	rc_gather += rc;
+
 again:
 	nr_pages = 0;
 	list_for_each_entry_safe(folio, folio2, from, lru) {
@@ -2246,6 +2363,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	 * will be put back to the right list by the caller.
 	 */
 	list_splice_tail(&hugetlb_folios, &ret_folios);
+	list_splice_tail(&movable_ops_pages, &ret_folios);
 	list_splice(&ret_folios, from);
 
 	/*

-- 
2.53.0


