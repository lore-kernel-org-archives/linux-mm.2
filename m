Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576FE606A8AB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=q1K344jx
Received: by kanga.kvack.org (Postfix)
	id 749EA6B05B9; Tue, 17 Nov 2026 02:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721676B05BA; Tue, 17 Nov 2026 02:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637506B05BB; Tue, 17 Nov 2026 02:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 323916B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:17:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63001140313
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:17 +0000 (UTC)
X-FDA: 85443754914.13.3E8931E
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013069.outbound.protection.outlook.com [40.107.201.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1FAEC100003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=q1K344jx;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.69 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794899834;
	b=nbov+oV3muuHi4FX9DHyR/oafObgGUxEi0rU/UDR/g/z70OwMxLxr6uZXCe0ORGom7+INi
	OxiXrHRYVr+W7FPa4jERgzpOEabB2v40/XIfyOFj8gDKYwwSwIZ/jR1Sz5NFgPCLxJXdfM
	Uf5xSqQXlfgrOQxd1obQmvs+9jGVVUY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=q1K344jx;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.69 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+xV+Q/FmcEg+DznkN+seFJKIAO0Dys4NqSGGXgUOSug=;
	b=YRCCE/0nSLyhh7TDD6oibEI+TnI4sPhbq/U1xriQI0I+93apITqI715uLK50GsCEUUQn96
	thgxowJ7RveBxDPaErkTY/84DgtA5tvAF0Nb2JhV5qGMuo5MPmOEhIZgwkWuxtVzkjLpqA
	FYANn5silC4nO0bQ8i/glpWSrtDxe8E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u5s/HWUAXQvjamLaRznlhCiI1Eohpv+X6CoF4kPnHFuc4awZXUB+owgJd+XMJ1HgvYm87j944A0WtMtGRml2qjPNT5mD3XuRLZbdmFlG/cpG30n1m1/9xlacMFuFBcwhABmOCB7GaJt6TOxF9M4H24NTSz0UGHsIv80OlCr4s/oaabTVhSK0oYPQtsLJAOHNWtP/ymoEiP+8gc4MrK+iy9HsXOXuW1tSWEw5S53Bxub6xITy/iXi7U17ZLBuUk8Buv4sprYyMRNoLx/Gk8m15iZHhDPATbzugb7q/TmooyLt1VmLWQlAj+11rE9uPqxux6sDKh81LbfT3iIriVq0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xV+Q/FmcEg+DznkN+seFJKIAO0Dys4NqSGGXgUOSug=;
 b=TQlOz0ut8/G8BxbuaBaEhgcN2Ji90zJi/qkRMXnN7B6NsQAFs8o0Nb/Y2tsHfw/hUaMvoWOfmJqf93UiGNvwgxex+OnlWRMc0g+HgcYawakMI0SJ/zE4Y/A+Z8Tl9F7r8/ed1dN4WCzyMLpkh76eZZG/dpG5COC9gprPwpL6M6rpJNRdPsKbpa1RdKltP+rbIRr+cfLHBhWk9GO2DipWWFLlxRogLSVzwahjAyTSPLVlpfeke1/EbdATVggFiIoLUHnSgXrqYbxgDwsla42YZt21pP7tSAJ8pZzVQ48vlMw0e2lxu5WvdcrClCS1+3hqCxEDdCAukD3owbIfWg+KCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xV+Q/FmcEg+DznkN+seFJKIAO0Dys4NqSGGXgUOSug=;
 b=q1K344jxMC6hBDh96wOmu4oO2p2CiySHm4XgK9dBBVBmpkygIk8YdvQ2HtoxOMirZcOl9rk4XcvWoDp9P9qF0dxe0Z0dl4wibIJDMfQRob3O3kQXi55r9nHw5hsZBaWwdtBn2k1ykeABFoPxkY6dabho5ZUmOI/3z4pkDGAenNA=
Received: from CH3P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::19)
 by MN2PR12MB4422.namprd12.prod.outlook.com (2603:10b6:208:265::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 07:17:08 +0000
Received: from CH7PEPF00000015.namprd21.prod.outlook.com
 (2603:10b6:610:1e8:cafe::4d) by CH3P220CA0008.outlook.office365.com
 (2603:10b6:610:1e8::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue,
 17 Nov 2026 07:17:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH7PEPF00000015.mail.protection.outlook.com (10.167.244.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Tue, 17 Nov 2026 07:17:07 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 01:17:01 -0600
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH mm-new v2 0/5] mm: remove unused functions
Date: Tue, 17 Nov 2026 07:16:47 +0000
Message-ID: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MSQqAMAwAvyI5G9CqdfmKeBAbNYdWaXCj+HeLx
 2GYCSDkmQS6JICnk4U3F0GlCUzr6BZCNpFBZUrnedbi4Q4hg/JYtBabeax1qVVVFwSx2T3NfP+
 /HqJ3dMHwvh/93C6dZwAAAA==
X-Change-ID: 20261109-unused-sym-mm-8fa76462573e
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794899821; l=1262;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=9cQhrJlly/ClG37s4BEv1CH0T39zF1bHVJy1LWjiDOA=;
 b=th6hHOvFrEmqdr7Z4/7jLH2lvS2jUjI2hI1jhBhntNeSKVC+1vgstOoRc9zCHNMyJGlBqC58N
 02u3v1K2OtvAYFmkRAo0/2mgYz6kwPwQ+bHYn/Fjz44B+iAtxTsMtIc
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH7PEPF00000015:EE_|MN2PR12MB4422:EE_
X-MS-Office365-Filtering-Correlation-Id: c53d4ffc-9ee7-43e1-638d-08df447aca14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|36860700016|82310400026|921020|11063799006|56012099006|261026140227099003|261028144727099003|10067099003|261021123027099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|18002099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	dAByAkezUlZesjhhzopVkRn7jxXkDm2Yr6qxPX5XVjp3nh7iu06evsLj/bSuvyrwfnYQT+vOZnfnuE2bi/AjlIC/fqmVD/pLsg6KrnlETUSOOAfIUKkAmxGgRVMhIvKvQDoknmH4aCut4yCIylgh94wyhdDCUvOexDSiHpcrMKO97XiYnJmBoKOw5oBC5qoUuUkGpnJvGh5afPP1bbKbITs5cUWytAzeMg9bZkKJB47sCjcznTYn1kqt0TAnbDFm3a0RmFogJZLiY9bUDTm8kUHgU6vzWf7h2t143cGDeqnoIz2EVzfvnkSwtpFmcg5+A5C5G/3j9H2dl9dcyp470fiQ5Eizkn89RqpovH6BrSOnfTSptROb6ASoSL5Sm37ur2KcOcSAkTHi0dJEl6lxFDudWJ8wA8Lu0kb6BnoFy35EscGag59mHjQCUqP+V79nGUF962KBCyX6kslw11MJ79VXun39PP5UX3pOx8H8zVi4julyHaVEADsrqhSEhuUfwVVVu0vvRVVP/uVRAwaTN7cCrASBVsrX7CNctRSBy/PYhMkeqM9P6V4OdULTQCnxQku7UwztJ2aqNJ6l+99DBj9gqqR7fuKhwBfxVAse3jALPsz5SqUE+Dd+GoBuC85nd5VIJynY+F/GRiW5OsSo8QHPVfe5044HiQODPTkmzgG8h3Z95oiAVw3C/4myN8b2CbrUth/Fj0GdYVwjXe4Mqg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(36860700016)(82310400026)(921020)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(10067099003)(261021123027099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	R9tMzjEudz1Q/wQ+CNRd1ZqgEP2avBUzCXtbhsD/z4IGzdmu0bxSzYqPFKL8qKctD10eQvbltTA/WCp35/gS5xJp2QMt/PpP8SIlqjA6xOvd/IWsVU9crsmj4fQyaY+XZCjPySZ/jo1AKjtjmQZKB+CpXXxO9UP2nSsD+XxvX7slEMmnNu5qBRa6jp9SRb7BsS5hMxnKaPuDWa25+1huaAIYOCRqSilINyl1jV/vcg0MUhEhutidQoVygfJeTB8Unk+n5k3psEtrTHW6PqqYcG1rH2abxoEiCEhhaKCAp3kWrrpVrhZrxum2a/vfRn7rffNHgVV2UULojIfr82RzPJT+zDWjA4Gw3Slm3ivQX3zHnxNKGcqUUw0fGhm1NZxq2yB91qNxlClCbSQViPRyEeMN1EuGRXKFkHmgbJAykUvKoy+9lQldg/9xVWViR7fL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 07:17:07.6381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c53d4ffc-9ee7-43e1-638d-08df447aca14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH7PEPF00000015.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4422
X-Stat-Signature: e96ni6awwepek4jj9cm3db9spke8xi6i
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FAEC100003
X-HE-Tag: 1794899833-844495
X-HE-Meta: U2FsdGVkX1/agj6psYpnyGziO6teSTr78Okgk5BwGgw9gWUt0AUDYbSZ92YAJenQyFMDsKJhimU2Do8zn28ys8B+pGND/g+Ib8YQIT6M/a9eltTe1HSp37i+gOJrkVZlwK7VLF5GzQ8y1opc0GOIUeO3ZZTeBxpmCdSmkwhqHYOaivaPv/vNeh1uV3ACzByzfmue2eK5hv+ZJTKpqcS86y8M4pqh0AgXmT1KGMD9JdqAnl9yY4HpJErSSGTR6+5itCRl0BJcdgM8IUqweQE1f3EcTxfI8T6GdPQXdQTJXplmLUxVwkpkPHFT6dB3V0l587JZnCTdg4bn4Ma0CF9od09MbCPeaw4H3f9TaRNqh6830bROVjKJckGxvcauxjCuvqUBnezy40YqPJ9eZhFKL6wqnM3wIdkLQ0/RtWfjdfZRs1FGBDlJwj6jjyUfZVQESKGSSV6jybC3tPgZnOf5qGlx4IgpryLH24pXGyBaSa1POlsp0wgz6fJMuYohkLE3RXcgGFqCdhmOPjH1jIWZaGKQx3KDIylglNGcZCRaFiOhpzd8BUnvR3PH1UVoyDBybQBI5H8aCj+31DdEX9YmM3AVw0lEDj5aFFVz7AmSg5t3hEPCUulOOp4QA22qjTZXdRri5v8Zpjmc9hx+CaxePo35Ztpa1yv1E7K7PYZ14Oe0sIkqwKIR6kLD85mIAG2W8KD0N/n1R/sFxMvPIYjARW6YiaSjN23WFmojfrDyNPXyyn4RxB8YlQH+fZOG70Tdyh0OnpmmFNjKMBYVEND26f6V/rsrZVM8QV57xaQaH3Smt4r/CUyddvilcO7XsnH57U9LPc1ZY3qqXgbjx+1CBZvEO74P32WAW0Hs1b+h2OgIAQsJ7bJG2kw/QCPlIEI9Dk92ej/DqU31Xqv3lCEWGjQc16CwSVro2Vch1bSwjjypWaEYSi9c34xYFnS2/rDOzQQEXbsVbVKgLc3+ja2
 xX/T3p7r
 pGi18g1rQ6iIw3+wJiq46vtoETnkPpjhVPfWVjL+taM++gFbbjDe1IkOatTk/BDJ0NG8PH0LfmfTkskRHLHasFBhnpaKYBA4se/g6xagwNTlf7hZsGoYHgKvtBvL/nTkTC8VWwUE5NEmf+G6ibnahxjT922CgO6hYF37YeguA0HLphyW9lXzZYvLGNDas1K2gJSmweKqCkdfid18W3B7I/c//ujIM6szJFdlvTgrH/P7ka9hIIrUrquYJext0MRsrYms+i48G9zdi7vGgpNVi8N49h77n7smbgrQr/+PKTuDJ8Xo+QRn8zc1P/4AkIVYo+z1PeobpdTUGPV8DZlV7dX1W3DEHQccCDPY1cmVcSHml1O7F+fBbqV5BdRCjx3M+9Y7wwNJ/25n7k7HQTpmof7WnLf9UwGDY8drPLmPUn2jPRLR+tDGMpvHheI9/IQTTt0EHiNMR+kLuyh8guPhwPAobQPPSo6p1x9HtXeG7aenB1tCpa6691H2BS+gt6XqKqY3K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series removes five functions and one variable in mm that have no
users left anywhere in the tree. I found them with the kunused scripts
[1], which I wrote with LLM's help. The v1 cover letter [2] has more
details on the scripts and how LLM was used.

Changes in v2:
- Split v1 [2] up by MM tree, as David suggested. These five patches
  are based on mm-new. 
- No changes to the patches themselves.

[1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
[2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Shivank Garg (5):
      mm: remove unused helpers from pagemap.h
      mm/swapops: remove unused make_guard_swp_entry()
      mm/swap: remove unused folio_to_swp_tb()
      mm/zsmalloc: remove unused zpdesc_lock()
      mm: nommu: remove unused heap_stack_gap

 include/linux/pagemap.h | 11 -----------
 include/linux/swapops.h |  5 -----
 mm/nommu.c              |  1 -
 mm/swap_table.h         |  5 -----
 mm/zpdesc.h             |  5 -----
 5 files changed, 27 deletions(-)
---
base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
change-id: 20261109-unused-sym-mm-8fa76462573e

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


